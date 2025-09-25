*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FRIEGHT_CARRIER_E507
*&---------------------------------------------------------------------*
* REVISION NO: ED2K926925
* REFERENCE NO:  EAM-8514/E507
* DEVELOPER: Jagadeeswara Rao M (JMADAKA)
* DATE:  21/April/2022
* PROGRAM NAME: ZQTCN_FRIEGHT_CARRIER_E507(Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Logic to switch the freight carrier from DPD to DACHSER if
*              the total weight of confirmed quantity is freater than 225 KGs
*------------------------------------------------------------------------- *

* Types declerations
TYPES: BEGIN OF lty_posnr,
         posnr TYPE posnr,
       END OF lty_posnr.

TYPES: BEGIN OF lty_lfa1,
         lifnr TYPE lifnr,
         land1 TYPE land1_gp,
         adrnr TYPE adrnr,
       END OF lty_lfa1.

* Data declerations
DATA: lst_auart_range_e507       TYPE fip_s_auart_range,
      lir_auart_range_e507       TYPE fip_t_auart_range,
      lst_vkorg_range_e507       TYPE fip_s_vkorg_range,
      lir_vkorg_range_e507       TYPE fip_t_vkorg_range,
      lst_vtweg_range_e507       TYPE fip_s_vtweg_range,
      lir_vtweg_range_e507       TYPE fip_t_vtweg_range,
      lst_spart_range_e507       TYPE fip_s_spart_range,
      lir_spart_range_e507       TYPE fip_t_spart_range,
      li_constant_e507           TYPE zcat_constants,
      lv_confirmed_qty           TYPE bmeng,
      lv_perunit_netweight       TYPE ntgew_ap,
      lv_confirmed_qty_netweight TYPE ntgew_ap,
      lv_confirmed_qty_nw_total  TYPE ntgew_ap,
      lv_threshold_value         TYPE char19,
      lv_fc_dpd                  TYPE lifnr,
      lv_fc_dachser              TYPE lifnr,
      li_posnr                   TYPE TABLE OF lty_posnr,
      lst_posnr                  TYPE lty_posnr,
      lv_header_posnr            TYPE posnr VALUE '000000',
      lv_gewei                   TYPE gewei,
      li_lfa1                    TYPE TABLE OF lty_lfa1.

* Constant declerations
CONSTANTS: lc_dev_e507    TYPE zdevid      VALUE 'E507',
           lc_auart_e507  TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
           lc_vkorg_e507  TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
           lc_vtweg_e507  TYPE rvari_vnam  VALUE 'VTWEG',                    "Parameter: Distribution channnel
           lc_spart_e507  TYPE rvari_vnam  VALUE 'SPART',                    "Parameter: Division
           lc_create_e507 TYPE trtyp       VALUE 'H',                        "Transaction type
           lc_change_e507 TYPE trtyp       VALUE 'V',                        "Transaction type
           lc_a           TYPE lfgsa VALUE 'A',
           lc_b           TYPE lfgsa VALUE 'B',
           lc_ntgew       TYPE rvari_vnam VALUE 'NTGEW',
           lc_lifnr       TYPE rvari_vnam VALUE 'LIFNR',
           lc_parvw_sp    TYPE parvw VALUE 'SP',
           lc_u_e507      TYPE char1  VALUE 'U',
           lc_i_e507      TYPE char1  VALUE 'I',
           lc_d_e507      TYPE char1  VALUE 'D',
           lc_kg          TYPE gewei VALUE 'KG'.

IF t180-trtyp = lc_create_e507 OR t180-trtyp = lc_change_e507. "Creation mode/Change mode
  CLEAR: lst_auart_range_e507,
         lir_auart_range_e507[],
         lst_vkorg_range_e507,
         lir_vkorg_range_e507[],
         lst_vtweg_range_e507,
         lir_vtweg_range_e507[],
         lst_spart_range_e507,
         lir_spart_range_e507[],
         li_constant_e507[].

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e507                          "Development ID
    IMPORTING
      ex_constants = li_constant_e507.                    "Constant Values
  IF li_constant_e507[] IS NOT INITIAL.
    LOOP AT li_constant_e507 INTO DATA(lst_constants_e507).
      CASE lst_constants_e507-param1.
        WHEN lc_auart_e507.
          lst_auart_range_e507-sign     = lst_constants_e507-sign.
          lst_auart_range_e507-option   = lst_constants_e507-opti.
          lst_auart_range_e507-low      = lst_constants_e507-low.
          APPEND lst_auart_range_e507 TO lir_auart_range_e507.
          CLEAR: lst_auart_range_e507.
        WHEN lc_vkorg_e507.
          lst_vkorg_range_e507-sign     = lst_constants_e507-sign.
          lst_vkorg_range_e507-option   = lst_constants_e507-opti.
          lst_vkorg_range_e507-low      = lst_constants_e507-low.
          APPEND lst_vkorg_range_e507 TO lir_vkorg_range_e507.
          CLEAR: lst_vkorg_range_e507.
        WHEN lc_vtweg_e507.
          lst_vtweg_range_e507-sign     = lst_constants_e507-sign.
          lst_vtweg_range_e507-option   = lst_constants_e507-opti.
          lst_vtweg_range_e507-low      = lst_constants_e507-low.
          APPEND lst_vtweg_range_e507 TO lir_vtweg_range_e507.
          CLEAR: lst_vtweg_range_e507.
        WHEN lc_spart_e507.
          lst_spart_range_e507-sign     = lst_constants_e507-sign.
          lst_spart_range_e507-option   = lst_constants_e507-opti.
          lst_spart_range_e507-low      = lst_constants_e507-low.
          APPEND lst_spart_range_e507 TO lir_spart_range_e507.
          CLEAR: lst_spart_range_e507.

      ENDCASE.
    ENDLOOP.
* Check if current sales order document type, sales organization, distribution channel, division and PO types are exists in range tables.
    CLEAR: lst_posnr, li_posnr[], lv_confirmed_qty_nw_total.
    IF vbak-auart IN lir_auart_range_e507 AND vbak-vkorg IN lir_vkorg_range_e507 AND vbak-vtweg IN lir_vtweg_range_e507 AND
       vbak-spart IN lir_spart_range_e507.

      LOOP AT xvbap INTO DATA(lst_xvbap_e507).
        IF line_exists( xvbup[ posnr = lst_xvbap_e507-posnr lfgsa = lc_a ] ) OR line_exists( xvbup[ posnr = lst_xvbap_e507-posnr lfgsa = lc_b ] ).
*** Ger unit net weight
          lv_perunit_netweight = lst_xvbap_e507-ntgew / lst_xvbap_e507-kwmeng.
*** Get confirmed quantity for each line item
          CLEAR lv_confirmed_qty.
          LOOP AT xvbep INTO DATA(lst_xvbep_e507) WHERE posnr = lst_xvbap_e507-posnr
                                                  AND   edatu = sy-datum
                                                  AND   bmeng <> 0.
            lv_confirmed_qty = lv_confirmed_qty + lst_xvbep_e507-bmeng.
            lst_posnr-posnr = lst_xvbap_e507-posnr.
            APPEND lst_posnr TO li_posnr.
            CLEAR lst_posnr.
          ENDLOOP.

*** Get total weight for all line items confirmed quantity
          IF lv_confirmed_qty IS NOT INITIAL.
            CLEAR lv_confirmed_qty_netweight.
            lv_confirmed_qty_netweight = lv_confirmed_qty * lv_perunit_netweight.

*** Convert confirmed quantity net weight into KGs if not in KGs
            IF lst_xvbap_e507-gewei <> lc_kg.

              CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
                EXPORTING
                  input                = lv_confirmed_qty_netweight
                  unit_in              = lst_xvbap_e507-gewei
                  unit_out             = lc_kg
                IMPORTING
                  output               = lv_confirmed_qty_netweight
                EXCEPTIONS
                  conversion_not_found = 1
                  division_by_zero     = 2
                  input_invalid        = 3
                  output_invalid       = 4
                  overflow             = 5
                  type_invalid         = 6
                  units_missing        = 7
                  unit_in_not_found    = 8
                  unit_out_not_found   = 9
                  OTHERS               = 10.
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.

            ENDIF.

            lv_confirmed_qty_nw_total = lv_confirmed_qty_nw_total + lv_confirmed_qty_netweight.

          ENDIF.
        ENDIF.
      ENDLOOP.

      lv_fc_dpd = VALUE #( li_constant_e507[ param1 = lc_lifnr ]-low OPTIONAL ).
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_fc_dpd
        IMPORTING
          output = lv_fc_dpd.

      lv_fc_dachser = VALUE #( li_constant_e507[ param1 = lc_lifnr ]-high OPTIONAL ).
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_fc_dachser
        IMPORTING
          output = lv_fc_dachser.

      SELECT lifnr
             land1
             adrnr
             FROM lfa1
             INTO TABLE li_lfa1
             WHERE lifnr IN ( lv_fc_dpd, lv_fc_dachser ).
      IF sy-subrc = 0.
        SORT li_lfa1 BY lifnr.
      ENDIF.

*** Get threshold value from constant table
      lv_threshold_value = VALUE #( li_constant_e507[ param1 = lc_ntgew ]-low OPTIONAL ).

*** Check if confirmed quantity net weight is greater than the threshold value
      IF lv_confirmed_qty_nw_total > lv_threshold_value.
        SORT li_posnr BY posnr.
        DELETE ADJACENT DUPLICATES FROM li_posnr COMPARING posnr.
*** Change the freight carrier from DPD to DACHSER at line item level

*** Check if DPD vendor exists in header level. If exists then insert DACHSER at applicable items.
        IF line_exists( xvbpa[ posnr = lv_header_posnr parvw = lc_parvw_sp lifnr = lv_fc_dpd ] ).

          LOOP AT li_posnr INTO lst_posnr.

            IF NOT line_exists( xvbpa[ posnr = lst_posnr-posnr parvw = lc_parvw_sp ] ).

              APPEND VALUE #( posnr = lst_posnr-posnr
                              parvw = lc_parvw_sp
                              lifnr = lv_fc_dachser
                              adrnr = VALUE #( li_lfa1[ lifnr = lv_fc_dachser ]-adrnr OPTIONAL )
                              land1 = VALUE #( li_lfa1[ lifnr = lv_fc_dachser ]-land1 OPTIONAL )
                              updkz = lc_i_e507 ) TO xvbpa.
              DATA(lv_fc_changed) = abap_true.

            ELSEIF line_exists( xvbpa[ posnr = lst_posnr-posnr parvw = lc_parvw_sp lifnr = lv_fc_dpd ] ).
              MODIFY xvbpa FROM VALUE #( lifnr = lv_fc_dachser
                                       adrnr = VALUE #( li_lfa1[ lifnr = lv_fc_dachser ]-adrnr OPTIONAL )
                                       land1 = VALUE #( li_lfa1[ lifnr = lv_fc_dachser ]-land1 OPTIONAL )
                                       updkz = lc_u_e507 )
                                       TRANSPORTING lifnr adrnr land1 updkz
                                       WHERE posnr = lst_posnr-posnr
                                       AND   parvw = lc_parvw_sp
                                       AND   lifnr = lv_fc_dpd.
              IF sy-subrc = 0.
                lv_fc_changed = abap_true.
              ENDIF.
            ENDIF.
          ENDLOOP.

        ENDIF.
      ELSE.
