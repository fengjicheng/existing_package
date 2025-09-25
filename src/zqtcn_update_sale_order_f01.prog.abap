*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Program to update  sales order
*&                        Rep value
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627
*&----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCE_CREATE_SALES_ORDER_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       * Clear Variable.
*----------------------------------------------------------------------*
FORM f_clear_all.

* Clear Internal Table.
  CLEAR : i_input[],
         i_fcat[].

* Clear Global Variable.
  CLEAR : v_input.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_SALES_ORDER
*&---------------------------------------------------------------------*
*       update sales order
*----------------------------------------------------------------------*

FORM f_update_sales_order .
*Local type structure
  TYPES : BEGIN OF lty_input_sel,
            sign   TYPE char1,  " Sign of type CHAR1
            option TYPE char2,  " Option of type CHAR2
            low    TYPE char32, " Low of type CHAR30
            high   TYPE char32, " High of type CHAR30
          END OF lty_input_sel.
*Local data declarations
  DATA :  lst_input            TYPE ty_input,
          lst_alv              TYPE ty_alv,
          lst_input_sel        TYPE lty_input_sel,
          lst_order_partner    TYPE bapiparnr,      " Communications Fields: SD Document Partner: WWW
          lst_order_header_in  TYPE bapisdhd1,      " Communication Fields: Sales and Distribution Document Header
          lst_order_header_inx TYPE bapisdhd1x,     " Communication Fields: Sales and Distribution Document Header
          lst_header_delta     TYPE bapisdhd,   " BAPI Structure of VBAK with English Field Names
          lst_veda_delta       TYPE bapisdcntr, " BAPI Structure of VEDA with English Field Names
          lst_vbpa_delta       TYPE bapisdpart. " BAPI Structure of VBPA with English Field Names

  DATA : li_return       TYPE STANDARD TABLE OF bapiret2  INITIAL SIZE 0,  " Return Parameter
         li_input_tmp    TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0,
         li_input_tmp1   TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0,
         li_part_change  TYPE STANDARD TABLE OF  bapiparnrc INITIAL SIZE 0,
         lst_part_change TYPE bapiparnrc,
         lst_input_tmp   TYPE ty_input,
         lst_input_tmp1  TYPE ty_input,
         li_partners     TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,
         lst_partners    TYPE bapiparnr,
         li_orders_in    TYPE TABLE OF bapisditm INITIAL SIZE 0,
         lst_orders_in   TYPE bapisditm,
         li_orders_inx   TYPE TABLE OF bapisditmx INITIAL SIZE 0,
         lst_orders_inx  TYPE bapisditmx.


  DATA: lv_salesdocument TYPE bapivbeln-vbeln, " Sales Document
        lst_view         TYPE order_view,      " View for Mass Selection of Sales Orders
        li_order         TYPE mds_sales_key_tab.


  FIELD-SYMBOLS : <lst_order_partner> TYPE bapiparnrc. " Communications Fields: SD Document Partner: WWW
*Local constants
  CONSTANTS : lc_posnr_low TYPE vbap-posnr VALUE '000000', " Item 0
              lc_update    TYPE char1 VALUE 'U',           " Update
              lc_sucess    TYPE char25 VALUE 'Sucessfully Updated'.

* Get the value of sales document , New Sales Rep 1 and New sales Rep 2.
  LOOP AT s_input INTO lst_input_sel.
    lst_input-vbeln   =  lst_input_sel-low+0(10).
    lst_input-posnr   =  lst_input_sel-low+10(6).
    lst_input-nsrep1  =  lst_input_sel-low+16(8).
    lst_input-nsrep2  =  lst_input_sel-low+24(8).
    lst_input-flag    =  lst_input_sel-high.
    APPEND lst_input TO i_input.
    CLEAR: lst_input_sel,
           lst_input.
  ENDLOOP. " LOOP AT s_input INTO lst_input_sel

  SORT i_input BY vbeln posnr.

  li_input_tmp[] = i_input[].
  LOOP AT li_input_tmp INTO lst_input_tmp.
    IF  lst_input_tmp IS NOT INITIAL." AND sy-subrc EQ 0.
      lst_order_header_inx-updateflag = lc_update.
      v_vbeln = lst_input_tmp-vbeln.
      IF lst_input_tmp-nsrep1 IS NOT INITIAL.
        READ TABLE li_part_change ASSIGNING <lst_order_partner>
                                    WITH KEY partn_role = c_parvw_ve
                                             itm_number = lst_input_tmp-posnr.

        IF sy-subrc NE 0.
          IF lst_input_tmp-posnr IS NOT INITIAL.
            lst_part_change-document = v_vbeln.
            lst_part_change-itm_number = lst_input_tmp-posnr.
            lst_part_change-p_numb_new = lst_input_tmp-nsrep1.
            lst_part_change-partn_role = c_parvw_ve.
            lst_part_change-updateflag = lc_update.
            lst_partners-partn_role  =  c_parvw_ve.
            lst_partners-partn_numb =  lst_input_tmp-nsrep1.
            lst_partners-itm_number  = lst_input_tmp-posnr.
            APPEND lst_part_change TO li_part_change.
            CLEAR lst_order_partner.
            APPEND lst_partners TO li_partners.
            CLEAR lst_partners.
          ENDIF.
