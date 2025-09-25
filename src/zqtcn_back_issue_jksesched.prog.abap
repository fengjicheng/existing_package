*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_BACK_ISSUE_JKSESCHED
* PROGRAM DESCRIPTION: Duplicate Media Issues Prevention on Renewal
*                      Subscription
* DEVELOPER:           Writtick Roy (WROY)/Srabanti Bose (SRBOSE)
* CREATION DATE:       05/15/2015
* OBJECT ID:           E142
* TRANSPORT NUMBER(S): ED2K905794
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BACK_ISSUE_JKSESCHED
*&---------------------------------------------------------------------*
*Local types declaration


*--------------------------------------------------------------------*
*-************* Begin of comment of code by SKKAIRAMKO - CR7899
*--------------------------------------------------------------------*
*  TYPES:
*    BEGIN OF lty_aga_date,
*      matnr      TYPE matnr,          "Material Number
*      dwerk      TYPE dwerk_ext,      "Delivering Plant (Own or External)
*      ac_ga_date TYPE ismanlftagi,    "Actual Goods Arrival Date
*    END OF lty_aga_date,
*    ltt_aga_date TYPE STANDARD TABLE OF lty_aga_date INITIAL SIZE 0,
*
*    BEGIN OF lty_vbfa,
*      vbelv      TYPE  vbeln_von,     "Preceding sales and distribution document
*      posnv      TYPE  posnr_von,     "Preceding item of an SD document
*      vbeln      TYPE  vbeln_nach,    "Subsequent sales and distribution document
*      posnn       TYPE  posnr_nach,    "Subsequent item of an SD document
*      vbtyp_n    TYPE  vbtyp_n,       "Document category of subsequent document
*      order_type TYPE  auart,         "Sales Document Type
*    END OF lty_vbfa.
*
**Local data declaration
*  DATA:
*    lv_dlv_pln_c TYPE char50 VALUE '(SAPLJKSESAPMV45A)DELIVERYPLAN_TAB[]',     "Delv_plan of type CHAR50
*    lv_dlv_pln_a TYPE char50 VALUE '(SAPLJKSESAPMV45A)ALL_DELIVERYPLAN_TAB[]', "Delv_plan of type CHAR50
*    lv_xveda     TYPE char50 VALUE '(SAPLV45W)XVEDA[]',                        "Contract Data
*    lv_chng_ind  TYPE flag,                                                    "Change Indicator
*    lv_vgbel     TYPE vgbel.                                                   "Document number of the reference document
*
**Field symbol declaration
*  FIELD-SYMBOLS:
*    <li_dlv_p_c> TYPE table,
*    <li_dlv_p_a> TYPE table,
*    <li_xveda>   TYPE table.
*
**Local data declaration
*  DATA:
*    li_constants TYPE zcat_constants,                            "Constant Values
*    lr_dctyp_grc TYPE tms_t_auart_range,                         "Range: Sales Doc Type
*    lr_mdtyp_dig TYPE rjksd_mtype_range_tab,                     "Range: Media Type
*    li_jksesched TYPE rjksesched_tab,                            "IS-M: Media Schedule Lines
*    li_jksesch_c TYPE rjksesched_tab,                            "IS-M: Media Schedule Lines
*    li_jksesch_a TYPE rjksesched_tab,                            "IS-M: Media Schedule Lines
*    li_xveda_142 TYPE ztrar_vedavb,                              "Contract Data
*    li_aga_dates TYPE ltt_aga_date,                              "Actual Goods Arrival Date
*    li_jkseflow  TYPE STANDARD TABLE OF jkseflow INITIAL SIZE 0, "IS-M: Document Flow for Generated Orders ISP
*    li_ins_jflow TYPE STANDARD TABLE OF jkseflow INITIAL SIZE 0, "IS-M: Document Flow for Generated Orders ISP
*    li_vbfa      TYPE STANDARD TABLE OF lty_vbfa INITIAL SIZE 0. "Sales Document Flow
*
*  CONSTANTS:
*    lc_dev_e142  TYPE zdevid     VALUE 'E142',
*    lc_pr1_grace TYPE rvari_vnam VALUE 'GRACING',
*    lc_pr1_mdtyp TYPE rvari_vnam VALUE 'MEDIA_TYPE',
*    lc_pr2_dctyp TYPE rvari_vnam VALUE 'DOC_TYPE',
*    lc_pr2_digtl TYPE rvari_vnam VALUE 'DIGITAL'.
*
** Fetches Constant Values
*  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
*    EXPORTING
*      im_devid     = lc_dev_e142   "Development ID
*    IMPORTING
*      ex_constants = li_constants. "Constant Values
*  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
*    CASE <lst_constant>-param1.
*      WHEN lc_pr1_grace.
*        CASE <lst_constant>-param2.
*          WHEN lc_pr2_dctyp.
*            APPEND INITIAL LINE TO lr_dctyp_grc ASSIGNING FIELD-SYMBOL(<lst_dctyp_grc>).
*            <lst_dctyp_grc>-sign   = <lst_constant>-sign. "ID: I/E (include/exclude values)
*            <lst_dctyp_grc>-option = <lst_constant>-opti. "Selection option (EQ/BT/CP/...)
*            <lst_dctyp_grc>-low    = <lst_constant>-low.  "Lower Value: Sales Doc type
*            <lst_dctyp_grc>-high   = <lst_constant>-high. "Upper Value: Sales Doc type
*          WHEN OTHERS.
**           Nothing to do
*        ENDCASE.
*
*      WHEN lc_pr1_mdtyp.
*        CASE <lst_constant>-param2.
*          WHEN lc_pr2_digtl.
*            APPEND INITIAL LINE TO lr_mdtyp_dig ASSIGNING FIELD-SYMBOL(<lst_mdtyp_dig>).
*            <lst_mdtyp_dig>-sign   = <lst_constant>-sign. "ID: I/E (include/exclude values)
*            <lst_mdtyp_dig>-option = <lst_constant>-opti. "Selection option (EQ/BT/CP/...)
*            <lst_mdtyp_dig>-low    = <lst_constant>-low.  "Lower Value: Media type
*            <lst_mdtyp_dig>-high   = <lst_constant>-high. "Upper Value: Media type
*          WHEN OTHERS.
**           Nothing to do
*        ENDCASE.
*
*      WHEN OTHERS.
**       Nothing to do
*    ENDCASE.
*  ENDLOOP.
*
*  ASSIGN (lv_dlv_pln_c) TO <li_dlv_p_c>.
*  IF sy-subrc EQ 0.
*    MOVE-CORRESPONDING <li_dlv_p_c> TO li_jksesch_c.
*  ENDIF.
*  ASSIGN (lv_dlv_pln_a) TO <li_dlv_p_a>.
*  IF sy-subrc EQ 0.
*    MOVE-CORRESPONDING <li_dlv_p_a> TO li_jksesch_a.
*  ENDIF.
*  ASSIGN (lv_xveda)     TO <li_xveda>.
*  IF sy-subrc EQ 0.
*    MOVE-CORRESPONDING <li_xveda>   TO li_xveda_142.
*    SORT li_xveda_142 BY vposn.
*  ENDIF.
*  IF li_jksesch_c IS NOT INITIAL OR
*     li_jksesch_a IS NOT INITIAL.
*    APPEND LINES OF: li_jksesch_c TO li_jksesched,
*                     li_jksesch_a TO li_jksesched.
**   Get the Order Item Details
*    DATA(li_xvbap_e142) = xvbap[].
*    SORT li_xvbap_e142 BY posnr.
*
**   Identify if the Item is not being created / changed
*    LOOP AT li_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>).
*      CLEAR: lv_chng_ind.
*      READ TABLE li_xvbap_e142 ASSIGNING FIELD-SYMBOL(<lst_xvbap_e142>)
*           WITH KEY posnr = <lst_jksesched>-posnr
*           BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        IF <lst_xvbap_e142>-updkz EQ updkz_new OR    "Being Created
*           <lst_xvbap_e142>-updkz EQ updkz_update.   "Being Changed
*          lv_chng_ind = abap_true.
*        ENDIF.
*      ENDIF.
*
*      READ TABLE li_xveda_142 ASSIGNING FIELD-SYMBOL(<lst_xveda_e142>)
*           WITH KEY vposn = posnr_low
*           BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*           <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*          lv_chng_ind = abap_true.
*        ENDIF.
*      ENDIF.
*
*      READ TABLE li_xveda_142 ASSIGNING <lst_xveda_e142>
*           WITH KEY vposn = <lst_jksesched>-posnr
*           BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*           <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*          lv_chng_ind = abap_true.
*        ENDIF.
*      ENDIF.
*
*      IF lv_chng_ind IS INITIAL.
*        CLEAR: <lst_jksesched>-issue.
*      ENDIF.
*    ENDLOOP.
**   Remove the lines those are not being created / changed
*    DELETE li_jksesched WHERE issue IS INITIAL.
*
*    IF li_jksesched IS NOT INITIAL.
*      SORT li_jksesched BY issue.
*      DELETE ADJACENT DUPLICATES FROM li_jksesched COMPARING issue.
**     Fetch Plant and Sales Data for Material
*      SELECT mvke~matnr            "Material Number
*             mvke~dwerk            "Delivering Plant (Own or External)
*             marc~ismarrivaldateac "Actual Goods Arrival Date
*        FROM mvke
*       INNER JOIN marc
*          ON marc~matnr EQ mvke~matnr
*         AND marc~werks EQ mvke~dwerk
*       INNER JOIN mara
*          ON mara~matnr EQ mvke~matnr
*        INTO TABLE li_aga_dates
*         FOR ALL ENTRIES IN li_jksesched
*       WHERE mvke~matnr        EQ li_jksesched-issue
*         AND mvke~vkorg        EQ vbak-vkorg
*         AND mvke~vtweg        EQ vbak-vtweg
*         AND mara~ismmediatype IN lr_mdtyp_dig.
*      IF sy-subrc EQ 0.
*        SORT li_aga_dates BY matnr.
*      ENDIF. " IF sy-subrc EQ 0
*    ENDIF.
*    CLEAR: li_jksesched.
*
**   Duplicate Media Issues Prevention on Renewal Subscription
*    IF t180-trtyp EQ charh. "Only during creation
**     Fetch Reference Quotation Number from Sales Document: Header Data table
*      SELECT SINGLE vgbel   "Document number of the reference document
*        FROM vbak           "Sales Document: Header Data
*        INTO lv_vgbel
*       WHERE vbeln EQ vbak-vgbel.
*      IF sy-subrc IS INITIAL.
**       Fetch Gracing Order details from Sales Document Flow table
*        SELECT vbfa~vbelv   "Preceding sales and distribution document
*               vbfa~posnv   "Preceding item of an SD document
*               vbfa~vbeln   "Subsequent sales and distribution document
*               vbfa~posnn   "Subsequent item of an SD document
*               vbfa~vbtyp_n "Document category of subsequent document
*               vbak~auart   "Sales Document Type
*          FROM vbfa INNER JOIN vbak
*            ON vbfa~vbeln EQ vbak~vbeln
*          INTO TABLE li_vbfa
*         WHERE vbelv = lv_vgbel
*           AND vbtyp_n EQ vbtyp_kont
*           AND auart   IN lr_dctyp_grc.
*        IF sy-subrc IS INITIAL.
*          SORT li_vbfa BY vbeln posnn  .
*          DELETE ADJACENT DUPLICATES FROM li_vbfa COMPARING vbeln posnn.
*        ENDIF. " IF sy-subrc IS INITIAL
*      ENDIF. " IF sy-subrc IS INITIAL
*
**     Get data from Table: JKSEFLOW - IS-M: Document Flow for Generated Orders ISP
*      IF li_vbfa IS NOT INITIAL.
**       SELECT * is being used, since all the fields wll be used
*        SELECT *
*          FROM jkseflow  "IS-M: Document Flow for Generated Orders ISP
*          INTO TABLE li_jkseflow
*           FOR ALL ENTRIES IN li_vbfa
*         WHERE contract_vbeln EQ li_vbfa-vbeln
*           AND contract_posnr EQ li_vbfa-posnn
*           AND vbelnorder     NE space.
*        IF sy-subrc EQ 0.
*          SORT li_jkseflow BY issue.
*        ENDIF. " IF sy-subrc EQ 0
*      ENDIF. " IF li_vbfa IS NOT INITIAL
*    ENDIF.
*
*    IF li_aga_dates IS NOT INITIAL OR
*       li_jkseflow  IS NOT INITIAL.
*      LOOP AT li_jksesch_c ASSIGNING <lst_jksesched>.
*        DATA(lv_tabix) = sy-tabix.
**       Get the Order Item Details (No need to process if the Item is not being created / changed)
*        CLEAR: lv_chng_ind.
*        READ TABLE li_xvbap_e142 ASSIGNING <lst_xvbap_e142>
*             WITH KEY posnr = <lst_jksesched>-posnr
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xvbap_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xvbap_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*
*        READ TABLE li_xveda_142 ASSIGNING <lst_xveda_e142>
*             WITH KEY vposn = posnr_low
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*
*        READ TABLE li_xveda_142 ASSIGNING <lst_xveda_e142>
*             WITH KEY vposn = <lst_jksesched>-posnr
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*        IF lv_chng_ind IS INITIAL.
*          CONTINUE.
*        ENDIF.
*
*        READ TABLE li_aga_dates ASSIGNING FIELD-SYMBOL(<lst_aga_date>)
*             WITH KEY matnr = <lst_jksesched>-issue
*             BINARY SEARCH.
*        IF sy-subrc EQ 0 AND
*           <lst_aga_date>-ac_ga_date IS NOT INITIAL AND
*           <lst_aga_date>-ac_ga_date LT <lst_xvbap_e142>-erdat.
*          <lst_jksesched>-back          = abap_true.
*          <lst_jksesched>-shipping_date = <lst_xvbap_e142>-erdat.
*        ENDIF. " IF sy-subrc EQ 0 AND
*
*        IF t180-trtyp EQ charh. "Only during creation
*          READ TABLE li_jkseflow INTO DATA(lst_jkseflow)
*               WITH KEY issue = <lst_jksesched>-issue
*               BINARY SEARCH.
*          IF sy-subrc EQ 0.
*            <lst_jksesched>-xorder_created = abap_true.
*
*            lst_jkseflow-contract_vbeln = vbak-vbeln.
*            lst_jkseflow-contract_posnr = <lst_jksesched>-posnr.
*            APPEND lst_jkseflow TO li_ins_jflow.
*            CLEAR: lst_jkseflow.
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF.
*
*        READ TABLE <li_dlv_p_c> ASSIGNING FIELD-SYMBOL(<lst_dlv_p_c>) INDEX lv_tabix.
*        IF sy-subrc EQ 0.
*          MOVE-CORRESPONDING <lst_jksesched> TO <lst_dlv_p_c>.
*        ENDIF. " IF sy-subrc EQ 0
*      ENDLOOP. " LOOP AT li_jksesch_c ASSIGNING FIELD-SYMBOL(<lst_jksesched>)
*
*      LOOP AT li_jksesch_a ASSIGNING <lst_jksesched>.
*        lv_tabix = sy-tabix.
**       Get the Order Item Details (No need to process if the Item is not being created / changed)
*        CLEAR: lv_chng_ind.
*        READ TABLE li_xvbap_e142 ASSIGNING <lst_xvbap_e142>
*             WITH KEY posnr = <lst_jksesched>-posnr
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xvbap_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xvbap_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*
*        READ TABLE li_xveda_142 ASSIGNING <lst_xveda_e142>
*             WITH KEY vposn = posnr_low
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*
*        READ TABLE li_xveda_142 ASSIGNING <lst_xveda_e142>
*             WITH KEY vposn = <lst_jksesched>-posnr
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_xveda_e142>-updkz EQ updkz_new OR    "Being Created
*             <lst_xveda_e142>-updkz EQ updkz_update.   "Being Changed
*            lv_chng_ind = abap_true.
*          ENDIF.
*        ENDIF.
*        IF lv_chng_ind IS INITIAL.
*          CONTINUE.
*        ENDIF.
*
*        READ TABLE li_aga_dates ASSIGNING <lst_aga_date>
*             WITH KEY matnr = <lst_jksesched>-issue
*             BINARY SEARCH.
*        IF sy-subrc EQ 0 AND
*           <lst_aga_date>-ac_ga_date IS NOT INITIAL AND
*           <lst_aga_date>-ac_ga_date LT <lst_xvbap_e142>-erdat.
*          <lst_jksesched>-back          = abap_true.
*          <lst_jksesched>-shipping_date = <lst_xvbap_e142>-erdat.
*        ENDIF. " IF sy-subrc EQ 0 AND
*
*        IF t180-trtyp EQ charh. "Only during creation
*          READ TABLE li_jkseflow INTO lst_jkseflow
*               WITH KEY issue = <lst_jksesched>-issue
*               BINARY SEARCH.
*          IF sy-subrc EQ 0.
*            <lst_jksesched>-xorder_created = abap_true.
*
*            lst_jkseflow-contract_vbeln = vbak-vbeln.
*            lst_jkseflow-contract_posnr = <lst_jksesched>-posnr.
*            APPEND lst_jkseflow TO li_ins_jflow.
*            CLEAR: lst_jkseflow.
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF.
*
*        READ TABLE <li_dlv_p_a> ASSIGNING FIELD-SYMBOL(<lst_dlv_p_a>) INDEX lv_tabix.
*        IF sy-subrc EQ 0.
*          MOVE-CORRESPONDING <lst_jksesched> TO <lst_dlv_p_a>.
*        ENDIF. " IF sy-subrc EQ 0
*      ENDLOOP. " LOOP AT li_jksesch_c ASSIGNING FIELD-SYMBOL(<lst_jksesched>)
*    ENDIF.
*
*    IF li_ins_jflow[] IS NOT INITIAL.
**     Update Document Flow for Generated Orders
*      CALL FUNCTION 'ISM_SE_JKSEFLOW_BOOK' IN UPDATE TASK
*        TABLES
*          insert_tab = li_ins_jflow.
*    ENDIF.
*  ENDIF. " IF sy-subrc EQ 0
*
*--------------------------------------------------------------------*
*-************* END of comment of code by SKKAIRAMKO - CR7899
*--------------------------------------------------------------------*
