*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_CMR_UPLD_CONSORTIUM_TOP
* PROGRAM DESCRIPTION : Credit Memo Request Upload Consortium
* DEVELOPER           : Prabhu
* CREATION DATE       :  05/21/2018
* OBJECT ID           :  QTC_E101
* TRANSPORT NUMBER(S) :  ED2K912156
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_CMR_UPLD_CONSORTIUM_SUB
* PROGRAM DESCRIPTION  : Credit Memo Request Upload Consortium
* DEVELOPER            : Nageswar - NPOLINA
* CREATION DATE        : 12/14/2018
* OBJECT ID            : QTC_E101/ERP7860
* TRANSPORT NUMBER(S)  : ED2K914010
*----------------------------------------------------------------------*
*--*Structure to hold to crate Credit memo request data
TYPES: BEGIN OF ty_crdt_memo_crt,
         customer TYPE kunnr,      " Customer Number
         parvw    TYPE parvw,      " Partner Function
         partner  TYPE kunnr,      " Customer Number
         vkorg    TYPE vkorg,      " Sales Organization
         vtweg    TYPE vtweg,      " Distribution Channel
         spart    TYPE spart,      " Division
         auart    TYPE auart,      " Sales Document Type
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         vbtyp    TYPE vbtyp,      " Ref doc category
         zlsch    TYPE schzw_bseg, " Payment Method
         augru    TYPE augru,      " Order reason (reason for the business transaction)
         vbeln    TYPE vbeln_vf,   " Billing Document
         posnr    TYPE posnr_vf,   " Billing item
         matnr    TYPE matnr,      " Material Number
         zmeng    TYPE dzmeng,     " Target Quantity
         text     TYPE tdline,     " Name
         kbetr1   TYPE kwert,     " Rate (condition amount or percentage)
         kbetr2   TYPE kwert,      " Condition value
         kbetr3   TYPE kwert,      " Condition value
         discount TYPE kwert,      " DIscount - ZPQA
         disc_per TYPE kbetr,      " Discount percentage
         vgbel    TYPE vgbel,      " Sales Document
         kdkg3    TYPE kdkg3,      " Customer condition group 3
         vkbur    TYPE vkbur,      " Sales Office
         bstnk    TYPE bstkd,      " Customer purchase order number
         ihrez_e  TYPE ihrez_e,    " Your Reference
         posex_e  TYPE posex_e,    "Item num at shipto level
         bsark    TYPE bsark,      " Customer purchase order type
       END OF ty_crdt_memo_crt,
       BEGIN OF ty_price,
         vbeln    TYPE vbeln_vf,   " Billing Document
         posnr    TYPE posnr_vf,   " Billing item
         vbtyp    TYPE vbtyp,      " Ref doc category
         price1   TYPE kwert,     " Rate (condition amount or percentage)
         price2   TYPE kwert,      " Condition value
         price3   TYPE kwert,      " Condition value
         discount TYPE kwert,    "Discount
         disc_per TYPE kbetr,    "Discount percentage
       END OF ty_price,
*--*Structure to hold VBRK - Billing header and Item data
       BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_vf,      " Billing Document
         erdat TYPE erdat,         " Date on Which Record Was Created
         vbtyp TYPE vbtyp,         " SD document category
         zlsch TYPE schzw_bseg,    " Payment Method
         xblnr TYPE xblnr_v1,      " Reference Document Number
         posnr TYPE posnr,         " Sales Document Item
         matnr TYPE matnr,         " Material Number
         fkimg TYPE fkimg,         " Actual Invoiced Quantity
         pstyv TYPE pstyv,         " Sales document item category
         pospa TYPE pospa,         " Item number in the partner segment
         vgbel TYPE vgbel,         " Reference doc number
         vgpos TYPE vgpos,         " Reference doc Item number
       END OF ty_vbrk,
*--* Structure to hold sales order header data
       BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va,      " Sales Document
         erdat TYPE erdat,         " Date on Which Record Was Created
         vbtyp TYPE vbtyp,         " SD document category
         auart TYPE auart,         " Sales Document Type
         augru TYPE augru,         " Order Reasons
         vkorg TYPE vkorg,         " Sales Organization
         vtweg TYPE vtweg,         " Distribution Channel
         spart TYPE spart,         " Division
         vkbur TYPE vkbur,         " Sales Office
         kunnr TYPE kunnr,         "Customer
         knumv TYPE knumv,         " Number of the document condition
         bstnk TYPE bstkd,         " Customer purchase order number
       END OF ty_vbak,
