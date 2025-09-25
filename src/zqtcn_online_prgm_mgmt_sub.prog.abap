*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILE_UPLOAD_ORDBP_SUB
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILE_UPLOAD_ORDBP_SUB (Routines)
* PROGRAM DESCRIPTION: Create ZOPM (Online Program Management ) contracts
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   03/06/2019
* OBJECT ID:       TBD
* TRANSPORT NUMBER(S): ED2K914619
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
*** Methods--------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CLASS lcl_main IMPLEMENTATION. " Main class
  METHOD: get_file_path.
    CONSTANTS: lc_i0358        TYPE zdevid     VALUE 'I0358',     " Development ID
               lc_param1_fpath TYPE rvari_vnam VALUE 'FILE_PATH', " ABAP: Name of Variant Variable
               lc_logical_path TYPE rvari_vnam VALUE 'LOGICAL_PATH', " Logical Path "NPOLINA ERP6378 ED2K913631
               lc_fileext      TYPE rvari_vnam VALUE 'FNAME_EXT'.      " File Ext NPOLINA ERP6378 ED2K913631
    DATA: lv_system_id TYPE rvari_vnam. " ABAP: Name of Variant Variable

*** fetch Data from ZCACONSTANT Table
    SELECT devid,    " Development ID
           param1,   " ABAP: Name of Variant Variable
           param2,   " ABAP: Name of Variant Variable
           srno,     " ABAP: Current selection number
           sign,     " ABAP: ID: I/E (include/exclude values)
           opti,     " ABAP: Selection option (EQ/BT/CP/...)
           low,      " Lower Value of Selection Condition
           high      " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @DATA(li_constant)
    WHERE devid    = @lc_i0358
    AND   activate = @abap_true.

    IF sy-subrc = 0.
* SOC by NPOLINA I0358 Paths   ERP6378 ED2K913631
      SORT li_constant BY param1.
*                          param2.

      clear:v_fileext.
      DATA(lst_constant1) = li_constant[ devid = lc_i0358 param1 = lc_fileext  ].
      v_fileext = lst_constant1-low.

*      lv_system_id = sy-sysid(2).
*      DATA(lst_constant) = li_constant[ devid = lc_i0358 param1 = lc_param1_fpath param2 = lv_system_id ].
      DATA(lst_constant) = li_constant[ devid = lc_i0358 param1 = lc_logical_path  ].

* EOC by NPOLINA I0358 Paths   ERP6378 ED2K913631
      v_file_path = lst_constant-low.
    ENDIF. " IF sy-subrc = 0
  ENDMETHOD.
  METHOD f4help_file.
    DATA:lv_rc TYPE i. " Rc of type Integers
    DATA: li_file_table  TYPE filetable,
          lst_file_table TYPE file_table. " file_table

    CALL METHOD cl_gui_frontend_services=>file_open_dialog ##NO_TEXT
      EXPORTING
        window_title = 'Select a file'
      CHANGING
        file_table   = li_file_table
        rc           = lv_rc.                               ##SUBRC_OK ##NO_TEXT

    IF sy-subrc = 0 AND
       li_file_table IS NOT INITIAL.
      lst_file_table = li_file_table[ 1 ].
      p_file = lst_file_table-filename.
    ENDIF. " IF sy-subrc = 0 AND

  ENDMETHOD.
  METHOD validate_society.

