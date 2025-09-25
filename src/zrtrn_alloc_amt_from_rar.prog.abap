*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_ALLOC_AMT_FROM_RAR (Include)
*                      [Called from Cond Value Routine 903 (RV64A903)]
* PROGRAM DESCRIPTION: Fetch Allocated Amount from RAR
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/09/2017
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K907161
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_alloc_amt TYPE farr_alloc_amt.                        "Allocated Amount

* Performance Obligations (RAR)
SELECT alloc_amt                                           "Allocated Amount
  FROM farr_d_pob
  INTO lv_alloc_amt
 UP TO 1 ROWS
 WHERE zz_vbeln EQ komp-aubel                              "Reference Sales Document
   AND zz_posnr EQ komp-aupos.                             "reference Sales Document Item
ENDSELECT.
IF sy-subrc EQ 0.
  xkwert = lv_alloc_amt.                                   "Allocated Amount
ENDIF.
