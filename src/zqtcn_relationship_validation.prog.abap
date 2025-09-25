***------------------------------------------------------------------------*
*** PROGRAM NAME: ZQTCN_RELATIONSHIP_VALIDATION (Include)
*                 called from include: ZQTCN_BP_VALIDATIONS
*** PROGRAM DESCRIPTION: BP Relationship Validation
*** DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
*** CREATION DATE: 07/04/2018
*** OBJECT ID: E165 / CR# 6664
*** TRANSPORT NUMBER(s): ED2K913317
***------------------------------------------------------------------------*

* Local Types
TYPES: BEGIN OF lty_relations,
         partner1             TYPE  bu_partner,
         partner2             TYPE  bu_partner,
         relationshipcategory TYPE  char7,
         validfromdate        TYPE  bu_datfrom,
         validuntildate       TYPE  bu_datto,
         defaultrelationship  TYPE  bu_xdfrel,
         relationshiptype     TYPE bu_relkind,
       END OF lty_relations,
       BEGIN OF lty_rel_lm,
         relnr     TYPE  bu_relnr,
         partner1  TYPE  bu_partner,
         partner2  TYPE  bu_partner,
         date_to   TYPE  bu_datto,
         date_from TYPE  bu_datfrom,
         reltyp    TYPE  char7,
         xrf       TYPE  bu_xrf,
         action    TYPE bu_action,
       END OF lty_rel_lm,
       BEGIN OF lty_but0id,
         partner  TYPE bu_partner,
         type     TYPE char7,
         idnumber TYPE bu_id_number,
       END OF lty_but0id.

* Local declarations
DATA: lv_aktyp             TYPE bu_aktyp,                                    " Activity Category
      lv_bp_num            TYPE bu_partner,                                  " Business Partner Number
      lv_bp_entry          TYPE bu_partner,
      li_but000            TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,     " Itab: BP General data-I
      li_but0id            TYPE STANDARD TABLE OF lty_but0id INITIAL SIZE 0, " Itab: BP Identifications
      ls_but0id            TYPE lty_but0id,
      li_but0id_tmp        TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications
      li_but0id_old        TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications-Old
      li_relations         TYPE STANDARD TABLE OF lty_relations INITIAL SIZE 0,
      ls_relations         TYPE lty_relations, " bapibus1006_relations,
      li_relations_lm      TYPE STANDARD TABLE OF lty_rel_lm INITIAL SIZE 0,
      lst_relations_lm_new TYPE lty_rel_lm,
      lst_relations_new    TYPE lty_relations,
      li_relations_old     TYPE STANDARD TABLE OF bapibus1006_relations INITIAL SIZE 0, " Itab: Relationships
      li_return            TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " Itab: Return table
      lv_trtab_count       TYPE i,                                           " Log table count
      li_trtab             TYPE STANDARD TABLE OF trtab INITIAL SIZE 0,      " Itab: Log
      ls_trtab             TYPE trtab,                                       " Log table structure
      li_relations_mem     TYPE STANDARD TABLE OF but050 INITIAL SIZE 0,     " Itab: Relationships
      li_relations_lm_old  TYPE STANDARD TABLE OF bus050___i INITIAL SIZE 0, " Itab: Relationships
      li_relations_lm_tmp  TYPE STANDARD TABLE OF bus050___i INITIAL SIZE 0,
*      ls_but050            TYPE but050,
*      ls_bus050_vtp        TYPE bus050_vtp,
      lv_relation_entry    TYPE abap_bool VALUE abap_false.

* Local constants
CONSTANTS:
  lc_titlebar    TYPE text25     VALUE 'Invalid Relationship(s)',             " Title text for Pop-up
  lc_reltype     TYPE bu_id_type VALUE 'ZRLCT',                               " Identification Type: Valid Relationship Category
  lc_invalid_txt TYPE string     VALUE 'Found Invalid Relationship With BP#', " Text for Log information-1
  lc_reltyp_txt  TYPE string     VALUE '& Relationship Category:',            " Text for Log information-2
*  lc_enter_bp_txt TYPE string     VALUE 'Entered BP#',
*  lc_with_reltyp  TYPE string     VALUE 'With Relationship Category:',
*  lc_notvalid     TYPE string     VALUE 'is not valid',
  lc_act_typ_01  TYPE bu_aktyp   VALUE '01',                                  " Create
  lc_act_typ_02  TYPE bu_aktyp   VALUE '02',
  lc_act_typ_03  TYPE bu_aktyp   VALUE '03',
  lc_f           TYPE char1      VALUE 'F',
  lc_t           TYPE char1      VALUE 'T',
  lc_d           TYPE char1      VALUE 'D',
  lc_x           TYPE char1      VALUE 'X',
  lc_y           TYPE char1      VALUE 'Y',
