class ZQTCCL_TAX1_XTXIT_SET definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_TAX1_XTXIT_SET .
protected section.
private section.

  constants C_WRICEF_ID_E123 type ZDEVID value 'E123' ##NO_TEXT.
  constants C_SER_NUM_2_E123 type ZSNO value '002' ##NO_TEXT.
  constants C_AWTYP_VBRK type AWTYP value 'VBRK' ##NO_TEXT.
  constants C_PRM_NOII type RVARI_VNAM value 'NUMB_OF_INV_ITEMS' ##NO_TEXT.
  constants C_PRM_BSTR type RVARI_VNAM value 'BUSINESS_TRAN' ##NO_TEXT.
  data R_BUS_TRAN type ISSR_R_GLVOR .
ENDCLASS.



CLASS ZQTCCL_TAX1_XTXIT_SET IMPLEMENTATION.


  METHOD if_ex_tax1_xtxit_set~set_document_compress.
*----------------------------------------------------------------------*
* PROGRAM NAME: BADI_TAX1_XTXIT_SET~SET_DOCUMENT_COMPRESS (BADI)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1482786
*                      Activate automatic accounting document split
*                      (Tax Summarization)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/10/2017
* OBJECT ID: E123
* TRANSPORT NUMBER(S): ED2K908916
*----------------------------------------------------------------------*
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
        im_ser_num     = c_ser_num_2_e123
      IMPORTING
        ex_active_flag = lv_actv_flag_e123.

    IF lv_actv_flag_e123 EQ abap_true.
      INCLUDE zqtcn_posting_split_fi_04 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_tax1_xtxit_set~xtxit_set.
*----------------------------------------------------------------------*
* PROGRAM NAME: BADI_TAX1_XTXIT_SET~XTXIT_SET (BADI)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1482786
*                      Activate automatic accounting document split
*                      (Tax Summarization)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/10/2017
* OBJECT ID: E123
* TRANSPORT NUMBER(S): ED2K908916
*----------------------------------------------------------------------*
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
        im_ser_num     = c_ser_num_2_e123
      IMPORTING
        ex_active_flag = lv_actv_flag_e123.

    IF lv_actv_flag_e123 EQ abap_true.
      INCLUDE zqtcn_posting_split_fi_03 IF FOUND.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
