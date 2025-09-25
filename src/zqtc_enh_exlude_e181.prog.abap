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
IF NOT li_const_values_e181[] IS INITIAL.
  READ TABLE li_const_values_e181 INTO st_const_values WITH KEY low = sy-uname.
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
