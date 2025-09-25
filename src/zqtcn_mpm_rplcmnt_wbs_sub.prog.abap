*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_MPM_RPLCMNT_WBS_SUB
* PROGRAM DESCRIPTION:  Include for subroutines
* DEVELOPER:            Aratrika Banerjee(ARABANERJE)
* CREATION DATE:        17-Jan-2017
* OBJECT ID:            C079
* TRANSPORT NUMBER(S):  ED2K904151
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MPM_RPLCMNT_WBS_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PROJ_DFNTN
*&---------------------------------------------------------------------*
*       Validation of Project Definition
*----------------------------------------------------------------------*

FORM f_validate_proj_dfntn  USING fp_s_proj TYPE ztqtc_pspid_rang.

  SELECT pspid " Project Definition
    FROM proj  " Project definition
    UP TO 1 ROWS
    INTO @DATA(lv_proj)
    WHERE pspid IN @fp_s_proj.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Project Definition
    MESSAGE e107(zqtc_r2). " Invalid Project Definition
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_WBS
*&---------------------------------------------------------------------*
*       Validation of WBS Element
*----------------------------------------------------------------------*

FORM f_validate_wbs  USING fp_s_wbs TYPE zqtct_rng_pspnr. "tty_rng_posid.

*  SELECT posid " WBS Element
  SELECT pspnr " WBS Element
  FROM prps    " WBS (Work Breakdown Structure) Element Master Data
  UP TO 1 ROWS
  INTO @DATA(lv_wbs)
*    WHERE posid IN @fp_s_wbs.
  WHERE pspnr IN @fp_s_wbs.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid WBS
    MESSAGE e108(zqtc_r2). " Invalid WBS
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BUKRS
*&---------------------------------------------------------------------*
*       Validation of Company Code
*----------------------------------------------------------------------*

FORM f_validate_bukrs  USING fp_s_bukrs TYPE tpmy_range_bukrs.

  SELECT pbukr " Company code for WBS element
    FROM prps  " WBS (Work Breakdown Structure) Element Master Data
    UP TO 1 ROWS
    INTO @DATA(lv_bukrs)
    WHERE pbukr IN @fp_s_bukrs.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Company Code
    MESSAGE e109(zqtc_r2). " Invalid Company Code
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ZZMPM
*&---------------------------------------------------------------------*
*       Validation of MPM Issue
*----------------------------------------------------------------------*

FORM f_validate_zzmpm  USING fp_s_mpm TYPE tty_zzmpm_range. " MPM Issue

  SELECT zzmpm " MPM Issue
    FROM prps  " WBS (Work Breakdown Structure) Element Master Data
    UP TO 1 ROWS
    INTO @DATA(lv_zzmpm)
    WHERE zzmpm IN @fp_s_mpm.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid MPM Issue
    MESSAGE e110(zqtc_r2). " Invalid MPM Issue
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_TYPE
*&---------------------------------------------------------------------*
*       Validate Material Type
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type (Media Issue)
*----------------------------------------------------------------------*
FORM f_validate_mat_type USING fp_s_mtyp TYPE tty_mtart_range.

* Material Types
  SELECT mtart "Material type
    FROM t134  " Material Types
   UP TO 1 ROWS
    INTO @DATA(lv_mtart)
   WHERE mtart IN @fp_s_mtyp.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid material type; check your entry
    MESSAGE e084(ob). " Invalid material type,check your entry
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_PROCESS_RECORDS
*&---------------------------------------------------------------------*
*       Fetch and Process Records
*----------------------------------------------------------------------*
*      -->FP_S_PROJ[]  text
*      -->FP_S_WBS[]  text
*      -->FP_S_BUKRS[]  text
*      -->FP_S_MPM[]  text
*      -->FP_S_MTYP_I[]  text
*----------------------------------------------------------------------*
FORM f_fetch_process_records  USING    fp_s_proj   TYPE ztqtc_pspid_rang
                                       fp_s_wbs    TYPE zqtct_rng_pspnr "tty_rng_posid
                                       fp_s_bukrs  TYPE tpmy_range_bukrs
                                       fp_s_mpm    TYPE tty_zzmpm_range
                                       fp_s_mtyp_o TYPE tty_mtart_range
                                       fp_s_mtyp_n TYPE tty_mtart_range
                                       fp_idtype TYPE ismidcodetype.

  DATA : li_final_data   TYPE STANDARD TABLE OF ty_final_data,
         li_wbs_element  TYPE bapi_bus2054_chg_tab,         " Data Structure: Change WBS Element
         lst_wbs_element TYPE bapi_bus2054_chg,             " Data Structure: Change WBS Element
         li_wbs_upd      TYPE bapi_bus2054_upd_tab,         " Update Structure: Change Project Definition
         lst_wbs_upd     TYPE bapi_bus2054_upd,             " Update Structure: Change WBS Element
         li_return       TYPE TABLE OF bapiret2,            " Return Parameter
         lst_return      TYPE          bapiret2,            " Return Parameter
         li_extensionin  TYPE TABLE OF bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
         lst_extensionin TYPE          bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
         lst_valuepart1  TYPE          bapi_te_wbs_element, " Customer Enhancement to WBS Element (CI_PRPS)
         lv_proj_defn    TYPE ps_pspid,                     " Project Definition
         lv_pspid_e      TYPE ps_posid,                     " Project Definition
         lv_status       TYPE char1,                        " Status of type CHAR1
         lv_message      TYPE bapi_msg.                     " Message Text

  CONSTANTS : lc_semi TYPE char1 VALUE ';'. " Semi of type CHAR1

