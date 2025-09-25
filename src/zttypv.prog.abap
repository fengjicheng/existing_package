*&--------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*& Object          REPS ZTTYPV
*& Object Header   PROG ZTTYPV
*&--------------------------------------------------------------------*
*& REPORT ZTTYPV
*&--------------------------------------------------------------------*
*>>>> START OF INSERTION <<<<
*&---------------------------------------------------------------------*
*& Report  ZTTYPV
*&
*&---------------------------------------------------------------------*
*&
*& This report is part of note  36353
*&---------------------------------------------------------------------*
*
* This report inserts an entry in table TTYPV instead of using
* transaction OBCY;
* This report is also able to insert generic entries in table TTYPV
* that cannot be maintained with transaction OBCY;
* but if you run report ZTTYPS to insert generic entries in table TTYPS
* then you can maintain again these generic entries in TTYPV
* via transaction OBCY
*
************************************************************************
**


REPORT zttypv .

PARAMETERS: awtyp   LIKE ttypv-awtyp     DEFAULT 'MKPF',
            tabname LIKE ttypv-tabname   DEFAULT '*',
            fname   LIKE ttypv-fieldname DEFAULT '*'.



TABLES ttypv.
ttypv-awtyp   =   awtyp.
ttypv-tabname =   tabname.
ttypv-fieldname = fname.
INSERT ttypv.

WRITE:/ ' Entry inserted into table TTYPV: ',
      / ' Awtyp:     ', awtyp,
      / ' Tabname:   ', tabname,
      / ' Fieldname: ', fname.
