*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INVENTORY_RECON_DATA_SUB (Include Program)
* PROGRAM DESCRIPTION: Inventory Reconciliation Data
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   12/22/2016
* OBJECT ID:  I0315
* TRANSPORT NUMBER(S): ED2K903838
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED1K908833
* Reference No: INC0223402
* Developer: Rajasekhar.T (RBTIRUMALA)
* Date: 31/01/2018
* Description: To Transfer files from ERR To PRC folder, if the File has
* NO data found
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_SERVERFILE_F4
*&---------------------------------------------------------------------*
*     This perform is for application server F4 help
*----------------------------------------------------------------------*
FORM f_serverfile_f4 USING fp_ap_ph TYPE localfile. " Local file for upload/download

*** Calling FM for F4 help
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = fp_ap_ph
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
*& do nothing
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHK_ASFILE_EXISTS
*&---------------------------------------------------------------------*
*     This perform is to check if application server file exist or not
*----------------------------------------------------------------------*
FORM f_chk_asfile_exists USING    fp_ap_ph    TYPE localfile " Local file for upload/download
                         CHANGING fp_v_path   TYPE localfile " Local file for upload/download
                                  fp_v_drctry TYPE string.
****  Local data declarations
  DATA:
    lv_dir     TYPE pfeflnamel, "Directory
    lv_dir_chk TYPE string,
    lv_i       TYPE i,          " I of type Integers
    lv_name    TYPE localfile,  " Local file for upload/download
    lv_drctry  TYPE localfile.  " Local file for upload/download

  CONSTANTS:
      lc_dot     TYPE char1 VALUE '.'. " Dot of type CHAR1

*** Assigning file path to global variable
  lv_drctry = fp_ap_ph.

  lv_dir_chk = fp_ap_ph.

  IF lv_dir_chk CA lc_dot.
*   if the user input is a file path + file name
    PERFORM f_file_name_split USING lv_drctry CHANGING lv_name.

    IF lv_name IS NOT INITIAL.
      CLEAR lv_dir.
      lv_dir = lv_name.
*     Removing the last slash from the File path address
      CLEAR lv_dir_chk.
      lv_dir_chk = lv_dir.
      CLEAR lv_i.
      lv_i = strlen( lv_dir_chk ).
      lv_i = lv_i - 1.
      lv_dir = lv_dir+0(lv_i).
    ENDIF. " IF lv_name IS NOT INITIAL
  ELSE. " ELSE -> IF lv_dir_chk CA lc_dot
*  If only a directory address is provided.
    CLEAR lv_dir.
    lv_dir = lv_drctry.
  ENDIF. " IF lv_dir_chk CA lc_dot


  IF lv_dir IS NOT INITIAL.
*** Calling FM to get all the file names
    CALL FUNCTION 'RZL_READ_DIR_LOCAL'
      EXPORTING
        name               = lv_dir
      TABLES
        file_tbl           = i_file_names
      EXCEPTIONS
        argument_error     = 1
        not_found          = 2
        no_admin_authority = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
* Implement suitable error handling here
      MESSAGE i075(zqtc_r2). " Please enter a valid file name
      LEAVE LIST-PROCESSING.
    ELSE. " ELSE -> IF sy-subrc <> 0
      fp_v_path   = lv_dir.
      fp_v_drctry = lv_dir.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lv_dir IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_APPL_DATA_SOH
*&---------------------------------------------------------------------*
* This perform is used for uploading application server data for SOH file
*----------------------------------------------------------------------*
FORM f_upload_appl_data_soh .
****  Local Data Declaration
  DATA: lst_string   TYPE string,           "Workarea for data
        lv_subrc     TYPE sy-subrc,         " ABAP System Field: Return Code of ABAP Statements
        lst_msg      TYPE ty_msg,
        lst_soh      TYPE ty_soh,
        lv_filepath  TYPE string,
        lv_f1        TYPE string,
        lv_f2        TYPE string,
        lv_int       TYPE i,                " Int of type Integers
        lv_name      TYPE char3,            " Name of type CHAR3
        lv_ext1      TYPE char10,           " Ext1 of type CHAR10
        lst_inv_rcon TYPE zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lv_col       TYPE i.                " Col of type Integers

*** Local Constant Declaration
  CONSTANTS: lc_d   TYPE char1 VALUE '.', " D of type CHAR1
             lc_csv TYPE char3 VALUE 'CSV'. " Csv of type CHAR3

  IF i_file_names IS NOT INITIAL.
    LOOP AT i_file_names INTO st_file_names. " loop in file names
      CONCATENATE v_drctry c_slash st_file_names-name
                INTO v_file.
      IF v_file IS NOT INITIAL.
        lv_filepath = v_file.
        SPLIT lv_filepath AT lc_d INTO lv_f1 lv_f2.
        lv_ext1 = lv_f2.
        SET LOCALE LANGUAGE sy-langu.
        TRANSLATE lv_ext1 TO UPPER CASE.
        IF lv_ext1 EQ lc_csv. " checking file format is .csv or not
          st_file_names1 = st_file_names.
          APPEND st_file_names1 TO i_file_names1.
          CLEAR st_file_names1.
        ENDIF. " IF lv_ext1 EQ lc_csv
      ENDIF. " IF v_file IS NOT INITIAL
    ENDLOOP. " LOOP AT i_file_names INTO st_file_names
  ENDIF. " IF i_file_names IS NOT INITIAL

  i_file_names2 = i_file_names1.
  REFRESH i_file_names1.

  IF i_file_names2 IS NOT INITIAL.
    LOOP AT i_file_names2 INTO st_file_names.
      lv_name = st_file_names-name+0(3).
      TRANSLATE lv_name TO UPPER CASE.
      IF lv_name = c_soh. " checking file name SOH or not
        st_file_names1 = st_file_names.
        APPEND st_file_names1 TO i_file_names1.
        CLEAR st_file_names1.
      ENDIF. " IF lv_name = c_soh
    ENDLOOP. " LOOP AT i_file_names2 INTO st_file_names
  ENDIF. " IF i_file_names2 IS NOT INITIAL

  CLEAR: st_file_names.
  lv_subrc = 0.
  "refreshing i_soh for the next time
  REFRESH i_soh.

  IF i_file_names1 IS NOT INITIAL.
    LOOP AT i_file_names1 INTO st_file_names.
      lv_subrc = 0.
      CONCATENATE v_drctry c_slash st_file_names-name
           INTO v_file.
      IF v_file IS INITIAL.
        MESSAGE i080(zqtc_r2) INTO lst_msg-text.
        TRANSLATE st_file_names-name TO LOWER CASE.
        lst_msg-zsource = st_file_names-name.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE. " ELSE -> IF v_file IS INITIAL
        lv_col = lv_col + 1.
        OPEN DATASET v_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
        " opening file in application server
        IF sy-subrc NE 0.
          MESSAGE i076(zqtc_r2) INTO lst_msg-text. " File cannot be opened
          TRANSLATE st_file_names-name TO LOWER CASE.
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ELSE. " ELSE -> IF sy-subrc NE 0
          WHILE lv_subrc = 0.
            DATA(lv_indx) = sy-index.
            CLEAR: lst_string,
                   lst_soh.
            READ DATASET v_file INTO lst_string. " Reading the file
            IF sy-subrc = 0.
              SPLIT lst_string AT c_comma INTO
               lst_soh-jgc
               lst_soh-jy
               lst_soh-iss
               lst_soh-uid
               lst_soh-jt
               lst_soh-idt
               lst_soh-soh
               lst_soh-mdt
               lst_soh-iv
               lst_soh-itv
               lst_soh-in
               lst_soh-itn
               lst_soh-ip
               lst_soh-itp
*               lst_soh-dp
               lst_soh-grd.

* To remove the header record in each file as we can't check for
* first record we are doing this check.
              IF cb_ih EQ abap_true AND lv_indx = 1.
                CONTINUE.
                lv_subrc = 4 .
              ENDIF.
              lst_soh-col = lv_col.
              TRANSLATE st_file_names-name TO LOWER CASE.
              lst_soh-fnam = st_file_names-name.

              APPEND lst_soh TO i_soh.
              CLEAR: lst_soh, lst_string.
            ELSE. " ELSE -> IF sy-subrc = 0
              lv_subrc = 4 .
            ENDIF. " IF sy-subrc = 0
          ENDWHILE.
          CLOSE DATASET v_file. " closing the file
        ENDIF. " IF sy-subrc NE 0

      ENDIF. " IF v_file IS INITIAL
    ENDLOOP. " LOOP AT i_file_names1 INTO st_file_names
  ENDIF. " IF i_file_names1 IS NOT INITIAL

  IF i_soh[] IS INITIAL.
    LOOP AT i_file_names1 INTO st_file_names.
      MESSAGE i081(zqtc_r2). " File has no records
      TRANSLATE st_file_names-name TO LOWER CASE.
      lst_msg-zsource = st_file_names-name.
      APPEND lst_msg TO i_errlog_msgs.
      CLEAR lst_msg.
    ENDLOOP.
* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
    CLEAR i_err_tmp[].
    IF NOT i_errlog_msgs IS INITIAL.
      i_err_tmp[] = i_errlog_msgs[].
      CLEAR i_errlog_msgs[].
    ENDIF.
    PERFORM f_mv_to_pro_folder. " perform to move to processed folder
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
  ENDIF. " IF cb_ih EQ abap_true

  LOOP AT i_soh INTO lst_soh.
    lst_inv_rcon-zadjtyp = c_soh.
    lst_inv_rcon-matnr = lst_soh-uid.
    lst_inv_rcon-zevent = 'Goods Receipt'(t01).
    lst_soh-mdt  = lst_soh-grd+0(8).

    IF lst_soh-mdt IS INITIAL.

      MESSAGE i145(zqtc_r2) WITH lst_inv_rcon-matnr
                            INTO lst_msg-text. " Quantity is negative for material &
      lst_msg-zsource = lst_soh-fnam.
      APPEND lst_msg TO i_errlog_msgs.
      CLEAR lst_msg.

    ELSE.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
      lst_inv_rcon-zmaildt = sy-datum.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

      PERFORM f_pop_date USING lst_soh-mdt
                         CHANGING lst_inv_rcon-zdate.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = lst_inv_rcon-zdate
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc <> 0.
        MESSAGE i254(zqtc_r2) WITH lst_inv_rcon-zdate
                              INTO lst_msg-text. " Invalid Date Format &.
        lst_msg-zsource = lst_soh-fnam.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ENDIF.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    ENDIF.

* Begin of CHANGE:DEL:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
*    IF lst_soh-mdt IS NOT INITIAL.
*      PERFORM f_pop_date USING lst_soh-mdt
*                         CHANGING lst_inv_rcon-zdate.
*    ENDIF. " IF lst_soh-grd IS NOT INITIAL
* Begin of CHANGE:DEL:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    IF lst_soh-soh IS NOT INITIAL.
      IF lst_soh-soh CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text. " Quantity is negative for material &
        lst_msg-zsource = lst_soh-fnam.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_soh-soh
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zsohqty = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                            INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_soh-fnam.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_soh-soh IS NOT INITIAL

    lst_inv_rcon-zsource = lst_soh-fnam.
    lst_inv_rcon-zsysdate = sy-datum.
    APPEND lst_inv_rcon TO i_inv_rcon.
    CLEAR lst_inv_rcon.
  ENDLOOP. " LOOP AT i_soh INTO lst_soh
*  ENDIF. " IF i_soh[] IS INITIAL

  i_file_names = i_file_names1.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_CUST_TABL
*&---------------------------------------------------------------------*
*   This perform is used to update the custom table
*----------------------------------------------------------------------*

FORM f_update_cust_tabl .

*** Local Constant Declaration
  CONSTANTS: lc_etab TYPE dd26e-enqmode   VALUE 'E',                "Error
             lc_tab  TYPE rstable-tabname VALUE 'ZQTC_INVEN_RECON'. "Tab

*** Local Data Declaration
  DATA: li_inv_rcon  TYPE STANDARD TABLE OF zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lv_subrc     TYPE sy-subrc,                           " ABAP System Field: Return Code of ABAP Statements
        lst_inv_rcon TYPE zqtc_inven_recon,                   " Table for Inventory Reconciliation Data
        lv_temp      TYPE sydatum.                            " System Date


  PERFORM populate_seq_num_int_tab.

  li_inv_rcon = i_inv_rcon. " assigning to local internal tbl

* BOC on 18-DEC-2017 by PBANDLAPAL for ERP-5708 : ED2K909595
*  READ TABLE li_inv_rcon INTO lst_inv_rcon INDEX 1.
*  IF sy-subrc IS INITIAL.
*    IF lst_inv_rcon-zadjtyp = c_soh. " for SOH files
**** Locking custom table
*      CALL FUNCTION 'ENQUEUE_E_TABLE'
*        EXPORTING
*          mode_rstable   = lc_etab
*          tabname        = lc_tab
*          _wait          = abap_true
*        EXCEPTIONS
*          foreign_lock   = 1
*          system_failure = 2
*          OTHERS         = 3.
*      IF sy-subrc IS INITIAL.
*        DELETE FROM zqtc_inven_recon WHERE zadjtyp = lst_inv_rcon-zadjtyp
*                                       AND zsysdate NE sy-datum.
*        " Deleting from DB table
*        IF sy-subrc = 0.
*          COMMIT WORK AND WAIT.
*        ELSE. " ELSE -> IF sy-subrc = 0
*          ROLLBACK WORK.
*        ENDIF. " IF sy-subrc = 0
*      ENDIF. " IF sy-subrc IS INITIAL
**** Unlocking custom table
*      CALL FUNCTION 'DEQUEUE_E_TABLE'
*        EXPORTING
*          mode_rstable = lc_etab
*          tabname      = lc_tab.
*    ELSE. " ELSE -> IF lst_inv_rcon-zadjtyp = c_soh
*
*      lv_temp = sy-datum.
*      lv_temp = lv_temp - 60. " 60 days old date
**** Locking custom table
*      CALL FUNCTION 'ENQUEUE_E_TABLE'
*        EXPORTING
*          mode_rstable   = lc_etab
*          tabname        = lc_tab
*          _wait          = abap_true
*        EXCEPTIONS
*          foreign_lock   = 1
*          system_failure = 2
*          OTHERS         = 3.
*      IF sy-subrc IS INITIAL.
*        DELETE FROM zqtc_inven_recon WHERE zsysdate LE lv_temp
*                                     AND zadjtyp = lst_inv_rcon-zadjtyp.
*        " Deleting from DB table
*        IF sy-subrc = 0.
*
*          COMMIT WORK AND WAIT.
*        ELSE. " ELSE -> IF sy-subrc = 0
*          ROLLBACK WORK.
*        ENDIF. " IF sy-subrc = 0
*      ENDIF. " IF sy-subrc IS INITIAL
*
**** Unlocking custom table
*      CALL FUNCTION 'DEQUEUE_E_TABLE'
*        EXPORTING
*          mode_rstable = lc_etab
*          tabname      = lc_tab.
*    ENDIF. " IF lst_inv_rcon-zadjtyp = c_soh
* EOC on 18-DEC-2017 by PBANDLAPAL for ERP-5708 : ED2K909595
  IF li_inv_rcon IS NOT INITIAL.
*** Locking custom table
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        mode_rstable   = lc_etab
        tabname        = lc_tab
        _wait          = abap_true
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc = 0.
      MODIFY zqtc_inven_recon FROM TABLE li_inv_rcon.
      " modifying DB table
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        lv_subrc = 0.
        MESSAGE i003(zqtc_r2) DISPLAY LIKE 'S'. " File uploaded Successfully
      ELSE. " ELSE -> IF sy-subrc = 0
        ROLLBACK WORK.
        lv_subrc = 4.
      ENDIF. " IF sy-subrc = 0
*** Unlocking custom table
      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          mode_rstable = lc_etab
          tabname      = lc_tab.

      IF lv_subrc EQ 0 AND v_ap_path IS NOT INITIAL.

        PERFORM f_mv_to_pro_folder. " perform to move to processed folder
      ENDIF. " IF lv_subrc EQ 0 AND v_ap_path IS NOT INITIAL

    ELSE. " ELSE -> IF sy-subrc = 0
      MESSAGE i078(zqtc_r2). " Table is locked
    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF li_inv_rcon IS NOT INITIAL
* BOC on 18-DEC-2017 by PBANDLAPAL for CR#590 : ED2K909595
*  ENDIF. " IF sy-subrc IS INITIAL
* EOC on 18-DEC-2017 by PBANDLAPAL for CR#590 : ED2K909595
  REFRESH li_inv_rcon.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MV_TO_PRO_FOLDER
*&---------------------------------------------------------------------*
*    This perform is used to move files to processed folder
*----------------------------------------------------------------------*
FORM f_mv_to_pro_folder .

* Type declaration
  TYPES : BEGIN OF lty_constant,
            devid  TYPE zdevid,              " Development ID
            param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_constant.

*** Local Data declaration
  DATA: li_const         TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0,
        lst_const        TYPE lty_constant,
        lv_sfile_t       TYPE localfile, " Local file for upload/download
        lv_pfile_t       TYPE localfile, " '/intf/tib/dev/sap/prc',
        lv_sfile         TYPE localfile, " Local file for upload/download
        lv_length        TYPE i,         " Length of type Integers
        lst_prc_files    TYPE zqtc_inven_recon,
        lst_errlog_files TYPE ty_msg,
        lv_file_name_lc  TYPE pfeflname,
        lv_param1        TYPE rvari_vnam,
        lv_arg           TYPE btcxpgpar, "Parameter of external program
        lv_fnm           TYPE char50.    " Fnm of type CHAR50

