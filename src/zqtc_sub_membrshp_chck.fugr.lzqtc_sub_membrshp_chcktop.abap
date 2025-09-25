FUNCTION-POOL zqtc_sub_membrshp_chck. "MESSAGE-ID ..

* INCLUDE LZQTC_SUB_MEMBRSHP_CHCKD...        " Local class definition
*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_SUB_MEMBRSHP_CHCK
* PROGRAM DESCRIPTION: Subscription membership check Report
* DEVELOPER:Srabanti Bose (SRBOSE)/ Nallapaneni Mounika (NMOUNIKA)
* CREATION DATE:2017-01-19
* OBJECT ID:I0317
* TRANSPORT NUMBER(S):ED2K904076
*-------------------------------------------------------------------*

* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           LZQTC_SUB_MEMBRSHP_CHCKTOP
*&---------------------------------------------------------------------*

*****Type Declaration
TYPES: BEGIN OF ty_society,
         society TYPE zzsociety_acrnym,  " Society Acronym
       END OF ty_society,

       BEGIN OF ty_constant,
         devid    TYPE zdevid,              " Development ID
         param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno     TYPE tvarv_numb,          " ABAP: Current selection number
         sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         activate TYPE zconstactive,      "Activation indicator for constant
       END OF ty_constant,

       BEGIN OF ty_email,
         email TYPE ad_smtpadr,
       END OF ty_email,
*BOC by GKAMMILI on 09/10/2020 for ERPM 13923
       BEGIN OF ty_quote,
         vbeln TYPE vbeln,
       END OF ty_quote,
       BEGIN OF ty_postal,
         pcode TYPE ad_pstcd2,
       END OF ty_postal,
       BEGIN OF ty_country,
         country TYPE land1,
       END OF ty_country,
*EOC by GKAMMILI  on 09/10/2020 for ERPM 13023
       BEGIN OF ty_vbeln,
         vbeln TYPE vbeln,
       END OF ty_vbeln,
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
       BEGIN OF ty_ihrez,
         ihrez TYPE ihrez,
       END OF ty_ihrez,
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
       BEGIN OF ty_payment,
         payment_rate TYPE zqtc_paymrate,
       END OF ty_payment,

       BEGIN OF ty_subtyp,
         subtyp TYPE zqtc_subsc_cd,
       END OF ty_subtyp,

       BEGIN OF ty_jkseinterrupt,  "Added by MODUTTA for CR#410
         vbeln      TYPE  vbeln,
         posnr      TYPE  posnr,
         valid_from TYPE  jinterruptfrom,
         valid_to   TYPE  jinterruptto,
         reason     TYPE  jinterruptreason02,
       END OF ty_jkseinterrupt,
*&---------------------------------------------------------------------*
*&    Table Type Declaration
*&---------------------------------------------------------------------*
       tt_society       TYPE STANDARD TABLE OF ty_society INITIAL SIZE 0,
       tt_subtyp        TYPE STANDARD TABLE OF ty_subtyp INITIAL SIZE 0,
       tt_constant      TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0
                       WITH NON-UNIQUE SORTED KEY variable COMPONENTS param1,
       tt_email         TYPE STANDARD TABLE OF ty_email INITIAL SIZE 0,
*BOC by GKAMMILI on 09/10/2020 for ERPM 13923
       tt_quote         TYPE STANDARD TABLE OF ty_quote,
       tt_postal        TYPE STANDARD TABLE OF ty_postal,
       tt_country       TYPE STANDARD TABLE OF ty_country,
*BOC by GKAMMILI on 09/10/2020 for ERPM 13923
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*       tt_vbeln         TYPE STANDARD TABLE OF ty_vbeln INITIAL SIZE 0,
       tt_ihrez         TYPE STANDARD TABLE OF ty_ihrez INITIAL SIZE 0,
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
       tt_payment       TYPE STANDARD TABLE OF ty_payment INITIAL SIZE 0,
       tt_jkseinterrupt TYPE STANDARD TABLE OF ty_jkseinterrupt INITIAL SIZE 0. "Added by MODUTTA for CR#410

*&---------------------------------------------------------------------*
*&    Constants Declaration
*&---------------------------------------------------------------------*
CONSTANTS: c_frstdayyr     TYPE char4 VALUE '0101',
           c_lstdayyr      TYPE char4 VALUE '1231',
           c_media_default TYPE zqtc_media_type VALUE 'D', "Added by MODUTTA for CR#403
           c_media_type_m  TYPE zqtc_media_type VALUE 'M', "Added by GKAMMILI for ERPM-13923
           c_media_type_c  TYPE zqtc_media_type VALUE 'C'. "Added by GKAMMILI for ERPM-13923
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
CONSTANTS: c_object TYPE balobj_d    VALUE 'ZQTC',
           c_subobj TYPE balsubobj   VALUE 'ZDF_SUBMEMBRSHP',
           c_expiry TYPE rvari_vnam  VALUE 'EXPIRY_DATE',
           c_appl   TYPE expiry_date VALUE 'APPL_LOG'.
DATA : gv_log_handle TYPE balloghndl, " Application Log: Log Handle
       gv_days       TYPE i.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038

DATA:gv_sccode             TYPE zzsociety_acrnym.
