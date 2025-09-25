*----------------------------------------------------------------------*
***INCLUDE LZCSDSF04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_BOM_OPEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_open .
  DATA : lii_stpo  TYPE STANDARD TABLE OF stpo_api02.  " Local Itab for BOM Items
  WRITE lst_mara-ersda TO lv_date DD/MM/YYYY.
  CLEAR : tstk2,tstp2,flg_warning.
  CALL FUNCTION 'CSAP_MAT_BOM_OPEN'
    EXPORTING
      material   = lst_mastb-matnr
      plant      = lst_mastb-werks
      bom_usage  = lst_mastb-stlan
      valid_from = lv_date "lv_ersda
*     change_no  = 'AE001'
    IMPORTING
      o_stko     = tstk2
      fl_warning = flg_warning
    TABLES
      t_stpo     = tstp2
    EXCEPTIONS
      error      = 1.
  IF sy-subrc NE 0.
    PERFORM f_material_unlock.
* Implement suitable code
  ELSE.
    PERFORM f_material_unlock.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BOM_MODIFY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_modify .
  CALL FUNCTION 'CSAP_BOM_ITEM_MAINTAIN'
    EXPORTING
      i_stpo       = tstp2
    IMPORTING
      fl_warning   = flg_warning
    TABLES
*     t_dep_data   =
*     t_dep_descr  =
*     t_dep_order  =
      t_dep_source = tdep2_source
*     t_dep_doc    =
    EXCEPTIONS
      error        = 1
      OTHERS       = 2.
  IF sy-subrc EQ 0.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BOM_DELETE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_close .
  CALL FUNCTION 'CSAP_MAT_BOM_CLOSE'
    IMPORTING
      fl_warning = flg_warning
    EXCEPTIONS
      error      = 1.
  IF sy-subrc EQ 0.
* Implement suitable code
  ENDIF.
  CLEAR : tstk2,tstp2,flg_warning.
  PERFORM f_material_unlock.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BOM_INSERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_insert .
  IF v_idnrk IS NOT INITIAL.
    CLEAR: v_date,lv_date.
    SELECT SINGLE stlnr FROM mast INTO lst_mastb-stlnr WHERE matnr = lst_mastb-matnr.
    IF sy-subrc EQ 0.
      SELECT SINGLE datuv FROM stpo INTO v_date  WHERE stlnr = lst_mastb-stlnr AND idnrk = v_idnrk.
      IF sy-subrc EQ 0.
        WRITE v_date  TO lv_date DD/MM/YYYY.
      ENDIF.
    ENDIF.

    PERFORM f_material_unlock.
    CALL FUNCTION 'CSAP_MAT_BOM_MAINTAIN'
      EXPORTING
        material          = lst_mastb-matnr
        plant             = lst_mastb-werks
        bom_usage         = lst_mastb-stlan
        valid_from        = lv_date
        fl_recursive      = 'X'
        fl_bom_create     = 'X'
        fl_new_item       = 'X'
        fl_complete       = 'X'
        fl_default_values = 'X'
        i_stko            = tstk1
      IMPORTING
        fl_warning        = flg_warning
        o_stko            = tstk2
      TABLES
        t_stpo            = gt_tstp3
      EXCEPTIONS
        OTHERS            = 1.
    COMMIT WORK AND WAIT.
  ELSE.
    PERFORM f_material_unlock.
    CALL FUNCTION 'CSAP_MAT_BOM_MAINTAIN'
      EXPORTING
        material          = lst_mastb-matnr
        plant             = lst_mastb-werks
        bom_usage         = lst_mastb-stlan
        fl_recursive      = 'X'
        fl_bom_create     = 'X'
        fl_new_item       = 'X'
        fl_complete       = 'X'
        fl_default_values = 'X'
        i_stko            = tstk1
      IMPORTING
        fl_warning        = flg_warning
        o_stko            = tstk2
      TABLES
        t_stpo            = gt_tstp3
      EXCEPTIONS
        OTHERS            = 1.
    COMMIT WORK AND WAIT.
  ENDIF.
  lst_idoc_stat-msgno = '031'.            "BOM changen
  lst_idoc_stat-status = c_idoc_stat_is_posted.
  lst_idoc_stat-docnum = gs_edidc-docnum.
  lst_idoc_stat-msgty = c_succ.
  lst_idoc_stat-msgid = c_mcbom.
  lst_idoc_stat-msgv1 = api_mbom-matnr.
  l_str_message-type  = c_succ.
  l_str_message-id   = c_mcbom.
  l_str_message-number     = '031'.
  l_str_message-message_v1 = api_mbom-matnr.
  APPEND l_str_message TO l_tab_messages.
  CLEAR: l_str_message,idoc_err_nr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BOM_LOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_lock .
*IF stzub-vbkz = c_bom_change.    "request from direct distribution
*       select internal bom number for locking the bom group   "n598927
*        SELECT stlnr FROM mast INTO ls_ccin-stlnr UP TO 1 ROWS "n598927
*          WHERE matnr = mastb-matnr                        "note 646261
*            AND werks = mastb-werks                        "note 646261
*            AND stlan = mastb-stlan.                       "note 646261
*        ENDSELECT.
*  READ TABLE mastb INTO DATA(lst_mastb_tmp11) INDEX 1.
  SELECT stlnr FROM mast INTO ls_ccin-stlnr UP TO 1 ROWS    "n598927
  WHERE matnr = mastb-matnr                        "note 646261
    AND werks = mastb-werks                        "note 646261
    AND stlan = mastb-stlan.                       "note 646261
  ENDSELECT.
  IF sy-subrc = 0 AND NOT ls_ccin-stlnr IS INITIAL.         "note598927
*       lock the bom group before exploding the bom
*        -> prevent bom changes during bom explosion and calling the
*           API change otherwise the comparison between old (existing)
*           and new (received) bom data could be inconsistent.
    CALL FUNCTION 'ENQUEUE_ECSTZUE'                   "note598927
      EXPORTING                                        "note598927
        stlty          = 'M'                     "note598927
        stlnr          = ls_ccin-stlnr           "note598927
        _wait          = 'X'       "try again if lock conflict
      EXCEPTIONS                                       "note598927
        foreign_lock   = 1                       "note598927
        system_failure = 2                       "note598927
        OTHERS         = 3.                      "note598927

    CASE sy-subrc.                                          "note598927
      WHEN 1.                                               "note598927
        flg_lock_err = 'X'.                                 "note598927
        akt_uname = sy-msgv1.                               "note598927
