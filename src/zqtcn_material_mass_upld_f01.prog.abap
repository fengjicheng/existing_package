*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_MASS_UPLD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/17/2019
*& OBJECT ID:             C110.1
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FORM f_get_filename CHANGING p_filename.
  IF sy-batch = space.
    CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
      CHANGING
        file_name     = p_filename
      EXCEPTIONS
        mask_too_long = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file TABLES p_file_data.
  DATA:li_type       TYPE truxs_t_text_data,
       lst_file_data TYPE ity_file.
  FREE:p_file_data.
  IF sy-batch = space.
*--foreground file fetching into internal table

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = p_file_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
*--Background file fetching into internal table
    FREE: p_file_data,lst_file_data.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO lst_file_data.
        IF sy-subrc = 0.
          APPEND lst_file_data TO p_file_data.
          CLEAR lst_file_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_file.
    ENDIF.
  ENDIF.
  IF p_file_data[] IS NOT INITIAL.
    FREE:i_file_temp,i_rows.
    i_file_temp[] =  p_file_data[].
    SORT i_file_temp BY bismt.
    LOOP AT i_file_temp ASSIGNING FIELD-SYMBOL(<fs_file_temp>).
      CONDENSE <fs_file_temp>-bismt.
    ENDLOOP.
    SELECT matnr
           mtart
           bismt
       FROM mara
       INTO TABLE i_mara
       FOR ALL ENTRIES IN i_file_temp
       WHERE bismt = i_file_temp-bismt.
    IF sy-subrc = 0.
      SORT i_mara BY bismt.
    ENDIF.
    FREE:i_file_temp.
  ENDIF.
  i_rows = lines( p_file_data[] ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data.
  DATA: lr_events TYPE REF TO cl_salv_events_table.

  DATA: lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.
  IF p_chk IS NOT INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = ir_table
          CHANGING
            t_table      = i_file_data_p.
      ##NO_HANDLER    CATCH cx_salv_msg .
    ENDTRY.
  ELSE.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = ir_table
          CHANGING
            t_table      = i_file_data.
      ##NO_HANDLER    CATCH cx_salv_msg .
    ENDTRY.
  ENDIF.

  IF sy-batch = space.
    ir_table->set_screen_status(
        pfstatus      =  'ZSALV_STANDARD'
        report        =  sy-repid
        set_functions = ir_table->c_functions_all ).

    lr_columns = ir_table->get_columns( ).
    lr_columns->set_optimize( abap_true ).

    ir_selections = ir_table->get_selections( ).

    ir_selections->set_selection_mode( ir_selections->multiple ).

    TRY.
        lr_column ?= lr_columns->get_column( 'IND_SECT' ).
        lr_column ?= lr_columns->get_column( 'MTART' ).
        IF p_chk IS NOT INITIAL.
          lr_column ?= lr_columns->get_column( 'BUKRS' ).
        ENDIF.
        lr_column ?= lr_columns->get_column( 'WERKS' ).
        lr_column ?= lr_columns->get_column( 'VKORG' ).
        lr_column ?= lr_columns->get_column( 'VTWEG' ).
        lr_column ?= lr_columns->get_column( 'MAKTX' ).
        lr_column ?= lr_columns->get_column( 'MEINS' ).
        lr_column->set_short_text( 'B.Unit' ).
        lr_column->set_medium_text( 'Base Unit' ).
        lr_column->set_long_text( 'Base Unit' ).
        lr_column ?= lr_columns->get_column( 'MATKL' ).
        lr_column ?= lr_columns->get_column( 'BISMT' ).
        lr_column ?= lr_columns->get_column( 'SPART' ).
        lr_column ?= lr_columns->get_column( 'MSTAE' ).
        lr_column ?= lr_columns->get_column( 'ITEM_CAT' ).
        lr_column ?= lr_columns->get_column( 'DWERK' ).
        lr_column ?= lr_columns->get_column( 'TAXKM' ).
        lr_column->set_short_text( 'Tax clas.' ).
        lr_column->set_medium_text( 'Tax classification' ).
        lr_column->set_long_text( 'Tax classification' ).
        lr_column ?= lr_columns->get_column( 'MTPOS' ).
        lr_column ?= lr_columns->get_column( 'MVGR4' ).
        lr_column ?= lr_columns->get_column( 'MTVFP' ).
        lr_column ?= lr_columns->get_column( 'TRAGR' ).
        lr_column ?= lr_columns->get_column( 'LADGR' ).
        lr_column ?= lr_columns->get_column( 'PRCTR' ).
        IF p_chk IS NOT INITIAL.
          lr_column ?= lr_columns->get_column( 'EKGRP' ).
          lr_column ?= lr_columns->get_column( 'KAUTB' ).
          lr_column ?= lr_columns->get_column( 'DISMM' ).
          lr_column ?= lr_columns->get_column( 'BESKZ' ).
          lr_column ?= lr_columns->get_column( 'BKLAS' ).
          lr_column ?= lr_columns->get_column( 'VPRSV' ).
          lr_column ?= lr_columns->get_column( 'PEINH' ).
          lr_column->set_short_text( 'Price Unit' ).
          lr_column->set_medium_text( 'Price Unit' ).
          lr_column->set_long_text( 'Price Unit' ).
          lr_column ?= lr_columns->get_column( 'STPRS' ).
          lr_column->set_short_text( 'Std price' ).
          lr_column->set_medium_text( 'Standard price' ).
          lr_column->set_long_text( 'Standard price' ).
        ENDIF.
        lr_column ?= lr_columns->get_column( 'TEXT' ).
        lr_column->set_short_text( 'Text' ).
        lr_column->set_medium_text( 'Text' ).
        lr_column->set_long_text( 'Text' ).
        lr_column ?= lr_columns->get_column( 'MATNR' ).
        lr_column ?= lr_columns->get_column( 'TYPE' ).
        lr_column ?= lr_columns->get_column( 'MESSAGE' ).
        lr_column->set_short_text( 'Message' ).
        lr_column->set_medium_text( 'Message' ).
        lr_column->set_long_text( 'Message' ).
      ##NO_HANDLER    CATCH cx_salv_not_found.
    ENDTRY.

    lr_events = ir_table->get_event( ).
    CREATE OBJECT ir_events.
    SET HANDLER ir_events->on_user_command FOR lr_events.
    PERFORM f_set_top_of_page CHANGING ir_table.
  ENDIF.
  ir_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_IR_TABLE  text
*----------------------------------------------------------------------*
FORM f_set_top_of_page  CHANGING co_alv TYPE REF TO cl_salv_table.

  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string.

  lo_head = 'Material Master Create Report'(003).
  CONDENSE i_rows.
  CONDENSE gv_total_proc.
  CONDENSE gv_error.
  CONDENSE gv_success.

  CREATE OBJECT lo_grid.

  lo_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lo_head
                                      tooltip = lo_head ).

  lo_grid1 = lo_grid->create_grid( row = 2
                                  column = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row = 2
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Total Records:'(004)
                                    tooltip = 'Total Records:'(004) ).

  lo_text = lo_flow->create_text( text = i_rows
                                  tooltip = i_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '(006)
                                    tooltip = 'Processed : '(006) ).

  lo_text = lo_flow->create_text( text = gv_total_proc
                                  tooltip = gv_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'(007)
                                    tooltip = 'Success:'(007) ).

  lo_text = lo_flow->create_text( text = gv_success
                                  tooltip = gv_success ).
