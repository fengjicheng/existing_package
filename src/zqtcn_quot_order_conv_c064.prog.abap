**&---------------------------------------------------------------------*
**&  Include           ZQTCN_QUOT_ORDER_CONV_C064
**&---------------------------------------------------------------------*
**----------------------------------------------------------------------*
** PROGRAM NAME: ZQTCN_QUOT_ORDER_CONV_C064(Include Name)
** PROGRAM DESCRIPTION: Include for Quotation Order creation
** DEVELOPER: ARABANERJE
** CREATION DATE:   07/04/2017
** OBJECT ID: C064
** TRANSPORT NUMBER(S): ED2K905240
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  YYYY-MM-DD
** DESCRIPTION:
**----------------------------------------------------------------------*
CALL FUNCTION 'ZQTC_ORDER_COMMON_OPERATN'
 EXPORTING
   IM_DXVBAK             = dxvbak
   IM_DVTCOMAG           = dvtcomag
   IM_DLAST_DYNPRO       = dlast_dynpro
   IM_DXMESCOD           = dxmescod
 TABLES
   T_DXBDCDATA           = dxbdcdata
   T_DXVBAP              = dxvbap
   T_DXVBEP              = dxvbep
   T_DYVBEP              = dyvbep
   T_DXVBADR             = dxvbadr
   T_DYVBADR             = dyvbadr
   T_DXVBPA              = dxvbpa
   T_DXVBUV              = dxvbuv
   T_DIDOC_DATA          = didoc_data
   T_DXKOMV              = dxkomv
   T_DXVEKP              = dxvekp
   T_DYVEKP              = dyvekp.
