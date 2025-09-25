*----------------------------------------------------------------------*
***INCLUDE LZQTC_BPF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_IDOC_INPUT_DEBMAS_BP (FM)
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data using IDOCs
*                      (Inbound Process Code)
* DEVELOPER: Venkata D Rao P (VDPATABALL)
* CREATION DATE: 10/24/2019
* OBJECT ID:      I0200.3
* TRANSPORT NUMBER(S):ED2K916411
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  DATA:lst_bp_roles TYPE ty_roles.
  SELECT devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
     FROM zcaconstant
     INTO TABLE i_constants
     WHERE devid = c_devid
       AND activate = abap_true.
  IF sy-subrc EQ 0.
    SORT i_constants BY param1.
  ENDIF.
  LOOP AT i_constants INTO DATA(lst_constants).
    CASE lst_constants-param1.
      WHEN c_bp_role.
*---BO Roles
        lst_bp_roles-sign   = lst_constants-sign.
        lst_bp_roles-opti   = lst_constants-opti.
        lst_bp_roles-low    = lst_constants-low.
        lst_bp_roles-high   = lst_constants-high.
        APPEND lst_bp_roles TO ir_bp_roles.
        CLEAR lst_bp_roles .
*--*collection profile
      WHEN c_coll_profile.
        sr_coll_profile-sign   = lst_constants-sign.
        sr_coll_profile-option = lst_constants-opti.
        sr_coll_profile-low    = lst_constants-low.
        sr_coll_profile-high   = lst_constants-high.
*--*Collection  group
      WHEN c_coll_grp.
        sr_coll_group-sign   = lst_constants-sign.
        sr_coll_group-option = lst_constants-opti.
        sr_coll_group-low    = lst_constants-low.
        sr_coll_group-high   = lst_constants-high.
*--*collection segement
      WHEN c_coll_seg.
        sr_coll_seg-sign   = lst_constants-sign.
        sr_coll_seg-option = lst_constants-opti.
        sr_coll_seg-low    = lst_constants-low.
        sr_coll_seg-high   = lst_constants-high.
* ---Collection Specialist
      WHEN c_coll_specialist.
        sr_coll_spl-sign   = lst_constants-sign.
        sr_coll_spl-option = lst_constants-opti.
        sr_coll_spl-low    = lst_constants-low.
        sr_coll_spl-high   = lst_constants-high.
*----Credit Check rule
      WHEN c_check_rule.
        sr_check_rule-sign   = lst_constants-sign.
        sr_check_rule-option = lst_constants-opti.
        sr_check_rule-low    = lst_constants-low.
        sr_check_rule-high   = lst_constants-high.
*---Credit Group
      WHEN c_credit_grp.
        sr_credit_grp-sign   = lst_constants-sign.
        sr_credit_grp-option = lst_constants-opti.
        sr_credit_grp-low    = lst_constants-low.
        sr_credit_grp-high   = lst_constants-high.
*---Credit Risk Class
      WHEN c_risk_cls.
        sr_risk_cls-sign   = lst_constants-sign.
        sr_risk_cls-option = lst_constants-opti.
        sr_risk_cls-low    = lst_constants-low.
        sr_risk_cls-high   = lst_constants-high.
*---Begin of change VDPATABALL ERPM-22990 I0200.3 Message function 06/26/2020
*----Message Function - for control record
      WHEN c_mesfct.
        CLEAR sr_mesfct.
        sr_mesfct-sign   = lst_constants-sign.
        sr_mesfct-option = lst_constants-opti.
        sr_mesfct-low    = lst_constants-low.
        sr_mesfct-high   = lst_constants-high.
        APPEND sr_mesfct TO ir_mesfct.
      WHEN c_vkorg.
        CLEAR sr_vkorg.
        sr_vkorg-sign   = lst_constants-sign.
        sr_vkorg-option = lst_constants-opti.
        sr_vkorg-low    = lst_constants-low.
        sr_vkorg-high   = lst_constants-high.
        APPEND sr_vkorg TO ir_vkorg.

*---Begin of change VDPATABALL ERPM-22990 I0200.3 Message function 06/26/2020
    ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTACT_EMAIL_UPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_Z1QTC_E1BPADSMTP  text