*
*
  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'(008)
                                    tooltip =  'Errors:'(008) ).

  lo_text = lo_flow->create_text( text = gv_error
                                  tooltip = gv_error ).
*--Set Top of List
  co_alv->set_top_of_list( lo_grid ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_SALV_FUNCTION  text
*----------------------------------------------------------------------*
FORM f_handle_user_command  USING  i_ucomm TYPE salv_de_function.
  DATA: li_rows   TYPE salv_t_row.
  DATA: lst_const TYPE zcaconstant.
  DATA: lst_columns TYPE REF TO cl_salv_columns.
  IF  p_chk IS NOT INITIAL.
    DESCRIBE TABLE i_file_data_p LINES DATA(lv_no_of_records).
  ELSE.
    DESCRIBE TABLE i_file_data LINES lv_no_of_records.
  ENDIF.

  FREE: i_const.
  SELECT *
     FROM zcaconstant
     INTO TABLE i_const
     WHERE devid = c_devid
    AND activate = c_x.
  IF sy-subrc EQ 0.
    SORT i_const BY param1.
  ENDIF.

  CLEAR lst_const .
  READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param1.

  IF lv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.
    IF lv_no_of_records > lst_const-low.
*--get the application layer path dynamically
      PERFORM f_get_file_path USING v_path_in '*'.
      REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*---File data submitted to background and created the batch job in SM37
      PERFORM f_submit_program_in_background.
    ELSE.
      IF  p_chk IS NOT INITIAL.
        LOOP AT i_file_data_p ASSIGNING FIELD-SYMBOL(<fs_file_data_p>).
          PERFORM f_create_material_chk USING <fs_file_data_p>.
        ENDLOOP.
      ELSE.
        LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fs_file_data>).
          PERFORM f_create_material USING <fs_file_data>.
        ENDLOOP.
      ENDIF.
      PERFORM f_error_success_log.
      lst_columns = ir_table->get_columns( ).
      lst_columns->set_optimize( c_true ).
      PERFORM f_set_top_of_page CHANGING ir_table.
      ir_table->refresh( ).
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_FILE_DATA>  text
*----------------------------------------------------------------------*
FORM f_create_material  USING  lst_file_data TYPE ity_file.
  DATA:lst_header      TYPE bapimathead,
       lst_clientdata  TYPE bapi_mara,
       lst_clientdatax TYPE bapi_marax,
       lst_plantdata   TYPE bapi_marc,
       lst_plantdatax  TYPE bapi_marcx,
       lst_saledata    TYPE bapi_mvke,
       lst_saledatax   TYPE bapi_mvkex,
       lst_mat_des     TYPE bapi_makt,
       lst_mat_text    TYPE bapi_mltx,
       lst_taxclas     TYPE bapi_mlan,
       lst_return      TYPE bapiret2,
       li_return       TYPE STANDARD TABLE OF bapi_matreturn2,
       li_mat_des      TYPE STANDARD TABLE OF bapi_makt,
       li_mat_text     TYPE STANDARD TABLE OF bapi_mltx,
       li_taxclas      TYPE STANDARD TABLE OF bapi_mlan.

  CONSTANTS: lc_object   TYPE tdobject VALUE 'MVKE',
             lc_id       TYPE tdid     VALUE '0001',
             lc_country  TYPE aland    VALUE 'US',
             lc_tax_type TYPE	tatyp    VALUE 'ZITD'.
  FREE:lst_header,
       lst_clientdata,
       lst_clientdatax,
       lst_plantdata,
       lst_plantdatax,
       lst_saledata,
       lst_saledatax,
       lst_mat_des,
       li_mat_des,
       li_return,
       lst_taxclas,
       li_taxclas.
  READ TABLE i_mara INTO DATA(lst_mara) WITH KEY bismt = lst_file_data-bismt.
  IF sy-subrc NE 0.
    IF lst_file_data-maktx IS NOT INITIAL.
