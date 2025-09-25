FUNCTION zqtc_bur_bupr_event_dchck_e165.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*------------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_BUR_BUPR_EVENT_DCHCK_E165
*                       called via BDT BP Relationships event: DCHCK
* DESCRIPTION: BP Validations
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 07/04/2018
* OBJECT ID: E165 / CR# 6664
* TRANSPORT NUMBER(s): ED2K913317
*------------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_BUR_BUPR_EVENT_DCHCK_E165
*                       called via BDT BP Relationships event: DCHCK
* DESCRIPTION: SAP BP Job Name: BP_TAX_EXEMPT_UPDATE_E230
*                       Terminated in EP1
* DEVELOPER: BTIRUVATHU
* CREATION DATE: 01/18/2022
* OBJECT ID: INC0424056
* TRANSPORT NUMBER(s): ED2K925570
*------------------------------------------------------------------------*

* Local Types
  TYPES: BEGIN OF lty_rel_lm,
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
  DATA: lv_aktyp          TYPE bu_aktyp,                                    " Activity Category
        lv_bp_num         TYPE bu_partner,                                  " Business Partner Number
        lv_bp_entry       TYPE bu_partner,
        li_but000         TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,     " Itab: BP General data-I
        li_but0id         TYPE STANDARD TABLE OF lty_but0id INITIAL SIZE 0, " Itab: BP Identifications
        ls_but0id         TYPE lty_but0id,
        li_but0id_tmp     TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications
        li_but0id_old     TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,     " Itab: BP Identifications-Old
        li_relations_lm   TYPE STANDARD TABLE OF lty_rel_lm INITIAL SIZE 0,
        lst_relations_lm  TYPE lty_rel_lm,
        lv_trtab_count    TYPE i,                                           " Log table count
        li_trtab          TYPE STANDARD TABLE OF trtab INITIAL SIZE 0,      " Itab: Log
        ls_trtab          TYPE trtab,                                       " Log table structure
        ls_but050         TYPE but050,
        ls_bus050_vtp     TYPE bus050_vtp,
        lv_actv_flag_e165 TYPE zactive_flag. " Active/Inactive Flag

* Local constants
  CONSTANTS:
    lc_titlebar       TYPE text25     VALUE 'Invalid Relationship(s)',             " Title text for Pop-up
    lc_reltype        TYPE bu_id_type VALUE 'ZRLCT',                               " Identification Type: Valid Relationship Category
    lc_enter_bp_txt   TYPE string     VALUE 'Entered BP#',
    lc_with_reltyp    TYPE string     VALUE 'With Relationship Category:',
    lc_notvalid       TYPE string     VALUE 'is not valid',
    lc_f              TYPE c          VALUE 'F',
    lc_t              TYPE c          VALUE 'T',
    lc_act_typ_01     TYPE bu_aktyp   VALUE '01',                                  " Create
    lc_act_typ_02     TYPE bu_aktyp   VALUE '02',                                  " Change
    lc_act_typ_03     TYPE bu_aktyp   VALUE '03',                                  " Dispaly
    lc_msgno_302      TYPE syst_msgno VALUE '302',                                 " Error message number
    lc_msgno_304      TYPE syst_msgno VALUE '304',
    lc_wricef_id_e165 TYPE zdevid     VALUE 'E165',              " Development ID
    lc_sno_e165_001   TYPE zsno       VALUE '001',               " Serial Number
    lc_var_key_e165   TYPE zvar_key   VALUE 'RELTYP_VALIDATION'. " Variable Key

* Trigger Standard BDT Event DCHCK FM: Checks Before Saving (Cross-View)
* Item: 100000
  CALL FUNCTION 'BUR_BUPR_EVENT_DCHCK'.

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e165
      im_ser_num     = lc_sno_e165_001
      im_var_key     = lc_var_key_e165
    IMPORTING
      ex_active_flag = lv_actv_flag_e165.

  IF lv_actv_flag_e165 EQ abap_true.

* FM call for BP Control (Create/Change)
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

* FM call to fetch the details of BP Relationship Cat. Entry
      CALL FUNCTION 'BUB_BUPR_BUT050_GET'
        IMPORTING
          e_but050     = ls_but050
          e_bus050_vtp = ls_bus050_vtp.
      IF ls_but050 IS NOT INITIAL AND
         ls_but050-reltyp IS NOT INITIAL.

        IF lv_bp_num = ls_but050-partner1.
          lv_bp_entry = ls_but050-partner2.
        ELSE.
          lv_bp_entry = ls_but050-partner1.
        ENDIF.

        lst_relations_lm-partner1 = ls_but050-partner1.
        lst_relations_lm-partner2 = ls_but050-partner2.
        lst_relations_lm-reltyp = ls_but050-reltyp.
        IF lv_bp_num = lst_relations_lm-partner1.
          CONCATENATE lc_f lst_relations_lm-reltyp INTO lst_relations_lm-reltyp.
        ELSE.
          CONCATENATE lc_t lst_relations_lm-reltyp INTO lst_relations_lm-reltyp.
        ENDIF.
        lst_relations_lm-date_from = ls_but050-date_from.
        lst_relations_lm-date_to = ls_but050-date_to.

        APPEND lst_relations_lm TO li_relations_lm.
        CLEAR: lst_relations_lm.

      ENDIF. " IF ls_but050 IS NOT INITIAL AND

