*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SEL_FIELDS_R112 (Include Program)
* PROGRAM DESCRIPTION: define additional selection Screen fields
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918376
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*
TABLES :adr6.

SELECTION-SCREEN BEGIN OF BLOCK email WITH FRAME TITLE text-900.

SELECT-OPTIONS: s_email FOR adr6-smtp_addr.         " email address

SELECTION-SCREEN END OF BLOCK email.
