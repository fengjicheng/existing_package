*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SAP_CWS_SHPD_FROM_F00 (Include Program)
* PROGRAM DESCRIPTION: For print media at Wiley, all journals are initially
* shipped directly from a third party distributor, therefore the distributor
* address will be used. The distributor for each journal will be designated
* as the fixed vendor on the source list. From the source list we will pull
* the fixed vendor and send the address of the vendor as the “ship-from”
* for that product.
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   02/08/2017
* OBJECT ID:  I0322
* TRANSPORT NUMBER(S):  ED2K904348
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_LAST_RUNDATE
*&---------------------------------------------------------------------*
*       Subroutine to fetch Last Rundate
*----------------------------------------------------------------------*
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K906016
*** REFERENCE NO:  JIRA Defect# ERP-2029
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-11
*** DESCRIPTION: To ensure that any change to fixed vendor also Idoc needs
* to be triggered.
***------------------------------------------------------------------- *
FORM f_fetch_last_rundate.

  CONSTANTS : lc_param1 TYPE rvari_vnam VALUE 'PARAM1', " ABAP: Name of Variant Variable
              lc_param2 TYPE rvari_vnam VALUE '001'.    " ABAP: Name of Variant Variable

*--------------------------------------------------------------------*
*    W O R K - A R E A
*--------------------------------------------------------------------*
  DATA: lst_time_range     TYPE ty_uzeit,
        lst_zcaint_lastrun TYPE ty_zcaint,
        lst_date_range     TYPE ty_datum.


*Selecting data from ZCAINTERFACE table
  SELECT SINGLE mandt  " Client
                devid  " Development ID
                param1 " ABAP: Name of Variant Variable
                param2 " ABAP: Name of Variant Variable
                lrdat  " Last run date
                lrtime " Last run time
    FROM zcainterface  " Interface run details
    INTO lst_zcaint_lastrun
    WHERE devid = c_devid
    AND param1 = lc_param1
    AND param2 = lc_param2.

  IF sy-subrc IS NOT INITIAL.
    v_flag = abap_false.
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    v_flag = abap_true.
    lst_date_range-sign    = c_sign.
    lst_date_range-option  = c_opti_bt.
    lst_date_range-low     = lst_zcaint_lastrun-lrdat.
    lst_date_range-high    =  sy-datum.
    APPEND lst_date_range TO  i_date_range.
    CLEAR lst_date_range.

    lst_time_range-sign   = c_sign.
    lst_time_range-option = c_opti_bt.
    lst_time_range-low    = lst_zcaint_lastrun-lrtime.
    lst_time_range-high   = sy-uzeit.
    APPEND lst_time_range TO  i_uzeit.
    CLEAR lst_time_range.
  ENDIF. " IF sy-subrc IS NOT INITIAL

  CLEAR: v_datum,
         v_uzeit.

  v_datum = sy-datum.
  v_uzeit = sy-uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIABLES
*&---------------------------------------------------------------------*
*       Clear Global variables
*----------------------------------------------------------------------*

FORM f_clear_variables .

  CLEAR : i_date_range,
          i_uzeit,
          i_idoc_control,
          i_edidd,
          st_edidc,
          st_edidd,
          st_idoc_control,
          st_shpd_cws,
          v_flag,
          v_datum,
          v_uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LAST_RUN_DAT
*&---------------------------------------------------------------------*
*       Subroutine to update the Last Run date and Time
*----------------------------------------------------------------------*

FORM f_update_last_run_dat.

  DATA:       lst_zcaint_lastrun TYPE zcainterface. " Interface run details

  CONSTANTS : lc_param1 TYPE rvari_vnam VALUE 'PARAM1', " ABAP: Name of Variant Variable
              lc_param2 TYPE rvari_vnam VALUE '001'.    " ABAP: Name of Variant Variable

  CLEAR lst_zcaint_lastrun.
  lst_zcaint_lastrun-mandt   = sy-mandt.
  lst_zcaint_lastrun-devid   =  c_devid.
  lst_zcaint_lastrun-param1  =  lc_param1.
  lst_zcaint_lastrun-param2  =  lc_param2.
  lst_zcaint_lastrun-lrdat   =  v_datum.
  lst_zcaint_lastrun-lrtime	 =  v_uzeit.

