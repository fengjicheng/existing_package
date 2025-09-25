*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_CMR_UPLD_CONSORTIUM_SUB
* PROGRAM DESCRIPTION  : Credit Memo Request Upload Consortium
* DEVELOPER            : Prabhu (PTUFARAM)
* CREATION DATE        : 05/21/2018
* OBJECT ID            : QTC_E101
* TRANSPORT NUMBER(S)  : ED2K912156
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS_01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
TYPE-POOLS sscr .
FORM f_screen_dynamics_01 .
*--*When User selects orders uplaod
  IF rb_ucmr = c_x AND rb_dcmr NE c_x.
    LOOP AT SCREEN.
      IF screen-group1 = c_m1.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m3.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF rb_bg_m = c_x AND screen-group1 = c_m6..
        screen-required = 2.
        MODIFY SCREEN.
      ENDIF.
      IF rb_fg_m = c_x AND screen-group1 = c_m6..
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF ( screen-group1 = c_m4 OR screen-group1 = c_m5 OR
          screen-group1 = c_m7 OR screen-group1 = c_m8 OR
        screen-group1 = c_m9 OR screen-group1 = c_m10 OR screen-group1 = c_m11 ).
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
*--*When user selects download information
  IF rb_dcmr EQ c_x AND rb_ucmr NE c_x.
    LOOP AT SCREEN.
      IF screen-group1 = c_m4.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m5.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m7.
        screen-required = 2.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
*--*When User selects download CMR and either forground of background
    IF rb_dcmr EQ c_x AND  ( rb_sel_m EQ c_x OR rb_upd_m =  c_x ).
      LOOP AT SCREEN.
        IF screen-group1 = c_m7.
          screen-input = screen-active = screen-output = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = c_m8.
          screen-input = screen-active = screen-output = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = c_m9.
          screen-input = screen-active = screen-output = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = c_m10.
          screen-input = screen-active = screen-output = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = c_m11.
          screen-input = screen-active = screen-output = 1.
          MODIFY SCREEN.
        ENDIF.
*--*When user selects background
        IF rb_upd_m =  c_x.
          IF ( screen-group1 = c_m2 OR screen-group1 = c_m12 OR
                screen-group1 = c_m13 ).
            screen-input = screen-active = screen-output = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = c_m6.
            screen-input = screen-active = screen-output = 1.
            screen-required = 2.
            MODIFY SCREEN.
          ENDIF.
        ELSE.
          IF ( screen-group1 = c_m2 OR
             screen-group1 = c_m6  OR screen-group1 = c_m12 OR
                screen-group1 = c_m13 ).
            screen-input = screen-active = screen-output = 0.
            MODIFY SCREEN.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISP_ALV_RPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_disp_alv_rpt .
  PERFORM f_build_fcat.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = c_alv_pf_status
      is_layout                = st_layout
      it_fieldcat              = i_fcat_out
    TABLES
      t_outtab                 = i_final_crme_crt
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE text-091 TYPE c_i.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
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
  REFRESH i_fcat_out.

  DATA: lv_counter TYPE sycucol. " Counter of type Integers
  CONSTANTS : lc_customer TYPE fieldname VALUE 'CUSTOMER',
              lc_parvw    TYPE fieldname VALUE 'PARVW',
              lc_partner  TYPE fieldname VALUE 'PARTNER',
              lc_vkorg    TYPE fieldname VALUE 'VKORG',
              lc_vtweg    TYPE fieldname VALUE 'VTWEG',
              lc_spart    TYPE fieldname VALUE 'SPART',
              lc_auart    TYPE fieldname VALUE 'AUART',
              lc_xblnr    TYPE fieldname VALUE 'XBLNR',
              lc_vbtyp    TYPE fieldname VALUE 'VBTYP',
              lc_zlsch    TYPE fieldname VALUE 'ZLSCH',
              lc_augru    TYPE fieldname VALUE 'AUGRU',
              lc_vbeln    TYPE fieldname VALUE 'VBELN',
              lc_posnr    TYPE fieldname VALUE 'POSNR',
              lc_matnr    TYPE fieldname VALUE 'MATNR',
              lc_zmeng    TYPE fieldname VALUE 'ZMENG',
              lc_text     TYPE fieldname  VALUE 'TEXT',
              lc_kbetr1   TYPE fieldname VALUE 'KBETR1',
              lc_kbetr2   TYPE fieldname VALUE 'KBETR2',
              lc_kbetr3   TYPE fieldname VALUE 'KBETR3',
              lc_discount TYPE fieldname VALUE 'DISCOUNT',
              lc_disc_per TYPE fieldname VALUE 'DISC_PER',
              lc_vgbel    TYPE fieldname VALUE  'VGBEL',
              lc_kdkg3    TYPE fieldname VALUE 'KDKG3',
              lc_vkbur    TYPE fieldname VALUE 'VKBUR',
              lc_bstnk    TYPE fieldname VALUE 'BSTNK',
              lc_ihrez_e  TYPE fieldname VALUE 'IHREZ_E',
              lc_posex_e  TYPE fieldname VALUE 'POSEX_E',
              lc_bsark    TYPE fieldname VALUE 'BSARK'.
  PERFORM f_buildcat USING:
            lv_counter lc_customer  text-h01    , "item number
            lv_counter lc_parvw     text-011    ,
            lv_counter lc_partner   text-h02    ,
            lv_counter lc_vkorg     text-025    ,
            lv_counter lc_vtweg     text-026    , "Dist. channel
            lv_counter lc_spart     text-027    , "division
            lv_counter lc_auart     text-023    , "document type
            lv_counter lc_xblnr     text-060    ,
            lv_counter lc_vbtyp     text-064,      "Ref Doc category
            lv_counter lc_zlsch     text-061    ,
            lv_counter lc_augru     text-051    ,
            lv_counter lc_vbeln     text-065    , "'Invoice Number',
            lv_counter lc_posnr     text-066,   "Item Number
            lv_counter lc_matnr     text-h04    ,
            lv_counter lc_zmeng     text-014    , "target quantity
            lv_counter lc_text      text-032    , "object name
            lv_counter lc_kbetr1    text-067    , "Access Fees
            lv_counter lc_kbetr2    text-068,     "Content fees
            lv_counter lc_kbetr3    text-069,   "'Hosting fees',
            lv_counter lc_discount  text-093,   "Discount
            lv_counter lc_disc_per  text-094,   "Discount percentage
            lv_counter lc_vgbel     text-076,   "Reference
            lv_counter lc_kdkg3     text-012    ,
            lv_counter lc_vkbur     text-063    ,
            lv_counter lc_bstnk     text-024    , "purchase document number
            lv_counter lc_ihrez_e   text-077,   "'Snumber (ship to your reference)
            lv_counter lc_posex_e   text-078,   "Snumber (ship to your reference) item number
            lv_counter lc_bsark     text-079.   "PO Type'.
ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------
*       text
**-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  CONSTANTS : lc_tabname TYPE tabname   VALUE 'I_OUTPUT_X', " Table Name
              lc_zmeng   TYPE fieldname VALUE 'ZMENG',
              lc_matnr   TYPE fieldname VALUE 'MATNR'.
  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname.
  st_fcat_out-seltext_m    = fp_title.
  IF fp_fld = lc_matnr.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  IF fp_fld = lc_zmeng.
    st_fcat_out-decimals_out = 0.
  ENDIF.
  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

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
  DATA : lc_posnr TYPE posnr  VALUE '000000'. " Item number of the SD document
*--*Below Subroutine is used to get Constants
  PERFORM f_get_constants.
*--**Below Subroutine is used to validate input customer PO
  PERFORM f_check_po_entered.
*&---------------------------------------------------------------------*
*   Fetch Sale data from VBAK,VBAP,VBKD,VBPA and KONV
*----------------------------------------------------------------------*
*--*Get the data from Sales document header VBAK
  SELECT  a~vbeln   "Sales doc
          a~erdat   "Created date
          a~vbtyp   "Sales doc category
          a~auart   "Sales doc type
          a~augru   "Reason for rejection
          a~vkorg   "Sales Org
          a~vtweg   "Distribution channel
          a~spart   "Division
          a~vkbur   "Sales office
          a~kunnr   "Customer
          a~knumv   "Condition number
          b~bstkd   "Customer PO
       FROM vbak AS a INNER JOIN vbkd AS b
                       ON a~vbeln = b~vbeln
                       INTO TABLE i_vbak
                  WHERE "vbeln IN s_cnt_no -
**When member is entered on selection it should fecth corresponding ZSUB too
                        a~auart IN s_auart
                  AND   b~bstkd IN s_po
                  AND   b~posnr EQ '000000'.
  IF sy-subrc EQ 0 AND i_vbak[] IS NOT INITIAL.
    SORT i_vbak BY vbeln.
    IF s_cnt_no IS NOT INITIAL.
      LOOP AT i_vbak INTO st_vbak.
        IF st_vbak-auart = c_zmbr AND st_vbak-vbeln NOT IN s_cnt_no.
          DELETE i_vbak INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ENDIF.
*--*Get the Sales document item details from VBAP
    SELECT vbeln  "Sales doc
           posnr  "Item
           matnr  "Material
           matkl  "Material group
           zmeng  "Target Qty
           vgbel  "Refrence doc num
           vgpos  "Reference doc Item
        FROM vbap INTO TABLE i_vbap
                  FOR ALL ENTRIES IN i_vbak
                  WHERE vbeln = i_vbak-vbeln.
    IF sy-subrc EQ 0.
      SORT i_vbap BY vbeln posnr.
    ENDIF.
    IF sy-subrc EQ 0 AND i_vbap[] IS NOT INITIAL.
*--*Get the sales document business data from VBKD
      SELECT vbeln  "Sales doc
             posnr  "Item
             zlsch  "Payment method
             bsark  "PO Type
             ihrez_e"Your reference
             posex_e"PO Item
             kdkg3  "Customer condition group3
          FROM vbkd INTO TABLE i_vbkd
                    FOR ALL ENTRIES IN i_vbap
                    WHERE vbeln = i_vbap-vbeln
                    AND posnr = i_vbap-posnr.
      IF sy-subrc EQ 0.
        SORT i_vbkd BY vbeln posnr.
      ENDIF.
*--*Get the sales document partner data from VBPA
      SELECT vbeln  "Sales doc
             posnr  "Item
             parvw  "Partner function
             kunnr  "Partner
          FROM vbpa INTO TABLE i_vbpa
                    FOR ALL ENTRIES IN i_vbap
                    WHERE  vbeln = i_vbap-vbeln
                    AND ( posnr = i_vbap-posnr OR posnr = lc_posnr )
                    AND parvw IN ( c_pf_ag,c_pf_we ).
*                    AND kunnr IN s_shp_to.
      IF sy-subrc EQ 0.
        SORT i_vbpa BY vbeln posnr parvw.
      ENDIF.
    ENDIF.
*--*Get Pricing data from KONV table
    SELECT knumv  "Condition record number
           kposn  "Condition Item
           stunr  "Step number
           zaehk  "Condition counter
           kschl  "Condition Type
           kbetr  "Condition Price
           kwert  "Condition value
       FROM konv INTO TABLE i_konv
                 FOR ALL ENTRIES IN i_vbak
                 WHERE knumv = i_vbak-knumv.
    IF sy-subrc EQ 0.
      SORT i_konv BY knumv kposn kschl.
    ENDIF.
  ENDIF.