*--Get new material number based on the material type
      CALL FUNCTION 'MATERIAL_NUMBER_GET_NEXT'
        EXPORTING
          materialart          = lst_file_data-mtart
        IMPORTING
          materialnr           = lst_file_data-matnr
        EXCEPTIONS
          no_internal_interval = 1
          type_not_found       = 2
          OTHERS               = 3.
      IF sy-subrc = 0.
        lst_header-material       = lst_file_data-matnr.
        lst_header-ind_sector     = lst_file_data-ind_sect.
        lst_header-matl_type      = lst_file_data-mtart.
        lst_header-basic_view     = abap_true.
        lst_header-sales_view     = abap_true.

        lst_clientdata-matl_group = lst_file_data-matkl.
        lst_clientdata-base_uom   = lst_file_data-meins.
        lst_clientdata-old_mat_no = lst_file_data-bismt.
        lst_clientdata-division   = lst_file_data-spart.
        lst_clientdata-pur_status = lst_file_data-mstae.
        lst_clientdata-item_cat   = lst_file_data-item_cat.
        lst_clientdata-trans_grp  = lst_file_data-tragr.

        lst_clientdatax-matl_group = abap_true.
        lst_clientdatax-base_uom   = abap_true.
        lst_clientdatax-old_mat_no = abap_true.
        lst_clientdatax-division   = abap_true.
        lst_clientdatax-pur_status = abap_true.
        lst_clientdatax-item_cat   = abap_true.
        lst_clientdatax-trans_grp  = abap_true.

        lst_plantdata-plant      = lst_file_data-werks.
        lst_plantdata-availcheck = lst_file_data-mtvfp.
        lst_plantdata-loadinggrp = lst_file_data-ladgr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_file_data-prctr
          IMPORTING
            output = lst_file_data-prctr.

        lst_plantdata-profit_ctr  = lst_file_data-prctr.

        lst_plantdatax-plant      = lst_file_data-werks.
        lst_plantdatax-availcheck = abap_true.
        lst_plantdatax-loadinggrp = abap_true.
        lst_plantdatax-profit_ctr = abap_true.

        lst_saledata-sales_org  = lst_file_data-vkorg.
        lst_saledata-distr_chan = lst_file_data-vtweg.
        lst_saledata-delyg_plnt = lst_file_data-dwerk.
        lst_saledata-matl_grp_4 = lst_file_data-mvgr4.
        lst_saledata-item_cat   = lst_file_data-mtpos.

        lst_saledatax-sales_org  = lst_file_data-vkorg.
        lst_saledatax-distr_chan = lst_file_data-vtweg.
        lst_saledatax-delyg_plnt = abap_true.
        lst_saledatax-matl_grp_4 = abap_true.
        lst_saledatax-item_cat   = abap_true.

        lst_mat_des-langu     = c_langu .
        lst_mat_des-matl_desc = lst_file_data-maktx.
        APPEND lst_mat_des TO li_mat_des.

        lst_taxclas-depcountry = lc_country.
        lst_taxclas-tax_type_1 = lc_tax_type.
        lst_taxclas-taxclass_1 = lst_file_data-taxkm.
        APPEND lst_taxclas TO li_taxclas.

        IF lst_file_data-text IS NOT INITIAL .
          lst_mat_text-applobject = lc_object.
          lst_mat_text-text_id    = lc_id.
          lst_mat_text-langu      = c_langu .
          CONCATENATE lst_file_data-matnr
                      lst_file_data-vkorg
                      lst_file_data-vtweg
                      INTO lst_mat_text-text_name.
          lst_mat_text-text_line = lst_file_data-text+0(130).
          APPEND lst_mat_text TO li_mat_text.
          CLEAR lst_mat_text-text_line.
          IF lst_file_data-text+130(126) IS NOT INITIAL .
            lst_mat_text-text_line = lst_file_data-text+130(126).
            APPEND lst_mat_text TO li_mat_text.
            CLEAR lst_mat_text-text_line.
          ENDIF.
        ENDIF.
