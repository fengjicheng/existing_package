*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_WLS_ORDER_UPLOAD_E250 (Main Program)
* PROGRAM DESCRIPTION : Create  contracts for WLS Project
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 06/26/2020
* OBJECT ID           : E250
* TRANSPORT NUMBER(S) : ED2K918622
*----------------------------------------------------------------------*

FORM f_f4_file_name  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download 1

* Popup for file path

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
*&-----------------------------------*
*&      Form  F_CONVERT_EXCEL
*&-----------------------------------*
*       Convert Excel
*-----------------------------------*
*      ->P_P_FILE  text
*      <-P_I_FINAL  text
*-----------------------------------*
FORM f_convert_new_ord_excel USING fp_p_file  TYPE rlgrap-filename " Local file for upload/download 5
                               CHANGING fp_i_final TYPE tt_excel_ord.

  DATA :    li_excel        TYPE STANDARD TABLE OF zqtc_alsmex_tabline " Rows for Table with Excel Data
                                  INITIAL SIZE 0,                  " Rows for Table with Excel Data
            lst_excel_dummy TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
            lst_excel       TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
            lst_final       TYPE ty_excel_ord,
            lv_posnr1       TYPE posnr,
            lv_incpo        TYPE incpo,
            lv_ole          TYPE char1.

  WHILE lv_ole IS INITIAL.
    CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 2       " File contains header
*       i_end_col               = 35      " NPOLINA 5/May/2019 Added DEV ID field ED2K915113
        i_end_col               = 36
        i_end_row               = 65000
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc EQ 0.
      IF li_excel[] IS NOT INITIAL.

        CLEAR lst_final.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          IF lst_excel_dummy-value(1) EQ text-sqt.
            lst_excel_dummy-value(1) = space.
            SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
          ENDIF. " IF lst_excel_dummy-value(1) EQ '''

          AT NEW col.
            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT lst_final IS INITIAL.
                  lst_final-posnr = lv_posnr1.
                  APPEND lst_final TO fp_i_final.
                  CLEAR lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL

                lst_final-uid = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

                IF lst_final-uid EQ 'H'.
                  CLEAR:lv_posnr1.
                ELSEIF lst_final-uid = 'D'.
                  lv_posnr1 = lv_posnr1 + lv_incpo.
                  lst_final-posnr = lv_posnr1.
                ENDIF.

              WHEN 2.
                lst_final-auart = lst_excel_dummy-value.
                IF lv_incpo IS INITIAL AND lst_final-auart IS NOT INITIAL.
                  SELECT SINGLE    " Sales Document Type
                          incpo   " Increment of item number in the SD document
                     FROM tvak    " Sales Document Types
                     INTO  lv_incpo
                     WHERE auart EQ lst_final-auart.
                  IF sy-subrc IS NOT INITIAL.
*     Nothing to do
                  ENDIF. " IF sy-subrc IS INITIAL
                ENDIF.
                CLEAR: lst_excel_dummy.
              WHEN 3.
                lst_final-spart = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 4.
                lst_final-bstkd = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 5.
                lst_final-kunnr_sp = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 6.
                lst_final-kunnr_we = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 7.
                lst_final-vkbur = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 8.
                lst_final-augru = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 9.
                lst_final-guebg = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 10.
                lst_final-gueen = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 11.
                lst_final-faksk = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 12.
                lst_final-matnr = lst_excel_dummy-value.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-matnr
                  IMPORTING
                    output = lst_final-matnr.

                CLEAR lst_excel_dummy.

              WHEN 13.
                lst_final-kwmeng = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.
                IF lst_final-kwmeng LE 0.
                  MESSAGE 'Please check the file, Item Qty cannot be zero.'(123) TYPE 'I' DISPLAY LIKE 'E'.
                  LEAVE LIST-PROCESSING.
                ENDIF.
              WHEN 14.
                lst_final-arktx = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 15.
                lst_final-kdmat = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 16.
                lst_final-vkaus = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 17.
                lst_final-guebg_itm = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 18.
                lst_final-gueen_itm = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 19.
                lst_final-faksp = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 20.
                lst_final-kbetr = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 21.
                lst_final-kschl = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 22.
                lst_final-kbetr2 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 23.
                lst_final-kschl2 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 24.
                lst_final-kbetr3 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 25.
                lst_final-parvw = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 26.
                lst_final-partner = lst_excel_dummy-value.
                TRANSLATE lst_final-partner TO UPPER CASE.
                CLEAR lst_excel_dummy.

              WHEN 27.
                lst_final-name1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 28.
                lst_final-name2 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 29.
                lst_final-street = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 30.
                lst_final-city1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 31.
                lst_final-post_code1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 32.
                lst_final-regio = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 33.
                lst_final-land1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 34.
                lst_final-tzone = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 35.
                lst_final-disc = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

                IF NOT lst_final IS INITIAL.
                  APPEND lst_final TO fp_i_final.
                  CLEAR: lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL
            ENDCASE.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
* For last row population
        IF lst_final IS NOT INITIAL.

          APPEND lst_final TO fp_i_final.
          CLEAR lst_final.
        ENDIF. " IF lst_final IS NOT INITIAL
      ENDIF. " IF li_excel[] IS NOT INITIAL
      lv_ole = abap_true.
    ELSE.

      v_log = 'ERROR : Input file could not read'(061).
    ENDIF. " IF sy-subrc EQ 0
  ENDWHILE.
* SOC by NPOLINA 27/May/2019   ED2K915113
*  IF v_devid IS INITIAL.
*    MESSAGE 'Please check the file, Development ID cannot be blank.'(125) TYPE 'I' DISPLAY LIKE 'E'.
*    LEAVE LIST-PROCESSING.
*  ENDIF.
* EOC by NPOLINA 27/May/2019   ED2K915113
ENDFORM.
*&-----------------------------------*
*&      Form  DISPLAY_NEW_data_ORD_ALV
*&-----------------------------------*
*       text
*-----------------------------------*
*  ->  p1        text
*  <-  p2        text
*-----------------------------------*
FORM f_display_new_data_ord_alv .  "6
  DATA:lst_final TYPE ty_excel_ord.
  REFRESH i_fcat_out.

  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers


  PERFORM f_buildcat USING:
            lv_counter 'AUART'     'Document Type'(023)    , "document type
            lv_counter 'SPART'     'Division'(027)    ,       "division
            lv_counter 'BSTKD'     'Customer PO'(024)    , "purchase document number
            lv_counter 'KUNNR_SP'  'Sold-to Party'(h02)    , "Sold to
            lv_counter 'KUNNR_WE'  'Ship-to party'(056)    , "SHip to
            lv_counter 'VKBUR'     'Sales Office'(063)    ,  "Sales Office
            lv_counter 'AUGRU'     'Order Reason'(022)    , "Order reason
            lv_counter 'GUEBG'     'Contract Start Date'(015)    , "Contract start date
            lv_counter 'GUEEN'     'Contract End Date'(016)    , "Contract end date
            lv_counter 'FAKSK'     'Billing Block'(021)    , "billing block
            lv_counter 'MATNR'     'Material Number'(h04)    , " Material
            lv_counter 'KWMENG'    'Order Quantity'(014)    , "target quantity
            lv_counter 'ARKTX'     'Item text'(068)    , "Item Text
            lv_counter 'KDMAT'     'Material Used by Customer'(069)    , "Material Number Used by Customer
            lv_counter 'VKAUS'     'Usage Indicator'(070)    , "Usage Indicator
            lv_counter 'GUEBG_ITM' 'Contract Start Date'(015)    , "Contract start date
            lv_counter 'GUEEN_ITM' 'Contract End Date'(016)    , "Contract end date
            lv_counter 'FAKSP'     'Billing block for item'(071)    , "billing block Item
            lv_counter 'KBETR'     'Condition amount'(031)    , "pricing
            lv_counter 'KSCHL'     'Condition Type'(030)    , "pricing condition
            lv_counter 'KBETR2'    'Condition amount'(031)    , "pricing
            lv_counter 'KSCHL2'    'Condition Type'(030)    , "pricing condition
            lv_counter 'KBETR3'    'Condition amount'(031)    , "pricing
            lv_counter 'PARVW'     'Partner Type'(114)    , "Partner function   "ED2K914779
            lv_counter 'PARTNER'   'Partner'(050)    ,
            lv_counter 'NAME1'     'Name1'(072)     , " name1
            lv_counter 'NAME2'     'Name2'(073)     , " Name2
            lv_counter 'STREET'    'Street'(074)     , "STreet
            lv_counter 'CITY1'     'City'(075)     , " City
            lv_counter 'POST_CODE1' 'Postal Code'(076)    , " Postal Code
            lv_counter 'REGIO'      'Region'(077)    , " Region
            lv_counter 'LAND1'      'Country'(083)    , " Country
            lv_counter 'TZONE'      'Time ZOne'(084)    , "Time zone
            lv_counter 'DISC'      'Discount Notes'(097)    . " Discount Information

