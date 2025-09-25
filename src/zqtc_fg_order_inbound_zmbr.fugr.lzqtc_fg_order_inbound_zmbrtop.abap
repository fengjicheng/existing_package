FUNCTION-POOL zqtc_fg_order_inbound_zmbr.   "MESSAGE-ID ..

* INCLUDE LZQTC_FG_ORDER_INBOUND_ZMBRD...    " Local class definition
*----------------------------------------------------------------------*
* PROGRAM NAME        : LZQTC_FG_ORDER_INBOUND_ZMBRTOP (Include)
* PROGRAM DESCRIPTION : This Include is used to declare global variables
*                       to create ZMBR documnet type
*                       sales contracts by using BAPI.
* DEVELOPER           : Prabhu Kishore T
* CREATION DATE       : 6/8/2016
* OBJECT ID           :
* TRANSPORT NUMBER(S) : ED2K912203
*---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Structures Declaration
*----------------------------------------------------------------------*
*--*Structure to capture Idoc header segments data
TYPES : BEGIN OF ty_header,
          crcy     TYPE edi6345_a,  "Currency
          zterm    TYPE dzterm,        "Payment terms
          lifsk    TYPE lifsk,         "Delivery blcok
          submi    TYPE submi,         "Collection num
          zzlicyr  TYPE zzlicyr,      "License year
          doctype  TYPE auart,      "Sales doc num
          sorg     TYPE vkorg,      "Sales org
          dch      TYPE vtweg,      "Distribution channel
          division TYPE spart,      "Division
          saleoff  TYPE vkbur,      "Sales office
          potype   TYPE bsark,      "customer PO type
          podate   TYPE bstdk,       "PO Date
          billdate TYPE fkdat,       "Billing date
          reqdate  TYPE edatu_vbak,  "Requested del.date
          po       TYPE bstnk,      "Customer PO
          name     TYPE bname_v,    "Name at header level Po
          ref_1_s  TYPE ihrez_e,    "Your reference
          cardtype TYPE ccins,      "Payment card type
          cardnum  TYPE ccnum,      "Payment card num
          cardname TYPE ccname,     "payment card name
          expdate  TYPE edidat8,    "Expiry date
        END OF ty_header,
*--*Structure to capture Partner details
        BEGIN OF ty_partner,
          partner    TYPE kunnr,      "Partner num
          item       TYPE posnr,      "Item num
          pf         TYPE parvw,      "Partner function
          ref_1_s    TYPE ihrez_e,      "Yur ref
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
          name1      TYPE name1_gp,  "Name 1
          name2      TYPE name2_gp,  "Name 2
          street     TYPE stras_gp, "House number and street
          city       TYPE ort01_gp, "City
          region     TYPE regio, "region
          postl_code TYPE pstlz, "Postal Code
          country    TYPE land1, "Country Key
          telephone  TYPE telf1, "First telephone number
          str_suppl2 TYPE ad_strspp2,
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
        END OF ty_partner,
*--*Structure to capture Text details
        BEGIN OF ty_text,
          item   TYPE posnr,       "Item num
          tdid   TYPE edi4451_a,   "Text ID
          spras  TYPE edi3453_a,   "Language
          text   TYPE edi4040_a,   "text
          format TYPE tdformat,    "Format
        END OF ty_text,
*--*Structure to capture Item details
        BEGIN OF ty_item,
          item   TYPE posnr,       "Item num
          poitem TYPE posex,      "PO Item
          menge  TYPE edi_menge,  "Qty
          pstyv  TYPE pstyv,      "Item category
          belnr  TYPE edi_belnr,  "PO
        END OF ty_item,
*--*Structure to capture Material details
        BEGIN OF ty_mat,
          item  TYPE posnr,       "Item num
          matnr TYPE matnr,       "Material
          kdmat TYPE kdmat,       "Cust mat
        END OF ty_mat,
*--*Structure to capture Item nums at shipto PO
        BEGIN OF ty_poitem,
          item  TYPE posnr,       "Item num
          zeile TYPE edi1082_a,   "PO Item at shipto
        END OF ty_poitem,
*--*Structure to capture Item requested del.date
        BEGIN OF ty_item_date,
          item     TYPE posnr,       "Item num
          podate   TYPE edidat8,      "Item req.del date
          billdate TYPE edidat8,   "Bill date
        END OF ty_item_date,
*--*Structure to capture additional details
        BEGIN OF ty_item_add,
          item   TYPE posnr,       "Item num
          mvgr1  TYPE mvgr1,  " Mat Price group1
          mvgr2  TYPE mvgr2,  " Mat Price group2
          mvgr3  TYPE mvgr3,  " Mat Price group3
          kdkg4  TYPE kdkg4,  "Customer price group4
          kdkg5  TYPE kdkg5,   "Customer price group5
          cusadd TYPE char35,
        END OF ty_item_add,
