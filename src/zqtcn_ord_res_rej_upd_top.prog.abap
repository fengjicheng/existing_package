*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_TOP (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-43362 / OTCM-29655                                            *
* DEVELOPER   : Prabhu (PTUFARAM)                          *
* DATE        : 03/25/2021                               *
* DESCRIPTION : Adding sales org and Item category exclusion
*              OTCM-43362 is replaced with OTCM-29655
*----------------------------------------------------------------------*
* REVISION NO : ED2K926559
* REFERENCE NO: EAM-1661
* DEVELOPER   : Vishnu (VCHITTIBAL)
* DATE        : 06/04/2022
* OBJECT ID   : E505
* DESCRIPTION : Adding new functionality to update reason for rejection
*               for Back orders
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
        END OF ty_output,
        tt_output TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0.


DATA:gi_vbap          TYPE STANDARD TABLE OF zqtc_cds_e186,             " Sales Document Item Data
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
     g_job_name       TYPE tbtcjob-jobname.                             " Job Name
PARAMETERS :p_job TYPE tbtcjob-jobname NO-DISPLAY.

*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
TYPES:BEGIN OF ty_output_apl,
        vbeln      TYPE  vbeln,                     "Sales Document Number
        posnr      TYPE  posnr,                     "Sales Document Item
        wmeng      TYPE  wmeng,                     "Order Quantity
        bmeng      TYPE  bmeng,                     "Confirmed Quantity
        bo_quant   TYPE  bmeng,                     "Back Order Quantity
        abgru      TYPE  abgru,                     "Reason for Rejection
        type       TYPE  bapi_mtype,                "Message type: S Success, E Error, W Warning, I Info, A Abort
        id         TYPE  symsgid,                   "Message Class
        number     TYPE  symsgno,                   "Message Number
        message    TYPE  bapi_msg,                  "Message Text
        message_v1 TYPE  symsgv,                    "Message Variable
        message_v2 TYPE  symsgv,                    "Message Variable
        message_v3 TYPE  symsgv,                    "Message Variable
        message_v4 TYPE  symsgv,                    "Message Variable
        status     TYPE  char8,                     "Success/Fail Status
      END OF ty_output_apl,
      tt_cds_e505 TYPE STANDARD TABLE OF zqtc_cds_e505 INITIAL SIZE 0,

      BEGIN OF ty_zcaconstant_apl,
        devid    TYPE zdevid,                                       "Development ID
        param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
        param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
        srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
        sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
        opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
        low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
        high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
        activate TYPE zconstactive,                                 "Activation indicator for constant
      END OF ty_zcaconstant_apl.

DATA:i_vbap_apl   TYPE TABLE OF zqtc_cds_e505,              " Sales Document Item Data
     i_output_apl TYPE STANDARD TABLE OF ty_output_apl,     " Output Internal Table
     i_const_apl  TYPE STANDARD TABLE OF ty_zcaconstant_apl." Constant Internal Table

*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022
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
           c_opti_bt    TYPE s_option     VALUE 'BT'.  " Option: (BET)ween
