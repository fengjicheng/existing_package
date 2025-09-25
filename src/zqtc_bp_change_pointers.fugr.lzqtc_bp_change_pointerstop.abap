FUNCTION-POOL zqtc_bp_change_pointers. "MESSAGE-ID ..

* INCLUDE LZQTC_BP_CHANGE_POINTERSD...       " Local class definition

*====================================================================*
* G L O B A L   S T R U C T U R E S
*====================================================================*
TYPES : BEGIN OF ty_bdcp2,
          mandt   TYPE  mandt,         " Client
          mestype TYPE  edi_mestyp,    " Message Type
          cpident TYPE  cpident,       " Change pointer ID
          process TYPE  ale_proces,    " ALE processing indicator
          tabname TYPE  tabname,       " Table Name
          tabkey  TYPE  cdtabkeylo,    " Table Key for CDPOS in Character 254
          fldname TYPE  fieldname,     " Field Name
          cretime TYPE  cpcretime,     " Creation time of a change pointer
          acttime TYPE  cpacttime,     " Activation time of a change pointer
          usrname TYPE  cdusername,    " User name of the person responsible in change document
          cdobjcl TYPE  cdobjectcl,    " Object class
          cdobjid TYPE  cdobjectv,     " Object value
          cdchgno TYPE  cdchangenr,    " Document change number
          cdchgid TYPE  cdchngind,     " Change Type (U, I, S, D)
        END OF ty_bdcp2,

        BEGIN OF ty_bdcp2_adrnr,
          cdobjcl TYPE  cdobjectcl,    " Object class
          cdobjid TYPE  cdobjectv,     " Object value
          adrnr   TYPE  adrnr,         " Address
        END OF ty_bdcp2_adrnr,

        BEGIN OF ty_kna1,
          kunnr TYPE kunnr,            " Customer Number
          adrnr	TYPE adrnr,            " Address Number
        END OF   ty_kna1,

        BEGIN OF ty_but000,
          partner  TYPE  bu_partner,   " Business Partner Number
          addrcomm TYPE  bu_addrcomm,  " Address number
        END OF ty_but000,

        BEGIN OF ty_but020,
          partner    TYPE  bu_partner, " Business Partner Number
          addrnumber TYPE  ad_addrnum, " Address number
        END OF ty_but020,

        BEGIN OF ty_kunnr,
          sign TYPE tvarv_sign,        " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,        " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE kunnr,             " Customer Number
          high TYPE kunnr,             " Customer Number
        END OF ty_kunnr,

        BEGIN OF ty_class,
          sign TYPE tvarv_sign,        " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,        " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE klasse_d,          " Class number
          high TYPE klasse_d,          " Class number
        END OF ty_class,

*====================================================================*
*  G L O B A L   T A B L E   T Y P E S
*====================================================================*
        tt_bdcp2       TYPE STANDARD TABLE OF ty_bdcp2      WITH NON-UNIQUE SORTED KEY
                  mestype_key COMPONENTS mestype,
        tt_bdcp2_objcl TYPE STANDARD TABLE OF ty_bdcp2 WITH NON-UNIQUE SORTED KEY
                  cdobjcl_key COMPONENTS cdobjcl,
        tt_bdcp2_adrnr TYPE STANDARD TABLE OF ty_bdcp2_adrnr WITH NON-UNIQUE SORTED KEY
                   adrnr_key  COMPONENTS adrnr,
        tt_but000      TYPE STANDARD TABLE OF ty_but000      WITH NON-UNIQUE SORTED KEY
                  addrcomm_key COMPONENTS addrcomm,
        tt_but020      TYPE STANDARD TABLE OF ty_but020     WITH NON-UNIQUE SORTED KEY
                  addrnumber_key COMPONENTS addrnumber,
        tt_kna1        TYPE STANDARD TABLE OF ty_kna1       WITH NON-UNIQUE SORTED KEY
                   adrnr_key   COMPONENTS adrnr,
        tt_kunnr       TYPE STANDARD TABLE OF ty_kunnr      INITIAL SIZE 0,
        tt_class       TYPE STANDARD TABLE OF ty_class      INITIAL SIZE 0.
*====================================================================*
*  G L O B A L   I N T E R N A L   T A B L E
*====================================================================*
DATA: i_bdcp2       TYPE tt_bdcp2,
      i_kna1        TYPE tt_kna1,
      i_bdcp2_final TYPE zttqtc_bdcp2_details,
      i_but000      TYPE tt_but000,
      i_but020      TYPE tt_but020,
      i_selscreen   TYPE TABLE OF rsparams WITH HEADER LINE, " ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
*====================================================================*
*  G L O B A L   V A R I A B L E
*====================================================================*
      v_raise       TYPE char1. " Raise of type CHAR1

*====================================================================*
* G L O B A L  C O N S T A N T S
*====================================================================*
CONSTANTS: c_e    TYPE bapi_mtype VALUE 'E'. " Message type: S Success, E Error, W Warning, I Info, A Abort
