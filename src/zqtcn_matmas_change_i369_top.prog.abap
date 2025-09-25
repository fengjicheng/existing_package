*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MATMAS_CHANGE_I369_TOP
*&---------------------------------------------------------------------*
* Include Name       :  ZQTCN_MATMAS_CHANGE_I369_TOP
* PROGRAM DESCRIPTION:  Report to get the BDCP2 unprocessed            *
*                       Change Pointer details against the Message Type*
*                       and Submit program “RBDSEMAT” (Tcode BD10)with *
*                       materials and Update the process indicator = ‘X’
*                       using FM CHANGE_POINTERS_STATUS_WRITE
* DEVELOPER:            MIMMADISET                                     *
* CREATION DATE:        03/30/2021                                     *
* OBJECT ID:            I0369.1                                        *
* TRANSPORT NUMBER(S):  ED2K922771                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*====================================================================*
* G L O B A L   S T R U C T U R E S
*====================================================================*
TYPES : BEGIN OF ty_bdcp2,
          mestype TYPE  edi_mestyp,     " Message Type
          cpident TYPE  cpident,        " Change pointer ID
          process TYPE  ale_proces,     " ALE processing indicator
          tabname TYPE  tabname,        " Table Name
          tabkey  TYPE  cdtabkeylo,     " Table Key for CDPOS in Character 254
          fldname TYPE  fieldname,      " Field Name
          cretime TYPE  cpcretime,      " Creation time of a change pointer
          acttime TYPE  cpacttime,      " Activation time of a change pointer
          usrname TYPE  cdusername,     " User name of the person responsible in change document
          cdobjcl TYPE  cdobjectcl,     " Object class
          cdobjid TYPE  cdobjectv,      " Object value
          cdchgno TYPE  cdchangenr,     " Document change number
          cdchgid TYPE  cdchngind,      " Change Type (U, I, S, D)
        END OF ty_bdcp2,
        BEGIN OF ty_mara,
          matnr TYPE matnr,            " Material Number
          matkl TYPE matkl,            " Material type
        END OF   ty_mara,
        BEGIN OF ty_matnr,
          sign TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE matnr,              " Material Number
          high TYPE matnr,              " Material Number
        END OF ty_matnr,
*====================================================================*
*  G L O B A L   T A B L E   T Y P E S
*====================================================================*
        tt_bdcp2 TYPE STANDARD TABLE OF ty_bdcp2 INITIAL SIZE 0,
        tt_mara  TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
        tt_matnr TYPE STANDARD TABLE OF ty_matnr INITIAL SIZE 0.

*====================================================================*
*  G L O B A L   I N T E R N A L   T A B L E
*====================================================================*
DATA: i_bdcp2     TYPE tt_bdcp2,
      i_mara      TYPE tt_mara,
      i_constants TYPE zcat_constants,    "Constant Values
      i_selscreen TYPE TABLE OF rsparams WITH HEADER LINE. " ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
*====================================================================*
*  G L O B A L   V A R I A B L E S
*====================================================================*
DATA:gv_matnr TYPE matnr.
*====================================================================*
*  G L O B A L   C O N S T A N T V A R I B L E S
*====================================================================*
CONSTANTS:c_bt    TYPE char2 VALUE 'BT',
          c_i     TYPE char1 VALUE 'I',
          c_etime TYPE syuzeit VALUE '235959'.