*&---------------------------------------------------------------------*
* Fetch Sales billing data from VBRK&VBRP and Partners from VBPA
*----------------------------------------------------------------------*
  IF i_vbap IS NOT INITIAL.
    SELECT a~vbeln, " Billing Document
           a~erdat, " Created date
           a~vbtyp, "Document category
           a~zlsch, "Payment Method
           a~xblnr, "Reference document
           b~posnr, " Sales Document Item
           b~matnr, " Material Number
           b~fkimg, "Invice Qty
           b~pstyv, "Sales document item category
           b~pospa, "Item number in the partner segment
           b~vgbel, "Document number of the reference document
           b~vgpos "Item number of the reference item
                 INTO TABLE @i_vbrk
                     FROM vbrk AS a INNER JOIN vbrp AS b
                     ON (  a~vbeln EQ b~vbeln )
                     FOR ALL ENTRIES IN @i_vbap
                     WHERE a~vbeln IN @s_rf_inv
                     AND   a~erdat IN @s_inv_dt
                     AND   b~vgbel = @i_vbap-vbeln
                     AND   b~vgpos = @i_vbap-posnr
                     AND   a~vbtyp = @c_m
                     AND   a~rfbsk NE @c_e
                     AND a~fksto = ' '.
    IF sy-subrc EQ 0.
      SORT i_vbrk BY vbeln posnr matnr.
*--*Below Subroutine is used to build output internal table based on all
*--*Individual internal tables data fetched above
      PERFORM f_move_inv_to_final_alv.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVE_INV_TO_FINAL_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBRK  text
*----------------------------------------------------------------------*
FORM f_move_inv_to_final_alv.
  DATA : lst_vbrk TYPE ty_vbrk.
  DELETE ADJACENT DUPLICATES FROM i_vbrk COMPARING vbeln posnr matnr.
  CLEAR: st_cre_cred_memo.
  LOOP AT i_vbrk INTO st_vbrk.
*&---------------------------------------------------------------------*
*-Below subroutine is used Map billing data header for Sold to party
*----------------------------------------------------------------------*
    lst_vbrk = st_vbrk.
    AT NEW vbeln.
      st_vbrk = lst_vbrk.
      PERFORM f_map_header.
    ENDAT.
*--*Check if Material already placed into final
    READ TABLE i_final_crme_crt INTO st_cre_cred_memo TRANSPORTING NO FIELDS
                                                      WITH KEY vbeln = st_vbrk-vbeln
                                                               matnr = st_vbrk-matnr.
    IF sy-subrc NE 0.
*&---------------------------------------------------------------------*
*-Below subroutine is used Map ZMBR data header
*----------------------------------------------------------------------*
      PERFORM f_map_item_first.
*&---------------------------------------------------------------------*
*-Below subroutine is used ZMBR Item data
*----------------------------------------------------------------------*
      PERFORM f_map_items.
    ENDIF.
  ENDLOOP. " LOOP AT fp_i_vbrk INTO DATA(lst_vbrk)
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_WITH_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_with_excel .
  DATA : lv_name TYPE char100.
*-  Populate table with detaisl to be entered into .xls file
  PERFORM build_xls_data .

*- Populate message body text
  REFRESH i_message.
  st_imessage = text-101.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  IF sy-sysid = c_ep1.
    CONCATENATE text-107 sy-datum sy-uzeit  INTO lv_name SEPARATED BY '_'.
  ELSE.
    CONCATENATE text-107 sy-datum sy-uzeit sy-sysid INTO lv_name SEPARATED BY '_'.
  ENDIF.
  st_imessage = lv_name.
  CONCATENATE st_imessage text-103 INTO st_imessage SEPARATED BY space.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  st_imessage = text-104.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
*- Send file by email as .xls speadsheet
  PERFORM send_email_with_xls USING lv_name.
ENDFORM.
************************************************************************
*      Form  BUILD_XLS_DATA
************************************************************************
FORM build_xls_data .
  TYPES: BEGIN OF lty_text,
           xmlline(25000) TYPE c,
         END OF lty_text.
  DATA : li_text    TYPE TABLE OF  lty_text,
         lst_text   TYPE lty_text,
         cell       TYPE string,
         cell1      TYPE string,
         cell4      TYPE string,
         endcell    TYPE string,
         li_header  TYPE TABLE OF string,
         lst_header TYPE string.
  DATA :lv_targ_qty(17)    TYPE c,
        lv_kbetr1(15)      TYPE c,
        lv_kbetr2(15)      TYPE c,
        lv_vkbur(5)        TYPE c,
        lv_kbetr3(15)      TYPE c,
        lv_discount(15)    TYPE c,
        lv_disc_per(15)    TYPE c,
        lv_text            TYPE string,
        lv_xstring         TYPE xstring,
        lst_final_crme_crt LIKE LINE OF i_final_crme_crt,
        li_contents_hex    TYPE STANDARD TABLE OF solix WITH HEADER LINE.
  REFRESH : li_text.

  APPEND :'<?xml version="1.0"?>' TO li_text,
          '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' TO li_text,
          'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'       TO li_text,
* Style
          '<Styles>' TO li_text,
          '<Style ss:ID="1">' TO li_text,
          '<Font ss:Size="10" ss:Bold="0"/>' TO li_text,
          '<Borders>' TO li_text,
          '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'   TO li_text,
          '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'  TO li_text,
          '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'    TO li_text,
          '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' TO li_text,
          '</Borders>' TO li_text,
          '</Style>' TO li_text,
          '<Style ss:ID="4">' TO li_text,
          '<Font ss:Size="10" ss:Bold="0"/>' TO li_text,
          '<NumberFormat ss:Format="_(&quot;$&quot;* #,##0.00_);_(&quot;$&quot;* \(#,##0.00\);_(&quot;$&quot;* &quot;-&quot;??_);_(@_)" />' TO li_text,
          '<Borders>' TO li_text,
          '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'   TO li_text,
          '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'  TO li_text,
          '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'    TO li_text,
          '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' TO li_text,
          '</Borders>' TO li_text,
          '</Style>' TO li_text,
          '<Style ss:ID="2">' TO li_text,
          '<Alignment ss:Vertical="Center" ss:Horizontal="Center" ss:WrapText="1"/>' TO li_text,
          '<Font ss:Size="10" ss:Bold="1" />' TO li_text,
          '<Borders>' TO li_text,
          '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'   TO li_text,
          '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'  TO li_text,
          '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'    TO li_text,
          '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' TO li_text,
          '</Borders>' TO li_text,
          '<Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>' TO li_text,
          '</Style>' TO li_text,
          '</Styles>' TO li_text.

* End of Style
  APPEND:' <Worksheet ss:Name="CMR Download">' TO li_text,
          '<Head> brother int </Head>' TO li_text,
          '<Table>' TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="100" />'    TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="100" />'    TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
          '<Column ss:AutoFitWidth="1" ss:Width="60" />'     TO li_text,
           '<Column ss:AutoFitWidth="1" ss:Width="60" />'    TO li_text.
  APPEND  '<Row>' TO li_text.
  cell    = '<Cell ss:StyleID="2"><Data ss:Type="String" >'.
  cell1   = '<Cell ss:StyleID="1"><Data ss:Type="String" >'.
  cell4   = '<Cell ss:StyleID="1"><Data ss:Type="Number">'.
  endcell = '</Data></Cell>'.


  REFRESH : i_contents_hex,i_contents_bin.

  CONCATENATE text-009     text-011   text-010  text-025 text-026 text-027
               text-023    text-054   text-064  text-061 text-051 text-053
               text-066    text-h04   text-014  text-032
               text-067    text-068   text-069  text-093 text-094 text-060
               text-s06    text-063   text-042
               text-s07    text-s08   text-058
  INTO lst_header SEPARATED BY cl_abap_char_utilities=>newline.
  SPLIT lst_header AT cl_abap_char_utilities=>newline INTO TABLE li_header.
  CLEAR lst_header.
  LOOP AT li_header INTO lst_header.
    CONCATENATE cell1 lst_header endcell INTO lst_text.
    APPEND lst_text TO li_text.
    CLEAR : lst_text.
  ENDLOOP.
  APPEND '</Row>' TO li_text.

  LOOP AT i_final_crme_crt INTO lst_final_crme_crt.
    CLEAR: lv_targ_qty,lv_kbetr1,lv_kbetr2,lv_kbetr3,lv_vkbur.
    lv_targ_qty = lst_final_crme_crt-zmeng.
    lv_kbetr1   = lst_final_crme_crt-kbetr1.
    lv_kbetr2   = lst_final_crme_crt-kbetr2.
    lv_kbetr3   = lst_final_crme_crt-kbetr3.
    lv_discount = lst_final_crme_crt-discount.
    lv_disc_per = lst_final_crme_crt-disc_per.
    CONDENSE : lv_kbetr1,lv_kbetr2,lv_kbetr3,lv_discount,lv_disc_per.
    CONDENSE lv_targ_qty .
    APPEND '<Row>' TO li_text.
*  Customer
    CONCATENATE cell1 lst_final_crme_crt-customer endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
*   Partner Function
    CONCATENATE cell1 lst_final_crme_crt-parvw endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
*  Partner
    CONCATENATE cell1 lst_final_crme_crt-partner endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Sales Org
    CONCATENATE cell1 lst_final_crme_crt-vkorg endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Dis channel
    CONCATENATE cell1 lst_final_crme_crt-vtweg endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* division
    CONCATENATE cell1 lst_final_crme_crt-spart endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Doc type
    CONCATENATE cell1 lst_final_crme_crt-auart endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* ref doc
    CONCATENATE cell1 lst_final_crme_crt-xblnr endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Doc cat
    CONCATENATE cell1 lst_final_crme_crt-vbtyp endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Payment method
    CONCATENATE cell1 lst_final_crme_crt-zlsch endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
*Reason
    CONCATENATE cell1 lst_final_crme_crt-augru endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Billing doc
    CONCATENATE cell1 lst_final_crme_crt-vbeln endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Item
    CONCATENATE cell1 lst_final_crme_crt-posnr endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Material
    CONCATENATE cell1 lst_final_crme_crt-matnr endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Quantity
    CONCATENATE cell4 lv_targ_qty endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Text
    CONCATENATE cell1 lst_final_crme_crt-text endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Price1
    CONCATENATE cell1 lv_kbetr1 endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Price 2
    CONCATENATE cell1 lv_kbetr2 endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Price 3
    CONCATENATE cell1 lv_kbetr3 endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Discount
    CONCATENATE cell1 lv_discount endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Discount Percentage
    CONCATENATE cell1 lv_disc_per endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* ZSUB Doc
    CONCATENATE cell1 lst_final_crme_crt-vgbel endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Customer Grp 3
    CONCATENATE cell1 lst_final_crme_crt-kdkg3 endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Sales office
    CONCATENATE cell1 lst_final_crme_crt-vkbur endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Customer PO
    CONCATENATE cell1 lst_final_crme_crt-bstnk endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Your ref.
    CONCATENATE cell1 lst_final_crme_crt-ihrez_e endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Your ref item
    CONCATENATE cell1 lst_final_crme_crt-posex_e endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.
