*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU04 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA. This is copied from
*                      ZQTCN_INSUB04 and enhanced it.
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   19/08/2016
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K902770
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907156
* REFERENCE NO: ERP-2772
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-10
* DESCRIPTION: As currently contract start date and end dates are not
*              being populated for the reprint scenario of CSS when legacy
*              system doesn't send any dates. Ideally it should have copied
*              from header contract dates. When the contract dates are passed
*              in conversion C064, C042 or interface(I230) same dates are not
*              taken into consideration. Issue is corrected now by not updating
*              the rule when there is a date.
*----------------------------------------------------------------------*
* REVISION NO: ED2K909381
* REFERENCE NO: SAP Recommendations
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE: 20-Nov-2017
* DESCRIPTION: As per SAP recommendations we have optimized the code to ensure
*              that only once each screen is called to avoid unnecessary navigation.
*----------------------------------------------------------------------*
* REVISION NO: ED2K910085
* REFERENCE NO: I0230 - CR#741
* DEVELOPER: Writtick Roy (WROY)
* DATE: 02-Jan-2018
* DESCRIPTION: Populate Version Field
*----------------------------------------------------------------------*
* REVISION NO: ED2K908513
* REFERENCE NO: E162 - CR#607
* DEVELOPER: Writtick Roy (WROY)
* DATE: 08-Dec-2017
* DESCRIPTION: Store Contract Start Dates for DB BOM
*----------------------------------------------------------------------*
* REVISION NO: ED2K912174, ED2K912224 ---------------------------------*
* REFERENCE NO: I0230 - CR#6142
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE: 31-May-2018
* DESCRIPTION: Addition of new custom fields (PQ Deal Type, Cluster Type
* (In VBAP table) & License Year (In VBAK table)) to Inbound Sub. Order
*----------------------------------------------------------------------*
* REVISION NO: ED2K912853 ---------------------------------------------*
* REFERENCE NO: I0230 - CR#6122
* DEVELOPER(s): Rahul Tripathi (RTRIPAT2/RTR)
*               Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE: 31-May-2018
* DESCRIPTION: Billing Date change at Header level in Inbound Sub. Order
*----------------------------------------------------------------------*
* REVISION NO: ED2K913701 ---------------------------------------------*
* REFERENCE NO: I0230 - CR#7480
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 26-OCTOBER-2018
* DESCRIPTION: Addition of new custom fields (Cover Year, Cover Month)
* (In VBAP table) to Inbound Sub. Order
*----------------------------------------------------------------------*
* REVISION NO: ED2K913920 ---------------------------------------------*
* REFERENCE NO: I0230 - CR#6310
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 22-NOVEMBER-2018
* DESCRIPTION: Update Address fields 'NAME_CO' & 'SMTP_ADDR' to
* Bill-to party (RE) at header level in Inbound Sub. Order
*----------------------------------------------------------------------*
* REVISION NO: ED2K918929 ---------------------------------------------*
* REFERENCE NO: ERPM-1392 (I0230)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 17-JULY-2020
* DESCRIPTION: Process for Payment card manual Authorization
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K926194 ---------------------------------------------*
* REFERENCE NO: OTCM-54171/2 (I0230)
* DEVELOPER: Polina Nageswara / Bharat kumar saki (bsaki)
* DATE: 22-March-2022
* DESCRIPTION: For ship-to-party(WE)Contact names changing between     *
*              times of invoice generation                             *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K926194 ---------------------------------------------*
* REFERENCE NO: OTCM-54171/2 (I0230)
* DEVELOPER: MADAVOIN RAJKUMAR(MRAJKUMAR)
* DATE: 14-April-2022
* DESCRIPTION: if the ship to party is different between header and item
*              then assigning the E1EDKT2 021 ( E1EDKT2) segment name
*              should be assigned to item level ship to party c/o name *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB04_NEW
*&---------------------------------------------------------------------*

*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak. "Kopfdaten
         INCLUDE STRUCTURE vbak. " Sales Document: Header Data
         TYPES:  bstkd LIKE vbkd-bstkd. " Customer purchase order number

TYPES:  kursk LIKE vbkd-kursk. "Währungskurs
TYPES:  zterm LIKE vbkd-zterm. "Zahlungsbedingungsschlüssel
TYPES:  incov LIKE vbkd-incov. "Incoterms Teil Version
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms Teil 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms Teil 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms Teil 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms Teil 3_L
TYPES:  prsdt LIKE vbkd-prsdt. "Datum für Preisfindung
TYPES:  angbt LIKE vbak-vbeln. "Angebotsnummer Lieferant (SAP)
TYPES:  contk LIKE vbak-vbeln. "Kontraknummer Lieferant (SAP)
TYPES:  kzazu LIKE vbkd-kzazu. "Kz. Auftragszusammenführung
TYPES:  fkdat LIKE vbkd-fkdat. "Datum Faktura-/Rechnungsindex
TYPES:  fbuda LIKE vbkd-fbuda. "Datum der Leistungserstellung
TYPES:  empst LIKE vbkd-empst. "Empfangsstelle
TYPES:  valdt LIKE vbkd-valdt. "Valuta-Fix Datum
TYPES:  kdkg1 LIKE vbkd-kdkg1. "Kunden Konditionsgruppe 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. "Kunden Konditionsgruppe 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. "Kunden Konditionsgruppe 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. "Kunden Konditionsgruppe 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. "Kunden Konditionsgruppe 5
TYPES:  delco LIKE vbkd-delco. "vereinbarte Lieferzeit
TYPES:  abtnr LIKE vbkd-abtnr. "Abteilungsnummmer
TYPES:  dwerk LIKE rv45a-dwerk. "disponierendes Werk
TYPES:  angbt_ref LIKE vbkd-bstkd. "Angebotsnummer Kunde (SAP)
TYPES:  contk_ref LIKE vbkd-bstkd. "Kontraknummer Kunde  (SAP)
TYPES:  currdec LIKE tcurx-currdec. "Dezimalstellen Währung
TYPES:  bstkd_e LIKE vbkd-bstkd_e. "Bestellnummer Warenempfänger
TYPES:  bstdk_e LIKE vbkd-bstdk_e. "Bestelldatum Warenempfänger
TYPES: END OF lty_xvbak.

***<--- Change by SAYNADAS
*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap. "Position
         INCLUDE STRUCTURE vbap. " Sales Document: Item Data
         TYPES:  matnr_output(40) TYPE c. " Output(40) of type Character
TYPES:  wmeng(18) TYPE c. " Types: wmeng(18) of type Character
TYPES:  lfdat LIKE vbap-abdat. " Reconciliation Date for Agreed Cumulative Quantity
TYPES:  kschl LIKE komv-kschl. " Condition type
TYPES:  kbtrg(16) TYPE c. " Types: kbtrg(16) of type Character
TYPES:  kschl_netwr LIKE komv-kschl. " Condition type
TYPES:  kbtrg_netwr(16) TYPE c. " Netwr(16) of type Character
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms 3_L
TYPES:  incov LIKE vbkd-incov. "Incoterms v
TYPES:  yantlf(1) TYPE c. " Types: yantlf(1) of type Character
TYPES:  prsdt LIKE vbkd-prsdt. " Date for pricing and exchange rate
TYPES:  hprsfd LIKE tvap-prsfd. " Carry out pricing
TYPES:  bstkd_e LIKE vbkd-bstkd_e. " Ship-to Party's Purchase Order Number
TYPES:  bstdk_e LIKE vbkd-bstdk_e. " Ship-to party's PO date
TYPES:  bsark_e LIKE vbkd-bsark_e. " Ship-to party purchase order type
TYPES:  ihrez_e LIKE vbkd-ihrez_e. " Ship-to party character
TYPES:  posex_e LIKE vbkd-posex_e. " Item Number of the Underlying Purchase Order
TYPES:  lpnnr LIKE vbak-vbeln. " Sales Document
TYPES:  empst LIKE vbkd-empst. " Receiving point
TYPES:  ablad LIKE vbpa-ablad. " Unloading Point
TYPES:  knref LIKE vbpa-knref. " Customer description of partner (plant, storage location)
TYPES:  lpnnr_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  kdkg1 LIKE vbkd-kdkg1. " Customer condition group 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. " Customer condition group 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. " Customer condition group 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. " Customer condition group 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. " Customer condition group 5
TYPES:  abtnr LIKE vbkd-abtnr. " Department number
TYPES:  delco LIKE vbkd-delco. " Agreed delivery time
TYPES:  angbt LIKE vbak-vbeln. " Sales Document
TYPES:  angbt_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  contk LIKE vbak-vbeln. " Sales Document
TYPES:  contk_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  angbt_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  angbt_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order
TYPES:  contk_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  contk_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order

*- positionen ---------------------------------------------------------*
*- external config-id to set fcode 'POUP' on sub-item level ----*
TYPES:  config_id LIKE e1curef-config_id. " External Configuration ID (Temporary)
*- Instanznummer der Konfiguaration zum Setzen des FCODES 'POUP' bei --*
*- Unterpositionen ----------------------------------------------------*
*- instancenumber of the configuration to set fcode 'POUP' on sub-item *
*- level --------------------------------------------------------------*
TYPES:  inst_id LIKE e1curef-inst_id. " Instance Number in Configuration
TYPES:  kompp LIKE tvap-kompp. " Form delivery group and correlate BOM components
TYPES:  currdec LIKE tcurx-currdec. " Number of decimal places
TYPES:  curcy LIKE e1edp01-curcy. " Currency
TYPES:  valdt LIKE vbkd-valdt. " Fixed value date
TYPES:  valtg LIKE vbkd-valtg. " Additional value days
*- Flag  -------------------------------------------*
*- internal field additional ------------------------------------------*
TYPES:  vaddi(1) TYPE c. " Types: vaddi(1) of type Character
*- ARM Advanced Returns -----------------------------------------------*
TYPES: returns_reason     TYPE bezei40, " Description
       replace_request(1) TYPE c.       " Request(1) of type Character
TYPES: END OF lty_xvbap.

*** Local type declaration for item level fields
TYPES: BEGIN OF lty_item,
         posex     TYPE posex,      "Item Number
         mvgr1     TYPE mvgr1,      " Material Group 1
         mvgr3     TYPE mvgr3,      " Material Group 3
         zzpromo   TYPE zpromo,     " Promo Code
         zzartno   TYPE zartno,     " Article Number
         vbegdat   TYPE vbdat_veda, " Contract Start Date
         venddat   TYPE vndat_veda, " Contract End Date
         csd       TYPE zconstart,  " Content Start Date Override
         ced       TYPE zconend,    " Content End Date Override
         lsd       TYPE zlicstar,   " License Start Date Override
         led       TYPE zlicend,    " License End Date Override
* Begin of: CR#6142 KKR20180531  ED2K912174
         zzdealtyp TYPE zzdealtyp,  " PQ Deal type
         zzclustyp TYPE zzclustyp,  " Cluster type
* End of: CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
         zzcovryr  TYPE zzcovryr,   " Cover Year
         zzcovrmt  TYPE zzcovrmt,   " Cover Month
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
       END OF lty_item.

TYPES: BEGIN OF lty_item1,
         posex TYPE posex, " Item Number of the Underlying Purchase Order
         ihrez TYPE ihrez, " Your Reference
       END OF lty_item1.

TYPES: BEGIN OF lty_item_con,
         posex TYPE posex,     " Item Number of the Underlying Purchase Order
         csd   TYPE zconstart, " Content Start Date Override
         ced   TYPE zconend,   " Content End Date Override
*        lsd   TYPE ZLICSTAR,
*        led   TYPE ZLICEND,
       END OF lty_item_con.

TYPES: BEGIN OF lty_item_lis,
         posex TYPE posex,    " Item Number of the Underlying Purchase Order
         lsd   TYPE zlicstar, " License Start Date Override
         led   TYPE zlicend,  " License End Date Override
       END OF lty_item_lis.
***<--- Change by SAYANDAS

