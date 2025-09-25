*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_VA05 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   06/15/2017
* OBJECT ID: R052
* TRANSPORT NUMBER(S): ED2K906705
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917757 / ED2K917910
* REFERENCE NO:  ERPM-10485
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  03/10/2020   / 04/04/2020
* DESCRIPTION: Add freight forwarding and JPAT order fields
*---------------------------------------------------------------------*
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
* SOC by NPOLINA ERP7836
* Commented to avoid duplicates in ALV ED2K915777
**Delivery block (document header)
*INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
*                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifsk
*                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_lifsk )
*  INTO TABLE ct_result_comp.
*
**Billing block in SD document
*INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
*                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_faksk
*                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_faksk )
*  INTO TABLE ct_result_comp.
* EOC by NPOLINA ERP7836 ED2K915777
*Document number of the reference document
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vgbel
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_vgbel )
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
* No return
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zznoreturn
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zznoreturn )
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
* Consolidation/Packing list/Price on Packing List
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzwhs
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzwhs )
  INTO TABLE ct_result_comp.
* License Group
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzlicgrp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zzlicgrp )
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

* Registration code
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzrgcode
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzrgcode )
  INTO TABLE ct_result_comp.
* Cancel backorder by date
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzcancdate
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzcancdate )
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
* Ship complete or cancel complete
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzshpocanc
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzshpocanc )
  INTO TABLE ct_result_comp.

* Promo Code
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzpromo )
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

* Your reference
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez )
  INTO TABLE ct_result_comp.

* Billing Document Number
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vbeln
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_vbeln )
  INTO TABLE ct_result_comp.

* Billing Document Type
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fkart
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkart )
  INTO TABLE ct_result_comp.

* Billing category
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fktyp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fktyp )
  INTO TABLE ct_result_comp.

* Billing date for billing index and printout
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fkdat
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkdat )
  INTO TABLE ct_result_comp.

* Fiscal Year
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_gjahr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_gjahr )
  INTO TABLE ct_result_comp.

* Posting period
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_poper
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_poper )
  INTO TABLE ct_result_comp.

* Price group
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_konda
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_konda )
  INTO TABLE ct_result_comp.

* Customer group
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdgrp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kdgrp )
  INTO TABLE ct_result_comp.

* Price List
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pltyp
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_pltyp )
  INTO TABLE ct_result_comp.

* Incoterms
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_inco1
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_inco1 )
  INTO TABLE ct_result_comp.

* Terms of Payment
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zterm
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zterm )
  INTO TABLE ct_result_comp.

* Payment Method
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zlsch
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zlsch
                text  = 'Invoice Payment Method'(463) )
  INTO TABLE ct_result_comp.

* Cust.Acct.Assg.Group
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ktgrd
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ktgrd )
  INTO TABLE ct_result_comp.

* Net Value
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_netwr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_netwr )
  INTO TABLE ct_result_comp.

* Combination criteria
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zukri
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zukri )
  INTO TABLE ct_result_comp.

* Created by
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ernam
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ernam )
  INTO TABLE ct_result_comp.

* Time
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_erzet
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erzet )
  INTO TABLE ct_result_comp.


* Created on
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_erdat
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erdat )
  INTO TABLE ct_result_comp.

* Payer
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kunrg
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kunrg )
  INTO TABLE ct_result_comp.

* VAT Registration No.
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_stceg
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_stceg )
  INTO TABLE ct_result_comp.

* Cancelled Bill.Doc.
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_sfakn
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_sfakn )
  INTO TABLE ct_result_comp.

* Exchange Rate Type
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kurst
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kurst )
  INTO TABLE ct_result_comp.

* Dunning Key
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mschl
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mschl )
  INTO TABLE ct_result_comp.

* Assignment
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zuonr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zuonr )
  INTO TABLE ct_result_comp.

* Tax amount
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mwsbk
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mwsbk )
  INTO TABLE ct_result_comp.

* Payment reference
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kidno
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kidno )
  INTO TABLE ct_result_comp.