*  lc_msgno_304   TYPE syst_msgno VALUE '304',
  lc_msgno_302   TYPE syst_msgno VALUE '302'.                                 " Error message number.


* FM call for BP Control (Create/Change/Display)
CALL FUNCTION 'BUS_PARAMETERS_ISSTA_GET'
  IMPORTING
    e_aktyp = lv_aktyp.

IF lv_aktyp = lc_act_typ_01 OR lv_aktyp = lc_act_typ_02 OR
   lv_aktyp = lc_act_typ_03.

* FM call to fetch the BP Id
  CALL FUNCTION 'BUP_BUPA_BUT000_GET'
    TABLES
      et_but000 = li_but000.
  IF li_but000 IS NOT INITIAL.
    lv_bp_num = li_but000[ 1 ]-partner.
  ENDIF.

* FM call to fetch the Identification details
  CALL FUNCTION 'BUP_BUPA_BUT0ID_GET'
    TABLES
      t_but0id     = li_but0id_tmp
      t_but0id_old = li_but0id_old.

  IF li_but0id_tmp[] IS NOT INITIAL.
    DELETE li_but0id_tmp WHERE type <> lc_reltype.
  ENDIF.
  LOOP AT li_but0id_tmp INTO DATA(lst_but0id_tmp).
    IF lst_but0id_tmp-idnumber+0(1) <> lc_f AND
       lst_but0id_tmp-idnumber+0(1) <> lc_t.

      ls_but0id-partner = lst_but0id_tmp-partner.
      ls_but0id-idnumber = lst_but0id_tmp-idnumber.
      ls_but0id-type = lst_but0id_tmp-type.
      APPEND ls_but0id TO li_but0id.

      CONCATENATE lc_f lst_but0id_tmp-idnumber INTO ls_but0id-idnumber.
      APPEND ls_but0id TO li_but0id.

      CONCATENATE lc_t lst_but0id_tmp-idnumber INTO ls_but0id-idnumber.
      APPEND ls_but0id TO li_but0id.
      CLEAR ls_but0id.

    ELSE.
      ls_but0id-partner = lst_but0id_tmp-partner.
      ls_but0id-type = lst_but0id_tmp-type.
      ls_but0id-idnumber = lst_but0id_tmp-idnumber.
      APPEND ls_but0id TO li_but0id.
      CLEAR ls_but0id.
    ENDIF.
  ENDLOOP.
  REFRESH li_but0id_tmp.

  CASE lv_aktyp. " Activity Category (Create/Change)

    WHEN lc_act_typ_01.  " 01 indicates BP Create
* FM call to fetch the BP relationships from Local Memory (LM)
      CALL FUNCTION 'BUB_BUPR_BUT050_LM_READ'
        EXPORTING
          i_xlm1         = 'X'
          i_xlm2         = 'X'
          i_xdb          = ' '
          i_xrf          = ' '
        TABLES
          t_relations    = li_relations_mem
          t_relations_lm = li_relations_lm_old.

      IF li_relations_lm_old[] IS NOT INITIAL.
        DELETE li_relations_lm_old WHERE action = lc_d. " D indicates Delete
        DELETE li_relations_lm_old WHERE action = lc_x. " X indicates Delete after creating
        DELETE li_relations_lm_old WHERE action = lc_y. " Y indicates Delete after changing
      ENDIF.
*--*Prabhu - Return table parameter of above FM has relationship category with 6character
*--*To validate 7 character relation type, took an extra internal table and moved the data of old itab
*--* into new one along with additional character.
      LOOP AT li_relations_lm_old INTO DATA(lst_relations_lm_old).
        MOVE-CORRESPONDING lst_relations_lm_old TO lst_relations_lm_new.
        IF lv_bp_num = lst_relations_lm_old-partner1.
          CONCATENATE lc_f lst_relations_lm_old-reltyp INTO lst_relations_lm_new-reltyp.
        ELSE.
          CONCATENATE lc_t lst_relations_lm_old-reltyp INTO lst_relations_lm_new-reltyp.
        ENDIF.
        APPEND lst_relations_lm_new TO li_relations_lm.
        CLEAR: lst_relations_lm_new, lst_relations_lm_old.
      ENDLOOP.
      REFRESH: li_relations_lm_old, li_relations_mem.

    WHEN lc_act_typ_02 OR lc_act_typ_03. " 02 indicates BP Change / 03 indicates display
* FM call to fetch the BP relationships from Local Memory (LM)
* FYI... Added/Deleted relationships for an existing BP resides in LM
      CALL FUNCTION 'BUB_BUPR_BUT050_LM_READ'
        EXPORTING
          i_xlm1         = 'X'
          i_xlm2         = 'X'
          i_xdb          = ' '
          i_xrf          = ' '
        TABLES
          t_relations    = li_relations_mem
          t_relations_lm = li_relations_lm_old.

