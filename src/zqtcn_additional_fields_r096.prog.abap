*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADDITIONAL_FIELDS_R096 (Include)
* Called from Enhancement "ZSCM_UPDATE_ATP_QTY_E223(RJKSDWORKLIST_CLASS_LIST)"
* PROGRAM DESCRIPTION: LITHO Report Changes
* Update Additinal Column values for DIGITAL/LITHO Report
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE: 08/24/2021
* OBJECT ID: R096 - OTCM-45466
* TRANSPORT NUMBER(S): ED2K924372/ED2K925437
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* DEVELOPER:
* DATE:
* TRANSPORT NUMBER(S):
* DESCRIPTION: *
*&---------------------------------------------------------------------*
      DATA: lv_subs TYPE ddddlquantypes-quan13_3.
      " Get the Field Catalog
      REFRESH li_fcat.
      CALL METHOD gv_list->gv_alv_grid->get_frontend_fieldcatalog
        IMPORTING
          et_fieldcatalog = li_fcat.

      " Fetch PERCENT, ISSUE_PRINT_DATE variable from constant table
      IF li_constant[] IS INITIAL.
        SELECT devid, param1, param2, srno, sign, opti, low, high
               INTO TABLE @li_constant
               FROM zcaconstant
               WHERE devid = @lc_devid AND
                     activate = @abap_true.
      ENDIF.

      " Check for Report: LITHO/DIGITAL
      IF gv_filt = c_zd.

        " DIGITAL Report: Layout fields for DIGITAL Report
        LOOP AT li_fcat INTO lst_fcat.

          CASE lst_fcat-fieldname.
            WHEN 'ISMREFMDPROD'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 1.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MEDPROD_MAKTX'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 2.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MATNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 3.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MEDISSUE_MAKTX'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 4.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'IS_RENEWAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Renewal SUBS (Y/N)'.
              lst_fcat-outputlen = 16.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 5.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'IS_RENEWAL_OM'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Renewal OM (Y/N)'.
              lst_fcat-outputlen = 15.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 6.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PRINT_METHOD'.
              lst_fcat-no_out = abap_false.
              lst_fcat-edit = abap_true.
              lst_fcat-coltext = 'Print Method'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 7.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMYEARNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Pub Year'.
              lst_fcat-col_pos = 8.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'JOURNAL_CODE'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Acronym'.
              lst_fcat-col_pos = 9.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMCOPYNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-edit = abap_false.
              lst_fcat-coltext = 'Volume'.
              lst_fcat-col_pos = 10.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMNRINYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Issue Number'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 11.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'WBS_ELEMENT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'WBS Element'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 12.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PO_NUM'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer PO#'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 13.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PO_CREATE_DT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer PO Date'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 14.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PRINT_VENDOR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer'.
              lst_fcat-col_pos = 15.
              lst_fcat-just = 'L'.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'DIST_VENDOR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Distributor'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 16.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'DELV_PLANT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Deliv. Plant'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 17.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISSUE_TYPE'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Issue Type'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 18.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUB_ACTUAL_PY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Subs (Actual)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 19.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUBS_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Subs Plan'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 20.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'NEW_SUBS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'New Subs'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 21.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_PYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 18.
              lst_fcat-coltext = 'BL (PY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 22.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_PCURR_YR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 8.
              lst_fcat-coltext = 'BL (CY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 23.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_PYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 15.
              lst_fcat-coltext = 'ML (PY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 24.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_BL_PY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 18.
              lst_fcat-coltext = 'ML + BL (PY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 25.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_CYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 15.
              lst_fcat-coltext = 'ML (CY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 26.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_BL_CY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'ML + BL(CY)'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 27.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_BUFFER'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'BL Buffer'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 28.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PURCHASE_REQ'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 18.
              lst_fcat-coltext = 'Subs to Print'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 29.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM Plan'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 30.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_ACTUAL_TXT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM Actual'.
              lst_fcat-outputlen = 9.
              lst_fcat-just = 'L'.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 31.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OB_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OB Plan'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 32.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OB_ACTUAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OB Actual'.
              lst_fcat-outputlen = 9.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 33.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_TO_PRINT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM to Print'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 34.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUB_TOTAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Sub total(Subs + OM )'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 35.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'C_AND_E'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'C & E'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 36.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'AUTHOR_COPIES'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Author'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 37.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'EMLO_COPIES'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'EMLO'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 38.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ADJUSTMENT_TXT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Adjustment'.
              lst_fcat-hotspot = abap_true.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 39.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'TOTAL_PO_QTY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Print Run: Total PO Qty'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 40.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MARC_ISMARRIVALDATEAC'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Actual Goods Arrival'.
              lst_fcat-col_pos = 41.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ESTIMATED_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Estimated SOH'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 42.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'INITIAL_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'SOH Initial'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 43.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'CURRENT_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'SOH Current'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 44.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'REPRINT_QTY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Reprint Qty'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 45.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'REPRINT_PO_NO'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Reprint PO'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 46.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'COMMENTS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'Add Comments'.
              lst_fcat-just = 'C'.
              lst_fcat-icon = abap_true.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 47.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'VIEW_COMMENTS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'View Comments'.
              lst_fcat-just = 'C'.
              lst_fcat-icon = abap_true.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 48.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_PY_PS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'ML PY (Paid Subs only)'.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 49.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUBS_ACTUAL_PY_PS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'Subs Actual PY (Paid Subs only)'.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 50.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'RENEWAL_PER'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 13.
              lst_fcat-coltext = 'Renewal %'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 51.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'NOT_RENEWED_PER'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 13.
              lst_fcat-coltext = 'Not Renewed %'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 52.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'REN_CURR_SUBS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 18.
              lst_fcat-coltext = 'Renewal Cal. plus Current Year Subs'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 53.
              MODIFY li_fcat FROM lst_fcat.
            WHEN OTHERS.
              lst_fcat-no_out = abap_true.
              MODIFY li_fcat FROM lst_fcat.
          ENDCASE.

          CLEAR lst_fcat.
        ENDLOOP.

        " Range table parameters
        lst_wildcard-sign = 'I'.
        lst_wildcard-option = 'CP'.

        " Get 'Issue To Print Date' and 'Percentage' values
        LOOP AT li_constant INTO lst_constant.
          CASE lst_constant-param1.
            WHEN lc_percent.
              lv_percent = lst_constant-low.
            WHEN lc_pdate.
              lv_itpdate = lst_constant-low.
            WHEN OTHERS.
              " Nothing to do
          ENDCASE.
          CLEAR lst_constant.
        ENDLOOP.

        " FM Call: For Current Year, Current Period
        CALL FUNCTION 'DETERMINE_PERIOD'
          EXPORTING
            date                = sy-datum
*           PERIOD_IN           = '000'
            version             = lv_periv
          IMPORTING
            period              = lv_cprd
            year                = lv_cyear
          EXCEPTIONS
            period_in_not_valid = 1
            period_not_assigned = 2
            version_undefined   = 3
            OTHERS              = 4.
        IF sy-subrc = 0.
          lv_prd = lv_cprd.
        ENDIF.

        " Iterate the Media Issue Worklist to get the Media Issues of Previous Year
        LOOP AT i_statustab ASSIGNING <fs_wl>.
          APPEND INITIAL LINE TO li_pyr_data ASSIGNING <fs_pyr_data>.
          <fs_pyr_data>-plant = <fs_wl>-marc_werks.
          <fs_pyr_data>-ismrefmdprod = <fs_wl>-ismrefmdprod.
          <fs_pyr_data>-issue_no = <fs_wl>-ismnrinyear.
          <fs_pyr_data>-issue_num = <fs_wl>-ismnrinyear.
          lv_volume = <fs_wl>-ismcopynr.  " matnr+4(4).
          lv_volume = lv_volume - 1.             " Previous Year Volume
          <fs_pyr_data>-matnr = <fs_wl>-matnr.
          <fs_pyr_data>-matnr+4(4) = lv_volume.  " Previous Year Media Issue
          lv_pyear = <fs_wl>-ismyearnr.
          lv_pyear = lv_pyear - 1.
          <fs_pyr_data>-pyear = lv_pyear.        " Previous Year
          CLEAR: lv_pyear, lv_volume.
        ENDLOOP.

        " Extract all the Media Issues via CDS view with reference to report data
        IF i_statustab[] IS NOT  INITIAL.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          SELECT media_product, media_issue, print_method, pub_date,
*                 acronym, issue_no_unconv, issue_no, actual_goods_arrival,
*                 plant_marc, printer_po_number, printer_po_date,
*                 printer, distributor, delivering_plant, issue_type,
*                 om_actual, ob_actual, c_e, author, emlo, subs_actual,
*                 initial_soh, main_labels, back_labels, wbs_element,
*                 wbs_element_unconv
*                 FROM zcds_litho_001 INTO TABLE @li_litho_001_dig
*                 FOR ALL ENTRIES IN @i_statustab
*                 WHERE media_product = @i_statustab-ismrefmdprod AND
*                       media_issue = @i_statustab-matnr AND
*                       pub_date = @i_statustab-ismpubldate AND
*                       plant_marc = @i_statustab-marc_werks.
*          IF li_litho_001_dig[] IS NOT INITIAL.
*            SORT li_litho_001_dig BY media_issue pub_date plant_marc.
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          SELECT media_product, media_issue, print_method, pub_date,
                 acronym, issue_no_unconv, issue_no, actual_goods_arrival,
                 plant_marc, printer_po_number, printer_po_date,
                 printer, distributor, delivering_plant, issue_type,
                 om_actual, ob_actual, c_e, initial_soh, main_labels,
                 wbs_element, wbs_element_unconv
                 FROM zcds_litho_sp01 INTO TABLE @DATA(li_litho_sp01_dig)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_litho_sp01_dig[] IS NOT INITIAL.
            SORT li_litho_sp01_dig BY media_issue pub_date plant_marc.
          ENDIF.
          "--- Author Copies
          SELECT media_issue, author
                 FROM zcds_auth_sp02 INTO TABLE @DATA(li_auth_sp02_dig)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_auth_sp02_dig[] IS NOT INITIAL.
            SORT li_auth_sp02_dig BY media_issue.
          ENDIF.
          "--- EMLO
          SELECT media_issue, emlo
                 FROM zcds_emlo_sp02 INTO TABLE @DATA(li_emlo_sp02_dig)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_emlo_sp02_dig[] IS NOT INITIAL.
            SORT li_emlo_sp02_dig BY media_issue.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Fetch the Reprint PO, Reprint qty from CDS view 'zcds_litho_002'
          SELECT media_product, media_issue, pub_date,
                 pub_year, plant_marc, reprint_po, reprint_qty
                 FROM zcds_litho_002 INTO TABLE @li_litho_002_dig
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_litho_002_dig[] IS NOT INITIAL.
            SORT li_litho_002_dig BY media_issue.
          ENDIF.
*---BOI OTCM-45466 TDIMANTHA ED2K925437 "Replace select inside loop with a read statement
          " Fetch NEW_SUBS from CDS view 'zcds_litho_003'
          SELECT media_product, media_issue, pub_year, plant_marc, zzvyp, new_subs
              FROM zcds_litho_003 INTO TABLE @DATA(li_litho_003_tmp)
              FOR ALL ENTRIES IN @i_statustab
              WHERE media_issue = @i_statustab-matnr AND
                    zzvyp = @i_statustab-ismyearnr.
          IF sy-subrc = 0.
            SORT li_litho_003_tmp BY media_product media_issue pub_year plant_marc zzvyp.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925437
          " Fetch Log details
          SELECT media_product, media_issue, pub_date,
                 plant_marc, om_actual, adjustment
                 FROM zscm_worklistlog INTO TABLE @li_dig_log
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_dig_log[] IS NOT INITIAL.
            SORT li_dig_log BY media_issue pub_date plant_marc.
          ENDIF.
        ENDIF.
*---BOI OTCM-45466 TDIMANTHA ED2K925437 "Replace select inside loop with a read statement
        DATA: li_litho_003_digital LIKE li_litho_003_tmp.
        LOOP AT li_litho_003_tmp ASSIGNING FIELD-SYMBOL(<lf_litho_003>).
          AT NEW zzvyp.
            CLEAR lv_subs.
          ENDAT.
          lv_subs = lv_subs + <lf_litho_003>-new_subs.
          AT END OF zzvyp.
            <lf_litho_003>-new_subs = lv_subs.
            APPEND <lf_litho_003> TO li_litho_003_digital.
          ENDAT.
        ENDLOOP.
        SORT li_litho_003_digital BY media_issue plant_marc zzvyp.
        REFRESH: li_litho_003_tmp.
*---EOI OTCM-45466 TDIMANTHA ED2K925437
        " Extract the additional info of all the Media Issues
        " for previous year via CDS View
        IF li_pyr_data[] IS NOT INITIAL.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          SELECT media_product, media_issue, pub_date, pub_year,
