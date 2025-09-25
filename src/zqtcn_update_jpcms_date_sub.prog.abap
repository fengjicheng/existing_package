*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCR_UPDATE_JPCMS_DATE_MATMAS (Report)
* PROGRAM DESCRIPTION: Report to update JPCMS date in material master
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE: 22/12/2016
* OBJECT ID: E145
* TRANSPORT NUMBER(S): ED2K903846
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906112
* REFERENCE NO: ERP-2087
* DEVELOPER: Writtick Roy
* DATE:  2017-05-16
* DESCRIPTION: Add quantities for multiple PO Lines
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906306
* REFERENCE NO: ERP-2217
* DEVELOPER: Writtick Roy
* DATE:  2017-05-22
* DESCRIPTION: Swap the population logic of Material Availability Date
*              (MARC-ISMAVAILDATE) and Planned Goods Arrival Date
*              (MARC-ISMARRIVALDATEPL)
*              Add Z01 as Default Movement Type (along with 101)
*----------------------------------------------------------------------*
* REVISION NO: ED2K906985
* REFERENCE NO: ERP-2935
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-06-28
* DESCRIPTION: As currently we are displaying as error message when no
*              records are found the batch jobs are terminating and
*              getting cancelled. To avoid this we are displaying it as
*               information message.
*----------------------------------------------------------------------*
* REVISION NO: ED2K907255
* REFERENCE NO: ERP-3168
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-12
* DESCRIPTION: Dates are not getting updated when legacy system sends space.
*              Ideally it should update the dates in this scenario.
*----------------------------------------------------------------------*
* REVISION NO: ED2K910759
* REFERENCE NO: ERP-6470
* DEVELOPER: Writtick ROY (WROY)
* DATE:  2018-02-08
* DESCRIPTION: Add Manual Execution Option with checkboxes to choose
*              individual Date fields.
*----------------------------------------------------------------------*
* REVISION NO: ED1K909755
* REFERENCE NO: RITM0116455
* DEVELOPER: Arjun Reddy (ARGADEELA)
* DATE:  2019-03-05
* DESCRIPTION: Update Actual Goods Arr Date (MARC-ISMARRIVALDATEAC)
*               for all the plants activated for the same material.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED1K912945
* REFERENCE NO: PRB0047328
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2021-05-17
* DESCRIPTION: Plant details not updated in output when Actual Goods Arr Date
*              not updated / in error.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_UPDATE_JPCMS_DATE_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_PRINTER_PO
*&---------------------------------------------------------------------*
*       Fetch data for printer purchase order
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data_printer_po  USING fp_v_curr_date  TYPE sydatum
                                    fp_v_curr_time  TYPE syuzeit
                                    fp_v_from_date  TYPE sydatum
                                    fp_v_from_time  TYPE syuzeit
                           CHANGING fp_i_ekpo       TYPE tt_ekpo.

  DATA: lir_date TYPE trgr_date,
        lst_nast TYPE ty_nast.

  DATA: li_ekko  TYPE STANDARD TABLE OF ty_ekko INITIAL SIZE 0.

  CONSTANTS: lc_sign_incld TYPE ddsign    VALUE 'I',        "Sign: (I)nclude
             lc_opti_betwn TYPE ddoption  VALUE 'BT'.       "Option: (B)e(T)ween

* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  IF cb_man_e IS INITIAL.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    APPEND INITIAL LINE TO lir_date   ASSIGNING FIELD-SYMBOL(<lst_date>).
    <lst_date>-sign    = lc_sign_incld.                     "Sign: (I)nclude
    <lst_date>-option  = lc_opti_betwn.                     "Option: (B)e(T)ween
    <lst_date>-low     = fp_v_from_date.                    "From Date
    <lst_date>-high    = fp_v_curr_date.                    "To Date
* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  ELSE.
    lir_date[] = s_exdate[].
  ENDIF.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

  CLEAR: i_nast[], i_ekko[], fp_i_ekpo[].

  SELECT objky            " Object key
         kschl            " Message type
         erdat            " Date on which status record was created
         eruhr            " Time at which status record was created
         vstat            " Processing status of message
    FROM nast
    INTO TABLE i_nast
        WHERE kschl IN s_kschl    " 'ZNEU'
        AND erdat IN lir_date
        AND vstat IN s_vstat.         " '1'.

  IF i_nast IS NOT INITIAL.

*   Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    IF cb_man_e IS INITIAL.
*   End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     Remove the entries based on Time
      DELETE i_nast WHERE erdat EQ fp_v_from_date
                      AND eruhr LT fp_v_from_time.
      DELETE i_nast WHERE erdat EQ fp_v_curr_date
                      AND eruhr GT fp_v_curr_time.
*   Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    ENDIF.
*   End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

