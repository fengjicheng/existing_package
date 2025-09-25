*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E205_ORDER_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_E205_ORDER_UPLOAD (Main Program)
* PROGRAM DESCRIPTION: Create contracts for Knewton
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   05/28/2019
* OBJECT ID:       E205
* TRANSPORT NUMBER(S): ED2K915128
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------
* REVISION NO   : ED2K922307
* REFERENCE NO  : OTCM-43068
* DEVELOPER     : MIMMADISET
* DATE(MM/DD/YYYY): 03/04/2021
* DESCRIPTION   : Document Currency population for the contract creation from KNVV table
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO   : ED2K925068
* REFERENCE NO  : OTCM-54746,54881
* DEVELOPER     : MIMMADISET
* DATE(MM/DD/YYYY): 11/25/2021
* DESCRIPTION   : Adding two columns in Order upload program
* 1. New column for SFDC case at the header level in Knewton project
* 2. New column for Acceptance date at the item level in EJ Press project
* 3. Fixed the 0.25 hours scenario in orders.
* 4. Added the new validation for amount columns and quantity
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO   : ED2K925236,ED2K925265
* REFERENCE NO  : OTCM-55395
* DEVELOPER     : MIMMADISET
* DATE(MM/DD/YYYY): 12/10/2021
* DESCRIPTION   : Billing date updation
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO   :ED2K927215
* REFERENCE NO  :OTCM-63370
* DEVELOPER     :PBALASUB
* DATE(MM/DD/YYYY): 05/11/2022
* DESCRIPTION   :Added a logic to populate the material description
* Based on the language
*-------------------------------------------------------------------
*====================================================================*
* T A B L E S
*====================================================================*
TABLES:   sscrfields. "Screenfields

*====================================================================*
* S T R U C T U R E
*====================================================================*
TYPES: BEGIN OF ty_excel_ord,
         uid        TYPE char50, " Uid of type CHAR50
         auart      TYPE char50, " Sales Document Type
         spart      TYPE spart, " division SAP mandatory
         bstkd      TYPE char50, " purchase order number
         kunnr_sp   TYPE kunnr, " Customer Number - Sold to
         kunnr_we   TYPE kunnr, " Customer Number - Ship to
         vkbur      TYPE char50, " Sales Office
         augru      TYPE augru,  " Order eason
         guebg      TYPE char50, " contract start date Wiley mandatory
         gueen      TYPE char50, " contract end date Wiley mandatory
         faksk      TYPE char50, " billing block
         matnr      TYPE matnr, " Material
         kwmeng     TYPE char50, " Cumulative Order Quantity in Sales Units
         arktx      TYPE arktx,  " Contract Item Text
         kdmat      TYPE matnr_ku, " Material used by Coustomer
         vkaus      TYPE vkaus,  " Usae Indicator
         guebg_itm  TYPE char50, " contract start date Wiley mandatory
         gueen_itm  TYPE char50, " contract end date Wiley mandatory
         faksp      TYPE char50, " billing block Item
         kbetr      TYPE char50, " pricing Wiley mandatory
         kschl      TYPE char50, " pricing condition value Wiley mandatory
         kbetr2     TYPE char50, " pricing Wiley mandatory
         kschl2     TYPE char50, " pricing condition value Wiley mandatory
         kbetr3     TYPE char50, " pricing Wiley mandatory
         parvw      TYPE char50, " Partner Function
         partner    TYPE kunnr, " Customer Number
         name1      TYPE char50, " Name1 of type CHAR50
         name2      TYPE char50, " Name2 of type CHAR50
         street     TYPE char50, " Street of type CHAR50
         city1      TYPE char50, " City of type CHAR50
         post_code1 TYPE char50, " Postal code of type CHAR50
         regio      TYPE char50, " Regio of type CHAR50
         land1      TYPE char50, " Land1 of type CHAR50
         tzone      TYPE char50, " time zone of type CHAR50
         disc       TYPE char200, "Disc info
