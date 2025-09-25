*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCE_SDBILLDL (Subroutinenpool)
* PROGRAM DESCRIPTION: Maintain Selection Texts for VF04 transaction
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/11/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
PROGRAM zqtce_sdbilldl.

*&---------------------------------------------------------------------*
*&      Form  F_SEL_SCREEN_TEXTS
*&---------------------------------------------------------------------*
*       Selection Screen texts
*----------------------------------------------------------------------*
*      <--FP_V_TEXTB1  Text: Sel Screen Block
*      <--FP_V_TEXTF1  Text: Sel Screen Field (Sales Office)
*----------------------------------------------------------------------*
FORM f_sel_screen_texts CHANGING fp_v_textb1 TYPE any
                                 fp_v_textf1 TYPE any.

  fp_v_textb1 = 'Additional Selection Criteria'(001).
  fp_v_textf1 = 'Sales Office'(002).

ENDFORM.
