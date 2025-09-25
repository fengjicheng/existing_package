*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCN_REMINDER_FORM_SEL
* PROGRAM DESCRIPTION:   Program to send advance proforma reminders
* DEVELOPER:             GKINTALI
* CREATION DATE:         25/10/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .

**PARAMETERS: p_vkorg TYPE vkorg OBLIGATORY,  " Sales Organization
**            p_fkart TYPE fkart OBLIGATORY.  " Billing Type
SELECT-OPTIONS:
  s_vkorg  FOR v_vkorg OBLIGATORY,   " Sales Organization
  s_fkart  FOR v_fkart OBLIGATORY,   " Billing Type
  s_fkdat  FOR v_fkdat,              " Billing date for billing index and printout
  s_kunrg  FOR v_kunrg,              " Payer
  s_vbeln  FOR v_vbeln,              " Billing Document
  s_email  FOR v_email NO INTERVALS OBLIGATORY. " E-Mail Address
SELECTION-SCREEN END OF BLOCK b1.
