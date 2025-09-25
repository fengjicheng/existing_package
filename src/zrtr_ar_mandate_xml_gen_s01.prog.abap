*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTR_AR_MANDATE_XML_GEN_I0377
* PROGRAM DESCRIPTION: This report used to generate the XML file
* into AL11 directory. (XML file contains SEPA_Mandate info)
* DEVELOPER:           Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE:       18/11/2019
* OBJECT ID:           I0377
* TRANSPORT NUMBER(S): ED2K916852
*----------------------------------------------------------------------*
* REVISION NO: ED2K917486 ---------------------------------------------*
* REFERENCE NO: I0377 - ERPM-12674
* DEVELOPER: Gopalakrishna Kammili (GKAMMILI)
* DATE: 06-February-2020
* DESCRIPTION: Debitor Name and street is filling from cuutomer master
* if they are initial
*----------------------------------------------------------------------*
* REVISION NO: ED1K912279 ---------------------------------------------*
* REFERENCE NO: INC0317050
* DEVELOPER: BTIRUVATHU
* DATE: 16-October-2020
* DESCRIPTION: Terminated in EP1/400 with SAP Remote status : Cancelled
* when there are no customers to send in XML format.
*----------------------------------------------------------------------*
* REVISION HISTORY:
* REVISION NO:  <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:         MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZRTR_AR_MANDATE_XML_GEN_S01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       Initialize the values in Selection Screen
*----------------------------------------------------------------------*
FORM f_initialization.

  " Build File Path of AL11 Directory
  CONCATENATE '/intf/tib/' sy-sysid '/I0377/in/' INTO p_fpath.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SEL_SCREEN
*&---------------------------------------------------------------------*
*       Selection Screen Modification
*----------------------------------------------------------------------*
FORM f_modify_sel_screen.

  LOOP AT SCREEN.

    IF p_full = abap_false AND screen-group1 = 'CDT'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SS_VALIDATIONS
*&---------------------------------------------------------------------*
*       Selection Screen Validations
*----------------------------------------------------------------------*
FORM f_ss_validations.

  IF p_full = abap_true AND sy-ucomm = 'ONLI'.
    IF p_cutdt IS INITIAL.
      MESSAGE 'Please select Cut off date'(009) TYPE c_mtyp_e.
    ENDIF.
  ENDIF.

  IF s_fcdate[] IS INITIAL AND s_fctime[] IS NOT INITIAL.
    MESSAGE 'Please enter File Creation date'(006) TYPE c_mtyp_e.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       Fetch the data
*----------------------------------------------------------------------*
FORM f_get_data.

  DATA: li_cstmrdrctdbtinitn TYPE zcstmrdrctdbtinitn_tt,
        lr_cutdt             TYPE RANGE OF sepa_erdat,
        lst_cutdt            LIKE LINE OF lr_cutdt.

  FIELD-SYMBOLS:
        <lfs_sepa_mandt> TYPE ty_sepa_mandt.

  IF i_constant[] IS INITIAL.
    SELECT devid, param1, param2, srno, sign, opti, low, high
           FROM zcaconstant INTO TABLE @i_constant
           WHERE devid = @c_devid_i0377 AND
                 activate = @abap_true.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.
  ENDIF.

  IF p_full = abap_true.  " Full Load

    lst_cutdt-sign = c_sign_i.
    lst_cutdt-option = c_opt_ge.
    lst_cutdt-low = p_cutdt.
    APPEND lst_cutdt TO lr_cutdt.
    CLEAR lst_cutdt.
    " Fetch data from SEPA_MANDATE (SEPA Mandate table)
    SELECT mndid, mvers, status, erdat, ertim, origin_rec_crdid, ori_erdat, ori_ertim
           FROM sepa_mandate INTO TABLE @i_sepa_mandt
           WHERE mndid IN @s_mndid AND
                 erdat IN @lr_cutdt AND
                 origin_rec_crdid IN @s_crdid AND
                 anwnd = @p_appid ORDER BY mndid.
    IF sy-subrc = 0.
      IF i_sepa_mandt[] IS INITIAL.
        MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
        RETURN.
      ENDIF.
    ELSEIF sy-subrc <> 0.
      IF i_sepa_mandt[] IS INITIAL.
        MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
        RETURN.
      ENDIF.
    ENDIF.

    DATA(li_sepa_mandt) = i_sepa_mandt[].
    DELETE li_sepa_mandt WHERE status <> 4 AND status <> 5 AND status <> 6. " Get the Canceled, Obsolete, and Completed Mandates
    DELETE i_sepa_mandt WHERE status <> 1.     " Get all the Active Mandates
    IF li_sepa_mandt[] IS NOT INITIAL.
      SORT i_sepa_mandt BY mndid origin_rec_crdid.
      LOOP AT li_sepa_mandt ASSIGNING <lfs_sepa_mandt>.
        READ TABLE i_sepa_mandt WITH KEY mndid = <lfs_sepa_mandt>-mndid origin_rec_crdid = <lfs_sepa_mandt>-origin_rec_crdid
                                BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          DELETE i_sepa_mandt INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
      FREE li_sepa_mandt.
    ENDIF.

    IF i_sepa_mandt[] IS INITIAL.
      MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
      RETURN.
    ENDIF.
    SORT i_sepa_mandt BY mndid origin_rec_crdid.
    DELETE ADJACENT DUPLICATES FROM i_sepa_mandt COMPARING mndid origin_rec_crdid.
    " Pull the Mandate table info into internal table: i_stg_mandt
    LOOP AT i_sepa_mandt ASSIGNING <lfs_sepa_mandt>.
      st_stg_mandt-mndid = <lfs_sepa_mandt>-mndid.
      st_stg_mandt-rec_crdid = <lfs_sepa_mandt>-origin_rec_crdid.
      st_stg_mandt-zzdate = <lfs_sepa_mandt>-erdat.
      st_stg_mandt-zztime = <lfs_sepa_mandt>-ertim.
      st_stg_mandt-status = <lfs_sepa_mandt>-status.
      APPEND st_stg_mandt TO i_stg_mandt.
      CLEAR st_stg_mandt.
    ENDLOOP.
    FREE i_sepa_mandt.
  ELSE. " Incremental Load
    " Fetch data from ZRTR_AR_MAND_STG (Staging table)
    IF s_fcdate IS INITIAL.
      SELECT mandt,
             mndid,
             zzdate_c,
             zzver,
             anwnd,
             rec_crdid,
             zzdate,
             zztime,
             status,
             zzmodif,
             zzdate_file,
             zztime_file,
             zzuname
             FROM zrtr_ar_mand_stg INTO TABLE @i_stg_mandt
             WHERE mndid IN @s_mndid AND
                   anwnd = @p_appid AND
                   rec_crdid IN @s_crdid AND
                   zzdate IN @s_credt AND
                   ( zzdate_file = @v_date OR zzdate_file IS NULL ) AND
                   ( zztime_file = @v_time OR zztime_file IS NULL ) AND
                   ( zzuname = @c_space OR zzuname IS NULL )
             ORDER BY mndid.
      IF sy-subrc = 0.
        IF i_stg_mandt[] IS INITIAL.
          MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
          RETURN.
        ENDIF.
      ELSEIF sy-subrc <> 0.
        IF i_stg_mandt[] IS INITIAL.
          MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
          RETURN.
        ENDIF.
      ENDIF.
    ELSE. " To regenerate XML incase of File deletion from AL11 directory
      SELECT mandt,
             mndid,
             zzdate_c,
             zzver,
             anwnd,
             rec_crdid,
             zzdate,
             zztime,
             status,
             zzmodif,
             zzdate_file,
             zztime_file,
             zzuname
             FROM zrtr_ar_mand_stg INTO TABLE @i_stg_mandt
             WHERE mndid IN @s_mndid AND
                   anwnd = @p_appid AND
                   rec_crdid IN @s_crdid AND
                   zzdate IN @s_credt AND
                   zzdate_file IN @s_fcdate AND
                   zztime_file IN @s_fctime
             ORDER BY mndid.
      IF sy-subrc = 0.
        IF i_stg_mandt[] IS INITIAL.
          MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
          RETURN.
        ENDIF.
      ELSEIF sy-subrc <> 0.
        IF i_stg_mandt[] IS INITIAL.
          MESSAGE 'No data found with the input criteria'(003) TYPE c_mtyp_i.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF. " IF p_full = abap_true.  " Full Load

  " Fill XML Structures
  PERFORM f_fill_xml_str CHANGING li_cstmrdrctdbtinitn.

  " Generate XML File and post it into AL11 directory
  PERFORM f_generate_xml USING li_cstmrdrctdbtinitn.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_XML_STR
