*&---------------------------------------------------------------------*
*&  Include  ZQTCN_INSUB_INDIAN_AGT_I0341
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_INDIAN_AGT_I0341 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Interface for Indain Agent
* DEVELOPER: PTUFARAM ( Prabhu )/VDPATABALL
* CREATION DATE:   12/14/2021
* OBJECT ID: OTCM-47818/51088 - I0341
* TRANSPORT NUMBER(S):   ED2K925253
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*------------------------------------------------------------------- *

STATICS: lv_docnum_i0341 TYPE edi_docnum,
         lv_vbeln1_i0341 TYPE vbeln,
         lv_ihrez        TYPE ihrez,
         lv_customer     TYPE kunnr,
         lir_status      TYPE rjksd_mstae_range_tab.

DATA:lst_e1edk02_iag TYPE e1edk02,
     lst_e1edp19_iag TYPE e1edp19,
     lst_e1edka1_iag TYPE e1edka1,
     lst_e1edp02_iag TYPE e1edp02,
     lst_status      TYPE rjksd_mstae_range.

CONSTANTS : lc_e1edk02_iag TYPE edilsegtyp VALUE 'E1EDK02', " Segment type
            lc_004_iag     TYPE edi_qualfr VALUE '004',     "Qualifer
            lc_002_iag     TYPE edi_qualfr VALUE '002',     "Qualifer
            lc_001_iag     TYPE edi_qualfr VALUE '001',     "Qualifer
            lc_ag_iag      TYPE edi3035_a  VALUE 'AG',     "Qualifer
            lc_e1edp19_iag TYPE edilsegtyp VALUE 'E1EDP19', " Segment type
            lc_e1edka1_iag TYPE edilsegtyp VALUE 'E1EDKA1', " Segment type
            lc_e1edp02_iag TYPE edilsegtyp VALUE 'E1EDP02', " Segment type
            lc_posnr       TYPE posnr      VALUE '000000',
            lc_mstae       TYPE rvari_vnam VALUE 'MSTAE'.
*---Clear the static variables

IF lv_docnum_i0341 NE contrl-docnum.
  FREE: lv_vbeln1_i0341,lv_ihrez,lir_status,lv_customer.
  lv_docnum_i0341  =  contrl-docnum.
ENDIF.
IF lir_status IS INITIAL.
*---get the constant entries
  CALL METHOD zca_utilities=>get_constants
    EXPORTING
      im_devid     = lc_devid_i0341            "I0341
    IMPORTING
      et_constants = DATA(li_const1_i0341).     "Constant Values

  LOOP AT  li_const1_i0341 INTO DATA(lst_const_i0341) WHERE param1 = lc_mstae .
    lst_status-sign    = lst_const_i0341-sign.
    lst_status-option  = lst_const_i0341-opti.
    lst_status-low     = lst_const_i0341-low.
    APPEND lst_status TO lir_status.
    CLEAR lst_status.
  ENDLOOP.
ENDIF.

CASE segment-segnam.
*---Purchase Order Type
  WHEN lc_e1edk01_9.
    lst_e1edk01_01_9 = segment-sdata.
    IF lst_e1edk01_01_9-bsart IS NOT INITIAL.
      lst_xvbak9 = dxvbak.
      lst_xvbak9-bsark = lst_e1edk01_01_9-bsart.
      dxvbak = lst_xvbak9.

      lst_flag = dd_flag_k.
      lst_flag-kbes = abap_true.
      dd_flag_k = lst_flag.
    ENDIF. " IF lst_e1edk01_01_9-bsart IS NOT INITIAL

*---Sold to Validation
  WHEN lc_e1edka1_iag.
    FREE:lst_e1edka1_iag.
    lst_e1edka1_iag = segment-sdata.
    IF lst_e1edka1_iag-parvw = lc_ag.
      lv_customer = lst_e1edka1_iag-partn. "Sold-to
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_customer
        IMPORTING
          output = lv_customer.
    ENDIF.