* FM Call to fetch the Identifications of the entered BP
      CALL FUNCTION 'BUP_BUT0ID_SELECT_WITH_PARTNER'
        EXPORTING
          iv_partner = lv_bp_entry
*         I_VALDT    =
*         I_VALID_TIME       =
*         I_VALDT_SEL        = SY-DATLO
        TABLES
          et_but0id  = li_but0id_tmp
        EXCEPTIONS
          not_found  = 1
          not_valid  = 2
          OTHERS     = 3.
      IF sy-subrc <> 0.
*       Nothing to do
      ELSE.
        IF li_but0id_tmp[] IS NOT INITIAL.
          DELETE li_but0id_tmp WHERE type <> lc_reltype.
        ENDIF.
      ENDIF.

* Check for BP Identifications
      IF li_but0id[] IS NOT INITIAL OR
         li_but0id_tmp IS NOT INITIAL.

        SORT li_but0id BY type.
* If corresponding Identifications are not found for the current BP,
* no need to trigger the validation logic for BP relationships
        READ TABLE li_but0id WITH KEY type = lc_reltype
                             TRANSPORTING NO FIELDS BINARY SEARCH.
        IF sy-subrc = 0.
          " Since Valid Relationship Category (ZRLCT) found under Identification tab for a BP,
          " proceed with the BP relationships validation Logic
          SORT li_but0id BY type idnumber.

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
              CONCATENATE lc_enter_bp_txt lv_bp_entry
                          lc_with_reltyp <lif_relations_lm>-reltyp
                          lc_notvalid
                          INTO ls_trtab-line SEPARATED BY space.
              APPEND ls_trtab TO li_trtab.
              CLEAR: ls_trtab, lv_bp_entry.
            ENDIF.
          ENDLOOP.
        ENDIF. " IF sy-subrc = 0

*** Checking the ZRLCT relation ships of the entered BP
        IF li_trtab[] IS INITIAL AND
           li_but0id_tmp[] IS NOT INITIAL.

          LOOP AT li_but0id_tmp INTO DATA(lis_but0id).
            DATA(liv_len) = strlen( lis_but0id-idnumber ).
            IF liv_len = 7.
              SHIFT lis_but0id-idnumber BY 1 PLACES LEFT.
              MODIFY li_but0id_tmp FROM lis_but0id INDEX sy-tabix
                                   TRANSPORTING idnumber.
            ENDIF.
            CLEAR lis_but0id.
          ENDLOOP.
          SORT li_but0id_tmp BY type idnumber.
          READ TABLE li_but0id_tmp WITH KEY type = lc_reltype
                                        idnumber = ls_but050-reltyp
                                   TRANSPORTING NO FIELDS BINARY SEARCH.
          IF sy-subrc <> 0.
            DATA(lv_reltyp) = li_relations_lm[ 1 ]-reltyp.
            CONCATENATE lc_enter_bp_txt lv_bp_entry
                        lc_with_reltyp lv_reltyp
                        lc_notvalid
                        INTO ls_trtab-line SEPARATED BY space.
            APPEND ls_trtab TO li_trtab.
            CLEAR: ls_trtab, lv_bp_entry, ls_but050.
          ENDIF.
          REFRESH li_but0id_tmp.
        ENDIF. " IF li_trtab[] IS INITIAL AND

        lv_trtab_count = lines( li_trtab ).
* Check entries in the Log table
        IF lv_trtab_count >= 1.

          DATA(lv_linesize) = strlen( li_trtab[ 1 ]-line ).
          lv_linesize = lv_linesize + 10.

* BOC by BTIRUVATHU - INC0424056 - 01/18/2022 - ED2K925570
          IF sy-batch NE 'X'.
* EOC by BTIRUVATHU - INC0424056 - 01/18/2022 - ED2K925570
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
                  txtnr = lc_msgno_304.
            ENDIF.
* BOC by BTIRUVATHU - INC0424056 - 01/18/2022 - ED2K925570
          ELSE.
            CALL FUNCTION 'BUS_MESSAGE_STORE'
              EXPORTING
                arbgb = 'ZQTC_R2'
                msgty = 'E'
                txtnr = lc_msgno_304.
          ENDIF.
* EOC by BTIRUVATHU - INC0424056 - 01/18/2022 - ED2K925570
        ENDIF. " IF lv_trtab_count >= 1

      ENDIF. " IF li_but0id[] IS NOT INITIAL OR

      REFRESH: li_but0id, li_relations_lm, li_trtab.
      CLEAR: lv_bp_entry, ls_but050.
    ENDIF. " IF lv_aktyp = '01' OR lv_aktyp = '02'

  ENDIF. " IF lv_actv_flag_e165 EQ abap_true

ENDFUNCTION.
