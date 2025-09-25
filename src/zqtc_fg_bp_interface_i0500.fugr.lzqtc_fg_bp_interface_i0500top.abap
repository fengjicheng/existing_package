FUNCTION-POOL zqtc_fg_bp_interface_i0500.   "MESSAGE-ID ..

* INCLUDE LZQTC_FG_BP_INTERFACE_I0500D...    " Local class definition
TYPES: BEGIN OF ty_constant,
         devid        TYPE zdevid,              " Development ID
         param1       TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2       TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno         TYPE tvarv_numb,          " ABAP: Current selection number
         sign         TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti         TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         legacy_value TYPE zlegacy_value,       " Legacy Value
         sap_value    TYPE zsap_value,          " SAP Value
         activate     TYPE zconstactive,        " Activation indicator for constant
       END OF ty_constant,
       tt_constant TYPE STANDARD TABLE OF ty_constant,
       BEGIN OF ty_create,
         gen_data       TYPE c,
         comp_data      TYPE c,
         sales_data     TYPE c,
         relation       TYPE c,
         assign_bp      TYPE c,
         close_previous TYPE c,
         credit         TYPE c,
         collection     TYPE c,
       END OF ty_create,
       BEGIN OF lty_rltyp,
         legacy_value TYPE bu_partnerrole,
         sap_value    TYPE bu_partnerrole,
       END OF lty_rltyp,
       BEGIN OF lty_const_val,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         spart TYPE spart,
       END OF lty_const_val.
*====================================================================*
*  Global Internal table & Structures
*====================================================================*
DATA: i_input      TYPE ztqtc_customer_date_inputs,
      i_constant   TYPE tt_constant,
      i_bp_input   TYPE ztqtc_customer_date_inputs,
      i_bp_return  TYPE ztqtc_customer_date_outputs,
      st_bp_input  TYPE zstqtc_customer_date_input,
      st_create    TYPE ty_create,
      li_role      TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-role-roles,
      lst_role     LIKE LINE OF li_role,
      lsr_rel_type TYPE lty_rltyp,
      lsr_zca_val  TYPE lty_const_val,
      lir_rel_type TYPE STANDARD TABLE OF lty_rltyp.
*====================================================================*
*  Global Variables
*====================================================================*
DATA:gv_support_mode TYPE  char1,
     gv_error        TYPE  char1,
     gv_cat_flag     TYPE  bu_type,            " Business partner category 1 or 2
     gv_bp           TYPE  bu_partner,         " Business Partner Number
     gv_source       TYPE  tpm_source_name,
     gv_guid         TYPE  idoccarkey,
     gv_zca_valid    TYPE  zsap_value,
     gv_zca_katr6    TYPE  katr6,
     gv_zca_bukrs    TYPE  bukrs,
     gv_return_msg   TYPE  bapiretc,
     gv_country      TYPE  land1,
     gv_message      TYPE  char200,
     gv_log_handle   TYPE  balloghndl,         " Application Log: Log Handle
     gv_id_cat       TYPE  bu_id_type,         " ID type
     gv_tf_prefix    TYPE  char3.              " Telephone/Fax Prefix

CONSTANTS:c_person      TYPE bu_type            VALUE '1',      " BP: Person
          c_zecid       TYPE but0id-type        VALUE 'ZECID',  " BP: Org
          c_org         TYPE bu_type            VALUE '2',      " BP: Organization
          c_u           TYPE bus_ei_object_task VALUE 'U',      " External Interface: Change Indicator Object
          c_m           TYPE bus_ei_object_task VALUE 'M',      " nExternal Interface: Change Indicator Object
          c_s           TYPE bus_ei_object_task VALUE 'S',      " External Interface: Change Indicator Object
          c_bp          TYPE char2              VALUE 'BP',     " Business Parttner
          c_i           TYPE bus_ei_object_task VALUE 'I',      " External Interface: Change
          c_commtyp_int TYPE ad_comm            VALUE 'INT',
          c_commtyp_let TYPE ad_comm            VALUE 'LET',
          c_bp_group    TYPE bu_group           VALUE '0001',     "Business Partner Grouping
          c_msgid_zrtr  TYPE symsgid            VALUE 'ZRTR_R1B', "Message Class - ZRTR_R1B
          c_msgno_000   TYPE symsgno            VALUE '000',      "Message Number - 000
          c_msgty_err   TYPE symsgty            VALUE 'E',        "Message Type - (E)rror
          c_bal_obj     TYPE balobj_d           VALUE 'ZQTC',     "Application Log: Object Name
          c_bal_sub     TYPE balsubobj          VALUE 'ZBP_CUST', "Application Log: Subobject
          c_expiry      TYPE rvari_vnam         VALUE 'EXPIRY_DATE',
          c_appl        TYPE expiry_date        VALUE 'APPL_LOG',
          c_input_data  TYPE char10             VALUE '1INPUT_DATA',
          c_gen_data    TYPE char10             VALUE '2GEN_DATA'.