*** Local Constant declaration
  CONSTANTS: lc_opsystem  TYPE syopsys    VALUE 'Linux',          "## NO TEXT
             lc_dev_id    TYPE zdevid     VALUE 'I0315',          " Type of Identification Code
             lc_fold_name TYPE rvari_vnam VALUE 'PROCESS_FOLDER', " Promotion code for variant variable
             lc_jdr       TYPE rvari_vnam VALUE 'I0315_JDR',    " Promotion code for variant variable
             lc_bios      TYPE rvari_vnam VALUE 'I0315_BIOS',   " Promotion code for variant variable
             lc_jrr       TYPE rvari_vnam VALUE 'I0315_JRR',    " Promotion code for variant variable
             lc_soh       TYPE rvari_vnam VALUE 'I0315_SOH'.    " Promotion code for variant variable

  CLEAR lv_param1.
  IF     rb_soh   IS NOT INITIAL.
    lv_param1 = lc_soh.
  ELSEIF rb_bios  IS NOT INITIAL.
    lv_param1 = lc_bios.
  ELSEIF rb_jdr   IS NOT INITIAL.
    lv_param1 = lc_jdr.
  ELSEIF rb_jrr   IS NOT INITIAL.
    lv_param1 = lc_jrr.
  ENDIF.

* Fetch Folder name from constant table.
* (ZCACONSTANT table is hit for the second time as the Dev. ID
* and Parameters are different from the above where clause

  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_const
    WHERE devid    = lc_dev_id
      AND param1   = lv_param1
      AND param2   = lc_fold_name
      AND activate = abap_true.

  IF sy-subrc EQ 0.
    SORT li_const BY devid param1.
    CLEAR lst_const.
    READ TABLE li_const INTO lst_const WITH KEY devid    = lc_dev_id
                                                param1   = lv_param1
                                                param2   = lc_fold_name
                                                BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lv_pfile_t = lst_const-low.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc EQ 0

  lv_fnm = v_drctry.
  lv_length = strlen( lv_fnm ).
  lv_length = lv_length - 1.
  IF lv_fnm+lv_length(1) NE c_slash. " checking last char
    CONCATENATE lv_fnm c_slash INTO lv_fnm.
  ENDIF. " IF lv_fnm+lv_length(1) NE c_slash

* To move all the error log messages to new internal table and
* to get only the error file names.

* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
  IF NOT i_err_tmp[] IS INITIAL.
    MOVE-CORRESPONDING i_err_tmp[] TO i_prc_files[].
  ELSEIF NOT i_inv_rcon[] IS INITIAL.
    i_prc_files[] = i_inv_rcon[].
  ENDIF.
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
* Begin of CHANGE:DEL:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
*  i_prc_files[] = i_inv_rcon[].
* End of CHANGE:DEL:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
  SORT i_prc_files BY zsource.
  DELETE ADJACENT DUPLICATES FROM i_prc_files COMPARING zsource.

  LOOP AT i_file_names INTO st_file_names. " loop in file names
    CLEAR: lst_prc_files,
           lv_file_name_lc.
    lv_file_name_lc = st_file_names-name.
    TRANSLATE lv_file_name_lc TO LOWER CASE.
    READ TABLE i_prc_files INTO lst_prc_files WITH KEY zsource = lv_file_name_lc.
    IF sy-subrc EQ 0.
      CONCATENATE lv_fnm st_file_names-name
      INTO lv_sfile.

      lv_sfile_t = lv_sfile.

      CONCATENATE lv_sfile_t
                  lv_pfile_t
                INTO lv_arg SEPARATED BY space. " preparing additional parameter
*** Calling FM to Move file from one dir to another dir

      CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
        EXPORTING
          commandname                   = 'ZSSPMOVE'
          additional_parameters         = lv_arg
          operatingsystem               = lc_opsystem
        EXCEPTIONS
          no_permission                 = 1
          command_not_found             = 2
          parameters_too_long           = 3
          security_risk                 = 4
          wrong_check_call_interface    = 5
          program_start_error           = 6
          program_termination_error     = 7
          x_error                       = 8
          parameter_expected            = 9
          too_many_parameters           = 10
          illegal_command               = 11
          wrong_asynchronous_parameters = 12
          cant_enq_tbtco_entry          = 13
          jobcount_generation_error     = 14
          OTHERS                        = 15.
      IF sy-subrc <> 0.
        MESSAGE i084(zqtc_r2). " File cannot be moved to processed folder
      ELSE.
        MESSAGE i148(zqtc_r2) WITH st_file_names-name.
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
    CLEAR st_file_names.
  ENDLOOP. " LOOP AT i_file_names INTO st_file_names

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MV_TO_ERR_FOLDER
*&---------------------------------------------------------------------*
*     This perform is used to move files to error folder
*----------------------------------------------------------------------*
FORM f_mv_to_err_folder .

* Type declaration
  TYPES : BEGIN OF lty_constant,
            devid  TYPE zdevid,              " Development ID
            param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_constant.

*** Local Data declaration
  DATA: li_const         TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0,
        lst_const        TYPE lty_constant,
        lv_sfile_t       TYPE localfile, " Local file for upload/download
        lv_efile_t       TYPE localfile, " '/intf/tib/dev/sap/err',
        lv_sfile         TYPE localfile, " Local file for upload/download
        lv_length        TYPE i,         " Length of type Integers
        lv_length_err    TYPE i,
        lv_fnm_err       TYPE string,
        lv_param1        TYPE rvari_vnam,
        lv_time_stmp     TYPE /ipro/timestamp, " Time in CHAR Format
        lv_time_stmp_s   TYPE string,
        lv_fname         TYPE string,
        lv_file_name     TYPE char40,
        lst_errlog_files TYPE ty_msg,
        lst_errlog_msgs  TYPE ty_msg,
        lv_arg           TYPE btcxpgpar, "Parameter of external program
        lv_fnm           TYPE char50.    " Fnm of type CHAR50

*** Local constant declaration
  CONSTANTS: lc_opsystem  TYPE syopsys    VALUE 'Linux',        " ## NO TEXT
             lc_dev_id    TYPE zdevid     VALUE 'I0315',        " Type of Identification Code
             lc_fold_name TYPE rvari_vnam VALUE 'ERROR_FOLDER', " Promotion code for variant variable
             lc_bios      TYPE rvari_vnam VALUE 'I0315_BIOS',   " Promotion code for variant variable
             lc_jdr       TYPE rvari_vnam VALUE 'I0315_JDR',    " Promotion code for variant variable
             lc_jrr       TYPE rvari_vnam VALUE 'I0315_JRR',    " Promotion code for variant variable
             lc_soh       TYPE rvari_vnam VALUE 'I0315_SOH'.    " Promotion code for variant variable

  CLEAR lv_param1.
  IF     rb_soh   IS NOT INITIAL.
    lv_param1 = lc_soh.
  ELSEIF rb_bios  IS NOT INITIAL.
    lv_param1 = lc_bios.
  ELSEIF rb_jdr   IS NOT INITIAL.
    lv_param1 = lc_jdr.
  ELSEIF rb_jrr   IS NOT INITIAL.
    lv_param1 = lc_jrr.
  ENDIF.

* Fetch Folder name from constant table.
* (ZCACONSTANT table is hit for the second time as the Dev. ID
* and Parameters are different from the above where clause

  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_const
    WHERE devid    = lc_dev_id
      AND param1   = lv_param1
      AND param2   = lc_fold_name
      AND activate = abap_true.

  IF sy-subrc EQ 0.
    SORT li_const BY devid param1.
    CLEAR lst_const.
    READ TABLE li_const INTO lst_const WITH KEY devid    = lc_dev_id
                                                param1   = lv_param1
                                                param2   = lc_fold_name
                                                BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lv_efile_t = lst_const-low.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc EQ 0

  lv_fnm = v_drctry.
  lv_length = strlen( lv_fnm ).
  lv_length = lv_length - 1.
  IF lv_fnm+lv_length(1) NE c_slash. " checking last chr
    CONCATENATE lv_fnm c_slash INTO lv_fnm.
  ENDIF. " IF lv_fnm+lv_length(1) NE c_slash

  lv_fnm_err = lv_fnm.
  lv_length_err = strlen( lv_fnm_err ).
  lv_length_err = lv_length_err - 4.
  IF lv_fnm_err+lv_length_err(4) = c_fpath_in.
    REPLACE c_fpath_in IN lv_fnm_err WITH c_fpath_err.
  ENDIF.
* To move all the error log messages to new internal table and
* to get only the error file names.
  i_errlog_files[] = i_errlog_msgs[].
  SORT i_errlog_files BY zsource.
  DELETE ADJACENT DUPLICATES FROM i_errlog_files COMPARING zsource.

  LOOP AT i_file_names INTO st_file_names. " loop in file names
    lv_file_name = st_file_names-name.
    TRANSLATE lv_file_name TO LOWER CASE.
    READ TABLE i_errlog_files INTO lst_errlog_files WITH KEY zsource = lv_file_name.
    IF sy-subrc EQ 0.
      CONCATENATE lv_fnm st_file_names-name
      INTO lv_sfile.

      lv_sfile_t = lv_sfile.

      CONCATENATE lv_sfile_t
                  lv_efile_t
                INTO lv_arg SEPARATED BY space. " preparing additional parameter
* To write/transfer the error log file in the error folder.
      GET TIME STAMP FIELD lv_time_stmp.
      lv_time_stmp_s = lv_time_stmp.

      CONCATENATE lv_fnm_err 'ErrorLog'(t05) c_file_undsc sy-datum c_file_undsc lv_time_stmp_s
                  c_file_undsc st_file_names-name INTO lv_fname.

      CONDENSE lv_fname.

      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
      IF sy-subrc EQ 0.
        LOOP AT i_errlog_msgs INTO lst_errlog_msgs WHERE zsource = lv_file_name.
          TRANSFER lst_errlog_msgs-text TO lv_fname.
        ENDLOOP.
*--SOC by GKAMMILI  ERPM2204 13-Jan-2020 ED2K917189
        st_file_err-data = lv_fname.
        APPEND st_file_err TO i_file_err.
        CLEAR st_file_err.
        CONCATENATE v_drctry st_file_names-name INTO st_filenames-data SEPARATED BY c_slash.
        APPEND st_filenames TO i_filenames.
        CLEAR st_filenames.
*--EOC by GKAMMILI  ERPM2204 13-Jan-2020 ED2K917189
        CLOSE DATASET lv_fname.
      ENDIF.
*** Calling FM to Move file from one dir to another dir

      CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
        EXPORTING
          commandname                   = 'ZSSPMOVE'
          additional_parameters         = lv_arg
          operatingsystem               = lc_opsystem
        EXCEPTIONS
          no_permission                 = 1
          command_not_found             = 2
          parameters_too_long           = 3
          security_risk                 = 4
          wrong_check_call_interface    = 5
          program_start_error           = 6
          program_termination_error     = 7
          x_error                       = 8
          parameter_expected            = 9
          too_many_parameters           = 10
          illegal_command               = 11
          wrong_asynchronous_parameters = 12
          cant_enq_tbtco_entry          = 13
          jobcount_generation_error     = 14
          OTHERS                        = 15.
      IF sy-subrc <> 0.
        MESSAGE i085(zqtc_r2). " File cannot be moved to error folder
      ELSE.
        MESSAGE i147(zqtc_r2) WITH st_file_names-name.
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDLOOP. " LOOP AT i_file_names INTO st_file_names
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_APPL_DATA_BIOS
*&---------------------------------------------------------------------*
*    This perform is used for uploading application data for BIOS file
*----------------------------------------------------------------------*
FORM f_upload_appl_data_bios .
****  Local Data Declaration
  DATA: lst_string   TYPE string,           "Workarea for data
        lst_msg      TYPE ty_msg,
        lst_bios     TYPE ty_bios,
        lst_inv_rcon TYPE zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lv_subrc     TYPE sy-subrc,         " ABAP System Field: Return Code of ABAP Statements
        lv_filepath  TYPE string,
        lv_name      TYPE char4,            " Name of type CHAR4
        lv_adjd      TYPE string,
        lv_f1        TYPE string,
        lv_f2        TYPE string,
        lv_int       TYPE i,                " Int of type Integers
        lv_ext1      TYPE char10,           " Ext1 of type CHAR10
        lv_col       TYPE i,                " Col of type Integers
        lv_len       TYPE i. " I of type Integers

*** Local Constant Declaration
  CONSTANTS: lc_d    TYPE char1 VALUE '.', " D of type CHAR1
             lc_csv  TYPE char3 VALUE 'CSV',  " Csv of type CHAR3
             lc_bios TYPE char4 VALUE 'BIOS'. " Bios of type CHAR4

  IF i_file_names IS NOT INITIAL.
    LOOP AT i_file_names INTO st_file_names. " loop at file names
      CONCATENATE v_drctry c_slash st_file_names-name
                INTO v_file.
      IF v_file IS NOT INITIAL.
        lv_filepath = v_file.
        SPLIT lv_filepath AT lc_d INTO lv_f1 lv_f2.
        lv_ext1 = lv_f2.
        SET LANGUAGE sy-langu.
        TRANSLATE lv_ext1 TO UPPER CASE.
        IF lv_ext1 EQ lc_csv. " checking if the file type is .csv or not
          st_file_names1 = st_file_names.
          APPEND st_file_names1 TO i_file_names1.
          CLEAR st_file_names1.
        ENDIF. " IF lv_ext1 EQ lc_csv
      ENDIF. " IF v_file IS NOT INITIAL
    ENDLOOP. " LOOP AT i_file_names INTO st_file_names
  ENDIF. " IF i_file_names IS NOT INITIAL

  i_file_names2 = i_file_names1.
  REFRESH i_file_names1.

  IF i_file_names2 IS NOT INITIAL.
    LOOP AT i_file_names2 INTO st_file_names.
      lv_name = st_file_names-name+0(4).
      TRANSLATE lv_name TO UPPER CASE.
      IF lv_name = lc_bios. "'BIOS'." checking the file name
        st_file_names1 = st_file_names.
        APPEND st_file_names1 TO i_file_names1.
        CLEAR st_file_names1.
      ENDIF. " IF lv_name = lc_bios
    ENDLOOP. " LOOP AT i_file_names2 INTO st_file_names
  ENDIF. " IF i_file_names2 IS NOT INITIAL

  CLEAR: st_file_names.
  lv_subrc = 0.
  REFRESH i_bios.
  IF i_file_names1 IS NOT INITIAL.
    LOOP AT i_file_names1 INTO st_file_names.
      lv_subrc = 0.
      "refreshing i_bios for the next time
      CONCATENATE v_drctry c_slash st_file_names-name
           INTO v_file.
      IF v_file IS INITIAL.
        MESSAGE i080(zqtc_r2) INTO lst_msg-text. " Please enter a valid file name.
        lst_msg-zsource = st_file_names-name.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE. " ELSE -> IF v_file IS INITIAL
        lv_col = lv_col + 1.
        OPEN DATASET v_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
        " opening the file
        IF sy-subrc NE 0.
          MESSAGE i076(zqtc_r2) INTO lst_msg-text. " File cannot be opened
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ELSE. " ELSE -> IF sy-subrc NE 0
          WHILE lv_subrc = 0.
            DATA(lv_indx) = sy-index.
            CLEAR: lst_string,
                   lst_bios.
            READ DATASET v_file INTO lst_string.
            " reading the file
            IF sy-subrc = 0.
              SPLIT lst_string AT c_comma INTO
              lst_bios-jgc
              lst_bios-pbs
              lst_bios-uid
              lst_bios-adjt
              lst_bios-adjq
              lst_bios-adjn
              lst_bios-adjd.
* To remove the header record in each file as we can't check for
* first record we are doing this check.
              IF cb_ih EQ abap_true AND lv_indx = 1.
                CONTINUE.
                lv_subrc = 4 .
              ENDIF.
              lst_bios-col = lv_col.
              TRANSLATE st_file_names-name TO LOWER CASE.
              lst_bios-fnam = st_file_names-name.
              APPEND lst_bios TO i_bios.
              CLEAR:  lst_bios,lst_string.

            ELSE. " ELSE -> IF sy-subrc = 0
              lv_subrc = 4 .
            ENDIF. " IF sy-subrc = 0
          ENDWHILE.
          CLOSE DATASET v_file.
          " closing the file
        ENDIF. " IF sy-subrc NE 0

      ENDIF. " IF v_file IS INITIAL
    ENDLOOP. " LOOP AT i_file_names1 INTO st_file_names
  ENDIF. " IF i_file_names1 IS NOT INITIAL

  IF i_bios[] IS INITIAL.
* To populate the error file names so that we can move it to the error folder.
    CLEAR: lst_msg,
           st_file_names.
    LOOP AT i_file_names1 INTO st_file_names.
      MESSAGE i081(zqtc_r2) INTO lst_msg-text. " File has no records
      TRANSLATE st_file_names-name TO LOWER CASE.
      lst_msg-zsource = st_file_names-name.
      APPEND lst_msg TO i_errlog_msgs.
      CLEAR: lst_msg,
             st_file_names.
    ENDLOOP.
* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
    CLEAR i_err_tmp[].
    IF NOT i_errlog_msgs IS INITIAL.
      i_err_tmp[] = i_errlog_msgs[].
      CLEAR i_errlog_msgs[].
    ENDIF.
    PERFORM f_mv_to_pro_folder. " perform to move to processed folder
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
  ENDIF.

  LOOP AT i_bios INTO lst_bios. " preparing the internal tbl of custom tbl

    lst_inv_rcon-zadjtyp = lst_bios-adjt.
    lst_inv_rcon-matnr = lst_bios-uid.

    IF lst_bios-adjq IS NOT INITIAL.
      IF lst_bios-adjq CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text. " Quantity is negative for material &
        lst_msg-zsource = lst_bios-fnam.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_bios-adjq
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zadjqty = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                                INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_bios-fnam.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_bios-adjq IS NOT INITIAL

    IF lst_bios-adjd IS NOT INITIAL.

      PERFORM f_pop_date USING lst_bios-adjd
                         CHANGING lst_inv_rcon-zdate.

* begin of change:add:ritm0079465:rbtirumala:26/10/2018:ed1k908833
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = lst_inv_rcon-zdate
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc <> 0.
        MESSAGE i254(zqtc_r2) WITH lst_inv_rcon-zdate
                              INTO lst_msg-text. " Invalid Date Format &.
        lst_msg-zsource = lst_bios-fnam.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ENDIF.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    ELSE.
      lst_bios-adjd = sy-datum.
    ENDIF.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
    lst_inv_rcon-zmaildt = sy-datum.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    lst_inv_rcon-zevent = 'Adjustment Date'(t02).
    lst_inv_rcon-zsource = lst_bios-fnam.
    lst_inv_rcon-zsysdate = sy-datum.

    APPEND lst_inv_rcon TO i_inv_rcon.
    CLEAR lst_inv_rcon.
  ENDLOOP. " LOOP AT i_bios INTO lst_bios

  i_file_names = i_file_names1.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_APPL_DATA_JDR
*&---------------------------------------------------------------------*
*     This perform is for application server data upload for JDR file
*----------------------------------------------------------------------*
FORM f_upload_appl_data_jdr .
****  Local Data Declaration
  DATA: lst_string   TYPE string,           "Workarea for data
        lst_jdr      TYPE ty_jdr,
        lst_msg      TYPE ty_msg,
        lst_inv_rcon TYPE zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lv_subrc     TYPE sy-subrc,         " ABAP System Field: Return Code of ABAP Statements
        lv_filepath  TYPE string,
        lv_name      TYPE char3,            " Name of type CHAR3
        lv_f1        TYPE string,
        lv_f2        TYPE string,
        lv_ext1      TYPE char10,           " Ext1 of type CHAR10
        lv_int       TYPE i,                " Int of type Integers
        lv_col       TYPE i.                " Col of type Integers

*** Local Constant Declaration
  CONSTANTS: lc_d   TYPE char1 VALUE '.', " D of type CHAR1
             lc_csv TYPE char3 VALUE 'CSV',
             lc_jdr TYPE zadjtyp VALUE 'JDR'. " Adjustment Type

  IF i_file_names IS NOT INITIAL.
    LOOP AT i_file_names INTO st_file_names.
      CONCATENATE v_drctry c_slash st_file_names-name
                INTO v_file.
      IF v_file IS NOT INITIAL.
        lv_filepath = v_file.
        SPLIT lv_filepath AT lc_d INTO lv_f1 lv_f2.
        SET LOCALE LANGUAGE sy-langu.
        lv_ext1 = lv_f2.
        TRANSLATE lv_ext1 TO UPPER CASE.
*        IF lv_ext1 EQ lc_txt. " checking the file type
        IF lv_ext1 EQ lc_csv. " checking the file type
          st_file_names1 = st_file_names.
          APPEND st_file_names1 TO i_file_names1.
          CLEAR st_file_names1.
        ENDIF. " IF lv_ext1 EQ lc_txt
      ENDIF. " IF v_file IS NOT INITIAL
    ENDLOOP. " LOOP AT i_file_names INTO st_file_names
  ENDIF. " IF i_file_names IS NOT INITIAL

  i_file_names2 = i_file_names1.
  REFRESH i_file_names1.

  IF i_file_names2 IS NOT INITIAL.
    LOOP AT i_file_names2 INTO st_file_names.
      lv_name = st_file_names-name+0(3).
      TRANSLATE lv_name TO UPPER CASE.
      IF lv_name = lc_jdr . "'JDR'." checking the file name
        st_file_names1 = st_file_names.
        APPEND st_file_names1 TO i_file_names1.
        CLEAR st_file_names1.
      ENDIF. " IF lv_name = lc_jdr
    ENDLOOP. " LOOP AT i_file_names2 INTO st_file_names
  ENDIF. " IF i_file_names2 IS NOT INITIAL
  CLEAR: st_file_names.
  lv_subrc = 0.

  REFRESH i_jdr.
  IF i_file_names1 IS NOT INITIAL.
    LOOP AT i_file_names1 INTO st_file_names. " loop at file names
      " refreshing i_jdr for the next time

      CONCATENATE v_drctry c_slash st_file_names-name
           INTO v_file.
      IF v_file IS INITIAL.
        MESSAGE i077(zqtc_r2) INTO lst_msg-text. " File is blank.
        TRANSLATE st_file_names-name TO LOWER CASE.
        lst_msg-zsource = st_file_names-name.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE. " ELSE -> IF v_file IS INITIAL
        lv_col = lv_col + 1.
        OPEN DATASET v_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
        " opening the file
        IF sy-subrc NE 0.
          MESSAGE i076(zqtc_r2) INTO lst_msg-text. " File cannot be opened
          TRANSLATE st_file_names-name TO LOWER CASE.
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ELSE. " ELSE -> IF sy-subrc NE 0
          WHILE lv_subrc = 0.
            DATA(lv_indx) = sy-index.
            CLEAR: lst_string,
                   lst_jdr.
            READ DATASET v_file INTO lst_string.
            " reading the file
            IF sy-subrc = 0.
*              SPLIT lst_string AT c_tab INTO
              SPLIT lst_string AT c_comma INTO
              lst_jdr-uid
              lst_jdr-ippd
              lst_jdr-acro
              lst_jdr-vol
              lst_jdr-iss
              lst_jdr-supm
              lst_jdr-part
              lst_jdr-dw
              lst_jdr-mlqty
              lst_jdr-omq
              lst_jdr-cqty
              lst_jdr-ebo
              lst_jdr-office.
* To remove the header record in each file as we can't check for
* first record we are doing this check.
              IF cb_ih EQ abap_true AND lv_indx = 1.
                CONTINUE.
                lv_subrc = 4 .
              ENDIF.

              lst_jdr-col = lv_col.
              TRANSLATE st_file_names-name TO LOWER CASE.
              lst_jdr-fname = st_file_names-name.
              APPEND lst_jdr TO i_jdr.
              CLEAR: lst_jdr, lst_string.
            ELSE. " ELSE -> IF sy-subrc = 0
              lv_subrc = 4.
            ENDIF. " IF sy-subrc = 0
          ENDWHILE.
          CLOSE DATASET v_file.
          " closing the file
          CLEAR lv_subrc.
        ENDIF. " IF sy-subrc NE 0

        IF i_jdr[] IS INITIAL.
* To populate the error logs when the file is blank
*          LOOP AT i_file_names1 INTO st_file_names.
          MESSAGE i077(zqtc_r2) INTO lst_msg-text. " File is blank
          TRANSLATE st_file_names-name TO LOWER CASE.
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
*          ENDLOOP.
        ENDIF.
* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
        CLEAR i_err_tmp[].
        IF NOT i_errlog_msgs IS INITIAL.
          i_err_tmp[] = i_errlog_msgs[].
          CLEAR i_errlog_msgs[].
        ENDIF.
        PERFORM f_mv_to_pro_folder. " perform to move to processed folder
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
      ENDIF. " IF v_file IS INITIAL
    ENDLOOP. " LOOP AT i_file_names1 INTO st_file_names
  ENDIF. " IF i_file_names1 IS NOT INITIAL

  LOOP AT i_jdr INTO lst_jdr. " preparing the internal tbl of custom tbl

    lst_inv_rcon-zadjtyp = lc_jdr. "'JDR'.
    lst_inv_rcon-matnr = lst_jdr-uid.

    IF lst_jdr-ippd IS INITIAL.

      lst_inv_rcon-zdate = sy-datum.

    ELSE.

      PERFORM f_pop_date USING lst_jdr-ippd
                         CHANGING lst_inv_rcon-zdate.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = lst_inv_rcon-zdate
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc <> 0.
        MESSAGE i254(zqtc_r2) WITH lst_inv_rcon-zdate
                              INTO lst_msg-text. " Invalid Date Format &.
        lst_msg-zsource = lst_jdr-fname.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ENDIF.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    ENDIF.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
    lst_inv_rcon-zmaildt = sy-datum.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    IF lst_jdr-mlqty IS NOT INITIAL.
      IF lst_jdr-mlqty CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jdr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jdr-mlqty
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.
        IF sy-subrc EQ 0.
          lst_inv_rcon-zmainlbl =  lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                            INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jdr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_jdr-mlqty IS NOT INITIAL

    IF lst_jdr-omq IS NOT INITIAL.
      IF lst_jdr-omq CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jdr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jdr-omq
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zoffline = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                            INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jdr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_jdr-omq IS NOT INITIAL

    IF lst_jdr-cqty IS NOT INITIAL.
      IF lst_jdr-cqty CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jdr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jdr-cqty
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zconqty = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                                INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jdr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_jdr-cqty IS NOT INITIAL

    IF lst_jdr-ebo IS NOT INITIAL.
      IF lst_jdr-ebo CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jdr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jdr-ebo
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zebo = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                                INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jdr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.

    ENDIF. " IF lst_jdr-ebo IS NOT INITIAL

    lst_inv_rcon-zevent = 'Issue Publication Date'(t03).
*            lst_inv_rcon-matnr = lst_jdr-uid.
    lst_inv_rcon-zsource = lst_jdr-fname.
    lst_inv_rcon-zsysdate = sy-datum.

    APPEND lst_inv_rcon TO i_inv_rcon.
    CLEAR lst_inv_rcon.
  ENDLOOP. " LOOP AT i_jdr INTO lst_jdr

  i_file_names = i_file_names1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_APPL_DATA_JRR
*&---------------------------------------------------------------------*
*     This perform is used to upload application server data for JRR file
*----------------------------------------------------------------------*
FORM f_upload_appl_data_jrr .
****  Local Data Declaration
  DATA: lst_string   TYPE string,           "Workarea for data
        lst_jrr      TYPE ty_jrr,
        lst_msg      TYPE ty_msg,
        lst_fname    TYPE ty_fname,
        lst_inv_rcon TYPE zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lv_subrc     TYPE sy-subrc,         " ABAP System Field: Return Code of ABAP Statements
        lv_filepath  TYPE string,
        lv_name      TYPE char3,            " Name of type CHAR3
        lv_f1        TYPE string,
        lv_f2        TYPE string,
        lv_int       TYPE i,                " Int of type Integers
        lv_ext1      TYPE char10,           " Ext1 of type CHAR10
        lv_col       TYPE i.                " Col of type Integers

*** Local Constant Declaration
  CONSTANTS: lc_d   TYPE char1   VALUE '.', " D of type CHAR1
             lc_csv TYPE char3   VALUE 'CSV', " Txt of type CHAR3  Change of 378
             lc_jrr TYPE zadjtyp VALUE 'JRR'. " Adjustment Type

  IF i_file_names IS NOT INITIAL.

    LOOP AT i_file_names INTO st_file_names. " loop in file names
      CONCATENATE v_drctry c_slash st_file_names-name
                INTO v_file.
      IF v_file IS NOT INITIAL.
        lv_filepath = v_file.
        SPLIT lv_filepath AT lc_d INTO lv_f1 lv_f2.
        lv_ext1 = lv_f2.
        SET LOCALE LANGUAGE sy-langu.
        TRANSLATE lv_ext1 TO UPPER CASE.
*        IF lv_ext1 EQ lc_txt. " checking file type
        IF lv_ext1 EQ lc_csv. " checking file type   " Change of 378
          st_file_names1 = st_file_names.
          APPEND st_file_names1 TO i_file_names1.
          CLEAR st_file_names1.
        ENDIF. " IF lv_ext1 EQ lc_txt
      ENDIF. " IF v_file IS NOT INITIAL
    ENDLOOP. " LOOP AT i_file_names INTO st_file_names
  ENDIF. " IF i_file_names IS NOT INITIAL
  i_file_names2 = i_file_names1.
  REFRESH i_file_names1.

  IF i_file_names2 IS NOT INITIAL.

    LOOP AT i_file_names2 INTO st_file_names.
      lv_name = st_file_names-name+0(3).
      TRANSLATE lv_name TO UPPER CASE.
      IF lv_name = lc_jrr. "'JRR'. " checking file type
        st_file_names1 = st_file_names.
        APPEND st_file_names1 TO i_file_names1.
        CLEAR st_file_names1.
      ENDIF. " IF lv_name = lc_jrr
    ENDLOOP. " LOOP AT i_file_names2 INTO st_file_names

  ENDIF. " IF i_file_names2 IS NOT INITIAL

  CLEAR: st_file_names.
  lv_subrc = 0.

  REFRESH i_jrr.

  IF i_file_names1 IS NOT INITIAL.
    LOOP AT i_file_names1 INTO st_file_names.
      lv_subrc = 0.
      "refreshing i_jrr for the next time

      CONCATENATE v_drctry c_slash st_file_names-name
           INTO v_file.
      IF v_file IS INITIAL.
        MESSAGE i077(zqtc_r2) INTO lst_msg-text. " File is blank
        TRANSLATE st_file_names-name TO LOWER CASE.
        lst_msg-zsource = st_file_names-name.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ELSE. " ELSE -> IF v_file IS INITIAL
        lv_col = lv_col + 1.
        OPEN DATASET v_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
        " opening the file
        IF sy-subrc NE 0.
          MESSAGE i076(zqtc_r2) INTO lst_msg-text. " File cannot be opened
          TRANSLATE st_file_names-name TO LOWER CASE.
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ELSE. " ELSE -> IF sy-subrc NE 0
          WHILE lv_subrc = 0.
            DATA(lv_indx) = sy-index.

            CLEAR: lst_string,
                   lst_jrr.
            READ DATASET v_file INTO lst_string.
            " reading the file
            IF sy-subrc = 0.
*              SPLIT   lst_string AT c_tab INTO
              SPLIT   lst_string AT c_comma INTO       " Change CR 378
                     lst_jrr-uid
                     lst_jrr-stdd
                     lst_jrr-acro
                     lst_jrr-vol
                     lst_jrr-iss
                     lst_jrr-supm
                     lst_jrr-part
                     lst_jrr-opr
                     lst_jrr-qr
                     lst_jrr-wpc
                     lst_jrr-remk
                     lst_jrr-office.
* To remove the header record in each file as we don't need to populate it in internal table.
              IF cb_ih EQ abap_true AND lv_indx = 1.
                CONTINUE.
                lv_subrc = 4 .
              ENDIF.
              lst_jrr-col = lv_col.
              TRANSLATE st_file_names-name TO LOWER CASE.
              lst_jrr-fname = st_file_names-name.
              APPEND lst_jrr TO i_jrr.
              CLEAR: lst_jrr,
                     lst_string.
            ELSE. " ELSE -> IF sy-subrc = 0
              lv_subrc = 4.
            ENDIF. " IF sy-subrc = 0
          ENDWHILE.
          CLOSE DATASET v_file.
          " closing the file
        ENDIF. " IF sy-subrc NE 0

* If no records are found in the file after deleting the header
*  then we populate an error message in the file
        IF i_jrr[] IS INITIAL.
          MESSAGE i081(zqtc_r2) INTO lst_msg-text. " File has no records
          TRANSLATE st_file_names-name TO LOWER CASE.
          lst_msg-zsource = st_file_names-name.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF.
* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
        CLEAR i_err_tmp[].
        IF NOT i_errlog_msgs IS INITIAL.
          i_err_tmp[] = i_errlog_msgs[].
          PERFORM f_mv_to_pro_folder. " perform to move to process folder
          CLEAR : i_errlog_msgs[],i_err_tmp[].
        ENDIF.
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
      ENDIF. " IF v_file IS INITIAL
    ENDLOOP. " LOOP AT i_file_names1 INTO st_file_names
  ENDIF. " IF i_file_names1 IS NOT INITIAL

  LOOP AT i_jrr INTO lst_jrr. " populating internal tbl of custom tbl
    lst_inv_rcon-zadjtyp = lc_jrr. "'JRR'.

    IF lst_jrr-stdd IS NOT INITIAL.
      PERFORM f_pop_date USING lst_jrr-stdd
                         CHANGING lst_inv_rcon-zdate.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = lst_inv_rcon-zdate
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc <> 0.
        MESSAGE i254(zqtc_r2) WITH lst_inv_rcon-zdate
                              INTO lst_msg-text. " Invalid Date Format &.
        lst_msg-zsource = lst_jrr-fname.
        APPEND lst_msg TO i_errlog_msgs.
        CLEAR lst_msg.
      ENDIF.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    ELSE.
      lst_inv_rcon-zdate = sy-datum.
    ENDIF. " IF lst_jrr-stdd IS NOT INITIAL

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
    lst_inv_rcon-zmaildt = sy-datum.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

    IF lst_jrr-opr IS NOT INITIAL.
      IF lst_jrr-opr CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jrr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jrr-opr
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zprntrn  = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                                INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jrr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_jrr-opr IS NOT INITIAL

    IF lst_jrr-qr IS NOT INITIAL.
      IF lst_jrr-qr CA c_negative.
        MESSAGE i141(zqtc_r2) WITH lst_inv_rcon-matnr
                              INTO lst_msg-text.
        lst_msg-zsource = lst_jrr-fname.
        APPEND lst_msg TO i_errlog_msgs.
      ELSE.
        CLEAR lv_int.
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = lst_jrr-qr
          IMPORTING
            p_int         = lv_int
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        IF sy-subrc EQ 0.
          lst_inv_rcon-zrcpt = lv_int.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          MESSAGE i157(zqtc_r2) WITH lst_inv_rcon-matnr
                                INTO lst_msg-text. " Only Integer values are allowed for the material &.
          lst_msg-zsource = lst_jrr-fname.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF lst_jrr-qr IS NOT INITIAL
    lst_inv_rcon-zevent = 'Stock To Distributor'(t04).
    lst_inv_rcon-matnr = lst_jrr-uid.
    lst_inv_rcon-zsource = lst_jrr-fname.
    lst_inv_rcon-zsysdate = sy-datum.
    APPEND lst_inv_rcon TO i_inv_rcon.
    CLEAR lst_inv_rcon.

  ENDLOOP. " LOOP AT i_jrr INTO lst_jrr

  i_file_names = i_file_names1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATION_FIELDS
*&---------------------------------------------------------------------*
*     This perform is for validating the filed
*----------------------------------------------------------------------*

FORM f_validation_fields .
** local types declaration
  TYPES: BEGIN OF lty_valid,
           matnr          TYPE matnr, " Material Number
           ismrefmdprod   TYPE ismrefmdprod,
           ismyearnr      TYPE ismjahrgang,
           ismissuetypest TYPE ismausgvartyppl,
         END OF lty_valid,
*** Local types declaration
         BEGIN OF lty_mvke,
           matnr TYPE matnr,           " Material Number
           dwerk TYPE dwerk_ext,       " Delivering Plant (Own or External)
         END OF lty_mvke.
*** Local Data declaration
  DATA: lst_msg          TYPE ty_msg,
        lst_inv_rcon     TYPE zqtc_inven_recon,                   " Table for Inventory Reconciliation Data
        lst_source_fl    TYPE ty_fname,
        li_source_fl     TYPE STANDARD TABLE OF ty_fname,
        li_inv_rcon      TYPE STANDARD TABLE OF zqtc_inven_recon, " Table for Inventory Reconciliation Data
        li_inv_rcon_fgr  TYPE STANDARD TABLE OF zqtc_inven_recon, " Temporary table for all enries to get first gr date
        li_inv_rcon_file TYPE STANDARD TABLE OF zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lst_fgrdate      TYPE ty_fgrdate,
        lst_file_matnr   TYPE lty_valid,
        li_file_matnrs   TYPE STANDARD TABLE OF lty_valid,
        li_mvke          TYPE STANDARD TABLE OF lty_mvke,
        lst_mvke         TYPE lty_mvke,
        li_valid         TYPE STANDARD TABLE OF lty_valid,
        lst_valid        TYPE lty_valid,
        lv_tabix         TYPE sy-tabix.
  FIELD-SYMBOLS : <lst_inv_rcon>  TYPE zqtc_inven_recon,
                  <lst_inv_rcon1> TYPE zqtc_inven_recon.

* To check and validate if the same file has been loaded already in the table or not
* using the file name.
  REFRESH li_source_fl.
  li_inv_rcon_file[] = i_inv_rcon[].
  SORT li_inv_rcon_file BY zsource.
  DELETE ADJACENT DUPLICATES FROM li_inv_rcon_file COMPARING zsource.
  SELECT zsource INTO TABLE li_source_fl
         FROM zqtc_inven_recon
         FOR ALL ENTRIES IN li_inv_rcon_file
         WHERE zsource = li_inv_rcon_file-zsource.
  IF sy-subrc EQ 0.
    LOOP AT li_source_fl INTO lst_source_fl.
      MESSAGE i140(zqtc_r2) WITH lst_source_fl-zsource
                                  INTO lst_msg-text.
      lst_msg-zsource = lst_source_fl-zsource.
      APPEND lst_msg TO i_errlog_msgs.
      CLEAR lst_msg.
    ENDLOOP.
  ENDIF.

* Begin of Changes for CR#378
* To validate if the material(unique Issue ID) is existing in SAP system or not.
  li_inv_rcon[] = i_inv_rcon[]. " assigning to local internal tbl
  SORT li_inv_rcon BY matnr. " Sort Internal table by MATNR
* We are not deleting the duplicates for all entries for matnr because this is a valid scenario
* as multiple materials will come and accordingly I need to validate and send as an error message.

  IF li_inv_rcon[] IS NOT INITIAL.
*** Selecting matnr from mara
    SELECT matnr " Material Number
           ismrefmdprod
           ismyearnr
           ismissuetypest
      INTO TABLE li_valid
      FROM mara  " General Material Data
      FOR ALL ENTRIES IN li_inv_rcon
      WHERE matnr = li_inv_rcon-matnr.
    IF sy-subrc = 0.
      SORT li_valid BY matnr.
      LOOP AT li_inv_rcon ASSIGNING <lst_inv_rcon1>.
        READ TABLE li_valid INTO lst_valid WITH KEY
        matnr = <lst_inv_rcon1>-matnr " reading to check if valid material or not
        BINARY SEARCH.
        IF sy-subrc NE 0.
          MESSAGE i137(zqtc_r2) WITH <lst_inv_rcon1>-matnr
                                INTO lst_msg-text.
          lst_msg-zsource = <lst_inv_rcon1>-zsource.
          APPEND lst_msg TO i_errlog_msgs.
          CLEAR lst_msg.
        ELSE.
          <lst_inv_rcon1>-ismrefmdprod = lst_valid-ismrefmdprod.
          <lst_inv_rcon1>-ismyearnr    = lst_valid-ismyearnr.
          IF lst_valid-ismissuetypest IS NOT INITIAL.
            <lst_inv_rcon1>-zsupplm      = lst_valid-ismissuetypest.
          ENDIF.
        ENDIF. " IF sy-subrc NE 0
      ENDLOOP. " LOOP AT li_inv_rcon INTO lst_inv_rcon
    ELSE. " ELSE -> IF sy-subrc = 0
      MESSAGE i138(zqtc_r2) INTO lst_msg-text.
* Begin of Change:ADD:INC0236567:RBTIRUMALA:28/03/2019:ED1K909811
      READ TABLE li_inv_rcon ASSIGNING <lst_inv_rcon1> INDEX 1.
      lst_msg-zsource = <lst_inv_rcon1>-zsource.
* End of Change:ADD:INC0236567:RBTIRUMALA:28/03/2019:ED1K909811
      APPEND lst_msg TO i_errlog_msgs.
      CLEAR: lst_msg,
             v_nomat_flag.
      v_nomat_flag = abap_true.
    ENDIF. " IF sy-subrc = 0

**To get the delivery plant and update it in the record.
    IF v_nomat_flag = abap_false.
      SELECT matnr dwerk
          INTO TABLE li_mvke
          FROM mvke
          FOR ALL ENTRIES IN li_inv_rcon
          WHERE matnr = li_inv_rcon-matnr.
      IF sy-subrc EQ 0.
        SORT li_mvke BY matnr dwerk.
        LOOP AT li_inv_rcon ASSIGNING <lst_inv_rcon>.
*          lv_tabix = sy-tabix.
          READ TABLE li_mvke INTO lst_mvke WITH KEY matnr = <lst_inv_rcon>-matnr.
          IF sy-subrc EQ 0.
            IF lst_mvke-dwerk IS NOT INITIAL.
              <lst_inv_rcon>-werks = lst_mvke-dwerk.
            ELSE.
              MESSAGE i139(zqtc_r2) WITH <lst_inv_rcon>-matnr
                                    INTO lst_msg-text.
              lst_msg-zsource = lst_inv_rcon-zsource.
              APPEND lst_msg TO i_errlog_msgs.
              CLEAR lst_msg.
            ENDIF.
          ELSE.
            MESSAGE i136(zqtc_r2) WITH <lst_inv_rcon>-matnr
                                  INTO lst_msg-text.
            lst_msg-zsource = lst_inv_rcon-zsource.
            APPEND lst_msg TO i_errlog_msgs.
          ENDIF.
*          CLEAR lv_tabix.
        ENDLOOP.
      ENDIF.
    ENDIF.

* To get the first GR date for the same material, Plant and Adjustment Type.
    li_inv_rcon_fgr[] = li_inv_rcon[].
    SORT li_inv_rcon_fgr BY matnr werks.
    DELETE ADJACENT DUPLICATES FROM li_inv_rcon_fgr COMPARING matnr werks.
    IF li_inv_rcon_fgr IS NOT INITIAL.
      SELECT matnr werks zfgrdat
         INTO TABLE i_fgrdate_tab
        FROM zqtc_inven_recon
        FOR ALL ENTRIES IN li_inv_rcon_fgr
        WHERE zadjtyp EQ li_inv_rcon_fgr-zadjtyp
          AND matnr EQ li_inv_rcon_fgr-matnr
          AND werks EQ li_inv_rcon_fgr-werks
          AND zfgrdat NE space.
      IF sy-subrc EQ 0.
        SORT i_fgrdate_tab BY matnr werks zfgrdat DESCENDING.
        DELETE ADJACENT DUPLICATES FROM i_fgrdate_tab COMPARING matnr werks.
      ENDIF.
      LOOP AT li_inv_rcon ASSIGNING <lst_inv_rcon>.
        READ TABLE i_fgrdate_tab INTO lst_fgrdate WITH KEY matnr = <lst_inv_rcon>-matnr
                                                           werks = <lst_inv_rcon>-werks.
        IF sy-subrc EQ 0.
          <lst_inv_rcon>-zfgrdat = lst_fgrdate-zfgrdat.
        ENDIF.
      ENDLOOP.
* End of Changes CR#378
    ENDIF.
    i_inv_rcon[] = li_inv_rcon[].
  ENDIF. " IF li_inv_rcon[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_NAME_SPLIT
*&---------------------------------------------------------------------*
*   This perform is to split File Name
*----------------------------------------------------------------------*
FORM f_file_name_split  USING    fp_v_drctry TYPE localfile  " Local file for upload/download
                        CHANGING fp_v_name   TYPE localfile. " Local file for upload/download

  DATA: lv_name1 TYPE string.

  CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = fp_v_drctry
    IMPORTING
      stripped_name = lv_name1
      file_path     = fp_v_name
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_SOH_GRD  text
*      <--P_LST_INV_RCON  text
*----------------------------------------------------------------------*
FORM f_pop_date  USING    fp_lst_soh_grd  TYPE string
                 CHANGING fp_lst_inv_rcon TYPE ztdate. " Transactional date

  DATA: lv_i      TYPE i, " I of type Integers
        lv_string TYPE string.

  lv_i = strlen( fp_lst_soh_grd ).
* Begin of CHANGE:ADD:INC0236567:RBTIRUMALA:28/03/2019:ED1K909811
  IF  lv_i = 9.
    lv_i = lv_i - 1.
    fp_lst_soh_grd = fp_lst_soh_grd+0(lv_i).
  ENDIF.
* End of CHANGE:ADD:INC0236567:RBTIRUMALA:28/03/2019:ED1K909811
  IF lv_i = 10.

    CONCATENATE fp_lst_soh_grd+6(4)
                fp_lst_soh_grd+3(2)
                fp_lst_soh_grd+0(2)
                INTO
                lv_string.

  ELSEIF lv_i = 8.

    CONCATENATE fp_lst_soh_grd+4(4)
                fp_lst_soh_grd+2(2)
                fp_lst_soh_grd+0(2)
                INTO
                lv_string.
  ENDIF.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
  REPLACE '/' WITH '' INTO lv_string.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

  CONDENSE lv_string NO-GAPS.

* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
  CLEAR v_date.
  v_date = lv_string.
*  fp_lst_inv_rcon = lv_string.
  fp_lst_inv_rcon = v_date.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL_GLOBAL
*&---------------------------------------------------------------------*
*     Purpose of this perform Clearing all global variable
*----------------------------------------------------------------------*

FORM f_clear_all_global .
  CLEAR: v_ap_path,
         v_pr_path,
         v_drctry,
         v_flag,
         v_file,
         v_file_count,
         i_inv_rcon,
         i_soh ,
         st_soh,
         i_bios,
         st_bios,
         i_jdr,
         i_jrr,
         i_file_names,
         st_file_names,
         i_file_names1,
         i_file_names2,
         st_file_names1.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DEL_ERR_RECORDS_FRM_ITAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM del_err_records_frm_itab .

  DATA: lst_errlog_files TYPE ty_msg,
        lst_err_file_r   TYPE ty_err_file_r.

* To build a range table for the error files so that the error records are removed.
* from internal table i_inv_recon.
  LOOP AT i_errlog_files INTO lst_errlog_files.
    lst_err_file_r-sign    = c_sign_i.
    lst_err_file_r-option  = c_opt_eq.
    lst_err_file_r-low     = lst_errlog_files-zsource.
    APPEND lst_err_file_r TO i_err_file_r.
  ENDLOOP.

  SORT i_inv_rcon BY zsource.

  IF i_err_file_r IS NOT INITIAL.
    DELETE i_inv_rcon WHERE zsource IN i_err_file_r.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  POPULATE_SEQ_NUM_INT_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM populate_seq_num_int_tab .

  DATA: lv_seqno     TYPE pkr_seq,
        lst_inv_rcon TYPE zqtc_inven_recon.  " Sequence number

  CLEAR lv_seqno.

  IF rb_soh EQ abap_true.
    SELECT SINGLE MAX( zseqno )
           INTO lv_seqno
           FROM zqtc_inven_recon
         WHERE zadjtyp = c_soh
           AND zsysdate = sy-datum.
    IF sy-subrc NE 0.
      lv_seqno = 0.
    ENDIF.
  ELSEIF rb_bios EQ abap_true.
    SELECT SINGLE MAX( zseqno )
           INTO lv_seqno
           FROM zqtc_inven_recon
         WHERE zadjtyp = c_bios.
    IF sy-subrc NE 0.
      lv_seqno = 0.
    ENDIF.
  ELSEIF rb_jdr EQ abap_true.
    SELECT SINGLE MAX( zseqno )
           INTO lv_seqno
           FROM zqtc_inven_recon
         WHERE zadjtyp = c_jdr.
    IF sy-subrc NE 0.
      lv_seqno = 0.
    ENDIF.
  ELSEIF rb_jrr EQ abap_true.
    SELECT SINGLE MAX( zseqno )
           INTO lv_seqno
           FROM zqtc_inven_recon
         WHERE zadjtyp = c_jrr.
    IF sy-subrc NE 0.
      lv_seqno = 0.
    ENDIF.
  ENDIF.

  LOOP AT i_inv_rcon ASSIGNING FIELD-SYMBOL(<lfs_inv_rcon>).
    lv_seqno = lv_seqno + 1.
    <lfs_inv_rcon>-zseqno = lv_seqno.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email .
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
    lv_rec_u        TYPE so_escape  VALUE 'U',
    lv_cnt          TYPE char10,
    lv_str          TYPE string,
    lv_line         TYPE string.
  DATA: "i_objbin  LIKE solix OCCURS 10 WITH HEADER LINE,
    lv_string TYPE string,
    mailto    TYPE ad_smtpadr.
  FIELD-SYMBOLS <lfs_any_t> TYPE any.


  LOOP AT s_email.
    lst_mailrecipients-rec_type = lv_rec_u .
    lst_mailrecipients-receiver  = s_email-low.
    APPEND lst_mailrecipients TO li_mailrecipients.
    CLEAR:lst_mailrecipients.
  ENDLOOP.


  IF s_email[] IS NOT INITIAL.
    IF     rb_soh   IS NOT INITIAL.
      lv_str = text-t31.
    ELSEIF rb_bios  IS NOT INITIAL.
      lv_str = text-t28.
    ELSEIF rb_jdr   IS NOT INITIAL.
      lv_str = text-t29.
    ELSEIF rb_jrr   IS NOT INITIAL.
      lv_str = text-t30.
    ENDIF.
    CONCATENATE text-t32 lv_str text-t33 sy-datum+4(2) sy-datum+6(2) sy-datum+0(4)
                INTO lst_str.
    CLEAR  lst_doc_data.

    lst_doc_data-obj_name   = lst_str."text-t10.
    lst_doc_data-obj_descr  = lst_str.
    lst_doc_data-obj_langu  = sy-langu.

    lst_objtxt-line = '<body>'(t10).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(t12) text-t11 '</p>'(t13)
                      INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(t12)
                text-t14
                lv_str
                text-t34
                text-t15
                '</p>'(t13)
                INTO lst_objtxt-line SEPARATED BY space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.


*    lst_objtxt-line = text-t15.
*    APPEND lst_objtxt TO li_objtxt.
*    CLEAR  lst_objtxt.

    lst_objtxt-line = text-t16.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR  lst_objtxt.

    lst_objtxt-line = text-t16.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

**
    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    lst_objtxt-line = 'Error log File path :'(t35).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    LOOP AT i_file_err INTO st_file_err.
      lv_cnt = lv_cnt + 1.
      lst_objtxt-line = '</br>'(t17).
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.
      CONCATENATE lv_cnt '.' st_file_err-data INTO  lst_objtxt-line SEPARATED BY space .
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.
    ENDLOOP.
    CLEAR lv_cnt.
    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    lst_objtxt-line = text-t16.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
    CONCATENATE 'Error_log'(t26) sy-datum sy-uzeit INTO DATA(lv_file2) SEPARATED BY '_'.
    DATA(lv_file3) = lv_file2.

    lst_objtxt-line = 'Input File names as follows...'(t27).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CLEAR:st_filenames.
    LOOP AT i_filenames INTO st_filenames.
      lv_cnt = lv_cnt + 1.
      lst_objtxt-line = '</br>'(t17).
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.

      CONCATENATE lv_cnt '.' st_filenames-data INTO  lst_objtxt-line SEPARATED BY space .
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.
      CLEAR:st_filenames.
    ENDLOOP.
    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
*---Body of the EMAIL

    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<br><b><i><font color = "BLACK" style="font-family:arial;font-size:100%;">'(t19)
                'This is an auto generated Email. Do not Reply to this Email.</i></b></br>'(t20)
                INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</br>'(t17).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = 'Regards'(t21).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</body>'(t22).
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
      MESSAGE text-t25 TYPE c_inf.
    ENDIF.
  ENDIF.
ENDFORM.