* Enqueue cust table lock object
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true
      mandt             = sy-mandt
      devid             = c_devid
      param1            = lc_param1
      param2            = lc_param2
      x_devid           = abap_true
      x_param1          = abap_true
      x_param2          = abap_true
      _scope            = c_scope_enq
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2.
  IF sy-subrc IS INITIAL.
    TRY.
        MODIFY zcainterface FROM lst_zcaint_lastrun.
      CATCH cx_sy_dynamic_osql_error.

        CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'
          EXPORTING
            mode_zcainterface = abap_true "'X'
            mandt             = sy-mandt
            devid             = c_devid
            param1            = lc_param1
            param2            = lc_param2
            x_devid           = abap_true "'X'
            x_param1          = abap_true "'X'
            x_param2          = abap_true "'X'
            _scope            = c_scope_deq.

        MESSAGE e133(zqtc_r2). " Table Update Failed !
    ENDTRY.

* Dequeue cust table lock object
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'
      EXPORTING
        mode_zcainterface = abap_true "'X'
        mandt             = sy-mandt
        devid             = c_devid
        param1            = lc_param1
        param2            = lc_param2
        x_devid           = abap_true "'X'
        x_param1          = abap_true "'X'
        x_param2          = abap_true "'X'
        _scope            = c_scope_deq.

  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIAL_LOAD_DETAIL_FETCH
*&---------------------------------------------------------------------*
*       Initial data loading
*----------------------------------------------------------------------*

FORM f_initial_load_detail_fetch .

  DATA :   li_eord_ph  TYPE tt_eord_ph,
           li_ph_fin   TYPE tt_ph_fin,
           li_adrc_ph  TYPE tt_adrc_ph,
           li_lfa1_ph  TYPE tt_lfa1_ph,
           li_issn_ph  TYPE tt_issn,
           li_bezei_ph TYPE tt_bezei.

*--------------------------------------------------------------------*
*  Logic to retrieve distributor address for physical products:
*  Distributor Address from Source list for all level 2 journals.
*  Will need to link level 2 to level 3 to get source list data
*--------------------------------------------------------------------*
  PERFORM f_fetch_int_ph CHANGING li_eord_ph
                                  li_ph_fin
                                  li_lfa1_ph
                                  li_adrc_ph
                                  li_issn_ph
                                  li_bezei_ph.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POST_IDOC
*&---------------------------------------------------------------------*
*       Idoc Posting with the Control and Data Records
*----------------------------------------------------------------------*

FORM f_post_idoc USING fp_st_edidc TYPE edidc " Control record (IDoc)
                       fp_i_edidd  TYPE edidd_tt.

  DATA lv_msg           TYPE string.

  CONSTANTS  lc_seg_cws TYPE edilsegtyp VALUE 'Z1QTC_SAP_CWS'. " Segment type

  CLEAR lv_msg.
  READ TABLE fp_i_edidd TRANSPORTING NO FIELDS
                        WITH KEY segnam = lc_seg_cws.

  IF sy-subrc IS INITIAL.

    CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
      EXPORTING
        master_idoc_control            = fp_st_edidc
      TABLES
        communication_idoc_control     = i_idoc_control
        master_idoc_data               = fp_i_edidd
      EXCEPTIONS
        error_in_idoc_control          = 1
        error_writing_idoc_status      = 2
        error_in_idoc_data             = 3
        sending_logical_system_unknown = 4
        OTHERS                         = 5.
    IF sy-subrc <> 0.

* Implement suitable error handling here
      MESSAGE ID sy-msgid
      TYPE sy-msgty
      NUMBER sy-msgno
      INTO lv_msg
      WITH sy-msgv1
           sy-msgv2
           sy-msgv3
           sy-msgv4.

      ROLLBACK WORK.
    ELSE. " ELSE -> IF sy-subrc <> 0

* Apply Commit work
      COMMIT WORK AND WAIT.
      v_idoc_prc = abap_true.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF sy-subrc IS INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELTA_LOAD_DETAIL_FETCH
*&---------------------------------------------------------------------*
*  Delta Load Fetching
*----------------------------------------------------------------------*

FORM f_delta_load_detail_fetch .

  DATA : li_ph_crt  TYPE tt_ph_crt.