*                 acronym, issue_no_unconv, issue_no,
*                 plant_marc, delivering_plant,
*                 om_actual, ob_actual, main_labels, back_labels, subs_actual
*                 FROM zcds_litho_001 INTO TABLE @li_litho_001_py_dig
*                 FOR ALL ENTRIES IN @li_pyr_data
*                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
*                       pub_year = @li_pyr_data-pyear AND
*                       plant_marc = @li_pyr_data-plant.
*          IF li_litho_001_py_dig[] IS NOT INITIAL.
*            SORT li_litho_001_py_dig BY media_product pub_date(6) issue_no_unconv plant_marc.
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          "--- Main Labels (PY)/ OB Plan
          SELECT media_product, media_issue, pub_date, pub_year,
                 print_method, issue_no_unconv, issue_no,
                 plant_marc, delivering_plant,
                 om_actual, ob_actual, main_labels
                 FROM zcds_litho_sp01 INTO TABLE @DATA(li_litho_sp01_py_dig)
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
                       pub_year = @li_pyr_data-pyear AND
                       plant_marc = @li_pyr_data-plant.
          IF li_litho_sp01_py_dig[] IS NOT INITIAL.
            SORT li_litho_sp01_py_dig BY media_product pub_date(6) issue_no_unconv plant_marc.
          ENDIF.
          "--- Subs Actual (PY)
          SELECT media_product, media_issue, print_method, pub_date,
                 pub_year, issue_no_unconv, issue_no, plant_marc,
                 subs_actual
                 FROM zcds_litho_sp04 INTO TABLE @DATA(li_litho_sp04_dig)
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
                       pub_year = @li_pyr_data-pyear AND
                       plant_marc = @li_pyr_data-plant.
          IF li_litho_sp04_dig[] IS NOT INITIAL.
            SORT li_litho_sp04_dig BY media_product pub_date(6) issue_no_unconv plant_marc.
          ENDIF.
          "--- Back Labels (PY)
          SELECT media_product, media_issue, print_method, pub_date,
                 pub_year, issue_no_unconv, issue_no, plant_marc,
                 back_labels
                 FROM zcds_litho_sp05 INTO TABLE @DATA(li_litho_sp05_dig)
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
                       pub_year = @li_pyr_data-pyear AND
                       plant_marc = @li_pyr_data-plant.
          IF li_litho_sp05_dig[] IS NOT INITIAL.
            SORT li_litho_sp05_dig BY media_product pub_date(6) issue_no_unconv plant_marc.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          " Fetch ML PYear from CDS view 'zcds_litho_006'
          SELECT matnr, ismrefmdprod, ismpubldate,
                ismyearnr, plant, media_issue_identify,
                issue_no_unconv, issue_no, ml_qty
                FROM zcds_litho_006 INTO TABLE @li_litho_006_py_dig
                FOR ALL ENTRIES IN @li_pyr_data
                     WHERE ismrefmdprod = @li_pyr_data-ismrefmdprod AND
                           matnr = @li_pyr_data-matnr AND
                           ismyearnr = @li_pyr_data-pyear AND
                           plant = @li_pyr_data-plant.
          IF li_litho_006_py_dig[] IS NOT INITIAL.
            SORT li_litho_006_py_dig BY ismrefmdprod ismpubldate(6) issue_no_unconv plant.
          ENDIF.

          " Fetch Max Issue of Pervious Year via zcds_jptmg0
          SELECT med_prod, matnr, ismnrinyear, ismnrinyear_num, ismyearnr
                 FROM zcds_jptmg0 INTO TABLE @li_jptmg0_max_issue_dig
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE med_prod = @li_pyr_data-ismrefmdprod AND
                       ismyearnr = @li_pyr_data-pyear.
          IF sy-subrc = 0.
            LOOP AT li_jptmg0_max_issue_dig ASSIGNING <lst_max_issue_dig>.
              " Ommiting the Supplements
              FIND 'S' IN <lst_max_issue_dig>-ismnrinyear.
              IF sy-subrc = 0.
                CLEAR <lst_max_issue_dig>-ismnrinyear_num.
              ELSE.
                <lst_max_issue_dig>-ismnrinyear_num = <lst_max_issue_dig>-ismnrinyear.
              ENDIF.
            ENDLOOP.
            DELETE li_jptmg0_max_issue_dig WHERE ismnrinyear_num IS INITIAL.
            SORT li_jptmg0_max_issue_dig BY med_prod ismyearnr ismnrinyear_num DESCENDING.
            DELETE ADJACENT DUPLICATES FROM li_jptmg0_max_issue_dig COMPARING med_prod ismyearnr.
            IF li_jptmg0_max_issue_dig[] IS NOT INITIAL.
              " Fetch the Subs (Plan), OM (Plan) for all Max Media Issues
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*              SELECT media_product, media_issue, pub_year, om_actual, subs_actual
*                     FROM zcds_litho_001 INTO TABLE @li_subs_plan_dig
*                     FOR ALL ENTRIES IN @li_jptmg0_max_issue_dig
*                     WHERE media_product = @li_jptmg0_max_issue_dig-med_prod AND
*                           media_issue = @li_jptmg0_max_issue_dig-matnr AND
*                           pub_year = @li_jptmg0_max_issue_dig-ismyearnr.
*              IF sy-subrc = 0.
*                SORT li_subs_plan_dig BY media_product pub_year.
*              ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
              SELECT media_product, media_issue, pub_year, om_actual
                     FROM zcds_litho_sp01 INTO TABLE @li_subs_plan_dig
                     FOR ALL ENTRIES IN @li_jptmg0_max_issue_dig
                     WHERE media_product = @li_jptmg0_max_issue_dig-med_prod AND
                           media_issue = @li_jptmg0_max_issue_dig-matnr AND
                           pub_year = @li_jptmg0_max_issue_dig-ismyearnr.
              IF sy-subrc = 0.
                SORT li_subs_plan_dig BY media_product pub_year.
              ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
              SELECT matnr, ismrefmdprod, ismpubldate,
                    ismyearnr, plant, media_issue_identify,
                    issue_no_unconv, issue_no, act_subs_qty
                    FROM zcds_litho_007 INTO TABLE @li_litho_007_py_dig
                    FOR ALL ENTRIES IN @li_jptmg0_max_issue_dig
                    WHERE ismrefmdprod = @li_jptmg0_max_issue_dig-med_prod AND
                          matnr = @li_jptmg0_max_issue_dig-matnr AND
                          ismyearnr = @li_jptmg0_max_issue_dig-ismyearnr.
              IF li_litho_007_py_dig[] IS NOT INITIAL.
                SORT li_litho_007_py_dig BY ismrefmdprod ismyearnr.
              ENDIF.

            ENDIF.
          ENDIF. " IF sy-subrc = 0.
        ENDIF. " IF li_pyr_data[] IS NOT INITIAL.

        " Fetch the Renewal Period for Subs/BL-Buffer information
        SELECT tm_type, matnr, sub_type, act_date,
               sub_flag, quantity, aenam, aedat
               FROM zscm_litho_tm INTO TABLE @li_litho_tm_dig.
        IF sy-subrc = 0.
          SORT li_litho_tm_dig BY tm_type sub_type matnr.
        ENDIF.

        " Fetch the Log Information
        SELECT extnumber, altext FROM balhdr INTO TABLE @li_balhdr_dig
                                 WHERE object = @lc_object AND
                                       subobject = @lc_subobj.
        IF sy-subrc = 0.
          SORT li_balhdr_dig BY extnumber.
          DELETE ADJACENT DUPLICATES FROM li_balhdr_dig COMPARING extnumber.
        ENDIF.

        " Prcoess the MI Worklist to derive values for Custom fileds of
        " DIGITAL Report
        LOOP AT gt_outtab INTO lst_worklist.
          lv_sytabix = sy-tabix.
          lv_counter = lv_counter + 1.

          " When the subsequent Media Issues are same
          IF lst_worklist-ismrefmdprod IS INITIAL AND lst_worklist-matnr IS INITIAL.
            lst_statustab = i_statustab[ lv_counter ].
            MOVE-CORRESPONDING lst_statustab TO lst_worklist.
            CLEAR lst_statustab.
          ENDIF.

          lv_pubdate = lst_worklist-ismpubldate(6).
          lv_pyear = lst_worklist-ismyearnr.
          lv_pyear = lv_pyear - 1.
          lv_pubdate(4) = lv_pyear.

          " Get the Additional Field values with reference to Report data
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          READ TABLE li_litho_001_dig INTO lst_litho_001_dig WITH KEY
*                                  media_issue = lst_worklist-matnr
*                                  pub_date = lst_worklist-ismpubldate
*                                  plant_marc = lst_worklist-marc_werks BINARY SEARCH.
*          IF sy-subrc = 0.
*            IF lst_litho_001_dig-plant_marc <> lst_litho_001_dig-delivering_plant.
*              DELETE gt_outtab INDEX lv_sytabix.
*              CLEAR lst_litho_001_dig.
*              CONTINUE.
*            ENDIF.
*            lst_worklist-print_method = lst_litho_001_dig-print_method.         " Print Method
*            lst_worklist-journal_code = lst_litho_001_dig-acronym.              " Acronym
*            lst_worklist-po_num       = lst_litho_001_dig-printer_po_number.    " Printer PO Number
*            lst_worklist-po_create_dt = lst_litho_001_dig-printer_po_date.      " Printer PO Created Date
*            lst_worklist-print_vendor = lst_litho_001_dig-printer.              " Printer
*            lst_worklist-dist_vendor  = lst_litho_001_dig-distributor.          " Distributor
*            lst_worklist-delv_plant   = lst_litho_001_dig-delivering_plant.     " Delivery Plant
*            lst_worklist-issue_type   = lst_litho_001_dig-issue_type.           " Issue Type
*            lst_worklist-ml_cyear     = lst_litho_001_dig-main_labels.          " ML (CY)
*            lst_worklist-om_actual    = lst_litho_001_dig-om_actual.            " OM (Actual)
*            lst_worklist-ob_actual    = lst_litho_001_dig-ob_actual.            " OB (Actual)
*            lst_worklist-c_and_e      = lst_litho_001_dig-c_e.                  " C & E
*            lst_worklist-author_copies =  lst_litho_001_dig-author.             " Author
*            lst_worklist-emlo_copies  = lst_litho_001_dig-emlo.                 " EMLO
*            lst_worklist-marc_ismarrivaldateac = lst_litho_001_dig-actual_goods_arrival.  " Actual Goods Arrival
*            lst_worklist-initial_soh = lst_litho_001_dig-initial_soh.           " SOH (Initial)
*            CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
*              EXPORTING
*                input  = lst_litho_001_dig-wbs_element_unconv
*              IMPORTING
*                output = lst_worklist-wbs_element.                              "WBS Element
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          READ TABLE li_litho_sp01_dig INTO DATA(lst_litho_sp01_dig) WITH KEY
                                  media_issue = lst_worklist-matnr
                                  pub_date = lst_worklist-ismpubldate
                                  plant_marc = lst_worklist-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_litho_sp01_dig-plant_marc <> lst_litho_sp01_dig-delivering_plant.
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_litho_sp01_dig.
              CONTINUE.
            ENDIF.
            lst_worklist-print_method = lst_litho_sp01_dig-print_method.         " Print Method
            lst_worklist-journal_code = lst_litho_sp01_dig-acronym.              " Acronym
            lst_worklist-po_num       = lst_litho_sp01_dig-printer_po_number.    " Printer PO Number
            lst_worklist-po_create_dt = lst_litho_sp01_dig-printer_po_date.      " Printer PO Created Date
            lst_worklist-print_vendor = lst_litho_sp01_dig-printer.              " Printer
            lst_worklist-dist_vendor  = lst_litho_sp01_dig-distributor.          " Distributor
            lst_worklist-delv_plant   = lst_litho_sp01_dig-delivering_plant.     " Delivery Plant
            lst_worklist-issue_type   = lst_litho_sp01_dig-issue_type.           " Issue Type
            lst_worklist-ml_cyear     = lst_litho_sp01_dig-main_labels.          " ML (CY)
            lst_worklist-om_actual    = lst_litho_sp01_dig-om_actual.            " OM (Actual)
            lst_worklist-ob_actual    = lst_litho_sp01_dig-ob_actual.            " OB (Actual)
            lst_worklist-c_and_e      = lst_litho_sp01_dig-c_e.                  " C & E
            lst_worklist-marc_ismarrivaldateac = lst_litho_sp01_dig-actual_goods_arrival.  " Actual Goods Arrival
            lst_worklist-initial_soh = lst_litho_sp01_dig-initial_soh.           " SOH (Initial)
            CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
              EXPORTING
                input  = lst_litho_sp01_dig-wbs_element_unconv
              IMPORTING
                output = lst_worklist-wbs_element.                              "WBS Element

            READ TABLE li_auth_sp02_dig INTO DATA(lst_auth_sp02_dig) WITH KEY
                                       media_issue = lst_worklist-matnr
                                       BINARY SEARCH.
            IF sy-subrc = 0.
              lst_worklist-author_copies =  lst_auth_sp02_dig-author.             " Author
            ENDIF.

            READ TABLE li_emlo_sp02_dig INTO DATA(lst_emlo_sp02_dig) WITH KEY
                                       media_issue = lst_worklist-matnr
                                       BINARY SEARCH.
            IF sy-subrc = 0.
              lst_worklist-emlo_copies  = lst_emlo_sp02_dig-emlo.                 " EMLO
            ENDIF.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          lv_issue_num = lst_worklist-ismnrinyear.
          IF lv_issue_num = '0001'.  " For First Issue
            IF lst_worklist-ml_cyear IS NOT INITIAL.
              lst_worklist-ren_curr_subs = lst_worklist-ml_cyear.                " Renewal Calculation plus Current Year Subs
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = lst_worklist-ren_curr_subs
                IMPORTING
                  output = lst_worklist-ren_curr_subs.
              lv_ren_curr_subs = lst_worklist-ren_curr_subs.
            ENDIF.
          ELSE.     " From Second Issue
            IF lst_worklist-renewal_per IS NOT INITIAL.
              IF lst_worklist-ml_cyear IS NOT INITIAL.
                lst_worklist-ren_curr_subs = ( lst_worklist-ml_cyear / lv_renewal_per ) * 100.
                CONDENSE lst_worklist-ren_curr_subs NO-GAPS.
                FIND '.' IN lst_worklist-ren_curr_subs MATCH OFFSET lv_off.
                IF sy-subrc <> 0.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = lst_worklist-ren_curr_subs
                    IMPORTING
                      output = lst_worklist-ren_curr_subs.
                  lv_ren_curr_subs = lst_worklist-ren_curr_subs.
                ELSEIF sy-subrc = 0.
                  lv_ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
                  lv_ren_curr_subs = lv_ren_curr_subs + 1.
                  lst_worklist-ren_curr_subs = lv_ren_curr_subs.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = lst_worklist-ren_curr_subs
                    IMPORTING
                      output = lst_worklist-ren_curr_subs.