*   Modifing Object key for PO no.
    LOOP AT i_nast INTO lst_nast.
      MOVE lst_nast-objky+0(10) TO lst_nast-objky_tmp.
      MODIFY i_nast FROM lst_nast.
    ENDLOOP.
    SORT i_nast BY objky_tmp.

    SELECT ebeln          " Purchasing Document Number
           bsart          " Purchasing Document Type
    FROM ekko
    INTO TABLE i_ekko
      FOR ALL ENTRIES IN i_nast
     WHERE ebeln = i_nast-objky_tmp
       AND ( bsart IN s_typ_p     " 'NB'
        OR   bsart IN s_typ_d ).  " 'ZNB'

    IF i_ekko IS  NOT INITIAL.
      SORT i_ekko BY ebeln.

*     Identify Printer POs only
      li_ekko[] = i_ekko[].
      DELETE li_ekko WHERE bsart NOT IN s_typ_p.
      IF li_ekko[] IS NOT INITIAL.
        SELECT ebeln          " Purchasing Document Number
               ebelp          " Item Number of Purchasing Document
               matnr          " Material Number
               werks          " Plant
               menge          " Purchase Order Quantity
          FROM ekpo
          INTO TABLE fp_i_ekpo
          FOR ALL ENTRIES IN li_ekko
            WHERE ebeln = li_ekko-ebeln
              AND knttp IN s_aac_p.        " Account Assignment Category: Project

        IF fp_i_ekpo IS NOT INITIAL.
          SORT fp_i_ekpo BY matnr werks.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_DISTRIBUTOR_PO
*&---------------------------------------------------------------------*
*       Fetch data for distributor purchase order
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data_distributor_po USING fp_i_ekko     TYPE tt_ekko
                              CHANGING fp_i_ekpo_dis TYPE tt_ekpo_dis.

  DATA: li_ekko  TYPE STANDARD TABLE OF ty_ekko INITIAL SIZE 0.

  CLEAR: fp_i_ekpo_dis[].

* Identify Distributor POs only
  li_ekko[] = fp_i_ekko[].
  DELETE li_ekko WHERE bsart NOT IN s_typ_d.
  IF li_ekko IS NOT INITIAL.
    SELECT ebeln          " Purchasing Document Number
           ebelp          " Item Number of Purchasing Document
           matnr          " Material Number
           werks          " Plant
      FROM ekpo
      INTO TABLE fp_i_ekpo_dis
      FOR ALL ENTRIES IN li_ekko
      WHERE ebeln = li_ekko-ebeln
       AND  pstyp IN s_cat_d       " 'S'
       AND  knttp IN s_aac_d.      "'X'

    IF fp_i_ekpo_dis IS NOT INITIAL.
      SORT fp_i_ekpo_dis BY matnr werks.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_GOODS_ISSUE
*&---------------------------------------------------------------------*
*       Fetch data for goods issue
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data_goods_issue USING fp_v_curr_date  TYPE sydatum
                                    fp_v_curr_time  TYPE syuzeit
                                    fp_v_from_date  TYPE sydatum
                                    fp_v_from_time  TYPE syuzeit
                           CHANGING fp_i_ekbe    TYPE tt_ekbe.

  CONSTANTS: lc_bwart_101 TYPE bwart VALUE '101'.  "Movement Type: GR goods receipt

  DATA: lir_date TYPE trgr_date.

  CONSTANTS: lc_sign_incld TYPE ddsign    VALUE 'I',        "Sign: (I)nclude
             lc_opti_betwn TYPE ddoption  VALUE 'BT'.       "Option: (B)e(T)ween

* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  IF cb_man_e IS INITIAL.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    APPEND INITIAL LINE TO lir_date   ASSIGNING FIELD-SYMBOL(<lst_date>).
    <lst_date>-sign    = lc_sign_incld.                     "Sign: (I)nclude
    <lst_date>-option  = lc_opti_betwn.                     "Option: (B)e(T)ween
    <lst_date>-low     = fp_v_from_date.                    "From Date
    <lst_date>-high    = fp_v_curr_date.                    "To Date
* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  ELSE.
    lir_date[] = s_exdate[].
  ENDIF.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

  CLEAR: fp_i_ekbe[].

  SELECT b~ebeln                   " Purchasing Document Number
         b~ebelp                   " Item Number of Purchasing Document
         b~cpudt                   " Day On Which Accounting Document Was Entered
         b~cputm                   " Time of Entry
         b~matnr                   " Material Number
         b~werks                   " Plant
    FROM ekbe AS b INNER JOIN
         ekpo AS p
      ON p~ebeln = b~ebeln
     AND p~ebelp = b~ebelp
    INTO TABLE fp_i_ekbe
    WHERE b~cpudt IN lir_date
      AND b~bwart IN s_bwart       " '101'
      AND p~pstyp IN s_cat_d       " 'S'
      AND p~knttp IN s_aac_d.      " 'X'

  IF fp_i_ekbe IS NOT INITIAL.
