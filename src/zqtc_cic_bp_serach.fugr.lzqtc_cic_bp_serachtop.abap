FUNCTION-POOL zqtc_cic_bp_serach. "MESSAGE-ID ..

*Global type declaration
TYPES: BEGIN OF ty_search,
         partner  TYPE bu_partner,   " Business Partner Number
         idnumber TYPE bu_id_number, " Identification Number
         idtype   TYPE bu_id_type,   " Identification type
         taxnum   TYPE bptaxnum,     " Business Partner Tax Number
         ihrez    TYPE ihrez,        " Your Reference
       END OF ty_search.

*Global variable declaration
DATA: v_bp_search     TYPE ty_search,
      v_partner_error TYPE xfeld. " Checkbox

*Constant declaration
CONSTANTS: c_devid TYPE zdevid VALUE 'E157', " Development ID
           c_type  TYPE rvari_vnam VALUE 'BU_ID_TYPE'.

*User command variable
DATA v_user_command TYPE sy-ucomm. " ABAP System Field: PAI-Triggering Function Code
* INCLUDE LZQTC_CIC_BP_SERACHD...            " Local class definition