*    v_kunnr = p_kunnr.
*** Validate Customer from KNA1 table
    SELECT SINGLE kunnr " Customer Number
            FROM kna1   " General Data in Customer Master
      INTO @DATA(lv_kunnr)
      WHERE kunnr = @v_kunnr.
    IF sy-subrc NE 0.
      RAISE invalid_society.
    ENDIF. " IF sy-subrc NE 0
  ENDMETHOD.
  METHOD convert_excel.
    DATA : li_excel        TYPE STANDARD TABLE OF zqtc_alsmex_tabline " Rows for Table with Excel Data
                                INITIAL SIZE 0,                  " Rows for Table with Excel Data
           lst_excel_dummy TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
           lst_excel       TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
           lst_final       TYPE ty_file_excel.

    CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE'

      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 2       " File contains header
        i_end_col               = 34
        i_end_row               = 65000
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc EQ 0.
      IF li_excel[] IS NOT INITIAL.
        CLEAR lst_final.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          IF lst_excel_dummy-value(1) EQ text-sqt.
            lst_excel_dummy-value(1) = space.
            SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
          ENDIF. " IF lst_excel_dummy-value(1) EQ text-sqt
          AT NEW col.
            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT lst_final IS INITIAL.
                  APPEND lst_final TO i_final.
                  CLEAR lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL

                lst_final-uid = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 2.
                lst_final-auart = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 3.
                lst_final-spart = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 4.
                lst_final-bstkd = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 5.
                lst_final-kunnr_sp = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 6.
                lst_final-kunnr_we = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 7.
                lst_final-vkbur = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 8.
                lst_final-augru = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 9.
                lst_final-guebg = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 10.
                lst_final-gueen = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 11.
                lst_final-faksk = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 12.
                lst_final-matnr = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 13.
                lst_final-kwmeng = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 14.
                lst_final-arktx = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 15.
                lst_final-kdmat = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 16.
                lst_final-vkaus = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 17.
                lst_final-guebg_itm = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 18.
                lst_final-gueen_itm = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 19.
                lst_final-faksp = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 20.
                lst_final-kbetr = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 21.
                lst_final-kschl = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 22.
                lst_final-kbetr = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 23.
                lst_final-kschl2 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 24.
                lst_final-kbetr3 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 25.
                lst_final-parvw = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 26.
                lst_final-partner = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 27.
                lst_final-name1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 28.
                lst_final-name2 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 29.
                lst_final-street = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 30.
                lst_final-city1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 31.
                lst_final-post_code1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 32.
                lst_final-regio = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 33.
                lst_final-land1 = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 34.
                lst_final-tzone = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.



                IF NOT lst_final IS INITIAL.
                  APPEND lst_final TO i_final.
                  CLEAR lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL
* EOC by NPOLINA ERP7787     ED2K914488
            ENDCASE.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
* For last row population
        IF lst_final IS NOT INITIAL.

          APPEND lst_final TO i_final.
          CLEAR lst_final.
        ENDIF. " IF lst_final IS NOT INITIAL
      ENDIF. " IF li_excel[] IS NOT INITIAL
* SOC by NPOLINA ED2K913699
    ELSE.
      v_log = 'ERROR : Input file could not read'(061).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
* EOC by NPOLINA ED2K913699
    ENDIF. " IF sy-subrc EQ 0
  ENDMETHOD.
  METHOD validate_customer.
*DATA: lst_final  TYPE ty_file_excel.

    DATA(lst_final) = i_final[ 3 ].
    IF sy-subrc EQ 0.
*    IF p_kunnr NE lst_final-customer.
* SOC by NPOLINA ED2K913699
      v_log = 'ERROR : Customer in selection screen does not match with the customer in file'(059).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
* EOC by NPOLINA ED2K913699
      MESSAGE i510 DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
*    ENDIF. " IF p_kunnr NE lst_final-customer
* SOC by NPOLINA ED2K913699
    ELSE.
      v_log = 'ERROR : No records in upload file'(062).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
    ENDIF.
* EOC by NPOLINA ED2K913699
  ENDMETHOD.
  METHOD prepare_csv.
*** Local Constant Declaration
    CONSTANTS: lc_pipe   TYPE c VALUE '|',     " Tab of type Character
               lc_semico TYPE char1 VALUE ';'. " Semico of type CHAR1
**** Local field symbol declaration
    FIELD-SYMBOLS: <lfs_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
    DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
          li_final_csv  TYPE truxs_t_text_data.

* Calling FM to Convert the file to CSV format
    CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
      EXPORTING
        i_field_seperator    = lc_semico
      TABLES
        i_tab_sap_data       = i_final
      CHANGING
        i_tab_converted_data = li_final_csv[] " CSV file
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* SOC by NPOLINA ED2K913699
      v_log = 'ERROR : File could not convert to CSV format'(063).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
