*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_CREATE_UPDATE_MEDIA_ISSUE
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* All the Global Variable has declared here .
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_crt_updt_issues.                        "MESSAGE-ID ..

* INCLUDE LZQTC_CRT_UPDT_ISSUESD...                        "Local class definition

INCLUDE ljpismdc1 IF FOUND.

TYPES:
  BEGIN OF ty_issue_template,
    media_product  TYPE matnr,                             "Media Product
    issue_template TYPE matnr,                             "Issue Template
  END OF ty_issue_template.

CONSTANTS:
  c_issue_template TYPE matnr VALUE '%_TEMP%',             "Pattern: Issue Template
  c_updkz_u        TYPE xfeld VALUE 'U',                   "Update Indicator
  c_user_exit_actv TYPE xfeld VALUE 'A'.                   "User-Exit is Active

DATA:
  i_issue_template TYPE SORTED TABLE OF ty_issue_template INITIAL SIZE 0
                   WITH UNIQUE KEY media_product,
  i_mpop_tab       TYPE mpop_ueb_tt.                       "Forecast Parameters

DATA:
  v_update_ind     TYPE flag.                              "Update indicator