* fill up the ALV table
  LOOP AT i_final_ord INTO st_final_x.
    CLEAR: st_output_x.

    st_output_x-partner = st_final_x-partner. " Customer Number
    st_output_x-parvw    = st_final_x-parvw. " Partner Function
    st_output_x-kunnr_sp    = st_final_x-kunnr_sp. " Customer Number sold to
    st_output_x-kunnr_we    = st_final_x-kunnr_we. " Customer Number ship to

    st_output_x-spart    = st_final_x-spart. "division SAP mandatory
    WRITE st_final_x-guebg  TO st_output_x-guebg.
    WRITE st_final_x-gueen  TO st_output_x-gueen.
    WRITE st_final_x-guebg_itm  TO st_output_x-guebg_itm.
    WRITE st_final_x-gueen_itm  TO st_output_x-gueen_itm.

    st_output_x-matnr    = st_final_x-matnr. "Material
    st_output_x-kdmat    = st_final_x-kdmat. "Material used by customer
    st_output_x-arktx    = st_final_x-arktx. "Material description


    st_output_x-kwmeng    = st_final_x-kwmeng. "target quantity
    st_output_x-faksp    = st_final_x-faksp. "delivery block Wiley mandatory
    st_output_x-faksk    = st_final_x-faksk. "billing block Wiley mandatory
    st_output_x-augru    = st_final_x-augru. "reason for rejection
    st_output_x-auart    = st_final_x-auart. "Sales Document Type

    st_output_x-bstkd    = st_final_x-bstkd. "purchase order number Wiley mandatory
    st_output_x-kschl    = st_final_x-kschl. "Pricing condition value Wiley mandatory
    st_output_x-kbetr    = st_final_x-kbetr. "Pricing Wiley mandatory

    st_output_x-kschl2    = st_final_x-kschl2. "Pricing condition value Wiley mandatory
    st_output_x-kbetr2    = st_final_x-kbetr2. "Pricing Wiley mandatory

    st_output_x-kbetr3    = st_final_x-kbetr3. "Pricing Wiley mandatory

    st_output_x-vkbur    = st_final_x-vkbur.

    st_output_x-name1    = st_final_x-name1.
    st_output_x-name2    = st_final_x-name2.
    st_output_x-street    = st_final_x-street.
    st_output_x-city1    = st_final_x-city1.
    st_output_x-post_code1    = st_final_x-post_code1.
    st_output_x-regio    = st_final_x-regio.
    st_output_x-land1    = st_final_x-land1.
    st_output_x-tzone    = st_final_x-tzone.
    st_output_x-vkaus    = st_final_x-vkaus.
    st_output_x-disc    = st_final_x-disc.

    st_output_x-posnr    = st_final_x-posnr.

    APPEND st_output_x TO i_ord_alv.
    CLEAR st_output_x.
  ENDLOOP. " LOOP AT i_final INTO st_final_x

  IF    i_ord_alv[] IS NOT INITIAL
    AND i_fcat_out IS NOT INITIAL.

    st_layout-box_fieldname = 'SEL'.
    st_layout-colwidth_optimize = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'F_SET_PF_STATUS'
        i_callback_user_command  = 'F_USER_COMMAND'
        is_layout                = st_layout
        it_fieldcat              = i_fcat_out
      TABLES
        t_outtab                 = i_ord_alv
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.

      MESSAGE e000 WITH 'Material Description'(008).

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF i_output_x[] IS NOT INITIAL

ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------*
*       text
*-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position  7
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132

  CONSTANTS:  lc_tabname       TYPE tabname   VALUE 'I_ORD_ALV'. " Table Name

  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.

  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.  "8
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_user_command USING fp_ucomm        TYPE sy-ucomm       " ABAP System Field: PAI-Triggering Function Code 9
                          fp_st_selfields TYPE slis_selfield. " ABAP System Field: PAI-Triggering Function Code
  CASE fp_ucomm.
    WHEN 'UPDA'.

      DATA(li_output_x) = i_ord_alv.
      DELETE li_output_x WHERE sel NE abap_true.
      DATA(lv_lines) = lines( li_output_x ).
      IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL.
        PERFORM f_save_file_app_server_submit USING li_output_x.
        PERFORM f_send_notification.
        MESSAGE i555(zqtc_r2) WITH v_line_lmt sy-datum sy-uzeit v_job_name. " The no. of selected lines is greater than & so backgroung job scheduled
        SET SCREEN 0.
        LEAVE SCREEN.
      ELSE. " ELSE -> IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL
        PERFORM f_contract_createfromdata .
      ENDIF. " IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL

  ENDCASE.
ENDFORM.
*&-----------------------------------*
*&      Form  F_CONTRACT_CREATEFROMDATA
*&-----------------------------------*
*       text
*-----------------------------------*
*  ->  p1        text
*  <-  p2        text
*-----------------------------------*
FORM f_contract_createfromdata .

  TYPES: BEGIN OF lty_cond_class,
           kappl TYPE kappl,     " Application
           kschl TYPE kscha,     " Condition Type
           krech TYPE krech,     " Condition Class
         END OF lty_cond_class,

         BEGIN OF lty_mvke,
           matnr TYPE  matnr,    " Material Number
           vkorg TYPE  vkorg,    " Sales Organization
           vtweg TYPE vtweg,     " Distribution Channel
           dwerk TYPE dwerk_ext, " Delivering Plant (Own or External)
         END OF lty_mvke.
**====================================================================*
**       Local Internal Table
**====================================================================*
  DATA: li_return               TYPE STANDARD TABLE OF bapiret2,  " Return messages
        li_contract_itm         TYPE STANDARD TABLE OF bapisditm, "bapisditem, "bapisditm, " Item data
        li_contrchg_itm         TYPE STANDARD TABLE OF bapisditm, "bapisditm, " Item data
        li_contrchg_itmx        TYPE STANDARD TABLE OF bapisditmx, "bapisditm, " Item data
        li_contract_items_inx   TYPE STANDARD TABLE OF bapisditemx, "bapisditmx, " Communication Fields: Sales and Distribution Document Item
        li_contract_partn       TYPE STANDARD TABLE OF bapiparnr, "bapiparnr,  " Contract partner
        li_contract_data        TYPE STANDARD TABLE OF bapictr,     " Communciation Fields: SD Contract Data
        li_contract_data_inx    TYPE STANDARD TABLE OF bapictrx ,   " Communication fields: SD Contract Data Checkbox
        li_contract_cond        TYPE STANDARD TABLE OF bapicond, "bapicond,   " Contract conditions
        li_contract_condx       TYPE STANDARD TABLE OF bapicondx, "bapicond,   " Contract conditions
        li_extensionin          TYPE STANDARD TABLE OF bapiparex,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_text                 TYPE STANDARD TABLE OF bapisdtext, " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_text1                TYPE STANDARD TABLE OF bapisdtext,            " Communication fields: SD texts
        li_lines1               TYPE STANDARD TABLE OF tline  INITIAL SIZE 0, " SAPscript: Text Lines
        li_mvke                 TYPE STANDARD TABLE OF lty_mvke         INITIAL SIZE 0,
        li_bom_items            TYPE STANDARD TABLE OF ty_bom_items,
        li_cond_class           TYPE STANDARD TABLE OF lty_cond_class   INITIAL SIZE 0,
        li_contract_sched       TYPE STANDARD TABLE OF bapischedule   INITIAL SIZE 0,
        li_sales_schedules_in   TYPE STANDARD TABLE OF bapischdl,
        li_sales_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
*====================================================================*
*       Local Work-area
*====================================================================*
        lst_contract_sched      TYPE bapischedule,
        lst_contract_hdrin      TYPE bapisdhd1, " bapisdhd1,  " Header data
        lst_contract_hdrx       TYPE bapisdhd1x, " bapisdhd1,  " Header data
        lst_contchg_hdr         TYPE bapisdh1, " bapisdhd1,  " Header data
        lst_contchg_hdrx        TYPE bapisdh1x, " bapisdhd1,  " Header data
        lst_txt                 TYPE bapisdtext, " Communication fields: SD texts
        lst_txt1                TYPE bapisdtext, " Communication fields: SD texts
        lst_header1             TYPE thead,      " SAPscript: Text Header
        lst_lines1              TYPE tline,      " SAPscript: Text Lines
        lst_contract_hrdinx     TYPE bapisdhd1x, "bapisdhd1x, " Header data extended for promo code
        lst_contract_itm        TYPE bapisditm, "bapisditem, "bapisditm,  " Item data
        lst_contrchg_itm        TYPE bapisditm, "bapisditm,  " Item data
        lst_contrchg_itmx       TYPE bapisditmx, "bapisditm,  " Item data
        lst_contract_items_inx  TYPE bapisditemx, "bapisditm,  " Item data
        lst_sales_schedules_in  TYPE bapischdl,
        lst_sales_schedules_inx TYPE bapischdlx,
        lst_bape_vbak           TYPE bape_vbak,  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbap           TYPE bape_vbap,  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbapx          TYPE bape_vbapx, " BAPI Interface for Customer Enhancements to Table VBAK
        lst_extensionin         TYPE bapiparex,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_bape_vbakx          TYPE bape_vbakx, " BAPI Interface for Customer Enhancements to Table VBAKX
        lst_contract_partn      TYPE bapiparnr,   "bapiparnr,  " Contract partner
        lst_contract_cond       TYPE bapicond, "bapicond,   " Contract conditions
        lst_contract_data       TYPE bapictr,    " Contract Data
        lst_contract_data_inx   TYPE bapictrx, " Communication fields: SD Contract Data Checkbox
        lst_output_dummy        TYPE ty_ord_alv,
        lst_output_head         TYPE ty_ord_alv,
        lst_return              TYPE bapiret2, " For status of contract creation

*====================================================================*
*       Local Variable
*====================================================================*
        lv_salesdocin           TYPE bapivbeln-vbeln. "for export field

*====================================================================*
*       Local Constants
*====================================================================*
  CONSTANTS:lc_bape_vbak       TYPE char9  VALUE 'BAPE_VBAK',  " Bape_vbak of type CHAR9
            lc_bape_vbap       TYPE char9  VALUE 'BAPE_VBAP',  " Bape_vbak of type CHAR9
            lc_posnr           TYPE posnr  VALUE '000000',     " Item number of the SD document
            lc_bape_vbakx      TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
            lc_bape_vbapx      TYPE char10 VALUE 'BAPE_VBAPX', " Bape_vbak of type CHAR9
            lc_vbbp            TYPE char4 VALUE 'VBBP',    " Vbbp of type CHAR4
            lc_msgid           TYPE msgid VALUE 'ZQTC_R2', " Message identification
            lc_e               TYPE msgty VALUE 'E',       " Message Type
            lc_msgno           TYPE msgno VALUE '242',     " System Message Number
            lc_msgno2          TYPE msgno VALUE '260',     " System Message Number
            lc_tdid_eal        TYPE tdid VALUE '0012',
            lc_tdid_inv_header TYPE tdid VALUE '0007'.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR' "This FM will get the reference of the changed data in ref_grid
    IMPORTING
      e_grid = o_ref_grid.

  IF o_ref_grid IS NOT INITIAL.
    CALL METHOD o_ref_grid->check_changed_data( ).
  ENDIF. " IF o_ref_grid IS NOT INITIAL

