*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_AUTOMATED_LOCKBOX_E097
* REPORT DESCRIPTION:    Program to update Order Item Billing Plan
*                        Billing Date (FPLT-AFDAT) based on selection
*                        screen
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         31/07/2017
* OBJECT ID:             E097(CR# 463)
* TRANSPORT NUMBER(S):   ED2K907624(W)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_AUTOMATED_LOCKBOX_E097
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_automated_lockbox_e097 NO STANDARD PAGE HEADING
                                    MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_automated_lockbox_top. " For top declaration

**Include for Selection Screen
INCLUDE zqtcn_automated_lockbox_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_automated_lockbox_f01. " For subroutines

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.

* Populate constants from ZCACONSTANT table
  PERFORM f_get_constants CHANGING i_constant.

* Populate Selection Screen Default Values
  PERFORM f_populate_defaults USING i_constant
                              CHANGING s_augdt[]
                                       s_umskz[]
                                       s_blart[]
                                       s_fkart[].
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_umskz.
  IF s_umskz IS NOT INITIAL.
    PERFORM f_validate_umskz USING s_umskz[].
  ENDIF. " IF s_umskz IS NOT INITIAL

AT SELECTION-SCREEN ON s_bukrs.
  IF s_bukrs IS NOT INITIAL.
    PERFORM f_validate_bukrs USING s_bukrs[].
  ENDIF. " IF s_bukrs IS NOT INITIAL

AT SELECTION-SCREEN ON s_blart.
  IF s_blart IS NOT INITIAL.
    PERFORM f_validate_blart USING s_blart[].
  ENDIF. " IF s_blart IS NOT INITIAL

AT SELECTION-SCREEN ON s_fkart.
  IF s_fkart IS NOT INITIAL.
    PERFORM f_validate_fkart USING s_fkart[].
  ENDIF. " IF s_fkart IS NOT INITIAL

*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

*Populate final table
  PERFORM f_populate_final_tab USING i_final_tab.

*--------------------------------------------------------------------*
*   END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.

*Display ALV
  IF i_final_tab IS NOT INITIAL.
    PERFORM f_display_output USING i_final_tab.
  ELSE.
*Message: No records to update
    MESSAGE i110(sgt_01).
  ENDIF.