*         devid      TYPE zdevid,  " DEVID  Knewton Project NPOLINA ED2K915113

         quan_uom   TYPE char3, "Target Quantity UOM ++ mimmadiset OTCM-52349 ED2K924779
         zzsfdccase TYPE zsdfc, "SFDC case ++ mimmadiset OTCM-54746 ED2K925068
         vabndat    TYPE char50,   "Acceptance date ++ mimmadiset OTCM-54746 ED2K925068
         fkdat      TYPE char50, "Billing date ++ mimmadiset OTCM-55395 ED2K925236
         posnr      TYPE posnr,  "++ mimmadiset OTCM-55395ED2K925265
       END OF ty_excel_ord,

       BEGIN OF ty_bom_items,
         old_posnr TYPE posnr, " Item number of the SD document
         new_posnr TYPE posnr, " Item number of the SD document
       END OF ty_bom_items.

TYPES: BEGIN OF ty_ord_alv,
         sel        TYPE char50, " Uid of type CHAR50
         auart      TYPE auart, " Sales Document Type
         spart      TYPE spart, " division SAP mandatory
         bstkd      TYPE char50, " purchase order number
         kunnr_sp   TYPE kunnr, " Customer Number - Sold to
         kunnr_we   TYPE kunnr, " Customer Number - Ship to
         vkbur      TYPE char50, " Sales Office
         augru      TYPE augru,  " Order eason
         guebg      TYPE char50, " contract start date Wiley mandatory
         gueen      TYPE char50, " contract end date Wiley mandatory
         faksk      TYPE char50, " billing block
         matnr      TYPE matnr, " Material
         kwmeng     TYPE char20, " Cumulative Order Quantity in Sales Units
         arktx      TYPE arktx,  " Contract Item Text
         kdmat      TYPE matnr_ku, " Material used by Coustomer
         vkaus      TYPE vkaus,  " Usae Indicator
         guebg_itm  TYPE char50, " contract start date Wiley mandatory
         gueen_itm  TYPE char50, " contract end date Wiley mandatory
         faksp      TYPE char50, " billing block Item
         kbetr      TYPE char50, " pricing Wiley mandatory
         kschl      TYPE kschl, " pricing condition value Wiley mandatory
         kbetr2     TYPE char50, " pricing Wiley mandatory
         kschl2     TYPE kschl, " pricing condition value Wiley mandatory
         kbetr3     TYPE char50, " pricing Wiley mandatory
         parvw      TYPE char50, " Partner Function
         partner    TYPE kunnr, " Customer Number
         name1      TYPE char50, " Name1 of type CHAR50
         name2      TYPE char50, " Name2 of type CHAR50
         street     TYPE char50, " Street of type CHAR50
         city1      TYPE char50, " City of type CHAR50
         post_code1 TYPE char50, " Postal code of type CHAR50
         regio      TYPE char50, " Regio of type CHAR50
         land1      TYPE char50, " Land1 of type CHAR50
         tzone      TYPE char50, " time zone of type CHAR50
         disc       TYPE char200, "Disc info
*         devid      TYPE zdevid , " DEVID  Knewton Project NPOLINA ED2K915113
         quan_uom   TYPE char3, "Target Quantity UOM ++ mimmadiset OTCM-52349 ED2K924779
         zzsfdccase TYPE zsdfc, "SFDC case ++ mimmadiset OTCM-54746 ED2K925068
         vabndat    TYPE char50,   "Acceptance date ++ mimmadiset OTCM-54746 ED2K925068
         fkdat      TYPE char50, "Billing date ++ mimmadiset OTCM-55395 ED2K925236
         posnr      TYPE posnr, "++ mimmadiset OTCM-55395ED2K925265
       END OF ty_ord_alv.

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

TYPES:tt_excel_ord TYPE  TABLE OF ty_excel_ord,
      tt_ord_alv   TYPE STANDARD TABLE OF ty_ord_alv INITIAL SIZE 0,
      tt_bom_items TYPE STANDARD TABLE OF ty_bom_items INITIAL SIZE 0.