** Get Increment of item number in the SD document*
  DATA(li_output) = i_ord_alv.

  DATA(lst_ord_alv) = i_ord_alv[ 1  ].



  IF li_output[] IS NOT INITIAL.
    SELECT kunnr,
           vkorg,
           vtweg,
           spart " Division
      FROM knvv  " Customer Master Sales Data
      INTO TABLE @DATA(li_knvv)
      WHERE vkorg = @p_vkorg
      AND vtweg = @p_vtweg
      AND spart EQ @lst_ord_alv-spart.

    IF sy-subrc EQ 0.
      SORT li_knvv[] BY kunnr vkorg vtweg spart.
    ENDIF.

    SELECT matnr,
           maktx
      FROM makt
      INTO TABLE @DATA(lt_makt)
      FOR ALL ENTRIES IN @li_output
      WHERE matnr = @li_output-matnr.
    IF sy-subrc EQ 0.
      SORT lt_makt[] BY matnr.
    ENDIF.
  ENDIF.
* Sort by Order Type
  SORT li_output BY auart.

  DELETE li_output WHERE auart IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_output COMPARING auart.
*
  IF li_output[] IS NOT INITIAL.
    SELECT auart,	 " Sales Document Type
           incpo   " Increment of item number in the SD document
      FROM tvak    " Sales Document Types
      INTO TABLE @DATA(li_tvak)
      FOR ALL ENTRIES IN @li_output
      WHERE auart EQ @li_output-auart.
    IF sy-subrc IS INITIAL.
      SORT li_tvak BY auart.
    ENDIF. " IF sy-subrc IS INITIAL

    CLEAR li_output.
    li_output =  i_ord_alv.

    SORT li_output BY kschl.
    DELETE ADJACENT DUPLICATES FROM li_output COMPARING kschl.
    IF li_output[] IS NOT INITIAL.
      SELECT kappl,	 " Application
           kschl,	 " Condition type
           krech   " Condition class
     FROM t685a    " Conditions: Types: Additional Price Element Data
     INTO TABLE @li_cond_class
     WHERE kappl EQ 'V'.
      IF sy-subrc IS INITIAL.
        SORT li_cond_class BY kschl. "  class
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF.
    CLEAR li_output.
    li_output = i_ord_alv.

    SORT li_output BY matnr .
    DELETE ADJACENT DUPLICATES FROM li_output COMPARING matnr.

    IF li_output IS NOT INITIAL.
      SELECT matnr, " Material Number
             vkorg, " Sales Organization
             vtweg, " Distribution Channel
             dwerk  " Plant
        FROM mvke   " Sales Data for Material
        INTO TABLE @li_mvke
        FOR ALL ENTRIES IN @li_output
        WHERE matnr = @li_output-matnr
        AND   vkorg = @p_vkorg
        AND   vtweg = @p_vtweg.

      IF sy-subrc IS INITIAL.
        SORT li_mvke BY matnr vkorg vtweg.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF li_output IS NOT INITIAL
  ENDIF.
*
  DATA(li_create_contract) = i_ord_alv.
  DELETE li_create_contract WHERE sel NE abap_true.
*
  IF li_create_contract IS INITIAL.
    MESSAGE 'Select Header and Line Items'(e19) TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF li_create_contract IS INITIAL
*
  LOOP AT li_create_contract INTO DATA(lst_output_x).
*    " This loop is run to populate the required internal tables for BAPI purchase doc. no. wise

    DATA(lv_index) = sy-tabix.

    CLEAR lst_output_dummy.
    lst_output_dummy = lst_output_x.
    IF lst_output_head IS INITIAL.
      lst_output_head = lst_output_x.
    ENDIF.
**   Whenever we see new header entry, we refresh the tables
    IF lst_output_dummy-auart  IS NOT INITIAL.
      CLEAR: lst_output_x.
      CLEAR: li_contract_itm,
             li_contrchg_itm,
             li_contrchg_itmx,
             li_contract_items_inx,
             li_contract_partn,
             li_contract_cond,
             li_contract_data,
             li_contract_data_inx,
             lst_contract_hdrin,
             lst_contchg_hdr,
             lst_contchg_hdrx,
             li_extensionin,
             li_text,
             li_text1,
             lst_contract_hrdinx,
             lst_contract_data,
             lst_contract_data_inx,
             lv_salesdocin,
             lv_salesdocin,
             lst_contchg_hdr,
             lst_contchg_hdrx,
             li_return,
             li_contrchg_itm,
             li_contrchg_itmx,
             li_contract_data,
             li_contract_data_inx,
             li_contract_sched,
             li_contract_cond,
             li_return,
             li_sales_schedules_in,
             lst_sales_schedules_in,
             li_sales_schedules_inx,
             lst_sales_schedules_inx.








    ENDIF. " IF lst_output_dummy-parvw EQ c_ag

*  Populate the Header records
    IF lst_output_dummy-posnr = '000000'
     OR lst_output_dummy-posnr  EQ space.

*====================================================================*
* Populate Header structure
*====================================================================*
      IF lst_contract_hdrin IS INITIAL.
        lst_contract_hdrin-doc_type   = lst_output_dummy-auart.
        lst_contract_hdrin-sales_org  = p_vkorg.
        lst_contract_hdrin-distr_chan = p_vtweg.
        lst_contract_hdrin-division   = lst_output_dummy-spart.
        lst_contract_hdrin-sales_off  = lst_output_dummy-vkbur.
        lst_contract_hdrin-purch_no_c = lst_output_dummy-bstkd.
        lst_contract_hdrin-bill_block = lst_output_dummy-faksk.
        lst_contract_hdrin-ord_reason = lst_output_dummy-augru.
        lst_contract_hdrin-created_by  = sy-uname.

        lst_contchg_hdr-sales_org  = p_vkorg.
        lst_contchg_hdr-distr_chan = p_vtweg.
        lst_contchg_hdr-division   = lst_output_dummy-spart.

        lst_contchg_hdrx-sales_org  = abap_true.
        lst_contchg_hdrx-distr_chan = abap_true.
        lst_contchg_hdrx-division   = abap_true.
        lst_contchg_hdrx-updateflag   = c_u.

        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_output_dummy-guebg
          IMPORTING
            date_internal            = lst_contract_hdrin-ct_valid_f
          EXCEPTIONS
            date_external_is_invalid = 1.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_contract_hdrin-ct_valid_f.
        ENDIF. " IF sy-subrc IS NOT INITIAL
        lst_contract_data-con_st_dat = lst_contract_hdrin-ct_valid_f.
        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_output_dummy-gueen
          IMPORTING
            date_internal            = lst_contract_hdrin-ct_valid_t
          EXCEPTIONS
            date_external_is_invalid = 1.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_contract_hdrin-ct_valid_t.
        ELSE.
          lst_contract_data-con_en_dat = lst_contract_hdrin-ct_valid_t.
        ENDIF. " IF sy-subrc IS NOT INITIAL
        IF lst_contract_data IS NOT INITIAL.
          APPEND lst_contract_data TO li_contract_data.
          lst_contract_data_inx-updateflag = c_u.
          lst_contract_data_inx-con_st_rul = abap_true.
          IF lst_contract_data-con_st_dat IS NOT INITIAL.
            lst_contract_data_inx-con_st_dat = abap_true.
          ENDIF.

          IF lst_contract_data-con_en_dat IS NOT INITIAL.
            lst_contract_data_inx-con_en_dat = abap_true.
          ENDIF.

        ENDIF.
*====================================================================*
*     Header INX structure population for Header
*====================================================================*
        CLEAR lst_contract_hrdinx.

        IF lst_contract_hdrin-doc_type  IS NOT INITIAL.
          lst_contract_hrdinx-doc_type = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-doc_type IS NOT INITIAL
          lst_contract_hrdinx-doc_type = abap_false.
        ENDIF. " IF lst_contract_hdrin-doc_type IS NOT INITIAL

        IF lst_contract_hdrin-sales_org IS NOT INITIAL.
          lst_contract_hrdinx-sales_org = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-sales_org IS NOT INITIAL
          lst_contract_hrdinx-sales_org = abap_false.
        ENDIF. " IF lst_contract_hdrin-sales_org IS NOT INITIAL

        IF lst_contract_hdrin-distr_chan IS NOT INITIAL.
          lst_contract_hrdinx-distr_chan = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-distr_chan IS NOT INITIAL
          lst_contract_hrdinx-distr_chan = abap_false.
        ENDIF. " IF lst_contract_hdrin-distr_chan IS NOT INITIAL

        IF lst_contract_hdrin-division  IS NOT INITIAL.
          lst_contract_hrdinx-division = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-division IS NOT INITIAL
          lst_contract_hrdinx-division = abap_false.
        ENDIF. " IF lst_contract_hdrin-division IS NOT INITIAL

        IF lst_contract_hdrin-sales_off IS NOT INITIAL.
          lst_contract_hrdinx-sales_off = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-sales_off IS NOT INITIAL
          lst_contract_hrdinx-sales_off = abap_false.
        ENDIF. " IF lst_contract_hdrin-sales_off IS NOT INITIAL

        IF lst_contract_hdrin-purch_no_c IS NOT INITIAL.
          lst_contract_hrdinx-purch_no_c = abap_true.
        ELSE. " ELSE -> IF lst_contract_hdrin-purch_no_c IS NOT INITIAL
          lst_contract_hrdinx-purch_no_c = abap_true.
        ENDIF. " IF lst_contract_hdrin-purch_no_c IS NOT INITIAL

        IF lst_contract_hdrin-bill_block IS NOT INITIAL.
          lst_contract_hrdinx-bill_block = abap_true.
        ENDIF.

        IF lst_contract_hdrin-ord_reason IS NOT INITIAL.
          lst_contract_hrdinx-ord_reason = abap_true.
        ENDIF.

        IF lst_contract_hdrin-ct_valid_t  IS NOT INITIAL.
          lst_contract_hrdinx-ct_valid_t = abap_true.
        ENDIF. " IF lst_contract_hdrin-ct_valid_t IS NOT INITIAL

        IF lst_contract_hdrin-ct_valid_f IS NOT INITIAL.
          lst_contract_hrdinx-ct_valid_f = abap_true.
        ENDIF. " IF lst_contract_hdrin-ct_valid_f IS NOT INITIAL