*                  lv_off = lv_off + 3.
*                  lst_worklist-ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
                  CLEAR lv_off.
                ENDIF.
              ENDIF. " IF lst_worklist-ml_cyear IS NOT INITIAL.
            ENDIF. " IF lst_worklist-renewal_per IS NOT INITIAL.
          ENDIF. " IF lv_issue_num = '0001'.  " For First Issue

          " Get the Log values
          READ TABLE li_dig_log INTO lst_dig_log WITH KEY
                                  media_issue = lst_worklist-matnr
                                  pub_date = lst_worklist-ismpubldate
                                  plant_marc = lst_worklist-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*            IF lst_dig_log-plant_marc <> lst_litho_001_dig-delivering_plant.
            IF lst_dig_log-plant_marc <> lst_litho_sp01_dig-delivering_plant.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_dig_log.
              CONTINUE.
            ENDIF.
            lst_worklist-adjustment = lst_dig_log-adjustment.
            IF lst_dig_log-om_actual IS NOT INITIAL.
              lst_worklist-om_actual = lst_dig_log-om_actual.
            ENDIF.
          ENDIF.

          "Getting BL-Buffer
          READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_blbf
                                                                  sub_type = abap_false
                                                                  matnr = lst_worklist-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            IF sy-datum >= lst_litho_tm_dig-act_date.
              lst_worklist-bl_buffer = lst_litho_tm_dig-quantity.      " BL-Buffer
            ELSE.
              lst_worklist-bl_buffer = '0'.
            ENDIF.
            CLEAR lst_litho_tm_dig.
          ELSE.
            READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_blbf
                                                              sub_type = abap_false
                                                              matnr = lst_worklist-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              IF sy-datum >= lst_litho_tm_dig-act_date.
                lst_worklist-bl_buffer = lst_litho_tm_dig-quantity.    " BL-Buffer
              ELSE.
                lst_worklist-bl_buffer = '0'.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ELSE.
              READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_blbf
                                                                sub_type = abap_false
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                IF sy-datum >= lst_litho_tm_dig-act_date.
                  lst_worklist-bl_buffer = lst_litho_tm_dig-quantity.  " BL-Buffer
                ELSE.
                  lst_worklist-bl_buffer = '0'.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          " Subs (Plan), OM (Plan)
          lv_pyear = lst_worklist-ismyearnr.
          lv_pyear = lv_pyear - 1.   " Previous Year
          READ TABLE li_subs_plan_dig INTO lst_subs_plan_dig WITH KEY
                                  media_product = lst_worklist-ismrefmdprod
                                  pub_year = lv_pyear BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-om_plan   = lst_subs_plan_dig-om_actual.               " OM (Plan)
          ENDIF.

          READ TABLE li_litho_007_py_dig INTO lst_litho_007_py_dig WITH KEY
                                      ismrefmdprod = lst_worklist-ismrefmdprod
                                      ismyearnr = lv_pyear BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-subs_actual_py_ps = lst_litho_007_py_dig-act_subs_qty.       " Subs Actual PY (Paid Subs)
          ENDIF.

          lv_pubdate = lst_worklist-ismpubldate(6).
          lv_pubdate(4) = lv_pyear.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Get the Media Issue of Previous Year Copy based on Plant
