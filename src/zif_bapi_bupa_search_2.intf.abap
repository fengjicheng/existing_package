interface ZIF_BAPI_BUPA_SEARCH_2
  public .


  types:
    AD_MC_CITY type C length 000025 .
  types:
    AD_PSTCD1 type C length 000010 .
  types:
    LAND1 type C length 000003 .
  types:
    INTCA type C length 000002 .
  types:
    REGIO type C length 000003 .
  types:
    AD_MC_STRT type C length 000025 .
  types:
    AD_HSNM1 type C length 000010 .
  types:
    AD_CITY2 type C length 000040 .
  types:
    AD_MC_COUNTY type C length 000025 .
  types:
    AD_MC_TWSHP type C length 000025 .
  types:
    AD_HSNM2 type C length 000010 .
  types:
    AD_BLDNG type C length 000020 .
  types:
    AD_FLOOR type C length 000010 .
  types:
    AD_ROOMNUM type C length 000010 .
  types:
    begin of BAPIBUS1006_ADDR_SEARCH,
      CITY1 type AD_MC_CITY,
      POSTL_COD1 type AD_PSTCD1,
      COUNTRY type LAND1,
      COUNTRYISO type INTCA,
      REGION type REGIO,
      STREET type AD_MC_STRT,
      HOUSE_NO type AD_HSNM1,
      CITY2 type AD_CITY2,
      COUNTY type AD_MC_COUNTY,
      TOWNSHIP type AD_MC_TWSHP,
      HOUSE_NO2 type AD_HSNM2,
      BUILDING type AD_BLDNG,
      FLOOR type AD_FLOOR,
      ROOM_NO type AD_ROOMNUM,
    end of BAPIBUS1006_ADDR_SEARCH .
  types:
    BOOLE_D type C length 000001 .
  types:
    begin of BAPIBUS1006_X,
      MARK type BOOLE_D,
    end of BAPIBUS1006_X .
  types:
    BU_PARTNERROLE type C length 000006 .
  types:
    BU_DFVAL type C length 000020 .
  types:
    BU_PARTNERROLECAT type C length 000006 .
  types:
    begin of BAPIBUS1006_BPROLES,
      PARTNERROLE type BU_PARTNERROLE,
      DIFFTYPEVALUE type BU_DFVAL,
      PARTNERROLECATEGORY type BU_PARTNERROLECAT,
      VALID_FROM type DATS,
      VALID_TO type DATS,
    end of BAPIBUS1006_BPROLES .
  types:
    BU_PARTNER type C length 000010 .
  types:
    BU_MCNAME1 type C length 000035 .
  types:
    BU_MCNAME2 type C length 000035 .
  types:
    BU_SORT1 type C length 000020 .
  types:
    BU_SORT2 type C length 000020 .
  types:
    BU_TYPE type C length 000001 .
  types:
    begin of BAPIBUS1006_CENTRAL_SEARCH,
      PARTNER type BU_PARTNER,
      MC_NAME1 type BU_MCNAME1,
      MC_NAME2 type BU_MCNAME2,
      SEARCHTERM1 type BU_SORT1,
      SEARCHTERM2 type BU_SORT2,
      PARTNERCATEGORY type BU_TYPE,
    end of BAPIBUS1006_CENTRAL_SEARCH .
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
    AD_FXNRLNG type C length 000030 .
  types:
    begin of BAPIBUS1006_FAX_DATA,
      COUNTRY_FOR_FAX type AD_COMCTRY,
      FAX_NO type AD_FXNRLNG,
    end of BAPIBUS1006_FAX_DATA .
  types:
    BU_REQS_MASK type C length 000001 .
  types:
    begin of BAPIBUS1006_MASK,
      IV_REQ_MASK type BU_REQS_MASK,
    end of BAPIBUS1006_MASK .
  types:
    BAPIBUS1006_ALL_VERSIONS type C length 000001 .
  types:
    BU_NO_CONTP_SEARCH type C length 000001 .
  types:
    begin of BAPIBUS1006_OTHER_DATA,
      MAXSEL type INT4,
      ALL_VERSIONS type BAPIBUS1006_ALL_VERSIONS,
      NO_SEARCH_FOR_CONTACTPERSON type BU_NO_CONTP_SEARCH,
    end of BAPIBUS1006_OTHER_DATA .
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
  types:
    BU_ADDRESS_GUID_BAPI type C length 000032 .
  types:
    AD_ADRTYPE type C length 000001 .
  types:
    begin of BAPIBUS1006_BP_ADDR,
      PARTNER type BU_PARTNER,
      ADDRESSGUID type BU_ADDRESS_GUID_BAPI,
      ADDRESSTYPE type AD_ADRTYPE,
      COMPANY_PARTNER type BU_PARTNER,
    end of BAPIBUS1006_BP_ADDR .
  types:
    __BAPIBUS1006_BP_ADDR          type standard table of BAPIBUS1006_BP_ADDR            with non-unique default key .
  types BAPI_BUPA_VALID_DATE type DATS .
endinterface.
