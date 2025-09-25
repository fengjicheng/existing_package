*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_BP_ORDER_UPLD (Main Program)
* PROGRAM DESCRIPTION: To upload BP and subscription orders
* DEVELOPER: Nageswara(NPOLINA)
* CREATION DATE:   02/Dec/2019
* OBJECT ID: E225
* TRANSPORT NUMBER(S):ED2K916854
*----------------------------------------------------------------------*
* REVISION NO: ED2K919708
* REFERENCE NO: ERPM-4390
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE:   29/Sept/2020
* OBJECT ID:       E225
* DESCRIPTION: Make Condition grp2 Mandatory when order type 'ZOR' and
* Item category ZTXD or ZTXP
*----------------------------------------------------------------------*
* REVISION NO:                                                         *
* REFERENCE NO:                                                        *
* DEVELOPER:                                                           *
* DATE:                                                                *
* DESCRIPTION:                                                         *
*----------------------------------------------------------------------*
*====================================================================*
* T A B L E S
*====================================================================*
TABLES:
  sscrfields. "Screenfields
TYPE-POOLS:   ixml.  " XML Library Types
*====================================================================*
* S T R U C T U R E
*====================================================================*
TYPES: BEGIN OF ty_date,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE sydatum,    " System Date
         high TYPE sydatum,    " System Date
       END OF ty_date.

TYPES: BEGIN OF ty_xml_line,  " Structure for xml line
         data(255) TYPE x,
       END OF ty_xml_line.
TYPES: BEGIN OF ty_edit,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE fieldname,  " Field Name
         high TYPE fieldname,  " Field Name
       END OF ty_edit.

TYPES: BEGIN OF ty_excel_enhanced, "type for excel upload  "E225
         sel,
         identifier   TYPE char20,
         customer     TYPE kunnr,      " Customer Number
         parvw        TYPE parvw,      " Partner Function
         head_item    TYPE char1,      " Head or Item?
         bu_type      TYPE bu_type,
         bu_title     TYPE ad_title,
         name_f       TYPE bu_namep_f,
         name_l       TYPE bu_namep_l,
         suffix       TYPE char10,
         str_suppl2   TYPE ad_strspp2,
         str_suppl1   TYPE ad_strspp1,
         street       TYPE ad_street,
         str_suppl3   TYPE ad_strspp3,
         location     TYPE ad_lctn,
         city1        TYPE ad_city1,
         region       TYPE regio,
         country      TYPE land1,
         post_code1   TYPE ad_pstcd1,
         smtp_addr    TYPE ad_smtpadr,
         tel_number   TYPE ad_tlnmbr1,
         reltyp       TYPE bu_reltyp,
         datfrom      TYPE bu_datfrom,
         dateto       TYPE bu_datto,
         partner2     TYPE bu_partner,
         katr6        TYPE katr6,
         kdgrp        TYPE kdgrp,
         auart        TYPE auart,      "Sales Document Type
         vbeln        TYPE vbeln,      "Sales and Distribution Document Number
         vkorg        TYPE vkorg,      "sales org. SAP mandatory
         vtweg        TYPE vtweg,      "dist. channel SAP mandatory
         spart        TYPE spart,      "division SAP mandatory
         vkbur        TYPE vkbur, " Sales Office
         waerk        TYPE waerk, " SD Document Currency
         bstnk        TYPE bstnk,      "purchase order number Wiley mandatory
         bsark        TYPE bsark,      "PO Type
         xblnr        TYPE xblnr_v1,   "Reference
         zuonr        TYPE ordnr_v,  "Assignment number
         zlsch        TYPE schzw_bseg, "Payment Method
         fkdat        TYPE fkdat, " Billing date for billing index and printout
         stxh(264)    TYPE c,
         invinst(264) TYPE c,
         vaktsch      TYPE vasch_veda,    " Action
         vasda        TYPE vasda,         " Date for Action
         perio        TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte        TYPE autte,         " In Advance
         peraf        TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
         lifsk        TYPE lifsk,      "delivery block Wiley mandatory
         faksk        TYPE faksk,      "billing block Wiley mandatory
         posnr        TYPE posnr_va,
         matnr        TYPE matnr,      "Material
         vbegdat      TYPE vbdat_veda,
         venddat      TYPE vndat_veda,
         pstyv        TYPE pstyv,      "item category SAP mandatory
         kwmeng       TYPE dzmeng,     "target quantity
         augru        TYPE augru,
         kschl        TYPE kschl,      "pricing condition type
         kbetr        TYPE char17,      "pricing amount
         ihrez_e      TYPE ihrez_e,  "missing
         zzpromo      TYPE zpromo,     "Promo code
         kdkg4        TYPE kdkg4,      " Customer condition group 4
         kdkg4_2      TYPE kdkg4,      " price override reason group
         pq_typ(2)    TYPE c,          " PQ Subscription type
         ihrez        TYPE ihrez,
         kdkg2        TYPE kdkg2,
         bp_email     TYPE ad_smtpadr, "missing
       END OF ty_excel_enhanced.