*** Local work area declaration
DATA: lst_bdcdata TYPE bdcdata, " Batch input: New table field structure
      lst_idoc    TYPE edidd,   " Data record (IDoc)
      lst_idoc12  TYPE edidd,   " Data record (IDoc)
      lst_xvbak   TYPE lty_xvbak,
      lst_e1edk03 TYPE e1edk03. " IDoc: Document header date segment

*** Local Data declaration
DATA: lv_line        TYPE sytabix, " Row Index of Internal Tables
      lv_stdt        TYPE char10,  " Stdt of type CHAR10
      lv_eddt        TYPE char10,  " Eddt of type CHAR10
      lv_tabix230    TYPE sytabix, " Row Index of Internal Tables
      lv_ihrez       TYPE ihrez,   " Your Reference
*** BOC BY SAYANDAS on 02-JAN-2018 for CR-741
      lv_vsnmr_v_230 TYPE vsnmr_v, " Sales Doc. Version Number
*** EOC BY SAYANDAS on 02-JAN-2018 for CR-741
      lv_test        TYPE sy-datum. " ABAP System Field: Current Date of Application Server
*** BOC by SAYANDAS--->>>
*** Local Data Declaration
DATA : lst_vbap          TYPE lty_xvbap,
       lst_vbap4         TYPE lty_xvbap,
       li_vbap           TYPE STANDARD TABLE OF lty_xvbap,
       lst_vbap10_230    TYPE lty_xvbap,
       lst_bdcdata9_230  TYPE bdcdata, " Batch input: New table field structure
       lst_bdcdata10_230 TYPE bdcdata, " Batch input: New table field structure
       lst_bdcdata11_230 TYPE bdcdata, " Batch input: New table field structure
       lv_tabix1_230     TYPE syindex, " Loop Index
       lst_item          TYPE lty_item,
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*       lst_item22        TYPE lty_item,
       lst_item22        TYPE ty_item,
       lv_qt_lines_230   TYPE syst_tabix, " ABAP System Field: Row Index of Internal Tables
       lst_qty_tabix_230 TYPE ty_qty_tabix_230,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
       lst_itemcon       TYPE lty_item_con,
       li_itemcon        TYPE STANDARD TABLE OF lty_item_con,
       lst_itemlis       TYPE lty_item_lis,
       li_itemlis        TYPE STANDARD TABLE OF lty_item_lis,
       lst_item1         TYPE lty_item1,
       li_item1          TYPE STANDARD TABLE OF lty_item1,
       li_bdcdata230     TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
       li_di_doc4        TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
       lst_di_doc4       TYPE edidd,                     " Data record (IDoc)
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*       i_item22          TYPE STANDARD TABLE OF lty_item,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
       li_item           TYPE STANDARD TABLE OF lty_item,
** Begin Of: CR6122 RTR20180806  ED2K912853
       lir_so            TYPE rjksd_vkbur_range_tab,
** End Of: CR6122 RTR20180806  ED2K912853
*-- BOC: ERPM 1392 GKAMMILI 27-Jan-20202  ED2K917394
       li_bdcdata_230_8  TYPE STANDARD TABLE OF bdcdata. " Batch input: New table field structure
*-- EOC: ERPM 1392 GKAMMILI 27-Jan-20202  ED2K917394
DATA: lst_z1qtc_e1edp01_01_8 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_8 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lst_e1edp02            TYPE e1edp02,          " IDoc: Document Item Reference Data
      lst_e1edp03            TYPE e1edp03,          " IDoc: Document Item Date Segment
      lst_e1edp01            TYPE e1edp01,          " IDoc: Document Item General Data
      lst_e1edka1_8          TYPE e1edka1,          " IDoc: Document Header Partner Information
      lst_e1edk14            TYPE e1edk14,  " IDoc Segment for Sales Office, PO Type CR#6122 KKR20180606  ED2K912174
*     Begin of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
      li_db_dates            TYPE ztqtc_db_bom_dates, " DB BOM - Contract Start Date
      lv_mem_name            TYPE char30,             " Memory ID Name
*     End   of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
      lv_pos2                TYPE char3,    " Pos of type CHAR3
      lv_val2                TYPE char6,    " Val of type CHAR6
      lv_selkz2              TYPE char19,   " Selkz of type CHAR19
      lv_fnamm               TYPE char10,   " Fnamm of type CHAR10
      lv_posex               TYPE posnr_va, " Sales Document Item
      lv_posex1              TYPE posnr_va, " Sales Document Item
      lv_posex2              TYPE posnr_va, " Sales Document Item
      lv_posex3              TYPE posnr_va, " Sales Document Item
      lv_mvgr1_8             TYPE mvgr1,    " Material group 1
      lv_mvgr3_8             TYPE mvgr3,    " Material group 3
      lv_1230                TYPE char1,    " 1230 of type CHAR1
      lv_ihrez_e2            TYPE ihrez_e,  " Ship-to party character
      lv_artno1              TYPE zartno,   " Article Number
      lv_zzpromo             TYPE zpromo,   " Promo code
      lv_promo_8             TYPE zpromo,   " Promo code
      lv_zzlicyr             TYPE zzlicyr,  " License Year CR#6142 KKR20180605  ED2K912174
      lv_vbegdat2            TYPE d,        " Vbegdat2 of type Date
      lv_venddat2            TYPE d,        " Venddat2 of type Date
*** for content and license date
      lv_psgnum              TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
      lv_csd                 TYPE d,          " Csd of type Date
      lv_ced                 TYPE d,          " Ced of type Date
      lv_csd1                TYPE dats,       " Field of type DATS
      lv_ced1                TYPE dats,       " Field of type DATS
      lv_lsd                 TYPE d,          " Lsd of type Date
      lv_led                 TYPE d,          " Led of type Date
      lv_lsd1                TYPE dats,       " Field of type DATS
      lv_led1                TYPE dats,       " Field of type DATS
      lv_zmeng_230           TYPE char13,     " Zmeng of type CHAR13
      lv_kwmeng_230          TYPE char15,     " Kwmeng of type CHAR15
*** Change for FKDAT
      lv_fkdat1_230          TYPE dats, " Field of type DATS
      lv_fkdat_230           TYPE d,    " Fkdat_230 of type Date

*** Begin Of: CR6122 RTR20180803  ED2K912853
*** Change for FKDAT (Billing Date under Billing Document tab at header level)
      lv_fkdat2_230          TYPE dats, " Field of type DATS
      lv_fkdat3_230          TYPE d,    " Fkdat_230 of type Date
      lv_docnum              TYPE edi_docnum,
*** End Of: CR6122 RTR20180803  ED2K912853
*** for content and license date
      lv_vbegdat3            TYPE dats, " Field of type DATS
      lv_venddat3            TYPE dats, " Field of type DATS
      lv_zzdealtyp           TYPE zzdealtyp, " PQ Deal type  CR#6142 KKR20180531  ED2K912174
      lv_zzclustyp           TYPE zzclustyp, " Cluster type  CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
      lv_zzcovryr            TYPE zzcovryr,   " Cover Year
      lv_zzcovrmt            TYPE zzcovrmt,   " Cover Month
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
      lv_so                  TYPE vkbur, " Sales Office         CR#6122 KKR20180606  ED2K912174
      lv_po_type             TYPE bsark, " Purchase order type  CR#6122 KKR20180606  ED2K912174
      lrt_param2             TYPE RANGE OF rvari_vnam, " For both CR#6122 & CR#6142 KKR20180611  ED2K912174
      lrs_param2             LIKE LINE OF lrt_param2,  " For both CR#6122 & CR#6142 KKR20180611  ED2K912174
      lrt_param1             TYPE RANGE OF rvari_vnam, " For both CR#6122 & CR#6142 KKR20180611  ED2K912174
      lrs_param1             LIKE LINE OF lrt_param1,  " For both CR#6122 & CR#6142 KKR20180611  ED2K912174
*** BOC: CR#6310 KKRAVURI20181122  ED2K913920
      lst_z1qtc_e1edka1_01   TYPE z1qtc_e1edka1_01,
      lv_smtp_adr            TYPE ad_smtpadr,
      lv_loop_count          TYPE numc3,
      lv_co_name             TYPE ad_name_co,
      lv_co_name_we          TYPE ad_name_co,      " ++by NPOLINA OTCM-54171 ED2K926194 20220322 for WE-Shipto Name_CO
      lv_kpar_sub_tabix      TYPE sy-tabix,
      lv_kpar_sub_tabix_we   TYPE sy-tabix,        " ++by NPOLINA/BSAKI OTCM-54171 ED2K926194 20220322 for WE-Shipto Name_CO
      lv_papo_flag           TYPE abap_bool,
      lv_papo_tabix          TYPE sy-tabix,
      lv_re_flag             TYPE abap_bool,
      lv_re_tabix            TYPE sy-tabix,
      lv_psde_flag           TYPE abap_bool,
      lv_psde_tabix          TYPE sy-tabix,
      lv_5000_flag           TYPE abap_bool,
      lv_5000_tabix          TYPE sy-tabix,
      li_bdcdata_6310        TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0,
*** EOC: CR#6310 KKRAVURI20181122  ED2K913920
*** BOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
      lv_we_flag             TYPE abap_bool,
      lv_we_tabix            TYPE sy-tabix,
      lv_psde_flag2          TYPE abap_bool,
      lv_psde_tabix2         TYPE sy-tabix,
      lv_5000_flag2          TYPE abap_bool,
      lv_5000_tabix2         TYPE sy-tabix.
*** EOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_0230> TYPE bdcdata. " Batch input: New table field structure
***<<<--- EOC by SAYANDAS

***Local Constant Declaration
CONSTANTS: lc_e1edk03_1                   TYPE char7  VALUE 'E1EDK03',          " E1edk03_1 of type CHAR7
           lc_z1qtc_e1edp01_01_8          TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_8 of type CHAR16
           lc_z1qtc_e1edk01_01_8          TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_8 of type CHAR16
           lc_e1edp02_8                   TYPE char7 VALUE 'E1EDP02',           " E1edp02_8 of type CHAR7
           lc_e1edp03_8                   TYPE char7 VALUE 'E1EDP03',           " E1edp03_8 of type CHAR7
           lc_e1edka1_8                   TYPE char7 VALUE 'E1EDKA1',           " E1edka1_8 of type CHAR7
           lc_e1edk14                     TYPE char7 VALUE 'E1EDK14',           " CR#6122 KKR20180606  ED2K912174
           lc_we_8                        TYPE parvw VALUE 'WE',                " Partner Function: Ship-to party
           lc_csd                         TYPE edi_iddat  VALUE 'CSD',          " Qualifier for IDOC date segment
           lc_ced                         TYPE edi_iddat  VALUE 'CED',          " Qualifier for IDOC date segment
           lc_lsd                         TYPE edi_iddat  VALUE 'LSD',          " Qualifier for IDOC date segment
           lc_led                         TYPE edi_iddat  VALUE 'LED',          " Qualifier for IDOC date segment
*** Change for FKDAT
           lc_016                         TYPE edi_iddat  VALUE '016', " Qualifier for IDOC date segment
*** Change for FKDAT
           lc_019                         TYPE edi_iddat  VALUE '019', " Qualifier for IDOC date segment
           lc_020                         TYPE edi_iddat  VALUE '020', " Qualifier for IDOC date segment
* Begin Of CR#6122 KKR20180606  ED2K912174
           lc_026                         TYPE edi_iddat  VALUE '026',  " Qualifier for Billing Date, RTR20180731  ED2K912853
           lc_devid_i0230                 TYPE zdevid     VALUE 'I0230',
           lc_param2_so_i0230             TYPE rvari_vnam VALUE 'VKBUR',
           lc_param1_so_i0230             TYPE rvari_vnam VALUE 'SALES_OFFICE',
           lc_param1_potyp_i0230          TYPE rvari_vnam VALUE 'PO_TYPE',
           lc_param2_potyp_i0230          TYPE rvari_vnam VALUE 'BSARK',
           lc_var_key_bill_date_i0230     TYPE zvar_key   VALUE 'BILLING_DATE',