*      <--P_LI_KNVP  text
*----------------------------------------------------------------------*
FORM f_contact_email_upd  USING    p_z1qtc_e1bpadsmtp TYPE z1qtc_e1bpadsmtp
                                   p_knvp             TYPE  knvp.

  DATA : lv_msg     TYPE string,
         lv_msg_typ TYPE string,
         lv_mode    TYPE char1 VALUE 'N',
         lv_upd     TYPE char1 VALUE 'S',
         lv_cnt     TYPE numc2,
         lv_count   TYPE i.

  SELECT SINGLE *
    FROM knvk
    INTO @DATA(lst_knvk) WHERE kunnr = @p_knvp-kunnr.
  IF sy-subrc = 0.
    SELECT *
      FROM adr6
      INTO TABLE @DATA(li_adr6) WHERE persnumber = @lst_knvk-prsnr.
  ENDIF.
  iv_cont = lst_knvk-parnr.
  DESCRIBE TABLE li_adr6 LINES DATA(lv_existing_cnt).
  DESCRIBE TABLE i_smtp LINES DATA(lv_new_cnt).

  FREE: i_bdcdata,i_bdcmsg,lv_cnt,lv_count,iv_email_error.

  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '0036'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                'USE_ZAV'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM f_bdc_field       USING 'RF02D-PARNR'
                                p_knvp-parnr.
  PERFORM f_bdc_field       USING 'USE_ZAV'
                                abap_true.
  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '1361'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                'KNVK-PAVIP'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                '=$INT'.
  PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                'ADSMTP-SMTP_ADDR(01)'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                '=DELL'.
*---Deleteing existing Email Ids
  DO lv_existing_cnt TIMES.
    lv_cnt  = lv_cnt  + 1.
    CONCATENATE 'G_SELECTED(' lv_cnt ')' INTO DATA(lv_selected).
    PERFORM f_bdc_field       USING lv_selected
                                    abap_true.
  ENDDO.

*----Adding new Email Ids
  LOOP AT i_smtp[] INTO DATA(lst_smtp).
    lv_count = lv_count + 1.
    IF lv_count NE lv_new_cnt.
      PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
      PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                      'ADSMTP-FLGDEFAULT(01)'.
      PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                      '=NEWL'.
      PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                lst_smtp-contact-data-e_mail.
    ELSE.
      EXIT.
    ENDIF.
  ENDLOOP.

  PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                  'ADSMTP-SMTP_ADDR(01)'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                  '=CONT'.
*---For last record update
  READ TABLE i_smtp[] INTO lst_smtp INDEX lv_new_cnt.
  PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                  lst_smtp-contact-data-e_mail.
  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '1361'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                  'KNVK-PAVIP'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                  '=UPDA'.

  CALL TRANSACTION 'VAP2' USING i_bdcdata     "call transaction
                            MODE lv_mode      "N-no screen mode, A-all screen mode, E-error screen mode
                            UPDATE lv_upd     " A-assynchronous, S-synchronous
                            MESSAGES INTO  i_bdcmsg. "messages

  READ TABLE  i_bdcmsg INTO DATA(lst_bdcmsg) WITH KEY msgtyp = c_e.
  IF sy-subrc = 0.
    iv_email_error = abap_true.
  ENDIF.
  FREE: i_bdcdata,i_bdcmsg,lv_cnt,lv_count.
ENDFORM.

FORM f_bdc_field USING fnam fval.
  DATA : lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-fnam = fnam.
  lst_bdcdata-fval = fval.
  APPEND lst_bdcdata TO i_bdcdata.

ENDFORM.

FORM f_bdc_dynpro USING program dynpro.
  DATA : lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-program  = program. "program
  lst_bdcdata-dynpro   = dynpro. "screen
  lst_bdcdata-dynbegin = 'X'. "begin
  APPEND lst_bdcdata TO i_bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERSION_EXISTING_KUNNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_E1KNA1M_KUNNR  text
*----------------------------------------------------------------------*
FORM f_conversion_existing_kunnr  USING    p_lst_e1kna1m_kunnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = p_lst_e1kna1m_kunnr                                       " Business Partner Number (External)
    IMPORTING
      output = p_lst_e1kna1m_kunnr.
ENDFORM.