*&---------------------------------------------------------------------*
*       Fill XML Structures
*----------------------------------------------------------------------*
FORM f_fill_xml_str CHANGING fp_li_cstmrdrctdbtinitn TYPE zcstmrdrctdbtinitn_tt.

  DATA:
    lst_cstmrdrctdbtinitn TYPE zcstmrdrctdbtinitn_st,    " Struc:
    lst_drctdbttxinf      TYPE zdrctdbttxinf_st,         " Struc:
    li_drctdbttxinf       TYPE zdrctdbttxinf_tt,         " Itab:
    lst_mandate_to_read   TYPE bapi_s_sepa_mandate_id,   " Struc:
    lst_mandate_read      TYPE bapi_s_sepa_mandate_data, " Struc:
    lv_busab              TYPE busab,                    " Accounting Clerk Abbreviation
    lv_kunnr              TYPE kunnr,                    " Customer
    lv_bukrs              TYPE bukrs,                    " Comapny Code
    lv_sname              TYPE sname_001s,               " Name of Accounting Clerk
    lv_uname              TYPE fi_usr_nam,               " Name of SAP Office User
    lv_dtbid              TYPE dtbid,                    " DME Bank Identification
    lv_dtkid              TYPE dtkid,                    " Customer ID at House Bank
    lv_hbkid              TYPE hbkid,                    " Short Key for a House Bank
    lv_banks              TYPE banks,                    " Bank Country Key
    lv_bankl              TYPE bankl,                    " Bank Keys
    lv_cbanks             TYPE banks,                    " Customer Bank Country Key
    lv_cbankl             TYPE bankl,                    " Customer Bank Keys
    lv_cbankn             TYPE bankn35,                  " Customer Bank account number
    lv_cbrnch             TYPE brnch,                    " Bank Branch
    lv_koinh              TYPE koinh_fi,                 " Account Holder Name
    lv_swift              TYPE swift,                    " SWIFT/BIC for International Payments
    lv_brnch              TYPE brnch,                    " Bank Branch
    lv_ort01              TYPE ort01,                    " City
    lv_waers              TYPE waers,                    " Currency Key
    lv_fyear              TYPE gjahr,                    " Fiscal Year
    lv_fprd               TYPE monat,                    " Fiscal Period
    lv_persnumber	        TYPE ad_persnum,               " Person number
    lv_addrnumber	        TYPE ad_addrnum,               " Address Number
    lv_smtp_addr          TYPE ad_smtpadr,               " E-Mail Address
    lst_bapireturn        TYPE bapireturn1,              " Struc: Return Parameter
    lv_modif              TYPE zmodif_flg,               " Modification flag
    lst_return            TYPE bapiret1,                 " Return Parameter
    lv_date_c             TYPE char10,                   " Date in Char format
    lv_time_c             TYPE char8,                    " Time in Char format
    lv_generate_xml       TYPE abap_bool VALUE abap_false, " Boolean flag
    lr_bukrs              TYPE RANGE OF bukrs,           " Ranges: Company Code & Payment method
    lv_account_id         TYPE hktid,                    " Account Id
    lst_bukrs             LIKE LINE OF lr_bukrs,         " Struc: lr_bukrs
    lv_result             TYPE n,                        " Result
