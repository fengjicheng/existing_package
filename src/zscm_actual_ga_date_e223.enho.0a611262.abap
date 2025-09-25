"Name: \PR:RJKSDWORKLIST\IC:RJKSDWORKLIST_TOP1\SE:END\EI
ENHANCEMENT 0 ZSCM_ACTUAL_GA_DATE_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223) / ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Additional Fields in Media Issue Worklist
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 28-MAY-2020
* DESCRIPTION: Journal First Print Optimization
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 21-AUG-2020
* DESCRIPTION: DIGITAL/LITHO Report Changes
*-----------------------------------------------------------------------*

  types: BEGIN OF ty_enh_ctrl,
           wricef_id   TYPE zdevid,
           ser_num     TYPE zsno,
           var_key     TYPE zvar_key,
           active_flag TYPE zactive_flag,
         END OF ty_enh_ctrl,
* BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
         BEGIN OF ty_pir_info,
           matnr TYPE matnr,
           werks TYPE werks_d,
           bdzei TYPE bdzei,
           plnmg TYPE plnmg,
         END OF ty_pir_info,
         " Purchasing Source List
         BEGIN OF ty_eord,
           matnr TYPE matnr,    " Material Number
           werks TYPE werks_d,  " Plant
           zeord TYPE dzeord,   " Number of Source List Record
           lifnr  type lifnr,
           flifn type flifn,
           autet type autet,
         END OF ty_eord,
         " Purchasing Info Record
         BEGIN OF ty_eina,
           infnr TYPE infnr,    " Number of Purchasing Info Record
           matnr TYPE matnr,    " Material Number
           werks TYPE werks_d,  " Plant
           lifnr TYPE lifnr,  "Vendor
         END OF ty_eina,
         " Material Desc
         BEGIN OF ty_makt,
           matnr TYPE matnr,    " Material Number
           spras TYPE spras,    " Language
         END OF ty_makt,
        " Type Declaration of Constant table
         BEGIN OF ty_const,
           devid  TYPE zdevid,              " Development ID
           param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           srno   TYPE TVARV_NUMB,          " Serial Number
           sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
           opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
           low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
           high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         END OF ty_const.
* EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
* BOC: ERPM-837(R096)  KKRAVURI 21-AUG-2020  ED2K919143
   TYPES: BEGIN OF ty_cds,
           media_issue          TYPE matnr,
           pub_date             TYPE ismpubldate,
           media_product        TYPE ismrefmdprod,
           media_issue_identify TYPE loggr,
           journal_cd           TYPE ismidentcode,
           issue                TYPE ismnrimjahr,
           year1                TYPE ismjahrgang,
           plant                TYPE werks_d,
           main_labels          TYPE quan_15,
           back_labels          TYPE quan_15,
         END OF ty_cds,
         BEGIN OF ty_pyr_data,
           ismrefmdprod TYPE ismrefmdprod,
           matnr        TYPE matnr,
           issue_no     TYPE ismnrimjahr,
           issue_num    TYPE numc4,
           pyear        TYPE ismjahrgang,
           plant        TYPE werks_d,
         END OF ty_pyr_data,
         BEGIN OF ty_max_issue,
           media_issue   TYPE matnr,
           media_product TYPE ismrefmdprod,
           issue         TYPE ismnrimjahr,
           year1         TYPE ismjahrgang,
           plant         TYPE werks_d,
           main_labels   TYPE quan_15,
           back_labels   TYPE quan_15,
         END OF ty_max_issue,
         BEGIN OF ty_max_issue_f,
           media_issue   TYPE matnr,
           media_product TYPE ismrefmdprod,
           issue         TYPE numc4,
           year1         TYPE ismjahrgang,
           plant         TYPE werks_d,
           main_labels   TYPE quan_15,
           back_labels   TYPE quan_15,
         END OF ty_max_issue_f.
* EOC: ERPM-837(R096)  KKRAVURI 21-AUG-2020  ED2K919143

  data: t1 type c length 30,