*IF header flag is set
          IF lst_input_tmp-flag IS NOT  INITIAL.
            lst_part_change-document = v_vbeln.
            lst_part_change-itm_number  = c_posnr_hdr.
            lst_part_change-p_numb_new = lst_input_tmp-nsrep1.
            lst_part_change-partn_role = c_parvw_ve.
            lst_part_change-updateflag = lc_update.
            lst_partners-partn_role  =  c_parvw_ve.
            lst_partners-partn_numb =  lst_input_tmp-nsrep1.
            APPEND lst_part_change TO li_part_change.
            CLEAR lst_order_partner.
            APPEND lst_partners TO li_partners.
            CLEAR lst_partners.
          ENDIF.
          IF lst_input_tmp-posnr IS NOT INITIAL.
            lst_orders_in-itm_number = lst_input_tmp-posnr.
            APPEND lst_orders_in TO li_orders_in.
            CLEAR lst_orders_in.
            lst_orders_inx-itm_number = lst_input_tmp-posnr.
            lst_orders_inx-updateflag = lc_update.
            APPEND lst_orders_inx TO li_orders_inx.
            CLEAR lst_orders_inx.
          ENDIF.
        ELSE. " ELSE -> IF sy-subrc NE 0
          <lst_order_partner>-p_numb_new = lst_input_tmp-nsrep1.
          UNASSIGN <lst_order_partner>.
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF.
    IF lst_input_tmp-nsrep2 IS NOT INITIAL.
      READ TABLE li_part_change ASSIGNING FIELD-SYMBOL(<lst_order_partner2>)
                                                WITH KEY partn_role = c_parvw_ze
                                                        itm_number = lst_input_tmp-posnr.
      IF sy-subrc NE 0.
        IF lst_input_tmp-posnr IS NOT INITIAL.
          lst_part_change-document = v_vbeln.
          lst_part_change-itm_number = lst_input_tmp-posnr.
          lst_part_change-p_numb_new = lst_input_tmp-nsrep2.
          lst_part_change-partn_role = c_parvw_ze.
*Update the partner functions value
          lst_part_change-updateflag = lc_update.
          lst_partners-partn_role  =  c_parvw_ze.
          lst_partners-partn_numb =  lst_input_tmp-nsrep2.
          lst_partners-itm_number  = lst_input_tmp-posnr.
          APPEND lst_part_change TO li_part_change.
          CLEAR lst_order_partner.
          APPEND lst_partners TO li_partners.
          CLEAR lst_partners.
        ENDIF.
*IF header flag is set
        IF lst_input_tmp-flag IS NOT  INITIAL.
          lst_part_change-itm_number  = c_posnr_hdr.
          lst_part_change-p_numb_new = lst_input_tmp-nsrep2.
          lst_part_change-partn_role = c_parvw_ze.
          lst_part_change-updateflag = lc_update.
          lst_partners-partn_role  =  c_parvw_ze.
          lst_partners-partn_numb =  lst_input_tmp-nsrep2.
          APPEND lst_part_change TO li_part_change.
          CLEAR lst_order_partner.
          APPEND lst_partners TO li_partners.
          CLEAR lst_partners.
        ENDIF.
        IF lst_input_tmp-posnr IS NOT INITIAL.
          lst_orders_in-itm_number = lst_input_tmp-posnr.
          APPEND lst_orders_in TO li_orders_in.
          CLEAR lst_orders_in.
          lst_orders_inx-itm_number = lst_input_tmp-posnr.
          lst_orders_inx-updateflag = lc_update.
          APPEND lst_orders_inx TO li_orders_inx.
          CLEAR lst_orders_inx.
        ENDIF.
      ELSE. " ELSE -> IF sy-subrc NE 0
        <lst_order_partner2>-p_numb_new = lst_input_tmp-nsrep2.
        UNASSIGN <lst_order_partner2>.
      ENDIF. " IF sy-subrc NE 0
    ENDIF.
    DELETE ADJACENT DUPLICATES FROM  li_orders_in COMPARING itm_number.
    DELETE ADJACENT DUPLICATES FROM  li_orders_inx COMPARING itm_number.
    lst_input_tmp1 = lst_input_tmp.
    APPEND lst_input_tmp1 TO li_input_tmp1.
    CLEAR lst_input_tmp1.
    AT END OF vbeln.

      IF li_partners IS NOT INITIAL.
        CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
          EXPORTING
            salesdocument     = v_vbeln
            order_header_in   = lst_order_header_in
            order_header_inx  = lst_order_header_inx
          TABLES
            return            = li_return
            item_in           = li_orders_in
            item_inx          = li_orders_inx
            partners          = li_partners
            partnerchanges    = li_part_change
          EXCEPTIONS
            incov_not_in_item = 1
            OTHERS            = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ELSE.
          PERFORM f_bapi_commit USING lst_input_tmp-vbeln
                                           lst_order_header_in-doc_type
                                  CHANGING i_alv.
