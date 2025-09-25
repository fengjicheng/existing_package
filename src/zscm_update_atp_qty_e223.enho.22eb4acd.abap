"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\ME:ADD_ENTRIES\SE:END\EI
ENHANCEMENT 0 ZSCM_UPDATE_ATP_QTY_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Enhancement to update the Additional Column values
*              in Media Issue Worklist
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-05-28
* DESCRIPTION: Journal First Print Optimization
* Validations against Source List Vendor(Printer & Distributor), Info Record
* and Material Text
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 31-AUG-2020
* DESCRIPTION: LITHO Report Changes
* Update Additinal Column values for DIGITAL/LITHO Report
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K921719
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 05-FEB-2021
* DESCRIPTION: Aditional fields for Digital/Litho
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K922117
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 23-FEB-2021
* DESCRIPTION: Aditional fields for Digital/Litho Corrections
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K922407
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 09-MARCH-2021
* DESCRIPTION: Fixing Trailing 0 issue WBS Element
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K922780
* REFERENCE NO: OTCM-44349 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 30-MARCH-2021
* DESCRIPTION: Fixing Issues ML Cyear ML Pyear
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K923462
* REFERENCE NO: OTCM-46971 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 20-July-2021
* DESCRIPTION: New Renewal Calculation % LITHO_DIGITAL_SWITCH
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K925437
* REFERENCE NO: OTCM-45466 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 05-Jan-2022
* DESCRIPTION: Litho Digital Switch Performance
*-----------------------------------------------------------------------*

  type-pools: icon.
  " Local Data declaration
  DATA: lv_refresh_flag TYPE abap_bool VALUE abap_false,
        li_autet TYPE RANGE OF autet,
        lv_error_txt   TYPE string,
        lv_slv_err_txt TYPE string,         " Source List Validation Error Text
        lv_title_err_txt TYPE string,       " Title Validation Error Text
        lir_plant TYPE RANGES_WERKS_TT,
        lir_matnr TYPE RANGES_MATNR_TT,
        lir_sorgwrk_di TYPE P3PR_RT_LIFNR,
        lir_sorgwrk_pr TYPE P3PR_RT_LIFNR,
        lv_lifnr  TYPE lifnr,
        " BOC: ERPM-837(R096) KKRAVURI 21-08-2020  ED2K919143
        lv_cyear         TYPE bdatj,  " Current Period Year
        lv_cprd          TYPE poper,  " Current Period
        lv_prd           TYPE lfmon,  " Current Period with length 2
        li_constant      TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,
        li_md_is_unsm    TYPE STANDARD TABLE OF ty_cds,
        li_mi_unsm_pyd   TYPE STANDARD TABLE OF ty_cds,
        lv_volume        TYPE numc4,
        lv_pyear         TYPE numc4,
        lv_sub_actual_py TYPE i,
        lv_renewal_per   TYPE i,
        lv_bl_pcurr_yr   TYPE i,
        lv_ren_curr_subs TYPE i,
        lv_ml_py         TYPE numc13,
        lv_matnr         TYPE matnr,
        lv_periv         TYPE periv,
        lv_count         TYPE i,
        lv_off           TYPE i,
        lv_blcy_num      TYPE numc13,
        lv_issue_num     TYPE numc4,
        lv_percent       TYPE n VALUE '5',
        lv_itpdate       TYPE syst_datum,
        lr_wildcard      TYPE RANGE OF matnr,
        lst_wildcard     LIKE LINE OF lr_wildcard,
        li_pyr_data      TYPE STANDARD TABLE OF ty_pyr_data,
        lst_max_issue    TYPE ty_max_issue,
        li_max_issue     TYPE STANDARD TABLE OF ty_max_issue,
        lst_max_issue_f  TYPE ty_max_issue_f,
        li_max_issue_f   TYPE STANDARD TABLE OF ty_max_issue_f,
        lv_counter       TYPE syst_tabix,
        lv_sytabix       TYPE syst_tabix,
        lv_py_issue      TYPE matnr,
        lv_py_year       TYPE numc4.
        " EOC: ERPM-837(R096) KKRAVURI 21-08-2020  ED2K919143

  " Local Constants
  CONSTANTS:
    lc_digital   TYPE LOGGR  VALUE '0001',
    lc_comments  TYPE text25 VALUE '@0Q\QMaintain Comments@',
    lc_vcomments TYPE text25 VALUE '@6X\QView Comments@',
    lc_percent   TYPE rvari_vnam VALUE 'PERCENT',
    lc_pdate     TYPE rvari_vnam VALUE 'ISSUE_PRINT_DATE',
    lc_fyear_var TYPE rvari_vnam VALUE 'FYEAR_VAR',
    lc_periv     TYPE rvari_vnam VALUE 'PERIV',
    lc_w1        TYPE periv      VALUE 'W1',
    lc_object    TYPE balobj_d   VALUE 'ZQTC',
    lc_subobj    TYPE balsubobj  VALUE 'ZSCM_LITHO',
    lc_devid     TYPE zdevid VALUE 'R096',
    lc_comma     TYPE char1  VALUE ',',
    lc_all       TYPE char1  VALUE '*',
    lc_blbf      TYPE char4  VALUE 'BLBF',
    lc_rprd      TYPE char4  VALUE 'RPRD',
    lc_subs      TYPE char4  VALUE 'SUBS',
    lc_om        TYPE char4  VALUE 'OM',
    lc_y         TYPE char4  VALUE 'Y',
    lc_n         TYPE char4  VALUE 'N'.


  " Check for Tcode
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
      " Get the Field Catalog
      CALL METHOD gv_list->gv_alv_grid->get_frontend_fieldcatalog
        IMPORTING
          et_fieldcatalog = DATA(li_fcat).

      LOOP AT li_fcat INTO ls_fieldcat.
        CASE ls_fieldcat-fieldname.
          WHEN 'ISMREFMDPROD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 1.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MEDPROD_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 2.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MATNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 3.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MEDISSUE_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 4.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMPUBLDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 5.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMINITSHIPDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 6.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMCOPYNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 7.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'TEXT_ICON'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 8.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTAV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 9.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTDV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 10.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTAE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 11.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTDE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 12.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMYEARNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'PUB Year'.
            ls_fieldcat-JUST = 'L'.
            ls_fieldcat-col_pos = 13.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ZWKBST'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'ATP Qty'.
            ls_fieldcat-JUST = 'L'.
*            ls_fieldcat-LZERO = ' '.
            ls_fieldcat-col_pos = 14.
            MODIFY li_fcat FROM ls_fieldcat. " ISMREFMDPROD_SAVE
          WHEN 'MARC_WERKS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 15.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMPURCHASEDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 16.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEPL'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 17.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEAC'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 18.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTA'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 19.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 20.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK01'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 21.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_SFMEINS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 22.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN OTHERS.
            ls_fieldcat-no_out = abap_true.
            MODIFY li_fcat FROM ls_fieldcat.
        ENDCASE.

      CLEAR ls_fieldcat.
     ENDLOOP.

      " Setting the deafult Field Catalog
      CALL METHOD gv_list->gv_alv_grid->set_frontend_fieldcatalog
        EXPORTING
          it_fieldcatalog = li_fcat.

    " Check whether the Enhancement is active ot not
    IF v_aflag_e223 = abap_true.

     IF rjksdworklist_changefields-xincl_phases = con_angekreuzt.
       " Enhancement to update the ATP Qty for the same Media Issues with different Plant
       "  ATP Qty is getting cleared as per the standard code at line no: 1278
       LOOP AT I_STATUSTAB INTO LS_STATUSTAB.
         " Update the ATP Qty for the same Media Issues with different Plant
         IF LS_STATUSTAB-ZWKBST IS NOT INITIAL.
           READ TABLE GT_OUTTAB ASSIGNING FIELD-SYMBOL(<lfs_outtab>) INDEX SY-TABIX.
           IF SY-SUBRC = 0.
             IF <lfs_outtab>-ZWKBST IS INITIAL.
               <lfs_outtab>-ZWKBST = LS_STATUSTAB-ZWKBST.
               lv_refresh_flag = abap_true.
             ENDIF.
           ENDIF. " IF SY-SUBRC = 0.
         ENDIF. " IF LS_STATUSTAB-ZWKBST IS NOT INITIAL.
         CLEAR LS_STATUSTAB.
       ENDLOOP.
      ENDIF. " IF rjksdworklist_changefields-xincl_phases = con_angekreuzt.

    ENDIF. " IF v_aflag_e223 = abap_true.

    " Check whether enhancement is active or not
    IF v_aflag_e244 = abap_true.

     " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
     IF RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.

       " Get the Field Catalog
       REFRESH li_fcat.
       CALL METHOD gv_list->gv_alv_grid->get_frontend_fieldcatalog
         IMPORTING
           et_fieldcatalog = li_fcat.

       LOOP AT li_fcat INTO ls_fieldcat.
         CASE ls_fieldcat-fieldname.
          WHEN 'ISMREFMDPROD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 1.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MEDPROD_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 2.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MATNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 3.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MEDISSUE_MAKTX'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 4.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMPUBLDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 5.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMINITSHIPDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 6.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMCOPYNR'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 7.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'TEXT_ICON'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 8.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTAV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 9.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTDV'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 10.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTAE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 11.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MSTDE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 12.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'STATUS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'Status'.
*            ls_fieldcat-col_opt = 'X'.
            ls_fieldcat-JUST = 'L'.
            ls_fieldcat-col_pos = 13.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK10'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-tech = abap_false.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'Planned Qty'.
            ls_fieldcat-JUST = 'L'.
            ls_fieldcat-quantity = 'EA'.
            ls_fieldcat-col_pos = 14.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ISMYEARNR'.
            ls_fieldcat-no_out = abap_true.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'PUB Year'.
            ls_fieldcat-JUST = 'L'.
*            ls_fieldcat-col_pos = 13.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'ZWKBST'.
            ls_fieldcat-no_out = abap_true.
            ls_fieldcat-outputlen = 10.
            ls_fieldcat-coltext = 'ATP Qty'.
            ls_fieldcat-JUST = 'L'.
*            ls_fieldcat-col_pos = 14.
            MODIFY li_fcat FROM ls_fieldcat. " ISMREFMDPROD_SAVE
          WHEN 'MARC_WERKS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 15.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMPURCHASEDATE'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 16.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEPL'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 17.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_ISMARRIVALDATEAC'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 18.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTA'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 19.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_MMSTD'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 20.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_STOCK01'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 21.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN 'MARC_SFMEINS'.
            ls_fieldcat-no_out = abap_false.
            ls_fieldcat-col_pos = 22.
            MODIFY li_fcat FROM ls_fieldcat.
          WHEN OTHERS.
            ls_fieldcat-no_out = abap_true.
            MODIFY li_fcat FROM ls_fieldcat.
        ENDCASE.

       CLEAR ls_fieldcat.
      ENDLOOP.

     " Setting the deafult Field Catalog
     CALL METHOD gv_list->gv_alv_grid->set_frontend_fieldcatalog
       EXPORTING
         it_fieldcatalog = li_fcat.

      " FETCH the Constant Table entries
      SELECT devid,                          " Development ID
             param1,                         " ABAP: Name of Variant Variable
             param2,                         " ABAP: Name of Variant Variable
             srno,                           " ABAP: Current selection number
             sign,                           " ABAP: I/E (include/exclude values)
             opti,                           " ABAP: Selection option (EQ/BT/CP/...)
             low,                            " Lower Value of Selection Condition
             high                            " Upper Value of Selection Condition
             FROM zcaconstant                " Wiley Application Constant Table
             INTO TABLE @i_constant
             WHERE devid = @c_e244 AND
                   activate = @abap_true.    " Only active records
      IF sy-subrc = 0.
         sort i_constant by param1 low.
      ENDIF.

* Separate Constant Table entries
      LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_const>).

