*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_VF04_ITEM_CONTROL
* PROGRAM DESCRIPTION: VF04 Item Control
* DEVELOPER:           Siva Guda
* CREATION DATE:       08/12/2018
* OBJECT ID:           E174
* TRANSPORT NUMBER(S): ED2K913013
* CHANGE DESCRIPTION : ZF5 Proforma creation process, to create proforma
*                      based on current design, copy the ZF2 Billing plan
*                      information of respective contract. To achieve this
*                      functionality, below parameter must be adjusted.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

  CONSTANTS:c_fkart  TYPE vbrk-fkart VALUE 'ZF5',        "Billing Doc type
            c_seldat TYPE syst_datum VALUE '00000000'.   " Date

  IF invoice_type EQ c_fkart.
*- "processing proforma document
    READ TABLE xkomfk WITH KEY  fkart = c_fkart TRANSPORTING NO FIELDS.
    IF sy-subrc IS INITIAL.
*- If Proforma (ZF5), modifiy date with initial to refer the billing plan lines data.
      "standard billing job default carry xkomfk-deldat, this must be adjusted for proforma's
      LOOP AT xkomfk ASSIGNING FIELD-SYMBOL(<lstt_xkomfk>) WHERE fkart = c_fkart.
        <lstt_xkomfk>-seldat = c_seldat.
      ENDLOOP.
    ELSE.
      "there's no proforma (ZF5 line) to adjust with dated
    ENDIF.
  ELSE.
    "processing non-proforma document
  ENDIF.