TYPES: BEGIN OF ty_output_x,   "E225
         sel,
         identifier   TYPE char20,
         customer     TYPE kunnr,      " Customer Number
         parvw        TYPE parvw,      " Partner Function
         head_item    TYPE char1,      " Head or Item?
         bu_type      TYPE bu_type,
         bu_title     TYPE ad_title,
         name_f       TYPE bu_namep_f,
         name_l       TYPE bu_namep_l,
         suffix       TYPE char10,
         str_suppl2   TYPE ad_strspp2,
         str_suppl1   TYPE ad_strspp1,
         street       TYPE ad_street,
         str_suppl3   TYPE ad_strspp3,
         location     TYPE ad_lctn,
         city1        TYPE ad_city1,
         region       TYPE regio,
         country      TYPE land1,
         post_code1   TYPE ad_pstcd1,
         smtp_addr    TYPE ad_smtpadr,
         tel_number   TYPE ad_tlnmbr1,
         reltyp       TYPE bu_reltyp,
         datfrom      TYPE char10,
         dateto       TYPE char10,
         partner2     TYPE bu_partner,
         katr6        TYPE katr6,
         kdgrp        TYPE kdgrp,
         auart        TYPE auart,      "Sales Document Type
         vbeln        TYPE vbeln,      "Sales and Distribution Document Number
         vkorg        TYPE vkorg,      "sales org. SAP mandatory
         vtweg        TYPE vtweg,      "dist. channel SAP mandatory
         spart        TYPE spart,      "division SAP mandatory
         vkbur        TYPE vkbur, " Sales Office
         waerk        TYPE waerk, " SD Document Currency
         bstnk        TYPE bstnk,      "purchase order number Wiley mandatory
         bsark        TYPE bsark,      "PO Type
         xblnr        TYPE xblnr_v1,   "Reference
         zuonr        TYPE ordnr_v,  "Assignment number
         zlsch        TYPE schzw_bseg, "Payment Method
         fkdat        TYPE fkdat, " Billing date for billing index and printout
         stxh(264)    TYPE c,
         invinst(264) TYPE c,
         vaktsch      TYPE vasch_veda,    " Action
         vasda        TYPE vasda,         " Date for Action
         perio        TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte        TYPE autte,         " In Advance
         peraf        TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
         lifsk        TYPE lifsk,      "delivery block Wiley mandatory
         faksk        TYPE faksk,      "billing block Wiley mandatory
         posnr        TYPE posnr_va,
         matnr        TYPE matnr,      "Material
         vbegdat      TYPE vbdat_veda,
         venddat      TYPE vndat_veda,
         pstyv        TYPE pstyv,      "item category SAP mandatory
         kwmeng       TYPE char17, "dzmeng,     "target quantity
         augru        TYPE augru,
         kschl        TYPE kschl,      "pricing condition type
         kbetr        TYPE char14, "kbetr,      "pricing amount
         ihrez_e      TYPE ihrez_e,
         zzpromo      TYPE zpromo,     "Promo code
         kdkg4        TYPE kdkg4,      " Customer condition group 4
         kdkg4_2      TYPE kdkg4,      " price override reason group
         pq_typ(2)    TYPE c,          " PQ Subscription type
         ihrez        TYPE ihrez,
         kdkg2        TYPE kdkg2,
         bp_email     TYPE ad_smtpadr,
       END OF ty_output_x,

       BEGIN OF ty_bom_items,
         old_posnr TYPE posnr, " Item number of the SD document
         new_posnr TYPE posnr, " Item number of the SD document
       END OF ty_bom_items,

       BEGIN OF ty_path,
         devid TYPE zdevid,
         low   TYPE salv_de_selopt_low,
       END OF ty_path.

