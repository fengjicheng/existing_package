*&---------------------------------------------------------------------*
*&  INCLUDE           ZQTCN_BIL_DEL_BLK_ATO_E261_F01.
*&---------------------------------------------------------------------*
*& PROGRAM NAME: ZQTCE_BILL_DELV_BLK_AUTO
*& PROGRAM DESCRIPTION: As a CSR, I need the system to automatically
*&                      release DG billing and delivery blocks on
*&                      existing orders/subs when the DG block is
*&                      removed from the customer in order to service
*&                      our customer quicker
*& DEVELOPER: AMOHAMMED
*& CREATION DATE: 11/24/2020
*& OBJECT ID: E261
*& TRANSPORT NUMBER(S): ED2K920450
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:  ED2K926799/ED2K927301
*& REFERENCE NO: OTCM-55825
*& DEVELOPER:    Nikhilesh Palla (NPALLA)
*& DATE:         12-Apr-2022
*& DESCRIPTION:  Change "No.of days old order" field from 2 to 3 digits
*&               Initial Values for Billing and Delivery Blocks
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:
*& REFERENCE NO:
*& DEVELOPER:
*& DATE:
*& DESCRIPTION:
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*&       text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_initialization .
  CONSTANTS : lc_devid_e261 TYPE zdevid     VALUE 'E261',  " Development ID
              lc_lifsk      TYPE rvari_vnam VALUE 'LIFSK', " Delivery Block
              lc_faksk      TYPE rvari_vnam VALUE 'FAKSK', " Billing Block
              lc_old_days   TYPE rvari_vnam VALUE 'OLD_ORD_DAYS'. " To Days ++

  DATA: li_constnt TYPE zcat_constants. " Internal table

  " No.of days old orders
  p_days = c_90.

  " Fetching Delivery and Billing blocks from ZCACONSTANT table
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e261
    IMPORTING
      ex_constants = li_constnt.
  IF li_constnt IS NOT INITIAL.
    LOOP AT li_constnt ASSIGNING FIELD-SYMBOL(<fst_const>).
      CASE <fst_const>-param1.
        WHEN lc_lifsk.
          APPEND INITIAL LINE TO i_lifsk
              ASSIGNING FIELD-SYMBOL(<fst_lifsk>).
          <fst_lifsk>-sign           = <fst_const>-sign.
          <fst_lifsk>-option         = <fst_const>-opti.
          <fst_lifsk>-dlv_block_low  = <fst_const>-low.
          <fst_lifsk>-dlv_block_high = <fst_const>-high.
*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
*          " Fill select-options internal table with Delivery block
*          APPEND LINES OF i_lifsk TO s_lifsk.
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
        WHEN lc_faksk.
          APPEND INITIAL LINE TO i_faksk
              ASSIGNING FIELD-SYMBOL(<fst_faksk>).
          <fst_faksk>-sign           = <fst_const>-sign.
          <fst_faksk>-option         = <fst_const>-opti.
          <fst_faksk>-dlv_block_low  = <fst_const>-low.
          <fst_faksk>-dlv_block_high = <fst_const>-high.
*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
*          " Fill select-options internal table with Billing block
*          APPEND LINES OF i_faksk TO s_faksk.
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
        WHEN lc_old_days.
          v_old_days = <fst_const>-low.  "++ED2K926799
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
      ENDCASE.
    ENDLOOP.

*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
    " Fill select-options internal table with Delivery block
    IF i_lifsk IS NOT INITIAL.
      APPEND LINES OF i_lifsk TO s_lifsk.
    ENDIF.
    " Fill select-options internal table with Billing block
    IF i_faksk IS NOT INITIAL.
      APPEND LINES OF i_faksk TO s_faksk.
    ENDIF.
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECTION_VALIDATION
*&---------------------------------------------------------------------*
*&      text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_selection_validation .
  DATA: lv_text   TYPE char80.  "++ED2K926799 E261  OTCM-55825

  " Delivery Block validation
  IF s_lifsk IS NOT INITIAL.
    SELECT lifsp FROM tvls INTO TABLE @DATA(li_lifsp) WHERE lifsp IN @s_lifsk.
    IF sy-subrc NE 0.
      " Display "Invalid Delivery Block entered" message
      MESSAGE text-002 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

  " Billing Block validation
  IF s_faksk IS NOT INITIAL.
    SELECT faksp FROM tvfs INTO TABLE @DATA(li_faksp) WHERE faksp IN @s_faksk.
    IF sy-subrc NE 0.
      " Display "Invalid Billing Block entered" message
      MESSAGE text-003 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
  " No.of days old order - Validation
  IF p_days GT v_old_days.
    CONCATENATE 'No.of days old order is More Than'(007)
                v_old_days
                'Days'(008)
                INTO lv_text SEPARATED BY space.
      MESSAGE lv_text TYPE c_i.
      LEAVE SCREEN.
  ENDIF.
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_REMOVE_BLOCKS
*&---------------------------------------------------------------------*
*&      text
*----------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data_remove_blocks .

  DATA(r_parvw) = VALUE rjksd_parvw_range_tab(
    ( sign = c_i option = c_eq low = c_we )          " Ship-to party
    ( sign = c_i option = c_eq low = c_ag ) ).       " Sold-to party
  CONSTANTS : lc_blockb TYPE c VALUE 'B',
              lc_blockd TYPE c VALUE 'D'.
  DATA : lv_n_days_old_date TYPE sy-datum,  " N number of days old date
         lst_output         TYPE ty_output. " Output workarea
  CLEAR : lv_n_days_old_date, lst_output.
  lv_n_days_old_date = sy-datum - p_days.
