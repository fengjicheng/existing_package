*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_EXT_C121_SCR
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_EXTEND_C121_SCR(INCLUDE)
* PROGRAM DESCRIPTION:   Program to transfer Business partners
*                        from file and this program is copy of
*                        ZRTR_BP_INIT_LOAD_EXTEND
* DEVELOPER:             Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:         04/29/2022
* OBJECT ID:             C121
* TRANSPORT NUMBER(S):   ED2K927116
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:rb_bp_ct RADIOBUTTON GROUP rad1 USER-COMMAND uc1 DEFAULT 'X',
           rb_cp_ct RADIOBUTTON GROUP rad1,
           rb_rp_ct RADIOBUTTON GROUP rad1,
           p_file   LIKE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.