*   Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    IF cb_man_e IS INITIAL.
*   End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     Remove the entries based on Time
      DELETE fp_i_ekbe WHERE cpudt EQ fp_v_from_date
                         AND cputm LT fp_v_from_time.
      DELETE fp_i_ekbe WHERE cpudt EQ fp_v_curr_date
                         AND cputm GT fp_v_curr_time.
*   Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    ENDIF.
*   End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    SORT fp_i_ekbe BY matnr werks.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL_TAB
*&---------------------------------------------------------------------*
*       Get final table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_final_tab  USING fp_i_ekpo     TYPE tt_ekpo
                                 fp_i_ekpo_dis TYPE tt_ekpo_dis
                                 fp_i_ekbe     TYPE tt_ekbe
                        CHANGING fp_i_marc     TYPE tt_marc.

  CLEAR: i_final_tab[].

* Populating final table with printer PO data
  MOVE-CORRESPONDING fp_i_ekpo TO i_final_tab.

* Populating final table with distributor PO data
  MOVE-CORRESPONDING fp_i_ekpo_dis TO i_final_tab KEEPING TARGET LINES.

* Populating final table with goods issue data
  MOVE-CORRESPONDING fp_i_ekbe TO i_final_tab KEEPING TARGET LINES.

* Fetching required material master data
  IF i_final_tab IS NOT INITIAL.
    SORT i_final_tab BY matnr werks.
    DELETE ADJACENT DUPLICATES FROM i_final_tab COMPARING matnr werks.

    CLEAR: fp_i_marc[].
    SELECT matnr             " Material Number
           werks             " Plant
           basmg             " Base quantity
           vbamg             " Base quantity for capacity planning in shipping
           ismavaildate      " Material Staging/Availability Date
           ismarrivaldatepl  " Planned Goods Arrival Date
           ismarrivaldateac  " Actual Goods Arrival Date
      FROM marc
      INTO TABLE fp_i_marc
      FOR ALL ENTRIES IN i_final_tab
      WHERE matnr = i_final_tab-matnr.
*   Begin of DEL:RITM0116455:ARGADEELA:05-Mar-2019:ED1K909755
*        AND werks = i_final_tab-werks.
*   End of DEL:RITM0116455:ARGADEELA:05-Mar-2019:ED1K909755
    IF sy-subrc = 0.
      SORT fp_i_marc BY matnr werks.
      DELETE ADJACENT DUPLICATES FROM fp_i_marc COMPARING matnr werks.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Generate ALV display output
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv .

* Populate ALV display table
  PERFORM f_populate_display_tab.

* Populate ALV catelogue
  PERFORM f_populate_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DISPLAY_TAB
*&---------------------------------------------------------------------*
*       Populate ALV display table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_display_tab .

  DATA:li_ekpo      TYPE STANDARD TABLE OF ty_ekpo,
       li_ekpo_dis  TYPE STANDARD TABLE OF ty_ekpo_dis,
       li_ekbe      TYPE STANDARD TABLE OF ty_ekbe,

       lst_final    TYPE ty_final_tab,
       lst_ekpo     TYPE ty_ekpo,
       lst_ekpo_dis TYPE ty_ekpo_dis,
       lst_ekbe     TYPE ty_ekbe,
       lst_display  TYPE ty_display,

       lv_message   TYPE char100.

  CONSTANTS: lc_zero  TYPE char1 VALUE '0',
             lc_typ_e TYPE char1 VALUE 'E'.

  IF i_final_tab[] IS NOT INITIAL.

*   Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    LOOP AT i_retmsg ASSIGNING FIELD-SYMBOL(<lst_retmsg>).
      lst_display-matnr = <lst_retmsg>-material.
      lst_display-werks = <lst_retmsg>-plant.
      lst_display-message = <lst_retmsg>-message.
      lst_display-avldt   = <lst_retmsg>-avldt.
      lst_display-arvdtpl = <lst_retmsg>-arvdtpl.
      lst_display-arvdtac = <lst_retmsg>-arvdtac.
      APPEND lst_display TO i_display.
      CLEAR: lst_display.
    ENDLOOP.