* Billing Document
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vbeln
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_vbeln )
  INTO TABLE ct_result_comp.

* Item
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_posnr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_posnr )
  INTO TABLE ct_result_comp.

* Higher-level item
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_uepos
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_uepos )
  INTO TABLE ct_result_comp.

* Net value
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_netwr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_netwr )
  INTO TABLE ct_result_comp.
**
* Subtotal 1
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi1
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi1 )
  INTO TABLE ct_result_comp.


* Subtotal 2
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi2
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi2 )
  INTO TABLE ct_result_comp.

* Subtotal 3
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi3
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi3 )
  INTO TABLE ct_result_comp.

* Subtotal 4
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi4
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi4 )
  INTO TABLE ct_result_comp.

* Subtotal 5
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi5
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi5 )
  INTO TABLE ct_result_comp.

* Subtotal 6
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kzwi6
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi6 )
  INTO TABLE ct_result_comp.

* Profit Center
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_prctr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_prctr )
  INTO TABLE ct_result_comp.

* Tax Jurisdiction
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_txjcd
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_txjcd )
  INTO TABLE ct_result_comp.

** Begin of Changes by Lahiru on ERPM-10485 03/10/2020 with ED2K917757 **
* Forwarding Agent & name moved to the down becasue it should be link with ED2K918275

* PO Number
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ebeln
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ekko_ebeln
                text          = 'Mainlabel Purchase Order Number'(438) )
  INTO TABLE ct_result_comp.

* PO Date
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bedat
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-po_date
                text          = 'Mainlabel Purchase Order Document Date'(439) )
  INTO TABLE ct_result_comp.

* Outbound delivery Number
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_delno
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-likp_vbeln
                text          = 'Outbound Delivery Number'(440) )
  INTO TABLE ct_result_comp.

* Outbound Delivery date
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bldat
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-del_date
                text          = 'Outbound Delivery Document Date'(441) )
  INTO TABLE ct_result_comp.

* Shipping Condition
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtext
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ship_cond
                text          = 'Shipping Condition'(442) )
  INTO TABLE ct_result_comp.

* Subscription Order Type
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_auart
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-order_type
                text          = 'Subscription Order Type'(443) )
  INTO TABLE ct_result_comp.

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
** End of Changes by Lahiru on ERPM-10485 03/10/2020 with ED2K917757 **

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
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

** Begin of ERPM-10485 UAT Changes added with ED2K917910
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifnr
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                text = 'Forwarding Agent'(437) )
  INTO TABLE ct_result_comp.

* Forwarding Agent Name
INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fwname
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                text = 'Fwd Agent Name'(432) )
  INTO TABLE ct_result_comp.
** End of ERPM-10485 UAT Changes added with ED2K917910

* Forwading agent street
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                text          = 'Fwd Agent Street'(433) )
  INTO TABLE ct_result_comp.

* Forwading agent City
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                text          = 'Fwd Agent City'(434) )
  INTO TABLE ct_result_comp.

* Forwading agent postal code
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                text          = 'Fwd Agent Postal Code'(435) )
  INTO TABLE ct_result_comp.

* Forwading agent country
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                text          = 'Fwd Agent Country'(436) )
  INTO TABLE ct_result_comp.

* Billing type description
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtext_1
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-bill_desc
                text          = 'Billing type description'(453) )
  INTO TABLE ct_result_comp.

* Paid status
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstatus
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-paid_status
                text          = 'Paid Status'(454) )
  INTO TABLE ct_result_comp.

* Credit Limit
INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_crlimit
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                text          = 'Credit Limit'(457) )
  INTO TABLE ct_result_comp.

* Order Payment method
INSERT VALUE #( table         = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zlsch_1
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_zlsch
                text          = 'Order Payment Method'(462) )
  INTO TABLE ct_result_comp.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*

* BOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kdmat
                text  = 'Customer Material Number'(424) )
  INTO TABLE ct_result_comp.
* EOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
