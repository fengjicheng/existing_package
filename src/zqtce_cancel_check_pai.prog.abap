***&---------------------------------------------------------------------*
***&  Include           ZQTCE_CANCEL_CHECK_PAI
***&---------------------------------------------------------------------*
**FORM f_cancel_check      USING us_t185f
**                                us_t185
**                                us_t185v.
**  DATA:ls_t185      TYPE t185,
**       o_popup_alv  TYPE REF TO cl_salv_table,
**       lo_functions TYPE REF TO cl_salv_functions_list.
**
**  ls_t185 = us_t185.
**  IF ls_t185-fcode = 'ZCHK'. "Call Tokenizer
***    TYPES : BEGIN OF ty_output,
***              vkorg TYPE vkorg,
***              vtweg TYPE vtweg,
***              spart TYPE spart,
***              bsark TYPE bsark,
***              vkbur TYPE vkbur,
***              posnr TYPE posnr,
***              faksk TYPE faksk,
***              lifsk TYPE lifsk,
***              lifsp TYPE lifsp,
***              faksp TYPE faksp_ap,
***              abgru TYPE abgru,
***            END OF ty_output.
**    TYPES : BEGIN OF ty_output,
***              vbeln      TYPE vbeln,
**              posnr      TYPE posnr,
**              frm_vch    TYPE char1,
**              eal        TYPE char1,
**              frm_ftp    TYPE char1,
**              canc       TYPE char1,
**              rej        TYPE char1,
**              block      TYPE char1,
**              incomplete TYPE char1,
**              ac_sus     TYPE char1,
**            END OF ty_output.
**
**    DATA : lt_output TYPE STANDARD TABLE OF ty_output,
**           ls_output TYPE ty_output,
**           lt_field  TYPE STANDARD TABLE OF slis_fieldcat_alv,
**           ls_field  TYPE slis_fieldcat_alv.
**
**    IF xvbak-vkbur = '0080'.
**      IF xvbak-vkgrp = 'FRM'.
**        ls_output-frm_vch = abap_true.
**      ENDIF.
**    ELSEIF xvbak-vkbur = '0050'.
**      ls_output-eal = abap_true.
**    ENDIF.
**    IF xvbak-bsark EQ '0160'.
**      ls_output-frm_ftp = abap_true.
**    ENDIF.
**    IF xvbak-faksk IS NOT INITIAL.
**      ls_output-block = abap_true.
**    ENDIF.
**    IF line_exists( xvbuv[ posnr = '000000'] ).
**      ls_output-incomplete = abap_true.
**    ENDIF.
**    APPEND ls_output TO lt_output.
**    CLEAR:ls_output.
**    IF xvbap IS NOT INITIAL.
**      TYPES:BEGIN OF ty_jkshed,
**              vbeln     TYPE vbeln,
**              posnr     TYPE posnr,
**              interrupt TYPE jinterrupt,
**            END OF ty_jkshed.
**      DATA:li_jkshed TYPE STANDARD TABLE OF ty_jkshed.
**      SELECT vbeln posnr interrupt INTO TABLE li_jkshed
**        FROM jksesched
**        FOR ALL ENTRIES IN xvbap
**        WHERE vbeln = xvbap-vbeln AND
**        posnr = xvbap-posnr.
**    ENDIF.
**    LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
**      IF line_exists( xvbep[ posnr = <lfs_vbap>-posnr ] ).
**        IF  xvbep[ posnr = <lfs_vbap>-posnr ]-lifsp IS NOT INITIAL.
**          ls_output-block = abap_true.
**        ENDIF.
**      ENDIF.
**      IF <lfs_vbap>-faksp IS NOT INITIAL.
**        ls_output-block = abap_true.
**      ENDIF.
**      IF <lfs_vbap>-abgru IS NOT INITIAL.
**        ls_output-rej = abap_true.
**      ENDIF.
**      IF <lfs_vbap>-faksp IS NOT INITIAL.
**        ls_output-block = abap_true.
**      ENDIF.
**      IF line_exists( xveda[ vposn = <lfs_vbap>-posnr ] ).
**        IF xveda[ vposn = <lfs_vbap>-posnr ]-vkuegru IS NOT INITIAL.
**          ls_output-canc = abap_true.
**        ENDIF.
**      ENDIF.
**      IF line_exists( xvbuv[ posnr = <lfs_vbap>-posnr ] ).
**        ls_output-incomplete = abap_true.
**      ENDIF.
**      ls_output-posnr = <lfs_vbap>-posnr.
**      IF line_exists( li_jkshed[ posnr = <lfs_vbap>-posnr ] ).
**        ls_output-ac_sus = abap_true.
**      ENDIF.
**      APPEND ls_output TO lt_output.
**      CLEAR:ls_output.
**    ENDLOOP.
***    LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
***      IF line_exists( xvbep[ posnr = <lfs_vbap>-posnr ] ).
***        ls_output-lifsp = xvbep[ posnr = <lfs_vbap>-posnr ]-lifsp.
***      ENDIF.
***      ls_output-posnr = <lfs_vbap>-posnr.
****
***      ls_output-faksp = <lfs_vbap>-faksp.
***      ls_output-abgru = <lfs_vbap>-abgru.
***      ls_output-lifsk = xvbak-lifsk.
***      ls_output-faksk = xvbak-faksk.
***      ls_output-vkorg = xvbak-vkorg.
***      ls_output-vtweg = xvbak-vtweg.
***      ls_output-spart = xvbak-spart.
***      ls_output-vkbur = xvbak-vkbur.
***      ls_output-bsark = xvbak-bsark.
***      APPEND ls_output TO lt_output.
***    ENDLOOP.
**
***----------------------------
*** Get the data based on the field you clicked
***       select * from vbap into corresponding fields of table lt_vbap where vbeln = rs_selfield-value.
**
**    DATA lt_fcat1 TYPE TABLE OF lvc_s_fcat. " For temporary field catalog
**    DATA ls_fcat1 TYPE lvc_s_fcat.
**
**    DATA lv_lines TYPE char2.
**    DATA lv_index TYPE char2.
**
**    DESCRIBE TABLE xvbap LINES lv_lines.
**
**    TYPES:BEGIN OF ty_dynst,
**            fname TYPE char10,
**          END OF ty_dynst.
**
***      data lt_dynst type table of ty_dynst.
**    DATA ls_dynst TYPE ty_dynst.
**
**    FIELD-SYMBOLS:<t_dyntable>  TYPE INDEX TABLE,
**                  <fs_dyntable> TYPE any.
**
**    ls_fcat1-fieldname = 'FIELD'.
**    APPEND ls_fcat1 TO lt_fcat1.
**    CLEAR ls_fcat1.
**
**    ls_fcat1-fieldname = 'HEADER'.
**    APPEND ls_fcat1 TO lt_fcat1.
**    CLEAR ls_fcat1.
**
*** Build temporary field catalog to create dynamic internal table
**
**    LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lfs_xvbap_2>).
**      lv_index = sy-index.
**      ls_fcat1-fieldname = <lfs_xvbap_2>-posnr .
**
**      APPEND ls_fcat1 TO lt_fcat1.
**      CLEAR ls_dynst.
**      CLEAR lv_index.
**
**    ENDLOOP.
**
**    DATA:t_newtable  TYPE REF TO data.
**    DATA: t_newline  TYPE REF TO data.
**    DATA lv_tabix    TYPE sy-tabix.
**    FIELD-SYMBOLS   <fs_test> TYPE any.
*** Create Dynamic internal table
**    CALL METHOD cl_alv_table_create=>create_dynamic_table     "Here creates the internal table dynamcally
**      EXPORTING
**        it_fieldcatalog = lt_fcat1
**      IMPORTING
**        ep_table        = t_newtable.
**
*** Assign the field symbol with dynmica internal table
**    ASSIGN t_newtable->* TO <t_dyntable>.
**
***Create dynamic work area and assign to FS
**
**    CREATE DATA t_newline LIKE LINE OF <t_dyntable>.
**    ASSIGN t_newline->* TO <fs_dyntable>.
**    DATA:lv_counter TYPE i.
**    DO 2 TIMES.
**
**      lv_counter = lv_counter + 1.
**      CASE lv_counter.
**        WHEN 1.
*** MOve the internal table data to field symbol
**          LOOP AT lt_output INTO ls_output.
**            ASSIGN COMPONENT 1  OF STRUCTURE <fs_dyntable> TO <fs_test>.
**            MOVE 'FRM FTP' TO <fs_test>.
**            DATA(lv_line) = line_index( lt_fcat1[ fieldname = ls_output-posnr ] ) .
**            IF lv_line IS NOT INITIAL .
**              ASSIGN COMPONENT lv_line OF STRUCTURE <fs_dyntable> TO <fs_test>.
**              MOVE ls_output-frm_ftp TO <fs_test>.
**            ENDIF.
**          ENDLOOP.
**        WHEN 2.
*** MOve the internal table data to field symbol
**          LOOP AT lt_output INTO ls_output.
**            ASSIGN COMPONENT 1  OF STRUCTURE <fs_dyntable> TO <fs_test>.
**            MOVE 'Rejected' TO <fs_test>.
**            lv_line = line_index( lt_fcat1[ fieldname = ls_output-posnr ] ) .
**            IF lv_line IS NOT INITIAL .
**              ASSIGN COMPONENT lv_line OF STRUCTURE <fs_dyntable> TO <fs_test>.
**              MOVE ls_output-rej TO <fs_test>.
**            ENDIF.
**          ENDLOOP.
**        WHEN 3.
**        WHEN OTHERS.
**      ENDCASE.
**      APPEND <fs_dyntable> TO <t_dyntable>.
**    ENDDO.
**
*** Move the fieldsymbol data to standar internal table as REUSE_ALV_GRID_DISPLAY FM only allows standard field symbol type as OUTPUT
**    FIELD-SYMBOLS <fs_stdtab> TYPE STANDARD TABLE.
**    ASSIGN t_newtable->* TO <fs_stdtab>.
**    <fs_stdtab>[] = <t_dyntable>[].
**
*** building new field catalog
**
**    DATA lt_fieldcat TYPE TABLE OF slis_fieldcat_alv.
**    DATA ls_fieldcat TYPE  slis_fieldcat_alv.
**
**    LOOP AT lt_fcat1 INTO ls_fcat1.
**      ls_fieldcat-seltext_l = ls_fcat1-fieldname.
**      MOVE ls_fcat1-fieldname TO ls_fieldcat-fieldname.
**
**      APPEND ls_fieldcat TO lt_fieldcat.
**    ENDLOOP.
**
***----------------------------
**    cl_salv_table=>factory(
**       IMPORTING
**         r_salv_table   = o_popup_alv
**      CHANGING
**        t_table        = lt_output ). "<fs_stdtab> ).
**
**    lo_functions = o_popup_alv->get_functions( ).
**    lo_functions->set_default( 'X' ).
***
**
**    DATA(lr_display) =  o_popup_alv->get_display_settings( ).
**    lr_display->set_list_header( 'Cancellation/Block Details' ).
**
**    DATA: lo_columns TYPE REF TO cl_salv_columns_table,
**          lo_column  TYPE REF TO cl_salv_column.
**
**    TRY.
***        LOOP AT xvbap ASSIGNING <lfs_vbap>.
***          lo_columns = o_popup_alv->get_columns( ).
***          DATA:lv_fieldname TYPE fieldname.
***          lv_fieldname = <lfs_vbap>-posnr.
***          lo_column = lo_columns->get_column( lv_fieldname ).
***          DATA:lv_text TYPE scrtext_l.
***          DATA(lv_posnr) = <lfs_vbap>-posnr.
***          SHIFT lv_posnr LEFT DELETING LEADING '0'.
***          lv_text = |Item| && |{ lv_posnr }|.
***          lo_column->set_long_text( lv_text ).
***          lo_column->set_output_length('7').
***        ENDLOOP.
***
***        lo_columns = o_popup_alv->get_columns( ).
***        lo_column = lo_columns->get_column( 'FIELD' ).
***        lo_column->set_long_text( 'Field' ).
***        lo_column->set_output_length('8').
***
***        lo_columns = o_popup_alv->get_columns( ).
***        lo_column = lo_columns->get_column( 'HEADER' ).
***        lo_column->set_long_text( 'Header' ).
***        lo_column->set_output_length('8').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'POSNR' ).
**        lo_column->set_long_text( 'Item' ).
**        lo_column->set_output_length('5').
**
***repeat above code for all the columns
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'FRM_VCH' ).
**        lo_column->set_long_text( 'FRM VCH' ).
**        lo_column->set_output_length('8').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'FRM_FTP' ).
**        lo_column->set_long_text( 'FRM FTP' ).
**        lo_column->set_output_length('8').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'EAL' ).
**        lo_column->set_long_text( 'EAL' ).
**        lo_column->set_output_length('4').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'REJ' ).
**        lo_column->set_long_text( 'Rejected' ).
**        lo_column->set_output_length('10').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'CANC' ).
**        lo_column->set_long_text( 'Cancelled' ).
**        lo_column->set_output_length('10').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'BLOCK' ).
**        lo_column->set_long_text( 'Blocked' ).
**        lo_column->set_output_length('8').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'AC_SUS' ).
**        lo_column->set_long_text( 'Active Suspension' ).
**        lo_column->set_output_length('15').
**
**        lo_columns = o_popup_alv->get_columns( ).
**        lo_column = lo_columns->get_column( 'INCOMPLETE' ).
**        lo_column->set_long_text( 'Incomplete' ).
**        lo_column->set_output_length('10').
**      CATCH cx_salv_not_found.                          "#EC NO_HANDLER
**
**    ENDTRY.
**    DATA:lv_low TYPE char10.
**    SELECT SINGLE low INTO lv_low FROM zcaconstant WHERE devid = 'EXX' AND param1 = '1' .
**
**    IF lv_low = '1'.
*** ALV as Popup
**      o_popup_alv->set_screen_popup(
**        start_column = 10
**        end_column   = 100
**        start_line   = 3
**        end_line     = 20 ).
**
*** Display
**      o_popup_alv->display( ).
***    o_popup_alv->set_f
**    ELSE.
**      SUBMIT zqtcr_sord_canc_details AND RETURN  WITH p_vbeln = vbak-vbeln.
**    ENDIF.
**  ENDIF.
************ FIeld catlog creation*************
***    ls_field-col_pos = 1.
***    ls_field-fieldname = 'POSNR'.
***    ls_field-seltext_m = 'Item Number'.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 2.
***    ls_field-fieldname = 'LIFSK'.
***    ls_field-seltext_m = 'Header Delivery Block'.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 3.
***    ls_field-fieldname = 'FAKSK'.
***    ls_field-seltext_m = 'Header Billing Block'.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 4.
***    ls_field-fieldname = 'LIFSP'.
***    ls_field-seltext_m = 'Item Delivery Block'.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***
***    ls_field-col_pos = 5.
***    ls_field-fieldname = 'FAKSP'.
***    ls_field-seltext_m = 'Item Billing Block'.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***
***    ls_field-col_pos = 6.
***    ls_field-fieldname = 'ABGRU'.
***    ls_field-seltext_m = 'Reason For Rejection'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 7.
***    ls_field-fieldname = 'VKORG'.
***    ls_field-seltext_m = 'Sales Org'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 8.
***    ls_field-fieldname = 'VTWEG'.
***    ls_field-seltext_m = 'Distribution Channel'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 9.
***    ls_field-fieldname = 'SPART'.
***    ls_field-seltext_m = 'Division'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 10.
***    ls_field-fieldname = 'VKBUR'.
***    ls_field-seltext_m = 'Sales Office'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
***
***    ls_field-col_pos = 11.
***    ls_field-fieldname = 'BSARK'.
***    ls_field-seltext_m = 'PO Type'.
***    ls_field-outputlen = 30.
***    APPEND ls_field TO lt_field.
***    CLEAR ls_field.
**
**
********************** Call FUnction module to display data as popup screen********
***    CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
***      EXPORTING
***        i_title               = 'Order Details'
***        i_allow_no_selection  = 'X'
***        i_screen_start_column = 10
***        i_screen_start_line   = 5
***        i_screen_end_column   = 150
***        i_screen_end_line     = 20
***        i_tabname             = 'LT_OUTPUT'
***        it_fieldcat           = lt_field
***        i_callback_program    = sy-cprog
**** IMPORTING
****       ES_SELFIELD           =
****       E_EXIT                =
***      TABLES
***        t_outtab              = lt_output
***      EXCEPTIONS
***        program_error         = 1
***        OTHERS                = 2.
***    IF sy-subrc <> 0.
**** Implement suitable error handling here
***    ENDIF.
**
**ENDFORM.