* SOC by NPOLINA ERPM-10175  ED2K918271
          CASE <lst_const>-param1.
           WHEN c_p1_title.
             " Build the Range table for Material
             APPEND INITIAL LINE TO lir_matnr ASSIGNING FIELD-SYMBOL(<lst_matnr>).
             <lst_matnr>-sign   = <lst_const>-sign.
             <lst_matnr>-option = <lst_const>-opti.
             <lst_matnr>-low    = <lst_const>-low.
             <lst_matnr>-high   = <lst_const>-high.
           WHEN c_p1_werks.
             " Build the Range table for Plant
             APPEND INITIAL LINE TO lir_plant ASSIGNING FIELD-SYMBOL(<lst_plant>).
             <lst_plant>-sign   = <lst_const>-sign.
             <lst_plant>-option = <lst_const>-opti.
             <lst_plant>-low    = <lst_const>-low.
             <lst_plant>-high   = <lst_const>-high.
           WHEN OTHERS.
             " Nothing to do
         ENDCASE.

         IF <lst_const>-param2 = c_printer OR
            <lst_const>-param2 = c_distributor.
           CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
             EXPORTING
              input         = <lst_const>-low
             IMPORTING
              output        = lv_lifnr.

           CASE <lst_const>-param2.
            WHEN c_printer.
             " Build Range Table of Printer Vendor List
             APPEND INITIAL LINE TO lir_sorgwrk_pr ASSIGNING FIELD-SYMBOL(<lst_swrk_pr>).
             IF <lst_const>-high = c_dummy.
              <lst_swrk_pr>-sign = abap_true.  " To indicate that it is a DUMMY Vendor
             ELSE.
              <lst_swrk_pr>-sign = <lst_const>-sign.
             ENDIF.
             <lst_swrk_pr>-option = <lst_const>-opti.
             <lst_swrk_pr>-low    = <lst_const>-param1.
             <lst_swrk_pr>-high   = lv_lifnr.

            WHEN c_distributor.
             " Build Range Table of Distributor Vendor List
             APPEND INITIAL LINE TO lir_sorgwrk_di ASSIGNING FIELD-SYMBOL(<lst_swrk_di>).
             IF <lst_const>-high = c_dummy.
              <lst_swrk_di>-sign = abap_true.  " To indicate that it is a DUMMY Vendor
             ELSE.
              <lst_swrk_di>-sign   = <lst_const>-sign.
             ENDIF.
             <lst_swrk_di>-option = <lst_const>-opti.
             <lst_swrk_di>-low    = <lst_const>-param1.
             <lst_swrk_di>-high   = lv_lifnr.
* EOC by NPOLINA ERPM-10175  ED2K918271
            WHEN OTHERS.
              " Nothing to do
           ENDCASE.

           CLEAR lv_lifnr.
         ENDIF.  " IF <lst_const>-param2 = 'PRINTER' OR

      ENDLOOP.

      " To get the Source List only relevant to MRP Run
      " AUTET --> Source List Usage in Materials Planning
      li_autet = VALUE #( ( sign = 'I'
                            option = 'EQ'
                            low = '1' ) ).    " 1 --> Indicates Printer Vendor for MRP Run

      IF GT_OUTTAB[] IS NOT INITIAL.
      " Fetch Purchasing Source List
      SELECT MATNR, WERKS, lifnr, ZEORD, FLIFN, AUTET FROM EORD INTO CORRESPONDING FIELDS OF TABLE @i_eord
             FOR ALL ENTRIES IN @GT_OUTTAB
             WHERE MATNR = @GT_OUTTAB-MATNR AND
                   WERKS = @GT_OUTTAB-MARC_WERKS AND
                   VDATU <= @sy-datum AND
                   BDATU >= @sy-datum AND
                   ( AUTET IN @li_autet OR FLIFN EQ @abap_true ).
      IF sy-subrc = 0.
        SORT i_eord BY MATNR WERKS LIFNR.
      ENDIF.

      " Purchasing Info Record
      SELECT EINA~INFNR, EINA~MATNR,EINE~WERKS, EINA~LIFNR FROM EINA INNER JOIN EINE
             ON EINA~INFNR = EINE~INFNR
             INTO CORRESPONDING FIELDS OF TABLE @i_eina
             FOR ALL ENTRIES IN @GT_OUTTAB
             WHERE EINA~MATNR = @GT_OUTTAB-matnr AND
                   EINE~ESOKZ = '0' AND    " ESOKZ --> Purchasing Info Record Category: Standard (0)
                   EINE~WERKS = @GT_OUTTAB-MARC_WERKS.
      IF sy-subrc = 0.
        SORT i_eina BY MATNR WERKS.
      ENDIF.

      " Fetch Material Texts
      SELECT MATNR, SPRAS FROM MAKT INTO CORRESPONDING FIELDS OF TABLE @i_makt
             FOR ALL ENTRIES IN @GT_OUTTAB
             WHERE MATNR = @GT_OUTTAB-matnr AND
                   SPRAS = 'D'.
      IF sy-subrc = 0.
        SORT i_makt BY MATNR.
      ENDIF.
      ENDIF. " IF GT_OUTTAB[] IS NOT INITIAL

      " Iterate the Media Issues and validate them against Source List and Purchasing Info Record
      SORT lir_matnr by low.
      LOOP AT GT_OUTTAB ASSIGNING <lfs_outtab>.
         " Validate Source List
         SORT i_eord by matnr werks autet.
         " Read Printer entry for Material and Plant
         READ TABLE i_eord INTO DATA(lst_eord) WITH KEY
                                    MATNR = <lfs_outtab>-matnr
                                    WERKS = <lfs_outtab>-MARC_WERKS
                                    AUTET = '1'
                                    BINARY SEARCH.
         IF sy-subrc <> 0.
           lv_error_txt = |{ c_sl_txt } { c_print_txt }|.
         ELSE.
* SOC by NPOLINA ERPM-10175  ED2K918271
           " Source List validation for Printer Vendor with ZCACONSTANT
            READ TABLE LIR_SORGWRK_PR ASSIGNING FIELD-SYMBOL(<lfs_constpr>) WITH KEY
                                                    low+5(4) = <lfs_outtab>-MARC_WERKS
                                                    high = lst_eord-lifnr.
            IF sy-subrc NE 0.
               lv_slv_err_txt = c_print_txt.
            ELSE.
               " Validate Title/Material for DUMMY vendors for Printer
               IF <lfs_constpr>-sign = abap_true. " Means it is a DUMMY Vendor
                 " Hence we have to Validate it againt the Material as per the requirement
                 READ TABLE lir_matnr WITH KEY low = <lfs_outtab>-ISMREFMDPROD BINARY SEARCH
                                               TRANSPORTING NO FIELDS.
                 IF sy-subrc NE 0.
                   lv_title_err_txt = c_ptitle_txt.
                 ENDIF.
               ENDIF. " IF <lfs_constpr>-sign = abap_true.
            ENDIF.
           CLEAR lst_eord.
         ENDIF.

         " Validate source list for Distributor Vendor in ZCACONSTANT
         SORT i_eord by matnr werks flifn.
         READ TABLE i_eord INTO lst_eord WITH KEY MATNR = <lfs_outtab>-matnr
                                    WERKS = <lfs_outtab>-MARC_WERKS
                                    flifn = abap_true
                                    BINARY SEARCH.
         IF sy-subrc <> 0.
           IF lv_error_txt IS NOT INITIAL.
             lv_error_txt = |{ lv_error_txt } { c_and } { c_dist_txt }|.
           ELSE.
             lv_error_txt = |{ c_sl_txt } { c_dist_txt }|.
           ENDIF.
         ELSE.
              " Check Vendor entry in ZCACONSTANT Table
              READ TABLE LIR_SORGWRK_DI ASSIGNING FIELD-SYMBOL(<lfs_constdi>) with key
                                                    low+5(4) = <lfs_outtab>-MARC_WERKS
                                                    high = lst_eord-lifnr.
              IF sy-subrc NE 0.
                IF lv_slv_err_txt IS NOT INITIAL.
                  lv_slv_err_txt = |{ lv_slv_err_txt } { c_and } { c_dist_txt }|.
                ELSE.
                  lv_slv_err_txt = c_dist_txt.
                ENDIF.
              ELSE.
               " Validate Title/Material for DUMMY vendors for Printer
               IF <lfs_constdi>-sign = abap_true. " Means it is a DUMMY Vendor
                 " Hence we have to Validate it againt the Material as per the requirement
                 READ TABLE lir_matnr WITH KEY low = <lfs_outtab>-ISMREFMDPROD BINARY SEARCH
                                      TRANSPORTING NO FIELDS.
                 IF sy-subrc NE 0.
                   lv_title_err_txt = c_dtitle_txt.
                 ENDIF.
               ENDIF. " IF <lfs_constdi>-sign = abap_true
              ENDIF. " IF sy-subrc NE 0.

           CLEAR lst_eord.
         ENDIF. " IF sy-subrc <> 0. --> READ TABLE i_eord INTO lst_eord...

         IF lv_error_txt IS INITIAL AND lv_slv_err_txt IS NOT INITIAL.
           lv_error_txt = |{ lv_slv_err_txt } { c_const_txt }|.
           CLEAR lv_slv_err_txt.
         ELSEIF lv_error_txt IS INITIAL AND lv_title_err_txt IS NOT INITIAL.
           lv_error_txt = lv_title_err_txt.
           CLEAR lv_title_err_txt.
         ENDIF.
* EOC by NPOLINA ERPM-10175  ED2K918271

         " Validate Info Record
         READ TABLE i_eina WITH KEY MATNR = <lfs_outtab>-matnr WERKS = <lfs_outtab>-MARC_WERKS
                                    BINARY SEARCH
                                    TRANSPORTING NO FIELDS.
         IF sy-subrc <> 0.
           IF lv_error_txt IS NOT INITIAL.
             lv_error_txt = |{ lv_error_txt }{ c_comma } { c_ir_txt }|.
           ELSE.
             lv_error_txt = |{ lv_error_txt }{ c_ir_txt }|.
           ENDIF.
         ENDIF.

         " Validate Material text in DE
         IF lir_plant[] IS NOT INITIAL AND
            <lfs_outtab>-MARC_WERKS IN lir_plant.
           READ TABLE i_makt WITH KEY MATNR = <lfs_outtab>-matnr
                                    BINARY SEARCH
                                    TRANSPORTING NO FIELDS.
           IF sy-subrc <> 0.
             IF lv_error_txt IS NOT INITIAL.
               lv_error_txt = |{ lv_error_txt }{ c_comma } { c_mat_txt }|.
             ELSE.
               lv_error_txt = |{ lv_error_txt }{ c_mat_txt }|.
             ENDIF.
           ENDIF.
         ENDIF. " IF lir_plant[] IS NOT INITIAL AND

         IF lv_error_txt IS NOT INITIAL.
           lv_error_txt = |{ c_error } { lv_error_txt } { c_missing_txt }|.
           <lfs_outtab>-status = lv_error_txt.
           lv_refresh_flag = abap_true.
         ELSE.
           <lfs_outtab>-status = c_success.
           lv_refresh_flag = abap_true.
         ENDIF.

         CLEAR lv_error_txt.
      ENDLOOP.

     ENDIF. " IF RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.
     " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

    ENDIF. " IF v_aflag_e244 = abap_true.

    " REFRESH ALV DISPLAY
    CALL METHOD ME->REGISTER_REFRESH.
    CALL METHOD GV_list->EXECUTE_REFRESH. "ALV neu aufbauen
* BOI OTCM-46971 ED2K925437 TDIMANTHA 01/04/2022
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
*  IF sy-tcode = 'ZSCM_JKSD13_01' OR
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
  IF sy-tcode = 'ZSCM_JKSD13_01_OLD' OR
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
     sy-tcode = 'ZSCM_JKSD13_03'.
* EOI OTCM-46971 ED2K925437 TDIMANTHA 01/04/2022
    " Check whether the Enhancement is active ot not
    " Enhancement to update the Additional Column values of MI for Planning
    IF v_aflag_r096 = abap_true.

      "ED2K924372
*      INCLUDE zqtcn_additional_fields_r096 IF FOUND.
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
        LOOP AT li_fcat INTO DATA(lst_fcat).

         CASE lst_fcat-fieldname.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'JOURNAL_CODE'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-coltext = 'Journal Code'.
*            lst_fcat-JUST = 'L'.
*            lst_fcat-col_pos = 1.
*            MODIFY li_fcat FROM lst_fcat.
**EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
          WHEN 'ISMREFMDPROD'.
            lst_fcat-no_out = abap_false.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 1.
*            lst_fcat-col_pos = 2.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 1.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'MEDPROD_MAKTX'.
            lst_fcat-no_out = abap_false.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 2.
*            lst_fcat-col_pos = 3.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 2.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'MATNR'.
            lst_fcat-no_out = abap_false.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 3.
*            lst_fcat-col_pos = 4.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 3.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'MEDISSUE_MAKTX'.
            lst_fcat-no_out = abap_false.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 4.
*            lst_fcat-col_pos = 5.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 4.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOI: TDIMANTHA 20-Apr-2021 ED2K923103
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
*EOI: TDIMANTHA 20-Apr-2021 ED2K923103
          WHEN 'PRINT_METHOD'.
            lst_fcat-no_out = abap_false.
            lst_fcat-edit = abap_true.
            lst_fcat-coltext = 'Print Method'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 5.
*            lst_fcat-col_pos = 6.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 7.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'JOURNAL_CODE'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-coltext = 'Journal Code'.
*            lst_fcat-JUST = 'L'.
*            lst_fcat-col_pos = 6.
*            MODIFY li_fcat FROM lst_fcat.
*EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          WHEN 'ISMYEARNR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'Pub Year'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 7.
            lst_fcat-col_pos = 8.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'JOURNAL_CODE'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'Acronym'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 8.
            lst_fcat-col_pos = 9.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          WHEN 'ISMCOPYNR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-edit = abap_false.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 7.
*            lst_fcat-col_pos = 9.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-coltext = 'Volume'.
            lst_fcat-col_pos = 10.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
           WHEN 'ISMNRINYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Issue Number'.
            lst_fcat-JUST = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 8.