* EOC by NPOLINA ED2K913699
* Implement suitable error handling here
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0
    LOOP AT li_final_csv ASSIGNING <lfs_final_csv>.
      REPLACE ALL OCCURRENCES OF lc_semico IN <lfs_final_csv> WITH lc_pipe.
    ENDLOOP. " LOOP AT li_final_csv ASSIGNING <lfs_final_csv>

    IF li_final_csv[] IS NOT INITIAL.
      i_final_csv[] = li_final_csv[].
    ENDIF. " IF li_final_csv[] IS NOT INITIAL

  ENDMETHOD.
  METHOD file_upload.
    DATA: lv_fname      TYPE aco_string,  " String
* SOC by NPOLINA I0358 Paths   ERP6378 ED2K913631
*         lv_file       TYPE char70,      " File of type CHAR70
          lv_file       TYPE localfile,
* EOC by NPOLINA I0358 Paths   ERP6378 ED2K913631
          lv_length     TYPE i,           " Length of type Integers
          lv_fnm        TYPE char70,      " Fnm of type CHAR70
          lv_file_guid  TYPE sysuuid_c32, " 16 Byte UUID in 32 Characters (Hexadecimal Encoded)
          lst_final_csv TYPE LINE OF truxs_t_text_data.

  DATA : lv_path         TYPE filepath-pathintern , "NPOLINA ERP6378 ED2K913631
         lv_path_fname TYPE string.                 "NPOLINA ERP6378 ED2K913631

    CONSTANTS: lc_i0358     TYPE zdevid VALUE 'I0358', " Development ID
               lc_slash     TYPE char1  VALUE '/',     " Slash of type CHAR1
               lc_udrscore  TYPE char1  VALUE '_',     " Udrscore of type CHAR1
               lc_extension TYPE char4  VALUE '.txt',  " Extension of type CHAR4
               lc_x         TYPE char1    VALUE 'X',   " NPOLINA ERP6378 ED2K913631
               lc_e         TYPE char1    VALUE 'E'.   " NPOLINA ERP6378 ED2K913631
*** Create GUID
    TRY.
        CALL METHOD cl_system_uuid=>if_system_uuid_static~create_uuid_c32
          RECEIVING
            uuid = lv_file_guid.
      CATCH cx_uuid_error .
    ENDTRY.

    v_file_guid  = lv_file_guid.
*** checking if last character of file path is / or not
*** if not then then appending one /.
* SOC by NPOLINA I0358 Paths   ERP6378 ED2K913631

*    lv_fnm = v_file_path.
*    lv_length = strlen( lv_fnm ).
*    lv_length = lv_length - 1.
*    IF lv_fnm+lv_length(1) NE lc_slash.
*      CONCATENATE lv_fnm lc_slash INTO lv_fnm.
*    ENDIF. " IF lv_fnm+lv_length(1) NE lc_slash

*    CONCATENATE lc_i0358 lv_file_guid v_kunnr 'SocietyOrders'(055) INTO lv_file SEPARATED BY lc_udrscore.
     CONCATENATE lc_i0358 lv_file_guid v_kunnr v_fileext INTO lv_file SEPARATED BY lc_udrscore.

 CLEAR : lv_path_fname,lv_path.
  lv_path = v_file_path.
CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = lv_file
      eleminate_blanks           = lc_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
* SOC by NPOLINA ED2K913699
      v_log = 'ERROR : File path not found.'(064).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
* EOC by NPOLINA ED2K913699
    MESSAGE s001 DISPLAY LIKE lc_e.
    LEAVE LIST-PROCESSING.
  ELSE.
    lv_file = lv_path_fname.
  ENDIF.

*** Preparing file name
*    CONCATENATE lv_fnm lv_file lc_extension INTO lv_fname.
      CONCATENATE lv_file lc_extension INTO lv_fname.
* EOC by NPOLINA I0358 Paths   ERP6378 ED2K913631
    OPEN DATASET lv_fname FOR OUTPUT IN TEXT  MODE ENCODING UTF-8. " Output type
                      " opening file
    IF sy-subrc NE 0. " if file not opened showing error message
