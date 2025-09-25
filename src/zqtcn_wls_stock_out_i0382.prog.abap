*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_STOCK_OUT_I0382
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXLOIU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION : Include for doc type/order type/Material type
*                       filtering in Outbound IDOC for stock info
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 05/27/2020
* OBJECT ID           : I0382
* TRANSPORT NUMBER(S) : ED2K918150
*----------------------------------------------------------------------*
DATA:lst_e1mdpsl TYPE e1mdpsl,
     lst_e1mdstl TYPE e1mdstl,
     li_edidd    TYPE STANDARD TABLE OF edidd,
     lr_auart    TYPE RANGE OF auart WITH HEADER LINE,
     lr_mtart    TYPE RANGE OF mtart     WITH HEADER LINE.

CONSTANTS: lc_e1mdpsl   TYPE edilsegtyp VALUE 'E1MDPSL',
           lc_e1mdstl   TYPE edilsegtyp VALUE 'E1MDSTL',
           lc_devid     TYPE zdevid     VALUE 'I0382',
           lc_param2    TYPE rvari_vnam VALUE 'FILTER',
           lc_ordertype TYPE rvari_vnam VALUE 'AUART',
           lc_mtart     TYPE rvari_vnam VALUE 'MTART'.

*----get the constant values

SELECT  devid,      " Development ID
        param1,     " ABAP: Name of Variant Variable
        param2,     " ABAP: Name of Variant Variable
        srno,       " ABAP: Current selection number
        sign,       " ABAP: ID: I/E (include/exclude values)
        opti,       " ABAP: Selection option (EQ/BT/CP/...)
        low,        " Lower Value of Selection Condition
        high       " Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @DATA(li_constants)
    WHERE devid    = @lc_devid
      AND param2   = @lc_param2
      AND activate = @abap_true.

IF sy-subrc EQ 0.
  SORT li_constants BY devid param1 param2 srno.
ENDIF.

LOOP AT li_constants INTO DATA(lst_constant).
  CASE lst_constant-param1.
    WHEN lc_ordertype.
      CLEAR lr_auart.
      lr_auart-sign   = lst_constant-sign.
      lr_auart-option = lst_constant-opti.
      lr_auart-low    = lst_constant-low.
      lr_auart-high   = lst_constant-high.
      APPEND lr_auart TO lr_auart[].
      CLEAR lr_auart.
    WHEN lc_mtart.
      CLEAR lr_mtart.
      lr_mtart-sign   = lst_constant-sign.
      lr_mtart-option = lst_constant-opti.
      lr_mtart-low    = lst_constant-low.
      APPEND lr_mtart TO lr_mtart[].
      CLEAR lr_mtart.
  ENDCASE.
ENDLOOP.
*---Material type validations
READ TABLE idoc_data[] INTO DATA(lst_edidd) WITH KEY segnam = lc_e1mdstl.
IF sy-subrc = 0.
  FREE:lst_e1mdstl.
  lst_e1mdstl = lst_edidd-sdata.
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = lst_e1mdstl-matnr
    IMPORTING
      output = lst_e1mdstl-matnr.

  SELECT SINGLE mtart
    FROM mara
    INTO @DATA(lst_matnr)
    WHERE matnr = @lst_e1mdstl-matnr
      AND mtart IN @lr_mtart[].
*---If the material type 'ZFRT'(ZCACONSTANT) not exist in MARA then we are removing
*---segement from the IDOC data and removing other Child IDOCS(Not generating IDOCS for
*---that particular material
  IF sy-subrc <> 0.
    DELETE idoc_data[] INDEX 1.   "Removing segement data from DATA Record
  ENDIF.
ELSE.
  IF idoc_data[] IS NOT INITIAL.
    DELETE idoc_data[] INDEX 1. "Removing segement data from DATA Record
  ENDIF.
ENDIF.
*----Order Type validations
READ TABLE idoc_data[] INTO lst_edidd WITH KEY segnam = lc_e1mdpsl.
IF sy-subrc = 0.
  FREE:li_edidd.
  IF idoc_data[] IS NOT INITIAL.
    li_edidd = idoc_data[].
  ENDIF.
  LOOP AT li_edidd INTO lst_edidd WHERE segnam = lc_e1mdpsl.
    DATA(lv_tabix) = sy-tabix.
    FREE:lst_e1mdpsl.
    lst_e1mdpsl = lst_edidd-sdata.
    IF lst_e1mdpsl-auart IN lr_auart[]." 'ZWBV'. "Order Type/Prod Order type filtering
      DELETE idoc_data[] INDEX lv_tabix. "Delete that segment from DATA record if Order Type = 'ZWBV'.
    ENDIF.
  ENDLOOP.
  FREE:li_edidd.
ENDIF.
