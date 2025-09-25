*&---------------------------------------------------------------------*
* Program Name : ZQTCN_ORD_CONFIRM_SPUR_SS                             *
* REVISION NO:  ED2K925398                                             *
* REFERENCE NO: OTCM-51319                                             *
* DEVELOPER :   Lahiru Wathudura (LWATHUDURA)                          *
* DATE:  01/06/2022                                                    *
* DESCRIPTION: Indian Agents Order confirmation to SPUR team using     *
*              ZIAC Output type                                        *
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-001.
PARAMETERS : p_optyp  TYPE na_kschl DEFAULT text-002 OBLIGATORY,  " Output Type
             p_medium TYPE na_nacha DEFAULT text-003 OBLIGATORY,  " Transmission Medium
             p_docume TYPE vbak-vbeln OBLIGATORY,                 " Sales Document
             p_userid TYPE sy-uname  NO-DISPLAY.                  " GUI USer name
SELECTION-SCREEN END OF BLOCK b01.