*             BOM & is locked by &                          "note598927
        PERFORM appl_log_write_single_message               "note598927
                USING 'E' '29'                              "note598927
                      '161'                                 "note598927
                      ls_ccin-stlnr                         "note598927
                      akt_uname                             "note598927
                      ' ' ' '.                              "note598927
      WHEN 2 OR 3.                                          "note598927
        flg_lock_err = 'X'.                                 "note598927
*             System error while locking                    "note598927
        PERFORM appl_log_write_single_message               "note598927
                USING 'E' '29'                              "note598927
                      '169'                                 "note598927
                      ' ' ' ' ' ' ' '.                      "note598927
    ENDCASE.                                                "note598927
  ENDIF.                                                    "note598927

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BOM_UNLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bom_unlock .
  READ TABLE mastb INTO DATA(lst_mastb_tmp11) INDEX 1.
  CALL FUNCTION 'DEQUEUE_ECSTZUE'
*    EXPORTING
*      stlty = 'M'                     "note598927
*      stlnr = lst_mastb_tmp11-stlnr           "note598927
*      _wait = 'X'       "try again if lock conflict
**     X_STLTY         = ' '
**     X_STLNR         = ' '
**     _SCOPE          = '3'
**     _SYNCHRON       = ' '
**     _COLLECT        = ' '
    .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CLFM_FROM_SEGMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IDOC_DATA  text
*      -->P_IDOC_DATA_SEGNUM  text
*      -->P_1232   text
*      -->P_1233   text
*      -->P_1234   text
*      -->P_1235   text
*----------------------------------------------------------------------*
*FORM get_clfm_from_segments  TABLES   p_idoc_data STRUCTURE idoc_data
*                             USING    p_idoc_data_segnum
*                                      VALUE(p_1232)
*                                      VALUE(p_1233)
*                                      VALUE(p_1234)
*                                      VALUE(p_1235).
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PBOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_plant_data.
  DATA: li_headdata     TYPE STANDARD TABLE OF bapie1matheader INITIAL SIZE 0, " Header Segment with Control Information
        li_clientdata   TYPE STANDARD TABLE OF bapie1mara INITIAL SIZE 0,      " Material Data at Client Level
        li_clientdatax  TYPE STANDARD TABLE OF bapie1marax INITIAL SIZE 0,     " Checkbox Structure for BAPIE1MARA
        ls_clientdata   TYPE bapie1mara,      " Material Data at Client Level
        ls_clientdatax  TYPE bapie1marax,     " Checkbox Structure for BAPIE1MARA
        li_salesdata    TYPE STANDARD TABLE OF bapie1mvke INITIAL SIZE 0,      " Sales Data
        li_salesdatax   TYPE STANDARD TABLE OF bapie1mvkex INITIAL SIZE 0,     " Checkbox Structure for BAPIE1MVKE
        li_retdata      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,        " Return Parameter
        li_bapie1parex  TYPE STANDARD TABLE OF bapie1parex INITIAL SIZE 0,
        li_bapie1parexx TYPE STANDARD TABLE OF bapie1parexx INITIAL SIZE 0,
        li_bapie1marc   TYPE STANDARD TABLE OF bapie1marc INITIAL SIZE 0,
        li_bapie1marcx  TYPE STANDARD TABLE OF bapie1marcx INITIAL SIZE 0,
        lt_extension    LIKE bapie1parex OCCURS 0 WITH HEADER LINE,
        lt_extensionx   LIKE bapie1parexx OCCURS 0 WITH HEADER LINE,
        ls_ext_mara     TYPE bapi_te_mara,
        ls_ext_marax    TYPE bapi_te_marax,
        li_bapie1makt   TYPE STANDARD TABLE OF bapie1makt INITIAL SIZE 0.

  DATA : lst_headdata    TYPE  bapie1matheader, " Header Segment with Control Information
         lst_clientdata  TYPE  bapie1mara ,     " Material Data at Client Level
         lst_clientdatax TYPE  bapie1marax ,    " Checkbox Structure for BAPIE1MARA
         lst_salesdata   TYPE  bapie1mvke,      " Sales Data
         lst_salesdatax  TYPE  bapie1mvkex ,    " Checkbox Structure for BAPIE1MVKE
         lst_bapiret2    TYPE bapiret2,         " Return Parameter
         lst_bapie1marc  TYPE bapie1marc,
         lst_bapie1makt  TYPE bapie1makt,