* SOC by NPOLINA ED2K913699
      v_log = 'ERROR : File cannot be opened.'(060).
*** Call Method to send an email
      CALL METHOD o_main->send_mail.
* EOC by NPOLINA ED2K913699
      MESSAGE e045(zqtc_r2). " File cannot be opened.
      RETURN.
    ENDIF. " IF sy-subrc NE 0

    LOOP AT i_final_csv  INTO lst_final_csv.
      TRANSFER lst_final_csv TO lv_fname. " transfering data
    ENDLOOP. " LOOP AT i_final_csv INTO lst_final_csv

    CLOSE DATASET  lv_fname. " closing file

*   Unique ID "&1" is assigned for this file upload.
    MESSAGE s303(zqtc_r2) WITH lv_file_guid. " Unique ID "&1" is assigned for this file upload.

  ENDMETHOD.
  METHOD send_mail.
*******Local Constant Declaration
    CONSTANTS: lc_raw TYPE so_obj_tp      VALUE 'RAW', "Code for document class
               lc_s   TYPE bapi_mtype     VALUE 'S'.   "Message type: S Success, E Error, W Warning, I Info, A Abort

    CLASS cl_bcs DEFINITION LOAD. " Business Communication Service

    DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
          lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions

    TRY .
        lr_send_request = cl_bcs=>create_persistent( ).
      CATCH cx_send_req_bcs.
    ENDTRY.

* Message body and subject
    DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
          lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
          lst_usr21         TYPE usr21,                                    " User Name/Address Key Assignment
          lst_adr6          TYPE adr6,                                     " E-Mail Addresses (Business Address Services)
          lv_subject        TYPE so_obj_des,                               " Short description of contents
          lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
          lr_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL,    " Interface of Sender Object in BCS
          lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
          lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
          lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
          lv_date_char      TYPE char10,                                   " Date_char of type CHAR10
          lv_time_char      TYPE char8.                                    " Time_char of type CHAR8


    CLEAR li_message_body.

    WRITE sy-datum TO lv_date_char.
    WRITE sy-uzeit TO lv_time_char.
    CONCATENATE 'Date:'(m03) lv_date_char INTO lst_message_body-line SEPARATED BY space.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.
    CONCATENATE 'Time:'(m04) lv_time_char INTO lst_message_body-line SEPARATED BY space.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.

    APPEND lst_message_body-line TO li_message_body.
    CONCATENATE 'Society Number:'(m02) v_kunnr INTO lst_message_body-line SEPARATED BY space.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.
    CONCATENATE 'Upload File Details:'(m01) p_file INTO lst_message_body-line SEPARATED BY space.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.

    APPEND lst_message_body-line TO li_message_body.
    CONCATENATE 'Ref GUID:'(m05) v_file_guid INTO lst_message_body-line SEPARATED BY space.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.

   IF v_log IS INITIAL.  "NPOLINA ED2K913699
    APPEND lst_message_body-line TO li_message_body.
    MOVE 'Please contact AMS ERP Team with above reference id for any more details on your upload file processing.'(m06) TO lst_message_body-line.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.
* SOC by NPOLINA ED2K913699
   ELSE.
    APPEND lst_message_body-line TO li_message_body.
    MOVE v_log TO lst_message_body-line.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.
   ENDIF.
* EOC by NPOLINA ED2K913699
    APPEND lst_message_body-line TO li_message_body.
    MOVE 'Thanks,'(m07) TO lst_message_body-line.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.
    MOVE 'AMS ERP Team'(m08) TO lst_message_body-line.
    APPEND lst_message_body-line TO li_message_body.
    CLEAR lst_message_body-line.

    CONCATENATE v_kunnr text-056 INTO lv_subject SEPARATED BY space.

