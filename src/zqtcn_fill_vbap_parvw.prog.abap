*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILL_VBAP_MVGR3
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILL_VBAP_KDMAT (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: If Order Type ZACO and Partner_university is found
*                      from Material classication class type '001' then
*                      update that vendor to partner function(VBPA)
* DEVELOPER: Venkata Durga Rao P(VDPATABALL)
* CREATION DATE: 08/22/2019
* OBJECT ID: E215
* TRANSPORT NUMBER(S): ED2K915925
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K916423
* REFERENCE NO:ERPM 3368
* DEVELOPER:MIMMADISET
* DATE:10/11/2019
* DESCRIPTION:Issue with duplicate entries are adding to table XVBPA for partner ZX
*----------------------------------------------------------------------*

DATA:lv_vendorno TYPE  lifnr,
     lst_lfa1    TYPE lfa1.
CONSTANTS: lc_devid_e215   TYPE zdevid VALUE 'E215',                     "Development ID
           lc_charact_part TYPE atnam  VALUE 'PARTNER_UNIVERSITY',
           lc_parvw_zx     TYPE parvw  VALUE 'ZX',
           lc_parvw_ag     TYPE parvw  VALUE 'AG',
           lc_insert       TYPE char1  VALUE 'I',
           lc_08           TYPE FEHGR  VALUE '08', "Incompletion procedure for sales document
           lc_li           TYPE NRART  VALUE 'LI'. "Type of partner number

*---Check the Constant table before going to the actual logic wheather Order type is active or not.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e215  "Development ID
  IMPORTING
    ex_constants = li_constants. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
IF li_constants[] IS NOT INITIAL.
  SORT li_constants[] BY param1.
  FREE:lir_auart_range,lir_vkorg_range,lir_spart_range,
       lst_auart_range,lst_vkorg_range,lst_spart_range.
  LOOP AT li_constants[] ASSIGNING FIELD-SYMBOL(<lfs_constant>).
*---Document Type constant value
    IF <lfs_constant>-param1   = lc_auart.
      lst_auart_range-sign   = <lfs_constant>-sign.
      lst_auart_range-option = <lfs_constant>-opti.
      lst_auart_range-low    = <lfs_constant>-low.
      APPEND lst_auart_range TO lir_auart_range.
      CLEAR: lst_auart_range.
**---Sale Org constant value
    ELSEIF <lfs_constant>-param1 = lc_vkorg.
      lst_vkorg_range-sign     = <lfs_constant>-sign.
      lst_vkorg_range-option   = <lfs_constant>-opti.
      lst_vkorg_range-low      = <lfs_constant>-low.
      APPEND lst_vkorg_range TO lir_vkorg_range.
      CLEAR: lst_vkorg_range.
*---Division constant value
    ELSEIF <lfs_constant>-param1 = lc_spart.
      lst_spart_range-sign     = <lfs_constant>-sign.
      lst_spart_range-option   = <lfs_constant>-opti.
      lst_spart_range-low      = <lfs_constant>-low.
      APPEND lst_spart_range TO lir_spart_range.
      CLEAR: lst_spart_range.
    ENDIF. " IF <lfs_constant>-param1 = lc_auart
  ENDLOOP.
ENDIF. " IF li_constants[] IS NOT INITIAL

*--Check the Document Type,Sale Org and Divison
IF vbak-auart IN lir_auart_range
  AND vbak-vkorg IN lir_vkorg_range
  AND vbak-spart IN lir_spart_range.

  FREE:lt_allocvaluesnum,lt_allocvalueschar,lt_allocvaluescurr,lt_return_t,
       lv_objectkey,lv_objecttable,lv_classnum,lv_vendorno,lv_classtype.
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
    READ TABLE  xvbpa  TRANSPORTING NO FIELDS WITH KEY
    posnr = vbap-posnr
    parvw = lc_parvw_zx.
    IF sy-subrc NE 0." BOC-MIMMADISET-ED2K916423
      READ TABLE lt_allocvalueschar INTO lst_allocvalueschar WITH KEY charact = lc_charact_part.
      IF sy-subrc = 0.
        lv_vendorno = lst_allocvalueschar-value_char.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vendorno
          IMPORTING
            output = lv_vendorno.
*---Get the Vendor details
        FREE lst_lfa1.
        SELECT SINGLE * INTO lst_lfa1 FROM lfa1 WHERE lifnr = lv_vendorno.

        IF lst_lfa1 IS NOT INITIAL.
*--- get the customer AG details from below read condition
          READ TABLE  xvbpa  INTO DATA(lst_xvbpa) WITH KEY parvw = lc_parvw_ag.
          IF sy-subrc = 0.
            lst_xvbpa-parvw = lc_parvw_zx.
            lst_xvbpa-stkzn = space.
            lst_xvbpa-updkz = lc_insert.
            lst_xvbpa-posnr = vbap-posnr.
            lst_xvbpa-lifnr = lst_lfa1-lifnr.
            lst_xvbpa-kunnr = space.
            lst_xvbpa-name1 = lst_lfa1-name1.
            lst_xvbpa-land1 = lst_lfa1-land1.
            lst_xvbpa-adrnr = lst_lfa1-adrnr.
            lst_xvbpa-fehgr = lc_08.     "Incompletion procedure for sales document
            lst_xvbpa-nrart = lc_li.     "Type of partner number - Vendor
            APPEND lst_xvbpa TO xvbpa[].
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF."IF sy-subrc NE 0.
  ENDIF.
  FREE:lt_allocvaluesnum,lt_allocvalueschar,lt_allocvaluescurr,lt_return_t,
       lv_objectkey,lv_objecttable,lv_classnum,lv_classtype,lst_lfa1,
       lv_vendorno,lst_xvbpa.
  FREE:lir_auart_range,lir_vkorg_range,lir_spart_range.
ENDIF. "IF vbak-auart IN lir_auart_range.