*====================================================================*
*     Populating Partner Table
*====================================================================*
        IF lst_output_dummy-kunnr_sp IS NOT INITIAL.
          lst_contract_partn-partn_role = c_sp.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_output_dummy-kunnr_sp
            IMPORTING
              output = lst_contract_partn-partn_numb.

          lst_contract_partn-itm_number = lc_posnr.

          APPEND lst_contract_partn TO li_contract_partn.
          CLEAR lst_contract_partn.
        ENDIF.

        IF lst_output_dummy-kunnr_we IS NOT INITIAL.
          lst_contract_partn-partn_role = c_we.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_output_dummy-kunnr_we
            IMPORTING
              output = lst_contract_partn-partn_numb.

          lst_contract_partn-itm_number = lc_posnr.

          APPEND lst_contract_partn TO li_contract_partn.
          CLEAR lst_contract_partn.
        ENDIF.

*     Get Increment of item number in the SD document
        IF lst_output_dummy-auart IS NOT INITIAL.
          DATA(lst_tvak) = li_tvak[ auart = lst_output_dummy-auart ].
        ENDIF. " IF lst_output_dummy-auart IS NOT INITIAL

      ELSE. " ELSE -> IF lst_contract_hdrin IS INITIAL
*====================================================================*
*     Populating Partner Table
*====================================================================*

        IF lst_output_dummy-kunnr_sp IS NOT INITIAL .
          lst_contract_partn-partn_role = c_sp.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_output_dummy-kunnr_sp
            IMPORTING
              output = lst_contract_partn-partn_numb.
          lst_contract_partn-itm_number = lc_posnr.
          APPEND lst_contract_partn TO li_contract_partn.
          CLEAR lst_contract_partn.
        ENDIF.
        IF lst_output_dummy-kunnr_we IS NOT INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
            EXPORTING
              input  = lst_output_dummy-parvw
            IMPORTING
              output = lst_output_dummy-parvw.

          lst_contract_partn-partn_role = c_we.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_output_dummy-kunnr_we
            IMPORTING
              output = lst_contract_partn-partn_numb.

          lst_contract_partn-itm_number = lc_posnr.

          APPEND lst_contract_partn TO li_contract_partn.
          CLEAR lst_contract_partn.
        ENDIF. "IF lst_output_dummy-parvw = c_sp.
      ENDIF. " IF lst_contract_hdrin IS INITIAL

    ELSE. " ELSE -> IF lst_output_dummy-posnr = '000000'
*====================================================================*
*      I T E M DATA
*====================================================================*


      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_output_dummy-posnr
        IMPORTING
          output = lst_output_dummy-posnr.

      READ TABLE li_contract_itm WITH KEY itm_number =
      lst_output_dummy-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc IS NOT INITIAL.
*====================================================================*
*    Check BOM to determine line item numbers
*====================================================================*
        READ TABLE li_mvke ASSIGNING FIELD-SYMBOL(<lfs_mvke>)
        WITH KEY matnr = lst_output_dummy-matnr        " Material Number
                 vkorg = lst_contract_hdrin-sales_org  " Sales Organization
                 vtweg = lst_contract_hdrin-distr_chan " Distribution Channel
                 BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          IF <lfs_mvke>-dwerk IS NOT INITIAL.
            PERFORM f_get_bom USING    lst_output_dummy-matnr
                                       <lfs_mvke>-dwerk
                                       lst_output_dummy-kwmeng
                                       lv_index
                                       lst_tvak-incpo
                              CHANGING li_create_contract
                                       li_bom_items.
          ENDIF. " IF <lfs_mvke>-dwerk IS NOT INITIAL
        ENDIF. " IF sy-subrc IS INITIAL

*====================================================================*
* First populate item table
*====================================================================*
        lst_contract_itm-itm_number  = lst_output_dummy-posnr.
        lst_contrchg_itm-itm_number  = lst_output_dummy-posnr.
        lst_contrchg_itmx-itm_number  = lst_output_dummy-posnr.
        lst_contract_itm-target_qty  = lst_output_dummy-kwmeng.

        lst_sales_schedules_in-itm_number  = lst_output_dummy-posnr.
        lst_sales_schedules_inx-itm_number = abap_true.
        lst_sales_schedules_in-req_qty     = lst_output_dummy-kwmeng.
        lst_sales_schedules_inx-req_qty    = abap_true.

        lst_contract_itm-material    = lst_output_dummy-matnr.
        lst_contract_itm-short_text    = lst_output_dummy-arktx.

        IF lst_output_dummy-arktx IS INITIAL. " If material text blank in Input file
          READ TABLE lt_makt ASSIGNING FIELD-SYMBOL(<lfs_makt>) WITH KEY matnr = lst_output_dummy-matnr BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_contract_itm-short_text    = <lfs_makt>-maktx.
          ENDIF.
        ENDIF.

        lst_contract_itm-usage_ind    = lst_output_dummy-vkaus.
        lst_contract_itm-cust_mat35    = lst_output_dummy-kdmat.
        lst_contract_itm-bill_block  = lst_output_dummy-faksp.
        lst_contract_itm-purch_no_c  = lst_output_dummy-bstkd.

        lst_contract_items_inx-itm_number = lst_contract_itm-itm_number.

        IF lst_contract_itm-material IS NOT INITIAL.
          lst_contract_items_inx-material = abap_true.
        ENDIF.
        IF lst_contract_itm-short_text IS NOT INITIAL.
          lst_contract_items_inx-short_text = abap_true.
        ENDIF.

        IF lst_contract_itm-bill_block IS NOT INITIAL.
          lst_contract_items_inx-bill_block = abap_true.
        ENDIF.

        IF lst_contract_itm-purch_no_c IS NOT INITIAL.
          lst_contract_items_inx-purch_no_c = abap_true.
        ENDIF.

        IF lst_contract_itm-usage_ind IS NOT INITIAL.
          lst_contract_items_inx-usage_ind  = abap_true.
        ENDIF.

        IF lst_contract_itm-cust_mat35 IS NOT INITIAL.
          lst_contract_items_inx-cust_mat35 = abap_true.
        ENDIF.

        IF  lst_contract_itm-target_qty IS NOT INITIAL.
          lst_contract_items_inx-target_qty = abap_true.
        ENDIF.

        APPEND lst_contract_itm TO li_contract_itm.
        CLEAR lst_contract_itm.

        APPEND lst_contract_items_inx TO li_contract_items_inx.
        CLEAR lst_contract_items_inx.

        APPEND lst_sales_schedules_in TO li_sales_schedules_in.
        CLEAR lst_sales_schedules_in.

        APPEND lst_sales_schedules_inx TO li_sales_schedules_inx.
        CLEAR lst_sales_schedules_inx.

        APPEND lst_contrchg_itm TO li_contrchg_itm.
        CLEAR lst_contrchg_itm.

        APPEND lst_contrchg_itmx TO li_contrchg_itmx.
        CLEAR lst_contrchg_itmx.

        lst_contract_sched-itm_number  = lst_output_dummy-posnr.

        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_output_dummy-guebg_itm
          IMPORTING
            date_internal            = lst_contract_sched-req_date
          EXCEPTIONS
            date_external_is_invalid = 1.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_contract_sched-req_date.
        ENDIF.
        APPEND lst_contract_sched TO li_contract_sched.
        CLEAR lst_contract_sched.

*====================================================================*
* Populate the conditions table
*====================================================================*
*COndition Type 1
        IF lst_output_dummy-kbetr > 0.
          lst_contract_cond-itm_number = lst_output_dummy-posnr.
          lst_contract_cond-cond_type  = p_kschl.

          READ TABLE li_cond_class ASSIGNING FIELD-SYMBOL(<lfs_cond>) "  class
          WITH KEY kschl = p_kschl
          BINARY SEARCH.
          IF sy-subrc IS INITIAL AND lst_output_dummy-kbetr > 0.
            IF <lfs_cond>-krech NE 'A'.
              lst_contract_cond-cond_value = lst_output_dummy-kbetr / 10.
            ELSE. " ELSE -> IF <lfs_cond>-krech NE 'A'
              lst_contract_cond-cond_value = lst_output_dummy-kbetr.
            ENDIF. " IF <lfs_cond>-krech NE 'A'
          ENDIF. " IF sy-subrc IS INITIAL

          APPEND lst_contract_cond TO li_contract_cond.
          CLEAR lst_contract_cond.
        ENDIF.
*COndition Type 2
        IF lst_output_dummy-kbetr2 > 0.
          lst_contract_cond-itm_number = lst_output_dummy-posnr.
          lst_contract_cond-cond_type  = lst_output_dummy-kschl.

          READ TABLE li_cond_class ASSIGNING FIELD-SYMBOL(<lfs_cond2>) "  class
          WITH KEY kschl = lst_output_dummy-kschl
          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <lfs_cond2>-krech NE 'A'.
              lst_contract_cond-cond_value = lst_output_dummy-kbetr2 / 10.
            ELSE. " ELSE -> IF <lfs_cond>-krech NE 'A'
              lst_contract_cond-cond_value = lst_output_dummy-kbetr2.
            ENDIF. " IF <lfs_cond>-krech NE 'A'
          ENDIF. " IF sy-subrc IS INITIAL

          APPEND lst_contract_cond TO li_contract_cond.
          CLEAR lst_contract_cond.
        ENDIF.
