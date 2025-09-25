*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_LOCKBOX_TOP
* PROGRAM DESCRIPTION: Automated Lockbox Renewals
* DEVELOPER: Shivangi Priya
* CREATION DATE: 11/14/2016
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K903276
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCE_AUTO_LOCKBOX_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_bsid1,
         bukrs TYPE bukrs,    "Company Code
         kunnr TYPE kunnr,    "Customer Number
         zuonr TYPE dzuonr,   " Assignment Number             " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         belnr TYPE belnr_d,  " Accounting Document Number    " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         budat TYPE budat,    " Posting Date in the Document  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         waers TYPE waers,    "Currency Key
         xblnr TYPE xblnr1,   "Reference Document Number
         blart TYPE blart,    "Document Type
         bschl TYPE bschl,    " Posting Key    " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         shkzg TYPE shkzg,    "Debit/Credit Indicator
         wrbtr TYPE wrbtr,    "Amount in Document Currency
         xref1 TYPE xref1,    " Business Partner Reference Key " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
       END OF ty_bsid1,

       tt_bsid1 TYPE TABLE OF ty_bsid1,

       BEGIN OF ty_vbap_final,
         vbeln TYPE vbeln,    " Sales and Distribution Document Number
         kzwi6 TYPE kzwi6,    " Subtotal 6 from pricing procedure for condition
       END OF ty_vbap_final,
       tt_vbap_final TYPE TABLE OF ty_vbap_final,

       BEGIN OF ty_bsid,
         xref1   TYPE char10, " Business Partner Reference Key " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         xblnr   TYPE xblnr,  "Reference Document Number
         bukrs   TYPE bukrs,  "Company Code
         kunnr   TYPE kunnr,  "Customer Number
         budat   TYPE budat,  " Posting Date in the Document  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         augdt   TYPE augdt,  "Clearing Date
         waers   TYPE waers,  "Currency Key
         blart   TYPE blart,  "Document Type
         bschl   TYPE bschl,  " Posting Key    " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         shkzg   TYPE shkzg,  "Debit/Credit Indicator
         wrbtr   TYPE wrbtr,  "Amount in Document Currency
*        xref1   TYPE char10,         " Business Partner Reference Key " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         belnr   TYPE belnr_d,        " Accounting Document Number    " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         zuonr   TYPE dzuonr,         " Assignment Number             " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
         errcode TYPE zqtc_errorcode, " Error Code
         flag    TYPE flag,           "Flag
       END OF ty_bsid,

       tt_bsid TYPE TABLE OF ty_bsid,

* Begin of change: PBOSE: 02-02-2017:ED2K903276
* Type Declaration of Constant table
       BEGIN OF ty_constant,
         devid    TYPE zdevid,              " Development ID
         param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         activate TYPE zconstactive,        " Activation indicator for constant
       END OF ty_constant,
       tt_constant TYPE TABLE OF ty_constant,
* End of change: PBOSE: 02-02-2017: ED2K903276
*      Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
       BEGIN OF ty_kna1,
         kunnr TYPE kunnr,    " Customer Number
         name1 TYPE name1_gp, " Name 1
       END OF ty_kna1,
       tt_kna1 TYPE TABLE OF ty_kna1,
*      End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

       BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va, "Sales Document
         vbtyp TYPE vbtyp,    "SD document category
         auart TYPE auart,    "Sales Document Type
         netwr TYPE netwr_ak, "Net Value
         waerk TYPE waerk,    "SD Document Currency
         vkorg TYPE vkorg,    "Sales Organization
         vtweg TYPE vkorg,    "Distribution Channel
         spart TYPE spart,    "Division
         kunnr TYPE kunag,    "Sold-to party
         vgbel TYPE vgbel,    "Document number
       END OF ty_vbak,
       tt_vbak TYPE TABLE OF ty_vbak,

*      Begin of Change: PBOSE: 4-Jan-2016:
       BEGIN OF ty_vbap,
         vbeln TYPE vbeln, " Sales and Distribution Document Number
         posnr TYPE posnr, " Item number of the SD document
         kzwi6 TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
       END OF ty_vbap,
       tt_vbap TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
*      End of Change: PBOSE: 4-Jan-2016:

       BEGIN OF ty_vbfa,
         vbelv TYPE vbeln_von,   "Preceding sales
         vbeln TYPE vbeln_nach,  "Subsequent sales
       END OF ty_vbfa,

       tt_vbfa TYPE SORTED TABLE OF ty_vbfa WITH NON-UNIQUE KEY vbelv,

       BEGIN OF ty_final,
         zzxblnr  TYPE xblnr1,   " Reference Document Number
         zzvbeln  TYPE vbeln_va, " Sales Document
         zzwrbtr  TYPE wrbtr,    " Amount in Document Currency
         zzvgbel  TYPE vgbel,    " Document number of the reference document
         zznetwr  TYPE netwr_ak, " Net Value of the Sales Order in Document Currency
         zzwaers  TYPE waers,    " Currency Key
         zzkunnr  TYPE kunnr,    " Customer Number
         zzblart  TYPE blart,    " Document Type
         zzvbtyp  TYPE vbtyp,    " SD document category
         zzwaerk  TYPE waerk,    " SD Document Currency
         zzbukrs  TYPE bukrs,    " Company Code
