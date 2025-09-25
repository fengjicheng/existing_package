*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SEL_FIELDS_NAME_R112 (Include Program)
* PROGRAM DESCRIPTION: define additional selection Screen fields &Block names
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918376
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

LOOP AT SCREEN.

  %b900053_block_1000 = 'Other Details'.      " Block Name
  %_s_email_%_app_%-text = 'Email'.           " Email Address
  MODIFY SCREEN.

ENDLOOP.
