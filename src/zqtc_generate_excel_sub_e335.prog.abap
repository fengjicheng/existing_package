*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_GENERATE_EXCEL_SUB_E335 (Genarate the excel file)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/28/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                    *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*
* REVISION NO: ED2K919899                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/14/2020                                                    *
* DESCRIPTION: Logic changes for Subscrition order/Po count/add new Print vendor
*              display and remove duplicate from the PO number
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_columns,
         check      TYPE char1,
         fieldname  TYPE slis_fieldname,
         c_name(40) TYPE c,
       END OF ty_columns.

DATA : li_columns TYPE STANDARD TABLE OF ty_columns INITIAL SIZE 0.

DATA: li_colfcat  TYPE slis_t_fieldcat_alv,
      lst_colfcat LIKE LINE OF li_colfcat.

DATA : lv_mask_tmp    TYPE string,
       lv_mask        TYPE char255,
       lv_index       TYPE sy-tabix,
       lv_count       TYPE sy-tabix,
       lv_history_cnt TYPE char9,
       lv_filename    TYPE string,
       lv_path        TYPE string,
       lv_fullpath    TYPE string.

DATA : lst_line TYPE ty_excel_tab.

CONSTANTS : lc_mask_separator    TYPE char1 VALUE ' ',
            lc_history_separator TYPE char1 VALUE ':'.


REFRESH : li_colfcat[] , li_columns[] .
CLEAR  : lv_mask , lv_mask_tmp.

" Build Popup list field catalog
lst_colfcat-col_pos = 1.
lst_colfcat-fieldname = 'CHECK'.
lst_colfcat-seltext_l = 'Select'.
lst_colfcat-tabname = 'LI_COLUMNS'.
APPEND lst_colfcat TO li_colfcat.
CLEAR lst_colfcat.

lst_colfcat-col_pos = 2.
lst_colfcat-fieldname = 'FIELDNAME'.
lst_colfcat-seltext_l = 'Field Name'.
lst_colfcat-no_out = abap_true.
lst_colfcat-tabname = 'LI_COLUMNS'.
APPEND lst_colfcat TO li_colfcat.
CLEAR lst_colfcat.

lst_colfcat-col_pos = 3.
lst_colfcat-fieldname = 'C_NAME'.
lst_colfcat-seltext_l = 'Field Name'.
lst_colfcat-outputlen = 40.
lst_colfcat-tabname = 'LI_COLUMNS'.
APPEND lst_colfcat TO li_colfcat.
CLEAR lst_colfcat.


" Build popup list Field name and selection
LOOP AT i_fieldcat INTO DATA(lst_fieldcat).
  APPEND INITIAL LINE TO li_columns ASSIGNING FIELD-SYMBOL(<lfs_columns>).
  <lfs_columns>-check = abap_true.
  <lfs_columns>-fieldname = lst_fieldcat-fieldname.
  <lfs_columns>-c_name = lst_fieldcat-seltext_l.
ENDLOOP.

" Popup the list with filed names
CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
  EXPORTING
    i_title              = 'Select Fields Names'
    i_checkbox_fieldname = 'CHECK'
    i_tabname            = 'LI_COLUMNS'
    it_fieldcat          = li_colfcat
    i_callback_program   = sy-repid
  TABLES
    t_outtab             = li_columns
  EXCEPTIONS
    program_error        = 1
    OTHERS               = 2.

