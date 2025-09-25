*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_QUOTAT_RNWL_F065_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME    : ZQTCR_WLS_QUOTATION_RNWL_F065
* DESCRIPTION     : This driver program implemented for WLS
*                   Quotation Renewal forms F065
* DEVELOPER       : VDPATABALL
* CREATION DATE   : 06/29/2020
* OBJECT ID       : ERPM-20839/F065
* TRANSPORT NUMBER(S):ED2K918582
*----------------------------------------------------------------------*

TABLES: tnapr,    " Processing programs for output
        nast,     " Message Status
        toa_dara. " SAP ArchiveLink structure of a DARA line

*- Fimal table
TYPES: BEGIN OF ty_vbpa,
         vbeln TYPE vbpa-vbeln,
         parvw TYPE vbpa-parvw,
         kunnr TYPE vbpa-kunnr,
         pernr TYPE vbpa-pernr,
         adrnr TYPE vbpa-adrnr,
       END OF ty_vbpa,

       BEGIN OF ty_const,
         devid    TYPE zdevid,
         param1   TYPE rvari_vnam,
         param2   TYPE rvari_vnam,
         srno     TYPE tvarv_numb,
         sign     TYPE tvarv_sign,
         opti     TYPE tvarv_opti,
         low      TYPE salv_de_selopt_low,
         high     TYPE salv_de_selopt_high,
         activate TYPE zconstactive,
       END OF ty_const,
       BEGIN OF ty_send_email,
         send_email TYPE ad_smtpadr, " E-Mail Address
       END OF ty_send_email,
       tt_send_email TYPE STANDARD TABLE OF ty_send_email.

DATA:i_const              TYPE STANDARD TABLE OF ty_const,
     i_hdr_itm            TYPE zstqtc_wls_quotat_renwal_f065 ##NEEDED, " Structure for F065 Header and Item Data
     i_print_data_to_read TYPE lbbil_print_data_to_read ##NEEDED,       " Select. of Tables to be Compl. for Printing RD00;SmartForms
     st_formoutput        TYPE fpformoutput ##NEEDED,                   " Form Output (PDF, PDL)
     i_content_hex        TYPE solix_tab ##NEEDED,                      " Content table
     v_formname           TYPE fpname ##NEEDED,                         " Formname.
     v_ent_retco          TYPE sy-subrc ##NEEDED,                       " ABAP System Field: Return Code of ABAP Statements
     v_ent_screen         TYPE c ##NEEDED,                              " Screen of type Character
     v_send_email         TYPE ad_smtpadr ##NEEDED,                     " E-Mail Address
     v_retcode            TYPE sy-subrc,                                " Return code
     v_er_name            TYPE char50 ##NEEDED,                         " E-Mail Address
     v_persn_adrnr        TYPE knvk-prsnr ##NEEDED,                     " E-Mail Address
     v_logo               TYPE salv_de_selopt_low VALUE 'ZJWILEY_LOGO', " Logo
     v_bmp                TYPE xstring ##NEEDED,                        " Bitmap
     st_vbak              TYPE vbak,
     st_vbpa              TYPE ty_vbpa,
     i_send_email         TYPE TABLE OF ty_send_email,
*---Begin of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
     i_hdr_itm_f067       TYPE zstqtc_lh_opm_hdr_itm_f046.
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214

CONSTANTS: c_0          TYPE char4      VALUE '0.00',                          " Sales Office
           c_re         TYPE parvw      VALUE 'RE',                            " Partner Function
           c_1          TYPE na_nacha   VALUE '1',                             " Print Function
           c_5          TYPE na_nacha   VALUE '5',                             " Email Function
           c_zero       TYPE char1      VALUE '0',                             " Email Function
           c_pdf        TYPE toadv-doc_type VALUE 'PDF',                       " for PDF
           c_tax        TYPE char3      VALUE 'Tax',                           " Tax text
           c_vbbk       TYPE tdobject   VALUE 'VBBK',                          " Text object
           c_0007       TYPE tdid       VALUE '0007',                          " Text id
           c_eq         TYPE char1      VALUE '=',                             " Equal
           c_at         TYPE char1      VALUE '@',                             " At the rate
           c_pert       TYPE char1      VALUE '%',                             " At the rate
           c_we         TYPE parvw      VALUE 'WE',                            " Partner Function
           c_er         TYPE char02     VALUE 'ZM',                            " Employee responsible
           c_z1         TYPE knvk-pafkt VALUE 'Z1',                            " Contact person function
           c_e          TYPE char1      VALUE 'E',                             " Error Message
           c_zqtc_r2    TYPE syst-msgid VALUE 'ZQTC_R2',                       " Message ID
           c_msg_no     TYPE syst-msgno VALUE '000',                           " Message Number
           c_x          TYPE char1      VALUE 'X',                             " for x
           c_w          TYPE char1      VALUE 'W',                             " for Web
           c_under      TYPE char1      VALUE '-',                             " Underscore
           c_prod       TYPE char4      VALUE 'EP1',                           " For Production system
           c_cp         TYPE parvw      VALUE 'AP',                            " Partner Function Contact Person
           c_wt_tax     TYPE party      VALUE 'WT_TAX',                        " Wat tax id
           c_zwpr       TYPE kscha      VALUE 'ZWPR',                          " Pricing Condition
           c_zitr       TYPE kscha      VALUE 'ZITR',                          " Tax Condition
           c_zfrt       TYPE pstyv      VALUE 'ZFRT',                          "Sales document item category
           c_zckt       TYPE pstyv      VALUE 'ZCKT',                          "Sales document item category
           c_higherline TYPE uepos      VALUE '000000',                          "Sales document item category
           c_devid_f065 TYPE zdevid     VALUE 'F065',
           c_bank       TYPE zcaconstant-param1 VALUE 'BANK',
           c_portal     TYPE zcaconstant-param1 VALUE 'PORTAL',
           c_remit      TYPE zcaconstant-param1 VALUE 'REMIT',
*---Begin of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
           c_devid_f067 TYPE zdevid     VALUE 'F067',
           c_zwqt       TYPE zdevid     VALUE 'ZWQT',
           c_zqda       TYPE zdevid     VALUE 'ZQDA',
           c_40         TYPE spart      VALUE '40',                              " Division for DAT
           c_tax_des    TYPE zcaconstant-param1 VALUE 'TAX_DES',
           c_cust_id    TYPE zcaconstant-param1 VALUE 'CUST_ID'.
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
