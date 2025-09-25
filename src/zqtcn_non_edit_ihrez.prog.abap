*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_NON_EDIT_IHREZ(Include)
* PROGRAM DESCRIPTION: to make the field VBKD-IHREZ (SCREEN-NAME) as
* non-editable for specific Order Types maintained in ZCACONSTANT table.
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   11/08/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S):  ED2K903129
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_NON_EDIT_IHREZ
*&---------------------------------------------------------------------*

* Type Declaration
TYPES : BEGIN OF lty_zcaconstant,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          "ABAP: Current selection number
          sign     TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          activate TYPE zconstactive,        "Activation indicator for constant
        END OF   lty_zcaconstant.

* Local Constant Declaration
DATA :   lc_e112       TYPE zdevid        VALUE 'E112',         " Development ID
         lc_numb_ran   TYPE rvari_vnam    VALUE 'NUMBER_RANGE', " ABAP: Name of Variant Variable
         lc_auart      TYPE rvari_vnam    VALUE 'AUART',        " ABAP: Name of Variant Variable
         lc_i          TYPE char1         VALUE 'I',            " I of type CHAR1
         lc_h          TYPE trtyp         VALUE 'H',            " Transaction type
         lc_vbkd_ihrez TYPE char30        VALUE 'VBKD-IHREZ',   " Vbkd_ihrez of type CHAR30
         lc_eq         TYPE char2         VALUE 'EQ'.           " Eq of type CHAR2

* local Internal Table Declaration
DATA : li_zcaconstant  TYPE STANDARD TABLE OF lty_zcaconstant INITIAL SIZE 0,
       lst_zcaconstant TYPE lty_zcaconstant. " Wiley Application Constant Table

* Range Declaration
TYPES : ty_auart_r TYPE RANGE OF auart. " Sales Document Type
DATA : lst_auart TYPE LINE OF ty_auart_r,
       lir_auart TYPE ty_auart_r.

* Field(VBKD-IHREZ) Reference Id is non-editable for online (manual) processing only.
IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
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
    INTO TABLE li_zcaconstant
   WHERE devid  = lc_e112
     AND activate = abap_true.
  IF sy-subrc EQ 0.
*   Get The sales order type from constant Table
    DELETE li_zcaconstant WHERE param1 <> lc_auart.
    CLEAR lst_zcaconstant.
    IF li_zcaconstant IS NOT INITIAL .
      LOOP AT li_zcaconstant INTO lst_zcaconstant.
        lst_auart-sign   = lst_zcaconstant-sign.
        lst_auart-option = lst_zcaconstant-opti.
        lst_auart-low    = lst_zcaconstant-low.
        lst_auart-high   = lst_zcaconstant-high.
        APPEND lst_auart TO lir_auart.
        CLEAR lst_auart .
      ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
    ENDIF. " IF li_zcaconstant IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

  CASE screen-name.
    WHEN lc_vbkd_ihrez.
*     If the sales order maintain in ZCACONSTANT table then
      IF vbak-auart IN lir_auart   AND
         lir_auart  IS NOT INITIAL AND
         call_bapi  IS  INITIAL    AND
         sy-batch   IS  INITIAL    AND
         sy-binpt   IS  INITIAL.
*       Field(VBKD-IHREZ) Reference Id is non-editable
        screen-input = 0.
      ENDIF. " IF vbak-auart IN lir_auart
  ENDCASE.
ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL
