*&---------------------------------------------------------------------*
*&  Include           ZQTCR_CLEAR_DIR_R115_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_constant.

TYPES: BEGIN OF ty_errfile,
         file TYPE string,
       END OF ty_errfile.

TYPES: BEGIN OF ty_alv.
TYPES:  sel TYPE c.
        INCLUDE TYPE eps2fili.
        TYPES: END OF ty_alv.

CONSTANTS: c_devid   TYPE zdevid   VALUE 'R115',
           c_errtype TYPE char1   VALUE 'E'. "Error messege

DATA : i_constant      TYPE STANDARD TABLE OF ty_constant, " Constant entries
       i_errfile       TYPE TABLE OF ty_errfile,           " Files with delete errors
       i_files         TYPE TABLE OF eps2fili,           " File List in Directory
       i_fieldcat      TYPE STANDARD TABLE OF slis_fieldcat_alv, " Field Catalog
       i_alv_output    TYPE STANDARD TABLE OF ty_alv,  " ALV table
       v_sender        TYPE soextreci1-receiver,       " email sender address
       v_receiver      TYPE soextreci1-receiver,       " email receiver address
       v_recname       TYPE bapibname-bapibname,           " email receiver address
       v_cleared_count TYPE char4 VALUE 0,           " Deleted file count
       w_fieldcat      TYPE slis_fieldcat_alv,
       w_layout        TYPE slis_layout_alv,
       st_variant      TYPE disvariant, " Layout
       gv_fname        TYPE eps2fili-name.
