*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_RESTRICT_OUTPUT_E095
* PROGRAM DESCRIPTION:
* DEVELOPER: ANIRBAN SAHA
* CREATION DATE: 4/26/2017
* OBJECT ID: I095
* TRANSPORT NUMBER(S):  ED2K905497
*----------------------------------------------------------------------*

TYPES: BEGIN OF lty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF lty_const.

DATA:   li_const  TYPE STANDARD TABLE OF lty_const,
        lst_const TYPE                   lty_const,
        lv_flag   TYPE c.

*---------------------------------------------------------------------------*
*---------------Fetching Document Type from constant table------------------*
*---------------------------------------------------------------------------*
SELECT devid                       "Development ID
       param1                      "ABAP: Name of Variant Variable
       param2                      "ABAP: Name of Variant Variable
       srno                        "Current selection number
       sign                        "ABAP: ID: I/E (include/exclude values)
       opti                        "ABAP: Selection option (EQ/BT/CP/...)
       low                         "Lower Value of Selection Condition
       high                        "Upper Value of Selection Condition
       activate                    "Activation indicator for constant
       FROM zcaconstant            " Wiley Application Constant Table
       INTO TABLE li_const
       WHERE devid    = lc_wricef_id_e095
       AND   param1   = lc_promo
       AND   activate = abap_true. "Only active record
IF sy-subrc IS INITIAL.
  SORT li_const BY devid param1 srno.
ENDIF. " IF sy-subrc IS INITIAL

READ TABLE li_const INTO lst_const WITH KEY low = komkbv1-zzpromo.
IF sy-subrc = 0.
  lv_flag = abap_true.
ENDIF.

IF lv_flag = abap_true.
  sy-subrc = 4.
ELSE.
  sy-subrc = 0.
ENDIF.

CLEAR: lv_flag.