*         lst_bapie1maktx TYPE bapie1maktx.
         lii_bapie1marcx TYPE bapie1marcx.
  DATA : li_bapie1mlan TYPE TABLE OF bapie1mlan,
         ls_bapie1mlan TYPE bapie1mlan.
  CLEAR : li_salesdatax[],li_salesdata[],li_bapie1mlan[],li_clientdata[], li_clientdatax[],
           li_headdata[].
  lst_headdata-material          = gs_header_data-matnr.
  lst_headdata-ind_sector        = gs_header_data-mbrsh.
  lst_headdata-matl_type         = gs_header_data-mtart.
  lst_headdata-basic_view  = abap_true.
  lst_headdata-sales_view  = abap_true.
  APPEND lst_headdata TO li_headdata.
  LOOP AT gt_org_data INTO gs_org_data.
    lst_salesdata-material    = gs_header_data-matnr.
    lst_salesdata-delyg_plnt  = gs_org_data-dwerk.
    lst_salesdata-sales_org   = gs_org_data-vkorg.
    lst_salesdata-distr_chan  = gs_org_data-vtweg.
    lst_salesdata-item_cat   = gs_org_data-mtpos.
    lst_salesdata-matl_grp_5  = gs_org_data-mvgr5.
    lst_salesdata-prod_att_1  = gs_org_data-prat1.
    APPEND lst_salesdata TO li_salesdata.
    CLEAR: lst_salesdata.
    lst_salesdatax-material    = gs_header_data-matnr.
    lst_salesdatax-sales_org   = gs_org_data-vkorg.
    lst_salesdatax-distr_chan  = gs_org_data-vtweg.
    lst_salesdatax-delyg_plnt  = abap_true.
    lst_salesdatax-item_cat   = abap_true.
    lst_salesdatax-matl_grp_5  = abap_true.
    lst_salesdatax-prod_att_1  = abap_true.
    APPEND lst_salesdatax TO li_salesdatax.
    CLEAR: lst_salesdatax.
  ENDLOOP.


  LOOP AT gt_tax_classification INTO gs_tax_classification.
    ls_bapie1mlan-material  = gs_header_data-matnr.
    ls_bapie1mlan-depcountry  = gs_tax_classification-aland.
    ls_bapie1mlan-tax_type_1  = gs_tax_classification-taty1.
    ls_bapie1mlan-taxclass_1  = gs_tax_classification-taxm1.
    APPEND ls_bapie1mlan TO li_bapie1mlan.
    CLEAR : ls_bapie1mlan,gs_tax_classification.
  ENDLOOP.
  PERFORM f_material_unlock.
  CALL FUNCTION 'BAPI_MATERIAL_SAVEREPLICA'
    EXPORTING
      noappllog          = abap_true
      nochangedoc        = space
      testrun            = space
      inpfldcheck        = space
    IMPORTING
      return             = lst_bapiret2
    TABLES
      headdata           = li_headdata
      clientdata         = li_clientdata
      clientdatax        = li_clientdatax
      salesdata          = li_salesdata
      salesdatax         = li_salesdatax
      taxclassifications = li_bapie1mlan
      returnmessages     = li_retdata.
  READ TABLE li_retdata INTO DATA(lst_retdata_save1) WITH KEY type = c_s.
  IF sy-subrc EQ 0.
    CLEAR :lv_flag_error,lv_flag_success.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
    COMMIT WORK AND WAIT.
    lv_flag_success = abap_true.
    PERFORM f_log_update USING lst_retdata_save1.
    PERFORM f_update_idcode.
  ELSE.
    READ TABLE li_retdata INTO DATA(lst_retdata_save) WITH KEY type = c_e.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    PERFORM f_unlock_all.
    lv_flag_error = abap_true.
    PERFORM f_log_update USING lst_retdata_save.
    idoc_err_nr = 7.
    lst_idoc_status-err_nr = 7.
    lst_idoc_status-msgid = lst_retdata_save-id.
    lst_idoc_status-msgno = lst_retdata_save-number.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CHANGE_PRODUCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_change_product .
  CLEAR :lst_header,lst_clientdata,lst_clientdatax,lst_plantdata,
         lst_plantdatax,li_mat_unit[],li_mat_unitx[],li_taxclas[],
         li_mat_des[],lt_extension[],lt_extensionx[],lst_saledata,
         lst_saledatax,lst_return,li_mat_text[],li_return[],lv_flag_error,
         lv_flag_success.
* Header Data
  lst_header-material          = gs_header_data-matnr.
  lst_header-ind_sector        = gs_header_data-mbrsh.
  lst_header-matl_type         = gs_header_data-mtart.
  lst_header-basic_view        = abap_true.
  lst_header-sales_view        = abap_true.
  lst_header-purchase_view     = abap_true.
  lst_header-mrp_view          = abap_true.
  lst_header-forecast_view     = abap_true.
  lst_header-work_sched_view   = abap_true.
  lst_header-prt_view          = abap_true.
  lst_header-storage_view      = abap_true.
  lst_header-warehouse_view    = abap_true.
  lst_header-quality_view      = abap_true.
  lst_header-account_view      = abap_true.
  lst_header-cost_view         = abap_true.
* Client Data
  lst_clientdata-base_uom      = gs_header_data-meins.
  lst_clientdatax-base_uom     = abap_true.
  lst_clientdata-base_uom_iso  = gs_header_data-meins.
  lst_clientdatax-base_uom_iso = abap_true.
  lst_clientdata-net_weight    = gs_header_data-ntgew.
  lst_clientdatax-net_weight   = abap_true.
  lst_clientdata-unit_of_wt    = c_kg.
  lst_clientdatax-unit_of_wt   = abap_true.
  lst_clientdata-division      = gs_header_data-spart.
  lst_clientdatax-division     = abap_true.
  lst_clientdata-pur_status    = gs_header_data-mstae.
  lst_clientdatax-pur_status   = abap_true.
  lst_clientdata-sal_status    = gs_header_data-mstav.
  lst_clientdatax-sal_status   = abap_true.
  lst_clientdata-svalidfrom    = gs_header_data-mstdv.
  lst_clientdatax-svalidfrom   = abap_true.
  lst_clientdata-matl_group    = gs_header_data-matkl.
  lst_clientdatax-matl_group   = abap_true.
  lst_clientdata-extmatlgrp    = gs_header_data-extwg.
  lst_clientdatax-extmatlgrp   = abap_true.
* Plant Dta
  lst_plantdata-plant          = gs_header_data-werks.
  lst_plantdata-profit_ctr     = gs_header_data-prctr.
  lst_plantdatax-plant         = gs_header_data-werks.
  lst_plantdatax-profit_ctr    = abap_true.
* Units of Measure to Populate Gross Weight
  ls_mat_unit-alt_unit = gs_header_data-meins.
  ls_mat_unit-gross_wt = gs_header_data-brgew.
  ls_mat_unit-unit_of_wt  = c_kg.
  APPEND ls_mat_unit TO li_mat_unit.
* Checkbox Structure for BAPI_MARM to populate Gross Weight
  CLEAR ls_mat_unit.
  ls_mat_unitx-alt_unit = gs_header_data-meins.
  ls_mat_unitx-gross_wt = abap_true.
  ls_mat_unitx-unit_of_wt = abap_true.
  APPEND ls_mat_unitx TO li_mat_unitx.
  CLEAR ls_mat_unitx.
*- To Populate Header text
  LOOP AT gt_header_text INTO gs_header_text.
    lst_mat_des-langu          = gs_header_text-spras.
    lst_mat_des-matl_desc      = gs_header_text-maktx.
    APPEND lst_mat_des TO li_mat_des.
    CLEAR : lst_mat_des,gs_header_text.
  ENDLOOP.
*- To Populate Basix data text
  LOOP AT gt_basic_text INTO gs_basic_text.
    ls_mat_text-applobject     = gs_basic_text-tdobject.
    ls_mat_text-text_name      = gs_header_data-matnr.
    ls_mat_text-text_id        = gs_basic_text-tdid.
    ls_mat_text-langu          = gs_basic_text-tdspras.
    ls_mat_text-text_line      = gs_basic_text-tdline.
    APPEND ls_mat_text TO  li_mat_text.
    CLEAR :gs_basic_text, ls_mat_text.
  ENDLOOP.