*--BOC: ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
    lv_adrnr              TYPE kna1-adrnr,               "Address number
    lv_name               TYPE adrc-name1,                "name
    lv_street_adrc        TYPE adrc-street.              "street
*--EOC: ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486

  " Get the constant values
  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN c_grphdr_p1.
        CASE <lfs_constant>-param2.
          WHEN c_ctrlsum_p2.
            DATA(lv_ghdr_ctrlsum) = <lfs_constant>-low.
          WHEN c_schmenm_cd_p2.
            DATA(lv_schmenm_cd) = <lfs_constant>-low.
        ENDCASE.

      WHEN c_pmtinf_p1.
        CASE <lfs_constant>-param2.
          WHEN c_pmtmtd_p2.
            DATA(lv_pmtmtd) = <lfs_constant>-low.
          WHEN c_ctrlsum_p2.
            DATA(lv_pinf_ctrlsum) = <lfs_constant>-low.
          WHEN c_othr_id_p2.
            DATA(lv_othr_id) = <lfs_constant>-low.
          WHEN c_schmenm_prtry_p2.
            DATA(lv_schmenm_prtry) = <lfs_constant>-low.
        ENDCASE.

      WHEN c_drctdbttxinf_p1.
        CASE <lfs_constant>-param2.
          WHEN c_pmttpinf_instrprty_p2.
            DATA(lv_pmttpinf_instrprty) = <lfs_constant>-low.
          WHEN c_svclvl_cd_p2.
            DATA(lv_svclvl_cd) = <lfs_constant>-low.
          WHEN c_cd_uk0n_p2.
            DATA(lv_cd_uk0n) = <lfs_constant>-low.
          WHEN c_cd_uk0s_p2.
            DATA(lv_cd_uk0s) = <lfs_constant>-low.
          WHEN c_cd_uk0c_p2.
            DATA(lv_cd_uk0c) = <lfs_constant>-low.
          WHEN c_instdamt_p2.
            DATA(lv_instdamt) = <lfs_constant>-low.
          WHEN c_chrgbr_p2.
            DATA(lv_chrgbr) = <lfs_constant>-low.
          WHEN c_amdmntind_p2.
            DATA(lv_amdmntind) = <lfs_constant>-low.
          WHEN OTHERS.
            " Nothing to do
        ENDCASE.

      WHEN c_payment_p1.
        lst_bukrs-sign = <lfs_constant>-sign.
        lst_bukrs-option = <lfs_constant>-opti.
        lst_bukrs-low = <lfs_constant>-param2.
        lst_bukrs-high = <lfs_constant>-low.
        APPEND lst_bukrs TO lr_bukrs.
        CLEAR lst_bukrs.

      WHEN c_fn_pattern_p1.
        v_fn_pattern = <lfs_constant>-low.

      WHEN c_account_id_p1.
        lv_account_id = <lfs_constant>-low.

      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.

* Get the <MsgId>
  PERFORM f_get_number CHANGING lv_result.
  lst_cstmrdrctdbtinitn-grphdr-msgid = lv_result.              " <GrpHdr>/<MsgId>

* Get the <PmtInfId>
  PERFORM f_get_number CHANGING lv_result.
  lst_cstmrdrctdbtinitn-pmtinf-pmtinfid = lv_result.           " <PmtInf>/<PmtInfId>
  lst_cstmrdrctdbtinitn-pmtinf-pmtmtd = lv_pmtmtd.             " <PmtInf>/<PmtMtd>  Const Val: 'DD'

*  DESCRIBE TABLE i_stg_mandt LINES DATA(lv_lines).
*  lst_cstmrdrctdbtinitn-grphdr-nboftxs = lv_lines.             " <GrpHdr>/<NbOfTxs>
*  CONDENSE lst_cstmrdrctdbtinitn-grphdr-nboftxs NO-GAPS.
*  lst_cstmrdrctdbtinitn-pmtinf-nboftxs = lv_lines.             " <PmtInf>/<NbOfTxs>
*  CONDENSE lst_cstmrdrctdbtinitn-pmtinf-nboftxs NO-GAPS.

  lst_cstmrdrctdbtinitn-grphdr-ctrlsum = lv_ghdr_ctrlsum.      " <GrpHdr>/<CtrlSum>  Const Val: '0.00'
  lst_cstmrdrctdbtinitn-pmtinf-ctrlsum = lv_pinf_ctrlsum.      " <PmtInf>/<CtrlSum>  Const Val: '0.00'.

  LOOP AT i_stg_mandt ASSIGNING FIELD-SYMBOL(<lfs_mandt>).

    " FM call to fetch the Mandate information
    lst_mandate_to_read-application = p_appid.
    lst_mandate_to_read-sepa_creditor_id = <lfs_mandt>-rec_crdid.
    lst_mandate_to_read-sepa_mandate_id = <lfs_mandt>-mndid.

    CALL FUNCTION 'BAPI_SEPA_MANDATE_READ'
      EXPORTING
        is_mandate_to_read = lst_mandate_to_read
