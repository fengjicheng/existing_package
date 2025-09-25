*&---------------------------------------------------------------------*
*&  Include           ZQTCC_CREATE_INVOICE_VF04_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PROF_INV_CREATE_E182
* PROGRAM DESCRIPTION: To Create Proforma Invoice for mulitple Contracts
* with same PO for billing plan type ZF5 by using BAPI
* DEVELOPER: Kiran Jagana
* CREATION DATE: 11/13/2018
* OBJECT ID: WRICEF - E182
* TRANSPORT NUMBER(S): ED2K913742
*----------------------------------------------------------------------*
TABLES : vbak,vkdfs,vbrk,vbkd.
TYPE-POOLS:
   slis.
*- Final internal table with log data
TYPES : BEGIN OF ty_msg_log,
          vbeln       TYPE vbeln_va,  "Sales Document
          posnr       TYPE posnr,     "Item number of the SD document
          proforma    TYPE vbeln_va,  "Proforma Document
          item        TYPE posnr,     "Proforma Document Item
          status(10)  TYPE c,         "Status
          message(90) TYPE c,         "Status Message
        END OF ty_msg_log,

        ty_fieldcat TYPE slis_fieldcat_alv,
*- Billing document header data
        BEGIN OF ty_vbrk,
          vbelv   TYPE vbfa-vbelv,    "Preceding sales and distribution document
          posnv   TYPE vbfa-posnv,    "Preceding item of an SD document
          vbeln   TYPE vbfa-vbeln,    "Subsequent sales and distribution document
          posnn   TYPE vbfa-posnn,    "Subsequent item of an SD document
          vbtyp_n TYPE vbfa-vbtyp_n,  "Document category of subsequent document
          fkart   TYPE vbrk-fkart,    "Billing Type of Billing Document
          fksto   TYPE vbrk-fksto,    "Billing document is cancelled
          rfbsk   TYPE vbrk-rfbsk,    "Status for transfer to accounting
        END OF ty_vbrk,
*- Sales Document header data
        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,      "Sales Document
          vbtyp TYPE vbak-vbtyp,      "SD document category
          auart TYPE vbak-auart,      "Sales Document Type
          vkorg TYPE vbak-vkorg,      "Sales Organization
          vtweg TYPE vbak-vtweg,      "Distribution Channel
          spart TYPE vbak-spart,      "Division
          vkbur TYPE vbak-vkbur,      "Sales Office
        END OF ty_vbak,
*- Sales document item data
        BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,      "Sales Document
          posnr TYPE vbap-posnr,      "Sales Document Item
          matnr TYPE vbap-matnr,      "Material Number
          pstyv TYPE vbap-pstyv,      "Sales document item category
          zmeng TYPE vbap-zmeng,      "Target quantity in sales units
          waerk TYPE vbap-waerk,      "SD Document Currency
          werks TYPE vbap-werks,      "Plant (Own or External)
        END OF ty_vbap,
*- SD Index: Billing Initiator
        BEGIN OF ty_vkdfs,
          fktyp TYPE vkdfs-fktyp,  "Billing category
          vkorg TYPE vkdfs-vkorg,  "Sales Organization
          fkdat TYPE vkdfs-fkdat,  "Billing date for billing index and printout
          kunnr TYPE vkdfs-kunnr,  "Sold-to party
          fkart TYPE vkdfs-fkart,  "Billing Type
          vbeln TYPE vkdfs-vbeln,  "Sales and Distribution Document Number
        END OF ty_vkdfs,
*- SD Index: Billing Initiator
        BEGIN OF ty_vbeln,
          vbeln TYPE vbak-vbeln,   "Sales and Distribution Document Number
        END OF ty_vbeln.
*- ZCACONSTANT Entries
TYPES : BEGIN OF ty_constant,
          param1 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,   "Current selection number
          sign   TYPE tvarv_sign,   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low, "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, "Upper Value of Selection Condition
        END OF ty_constant.
*Begin of Change by KJAGANA CR7804  ED2K913742
  TYPES: BEGIN OF ty_vbap_ch,
          bstkd TYPE bstkd,           "Customer PO.
          vbeln TYPE vbap-vbeln,      "Sales Document
          posnr TYPE vbap-posnr,      "Sales Document Item
          matnr TYPE vbap-matnr,      "Material Number
          pstyv TYPE vbap-pstyv,      "Sales document item category
          zmeng TYPE vbap-zmeng,      "Target quantity in sales units
          waerk TYPE vbap-waerk,      "SD Document Currency
          werks TYPE vbap-werks,      "Plant (Own or External)
        END OF ty_vbap_ch.
