FUNCTION-POOL zqtc_tax_procedure. "MESSAGE-ID ..

* INCLUDE LZQTC_TAX_PROCEDURED...            " Local class definition
TYPES: BEGIN OF ty_caconst,
         devid  TYPE zdevid,             " Development ID
         param1 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
         low    TYPE salv_de_selopt_low, " LOW value
       END OF ty_caconst,

       tty_caconst TYPE STANDARD TABLE OF ty_caconst.
DATA:
  i_caconst    TYPE tty_caconst.

CONSTANTS:
  c_devid_e038 TYPE zdevid         VALUE 'E038',          "Development ID: E038
  c_tax_proc   TYPE rvari_vnam     VALUE 'TAX_PROCEDURE', "Name of Variant Variable: TAX_PROCEDURE
* Begin of ADD:INC0185390:WROY:18-Apr-2018:ED2K909720
  c_prog_name  TYPE rvari_vnam     VALUE 'PROGRAM_NAME',  "Name of Variant Variable: PROGRAM_NAME
  c_ar_sd_prc  TYPE rvari_vnam     VALUE 'AR_SD',         "Name of Variant Variable: AR_SD
* End   of ADD:INC0185390:WROY:18-Apr-2018:ED2K909720

  c_prg_inv_a  TYPE dbglprog       VALUE 'SAPLV60A',      "Program: SD-FI Interface
  c_prg_inv_b  TYPE dbglprog       VALUE 'SAPLV60B',      "Program: SD-FI Interface
  c_prg_acc_n  TYPE dbglprog       VALUE 'SAPLFDCB',      "Program: Subledger Accounting
  c_prg_acc_o  TYPE dbglprog       VALUE 'SAPMF05A',      "Program: Post Acc Document
  c_prg_gl_acc TYPE dbglprog       VALUE 'SAPLFSKB',      "Program: G/L Account Entry

  c_koart_cust TYPE koart          VALUE 'D'.             "Account Type: Customer
