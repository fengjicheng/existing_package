*-------------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_ENH_EXLUDE_E181_GET
* PROGRAM DESCRIPTION: Restrict any Enhancement active logic if processing
*                      user id is maintained in ZCACONSTANT table against
*                      E181 Enhancement
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   2018-08-09
* OBJECT ID: E181
* TRANSPORT NUMBER(S):  ED2K912980
*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
CONSTANTS:
  lc_devid_e181 TYPE zdevid      VALUE 'E181'.                "Development ID: I0229
IF li_const_values_e181[] IS INITIAL.
  SELECT param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE li_const_values_e181
   WHERE devid    EQ lc_devid_e181                              "Development ID
     AND activate EQ abap_true.
ENDIF.
