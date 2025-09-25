*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_VALIDITY_DATES_HEADER (Include Program)
*               [Called from Standard Subroutine CHECK_VALIDITY_CONTRACT
*               Of Program LJKSESAPMV45AF01]
* PROGRAM DESCRIPTION: Ignore Header Contract Validity Dates; only Item
*                      level Contract Validity Dates will be considered
*                      for determining Media Issues
*                      [Copied standard logic with small modifications]
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 10/10/2017
* OBJECT ID: E166
* TRANSPORT NUMBER(S): ED2K908494
*----------------------------------------------------------------------*
DATA: lvz_valid_from      TYPE veda-vbegdat,
      lvz_valid_until     TYPE veda-venddat,
      lvz_guebg           TYPE vbak-guebg,
      lvz_gueen           TYPE vbak-gueen,
      lvz_veda_date_from  TYPE veda-venddat,
      lvz_veda_date_until TYPE veda-vbegdat.

* Rückgabewerte initialisieren
CLEAR out_valid.

* Wenn keine Einschränkung => okay.
IF in_valid_from IS INITIAL AND
   in_valid_until IS INITIAL.
  out_valid = 'X'.
  EXIT.
ENDIF.

* Übernahme der übergebenen Werte in lokale Variablen
lvz_valid_from      = in_valid_from.
lvz_valid_until     = in_valid_until.
* Begin of CHANGE: Deviation from Standard Logic
*lvz_guebg           = in_guebg.
*lvz_gueen           = in_gueen.
IF in_veda_date_from IS NOT INITIAL.
  lvz_guebg           = in_veda_date_from.
ELSE.
  lvz_guebg           = in_guebg.
ENDIF.
IF in_veda_date_until IS NOT INITIAL.
  lvz_gueen           = in_veda_date_until.
ELSE.
  lvz_gueen           = in_gueen.
ENDIF.
* End   of CHANGE: Deviation from Standard Logic
lvz_veda_date_from  = in_veda_date_from.
lvz_veda_date_until = in_veda_date_until.

* Setze lvz_valid_from um
IF lvz_valid_from IS INITIAL.
  lvz_valid_from = '99991231'.
ENDIF.
* Setze lvz_gueen um
IF lvz_gueen IS INITIAL.
  lvz_gueen = '99991231'.
ENDIF.
* Setze lvz_veda_date_until um
IF lvz_veda_date_until IS INITIAL.
  lvz_veda_date_until = '99991231'.
ENDIF.

IF lvz_guebg >= lvz_valid_from AND
   lvz_guebg <= lvz_valid_until.
  out_valid = 'X'.
ELSEIF lvz_gueen >= lvz_valid_from AND
       lvz_gueen <= lvz_valid_until.
  out_valid = 'X'.
ELSEIF lvz_guebg <= lvz_valid_from AND
       lvz_gueen >= lvz_valid_until.
  out_valid = 'X'.
ELSE.
  CLEAR out_valid.
  EXIT.
ENDIF.

* Vertragsdaten berücksichtigen
IF lvz_veda_date_from IS INITIAL AND
   lvz_veda_date_until IS INITIAL.
  out_valid = 'X'.
  EXIT.
ELSE.
  IF lvz_veda_date_from >= lvz_valid_from AND
     lvz_veda_date_from <= lvz_valid_until.
    out_valid = 'X'.
  ELSEIF lvz_veda_date_until >= lvz_valid_from AND
         lvz_veda_date_until <= lvz_valid_until.
    out_valid = 'X'.
  ELSEIF lvz_veda_date_from <= lvz_valid_from AND
         lvz_veda_date_until >= lvz_valid_until.
    out_valid = 'X'.
  ELSE.
    CLEAR out_valid.
  ENDIF.
ENDIF.
RETURN. " Skip Standard Logic
