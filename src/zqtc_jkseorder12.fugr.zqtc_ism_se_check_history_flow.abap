*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_ISM_SE_CHECK_HISTORY_FLOW (Function Module)*
* PROGRAM DESCRIPTION: Copy of ISM_SE_CHECK_HISTORY_FLOW               *
*                      Additional check for duplicate release order    *
*                      contract along with item no.                    *
* DEVELOPER:           Nikhilesh Palla (NPALLA)                        *
* CREATION DATE:       09-DEC-2019                                     *
* OBJECT ID:           E142                                            *
* TRANSPORT NUMBER(S): ED2K917037                                      *
*----------------------------------------------------------------------*
function ZQTC_ISM_SE_CHECK_HISTORY_FLOW.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IN_ISSUE) TYPE  MATNR
*"     REFERENCE(IN_VBELN) TYPE  VBELN
*"     REFERENCE(IN_POSNR) TYPE  POSNR
*"     REFERENCE(IN_QUANTITY) TYPE  JORDERQUAN
*"     REFERENCE(IN_UNIT) TYPE  JORDERUNIT
*"     REFERENCE(IN_TESTRUN) TYPE  CHAR01
*"     REFERENCE(IN_MESSAGE) TYPE REF TO  CL_ISM_SD_MESSAGE
*"  EXPORTING
*"     REFERENCE(OUT_CHECK_FAILED) TYPE  XFELD
*"     REFERENCE(OUT_CALL_PROCESSING) TYPE  XFELD
*"----------------------------------------------------------------------
  data issue type jkseflow-issue.

* OUT_CALL_PROCESSING initialisieren
  clear out_call_processing.

* Prüfe, ob Kunde die Ausgabe bereits erhalten hat
  select issue into issue from jkseflow up to 1 rows
    where contract_vbeln = in_vbeln and
          contract_posnr = in_posnr and    "++ED2K917037
          issue          = in_issue.
  endselect.
  if sy-subrc = 0.
    out_check_failed = 'X'.
  else.
    clear out_check_failed.
  endif.
endfunction.
