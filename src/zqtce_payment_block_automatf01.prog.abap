*----------------------------------------------------------------------*
***INCLUDE ZQTCR_PAYMENT_BLOCK_AUTOMATF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_PAYMENT_BLOCK_AUTOMATF01
* PROGRAM DESCRIPTION: Process logic include for ZQTCE_PAYMENT_BLOCK_AUTO_E247
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE: 6/22/2020
* OBJECT ID: E247
* TRANSPORT NUMBER(S): ED2K918595
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization .

  REFRESH :  i_bsad,
         i_vbak,
         i_vbak_ord ,
         i_vbfa,
         i_vbfa_ord ,
         i_return,
         i_final,
         i_fcat,
         i_attach,
         i_attachment,
         i_packing_list,
         i_receivers  .
  CLEAR:st_fcat,
        st_final,
        st_vbfa,
        st_vbak,
        st_bsad ,
        st_return,
        st_order_headerx,
        st_interface .



  s_blart-option = 'EQ'.
  s_blart-sign = 'I'.
  s_blart-low = 'RV'.
  APPEND s_blart.
  CLEAR s_blart.

  s_auart-option = 'EQ'.
  s_auart-sign = 'I'.
  s_auart-low = 'ZSUB'.
  APPEND s_auart.
  CLEAR s_auart.

  s_auart-option = 'EQ'.
  s_auart-sign = 'I'.
  s_auart-low = 'ZREW'.
  APPEND s_auart.
  CLEAR s_auart.

*  s_auart2-option = 'EQ'.
*  s_auart2-sign = 'I'.
*  s_auart2-low = 'ZOR'.
*  APPEND s_auart2.
*  CLEAR s_auart2.

  s_auart2-option = 'EQ'.
  s_auart2-sign = 'I'.
  s_auart2-low = 'ZSRO'.
  APPEND s_auart2.
  CLEAR s_auart2.

  s_lifsk-option = 'EQ'.
  s_lifsk-sign = 'I'.
  s_lifsk-low = 54.
  APPEND s_lifsk.
  CLEAR s_lifsk.

  s_augru-option = 'EQ'.
  s_augru-sign = 'I'.
  s_augru-low = 'U01'.
  APPEND s_augru.
  CLEAR s_augru.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECTION_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_selection_validation .
  DATA : lv_auart TYPE auart,
         lv_lifsk TYPE lifsp,
         lv_augru TYPE augru.
  IF s_auart IS NOT INITIAL.
    SELECT SINGLE auart FROM tvak INTO lv_auart WHERE auart IN s_auart.
    IF sy-subrc NE 0.
      MESSAGE text-s01 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

  IF s_auart2 IS NOT INITIAL.
    SELECT SINGLE auart FROM tvak INTO lv_auart WHERE auart IN s_auart2.
    IF sy-subrc NE 0.
      MESSAGE text-s02 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

  IF s_lifsk IS NOT INITIAL.
    SELECT SINGLE lifsp FROM tvls INTO lv_lifsk WHERE lifsp IN s_lifsk.
    IF sy-subrc NE 0.
      MESSAGE text-s03 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

  IF s_augru IS NOT INITIAL.
    SELECT SINGLE augru INTO lv_augru FROM tvau WHERE augru IN s_augru.
    IF sy-subrc NE 0.
      MESSAGE text-s04 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
*--*Get BSAD entries (Cleared Accounting Documents)
  SELECT bukrs,    "Company code
            kunnr, "Customer
            umsks, "Special G/L Transaction Type
            umskz, "Special G/L Indicator
            augdt, "Clearing Date
            augbl, "Document Number of the Clearing Document
            zuonr, "Assignment Number
            gjahr, "Fiscal Year
            belnr, "Accounting Document Number
*            buzei, "Number of Line Item Within Accounting Document
            blart "Document Type
             FROM bsad INTO TABLE @i_bsad WHERE augdt IN @s_augdt
                                                  AND blart IN @s_blart.
*--*Get Reference Contract info ex: ZSUB/ZREW
  IF sy-subrc EQ 0 AND i_bsad IS NOT INITIAL.
    SORT i_bsad BY belnr.
*    DELETE ADJACENT DUPLICATES FROM i_bsad COMPARING belnr.
    SELECT    vbelv, "Preceding sales and distribution document
              posnv,  "Preceding item of an SD document
              vbeln, "Subsequent sales and distribution document
              posnn, "Subsequent item of an SD document
              vbtyp_n "Document category of subsequent document
              FROM vbfa INTO TABLE @i_vbfa FOR ALL ENTRIES IN  @i_bsad
                                            WHERE vbeln = @i_bsad-belnr "Pass invoice as subsequent
                                             AND vbtyp_n = @c_m "Subsequent doc category
                                             AND vbtyp_v = @c_g "Preceeding doc category
                                             AND stufe = 00. "Level