*--*Prabhu - Return table parameter of above FM has relationship category with 6character
*--*To validate 7 character relation type, took an extra internal table and moved the data of old itab
*--* into new one along with additional character.
      LOOP AT li_relations_lm_old INTO DATA(lst_relations_lm_old2).
        MOVE-CORRESPONDING lst_relations_lm_old2 TO lst_relations_lm_new.
        IF lv_bp_num = lst_relations_lm_old-partner1.
          CONCATENATE lc_f lst_relations_lm_old2-reltyp INTO lst_relations_lm_new-reltyp.
        ELSE.
          CONCATENATE lc_t lst_relations_lm_old2-reltyp INTO lst_relations_lm_new-reltyp.
        ENDIF.
        APPEND lst_relations_lm_new TO li_relations_lm.
        CLEAR: lst_relations_lm_new, lst_relations_lm_old2.
      ENDLOOP.
      REFRESH: li_relations_lm_old, li_relations_mem.

* FM call to fetch the BP relationships from DB
      CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
        EXPORTING
          iv_partner       = lv_bp_num
        TABLES
          et_relationships = li_relations_old
          et_return        = li_return.
*--*Prabhu - Return table parameter of above FM has relationship category with 6character
*--*To validate 7 character relation type, took an extra internal table and moved the data of old itab
*--* into new one along with additional character.
      LOOP AT li_relations_old INTO DATA(lst_relations_old).
        MOVE-CORRESPONDING lst_relations_old TO lst_relations_new.
        IF lv_bp_num = lst_relations_old-partner1.
          CONCATENATE lc_f lst_relations_old-relationshipcategory INTO lst_relations_new-relationshipcategory.
        ELSE.
          CONCATENATE lc_t lst_relations_old-relationshipcategory INTO lst_relations_new-relationshipcategory.
        ENDIF.
        APPEND lst_relations_new TO li_relations.
        CLEAR: lst_relations_new, lst_relations_old.
      ENDLOOP.
      REFRESH li_relations_old.

      IF li_relations[] IS NOT INITIAL.
        SORT li_relations BY partner1 partner2 relationshipcategory.
*          DELETE ADJACENT DUPLICATES FROM li_relations
*                          COMPARING relationshipcategory.
        " Iterate the LM relationships (Added/Deleted relationships of a BP)
        " and delete them from DB Relationships if the LM relationship
        " action is D/X/Y, else add them to DB Relationships
        LOOP AT li_relations_lm INTO DATA(lis_relations_lm).
          DATA(liv_sytabix) = sy-tabix.
          READ TABLE li_relations WITH KEY partner1 = lis_relations_lm-partner1
                                           partner2 = lis_relations_lm-partner2
                                           relationshipcategory = lis_relations_lm-reltyp
                                  TRANSPORTING NO FIELDS BINARY SEARCH.
          IF sy-subrc = 0.
            IF lis_relations_lm-action = lc_d OR  " D indicates Delete
               lis_relations_lm-action = lc_x OR  " X indicates Delete after creating
               lis_relations_lm-action = lc_y.    " Y indicates Delete after changing
              DELETE li_relations INDEX sy-tabix.
              DELETE li_relations_lm INDEX liv_sytabix.
            ENDIF.
          ELSE.
            APPEND lis_relations_lm TO li_relations_lm_tmp.
            DELETE li_relations_lm INDEX liv_sytabix.
          ENDIF.
          CLEAR lis_relations_lm.
        ENDLOOP.

        IF li_relations_lm_tmp[] IS NOT INITIAL.
* Adding LM Relationships to DB Relationships
          LOOP AT li_relations_lm_tmp INTO DATA(lis_relations_lm_tmp).
            ls_relations-partner1 = lis_relations_lm_tmp-partner1.
            ls_relations-partner2 = lis_relations_lm_tmp-partner2.
            ls_relations-relationshipcategory = lis_relations_lm_tmp-reltyp.
            ls_relations-validfromdate = lis_relations_lm_tmp-date_from.
            ls_relations-validuntildate = lis_relations_lm_tmp-date_to.
            APPEND ls_relations TO li_relations.
            CLEAR: ls_relations, lis_relations_lm_tmp.
          ENDLOOP.
          REFRESH li_relations_lm_tmp.
        ENDIF. " IF li_relations_lm_tmp[] IS NOT INITIAL.
      ENDIF. " IF li_relations[] IS NOT INITIAL

    WHEN OTHERS.
***    No need of OTHERS in this CASE

  ENDCASE. " CASE lv_aktyp

* Check for BP Identifications
  IF li_but0id[] IS NOT INITIAL.

    SORT li_but0id BY type.
