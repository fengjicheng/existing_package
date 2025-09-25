*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_AVOID_BILLING_SPLIT (Include)
* [Called from Billing Document Data Transfer Routine - 900 (RV60C900)]
* PROGRAM DESCRIPTION: Avoid Billing Split
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/26/2017
* OBJECT ID:           E070 / CR595
* TRANSPORT NUMBER(S): ED2K907534
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K907840
* REFERENCE NO:  ERP-3854
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08/09/2017
* DESCRIPTION: Split based on PO Number
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K909701
* REFERENCE NO:  ERP-5412
* DEVELOPER: Writtick Roy (WROY)
* DATE:  12/04/2017
* DESCRIPTION: Split based on:
*              1. Origin of sales tax ID number,
*              2. VAT Registration Number
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K912176
* REFERENCE NO:  ERP-6317
* DEVELOPER: AGUDURKHAD
* DATE:  06/21/2018
* DESCRIPTION: Copy the reference document from sales order to billing
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:ED2K918399
* REFERENCE NO:ERPM-16159
* DEVELOPER:SGUDA
* DATE:  06/08/2020
* DESCRIPTION:Invoices and Credit/Debit memos shoud not consolidate
*             when PO is 'Blank'
*---------------------------------------------------------------------*
* REVISION NO: ED1K909465 / ED2K919280
* REFERENCE NO:  RITM0106562 / INC0308834
* DEVELOPER: AGUDURKHAD / RKUMAR2
* DATE:  06/21/2018 / 08/25/2020
* DESCRIPTION: Move sales document number to vbrk-zukri
*---------------------------------------------------------------------*
* REVISION NO:   ED2K927337
* REFERENCE NO:  OTCM-54171
* DEVELOPER:     NPALLA
* DATE:          05/19/2022
* DESCRIPTION:   Move sales document number to vbrk-zukri to Avoid Billing split
*                whent the Order type is ZCSS and PO type is 0130 (maintained)
*---------------------------------------------------------------------*
CONSTANTS: c_auart TYPE auart VALUE  'ZIDR'.

* Begin of ADD:OTCM-54171:NPALLA:19-MAY-2022:ED2K927337
  TYPES : BEGIN OF lty_constants_005,
            devid  TYPE zdevid,                                        "Devid
            param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
            srno   TYPE tvarv_numb,                                   "Current selection number
            sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
          END OF lty_constants_005.
  TYPES:  BEGIN OF lty_xvbpak_005.
            INCLUDE STRUCTURE vbpavb.
  TYPES:  END OF lty_xvbpak_005.

CONSTANTS: lc_ord_type_005 TYPE char5 VALUE 'AUART',
           lc_po_type_005  TYPE char5 VALUE 'BSARK'.

CONSTANTS: lc_devid_e070    TYPE zdevid     VALUE 'E070',                           "Development ID
           lc_parm2_900_005 TYPE rvari_vnam VALUE '900_005',
           lc_ship_to       TYPE parvw      VALUE 'WE'. "Ship-To.

STATICS:
    lsv_adrnr_005      TYPE adrnr,                                     "Address Number
    lsv_vbeln_005      TYPE vbeln,                                     "SD Document
    lsv_shipto_005     TYPE kunnr,                                     "Ship-To
    lis_constants_005  TYPE STANDARD TABLE OF lty_constants_005,       "Itab for constants
    lrs_ordtype_005    TYPE STANDARD TABLE OF tds_rg_auart,            "Range : Order type
    lrs_potype_005     TYPE STANDARD TABLE OF tds_rg_bsark.            "Range : PO type

FIELD-SYMBOLS: <li_xvbpak_e070_005> TYPE any.
DATA: lv_xvbpak      TYPE string VALUE '(SAPLV60A)XVBPAK[]'. "VBPA Table
DATA: li_xvbpak_005 TYPE STANDARD TABLE OF lty_xvbpak_005.

IF lis_constants_005 IS INITIAL.
* Get Cnonstant values
  SELECT devid,                                                  "Devid
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @lis_constants_005
   WHERE devid    EQ @lc_devid_e070                               "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT lis_constants_005 ASSIGNING FIELD-SYMBOL(<lst_const_value_005>).
      IF <lst_const_value_005>-param2   EQ lc_parm2_900_005.
        CASE <lst_const_value_005>-param1.
          WHEN lc_ord_type_005.                                       "Order Type
            APPEND INITIAL LINE TO lrs_ordtype_005 ASSIGNING FIELD-SYMBOL(<lst_ordtype_005>).
            <lst_ordtype_005>-sign   = <lst_const_value_005>-sign.
            <lst_ordtype_005>-option = <lst_const_value_005>-opti.
            <lst_ordtype_005>-low    = <lst_const_value_005>-low.
            <lst_ordtype_005>-high   = <lst_const_value_005>-high.
          WHEN lc_po_type_005.
            APPEND INITIAL LINE TO lrs_potype_005 ASSIGNING FIELD-SYMBOL(<lst_potype_005>).
            <lst_potype_005>-sign   = <lst_const_value_005>-sign.
            <lst_potype_005>-option = <lst_const_value_005>-opti.
            <lst_potype_005>-low    = <lst_const_value_005>-low.
            <lst_potype_005>-high   = <lst_const_value_005>-high.
          WHEN OTHERS.
