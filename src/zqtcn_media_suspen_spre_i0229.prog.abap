*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MEDIA_SUSPEN_SPRE_I0229
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTCN_MEDIA_SUSPEN_SPRE_I0229
* PROGRAM DESCRIPTION:  Capture the Changes to table JKSEINTERRUPT and
*               update internal tables
*                   - i_insert_tab
*                   - i_update_tab
*                   - i_delete_tab
*               ( Variables are getting cleared in FM ISM_SE_MV45A_SAVE_INTERRUPTION
*               these details are captured here and used to generate SLG1
*                Logs in ZQTCN_MEDIA_SUSPEN_SAVE_I0229).
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* CREATION DATE: 09/30/2021
* OBJECT ID:     I0229
* TRANSPORT NUMBER(S): ED2K924568
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES BEGIN OF t_interrupt.
        INCLUDE STRUCTURE jkseinterrupt.
TYPES: cell_tab          TYPE lvc_t_styl,
       data_changed      TYPE char01,
       type_dynp         TYPE jinterrupttype_dynp,
       error             TYPE char01,
       not_on_db         TYPE char01,
       deliveryblocdynp  TYPE rjkseinterrupt01-deliveryblocdynp,
       reasoncodedynp    TYPE rjkseinterrupt01-reasoncodedynp,
       old_valid_from    TYPE jkseinterrupt-valid_from,
       old_valid_to      TYPE jkseinterrupt-valid_to,
       old_reason        TYPE jkseinterrupt-reason,
       old_type          TYPE jkseinterrupt-type,
       old_delivery_date TYPE jkseinterrupt-delivery_date,
       old_deliverybloc  TYPE jkseinterrupt-deliverybloc,
       old_reasoncode    TYPE jkseinterrupt-reasoncode,
       END OF t_interrupt.
TYPES: tt_interrupt TYPE TABLE OF t_interrupt.
TYPES: tt_jkseinterrupt TYPE TABLE OF jkseinterrupt.

DATA li_all_interrupt_tab TYPE STANDARD TABLE OF t_interrupt.
DATA li_interrupt_tab     TYPE STANDARD TABLE OF t_interrupt.
DATA li_on_db_tab         TYPE STANDARD TABLE OF jkseinterrupt.
DATA: lst_db              TYPE jkseinterrupt,
      lst_on_db           TYPE jkseinterrupt.
DATA: lv_interrupt        TYPE char50.
FIELD-SYMBOLS: <lfs_i_interrupt_tab> TYPE tt_interrupt.
FIELD-SYMBOLS: <lfs_i_on_db_tab>     TYPE tt_jkseinterrupt.
FIELD-SYMBOLS: <lfs_in>              TYPE t_interrupt,
               <lfs_db>              TYPE jkseinterrupt.

CLEAR: i_insert_tab,
       i_update_tab,
       i_delete_tab.

* Get the Data into Internal tables.
lv_interrupt = '(SAPLJKSESAPMV45A03)ALL_INTERRUPT_TAB[]'.
ASSIGN (lv_interrupt) TO <lfs_i_interrupt_tab>.
li_all_interrupt_tab[] = <lfs_i_interrupt_tab>.
UNASSIGN <lfs_i_interrupt_tab>.

lv_interrupt = '(SAPLJKSESAPMV45A03)INTERRUPT_TAB[]'.
ASSIGN (lv_interrupt) TO <lfs_i_interrupt_tab>.
li_interrupt_tab[] = <lfs_i_interrupt_tab>.
UNASSIGN <lfs_i_interrupt_tab>.

lv_interrupt = '(SAPLJKSESAPMV45A03)ON_DB_TAB[]'.
ASSIGN (lv_interrupt) TO <lfs_i_on_db_tab>.
li_on_db_tab[] = <lfs_i_on_db_tab>.
UNASSIGN <lfs_i_on_db_tab>.

*
APPEND LINES OF li_interrupt_tab[] TO li_all_interrupt_tab[].

SORT li_on_db_tab BY id.
SORT li_all_interrupt_tab BY id.
* Aufbau der I und U-Tabellen
LOOP AT li_all_interrupt_tab ASSIGNING <lfs_in>
  WHERE error = ' '.
  IF NOT <lfs_in>-not_on_db IS INITIAL.
    MOVE-CORRESPONDING <lfs_in> TO lst_db.
    CHECK NOT ( lst_db-valid_from IS INITIAL    AND
                lst_db-valid_to IS INITIAL      AND
                lst_db-reason IS INITIAL        AND
                lst_db-type IS INITIAL          AND
                lst_db-deliverybloc IS INITIAL  AND
                lst_db-delivery_date IS INITIAL AND
                lst_db-no_change_until IS INITIAL ).
    lst_db-vbeln = vbak-vbeln.
    APPEND lst_db TO i_insert_tab.
  ELSE.
    READ TABLE li_on_db_tab INTO lst_on_db WITH KEY
      id = <lfs_in>-id BINARY SEARCH.
    CHECK sy-subrc = 0.
    MOVE-CORRESPONDING <lfs_in> TO lst_db.
    CHECK lst_db <> lst_on_db.
    APPEND lst_db TO i_update_tab.
  ENDIF.
ENDLOOP.

* D-Tabelle aufbauen
LOOP AT li_on_db_tab ASSIGNING <lfs_db>.
*   Wird dieser Unterbrechungssatz noch verwendet?
  READ TABLE li_all_interrupt_tab WITH KEY
      id = <lfs_db>-id BINARY SEARCH TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    APPEND <lfs_db> TO i_delete_tab.
  ENDIF.
ENDLOOP.
