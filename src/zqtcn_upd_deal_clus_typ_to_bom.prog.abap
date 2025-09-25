*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPD_DEAL_CLUS_TYP_TO_BOM (Include)
*               Called from "zqtcn_userexit_save_doc_prep (MV45AFZZ)"
* PROGRAM DESCRIPTION: Update PQ Deal Type & Cluster Type for BOM
* components at item level for Subscription Orders
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI/KKR)
* CREATION DATE: 07/09/2018
* OBJECT ID: I0230 - CR#6142
* TRANSPORT NUMBER(s): ED2K912552
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

*Local declarations
DATA: ls_vbap      TYPE vbap,
      lv_bom_posnr TYPE posnr_va.

* Iterating BOM Child items
LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lifs_xvbap>) WHERE uepos IS NOT INITIAL.
  IF lv_bom_posnr <> <lifs_xvbap>-uepos.
    READ TABLE xvbap INTO ls_vbap WITH KEY vbeln = <lifs_xvbap>-vbeln
                                           posnr = <lifs_xvbap>-uepos
                                           BINARY SEARCH.
    IF sy-subrc = 0.
      lv_bom_posnr = ls_vbap-posnr.
    ENDIF.
  ENDIF. " IF lv_bom_posnr <> <lifs_xvbap>-uepos
  IF lv_bom_posnr = <lifs_xvbap>-uepos AND
     ( ls_vbap-zzdealtyp IS NOT INITIAL OR
       ls_vbap-zzclustyp IS NOT INITIAL ).
* Update the zzdealtyp and zzclustyp from BOM header to BOM item
    <lifs_xvbap>-zzdealtyp = ls_vbap-zzdealtyp.
    <lifs_xvbap>-zzclustyp = ls_vbap-zzclustyp.
  ENDIF. " IF lv_bom_posnr = <lifs_xvbap>-uepos AND
ENDLOOP.