*====================================================================*
* T A B L E  T Y P E S
*====================================================================*


*====================================================================*
*  I N T E R N A L  T A B L E
*====================================================================*
DATA:
  i_ord_alv      TYPE STANDARD TABLE OF  ty_ord_alv
                     INITIAL SIZE 0,
  i_final_ord    TYPE STANDARD TABLE OF  ty_excel_ord
                    INITIAL SIZE 0,
  i_err_msg      TYPE STANDARD TABLE OF wlf1_error, "  Error Message Structure
  i_err_msg1     TYPE STANDARD TABLE OF wlf1_error,
  i_fcat_out     TYPE slis_t_fieldcat_alv,
  i_attach       TYPE STANDARD TABLE OF solisti1,     "Itab to hold attachment for email
  i_err_msg_list TYPE TABLE OF wlf1_err_li      ,     " Agency business: Error message structure, list processor
  i_message      TYPE STANDARD TABLE OF solisti1,     " SAPoffice: Single List with Column Length 255
  i_const        TYPE STANDARD TABLE OF ty_const.
*====================================================================*
*   W O R K - A R E A
*====================================================================*
DATA: st_fcat_out TYPE slis_fieldcat_alv, " ALV specific tables and structures
      st_err_msg  TYPE wlf1_error,        " Vendor Billing Document: Error Message Structure
      st_final_x  TYPE ty_excel_ord,
      st_output_x TYPE ty_ord_alv,
      st_layout   TYPE slis_layout_alv.
*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_titlebar   TYPE syst_title, " For consolidated error message
*      v_tdid       TYPE tdid,     " Text ID
      v_e205_path  TYPE salv_de_selopt_low,
*      v_e205_sorg  TYPE salv_de_selopt_low,
*      v_e205_dist  TYPE salv_de_selopt_low,
*      v_e205_cond  TYPE salv_de_selopt_low,
      v_log        TYPE char100,
*      v_devid      TYPE zdevid,   " NPOLINA 27/May/2019  ED2K915113
*====================================================================*
* C L A S S
*====================================================================*
      o_ref_grid   TYPE REF TO cl_gui_alv_grid, " ALV List Viewer
      v_fpath      TYPE localfile,       " Local file for upload/download
      v_path_fname TYPE localfile,       " Local file for upload/download
      v_job_name   TYPE tbtcjob-jobname, " Background job name
      v_line_lmt   TYPE sytabix.         " Row Index of Internal Tables

INCLUDE ole2incl.
* handles for OLE objects
DATA: v_excel TYPE ole2_object,        " Excel object
      v_mapl  TYPE ole2_object,         " list of workbooks
      v_map   TYPE ole2_object,          " workbook
      v_zl    TYPE ole2_object,           " cell
      v_f     TYPE ole2_object.            " font
DATA  v_h TYPE i.

DATA: v_column    TYPE ole2_object,
      v_skip_curr TYPE char1.  ""++mimmadiset 03/04/2021 OTCM-43068

*====================================================================*
* C O N S T A N T S
*====================================================================*

