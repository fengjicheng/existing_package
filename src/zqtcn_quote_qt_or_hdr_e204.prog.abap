*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_QUOTE_QT_OR_HDR (Include)
* [Called from Quotation to Sales Orders Data Transfer Routine - 909 (RV45C909)]
* PROGRAM DESCRIPTION: Copy Routine 101 between ZQT to ZOR on header should
* allow to copy the data in VBKD
* DEVELOPER:           MIMMADISET
* CREATION DATE:       05/21/2019
* OBJECT ID:           E202(DM-1898)
* TRANSPORT NUMBER(S): ED2K915070
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY : Changed the object id from E202 to E204 Because of  conflcit
* REVISION NO: ED2K915130
* REFERENCE NO:  E204/CR-DM-1898
* DEVELOPER:Murali immadisetty(mimmadiset)
* DATE:  05/28/2019
* DESCRIPTION:R2P_QTC_SD_ERP-1898-Po Num and PO type cpy in 909_E204_T2
*----------------------------------------------------------------------*
VBKD-BSTKD = CVBKD-BSTKD. "PO Number
VBKD-BSARK = CVBKD-BSARK. "PO Type.