TYPES: BEGIN OF ty_cond_class,
         kappl TYPE kappl,                                            " Application
         kschl TYPE kscha,                                            " Condition Type
         krech TYPE krech,                                            " Condition Class
       END OF ty_cond_class,
       tt_cond_class TYPE STANDARD TABLE OF ty_cond_class INITIAL SIZE 0,
       tt_bapicond   TYPE STANDARD TABLE OF bapicond INITIAL SIZE 0,  " Communication Fields for Maintaining Conditions in the Order
       tt_bapicondx  TYPE STANDARD TABLE OF bapicondx INITIAL SIZE 0. " Communication Fields for Maintaining Conditions in the Order

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
       END OF ty_const,

       BEGIN OF ty_tvak,
         auart TYPE auart,
         vbtyp TYPE vbtyp,
       END OF ty_tvak.


*====================================================================*
* T A B L E  T Y P E S
*====================================================================*
TYPES: tt_edit         TYPE STANDARD TABLE OF ty_edit
                          INITIAL SIZE 0,
       tt_excel_enh    TYPE STANDARD TABLE OF ty_excel_enhanced
                          INITIAL SIZE 0,
       tt_output_x     TYPE STANDARD TABLE OF ty_output_x
                          INITIAL SIZE 0,

       tt_bom_items    TYPE STANDARD TABLE OF ty_bom_items
                          INITIAL SIZE 0,
       tt_date         TYPE STANDARD TABLE OF ty_date
                          INITIAL SIZE 0,

       tt_err_msg      TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                          INITIAL SIZE 0,
       tt_err_msg_list TYPE STANDARD TABLE OF wlf1_err_li
                          INITIAL SIZE 0.

*====================================================================*
*  I N T E R N A L  T A B L E
*====================================================================*
DATA:
  i_edit         TYPE tt_edit,

  i_final        TYPE zttqtc_bporder,    " This internal table would be used for data storing during validation
  i_final_err    TYPE zttqtc_bporder,    " This internal table would be used for data storing during validation
  i_output_x     TYPE zttqtc_bporder,    " For the ALV display

  i_err_msg      TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                     INITIAL SIZE 0,
  i_err_msg1     TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                     INITIAL SIZE 0,

  i_final_csv    TYPE truxs_t_text_data,

  i_message      TYPE STANDARD TABLE OF solisti1,                  " SAPoffice: Single List with Column Length 255
  i_attach       TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_err_msg_list TYPE wlf1_err_li                                  " Agency business: Error message structure, list processor
                   OCCURS 0 WITH HEADER LINE,
  i_auart        TYPE shp_auart_range_t,
  i_auart_head   TYPE shp_auart_range_t,
  i_auart_item   TYPE shp_auart_range_t,
  i_auart_grp    TYPE shp_auart_range_t,
