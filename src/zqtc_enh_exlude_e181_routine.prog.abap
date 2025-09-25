*&------------------------------------------------------------------------*
*&  Include           ZQTC_ENH_EXLUDE_E181
*&------------------------------------------------------------------------*
*-------------------------------------------------------------------------*
* PROGRAM NAME:ZRTRN_RESTRICT_OUTPUT_E181
* PROGRAM DESCRIPTION: Restrict any Enhancement active logic if processing
*                      user id is maintained in ZCACONSTANT table against
*                      E181 Enhancement
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   2018-08-09
* OBJECT ID: E181
* TRANSPORT NUMBER(S):  ED2K912980
*------------------------------------------------------------------------*
TYPES : BEGIN OF ty_constant_r,
          param1 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,   "Current selection number
          sign   TYPE tvarv_sign,   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low, "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, "Upper Value of Selection Condition
        END OF ty_constant_r.
DATA: li_const_values_e181_r TYPE TABLE OF ty_constant_r.
CONSTANTS:
  lc_devid_e181_r TYPE zdevid      VALUE 'E181'.                "Development ID: I0229
REFRESH:li_const_values_e181_r.
SELECT param1                                                  "ABAP: Name of Variant Variable
       param2                                                  "ABAP: Name of Variant Variable
       srno                                                    "Current selection number
       sign                                                    "ABAP: ID: I/E (include/exclude values)
       opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE li_const_values_e181_r
 WHERE devid    EQ lc_devid_e181_r                               "Development ID
   AND activate EQ abap_true.                                  "Only active record
IF NOT li_const_values_e181_r[] IS INITIAL.
  READ TABLE li_const_values_e181_r INTO DATA(st_const_values_r) WITH KEY low = sy-uname.
  " If current user is maintained in constant table against E181,
  " then exclusion logic is met and I0229 enhancement shouldn't be triggered
  IF sy-subrc = 0.
    sy-subrc = 4.
  ELSE.
    " If current user is not maintained in constant table against E181,
    " then requirement will trigger as per other logic followed below.
    sy-subrc = 0.
  ENDIF.
ENDIF.
