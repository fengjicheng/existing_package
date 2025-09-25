*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_AGU_FILE_UPLOAD
* PROGRAM DESCRIPTION: This report used to Upload AGU file to AL11
* DEVELOPER:           GKAMMILI
* CREATION DATE:       10/22/2019
* OBJECT ID:           I0368
* TRANSPORT NUMBER(S): ED2K916513
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
REPORT ZQTCR_AGU_FILE_UPLOAD_I0368.
*----------------------------------------------------------------------*
* INCLUDES
*----------------------------------------------------------------------*
*--Data declaration
INCLUDE ZQTCN_AGU_FILE_UPLOAD_TOP.

*--Selection screen
INCLUDE ZQTCN_AGU_FILE_UPLOAD_SCR.

*--Perform for routines
INCLUDE ZQTCN_AGU_FILE_UPLOAD_F01.

INITIALIZATION.
  PERFORM f_init_vales.
*--Value request for presentation server file path
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_cl_fn.
  PERFORM f_get_outputfile.


START-OF-SELECTION.
*-- Upload the file file to application server
  PERFORM f_upload_file.