*- To Populate tax classification data
  LOOP AT gt_tax_classification INTO gs_tax_classification.
    ls_taxclas-depcountry  = gs_tax_classification-aland.
    ls_taxclas-tax_type_1  = gs_tax_classification-taty1.
    ls_taxclas-taxclass_1  = gs_tax_classification-taxm1.
    APPEND ls_taxclas TO li_taxclas.
    CLEAR : ls_taxclas,gs_tax_classification.
  ENDLOOP.
* Extension Field MARA-ZZ1_GENRE_PRD (same name as DB field)
  ls_ext_mara-material         = gs_header_data-matnr.
  ls_ext_mara-ismhierarchlevl  = gs_header_data-ismhierarchlevl.
  ls_ext_mara-ismtitle         = gs_header_data-ismtitle.
  ls_ext_mara-ismpubltype      = gs_header_data-ismpubltype.
  ls_ext_mara-ismmediatype     = gs_header_data-ismmediatype.
  ls_ext_mara-ismconttype      = gs_header_data-ismconttype.
  ls_ext_mara-ismperrule       = gs_header_data-ismperrule.

  ls_ext_marax-material        = gs_header_data-matnr.
  ls_ext_marax-ismhierarchlevl = abap_true.
  ls_ext_marax-ismtitle        = abap_true.
  ls_ext_marax-ismpubltype     = abap_true.
  ls_ext_marax-ismmediatype    = abap_true.
  ls_ext_marax-ismconttype     = abap_true.
  ls_ext_marax-ismperrule      = abap_true.

  lt_extension-structure       = 'BAPI_TE_MARA'.
  CONDENSE lt_extension-structure.
  CONCATENATE ls_ext_mara-material ls_ext_mara-ismhierarchlevl
              ls_ext_mara-ismtitle ls_ext_mara-ismpubltype
              ls_ext_mara-ismmediatype ls_ext_mara-ismconttype
              ls_ext_mara-ismperrule  INTO lt_extension-valuepart1 RESPECTING BLANKS.
  APPEND lt_extension.

  lt_extensionx-structure    = 'BAPI_TE_MARAX'.
  CONDENSE lt_extensionx-structure.
  CONCATENATE ls_ext_marax-material ls_ext_marax-ismhierarchlevl
              ls_ext_marax-ismtitle ls_ext_marax-ismpubltype
              ls_ext_marax-ismmediatype ls_ext_marax-ismconttype
              ls_ext_marax-ismperrule  INTO  lt_extensionx-valuepart1 RESPECTING BLANKS.
  APPEND lt_extensionx.

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata            = lst_header
      clientdata          = lst_clientdata
      clientdatax         = lst_clientdatax
      plantdata           = lst_plantdata
      plantdatax          = lst_plantdatax
      salesdata           = lst_saledata
      salesdatax          = lst_saledatax
    IMPORTING
      return              = lst_return
    TABLES
      materialdescription = li_mat_des
      unitsofmeasure      = li_mat_unit
      unitsofmeasurex     = li_mat_unitx
      materiallongtext    = li_mat_text
      taxclassifications  = li_taxclas
      extensionin         = lt_extension
      extensioninx        = lt_extensionx
      returnmessages      = li_return.

  READ TABLE li_return INTO DATA(lst_return1) WITH KEY type = c_s.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    PERFORM f_material_unlock.
    PERFORM f_unlock_all.
    lv_flag_success = abap_true.
    PERFORM f_log_update USING lst_return1.
    PERFORM f_update_plant_data.
  ELSE.
    READ TABLE li_return INTO DATA(lst_retrun) WITH KEY type = c_e.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    PERFORM f_material_unlock.
    PERFORM f_unlock_all.
    lv_flag_error = abap_true.
    PERFORM f_log_update USING lst_retrun.
    idoc_err_nr = 6.
    lst_idoc_status-err_nr = 6..
    lst_idoc_status-msgid = lst_retrun-id.
    lst_idoc_status-msgno = lst_retrun-number.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CLASSIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_classification .
  CLEAR  : i_allocvalueschar[].
* Classification header data
  READ TABLE gt_class_data INTO  gs_class_data INDEX 1.
  i_objectkey = gs_header_data-matnr.
  i_objecttab = gs_class_data-obtab.
  i_classnum  = gs_class_data-class.
  i_classtype  = gs_class_data-klart.
  i_keydate   = sy-datum.
* Classfication Item Data
  LOOP AT gt_class_data INTO gs_class_data FROM 2.
    st_allocvalueschar-charact    = gs_class_data-atnam.
    st_allocvalueschar-value_char = gs_class_data-atwrt.
    APPEND st_allocvalueschar TO i_allocvalueschar.
    CLEAR: st_allocvalueschar, gs_class_data.
  ENDLOOP.
  PERFORM f_material_unlock.
* Classification BAPI: Change Assignment
  CALL FUNCTION 'BAPI_OBJCL_CHANGE'
    EXPORTING
      objectkey          = i_objectkey
      objecttable        = i_objecttab
      classnum           = i_classnum
      classtype          = i_classtype
    TABLES
      allocvaluesnumnew  = i_allocvaluesnumnew
      allocvaluescharnew = i_allocvalueschar
      allocvaluescurrnew = i_allocvaluescurrnew
      return             = i_return.
  CLEAR :lv_flag_error,lv_flag_success.
  READ TABLE li_return INTO DATA(lst_return1_clas) WITH KEY type = c_s.
  IF sy-subrc EQ 0.
    PERFORM f_batch_log_update USING lst_return1_clas.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
    lv_flag_success = abap_true.
  ELSE.
    READ TABLE i_return INTO DATA(lst_retrun_clas) WITH KEY type = c_e.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    PERFORM f_batch_log_update USING lst_retrun_clas.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
    lv_flag_error = abap_true.
    idoc_err_nr = 11.
    lst_idoc_status-err_nr = 11.
    lst_idoc_status-msgid = lst_retrun_clas-id.
    lst_idoc_status-msgno = lst_retrun_clas-number.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_IDCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_idcode.
  CLEAR :gt_idcode[].
