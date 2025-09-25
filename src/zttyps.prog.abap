*$*$----------------------------------------------------------------$*$*
*$ Correction Inst.         0020751258 0000022937                     $*
*$--------------------------------------------------------------------$*
*$ Valid for       :                                                  $*
*$ Software Component   SAP_FIN                                       $*
*$  Release 617          All Support Package Levels                   $*
*$  Release 618          All Support Package Levels                   $*
*$  Release 700          All Support Package Levels                   $*
*$  Release 720          All Support Package Levels                   $*
*$  Release 730          All Support Package Levels                   $*
*$--------------------------------------------------------------------$*
*$ Changes/Objects Not Contained in Standard SAP System               $*
*$*$----------------------------------------------------------------$*$*
*&--------------------------------------------------------------------*
*& Object          REPS ZTTYPS
*& Object Header   PROG ZTTYPS
*&--------------------------------------------------------------------*
*& REPORT ZTTYPS
*&--------------------------------------------------------------------*
*>>>> START OF INSERTION <<<<
*&---------------------------------------------------------------------*
*& Report  ZTTYPS
*&
*&---------------------------------------------------------------------*
*&
*& This report is part of note  36353
*&---------------------------------------------------------------------*
*
* This report inserts generic entries in table TTYPS so that afterwards
* these entries allow transaction OBCY to maintain these generic entries
* in table TTYPV;
* report ZTTYPV is then not necessary anymore for the direct insertion
*of
* generic entries in TTYPV
*
************************************************************************
**
*
REPORT zttyps.

TABLES ttyps.

*
ttyps-tabname =   '*'.
ttyps-fieldname = '*'.
INSERT ttyps.

*
ttyps-tabname =   'BSET'.
ttyps-fieldname = '*'.
INSERT ttyps.

*
WRITE: / ' Entries inserted into table TTYPS: ',
       / ' Tabname: *    , Fieldname: * ',
       / ' Tabname: BSET , Fieldname: * '.