*         Nothing to do
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF.
* End   of ADD:OTCM-54171:NPALLA:19-MAY-2022:ED2K927337

CLEAR:
*       vbrk-kdgrp,                                    "Customer Group
       vbrk-inco1,                                    "Incoterms (Part 1)
       vbrk-inco2,                                    "Incoterms (Part 2)
       vbrk-pltyp,                                    "Price List Type
       vbrk-regio,                                    "Region (State, Province, County)
       vbrk-konda,                                    "Price group (customer)
       vbrk-land1,                                    "Country of Destination
       vbrk-stceg_l,                                  "Country of Sales Tax ID Number
*      Begin of ADD:ERP-5412:WROY:04-Dec-2017:ED2K909701
       vbrk-stceg_h,                                  "Origin of sales tax ID number
       vbrk-stceg,                                    "VAT Registration Number
*      End   of ADD:ERP-5412:WROY:04-Dec-2017:ED2K909701
       vbrk-landtx.                                   "Tax departure country

* Begin of ADD:ERP-3854:WROY:09-AUG-2017:ED2K907840
* Populate Combination criteria in the billing document
IF vbrk-zukri IS INITIAL.
  vbrk-zukri = vbkd-bstkd.                            "Customer purchase order number
ELSE.
  CONCATENATE vbrk-zukri
              vbkd-bstkd                              "Customer purchase order number
         INTO vbrk-zukri.

ENDIF.
* End   of ADD:ERP-3854:WROY:09-AUG-2017:ED2K907840
* Begin of ADD:ERPM-16159:SGUDA:08-JUNE-2020:ED2K918399
IF vbkd-bstkd IS INITIAL.
  CONCATENATE vbrk-zukri
              vbkd-vbeln                              "Sales and Distribution Document Number
         INTO vbrk-zukri.
ENDIF.
* End of ADD:ERPM-16159:SGUDA:09-JUNE-2020:ED2K918399
*Begin of ADD:ERP-6317:Agudurkhad:21-June-2018:ED2K912176
IF vbak-auart = c_auart.
*Commented below Logic due to standard functionality is not deleting entries from VKDFS table
*and its appear in VF04 as a pending for Invoicing
*  vbrp-vgbel = vbap-vgbel.
*  vbrp-vgpos = vbap-vgpos.
*  vbrp-vgtyp = vbap-vgtyp.

*  CLEAR vbrk-zukri.
    vbrk-zukri = vbak-vbeln.                                  "ED1K909465/ED1K912128  line added
ENDIF.

*End of ADD:ERP-6317:Agudurkhad:21-June-2018:ED2K912176

* Begin of ADD:OTCM-54171:NPALLA:19-MAY-2022:ED2K927337
*IF vbak-auart = c_auart.
*IF vbak-auart = c_auart OR                  " Order Type
*  ( vbak-auart IN lrs_ordtype_005 AND       " Order Type ++
*    vbak-bsark IN lrs_potype_005 ).         " PO Type    ++

*IF ( vbak-auart IN lrs_ordtype_005 AND       " Order Type ++
*    vbak-bsark IN lrs_potype_005 ).         " PO Type    ++
*
*    vbrk-zukri = vbak-vbeln.                                  "ED1K909465/ED1K912128  line added
*
** For the First Order
*  IF lsv_vbeln_005 IS INITIAL.
*    lsv_vbeln_005 = vbak-vbeln.
*  ELSEIF lsv_vbeln_005 NE vbak-vbeln.
*  "For the Subsequent Orders if any.
*    lsv_vbeln_005 = vbak-vbeln.
*    CLEAR: lsv_adrnr_005.
*  ENDIF.
*
** To Avoid the Split based on Ship-To address Number, Copy the First Ship-To address to all the Subsequent lines
*  ASSIGN (lv_xvbpak) TO <li_xvbpak_e070_005>.
*  li_xvbpak_005[] = <li_xvbpak_e070_005>.
*  LOOP AT li_xvbpak_005 ASSIGNING FIELD-SYMBOL(<lfs_xvbpak_005>) WHERE parvw = lc_ship_to. "Ship-To
*    "First VBPA Ship-To line, Capture the address.
**    IF lsv_adrnr_005 IS INITIAL AND ( lsv_shipto_005 IS INITIAL OR lsv_shipto_005 NE <lfs_xvbpak_005>-kunnr ).
*    IF lsv_adrnr_005 IS INITIAL.
*      lsv_adrnr_005 = <lfs_xvbpak_005>-adrnr.
**      lsv_shipto_005 = <lfs_xvbpak_005>-kunnr.
*    ELSE.
*    "For the subsequent Ship-To lines, copy the first line Ship-To address number
*      <lfs_xvbpak_005>-adrnr = lsv_adrnr_005.
*    ENDIF.
*  ENDLOOP.
*  <li_xvbpak_e070_005> = li_xvbpak_005[].
*
*ENDIF.
* End   of ADD:OTCM-54171:NPALLA:19-MAY-2022:ED2K927337
