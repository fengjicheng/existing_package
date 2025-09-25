*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ACCESS_TRCKNG_SCTY (Function Module)
* PROGRAM DESCRIPTION: This enhancement will capture the online access code
* recognized by ALM in the created subscription which will be determined by
* the society and the product in the subscription.
* DEVELOPER:            Writtick Roy(WROY)
* CREATION DATE:        28-AUG-2017
* OBJECT ID:            E152 - CR#642
* TRANSPORT NUMBER(S):  ED2K908174
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908648
* REFERENCE NO:  Defect 4250
* DEVELOPER: Anirban Saha
* DATE:  2017-09-21
* DESCRIPTION: Performance improvement
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_access_trckng_scty .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MATNR) TYPE  BU_ID_NUMBER
*"     REFERENCE(IM_KUNNR) TYPE  KUNNR
*"  EXPORTING
*"     REFERENCE(EX_ACCESS_MECH) TYPE  ZTQTC_ACCESS_MECH
*"----------------------------------------------------------------------
*======================================================================*
* Local workarea,Internal table and variable declaration
*======================================================================*
*Begin of Del-Anirban-09.21.2017-ED2K908648-Defect 4250*  DATA:
*    li_but0id TYPE STANDARD TABLE OF ty_but0id INITIAL SIZE 0.
*End of Del-Anirban-09.21.2017-ED2K908648-Defect 4250

*Begin of Add-Anirban-09.21.2017-ED2K908648-Defect 4250
  STATICS : li_but0id TYPE STANDARD TABLE OF ty_but0id INITIAL SIZE 0.
*End of Add-Anirban-09.21.2017-ED2K908648-Defect 4250

*======================================================================*
* Fetching values from ZCACONSTANT table. Retrieving the Partner Function
* values from the table and assigning it to a local variable.
*======================================================================*
  IF i_constant IS INITIAL.
*   Get data from constant table
    SELECT devid                  "Development ID
           param1                 "ABAP: Name of Variant Variable
           param2                 "ABAP: Name of Variant Variable
           srno                   "Current selection number
           sign                   "ABAP: ID: I/E (include/exclude values)
           opti                   "ABAP: Selection option (EQ/BT/CP/...)
           low                    "Lower Value of Selection Condition
           high                   "Upper Value of Selection Condition
           activate               "Activation indicator for constant
      FROM zcaconstant            "Wiley Application Constant Table
      INTO TABLE i_constant
     WHERE devid    EQ c_devid
       AND activate EQ abap_true. "Only active record
    IF sy-subrc IS INITIAL.
      SORT i_constant BY devid param1 param2.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF li_constnt IS INITIAL

*Begin of Add-Anirban-09.21.2017-ED2K908648-Defect 4250
  READ TABLE li_but0id TRANSPORTING NO FIELDS
       WITH KEY partner = im_kunnr
       BINARY SEARCH.
  IF sy-subrc NE 0.
    SELECT partner   " Business Partner Number
           type      " Identification Type
           idnumber  " Identification Number
      FROM but0id    " BP: ID Numbers
 APPENDING TABLE li_but0id
     WHERE partner  EQ im_kunnr.
    IF sy-subrc EQ 0.
      SORT li_but0id BY partner idnumber.
    ENDIF.
  ENDIF.

  READ TABLE i_acs_mech TRANSPORTING NO FIELDS
       WITH KEY matnr = im_matnr
                kunnr = im_kunnr
       BINARY SEARCH.
  IF sy-subrc NE 0.
    READ TABLE li_but0id TRANSPORTING NO FIELDS
         WITH KEY partner  = im_kunnr
                  idnumber = im_matnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT li_but0id ASSIGNING FIELD-SYMBOL(<lst_but0id>) FROM sy-tabix.
        IF <lst_but0id>-partner  NE im_kunnr OR
           <lst_but0id>-idnumber NE im_matnr.
          EXIT.
        ENDIF.

        APPEND INITIAL LINE TO ex_access_mech ASSIGNING FIELD-SYMBOL(<lst_acs_mech>).
        <lst_acs_mech>-matnr = im_matnr.
        <lst_acs_mech>-kunnr = im_kunnr.
        READ TABLE i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)
             WITH KEY devid  = c_devid
                      param1 = c_param_am
                      param2 = <lst_but0id>-type
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <lst_acs_mech>-access_mech = <lst_constant>-low.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDLOOP.
    ENDIF. " IF sy-subrc IS INITIAL
    APPEND LINES OF ex_access_mech TO i_acs_mech.
    SORT i_acs_mech BY matnr kunnr.
  ELSE.
    LOOP AT i_acs_mech ASSIGNING <lst_acs_mech> FROM sy-tabix.
      IF <lst_acs_mech>-matnr NE im_matnr OR
         <lst_acs_mech>-kunnr NE im_kunnr.
        EXIT.
      ENDIF.
      APPEND <lst_acs_mech> TO ex_access_mech.
    ENDLOOP.
  ENDIF.
*End of Add-Anirban-09.21.2017-ED2K908648-Defect 4250

*Begin of Del-Anirban-09.21.2017-ED2K908648-Defect 4250

*  READ TABLE i_acs_mech TRANSPORTING NO FIELDS
*       WITH KEY matnr = im_matnr
*                kunnr = im_kunnr
*       BINARY SEARCH.
*  IF sy-subrc NE 0.
*    SELECT partner   " Business Partner Number
*           type      " Identification Type
*           idnumber  " Identification Number
*      FROM but0id    " BP: ID Numbers
*      INTO TABLE li_but0id
*     WHERE partner  EQ im_kunnr
*       AND idnumber EQ im_matnr.
*    IF sy-subrc IS INITIAL.
*      LOOP AT li_but0id ASSIGNING FIELD-SYMBOL(<lst_but0id>).
*        APPEND INITIAL LINE TO ex_access_mech ASSIGNING FIELD-SYMBOL(<lst_acs_mech>).
*        <lst_acs_mech>-matnr = im_matnr.
*        <lst_acs_mech>-kunnr = im_kunnr.
*        READ TABLE i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)
*             WITH KEY devid  = c_devid
*                      param1 = c_param_am
*                      param2 = <lst_but0id>-type
*             BINARY SEARCH.
*        IF sy-subrc IS INITIAL.
*          <lst_acs_mech>-access_mech = <lst_constant>-low.
*        ENDIF. " IF sy-subrc IS INITIAL
*      ENDLOOP.
*    ENDIF. " IF sy-subrc IS INITIAL
*    APPEND LINES OF ex_access_mech TO i_acs_mech.
*    SORT i_acs_mech BY matnr kunnr.
*  ELSE.
*    LOOP AT i_acs_mech ASSIGNING <lst_acs_mech> FROM sy-tabix.
*      IF <lst_acs_mech>-matnr NE im_matnr OR
*         <lst_acs_mech>-kunnr NE im_kunnr.
*        EXIT.
*      ENDIF.
*      APPEND <lst_acs_mech> TO ex_access_mech.
*    ENDLOOP.
*  ENDIF.
*End of Del-Anirban-09.21.2017-ED2K908648-Defect 4250

ENDFUNCTION.
