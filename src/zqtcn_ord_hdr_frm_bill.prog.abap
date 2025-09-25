*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_HDR_FRM_BILL (Include)
* [Called from Sales Orders Data Transfer Routine - 900 (RV45C900)]
* PROGRAM DESCRIPTION: Additional fields for Order Header
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/13/2017
* OBJECT ID:           E070
* TRANSPORT NUMBER(S): ED2K907268
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K912860
* REFERENCE NO:  E070 (ERP-7602)
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08/01/2018
* DESCRIPTION: Additional fields for Order Header
*---------------------------------------------------------------------*
* Begin of ADD:ERP-7602:WROY:01-AUG-2018:ED2K912860
DATA:
  lst_vbak_e070 TYPE vbak.             "Sales Document: Header Data
* End   of ADD:ERP-7602:WROY:01-AUG-2018:ED2K912860

READ TABLE cvbrp ASSIGNING FIELD-SYMBOL(<lst_cvbrp_e070>) INDEX 1.
IF sy-subrc EQ 0.
  vbak-vkbur = <lst_cvbrp_e070>-vkbur. "Sales Office

* Begin of ADD:ERP-7602:WROY:01-AUG-2018:ED2K912860
  IF <lst_cvbrp_e070>-aubel IS NOT INITIAL.
*   Fetch Sales Document: Header Data
    CALL FUNCTION 'SD_VBAK_SELECT'
      EXPORTING
        i_document_number  = <lst_cvbrp_e070>-aubel
      IMPORTING
        e_vbak             = lst_vbak_e070  "Sales Document: Header Data
      EXCEPTIONS
        document_not_found = 1
        OTHERS             = 2.
    IF sy-subrc EQ 0.
      vbak-zzlicyr = lst_vbak_e070-zzlicyr. "License Year
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF <lst_cvbrp_e070>-aubel IS NOT INITIAL
* End   of ADD:ERP-7602:WROY:01-AUG-2018:ED2K912860
ENDIF. " IF sy-subrc EQ 0
