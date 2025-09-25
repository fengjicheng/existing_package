FUNCTION zqtc_upd_acceptance_date_i0369 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_DATE) TYPE  VADAT_VEDA
*"     VALUE(I_RGCODE) TYPE  ZRGCODE
*"     VALUE(I_IDNUMBER) TYPE  ZQTC_EXT_ID_NO
*"     VALUE(I_TIBCO_ID) TYPE  CHAR50 OPTIONAL
*"  EXPORTING
*"     VALUE(EX_MSG_TYPE) TYPE  BAPI_MTYPE
*"     VALUE(EX_MSG_ID) TYPE  SYMSGNO
*"     VALUE(EX_MSG) TYPE  BAPI_MSG
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:           ZQTC_UPD_ACCEPTANCE_DATE
* PROGRAM DESCRIPTION:    Updating the acceptance date in the order
* DEVELOPER:              GKAMMILI
* CREATION DATE:          09-03-2021
* OBJECT ID:              I0369
* TRANSPORT NUMBER(S):    ED2K922266
*----------------------------------------------------------------------*
  TYPES:BEGIN OF lty_vbap,
          vbeln    TYPE vbap-vbeln,
          posnr    TYPE vbap-posnr,
          zzrgcode TYPE vbap-zzrgcode,
        END OF lty_vbap,
        BEGIN OF lty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
        END OF lty_vbpa,
        BEGIN OF lty_veda,
          vbeln   TYPE veda-vbeln,
          vposn   TYPE veda-vposn,
          vabndat TYPE veda-vabndat,
        END OF lty_veda,
        BEGIN OF lty_zqtc_ext_ident,
          partner      TYPE zqtc_ext_ident-partner,
          type         TYPE zqtc_ext_ident-type,
          idnumber     TYPE zqtc_ext_ident-idnumber,
          ext_idnumber TYPE zqtc_ext_ident-ext_idnumber,
        END OF lty_zqtc_ext_ident.
  DATA:li_vbap               TYPE TABLE OF lty_vbap,
       lst_vbap              TYPE lty_vbap,
       li_vbpa               TYPE TABLE OF lty_vbpa,
       lst_vbpa              TYPE lty_vbpa,
       li_veda               TYPE TABLE OF lty_veda,
       lst_veda              TYPE lty_veda,
       li_idnum              TYPE TABLE OF lty_zqtc_ext_ident,
       li_return             TYPE TABLE OF bapiret2,
       li_sales_contract_in  TYPE STANDARD TABLE OF bapictr,
       lr_sales_contract_in  TYPE  REF TO bapictr,
       li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx,
       lr_sales_contract_inx TYPE REF TO  bapictrx,
       lst_header_inx        TYPE bapisdhd1x,
       li_item_in            TYPE STANDARD TABLE OF bapisditm,
       lst_item_in           TYPE  bapisditm,
       lst_item_inx          TYPE  bapisditmx,
       li_item_inx           TYPE STANDARD TABLE OF bapisditmx,
       lst_bapiret           TYPE bapiret2,
       lr_parvw              TYPE TABLE OF prvw_range,
       lst_parvw             TYPE prvw_range,
       lr_exter              TYPE TABLE OF emma_extnumber_range,
       lst_exter             TYPE emma_extnumber_range,
       lr_msgno              TYPE TABLE OF ssc_s_rg_msgno,
       lst_msgno             TYPE ssc_s_rg_msgno,
       lr_vbeln              TYPE TABLE OF sdsls_vbeln_range,
       lst_vbeln             TYPE sdsls_vbeln_range.
  DATA:lv_fval(200)          TYPE c.
  CONSTANTS:lc_e      TYPE char1 VALUE 'E',
            lc_s      TYPE char1 VALUE 'S',
            lc_i      TYPE char1 VALUE 'I',
            lc_u      TYPE char1 VALUE 'U',
            lc_param1 TYPE rvari_vnam VALUE 'PARVW',
            lc_alert  TYPE rvari_vnam VALUE 'ALERT',
            lc_msgno  TYPE rvari_vnam VALUE 'MSGNO',
            lc_devid  TYPE zdevid VALUE 'I0369',
            lc_type   TYPE char5 VALUE 'ZSFCI',
            lc_slash  TYPE char1 VALUE '/',
            lc_cama   TYPE char1 VALUE ','.