*  " Fetch the orders older than N days and  are blocked at delivery or billing level
*  " Fetch the partner fucntions (Sold-to-party, Ship-to-party) for the orders
  " Fetch the Delivery and Billing block values for the partners
  SELECT a~vbeln, " Sales Document
         a~erdat, " Date on Which Record Was Created
         a~lifsk, " Delivery block (document header)
         a~faksk, " Billing block in SD document
         a~vkorg, " Sales Organization
         a~vtweg, " Distribution Channel
         a~spart, " Division
         b~posnr, " Item number of the SD document
         b~parvw, " Partner Function
         b~kunnr, " Customer Number
         c~lifsd, " Customer delivery block (sales area)
         c~faksd  " Billing block for customer (sales and distribution)
    FROM vbak AS a
    INNER JOIN vbpa AS b ON a~vbeln EQ b~vbeln
    INNER JOIN knvv AS c ON b~kunnr EQ c~kunnr
                        AND a~vkorg EQ c~vkorg
                        AND a~vtweg EQ c~vtweg
                        AND a~spart EQ c~spart
    INTO TABLE @DATA(li_final)
    WHERE a~erdat GT @lv_n_days_old_date
      AND ( a~lifsk IN @s_lifsk OR
            a~faksk IN @s_faksk )
      AND b~posnr EQ @c_header
      AND b~parvw IN @r_parvw
*      AND ( c~lifsd NOT IN @s_lifsk OR
*            c~faksd NOT IN @s_faksk )
    ORDER BY a~vbeln ASCENDING.
  IF sy-subrc EQ 0.
    LOOP AT li_final ASSIGNING FIELD-SYMBOL(<lst_final>).
*---------------Billing Blocks Removal--------------------*
      lst_output-vbeln = <lst_final>-vbeln.
      " Billing block removal only for Sold-to party
      IF ( <lst_final>-faksk IN i_faksk AND <lst_final>-faksd IS INITIAL ). " Order Billing block
        CASE <lst_final>-parvw. " Partner function
          WHEN c_ag.
            " Remove Order Billing block
            PERFORM f_call_bapi USING <lst_final>-vbeln
                                      <lst_final>-parvw
                                      lc_blockb
                                CHANGING lst_output.
            IF lst_output-msg_type IS NOT INITIAL.
              APPEND lst_output TO i_output.
            ENDIF.
            CLEAR lst_output.
        ENDCASE.
      ENDIF.
*------------------Delivery Blocls Removal-----------------*
      IF <lst_final>-lifsk IN i_lifsk AND <lst_final>-lifsd IS INITIAL. " Order Delivery block
        " Delivery block removal only when SoldTo and Shipto doesn't have delivery blocks
        CASE <lst_final>-parvw. " Partner function
          WHEN c_ag. " Sold-to party.
            "Check Ship To party delivery blocks
            READ TABLE li_final INTO DATA(lst_final) WITH KEY vbeln = <lst_final>-vbeln
                                                              parvw = c_we.
            IF sy-subrc EQ 0 AND lst_final-lifsk IN i_lifsk AND lst_final-lifsd IS INITIAL.

              PERFORM f_call_bapi USING <lst_final>-vbeln
                                        <lst_final>-parvw
                                        lc_blockd
                                  CHANGING lst_output.
              IF lst_output-msg_type IS NOT INITIAL.
                lst_output-vbeln = <lst_final>-vbeln.
                APPEND lst_output TO i_output.
              ENDIF.
              CLEAR lst_output.
            ENDIF.
          WHEN c_we. " Ship-to party.
            "Check Sold To party delivery blocks
            READ TABLE li_final INTO DATA(lst_final2) WITH KEY vbeln = <lst_final>-vbeln
                                                              parvw = c_ag.
            IF sy-subrc EQ 0 AND <lst_final>-kunnr NE lst_final2-kunnr.
              IF lst_final2-lifsk IN i_lifsk AND lst_final2-lifsd IS INITIAL.

                PERFORM f_call_bapi USING <lst_final>-vbeln
                                          <lst_final>-parvw
                                          lc_blockd
                                    CHANGING lst_output.
                IF lst_output-msg_type IS NOT INITIAL.
                  lst_output-vbeln = <lst_final>-vbeln.
                  APPEND lst_output TO i_output.
                ENDIF.
                CLEAR lst_output.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ELSE.
    lst_output-msg = text-006.
    APPEND lst_output TO i_output.
    CLEAR lst_output.
  ENDIF.
  FREE : lv_n_days_old_date, lst_output.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BAPI
