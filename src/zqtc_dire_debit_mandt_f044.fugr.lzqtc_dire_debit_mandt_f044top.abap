FUNCTION-POOL zqtc_dire_debit_mandt_f044. "MESSAGE-ID ..

* INCLUDE LZQTC_DIRE_DEBIT_MANDT_F044D...    " Local class definition

TYPES: BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum, " Address number
         date_from  TYPE ad_date_fr, " Valid-from date - in current Release only 00010101 possible
         nation     TYPE ad_nation,  " Version ID for International Addresses
         title      TYPE ad_title,   " Form-of-Address Key
         name1      TYPE ad_name1,   " Name 1
         name2      TYPE ad_name2,   " Name 2
         name3      TYPE ad_name3,   " Name 3
         name4      TYPE ad_name4,   " Name 4
         city1      TYPE ad_city1,   " City
         post_code1 TYPE ad_pstcd1,  " City postal code
         street     TYPE ad_street,  " Street
*        Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
         country    TYPE land1, " Country Key
*        End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
       END OF ty_adrc,

*      Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
       BEGIN OF ty_dd_mndt,
         dd_process TYPE zdd_process,  " Direct Debit Process
         sform      TYPE fpwbformname, " PDF-Based Forms: Form Name
       END OF ty_dd_mndt.
*      End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385

TYPES: tt_vkorg    TYPE STANDARD TABLE OF range_vkorg. " Range table for VKORG

DATA: st_adrc          TYPE ty_adrc,
*     Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
      st_dd_mndt       TYPE ty_dd_mndt,
*     End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
      st_formoutput    TYPE fpformoutput,              " Form Output (PDF, PDL)
      st_standard_text TYPE zstqtc_standard_text_f044, " Structure for Standard Text
      st_odnum         TYPE zstqtc_odnum_f044,         " Structure for Originators Indentification Number
      st_ihrez         TYPE zstqtc_ihrez_f044,         " Structure for Your Reference
      st_accnum        TYPE zstqtc_acc_num_f044,       " Structure for Account Number
      st_srtcod        TYPE zstqtc_sort_code_f044,     " Structure for Sort Code
      st_address       TYPE zstqtc_adrc_f044.          " Structure for ADRC

DATA:               v_drct_dbt_logo     TYPE xstring,
                    v_direct_debit_logo TYPE xstring,
                    v_xstring           TYPE xstring,
                    v_account_text      TYPE thead-tdname, " Name
                    v_srtcode_text      TYPE thead-tdname, " Name
                    v_bnkname_text      TYPE thead-tdname, " Name
                    v_remitto_text      TYPE thead-tdname, " SAPscript: Text Header:Name
                    v_pstcode_text      TYPE thead-tdname, " Name
                    v_sftcode_text      TYPE thead-tdname, " Name
                    v_langu             TYPE spras,        " Language Key
                    v_kunnr             TYPE kunnr,        " Customer Number
                    v_vkorg             TYPE vkorg,        " Sales Organization
                    v_waerk             TYPE waerk,        " SD Document Currency
                    v_ref_text          TYPE char1,        " Ref Text
                    v_scenario          TYPE char3,        " Scenario of type CHAR3
                    v_reference_text    TYPE char50,       " Reference Text "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
                    v_crd_no_text       TYPE char100,      " Creditor Identification number "ADD:ERPm-24393:SGUDA:10/06/2020
                    v_crd_no            TYPE char100.      " Creditor Identification number "ADD:ERPm-24393:SGUDA:10/06/2020

CONSTANTS: c_st     TYPE thead-tdid VALUE 'ST',       " Text ID
           c_object TYPE thead-tdobject VALUE 'TEXT', " Texts: Application Object
*          Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
           c_dd_uk  TYPE zdd_process    VALUE '1', " Direct Debit - UK
           c_dd_vch TYPE zdd_process    VALUE '2'. " Direct Debit - VCH
*          End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
