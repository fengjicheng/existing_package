*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POPULATE_SPL_OFFER
* PROGRAM DESCRIPTION: Default 55(Special Offer) to condition group 4
*                      (VBKD-KDKG4) for Opt In scenario for the free
*                      item when creating a renewal quote.
* DEVELOPER: Anirban Saha (ANISAHA)
* CREATION DATE: 2017-10-02
* OBJECT ID: E095 - ERP 4704
* TRANSPORT NUMBER(S) ED2K908748
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910121
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-01-05
* DESCRIPTION: 1. Logic to avoid LOOP.
*              2. Logic to trigger for Quotation Only
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA: lst_constant TYPE zcast_constant.
* Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
STATICS:
* End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
      li_constant  TYPE zcat_constants.
CONSTANTS : lc_devid_e095 TYPE zdevid      VALUE 'E095',
            lc_kdkg4      TYPE rvari_vnam  VALUE 'KDKG4',
            lc_pstyv      TYPE rvari_vnam  VALUE 'PSTYV',
            lc_create     TYPE t180-trtyp  VALUE 'H',
            lc_change     TYPE t180-trtyp  VALUE 'V'.

* Check if in create or change mode
IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
* Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
  IF li_constant IS INITIAL.
* End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid_e095
      IMPORTING
        ex_constants = li_constant.
* Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
    SORT li_constant BY param1 param2 low.
  ENDIF.
* End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
  IF NOT li_constant IS INITIAL.
*   Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*   LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lst_vbap>).
*   End   of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*   Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
    IF vbkd-posnr IS NOT INITIAL.
*   End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_pstyv
                                                        param2 = lc_kdkg4
*     Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*                                                       low = <lst_vbap>-pstyv
*     End   of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*     Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
                                                        low = vbap-pstyv
      BINARY SEARCH.
*     End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
      IF sy-subrc = 0.
*   Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*       Populate Customer Condition Group 4 for the line item
        vbkd-kdkg4 = lst_constant-high.
      ENDIF.
    ENDIF.
*   End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*   Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
*       READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) WITH KEY posnr = <lst_vbap>-posnr.
*       IF sy-subrc = 0.
** Populate Customer Condition Group 4 for the line item
*         <lst_vbkd>-kdkg4 = lst_constant-high.
*       ENDIF.
*     ENDIF.
*   ENDLOOP.
*   End   of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
  ENDIF.
ENDIF.
