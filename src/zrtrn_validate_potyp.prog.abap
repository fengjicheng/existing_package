*&---------------------------------------------------------------------*
*&  Include           ZRTRN_VALIDATE_POTYP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_VALIDATE_POTYP (Include)
*                      [Metrial Determination- 900]
* PROGRAM DESCRIPTION: Material Determination
* DEVELOPER:           Nageswara Polina
* CREATION DATE:       09/27/2018
* OBJECT ID:           Ennn
* TRANSPORT NUMBER(S): ED2K913470
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

  CONSTANTS:lc_p1_potype  TYPE rvari_vnam  VALUE 'PO_TYPE'.

  DATA: lv_bsark(40) TYPE c VALUE '(SAPMV45A)vbkd-bsark'.  "PO Type value

  FIELD-SYMBOLS:<lfs_bsark> TYPE any .
  ASSIGN (lv_bsark) TO <lfs_bsark>.

  IF lis_constants IS INITIAL.
* Get Cnonstant values
    SELECT devid,                                                  "Devid
           param1,                                                  "ABAP: Name of Variant Variable
           param2,                                                  "ABAP: Name of Variant Variable
           srno,                                                    "Current selection number
           sign,                                                    "ABAP: ID: I/E (include/exclude values)
           opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
           low,                                                     "Lower Value of Selection Condition
           high                                                     "Upper Value of Selection Condition
      FROM zcaconstant
      INTO TABLE @lis_constants
     WHERE devid    EQ @lc_wricef_id_e183                           "Development ID
       AND activate EQ @abap_true.                                  "Only active record
  ENDIF.

  IF lis_constants IS NOT INITIAL.
    LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value1>).

      CASE <lst_const_value1>-param1.

        WHEN lc_p1_potype.                                          " PO Type
          APPEND INITIAL LINE TO lrs_potype ASSIGNING FIELD-SYMBOL(<lst_potype1>).
          <lst_potype1>-sign   = <lst_const_value1>-sign.
          <lst_potype1>-option = <lst_const_value1>-opti.
          <lst_potype1>-low    = <lst_const_value1>-low.
          <lst_potype1>-high   = <lst_const_value1>-high.

        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.

    IF <lfs_bsark> IS  ASSIGNED.
      IF <lfs_bsark> IN lrs_potype.         "PO type check '0230',0140.
        sy-subrc = 4 .
      ELSE.
        sy-subrc = 0.
      ENDIF.
    ENDIF.
  ENDIF.
