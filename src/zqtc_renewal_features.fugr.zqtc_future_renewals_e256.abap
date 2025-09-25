*----------------------------------------------------------------------*
* REPORT NAME:           ZQTC_FUTURE_RENEWALS_E256
* REPORT DESCRIPTION:    Copy of standard FM ISM_SE_CIC_SAMPLE_CREATE_CONTR
*       Calls FIORI application to create Future Renewal Order
*       This FM is being called from CIC0 Tcode
* DEVELOPER:             Prabhu(PTUFARAM)
* CREATION DATE:         10/12/2020
* OBJECT ID:             E256
* TRANSPORT NUMBER(S):   ED2K919885
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_future_renewals_e256 .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IN_KUNNR) TYPE  KUNNR
*"     REFERENCE(IN_CONTRACT_TAB) TYPE  RJKSDORDER2_TAB
*"     REFERENCE(IN_LINE_TAB) TYPE  RJKSECONTRACTCIC_TAB
*"  EXPORTING
*"     REFERENCE(OUT_LINE_TAB) TYPE  RJKSECONTRACTCIC_TAB
*"     REFERENCE(OUT_CHANGED_BOR_OBJECTS_TAB) TYPE  TRL_BORID
*"--------------------------------------------------------------------
************************************************************************
* Transaction is activated via call transaction. Subsequently, a
* Unlimited consecutive item.
*----------------------------------------------------------------
  DATA : obj_launch TYPE REF TO zcl_launch_ui5.
*--*Create Object
  CREATE OBJECT obj_launch.
*--*Call Method
  CALL METHOD obj_launch->future_renewal_app_launch
    EXPORTING
      im_kunnr = in_kunnr.

ENDFUNCTION.
