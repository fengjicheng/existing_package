*&--------------------------------------------------------------------------------*
*&  Include       ZQTCN_APL_MATNR_EXCL_E502                                       *
*&--------------------------------------------------------------------------------*
* REVISION NO   : ED2K926532                                                      *
* REFERENCE NO  : EAM111 / E502                                                   *
* DEVELOPER     : Sivarami Isiredddy(SISIREDDY)                                   *
* DATE          : 04/01/2022                                                      *
* PROGRAM NAME  : ZQTCN_APL_MATNR_EXCL_E502                                       *
* DESCRIPTION   : Automatic_Delivery Block_Rejection_Rules when creating the Sales*
*                 Order and avoid the standard error Material exluded             *
*---------------------------------------------------------------------------------*
* Data declerations
DATA:lir_auart_range_e502 TYPE fip_t_auart_range,
     lir_vkorg_range_e502 TYPE fip_t_vkorg_range,
     lir_vtweg_range_e502 TYPE fip_t_vtweg_range,
     lir_spart_range_e502 TYPE fip_t_spart_range,
     li_constant_e502     TYPE zcat_constants.
* Constant declerations
CONSTANTS: lc_dev_e502   TYPE zdevid      VALUE 'E502',
           lc_auart_e502 TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
           lc_vkorg_e502 TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
           lc_vtweg_e502 TYPE rvari_vnam  VALUE 'VTWEG',                    "Parameter: Distribution channnel
           lc_spart_e502 TYPE rvari_vnam  VALUE 'SPART'.                   "Parameter: Division
REFRESH:lir_auart_range_e502,
        lir_vkorg_range_e502,
        lir_vtweg_range_e502,
        lir_spart_range_e502,
        li_constant_e502.

* Fetch Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_dev_e502                         "Development ID
  IMPORTING
    ex_constants = li_constant_e502.                    "Constant Values

* Move the constant values to range tables
LOOP AT li_constant_e502 ASSIGNING FIELD-SYMBOL(<lfs_constants_e502>).
  CASE <lfs_constants_e502>-param1.
    WHEN lc_auart_e502.
      APPEND INITIAL LINE TO lir_auart_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_auart_range_e502>).
      <lfs_auart_range_e502>-sign   = <lfs_constants_e502>-sign.
      <lfs_auart_range_e502>-option = <lfs_constants_e502>-opti.
      <lfs_auart_range_e502>-low    = <lfs_constants_e502>-low.
    WHEN lc_vkorg_e502.
      APPEND INITIAL LINE TO lir_vkorg_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_vkorg_range_e502>).
      <lfs_vkorg_range_e502>-sign   = <lfs_constants_e502>-sign.
      <lfs_vkorg_range_e502>-option = <lfs_constants_e502>-opti.
      <lfs_vkorg_range_e502>-low    = <lfs_constants_e502>-low.
    WHEN lc_vtweg_e502.
      APPEND INITIAL LINE TO lir_vtweg_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_vtweg_range_e502>).
      <lfs_vtweg_range_e502>-sign   = <lfs_constants_e502>-sign.
      <lfs_vtweg_range_e502>-option = <lfs_constants_e502>-opti.
      <lfs_vtweg_range_e502>-low    = <lfs_constants_e502>-low.
    WHEN lc_spart_e502.
      APPEND INITIAL LINE TO lir_spart_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_spart_range_e502>).
      <lfs_spart_range_e502>-sign   = <lfs_constants_e502>-sign.
      <lfs_spart_range_e502>-option = <lfs_constants_e502>-opti.
      <lfs_spart_range_e502>-low    = <lfs_constants_e502>-low.
    WHEN OTHERS.
  ENDCASE.
ENDLOOP.
IF lir_auart_range_e502 IS NOT INITIAL AND lir_spart_range_e502 IS NOT INITIAL
AND lir_vkorg_range_e502 IS NOT INITIAL AND lir_vtweg_range_e502  IS NOT INITIAL.
* Check if current sales order document type, sales organization, distribution channel, division are exists in range tables.
  IF vbak-auart IN lir_auart_range_e502 AND vbak-vkorg IN lir_vkorg_range_e502
    AND vbak-vtweg IN lir_vtweg_range_e502 AND vbak-spart IN lir_spart_range_e502.
    CLEAR:tvak-kalau.
  ENDIF.
ENDIF.
