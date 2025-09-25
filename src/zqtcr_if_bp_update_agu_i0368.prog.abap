*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_BP_UPDATE_AGU_I0368
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_BP_UPDATE_AGU_I0368
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_IF_BP_UPDATE_AGU_I0368
*& PROGRAM DESCRIPTION:   BP creation interface based on file Input
*& DEVELOPER:             VDPATABALL/PTUFARAM
*& CREATION DATE:         09/09/2019
*& OBJECT ID:             I0368
*& TRANSPORT NUMBER(S):   ED2K916061
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_if_bp_update_agu_i0368 NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.

DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_I0368_UPLOAD_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_I0368_UPLOAD_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_I0368_UPLOAD_ERR',
     v_path_out TYPE filepath-pathintern VALUE 'Z_I0368_UPLOAD_OUT'.

DATA : v_filename   TYPE string,
       lst_filename TYPE string,
       v_file_path  TYPE string,
       v_path_fname TYPE string,
       v_file       TYPE localfile,
       v_file_mask  TYPE epsfilnam,
       v_dir        TYPE epsdirnam,
       v_sourcepath TYPE  sapb-sappfad,
       v_targetpath TYPE  sapb-sappfad,
       lv_data      TYPE string,
       lst_tab_data TYPE string,
       lst_bp       TYPE zsqtc_bp_input_i0368,
       i_return     TYPE ztqtc_bp_output_i0368,
       i_string     TYPE STANDARD TABLE OF string,
       i_bp         TYPE STANDARD TABLE OF zsqtc_bp_input_i0368,
       i_dir_list   TYPE STANDARD TABLE OF epsfili.
DATA: lv_str_t  TYPE string,
      lv_length TYPE i,
      lv_ofst   TYPE i,
      lv_cnt    TYPE i.
FIELD-SYMBOLS: <fs> TYPE  zsqtc_bp_input_i0368.
DATA:ls_file_name      TYPE epsf-epsfilnam,
     ls_dir_name       TYPE epsf-epsdirnam,
     ls_file_path      TYPE epsf-epspath,
     ev_long_file_path TYPE eps2path,
     lv_flag           TYPE char1.


CONSTANTS:c_delimiter TYPE char1 VALUE ',',
          c_x         TYPE char1 VALUE 'X',
          c_e         TYPE char1 VALUE 'E',
          c_s         TYPE char1 VALUE 'S'.

*---Selection Screen
TABLES adr6.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_file TYPE rlgrap-filename DEFAULT 'AGU_1001_NEW_MEMBER_*' OBLIGATORY,
            p_head AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
