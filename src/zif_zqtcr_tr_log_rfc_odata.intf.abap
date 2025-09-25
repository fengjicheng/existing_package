interface ZIF_ZQTCR_TR_LOG_RFC_ODATA
  public .


  types:
    AS4TEXT type C length 000060 .
  types:
    TRKORR type C length 000020 .
  types:
    TR_AS4USER type C length 000012 .
  types:
    OAX type C length 000001 .
  types:
    TRVALUE type C length 000032 .
  types:
    PGMID type C length 000004 .
  types:
    TROBJTYPE type C length 000004 .
  types:
    TROBJ_NAME type C length 000120 .
  types:
    DDTEXT type C length 000060 .
  types:
    ICON_D type C length 000004 .
  types AS4TIME type T .
  types:
    ZDEPENDENCY_TR type C length 000020 .
  types:
    ZDEPENDENCY_CR type C length 000050 .
  types:
    ZCR_CHECK type C length 000001 .
  types:
    ZINCIDENT_CHECK type C length 000001 .
  types:
    ZINCIDENT_NO type C length 000050 .
  types:
    ZMESSAGE_TEXT type C length 001024 .
  types:
    ZRETROFIT_CHECK type C length 000001 .
  types:
    TRSTATUS type C length 000001 .
  types:
    begin of ZQTCR_TR_LOG_OPT_STR,
      TRKORR type TRKORR,
      TRTYPE type C length 000010,
      AS4TEXT type AS4TEXT,
      AS4USER type TR_AS4USER,
      PROJECT type TRVALUE,
      PGMID type PGMID,
      OBJECT type TROBJTYPE,
      OBJ_NAME type TROBJ_NAME,
      OBJ_TXT type DDTEXT,
      ED1 type ICON_D,
      ED1DATE type DATS,
      ED1TIME type AS4TIME,
      ED2 type ICON_D,
      ED2DATE type DATS,
      ED2TIME type AS4TIME,
      EQ1 type ICON_D,
      EQ1DATE type DATS,
      EQ1TIME type AS4TIME,
      EQ2 type ICON_D,
      EQ2DATE type DATS,
      EQ2TIME type AS4TIME,
      EP1 type C length 000004,
      EP1DATE type DATS,
      EP1TIME type T,
      EQ3 type C length 000004,
      EQ3DATE type DATS,
      EQ3TIME type T,
      ES1 type C length 000004,
      ES1DATE type DATS,
      ES1TIME type T,
      DEPENDENCY_TR type ZDEPENDENCY_TR,
      DEPENDENCY_CR type ZDEPENDENCY_CR,
      CR_CHECK type ZCR_CHECK,
      INCIDENT_CHECK type ZINCIDENT_CHECK,
      INCIDENT_NO type ZINCIDENT_NO,
      ZMESSAGE type ZMESSAGE_TEXT,
      RETROFIT_CHECK type ZRETROFIT_CHECK,
      TRSTATUS type TRSTATUS,
    end of ZQTCR_TR_LOG_OPT_STR .
  types:
    ZQTCR_TR_LOG_OPT_STR_TT        type standard table of ZQTCR_TR_LOG_OPT_STR           with non-unique default key .
  types:
    BALLOGHNDL type C length 000022 .
  types SWN_TIMEFROM type T .
  types:
    /IBMACCEL/UNAME type C length 000012 .
  types:
    ZOTHERS_CHK type C length 000001 .
  types:
    ZOTHERS_DES type C length 000050 .
  types:
    begin of ZCA_TR_LOG,
      ZREQUEST type TRKORR,
      ZMESSAGE type BALLOGHNDL,
      LOG_NUM type BALLOGHNDL,
      ZDATE type DATS,
      ZTIME type SWN_TIMEFROM,
      ZUNAME type /IBMACCEL/UNAME,
      DEPENDENCY_TR type ZDEPENDENCY_TR,
      DEPENDENCY_CR type ZDEPENDENCY_CR,
      CR_CHECK type ZCR_CHECK,
      INCIDENT_CHECK type ZINCIDENT_CHECK,
      INCIDENT_NO type ZINCIDENT_NO,
      RETROFIT_CHECK type ZRETROFIT_CHECK,
      OTHERS_CHK type ZOTHERS_CHK,
      OTHERS_DES type ZOTHERS_DES,
    end of ZCA_TR_LOG .
  types:
    __ZCA_TR_LOG                   type standard table of ZCA_TR_LOG                     with non-unique default key .
  types:
    begin of KO100,
      PGMID type PGMID,
      OBJECT type TROBJTYPE,
      TEXT type DDTEXT,
    end of KO100 .
  types:
    __KO100                        type standard table of KO100                          with non-unique default key .
  types:
    DDPOSITION type N length 000006 .
  types:
    OBJFUNC type C length 000001 .
  types:
    LOCKFLAG type C length 000001 .
  types:
    TRGENNUM type C length 000003 .
  types:
    SPRAS type C length 000001 .
  types:
    TRACTIVITY type C length 000020 .
  types:
    begin of E071,
      TRKORR type TRKORR,
      AS4POS type DDPOSITION,
      PGMID type PGMID,
      OBJECT type TROBJTYPE,
      OBJ_NAME type TROBJ_NAME,
      OBJFUNC type OBJFUNC,
      LOCKFLAG type LOCKFLAG,
      GENNUM type TRGENNUM,
      LANG type SPRAS,
      ACTIVITY type TRACTIVITY,
    end of E071 .
  types:
    __E071                         type standard table of E071                           with non-unique default key .
  types:
    CHAR1 type C length 000001 .
  types:
    CHAR2 type C length 000002 .
  types:
    begin of ZQTCR_TR_LOG_DES,
      SIGN type CHAR1,
      OPTION type CHAR2,
      LOW type AS4TEXT,
      HIGH type AS4TEXT,
    end of ZQTCR_TR_LOG_DES .
  types:
    __ZQTCR_TR_LOG_DES             type standard table of ZQTCR_TR_LOG_DES               with non-unique default key .
  types:
    TVARV_SIGN type C length 000001 .
  types:
    TVARV_OPTI type C length 000002 .
  types:
    RSDSSELOP_ type C length 000045 .
  types:
    begin of RSDSSELOPT,
      SIGN type TVARV_SIGN,
      OPTION type TVARV_OPTI,
      LOW type RSDSSELOP_,
      HIGH type RSDSSELOP_,
    end of RSDSSELOPT .
  types:
    __RSDSSELOPT                   type standard table of RSDSSELOPT                     with non-unique default key .
  types AS4DATE type DATS .
endinterface.