*--Create Applocation log
  CONCATENATE i_tibco_id i_rgcode i_idnumber INTO v_exter
                                             SEPARATED BY lc_slash.
  PERFORM f_create_log.

  lv_fval = text-001.
* update application log
  PERFORM f_log_maintain  USING lv_fval lc_i.
*-- Updating the application log with inputs
  CONCATENATE text-017 i_tibco_id INTO lv_fval.
  PERFORM f_log_maintain  USING lv_fval lc_i.
  CLEAR lv_fval.

  CONCATENATE text-002 i_rgcode INTO lv_fval.
  PERFORM f_log_maintain  USING lv_fval lc_i.
  CLEAR lv_fval.

  CONCATENATE text-003 i_date INTO lv_fval.
  PERFORM f_log_maintain  USING lv_fval lc_i.
  CLEAR lv_fval.

  CONCATENATE text-004 i_idnumber INTO lv_fval.
  PERFORM f_log_maintain  USING lv_fval lc_i.
  CLEAR lv_fval.
*-- Getting the constant table entries
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low,
         high
         FROM zcaconstant
         INTO TABLE @DATA(li_const)
         WHERE devid    = @lc_devid
         AND   activate = @abap_true.
  IF sy-subrc = 0.
    LOOP AT li_const INTO DATA(lst_const).
      CASE lst_const-param1.
        WHEN lc_param1.
          lst_parvw-sign      = lst_const-sign.
          lst_parvw-option    = lst_const-opti.
          lst_parvw-parvw_low = lst_const-low.
          APPEND lst_parvw TO lr_parvw.
          CLEAR lst_parvw.
        WHEN lc_msgno.
          lst_msgno-sign      = lst_const-sign.
          lst_msgno-option    = lst_const-opti.
          lst_msgno-low       = lst_const-low.
          APPEND lst_msgno TO lr_msgno.
          CLEAR lst_msgno.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.

*--Getting the order details based on registration code
  SELECT vbeln,
         posnr,
         zzrgcode FROM vbap
                  INTO TABLE @li_vbap
                  WHERE zzrgcode = @i_rgcode.
  IF sy-subrc = 0.
    SELECT vbeln,
           vposn,
           vabndat FROM veda
                   INTO TABLE @li_veda
                   FOR ALL ENTRIES IN @li_vbap
                   WHERE vbeln = @li_vbap-vbeln
                   AND   vposn = @li_vbap-posnr
                   AND   vabndat = '00000000'.
    IF sy-subrc = 0.
      SELECT vbeln
             FROM vbak
             INTO TABLE @DATA(li_vbak)
             FOR ALL ENTRIES IN @li_veda
             WHERE vbeln = @li_veda-vbeln.
      IF sy-subrc = 0.
        LOOP AT li_vbak INTO DATA(lst_vbak).
          lst_vbeln-sign = 'I'.
          lst_vbeln-option = 'EQ'.
          lst_vbeln-low    = lst_vbak-vbeln.
          APPEND lst_vbeln TO lr_vbeln.
          CLEAR lst_vbeln.
        ENDLOOP.
        DELETE li_vbap WHERE vbeln NOT IN lr_vbeln.
      ENDIF.
    ENDIF.
  ENDIF.
  IF li_vbap[] IS NOT INITIAL.