***Selection from PRPS, MARA and JPTIDCDASSIGN to fetch the corresopomding fields
  SELECT p~psphi,
         p~posid,
         p~pspnr,
         p~pbukr,
         p~zzmpm,
         m~matnr,
         m~mtart,
         id~idcodetype,
         id~identcode " Identification Code
    FROM ( ( prps AS p
    INNER JOIN mara AS m
    ON  p~zzmpm EQ m~matnr )
    INNER JOIN jptidcdassign AS id
    ON m~matnr EQ id~matnr )
    INTO TABLE @DATA(li_data)
    WHERE p~psphi IN @fp_s_proj
    AND   p~pspnr IN @fp_s_wbs
    AND   p~pbukr IN @fp_s_bukrs
    AND   p~zzmpm IN @fp_s_mpm
    AND   m~mtart IN @fp_s_mtyp_o
    AND   id~idcodetype EQ @fp_idtype.

  IF sy-subrc IS INITIAL.

    SELECT m~matnr,
           id~idcodetype,
           id~identcode " Identification Code
    FROM jptidcdassign AS id
      INNER JOIN mara AS m
      ON m~matnr EQ id~matnr
      INTO TABLE @DATA(li_data_matnr)
      FOR ALL ENTRIES IN @li_data
      WHERE id~idcodetype EQ @li_data-idcodetype
      AND id~identcode EQ @li_data-identcode
      AND m~mtart IN @fp_s_mtyp_n.

    IF sy-subrc IS INITIAL.
      SORT li_data_matnr BY idcodetype identcode matnr.
      DELETE ADJACENT DUPLICATES FROM li_data_matnr
                  COMPARING idcodetype identcode matnr.
    ENDIF. " IF sy-subrc IS INITIAL

  ENDIF. " IF sy-subrc IS INITIAL

  LOOP AT li_data ASSIGNING FIELD-SYMBOL(<lst_data>).

    CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
      EXPORTING
        input  = <lst_data>-posid "<lst_data>-pspnr
      IMPORTING
        output = lv_pspid_e.

    APPEND INITIAL LINE TO li_final_data ASSIGNING FIELD-SYMBOL(<lst_final_data>).

    READ TABLE li_data_matnr ASSIGNING FIELD-SYMBOL(<lst_data_matnr>)
         WITH KEY idcodetype = <lst_data>-idcodetype
                  identcode = <lst_data>-identcode
                  BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      <lst_final_data>-posid = lv_pspid_e.
      <lst_final_data>-zzmpm = <lst_data>-zzmpm.
      <lst_final_data>-identcode = <lst_data>-identcode.
      <lst_final_data>-zzmpm_new = <lst_data_matnr>-matnr.

      lst_valuepart1-wbs_element = lv_pspid_e.
      lst_valuepart1-zzmpm = <lst_data_matnr>-matnr.
      lst_extensionin-structure  = 'BAPI_TE_WBS_ELEMENT'.
      lst_extensionin-valuepart1 = lst_valuepart1.
      APPEND lst_extensionin TO li_extensionin.
      CLEAR lst_extensionin.
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
      <lst_final_data>-posid = lv_pspid_e.
      <lst_final_data>-zzmpm = <lst_data>-zzmpm.
      <lst_final_data>-identcode = <lst_data>-identcode.
      lv_message = text-001.
      <lst_final_data>-message = lv_message.
      lv_status = c_status_err. "Status: '1' = Red/Error
      <lst_final_data>-status = lv_status.
      CONTINUE.
    ENDIF. " IF sy-subrc IS INITIAL

