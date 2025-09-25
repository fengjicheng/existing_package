*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OPM_ORDER_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILE_UPLOAD_ORDBP_TOP (Declarations)
* PROGRAM DESCRIPTION: Create ZOPM (Online Program Management ) contracts
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   03/06/2019
* OBJECT ID:       TBD
* TRANSPORT NUMBER(S): ED2K914619
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
*====================================================================*
* T A B L E S
*====================================================================*
TABLES:   sscrfields. "Screenfields

*====================================================================*
* S T R U C T U R E
*====================================================================*
TYPES: BEGIN OF ty_excel_zopm,
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
         posnr      TYPE posnr,
       END OF ty_excel_zopm,

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
         posnr      TYPE posnr,
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

TYPES:tt_excel_zopm TYPE  TABLE OF ty_excel_zopm,
      tt_ord_alv    TYPE STANDARD TABLE OF ty_ord_alv INITIAL SIZE 0,
      tt_bom_items  TYPE STANDARD TABLE OF ty_bom_items INITIAL SIZE 0.
*====================================================================*
* T A B L E  T Y P E S
*====================================================================*


*====================================================================*
*  I N T E R N A L  T A B L E
*====================================================================*
DATA:
  i_ord_alv      TYPE STANDARD TABLE OF  ty_ord_alv
                     INITIAL SIZE 0,
  i_final_zopm   TYPE STANDARD TABLE OF  ty_excel_zopm
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
      st_final_x  TYPE ty_excel_zopm,
      st_output_x TYPE ty_ord_alv,
      st_layout   TYPE slis_layout_alv.
*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_titlebar   TYPE syst_title, " For consolidated error message
      v_tdid       TYPE tdid,     " Text ID
      v_c108_path  TYPE salv_de_selopt_low,
      v_c108_sorg  TYPE salv_de_selopt_low,
      v_c108_dist  TYPE salv_de_selopt_low,
      v_c108_cond  TYPE salv_de_selopt_low,
      v_log        TYPE char100,
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

  DATA: v_column TYPE ole2_object.

*====================================================================*
* C O N S T A N T S
*====================================================================*

CONSTANTS: c_x      TYPE char1    VALUE 'X',        "for marking the radiobutton as selected
           c_zopm   TYPE auart    VALUE 'ZOPM',      "for ZOPM order type
           c_e      TYPE char1    VALUE 'E',        "update flag
           c_u      TYPE char1    VALUE 'U',        "update flag
           c_format TYPE tdformat VALUE '*',        " Tag column
           c_vbbk   TYPE tdobject VALUE 'VBBK',     " Texts: Application Object
           c_vbbp   TYPE tdobject VALUE 'VBBP',     " Texts: Application Object
           c_devid  TYPE zdevid   VALUE 'C108',
           c_path   TYPE rvari_vnam   VALUE 'LOGICAL_PATH',
           c_sorg   TYPE rvari_vnam   VALUE 'SALES_ORG',
           c_dist   TYPE rvari_vnam   VALUE 'DIST_CHANNEL',
           c_cond   TYPE rvari_vnam   VALUE 'COND_TYPE',
           c_limit  TYPE rvari_vnam   VALUE 'LINES_LIMIT',
           c_tdid   TYPE rvari_vnam   VALUE 'TDID',
           c_fc01   TYPE syst_ucomm VALUE 'FC01',
           c_sp     TYPE parvw    VALUE 'AG',
           c_we     TYPE parvw    VALUE 'WE',
           c_custo  TYPE char10   VALUE 'CUSTOMER',
           c_parvw  TYPE char10   VALUE 'PARVW',
           c_kunnr  TYPE char10   VALUE 'KUNNR',
           c_vkorg  TYPE char10   VALUE 'VKORG',
           c_vtweg  TYPE char10   VALUE 'VTWEG',
           c_spart  TYPE char10   VALUE 'SPART',
           c_guebg  TYPE char10   VALUE 'GUEBG',
           c_gueen  TYPE char10   VALUE 'GUEEN',
           c_posnr  TYPE char10   VALUE 'POSNR',
           c_matnr  TYPE char10   VALUE 'MATNR',
           c_plant  TYPE char10   VALUE 'PLANT',
           c_vbeln  TYPE char10   VALUE 'VBELN',
           c_pstyv  TYPE char10   VALUE 'PSTYV',
           c_zmeng  TYPE char10   VALUE 'ZMENG',
           c_lifsk  TYPE char10   VALUE 'LIFSK',
           c_faksk  TYPE char10   VALUE 'FAKSK',
           c_abgru  TYPE char10   VALUE 'ABGRU',
           c_auart  TYPE char10   VALUE 'AUART',
           c_xblnr  TYPE char10   VALUE 'XBLNR',
           c_zlsch  TYPE char10   VALUE 'ZLSCH',
           c_bsark  TYPE char10   VALUE 'BSARK',
           c_bstn   TYPE char10   VALUE 'BSTNK',
           c_stxh   TYPE char10   VALUE 'STXH',
           c_kschl  TYPE char10   VALUE 'KSCHL',
           c_kbetr  TYPE char10   VALUE 'KBETR',
           c_ihrez  TYPE char10   VALUE 'IHREZ',
           c_ihreze TYPE char10   VALUE 'IHREZ_E',
           c_zzpro  TYPE char10   VALUE 'ZZPROMO',
           c_kdkg4  TYPE char10   VALUE 'KDKG4',
           c_kdkg5  TYPE char10   VALUE 'KDKG5',
           c_kdkg3  TYPE char10   VALUE 'KDKG3',
           c_srid   TYPE char10   VALUE 'SRID',
           c_vkbur  TYPE char10   VALUE 'VKBUR',
           c_fkdat  TYPE char10   VALUE 'FKDAT',
           c_waerk  TYPE char10   VALUE 'WAERK',
           c_zuonr  TYPE char10   VALUE 'ZUONR',
           c_invtx  TYPE char10   VALUE 'INV_TEXT',
           c_fkimg  TYPE char10   VALUE 'FKIMG',
           c_kwmeng TYPE char10   VALUE 'KWMENG',
           c_augru  TYPE char10   VALUE 'AUGRU',
           c_kschl2 TYPE char10   VALUE 'KSCHL2',
           c_kbetr2 TYPE char10   VALUE 'KBETR2',
           c_kschl3 TYPE char10   VALUE 'KSCHL3',
           c_kbetr3 TYPE char10   VALUE 'KBETR3',
           c_ztax   TYPE char4    VALUE 'ZTAX',
           c_tax    TYPE char4    VALUE 'TAX',
           c_ZU     TYPE CHAR2    VALUE 'ZU'.