*       I_READ_FOR_CHANGE  = ' '
      IMPORTING
        es_mandate_read    = lst_mandate_read
        es_return          = lst_return.

    IF sy-tabix = 1.
*** BOC: Filling Structure 'Group Header' (<GrpHdr>...</GrpHdr>)
      lv_date_c = lst_mandate_read-creationdate.  " <lfs_mandt>-zzdate.
      lv_time_c = lst_mandate_read-creationtime.  " <lfs_mandt>-zztime.

      CONCATENATE lv_date_c(4) c_iphen lv_date_c+4(2) c_iphen lv_date_c+6(2) INTO lv_date_c.
      CONCATENATE lv_time_c(2) c_collan lv_time_c+2(2) c_collan lv_time_c+4(2) INTO lv_time_c.
      CONCATENATE lv_date_c c_t lv_time_c INTO lst_cstmrdrctdbtinitn-grphdr-credttm.   " <GrpHdr>/<CreDtTm>

      lv_kunnr = lst_mandate_read-snd_id.
      lv_bukrs = lst_mandate_read-rec_id.

      " Fetch DME Bank Identification (<GrpHdr>/<InitgPty>/<Id>/<OrdId>/<Othr>/<Id>)
      SELECT SINGLE hbkid FROM t042a INTO lv_hbkid
             WHERE zbukr = lv_bukrs AND
                   zlsch = c_paym AND
                   rangf = c_rankord.
      IF sy-subrc = 0.
        SELECT SINGLE dtbid dtkid FROM t012d INTO ( lv_dtbid, lv_dtkid )
               WHERE bukrs = lv_bukrs AND
                     hbkid = lv_hbkid.
        IF sy-subrc = 0.
          IF lv_dtbid IS NOT INITIAL.
            lst_cstmrdrctdbtinitn-grphdr-initgpty-othr-id = lv_dtbid.                  " <GrpHdr>/<InitgPty>/<Id>/<OrdId>/<Othr>/<Id>
          ENDIF.
          IF lv_dtkid IS NOT INITIAL.
            lst_cstmrdrctdbtinitn-pmtinf-cdtracct-tp-prtry = lv_dtkid.                 " <PmtInf>/<CdtrAcct>/<Tp>/<Prtry>
          ENDIF.
        ENDIF. " IF sy-subrc = 0.
      ENDIF. " IF sy-subrc = 0.

      " Fetch the City (<PmtInf>/<Cdtr>/<PstlAdr>/<TwnNm> )
      SELECT SINGLE ort01 waers FROM t001 INTO ( lv_ort01, lv_waers )
             WHERE bukrs = lv_bukrs.
      IF sy-subrc = 0.
        IF lv_ort01 IS NOT INITIAL.
          lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-twnnm = lv_ort01.                  " <PmtInf>/<Cdtr>/<PstlAdr>/<TwnNm>
        ENDIF.
      ENDIF.

      lst_cstmrdrctdbtinitn-grphdr-initgpty-nm = lst_mandate_read-rec_name1.           " <GrpHdr>/<InitgPty>/<Nm>
      PERFORM f_convert USING abap_true
                        CHANGING lst_cstmrdrctdbtinitn-grphdr-initgpty-nm.

      lst_cstmrdrctdbtinitn-grphdr-initgpty-othr-schmenm-cd = lv_schmenm_cd.  " 'BANK' " <GrpHdr>/<InitgPty>/<Id>/<OrdId>/<Othr>/<SchmeNm>/<Cd>
*** EOC: Filling Structure 'Group Header' (<GrpHdr>...</GrpHdr>)

