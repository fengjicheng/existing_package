*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_PRODUCT_SUBS_E136_01 (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMPD(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      substitution
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/08/2018
* OBJECT ID: E136
* TRANSPORT NUMBER(S): ED2K912244, ED2K913105
*----------------------------------------------------------------------*
IF vbak-vgbel IS INITIAL OR
   vbap-posnr IS INITIAL.
  kompd-zzkdkg2 = vbkd-kdkg2.                    " Customer condition group 2
  kompd-zzkonda = vbkd-konda.                    " Price group (customer)
ELSE. " ELSE -> IF vbak-vgbel IS INITIAL OR
* Check if the Sales Document Item is being created with reference to
* another Sales Document Item
  READ TABLE cvbap ASSIGNING FIELD-SYMBOL(<lst_cvbap_e136>)
       WITH KEY vbeln = vbak-vgbel
                posnr = vbap-posnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
*   Get Sales Document: Business Data of the Reference Sales Document
    READ TABLE cvbkd ASSIGNING FIELD-SYMBOL(<lst_cvbkd_e136>)
         WITH KEY vbeln = vbak-vgbel
                  posnr = vbap-posnr
         BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE cvbkd ASSIGNING <lst_cvbkd_e136>
           WITH KEY vbeln = vbak-vgbel
                    posnr = posnr_low
           BINARY SEARCH.
    ENDIF. " IF sy-subrc NE 0
    IF sy-subrc EQ 0.
      kompd-zzkdkg2 = <lst_cvbkd_e136>-kdkg2.    " Customer condition group 2
      kompd-zzkonda = <lst_cvbkd_e136>-konda.    " Price group (customer)
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF vbak-vgbel IS INITIAL OR