*  BOC by Thilina on 09/29/2020 for ERPM-4390 with ED2K919708
  i_pstyv_grp    TYPE rjksd_pstyv_range_tab,
*  EOC by Thilina on 09/29/2020 for ERPM-4390 with ED2K919708
  i_vbtyp        TYPE saco_vbtyp_ranges_tab,
  i_const        TYPE STANDARD TABLE OF ty_const,
  i_tvak         TYPE STANDARD TABLE OF ty_tvak,
  i_path         TYPE STANDARD TABLE OF ty_path,
  i_bp_data      TYPE STANDARD TABLE OF zsqtc_bp_update,  " BP funcation module internal table
  iv_identifier  TYPE char20,
  iv_batchuser   TYPE char20.
*====================================================================*
*   W O R K - A R E A
*====================================================================*
DATA:
  st_err_msg    TYPE wlf1_error,        " Vendor Billing Document: Error Message Structure
  st_final_x    TYPE zstqtc_bporder, "ty_excel_enhanced, " For subscription order "E225
  st_final_csv  TYPE LINE OF truxs_t_text_data,
  st_auart      TYPE shp_auart_range,
  st_vbtyp      TYPE saco_vbtyp_ranges_tab,
  st_output_x   TYPE zstqtc_bporder, "ty_output_x,       " For create subscription order alv
  st_layout     TYPE slis_layout_alv,
  st_loghandle  TYPE bal_t_logh,
  i_lognum      TYPE bal_t_lgnm,
  st_lognum     TYPE bal_s_lgnm,
  i_staging     TYPE TABLE OF ze225_staging,
  st_staging    TYPE ze225_staging,
  st_msg        TYPE bal_s_msg,
  st_log        TYPE bal_s_log,
  st_log_handle TYPE balloghndl.

*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_titlebar   TYPE sy-title, " For consolidated error message
      v_tdid       TYPE tdid,     " Text ID
      v_e225       TYPE salv_de_selopt_low,
      v_oid        TYPE numc10,
      v_auart      TYPE auart,
      v_cont       TYPE char1,
      v_ord        TYPE char1,
*====================================================================*
* C L A S S
*====================================================================*
      o_ref_grid   TYPE REF TO cl_gui_alv_grid, " ALV List Viewer
      v_fpath      TYPE localfile,       " Local file for upload/download
      v_file_chk   TYPE rlgrap-filename,       " Local file for upload/download
      v_path_fname TYPE localfile,       " Local file for upload/download
      v_job_name   TYPE tbtcjob-jobname, " Background job name
      v_line_lmt   TYPE sytabix,        " Row Index of Internal Tables
      v_sourcepath TYPE  sapb-sappfad,
      v_targetpath TYPE  sapb-sappfad.
*====================================================================*
* C O N S T A N T S
*====================================================================*

