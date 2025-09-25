FUNCTION zqtc_update_classif_data.
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_UPDATE_CLASSIF_DATA
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* In order to create the new Media Issue with reference to the existing
* Media Issue called “Issue Template”.
* Updating Classification data .
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_ACTIVE) TYPE  XFELD
*"  CHANGING
*"     REFERENCE(CH_T_ALLKSSK) TYPE  RMCLKSSK_TAB
*"----------------------------------------------------------------------
  IF ch_t_allkssk[] IS INITIAL.
    RETURN.
  ENDIF.

  IF v_update_ind IS NOT INITIAL.
*   Allocation Table: Object to Class
    SELECT objek,                                          "Key of object to be classified
           mafid,	                                         "Indicator: Object/Class
           klart,	                                         "Class Type
           clint,	                                         "Internal Class Number
           adzhl                                           "Internal counter for archiving objects via engin. chg. mgmt
      FROM kssk
      INTO TABLE @DATA(li_kssk)
       FOR ALL ENTRIES IN @ch_t_allkssk
     WHERE objek EQ @ch_t_allkssk-objek                    "Key of object to be classified
       AND mafid EQ @ch_t_allkssk-mafid                    "Indicator: Object/Class
       AND klart EQ @ch_t_allkssk-klart                    "Class Type
       AND clint EQ @ch_t_allkssk-clint                    "Internal Class Number
       AND adzhl EQ @ch_t_allkssk-adzhl.                   "Internal counter for archiving objects via engin. chg. mgmt
    IF sy-subrc EQ 0.
      SORT li_kssk BY objek mafid klart clint adzhl.

*
      LOOP AT ch_t_allkssk ASSIGNING FIELD-SYMBOL(<lst_allkssk>).
        READ TABLE li_kssk TRANSPORTING NO FIELDS
             WITH KEY objek = <lst_allkssk>-objek          "Key of object to be classified
                      mafid = <lst_allkssk>-mafid          "Indicator: Object/Class
                      klart = <lst_allkssk>-klart          "Class Type
                      clint = <lst_allkssk>-clint          "Internal Class Number
                      adzhl = <lst_allkssk>-adzhl          "Internal counter for archiving objects via engin. chg. mgmt
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lst_allkssk>-vbkz = c_updkz_u.
        ENDIF.
      ENDLOOP.
      ex_active = c_user_exit_actv.
    ENDIF.
  ENDIF.

ENDFUNCTION.
