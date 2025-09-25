*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_E131_SALES_REP_CHG_F01
* PROGRAM DESCRIPTION:This enhancement will change the sales rep
* after the order has been billed. Individual orders will be manually
* changed, however, mass changes will be allowed through this enhancement.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERP-7786
* REFERENCE NO: ERP-7786
* DEVELOPER: rtripat2  ED1K908586
* DATE: 11/5/2018
* DESCRIPTION: Cretion of Credit/Debit memo using item category  and
*              pricing  routines copy from invoice
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914088
* REFERENCE NO: CR#7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 20/12/2018
* DESCRIPTION: Adding Document Types: ZSUB, ZREW
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914088
* REFERENCE NO: AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
* DEVELOPER:KIRAN JAGANA
* DATE:12/19/2018
* DESCRIPTION:Create CMR/DMR
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E131_SALES_REP_CHG_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       Clear All the variables
*----------------------------------------------------------------------*
FORM f_clear_all.

* Clear Internal Table
  CLEAR: i_constant[],
         i_vbrp[],
         i_vbpa[],
         i_vbrk[],
         i_fcat[],
         i_final[],
         i_process[].

*** BOC: CR#7764 KKRAVURI20181219  ED2K914088
  IF sy-tcode = 'ZQTC_ZCSS_REPCHG'.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZCSS'.
    APPEND s_auart.
    CLEAR s_auart.
  ELSEIF sy-tcode = 'ZQTC_ZSUB_REPCHG'.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZSUB'.
    APPEND s_auart.
    CLEAR s_auart.

    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZREW'.
    APPEND s_auart.
    CLEAR s_auart.
  ELSE.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZCSS'.
    APPEND s_auart.
    CLEAR s_auart.
  ENDIF.
*** EOC: CR#7764 KKRAVURI20181219  ED2K914088

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_VALIDATE_VKORG
*&---------------------------------------------------------------------*
*       Validate Sales Org
*----------------------------------------------------------------------*
FORM f_validate_vkorg .

  DATA : lv_vkorg TYPE vkorg. " Sales Organization
