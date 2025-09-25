*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCN_REMINDER_FORM_TOP
* PROGRAM DESCRIPTION:   Program to send advance proforma reminders
* DEVELOPER:             GKINTALI
* CREATION DATE:         25/10/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
* REFERENCE NO:  OTCM-51284/FMM-5645
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

TABLES: toa_dara.

* Types Declarations
TYPES: BEGIN OF ty_vbrk_sub,
         vbeln    TYPE vbeln,    " Billing Document
         fkart    TYPE fkart,    " Billing Type
         waerk    TYPE waerk,    " SD Document Currency
         vkorg    TYPE vkorg,    " Sales Organization
         fkdat    TYPE fkdat,    " Billing date for billing index and printout
         netwr    TYPE netwr,    " Net Value in Document Currency
         kunrg    TYPE kunrg,    " Payer
         bstnk_vf TYPE bstkd,    " Customer purchase order number
       END OF ty_vbrk_sub,
       tt_vbrk_sub TYPE STANDARD TABLE OF ty_vbrk_sub INITIAL SIZE 0,

       BEGIN OF ty_vbfa_sub,
         vbelv   TYPE vbeln_von,  " Preceding sales and distribution document
         posnv   TYPE posnr_von,  " Preceding item of an SD document
         vbeln   TYPE vbeln_nach, " Subsequent sales and distribution document
         posnn   TYPE posnr_nach, " Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,    " Document category of subsequent document
       END OF ty_vbfa_sub,
       tt_vbfa_sub TYPE STANDARD TABLE OF ty_vbfa_sub INITIAL SIZE 0,

       BEGIN OF ty_vbak_sub,
         vbeln TYPE vbeln_va,     " Sales Document
         auart TYPE auart,        " Sales Document Type
         netwr TYPE netwr_ak,     " Net Value of the Sales Order in Document Currency
         waerk TYPE waerk,        " SD Document Currency
         vkbur TYPE vkbur,        "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
       END OF ty_vbak_sub,
       tt_vbak_sub TYPE STANDARD TABLE OF ty_vbak_sub INITIAL SIZE 0,

       BEGIN OF ty_vbrk_fin,
         waerk    TYPE waerk,     " SD Document Currency
         vkorg    TYPE vkorg,     " Sales Organization
         kunrg    TYPE kunrg,     " Payer
         vbeln    TYPE vbeln,     " Billing Document
         fkdat    TYPE fkdat,     " Billing date for billing index and printout
         netwr    TYPE netwr,     " Net Value in Document Currency
         bstnk_vf TYPE bstkd,     " Customer purchase order number
       END OF ty_vbrk_fin,
       tt_vbrk_fin TYPE STANDARD TABLE OF ty_vbrk_fin INITIAL SIZE 0,

** Type for fields from ZCACONSTANT table
       BEGIN OF ty_const,
         devid    TYPE zdevid,              " Development ID
         param1   TYPE rvari_vnam,          " Parameter1
         param2   TYPE rvari_vnam,          " Parameter2
         srno     TYPE tvarv_numb,          " Serial Number
         sign     TYPE tvarv_sign,          " Sign
         opti     TYPE tvarv_opti,          " Option
         low      TYPE salv_de_selopt_low,  " Low
         high     TYPE salv_de_selopt_high, " High
         activate TYPE zconstactive,        " Active/Inactive Indicator
       END OF ty_const,
       tt_const TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,

       BEGIN OF ty_mailnot,
         vkorg TYPE vkorg,     " Sales Organization
         kunrg TYPE kunrg,     " Payer
         flag  TYPE flag,
       END OF ty_mailnot,
       tt_mailnot TYPE STANDARD TABLE OF ty_mailnot INITIAL SIZE 0,

       tt_remlog TYPE STANDARD TABLE OF zqtc_remlog_f045 INITIAL SIZE 0.

