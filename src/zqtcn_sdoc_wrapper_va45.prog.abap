*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_VA45 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA45
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050
* TRANSPORT NUMBER(S): ED2K906227
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913057
* REFERENCE NO: ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-14
* DESCRIPTION: Added new fields: Number of FTEs, Sold-to Party Email ID
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914716
* REFERENCE NO: DM1748
* DEVELOPER: VDPATABALL
* DATE:  03/19/2019
* DESCRIPTION: added SALES TEXT DISPLAY in ZQTC_VA45 screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915770
* REFERENCE NO:
* DEVELOPER: Lahiru Wathudura
* DATE:  07/25/2019
* DESCRIPTION: Comment Delivery block output to avoid the duplicate in report output
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

* Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
DATA:
  li_join_metadata_va45 TYPE if_sdoc_select=>tct_join_metadata,
  li_fieldname_va45     TYPE tdt_fieldname. " Field Name
* End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057

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

*Customer group 1
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kvgr1
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kvgr1 )
    INTO TABLE ct_result_comp.

**Customer group 2
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

  "" Comment by Lahiru on 07/25/2019 to avoidthe duplicate columns from the output.
**Delivery block (document header)
*INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
*                field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifsk
*                name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_lifsk )
*  INTO TABLE ct_result_comp.

*Billing block in SD document
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_faksk
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_faksk )
    INTO TABLE ct_result_comp.

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

* Assignment number
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zuonrk
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_zuonr )
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

* Tax amount in document currency
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_mwsbp
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_mwsbp )
    INTO TABLE ct_result_comp.

* Promo code
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzpromo
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzpromo )
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
* Subscription Type
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzsubtyp
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_zzsubtyp )
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
* Posting Status of Billing Document
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbuk
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_buchk
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbuk_buchk )
    INTO TABLE ct_result_comp.

* Customer purchase order type
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bsark
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_bsark )
    INTO TABLE ct_result_comp.

* Your Reference
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez )
    INTO TABLE ct_result_comp.

* Price group (customer)
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_konda
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_konda )
    INTO TABLE ct_result_comp.

*BOC by MODUTTA on 14/07/2017 for CR# 543
* Membership Category
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdkg2
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_kdkg2 )
    INTO TABLE ct_result_comp.

*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bname
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_bname )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez_e )
    INTO TABLE ct_result_comp.
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017
* Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
* Identify fields for Join Condition (KNVV [Customer Master Sales Data] table)
  CLEAR: li_join_metadata_va45.
* Customer Number (Sold-To Party)
  INSERT VALUE #( target_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kunnr
                  source_table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  source_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kunnr )
    INTO TABLE li_join_metadata_va45.
* Sales Organization
  INSERT VALUE #( target_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vkorg
                  source_table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  source_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vkorg )
    INTO TABLE li_join_metadata_va45.
* Distribution Channel
  INSERT VALUE #( target_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtweg
                  source_table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  source_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtweg )
    INTO TABLE li_join_metadata_va45.
* Division
  INSERT VALUE #( target_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_spart
                  source_table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbak
                  source_field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtweg )
    INTO TABLE li_join_metadata_va45.
* Join KNVV [Customer Master Sales Data] table
  INSERT VALUE #( target_table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_knvv
                  join_metadata = li_join_metadata_va45 )
    INTO TABLE ct_additional_table_metadata.
* Display field "Number of FTE’s"
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_knvv
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zzfte
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-knvv_zzfte )
    INTO TABLE ct_result_comp.

* Display Sold-to Party's Address Number (Mandatory field for Email ID Selection)
  INSERT VALUE #( table       = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_adrc
                  field       = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_addrn
                  table_alias = if_sdoc_select~co_tablename-adrc_ag
                  text        = 'Sold-To Party Address#'(427)
                  name        = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_addrn )
    INTO TABLE ct_result_comp.

  CLEAR: li_fieldname_va45.
  APPEND zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_addrn TO li_fieldname_va45.
* Display field "Sold-To Party's E-Mail Address"
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_email
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_email
                  text          = 'Sold-To Party E-mail Address'(428)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.
* End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
*---Begin of change VDPATABALL DM1748 03/19/2019

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_stras
                  text          = 'Sold-To Street'(028)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street2
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_street2
                  text          = 'Sold-To Street2'(039)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.
*
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                 name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_ort01
                 text          = 'Sold-To City'(029)
                 required_comp = li_fieldname_va45 )
   INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_region
                 name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_regio
                 text          = 'Sold-To State/Region'(030)
                 required_comp = li_fieldname_va45 )
   INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_pstlz
                text          = 'Sold-To Postal Code'(031)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_land1
                text          = 'Sold-To Country'(032)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.
*
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_shipto
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto
                  text          = 'Ship-To Party'(033)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name1           "shipto_name
                  text          = 'Ship-To Party name'(041)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name2           "shipto_name
                  text          = 'Ship-To Party name2'(458)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_stras
                text          = 'Ship-To Street'(034)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street2
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_street2
                text          = 'Ship-To Street2'(040)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                 name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_ort01
                 text          = 'Ship-To City'(035)
                 required_comp = li_fieldname_va45 )
   INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_region
                 name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_regio
                 text          = 'Ship-To State/Region'(036)
                 required_comp = li_fieldname_va45 )
   INTO TABLE ct_result_comp.
*
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_pstlz
                text          = 'Ship-To Postal Code'(037)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_land1
                text          = 'Ship-To Country'(038)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_email
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ship_email
                text          = 'Ship-To Email'(042)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_media_type
                name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-mediatype
                text          = 'Media Type'(043)
                required_comp = li_fieldname_va45 )
  INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_msg
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_text
                  text          = 'Text Message'(027)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.
*---End of change VDPATABALL DM1748 03/19/2019

** Begin of added by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536 **
  INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbpa
                  field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_lifnr
                  name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                  text = 'Fwd Agent No'(431) )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fwname
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                  text          = 'Fwd Agent Name'(432)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_street
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                  text          = 'Fwd Agent Street'(433)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_city
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                  text          = 'Fwd Agent City'(434)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_postal
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                  text          = 'Fwd Agent Postal Code'(435)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_country
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                  text          = 'Fwd Agent Country'(436)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.
** End of added by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536 **

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
* Overall credit status
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_cmgst
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_stat
                  text          = 'Overall Credit Status'(444)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Credit description
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bezei
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_desc
                  text          = 'Overall Credit Status Description'(445)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Billing type description
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_vtext_1
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-bill_desc
                  text          = 'Billing type description'(453)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Paid status
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_pstatus
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-paid_status
                  text          = 'Paid Status'(454)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Credit Limit
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_crlimit
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                  text          = 'Credit Limit'(457)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Sold t party name2
  INSERT VALUE #( field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_name
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-slodto_name2
                  text          = 'Sold to Party Name2'(459)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.

* Contract Payment method
  INSERT VALUE #( table         = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                  field         = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_zlsch_1
                  name          = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_zlsch
                  text          = 'Contract Payment Method'(460)
                  required_comp = li_fieldname_va45 )
    INTO TABLE ct_result_comp.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
