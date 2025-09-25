*----------------------------------------------------------------------*
* FUNCTION MODULE NAME:ZQTC_SOHELP_EXIT (Enhancement Implementation)
* PROGRAM DESCRIPTION:Function Module for Sales Order Search Help
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   06/10/2016
* OBJECT ID: E061
* TRANSPORT NUMBER(S): ED2K903058
*----------------------------------------------------------------------*
FUNCTION zqtc_sohelp_exit.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------
*** local Types Declaration
  TYPES: BEGIN OF lty_email_range,
           sign   TYPE char1,      " Sign of type CHAR1
           option TYPE char2,      " Option of type CHAR2
           low    TYPE ad_smtpadr, " E-Mail Address
           high   TYPE ad_smtpadr, " E-Mail Address
         END OF lty_email_range.

  TYPES: BEGIN OF lty_email.
          INCLUDE TYPE m_vmvae.
  TYPES: email TYPE ad_smtpadr,       " E-Mail Address
         END OF lty_email,

         BEGIN OF lty_adr6,
           vbeln     TYPE vbeln,      " Sales and Distribution Document Number
           parvw     TYPE parvw,      " Partner Function
           smtp_addr TYPE ad_smtpadr, " E-Mail Address
         END OF lty_adr6.

  DATA: lst_email       TYPE lty_email,
        lst_record_temp TYPE lty_email,
        lst_adr6        TYPE lty_adr6,
        li_record_temp  TYPE STANDARD TABLE OF lty_email INITIAL SIZE 0.

*** local data declaration
  DATA:  li_seltop       TYPE ddshselops,
         lst_seltop      TYPE ddshselopt, " Selection options for value selection with search help
         lst_record      TYPE seahlpres,  " Search help result structure
         lv_idx          TYPE sytabix,    " Row Index of Internal Tables
         li_email_range  TYPE STANDARD TABLE OF lty_email_range,
         lst_email_range TYPE lty_email_range.


** local constant declaration
  CONSTANTS: lc_disp          TYPE ddshf4step VALUE 'DISP',        " Current step in the F4 process
             lc_zqtce_so_help TYPE shlpname VALUE 'ZQTCE_SO_HELP', " Name of a Search Help
             lc_smtp_addr     TYPE shlpfield VALUE 'SMTP_ADDR'.    " Name of a search help parameter


  IF  callcontrol-step = lc_disp. " DISP

    LOOP AT record_tab INTO lst_record.
      lst_record_temp = lst_record-string.
      APPEND  lst_record_temp TO li_record_temp.
      CLEAR lst_record_temp.
    ENDLOOP. " LOOP AT record_tab INTO lst_record

    IF li_record_temp[] IS NOT INITIAL.
      SELECT a~vbeln AS vbeln,
             a~parvw AS parvw,
             b~smtp_addr AS smtp_addr " E-Mail Address
      INTO TABLE @DATA(li_adr6)
      FROM adr6 AS b                  " E-Mail Addresses (Business Address Services)
      INNER JOIN vakpa AS a ON a~adrnr = b~addrnumber
      FOR ALL ENTRIES IN @li_record_temp
      WHERE a~vbeln = @li_record_temp-vbeln
        AND a~parvw = @li_record_temp-parvw.
      IF sy-subrc EQ 0.
        SORT li_adr6 BY vbeln parvw.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_record_temp[] IS NOT INITIAL


    li_seltop[] = shlp-selopt[].
*** Checking if Email ID  has been entered or not
*** Binary search cannot be used as this table cannot be sorted
    READ TABLE li_seltop TRANSPORTING NO FIELDS
    WITH KEY shlpname = lc_zqtce_so_help
             shlpfield = lc_smtp_addr.

    IF sy-subrc IS INITIAL.
*** Fetching the email address which has been entered
      LOOP AT li_seltop INTO lst_seltop
       WHERE shlpname = lc_zqtce_so_help
           AND  shlpfield = lc_smtp_addr.
        IF sy-subrc = 0.
          lst_email_range-sign =  lst_seltop-sign.
          lst_email_range-option =  lst_seltop-option.
          lst_email_range-low =  lst_seltop-low.
          lst_email_range-high =  lst_seltop-high.
          APPEND lst_email_range TO li_email_range.
        ENDIF. " IF sy-subrc = 0
      ENDLOOP. " LOOP AT li_seltop INTO lst_seltop
    ENDIF. " IF sy-subrc IS INITIAL



    LOOP AT record_tab INTO lst_record.
      lv_idx = sy-tabix.
      lst_email = lst_record-string.
      READ TABLE li_adr6 INTO lst_adr6 WITH KEY vbeln = lst_email-vbeln
                                                parvw = lst_email-parvw
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_email-email   = lst_adr6-smtp_addr.
        lst_record-string = lst_email.
        IF li_email_range IS INITIAL.
          MODIFY record_tab FROM lst_record INDEX lv_idx TRANSPORTING string.
        ELSE. " ELSE -> IF li_email_range IS INITIAL
          IF lst_email-email IN li_email_range.
            MODIFY record_tab FROM lst_record INDEX lv_idx TRANSPORTING string.
          ELSE. " ELSE -> IF lst_email-email IN li_email_range
            DELETE record_tab INDEX lv_idx.
          ENDIF. " IF lst_email-email IN li_email_range
        ENDIF. " IF li_email_range IS INITIAL
      ELSE. " ELSE -> IF sy-subrc EQ 0
        IF li_email_range IS NOT INITIAL.
          DELETE record_tab INDEX lv_idx.
        ENDIF. " IF li_email_range IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
      CLEAR: lst_record ,
                lst_record_temp,
                lst_adr6,
                lst_email.
    ENDLOOP. " LOOP AT record_tab INTO lst_record

  ENDIF. " IF callcontrol-step = lc_disp

ENDFUNCTION.
