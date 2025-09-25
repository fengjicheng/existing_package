*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_VF04_ITEM_CONTROL
* DEVELOPER:           Siva Guda
* CREATION DATE:       08/12/2018
* OBJECT ID:           E174
* CHANGE REFERENCE   : ERP-6692
* TRANSPORT NUMBER(S): ED2K913013
* PROGRAM DESCRIPTION: ZF5 Proforma creation process, to create proforma
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

  CONSTANTS:c_fkart  TYPE vbrk-fkart VALUE 'ZF5'.        "Billing Doc type

  IF kom-fkart IS INITIAL.
    "standard billing job doesn't carry the value of kom-fkart
    "but ZF5 need to have value of kom-fkart mapped to get ZF5 created properly
    READ TABLE xkomfk WITH KEY  fkart = c_fkart TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.
      kom-fkart   = c_fkart.
      invoice_type = c_fkart.
      else.
     "Looks like the billing document requested to create is not a ZF5 Proforma
    ENDIF.

  ELSE.
   "May be this execution is not from VF04 T.code or SDBILLDL program
    "if this is happening in VF04, then further evaluation is required
  ENDIF.
