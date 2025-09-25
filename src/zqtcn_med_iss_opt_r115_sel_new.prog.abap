*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MED_ISS_OPT_R115_SEL_NEW
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*   selection screen                                                  *
*---------------------------------------------------------------------*


*Block for Media Master Data
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-001.
SELECT-OPTIONS :
             s_prod   FOR jksesched-product,
             s_issu   FOR jksesched-issue,
             s_pbdt   FOR mara-ismpubldate,
             s_indt   FOR mara-isminitshipdate,
             s_dldt   FOR jksenip-shipping_date,
             s_gddt   FOR marc-ismarrivaldateac.
SELECTION-SCREEN END OF BLOCK bl1.

*Block for Organization Data
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-002.
SELECT-OPTIONS:
             s_sorg   FOR vbak-vkorg, " OBLIGATORY,
             s_dist   FOR vbak-vtweg, " DEFAULT '00',
             s_sdiv   FOR vbak-spart, "DEFAULT '00',
             s_soff   FOR vbak-vkbur.
SELECTION-SCREEN END OF BLOCK bl2.

*Block for Document Data
SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE text-003.
SELECT-OPTIONS:
             s_sdoc   FOR vbak-vbeln, " OBLIGATORY,
             s_assg   FOR zcds_mi_r115_rpt-assignment,
             s_dctp   FOR vbak-auart, " DEFAULT '00',
             s_itcg   FOR vbap-pstyv,
             s_csdt   FOR zcds_mi_r115_rpt-contract_start_date,
             s_cedt   FOR zcds_mi_r115_rpt-contract_end_date,
             s_rele   FOR jkseflow-vbelnorder.
"s_vdat   FOR zcds_mi_r115_rpt-contract_start_date.
SELECTION-SCREEN END OF BLOCK bl3.

* Display Unearned Record
SELECTION-SCREEN BEGIN OF BLOCK bl5 WITH FRAME TITLE text-005.
SELECT-OPTIONS:
s_iamt FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION. "LISTBOX VISIBLE LENGTH 10. "type zcds_mi_r115_rpt-bill_block_flag. "Display unearned records
SELECTION-SCREEN END OF BLOCK bl5.

SELECTION-SCREEN BEGIN OF BLOCK bl4 WITH FRAME TITLE text-004.
*PARAMETERS: c_exbb as CHECKBOX, "Exclude billing blocked docs
*            c_exdb as CHECKBOX, "Exclude delivery blocked docs
*            c_excb as CHECKBOX, "Exclude Credit blocked docs
*            c_excc as CHECKBOX, "Exclude cancelled contracts
*            c_exro as CHECKBOX, "Exclude rejected orders
*            c_irel as CHECKBOX. "Display Release Order docs

*tables: vbuk.

SELECT-OPTIONS:
            s_exbb FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION,"LISTBOX VISIBLE LENGTH 10 no-EXTENSION, "zcds_mi_r115_rpt-bill_block_flag, "Exclude billing blocked docs
            s_exdb FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION, "LISTBOX VISIBLE LENGTH 10, "type zcds_mi_r115_rpt-del_block_flag, "Exclude delivery blocked docs
            s_excb FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION, "LISTBOX VISIBLE LENGTH 10, "type zcds_mi_r115_rpt-credit_block_flag, "Exclude Credit blocked docs
            s_excc FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION, "LISTBOX VISIBLE LENGTH 10, "type zcds_mi_r115_rpt-cancel_ord_flag, "Exclude cancelled contracts
            s_exro FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION, "LISTBOX VISIBLE LENGTH 10, "type zcds_mi_r115_rpt-cancel_res_flag, "Exclude rejected orders
            s_irel FOR zcds_mi_r115_rpt-bill_block_flag NO INTERVALS NO-EXTENSION. "LISTBOX VISIBLE LENGTH 10, "type zcds_mi_r115_rpt-rel_ord_flag, "Display Release Order docs

SELECTION-SCREEN END OF BLOCK bl4.