*--*validate quotation
  WHEN lc_e1edk02_iag.
    FREE:lst_e1edk02_iag.
    lst_e1edk02_iag = segment-sdata.
    IF lst_e1edk02_iag-qualf = lc_004_iag AND lst_e1edk02_iag-belnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_e1edk02_iag-belnr
        IMPORTING
          output = lv_vbeln1_i0341.

      SELECT SINGLE vbeln, kunnr
        FROM vbak
        INTO @DATA(lst_vbak_t)
        WHERE vbeln = @lv_vbeln1_i0341.
      IF sy-subrc <> 0.
        MESSAGE e222(zqtc_r2) WITH lv_vbeln1_i0341 RAISING user_error.
      ELSE.

        DATA(lv_soldto) = lst_vbak_t-kunnr.
        FREE:lst_vbak_t.
        SELECT SINGLE vbeln, kunnr
        FROM vbak
        INTO @lst_vbak_t
        WHERE vbeln = @lv_vbeln1_i0341
          AND kunnr = @lv_customer.
        IF sy-subrc <> 0.
          MESSAGE e612(zqtc_r2) WITH lv_customer lv_soldto RAISING user_error.
        ENDIF.
      ENDIF.
    ENDIF.
*--*Validate Subrefid
  WHEN lc_e1edp02_iag.
    FREE:lst_e1edp02_iag.
    lst_e1edp02_iag = segment-sdata.
    IF lst_e1edp02_iag-qualf  = lc_001_iag AND lst_e1edp02_iag-ihrez IS NOT INITIAL.
      CLEAR:lv_ihrez.
      lv_ihrez = lst_e1edp02_iag-ihrez.
    ENDIF.
*---Validating the Material
  WHEN lc_e1edp19_iag.
    FREE:lst_e1edp19_iag.
    lst_e1edp19_iag = segment-sdata.
    IF lst_e1edp19_iag-qualf  = lc_002_iag.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = lst_e1edp19_iag-idtnr
        IMPORTING
          output       = lst_e1edp19_iag-idtnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

      SELECT SINGLE vbeln, posnr,  matnr, abgru
        FROM vbap
        INTO  @DATA(lst_vbap)
        WHERE vbeln = @lv_vbeln1_i0341
          AND matnr = @lst_e1edp19_iag-idtnr
          AND uepos = @lc_posnr.
      IF sy-subrc <> 0.
        MESSAGE e608(zqtc_r2) WITH lst_e1edp19_iag-idtnr RAISING user_error.  "material Existing Check
      ELSEIF lst_vbap-abgru IS NOT INITIAL. "IF sy-subrc <> 0.
        MESSAGE e610(zqtc_r2) WITH lst_e1edp19_iag-idtnr lst_vbap-posnr RAISING user_error." LineItem Check for Reason rejection
      ELSEIF lst_vbap-matnr IS NOT INITIAL. "IF sy-subrc <> 0.
        SELECT SINGLE matnr, mstae
          FROM mara
          INTO @DATA(lst_mara)
          WHERE matnr = @lst_vbap-matnr
            AND mstae IN @lir_status
            AND mstdv LT @sy-datum.
        IF sy-subrc = 0.
          MESSAGE e610(zqtc_r2) WITH lst_e1edp19_iag-idtnr lst_mara-mstae RAISING user_error. "Material Statas Check
        ELSE.
*--*Validate Subrefid
          IF lv_ihrez IS NOT INITIAL.
            SELECT SINGLE vbeln, posnr
                FROM vbkd
                INTO @DATA(lst_vbkd)
                WHERE vbeln = @lst_vbap-vbeln
                  AND posnr = @lst_vbap-posnr
                  AND ihrez = @lv_ihrez.
            IF sy-subrc <> 0.
              MESSAGE e609(zqtc_r2) WITH lv_ihrez RAISING user_error.
            ENDIF.
            FREE:lv_ihrez.
          ENDIF. "IF lv_ihrez IS NOT INITIAL.
        ENDIF. "" IF sy-subrc <> 0.
      ENDIF. "IF sy-subrc <> 0.
    ENDIF. " IF lst_e1edp19_iag-qualf  = lc_002_iag.
ENDCASE.
