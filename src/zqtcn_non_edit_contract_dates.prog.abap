*&---------------------------------------------------------------------*
*&  Include           ZQTCN_NON_EDIT_CONTRACT_DATES
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_NON_EDIT_CONTRACT_DATES(Include)
* PROGRAM DESCRIPTION:As a society specialist we need the contract header start and end dates to
* become non editable for ZOR, ZOFL and Indirect when editing society orders
* non-editable for specific Order Types maintained in ZCACONSTANT table.
* DEVELOPER: SivaramiReddy
* CREATION DATE:   05/11/2023
* OBJECT ID: N/A
* TRANSPORT NUMBER(S):
*--------------------------------------------------------------------
* Type Declaration
TYPES : BEGIN OF lty_zcaconstant_eced,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          "ABAP: Current selection number
          sign     TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          activate TYPE zconstactive,        "Activation indicator for constant
        END OF   lty_zcaconstant_eced.

* Local Constant Declaration
DATA : lc_e386         TYPE zdevid        VALUE 'E386',         " Development ID
       lc_eced_auart   TYPE rvari_vnam    VALUE 'AUART',        " ABAP: Name of Variant Variable
       lc_eced_i       TYPE char1         VALUE 'I',            " I of type CHAR1
       lc_tcode        TYPE syst_tcode    VALUE 'VA42',         " Transaction type
       lc_veda_vbegdat TYPE char30        VALUE 'VEDA-VBEGDAT', " VEDA-VBEGDAT of type CHAR30
       lc_veda_venddat TYPE char30        VALUE 'VEDA-VENDDAT', " VEDA-VENDDAT of type CHAR30
       lc_eced_eq      TYPE char2         VALUE 'EQ'.           " EQ of type CHAR2

* local Internal Table Declaration
DATA : li_zcaconstant_eced  TYPE STANDARD TABLE OF lty_zcaconstant_eced INITIAL SIZE 0,
       lst_zcaconstant_eced TYPE lty_zcaconstant_eced. " Wiley Application Constant Table

* Range Declaration
TYPES: ty_eced_auart_r TYPE RANGE OF auart. " Sales Document Type
DATA: lst_eced_auart TYPE LINE OF ty_eced_auart_r,
      lir_eced_auart TYPE ty_eced_auart_r.
CASE screen-name.
  WHEN lc_veda_vbegdat OR lc_veda_venddat.
*BREAK SISIREDDY.
    IF sy-tcode EQ lc_tcode.
      SELECT devid       "Development ID
             param1	     "ABAP: Name of Variant Variable
             param2	     "ABAP: Name of Variant Variable
             srno	       "ABAP: Current selection number
             sign	       "ABAP: ID: I/E (include/exclude values)
             opti	       "ABAP: Selection option (EQ/BT/CP/...)
             low         "Lower Value of Selection Condition
             high	       "Upper Value of Selection Condition
             activate    "Activation indicator for constant
        FROM zcaconstant "Wiley Application Constant Table
        INTO TABLE li_zcaconstant_eced
       WHERE devid  = lc_e386
         AND activate = abap_true.
      IF sy-subrc EQ 0.
*   Get The sales order type from constant Table
        DELETE li_zcaconstant_eced WHERE param1 <> lc_eced_auart.
        CLEAR lst_zcaconstant_eced.
        IF li_zcaconstant_eced IS NOT INITIAL .
          LOOP AT li_zcaconstant_eced INTO lst_zcaconstant_eced.
            CASE lst_zcaconstant_eced-param1.
              WHEN lc_eced_auart.
                lst_eced_auart-sign   = lst_zcaconstant_eced-sign.
                lst_eced_auart-option = lst_zcaconstant_eced-opti.
                lst_eced_auart-low    = lst_zcaconstant_eced-low.
                APPEND lst_eced_auart TO lir_eced_auart.
                CLEAR lst_eced_auart .
            ENDCASE.
          ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
        ENDIF. " IF li_zcaconstant IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " SY-Tcode
    DATA:lv_auart TYPE auart.
    SELECT SINGLE auart FROM vbak INTO lv_auart WHERE vbeln = xveda-vbeln.
*      If the sales order maintain in ZCACONSTANT table then
    IF lv_auart IN lir_eced_auart   AND
       lir_eced_auart  IS NOT INITIAL.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF. " IF vbak-auart IN lir_auart
ENDCASE.
