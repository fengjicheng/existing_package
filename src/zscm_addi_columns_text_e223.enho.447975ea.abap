"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\ME:CONSTRUCTOR\SE:END\EI
ENHANCEMENT 0 ZSCM_ADDI_COLUMNS_TEXT_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223) / 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Enhancement for Additional Column Texts
* Modifications in Field Catalog to accommodate the Additional Columns
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-05-28
* DESCRIPTION: Journal First Print Optimization
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 21-AUG-2020
* DESCRIPTION: Register Event Handler Method: HANDLE_HOTSPOT_CLICK and
* Setting Column texts for LITHO Report Layou Fields
*-----------------------------------------------------------------------*

  " BOC: ERPM-837 KKRAVURI Litho Report Changes
  SET HANDLER ME->HANDLE_HOTSPOT_CLICK FOR GV_ALV_GRID.
  " EOC: ERPM-837 KKRAVURI Litho Report Changes

  IF i_enh_ctrl[] IS INITIAL.
    REFRESH: ir_devid, ir_vkey.
    st_devid-sign   = 'I'.
    st_devid-option = 'EQ'.
    st_devid-low    = c_e223.
    APPEND st_devid TO ir_devid.
    CLEAR st_devid-low.

    " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
    st_devid-sign   = 'I'.
    st_devid-option = 'EQ'.
    st_devid-low    = c_e244.
    APPEND st_devid TO ir_devid.
    CLEAR st_devid-low.
    " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

    st_devid-low    = c_r096.
    APPEND st_devid TO ir_devid.
    CLEAR st_devid.

    st_vkey-sign   = 'I'.
    st_vkey-option = 'EQ'.
    st_vkey-low    = c_vkey_scrapping.
    APPEND st_vkey TO ir_vkey.
    CLEAR st_vkey-low.

    " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
    st_vkey-sign   = 'I'.
    st_vkey-option = 'EQ'.
    st_vkey-low    = ' '.
    APPEND st_vkey TO ir_vkey.
    CLEAR st_vkey-low.
    " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

    st_vkey-low    = c_vkey_mi_plan.
    APPEND st_vkey TO ir_vkey.
    CLEAR st_vkey.

    SELECT wricef_id, ser_num, var_key, active_flag
           FROM zca_enh_ctrl INTO TABLE @i_enh_ctrl
           WHERE wricef_id IN @ir_devid AND
                 var_key IN @ir_vkey.
  ENDIF.

  IF i_enh_ctrl[] IS NOT INITIAL.
    READ TABLE i_enh_ctrl INTO st_enh_ctrl WITH KEY
         wricef_id = c_e223 ser_num = c_sno_001 var_key = c_vkey_scrapping.
    IF sy-subrc = 0.
      v_aflag_e223 = st_enh_ctrl-active_flag.
      CLEAR st_enh_ctrl.
    ENDIF.
    READ TABLE i_enh_ctrl INTO st_enh_ctrl WITH KEY
         wricef_id = c_r096 ser_num = c_sno_001 var_key = c_vkey_mi_plan.
    IF sy-subrc = 0.
      v_aflag_r096 = st_enh_ctrl-active_flag.
      CLEAR st_enh_ctrl.
    ENDIF.
**   BOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021
*    READ TABLE i_enh_ctrl INTO st_enh_ctrl WITH KEY
*         wricef_id = c_r096 ser_num = c_sno_002 var_key = c_vkey_mi_plan.
*    IF sy-subrc = 0.
*      v_aflag_r096_002 = st_enh_ctrl-active_flag.
*      CLEAR st_enh_ctrl.
*    ENDIF.
**   BOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021
    " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
    READ TABLE i_enh_ctrl INTO st_enh_ctrl WITH KEY
         wricef_id = c_e244 ser_num = c_sno_001.
    IF sy-subrc = 0.
      v_aflag_e244 = st_enh_ctrl-active_flag.
      CLEAR st_enh_ctrl.
    ENDIF.
    " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
  ENDIF.

  IF sy-tcode = 'ZSCM_JKSD13_01' OR
     sy-tcode = 'ZSCM_JKSD13_03' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*     sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
    sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
     LOOP AT gt_fieldcat INTO ls_fieldcat.
        CASE ls_fieldcat-fieldname.
          WHEN 'ISMREFMDPROD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 1.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MEDPROD_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 2.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MATNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 3.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MEDISSUE_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 4.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISMPUBLDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 5.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISMINITSHIPDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 6.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISMCOPYNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 7.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'TEXT_ICON'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 8.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MSTAV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 9.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MSTDV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 10.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MSTAE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 11.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MSTDE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 12.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISMYEARNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'PUB Year'.
            ls_fieldcat-JUST = 'L'.
            ls_fieldcat-col_pos = 13.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ZWKBST'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'ATP Qty'.
            ls_fieldcat-JUST = 'L'.