* End Of CR#6122 KKR20180606  ED2K912174
* Begin Of CR#6142 KKR20180605  ED2K912174
           lc_param1_ly_i0230             TYPE rvari_vnam VALUE 'LICENSE_YEAR',
           lc_param2_zly_i0230            TYPE rvari_vnam VALUE 'ZZLICYR',
           lc_var_key_dealclus_type_i0230 TYPE zvar_key   VALUE 'PQ_DEAL_CLUSTER_TYPE',
           lc_var_key_license_year_i0230  TYPE zvar_key   VALUE 'LICENSE_YEAR',
* End Of CR#6142 KKR20180605  ED2K912174
* BOC: CR6310 KKRAVURI20181122  ED2K913920
           lc_z1qtc_e1edka1_01            TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
           lc_re                          TYPE parvw      VALUE 'RE',           " Partner Function: Bill-to party
           lc_varkey_name_co_i0230        TYPE zvar_key   VALUE 'NAME_CO',
* EOC: CR6310 KKRAVURI20181122  ED2K913920
* BOC: ERPM 1392 GKAMMILI 27-Jan-20202  ED2K917394
           lc_okcode                      TYPE fnam_____4 VALUE 'BDC_OKCODE'. " Field name for OK_CODE
* EOC: ERPM 1392 GKAMMILI 27-Jan-20202  ED2K917394

*** Changing BDCDATA table to change contract start date and contract end date

DESCRIBE TABLE dxbdcdata LINES lv_line.
READ TABLE didoc_data INTO lst_idoc INDEX 1.
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.

*** Begin of CR#6142, CR#6122 KKR20180611  ED2K912174
* To check if the CR#6142, CR#6122 needs to be triggered
IF igt_enh_ctrl[] IS INITIAL.
  REFRESH lrt_param2.
  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_var_key_dealclus_type_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_var_key_license_year_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_var_key_bill_date_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

* BOC: CR6310 KKRAVURI20181122  ED2K913920
  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_varkey_name_co_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.
* EOC: CR6310 KKRAVURI20181122  ED2K913920

  SELECT wricef_id, ser_num, var_key, active_flag
         FROM zca_enh_ctrl INTO TABLE @igt_enh_ctrl
         WHERE wricef_id = @lc_wricef_id_i0230 AND
               var_key IN @lrt_param2.
  IF igt_enh_ctrl[] IS NOT INITIAL.
    DATA(lis_dealclus_type) = igt_enh_ctrl[ wricef_id = lc_wricef_id_i0230 var_key = lc_var_key_dealclus_type_i0230 ].
    igv_aflag_dealclus_type_i0230 = lis_dealclus_type-active_flag.
    DATA(lis_license_year) = igt_enh_ctrl[ wricef_id = lc_wricef_id_i0230 var_key = lc_var_key_license_year_i0230 ].
    igv_actv_flag_lic_year_i0230 = lis_license_year-active_flag.
    DATA(lis_bill_date) = igt_enh_ctrl[ wricef_id = lc_wricef_id_i0230 var_key = lc_var_key_bill_date_i0230 ].
    igv_actv_flag_bill_date_i0230 = lis_bill_date-active_flag.
* BOC: CR6310 KKRAVURI20181122  ED2K913920
    DATA(lis_name_co) = igt_enh_ctrl[ wricef_id = lc_wricef_id_i0230 var_key = lc_varkey_name_co_i0230 ].
    v_actv_flag_name_co_i0230 = lis_name_co-active_flag.
* EOC: CR6310 KKRAVURI20181122  ED2K913920
  ENDIF. " IF igt_enh_ctrl[] IS NOT INITIAL.
ENDIF. " IF igt_enh_ctrl[] IS INITIAL.
*** End of CR#6142, CR#6122 KKR20180611  ED2K912174

*** Begin of CR#6142, CR#6122 KKR20180611  ED2K912174
*** Fetching the constant values from table: zcaconstant
IF igt_zcaconstant[] IS INITIAL.
  REFRESH: lrt_param1, lrt_param2.
  lrs_param1-sign   = 'I'.
  lrs_param1-option = 'EQ'.
  lrs_param1-low    = lc_param1_so_i0230.
  APPEND lrs_param1 TO lrt_param1.
  CLEAR lrs_param1.

  lrs_param1-sign   = 'I'.
  lrs_param1-option = 'EQ'.
  lrs_param1-low    = lc_param1_potyp_i0230.
  APPEND lrs_param1 TO lrt_param1.
  CLEAR lrs_param1.

  lrs_param1-sign   = 'I'.
  lrs_param1-option = 'EQ'.
  lrs_param1-low    = lc_param1_ly_i0230.
  APPEND lrs_param1 TO lrt_param1.
  CLEAR lrs_param1.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_param2_so_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_param2_potyp_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_param2_zly_i0230.
  APPEND lrs_param2 TO lrt_param2.
  CLEAR lrs_param2.

  SELECT devid, param1, param2, srno, sign, opti, low, high   " RTR CR6122 20180731  ED2K912853
         FROM zcaconstant INTO TABLE @igt_zcaconstant         " Fetching Sign, Option and High to validate Sales Office
         WHERE devid = @lc_devid_i0230 AND
               param1 IN @lrt_param1 AND
               param2 IN @lrt_param2 AND
               activate = @abap_true.
ENDIF.  " IF igt_zcaconstant[] IS INITIAL
*** End of CR#6142, CR#6122 KKR20180611  ED2K912174

* BOC for BOM Material *
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
IF i_item22 IS INITIAL.
  li_di_doc4[] = didoc_data[].
  DELETE li_di_doc4 WHERE segnam NE lc_z1qtc_e1edp01_01_8.
  LOOP AT li_di_doc4 INTO lst_di_doc4.
    CLEAR: lst_z1qtc_e1edp01_01_8,
           lv_vbegdat3, lv_venddat3,
           lv_vbegdat2, lv_venddat2.
    lst_z1qtc_e1edp01_01_8 = lst_di_doc4-sdata.
    lv_posex = lst_z1qtc_e1edp01_01_8-vposn.
*    lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
    lv_zzpromo          = lst_z1qtc_e1edp01_01_8-zzpromo.
    lv_zzdealtyp        = lst_z1qtc_e1edp01_01_8-zzdealtyp.  " CR#6142 KKR20180531  ED2K912174
    lv_zzclustyp        = lst_z1qtc_e1edp01_01_8-zzclustyp.  " CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
    lv_zzcovryr         = lst_z1qtc_e1edp01_01_8-zzcovryr.   " Cover Year
    lv_zzcovrmt         = lst_z1qtc_e1edp01_01_8-zzcovrmt.   " Cover Month
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
    lv_artno1           = lst_z1qtc_e1edp01_01_8-zzartno.
    lv_vbegdat3         = lst_z1qtc_e1edp01_01_8-vbegdat. " Contract Strat Date
    lv_venddat3         = lst_z1qtc_e1edp01_01_8-venddat. " Contract End Date
    WRITE lv_vbegdat3 TO lv_vbegdat2.
    WRITE lv_venddat3 TO lv_venddat2.

    lv_csd1            = lst_z1qtc_e1edp01_01_8-zzcontent_start_d.
    lv_ced1            = lst_z1qtc_e1edp01_01_8-zzcontent_end_d.
    lv_lsd1            = lst_z1qtc_e1edp01_01_8-zzlicense_start_d.
    lv_led1            = lst_z1qtc_e1edp01_01_8-zzlicense_end_d.

    WRITE lv_csd1 TO lv_csd.
    WRITE lv_ced1 TO lv_ced.
    WRITE lv_lsd1 TO lv_lsd.
    WRITE lv_led1 TO lv_led.

    IF lv_posex IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_posex
        IMPORTING
          output = lv_posex.

      lst_item22-posex = lv_posex.
      lst_item22-vbegdat = lv_vbegdat2.
      lst_item22-venddat = lv_venddat2.
      lst_item22-zzpromo = lv_zzpromo.
      lst_item22-zzdealtyp = lv_zzdealtyp.  " CR#6142 KKR20180531  ED2K912174
      lst_item22-zzclustyp = lv_zzclustyp.  " CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
      lst_item22-zzcovryr = lv_zzcovryr.
      lst_item22-zzcovrmt = lv_zzcovrmt.
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
      lst_item22-zzartno = lv_artno1.
      lst_item22-csd     = lv_csd.
      lst_item22-ced     = lv_ced.
      lst_item22-lsd     = lv_lsd.
      lst_item22-led     = lv_led.
*     Begin of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
      lst_item22-st_date = lst_z1qtc_e1edp01_01_8-vbegdat. " Contract Strat Date
*     End   of ADD:CR#607:WROY:08-DEC-2017:ED2K908513

      APPEND lst_item22 TO i_item22.
      CLEAR: lst_item22, lv_posex,
             lv_vbegdat2, lv_venddat2.
    ENDIF. " IF lv_posex IS NOT INITIAL
  ENDLOOP. " LOOP AT li_di_doc4 INTO lst_di_doc4

  SORT i_item22 BY posex.
  DELETE ADJACENT DUPLICATES FROM i_item22.
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
ENDIF. " IF i_item22 IS INITIAL
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888

lst_vbap4 = dxvbap.

IF lst_vbap4-kdmat IS INITIAL.
  lv_fnamm = 'VBAP-POSEX'.
ELSE. " ELSE -> IF lst_vbap4-kdmat IS INITIAL
  lv_fnamm = 'VBAP-KDMAT'.
ENDIF. " IF lst_vbap4-kdmat IS INITIAL

IF lst_bdcdata-fnam+0(10) = lv_fnamm.
  lv_pos2 = lst_bdcdata-fnam+10(3).

  READ TABLE i_item22 INTO lst_item22 WITH KEY posex = lst_vbap4-posex.
  IF sy-subrc = 0.

    IF lst_item22 IS NOT INITIAL.
* Begin of Insert by PBANDLAPAL on 20-Nov-2017: ED2K909381
      IF ( lst_item22-vbegdat IS NOT INITIAL AND lst_item22-vbegdat NE space ) OR
         ( lst_item22-csd IS NOT INITIAL AND lst_item22-csd NE space ) OR
         ( lst_item22-ced IS NOT INITIAL AND lst_item22-ced NE space ) OR
         ( lst_item22-lsd IS NOT INITIAL AND lst_item22-lsd NE space ) OR
         ( lst_item22-led IS NOT INITIAL AND lst_item22-led NE space ) OR
         lst_item22-zzpromo IS NOT INITIAL OR
         lst_item22-zzartno IS NOT INITIAL OR
         lst_item22-zzdealtyp IS NOT INITIAL OR  " CR#6142 KKR20180531  ED2K912174
         lst_item22-zzclustyp IS NOT INITIAL OR  " CR#6142 KKR20180531  ED2K912174
* End of Insert by PBANDLAPAL on 20-Nov-2017: ED2K909381
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
         lst_item22-zzcovryr IS NOT INITIAL OR
         lst_item22-zzcovrmt IS NOT INITIAL.
* EOC: CR#7480 KKRAVURI20181026  ED2K913701

* Begin of Insert by PBANDLAPAL on 10-Jul-2017 for ERP-2772

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata. " Appending Screen

*     IF lst_item22-vbegdat IS NOT INITIAL.
        IF lst_item22-vbegdat IS NOT INITIAL AND lst_item22-vbegdat NE space.
*         Begin of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
*         Prepare the Memory ID Name
          CONCATENATE lst_idoc-docnum
                      '_DB_BOM_DATES'
                 INTO lv_mem_name.
*         Get the DB BOM - Contract Start Dates from Memory ID
          IMPORT li_db_dates FROM MEMORY ID lv_mem_name.
          READ TABLE li_db_dates INTO DATA(lst_db_date)
               WITH KEY posex = lst_vbap4-posex
               BINARY SEARCH.
          IF sy-subrc NE 0.
            lst_db_date-posex   = lst_vbap4-posex.
            lst_db_date-vbegdat = lst_item22-st_date.
            INSERT lst_db_date INTO TABLE li_db_dates.

            EXPORT li_db_dates TO MEMORY ID lv_mem_name.
          ENDIF. " IF sy-subrc NE 0
*         End   of ADD:CR#607:WROY:08-DEC-2017:ED2K908513

          CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = lv_selkz2.
          lst_bdcdata-fval = 'X'.
          APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
