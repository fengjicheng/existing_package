*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_PROD_LISTING_EXCL_E257(Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMPG(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      listing or exclusion.
* DEVELOPER: Siva Guda (sguda)
* CREATION DATE:   07/29/2020
* OBJECT ID: E257
* TRANSPORT NUMBER(S): ED2K919014
*----------------------------------------------------------------------*
DATA : lv_ismmediatype TYPE mara-ismmediatype.
*- To Get Media Type for Material
SELECT SINGLE ismmediatype FROM mara
                           INTO lv_ismmediatype
                           WHERE matnr = vbap-matnr.
*- Checking Media type is exited ot not
IF sy-subrc EQ 0.
*- Populate to Material Listing/Exclusion - Item
kompg-zzismmediatype = lv_ismmediatype.                     " Media Type

ENDIF.
*- Clear the Varible
CLEAR lv_ismmediatype.
