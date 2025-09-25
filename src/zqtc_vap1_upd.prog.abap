REPORT zqtc_vap1_upd
       NO STANDARD PAGE HEADING LINE-SIZE 255.


TABLES: kna1.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-004.
PARAMETERS: p_kunnr TYPE kna1-kunnr MODIF ID m4.
PARAMETERS : p_name TYPE kna1-name1.
PARAMETERS : p_mail TYPE adr6-smtp_addr.
SELECTION-SCREEN END OF BLOCK b1.
*INCLUDE bdcrecx1.
DATA : bdcdata          LIKE bdcdata    OCCURS 0 WITH HEADER LINE.  "ED2K914010       NPOLINA ERP7860

START-OF-SELECTION.

*  PERFORM open_group.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0036'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'USE_ZAV'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'RF02D-KUNNR'
                                p_kunnr.
  PERFORM bdc_field       USING 'USE_ZAV'
                                'X'.
  PERFORM bdc_dynpro      USING 'SAPMF02D' '1361'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=UPDA'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'SZA5_D0700-SMTP_ADDR'.
  PERFORM bdc_field       USING 'SZA5_D0700-TITLE_MEDI'
                                'Mr.'.
  PERFORM bdc_field       USING 'ADDR3_DATA-NAME_LAST'
                                p_name.
  PERFORM bdc_field       USING 'ADDR3_DATA-LANGU_P'
                                'EN'.
*  PERFORM bdc_field       USING 'SZA5_D0700-TEL_NUMBER'
*                                '123344213'.
  PERFORM bdc_field       USING 'SZA5_D0700-SMTP_ADDR'
                                p_mail.
  PERFORM bdc_transaction USING 'VAP1'.

*  PERFORM close_group.
*  *&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_7250   text
*      -->P_7251   text
*----------------------------------------------------------------------*
FORM bdc_dynpro  USING program dynpro.

  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_7400   text
*      -->P_7401   text
*----------------------------------------------------------------------*
FORM bdc_field  USING    fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_7405   text
*      -->P_FP_LV_DOC_TYPE  text
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode .
  DATA : li_messtab  TYPE STANDARD TABLE OF bdcmsgcoll,
         lst_messtab TYPE bdcmsgcoll,
         lv_mode     TYPE ctu_mode VALUE 'N',
         lv_update   TYPE ctu_update VALUE 'S'.
*         lst_alv     TYPE ty_alv.

  REFRESH li_messtab.
*  CALL FUNCTION 'ENQUEUE_EVVBRKE'
*    EXPORTING
*      mode_vbrk      = 'E'
*      mandt          = sy-mandt
*      vbeln          = st_cmr-vbeln
*      x_vbeln        = ' '
*      _scope         = '2'
*      _wait          = 'X'
*      _collect       = ' '
*    EXCEPTIONS
*      foreign_lock   = 1
*      system_failure = 2
*      OTHERS         = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
  CLEAR : li_messtab[].
  CALL TRANSACTION tcode USING bdcdata
                   MODE   lv_mode
                   UPDATE lv_update
                   MESSAGES INTO li_messtab.
*
*  CALL FUNCTION 'DEQUEUE_EVVBRKE'
*    EXPORTING
*      mode_vbrk = 'E'
*      mandt     = sy-mandt
*      vbeln     = st_cmr-vbeln
*      x_vbeln   = ' '
*      _scope    = '3'
*      _synchron = ' '
*      _collect  = ' '.

  LOOP AT li_messtab INTO lst_messtab.
    IF lst_messtab-msgtyp NE 'I'.
      IF lst_messtab-msgnr = 205 AND lst_messtab-msgtyp = 'S'.
        CONTINUE.
      ENDIF.

*      CALL FUNCTION 'FORMAT_MESSAGE'
*        EXPORTING
*          id        = lst_messtab-msgid
*          lang      = '-D'
*          no        = lst_messtab-msgnr
*          v1        = lst_messtab-msgv1
*          v2        = lst_messtab-msgv2
*          v3        = lst_messtab-msgv3
*          v4        = lst_messtab-msgv4
*        IMPORTING
*          msg       = st_log-message
*        EXCEPTIONS
*          not_found = 1
*          OTHERS    = 2.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      st_log-posnr = st_cmr-posnr.
*      st_log-matnr = st_cmr-matnr.
*      st_log-vbeln = lst_messtab-msgv2.
*      st_log-msg_typ = lst_messtab-msgtyp.
*      st_log-message = st_log-message.
*      APPEND st_log TO i_log.
*      CLEAR:st_log.
*      CLEAR:v_bom.
    ENDIF.
  ENDLOOP.
ENDFORM.
