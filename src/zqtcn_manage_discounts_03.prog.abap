*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_03 (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMK(MV45AFZZ)"
* PROGRAM DESCRIPTION: Replace Pricing Customer Group, Price List
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10-NOV-2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903315
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905909
* REFERENCE NO: ERP-2861
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-JUN-2017
* DESCRIPTION: Performance Fix
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910130
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JAN-2018
* DESCRIPTION: Introduce Buffering Concept
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910573
* REFERENCE NO: ERP-5372
* DEVELOPER: Writtick Roy (WROY)
* DATE:  29-JAN-2018
* DESCRIPTION: Populate Licence ID Group flag depending on Attribute 8
*----------------------------------------------------------------------*
DATA:
  li_const_v TYPE zcat_constants.

DATA:
* Begin of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
* lv_lic_id  TYPE bu_id_type,                              "Identification Type: License ID Group
* lv_id_numb TYPE bu_id_number.                            "Identification Number
* End   of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
* Begin of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573
  lir_attr_8 TYPE RANGE OF katr8 INITIAL SIZE 0.
* End   of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573

CONSTANTS:
  lc_id_e075 TYPE zdevid         VALUE 'E075',             "Development ID
* Begin of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
* lc_param_l TYPE rvari_vnam     VALUE 'LIC_ID_GRP'.       "ABAP: Name of Variant Variable
* End   of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
* Begin of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573
  lc_attr_8  TYPE rvari_vnam     VALUE 'ATTR_8_EAL'.       "ABAP: Name of Variant Variable
* End   of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573

* Begin of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
**Begin of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*STATICS:
**Begin of DEL:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**lst_id_grp TYPE but0id,
**End   of DEL:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**Begin of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
* li_id_grp  TYPE SORTED TABLE OF but0id WITH UNIQUE KEY partner type.
**End   of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**End   of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
* End   of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573

* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_id_e075
  IMPORTING
    ex_constants = li_const_v.

LOOP AT li_const_v ASSIGNING FIELD-SYMBOL(<lst_const>).
  CASE <lst_const>-param1.
*   Begin of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
*   WHEN lc_param_l.                                       "Identification Type: License ID Group
*     lv_lic_id = <lst_const>-low.
*   End   of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
*   Begin of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573
    WHEN lc_attr_8.                                        "Attribute 8 (EAL)
      APPEND INITIAL LINE TO lir_attr_8 ASSIGNING FIELD-SYMBOL(<lst_attr_8>).
      <lst_attr_8>-sign   = <lst_const>-sign.
      <lst_attr_8>-option = <lst_const>-opti.
      <lst_attr_8>-low    = <lst_const>-low.
      <lst_attr_8>-high   = <lst_const>-high.
*   End   of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573

    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.

IF tkomk-kdgrp IS INITIAL.                                 "Customer Group (Ship-to Party)
  tkomk-kdgrp           = kuwev-kdgrp.
ENDIF.

IF tkomk-pltyp IS INITIAL.
  tkomk-pltyp           = kuwev-pltyp.                     "Price list type (Ship-to Party)
ENDIF.

IF tkomk-zzkvgr1 IS INITIAL.
  tkomk-zzkvgr1         = kuagv-kvgr1.                     "Customer group 1 (Sold-to Party)
ENDIF.

* Begin of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
*IF lv_lic_id IS NOT INITIAL.
**Begin of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
**Begin of DEL:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**IF lst_id_grp-partner EQ kuwev-kunnr AND
**   lst_id_grp-type    EQ lv_lic_id.
**End   of DEL:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**Begin of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
* READ TABLE li_id_grp INTO DATA(lst_id_grp)
*      WITH KEY partner = kuwev-kunnr
*               type    = lv_lic_id
*      BINARY SEARCH.
* IF sy-subrc EQ 0.
**End   of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
*   IF lst_id_grp-idnumber IS NOT INITIAL.
*     tkomk-zzlic_id_grp  = abap_true.                     "Licence ID Group (Flag = X)
*   ELSE.
*     tkomk-zzlic_id_grp  = abap_false.                    "Licence ID Group (Flag = X)
*   ENDIF.
* ELSE.
*   lst_id_grp-partner = kuwev-kunnr.
*   lst_id_grp-type    = lv_lic_id.
**End   of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*   SELECT idnumber                                        "Identification Number
*     FROM but0id
*     INTO lv_id_numb
*    UP TO 1 ROWS
*    WHERE partner EQ kuwev-kunnr                          "Business Partner Number: Ship-to Party
*      AND type    EQ lv_lic_id.                           "Identification Type: License ID Group
*   ENDSELECT.
*   IF sy-subrc EQ 0.
*     tkomk-zzlic_id_grp  = abap_true.                     "Licence ID Group (Flag = X)
**Begin of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*     lst_id_grp-idnumber = lv_id_numb.
*   ELSE.
*     CLEAR: lst_id_grp-idnumber.
**End   of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*   ENDIF.
**Begin of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
*   INSERT lst_id_grp INTO TABLE li_id_grp.
**End   of ADD:SAP's Recommendations:WROY:05-JAN-2018:ED2K910130
**Begin of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
* ENDIF.
**End   of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*ENDIF.
* End   of DEL:ERP-5372:WROY:29-Jan-2018:ED2K910573
* Begin of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573
IF kuwev-katr8 IN lir_attr_8.                              "Attribute 8 (Ship-to Party)
  tkomk-zzlic_id_grp  = abap_true.                         "Licence ID Group (Flag = X)
ELSE.
  tkomk-zzlic_id_grp  = abap_false.                        "Licence ID Group (Flag = X)
ENDIF.
* End   of ADD:ERP-5372:WROY:29-Jan-2018:ED2K910573