* Po type
    CONCATENATE cell1 lst_final_crme_crt-bsark endcell INTO  lst_text.
    APPEND lst_text TO li_text.
    CLEAR lst_text.

    APPEND '</Row>' TO li_text.
    CLEAR : lst_text.
  ENDLOOP.
  APPEND  :  ' </Table>'     TO li_text,
             ' </Worksheet>' TO li_text,
             ' </Workbook>'  TO li_text.


  CALL FUNCTION 'SCMS_TEXT_TO_BINARY'
    EXPORTING
      first_line = 1
    TABLES
      text_tab   = li_text
      binary_tab = i_contents_hex.
ENDFORM.

************************************************************************
*      Form  SEND_EMAIL_WITH_XLS
************************************************************************
FORM send_email_with_xls USING fp_lv_name TYPE char100.

  DATA: lst_xdocdata LIKE sodocchgi1,
        lv_xcnt      TYPE i,
        lv_file_name TYPE char100,
        lst_usr21    TYPE usr21,
        lst_adr6     TYPE adr6,
        lv_p_mail    LIKE LINE OF p_mail.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_contents_hex INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = text-106.
  lst_xdocdata-obj_descr  = fp_lv_name.
  CLEAR : i_attachment,lv_file_name.  REFRESH i_attachment.
  i_attachment[] = i_attach[]."pit_attach[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw.
  APPEND i_packing_list.

*- Create attachment notification
  i_packing_list-transf_bin = c_x.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 1.
  i_packing_list-body_start = 1.

  DESCRIBE TABLE i_contents_hex LINES i_packing_list-body_num.
  CONCATENATE text-108 sy-datum sy-uzeit INTO lv_file_name SEPARATED BY '_'.
  i_packing_list-doc_type   =  c_xls."'BIN'."p_format.
  i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
  i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
  i_packing_list-doc_size   =  i_packing_list-body_num * 255.
  APPEND i_packing_list.

  IF p_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT p_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver = lv_p_mail-low."'sguda@wiley.com'."p_email.
      i_receivers-rec_type = c_u.
      i_receivers-com_type = c_int.
      i_receivers-notif_del = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
    TABLES
      packing_list               = i_packing_list
*     contents_bin               = i_attachment
      contents_txt               = i_message
      contents_hex               = i_contents_hex
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
    MESSAGE text-120 TYPE c_i.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PO_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_po_dynamics .
*- Define the object to be passed to the RESTRICTION parameter
  DATA: lst_restrict TYPE sscr_restrict,
        lst_optlist  TYPE sscr_opt_list,
        lst_ass      TYPE sscr_ass.
* Constant Declaration
  CONSTANTS: lc_name    TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lc_flag    TYPE flag VALUE 'X',                " General Flag
             lc_kind    TYPE rsscr_kind VALUE 'S',          " ABAP: Type of selection
             lc_name1   TYPE blockname VALUE 'S_PO',        " Block name on selection screen
             lc_sg_main TYPE raldb_sign VALUE 'I',          " SIGN field in creation of SELECT-OPTIONS tables
             lc_sg_addy TYPE raldb_sign VALUE space,        " SIGN field in creation of SELECT-OPTIONS tables
             lc_op_main TYPE rsrest_opl VALUE 'OBJECTKEY1'. " Name of an options list for SELECT-OPTIONS restrictions
  CLEAR: lst_optlist , lst_ass.
* Restricting the KURST selection to only EQ.
  lst_optlist-name = lc_name.
  lst_optlist-options-eq = lc_flag.
  APPEND lst_optlist TO lst_restrict-opt_list_tab.

  lst_ass-kind = lc_kind.
  lst_ass-name = lc_name1.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CLEAR lst_ass.
  lst_ass-kind = lc_kind.
  lst_ass-name = 'P_MAIL'.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lst_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_CRME_CRT_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_I_FINAL_CRME_CRT  text
*----------------------------------------------------------------------*
FORM f_convert_crme_crt_excel  USING    fp_p_file TYPE localfile.
  DATA : i_raw_data   TYPE  truxs_t_text_data,
         li_final_tmp TYPE STANDARD TABLE OF ty_crdt_memo_crt,
*--*Begin of change ERP-7680 - ED1K908253 - 8/23/2018
         lv_lines     TYPE i.
*--*End of change ERP-7680 - ED1K908253 - 8/23/2018
*Get input data into internal table
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = c_x
      i_tab_raw_data       = i_raw_data
      i_filename           = fp_p_file
    TABLES
      i_tab_converted_data = i_final_crme_crt
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc NE 0.
    MESSAGE text-121 TYPE c_i.
    LEAVE LIST-PROCESSING.
*--*Begin of change ERP-7680 - ED1K908253 - 8/23/2018
  ELSE.
    IF rb_fg_m = c_x. "Check if foreground selected
      CLEAR : lv_lines.
      PERFORM f_get_constants.
      DESCRIBE TABLE i_final_crme_crt LINES lv_lines.
      IF lv_lines GT v_fg_lines_limit AND v_fg_lines_limit IS NOT INITIAL.
        MESSAGE text-122 TYPE c_i.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.
