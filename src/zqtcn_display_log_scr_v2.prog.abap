*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DISPLAY_LOG_SCR
*&---------------------------------------------------------------------*


*---------Selection Screen --------------------------------
TABLES:e070v,e070,e07t,adr6,zca_tr_log."
"/ibmaccel/ctslog,
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s00.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s01.
SELECT-OPTIONS: s_trkorr FOR e070-trkorr ,
                s_des    FOR e07t-as4text,
                s_user   FOR e070v-as4user,
                s_date   FOR e070v-as4date,
                s_inc FOR zca_tr_log-incident_no.
SELECTION-SCREEN END OF BLOCK b2.

* makro definition
DEFINE scr_line.
  selection-screen begin of line.
  parameters &1 as checkbox user-command setcursor.
  selection-screen: comment 3(21) &5 for field &1,
                    comment 25(6) text-p11 for field &2.
  parameters &2 like tadir-pgmid  default 'R3TR' modif id INP.
  selection-screen comment 37(3) text-p12 for field &3.
  parameters &3 like tadir-object default &4     modif id INP.
  parameters &6 like &7.
  selection-screen end of line.
END-OF-DEFINITION.


SELECTION-SCREEN:BEGIN OF BLOCK b6 WITH FRAME TITLE text-s05.
PARAMETERS:p_rfit TYPE char1 USER-COMMAND rfit.
*SELECTION-SCREEN:END OF BLOCK b6.
*SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s02.
SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_ed1 AS CHECKBOX DEFAULT 'X' USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s10 FOR FIELD p_ed1 MODIF ID trf.
PARAMETERS:p_eds1 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_ed2 AS CHECKBOX DEFAULT 'X' USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s11 FOR FIELD p_ed2 MODIF ID trf.
PARAMETERS:p_eds2 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_eq1 AS CHECKBOX DEFAULT 'X' USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s12 FOR FIELD p_eq1 MODIF ID trf.
PARAMETERS:p_eqs1 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_eq2 AS CHECKBOX DEFAULT 'X' USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s13 FOR FIELD p_eq2 MODIF ID trf.
PARAMETERS:p_eqs2 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_ep1 AS CHECKBOX DEFAULT 'X' USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s14 FOR FIELD p_ep1 MODIF ID trf.
PARAMETERS:p_eps1 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_eq3 AS CHECKBOX  USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s15 FOR FIELD p_eq3 MODIF ID trf.
PARAMETERS:p_eqs3 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.

SELECTION-SCREEN:BEGIN OF LINE.
PARAMETERS:p_es1 AS CHECKBOX USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN: COMMENT 3(21) text-s16 FOR FIELD p_es1 MODIF ID trf.
PARAMETERS:p_ess1 TYPE c AS LISTBOX VISIBLE LENGTH 20 MODIF ID trf.
SELECTION-SCREEN:END OF LINE.
PARAMETERS:p_ddup AS CHECKBOX USER-COMMAND syssel MODIF ID trf.
SELECTION-SCREEN:END OF BLOCK b6.

*SELECTION-SCREEN END OF BLOCK b3.


* selection screen
SELECTION-SCREEN BEGIN OF BLOCK objects WITH FRAME TITLE text-t02.

scr_line  p_check1 p_pgm1 p_obj1 'PROG' text-p01 p_objn1 rseux-cp_value.
scr_line  p_check2 p_pgm2 p_obj2 'FUGR' text-p02 p_objn2 rseux-cf_value.
scr_line  p_check7 p_pgm7 p_obj7 'CLAS' text-p07 p_objn7 seoclass-clsname.
scr_line  p_check3 p_pgm3 p_obj3 'TABL' text-p03 p_objn3 dd02v-tabname.
scr_line  p_check4 p_pgm4 p_obj4 'VIEW' text-p04 p_objn4 dd25l-viewname.
scr_line  p_check6 p_pgm6 p_obj6 'TTYP' text-p06 p_objn6 dd40l-typename.
scr_line  p_check5 p_pgm5 p_obj5 'DTEL' text-p05 p_objn5 dd04v-rollname.

SELECTION-SCREEN BEGIN OF BLOCK b01.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_checka LIKE sctsobject-checkbox  USER-COMMAND setcursor.
SELECTION-SCREEN: COMMENT 3(21) p_objtxa FOR FIELD p_checka,
                  COMMENT 25(6) text-p11 FOR FIELD p_pgmida.
PARAMETERS p_pgmida   LIKE sctsobject-pgmid  MODIF ID inp.
SELECTION-SCREEN  COMMENT 37(3) text-p12 FOR FIELD p_objta.
PARAMETERS p_objta  LIKE sctsobject-object.
PARAMETERS p_objna(120) TYPE c.
PARAMETERS p_onlyca  LIKE sctsobject-only_compl NO-DISPLAY DEFAULT ' '.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_checkb LIKE sctsobject-checkbox  USER-COMMAND setcursor.

SELECTION-SCREEN: COMMENT 3(21) p_objtxb FOR FIELD p_checkb,
                  COMMENT 25(6) text-p11 FOR FIELD p_pgmidb.
PARAMETERS p_pgmidb   LIKE sctsobject-pgmid  MODIF ID inp.
SELECTION-SCREEN  COMMENT 37(3) text-p12 FOR FIELD p_objtb.
PARAMETERS p_objtb  LIKE sctsobject-object.
PARAMETERS p_objnb(120) TYPE c.
PARAMETERS p_onlycb  LIKE sctsobject-only_compl NO-DISPLAY DEFAULT ' '.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b03.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_checkc LIKE sctsobject-checkbox  USER-COMMAND setcursor.

SELECTION-SCREEN: COMMENT 3(21) p_objtxc FOR FIELD p_checkc,
                  COMMENT 25(6) text-p11 FOR FIELD p_pgmidc.
PARAMETERS p_pgmidc   LIKE sctsobject-pgmid  MODIF ID inp.
SELECTION-SCREEN  COMMENT 37(3) text-p12 FOR FIELD p_objtc.
PARAMETERS p_objtc  LIKE sctsobject-object.
PARAMETERS p_objnc(120) TYPE c.
PARAMETERS p_onlycc  LIKE sctsobject-only_compl NO-DISPLAY DEFAULT ' '.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b03.
SELECTION-SCREEN END OF BLOCK objects.




SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
PARAMETERS:p_disp AS CHECKBOX  DEFAULT 'X',
           p_mail AS CHECKBOX USER-COMMAND  check.
SELECT-OPTIONS:s_email  FOR adr6-smtp_addr NO INTERVALS MODIF ID pat LOWER CASE.
SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN END OF BLOCK b1.
