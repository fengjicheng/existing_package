*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DISPLAY_LOG_SCR
*&---------------------------------------------------------------------*


*---------Selection Screen --------------------------------
TABLES:e070v,e070,e07t,adr6.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s00.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s01.
SELECT-OPTIONS: s_trkorr FOR e070-trkorr ,
                s_des    FOR e07t-as4text,
                s_user   FOR e070v-as4user,
                s_date   FOR e070v-as4date.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s02.
PARAMETERS:p_ed1 AS CHECKBOX DEFAULT 'X',
           p_ed2 AS CHECKBOX DEFAULT 'X',
           p_eq1 AS CHECKBOX DEFAULT 'X',
           p_eq2 AS CHECKBOX DEFAULT 'X',
           p_ep1 AS CHECKBOX DEFAULT 'X',
           p_eq3 AS CHECKBOX,
           p_es1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.
*SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s03.
*PARAMETERS:p_dep AS CHECKBOX.
*SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
PARAMETERS:p_disp AS CHECKBOX  DEFAULT 'X',
           p_mail AS CHECKBOX USER-COMMAND  check.
SELECT-OPTIONS:s_email  FOR adr6-smtp_addr NO INTERVALS MODIF ID pat LOWER CASE.
SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN END OF BLOCK b1.
