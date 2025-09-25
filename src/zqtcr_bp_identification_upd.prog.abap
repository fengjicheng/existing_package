*&---------------------------------------------------------------------*
*& Report  ZQTCR_BP_IDENTIFICATION_UPD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_BP_IDENTIFICATION_UPD
*& PROGRAM DESCRIPTION:   BPIdentification Mass Upload
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         11/12/2020
*& OBJECT ID:             E344
*& TRANSPORT NUMBER(S): ED2K920308
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_bp_identification_upd NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.

*---Top include
INCLUDE zqtcn_bp_identification_upd_tp.

*---Include for Selection Screen
INCLUDE zqtcn_bp_identification_upd_sr.

*--Form inlude
INCLUDE zqtcn_bp_identification_upd_f1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*---FIle selction Popup screen
  PERFORM f_get_filename CHANGING p_file.

START-OF-SELECTION.
*---Get the file and get the data into internal table

  PERFORM f_get_data_from_file TABLES i_file_data.


END-OF-SELECTION.

  PERFORM f_display_data.
