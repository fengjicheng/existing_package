FUNCTION-POOL zqtc_repdet                MESSAGE-ID sv.

* INCLUDE LZQTC_REPDETD...                   " Local class definition
INCLUDE lsvimdat                                . "general data decl.
INCLUDE lzqtc_repdett00                         . "view rel. data dcl.

TYPES:
  BEGIN OF ty_kvgr1_rng,
    sign TYPE tvarv_sign,                    " ABAP: ID: I/E (include/exclude values)
    opti TYPE tvarv_opti,                    " ABAP: Selection option (EQ/BT/CP/...)
    low  TYPE kvgr1,                         " Lower Value of Cust Grp 1
    high TYPE kvgr1,                         " Upper Value of Cust Grp 1
  END OF ty_kvgr1_rng,
  tt_kvgr1_rng TYPE STANDARD TABLE OF ty_kvgr1_rng INITIAL SIZE 0.

CONSTANTS:
  c_sign_incld TYPE tvarv_sign VALUE 'I',    " Sign: (I)nclude
  c_option_eq  TYPE tvarv_opti VALUE 'EQ',   " Option: (EQ)uals
  c_option_cp  TYPE tvarv_opti VALUE 'CP',   " Option: (C)ontains (P)attern
  c_pattern    TYPE char1      VALUE '*'.    " Pattern Search