* Display the error log,if bapi encoutered any errors
          LOOP AT li_input_tmp1 INTO lst_input_tmp1.
            READ TABLE li_return INTO DATA(lst_return) WITH KEY type = c_e.
            IF sy-subrc EQ 0.
              lst_alv-vbeln =  lst_input_tmp1-vbeln.
              lst_alv-posnr =  lst_input_tmp1-posnr.
              lst_alv-type  =  lst_return-type.
              lst_alv-message  = lst_return-message.
              APPEND lst_alv TO i_alv.
              CLEAR lst_alv.
            ELSE.
              READ TABLE li_return INTO lst_return WITH KEY type = c_s.
              IF sy-subrc EQ 0.
                lst_alv-vbeln =  lst_input_tmp1-vbeln.
                lst_alv-posnr =  lst_input_tmp1-posnr.
                lst_alv-auart =  c_doctype.
                lst_alv-type  =  c_s.
                lst_alv-message  = lc_sucess.
                APPEND lst_alv TO i_alv.
                CLEAR lst_alv.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
        CLEAR :lv_salesdocument, li_return[],li_orders_in[],li_orders_inx[],li_partners[],li_part_change[].
      ENDIF.
      REFRESH li_input_tmp1.
    ENDAT.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_RECORDS_ALV
*&---------------------------------------------------------------------*
*       Display ALV Reports
*----------------------------------------------------------------------*
FORM f_display_records_alv .
*Local data declarations
  DATA: lst_layout   TYPE slis_layout_alv.
  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_catalog .
*To display the output in ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat
      i_save             = abap_true
    TABLES
      t_outtab           = i_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
  ENDIF. " IF sy-subrc <> 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*      Populate Field Catalog
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .
*Local data declarations
*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers
*Constant for hold for alv tablename
  CONSTANTS: lc_tabname     TYPE slis_tabname VALUE 'I_ALV', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln   TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_posnr   TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_fkart   TYPE slis_fieldname VALUE 'AUART',
             lc_fld_type    TYPE slis_fieldname VALUE 'TYPE',
*             lc_fld_number  TYPE slis_fieldname VALUE 'DOCUMENT',
             lc_fld_message TYPE slis_fieldname VALUE 'MESSAGE'.
* Populate field catalog
* Invoice Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Sales doc number'(001)
                       CHANGING i_fcat.
* Sales Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Sales Item Number'(007)
                      CHANGING i_fcat.
* Salesdoc Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_fkart  lc_tabname   lv_col_pos  'Sales doc Type'(002)
                       CHANGING i_fcat.
* MessageType
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_type  lc_tabname   lv_col_pos  'Message Type'(003)
                     CHANGING i_fcat.
* Message
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_message lc_tabname   lv_col_pos  'Message'(006)
                     CHANGING i_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field catalog
*----------------------------------------------------------------------*
*                   USING      fp_field        " Field Name
*                              fp_tabname      " Table Name
*                              fp_col_pos      " Col_pos of type Integers
*                              fp_text         " Text of type CHAR50
*                     CHANGING fp_i_fcat       " Build field catalog
*----------------------------------------------------------------------*
FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.
*Locladata decalarations
  DATA: lst_fcat   TYPE slis_fieldcat_alv.
*Local constants declarations
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length
  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*      Get The constant value from ZCACONSTANT table
*----------------------------------------------------------------------*
FORM f_get_constants .
*Local constants declarations
  CONSTANTS: lc_devid  TYPE zdevid VALUE 'E199'. " Development ID
* Get the constant value from table Zcaconstant
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid = lc_devid.
  IF sy-subrc IS INITIAL.
    SORT i_constant BY devid.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_COMMIT
*&---------------------------------------------------------------------*
*       Commit Work and Refreash the buffer.
*----------------------------------------------------------------------*
*  Using    FP_VBELN " sales docuemnt
*           FP_DOC_TYPE  " Docuemnt Type
*  Changing FP_I_ALV " ALV Report
*----------------------------------------------------------------------*
FORM f_bapi_commit    USING   fp_vbeln TYPE vbeln_va" Sales Document
                              fp_doc_type TYPE auart
                     CHANGING fp_i_alv TYPE tt_alv.
*Local constants
  CONSTANTS : lc_wait       TYPE bapiwait VALUE 'X'. " Use the command `COMMIT AND WAIT`
*Local data  declarations
  DATA :  lst_return TYPE bapiret2, " Return Parameter
          lst_alv    TYPE ty_alv.
*Call the bapi to commit
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait   = lc_wait
    IMPORTING
      return = lst_return.

ENDFORM.