* Selection and populating the fields in the segment in IDOC for Physical Products.
* Scenario 1 : Trigger interface when New Source List is created for material with pub date within 30 days
* Scenario 2 : Trigger interface when a distributor (fixed vendor) on a source list with pub date within 30 days is changed
  PERFORM f_source_list CHANGING li_ph_crt.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTROL_DATA
*&---------------------------------------------------------------------*
*       Populate Control record for IDOC
*----------------------------------------------------------------------*

FORM f_control_data CHANGING fp_st_edidc TYPE edidc. " Control record (IDoc)

  CONSTANTS :
* Direction of Idoc
    lc_direct_out TYPE edi_direct VALUE '1', " Direction for IDoc
* SAP Value
    lc_sap        TYPE char3      VALUE 'SAP', " Sap of type CHAR3
* Partner type
    lc_partyp_ls  TYPE edi_sndprt VALUE 'LS'. " Partner type of sender

*Direction ( 1 : Outbound Idoc)
  fp_st_edidc-direct = lc_direct_out.

* Receiver Port
  fp_st_edidc-rcvpor = p_rcvpor.

* Receiver partner type
  fp_st_edidc-rcvprt = p_rcvprt.

* Receiver partner number
  fp_st_edidc-rcvprn = p_rcvprn.

* Sender port
  CONCATENATE lc_sap
              sy-sysid
              INTO fp_st_edidc-sndpor.

  CONDENSE fp_st_edidc-sndpor.

* Sender partner type
  fp_st_edidc-sndprt = lc_partyp_ls.

* Sender partner number
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_st_edidc-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.

* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.

    CLEAR fp_st_edidc-sndprn.

  ENDIF. " IF sy-subrc IS NOT INITIAL

* Message type
  fp_st_edidc-mestyp = c_msgtyp.

* Idoc Type
  fp_st_edidc-idoctp = c_idoctp.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_NEW_SOURCE_LIST
*&---------------------------------------------------------------------*
*       Physical Products : Trigger interface when New Source List is
*       created for material with pub date within 30 days
*----------------------------------------------------------------------*

FORM f_source_list CHANGING fp_li_ph_crt TYPE tt_ph_crt.

  DATA : lv_add_date     TYPE begda,                          " Start Date
         lv_sub_date     TYPE begda,                          " Start Date
         lc_ph           TYPE ismmediatype VALUE 'PH',        " Media Type
         lc_me01         TYPE cdtcode      VALUE 'ME01',      " Transaction in which a change was made
         lc_i            TYPE cdchngindh   VALUE 'I',         " Application object change type (U, I, E, D)
         lc_u            TYPE cdchngindh   VALUE 'U',         " Application object change type (U, I, E, D)
         lc_fname        TYPE fieldname    VALUE 'FLIFN',     " Field Name
         lc_fname_lifnr  TYPE fieldname    VALUE 'LIFNR',
         lc_key          TYPE fieldname    VALUE 'KEY',       " Field Name
         lc_objcls       TYPE cdobjectcl   VALUE 'ORDERBUCH', " Object class
         lst_object_dtls TYPE ty_obj_dtls,                 "Insert Defect 2029
         li_object_dtls  TYPE TABLE OF ty_obj_dtls,        "Insert Defect 2029
         li_mdprod_jpt   TYPE tt_ph_crt.

  CONSTANTS : lc_hlvl_01 TYPE edi_hlevel    VALUE '01',   " Hierarchy level
              lc_zssn    TYPE ismidcodetype VALUE 'ZSSN'. " Type of Identification Code

  SELECT     h~objectclas,                        "Object class
             h~objectid,                          "Object value
             h~changenr,                          "Document change number
             h~udate,                             "Creation date of the change document
             h~utime,                             "Time changed
             h~tcode,                             " Transaction in which a change was made
             p~tabname,                           "Table Name
             p~tabkey,                            "Changed table record key
             p~fname,                             "Field Name
             p~chngind,                           "Change Type (U, I, S, D)
             p~value_new,                         "New contents of changed field
             p~value_old                          " Old contents of changed field
        FROM cdhdr AS h
  INNER JOIN cdpos AS p
          ON ( h~objectclas EQ p~objectclas       "Object class
         AND h~objectid     EQ p~objectid         "Object value
         AND h~changenr     EQ p~changenr )       "Document change number
        INTO TABLE @DATA(li_objects_crt)
       WHERE h~objectclas  EQ @lc_objcls
         AND h~udate       IN @i_date_range       "Creation date of the change document
         AND h~tcode       EQ @lc_me01            "Object class: MATERIAL
         AND p~fname       IN (@lc_fname,@lc_fname_lifnr,@lc_key) "Field Name  "Defect 2029
         AND p~chngind     IN (@lc_i,@lc_u).

  IF sy-subrc EQ 0.
