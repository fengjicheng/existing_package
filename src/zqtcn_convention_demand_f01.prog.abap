*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_CONVENTION_DEMAND_E151
* PROGRAM DESCRIPTION: Custom report from to create conference purchase
* requisition based on the file received from JFDS
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-03-01
* OBJECT ID: E151
* TRANSPORT NUMBER(S): ED2K904707(W),ED2K904827(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K905904
* Reference No:  JIRA Defect# ERP-1947
* Developer: Monalisa Dutta
* Date:  2017-05-05
* Description: Conference  Po already exists for the issue to be displayed
* in output
*------------------------------------------------------------------- *

*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONVENTION_DEMAND_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*      Populate constant table fields
*----------------------------------------------------------------------*
*  <--  FP_I_CONSTANT     ZCACONSTANT internal table
*----------------------------------------------------------------------*
FORM f_get_constants CHANGING fp_i_constant TYPE tt_constant.
  CONSTANTS:  lc_devid  TYPE zdevid VALUE 'E151'.          " Development ID

  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = lc_devid.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DOC_TYPE
*&---------------------------------------------------------------------*
*      Subroutine to validate purchasing document type
*----------------------------------------------------------------------*
*      -->FP_S_DOC_I[]  Select Option for purchasing doc type
*----------------------------------------------------------------------*
FORM f_validate_doc_type  USING  fp_s_doc_i TYPE mmpur_t_bsart.

  IF fp_s_doc_i IS NOT INITIAL.
*  Validation of purchasing document type
    SELECT bsart   "Purchasing document type
      FROM t161
      UP TO 1 ROWS
      INTO @DATA(lv_bsart)
      WHERE bsart IN @fp_s_doc_i.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE e092(zqtc_r2). "Invalid Purchasing Document
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ACC_ASGNMNT
*&---------------------------------------------------------------------*
*       Validation of Account Assignment
*----------------------------------------------------------------------*
*      -->FP_S_ACC_I[]  Select option for account assignment
*----------------------------------------------------------------------*
FORM f_validate_acc_asgnmnt  USING    fp_s_acc_i TYPE tt_knttp.

  IF fp_s_acc_i IS NOT INITIAL.
*  Validation of account assignment type
    SELECT knttp   "Account assignment
       FROM t163k
       INTO @DATA(lv_knttp)
       UP TO 1 ROWS
       WHERE knttp IN @fp_s_acc_i.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE e094(zqtc_r2). "invalid Account Assignment Type
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       Subroutine to get file from presentation server
*----------------------------------------------------------------------*
*      -->FP_SYST_CPROG  system field
*      -->FP_C_FIELD  field name
*      <--FP_P_FILE local file
*----------------------------------------------------------------------*
FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog "ABAP System Field: Calling Program
                                 fp_c_field    TYPE dynfnam    " Field name
                        CHANGING fp_p_file     TYPE localfile. " Local file for upload/download
  "Local file for upload/download

* To get the file from presentation server when radio button Presentation
* Server is selected
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_p_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_APPLICATION
*&---------------------------------------------------------------------*
*      Subroutine to get file from application
*----------------------------------------------------------------------*
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_application  CHANGING fp_p_file TYPE localfile.
*  To get the file from application server when radio button Application
*  Server is selected
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    MESSAGE e002(zqtc_r2). "File does not exist
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Soubroutine to populate the default values in select options
*----------------------------------------------------------------------*
*      <--FP_S_DOC_I  purchasing document type
*      <--FP_S_ACC_I  account assignment type
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_doc_i TYPE mmpur_t_bsart
                                   fp_s_acc_i TYPE tt_knttp.

*  Local constant declaration
  CONSTANTS: lc_doc_type  TYPE esart VALUE 'NB',
             lc_acc_assgn TYPE knttp VALUE 'P'.
* Purchasing Document Type
  APPEND INITIAL LINE TO fp_s_doc_i ASSIGNING FIELD-SYMBOL(<lst_doc_i>).
  <lst_doc_i>-sign   = c_sign_incld.               "Sign: (I)nclude
  <lst_doc_i>-option = c_opti_equal.               "Option: (EQ)ual
  <lst_doc_i>-low    = lc_doc_type.                "Document Type
  <lst_doc_i>-high   = space.

* Media Issue Status
  APPEND INITIAL LINE TO fp_s_acc_i ASSIGNING FIELD-SYMBOL(<lst_acc_i>).
  <lst_acc_i>-sign   = c_sign_incld.         "Sign: (I)nclude
  <lst_acc_i>-option = c_opti_equal.         "Option: (EQ)ual
  <lst_acc_i>-low    = lc_acc_assgn.            "media Issue Status P: current status
  <lst_acc_i>-high   = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       Subroutine to read file from presentation server
*----------------------------------------------------------------------*
*      -->FP_V_PS_FILE_PATH  File Path
*      <--FP_I_UPLOAD_FILE   file details
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server  USING    fp_p_file TYPE localfile
                                  CHANGING fp_i_upload_file TYPE tt_upload_file.

*   Local data declaration
  DATA:
    lst_upload_file TYPE ty_upload_file, " file data
    lv_file         TYPE localfile, "file path
    li_exceldata    TYPE STANDARD TABLE OF alsmex_tabline.

  lv_file = fp_p_file.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_file
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 500
      i_end_row               = 99999
    TABLES
      intern                  = li_exceldata
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc EQ 0.
    LOOP AT li_exceldata INTO DATA(lst_data_tab).
      IF ( cb_hdr IS NOT INITIAL
        AND lst_data_tab-row GE 2 )
        OR
        ( cb_hdr IS INITIAL AND lst_data_tab-row GE 1 ).
        CASE lst_data_tab-col.
          WHEN 1.
            lst_upload_file-matnr = lst_data_tab-value.
          WHEN 2.
            lst_upload_file-quantity = lst_data_tab-value.
          WHEN 3.
            lst_upload_file-requisitioner = lst_data_tab-value.
          WHEN 4.
            lst_upload_file-tracking_no = lst_data_tab-value.
          WHEN 5.
            lst_upload_file-text = lst_data_tab-value.
          WHEN OTHERS.
            "Do Nothing
        ENDCASE.
        AT END OF row.
          APPEND lst_upload_file TO fp_i_upload_file.
          CLEAR: lst_upload_file,lst_data_tab.
        ENDAT.
      ENDIF.
    ENDLOOP.

    DELETE fp_i_upload_file WHERE matnr IS INITIAL.
  ENDIF. " GUI_UPLOAD sy-subrc
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*      Subroutine to read file from application server
*----------------------------------------------------------------------*
*      -->FP_V_AS_FILE_PATH File Path application server
*      <--FP_I_UPLOAD_FILE  File upload internal table
*----------------------------------------------------------------------*
FORM f_read_file_frm_app_server  USING    fp_p_file TYPE localfile
                                 CHANGING fp_i_upload_file TYPE tt_upload_file.

*Local data declaration
  DATA:         lst_file    TYPE string, "file path
                lst_upload  TYPE ty_upload_file, "workarea for file
                lv_quantity TYPE char16, "Quantity
                lv_file     TYPE localfile, " Local file for upload/download
                lv_tabix    TYPE sy-tabix. "For table line count

  CLEAR lv_file.
  lv_file = fp_p_file.

  TRY.
*  Open dataset
      OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
      IF sy-subrc EQ 0.
        DO.
          lv_tabix = lv_tabix + 1.
*  Read Dataset
          READ DATASET lv_file INTO lst_file.
          IF sy-subrc NE 0.
            EXIT.
          ELSE. " ELSE -> IF sy-subrc NE 0
            CLEAR lst_upload.
            IF lv_tabix = 1
             AND cb_hdr IS NOT INITIAL.
              CONTINUE.
            ENDIF.
            SPLIT lst_file AT cl_abap_char_utilities=>horizontal_tab INTO lst_upload-matnr
                                     lv_quantity
                                     lst_upload-requisitioner
                                     lst_upload-tracking_no
                                     lst_upload-text.
            MOVE lv_quantity TO  lst_upload-quantity.
            APPEND lst_upload TO fp_i_upload_file.
            CLEAR  lst_upload.
          ENDIF.
        ENDDO. "open dataset
        CLOSE DATASET lv_file.

      ENDIF. " IF sy-subrc EQ 0
    CATCH cx_sy_file_open.
      MESSAGE i045(zqtc_r2).
      LEAVE LIST-PROCESSING.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       Subroutine to validate the file path
*----------------------------------------------------------------------*
*      -->FP_P_FILE  file path
*----------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile.
*  Local data declaration
  DATA: lv_file   TYPE string,      " File name
        lv_result TYPE abap_bool.   " flag

  CLEAR lv_file.
  lv_file = fp_p_file.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*  Error message : unable to check file 'E'
    MESSAGE e001(zqtc_r2). " Unable to check file
  ELSE. " ELSE -> IF sy-subrc <> 0
    IF lv_result EQ abap_false.
*   Error message :File does not exits 'E'
      MESSAGE e002(zqtc_r2). " 'File does not exits.
    ENDIF. " IF lv_result EQ abap_false
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_APPLICATION
*&---------------------------------------------------------------------*
*       Subroutine to validate application server file
*----------------------------------------------------------------------*
*      -->FP_P_FILE  File Path
*----------------------------------------------------------------------*
FORM f_validate_application  USING  fp_p_file TYPE localfile.
*  Local data declaration
  DATA:   lv_test TYPE string,           " Data block for original data
          lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
          l_len   TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables

  lv_file = fp_p_file.

  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
  IF sy-subrc EQ 0.
    READ DATASET lv_file INTO lv_test LENGTH l_len. " lst_str.
    IF sy-subrc EQ 0 AND lv_test IS NOT INITIAL AND l_len IS NOT INITIAL.
      CLOSE DATASET fp_p_file.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLOSE DATASET fp_p_file.
      MESSAGE e004(zqtc_r2).
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE e002(zqtc_r2). "File doesnot exist
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_PUCHASE_REQ
*&---------------------------------------------------------------------*
*       Subroutine to create purchase requisition
*----------------------------------------------------------------------*
*      -->FP_I_UPLOAD_FILE  Table for upload file
*      <--FP_I_OUTPUT Table for output display
*----------------------------------------------------------------------*
FORM f_create_puchase_req  USING    fp_i_upload_file TYPE tt_upload_file
                           CHANGING fp_i_output TYPE tt_output.
*  Local data declaration
  DATA: li_mvke    TYPE tt_mvke,
        li_matnr   TYPE tt_matnr,
        li_mara    TYPE tt_mara,
        li_records TYPE tt_records.

*  Fetch records from MVKE
  PERFORM f_get_mvke_data USING fp_i_upload_file
                          CHANGING li_mvke
                                   li_mara
                                   li_matnr.
*  Fetch records from MARA and EORD
  PERFORM f_get_mara_eord USING li_mvke
                          CHANGING li_records.

*  Create Purchase Requisition
  PERFORM f_create_pr USING li_records
                            li_mvke
                            li_mara
                            li_matnr
                            i_constant
                      CHANGING fp_i_output.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MVKE_DATA
*&---------------------------------------------------------------------*
*       Subroutine to fetch records from MVKE
*----------------------------------------------------------------------*
*      -->FP_I_UPLOAD_FILE Upload file table
*      <--FP_LI_MVKE  MVKE table
*----------------------------------------------------------------------*
FORM f_get_mvke_data  USING    fp_i_upload_file TYPE tt_upload_file
                      CHANGING fp_li_mvke TYPE tt_mvke
                               fp_li_mara TYPE tt_mara
                               fp_li_matnr TYPE tt_matnr.

* Local data declaration
  DATA: lst_mvke_prev TYPE ty_mvke, "Workarea for MVKE
        lv_matnr      TYPE matnr.

  IF fp_i_upload_file IS NOT INITIAL.
*  Copying the records in local internal table to sort and delete adjacent
*  for using it in for all entries
    DATA(li_upload_file) = fp_i_upload_file.
    SORT li_upload_file BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_upload_file COMPARING matnr.

*  Get records from MARA for validation purpose
    SELECT matnr, "material
           meins  "uom
      FROM mara
      INTO TABLE @fp_li_mara
      FOR ALL ENTRIES IN @li_upload_file
      WHERE matnr = @li_upload_file-matnr.
    IF sy-subrc EQ 0.
      SORT fp_li_mara BY matnr.
    ENDIF.

* Get records from MVKE
    SELECT matnr,  "material
           vkorg,  "sales org
           vtweg,  "distribution channel
           dwerk   "delivering plant
      INTO TABLE @fp_li_mvke
      FROM mvke
      FOR ALL ENTRIES IN @li_upload_file
      WHERE matnr = @li_upload_file-matnr
*      AND   dwerk <> @space.
      AND   dwerk <> @c_char_blank.
    IF sy-subrc EQ 0.
*    Copying contents to local temporary table
      DATA(li_mvke_tmp) = fp_li_mvke[].
      SORT li_mvke_tmp BY matnr dwerk.
      DELETE ADJACENT DUPLICATES FROM li_mvke_tmp COMPARING matnr dwerk.

*   To populate all the material where plant is not same or initial
      LOOP AT li_mvke_tmp INTO DATA(lst_mvke_tmp).
*     If duplicate material is not there
        IF lst_mvke_prev IS INITIAL
         OR lst_mvke_prev-matnr <> lst_mvke_tmp-matnr.
          CLEAR lst_mvke_prev.
          lst_mvke_prev = lst_mvke_tmp.
          CLEAR lst_mvke_tmp.
          CONTINUE.
*    If material is multiple and delivering plant is not same populate table
        ELSEIF lst_mvke_prev-matnr = lst_mvke_tmp-matnr
          AND ( lst_mvke_prev-dwerk <> lst_mvke_tmp-dwerk
           OR lst_mvke_prev-dwerk IS INITIAL ).
          lv_matnr = lst_mvke_tmp-matnr.
          APPEND lv_matnr TO fp_li_matnr.
          CLEAR lst_mvke_prev.
          lst_mvke_prev = lst_mvke_tmp.
          CLEAR: lst_mvke_tmp,lv_matnr.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA_EORD
*&---------------------------------------------------------------------*
*      Subroutine to get MARA & EORD data
*----------------------------------------------------------------------*
*  -->  FP_I_UPLOAD_FILE  Internal table with file data
*  <--  FP_LI_MARA_EORD Mara & Eord table
*----------------------------------------------------------------------*
FORM f_get_mara_eord USING    fp_li_mvke TYPE tt_mvke
                     CHANGING fp_li_records TYPE tt_records.

  IF fp_li_mvke IS NOT INITIAL.
*  Copying the records in local internal table to sort and delete adjacent
*  for using it in for all entries
    DATA(li_mvke_temp) = fp_li_mvke.
    SORT li_mvke_temp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_mvke_temp COMPARING matnr.
    SELECT m~matnr,
           m~werks AS plant,
           e~werks,
           e~lifnr,
           e~flifn,
           e~ekorg,
           e~autet,
           a~ebeln,
*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
           a~ebelp,
           a~loekz,
           a~werks AS po_werks,
*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
           a~knttp,
           b~bsart,
           c~maktx
       FROM marc AS m
       INNER JOIN makt AS c ON m~matnr = c~matnr
       LEFT OUTER JOIN ekpo AS a ON m~matnr = a~matnr
       LEFT OUTER JOIN ekko AS b ON a~ebeln = b~ebeln
       LEFT OUTER JOIN eord AS e ON m~matnr = e~matnr
       INTO TABLE @fp_li_records
       FOR ALL ENTRIES IN @li_mvke_temp
       WHERE m~matnr = @li_mvke_temp-matnr
       AND   c~spras = @sy-langu.
    IF sy-subrc EQ 0.
      SORT fp_li_records BY matnr.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_PR
*&---------------------------------------------------------------------*
*       Subroutine to create Purchase Requistion
*----------------------------------------------------------------------*
*      -->FP_LI_RECORDS  MARA EORD EKKO EKPO records
*      -->FP_LI_MVKE   MVKE internal table
*      -->FP_LI_MATNR  MATNR
*      <--FP_I_OUTPUT  OUTPUT table
*----------------------------------------------------------------------*
FORM f_create_pr  USING    fp_li_records TYPE tt_records
                           fp_li_mvke TYPE tt_mvke
                           fp_li_mara TYPE tt_mara
                           fp_li_matnr TYPE tt_matnr
                           fp_i_constant TYPE tt_constant
                  CHANGING fp_i_output TYPE tt_output.

* Local data declaration
  DATA: lst_header    TYPE bapimereqheader,
        lst_headerx   TYPE bapimereqheaderx,
        lv_testrun    TYPE bapiflag-bapiflag,
        lv_number     TYPE bapimereqheader-preq_no,
        lv_line_item  TYPE bnfpo,
        lv_pr_counter TYPE i,
        lv_max        TYPE i,
        li_return     TYPE bapiret2_t,
        li_item       TYPE ty_bapimereqitemimp,
        li_itemx      TYPE ty_bapimereqitemx,
        li_item_text  TYPE ty_bapimereqitemtext,
        lst_bapiret   TYPE bapiret2,
        lst_item      TYPE bapimereqitemimp,
        lst_itemx     TYPE bapimereqitemx,
        lst_output    TYPE ty_output,
        lst_itemtext  TYPE bapimereqitemtext.

* Local constant declaration
  CONSTANTS: lc_doc_type   TYPE rvari_vnam VALUE 'DOC_TYPE',
             lc_acc_assign TYPE rvari_vnam VALUE 'ACC_ASSIGN',
             lc_pur_group  TYPE rvari_vnam VALUE 'PUR_GROUP',
             lc_pur_org    TYPE rvari_vnam VALUE 'PUR_ORG',
             lc_storage    TYPE rvari_vnam VALUE 'STORAGE',
             lc_textid     TYPE rvari_vnam VALUE 'TEXTID',
             lc_autet      TYPE autet VALUE '1'.

  IF fp_li_mvke IS NOT INITIAL.
*   Copying records in local table to remove duplicate entries
    DATA(li_mvke) = fp_li_mvke[].
    SORT li_mvke BY matnr. "Sort is done based on MATNR since this key is used to read records from this table
    DELETE ADJACENT DUPLICATES FROM li_mvke COMPARING matnr.
  ENDIF.

*      Populate header
  READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = lc_doc_type BINARY SEARCH.
  IF sy-subrc EQ 0.
*    Purchasing Document Type
    lst_header-pr_type = lst_constant-low.
  ENDIF.

*    Auto Source
  lst_header-auto_source = abap_true.

*  Populate Change structure
*  Purchase document type
  lst_headerx-pr_type = abap_true.
*  Auto Source
  lst_headerx-auto_source = abap_true.

*If Test Mode is checked in selection screen then test run will be X
  IF cb_tst IS NOT INITIAL.
    lv_testrun = abap_true.
  ENDIF.

  DATA(li_marc) = fp_li_records[].
  SORT li_marc BY matnr plant.

  DATA(li_records) = fp_li_records[].
  SORT li_records BY matnr werks flifn.

  DATA(li_records_temp) = fp_li_records[].
  SORT li_records_temp BY matnr werks autet.

*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
  DATA(li_po_records) = fp_li_records[].
  DELETE li_po_records WHERE loekz NE space.
  SORT li_po_records BY ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM li_po_records COMPARING ebeln ebelp.
  SORT li_po_records BY knttp bsart.
  DELETE li_po_records WHERE knttp NOT IN s_acc_i
                           OR bsart NOT IN s_doc_i.
  SORT li_po_records BY matnr werks.
*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>

* Populate Item Table
  DESCRIBE TABLE i_upload_file LINES lv_max.
  LOOP AT i_upload_file INTO DATA(lst_upload_file).
    READ TABLE fp_li_mara  INTO DATA(lst_mara) WITH KEY matnr = lst_upload_file-matnr
                                                        BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE e160(zqtc_r2) WITH lst_upload_file-matnr INTO lst_bapiret-message.
      "Material & not found in MARA
      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = sy
        CHANGING
          bapiret2 = lst_bapiret.
      lst_output-material = lst_upload_file-matnr.
      lst_output-type = lst_bapiret-type.
      lst_output-id = lst_bapiret-id.
      lst_output-number = lst_bapiret-number.
      lst_output-message = lst_bapiret-message.
      lst_output-status = c_status_err.
      APPEND lst_output TO fp_i_output.
      CLEAR: lst_output,lst_upload_file,lst_bapiret.
      lv_max = lv_max - 1.
      IF lv_max <> lv_pr_counter.
        CONTINUE.
      ENDIF.
    ELSE.
*     Material
      lst_item-material = lst_mara-matnr.

*      Unit of measure
      lst_item-unit = lst_mara-meins.

      IF lst_upload_file-quantity IS NOT INITIAL.
*    Quantity
        lst_item-quantity = lst_upload_file-quantity.
      ELSE.
        MESSAGE e161(zqtc_r2) WITH lst_item-material INTO lst_bapiret-message.
        "Quantity is blank in file
        CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
          EXPORTING
            syst     = sy
          CHANGING
            bapiret2 = lst_bapiret.
        lst_output-material = lst_upload_file-matnr.
        lst_output-type = lst_bapiret-type.
        lst_output-id = lst_bapiret-id.
        lst_output-number = lst_bapiret-number.
        lst_output-message = lst_bapiret-message.
        lst_output-status = c_status_err.
        APPEND lst_output TO fp_i_output.
        CLEAR: lst_output,lst_upload_file,lst_bapiret.
        lv_max = lv_max - 1.
        IF lv_max <> lv_pr_counter.
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lv_max <> lv_pr_counter.
      READ TABLE li_mvke INTO DATA(lst_mvke) WITH KEY matnr = lst_upload_file-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE e153(zqtc_r2) WITH lst_upload_file-matnr INTO lst_bapiret-message.
        "Delivering plant is blank for the material &
        CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
          EXPORTING
            syst     = sy
          CHANGING
            bapiret2 = lst_bapiret.
        lst_output-material = lst_upload_file-matnr.
        lst_output-type = lst_bapiret-type.
        lst_output-id = lst_bapiret-id.
        lst_output-number = lst_bapiret-number.
        lst_output-message = lst_bapiret-message.
        lst_output-status = c_status_err.
        APPEND lst_output TO fp_i_output.
        CLEAR: lst_output,lst_upload_file,lst_item,lst_mvke,lst_bapiret.
        lv_max = lv_max - 1.
        IF lv_max <> lv_pr_counter.
          CONTINUE.
        ENDIF.
      ELSE.
        READ TABLE fp_li_matnr WITH KEY matnr = lst_mvke-matnr TRANSPORTING NO FIELDS.
        IF sy-subrc EQ 0.
          MESSAGE e149(zqtc_r2) WITH lst_mvke-matnr INTO lst_bapiret-message.
          "Delivering plant not found &
          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = sy
            CHANGING
              bapiret2 = lst_bapiret.
          lst_output-material = lst_upload_file-matnr.
          lst_output-type = lst_bapiret-type.
          lst_output-id = lst_bapiret-id.
          lst_output-number = lst_bapiret-number.
          lst_output-message = lst_bapiret-message.
          lst_output-status = c_status_err.
          APPEND lst_output TO fp_i_output.
          CLEAR: lst_output,lst_upload_file,lst_item,lst_mvke,lst_bapiret.
          lv_max = lv_max - 1.
          IF lv_max <> lv_pr_counter.
            CONTINUE.
          ENDIF.
        ELSE.
          READ TABLE li_marc INTO DATA(lst_marc) WITH KEY matnr = lst_mvke-matnr
                                                          plant = lst_mvke-dwerk
                                                          BINARY SEARCH.
          IF sy-subrc NE 0.
            MESSAGE e158(zqtc_r2) WITH lst_marc-matnr lst_mvke-dwerk INTO lst_bapiret-message.
            " Material not assigned to plant
            CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
              EXPORTING
                syst     = sy
              CHANGING
                bapiret2 = lst_bapiret.
            lst_output-material = lst_upload_file-matnr.
            lst_output-type = lst_bapiret-type.
            lst_output-id = lst_bapiret-id.
            lst_output-number = lst_bapiret-number.
            lst_output-message = lst_bapiret-message.
            lst_output-status = c_status_err.
            APPEND lst_output TO fp_i_output.
            CLEAR: lst_output,lst_upload_file,lst_item,lst_mvke,lst_bapiret.
            lv_max = lv_max - 1.
            IF lv_max <> lv_pr_counter.
              CONTINUE.
            ENDIF.
          ELSE.
            lv_line_item = lv_line_item + 10.

* Line item
            lst_item-preq_item = lv_line_item.

* Purchasing Group
            CLEAR lst_constant.
            READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_pur_group BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_item-pur_group = lst_constant-low.
            ENDIF.

* Account Assignmnet
            CLEAR lst_constant.
            READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_acc_assign BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_item-acctasscat = lst_constant-low.
            ENDIF.

*  Requisitioner name
            lst_item-preq_name = lst_upload_file-requisitioner.

*    Tracking Number
            lst_item-trackingno = lst_upload_file-tracking_no.

*        Plant
            lst_item-plant = lst_mvke-dwerk.

*      Storage
            CLEAR lst_constant.
            READ TABLE fp_i_constant INTO lst_constant WITH KEY param1 = lc_storage BINARY SEARCH.
            IF sy-subrc EQ 0.
*        Storage
              lst_item-store_loc = lst_constant-low.
            ENDIF.

*       Purchasing Group
            CLEAR lst_constant.
            READ TABLE fp_i_constant INTO lst_constant WITH KEY param1 = lc_pur_group BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_item-pur_group = lst_constant-low.
            ENDIF.

            READ TABLE fp_li_records INTO DATA(lst_records) WITH KEY matnr = lst_mvke-matnr
                                                                     BINARY SEARCH.
            IF sy-subrc EQ 0.

*    Material Short text
              lst_item-short_text = lst_records-maktx.
            ENDIF."read li_records

*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
            READ TABLE li_po_records INTO DATA(lst_po_records) WITH KEY matnr = lst_mvke-matnr
                                                                        po_werks = lst_mvke-dwerk
                                                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
*          Conference PO already exists for issue
*              IF lst_po_records-bsart IN s_doc_i   "commented by modutta to be removed after FUT
*                AND lst_po_records-knttp IN s_acc_i.
              lst_item-closed = abap_true.
              lst_itemx-closed = abap_true.
              MESSAGE w187(zqtc_r2) WITH lst_po_records-matnr lst_po_records-po_werks INTO lst_bapiret-message.
              " PO already exists for the material plant combination
              CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
                EXPORTING
                  syst     = sy
                CHANGING
                  bapiret2 = lst_bapiret.
              lst_output-material = lst_upload_file-matnr.
              lst_output-purchase_order = lst_po_records-ebeln.
              lst_output-line_item = lst_po_records-ebelp.
              lst_output-status = c_status_war.
              lst_output-type = lst_bapiret-type.
              lst_output-id = lst_bapiret-id.
              lst_output-number = lst_bapiret-number.
              lst_output-message = lst_bapiret-message.
              APPEND lst_output TO fp_i_output.
              CLEAR: lst_output,lst_bapiret.
            ENDIF. "read li_po_records
*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>

            CLEAR lst_constant.
            READ TABLE fp_i_constant INTO lst_constant WITH KEY param1 = lc_pur_org BINARY SEARCH.
            IF sy-subrc EQ 0.
*        Purchasing Organization
              lst_item-purch_org = lst_constant-low.

              CLEAR lst_records.
              READ TABLE li_records INTO lst_records WITH KEY matnr = lst_mvke-matnr
                                                              werks = lst_mvke-dwerk
                                                              flifn = abap_true
                                                              BINARY SEARCH.
              IF sy-subrc EQ 0.
*        Supply vendor
                IF lst_records-ekorg = lst_item-purch_org.
                  lst_item-supp_vendor = lst_records-lifnr.
                  lst_itemx-supp_vendor = abap_true.
                ENDIF. "if lst_records
              ENDIF.

              CLEAR lst_records.
              READ TABLE li_records_temp INTO lst_records WITH KEY matnr = lst_mvke-matnr
                                                                   werks = lst_mvke-dwerk
                                                                   autet = lc_autet
                                                                   BINARY SEARCH.
              IF sy-subrc EQ 0.
*        Fixed vendor
                IF lst_records-ekorg = lst_item-purch_org.
                  lst_item-fixed_vend = lst_records-lifnr.
                  lst_itemx-fixed_vend = abap_true.
                ENDIF.
              ENDIF. "werks = lst_mvke-dwerk
            ENDIF. "read i_constant
          ENDIF.

          IF lst_item IS NOT INITIAL.
            APPEND lst_item TO li_item.

            CLEAR:lst_records,lst_mvke,lst_marc,lst_po_records.

*    Populate Change Parameter for Enjoy trasaction
            lst_itemx-preq_item = lst_item-preq_item.
            lst_itemx-preq_itemx = abap_true.
            lst_itemx-pur_group = abap_true.
            lst_itemx-preq_name = abap_true.
            lst_itemx-short_text = abap_true.
            lst_itemx-material = abap_true.
            lst_itemx-plant = abap_true.
            lst_itemx-store_loc = abap_true.
            lst_itemx-trackingno = abap_true.
            lst_itemx-quantity = abap_true.
            lst_itemx-unit = abap_true.
            lst_itemx-acctasscat = abap_true.
            lst_itemx-purch_org = abap_true.
            APPEND lst_itemx TO li_itemx.
            CLEAR lst_itemx.

*   Populate Item text table
            lst_itemtext-preq_item = lst_item-preq_item.
            CLEAR lst_constant.
            READ TABLE fp_i_constant INTO lst_constant WITH KEY param1 = lc_textid BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_itemtext-text_id = lst_constant-low.
            ENDIF.
            lst_itemtext-text_line = lst_upload_file-text.
            APPEND lst_itemtext TO li_item_text.
            CLEAR: lst_item,lst_itemtext,lst_upload_file.
          ENDIF.
        ENDIF. "li_matnr read
      ENDIF. "read li_mvke
*    IF lv_max <> lv_pr_counter.
      lv_pr_counter = lv_pr_counter + 1.
    ENDIF.

    IF lv_max LE 990.
      IF lv_max EQ lv_pr_counter.
*        Call BAPI to create purchase requisition
        CALL FUNCTION 'BAPI_PR_CREATE'
          EXPORTING
            prheader   = lst_header
            prheaderx  = lst_headerx
            testrun    = lv_testrun
          IMPORTING
            number     = lv_number
          TABLES
            return     = li_return
            pritem     = li_item
            pritemx    = li_itemx
            pritemtext = li_item_text.

        IF lv_number IS NOT INITIAL.
          IF cb_tst IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
          ENDIF.
          LOOP AT li_return INTO DATA(lst_return).
            CASE lst_return-type.
              WHEN c_success. "when success
                lst_output-material = lst_upload_file-matnr.
                lst_output-purchase_req = lv_number.
                lst_output-status = c_status_suc.
                lst_output-type = lst_return-type.
                lst_output-id = lst_return-id.
                lst_output-number = lst_return-number.
                lst_output-message = lst_return-message.
                APPEND lst_output TO fp_i_output.
                CLEAR: lst_output.
              WHEN c_error. "when error
                lst_output-material = lst_upload_file-matnr.
                lst_output-status = c_status_err.
                lst_output-type = lst_return-type.
                lst_output-id = lst_return-id.
                lst_output-number = lst_return-number.
                lst_output-message = lst_return-message.
                APPEND lst_output TO fp_i_output.
                CLEAR: lst_output.
              WHEN OTHERS.
                "Do Nothing
            ENDCASE.
            CLEAR lst_return.
          ENDLOOP.
        ENDIF.
        CLEAR:li_item,li_itemx,li_return,li_item_text,lst_records,lst_mvke,lst_item,lst_constant,lst_itemx,lv_number,lv_line_item.
      ENDIF.
    ELSE.
      IF lv_pr_counter EQ 990.
*         call bapi to create purchase requisition
        CALL FUNCTION 'BAPI_PR_CREATE'
          EXPORTING
            prheader   = lst_header
            prheaderx  = lst_headerx
            testrun    = lv_testrun
          IMPORTING
            number     = lv_number
          TABLES
            return     = li_return
            pritem     = li_item
            pritemx    = li_itemx
            pritemtext = li_item_text.

        IF lv_number IS NOT INITIAL.
          IF cb_tst IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
          ENDIF.
          CLEAR lst_return.
          LOOP AT li_return INTO lst_return.
            CASE lst_return-type.
              WHEN c_success.
                lst_output-material = lst_upload_file-matnr.
                lst_output-purchase_req = lv_number.
                lst_output-status = c_status_suc.
                lst_output-type = lst_return-type.
                lst_output-id = lst_return-id.
                lst_output-number = lst_return-number.
                lst_output-message = lst_return-message.
                APPEND lst_output TO fp_i_output.
                CLEAR lst_output.
              WHEN c_error.
                lst_output-material = lst_upload_file-matnr.
                lst_output-status = c_status_err.
                lst_output-type = lst_return-type.
                lst_output-id = lst_return-id.
                lst_output-number = lst_return-number.
                lst_output-message = lst_return-message.
                APPEND lst_output TO fp_i_output.
                CLEAR lst_output.
              WHEN OTHERS.
                "Do Nothing
            ENDCASE.
            CLEAR lst_return.
          ENDLOOP.
        ENDIF.
        lv_max = lv_max - 990.
        CLEAR: lv_pr_counter,li_item,li_itemx,li_return,li_item_text,lv_line_item.
      ENDIF.
      CLEAR:lst_records,lst_mvke,lst_item,lst_constant,lst_itemx,lv_number.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*      Display ALV
*----------------------------------------------------------------------*
*      <--FP_I_OUTPUT  Output table
*----------------------------------------------------------------------*
FORM f_display_output  CHANGING  fp_i_output TYPE tt_output.
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lst_layout       TYPE slis_layout_alv,
        li_fieldcatalog  TYPE slis_t_fieldcat_alv.

* Fill traffic lights field name in the ALV layout
  lst_layout-lights_fieldname = 'STATUS'.
  lst_layout-colwidth_optimize = abap_true.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'PURCHASE_REQ'.
  lst_fieldcatalog-seltext_m   = 'Purchase Requsition No'(t01).
  lst_fieldcatalog-col_pos     = 0.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'PURCHASE_ORDER'.
  lst_fieldcatalog-seltext_m   = 'Purchase Order No'(t07).
  lst_fieldcatalog-col_pos     = 1.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'LINE_ITEM'.
  lst_fieldcatalog-seltext_m   = 'PO Line Item'(t06).
  lst_fieldcatalog-col_pos     = 2.
  lst_fieldcatalog-outputlen = 14.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'MATERIAL'.
  lst_fieldcatalog-seltext_m   = 'Material'(t08).
  lst_fieldcatalog-col_pos     = 3.
  lst_fieldcatalog-outputlen = 14.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>>

  lst_fieldcatalog-fieldname   = 'TYPE'.
  lst_fieldcatalog-seltext_m   = 'Type'(t02).
  lst_fieldcatalog-col_pos     = 5.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'ID'.
  lst_fieldcatalog-seltext_m   = 'Id'(t03).
  lst_fieldcatalog-col_pos     = 6.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'NUMBER'.
  lst_fieldcatalog-seltext_m   = 'Number'(t04).
  lst_fieldcatalog-col_pos     = 7.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_m   = 'Message'(t05).
  lst_fieldcatalog-col_pos     = 8.
  lst_fieldcatalog-outputlen = 100.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.
*
*  lst_fieldcatalog-fieldname   = 'STATUS'.
*  lst_fieldcatalog-seltext_m   = 'Status'(t06).
*  lst_fieldcatalog-col_pos     = 7.
*  APPEND lst_fieldcatalog TO li_fieldcatalog.
*  CLEAR  lst_fieldcatalog.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = li_fieldcatalog
    TABLES
      t_outtab           = fp_i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR li_fieldcatalog[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_TO_APP_SERVER
*&---------------------------------------------------------------------*
*       Subroutine to write the file in app server
*----------------------------------------------------------------------*
*      -->FP_I_OUTPUT  Output File
*----------------------------------------------------------------------*
FORM f_write_to_app_server  USING    fp_i_output TYPE tt_output
                                     fp_p_file   TYPE localfile.

  DATA :   lst_output   TYPE ty_output, "structure for output
           lv_file      TYPE string,
           lv_extension TYPE char4,
           lv_file_path TYPE localfile,
           lst_text     TYPE string.

  CONSTANTS: lc_dot        TYPE char1 VALUE '.',
             lc_error_text TYPE char10 VALUE '_ERRORLOG_',
             lc_underscore TYPE char1 VALUE '_'.

* Split file name from file path
  SPLIT fp_p_file AT lc_dot INTO lv_file_path lv_extension.

*  Concatenate file path +filename+extension
  CONCATENATE lv_file_path lc_error_text sy-datum lc_underscore sy-uzeit lc_dot lv_extension  INTO lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

*--- Display error messages if any.
  IF sy-subrc NE 0.
    MESSAGE e045(zqtc_r2).
    RETURN.
  ELSE.

*---Data is downloaded to the application server file path

    LOOP AT fp_i_output INTO lst_output.
      CONCATENATE lst_output-purchase_req lst_output-type lst_output-id lst_output-number lst_output-message
      INTO lst_text SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lst_text TO lv_file.
      CLEAR lst_output.
    ENDLOOP.
  ENDIF.
*--Close the Application server file (Mandatory).

  CLOSE DATASET lv_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_TO_PRES_SERVER
*&---------------------------------------------------------------------*
*       Subroutine to save file in presentation server
*----------------------------------------------------------------------*
*      -->FP_I_OUTPUT  Output table
*      -->FP_P_FILE  file path
*----------------------------------------------------------------------*
FORM f_write_to_pres_server  USING fp_i_output TYPE tt_output
                                   fp_p_file TYPE localfile.

  TYPES: BEGIN OF lty_final,
           type    TYPE char4, "type
           id      TYPE edi_stamid, "id
           number  TYPE char6, "number
           message TYPE bapi_msg, "message
           pur_req TYPE char30, "purchase requisition
         END OF lty_final.

  DATA :    lv_file      TYPE localfile,
            lv_extension TYPE char4,
            lv_file_path TYPE localfile,
            li_final     TYPE STANDARD TABLE OF lty_final,
            lst_final    TYPE lty_final.

  CONSTANTS: lc_dot        TYPE char1 VALUE '.',
             lc_seperator  TYPE char1 VALUE '#',
             lc_error_text TYPE char10 VALUE '_ERRORLOG_',
             lc_underscore TYPE char1 VALUE '_',
             lc_type       TYPE char4 VALUE 'TYPE',
             lc_id         TYPE char2 VALUE 'ID',
             lc_number     TYPE char6 VALUE 'NUMBER',
             lc_message    TYPE char7 VALUE 'MESSAGE',
             lc_pur_req    TYPE char30 VALUE 'PURCHASE REQUISTITION NUMBER'.

* Appending header in the table for downloading
  lst_final-type = lc_type.
  lst_final-id = lc_id.
  lst_final-number = lc_number.
  lst_final-message = lc_message.
  lst_final-pur_req = lc_pur_req.
  APPEND lst_final TO li_final.
  CLEAR lst_final.

* Populate internal table to be downloaded in excel
  LOOP AT fp_i_output INTO DATA(lst_output).
    lst_final-type = lst_output-type.
    lst_final-id = lst_output-id.
    lst_final-number = lst_output-number.
    lst_final-message = lst_output-message.
    lst_final-pur_req = lst_output-purchase_req.
    APPEND lst_final TO li_final.
    CLEAR: lst_final,lst_output.
  ENDLOOP.

* Split file name from file path
  SPLIT fp_p_file AT lc_dot INTO lv_file_path lv_extension.

*  Concatenate file path +filename+extension
  CONCATENATE lv_file_path lc_error_text sy-datum lc_underscore sy-uzeit lc_dot lv_extension INTO lv_file.

  CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
    EXPORTING
      i_field_seperator = lc_seperator
      i_line_header     = abap_true
      i_filename        = lv_file
    TABLES
      i_tab_sap_data    = li_final
    EXCEPTIONS
      conversion_failed = 1
      OTHERS            = 2.
  IF sy-subrc EQ 0.
    CLEAR: li_final.
  ENDIF.

ENDFORM.