*COndition Type 3
        IF lst_output_dummy-kbetr3 > 0.
          lst_contract_cond-itm_number = lst_output_dummy-posnr.
          lst_contract_cond-cond_type  = lst_output_dummy-kschl2.

          READ TABLE li_cond_class ASSIGNING FIELD-SYMBOL(<lfs_cond3>) "  class
          WITH KEY kschl = lst_output_dummy-kschl2
          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <lfs_cond3>-krech NE 'A'.
              lst_contract_cond-cond_value = lst_output_dummy-kbetr3 / 10.
            ELSE. " ELSE -> IF <lfs_cond>-krech NE 'A'
              lst_contract_cond-cond_value = lst_output_dummy-kbetr3.
            ENDIF. " IF <lfs_cond>-krech NE 'A'
          ENDIF. " IF sy-subrc IS INITIAL

          APPEND lst_contract_cond TO li_contract_cond.
          CLEAR lst_contract_cond.
        ENDIF.
*====================================================================*
*      BAPI TEXT
*====================================================================*
        IF lst_output_dummy-disc IS NOT INITIAL.
          lst_txt-itm_number = lst_output_dummy-posnr.
          lst_txt-text_id    = p_tdid.
          lst_txt-langu      = sy-langu.
          lst_txt-format_col = c_format.
          lst_txt-text_line  = lst_output_dummy-disc.

          APPEND lst_txt TO li_text.
        ENDIF.
        IF li_bom_items IS NOT INITIAL AND lst_output_dummy-disc IS NOT INITIAL.
          LOOP AT li_bom_items ASSIGNING FIELD-SYMBOL(<lfs_bom>).

            lst_txt-itm_number = <lfs_bom>-old_posnr + lst_tvak-incpo.
            lst_txt-text_id    = p_tdid.
            lst_txt-langu      = sy-langu.
            lst_txt-format_col = c_format.
            lst_txt-text_line  = lst_output_dummy-disc.
            IF lst_txt-text_line IS NOT INITIAL.
              APPEND lst_txt TO li_text1.
            ENDIF.
            CLEAR  lst_txt.

          ENDLOOP. " LOOP AT li_bom_items ASSIGNING FIELD-SYMBOL(<lfs_bom>)
          REFRESH : li_bom_items.
        ENDIF. " IF li_bom_items IS NOT INITIAL

*====================================================================*
*     Populate Item Date
*====================================================================*
        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_output_dummy-guebg_itm
          IMPORTING
            date_internal            = lst_contract_data-con_st_dat
          EXCEPTIONS
            date_external_is_invalid = 1.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_contract_data-con_st_dat.
        ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL

          CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
            EXPORTING
              date_external            = lst_output_dummy-gueen_itm
            IMPORTING
              date_internal            = lst_contract_data-con_en_dat
            EXCEPTIONS
              date_external_is_invalid = 1.
          IF sy-subrc IS NOT INITIAL.
            CLEAR lst_contract_data-con_en_dat.
          ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
            lst_contract_data_inx-con_en_dat = abap_true.
            lst_contract_data_inx-con_en_rul = abap_true.
          ENDIF. " IF sy-subrc IS NOT INITIAL

          lst_contract_data-itm_number = lst_output_dummy-posnr.
          APPEND lst_contract_data TO li_contract_data.

          lst_contract_data_inx-itm_number = lst_output_dummy-posnr.
          lst_contract_data_inx-updateflag = c_u.
          lst_contract_data_inx-con_st_dat = abap_true.
          lst_contract_data_inx-con_st_rul = abap_true.
          APPEND lst_contract_data_inx TO li_contract_data_inx.
        ENDIF. " IF sy-subrc IS NOT INITIAL
*====================================================================*
*     Populate partner details
*====================================================================*
        IF lst_output_dummy-parvw IS NOT INITIAL.
          lst_contract_partn-partn_role = lst_output_dummy-parvw.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_output_dummy-partner
            IMPORTING
              output = lst_contract_partn-partn_numb.

*** Fetch Data from KNVV to chech if customer is extended to Sales Area or not
          READ TABLE li_knvv ASSIGNING FIELD-SYMBOL(<lfs_knvv>) WITH KEY kunnr = lst_contract_partn-partn_numb
                                                                         vkorg = lst_contract_hdrin-sales_org
                                                                         vtweg = lst_contract_hdrin-distr_chan
                                                                         spart = lst_contract_hdrin-division BINARY SEARCH.
          IF sy-subrc NE 0
            AND lst_output_dummy-parvw NE 'ZU'.
            st_err_msg-msgid = lc_msgid.
            st_err_msg-msgty = lc_e.
            st_err_msg-msgno = lc_msgno2.
            st_err_msg-msgv1 = lst_contract_partn-partn_numb.
            st_err_msg-msgv2 = p_vkorg.
            st_err_msg-msgv3 = lst_contract_hdrin-distr_chan.
            st_err_msg-msgv4 = lst_contract_hdrin-division.
            APPEND st_err_msg TO i_err_msg.

            CLEAR: st_err_msg.
            CONTINUE.
          ENDIF. " IF sy-subrc NE 0

          lst_contract_partn-itm_number = lst_output_dummy-posnr.
          lst_contract_partn-name = lst_output_dummy-name1.
          lst_contract_partn-name_2 = lst_output_dummy-name2.
          lst_contract_partn-street = lst_output_dummy-street.
          lst_contract_partn-city = lst_output_dummy-city1.
          lst_contract_partn-postl_code = lst_output_dummy-post_code1.
          lst_contract_partn-region = lst_output_dummy-regio.
          lst_contract_partn-country = lst_output_dummy-land1.

          APPEND lst_contract_partn TO li_contract_partn.
          CLEAR lst_contract_partn.
        ENDIF.
      ENDIF. " IF sy-subrc IS NOT INITIAL
    ENDIF. " IF lst_output_dummy-posnr = '000000'

*   Before a new header record/ last entry - Create contract
    IF lv_index EQ lines( li_create_contract ).
      DATA(lv_create_contract) = abap_true.
    ELSE. " ELSE -> IF lv_index EQ lines( li_create_contract )
      IF li_create_contract[ ( lv_index + 1 ) ]-auart IS NOT INITIAL.
        lv_create_contract = abap_true.
      ENDIF. " IF li_create_contract[ ( lv_index + 1 ) ]-parvw EQ c_ag
    ENDIF. " IF lv_index EQ lines( li_create_contract )

    IF lv_create_contract EQ abap_true.
      CLEAR lv_create_contract.
