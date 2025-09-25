*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_RESTRICT_OUTPUT_I0229_12
* PROGRAM DESCRIPTION: Restrict O/P Type based on Version
*                      Check Version (VBAK-VSNMR_V) field for values
*                      If Version contains a value, restrict output
*                      maintained in ZCACONSTANT (ZOA2).
* DEVELOPER: Nikhilesh Palla
* CREATION DATE:   2021-10-12
* OBJECT ID: I0229
* TRANSPORT NUMBER(S): ED2K924568
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
* Rettung von VBAK Feldern nach AG-Änderung.
TYPES:    BEGIN OF ty_xvbak.
            INCLUDE STRUCTURE vbak.
TYPES:      agupda    LIKE rv02p-agupd,
            weupda    LIKE rv02p-weupd,
            auartupda,
          END OF ty_xvbak.
* Range for KSCHL
TYPES: BEGIN OF ty_kschl,
         sign   TYPE tvarv_sign,
         option TYPE tvarv_opti,
         low    TYPE kschl,
         high   TYPE kschl,
       END OF ty_kschl.

CONSTANTS:
  lc_kschl          TYPE char5       VALUE 'KSCHL',
  lc_devid_i0229_12 TYPE zdevid      VALUE 'I0229'.             "Development ID: I0229
DATA:
  lv_fname_xvbak TYPE char40 VALUE '(SAPMV45A)XVBAK',        "Sales Document: Item Data
  lir_kschl      TYPE STANDARD TABLE OF ty_kschl.

FIELD-SYMBOLS:
  <li_ord_hdr> TYPE ty_xvbak.                                   "Sales Document: Item Data

SELECT param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values_i0229_12)
 WHERE devid    EQ @lc_devid_i0229_12                           "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc = 0.
  LOOP AT li_const_values_i0229_12 ASSIGNING FIELD-SYMBOL(<lfs_constant_12>).
    IF <lfs_constant_12>-param1 = lc_kschl.
      APPEND INITIAL LINE TO lir_kschl ASSIGNING FIELD-SYMBOL(<lfs_kschl>).
      <lfs_kschl>-sign = <lfs_constant_12>-sign.
      <lfs_kschl>-option = <lfs_constant_12>-opti.
      <lfs_kschl>-low =  <lfs_constant_12>-low.
      <lfs_kschl>-high = <lfs_constant_12>-high.
    ENDIF.
  ENDLOOP.
ENDIF.

IF t683s-kschl IN lir_kschl[].
  ASSIGN (lv_fname_xvbak) TO <li_ord_hdr>.
  IF sy-subrc EQ 0.
    IF <li_ord_hdr>-vsnmr_v IS INITIAL.
      sy-subrc = 0.
    ELSE.
      sy-subrc = 4.
    ENDIF.
  ENDIF.
ENDIF.
