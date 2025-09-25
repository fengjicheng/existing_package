FUNCTION-POOL ZQTC_RENEWAL_FEATURES.                  "MESSAGE-ID ..
*************************************************************************
* Types delaration
*************************************************************************
types: t_vbap type vbap,

*Constant table
       BEGIN OF ty_constant,
          devid  TYPE zdevid,              " Development ID
          param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,          " ABAP: Current selection number
          sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
        END OF ty_constant.

*************************************************************************
* Table type for VBAP
*************************************************************************
types t_vbap_tab type standard table of t_vbap.

*       Batchinputdata of single transaction
  DATA:   bdcdata TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE. " Batch input: New table field structure
*       messages of call transaction
  DATA:   messtab TYPE STANDARD TABLE OF bdcmsgcoll WITH HEADER LINE. " Collecting messages in the SAP System

*************************************************************************
* Global constant declaration
*************************************************************************
  CONSTANTS:  c_devid  TYPE zdevid VALUE 'E157'.    " Development ID

*************************************************************************
* Internal table declaration
*************************************************************************
  DATA: i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.
