*-------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_CONSTANT_TBF01
* PROGRAM DESCRIPTION: Table maintenance event for ZQTC_CONSTANT_TB table.
* Update changed by and changed on fields On SAVE event
* DEVELOPER: Siva Guda
* CREATION DATE:  02/27/2020
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K917665
*-------------------------------------------------------------------*

*----------------------------------------------------------------------*
***INCLUDE LZQTC_CONSTANT_TBF01.
*----------------------------------------------------------------------*
FORM f_on_save.

*Local data declarations
  DATA: lv_tot_index TYPE sy-tabix,
        lv_ext_index TYPE sy-tabix.

*Local field symbol declarations
  FIELD-SYMBOLS: <lfs_record> TYPE any. " Work area for table

*Local constants
  CONSTANTS: lc_new_entry TYPE char1 VALUE 'N',
             lc_upd_entry TYPE char1 VALUE 'U'.

*loop over the table contents
  LOOP AT total.
    lv_tot_index = sy-tabix.
* Assign the table header line to the work area
    ASSIGN total TO <lfs_record>.

    IF <action> = lc_new_entry OR <action> = lc_upd_entry.      " New or updated entry
      READ TABLE extract WITH KEY <vim_xtotal_key>.
      IF sy-subrc = 0.
        lv_ext_index = sy-tabix.

        <lfs_record>+113(12) = sy-uname.
        <lfs_record>+125(8)  = sy-datum.

*       Modify total table
        MODIFY total FROM <lfs_record> INDEX lv_tot_index.

        extract = <lfs_record>.
*       Modify extract table
        MODIFY extract INDEX lv_ext_index.

      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.   "F_ON_SAVE
