*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_ITEMS(Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMKD(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      substitution.
* DEVELOPER: Chandra Sekhar Panda (cpanda)
* CREATION DATE:   10/18/2016
* OBJECT ID: E136
* TRANSPORT NUMBER(S): ED2K903188
*----------------------------------------------------------------------*

* Local data declaration
FIELD-SYMBOLS:
  <lst_xvbkd> TYPE vbkdvb.

komkd-zzkatr2 = kuagv-katr2.                     " Attribute 2

* Populate Customer purchase order type
READ TABLE xvbkd ASSIGNING <lst_xvbkd>
     WITH KEY vbeln = xvbak-vbeln
              posnr = posnr_low.
IF sy-subrc EQ 0.
  komkd-zzbsark = <lst_xvbkd>-bsark.             " Customer purchase order type
ENDIF. " IF sy-subrc EQ 0