SELECT-OPTIONS :s_mail FOR adr6-smtp_addr NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
*--Get the Application Layer path dynamically
  PERFORM f_get_file_path USING v_path_in p_file.
  REPLACE ALL OCCURRENCES OF p_file IN v_file_path WITH ''.
  v_dir       = v_file_path.
  v_file_mask = p_file.
  CALL FUNCTION 'EPS_GET_DIRECTORY_LISTING'
    EXPORTING
      dir_name               = v_dir
      file_mask              = v_file_mask
    TABLES
      dir_list               = i_dir_list
    EXCEPTIONS
      invalid_eps_subdir     = 1
      sapgparam_failed       = 2
      build_directory_failed = 3
      no_authorization       = 4
      read_directory_failed  = 5
      too_many_read_errors   = 6
      empty_directory_list   = 7
      OTHERS                 = 8.
  IF sy-subrc EQ 4.
    MESSAGE 'No authorization to access the file'(043) TYPE c_e.
  ELSEIF sy-subrc <> 0 .
    MESSAGE 'No file found'(041) TYPE c_e.
  ELSE.
    IF i_dir_list IS NOT INITIAL.
      LOOP AT i_dir_list INTO DATA(lst_dir_list).
        CONCATENATE v_dir lst_dir_list-name INTO v_filename.
        OPEN DATASET v_filename FOR INPUT IN LEGACY TEXT MODE CODE PAGE '1100'.
        IF NOT sy-subrc IS INITIAL.
          MESSAGE e048(cms) WITH v_filename RAISING file_read_error.
          EXIT.
        ELSE.
          DO.
            READ DATASET v_filename INTO lst_tab_data.
            IF sy-subrc IS INITIAL.
              FREE:i_string.
              FREE:lv_length,lv_ofst,lv_str_t,lv_cnt.
              lv_length = strlen( lst_tab_data ).
              DO.
                IF lv_ofst = lv_length.
                  EXIT.
                ENDIF.
                IF lst_tab_data+lv_ofst(1) CO '"'.
                  lv_flag = abap_true.
                  lv_cnt = lv_cnt + 1.
                  IF lv_cnt GE 2.
                    CLEAR:lv_flag,lv_cnt.
                  ENDIF.
                ENDIF.
                IF lv_flag = abap_true.
                  IF lst_tab_data+lv_ofst(1) CO ','.
                  ELSE.
                    CONCATENATE lv_str_t lst_tab_data+lv_ofst(1) INTO lv_str_t.
                  ENDIF.
                ELSE.
                  CONCATENATE lv_str_t lst_tab_data+lv_ofst(1)  INTO lv_str_t.
                ENDIF.
                lv_ofst = lv_ofst + 1.
              ENDDO.
              SPLIT lv_str_t AT c_delimiter INTO TABLE i_string.
              LOOP AT i_string ASSIGNING FIELD-SYMBOL(<fs_string>).
                ASSIGN COMPONENT sy-tabix OF STRUCTURE lst_bp TO FIELD-SYMBOL(<fs_bp>).
                IF sy-subrc = 0.
                  <fs_bp> = <fs_string>.
                ENDIF.
                AT LAST.
                  APPEND lst_bp TO i_bp.
                  CLEAR lst_bp .
                ENDAT.
              ENDLOOP.
            ELSE.
              EXIT.
            ENDIF.
          ENDDO.
        ENDIF.
        CLOSE DATASET v_filename.
        IF i_bp IS NOT INITIAL.
          IF p_head IS NOT INITIAL.
            DELETE i_bp INDEX 1.
          ENDIF.
          FREE:i_return.
*---Creating New BP for new customers
          CALL FUNCTION 'ZQTC_BP_INTERFACE_AGU_I0368'
            EXPORTING
              im_data   = i_bp
            IMPORTING
              ex_return = i_return.

          IF i_return IS NOT INITIAL.
            READ TABLE i_return INTO DATA(lst_return) WITH KEY msg_type = c_e.
            IF sy-subrc = 0.
*---return file moving into error folder
              CLEAR v_filename.
              PERFORM f_get_file_path USING v_path_err p_file.
              REPLACE ALL OCCURRENCES OF p_file IN v_file_path WITH ''.
              CONCATENATE v_file_path lst_dir_list-name INTO v_filename.
              OPEN DATASET  v_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
              IF sy-subrc NE 0.
                MESSAGE s100 DISPLAY LIKE c_e.
                LEAVE LIST-PROCESSING.
              ENDIF.
              LOOP AT i_return INTO lst_return.
                CONCATENATE lst_return-e_mail       lst_return-id_number  lst_return-indicator
                            lst_return-title        lst_return-firstname  lst_return-lastname
                            lst_return-dept   lst_return-org lst_return-street
                            lst_return-street_line2   lst_return-street_line3   lst_return-postl_cod1
                            lst_return-city         lst_return-region     lst_return-country
                            lst_return-telephone    lst_return-reltyp     lst_return-bp
                            lst_return-msg_type     lst_return-msg_number lst_return-message
                            INTO lv_data SEPARATED BY c_delimiter.
                TRANSFER lv_data TO v_filename.
                CLEAR: lv_data,lst_return.
              ENDLOOP.
              CLOSE DATASET  v_filename.
            ENDIF.
