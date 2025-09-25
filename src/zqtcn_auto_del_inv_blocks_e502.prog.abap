*&--------------------------------------------------------------------------------*
*&  Include      ZQTCN_AUTO_DEL_INV_BLOCKS_E502                                   *
*&--------------------------------------------------------------------------------*
* REVISION NO   : ED2K926532                                                      *
* REFERENCE NO  : EAM111 / E502                                                   *
* DEVELOPER     : Sivarami Isiredddy(SISIREDDY)                                   *
* DATE          : 04/01/2022                                                      *
* PROGRAM NAME  : ZQTCN_AUTO_DEL_INV_BLOCKS_E502                                  *
*                 Called from userexit_save_document_prepare(MV45AFZZ)            *
* DESCRIPTION   : Automatic_Delivery Block_Rejection_Rules when creating the Sales*
*                 Order                                                           *
*---------------------------------------------------------------------------------*
*** Types for KNVV
TYPES:BEGIN OF ty_knvv,
        lifsd TYPE lifsd_v,
        faksd TYPE faksd_v,
      END OF ty_knvv,

      BEGIN OF ty_cdpos,
        fname     TYPE fieldname,
        value_new TYPE cdfldvaln,
        value_old TYPE cdfldvalo,
      END OF ty_cdpos.


* Data declerations
DATA:lir_auart_range_e502 TYPE fip_t_auart_range,
     lir_vkorg_range_e502 TYPE fip_t_vkorg_range,
     lir_vtweg_range_e502 TYPE fip_t_vtweg_range,
     lir_spart_range_e502 TYPE fip_t_spart_range,
     lir_lifsd_range_e502 TYPE RANGE OF lifsd_v,
     lir_faksd_range_e502 TYPE RANGE OF faksd_v,
     li_constant_e502     TYPE zcat_constants.

DATA:lst_knvv  TYPE ty_knvv,
     lst_cdpos TYPE ty_cdpos,
     li_cdpos  TYPE STANDARD TABLE OF ty_cdpos INITIAL SIZE 0.


* Constant declerations
CONSTANTS: lc_dev_e502      TYPE zdevid      VALUE 'E502',
           lc_auart_e502    TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
           lc_vkorg_e502    TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
           lc_vtweg_e502    TYPE rvari_vnam  VALUE 'VTWEG',                    "Parameter: Distribution channnel
           lc_spart_e502    TYPE rvari_vnam  VALUE 'SPART',                    "Parameter: Division
           lc_lifsd_e502    TYPE rvari_vnam  VALUE 'LIFSD',                    "Parameter: Delivery Block
           lc_faksd_e502    TYPE rvari_vnam  VALUE 'FAKSD',                    "Parameter: Delivery Block
           lc_parvw_we_e502 TYPE parvw       VALUE 'WE',                       "Patner Function for Ship To Part
           lc_create_e502   TYPE trtyp       VALUE 'H',                        "Transaction type
           lc_change_e502   TYPE trtyp       VALUE 'V',                        "Transaction type
           lc_zero_e502     TYPE posnr       VALUE '000000',                   "Item Number
           lc_verkbeleg     TYPE cdobjectcl  VALUE 'VERKBELEG',                " Change doc. object
           lc_u_e502        TYPE cdchngind   VALUE 'U',                        " Change Type (U, I, S, D)
           lc_vbak          TYPE tabname     VALUE 'VBAK',                     " Table Name
           lc_lifsk_e502    TYPE fieldname   VALUE 'LIFSK',                    " Field Name
           lc_faksk_e502    TYPE fieldname   VALUE 'FAKSK'.                    " Field Name


*The blocks should not come again when a manual operation is carried out in change mode of the Sales order
*when the blocks are removed by the user i.e., the setting of Block should only occur once only when the block
*is placed in the ‘customer master.If the same blocks are already existing in the applicable sales order during
*the system check, then there would be no action for that particular sales order.
IF t180-trtyp EQ lc_change_e502.
  REFRESH:lir_auart_range_e502,
      lir_vkorg_range_e502,
      lir_vtweg_range_e502,
      lir_spart_range_e502,
      lir_lifsd_range_e502,
      lir_faksd_range_e502,
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
      WHEN lc_lifsd_e502.
        APPEND INITIAL LINE TO lir_lifsd_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_lifsd_range_e502>).
        <lfs_lifsd_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_lifsd_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_lifsd_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_faksd_e502.
        APPEND INITIAL LINE TO lir_faksd_range_e502 ASSIGNING FIELD-SYMBOL(<lfs_faksd_range_e502>).
        <lfs_faksd_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_faksd_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_faksd_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
  IF lir_auart_range_e502 IS NOT INITIAL AND lir_spart_range_e502 IS NOT INITIAL
  AND lir_vkorg_range_e502 IS NOT INITIAL AND lir_vtweg_range_e502  IS NOT INITIAL.
