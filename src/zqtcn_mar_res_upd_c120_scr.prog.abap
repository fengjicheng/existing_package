*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAR_RES_UPD_C120_SCR
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MARKET_REST_UPD_C120
*&*--------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MARKET_REST_UPD_C120
*& PROGRAM DESCRIPTION:   Market Restriction Conversion Selection screen
*& DEVELOPER:             SVISHWANAT
*& CREATION DATE:         03/28/2022
*& OBJECT ID:             C120 / EAM-8340
*& TRANSPORT NUMBER(S):   ED2K926336.
*&--------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-S01.

SELECTION-SCREEN: BEGIN OF BLOCK  b2 WITH FRAME TITLE text-s02.
PARAMETERS:p_kappl  TYPE kappl   DEFAULT 'V',
           p_kschl  TYPE kschl   DEFAULT 'Z003',
           p_table  TYPE tabname DEFAULT 'KOTG501',
           p_test   AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK b2.

SELECTION-SCREEN: BEGIN OF BLOCK  b5 WITH FRAME TITLE text-s05.
PARAMETERS:r_create RADIOBUTTON GROUP rb1 USER-COMMAND ucm DEFAULT 'X',
           r_dele   RADIOBUTTON GROUP rb1.
SELECTION-SCREEN: END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
PARAMETERS: r_pre  RADIOBUTTON GROUP rb2 USER-COMMAND rucomm DEFAULT 'X', "radiobutton for Presentation server
            r_appl RADIOBUTTON GROUP rb2 .                                "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN: BEGIN OF BLOCK  b4 WITH FRAME TITLE text-s04.
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY DEFAULT 'Test.XLS'.
SELECTION-SCREEN: END OF BLOCK b4.

SELECTION-SCREEN: END OF BLOCK b1.
