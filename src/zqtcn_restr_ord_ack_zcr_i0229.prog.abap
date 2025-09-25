*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTR_ORD_ACK_ZCR_I0229
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_RESTR_ORD_ACK_ZCR_I0229(Include)
* PROGRAM DESCRIPTION: Restrict O/P Type ZCR based on conditions
* DEVELOPER          : Prabhu
* CREATION DATE      : 2019-06-07
* OBJECT ID          : I0229 (ERP-7664)
* TRANSPORT NUMBER(S): ED2K915222
*----------------------------------------------------------------------*
DATA:
  lv_fname_xvbak TYPE char40 VALUE '(SAPMV45A)VBAK',             "Sales Document: Header Data
  lv_subrc       TYPE sy-subrc.                                        "To hold sy-subrc value
FIELD-SYMBOLS : <lst_vbak> TYPE vbak.                            "Sales Document: Header Data
*--*Make subrc value zero in order to pass condition type in ideal case.
lv_subrc = 0.
ASSIGN (lv_fname_xvbak) TO <lst_vbak>.
*--*Check if the document type is ZCR maintained in consatnt table
IF <lst_vbak> IS ASSIGNED.
  CALL FUNCTION 'ZQTC_ZCR_IDOC_ACK_VALID_I0229'
    EXPORTING
      im_vbak  = <lst_vbak>
    IMPORTING
      ex_subrc = lv_subrc.
*--*Check billing block
  IF <lst_vbak>-faksk IS NOT INITIAL.
    lv_subrc = 4.
  ENDIF.
ENDIF.

sy-subrc = lv_subrc.