*            lst_fcat-col_pos = 10.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 11.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          WHEN 'WBS_ELEMENT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'WBS Element'.
            lst_fcat-JUST = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 11.
            lst_fcat-col_pos = 12.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PO_NUM'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-coltext = 'Printer PO Number'.
            lst_fcat-coltext = 'Printer PO#'.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 12.
            lst_fcat-col_pos = 13.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PO_CREATE_DT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Printer PO Date'.
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 13.
            lst_fcat-col_pos = 14.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PRINT_VENDOR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Printer'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 14.
            lst_fcat-col_pos = 15.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-just = 'L'.
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'DIST_VENDOR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Distributor'.
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 15.
            lst_fcat-col_pos = 16.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'DELV_PLANT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Deliv. Plant'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 16.
            lst_fcat-col_pos = 17.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ISSUE_TYPE'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Issue Type'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-col_pos = 17.
            lst_fcat-col_pos = 18.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'MSTAE'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-edit = abap_false.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 9.
*            lst_fcat-col_pos = 18.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'MARC_ISMPURCHASEDATE'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-edit = abap_false.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 10.
*            lst_fcat-col_pos = 19.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
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
            lst_fcat-JUST = 'L'.
            lst_fcat-col_pos = 22.
            MODIFY li_fcat FROM lst_fcat.
        WHEN 'BL_PCURR_YR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 8.
            lst_fcat-coltext = 'BL (CY)'.
            lst_fcat-JUST = 'L'.
            lst_fcat-col_pos = 23.
            MODIFY li_fcat FROM lst_fcat.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
          WHEN 'ML_PYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 15.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-coltext = 'ML Previous Year'.
            lst_fcat-coltext = 'ML (PY)'.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-JUST = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 11.
*            lst_fcat-col_pos = 20.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 24.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*          WHEN 'BL_PYEAR'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 18.
*            lst_fcat-coltext = 'BL Actual for Prior Year'.
*            lst_fcat-JUST = 'L'.
**BOC: TDIMANTHA 20-Apr-2021 ED2K923103
***BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
***            lst_fcat-col_pos = 12.
**            lst_fcat-col_pos = 21.
***EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*          WHEN 'SUB_ACTUAL_PY'.
          WHEN 'ML_BL_PY'.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 18.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-coltext = 'Subs Actual for Prior Year'.
            lst_fcat-coltext = 'ML + BL (PY)'.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-JUST = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 13.
*            lst_fcat-col_pos = 22.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            lst_fcat-col_pos = 25.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'NEW_SUBS'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 10.
*            lst_fcat-coltext = 'New Subs'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 23.
*            MODIFY li_fcat FROM lst_fcat.
***EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'RENEWAL_PER'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 13.
*            lst_fcat-coltext = 'Renewal %'.
*            lst_fcat-JUST = 'L'.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 14.
*            lst_fcat-col_pos = 24.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'NOT_RENEWED_PER'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 13.
*            lst_fcat-coltext = 'Not Renewed %'.
*            lst_fcat-JUST = 'L'.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 15.
*            lst_fcat-col_pos = 25.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
          WHEN 'ML_CYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 15.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*            lst_fcat-coltext = 'ML Current Year'.
            lst_fcat-coltext = 'ML (CY)'.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            lst_fcat-JUST = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            lst_fcat-col_pos = 16.
            lst_fcat-col_pos = 26.
*EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
            MODIFY li_fcat FROM lst_fcat.
*BOI: TDIMANTHA 20-Apr-2021 ED2K923103
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
            lst_fcat-JUST = 'L'.
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
*            lst_fcat-edit = abap_true.
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
*BOI OTCM-46971 ED2K924440 21-Oct-2021.
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
*EOI OTCM-46971 ED2K924440 21-Oct_2021.
          WHEN 'RENEWAL_PER'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 13.
            lst_fcat-coltext = 'Renewal %'.
            lst_fcat-JUST = 'L'.
*            lst_fcat-col_pos = 49.
            lst_fcat-col_pos = 51.
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'NOT_RENEWED_PER'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 13.
            lst_fcat-coltext = 'Not Renewed %'.
            lst_fcat-JUST = 'L'.
*            lst_fcat-col_pos = 50.
            lst_fcat-col_pos = 52.
            MODIFY li_fcat FROM lst_fcat.
*EOI: TDIMANTHA 20-Apr-2021 ED2K923103
          WHEN 'REN_CURR_SUBS'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 18.
            lst_fcat-coltext = 'Renewal Cal. plus Current Year Subs'.
            lst_fcat-JUST = 'L'.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 17.
*            lst_fcat-col_pos = 27.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            lst_fcat-col_pos = 51.
            lst_fcat-col_pos = 53.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
            MODIFY li_fcat FROM lst_fcat.
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
*          WHEN 'BL_PCURR_YR'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 18.
*            lst_fcat-coltext = 'BL Planned Current Year'.
**            lst_fcat-LZERO = 'X'.
**            lst_fcat-NO_ZERO = ' '.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 18.
*            lst_fcat-col_pos = 28.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'PURCHASE_REQ'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 18.
*            lst_fcat-coltext = 'New Subs Purchase Req For Current Year'.
*            lst_fcat-JUST = 'L'.
**BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
**            lst_fcat-col_pos = 19.
*            lst_fcat-col_pos = 29.
**EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*            MODIFY li_fcat FROM lst_fcat.
**BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*         WHEN 'OM_PLAN'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'OM Plan'.
*            lst_fcat-outputlen = 8.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 30.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'OM_ACTUAL_TXT'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'OM Actual'.
*            lst_fcat-outputlen = 9.
*            lst_fcat-just = 'L'.
*            lst_fcat-hotspot = abap_true.
*            lst_fcat-col_pos = 31.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'OB_PLAN'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'OB Plan'.
*            lst_fcat-outputlen = 8.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 32.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'OB_ACTUAL'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'OB Actual'.
*            lst_fcat-outputlen = 9.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 33.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'BL_BUFFER'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'BL Buffer'.
*            lst_fcat-outputlen = 10.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 34.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'SUB_TOTAL'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'Sub total(Subs + OM + BL Buffer)'.
*            lst_fcat-outputlen = 10.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 35.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'C_AND_E'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'C & E'.
*            lst_fcat-outputlen = 8.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 36.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'AUTHOR_COPIES'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'Author'.
*            lst_fcat-outputlen = 8.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 37.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'EMLO_COPIES'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'EMLO'.
*            lst_fcat-outputlen = 8.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 38.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'ADJUSTMENT_TXT'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'Adjustment'.
**            lst_fcat-edit = abap_true.
*            lst_fcat-hotspot = abap_true.
*            lst_fcat-outputlen = 12.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 39.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'TOTAL_PO_QTY'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'Total Print Run'.
*            lst_fcat-outputlen = 12.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 41.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'MARC_ISMARRIVALDATEAC'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-coltext = 'Actual Goods Arrival'.
*            lst_fcat-col_pos = 42.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'ESTIMATED_SOH'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-coltext = 'Estimated SOH'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 43.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'INITIAL_SOH'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 10.
*            lst_fcat-coltext = 'SOH Initial'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 44.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'CURRENT_SOH'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 10.
*            lst_fcat-coltext = 'SOH Current'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 45.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'REPRINT_QTY'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 10.
*            lst_fcat-coltext = 'Reprint Qty'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 46.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'REPRINT_PO_NO'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 12.
*            lst_fcat-coltext = 'Reprint PO'.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 47.
*            MODIFY li_fcat FROM lst_fcat.
*           WHEN 'COMMENTS'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 14.
*            lst_fcat-coltext = 'Add Comments'.
*            lst_fcat-just = 'C'.
*            lst_fcat-icon = abap_true.
*            lst_fcat-hotspot = abap_true.
*            lst_fcat-col_pos = 48.
*            MODIFY li_fcat FROM lst_fcat.
*          WHEN 'VIEW_COMMENTS'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-outputlen = 14.
*            lst_fcat-coltext = 'View Comments'.
*            lst_fcat-just = 'C'.
*            lst_fcat-icon = abap_true.
*            lst_fcat-hotspot = abap_true.
*            lst_fcat-col_pos = 49.
*            MODIFY li_fcat FROM lst_fcat.
**EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103
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
        LOOP AT li_constant INTO DATA(lst_constant).
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

        " Iterate the Media Issue Worklist to get the Media Issues of Previous Year
        LOOP AT i_statustab ASSIGNING FIELD-SYMBOL(<fs_wl>).
          APPEND INITIAL LINE TO li_pyr_data ASSIGNING FIELD-SYMBOL(<fs_pyr_data>).
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
           SELECT media_issue, pub_date, media_product, media_issue_identify,
                  journal_cd, issue, year1, plant, main_labels, back_labels
                  FROM zqtc_md_is_unsm INTO TABLE @li_md_is_unsm
                  FOR ALL ENTRIES IN @i_statustab
                  WHERE media_issue = @i_statustab-matnr AND
                        pub_date = @i_statustab-ismpubldate AND
                        media_product = @i_statustab-ismrefmdprod AND
                        media_issue_identify = @lc_digital AND
                        plant = @i_statustab-marc_werks.
           IF li_md_is_unsm[] IS NOT INITIAL.
             SORT li_md_is_unsm BY media_issue pub_date media_product plant.
           ENDIF.

*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719

            SELECT media_product, media_issue, print_method, pub_date,
                   acronym, issue_no_unconv, issue_no, actual_goods_arrival,
                   plant_marc, printer_po_number, printer_po_date,
                   printer, distributor, delivering_plant, issue_type,
                   om_actual, ob_actual, c_e, author, emlo, subs_actual,
                   initial_soh, main_labels, back_labels, wbs_element
*BOI: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
                 , wbs_element_unconv
*EOI: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
                   FROM zcds_litho_001 INTO TABLE @DATA(li_litho_001_dig)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_product = @i_statustab-ismrefmdprod AND
                         media_issue = @i_statustab-matnr AND
                         pub_date = @i_statustab-ismpubldate AND
                         plant_marc = @i_statustab-marc_werks.
            IF li_litho_001_dig[] IS NOT INITIAL.
              SORT li_litho_001_dig BY media_issue pub_date plant_marc.
            ENDIF.

            " Fetch the Reprint PO, Reprint qty from CDS view 'zcds_litho_002'
            SELECT media_product, media_issue, pub_date,
                   pub_year, plant_marc, reprint_po, reprint_qty
                   FROM zcds_litho_002 INTO TABLE @DATA(li_litho_002_dig)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_issue = @i_statustab-matnr.
            IF li_litho_002_dig[] IS NOT INITIAL.
              SORT li_litho_002_dig BY media_issue.
            ENDIF.

            " Fetch SOH (Current) from CDS view 'zcds_litho_004'
            SELECT media_product, media_issue, pub_date,
                   pub_year, plant_marc, soh
                   FROM zcds_litho_004 INTO TABLE @DATA(li_litho_004_dig)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_issue = @i_statustab-matnr AND
                         plant_marc = @i_statustab-marc_werks AND
                         lfgja = @lv_cyear AND
                         lfmon = @lv_prd.
            IF li_litho_004_dig[] IS NOT INITIAL.
              SORT li_litho_004_dig BY media_issue plant_marc.
            ENDIF.

            " Fetch Log details
            SELECT media_product, media_issue, pub_date,
                   plant_marc, om_actual, adjustment
                   FROM zscm_worklistlog INTO TABLE @DATA(li_dig_log)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_product = @i_statustab-ismrefmdprod AND
                         media_issue = @i_statustab-matnr AND
                         pub_date = @i_statustab-ismpubldate AND
                         plant_marc = @i_statustab-marc_werks.
            IF li_dig_log[] IS NOT INITIAL.
              SORT li_dig_log BY media_issue pub_date plant_marc.
            ENDIF.
*EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
        ENDIF.
*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          " Extract the additional info of all the Media Issues
          " for previous year via CDS View
          IF li_pyr_data[] IS NOT INITIAL.
            SELECT media_product, media_issue, pub_date, pub_year,
                   acronym, issue_no_unconv, issue_no,
                   plant_marc, delivering_plant,
                   om_actual, ob_actual, main_labels, back_labels, subs_actual
                   FROM zcds_litho_001 INTO TABLE @DATA(li_litho_001_py_dig)
                   FOR ALL ENTRIES IN @li_pyr_data
                   WHERE media_product = @li_pyr_data-ismrefmdprod AND
                         pub_year = @li_pyr_data-pyear AND
                         plant_marc = @li_pyr_data-plant.
            IF li_litho_001_py_dig[] IS NOT INITIAL.
              SORT li_litho_001_py_dig BY media_product pub_date(6) issue_no_unconv plant_marc.
            ENDIF.
*BOC OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "Replacing 'Renewal %' logic with ZCDS_LITHO_006/ZCDS_LITHO_007
**BOI OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021 "New 'Renewal %' logic.
*            " Fetch ML PYear from CDS view 'zcds_litho_005'
*            SELECT media_product, media_issue, pub_date,
*                   pub_year, plant_marc, ml_ren_calc_qty,
*                   dgt_lth_filter
*                   FROM zcds_litho_005 INTO TABLE @DATA(li_litho_005_py_dig)
*                   FOR ALL ENTRIES IN @li_pyr_data
*                   WHERE media_product = @li_pyr_data-ismrefmdprod AND
*                         media_issue = @li_pyr_data-matnr AND
*                         pub_year = @li_pyr_data-pyear AND
*                         plant_marc = @li_pyr_data-plant.
*            IF li_litho_005_py_dig[] IS NOT INITIAL.
*              SORT li_litho_005_py_dig BY media_product media_issue pub_date(6) plant_marc.
*            ENDIF.
**EOI OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021
*EOC OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
*BOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "Replacing 'Renewal %' logic with ZCDS_LITHO_006/ZCDS_LITHO_007
            SELECT matnr, ismrefmdprod, ismpubldate,
              ismyearnr, plant, media_issue_identify,
              issue_no_unconv, issue_no, ml_qty
              FROM zcds_litho_006 INTO TABLE @DATA(li_litho_006_py_dig)
              FOR ALL ENTRIES IN @li_pyr_data
                   WHERE ismrefmdprod = @li_pyr_data-ismrefmdprod AND
                         matnr = @li_pyr_data-matnr AND
                         ismyearnr = @li_pyr_data-pyear AND
                         plant = @li_pyr_data-plant.
            IF li_litho_006_py_dig[] IS NOT INITIAL.
              SORT li_litho_006_py_dig BY ismrefmdprod ismpubldate(6) issue_no_unconv plant.
            ENDIF.
*EOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
            " Fetch Max Issue of Pervious Year via zcds_jptmg0
            SELECT med_prod, matnr, ismnrinyear, ismnrinyear_num, ismyearnr
                   FROM zcds_jptmg0 INTO TABLE @DATA(li_jptmg0_max_issue_dig)
                   FOR ALL ENTRIES IN @li_pyr_data
                   WHERE med_prod = @li_pyr_data-ismrefmdprod AND
                         ismyearnr = @li_pyr_data-pyear.
            IF sy-subrc = 0.
             LOOP AT li_jptmg0_max_issue_dig ASSIGNING FIELD-SYMBOL(<lst_max_issue_dig>).
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
               SELECT media_product, media_issue, pub_year, om_actual, subs_actual
                      FROM zcds_litho_001 INTO TABLE @DATA(li_subs_plan_dig)
                      FOR ALL ENTRIES IN @li_jptmg0_max_issue_dig
                      WHERE media_product = @li_jptmg0_max_issue_dig-med_prod AND
                            media_issue = @li_jptmg0_max_issue_dig-matnr AND
                            pub_year = @li_jptmg0_max_issue_dig-ismyearnr.
               IF sy-subrc = 0.
                 SORT li_subs_plan_dig BY media_product pub_year.
               ENDIF.
*BOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "Replacing 'Renewal %' logic with ZCDS_LITHO_006/ZCDS_LITHO_007
               SELECT matnr, ismrefmdprod, ismpubldate,
                 ismyearnr, plant, media_issue_identify,
                 issue_no_unconv, issue_no, act_subs_qty
                 FROM zcds_litho_007 INTO TABLE @DATA(li_litho_007_py_dig)
                 FOR ALL ENTRIES IN @li_jptmg0_max_issue_dig
                      WHERE ismrefmdprod = @li_jptmg0_max_issue_dig-med_prod AND
                            matnr = @li_jptmg0_max_issue_dig-matnr AND
                            ismyearnr = @li_jptmg0_max_issue_dig-ismyearnr.
               IF li_litho_007_py_dig[] IS NOT INITIAL.
                 SORT li_litho_007_py_dig BY ismrefmdprod ismyearnr.
               ENDIF.
*EOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
             ENDIF.
            ENDIF. " IF sy-subrc = 0.
          ENDIF. " IF li_pyr_data[] IS NOT INITIAL.

          " Fetch the Renewal Period for Subs/BL-Buffer information
          SELECT tm_type, matnr, sub_type, act_date,
                 sub_flag, quantity, aenam, aedat
                 FROM zscm_litho_tm INTO TABLE @DATA(li_litho_tm_dig).
          IF sy-subrc = 0.
            SORT li_litho_tm_dig BY tm_type sub_type matnr.
          ENDIF.

          " Fetch the Log Information
          SELECT extnumber, altext FROM balhdr INTO TABLE @DATA(li_balhdr_dig)
                                   WHERE object = @lc_object AND
                                         subobject = @lc_subobj.
          IF sy-subrc = 0.
            SORT li_balhdr_dig BY extnumber.
            DELETE ADJACENT DUPLICATES FROM li_balhdr_dig COMPARING extnumber.
          ENDIF.
*EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*BOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
        " Extract all the Media Issues of previous year via CDS View
*        IF li_pyr_data[] IS NOT INITIAL.
*          SELECT media_issue, pub_date, media_product, media_issue_identify,
*                 journal_cd, issue, year1, plant, main_labels, back_labels
*                 FROM zqtc_md_is_unsm INTO TABLE @li_mi_unsm_pyd
*                 FOR ALL ENTRIES IN @li_pyr_data
*                 WHERE media_product = @li_pyr_data-ismrefmdprod AND
*                       media_issue_identify = @lc_digital AND
*                       year1 = @li_pyr_data-pyear AND
*                       plant = @li_pyr_data-plant.
*          IF li_mi_unsm_pyd[] IS NOT INITIAL.
*            SORT li_mi_unsm_pyd BY pub_date(6) media_product issue plant.
*          ENDIF.
*        ENDIF.
*EOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
        " Prcoess the MI Worklist to derive values for Custom fileds of
        " DIGITAL Report
        LOOP AT gt_outtab INTO DATA(lst_worklist).
          lv_sytabix = sy-tabix.
*BOI: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
          lv_counter = lv_counter + 1.
*EOI: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117

          " When the subsequent Media Issues are same
          IF lst_worklist-ismrefmdprod IS INITIAL AND lst_worklist-matnr IS INITIAL.
*BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*            DATA(lst_statustab) = i_statustab[ lv_sytabix ].
            DATA(lst_statustab) = i_statustab[ lv_counter ].
*EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
            MOVE-CORRESPONDING lst_statustab TO lst_worklist.
            CLEAR lst_statustab.
          ENDIF.
*          lv_volume = lst_worklist-matnr+4(4).
*          lv_volume = lv_volume - 1.
*          lv_matnr = lst_worklist-matnr.
*          lv_matnr+4(4) = lv_volume.

          DATA(lv_pubdate) = lst_worklist-ismpubldate(6).
          lv_pyear = lst_worklist-ismyearnr.
          lv_pyear = lv_pyear - 1.
          lv_pubdate(4) = lv_pyear.
*BOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
          " Get the Media Issue of Previous Year copy
*          READ TABLE li_mi_unsm_pyd INTO DATA(lst_mi_unsm_pyd) WITH KEY
*                     pub_date(6) = lv_pubdate
*                     media_product = lst_worklist-ismrefmdprod
*                     issue = lst_worklist-ismnrinyear
*                     plant = lst_worklist-marc_werks BINARY SEARCH.
*          IF sy-subrc <> 0.
*            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*               EXPORTING
*                 input         = lst_worklist-ismnrinyear
*               IMPORTING
*                 OUTPUT        = lst_worklist-ismnrinyear.
*               " Get the Media Issue of Previous Year copy
*               READ TABLE li_mi_unsm_pyd INTO lst_mi_unsm_pyd WITH KEY
*                          pub_date(6) = lv_pubdate
*                          media_product = lst_worklist-ismrefmdprod
*                          issue = lst_worklist-ismnrinyear
*                          plant = lst_worklist-marc_werks BINARY SEARCH.
*               IF sy-subrc <> 0.
*                 " Nothing to do
*               ENDIF.
*          ENDIF.
*          IF sy-subrc = 0.
**BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*            lst_worklist-ml_pyear = lst_mi_unsm_pyd-main_labels.   " ML Previous Year
**EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*EOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
*            lst_worklist-bl_pyear = lst_mi_unsm_pyd-back_labels.   " BL Actual for Prior Year
**BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*            DATA(lv_len) = strlen( lst_mi_unsm_pyd-media_issue ).
*            lv_len = lv_len - 1.
*            DATA(lv_mtyp) = lst_mi_unsm_pyd-media_issue+lv_len(1).
*            lv_matnr = lst_mi_unsm_pyd-media_issue+0(11).
*            CONCATENATE lv_matnr '*' lv_mtyp INTO lv_matnr.
*            lst_wildcard-low = lv_matnr.
*            APPEND lst_wildcard TO lr_wildcard.
            " Extract all the Media Issues of Previous Copies/Previous Year
            " to find the Medis Issue of Max
*            SELECT media_issue, media_product,
*                   issue, year1, plant, main_labels, back_labels
*                   FROM zqtc_md_is_unsm INTO TABLE @li_max_issue
*                   WHERE media_issue IN @lr_wildcard AND
*                         media_product = @lst_mi_unsm_pyd-media_product AND
*                         year1 = @lst_mi_unsm_pyd-year1 AND
*                         plant = @lst_mi_unsm_pyd-plant.
*            IF sy-subrc = 0 AND li_max_issue[] IS NOT INITIAL.
*              DESCRIBE TABLE li_max_issue LINES lv_count.
*              " If Multiple Media Issues Exists in Previous Year, then find the record which has Max Issue Number
*              IF lv_count > 1.
*                LOOP AT li_max_issue INTO lst_max_issue.
*                  MOVE-CORRESPONDING lst_max_issue TO lst_max_issue_f.
*                  APPEND lst_max_issue_f TO li_max_issue_f.
*                  CLEAR: lst_max_issue_f, lst_max_issue.
*                ENDLOOP.
*                SORT li_max_issue_f BY issue DESCENDING.
*                READ TABLE li_max_issue_f INTO lst_max_issue_f INDEX 1.
*                lv_sub_actual_py = lst_max_issue_f-main_labels + lst_max_issue_f-back_labels.
*                lst_worklist-sub_actual_py = lv_sub_actual_py.                  " Subs Actual for Prior Year
*              ELSE. " For Single Media Issue
*                READ TABLE li_max_issue INTO lst_max_issue INDEX 1.
*                lv_sub_actual_py = lst_max_issue-main_labels + lst_max_issue-back_labels.
*                lst_worklist-sub_actual_py = lv_sub_actual_py.                  " Subs Actual for Prior Year
*              ENDIF.

*              IF lst_worklist-sub_actual_py IS NOT INITIAL.
*                IF lst_worklist-ml_pyear IS NOT INITIAL.
*                  lst_worklist-renewal_per = ( lst_worklist-ml_pyear / lst_worklist-sub_actual_py ) * 100.  " Renewal Percentage
*                  CONDENSE lst_worklist-renewal_per NO-GAPS.
*                  FIND '.' IN lst_worklist-renewal_per MATCH OFFSET lv_off.
*                  IF sy-subrc <> 0.
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                      EXPORTING
*                        input  = lst_worklist-renewal_per
*                      IMPORTING
*                        output = lst_worklist-renewal_per.
*                    lv_renewal_per = lst_worklist-renewal_per.
*                  ELSEIF sy-subrc = 0.
*                    lv_renewal_per = lst_worklist-renewal_per+0(lv_off).
*                    lv_renewal_per = lv_renewal_per + 1.
*                    lst_worklist-renewal_per = lv_renewal_per.
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                      EXPORTING
*                        input  = lst_worklist-renewal_per
*                      IMPORTING
*                        output = lst_worklist-renewal_per.
*                    CLEAR lv_off.
*                  ENDIF.
*                ENDIF.
*              ENDIF.

*              IF lst_worklist-renewal_per IS NOT INITIAL.
*                lv_renewal_per = lst_worklist-renewal_per.
*                lst_worklist-not_renewed_per = 100 - lv_renewal_per.   " Not Renewed Percentage
*                CONDENSE lst_worklist-not_renewed_per NO-GAPS.
*              ENDIF.
*            ENDIF. " IF sy-subrc = 0 AND li_max_issue[] IS NOT INITIAL.
*BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
**BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
**          ENDIF. " IF sy-subrc = 0. of READ TABLE li_mi_unsm_pyd
**EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117

          READ TABLE li_md_is_unsm INTO DATA(lst_md_is_unsm) WITH KEY
                     media_issue = lst_worklist-matnr
                     pub_date = lst_worklist-ismpubldate
                     media_product = lst_worklist-ismrefmdprod
                     plant = lst_worklist-marc_werks BINARY SEARCH.
          IF sy-subrc = 0.
            lst_worklist-journal_code = lst_md_is_unsm-journal_cd.              " Journal Code
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*            lst_worklist-ml_cyear = lst_md_is_unsm-main_labels.                 " ML Current Year
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
            lst_worklist-print_method = lst_md_is_unsm-media_issue_identify.    " Print Method
          ENDIF.

          " Actual Goods Arrival Date should be less than ITP Date (Issue To Print Date) for
          " BL Planned Current Year value calculation
          " If Actual Goods Arrival Date is Greater than ITP Date, then
          " BL Planned Current Year value should be '0' (Zero)
*BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*          IF lst_worklist-marc_ismarrivaldateac < lv_itpdate.
*            IF lst_worklist-sub_actual_py IS NOT INITIAL.
*              lst_worklist-bl_pcurr_yr = ( lst_worklist-sub_actual_py * lv_percent ) / 100.
*              CONDENSE lst_worklist-bl_pcurr_yr NO-GAPS.
*              FIND '.' IN lst_worklist-bl_pcurr_yr MATCH OFFSET lv_off.
*              IF sy-subrc <> 0.
*                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                  EXPORTING
*                    input  = lst_worklist-bl_pcurr_yr
*                  IMPORTING
*                    output = lst_worklist-bl_pcurr_yr.
*                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr.
*              ELSEIF sy-subrc = 0.
*                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr+0(lv_off).
*                lv_bl_pcurr_yr = lv_bl_pcurr_yr + 1.
*                lst_worklist-bl_pcurr_yr = lv_bl_pcurr_yr.                        " BL Planned Current Year
*                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                  EXPORTING
*                    input  = lst_worklist-bl_pcurr_yr
*                  IMPORTING
*                    output = lst_worklist-bl_pcurr_yr.
**                lv_off = lv_off + 3.
**                lv_bl_pcurr_yr = lv_bl_pcurr_yr+0(lv_off).
*                CLEAR lv_off.
*              ENDIF.
*            ENDIF. " IF lst_worklist-sub_actual_py IS NOT INITIAL.
*          ELSEIF lst_worklist-marc_ismarrivaldateac > lv_itpdate.
*            CLEAR lst_worklist-bl_pcurr_yr.
*          ENDIF.
*EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*          " Renewal Calculation plus Current Year Subs
*          lv_issue_num = lst_worklist-ismnrinyear.
*          IF lv_issue_num = '0001'.  " For First Issue
*            IF lst_worklist-ml_cyear IS NOT INITIAL.
*              lst_worklist-ren_curr_subs = lst_worklist-ml_cyear.                " Renewal Calculation plus Current Year Subs
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                EXPORTING
*                  input  = lst_worklist-ren_curr_subs
*                IMPORTING
*                  output = lst_worklist-ren_curr_subs.
*              lv_ren_curr_subs = lst_worklist-ren_curr_subs.
*            ENDIF.
*          ELSE.     " From Second Issue
*            IF lst_worklist-renewal_per IS NOT INITIAL.
*              IF lst_worklist-ml_cyear IS NOT INITIAL.
*                lst_worklist-ren_curr_subs = ( lst_worklist-ml_cyear / lv_renewal_per ) * 100.
*                CONDENSE lst_worklist-ren_curr_subs NO-GAPS.
*                FIND '.' IN lst_worklist-ren_curr_subs MATCH OFFSET lv_off.
*                IF sy-subrc <> 0.
*                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                    EXPORTING
*                      input  = lst_worklist-ren_curr_subs
*                    IMPORTING
*                      output = lst_worklist-ren_curr_subs.
*                  lv_ren_curr_subs = lst_worklist-ren_curr_subs.
*                ELSEIF sy-subrc = 0.
*                 lv_ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
*                 lv_ren_curr_subs = lv_ren_curr_subs + 1.
*                 lst_worklist-ren_curr_subs = lv_ren_curr_subs.
*                 CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                    EXPORTING
*                      input  = lst_worklist-ren_curr_subs
*                    IMPORTING
*                      output = lst_worklist-ren_curr_subs.
**                  lv_off = lv_off + 3.
**                  lst_worklist-ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
*                  CLEAR lv_off.
*                ENDIF.
*              ENDIF. " IF lst_worklist-ml_cyear IS NOT INITIAL.
*            ENDIF. " IF lst_worklist-renewal_per IS NOT INITIAL.
*          ENDIF. " IF lv_issue_num = '0001'.  " For First Issue
*
*          " New Subs Purchase Request For Current Year
*          IF lst_worklist-ren_curr_subs IS NOT INITIAL OR
*             lst_worklist-bl_pcurr_yr IS NOT INITIAL.
*            lst_worklist-purchase_req = lv_bl_pcurr_yr + lv_ren_curr_subs.  " New Subs Purchase Request For Current Year
**            CONDENSE lst_worklist-purchase_req NO-GAPS.
**            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
**                EXPORTING
**                  input  = lst_worklist-purchase_req
**                IMPORTING
**                  output = lst_worklist-purchase_req.
*          ENDIF.
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          " Get the Additional Field values with reference to Report data
            READ TABLE li_litho_001_dig INTO DATA(lst_litho_001_dig) WITH KEY
                                    media_issue = lst_worklist-matnr
                                    pub_date = lst_worklist-ismpubldate
                                    plant_marc = lst_worklist-marc_werks BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_litho_001_dig-plant_marc <> lst_litho_001_dig-delivering_plant.
                DELETE gt_outtab INDEX lv_sytabix.
                CLEAR lst_litho_001_dig.
                CONTINUE.
              ENDIF.
              lst_worklist-print_method = lst_litho_001_dig-print_method.         " Print Method
              lst_worklist-journal_code = lst_litho_001_dig-acronym.              " Acronym
              lst_worklist-po_num       = lst_litho_001_dig-printer_po_number.    " Printer PO Number
              lst_worklist-po_create_dt = lst_litho_001_dig-printer_po_date.      " Printer PO Created Date
              lst_worklist-print_vendor = lst_litho_001_dig-printer.              " Printer
              lst_worklist-dist_vendor  = lst_litho_001_dig-distributor.          " Distributor
              lst_worklist-delv_plant   = lst_litho_001_dig-delivering_plant.     " Delivery Plant
              lst_worklist-issue_type   = lst_litho_001_dig-issue_type.           " Issue Type
*              lst_worklist-sub_actual_py = lst_litho_001_dig-subs_actual.         " Subs (Actual) "ED2K923462 TDIMANTHA 05/18/2021
*              lv_blcy_num = lst_litho_001_dig-back_labels.
*              lst_worklist-bl_pcurr_yr  = lv_blcy_num.                            " BL (CY)
*              SHIFT lst_worklist-bl_pcurr_yr LEFT DELETING LEADING '0'.
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
              lst_worklist-ml_cyear     = lst_litho_001_dig-main_labels.          " ML (CY)
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*              lst_worklist-ml_bl_cy     = lst_worklist-ml_cyear + lst_worklist-bl_pcurr_yr. " ML+BL (CY)
              lst_worklist-om_actual    =	lst_litho_001_dig-om_actual.            " OM (Actual)
              lst_worklist-ob_actual    =	lst_litho_001_dig-ob_actual.            " OB (Actual)
              lst_worklist-c_and_e      = lst_litho_001_dig-c_e.                  " C & E
              lst_worklist-author_copies =  lst_litho_001_dig-author.             " Author
              lst_worklist-emlo_copies  = lst_litho_001_dig-emlo.                 " EMLO
              lst_worklist-marc_ismarrivaldateac = lst_litho_001_dig-actual_goods_arrival.  " Actual Goods Arrival
              lst_worklist-initial_soh = lst_litho_001_dig-initial_soh.           " SOH (Initial)
*BOC: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
*              lst_worklist-wbs_element = lst_litho_001_dig-wbs_element.           " WBS Element
              CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
                EXPORTING
                  input         = lst_litho_001_dig-wbs_element_unconv
               IMPORTING
                 OUTPUT        = lst_worklist-wbs_element.
*EOC: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
          ENDIF.

*BOI: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*BOC OTCM-46971 ED2K924981 TDIMANTHA 11/10/2021
**BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*        lv_issue_num = lst_worklist-ismnrinyear.
*          IF lv_issue_num = '0001'.  " For First Issue
*            IF lst_worklist-ml_cyear IS NOT INITIAL.
*              lst_worklist-ren_curr_subs = lst_worklist-ml_cyear.                " Renewal Calculation plus Current Year Subs
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                EXPORTING
*                  input  = lst_worklist-ren_curr_subs
*                IMPORTING
*                  output = lst_worklist-ren_curr_subs.
*              lv_ren_curr_subs = lst_worklist-ren_curr_subs.
*            ENDIF.
*          ELSE.     " From Second Issue
*            IF lst_worklist-renewal_per IS NOT INITIAL.
*              IF lst_worklist-ml_cyear IS NOT INITIAL.
*                lst_worklist-ren_curr_subs = ( lst_worklist-ml_cyear / lv_renewal_per ) * 100.
*                CONDENSE lst_worklist-ren_curr_subs NO-GAPS.
*                FIND '.' IN lst_worklist-ren_curr_subs MATCH OFFSET lv_off.
*                IF sy-subrc <> 0.
*                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                    EXPORTING
*                      input  = lst_worklist-ren_curr_subs
*                    IMPORTING
*                      output = lst_worklist-ren_curr_subs.
*                  lv_ren_curr_subs = lst_worklist-ren_curr_subs.
*                ELSEIF sy-subrc = 0.
*                 lv_ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
*                 lv_ren_curr_subs = lv_ren_curr_subs + 1.
*                 lst_worklist-ren_curr_subs = lv_ren_curr_subs.
*                 CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                    EXPORTING
*                      input  = lst_worklist-ren_curr_subs
*                    IMPORTING
*                      output = lst_worklist-ren_curr_subs.
**                  lv_off = lv_off + 3.
**                  lst_worklist-ren_curr_subs = lst_worklist-ren_curr_subs+0(lv_off).
*                  CLEAR lv_off.
*                ENDIF.
*              ENDIF. " IF lst_worklist-ml_cyear IS NOT INITIAL.
*            ENDIF. " IF lst_worklist-renewal_per IS NOT INITIAL.
*          ENDIF. " IF lv_issue_num = '0001'.  " For First Issue
**BOC ED2K923103 TDIMANTHA 23.04.2021
*EOC OTCM-46971 ED2K924981 TDIMANTHA 11/10/2021 "Fixing issue 'Renewal Calculation plus Current Year Subs' shows empty value
* "Moved code segment sfter 'Renewal %'
*          " New Subs Purchase Request For Current Year
*          IF lst_worklist-ren_curr_subs IS NOT INITIAL OR
*             lst_worklist-bl_pcurr_yr IS NOT INITIAL.
*            lst_worklist-purchase_req = lv_bl_pcurr_yr + lv_ren_curr_subs.  " New Subs Purchase Request For Current Year
**            CONDENSE lst_worklist-purchase_req NO-GAPS.
**            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
**                EXPORTING
**                  input  = lst_worklist-purchase_req
**                IMPORTING
**                  output = lst_worklist-purchase_req.
*          ENDIF.
*EOC ED2K923103 TDIMANTHA 23.04.2021
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*              IF lst_worklist-sub_actual_py IS NOT INITIAL.
*                IF lst_worklist-ml_pyear IS NOT INITIAL.
*                  lst_worklist-renewal_per = ( lst_worklist-ml_pyear / lst_worklist-sub_actual_py ) * 100.  " Renewal Percentage
*                  CONDENSE lst_worklist-renewal_per NO-GAPS.
*                  FIND '.' IN lst_worklist-renewal_per MATCH OFFSET lv_off.
*                  IF sy-subrc <> 0.
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                      EXPORTING
*                        input  = lst_worklist-renewal_per
*                      IMPORTING
*                        output = lst_worklist-renewal_per.
*                    lv_renewal_per = lst_worklist-renewal_per.
*                  ELSEIF sy-subrc = 0.
*                    lv_renewal_per = lst_worklist-renewal_per+0(lv_off).
*                    lv_renewal_per = lv_renewal_per + 1.
*                    lst_worklist-renewal_per = lv_renewal_per.
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                      EXPORTING
*                        input  = lst_worklist-renewal_per
*                      IMPORTING
*                        output = lst_worklist-renewal_per.
*                    CLEAR lv_off.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*
*              IF lst_worklist-renewal_per IS NOT INITIAL.
*                lv_renewal_per = lst_worklist-renewal_per.
*                lst_worklist-not_renewed_per = 100 - lv_renewal_per.   " Not Renewed Percentage
*                CONDENSE lst_worklist-not_renewed_per NO-GAPS.
*              ENDIF.
*
*              IF lst_worklist-marc_ismarrivaldateac < lv_itpdate.
*            IF lst_worklist-sub_actual_py IS NOT INITIAL.
*              lst_worklist-bl_pcurr_yr = ( lst_worklist-sub_actual_py * lv_percent ) / 100.
*              CONDENSE lst_worklist-bl_pcurr_yr NO-GAPS.
*              FIND '.' IN lst_worklist-bl_pcurr_yr MATCH OFFSET lv_off.
*              IF sy-subrc <> 0.
*                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                  EXPORTING
*                    input  = lst_worklist-bl_pcurr_yr
*                  IMPORTING
*                    output = lst_worklist-bl_pcurr_yr.
*                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr.
*              ELSEIF sy-subrc = 0.
*                lv_bl_pcurr_yr = lst_worklist-bl_pcurr_yr+0(lv_off).
*                lv_bl_pcurr_yr = lv_bl_pcurr_yr + 1.
*                lst_worklist-bl_pcurr_yr = lv_bl_pcurr_yr.                        " BL Planned Current Year
*                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                  EXPORTING
*                    input  = lst_worklist-bl_pcurr_yr
*                  IMPORTING
*                    output = lst_worklist-bl_pcurr_yr.
*                CLEAR lv_off.
*              ENDIF.
*            ENDIF. " IF lst_worklist-sub_actual_py IS NOT INITIAL.
*          ELSEIF lst_worklist-marc_ismarrivaldateac > lv_itpdate.
*            CLEAR lst_worklist-bl_pcurr_yr.
*          ENDIF.
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*EOI: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117

          " Get the Log values
            READ TABLE li_dig_log INTO DATA(lst_dig_log) WITH KEY
                                    media_issue = lst_worklist-matnr
                                    pub_date = lst_worklist-ismpubldate
                                    plant_marc = lst_worklist-marc_werks BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_dig_log-plant_marc <> lst_litho_001_dig-delivering_plant.
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
              READ TABLE li_litho_tm_dig INTO DATA(lst_litho_tm_dig) WITH KEY tm_type = lc_blbf
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
              READ TABLE li_subs_plan_dig INTO DATA(lst_subs_plan_dig) WITH KEY
                                      media_product = lst_worklist-ismrefmdprod
                                      pub_year = lv_pyear BINARY SEARCH.
              IF sy-subrc = 0.
