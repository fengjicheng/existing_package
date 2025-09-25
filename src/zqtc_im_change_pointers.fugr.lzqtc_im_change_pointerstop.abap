FUNCTION-POOL zqtc_im_change_pointers. "MESSAGE-ID ..

* INCLUDE LZQTC_BP_CHANGE_POINTERSD...       " Local class definition

*====================================================================*
* G L O B A L   S T R U C T U R E S
*====================================================================*
TYPES : BEGIN OF ty_bdcp2,
          mandt   TYPE  mandt,          " Client
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

        BEGIN OF ty_bdcp2_matnr,
          cdobjcl TYPE  cdobjectcl,     " Object class
          cdobjid TYPE  cdobjectv,      " Object value
          matnr   TYPE  matnr,          " Address
        END OF ty_bdcp2_matnr,

        BEGIN OF ty_mara,
          matnr       TYPE matnr,       " Customer Number
          ismpubldate	TYPE ismpubldate, " Address Number
        END OF   ty_mara,

        BEGIN OF ty_but000,
          partner  TYPE  bu_partner,    " Business Partner Number
          addrcomm TYPE  bu_addrcomm,   " Address number
        END OF ty_but000,

        BEGIN OF ty_but020,
          partner    TYPE  bu_partner,  " Business Partner Number
          addrnumber TYPE  ad_addrnum,  " Address number
        END OF ty_but020,

        BEGIN OF ty_matnr,
          sign TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE matnr,              " Customer Number
          high TYPE matnr,              " Customer Number
        END OF ty_matnr,

        BEGIN OF ty_class,
          sign TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE klasse_d,           " Class number
          high TYPE klasse_d,           " Class number
        END OF ty_class,

*====================================================================*
*  G L O B A L   T A B L E   T Y P E S
*====================================================================*
        tt_bdcp2       TYPE STANDARD TABLE OF ty_bdcp2       WITH NON-UNIQUE SORTED KEY
                  mestype_key COMPONENTS mestype,
        tt_bdcp2_objcl TYPE STANDARD TABLE OF ty_bdcp2       WITH NON-UNIQUE SORTED KEY
                  cdobjcl_key COMPONENTS cdobjcl,
        tt_bdcp2_matnr TYPE STANDARD TABLE OF ty_bdcp2_matnr WITH NON-UNIQUE SORTED KEY
                   matnr_key  COMPONENTS matnr,
        tt_but000      TYPE STANDARD TABLE OF ty_but000      WITH NON-UNIQUE SORTED KEY
                  addrcomm_key COMPONENTS addrcomm,
        tt_but020      TYPE STANDARD TABLE OF ty_but020      WITH NON-UNIQUE SORTED KEY
                  addrnumber_key COMPONENTS addrnumber,
        tt_mara        TYPE STANDARD TABLE OF ty_mara        WITH NON-UNIQUE SORTED KEY
                   matnr_key   COMPONENTS matnr,
        tt_matnr       TYPE STANDARD TABLE OF ty_matnr      INITIAL SIZE 0,
        tt_class       TYPE STANDARD TABLE OF ty_class      INITIAL SIZE 0.
*====================================================================*
*  G L O B A L   I N T E R N A L   T A B L E
*====================================================================*
DATA: i_bdcp2       TYPE tt_bdcp2,
      i_mara        TYPE tt_mara,
      i_bdcp2_final TYPE zttqtc_bdcp2_details_im,
      i_but000      TYPE tt_but000,
      i_but020      TYPE tt_but020,
      i_selscreen   TYPE TABLE OF rsparams WITH HEADER LINE, " ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
      i_rep_data    TYPE REF TO data,                        "  class
*====================================================================*
*  G L O B A L   V A R I A B L E
*====================================================================*
      v_raise       TYPE char1. " Raise of type CHAR1
*====================================================================*
* F I E L D  S Y M B O L S
*====================================================================*
FIELD-SYMBOLS  : <i_rep_data>  TYPE ANY TABLE,
                 <st_rep_data> TYPE any. "LIKE LINE OF  it_tab .
*====================================================================*
* G L O B A L  C O N S T A N T S
*====================================================================*
CONSTANTS: c_e    TYPE bapi_mtype VALUE 'E'. " Message type: S Success, E Error, W Warning, I Info, A Abort
