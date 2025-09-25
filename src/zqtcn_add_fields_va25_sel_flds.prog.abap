* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906855
* REFERENCE NO: CR#543
* DEVELOPER: Paramita Bose (PBOSE)
* DATE:  2017-07-05
* DESCRIPTION: Add new fields in VA25.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918259
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/20/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADD_FIELDS_VA25_SEL_FLDS
*&---------------------------------------------------------------------*
* Reference Document
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vgbel
                       s_vgbel.
*License Group
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicgrp
                       s_zzligp.
*Sales document item category
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstyv
                       s_pstyv.

*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
*** Customer Material Number
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                       s_kdmat.
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018

*---Begin of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*
* Price group
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_konda
                       s_konda.

* Rejection reason
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_abgru
                       s_abgru.
* Payment method
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zlsch_1
                       s_zlsch.
*---End of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*

*** BOC BY NPALLA for JIRA# OCTM-49605 on 20-OCT-2021 - ED2K924869
*** PO Type
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bsark
                       s_bsark.
*** EOC BY NPALLA for JIRA# OCTM-49605 on 20-OCT-2021 - ED2K924869
