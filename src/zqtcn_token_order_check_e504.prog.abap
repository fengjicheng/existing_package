*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TOKEN_ORDER_CHECK_E504
*&---------------------------------------------------------------------*
* REVISION NO: ED2K926594
* REFERENCE NO:  EAM-5945 / E504
* DEVELOPER: Jagadeeswara Rao M (JMADAKA)
* DATE:  07/April/2022
* PROGRAM NAME: ZQTCN_TOKEN_ORDER_CHECK_E504(Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Logic to check field value for mandatory token number
*              for credit card payments in the field BSTKD_E from
*              header data(Order data)
*------------------------------------------------------------------------- *

* Data declerations
DATA: lst_auart_range_e504 TYPE fip_s_auart_range,
      lir_auart_range_e504 TYPE fip_t_auart_range,
      lst_vkorg_range_e504 TYPE fip_s_vkorg_range,
      lir_vkorg_range_e504 TYPE fip_t_vkorg_range,
      lst_vtweg_range_e504 TYPE fip_s_vtweg_range,
      lir_vtweg_range_e504 TYPE fip_t_vtweg_range,
      lst_spart_range_e504 TYPE fip_s_spart_range,
      lir_spart_range_e504 TYPE fip_t_spart_range,
      lir_bsark_range_e504 TYPE RANGE OF bsark,
      lst_bsark_range_e504 LIKE LINE OF lir_bsark_range_e504,
      li_constant_e504     TYPE zcat_constants,
      lv_bstkd_e           TYPE bstkd_e.

* Constant declerations
CONSTANTS: lc_dev_e504      TYPE zdevid      VALUE 'E504',
           lc_auart_e504    TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
           lc_vkorg_e504    TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
           lc_vtweg_e504    TYPE rvari_vnam  VALUE 'VTWEG',                    "Parameter: Distribution channnel
           lc_spart_e504    TYPE rvari_vnam  VALUE 'SPART',                    "Parameter: Division
           lc_bsark_e504    TYPE rvari_vnam  VALUE 'BSARK',                    "Parameter: PO type
           lc_create_e504   TYPE trtyp       VALUE 'H',                        "Transaction type
           lc_change_e504   TYPE trtyp       VALUE 'V',                        "Transaction type
           lc_zero          TYPE posnr VALUE '000000',                         "Item Number
           lc_ent1_e504(20) TYPE c             VALUE 'ENT1'.  " FCODE

IF t180-trtyp = lc_create_e504 OR t180-trtyp = lc_change_e504. "Creation mode/Change mode
  IF ( sy-binpt = space AND sy-batch = space ) AND ( call_bapi EQ space ). "Do not execute for BAPI call & Batch call
    CLEAR: lst_auart_range_e504,
           lir_auart_range_e504[],
           lst_vkorg_range_e504,
           lir_vkorg_range_e504[],
           lst_vtweg_range_e504,
           lir_vtweg_range_e504[],
           lst_spart_range_e504,
           lir_spart_range_e504[],
           lst_bsark_range_e504,
           lir_bsark_range_e504[],
           li_constant_e504[].

* Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dev_e504                          "Development ID
      IMPORTING
        ex_constants = li_constant_e504.                    "Constant Values

* Move the constant values to range tables
    IF li_constant_e504[] IS NOT INITIAL.
      LOOP AT li_constant_e504 INTO DATA(lst_constants_e504).
        CASE lst_constants_e504-param1.
          WHEN lc_auart_e504.
            lst_auart_range_e504-sign     = lst_constants_e504-sign.
            lst_auart_range_e504-option   = lst_constants_e504-opti.
            lst_auart_range_e504-low      = lst_constants_e504-low.
            APPEND lst_auart_range_e504 TO lir_auart_range_e504.
            CLEAR: lst_auart_range_e504.
          WHEN lc_vkorg_e504.
            lst_vkorg_range_e504-sign     = lst_constants_e504-sign.
            lst_vkorg_range_e504-option   = lst_constants_e504-opti.
            lst_vkorg_range_e504-low      = lst_constants_e504-low.
            APPEND lst_vkorg_range_e504 TO lir_vkorg_range_e504.
            CLEAR: lst_vkorg_range_e504.
          WHEN lc_vtweg_e504.
            lst_vtweg_range_e504-sign     = lst_constants_e504-sign.
            lst_vtweg_range_e504-option   = lst_constants_e504-opti.
            lst_vtweg_range_e504-low      = lst_constants_e504-low.
            APPEND lst_vtweg_range_e504 TO lir_vtweg_range_e504.
            CLEAR: lst_vtweg_range_e504.
          WHEN lc_spart_e504.
            lst_spart_range_e504-sign     = lst_constants_e504-sign.
            lst_spart_range_e504-option   = lst_constants_e504-opti.
            lst_spart_range_e504-low      = lst_constants_e504-low.
            APPEND lst_spart_range_e504 TO lir_spart_range_e504.
            CLEAR: lst_spart_range_e504.
          WHEN lc_bsark_e504.
            lst_bsark_range_e504-sign     = lst_constants_e504-sign.
            lst_bsark_range_e504-option   = lst_constants_e504-opti.
            lst_bsark_range_e504-low      = lst_constants_e504-low.
            APPEND lst_bsark_range_e504 TO lir_bsark_range_e504.
            CLEAR: lst_bsark_range_e504.

        ENDCASE.
      ENDLOOP.

* Check if current sales order document type, sales organization, distribution channel, division and PO types are exists in range tables.
      IF vbak-auart IN lir_auart_range_e504 AND vbak-vkorg IN lir_vkorg_range_e504 AND vbak-vtweg IN lir_vtweg_range_e504 AND
         vbak-spart IN lir_spart_range_e504 AND vbak-bsark IN lir_bsark_range_e504.
* Check the header BSTKD_E field is empty or not
        CLEAR lv_bstkd_e.
        lv_bstkd_e = VALUE #( xvbkd[ posnr = lc_zero ]-bstkd_e OPTIONAL ).
        IF lv_bstkd_e IS INITIAL.
* Raise an hard stop error message
          MESSAGE w614(zqtc_r2) DISPLAY LIKE 'E'.

          " This will display a message about the problem
          " or the reason for not saving the document
          PERFORM folge_gleichsetzen(saplv00f).
          fcode = lc_ent1.
          SET SCREEN syst-dynnr.
          LEAVE SCREEN.

        ENDIF.
      ENDIF.

    ENDIF.
  ENDIF.
ENDIF.