* End of Insert by PBANDLAPAL on 10-Jul-2017 for ERP-2772
          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_OKCODE'.
          lst_bdcdata-fval = '=PVER'.
          APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

          CLEAR lst_bdcdata.
          lst_bdcdata-program = 'SAPLV45W'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO dxbdcdata. " Appending Screen

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
          lst_bdcdata-fval = lst_item22-vbegdat.
          APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract Start Date

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VENDDAT'.
          lst_bdcdata-fval = lst_item22-venddat.
          APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract End Date

* Begin of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772
          IF lst_item22-venddat IS NOT INITIAL AND lst_item22-venddat NE space.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VEDA-VENDREG'.
            lst_bdcdata-fval = space.
            APPEND  lst_bdcdata TO dxbdcdata. " Appending Rule for Contract End Date
          ENDIF. " IF lst_item22-venddat IS NOT INITIAL AND lst_item22-venddat NE space
          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_OKCODE'.
          lst_bdcdata-fval = '/EBACK'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO dxbdcdata.
* End of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772
        ENDIF. " IF lst_item22-vbegdat IS NOT INITIAL AND lst_item22-vbegdat NE space

* Begin of Insert by PBANDLAPAL on 20-Nov-2017: ED2K909381
        IF ( lst_item22-csd IS NOT INITIAL AND lst_item22-csd NE space ) OR
         ( lst_item22-ced IS NOT INITIAL AND lst_item22-ced NE space ) OR
         ( lst_item22-lsd IS NOT INITIAL AND lst_item22-lsd NE space ) OR
         ( lst_item22-led IS NOT INITIAL AND lst_item22-led NE space ) OR
         lst_item22-zzpromo IS NOT INITIAL OR
         lst_item22-zzartno IS NOT INITIAL OR
         lst_item22-zzdealtyp IS NOT INITIAL OR    " CR#6142 KKR20180531  ED2K912174
         lst_item22-zzclustyp IS NOT INITIAL OR    " CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
         lst_item22-zzcovryr IS NOT INITIAL OR
         lst_item22-zzcovrmt IS NOT INITIAL.
* EOC: CR#7480 KKRAVURI20181026  ED2K913701

          CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = lv_selkz2.
          lst_bdcdata-fval = 'X'.
          APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

          CLEAR: lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_OKCODE'.
          lst_bdcdata-fval = '=PZKU'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4003'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO dxbdcdata.
* End of Insert by PBANDLAPAL on 20-Nov-2017 : ED2K909381

          IF lst_item22-zzpromo IS NOT INITIAL.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZPROMO'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZPROMO'.
            lst_bdcdata-fval = lst_item22-zzpromo.
            APPEND lst_bdcdata TO dxbdcdata.

          ENDIF. " IF lst_item22-zzpromo IS NOT INITIAL

*** Begin of: CR#6142 KKR20180531  ED2K912174
*** Adding of two new fileds ZZDEALTYP, ZZCLUSTYP to BDC
          IF igv_aflag_dealclus_type_i0230 = abap_true.  " Check if the CR#6142 needs to be triggered
            IF lst_item22-zzdealtyp IS NOT INITIAL.
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_CURSOR'.
              lst_bdcdata-fval = 'VBAP-ZZDEALTYP'.
              APPEND lst_bdcdata TO dxbdcdata.
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'VBAP-ZZDEALTYP'.
              lst_bdcdata-fval = lst_item22-zzdealtyp.
              APPEND lst_bdcdata TO dxbdcdata.
              CLEAR lst_bdcdata.
            ENDIF. " IF lst_item22-ZZDEALTYP IS NOT INITIAL

            IF lst_item22-zzclustyp IS NOT INITIAL.
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_CURSOR'.
              lst_bdcdata-fval = 'VBAP-ZZCLUSTYP'.
              APPEND lst_bdcdata TO dxbdcdata.
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'VBAP-ZZCLUSTYP'.
              lst_bdcdata-fval = lst_item22-zzclustyp.
              APPEND lst_bdcdata TO dxbdcdata.
              CLEAR lst_bdcdata.
            ENDIF. " IF lst_item22-ZZCLUSTYP IS NOT INITIAL
          ENDIF. " IF igv_aflag_dealclus_type_i0230 = abap_true.
*** End of: CR#6142 KKR20180531  ED2K912174

*** BOC: CR#7480 KKRAVURI20181026  ED2K913701
          " Adding of two new fileds ZZCOVRYR, ZZCOVRMT to BDC
          IF lst_item22-zzcovryr IS NOT INITIAL.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZCOVRYR'.
            APPEND lst_bdcdata TO dxbdcdata.
            CLEAR lst_bdcdata.

            lst_bdcdata-fnam = 'VBAP-ZZCOVRYR'.
            lst_bdcdata-fval = lst_item22-zzcovryr.
            APPEND lst_bdcdata TO dxbdcdata.
            CLEAR lst_bdcdata.
          ENDIF. " IF lst_item22-ZZCOVRYR IS NOT INITIAL

          IF lst_item22-zzcovrmt IS NOT INITIAL.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZCOVRMT'.
            APPEND lst_bdcdata TO dxbdcdata.
            CLEAR lst_bdcdata.

            lst_bdcdata-fnam = 'VBAP-ZZCOVRMT'.
            lst_bdcdata-fval = lst_item22-zzcovrmt.
            APPEND lst_bdcdata TO dxbdcdata.
            CLEAR lst_bdcdata.
          ENDIF. " IF lst_item22-ZZCOVRMT IS NOT INITIAL
*** EOC: CR#7480 KKRAVURI20181026  ED2K913701

          IF lst_item22-zzartno IS NOT INITIAL.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZARTNO'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZARTNO'.
            lst_bdcdata-fval = lst_item22-zzartno.
            APPEND lst_bdcdata TO dxbdcdata.
          ENDIF. " IF lst_item22-zzartno IS NOT INITIAL

          IF lst_item22-csd IS NOT INITIAL AND lst_item22-csd NE space.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZCONSTART'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZCONSTART'.
            lst_bdcdata-fval = lst_item22-csd.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZCONEND'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZCONEND'.
            lst_bdcdata-fval = lst_item22-ced.
            APPEND lst_bdcdata TO dxbdcdata.
          ENDIF. " IF lst_item22-csd IS NOT INITIAL AND lst_item22-csd NE space

          IF lst_item22-lsd IS NOT INITIAL AND lst_item22-lsd NE space.
            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZLICSTART'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZLICSTART'.
            lst_bdcdata-fval = lst_item22-lsd.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_CURSOR'.
            lst_bdcdata-fval = 'VBAP-ZZLICEND'.
            APPEND lst_bdcdata TO dxbdcdata.

            CLEAR lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-ZZLICEND'.
            lst_bdcdata-fval = lst_item22-led.
            APPEND lst_bdcdata TO dxbdcdata.

          ENDIF. " IF lst_item22-lsd IS NOT INITIAL AND lst_item22-lsd NE space

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_OKCODE'.
          lst_bdcdata-fval = '/EBACK'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO dxbdcdata.
        ENDIF. " IF ( lst_item22-csd IS NOT INITIAL AND lst_item22-csd NE space ) OR
      ENDIF. " IF ( lst_item22-vbegdat IS NOT INITIAL AND lst_item22-vbegdat NE space ) OR
    ENDIF. " IF lst_item22 IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lst_bdcdata-fnam+0(10) = lv_fnamm
* EOC for BOM Material*

*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.
IF sy-subrc IS INITIAL.
*    IF lst_bdcdata-fnam = 'RV45A-DOCNUM'
*      AND lst_bdcdata-fval = lst_idoc-docnum.
  IF lst_bdcdata-fnam = 'BDC_OKCODE' AND
     lst_bdcdata-fval = 'SICH'.
    CLEAR lst_idoc.
*** Loop at IDOC DATA if segment is E1EDK03 Date segment
*    LOOP AT didoc_data INTO lst_idoc WHERE segnam =  lc_e1edk03_1.
    LOOP AT didoc_data INTO lst_idoc.
      CASE lst_idoc-segnam.
        WHEN lc_e1edk03_1.
*** Putting the idoc data in a local work area
          lst_e1edk03 = lst_idoc-sdata.

          IF lst_e1edk03-iddat = lc_019.
***     Qualifier for IDOC date segment is '019' then
***     we are putting IDOC: Date in local variable.

            WRITE lst_e1edk03-datum TO lv_test.
            WRITE lv_test TO lv_stdt. " lv_stdt is used for contract start date

          ELSEIF lst_e1edk03-iddat = lc_020.
***     Qualifier for IDOC date segment is '020' then
***     we are putting IDOC: Date in local variable.

            CLEAR lv_test.
            WRITE lst_e1edk03-datum TO lv_test.
            WRITE lv_test TO lv_eddt. " lv_eddt is used for contract end date
**** Change for FKDAT
          ELSEIF lst_e1edk03-iddat = lc_016.

            lv_fkdat1_230 = lst_e1edk03-datum.
            WRITE lv_fkdat1_230 TO lv_fkdat_230.
*** Begin of: CR#6122 RTR20180731  ED2K912853
*** Change for FKDAT (Billing Date under Billing Document at Header level)
          ELSEIF lst_e1edk03-iddat = lc_026.
            CONDENSE lst_e1edk03-datum NO-GAPS.
            DATA(liv_len) = strlen( lst_e1edk03-datum ).
            IF liv_len = 8.
              lv_fkdat2_230 = lst_e1edk03-datum.
              IF lv_fkdat2_230 >= sy-datum.
                WRITE lv_fkdat2_230 TO lv_fkdat3_230.
              ENDIF.
            ENDIF.

          ENDIF. " IF lst_e1edk03-iddat = lc_019
          CLEAR: lst_e1edk03, lst_idoc. " Clearing local work area
***<<<
        WHEN lc_z1qtc_e1edp01_01_8.
          CLEAR: lst_z1qtc_e1edp01_01_8, lv_artno1,
                 lv_mvgr1_8, lv_mvgr3_8, lv_zzpromo,
                 lv_zzdealtyp, lv_zzclustyp, " CR#6142 KKR20180531  ED2K912174
                 lv_zzcovryr, lv_zzcovrmt.   " ADD:CR#7480 KKRAVURI20181026  ED2K913701

          lst_z1qtc_e1edp01_01_8 = lst_idoc-sdata.
          lv_posex = lst_z1qtc_e1edp01_01_8-vposn.
          lv_mvgr1_8 = lst_z1qtc_e1edp01_01_8-mvgr1.
          lv_mvgr3_8 = lst_z1qtc_e1edp01_01_8-mvgr3.
          lv_zzpromo = lst_z1qtc_e1edp01_01_8-zzpromo.
          lv_zzdealtyp = lst_z1qtc_e1edp01_01_8-zzdealtyp.  " CR#6142 KKR20180531  ED2K912174
          lv_zzclustyp = lst_z1qtc_e1edp01_01_8-zzclustyp.  " CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
          lv_zzcovryr = lst_z1qtc_e1edp01_01_8-zzcovryr.
          lv_zzcovrmt = lst_z1qtc_e1edp01_01_8-zzcovrmt.
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
          lv_artno1  = lst_z1qtc_e1edp01_01_8-zzartno.
          lv_vbegdat3  = lst_z1qtc_e1edp01_01_8-vbegdat.
          lv_venddat3  = lst_z1qtc_e1edp01_01_8-venddat.
          WRITE lv_vbegdat3 TO lv_vbegdat2.
          WRITE lv_venddat3 TO lv_venddat2.

        WHEN lc_e1edka1_8.
          lst_e1edka1_8 = lst_idoc-sdata.
          IF lst_e1edka1_8-parvw = lc_we_8.
            lv_ihrez_e2 = lst_e1edka1_8-ihrez.
          ENDIF. " IF lst_e1edka1_8-parvw = lc_we_8
