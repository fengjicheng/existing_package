*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCR_CONSOLIDATED_NOTICE_F043
* PROGRAM DESCRIPTION:Consolidated Renewal Notice
* DEVELOPER:          SAYANDAS(Sayantan Das)
* CREATION DATE:      08-MAY-2018
* OBJECT ID:          F043
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912554
* REFERENCE NO: ERP-7539
* DEVELOPER: Monalisa Dutta
* DATE: 09-Jun-2018
* DESCRIPTION: Addition of email address in detach text
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912556
* REFERENCE NO: CR# 6301
* DEVELOPER: Monalisa Dutta
* DATE: 09-Jun-2018
* DESCRIPTION: Addition of various texts like title description etc.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
REPORT zqtcr_consolidated_notice_f043 MESSAGE-ID zqtc_r2.

*===================================================================*
* Includes
*===================================================================*
*Include for Global Data Declaration
INCLUDE zqtcn_consolidated_notice_top. " Include ZQTCN_CONSOLIDATED_NOTICE_TOP

*Include for sub-routines
INCLUDE zqtcn_consolidated_notice_f00. " Include ZQTCN_CONSOLIDATED_NOTICE_F00

*---------------------------------------------------------------------*
*       FORM ENTRY                                                    *
*---------------------------------------------------------------------*
FORM f_entry_adobe_form                  "#EC CALLED
  USING v_returncode        TYPE sysubrc " Return Code
        v_screen            TYPE char1.  " Screen of type CHAR1

  CLEAR v_returncode.

  v_screen_display = v_screen.
  PERFORM f_processing_form CHANGING v_returncode.

ENDFORM. "F_ENTRY_ADOBE_FORM