CONSTANTS: c_x         TYPE char1    VALUE 'X',        "for marking the radiobutton as selected
           c_format    TYPE tdformat VALUE '*',        " Tag column
           c_extn      TYPE char4 VALUE '.csv', " Extn of type CHAR4
           c_vbbk      TYPE tdobject VALUE 'VBBK',     " Texts: Application Object
           c_vbbp      TYPE tdobject VALUE 'VBBP',     " Texts: Application Object
           c_zofl      TYPE auart     VALUE 'ZOFL',    "Order type ZOFL
           c_sub       TYPE auart    VALUE 'ZSUB',     "for subscription
           c_rew       TYPE auart    VALUE 'ZREW',     "for return
           c_zor       TYPE auart    VALUE 'ZOR',      "for Normal Order
           c_ag        TYPE char2    VALUE 'AG',       "sold to party
           c_we        TYPE char2    VALUE 'WE',       "ship to party
           c_u         TYPE char1    VALUE 'U',        "update flag
           c_pipe      TYPE char1    VALUE '|',        " Tab of type Character
           c_i         TYPE char1    VALUE 'I',        "update flag
           c_i_s       TYPE char1    VALUE 'i',        "update flag    "ERPM-19878  ED2K918239
           c_e         TYPE char1    VALUE 'E',        "update flag
           c_s         TYPE char1    VALUE 'S',        "update flag
           c_eq        TYPE char2    VALUE 'EQ',       "update flag
           c_sp        TYPE parvw    VALUE  'SP',         "Forwarding agent
           c_00010     TYPE posnr    VALUE '00010',    " Item number of the SD document
           c_devid     TYPE zdevid   VALUE 'E225',
           c_e101      TYPE zdevid   VALUE 'E101',
           c_path      TYPE rvari_vnam   VALUE 'LOGICAL_PATH',
           c_vbtyp     TYPE rvari_vnam  VALUE 'VBTYP',
           c_msgcount  TYPE rvari_vnam  VALUE 'MSG_COUNT',
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
           c_new_logic TYPE rvari_vnam  VALUE 'NEW_LOGIC',
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
           c_auart     TYPE rvari_vnam  VALUE 'AUART',
           c_auart_cnt TYPE rvari_vnam  VALUE 'AUART_CNT',
           c_dld       TYPE char8    VALUE 'Download',
           c_fc01      TYPE sy-ucomm VALUE 'FC01',
           c_custo     TYPE char10   VALUE 'CUSTOMER',
           c_parvw     TYPE char10   VALUE 'PARVW',
           c_kunnr     TYPE char10   VALUE 'KUNNR',
           c_vkorg     TYPE char10   VALUE 'VKORG',
           c_vtweg     TYPE char10   VALUE 'VTWEG',
           c_spart     TYPE char10   VALUE 'SPART',
           c_guebg     TYPE char10   VALUE 'GUEBG',
           c_gueen     TYPE char10   VALUE 'GUEEN',
           c_vbegdat   TYPE char10   VALUE 'VBEGDAT',
           c_venddat   TYPE char10   VALUE 'VENDDAT',
           c_posnr     TYPE char10   VALUE 'POSNR',
           c_matnr     TYPE char10   VALUE 'MATNR',
           c_plant     TYPE char10   VALUE 'PLANT',
           c_vbeln     TYPE char10   VALUE 'VBELN',
           c_pstyv     TYPE char10   VALUE 'PSTYV',
           c_zmeng     TYPE char10   VALUE 'ZMENG',
           c_lifsk     TYPE char10   VALUE 'LIFSK',
           c_faksk     TYPE char10   VALUE 'FAKSK',
           c_abgru     TYPE char10   VALUE 'ABGRU',
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
           c_text_head TYPE char10   VALUE 'HEAD_ITEM',
           c_head_item TYPE char10   VALUE 'HEAD_ITEM',

           c_butype    TYPE char10   VALUE 'BU_TYPE',
           c_butitle   TYPE char10   VALUE 'BU_TITLE',
           c_fname     TYPE char10   VALUE 'NAME_F',
           c_lname     TYPE char10   VALUE 'NAME_L',
           c_suffix    TYPE char10   VALUE 'SUFFIX',
           c_suppl2    TYPE char10   VALUE 'STR_SUPPL2',
           c_suppl1    TYPE char10   VALUE 'STR_SUPPL1',
           c_suppl3    TYPE char10   VALUE 'STR_SUPPL3',
           c_street    TYPE char10   VALUE 'STREET',
           c_loc       TYPE char10   VALUE 'LOCATION',
           c_city1     TYPE char10   VALUE 'CITY1',
           c_regio     TYPE char10   VALUE 'REGION',
           c_country   TYPE char10   VALUE 'COUNTRY',
           c_pcode     TYPE char10   VALUE 'POST_CODE1',
           c_email     TYPE char10   VALUE 'SMTP_ADDR',
           c_bpemail   TYPE char10   VALUE 'BP_EMAIL',
           c_tel       TYPE char10   VALUE 'TEL_NUMBER',
           c_rcatg     TYPE char10   VALUE 'RELTYP',
           c_rstart    TYPE char10   VALUE 'DATFROM',
           c_rend      TYPE char10   VALUE 'DATETO',
           c_soc_bp    TYPE char10   VALUE 'PARTNER2',
           c_bpatt6    TYPE char10   VALUE 'KATR6',
           c_kdgrp     TYPE char10   VALUE 'KDGRP',
           c_invinst   TYPE char10   VALUE 'INVINST',
           c_hi_text   TYPE char10   VALUE 'STXH',
           c_ztax      TYPE char4    VALUE 'ZTAX',
           c_tax       TYPE char4    VALUE 'TAX',
           c_kdkg2     TYPE char10   VALUE 'KDKG2',
           c_batchjob  TYPE char10   VALUE 'BATCHJOB',
           c_kdkg42    TYPE char10   VALUE 'KDKG4_2',
           c_vaktsch   TYPE char10   VALUE 'VAKTSCH',    " Action
           c_vasda     TYPE char10   VALUE 'VASDA',      " Date for Action
           c_perio     TYPE char10   VALUE 'PERIO',      " Rule for Origin of Next Billing/Invoice Date
           c_autte     TYPE char10   VALUE 'AUTTE',      " In Advance
           c_peraf     TYPE char10   VALUE 'PERAF',      " Rule for Determination of a Deviating Billing/Invoice Date
           c_zsbp      TYPE auart    VALUE 'ZSBP',        "for subscription
           c_va42      TYPE sy-tcode VALUE 'VA42',        "for subscription
           c_uns       TYPE char1    VALUE '_'.