*                <lst_worklist>-subs_plan = lst_subs_plan-subs_actual.             " Subs (Plan)
                lst_worklist-om_plan   = lst_subs_plan_dig-om_actual.               " OM (Plan)
              ENDIF.
*BOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
              READ TABLE li_litho_007_py_dig INTO DATA(lst_litho_007_py_dig) WITH KEY
                                      ismrefmdprod = lst_worklist-ismrefmdprod
                                      ismyearnr = lv_pyear BINARY SEARCH.
              IF sy-subrc = 0.
                lst_worklist-subs_actual_py_ps = lst_litho_007_py_dig-act_subs_qty.       " Subs Actual PY (Paid Subs)
              ENDIF.
*EOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
              lv_pubdate = lst_worklist-ismpubldate(6).
              lv_pubdate(4) = lv_pyear.
              " Get the Media Issue of Previous Year Copy based on Plant
              READ TABLE li_litho_001_py_dig INTO DATA(lst_litho_001_py_dig) WITH KEY
                         media_product = lst_worklist-ismrefmdprod
                         pub_date(6) = lv_pubdate
                         issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                         plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input         = lst_litho_001_dig-issue_no_unconv
                  IMPORTING
                    OUTPUT        = lst_litho_001_dig-issue_no_unconv.
                  " Get the Media Issue of Previous Year Copy
                  READ TABLE li_litho_001_py_dig INTO lst_litho_001_py_dig WITH KEY
                             media_product = lst_worklist-ismrefmdprod
                             pub_date(6) = lv_pubdate
                             issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                             plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
                  IF sy-subrc <> 0.
*BOI: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
                    " Nothing to do
                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                      EXPORTING
                        input         = lst_litho_001_dig-issue_no_unconv
                      IMPORTING
                        OUTPUT        = lst_litho_001_dig-issue_no_unconv.
                    " Get the Media Issue of Previous Year Copy
                    READ TABLE li_litho_001_py_dig INTO lst_litho_001_py_dig WITH KEY
                                media_product = lst_worklist-ismrefmdprod
                                pub_date(6) = lv_pubdate
                                issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                                plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
                    IF sy-subrc <> 0.
                    ENDIF.
*EOI: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
                  ENDIF.
              ENDIF.
              IF sy-subrc = 0.
*BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
                lst_worklist-ml_pyear = lst_litho_001_py_dig-main_labels.           " ML (PY)
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*                lst_worklist-bl_pyear = lst_litho_001_py_dig-back_labels.           " BL (PY)
*EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*                lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*BOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
                lst_worklist-bl_pyear = lst_litho_001_py_dig-back_labels.           " BL (PY)
                lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*EOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297

                lst_worklist-ob_plan = lst_litho_001_py_dig-ob_actual.              " OB (Plan)
                lst_worklist-sub_actual_py = lst_litho_001_py_dig-subs_actual. "ED2K923462 TDIMANTHA 05/18/2021
              ELSE.
                DATA(li_litho1_py_tmp_dig) = li_litho_001_py_dig.
                DELETE li_litho1_py_tmp_dig WHERE media_product <> lst_worklist-ismrefmdprod AND
                                              pub_date(6) <> lv_pubdate AND
                                              issue_no_unconv <> lst_litho_001_dig-issue_no_unconv.
                LOOP AT li_litho1_py_tmp_dig ASSIGNING FIELD-SYMBOL(<lst_litho1_py_tmp_dig>).
                  IF <lst_litho1_py_tmp_dig>-plant_marc = <lst_litho1_py_tmp_dig>-delivering_plant.
*BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
                    lst_worklist-ml_pyear = <lst_litho1_py_tmp_dig>-main_labels.           " ML (PY)
*EOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*                    lst_worklist-bl_pyear = <lst_litho1_py_tmp_dig>-back_labels.           " BL (PY)
*EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
*                    lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*BOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297
                lst_worklist-bl_pyear = <lst_litho1_py_tmp_dig>-back_labels.           " BL (PY)
                lst_worklist-ml_bl_py = lst_worklist-ml_pyear + lst_worklist-bl_pyear.  " ML+BL (PY)
*EOC: OTCM-30221(R096) TDIMANTHA 06-May-2021 ED2K923297

                    lst_worklist-ob_plan = <lst_litho1_py_tmp_dig>-ob_actual.              " OB (Plan)
*                    lst_worklist-sub_actual_py = <lst_litho1_py_tmp_dig>-subs_actual. "ED2K923462 TDIMANTHA 05/18/2021
                  ENDIF.
                ENDLOOP.
                CLEAR: li_litho1_py_tmp_dig[].
              ENDIF.
*BOI OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021

*BOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
              " Get the Media Issue of Previous Year Copy based on Plant
              READ TABLE li_litho_006_py_dig INTO DATA(lst_litho_006_py_dig) WITH KEY
                         ismrefmdprod = lst_worklist-ismrefmdprod
                         ismpubldate(6) = lv_pubdate
                         issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                         plant = lst_litho_001_dig-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input         = lst_litho_001_dig-issue_no_unconv
                  IMPORTING
                    OUTPUT        = lst_litho_001_dig-issue_no_unconv.
                  " Get the Media Issue of Previous Year Copy
                  READ TABLE li_litho_006_py_dig INTO lst_litho_006_py_dig WITH KEY
                             ismrefmdprod = lst_worklist-ismrefmdprod
                             ismpubldate(6) = lv_pubdate
                             issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                             plant = lst_litho_001_dig-plant_marc BINARY SEARCH.
                  IF sy-subrc <> 0.
                    " Nothing to do
                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                      EXPORTING
                        input         = lst_litho_001_dig-issue_no_unconv
                      IMPORTING
                        OUTPUT        = lst_litho_001_dig-issue_no_unconv.
                    " Get the Media Issue of Previous Year Copy
                    READ TABLE li_litho_006_py_dig INTO lst_litho_006_py_dig WITH KEY
                                ismrefmdprod = lst_worklist-ismrefmdprod
                                ismpubldate(6) = lv_pubdate
                                issue_no_unconv = lst_litho_001_dig-issue_no_unconv
                                plant = lst_litho_001_dig-plant_marc BINARY SEARCH.
                    IF sy-subrc <> 0.
                    ENDIF.
                  ENDIF.
              ENDIF.
              IF sy-subrc = 0.
                lst_worklist-ml_py_ps = lst_litho_006_py_dig-ml_qty.      "ML PY (Paid Subs)
              ENDIF.
*EOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "New 'Renewal %' logic from ZCDS_LITHO_005
*BOC OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "Replacing New 'Renewal %' logic from ZCDS_LITHO_005 with ZCDS_LITHO_006/007
*             CLEAR: lv_py_issue, lv_py_year.
*             lv_py_issue = lst_litho_001_dig-media_issue.
*             lv_py_year  = lv_py_issue+4(4) - 1.
*             lv_py_issue+4(4) =  lv_py_year.
*
*             READ TABLE li_litho_005_py_dig INTO DATA(lst_litho_005_py_dig) WITH KEY
*                         media_product = lst_worklist-ismrefmdprod
*                         media_issue = lv_py_issue
*                         pub_date(6) = lv_pubdate
*                         plant_marc = lst_litho_001_dig-plant_marc BINARY SEARCH.
**EOI OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021
**BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780
*             IF lst_worklist-sub_actual_py IS NOT INITIAL.
**BOC OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021 "New 'Renewal %' logic from ZCDS_LITHO_005
**                IF lst_worklist-ml_pyear IS NOT INITIAL.
*                IF lst_litho_005_py_dig-ml_ren_calc_qty IS NOT INITIAL.
**                  lst_worklist-renewal_per = ( lst_worklist-ml_pyear / lst_worklist-sub_actual_py ) * 100.  " Renewal Percentage
*                  lst_worklist-renewal_per = ( lst_litho_005_py_dig-ml_ren_calc_qty / lst_worklist-sub_actual_py ) * 100.  " Renewal Percentage
**EOC OTCM-46971 ED2K923462 TDIMANTHA 20-July-2021
*EOC OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
*BOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021 "New 'Renewal %' logic. From ZCDS_LITHO_006/ZCDS_LITHO_007 replacing ZCDS_LITHO_005 logic
             IF lst_worklist-subs_actual_py_ps IS NOT INITIAL.
                IF lst_worklist-ml_py_ps IS NOT INITIAL.
                  lst_worklist-renewal_per = ( lst_worklist-ml_py_ps / lst_worklist-subs_actual_py_ps ) * 100.  " Renewal Percentage
*EOI OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
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
*BOC OTCM-46971 ED2K924981 TDIMANTHA 11/10/2021
* "Fixing issue 'Renewal Calculation plus Current Year Subs' show empty values.
* "Move code segment for Renewal Calculation plus Current Year Subs' calc after 'Renewal %' logic.
             lv_issue_num = lst_worklist-ismnrinyear.
          IF lv_issue_num = '0001'.  " For First Issue
            IF lst_worklist-ml_cyear IS NOT INITIAL.
              lst_worklist-ren_curr_subs = lst_worklist-ml_cyear. " Renewal Calculation plus Current Year Subs
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
*EOC OTCM-46971 ED2K924981 TDIMANTHA 11/10/2021
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
*BOC: OTCM-44349(R096) TDIMANTHA 30-MARCH-2021  ED2K922780

              " Reprint Qty, Reprint PO No.
              LOOP AT li_litho_002_dig INTO DATA(lst_litho_0020_dig) WHERE media_issue = lst_worklist-matnr.
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

              " New_Subs
              SELECT media_issue, pub_year, plant_marc, SUM( new_subs ) as new_subs, zzvyp
                     FROM zcds_litho_003 INTO TABLE @DATA(li_litho_003_dig)
                     WHERE media_issue = @lst_worklist-matnr AND
                           plant_marc = @lst_worklist-marc_werks AND
                           zzvyp = @lst_worklist-ismyearnr
                     GROUP BY media_issue, pub_year, plant_marc, zzvyp.
              IF sy-subrc = 0.
                READ TABLE li_litho_003_dig INTO DATA(lst_litho_003_dig) INDEX 1.
                IF sy-subrc = 0.
                  lst_worklist-new_subs = lst_litho_003_dig-new_subs.                  " New_Subs
                  CLEAR: li_litho_003_dig[],lst_litho_0020_dig.
                ENDIF.
              ENDIF.

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


*BOI: TDIMANTHA 20-Apr-2021 ED2K923103
              lst_worklist-purchase_req = lst_worklist-ren_curr_subs + lst_worklist-bl_buffer.  " New Subs Purchase Request For Current Year
*EOI: TDIMANTHA 20-Apr-2021 ED2K923103
              " Sub Total (Subs + OM + BL Buffer)
*BOC: TDIMANTHA 20-Apr-2021 ED2K923103
**BOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
**              lst_worklist-sub_total = lst_worklist-subs_to_print + lst_worklist-om_to_print.
*              lst_worklist-sub_total = lst_worklist-purchase_req + lst_worklist-om_actual + lst_worklist-bl_buffer.
**EOC: OTCM-30221(R096) TDIMANTHA 25-FEB-2021  ED2K922117
              lst_worklist-sub_total = lst_worklist-purchase_req + lst_worklist-om_actual.
*EOC: TDIMANTHA 20-Apr-2021 ED2K923103

              " PRINT RUN: TOTAL PO QTY
              lst_worklist-total_po_qty = lst_worklist-sub_total + lst_worklist-c_and_e + lst_worklist-author_copies +
                                            lst_worklist-emlo_copies + lst_worklist-adjustment.

              " Estimated SOH
              lst_worklist-estimated_soh = lst_worklist-total_po_qty - lst_worklist-ml_cyear - lst_worklist-om_actual -
                                             lst_worklist-c_and_e - lst_worklist-author_copies - lst_worklist-emlo_copies.