*--Getting ship to party parter details for order
    SELECT vbeln,
           posnr,
           parvw,
           kunnr FROM vbpa
                 INTO TABLE @li_vbpa
                 FOR ALL ENTRIES IN @li_vbap
                 WHERE vbeln = @li_vbap-vbeln
                 AND   posnr = @space
                 AND   parvw IN @lr_parvw.
    IF sy-subrc = 0.
      SELECT partner,
             type,
             idnumber,
             ext_idnumber
             FROM zqtc_ext_ident
             INTO TABLE @li_idnum
             FOR ALL ENTRIES IN @li_vbpa
             WHERE partner = @li_vbpa-kunnr
             AND   type    = @lc_type
             AND   ext_idnumber = @i_idnumber.
      IF sy-subrc NE 0.
        MESSAGE e000(zqtc_r2) WITH text-005 INTO lst_bapiret-message.
        ex_msg_type = lc_e.
        ex_msg_id   = text-012.
        ex_msg      = lst_bapiret-message.
        lv_fval     = lst_bapiret-message.
        v_msgno     = ex_msg_id.
        PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        CLEAR:v_msgno, lv_fval.
        REFRESH li_vbap.
      ENDIF.
    ELSE.
      MESSAGE e000(zqtc_r2) WITH text-006 INTO lst_bapiret-message.
      ex_msg_type = lc_e.
      ex_msg_id   = text-011.
      ex_msg      = lst_bapiret-message.
      lv_fval     = lst_bapiret-message.
      v_msgno     = ex_msg_id.
      PERFORM f_log_maintain  USING lv_fval ex_msg_type.
      CLEAR:v_msgno, lv_fval.
      REFRESH li_vbap.
    ENDIF.
  ELSE.
    MESSAGE e000(zqtc_r2) WITH text-007 INTO lst_bapiret-message.
    ex_msg_type = lc_e.
    ex_msg_id   = text-010.
    ex_msg      = lst_bapiret-message.
    lv_fval     = lst_bapiret-message.
    v_msgno     = ex_msg_id.
    PERFORM f_log_maintain  USING lv_fval ex_msg_type.
    CLEAR:v_msgno, lv_fval.
    REFRESH li_vbap.
  ENDIF.
  SORT: li_vbap BY vbeln posnr,
        li_veda BY vbeln vposn,
        li_vbpa BY vbeln posnr,
        li_idnum BY partner type ext_idnumber.

  DESCRIBE TABLE li_vbak LINES DATA(lv_lines).
  IF lv_lines GT 1.
    MESSAGE e000(zqtc_r2) WITH text-020 i_rgcode INTO lst_bapiret-message.
    ex_msg_type = lc_e.
    ex_msg_id   = text-022.
    ex_msg      = lst_bapiret-message.
    lv_fval     = lst_bapiret-message.
    v_msgno     = ex_msg_id.
    PERFORM f_log_maintain  USING lv_fval ex_msg_type.
    CLEAR:v_msgno, lv_fval.
    LOOP AT li_vbak INTO lst_vbak.
      IF sy-tabix = 1.
        lv_fval = lst_vbak-vbeln.
      ELSE.
        CONCATENATE lv_fval lst_vbak-vbeln INTO lv_fval SEPARATED BY lc_cama.
      ENDIF.
    ENDLOOP.
    PERFORM f_log_maintain  USING lv_fval lc_i.
    CLEAR lv_fval.
    REFRESH li_vbap.
  ENDIF.
  LOOP AT li_vbap INTO DATA(lst_vbap1).
    lst_vbap = lst_vbap1.
    CONCATENATE lst_vbap-vbeln lc_slash lst_vbap-posnr text-019 INTO lv_fval
                                                                SEPARATED BY space.
    v_msgno = text-009.
    PERFORM f_log_maintain  USING lv_fval lc_i.
    CLEAR lv_fval.
    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                              vposn = lst_vbap-posnr
                                              BINARY SEARCH.
    IF sy-subrc = 0 AND lst_veda-vabndat IS INITIAL.
      READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_vbap-vbeln
                                                posnr = space
                                                BINARY SEARCH.
      IF sy-subrc = 0 AND  lst_vbpa-parvw IN lr_parvw.
*Checking the SFDC ID from input
        READ TABLE li_idnum TRANSPORTING NO FIELDS WITH KEY partner = lst_vbpa-kunnr
                                                            type    = lc_type
                                                            ext_idnumber = i_idnumber
                                                            BINARY SEARCH.
        IF sy-subrc = 0.
*--Preparing the heade details for order change
          lst_header_inx-updateflag = lc_u.

*--Preparing the item details for order change
          lst_item_in-itm_number = lst_vbap-posnr.
          APPEND lst_item_in TO li_item_in.
          lst_item_inx-itm_number = lst_vbap-posnr.
          lst_item_inx-updateflag = lc_u.
          APPEND lst_item_inx TO li_item_inx.

*--Preparing the item contract details for order change
          CREATE DATA lr_sales_contract_in.
          lr_sales_contract_in->itm_number = lst_vbap-posnr.
          lr_sales_contract_in->accept_dat = i_date.
          APPEND lr_sales_contract_in->* TO li_sales_contract_in.
          CLEAR lr_sales_contract_in->*.
          CREATE DATA lr_sales_contract_inx.
          lr_sales_contract_inx->itm_number =  lst_vbap-posnr.. " Iteme number
          lr_sales_contract_inx->updateflag = lc_u.
          lr_sales_contract_inx->accept_dat = abap_true.
          APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
          CLEAR lr_sales_contract_inx->*.


        ELSE.
