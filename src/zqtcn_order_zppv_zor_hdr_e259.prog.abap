*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_ZPPV_ZOR_HDR_E259
*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORDER_ZPPV_ZOR_HDR_E259 (Include)
* Sales office and purchase order type data not carried across to ZOR order - 912 (RV45C912)]
* PROGRAM DESCRIPTION: Copy Routine 101 between ZPPV to ZOR on header should
* allow to copy the data IN VKKD
* DEVELOPER:           MIMMADISET
* CREATION DATE:       10/21/2020
* OBJECT ID:           E259(OTCM-24532)
* TRANSPORT NUMBER(S):ED2K920061
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY :
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
vbAK-vkbur = cvbak-vkbur.                                "Sales Office
vbKD-bsark = cvbKD-bsark.                                "Customer purchase order type