TYPES : BEGIN OF ty_vbkd,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
        bstkd TYPE bstkd,
        bsark TYPE bsark,
        END OF ty_vbkd.
*End of Change by KJAGANA CR7804   ED2K913742
DATA  : li_vbap              TYPE STANDARD TABLE OF ty_vbap,   "Sales Document Item data
        li_vbrk              TYPE STANDARD TABLE OF ty_vbrk,   "Billing document header data
        li_vbrk_tmp          TYPE STANDARD TABLE OF ty_vbrk,   "Billing document header data
        li_vkdfs             TYPE STANDARD TABLE OF ty_vkdfs,  "SD Index: Billing Initiator
        li_vbeln             TYPE STANDARD TABLE OF ty_vbeln,  "Sales Document number
        li_vbak              TYPE STANDARD TABLE OF ty_vbak,   "Sales document header data
        li_billdata          TYPE TABLE OF bapivbrk,           "BAPI - Communication Fields for Billing Header Fields
        li_error             TYPE TABLE OF bapivbrkerrors,     "BAPI - Information on Incorrect Processing of Preceding Items
        li_return            TYPE TABLE OF bapiret1,           "BAPI - Return Parameter
        li_success           TYPE TABLE OF bapivbrksuccess,    "BAPI - Information for Successfully Processing Billing Doc. Items
        li_msg_log           TYPE TABLE OF ty_msg_log,         "Final internal table - Log data
        li_fieldcat          TYPE STANDARD TABLE OF ty_fieldcat, "Fieldcatlog
        li_const_values_e182 TYPE TABLE OF ty_constant, "Constant table entries for E182
*        *Begin of Change by KJAGANA CR7804 on 2018.10.31  ED2K913742
        li_vbkd              TYPE TABLE OF ty_vbkd,"           "Sales document:business data
        li_vbap_ch           TYPE TABLE OF ty_vbap_ch,         "Sales Document Item dat
*        *End of Change by KJAGANA CR7804 on 2018.10.31  ED2K913742
        lst_fieldcat         TYPE ty_fieldcat,                 "Fieldcatlog
        lst_billdata         TYPE bapivbrk,                    "BAPI - Communication Fields for Billing Header Fields
        lst_msg_log          TYPE ty_msg_log,                  "Log Data
        lst_vbeln            TYPE ty_vbeln,                    "Sales Document
        st_layout            TYPE slis_layout_alv,             "ALV Layout
        st_const_values      TYPE ty_constant,        "ZCACONSTANT entries
        lv_glb_flg           TYPE char1,
        lv_zf2_zf5           TYPE char10.

*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_x                TYPE char1      VALUE 'X',      " X of type CHAR1
           c_ag               TYPE parvw      VALUE 'AG',     "Partner Function
           c_re               TYPE parvw      VALUE 'RE',     "Partner Function
           c_rg               TYPE parvw      VALUE 'RG',     "Partner Function
           c_we               TYPE parvw      VALUE 'WE',     "Partner Function
           c_0                TYPE vbap-posnr VALUE '000000', "Item
           c_complete_invoice TYPE char1      VALUE 'C',      "Invoice Status
           c_vbtyp_rech       TYPE vbak-vbtyp VALUE 'M',      "Document Status
           c_vbtyp_prof       TYPE vbak-vbtyp VALUE 'U',      "Document Status
           c_zf5_cancel       TYPE rfbsk      VALUE 'E',      "Document Status
           c_zf5_d            TYPE rfbsk      VALUE 'D',      "Document Status
           c_zf5              TYPE vbrk-fkart VALUE 'ZF5',    "Billing Document for ZF5
           c_0050             TYPE vbak-vkbur VALUE '0050',   "Sales Office
           c_0230             TYPE vbkd-bsark VALUE '0230',   "PO type
           c_i                TYPE char1      VALUE 'I',      "Information
           c_e                TYPE char1      VALUE 'E',      "Error
           c_s                TYPE char1      VALUE 'S',      "Success
           c_w                TYPE char1      VALUE 'W'.      "Warning