*  Populate email body
    TRY .
        lr_document = cl_document_bcs=>create_document(
        i_type = lc_raw "'RAW'
        i_text = li_message_body
        i_subject = lv_subject ).
      CATCH cx_document_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.


    CLEAR : lst_usr21,lst_adr6.
    SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = sy-uname.
    IF lst_usr21 IS NOT INITIAL.
      SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                              AND   persnumber = lst_usr21-persnumber.
    ENDIF. " IF lst_usr21 IS NOT INITIAL

    IF lst_adr6-smtp_addr IS NOT INITIAL.
* Pass the document to send request
      TRY.
          lr_send_request->set_document( lr_document ).

* Create sender
          lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
          lr_send_request->set_sender(
          EXPORTING
          i_sender = lr_sender ).
        CATCH cx_address_bcs.
        CATCH cx_send_req_bcs.
      ENDTRY.

* Create recipient
      TRY.
          lr_recipient = cl_cam_address_bcs=>create_internet_address( lst_adr6-smtp_addr ).
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        CATCH cx_address_bcs.
        CATCH cx_send_req_bcs.
      ENDTRY.

* Send email
      TRY.
          lr_send_request->send(
          EXPORTING
          i_with_error_screen = abap_true " 'X'
          RECEIVING
          result = lv_sent_to_all ).


          CALL METHOD cl_system_transaction_state=>get_in_update_task
            RECEIVING
              in_update_task = lv_upd_tsk.
          IF lv_upd_tsk EQ 0.
            COMMIT WORK.
          ENDIF. " IF lv_upd_tsk EQ 0
        CATCH cx_send_req_bcs.
      ENDTRY.
    ENDIF. " IF lst_adr6-smtp_addr IS NOT INITIAL

  ENDMETHOD.

* SOC by NPOLINA ERP7787     ED2K914488
  METHOD down_template.
    TYPES: BEGIN OF lty_header ,
           lv_head(50) TYPE c, " Line(50) of type Character
          END OF lty_header.

     CONSTANTS:
            lc_uid      TYPE char10   VALUE  'UID',
            lc_smn      TYPE char10   VALUE  'SMN',
            lc_prefix  TYPE char10   VALUE  'PREFIX',
            lc_name1    TYPE char10   VALUE  'NAME1',
            lc_mname    TYPE char10   VALUE  'MNAME',
            lc_name2    TYPE char10   VALUE  'NAME2',
            lc_suffix  TYPE char10   VALUE  'SUFFIX',
            lc_cmpaff  TYPE char10   VALUE  'CMPAFF',
            lc_dept    TYPE char10   VALUE  'DEPT',
            lc_adrnr    TYPE char10   VALUE  'ADRNR',
            lc_adrnr2  TYPE char10   VALUE  'ADRNR2',
            lc_adrnr3  TYPE char10   VALUE  'ADRNR3',
            lc_ort01    TYPE char10   VALUE  'ORT01',
            lc_regio    TYPE char10   VALUE  'REGIO',
            lc_land1    TYPE char10   VALUE  'LAND1',
            lc_pstlz    TYPE char10   VALUE  'PSTLZ',
            lc_smtp_addr  TYPE char10   VALUE  'SMTP_ADDR',
            lc_telf1    TYPE char10   VALUE  'TELF1',
            lc_relcat  TYPE char10   VALUE  'RELCAT',
            lc_relstdt  TYPE char10   VALUE  'RELSTDT',
            lc_relendt  TYPE char10   VALUE  'RELENDT',
            lc_bukrs   TYPE char10   VALUE  'BUKRS',
            lc_customer  TYPE char10   VALUE  'CUSTOMER',
            lc_parvw   TYPE char10   VALUE  'PARVW',
            lc_kunnr   TYPE char10   VALUE  'KUNNR',
            lc_vkorg   TYPE char10   VALUE  'VKORG',
            lc_vtweg   TYPE char10   VALUE  'VTWEG',
            lc_spart   TYPE char10   VALUE  'SPART',
            lc_guebg    TYPE char10   VALUE  'GUEBG',
            lc_gueen    TYPE char10   VALUE  'GUEEN',
            lc_posnr    TYPE char10   VALUE  'POSNR',
            lc_matnr    TYPE char10   VALUE  'MATNR',
            lc_vbeln    TYPE char10   VALUE  'VBELN',
            lc_pstyv    TYPE char10   VALUE  'PSTYV',
            lc_zmeng    TYPE char10   VALUE  'ZMENG',
            lc_lifsk    TYPE char10   VALUE  'LIFSK',
            lc_faksk    TYPE char10   VALUE  'FAKSK',
            lc_abgru    TYPE char10   VALUE  'ABGRU',
            lc_auart    TYPE char10   VALUE  'AUART',
            lc_xblnr    TYPE char10   VALUE  'XBLNR',
            lc_zlsch    TYPE char10   VALUE  'ZLSCH',
            lc_bsark    TYPE char10   VALUE  'BSARK',
            lc_bstnk    TYPE char10   VALUE  'BSTNK',
            lc_stxh    TYPE char10   VALUE  'STXH',
            lc_kschl    TYPE char10   VALUE  'KSCHL',
            lc_kbetr    TYPE char10   VALUE  'KBETR',
            lc_ihrez    TYPE char10   VALUE  'IHREZ',
            lc_zzpromo  TYPE char10   VALUE  'ZZPROMO',
            lc_kdkg4    TYPE char10   VALUE  'KDKG4',
            lc_kdkg5    TYPE char10   VALUE  'KDKG5',
            lc_kdkg3    TYPE char10   VALUE  'KDKG3',
            lc_srid    TYPE char10   VALUE  'SRID',
            lc_vkbur    TYPE char10   VALUE  'VKBUR',
            lc_fkdat    TYPE char10   VALUE  'FKDAT',
            lc_inv_text  TYPE char10   VALUE  'INV_TEXT'.
