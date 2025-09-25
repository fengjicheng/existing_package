*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_RENEWAL_E245
*&---------------------------------------------------------------------*
* PROGRAM DESCRIPTION : During the renewal process changeCVBAP-UEPOS as zero
* DEVELOPER           : mimmadiset(murali)
* CREATION DATE       : 02-June-2020
* OBJECT ID           : E245
* TRANSPORT NUMBER(S) : ED2K918348
* DESCRIPTION:         During the renewal process using tcode VA46, we want to copy 1 line item
*from the new partner contract to a new contract document for the renewal,
*but we want to copy only the Partner Fee material.
*The partner fee material happens to be part of the New Partner BOM.
*Therefore, SAP is forcing the BOM header material to be copied as well,
*but this will disrupt our pricing strategy and is not wanted.
  DATA:li_constants_E245         TYPE zcat_constants,    "Constant Values
       lir_auart_range_e245 TYPE fip_t_auart_range,
       lir_vkorg_range_e245 TYPE fip_t_vkorg_range,
       lir_vtweg_range_e245 TYPE fip_t_vtweg_range,
       lir_pstyv_range_e245 TYPE ism_pstyv_range_tab,
       lir_spart_range_e245 TYPE fip_t_spart_range.

  CONSTANTS: lc_devid_e245 TYPE zdevid        VALUE 'E245',                     "Development ID
             lc_auart_e245 TYPE rvari_vnam    VALUE 'AUART',
             lc_vkorg_e245 TYPE rvari_vnam    VALUE 'VKORG',
             lc_vtweg_e245 TYPE rvari_vnam    VALUE 'VTWEG',
             lc_spart_e245 TYPE rvari_vnam    VALUE 'SPART',
             lc_pstyv_e245 TYPE rvari_vnam    VALUE 'PSTYV'.
*---Check the Constant table before going to the actual logic wheather Order type is active or not.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e245  "Development ID
    IMPORTING
      ex_constants = li_constants_E245. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
  IF li_constants_E245[] IS NOT INITIAL.
    SORT li_constants_E245[] BY param1.
    FREE:lir_auart_range_e245,lir_vkorg_range_e245,
         lir_spart_range_e245,lir_vtweg_range_e245,lir_pstyv_range_e245.
    LOOP AT li_constants_E245[] ASSIGNING FIELD-SYMBOL(<lfs_constant_e245>).
*---Document Type constant value
      IF <lfs_constant_e245>-param1   = lc_auart_e245.
        APPEND INITIAL LINE TO lir_auart_range_e245 ASSIGNING FIELD-SYMBOL(<lst_auart_range>).
        <lst_auart_range>-sign   = <lfs_constant_e245>-sign.
        <lst_auart_range>-option = <lfs_constant_e245>-opti.
        <lst_auart_range>-low    = <lfs_constant_e245>-low.
**---Sale Org constant value
      ELSEIF <lfs_constant_e245>-param1 = lc_vkorg_e245.
        APPEND INITIAL LINE TO lir_vkorg_range_e245 ASSIGNING FIELD-SYMBOL(<lst_vkorg_range>).
        <lst_vkorg_range>-sign     = <lfs_constant_e245>-sign.
        <lst_vkorg_range>-option   = <lfs_constant_e245>-opti.
        <lst_vkorg_range>-low      = <lfs_constant_e245>-low.
*---Division constant value
      ELSEIF <lfs_constant_e245>-param1 = lc_spart_e245.
        APPEND INITIAL LINE TO lir_spart_range_e245 ASSIGNING FIELD-SYMBOL(<lst_spart_range>).
        <lst_spart_range>-sign     = <lfs_constant_e245>-sign.
        <lst_spart_range>-option   = <lfs_constant_e245>-opti.
        <lst_spart_range>-low      = <lfs_constant_e245>-low.
*---Dist channgel
      ELSEIF <lfs_constant_e245>-param1 = lc_vtweg_e245.
        APPEND INITIAL LINE TO lir_vtweg_range_e245 ASSIGNING FIELD-SYMBOL(<lst_vtweg_range>).
        <lst_vtweg_range>-sign     = <lfs_constant_e245>-sign.
        <lst_vtweg_range>-option   = <lfs_constant_e245>-opti.
        <lst_vtweg_range>-low      = <lfs_constant_e245>-low.
*---Item category
      ELSEIF <lfs_constant_e245>-param1 = lc_pstyv_e245.
        APPEND INITIAL LINE TO lir_pstyv_range_e245 ASSIGNING FIELD-SYMBOL(<lst_pstyv_range>).
        <lst_pstyv_range>-sign     = <lfs_constant_e245>-sign.
        <lst_pstyv_range>-option   = <lfs_constant_e245>-opti.
        <lst_pstyv_range>-low      = <lfs_constant_e245>-low.
      ENDIF. " IF <lfs_constant>-param1 = lc_auart
    ENDLOOP.
  ENDIF. " IF li_constants_E245[] IS NOT INITIAL

  IF cvbak-vkorg IS NOT INITIAL AND cvbak-vkorg IN lir_vkorg_range_e245 AND
    cvbak-vtweg IS NOT INITIAL AND cvbak-vtweg IN lir_vtweg_range_e245 AND
    cvbak-spart IS NOT INITIAL AND cvbak-spart IN lir_spart_range_e245 AND
    cvbak-auart IS NOT INITIAL AND cvbak-auart IN lir_auart_range_e245 AND
    cvbap-pstyv IS NOT INITIAL AND cvbap-pstyv IN lir_pstyv_range_e245.
    CLEAR:cvbap-uepos.
  ENDIF.
