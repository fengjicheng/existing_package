*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales document header workaerea VBAK and
*                       also in VBAP
* DEVELOPER: Aratrika Banerjee(ARABANERJE)
* CREATION DATE:   10/17/2016
* OBJECT ID: E124
* TRANSPORT NUMBER(S):  ED2K903037
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP
*&---------------------------------------------------------------------*
FIELD-SYMBOLS:
  <lst_vbapvb>   TYPE vbapvb.                         " Document Structure for XVBAP/YVBAP

DATA:
  lv_idtype_fice TYPE bu_id_type,                     " Identification Type
  lv_save_fcode  TYPE char20,                         " Function Code
  lv_promo_flag  TYPE flag.                           " Flag: Promo Code Populate

CONSTANTS:
  lc_devid_e124  TYPE zdevid     VALUE 'E124',        " Development ID: E124
  lc_param1_fice TYPE rvari_vnam VALUE 'ID_FICE_NO',  " Name of Variant Variable
  lc_fcode_prse  TYPE char20     VALUE 'PRSE',        " Func Code: Pricing
  lc_prc_type_c  TYPE knprs      VALUE 'C'.           " Pricing Type: C

IF vbak-kunnr NE *vbak-kunnr.                         " Sold-to Party is changed / newly populated
* Assign the values to the field in the Sales Document Header.
  vbak-zznoreturn = kuagv-zznoreturn.                 " No return
  vbak-zzholdfrom = kuagv-zzholdfrom.                 " Hold Date from
  vbak-zzholdto   = kuagv-zzholdto.                   " Hold Date to
  vbak-zzwhs      = kuagv-zzwhs.                      " Consolidation/Packing list/Price on Packing List

* Get ID Type (FICE Number) from Wiley Application Constant Table
  SELECT low                                          " Lower Value of Selection Condition
    FROM zcaconstant
    INTO lv_idtype_fice                               " Identification Type (FICE Number)
   UP TO 1 ROWS
   WHERE devid  EQ lc_devid_e124                      " Development ID: E124
     AND param1 EQ lc_param1_fice.                    " Name of Variant Variable: ID_FICE_NO
  ENDSELECT.
  IF sy-subrc EQ 0 AND
     lv_idtype_fice IS NOT INITIAL.
*   Fetch FICE Number from BP: ID Numbers
    SELECT idnumber                                   " Identification Number
      FROM but0id
      INTO vbak-zzfice                                " FICE Number
     UP TO 1 ROWS
     WHERE partner EQ kuagv-kunnr                     " Business Partner: Sold-to Party
       AND type    EQ lv_idtype_fice.                 " Identification Type: ZFICE
    ENDSELECT.
    IF sy-subrc NE 0.
      CLEAR: vbak-zzfice.                             " FICE Number
    ENDIF.
  ENDIF.
ENDIF.

*Assign the values to the field in the Sales Document Item.
LOOP AT xvbap ASSIGNING <lst_vbapvb>.
  IF vbak-kunnr NE *vbak-kunnr OR                     " Sold-to Party is changed / newly populated
     <lst_vbapvb>-updkz EQ updkz_new.                 " Newly added line
    IF <lst_vbapvb>-updkz IS INITIAL.                 " The line is not yet changed
      APPEND <lst_vbapvb> TO yvbap.                   " Store Old values
      <lst_vbapvb>-updkz    = updkz_update.           " Update Indicator - U
    ENDIF.

    <lst_vbapvb>-zzshpocanc = kuagv-zzshpocanc.       " Flag: Ship complete or cancel complete
  ENDIF.

  IF vbak-zzpromo NE *vbak-zzpromo OR                 " Promotion Code is changed / newly populated
     <lst_vbapvb>-updkz EQ updkz_new.                 " Newly added line
    IF <lst_vbapvb>-zzpromo IS INITIAL OR             " Promotion Code is not populated
       <lst_vbapvb>-zzpromo EQ *vbak-zzpromo.         " Promotion Code is not overwritten
      IF <lst_vbapvb>-updkz IS INITIAL.               " The line is not yet changed
        APPEND <lst_vbapvb> TO yvbap.                 " Store Old values
        <lst_vbapvb>-updkz  = updkz_update.           " Update Indicator - U
      ENDIF.

      <lst_vbapvb>-zzpromo  = vbak-zzpromo.           " Promotion code
    ENDIF.
  ENDIF.
ENDLOOP. " LOOP AT xvbap INTO lst_vbapvb

* Re-trigger Pricing if Promocode is applied
IF vbak-zzpromo NE *vbak-zzpromo AND                  " Promo Code is Changed / Populated
   xvbap[]      IS NOT INITIAL.                       " Items exist
  lv_save_fcode = fcode.                              " Store current Func Code

  fcode = lc_fcode_prse.                              " Func Code: Pricing
  global_pricing_type = lc_prc_type_c.                " Carry out new pricing
* Header level Pricing
  PERFORM preisfindung_nachbereiten_kopf(sapfv45p).
  fcode = lv_save_fcode.                              " Restore Func Code
  CLEAR: lv_promo_flag,
         global_pricing_type.
ENDIF.