* Global constants
CONSTANTS: gc_sign_i   TYPE sign           VALUE 'I',       " I = Include
           gc_opti_eq  TYPE opti           VALUE 'EQ',      " EQ = Equals
           gc_opti_bt  TYPE opti           VALUE 'BT',      " BT = Between
           gc_days     TYPE t5a4a-dlydy    VALUE '00',      " Days
           gc_month    TYPE t5a4a-dlymo    VALUE '00',      " Month
           gc_year     TYPE t5a4a-dlyyr    VALUE '01',      " Year
           gc_signum   TYPE t5a4a-split    VALUE '-',       " Sign = + / - for increase or decrease
           gc_zf2      TYPE fkart          VALUE 'ZF2',     " Document Type
           gc_zf5      TYPE fkart          VALUE 'ZF5',     " Document Type
           gc_printer  TYPE fpmedium       VALUE 'PRINTER', " Output device
           gc_st       TYPE thead-tdid     VALUE 'ST',      " Text ID of text to be read
           gc_object   TYPE thead-tdobject VALUE 'TEXT',    " Object of text to be read
           gc_langu    TYPE thead-tdspras  VALUE 'E',       " Language of text to be read
           gc_raw      TYPE so_obj_tp      VALUE 'RAW',     " Code for document class
           gc_pdf      TYPE so_obj_tp      VALUE 'PDF',     " Code for document class
           gc_devid    TYPE zdevid         VALUE 'F045',    " Development ID
           gc_frm_name TYPE fpname         VALUE 'ZQTC_FRM_PROF_REMINDER_F045',  " Name of Form Object
           gc_inf      TYPE bapi_mtype VALUE 'I',       " Message type: S Success, E Error, W Warning, I Info, A Abort
           gc_err      TYPE bapi_mtype VALUE 'E',       " Message type: S Success, E Error, W Warning, I Info, A Abort
           gc_abt      TYPE bapi_mtype VALUE 'A',       " Message type: S Success, E Error, W Warning, I Info, A Abort
           gc_msgno    TYPE symsgno    VALUE '000',     " Message Number
           gc_msg_251  TYPE symsgno    VALUE '251',     " Message Number
           gc_suc      TYPE bapi_mtype VALUE 'S',       " Success
           gc_msg_cls  TYPE symsgid    VALUE 'ZQTC_R2', " Message_class 'ZQTC_R2' . " Message class = ZQTC_R2
           gc_bp       TYPE char3      VALUE 'BP',
           gc_zs       TYPE char3      VALUE 'ZS',
           gc_crep     TYPE char3      VALUE 'CREP'.

*Global variable declaration
DATA: v_vkorg      TYPE vkorg,          " Sales Org
      v_fkart      TYPE fkart,          " Billing Type
      v_fkdat      TYPE fkdat,          " Billing date for billing index and printout
      v_kunrg      TYPE kunrg,          " Payer
      v_vbeln      TYPE vbeln,          " Billing Document
      v_email      TYPE ad_smtpadr,     " E-Mail Addresses (Business Address Services)
      v_land1      TYPE land1,          " Country Key
      v_bukrs      TYPE bukrs,          " Company Code
      v_curr       TYPE waerk,          " Currency Key
      v_sname      TYPE sname_001s,     " Name of Accounting Clerk
      v_notif_dat  TYPE datum,          " Notification Date
      v_ph_no      TYPE tlfnr,          " Addresses: telephone no.
      v_email_addr TYPE intad,          " Internet address of partner company clerk
      v_email_id   TYPE ad_smtpadr,     " Email ID of BP
      v_crop_duns  TYPE thead-tdname,   " SAPscript: Text Header - Name
      v_body       TYPE thead-tdname,   " SAPscript: Text Header - Name
      v_remit_to   TYPE thead-tdname,   " SAPscript: Text Header - Name
      v_footer1    TYPE thead-tdname,   " SAPscript: Text Header - Name
      v_langu      TYPE spras,          " Language Key
      v_datum      TYPE char15,         " Char field for DD-MMM-YYYY date format
      v_date       TYPE char15,         " Date field - to be converted into MM/DD/YYYY format
      v_filepath   TYPE mdg_filename,   " Local file for upload/download
      v_retcode    TYPE syst_subrc.     " ABAP System Field: Return Code of ABAP Statements,

* Global Internal Tables Declaratons
DATA: gt_vbrk_sub    TYPE tt_vbrk_sub,
      gt_vbrk_zf2    TYPE tt_vbrk_sub,
      gt_vbfa_sub    TYPE tt_vbfa_sub,
      gt_vbfa_zf2    TYPE tt_vbfa_sub,
      gt_vbak_sub    TYPE tt_vbak_sub,
      gt_vbrk        TYPE tt_vbrk_fin,
      gt_vbrk_tmp    TYPE tt_vbrk_fin,
      gt_const       TYPE tt_const,      " Constants table.
      st_formoutput  TYPE fpformoutput,  " Form Output (PDF, PDL)
      st_content_hex TYPE solix_tab,     " GBT: SOLIX as Table Type
      gt_remlog      TYPE STANDARD TABLE OF zqtc_remlog_f045 INITIAL SIZE 0,
      gt_mailnot     TYPE tt_mailnot,
      gt_return      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0, " Return Parameter
      gt_receivers   TYPE bcsy_smtpa,
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code     TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office  TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency TYPE RANGE OF  salv_de_selopt_low.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