*--Order BP SDFC code and input SDFC code is not matched
          MESSAGE e000(zqtc_r2) WITH text-005 INTO lst_bapiret-message.
          ex_msg_type = lc_e.
          ex_msg_id   = text-012.
          ex_msg      = lst_bapiret-message.
          lv_fval     = lst_bapiret-message.
          v_msgno     = ex_msg_id.
          PERFORM f_log_maintain  USING lv_fval ex_msg_type.
          CLEAR lv_fval.
          CONCATENATE text-021 lst_vbpa-kunnr INTO lv_fval SEPARATED BY space.
          PERFORM f_log_maintain  USING lv_fval ex_msg_type.
          CLEAR:v_msgno, lv_fval.
        ENDIF.
      ELSE.
*--Order BP is not found
        MESSAGE e000(zqtc_r2) WITH text-006 INTO lst_bapiret-message.
        ex_msg_type = lc_e.
        ex_msg_id   = text-011.
        ex_msg      = lst_bapiret-message.
        lv_fval     = lst_bapiret-message.
        v_msgno     = ex_msg_id.
        PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        CLEAR:v_msgno, lv_fval.
      ENDIF.
    ELSE.
*--Oreder is alreay updated with acceptance date
      MESSAGE e000(zqtc_r2) WITH text-018 INTO lst_bapiret-message.
      ex_msg_type = lc_e.
      ex_msg_id   = text-013.
      ex_msg      = lst_bapiret-message.
      lv_fval     = lst_bapiret-message.
      v_msgno     = ex_msg_id.
      PERFORM f_log_maintain  USING lv_fval ex_msg_type.
      CLEAR:v_msgno, lv_fval.
    ENDIF.
    AT LAST.
*--calling the fm for updating the order
      CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
        EXPORTING
          salesdocument      = lst_vbap-vbeln
          order_header_inx   = lst_header_inx
        TABLES
          return             = li_return
          item_in            = li_item_in
          item_inx           = li_item_inx
          sales_contract_in  = li_sales_contract_in
          sales_contract_inx = li_sales_contract_inx.
      READ TABLE li_return INTO DATA(lst_return) WITH KEY type = lc_e.
      IF sy-subrc NE 0.
*--Calling the transaction commit if no errors
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
        MESSAGE s000(zqtc_r2) WITH text-008 INTO lst_bapiret-message.
        ex_msg_type = lc_s.
        ex_msg_id   = text-009.
        ex_msg      = lst_bapiret-message.
        lv_fval     = lst_bapiret-message.
        v_msgno     = ex_msg_id.
        PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        LOOP AT li_return INTO lst_return.
          lv_fval   = lst_return-message.
          PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        ENDLOOP.
        CLEAR:v_msgno, lv_fval.
      ELSE.
*-- Order failed to update capturing the message
*          lst_bapiret = lst_return.
        MESSAGE e000(zqtc_r2) WITH text-016 INTO lst_bapiret-message.
            ex_msg_type = lc_e.
            ex_msg_id   = text-015.
            ex_msg      = text-016."lst_bapiret-message.
            lv_fval     = text-016.
            v_msgno     = ex_msg_id.
        PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        LOOP AT li_return INTO lst_return.
          lv_fval   = lst_return-message.
          v_msgno   = ex_msg_id.
          PERFORM f_log_maintain  USING lv_fval ex_msg_type.
        ENDLOOP.
        CLEAR:v_msgno, lv_fval.
      ENDIF.
    ENDAT.
  ENDLOOP.
* Save the log
  PERFORM f_log_save.
*-- sending failure aleert
  IF ex_msg_id IN lr_msgno.
    READ TABLE li_const INTO lst_const WITH KEY devid = lc_devid
                                                param1 = lc_alert.
    IF sy-subrc = 0 AND lst_const-low = abap_true.
      lst_exter-sign   = 'I'.
      lst_exter-option = 'EQ'.
      lst_exter-low    = v_exter.
      APPEND lst_exter TO lr_exter.
      SUBMIT zqtcr_kiara_adate_alert_i0369 WITH s_exter IN lr_exter
                                           AND RETURN.
    ENDIF.

  ENDIF.
ENDFUNCTION.