*---Creating the material master
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
            materiallongtext    = li_mat_text
            taxclassifications  = li_taxclas
            returnmessages      = li_return.
        READ TABLE li_return INTO DATA(lst_return1) WITH KEY type = c_e.
        IF sy-subrc = 0.
*--creating error interal table
          lst_file_data-type    = lst_return1-type.
          lst_file_data-message = lst_return1-message.
          APPEND lst_file_data TO i_error_rec.
        ELSE.
          READ TABLE li_return INTO lst_return1 WITH KEY type = c_s.
          IF sy-subrc = 0.
*--creating success interal table
            lst_file_data-type   = lst_return1-type.
            lst_file_data-message = lst_return1-message.
            APPEND lst_file_data TO i_sucess_rec.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
*--materials existing with old material numbers
      lst_file_data-type    = c_e.
      lst_file_data-message = 'Material Description is blank'(045).
      APPEND lst_file_data TO i_error_rec.
    ENDIF.
  ELSE.
*--materials existing with old material numbers
    lst_file_data-type    = c_e.
    lst_file_data-matnr   = lst_mara-matnr.
    lst_file_data-message = 'Material is already existing with old material Number'(044).
    APPEND lst_file_data TO i_error_rec.
  ENDIF.
ENDFORM.
FORM f_create_material_chk  USING  lst_file_data TYPE ity_file_p.
  DATA:lst_header         TYPE bapimathead,
       lst_clientdata     TYPE bapi_mara,
       lst_clientdatax    TYPE bapi_marax,
       lst_plantdata      TYPE bapi_marc,
       lst_plantdatax     TYPE bapi_marcx,
       lst_saledata       TYPE bapi_mvke,
       lst_saledatax      TYPE bapi_mvkex,
       lst_mat_des        TYPE bapi_makt,
       lst_mat_text       TYPE bapi_mltx,
       lst_taxclas        TYPE bapi_mlan,
       lst_return         TYPE bapiret2,
       lst_valuationdata  TYPE bapi_mbew,
       lst_valuationdatax TYPE bapi_mbewx,
       li_return          TYPE STANDARD TABLE OF bapi_matreturn2,
       li_mat_des         TYPE STANDARD TABLE OF bapi_makt,
       li_mat_text        TYPE STANDARD TABLE OF bapi_mltx,
       li_taxclas         TYPE STANDARD TABLE OF bapi_mlan.

  CONSTANTS: lc_object   TYPE tdobject VALUE 'MVKE',
             lc_id       TYPE tdid     VALUE '0001',
             lc_country  TYPE aland    VALUE 'US',
             lc_tax_type TYPE	tatyp    VALUE 'ZITD'.
  FREE:lst_header,
       lst_clientdata,
       lst_clientdatax,
       lst_plantdata,
       lst_plantdatax,
       lst_saledata,
       lst_saledatax,
       lst_valuationdata,
       lst_valuationdatax,
       lst_mat_des,
       li_return,
       li_mat_des,
       lst_taxclas,
       li_taxclas.
  READ TABLE i_mara INTO DATA(lst_mara) WITH KEY bismt = lst_file_data-bismt.
  IF sy-subrc NE 0.
    IF lst_file_data-maktx IS NOT INITIAL.
