*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCR_PARTNER_UPLOAD_BATCH
* PROGRAM DESCRIPTION: Update ZY (Master License Owner) Partners in
*                      Order / Contract Headers
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2018-08-13
* OBJECT ID: ERP-6593
* TRANSPORT NUMBER(S): ED2K913026
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*& Report  ZQTCR_PARTNER_UPLOAD_BATCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_partner_upload_batch.
* Type Declaration
TYPES : BEGIN OF ty_excel_file,
          order     TYPE vbeln,          " Sales and Distribution Document Number
          part_func TYPE parvw,          " Partner Function
          cust_no   TYPE kunnr,          " Customer Number
        END OF ty_excel_file,
        tt_excel_file TYPE STANDARD TABLE OF ty_excel_file,

        BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.

DATA :        i_excel_file TYPE STANDARD TABLE OF ty_excel_file,
              i_mail       TYPE STANDARD TABLE OF ty_mail,
              v_email      TYPE adr6-smtp_addr,  " E-Mail Address
              v_job_name   TYPE tbtcjob-jobname. " Job Name

PARAMETERS :   p_a_file TYPE localfile NO-DISPLAY. " Local file for upload/download
SELECT-OPTIONS :p_mail FOR v_email NO INTERVALS NO-DISPLAY.
PARAMETERS:   p_recon TYPE char10 DEFAULT '50000' NO-DISPLAY,
              p_job TYPE tbtcjob-jobname NO-DISPLAY,
              p_user TYPE sy-uname NO-DISPLAY  DEFAULT 'BC_RDWD'.
************************************************************************
*                      START-OF-SELECTION                              *
************************************************************************
START-OF-SELECTION.
  REFRESH : i_excel_file.
  IF sy-batch = abap_true.
    MESSAGE i506(zqtc_r2). " Batch Job Started
  ENDIF. " IF sy-batch = abap_true
*  To read data from app server
  PERFORM f_read_from_app.

*  To update ZY partner
  PERFORM f_partner_upd.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  READ_FROM_APP
*&---------------------------------------------------------------------*
*      Read the data from application server
*----------------------------------------------------------------------*
FORM f_read_from_app .
  DATA : lv_string      TYPE string,
         lst_excel_file TYPE ty_excel_file,
         c_tab          TYPE abap_char1 VALUE cl_abap_char_utilities=>horizontal_tab.
  IF sy-batch = abap_true.
    MESSAGE i507(zqtc_r2). " Reading the files from Application Server
  ENDIF. " IF sy-batch = abap_true
  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2). " File does not transfer to Application server
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0
  DO.
    READ DATASET p_a_file INTO lv_string.
    IF sy-subrc EQ 0.
      SPLIT lv_string AT ',' INTO lst_excel_file-order
                                  lst_excel_file-part_func
                                  lst_excel_file-cust_no.
      APPEND lst_excel_file TO i_excel_file.
      CLEAR  lst_excel_file.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      EXIT.
    ENDIF. " IF sy-subrc EQ 0
  ENDDO.
  CLOSE DATASET p_a_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDER_UPD
*&---------------------------------------------------------------------*
*       Update partner
*----------------------------------------------------------------------*
FORM f_partner_upd .
  DATA : lv_lines TYPE i. " Lines of type Integers
  IF sy-batch = abap_true.
    DESCRIBE TABLE i_excel_file LINES lv_lines.
    MESSAGE i508(zqtc_r2) WITH lv_lines. " Total & Subscription order are updating with new value
  ENDIF. " IF sy-batch = abap_true
  i_mail[] = p_mail[].
  PERFORM f_partnr_update_with_new_value IN PROGRAM zqtcr_partners_update USING p_recon
                                                                                p_user
                                                                                p_job
                                                                          CHANGING i_excel_file
                                                                                   i_mail. " type tt_excel_file.
ENDFORM.
