class ZCL_IM_QTCBI_BDCP_BEFORE_W definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BDCP_BEFORE_WRITE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCBI_BDCP_BEFORE_W IMPLEMENTATION.


  METHOD if_ex_bdcp_before_write~filter_bdcpv_before_write.
*----------------------------------------------------------------------*
* PROGRAM NAME:         FILTER_BDCPV_BEFORE_WRITE                      *
* PROGRAM DESCRIPTION:  BADi to determine whether the material type is *
*                       ZJID and if there is any change in the actual  *
*                       goods arrival date. If not then we will        *
*                       clear the change pointer entry to restrict from*
*                       BDCP2 entry.                                   *
* DEVELOPER:            MMUKHERJEE                                     *
* CREATION DATE:        18/04/2017                                     *
* OBJECT ID:            I158                                           *
* TRANSPORT NUMBER(S):  ED2K905426,ED2K905437(C)                       *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

    CONSTANTS:
      lc_wricef_id TYPE zdevid VALUE 'E158', " Development ID
      lc_ser_num   TYPE zsno   VALUE '001'.  " Serial Number

    DATA:
      lv_actv_flag TYPE zactive_flag . " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id
        im_ser_num     = lc_ser_num
      IMPORTING
        ex_active_flag = lv_actv_flag.
    IF lv_actv_flag EQ abap_true.
      INCLUDE zqtcn_digital_media_cp_158 IF FOUND.
    ENDIF. " IF lv_actv_flag EQ abap_true

  ENDMETHOD.
ENDCLASS.
