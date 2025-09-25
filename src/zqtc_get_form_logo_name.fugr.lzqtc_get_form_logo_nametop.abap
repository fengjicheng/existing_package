FUNCTION-POOL zqtc_get_form_logo_name. "MESSAGE-ID ..

* INCLUDE LZQTC_GET_FORM_LOGO_NAMED...       " Local class definition

* Type Declaration
TYPES: tt_parvw_r  TYPE RANGE OF parvw,     " Partner Function
       tt_reltyp_r TYPE RANGE OF bu_reltyp, " Business Partner Relationship Category
       tt_mvgr5_r  TYPE RANGE OF mvgr5,     " Material group 5
       tt_kunnr_r  TYPE RANGE OF kunnr.     " Customer Number

* Constant Declaration
CONSTANTS : c_i       TYPE tvarv_sign VALUE 'I',   " I of type CHAR1
            c_eq      TYPE tvarv_opti VALUE 'EQ',  " Eq of type CHAR2
            c_order   TYPE char10 VALUE 'ORDER',   " Order of type CHAR10
            c_invoice TYPE char10 VALUE 'INVOICE'. " Invoice of type CHAR10
