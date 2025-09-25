FUNCTION-POOL ZQTC_FG_BP_VALIDATIONS.           "MESSAGE-ID ..

* INCLUDE LZBP_FG_VALIDATIONSD...            " Local class definition

* Gocal Types
TYPES: BEGIN OF ty_constants,
         param1 TYPE rvari_vnam,          " Param1
         param2 TYPE rvari_vnam,          " Param2
         srno   TYPE tvarv_numb,          " Serial Number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_constants,
       tt_constants TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0.

DATA:
  i_constants  TYPE tt_constants.