* To Populate ID Code Assignment for Product
  LOOP AT gt_ism_data INTO gs_ism_data.
    gs_idcode-client      = sy-mandt.
    gs_idcode-matnr       = gs_header_data-matnr.
    gs_idcode-idcodetype  = gs_ism_data-idcodetype.
    gs_idcode-identcode   = gs_ism_data-identcode.
    gs_idcode-xmainidcode = gs_ism_data-xmainidcode.
    gs_idcode-tranc       = gs_idcode-tranc + 1.
    APPEND gs_idcode TO gt_idcode.
  ENDLOOP.
  PERFORM f_material_unlock.
  CALL FUNCTION 'ISM_PMD_IDCODES_MAINTAIN_DARK'
    EXPORTING
      pvi_xtest       = kz_test                "TK18112009
      pvi_xcommit     = c_x
    IMPORTING
      pte_amerrdat    = lt_merrdat
    CHANGING
      ptc_idcdassign  = gt_idcode
    EXCEPTIONS
      internal_error  = 1
      too_many_errors = 2
      update_error    = 3.
  IF sy-subrc NE 0.
    idoc_err_nr = 8.
    READ TABLE lt_merrdat INTO DATA(lst_merrdat) WITH KEY msgty = c_e.
    PERFORM f_log_mat_update USING lst_merrdat.
    lst_idoc_status-err_nr = 8.
    lst_idoc_status-msgid = lst_merrdat-msgid.
    lst_idoc_status-msgno = lst_merrdat-msgno.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
    PERFORM f_material_unlock.
  ELSE.
    PERFORM f_material_unlock.
  ENDIF.
  CLEAR: gt_jptmara[],lt_merrdat[].
*- To Populate for IS-M: Search Strategy for Next Issue and IS-M: Series Characteristic
  gs_jptmara-mandt        = sy-mandt.
  gs_jptmara-matnr        = gs_header_data-matnr.
  gs_jptmara-ismsstratni  = gs_header_data-ismsstratni.
  gs_jptmara-ismniptype   = gs_header_data-ismniptype.
  gs_jptmara-tranc        = gs_jptmara-tranc + 1.
  APPEND gs_jptmara TO gt_jptmara.
  PERFORM f_material_unlock.
  CALL FUNCTION 'ISM_PMD_JPTMARA_MAINTAIN_DARK'
    EXPORTING
      pvi_xcommit     = c_x
      pvi_xtest       = kz_test
    IMPORTING
      pte_amerrdat    = lt_merrdat
    CHANGING
      ptc_jptmara     = gt_jptmara
    EXCEPTIONS
      internal_error  = 1
      too_many_errors = 2
      update_error    = 3.
  IF sy-subrc NE 0.
    idoc_err_nr = 9.
    READ TABLE lt_merrdat INTO DATA(lst_merrdat1) WITH KEY msgty = c_e.
    PERFORM f_log_mat_update USING lst_merrdat1.
    lst_idoc_status-err_nr = 9.
    lst_idoc_status-msgid = lst_merrdat1-msgid.
    lst_idoc_status-msgno = lst_merrdat1-msgno.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
    PERFORM f_material_unlock.
  ELSE.
    PERFORM f_material_unlock.
  ENDIF.
  PERFORM f_unlock_all.
  PERFORM f_material_unlock.
*  PERFORM f_update_net_weight.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_NET_WEIGHT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_net_weight .
*  REFRESH: t_bdcdata.
*  CLEAR fs_bdcdata.
*  PERFORM populate_bdcdata.
*  PERFORM insert_data.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  POPULATE_BDCDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM populate_bdcdata .
  TABLES : msichtausw.
  PERFORM : f_fill_bdc_data USING 'SAPLMGMM'  '0060' 'X' '' '',
            f_fill_bdc_data USING ''  '' ''  'RMMG1-MATNR'  gs_header_data-matnr,
            f_fill_bdc_data USING ''  '' ''  'BDC_OKCODE' '=ENTR',
            f_fill_bdc_data USING 'SAPLMGMM' '0070' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '=SELA',
            f_fill_bdc_data USING 'SAPLMGMM' '0070' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '=ENTR',
            f_fill_bdc_data USING 'SAPLMGMM' '0080' 'X'  '' '',
            f_fill_bdc_data USING ''  '' ''  'BDC_CURSOR'  gs_header_data-werks,
            f_fill_bdc_data USING ''  '' ''  'BDC_OKCODE' '=ENTR',
            f_fill_bdc_data USING 'SAPLMGMM' '4000' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '=ZU01',
            f_fill_bdc_data USING ''  ''  '' 'BDC_SUBSCR' 'SAPLJPMM',
            f_fill_bdc_data USING 'SAPLMGMM' '4300' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '=ZU02',
            f_fill_bdc_data USING 'SAPLMGMM' '4300' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '/00',
            f_fill_bdc_data USING ''  ''  '' 'BDC_CURSOR' 'SMEINH-NTGEW(01)',
            f_fill_bdc_data USING ''  ''  '' 'SMEINH-NTGEW(01)' gs_header_data-ntgew,
            f_fill_bdc_data USING 'SAPLMGMM' '4300' 'X'  '' '',
            f_fill_bdc_data USING ''  ''  '' 'BDC_OKCODE' '=BU'.

ENDFORM.
FORM f_fill_bdc_data USING VALUE(p_program)
                      VALUE(p_dynpro)
                      VALUE(p_dynbegin)
                      VALUE(p_fnam)
                      VALUE(p_fval).
  CLEAR fs_bdcdata .
  IF p_dynbegin = 'X' .
    fs_bdcdata-program = p_program .
    fs_bdcdata-dynpro  = p_dynpro .
    fs_bdcdata-dynbegin = p_dynbegin .
    APPEND fs_bdcdata TO t_bdcdata.
  ELSE.
    fs_bdcdata-fnam = p_fnam.
    fs_bdcdata-fval = p_fval.
    CONDENSE fs_bdcdata-fval.
    APPEND fs_bdcdata TO t_bdcdata.
  ENDIF.                               " IF p_dynbeg..

ENDFORM .                              " Fill_entry
*&---------------------------------------------------------------------*
*&      Form  INSERT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM insert_data .
  DATA:
    t_msg      TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
    w_msg      TYPE bdcmsgcoll,
    w_msg1(51),
    w_mode     TYPE c.
  w_mode = 'N'.
  PERFORM f_material_unlock.