*** BOC: Filling Structure 'PmtInf' (<PmtInf>...</PmtInf>)
      lst_cstmrdrctdbtinitn-pmtinf-reqdcolltndt = lv_date_c.                           " <PmtInf>/<ReqdColltnDt>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-nm = lst_mandate_read-rec_name1.               " <PmtInf>/<Cdtr>/<Nm>
      PERFORM f_convert USING abap_false
                        CHANGING lst_cstmrdrctdbtinitn-pmtinf-cdtr-nm.
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-strtnm = lst_mandate_read-rec_street.  " <PmtInf>/<Cdtr>/<PstlAdr>/<StrtNm>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-pstcd = lst_mandate_read-rec_postal.   " <PmtInf>/<Cdtr>/<PstlAdr>/<PstCd>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-ctry = lst_mandate_read-rec_country.   " <PmtInf>/<Cdtr>/<PstlAdr>/<Ctry>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-adrline1 = lst_mandate_read-rec_street." <PmtInf>/<Cdtr>/<PstlAdr>/<AdrLine>
      CONCATENATE lst_mandate_read-rec_postal lv_ort01 INTO DATA(lv_street) SEPARATED BY space.
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-pstladr-adrline2 = lv_street.                  " <PmtInf>/<Cdtr>/<PstlAdr>/<AdrLine>

      lst_cstmrdrctdbtinitn-pmtinf-cdtr-othr-id = lv_othr_id.    " '1234567'           " <PmtInf>/<Cdtr>/<Othr>/<Id>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-othr-schmenm-prtry = lv_schmenm_prtry. " 'WILEY'  " <PmtInf>/<Cdtr>/<Othr>/<SchmeNm>/<Prtry>
      lst_cstmrdrctdbtinitn-pmtinf-cdtr-ctryofres = lst_mandate_read-rec_country.      " <PmtInf>/<Cdtr>/<CtryOfRes>

      " Fetch 'Accounting Clerk Abbreviation(BUSAB)' from KNB1
      SELECT SINGLE busab FROM knb1 INTO lv_busab
             WHERE kunnr = lv_kunnr AND
                   bukrs = lv_bukrs.
      IF sy-subrc = 0.
        SELECT SINGLE sname usnam FROM t001s INTO ( lv_sname, lv_uname )
               WHERE bukrs = lv_bukrs AND
                     busab = lv_busab.
        IF sy-subrc = 0.
          IF lv_sname IS NOT INITIAL.
            lst_cstmrdrctdbtinitn-pmtinf-cdtr-ctctdtls-nm = lv_sname.                  " <PmtInf>/<Cdtr>/<CtctDtls>/<Nm>
          ENDIF.
          SELECT SINGLE persnumber addrnumber FROM usr21 INTO ( lv_persnumber, lv_addrnumber )
                 WHERE bname = lv_uname.
          IF sy-subrc = 0.
            SELECT SINGLE smtp_addr FROM adr6 INTO lv_smtp_addr
                   WHERE addrnumber = lv_addrnumber AND persnumber = lv_persnumber.
            IF sy-subrc = 0.
              IF lv_smtp_addr IS NOT INITIAL.
                lst_cstmrdrctdbtinitn-pmtinf-cdtr-ctctdtls-emailadr = lv_smtp_addr.     " <PmtInf>/<Cdtr>/<CtctDtls>/<EmailAdr>
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      lst_cstmrdrctdbtinitn-pmtinf-cdtracct-ccy = lv_waers.                             " <PmtInf>/<CdtrAcct>/<Ccy>

      IF lv_hbkid IS NOT INITIAL AND lv_bukrs IS NOT INITIAL.
        " Fetch 'Bank Country Key(BANKS), Bank Keys(BANKL)' from T012
        SELECT SINGLE banks bankl FROM t012 INTO ( lv_banks, lv_bankl )
               WHERE bukrs = lv_bukrs AND
                     hbkid = lv_hbkid.     " Short Key for a House Bank(HBKID)
        IF sy-subrc = 0.
          " Fetch 'Bank account number(BANKN)' from T012K
          SELECT SINGLE bankn FROM t012k INTO @DATA(lv_bankn)
                 WHERE bukrs = @lv_bukrs AND
                       hbkid = @lv_hbkid AND
                       hktid = @lv_account_id.
          IF sy-subrc = 0 AND lv_bankn IS NOT INITIAL.
            " Fetch IBAN from TIBAN
            SELECT SINGLE iban FROM tiban INTO @DATA(lv_iban)
                   WHERE banks = @lv_banks AND
                         bankl = @lv_bankl AND
                         bankn = @lv_bankn.
            IF sy-subrc = 0 AND lv_iban IS NOT INITIAL.
              lst_cstmrdrctdbtinitn-pmtinf-cdtracct-id-iban = lv_iban.                   " <PmtInf>/<CdtrAcct>/<Id>/<IBAN>
            ENDIF.
          ENDIF.
          IF lv_banks IS NOT INITIAL.
            lst_cstmrdrctdbtinitn-pmtinf-cdtragt-fininstnid-pstladr-ctry = lv_banks.     " <PmtInf>/<CdtrAgt>/<FinInstnId>/<PstlAdr>/<Ctry>
          ENDIF.
          SELECT SINGLE swift brnch FROM bnka INTO ( lv_swift, lv_brnch )
                 WHERE banks = lv_banks AND
                       bankl = lv_bankl.
          IF sy-subrc = 0.
            IF lv_swift IS NOT INITIAL.
              lst_cstmrdrctdbtinitn-pmtinf-cdtragt-fininstnid-bic = lv_swift.            " <PmtInf>/<CdtrAgt>/<FinInstnId>/<BIC>
            ENDIF.
            IF lv_brnch IS NOT INITIAL.
              lst_cstmrdrctdbtinitn-pmtinf-cdtragt-brnchid-id = lv_brnch.                " <PmtInf>/<CdtrAgt>/<BrnchId>/<Id>
            ENDIF.
          ENDIF. " IF sy-subrc = 0.
        ENDIF. " IF sy-subrc = 0.
      ENDIF. " IF lv_hbkid IS NOT INITIAL AND lv_bukrs IS NOT INITIAL.
*** EOC: Filling Structure 'PmtInf' (<PmtInf>...</PmtInf>)
    ENDIF.  " IF sy-tabix = 1.

