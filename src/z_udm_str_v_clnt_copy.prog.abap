*&---------------------------------------------------------------------*
*& Report  Z_UDM_STR_V_CLNT_COPY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*&Created as part of OSS Note 1277798 - Problem related to client copy
REPORT z_udm_str_v_clnt_copy.

TABLES: udm_pr_head, udm_strategy_v, dfpm_numb.

PARAMETERS: source  LIKE sy-mandt OBLIGATORY,
            target  LIKE sy-mandt DEFAULT sy-mandt OBLIGATORY,
            correct TYPE boolean. "Inconsistencies are corrected only when this flag is set otherwise it only displays

INITIALIZATION.
  LOOP AT SCREEN.
    IF screen-name = 'TARGET'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  DATA: lt_strategy  TYPE TABLE OF udm_strategy_v,
        lt_dfpm_numb TYPE TABLE OF dfpm_numb,
        lt_pr_head   TYPE TABLE OF udm_pr_head.

* Collect the udm_strategy_v entries from the source client.
  SELECT * FROM udm_strategy_v CLIENT SPECIFIED INTO TABLE lt_strategy
  WHERE mandt = source.

  IF lt_strategy[] IS NOT INITIAL AND correct IS NOT INITIAL.
*Insert the entries fetched from the source client
    INSERT udm_strategy_v FROM TABLE lt_strategy ACCEPTING DUPLICATE KEYS.
  ENDIF.

* read corresponding entries from dfpm_numb relevant for strategy and pr_head tables
  SELECT object key1 key2 current_number FROM dfpm_numb
    INTO CORRESPONDING FIELDS OF TABLE lt_dfpm_numb
    WHERE object = 'UDM_PR' OR object = 'UDMSTR'.

* Read corresponding entries from udm_pr_head
  SELECT prog_id MAX( run_id ) AS run_id FROM udm_pr_head
    INTO CORRESPONDING FIELDS OF TABLE lt_pr_head GROUP BY prog_id.

* get the list of strategies and their highest version
  SELECT coll_strategy MAX( version ) AS version FROM udm_strategy_v
  INTO CORRESPONDING FIELDS OF TABLE lt_strategy GROUP BY coll_strategy.

* display the inconsistencies of the starategies with resp to dfpm_numb
  LOOP AT lt_strategy INTO udm_strategy_v.
    READ TABLE lt_dfpm_numb INTO dfpm_numb WITH KEY object = 'UDMSTR'
                    key1 = udm_strategy_v-coll_strategy key2 = sy-mandt.
    IF sy-subrc = 0.
      IF dfpm_numb-current_number = udm_strategy_v-version.
        WRITE / : 'No inconsistency with strategy        :', udm_strategy_v-coll_strategy.
      ELSE.
        IF correct IS INITIAL.
          WRITE / : 'Inconsistency with strategy          :', udm_strategy_v-coll_strategy.
        ELSE.
          WRITE / : 'Inconsistency corrected for strategy :', udm_strategy_v-coll_strategy.
          UPDATE dfpm_numb SET current_number = udm_strategy_v-version
                           WHERE object = 'UDMSTR'
                             AND key1 = dfpm_numb-key1
                             AND key2 = sy-mandt.
        ENDIF.
      ENDIF.
    ELSE.
      IF correct IS INITIAL.
        WRITE / : 'Inconsistency with strategy          :', udm_strategy_v-coll_strategy.
      ELSE.
        WRITE / : 'Inconsistency corrected for strategy :', udm_strategy_v-coll_strategy.
        CLEAR dfpm_numb.
        dfpm_numb-object = 'UDMSTR'.
        dfpm_numb-key1 = udm_strategy_v-coll_strategy.
        dfpm_numb-key2 = sy-mandt.
        dfpm_numb-creation_date = sy-datum.
        dfpm_numb-current_number = udm_strategy_v-version.
        MODIFY dfpm_numb.
      ENDIF.
    ENDIF.
  ENDLOOP.

* display the inconsistencies with different objects of pr_head
  LOOP AT lt_pr_head INTO udm_pr_head.
    READ TABLE lt_dfpm_numb INTO dfpm_numb WITH KEY object = 'UDM_PR'
                     key1 = udm_pr_head-prog_id key2 = sy-mandt.
    IF dfpm_numb-current_number = udm_pr_head-run_id.
      WRITE / : 'No inconsistency with object          :', udm_pr_head-prog_id.
    ELSE.
      IF correct IS INITIAL.
        WRITE / : 'Inconsistency with object            :', udm_pr_head-prog_id.
      ELSE.
        WRITE / : 'Inconsistency corrected for object   :', udm_pr_head-prog_id.
        UPDATE dfpm_numb SET current_number = udm_pr_head-run_id
                         WHERE object = 'UDM_PR'
                           AND key1 = dfpm_numb-key1
                           AND key2 = sy-mandt.
      ENDIF.
    ENDIF.
  ENDLOOP.

  COMMIT WORK.