*** BOC: CR#6310 KKRAVURI20181122  ED2K913920
          IF lst_e1edka1_8-parvw = lc_re OR lst_e1edka1_8-parvw = lc_we_8. " ++ by NPOLINA ED2K926194
            READ TABLE didoc_data INTO DATA(lst_idoc_6310) WITH KEY
                                  segnam = lc_z1qtc_e1edka1_01 psgnum = lst_idoc-segnum.
            IF sy-subrc = 0.
              lst_z1qtc_e1edka1_01 = lst_idoc_6310-sdata.
*** BOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
              IF lst_e1edka1_8-parvw = lc_re.
*** BOC: OTCM-54171 by MRAJKUMAR ED2K926194 20220501 for WE-Shipto Name_CO
                REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]'
                  IN lst_z1qtc_e1edka1_01-name_co WITH | |.
                    lv_co_name = lst_z1qtc_e1edka1_01-name_co.
*** EOC: OTCM-54171 by MRAJKUMAR ED2K926194 20220501 for WE-Shipto Name_CO
              ENDIF.
              IF lst_e1edka1_8-parvw = lc_we_8.
*** BOC: OTCM-54171 by MRAJKUMAR ED2K926194 20220501 for WE-Shipto Name_CO
                REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]'
                  IN lst_z1qtc_e1edka1_01-name_co WITH | |.
                    lv_co_name_we = lst_z1qtc_e1edka1_01-name_co.
*** EOC: OTCM-54171 by MRAJKUMAR ED2K926194 20220501 for WE-Shipto Name_CO
              ENDIF.
*** EOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
              lv_smtp_adr = lst_z1qtc_e1edka1_01-smtp_addr.
              CLEAR lst_idoc_6310.
            ENDIF.
          ENDIF.
*** EOC: CR#6310 KKRAVURI20181122  ED2K913920
********* code for IHREZ
        WHEN lc_e1edp02_8.
          CLEAR: lst_e1edp02.
          lst_e1edp02 = lst_idoc-sdata.
          IF lst_e1edp02-qualf = '001'.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex1 = lst_e1edp01-posex.
              lv_ihrez = lst_e1edp02-ihrez.
            ENDIF. " IF sy-subrc = 0
            CLEAR: lst_e1edp01, lst_idoc12,lv_psgnum.
          ENDIF. " IF lst_e1edp02-qualf = '001'

***** code for content start date and end date
        WHEN lc_z1qtc_e1edk01_01_8.
          CLEAR: lst_z1qtc_e1edk01_01_8, lv_promo_8, lv_zzlicyr.
          lst_z1qtc_e1edk01_01_8 = lst_idoc-sdata.
          lv_promo_8 = lst_z1qtc_e1edk01_01_8-zzpromo.
          lv_zzlicyr = lst_z1qtc_e1edk01_01_8-zzlicyr. " CR#6142 KKR20180605  ED2K912174
*** BOC BY SAYANDAS on 02-JAN-2018 for CR-741
          lv_vsnmr_v_230 = lst_z1qtc_e1edk01_01_8-vsnmr_v.
*** BOC BY SAYANDAS on 02-JAN-2018 for CR-741
*** BOC: ERPM-1392 KKRAVURI 17-JULY-2020  ED2K918929
          IF lst_z1qtc_e1edk01_01_8-aunum IS NOT INITIAL AND
             lst_z1qtc_e1edk01_01_8-autwr IS NOT INITIAL.
            READ TABLE dxbdcdata WITH KEY fnam+0(14) = 'CCDATE-EXDATBI' TRANSPORTING NO FIELDS.
            IF sy-subrc EQ 0.
              lv_tabix230 = sy-tabix.
              " Build Itab with BDC Mapping
              li_bdcdata_230_8 = VALUE #(
                  ( program  = 'SAPLV60F' dynpro = '4001' dynbegin = abap_true )
                  ( fnam     = lc_okcode  fval   = '/00' )
                  ( program  = 'SAPLV60F' dynpro = '4001' dynbegin = abap_true )
                  ( fnam     = lc_okcode  fval   = '=CCMA' )
                  ( program  = 'SAPLV60F' dynpro = '0200' dynbegin = abap_true )
                  ( fnam     = 'FPLTC-AUNUM' fval = lst_z1qtc_e1edk01_01_8-aunum )          " Auth. Number
                  ( fnam     = 'FPLTC-AUTRA' fval = lst_z1qtc_e1edk01_01_8-auth_order_id )  " Auth. Refer Code
                  ( fnam     = 'FPLTC-AUTWR' fval = lst_z1qtc_e1edk01_01_8-autwr )          " Auth. Amount
                  ( fnam     = lc_okcode  fval = '=BACK' )
                  ( program  = 'SAPLV60F' dynpro = '4001' dynbegin = abap_true ) ).

              lv_tabix230 = lv_tabix230 + 1.
              INSERT LINES OF li_bdcdata_230_8 INTO dxbdcdata INDEX lv_tabix230.
              CLEAR: li_bdcdata_230_8[], lv_tabix230.
            ENDIF. "if sy-subrc EQ 0
          ENDIF. " IF lst_z1qtc_e1edk01_01_8-aunum IS NOT INITIAL AND ...
*** EOC: ERPM-1392 KKRAVURI 17-JULY-2020  ED2K918929
      ENDCASE.
*** Begin of: code for ihrez
* BOC by PBANDLAPAL on 08-Nov-2017
*      IF lv_posex1 IS NOT INITIAL.
      IF lv_posex1 IS NOT INITIAL AND lv_ihrez IS NOT INITIAL.
* EOC by PBANDLAPAL on 08-Nov-2017
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex1
          IMPORTING
            output = lv_posex1.

        lst_item1-posex = lv_posex1.
        lst_item1-ihrez = lv_ihrez.
        APPEND lst_item1 TO li_item1.

        CLEAR: lst_item1,
               lv_posex1,
               lv_ihrez.

      ENDIF. " IF lv_posex1 IS NOT INITIAL AND lv_ihrez IS NOT INITIAL
*** End of: code for ihrez

      IF lv_posex IS NOT INITIAL.
        lst_item-posex = lv_posex.
        lst_item-mvgr1 = lv_mvgr1_8.
        lst_item-mvgr3 = lv_mvgr3_8.
        lst_item-zzpromo = lv_zzpromo.
        lst_item-zzdealtyp = lv_zzdealtyp.   " CR#6142 KKR20180531  ED2K912174
        lst_item-zzclustyp = lv_zzclustyp.   " CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
        lst_item-zzcovryr = lv_zzcovryr.
        lst_item-zzcovrmt = lv_zzcovrmt.
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
        lst_item-zzartno = lv_artno1.
        lst_item-vbegdat = lv_vbegdat2.
        lst_item-venddat = lv_venddat2.
        APPEND lst_item TO li_item.
        CLEAR: lst_item, lv_posex,
               lv_mvgr1_8,lv_mvgr3_8,lv_zzpromo,
               lv_zzdealtyp, lv_zzclustyp,   " CR#6142 KKR20180531  ED2K912174
               lv_vbegdat2, lv_venddat2,
               lv_zzcovryr, lv_zzcovrmt.     " CR#7480 KKRAVURI20181026  ED2K913701
      ENDIF. " IF lv_posex IS NOT INITIAL
      CLEAR lst_idoc.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc

* Begin of Insert by PBANDLAPAL on 20-Nov-2017: ED2K909381
    IF lv_stdt IS NOT INITIAL OR
       lv_promo_8 IS NOT INITIAL OR
       lv_fkdat_230 IS NOT INITIAL OR
       lv_fkdat3_230 IS NOT INITIAL OR  " CR#6122 RTR20180731  ED2K912853
       lv_zzlicyr IS NOT INITIAL OR     " CR#6142 KKR20180605  ED2K912174
*** BOC BY SAYANDAS on 02-JAN-2018 for CR-741
       lv_vsnmr_v_230 IS NOT INITIAL OR
*** EOC BY SAYANDAS on 02-JAN-2018 for CR-741
       lv_ihrez_e2 IS NOT INITIAL OR
* BOC: CR#6310 KKRAVURI20181122  ED2K913920
       lv_co_name IS NOT INITIAL OR
       lv_smtp_adr IS NOT INITIAL.
* EOC: CR#6310 KKRAVURI20181122  ED2K913920

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
* End of Insert by PBANDLAPAL on 20-Nov-2017 : ED2K909381

      IF lv_stdt IS NOT INITIAL.
        lst_xvbak = dxvbak. " Putting VBAK data in local work area

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata-fval = lv_stdt.
        APPEND lst_bdcdata TO li_bdcdata230. " appending contract start date

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VENDDAT'.
        lst_bdcdata-fval = lv_eddt.
        APPEND lst_bdcdata TO li_bdcdata230. " appending contract end date

      ENDIF. " IF lv_stdt IS NOT INITIAL

*** BOC BY SAYANDAS on 02-JAN-2018 for CR-741
      IF lv_vsnmr_v_230 IS NOT INITIAL.

        CLEAR lst_bdcdata. " Clearing work area for BDC data
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KKAU'.
        APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-VSNMR_V'.
        lst_bdcdata-fval = lv_vsnmr_v_230.
        APPEND lst_bdcdata TO li_bdcdata230.

        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER1'.
        APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      ENDIF. " IF lv_vsnmr_v_230 IS NOT INITIAL
*** EOC BY SAYANDAS on 02-JAN-2018 for CR-741

      IF lv_promo_8 IS NOT INITIAL OR
         lv_zzlicyr IS NOT INITIAL. " CR#6142 KKR20180605  ED2K912174
        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KZKU'.
        APPEND lst_bdcdata TO li_bdcdata230.
        CLEAR lst_bdcdata.

        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata230.
        CLEAR lst_bdcdata.

        IF lv_promo_8 IS NOT INITIAL.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAK-ZZPROMO'.
          APPEND lst_bdcdata TO li_bdcdata230.
          CLEAR lst_bdcdata.

          lst_bdcdata-fnam = 'VBAK-ZZPROMO'.
          lst_bdcdata-fval = lv_promo_8.
          APPEND lst_bdcdata TO li_bdcdata230.
          CLEAR: lst_bdcdata, lv_promo_8.
        ENDIF. " IF lv_promo_8 IS NOT INITIAL

* Begin of: CR#6142 KKR20180605  ED2K912174
* Adding ZZLICYR to BDC Code
        IF igv_actv_flag_lic_year_i0230 = abap_true. " Check if the CR#6142 needs to be triggered
          IF lv_zzlicyr IS NOT INITIAL.
            IF igt_zcaconstant[] IS NOT INITIAL.
              DATA(liv_zzlicyr) = igt_zcaconstant[ devid = lc_devid_i0230 param2 = lc_param2_zly_i0230 ].
              IF sy-subrc = 0.
                IF lv_zzlicyr >= liv_zzlicyr-low.
                  CLEAR lst_bdcdata.
                  lst_bdcdata-fnam = 'BDC_CURSOR'.
                  lst_bdcdata-fval = 'VBAK-ZZLICYR'.
                  APPEND lst_bdcdata TO li_bdcdata230.
                  CLEAR lst_bdcdata.

                  lst_bdcdata-fnam = 'VBAK-ZZLICYR'.
                  lst_bdcdata-fval = lv_zzlicyr.
                  APPEND lst_bdcdata TO li_bdcdata230.
                  CLEAR: lst_bdcdata, lv_zzlicyr, liv_zzlicyr.
                ENDIF. " IF lv_zzlicyr >= liv_zzlicyr-low.
                CLEAR liv_zzlicyr.
              ENDIF. " IF sy-subrc = 0
            ENDIF. " IF igt_zcaconstant[] IS NOT INITIAL
          ENDIF. " IF lv_zzlicyr IS NOT INITIAL
        ENDIF. " IF igv_actv_flag_lic_year_i0230 = abap_true
* End of: CR#6142 KKR20180605  ED2K912174

      ENDIF. " IF lv_promo_8 IS NOT INITIAL OR lv_zzlicyr IS NOT INITIAL.