*--*Structure to hold Sale Item data
       BEGIN OF ty_vbap,
         vbeln TYPE vbeln_va,      " Sales Document
         posnr TYPE posnr_va,      " Sales Document Item
         matnr TYPE matnr,         " Material Number
         matkl TYPE matkl,         " Material Group
         zmeng TYPE dzmeng,        " Target quantity in sales units
         vgbel TYPE vgbel,         " Document number of the reference document
         vgpos TYPE vgpos,         " Item number of the reference item
       END OF ty_vbap,
*--*Structure to hold sales doc business data
       BEGIN OF ty_vbkd,
         vbeln   TYPE vbeln_va,    " Sales Document
         posnr   TYPE posnr_va,    " Sales Document Item
         zlsch   TYPE schzw_bseg,  " Payment Method
         bsark   TYPE bsark,       " PO type
         ihrez_e TYPE ihrez_e,     " Ship-to party character
         posex_e TYPE posex_e,     " Ship to your reference PO item number
         kdkg3   TYPE kdkg3,       " Customer condition group 3
       END OF ty_vbkd,
*--*Structure to hold price conditions data
       BEGIN OF ty_konv,
         knumv TYPE knumv,         " Number of the document condition
         kposn TYPE kposn,         " Condition item number
         stunr TYPE stunr,         " Step number
         zaehk TYPE dzaehk,        " Condition counter
         kschl TYPE kscha,         " Condition type
         kbetr TYPE kbetr,         " Rate (condition amount or percentage)
         kwert TYPE kwert,         "Condition value
       END OF ty_konv,
*--8Structre to hold sales Partner data
       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln_va,       " Sales Document
         posnr TYPE posnr_va,       " Sales Document Item
         parvw TYPE parvw,          " Partner Function
         kunnr TYPE   kunnr,        " Partner Nubbeer
       END OF ty_vbpa,
*--*Structre to hold credit memo request data
       BEGIN OF ty_crdt_memo_cmr,
         vbeln    TYPE vbeln_vf,   " Billing Document
         customer TYPE kunnr,      " Customer Number
         posnr    TYPE posnr_vf,   " Billing item
         matnr    TYPE matnr,      " Material Number
         parvw    TYPE parvw,      " Partner Function
         partner  TYPE kunnr,      " Customer Number
         vkorg    TYPE vkorg,      " Sales Organization
         vtweg    TYPE vtweg,      " Distribution Channel
         spart    TYPE spart,      " Division
         auart    TYPE auart,      " Sales Document Type
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         vbtyp    TYPE vbtyp,      " Ref doc category
         zlsch    TYPE schzw_bseg, " Payment Method
         augru    TYPE augru,      " Order reason (reason for the business transaction)
         zmeng    TYPE dzmeng,     " Target Quantity
         text     TYPE tdline,     " Name
         kbetr1   TYPE kwert,      " Rate (condition amount or percentage)
         kbetr2   TYPE kwert,      " Condition value
         kbetr3   TYPE kwert,      " Condition value
         discount TYPE kwert,      " Condition Value
         disc_per TYPE kbetr,      " Condition percentage
         vgbel    TYPE vgbel,      " Sales Document
         kdkg3    TYPE kdkg3,      " Customer condition group 3
         vkbur    TYPE vkbur,      " Sales Office
         bstnk    TYPE bstkd,      " Customer purchase order number
         ihrez_e  TYPE ihrez_e,    " Your Reference
         posex_e  TYPE posex_e,    "Item At shipto level
         bsark    TYPE bsark,      " Customer purchase order type
       END OF ty_crdt_memo_cmr.
*--*Structure to hold Log data after creating credit memo request
TYPES : BEGIN OF ty_log,
          vkorg        TYPE vkorg,      " Sales Organization
          vtweg        TYPE vtweg,      " Distribution Channel
          spart        TYPE spart,      " Division
          bstnk        TYPE bstkd,      "Customer PO
          kunnr        TYPE kunnr,      " Customer
          xblnr        TYPE xblnr_v1,   " Reference Document Number
          vbeln        TYPE vbeln_vf,   "Credit memo
          posnr        TYPE posnr,      "Item
          matnr        TYPE matnr,      "Material
          msg_typ(8)   TYPE c,          "Message type
          message(220) TYPE c,          " Message
        END OF ty_log.
