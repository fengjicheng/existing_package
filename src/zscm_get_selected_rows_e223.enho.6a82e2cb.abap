"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\ME:HANDLE_USER_COMMAND\SE:BEGIN\EI
ENHANCEMENT 0 ZSCM_GET_SELECTED_ROWS_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Enhancement to get the Selected Records
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919750
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-10-01
* DESCRIPTION: LITHO Report Excel Download
*----------------------------------------------------------------------*

* Local Data
   DATA: LI_T_ROW  TYPE LVC_T_ROW,
         LS_T_ROW  TYPE LVC_S_ROW,
         LI_T_ROID TYPE LVC_T_ROID,
         lv_index  TYPE SYST_TABIX.

   " Check for Tcode
   IF sy-tcode = 'ZSCM_JKSD13_01' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*      sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
     sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
   " Check whether the Enhancement is active ot not
    IF v_aflag_e223 = abap_true OR
       v_aflag_r096 = abap_true. "OR
** BOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021
*       v_aflag_r096_002 = abap_true.
** EOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021
     " Get Selected Records
     CALL METHOD gv_alv_grid->get_selected_rows
       IMPORTING
         et_index_rows = LI_T_ROW
         et_row_no     = LI_T_ROID.

     IF SY-SUBRC = 0 AND LI_T_ROW[] IS NOT INITIAL.
       REFRESH i_outtab.
       SORT LI_T_ROW BY INDEX.
       LOOP AT LI_T_ROW INTO DATA(lst_row).
         lv_index = lst_row-index.
         " Get selected records which will be used in the Scrapping
         READ TABLE GT_OUTTAB INTO DATA(lst_outtab) INDEX lv_index.
         IF SY-SUBRC = 0.
           APPEND lst_outtab TO i_outtab.
           CLEAR: lst_row, lst_outtab, lv_index.
         ENDIF.
       ENDLOOP.
     ENDIF.

    ENDIF. " IF v_aflag_e223 = abap_true OR

   ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01'.

ENDENHANCEMENT.