*&---------------------------------------------------------------------*
*&      text
*&---------------------------------------------------------------------*
*&     -->P_VBELN  text
*&     -->P_PARVW  text
*&     <--P_OUTPUT text
*----------------------------------------------------------------------*
FORM f_call_bapi  USING    p_vbeln  TYPE vbeln_va
                           p_parvw  TYPE parvw
                           p_lv_blcok TYPE c
                  CHANGING p_output TYPE ty_output.
  CONSTANTS : lc_blockb TYPE c VALUE 'B',
              lc_blockd TYPE c VALUE 'D'.
  DATA : lst_order_headerx   TYPE bapisdh1x,
         lst_order_header_in TYPE bapisdh1,
         li_return           TYPE STANDARD TABLE OF bapiret2.
  CLEAR lst_order_headerx.
  REFRESH li_return.
  CASE p_parvw. " Partner function
    WHEN c_ag. " Sold-to party
      IF p_lv_blcok = lc_blockb.
        lst_order_header_in-bill_block = space.
        lst_order_headerx-bill_block = abap_true.
      ELSEIF p_lv_blcok = lc_blockd.
        lst_order_header_in-dlv_block = space.
        lst_order_headerx-dlv_block = abap_true.
      ENDIF.
    WHEN c_we. " Ship-to party
      lst_order_header_in-dlv_block = space.
      lst_order_headerx-dlv_block = abap_true.
  ENDCASE.
  lst_order_headerx-updateflag = 'U'.
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = p_vbeln
      order_header_in  = lst_order_header_in
      order_header_inx = lst_order_headerx
    TABLES
      return           = li_return.
  IF li_return IS NOT INITIAL.
    SORT li_return BY type ASCENDING.
    READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lst_return>)
                         WITH KEY type = c_e
                         BINARY SEARCH.
    IF sy-subrc EQ 0.
      p_output-msg_type = c_e.
      p_output-msg = <lst_return>-message.
    ELSE.
      IF p_output-msg_type IS INITIAL.
        p_output-msg_type = c_s.
      ENDIF.
      CASE p_parvw. " Partner function
        WHEN c_ag. " Sold-to party
          IF p_lv_blcok = lc_blockb.
            p_output-msg = text-004. " Billing Blocks Removed Successfully!
          ELSEIF p_lv_blcok = lc_blockd.
            p_output-msg = text-005. " Delivery Blocks Removed Successfully!
          ENDIF.
        WHEN c_we. " Ship-to party
          p_output-msg = text-005. " Delivery Blocks Removed Successfully!
      ENDCASE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      text
*----------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .
  REFRESH i_fcat.
  DATA: lv_counter TYPE sycucol. " Counter of type Integers
  CONSTANTS : lc_order    TYPE fieldname VALUE 'VBELN',
              lc_msg_type TYPE fieldname VALUE 'MSG_TYPE',
              lc_msg      TYPE fieldname VALUE 'MSG'.

  PERFORM f_buildcat USING: lv_counter lc_order    text-f01,
                            lv_counter lc_msg_type text-f02,
                            lv_counter lc_msg      text-f03.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILDCAT
*&---------------------------------------------------------------------*
*&      text
*----------------------------------------------------------------------*
*&     -->P_COL  text
*&     -->P_FLD  text
*&     -->P_TITLE  text
*----------------------------------------------------------------------*
FORM f_buildcat USING p_col   TYPE sycucol   " Horizontal Cursor Position
                      p_fld   TYPE fieldname " Field Name
                      p_title TYPE itex132.  " Text Symbol length 132
  DATA st_fcat TYPE slis_fieldcat_alv.   " Field catalog workarea
  CONSTANTS : lc_tabname TYPE tabname VALUE 'I_OUTPUT'. " Table Name
  CLEAR st_fcat.
  st_fcat-col_pos      = p_col + 1.
  st_fcat-lowercase    = abap_true.
  st_fcat-fieldname    = p_fld.
  st_fcat-tabname      = lc_tabname.
  st_fcat-seltext_l    = p_title.

  APPEND st_fcat TO i_fcat.
  FREE st_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*&      text
*----------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA : lst_layout TYPE slis_layout_alv.
  lst_layout-colwidth_optimize = abap_true.
  SORT i_output BY vbeln msg_type msg.
  DELETE ADJACENT DUPLICATES FROM i_output COMPARING ALL FIELDS.
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat
    TABLES
      t_outtab           = i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