* Check if current sales order document type, sales organization, distribution channel, division are exists in range tables.
    IF vbak-auart IN lir_auart_range_e502 AND vbak-vkorg IN lir_vkorg_range_e502
      AND vbak-vtweg IN lir_vtweg_range_e502 AND vbak-spart IN lir_spart_range_e502.
      SELECT fname
             value_new
             value_old
        FROM cdpos
        INTO TABLE li_cdpos
       WHERE objectclas = lc_verkbeleg
        AND  objectid   = vbak-vbeln
        AND  tabname    = lc_vbak
        AND  fname      IN ( lc_faksk_e502,lc_lifsk_e502 )
        AND  chngind   = lc_u_e502.
      IF sy-subrc EQ 0.
        SORT:li_cdpos BY fname.
      ENDIF.
      LOOP AT li_cdpos INTO lst_cdpos WHERE fname = lc_faksk_e502
                                      AND value_old IS NOT INITIAL
                                      AND value_new IS INITIAL.
        IF lir_faksd_range_e502[] IS NOT INITIAL.
          IF vbak-faksk IN lir_faksd_range_e502.
            CLEAR:vbak-faksk.
          ENDIF.
        ENDIF.
      ENDLOOP.
      LOOP AT li_cdpos INTO lst_cdpos WHERE fname = lc_lifsk_e502
                                      AND value_old IS NOT INITIAL
                                      AND value_new IS INITIAL.
        IF lir_lifsd_range_e502[] IS NOT INITIAL.
          IF vbak-lifsk IN lir_lifsd_range_e502.
            CLEAR:vbak-lifsk.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
*************************************************************************************************
*&  Sales Order Creation
*************************************************************************************************
IF ( t180-trtyp EQ lc_create_e502 ).
  REFRESH:lir_auart_range_e502,
      lir_vkorg_range_e502,
      lir_vtweg_range_e502,
      lir_spart_range_e502,
      lir_lifsd_range_e502,
      lir_faksd_range_e502,
      li_constant_e502.

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e502                         "Development ID
    IMPORTING
      ex_constants = li_constant_e502.                    "Constant Values

* Move the constant values to range tables
  LOOP AT li_constant_e502 ASSIGNING <lfs_constants_e502>.
    CASE <lfs_constants_e502>-param1.
      WHEN lc_auart_e502.
        APPEND INITIAL LINE TO lir_auart_range_e502 ASSIGNING <lfs_auart_range_e502>.
        <lfs_auart_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_auart_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_auart_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_vkorg_e502.
        APPEND INITIAL LINE TO lir_vkorg_range_e502 ASSIGNING <lfs_vkorg_range_e502>.
        <lfs_vkorg_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_vkorg_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_vkorg_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_vtweg_e502.
        APPEND INITIAL LINE TO lir_vtweg_range_e502 ASSIGNING <lfs_vtweg_range_e502>.
        <lfs_vtweg_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_vtweg_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_vtweg_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_spart_e502.
        APPEND INITIAL LINE TO lir_spart_range_e502 ASSIGNING <lfs_spart_range_e502>.
        <lfs_spart_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_spart_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_spart_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_lifsd_e502.
        APPEND INITIAL LINE TO lir_lifsd_range_e502 ASSIGNING <lfs_lifsd_range_e502>.
        <lfs_lifsd_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_lifsd_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_lifsd_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN lc_faksd_e502.
        APPEND INITIAL LINE TO lir_faksd_range_e502 ASSIGNING <lfs_faksd_range_e502>.
        <lfs_faksd_range_e502>-sign   = <lfs_constants_e502>-sign.
        <lfs_faksd_range_e502>-option = <lfs_constants_e502>-opti.
        <lfs_faksd_range_e502>-low    = <lfs_constants_e502>-low.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
  IF lir_auart_range_e502 IS NOT INITIAL AND lir_spart_range_e502 IS NOT INITIAL
  AND lir_vkorg_range_e502 IS NOT INITIAL AND lir_vtweg_range_e502  IS NOT INITIAL.
* Check if current sales order document type, sales organization, distribution channel, division are exists in range tables.
    IF vbak-auart IN lir_auart_range_e502 AND vbak-vkorg IN lir_vkorg_range_e502
      AND vbak-vtweg IN lir_vtweg_range_e502 AND vbak-spart IN lir_spart_range_e502.
*      Fetch the data from KNVV by passing customer(shipto party) of VBPA and sales areas fields
*      (VBAK-VKORG,VBAK-VTWEG,VBAK-SPART) from order VBAK
      READ TABLE xvbpa INTO DATA(lst_vbpa_e502) WITH KEY vbeln = vbak-vbeln
                                                         posnr = lc_zero_e502                   "Item Number
                                                         parvw = lc_parvw_we_e502.
      IF sy-subrc EQ 0.
        SELECT SINGLE lifsd
                      faksd
         FROM knvv
         INTO lst_knvv
         WHERE kunnr = lst_vbpa_e502-kunnr
         AND   vkorg = vbak-vkorg
         AND   vtweg = vbak-vtweg
         AND   spart = vbak-spart.
        IF sy-subrc EQ 0.
          IF lir_faksd_range_e502[] IS NOT INITIAL.
            IF lst_knvv-faksd IN lir_faksd_range_e502.
              vbak-faksk = lst_knvv-faksd.
            ENDIF.
          ENDIF.
          IF lir_lifsd_range_e502[] IS NOT INITIAL.
            IF lst_knvv-lifsd IN lir_lifsd_range_e502.
              vbak-lifsk = lst_knvv-lifsd.
            ENDIF.
          ENDIF.
        ENDIF.
*        Sales Area Blocks are not available,need to check Central Blocks.
        IF vbak-faksk IS INITIAL OR vbak-lifsk IS INITIAL.
          SELECT SINGLE lifsd
                        faksd
          FROM kna1
          INTO lst_knvv
          WHERE kunnr = lst_vbpa_e502-kunnr.
          IF sy-subrc EQ 0.
            IF lir_faksd_range_e502[] IS NOT INITIAL.
              IF lst_knvv-faksd IN lir_faksd_range_e502.
                vbak-faksk = lst_knvv-faksd.
              ENDIF.
            ENDIF.
            IF lir_lifsd_range_e502[] IS NOT INITIAL.
              IF lst_knvv-lifsd IN lir_lifsd_range_e502.
                vbak-lifsk = lst_knvv-lifsd.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
