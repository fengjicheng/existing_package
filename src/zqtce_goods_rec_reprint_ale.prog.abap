*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_GOODS_REC_REPRINT_F00
* REPORT DESCRIPTION:    Include for subroutine
* DEVELOPER:             Pavan Bandlapalli (PBANDLAPAL)
* CREATION DATE:         23-OCT-2017
* OBJECT ID:             E143
* TRANSPORT NUMBER(S):   ED2K908861
* DESCRIPTION:           This program is used for processing of the output
*                        type ZALE for account assignments maintained in
*                        ZCACONSTANT. This will posts the goods receipt
*                        and inbound Idoc is created.
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
*& Report  ZQTCE_GOODS_REC_REPRINT_ALE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtce_goods_rec_reprint_ale.

**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_goods_rec_reprint_top.

*********Subroutine for this report
INCLUDE zqtcn_goods_rec_reprint_f00.

*---------------------------------------------------------------------*
*       FORM F_ALE_PROCESSING                                           *
*---------------------------------------------------------------------*
*       entry-point used from program RSNASTED for medium 'A'         *
*---------------------------------------------------------------------*
*  -->  FP_US_SCREEN for use in future                                   *
*  <--  FP_RC      returncode                                            *
*---------------------------------------------------------------------*
FORM f_ale_processing USING fp_rc
                            fp_us_screen.                   "#EC CALLED

  fp_rc = 0.

  PERFORM f_goods_movement_reprint USING nast.

  fp_rc = v_retcode.
ENDFORM.
