interface ZIF_ZBAPI_BUPA_SEARCH_2
  public .


  types:
    AD_TELNRCL type C length 000030 .
  types:
    AD_SMTPADR type C length 000241 .
  types:
    AD_URI2 type C length 000050 .
  types:
    AD_COMCTRY type C length 000003 .
  types:
    begin of BAPIBUS1006_COMM,
      TELEPHONE type AD_TELNRCL,
      E_MAIL type AD_SMTPADR,
      URL type AD_URI2,
      COUNTRY_FOR_TELEPHONE type AD_COMCTRY,
    end of BAPIBUS1006_COMM .
  types:
    BU_PARTNER type C length 000010 .
  types:
    BU_ADDRESS_GUID_BAPI type C length 000032 .
  types:
    AD_ADRTYPE type C length 000001 .
  types:
    begin of ZBP_ADDR,
      PARTNER type BU_PARTNER,
      ADDRESSGUID type BU_ADDRESS_GUID_BAPI,
      ADDRESSTYPE type AD_ADRTYPE,
      COMPANY_PARTNER type BU_PARTNER,
      EMAIL type AD_SMTPADR,
    end of ZBP_ADDR .
  types:
    __ZBP_ADDR                     type standard table of ZBP_ADDR                       with non-unique default key .
  types:
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
  types:
    __BAPIRET2                     type standard table of BAPIRET2                       with non-unique default key .
endinterface.