*            ls_fieldcat-LZERO = ' '.
            ls_fieldcat-col_pos = 14.
            MODIFY gt_fieldcat FROM ls_fieldcat. " ISMREFMDPROD_SAVE
          WHEN 'MARC_WERKS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 15.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_ISMPURCHASEDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 16.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEPL'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 17.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEAC'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 18.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTA'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 19.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 20.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK01'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 21.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_SFMEINS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 22.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
          WHEN 'STATUS'.
            ls_fieldcat-no_out = abap_true.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'Status'.
*            ls_fieldcat-col_opt = 'X'.
            ls_fieldcat-JUST = 'L'.
*            ls_fieldcat-col_pos = 13.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK10'.
            ls_fieldcat-no_out = abap_true.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'Planned Qty'.
            ls_fieldcat-JUST = 'L'.
            ls_fieldcat-quantity = 'EA'.
*            ls_fieldcat-col_pos = 14.
            ls_fieldcat-tech = abap_false.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
          WHEN OTHERS.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.

        ENDCASE.

      CLEAR ls_fieldcat.
     ENDLOOP.

     CALL METHOD GV_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT            = LS_LAYOUT
        IT_TOOLBAR_EXCLUDING = LT_EXCLUDE
        I_SAVE               = 'A'        "Save Layout
        IS_VARIANT           = LS_LAYOUT2 "Save Layout
      CHANGING
        IT_FIELDCATALOG      = GT_FIELDCAT
        IT_OUTTAB            = GT_OUTTAB.

   ELSE. " IF sy-tcode = 'ZSCM_JKSD13_01' OR
     " Hide all the Custom Fields for standard TCodes
     LOOP AT gt_fieldcat INTO ls_fieldcat.
        CASE ls_fieldcat-fieldname.
          WHEN 'ISMYEARNR'.    " Media issue year number
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ZWKBST'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'STATUS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK10'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISMNRINYEAR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'JOURNAL_CODE'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ML_PYEAR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'BL_PYEAR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'SUB_ACTUAL_PY'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'RENEWAL_PER'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'NOT_RENEWED_PER'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ML_CYEAR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'REN_CURR_SUBS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'BL_PCURR_YR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'PURCHASE_REQ'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          " BOC: ERPM-837 KKRAVURI Litho Report Changes
          WHEN 'PRINT_METHOD'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'PO_NUM'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'PO_CREATE_DT'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'PRINT_VENDOR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'DIST_VENDOR'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'DELV_PLANT'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ISSUE_TYPE'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'SUBS_PLAN'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'NEW_SUBS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ML_BL_PY'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ML_BL_CY'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'BL_BUFFER'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'SUBS_TO_PRINT'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OM_PLAN'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OM_ACTUAL'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OB_PLAN'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OB_ACTUAL'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OM_TO_PRINT'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'SUB_TOTAL'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'C_AND_E'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'AUTHOR_COPIES'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'EMLO_COPIES'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ADJUSTMENT'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'TOTAL_PO_QTY'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'ESTIMATED_SOH'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'INITIAL_SOH'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'CURRENT_SOH'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'REPRINT_QTY'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'REPRINT_PO_NO'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'REPRINT_REASON'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'REMARKS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'OM_INSTRUCTIONS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'COMMENTS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          WHEN 'VIEW_COMMENTS'.
            ls_fieldcat-no_out = abap_true.
            MODIFY gt_fieldcat FROM ls_fieldcat.
          " EOC: ERPM-837 KKRAVURI Litho Report Changes
          WHEN OTHERS.
            " Nothing to do
        ENDCASE.

      CLEAR ls_fieldcat.
     ENDLOOP.

     CALL METHOD GV_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT            = LS_LAYOUT
        IT_TOOLBAR_EXCLUDING = LT_EXCLUDE
        I_SAVE               = 'A'        "Save Layout
        IS_VARIANT           = LS_LAYOUT2 "Save Layout
      CHANGING
        IT_FIELDCATALOG      = GT_FIELDCAT
        IT_OUTTAB            = GT_OUTTAB.

   ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01' OR

ENDENHANCEMENT.