* FM to convert Internal Project definition Number to External format
    CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
      EXPORTING
        input  = <lst_data>-psphi
      IMPORTING
        output = lv_proj_defn.

    lst_wbs_element-wbs_element = lv_pspid_e.
    APPEND lst_wbs_element TO li_wbs_element.
    CLEAR lst_wbs_element.

    lst_wbs_upd-wbs_element = lv_pspid_e.
    APPEND lst_wbs_upd TO li_wbs_upd.
    CLEAR lst_wbs_upd.

**********************************************************************
******Update WBS Element
**********************************************************************

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

    CALL FUNCTION 'BAPI_BUS2054_CHANGE_MULTI'
      EXPORTING
        i_project_definition  = lv_proj_defn
      TABLES
        it_wbs_element        = li_wbs_element
        it_update_wbs_element = li_wbs_upd
        et_return             = li_return
        extensionin           = li_extensionin.

    CLEAR : lst_wbs_element,
            lst_wbs_upd,
            li_wbs_element,
            li_return,
            li_wbs_upd,
            li_extensionin.

    CALL FUNCTION 'BAPI_PS_PRECOMMIT'
      TABLES
        et_return = li_return.

*Checking the type of return m,essages. If 'E' msg then Commit is not done.

    READ TABLE li_return INTO lst_return WITH KEY type = 'E'. " Return into lst_ of type

    IF sy-subrc NE 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

*Capturing the Success Messages
      READ TABLE li_return INTO lst_return WITH KEY type = 'S'. " Return into lst_ of type
      <lst_final_data>-message = lst_return-message.
      lv_status = c_status_suc. "Status: '3' = Green/Success
      <lst_final_data>-status = lv_status.

    ELSE. " ELSE -> IF sy-subrc NE 0
      CLEAR lst_return.

*Capturing the Error messages.
      LOOP AT li_return INTO lst_return WHERE type = 'E'. " Return into lst_ret of type

        CONCATENATE <lst_final_data>-message lst_return-message INTO <lst_final_data>-message
        SEPARATED BY lc_semi.

        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return WHERE type = 'E'

      SHIFT <lst_final_data>-message LEFT DELETING LEADING lc_semi.

      lv_status = c_status_err. "Status: '3' = Green/Success
      <lst_final_data>-status = lv_status.
    ENDIF. " IF sy-subrc NE 0

    UNASSIGN: <lst_final_data>.


  ENDLOOP. " LOOP AT li_data ASSIGNING FIELD-SYMBOL(<lst_data>)

*ALV Display to display the output result of replacement of MPM
  PERFORM f_alv_display USING li_final_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate Selection Screen Default Values