* Begin of Change Defect 2029
*    SELECT e~matnr,
*           e~werks,
*           e~lifnr,              " Vendor Account Number
*           t~bwkey               " Valuation Area
*      FROM eord AS e             " Purchasing Source List
*      LEFT OUTER JOIN t001w AS t
*      ON e~werks = t~werks
*      INTO TABLE @DATA(li_eord_crt)
*      FOR ALL ENTRIES IN @li_objects_crt
*      WHERE e~matnr EQ @li_objects_crt-objectid+0(18)
*      AND   e~werks EQ @li_objects_crt-objectid+18(4)
*      AND   e~flifn = @abap_true "'X'
*      AND   e~autet = @space.

* This loop is built as the zeord is numeric and tabkey fields are characters and hence
* direct for all entries with the offset is not working.
   LOOP AT li_objects_crt ASSIGNING FIELD-SYMBOL(<fs_obj_crt>).
     lst_object_dtls-matnr  = <fs_obj_crt>-tabkey+3(18).
     lst_object_dtls-werks  = <fs_obj_crt>-tabkey+21(4).
     lst_object_dtls-zeord  = <fs_obj_crt>-tabkey+25(5).
     APPEND lst_object_dtls TO li_object_dtls.
   ENDLOOP.

  IF li_object_dtls IS NOT INITIAL.
    SELECT e~matnr,
           e~werks,
           e~zeord,
           e~lifnr,              " Vendor Account Number
           t~bwkey               " Valuation Area
      FROM eord AS e             " Purchasing Source List
      LEFT OUTER JOIN t001w AS t
      ON e~werks = t~werks
      INTO TABLE @DATA(li_eord_crt)
      FOR ALL ENTRIES IN @li_object_dtls
      WHERE e~matnr EQ @li_object_dtls-matnr
      AND   e~werks EQ @li_object_dtls-werks
      AND   e~zeord EQ @li_object_dtls-zeord
      AND   e~flifn = @abap_true. "'X'
* End of Change Defect 2029
    IF sy-subrc IS INITIAL.

      SORT li_eord_crt BY matnr werks lifnr.

      DELETE ADJACENT DUPLICATES FROM li_eord_crt COMPARING matnr werks lifnr.

      SELECT lifnr,
             adrnr " Address
       FROM  lfa1  " Vendor Master (General Section)
       INTO TABLE @DATA(li_lfa1_crt)
       FOR ALL ENTRIES IN @li_eord_crt
       WHERE lifnr EQ @li_eord_crt-lifnr.

      IF sy-subrc IS INITIAL.
        SORT li_lfa1_crt BY lifnr.
        SELECT addrnumber,
               city1,      " City
               post_code1, " City postal code
               country,    " Country Key
               region      " Region for PO Box (Country, State, Province, ...)
        FROM adrc          " Addresses (Business Address Services)
          INTO TABLE @DATA(li_adrc_crt)
          FOR ALL ENTRIES IN @li_lfa1_crt
          WHERE addrnumber EQ @li_lfa1_crt-adrnr.
        IF sy-subrc EQ 0.
          SORT li_adrc_crt BY addrnumber.
          SELECT     land1, " Country Key
                     bland, " Region (State, Province, County)
                     bezei  " Description
              FROM t005u    " Taxes: Region Key: Texts
                INTO TABLE @DATA(fp_bezei_di_ph)
              FOR ALL ENTRIES IN @li_adrc_crt
              WHERE land1 = @li_adrc_crt-country
              AND   bland = @li_adrc_crt-region
              AND   spras = @sy-langu.
          IF sy-subrc EQ 0.
            SORT fp_bezei_di_ph BY land1 bland.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc IS INITIAL

      SELECT matnr,        " Material Number
             ismrefmdprod, " Higher-Level Media Product
             ismmediatype, " Media Type
             ismpubldate   " Publication Date
        FROM mara          " General Material Data
              INTO TABLE @fp_li_ph_crt
        FOR ALL ENTRIES IN @li_eord_crt
        WHERE matnr = @li_eord_crt-matnr
        AND ismmediatype = @lc_ph
        AND ismpubldate  GE @sy-datum.

      IF sy-subrc IS INITIAL.

        SORT fp_li_ph_crt BY matnr.

        DELETE ADJACENT DUPLICATES FROM fp_li_ph_crt COMPARING matnr.

