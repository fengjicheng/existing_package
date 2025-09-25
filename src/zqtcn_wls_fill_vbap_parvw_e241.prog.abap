*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_FILL_VBAP_PARVW_E241
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WLS_FILL_VBAP_PARVW_E241
* PROGRAM DESCRIPTION: Add Forwarding Agent(CR) as Partner Function at document header.
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   05/14/2020
* OBJECT ID: E241(ERPM-11672,ERPM-25987)
* TRANSPORT NUMBER(S):ED2K918215
****************************************************************************

DATA:lv_vendorno_wls TYPE lifnr,
     lst_lfa1_wls    TYPE lfa1.

DATA: lir_auart_range_e241 TYPE fip_t_auart_range,
      lir_vkorg_range_e241 TYPE fip_t_vkorg_range,
      lir_vtweg_range_e241 TYPE fip_t_vtweg_range,
      lir_vsbed_range_e241 TYPE shp_vsbed_range_t,
      lir_spart_range_e241 TYPE fip_t_spart_range.

CONSTANTS: lc_devid_e241    TYPE zdevid        VALUE 'E241',                     "Development ID
           lc_parvw_sp_e241 TYPE parvw         VALUE 'SP',
           lc_parvw_ag_e241 TYPE parvw         VALUE 'AG',
           lc_insert_e241   TYPE updkz         VALUE 'I',
           lc_auart_e241    TYPE rvari_vnam    VALUE 'AUART',
           lc_vkorg_e241    TYPE rvari_vnam    VALUE 'VKORG',
           lc_vtweg_e241    TYPE rvari_vnam    VALUE 'VTWEG',
           lc_spart_e241    TYPE rvari_vnam    VALUE 'SPART',
           lc_vsbed_e241    TYPE rvari_vnam    VALUE 'VSBED',
           lc_lifnr_e241    TYPE rvari_vnam    VALUE 'LIFNR',
           lc_08_e241       TYPE fehgr         VALUE '08', "Incompletion procedure for sales document
           lc_li_e241       TYPE nrart         VALUE 'LI'. "Type of partner number

*---Check the Constant table before going to the actual logic wheather Order type is active or not.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e241  "Development ID
  IMPORTING
    ex_constants = li_constants. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
IF li_constants[] IS NOT INITIAL.
  CLEAR:lst_lfa1_wls,lv_vendorno_wls.
  SORT li_constants[] BY param1.
  FREE:lir_auart_range_e241,lir_vkorg_range_e241,
       lir_spart_range_e241,lir_vtweg_range_e241,lir_vsbed_range_e241.
  LOOP AT li_constants[] ASSIGNING FIELD-SYMBOL(<lfs_constant_e241>).
*---Document Type constant value
    IF <lfs_constant_e241>-param1   = lc_auart_e241.
      APPEND INITIAL LINE TO lir_auart_range_e241 ASSIGNING FIELD-SYMBOL(<lst_auart_range>).
      <lst_auart_range>-sign   = <lfs_constant_e241>-sign.
      <lst_auart_range>-option = <lfs_constant_e241>-opti.
      <lst_auart_range>-low    = <lfs_constant_e241>-low.
**---Sale Org constant value
    ELSEIF <lfs_constant_e241>-param1 = lc_vkorg_e241.
      APPEND INITIAL LINE TO lir_vkorg_range_e241 ASSIGNING FIELD-SYMBOL(<lst_vkorg_range>).
      <lst_vkorg_range>-sign     = <lfs_constant_e241>-sign.
      <lst_vkorg_range>-option   = <lfs_constant_e241>-opti.
      <lst_vkorg_range>-low      = <lfs_constant_e241>-low.
*---Division constant value
    ELSEIF <lfs_constant_e241>-param1 = lc_spart_e241.
      APPEND INITIAL LINE TO lir_spart_range_e241 ASSIGNING FIELD-SYMBOL(<lst_spart_range>).
      <lst_spart_range>-sign     = <lfs_constant_e241>-sign.
      <lst_spart_range>-option   = <lfs_constant_e241>-opti.
      <lst_spart_range>-low      = <lfs_constant_e241>-low.
