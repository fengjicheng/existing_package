*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CNTRCT_WITHOUT_JKSE_SEL (Include Program)
* PROGRAM DESCRIPTION: Selection Screen declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   02/13/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917550
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN  OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS : s_auart FOR zcds_jkse_cwsch-contract_type,             " Contract type
                 s_pstyv FOR zcds_jkse_cwsch-item_category,             " Item category
                 s_vkorg FOR zcds_jkse_cwsch-sales_org OBLIGATORY,      " Sales Organization
                 s_cdate FOR zcds_jkse_cwsch-contract_start_date OBLIGATORY, " Contract date
                 s_ddate FOR zcds_jkse_cwsch-document_date.  " Document date

SELECTION-SCREEN END OF BLOCK b1.