DATA: st_struc  TYPE ty_file_excel,
      li_strc   TYPE REF TO cl_abap_structdescr,
      li_comp   TYPE abap_component_tab,
      lst_comp  TYPE abap_componentdescr,
      li_head   TYPE TABLE OF lty_header,
      li_data TYPE TABLE OF ty_file_excel,
      lst_head  TYPE lty_header,
      lv_fname  TYPE string, "FILE NAME
      lv_fname2 TYPE string, "FILE NAME
      lv_path   TYPE string, "FILE PATH
      lv_fpath  TYPE string. "FULL FILE PATH.

    FIELD-SYMBOLS: <f_str>  TYPE any.

    ASSIGN st_struc TO <f_str>.

* Get the structure of the table.
    li_strc ?= cl_abap_typedescr=>describe_by_data( <f_str> ).
    li_comp = li_strc->get_components( ).
*    APPEND st_struc to lt_data.

    LOOP AT li_comp INTO lst_comp.

     CASE lst_comp-name.

      WHEN lc_uid.
        lst_head-lv_head = text-001.
      WHEN  lc_smn.
        lst_head-lv_head = text-002.
      WHEN  lc_prefix.
        lst_head-lv_head = text-003.
      WHEN  lc_name1.
        lst_head-lv_head = text-004.
      WHEN  lc_mname.
        lst_head-lv_head = text-005.
      WHEN  lc_name2.
        lst_head-lv_head = text-006.
      WHEN  lc_suffix.
        lst_head-lv_head = text-007.
      WHEN  lc_cmpaff.
        lst_head-lv_head = text-008.
      WHEN  lc_dept.
        lst_head-lv_head = text-009.
      WHEN  lc_adrnr.
        lst_head-lv_head = text-010.
      WHEN  lc_adrnr2.
        lst_head-lv_head = text-011.
      WHEN  lc_adrnr3.
        lst_head-lv_head = text-012.
      WHEN  lc_ort01.
        lst_head-lv_head = text-013.
      WHEN  lc_regio.
        lst_head-lv_head = text-014.
      WHEN  lc_land1.
        lst_head-lv_head = text-015.
      WHEN  lc_pstlz.
        lst_head-lv_head = text-016.
      WHEN  lc_smtp_addr.
        lst_head-lv_head = text-017.
      WHEN  lc_telf1.
        lst_head-lv_head = text-018.
      WHEN  lc_relcat.
        lst_head-lv_head = text-019.
      WHEN  lc_relstdt.
        lst_head-lv_head = text-020.
      WHEN  lc_relendt.
        lst_head-lv_head = text-021.
      WHEN  lc_bukrs.
        lst_head-lv_head = text-022.
      WHEN  lc_customer.
        lst_head-lv_head = text-023.
      WHEN  lc_parvw.
        lst_head-lv_head = text-024.
      WHEN  lc_kunnr.
        lst_head-lv_head = text-025.
      WHEN  lc_vkorg.
        lst_head-lv_head = text-026.
      WHEN  lc_vtweg.
        lst_head-lv_head = text-027.
      WHEN  lc_spart.
        lst_head-lv_head = text-028.
      WHEN  lc_guebg.
        lst_head-lv_head = text-029.
      WHEN  lc_gueen.
        lst_head-lv_head = text-030.
      WHEN  lc_posnr.
        lst_head-lv_head = text-031.
      WHEN  lc_matnr.
        lst_head-lv_head = text-032.
      WHEN  lc_vbeln.
        lst_head-lv_head = text-033.
      WHEN  lc_pstyv.
        lst_head-lv_head = text-034.
      WHEN  lc_zmeng.
        lst_head-lv_head = text-035.
      WHEN  lc_lifsk.
        lst_head-lv_head = text-036.
      WHEN  lc_faksk.
        lst_head-lv_head = text-037.
      WHEN  lc_abgru.
        lst_head-lv_head = text-038.
      WHEN  lc_auart.
        lst_head-lv_head = text-039.
      WHEN  lc_xblnr.
        lst_head-lv_head = text-040.
      WHEN  lc_zlsch.
        lst_head-lv_head = text-041.
      WHEN  lc_bsark.
        lst_head-lv_head = text-042.
      WHEN  lc_bstnk.
        lst_head-lv_head = text-043.
      WHEN  lc_stxh.
        lst_head-lv_head = text-044.
      WHEN  lc_kschl.
        lst_head-lv_head = text-045.
      WHEN  lc_kbetr.
        lst_head-lv_head = text-046.
      WHEN  lc_ihrez.
        lst_head-lv_head = text-047.
      WHEN  lc_zzpromo.
        lst_head-lv_head = text-048.
      WHEN  lc_kdkg4.
        lst_head-lv_head = text-049.
      WHEN  lc_kdkg5.
        lst_head-lv_head = text-050.
      WHEN  lc_kdkg3.
        lst_head-lv_head = text-051.
      WHEN  lc_srid.
        lst_head-lv_head = text-052.
      WHEN  lc_vkbur.
        lst_head-lv_head = text-053.
      WHEN  lc_fkdat.
        lst_head-lv_head = text-054.
      WHEN  lc_inv_text.
        lst_head-lv_head = text-066.
      ENDCASE.
      APPEND lst_head to li_head.
      CLEAR:lst_head,lst_comp.
    ENDLOOP.


     CALL METHOD cl_gui_frontend_services=>file_save_dialog  ##SUBRC_OK ##NO_TEXT
        EXPORTING
          default_extension = 'XLS'
          window_title      = 'Save dailog'
        CHANGING
          filename          = lv_fname
          path              = lv_path
          fullpath          = lv_fpath.          ##SUBRC_OK ##NO_TEXT
      IF sy-subrc <> 0.                          ##SUBRC_OK ##NO_TEXT
        MESSAGE e000 WITH text-067.
      ELSE.

       IF lv_fpath IS NOT INITIAL.
        CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              filename              = lv_fpath
              filetype              = 'ASC'
              write_field_separator = '|'
              header                = '00'
              wk1_t_size            = 15
            TABLES
              data_tab              = li_data[]
              fieldnames            = li_head
            EXCEPTIONS
              OTHERS                = 22.
          IF sy-subrc <> 0.
            MESSAGE e000 WITH text-068.
          ENDIF. " IF sy-subrc <> 0
      ENDIF.
    ENDIF.
  ENDMETHOD.
* EOC by NPOLINA ERP7787     ED2K914488
ENDCLASS.
