*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_KOMKBV3_FILL_E160 (Include)
*                      [Called from USEREXIT_KOMKBV3_FILL (RVCOMFZZ)]
* PROGRAM DESCRIPTION: Determine Cross Company scenario
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/09/2017
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K907161
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907159
* REFERENCE NO:  INC0193502
* DEVELOPER: Monalisa Dutta
* DATE:  05/07/2018
* DESCRIPTION: Consider specific billing document
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
  li_vbrp_e160 TYPE vbrpvb_t,                             "Billing Item Data
  lv_upd_tsk   TYPE i.

li_vbrp_e160[] = com_vbrp_tab[].                           "Billing Item Data
**BOC by MODUTTA:: TR#ED1K907159:: 05/07/2018 :: INC0193502
DELETE li_vbrp_e160 WHERE vbeln <> com_vbrk-vbeln.
**EOC by MODUTTA:: TR#ED1K907159:: 05/07/2018 :: INC0193502
IF li_vbrp_e160[] IS NOT INITIAL.
  SORT li_vbrp_e160 BY werks.
  DELETE ADJACENT DUPLICATES FROM li_vbrp_e160 COMPARING werks.

* Details of Plants/Branches and Valuation areas
  SELECT t001w~werks,                                      "Plant
         t001w~bwkey,                                      "Valuation Area
         t001k~bukrs                                       "Company Code
    FROM t001w INNER JOIN t001k
      ON t001w~bwkey = t001k~bwkey
    INTO TABLE @DATA(li_t001wk_e160)
     FOR ALL ENTRIES IN @li_vbrp_e160
   WHERE t001w~werks EQ @li_vbrp_e160-werks.               "Plant
  IF sy-subrc EQ 0.
    SORT li_t001wk_e160 BY werks.
  ENDIF.
ENDIF.

LOOP AT com_vbrp_tab ASSIGNING FIELD-SYMBOL(<lst_vbrp_e160>)
**BOC by MODUTTA:: TR#ED1K907159:: 05/07/2018 :: INC0193502
  WHERE vbeln = com_vbrk-vbeln.
**EOC by MODUTTA:: TR#ED1K907159:: 05/07/2018 :: INC0193502
* Fetch the Compnay Code of the Plant
  READ TABLE li_t001wk_e160 ASSIGNING FIELD-SYMBOL(<lst_li_t001wk_e160>)
       WITH KEY werks = <lst_vbrp_e160>-werks
       BINARY SEARCH.
  IF sy-subrc EQ 0 AND
*    Compare the Company Codes
     <lst_li_t001wk_e160>-bukrs NE com_kbv3-bukrs.
    com_kbv3-cross_comp = abap_true.
    EXIT.
  ENDIF.
ENDLOOP.