* All Key fields has been passed so select single use
* Valid VKORG from table TVKO
  SELECT SINGLE vkorg " Sales Organization
   FROM tvko          " Organizational Unit: Sales Organizations
   INTO lv_vkorg
   WHERE vkorg IN s_vkorg.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e012(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_VALIDATE_KUNNR
*&---------------------------------------------------------------------*
*       Validate Customer Number
*----------------------------------------------------------------------*
FORM f_validate_kunnr .

  DATA : lv_kunnr TYPE kunnr . " Customer Number

* All Key fields has been passed so select single used
* Validate Customer Number from KNA1 table
  SELECT SINGLE kunnr " Customer Number
    FROM kna1         " General Data in Customer Master
    INTO lv_kunnr
    WHERE kunnr IN s_kunnr.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e010(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_VALIDATE_LAND1
*&---------------------------------------------------------------------*
*       Validate Country
*----------------------------------------------------------------------*
FORM f_validate_land1 .
* All Key fields has been passed so select single used.
  DATA : lv_land1 TYPE land1 ,          " Country Key
         lst_land TYPE shp_land1_range. " Range for Country

  lst_land-sign   = c_i.
  lst_land-option = c_eq.
  lst_land-low    = p_land1.
  APPEND lst_land TO ir_land.
  CLEAR lst_land .

* Validate Country from T005 table
  SELECT SINGLE land1 " Country Key
    FROM t005         " Countries
    INTO lv_land1
    WHERE land1 = p_land1.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e030(zqtc_r2). " Invalid Country!
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_VALIDATE_BLAND
*&---------------------------------------------------------------------*
*       Validate region
*----------------------------------------------------------------------*
FORM f_validate_bland.

  DATA lv_bland TYPE regio. " Region (State, Province, County)

* All Key fields has been passed so select single used.
* Validate Region from T005s table
  IF p_land1 IS NOT INITIAL.
    SELECT SINGLE bland " Region (State, Province, County)
      FROM t005s        " Taxes: Region (Province) Key
      INTO lv_bland
      WHERE land1 IN ir_land
      AND  bland IN s_bland.
    IF sy-subrc IS NOT INITIAL.
      SET CURSOR FIELD 'S_BLAND-LOW'.
      MESSAGE e033(zqtc_r2). " Invalid Region!
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ELSE. " ELSE -> IF p_land1 IS NOT INITIAL
    SET CURSOR FIELD 'P_LAND1'.
    MESSAGE e051(zqtc_r2). " Please enter country.
  ENDIF. " IF p_land1 IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_VBRK
*&---------------------------------------------------------------------*
*       Get Data from VBRK
*----------------------------------------------------------------------*
FORM f_get_data_vbrk .


* Declaration of Range
  DATA : lir_fkart TYPE tt_fkart_r.

* Populate Range for Billing type.
  PERFORM f_populate_billing_type CHANGING lir_fkart.

* Get billing documents from VBRK table.
* According to requirement no key fields and indexs are Present in table VBRK.
  SELECT vbeln " Billing Document
         fkart " Billing Type
         vkorg " Sales Organization
         vtweg " Distribution Channel
         fkdat " Billing date for billing index and printout
         kunag " Sold-to party
         land1 " Country of Destination
         regio " Region (State, Province, County)
   FROM vbrk   " Billing Document: Header Data
   INTO TABLE i_vbrk
   WHERE fkart IN lir_fkart
     AND vkorg IN s_vkorg
     AND fkdat IN s_fkdat
     AND land1 IN ir_land
     AND regio IN s_bland
     AND kunag IN s_kunnr
**BOC PRABHU AMS_R2_QTC_SD INC0207762 TR#ED1K909214
     AND fksto EQ ' '. "Cancellation indicator of Invoice
**EOC PRABHU AMS_R2_QTC_SD INC0207762 TR#ED1K909214
  IF sy-subrc EQ 0.
    SORT i_vbrk BY vbeln.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       Get Data from constant Table
*----------------------------------------------------------------------*
FORM f_get_constants .

  CONSTANTS: lc_devid  TYPE zdevid VALUE 'E131'. " Development ID

* Get the constant value from table Zcaconstant
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid = lc_devid.
  IF sy-subrc IS INITIAL.
* Suitable error handling will done later .
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BILLING_TYPE
*&---------------------------------------------------------------------*
*       Populate Billing type
*----------------------------------------------------------------------*
*      -->FP_LIR_FKART   Billing Type
*----------------------------------------------------------------------*
FORM f_populate_billing_type  CHANGING fp_lir_fkart TYPE tt_fkart_r.

  DATA : lst_fkart      TYPE LINE OF tt_fkart_r,
         lst_constant   TYPE ty_constant,
         i_constant_tmp TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.

  CONSTANTS : lc_bill_type TYPE rvari_vnam VALUE 'BILLING_TYPE'.

  i_constant_tmp[] = i_constant[].
*  Get only the entries where param1 = BILLING_TYPE.
  DELETE i_constant_tmp WHERE param1 <> lc_bill_type.

  LOOP AT i_constant_tmp INTO lst_constant.
    lst_fkart-sign   = c_i.
    lst_fkart-option = c_eq.
    lst_fkart-low    = lst_constant-low.
    APPEND lst_fkart TO fp_lir_fkart.
    CLEAR lst_fkart.
  ENDLOOP. " LOOP AT i_constant_tmp INTO lst_constant

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_VBRP
*&---------------------------------------------------------------------*
*      Get Data from VBRP table
*----------------------------------------------------------------------*
FORM f_get_data_vbrp .

  IF i_vbrk[] IS NOT INITIAL .
    SELECT vbeln " Billing Document
           posnr " Billing item
*--*BOC AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
           uepos " Higher level item
           netwr
*--*EOC AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
           matnr " Material Number
           aubel " Sales Document
           aupos " Sales Document Item
      FROM vbrp  " Billing Document: Item Data
      INTO TABLE i_vbrp
      FOR ALL ENTRIES IN i_vbrk
      WHERE vbeln = i_vbrk-vbeln.
    IF sy-subrc EQ 0.
* Suitable error handling will done later .
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_vbrk[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_VBPA
*&---------------------------------------------------------------------*
*       Get Data from VBPA table
*----------------------------------------------------------------------*
FORM f_get_data_vbpa .

  DATA : lir_parvw   TYPE tt_parvw_r,
         lir_pernr   TYPE tt_pernr_r,
         li_vbrp_tmp TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0.

  CONSTANTS : lc_posnr_hdr TYPE posnr VALUE '00000'. " Item number of the SD document

* Populate Range Table for Partner Function(PARVW)
  PERFORM f_populate_range_parvw  USING c_parvw_ve
                                  CHANGING lir_parvw.

* Populate Range Table for Partner Function(PARVW)
  PERFORM f_populate_range_parvw  USING c_parvw_ze
                                  CHANGING lir_parvw.

* Populate Range Table for Partner Function(PARVW)
  PERFORM f_populate_range_parvw  USING c_parvw_ag
                                  CHANGING lir_parvw.
  IF p_srep1 IS NOT INITIAL.
* Populate Range table for Personnel Number
    PERFORM f_poplate_range_pernr   USING p_srep1
                                    CHANGING lir_pernr.
  ENDIF. " IF p_srep1 IS NOT INITIAL

  IF p_srep2 IS NOT INITIAL.
* Populate Range table for Personnel Number
    PERFORM f_poplate_range_pernr   USING p_srep2
                                    CHANGING lir_pernr.
  ENDIF. " IF p_srep2 IS NOT INITIAL

  li_vbrp_tmp[] = i_vbrp[].
  SORT li_vbrp_tmp BY aubel aupos.
  DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp COMPARING aubel aupos.

  IF li_vbrp_tmp[] IS NOT INITIAL.
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           parvw " Partner Function
           pernr " Personnel Number
           adrnr " Address
      FROM vbpa  " Sales Document: Partner
      INTO TABLE i_vbpa
      FOR ALL ENTRIES IN li_vbrp_tmp
      WHERE vbeln = li_vbrp_tmp-aubel
      AND ( posnr = li_vbrp_tmp-aupos
      OR posnr EQ lc_posnr_hdr )
      AND parvw IN lir_parvw
      AND pernr IN lir_pernr.
    IF sy-subrc EQ 0.
      SORT i_vbpa BY vbeln posnr parvw.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_vbrp_tmp[] IS NOT INITIAL

  PERFORM f_get_data_adrc.

  CLEAR: li_vbrp_tmp[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RANGE_PARVW
*&---------------------------------------------------------------------*
*       Populate Patner Function Range
*----------------------------------------------------------------------*
FORM f_populate_range_parvw  USING    fp_lc_parvw TYPE parvw " Partner Function
                             CHANGING fp_lir_parvw TYPE tt_parvw_r.

  DATA : lst_parvw TYPE LINE OF tt_parvw_r.

  lst_parvw-sign   = c_i.
  lst_parvw-option = c_eq.
  lst_parvw-low    = fp_lc_parvw.
  APPEND lst_parvw TO fp_lir_parvw.
  CLEAR lst_parvw.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL
*&---------------------------------------------------------------------*
*       Populate Final Table
*----------------------------------------------------------------------*
FORM f_populate_final.

  DATA : lst_vbrp  TYPE ty_vbrp,
         lst_vbpa  TYPE ty_vbpa,
         lst_vbrk  TYPE ty_vbrk,
         lst_final TYPE ty_final,
         lst_vbfa1 TYPE ty_vbfa, "RTR INC0207762
         lst_vbak  TYPE ty_vbak, "RTR INC0207762
         lv_srep   TYPE flag. " General Flag

  CONSTANTS : lc_vbtyp_l   TYPE vbtyp_n VALUE 'L',      " Document category of subsequent document
              lc_vbtyp_k   TYPE vbtyp_n VALUE 'K',      " Document category of subsequent document
              lc_vbtyp_m   TYPE vbtyp_n VALUE 'M',      " Document category of subsequent document " RTR
              lc_posnr_hdr TYPE posnr   VALUE '000000'. " Item number of the SD document

  FIELD-SYMBOLS : <lst_vbfa> TYPE ty_vbfa.

  LOOP AT i_vbfa ASSIGNING <lst_vbfa>.
    IF <lst_vbfa>-vbtyp_n = lc_vbtyp_k.
      IF <lst_vbfa>-rfwrt LT 0.
        <lst_vbfa>-vbtyp_n = lc_vbtyp_l.
      ENDIF. " IF <lst_vbfa>-rfwrt LT 0
    ENDIF. " IF <lst_vbfa>-vbtyp_n = lc_vbtyp_k
  ENDLOOP. " LOOP AT i_vbfa ASSIGNING <lst_vbfa>
  UNASSIGN <lst_vbfa>.

  SORT i_vbfa BY vbelv posnv vbtyp_n.
  SORT i_vbfa BY vbelv posnv vbtyp_n.
  SORT i_vbak BY vbeln.
  SORT i_vbfa1 BY vbeln posnn vbtyp_n. "Prabhu AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
  LOOP AT i_vbrp INTO lst_vbrp.
    IF lst_vbrp-uepos IS NOT INITIAL.
      CONTINUE.
    ENDIF.
    READ TABLE i_vbrk INTO lst_vbrk WITH KEY vbeln = lst_vbrp-vbeln
                                             BINARY SEARCH .
    IF sy-subrc EQ 0.
      " BC RTR INC0207762 ED1K908586 28/09/2018
      READ TABLE i_vbfa1 INTO lst_vbfa1 WITH KEY vbeln = lst_vbrp-vbeln
                                                  posnn = lst_vbrp-posnr
                                                  vbtyp_n = lc_vbtyp_m
                                                   BINARY SEARCH .
      IF sy-subrc EQ 0.
        READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln = lst_vbfa1-vbelv
                                                         BINARY SEARCH .
        IF sy-subrc EQ 0.
          " BC RTR INC0207762 ED1K908586 28/09/2018
          READ TABLE i_vbfa TRANSPORTING NO FIELDS WITH KEY vbelv = lst_vbrp-vbeln
                                                    posnv = lst_vbrp-posnr
                                                    vbtyp_n = lc_vbtyp_l
                                                    BINARY SEARCH .
          IF sy-subrc EQ 0.
            READ TABLE i_vbfa TRANSPORTING NO FIELDS WITH KEY  vbelv = lst_vbrp-vbeln
                                                      posnv = lst_vbrp-posnr
                                                      vbtyp_n = lc_vbtyp_k
                                                      BINARY SEARCH .
            IF sy-subrc EQ 0.
              CONTINUE.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
          lst_final-vbeln  = lst_vbrk-vbeln.
          lst_final-fkart  = lst_vbrk-fkart.
          lst_final-posnr = lst_vbrp-posnr.
          lst_final-matnr = lst_vbrp-matnr.

* Check for postal code
          IF i_adrc[] IS NOT INITIAL.
            CLEAR: lst_vbpa.

            READ TABLE i_vbpa INTO lst_vbpa WITH KEY   vbeln = lst_vbrp-aubel
                                                       posnr = lst_vbrp-aupos
                                                       parvw = c_parvw_ag
                                                       BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL .
              READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                       posnr = lc_posnr_hdr
                                                       parvw = c_parvw_ag
                                                       BINARY SEARCH.
            ENDIF. " IF sy-subrc IS NOT INITIAL
            IF sy-subrc IS INITIAL.
              READ TABLE i_adrc TRANSPORTING NO FIELDS WITH KEY addrnumber = lst_vbpa-adrnr
                                                                BINARY SEARCH.
              IF sy-subrc IS NOT INITIAL.
                CONTINUE.
              ENDIF. " IF sy-subrc IS NOT INITIAL
            ENDIF. " IF sy-subrc IS INITIAL
*        ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF i_adrc[] IS NOT INITIAL

* Cond1. P_srep1 is initial, P_srep2 is not initial
          IF p_srep1 IS INITIAL AND p_srep2 IS NOT INITIAL.
            READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                     parvw = c_parvw_ze
                                                     pernr = p_srep2
                                                     BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                       posnr = lc_posnr_hdr
                                                       parvw = c_parvw_ze
                                                       pernr = p_srep2
                                                       BINARY SEARCH.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc IS INITIAL.
              lst_final-srep2 = p_srep2.
              lst_final-nsrep2 = p_nsrep2.
              lv_srep = abap_true.
            ELSE. " ELSE -> IF sy-subrc IS INITIAL
              CONTINUE.
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF p_srep1 IS INITIAL AND p_srep2 IS NOT INITIAL

* Cond2 : P_Srep1 is not initial and  p_srep2 IS INITIAL
          IF p_srep2 IS INITIAL AND p_srep1 IS NOT INITIAL.
            READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                     parvw = c_parvw_ve
                                                     pernr = p_srep1
                                                     BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
              READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                                posnr = lc_posnr_hdr
                                                                parvw = c_parvw_ve
                                                                pernr = p_srep1
                                                                BINARY SEARCH.
            ENDIF. " IF sy-subrc IS NOT INITIAL
            IF sy-subrc IS INITIAL.
              lst_final-nsrep1 = p_nsrep1.
              lst_final-srep1 = p_srep1.
            ELSE. " ELSE -> IF sy-subrc IS INITIAL
              CONTINUE.
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF p_srep2 IS INITIAL AND p_srep1 IS NOT INITIAL

* Cond3 : P_Srep1 and  p_srep2  both are not INITIAL
          IF p_srep1 IS NOT INITIAL AND  p_srep2 IS NOT INITIAL.
* First Check with item number.
            READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY  vbeln = lst_vbrp-aubel
                                                      posnr = lst_vbrp-aupos
                                                      parvw = c_parvw_ve
                                                      pernr = p_srep1
                                                      BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
              READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                                posnr = lc_posnr_hdr
                                                                parvw = c_parvw_ve
                                                                pernr = p_srep1
                                                                BINARY SEARCH.
            ENDIF. " IF sy-subrc IS NOT INITIAL

            IF sy-subrc EQ 0.
              READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY  vbeln = lst_vbrp-aubel
                                                        posnr = lst_vbrp-aupos
                                                        parvw = c_parvw_ze
                                                        pernr = p_srep2
                                                        BINARY SEARCH.
              IF sy-subrc NE 0.
                READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbrp-aubel
                                                         posnr = lc_posnr_hdr
                                                         parvw = c_parvw_ze
                                                         pernr = p_srep2
                                                         BINARY SEARCH.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0.
                lst_final-srep1 = p_srep1.
                lst_final-srep2 = p_srep2.
                lst_final-nsrep1 = p_nsrep1.
                lst_final-nsrep2 = p_nsrep2.
              ELSE. " ELSE -> IF sy-subrc EQ 0
                CONTINUE.
              ENDIF. " IF sy-subrc EQ 0

            ELSE. " ELSE -> IF sy-subrc EQ 0
              CONTINUE.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF p_srep1 IS NOT INITIAL AND p_srep2 IS NOT INITIAL


* Cond4. P_srep1 is initial, P_srep2 is initial.
          IF p_srep1 IS INITIAL AND  p_srep2 IS INITIAL.
            READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbrp-aubel
                                                      posnr = lst_vbrp-aupos
                                                      parvw = c_parvw_ve
                                                      BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
              READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = lst_vbrp-aubel
                                                                posnr = lc_posnr_hdr
                                                                parvw = c_parvw_ve
                                                                BINARY SEARCH.
            ENDIF. " IF sy-subrc IS NOT INITIAL
            IF sy-subrc EQ 0.
              lst_final-srep1 = lst_vbpa-pernr.
            ENDIF. " IF sy-subrc EQ 0

            CLEAR lst_vbpa.
            READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbrp-aubel
                                                        posnr = lst_vbrp-aupos
                                                        parvw = c_parvw_ze
                                                        BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = lst_vbrp-aubel
                                                       posnr = lc_posnr_hdr
                                                       parvw = c_parvw_ze
                                                       BINARY SEARCH.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc EQ 0.
              lst_final-srep2 = lst_vbpa-pernr.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF p_srep1 IS INITIAL AND p_srep2 IS INITIAL
          APPEND lst_final TO i_final.
          CLEAR: lst_final,
                 lv_srep.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. "  RTR INC0207762 ED1K908586 28/09/2018
    ENDIF. "  RTR INC0207762 ED1K908586 28/09/2018
  ENDLOOP. " LOOP AT i_vbrp INTO lst_vbrp

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_RECORDS_ALV
*&---------------------------------------------------------------------*
*       Display ALV records
*----------------------------------------------------------------------*

FORM f_display_records_alv .

  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',
              lc_box_sel     TYPE slis_fieldname VALUE 'SEL'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(002).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
  lst_layout-box_fieldname      = lc_box_sel.

  PERFORM f_popul_field_catalog .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = i_fcat
      i_save                   = abap_true
    TABLES
      t_outtab                 = i_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab.      "#EC CALLED

  DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
  SET PF-STATUS 'ZSTANDARD'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations
  DATA: li_header     TYPE slis_t_listheader,
        lst_header    TYPE slis_listheader,
        lv_line       TYPE slis_entry,
        lv_dat_low    TYPE slis_entry,
        lv_dat_high   TYPE slis_entry,
        lv_count      TYPE i,      " Count of type Integers
        lv_line_count TYPE i,      " Lines of type Integers
        lv_linesc     TYPE char10. " Linesc(10) of type Character

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H', " Typ_h of type CHAR1
                  lc_typ_s TYPE char1 VALUE 'S', " Typ_s of type CHAR1
                  lc_typ_a TYPE char1 VALUE 'A'. " Typ_a of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Sales Rep Change'(005).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

* DATE
  lst_header-typ = lc_typ_s . "'S'
  lst_header-key = 'Date: '(006).
  WRITE sy-datum TO lst_header-info.
  APPEND lst_header TO li_header.
  CLEAR: lst_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE i_final LINES lv_line_count.
  lv_linesc = lv_line_count.
  CONCATENATE 'Total No. of Records Selected: '(007) lv_linesc
  INTO lv_line SEPARATED BY space.
  lst_header-typ = lc_typ_a . "'A'
  lst_header-info = lv_line.
  APPEND lst_header TO li_header.
  CLEAR: lst_header, lv_line.

  IF s_kunnr[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_kunnr LINES lv_line_count.
    IF lv_line_count EQ 1.
* Sold to
      LOOP AT s_kunnr.
        IF s_kunnr-high IS INITIAL.
          lv_line = s_kunnr-low.
        ELSE. " ELSE -> IF s_kunnr-high IS INITIAL
          CONCATENATE  s_kunnr-low 'To'
         s_kunnr-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_kunnr-high IS INITIAL
        lst_header-typ = lc_typ_s.
        lst_header-key = 'Customer Number:'(008).
        lst_header-info = lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header, lv_line.
      ENDLOOP. " LOOP AT s_kunnr
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_kunnr.
        IF  lv_count = 1.
          lv_line = s_kunnr-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_kunnr-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_kunnr
      lst_header-typ = 'S'.
      lst_header-key = 'Customer Number:'(008).
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header, lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_kunnr[] IS NOT INITIAL

* Sales Org.
  IF s_vkorg[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_vkorg LINES lv_line_count.
    IF lv_line_count EQ 1.
      LOOP AT s_vkorg.
        IF s_vkorg-high IS INITIAL.
          lv_line = s_vkorg-low.
        ELSE. " ELSE -> IF s_vkorg-high IS INITIAL
          CONCATENATE s_vkorg-low 'To'
          s_vkorg-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_vkorg-high IS INITIAL
        lst_header-typ  = lc_typ_s.
        lst_header-key  = 'Sales Org:'(009).
        lst_header-info =  lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header, lv_line.
      ENDLOOP. " LOOP AT s_vkorg
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_vkorg.
        IF  lv_count = 1.
          lv_line = s_vkorg-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_vkorg-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_vkorg
      lst_header-typ = lc_typ_s.
      lst_header-key = ':'.
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header, lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_vkorg[] IS NOT INITIAL

* BIlling Date
  IF s_fkdat[] IS NOT INITIAL.
    READ TABLE s_fkdat INDEX 1.
    IF s_fkdat-high IS INITIAL.
      WRITE s_fkdat-low TO lv_line.
    ELSE. " ELSE -> IF s_fkdat-high IS INITIAL
      WRITE s_fkdat-low TO lv_dat_low.
      WRITE s_fkdat-high TO lv_dat_high.
      CONCATENATE lv_dat_low 'To'
      lv_dat_high INTO lv_line SEPARATED BY space.
    ENDIF. " IF s_fkdat-high IS INITIAL
    lst_header-typ  = lc_typ_s.
    lst_header-key  = 'Billing date:'(010).
    lst_header-info =  lv_line.
    APPEND lst_header TO li_header.
    CLEAR: lst_header, lv_line.
  ENDIF. " IF s_fkdat[] IS NOT INITIAL

*  lst_header-typ = lc_typ_s.
*  lst_header-key = ' '.
*  lst_header-info = ' '.
*  APPEND lst_header TO li_header.
*  CLEAR: lst_header.

** Country
  IF p_land1 IS NOT INITIAL.
    lst_header-typ = lc_typ_s.
    lst_header-key = 'Country:'(011).
    lst_header-info = p_land1.
    APPEND lst_header TO li_header.
    CLEAR: lst_header.
  ENDIF. " IF p_land1 IS NOT INITIAL

* Region
  IF s_bland[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_bland LINES lv_line_count.
    IF lv_line_count EQ 1.
      LOOP AT s_bland.
        IF s_bland-high IS INITIAL.
          lv_line = s_bland-low.
        ELSE. " ELSE -> IF s_bland-high IS INITIAL
          CONCATENATE s_bland-low 'To'
          s_bland-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_bland-high IS INITIAL
        lst_header-typ  = lc_typ_s.
        lst_header-key  = 'Region:'(012).
        lst_header-info =  lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header, lv_line.
      ENDLOOP. " LOOP AT s_bland
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_bland.
        IF  lv_count = 1.
          lv_line = s_bland-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_bland-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_bland
      lst_header-typ = lc_typ_s.
      lst_header-key = 'Region:'(012).
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header, lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_bland[] IS NOT INITIAL

* Postal Code
  IF s_pcode[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_pcode LINES lv_line_count.
    IF lv_line_count EQ 1.
      LOOP AT s_pcode.
        IF s_pcode-high IS INITIAL.
          lv_line = s_pcode-low.
        ELSE. " ELSE -> IF s_pcode-high IS INITIAL
          CONCATENATE s_pcode-low 'To'
          s_pcode-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_pcode-high IS INITIAL
        lst_header-typ  = lc_typ_s.
        lst_header-key  = 'Postal Code:'(013).
        lst_header-info =  lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header, lv_line.
      ENDLOOP. " LOOP AT s_pcode
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_pcode.
        IF  lv_count = 1.
          lv_line = s_pcode-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_pcode-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_pcode
      lst_header-typ = lc_typ_s.
      lst_header-key = 'Postal Code:'(013).
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header, lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_pcode[] IS NOT INITIAL
  DELETE li_header WHERE info IS INITIAL.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.


ENDFORM. "APPLICATION_SERVER

*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.

  DATA: lst_final   TYPE ty_final,
        lst_process TYPE ty_final,
        lv_input    TYPE char32, " Input of type CHAR30
        lv_tabix    TYPE sy-tabix.

  DATA: lcl_ref_grid TYPE REF TO cl_gui_alv_grid. " ALV List Viewer
*  *        * BOC by KJAGANA INC0207762
  DATA :    lv_count   TYPE i,
            li_tab     TYPE  esp1_message_tab_type,
            lst_tab    TYPE esp1_message_wa_type,
            lc_mesid   TYPE char8 VALUE 'ZQTC_R2', "Message class
            lc_msgno   TYPE char3 VALUE '525', "Message Number
            lc_msgno1  TYPE char3 VALUE '526', "Message Number
            lc_msgty_e TYPE char1 VALUE 'E', "Message type
            lc_d       TYPE char1 VALUE 'D',
            lc_msgty_s TYPE char1 VALUE 'S'. "Message type
*  *        * EOC by KJAGANA INC0207762
  DATA: lir_input TYPE tt_range_r,
        lst_input TYPE LINE OF tt_range_r.
  "RTR ERP-7786   ED1K908586 23/10/2018
  DATA : lir_returncc         TYPE  bapiret2,         "RTR ERP-7786   ED1K908586 23/10/2018
         lir_returnc          TYPE TABLE OF bapiret2, "RTR ERP-7786   ED1K908586 23/10/2018
         lir_returnd          TYPE TABLE OF bapiret2, "RTR ERP-7786   ED1K908586 23/10/2018
         lir_return           TYPE TABLE OF  bapiret2 INITIAL SIZE 0,
         lst_partners         TYPE bapiparnr,         "RTR ERP-7786   ED1K908586 23/10/2018
         lst_partchg          TYPE  bapiparnrc,       "RTR ERP-7786   ED1K908586 23/10/2018
         lst_order_header_in  TYPE bapisdhd1,      "RTR ERP-7786   ED1K908586 23/10/2018 Communication Fields
         lst_order_header_inx TYPE bapisdhd1x,     "RTR ERP-7786   ED1K908586 23/10/2018 Communication Fields
         lst_vbak             TYPE vbak,           "RTR ERP-7786   ED1K908586 23/10/2018
         li_partners          TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0, " "RTR ERP-7786   ED1K908586 23/10/2018
         li_partchg           TYPE STANDARD TABLE OF  bapiparnrc INITIAL SIZE 0, "RTR ERP-7786   ED1K908586 23/10/2018
         lc_parvw_ze          TYPE parvw VALUE 'ZE',               "RTR ERP-7786   ED1K908586 23/10/2018 Partner Function
         lc_parvw_ve          TYPE parvw VALUE 'VE',               "RTR ERP-7786   ED1K908586 23/10/2018 Partner Function.
         lc_ord_reason        TYPE augru   VALUE 'C82',            "RTR ERP-7786   ED1K908586 23/10/2018" Order reason (reason for the business transaction)
         lc_ass_number        TYPE ordnr_v VALUE 'SALESREPCHANGE', "RTR ERP-7786   ED1K908586 23/10/2018" Assignment number
         lv_message           TYPE string,                            "RTR ERP-7786   ED1K908586 23/10/2018
         lv_value_initial     TYPE c,
         lv_job_created       TYPE c.

  FIELD-SYMBOLS : <lst_final> TYPE ty_final.  "RTR ERP-7786   ED1K908586 23/10/2018"

  CONSTANTS :  lc_fld_vbeln TYPE slis_fieldname VALUE 'VBELN',
               lc_ic1       TYPE syst_ucomm     VALUE '&IC1',       " ABAP System Field: PAI-Triggering Function Code
               lc_data_save TYPE syst_ucomm     VALUE '&DATA_SAVE', " ABAP System Field: PAI-Triggering Function Code
               lc_process   TYPE syst_ucomm     VALUE '&PROCESS',   " ABAP System Field: PAI-Triggering Function Code
               lc_msg_id    TYPE symsgid VALUE 'ZQTC_R2',         " "RTR ERP-7786   ED1K908586 23/10/2018Message Class
               lc_msgty     TYPE symsgty VALUE 'E'.               " "RTR ERP-7786   ED1K908586 23/10/2018Message Type

  CASE fp_ucomm.
    WHEN lc_ic1.
* User double clicks any Invoice number then tcode VF03 is called from ALV.
      READ TABLE i_final INTO lst_final INDEX fp_lst_selfield-tabindex .
      IF sy-subrc = 0.
        IF fp_lst_selfield-fieldname = lc_fld_vbeln
               AND NOT lst_final-vbeln IS INITIAL.
          SET PARAMETER ID 'VF' FIELD lst_final-vbeln.
          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
        ENDIF. " IF fp_lst_selfield-fieldname = lc_fld_vbeln
      ENDIF. " IF sy-subrc = 0

    WHEN lc_process.
      CLEAR: lcl_ref_grid.
      IF lcl_ref_grid IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING "getting alv grid details
            e_grid = lcl_ref_grid.

        IF sy-subrc <> 0.                                   "#EC *
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF lcl_ref_grid IS INITIAL

      IF NOT lcl_ref_grid IS INITIAL.
        CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
        "changes in internal table
      ENDIF. " IF NOT lcl_ref_grid IS INITIAL

      i_process[] = i_final[].
      DELETE i_process WHERE sel IS INITIAL.
      IF i_process[] IS NOT INITIAL.
        LOOP AT i_process INTO lst_process.
          CONCATENATE lst_process-vbeln
                      lst_process-posnr
                      lst_process-nsrep1
                      lst_process-nsrep2
                      INTO lv_input.
          lst_input-sign = c_i.
          lst_input-option = c_eq.
          lst_input-low = lv_input.
          APPEND lst_input TO lir_input.
          CLEAR lst_input.
        ENDLOOP. " LOOP AT i_process INTO lst_process
*        * BOC by KJAGANA INC0207762 TR: ED1K909180
        i_selines[] = i_process[].
        DELETE i_selines WHERE nsrep1 EQ space AND nsrep2 EQ space.
        CLEAR :  lv_value_initial,lv_job_created .
        IF i_selines IS NOT INITIAL.
          LOOP AT lir_input INTO lst_input.
            lv_tabix = sy-tabix.
            READ TABLE i_selines INTO DATA(lst_selines)
                                                WITH KEY vbeln = lst_input-low+0(10)
                                                         posnr = lst_input-low+10(6)
                                                         nsrep1 = lst_input-low+16(8)
                                                         nsrep2 = lst_input-low+24(8).
            IF sy-subrc NE 0.
*          delete lir_input FROM lv_tabix.
              lst_input-high = lc_d."'D'.
              MODIFY lir_input FROM lst_input INDEX lv_tabix TRANSPORTING high .
            ENDIF.
*--* BOC Prabhu AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
*--*Check if the billing item value is initial
            READ TABLE i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = lst_input-low+0(10)
                                                           posnr = lst_input-low+10(6).
            IF sy-subrc EQ 0 AND lst_vbrp-netwr IS INITIAL.
*--* Make sure selected item is not BOM header
              READ TABLE i_vbrp INTO DATA(lst_vbrp2) WITH KEY vbeln = lst_input-low+0(10)
                                                              uepos = lst_input-low+10(6).
              IF sy-subrc NE 0.
                lv_value_initial = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
*--*Check if job created already for the selected line
            READ TABLE i_final INTO DATA(lst_final2) WITH KEY vbeln = lst_input-low+0(10)
                                                             posnr = lst_input-low+10(6)                                                            .
            IF sy-subrc EQ 0 AND lst_final2-jobname IS NOT INITIAL.
              lv_job_created = abap_true.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF lv_job_created = abap_true..
            MESSAGE e536(zqtc_r2) DISPLAY LIKE 'I' WITH lst_vbrp-vbeln lst_vbrp-posnr.
          ENDIF.
          IF lv_value_initial = abap_true.
            MESSAGE e529(zqtc_r2) DISPLAY LIKE 'I' WITH lst_vbrp-vbeln lst_vbrp-posnr.
          ENDIF.
*--*EOC Prabhu AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
          DELETE lir_input WHERE high = lc_d."'D'.
*          * EOC by KJAGANA INC0207762 TR: ED1K909180
          PERFORM f_create_sales_order USING lir_input.
          fp_lst_selfield-refresh = abap_true.
        ELSE.
          MESSAGE e524(zqtc_r2) DISPLAY LIKE 'I'.
        ENDIF."i_selines is NOT INITIAL.
        REFRESH i_selines.
        i_selines[] = i_process[].
*        delete i_selines WHERE nsrep1 ne space AND nsrep2 ne space.
        LOOP AT i_selines INTO DATA(lst_selines1).
          lv_count = lv_count + 1.
          IF lst_selines1-nsrep1 IS INITIAL AND lst_selines1-nsrep2 IS INITIAL.
            lst_tab-msgid  = lc_mesid.
            lst_tab-msgno  = lc_msgno.

            lst_tab-msgty  = lc_msgty_e.
            lst_tab-msgv1  = lst_selines1-vbeln.
            lst_tab-msgv2  = lst_selines1-posnr.
            lst_tab-lineno = lv_count.
            APPEND lst_tab TO li_tab.
            CLEAR lst_tab.
          ENDIF.
          IF lst_selines1-nsrep1 IS NOT INITIAL AND lst_selines1-nsrep2 IS NOT INITIAL.
            lst_tab-msgid  = lc_mesid.
            lst_tab-msgno  = lc_msgno1.

            lst_tab-msgty  = lc_msgty_s.
            lst_tab-msgv1  = lst_selines1-vbeln.
            lst_tab-msgv2  = lst_selines1-posnr.
            lst_tab-lineno = lv_count.
            APPEND lst_tab TO li_tab.
            CLEAR lst_tab.
          ENDIF.
        ENDLOOP.
      ENDIF. " IF i_process[] IS NOT INITIAL
      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        TABLES
          i_message_tab = li_tab.
*        * EOC by KJAGANA INC0207762 TR: ED1K909180
    WHEN lc_data_save.
      MESSAGE i070(zqtc_r2). " Changes saved successfully.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Populate Field Catalog
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname     TYPE slis_tabname VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln   TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_fkart   TYPE slis_fieldname VALUE 'FKART',
             lc_fld_posnr   TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_matnr   TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_srep1   TYPE slis_fieldname VALUE 'SREP1',
             lc_fld_srep2   TYPE slis_fieldname VALUE 'SREP2',
             lc_fld_nsrep1  TYPE slis_fieldname VALUE 'NSREP1',
             lc_fld_nsrep2  TYPE slis_fieldname VALUE 'NSREP2',
             lc_fld_jobname TYPE slis_fieldname VALUE 'JOBNAME'.

  lv_col_pos         = 0 .
* Populate field catalog

* Invoice Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Invoice number'(014)
                       CHANGING i_fcat.

* Invoice Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Invoice item number'(016)
                     CHANGING i_fcat.

* Invoice Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_fkart  lc_tabname   lv_col_pos  'Invoice Type'(015)
                       CHANGING i_fcat.

* Material
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Material'(017)
                     CHANGING i_fcat.

* Sales Rep 1
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_srep1  lc_tabname   lv_col_pos  'Sales rep 1'(018)
                     CHANGING i_fcat.

* Sales Rep 2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_srep2  lc_tabname   lv_col_pos  'Sales rep 2'(019)
                   CHANGING i_fcat.

* New Sales Rep1
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_edit USING lc_fld_nsrep1  lc_tabname   lv_col_pos  'New Sales rep 1'(020)
                 CHANGING i_fcat.

* New Sales Rep2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_edit_2 USING lc_fld_nsrep2  lc_tabname   lv_col_pos  'New Sales rep 2'(021)
                  CHANGING i_fcat.

* New Sales Rep2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_jobname  lc_tabname   lv_col_pos  'Background Job Name'(022)
                  CHANGING i_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field Catalog
*----------------------------------------------------------------------*

FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_EDIT
*&---------------------------------------------------------------------*
*      Build Field Catalog for editable field
*----------------------------------------------------------------------*
FORM f_build_fcat_edit USING  fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30',          " Output Length
              lc_ref_tab   TYPE tabname    VALUE 'ZQTC_REPDET', " Table Name
              lc_ref_fld   TYPE fieldname  VALUE 'SREP1'.       " Field Name

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-edit        = abap_true.
  lst_fcat-seltext_l   = fp_text.
  lst_fcat-seltext_m   = fp_text.
  lst_fcat-seltext_s   = fp_text.
  lst_fcat-ref_tabname = lc_ref_tab.
  lst_fcat-ref_fieldname = lc_ref_fld.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_EDIT
*&---------------------------------------------------------------------*
*      Build Field Catalog for editable field
*----------------------------------------------------------------------*
FORM f_build_fcat_edit_2 USING  fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30',          " Output Length
              lc_ref_tab   TYPE tabname    VALUE 'ZQTC_REPDET', " Table Name
              lc_ref_fld   TYPE fieldname  VALUE 'SREP2'.       " Field Name

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-edit        = abap_true.
  lst_fcat-seltext_l   = fp_text.
  lst_fcat-seltext_m   = fp_text.
  lst_fcat-seltext_s   = fp_text.
  lst_fcat-ref_tabname = lc_ref_tab.
  lst_fcat-ref_fieldname = lc_ref_fld.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_HOTSPOT
*&---------------------------------------------------------------------*
*      Build field catalog for craeting HOTSPOT fields
*----------------------------------------------------------------------*
FORM f_build_fcat_hotspot  USING fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-key         = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-hotspot     = abap_true.
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_POSTALCODE
*&---------------------------------------------------------------------*
*       Validate Postal Code
*----------------------------------------------------------------------*
FORM f_validate_postalcode .

  IF p_land1 IS NOT INITIAL. "Country
    LOOP AT s_pcode.
      IF s_pcode-low IS NOT INITIAL.
* Validate Postal Code
        CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
          EXPORTING
            country                        = p_land1     "Country
            postal_code_city               = s_pcode-low "Postal Code
          EXCEPTIONS
            country_not_valid              = 1
            region_not_valid               = 2
            postal_code_city_not_valid     = 3
            postal_code_po_box_not_valid   = 4
            postal_code_company_not_valid  = 5
            po_box_missing                 = 6
            postal_code_po_box_missing     = 7
            postal_code_missing            = 8
            postal_code_pobox_comp_missing = 9
            po_box_region_not_valid        = 10
            po_box_country_not_valid       = 11
            pobox_and_poboxnum_filled      = 12
            OTHERS                         = 13.
        IF sy-subrc IS NOT INITIAL.
          SET CURSOR FIELD 'S_PCODE-LOW'.
          MESSAGE e067(zqtc_r2) WITH s_pcode-low. " Invalid Postal Code &.
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF s_pcode-low IS NOT INITIAL

      IF s_pcode-high IS NOT INITIAL.
* Validate Postal Code
        CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
          EXPORTING
            country                        = p_land1      "Country
            postal_code_city               = s_pcode-high "Postal Code
          EXCEPTIONS
            country_not_valid              = 1
            region_not_valid               = 2
            postal_code_city_not_valid     = 3
            postal_code_po_box_not_valid   = 4
            postal_code_company_not_valid  = 5
            po_box_missing                 = 6
            postal_code_po_box_missing     = 7
            postal_code_missing            = 8
            postal_code_pobox_comp_missing = 9
            po_box_region_not_valid        = 10
            po_box_country_not_valid       = 11
            pobox_and_poboxnum_filled      = 12
            OTHERS                         = 13.
        IF sy-subrc IS NOT INITIAL.
          SET CURSOR FIELD 'S_PCODE-HIGH'.
          MESSAGE e067(zqtc_r2) WITH s_pcode-high. " Invalid Postal Code &.
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF s_pcode-high IS NOT INITIAL
    ENDLOOP. " LOOP AT s_pcode
  ELSE. " ELSE -> IF p_land1 IS NOT INITIAL
    SET CURSOR FIELD 'P_LAND1'.
    MESSAGE e051(zqtc_r2). " Please enter country.
  ENDIF. " IF p_land1 IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SALES_ORDER
*&---------------------------------------------------------------------*
*       Create Sales order with reference to ALV
*----------------------------------------------------------------------*
FORM f_create_sales_order USING fp_lir_input TYPE tt_range_r.

  DATA :lv_jobname      TYPE btcjob,                                    " Background job name
        lv_jobcount     TYPE btcjobcnt,                                 " Job ID
        lv_valid        TYPE char1,                                     " Valid of type Character
        lv_error        TYPE char1,                                     " Error of type CHAR1
        lv_flg_released TYPE flag,                                      " General Flag
        lv_message      TYPE string,
        lv_locl         TYPE sypri_pdest,                               " Spool Parameter: Name of Device
        lst_params      TYPE pri_params,                                " Structure for Passing Spool Parameters
        lst_constant    TYPE ty_constant.

  CONSTANTS : lc_destination TYPE rvari_vnam VALUE 'DESTINATION', " ABAP: Name of Variant Variable
              lc_msg_id      TYPE symsgid VALUE 'ZQTC_R2',        " Message Class
              lc_msgty       TYPE symsgty VALUE 'E',              " Message Type
              lc_space       TYPE char1 VALUE ' '.                " Space(1) of type Character

  FIELD-SYMBOLS : <lst_final> TYPE ty_final.
* Get the Program Name
  lv_jobname = sy-cprog.

* To Open the Job for background processing
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
      sdlstrtdt        = sy-datum
      sdlstrttm        = sy-uzeit
    IMPORTING
      jobcount         = lv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE s000(zqtc_r2) WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4. " & & & &
    lv_error = abap_true.
  ELSE. " ELSE -> IF sy-subrc <> 0

* Get the Destination Value from i_constant Table.
    READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_destination.
    IF sy-subrc EQ 0.
      lv_locl = lst_constant-low .
    ENDIF. " IF sy-subrc EQ 0

    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        destination            = lv_locl " LOCL
        immediately            = space
        new_list_id            = abap_true
        no_dialog              = abap_true
        user                   = sy-uname
      IMPORTING
        out_parameters         = lst_params
        valid                  = lv_valid
      EXCEPTIONS
        archive_info_not_found = 1
        invalid_print_params   = 2
        invalid_archive_params = 3
        OTHERS                 = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

* Execute abap program zqtce_create_sales_order in background job storing any output to spool
** RTR EPR-7786 ED1K908586 11/05/2018 Create credit debit memo using copy control and calculation rotuines
    SUBMIT zqtce_create_credit_order WITH s_input IN fp_lir_input
                USER 'QTC_BATCH01'
                 VIA JOB  lv_jobname NUMBER lv_jobcount
                 TO SAP-SPOOL
                 WITHOUT SPOOL DYNPRO
                 DESTINATION lst_constant-low IMMEDIATELY lc_space
                 KEEP IN SPOOL abap_true AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname              = lv_jobname
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      IMPORTING
        job_was_released     = lv_flg_released
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        OTHERS               = 8.
    IF sy-subrc <> 0.
      lv_error = abap_true.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

  IF lv_error = abap_true.
    MESSAGE ID lc_msg_id
    TYPE       lc_msgty
    NUMBER     '068'
    INTO       lv_message.

**BOC PRABHU AMS_R2_QTC_SD INC0207762 ED1K909214
    LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true
                                           AND ( nsrep1 IS NOT INITIAL OR
                                                 nsrep2 IS NOT INITIAL ).
**EOC PRABHU AMS_R2_QTC_SD INC0207762 ED1K909214
      <lst_final>-jobname  = lv_message.
    ENDLOOP. " LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true

  ELSEIF lv_error IS INITIAL.
    MESSAGE ID lc_msg_id
    TYPE       lc_msgty
    NUMBER     '069'
    INTO       lv_message
    WITH       lv_jobname
               sy-datum
               sy-uzeit.
    LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true.
      <lst_final>-jobname  = lv_message.
    ENDLOOP. " LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true

  ENDIF. " IF lv_error = abap_true

ENDFORM.
*&--------------------------------------------------------------------*
*&      Form  F_VALIDATE_SALES_REP
*&---------------------------------------------------------------------*
*       Validate sales Rep
*----------------------------------------------------------------------*
FORM f_validate_sales_rep.

* Local Type Declaration
  TYPES : BEGIN OF lty_pernr,
            pernr TYPE persno,                " Personnel number
          END OF lty_pernr,
          ltt_srep_r TYPE RANGE OF zz_persno. " Personnel Number

  DATA : lir_srep TYPE ltt_srep_r,
         lst_srep TYPE LINE OF ltt_srep_r,
         li_pernr TYPE STANDARD TABLE OF lty_pernr INITIAL SIZE 0.

  IF p_srep1 IS NOT INITIAL.
    IF p_nsrep1 IS INITIAL.
      MESSAGE e056(zqtc_r2). " Please enter new sales rep
    ELSE. " ELSE -> IF p_nsrep1 IS INITIAL
*  Popualte new Sales Rep 1
      lst_srep-sign   = c_i.
      lst_srep-option = c_eq.
      lst_srep-low    =  p_nsrep1.
      APPEND lst_srep TO lir_srep.
      CLEAR lst_srep.
    ENDIF. " IF p_nsrep1 IS INITIAL

* Popualte Sales Rep 1
    lst_srep-sign   = c_i.
    lst_srep-option = c_eq.
    lst_srep-low    =  p_srep1.
    APPEND lst_srep TO lir_srep.
    CLEAR lst_srep.
  ENDIF. " IF p_srep1 IS NOT INITIAL

  IF p_srep2 IS NOT INITIAL.
* Popualte Sales Rep 2
    lst_srep-sign   = c_i.
    lst_srep-option = c_eq.
    lst_srep-low    =  p_srep2.
    APPEND lst_srep TO lir_srep.
    CLEAR lst_srep.
    IF p_nsrep2 IS INITIAL.
      MESSAGE e058(zqtc_r2). " Please enter new sales rep 2.
    ELSE. " ELSE -> IF p_nsrep2 IS INITIAL
* Popualte New Sales Rep 2
      lst_srep-sign   = c_i.
      lst_srep-option = c_eq.
      lst_srep-low    =  p_nsrep2.
      APPEND lst_srep TO lir_srep.
      CLEAR lst_srep.
    ENDIF. " IF p_nsrep2 IS INITIAL
  ENDIF. " IF p_srep2 IS NOT INITIAL

  IF lir_srep IS NOT INITIAL.
    SELECT pernr " Personnel number
     FROM pa0002 " HR Master Record: Infotype 0002 (Personal Data)
      INTO TABLE li_pernr
      WHERE pernr IN lir_srep.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e031(zqtc_r2). " Invalid Sales Rep!
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      SORT li_pernr BY pernr.
      IF p_srep1 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_srep1 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e059(zqtc_r2). " Invalid Sales Rep1!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_srep1 IS NOT INITIAL

      IF p_srep2 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_srep2 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e061(zqtc_r2). " Invalid Sales Rep2!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_srep2 IS NOT INITIAL

      IF p_nsrep1 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_nsrep1 BINARY SEARCH TRANSPORTING NO FIELDS .
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e062(zqtc_r2). " Invalid New Sales Rep1!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_nsrep1 IS NOT INITIAL

      IF p_nsrep2 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_nsrep2 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e063(zqtc_r2). " Invalid New Sales Rep2!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_nsrep2 IS NOT INITIAL
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF. " IF lir_srep IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPLATE_RANGE_PERNR
*&---------------------------------------------------------------------*
*       Populate range table for sales rep
*----------------------------------------------------------------------*
*      -->FP_P_SREP1   " sales rep
*      <--FP_LIR_PERNR  " range table for sales rep
*----------------------------------------------------------------------*
FORM f_poplate_range_pernr  USING    fp_p_srep    TYPE zz_persno " Personnel Number
                            CHANGING fp_lir_pernr TYPE tt_pernr_r.

  DATA : lst_pernr TYPE LINE OF tt_pernr_r.
  lst_pernr-sign   = c_i.
  lst_pernr-option = c_eq.
  lst_pernr-low    = fp_p_srep.
  APPEND lst_pernr TO fp_lir_pernr.
  CLEAR lst_pernr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_ADRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_adrc .

  DATA : li_vbpa_tmp TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0.

  CONSTANTS : lc_parvw_ag TYPE parvw VALUE 'AG'. " Partner Function

  IF s_pcode[] IS NOT INITIAL.
    li_vbpa_tmp[] = i_vbpa[].
    SORT li_vbpa_tmp BY parvw.
    DELETE li_vbpa_tmp  WHERE parvw <> lc_parvw_ag.
    IF li_vbpa_tmp IS NOT INITIAL.
      SELECT addrnumber " Address number
             date_from  " Valid-from date - in current Release only 00010101 possible
             nation     " Version ID for International Addresses
             post_code1 " City postal code
        FROM adrc       " Addresses (Business Address Services)
        INTO TABLE i_adrc
        FOR ALL ENTRIES IN li_vbpa_tmp
        WHERE addrnumber = li_vbpa_tmp-adrnr
        AND   post_code1 IN s_pcode.
      IF sy-subrc EQ 0.
        SORT i_adrc BY addrnumber.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_vbpa_tmp IS NOT INITIAL

  ENDIF. " IF s_pcode[] IS NOT INITIAL

  CLEAR:li_vbpa_tmp[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_VBFA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_vbfa .

** BC RTR ED1K908586 INC0207762 Fetch All orders for invoices
  DATA : lst_vbtyv      TYPE LINE OF tt_vbtyv_r,  " Range work area
         lir_vbtyv      TYPE tt_vbtyv_r,          " Range table
         lst_vbtyn      TYPE LINE OF tt_vbtyn_r,  " Range work area
         lir_vbtyn      TYPE tt_vbtyn_r,          " Range Internal table
         lst_constant   TYPE ty_constant,
         i_constant_tmp TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.

  CONSTANTS : lc_pre_doctyp TYPE rvari_vnam VALUE 'PRE_DOCTYPE',   " Contant param
              lc_suc_doctyp TYPE rvari_vnam VALUE 'SUC_DOCTYPE'.   " Constant param
** EC RTR ED1K908586 INC0207762 Fetch All orders for invoices


  IF i_vbrp[] IS NOT INITIAL.
    SELECT vbelv   " Preceding sales and distribution document
           posnv   " Preceding item of an SD document
           vbeln   " Subsequent sales and distribution document
           posnn   " Subsequent item of an SD document
           vbtyp_n " Document category of subsequent document
           rfwrt   " Reference value
     FROM vbfa     " Sales Document Flow
     INTO TABLE i_vbfa
     FOR ALL ENTRIES IN i_vbrp
     WHERE vbelv = i_vbrp-vbeln
     AND  posnv = i_vbrp-posnr
    AND ( vbtyp_n = 'L'
     OR  vbtyp_n = 'K').
    IF sy-subrc EQ 0.
      SORT i_vbfa BY vbelv posnv vbtyp_n.
    ENDIF. " IF sy-subrc EQ 0



** BC RTR ED1K908586 INC0207762 Fetch All orders for invoices


    i_constant_tmp[] = i_constant[].
*  Get only the entries where param1 = PRE_DOCTYPE.
    DELETE i_constant_tmp WHERE param1 <> lc_pre_doctyp.

    LOOP AT i_constant_tmp INTO lst_constant.
      lst_vbtyv-sign   = c_i.
      lst_vbtyv-option = c_eq.
      lst_vbtyv-low    = lst_constant-low.
      APPEND lst_vbtyv TO lir_vbtyv.
      CLEAR lst_vbtyv.
    ENDLOOP. " LOOP AT i_constant_tmp INTO lst_constant


    i_constant_tmp[] = i_constant[].
*  Get only the entries where param1 = SUC_DOCTYPE.
    DELETE i_constant_tmp WHERE param1 <> lc_suc_doctyp.

    LOOP AT i_constant_tmp INTO lst_constant.
      lst_vbtyn-sign   = c_i.
      lst_vbtyn-option = c_eq.
      lst_vbtyn-low    = lst_constant-low.
      APPEND lst_vbtyn TO lir_vbtyn.
      CLEAR lst_vbtyn.
    ENDLOOP. " LOOP AT i_constant_tmp INTO lst_constant



    SELECT   vbelv   " Preceding sales and distribution document
             posnv   " Preceding item of an SD document
             vbeln   " Subsequent sales and distribution document
             posnn   " Subsequent item of an SD document
             vbtyp_n " Document category of subsequent document
             rfwrt   " Reference value
       FROM vbfa     " Sales Document Flow
       INTO TABLE i_vbfa1
       FOR ALL ENTRIES IN i_vbrp
       WHERE vbeln = i_vbrp-vbeln
       AND  posnv = i_vbrp-posnr
      AND   vbtyp_v  IN lir_vbtyv
       AND  vbtyp_n IN lir_vbtyn.

    IF i_vbfa1[] IS NOT INITIAL.

      SELECT vbeln auart
        FROM vbak
        INTO TABLE i_vbak
        FOR ALL ENTRIES IN i_vbfa1
        WHERE vbeln = i_vbfa1-vbelv
*        AND auart EQ s_auart-low. " Commented per CR#7764
         AND auart IN s_auart.      " ADD: CR#7764  KKRAVURI20181220  ED2K914088

    ENDIF.
  ENDIF.  " IF i_vbrp[] IS NOT INITIAL
** EC ED1K908586 INC0207762 Fetch All orders for invoices

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DOC_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_doc_type.

** BC RTR ED1K908586 INC0207762 Validate Sales document type
  READ TABLE i_constant WITH KEY param1 = 'ORDER_TYPE' param2 = s_auart-low TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    MESSAGE e527(zqtc_r2).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_screen_mode.

  LOOP AT SCREEN.
    IF screen-name = 'S_AUART-LOW'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF. " IF screen-name = 'S_AUART-LOW'.
  ENDLOOP. " LOOP AT SCREEN

ENDFORM.