* Call transaction 'JP25'
  CALL TRANSACTION 'JP25' USING t_bdcdata
    MODE w_mode
    UPDATE 'S'
    MESSAGES INTO t_msg.
  IF sy-subrc NE 0.
    READ TABLE t_msg INTO DATA(lst_msg) WITH KEY msgtyp = c_e.
    IF sy-subrc EQ 0.
      PERFORM f_bdc_log_update USING lst_msg.
    ENDIF.
    idoc_err_nr = 10.
    lst_idoc_status-err_nr = 10.
    lst_idoc_status-msgid = lst_msg-msgid.
    lst_idoc_status-msgno = lst_msg-msgnr.
    lst_idoc_status-msgv1 = gv_matnr_err.
    APPEND lst_idoc_status TO lt_idoc_status.
    CLEAR lst_idoc_status.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
  ELSE.
    READ TABLE t_msg INTO DATA(lst_msg1) WITH KEY msgtyp = c_s.
    PERFORM f_bdc_log_update USING lst_msg1.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
  ENDIF.
  CLEAR t_msg[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_BOM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_modify_bom_data .
  CLEAR stzub-vbkz.
  DATA(lt_bom_new_data) = gt_idoc_data[].
  DATA(lt_bom_old_data) = li_stpo[].
  SORT lt_bom_new_data BY idnrk.
  DELETE ADJACENT DUPLICATES FROM lt_bom_new_data COMPARING idnrk.
  DATA(lt_bom_new_data_t) = lt_bom_old_data[].
  SORT lt_bom_new_data_t BY item_no DESCENDING.
  READ TABLE lt_bom_new_data_t INTO DATA(lst_bom_item) INDEX 1.
  DATA : lv_posnr TYPE sposn.
  SORT lt_bom_new_data BY posnr idnrk.
  SORT lt_bom_old_data BY item_no component.
  LOOP AT lt_bom_new_data INTO DATA(wa_bom_new_data).
    READ TABLE lt_bom_old_data INTO DATA(wa_bom_old_data) WITH KEY component =  wa_bom_new_data-idnrk.
    IF sy-subrc EQ 0.
      IF wa_bom_new_data-idnrk = wa_bom_old_data-component.
        wa_bom_original_tmp-idnrk = wa_bom_new_data-idnrk.
        wa_bom_original_tmp-posnr = wa_bom_old_data-item_no.
        wa_bom_original_tmp-ind = c_u.
        APPEND wa_bom_original_tmp TO lt_bom_original_tmp.
        CLEAR wa_bom_original_tmp.
      ELSE.
        wa_bom_original_tmp-idnrk = wa_bom_new_data-idnrk.
        IF lv_posnr IS INITIAL.
          lv_posnr = lst_bom_item-item_no + 10.
          CONDENSE lv_posnr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_posnr
            IMPORTING
              output = lv_posnr.
        ELSE.
          lv_posnr =   lv_posnr + 10.
          CONDENSE lv_posnr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_posnr
            IMPORTING
              output = lv_posnr.
        ENDIF.
        wa_bom_original_tmp-posnr = lv_posnr.
        wa_bom_original_tmp-ind = c_i.
        APPEND wa_bom_original_tmp TO lt_bom_original_tmp.
        CLEAR wa_bom_original_tmp.
      ENDIF.
    ELSE.
      wa_bom_original_tmp-idnrk = wa_bom_new_data-idnrk.
      IF lv_posnr IS INITIAL.
        lv_posnr = lst_bom_item-item_no + 10.
        CONDENSE lv_posnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posnr
          IMPORTING
            output = lv_posnr.
      ELSE.
        lv_posnr =   lv_posnr + 10.
        CONDENSE lv_posnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posnr
          IMPORTING
            output = lv_posnr.
      ENDIF.
      wa_bom_original_tmp-posnr = lv_posnr.
      wa_bom_original_tmp-ind = c_i.
      APPEND wa_bom_original_tmp TO lt_bom_original_tmp.
      CLEAR wa_bom_original_tmp.
    ENDIF.
    CLEAR : wa_bom_old_data,wa_bom_original_tmp,wa_bom_new_data.
  ENDLOOP.
  CLEAR : lv_posnr.
  DELETE ADJACENT DUPLICATES FROM lt_bom_original_tmp COMPARING ALL FIELDS.
  LOOP AT lt_bom_old_data INTO DATA(wa_bom_old_data_tmp).
    READ TABLE lt_bom_new_data INTO DATA(wa_bom_new_data_tmp) WITH KEY  idnrk = wa_bom_old_data_tmp-component.
    IF sy-subrc EQ 0.
      CONTINUE.
      CLEAR: wa_bom_old_data_tmp,wa_bom_new_data_tmp.
    ELSE.
      READ TABLE lt_bom_original_tmp INTO wa_bom_original_tmp WITH KEY idnrk = wa_bom_old_data_tmp-component.
      IF sy-subrc NE 0.
        wa_bom_original_tmp-idnrk  = wa_bom_old_data_tmp-component.
        wa_bom_original_tmp-posnr  = wa_bom_old_data_tmp-item_no.
        wa_bom_original_tmp-ind = c_d.
        APPEND wa_bom_original_tmp TO lt_bom_original_tmp.
        CLEAR: wa_bom_original_tmp,wa_bom_old_data_tmp.
      ENDIF.
    ENDIF.
    CLEAR : wa_bom_old_data_tmp,wa_bom_new_data_tmp,wa_bom_original_tmp.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BOM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_bom_data .
  WRITE lst_mara-ersda TO lv_date DD/MM/YYYY.
  CALL FUNCTION 'CSAP_MAT_BOM_READ'
    EXPORTING
      material  = lst_mastb-matnr
      plant     = lst_mastb-werks
      bom_usage = lst_mastb-stlan
    TABLES
      t_stpo    = li_stpo
    EXCEPTIONS
      error     = 1
      OTHERS    = 2.
  IF sy-subrc EQ 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_BOM_CREATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_bom_create_data .
*----------------------------------------------------------------------*
*   save internal tables in database via (external-)APIs
*   -> initialize APIs
  CLEAR: api_warning, api_stko1, api_stko2, api_mbom,
           api_stpo1, api_stpo2, api_stpo3,
           bom_error.
  REFRESH: api_stpo1, api_stpo2, api_stpo3.
  api_logno =  gs_edidc-docnum.
*   set ALE flag for APIs
  flg_ale = c_true.
  EXPORT flg_ale TO MEMORY ID 'CS_ALE'.
  flg_no_commit_work  = c_true.
  EXPORT flg_no_commit_work TO MEMORY ID 'CS_CSAP'.
  READ TABLE stzub INDEX 1.  "(otherwise a loop is necessary)

*   Don't loop, because no COMMIT in APIs !
*   LOOP AT MASTB.   "each entry will create a new bom alternative ?
  DESCRIBE TABLE mastb LINES nr_entries.
  IF nr_entries <> 1.
    idoc_err_nr = 3.
  ELSE.
    READ TABLE mastb INDEX 1.
*     set API tables
    PERFORM itabs_to_api USING mastb-stlal.
*     set material bom key data
    WRITE mastb-matnr TO api_mbom-matnr.
    WRITE mastb-werks TO api_mbom-werks.
    WRITE mastb-stlan TO api_mbom-stlan.
    WRITE mastb-stlal TO api_mbom-stlal.
    stpoi-datuv = sy-datum.  "SGUDA
    stkob-datuv = sy-datum.  "SGUDA
    IF stkob-vbkz <> c_vbkz_sync.
      IF stkob-datuv IS INITIAL.
        CLEAR api_mbom-datuv.
      ELSE.
        WRITE stkob-datuv TO api_mbom-datuv DD/MM/YYYY.
      ENDIF.
    ELSE.

      IF stpoi-datuv IS INITIAL.
        CLEAR api_mbom-datuv.
* Begin of note 902448
        IF NOT stkob-datuv IS INITIAL.
          WRITE stkob-datuv TO api_mbom-datuv DD/MM/YYYY.
        ENDIF.
* End of note 902448

      ELSE.
        WRITE stpoi-datuv TO api_mbom-datuv DD/MM/YYYY.
      ENDIF.
    ENDIF.
    PERFORM check_valfl USING 'M'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_BOM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_bom_data .
  LOOP AT lt_bom_original_tmp INTO wa_bom_original_tmp.
    CLEAR: tdep2_data,
           tdep2_source,
           tdep2_descr,
           tdep2_order,
           tdep2_doc,
           v_idnrk.
    REFRESH: tdep2_data,
             tdep2_source,
             tdep2_descr,
             tdep2_order,
             tdep2_doc.
    CASE wa_bom_original_tmp-ind.
      WHEN c_d.
        CLEAR v_idnrk.
        ls_tstp3-id_item_no = wa_bom_original_tmp-posnr.                    "Item identification.
        ls_tstp3-id_comp  = wa_bom_original_tmp-idnrk.
        ls_tstp3-fldelete = c_x.
        v_idnrk = wa_bom_original_tmp-idnrk.
        APPEND ls_tstp3  TO gt_tstp3.
        PERFORM f_bom_insert.
        PERFORM f_material_unlock.
        PERFORM f_unlock_all.
        CLEAR : ls_tstp3, gt_tstp3[].
      WHEN c_i.
        ls_tstp3-item_no = wa_bom_original_tmp-posnr.
        ls_tstp3-component  = wa_bom_original_tmp-idnrk.
        ls_tstp3-item_categ = c_n.
        ls_tstp3-comp_qty   = c_1.
        ls_tstp3-comp_unit  = gs_header_data-meins.
        ls_tstp3-rel_sales  = c_x.
        WRITE sy-datum TO ls_tstp3-valid_from DD/MM/YYYY.
        ls_tstp3-valid_to  = c_enddate.
        APPEND ls_tstp3 TO gt_tstp3.
        PERFORM f_bom_insert.
        PERFORM f_material_unlock.
        PERFORM f_unlock_all.
        CLEAR : ls_tstp3, gt_tstp3[].
      WHEN c_u.
        ls_tstp3-id_item_no = wa_bom_original_tmp-posnr.
        ls_tstp3-component  = wa_bom_original_tmp-idnrk.
        v_idnrk = wa_bom_original_tmp-idnrk.
        APPEND ls_tstp3 TO gt_tstp3.
        PERFORM f_bom_insert.
        PERFORM f_material_unlock.
        PERFORM f_unlock_all.
        CLEAR : ls_tstp3, gt_tstp3[].
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_bom .
  api_stko1-base_quan = c_1.
  IF gs_header_data-mtart = c_multi_med.
    api_stko1-bom_text = 'BOM for Multi Journal Package'(001).
  ELSEIF gs_header_data-mtart = c_multi_jour.
    api_stko1-bom_text = 'BOM for Multi Media'(002).
  ENDIF.

  APPEND api_stko1.
  api_stpo1-comp_qty = c_1.
  MODIFY api_stpo1 TRANSPORTING comp_qty WHERE comp_qty = space.
  PERFORM f_material_unlock.
  CALL FUNCTION 'DEQUEUE_ALL'.
*  es_message  = gs_message.
*       create new bom
  CALL FUNCTION 'CSAP_MAT_BOM_CREATE'
    EXPORTING
      material          = api_mbom-matnr
      plant             = api_mbom-werks
      bom_usage         = api_mbom-stlan
      valid_from        = api_mbom-datuv
      change_no         = ale_aennr
      fl_recursive      = c_x                   "note_1826207
*     REVISION_LEVEL    =
      i_stko            = api_stko1
*     FL_NO_CHANGE_DOC  = ' '
      fl_default_values = ' '                   "note506312
    IMPORTING
      fl_warning        = api_warning
    TABLES
      t_stpo            = api_stpo1
    EXCEPTIONS
      error             = 1
      OTHERS            = 2.
  IF sy-subrc NE 0.
    flg_lock_err = abap_true.
  ENDIF.
  PERFORM f_material_unlock.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PLANT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_plant_data .
  LOOP AT mastb.
    SELECT SINGLE werks
             FROM mast
             INTO l_werks
            WHERE matnr = mastb-matnr
              AND werks = mastb-werks
              AND stlan = mastb-stlan
              AND cslty = ' '.
    IF sy-subrc = 0.
      EXIT.
    ENDIF.
  ENDLOOP.
  IF l_werks IS INITIAL.
    READ TABLE mastb INDEX 1.
  ENDIF.
  REFRESH mastb.
  APPEND mastb.
  READ TABLE mastb INTO lst_mastb INDEX 1.
  SELECT SINGLE * FROM mara INTO lst_mara WHERE matnr = lst_mastb-matnr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_API
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_api .
  CALL FUNCTION 'CALO_INIT_API'
    EXCEPTIONS
      log_object_not_found     = 1
      log_sub_object_not_found = 2
      other_error              = 3
      OTHERS                   = 4.
  IF sy-subrc EQ 0.
* Implement suitable code
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UNLOCK_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_unlock_all .
  CALL FUNCTION 'DEQUEUE_ALL'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_ENTRIES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constant_entries .
* Fetch values from constant table
  SELECT *
    INTO TABLE li_constant
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid = c_devid
      AND activate = abap_true.
  IF sy-subrc EQ 0.
    SORT li_constant BY devid param1.

*   Loop through constant table to retrieve constant values
    LOOP AT li_constant INTO DATA(lst_constant).
      IF lst_constant-param1 EQ c_multi_journal. " Material Types: multi_journal
        APPEND INITIAL LINE TO r_multi_journal ASSIGNING FIELD-SYMBOL(<lst_multi_journal>).
        <lst_multi_journal>-sign   = lst_constant-sign.
        <lst_multi_journal>-option = lst_constant-opti.
        <lst_multi_journal>-low    = lst_constant-low.
        <lst_multi_journal>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mtart_med_iss
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SLG_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_slg_create .
  DATA: l_log_handle TYPE balloghndl,
        l_timestamp  TYPE tzntstmps,
        l_timezone   TYPE timezone VALUE 'UTC',
        l_str_log    TYPE bal_s_log,
        l_str_balmsg TYPE bal_s_msg,
*        l_str_message  TYPE bapiret2,
        l_msg_logged TYPE boolean.
*        l_tab_messages TYPE bapiret2_t.
  TABLES: syst.
  DATA: lv_log_object    LIKE balhdr-object    VALUE 'ZQTC',
        lv_log_subobject LIKE balhdr-subobject VALUE 'ZBOMMAT_INB01'.
  "lt_log_number_tab TYPE TABLE OF balnri,
  "ls_log_number     TYPE balnri.
*-Logging messages
  CONVERT DATE sy-datum TIME sy-uzeit
  INTO TIME STAMP l_timestamp TIME ZONE l_timezone.

  l_str_log-extnumber = l_timestamp.
  CONDENSE l_str_log-extnumber.
  l_str_log-object = lv_log_object.
  l_str_log-subobject = lv_log_subobject.
  l_str_log-aldate_del = sy-datum + 5.
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = l_str_log
    IMPORTING
      e_log_handle            = l_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
*    WRITE: ‘type’,sy-msgty, ‘message’,l_str_message-message.
  ELSE.
    LOOP AT l_tab_messages INTO l_str_message.
      MOVE: l_str_message-type       TO l_str_balmsg-msgty,
      l_str_message-id         TO l_str_balmsg-msgid,
      l_str_message-number     TO l_str_balmsg-msgno,
      l_str_message-message_v1 TO l_str_balmsg-msgv1,
      l_str_message-message_v2 TO l_str_balmsg-msgv2,
      l_str_message-message_v3 TO l_str_balmsg-msgv3,
      l_str_message-message_v4 TO l_str_balmsg-msgv4.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = l_log_handle
          i_s_msg          = l_str_balmsg
        IMPORTING
          e_msg_was_logged = l_msg_logged
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
*        WRITE: ‘type’,sy-msgty, ‘message’,l_str_message-message.
      ENDIF.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAL_DB_SAVE'
        EXPORTING
          i_save_all       = abap_true
        EXCEPTIONS
          log_not_found    = 1
          save_not_allowed = 2
          numbering_error  = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
*        WRITE: ‘type’,sy-msgty, ‘message’,l_str_message-message.
      ELSE.
*        WRITE: ‘messages saved IN the log’.
      ENDIF.
    ENDIF.
  ENDIF.
*  WRITE : ‘done with LOG number’,l_str_log-extnumber.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_RETDATA_SAVE1  text
*----------------------------------------------------------------------*
FORM f_log_update  USING    p_lst_retdata_save1 TYPE bapi_matreturn2.
  l_str_message-type  = p_lst_retdata_save1-type.
  l_str_message-id   = p_lst_retdata_save1-id.
  l_str_message-number     = p_lst_retdata_save1-number.
  l_str_message-message_v1 = p_lst_retdata_save1-message_v1.
  l_str_message-message_v2 = p_lst_retdata_save1-message_v2.
  l_str_message-message_v3 = p_lst_retdata_save1-message_v3.
  l_str_message-message_v4 = p_lst_retdata_save1-message_v4.
  APPEND l_str_message TO l_tab_messages.
  CLEAR l_str_message.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BDC_LOG_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_MSG  text
*----------------------------------------------------------------------*
FORM f_bdc_log_update  USING    p_t_msg TYPE bdcmsgcoll.
  l_str_message-type  = p_t_msg-msgtyp.
  l_str_message-id   = p_t_msg-msgid.
  l_str_message-number     = p_t_msg-msgnr.
  l_str_message-message_v1 = p_t_msg-msgv1.
  l_str_message-message_v2 = p_t_msg-msgv2.
  l_str_message-message_v3 = p_t_msg-msgv3.
  l_str_message-message_v4 = p_t_msg-msgv4.
  APPEND l_str_message TO l_tab_messages.
  CLEAR l_str_message.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BATCH_LOG_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_RETURN1_CLAS  text
*----------------------------------------------------------------------*
FORM f_batch_log_update  USING    p_lst_return1_clas TYPE bapi_matreturn2.
  l_str_message-type  = p_lst_return1_clas-type.
  l_str_message-id   = p_lst_return1_clas-id.
  l_str_message-number     = p_lst_return1_clas-number.
  l_str_message-message_v1 = p_lst_return1_clas-message_v1.
  l_str_message-message_v2 = p_lst_return1_clas-message_v2.
  l_str_message-message_v3 = p_lst_return1_clas-message_v3.
  l_str_message-message_v4 = p_lst_return1_clas-message_v4.
  APPEND l_str_message TO l_tab_messages.
  CLEAR l_str_message.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MAT_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_MERRDAT  text
*----------------------------------------------------------------------*
FORM f_log_mat_update  USING    p_lst_merrdat TYPE merrdat.
  l_str_message-type  = p_lst_merrdat-msgty.
  l_str_message-id   = p_lst_merrdat-msgid.
  l_str_message-number     = p_lst_merrdat-msgno.
  l_str_message-message_v1 = p_lst_merrdat-msgv1.
  l_str_message-message_v2 = p_lst_merrdat-msgv2.
  l_str_message-message_v3 = p_lst_merrdat-msgv3.
  l_str_message-message_v4 = p_lst_merrdat-msgv4.
  APPEND l_str_message TO l_tab_messages.
  CLEAR l_str_message.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_UNLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_material_unlock .
  CALL FUNCTION 'DEQUEUE_EMMARAE'
    EXPORTING
      mandt  = sy-mandt
      matnr  = gs_header_data-matnr
      _scope = '2'.

  CALL FUNCTION 'DEQUEUE_EMMARAS'
    EXPORTING
      mandt  = sy-mandt
      matnr  = gs_header_data-matnr
      _scope = '2'.

ENDFORM.