CONSTANTS: c_x         TYPE char1    VALUE 'X',        "for marking the radiobutton as selected
           c_e         TYPE char1    VALUE 'E',        "update flag
           c_u         TYPE char1    VALUE 'U',        "update flag
           c_devid     TYPE zdevid   VALUE 'E205',
           c_format    TYPE tdformat VALUE '*',        " Tag column
           c_vbbk      TYPE tdobject VALUE 'VBBK',     " Texts: Application Object
           c_vbbp      TYPE tdobject VALUE 'VBBP',     " Texts: Application Object
           c_path      TYPE rvari_vnam   VALUE 'LOGICAL_PATH',
           c_sorg      TYPE rvari_vnam   VALUE 'SALES_ORG',
           c_dist      TYPE rvari_vnam   VALUE 'DIST_CHANNEL',
           c_cond      TYPE rvari_vnam   VALUE 'COND_TYPE',
           c_limit     TYPE rvari_vnam   VALUE 'LINES_LIMIT',
           c_tdid      TYPE rvari_vnam   VALUE 'TDID',
           c_fc01      TYPE syst_ucomm VALUE 'FC01',
           c_sp        TYPE parvw    VALUE 'AG',
           c_we        TYPE parvw    VALUE 'WE',
           c_custo     TYPE char10   VALUE 'CUSTOMER',
           c_parvw     TYPE char10   VALUE 'PARVW',
           c_kunnr     TYPE char10   VALUE 'KUNNR',
           c_vkorg     TYPE char10   VALUE 'VKORG',
           c_vtweg     TYPE char10   VALUE 'VTWEG',
           c_spart     TYPE char10   VALUE 'SPART',
           c_guebg     TYPE char10   VALUE 'GUEBG',
           c_gueen     TYPE char10   VALUE 'GUEEN',
           c_posnr     TYPE char10   VALUE 'POSNR',
           c_matnr     TYPE char10   VALUE 'MATNR',
           c_plant     TYPE char10   VALUE 'PLANT',
           c_vbeln     TYPE char10   VALUE 'VBELN',
           c_pstyv     TYPE char10   VALUE 'PSTYV',
           c_zmeng     TYPE char10   VALUE 'ZMENG',
           c_lifsk     TYPE char10   VALUE 'LIFSK',
           c_faksk     TYPE char10   VALUE 'FAKSK',
           c_abgru     TYPE char10   VALUE 'ABGRU',
           c_auart     TYPE char10   VALUE 'AUART',
           c_xblnr     TYPE char10   VALUE 'XBLNR',
           c_zlsch     TYPE char10   VALUE 'ZLSCH',
           c_bsark     TYPE char10   VALUE 'BSARK',
           c_bstn      TYPE char10   VALUE 'BSTNK',
           c_stxh      TYPE char10   VALUE 'STXH',
           c_kschl     TYPE char10   VALUE 'KSCHL',
           c_kbetr     TYPE char10   VALUE 'KBETR',
           c_ihrez     TYPE char10   VALUE 'IHREZ',
           c_ihreze    TYPE char10   VALUE 'IHREZ_E',
           c_zzpro     TYPE char10   VALUE 'ZZPROMO',
           c_kdkg4     TYPE char10   VALUE 'KDKG4',
           c_kdkg5     TYPE char10   VALUE 'KDKG5',
           c_kdkg3     TYPE char10   VALUE 'KDKG3',
           c_srid      TYPE char10   VALUE 'SRID',
           c_vkbur     TYPE char10   VALUE 'VKBUR',
           c_fkdat     TYPE char10   VALUE 'FKDAT',
           c_waerk     TYPE char10   VALUE 'WAERK',
           c_zuonr     TYPE char10   VALUE 'ZUONR',
           c_invtx     TYPE char10   VALUE 'INV_TEXT',
           c_fkimg     TYPE char10   VALUE 'FKIMG',
           c_kwmeng    TYPE char10   VALUE 'KWMENG',
           c_augru     TYPE char10   VALUE 'AUGRU',
           c_kschl2    TYPE char10   VALUE 'KSCHL2',
           c_kbetr2    TYPE char10   VALUE 'KBETR2',
           c_kschl3    TYPE char10   VALUE 'KSCHL3',
           c_kbetr3    TYPE char10   VALUE 'KBETR3',
           c_ztax      TYPE char4    VALUE 'ZTAX',
           c_tax       TYPE char4    VALUE 'TAX',
           c_zu        TYPE char2    VALUE 'ZU',
           c_waers     TYPE rvari_vnam VALUE 'WAERS', "++mimmadiset 03/04/2021 OTCM-43068
           c_mat_spras TYPE rvari_vnam VALUE 'MAT_SPRAS'. "++ MIMMADSETY 05/11/2022 OTCM-63370 ED2K927215