*        tt_outtab TYPE REF TO data,
        i_outtab     TYPE TABLE OF RJKSDWORKLIST_ALV,
        ir_vkey      TYPE RANGE OF ZVAR_KEY,
        st_vkey      LIKE LINE OF ir_vkey,
        ir_devid     TYPE RANGE OF ZDEVID,
        st_devid     LIKE LINE OF ir_devid,
        i_enh_ctrl   TYPE STANDARD TABLE OF ty_enh_ctrl INITIAL SIZE 0,
        " BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
        i_pir_info   TYPE STANDARD TABLE OF ty_pir_info INITIAL SIZE 0,
        i_eord       TYPE STANDARD TABLE OF ty_eord INITIAL SIZE 0,
        i_eina       TYPE STANDARD TABLE OF ty_eina INITIAL SIZE 0,
        i_makt       TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
        i_constant   TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,
        v_agadt      TYPE JREAD_ISSUE_INCL_PHASES,
        v_aflag_e244 TYPE zactive_flag,
        " EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
        st_enh_ctrl  TYPE ty_enh_ctrl,
        v_aflag_e223 TYPE zactive_flag,
        v_aflag_r096 TYPE zactive_flag.
**       BOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021
*        v_aflag_r096_002 TYPE zactive_flag.
**       EOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021

  CONSTANTS:
     c_vkey_scrapping TYPE zvar_key VALUE 'SCRAPPING',
     c_vkey_mi_plan   TYPE zvar_key VALUE 'MI_PLANNING',
     c_e223           TYPE zdevid   VALUE 'E223', " Development ID-E223
     c_e244           TYPE zdevid   VALUE 'E244', " Development ID-E244  " ++ ERPM-10175
     c_r096           TYPE zdevid   VALUE 'R096', " Development ID-R096
     c_sno_001        TYPE zsno     VALUE '001',  " Serial Number
*    BOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021
     c_sno_002        TYPE zsno     VALUE '002',  " Serial Number
*    EOI OTCM-45466 ED2K924372 TDIMANTHA 08/24/2021
     " BOC: ERPM-10175  KKRAVURI 02-JUNE-2020  ED2K918271
     c_error     TYPE CHAR4  VALUE '@5C@',
     c_success   TYPE string VALUE '@5B@ Ready for MRP Run',
     c_dummy     TYPE string VALUE 'DUMMY',
     c_p1_title  TYPE string VALUE 'TITLE',
     c_p1_werks  TYPE string VALUE 'WERKS',
     c_printer     TYPE string VALUE 'PRINTER',
     c_distributor TYPE string VALUE 'DISTRIBUTOR',
     c_sl_txt    TYPE string VALUE 'Source List for',
     c_print_txt TYPE string VALUE 'Printer',
     c_dist_txt  TYPE string VALUE 'Distributor',
     c_ptitle_txt TYPE string VALUE 'Printer Title',
     c_dtitle_txt TYPE string VALUE 'Distributor Title',
     c_const_txt TYPE string VALUE 'Vendor in ZCACONSTANT',
     c_ir_txt    TYPE string VALUE 'Info Record',
     c_ven_txt   TYPE string VALUE 'Vendor: ',
     c_mat_txt   TYPE string VALUE 'Mat text in DE',
     c_and       TYPE char1  VALUE '&',
     c_comma     TYPE char1  VALUE ',',
     c_missing_txt TYPE TEXT10 VALUE 'missing',
     " EOC: ERPM-10175  KKRAVURI 02-JUNE-2020  ED2K918271
     " BOC: ERPM-837(R096)  KKRAVURI 21-AUG-2020  ED2K919143
     c_object     TYPE balobj_d    VALUE 'ZQTC',            " Application Log: Object Name (Application Code)
     c_subobj     TYPE balsubobj   VALUE 'ZSCM_LITHO',      " Application Log: Sub Object
     c_icon_text  TYPE text25 VALUE '@6X\QView Comments@',  " Icon Text
     c_zd         TYPE char2  VALUE 'ZD',                   " ZD --> Printing Type: Digital
     c_zl         TYPE char2  VALUE 'ZL'.                   " ZL --> Printing Type: Litho (Print)
     " BOC: ERPM-837(R096)  KKRAVURI 21-AUG-2020  ED2K919143

ENDENHANCEMENT.