*----------------------------------------------------------------------*
*      <--FP_S_MTYP_O[]  Material Type(Old)
*      <--FP_S_MTYP_N[]  Material Type(Old)
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_mtyp_o TYPE tty_mtart_range
                                   fp_s_mtyp_n TYPE tty_mtart_range.

  APPEND INITIAL LINE TO fp_s_mtyp_o ASSIGNING FIELD-SYMBOL(<lst_mtyp_o>).
  <lst_mtyp_o>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_o>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_o>-low    = c_mtart_zgl3. "Material Type: ZGL3
  <lst_mtyp_o>-high   = space. "Material Type: ZJL3

  APPEND INITIAL LINE TO fp_s_mtyp_o ASSIGNING <lst_mtyp_o>.
  <lst_mtyp_o>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_o>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_o>-low    = c_mtart_zjl3. "Material Type: ZGL3
  <lst_mtyp_o>-high   = space. "Material Type: ZJL3

  APPEND INITIAL LINE TO fp_s_mtyp_n ASSIGNING FIELD-SYMBOL(<lst_mtyp_n>).
  <lst_mtyp_n>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_n>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_n>-low    = c_mtart_zjid. "Material Type: ZJID
  <lst_mtyp_n>-high   = space. "Material Type: ZJIP

  APPEND INITIAL LINE TO fp_s_mtyp_n ASSIGNING <lst_mtyp_n>.
  <lst_mtyp_n>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_n>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_n>-low    = c_mtart_zjip. "Material Type: ZJID
  <lst_mtyp_n>-high   = space. "Material Type: ZJIP

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_IDTYPE
*&---------------------------------------------------------------------*
*       Validate Type of Identification Code
*----------------------------------------------------------------------*
*      -->FP_P_IDTYPE
*----------------------------------------------------------------------*
FORM f_validate_idtype  USING  fp_p_idtype TYPE ismidcodetype.

  SELECT idcodetype    " Type of Identification Code
    FROM jptidcdassign " Material Types
     UP TO 1 ROWS
      INTO @DATA(lv_idtype)
     WHERE idcodetype EQ @fp_p_idtype.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Type of Identification Code
    MESSAGE e112(zqtc_r2). " Invalid Type of Identification Code
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_DISPLAY
*&---------------------------------------------------------------------*
*       Display Process Log (ALV)
*----------------------------------------------------------------------*
*      -->FP_LI_FINAL_DATA
*----------------------------------------------------------------------*
FORM f_alv_display  USING fp_li_final_data TYPE tt_final_data.

  DATA: lv_col_pos  TYPE i,                   "Column Position
        li_fieldcat TYPE slis_t_fieldcat_alv, "Field catalog with field descriptions
        lst_layout  TYPE slis_layout_alv.     "List layout specifications

  FIELD-SYMBOLS: <lst_fldcat> TYPE slis_fieldcat_alv. "Field catalog with field description

  CONSTANTS:
    lc_fld_stind  TYPE slis_fieldname VALUE 'STATUS',    "Field: Status Ind
    lc_fld_wbs    TYPE slis_fieldname VALUE 'POSID',     "Field: Media Product
    lc_fld_oldmpm TYPE slis_fieldname VALUE 'ZZMPM',     "Field: Media Issue
    lc_fld_idcode TYPE slis_fieldname VALUE 'IDENTCODE', "Field: Change Ind
    lc_fld_newmpm TYPE slis_fieldname VALUE 'ZZMPM_NEW', "Field: Status Messages
    lc_fld_msg    TYPE slis_fieldname VALUE 'MESSAGE'.   "Field: Status Ind

  IF fp_li_final_data[] IS INITIAL.
*   Message: No data records found for the specified selection criteria
    MESSAGE s004(wrf_at_generate) DISPLAY LIKE 'E'. " No data records found for the specified selection criteria
    LEAVE LIST-PROCESSING.
  ENDIF. " IF fp_li_final_data[] IS INITIAL

* list layout specifications
  lst_layout-zebra             = abap_true. "Striped pattern
  lst_layout-colwidth_optimize = abap_true. "Column Width Optimization
  lst_layout-lights_fieldname  = lc_fld_stind. "Fieldname for exception

* Field catalog with field descriptions - WBS Element
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_wbs.
  <lst_fldcat>-seltext_l = 'WBS Element'(c01).
  <lst_fldcat>-seltext_m = 'WBS Element'(c01).
  <lst_fldcat>-seltext_s = 'WBS Element'(c01).

* Field catalog with field descriptions - Old MPM Issue
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_oldmpm.
  <lst_fldcat>-seltext_l = 'Old MPM Issue'(c02).
  <lst_fldcat>-seltext_m = 'Old MPM Issue'(c02).
  <lst_fldcat>-seltext_s = 'Old MPM Issue'(c02).

* Field catalog with field descriptions - Journal Code
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_idcode.
  <lst_fldcat>-seltext_l = 'Identification Code'(c03).
  <lst_fldcat>-seltext_m = 'Identification Code'(c03).
  <lst_fldcat>-seltext_s = 'Identification Code'(c03).

* Field catalog with field descriptions - New MPM Issue
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_newmpm.
  <lst_fldcat>-seltext_l = 'New MPM Issue'(c04).
  <lst_fldcat>-seltext_m = 'New MPM Issue'(c04).
  <lst_fldcat>-seltext_s = 'New MPM Issue'(c04).

* Field catalog with field descriptions - Status Message
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_msg.
  <lst_fldcat>-seltext_l = 'Status Message'(c05).
  <lst_fldcat>-seltext_m = 'Status Message'(c05).
  <lst_fldcat>-seltext_s = 'Status Message'(c05).

* Display ALV Grid
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid         "Name of the calling program
      is_layout          = lst_layout       "List layout specifications
      it_fieldcat        = li_fieldcat      "Field catalog with field descriptions
    TABLES
      t_outtab           = fp_li_final_data "Table with data to be displayed
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
*   Error Message
    MESSAGE ID sy-msgid     "Message Class
          TYPE c_msgty_info "Message Type: Information
        NUMBER sy-msgno     "Message Number
          WITH sy-msgv1     "Message Variable-1
               sy-msgv2     "Message Variable-2
               sy-msgv3     "Message Variable-3
               sy-msgv4.    "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
