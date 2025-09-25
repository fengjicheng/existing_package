*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_MASS_VA05 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   05/07/2018
* OBJECT ID: E099
* TRANSPORT NUMBER(S): ED2K912009
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
TYPES: BEGIN OF lty_auart,
         vbeln TYPE vbeln_va,    " Sales Document
         posnr TYPE posnr_va,    " Sales Document Item
         auart TYPE auart,       " Sales Document Type
       END OF lty_auart,

       BEGIN OF lty_toauart,
         sign TYPE tvarv_sign,   " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti,   " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE auart,        " Sales Document Type
         high TYPE auart,        " Sales Document Type
       END OF  lty_toauart,

       BEGIN OF lty_tomatnr,
         sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE matnr,      " Sales Document Type
         high   TYPE matnr,      " Sales Document Type
       END OF lty_tomatnr.

DATA : li_vbap_keys_va05_2 TYPE tdt_sw_vbap_key, "Keys - Sales Document Item (VBAP)
       lst_vbap_key_va05_2 TYPE tds_sw_vbap_key, "Key Structure for VBAP
       lst_toauart         TYPE lty_toauart.


DATA : li_auart    TYPE STANDARD TABLE OF lty_auart INITIAL SIZE 0,
       li_toauart  TYPE STANDARD TABLE OF lty_toauart INITIAL SIZE 0,
       lir_tomatnr TYPE STANDARD TABLE OF lty_tomatnr INITIAL SIZE 0.
*       li_ct_result_copy   TYPE STANDARD TABLE OF any.

DATA:
  lo_dynamic_s_va05_2 TYPE REF TO data, "Data Reference (Structure)
  lo_dynamic_t_va05_2 TYPE REF TO data. "Data Reference (Table)

FIELD-SYMBOLS: <lst_result_va05_2> TYPE any,            "Result (Structure)
               <li_rng_tab_va05_2> TYPE table,          "Range Table
               <li_results_va05_2> TYPE STANDARD TABLE. "Result (Internal Table)

CONSTANTS:
*lc_ztro  TYPE auart VALUE 'ZTRO'.
  lc_e099         TYPE zdevid     VALUE 'E099',                           " Development ID
  lc_param1_tkor  TYPE rvari_vnam VALUE 'AUART',                          " ABAP: Name of Variant Variable
  lc_param2_tkor  TYPE rvari_vnam VALUE 'TORD',                           " ABAP: Name of Variant Variable
  lc_i            TYPE char1      VALUE 'I',                              " I of type CHAR1
  lc_eq           TYPE char2      VALUE 'EQ',                             " Eq of type CHAR2
  lv_tomatnr_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_MATNR2[]'. "Token Material

*** Select Data from CONSTANT Table
SELECT devid,    " Development ID
       param1,   " ABAP: Name of Variant Variable
       param2,   " ABAP: Name of Variant Variable
       srno,     " ABAP: Current selection number
       sign,     " ABAP: ID: I/E (include/exclude values)
       opti,     " ABAP: Selection option (EQ/BT/CP/...)
       low,      " Lower Value of Selection Condition
       high      " Upper Value of Selection Condition
FROM zcaconstant " Wiley Application Constant Table
INTO TABLE @DATA(li_constant)
WHERE devid    = @lc_e099
AND   activate = @abap_true.
IF sy-subrc = 0.
  SORT li_constant BY param1 param2.
  LOOP AT li_constant INTO DATA(lst_constant) WHERE param1 = lc_param1_tkor
                                               AND  param2 = lc_param2_tkor.
    lst_toauart-sign = lc_i.
    lst_toauart-opti = lc_eq.
    lst_toauart-low  = lst_constant-low.
    lst_toauart-high = lst_constant-high.

    APPEND lst_toauart TO li_toauart.
    CLEAR lst_toauart.
  ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant) WHERE param1 = lc_param1_tkor
ENDIF. " IF sy-subrc = 0
* Create Dynamic Table (Result)
CALL METHOD me->meth_create_dynamic_table
  EXPORTING
    im_ct_result = ct_result            "Current result table
  IMPORTING
    ex_dynamic_s = lo_dynamic_s_va05_2  "Data Reference (Structure)
    ex_dynamic_t = lo_dynamic_t_va05_2. "Data Reference (Table)
* Assignment of structure / internal table ref to the compatible field symbols
ASSIGN lo_dynamic_s_va05_2->* TO <lst_result_va05_2>.
ASSIGN lo_dynamic_t_va05_2->* TO <li_results_va05_2>.