*** BOC: CR#6310 KKRAVURI20181122  ED2K913920
      IF v_actv_flag_name_co_i0230 = abap_true.

        IF lv_co_name IS NOT INITIAL OR lv_smtp_adr IS NOT INITIAL OR lv_co_name_we IS NOT INITIAL. " lv_co_name_we ++by BSAKI ED2K926194 20220322
          " 'KPAR_SUB' is the Function code to navigate to Partners tab
          READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> WITH KEY
                               fnam = 'BDC_OKCODE' fval = 'KPAR_SUB'.
          IF sy-subrc EQ 0 AND <lst_bdcdata_0230> IS ASSIGNED.
            lv_kpar_sub_tabix_we = lv_kpar_sub_tabix = sy-tabix.
            lv_kpar_sub_tabix    = lv_kpar_sub_tabix + 1.
            lv_kpar_sub_tabix_we = lv_kpar_sub_tabix_we + 1.
            IF <lst_bdcdata_0230> IS ASSIGNED.
              UNASSIGN <lst_bdcdata_0230>.
            ENDIF.

            LOOP AT dxbdcdata ASSIGNING <lst_bdcdata_0230> FROM lv_kpar_sub_tabix.
              IF <lst_bdcdata_0230>-fnam = 'BDC_OKCODE' AND <lst_bdcdata_0230>-fval = 'PAPO'.
                IF lv_papo_flag = abap_false.
                  lv_papo_flag = abap_true.
                  lv_papo_tabix = sy-tabix.
                ENDIF.
              ENDIF.
              IF <lst_bdcdata_0230>-fnam = 'DV_PARVW' AND <lst_bdcdata_0230>-fval = 'RE'.
                IF lv_re_flag = abap_false.
                  lv_re_flag = abap_true.
                  lv_re_tabix = sy-tabix.
                ENDIF.
*** BOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
              ELSEIF <lst_bdcdata_0230>-fnam = 'DV_PARVW' AND <lst_bdcdata_0230>-fval = lc_we_8.
                IF lv_we_flag = abap_false.
                  lv_we_flag = abap_true.
                  lv_we_tabix = sy-tabix.
                ENDIF.
              ENDIF.
*** EOC: OTCM-54171 by NPOLINA ED2K926194 20220322 for WE-Shipto Name_CO
              IF lv_papo_flag = abap_true AND lv_re_flag = abap_true AND lv_we_flag = abap_true.
                EXIT.
              ENDIF.
              IF <lst_bdcdata_0230>-program = 'SAPMV45A' AND <lst_bdcdata_0230>-dynpro = '4003' AND
                 <lst_bdcdata_0230>-dynbegin = 'X'.
                EXIT. " Exit when Item data starts
              ENDIF.
            ENDLOOP.

            IF lv_re_flag = abap_true.
              lv_re_tabix = lv_re_tabix + 1.
              DATA(lv_to_index1) = lv_re_tabix + 7.
              IF <lst_bdcdata_0230> IS ASSIGNED.
                UNASSIGN <lst_bdcdata_0230>.
              ENDIF.
              LOOP AT dxbdcdata ASSIGNING <lst_bdcdata_0230> FROM lv_re_tabix TO lv_to_index1.
                IF <lst_bdcdata_0230>-fnam = 'BDC_OKCODE' AND <lst_bdcdata_0230>-fval = 'PSDE'.
                  IF lv_psde_flag = abap_false.
                    lv_psde_flag = abap_true.
                    lv_psde_tabix = sy-tabix.
                  ENDIF.
                ENDIF.
                IF <lst_bdcdata_0230>-program = 'SAPLV09C' AND <lst_bdcdata_0230>-dynpro = '5000' AND
                   <lst_bdcdata_0230>-dynbegin = 'X'.
                  IF lv_5000_flag = abap_false.
                    lv_5000_flag = abap_true.
                    lv_5000_tabix = sy-tabix.
                  ENDIF.
                ENDIF.
                IF lv_psde_flag = abap_true AND lv_5000_flag = abap_true.
                  EXIT.
                ENDIF.
              ENDLOOP.
            ENDIF. " IF lv_re_flag = abap_true.
*** BOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220322 for WE-Shipto Name_CO
            IF lv_we_flag = abap_true.
              lv_we_tabix = lv_we_tabix + 1.
              DATA(lv_to_indexwe) = lv_we_tabix + 7.
              IF <lst_bdcdata_0230> IS ASSIGNED.
                UNASSIGN <lst_bdcdata_0230>.
              ENDIF.
              LOOP AT dxbdcdata ASSIGNING <lst_bdcdata_0230> FROM lv_we_tabix TO lv_to_indexwe.
                IF <lst_bdcdata_0230>-fnam = 'BDC_OKCODE' AND <lst_bdcdata_0230>-fval = 'PSDE'.
                  IF lv_psde_flag2 = abap_false.
                    lv_psde_flag2 = abap_true.
                    lv_psde_tabix2 = sy-tabix.
                  ENDIF.
                ENDIF.
                IF <lst_bdcdata_0230>-program = 'SAPLV09C' AND <lst_bdcdata_0230>-dynpro = '5000' AND
                   <lst_bdcdata_0230>-dynbegin = 'X'.
                  IF lv_5000_flag2 = abap_false.
                    lv_5000_flag2 = abap_true.
                    lv_5000_tabix2 = sy-tabix.
                  ENDIF.
                ENDIF.
                IF lv_psde_flag2 = abap_true AND lv_5000_flag2 = abap_true.
                  EXIT.
                ENDIF.
              ENDLOOP.
            ENDIF. " IF lv_we_flag = abap_true.
*** EOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220322 for WE-Shipto Name_CO
* Bill-to Address details are passed via IDOC Segment EIEDKA1
* Hence just add the Fields: NAME_CO, SMTP_ADDR and its values to the Address Screen
* as a first entry
            IF lv_re_flag = abap_true AND lv_psde_flag = abap_true AND
               lv_5000_flag = abap_true.
              " Index built to insert the BDC code
              lv_5000_tabix = lv_5000_tabix + 1.

              IF lv_co_name IS NOT INITIAL.
                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name.
                APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending field 'NAME_CO' value
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CLEAR lst_bdcdata.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending field 'SMTP_ADDR' value
              ENDIF.
              " Insert field 'c/o' value as first entry to Address screen: 5000
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX lv_5000_tabix.
              CLEAR: lst_bdcdata, li_bdcdata_6310[], lv_re_flag, lv_re_tabix, lv_psde_flag, lv_psde_tabix,
                     lv_5000_flag, lv_5000_tabix.

* Bill-to partner function is passed but not the Address details via IDOC Segment EIEDKA1
* Hence add the BDC mapping for Function Code of Address screen, Address screen details,
* Field: NAME_CO and its value to the Address screen. Then Insert all the corresponding BDC code
* at the relevant Index
            ELSEIF lv_re_flag = abap_true AND lv_psde_flag = abap_false.
              DATA(lv_to_index2) = lv_re_tabix + 3.
              IF <lst_bdcdata_0230> IS ASSIGNED.
                UNASSIGN <lst_bdcdata_0230>.
              ENDIF.
              LOOP AT dxbdcdata ASSIGNING <lst_bdcdata_0230> FROM lv_re_tabix TO lv_to_index2.
                IF <lst_bdcdata_0230>-fnam = 'GVS_TC_DATA-REC-PARTNER(01)'.
                  DATA(liv_partner_flag) = abap_true.
                  DATA(liv_partner_tabix) = sy-tabix.
                ENDIF.
                IF <lst_bdcdata_0230>-fnam = 'GVS_TC_DATA-SELKZ(01)' AND <lst_bdcdata_0230>-fval = 'X'.
                  DATA(liv_selkz_flag) = abap_true.
                  DATA(liv_selkz_tabix) = sy-tabix.
                ENDIF.
              ENDLOOP.
              " Build the Index value 'liv_selkz_tabix' to insert the BDC code
              IF liv_selkz_flag = abap_true AND liv_partner_flag = abap_true.
                IF liv_selkz_tabix < liv_partner_tabix.
                  liv_selkz_tabix = liv_partner_tabix + 1.
                ELSE.
                  liv_selkz_tabix = liv_selkz_tabix + 1.
                ENDIF.
              ELSEIF liv_selkz_flag = abap_true AND liv_partner_flag = abap_false.
                liv_selkz_tabix = liv_selkz_tabix + 1.
              ELSEIF liv_selkz_flag = abap_false AND liv_partner_flag = abap_true.
                liv_selkz_tabix = liv_partner_tabix + 1.
              ELSE.
                liv_selkz_tabix = lv_re_tabix + 1.
              ENDIF.

              IF liv_selkz_flag = abap_false.
                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'GVS_TC_DATA-SELKZ(01)'.
                lst_bdcdata-fval = 'X'.
                APPEND lst_bdcdata TO li_bdcdata_6310.   " Appending OKCODE for Address Screen
                CLEAR lst_bdcdata.
              ENDIF.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PSDE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending OKCODE for Address Screen
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '5000'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending Address screen and Program
              CLEAR lst_bdcdata.

              IF lv_co_name IS NOT INITIAL.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name.
                APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending field 'c/o' value
                CLEAR lst_bdcdata.
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending field 'SMTP_ADDR' value
                CLEAR lst_bdcdata.
              ENDIF.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'ENT1'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending OKCODE for enter
              CLEAR lst_bdcdata.

              " Insert the BDC code at the relevant Index
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX liv_selkz_tabix.
              CLEAR: li_bdcdata_6310[], liv_selkz_tabix, liv_selkz_flag, liv_partner_flag,lv_kpar_sub_tabix,
                     liv_partner_tabix, lv_re_flag, lv_re_tabix,lv_papo_flag, lv_papo_tabix.

* Bill-to partner function is not passed via IDOC Segment EIEDKA1
* Hence add the BDC mapping for Function Code of Partner function selection, Screen details of
* Partner function selection, Function Code of Address screen, Address screen details,
* Field: NAME_CO and its value to the Address screen. Then Insert all the corresponding BDC code
* at the relevant Index
            ELSEIF lv_re_flag = abap_false.
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PAPO'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for Partner Function selection
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '0666'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner Function screen & Program
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'DV_PARVW'.
              lst_bdcdata-fval = 'RE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner Function value
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'GVS_TC_DATA-SELKZ(01)'.
              lst_bdcdata-fval = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner function selection indicator
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PSDE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for Address screen
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '5000'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Address screen & program
              CLEAR lst_bdcdata.

              IF lv_co_name IS NOT INITIAL.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name.
                APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending field 'c/o' value
                CLEAR lst_bdcdata.
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending field 'SMTP_ADDR' value
                CLEAR lst_bdcdata.
              ENDIF.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'ENT1'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for enter
              CLEAR lst_bdcdata.

              IF lv_papo_flag = abap_false.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4002'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdata_6310.  " Appending Main program and screen
                CLEAR lst_bdcdata.
              ENDIF.

              " Insert the BDC code at the relevant Index
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX lv_kpar_sub_tabix.
              CLEAR: li_bdcdata_6310[], lv_kpar_sub_tabix .

            ENDIF. " IF lv_re_flag = abap_true AND lv_psde_flag = abap_true

*** BOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220322 for WE-Shipto Name_CO

* Ship-to-Party Address details are passed via IDOC Segment EIEDKA1
* Hence just add the Fields: NAME_CO, SMTP_ADDR and its values to the Address Screen
* as a first entry
            IF lv_we_flag = abap_true AND lv_psde_flag2 = abap_true AND
               lv_5000_flag2 = abap_true.
              " Index built to insert the BDC code
              lv_5000_tabix2 = lv_5000_tabix2 + 1.
              IF lv_co_name_we IS NOT INITIAL.  "lv_co_name
                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name_we.  "lv_co_name
                APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending field 'NAME_CO' value
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CLEAR lst_bdcdata.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending field 'SMTP_ADDR' value
              ENDIF.
              " Insert field 'c/o' value as first entry to Address screen: 5000
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX lv_5000_tabix2.
              CLEAR: lst_bdcdata, li_bdcdata_6310[] , lv_we_flag, lv_we_tabix, lv_psde_flag2, lv_psde_tabix2,
                     lv_5000_flag2, lv_5000_tabix2. " lv_papo_flag, lv_papo_tabix.