*====================================================================*
*     Call Bapi
*====================================================================*
      CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
        EXPORTING
          salesdocument         = lv_salesdocin
          sales_header_in       = lst_contract_hdrin
          sales_header_inx      = lst_contract_hrdinx
          status_buffer_refresh = 'X'
        IMPORTING
          salesdocument_ex      = lv_salesdocin
        TABLES
          return                = li_return
          sales_items_in        = li_contract_itm
          sales_items_inx       = li_contrchg_itmx
          sales_partners        = li_contract_partn
          sales_schedules_in    = li_sales_schedules_in
          sales_schedules_inx   = li_sales_schedules_inx
          sales_conditions_in   = li_contract_cond
          sales_conditions_inx  = li_contract_condx
          sales_text            = li_text
          sales_contract_in     = li_contract_data
          sales_contract_inx    = li_contract_data_inx.


      IF NOT li_return IS INITIAL.
        READ TABLE li_return INTO lst_return WITH KEY type = 'E'. " Return into lst_ of type
        IF sy-subrc IS INITIAL.
          st_err_msg-msgid = lst_return-id.
          st_err_msg-msgty = lst_return-type.
          st_err_msg-msgno = lst_return-number.
          st_err_msg-msgv1 = lst_return-message_v1.
          st_err_msg-msgv2 = lst_return-message_v2.
          st_err_msg-msgv3 = lst_return-message_v3.
          st_err_msg-msgv4 = lst_return-message_v4.
          APPEND st_err_msg TO i_err_msg.

          CLEAR: lst_return,
                 lst_output_head,
                 st_err_msg.
        ELSE. " ELSE -> IF sy-subrc IS INITIAL

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          READ TABLE li_return INTO lst_return WITH KEY type = 'S'. " Return into lst_ of type
          IF sy-subrc IS INITIAL.
            st_err_msg-wbeln = lv_salesdocin.
            st_err_msg-msgid = lst_return-id.
            st_err_msg-msgty = lst_return-type.
            st_err_msg-msgno = lst_return-number.
            st_err_msg-msgv1 = 'Order'(130).
            st_err_msg-msgv2 = lst_return-message_v2.
            st_err_msg-msgv3 = lst_return-message_v3.
            st_err_msg-msgv4 = lst_return-message_v4.
            APPEND st_err_msg TO i_err_msg.
            CLEAR: lst_return,
                   lst_output_head,
                   st_err_msg.

            IF li_text[] IS NOT INITIAL.
              LOOP AT li_text ASSIGNING FIELD-SYMBOL(<lfs_text>).
                <lfs_text>-doc_number = lv_salesdocin.
              ENDLOOP.
            ENDIF.
            FREE:li_return[].

          ENDIF. " IF sy-subrc IS INITIAL

        ENDIF. " IF sy-subrc IS INITIAL
        CLEAR:lst_output_head.
      ENDIF. " IF NOT li_return IS INITIAL

    ENDIF. " IF lv_create_contract EQ abap_true

  ENDLOOP  . " LOOP AT li_create_contract INTO DATA(lst_output_x)

  PERFORM f_send_email_move_file.

  CALL FUNCTION 'WLF_PRINT_ERROR_MESSAGES_LIST'
    EXPORTING
      i_titlebar       = v_titlebar
      i_report         = sy-cprog
    TABLES
      t_error_messages = i_err_msg
    EXCEPTIONS
      program_error    = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_READ_FROM_APP_SUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_from_app_srvr . "4
  DATA : lv_string    TYPE string,
         lv_flag      TYPE char1,
         lst_output_x TYPE ty_ord_alv.
  FIELD-SYMBOLS:<lfs_outpt> TYPE ty_ord_alv.

  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2). " File does not transfer to Application server
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0

  WHILE lv_flag IS INITIAL.
    READ DATASET p_a_file INTO lv_string.
    IF sy-subrc EQ 0.
      APPEND INITIAL LINE TO   i_ord_alv ASSIGNING <lfs_outpt> .
      SPLIT lv_string AT '|' INTO <lfs_outpt>-sel
            <lfs_outpt>-auart
            <lfs_outpt>-spart
            <lfs_outpt>-bstkd
            <lfs_outpt>-kunnr_sp
            <lfs_outpt>-kunnr_we
            <lfs_outpt>-vkbur
            <lfs_outpt>-augru
            <lfs_outpt>-guebg
            <lfs_outpt>-gueen
            <lfs_outpt>-faksk
            <lfs_outpt>-matnr
            <lfs_outpt>-kwmeng
            <lfs_outpt>-arktx
            <lfs_outpt>-kdmat
            <lfs_outpt>-vkaus
            <lfs_outpt>-guebg_itm
            <lfs_outpt>-gueen_itm
            <lfs_outpt>-faksp
            <lfs_outpt>-kbetr
            <lfs_outpt>-kschl
            <lfs_outpt>-kbetr2
            <lfs_outpt>-kschl2
            <lfs_outpt>-kbetr3
            <lfs_outpt>-parvw
            <lfs_outpt>-partner
            <lfs_outpt>-name1
            <lfs_outpt>-name2
            <lfs_outpt>-street
            <lfs_outpt>-city1
            <lfs_outpt>-post_code1
            <lfs_outpt>-regio
            <lfs_outpt>-land1
            <lfs_outpt>-tzone
            <lfs_outpt>-disc
            <lfs_outpt>-posnr.

    ELSE. " ELSE -> IF sy-subrc EQ 0
      lv_flag = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDWHILE.
  CLOSE DATASET p_a_file.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_log_email.
  DATA: lv_con_cret TYPE char2  VALUE cl_abap_char_utilities=>cr_lf, " Con_cret of type Character
        lst_message TYPE solisti1,                               " SAPoffice: Single List with Column Length 255
        lst_attach  TYPE solisti1.                               " SAPoffice: Single List with Column Length 255


  CONCATENATE 'Contract No'(087) 'Message ID'(088) 'Type'(091) 'Message no'(092) 'Status'(093) 'Message1'(094) 'Message2'(095)     INTO lst_attach SEPARATED BY ','.
  CONCATENATE lv_con_cret lst_attach INTO lst_attach.
  APPEND  lst_attach TO i_attach.
  CLEAR:lst_attach.

  LOOP AT i_err_msg_list INTO DATA(lst_err_msg).
    CONCATENATE lst_err_msg-wbeln lst_err_msg-msgid lst_err_msg-msgty lst_err_msg-msgno lst_err_msg-natxt lst_err_msg-msgv1 lst_err_msg-msgv2
    lst_err_msg-msgv3 lst_err_msg-msgv4
    INTO lst_attach SEPARATED BY ','.
    CONCATENATE lv_con_cret lst_attach INTO lst_attach.
    APPEND  lst_attach TO i_attach.
    CLEAR:lst_attach.
  ENDLOOP. " LOOP AT i_err_msg_list INTO DATA(lst_err_msg)

  v_job_name = p_job.

  PERFORM f_send_csv_xls_log.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log .
  DATA: lst_xdocdata     TYPE sodocchgi1,                           " Data of an object which can be changed
        lst_message      TYPE  solisti1,
        lv_xcnt          TYPE syst_index,                                    " Xcnt of type Integers
        lv_file_name     TYPE char100,                              " File_name of type CHAR100
        lst_usr21        TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6         TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        li_packing_list  TYPE TABLE OF sopcklsti1 , "Itab to hold packing list for email
        lst_packing_list TYPE sopcklsti1 , "Itab to hold packing list for email
        li_receivers     TYPE TABLE OF somlreci1 ,  "Itab to hold mail receipents
        lst_receivers    TYPE  somlreci1 ,  "Itab to hold mail receipents
        li_attachment    TYPE TABLE OF solisti1 ,   " SAPoffice: Single List with Column Length 255
        lst_attachment   TYPE solisti1 ,   " SAPoffice: Single List with Column Length 255
        lv_n             TYPE syst_index,                                    " N of type Integers
        lst_attach       TYPE  solisti1,
        lv_desc          TYPE so_obj_des.                           " Short description of contents

  CONSTANTS:lc_uc  TYPE char1 VALUE '_',
            lc_ep1 TYPE sy-sysid VALUE 'EP1'.
  IF sy-sysid NE lc_ep1.
    CONCATENATE sy-sysid 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY lc_uc.
  ELSE.
    CONCATENATE 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY lc_uc.
  ENDIF.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.
