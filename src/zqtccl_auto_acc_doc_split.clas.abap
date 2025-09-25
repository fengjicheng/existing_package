class ZQTCCL_AUTO_ACC_DOC_SPLIT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_FI_BILL_ISSUE_SPLIT .
protected section.
private section.

  constants C_WRICEF_ID_E123 type ZDEVID value 'E123' ##NO_TEXT.
  constants C_SER_NUM_1_E123 type ZSNO value '001' ##NO_TEXT.
  constants C_DOC_TYPE_SUBSEQ type BLART value 'ZW' ##NO_TEXT.
ENDCLASS.



CLASS ZQTCCL_AUTO_ACC_DOC_SPLIT IMPLEMENTATION.


  METHOD if_ex_fi_bill_issue_split~activate_automatic_split.
*----------------------------------------------------------------------*
* PROGRAM NAME: FI_BILL_ISSUE_SPLIT~ACTIVATE_AUTOMATIC_SPLIT (BADI)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1670486
*                      Activate automatic accounting document split
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02/23/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904038
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
    DATA:
      lv_actv_flag_e123 TYPE zactive_flag.            "Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e123
        im_ser_num     = c_ser_num_1_e123
      IMPORTING
        ex_active_flag = lv_actv_flag_e123.

    IF lv_actv_flag_e123 EQ abap_true.
      INCLUDE zqtcn_posting_split_fi_01 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_fi_bill_issue_split~set_document_type_subseq.
*----------------------------------------------------------------------*
* PROGRAM NAME: FI_BILL_ISSUE_SPLIT~SET_DOCUMENT_TYPE_SUBSEQ (BADI)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1670486
*                      Determine Document Type of Subsequent Documents
*                      being created as a result of Acc document split
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02/23/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904038
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
    DATA:
      lv_actv_flag_e123 TYPE zactive_flag.            "Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e123
        im_ser_num     = c_ser_num_1_e123
      IMPORTING
        ex_active_flag = lv_actv_flag_e123.

    IF lv_actv_flag_e123 EQ abap_true.
      INCLUDE zqtcn_posting_split_fi_02 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_fi_bill_issue_split~set_number_of_invoice_items.
*----------------------------------------------------------------------*
* PROGRAM NAME: FI_BILL_ISSUE_SPLIT~SET_NUMBER_OF_INVOICE_ITEMS (BADI)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1670486
*                      Determine No of Inv Items per Split FI Document
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   11/14/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K909450
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
    DATA:
      lv_actv_flag_e123 TYPE zactive_flag.            "Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e123
        im_ser_num     = c_ser_num_1_e123
      IMPORTING
        ex_active_flag = lv_actv_flag_e123.

    IF lv_actv_flag_e123 EQ abap_true.
      INCLUDE zqtcn_posting_split_fi_05 IF FOUND.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