**********************************************************************
*** Selection from JPTIDCDASSIGN table to fetch IDENTCODE where Material
*   Number is equal to Material Number found in tha above table.
**********************************************************************
        li_mdprod_jpt[] = fp_li_ph_crt.

        SORT li_mdprod_jpt BY ismrefmdprod.
        DELETE ADJACENT DUPLICATES FROM li_mdprod_jpt COMPARING ismrefmdprod.

        IF li_mdprod_jpt[] IS NOT INITIAL.
          SELECT matnr,      " Material Number
                 idcodetype, " Type of Identification Code
                 identcode   " Identification Code
          FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
          INTO TABLE @DATA(fp_li_issn_ph_crt)
          FOR ALL ENTRIES IN @li_mdprod_jpt
            WHERE matnr EQ @li_mdprod_jpt-ismrefmdprod
          AND idcodetype = @lc_zssn.

          IF sy-subrc IS INITIAL.

            SORT fp_li_issn_ph_crt BY matnr.

            DELETE ADJACENT DUPLICATES FROM fp_li_issn_ph_crt COMPARING matnr.

          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF.     " IF li_mdprod_jpt[] IS NOT INITIAL.

      ENDIF. " IF sy-subrc IS INITIAL

    ENDIF. " IF sy-subrc IS INITIAL
ENDIF.     " Insert Defect 2029

*** To retrieve date (+/- 30 days from current date)

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = '30'
        months    = '00'
        signum    = '+'
        years     = '00'
      IMPORTING
        calc_date = lv_add_date.


    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = '30'
        months    = '00'
        signum    = '-'
        years     = '00'
      IMPORTING
        calc_date = lv_sub_date.

  ENDIF. " IF sy-subrc EQ 0

* Populate
  CLEAR st_shpd_cws.

* Populating the field segments in IDOC between Publication date +/- 30 days of the current date
  LOOP AT fp_li_ph_crt INTO DATA(lst_ph_crt)
                    WHERE ismpubldate GE lv_sub_date
                     AND  ismpubldate LE lv_add_date.


    IF sy-subrc IS INITIAL.

      READ TABLE li_eord_crt ASSIGNING FIELD-SYMBOL(<lst_eord_crt>)
                                        WITH KEY matnr = lst_ph_crt-matnr BINARY SEARCH .

      IF sy-subrc IS INITIAL.

        AT NEW matnr.
          CLEAR: i_edidd.
*  populate control record
* Control Record For Outbound IDOC
          CLEAR st_edidc.
          PERFORM f_control_data CHANGING st_edidc.
        ENDAT.
        CLEAR st_edidd.

* Segment name : Z1QTC_SAP_CWS
        st_edidd-segnam = c_segtyp.

* Segment hierarchy : 02
        st_edidd-hlevel = lc_hlvl_01.

* Field : ISSN
        READ TABLE fp_li_issn_ph_crt ASSIGNING FIELD-SYMBOL(<lst_issn_ph_crt>)
                                     WITH KEY matnr = lst_ph_crt-ismrefmdprod BINARY SEARCH .
        IF sy-subrc IS INITIAL.
          st_shpd_cws-ismidentcode = <lst_issn_ph_crt>-identcode.
        ENDIF. " IF sy-subrc IS INITIAL

* Field : Media
        st_shpd_cws-ismmediatype = lst_ph_crt-ismmediatype.

* Field : External Company ID
        st_shpd_cws-bwkey = <lst_eord_crt>-bwkey.

* Field : Journal Group Code
        st_shpd_cws-ismrefmdprod = lst_ph_crt-ismrefmdprod.

        READ TABLE li_lfa1_crt ASSIGNING FIELD-SYMBOL(<lst_lfa1_crt>)
                               WITH KEY lifnr = <lst_eord_crt>-lifnr
                               BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          READ TABLE li_adrc_crt ASSIGNING FIELD-SYMBOL(<lst_adrc_crt>)
                                       WITH KEY addrnumber = <lst_lfa1_crt>-adrnr
                                       BINARY SEARCH.

          IF sy-subrc IS INITIAL.