DATA: v_posnr     TYPE posnr,
      v_fplnr     TYPE fplnr,
      it_fpla     TYPE TABLE OF fplavb,
      it_fpla_old TYPE TABLE OF fplavb,
      it_fplt     TYPE TABLE OF fpltvb,
      it_fplt_old TYPE TABLE OF fpltvb,
      wa_output   TYPE ty_output_x,
      v_error     TYPE char1,
      v_msgcnt    TYPE i,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
      v_new_logic TYPE char1.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267


DATA:v_augru TYPE augru.

DATA:obj_ixml          TYPE REF TO   if_ixml,
     obj_streamfactory TYPE REF TO   if_ixml_stream_factory,
     obj_ostream       TYPE REF TO   if_ixml_ostream,
     obj_renderer      TYPE REF TO   if_ixml_renderer,
     obj_document      TYPE REF TO   if_ixml_document,
     obj_element_root  TYPE REF TO   if_ixml_element,
     obj_ns_attribute  TYPE REF TO   if_ixml_attribute,
     obj_element_pro   TYPE REF TO   if_ixml_element,
     obj_worksheet     TYPE REF TO   if_ixml_element,
     obj_table         TYPE REF TO   if_ixml_element,
     obj_column        TYPE REF TO   if_ixml_element,
     obj_row           TYPE REF TO   if_ixml_element,
     obj_cell          TYPE REF TO   if_ixml_element,
     obj_data          TYPE REF TO   if_ixml_element,
     v_value           TYPE          string,
     obj_styles        TYPE REF TO   if_ixml_element,
     obj_style         TYPE REF TO   if_ixml_element,
     obj_style1        TYPE REF TO   if_ixml_element,
     obj_style2        TYPE REF TO   if_ixml_element,
     obj_format        TYPE REF TO   if_ixml_element,
     obj_border        TYPE REF TO   if_ixml_element,
     i_xml_table       TYPE TABLE OF ty_xml_line,
     st_xml            TYPE          ty_xml_line,
     gt_fcat           TYPE          lvc_t_fcat,
     gr_credat         TYPE          fkk_rt_chdate,
     c_att             TYPE e070a-attribute VALUE 'SAP_CTS_PROJECT'.