*** BOC: Filling Structure '<DrctDbtTxInf>' (<DrctDbtTxInf>...</DrctDbtTxInf>)
    lv_bukrs = lst_mandate_read-rec_id.
    lv_kunnr = lst_mandate_read-snd_id.

    IF line_exists( lr_bukrs[ low = lv_bukrs ] ).
      " Fetch the Customer Payment Method from KNB1
      SELECT SINGLE zwels FROM knb1 INTO @DATA(lv_zwels)
                    WHERE kunnr = @lv_kunnr AND
                          bukrs = @lv_bukrs.
      IF sy-subrc = 0 AND lv_zwels IS NOT INITIAL.
        LOOP AT lr_bukrs INTO lst_bukrs WHERE low = lv_bukrs.
          IF lst_bukrs-high IS NOT INITIAL.
            FIND lst_bukrs-high IN lv_zwels.
            IF sy-subrc = 0.
              lv_generate_xml = abap_true.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF lv_generate_xml = abap_true.
        " FM call to get the Fiscal Year
        CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
          EXPORTING
            companycodeid = lv_bukrs
            posting_date  = lst_mandate_read-creationdate
          IMPORTING
            fiscal_year   = lv_fyear
            fiscal_period = lv_fprd
            return        = lst_bapireturn.
        IF sy-subrc = 0.
          CONCATENATE c_01 c_iphen lst_mandate_read-rec_id lst_mandate_read-snd_id lv_fyear
                      INTO lst_drctdbttxinf-pmtid-instrid.                                " <PmtInf>/<DrctDbtTxInf>/<PmtId>/<InstrId>
        ENDIF.

        lst_drctdbttxinf-pmtid-endtoendid = lst_mandate_read-snd_id.                      " <PmtInf>/<DrctDbtTxInf>/<PmtId>/<EndToEndId>
        lst_drctdbttxinf-pmttpinf-instrprty = lv_pmttpinf_instrprty. " 'NORM'             " <PmtInf>/<DrctDbtTxInf>/<PmtTpInf>/<InstrPrty>
        lst_drctdbttxinf-pmttpinf-svclvl-cd = lv_svclvl_cd. " 'NURG'                      " <PmtInf>/<DrctDbtTxInf>/<PmtTpInf>/<SvcLvl>/<Cd>

        IF p_full = abap_false.
          IF <lfs_mandt>-zzmodif = c_modid_c.
            lst_drctdbttxinf-pmttpinf-lclinstrm-cd = lv_cd_uk0n. " 'UK0N'                 " <PmtInf>/<DrctDbtTxInf>/<PmtTpInf>/<LclInstrm>/<Cd>
          ELSEIF <lfs_mandt>-zzmodif = c_modid_u.
            lst_drctdbttxinf-pmttpinf-lclinstrm-cd = lv_cd_uk0s. " 'UK0S'
          ELSEIF <lfs_mandt>-zzmodif = c_modid_d.
            lst_drctdbttxinf-pmttpinf-lclinstrm-cd = lv_cd_uk0c. " 'UK0C'
          ENDIF.
        ELSEIF p_full = abap_true.
          lst_drctdbttxinf-pmttpinf-lclinstrm-cd = lv_cd_uk0n.   " 'UK0N'
        ENDIF.

        lst_drctdbttxinf-instdamt = lv_instdamt.  " '0.00'                                " <PmtInf>/<DrctDbtTxInf>/<InstdAmt>
        lst_drctdbttxinf-chrgbr = lv_chrgbr.      " 'SHAR'                                " <PmtInf>/<DrctDbtTxInf>/<ChrgBr>

        lst_drctdbttxinf-drctdbttx-mndtrltdinf-mndtid = lst_mandate_read-sepa_mandate_id. " <PmtInf>/<DrctDbtTxInf>/<DrctDbtTx>/<MndtRltdInf>/<MndtId>
        lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr = lst_mandate_read-sign_date.    " <PmtInf>/<DrctDbtTxInf>/<DrctDbtTx>/<MndtRltdInf>/<DtOfSgntr>
        IF lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr IS NOT INITIAL.
          CONCATENATE lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr(4) c_iphen lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr+4(2)
                      c_iphen lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr+6(2) INTO lst_drctdbttxinf-drctdbttx-mndtrltdinf-dtofsgntr.
        ENDIF.
        lst_drctdbttxinf-drctdbttx-mndtrltdinf-amdmntind = lv_amdmntind. " 'false'        " <PmtInf>/<DrctDbtTxInf>/<DrctDbtTx>/<MndtRltdInf>/<AmdmntInd>

        lst_drctdbttxinf-dbtragt-fininstnid-bic = lst_mandate_read-snd_bic.               " <PmtInf>/<DrctDbtTxInf>/<DbtrAgt>/<FinInstnId>/<BIC>
        lst_drctdbttxinf-dbtragt-fininstnid-pstladr-ctry = lst_mandate_read-snd_country.  " <PmtInf>/<DrctDbtTxInf>/<DbtrAgt>/<FinInstnId>/<PstlAdr>/<Ctry>

        " Fetching the Customer Bank Country Key, Bank Key, Bank Account Number
        " based on Customer IBAN
        SELECT SINGLE banks, bankl, bankn FROM tiban INTO ( @lv_cbanks, @lv_cbankl, @lv_cbankn )
               WHERE iban = @lst_mandate_read-snd_iban.
        IF sy-subrc = 0.
          " Fetching Customer Bank Branch
          SELECT SINGLE brnch FROM bnka INTO lv_cbrnch
                 WHERE banks = lv_cbanks AND
                       bankl = lv_cbankl.
          IF sy-subrc = 0.
            IF lv_cbrnch IS NOT INITIAL.
              lst_drctdbttxinf-dbtragt-brnchid-id = lv_cbrnch.                            " <PmtInf>/<DrctDbtTxInf>/<DbtrAgt>/<BrnchId>/<Id>
            ENDIF.
          ENDIF.
*-- BOC:ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
        "Getting customer address number
         SELECT SINGLE adrnr FROM kna1 INTO lv_adrnr
                WHERE kunnr = lv_kunnr.
         IF sy-subrc = 0.
         "Getting customer Name and street
           SELECT SINGLE name1 street FROM adrc INTO ( lv_name, lv_street_adrc )
                  WHERE addrnumber = lv_adrnr.
         ENDIF.
*-- EOC:ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
          " Fetching 'Account Holder Name'
          SELECT SINGLE koinh FROM knbk INTO lv_koinh
                 WHERE kunnr = lv_kunnr AND
                       banks = lv_cbanks AND
                       bankl = lv_cbankl AND
                       bankn = lv_cbankn.
          IF sy-subrc = 0.
            IF lv_koinh IS INITIAL.
*-- BOC: ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
*              lv_koinh = lst_mandate_read-snd_name1.  " commented FOR ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
              lv_koinh = lv_name.
              CLEAR lv_name.
*-- EOC: ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
            ENDIF.
            PERFORM f_convert USING abap_false
                              CHANGING lv_koinh.
            lst_drctdbttxinf-dbtr-nm = lv_koinh.                                          " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<Nm>
          ENDIF.
        ENDIF.  " IF sy-subrc = 0.