* Field : Country
            st_shpd_cws-country = <lst_adrc_crt>-country.
          ENDIF. " IF sy-subrc IS INITIAL

          READ TABLE fp_bezei_di_ph ASSIGNING FIELD-SYMBOL(<lst_bezei_di_ph>)
                                    WITH KEY land1 = <lst_adrc_crt>-country
                                    bland = <lst_adrc_crt>-region
                                    BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            IF <lst_adrc_crt>-country = c_ca.

* Field : State ISO 2-Digit
              st_shpd_cws-province = <lst_bezei_di_ph>-bezei.
* Field : Region ISO 2-Digit
              st_shpd_cws-province_iso = <lst_adrc_crt>-region.
            ELSE. " ELSE -> IF <lst_adrc_crt>-country = c_ca
* Field : State
              st_shpd_cws-state = <lst_bezei_di_ph>-bezei.
* Field : Region
              st_shpd_cws-state_iso = <lst_adrc_crt>-region.
            ENDIF. " IF <lst_adrc_crt>-country = c_ca

          ENDIF. " IF sy-subrc IS INITIAL
* Field : Postal Code
          st_shpd_cws-post_code1 = <lst_adrc_crt>-post_code1.

* Field : City
          st_shpd_cws-city1 = <lst_adrc_crt>-city1.

          st_edidd-sdata = st_shpd_cws.

          APPEND st_edidd TO i_edidd.
          CLEAR : st_shpd_cws.

        ENDIF. " IF sy-subrc IS INITIAL

        AT END OF matnr.
*  Posting IDOC
          PERFORM f_post_idoc USING st_edidc
                                    i_edidd.
        ENDAT.

      ENDIF. " IF sy-subrc IS INITIAL


    ELSE. " ELSE -> IF sy-subrc IS INITIAL

      CONTINUE.

    ENDIF. " IF sy-subrc IS INITIAL

  ENDLOOP. " LOOP AT fp_li_ph_crt INTO DATA(lst_ph_crt)
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_INT_PH
*&---------------------------------------------------------------------*
*  Logic to retrieve distributor address for physical products:
*  Distributor Address from Source list for all level 2 journals.
*  Will need to link level 2 to level 3 to get source list data
*--------------------------------------------------------------------*

FORM f_fetch_int_ph CHANGING fp_li_eord_ph  TYPE tt_eord_ph
                             fp_li_ph_fin   TYPE tt_ph_fin
                             fp_li_lfa1_ph  TYPE tt_lfa1_ph
                             fp_li_adrc_ph  TYPE tt_adrc_ph
                             fp_li_issn_ph  TYPE tt_issn
                             fp_li_bezei_ph TYPE tt_bezei.

  CONSTANTS : lc_zsbe    TYPE mtart VALUE 'ZSBE',         " Material Type
              lc_zjip    TYPE mtart VALUE 'ZJIP',         " Material Type
              lc_ph      TYPE ismmediatype VALUE 'PH',    " Media Type
              lc_zssn    TYPE ismidcodetype VALUE 'ZSSN', " Type of Identification Code
              lc_hlvl_01 TYPE edi_hlevel VALUE '01'.      " Hierarchy level

  DATA: li_refmdprod TYPE tt_ph_fin.
*--------------------------------------------------------------------*
***Selecting all Material Numbers from MARA Table where Material Type=ZSBE
*and Media Type = 'PH'.
**********************************************************************
  SELECT matnr,      " Material Number
         mtart,
         ismrefmdprod,
         ismmediatype,
         ismpubldate " Publication Date
    FROM mara        " General Material Data
    INTO TABLE @DATA(fp_li_mara_ph)
    WHERE mtart EQ @lc_zsbe
     AND ismmediatype EQ @lc_ph.

  IF sy-subrc IS INITIAL.
**********************************************************************
*    Selecting all Material Numbers where
*    ISMREFMDPROD(Higher-Level Media Product) = MATNR(Material Number)
*    and Material type = ZJIP
**********************************************************************
    SELECT matnr,
           mtart,
           ismrefmdprod,
           ismmediatype,
           ismpubldate " Publication Date
     FROM mara         " General Material Data
      INTO TABLE @fp_li_ph_fin
      FOR ALL ENTRIES IN @fp_li_mara_ph
      WHERE mtart = @lc_zjip
        AND ismrefmdprod = @fp_li_mara_ph-matnr.

    IF sy-subrc IS INITIAL.