*---Dist channgel
    ELSEIF <lfs_constant_e241>-param1 = lc_vtweg_e241.
      APPEND INITIAL LINE TO lir_vtweg_range_e241 ASSIGNING FIELD-SYMBOL(<lst_vtweg_range>).
      <lst_vtweg_range>-sign     = <lfs_constant_e241>-sign.
      <lst_vtweg_range>-option   = <lfs_constant_e241>-opti.
      <lst_vtweg_range>-low      = <lfs_constant_e241>-low.
*---Shiping conditions.
    ELSEIF <lfs_constant_e241>-param1 = lc_vsbed_e241.
      APPEND INITIAL LINE TO lir_vsbed_range_e241 ASSIGNING FIELD-SYMBOL(<lst_vsbed_range>).
      <lst_vsbed_range>-sign     = <lfs_constant_e241>-sign.
      <lst_vsbed_range>-option   = <lfs_constant_e241>-opti.
      <lst_vsbed_range>-low      = <lfs_constant_e241>-low.
*--Forwarding Agent number
    ELSEIF <lfs_constant_e241>-param1 = lc_lifnr_e241.
      lv_vendorno_wls = <lfs_constant_e241>-low.
    ENDIF. " IF <lfs_constant>-param1 = lc_auart
  ENDLOOP.
ENDIF. " IF li_constants[] IS NOT INITIAL

*--Check the Document Type,Sale Org and Divison
IF vbak-auart IN lir_auart_range_e241
  AND vbak-vkorg IN lir_vkorg_range_e241
  AND vbak-spart IN lir_spart_range_e241
  AND vbak-vtweg IN lir_vtweg_range_e241
*  AND vbak-vsbed IS NOT INITIAL
  AND lv_vendorno_wls IS NOT INITIAL
  AND vbap-posnr IS INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_vendorno_wls
    IMPORTING
      output = lv_vendorno_wls.
  IF vbak-vsbed IN lir_vsbed_range_e241.
    READ TABLE  xvbpa  TRANSPORTING NO FIELDS WITH KEY
    posnr = vbap-posnr
    parvw = lc_parvw_sp_e241.
    IF sy-subrc NE 0.
*---Get the Vendor details
      SELECT SINGLE * FROM lfa1
                     INTO lst_lfa1_wls
                      WHERE lifnr = lv_vendorno_wls.
      IF lst_lfa1_wls IS NOT INITIAL.
*--- get the customer AG details from below read condition
        READ TABLE  xvbpa  INTO DATA(lst_xvbpa_wls) WITH KEY parvw = lc_parvw_ag_e241.
        IF sy-subrc = 0.
          lst_xvbpa_wls-parvw = lc_parvw_sp_e241.
          lst_xvbpa_wls-stkzn = space.
          lst_xvbpa_wls-updkz = lc_insert_e241.
          lst_xvbpa_wls-posnr = vbap-posnr.
          lst_xvbpa_wls-lifnr = lst_lfa1_wls-lifnr.
          lst_xvbpa_wls-kunnr = space.
          lst_xvbpa_wls-name1 = lst_lfa1_wls-name1.
          lst_xvbpa_wls-land1 = lst_lfa1_wls-land1.
          lst_xvbpa_wls-adrnr = lst_lfa1_wls-adrnr.
          lst_xvbpa_wls-fehgr = lc_08_e241.     "Incompletion procedure for sales document
          lst_xvbpa_wls-nrart = lc_li_e241.     "Type of partner number - Vendor
          APPEND lst_xvbpa_wls TO xvbpa[].
        ENDIF.
      ENDIF.
    ENDIF."IF sy-subrc NE 0.
  ELSE.
    READ TABLE  xvbpa  TRANSPORTING NO FIELDS WITH KEY
    posnr = vbap-posnr
    parvw = lc_parvw_sp_e241.
    IF sy-subrc = 0.
      DELETE xvbpa[] WHERE parvw = lc_parvw_sp_e241 AND lifnr = lv_vendorno_wls.
    ENDIF.
  ENDIF.
  FREE:lir_auart_range_e241,lir_vkorg_range_e241,
       lir_spart_range_e241,lir_vtweg_range_e241,
       lir_vsbed_range_e241.
  CLEAR:lst_lfa1_wls.
ENDIF. "IF vbak-auart IN lir_auart_range.
