*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPD_CONDGRP4_FREEGOODS
* PROGRAM DESCRIPTION: To update condition Group4(KDKG4) for free Goods
*                      Item Categories(PSTYV) maintained in ZCACONSTANT.
* DEVELOPER: Pavan Bandlapalli (PBANDLAPAL)
* CREATION DATE: 02-Jan-2017
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K910047, ED2K910049(Cust)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912756
* REFERENCE NO: E172 (ERP-6690)
* DEVELOPER: Writtik Roy (WROY)
* DATE:  2018-07-24
* DESCRIPTION: Determine Customer Condition Group 4 Based on Customer
*              PO Type and Item Category
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914961
* REFERENCE NO: E172 (ERP-7842)
* DEVELOPER: Prabhu (PTUFARAM)
* DATE:  2019-04-24
* DESCRIPTION: Exclude 'Condition Group 4' auto populated for complimentary orders 'ZCOP'*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPD_CONDGRP4_FREEGOODS
*&---------------------------------------------------------------------*

CONSTANTS : lc_devid_e172 TYPE zdevid VALUE 'E172',
            lc_param      TYPE rvari_vnam  VALUE 'AUART_EXCLUDE'.
DATA : lir_auart TYPE sd_auart_ranges.
STATICS: li_const TYPE zcat_constants.
* Begin of DEL:E172:WROY:24-JUL-2018:ED2K912756
*CONSTANTS:
*   lc_devid_i0230  TYPE zdevid VALUE 'I0230'.
*
*STATICS:  li_zcaconst_230     TYPE zcat_constants.       " Local Internal table for ZCACONSTANT entries.
*
** Check if in create or change mode
*IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
*  IF li_zcaconst_230 IS INITIAL.
*    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
*      EXPORTING
*        im_devid     = lc_devid_i0230
*      IMPORTING
*        ex_constants = li_zcaconst_230.
*
*    SORT li_zcaconst_230 BY param1 param2 low.
*  ENDIF.                             "   IF li_itmcat_condgrp4 IS INITIAL.
*
*  IF vbkd-kdkg4 IS INITIAL AND
*     vbkd-posnr IS NOT INITIAL.
*    READ TABLE li_zcaconst_230 INTO DATA(lst_zcaconst_230) WITH KEY param1 = lc_pstyv
*                                                                    param2 = lc_kdkg4
*                                                                    low    = vbap-pstyv BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      vbkd-kdkg4 = lst_zcaconst_230-high.
*    ENDIF.
*  ENDIF.
*ENDIF.      " IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
* End   of DEL:E172:WROY:24-JUL-2018:ED2K912756
* Begin of ADD:E172:CR7842 Prabhu:24-April-2019:ED2K914961
IF li_const[] IS INITIAL.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e172
    IMPORTING
      ex_constants = li_const.
ENDIF.
IF li_const[] IS NOT INITIAL.
  CLEAR : lir_auart[].
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_param.
        APPEND INITIAL LINE TO lir_auart ASSIGNING FIELD-SYMBOL(<lst_auart>).
        <lst_auart>-sign   = <lst_const>-sign.
        <lst_auart>-option = <lst_const>-opti.
        <lst_auart>-low    = <lst_const>-low.
        <lst_auart>-high   = <lst_const>-high.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
ENDIF.
* End of ADD:E172:CR7842 Prabhu:24-April-2019:ED2K914961
* Begin of ADD:E172:WROY:24-JUL-2018:ED2K912756
STATICS:
  li_cond_grp4 TYPE STANDARD TABLE OF zqtc_cond_grp4 INITIAL SIZE 0. "Cust Cond Group 4: Based on Cust PO Type and Item Category

IF t180-trtyp NE chara AND vbak-auart NOT IN lir_auart. "Not in DISPLAY Mode, "Prabhu - Exclude doc types -CR7842 4/24/2019
  IF li_cond_grp4[] IS INITIAL.
*   Fetch details from Cust Cond Group 4: Based on Cust PO Type and Item Category
*   SELECT * is being used since all the fields (except MANDT / Client) will be used
    SELECT *
      FROM zqtc_cond_grp4 " Cust Cond Group 4: Based on Cust PO Type and Item Category
      INTO TABLE li_cond_grp4
     ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      CLEAR: li_cond_grp4.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF li_cond_grp4[] IS INITIAL

* Determine Cust Cond Group 4 based on Cust PO Type and Item Category
  READ TABLE li_cond_grp4 ASSIGNING FIELD-SYMBOL(<lst_cond_grp4>)
       WITH KEY bsark = vbak-bsark                                   "Customer purchase order type
                pstyv = vbap-pstyv                                   "Sales document item category
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    vbkd-kdkg4 = <lst_cond_grp4>-kdkg4.                              "Customer condition group 4
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF t180-trtyp NE 'D'
* End   of ADD:E172:WROY:24-JUL-2018:ED2K912756
