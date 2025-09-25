FUNCTION-POOL zscm_jksd13.                   " MESSAGE-ID ..

* INCLUDE LZSCM_JKSD13D...                   " Local class definition

TABLES: rjksd13, csks, marc, t001l,
        jksdmaterialstatus,   " ++ ERPM-837  LITHO Report
*BOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
        zscm_worklistlog.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719

TYPES: lty_rjksdworklist_alv TYPE STANDARD TABLE OF rjksdworklist_alv,
       BEGIN OF ty_constant,
         devid  TYPE zdevid,
         param1 TYPE rvari_vnam,
         srno   TYPE tvarv_numb,
         sign   TYPE tvarv_sign,
         opti   TYPE tvarv_opti,
         low    TYPE salv_de_selopt_low,
         high   TYPE salv_de_selopt_high,
       END OF ty_constant,
       " BOC: ERPM-837  KKRAVURI  2020-10-01  ED2K919750
       BEGIN OF ty_litho,
         ismrefmdprod          TYPE ismrefmdprod,  " Media Product
         medprod_maktx         TYPE maktx,         " Media Product Text
         matnr                 TYPE matnr,         " Media Issue
         medissue_maktx        TYPE maktx,         " Media Issue Text
         print_method          TYPE loggr,         " Print Method
         ismyearnr             TYPE ismjahrgang,   " Pub Year
         journal_code          TYPE ismidentcode,  " Acronym
         ismcopynr             TYPE ismheftnummer, " Volume
         ismnrinyear           TYPE ismnrimjahr,   " Issue No
         po_num                TYPE ebeln,         " Printer PO#
         po_create_dt          TYPE erdat,         " Printer PO Date
         print_vendor          TYPE elifn,         " Printer
         dist_vendor           TYPE elifn,         " Distributor
         delv_plant            TYPE dwerk_ext,     " Deliv. Plant
         issue_type            TYPE prat1,         " Issue Type
         sub_actual_py         TYPE numc13,        " Subs (Actual)
         subs_plan             TYPE numc13,        " Subs Plan
         new_subs              TYPE numc13,        " New Subs
         bl_pyear              TYPE numc13,        " BL (PY)
         bl_pcurr_yr           TYPE numc13,        " BL (CY)  char13
         ml_pyear              TYPE numc13,        " ML (PY)
         ml_bl_py              TYPE numc13,        " ML + BL(PY)
         ml_cyear              TYPE numc13,        " ML (CY)
         ml_bl_cy              TYPE numc13,        " ML + BL(CY)
         bl_buffer             TYPE numc13,        " BL Buffer
         subs_to_print         TYPE numc13,        " Subs to Print
         om_plan               TYPE numc13,        " OM Plan
         om_actual             TYPE numc13,        " OM Actual
         ob_plan               TYPE numc13,        " OB Plan
         ob_actual             TYPE numc13,        " OB Actual
         om_to_print           TYPE numc13,        " OM to Print
         sub_total             TYPE numc13,        " Subs total(Subs + OM)
         c_and_e               TYPE numc13,        " C & E
         author_copies         TYPE numc13,        " Author
         emlo_copies           TYPE numc13,        " EMLO
         adjustment            TYPE numc13,        " Adjustment
         total_po_qty          TYPE numc13,        " Print Run: Total PO Qty
         marc_ismarrivaldateac TYPE dats,          " Actual Goods Arrival
         estimated_soh         TYPE numc13,        " Estimated SOH
         initial_soh           TYPE numc13,        " SOH Initial
         current_soh           TYPE numc13,        " SOH Current
         reprint_qty           TYPE numc13,        " Reprint Qty
         reprint_po_no         TYPE text200,       " Reprint PO
         reprint_reason        TYPE text200,       " Reprint Reason
         remarks               TYPE text200,       " Remarks
         om_instructions       TYPE text200,       " OM Instructions
       END OF ty_litho.
" EOC: ERPM-837  KKRAVURI  2020-10-01  ED2K919750

DATA: ok_code               LIKE sy-ucomm,
      gv_cancel,                             " F12
      ok_code_0500          LIKE ok_code,
      popup_status(1),
      con_popupstatus_abort LIKE popup_status VALUE 'A',
      i_matnr_issue         TYPE ismmatnr_issuetab,
* BOC: ERPM-837 KKRAVURI LITHO Report Changes  ED2K919143
      gv_exp_days           TYPE numc3,      " Expiry days
      gv_lognumber          TYPE balognr,    " Application log number
      gv_matnr              TYPE matnr,      " Media Issue
      gv_plant              TYPE werks_d,    " Plant
* EOC: ERPM-837 KKRAVURI LITHO Report Changes  ED2K919143
*BOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
      gv_pubdate            TYPE ismpubldate,
      gv_product            TYPE ismrefmdprod,
      gv_adjustment         TYPE char13,
      gv_omactual           TYPE numc13.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719


* INCLUDE LJKSD13D...                        " Local class definition

CONSTANTS: con_plant_memoryid TYPE memoryid      "TK01042008/hint1158167
               VALUE 'WORKLIST_PLANT'.           "TK01042008/hint1158167
CONSTANTS: con_vkorg_memoryid TYPE memoryid      "TK01042008/hint1158167
               VALUE 'WORKLIST_VKORG'.           "TK01042008/hint1158167
CONSTANTS: con_vtweg_memoryid TYPE memoryid      "TK01042008/hint1158167
               VALUE 'WORKLIST_VTWEG'.           "TK01042008/hint1158167

* BOC: ERPM-837 KKRAVURI LITHO Report Changes  ED2K919143
CONSTANTS:
  c_msgid_zqtc TYPE symsgid     VALUE 'ZQTC_R2',    " Message Class - ZQTC_R2
  c_msgno_000  TYPE symsgno     VALUE '000',        " Message Number - 000
  c_n          TYPE mbrsh       VALUE 'N',          " Industry Sector
  c_zl         TYPE char2       VALUE 'ZL',         " Print Method: LITHO (Print)
  c_zd         TYPE char2       VALUE 'ZD',         " Print Method: DIGITAL
  c_msgtyp_i   TYPE symsgty     VALUE 'I',          " Message Type
  c_object     TYPE balobj_d    VALUE 'ZQTC',       " Application Log: Object Name (Application Code)
  c_subobj     TYPE balsubobj   VALUE 'ZSCM_LITHO'. " Application Log: Sub Object
* EOC: ERPM-837 KKRAVURI LITHO Report Changes  ED2K919143
