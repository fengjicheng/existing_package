*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_E106_004
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION:DM-1901 Price Group in WOL Orders can not be overridden from customer default
* DEVELOPER: Murali(MIMMADISET)
* CREATION DATE:   24/06/2019
* OBJECT ID: DM-1901 E106
* TRANSPORT NUMBER(S): ED2K915227
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION:BP Relationship validity check for DM-1901 Price Group in WOL Orders
* DEVELOPER: Murali(MIMMADISET)
* CREATION DATE:   07/02/2019
* OBJECT ID: DM-1901 E106
* TRANSPORT NUMBER(S): ED2K915563
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION:SKIP the Relationship validity check for BP
* DEVELOPER: Murali(MIMMADISET)
* CREATION DATE:   08/22/2019
* OBJECT ID: DM-1901 E106
* TRANSPORT NUMBER(S): ED2K915939
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION:SKIP the Relationship validity check for BP
* DEVELOPER: Murali(MIMMADISET)
* CREATION DATE:   08/29/2019
* OBJECT ID: DM-1901 E106
* TRANSPORT NUMBER(S): ED2K916010
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------
*&---------------------------------------------------------------------*
TYPES:BEGIN OF lty_constant,
        devid  TYPE zdevid,             " Development ID
        param1 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
        param2 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
        srno   TYPE tvarv_numb,         " ABAP: Current selection number
        sign   TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
        opti   TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
        low    TYPE salv_de_selopt_low, " Lower Value of Selection Condition
        high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
      END OF lty_constant,
*       Begin of change:MIMMADISET:ED2K915939:CR DM1901
      BEGIN OF lty_bp,
        sign   TYPE tvarv_sign,                                  " Sign
        option TYPE tvarv_opti,                                  " Option
        low    TYPE bu_partner,                                  " BP
        high   TYPE bu_partner,                                  " BP
      END OF lty_bp.
STATICS:li_constant_106   TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0.

DATA: li_relations  TYPE STANDARD TABLE OF bapibus1006_relations
      INITIAL SIZE 0,                                               "Relation cat dates check
      lir_bsark_wol TYPE tdt_rg_bsark,                              "PO types
      lv_mem_name_h TYPE char30,                                    "Memory ID for header
*       Begin of change:MIMMADISET:ED2K915563:CR DM1901
      lv_validflag  TYPE c,                                         "Flag for validating the relationship category
      lv1_reltyp    TYPE bu_reltyp,                                 "Relationship Category
      ltt_bp        TYPE STANDARD TABLE OF lty_bp INITIAL SIZE 0.     "BP table type
*       End of change:MIMMADISET:ED2K915563:CR DM1901
*       Begin of change:MIMMADISET:ED2K915939:CR DM1901

CONSTANTS:lc_bp           TYPE rvari_vnam VALUE 'DUMMY_BP',
          lc_bsark_wol    TYPE rvari_vnam VALUE 'BSARK_WOL',         " ABAP: Name of Variant Variable
          lc_objectid_106 TYPE zdevid     VALUE 'E106',              " Object id
          lc_rel_type     TYPE char20     VALUE '_REL_TYPE_H'.       " Memory ID for header

IF li_constant_106[] IS INITIAL.
* fetch constant table entry for price grp and customer grp
  SELECT devid        " Development ID
         param1       " ABAP: Name of Variant Variable
         param2       " ABAP: Name of Variant Variable
         srno         " ABAP: Current selection number
         sign         " ABAP: ID: I/E (include/exclude values)
         opti         " ABAP: Selection option (EQ/BT/CP/...)
         low          " Lower Value of Selection Condition
         high         " Upper Value of Selection Condition
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE li_constant_106
     WHERE devid    EQ lc_objectid_106
       AND activate EQ abap_true.
  IF sy-subrc EQ 0.
    SORT li_constant_106 BY devid param1 param2 low.
  ENDIF. " IF sy-subrc EQ 0