*-- BOC: ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
        IF lst_mandate_read-snd_street IS INITIAL.
          lst_mandate_read-snd_street = lv_street_adrc.
          CLEAR lv_street_adrc.
        ENDIF.
*-- EOC:ERPM-12674  GKAMMILI 06-Feb-20202  ED2K917486
        lst_drctdbttxinf-dbtr-pstladr-strtnm = lst_mandate_read-snd_street.               " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<StrtNm>
        lst_drctdbttxinf-dbtr-pstladr-pstcd = lst_mandate_read-snd_postal.                " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<PstCd>
        lst_drctdbttxinf-dbtr-pstladr-twnnm = lst_mandate_read-snd_city.                  " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<TwnNm>
        lst_drctdbttxinf-dbtr-pstladr-ctry = lst_mandate_read-snd_country.                " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<Ctry>
        lst_drctdbttxinf-dbtr-pstladr-adrline1 = lst_mandate_read-snd_street.             " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<AdrLine>
        CONCATENATE lst_mandate_read-snd_postal lst_mandate_read-snd_city INTO
                    lst_drctdbttxinf-dbtr-pstladr-adrline2 SEPARATED BY space.            " <PmtInf>/<DrctDbtTxInf>/<Dbtr>/<PstlAdr>/<AdrLine>

        lst_drctdbttxinf-dbtracct-id-iban = lst_mandate_read-snd_iban.                    " <PmtInf>/<DrctDbtTxInf>/<DbtrAcct>/<Id>/<IBAN>
        lst_drctdbttxinf-dbtracct-nm = lv_koinh.                                          " <PmtInf>/<DrctDbtTxInf>/<DbtrAcct>/<Nm>

        lst_drctdbttxinf-rmtinf-ustrd = lst_mandate_read-snd_id.                          " <PmtInf>/<DrctDbtTxInf>/<RmtInf>/<Ustrd>
        APPEND lst_drctdbttxinf TO li_drctdbttxinf.

      ENDIF. " IF lv_generate_xml = abap_true.
    ENDIF. " IF line_exists( r_bukrs[ low = lv_bukrs ] ).
*** EOC: Filling Structure '<DrctDbtTxInf>' (<DrctDbtTxInf>...</DrctDbtTxInf>)
    CLEAR: lst_mandate_to_read,
           lst_mandate_read,
           lst_return,
           lst_drctdbttxinf,
           lst_bapireturn.
    CLEAR: lv_bukrs,
           lv_kunnr,
           lv_dtkid,
           lv_dtbid,
           lv_cbanks,
           lv_cbankl,
           lv_cbankn,
           lv_cbrnch,
           lv_koinh.
    CLEAR: lv_persnumber,
           lv_addrnumber,
           lv_smtp_addr,
           lv_zwels,
           lv_generate_xml.
  ENDLOOP.

  IF li_drctdbttxinf[] IS INITIAL.
* BOC - BTIRUVATHU - INC0317050- 2020/10/16 - ED1K912279
*    MESSAGE 'No Customer(s) found to generate the XML'(010) TYPE c_mtyp_e.
    MESSAGE 'No Customer(s) found to generate the XML'(010) TYPE c_mtyp_i.
* EOC - BTIRUVATHU - INC0317050- 2020/10/16 - ED1K912279
  ELSE.
    DESCRIBE TABLE li_drctdbttxinf LINES DATA(lv_customers).
    IF lv_customers > 1.
      " If we have multiple Customers, clear the Accounting clerk details (Name, Email Addr)
      CLEAR: lst_cstmrdrctdbtinitn-pmtinf-cdtr-ctctdtls-nm,
             lst_cstmrdrctdbtinitn-pmtinf-cdtr-ctctdtls-emailadr.
    ENDIF.
    lst_cstmrdrctdbtinitn-grphdr-nboftxs = lv_customers.             " <GrpHdr>/<NbOfTxs>
    CONDENSE lst_cstmrdrctdbtinitn-grphdr-nboftxs NO-GAPS.
    lst_cstmrdrctdbtinitn-pmtinf-nboftxs = lv_customers.             " <PmtInf>/<NbOfTxs>
    CONDENSE lst_cstmrdrctdbtinitn-pmtinf-nboftxs NO-GAPS.

    lst_cstmrdrctdbtinitn-pmtinf-drctdbttxinf = li_drctdbttxinf.
    APPEND lst_cstmrdrctdbtinitn TO fp_li_cstmrdrctdbtinitn.
    CLEAR: lst_cstmrdrctdbtinitn,
           li_drctdbttxinf[].
    FREE i_constant.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT
*&---------------------------------------------------------------------*
FORM f_convert USING fp_lv_upper TYPE abap_bool
               CHANGING fp_lv_value.

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_const>) WHERE param1 = c_special_char_p1.
    REPLACE ALL OCCURRENCES OF <lfs_const>-low IN fp_lv_value WITH ''.
  ENDLOOP.
  CONDENSE fp_lv_value.

  IF fp_lv_upper = abap_true.
    TRANSLATE fp_lv_value TO UPPER CASE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GENERATE_XML
*&---------------------------------------------------------------------*
FORM f_generate_xml USING fp_li_cstmrdrctdbtinitn TYPE zcstmrdrctdbtinitn_tt.

  DATA:
    lv_xml_string  TYPE string,
    lv_xml_xstring TYPE xstring,
    lv_file        TYPE string,
    lv_msg         TYPE string,
