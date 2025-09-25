*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_DATADECLARATION_E335 (Declare the global variables)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/21/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                    *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*
* REVISION NO: ED2K919899                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/14/2020                                                    *
* DESCRIPTION: Logic changes for Subscrition order/Po count/add new Print vendor
*              display and remove duplicate from the PO number
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K925275                                              *
* REFERENCE NO: OTCM-51316                                             *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/20/2021                                                    *
* DESCRIPTION: Add new fields to input and output of V_RA Report
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_sum_ordertypewise,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          auart TYPE auart,
          count TYPE kwmeng,
        END OF ty_sum_ordertypewise.

TYPES : BEGIN OF ty_excel_tab,
          vbeln               TYPE char14,
          posnr               TYPE char20,
          matnr               TYPE char18,
          kwmeng              TYPE char19,
          kbmeng              TYPE char19,
          olfmng              TYPE char19,
          vrkme               TYPE char10,
          lfdat_1             TYPE char17,
          lprio               TYPE char17,
          kunnr               TYPE char10,
          fixmg               TYPE char18,
          zzship2party        TYPE char13,
          zzforwarding_agent  TYPE char16,
          zzvgbel             TYPE char25,
          zzihrez             TYPE char50,
          zzismarrivaldateac  TYPE char36,
          zzwerks             TYPE char14,
          zzvstel             TYPE char14,
          zzland1             TYPE char7,
          zzauart             TYPE char10,
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
          zzvendor_prt        TYPE char50,
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
          zzvendor            TYPE char50,
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
          zzismyearnr         TYPE char11,
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
          zzhistory           TYPE char50,
          zzpohistory         TYPE char200,
          zzdeliveryhistory   TYPE char200,
          zzvsbed             TYPE char18,
          zzship_introduction TYPE char250,
          zzlifsk             TYPE char14,
          zzdel_vtext         TYPE char26,
          zzfaksk             TYPE char13,
          zzbill_vtext        TYPE char25,
          zzcmgst             TYPE char11,
          zzbezei             TYPE char23,
        END OF ty_excel_tab.

DATA : i_excel_tab TYPE TABLE OF ty_excel_tab.

DATA  : is_sum_ortypewise TYPE SORTED TABLE OF ty_sum_ordertypewise WITH UNIQUE KEY kunnr matnr auart INITIAL SIZE 0,
        st_sum_ortypewise TYPE ty_sum_ordertypewise.

DATA : i_fieldcat TYPE slis_t_fieldcat_alv,    " declare for global access
       v_quote    TYPE char1.

* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
TYPES : BEGIN OF ty_po_history,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          ebeln TYPE ebeln,
        END OF ty_po_history.

TYPES : BEGIN OF ty_del_history,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          vbeln TYPE vbeln,
        END OF ty_del_history.

DATA : i_pohistory  TYPE STANDARD TABLE OF ty_po_history INITIAL SIZE 0,
       i_delhistory TYPE STANDARD TABLE OF ty_del_history INITIAL SIZE 0.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *

CONSTANTS : c_ship2party   TYPE rvari_vnam  VALUE 'ZZSHIP2PARTY',          " Ship-to Party
            c_forwdagnt    TYPE rvari_vnam  VALUE 'ZZFORWARDING_AGENT',    " Forwarding Agent
            c_refdoc       TYPE rvari_vnam  VALUE 'ZZVGBEL',               " Subscription Order Number
            c_yourref      TYPE rvari_vnam  VALUE 'ZZIHREZ',               " Subs Reference Number/ Your reference
*  BOC by NPOLINA on 12/15/2021 for OTCM-51316 with ED2K925275 *
            c_erdat        TYPE rvari_vnam  VALUE 'ERDAT',                 "Order Creation Date