*          READ TABLE li_litho_001_py_dig INTO lst_litho_001_py_dig WITH KEY
*                     media_product = lst_worklist-ismrefmdprod
*                     pub_date(6) = lv_pubdate
*                     issue_no_unconv = lst_litho_001_dig-issue_no_unconv
*                     plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
*          IF sy-subrc <> 0.
*            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*              EXPORTING
*                input  = lst_litho_001_dig-issue_no_unconv
*              IMPORTING
*                output = lst_litho_001_dig-issue_no_unconv.
*            " Get the Media Issue of Previous Year Copy
*            READ TABLE li_litho_001_py_dig INTO lst_litho_001_py_dig WITH KEY
*                       media_product = lst_worklist-ismrefmdprod
*                       pub_date(6) = lv_pubdate
*                       issue_no_unconv = lst_litho_001_dig-issue_no_unconv
*                       plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
*            IF sy-subrc <> 0.
*
*              " Nothing to do
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                EXPORTING
*                  input  = lst_litho_001_dig-issue_no_unconv
*                IMPORTING
*                  output = lst_litho_001_dig-issue_no_unconv.
*              " Get the Media Issue of Previous Year Copy
*              READ TABLE li_litho_001_py_dig INTO lst_litho_001_py_dig WITH KEY
*                          media_product = lst_worklist-ismrefmdprod
*                          pub_date(6) = lv_pubdate
*                          issue_no_unconv = lst_litho_001_dig-issue_no_unconv
*                          plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
*              IF sy-subrc <> 0.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*          IF sy-subrc = 0.
*            lst_worklist-ml_pyear = lst_litho_001_py_dig-main_labels.           " ML (PY)
*            lst_worklist-bl_pyear = lst_litho_001_py_dig-back_labels.           " BL (PY)
*            lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*            lst_worklist-ob_plan = lst_litho_001_py_dig-ob_actual.              " OB (Plan)
*            lst_worklist-sub_actual_py = lst_litho_001_py_dig-subs_actual.
*          ELSE.
*            li_litho1_py_tmp_dig = li_litho_001_py_dig.
*            DELETE li_litho1_py_tmp_dig WHERE media_product <> lst_worklist-ismrefmdprod AND
*                                          pub_date(6) <> lv_pubdate AND
*                                          issue_no_unconv <> lst_litho_001_dig-issue_no_unconv.
**---BOC OTCM-45466 TDIMANTHA ED2K925437 "Replace Loop statement with read statting from bottom
*            DATA(lv_py_lines) = lines( li_litho1_py_tmp_dig ).
*            DATA(lv_py_index) = lv_py_lines.
*            DO lv_py_lines TIMES.
*              READ TABLE li_litho1_py_tmp_dig ASSIGNING <lst_litho1_py_tmp_dig> INDEX lv_py_index.
*              IF sy-subrc = 0 AND <lst_litho1_py_tmp_dig>-plant_marc = <lst_litho1_py_tmp_dig>-delivering_plant.
*                lst_worklist-ml_pyear = <lst_litho1_py_tmp_dig>-main_labels.           " ML (PY)
*                lst_worklist-bl_pyear = <lst_litho1_py_tmp_dig>-back_labels.           " BL (PY)
*                lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*                lst_worklist-ob_plan = <lst_litho1_py_tmp_dig>-ob_actual.              " OB (Plan)
*                EXIT.
*              ELSE.
*                lv_py_index = lv_py_index - 1.
*              ENDIF.
*            ENDDO.
**            LOOP AT li_litho1_py_tmp_dig ASSIGNING <lst_litho1_py_tmp_dig>.
**              IF <lst_litho1_py_tmp_dig>-plant_marc = <lst_litho1_py_tmp_dig>-delivering_plant.
**                lst_worklist-ml_pyear = <lst_litho1_py_tmp_dig>-main_labels.           " ML (PY)
**                lst_worklist-bl_pyear = <lst_litho1_py_tmp_dig>-back_labels.           " BL (PY)
**                lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
**
**                lst_worklist-ob_plan = <lst_litho1_py_tmp_dig>-ob_actual.              " OB (Plan)
**                lst_worklist-sub_actual_py = <lst_litho1_py_tmp_dig>-subs_actual. "ED2K923462 TDIMANTHA 05/18/2021
**              ENDIF.
**            ENDLOOP.
*            CLEAR: li_litho1_py_tmp_dig[],lv_py_lines, lv_py_index.
**---EOC OTCM-45466 TDIMANTHA ED2K925437
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          "Get ML (PY)/ OB Plan
          READ TABLE li_litho_sp01_py_dig INTO DATA(lst_litho_sp01_py_dig) WITH KEY
                     media_product = lst_worklist-ismrefmdprod
                     pub_date(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                     plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01_dig-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01_dig-issue_no_unconv.
            " Get the Media Issue of Previous Year Copy
            READ TABLE li_litho_sp01_py_dig INTO lst_litho_sp01_py_dig WITH KEY
                       media_product = lst_worklist-ismrefmdprod
                       pub_date(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                       plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
            IF sy-subrc <> 0.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = lst_litho_sp01_dig-issue_no_unconv
                IMPORTING
                  output = lst_litho_sp01_dig-issue_no_unconv.
              " Get the Media Issue of Previous Year Copy
              READ TABLE li_litho_sp01_py_dig INTO lst_litho_sp01_py_dig WITH KEY
                          media_product = lst_worklist-ismrefmdprod
                          pub_date(6) = lv_pubdate
                          issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                          plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
              ENDIF.
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            lst_worklist-ml_pyear = lst_litho_sp01_py_dig-main_labels.           " ML (PY)
            lst_worklist-ob_plan = lst_litho_sp01_py_dig-ob_actual.              " OB (Plan)
          ELSE.
            DATA(li_litho_sp01_py_tmp_dig) = li_litho_sp01_py_dig.
            DELETE li_litho_sp01_py_tmp_dig WHERE media_product <> lst_worklist-ismrefmdprod AND
                                          pub_date(6) <> lv_pubdate AND
                                          issue_no_unconv <> lst_litho_sp01_dig-issue_no_unconv.

            DATA(lv_sp01_lines) = lines( li_litho_sp01_py_tmp_dig ).
            DATA(lv_sp01_index) = lv_sp01_lines.
            DO lv_sp01_lines TIMES.
              READ TABLE li_litho_sp01_py_tmp_dig ASSIGNING FIELD-SYMBOL(<lst_litho_sp01_py_tmp_dig>) INDEX lv_sp01_index.
              IF sy-subrc = 0 AND <lst_litho_sp01_py_tmp_dig>-plant_marc = <lst_litho_sp01_py_tmp_dig>-delivering_plant.
                lst_worklist-ml_pyear = <lst_litho_sp01_py_tmp_dig>-main_labels.           " ML (PY)
                lst_worklist-ob_plan = <lst_litho_sp01_py_tmp_dig>-ob_actual.              " OB (Plan)
                EXIT.
              ELSE.
                lv_sp01_index = lv_sp01_index - 1.
              ENDIF.
            ENDDO.
            CLEAR: li_litho_sp01_py_tmp_dig[],lv_sp01_lines, lv_sp01_index.
          ENDIF.

          " Get Subs Actual (PY)
          READ TABLE li_litho_sp04_dig INTO DATA(lst_litho_sp04_dig) WITH KEY
                     media_product = lst_worklist-ismrefmdprod
                     pub_date(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                     plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01_dig-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01_dig-issue_no_unconv.

            READ TABLE li_litho_sp04_dig INTO lst_litho_sp04_dig WITH KEY
                       media_product = lst_worklist-ismrefmdprod
                       pub_date(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                       plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
            IF sy-subrc <> 0.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = lst_litho_sp01_dig-issue_no_unconv
                IMPORTING
                  output = lst_litho_sp01_dig-issue_no_unconv.

              READ TABLE li_litho_sp04_dig INTO lst_litho_sp04_dig WITH KEY
                          media_product = lst_worklist-ismrefmdprod
                          pub_date(6) = lv_pubdate
                          issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                          plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
                "Nothing to Do
              ENDIF.
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            lst_worklist-sub_actual_py = lst_litho_sp04_dig-subs_actual. " Subs Actual (PY)
          ENDIF.

          " Get Back Labels (PY)
          READ TABLE li_litho_sp05_dig INTO DATA(lst_litho_sp05_dig) WITH KEY
                     media_product = lst_worklist-ismrefmdprod
                     pub_date(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                     plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01_dig-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01_dig-issue_no_unconv.

            READ TABLE li_litho_sp05_dig INTO lst_litho_sp05_dig WITH KEY
                       media_product = lst_worklist-ismrefmdprod
                       pub_date(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                       plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
            IF sy-subrc <> 0.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = lst_litho_sp01_dig-issue_no_unconv
                IMPORTING
                  output = lst_litho_sp01_dig-issue_no_unconv.

              READ TABLE li_litho_sp05_dig INTO lst_litho_sp05_dig WITH KEY
                          media_product = lst_worklist-ismrefmdprod
                          pub_date(6) = lv_pubdate
                          issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv
                          plant_marc = lst_litho_sp01_dig-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
                "Nothing to Do
              ENDIF.
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            lst_worklist-bl_pyear = lst_litho_sp05_dig-back_labels.  " BL (PY)
          ELSE.
            DATA(li_litho_sp05_tmp_dig) = li_litho_sp05_dig.
            DELETE li_litho_sp05_tmp_dig WHERE media_product <> lst_worklist-ismrefmdprod AND
                                          pub_date(6) <> lv_pubdate AND
                                          issue_no_unconv <> lst_litho_sp01_dig-issue_no_unconv.

            DATA(lv_sp05_lines) = lines( li_litho_sp05_tmp_dig ).
            DATA(lv_sp05_index) = lv_sp05_lines.
            DO lv_sp05_lines TIMES.
              READ TABLE li_litho_sp05_tmp_dig ASSIGNING FIELD-SYMBOL(<lst_litho_sp05_tmp_dig>) INDEX lv_sp05_index.
              IF sy-subrc = 0 AND <lst_litho_sp05_tmp_dig>-plant_marc = lst_worklist-delv_plant.
                lst_worklist-bl_pyear = <lst_litho_sp05_tmp_dig>-back_labels.           " BL (PY)
                EXIT.
              ELSE.
                lv_sp05_index = lv_sp05_index - 1.
              ENDIF.
            ENDDO.
            CLEAR: li_litho_sp05_tmp_dig[],lv_sp05_lines, lv_sp05_index.
          ENDIF.
          lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Get the Media Issue of Previous Year Copy based on Plant
          READ TABLE li_litho_006_py_dig INTO lst_litho_006_py_dig WITH KEY
                     ismrefmdprod = lst_worklist-ismrefmdprod
                     ismpubldate(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv "lst_litho_001_dig-issue_no_unconv
                     plant = lst_litho_sp01_dig-plant_marc BINARY SEARCH. "lst_litho_001_dig-plant_marc
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01_dig-issue_no_unconv "lst_litho_001_dig-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01_dig-issue_no_unconv. "lst_litho_001_dig-issue_no_unconv
            " Get the Media Issue of Previous Year Copy
            READ TABLE li_litho_006_py_dig INTO lst_litho_006_py_dig WITH KEY
                       ismrefmdprod = lst_worklist-ismrefmdprod
                       ismpubldate(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv  "lst_litho_001_dig-issue_no_unconv
                       plant = lst_litho_sp01_dig-plant_marc BINARY SEARCH.  "lst_litho_001_dig-plant_marc
            IF sy-subrc <> 0.
              " Nothing to do
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = lst_litho_sp01_dig-issue_no_unconv  "lst_litho_001_dig-issue_no_unconv
                IMPORTING
                  output = lst_litho_sp01_dig-issue_no_unconv.  "lst_litho_001_dig-issue_no_unconv
              " Get the Media Issue of Previous Year Copy
              READ TABLE li_litho_006_py_dig INTO lst_litho_006_py_dig WITH KEY
                          ismrefmdprod = lst_worklist-ismrefmdprod
                          ismpubldate(6) = lv_pubdate
                          issue_no_unconv = lst_litho_sp01_dig-issue_no_unconv  "lst_litho_001_dig-issue_no_unconv
                          plant = lst_litho_sp01_dig-plant_marc BINARY SEARCH.   "lst_litho_001_dig-plant_marc
              IF sy-subrc <> 0.
              ENDIF.
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            lst_worklist-ml_py_ps = lst_litho_006_py_dig-ml_qty.      "ML PY (Paid Subs)
          ENDIF.

          IF lst_worklist-subs_actual_py_ps IS NOT INITIAL.
            IF lst_worklist-ml_py_ps IS NOT INITIAL.
              lst_worklist-renewal_per = ( lst_worklist-ml_py_ps / lst_worklist-subs_actual_py_ps ) * 100.  " Renewal Percentage
              CONDENSE lst_worklist-renewal_per NO-GAPS.
              FIND '.' IN lst_worklist-renewal_per MATCH OFFSET lv_off.
              IF sy-subrc <> 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = lst_worklist-renewal_per
                  IMPORTING
                    output = lst_worklist-renewal_per.
                lv_renewal_per = lst_worklist-renewal_per.
              ELSEIF sy-subrc = 0.
                lv_renewal_per = lst_worklist-renewal_per+0(lv_off).
                lv_renewal_per = lv_renewal_per + 1.
                lst_worklist-renewal_per = lv_renewal_per.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = lst_worklist-renewal_per
                  IMPORTING
                    output = lst_worklist-renewal_per.
                CLEAR lv_off.
              ENDIF.
            ENDIF.
          ENDIF.

          IF lst_worklist-renewal_per IS NOT INITIAL.
            lv_renewal_per = lst_worklist-renewal_per.
            lst_worklist-not_renewed_per = 100 - lv_renewal_per.   " Not Renewed Percentage
            CONDENSE lst_worklist-not_renewed_per NO-GAPS.
          ENDIF.

          IF lst_worklist-marc_ismarrivaldateac < lv_itpdate.
            IF lst_worklist-sub_actual_py IS NOT INITIAL.
              lst_worklist-bl_pcurr_yr = ( lst_worklist-sub_actual_py * lv_percent ) / 100.
              CONDENSE lst_worklist-bl_pcurr_yr NO-GAPS.
              FIND '.' IN lst_worklist-bl_pcurr_yr MATCH OFFSET lv_off.
              IF sy-subrc <> 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = lst_worklist-bl_pcurr_yr
                  IMPORTING
                    output = lst_worklist-bl_pcurr_yr.
                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr.
              ELSEIF sy-subrc = 0.
                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr+0(lv_off).
                lv_bl_pcurr_yr = lv_bl_pcurr_yr + 1.
                lst_worklist-bl_pcurr_yr = lv_bl_pcurr_yr.                        " BL Planned Current Year
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = lst_worklist-bl_pcurr_yr
                  IMPORTING
                    output = lst_worklist-bl_pcurr_yr.
                CLEAR lv_off.
              ENDIF.
            ENDIF. " IF lst_worklist-sub_actual_py IS NOT INITIAL.
          ELSEIF lst_worklist-marc_ismarrivaldateac > lv_itpdate.
            CLEAR lst_worklist-bl_pcurr_yr.
          ENDIF.

          " Reprint Qty, Reprint PO No.
          LOOP AT li_litho_002_dig INTO lst_litho_0020_dig WHERE media_issue = lst_worklist-matnr.
            lst_worklist-reprint_qty = lst_worklist-reprint_qty + lst_litho_0020_dig-reprint_qty.
            IF lst_litho_0020_dig-reprint_po IS NOT INITIAL.
              IF lst_worklist-reprint_po_no IS INITIAL.
                lst_worklist-reprint_po_no = lst_litho_0020_dig-reprint_po.
              ELSE.
                lst_worklist-reprint_po_no = |{ lst_worklist-reprint_po_no }, { lst_litho_0020_dig-reprint_po }|.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_0020_dig.
          ENDLOOP.
*---BOC OTCM-45466 TDIMANTHA ED2K925437 "Replace select inside loop with a read statement
          " New_Subs
*          SELECT media_issue, pub_year, plant_marc, SUM( new_subs ) AS new_subs, zzvyp
*                 FROM zcds_litho_003 INTO TABLE @li_litho_003_dig
*                 WHERE media_issue = @lst_worklist-matnr AND
*                       plant_marc = @lst_worklist-marc_werks AND
*                       zzvyp = @lst_worklist-ismyearnr
*                 GROUP BY media_issue, pub_year, plant_marc, zzvyp.
*          IF sy-subrc = 0.
*            READ TABLE li_litho_003_dig INTO lst_litho_003_dig INDEX 1.
*            IF sy-subrc = 0.
*              lst_worklist-new_subs = lst_litho_003_dig-new_subs.                  " New_Subs
*              CLEAR: li_litho_003_dig[],lst_litho_0020_dig.
*            ENDIF.
*          ENDIF.

          READ TABLE li_litho_003_digital ASSIGNING FIELD-SYMBOL(<lf_litho_003_dig>)
                WITH KEY media_issue = lst_worklist-matnr
                         plant_marc = lst_worklist-marc_werks
                         zzvyp = lst_worklist-ismyearnr
                BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-new_subs = <lf_litho_003_dig>-new_subs.                  " New_Subs
          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925437
          " Subs to Print
          READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                            sub_type = lc_subs
                                                            matnr = lst_worklist-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-is_renewal = lst_litho_tm_dig-sub_flag.
            IF lst_litho_tm_dig-sub_flag = lc_y.
              IF sy-datum >= lst_litho_tm_dig-act_date.
                lst_worklist-subs_to_print = lst_worklist-subs_plan + lst_worklist-new_subs + lst_worklist-bl_buffer.
              ENDIF.
            ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
              IF sy-datum >= lst_litho_tm_dig-act_date.
                lst_worklist-subs_to_print = lst_worklist-sub_actual_py + lst_worklist-bl_pyear + lst_worklist-bl_buffer.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_tm_dig.
          ELSE.
            READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                              sub_type = lc_subs
                                                              matnr = lst_worklist-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              lst_worklist-is_renewal = lst_litho_tm_dig-sub_flag.
              IF lst_litho_tm_dig-sub_flag = lc_y.
                IF sy-datum >= lst_litho_tm_dig-act_date.
                  lst_worklist-subs_to_print = lst_worklist-subs_plan + lst_worklist-new_subs + lst_worklist-bl_buffer.
                ENDIF.
              ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                IF sy-datum >= lst_litho_tm_dig-act_date.
                  lst_worklist-subs_to_print = lst_worklist-sub_actual_py + lst_worklist-bl_pyear + lst_worklist-bl_buffer.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ELSE.
              READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                                sub_type = lc_subs
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                lst_worklist-is_renewal = lst_litho_tm_dig-sub_flag.
                IF lst_litho_tm_dig-sub_flag = lc_y.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_worklist-subs_to_print = lst_worklist-subs_plan + lst_worklist-new_subs + lst_worklist-bl_buffer.
                  ENDIF.
                ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_worklist-subs_to_print = lst_worklist-sub_actual_py + lst_worklist-bl_pyear + lst_worklist-bl_buffer.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          " OM to Print
          READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                            sub_type = lc_om
                                                            matnr = lst_worklist-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-is_renewal_om = lst_litho_tm_dig-sub_flag.
            IF lst_litho_tm_dig-sub_flag = lc_y.
              IF sy-datum >= lst_litho_tm_dig-act_date.
                lst_worklist-om_to_print = lst_worklist-om_plan + lst_worklist-ob_plan.
              ENDIF.
            ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
              IF sy-datum >= lst_litho_tm_dig-act_date.
                lst_worklist-om_to_print = lst_worklist-om_actual + lst_worklist-ob_plan.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_tm_dig.
          ELSE.
            READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                              sub_type = lc_om
                                                              matnr = lst_worklist-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              lst_worklist-is_renewal_om = lst_litho_tm_dig-sub_flag.
              IF lst_litho_tm_dig-sub_flag = lc_y.
                IF sy-datum >= lst_litho_tm_dig-act_date.
                  lst_worklist-om_to_print = lst_worklist-om_plan + lst_worklist-ob_plan.
                ENDIF.
              ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                IF sy-datum >= lst_litho_tm_dig-act_date.
                  lst_worklist-om_to_print = lst_worklist-om_actual + lst_worklist-ob_plan.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ELSE.
              READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                                sub_type = lc_om
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                lst_worklist-is_renewal_om = lst_litho_tm_dig-sub_flag.
                IF lst_litho_tm_dig-sub_flag = lc_y.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_worklist-om_to_print = lst_worklist-om_plan + lst_worklist-ob_plan.
                  ENDIF.
                ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_worklist-om_to_print = lst_worklist-om_actual + lst_worklist-ob_plan.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm_dig.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          lst_worklist-purchase_req = lst_worklist-ren_curr_subs + lst_worklist-bl_buffer.  " New Subs Purchase Request For Current Year
          lst_worklist-sub_total = lst_worklist-purchase_req + lst_worklist-om_actual.

          " PRINT RUN: TOTAL PO QTY
          lst_worklist-total_po_qty = lst_worklist-sub_total + lst_worklist-c_and_e + lst_worklist-author_copies +
                                        lst_worklist-emlo_copies + lst_worklist-adjustment.

          " Estimated SOH
          lst_worklist-estimated_soh = lst_worklist-total_po_qty - lst_worklist-ml_cyear - lst_worklist-om_actual -
                                         lst_worklist-c_and_e - lst_worklist-author_copies - lst_worklist-emlo_copies.

          " Assign the Log Icon
          lst_worklist-comments = lc_comments.
          lv_external_num_dig = |{ lst_worklist-matnr }{ lst_worklist-marc_werks }|.
          READ TABLE li_balhdr_dig WITH KEY extnumber = lv_external_num_dig
                               BINARY SEARCH
                               TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            lst_worklist-view_comments = lc_vcomments.
          ENDIF.

          " Change Adjustment & OM Actual
          lst_worklist-om_actual_txt = lst_worklist-om_actual.
          SHIFT lst_worklist-om_actual_txt LEFT DELETING LEADING '0'.
          CONDENSE lst_worklist-om_actual_txt.
          CONCATENATE lc_comments lst_worklist-om_actual_txt INTO lst_worklist-om_actual_txt SEPARATED BY space.
          lst_worklist-adjustment_txt = lst_worklist-adjustment.
          CONDENSE lst_worklist-adjustment_txt.
          CONCATENATE lc_comments lst_worklist-adjustment_txt INTO lst_worklist-adjustment_txt SEPARATED BY space.

          " Clear the structures
          CLEAR: lst_litho_001_py_dig, lst_litho_sp01_dig,lst_litho_003_dig, "lst_litho_004_dig, lst_litho_001_dig
                 lst_subs_plan_dig, lst_litho_tm_dig, lst_dig_log, lst_litho_006_py_dig,lst_litho_007_py_dig,
                 lst_litho_sp04_dig, lst_litho_sp05_dig, lst_litho_sp01_py_dig, lst_auth_sp02_dig, lst_emlo_sp02_dig.

          CLEAR: lst_worklist-is_renewal, lst_worklist-is_renewal_om, lst_worklist-sub_actual_py,
                 lst_worklist-subs_plan, lst_worklist-bl_pcurr_yr, lst_worklist-ml_bl_cy.

          MODIFY gt_outtab FROM lst_worklist INDEX lv_sytabix.
          CLEAR: lst_worklist, lst_md_is_unsm, lst_max_issue_f,lv_issue_num, "lst_mi_unsm_pyd,
                 lr_wildcard[], li_max_issue[], li_max_issue_f[], lv_sytabix, lv_sub_actual_py,
                 lv_bl_pcurr_yr, lv_ren_curr_subs, lv_renewal_per.

        ENDLOOP.

      ELSEIF gv_filt = c_zl.

        " LITHO Report: Layout fields for LITHO Report
        LOOP AT li_fcat INTO lst_fcat.
          CASE lst_fcat-fieldname.
              " LITHO Report Layout Fields
            WHEN 'ISMREFMDPROD'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 1.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MEDPROD_MAKTX'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 2.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MATNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 3.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MEDISSUE_MAKTX'.
              lst_fcat-no_out = abap_false.
              lst_fcat-col_pos = 4.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'IS_RENEWAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Renewal SUBS (Y/N)'.
              lst_fcat-outputlen = 16.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 5.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'IS_RENEWAL_OM'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Renewal OM (Y/N)'.
              lst_fcat-outputlen = 15.
              lst_fcat-just = 'C'.
              lst_fcat-col_pos = 6.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PRINT_METHOD'.
              lst_fcat-no_out = abap_false.
              lst_fcat-edit = abap_true.
              lst_fcat-f4availabl = abap_true.
              lst_fcat-coltext = 'Print Method'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 7.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMYEARNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Pub Year'.
              lst_fcat-col_pos = 8.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'JOURNAL_CODE'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Acronym'.
              lst_fcat-col_pos = 9.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMCOPYNR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-edit = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Volume'.
              lst_fcat-col_pos = 10.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'WBS_ELEMENT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'WBS Element'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 11.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISMNRINYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-edit = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Issue No'.
              lst_fcat-col_pos = 12.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PO_NUM'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer PO#'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 13.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PO_CREATE_DT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer PO Date'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 14.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'PRINT_VENDOR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Printer'.
              lst_fcat-col_pos = 15.
              lst_fcat-just = 'L'.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'DIST_VENDOR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Distributor'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 16.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'DELV_PLANT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Deliv. Plant'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 17.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ISSUE_TYPE'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Issue Type'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 18.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUB_ACTUAL_PY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Subs (Actual)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 19.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUBS_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Subs Plan'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 20.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'NEW_SUBS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'New Subs'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 21.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_PYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 8.
              lst_fcat-coltext = 'BL (PY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 22.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_PCURR_YR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 8.
              lst_fcat-coltext = 'BL (CY)'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 23.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_PYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'ML (PY)'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 24.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_BL_PY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'ML + BL(PY)'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 25.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_CYEAR'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'ML (CY)'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 26.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ML_BL_CY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'ML + BL(CY)'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 27.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'BL_BUFFER'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'BL Buffer'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 28.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUBS_TO_PRINT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Subs to Print'.
              lst_fcat-outputlen = 11.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 29.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM Plan'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 30.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_ACTUAL_TXT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM Actual'.
              lst_fcat-outputlen = 9.
              lst_fcat-just = 'L'.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 31.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OB_PLAN'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OB Plan'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 32.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OB_ACTUAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OB Actual'.
              lst_fcat-outputlen = 9.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 33.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'OM_TO_PRINT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'OM to Print'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 34.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'SUB_TOTAL'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Sub total(Subs + OM)'.
              lst_fcat-outputlen = 10.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 35.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'C_AND_E'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'C & E'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 36.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'AUTHOR_COPIES'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Author'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 37.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'EMLO_COPIES'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'EMLO'.
              lst_fcat-outputlen = 8.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 38.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ADJUSTMENT_TXT'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Adjustment'.
              lst_fcat-hotspot = abap_true.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 39.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'TOTAL_PO_QTY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-coltext = 'Print Run: Total PO Qty'.
              lst_fcat-outputlen = 12.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 40.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'MARC_ISMARRIVALDATEAC'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Actual Goods Arrival'.
              lst_fcat-col_pos = 41.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'ESTIMATED_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Estimated SOH'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 42.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'INITIAL_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'SOH Initial'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 43.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'CURRENT_SOH'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'SOH Current'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 44.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'REPRINT_QTY'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 10.
              lst_fcat-coltext = 'Reprint Qty'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 45.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'REPRINT_PO_NO'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 12.
              lst_fcat-coltext = 'Reprint PO'.
              lst_fcat-just = 'L'.
              lst_fcat-col_pos = 46.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'COMMENTS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'Add Comments'.
              lst_fcat-just = 'C'.
              lst_fcat-icon = abap_true.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 47.
              MODIFY li_fcat FROM lst_fcat.
            WHEN 'VIEW_COMMENTS'.
              lst_fcat-no_out = abap_false.
              lst_fcat-outputlen = 14.
              lst_fcat-coltext = 'View Comments'.
              lst_fcat-just = 'C'.
              lst_fcat-icon = abap_true.
              lst_fcat-hotspot = abap_true.
              lst_fcat-col_pos = 48.
              MODIFY li_fcat FROM lst_fcat.
            WHEN OTHERS.
              lst_fcat-no_out = abap_true.
              MODIFY li_fcat FROM lst_fcat.
          ENDCASE.

          CLEAR lst_fcat.
        ENDLOOP.

        " Get the Fiscal Year Variant
        READ TABLE li_constant INTO lst_constant WITH KEY devid = lc_devid
                                                         param1 = lc_periv
                                                         param2 = lc_fyear_var.
        IF sy-subrc = 0.
          lv_periv = lst_constant-low.
        ELSE.
          lv_periv = lc_w1.
        ENDIF.

        " FM Call: For Current Year, Current Period
        CALL FUNCTION 'DETERMINE_PERIOD'
          EXPORTING
            date                = sy-datum
*           PERIOD_IN           = '000'
            version             = lv_periv
          IMPORTING
            period              = lv_cprd
            year                = lv_cyear
          EXCEPTIONS
            period_in_not_valid = 1
            period_not_assigned = 2
            version_undefined   = 3
            OTHERS              = 4.
        IF sy-subrc = 0.
          lv_prd = lv_cprd.
        ENDIF.

        " Iterate the Media Issue Worklist to get the Media Issues of Previous Year
        LOOP AT i_statustab ASSIGNING <fs_wl>.
          APPEND INITIAL LINE TO li_pyr_data ASSIGNING <fs_pyr_data>.
          <fs_pyr_data>-plant = <fs_wl>-marc_werks.
          <fs_pyr_data>-ismrefmdprod = <fs_wl>-ismrefmdprod.
          <fs_pyr_data>-issue_no = <fs_wl>-ismnrinyear.
          <fs_pyr_data>-issue_num = <fs_wl>-ismnrinyear.
          lv_volume = <fs_wl>-ismcopynr.  " matnr+4(4).
          lv_volume = lv_volume - 1.             " Previous Year Volume
          <fs_pyr_data>-matnr = <fs_wl>-matnr.
          <fs_pyr_data>-matnr+4(4) = lv_volume.  " Previous Year Media Issue
          lv_pyear = <fs_wl>-ismyearnr.
          lv_pyear = lv_pyear - 1.
          <fs_pyr_data>-pyear = lv_pyear.        " Previous Year
          CLEAR: lv_pyear, lv_volume.
        ENDLOOP.

        " Extract the additional info of all the Media Issues
        " via CDS view 'li_litho_001' with reference to report data
        IF i_statustab[] IS NOT INITIAL.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          SELECT media_product, media_issue, print_method, pub_date,
*                 acronym, issue_no_unconv, issue_no, actual_goods_arrival,
*                 plant_marc, printer_po_number, printer_po_date,
*                 printer, distributor, delivering_plant, issue_type,
*                 om_actual, ob_actual, c_e, author, emlo, subs_actual,
*                 initial_soh, main_labels, back_labels, wbs_element,
*                 wbs_element_unconv
*                 FROM zcds_litho_001 INTO TABLE @li_litho_001
*                 FOR ALL ENTRIES IN @i_statustab
*                 WHERE media_product = @i_statustab-ismrefmdprod AND
*                       media_issue = @i_statustab-matnr AND
*                       pub_date = @i_statustab-ismpubldate AND
*                       plant_marc = @i_statustab-marc_werks.
*          IF li_litho_001[] IS NOT INITIAL.
*            SORT li_litho_001 BY media_issue pub_date plant_marc.
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          SELECT media_product, media_issue, print_method, pub_date,
                 acronym, issue_no_unconv, issue_no, actual_goods_arrival,
                 plant_marc, printer_po_number, printer_po_date,
                 printer, distributor, delivering_plant, issue_type,
                 om_actual, ob_actual, c_e, initial_soh, main_labels,
                 wbs_element, wbs_element_unconv
                 FROM zcds_litho_sp01 INTO TABLE @DATA(li_litho_sp01)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_litho_sp01[] IS NOT INITIAL.
            SORT li_litho_sp01 BY media_issue pub_date plant_marc.
          ENDIF.

          "--- Author Copies
          SELECT media_issue, author
                 FROM zcds_auth_sp02 INTO TABLE @DATA(li_auth_sp02)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_auth_sp02[] IS NOT INITIAL.
            SORT li_auth_sp02 BY media_issue.
          ENDIF.
          "--- EMLO
          SELECT media_issue, emlo
                 FROM zcds_emlo_sp02 INTO TABLE @DATA(li_emlo_sp02)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_emlo_sp02[] IS NOT INITIAL.
            SORT li_emlo_sp02 BY media_issue.
          ENDIF.

          "--- Subs Actual
          SELECT media_product, media_issue, print_method, pub_date,
                 pub_year, issue_no_unconv, issue_no, plant_marc,
                 subs_actual
                 FROM zcds_litho_sp04 INTO TABLE @DATA(li_litho_sp04)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_litho_sp04[] IS NOT INITIAL.
            SORT li_litho_sp04 BY media_issue pub_date plant_marc.
          ENDIF.
          "--- Back Labels (CY)
          SELECT media_product, media_issue, print_method, pub_date,
                 pub_year, issue_no_unconv, issue_no, plant_marc,
                 back_labels
                 FROM zcds_litho_sp05 INTO TABLE @DATA(li_litho_sp05)
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_litho_sp05[] IS NOT INITIAL.
            SORT li_litho_sp05 BY media_issue pub_date plant_marc.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022

          " Fetch the Reprint PO, Reprint qty from CDS view 'zcds_litho_002'
          SELECT media_product, media_issue, pub_date,
                 pub_year, plant_marc, reprint_po, reprint_qty
                 FROM zcds_litho_002 INTO TABLE @li_litho_002
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr.
          IF li_litho_002[] IS NOT INITIAL.
            SORT li_litho_002 BY media_issue.
          ENDIF.
*---BOI OTCM-45466 TDIMANTHA ED2K925437 "Replace Loop statement with read statement
          " Fetch NEW_SUBS from CDS view 'zcds_litho_003'
          SELECT media_product, media_issue, pub_year, plant_marc, zzvyp, new_subs
              FROM zcds_litho_003 INTO TABLE @DATA(li_litho_003_tmp1)
              FOR ALL ENTRIES IN @i_statustab
              WHERE media_issue = @i_statustab-matnr AND
                    zzvyp = @i_statustab-ismyearnr.
          IF sy-subrc = 0.
            SORT li_litho_003_tmp1 BY media_product media_issue pub_year plant_marc zzvyp.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925437
          " Fetch SOH (Current) from CDS view 'zcds_litho_004'
          SELECT media_product, media_issue, pub_date,
                 pub_year, plant_marc, soh
                 FROM zcds_litho_004 INTO TABLE @li_litho_004
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_issue = @i_statustab-matnr AND
                       plant_marc = @i_statustab-marc_werks AND
                       lfgja = @lv_cyear AND
                       lfmon = @lv_prd.
          IF li_litho_004[] IS NOT INITIAL.
            SORT li_litho_004 BY media_issue plant_marc.
          ENDIF.

          " Fetch Log details
          SELECT media_product, media_issue, pub_date,
                 plant_marc, om_actual, adjustment
                 FROM zscm_worklistlog INTO TABLE @li_litho_log
                 FOR ALL ENTRIES IN @i_statustab
                 WHERE media_product = @i_statustab-ismrefmdprod AND
                       media_issue = @i_statustab-matnr AND
                       pub_date = @i_statustab-ismpubldate AND
                       plant_marc = @i_statustab-marc_werks.
          IF li_litho_log[] IS NOT INITIAL.
            SORT li_litho_log BY media_issue pub_date plant_marc.
          ENDIF.

        ENDIF. " IF i_statustab[] IS NOT INITIAL.

        " Extract the additional info of all the Media Issues
        " for previous year via CDS View
        IF li_pyr_data[] IS NOT INITIAL.
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          SELECT media_product, media_issue, pub_date, pub_year,
*                 acronym, issue_no_unconv, issue_no,
*                 plant_marc, delivering_plant,
*                 om_actual, ob_actual, main_labels, back_labels
*                 FROM zcds_litho_001 INTO TABLE @li_litho_001_py
*                 FOR ALL ENTRIES IN @li_pyr_data
*                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
*                       pub_year = @li_pyr_data-pyear AND
*                       plant_marc = @li_pyr_data-plant.
*          IF li_litho_001_py[] IS NOT INITIAL.
*            SORT li_litho_001_py BY media_product pub_date(6) issue_no_unconv plant_marc.
*          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          SELECT media_product, media_issue, pub_date, pub_year,
                 acronym, issue_no_unconv, issue_no,
                 plant_marc, delivering_plant,
                 om_actual, ob_actual, main_labels
                 FROM zcds_litho_sp01 INTO TABLE @DATA(li_litho_sp01_py)
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
                       pub_year = @li_pyr_data-pyear AND
                       plant_marc = @li_pyr_data-plant.
          IF li_litho_sp01_py[] IS NOT INITIAL.
            SORT li_litho_sp01_py BY media_product pub_date(6) issue_no_unconv plant_marc.
          ENDIF.
          "--- Back Labels (PY)
          SELECT media_product, media_issue, print_method, pub_date,
                 pub_year, issue_no_unconv, issue_no, plant_marc,
                 back_labels
                 FROM zcds_litho_sp05 INTO TABLE @DATA(li_litho_sp05_py)
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
                       pub_year = @li_pyr_data-pyear AND
                       plant_marc = @li_pyr_data-plant.
          IF li_litho_sp05_py[] IS NOT INITIAL.
            SORT li_litho_sp05_py BY media_product pub_date(6) issue_no_unconv plant_marc.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Fetch Max Issue of Pervious Year via zcds_jptmg0
          SELECT med_prod, matnr, ismnrinyear, ismnrinyear_num, ismyearnr
                 FROM zcds_jptmg0 INTO TABLE @li_jptmg0_max_issue
                 FOR ALL ENTRIES IN @li_pyr_data
                 WHERE med_prod = @li_pyr_data-ismrefmdprod AND
                       ismyearnr = @li_pyr_data-pyear.
          IF sy-subrc = 0.
            LOOP AT li_jptmg0_max_issue ASSIGNING <lst_max_issue>.
              " Ommiting the Supplements
              FIND 'S' IN <lst_max_issue>-ismnrinyear.
              IF sy-subrc = 0.
                CLEAR <lst_max_issue>-ismnrinyear_num.
              ELSE.
                <lst_max_issue>-ismnrinyear_num = <lst_max_issue>-ismnrinyear.
              ENDIF.
            ENDLOOP.
            DELETE li_jptmg0_max_issue WHERE ismnrinyear_num IS INITIAL.
            SORT li_jptmg0_max_issue BY med_prod ismyearnr ismnrinyear_num DESCENDING.
            DELETE ADJACENT DUPLICATES FROM li_jptmg0_max_issue COMPARING med_prod ismyearnr.
            IF li_jptmg0_max_issue[] IS NOT INITIAL.
              " Fetch the Subs (Plan), OM (Plan) for all Max Media Issues
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*              SELECT media_product, media_issue, pub_year, om_actual, subs_actual
*                     FROM zcds_litho_001 INTO TABLE @li_subs_plan
*                     FOR ALL ENTRIES IN @li_jptmg0_max_issue
*                     WHERE media_product = @li_jptmg0_max_issue-med_prod AND
*                           media_issue = @li_jptmg0_max_issue-matnr AND
*                           pub_year = @li_jptmg0_max_issue-ismyearnr.
*              IF sy-subrc = 0.
*                SORT li_subs_plan BY media_product pub_year.
*              ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
              SELECT media_product, media_issue, pub_year, subs_actual
                     FROM zcds_litho_sp04 INTO TABLE @DATA(li_subs_plan_new)
                     FOR ALL ENTRIES IN @li_jptmg0_max_issue
                     WHERE media_product = @li_jptmg0_max_issue-med_prod AND
                           media_issue = @li_jptmg0_max_issue-matnr AND
                           pub_year = @li_jptmg0_max_issue-ismyearnr.
              IF sy-subrc = 0.
                SORT li_subs_plan_new BY media_product pub_year.
              ENDIF.
              SELECT media_product, media_issue, pub_year, om_actual
                     FROM zcds_litho_sp01 INTO TABLE @DATA(li_om_plan)
                     FOR ALL ENTRIES IN @li_jptmg0_max_issue
                     WHERE media_product = @li_jptmg0_max_issue-med_prod AND
                           media_issue = @li_jptmg0_max_issue-matnr AND
                           pub_year = @li_jptmg0_max_issue-ismyearnr.
              IF sy-subrc = 0.
                SORT li_om_plan BY media_product pub_year.
              ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
            ENDIF.
          ENDIF. " IF sy-subrc = 0.
        ENDIF. " IF li_pyr_data[] IS NOT INITIAL.

        " Fetch the Renewal Period for Subs/BL-Buffer information
        SELECT tm_type, matnr, sub_type, act_date,
               sub_flag, quantity, aenam, aedat
               FROM zscm_litho_tm INTO TABLE @li_litho_tm.
        IF sy-subrc = 0.
          SORT li_litho_tm BY tm_type sub_type matnr.
        ENDIF.

        " Fetch the Log Information
        SELECT extnumber, altext FROM balhdr INTO TABLE @li_balhdr
                                 WHERE object = @lc_object AND
                                       subobject = @lc_subobj.
        IF sy-subrc = 0.
          SORT li_balhdr BY extnumber.
          DELETE ADJACENT DUPLICATES FROM li_balhdr COMPARING extnumber.
        ENDIF.
*---BOI OTCM-45466 TDIMANTHA ED2K925437 "Replace Loop statement with read statement
        DATA: li_litho_003_new LIKE li_litho_003_tmp1.
        LOOP AT li_litho_003_tmp1 ASSIGNING FIELD-SYMBOL(<lf_litho_003_tmp1>).
          AT NEW zzvyp.
            CLEAR lv_subs.
          ENDAT.
          lv_subs = lv_subs + <lf_litho_003_tmp1>-new_subs.
          AT END OF zzvyp.
            <lf_litho_003_tmp1>-new_subs = lv_subs.
            APPEND <lf_litho_003_tmp1> TO li_litho_003_new.
          ENDAT.
        ENDLOOP.
        SORT li_litho_003_new BY media_issue plant_marc zzvyp.
        REFRESH: li_litho_003_tmp1.
*---EOI OTCM-45466 TDIMANTHA ED2K925437
        " Prcoess the MI Worklist to derive the values for Custom fileds of
        " LITHO Report
        LOOP AT gt_outtab ASSIGNING <lst_worklist>.
          lv_sytabix = sy-tabix.
          lv_counter = lv_counter + 1.
          " When the subsequent Media Issues are same
          IF <lst_worklist>-ismrefmdprod IS INITIAL AND <lst_worklist>-matnr IS INITIAL.
            lst_statustab = i_statustab[ lv_counter ].
            MOVE-CORRESPONDING lst_statustab TO <lst_worklist>.
            CLEAR lst_statustab.
          ENDIF.

          " Get the Additional Field values with reference to Report data
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*          READ TABLE li_litho_001 INTO lst_litho_001 WITH KEY
*                                  media_issue = <lst_worklist>-matnr
*                                  pub_date = <lst_worklist>-ismpubldate
*                                  plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
*          IF sy-subrc = 0.
*            IF lst_litho_001-plant_marc <> lst_litho_001-delivering_plant.
*              DELETE gt_outtab INDEX lv_sytabix.
*              CLEAR lst_litho_001.
*              CONTINUE.
*            ENDIF.
*            <lst_worklist>-print_method = lst_litho_001-print_method.         " Print Method
*            <lst_worklist>-journal_code = lst_litho_001-acronym.              " Acronym
*            <lst_worklist>-po_num       = lst_litho_001-printer_po_number.    " Printer PO #
*            <lst_worklist>-po_create_dt = lst_litho_001-printer_po_date.      " Printer PO Created Date
*            <lst_worklist>-print_vendor = lst_litho_001-printer.              " Printer
*            <lst_worklist>-dist_vendor  = lst_litho_001-distributor.          " Distributor
*            <lst_worklist>-delv_plant   = lst_litho_001-delivering_plant.     " Delivery Plant
*            <lst_worklist>-issue_type   = lst_litho_001-issue_type.           " Issue Type
*            <lst_worklist>-sub_actual_py = lst_litho_001-subs_actual.         " Subs (Actual)
*            lv_blcy_num = lst_litho_001-back_labels.
*            <lst_worklist>-bl_pcurr_yr  = lv_blcy_num.                        " BL (CY)
*            SHIFT <lst_worklist>-bl_pcurr_yr LEFT DELETING LEADING '0'.
*            <lst_worklist>-ml_cyear     = lst_litho_001-main_labels.          " ML (CY)
*            <lst_worklist>-ml_bl_cy     = <lst_worklist>-ml_cyear + <lst_worklist>-bl_pcurr_yr. " ML+BL (CY)
*            <lst_worklist>-om_actual    =  lst_litho_001-om_actual.            " OM (Actual)
*            <lst_worklist>-ob_actual    =  lst_litho_001-ob_actual.            " OB (Actual)
*            <lst_worklist>-c_and_e      = lst_litho_001-c_e.                  " C & E
*            <lst_worklist>-author_copies =  lst_litho_001-author.             " Author
*            <lst_worklist>-emlo_copies  = lst_litho_001-emlo.                 " EMLO
*            <lst_worklist>-marc_ismarrivaldateac = lst_litho_001-actual_goods_arrival.  " Actual Goods Arrival
*            <lst_worklist>-initial_soh = lst_litho_001-initial_soh.           " SOH (Initial)
*            CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
*              EXPORTING
*                input  = lst_litho_001-wbs_element_unconv
*              IMPORTING
*                output = <lst_worklist>-wbs_element.                          "WBS Element
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          READ TABLE li_litho_sp01 INTO DATA(lst_litho_sp01) WITH KEY
                                  media_issue = <lst_worklist>-matnr
                                  pub_date = <lst_worklist>-ismpubldate
                                  plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_litho_sp01-plant_marc <> lst_litho_sp01-delivering_plant.
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_litho_sp01.
              CONTINUE.
            ENDIF.
            <lst_worklist>-print_method = lst_litho_sp01-print_method.         " Print Method
            <lst_worklist>-journal_code = lst_litho_sp01-acronym.              " Acronym
            <lst_worklist>-po_num       = lst_litho_sp01-printer_po_number.    " Printer PO Number
            <lst_worklist>-po_create_dt = lst_litho_sp01-printer_po_date.      " Printer PO Created Date
            <lst_worklist>-print_vendor = lst_litho_sp01-printer.              " Printer
            <lst_worklist>-dist_vendor  = lst_litho_sp01-distributor.          " Distributor
            <lst_worklist>-delv_plant   = lst_litho_sp01-delivering_plant.     " Delivery Plant
            <lst_worklist>-issue_type   = lst_litho_sp01-issue_type.           " Issue Type
            <lst_worklist>-ml_cyear     = lst_litho_sp01-main_labels.          " ML (CY)
            <lst_worklist>-om_actual    = lst_litho_sp01-om_actual.            " OM (Actual)
            <lst_worklist>-ob_actual    = lst_litho_sp01-ob_actual.            " OB (Actual)
            <lst_worklist>-c_and_e      = lst_litho_sp01-c_e.                  " C & E
            <lst_worklist>-marc_ismarrivaldateac = lst_litho_sp01-actual_goods_arrival.  " Actual Goods Arrival
            <lst_worklist>-initial_soh = lst_litho_sp01-initial_soh.           " SOH (Initial)
            CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
              EXPORTING
                input  = lst_litho_sp01-wbs_element_unconv
              IMPORTING
                output = <lst_worklist>-wbs_element.                           "WBS Element

            READ TABLE li_auth_sp02 INTO DATA(lst_auth_sp02) WITH KEY
                                          media_issue = <lst_worklist>-matnr
                                          BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_worklist>-author_copies =  lst_auth_sp02-author.             " Author
            ENDIF.

            READ TABLE li_emlo_sp02 INTO DATA(lst_emlo_sp02) WITH KEY
                                       media_issue = <lst_worklist>-matnr
                                       BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_worklist>-emlo_copies  = lst_emlo_sp02-emlo.                 " EMLO
            ENDIF.

          READ TABLE li_litho_sp04 INTO DATA(lst_litho_sp04) WITH KEY
                                   media_issue = <lst_worklist>-matnr
                                   pub_date = <lst_worklist>-ismpubldate
                                   plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_litho_sp04-plant_marc <> lst_litho_sp01-delivering_plant.
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_litho_sp04.
              CONTINUE.
            ENDIF.
            <lst_worklist>-sub_actual_py = lst_litho_sp04-subs_actual.         " Subs (Actual)
          ENDIF.

          READ TABLE li_litho_sp05 INTO DATA(lst_litho_sp05) WITH KEY
                                   media_issue = <lst_worklist>-matnr
                                   pub_date = <lst_worklist>-ismpubldate
                                   plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_litho_sp05-plant_marc <> lst_litho_sp01-delivering_plant.
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_litho_sp05.
              CONTINUE.
            ENDIF.
            lv_blcy_num = lst_litho_sp05-back_labels.
            <lst_worklist>-bl_pcurr_yr  = lv_blcy_num.                        " BL (CY)
            SHIFT <lst_worklist>-bl_pcurr_yr LEFT DELETING LEADING '0'.
          ENDIF.

          <lst_worklist>-ml_bl_cy     = <lst_worklist>-ml_cyear + <lst_worklist>-bl_pcurr_yr. " ML+BL (CY)
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Get the Log values
          READ TABLE li_litho_log INTO lst_litho_log WITH KEY
                                  media_issue = <lst_worklist>-matnr
                                  pub_date = <lst_worklist>-ismpubldate
                                  plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_litho_log-plant_marc <> lst_litho_sp01-delivering_plant. "lst_litho_001-delivering_plant.
              DELETE gt_outtab INDEX lv_sytabix.
              CLEAR lst_litho_log.
              CONTINUE.
            ENDIF.
            <lst_worklist>-adjustment = lst_litho_log-adjustment.
            IF lst_litho_log-om_actual IS NOT INITIAL.
              <lst_worklist>-om_actual = lst_litho_log-om_actual.
            ENDIF.
          ENDIF.

          " Getting BL-Buffer
          READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_blbf
                                                                  sub_type = abap_false
                                                                  matnr = <lst_worklist>-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            IF sy-datum >= lst_litho_tm-act_date.
              <lst_worklist>-bl_buffer = lst_litho_tm-quantity.      " BL-Buffer
            ELSE.
              <lst_worklist>-bl_buffer = '0'.
            ENDIF.
            CLEAR lst_litho_tm.
          ELSE.
            READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_blbf
                                                              sub_type = abap_false
                                                              matnr = <lst_worklist>-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              IF sy-datum >= lst_litho_tm-act_date.
                <lst_worklist>-bl_buffer = lst_litho_tm-quantity.    " BL-Buffer
              ELSE.
                <lst_worklist>-bl_buffer = '0'.
              ENDIF.
              CLEAR lst_litho_tm.
            ELSE.
              READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_blbf
                                                                sub_type = abap_false
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                IF sy-datum >= lst_litho_tm-act_date.
                  <lst_worklist>-bl_buffer = lst_litho_tm-quantity.  " BL-Buffer
                ELSE.
                  <lst_worklist>-bl_buffer = '0'.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          " Subs (Plan), OM (Plan)
          lv_pyear = <lst_worklist>-ismyearnr.
          lv_pyear = lv_pyear - 1.   " Previous Year
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*            READ TABLE li_subs_plan INTO lst_subs_plan WITH KEY
*                                    media_product = <lst_worklist>-ismrefmdprod
*                                    pub_year = lv_pyear BINARY SEARCH.
*            IF sy-subrc = 0.
*              <lst_worklist>-subs_plan = lst_subs_plan-subs_actual.             " Subs (Plan)
*              <lst_worklist>-om_plan   = lst_subs_plan-om_actual.               " OM (Plan)
*            ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          READ TABLE li_subs_plan_new INTO DATA(lst_subs_plan_new) WITH KEY
                                  media_product = <lst_worklist>-ismrefmdprod
                                  pub_year = lv_pyear BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-subs_plan = lst_subs_plan_new-subs_actual.             " Subs (Plan)
          ENDIF.
          READ TABLE li_om_plan INTO DATA(lst_om_plan) WITH KEY
                                  media_product = <lst_worklist>-ismrefmdprod
                                  pub_year = lv_pyear BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-om_plan   = lst_om_plan-om_actual.               " OM (Plan)
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          lv_pubdate = <lst_worklist>-ismpubldate(6).
          lv_pubdate(4) = lv_pyear.
          " Get the Media Issue of Previous Year Copy based on Plant
*---BOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*            READ TABLE li_litho_001_py INTO lst_litho_001_py WITH KEY
*                       media_product = <lst_worklist>-ismrefmdprod
*                       pub_date(6) = lv_pubdate
*                       issue_no_unconv = lst_litho_sp01-issue_no_unconv "lst_litho_001-issue_no_unconv
*                       plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH. "lst_litho_001-plant_marc
*            IF sy-subrc <> 0.
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*                EXPORTING
*                  input  = lst_litho_sp01-issue_no_unconv    "lst_litho_001-issue_no_unconv
*                IMPORTING
*                  output = lst_litho_sp01-issue_no_unconv.    "lst_litho_001-issue_no_unconv
*              " Get the Media Issue of Previous Year Copy
*              READ TABLE li_litho_001_py INTO lst_litho_001_py WITH KEY
*                         media_product = <lst_worklist>-ismrefmdprod
*                         pub_date(6) = lv_pubdate
*                         issue_no_unconv = lst_litho_sp01-issue_no_unconv  "lst_litho_001-issue_no_unconv
*                         plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH.  "lst_litho_001-plant_marc
*              IF sy-subrc <> 0.
*                " Nothing to do
*              ENDIF.
*            ENDIF.
*            IF sy-subrc = 0.
*              <lst_worklist>-ml_pyear = lst_litho_001_py-main_labels.           " ML (PY)
*              <lst_worklist>-bl_pyear = lst_litho_001_py-back_labels.           " BL (PY)
*
*              <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)
*
*              <lst_worklist>-ob_plan = lst_litho_001_py-ob_actual.              " OB (Plan)
*            ELSE.
*              li_litho1_py_tmp = li_litho_001_py.
*              DELETE li_litho1_py_tmp WHERE media_product <> <lst_worklist>-ismrefmdprod AND
*                                            pub_date(6) <> lv_pubdate AND
*                                            issue_no_unconv <> lst_litho_sp01-issue_no_unconv. "lst_litho_001-issue_no_unconv.
**---BOC OTCM-45466 TDIMANTHA ED2K925437 "Replace Loop statement with read statting from bottom
*              DATA(lv_py_lines) = lines( li_litho1_py_tmp ).
*              DATA(lv_py_index) = lv_py_lines.
*              DO lv_py_lines TIMES.
*                READ TABLE li_litho1_py_tmp ASSIGNING <lst_litho1_py_tmp> INDEX lv_py_index.
*                IF sy-subrc = 0 AND <lst_litho1_py_tmp>-plant_marc = <lst_litho1_py_tmp>-delivering_plant.
*                  <lst_worklist>-ml_pyear = <lst_litho1_py_tmp>-main_labels.           " ML (PY)
*                  <lst_worklist>-bl_pyear = <lst_litho1_py_tmp>-back_labels.           " BL (PY)
*                  <lst_worklist>-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*                  <lst_worklist>-ob_plan = <lst_litho1_py_tmp>-ob_actual.              " OB (Plan)
*                  EXIT.
*                ELSE.
*                  lv_py_index = lv_py_index - 1.
*                ENDIF.
*              ENDDO.
**              LOOP AT li_litho1_py_tmp ASSIGNING <lst_litho1_py_tmp>.
**                IF <lst_litho1_py_tmp>-plant_marc = <lst_litho1_py_tmp>-delivering_plant.
**                  <lst_worklist>-ml_pyear = <lst_litho1_py_tmp>-main_labels.           " ML (PY)
**                  <lst_worklist>-bl_pyear = <lst_litho1_py_tmp>-back_labels.           " BL (PY)
**
**                  <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)
**
**                  <lst_worklist>-ob_plan = <lst_litho1_py_tmp>-ob_actual.              " OB (Plan)
**                ENDIF.
**              ENDLOOP.
*              CLEAR: li_litho1_py_tmp[],lv_py_lines,lv_py_index.
**---EOC OTCM-45466 TDIMANTHA ED2K925437
*            ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
*---BOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          READ TABLE li_litho_sp01_py INTO DATA(lst_litho_sp01_py) WITH KEY
                     media_product = <lst_worklist>-ismrefmdprod
                     pub_date(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01-issue_no_unconv
                     plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01-issue_no_unconv.
            " Get the Media Issue of Previous Year Copy
            READ TABLE li_litho_sp01_py INTO lst_litho_sp01_py WITH KEY
                       media_product = <lst_worklist>-ismrefmdprod
                       pub_date(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01-issue_no_unconv
                       plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH.
            IF sy-subrc <> 0.
              " Nothing to do
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            <lst_worklist>-ml_pyear = lst_litho_sp01_py-main_labels.           " ML (PY)
            <lst_worklist>-ob_plan = lst_litho_sp01_py-ob_actual.              " OB (Plan)
          ELSE.
            DATA(li_litho_sp01_py_tmp) = li_litho_sp01_py.
            DELETE li_litho_sp01_py_tmp WHERE media_product <> <lst_worklist>-ismrefmdprod AND
                                          pub_date(6) <> lv_pubdate AND
                                          issue_no_unconv <> lst_litho_sp01-issue_no_unconv.

            DATA(lv_sp01_py_lines) = lines( li_litho_sp01_py_tmp ).
            DATA(lv_sp01_py_index) = lv_sp01_py_lines.
            DO lv_sp01_py_lines TIMES.
              READ TABLE li_litho_sp01_py_tmp ASSIGNING FIELD-SYMBOL(<lst_litho_sp01_py_tmp>) INDEX lv_sp01_py_index.
              IF sy-subrc = 0 AND <lst_litho_sp01_py_tmp>-plant_marc = <lst_litho_sp01_py_tmp>-delivering_plant.
                <lst_worklist>-ml_pyear = <lst_litho_sp01_py_tmp>-main_labels.           " ML (PY)
                <lst_worklist>-ob_plan = <lst_litho_sp01_py_tmp>-ob_actual.              " OB (Plan)
                EXIT.
              ELSE.
                lv_sp01_py_index = lv_sp01_py_index - 1.
              ENDIF.
            ENDDO.
            CLEAR: li_litho_sp01_py_tmp[],lv_sp01_py_lines,lv_sp01_py_index.
          ENDIF.

          READ TABLE li_litho_sp05_py INTO DATA(lst_litho_sp05_py) WITH KEY
                     media_product = <lst_worklist>-ismrefmdprod
                     pub_date(6) = lv_pubdate
                     issue_no_unconv = lst_litho_sp01-issue_no_unconv
                     plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_litho_sp01-issue_no_unconv
              IMPORTING
                output = lst_litho_sp01-issue_no_unconv.
            " Get the Media Issue of Previous Year Copy
            READ TABLE li_litho_sp05_py INTO lst_litho_sp05_py WITH KEY
                       media_product = <lst_worklist>-ismrefmdprod
                       pub_date(6) = lv_pubdate
                       issue_no_unconv = lst_litho_sp01-issue_no_unconv
                       plant_marc = lst_litho_sp01-plant_marc BINARY SEARCH.
            IF sy-subrc <> 0.
              " Nothing to do
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.
            <lst_worklist>-bl_pyear = lst_litho_sp05_py-back_labels.           " BL (PY)
            <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)
          ELSE.
            DATA(li_litho_sp05_py_tmp) = li_litho_sp05_py.
            DELETE li_litho_sp01_py_tmp WHERE media_product <> <lst_worklist>-ismrefmdprod AND
                                          pub_date(6) <> lv_pubdate AND
                                          issue_no_unconv <> lst_litho_sp01-issue_no_unconv.

            DATA(lv_sp05_py_lines) = lines( li_litho_sp05_py_tmp ).
            DATA(lv_sp05_py_index) = lv_sp05_py_lines.
            DO lv_sp05_py_lines TIMES.
              READ TABLE li_litho_sp05_py_tmp ASSIGNING FIELD-SYMBOL(<lst_litho_sp05_py_tmp>) INDEX lv_sp05_py_index.
              IF sy-subrc = 0 AND <lst_litho_sp05_py_tmp>-plant_marc = <lst_worklist>-delv_plant.
                <lst_worklist>-bl_pyear = <lst_litho_sp05_py_tmp>-back_labels.           " BL (PY)
                <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)
                EXIT.
              ELSE.
                lv_sp05_py_index = lv_sp05_py_index - 1.
              ENDIF.
            ENDDO.
            CLEAR: li_litho_sp05_py_tmp[],lv_sp05_py_lines,lv_sp05_py_index.
          ENDIF.
*---EOI OTCM-45466 TDIMANTHA ED2K925572 19-Jan-2022
          " Reprint Qty, Reprint PO No.
          LOOP AT li_litho_002 INTO lst_litho_0020 WHERE media_issue = <lst_worklist>-matnr.
            <lst_worklist>-reprint_qty = <lst_worklist>-reprint_qty + lst_litho_0020-reprint_qty.
            IF lst_litho_0020-reprint_po IS NOT INITIAL.
              IF <lst_worklist>-reprint_po_no IS INITIAL.
                <lst_worklist>-reprint_po_no = lst_litho_0020-reprint_po.
              ELSE.
                <lst_worklist>-reprint_po_no = |{ <lst_worklist>-reprint_po_no }, { lst_litho_0020-reprint_po }|.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_0020.
          ENDLOOP.
*---BOC OTCM-45466 TDIMANTHA ED2K925437 "Replace Loop statement with read statement
          " New_Subs
*            SELECT media_issue, pub_year, plant_marc, SUM( new_subs ) AS new_subs, zzvyp
*                   FROM zcds_litho_003 INTO TABLE @li_litho_003
*                   WHERE media_issue = @<lst_worklist>-matnr AND
*                         plant_marc = @<lst_worklist>-marc_werks AND
*                         zzvyp = @<lst_worklist>-ismyearnr
*                   GROUP BY media_issue, pub_year, plant_marc, zzvyp.
*            IF sy-subrc = 0.
*              READ TABLE li_litho_003 INTO lst_litho_003 INDEX 1.
*              IF sy-subrc = 0.
*                <lst_worklist>-new_subs = lst_litho_003-new_subs.                  " New_Subs
*                CLEAR: lst_litho_0020, li_litho_003[].
*              ENDIF.
*            ENDIF.
          READ TABLE li_litho_003_new ASSIGNING FIELD-SYMBOL(<lf_litho_003_new>)
                WITH KEY media_issue = <lst_worklist>-matnr
                         plant_marc = <lst_worklist>-marc_werks
                         zzvyp = <lst_worklist>-ismyearnr
                BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-new_subs = <lf_litho_003_new>-new_subs.                  " New_Subs
          ENDIF.
*---EOC OTCM-45466 TDIMANTHA ED2K925437
          " Subs to Print
          READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                            sub_type = lc_subs
                                                            matnr = <lst_worklist>-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-is_renewal = lst_litho_tm-sub_flag.
            IF lst_litho_tm-sub_flag = lc_y.
              IF sy-datum >= lst_litho_tm-act_date.
                <lst_worklist>-subs_to_print = <lst_worklist>-subs_plan + <lst_worklist>-new_subs + <lst_worklist>-bl_buffer.
              ENDIF.
            ELSEIF lst_litho_tm-sub_flag = lc_n.
              IF sy-datum >= lst_litho_tm-act_date.
                <lst_worklist>-subs_to_print = <lst_worklist>-sub_actual_py + <lst_worklist>-bl_pyear + <lst_worklist>-bl_buffer.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_tm.
          ELSE.
            READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                              sub_type = lc_subs
                                                              matnr = <lst_worklist>-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_worklist>-is_renewal = lst_litho_tm-sub_flag.
              IF lst_litho_tm-sub_flag = lc_y.
                IF sy-datum >= lst_litho_tm-act_date.
                  <lst_worklist>-subs_to_print = <lst_worklist>-subs_plan + <lst_worklist>-new_subs + <lst_worklist>-bl_buffer.
                ENDIF.
              ELSEIF lst_litho_tm-sub_flag = lc_n.
                IF sy-datum >= lst_litho_tm-act_date.
                  <lst_worklist>-subs_to_print = <lst_worklist>-sub_actual_py + <lst_worklist>-bl_pyear + <lst_worklist>-bl_buffer.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm.
            ELSE.
              READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                                sub_type = lc_subs
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_worklist>-is_renewal = lst_litho_tm-sub_flag.
                IF lst_litho_tm-sub_flag = lc_y.
                  IF sy-datum >= lst_litho_tm-act_date.
                    <lst_worklist>-subs_to_print = <lst_worklist>-subs_plan + <lst_worklist>-new_subs + <lst_worklist>-bl_buffer.
                  ENDIF.
                ELSEIF lst_litho_tm-sub_flag = lc_n.
                  IF sy-datum >= lst_litho_tm-act_date.
                    <lst_worklist>-subs_to_print = <lst_worklist>-sub_actual_py + <lst_worklist>-bl_pyear + <lst_worklist>-bl_buffer.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          " OM to Print
          READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                            sub_type = lc_om
                                                            matnr = <lst_worklist>-matnr BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-is_renewal_om = lst_litho_tm-sub_flag.
            IF lst_litho_tm-sub_flag = lc_y.
              IF sy-datum >= lst_litho_tm-act_date.
                <lst_worklist>-om_to_print = <lst_worklist>-om_plan + <lst_worklist>-ob_plan.
              ENDIF.
            ELSEIF lst_litho_tm-sub_flag = lc_n.
              IF sy-datum >= lst_litho_tm-act_date.
                <lst_worklist>-om_to_print = <lst_worklist>-om_actual + <lst_worklist>-ob_plan.
              ENDIF.
            ENDIF.
            CLEAR lst_litho_tm.
          ELSE.
            READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                              sub_type = lc_om
                                                              matnr = <lst_worklist>-ismrefmdprod BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_worklist>-is_renewal_om = lst_litho_tm-sub_flag.
              IF lst_litho_tm-sub_flag = lc_y.
                IF sy-datum >= lst_litho_tm-act_date.
                  <lst_worklist>-om_to_print = <lst_worklist>-om_plan + <lst_worklist>-ob_plan.
                ENDIF.
              ELSEIF lst_litho_tm-sub_flag = lc_n.
                IF sy-datum >= lst_litho_tm-act_date.
                  <lst_worklist>-om_to_print = <lst_worklist>-om_actual + <lst_worklist>-ob_plan.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm.
            ELSE.
              READ TABLE li_litho_tm INTO lst_litho_tm WITH KEY tm_type = lc_rprd
                                                                sub_type = lc_om
                                                                matnr = lc_all BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_worklist>-is_renewal_om = lst_litho_tm-sub_flag.
                IF lst_litho_tm-sub_flag = lc_y.
                  IF sy-datum >= lst_litho_tm-act_date.
                    <lst_worklist>-om_to_print = <lst_worklist>-om_plan + <lst_worklist>-ob_plan.
                  ENDIF.
                ELSEIF lst_litho_tm-sub_flag = lc_n.
                  IF sy-datum >= lst_litho_tm-act_date.
                    <lst_worklist>-om_to_print = <lst_worklist>-om_actual + <lst_worklist>-ob_plan.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR lst_litho_tm.
            ENDIF.
          ENDIF.  " IF sy-subrc = 0.

          " Sub Total (Subs + OM)
          <lst_worklist>-sub_total = <lst_worklist>-subs_to_print + <lst_worklist>-om_to_print.

          " PRINT RUN: TOTAL PO QTY
          <lst_worklist>-total_po_qty = <lst_worklist>-sub_total + <lst_worklist>-c_and_e + <lst_worklist>-author_copies +
                                        <lst_worklist>-emlo_copies.

          " Estimated SOH
          <lst_worklist>-estimated_soh = <lst_worklist>-total_po_qty - <lst_worklist>-ml_cyear - <lst_worklist>-om_actual -
                                         <lst_worklist>-c_and_e - <lst_worklist>-author_copies - <lst_worklist>-emlo_copies.

          " Stock on Hand (Current)
          READ TABLE li_litho_004 INTO lst_litho_004 WITH KEY
                                  media_issue = <lst_worklist>-matnr
                                  plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_worklist>-current_soh = lst_litho_004-soh.                    " SOH (Current)
          ENDIF.

          " Assign the Log Icon
          <lst_worklist>-comments = lc_comments.
          lv_external_num = |{ <lst_worklist>-matnr }{ <lst_worklist>-marc_werks }|.
          READ TABLE li_balhdr WITH KEY extnumber = lv_external_num
                               BINARY SEARCH
                               TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            <lst_worklist>-view_comments = lc_vcomments.
          ENDIF.

        ENDIF. " IF sy-subrc = 0. READ TABLE li_litho_001...

        " Change Adjustment & OM Actual
        <lst_worklist>-om_actual_txt = <lst_worklist>-om_actual.
        SHIFT <lst_worklist>-om_actual_txt LEFT DELETING LEADING '0'.
        CONDENSE <lst_worklist>-om_actual_txt.
        CONCATENATE lc_comments <lst_worklist>-om_actual_txt INTO <lst_worklist>-om_actual_txt SEPARATED BY space.
        <lst_worklist>-adjustment_txt = <lst_worklist>-adjustment.
        CONDENSE <lst_worklist>-adjustment_txt.
        CONCATENATE lc_comments <lst_worklist>-adjustment_txt INTO <lst_worklist>-adjustment_txt SEPARATED BY space.
        " Clear the structures
        CLEAR: lst_litho_001_py, lst_litho_001, lst_litho_003, lst_litho_sp01,lst_litho_sp04,
               lst_litho_004, lst_subs_plan, lst_litho_tm, lst_litho_log, lst_litho_sp05,
               lst_litho_sp01_py, lst_litho_sp05_py, lst_subs_plan_new, lst_om_plan, lst_auth_sp02,
               lst_emlo_sp02.

      ENDLOOP.

    ENDIF. " IF gv_filt = lc_zd.

    " Set the Field Catalog
    CALL METHOD gv_list->gv_alv_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = li_fcat.

    " REFRESH ALV DISPLAY
    CALL METHOD me->register_refresh.
    CALL METHOD gv_list->execute_refresh. "ALV neu aufbauen