*- Populate message body text
  CLEAR i_message.
  REFRESH i_message.
  lst_message = 'Dear User,'(078). "Dear Wiley Customer,Please find Attachmen
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'JOB NAME:' v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  lst_message = 'Process completed.Please find the attachment.'(089).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'Thanks,'(080).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'WILEY ERP Team'(081).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  DESCRIBE TABLE i_attach LINES lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( lst_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = 'SAPRPT'.
  lst_xdocdata-obj_descr  = lv_desc.
  CLEAR li_attachment[].
  APPEND lst_attach TO i_attach.
  CLEAR:lst_attach.
  li_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR li_packing_list.
  lst_packing_list-transf_bin = space.
  lst_packing_list-head_start = 1.
  lst_packing_list-head_num = 0.
  lst_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES lst_packing_list-body_num.
  lst_packing_list-doc_type = 'RAW'.
  APPEND lst_packing_list TO li_packing_list.
  IF i_attach[] IS NOT INITIAL.
    lv_n = 1.
*- Create attachment notification
    lst_packing_list-transf_bin = abap_true.
    lst_packing_list-head_start = 1.
    lst_packing_list-head_num   = 1.
    lst_packing_list-body_start = lv_n.

    DESCRIBE TABLE i_attach LINES lst_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZORDER_UPLD' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    lst_packing_list-doc_type   =  'CSV'.
    lst_packing_list-obj_descr  =  lv_file_name. "p_attdescription.
    lst_packing_list-obj_name   =  lv_file_name. "."p_filename.
    lst_packing_list-doc_size   =  lst_packing_list-body_num * 255.
    APPEND lst_packing_list TO li_packing_list.
  ENDIF. " IF i_attach[] IS NOT INITIAL

  CLEAR : lst_usr21,
          lst_adr6.
  SELECT SINGLE addrnumber persnumber FROM usr21
    INTO ( lst_usr21-addrnumber ,lst_usr21-persnumber )
    WHERE bname = p_userid.
  IF sy-subrc EQ 0 AND lst_usr21 IS NOT INITIAL.
    SELECT SINGLE smtp_addr FROM adr6 INTO lst_adr6-smtp_addr WHERE addrnumber = lst_usr21-addrnumber
                                            AND   persnumber = lst_usr21-persnumber.
    IF   sy-subrc EQ 0 .

*- Add the recipients email address
      CLEAR lst_receivers.
      lst_receivers-receiver = lst_adr6-smtp_addr.
      lst_receivers-rec_type = 'U'.
      lst_receivers-com_type = 'INT'.
      lst_receivers-notif_del = abap_true.
      lst_receivers-notif_ndel = abap_true.
      APPEND lst_receivers TO li_receivers.

      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          document_data              = lst_xdocdata
          put_in_outbox              = abap_true
          commit_work                = abap_true
        TABLES
          packing_list               = li_packing_list
          contents_bin               = li_attachment
          contents_txt               = i_message
          receivers                  = li_receivers
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
        MESSAGE 'Country'(083) TYPE 'E'. "Error in sending Email
      ELSE. " ELSE -> IF sy-subrc NE 0
        MESSAGE 'Time ZOne'(084) TYPE 'S'. "Email sent with Success log file
      ENDIF. " IF sy-subrc NE 0
    ENDIF.
  ENDIF. " IF lst_usr21 IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_MOVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_move_file .

  DATA:
    lv_dirtemp   TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_path      TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_directory TYPE btcxpgpar,                               " Parameters of external program (string)                          " Directory of Files
    li_exec_move TYPE STANDARD TABLE OF btcxpm INITIAL SIZE 0. " Log message from external program to calling program

  IF p_a_file IS NOT INITIAL.

    lv_path = p_a_file.
    READ TABLE i_err_msg TRANSPORTING NO FIELDS WITH KEY msgty = c_e.
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF '/E205/in' IN lv_path WITH '/E205/err'.
    ELSE. " ELSE -> IF sy-subrc = 0
      REPLACE ALL OCCURRENCES OF '/E205/in' IN lv_path WITH '/E205/prc'.
    ENDIF. " IF sy-subrc = 0

    i_err_msg1 = i_err_msg.
    PERFORM transfer_add_error_msg IN PROGRAM saplwlf5
      TABLES i_err_msg1 i_err_msg_list.
    PERFORM f_send_log_email.
*
    lv_dirtemp = p_a_file.
    CONCATENATE lv_dirtemp
                lv_path
          INTO lv_directory
          SEPARATED BY space.

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = 'ZSSPMOVE'
        additional_parameters         = lv_directory
      TABLES
        exec_protocol                 = li_exec_move
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.

    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR: li_exec_move[],
           lv_directory,
           lv_dirtemp.
  ENDIF. " IF p_a_file IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_NOTIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_notification . "e205
  DATA: lst_xdocdata     TYPE sodocchgi1,                           " Data of an object which can be changed
        lst_message      TYPE solisti1,
        lv_xcnt          TYPE syst_index,                                    " Xcnt of type Integers
        lv_file_name     TYPE char100,                              " File_name of type CHAR100
        lst_usr21        TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6         TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        li_packing_list  TYPE TABLE OF sopcklsti1 ,                 "Itab to hold packing list for email
        lst_packing_list TYPE sopcklsti1 ,                         "Itab to hold packing list for email
        li_receivers     TYPE TABLE OF somlreci1 ,                  "Itab to hold mail receipents
        lst_receivers    TYPE somlreci1 ,                          "Itab to hold mail receipents
        li_attachment    TYPE TABLE OF solisti1 ,                   " SAPoffice: Single List with Column Length 255
        lst_attachment   TYPE solisti1 ,                            " SAPoffice: Single List with Column Length 255
        lv_n             TYPE syst_index,                                    " N of type Integers
        lv_desc          TYPE so_obj_des,                           " Short description of contents
        lc_ep1           TYPE sy-sysid VALUE 'EP1'.

  IF sy-sysid NE lc_ep1.
    CONCATENATE sy-sysid 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY '_'.
  ELSE.
    CONCATENATE 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY '_'.
  ENDIF.

*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.
*- Populate message body text
  CLEAR i_message.
  REFRESH i_message.
  lst_message = 'Dear User,'(078).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'Your order upload file is being processed through background job'(079) v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  CONCATENATE 'File name'(090) p_file INTO lst_message SEPARATED BY ':'.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  CONCATENATE 'Date & Time'(096) sy-datum sy-uzeit INTO lst_message SEPARATED BY ':'.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'Thanks,'(080).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'WILEY ERP Team'(081).
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Describe the body of the message
  CLEAR lst_packing_list.
  lst_packing_list-transf_bin = space.
  lst_packing_list-head_start = 1.
  lst_packing_list-head_num = 0.
  lst_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES lst_packing_list-body_num.
  lst_packing_list-doc_type = 'RAW'.
  APPEND lst_packing_list TO li_packing_list.
  CLEAR :
          lst_usr21,
          lst_adr6.
  p_userid = sy-uname.
  SELECT SINGLE addrnumber persnumber FROM usr21 INTO (lst_usr21-addrnumber,lst_usr21-persnumber ) WHERE bname = p_userid.
  IF sy-subrc EQ 0 AND lst_usr21 IS NOT INITIAL.
    SELECT SINGLE smtp_addr FROM adr6 INTO lst_adr6-smtp_addr WHERE addrnumber = lst_usr21-addrnumber
                                            AND   persnumber = lst_usr21-persnumber.
    IF sy-subrc EQ 0.
*- Add the recipients email address
      CLEAR lst_receivers.
      lst_receivers-receiver = lst_adr6-smtp_addr.
      lst_receivers-rec_type = 'U'.
      lst_receivers-com_type = 'INT'.
      lst_receivers-notif_del = abap_true.
      lst_receivers-notif_ndel = abap_true.
      APPEND lst_receivers TO li_receivers.

      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          document_data              = lst_xdocdata
          put_in_outbox              = abap_true
          commit_work                = abap_true
        TABLES
          packing_list               = li_packing_list
          contents_bin               = li_attachment
          contents_txt               = i_message
          receivers                  = li_receivers
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
        MESSAGE 'Country'(083) TYPE 'E'. "Error in sending Email
      ELSE. " ELSE -> IF sy-subrc NE 0
        MESSAGE 'Time Zone'(084) TYPE 'S'. "Email sent with Success log file
      ENDIF. " IF sy-subrc NE 0
    ENDIF. "sy-subrc eq 0
  ENDIF. " IF lst_usr21 IS NOT INITIAL
  CLEAR : li_packing_list,
          li_attachment,
          i_message,
          li_receivers.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING   fp_lv_filename.
  DATA : lv_path         TYPE filepath-pathintern .
  DATA:lv_path_fname TYPE string.
  CLEAR : lv_path_fname,
          lv_path.
  lv_path = v_e205_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = fp_lv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
    v_path_fname = lv_path_fname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_template
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_file_template .   "2
  CONSTANTS:lc_sorg    TYPE rvari_vnam VALUE 'SALES_ORG',
            lc_distch  TYPE rvari_vnam VALUE 'DIST_CHANNEL',
            lc_condtyp TYPE rvari_vnam VALUE 'COND_TYPE',
            lc_tdid    TYPE rvari_vnam VALUE 'TDID'.




  IF sy-ucomm ='FC01'.
* Start Excel
    CREATE OBJECT v_excel 'EXCEL.APPLICATION'.
    SET PROPERTY OF  v_excel  'Visible' = 1.

* get list of workbooks, initially empty
    CALL METHOD OF v_excel 'Workbooks' = v_mapl.
* add a new workbook
    CALL METHOD OF v_mapl 'Add' = v_map.

    CALL METHOD OF v_excel 'Columns' = v_column.
    CALL METHOD OF v_column 'Autofit'.

* output column headings to active Excel sheet
    PERFORM: f_fill_cell USING 1 1 1 'ID Column'(101),
    f_fill_cell USING 1 2 0 'Sales Document Type'(102),
    f_fill_cell USING 1 3 1 'Division'(027),
    f_fill_cell USING 1 4 1 'Customer PO number'(103),
    f_fill_cell USING 1 5 1 'Sold-to party'(104),
    f_fill_cell USING 1 6 1 'Ship-to party'(056),
    f_fill_cell USING 1 7 1 'Sales Office'(063),
    f_fill_cell USING 1 8 1 'Order reason'(105),
    f_fill_cell USING 1 9 1 'Contract start date'(106),
    f_fill_cell USING 1 10 1 'Contract end date'(107),
    f_fill_cell USING 1 11 1 'Billing block in SD document'(108),
    f_fill_cell USING 1 12 1 'Material Number'(H04),
    f_fill_cell USING 1 13 1 'Cumulative Order Quantity in Sales Units'(109),
    f_fill_cell USING 1 14 1 'Short text for sales order item'(110),
    f_fill_cell USING 1 15 1 'Material Number Used by Customer'(111),
    f_fill_cell USING 1 16 1 'Usage Indicator'(070),
    f_fill_cell USING 1 17 1 'Contract start date'(106),
    f_fill_cell USING 1 18 1 'Contract end date'(107),
    f_fill_cell USING 1 19 1 'Billing block for item'(071),
    f_fill_cell USING 1 20 1 'Rate (condition amount or percentage)'(112),
    f_fill_cell USING 1 21 1 'Condition type'(113),
    f_fill_cell USING 1 22 1 'Rate (condition amount or percentage)'(112),
    f_fill_cell USING 1 23 1 'Condition  type'(122),
    f_fill_cell USING 1 24 1 'Rate (condition amount or percentage)'(112),
    f_fill_cell USING 1 25 1 'Partner Type'(114),
    f_fill_cell USING 1 26 1 'Partner no'(115),
    f_fill_cell USING 1 27 1 'Name 1'(116),
    f_fill_cell USING 1 28 1 'Name 2'(117),
    f_fill_cell USING 1 29 1 'Street'(074),
    f_fill_cell USING 1 30 1 'City'(075),
    f_fill_cell USING 1 31 1 'City postal code'(118),
    f_fill_cell USING 1 32 1 'Region (State, Province, County)'(119),
    f_fill_cell USING 1 33 1 'Country Key'(120),
    f_fill_cell USING 1 34 1 'Address time zone'(121),
    f_fill_cell USING 1 35 1 'Discount Notes'(097),
    f_fill_cell USING 1 36 1 'Development ID'(124).  " DEVID  Knewton Project NPOLINA ED2K915113

    CALL METHOD OF v_excel 'Worksheets' = v_mapl.

    FREE OBJECT v_excel.
  ELSE.
    IF p_vkorg IS NOT INITIAL.
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_sorg1>) WITH KEY devid = c_devid
                                                param1 = lc_sorg
                                                low = p_vkorg
                                                BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR:p_vkorg.
      ENDIF.
    ENDIF.

    IF p_vtweg IS NOT INITIAL.
      SELECT SINGLE vtweg FROM tvtw INTO @DATA(lv_vtweg)
         WHERE vtweg = @p_vtweg.
      IF sy-subrc NE 0.
        MESSAGE 'Entered Distribute Channel is not valid'(128) TYPE 'E' DISPLAY LIKE 'S'.
      ENDIF.
    ENDIF.

    IF p_kschl IS NOT INITIAL.
      SELECT SINGLE kschl FROM t685 INTO @DATA(lv_kschl)
        WHERE  kschl = @p_kschl.
      IF sy-subrc NE 0.
        MESSAGE 'Entered Condition type is not valid'(127) TYPE 'E' DISPLAY LIKE 'S'.
      ENDIF.
    ENDIF.

    IF p_tdid IS NOT INITIAL.

    ENDIF.
  ENDIF.

ENDFORM.

*&-----------------------------------*
*&      Form  F_GET_BOM
*&-----------------------------------*
*       Check BOM and determine line item number accoringly
*-----------------------------------*
*      ->FP_MATNR  Material
*      ->FP_PLANT  Plant
*      ->FP_QUANTITY Quantity
*      ->FP_INDEX    Index
*      ->FP_INCPO    Increment of item number in the SD document
*      <-FP_I_OUTPUT  Output table with changed line items
*-----------------------------------*
FORM f_get_bom  USING    fp_matnr    TYPE matnr    " Material Number
                         fp_plant    TYPE werks_d  " Plant
                         fp_quantity TYPE char20   " Quantity of type CHAR17
                         fp_index    TYPE sy-tabix " ABAP System Field: Row Index of Internal Tables
                         fp_incpo    TYPE incpo    " Increment of item number in the SD document
                CHANGING fp_i_output TYPE tt_ord_alv
                         fp_bom_items TYPE tt_bom_items.