" Build the mask variable for selected field export
LOOP AT li_columns ASSIGNING <lfs_columns>.
  IF sy-tabix = 1.                        " First record of the field list
    IF <lfs_columns>-check = abap_true.   " Field selected for export
      CONCATENATE lv_mask_tmp abap_true INTO lv_mask_tmp.
    ELSE.                                 " Field not selected for export
      CONCATENATE lv_mask_tmp lc_mask_separator  INTO lv_mask_tmp SEPARATED BY space.
    ENDIF.
  ELSE.                                   " Concatenate the checkbox value to mask variable.
    IF <lfs_columns>-check = abap_true.   " Field selected for export
      CONCATENATE lv_mask_tmp abap_true INTO lv_mask_tmp.
    ELSE.                                 " Field not selected for export
      CONCATENATE lv_mask_tmp lc_mask_separator  INTO lv_mask_tmp SEPARATED BY space.
    ENDIF.
  ENDIF.

  " Prepare the selected header for excel export
  CASE <lfs_columns>-fieldname.
    WHEN c_vbeln.
      lst_line-vbeln = <lfs_columns>-c_name.
      CONDENSE lst_line-vbeln.
    WHEN c_posnr.
      lst_line-posnr = <lfs_columns>-c_name.
    WHEN c_matnr.
      lst_line-matnr = <lfs_columns>-c_name.
    WHEN c_kwmeng.
      lst_line-kwmeng = <lfs_columns>-c_name.
    WHEN c_kbmeng.
      lst_line-kbmeng = <lfs_columns>-c_name.
    WHEN c_olfmng.
      lst_line-olfmng = <lfs_columns>-c_name.
    WHEN c_vrkme.
      lst_line-vrkme = <lfs_columns>-c_name.
    WHEN c_lfdat_1.
      lst_line-lfdat_1 = <lfs_columns>-c_name.
    WHEN c_lprio.
      lst_line-lprio = <lfs_columns>-c_name.
    WHEN c_kunnr.
      lst_line-kunnr = <lfs_columns>-c_name.
    WHEN c_fixmg.
      lst_line-fixmg = <lfs_columns>-c_name.
    WHEN c_ship2party.
      lst_line-zzship2party = <lfs_columns>-c_name.
    WHEN c_forwdagnt.
      lst_line-zzforwarding_agent = <lfs_columns>-c_name.
    WHEN c_refdoc.
      lst_line-zzvgbel = <lfs_columns>-c_name.
    WHEN c_yourref.
      lst_line-zzihrez = <lfs_columns>-c_name.
    WHEN c_arriavaldat.
      lst_line-zzismarrivaldateac = <lfs_columns>-c_name.
    WHEN c_plant.
      lst_line-zzwerks = <lfs_columns>-c_name.
    WHEN c_shippoint.
      lst_line-zzvstel = <lfs_columns>-c_name.
    WHEN c_conuntryky.
      lst_line-zzland1 = <lfs_columns>-c_name.
    WHEN c_ordertype.
      lst_line-zzauart = <lfs_columns>-c_name.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    WHEN c_prtvendor.
      lst_line-zzvendor_prt = <lfs_columns>-c_name.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    WHEN c_vendor.
      lst_line-zzvendor = <lfs_columns>-c_name.
    WHEN c_volumyear.
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
      lst_line-zzismyearnr = <lfs_columns>-c_name.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    WHEN c_history.
      lst_line-zzhistory = <lfs_columns>-c_name.
    WHEN c_ponumber.
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
      lst_line-zzpohistory = <lfs_columns>-c_name.
    WHEN c_delnumber.
      lst_line-zzdeliveryhistory = <lfs_columns>-c_name.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    WHEN c_shipcondit.
      lst_line-zzvsbed = <lfs_columns>-c_name.
    WHEN c_shipinstruct.
      lst_line-zzship_introduction = <lfs_columns>-c_name.
    WHEN c_delblock.
      lst_line-zzlifsk = <lfs_columns>-c_name.
    WHEN c_delblkdes.
      lst_line-zzdel_vtext = <lfs_columns>-c_name.
    WHEN c_bilblock.
      lst_line-zzfaksk = <lfs_columns>-c_name.
    WHEN c_bilblockdes.
      lst_line-zzbill_vtext = <lfs_columns>-c_name.
    WHEN c_crdblock.
      lst_line-zzcmgst = <lfs_columns>-c_name.
    WHEN c_crdblockdes.
      lst_line-zzbezei = <lfs_columns>-c_name.
  ENDCASE.
ENDLOOP.

MOVE lv_mask_tmp TO lv_mask.            " Move string to char
SORT i_excel_tab BY zzship2party matnr.

" Fill order history columns with details
LOOP AT i_excel_tab ASSIGNING FIELD-SYMBOL(<lfs_excel_tab>).
  IF is_sum_ortypewise IS NOT INITIAL.
    READ TABLE is_sum_ortypewise ASSIGNING FIELD-SYMBOL(<lfs_sum_ortypewise>) WITH KEY kunnr = <lfs_excel_tab>-zzship2party
                                                                                       matnr = <lfs_excel_tab>-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
      LOOP AT is_sum_ortypewise ASSIGNING <lfs_sum_ortypewise> FROM lv_index. "Avoiding Where clause
        IF <lfs_sum_ortypewise>-kunnr <> <lfs_excel_tab>-zzship2party OR
           <lfs_sum_ortypewise>-matnr <> <lfs_excel_tab>-matnr.
          CLEAR lv_count.
          EXIT.
        ENDIF.
        CLEAR : lv_history_cnt.
        WRITE <lfs_sum_ortypewise>-count TO lv_history_cnt DECIMALS 0.
        CONDENSE lv_history_cnt NO-GAPS.
        lv_count = lv_count + 1.
        IF lv_count GT 1.
          CONCATENATE <lfs_excel_tab>-zzhistory ',' INTO <lfs_excel_tab>-zzhistory SEPARATED BY space.
          CONCATENATE <lfs_excel_tab>-zzhistory lc_mask_separator INTO lv_mask_tmp SEPARATED BY space.
          CONCATENATE  <lfs_excel_tab>-zzhistory <lfs_sum_ortypewise>-auart lc_history_separator
                                              lv_history_cnt INTO <lfs_excel_tab>-zzhistory.
          CONDENSE <lfs_excel_tab>-zzhistory.
        ELSE.
          CONCATENATE <lfs_excel_tab>-zzhistory <lfs_sum_ortypewise>-auart lc_history_separator
                                              lv_history_cnt INTO <lfs_excel_tab>-zzhistory.
          CONDENSE <lfs_excel_tab>-zzhistory.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDLOOP.