*   End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*   Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*    LOOP AT i_final_tab INTO lst_final.
*
*      CLEAR: li_ekpo[], li_ekpo_dis[], li_ekbe[].
*
*      li_ekpo = i_ekpo.
*      DELETE li_ekpo WHERE matnr NE lst_final-matnr.
*      IF li_ekpo IS NOT INITIAL.
*        LOOP AT li_ekpo INTO lst_ekpo.
*          lst_display-ebeln = lst_ekpo-ebeln.
*          lst_display-ebelp = lst_ekpo-ebelp.
*          lst_display-matnr = lst_ekpo-matnr.
*          lst_display-werks = lst_ekpo-werks.
*
*          READ TABLE i_retmsg ASSIGNING FIELD-SYMBOL(<lst_retmsg>) WITH KEY material = lst_ekpo-matnr.
*          IF sy-subrc = 0.
*            lst_display-message = <lst_retmsg>-message.
*            lst_display-avldt   = <lst_retmsg>-avldt.
*            lst_display-arvdtpl = <lst_retmsg>-arvdtpl.
*            lst_display-arvdtac = <lst_retmsg>-arvdtac.
*          ENDIF.
*
*          APPEND lst_display TO i_display.
*          CLEAR: lst_display, lst_ekpo.
*        ENDLOOP.
*      ENDIF.
*
*      li_ekpo_dis = i_ekpo_dis.
*      DELETE li_ekpo_dis WHERE matnr NE lst_final-matnr.
*      IF li_ekpo_dis IS NOT INITIAL.
*        LOOP AT li_ekpo_dis INTO lst_ekpo_dis.
*          lst_display-ebeln = lst_ekpo_dis-ebeln.
*          lst_display-ebelp = lst_ekpo_dis-ebelp.
*          lst_display-matnr = lst_ekpo_dis-matnr.
*          lst_display-werks = lst_ekpo_dis-werks.
*
*          READ TABLE i_retmsg ASSIGNING <lst_retmsg> WITH KEY material = lst_ekpo_dis-matnr.
*          IF sy-subrc = 0.
*            lst_display-message = <lst_retmsg>-message.
*            lst_display-avldt   = <lst_retmsg>-avldt.
*            lst_display-arvdtpl = <lst_retmsg>-arvdtpl.
*            lst_display-arvdtac = <lst_retmsg>-arvdtac.
*          ENDIF.
*
*          APPEND lst_display TO i_display.
*          CLEAR: lst_display, lst_ekpo_dis.
*        ENDLOOP.
*      ENDIF.
*
*      li_ekbe = i_ekbe.
*      DELETE li_ekbe WHERE matnr NE lst_final-matnr.
*      IF li_ekbe IS NOT INITIAL.
*        LOOP AT li_ekbe INTO lst_ekbe.
*          lst_display-ebeln = lst_ekbe-ebeln.
*          lst_display-ebelp = lst_ekbe-ebelp.
*          lst_display-matnr = lst_ekbe-matnr.
*          lst_display-werks = lst_ekbe-werks.
*
*          READ TABLE i_retmsg ASSIGNING <lst_retmsg> WITH KEY material = lst_ekbe-matnr.
*          IF sy-subrc = 0.
*            lst_display-message = <lst_retmsg>-message.
*            lst_display-avldt   = <lst_retmsg>-avldt.
*            lst_display-arvdtpl = <lst_retmsg>-arvdtpl.
*            lst_display-arvdtac = <lst_retmsg>-arvdtac.
*          ENDIF.
*
*          APPEND lst_display TO i_display.
*          CLEAR: lst_display, lst_ekbe.
*        ENDLOOP.
*      ENDIF.
*    ENDLOOP.
*   End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
  ELSE.
* Begin of Change by PBANDLAPAL on 28-Jun-2017 for ERP-2935
*    MESSAGE text-008 TYPE lc_typ_e.    " 'E'
    MESSAGE i123(zqtc_r2).
* End of Change by PBANDLAPAL on 28-Jun-2017 for ERP-2935
    LEAVE LIST-PROCESSING.

  ENDIF.

* Deleting duplicate entries
* Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
* SORT i_display BY ebeln ebelp matnr.
* DELETE ADJACENT DUPLICATES FROM i_display COMPARING ebeln ebelp matnr.
* End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
* Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
  SORT i_display BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM i_display COMPARING matnr werks.
* End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
  DELETE i_display WHERE avldt   IS INITIAL
                     AND arvdtpl IS INITIAL
                     AND arvdtac IS INITIAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ALV
*&---------------------------------------------------------------------*
*       Populate ALV catelogue
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_alv .

  DATA: li_fieldcat TYPE slis_t_fieldcat_alv,     "Field catalog with field descriptions
        lst_layout  TYPE slis_layout_alv.         "List layout specifications

  DATA: lv_col_pos TYPE i.

  CONSTANTS: lc_fld_ebeln   TYPE slis_fieldname VALUE 'EBELN',
             lc_fld_ebelp   TYPE slis_fieldname VALUE 'EBELP',
             lc_fld_matnr   TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_werks   TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_message TYPE slis_fieldname VALUE 'MESSAGE',
             lc_fld_avldt   TYPE slis_fieldname VALUE 'AVLDT',
             lc_fld_arvdtpl TYPE slis_fieldname VALUE 'ARVDTPL',
             lc_fld_arvdtac TYPE slis_fieldname VALUE 'ARVDTAC',
             lc_tabnam      TYPE slis_tabname   VALUE 'I_DISPLAY'.

* List layout specifications
  lst_layout-zebra             = abap_true.                          "Stripped pattern
  lst_layout-colwidth_optimize = abap_true.                          "Column Width Optimization

  CLEAR: lv_col_pos.

* Populate Field catalog with field descriptions
  PERFORM f_populate_fieldcat:
* Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     USING lc_fld_ebeln lc_tabnam text-001
* CHANGING lv_col_pos li_fieldcat,
*     USING lc_fld_ebelp lc_tabnam text-002
* CHANGING lv_col_pos li_fieldcat,
* End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
     USING lc_fld_matnr lc_tabnam text-003
 CHANGING lv_col_pos li_fieldcat,
     USING lc_fld_werks lc_tabnam text-010
 CHANGING lv_col_pos li_fieldcat,
     USING lc_fld_message lc_tabnam text-004
 CHANGING lv_col_pos li_fieldcat,
     USING lc_fld_avldt lc_tabnam text-005
 CHANGING lv_col_pos li_fieldcat,
     USING lc_fld_arvdtpl lc_tabnam text-006
 CHANGING lv_col_pos li_fieldcat,
     USING lc_fld_arvdtac lc_tabnam text-007
 CHANGING lv_col_pos li_fieldcat.

* Display ALV Grid
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid                             "Name of the calling program
      is_layout          = lst_layout                           "List layout specifications
      it_fieldcat        = li_fieldcat                          "Field catalog with field descriptions
    TABLES
      t_outtab           = i_display                      "Table with data to be displayed
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
*  Do Nothing
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_FLD_EBELN  text
*      -->P_LC_TABNAM  text
*      -->P_TEXT_001  text
*      <--P_LV_COL_POS  text
*      <--P_LI_FIELDCAT  text
*----------------------------------------------------------------------*
FORM f_populate_fieldcat  USING    fp_fld_name  TYPE slis_fieldname
                                   fp_tabnam    TYPE slis_tabname
                                   fp_desc      TYPE any
                          CHANGING fp_col_pos   TYPE sycucol
                                   fp_fieldcat  TYPE slis_t_fieldcat_alv.

  FIELD-SYMBOLS: <lst_fldcat> TYPE slis_fieldcat_alv.    "Field catalog with field description

  fp_col_pos = fp_col_pos + 1.
  APPEND INITIAL LINE TO fp_fieldcat ASSIGNING <lst_fldcat>.

  <lst_fldcat>-col_pos       = fp_col_pos.            "Column Position
  <lst_fldcat>-fieldname     = fp_fld_name.           "Field Name
  <lst_fldcat>-seltext_l     = fp_desc.               "Field Description
  <lst_fldcat>-seltext_m     = fp_desc.               "Field Description
  <lst_fldcat>-seltext_s     = fp_desc.               "Field Description

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATE_VAL
*&---------------------------------------------------------------------*
*       Get the date range value
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_date_val   CHANGING fp_v_curr_date  TYPE sydatum
                               fp_v_curr_time  TYPE syuzeit
                               fp_v_from_date  TYPE sydatum
                               fp_v_from_time  TYPE syuzeit.

* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  IF cb_man_e IS NOT INITIAL.
    RETURN.
  ENDIF.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

  fp_v_curr_date = sy-datum.           "Current/To Date
  fp_v_curr_time = sy-uzeit.           "Current/To Time

* Get Interface run details
  SELECT SINGLE lrdat                "Last run date
                lrtime               "Last run time
    FROM zcainterface
    INTO (fp_v_from_date,
          fp_v_from_time)
   WHERE devid  EQ c_devid_e145
     AND param1 EQ space
     AND param2 EQ space.

  IF sy-subrc NE 0.
    CLEAR: fp_v_from_date,
           fp_v_from_time.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_DATE_VAL
*&---------------------------------------------------------------------*
*       Set the date value in ZCAINTERFACE table
*----------------------------------------------------------------------*
*      -->FP_V_CURR_DATE  Current Date Value
*      -->FP_V_CURR_TIME  Current Time Value
*----------------------------------------------------------------------*
FORM f_set_date_val  USING    fp_v_curr_date  TYPE sydatum
                              fp_v_curr_time  TYPE syuzeit.

  DATA: lst_interface TYPE zcainterface.   "Interface run details

* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
  IF cb_man_e IS NOT INITIAL.
    RETURN.
  ENDIF.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true                             "Lock mode
      mandt             = sy-mandt                              "01th enqueue argument (Client)
      devid             = c_devid_e145                          "02th enqueue argument (Development ID)
      param1            = space                                 "03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = space                                 "04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.

  IF sy-subrc EQ 0.
    lst_interface-mandt  = sy-mandt.                            "Client
    lst_interface-devid  = c_devid_e145.                        "Development ID
    lst_interface-param1 = space.                               "ABAP: Name of Variant Variable
    lst_interface-param2 = space.                               "ABAP: Name of Variant Variable
    lst_interface-lrdat  = fp_v_curr_date.                      "Last run date
    lst_interface-lrtime = fp_v_curr_time.                      "Last run time

* Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_interface.

* Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
  ELSE.
*   Error Message
    MESSAGE ID sy-msgid                                         "Message Class
          TYPE c_msgty_info                                     "Message Type: Information
        NUMBER sy-msgno                                         "Message Number
          WITH sy-msgv1                                         "Message Variable-1
               sy-msgv2                                         "Message Variable-2
               sy-msgv3                                         "Message Variable-3
               sy-msgv4.                                        "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_DATE_MATMAS