*    lo_xml        TYPE REF TO cl_xml_document,
    lo_conv        TYPE REF TO cl_abap_conv_in_ce,
    lo_st_error    TYPE REF TO cx_st_error.

  " XSLT call to generate the XML String
  TRY.
      CALL TRANSFORMATION zrtr_xslt_sepa_mandate_i0377
           SOURCE cstmrdrctdbtinitn = fp_li_cstmrdrctdbtinitn[]
           RESULT XML lv_xml_xstring.  " XML string in xstring format
      IF sy-subrc = 0.
        " Logic to convert the xstring into XML string with encoding format 'UTF-8'
        CALL METHOD cl_abap_conv_in_ce=>create
          EXPORTING
            input = lv_xml_xstring     " Xstring variable with XML
          RECEIVING
            conv  = lo_conv.

        CALL METHOD lo_conv->read
          IMPORTING
            data = lv_xml_string.      " String variable with XML Encoding UTF-8

        " Adding required attributes to <Document> tab
        REPLACE '<Document>'(007) IN lv_xml_string WITH p_dtag.
        IF p_disp = abap_true.
*      CREATE OBJECT lo_xml.
*      CALL METHOD lo_xml->parse_string
*        EXPORTING
*          stream = lv_xml_string.   " lv_xml_string is the variable which is holding the xml string
*      CALL METHOD lo_xml->display.
          cl_abap_browser=>show_xml( xml_string   = lv_xml_string
                                     context_menu = abap_true ).
        ELSE.
          GET TIME.
          IF sy-subrc <> 0.
            " Nothing to do
          ENDIF.
          CONCATENATE: v_fn_pattern sy-datum sy-uzeit INTO lv_file SEPARATED BY c_uscore,
                       lv_file '.xml'(008) INTO lv_file,
                       p_fpath lv_file INTO lv_file.
          "Post the XML File into AL11 directory
          OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE lv_msg.
          IF sy-subrc <> 0.
            MESSAGE lv_msg TYPE c_mtyp_e.
          ELSE.
            TRANSFER lv_xml_string TO lv_file.
            CLOSE DATASET lv_file.
            IF p_full = abap_false.
              PERFORM f_update_stg_mandt CHANGING i_stg_mandt.
              FREE i_stg_mandt.
            ENDIF.
            MESSAGE 'File Uploaded Successfully'(005) TYPE c_mtyp_s.
          ENDIF.
        ENDIF.
      ENDIF.

    CATCH cx_st_error INTO lo_st_error.
      lv_msg = lo_st_error->get_text( ).
      MESSAGE lv_msg TYPE c_mtyp_e.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_STG_MANDT
*&---------------------------------------------------------------------*
*       Update the staging table
*----------------------------------------------------------------------*
FORM f_update_stg_mandt CHANGING fp_li_stg_mandt TYPE tt_stg_mandt.

  " Get the System latest time
  GET TIME.
  IF sy-subrc <> 0.
    " Nothing to do
  ENDIF.
  " Updating Log Info
  LOOP AT fp_li_stg_mandt ASSIGNING FIELD-SYMBOL(<lfs_stg_mandt>).
    <lfs_stg_mandt>-zzdate_file = sy-datum.
    <lfs_stg_mandt>-zztime_file = sy-uzeit.
    <lfs_stg_mandt>-zzuname = sy-uname.
  ENDLOOP.
  " Update Staging table with Log Info
  MODIFY zrtr_ar_mand_stg FROM TABLE fp_li_stg_mandt.
  IF sy-subrc = 0.
    COMMIT WORK.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_get_number
*&---------------------------------------------------------------------*
*       Generate number
*----------------------------------------------------------------------*
FORM f_get_number CHANGING fp_lv_num TYPE n.

  DATA: lv_first_number TYPE n.

  CALL FUNCTION 'GET_NEXT_NUMBERS'
    EXPORTING
      i_object       = 'FPMFIL'
      i_key1         = space
      i_key2         = space
    IMPORTING
      e_first_number = lv_first_number
    EXCEPTIONS
      foreign_lock   = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
             RAISING foreign_lock.

  ELSEIF lv_first_number EQ 1.
    CALL FUNCTION 'GET_NEXT_NUMBERS'
      EXPORTING
        i_object       = 'FPMFIL'
        i_key1         = space
        i_key2         = space
        i_count_number = 10000000
      IMPORTING
        e_last_number  = lv_first_number
      EXCEPTIONS
        foreign_lock   = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
             RAISING foreign_lock.
    ENDIF.

    CALL FUNCTION 'COMPUTE_CONTROL_NUMBER'
      EXPORTING
        i_refno  = lv_first_number
      IMPORTING
        e_result = fp_lv_num.
    IF sy-subrc <> 0.
      " Nothing to do
    ENDIF.

  ELSEIF lv_first_number > 1.
    CALL FUNCTION 'COMPUTE_CONTROL_NUMBER'
      EXPORTING
        i_refno  = lv_first_number
      IMPORTING
        e_result = fp_lv_num.
    IF sy-subrc <> 0.
      " Nothing to do
    ENDIF.

  ELSEIF lv_first_number = 0.
    CALL FUNCTION 'GET_NEXT_NUMBERS'
      EXPORTING
        i_object      = 'FPMFIL'
        i_key1        = space
        i_key2        = space
      IMPORTING
        e_last_number = lv_first_number
      EXCEPTIONS
        foreign_lock  = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
             RAISING foreign_lock.
    ENDIF.

    CALL FUNCTION 'COMPUTE_CONTROL_NUMBER'
      EXPORTING
        i_refno  = lv_first_number
      IMPORTING
        e_result = fp_lv_num.
    IF sy-subrc <> 0.
      " Nothing to do
    ENDIF.
  ENDIF.

ENDFORM.
