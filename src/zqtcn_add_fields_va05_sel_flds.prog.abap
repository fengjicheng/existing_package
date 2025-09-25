*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA05_SEL_FLDS (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   06/15/2017
* OBJECT ID: R052
* TRANSPORT NUMBER(S): ED2K906705
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Transfering BillBlock & Delv Block to ZQTC_VA05 selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918275
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/21/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922945
* REFERENCE NO:  OTCM-42980
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  04/08/2021
* DESCRIPTION: Add Customer material no to Selection and report output
*---------------------------------------------------------------------*
* Reference Document
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vgbel
                       s_vgbel.

*Promo code
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                       s_promo.

*License Group
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicgrp
                       s_licgrp.

*Sales document item category
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstyv
                       s_pstyv.

*Material group 1
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr1
                       s_mvgr1.

*Material group 2
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr2
                       s_mvgr2.

*Material group 3
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr3
                       s_mvgr3.

*Material group 4
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr4
                       s_mvgr4.

*Material group 5
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr5
                       s_mvgr5.

*Customer purchase order type
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bsark
                       s_bsark.

*Your Reference
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez
                       s_ihrez.

*** BOC BY SAYANDAS for JIRA#6289 on 04-MAY-2018
*** Your Reference
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
                       s_ihreze.
*** EOC BY SAYANDAS for JIRA#6289 on 04-MAY-2018
*--SOC NPOLINA 08/13/2019 DM7836 ED2K915777
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifsk
                       s_dlvblk.

transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_faksk
                       s_bilblk.
*--EOC NPOLINA 08/13/2019 DM7836 ED2K915777

*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918275---*
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
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918275---*

* BOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                       s_kdmat.
* EOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