*&---------------------------------------------------------------------*
*       Update material master date field
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_date_matmas    USING fp_i_marc     TYPE tt_marc
                                   fp_i_nast     TYPE tt_nast
                                   fp_i_ekpo     TYPE tt_ekpo
                                   fp_i_ekpo_dis TYPE tt_ekpo_dis
                                   fp_i_ekbe     TYPE tt_ekbe.

  DATA: li_headdata       TYPE STANDARD TABLE OF bapie1matheader, " Header Segment with Control Information
        li_plantdata      TYPE STANDARD TABLE OF bapie1marc,      " Plant data
        li_plantdatax     TYPE STANDARD TABLE OF bapie1marcx,     " Plant data extension
        li_bapie1parex    TYPE STANDARD TABLE OF bapie1parex,     " Ref. Structure for BAPI Parameters EXTENSIONIN/EXTENSIONOUT
        li_bapie1parexx   TYPE STANDARD TABLE OF bapie1parexx,    " Checkbox Structure for Extension In/Extension Out
        li_retdata        TYPE STANDARD TABLE OF bapiret2,        "BAPI return message structure

        lst_headdata      TYPE bapie1matheader, " Header Segment with Control Information
        lst_plantdata     TYPE bapie1marc,      " Plant data
        lst_plantdatax    TYPE bapie1marcx,     " Plant data extension
        lst_bapi_te_marc  TYPE bapi_te_e1marc,  " Customer-Defined Fields: Material Data at Client Level
        lst_bapi_te_marcx TYPE bapi_te_e1marcx, " Customer-Defined Fields: Material Data at Client Level
        lst_bapie1parex   TYPE bapie1parex,     " Ref. Structure for BAPI Parameters EXTENSIONIN/EXTENSIONOUT
        lst_bapie1parexx  TYPE bapie1parexx,    " Checkbox Structure for Extension In/Extension Out
        lst_bapiret2      TYPE bapiret2,
        lst_retmsg        TYPE ty_retmsg,

        lv_menge          TYPE menge_d.

  CONSTANTS: lc_upd          TYPE bapifn     VALUE 'UPD',            " BAPI function: Update
             lc_struct_marc  TYPE te_struc   VALUE 'BAPI_TE_E1MARC', " BAPI structure: MARC
             lc_struct_marcx TYPE te_struc   VALUE 'BAPI_TE_E1MARCX', " BAPI structure: MARCX
             lc_msgtyp_s     TYPE bapi_mtype VALUE 'S',              " BAPI return message type
             lc_id_m3        TYPE symsgid    VALUE 'M3',             " BAPI return message id
             lc_num_801      TYPE symsgid    VALUE '801'.            " BAPI return message number

  IF fp_i_marc IS NOT INITIAL.

    LOOP AT fp_i_marc ASSIGNING FIELD-SYMBOL(<lst_marc>).

* Populate Header Data for material
      lst_headdata-function = lc_upd.
      lst_headdata-material = <lst_marc>-matnr.
      APPEND lst_headdata TO li_headdata.
      CLEAR: lst_headdata.

* Populating Plantdata for material
      lst_plantdata-function  = lc_upd.
      lst_plantdata-material  = <lst_marc>-matnr.
      lst_plantdatax-function = lc_upd.
      lst_plantdatax-material = <lst_marc>-matnr.
      lst_plantdata-plant     = <lst_marc>-werks.
      lst_plantdatax-plant    = <lst_marc>-werks.
*     Begin of ADD:ERP-2087:WROY:16-MAY-2017:ED2K906112
      IF <lst_marc>-vbamg IS INITIAL.
        CLEAR: lv_menge.
*       Add Quantities of all line items
        READ TABLE fp_i_ekpo ASSIGNING FIELD-SYMBOL(<lst_ekpo>)
             WITH KEY matnr = <lst_marc>-matnr
                      werks = <lst_marc>-werks
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT fp_i_ekpo ASSIGNING <lst_ekpo> FROM sy-tabix.
            IF <lst_ekpo>-matnr NE <lst_marc>-matnr OR
               <lst_ekpo>-werks NE <lst_marc>-werks.
              EXIT.
            ENDIF.
            lv_menge = lv_menge + <lst_ekpo>-menge.
          ENDLOOP.
        ENDIF.

        IF lv_menge IS NOT INITIAL.
          lst_plantdata-base_qty       = lv_menge.
          lst_plantdatax-base_qty      = abap_true.
          lst_plantdata-base_qty_plan  = lv_menge.
          lst_plantdatax-base_qty_plan = abap_true.
        ENDIF.
      ENDIF.