*        Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
         zzxref1  TYPE xref1,    " Business Partner Reference Key
         zzbelnr  TYPE belnr_d,  " Assignment of Item Numbers: Material Doc. - Purchasing Doc.
         zzzuonr  TYPE dzuonr,   " Assignment Number
         zzname1  TYPE name1_gp, " Name 1
         zzreason TYPE char100,  " Zzreason of type CHAR100
*        End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
       END OF ty_final,
       tt_final TYPE TABLE OF ty_final,

       BEGIN OF ty_datum,
         sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE sydatum,    " System Date
         high   TYPE sydatum,    " System Date
       END OF ty_datum,
       tt_datum   TYPE STANDARD TABLE OF ty_datum     INITIAL SIZE 0,

*       tt_custtab TYPE TABLE OF zqtclockbox_upd, " Lockbox Renewal
       tt_custtab TYPE SORTED TABLE OF zqtclockbox_upd WITH NON-UNIQUE KEY xblnr belnr reason_code, " Lockbox Renewal

       BEGIN OF ty_zcaint,
         mandt  TYPE mandt,                                                                         " Client
         devid  TYPE zdevid,                                                                        " Development ID
         param1	TYPE rvari_vnam,                                                                    " Name of Variant Variable
         param2	TYPE rvari_vnam,                                                                    " Name of Variant Variable
         lrdat  TYPE zlrdat,                                                                        " Last run date
         lrtime	TYPE zlrtime,                                                                       " Last run time
       END OF ty_zcaint,

       BEGIN OF ty_uzeit,
         sign   TYPE tvarv_sign,                                                                    " ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti,                                                                    " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE syuzeit,                                                                       " System Time
         high   TYPE syuzeit,                                                                       " System Time
       END OF ty_uzeit       ,
       tt_uzeit TYPE STANDARD TABLE OF ty_uzeit     INITIAL SIZE 0.

****Data Declarartion***
DATA: i_bsid         TYPE tt_bsid,     " Int table for BSID
      i_vbak         TYPE tt_vbak,     " Int Table for VBAK
      i_constant     TYPE tt_constant, " Int table for constant " (++) PBOSE: 02-02-2017:ED2K903276
      i_vbfa         TYPE tt_vbfa,     " Int Table for VBFA
      i_vbap         TYPE tt_vbap,     " Internal table for VBAP    " (++) PBOSE: 4-Jan-2016
      i_custtab      TYPE tt_custtab,  " Int Table for CUSTOM TABLE
      i_final        TYPE tt_final,    " Int Table for FINAL
      i_date_range   TYPE tt_datum,    " Int Table for DATE
      i_uzeit        TYPE tt_uzeit,    " Int Table for TIME
      i_vbap_final   TYPE tt_vbap_final,
      i_kna1         TYPE tt_kna1,     " Int Table for KNA1 " (++)PBOSE: 15-05-2017: CR#384: ED2K905720
*** ALV Data ***
      i_fieldcat     TYPE slis_t_fieldcat_alv, " Field Catalog Tabe
      st_layout      TYPE slis_layout_alv,     " Field Catalog Structure
      st_vbap        TYPE ty_vbap,
*** Variable ***
      v_budat        TYPE budat, "Global Var
*     Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
      v_flag_und_tol TYPE char1,    " Flag_und_tol of type CHAR1
      v_flag_und_amt TYPE char1,    " Flag_und_amt of type CHAR1
      v_flag_ovr_tol TYPE char1,    " Flag_ovr_tol of type CHAR1
      v_flag_ovr_amt TYPE char1,    " Flag_ovr_amt of type CHAR1
*Begin of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
      v_flag_ord_rsn TYPE char1,    " Flag for populating order reason code
*End of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
      v_name         TYPE name1_gp, " Name 1
      v_bukrs        TYPE bukrs,    " Company Code
      v_blart        TYPE blart,    " Document Type
      v_bschl        TYPE bschl,    " Posting Key
      v_xref1        TYPE xref1,    " Business Partner Reference Key
*     End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
      v_count        TYPE int4,                                             " Natural Number
      i_custtab_upd  TYPE STANDARD TABLE OF zqtclockbox_upd INITIAL SIZE 0. " Lockbox update

***Constants ***
CONSTANTS: c_2 TYPE c VALUE '2', " 2 of type Character
           c_3 TYPE c VALUE '3', " 3 of type Character
           c_a TYPE c VALUE 'A', " A of type Character
           c_b TYPE c VALUE 'B', " B of type Character
           c_c TYPE c VALUE 'C', " C of type Character
           c_d TYPE c VALUE 'D', " D of type Character
           c_e TYPE c VALUE 'E', " E of type Character
           c_f TYPE c VALUE 'F'. " F of type Character
