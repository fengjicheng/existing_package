*&---------------------------------------------------------------------*
*&  Include           ZQTCN_VALID_RELATION_ID
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* INCLUDE NAME: ZQTCN_VALID_RELATION_ID
*               Called from BDT event FM: ZQTC_BUP0ID_EVENT_DCHCK_E165
* DESCRIPTION: BP Validations Identifications
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 09/12/2018
* OBJECT ID: E165
* TRANSPORT NUMBER(s): ED2K913318
*----------------------------------------------------------------------*

DATA:   li_but000        TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,     " Itab: BP General data-I
        li_but0id        TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications
        li_but0id_old    TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications-Old
        lr_prefix        TYPE STANDARD TABLE OF srg_char1,
        lv_msgv1(60)     TYPE c,
        lv_rel_type      TYPE bu_reltyp,
        lv_rel_type_2(7) TYPE c,
        lv_rel_type_3(7) TYPE c,
        lv_error         TYPE c,
        lv_first         TYPE c,
        lv_msgno         TYPE syst_msgno VALUE '305',
        lv_len           TYPE i.

CONSTANTS:
  lc_reltype    TYPE bu_id_type VALUE 'ZRLCT',
  lc_devid_e165 TYPE zdevid     VALUE 'E165',   " Development ID: E165
  lc_prefix     TYPE rvari_vnam VALUE 'PREFIX'. " Name of Variant Variable: Prefix

* Get Cnonstant values
SELECT devid,                                                   "Devid
       param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values)
 WHERE devid    EQ @lc_devid_e165                               "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_prefix.                                       "Sales Office (SALES_OFFICE)
        APPEND INITIAL LINE TO lr_prefix ASSIGNING FIELD-SYMBOL(<lst_prefix>).
        <lst_prefix>-sign   = <lst_const_value>-sign.
        <lst_prefix>-option = <lst_const_value>-opti.
        <lst_prefix>-low    = <lst_const_value>-low.
        <lst_prefix>-high   = <lst_const_value>-high.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL
* FM call to fetch the Identification details
CALL FUNCTION 'BUP_BUPA_BUT0ID_GET'
  TABLES
    t_but0id     = li_but0id
    t_but0id_old = li_but0id_old.
IF li_but0id[] IS NOT INITIAL.
*--* Look for only ZRLCT relation types
  DELETE li_but0id WHERE type NE lc_reltype.
  SORT li_but0id BY partner type idnumber DESCENDING.
  IF li_but0id[] IS NOT INITIAL.
    LOOP AT li_but0id INTO DATA(lst_but0id).
      CLEAR : lv_rel_type,lv_len,lv_error,lv_rel_type_2,lv_rel_type_3,lv_first,lv_msgv1.
      lv_rel_type = lst_but0id-idnumber.
      IF lv_rel_type IS NOT INITIAL.
*--*TBZ9 table relation type has only 6 character limit
*--*If entered value contains more than 7 char(6 + prefix) means invalid
        lv_len = strlen( lst_but0id-idnumber ).
        IF lv_len GT 7.
          lv_error = abap_true.
        ENDIF.
        IF lv_error IS INITIAL.
          lv_first = lst_but0id-idnumber+0(1).
*--*Check the first character with Prefix maintained in constant table
          IF lv_first IN lr_prefix.
            lv_rel_type = lst_but0id-idnumber+1(6).
            READ TABLE li_but0id INTO DATA(lst_bt0id_dummy2) WITH KEY idnumber = lv_rel_type.
            IF sy-subrc EQ 0.
              lv_msgno = 306.
              lv_error = abap_true.
              lv_msgv1 = lv_rel_type.
            ENDIF.
          ELSEIF lv_len GT 6..
*--*If first 6 char is valid and added some extra characters
            lv_error = abap_true.
          ELSE.
            LOOP AT lr_prefix INTO DATA(lst_prefix2) WHERE low NE lv_first.
              CONCATENATE lst_prefix2-low lv_rel_type INTO lv_rel_type_3.
              READ TABLE li_but0id INTO DATA(lst_bt0id_dummy) WITH KEY idnumber = lv_rel_type_3.
              IF sy-subrc EQ 0.
                lv_msgno = 307.
                lv_error = abap_true.
                lv_msgv1 = lv_rel_type.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
*--*Check the entered value
        SELECT SINGLE reltyp FROM tbz9 INTO @DATA(lv2_rel_type)
               WHERE reltyp = @lv_rel_type.
        IF sy-subrc IS NOT INITIAL.
          lv_error = abap_true.
        ENDIF.
      ENDIF.
      IF lv_error = abap_true.
        IF lv_msgv1 IS INITIAL.
          lv_msgv1 = lst_but0id-idnumber.
        ENDIF.
*--*exception message
        CALL FUNCTION 'BUS_MESSAGE_STORE'
          EXPORTING
            arbgb = 'ZQTC_R2'
            msgty = 'E'
            txtnr = lv_msgno
            msgv1 = lv_msgv1.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.