*--*Structure to hold constant table
TYPES: BEGIN OF ty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const.
*** Begin of: KJAGANA  ED2K913407  CR#  7738
* *Structure to hold condition group table
TYPES :BEGIN OF ty_cond,
         vbeln TYPE vbeln,                    "Sales and Distribution Document Number
         posnr TYPE posnr,                    "Item number of the SD document
         kdkg1 TYPE kdkg1,                    "Customer condition group 1
         kdkg2 TYPE kdkg2,                    "Customer condition group 2
         kdkg3 TYPE kdkg3,                    "Customer condition group 3
         kdkg4 TYPE kdkg4,                    "Customer condition group 4
         kdkg5 TYPE kdkg5,                    "Customer condition group 5
       END OF   ty_cond.
*** END of: KJAGANA  ED2K913407  CR#  7738
*====================================================================*
*   Internal Tables - Global
*====================================================================*
DATA :
  i_final_crme_crt   TYPE STANDARD TABLE OF  ty_crdt_memo_crt, "Itab to hold CMR related data
  i_final_crme_split TYPE STANDARD TABLE OF ty_crdt_memo_cmr,  "Itab to hold CMR related data
  i_final_crme_cmr   TYPE STANDARD TABLE OF ty_crdt_memo_cmr,  "Itab to hold CMR related data
  i_vbrk             TYPE STANDARD TABLE OF  ty_vbrk,          "Itab to hold billing data
  i_vbak             TYPE STANDARD TABLE OF ty_vbak,           "Itab to hold sales header data
  i_vbap             TYPE STANDARD TABLE OF ty_vbap,           "Itab to hold sales item data
  i_vbkd             TYPE STANDARD TABLE OF ty_vbkd,           "Itab to hold sales business data
  i_konv             TYPE STANDARD TABLE OF ty_konv,           "Itab to hold sales pricing data
  i_vbpa             TYPE STANDARD TABLE OF ty_vbpa,           "Itab to hold sales partner data
  i_const            TYPE STANDARD TABLE OF ty_const,          "Itab to hold constant table
*  *** Begin of: KJAGANA  ED2K913407  CR#  7738
  i_cond             TYPE STANDARD TABLE OF ty_cond,           "Itab to hold condition table
*  *** End of: KJAGANA  ED2K913407  CR#  7738
  i_fcat_out         TYPE slis_t_fieldcat_alv,                 "Itab to hold fieldact output ALV data
  i_log              TYPE STANDARD TABLE OF ty_log,            "Itab to hold Log data
  i_log_temp         TYPE STANDARD TABLE OF ty_log,            "Itab to hold Log data
  i_fcat             TYPE slis_t_fieldcat_alv,                 "Itab to hold log data fieldcat alv
  i_message          TYPE STANDARD TABLE OF solisti1,              "Itab to hold message for email
  i_attach           TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_packing_list     LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,    "Itab to hold packing list for email
  i_receivers        LIKE somlreci1 OCCURS 0 WITH HEADER LINE,     "Itab to hold mail receipents
  i_attachment       LIKE solisti1 OCCURS 0 WITH HEADER LINE,      "Itab to hold attachmnt for email
  i_contents_hex     TYPE STANDARD TABLE OF solix WITH HEADER LINE,
  i_contents_bin     TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE,
  st_price           TYPE ty_price,
  i_price            TYPE STANDARD TABLE OF ty_price,
  i_copy_vbap TYPE STANDARD TABLE OF vbap,
  i_copy_return TYPE STANDARD TABLE OF bapiret2.


*====================================================================*
*   W O R K - A R E A
*====================================================================*
DATA: st_fcat_out       TYPE slis_fieldcat_alv, "structure for ALV fieldcatelog download
      st_layout         TYPE slis_layout_alv,   "Structure for ALV layout download
      st_fcat           TYPE slis_fieldcat_alv, "structure for ALV fieldcatelog for Log display
      st_layo           TYPE slis_layout_alv,   "Structure for ALV layout for log display
      st_cre_cred_memo  TYPE ty_crdt_memo_crt,
      st_final_crme_crt TYPE ty_crdt_memo_crt,
      st_vbap           TYPE ty_vbap,           "Structure for sales item
      st_log            TYPE ty_log,           "Structure to display Log
      st_vbak           TYPE ty_vbak,           "Structure for sales header
      st_vbkd           TYPE ty_vbkd,           "Strcuture for sales business data
      st_vbpa           TYPE ty_vbpa,           "Structure for  sales partners
      st_vbrk           TYPE ty_vbrk,           "Structure for billing
      st_cmr            TYPE ty_crdt_memo_cmr,  "Structure to create credit memo request
      st_imessage       TYPE solisti1,
      st_const          TYPE ty_const,
      st_konv           TYPE ty_konv.            "Structure for pricing KONV

