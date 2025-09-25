*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_VA25 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA25
* DEVELOPER: Nallapaneni Mounika (nmounika)
* CREATION DATE:   06/22/2017
* OBJECT ID: R054
* TRANSPORT NUMBER(S): ED2K906855
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917574
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/17/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918259
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/21/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K924869
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 10/29/2021
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K925479
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 01/10/2022
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list. Add
*               Ship to Address Fields
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SDOC_WRAPPER_VA25
*&---------------------------------------------------------------------*
*Customer group 1
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr1
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr1 )
  INTO TABLE ct_result_comp.
*Customer group 2
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr2
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr2 )
  INTO TABLE ct_result_comp.

*Customer group 3
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr3
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr3 )
  INTO TABLE ct_result_comp.

*Customer group 4
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr4
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr4 )
  INTO TABLE ct_result_comp.

*Customer group 5
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr5
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr5 )
  INTO TABLE ct_result_comp.
*Purchase order Type
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bsark
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_bsark )
 INTO TABLE ct_result_comp.
* Sales document item category
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstyv
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_pstyv )
  INTO TABLE ct_result_comp.

*Material group 1
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr1
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mvgr1 )
  INTO TABLE ct_result_comp.

*Material group 2
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr2
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mvgr2 )
  INTO TABLE ct_result_comp.

*Material group 3
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr3
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mvgr3 )
  INTO TABLE ct_result_comp.

*Material group 4
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr4
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mvgr4 )
  INTO TABLE ct_result_comp.

*Material group 5
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mvgr5
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mvgr5 )
  INTO TABLE ct_result_comp.
* Your reference
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez )
  INTO TABLE ct_result_comp.
*  Price Group
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_konda
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_konda )
  INTO TABLE ct_result_comp.
*  Condition Group 2
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdkg2
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_kdkg2 )
  INTO TABLE ct_result_comp.
*  Partner Functions
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbpa
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_parvw
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_parvw )
  INTO TABLE ct_result_comp.
* SFDC case
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzsfdccase
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzsfdccase )
  INTO TABLE ct_result_comp.
* FICE
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzfice
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzfice )
  INTO TABLE ct_result_comp.

* Hold Date from
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzholdfrom
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzholdfrom )
  INTO TABLE ct_result_comp.
* Hold Date to
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzholdto
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzholdto )
  INTO TABLE ct_result_comp.
* Promo code
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzpromo )
  INTO TABLE ct_result_comp.
* License Group
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicgrp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzlicgrp )
  INTO TABLE ct_result_comp.
* Promo Code
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzpromo )
  INTO TABLE ct_result_comp.
* Registration code
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzrgcode
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzrgcode )
  INTO TABLE ct_result_comp.
* Article Number
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzartno
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzartno )
  INTO TABLE ct_result_comp.
* ISBN Language
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzisbnlan
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzisbnlan )
  INTO TABLE ct_result_comp.
* Volume Year Product
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzvyp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzvyp )
  INTO TABLE ct_result_comp.
* Access Mechanism
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzaccess_mech
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzaccess_mech )
  INTO TABLE ct_result_comp.
* Content Start Date Override
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzconstart
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzconstart )
  INTO TABLE ct_result_comp.
* Content End Date Override
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzconend
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzconend )
  INTO TABLE ct_result_comp.
* License Start Date Override
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicstart
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzlicstart )
  INTO TABLE ct_result_comp.
* License End Date Override
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicend
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzlicend )
  INTO TABLE ct_result_comp.
INSERT VALUE #(
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vbtyp_n
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbfa_vbtyp_n )
  INTO TABLE ct_result_comp.


INSERT VALUE #(
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vbeln_vbfa
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbfa_vbeln )
  INTO TABLE ct_result_comp.

*Customer Group 2
*BOC by MODUTTA on 14/07/2017 fopr CR# 543
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdkg2
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_kdkg2 )
  INTO TABLE ct_result_comp.

** Begin of added by Lahiru on 02/17/2020 ERPM-9418 with ED2K917574 **
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbpa
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifnr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                text = 'Fwd Agent No'(431) )
  INTO TABLE ct_result_comp.

INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fwname
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                text          = 'Fwd Agent Name'(432) )
*                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                text          = 'Fwd Agent Street'(433) )
  INTO TABLE ct_result_comp.

INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                text          = 'Fwd Agent City'(434) )
  INTO TABLE ct_result_comp.

INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                text          = 'Fwd Agent Postal Code'(435) )
  INTO TABLE ct_result_comp.

INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                text          = 'Fwd Agent Country'(436) )
  INTO TABLE ct_result_comp.
** End of added by Lahiru on 02/17/2020 ERPM-9418 with ED2K917574 **

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
* Overall credit status
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_cmgst
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_stat
                text          = 'Overall Credit Status'(444) )
  INTO TABLE ct_result_comp.

* Credit description
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bezei
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_desc
                text          = 'Overall Credit Status Description'(445) )
  INTO TABLE ct_result_comp.

* Credit Limit
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_crlimit
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                text          = 'Credit Limit'(457) )
  INTO TABLE ct_result_comp.

* Ship to party code
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_shipto
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto
                text          = 'Ship-To Party'(033) )
  INTO TABLE ct_result_comp.

* Ship to party name1
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name1
                text          = 'Ship-To Party name'(041)  )
  INTO TABLE ct_result_comp.

* Ship to party name2
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name2
                text          = 'Ship-To Party name2'(458) )
  INTO TABLE ct_result_comp.

* Sold t party name2
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-slodto_name2
                text          = 'Sold to Party Name2'(459) )
  INTO TABLE ct_result_comp.

* Contract Payment method
INSERT VALUE #( table         = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zlsch_1
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_zlsch
                text          = 'Quotation Payment Method'(461) )
  INTO TABLE ct_result_comp.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

*---BOC VDPATABALL ED2K924869 OTCM-54011 20-Oct-2021 - India agent new fieds
* Tax Line Item
INSERT VALUE #( table         = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi6
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kzwi6
                text          = 'Tax Line Item'(472) )
  INTO TABLE ct_result_comp.

* Tax Header
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi6
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kzwi6
                text          = 'Tax Header'(473) )
  INTO TABLE ct_result_comp.
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kbetr
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-konv_kbetr
                text          = 'Condition Type Value'(045) )
  INTO TABLE ct_result_comp.
*---EOC VDPATABALL ED2K924869 OTCM-54011 20-Oct-2021 - India agent new fieds
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
* Ship to Street
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_stras
                text          = 'Ship-To Street'(034)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

* Ship to City
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_ort01
                text          = 'Ship-To City'(035)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

* Ship to State/Region
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_region
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_regio
                text          = 'Ship-To State/Region'(036)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

* Ship to Postal Code
INSERT VALUE #( field       = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
              name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_pstlz
              text          = 'Ship-To Postal Code'(037)
              required_comp = li_fieldname_va45 )
INTO TABLE ct_result_comp.

* Ship to country
INSERT VALUE #( field       = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
              name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_land1
              text          = 'Ship-To Country'(038)
              required_comp = li_fieldname_va45 )
INTO TABLE ct_result_comp.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