* If corresponding Identifications are not found for the current BP,
* no need to trigger the validation logic for BP relationships
    READ TABLE li_but0id WITH KEY type = lc_reltype
                         TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc = 0.
      " Since Valid Relationship Category (ZRLCT) found under Identification tab for a BP,
      " proceed with the BP relationships validation Logic
      SORT li_but0id BY type idnumber.

      CASE lv_aktyp. " Activity Category
        WHEN lc_act_typ_01.  " 01 indicates Create
          LOOP AT li_relations_lm ASSIGNING FIELD-SYMBOL(<lif_relations_lm>).
            READ TABLE li_but0id WITH KEY type = lc_reltype
                                          idnumber = <lif_relations_lm>-reltyp
                                 TRANSPORTING NO FIELDS BINARY SEARCH.
            IF sy-subrc <> 0.
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*                EXPORTING
*                  input  = <lif_relations_mem>-partner2
*                IMPORTING
*                  output = <lif_relations_mem>-partner2.
              IF <lif_relations_lm>-reltyp+0(1) = lc_f.
                lv_bp_entry = <lif_relations_lm>-partner2.
              ELSE.
                lv_bp_entry = <lif_relations_lm>-partner1.
              ENDIF.
              CONCATENATE lc_invalid_txt lv_bp_entry
                          lc_reltyp_txt <lif_relations_lm>-reltyp
                          INTO ls_trtab-line SEPARATED BY space.
              APPEND ls_trtab TO li_trtab.
              CLEAR ls_trtab.
            ENDIF.
          ENDLOOP.

        WHEN lc_act_typ_02 OR lc_act_typ_03. " 02 indicates Change
          IF li_relations[] IS NOT INITIAL.
            LOOP AT li_relations ASSIGNING FIELD-SYMBOL(<lif_relations>).
              READ TABLE li_but0id WITH KEY type = lc_reltype
                                            idnumber = <lif_relations>-relationshipcategory
                                   TRANSPORTING NO FIELDS BINARY SEARCH.
              IF sy-subrc <> 0.
                IF <lif_relations>-relationshipcategory+0(1) = lc_f.
                  lv_bp_entry = <lif_relations>-partner2.
                ELSE.
                  lv_bp_entry = <lif_relations>-partner1.
                ENDIF.
                CONCATENATE lc_invalid_txt lv_bp_entry
                            lc_reltyp_txt <lif_relations>-relationshipcategory
                            INTO ls_trtab-line SEPARATED BY space.
                APPEND ls_trtab TO li_trtab.
                CLEAR ls_trtab.
              ENDIF.
            ENDLOOP.
          ELSEIF li_relations_lm[] IS NOT INITIAL.
            LOOP AT li_relations_lm ASSIGNING FIELD-SYMBOL(<lif_relations_m>).
              READ TABLE li_but0id WITH KEY type = lc_reltype
                                            idnumber = <lif_relations_m>-reltyp
                                   TRANSPORTING NO FIELDS BINARY SEARCH.
              IF sy-subrc <> 0.
                IF <lif_relations_m>-reltyp+0(1) = lc_f.
                  lv_bp_entry = <lif_relations_m>-partner2.
                ELSE.
                  lv_bp_entry = <lif_relations_m>-partner1.
                ENDIF.
                CONCATENATE lc_invalid_txt lv_bp_entry
                            lc_reltyp_txt <lif_relations_m>-reltyp
                            INTO ls_trtab-line SEPARATED BY space.
                APPEND ls_trtab TO li_trtab.
                CLEAR ls_trtab.
              ENDIF.
            ENDLOOP.
          ENDIF. " IF li_relations[] IS NOT INITIAL.

        WHEN OTHERS.
*         No need of OTHERS in this CASE
      ENDCASE.

      SORT li_trtab BY line.
      DELETE ADJACENT DUPLICATES FROM li_trtab COMPARING line.
      lv_trtab_count = lines( li_trtab ).
* Check entries in the Log table
      IF lv_trtab_count >= 1.

        DATA(lv_linesize) = strlen( li_trtab[ 1 ]-line ).
        lv_linesize = lv_linesize + 10.

        CALL FUNCTION 'LAW_SHOW_POPUP_WITH_TEXT'
          EXPORTING
            titelbar         = lc_titlebar
            line_size        = lv_linesize
          TABLES
            list_tab         = li_trtab
          EXCEPTIONS
            action_cancelled = 1
            OTHERS           = 2.
        IF sy-subrc = 0.
          CALL FUNCTION 'BUS_MESSAGE_STORE'
            EXPORTING
              arbgb = 'ZQTC_R2'
              msgty = 'E'
              txtnr = lc_msgno_302.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF lv_trtab_count >= 1
    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF li_but0id[] IS NOT INITIAL

  REFRESH: li_relations, li_relations_lm, li_but0id, li_trtab.
ENDIF. " IF lv_aktyp = '01' OR lv_aktyp = '02' OR lv_aktyp = '03'
