*&---------------------------------------------------------------------*
*& Report  ZQTCE_GOODS_REC_OUTBOUND
*&
*&---------------------------------------------------------------------*
* REPORT NAME:           ZQTCE_GOODS_REC_OUTBOUND
* DEVELOPER:             VDPATABALL
* CREATION DATE:         04/28/2020
* OBJECT ID:
* TRANSPORT NUMBER(S):   ED2K918070
* DESCRIPTION:           This program is used for processing of the output
*                        type ZWMB for account assignments maintained in
*                        ZCACONSTANT. This will posts the goods receipt
*                        and Outbound Idoc is created.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtce_goods_rec_outbound.

**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_goods_rec_outbound_top.

*********Subroutine for this report
INCLUDE zqtcn_goods_rec_outbound_f00.


START-OF-SELECTION.
*---------------------------------------------------------------------*
*       FORM F_ALE_PROCESSING                                         *
*---------------------------------------------------------------------*
*       entry-point used from program RSNASTED for medium 'A'         *
*---------------------------------------------------------------------*
*  -->  FP_US_SCREEN for use in future                                *
*  <--  FP_RC      returncode                                         *
*---------------------------------------------------------------------*
FORM f_ale_processing USING fp_rc
                            fp_us_screen.                   "#EC CALLED

  fp_rc = 0.

  PERFORM f_goods_movement_reprint USING nast.
  fp_rc = v_retcode.
ENDFORM.
