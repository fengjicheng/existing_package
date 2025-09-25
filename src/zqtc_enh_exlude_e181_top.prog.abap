*-------------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_ENH_EXLUDE_E181_TOP
* PROGRAM DESCRIPTION: Restrict any Enhancement active logic if processing
*                      user id is maintained in ZCACONSTANT table against
*                      E181 Enhancement
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   2018-08-09
* OBJECT ID: E181
* TRANSPORT NUMBER(S):  ED2K912980
*------------------------------------------------------------------------*
TYPES : BEGIN OF tyy_constant,
          param1 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,   "Current selection number
          sign   TYPE tvarv_sign,   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low, "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, "Upper Value of Selection Condition
        END OF tyy_constant.
DATA: li_const_values_e181 TYPE TABLE OF tyy_constant,
      st_const_values      TYPE tyy_constant,
      lv_actv_flag_e181    TYPE zactive_flag.             "Active / Inactive flag "ADD:E181:SGUDA:10-SEP-2018:ED2K912979

CONSTANTS:
     lc_wricef_id_e181     TYPE zdevid VALUE 'E181',      "Constant value for WRICEF (E181)
     lc_ser_num_e181_1     TYPE zsno   VALUE '001'.       "Serial Number (001)