*--Get new material number based on the material type
      CALL FUNCTION 'MATERIAL_NUMBER_GET_NEXT'
        EXPORTING
          materialart          = lst_file_data-mtart
        IMPORTING
          materialnr           = lst_file_data-matnr
        EXCEPTIONS
          no_internal_interval = 1
          type_not_found       = 2
          OTHERS               = 3.
      IF sy-subrc = 0.
        lst_header-material       = lst_file_data-matnr.
        lst_header-ind_sector     = lst_file_data-ind_sect.
        lst_header-matl_type      = lst_file_data-mtart.
        lst_header-basic_view     = abap_true.
        lst_header-sales_view     = abap_true.
        lst_header-purchase_view  = abap_true.
        lst_header-mrp_view       = abap_true.
        lst_header-account_view   = abap_true.

        lst_clientdata-matl_group = lst_file_data-matkl.
        lst_clientdata-base_uom   = lst_file_data-meins.
        lst_clientdata-old_mat_no = lst_file_data-bismt.
        lst_clientdata-division   = lst_file_data-spart.
        lst_clientdata-pur_status = lst_file_data-mstae.
        lst_clientdata-item_cat   = lst_file_data-item_cat.
        lst_clientdata-trans_grp  = lst_file_data-tragr.

        lst_clientdatax-matl_group = abap_true.
        lst_clientdatax-base_uom   = abap_true.
        lst_clientdatax-old_mat_no = abap_true.
        lst_clientdatax-division   = abap_true.
        lst_clientdatax-pur_status = abap_true.
        lst_clientdatax-item_cat   = abap_true.
        lst_clientdatax-trans_grp  = abap_true.

        lst_plantdata-plant      = lst_file_data-werks.
        lst_plantdata-availcheck = lst_file_data-mtvfp.
        lst_plantdata-loadinggrp = lst_file_data-ladgr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_file_data-prctr
          IMPORTING
            output = lst_file_data-prctr.

        lst_plantdata-profit_ctr = lst_file_data-prctr.
        lst_plantdata-pur_group  = lst_file_data-ekgrp.
        lst_plantdata-auto_p_ord = lst_file_data-kautb.
        lst_plantdata-mrp_type   = lst_file_data-dismm.
        lst_plantdata-proc_type  = lst_file_data-beskz.

        lst_plantdatax-plant      = lst_file_data-werks.
        lst_plantdatax-availcheck = abap_true.
        lst_plantdatax-loadinggrp = abap_true.
        lst_plantdatax-profit_ctr = abap_true.
        lst_plantdatax-pur_group  = abap_true.
        lst_plantdatax-auto_p_ord = abap_true.
        lst_plantdatax-mrp_type   = abap_true.
        lst_plantdatax-proc_type  = abap_true.

        lst_valuationdata-val_class  = lst_file_data-bklas.
        lst_valuationdata-val_area   = lst_file_data-bukrs.
        lst_valuationdata-price_ctrl = lst_file_data-vprsv.
        lst_valuationdata-price_unit = lst_file_data-peinh.
        lst_valuationdata-std_price  = lst_file_data-stprs.

        lst_valuationdatax-val_area   = lst_file_data-bukrs.
        lst_valuationdatax-val_class  = abap_true.
        lst_valuationdatax-price_ctrl = abap_true.
        lst_valuationdatax-price_unit = abap_true.
        lst_valuationdatax-std_price  = abap_true.

        lst_saledata-sales_org  = lst_file_data-vkorg.
        lst_saledata-distr_chan = lst_file_data-vtweg.
        lst_saledata-delyg_plnt = lst_file_data-dwerk.
        lst_saledata-matl_grp_4 = lst_file_data-mvgr4.
        lst_saledata-item_cat   = lst_file_data-mtpos.

        lst_saledatax-sales_org  = lst_file_data-vkorg.
        lst_saledatax-distr_chan = lst_file_data-vtweg.
        lst_saledatax-delyg_plnt = abap_true.
        lst_saledatax-matl_grp_4 = abap_true.
        lst_saledatax-item_cat   = abap_true.

        lst_mat_des-langu     = c_langu .
        lst_mat_des-matl_desc = lst_file_data-maktx.
        APPEND lst_mat_des TO li_mat_des.

        lst_taxclas-depcountry = lc_country.
        lst_taxclas-tax_type_1 = lc_tax_type.
        lst_taxclas-taxclass_1 = lst_file_data-taxkm.
        APPEND lst_taxclas TO li_taxclas.

        IF lst_file_data-text IS NOT INITIAL .
          lst_mat_text-applobject = lc_object.
          lst_mat_text-text_id    = lc_id.
          lst_mat_text-langu      = c_langu .
          CONCATENATE lst_file_data-matnr
                      lst_file_data-vkorg
                      lst_file_data-vtweg
                      INTO lst_mat_text-text_name.
          lst_mat_text-text_line = lst_file_data-text+0(130).
          APPEND lst_mat_text TO li_mat_text.
          CLEAR lst_mat_text-text_line.
          lst_mat_text-text_line = lst_file_data-text+130(126).
          APPEND lst_mat_text TO li_mat_text.
          CLEAR lst_mat_text-text_line.
        ENDIF.

