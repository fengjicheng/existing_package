"Name: \PR:RBDSEMAT\EX:RBDSEMAT_01\EN:OI0_COMMON_RBDSEMAT\SE:END\EI
ENHANCEMENT 0 ZQTCEI_MATMAS_OUTB_EXTENSION.
*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_RBDSEMAT_F4_ENHANCEMENT                  *
* PROGRAM DESCRIPTION:  Include for RBDSEMAT for Enhancing the F4 help *
* DEVELOPER:            Sarada Mukherjee                               *
* CREATION DATE:        01/12/2017                                     *
* OBJECT ID:            I0204                                          *
* TRANSPORT NUMBER(S):  ED2K904106                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*====================================================================*
* Data Declaration
*====================================================================*
  DATA : lv_active_stat TYPE zactive_flag. " Active / Inactive flag
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS : lc_wricefid_i0204 TYPE zdevid VALUE 'I0204', " Constant value for WRICEF (I0204)
              lc_ser_num_001    TYPE zsno   VALUE '001'.   " Serial Number (001)

  CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0204
    im_ser_num     = lc_ser_num_001
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for MATMAS interface.
  INCLUDE zqtcn_rbdsemat_f4_enhancement IF FOUND.
ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true

ENDENHANCEMENT.