*--*Strcuture for additional custom fields
        BEGIN OF ty_item_cust,
          vposn             TYPE posnr_va,   "SO item
          vbegdat           TYPE vbdat_veda, "Contract start date
          venddat           TYPE vndat_veda, "Contract end date
          zzcontent_start_d TYPE  dats,      "Content start date
          zzcontent_end_d   TYPE dats,       "Content end date
          zzlicense_start_d TYPE  dats,      "License start date
          zzlicense_end_d   TYPE  dats,      "License end date
          zzdealtyp         TYPE zzdealtyp,  "Deal type
          zzclustyp         TYPE zzclustyp,  "Cluster type
        END OF ty_item_cust,
*--*Structure to capture pricing details
        BEGIN OF ty_cond,
          item  TYPE posnr,            "SO Item
          kschl TYPE kschl,            "Condition type
          betrg TYPE edi5004_p,        "Price
        END OF ty_cond,
*--*Structure to capture customer PO
        BEGIN OF ty_po,
          vbeln TYPE vbeln_va,         "Sales doc num
          bstnk TYPE bstnk,            "Customer PO
        END OF ty_po,
*--*KNVV
        BEGIN OF ty_knvv,
          kunnr TYPE kunnr,
          vkorg TYPE vkorg,
          vtweg TYPE vtweg,
          spart TYPE spart,
        END OF ty_knvv.
*----------------------------------------------------------------------*
* Global work areas,Internal Tabs and Variables Declaration
*----------------------------------------------------------------------*
DATA : st_header         TYPE ty_header, "Structure for Idoc header
       i_partner         TYPE STANDARD TABLE OF ty_partner, "Itab to hold Idoc partner details
       st_partner        TYPE ty_partner, "structure to hold Idoc partner details
       i_text            TYPE STANDARD TABLE OF ty_text, "Itab to hold Idoc text
       st_text           TYPE ty_text,    "Structure to hold Idoc text
       i_item            TYPE STANDARD TABLE OF ty_item, "Itab to hold Idoc item
       st_item           TYPE ty_item,     "structure to hold Idoc item
       i_cond            TYPE STANDARD TABLE OF ty_cond, "Itab to hold Idoc conditions
       st_cond           TYPE ty_cond,     "structure to hold Idoc conditions
       i_mat             TYPE STANDARD TABLE OF ty_mat,
       st_mat            TYPE ty_mat,      "structure to hold Idoc material details
       i_item_cust       TYPE STANDARD TABLE OF ty_item_cust,
       st_item_cust      TYPE ty_item_cust,  "structure to hold item cust details
       i_poitem          TYPE STANDARD TABLE OF ty_poitem,
       st_poitem         TYPE ty_poitem,     "structure to hold Idoc PO item details
       i_item_date       TYPE STANDARD TABLE OF ty_item_date,
       st_item_date      TYPE ty_item_date,   "structure to hold Idoc dates
       i_item_add        TYPE STANDARD TABLE OF ty_item_add,
       i_knvv            TYPE STANDARD TABLE OF ty_knvv,
       st_knvv           TYPE ty_knvv,
       st_item_add       TYPE ty_item_add,     "structure to hold Idoc additional details
       st_po             TYPE ty_po,           "structure to hold Idoc PO details
       i_po              TYPE STANDARD TABLE OF ty_po, "itab to hold  PO details
       i_return          TYPE STANDARD TABLE OF bapiret2, "itab to hold BAPI return messages
       i_bapi_items      TYPE STANDARD TABLE OF bapisditm, "Itab to hold BAPI Items
       i_bapi_itemsx     TYPE STANDARD TABLE OF bapisditmx, "Itab to hold BAPI Items
       i_bapi_partners   TYPE STANDARD TABLE OF bapiparnr, "Itab to hold BAPI Pratner
       i_bapi_cond       TYPE STANDARD TABLE OF bapicond,  "itab to hold BAPI conditions
       i_bapi_condx      TYPE STANDARD TABLE OF bapicondx, "Itab to hold BAPI conditions
       i_bapi_card       TYPE STANDARD TABLE OF bapiccard, "Itab to hold BAPI credit card details
       i_bapi_text       TYPE STANDARD TABLE OF bapisdtext, "Itab to hold BAPI text
       i_bapi_ext        TYPE STANDARD TABLE OF bapiparex, "Itab to hold BAPI extension
       i_bapi_contract   TYPE STANDARD TABLE OF bapictr,  "Itab to hold BAPI contract data
       i_bapi_contractx  TYPE STANDARD TABLE OF bapictrx, "Itab to hold BAPI contract data
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
       i_bapi_address    TYPE STANDARD TABLE OF bapiaddr1, "Itab to hold BAPI partner additional aaddress data
       st_bapi_address   TYPE bapiaddr1,   " "structure to hold BAPI partner additional aaddress data
       iv_we_cnt         TYPE i VALUE '100', "Ship to Count address
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
       st_bapi_header    TYPE bapisdhd1,   "structure to hold header
       st_bapi_headerx   TYPE bapisdhd1x,   "structure to hold header flags
       v_doc             TYPE bapivbeln-vbeln, "Variable to hold slaes doc
       v_idoc            TYPE edi_docnum,    "Variable to hold Idoc num
       st_return         TYPE bapiret2,      "structure to hold return
       st_bapi_items     TYPE bapisditm,     "structure to hold BAPI Items
       st_bapi_itemsx    TYPE bapisditmx,    "structure to hold BAPI Items
       st_bapi_partners  TYPE bapiparnr,     "structure to hold BAPI Partners
       st_bapi_cond      TYPE bapicond,      "structure to hold BAPI conditions
       st_bapi_condx     TYPE bapicondx,     "structure to hold BAPI conditions
       st_bapi_card      TYPE bapiccard,     "structure to hold BAPI cards
       st_bapi_text      TYPE bapisdtext,    "structure to hold BAPI text
       st_bapi_contract  TYPE bapictr,       "structure to hold BAPI contract
       st_bapi_contractx TYPE bapictrx,      "structure to hold BAPI contract
       st_bapi_ext       TYPE bapiparex.      "structure to hold BAPI extension
