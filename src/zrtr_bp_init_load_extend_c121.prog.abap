*----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_EXTEND_C121
* PROGRAM DESCRIPTION:   Program to transfer Business partners
*                        from file and this program is copy of
*                        ZRTR_BP_INIT_LOAD_EXTEND
* DEVELOPER:             Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:         04/29/2022
* OBJECT ID:             C121
* TRANSPORT NUMBER(S):   ED2K927116
*----------------------------------------------------------------------*

REPORT zrtr_bp_init_load_extend_c121.


INCLUDE zrtr_bp_init_load_ext_c121_top IF FOUND. "Data declaration

INCLUDE zrtr_bp_init_load_ext_c121_scr IF FOUND. "Selection screen

INCLUDE zrtr_bp_init_load_ext_c121_f01 IF FOUND. "Subroutines

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM get_filename CHANGING p_file.

*====================================================================*
*AT SELECTION SCREEN
*====================================================================*
AT SELECTION-SCREEN.

** To Validate Input File
  PERFORM f_validate_file USING p_file.

START-OF-SELECTION.

  PERFORM get_data_from_file.

END-OF-SELECTION.
  IF sy-batch = space.
    PERFORM display_data.
  ELSE.
    PERFORM bp_create.
    PERFORM log_message.
  ENDIF.
