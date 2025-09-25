*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MISSING_FIELDS_SUB_ORD (Include)
* PROGRAM DESCRIPTION: Include for Additional values in Outbound IDOC
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   30/08/2017
* OBJECT ID: I0229
* TRANSPORT NUMBER(S):  ED2K908278
*----------------------------------------------------------------------*
DATA:
  lst_vbkd_i0229 TYPE vbkd.                           "Sales Document: Business Data

* Populate Customer PO number with the SD Document Number (if blank)
lst_vbkd_i0229-bstkd = dxvbak-vbeln.
MODIFY dxvbkd FROM lst_vbkd_i0229 TRANSPORTING bstkd
 WHERE bstkd IS INITIAL.
