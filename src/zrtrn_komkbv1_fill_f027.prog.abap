*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_KOMKBV1_FILL_F027 (Include)
*                      [Called from USEREXIT_KOMKBV1_FILL (RVCOMFZZ)]
* PROGRAM DESCRIPTION: Communication structure update with additional
*                      field values
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       01/25/2018
* OBJECT ID:           F027
* TRANSPORT NUMBER(S): ED2K909938
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
CONSTANTS:
  lc_parvw_za TYPE parvw    VALUE 'ZA'.                    "Partner Function: Society Partner

DATA:
  lv_xvbkd_tb TYPE char30   VALUE '(SAPMV45A)XVBKD[]'.

FIELD-SYMBOLS:
  <li_xvbkd>  TYPE va_vbkdvb_t.

* Check if there is at least one Society Partner
* Since number of entries in the Internal table will be very limited,
* SORT and BINARY SEARCH is not being used
READ TABLE com_vbpa[] TRANSPORTING NO FIELDS
     WITH KEY parvw = lc_parvw_za.
IF sy-subrc EQ 0.
  com_kbv1-zzsoc_doc = abap_true.
ENDIF.

ASSIGN (lv_xvbkd_tb) TO <li_xvbkd>.
IF sy-subrc EQ 0.
* Populate Line Item details to Communication structure (from first Line Item)
  READ TABLE <li_xvbkd> ASSIGNING FIELD-SYMBOL(<lst_xvbkd>) INDEX 2.
  IF sy-subrc EQ 0.
    com_kbv1-konda = <lst_xvbkd>-konda.                    "Price group (customer)
  ENDIF.
ENDIF.
