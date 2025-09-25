*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILL_VBAP_MVGR3
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILL_VBAP_KDMAT (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: If Order Type ZACO then populated VBAP-KDMAT value
*                       from Material classication class type '001'
* DEVELOPER: Venkata Durga Rao P(VDPATABALL)
* CREATION DATE: 08/22/2019
* OBJECT ID: E214 - ERPM-1452
* TRANSPORT NUMBER(S): ED2K915925
*----------------------------------------------------------------------*

CONSTANTS: lc_devid_e214      TYPE zdevid      VALUE 'E214',                     "Development ID
           lc_charact_shortnm TYPE atnam       VALUE 'MOODLE_SHORTNAME'.         "Charaterstic value -MOODLE_SHORTNAME

*---Check the Constant table before going to the actual logic wheather Order type is active or not.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e214  "Development ID
  IMPORTING
    ex_constants = li_constants. "Constant Values
* Fill the respective entries which are maintain in zcaconstant.
IF li_constants[] IS NOT INITIAL.
  SORT li_constants[] BY param1.
  FREE:lir_auart_range,lir_vkorg_range,lir_spart_range,
       lst_auart_range,lst_vkorg_range,lst_spart_range.
  LOOP AT li_constants[] ASSIGNING FIELD-SYMBOL(<fs_constant>).
*---Document Type constant value
    IF <fs_constant>-param1   = lc_auart.
      lst_auart_range-sign   = <fs_constant>-sign.
      lst_auart_range-option = <fs_constant>-opti.
      lst_auart_range-low    = <fs_constant>-low.
      APPEND lst_auart_range TO lir_auart_range.
      CLEAR: lst_auart_range.
**---Sale Org constant value
    ELSEIF <fs_constant>-param1 = lc_vkorg.
      lst_vkorg_range-sign     = <fs_constant>-sign.
      lst_vkorg_range-option   = <fs_constant>-opti.
      lst_vkorg_range-low      = <fs_constant>-low.
      APPEND lst_vkorg_range TO lir_vkorg_range.
      CLEAR: lst_vkorg_range.
*---Division constant value
    ELSEIF <fs_constant>-param1 = lc_spart.
      lst_spart_range-sign     = <fs_constant>-sign.
      lst_spart_range-option   = <fs_constant>-opti.
      lst_spart_range-low      = <fs_constant>-low.
      APPEND lst_spart_range TO lir_spart_range.
      CLEAR: lst_spart_range.
    ENDIF. " IF <fs_constant>-param1 = lc_auart
  ENDLOOP.
ENDIF. " IF li_constants[] IS NOT INITIAL

*--Check the Document Type,Sale Org and Divison
IF vbak-auart IN lir_auart_range
  AND vbak-vkorg IN lir_vkorg_range
  AND vbak-spart IN lir_spart_range.
  FREE:lt_allocvaluesnum,lt_allocvalueschar,lt_allocvaluescurr,lt_return_t,
        lv_objectkey,lv_objecttable,lv_classnum,lv_classtype.
  lv_objecttable = lc_mara.
  lv_objectkey   = vbap-matnr.
  lv_classnum    = lc_classnum.
  lv_classtype   = lc_classtyp.
*---Get the material classification details
  CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
    EXPORTING
      objectkey       = lv_objectkey
      objecttable     = lv_objecttable
      classnum        = lv_classnum
      classtype       = lv_classtype
    TABLES
      allocvaluesnum  = lt_allocvaluesnum
      allocvalueschar = lt_allocvalueschar
      allocvaluescurr = lt_allocvaluescurr
      return          = lt_return_t.
  IF lt_allocvalueschar IS NOT INITIAL.
    READ TABLE lt_allocvalueschar INTO DATA(lst_allocvalueschar) WITH KEY charact = lc_charact_shortnm.
    IF sy-subrc = 0.
      vbap-kdmat = lst_allocvalueschar-value_char.  " pass the Characterstic value to field VBAP-KDMAT
    ENDIF.
  ENDIF.
  FREE:lt_allocvaluesnum,lt_allocvalueschar,lt_allocvaluescurr,lt_return_t,
        lv_objectkey,lv_objecttable,lv_classnum,lv_classtype.
  FREE:lir_auart_range,lir_vkorg_range,lir_spart_range.
ENDIF. "IF vbak-auart IN lir_auart_range.