" Fill purchase order history columns with details
LOOP AT i_excel_tab ASSIGNING <lfs_excel_tab>.
  IF i_pohistory IS NOT INITIAL.
    READ TABLE i_pohistory ASSIGNING FIELD-SYMBOL(<lfs_podeails>) WITH KEY kunnr = <lfs_excel_tab>-zzship2party
                                                                           matnr = <lfs_excel_tab>-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
      CLEAR : lv_count.
      LOOP AT i_pohistory ASSIGNING <lfs_podeails> FROM lv_index. "Avoiding Where clause
        IF <lfs_podeails>-kunnr <> <lfs_excel_tab>-zzship2party OR
           <lfs_podeails>-matnr <> <lfs_excel_tab>-matnr.
          CLEAR lv_count.
          EXIT.
        ENDIF.
        CONDENSE <lfs_podeails>-ebeln.
        lv_count = lv_count + 1.
        IF lv_count GT 1.
          CONCATENATE <lfs_excel_tab>-zzpohistory ',' INTO <lfs_excel_tab>-zzpohistory SEPARATED BY space.
          CONCATENATE <lfs_excel_tab>-zzpohistory lc_mask_separator INTO lv_mask_tmp SEPARATED BY space.
          CONCATENATE  <lfs_excel_tab>-zzpohistory <lfs_podeails>-ebeln INTO <lfs_excel_tab>-zzpohistory.
          CONDENSE <lfs_excel_tab>-zzpohistory.
        ELSE.
          <lfs_excel_tab>-zzpohistory = <lfs_podeails>-ebeln.
          CONDENSE <lfs_excel_tab>-zzpohistory.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDLOOP.

" Fill outbound delivery history columns with details
LOOP AT i_excel_tab ASSIGNING <lfs_excel_tab>.
  IF i_delhistory IS NOT INITIAL.
    READ TABLE i_delhistory ASSIGNING FIELD-SYMBOL(<lfs_deldeails>) WITH KEY kunnr = <lfs_excel_tab>-zzship2party
                                                                             matnr = <lfs_excel_tab>-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
      CLEAR : lv_count.
      LOOP AT i_delhistory ASSIGNING <lfs_deldeails> FROM lv_index. "Avoiding Where clause
        IF <lfs_deldeails>-kunnr <> <lfs_excel_tab>-zzship2party OR
           <lfs_deldeails>-matnr <> <lfs_excel_tab>-matnr.
          CLEAR lv_count.
          EXIT.
        ENDIF.
        CONDENSE <lfs_deldeails>-vbeln.
        lv_count = lv_count + 1.
        IF lv_count GT 1.
          CONCATENATE <lfs_excel_tab>-zzdeliveryhistory ',' INTO <lfs_excel_tab>-zzdeliveryhistory SEPARATED BY space.
          CONCATENATE <lfs_excel_tab>-zzdeliveryhistory lc_mask_separator INTO lv_mask_tmp SEPARATED BY space.
          CONCATENATE  <lfs_excel_tab>-zzdeliveryhistory <lfs_deldeails>-vbeln INTO <lfs_excel_tab>-zzdeliveryhistory.
          CONDENSE <lfs_excel_tab>-zzdeliveryhistory.
        ELSE.
          <lfs_excel_tab>-zzdeliveryhistory = <lfs_deldeails>-vbeln.
          CONDENSE <lfs_excel_tab>-zzdeliveryhistory.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDLOOP.

SORT i_excel_tab BY vbeln posnr.            " Sort Itab for final output
INSERT lst_line INTO i_excel_tab INDEX 1.   " Add excel header to output itab

" select file location
CALL METHOD cl_gui_frontend_services=>file_save_dialog
  EXPORTING
    default_extension         = 'XLS'
  CHANGING
    filename                  = lv_filename
    path                      = lv_path
    fullpath                  = lv_fullpath
  EXCEPTIONS
    cntl_error                = 1
    error_no_gui              = 2
    not_supported_by_gui      = 3
    invalid_default_file_name = 4
    OTHERS                    = 5.
IF sy-subrc = 0.

  IF lv_fullpath IS NOT INITIAL.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename                = lv_fullpath
        filetype                = 'ASC'
        write_field_separator   = '|'
        header                  = '00'
        col_select              = abap_true
        col_select_mask         = lv_mask
        wk1_t_size              = 15
        confirm_overwrite       = 'X'
      TABLES
        data_tab                = i_excel_tab
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.
    IF sy-subrc <> 0.
      " need to implement suitable error handler
    ENDIF.
  ENDIF.

ENDIF.