*--return file moving into out folder
            CLEAR v_filename.
            PERFORM f_get_file_path USING v_path_out p_file.
            REPLACE ALL OCCURRENCES OF p_file IN v_file_path WITH ''.
            CONCATENATE v_file_path 'OUT_' lst_dir_list-name INTO v_filename.
            OPEN DATASET  v_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
            IF sy-subrc NE 0.
              MESSAGE s100 DISPLAY LIKE c_e.
              LEAVE LIST-PROCESSING.
            ENDIF.
            LOOP AT i_return INTO lst_return.
              CONCATENATE lst_return-e_mail       lst_return-id_number  lst_return-indicator
                            lst_return-title        lst_return-firstname  lst_return-lastname
                            lst_return-dept    lst_return-org lst_return-street
                            lst_return-street_line2   lst_return-street_line3   lst_return-postl_cod1
                            lst_return-city         lst_return-region     lst_return-country
                            lst_return-telephone    lst_return-reltyp     lst_return-bp
                            lst_return-msg_type     lst_return-msg_number lst_return-message
                            INTO lv_data SEPARATED BY c_delimiter.
              TRANSFER lv_data TO v_filename.
              CLEAR: lv_data,lst_return.
            ENDLOOP.
            CLOSE DATASET  v_filename.
*---file moving into processing
            CONCATENATE v_dir lst_dir_list-name INTO v_filename.
            v_sourcepath =  v_filename.
            PERFORM f_get_file_path USING v_path_prc p_file.              " get the processing path
            REPLACE ALL OCCURRENCES OF p_file IN v_file_path WITH ''.
            CONCATENATE v_file_path lst_dir_list-name INTO v_targetpath.  " processing path
            PERFORM f_moving_next_level.                                   " moving to PROC and deleteing from IN
*---sending an email
            PERFORM send_email.
          ENDIF.
        ENDIF.
        FREE:lst_return,i_return,i_bp,lst_bp,v_filename,lst_dir_list,lv_data,lst_tab_data,i_string.
      ENDLOOP.
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING    fp_v_path
                               fp_v_filename.
  CLEAR :v_file_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_v_path
      operating_system           = sy-opsys
      file_name                  = fp_v_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_file_path
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVING_NEXT_LEVEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_moving_next_level .

  CALL FUNCTION 'ARCHIVFILE_SERVER_TO_SERVER'
    EXPORTING
      sourcepath       = v_sourcepath
      targetpath       = v_targetpath
    EXCEPTIONS
      error_file       = 1
      no_authorization = 2
      OTHERS           = 3.
  IF sy-subrc = 2.
    MESSAGE text-043 TYPE c_e.
  ELSEIF sy-subrc <> 0.
    MESSAGE 'File Not transfered to Proccessing'(006) TYPE c_e.
  ELSE.
    FREE:ls_file_name , ls_dir_name,ls_file_path,ev_long_file_path.
    ls_file_name = lst_dir_list-name.
    ls_dir_name  = v_dir.

    CALL FUNCTION 'EPS_DELETE_FILE'
      EXPORTING
        file_name              = ls_file_name
        dir_name               = ls_dir_name
      IMPORTING
        file_path              = ls_file_path
        ev_long_file_path      = ev_long_file_path
      EXCEPTIONS
        invalid_eps_subdir     = 1
        sapgparam_failed       = 2
        build_directory_failed = 3
        no_authorization       = 4
        build_path_failed      = 5
        delete_failed          = 6
        OTHERS                 = 7.
    IF sy-subrc = 4.
      MESSAGE text-043 TYPE c_e.
    ELSEIF sy-subrc <> 0.
      MESSAGE 'File not removed from IN folder'(004) TYPE c_e.
    ELSE.
      MESSAGE 'File transfered to Proccessing folder'(005) TYPE c_s.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_email .

  DATA:lst_text         TYPE so_text255,
       lt_text          TYPE bcsy_text,
       lv_send_request  TYPE REF TO cl_bcs,
       lv_string        TYPE string,
       lv_sender        TYPE REF TO cl_cam_address_bcs,
       lv_recipient     TYPE REF TO if_recipient_bcs,
       lv_mailid        TYPE ad_smtpadr,
       lt_bin_con       TYPE solix_tab,
       lv_size          TYPE so_obj_len,
       lv_sub           TYPE so_obj_des,
       lv_attnam        TYPE sood-objdes,
       lv_document      TYPE REF TO cl_document_bcs,
       lv_all           TYPE os_boolean,
       bcs_exception    TYPE REF TO cx_bcs,
       li_constants     TYPE zcat_constants,
       lst_sender_email TYPE adr6-smtp_addr,
       lv_sender_name   TYPE adr6-smtp_addr.

  CONSTANTS:gc_tab         TYPE c VALUE cl_bcs_convert=>gc_tab,
            gc_crlf        TYPE c VALUE cl_bcs_convert=>gc_crlf,
            lc_raw         TYPE char3 VALUE 'RAW',
            lc_xls         TYPE char3 VALUE 'XLS',
            lc_devid_i0368 TYPE zdevid VALUE 'I0368',             "DevID
            lc_sender      TYPE rvari_vnam VALUE 'SENDER_EMAIL'.  "Variable name
  .