*     End   of ADD:ERP-2087:WROY:16-MAY-2017:ED2K906112
*     Begin of DEL:ERP-2087:WROY:16-MAY-2017:ED2K906112
*      READ TABLE fp_i_ekpo ASSIGNING FIELD-SYMBOL(<lst_ekpo>)
*           WITH KEY matnr = <lst_marc>-matnr
*                    werks = <lst_marc>-werks
*           BINARY SEARCH.
**     IF sy-subrc = 0 AND <lst_marc>-basmg IS INITIAL.
*      IF sy-subrc = 0 AND <lst_marc>-vbamg IS INITIAL.
*        lst_plantdata-base_qty       = <lst_ekpo>-menge.
*        lst_plantdatax-base_qty      = abap_true.
*        lst_plantdata-base_qty_plan  = <lst_ekpo>-menge.
*        lst_plantdatax-base_qty_plan = abap_true.
*      ENDIF.
*     End   of DEL:ERP-2087:WROY:16-MAY-2017:ED2K906112
      APPEND lst_plantdata  TO li_plantdata.
      APPEND lst_plantdatax TO li_plantdatax.

* Extension for Custom Client Level Fields
      lst_bapi_te_marc-material  = lst_plantdata-material.
      lst_bapi_te_marcx-material = lst_plantdata-material.
      lst_bapi_te_marc-plant     = lst_plantdata-plant.
      lst_bapi_te_marcx-plant    = lst_plantdata-plant.

*     Begin of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     IF <lst_marc>-ismavaildate IS INITIAL.
*     End   of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     Begin of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*     IF <lst_marc>-ismarrivaldatepl IS INITIAL.
*     Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     IF <lst_marc>-ismarrivaldatepl IS INITIAL OR
*        <lst_marc>-ismarrivaldatepl EQ space.
*     End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     End of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*     Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
      IF ( cb_man_e IS INITIAL OR cb_pla_d IS NOT INITIAL ) AND
         ( <lst_marc>-ismarrivaldatepl IS INITIAL OR
           <lst_marc>-ismarrivaldatepl EQ space ).
*     nd   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
        READ TABLE fp_i_ekpo ASSIGNING <lst_ekpo>
             WITH KEY matnr = <lst_marc>-matnr
                      werks = <lst_marc>-werks
             BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE fp_i_nast ASSIGNING FIELD-SYMBOL(<lst_nast>)
               WITH KEY objky_tmp = <lst_ekpo>-ebeln
               BINARY SEARCH.
          IF sy-subrc = 0.
*           Begin of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*           lst_bapi_te_marc-ismavaildate   = <lst_nast>-erdat.
*           lst_bapi_te_marcx-ismavaildate  = abap_true.
*           lst_retmsg-avldt                = abap_true.
*           End   of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*           Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
            lst_bapi_te_marc-ismarrivaldatepl   = <lst_nast>-erdat.
            lst_bapi_te_marcx-ismarrivaldatepl  = abap_true.
            lst_retmsg-arvdtpl                  = abap_true.
*           End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
          ENDIF.
        ENDIF.
      ENDIF.

*     Begin of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     IF <lst_marc>-ismarrivaldatepl IS INITIAL.
*     End   of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
*     Begin of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*      IF <lst_marc>-ismavaildate IS INITIAL.
*     Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     IF <lst_marc>-ismavaildate IS INITIAL OR
*        <lst_marc>-ismavaildate EQ space.
*     End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     End of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*     Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
      IF ( cb_man_e IS INITIAL OR cb_gda_d IS NOT INITIAL ) AND
         ( <lst_marc>-ismavaildate IS INITIAL OR
           <lst_marc>-ismavaildate EQ space ).
*     End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
        READ TABLE fp_i_ekpo_dis ASSIGNING FIELD-SYMBOL(<lst_ekpo_dis>)
             WITH KEY matnr = <lst_marc>-matnr
                      werks = <lst_marc>-werks
             BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE fp_i_nast ASSIGNING <lst_nast>
               WITH KEY objky_tmp = <lst_ekpo_dis>-ebeln
               BINARY SEARCH.
          IF sy-subrc = 0.
*           Begin of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*           lst_bapi_te_marc-ismarrivaldatepl   = <lst_nast>-erdat.
*           lst_bapi_te_marcx-ismarrivaldatepl  = abap_true.
*           lst_retmsg-arvdtpl                  = abap_true.
*           End   of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
*           Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
            lst_bapi_te_marc-ismavaildate   = <lst_nast>-erdat.
            lst_bapi_te_marcx-ismavaildate  = abap_true.
            lst_retmsg-avldt                = abap_true.
*           End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
          ENDIF.
        ENDIF.
      ENDIF.

*     Begin of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*     IF <lst_marc>-ismarrivaldateac IS INITIAL .
*     Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     IF <lst_marc>-ismarrivaldateac IS INITIAL OR
*       <lst_marc>-ismarrivaldateac EQ space.
*     End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*     End of Change by PBNADLAPAL on 12-Jul-2017 for ERP-3168
*     Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
      IF ( cb_man_e IS INITIAL OR cb_aga_d IS NOT INITIAL ) AND
         ( <lst_marc>-ismarrivaldateac IS INITIAL OR
           <lst_marc>-ismarrivaldateac EQ space ).
