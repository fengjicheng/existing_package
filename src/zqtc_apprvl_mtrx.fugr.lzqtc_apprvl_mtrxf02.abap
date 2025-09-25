*----------------------------------------------------------------------*
***INCLUDE LZQTC_APPRVL_MTRXF02.
**----------------------------------------------------------------------*
** PROGRAM NAME:         F_SAVE_ENTRY                                   *
** PROGRAM DESCRIPTION:  Popalate username, date and time at changes are*
**                       save.
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        16/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_ENTRY
*&---------------------------------------------------------------------*
* Whenever User Changes Or modify the data It updates accordingly and
* changed username, date and Time
*----------------------------------------------------------------------*
FORM f_save_entry.

* VARIABLES------------------------------------------------------------*
  DATA:
        lv_index TYPE sytabix. " Index to note the lines found

* Field Symbols Declaration--------------------------------------------*
  FIELD-SYMBOLS:
                 <fields> TYPE any.

* CONSTANTS------------------------------------------------------------*
  CONSTANTS:
              lc_action TYPE c VALUE 'U' . " Change value

* Which records are changed
  LOOP AT total.
    IF <action> = lc_action.
      READ TABLE extract TRANSPORTING NO FIELDS .
      IF sy-subrc EQ 0.
        lv_index = sy-tabix.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        CLEAR lv_index.
      ENDIF. " IF sy-subrc EQ 0
      CHECK lv_index GT 0 .

* Update By
      ASSIGN COMPONENT 'AENAM' OF STRUCTURE
                        <vim_total_struc> TO <fields>.
      <fields> = sy-uname. " Changed username

* Update on
      ASSIGN COMPONENT 'AEDAT' OF STRUCTURE
                         <vim_total_struc> TO <fields>.
      <fields> = sy-datum. " Changed date

* Update in
      ASSIGN COMPONENT 'AEZET' OF STRUCTURE
                         <vim_total_struc> TO <fields>.
      <fields> = sy-uzeit. " Changed time

      MODIFY total. " Update into Total
      extract = total.
      MODIFY extract INDEX lv_index. " Modify into Extract
      CLEAR lv_index.
    ENDIF. " IF <action> = lc_action
  ENDLOOP. " LOOP AT total
ENDFORM. "SAVE_ENTRY
**----------------------------------------------------------------------*
** PROGRAM NAME:         F_CREATE_ENTRY                                 *
** PROGRAM DESCRIPTION:  Populate username, date and time of change value*
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        16/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*

FORM f_create_entry.
* Whenever User create new entry username, date and time will be saved.
  zqtcv_appr_mtrx-aenam = sy-uname. " Username
  zqtcv_appr_mtrx-aedat = sy-datum. " Create date
  zqtcv_appr_mtrx-aezet = sy-uzeit. " Create time
ENDFORM.