*---Check the Constant table before going to the actual logic wheather Sender email is active or not.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_i0368  "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
  IF li_constants IS NOT INITIAL.
    LOOP AT li_constants[] ASSIGNING FIELD-SYMBOL(<lfs_constant>).
*---sender constant value
      IF <lfs_constant>-param1   = lc_sender.
        lst_sender_email = <lfs_constant>-low.
        lv_sender_name   = <lfs_constant>-low.
        CONCATENATE lst_sender_email '@wiley.com'(042) INTO lst_sender_email.
        TRANSLATE lv_sender_name TO UPPER CASE.
      ENDIF.
    ENDLOOP.
    IF lst_sender_email IS NOT INITIAL.
      IF s_mail[] IS NOT INITIAL .
        CONCATENATE 'E-Mail Address'(007)    gc_tab
                    'Identification No'(008) gc_tab
                    'Indicator'(009)         gc_tab
                    'Tittle'(010)            gc_tab
                    'First name'(011)        gc_tab
                    'Last name'(012)         gc_tab
                    'Street 2'(013)          gc_tab
                    'Street 3'(014)          gc_tab
                    'Street'(015)            gc_tab
                    'Street 4'(016)          gc_tab
                    'Street 5'(017)          gc_tab
                    'postal code'(018)       gc_tab
                    'City'(019)              gc_tab
                    'Region'(020)            gc_tab
                    'Country'(021)           gc_tab
                    'Telephone no'(022)      gc_tab
                    'BP Rel. Category'(023)  gc_tab
                    'BP Number'(024)         gc_tab
                    'Message type'(025)      gc_tab
                    'Message Number'(026)    gc_tab
                    'Message Text'(027)      gc_crlf   INTO lv_string.

        LOOP AT i_return INTO lst_return.
          CONCATENATE lv_string                       lst_return-e_mail      gc_tab   lst_return-id_number  gc_tab
                      lst_return-indicator     gc_tab lst_return-title       gc_tab   lst_return-firstname  gc_tab
                      lst_return-lastname      gc_tab lst_return-DEPT  gc_tab   lst_return-ORG gc_tab
                      lst_return-street        gc_tab lst_return-STREET_LINE2  gc_tab   lst_return-STREET_LINE3   gc_tab
                      lst_return-postl_cod1    gc_tab lst_return-city        gc_tab   lst_return-region     gc_tab
                      lst_return-country       gc_tab lst_return-telephone   gc_tab   lst_return-reltyp     gc_tab
                      lst_return-bp            gc_tab lst_return-msg_type    gc_tab   lst_return-msg_number gc_tab
                      lst_return-message       gc_crlf
                      INTO lv_string.
        ENDLOOP.

        CONCATENATE 'Hi Team,'(028) ' '  INTO lst_text SEPARATED BY space.
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.

        lst_text = '<br><br>'.
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.
        IF sy-batch EQ abap_true.
          SELECT SINGLE * FROM tbtcp INTO @DATA(lst_tbtcp) WHERE progname = @sy-repid.
          IF sy-subrc = 0.
            CLEAR lst_text.
            CONCATENATE 'Redwood Job Name:'(029)  lst_tbtcp-jobname INTO lst_text SEPARATED BY space.
            APPEND lst_text TO lt_text.
            CLEAR lst_text.
            CONCATENATE 'SAP Job Status:'(030)  lst_tbtcp-status INTO lst_text SEPARATED BY space.
            APPEND lst_text TO lt_text.
            CLEAR lst_text.
            CONCATENATE 'SAP Job Name:'(031)  lst_tbtcp-jobname INTO lst_text SEPARATED BY space.
            APPEND lst_text TO lt_text.
            CLEAR lst_text.
            CONCATENATE 'SAP System:'(032)  sy-sysid INTO lst_text SEPARATED BY space.
            APPEND lst_text TO lt_text.
            CLEAR lst_text.
            CONCATENATE 'SAP Client:'(033)  sy-mandt INTO lst_text SEPARATED BY space.
            APPEND lst_text TO lt_text.
            CLEAR lst_text.
          ENDIF.
        ENDIF.
        lst_text = 'Please find the AGU BP result file'(034).
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.

        lst_text = '<br><br>'.
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.

        lst_text = 'Thanks!'(035).
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.

        lst_text = '<br><br>'.
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.

        lst_text = lv_sender_name.
        APPEND lst_text TO lt_text.
        CLEAR:lst_text.
        LOOP AT s_mail INTO s_mail.
          TRY.
              lv_send_request = cl_bcs=>create_persistent( ).
              CLEAR:lv_sender.

              CALL METHOD cl_cam_address_bcs=>create_internet_address
                EXPORTING
                  i_address_string = lst_sender_email
                  i_address_name   = lv_sender_name
                RECEIVING
                  result           = lv_sender.

              CALL METHOD lv_send_request->set_sender
                EXPORTING
                  i_sender = lv_sender.

              lv_mailid = s_mail-low.
              CLEAR:lv_recipient,lt_bin_con..
              lv_recipient = cl_cam_address_bcs=>create_internet_address( lv_mailid ).
              CALL METHOD lv_send_request->add_recipient
                EXPORTING
                  i_recipient  = lv_recipient
                  i_express    = c_x
                  i_copy       = ' '
                  i_blind_copy = ' '.

              TRY.
                  cl_bcs_convert=>string_to_solix(
                    EXPORTING
                      iv_string   = lv_string
                      iv_codepage = '4103'
                      iv_add_bom  = c_x
                    IMPORTING
                      et_solix  = lt_bin_con
                      ev_size   = lv_size ).
                CATCH cx_bcs.
                  MESSAGE 'Error when transfering document contents'(037) TYPE c_e.
              ENDTRY.
              CONCATENATE sy-repid ':Interface BP Update AGU'(038) sy-datum sy-uzeit INTO lv_sub SEPARATED BY space.
              lv_document = cl_document_bcs=>create_document(
                i_type    = 'HTM'
                i_text    = lt_text
                i_subject =  lv_sub ) .

              lv_attnam = 'Interface AGU-BP Results'.

              lv_document->add_attachment(
                i_attachment_type    = 'xls'
                i_attachment_subject = lv_attnam
                i_attachment_size    = lv_size
                i_att_content_hex    = lt_bin_con ).

              lv_send_request->set_document( lv_document ).


              lv_all = lv_send_request->send( i_with_error_screen = abap_true ).

              COMMIT WORK.

              IF  lv_all IS INITIAL.
                MESSAGE 'document not sent'(039) TYPE c_s.
              ELSE.
                MESSAGE 'document sent sucessfully'(040) TYPE c_s.
              ENDIF.

            CATCH cx_bcs INTO bcs_exception.
              FREE : lv_document,lv_send_request,lv_recipient.
          ENDTRY.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