*  EOC by NPOLINA on 12/15/2021 for OTCM-51316 with ED2K925275 *
            c_arriavaldat  TYPE rvari_vnam  VALUE 'ZZISMARRIVALDATEAC',    " Material’s Actual Goods Arrival Date
            c_plant        TYPE rvari_vnam  VALUE 'ZZWERKS',               " Delivery Plant
            c_shippoint    TYPE rvari_vnam  VALUE 'ZZVSTEL',               " Shipping Point
            c_conuntryky   TYPE rvari_vnam  VALUE 'ZZLAND1',               " Country
            c_ordertype    TYPE rvari_vnam  VALUE 'ZZAUART',               " Order Type
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
            c_prtvendor    TYPE rvari_vnam  VALUE 'ZZVENDOR_PRT',          " Print Vendor
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
            c_vendor       TYPE rvari_vnam  VALUE 'ZZVENDOR',              " Distributor Vendor
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
            c_volumyear    TYPE rvari_vnam  VALUE 'ZZISMYEARNR',           " Volume Year
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
            c_history      TYPE rvari_vnam  VALUE 'ZZHISTORY',             " Order History
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
            c_ponumber     TYPE rvari_vnam  VALUE 'ZZPOHISTORY',           " Purchase Order history
            c_delnumber    TYPE rvari_vnam  VALUE 'ZZDELIVERYHISTORY',     " Outbound Delivery history
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
            c_shipcondit   TYPE rvari_vnam  VALUE 'ZZVSBED',               " Shipping Condition
            c_shipinstruct TYPE rvari_vnam  VALUE 'ZZSHIP_INTRODUCTION',   " Special Shipping Instructions
            c_delblock     TYPE rvari_vnam  VALUE 'ZZLIFSK',               " Delivery Block
            c_delblkdes    TYPE rvari_vnam  VALUE 'ZZDEL_VTEXT',           " Delivery Block Description
            c_bilblock     TYPE rvari_vnam  VALUE 'ZZFAKSK',               " Billing Block
            c_bilblockdes  TYPE rvari_vnam  VALUE 'ZZBILL_VTEXT',          " Billing Block Description
            c_crdblock     TYPE rvari_vnam  VALUE 'ZZCMGST',               " Credit Hold
            c_crdblockdes  TYPE rvari_vnam  VALUE 'ZZBEZEI',               " Credit Hold Description
            c_vbeln        TYPE rvari_vnam  VALUE 'VBELN',                 " Sales Document
            c_posnr        TYPE rvari_vnam  VALUE 'POSNR',                 " Document line item
            c_matnr        TYPE rvari_vnam  VALUE 'MATNR',                 " material Code
            c_kwmeng       TYPE rvari_vnam  VALUE 'KWMENG',                " Order qty
            c_kbmeng       TYPE rvari_vnam  VALUE 'KBMENG',                " Cum. order qty
            c_olfmng       TYPE rvari_vnam  VALUE 'OLFMNG',                " Open qty
            c_vrkme        TYPE rvari_vnam  VALUE 'VRKME',                 " Uom
            c_lfdat_1      TYPE rvari_vnam  VALUE 'LFDAT_1',               " 1st delivery date
            c_lprio        TYPE rvari_vnam  VALUE 'LPRIO',                 " delivery priority
            c_kunnr        TYPE rvari_vnam  VALUE 'KUNNR',                 " Customer
            c_fixmg        TYPE rvari_vnam  VALUE 'FIXMG'.                 " Fixed date and qty


*BOC by NPOLINA on 12/20/2021 for OTCM-51316 with ED2K925275 *
DATA:wa_marc TYPE marc.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(30) cdate FOR FIELD s_erdat.
SELECT-OPTIONS: s_erdat FOR vbap-erdat.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(30) adate FOR FIELD s_arrdat.
SELECT-OPTIONS: s_arrdat FOR wa_marc-ismarrivaldateac.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN: SKIP 1.

IF ( s_erdat IS INITIAL AND s_arrdat IS INITIAL ) or ( s_erdat IS NOT INITIAL AND s_arrdat IS NOT INITIAL ).
  MESSAGE 'Please enter Order Creation Date OR Actual Goods Arrival Date' TYPE 'S'.
  LEAVE TO TRANSACTION sy-tcode.
ENDIF.
*EOC by NPOLINA on 12/20/2021 for OTCM-51316 with ED2K925275 *