*----------------------------------------------------------------------*
* Global Constants
*----------------------------------------------------------------------*
CONSTANTS :
  c_error            TYPE symsgty VALUE 'E',     " Error Message
*--*Constants to hold IDOC  segment names
  c_e1edk01          TYPE char7 VALUE 'E1EDK01',
  c_e1edk36          TYPE char7 VALUE 'E1EDK36',
  c_e1edk14          TYPE char7 VALUE 'E1EDK14',
  c_e1edk02          TYPE char7 VALUE 'E1EDK02',
  c_e1edka1          TYPE char7 VALUE 'E1EDKA1',
  c_e1edka3          TYPE char7 VALUE 'E1EDKA3',
  c_e1edkt1          TYPE char7 VALUE 'E1EDKT1',
  c_e1edkt2          TYPE char7 VALUE 'E1EDKT2',
  c_e1edp01          TYPE char7 VALUE 'E1EDP01',
  c_e1edp02          TYPE char7 VALUE 'E1EDP02',
  c_e1edp03          TYPE char7 VALUE 'E1EDP03',
  c_e1edp04          TYPE char7 VALUE 'E1EDP04',
  c_e1edp05          TYPE char7 VALUE 'E1EDP05',
  c_e1edpa1          TYPE char7 VALUE 'E1EDPA1',
  c_e1edp19          TYPE char7 VALUE 'E1EDP19',
  c_e1edp35          TYPE char7 VALUE 'E1EDP35',
  c_e1edpt1          TYPE char7 VALUE 'E1EDPT1',
  c_e1edpt2          TYPE char7 VALUE 'E1EDPT2',
  c_e1edk03          TYPE char7 VALUE 'E1EDK03',
  c_z1qtc_e1edk01    TYPE char20 VALUE 'Z1QTC_E1EDK01_01',
  c_z1qtc_e1edp01_01 TYPE char20 VALUE 'Z1QTC_E1EDP01_01',
  c_bus2034          TYPE bapiusw01-objtype VALUE 'BUS2034', "business object
*--*Constants for Idoc qualifiers
  c_qualf_012        TYPE char3 VALUE '012',
  c_qualf_008        TYPE char3 VALUE '008',
  c_qualf_006        TYPE char3 VALUE '006',
  c_qualf_007        TYPE char3 VALUE '007',
  c_qualf_016        TYPE char3 VALUE '016',
  c_qualf_019        TYPE char3 VALUE '019',
  c_qualf_022        TYPE char3 VALUE '022',
  c_qualf_026        TYPE char3 VALUE '026',
  c_qualf_002        TYPE char3 VALUE '002',
  c_qualf_003        TYPE char3 VALUE '003',
  c_qualf_009        TYPE char3 VALUE '009',
  c_qualf_44         TYPE char3 VALUE '044',
  c_qualf_001        TYPE char3 VALUE '001',
  c_qalf_002         TYPE char3 VALUE '002',
  c_qalf_001         TYPE char3 VALUE '001',
  c_qualf_005        TYPE char3 VALUE '005',
  c_qualf_010        TYPE char3 VALUE '010',
*--*Constants for Partnr functions
  c_pf_ag            TYPE char2 VALUE 'AG',
  c_pf_we            TYPE char2 VALUE 'WE',
*--*Constants for Document types
  c_zsub             TYPE char4 VALUE 'ZSUB',
  c_zmbr             TYPE char4 VALUE 'ZMBR',
*--*Constants for Idoc status
  c_status_53        TYPE char2 VALUE '53',
  c_status_51        TYPE char2 VALUE '51',
  c_header_item      TYPE char6 VALUE '000000',
*--*Constants for additional flags
  c_x                TYPE c VALUE 'X', "ABAP_TRUE
  c_e                TYPE c VALUE 'E', "ERROR
  c_a                TYPE c VALUE 'A', "ABORT
  c_s                TYPE c VALUE 'S'. "SUCCESS