*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_tdid           TYPE tdid,      " Text ID
      v_lines          TYPE salv_de_selopt_low, "number of line items
      v_item_cat       TYPE pstyv,     "Item category
      v_path_fname     TYPE string,    "File path
      v_curr           TYPE waerk,     "currency,
      v_job_name       TYPE tbtcjob-jobname,  " Job Name
      v_kunnr          TYPE kunnr,     " Customer Number
*--*Begin of change ERP-7680 - ED1K908253 - 8/23/2018
      v_fg_lines_limit TYPE salv_de_selopt_low,
*--*End of change ERP-7680 - ED1K908253 - 8/23/2018
      v_bom(1)         TYPE c,       "ED2K914010       NPOLINA ERP7860
      v_cnt            TYPE i,
      v_pos            type posnr,
      bdcdata          LIKE bdcdata    OCCURS 0 WITH HEADER LINE.  "ED2K914010       NPOLINA ERP7860
*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore    TYPE char1      VALUE '_',     " Underscore of type CHAR1
           c_extn          TYPE char4      VALUE '.txt',  " Extn of type CHAR4
           c_cmr           TYPE char3     VALUE 'CMR',    "CMR string for file upload
           c_e             TYPE char1      VALUE 'E',     " E of type CHAR1
           c_a             TYPE char1      VALUE 'A',     " Value A for Abort message
           c_i             TYPE char1      VALUE 'I',     " Value S for information
           c_eq            TYPE char2      VALUE 'EQ',    "EQ for ranges
           c_zsub          TYPE char4      VALUE 'ZSUB',  "Order tpe ZSUB
           c_zmbr          TYPE char4      VALUE 'ZMBR',  "Order type ZMBR
           c_zacc          TYPE char4     VALUE 'ZACC',  "Order type ZACC
           c_zcon          TYPE  char4     VALUE 'ZCON',  "Order type ZCON
           c_zhos          TYPE char4      VALUE 'ZHOS',  "Order type ZHOS
           c_zpqa          TYPE char4      VALUE 'ZPQA', "Discount
           c_g             TYPE char1      VALUE 'G',     "Doc category G
           c_s             TYPE char1      VALUE 'S',     " S of type CHAR1
           c_x             TYPE char1      VALUE 'X',     " X of type CHAR1
           c_ep1           TYPE sy-sysid    VALUE 'EP1', "Sys id
           c_u             TYPE char1 VALUE 'U',                   "Value U for update
           c_int           TYPE char3 VALUE 'INT',               "Value INT for email send
           c_zcr           TYPE char3 VALUE 'ZCR',               "Credit memo type
           c_usd           TYPE char3 VALUE 'USD',               "Currency USD
           c_raw           TYPE char3 VALUE 'RAW',               "Value RAW for email send
           c_xls           TYPE char4 VALUE 'XLS',               "DOc attachment XLSX
           c_alv_pf_status TYPE slis_formname VALUE 'F_SET_PF_STATUS', "Form routine for ALV
           c_devid         TYPE zdevid     VALUE 'I0354',              "Development ID
           c_pf_ag         TYPE char2 VALUE 'AG',              "Partner function soldto
           c_pf_we         TYPE char2 VALUE 'WE',              "Partner function Shipto
           c_m             TYPE char1 VALUE 'M',                  "Value M for selection screen group
           c_m1            TYPE char2 VALUE 'M1',                 "Value M1 for selection screen group
           c_m2            TYPE char2 VALUE 'M2',                 "Value M2 for selection screen group
           c_m3            TYPE char2 VALUE 'M3',                 "Value M3 for selection screen group
           c_m4            TYPE char2 VALUE 'M4',                 "Value M4 for selection screen group
           c_m5            TYPE char2 VALUE 'M5',                 "Value M5 for selection screen group
           c_m6            TYPE char2 VALUE 'M6',                 "Value M6 for selection screen group
           c_m7            TYPE char2 VALUE 'M7',                 "Value M7 for selection screen group
           c_m8            TYPE char2 VALUE 'M8',                 "Value M8 for selection screen group
           c_m9            TYPE char2 VALUE 'M9',                 "Value M9 for selection screen group
           c_m10           TYPE char3 VALUE 'M10',               "Value M10 for selection screen group
           c_m11           TYPE char3 VALUE 'M11',               "Value M11 for selection screen group
           c_m12           TYPE char3 VALUE 'M12',               "Value M12 for selection screen group
           c_m13           TYPE char3 VALUE 'M13',               "Value M13 for selection screen group
           con_tab         TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret        TYPE c VALUE cl_abap_char_utilities=>cr_lf,
           c_hex1          TYPE c VALUE cl_abap_char_utilities=>cr_lf.