* Ship-to-Party partner function is passed but not the Address details via IDOC Segment EIEDKA1
* Hence add the BDC mapping for Function Code of Address screen, Address screen details,
* Field: NAME_CO and its value to the Address screen. Then Insert all the corresponding BDC code
* at the relevant Index
            ELSEIF lv_we_flag = abap_true AND lv_psde_flag2 = abap_false.
              CLEAR : lv_to_index2.
              lv_to_index2 = lv_we_tabix + 3.
              IF <lst_bdcdata_0230> IS ASSIGNED.
                UNASSIGN <lst_bdcdata_0230>.
              ENDIF.
              LOOP AT dxbdcdata ASSIGNING <lst_bdcdata_0230> FROM lv_we_tabix TO lv_to_index2.
                IF <lst_bdcdata_0230>-fnam = 'GVS_TC_DATA-REC-PARTNER(01)'.
                  CLEAR : liv_partner_flag  , liv_partner_tabix.
                  liv_partner_flag   = abap_true.
                  liv_partner_tabix  = sy-tabix.
                ENDIF.
                IF <lst_bdcdata_0230>-fnam = 'GVS_TC_DATA-SELKZ(01)' AND <lst_bdcdata_0230>-fval = 'X'.
                  CLEAR : liv_selkz_flag , liv_selkz_tabix.
                  liv_selkz_flag  = abap_true.
                  liv_selkz_tabix = sy-tabix.
                ENDIF.
              ENDLOOP.
              " Build the Index value 'liv_selkz_tabix' to insert the BDC code
              IF liv_selkz_flag = abap_true AND liv_partner_flag = abap_true.
                IF liv_selkz_tabix < liv_partner_tabix.
                  liv_selkz_tabix = liv_partner_tabix + 1.
                ELSE.
                  liv_selkz_tabix = liv_selkz_tabix + 1.
                ENDIF.
              ELSEIF liv_selkz_flag = abap_true AND liv_partner_flag = abap_false.
                liv_selkz_tabix = liv_selkz_tabix + 1.
              ELSEIF liv_selkz_flag = abap_false AND liv_partner_flag = abap_true.
                liv_selkz_tabix = liv_partner_tabix + 1.
              ELSE.
                liv_selkz_tabix = lv_we_tabix + 1.
              ENDIF.

              IF liv_selkz_flag = abap_false.
                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'GVS_TC_DATA-SELKZ(01)'.
                lst_bdcdata-fval = 'X'.
                APPEND lst_bdcdata TO li_bdcdata_6310.   " Appending OKCODE for Address Screen
                CLEAR lst_bdcdata.
              ENDIF.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PSDE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending OKCODE for Address Screen
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '5000'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.       " Appending Address screen and Program
              CLEAR lst_bdcdata.

              IF lv_co_name IS NOT INITIAL.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name_we.
                APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending field 'c/o' value
                CLEAR lst_bdcdata.
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending field 'SMTP_ADDR' value
                CLEAR lst_bdcdata.
              ENDIF.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'ENT1'.
              APPEND lst_bdcdata TO li_bdcdata_6310.     " Appending OKCODE for enter
              CLEAR lst_bdcdata.

              " Insert the BDC code at the relevant Index
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX liv_selkz_tabix.
              CLEAR: li_bdcdata_6310[], liv_selkz_tabix, liv_selkz_flag, liv_partner_flag,
                     liv_partner_tabix, lv_we_flag, lv_we_tabix." lv_papo_flag, lv_papo_tabix.

* Ship-to-party partner function is not passed via IDOC Segment EIEDKA1
* Hence add the BDC mapping for Function Code of Partner function selection, Screen details of
* Partner function selection, Function Code of Address screen, Address screen details,
* Field: NAME_CO and its value to the Address screen. Then Insert all the corresponding BDC code
* at the relevant Index
            ELSEIF lv_we_flag = abap_false.
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PAPO'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for Partner Function selection
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '0666'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner Function screen & Program
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'DV_PARVW'.
              lst_bdcdata-fval = 'WE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner Function value
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'GVS_TC_DATA-SELKZ(01)'.
              lst_bdcdata-fval = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Partner function selection indicator
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PSDE'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for Address screen
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '5000'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending Address screen & program
              CLEAR lst_bdcdata.

              IF lv_co_name_we IS NOT INITIAL.
                lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
                lst_bdcdata-fval = lv_co_name_we.
                APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending field 'c/o' value
                CLEAR lst_bdcdata.
              ENDIF.
              IF lv_smtp_adr IS NOT INITIAL.
                CONDENSE lv_smtp_adr NO-GAPS.
                lst_bdcdata-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata-fval = lv_smtp_adr.
                APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending field 'SMTP_ADDR' value
                CLEAR lst_bdcdata.
              ENDIF.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'ENT1'.
              APPEND lst_bdcdata TO li_bdcdata_6310.    " Appending OKCODE for enter
              CLEAR lst_bdcdata.

              IF lv_papo_flag = abap_false.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4002'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdata_6310.  " Appending Main program and screen
                CLEAR lst_bdcdata.
              ENDIF.

              " Insert the BDC code at the relevant Index
              INSERT LINES OF li_bdcdata_6310 INTO dxbdcdata INDEX lv_kpar_sub_tabix_we.
              CLEAR: li_bdcdata_6310[],lv_kpar_sub_tabix_we.

            ENDIF. " IF lv_we_flag = abap_true AND lv_psde_flag2 = abap_true
            CLEAR :  lv_papo_flag, lv_papo_tabix , lv_kpar_sub_tabix_we , lv_we_flag, lv_we_tabix, lv_psde_flag2, lv_psde_tabix2,
                     lv_5000_flag2, lv_5000_tabix2,lv_kpar_sub_tabix_we.
*** EOC: OTCM-54171 BSAKI ED2K926194 20220322

            IF <lst_bdcdata_0230> IS ASSIGNED.
              UNASSIGN <lst_bdcdata_0230>.
            ENDIF.
            CLEAR : lv_kpar_sub_tabix   , lv_kpar_sub_tabix_we , lv_papo_flag ,lv_papo_tabix ,lv_re_flag ,lv_re_tabix,
            lv_we_flag ,lv_we_tabix,lv_to_index1.
          ENDIF. " IF sy-subrc EQ 0 AND <lst_bdcdata_0230> IS ASSIGNED

        ENDIF. " IF lv_co_name IS NOT INITIAL OR lv_smtp_adr IS NOT INITIAL

        CLEAR: lv_co_name,lv_co_name_we, lv_smtp_adr.
"BOC by MRAJKUMAR OTCM-54171  ED2K926835 20-04-2022
        DATA: lst_e1edka1_i0230_8 TYPE e1edka1,
              lst_e1edkt2_i0230_8 TYPE e1edkt2,
              lst_e1edpa1_i0230_8 TYPE e1edpa1,
              lst_insert_check    TYPE char1,
              lst_insert          TYPE sy-tabix.
        DATA: li_bdcdata_i0230_8 TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0.
        CLEAR: lst_e1edka1_i0230_8,
               lst_e1edkt2_i0230_8,
               lst_e1edpa1_i0230_8.
"Fetching c/o name from E1EDKT2 to pass on to item ship-to-paty c/o name.
        READ TABLE didoc_data
          ASSIGNING FIELD-SYMBOL(<fs_idoc_i0230_8>)
          WITH KEY segnam = 'E1EDKT1'
                   sdata+0(4) = '0021'.
        IF  sy-subrc IS INITIAL
        AND <fs_idoc_i0230_8> IS ASSIGNED.
          DATA(lst_next) = sy-tabix + 1.
          READ TABLE didoc_data
            ASSIGNING FIELD-SYMBOL(<fs_idoc_i0230_8_1>)
            INDEX lst_next.
          IF  sy-subrc IS INITIAL
          AND <fs_idoc_i0230_8_1>-segnam = 'E1EDKT2'.
            lst_e1edkt2_i0230_8 = <fs_idoc_i0230_8_1>-sdata.
            DATA(lst_wename) = lst_e1edkt2_i0230_8-tdline.
            SPLIT lst_wename AT cl_abap_char_utilities=>horizontal_tab
                       INTO DATA(lst_wename1) DATA(lst_wename2).
            CONCATENATE lst_wename1
                        lst_wename2
                   INTO lst_wename
              SEPARATED BY space.

*** BOC: OTCM-54171 by NPOLINA  Name_CO
                REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]'
                  IN lst_wename WITH | |.

*** EOC: OTCM-54171 by NPOLINA Name_CO

          ENDIF.
        ENDIF.
"Fetching header ship-to-party value.
        UNASSIGN <fs_idoc_i0230_8>.
        READ TABLE didoc_data
          ASSIGNING <fs_idoc_i0230_8>
          WITH KEY segnam = 'E1EDKA1'
                   sdata+0(3) = 'WE'.
        IF  sy-subrc IS INITIAL
        AND <fs_idoc_i0230_8> IS ASSIGNED.
          lst_e1edka1_i0230_8 = <fs_idoc_i0230_8>-sdata.
          IF lst_e1edka1_i0230_8-parvw = 'WE'.
            DATA(lst_wevalue) = lst_e1edka1_i0230_8-partn.
          ENDIF.
        ENDIF.
        UNASSIGN <fs_idoc_i0230_8>.
        LOOP AT didoc_data
          ASSIGNING <fs_idoc_i0230_8>
                    WHERE segnam EQ 'E1EDPA1'.
" Fetching item ship to party value and comparing with header ship to party
" if both are different then passing c/o  name to item ship to party thoguh BDC.
          lst_e1edpa1_i0230_8 = <fs_idoc_i0230_8>-sdata.
          IF lst_e1edpa1_i0230_8-parvw = 'WE'.
            DATA(lst_weitemvalue) = lst_e1edpa1_i0230_8-partn.
            IF lst_wevalue NE lst_weitemvalue.
" if both are different then passing c/o  name to item ship to party thoguh BDC.
              FREE li_bdcdata_i0230_8.
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4003'.
              lst_bdcdata-dynbegin = 'X'.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PAPO'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Main program and screen
              CLEAR lst_bdcdata.
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '666'.
              lst_bdcdata-dynbegin = 'X'.
              lst_bdcdata-fnam = 'DV_PARVW'.
              lst_bdcdata-fval = 'WE'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Main program and screen
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'DV_PARNR'.
              lst_bdcdata-fval = lst_weitemvalue.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Main program and screen
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4003'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Partner Function screen & Program
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'GVS_TC_DATA-SELKZ(01)'.
              lst_bdcdata-fval = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending OKCODE for Partner Function selection
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4003'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PSDE'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Partner Function value
              CLEAR lst_bdcdata.

              lst_bdcdata-program = 'SAPLV09C'.
              lst_bdcdata-dynpro = '5000'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Main program and screen
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'ADDR1_DATA-NAME_CO'.
              lst_bdcdata-fval = lst_wename.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending Partner function selection indicator
              CLEAR lst_bdcdata.

              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'ENT1'.
              APPEND lst_bdcdata TO li_bdcdata_i0230_8.    " Appending OKCODE for Address screen
              CLEAR lst_bdcdata.
              LOOP AT dxbdcdata
                ASSIGNING FIELD-SYMBOL(<fs_bdc_i0230_8>)
                FROM  lst_insert
                WHERE fnam EQ 'GVS_TC_DATA-REC-PARTNER(01)'
                  AND fval EQ lst_weitemvalue.
                  lst_insert = sy-tabix + 1.
                  INSERT LINES OF li_bdcdata_i0230_8 INTO dxbdcdata INDEX lst_insert.
                  IF sy-subrc IS INITIAL.
                   "Do Nothing
                  ENDIF.
                EXIT.
              ENDLOOP.