*     nd   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
        READ TABLE fp_i_ekbe ASSIGNING FIELD-SYMBOL(<lst_ekbe>)
             WITH KEY matnr = <lst_marc>-matnr
*   Begin of DEL:RITM0116455:ARGADEELA:05-Mar-2019:ED1K909755
*                      werks = <lst_marc>-werks
*   End of DEL:RITM0116455:ARGADEELA:05-Mar-2019:ED1K909755
             BINARY SEARCH.
        IF sy-subrc = 0.
          lst_bapi_te_marc-ismarrivaldateac   = <lst_ekbe>-cpudt.
          lst_bapi_te_marcx-ismarrivaldateac  = abap_true.
          lst_retmsg-arvdtac                  = abap_true.
        ENDIF.
      ENDIF.

* Populating Extension Structures for MARC
      lst_bapie1parex-structure  = lc_struct_marc.   " 'BAPI_TE_E1MARC'
      lst_bapie1parex-function   = lc_upd.
      lst_bapie1parex-material   = lst_plantdata-material.
      lst_bapie1parex-valuepart1 = lst_bapi_te_marc.
      APPEND lst_bapie1parex TO li_bapie1parex.
      CLEAR: lst_bapie1parex, lst_bapi_te_marc.

      lst_bapie1parexx-structure  = lc_struct_marcx.  " 'BAPI_TE_E1MARCX'
      lst_bapie1parexx-function   = lc_upd.
      lst_bapie1parexx-material   = lst_plantdata-material.
      lst_bapie1parexx-valuepart1 = lst_bapi_te_marcx.
      APPEND lst_bapie1parexx TO li_bapie1parexx.
      CLEAR: lst_bapie1parexx, lst_bapi_te_marcx.
      CLEAR: lst_plantdata, lst_plantdatax.

* Call BAPI for materrial available and arrival date value
      CALL FUNCTION 'BAPI_MATERIAL_SAVEREPLICA'
        EXPORTING
          noappllog      = abap_true
          nochangedoc    = space
          testrun        = space
          inpfldcheck    = space
        IMPORTING
          return         = lst_bapiret2
        TABLES
          headdata       = li_headdata
          plantdata      = li_plantdata
          plantdatax     = li_plantdatax
          extensionin    = li_bapie1parex
          extensioninx   = li_bapie1parexx
          returnmessages = li_retdata.

      READ TABLE li_retdata ASSIGNING FIELD-SYMBOL(<lst_retdata>) WITH KEY type = lc_msgtyp_s      " 'S'
                                                                             id = lc_id_m3         " 'M3'
                                                                         number = lc_num_801.      " '801'
      IF sy-subrc = 0.
        lst_retmsg-material = <lst_marc>-matnr.
*       Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
        lst_retmsg-plant    = <lst_marc>-werks.
*       End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
        lst_retmsg-message  = lst_bapiret2-message.

        APPEND lst_retmsg TO i_retmsg.
* Call BAPI to commit the trasaction
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      ELSE.
        lst_retmsg-material = <lst_marc>-matnr.
*       Begin of ADD:PRB0047328:NPALLA:17-May-2021:ED1K912945
        lst_retmsg-plant    = <lst_marc>-werks.
*       End of ADD:PRB0047328:NPALLA:17-May-2021:ED1K912945
        lst_retmsg-message  = lst_bapiret2-message.

        APPEND lst_retmsg TO i_retmsg.
      ENDIF.

      CLEAR: li_retdata[], li_headdata[], li_plantdata[], li_plantdatax[],
             li_bapie1parex[], li_bapie1parexx[], lst_bapiret2.
*     Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
      CLEAR: lst_retmsg.
*     nd   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
    ENDLOOP.
  ENDIF.
ENDFORM.
* Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULS
*&---------------------------------------------------------------------*
*       Populate Default Values of the Selection Screen Fields
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_defauls .

  APPEND INITIAL LINE TO s_bwart ASSIGNING FIELD-SYMBOL(<lst_bwart>).
  <lst_bwart>-sign   = c_sign_incld.
  <lst_bwart>-option = c_opti_equal.
  <lst_bwart>-low    = '101'.
  <lst_bwart>-high   = space.

  APPEND INITIAL LINE TO s_bwart ASSIGNING <lst_bwart>.
  <lst_bwart>-sign   = c_sign_incld.
  <lst_bwart>-option = c_opti_equal.
  <lst_bwart>-low    = 'Z01'.
  <lst_bwart>-high   = space.

ENDFORM.
* End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       Control display of the Selection Screen Fields
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_modify_screen .

  DATA:
    lc_grp_manual TYPE char3 VALUE 'MAN'.

  LOOP AT SCREEN.
    IF cb_man_e IS INITIAL AND
       screen-group1 EQ lc_grp_manual.
      screen-active = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
