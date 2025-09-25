*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POSTING_SPLIT_FI_02 (Include Program)
*               Called from BADI method SET_DOCUMENT_TYPE_SUBSEQ
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1670486
*                      Determine Document Type of Subsequent Documents
*                      being created as a result of Acc document split
*                      (Doc Type should be exact same as "RV" but with
*                      internal number range)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02/23/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904038, ED2K908950, ED2K910296
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

DATA:
  li_constant TYPE zcat_constants.                                   "Constant Values

CONSTANTS:
  lc_prm_dtyp TYPE rvari_vnam VALUE 'DOC_TYPE',                      "Parameter: Document Type
  lc_prm_sbsq TYPE rvari_vnam VALUE 'SUBSEQUENT_DOC'.                "Parameter: Subsequent Document

DATA:
  lv_accit_fi TYPE char30     VALUE '(SAPLFACI)ACCIT_FI'.

FIELD-SYMBOLS:
  <lst_accit> TYPE accit_fi.

* Get Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = c_wricef_id_e123                                  "Development ID: E123
  IMPORTING
    ex_constants = li_constant.                                      "Constant Values

* Get the Document Type
*READ TABLE it_accit_fi ASSIGNING FIELD-SYMBOL(<lst_accit_fi>) INDEX 1.
ASSIGN (lv_accit_fi) TO <lst_accit>.
IF sy-subrc EQ 0.
* Identify the Document Type of the Subsequent Document
  READ TABLE li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)
       WITH KEY param1 = lc_prm_dtyp                                 "Parameter: Document Type
                param2 = lc_prm_sbsq                                 "Parameter: Subsequent Document
                low    = <lst_accit>-blart.                          "Document Type
*               low    = <lst_accit_fi>-blart.                       "Document Type
  IF sy-subrc EQ 0.
    e_document_type_subseq = <lst_constant>-high.                    "Document Type of Subsequent Document
  ENDIF.
ENDIF.
*e_document_type_subseq = c_doc_type_subseq.
