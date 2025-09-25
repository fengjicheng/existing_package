*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_ITM_FRM_BILL (Include)
* [Called from Sales Orders Data Transfer Routine - 908 (RV45C908)]
* PROGRAM DESCRIPTION: Additional fields for Order Items
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       08/01/2018
* OBJECT ID:           E070 (ERP-7602)
* TRANSPORT NUMBER(S): ED2K912860
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
DATA:
  lst_vbap_e070 TYPE vbap.                       "Sales Document: Item Data

IF cvbrp-aubel IS NOT INITIAL AND
   cvbrp-aupos IS NOT INITIAL.
* Fetch Sales Document: Item Data
  CALL FUNCTION 'SD_VBAP_SELECT'
    EXPORTING
      i_document_number = cvbrp-aubel            "Sales Document
      i_item_number     = cvbrp-aupos            "Sales Document Item
    IMPORTING
      e_vbap            = lst_vbap_e070          "Sales Document: Item Data
    EXCEPTIONS
      item_not_found    = 1
      OTHERS            = 2.
  IF sy-subrc EQ 0.
    vbap-zzdealtyp = lst_vbap_e070-zzdealtyp.    "PQ Deal type
    vbap-zzclustyp = lst_vbap_e070-zzclustyp.    "Cluster type
    vbap-kdmat     = lst_vbap_e070-kdmat.        "Customer Material Number
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF cvbrp-aubel IS NOT INITIAL AND
