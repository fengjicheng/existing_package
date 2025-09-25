*----------------------------------------------------------------------*
* PROGRAM NAME:ZRTRN_RESTRICT_OUTPUT_E181
* PROGRAM DESCRIPTION: Restrict O/P Type based on MQ number change
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   2018-08-09
* OBJECT ID: E181
* TRANSPORT NUMBER(S):  ED2K912980
*----------------------------------------------------------------------*
CONSTANTS:
  lc_devid_e181 TYPE zdevid      VALUE 'E181'.                "Development ID: I0229
** Get Cnonstant values
SELECT param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values_e181)
 WHERE devid    EQ @lc_devid_e181                               "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  READ TABLE li_const_values_e181 INTO DATA(lst_const_values) WITH KEY low = sy-uname.
  IF sy-subrc EQ 0.
    sy-subrc = 4.
  ENDIF.
ENDIF.