"*** BOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220428 for WE-Shipto Name_CO
            ELSE.
                LOOP AT dxbdcdata INTO DATA(ls_bdcdata) WHERE fnam = 'GVS_TC_DATA-REC-PARTNER(01)' AND fval = lst_wevalue.
                  DATA(lv_tabix_we) = sy-tabix.
                  lv_tabix_we = sy-tabix - 2.
                  DATA(lv_tabix_p) = sy-tabix - 1.
                  CLEAR ls_bdcdata.
                  READ TABLE dxbdcdata INTO ls_bdcdata INDEX lv_tabix_we.
                  IF sy-subrc = 0 AND ls_bdcdata-fnam = 'DV_PARVW' AND ls_bdcdata-fval = 'WE'.
                     DATA(lv_tabix_tmp) = lv_tabix_we + 2.
                     DATA(lv_tabix_f) = lv_tabix_we + 1.
                     DATA(lv_tabix_t) = lv_tabix_we + 3.
                     CLEAR ls_bdcdata.
                     READ TABLE dxbdcdata INTO ls_bdcdata INDEX lv_tabix_p.
                     IF sy-subrc = 0 AND ls_bdcdata-program = 'SAPMV45A' AND ls_bdcdata-dynpro = '4003'.
                      CLEAR ls_bdcdata.
                      READ TABLE dxbdcdata INTO ls_bdcdata INDEX lv_tabix_tmp.
                      IF sy-subrc = 0 AND ls_bdcdata-fnam = 'GVS_TC_DATA-REC-PARTNER(01)' AND ls_bdcdata-fval = lst_wevalue.
                       DELETE dxbdcdata INDEX lv_tabix_t.
                       DELETE dxbdcdata INDEX lv_tabix_tmp.
                       DELETE dxbdcdata INDEX lv_tabix_f.
                      ENDIF.
                     ENDIF.
                  ENDIF.
                  CLEAR: lv_tabix_we, lv_tabix_p, lv_tabix_tmp, lv_tabix_f, lv_tabix_t.
                ENDLOOP.
*** BOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220428 for WE-Shipto Name_CO
            ENDIF.
          ENDIF.
        ENDLOOP.
"EOC by MRAJKUMAR OTCM-54171  ED2K926835 20-04-2022
      ENDIF. " IF v_actv_flag_name_co_i0230 = abap_true.
*** EOC: CR#6310 KKRAVURI20181122  ED2K913920

*** Begin of: CR#6122 RTR20180731  ED2K912853
      IF igv_actv_flag_bill_date_i0230 = abap_true. " Check if the CR#6122 needs to be triggered
        IF lv_fkdat3_230 IS NOT INITIAL.

          LOOP AT didoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>) WHERE segnam = lc_e1edk14.
            lst_e1edk14 = <lst_idoc_data>-sdata.
            IF lst_e1edk14-qualf = lc_016.  " Qualifier 016 (lc_016) indicates Sales Office
              lv_so = lst_e1edk14-orgid.
            ENDIF.
            CLEAR lst_e1edk14.
          ENDLOOP.

          LOOP AT igt_zcaconstant INTO DATA(lst_zcaconstant).
            CASE lst_zcaconstant-param1.
              WHEN lc_param1_so_i0230.
                IF lst_zcaconstant-param2 = lc_param2_so_i0230.
                  APPEND INITIAL LINE TO lir_so ASSIGNING FIELD-SYMBOL(<lif_so>).
                  <lif_so>-sign   = lst_zcaconstant-sign.
                  <lif_so>-option = lst_zcaconstant-opti.
                  <lif_so>-low    = lst_zcaconstant-low.
                  <lif_so>-high   = lst_zcaconstant-high.
                ENDIF.

              WHEN OTHERS.
                " No need of OTHERS here
            ENDCASE.
            CLEAR lst_zcaconstant.
          ENDLOOP.

          IF lv_so IN lir_so.
            lv_docnum = didoc_data[ 1 ]-docnum.
            CONCATENATE lv_docnum '_BILL_DATE' INTO lv_mem_name.
            EXPORT lv_fkdat2_230 TO MEMORY ID lv_mem_name.

            READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> WITH KEY fnam = 'BDC_OKCODE' fval = 'KDE3'.
            IF sy-subrc EQ 0 AND <lst_bdcdata_0230> IS ASSIGNED.
              lv_tabix230 = sy-tabix.
              lv_tabix230 = lv_tabix230 + 1.
              UNASSIGN <lst_bdcdata_0230>.
              READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
              IF sy-subrc EQ 0 AND <lst_bdcdata_0230> IS ASSIGNED.
                IF <lst_bdcdata_0230>-program = 'SAPMV45A' AND
                   <lst_bdcdata_0230>-dynpro = '4002' AND
                   <lst_bdcdata_0230>-dynbegin = 'X'.
                  lv_tabix230 = sy-tabix.
                  lv_tabix230 = lv_tabix230 + 1.

                  CLEAR lst_bdcdata.
                  lst_bdcdata-fnam = 'VBKD-FKDAT'.
                  lst_bdcdata-fval = lv_fkdat3_230.
                  INSERT lst_bdcdata INTO dxbdcdata INDEX lv_tabix230.
                  CLEAR: lst_bdcdata, lv_tabix230.
                ENDIF.
                UNASSIGN <lst_bdcdata_0230>.
              ENDIF.
            ELSE. " --> IF sy-subrc EQ 0
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'KDE3'.
              APPEND lst_bdcdata TO li_bdcdata230. " Appending OKCODE

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4002'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230. " Appending program and screen

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'VBKD-FKDAT'.
              lst_bdcdata-fval = lv_fkdat3_230.
              APPEND lst_bdcdata TO li_bdcdata230. " Appending Assignment

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '/EBACK'.
              APPEND lst_bdcdata TO li_bdcdata230. " Appending OKCODE
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lv_so = liv_so-low
          CLEAR: lir_so[], lv_so, lv_docnum, lv_fkdat3_230, lv_fkdat2_230.

        ENDIF. " IF lv_fkdat3_230 IS NOT INITIAL.
      ENDIF. " IF igv_actv_flag_bill_date_i0230 = abap_true.
*** End of: CR#6122 RTR20180731  ED2K912853

*** Change for FKDAT
      IF lv_fkdat_230 IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KDE3'.
        APPEND lst_bdcdata TO li_bdcdata230. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-FKDAT'.
        lst_bdcdata-fval = lv_fkdat_230.
        APPEND lst_bdcdata TO li_bdcdata230. " Appending Assignment

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      ENDIF. " IF lv_fkdat_230 IS NOT INITIAL
*** Change for FKDAT

      IF lv_ihrez_e2 IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=KBES'.
        APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBKD-IHREZ_E'.
        APPEND lst_bdcdata TO li_bdcdata230.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-IHREZ_E'.
        lst_bdcdata-fval = lv_ihrez_e2.
        APPEND lst_bdcdata TO li_bdcdata230. " Appending Assignment

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      ENDIF. " IF lv_ihrez_e2 IS NOT INITIAL
***<<<--- BOC by SAYANDAS
* Begin of Insert by PBANDLAPAL on 20-Nov-2017 : ED2K909381
      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

    ENDIF. " IF lv_stdt IS NOT INITIAL OR
* End of Insert by PBANDLAPAL on 20-Nov-2017 : ED2K909381
    CLEAR lst_bdcdata. " Clearing work area for BDC data
    lst_bdcdata-fnam = 'BDC_OKCODE'.
    lst_bdcdata-fval = 'UER1'.
    APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

    IF dxvbap[] IS NOT INITIAL.

      li_vbap[] = dxvbap[].

******** code for ihrez
      IF li_item1 IS NOT INITIAL.
        SORT li_item1 BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item1.

        LOOP AT li_vbap INTO lst_vbap.
* BOC by PBANDLAPAL on 08-Nov-2017
*          CLEAR: lst_bdcdata.
*          lst_bdcdata-program = 'SAPMV45A'.
*          lst_bdcdata-dynpro = '4001'.
*          lst_bdcdata-dynbegin = 'X'.
*          APPEND lst_bdcdata TO li_bdcdata230.
* EOC by PBANDLAPAL on 08-Nov-2017
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-posex
            IMPORTING
              output = lst_vbap-posex.

          READ TABLE li_item1 INTO lst_item1 WITH KEY posex = lst_vbap-posex BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_item1-ihrez IS NOT INITIAL.
* BOC by PBANDLAPAL on 08-Nov-2017
              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4001'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.
* EOC by PBANDLAPAL on 08-Nov-2017
              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'POPO'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '251'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata-fval = lst_vbap-posex.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PBES'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4003'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'VBKD-IHREZ'.
              lst_bdcdata-fval = lst_item1-ihrez.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '/EBACK'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.
            ENDIF. " IF lst_item1-ihrez IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap

      ENDIF. " IF li_item1 IS NOT INITIAL
    ENDIF. " IF dxvbap[] IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix230.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
    IF <lst_bdcdata_0230> IS ASSIGNED.
      <lst_bdcdata_0230>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_0230> IS ASSIGNED
    INSERT LINES OF li_bdcdata230 INTO dxbdcdata INDEX lv_tabix230.

***EOC by SAYANDAS--->>>
  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata-fnam = 'BDC_OKCODE'
   AND lst_bdcdata-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix230.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
    IF <lst_bdcdata_0230> IS ASSIGNED.
      <lst_bdcdata_0230>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0230> IS ASSIGNED

  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_vbap10_230 = dxvbap. " Copy the value in local work area

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
IF v_vbtyp_flg_230 = abap_true.
  READ TABLE i_qty_tabix_230 INTO lst_qty_tabix_230
                             WITH KEY posnr = lst_vbap10_230-posnr.
  IF sy-subrc NE 0.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
    IF lst_vbap10_230-posnr EQ 1.
      lv_zmeng_230 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
    ELSE. " ELSE -> IF lst_vbap10_230-posnr EQ 1
      lv_zmeng_230 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
    ENDIF. " IF lst_vbap10_230-posnr EQ 1

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230.
    DESCRIBE TABLE i_qty_tabix_230 LINES lv_qt_lines_230.
    IF lv_qt_lines_230 GE 1.
      READ TABLE i_qty_tabix_230 INTO lst_qty_tabix_230 INDEX lv_qt_lines_230.
      IF sy-subrc EQ 0.
        LOOP AT dxbdcdata INTO lst_bdcdata9_230 FROM lst_qty_tabix_230-tabix
                                                WHERE fnam = lv_zmeng_230.
          lv_tabix1_230 = sy-tabix. " Storing the index of ZMENG
        ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_230 FROM lst_qty_tabix_230-tabix
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF lv_qt_lines_230 GE 1
      LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230.
        lv_tabix1_230 = sy-tabix. " Storing the index of ZMENG
      ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230
    ENDIF. " IF lv_qt_lines_230 GE 1
    IF sy-subrc = 0.
      IF lst_vbap10_230-posnr EQ 1.
        lv_kwmeng_230 = 'RV45A-KWMENG(1)'. "KWMENG Field Name
      ELSE. " ELSE -> IF lst_vbap10_230-posnr EQ 1
        lv_kwmeng_230 = 'RV45A-KWMENG(2)'. "KWMENG Field Name
      ENDIF. " IF lst_vbap10_230-posnr EQ 1

      READ TABLE dxbdcdata INTO lst_bdcdata11_230 INDEX ( lv_tabix1_230 - 1 ).
      IF sy-subrc EQ 0 AND
         lst_bdcdata11_230-fnam NE lv_kwmeng_230.

        lst_bdcdata10_230-dynpro = '0000'.
        lst_bdcdata10_230-fnam = lv_kwmeng_230.
        lst_bdcdata10_230-fval = lst_bdcdata9_230-fval.

        INSERT lst_bdcdata10_230 INTO dxbdcdata INDEX lv_tabix1_230.
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
        lst_qty_tabix_230-posnr = lst_vbap10_230-posnr.
        lst_qty_tabix_230-tabix = lv_tabix1_230.
        APPEND lst_qty_tabix_230 TO i_qty_tabix_230.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
        CLEAR: lst_bdcdata11_230,
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
               lst_qty_tabix_230,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
               lst_bdcdata10_230. " appending KWMENG
      ENDIF. " IF sy-subrc EQ 0 AND
      CLEAR lst_bdcdata9_230.
    ENDIF. " IF sy-subrc = 0
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888

  ENDIF. " IF sy-subrc NE 0
ENDIF. " IF v_vbtyp_flg_230 = abap_true
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
