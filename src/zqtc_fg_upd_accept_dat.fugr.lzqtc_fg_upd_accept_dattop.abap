FUNCTION-POOL ZQTC_FG_UPD_ACCEPT_DAT.       "MESSAGE-ID ..

* INCLUDE LZQTC_FG_UPD_ACCEPT_DATD...        " Local class definition


DATA : v_log_handle TYPE balloghndl, " Application Log: Log Handle
       v_days       TYPE i,
       v_msgno      TYPE sy-msgno,
       v_exter      TYPE balhdr-extnumber.
CONSTANTS: c_object TYPE balobj_d    VALUE 'ZQTC',
           c_subobj TYPE balsubobj   VALUE 'ZUPD_ACCEPTANCE'.
