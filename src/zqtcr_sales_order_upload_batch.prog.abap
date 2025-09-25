*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_SALES_ORDER_UPLOAD_BATCH
* PROGRAM DESCRIPTION: Subscription order update with BAPI
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   07/02/2018
* OBJECT ID:  N/A
* TRANSPORT NUMBER(S): ED2K912414
*----------------------------------------------------------------------*
REPORT zqtcr_sales_order_upload_batch.
TABLES: adr6.
* Type Declaration
TYPES : BEGIN OF ty_excel_file,
          leg_ref   TYPE vbkd-ihrez,  " Leg Ref Number
          filed2    TYPE char10,
          filed3    TYPE char20,
          field4    TYPE char10,
          field5    TYPE char10,
          field6    TYPE char10,
          field7    TYPE char20,
          field8    TYPE char10,
          field9    TYPE char10,
          leg_mq_no TYPE vbak-bname,  " Leg MQ Number
        END OF ty_excel_file,
        tt_excel_file TYPE STANDARD TABLE OF ty_excel_file,
        BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.
DATA :        i_excel_file  TYPE STANDARD TABLE OF ty_excel_file,
              st_excel_file TYPE ty_excel_file,
              i_mail        TYPE STANDARD TABLE OF ty_mail,
              g_job_name    TYPE tbtcjob-jobname.  " Job Name
PARAMETERS :  p_file TYPE string NO-DISPLAY.
SELECT-OPTIONS :p_mail FOR adr6-smtp_addr NO INTERVALS NO-DISPLAY.
PARAMETERS: p_ind  TYPE char1 NO-DISPLAY.
PARAMETERS: p_recon TYPE char10 DEFAULT '50000' NO-DISPLAY.
PARAMETERS: p_user TYPE sy-uname NO-DISPLAY  DEFAULT 'BC_RDWD'.
PARAMETERS :p_job TYPE tbtcjob-jobname NO-DISPLAY.
CONSTANTS : c_x  TYPE c VALUE 'X'.
************************************************************************
*                      START-OF-SELECTION                              *
************************************************************************
START-OF-SELECTION.
  REFRESH : i_excel_file.
  IF sy-batch = c_x.
    MESSAGE i000(zqtc_r2) WITH 'Batch job Started'.
  ENDIF.
  PERFORM read_from_app.
  PERFORM order_upd.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  READ_FROM_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_from_app .
  DATA : lv_string TYPE string,
         c_tab     TYPE abap_char1 VALUE cl_abap_char_utilities=>horizontal_tab.
  IF sy-batch = c_x.
    MESSAGE i000(zqtc_r2) WITH 'Reading the files from Application Server'.
  ENDIF.
  OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2).
    LEAVE LIST-PROCESSING.
  ENDIF.
  DO.
    READ DATASET p_file INTO lv_string.
    IF sy-subrc EQ 0.
      SPLIT lv_string AT ','      INTO st_excel_file-leg_ref
                                    st_excel_file-filed2
                                    st_excel_file-filed3
                                    st_excel_file-field4
                                    st_excel_file-field5
                                    st_excel_file-field6
                                    st_excel_file-field7
                                    st_excel_file-field8
                                    st_excel_file-field9
                                    st_excel_file-leg_mq_no.
      REPLACE ALL OCCURRENCES OF '"' IN st_excel_file-leg_ref WITH  space.
      CONDENSE st_excel_file-leg_ref.
      REPLACE ALL OCCURRENCES OF '"' IN st_excel_file-leg_mq_no WITH  space.
      CONDENSE st_excel_file-leg_mq_no.
      APPEND st_excel_file TO i_excel_file.
      CLEAR  st_excel_file.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  CLOSE DATASET p_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDER_UPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM order_upd .
  DATA : lv_lines TYPE i.
  IF sy-batch = c_x.
    DESCRIBE TABLE i_excel_file LINES lv_lines.
    MESSAGE i000(zqtc_r2) WITH 'Total' lv_lines 'Subscription order are updating with new value'.
  ENDIF.
  i_mail[] = p_mail[].
*  p_file =
  PERFORM f_bapi_update_with_new_value IN PROGRAM zqtc_sales_order_update USING p_recon
                                                                                p_ind
                                                                                p_user
                                                                                p_job
                                                                          CHANGING i_excel_file
                                                                                   i_mail." type tt_excel_file.
ENDFORM.
