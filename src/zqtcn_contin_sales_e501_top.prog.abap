*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONTIN_SALES_E501_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_CONTIN_SALES_E501_TOP                  *
* PROGRAM DESCRIPTION : Creating Child(Continuous)Sales Order Automatically
* DEVELOPER           : SRAMASUBRA (Sankarram R)                       *
* CREATION DATE       : 2022-04-07                                     *
* OBJECT ID           : E501/EAM-8355                                  *
* TRANSPORT NUMBER(S) : ED2K926637                                     *
*&---------------------------------------------------------------------*

TABLES:
  vbak,
  mara
  .

TYPES:
  BEGIN OF ty_zcaconstant,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF ty_zcaconstant,

  BEGIN OF ty_contrct_det,
    vbeln     TYPE vbeln,
    posnr     TYPE posnr,
    auart     TYPE auart,
    vkorg     TYPE vkorg,
    vtweg     TYPE vtweg,
    spart     TYPE spart,
    kunnr     TYPE kunnr,
    guebg     TYPE guebg,
    gueen     TYPE gueen,
    lifsk     TYPE lifsk,
    matnr     TYPE matnr,
    abgru     TYPE abgru,
    zmeng     TYPE dzmeng,
    kwmeng    TYPE kwmeng,
    identcode TYPE ismidentcode, "vmamilapa
  END OF ty_contrct_det,


  BEGIN OF ty_matrl_mast,
    matnr       TYPE  matnr,
    bismt       TYPE  bismt,
    mstae       TYPE  mstae,
    ismpubldate TYPE  ismpubldate,
  END OF ty_matrl_mast,

  BEGIN OF ty_matrl_code,
    matnr      TYPE  matnr,
    idcodetype TYPE  ismidcodetype,
    identcode  TYPE  ismidentcode,
    idcodearea TYPE  char18,
  END OF ty_matrl_code,

  BEGIN OF ty_partners,
    vbeln TYPE  vbeln,
    posnr TYPE  posnr,
    parvw TYPE  parvw,
    kunnr TYPE  kunnr,
  END OF ty_partners,

  BEGIN OF ty_output,
    ser_code   TYPE  matnr,
    contrct_no TYPE  vbeln,
    item_no    TYPE  posnr,
    customer   TYPE  kunnr,
    so_no      TYPE  vbeln,
    matrl_no   TYPE  matnr,
    isbn_mat   TYPE  bismt,
    qty        TYPE  kwmeng,
    status     TYPE  char10,
    remarks    TYPE  char255,
  END OF ty_output.


DATA:
  v_vkorg        TYPE vkorg,
  v_auart        TYPE auart,
  v_vtweg        TYPE vtweg,
  v_email        TYPE ad_smtpadr,
  v_isbn_cd_typ  TYPE ismidcodetype,
  v_pur_ord_typ  TYPE bsark,

  i_const_val    TYPE STANDARD TABLE OF ty_zcaconstant,
  i_contract     TYPE STANDARD TABLE OF ty_contrct_det,
  i_matrl_code   TYPE STANDARD TABLE OF ty_matrl_code,
  i_vbpa_patnrs  TYPE STANDARD TABLE OF ty_partners,
  i_matrl_mast   TYPE STANDARD TABLE OF ty_matrl_mast,
  i_message      TYPE STANDARD TABLE OF solisti1,  " Itab to hold message for email
  i_attach_total TYPE STANDARD TABLE OF solisti1 , " Itab to hold attachment for email
  i_packing_list TYPE STANDARD TABLE OF sopcklsti1, " Itab to hold packing list for email
  i_receivers    TYPE STANDARD TABLE OF somlreci1, " Itab to hold mail receipents
  i_attachment   TYPE STANDARD TABLE OF solisti1 , " Itab to hold attachmnt for email
  i_output       TYPE STANDARD TABLE OF ty_output
  .

CONSTANTS:
  c_sd_ord_typ TYPE  auart           VALUE 'ZACC',
  c_devid_e501 TYPE  zdevid          VALUE 'E501',
  c_shp_to     TYPE  parvw           VALUE 'WE',
  c_sld_to     TYPE  parvw           VALUE 'AG',
  c_tab        TYPE  c               VALUE cl_abap_char_utilities=>horizontal_tab,
  c_clrf       TYPE  c               VALUE cl_abap_char_utilities=>cr_lf,
  c_err        TYPE  char1           VALUE 'E',
  c_succ       TYPE  char1           VALUE 'S',
  c_idcodetype TYPE  rvari_vnam      VALUE 'IDCODETYPE'.
