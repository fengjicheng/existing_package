*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_RESTRICT_RELEASE_ORD(Include Program)
* PROGRAM DESCRIPTION: Release order creation to check for Delivery/Billing block
* DEVELOPER:           Aratrika Banerjee
* CREATION DATE:       12/29/2016
* OBJECT ID:           E141
* TRANSPORT NUMBER(S): ED2K903803
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908851
* REFERENCE NO: ERP-4747
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  10/05/2017
* DESCRIPTION: As part of requirement Billing block check is not needed.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909406
* REFERENCE NO: ERP-4894
* DEVELOPER: Writtick Roy(WROY)
* DATE:  11/09/2017
* DESCRIPTION: Check Overall status of credit checks
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RESTRICT_RELEASE_ORD
*&---------------------------------------------------------------------*
    bp_subrc = 0.

*   Check Reference Order's Header details
* Begin of Change on 05-Oct-2017 for ERP-4747: TR ED2K908851
*    IF vbak-lifsk IS NOT INITIAL OR
*       vbak-faksk IS NOT INITIAL.
    IF vbak-lifsk IS NOT INITIAL.
* End of Change on 05-Oct-2017 for ERP-4747: TR ED2K908851
      bp_subrc = 1.
    ENDIF.

* Begin of Change on 05-Oct-2017 for ERP-4747: TR ED2K908851
**   Check Reference Order's Line Item details
*    IF vbap-faksp IS NOT INITIAL.
*      bp_subrc = 1.
*    ENDIF.
* End of Change on 05-Oct-2017 for ERP-4747: TR ED2K908851

*   Check Reference Order's Schedule Line details
    IF vbep-lifsp IS NOT INITIAL.
      bp_subrc = 1.
    ENDIF.

*   Begin of ADD:ERP-4894:WROY:09-Nov-2017:ED2K909406
*   Check Overall status of credit checks
    IF vbuk-cmgst CA 'BC'.
      bp_subrc = 1.
    ENDIF.
*   End   of ADD:ERP-4894:WROY:09-Nov-2017:ED2K909406