*** If confirmed qty net weight is lesser than threshold value then change freight carrier from Dachser to DPD if exists
        IF li_posnr[] IS NOT INITIAL.

**          LOOP AT li_posnr INTO lst_posnr.
**
**            IF line_exists( xvbpa[ posnr = lst_posnr-posnr parvw = lc_parvw_sp lifnr = lv_fc_dachser ] ).
**
**              MODIFY xvbpa FROM VALUE #( lifnr = lv_fc_dpd
**                                         adrnr = VALUE #( li_lfa1[ lifnr = lv_fc_dpd ]-adrnr OPTIONAL )
**                                         land1 = VALUE #( li_lfa1[ lifnr = lv_fc_dpd ]-land1 OPTIONAL )
**                                         updkz = lc_u_e507 )
**                                         TRANSPORTING lifnr adrnr land1 updkz
**                                         WHERE posnr = lst_posnr-posnr
**                                         AND   parvw = lc_parvw_sp
**                                         AND   lifnr = lv_fc_dachser.
**            ENDIF.
**
**          ENDLOOP.
          LOOP AT xvbup INTO DATA(lst_xvbup) WHERE lfgsa = lc_a OR lfgsa = lc_b.
            IF line_exists( xvbpa[ posnr = lst_xvbup-posnr parvw = lc_parvw_sp lifnr = lv_fc_dachser ] ).

              MODIFY xvbpa FROM VALUE #( lifnr = lv_fc_dpd
                                         adrnr = VALUE #( li_lfa1[ lifnr = lv_fc_dpd ]-adrnr OPTIONAL )
                                         land1 = VALUE #( li_lfa1[ lifnr = lv_fc_dpd ]-land1 OPTIONAL )
                                         updkz = lc_u_e507 )
                                         TRANSPORTING lifnr adrnr land1 updkz
                                         WHERE posnr = lst_xvbup-posnr
                                         AND   parvw = lc_parvw_sp
                                         AND   lifnr = lv_fc_dachser.
            ENDIF.

          ENDLOOP.

        ENDIF.
      ENDIF.

      IF lv_fc_changed IS NOT INITIAL AND ( ( sy-binpt = space AND sy-batch = space ) AND ( call_bapi EQ space ) ).
        MESSAGE TEXT-046 TYPE 'I'.
      ENDIF.


    ENDIF.
  ENDIF.
ENDIF.
*Begin of ADD: Nageswara Polina(NPOLINA):06-FEB-2023: ED2K929792

   CONSTANTS: lc_wricef_id_e375  TYPE zdevid   VALUE 'E375', "WRICEF ID
              lc_ser_num_e375    TYPE zsno     VALUE '001'.  "Serial Number

   DATA: lv_actv_flag_e375  TYPE zactive_flag .

   CLEAR:lv_actv_flag_e375.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e375  "Constant value for WRICEF
      im_ser_num     = lc_ser_num_e375    "Serial Number
    IMPORTING
      ex_active_flag = lv_actv_flag_e375. "Active / Inactive flag

  IF lv_actv_flag_e375 = abap_true.
    INCLUDE zqtcn_update_reason_for_change IF FOUND.
  ENDIF.

*End of ADD: Nageswara Polina(NPOLINA): 06-FEB-2023: ED2K929792

*** EOC by VCHITTIBAL***
