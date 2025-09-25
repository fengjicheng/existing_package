*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EDI_DOC_ENTITLE_SAP_TOP
*&---------------------------------------------------------------------*
***Types Declaration
TYPES: BEGIN OF ty_final,
         smtp_addr  TYPE ad_smtpadr,
         identcode  TYPE char4,
         vbeln      TYPE vbeln,
* Date needs to be in the same format as YYYYMMDD but when we are passing
* externally its converting into MM/DD/YYYY.
         audat      TYPE char08,
         auart      TYPE auart,
         zzsubtyp   TYPE zsubtyp,
***BOC BY SAYANDAS on 17th May 2017 for ERP-2130
*         name1      TYPE ad_name1,
         name1      TYPE char100,
***EOC BY SAYANDAS on 17th May 2017 for ERP-2130
         name3      TYPE ad_name1,
         name2      TYPE ad_name2,
         street     TYPE ad_street,
         city1      TYPE ad_city1,
         landx50    TYPE landx50,
         reg_post_code TYPE char13,
       END OF ty_final.

CONSTANTS: c_lead_zero     TYPE char1 VALUE '0'.

*** Data Declaration
DATA: gv_auart TYPE auart,
      gv_idct  TYPE char4.

*** Internal table declaration
DATA:     i_final     TYPE STANDARD TABLE OF ty_final,
          i_final_csv TYPE truxs_t_text_data.