ENDIF."IF li_constant[] IS INITIAL.
LOOP AT li_constant_106 INTO DATA(lst1_constant)
  WHERE param1 = lc_bsark_wol OR param1 = lc_bp.
  CASE lst1_constant-param1.
    WHEN lc_bsark_wol.
      APPEND INITIAL LINE TO lir_bsark_wol
      ASSIGNING FIELD-SYMBOL(<lst_bsark_wol>).
      <lst_bsark_wol>-sign   = lst1_constant-sign.
      <lst_bsark_wol>-option = lst1_constant-opti.
      <lst_bsark_wol>-low    = lst1_constant-low.
      <lst_bsark_wol>-high   = lst1_constant-high.
*       Begin of change:MIMMADISET:ED2K915939:CR DM1901
    WHEN lc_bp.
      APPEND INITIAL LINE TO ltt_bp
      ASSIGNING FIELD-SYMBOL(<lfs_bp>).
      <lfs_bp>-sign   = lst1_constant-sign.
      <lfs_bp>-option = lst1_constant-opti.
      <lfs_bp>-low    = lst1_constant-low.
      <lfs_bp>-high   = lst1_constant-high.
*       End of change:MIMMADISET:ED2K915939:CR DM1901
  ENDCASE.
ENDLOOP.
"Po type
IF lst_xvbak11-bsark IN lir_bsark_wol AND lir_bsark_wol IS NOT INITIAL.
  " Get the existing relationships of Ship-to WE(BP)
  IF lst_reltyp-partner1 IN ltt_bp." Begin of change:MIMMADISET:ED2K915939:CR DM1901
    " IDoc passes the BP# and check the same bp in zconstant table, if exist skip relationship check.
  ELSE.
    IF lst_reltyp-partner1 IS NOT INITIAL.
      lv1_reltyp =  lst_reltyp-reltyp.
      CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
        EXPORTING
          iv_partner               = lst_reltyp-partner1
          iv_relationship_category = lv1_reltyp
        TABLES
          et_relationships         = li_relations.
      IF li_relations[] IS NOT INITIAL.
*       Begin of change:MIMMADISET:ED2K915563:CR DM1901
* getting the existing Student member relationships from the relations of Ship-to WE(BP).
        LOOP AT li_relations INTO DATA(li_rel).
          IF sy-datum BETWEEN li_rel-validfromdate
                          AND li_rel-validuntildate.
            lv_validflag = abap_true.
            EXIT.
          ENDIF."IF sy-datum BETWEEN li_rel-validfromdate AND li_rel-validuntildate.
        ENDLOOP.
        IF lv_validflag = abap_false.
          MESSAGE e558(zqtc_r2) RAISING user_error WITH lst_reltyp-reltyp.
*         check/extend the validity dates of the relationship. Fail the Idoc
        ENDIF."IF lv_validflag = abap_false.
      ELSE.
        MESSAGE e559(zqtc_r2) RAISING user_error WITH lst_reltyp-reltyp.
*      check/maintain the correct relationship type & in Business partner
*       End of change:MIMMADISET:ED2K915563:CR DM1901
      ENDIF."IF sy-subrc = 0 AND li_relations[] IS NOT INITIAL.
*      Begin of change:MIMMADISET:ED2K916010:CR DM1901
      CONCATENATE segment-docnum lc_rel_type INTO lv_mem_name_h.
      EXPORT lst_reltyp TO MEMORY ID lv_mem_name_h.
*      End of change:MIMMADISET:ED2K915563:CR DM1901
    ENDIF."IF lst_reltyp-partner1 IS NOT INITIAL.
  ENDIF."lst_reltyp-partner1 NOT IN ltt_bp
  "IMPORT statement is written in include ZQTCN_MEMBER_PARTNER_PRICE
ENDIF."lst_xvbak11-bsark IN lir_bsark_wol AND lir_bsark_wol IS NOT INITIAL.
