*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_TOP (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-29655
* REFERENCE NO: ED2K915695
* DEVELOPER: Siva Guda (SGUDA)
* DATE: 12-21-2020
* DESCRIPTION: Auto rejection on release order
* 1) Add order type as VBAK-AUART in Excel file.
* 2) Change Mail Body
* 3) Add reason for rejection for subsequent documents.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORD_RES_REJ_UPD_TOP
*&---------------------------------------------------------------------*
*- Report Output
TYPES : BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
        END OF ty_mail,
        tt_sel_opt  TYPE STANDARD TABLE OF ty_mail,
        tt_cds_e186 TYPE STANDARD TABLE OF zqtc_cds_e186,

        BEGIN OF ty_output,
          vbeln      TYPE  vbeln,                     "Sales Document Number
          posnr      TYPE  posnr,                     "Sales Document Item
          vbelnorder type  vbeln,                     " Release order
          posnrorder TYPE  posnr,                     " Release Order Item
          auart      TYPE  auart,                     "Sales Document Type
          vkuegru    TYPE  vkgru_veda,                "Reason for Cancellation of Contract
          vkuesch    TYPE  vkues_veda,                "Assignment cancellation procedure/cancellation rule
          veindat    TYPE  vedat_veda,                "Date on which cancellation request was received
          vwundat    TYPE  vwdat_veda,                "Requested cancellation date
          type       TYPE  bapi_mtype,                "Message type: S Success, E Error, W Warning, I Info, A Abort
          id         TYPE  symsgid,                   "Message Class
          number     TYPE  symsgno,                   "Message Number
          message    TYPE  bapi_msg,                  "Message Text
          message_v1 TYPE  symsgv,                    "Message Variable
          message_v2 TYPE  symsgv,                    "Message Variable
          message_v3 TYPE  symsgv,                    "Message Variable
          message_v4 TYPE  symsgv,                    "Message Variable
          log_text   TYPE char255,
        END OF ty_output,
        tt_output TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0,
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
        BEGIN OF ty_ekkn,
          vbeln TYPE vbeln_co,                 "Sales and Distribution Document Number
          vbelp TYPE posnr_co,                 "Sales Document Item
        END OF ty_ekkn,
        BEGIN OF ty_vbup,
          vbeln TYPE vbup-vbeln,                "Sales and Distribution Document Number
          posnr TYPE vbup-posnr,                "Sales Document Item
          lfsta TYPE vbup-lfsta,                "Delivery status
        END OF ty_vbup,
        BEGIN OF ty_item_catg,
          vbeln TYPE vbap-vbeln,                "Sales and Distribution Document Number
          posnr TYPE vbap-posnr,                "Sales Document Item
          pstyv TYPE vbap-pstyv,                " Item Catg
        END OF ty_item_catg,
        BEGIN OF ty_rel_order,
          vbeln TYPE vbak-vbeln,
        END OF ty_rel_order,
        BEGIN OF ty_rel_cds_view,
          vbelnorder     TYPE vbeln,
          posnrorder     TYPE posnr,
          xorder_created TYPE jmorder_created,
          shipping_date  TYPE jshipping_date,
          vbeln          TYPE vbeln,
          posnr          TYPE posnr,
          vwundat        TYPE vwdat_veda,
          vkuegru        TYPE vkgru_veda,
        END OF ty_rel_cds_view.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
DATA:gi_vbap          TYPE STANDARD TABLE OF zqtc_cds_e186,             " Sales Document Item Data
     gi_vbap_rel_order TYPE STANDARD TABLE OF zqtc_cds_e186,             " Sales Document Item Data "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     i_ekkn           TYPE STANDARD TABLE OF ty_ekkn,                   "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     i_vbup           TYPE STANDARD TABLE OF ty_vbup,                   "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     i_item_catg      TYPE STANDARD TABLE OF ty_item_catg,              "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     i_rel_order      TYPE STANDARD TABLE OF ty_rel_order,              "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     i_rel_cds_view   TYPE STANDARD TABLE OF ty_rel_cds_view,           "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     li_mail          TYPE STANDARD TABLE OF ty_mail,                   " Mail
     gi_output        TYPE STANDARD TABLE OF ty_output,                 " Output
     li_tvagt         TYPE STANDARD TABLE OF tvagt,
     li_return        TYPE bapiret2_t,                                  " Return table
     li_return_tmp    TYPE bapiret2_t,                                  " Return table
     li_bapisditmx    TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
     li_bapisditm     TYPE STANDARD TABLE OF bapisditm  INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
     lst_bapisdh1x    TYPE bapisdh1x,                                   " Checkbox List: SD Order Header
     lst_bapisditm    TYPE bapisditm,                                   " Communication Fields: Sales and Distribution Document Item
     lst_bapisditmx   TYPE bapisditmx,                                  " Communication Fields: Sales and Distribution Document Item
     i_message        TYPE STANDARD TABLE OF solisti1,                  " Itab to hold message for email
     i_attach_success TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_attach_error   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_attach_total   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_packing_list   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,        " Itab to hold packing list for email
     i_receivers      LIKE somlreci1 OCCURS 0 WITH HEADER LINE,         " Itab to hold mail receipents
     i_attachment     LIKE solisti1 OCCURS 0 WITH HEADER LINE,          " Itab to hold attachmnt for email
     st_imessage      TYPE solisti1,                                    " Messages
     g_job_name       TYPE tbtcjob-jobname,                             " Job Name
     "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
     lst_rel_order    TYPE ty_rel_order,
     lst_rel_cds_view TYPE ty_rel_cds_view,
     lst_vbap         TYPE zqtc_cds_e186,
     lst_output       TYPE ty_output,
     lst_return       TYPE bapiret2,
     lst_att_err      TYPE so_text255,
     lst_text         TYPE so_text255,
     lv_flag_order    TYPE char1,
     lv_vbeln         TYPE vbeln,
     lv_log_text      TYPE char255,
     lv_index         type char1.
"END:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
PARAMETERS :     p_job TYPE tbtcjob-jobname NO-DISPLAY.
*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore TYPE char1      VALUE '_',                      " Underscore of type CHAR1
           c_x          TYPE char1      VALUE 'X',                      " X of type CHAR1
           con_tab      TYPE c          VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret     TYPE c          VALUE cl_abap_char_utilities=>cr_lf,
           c_separator  TYPE c          VALUE ',',                      " Separator of type CHAR1
           c_u          TYPE char1      VALUE 'U',                      " U of Type CHAR1
           c_int        TYPE char3      VALUE 'INT',
           c_raw        TYPE char3      VALUE 'RAW',
           c_csv        TYPE char5      VALUE 'CSV',
           c_saprpt     TYPE char6      VALUE 'SAPRPT',
           c_s          TYPE char1      VALUE 'S',
           c_e          TYPE char1      VALUE 'E',
           c_i          TYPE char1      VALUE 'I',
           c_a          TYPE char1      VALUE 'A',
           c_ep1        TYPE syst_sysid VALUE 'EP1',
           c_xls        TYPE so_obj_tp VALUE  'XLS',
           c_days       TYPE t5a4a-dlydy  VALUE '00',  " Days
           c_month      TYPE t5a4a-dlymo  VALUE '00',  " Month
           c_year       TYPE t5a4a-dlyyr  VALUE '00',  " Year
           c_opti_bt    TYPE s_option     VALUE 'BT',  " Option: (BET)ween
           c_lfsta_a    TYPE vbup-lfsta   VALUE 'A'. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