*--*End of change ERP-7680 - ED1K908253 - 8/23/2018
  ENDIF.
  LOOP AT i_final_crme_crt INTO st_final_crme_crt.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-customer
      IMPORTING
        output = st_final_crme_crt-customer.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-partner
      IMPORTING
        output = st_final_crme_crt-partner.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-vkorg
      IMPORTING
        output = st_final_crme_crt-vkorg.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-vtweg
      IMPORTING
        output = st_final_crme_crt-vtweg.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-spart
      IMPORTING
        output = st_final_crme_crt-spart.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-vkbur
      IMPORTING
        output = st_final_crme_crt-vkbur.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-bsark
      IMPORTING
        output = st_final_crme_crt-bsark.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-vbeln
      IMPORTING
        output = st_final_crme_crt-vbeln.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = st_final_crme_crt-posnr
      IMPORTING
        output = st_final_crme_crt-posnr.

    APPEND st_final_crme_crt TO li_final_tmp.
    CLEAR st_final_crme_crt.
  ENDLOOP.
  i_final_crme_crt[] = li_final_tmp[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file.
*--*F4 Help to get file from Presentation server
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF. " IF sy-subrc NE 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_CMR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fill_cmr TABLES fp_final_crme_crt fp_mail."TYPE STANDARD TABLE.
  DATA : lv_vbeln         TYPE vbeln_vf,
         lv_posnr         TYPE posnr,
         lst_cred_mem     TYPE ty_crdt_memo_crt,
         lv_price1        TYPE kwert,
         lv_price2        TYPE kwert,
         lv_price3        TYPE kwert,
         lv_discount      TYPE kwert,
         lv_discount_zsub TYPE kbetr.
  REFRESH i_price.
  p_mail[] = fp_mail[].
*--*Make the invoice number to first column of to be created CMR final Itab
  LOOP AT fp_final_crme_crt INTO lst_cred_mem.
    IF lst_cred_mem-parvw = c_pf_ag." OR lst_cred_mem-vbtyp = c_m.
      lv_vbeln = lst_cred_mem-vbeln.
      CONTINUE.
    ELSE.
*--*Build a seperate Internal table with only Prices and Billingdoc,Item and category.
      lst_cred_mem-vbeln = lv_vbeln.
      MOVE-CORRESPONDING lst_cred_mem TO st_cmr.
      APPEND st_cmr TO i_final_crme_cmr.
      st_price-vbeln = lv_vbeln.
      st_price-vbtyp = lst_cred_mem-vbtyp.
      IF lst_cred_mem-vbtyp = c_m.
        lv_posnr = lst_cred_mem-posnr.
      ENDIF.
      st_price-posnr = lv_posnr.   "Keep only ZSUB Item numbers
      st_price-price1 = lst_cred_mem-kbetr1.
      st_price-price2 = lst_cred_mem-kbetr2.
      st_price-price3 = lst_cred_mem-kbetr3.
      st_price-discount = lst_cred_mem-discount.
      st_price-disc_per = lst_cred_mem-disc_per.
      APPEND st_price TO i_price.
      CLEAR st_price.
    ENDIF.
    CLEAR:lst_cred_mem,st_cmr.
  ENDLOOP.
  CLEAR : lv_posnr.
*--* Accumlate Members's price and populate to Parent Item
  SORT i_price BY vbeln posnr vbtyp.
  LOOP AT i_price INTO st_price.
*--*Member prices
    IF st_price-vbtyp = c_g.
      lv_price1 = lv_price1 + st_price-price1.
      lv_price2 = lv_price2 + st_price-price2.
      lv_price3 = lv_price3 + st_price-price3.
      lv_discount = lv_discount + st_price-discount.
      lv_discount_zsub = st_price-disc_per.
    ENDIF.
*--*Parent Item level
    IF st_price-vbtyp = c_m.
      READ TABLE i_final_crme_cmr INTO st_cmr WITH KEY vbeln = st_price-vbeln
                                                       posnr = st_price-posnr
                                                       vbtyp = st_price-vbtyp.
      IF sy-subrc EQ 0.
        st_cmr-kbetr1 = lv_price1.
        st_cmr-kbetr2 = lv_price2.
        st_cmr-kbetr3 = lv_price3.
        st_cmr-discount = lv_discount.
        st_cmr-disc_per = lv_discount_zsub.
        CLEAR : lv_price1,lv_price2,lv_price3,lv_discount,lv_discount_zsub.
        MODIFY i_final_crme_cmr FROM st_cmr INDEX sy-tabix TRANSPORTING kbetr1 kbetr2 kbetr3 discount disc_per.
      ENDIF.
    ENDIF.
  ENDLOOP.
*--*Below Subroutine is used to get Constants
  PERFORM f_get_constants.
*--*Get Currency
  PERFORM f_get_currency.
*** Begin of: KJAGANA  ED2K913407  CR#  7738
*--*Below Subroutine is used to get condition grop values.
  PERFORM f_cond_group_value.
*** End of: KJAGANA  ED2K913407  CR#  7738
*&---------------------------------------------------------------------*
*  The below subroutine is used to create Credit Memo Request
*----------------------------------------------------------------------*
  PERFORM f_create_cmr.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_INV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_inv .
*--*Get the Invoice doc fron VBRK based on selection screen entry
  DATA lv_vbeln TYPE vbrk-vbeln.
  IF s_rf_inv[] IS NOT INITIAL.
    SELECT SINGLE vbeln
                  FROM vbrk
                  INTO lv_vbeln
                  WHERE vbeln IN s_rf_inv.
    IF lv_vbeln IS INITIAL.
      MESSAGE text-090 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_so .
*--*Select the sales doc number from VBAK based on selection screen entry
  DATA lv_so TYPE vbak-vbeln.
  IF s_cnt_no[] IS NOT INITIAL.
    SELECT SINGLE vbeln
                  FROM vbak
                  INTO lv_so
                  WHERE vbeln IN s_cnt_no.
    IF lv_so IS INITIAL.
      MESSAGE text-090 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_sp.
*--*Get the partner from VBPA based on selection screen entry
  DATA lv_shp_to TYPE vbpa-kunnr.
  IF s_shp_to[] IS NOT INITIAL.
    SELECT SINGLE kunnr
                  FROM vbpa
                  INTO lv_shp_to
                  WHERE parvw = c_pf_we
                  AND kunnr   IN s_shp_to.
    IF lv_shp_to IS INITIAL.
      MESSAGE text-090 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BATCH_JOB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_batch_job .
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status
* Local constant declaration
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'CONSORTIA_CMR'. " Background job name
  CONCATENATE lc_job_name c_underscore sy-datum c_underscore sy-uzeit INTO lv_job_name.
  v_job_name = lv_job_name.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
*--*Below program is used to read the application server data which is placed from current program
*--*And creates Credit memos
    SUBMIT zqtcr_cmr_upld_consortium_b
                               WITH p_file =  v_path_fname
                               WITH p_mail IN  p_mail
                               VIA JOB lv_job_name NUMBER lv_job_number
                               AND RETURN.
** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.

** if job is closed sucessfully, pass the job name and job count
** as previous job name and count for next job.
    IF sy-subrc EQ 0.
*--*The below subroutine is used to display the information about Batch job on ALV
      PERFORM f_display_message USING lv_job_name.

    ELSE. " ELSE -> IF sy-subrc EQ 0
      MESSAGE e000(zrtr_r1b) WITH text-109. " & & & &
    ENDIF.
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_PLACE_INTO_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_file_place_into_app .
* Local data ----------------------------------------------------------
  DATA: lv_data         TYPE string,
        lv_tab          TYPE c VALUE cl_abap_char_utilities=>horizontal_tab, " Tab of type Character
        lv_targ_qty(17) TYPE c,
        lv_kbetr1(15)   TYPE c,
        lv_kbetr2(15)   TYPE c,
        lv_kbetr3(15)   TYPE c,
        lv_discount(15) TYPE c,
        lv_disc_per(15) TYPE c,
        lv_path         TYPE filepath-pathintern VALUE 'Z_CMR_UPLOAD_IN',
        lv_filename     TYPE string.
  CONCATENATE c_cmr sy-uname sy-datum sy-uzeit INTO lv_filename SEPARATED BY c_underscore.
  CONCATENATE lv_filename c_extn INTO lv_filename.
  PERFORM f_get_file_path USING lv_path lv_filename.
  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
  LOOP AT i_final_crme_crt INTO DATA(lst_file_crt).
    CLEAR: lv_targ_qty,lv_kbetr1,lv_kbetr2,lv_kbetr3.
    lv_targ_qty = lst_file_crt-zmeng.
    lv_kbetr1   = lst_file_crt-kbetr1.
    lv_kbetr2   = lst_file_crt-kbetr2.
    lv_kbetr3   = lst_file_crt-kbetr3.
    lv_discount = lst_file_crt-discount.
    lv_disc_per  = lst_file_crt-disc_per.
    CONCATENATE lst_file_crt-customer lst_file_crt-parvw    lst_file_crt-partner lst_file_crt-vkorg
               lst_file_crt-vtweg    lst_file_crt-spart    lst_file_crt-auart   lst_file_crt-xblnr
               lst_file_crt-vbtyp    lst_file_crt-zlsch    lst_file_crt-augru   lst_file_crt-vbeln
               lst_file_crt-posnr    lst_file_crt-matnr    lv_targ_qty          lst_file_crt-text
               lv_kbetr1             lv_kbetr2   lv_kbetr3  lv_discount         lv_disc_per lst_file_crt-vgbel
               lst_file_crt-kdkg3    lst_file_crt-vkbur    lst_file_crt-bstnk   lst_file_crt-ihrez_e
               lst_file_crt-posex_e  lst_file_crt-bsark
           INTO lv_data
      SEPARATED BY lv_tab.
    TRANSFER lv_data TO v_path_fname.
    CLEAR: lv_data.
  ENDLOOP.
  CLOSE DATASET v_path_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_JOB_NAME  text
*----------------------------------------------------------------------*
FORM f_display_message  USING    fp_lv_job_name.
  TYPE-POOLS : slis.
  TYPES : BEGIN OF lty_tab,
            job(32) TYPE c,
            user    TYPE sy-uname,
            date    TYPE sy-datum,
            time    TYPE sy-uzeit,
          END OF lty_tab.
  DATA : li_tab     TYPE STANDARD TABLE OF lty_tab,
         lst_tab    TYPE lty_tab,
         li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.
  CONSTANTS : lc_job  TYPE char3 VALUE 'JOB',
              lc_tab  TYPE char10 VALUE 'LI_TAB',
              lc_user TYPE char10 VALUE 'USER',
              lc_date TYPE char4 VALUE 'DATE',
              lc_time TYPE char4 VALUE 'TIME'.
  lst_layout-colwidth_optimize = c_x.
  lst_layout-zebra = c_x.

  CLEAR: lv_val.
  lst_fcat-fieldname   = lc_job.
  lst_fcat-tabname  = lc_tab.
  lst_fcat-seltext_m      = text-070.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = lc_user.
  lst_fcat-tabname  = lc_tab.
  lst_fcat-seltext_m      = text-071.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = lc_date.
  lst_fcat-tabname  = lc_tab.
  lst_fcat-seltext_m      = text-072.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = lc_time.
  lst_fcat-tabname  = lc_tab.
  lst_fcat-seltext_m      = text-073.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_tab-job = fp_lv_job_name.
  lst_tab-user = sy-uname.
  lst_tab-date = sy-datum.
  lst_tab-time = sy-uzeit.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-075
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = li_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE text-091 TYPE c_i.
  ENDIF.
  REFRESH : li_fcat,li_tab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_CMR_D
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_CMR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_cmr .
*====================================================================*
*     L O C A L  I N T E R N A L  T A B L E
*====================================================================*
  DATA: li_sales_itm   TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        li_sales_partn TYPE STANDARD TABLE OF bapiparnr,  " Communications Fields: SD Document Partner: WWW
        li_sales_cond  TYPE STANDARD TABLE OF bapicond,   " Communication Fields for Maintaining Conditions in the Order
        li_sales_condx TYPE STANDARD TABLE OF bapicondx,  " Communication Fields for Maintaining Conditions in the Order
        li_sales_itmx  TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
        li_sales_text  TYPE STANDARD TABLE OF bapisdtext, " Communication fields: SD texts
        li_return      TYPE STANDARD TABLE OF bapiret2. " Return Parameter
*====================================================================*
*     L O C A L  W O R K A R E A
*====================================================================*
  DATA: lst_sales_hdr_in  TYPE bapisdhd1,  " Communication Fields: Sales and Distribution Document Header
        lst_sales_hdr_inx TYPE bapisdhd1x, " Checkbox Fields for Sales and Distribution Document Header
        lst_sales_itm     TYPE bapisditm,  " Communication Fields: Sales and Distribution Document Item
        lst_sales_partn   TYPE bapiparnr,  " Communications Fields: SD Document Partner: WWW
        lst_sales_cond    TYPE bapicond,   " Communication Fields for Maintaining Conditions in the Order
        lst_return        TYPE bapiret2,   " Return Parameter
        lst_e_return      TYPE bapiret2,   " Return Parameter
        lst_sales_condx   TYPE bapicondx,  " Communication Fields for Maintaining Conditions in the Order
        lst_cmr_final     TYPE ty_crdt_memo_cmr,
        lst_cmr           LIKE LINE OF i_final_crme_cmr,
        lst_sales_text    TYPE bapisdtext, " Communication fields: SD texts
        lst_sales_itmx    TYPE bapisditmx, " Communication Fields: Sales and Distribution Document Item
        lst_cond          TYPE ty_cond.    "Condition value table

*====================================================================*
*     L O C A L  V A R I A B L E
*====================================================================*
  DATA: lv_credit_memo TYPE bapivbeln-vbeln, " Sales Document
        lv_path_prc    TYPE filepath-pathintern VALUE 'Z_CMR_UPLOAD_PROCESS',
        lv_path_err    TYPE filepath-pathintern VALUE 'Z_CMR_UPLOAD_ERR',
        lv_filename    TYPE string.
*====================================================================*
*     L O C A L  C O N S T A N T S
*====================================================================*
  CONSTANTS: lc_posnr       TYPE posnr VALUE '000010'. " Item number of the SD document
************************8IMP**************
  DATA : lv_posnr       TYPE posnr_vl,
         lv_vb          TYPE vbeln_vl,
         lv_data        TYPE string,
         lv_count_index TYPE sytabix,
         lv_next_record TYPE sy-tabix.
  CLEAR: i_log.
***********************************************************8
  i_final_crme_split[] = i_final_crme_cmr[].
  SORT i_final_crme_split BY vbeln customer.
*--*Keep number of invoices alonth with customer as Unique in Split internal table
  DELETE ADJACENT DUPLICATES FROM i_final_crme_split COMPARING vbeln  customer.
  LOOP AT i_final_crme_split INTO DATA(lst_split).
    CLEAR: lv_posnr.
    lv_count_index = 0.
*    PERFORM f_call_copy_control USING lst_split-vbeln.
    LOOP AT i_final_crme_cmr INTO st_cmr WHERE vbeln = lst_split-vbeln
                                         AND customer = lst_split-customer.
      lv_next_record = sy-tabix + 1.
      lv_posnr = lv_posnr + lc_posnr.
      lst_cmr_final = st_cmr.
      AT NEW vbeln.
        st_cmr = lst_cmr_final.
        CLEAR : lst_sales_hdr_in,lst_sales_hdr_inx.
        lst_sales_hdr_in-doc_type    = c_zcr.
        lst_sales_hdr_in-sales_org   = st_cmr-vkorg.
        lst_sales_hdr_in-distr_chan  = st_cmr-vtweg.
        lst_sales_hdr_in-division    = st_cmr-spart.
        lst_sales_hdr_in-sales_off   = st_cmr-vkbur.
        lst_sales_hdr_in-purch_no_c  = st_cmr-bstnk.
        lst_sales_hdr_in-po_method = st_cmr-bsark.
        lst_sales_hdr_in-ord_reason = st_cmr-augru.
*      lst_sales_hdr_in-ref_1_s = st_cmr-ihrez_e.
        lst_sales_hdr_in-bill_block = abap_false.
        lst_sales_hdr_inx-bill_block = abap_true.

        lst_sales_hdr_inx-updateflag = c_x.
        lst_sales_hdr_inx-doc_type  = c_x.
        lst_sales_hdr_inx-sales_org = c_x.
        lst_sales_hdr_inx-distr_chan = c_x.
        lst_sales_hdr_inx-division = c_x.
        lst_sales_hdr_inx-sales_off = c_x.
        IF lst_sales_hdr_in-purch_no_c IS NOT INITIAL.
          lst_sales_hdr_inx-purch_no_c = c_x.
        ENDIF.
        IF lst_sales_hdr_in-po_method IS NOT INITIAL.
          lst_sales_hdr_inx-po_method = c_x.
        ENDIF.
        IF lst_sales_hdr_in-ord_reason IS NOT INITIAL.
          lst_sales_hdr_inx-ord_reason = c_x.
        ENDIF.
*      lst_sales_hdr_inx-ref_1_s = c_x.
      ENDAT.
      lst_sales_itm-itm_number = lv_posnr.
      lst_sales_itmx-itm_number = lv_posnr.
      lst_sales_itm-material = st_cmr-matnr.
      lst_sales_itmx-material = c_x.
      lst_sales_itm-target_qty = st_cmr-zmeng.
      lst_sales_itmx-target_qty = c_x.
      lst_sales_itm-ref_1_s = st_cmr-ihrez_e.
      IF lst_sales_itm-ref_1_s IS NOT INITIAL.
        lst_sales_itmx-ref_1_s  = c_x.
      ENDIF.
      lst_sales_itm-poitm_no_s = st_cmr-posex_e.
      IF lst_sales_itm-poitm_no_s IS NOT INITIAL.
        lst_sales_itmx-poitm_no_s = c_x.
      ENDIF.
      IF st_cmr-vbtyp = c_m.
        lst_sales_itm-ref_doc = st_cmr-vbeln.
        lst_sales_itm-ref_doc_it = st_cmr-posnr.
        lst_sales_itm-ref_doc_ca = c_m.
*** Begin of: KJAGANA  ED2K913407  CR#  7738
        CLEAR: lst_cond.
        READ TABLE i_cond INTO lst_cond WITH KEY vbeln =  st_cmr-vgbel
                                                 posnr =  st_cmr-posnr
                                                 BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_sales_itm-cstcndgrp1 = lst_cond-kdkg1.
          lst_sales_itm-cstcndgrp2 = lst_cond-kdkg2.
          lst_sales_itm-cstcndgrp3 = lst_cond-kdkg3.
          lst_sales_itm-cstcndgrp4 = lst_cond-kdkg4.
          lst_sales_itm-cstcndgrp5 = lst_cond-kdkg5.
          IF lst_sales_itm-cstcndgrp1 IS NOT INITIAL.
            lst_sales_itmx-cstcndgrp1 = c_x.
          ENDIF.
          IF lst_sales_itm-cstcndgrp2 IS NOT INITIAL.
            lst_sales_itmx-cstcndgrp2 = c_x.
          ENDIF.
          IF lst_sales_itm-cstcndgrp3 IS NOT INITIAL.
            lst_sales_itmx-cstcndgrp3 = c_x.
          ENDIF.
          IF lst_sales_itm-cstcndgrp4 IS NOT INITIAL.
            lst_sales_itmx-cstcndgrp4 = c_x.
          ENDIF.
          IF lst_sales_itm-cstcndgrp5 IS NOT INITIAL.
            lst_sales_itmx-cstcndgrp5 = c_x.
          ENDIF.
        ENDIF.
*** End of: KJAGANA  ED2K913407  CR#  7738
*        READ TABLE i_copy_vbap INTO DATA(lst_copy_vbap) WITH KEY "vbeln = st_cmr-vgbel
*                                                                 posnr = lst_sales_itm-itm_number.
*        "BINARY SEARCH.
*        IF sy-subrc EQ 0 AND lst_copy_vbap-pstyv IS NOT INITIAL.
*          lst_sales_itm-item_categ = lst_copy_vbap-pstyv.
*          lst_sales_itmx-item_categ = c_x.
*        ENDIF.
      ELSE.
        lst_sales_itm-ref_doc = st_cmr-xblnr.
        lst_sales_itm-ref_doc_it = st_cmr-posnr.
        lst_sales_itm-ref_doc_ca = c_g.
        lst_sales_itm-item_categ = v_item_cat.
        lst_sales_itmx-item_categ = c_x.
      ENDIF.
      IF lst_sales_itm-ref_doc IS NOT INITIAL.
        lst_sales_itmx-ref_doc = c_x.
      ENDIF.
      IF lst_sales_itm-ref_doc_it IS NOT INITIAL.
        lst_sales_itmx-ref_doc_it = c_x.
      ENDIF.
      IF lst_sales_itm-ref_doc_ca IS NOT INITIAL.
        lst_sales_itmx-ref_doc_ca = c_x.
      ENDIF.
      APPEND lst_sales_itm TO li_sales_itm.
      CLEAR : lst_sales_itm.
      APPEND lst_sales_itmx TO li_sales_itmx.
      CLEAR : lst_sales_itmx.
      lv_vb = st_cmr-vbeln.
      IF li_sales_partn IS INITIAL.
        lst_sales_partn-partn_role = c_pf_ag.
        lst_sales_partn-partn_numb = st_cmr-customer.
        APPEND lst_sales_partn TO li_sales_partn.
        CLEAR : lst_sales_partn.
        lst_sales_partn-partn_role = c_pf_we.
        lst_sales_partn-partn_numb = st_cmr-partner.
        lst_sales_partn-itm_number = lv_posnr.
        APPEND lst_sales_partn TO li_sales_partn.
        CLEAR : lst_sales_partn.
      ELSE.
        lst_sales_partn-partn_role = c_pf_we.
        lst_sales_partn-partn_numb = st_cmr-partner.
        lst_sales_partn-itm_number = lv_posnr.
        APPEND lst_sales_partn TO li_sales_partn.
        CLEAR : lst_sales_partn.
      ENDIF.
*--* Acces Fee
      lst_sales_cond-itm_number = lv_posnr.
      lst_sales_condx-itm_number = lv_posnr.
      lst_sales_cond-cond_type = c_zacc.
      lst_sales_condx-cond_type = c_zacc.
      lst_sales_cond-cond_value = st_cmr-kbetr1.
      lst_sales_condx-cond_value = c_x.
      lst_sales_cond-currency = v_curr.
      lst_sales_condx-currency = c_x.
      APPEND lst_sales_cond TO li_sales_cond.
      APPEND lst_sales_condx TO li_sales_condx.
      CLEAR : lst_sales_cond,lst_sales_condx.
*--*Content Fee
      lst_sales_cond-itm_number = lv_posnr.
      lst_sales_condx-itm_number = lv_posnr.
      lst_sales_cond-cond_type = c_zcon.
      lst_sales_condx-cond_type = c_zcon.
      lst_sales_cond-cond_value = st_cmr-kbetr2.
      lst_sales_condx-cond_value = c_x.
      lst_sales_cond-currency = v_curr.
      lst_sales_condx-currency = c_x.
      APPEND lst_sales_cond TO li_sales_cond.
      APPEND lst_sales_condx TO li_sales_condx.
      CLEAR : lst_sales_cond,lst_sales_condx.
*--*Host Fee
      lst_sales_cond-itm_number = lv_posnr.
      lst_sales_condx-itm_number = lv_posnr.
      lst_sales_cond-cond_type = c_zhos.
      lst_sales_condx-cond_type = c_zhos.
      lst_sales_cond-cond_value = st_cmr-kbetr3.
      lst_sales_condx-cond_value = c_x.
      lst_sales_cond-currency = v_curr.
      lst_sales_condx-currency = c_x.
      APPEND lst_sales_cond TO li_sales_cond.
      APPEND lst_sales_condx TO li_sales_condx.
      CLEAR : lst_sales_cond,lst_sales_condx.
*--*Discount
      lst_sales_cond-itm_number = lv_posnr.
      lst_sales_condx-itm_number = lv_posnr.
      lst_sales_cond-cond_type = c_zpqa.
      lst_sales_condx-cond_type = c_zpqa.
      IF st_cmr-discount IS NOT INITIAL.
        st_cmr-discount = st_cmr-discount * -1.
        lst_sales_cond-condvalue = st_cmr-discount.
        lst_sales_cond-currency_2 = c_usd.
        lst_sales_condx-currency = c_x.
        lst_sales_condx-cond_value = c_x.
      ELSE.
        lst_sales_cond-cond_value = st_cmr-disc_per.
        lst_sales_condx-cond_value = c_x.
      ENDIF.
*        lst_sales_condx-cond_value = c_x.
*
      IF lst_sales_cond-condvalue IS NOT INITIAL OR lst_sales_cond-cond_value IS NOT INITIAL.
        APPEND lst_sales_cond TO li_sales_cond.
        APPEND lst_sales_condx TO li_sales_condx.
      ENDIF.
      CLEAR : lst_sales_cond,lst_sales_condx.
*--*Update text
      lst_sales_text-itm_number = lv_posnr. "Item number
      lst_sales_text-text_id = v_tdid.      "Text Id
      lst_sales_text-langu = sy-langu.      "Language
      lst_sales_text-text_line = st_cmr-text.
      APPEND lst_sales_text TO li_sales_text.
      CLEAR lst_sales_text.
      lv_count_index = lv_count_index + 1.
**Check if current material is BOM
      IF st_cmr-vbtyp = c_m.
        PERFORM f_check_bom TABLES li_sales_itm li_sales_itmx CHANGING lv_posnr.
      ENDIF.
      CLEAR : lst_cmr.

      READ TABLE i_final_crme_cmr INTO lst_cmr INDEX lv_next_record.
      IF sy-subrc NE 0 OR ( st_cmr-matnr NE lst_cmr-matnr AND lv_count_index GE v_lines )
                       OR ( st_cmr-vbeln NE lst_cmr-vbeln ).
        IF i_log IS INITIAL.
*     Bapi call
          CLEAR: li_return[],lv_credit_memo.
          CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
            EXPORTING
              sales_header_in      = lst_sales_hdr_in
              sales_header_inx     = lst_sales_hdr_inx
            IMPORTING
              salesdocument_ex     = lv_credit_memo
            TABLES
              return               = li_return
              sales_items_in       = li_sales_itm
              sales_items_inx      = li_sales_itmx
              sales_partners       = li_sales_partn
              sales_conditions_in  = li_sales_cond
              sales_conditions_inx = li_sales_condx
              sales_text           = li_sales_text.

          st_log-vkorg = st_cmr-vkorg..
          st_log-vtweg = st_cmr-vtweg.
          st_log-spart = st_cmr-spart.
          st_log-bstnk = st_cmr-bstnk.
          st_log-kunnr = st_cmr-partner.
          st_log-xblnr = st_cmr-vbeln.

          IF NOT li_return IS INITIAL.
            READ TABLE li_return INTO lst_e_return WITH KEY type = c_e. " Return into lst_ of type
            IF sy-subrc NE 0.
              READ TABLE li_return INTO lst_return WITH KEY type = c_a.
            ENDIF.
            IF sy-subrc = 0.
              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
              LOOP AT li_return INTO lst_return." WHERE message_v2 IS NOT INITIAL.
*              READ TABLE li_sales_itm INTO lst_sales_itm WITH KEY itm_number = lst_return-message_v2.
*              IF sy-subrc EQ 0.
                st_log-posnr = lst_sales_itm-itm_number.
                st_log-matnr = lst_sales_itm-material.
                st_log-msg_typ = lst_return-type.
                st_log-message = lst_return-message.
                APPEND st_log TO i_log.
*              ENDIF.
              ENDLOOP.
              IF i_log IS INITIAL.
                st_log-msg_typ = lst_e_return-type.
                st_log-message = lst_e_return-message.
                APPEND st_log TO i_log.
              ENDIF.
              CLEAR: lst_return, st_log,lv_vb.

            ELSE. " ELSE -> IF sy-subrc = 0
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = 'X'.

              READ TABLE li_return INTO lst_return WITH KEY type = c_s
                                                            number = 311. " Return into lst_ of type

              IF sy-subrc IS INITIAL.
                LOOP AT li_sales_itm INTO lst_sales_itm.
                  st_log-vbeln = lv_credit_memo.
                  IF lv_credit_memo IS INITIAL.
                    st_log-vbeln = lst_return-message_v2.
                  ENDIF.
                  st_log-posnr = lst_sales_itm-itm_number.
                  st_log-matnr = lst_sales_itm-material.
                  st_log-message = lst_return-message.
                  st_log-msg_typ = lst_return-type.
                  APPEND st_log TO i_log.
                ENDLOOP.
                CLEAR : lst_sales_itm.
              ENDIF.

              CLEAR: lst_return, st_log,lv_credit_memo.
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDIF.
        CLEAR:
*** Begin of: KJAGANA  ED2K913407  CR#  7738
*             lst_sales_hdr_in,
*** End of: KJAGANA  ED2K913407  CR#  7738
             lst_sales_itm,
             lv_credit_memo,
             li_return,
             li_sales_itm,
             li_sales_itmx,
             li_sales_partn,
             li_sales_cond,
             li_sales_condx,
             lv_count_index,
             lv_posnr.
      ENDIF. " IF NOT li_return IS INITIAL
      APPEND LINES OF i_log TO i_log_temp.
      CLEAR : i_log[].
    ENDLOOP.
  ENDLOOP.
  i_log[] = i_log_temp[].
  CLEAR  : i_log_temp[].
*--*Below Subroutine is used to build fieldcatelog for Log display
  PERFORM f_build_fcat_log.
*--*Below Subroutine is used for  Log display
  PERFORM f_display_log.
  IF sy-batch EQ c_x.
*--*Below Subroutine is used to send Log as Email
    PERFORM f_send_log_email.
  ENDIF.
*--*Send file to AL11
  CONCATENATE c_cmr sy-uname sy-datum sy-uzeit INTO lv_filename SEPARATED BY c_underscore.
  CONCATENATE lv_filename c_extn INTO lv_filename.
*&---------------------------------------------------------------------*
*  Below subroutines is used to place the log file in Application server
*  Error file goes to error path and succes file goes to processed path
*----------------------------------------------------------------------*
  READ TABLE i_log INTO st_log WITH KEY msg_typ = c_e.
  IF sy-subrc EQ 0.
    PERFORM f_get_file_path USING lv_path_err lv_filename.
  ELSE.
    PERFORM f_get_file_path USING lv_path_prc lv_filename.
  ENDIF.
  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
  LOOP AT i_log INTO st_log.
    CONCATENATE   st_log-vkorg
                  st_log-spart
                  st_log-bstnk
                  st_log-kunnr
                  st_log-xblnr
                  st_log-vbeln
                  st_log-posnr
                  st_log-matnr
                  st_log-msg_typ
                  st_log-message
                INTO lv_data
      SEPARATED BY con_tab.
    TRANSFER lv_data TO v_path_fname.
    CLEAR: lv_data.
  ENDLOOP.
  CLOSE DATASET v_path_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat_log .
  DATA : lv_val     TYPE i VALUE 1,
         lc_vkorg   TYPE fieldname VALUE 'VKORG',
         lc_vtweg   TYPE fieldname VALUE 'VTWEG',
         lc_spart   TYPE fieldname VALUE 'SPART',
         lc_bstnk   TYPE fieldname VALUE 'BSTNK',
         lc_kunnr   TYPE fieldname VALUE 'KUNNR',
         lc_xblnr   TYPE fieldname VALUE 'XBLNR',
         lc_vbeln   TYPE fieldname VALUE 'VBELN',
         lc_posnr   TYPE fieldname VALUE 'POSNR',
         lc_matnr   TYPE fieldname VALUE 'MATNR',
         lc_msgtype TYPE fieldname VALUE 'MSG_TYP',
         lc_message TYPE fieldname VALUE 'MESSAGE',
         lc_tab     TYPE fieldname VALUE 'I_LOG'.

  st_layout-colwidth_optimize = c_x.
  st_layout-zebra = c_x.

  st_fcat-fieldname   = lc_vkorg.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-080.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_vtweg.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-081.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_spart.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-082.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_bstnk.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-083.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_kunnr.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-084.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_xblnr.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-085.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_vbeln.
  st_fcat-tabname     = lc_tab.
  st_fcat-seltext_m   = text-086.
  st_fcat-col_pos     = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_posnr.
  st_fcat-tabname     = lc_tab.
  st_fcat-seltext_m   = text-066.
  st_fcat-col_pos     = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_matnr.
  st_fcat-tabname     = lc_tab.
  st_fcat-seltext_m   = text-h04.
  st_fcat-col_pos     = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.
  st_fcat-fieldname   = lc_msgtype.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-087.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.

  st_fcat-fieldname   = lc_message.
  st_fcat-tabname  = lc_tab.
  st_fcat-seltext_m      = text-088.
  st_fcat-col_pos      = lv_val.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  ADD 1 TO lv_val.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_log .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-089
      is_layout          = st_layo
      it_fieldcat        = i_fcat
    TABLES
      t_outtab           = i_log
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc NE 0.
    MESSAGE text-091 TYPE c_i.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_log_email .
*-  Populate table with detaisl to be entered into .xls file
  PERFORM build_xls_log_data .

*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage = text-110.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  CONCATENATE 'Job' v_job_name text-105  INTO st_imessage SEPARATED BY space.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Send file by email as .xls speadsheet
  PERFORM send_email_xls_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_XLS_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_xls_log_data .

  REFRESH i_attach.
  CONCATENATE text-080  text-081  text-082 text-083 text-084
              text-085  text-086  text-066 text-h04 text-087 text-088
      INTO i_attach SEPARATED BY con_tab.

  CONCATENATE con_cret i_attach INTO i_attach.
  APPEND  i_attach.

  LOOP AT i_log INTO st_log.
    CONCATENATE  st_log-vkorg st_log-vtweg  st_log-spart st_log-bstnk st_log-kunnr
                 st_log-xblnr st_log-vbeln  st_log-posnr st_log-matnr st_log-msg_typ st_log-message
             INTO i_attach SEPARATED BY con_tab.
    CONCATENATE con_cret i_attach  INTO i_attach.
    APPEND  i_attach.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_email_xls_log .
  DATA: lst_xdocdata LIKE sodocchgi1,
        lv_xcnt      TYPE i,
        lv_file_name TYPE char100,
        lst_usr21    TYPE usr21,
        lst_adr6     TYPE adr6,
        lv_p_mail    LIKE LINE OF p_mail.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = text-106.
  IF sy-sysid EQ c_ep1.
    CONCATENATE text-111 sy-datum sy-uzeit INTO lv_file_name  SEPARATED BY '_'.
  ELSE.
    CONCATENATE text-111 sy-datum sy-uzeit sy-sysid INTO lv_file_name  SEPARATED BY '_'.
  ENDIF.
  lst_xdocdata-obj_descr  = lv_file_name.
  CLEAR : i_attachment,lv_file_name.  REFRESH i_attachment.
  i_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw.
  APPEND i_packing_list.

*- Create attachment notification
  i_packing_list-transf_bin = c_x.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 1.
  i_packing_list-body_start = 1.

  DESCRIBE TABLE i_attachment LINES i_packing_list-body_num.
  CONCATENATE text-111 '.xlsx'  INTO lv_file_name.
  i_packing_list-doc_type   =  c_xls..
  i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
  i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
  i_packing_list-doc_size   =  i_packing_list-body_num * 255.
  APPEND i_packing_list.


  IF p_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT p_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver = lv_p_mail-low.
      i_receivers-rec_type = c_u.
      i_receivers-com_type = c_int.
      i_receivers-notif_del = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ELSE.
    CLEAR : lst_usr21,lst_adr6.
    SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = sy-uname.
    IF lst_usr21 IS NOT INITIAL.
      SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                              AND   persnumber = lst_usr21-persnumber.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.  REFRESH i_receivers.
    i_receivers-receiver = lst_adr6-smtp_addr.
    i_receivers-rec_type = c_u.
    i_receivers-com_type = c_int.
    i_receivers-notif_del = c_x.
    i_receivers-notif_ndel = c_x.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_message
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
    MESSAGE text-120 TYPE c_i.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_POSNR  text
*----------------------------------------------------------------------*
FORM f_check_bom TABLES fp_li_sales_itm STRUCTURE bapisditm
                        fp_li_sales_itmx STRUCTURE bapisditmx CHANGING fp_lv_item.
  DATA : li_bom          TYPE STANDARD TABLE OF stpox INITIAL SIZE 0, " BOM Items (Extended for List Displays)
         lv_plant        TYPE csap_mbom-werks,               " Local Variable for Plant
         lst_topmat      TYPE cstmat, " Start Material Display for BOM Explosions
         lv_quantity     TYPE basmn, " Base quantity
         lst_sales_item  TYPE bapisditm,
         lst_sales_itemx TYPE bapisditmx,
         lv_count        TYPE i,  "Local Variable for Item count
         lv_stlnr        TYPE stnum,
         lv_stlal        TYPE stalt,
         lv_year         TYPE bdatj,
         lv_erdat        TYPE erdat,
         lv_bukrs        TYPE bukrs,
         lv_periv        TYPE periv,
         lv_comp         TYPE posnr.

  CONSTANTS :lc_usage TYPE csap_mbom-stlan VALUE '5'. "Local constant for BOM Usage
  CLEAR : li_bom,lv_plant.
*--*Fetch the plant associated with material in Material/Sales org/d.channel combination
  SELECT SINGLE dwerk FROM mvke INTO lv_plant WHERE matnr = st_cmr-matnr
                                               AND  vkorg = st_cmr-vkorg
                                               AND  vtweg = st_cmr-vtweg.
*--*BOC ERP7774  PRABHU ED2K913528
*--*Call FM to check whether the material is BOM associated or not
  IF sy-subrc EQ 0.
    CLEAR : lv_stlnr,lv_erdat,lv_bukrs,lv_periv.
*--* get BOM number from MAST based on material and plant
    SELECT SINGLE stlnr FROM mast INTO lv_stlnr WHERE matnr = st_cmr-matnr
                                                AND  werks = lv_plant
                                                AND stlan = lc_usage.
    IF sy-subrc EQ 0.
*--*get Invoice creation date from VBRK based on invoice number
      SELECT SINGLE erdat bukrs FROM vbrk INTO (lv_erdat,lv_bukrs) WHERE vbeln = st_cmr-vbeln.
      IF sy-subrc EQ 0.
*--*Get physical year variant
        SELECT SINGLE periv FROM t001 INTO lv_periv WHERE bukrs = lv_bukrs.
        IF sy-subrc EQ 0.
*--*Find out the period based on Invoice creation date
          CALL FUNCTION 'DATE_TO_PERIOD_CONVERT'
            EXPORTING
              i_date         = lv_erdat
*             I_MONMIT       = 00
              i_periv        = lv_periv
            IMPORTING
              e_gjahr        = lv_year
            EXCEPTIONS
              input_false    = 1
              t009_notfound  = 2
              t009b_notfound = 3
              OTHERS         = 4.
          IF sy-subrc EQ 0.
            CLEAR : lv_stlal.
*--*Get Valid alternative BOM number
            SELECT SINGLE stlal FROM stko INTO lv_stlal WHERE stlty = c_m
                                                        AND stlnr = lv_stlnr
                                                        AND lkenz  EQ abap_false
                                                        AND loekz EQ abap_false
                                                        AND zzwaers = v_curr
                                                        AND zzbegjj = lv_year.
            IF sy-subrc NE 0.
              st_log-vkorg = st_cmr-vkorg.
              st_log-vtweg = st_cmr-vtweg.
              st_log-spart = st_cmr-spart.
              st_log-bstnk = st_cmr-bstnk.
              st_log-kunnr = st_cmr-partner.
              st_log-xblnr = st_cmr-vbeln.
              st_log-matnr = st_cmr-matnr.
              st_log-message = text-123.
              st_log-msg_typ = c_e.
              APPEND st_log TO i_log.
              CLEAR st_log.
              EXIT.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    lv_quantity = st_cmr-zmeng.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'SD01'      " Application ID
        datuv                 = sy-datum    " Date
        emeng                 = lv_quantity " Quantity
        salww                 = abap_true
        mtnrv                 = st_cmr-matnr    " Material
        rndkz                 = '2'         " Round off: ' '=always, '1'=never, '2'=only levels > 1
        stlan                 = lc_usage
        werks                 = lv_plant    " Plant
        stlal                 = lv_stlal
      IMPORTING
        topmat                = lst_topmat
      TABLES
        stb                   = li_bom
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
*--*EOC ERP7774  PRABHU ED2K913528
    IF sy-subrc EQ 0 AND li_bom IS NOT INITIAL..
*         Delete items which are not Sales Relevant
      DELETE li_bom WHERE rvrel IS INITIAL.
*--*Clear the reference document item for BAPI in BOM case
      READ TABLE fp_li_sales_itm INTO lst_sales_item  WITH KEY fp_lv_item.
      IF sy-subrc EQ 0.
        CLEAR : lst_sales_item-ref_doc_ca."lst_sales_item-ref_doc_it
        lst_sales_item-altern_bom = lv_stlal.
        MODIFY fp_li_sales_itm FROM lst_sales_item INDEX sy-tabix TRANSPORTING ref_doc_it ref_doc_ca altern_bom.
      ENDIF.
      READ TABLE fp_li_sales_itmx INTO lst_sales_itemx  WITH KEY fp_lv_item.
      IF sy-subrc EQ 0.
        CLEAR : lst_sales_itemx-ref_doc_ca."lst_sales_itemx-ref_doc_it
        lst_sales_itemx-altern_bom = c_x.
        MODIFY fp_li_sales_itmx FROM lst_sales_itemx INDEX sy-tabix TRANSPORTING ref_doc_it ref_doc_ca altern_bom.
      ENDIF.
**--*If material is BOM then get the count of number of Items
**--*and populate next item number for BAPI
      IF li_bom IS NOT INITIAL.
        DESCRIBE TABLE li_bom LINES lv_count.
        lv_count = lv_count * 10.
        fp_lv_item = fp_lv_item + lv_count.
      ENDIF.
*      CLEAR lv_comp.
*      lv_comp  = fp_lv_item.
*      LOOP AT i_copy_vbap INTO DATA(lst_copy_vbap) WHERE uepos = fp_lv_item.
*        ADD 10 TO lv_comp.
*        lst_sales_item-itm_number = lv_comp.
*        lst_sales_item-material = lst_copy_vbap-matnr.
*        lst_sales_item-target_qty = lst_copy_vbap-zmeng.
*        lst_sales_item-item_categ  = lst_copy_vbap-pstyv.
*        lst_sales_item-hg_lv_item = fp_lv_item.
*        lst_sales_item-ref_doc_it = lst_copy_vbap-posnr.
*        APPEND lst_sales_item TO fp_li_sales_itm.
*        lst_sales_itemx-itm_number = lst_sales_item-itm_number.
*        lst_sales_itemx-hg_lv_item = c_x.
*        APPEND lst_sales_itemx TO fp_li_sales_itmx.
*      ENDLOOP.
*      fp_lv_item = lst_sales_item-itm_number.
      CLEAR : lst_sales_item,lst_sales_itemx.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization .
*--*Refresh and clear all global variables
  REFRESH : i_final_crme_crt,i_final_crme_split,i_final_crme_cmr,i_vbrk,i_vbak,i_vbap,
            i_vbkd,i_konv,i_vbpa,i_fcat_out,i_log,i_fcat,i_message,i_attach,
            i_packing_list,i_receivers,i_attachment.

  CLEAR : st_fcat_out,st_layout,st_fcat,st_layo,st_vbap,st_log,st_vbak,st_vbkd,st_vbpa,st_cmr,
          st_imessage,st_konv.
*--*Default sales document types
  s_auart-sign = c_i.
  s_auart-option = c_eq.
  s_auart-low = c_zsub.
  APPEND s_auart.

  s_auart-sign = c_i.
  s_auart-option = c_eq.
  s_auart-low = c_zmbr.
  APPEND s_auart.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING    fp_lv_path
                               fp_lv_filename.
  CLEAR : v_path_fname.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_lv_path
      operating_system           = sy-opsys
      file_name                  = fp_lv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_path_fname
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
*&---------------------------------------------------------------------*
*&      Form  F_MAP_ITEM_FIRST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_item_first .
  DATA: li_lines TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_posnr TYPE posnr VALUE  000000,
        lv_line  TYPE tdline,                  " Text Line
        lv_name  TYPE tdobname.                " Name
  CONSTANTS :  lc_vbbp  TYPE thead-tdobject VALUE 'VBBP'.
*  st_cre_cred_memo-customer  = v_kunnr. " Customer Number
  READ TABLE i_vbpa INTO st_vbpa WITH KEY vbeln = st_vbrk-vgbel
                                          posnr = st_vbrk-vgpos
                                          parvw = c_pf_we
                                          BINARY SEARCH.
  IF sy-subrc NE 0.
    READ TABLE i_vbpa INTO st_vbpa WITH KEY vbeln = st_vbrk-vgbel
                                                   posnr = lv_posnr
                                                   parvw = c_pf_we
                                                   BINARY SEARCH.
  ENDIF.
  IF sy-subrc = 0.
    st_cre_cred_memo-partner   = st_vbpa-kunnr. "Partner-Shipto party
    st_cre_cred_memo-parvw     = st_vbpa-parvw. " Partner Function
  ENDIF. " IF sy-subrc = 0
  st_cre_cred_memo-vbeln     = st_vbrk-vbeln. " Billing Number
  st_cre_cred_memo-posnr     = st_vbrk-posnr. " Item number of the Billing document
  st_cre_cred_memo-matnr     = st_vbrk-matnr. " Material Number
  st_cre_cred_memo-xblnr = st_vbrk-xblnr.
  st_cre_cred_memo-vbtyp = st_vbrk-vbtyp.
  CLEAR st_vbap.
  READ TABLE i_vbap INTO st_vbap WITH  KEY vbeln = st_vbrk-vgbel
                                           posnr = st_vbrk-vgpos
                                           BINARY SEARCH .
  IF sy-subrc EQ 0.
    CLEAR st_vbak.
    READ TABLE i_vbak INTO st_vbak WITH KEY vbeln = st_vbap-vbeln
                                            BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_cre_cred_memo-vkorg     = st_vbak-vkorg. " Sales Organization
      st_cre_cred_memo-vtweg     = st_vbak-vtweg. " Distribution Channel
      st_cre_cred_memo-spart     = st_vbak-spart. " Division
      st_cre_cred_memo-bstnk     = st_vbak-bstnk. " Customer Po
*      st_cre_cred_memo-auart     = st_vbak-auart. "Doc type
      st_cre_cred_memo-customer  = st_vbak-kunnr. " Customer Number
      st_cre_cred_memo-vkbur     = st_vbak-vkbur. " Sales office
      st_cre_cred_memo-xblnr     = st_vbak-vbeln. "Sales doc
      st_cre_cred_memo-augru    = st_vbak-augru.  "Order reason
      st_cre_cred_memo-zmeng = st_vbap-zmeng.
    ENDIF.
    CLEAR st_vbkd.
    READ TABLE i_vbkd INTO st_vbkd WITH KEY vbeln = st_vbap-vbeln
                                            posnr = st_vbap-posnr
                                            BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_cre_cred_memo-bsark     = st_vbkd-bsark.     "Customer PO
      st_cre_cred_memo-ihrez_e     = st_vbkd-ihrez_e. " Your ref
      st_cre_cred_memo-posex_e     = st_vbkd-posex_e. " PO Item
      st_cre_cred_memo-vgbel       = st_vbkd-vbeln.   " Reference doc
      st_cre_cred_memo-zlsch       = st_vbkd-zlsch.   "Payment method
      st_cre_cred_memo-kdkg3       = st_vbkd-kdkg3.   "Customer group3
    ENDIF.

    CLEAR  lv_name.
*--*Read Item text
    CONCATENATE  st_vbap-vbeln st_vbrk-posnr INTO lv_name.
    CONDENSE lv_name NO-GAPS.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = v_tdid
        language                = sy-langu
        name                    = lv_name
        object                  = lc_vbbp
      TABLES
        lines                   = li_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7.

    IF sy-subrc IS INITIAL.
      CLEAR lv_line.
      LOOP AT li_lines INTO DATA(lst_lines_item1).
        CONCATENATE lv_line lst_lines_item1-tdline INTO lv_line.
      ENDLOOP. " LOOP AT li_lines INTO DATA(lst_lines_item1)
      CONDENSE lv_line.
      st_cre_cred_memo-text = lv_line.
    ENDIF. " IF sy-subrc IS INITIAL

    APPEND st_cre_cred_memo TO i_final_crme_crt.
    CLEAR : st_cre_cred_memo-vbeln.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBRK  text
*----------------------------------------------------------------------*
FORM f_map_header .
  DATA: li_lines TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_line  TYPE tdline,                  " Text Line
        lv_name  TYPE tdobname.                " Name
  CONSTANTS:lc_posnr TYPE posnr VALUE '000000', " Item number of the SD document
            lc_auart TYPE auart VALUE 'ZCR',    " Item number of the SD document
            lc_vbbk  TYPE thead-tdobject VALUE 'VBBK'.

  st_cre_cred_memo-auart     = lc_auart.       " Doc type
  st_cre_cred_memo-zlsch     = st_vbrk-zlsch. " Payment method
  st_cre_cred_memo-xblnr     = st_vbrk-xblnr. " Ref.document
  st_cre_cred_memo-vbeln     = st_vbrk-vbeln. " Sales and Distribution Document Number
  st_cre_cred_memo-posnr     = lc_posnr.       " Item number of the SD document
  CLEAR st_vbap.
*--*Read and Map sales document data
  READ TABLE i_vbap INTO st_vbap WITH  KEY vbeln = st_vbrk-vgbel
                                           posnr = st_vbrk-vgpos
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    CLEAR st_vbak.
    READ TABLE i_vbak INTO st_vbak WITH KEY vbeln = st_vbap-vbeln
                                            BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_cre_cred_memo-vkorg     = st_vbak-vkorg. " Sales Organization
      st_cre_cred_memo-vtweg     = st_vbak-vtweg. " Distribution Channel
      st_cre_cred_memo-spart     = st_vbak-spart. " Division
      st_cre_cred_memo-bstnk     = st_vbak-bstnk. " Division
      st_cre_cred_memo-vkbur     = st_vbak-vkbur. " Sales Office
      st_cre_cred_memo-augru     =  st_vbak-augru. "reason For rejection
      st_cre_cred_memo-customer  = st_vbak-kunnr. " Customer Number
      v_kunnr                    = st_vbak-kunnr. " Customer Number
      st_cre_cred_memo-parvw     = c_pf_ag. " Partner Function
      st_cre_cred_memo-zmeng = st_vbap-zmeng.
    ENDIF.
    CLEAR st_vbkd.
*--*Read sales business data
    READ TABLE i_vbkd INTO st_vbkd WITH KEY vbeln = st_vbap-vbeln
                                             posnr = st_vbap-posnr
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_cre_cred_memo-bsark       = st_vbkd-bsark.     " Po type
      st_cre_cred_memo-vgbel       = st_vbkd-vbeln.     " Reference doc
      st_cre_cred_memo-zlsch       = st_vbkd-zlsch.     "Payment method
      st_cre_cred_memo-kdkg3       = st_vbkd-kdkg3.    "Customer group3
    ENDIF.
    APPEND st_cre_cred_memo TO i_final_crme_crt.
    CLEAR st_cre_cred_memo.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_ITEMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_items .
  DATA : lv_posnr      TYPE posnr VALUE 000000,
         lv_item_check TYPE c,
         lv_total      TYPE kwert.
  CLEAR : st_vbap, lv_item_check.
  LOOP AT i_vbap INTO st_vbap WHERE matnr = st_cre_cred_memo-matnr.
    CLEAR st_vbak.
    READ TABLE i_vbak INTO st_vbak WITH KEY vbeln =  st_vbap-vbeln
                                            bstnk  = st_cre_cred_memo-bstnk.
    IF sy-subrc EQ 0.
      IF st_vbak-auart = c_zsub.
        CONTINUE.
      ENDIF.
      st_vbrk-vbtyp = c_g.
      st_cre_cred_memo-vbtyp = st_vbrk-vbtyp.
      st_cre_cred_memo-zmeng = st_vbap-zmeng."lv_qty.
      st_cre_cred_memo-augru    = st_vbak-augru."Order reason

      CLEAR st_vbpa.
      READ TABLE i_vbpa INTO st_vbpa WITH KEY vbeln = st_vbap-vbeln
                                              posnr = st_vbap-posnr
                                              parvw = c_pf_we
                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE i_vbpa INTO st_vbpa WITH KEY vbeln = st_vbap-vbeln
                                                posnr = lv_posnr
                                                parvw = c_pf_we
                                               BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        st_cre_cred_memo-partner = st_vbpa-kunnr.
      ENDIF.
*--*Filter by ShipTo
      IF s_shp_to[] IS NOT INITIAL.
        IF st_vbpa-kunnr NOT IN s_shp_to.
          CONTINUE.
        ENDIF.
      ENDIF.
      st_cre_cred_memo-posnr = st_vbap-posnr.
      st_cre_cred_memo-xblnr = st_vbap-vbeln.
*--* Read VBKD
      CLEAR st_vbkd.
      READ TABLE i_vbkd INTO st_vbkd WITH KEY vbeln = st_vbap-vbeln
                                              posnr = st_vbap-posnr
                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_cre_cred_memo-ihrez_e     = st_vbkd-ihrez_e. " Your ref
        st_cre_cred_memo-posex_e     = st_vbkd-posex_e. " PO Item
        st_cre_cred_memo-zlsch       = st_vbkd-zlsch.   "Payment method
        st_cre_cred_memo-kdkg3       = st_vbkd-kdkg3.   "Customer group3
      ENDIF.
*- Access Fee
      CLEAR : st_konv,st_cre_cred_memo-kbetr1.
      READ TABLE i_konv INTO st_konv WITH KEY knumv = st_vbak-knumv
                                              kposn = st_vbap-posnr
                                              kschl = c_zacc
                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_cre_cred_memo-kbetr1 = st_konv-kwert.
      ENDIF.
*- Content Feee
      CLEAR: st_konv,st_cre_cred_memo-kbetr2.
      READ TABLE i_konv INTO st_konv WITH KEY knumv = st_vbak-knumv
                                              kposn = st_vbap-posnr
                                              kschl = c_zcon
                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_cre_cred_memo-kbetr2 = st_konv-kwert.
      ENDIF.
*- Hosting Fee
      CLEAR : st_konv,st_cre_cred_memo-kbetr3.
      READ TABLE i_konv INTO st_konv WITH KEY knumv = st_vbak-knumv
                                              kposn = st_vbap-posnr
                                              kschl = c_zhos
                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_cre_cred_memo-kbetr3 = st_konv-kwert.
      ENDIF.
*--*Discount
      CLEAR : st_konv,st_cre_cred_memo-discount.
      READ TABLE i_konv INTO st_konv WITH KEY knumv = st_vbak-knumv
                                               kposn = st_vbap-posnr
                                               kschl = c_zpqa
                                               BINARY SEARCH.
      IF sy-subrc EQ 0."right now discount maintained as value in ZMBR lines
*--*Remove Negative symbol
        IF st_konv-kwert LT 0.
          st_konv-kwert = st_konv-kwert * -1.
        ENDIF.
        st_cre_cred_memo-discount = st_konv-kwert.
      ENDIF.
*--*Discount Percentage
      CLEAR : st_cre_cred_memo-disc_per.
      IF st_cre_cred_memo-discount IS NOT INITIAL.
        CLEAR : lv_total.
*--*Access Fee + Hosting Fee + Content Fee
        lv_total = st_cre_cred_memo-kbetr1 + st_cre_cred_memo-kbetr2 + st_cre_cred_memo-kbetr3.
        TRY.
            st_cre_cred_memo-disc_per = ( st_cre_cred_memo-discount / lv_total ) * 100.
          CATCH cx_sy_arithmetic_error INTO DATA(exc).
        ENDTRY.
      ENDIF.
*--*Flag Check for ZMBR, since already ZSUB is updated if there is no ZMBR for that line
*--*deleting corresponding ZSUB after loop.
      lv_item_check = c_x. "It means an item (ZMBR) Is available
      APPEND st_cre_cred_memo TO i_final_crme_crt.
    ENDIF.
    CLEAR st_vbap.
  ENDLOOP.
*--*If there are no items(ZMBR) then delete header(ZSUB) too.
  IF lv_item_check IS INITIAL.
    DELETE i_final_crme_crt WHERE posnr = st_cre_cred_memo-posnr.
  ENDIF.
  CLEAR  st_cre_cred_memo.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT_ID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  CONSTANTS  : lc_textid   TYPE rvari_vnam VALUE 'TEXT_ID',
               lc_lines    TYPE rvari_vnam VALUE 'LINE_ITEMS',
               lc_item_cat TYPE rvari_vnam VALUE 'ITEM_CAT',
*--*Begin of change ERP-7680 - ED1K908253 - 8/23/2018
               lc_fg_lines TYPE rvari_vnam VALUE 'FG_LINES_LIMIT'.
  IF i_const IS INITIAL.
    CLEAR : v_tdid,v_lines,v_item_cat,v_fg_lines_limit.
    SELECT devid                      "Development ID
            param1                     "ABAP: Name of Variant Variable
            param2                     "ABAP: Name of Variant Variable
            srno                       "Current selection number
            sign                       "ABAP: ID: I/E (include/exclude values)
            opti                       "ABAP: Selection option (EQ/BT/CP/...)
            low                        "Lower Value of Selection Condition
            high                       "Upper Value of Selection Condition
            activate                   "Activation indicator for constant
            FROM zcaconstant           " Wiley Application Constant Table
            INTO TABLE i_const
            WHERE devid    = c_devid
            AND   activate = c_x. "Only active record
    IF sy-subrc EQ 0.
      SORT i_const BY devid param1.
*--*Text ID
      READ TABLE i_const INTO st_const WITH KEY devid = c_devid
                                                param1 = lc_textid
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_tdid = st_const-low.
      ENDIF.
*--*number of item lines to be considered to create credit memo
      READ TABLE i_const INTO st_const WITH KEY devid = c_devid
                                                param1 = lc_lines
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_lines = st_const-low.
      ENDIF.
*--*Item category to be considered to create credit memo
      READ TABLE i_const INTO st_const WITH KEY devid = c_devid
                                                param1 = lc_item_cat
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_item_cat = st_const-low.
      ENDIF.
*--*Number of lines to be considered for forground execution
      READ TABLE i_const INTO st_const WITH KEY devid = c_devid
                                                param1 = lc_fg_lines
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_fg_lines_limit = st_const-low.
      ENDIF.
    ENDIF.
  ENDIF.
*--*End of change ERP-7680 - ED1K908253 - 8/23/2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_check_po_entered.
  IF rb_dcmr IS NOT INITIAL.
    IF s_po IS INITIAL.
      MESSAGE text-092 TYPE c_i.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_EMAIL_ENTERED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_check_email_entered .
  IF p_mail IS INITIAL.
    MESSAGE text-092 TYPE c_i.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CURRENCY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_currency .
  CLEAR : v_curr.
  READ TABLE i_final_crme_cmr INTO DATA(lst_final) INDEX 1.
  IF sy-subrc EQ 0.
    SELECT SINGLE waerk INTO v_curr FROM vbak WHERE vbeln = lst_final-vgbel.
    IF sy-subrc NE 0.
      v_curr = c_usd.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_COND_GROUP_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_cond_group_value .
  IF i_final_crme_cmr IS NOT INITIAL.
    SELECT vbeln
           posnr
           kdkg1
           kdkg2
           kdkg3
           kdkg4
           kdkg5
     FROM  vbkd
     INTO TABLE i_cond
      FOR ALL ENTRIES IN i_final_crme_cmr
     WHERE vbeln EQ i_final_crme_cmr-vgbel
     AND   posnr EQ i_final_crme_cmr-posnr.
  ENDIF.

  SORT i_cond BY vbeln posnr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_COPY_CONTROL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_SPLIT  text
*----------------------------------------------------------------------*
FORM f_call_copy_control  USING    fp_lv_vbeln TYPE vbeln_vf.
  DATA : lv_doc_type TYPE bapisdhd1-doc_type VALUE 'ZCR'.
  REFRESH : i_copy_vbap, i_copy_return.
  CALL FUNCTION 'ZQTC_SD_COPY_CONTROL'
    EXPORTING
      im_salesdocument = fp_lv_vbeln
*     IM_SALESDOCITEM  =
      im_documenttype  = lv_doc_type
    TABLES
*     T_VBAK           =
      t_vbap           = i_copy_vbap
*     T_VBKD           =
*     T_VBPA           =
      t_return         = i_copy_return.
*  SORT i_copy_vbap BY vbeln posnr.
ENDFORM.