*--*Get Contract details
    IF sy-subrc EQ 0 AND i_vbfa IS NOT INITIAL.
      SORT i_vbfa BY vbelv.
      DELETE ADJACENT DUPLICATES FROM i_vbfa COMPARING vbelv.
      SELECT vbeln, "Sales Document
             auart, "Sales Document Type
             kunnr, "Sold-to party
             lifsk, "Delivery block (document header)
             augru  "Order reason (reason for the business transaction)
              FROM vbak INTO TABLE @i_vbak FOR ALL ENTRIES IN @i_vbfa
                                            WHERE vbeln = @i_vbfa-vbelv
                                             AND auart IN @s_auart
                                             AND lifsk IN @s_lifsk
                                             AND augru IN @s_augru.
*--*Get Release orders based on Contracts
      IF sy-subrc EQ 0 AND i_vbak IS NOT INITIAL.
        SORT  i_vbak BY vbeln.
        SELECT vbelv, "Preceding sales and distribution document
               posnv, "Preceding item of an SD document
               vbeln, "Subsequent sales and distribution document
               posnn, "Subsequent item of an SD document
               vbtyp_n "Document category of subsequent document
               FROM vbfa INTO TABLE @i_vbfa_ord FOR ALL ENTRIES IN  @i_vbak
                                             WHERE vbelv = @i_vbak-vbeln "Pass Contract as preceeding
                                              AND vbtyp_n = @c_c "Document category of subsequent document
                                              AND vbtyp_v = @c_g "Document category of preceding SD document
                                              AND stufe = 00. "Level
*--*Get Order details
        IF sy-subrc EQ 0 AND i_vbfa_ord IS NOT INITIAL.
          SORT i_vbfa_ord BY vbeln.
          DELETE ADJACENT DUPLICATES FROM i_vbfa_ord COMPARING vbeln.
          SELECT vbeln, "Sales Document
                 auart, "Sales Document Type
                 kunnr, "Sold-to party
                 lifsk, "Delivery block (document header)
                 augru  "Order reason (reason for the business transaction)
                  FROM vbak INTO TABLE @i_vbak_ord FOR ALL ENTRIES IN @i_vbfa_ord
                                                WHERE vbeln = @i_vbfa_ord-vbeln "subsequent
                                                 AND auart IN @s_auart2
                                                 AND lifsk IN @s_lifsk
                                                 AND augru IN @s_augru.
          IF sy-subrc EQ 0.
            SORT i_vbak_ord BY vbeln.
            SORT i_vbfa_ord BY vbelv.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_data .
  DATA :  lst_final         TYPE ty_final.
*--*Loop Contracts info
  LOOP AT i_vbak INTO st_vbak.
    st_final-vbelnc = st_vbak-vbeln.
    st_final-auart = st_vbak-auart.
*--*Read Invoice info
    READ TABLE i_vbfa INTO st_vbfa WITH KEY vbelv = st_vbak-vbeln
                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_final-vbelni = st_vbfa-vbeln. "Invoice
    ENDIF.
*--*Read Order info
    lst_final = st_final.
    LOOP AT i_vbfa_ord  INTO DATA(lst_vbfa_ord) WHERE vbelv = st_vbak-vbeln.
      st_final = lst_final.
      READ TABLE i_vbak_ord INTO DATA(lst_vbak_ord) WITH KEY vbeln = lst_vbfa_ord-vbeln
                                                        BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_final-vbelno = lst_vbak_ord-vbeln.
        st_final-auart2 =  lst_vbak_ord-auart.
      ENDIF.
*Build final Itab
      APPEND st_final TO i_final.
      CLEAR st_final.
    ENDLOOP.
*Build final Itab
    IF st_final IS NOT INITIAL.
      APPEND st_final TO i_final.
      CLEAR st_final.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .
  REFRESH i_fcat.
  DATA: lv_counter TYPE sycucol. " Counter of type Integers
  CONSTANTS : lc_contract      TYPE fieldname VALUE 'VBELNC',
              lc_contract_type TYPE fieldname VALUE 'AUART',
              lc_order         TYPE fieldname VALUE 'VBELNO',
              lc_order_type    TYPE fieldname VALUE 'AUART2',
              lc_invoice       TYPE fieldname VALUE 'VBELNI',
              lc_msg_type      TYPE fieldname VALUE 'MSG_TYPE',
              lc_message       TYPE fieldname VALUE 'MESSAGE'.

  PERFORM f_buildcat USING:
            lv_counter lc_contract       text-f01,
            lv_counter lc_contract_type text-f02,
            lv_counter lc_order       text-f03,
            lv_counter lc_order_type  text-f04,
            lv_counter lc_invoice     text-f05,
            lv_counter lc_msg_type    text-f06,
            lv_counter lc_message     text-f07.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA : lst_layout TYPE slis_layout_alv.
  lst_layout-colwidth_optimize = abap_true.
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat
    TABLES
      t_outtab           = i_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email .
  DATA: lst_xdocdata LIKE sodocchgi1,
        lv_xcnt      TYPE i,
        lv_file_name TYPE char100,
        lst_usr21    TYPE usr21,
        lst_adr6     TYPE adr6.

  CONSTANTS : lc_con_tab  TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
              lc_con_cret TYPE c VALUE cl_abap_char_utilities=>cr_lf.
  REFRESH i_attach.
  CONCATENATE text-f01  text-f02  text-f03 text-f04 text-f05
              text-f06  text-f07
      INTO i_attach SEPARATED BY lc_con_tab.

  CONCATENATE lc_con_cret i_attach INTO i_attach.
  APPEND  i_attach.

  LOOP AT i_final INTO st_final.
    CONCATENATE  st_final-vbelnc st_final-auart  st_final-vbelno st_final-auart2 st_final-vbelni
                 st_final-msg_type st_final-message
             INTO i_attach SEPARATED BY lc_con_tab.
    CONCATENATE lc_con_cret i_attach  INTO i_attach.
    APPEND  i_attach.
  ENDLOOP.