*---Creating the material master
        CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
          EXPORTING
            headdata            = lst_header
            clientdata          = lst_clientdata
            clientdatax         = lst_clientdatax
            plantdata           = lst_plantdata
            plantdatax          = lst_plantdatax
            salesdata           = lst_saledata
            salesdatax          = lst_saledatax
            valuationdata       = lst_valuationdata
            valuationdatax      = lst_valuationdatax
          IMPORTING
            return              = lst_return
          TABLES
            materialdescription = li_mat_des
            materiallongtext    = li_mat_text
            taxclassifications  = li_taxclas
            returnmessages      = li_return.
        READ TABLE li_return INTO DATA(lst_return1) WITH KEY type = c_e.
        IF sy-subrc = 0.
*--creating error interal table
          lst_file_data-type    = lst_return1-type.
          lst_file_data-message = lst_return1-message.
          APPEND lst_file_data TO i_error_rec_p.
        ELSE.
          READ TABLE li_return INTO lst_return1 WITH KEY type = c_s.
          IF sy-subrc = 0.
*--creating success interal table
            lst_file_data-type   = lst_return1-type.
            lst_file_data-message = lst_return1-message.
            APPEND lst_file_data TO i_sucess_rec_p.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
*--materials existing with old material numbers
      lst_file_data-type    = c_e.
      lst_file_data-message = 'Material Description is blank'(045).
      APPEND lst_file_data TO i_error_rec_p.
    ENDIF.
  ELSE.
*--materials existing with old material numbers
    lst_file_data-type    = c_e.
    lst_file_data-matnr   = lst_mara-matnr.
    lst_file_data-message = 'Material is already existing with old material Number'(044).
    APPEND lst_file_data TO i_error_rec_p.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_material_create .
  DATA:lv_sel TYPE string.

  IF sy-batch <> space.
    CONCATENATE 'Batch Job Triggered by'(010)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE c_s.
  ENDIF.
  IF  p_chk IS NOT INITIAL.
    LOOP AT i_file_data_p ASSIGNING FIELD-SYMBOL(<fs_file_data_p>).
      PERFORM f_create_material_chk USING <fs_file_data_p>.
    ENDLOOP.
  ELSE.
    LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fs_file_data>).
      PERFORM f_create_material USING <fs_file_data>.
    ENDLOOP.
  ENDIF.

  IF sy-batch <> space.
    FREE:gv_success,gv_error,lv_sel.
    IF  p_chk IS NOT INITIAL.
      DESCRIBE TABLE i_error_rec_p  LINES gv_error.
      DESCRIBE TABLE i_sucess_rec_p LINES gv_success .
      DESCRIBE TABLE i_file_data_p  LINES lv_sel.
    ELSE.
      DESCRIBE TABLE i_error_rec  LINES gv_error.
      DESCRIBE TABLE i_sucess_rec LINES gv_success .
      DESCRIBE TABLE i_file_data  LINES lv_sel.
    ENDIF.
    gv_total_proc = gv_error + gv_success.
    CONCATENATE 'Total selected records to be processed: '(011) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(012) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE c_s.
    MESSAGE lv_error TYPE c_s.
    PERFORM f_error_success_log.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ERROR_SUCCESS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background."  USING p_file TYPE string.
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  CONSTANTS: lc_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_p_file      TYPE rsscr_name VALUE 'P_FILE',
             lc_p_chk       TYPE rsscr_name VALUE 'P_CHK'.
  DATA: lv_file TYPE string,
        lv_bjob TYPE char1.

  CONCATENATE v_file_path 'Material_cr_'(014) sy-datum sy-uzeit INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    IF  p_chk IS NOT INITIAL.
      LOOP AT i_file_data_p INTO DATA(lst_file_data_p).
        TRANSFER lst_file_data_p TO lv_file.
      ENDLOOP.
    ELSE.
      LOOP AT i_file_data INTO DATA(lst_file_data).
        TRANSFER lst_file_data TO lv_file.
      ENDLOOP.
    ENDIF.
  ENDIF.
  CLOSE DATASET lv_file.


  CLEAR:lst_file_data,lst_params.
  lst_params-selname = lc_p_file.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.
  lst_params-selname = lc_p_chk.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = p_chk.           "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE 'ZQTCR_MAT_CREATE_' sy-datum sy-uzeit INTO lv_jobname.
  CONDENSE lv_jobname NO-GAPS.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    lv_bjob = abap_true.
    IF lv_bjob = abap_true.
      SUBMIT zqtcr_material_mass_upld WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_material_mass_upld WITH SELECTION-TABLE li_params.
    ENDIF.
  ENDIF.

  IF sy-subrc = 0.
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_number   "Job number
        jobname              = lv_jobname  "Job name
        strtimmed            = abap_true   "Start immediately
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
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  MESSAGE i255(zqtc_r2) WITH lv_jobname.
  LEAVE TO SCREEN 0.