**********************************************************************
*      Sorting the above table on the basis of Media Product and Publication
*      date in Descending order and deleting adjacent duplicates comparing
*      Media product. This will help to get the latest Publication date for
*      a particular Media Product.
**********************************************************************
* To take only materials that are in the future
      DELETE fp_li_ph_fin WHERE ismpubldate LT sy-datum.

      SORT fp_li_ph_fin BY ismrefmdprod ismpubldate DESCENDING.

      DELETE ADJACENT DUPLICATES FROM fp_li_ph_fin COMPARING ismrefmdprod.

* This sort is needed for Binary search Read.
      SORT fp_li_ph_fin BY matnr.
**********************************************************************
*** Selection from JPTIDCDASSIGN table to fetch IDENTCODE where Material
*   Number is equal to Media Product found in the above table.
**********************************************************************
      REFRESH li_refmdprod.
      li_refmdprod[] = fp_li_ph_fin[].
      SORT li_refmdprod BY ismrefmdprod.
      DELETE ADJACENT DUPLICATES FROM li_refmdprod COMPARING ismrefmdprod.
      IF li_refmdprod[] IS NOT INITIAL.
        SELECT matnr,      " Material Number
               idcodetype, " Type of Identification Code
               identcode   " Identification Code
        FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
        INTO TABLE @fp_li_issn_ph
        FOR ALL ENTRIES IN @li_refmdprod
        WHERE matnr EQ @li_refmdprod-ismrefmdprod
        AND idcodetype = @lc_zssn.
        IF sy-subrc EQ 0.
          SORT fp_li_issn_ph BY matnr.
        ENDIF.
      ENDIF.
**********************************************************************
*     Selection from EORD Table to fetch Vendor Number where FLIFN = 'X'
*     and AUTET = space and selecting the Valuation area by comparing the Plants
**********************************************************************
      SELECT e~matnr,
             e~werks,
             e~lifnr,              " Vendor Account Number
             t~bwkey               " Valuation Area
        FROM eord AS e             " Purchasing Source List
        LEFT OUTER JOIN t001w AS t
        ON e~werks = t~werks
        INTO TABLE @fp_li_eord_ph
        FOR ALL ENTRIES IN @fp_li_ph_fin
        WHERE e~matnr EQ @fp_li_ph_fin-matnr
        AND   e~flifn = @abap_true "'X'
        AND   e~autet = @space.

      IF sy-subrc IS INITIAL.
        SORT fp_li_eord_ph BY matnr werks lifnr.
*       To fetch the address number from LFA1 Table by comparing the Vendor Numbers
        SELECT lifnr,
               adrnr " Address
         FROM  lfa1  " Vendor Master (General Section)
         INTO TABLE @fp_li_lfa1_ph
         FOR ALL ENTRIES IN @fp_li_eord_ph
         WHERE lifnr EQ @fp_li_eord_ph-lifnr.

        IF sy-subrc IS INITIAL.
          SORT fp_li_lfa1_ph BY lifnr adrnr.
**********************************************************************
*       Selecting the address details of the vendor from ADRC table by comparing
*       Address Numbers
**********************************************************************
          SELECT addrnumber,
                 city1,      " City
                 post_code1, " City postal code
                 country,    " Country Key
                 region      " Region for PO Box (Country, State, Province, ...)
          FROM adrc          " Addresses (Business Address Services)
            INTO TABLE @fp_li_adrc_ph
            FOR ALL ENTRIES IN @fp_li_lfa1_ph
            WHERE addrnumber EQ @fp_li_lfa1_ph-adrnr.
          IF sy-subrc EQ 0.

            SORT fp_li_adrc_ph BY addrnumber.

            SELECT land1, " Country Key
                   bland, " Region (State, Province, County)
                   bezei  " Description
            FROM t005u    " Taxes: Region Key: Texts
              INTO TABLE @fp_li_bezei_ph
            FOR ALL ENTRIES IN @fp_li_adrc_ph
            WHERE land1 = @fp_li_adrc_ph-country
            AND bland = @fp_li_adrc_ph-region
            AND spras = @sy-langu.

            IF sy-subrc IS INITIAL.
              SORT fp_li_bezei_ph BY land1 bland.
              DELETE ADJACENT DUPLICATES FROM fp_li_bezei_ph COMPARING land1 bland.
            ENDIF. " IF sy-subrc IS INITIAL

          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL

***********************************************************************
** Physical Products : Segment population of data
***********************************************************************

  LOOP AT fp_li_eord_ph INTO DATA(lst_eord_ph).

    AT NEW lifnr.
      CLEAR : i_edidd.

* Control Record For Outbound IDOC
      CLEAR st_edidc.
      PERFORM f_control_data CHANGING st_edidc.
    ENDAT.

    CLEAR st_edidd.

* Segment name : Z1QTC_SAP_CWS
    st_edidd-segnam = c_segtyp.

* Segment hierarchy : 01
    st_edidd-hlevel = lc_hlvl_01.

    READ TABLE fp_li_ph_fin ASSIGNING FIELD-SYMBOL(<lst_ph_fin>)
                            WITH KEY matnr = lst_eord_ph-matnr
                            BINARY SEARCH.

    IF sy-subrc IS INITIAL.
* Field : Media
      st_shpd_cws-ismmediatype = <lst_ph_fin>-ismmediatype.

* Field : Journal Group Code
      st_shpd_cws-ismrefmdprod = <lst_ph_fin>-ismrefmdprod.

* Field : ISSN
      READ TABLE fp_li_issn_ph ASSIGNING FIELD-SYMBOL(<lst_i_issn_ph>)
                               WITH KEY matnr = <lst_ph_fin>-ismrefmdprod
                               BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        st_shpd_cws-ismidentcode = <lst_i_issn_ph>-identcode.
      ENDIF. " IF sy-subrc IS INITIAL

    ENDIF. " IF sy-subrc IS INITIAL

* Field : External Company ID
    st_shpd_cws-bwkey = lst_eord_ph-bwkey.

    READ TABLE fp_li_lfa1_ph ASSIGNING FIELD-SYMBOL(<lst_lfa1_ph>)
                             WITH KEY lifnr = lst_eord_ph-lifnr
                             BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      READ TABLE fp_li_adrc_ph ASSIGNING FIELD-SYMBOL(<lst_adrc_ph>)
                                   WITH KEY addrnumber = <lst_lfa1_ph>-adrnr
                                   BINARY SEARCH.

      IF sy-subrc IS INITIAL.
* Field : Country
        st_shpd_cws-country = <lst_adrc_ph>-country.

* Field : Description : Whether US State or Canada Province
        READ TABLE fp_li_bezei_ph ASSIGNING FIELD-SYMBOL(<lst_i_bezei_ph>)
                                  WITH KEY land1 = <lst_adrc_ph>-country
                                  bland = <lst_adrc_ph>-region
                                  BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          IF <lst_adrc_ph>-country = c_ca.

* Field : State ISO 2-Digit
            st_shpd_cws-province = <lst_i_bezei_ph>-bezei.
* Field : Region ISO 2-Digit
            st_shpd_cws-province_iso = <lst_adrc_ph>-region.
          ELSE. " ELSE -> IF <lst_adrc_ph>-country = c_ca
* Field : State
            st_shpd_cws-state = <lst_i_bezei_ph>-bezei.
* Field : Region
            st_shpd_cws-state_iso = <lst_adrc_ph>-region.
          ENDIF. " IF <lst_adrc_ph>-country = c_ca

        ENDIF. " IF sy-subrc IS INITIAL

* Field : Post Code
        st_shpd_cws-post_code1 = <lst_adrc_ph>-post_code1.

* Field : City
        st_shpd_cws-city1 = <lst_adrc_ph>-city1.
      ENDIF. " IF sy-subrc IS INITIAL

    ENDIF. " IF sy-subrc IS INITIAL

    st_edidd-sdata = st_shpd_cws.

    APPEND st_edidd TO i_edidd.
    CLEAR : st_shpd_cws.

    AT END OF matnr.
*  Posting IDOC
      PERFORM f_post_idoc USING st_edidc
                                i_edidd.
    ENDAT.

  ENDLOOP. " LOOP AT fp_li_eord_ph INTO DATA(lst_eord_ph)

  CLEAR st_edidd.

ENDFORM.