*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
*  CONCATENATE text-005 sy-datum INTO lst_xdocdata-obj_name SEPARATED BY '_'.
  lst_xdocdata-obj_name   = text-005.
*  IF sy-sysid EQ c_ep1.
**    CONCATENATE text-006 sy-datum sy-uzeit INTO lv_file_name  SEPARATED BY '_'.
*    lv_file_name =
*  ELSE.
  lv_file_name = text-006.
*  ENDIF.
  lst_xdocdata-obj_descr  = lv_file_name.
  CLEAR : i_attachment,lv_file_name.  REFRESH i_attachment.
  i_attachment[] = i_attach[].

**- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num = 0.
  i_packing_list-body_start = 1.
*  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw.
  APPEND i_packing_list.

*- Create attachment notification
  i_packing_list-transf_bin = abap_true.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 1.
  i_packing_list-body_start = 1.

  DESCRIBE TABLE i_attachment LINES i_packing_list-body_num.
  CONCATENATE text-005 sy-datum '.xlsx'  INTO lv_file_name.
  i_packing_list-doc_type   =  c_xls.
  i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
  i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
  i_packing_list-doc_size   =  i_packing_list-body_num * 255.
  APPEND i_packing_list.



  LOOP AT s_email.
    CLEAR i_receivers.
    i_receivers-receiver = s_email-low.
    i_receivers-rec_type = c_u.
    i_receivers-com_type = c_int.
    i_receivers-notif_del = abap_true.
    i_receivers-notif_ndel = abap_true.
    APPEND i_receivers.
  ENDLOOP.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_true
      commit_work                = abap_true
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
*     contents_txt               = i_message
      receivers                  = i_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc NE 0.
*    MESSAGE text-120 TYPE c_i.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_COUNTER  text
*      -->P_LC_CONTRACT  text
*      -->P_TEXT_F01  text
*----------------------------------------------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  CONSTANTS : lc_tabname TYPE tabname   VALUE 'I_FINAL'. " Table Name
  st_fcat-col_pos      = fp_col + 1.
  st_fcat-lowercase    = abap_true.
  st_fcat-fieldname    = fp_fld.
  st_fcat-tabname      = lc_tabname.
  st_fcat-seltext_l    = fp_title.

  APPEND st_fcat TO i_fcat.
  CLEAR st_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REMOVE_BLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_remove_block .
  DATA : lv_tabix TYPE sy-tabix.
  LOOP AT i_final INTO st_final.
    lv_tabix = sy-tabix.
*--*Remove Block from Contract
    PERFORM f_call_bapi USING st_final-vbelnc
                        CHANGING st_final.
    IF st_final-vbelno IS NOT INITIAL.
*--*Remove block from Order
      PERFORM f_call_bapi USING st_final-vbelno
                          CHANGING st_final.
    ENDIF.
*--*Update Log
    IF st_final-msg_type IS INITIAL.
      st_final-msg_type = c_s.
      st_final-message = text-007.
    ENDIF.
    MODIFY i_final FROM st_final INDEX lv_tabix TRANSPORTING msg_type message.
    CLEAR : st_final.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_FINAL  text
*----------------------------------------------------------------------*
FORM f_call_bapi     USING fp_vbeln TYPE vbeln
                     CHANGING fp_st_final TYPE ty_final.
  st_order_headerx-dlv_block = abap_true.
  st_order_headerx-updateflag = 'U'.
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = fp_vbeln
*     ORDER_HEADER_IN  =
      order_header_inx = st_order_headerx
    TABLES
      return           = i_return.
  READ TABLE i_return INTO st_return WITH KEY type = c_e.
  IF sy-subrc EQ 0.
    fp_st_final-msg_type = c_e.
    fp_st_final-message = st_return-message.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_INTERFACE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_interface .
  st_interface-devid = c_devid.
  st_interface-lrdat = sy-datum.
  st_interface-lrtime = sy-uzeit.

  MODIFY zcainterface FROM st_interface.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_date .
*--*date default
  SELECT SINGLE * FROM zcainterface INTO st_interface  WHERE devid = c_devid.
  IF sy-subrc EQ 0.
    REFRESH s_augdt.
    s_augdt-option = 'BT'.
    s_augdt-sign = 'I'.
    s_augdt-low = st_interface-lrdat - 1.
    IF st_interface-lrdat NE sy-datum.
      st_interface-lrdat =  sy-datum.
    ENDIF.
    s_augdt-high = st_interface-lrdat.
    APPEND s_augdt.
    CLEAR s_augdt.
  ENDIF.
ENDFORM.
