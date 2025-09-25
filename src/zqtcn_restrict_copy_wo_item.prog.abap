*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_RESTRICT_COPY_WO_ITEM (Include)
* PROGRAM DESCRIPTION: Restrict creation of multiple Quotations
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 12/15/2017
* OBJECT ID: E070
* TRANSPORT NUMBER(S): ED2K909901
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :
* REFERENCE NO :
* DEVELOPER :
* DATE :
* DESCRIPTION :
*----------------------------------------------------------------------*
IF xvbap[] IS INITIAL.
* Message: There is no data to be copied
  MESSAGE a377(gk).
ENDIF.