*
*              " Stock on Hand (Current)
*              READ TABLE li_litho_004 INTO DATA(lst_litho_004) WITH KEY
*                                      media_issue = <lst_worklist>-matnr
*                                      plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
*              IF sy-subrc = 0.
*                <lst_worklist>-current_soh = lst_litho_004-soh.                    " SOH (Current)
*              ENDIF.
*
              " Assign the Log Icon
              lst_worklist-comments = lc_comments.
              DATA(lv_external_num_dig) = |{ lst_worklist-matnr }{ lst_worklist-marc_werks }|.
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
*
*            ENDIF. " IF sy-subrc = 0. READ TABLE li_litho_001...
*
            " Clear the structures
            CLEAR: lst_litho_001_py_dig, lst_litho_001_dig,lst_litho_003_dig, "lst_litho_004_dig,
                   lst_subs_plan_dig, lst_litho_tm_dig, lst_dig_log, "lst_litho_005_py_dig
                   lst_litho_006_py_dig,lst_litho_007_py_dig. "OTCM-46971 ED2K924440 TDIMANTHA 10/21/2021
*EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*BOI: TDIMANTHA 20-Apr-2021 ED2K923103
          CLEAR: lst_worklist-is_renewal, lst_worklist-is_renewal_om, lst_worklist-SUB_ACTUAL_PY,
                 lst_worklist-subs_plan, lst_worklist-BL_PCURR_YR, lst_worklist-ml_bl_cy.
*EOI: TDIMANTHA 20-Apr-2021 ED2K923103

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
*BOI: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
          WHEN 'WBS_ELEMENT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'WBS Element'.
            lst_fcat-JUST = 'L'.
            lst_fcat-col_pos = 11.
            MODIFY li_fcat FROM lst_fcat.
*EOI: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
          WHEN 'ISMNRINYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-edit = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'Issue No'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 11.
            lst_fcat-col_pos = 12.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PO_NUM'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Printer PO#'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 12.
            lst_fcat-col_pos = 13.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PO_CREATE_DT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Printer PO Date'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 13.
            lst_fcat-col_pos = 14.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'PRINT_VENDOR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Printer'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 14.
            lst_fcat-col_pos = 15.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            lst_fcat-just = 'L'.
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'DIST_VENDOR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Distributor'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 15.
            lst_fcat-col_pos = 16.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'DELV_PLANT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Deliv. Plant'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 16.
            lst_fcat-col_pos = 17.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ISSUE_TYPE'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Issue Type'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 17.
            lst_fcat-col_pos = 18.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'SUB_ACTUAL_PY'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Subs (Actual)'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 18.
            lst_fcat-col_pos = 19.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'SUBS_PLAN'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'Subs Plan'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 19.
            lst_fcat-col_pos = 20.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'NEW_SUBS'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'New Subs'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 20.
            lst_fcat-col_pos = 21.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'BL_PYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 8.
            lst_fcat-coltext = 'BL (PY)'.
            lst_fcat-JUST = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 21.
            lst_fcat-col_pos = 22.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'BL_PCURR_YR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 8.
            lst_fcat-coltext = 'BL (CY)'.
            lst_fcat-JUST = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 22.
            lst_fcat-col_pos = 23.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ML_PYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'ML (PY)'.
            lst_fcat-outputlen = 8.
            lst_fcat-JUST = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 23.
            lst_fcat-col_pos = 24.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
           WHEN 'ML_BL_PY'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'ML + BL(PY)'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 24.
            lst_fcat-col_pos = 25.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ML_CYEAR'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'ML (CY)'.
            lst_fcat-outputlen = 8.
            lst_fcat-JUST = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 25.
            lst_fcat-col_pos = 26.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ML_BL_CY'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'ML + BL(CY)'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 26.
            lst_fcat-col_pos = 27.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'BL_BUFFER'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'BL Buffer'.
            lst_fcat-outputlen = 10.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 27.
            lst_fcat-col_pos = 28.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'SUBS_TO_PRINT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Subs to Print'.
            lst_fcat-outputlen = 11.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 28.
            lst_fcat-col_pos = 29.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'OM_PLAN'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'OM Plan'.
            lst_fcat-outputlen = 8.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 29.
            lst_fcat-col_pos = 30.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
*BOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
*          WHEN 'OM_ACTUAL'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'OM Actual'.
*            lst_fcat-outputlen = 9.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 30.
*            MODIFY li_fcat FROM lst_fcat.
          WHEN 'OM_ACTUAL_TXT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'OM Actual'.
            lst_fcat-outputlen = 9.
            lst_fcat-just = 'L'.
            lst_fcat-hotspot = abap_true.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 30.
            lst_fcat-col_pos = 31.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
*EOC: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
          WHEN 'OB_PLAN'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'OB Plan'.
            lst_fcat-outputlen = 8.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 31.
            lst_fcat-col_pos = 32.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'OB_ACTUAL'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'OB Actual'.
            lst_fcat-outputlen = 9.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 32.
            lst_fcat-col_pos = 33.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'OM_TO_PRINT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'OM to Print'.
            lst_fcat-outputlen = 10.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 33.
            lst_fcat-col_pos = 34.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'SUB_TOTAL'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Sub total(Subs + OM)'.
            lst_fcat-outputlen = 10.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 34.
            lst_fcat-col_pos = 35.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'C_AND_E'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'C & E'.
            lst_fcat-outputlen = 8.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 35.
            lst_fcat-col_pos = 36.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'AUTHOR_COPIES'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Author'.
            lst_fcat-outputlen = 8.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 36.
            lst_fcat-col_pos = 37.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'EMLO_COPIES'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'EMLO'.
            lst_fcat-outputlen = 8.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 37.
            lst_fcat-col_pos = 38.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
*BOC: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
*          WHEN 'ADJUSTMENT'.
*            lst_fcat-no_out = abap_false.
*            lst_fcat-coltext = 'Adjustment'.
*            lst_fcat-edit = abap_true.
*            lst_fcat-outputlen = 12.
*            lst_fcat-just = 'L'.
*            lst_fcat-col_pos = 38.
*            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ADJUSTMENT_TXT'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Adjustment'.
            lst_fcat-hotspot = abap_true.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 38.
            lst_fcat-col_pos = 39.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
          WHEN 'TOTAL_PO_QTY'.
            lst_fcat-no_out = abap_false.
            lst_fcat-coltext = 'Print Run: Total PO Qty'.
            lst_fcat-outputlen = 12.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 39.
            lst_fcat-col_pos = 40.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'MARC_ISMARRIVALDATEAC'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Actual Goods Arrival'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 40.
            lst_fcat-col_pos = 41.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'ESTIMATED_SOH'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Estimated SOH'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 41.
            lst_fcat-col_pos = 42.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'INITIAL_SOH'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'SOH Initial'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 42.
            lst_fcat-col_pos = 43.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'CURRENT_SOH'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'SOH Current'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 43.
            lst_fcat-col_pos = 44.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'REPRINT_QTY'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 10.
            lst_fcat-coltext = 'Reprint Qty'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 44.
            lst_fcat-col_pos = 45.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'REPRINT_PO_NO'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 12.
            lst_fcat-coltext = 'Reprint PO'.
            lst_fcat-just = 'L'.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 45.
            lst_fcat-col_pos = 46.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
           WHEN 'COMMENTS'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 14.
            lst_fcat-coltext = 'Add Comments'.
            lst_fcat-just = 'C'.
            lst_fcat-icon = abap_true.
            lst_fcat-hotspot = abap_true.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 46.
            lst_fcat-col_pos = 47.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
            MODIFY li_fcat FROM lst_fcat.
          WHEN 'VIEW_COMMENTS'.
            lst_fcat-no_out = abap_false.
            lst_fcat-outputlen = 14.
            lst_fcat-coltext = 'View Comments'.
            lst_fcat-just = 'C'.
            lst_fcat-icon = abap_true.
            lst_fcat-hotspot = abap_true.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*            lst_fcat-col_pos = 47.
            lst_fcat-col_pos = 48.
*BOC: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
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
*             PERIOD_IN           = '000'
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
            SELECT media_product, media_issue, print_method, pub_date,
                   acronym, issue_no_unconv, issue_no, actual_goods_arrival,
                   plant_marc, printer_po_number, printer_po_date,
                   printer, distributor, delivering_plant, issue_type,
                   om_actual, ob_actual, c_e, author, emlo, subs_actual,
                   initial_soh, main_labels, back_labels, wbs_element "TD ED2K922117 23.02.2021
*BOI: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
                  ,wbs_element_unconv
*EOI: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
                   FROM zcds_litho_001 INTO TABLE @DATA(li_litho_001)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_product = @i_statustab-ismrefmdprod AND
                         media_issue = @i_statustab-matnr AND
                         pub_date = @i_statustab-ismpubldate AND
                         plant_marc = @i_statustab-marc_werks.
            IF li_litho_001[] IS NOT INITIAL.
              SORT li_litho_001 BY media_issue pub_date plant_marc.
            ENDIF.

            " Fetch the Reprint PO, Reprint qty from CDS view 'zcds_litho_002'
            SELECT media_product, media_issue, pub_date,
                   pub_year, plant_marc, reprint_po, reprint_qty
                   FROM zcds_litho_002 INTO TABLE @DATA(li_litho_002)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_issue = @i_statustab-matnr.
            IF li_litho_002[] IS NOT INITIAL.
              SORT li_litho_002 BY media_issue.
            ENDIF.

          " Fetch NEW_SUBS from CDS view 'zcds_litho_003'
*          LOOP AT gt_outtab INTO DATA(lst_outtab).
*            SELECT media_product, media_issue, pub_year, plant_marc, SUM( new_subs ) as new_subs, zzvyp
*                   FROM zcds_litho_003 APPENDING TABLE @DATA(li_litho_003)
*                   WHERE media_issue = @lst_outtab-matnr AND
*                         zzvyp = @lst_outtab-ismyearnr
*                   GROUP BY media_product, media_issue, pub_year, plant_marc, zzvyp.
*            CLEAR lst_outtab.
*          ENDLOOP.
*          IF li_litho_003[] IS NOT INITIAL.
*            SORT li_litho_003 BY media_issue zzvyp.
*          ENDIF.

            " Fetch SOH (Current) from CDS view 'zcds_litho_004'
            SELECT media_product, media_issue, pub_date,
                   pub_year, plant_marc, soh
                   FROM zcds_litho_004 INTO TABLE @DATA(li_litho_004)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_issue = @i_statustab-matnr AND
                         plant_marc = @i_statustab-marc_werks AND
                         lfgja = @lv_cyear AND
                         lfmon = @lv_prd.
            IF li_litho_004[] IS NOT INITIAL.
              SORT li_litho_004 BY media_issue plant_marc.
            ENDIF.
*BOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
            " Fetch Log details
            SELECT media_product, media_issue, pub_date,
                   plant_marc, om_actual, adjustment
                   FROM zscm_worklistlog INTO TABLE @DATA(li_litho_log)
                   FOR ALL ENTRIES IN @i_statustab
                   WHERE media_product = @i_statustab-ismrefmdprod AND
                         media_issue = @i_statustab-matnr AND
                         pub_date = @i_statustab-ismpubldate AND
                         plant_marc = @i_statustab-marc_werks.
            IF li_litho_log[] IS NOT INITIAL.
              SORT li_litho_log BY media_issue pub_date plant_marc.
            ENDIF.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
          ENDIF. " IF i_statustab[] IS NOT INITIAL.

          " Extract the additional info of all the Media Issues
          " for previous year via CDS View
          IF li_pyr_data[] IS NOT INITIAL.
            SELECT media_product, media_issue, pub_date, pub_year,
                   acronym, issue_no_unconv, issue_no,
                   plant_marc, delivering_plant,
                   om_actual, ob_actual, main_labels, back_labels
                   FROM zcds_litho_001 INTO TABLE @DATA(li_litho_001_py)
                   FOR ALL ENTRIES IN @li_pyr_data
                   WHERE media_product = @li_pyr_data-ismrefmdprod AND
                         pub_year = @li_pyr_data-pyear AND
                         plant_marc = @li_pyr_data-plant.
            IF li_litho_001_py[] IS NOT INITIAL.
              SORT li_litho_001_py BY media_product pub_date(6) issue_no_unconv plant_marc.
            ENDIF.

            " Fetch Max Issue of Pervious Year via zcds_jptmg0
            SELECT med_prod, matnr, ismnrinyear, ismnrinyear_num, ismyearnr
                   FROM zcds_jptmg0 INTO TABLE @DATA(li_jptmg0_max_issue)
                   FOR ALL ENTRIES IN @li_pyr_data
                   WHERE med_prod = @li_pyr_data-ismrefmdprod AND
                         ismyearnr = @li_pyr_data-pyear.
            IF sy-subrc = 0.
             LOOP AT li_jptmg0_max_issue ASSIGNING FIELD-SYMBOL(<lst_max_issue>).
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
               SELECT media_product, media_issue, pub_year, om_actual, subs_actual
                      FROM zcds_litho_001 INTO TABLE @DATA(li_subs_plan)
                      FOR ALL ENTRIES IN @li_jptmg0_max_issue
                      WHERE media_product = @li_jptmg0_max_issue-med_prod AND
                            media_issue = @li_jptmg0_max_issue-matnr AND
                            pub_year = @li_jptmg0_max_issue-ismyearnr.
               IF sy-subrc = 0.
                 SORT li_subs_plan BY media_product pub_year.
               ENDIF.
             ENDIF.
            ENDIF. " IF sy-subrc = 0.
          ENDIF. " IF li_pyr_data[] IS NOT INITIAL.

          " Fetch the Renewal Period for Subs/BL-Buffer information
          SELECT tm_type, matnr, sub_type, act_date,
                 sub_flag, quantity, aenam, aedat
                 FROM zscm_litho_tm INTO TABLE @DATA(li_litho_tm).
          IF sy-subrc = 0.
            SORT li_litho_tm BY tm_type sub_type matnr.
          ENDIF.

          " Fetch the Log Information
          SELECT extnumber, altext FROM balhdr INTO TABLE @DATA(li_balhdr)
                                   WHERE object = @lc_object AND
                                         subobject = @lc_subobj.
          IF sy-subrc = 0.
            SORT li_balhdr BY extnumber.
            DELETE ADJACENT DUPLICATES FROM li_balhdr COMPARING extnumber.
          ENDIF.

          " Prcoess the MI Worklist to derive the values for Custom fileds of
          " LITHO Report
          LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<lst_worklist>).
            lv_sytabix = sy-tabix.
            lv_counter = lv_counter + 1.
            " When the subsequent Media Issues are same
            IF <lst_worklist>-ismrefmdprod IS INITIAL AND <lst_worklist>-matnr IS INITIAL.
              lst_statustab = i_statustab[ lv_counter ].
              MOVE-CORRESPONDING lst_statustab TO <lst_worklist>.
              CLEAR lst_statustab.
            ENDIF.

            " Get the Additional Field values with reference to Report data
            READ TABLE li_litho_001 INTO DATA(lst_litho_001) WITH KEY
                                    media_issue = <lst_worklist>-matnr
                                    pub_date = <lst_worklist>-ismpubldate
                                    plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_litho_001-plant_marc <> lst_litho_001-delivering_plant.
                DELETE gt_outtab INDEX lv_sytabix.
                CLEAR lst_litho_001.
                CONTINUE.
              ENDIF.
              <lst_worklist>-print_method = lst_litho_001-print_method.         " Print Method
              <lst_worklist>-journal_code = lst_litho_001-acronym.              " Acronym
              <lst_worklist>-po_num       = lst_litho_001-printer_po_number.    " Printer PO #
              <lst_worklist>-po_create_dt = lst_litho_001-printer_po_date.      " Printer PO Created Date
              <lst_worklist>-print_vendor = lst_litho_001-printer.              " Printer
              <lst_worklist>-dist_vendor  = lst_litho_001-distributor.          " Distributor
              <lst_worklist>-delv_plant   = lst_litho_001-delivering_plant.     " Delivery Plant
              <lst_worklist>-issue_type   = lst_litho_001-issue_type.           " Issue Type
              <lst_worklist>-sub_actual_py = lst_litho_001-subs_actual.         " Subs (Actual)
              lv_blcy_num = lst_litho_001-back_labels.
              <lst_worklist>-bl_pcurr_yr  = lv_blcy_num.                        " BL (CY)
              SHIFT <lst_worklist>-bl_pcurr_yr LEFT DELETING LEADING '0'.
              <lst_worklist>-ml_cyear     = lst_litho_001-main_labels.          " ML (CY)
              <lst_worklist>-ml_bl_cy     = <lst_worklist>-ml_cyear + <lst_worklist>-bl_pcurr_yr. " ML+BL (CY)
              <lst_worklist>-om_actual    =	lst_litho_001-om_actual.            " OM (Actual)
              <lst_worklist>-ob_actual    =	lst_litho_001-ob_actual.            " OB (Actual)
              <lst_worklist>-c_and_e      = lst_litho_001-c_e.                  " C & E
              <lst_worklist>-author_copies =  lst_litho_001-author.             " Author
              <lst_worklist>-emlo_copies  = lst_litho_001-emlo.                 " EMLO
              <lst_worklist>-marc_ismarrivaldateac = lst_litho_001-actual_goods_arrival.  " Actual Goods Arrival
              <lst_worklist>-initial_soh = lst_litho_001-initial_soh.           " SOH (Initial)
*BOI: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
*BOC: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
*              <lst_worklist>-wbs_element = lst_litho_001-wbs_element.           " WBS Element
              CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
                EXPORTING
                  input         = lst_litho_001-wbs_element_unconv
               IMPORTING
                 OUTPUT        = <lst_worklist>-wbs_element.
*EOC: OTCM-30221(R096) TDIMANTHA 09-MARCH-2021  ED2K922407
*EOI: OTCM-30221(R096) TDIMANTHA 23-FEB-2021  ED2K922117
              " Get the Log values
              READ TABLE li_litho_log INTO DATA(lst_litho_log) WITH KEY
                                      media_issue = <lst_worklist>-matnr
                                      pub_date = <lst_worklist>-ismpubldate
                                      plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
              IF sy-subrc = 0.
                IF lst_litho_log-plant_marc <> lst_litho_001-delivering_plant.
                  DELETE gt_outtab INDEX lv_sytabix.
                  CLEAR lst_litho_log.
                  CONTINUE.
                ENDIF.
                <lst_worklist>-adjustment = lst_litho_log-adjustment.
                IF lst_litho_log-om_actual IS NOT INITIAL.
                 <lst_worklist>-om_actual = lst_litho_log-om_actual.
                ENDIF.
              ENDIF.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
              " Getting BL-Buffer
              READ TABLE li_litho_tm INTO DATA(lst_litho_tm) WITH KEY tm_type = lc_blbf
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
              READ TABLE li_subs_plan INTO DATA(lst_subs_plan) WITH KEY
                                      media_product = <lst_worklist>-ismrefmdprod
                                      pub_year = lv_pyear BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_worklist>-subs_plan = lst_subs_plan-subs_actual.             " Subs (Plan)
                <lst_worklist>-om_plan   = lst_subs_plan-om_actual.               " OM (Plan)
              ENDIF.

              lv_pubdate = <lst_worklist>-ismpubldate(6).
              lv_pubdate(4) = lv_pyear.
              " Get the Media Issue of Previous Year Copy based on Plant
              READ TABLE li_litho_001_py INTO DATA(lst_litho_001_py) WITH KEY
                         media_product = <lst_worklist>-ismrefmdprod
                         pub_date(6) = lv_pubdate
                         issue_no_unconv = lst_litho_001-issue_no_unconv
                         plant_marc = lst_litho_001-plant_marc BINARY SEARCH.
              IF sy-subrc <> 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input         = lst_litho_001-issue_no_unconv
                  IMPORTING
                    OUTPUT        = lst_litho_001-issue_no_unconv.
                  " Get the Media Issue of Previous Year Copy
                  READ TABLE li_litho_001_py INTO lst_litho_001_py WITH KEY
                             media_product = <lst_worklist>-ismrefmdprod
                             pub_date(6) = lv_pubdate
                             issue_no_unconv = lst_litho_001-issue_no_unconv
                             plant_marc = lst_litho_001-plant_marc BINARY SEARCH.
                  IF sy-subrc <> 0.
                    " Nothing to do
                  ENDIF.
              ENDIF.
              IF sy-subrc = 0.
                <lst_worklist>-ml_pyear = lst_litho_001_py-main_labels.           " ML (PY)
                <lst_worklist>-bl_pyear = lst_litho_001_py-back_labels.           " BL (PY)

                <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)

                <lst_worklist>-ob_plan = lst_litho_001_py-ob_actual.              " OB (Plan)
              ELSE.
                DATA(li_litho1_py_tmp) = li_litho_001_py.
                DELETE li_litho1_py_tmp WHERE media_product <> <lst_worklist>-ismrefmdprod AND
                                              pub_date(6) <> lv_pubdate AND
                                              issue_no_unconv <> lst_litho_001-issue_no_unconv.
                LOOP AT li_litho1_py_tmp ASSIGNING FIELD-SYMBOL(<lst_litho1_py_tmp>).
                  IF <lst_litho1_py_tmp>-plant_marc = <lst_litho1_py_tmp>-delivering_plant.
                    <lst_worklist>-ml_pyear = <lst_litho1_py_tmp>-main_labels.           " ML (PY)
                    <lst_worklist>-bl_pyear = <lst_litho1_py_tmp>-back_labels.           " BL (PY)

                    <lst_worklist>-ml_bl_py = <lst_worklist>-ml_pyear + <lst_worklist>-bl_pyear.  " ML+BL (PY)

                    <lst_worklist>-ob_plan = <lst_litho1_py_tmp>-ob_actual.              " OB (Plan)
                  ENDIF.
                ENDLOOP.
                CLEAR: li_litho1_py_tmp[].
              ENDIF.

              " Reprint Qty, Reprint PO No.
              LOOP AT li_litho_002 INTO DATA(lst_litho_0020) WHERE media_issue = <lst_worklist>-matnr.
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

              " New_Subs
              SELECT media_issue, pub_year, plant_marc, SUM( new_subs ) as new_subs, zzvyp
                     FROM zcds_litho_003 INTO TABLE @DATA(li_litho_003)
                     WHERE media_issue = @<lst_worklist>-matnr AND
                           plant_marc = @<lst_worklist>-marc_werks AND
                           zzvyp = @<lst_worklist>-ismyearnr
                     GROUP BY media_issue, pub_year, plant_marc, zzvyp.
              IF sy-subrc = 0.
                READ TABLE li_litho_003 INTO DATA(lst_litho_003) INDEX 1.
                IF sy-subrc = 0.
                  <lst_worklist>-new_subs = lst_litho_003-new_subs.                  " New_Subs
                  CLEAR: lst_litho_0020, li_litho_003[].
                ENDIF.
              ENDIF.

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
              READ TABLE li_litho_004 INTO DATA(lst_litho_004) WITH KEY
                                      media_issue = <lst_worklist>-matnr
                                      plant_marc = <lst_worklist>-marc_werks BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_worklist>-current_soh = lst_litho_004-soh.                    " SOH (Current)
              ENDIF.

              " Assign the Log Icon
              <lst_worklist>-comments = lc_comments.
              DATA(lv_external_num) = |{ <lst_worklist>-matnr }{ <lst_worklist>-marc_werks }|.
              READ TABLE li_balhdr WITH KEY extnumber = lv_external_num
                                   BINARY SEARCH
                                   TRANSPORTING NO FIELDS.
              IF sy-subrc = 0.
                <lst_worklist>-view_comments = lc_vcomments.
              ENDIF.

            ENDIF. " IF sy-subrc = 0. READ TABLE li_litho_001...

*BOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
              " Change Adjustment & OM Actual
              <lst_worklist>-om_actual_txt = <lst_worklist>-om_actual.
              SHIFT <lst_worklist>-om_actual_txt LEFT DELETING LEADING '0'.
              CONDENSE <lst_worklist>-om_actual_txt.
              CONCATENATE lc_comments <lst_worklist>-om_actual_txt INTO <lst_worklist>-om_actual_txt SEPARATED BY space.
              <lst_worklist>-adjustment_txt = <lst_worklist>-adjustment.
              CONDENSE <lst_worklist>-adjustment_txt.
              CONCATENATE lc_comments <lst_worklist>-adjustment_txt INTO <lst_worklist>-adjustment_txt SEPARATED BY space.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
            " Clear the structures
            CLEAR: lst_litho_001_py, lst_litho_001, lst_litho_003,
                   lst_litho_004, lst_subs_plan, lst_litho_tm, lst_litho_log.

          ENDLOOP.

      ENDIF. " IF gv_filt = lc_zd.

      " Set the Field Catalog
      CALL METHOD gv_list->gv_alv_grid->set_frontend_fieldcatalog
        EXPORTING
          it_fieldcatalog = li_fcat.

      " REFRESH ALV DISPLAY
      CALL METHOD ME->REGISTER_REFRESH.
      CALL METHOD GV_list->EXECUTE_REFRESH. "ALV neu aufbauen

    ENDIF. " IF v_aflag_r096 = abap_true.
  ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01' "OTCM-46971 ED2K925437 TDIMANTHA 01/04/2022

* BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
*  IF sy-tcode = 'ZSCM_JKSD13_01_NEW'.
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
  IF sy-tcode = 'ZSCM_JKSD13_01'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
    " Check whether the Enhancement is active ot not
    " Enhancement to update the Additional Column values of MI for Planning
    IF v_aflag_r096 = abap_true.
      INCLUDE zqtcn_additional_fields_r096 IF FOUND.
    ENDIF.  " IF v_aflag_r096_002 = abap_true.
  ENDIF.  " IF sy-tcode = 'ZSCM_JKSD13_01_NEW'.
* EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022

  ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01' OR

ENDENHANCEMENT.
