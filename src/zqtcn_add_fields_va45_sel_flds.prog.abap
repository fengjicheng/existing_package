*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA45_SEL_FLDS (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA45
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050
* TRANSPORT NUMBER(S): ED2K906227
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906843
* REFERENCE NO: CR#543
* DEVELOPER: Paramita Bose (PBOSE)
* DATE:  2017-07-03
* DESCRIPTION: Add new fields in VA45.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908958
* REFERENCE NO: CR#706
* DEVELOPER: Sayantan Das (SAYANDAS)
* DATE:  2017-10-12
* DESCRIPTION: Add new fields in VA45.
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
* REVISION NO: ED2K917536
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/13/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918229
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/15/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918827
* REFERENCE NO:  ERPM-21199
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  07/09/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          :  11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*---------------------------------------------------------------------*

* Item Category
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstyv
                       s_pstyv.

* Reference Document
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vgbel
                       s_vgbel.

* Terms of Payment Key
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zterm
                       s_zterm.

* Your Reference
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez
                       s_ihrez.

* Subscription Type
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzsubtyp
                       s_sbtyp.

* Purchase Order Type
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bsark
                       s_bsark.

*Assignment number
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zuonrk
                       s_zuonr.

*Promo code
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                       s_promo.

*License Group
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicgrp
                       s_licgrp.

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

* Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
*Customer condition group 2
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdkg2
                       s_kdkg2.

* Delivery Block
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifsk
                       s_lifsk.

* Billing Block
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_faksk
                       s_faksk.

*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bname
                       s_bname.

transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
                       s_ihreze.
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017

*** BOC BY SAYANDAS FOR JIRA# 6289 on 04-MAY-2018
transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                       s_kdmat.
*** EOC BY SAYANDAS FOR JIRA# 6289 on 04-MAY-2018
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
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
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

IF sy-tcode = 'VA45'.
  transfer_select_option zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                       zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fkdat
                       s_fkdat.
ENDIF.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