ENDFORM.

FORM f_error_success_log.
  CONSTANTS:lc_success TYPE string VALUE 'MAT_UPD_SUCCESS_',
            lc_error   TYPE string VALUE 'MAT_UPD_ERROR_'.

  IF sy-batch = space.
    IF  p_chk IS NOT INITIAL.
      DESCRIBE TABLE i_error_rec_p  LINES gv_error.
      DESCRIBE TABLE i_sucess_rec_p LINES gv_success .
    ELSE.
      DESCRIBE TABLE i_error_rec  LINES gv_error.
      DESCRIBE TABLE i_sucess_rec LINES gv_success .
    ENDIF.
    gv_total_proc = gv_error + gv_success.
  ENDIF.

  IF  i_sucess_rec IS NOT INITIAL.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_prc '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing Sucess records to application layer
    CONCATENATE v_file_path lc_success sy-datum sy-uzeit INTO DATA(lv_file).
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.
    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec INTO DATA(lst_record).
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-werks
                    lst_record-vkorg
                    lst_record-vtweg
                    lst_record-maktx
                    lst_record-meins
                    lst_record-matkl
                    lst_record-bismt
                    lst_record-spart
                    lst_record-mstae
                    lst_record-item_cat
                    lst_record-dwerk
                    lst_record-taxkm
                    lst_record-mtpos
                    lst_record-mvgr4
                    lst_record-mtvfp
                    lst_record-tragr
                    lst_record-ladgr
                    lst_record-prctr
                    lst_record-text
                    lst_record-type
                    lst_record-message
                    INTO DATA(lv_value1)
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file.
        CLEAR :lst_record.
      ENDLOOP.

      MESSAGE s258(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.
  IF  i_sucess_rec_p IS NOT INITIAL.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_prc '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing Sucess records to application layer
    FREE:lv_file.
    CONCATENATE v_file_path lc_success sy-datum sy-uzeit INTO lv_file.
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.
    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec_p INTO DATA(lst_record_p).
        CONCATENATE lst_record_p-matnr
                    lst_record_p-ind_sect
                    lst_record_p-mtart
                    lst_record_p-bukrs
                    lst_record_p-werks
                    lst_record_p-vkorg
                    lst_record_p-vtweg
                    lst_record_p-maktx
                    lst_record_p-meins
                    lst_record_p-matkl
                    lst_record_p-bismt
                    lst_record_p-spart
                    lst_record_p-mstae
                    lst_record_p-item_cat
                    lst_record_p-dwerk
                    lst_record_p-taxkm
                    lst_record_p-mtpos
                    lst_record_p-mvgr4
                    lst_record_p-mtvfp
                    lst_record_p-tragr
                    lst_record_p-ladgr
                    lst_record_p-prctr
                    lst_record_p-ekgrp
                    lst_record_p-kautb
                    lst_record_p-dismm
                    lst_record_p-beskz
                    lst_record_p-bklas
                    lst_record_p-vprsv
                    lst_record_p-peinh
                    lst_record_p-stprs
                    lst_record_p-text
                    lst_record_p-type
                    lst_record_p-message
                    INTO lv_value1
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file.
        CLEAR :lst_record_p.
      ENDLOOP.
      MESSAGE s258(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.
  IF i_error_rec IS  NOT INITIAL.

    FREE:lv_value1,lst_record_p,lst_record.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_err '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing error records to application layer
    CONCATENATE v_file_path lc_error sy-datum sy-uzeit INTO DATA(lv_file_e).
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file_e.
    OPEN DATASET lv_file_e FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER i_head TO lv_file_e.

      CLEAR lst_record.
      LOOP AT i_error_rec  INTO lst_record.
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-werks
                    lst_record-vkorg
                    lst_record-vtweg
                    lst_record-maktx
                    lst_record-meins
                    lst_record-matkl
                    lst_record-bismt
                    lst_record-spart
                    lst_record-mstae
                    lst_record-item_cat
                    lst_record-dwerk
                    lst_record-taxkm
                    lst_record-mtpos
                    lst_record-mvgr4
                    lst_record-mtvfp
                    lst_record-tragr
                    lst_record-ladgr
                    lst_record-prctr
                    lst_record-text
                    lst_record-type
                    lst_record-message
                    INTO lv_value1
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file_e.
        CLEAR :lst_record.
      ENDLOOP.

      MESSAGE s257(zqtc_r2) WITH lv_file_e.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file_e.
    ENDIF.
    CLOSE DATASET lv_file_e.
  ENDIF.
  IF  i_error_rec_p IS NOT INITIAL.
    FREE:lv_value1,lst_record_p,lst_record,lv_file_e.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_err '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing error records to application layer
    CONCATENATE v_file_path lc_error sy-datum sy-uzeit INTO lv_file_e.
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file_e.
    OPEN DATASET lv_file_e FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER i_head TO lv_file_e.

      CLEAR lst_record.
      LOOP AT i_error_rec_p INTO lst_record_p.
        CONCATENATE lst_record_p-matnr
                    lst_record_p-ind_sect
                    lst_record_p-mtart
                    lst_record_p-bukrs
                    lst_record_p-werks
                    lst_record_p-vkorg
                    lst_record_p-vtweg
                    lst_record_p-maktx
                    lst_record_p-meins
                    lst_record_p-matkl
                    lst_record_p-bismt
                    lst_record_p-spart
                    lst_record_p-mstae
                    lst_record_p-item_cat
                    lst_record_p-dwerk
                    lst_record_p-taxkm
                    lst_record_p-mtpos
                    lst_record_p-mvgr4
                    lst_record_p-mtvfp
                    lst_record_p-tragr
                    lst_record_p-ladgr
                    lst_record_p-prctr
                    lst_record_p-ekgrp
                    lst_record_p-kautb
                    lst_record_p-dismm
                    lst_record_p-beskz
                    lst_record_p-bklas
                    lst_record_p-vprsv
                    lst_record_p-peinh
                    lst_record_p-stprs
                    lst_record_p-text
                    lst_record_p-type
                    lst_record_p-message
                    INTO lv_value1
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file_e.
        CLEAR :lst_record_p.
      ENDLOOP.
      MESSAGE s257(zqtc_r2) WITH lv_file_e.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file_e.
    ENDIF.
    CLOSE DATASET lv_file_e.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HEAD_NAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_HEAD  text
*----------------------------------------------------------------------*
FORM f_head_names.
  FREE:i_head.
  IF  p_chk IS NOT INITIAL.
*--Header names for files
    CONCATENATE 'Material'(015)
                'Industry Sector'(002)
                'Material Type'(016)
                'Plant'(005)
                'sale Org.'(017)
                'Distribution'(018)
                'Material Des.'(019)
                'Base Unit'(020)
                'Mat. Group'(021)
                'Old Material'(022)
                'Division'(023)
                'Material Status'(024)
                'Item cat. group'(025)
                'Del. Plant'(026)
                'Tax Classif.'(027)
                'Item cat. group'(025)
                'Material grp4'(028)
                'Availability Check'(029)
                'Transportation Group'(030)
                'Loading Group'(031)
                'Profit Center'(032)
                'Text Name'(034)
                'Msg Type'(033)
                'Message'(035)
        INTO i_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
  ELSE.
    CONCATENATE 'Material'(015)
               'Industry Sector'(002)
               'Material Type'(016)
               'Company Code'(036)
               'Plant'(005)
               'sale Org.'(017)
               'Distribution'(018)
               'Material Des.'(019)
               'Base Unit'(020)
               'Mat. Group'(021)
               'Old Material'(022)
               'Division'(023)
               'Material Status'(024)
               'Item cat. group'(025)
               'Del. Plant'(026)
               'Tax Classif.'(027)
               'Item cat. group'(025)
               'Material grp4'(028)
               'Availability Check'(029)
               'Transportation Group'(030)
               'Loading Group'(031)
               'Profit Center'(032)
               'Purchase Group'(037)
               'Auto. PO'(038)
               'MRP Type'(039)
               'Procurement Type'(040)
               'Valuation Class'(041)
               'Valuation Class'(041)
               'Price Unit'(042)
               'Standard Price'(043)
               'Text Name'(034)
               'Msg Type'(033)
               'Message'(035)
       INTO i_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING   fp_v_path
                              fp_v_filename.
  CLEAR :v_file_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_v_path
      operating_system           = sy-opsys
      file_name                  = fp_v_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_file_path
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