* Local Internal table for BOM
  DATA : li_bom      TYPE STANDARD TABLE OF stpox INITIAL SIZE 0, " BOM Items (Extended for List Displays)
* Local Work Area for BOM Explosions
         lst_topmat  TYPE cstmat, " Start Material Display for BOM Explosions
* Local Variable for target Quantity
         lv_quantity TYPE basmn. " Base quantity

* Move character format to quantity format
  lv_quantity = fp_quantity.

  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      capid                 = 'SD01'      " Application ID
      datuv                 = sy-datum    " Date
      emeng                 = lv_quantity " Quantity
      salww                 = abap_true
      mtnrv                 = fp_matnr    " Material
      rndkz                 = '2'         " Round off: ' '=always, '1'=never, '2'=only levels > 1
      werks                 = fp_plant    " Plant
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
  IF sy-subrc IS INITIAL.

* Delete items which are not Sales Relevant
    DELETE li_bom WHERE rvrel IS INITIAL.

    IF li_bom IS NOT INITIAL.

*  Get total number of BOM item
      DATA(lv_bom_lines) = lines( li_bom ).

      LOOP AT fp_i_output ASSIGNING FIELD-SYMBOL(<lfs_output>)
                                    FROM  fp_index.
        DATA(lv_tabix) = sy-tabix.

        IF <lfs_output>-parvw EQ 'AG' OR <lfs_output>-parvw EQ c_sp.
          EXIT.
        ENDIF. " IF <lfs_output>-parvw EQ 'AG'

        APPEND INITIAL LINE TO fp_bom_items ASSIGNING
        FIELD-SYMBOL(<lfs_bom_items>).
        IF <lfs_bom_items> IS ASSIGNED.
          <lfs_bom_items>-old_posnr =  <lfs_output>-posnr.
        ENDIF. " IF <lfs_bom_items> IS ASSIGNED

        IF lv_tabix NE fp_index.

          <lfs_output>-posnr = <lfs_output>-posnr + ( lv_bom_lines * fp_incpo ).
        ENDIF. " IF lv_tabix NE fp_index
        IF <lfs_bom_items> IS ASSIGNED.
          <lfs_bom_items>-new_posnr = <lfs_output>-posnr.
        ENDIF. " IF <lfs_bom_items> IS ASSIGNED
      ENDLOOP. " LOOP AT fp_i_output ASSIGNING FIELD-SYMBOL(<lfs_output>)
      CLEAR lst_topmat.
    ENDIF. " IF li_bom IS NOT INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE_APP_SERVER_SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_OUTPUT_X  text
*----------------------------------------------------------------------*
FORM f_save_file_app_server_submit  USING fp_li_output_x TYPE tt_ord_alv.
*** Local Constant Declaration
  CONSTANTS: lc_pipe       TYPE char1 VALUE '|',        " Tab of type Character
             lc_semico     TYPE char1 VALUE ';',    " Semico of type CHAR1
             lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv', " Extn of type CHAR4
             lc_job_name   TYPE btcjob VALUE 'ZORDER_UPLD'. " Background job name
**** Local field symbol declaration
  FIELD-SYMBOLS: <lfs_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        lv_length     TYPE syst_index,      " Length of type Integers
        lv_fnm        TYPE char70, " Fnm of type CHAR70
        li_final_csv  TYPE truxs_t_text_data.

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status

  LOOP AT fp_li_output_x ASSIGNING FIELD-SYMBOL(<lfs_outpt>).
    CLEAR:lst_final_csv.
    CONCATENATE
            <lfs_outpt>-sel
            <lfs_outpt>-auart
            <lfs_outpt>-spart
            <lfs_outpt>-bstkd
            <lfs_outpt>-kunnr_sp
            <lfs_outpt>-kunnr_we
            <lfs_outpt>-vkbur
            <lfs_outpt>-augru
            <lfs_outpt>-guebg
            <lfs_outpt>-gueen
            <lfs_outpt>-faksk
            <lfs_outpt>-matnr
            <lfs_outpt>-kwmeng
            <lfs_outpt>-arktx
            <lfs_outpt>-kdmat
            <lfs_outpt>-vkaus
            <lfs_outpt>-guebg_itm
            <lfs_outpt>-gueen_itm
            <lfs_outpt>-faksp
            <lfs_outpt>-kbetr
            <lfs_outpt>-kschl
            <lfs_outpt>-kbetr2
            <lfs_outpt>-kschl2
            <lfs_outpt>-kbetr3
            <lfs_outpt>-parvw
            <lfs_outpt>-partner
            <lfs_outpt>-name1
            <lfs_outpt>-name2
            <lfs_outpt>-street
            <lfs_outpt>-city1
            <lfs_outpt>-post_code1
            <lfs_outpt>-regio
            <lfs_outpt>-land1
            <lfs_outpt>-tzone
            <lfs_outpt>-disc
            <lfs_outpt>-posnr
        INTO lst_final_csv SEPARATED BY lc_pipe.

    APPEND lst_final_csv TO li_final_csv.
    CLEAR:lst_final_csv.
  ENDLOOP.

  CLEAR v_fpath.

  CONCATENATE 'ZORDER_UPLD'
              lc_underscore
              c_devid
              lc_underscore
              sy-uname
              lc_underscore
              sy-datum
              lc_underscore
              sy-uzeit
              lc_extn
              INTO
              v_path_fname.

  PERFORM f_get_file_path USING v_path_fname.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc EQ 0.
    LOOP AT li_final_csv INTO lst_final_csv.
      TRANSFER lst_final_csv TO v_path_fname.
    ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
    CLOSE DATASET v_path_fname.
  ENDIF.
**** Submit Program
  CLEAR lv_job_name.
  CONCATENATE lc_job_name '_' sy-datum '_' sy-uzeit '_' sy-uname  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Assignment number'(066).

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
    v_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcr_e205_order_upload
                                        WITH p_file  = p_file
                                        WITH p_vkorg = p_vkorg
                                        WITH p_vtweg = p_vtweg
                                        WITH p_kschl = p_kschl
                                        WITH p_tdid = p_tdid
                                        WITH p_a_file = v_path_fname
                                        WITH p_job    = p_job
                                        WITH p_userid = sy-uname
                                        USER  'QTC_BATCH01'
                                        VIA JOB lv_job_name NUMBER lv_job_number
                                        AND RETURN.
** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE' ##FM_SUBRC_OK
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
    IF sy-subrc = 0.

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.

*---------------------------------------------------------------------*
*       FORM FILL_CELL                                                *
*---------------------------------------------------------------------*
*       sets cell at coordinates i,j to value val boldtype bold       *
*---------------------------------------------------------------------*
FORM f_fill_cell USING fp_i fp_j fp_bold fp_val.
  DATA: lv_interior TYPE ole2_object,
        lv_borders  TYPE ole2_object.

  CALL METHOD OF v_excel 'Cells' = v_zl EXPORTING #1 = fp_i #2 = fp_j.

  SET PROPERTY OF v_zl 'Value' = fp_val .

  GET PROPERTY OF v_zl 'Font' = v_f.
  SET PROPERTY OF v_zl 'ColumnWidth' = 20.

  SET PROPERTY OF v_f 'Bold' = 1 .

  SET PROPERTY OF v_f 'COLORINDEX' = 1 .

  GET PROPERTY OF v_zl 'Interior' = lv_interior .

  SET PROPERTY OF lv_interior 'ColorIndex' = 15.
  SET PROPERTY OF v_zl 'WrapText' = 1.
*left

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '1'.

  SET PROPERTY OF lv_borders 'LineStyle' = '1'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '2'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '3'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '4'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ZCACONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_zcaconstants .
*Local data declarations
  DATA: li_vrm_values TYPE vrm_values,        " Value table
        lst_list      TYPE vrm_value.         " Value structure

  CONSTANTS:
    lc_vkorg  TYPE vrm_id     VALUE 'P_VKORG',  " Sales Org
    lc_param1 TYPE rvari_vnam VALUE 'SALES_ORG'.

  SELECT vkorg , vtext FROM tvkot
    INTO TABLE @DATA(li_tvko)
    WHERE spras = @sy-langu
      AND vkorg NE @space.
  IF sy-subrc EQ 0.
    SORT li_tvko BY vkorg.
  ENDIF.

  IF i_const IS INITIAL .
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
*--*App server FIle path
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_path>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
                                                param1 = c_path
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_e205_path = <lst_e205_path>-low.
      ENDIF.

**--*Sales Org
      IF i_const[] IS NOT INITIAL.
        LOOP AT i_const INTO DATA(lst_caconstant) WHERE param1 = lc_param1.
          lst_list-key = lst_caconstant-low.

          READ TABLE li_tvko ASSIGNING FIELD-SYMBOL(<lfs_tvko>) WITH KEY vkorg = lst_list-key.
          IF sy-subrc EQ 0.
            lst_list-text = <lfs_tvko>-vtext.
          ENDIF.
          APPEND lst_list TO li_vrm_values.
          CLEAR: lst_caconstant, lst_list.
        ENDLOOP.
      ENDIF.

* Value Request Manager: Set new Values for Valueset
      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id              = lc_vkorg      " Name of Value Set
          values          = li_vrm_values   " Value table
        EXCEPTIONS
          id_illegal_name = 1
          OTHERS          = 2.
      IF sy-subrc EQ 0.
*    Nothing to do
      ENDIF.

*--*Row limit
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_limit>) WITH KEY devid = c_devid
                                                param1 = c_limit
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_line_lmt = <lst_e205_limit>-low.
      ENDIF.

    ENDIF.
  ENDIF.
ENDFORM.
