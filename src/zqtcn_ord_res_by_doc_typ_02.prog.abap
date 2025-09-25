*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ORD_RES_BY_DOC_TYP_02 (Include)
*               Called from "USEREXIT_REFRESH_DOCUMENT(MV45AFZA)"
* PROGRAM DESCRIPTION: Order Reasons by Document Type
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/23/2017
* OBJECT ID: E161
* TRANSPORT NUMBER(S): ED2K906642
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  li_vrm_values TYPE vrm_values.                                     "Value table

CONSTANTS:
  lc_vbak_augru TYPE vrm_id       VALUE 'VBAK-AUGRU'.                "Name of Value Set

* Value Request Manager: Set new Values for Valueset
CALL FUNCTION 'VRM_SET_VALUES'
  EXPORTING
    id              = lc_vbak_augru                                  "Name of Value Set
    values          = li_vrm_values                                  "Value table
  EXCEPTIONS
    id_illegal_name = 1
    OTHERS          = 2.
IF sy-subrc EQ 0.
* Nothing to do
ENDIF.