*** Fetch Selection Screen Details from ABAP Stack
*** Token Material
ASSIGN (lv_tomatnr_va05) TO <li_rng_tab_va05_2>.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <li_rng_tab_va05_2> TO lir_tomatnr.
ENDIF. " IF sy-subrc = 0
*   li_ct_result_copy = ct_result.
* Identify Sales Document and Sales Document Item
*MOVE-CORRESPONDING ct_result TO li_vbap_keys_va05_2.
MOVE-CORRESPONDING ct_result TO li_auart.
IF li_auart IS NOT INITIAL.
*  DELETE li_auart WHERE auart NE lc_ztro.
  DELETE li_auart WHERE auart NOT IN li_toauart.
  MOVE-CORRESPONDING li_auart TO li_vbap_keys_va05_2.
  SORT li_vbap_keys_va05_2 BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_vbap_keys_va05_2
            COMPARING vbeln posnr.
  IF li_vbap_keys_va05_2 IS NOT INITIAL.
*** Select Data from  VBAP table
    SELECT vbeln,
           posnr,
           vgbel,
           vgpos, " Item number of the reference item
           matnr
      FROM vbap  " Sales Document: Item Data
      INTO TABLE @DATA(li_vbap1)
      FOR ALL ENTRIES IN @li_vbap_keys_va05_2
      WHERE vbeln EQ @li_vbap_keys_va05_2-vbeln
      AND   posnr EQ @li_vbap_keys_va05_2-posnr.
    IF sy-subrc = 0 AND li_vbap1 IS NOT INITIAL.
      SORT li_vbap1 BY vbeln posnr.
*** Selecting data again from VBAP to get Token Material
      SELECT vbeln,
             posnr,
             matnr  " Material Number
          FROM vbap " Sales Document: Item Data
        INTO TABLE @DATA(li_vbap2)
        FOR ALL ENTRIES IN @li_vbap1
        WHERE vbeln EQ @li_vbap1-vgbel
        AND   posnr EQ @li_vbap1-vgpos
        AND   matnr IN @lir_tomatnr.
      IF sy-subrc = 0.
        SORT li_vbap2 BY vbeln posnr.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc = 0 AND li_vbap1 IS NOT INITIAL
  ENDIF. " IF li_vbap_keys_va05_2 IS NOT INITIAL
ENDIF. " IF li_auart IS NOT INITIAL

IF li_vbap2 IS NOT INITIAL.
  LOOP AT ct_result ASSIGNING <lst_result_va05_2>.
    MOVE-CORRESPONDING <lst_result_va05_2> TO lst_vbap_key_va05_2.
    READ TABLE li_vbap1 INTO DATA(lst_vbap1)
    WITH KEY vbeln = lst_vbap_key_va05_2-vbeln
             posnr = lst_vbap_key_va05_2-posnr
             BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE li_vbap2 INTO DATA(lst_vbap2)
      WITH KEY vbeln = lst_vbap1-vgbel
               posnr = lst_vbap1-vgpos.
      IF sy-subrc = 0.
        ASSIGN COMPONENT 'TOKEN_MATNR' OF STRUCTURE <lst_result_va05_2> TO FIELD-SYMBOL(<lv_fld_token_matnr_va05_2>).
        IF sy-subrc = 0.
          <lv_fld_token_matnr_va05_2> = lst_vbap2-matnr.
          UNASSIGN <lv_fld_token_matnr_va05_2>.
          APPEND <lst_result_va05_2> TO <li_results_va05_2>.
        ENDIF. " IF sy-subrc = 0
        CLEAR lst_vbap2.
*---Begin of change VDPATABALL CR7836 -- If the data not found from the above read condition
      ELSE.
        ASSIGN COMPONENT 'TOKEN_MATNR' OF STRUCTURE <lst_result_va05_2> TO <lv_fld_token_matnr_va05_2>.
        IF sy-subrc = 0.
          <lv_fld_token_matnr_va05_2> = lst_vbap1-matnr.
          UNASSIGN <lv_fld_token_matnr_va05_2>.
          APPEND <lst_result_va05_2> TO <li_results_va05_2>.
        ENDIF. " IF sy-subrc = 0
        CLEAR lst_vbap2.
*---End of change VDPATABALL CR7836
      ENDIF. " IF sy-subrc = 0
      CLEAR lst_vbap1.

*      APPEND <lst_result_va05_2> TO <li_results_va05_2>.

    ELSE. " ELSE -> IF sy-subrc = 0
      IF lir_tomatnr IS INITIAL.
        APPEND <lst_result_va05_2> TO <li_results_va05_2>.
      ENDIF. " IF lir_tomatnr IS INITIAL
    ENDIF. " IF sy-subrc = 0

  ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result_va05_2>

  ct_result = <li_results_va05_2>.

ELSE. " ELSE -> IF li_vbap2 IS NOT INITIAL
  IF lir_tomatnr IS NOT INITIAL.
    CLEAR ct_result.
  ENDIF. " IF lir_tomatnr IS NOT INITIAL
ENDIF. " IF li_vbap2 IS NOT INITIAL
