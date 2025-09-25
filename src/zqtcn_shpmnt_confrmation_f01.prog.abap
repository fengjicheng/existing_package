*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCN_SHPMNT_CONFRMATION_F01
* PROGRAM DESCRIPTION: Include for declaring subroutines
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2016-12-23
* OBJECT ID: I0256
* TRANSPORT NUMBER(S):ED2K903891(W)/ED2K903977(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K906177
* Reference No:  CR# 456
* Developer: Monalisa Dutta
* Date:  2017-05-19
* Description: To comment the code related to Goods Issue as we will be
*              doing only GR in this wricef.
*              To ensure multiple files are selected directly from the
*              folder instead of a single file.
*------------------------------------------------------------------- *
* Revision No: ED2K910605
* Reference No: ERP-6331
* Developer: Pavan Bandlapalli(PBANDLAPAL)
* Date:  2018-01-30
* Description: File Name is being updated in the header segment. Initially it
*              was showing as wrong file name.
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Nageswara (NPOLINA)
* Date:  2020-01-06
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED1K912595
* Reference No:  PRB0047015
* Developer: Nikhilesh Palla (NPALLA)
* Date:  2021-01-15
* Description: Capture only Errors in AL11 file
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SHPMNT_CONFRMATION_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
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
FORM f_f4_application  CHANGING fp_p_file TYPE localfile.
*  To get the file from application server when radio button Application
*  Server is selected
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile = fp_p_file.
*    EXCEPTIONS
*      canceled_by_user = 1
*      OTHERS           = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile.
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
**  Local data declaration
  DATA: lv_file   TYPE string,      " File name
        lv_result TYPE abap_bool.   " flag

  CLEAR lv_file.
  lv_file = fp_p_file.

* To check if directory exists or not
  CALL METHOD cl_gui_frontend_services=>directory_exist
    EXPORTING
      directory            = lv_file
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
      MESSAGE e197(zqtc_r2). " 'File does not exits.
    ENDIF. " IF lv_result EQ abap_false
  ENDIF.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

*  CALL METHOD cl_gui_frontend_services=>file_exist
*    EXPORTING
*      file                 = lv_file
*    RECEIVING
*      result               = lv_result
*    EXCEPTIONS
*      cntl_error           = 1
*      error_no_gui         = 2
*      wrong_parameter      = 3
*      not_supported_by_gui = 4
*      OTHERS               = 5.
*  IF sy-subrc <> 0.
**  Error message : unable to check file 'E'
*    MESSAGE e001(zqtc_r2). " Unable to check file
*  ELSE. " ELSE -> IF sy-subrc <> 0
*    IF lv_result EQ abap_false.
**   Error message :File does not exits 'E'
*      MESSAGE e002(zqtc_r2). " 'File does not exits.
*    ENDIF. " IF lv_result EQ abap_false
*  ENDIF. " IF sy-subrc <> 0
*
ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  F_VALIDATE_APPLICATION
**&---------------------------------------------------------------------*
FORM f_validate_application  USING fp_p_file TYPE localfile.
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
*Local data declaration
  DATA: lv_dir TYPE btctext80.

  lv_dir = fp_p_file.

  CALL FUNCTION 'PFL_CHECK_DIRECTORY'
    EXPORTING
      directory                   = lv_dir
*     WRITE_CHECK                 = ' '
*     FILNAME                     = ' '
*     DIRECTORY_LONG              =
    EXCEPTIONS
      pfl_dir_not_exist           = 1
      pfl_permission_denied       = 2
      pfl_cant_build_dataset_name = 3
      pfl_file_not_exist          = 4
      pfl_authorization_missing   = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
*   Error message :File does not exits 'E'
    MESSAGE e197(zqtc_r2). " 'File does not exits.
  ENDIF.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

**  Local data declaration
*  DATA:    lv_test TYPE string,           " Data block for original data
*           lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
*           l_len   TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables
*
**  Local constant declaration
*  CONSTANTS: lc_11 TYPE char2 VALUE '11', "dataset read error
*             lc_12 TYPE char2 VALUE '12'. "other error
*
*  lv_file = fp_p_file.
*  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
*  IF sy-subrc EQ 0.
*    CATCH SYSTEM-EXCEPTIONS dataset_read_error = lc_11
*                            OTHERS = lc_12.
*      READ DATASET lv_file INTO lv_test LENGTH l_len. " lst_str.
*      IF sy-subrc EQ 0.
*        CLOSE DATASET fp_p_file.
*      ELSE. " ELSE -> IF sy-subrc EQ 0
*        CLOSE DATASET fp_p_file.
*        MESSAGE e004.
*      ENDIF. " IF sy-subrc EQ 0
*    ENDCATCH.
*  ELSE. " ELSE -> IF sy-subrc EQ 0
*    MESSAGE e002. "File doesnot exist
*  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
FORM f_read_file_frm_pres_server  USING    fp_p_file TYPE localfile
                                  CHANGING fp_i_upload_file TYPE tt_upload_file.

*Local type declaration
  TYPES: BEGIN OF lty_data_tab,
           value TYPE string,
         END OF lty_data_tab,

         tt_dir TYPE STANDARD TABLE OF sdokpath INITIAL SIZE 0.

*   Local data declaration
  DATA:
    lst_upload_file TYPE ty_upload_file,
    li_data_tab     TYPE STANDARD TABLE OF lty_data_tab INITIAL SIZE 0,
    lv_file         TYPE string,
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
    lv_dir          TYPE sdok_chtrd,
    li_dir_tab      TYPE tt_dir,
    li_file_tab     TYPE tt_dir.

*   Local constant declaration
  CONSTANTS: lc_csv1 TYPE char4 VALUE '.CSV',
             lc_csv2 TYPE char4 VALUE '.csv'.

*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
*  lv_file = fp_p_file. "commented by MODUTTA
  lv_dir  = fp_p_file+0(128). "Added by MODUTTA on 19/05/2017 for CR# 456

*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
  CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
    EXPORTING
      directory  = lv_dir
      filter     = '*.*'
*   IMPORTING
*     FILE_COUNT =
*     DIR_COUNT  =
    TABLES
      file_table = li_file_tab
      dir_table  = li_dir_tab
    EXCEPTIONS
      cntl_error = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
    RAISE exception.
  ENDIF.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

  LOOP AT li_file_tab INTO DATA(lst_file_tab).
    lv_file = lst_file_tab-pathname.
    IF lv_file CS lc_csv1
      OR lv_file CS lc_csv2.

      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          filename                = lv_file
        TABLES
          data_tab                = li_data_tab
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          OTHERS                  = 17.
      IF sy-subrc = 0.
        LOOP AT li_data_tab INTO DATA(lst_data_tab).
          SPLIT lst_data_tab-value AT ',' INTO lst_upload_file-journal
                                     lst_upload_file-pub_set
                                     lst_upload_file-matnr
                                     lst_upload_file-lodgement_date
                                     lst_upload_file-issue_vol
                                     lst_upload_file-issue_to_vol
                                     lst_upload_file-issue_num
                                     lst_upload_file-issue_to_num
                                     lst_upload_file-issue_part
                                     lst_upload_file-issue_to_part.
* BOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
          lst_upload_file-file_name = lst_file_tab-pathname.
* EOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
          IF lst_upload_file-matnr IS NOT INITIAL.
*   Conversion of material to SAP format
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
              EXPORTING
                input        = lst_upload_file-matnr
              IMPORTING
                output       = lst_upload_file-matnr
              EXCEPTIONS
                length_error = 1
                OTHERS       = 2.
            IF sy-subrc = 0.
              APPEND lst_upload_file TO fp_i_upload_file.
            ENDIF. " IF sy-subrc <> 0
          ENDIF.
          CLEAR:  lst_upload_file.
        ENDLOOP. " LOOP AT li_data_tab INTO lst_data_tab
        CLEAR:st_filenames.
        st_filenames-data = lv_file.
        APPEND st_filenames TO i_filenames.
        CLEAR:st_filenames.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
FORM f_read_file_frm_app_server  USING fp_p_file TYPE localfile " Local file for upload/download
                                 CHANGING fp_i_upload_file  TYPE tt_upload_file.
*  Local constant declaration
  CONSTANTS: lc_tab  TYPE c VALUE ',', "Comma
             lc_csv1 TYPE char4 VALUE '.CSV',
             lc_csv2 TYPE char4 VALUE '.csv'.

*Local data declaration
  DATA: lst_file       TYPE string,
        lst_upload     TYPE ty_upload_file,
*                lv_file    TYPE localfile. " Local file for upload/download
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
        lv_file        TYPE string,
        lv_path        TYPE pfeflnamel, "Directory
        lst_bapiret    TYPE bapiret2,  "structure for BAPIRET2
        lst_output_det TYPE ty_output_det, "structure for output file
        li_file_tab    TYPE STANDARD TABLE OF salfldir INITIAL SIZE 0. "Directory of Files.
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

  CLEAR lv_path.
  lv_path = fp_p_file.
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
*** Calling FM to get all the file names
  CALL FUNCTION 'RZL_READ_DIR_LOCAL'
    EXPORTING
      name               = lv_path
    TABLES
      file_tbl           = li_file_tab
    EXCEPTIONS
      argument_error     = 1
      not_found          = 2
      no_admin_authority = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE i075(zqtc_r2). " Please enter a valid file name
    LEAVE LIST-PROCESSING.
  ENDIF. " IF lv_dir IS NOT INITIAL
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

  LOOP AT li_file_tab INTO DATA(lst_file_tab).
    CLEAR lv_file.
    CONCATENATE fp_p_file '/' lst_file_tab-name INTO lv_file.
    IF lv_file CS lc_csv1
      OR lv_file CS lc_csv2.
      TRY.
*  Open dataset
          OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
          IF sy-subrc EQ 0.
            DO.
              CLEAR lst_file.
*  Read Dataset
              READ DATASET lv_file INTO lst_file.
              IF sy-subrc NE 0.
                EXIT.
              ELSE. " ELSE -> IF sy-subrc NE 0
                CLEAR lst_upload.
                SPLIT lst_file AT lc_tab INTO lst_upload-journal
                                         lst_upload-pub_set
                                         lst_upload-matnr
                                         lst_upload-lodgement_date
                                         lst_upload-issue_vol
                                         lst_upload-issue_to_vol
                                         lst_upload-issue_num
                                         lst_upload-issue_to_num
                                         lst_upload-issue_part
                                         lst_upload-issue_to_part.
* BOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
                lst_upload-file_name = lst_file_tab-name.
* EOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
                IF lst_upload-matnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                    EXPORTING
                      input        = lst_upload-matnr
                    IMPORTING
                      output       = lst_upload-matnr
                    EXCEPTIONS
                      length_error = 1
                      OTHERS       = 2.
                  IF sy-subrc = 0.
                    APPEND lst_upload TO fp_i_upload_file.
                    CLEAR  lst_upload.
                  ENDIF. " IF sy-subrc <> 0
                ENDIF.
              ENDIF. " IF sy-subrc NE 0
            ENDDO.
            CLOSE DATASET lv_file.
            CLEAR:st_filenames.
            st_filenames-data = lv_file.
            APPEND st_filenames TO i_filenames.
            CLEAR:st_filenames.
          ENDIF. " IF sy-subrc EQ 0
        CATCH cx_sy_file_open.
          MESSAGE i196(zqtc_r2) WITH lv_file INTO lst_bapiret-message. "an exception occured
          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = sy
            CHANGING
              bapiret2 = lst_bapiret.

          lst_output_det-type = lst_bapiret-type. "Type
          lst_output_det-id = lst_bapiret-id. "Id
          lst_output_det-number = lst_bapiret-number. "Number
          lst_output_det-message = lst_bapiret-message. "Message
          APPEND lst_output_det TO i_output_det.
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
          APPEND lst_output_det TO i_output_det_err. "++ED1K912595
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
          CLEAR lst_output_det.
      ENDTRY.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDC_PO
*&---------------------------------------------------------------------*
FORM f_set_edidc_po  CHANGING fp_st_edidc_po TYPE edidc.
* Local Constant Declaration
  CONSTANTS:
    lc_mestyp     TYPE edi_mestyp VALUE 'MBGMCR',       "Message Type
    lc_basic_type TYPE edi_idoctp VALUE 'MBGMCR03',     "Basic type
    lc_prt_ls     TYPE edi_sndprt VALUE 'LS',           "Logical port
    lc_sap        TYPE char3      VALUE 'SAP',          "system name SAP
    lc_direct_2   TYPE edi_direct VALUE '2',            "direction-inbound
    lc_status_53  TYPE edi_status VALUE '53'.           "idoc status-started
* Get Logical System
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_st_edidc_po-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
  IF sy-subrc = 0.
    fp_st_edidc_po-rcvprn = fp_st_edidc_po-sndprn.
  ENDIF. " IF sy-subrc = 0

  fp_st_edidc_po-mandt  = sy-mandt.
  fp_st_edidc_po-status = lc_status_53. "53
  fp_st_edidc_po-direct = lc_direct_2. "2
  CONCATENATE lc_sap sy-sysid INTO fp_st_edidc_po-rcvpor. "Reciever Port
  fp_st_edidc_po-sndpor = fp_st_edidc_po-rcvpor. "Sender Port
  fp_st_edidc_po-sndprt = lc_prt_ls. "LS
  fp_st_edidc_po-rcvprt = fp_st_edidc_po-sndprt. "Reciving Partner
  fp_st_edidc_po-credat = sy-datum. "Creation date
  fp_st_edidc_po-cretim = sy-uzeit. "Creation time
  fp_st_edidc_po-mestyp = lc_mestyp. "MBGMCR
  fp_st_edidc_po-idoctp = lc_basic_type. "Basic type

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_IDOC_GR
*&---------------------------------------------------------------------*
FORM f_build_idoc_gr  USING    fp_edidc_po    TYPE edidc
                      CHANGING fp_i_upload_file TYPE tt_upload_file
                               fp_i_output_det TYPE tt_output_det.

  TYPES: BEGIN OF lty_doc_type,
           sign   TYPE sign,
           option TYPE option,
           low    TYPE esart,
           high   TYPE esart,
         END OF lty_doc_type.

*    Local constant declaration
  CONSTANTS: lc_segnam   TYPE edilsegtyp VALUE 'E1MBGMCR', "Idoc segment name E1MBGCR
             lc_segnam1  TYPE edilsegtyp VALUE 'E1BP2017_GM_HEAD_01', "Idoc segment name
             lc_segnam2  TYPE edilsegtyp VALUE 'E1BP2017_GM_CODE', "Idoc segment name
             lc_segnam4  TYPE edilsegtyp VALUE 'E1BP2017_GM_ITEM_CREATE', "Idoc segment name
             lc_segnam5  TYPE edilsegtyp VALUE 'E1BP2017_GM_ITEM_CREATE1', "Idoc segment name
             lc_doc_type TYPE rvari_vnam VALUE 'DOC_TYPE',
             lc_gm_code  TYPE gm_code VALUE '01', "Value for GM_CODE
             lc_pstyp    TYPE pstyp VALUE '5', " PSTYP = 5
             lc_knttp    TYPE knttp VALUE 'X', "KNTTP = X
             lc_bewtp_e  TYPE bewtp VALUE 'E',
             lc_mov_type TYPE rvari_vnam VALUE 'MOVEMENT_TYPE',
             lc_evcode   TYPE edi_evcode VALUE 'BAPI'.

*         Local data declaration
  DATA: lst_header     TYPE e1bp2017_gm_head_01, "header strcuture
        lst_sdata      TYPE edi_sdata, "sdata structure
        lst_item       TYPE e1bp2017_gm_item_create, "Item structure
        li_edidd       TYPE tt_edidd, "EDIDD table
        li_item        TYPE tt_item, "Item table
        lst_ekko       TYPE ty_ekko,
        li_ekko        TYPE tt_ekko, "Header table
        li_ekpo_tmp    TYPE tt_ekpo, "Temporary internal table
        li_ekpo_tmp1   TYPE tt_ekpo,  "Tempororay internal tablew
        lst_ekpo       TYPE ty_ekpo, "structure for item
        lv_po_document TYPE ebeln, "Purchase Order
        lv_hlevel      TYPE edi_hlevel, "Hierarchy level
        lir_mov_typ    TYPE TABLE OF lty_doc_type,
        lst_mov_typ    TYPE lty_doc_type,
        lst_doc_typ    TYPE lty_doc_type,
        lir_doc_typ    TYPE TABLE OF lty_doc_type,
        lst_upld_file  TYPE ty_upload_file,
        lst_output_det TYPE ty_output_det,
        lv_so_document TYPE vbeln_vl. "Delivery

  LOOP AT i_constant INTO DATA(lst_zcaconst).
    CASE lst_zcaconst-param1.
      WHEN lc_doc_type.
        lst_doc_typ-sign = lst_zcaconst-sign.
        lst_doc_typ-option = lst_zcaconst-opti.
        lst_doc_typ-low = lst_zcaconst-low.
        IF lst_zcaconst-high IS NOT INITIAL.
          lst_doc_typ-high = lst_zcaconst-high.
        ENDIF.
        APPEND lst_doc_typ TO lir_doc_typ.
        CLEAR lst_doc_typ.

      WHEN lc_mov_type.
        lst_mov_typ-sign = lst_zcaconst-sign.
        lst_mov_typ-option = lst_zcaconst-opti.
        lst_mov_typ-low = lst_zcaconst-low.
        IF lst_zcaconst-high IS NOT INITIAL.
          lst_mov_typ-high = lst_zcaconst-high.
        ENDIF.
        APPEND lst_mov_typ TO lir_mov_typ.
        CLEAR lst_mov_typ.
    ENDCASE.
  ENDLOOP.

*  Populate PO item details
  SORT fp_i_upload_file BY matnr.
*  Deleting duplicate entries from internal table for using it in FOR ALL ENTRIES
  DELETE ADJACENT DUPLICATES FROM fp_i_upload_file COMPARING matnr.
  IF fp_i_upload_file IS NOT INITIAL.
    SELECT
       ebeln  " Purchasing Document Number
       ebelp  " Item Number of Purchasing Document
       matnr  " Material
       werks  " Plant
       menge  " Quantity
       meins  " Unit
  FROM ekpo
  INTO TABLE i_ekpo
  FOR ALL ENTRIES IN fp_i_upload_file
  WHERE loekz = space
  AND   matnr = fp_i_upload_file-matnr
  AND   elikz = space
  AND   pstyp = lc_pstyp
  AND   knttp = lc_knttp.
    IF sy-subrc EQ 0.
*      Copying contents of internal table to local table for deleting duplicate entries
      li_ekpo_tmp[] = i_ekpo[].
*  Deleting duplicate entries from internal table for using it in FOR ALL ENTRIES
      SORT li_ekpo_tmp BY ebeln.
      DELETE ADJACENT DUPLICATES FROM li_ekpo_tmp COMPARING ebeln.
      IF li_ekpo_tmp IS NOT INITIAL.
*    Populate PO header details
        SELECT ebeln  " Purchasing Document Number
               aedat  " Date on Which Record Was Created
               lifnr  " Vendor Account Number
               bedat  " Purchasing Document date
          INTO TABLE li_ekko
          FROM ekko
          FOR ALL ENTRIES IN li_ekpo_tmp
          WHERE ebeln = li_ekpo_tmp-ebeln
            AND bsart IN lir_doc_typ.
        IF sy-subrc EQ 0.
          SORT li_ekko BY ebeln.
        ENDIF.
        CLEAR li_ekpo_tmp[].
* To remove purchase orders that has document types not in the range of lir_doc_typ.
        LOOP AT i_ekpo INTO lst_ekpo.
          READ TABLE li_ekko INTO lst_ekko WITH KEY ebeln = lst_ekpo-ebeln.
          IF sy-subrc NE 0.
            DELETE i_ekpo WHERE ebeln = lst_ekpo-ebeln.
          ENDIF.
        ENDLOOP.
        li_ekpo_tmp[] = i_ekpo[].
        SORT li_ekpo_tmp BY ebeln ebelp.
        DELETE ADJACENT DUPLICATES FROM li_ekpo_tmp COMPARING ebeln ebelp.
        IF  li_ekpo_tmp IS NOT INITIAL.
*--Begin Code Added by Pavan
* S stands for + and H is -.
          SELECT ebeln ebelp belnr bwart menge shkzg
                 INTO TABLE i_ekbe
                 FROM ekbe
              FOR ALL ENTRIES IN li_ekpo_tmp
            WHERE ebeln = li_ekpo_tmp-ebeln AND
                  ebelp = li_ekpo_tmp-ebelp AND
                  bewtp = lc_bewtp_e AND
                  bwart IN lir_mov_typ.
          IF sy-subrc EQ 0.
            SORT i_ekbe BY ebeln ebelp.
          ENDIF.
*--End Code Added by Pavan
*    Populate EKKN data
          SELECT ebeln "Purchasing Document Number
                 ebelp "Line Item
                 zekkn "Counter
                 menge "Quantity
                 vbeln "Sales Document
                 vbelp "Sales Document Item
            FROM ekkn
            INTO TABLE i_ekkn
            FOR ALL ENTRIES IN li_ekpo_tmp
            WHERE ebeln = li_ekpo_tmp-ebeln
            AND   ebelp = li_ekpo_tmp-ebelp
            AND   vbeln <> space.
          IF sy-subrc EQ 0.
            SORT i_ekkn BY ebeln ebelp.
          ENDIF. "li_ekkn
        ENDIF. "li_ekpo_tmp
      ENDIF. "li_ekpo_tmp
    ENDIF. "li_ekpo
  ENDIF. "fp_i_upload_file

  IF i_ekpo IS NOT INITIAL.
    CLEAR li_ekpo_tmp.
    li_ekpo_tmp[] = i_ekpo[].
    SORT li_ekpo_tmp BY ebeln.
*  To process the records of EKPO and populate idoc structure
    LOOP AT li_ekpo_tmp INTO lst_ekpo.
*    To populate item table and pass it in idoc
      PERFORM f_populate_item USING lst_ekpo
                                    li_ekko
                              CHANGING li_item.

      READ TABLE li_item INTO DATA(lst_item_s) INDEX 1.
      IF sy-subrc NE 0.
        CLEAR li_item[].
        CONTINUE.
      ENDIF.

      DATA(lst_ekpo_tmp) = lst_ekpo.
      AT END OF ebeln. " to populate idoc for purchase order
*      To build the IDOC  data structure
        DATA(lv_segnam) = lc_segnam.
        CLEAR lv_hlevel.
        lv_hlevel = lv_hlevel + 1.
        PERFORM f_set_edidd USING lv_segnam
                                  lv_hlevel
                                  lst_sdata
                            CHANGING li_edidd.

*    To populate header table and pass in IDOC
        PERFORM f_populate_header USING lst_ekpo_tmp
                                        fp_i_upload_file
                                  CHANGING lst_header.

        CLEAR lv_segnam.
        lv_segnam = lc_segnam1.
        lst_sdata = lst_header.
        lv_hlevel = lv_hlevel + 1.
*      To build the IDOC  data structure
        PERFORM f_set_edidd USING lv_segnam
                                  lv_hlevel
                                  lst_sdata
                            CHANGING li_edidd.
        lv_hlevel = lv_hlevel - 1.

*      To set edidc for GM Code
        DATA(lv_code) = lc_gm_code.
        lv_segnam = lc_segnam2.
        lst_sdata = lv_code.
        lv_hlevel = lv_hlevel + 1.
*      To build the IDOC  data structure
        PERFORM f_set_edidd USING lv_segnam
                                  lv_hlevel
                                  lst_sdata
                            CHANGING li_edidd.
*      lv_hlevel = lv_hlevel - 1.
*
*      lv_segnam = lc_segnam3.
*      lv_hlevel = lv_hlevel + 1.
*      CLEAR lst_sdata.
**      To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
        lv_hlevel = lv_hlevel - 1.

*      To set EDIDC for items
        LOOP AT li_item INTO lst_item.
          "For line item
          lv_segnam = lc_segnam4.
          lst_sdata = lst_item.
          lv_hlevel = lv_hlevel + 1.
*      To build the IDOC  data structure
          PERFORM f_set_edidd USING lv_segnam
                                    lv_hlevel
                                    lst_sdata
                              CHANGING li_edidd.
          CLEAR lst_item.

          lv_segnam = lc_segnam5.
          CLEAR lst_sdata.
          lst_sdata = lst_item.
          lv_hlevel = lv_hlevel + 1.
*      To build the IDOC  data structure
          PERFORM f_set_edidd USING lv_segnam
                                    lv_hlevel
                                    lst_sdata
                              CHANGING li_edidd.
          lv_hlevel = lv_hlevel - 2.
        ENDLOOP.

*      lv_segnam = lc_segnam6.
*      lv_hlevel = lv_hlevel + 1.
*      CLEAR lst_sdata.
**      To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
*      lv_hlevel = lv_hlevel - 1.
*
*      lv_segnam = lc_segnam7.
*      lv_hlevel = lv_hlevel + 1.
*      CLEAR lst_sdata.
**      To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
*      lv_hlevel = lv_hlevel - 1.
*
*      lv_segnam = lc_segnam8.
*      lv_hlevel = lv_hlevel + 1.
*      CLEAR lst_sdata.
**      To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
        lv_hlevel = lv_hlevel - 1.

*    Create IDOC
        lv_po_document = lst_ekpo-ebeln.
        PERFORM f_create_idoc USING    fp_edidc_po
                                       lc_evcode
                                       lv_po_document
*                                       lv_so_document
                              CHANGING li_edidd
                                       fp_i_output_det.
        CLEAR li_item[].
      ENDAT.
      CLEAR: lst_ekpo,lst_ekpo_tmp.
    ENDLOOP.
  ELSE.
    LOOP AT fp_i_upload_file INTO lst_upld_file.
      CONCATENATE text-012 lst_upld_file-matnr
             INTO lst_output_det-message SEPARATED BY space.
      APPEND lst_output_det TO fp_i_output_det.
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      APPEND lst_output_det TO i_output_det_err.   "++ED1K912595
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      CLEAR: lst_output_det,
             lst_upld_file.
    ENDLOOP.
  ENDIF.

* To Populate the message which has no PO items for some of the materials from the file.
* In this Scenario i_ekpo will be populated.

* To make sure original I_EKPO sort criteria is not disturbed we are taking it into temp
* internal table and sorting it based on MATNR to be used for binary search.
  li_ekpo_tmp1[] = i_ekpo[].

  LOOP AT fp_i_upload_file INTO lst_upld_file.
    READ TABLE  li_ekpo_tmp1 INTO lst_ekpo WITH KEY matnr = lst_upld_file-matnr.
    IF sy-subrc NE 0.
      CONCATENATE text-013 lst_upld_file-matnr
                INTO lst_output_det-message SEPARATED BY space.
      APPEND lst_output_det TO fp_i_output_det.
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      APPEND lst_output_det TO i_output_det_err.   "++ED1K912595
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      CLEAR: lst_output_det,
             lst_upld_file.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ITEM
*&---------------------------------------------------------------------*
FORM f_populate_item  USING    fp_lst_ekpo TYPE ty_ekpo
                               fp_li_ekko TYPE tt_ekko
                      CHANGING fp_li_item TYPE tt_item.

*Local constant declaration
  CONSTANTS: lc_mvt_ind    TYPE char1 VALUE 'B',
             lc_shkzg_s    TYPE shkzg VALUE 'S',
             lc_shkzg_h    TYPE shkzg VALUE 'H',
             lc_post_mvtyp TYPE rvari_vnam VALUE 'POST_MVTYP',
             lc_storage    TYPE rvari_vnam VALUE 'STORAGE_LOC'.

* Local data declaration
  DATA: lst_item     TYPE e1bp2017_gm_item_create,
        lst_ekkn     TYPE ty_ekkn,
        lst_ekbe     TYPE ty_ekbe,
        lst_constant TYPE ty_constant,
        lv_remqty    TYPE menge_d.

  lst_item-material = fp_lst_ekpo-matnr.
  lst_item-plant    = fp_lst_ekpo-werks.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_storage BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_item-stge_loc  = lst_constant-low."'1001'.
  ENDIF.
  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_post_mvtyp BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_item-move_type = lst_constant-low.
  ENDIF.

  lst_item-mvt_ind  = lc_mvt_ind.

*-- Begin Code Added by Pavan
  CLEAR lv_remqty.
  LOOP AT i_ekbe INTO lst_ekbe WHERE ebeln = fp_lst_ekpo-ebeln AND
                                     ebelp = fp_lst_ekpo-ebelp.
    IF lst_ekbe-shkzg = lc_shkzg_s.
      lv_remqty = lv_remqty + lst_ekbe-menge.
    ELSEIF lst_ekbe-shkzg = lc_shkzg_h.
      lv_remqty = lv_remqty - lst_ekbe-menge.
    ENDIF.
  ENDLOOP.
*  lst_item-entry_qnt = fp_lst_ekpo-menge.
  IF lv_remqty IS NOT INITIAL.
    lst_item-entry_qnt = fp_lst_ekpo-menge - lv_remqty.
  ELSE.
    lst_item-entry_qnt = fp_lst_ekpo-menge.
  ENDIF.
*-- End Code Added by Pavan

  CONDENSE lst_item-entry_qnt.
  lst_item-entry_uom = fp_lst_ekpo-meins.
  READ TABLE fp_li_ekko INTO DATA(lst_ekko) WITH KEY ebeln = fp_lst_ekpo-ebeln BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_item-vendor = lst_ekko-lifnr.
  ENDIF.
  lst_item-po_number = fp_lst_ekpo-ebeln.
  lst_item-po_item = fp_lst_ekpo-ebelp.
  CLEAR lst_ekkn.
**  Populate delivery number
*  READ TABLE i_ekkn INTO lst_ekkn WITH KEY  ebeln = fp_lst_ekpo-ebeln
*                                               ebelp = fp_lst_ekpo-ebelp
*                                               BINARY SEARCH.
*  IF sy-subrc EQ 0.
*    lst_item-deliv_numb_to_search = lst_ekkn-vbeln.
*    lst_item-deliv_item_to_search = lst_ekkn-vbelp.
*  ENDIF.
  IF lst_item-entry_qnt GT 0.
    APPEND lst_item TO fp_li_item.
  ENDIF.
  CLEAR lst_item.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDD
*&---------------------------------------------------------------------*
FORM f_set_edidd USING fp_lv_segnam TYPE edilsegtyp
                       fp_lv_hlevel TYPE edi_hlevel
                       fp_lst_sdata TYPE edi_sdata
                 CHANGING fp_li_edidd TYPE tt_edidd.
* Local data declaration
  DATA lst_edidd TYPE edidd.   "IDOC Data structure
* Local Constant Declaration
  CONSTANTS lc_mestyp TYPE edi_mestyp VALUE 'MBGMCR'. "Message type
* Call the FM to adjust the fields in SDATA structure
  CALL FUNCTION 'IDOC_REDUCTION_FIELD_REDUCE'
    EXPORTING
      message_type = lc_mestyp
      segment_type = fp_lv_segnam
      segment_data = fp_lst_sdata
    IMPORTING
      segment_data = lst_edidd-sdata.
* Add the segment name
  lst_edidd-segnam = fp_lv_segnam.
*  Add the hierarchy level
  lst_edidd-hlevel = fp_lv_hlevel.
  APPEND lst_edidd TO fp_li_edidd.
  CLEAR lst_edidd.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_IDOC
*&---------------------------------------------------------------------*
FORM f_create_idoc  USING    fp_lst_edidc TYPE edidc
                             fp_lc_evcode TYPE edi_evcode
                             fp_lv_po_document TYPE ebeln
*                             fp_lv_so_document TYPE vbeln_vl
                    CHANGING fp_li_edidd TYPE tt_edidd
                             fp_i_output_det TYPE tt_output_det.
* Local data declaration
  DATA: lst_inb_pr_data    TYPE tede2,                   "inbound data
        lv_sy_subrc        TYPE sysubrc,                 "Sy-subrc
        li_control_records TYPE STANDARD TABLE OF edidc, "IDOC control record
        lst_process_data   TYPE tede2,                   "IDOC process data
        lst_output_det     TYPE ty_output_det,          "Output Details Table
        lst_edidc          TYPE edidc.                  "IDOC control record data

* Local Constant declaration
  CONSTANTS:
    lc_6    TYPE edi_edivr2 VALUE '6'.     "Event No

  CLEAR lst_output_det.
  lst_edidc = fp_lst_edidc.
* Call the FM to create the IDOC no and initatiate the IDOC
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error      = abap_true
      pi_return_data_flag     = space
    IMPORTING
      pe_idoc_number          = lst_output_det-idoc_number
      pe_state_of_processing  = lv_sy_subrc
      pe_inbound_process_data = lst_inb_pr_data
    TABLES
      t_data_records          = fp_li_edidd[]
    CHANGING
      pc_control_record       = lst_edidc
    EXCEPTIONS
      idoc_not_saved          = 1
      OTHERS                  = 2.
  IF sy-subrc = 0.
    COMMIT WORK.
* Append the data in the control record table to pass
    APPEND lst_edidc TO li_control_records.
    CLEAR: lst_edidc,
           lst_process_data.
* Assign the Event code details
    lst_process_data-mandt  = sy-mandt.
    lst_process_data-evcode = fp_lc_evcode.
    lst_process_data-edivr2 = lc_6.

* Call the FM to schedule the Inbound processing in Foreground
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_process_data
        succ_show_flag                = abap_true
        pi_called_online              = abap_true
        pi_start_event_enabled        = abap_true
      TABLES
        t_control_records             = li_control_records
      EXCEPTIONS
        invalid_document_number       = 1
        error_before_call_application = 2
        inbound_process_not_possible  = 3
        old_wf_start_failed           = 4
        wf_task_error                 = 5
        serious_inbound_error         = 6
        OTHERS                        = 7.
    IF sy-subrc EQ 0.
*      Populate final output table
      PERFORM f_populate_output  USING     fp_lv_po_document
*                                           fp_lv_so_document
                                 CHANGING  lst_output_det
                                           fp_i_output_det.
    ENDIF.
  ENDIF. " IF sy-subrc message    = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_OUTPUT
*&---------------------------------------------------------------------*
FORM f_populate_output  USING       fp_lv_po_document TYPE ebeln
*                                    fp_lv_so_document TYPE vbeln_vl
                        CHANGING    fp_lst_output_det TYPE ty_output_det
                                    fp_i_output_det TYPE tt_output_det.
  DATA: li_edids  TYPE STANDARD TABLE OF edids, "table for edidd
        li_edidd  TYPE STANDARD TABLE OF edidd, "table for edidc
        lst_edids TYPE edids, "edids structure
        lv_msg    TYPE bapi_msg. "message

* FM to read the idoc details
  CALL FUNCTION 'IDOC_READ_COMPLETELY'
    EXPORTING
      document_number         = fp_lst_output_det-idoc_number
    TABLES
      int_edids               = li_edids
      int_edidd               = li_edidd
    EXCEPTIONS
      document_not_exist      = 1
      document_number_invalid = 2
      OTHERS                  = 3.
  IF sy-subrc = 0.
    SORT li_edids BY countr DESCENDING.
    READ TABLE li_edids INTO lst_edids INDEX 1.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = lst_edids-stamid
          lang      = sy-langu
          no        = lst_edids-stamno
          v1        = lst_edids-stapa1
          v2        = lst_edids-stapa2
          v3        = lst_edids-stapa3
          v4        = lst_edids-stapa4
        IMPORTING
          msg       = lv_msg
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.
        fp_lst_output_det-po_number = fp_lv_po_document. "Purchase Order
*        fp_lst_output_det-delivery = fp_lv_so_document. "Delivery
        fp_lst_output_det-type = lst_edids-statyp. "Type
        fp_lst_output_det-id = lst_edids-stamid. "Id
        fp_lst_output_det-number = lst_edids-stamno. "Number
        fp_lst_output_det-message = lv_msg. "Message
        APPEND fp_lst_output_det TO fp_i_output_det.
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
        IF lst_edids-statyp = 'E'.
          APPEND fp_lst_output_det TO i_output_det_err.
        ENDIF.
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDC_SO
*&---------------------------------------------------------------------*
*FORM f_set_edidc_so  CHANGING fp_st_edidc_so TYPE edidc.
** Local Constant Declaration
*  CONSTANTS:
*    lc_mestyp     TYPE edi_mestyp VALUE 'WHSCON',       "Message Type
*    lc_basic_type TYPE edi_idoctp VALUE 'DELVRY03',     "Basic Type
*    lc_prt_ls     TYPE edi_sndprt VALUE 'LS',           "Logical port
*    lc_sap        TYPE char10     VALUE 'SAP',          "system name SAP
*    lc_direct_2   TYPE edi_direct VALUE '2',            "direction-inbound
*    lc_status_53  TYPE edi_status VALUE '53'.           "idoc status-started
** Get Logical System
*  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
*    IMPORTING
*      own_logical_system             = fp_st_edidc_so-sndprn
*    EXCEPTIONS
*      own_logical_system_not_defined = 1
*      OTHERS                         = 2.
*  IF sy-subrc = 0.
*    fp_st_edidc_so-rcvprn = fp_st_edidc_so-sndprn.
*  ENDIF. " IF sy-subrc = 0
*
*  fp_st_edidc_so-mandt  = sy-mandt.
*  fp_st_edidc_so-status = lc_status_53. "53
*  fp_st_edidc_so-direct = lc_direct_2. "2
*  CONCATENATE lc_sap sy-sysid INTO fp_st_edidc_so-rcvpor. "Reciever Port
*  fp_st_edidc_so-sndpor = fp_st_edidc_so-rcvpor. "Sender Port
*  fp_st_edidc_so-sndprt = lc_prt_ls. "LS
*  fp_st_edidc_so-rcvprt = fp_st_edidc_so-sndprt. "Reciever Partner
*  fp_st_edidc_so-credat = sy-datum. "Creation date
*  fp_st_edidc_so-cretim = sy-uzeit. "Creation Time
*  fp_st_edidc_so-mestyp = lc_mestyp. "MBGMCR
*  fp_st_edidc_so-idoctp = lc_basic_type. "basic type
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_IDOC_GI
*&---------------------------------------------------------------------*
*FORM f_build_idoc_gi  USING    i_ekkn TYPE tt_ekkn
*                               fp_edidc_so TYPE edidc
**                               fp_i_upload_file TYPE tt_upload_file
*                      CHANGING fp_i_output_det TYPE tt_output_det.
*
**  local data declaration
*  DATA: lv_num_deliv         TYPE vbnum, " Delivery Number
*        li_sales_order_item  TYPE STANDARD TABLE OF bapidlvreftosalesorder, "sales Order item
*        li_ekkn_tmp          TYPE tt_ekkn, "Temporary table
*        lst_ekkn             TYPE ty_ekkn, " INTERNAL TABLE FOR EKKN
*        lst_sales_order_item TYPE bapidlvreftosalesorder, "Structure for sales order
*        li_return            TYPE bapiret2_t, "Internal table for return
*        li_likp              TYPE tt_likp, "Internal table for delivery header
*        li_lips              TYPE tt_lips, "Internal table for delivery item
*        li_delivery          TYPE tt_delivery, "Internal table for delivery
*        lst_delivery         TYPE ty_delivery, "Structure for delivery
*        lst_lips             TYPE ty_lips, "Structure for delivery item
*        lst_e1edl20          TYPE e1edl20, "E1EDL20 structure
*        lst_e1edl21          TYPE e1edl21, "E1EDL21 structure
*        lst_e1edl18          TYPE e1edl18, "E1EDL18 structure
*        lst_e1edt13          TYPE e1edt13, "E1EDL13 structure
*        lst_e1edl24          TYPE e1edl24, "E1EDL24 structure
*        lst_e1edl26          TYPE e1edl26, "E1EDL26 structure
*        lst_sdata            TYPE edi_sdata, "SDATA structure
*        li_idoc_number       TYPE tt_idoc_number,
*        li_mseg              TYPE tt_mseg,
*        lst_likp             TYPE ty_likp, "Delivery Header structure
*        li_edidd             TYPE tt_edidd, "EDIDD internal table
*        lst_output_det       TYPE ty_output_det,
*        lv_ship_point        TYPE vstel, "variable for ship point
*        lv_tabix             TYPE sy-tabix, "Tabix variable
*        lv_due_date          TYPE sy-datum, "Date variable
*        lv_so_document       TYPE vbeln_vl, "Variable for delivery
*        lv_idoc_number       TYPE char70,
*        lv_hlevel            TYPE edi_hlevel,
*        lv_po_document       TYPE ebeln.  "variable for Purchase Document
*
**  Local constant declaration
*  CONSTANTS: lc_segnam  TYPE edilsegtyp VALUE 'E1EDL20',  "E1EDL20
*             lc_segnam1 TYPE edilsegtyp VALUE 'E1EDL21',  "E1EDL21
*             lc_segnam2 TYPE edilsegtyp VALUE 'E1EDL18',  "E1EDL18
*             lc_segnam3 TYPE edilsegtyp VALUE 'E1EDT13',  "E1EDL13
*             lc_segnam4 TYPE edilsegtyp VALUE 'E1EDL24',  "E1EDL24
*             lc_segnam5 TYPE edilsegtyp VALUE 'E1EDL26',  "E1EDL26
*             lc_qualf18 TYPE edi_vtdl18 VALUE 'PGI', "PGI
*             lc_qualf13 TYPE edi_vtdt13 VALUE '015', "015
**             lc_ship_point TYPE rvari_vnam VALUE 'SHIP_POINT', "Ship point
*             lc_success TYPE bapi_mtype VALUE 'S', "Error
*             lc_evcode  TYPE edi_evcode VALUE 'DELV'. "Process code
*  IF fp_i_output_det IS NOT INITIAL.
** Fetching of material document number generated after GR
** Removing duplicate idoc number if any
*    LOOP AT fp_i_output_det INTO DATA(lst_output).
*      lv_idoc_number = lst_output-idoc_number.
*      APPEND lv_idoc_number TO li_idoc_number.
*      CLEAR lv_idoc_number.
*    ENDLOOP.
*
*    IF li_idoc_number IS NOT INITIAL.
** Perform to get MSEG details
*      PERFORM f_get_mseg_det CHANGING li_idoc_number
*                                      li_mseg.
*    ENDIF.
*  ENDIF.
*
**To populate sales order details
*  CLEAR li_ekkn_tmp[].
*  li_ekkn_tmp[] = i_ekkn[].
*  IF li_ekkn_tmp IS NOT INITIAL.
*    SELECT a~vbeln,
*           a~posnr,
*           a~vstel,
*           b~edatu
*      FROM vbap AS a
*      LEFT OUTER JOIN vbep AS b ON a~vbeln = b~vbeln
*      INTO TABLE @DATA(li_vbap_vbep)
*      FOR ALL ENTRIES IN @li_ekkn_tmp
*      WHERE a~vbeln = @li_ekkn_tmp-vbeln
*      AND   a~posnr = @li_ekkn_tmp-vbelp.
*    IF sy-subrc EQ 0.
*      SORT li_vbap_vbep BY vbeln posnr.
*    ENDIF.
*  ENDIF.
*
**  Create outbound delivery
*  LOOP AT i_ekkn INTO lst_ekkn.
*    lst_sales_order_item-ref_doc = lst_ekkn-vbeln.
*    lst_sales_order_item-ref_item = lst_ekkn-vbelp.
**      Get the Material Document generated by GR idoc MBGMCR and its quantity
*    READ TABLE fp_i_output_det ASSIGNING FIELD-SYMBOL(<lst_output_det>) WITH KEY po_number = lst_ekkn-ebeln.
*    IF sy-subrc EQ 0.
*      CLEAR lv_idoc_number.
*      lv_idoc_number = <lst_output_det>-idoc_number.
*      READ TABLE li_idoc_number WITH KEY idoc_number = lv_idoc_number TRANSPORTING NO FIELDS.
*      IF sy-subrc EQ 0.
*        READ TABLE li_mseg INTO DATA(lst_mseg) WITH KEY ebeln = lst_ekkn-ebeln
*                                                        ebelp = lst_ekkn-ebelp BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          lst_sales_order_item-dlv_qty = lst_mseg-menge.
*          lst_sales_order_item-sales_unit = lst_mseg-meins.
*          APPEND lst_sales_order_item TO li_sales_order_item.
*          CLEAR lst_sales_order_item.
*          <lst_output_det>-material_doc = lst_mseg-mblnr.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    DATA(lst_ekkn_tmp) = lst_ekkn.
*    AT END OF vbeln. " For new sales order create delivery
*      READ TABLE li_vbap_vbep INTO DATA(lst_vbap_vbep) WITH KEY vbeln = lst_ekkn_tmp-vbeln
*                                                           posnr = lst_ekkn_tmp-vbelp
*                                                           BINARY SEARCH.
*
*      IF sy-subrc EQ 0.
*        CLEAR lv_ship_point.
*        lv_ship_point = lst_vbap_vbep-vstel.
*
*        CLEAR lv_due_date.
*        lv_due_date = lst_vbap_vbep-edatu.
*      ENDIF.
*
**     FM to create outbound delivery
*      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
*        EXPORTING
*          ship_point        = lv_ship_point
*          due_date          = lv_due_date
*        IMPORTING
*          delivery          = lst_delivery-delivery
*          num_deliveries    = lv_num_deliv
*        TABLES
*          sales_order_items = li_sales_order_item
*          return            = li_return.
*      READ TABLE li_return INTO DATA(lst_return) WITH KEY type = lc_success.
*      IF sy-subrc EQ 0."lst_return-type = lc_success.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            wait = abap_true.
*      ENDIF.
*      lst_output_det-po_number = lst_delivery-po_number = lst_ekkn_tmp-ebeln. "Purchase Order
*      lst_output_det-delivery = lst_delivery-delivery. "Delivery
*      lst_output_det-type = lst_return-type. "Type
*      lst_output_det-id = lst_return-id. "Id
*      lst_output_det-number = lst_return-number. "Number
*      lst_output_det-message = lst_return-message. "Message
*      APPEND lst_output_det TO fp_i_output_det.
*      APPEND lst_delivery TO li_delivery.
*      CLEAR: lst_return,lst_output_det,lst_delivery,li_return.
*    ENDAT.
*    CLEAR: lst_ekkn,lst_ekkn_tmp.
*  ENDLOOP.
*
*  IF li_delivery IS NOT INITIAL.
** Populate LIKP and LIPS data
*    PERFORM f_populate_likp_lips CHANGING li_delivery
*                                          li_likp
*                                          li_lips.
*
**Populate IDOC
*    LOOP AT li_delivery INTO DATA(lst_deliv).
*      lst_delivery = lst_deliv.
*
*      AT END OF delivery. "For each delivery an IDOC will be generated
*        CLEAR: lst_likp.
*        READ TABLE li_likp INTO lst_likp WITH KEY vbeln = lst_delivery-delivery
*                                                  BINARY SEARCH.
*        IF sy-subrc EQ 0.
**        Populate E1EDL20
*          lst_e1edl20-vbeln = lst_likp-vbeln.
*          lst_e1edl20-vstel = lst_likp-vstel.
*          lst_e1edl20-vkorg = lst_likp-vkorg.
*          lst_e1edl20-vsbed = lst_likp-vsbed.
*          lst_e1edl20-podat = lst_likp-podat.
*          lst_e1edl20-potim = lst_likp-potim.
**        Populate E1EDL21
*          lst_e1edl21-lfart = lst_likp-lfart.
*          lst_e1edl21-lprio = lst_likp-lprio.
*          lst_e1edl21-tragr = lst_likp-tragr.
*        ENDIF.
**        Populate E1EDL18
*        lst_e1edl18-qualf = lc_qualf18.
**        Populate E1EDT13
*        lst_e1edt13-qualf = lc_qualf13.
*        lst_e1edt13-ntanf = sy-datum.
*        lst_e1edt13-ntanz = '000000'.
*        lst_e1edt13-ntend = sy-datum.
*        lst_e1edt13-ntenz = '000000'.
*
**      To build the IDOC  data structure
*        DATA(lv_segnam) = lc_segnam.
*        CLEAR lv_hlevel.
*        lv_hlevel = lv_hlevel + 2.
*        lst_sdata = lst_e1edl20.
*        PERFORM f_set_edidd USING lv_segnam
*                                  lv_hlevel
*                                  lst_sdata
*                            CHANGING li_edidd.
*
**      To build the IDOC  data structure
*        lv_hlevel = lv_hlevel + 1.
*        lv_segnam = lc_segnam1.
*        lst_sdata = lst_e1edl21.
*        PERFORM f_set_edidd USING lv_segnam
*                                  lv_hlevel
*                                  lst_sdata
*                            CHANGING li_edidd.
*
**      To build the IDOC  data structure
*        lv_segnam = lc_segnam2.
*        lst_sdata = lst_e1edl18.
*        PERFORM f_set_edidd USING lv_segnam
*                                  lv_hlevel
*                                  lst_sdata
*                            CHANGING li_edidd.
**      To build the IDOC  data structure
*        lv_segnam = lc_segnam3.
*        lst_sdata = lst_e1edt13.
*        PERFORM f_set_edidd USING lv_segnam
*                                  lv_hlevel
*                                  lst_sdata
*                            CHANGING li_edidd.
************************************************************************
*        READ TABLE li_lips INTO lst_lips WITH KEY vbeln = lst_delivery-delivery BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          lv_tabix = sy-tabix.
*          CLEAR lst_lips.
*          LOOP AT li_lips INTO lst_lips FROM lv_tabix. "It will loop from that index
*            IF lst_lips-vbeln <> lst_delivery-delivery .
*              EXIT.
*            ENDIF.
**        Populate E1EDL24
*            lst_e1edl24-posnr = lst_lips-posnr.
*            lst_e1edl24-matnr = lst_lips-matnr.
*            lst_e1edl24-werks = lst_lips-werks.
*            lst_e1edl24-lgort = lst_lips-lgort.
*            lst_e1edl24-lfimg = lst_lips-lfimg.
*            CONDENSE lst_e1edl24-lfimg.
*            lst_e1edl24-vrkme = lst_lips-vrkme.
*            lst_e1edl24-lgmng = lst_lips-lgmng.
*            CONDENSE lst_e1edl24-lgmng.
*            lst_e1edl24-meins = lst_lips-meins.
*            lst_e1edl24-vtweg = lst_lips-vtweg.
*            lst_e1edl24-spart = lst_lips-spart.
*            lst_e1edl24-vgbel = lst_lips-vgbel.
*            lst_e1edl24-vgpos = lst_lips-vgpos.
*            lst_e1edl24-ormng = lst_lips-ormng.
*            CONDENSE lst_e1edl24-ormng.
**      To build the IDOC  data structure
*            lv_segnam = lc_segnam4.
*            lst_sdata = lst_e1edl24.
*            PERFORM f_set_edidd USING lv_segnam
*                                      lv_hlevel
*                                      lst_sdata
*                                CHANGING li_edidd.
*            CLEAR lst_e1edl24.
*
**        Populate E1EDL26
*            lst_e1edl26-pstyv = lst_lips-pstyv.
*            lst_e1edl26-umvkz = lst_lips-umvkz.
*            CONDENSE lst_e1edl26-umvkz.
*            lst_e1edl26-umvkn = lst_lips-umvkn.
*            lst_e1edl26-uebto = lst_lips-uebto.
*            lst_e1edl26-untto = lst_lips-untto.
**      To build the IDOC  data structure
*            lv_hlevel = lv_hlevel + 1.
*            lv_segnam = lc_segnam5.
*            lst_sdata = lst_e1edl26.
*            PERFORM f_set_edidd USING lv_segnam
*                                      lv_hlevel
*                                      lst_sdata
*                                CHANGING li_edidd.
*            CLEAR lst_e1edl26.
*          ENDLOOP.
*        ENDIF.
*************************************************************************
**       Taking delivery number in a variable to pass in subroutine
*        lv_so_document = lst_delivery-delivery.
*
**    Create IDOC
*        PERFORM f_create_idoc USING    fp_edidc_so
*                                       lc_evcode
*                                       lv_po_document
*                                       lv_so_document
*                              CHANGING li_edidd
*                                       fp_i_output_det.
*      ENDAT.
*    ENDLOOP.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LIKP_LIPS
*&---------------------------------------------------------------------*
*FORM f_populate_likp_lips  CHANGING    fp_li_delivery TYPE tt_delivery
*                                       fp_li_likp TYPE tt_likp
*                                       fp_li_lips TYPE tt_lips.
*
*  DELETE ADJACENT DUPLICATES FROM fp_li_delivery COMPARING delivery.
*  IF fp_li_delivery IS NOT INITIAL.
*    SELECT vbeln "Delivery
*           vstel "Ship Point
*           vkorg "Sales Organization
*           lfart "Vendor
*           lprio "Delivery Priority
*           vsbed "Shipping Conditions
*           tragr "Transportation Group
*           podat "Date
*           potim "Confirmation time
*      FROM likp
*      INTO TABLE fp_li_likp
*      FOR ALL ENTRIES IN fp_li_delivery
*      WHERE vbeln = fp_li_delivery-delivery.
*    IF sy-subrc EQ 0.
*      SORT fp_li_likp BY vbeln.
*    ENDIF.
*  ENDIF.
*
*  IF fp_li_likp IS NOT INITIAL.
*    SELECT vbeln "Delivery
*           posnr "Delivery Item
*           pstyv "Category
*           matnr "Material
*           werks "Plant
*           lgort "Storage Loc
*           lfimg "Actual quantity delivered (in sales units)
*           meins "Base unit of measure
*           vrkme "Sales unit
*           umvkz "Numerator (factor) for conversion of sales quantity into SKU
*           umvkn "Denominator (Divisor) for Conversion of Sales Qty into SKU
*           uebto "Overdelivery Tolerance Limit
*           untto "Underdelivery Tolerance Limit
*           lgmng "Actual quantity delivered in stockkeeping units
*           vgbel "Document Number in reference Document
*           vgpos "Item number of the reference item
*           vtweg "Distribution Channel
*           spart "Division
*           ormng "Original Quantity of Delivery Item
*      FROM lips
*      INTO TABLE fp_li_lips
*      FOR ALL ENTRIES IN fp_li_likp
*      WHERE vbeln = fp_li_likp-vbeln.
*    IF sy-subrc EQ 0.
*      SORT fp_li_lips BY vbeln posnr.
*    ENDIF.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_TO_APP_SERVER
*&---------------------------------------------------------------------*
FORM f_write_to_app_server  USING    fp_i_output_det TYPE tt_output_det.

  DATA : lv_file        TYPE rlgrap-filename, "Filename
         lst_output_det TYPE ty_output_det, "structure for output
         lst_text       TYPE string. "string variable
  CONSTANTS lc_file_path TYPE rvari_vnam VALUE 'FILE_PATH'.

  CLEAR:v_file.
  READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = lc_file_path BINARY SEARCH.
  IF sy-subrc EQ 0.
    CONCATENATE lst_constant-low sy-datum '_' sy-uzeit '.txt'(t01)  INTO lv_file.
    v_file = lv_file.
  ENDIF.
  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

*--- Display error messages if any.
  IF sy-subrc NE 0.
    MESSAGE e045(zqtc_r2).
    RETURN.
  ELSE.

*---Data is downloaded to the application server file path

    LOOP AT fp_i_output_det INTO lst_output_det.
      CONCATENATE lst_output_det-idoc_number
                  lst_output_det-po_number
                  lst_output_det-material_doc
                  lst_output_det-type
                  lst_output_det-id
                  lst_output_det-number
                  lst_output_det-message
      INTO lst_text SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lst_text TO lv_file.
      CLEAR lst_output_det.
    ENDLOOP.
  ENDIF.
*--Close the Application server file (Mandatory).

  CLOSE DATASET lv_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tt_constant.
  CONSTANTS:  lc_devid  TYPE zdevid VALUE 'I0256'.          " Development ID

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
*&      Form  F_POPULATE_HEADER
*&---------------------------------------------------------------------*
*       Get header data
*----------------------------------------------------------------------*
*      -->FP_LST_EKPO  : EKPO Table
*      -->FP_LI_EKKO   : EKKO table
*      <--FP_LST_HEADER  : IDOC Header
*----------------------------------------------------------------------*
FORM f_populate_header  USING    fp_lst_ekpo  TYPE ty_ekpo
                                 fp_i_upload_file TYPE tt_upload_file
                        CHANGING fp_lst_header TYPE e1bp2017_gm_head_01.


*  local constant declaration
  CONSTANTS: lc_tab TYPE char1 VALUE '/'.
*  local data declaration
  DATA: lst_text   TYPE char255, " used for split of string
        lst_string TYPE string,  " used for split of string
        lv_file    TYPE char255. " variable to store file name

*Added by MODUTTA on 19/01/2017 for FUT defect
  READ TABLE fp_i_upload_file INTO DATA(lst_upload_file) WITH KEY
                                                matnr = fp_lst_ekpo-matnr
                                                BINARY SEARCH.
  IF sy-subrc EQ 0.
    CONCATENATE lst_upload_file-lodgement_date+4(4) lst_upload_file-lodgement_date+2(2) lst_upload_file-lodgement_date+0(2)
    INTO fp_lst_header-pstng_date.
    fp_lst_header-doc_date =  fp_lst_header-pstng_date.
  ENDIF.
*Commented by MODUTTA on 19/01/2017 for FUT defect
**  Read table ekko to get header details
*  CLEAR lst_ekko.
*  READ TABLE fp_li_ekko INTO lst_ekko WITH KEY ebeln = fp_lst_ekpo-ebeln
*                                               BINARY SEARCH.
*  IF sy-subrc EQ 0.
*    fp_lst_header-pstng_date = lst_ekko-aedat.
*    fp_lst_header-doc_date = lst_ekko-bedat.
*  ENDIF.

* BOC by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
*
**  FM to reverse string for getting the filename from file path
*  CALL FUNCTION 'STRING_REVERSE'
*    EXPORTING
*      string    = p_file
*      lang      = sy-langu
*    IMPORTING
*      rstring   = lv_file
*    EXCEPTIONS
*      too_small = 1
*      OTHERS    = 2.
*  IF sy-subrc = 0.
*    SPLIT lv_file AT lc_tab INTO lst_text lst_string.
*  ENDIF.
*  CLEAR lv_file.
**  FM to reverse the filename retrieved from filepath
*  CALL FUNCTION 'STRING_REVERSE'
*    EXPORTING
*      string    = lst_text
*      lang      = sy-langu
*    IMPORTING
*      rstring   = lv_file
*    EXCEPTIONS
*      too_small = 1
*      OTHERS    = 2.
*  IF sy-subrc EQ 0.
*    fp_lst_header-header_txt = lv_file.
*  ENDIF.
  fp_lst_header-header_txt = lst_upload_file-file_name.
* EOC by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
FORM f_display_output  USING    fp_i_output_det TYPE tt_output_det.

  SORT fp_i_output_det BY po_number.
*  Build Fieldcatalog
  PERFORM f_build_fieldcatalog.

*  Display ALV
  PERFORM f_display_alv CHANGING fp_i_output_det.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
FORM f_build_fieldcatalog .
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv.
*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'IDOC_NUMBER'.
  lst_fieldcatalog-seltext_m   = 'Idoc Number'(004).
  lst_fieldcatalog-col_pos     = 0.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'PO_NUMBER'.
  lst_fieldcatalog-seltext_m   = 'PO Number'(010).
  lst_fieldcatalog-col_pos     = 1.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
**  Populate fieldcatalog
*  lst_fieldcatalog-fieldname   = 'DELIVERY'.
*  lst_fieldcatalog-seltext_m   = 'Delivery'(011).
*  lst_fieldcatalog-col_pos     = 2.
*  lst_fieldcatalog-outputlen = 16.
*  APPEND lst_fieldcatalog TO i_fieldcatalog.
*  CLEAR  lst_fieldcatalog.
*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'MATERIAL_DOC'.
  lst_fieldcatalog-seltext_l   = 'Material Document No'(012).
  lst_fieldcatalog-col_pos     = 2.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'TYPE'.
  lst_fieldcatalog-seltext_m   = 'Type'(005).
  lst_fieldcatalog-col_pos     = 3.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'ID'.
  lst_fieldcatalog-seltext_m   = 'ID'(006).
  lst_fieldcatalog-col_pos     = 4.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'NUMBER'.
  lst_fieldcatalog-seltext_m   = 'Number'(007).
  lst_fieldcatalog-col_pos     = 5.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_m   = 'Message'(008).
  lst_fieldcatalog-col_pos     = 6.
  lst_fieldcatalog-outputlen = 100.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM f_display_alv CHANGING fp_i_output_det TYPE tt_output_det.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = i_fieldcatalog[]
      i_save             = abap_true
    TABLES
      t_outtab           = fp_i_output_det
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_fieldcatalog[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MSEG_DET
*&---------------------------------------------------------------------*
*      Subroutine to get MSEG details
*----------------------------------------------------------------------*
FORM f_get_mseg_det  CHANGING  fp_i_output_det TYPE tt_output_det.

*Local types declaration
  TYPES: BEGIN OF lty_idoc_no,
           idoc_number TYPE char70,
         END OF lty_idoc_no.

*Local data declaration
  DATA: li_mseg        TYPE tt_mseg,
        li_idoc_number TYPE STANDARD TABLE OF lty_idoc_no INITIAL SIZE 0,
        lv_idoc_number TYPE char70.

  DATA(li_output_tmp) = fp_i_output_det[].
  SORT li_output_tmp BY idoc_number.
  DELETE ADJACENT DUPLICATES FROM li_output_tmp COMPARING idoc_number.
  IF li_output_tmp IS NOT INITIAL.
    LOOP AT li_output_tmp INTO DATA(lst_idoc_number).
      lv_idoc_number = lst_idoc_number-idoc_number.
      APPEND lv_idoc_number TO li_idoc_number.
      CLEAR lv_idoc_number.
    ENDLOOP.
  ENDIF.

  IF li_idoc_number IS NOT INITIAL.
*  To get the roleid based on idoc number
    SELECT objkey,
           objtype,
           logsys,
           roletype,
           roleid
      FROM srrelroles
      INTO TABLE @DATA(li_service_roles)
      FOR ALL ENTRIES IN @li_idoc_number
      WHERE objkey = @li_idoc_number-idoc_number.
    IF sy-subrc EQ 0.
      SORT li_service_roles BY roleid.
      DELETE ADJACENT DUPLICATES FROM li_service_roles COMPARING roleid.
      IF li_service_roles IS NOT INITIAL.
        SELECT role_a,
               role_b
          FROM idocrel
          INTO TABLE @DATA(li_idocrel)
          FOR ALL ENTRIES IN @li_service_roles
          WHERE role_a = @li_service_roles-roleid.
        IF sy-subrc EQ 0.
          SORT  li_idocrel BY role_b.
          DELETE ADJACENT DUPLICATES FROM li_idocrel COMPARING role_b.
          IF li_idocrel IS NOT INITIAL.
*       Again select is done from srrelroles table to get the OBJKEY
*       which will now containm the material document after putting ROLE_B of IDOCREL into roleid
            SELECT objkey,
                   roleid
              FROM srrelroles
              INTO TABLE @DATA(li_objkey)
              FOR ALL ENTRIES IN @li_idocrel
              WHERE roleid = @li_idocrel-role_b.
            IF sy-subrc EQ 0.
              SORT li_objkey BY objkey.
              SELECT mblnr,
                     zeile,
                     menge,
                     meins,
                     ebeln,
                     ebelp
                FROM mseg
                INTO TABLE @li_mseg
                FOR ALL ENTRIES IN @li_objkey
                WHERE mblnr = @li_objkey-objkey+0(10).
              IF sy-subrc EQ 0.
                SORT li_mseg BY ebeln.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
*Populate material document number in final output
  LOOP AT fp_i_output_det ASSIGNING FIELD-SYMBOL(<lst_output_det>).
    CLEAR lv_idoc_number.
    lv_idoc_number = <lst_output_det>-idoc_number.

    READ TABLE li_idoc_number WITH KEY idoc_number = lv_idoc_number TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.
      READ TABLE li_mseg INTO DATA(lst_mseg) WITH KEY ebeln = <lst_output_det>-po_number
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_output_det>-material_doc = lst_mseg-mblnr.
      ENDIF.
    ENDIF.
  ENDLOOP.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
ENDFORM.
* SOC by NPOLINA ERPM2204 6/Jan/2020 ED2K917189
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_OUTPUT_DET  text
*----------------------------------------------------------------------*
FORM f_send_email  USING    fp_i_output_det TYPE tt_output_det.
  DATA:
    lv_count           TYPE syindex,                                     " Loop Index
    lst_attachment     TYPE solisti1,                                    " SAPoffice: Single List with Column Length 255
    li_mailrecipients  TYPE STANDARD TABLE OF somlreci1 INITIAL SIZE 0,  " SAPoffice: Structure of the API Recipient List
    li_mailtxt         TYPE STANDARD TABLE OF soli INITIAL SIZE 0,       " SAPoffice: line, length 255
    li_packing_list    TYPE STANDARD TABLE OF sopcklsti1 INITIAL SIZE 0, " SAPoffice: Description of Imported Object Components
    li_doc_data        TYPE STANDARD TABLE OF sodocchgi1 INITIAL SIZE 0, " Data of an object which can be changed
    lst_doc_data       TYPE sodocchgi1,                                  " Data of an object which can be changed
    lst_mailrecipients TYPE somlreci1.                                   " SAPoffice: Structure of the API Recipient List
  DATA:
    li_objhead      TYPE TABLE OF solisti1,  " Internal Table to hold data in single line format
    li_objtxt       TYPE TABLE OF solisti1,  " Internal Table to hold data in single line format
    lst_objtxt      TYPE solisti1,   " Structure to hold data in single line format
    lst_output_soli TYPE soli,       " Structure to hold Output Details in delimited format
    lst_objpack     TYPE sopcklsti1, " Structure to hold Imported Object Components
    lst_objhead     TYPE solisti1,   " Structure to hold data in single line format
    lst_str         TYPE string,
    lst_url         TYPE string,   " URL for the Runbook - Interface Error Guide
    lv_tzone        TYPE char10,
*    lst_final       TYPE ty_final,
    lv_lines        TYPE sy-tabix,  "To hold number of records
    lv_msg_lines    TYPE sy-tabix,  "To hold number of records
    lv_sent_all(1)  TYPE c,
    lv_send_email   TYPE abap_bool VALUE abap_false, " Flag for email sending in case error IDoc exists
    lv_col_cnt      TYPE i, " Flag for column count to be displayed
    lv_intid        TYPE syst-slset,         " Interface ID from Selection Screen Variant
    lv_param1       TYPE rvari_vnam VALUE 'RUN_BOOK',
    lv_xls          TYPE so_obj_tp  VALUE 'XLS',
    lv_htm          TYPE so_obj_tp  VALUE 'HTM',
    lv_rec_u        TYPE so_escape  VALUE 'U'.
  DATA: i_objbin  LIKE solix OCCURS 10 WITH HEADER LINE,
        lv_string TYPE string,
        lv_cnt    TYPE char10,
        mailto    TYPE ad_smtpadr.
  FIELD-SYMBOLS <lfs_any_t> TYPE any.


  LOOP AT s_email.
    lst_mailrecipients-rec_type = lv_rec_u .
    lst_mailrecipients-receiver  = s_email-low.
    APPEND lst_mailrecipients TO li_mailrecipients.
    CLEAR:lst_mailrecipients.
  ENDLOOP.


  IF s_email[] IS NOT INITIAL.
*    IF sy-sysid NE 'EP1'.
    CONCATENATE 'I0256_JFDS_LODGEMENT_ERROR_' sy-datum+4(2) sy-datum+6(2) sy-datum+0(4)
*                      ':'
*                      text-015
*                      text-028

               INTO lst_str
               SEPARATED BY space.
    CONDENSE lst_str NO-GAPS.
*    ELSE.
*      CONCATENATE
*                  text-015
*                  text-028
*
*             INTO lst_str
*             SEPARATED BY space.
*    ENDIF.
    CLEAR  lst_doc_data.

    lst_doc_data-obj_name   = text-029.
    lst_doc_data-obj_descr  = lst_str.
    lst_doc_data-obj_langu  = sy-langu.

    lst_objtxt-line = '<body>'(047).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(045) text-014 '</p>'(046)
                      INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(045)
*                text-042
                text-b01 text-b02
                '</p>'(046)
                INTO lst_objtxt-line SEPARATED BY space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.


    lst_objtxt-line = text-t02.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR  lst_objtxt.

    lst_objtxt-line = text-t02.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE 'Error_log' sy-datum sy-uzeit INTO DATA(lv_file2) SEPARATED BY '_'.
    DATA(lv_file3) = lv_file2.

    CONCATENATE 'Error log File path : ' v_file into DATA(lv_output) SEPARATED BY space.

    lst_objtxt-line = lv_output.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = 'Input File names as follows...'(017).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CLEAR:st_filenames.
    LOOP AT i_filenames INTO st_filenames.
      lv_cnt = lv_cnt + 1.
      lst_objtxt-line = '</br>'.
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.

      CONCATENATE lv_cnt '.' st_filenames-data INTO  lst_objtxt-line SEPARATED BY space .
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.
      CLEAR:st_filenames.
    ENDLOOP.
*---Body of the EMAIL

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<br><b><i><font color = "BLACK" style="font-family:arial;font-size:100%;">'(050)
                'This is an auto generated Email. Do not Reply to this Email.</i></b></br>'(051)
                INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = 'Regards'(016).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</body>'(065).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    DESCRIBE TABLE li_objtxt LINES lv_msg_lines.
    READ TABLE li_objtxt INTO lst_objtxt INDEX lv_msg_lines.
    lst_doc_data-doc_size = ( lv_msg_lines - 1 ) * 255 + strlen( lst_objtxt ).

    lst_objpack-head_start = 1.
    lst_objpack-head_num   = 0.
    lst_objpack-body_start = 1.
    lst_objpack-body_num   = lv_msg_lines.
    lst_objpack-doc_type   = lv_htm.     "Body must be displayed in HTM format
    APPEND lst_objpack TO li_packing_list.
    CLEAR lst_objpack.

*    PERFORM f_excel_attachment_rep.  " Excel attachment table

    LOOP AT i_xml_table INTO st_xml.
      CLEAR i_objbin.
      i_objbin-line = st_xml-data.
      APPEND i_objbin.
    ENDLOOP.

    DESCRIBE TABLE i_objbin LINES lv_count.

    lst_objpack-transf_bin  = abap_true.
    lst_objpack-head_start  = 1.
    lst_objpack-head_num    = 0.
    lst_objpack-body_start  = 1.
    lst_objpack-body_num    = lv_count.
    lst_objpack-doc_type    = 'XLS'.  "Type XLS
    lst_objpack-obj_name    = 'data'(031).
    lst_objpack-obj_descr   = lv_file3 ."'Error Log'(009).
    lst_objpack-doc_size    = lv_count * 255. " Total Number of lines * 225

*    APPEND lst_objpack TO li_packing_list.  "FIle name
    CLEAR lst_objpack.
*--Sending the Email with Attchment
    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = lst_doc_data
        put_in_outbox              = abap_true
        commit_work                = abap_true
      TABLES
        packing_list               = li_packing_list
        object_header              = li_objhead
        contents_hex               = i_objbin
        contents_txt               = li_objtxt
        receivers                  = li_mailrecipients
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.

    IF sy-subrc = 0.
      cl_os_transaction_end_notifier=>raise_commit_requested( ).
      CALL FUNCTION 'DB_COMMIT'.
      cl_os_transaction_end_notifier=>raise_commit_finished( ).
      MESSAGE text-032 TYPE c_inf.
    ENDIF.
  ENDIF.
ENDFORM.

FORM  f_excel_attachment_rep.

  DATA: lst_fcat    TYPE lvc_s_fcat,
        lv_temp_str TYPE string.

  ##NO_TEXT CONSTANTS:lc_workbook     TYPE string VALUE 'Workbook',
            lc_xmlns        TYPE string VALUE 'xmlns',
            lc_value        TYPE string VALUE 'urn:schemas-microsoft-com:office:spreadsheet',
            lc_excel        TYPE string VALUE 'urn:schemas-microsoft-com:office:excel',
            lc_ss           TYPE string VALUE 'ss',
            lc_x            TYPE string VALUE 'x',
            lc_doc_p        TYPE string VALUE 'DocumentProperties',
            lc_bc_rdwd      TYPE string VALUE 'BC_RDWD',
            lc_author       TYPE string VALUE 'Author',
            lc_styles       TYPE string VALUE 'Styles',
            lc_style        TYPE string VALUE 'Style',
            lc_id           TYPE string VALUE 'ID',
            lc_header       TYPE string VALUE 'Header',
            lc_font         TYPE string VALUE 'Font',
            lc_bold         TYPE string VALUE 'Bold',
            lc_color        TYPE string VALUE 'Color',
            lc_pattern      TYPE string VALUE 'Pattern',
            lc_vertical     TYPE string VALUE 'Vertical',
            lc_wraptext     TYPE string VALUE 'WrapText',
            lc_position     TYPE string VALUE 'Position',
            lc_linestyle    TYPE string VALUE 'LineStyle',
            lc_weight       TYPE string VALUE 'Weight',
            lc_92d050       TYPE string VALUE '#92D050',
            lc_solid        TYPE string VALUE 'Solid',
            lc_center       TYPE string VALUE 'Center',
            lc_bottom       TYPE string VALUE 'Bottom',
            lc_one          TYPE string VALUE '1',
            lc_continuous   TYPE string VALUE 'Continuous',
            lc_left         TYPE string VALUE 'Left',
            lc_right        TYPE string VALUE 'Right',
            lc_top          TYPE string VALUE 'Top',
            lc_border       TYPE string VALUE 'Border',
            lc_borders      TYPE string VALUE 'Borders',
            lc_ffff33       TYPE string VALUE '#FFFF33',
            lc_report       TYPE string VALUE 'Report',
            lc_name         TYPE string VALUE 'Name',
            lc_full_columns TYPE string VALUE 'FullColumns',
            lc_full_rows    TYPE string VALUE 'FullRows',
            lc_width        TYPE string VALUE 'Width',
            lc_column       TYPE string VALUE 'Column',
            lc_row          TYPE string VALUE 'Row',
            lc_autofit_hght TYPE string VALUE 'AutoFitHeight',
            lc_styleid      TYPE string VALUE 'StyleID',
            lc_type         TYPE string VALUE 'Type',
            lc_string       TYPE string VALUE 'String',
            lc_interior     TYPE string VALUE 'Interior',
            lc_alignment    TYPE string VALUE 'Alignment',
            lc_data         TYPE string VALUE 'Data',
            lc_lastrow      TYPE string VALUE 'LastRow',
            lc_worksheet    TYPE string VALUE 'Worksheet',
            lc_table        TYPE string VALUE 'Table',
            lc_90           TYPE string VALUE '90',
            lc_55           TYPE string VALUE '55',
            lc_50           TYPE string VALUE '50',
            lc_70           TYPE string VALUE '70',
            lc_35           TYPE string VALUE '35',
            lc_60           TYPE string VALUE '60',
            lc_40           TYPE string VALUE '40',
            lc_cell         TYPE string VALUE 'Cell'.


* Creating a ixml Factory
  obj_ixml  = cl_ixml=>create( ).

* Creating the DOM Object Model for Excel file
  obj_document = obj_ixml->create_document( ).

* Create Root Node Excel 'Workbook'
  obj_element_root  = obj_document->create_simple_element( name = lc_workbook  parent = obj_document ).
  obj_element_root->set_attribute( name = lc_xmlns  value =  lc_value ).
  obj_ns_attribute = obj_document->create_namespace_decl( name = lc_ss  prefix = lc_xmlns  uri = lc_value  ).
  obj_element_root->set_attribute_node( obj_ns_attribute ).
  obj_ns_attribute = obj_document->create_namespace_decl( name = lc_x  prefix = lc_xmlns  uri = lc_excel ).
  obj_element_root->set_attribute_node( obj_ns_attribute ).

* Create node for document properties.
  obj_element_pro = obj_document->create_simple_element( name = lc_doc_p  parent = obj_element_root ).
  v_value = lc_bc_rdwd.

* Excel file author
  obj_document->create_simple_element( name = lc_author  value = v_value parent = obj_element_pro  ).

* Excel Styles
  obj_styles = obj_document->create_simple_element( name = lc_styles   parent = obj_element_root  ).

* Style, alignment, font and border setting for Header
  obj_style  = obj_document->create_simple_element( name = lc_style   parent = obj_styles  ).
  obj_style->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_header ).
  obj_format  = obj_document->create_simple_element( name = lc_font  parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_bold  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_interior parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_color  prefix = lc_ss value = lc_92d050 ).
  obj_format->set_attribute_ns( name = lc_pattern prefix = lc_ss  value = lc_solid ).
  obj_format  = obj_document->create_simple_element( name = lc_alignment parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_vertical  prefix = lc_ss  value = lc_center ).
  obj_format->set_attribute_ns( name = lc_wraptext  prefix = lc_ss  value = lc_one ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Style for Data in Excel file
  obj_style1  = obj_document->create_simple_element( name = lc_style parent = obj_styles  ).
  obj_style1->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_data ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style1 ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Style, for LastRow
  obj_style2  = obj_document->create_simple_element( name = lc_style parent = obj_styles  ).
  obj_style2->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_lastrow ).
  obj_format  = obj_document->create_simple_element( name = lc_font  parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_bold  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_interior parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_color  prefix = lc_ss  value = lc_ffff33 ).
  obj_format->set_attribute_ns( name = lc_pattern prefix = lc_ss  value = lc_solid ).
  obj_format  = obj_document->create_simple_element( name = lc_alignment parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_vertical  prefix = lc_ss  value = lc_center ).
  obj_format->set_attribute_ns( name = lc_wraptext  prefix = lc_ss  value = lc_one ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style2 ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Excel Worksheet1 Data.
  obj_worksheet = obj_document->create_simple_element( name = lc_worksheet parent = obj_element_root ).

* Worksheet Name
  obj_worksheet->set_attribute_ns( name = lc_name  prefix = lc_ss  value = lc_report ).

* Table
  obj_table = obj_document->create_simple_element( name = lc_table  parent = obj_worksheet ).
  obj_table->set_attribute_ns( name = lc_full_columns  prefix = lc_x  value = lc_one ).
  obj_table->set_attribute_ns( name = lc_full_rows     prefix = lc_x  value = lc_one ).

* Excel Column Formatting
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " TR
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_90 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " Tr Type
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_70 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " Text
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " User
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1 Date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_35 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_60 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_60 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_40 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).

* Column Headers Row logic
  obj_row = obj_document->create_simple_element( name = lc_row  parent = obj_table ).
  obj_row->set_attribute_ns( name = lc_autofit_hght  prefix = lc_ss value = lc_one ).
*---------------To----------------
  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-036.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-025.
  obj_data = obj_document->create_simple_element( name = lc_data  value =  v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-037.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-038.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-039.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-040.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-041.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

*----Pass the values to Excel cell
  LOOP AT i_output_det INTO DATA(lst_final).
    obj_row = obj_document->create_simple_element( name = lc_row  parent = obj_table ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-idoc_number.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-po_number.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-material_doc.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-type .
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-id .
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-number .
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-message .
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

  ENDLOOP.

* Creating a Stream Factory for XML
  obj_streamfactory = obj_ixml->create_stream_factory( ).

* Connect Internal XML Table to Stream Factory for Excel data
  obj_ostream = obj_streamfactory->create_ostream_itable( table = i_xml_table ).

* Rendering the Document
  obj_renderer = obj_ixml->create_renderer( ostream  = obj_ostream  document = obj_document ).
  obj_renderer->render( ).

* Saving the XML Document
  obj_ostream->get_num_written_raw( ).
ENDFORM.
* EOC by NPOLINA ERPM2204 6/Jan/2020 ED2K917189
