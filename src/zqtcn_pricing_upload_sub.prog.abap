*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCC_PRICING_UPLOAD
* PROGRAM DESCRIPTION: Pricing Upload for Non-Interface Prices
* DEVELOPER: Writtick Roy/Lucky Kodwani
* CREATION DATE:   2017-01-13
* OBJECT ID: C066
* TRANSPORT NUMBER(S): ED2K904117
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K906023
* REFERENCE NO: CR# 512
* DEVELOPER: Writtick Roy
* DATE:  2017-05-11
* DESCRIPTION: In stead of Sales Deal, Search Term has to be used
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO   : ED2K919262
* REFERENCE NO  : OTCM-26023
* DEVELOPER     : VDPATABALL
* DATE          : 08/21/2020
* DESCRIPTION   : Added two new fields in Input file (Scale Type and Scale Unit)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PRICING_UPLOAD_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
FORM f_clear_all .

* Clear Work Area
  CLEAR: st_t685a,
         st_edidc.

* Clear Internal Table
  CLEAR :i_fields[],
         i_fcat[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_STEPS
*&---------------------------------------------------------------------*
*       Processing Steps
*----------------------------------------------------------------------*
*      -->FP_P_KAPPL  Application
*      -->FP_P_KSCHL  Condition Type
*      -->FP_P_TNAME  Condition Table
*      -->FP_P_S_TERM Include Column for Search Term
*----------------------------------------------------------------------*
FORM f_processing_steps  USING    fp_p_kappl  TYPE kappl     " Application
                                  fp_p_kschl  TYPE kschl     " Condition Type
                                  fp_p_tname  TYPE tabname16 " Table name, 16 characters
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
                                  fp_p_s_term TYPE char1.    " P_s_term of type CHAR1
*                                 fp_p_sls_dl TYPE char1.    " P_sls_dl of type CHAR1
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023

  DATA: li_fld_list   TYPE ddfields.

  DATA: lr_dynamic_s TYPE REF TO data, "  class
        lr_dynamic_t TYPE REF TO data. "  class

* Create Dynamic Table
  PERFORM f_create_dynamic_table USING    fp_p_kappl
                                          fp_p_kschl
                                          fp_p_tname
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
                                          fp_p_s_term
*                                         fp_p_sls_dl
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
                                 CHANGING lr_dynamic_s
                                          lr_dynamic_t
                                          li_fld_list.

* Assignment of structure / internal table ref to the compatible field symbols
  ASSIGN lr_dynamic_s->* TO <st_cond_rc>.
  ASSIGN lr_dynamic_t->* TO <i_cond_rcs>.

  IF rb_appl IS INITIAL.
*  Read file from presentation server and save the data in li_cond_rcs internal table
    PERFORM  f_read_file_frm_pres_server USING     p_file
                                                   li_fld_list
                                         CHANGING <st_cond_rc>
                                                  <i_cond_rcs>.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
*  Read file from application server and save the data in li_cond_rcs internal table
    PERFORM  f_read_file_frm_app_server  USING    p_file
                                                  li_fld_list
                                         CHANGING <st_cond_rc>
                                                  <i_cond_rcs>.
  ENDIF. " IF rb_appl IS INITIAL

* Process records from File
  PERFORM f_process_file_records USING  <i_cond_rcs>
                                        li_fld_list.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*       Create Dynamic Table
*----------------------------------------------------------------------*
*      -->FP_P_KAPPL       Application
*      -->FP_P_KSCHL       Condition Type
*      -->FP_P_TNAME       Condition Table
*      -->FP_P_SLS_DL      Include Column for Sales Deal
*      <--FP_LR_DYNAMIC_S  Data object (Structure)
*      <--FP_LR_DYNAMIC_T  Data object (Internal Table)
*      <--FP_LI_FLD_LIST   DD: Field List
*----------------------------------------------------------------------*
FORM f_create_dynamic_table  USING    fp_p_kappl      TYPE kappl       " Application
                                      fp_p_kschl      TYPE kschl       " Condition Type
                                      fp_p_tname      TYPE tabname16   " Table name, 16 characters
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
*                                     fp_p_sls_dl     TYPE char1       " Include Column for Sales Deal
                                      fp_p_s_term     TYPE char1       " Include Column for Search Term
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
                             CHANGING fp_lr_dynamic_s TYPE REF TO data "  class
                                      fp_lr_dynamic_t TYPE REF TO data "  class
                                      fp_li_fld_list  TYPE ddfields.

* Data Declaration
  DATA:
    lr_struc_desc TYPE REF TO cl_abap_structdescr. "Describe a Structure

  DATA:
    li_components TYPE abap_component_tab.

  DATA:
    lo_struc_type TYPE REF TO cl_abap_structdescr, " Runtime Type Services
    lo_table_type TYPE REF TO cl_abap_tabledescr.  " Runtime Type Services

* Get Description of data object type (Table)
  lr_struc_desc ?= cl_abap_typedescr=>describe_by_name( fp_p_tname ).

* List of Dictionary Descriptions for all Components
  CALL METHOD lr_struc_desc->get_ddic_field_list
    EXPORTING
      p_langu                  = sy-langu       "Language Key
      p_including_substructres = abap_true      "List Also for Substructures
    RECEIVING
      p_field_list             = fp_li_fld_list "List of Dictionary Descriptions for the Components
    EXCEPTIONS
      not_found                = 1
      no_ddic_type             = 2
      OTHERS                   = 3.
  IF sy-subrc EQ 0.
*   Keep only the required Key fields
    DELETE fp_li_fld_list WHERE keyflag EQ abap_false.
    DELETE fp_li_fld_list WHERE fieldname EQ c_fld_mandt  "Field: Client
                             OR fieldname EQ c_fld_kappl  "Field: Application
                             OR fieldname EQ c_fld_kfrst  "Field: Release status
                             OR fieldname EQ c_fld_datbi. "Field: Validity end date of the condition record

*   Add Dynamic Key Fields
    LOOP AT fp_li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_lst>).
      APPEND INITIAL LINE TO li_components ASSIGNING FIELD-SYMBOL(<lst_component>).
      <lst_component>-name = <lst_fld_lst>-fieldname.
      <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( <lst_fld_lst>-rollname ).
      UNASSIGN: <lst_component>.
    ENDLOOP. " LOOP AT fp_li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_lst>)

*   Scale Quantity column will be populated ONLY for relevant Condition Type
    SELECT SINGLE kappl                " Application
                  kschl                " Condition type
                  krech                " Calculation type for condition
                  kzbzg                " Scale basis indicator
                  stfkz                " Scale Type
            FROM t685a                 " Conditions: Types: Additional Price Element Data
            INTO st_t685a
            WHERE kappl EQ fp_p_kappl  "Application
              AND kschl EQ fp_p_kschl. "Condition type
    IF sy-subrc EQ 0 AND
         st_t685a-kzbzg IS NOT INITIAL.

*     Add Field: Condition scale quantity
      APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
      <lst_component>-name = c_fld_kstbm.
      <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_kstbm ).
      UNASSIGN: <lst_component>.
    ENDIF. " IF sy-subrc EQ 0 AND

*   Add Field: Rate (condition amount or percentage)
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_kbetr.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_kbetr ).
    UNASSIGN: <lst_component>.

*   Add Field: Rate unit (currency or percentage)
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_konwa.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_konwa ).
    UNASSIGN: <lst_component>.

*   Add Field: Condition pricing unit
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_kpein.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_kpein ).
    UNASSIGN: <lst_component>.

*   Add Field: Condition unit
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_kmein.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_kmein ).
    UNASSIGN: <lst_component>.

*   Add Field: Validity start date of the condition record
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_datab.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_datab ).
    UNASSIGN: <lst_component>.

*   Add Field: Validity end date of the condition record
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_datbi.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_datbi ).
    UNASSIGN: <lst_component>.

*---Begin of change VDPATABALL 08/21/2020 ED2K919262 OTCM-26023
*   Add Field: Scale Type
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_stfkz.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_stfkz ).
    UNASSIGN: <lst_component>.
*   Add Field: Scale Unit
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_konms.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_konms ).
    UNASSIGN: <lst_component>.
*---End of change VDPATABALL 08/21/2020 ED2K919262 OTCM-26023

*   Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
*   IF fp_p_sls_dl IS NOT INITIAL.
**    Add Field: Sales Deal
*     APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
*     <lst_component>-name = c_fld_knumaag.
*     <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_knumaag ).
*     UNASSIGN: <lst_component>.
*   ENDIF. " IF fp_p_sls_dl IS NOT INITIAL
    IF fp_p_s_term IS NOT INITIAL.
*     Add Field: Search Term
      APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
      <lst_component>-name = c_fld_kosrt.
      <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_kosrt ).
      UNASSIGN: <lst_component>.
    ENDIF. " IF fp_p_sls_dl IS NOT INITIAL
*   END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023


*   Add Field: Idoc Number
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_idoc.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_idoc ).
    UNASSIGN: <lst_component>.

*   Add Field: Message
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_msg.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_msg ).
    UNASSIGN: <lst_component>.

*   Add Field: Traffic Light indicator
    APPEND INITIAL LINE TO li_components ASSIGNING <lst_component>.
    <lst_component>-name = c_fld_indictr.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( c_fld_indictr ).
    UNASSIGN: <lst_component>.

 ENDIF. " IF sy-subrc EQ 0


* Get the line type
  lo_struc_type = cl_abap_structdescr=>create( p_components = li_components ).
* Get the table type
  lo_table_type = cl_abap_tabledescr=>create( p_line_type = lo_struc_type ).

* Create data object (Structure)
  CREATE DATA fp_lr_dynamic_s TYPE HANDLE lo_struc_type. " Internal ID of an object
* Create data object (Internal Table)
  CREATE DATA fp_lr_dynamic_t TYPE HANDLE lo_table_type. " Internal ID of an object

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KAPPL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_kappl .

  SELECT SINGLE kappl " Application
    FROM t681a        " Conditions: Applications
    INTO @DATA(lv_kappl)
    WHERE kappl = @p_kappl.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e105(zqtc_r2). " Invalid Application,please re-enter.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KSCHL
*&---------------------------------------------------------------------*
*       Validate Condition Type
*----------------------------------------------------------------------*
FORM f_validate_kschl .

  SELECT kschl " Condition Type
    FROM t685  " Conditions: Types
    INTO @DATA(lv_kschl)
    UP TO 1 ROWS
    WHERE kschl = @p_kschl.
  ENDSELECT.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e106(zqtc_r2). " Invalid Condition Type,please re-enter.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SYST_CPROG  text
*      -->P_C_FIELD  text
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog " ABAP System Field: Calling Program
                                 fp_c_field    TYPE dynfnam    " Field name
                        CHANGING fp_p_file     TYPE localfile. " Local file for upload/download

  CALL FUNCTION 'F4_FILENAME' "for search help in presentation server.
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_p_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_application  CHANGING fp_p_file TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc EQ 0.
* suitable error handling will done later
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile. " Local file for upload/download
  DATA: lv_file   TYPE string,
        lv_result TYPE abap_bool.

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
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_application  USING    fp_p_file TYPE localfile. " Local file for upload/download

  DATA: lv_test TYPE orblk,            " Data block for original data
        lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
        l_len   TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables

  lv_file = fp_p_file.
  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
  IF sy-subrc EQ 0.
    CATCH SYSTEM-EXCEPTIONS dataset_read_error = 11
                          OTHERS = 12.
      READ DATASET lv_file INTO lv_test LENGTH l_len. " lst_str.

    ENDCATCH.
    IF sy-subrc EQ 0.
      CLOSE DATASET fp_p_file.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLOSE DATASET fp_p_file.
      MESSAGE e004.
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE e002. "File doesnot exist
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_FILE_RECORDS
*&---------------------------------------------------------------------*
*       Process records from File
*----------------------------------------------------------------------*
*      -->FP_LI_COND_RCS  text
*      -->FP_LI_FLD_LIST  text
*----------------------------------------------------------------------*
FORM f_process_file_records  USING    fp_li_cond_rcs TYPE ANY TABLE
                                      fp_li_fld_list TYPE ddfields.

  DATA: lr_key_fields    TYPE REF TO data, "  class
        lv_index_st      TYPE i,           " Index_st of type Integers
        lv_index_en      TYPE i,           " Index_en of type Integers
        lv_segnum        TYPE edi_segnum,  " Number of SAP segment
        lv_hlevel        TYPE edi_hlevel,  " Hierarchy level
        lst_sg_e1komg    TYPE e1komg,      " Filter segment with separated condition key
        lst_sg_e1konh    TYPE e1konh,      " Data from condition header
        lst_sg_e1konp    TYPE e1konp,      " Conditions Items
        lst_sg_e1konm    TYPE e1konm,      " Conditions Quantity Scale
        lst_key_fld_err  TYPE ty_status,   " Key Field Error
        li_idoc_data     TYPE edidd_tt,
        lv_lines         TYPE i,           " Lines of type Integers
        lv_lst_key_field TYPE fieldname.   " Field Name

*  CONSTANTS : lc_e1konh  TYPE  edilsegtyp VALUE 'E1KONH',
*              lc_e1konp  TYPE  edilsegtyp VALUE 'E1KOMP',
*              lc_e1konm TYPE  edilsegtyp VALUE 'E1KONM'. " Segment type


  FIELD-SYMBOLS:  <lst_key_fld>     TYPE any.

  lv_segnum = 0.
  lv_hlevel = 0.

* Build a dynamic structure with Key fields (Data)
  PERFORM f_get_key_fields_str USING    fp_li_fld_list
                               CHANGING lr_key_fields.

* Assignment of structure ref to the compatible field symbols
  ASSIGN lr_key_fields->* TO <lst_key_fld>.

  IF st_t685a-kzbzg IS INITIAL.

    LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<lst_cond_rc>).
      lv_index_st = lv_index_en = sy-tabix.
      CLEAR: lst_key_fld_err,
             <lst_key_fld>,
             li_idoc_data.

      MOVE-CORRESPONDING <lst_cond_rc> TO <lst_key_fld>.

*     Validate Key Fields (Blank Values)
      PERFORM f_validate_key_fields USING    fp_li_fld_list
                                             <lst_key_fld>
                                    CHANGING lst_key_fld_err.
      IF lst_key_fld_err IS NOT INITIAL.
        MOVE-CORRESPONDING lst_key_fld_err TO <lst_cond_rc>.
        CONTINUE.
      ENDIF.

      MOVE-CORRESPONDING <lst_key_fld> TO lst_sg_e1komg.
      lst_sg_e1komg-vakey   =  lst_sg_e1komg-vakey_long = <lst_key_fld>.
      lst_sg_e1komg-kvewe   =  p_tname+0(1).
      lst_sg_e1komg-kotabnr =  p_tname+1(3).
      lst_sg_e1komg-kappl =  p_kappl.
      lst_sg_e1komg-kschl =  p_kschl.

      APPEND INITIAL LINE TO li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>).
      <lst_idoc_data>-segnam = 'E1KOMG'.
      lv_segnum = lv_segnum + 1.
      lv_hlevel = lv_hlevel + 1.
      <lst_idoc_data>-segnum = lv_segnum.
      <lst_idoc_data>-hlevel = lv_hlevel.
      <lst_idoc_data>-sdata =  lst_sg_e1komg.
      UNASSIGN : <lst_idoc_data>.

      MOVE-CORRESPONDING <lst_cond_rc> TO lst_sg_e1konh.
      APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
      <lst_idoc_data>-segnam = 'E1KONH'. "lc_e1konh.
      lv_segnum = lv_segnum + 1.
      lv_hlevel = lv_hlevel + 1.
      <lst_idoc_data>-segnum = lv_segnum.
      <lst_idoc_data>-hlevel = lv_hlevel.
      <lst_idoc_data>-sdata =  lst_sg_e1konh.
      UNASSIGN : <lst_idoc_data>.

      MOVE-CORRESPONDING <lst_cond_rc> TO lst_sg_e1konp.
**      lst_sg_e1konp-stfkz = st_t685a-stfkz.  " --VDPATABALL 08/21/2020 ED2K919262 OTCM-26023
      lst_sg_e1konp-kzbzg = st_t685a-kzbzg.
      lst_sg_e1konp-krech = st_t685a-krech.
      APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
      <lst_idoc_data>-segnam = 'E1KONP'. " lc_e1konp. "
      lv_segnum = lv_segnum + 1.
      lv_hlevel = lv_hlevel + 1.
      <lst_idoc_data>-segnum = lv_segnum.
      <lst_idoc_data>-hlevel = lv_hlevel.
      <lst_idoc_data>-sdata =  lst_sg_e1konp.
      UNASSIGN : <lst_idoc_data>.

      PERFORM f_create_save_idoc  USING li_idoc_data
                                        lv_index_st
                                        lv_index_en
                                CHANGING <i_cond_rcs>.
*      PERFORM f_create_save_idoc  USING li_idoc_data
*                                CHANGING <lst_cond_rc>.
    ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<lst_cond_rc>)

  ELSE. " ELSE -> IF st_t685a-kzbzg IS INITIAL

    DESCRIBE TABLE fp_li_fld_list LINES lv_lines.
    READ TABLE fp_li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_list>) INDEX lv_lines.
    MOVE : <lst_fld_list>-fieldname TO  lv_lst_key_field.

    LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<lst_cond_rc_sc>).
      lv_index_en = sy-tabix.
      AT NEW (lv_lst_key_field) .
        lv_index_st = sy-tabix.
        CLEAR: <lst_key_fld>,
               li_idoc_data,
               lst_key_fld_err.

        MOVE-CORRESPONDING <lst_cond_rc_sc> TO <lst_key_fld>.

*       Validate Key Fields (Blank Values)
        PERFORM f_validate_key_fields USING    fp_li_fld_list
                                               <lst_key_fld>
                                      CHANGING lst_key_fld_err.
        IF lst_key_fld_err IS INITIAL.
          MOVE-CORRESPONDING <lst_key_fld> TO lst_sg_e1komg.
          lst_sg_e1komg-vakey   =  lst_sg_e1komg-vakey_long = <lst_key_fld>.
          lst_sg_e1komg-kvewe   =  p_tname+0(1).
          lst_sg_e1komg-kotabnr =  p_tname+1(3).
          lst_sg_e1komg-kappl =  p_kappl.
          lst_sg_e1komg-kschl =  p_kschl.

          APPEND INITIAL LINE TO li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data_sc>).
          <lst_idoc_data_sc>-segnam = 'E1KOMG'.
          lv_segnum = lv_segnum + 1.
          lv_hlevel = lv_hlevel + 1.
          <lst_idoc_data_sc>-segnum = lv_segnum.
          <lst_idoc_data_sc>-hlevel = lv_hlevel.
          <lst_idoc_data_sc>-sdata =  lst_sg_e1komg.
          UNASSIGN : <lst_idoc_data_sc>.

          MOVE-CORRESPONDING <lst_cond_rc_sc> TO lst_sg_e1konh.
          APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data_sc>.
          <lst_idoc_data_sc>-segnam = 'E1KONH'. "lc_e1konh.
          lv_segnum = lv_segnum + 1.
          lv_hlevel = lv_hlevel + 1.
          <lst_idoc_data_sc>-segnum = lv_segnum.
          <lst_idoc_data_sc>-hlevel = lv_hlevel.
          <lst_idoc_data_sc>-sdata =  lst_sg_e1konh.
          UNASSIGN : <lst_idoc_data_sc>.

          MOVE-CORRESPONDING <lst_cond_rc_sc> TO lst_sg_e1konp.
**          lst_sg_e1konp-stfkz = st_t685a-stfkz. " --VDPATABALL 08/21/2020 ED2K919262 OTCM-26023
          lst_sg_e1konp-kzbzg = st_t685a-kzbzg.
          lst_sg_e1konp-krech = st_t685a-krech.
          APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data_sc>.
          <lst_idoc_data_sc>-segnam = 'E1KONP'. " lc_e1konp. "
          lv_segnum = lv_segnum + 1.
          lv_hlevel = lv_hlevel + 1.
          <lst_idoc_data_sc>-segnum = lv_segnum.
          <lst_idoc_data_sc>-hlevel = lv_hlevel.
          <lst_idoc_data_sc>-sdata =  lst_sg_e1konp.
          UNASSIGN : <lst_idoc_data_sc>.
        ENDIF.
      ENDAT.

      IF lst_key_fld_err IS NOT INITIAL.
        MOVE-CORRESPONDING lst_key_fld_err TO <lst_cond_rc_sc>.
        CONTINUE.
      ENDIF.

      MOVE-CORRESPONDING <lst_cond_rc_sc> TO lst_sg_e1konm.
      IF lst_sg_e1konp-kstbm IS INITIAL OR
         lst_sg_e1konp-kstbm EQ 0.
*       Do not ADD the segment
      ELSE.
        APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data_sc>.
        <lst_idoc_data_sc>-segnam = 'E1KONM'. "lc_e1konm. "
        lv_segnum = lv_segnum + 1.
        lv_hlevel = lv_hlevel + 1.
        <lst_idoc_data_sc>-segnum = lv_segnum.
        <lst_idoc_data_sc>-hlevel = lv_hlevel.
        <lst_idoc_data_sc>-sdata =  lst_sg_e1konm.
        UNASSIGN : <lst_idoc_data_sc>.
      ENDIF.

      AT END OF (lv_lst_key_field).
        IF lst_key_fld_err IS INITIAL.
          PERFORM f_create_save_idoc  USING li_idoc_data
                                            lv_index_st
                                            lv_index_en
                                    CHANGING <i_cond_rcs>.
        ENDIF.
      ENDAT.
    ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<lst_cond_rc_sc>)
  ENDIF. " IF st_t685a-kzbzg IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KEY_FIELDS_STR
*&---------------------------------------------------------------------*
*       Build a dynamic structure with Key fields (Data)
*----------------------------------------------------------------------*
*      -->FP_LI_FLD_LIST    text
*      <--FP_LR_KEY_FIELDS  text
*----------------------------------------------------------------------*
FORM f_get_key_fields_str  USING    fp_li_fld_list   TYPE ddfields
                           CHANGING fp_lr_key_fields TYPE REF TO data. "  class

  DATA:
    li_components TYPE abap_component_tab,
    li_fld_list   TYPE ddfields.

  DATA:
    lo_struc_type TYPE REF TO cl_abap_structdescr. " Runtime Type Services

* Dynamic Key Fields
  li_fld_list[] = fp_li_fld_list[].
  DELETE li_fld_list INDEX 1.
  LOOP AT li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_lst>).
    APPEND INITIAL LINE TO li_components ASSIGNING FIELD-SYMBOL(<lst_component>).
    <lst_component>-name = <lst_fld_lst>-fieldname.
    <lst_component>-type ?= cl_abap_elemdescr=>describe_by_name( <lst_fld_lst>-rollname ).
    UNASSIGN: <lst_component>.
  ENDLOOP. " LOOP AT li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_lst>)

* Get the line type
  lo_struc_type = cl_abap_structdescr=>create( p_components = li_components ).

* Create data object (Structure)
  CREATE DATA fp_lr_key_fields TYPE HANDLE lo_struc_type. " Internal ID of an object

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_<LI_COND_RCS>  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server  USING     fp_p_file      TYPE localfile " Local file for upload/download
                                             fp_li_fld_list TYPE ddfields
                                  CHANGING  fp_lst_cond_rc TYPE any
                                            fp_li_cond_rcs TYPE STANDARD TABLE.

*--------------------------------------------------------------------*
*  Local Internal table
*--------------------------------------------------------------------*
  DATA: li_intern     TYPE kcde_intern,
        lv_index      TYPE i,          " Index of type Integers
*        lv_index_datab TYPE syst_tabix, " ABAP System Field: Loop Index
*        lv_index_datbi TYPE syst_tabix, " ABAP System Field: Loop Index
        lv_count      TYPE i,          " Count of type Integers
        lv_conv_inpfm TYPE char30.     " Conv_inpfm of type CHAR30
*        lst_fields     TYPE ty_fields,
*        lst_fld_list   TYPE dfies.      " DD Interface: Table Fields for DDIF_FIELDINFO_GET
*--------------------------------------------------------------------*
*  Fields Symbols
*--------------------------------------------------------------------*
  FIELD-SYMBOLS : <lst_fs> TYPE any.

  CLEAR fp_li_cond_rcs.

*Read the CSV file data to an internal table
  CALL FUNCTION 'KCD_CSV_FILE_TO_INTERN_CONVERT'
    EXPORTING
      i_filename      = fp_p_file
      i_separator     = c_separator
    TABLES
      e_intern        = li_intern
    EXCEPTIONS
      upload_csv      = 1
      upload_filetype = 2
      OTHERS          = 3.
  IF sy-subrc IS INITIAL.
    IF  p_hdr_ln IS NOT INITIAL.
      lv_count = 1.
      DO p_hdr_ln TIMES .
        DELETE li_intern WHERE row = lv_count.
        lv_count = lv_count + 1 .
      ENDDO.
    ENDIF. " IF p_hdr_ln IS NOT INITIAL

    LOOP AT li_intern  ASSIGNING FIELD-SYMBOL(<lst_cond_rc>).
      MOVE : <lst_cond_rc>-col TO lv_index.
      ASSIGN COMPONENT lv_index OF STRUCTURE fp_lst_cond_rc TO <lst_fs>.

      DESCRIBE FIELD <lst_fs> EDIT MASK DATA(lv_edt_msk).
      IF lv_edt_msk IS NOT INITIAL.
        WRITE <lst_cond_rc>-value TO <lst_fs> USING EDIT MASK lv_edt_msk.
        REPLACE ALL OCCURRENCES OF '=' IN  lv_edt_msk WITH space.
        CONCATENATE 'CONVERSION_EXIT_' lv_edt_msk '_INPUT' INTO lv_conv_inpfm.
        CALL FUNCTION lv_conv_inpfm
          EXPORTING
            input  = <lst_fs>
          IMPORTING
            output = <lst_fs>.
      ELSE. " ELSE -> IF lv_edt_msk IS NOT INITIAL
        MOVE <lst_cond_rc>-value TO <lst_fs>.
      ENDIF. " IF lv_edt_msk IS NOT INITIAL
      CLEAR: lv_edt_msk.

      AT END OF row.
        APPEND fp_lst_cond_rc TO fp_li_cond_rcs.
        CLEAR: fp_lst_cond_rc.
      ENDAT.
    ENDLOOP. " LOOP AT li_intern ASSIGNING FIELD-SYMBOL(<lst_cond_rc>)

  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_<LI_COND_RCS>  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_app_server  USING     fp_p_file      TYPE localfile " Local file for upload/download
                                           fp_li_fld_list TYPE ddfields
                                 CHANGING  fp_lst_cond_rc TYPE any
                                           fp_li_cond_rcs TYPE STANDARD TABLE.

*--------------------------------------------------------------------*
*  Local Work-area
*--------------------------------------------------------------------*
  DATA: lst_string    TYPE string,
        lst_fields    TYPE ty_fields,
        lst_fld_list  TYPE dfies,      " DD Interface: Table Fields for DDIF_FIELDINFO_GET
*        lv_index_datab TYPE syst_tabix, " ABAP System Field: Loop Index
*        lv_index_datbi TYPE syst_tabix, " ABAP System Field: Loop Index
        lv_index      TYPE syst_tabix, " ABAP System Field: Loop Index
        li_data       TYPE TABLE OF string,
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
        lv_file       TYPE localfile, " Local file for upload/download
        lv_conv_inpfm TYPE char30,    " Conv_inpfm of type CHAR30
        lv_count      TYPE i.         " Count of type Integers
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
*  CONSTANTS : lc_con_tab  TYPE c       VALUE cl_abap_char_utilities=>cr_lf. " Con_tab2 of type Character

*--------------------------------------------------------------------*
*  Field Symbols
*--------------------------------------------------------------------*

  FIELD-SYMBOLS : <lst_fs> TYPE any.
  CLEAR lv_file.

  lv_file = fp_p_file.
*--------------------------------------------------------------------*
* Open Dataset
*--------------------------------------------------------------------*
  OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc EQ 0.
    lv_count = 0.
    DO.
      CLEAR: lst_string,
             li_data[].
*--------------------------------------------------------------------*
*  Read Dataset
*--------------------------------------------------------------------*
      READ DATASET lv_file INTO lst_string.
      IF sy-subrc NE 0.
        EXIT.
      ELSE. " ELSE -> IF sy-subrc NE 0
        IF  p_hdr_ln IS NOT INITIAL.
          lv_count = lv_count + 1.
          IF lv_count LE p_hdr_ln .
            CONTINUE.
          ENDIF. " IF lv_count LE p_hdr_ln
        ENDIF. " IF p_hdr_ln IS NOT INITIAL

        CLEAR li_data.
        SPLIT lst_string AT c_separator INTO TABLE li_data IN CHARACTER MODE.
        LOOP AT li_data ASSIGNING FIELD-SYMBOL(<lst_data>).
          lv_index = sy-tabix.
          ASSIGN COMPONENT lv_index OF STRUCTURE fp_lst_cond_rc TO <lst_fs>.
          MOVE :<lst_data> TO <lst_fs>.
          DESCRIBE FIELD <lst_fs> EDIT MASK DATA(lv_edt_msk).
          IF lv_edt_msk IS NOT INITIAL.
            WRITE <lst_data> TO <lst_fs> USING EDIT MASK lv_edt_msk.
            REPLACE ALL OCCURRENCES OF '=' IN  lv_edt_msk WITH space.
            CONCATENATE 'CONVERSION_EXIT_' lv_edt_msk '_INPUT' INTO lv_conv_inpfm.
            CALL FUNCTION lv_conv_inpfm
              EXPORTING
                input  = <lst_fs>
              IMPORTING
                output = <lst_fs>.
          ENDIF. " IF lv_edt_msk IS NOT INITIAL
          CLEAR: lv_edt_msk.
        ENDLOOP. " LOOP AT li_data ASSIGNING FIELD-SYMBOL(<lst_data>)
        CLEAR lv_index.
        APPEND fp_lst_cond_rc TO fp_li_cond_rcs.
      ENDIF. " IF sy-subrc NE 0
    ENDDO.
*--------------------------------------------------------------------*
*  Close Dataset
*--------------------------------------------------------------------*
    CLOSE DATASET lv_file.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SAVE_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_IDOC_DATA  text
*----------------------------------------------------------------------*
FORM f_create_save_idoc  USING    fp_li_idoc_data TYPE edidd_tt
                                  fp_lv_index_st  TYPE i               " Lv_index_st of type Integers
                                  fp_lv_index_en  TYPE i               " Lv_index_en of type Integers
                         CHANGING fp_li_cond_rcs TYPE STANDARD TABLE . " IDoc number

  TYPES : BEGIN OF lty_edids,
            docnum TYPE edi_docnum,               " IDoc number
            logdat TYPE edi_logdat,               " Date of status information
            logtim TYPE edi_logtim,               " Time of status information
            countr TYPE edi_countr,               " IDoc status counter
            status TYPE edi_status,               " Status of IDoc
            stapa1 TYPE	edi_stapa1,
            stapa2 TYPE	edi_stapa2,
            stapa3 TYPE edi_stapa3,               " Parameter 3
            stapa4 TYPE	edi_stapa4,
            stamid TYPE	edi_stamid,
            stamno TYPE	edi_stamno,
          END OF lty_edids.

  DATA: lst_edi_sttngs TYPE edi_glo,    "Global IDoc Administration Settings
        lst_status     TYPE ty_status,
        lst_ediadmin   TYPE swhactor,   "Rule Resolution Result
        lst_ib_process TYPE tede2,      " EDI process types (inbound)
        lv_sybrc       TYPE syst_subrc. " ABAP System Field: Return Code of ABAP Statements

  DATA : li_idoc_contrl TYPE edidc_tt,
         li_edids       TYPE STANDARD TABLE OF lty_edids INITIAL SIZE 0.

  CONSTANTS : lc_51        TYPE edi_status VALUE '51',   " Status of IDoc
              lc_53        TYPE edi_status VALUE '53',   " Status of IDoc
              lc_msgno_114 TYPE symsgno VALUE '114'.     " Message Type
*              lc_msgno_116 TYPE symsgno VALUE '116'     " Message Number


* Control Record For Inbound IDOC
  PERFORM f_control_data.

* Find out whether ALE is existing in the system
  CALL FUNCTION 'IDOC_READ_GLOBAL'
    IMPORTING
      global_data    = lst_edi_sttngs "Global IDoc Administration Settings
    EXCEPTIONS
      internal_error = 1
      OTHERS         = 2.
  IF sy-subrc EQ 0.
    lst_ediadmin = lst_edi_sttngs-no_appl. "Rule Resolution Result
  ENDIF. " IF sy-subrc EQ 0

* Create and Save IDOC in DB
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error      = abap_true       "Flag: Error handling yes/no
      pi_return_data_flag     = abap_false      "Return of initialized data records
    IMPORTING
      pe_idoc_number          = st_edidc-docnum "IDOC Number
      pe_state_of_processing  = lv_sybrc
      pe_inbound_process_data = lst_ib_process  "EDI process types (inbound)
    TABLES
      t_data_records          = fp_li_idoc_data "IDOC Data Records
    CHANGING
      pc_control_record       = st_edidc        "IDOC Control Record
    EXCEPTIONS
      idoc_not_saved          = 1
      OTHERS                  = 2.
  IF sy-subrc EQ 0.
    COMMIT WORK.
    SET PARAMETER ID 'DCN' FIELD st_edidc-docnum. "IDOC Number
    APPEND st_edidc TO li_idoc_contrl. "IDOC Control Record

*       Start inbound processing for inbound IDoc
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_ib_process  "EDI process types (inbound)
        pi_org_unit                   = lst_ediadmin    "Rule Resolution Result
      TABLES
        t_control_records             = li_idoc_contrl  "IDOC Control Records
        t_data_records                = fp_li_idoc_data "IDOC Data Records
      EXCEPTIONS
        invalid_document_number       = 1
        error_before_call_application = 2
        inbound_process_not_possible  = 3
        old_wf_start_failed           = 4
        wf_task_error                 = 5
        serious_inbound_error         = 6
        OTHERS                        = 7.
    IF sy-subrc EQ 0.
      SELECT docnum " IDoc number
             logdat " Date of status information
             logtim " Time of status information
            countr  " IDoc status counter
            status  " Status of IDoc
            stapa1  " Parameter 1
            stapa2  " Parameter 2
            stapa3  " Parameter 3
            stapa4  " Parameter 4
            stamid  " Status message ID
            stamno  " Status message number
      FROM edids    " Status Record (IDoc)
      INTO TABLE  li_edids
        WHERE docnum = st_edidc-docnum.
      IF sy-subrc EQ 0.
        SORT li_edids BY status.
        READ TABLE li_edids ASSIGNING FIELD-SYMBOL(<lst_edids>)
          WITH KEY status =  lc_51 BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_lst_cond_rcs>) FROM fp_lv_index_st TO fp_lv_index_en.
            MOVE-CORRESPONDING st_edidc TO <fp_lst_cond_rcs>.
            MESSAGE ID <lst_edids>-stamid
             TYPE    c_msg_type_e
             NUMBER  <lst_edids>-stamno
             INTO    lst_status-fin_message_alv
             WITH   <lst_edids>-stapa1
                    <lst_edids>-stapa2
                    <lst_edids>-stapa3
                    <lst_edids>-stapa4.
            lst_status-vvis_lights       = c_alv_light_1.
            MOVE-CORRESPONDING lst_status TO <fp_lst_cond_rcs>.
            CLEAR lst_status.
          ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_li_cond_rcs>) FROM fp_lv_index_st TO fp_lv_index_en
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE li_edids TRANSPORTING NO FIELDS WITH KEY status =  lc_53
                                                              BINARY SEARCH.
          IF sy-subrc EQ 0.
            LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_lst_cond_rc_53>) FROM fp_lv_index_st TO fp_lv_index_en.
              MOVE-CORRESPONDING st_edidc TO <fp_lst_cond_rc_53>.
              MESSAGE ID c_msgid
              TYPE    c_msg_type_i
              NUMBER  lc_msgno_114
              INTO    lst_status-fin_message_alv
              WITH   p_tname.
              lst_status-vvis_lights       = c_alv_light_3.
              MOVE-CORRESPONDING lst_status TO <fp_lst_cond_rc_53>.
              CLEAR lst_status.
            ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_li_cond_rcs>) FROM fp_lv_index_st TO fp_lv_index_en
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
    CLEAR st_edidc.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTROL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_control_data .

*LOCAL constant declaration
  CONSTANTS: lc_direct_in TYPE edi_direct VALUE '2',          " Direction for IDoc
             lc_sap       TYPE char3      VALUE 'SAP',        " Sap of type CHAR3
*              lc_partyp_ls TYPE edi_sndprt VALUE 'LS',         " Partner type of sender
             lc_msgtyp    TYPE edi_mestyp   VALUE 'COND_A',   " Message Type
             lc_idoctp    TYPE edi_idoctp   VALUE 'COND_A04', " Basic type                          " Hierarchy level
             lc_mescod    TYPE edipmescod   VALUE 'Z1',       " Message code
             lc_part_type TYPE edi_sndprt   VALUE 'LS'.

*Populate EDIDC Data
  st_edidc-direct = lc_direct_in. " Direction for IDoc-Outbound(1)
  st_edidc-mestyp = lc_msgtyp. " Message Type-'ZRTR_CUST_CRDT_STATUS_VCH'
  st_edidc-idoctp = lc_idoctp.
  st_edidc-mescod = lc_mescod.

* Fetch details from Partner Profile: inbound (technical parameters)
  SELECT sndprn " Partner Number of Sender
         sndprt " Partner Type of Sender
         sndpfc " Partner function of sender
    FROM edp21  " Partner Profile: Inbound
   UP TO 1 ROWS
    INTO ( st_edidc-sndprn,
           st_edidc-sndprt,
           st_edidc-sndpfc )
   WHERE mestyp EQ lc_msgtyp
    AND mescod EQ  lc_mescod.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: st_edidc-sndprn, " Partner Number of Receiver
           st_edidc-sndprt, " Partner Type of Receiver
           st_edidc-sndpfc. " Receiver port
  ENDIF. " IF sy-subrc NE 0

  st_edidc-sndpor = 'ZLSMW'.

  CONCATENATE lc_sap
              sy-sysid
              INTO st_edidc-rcvpor. "
  CONDENSE st_edidc-rcvpor.

  st_edidc-rcvprt = lc_part_type.

* Get receiver information (Current System)
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = st_edidc-rcvprn " Partner Number of Receiver
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_edidc-rcvprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<LST_COND_RC>  text
*      -->P_<LI_COND_RCS>  text
*----------------------------------------------------------------------*
FORM f_display_alv  USING    fp_lst_cond_rc TYPE any.


  DATA : lv_stname  TYPE dd02l-tabname, " Table Name
         li_fields  TYPE cl_abap_structdescr=>included_view,
         lst_fields TYPE LINE OF cl_abap_structdescr=>included_view,
         lst_fldcat TYPE LINE OF lvc_t_fcat,
         lst_desc   TYPE x030l.         " Nametab Header, Database Structure DDNTT

  TRY.
      obj_stdesc_d ?= cl_abap_structdescr=>describe_by_data( fp_lst_cond_rc ).
    CATCH cx_root.
      RAISE no_field_catalog.
  ENDTRY.

* If It is DDIC structure, determine field catalog using ALV FM
  IF obj_stdesc_d->is_ddic_type( ) IS NOT INITIAL.
    lv_stname = obj_stdesc_d->get_relative_name( ).
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_buffer_active        = space
        i_structure_name       = lv_stname
        i_bypassing_buffer     = abap_on
      CHANGING
        ct_fieldcat            = i_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      CLEAR i_fcat.
      RAISE no_field_catalog.
    ENDIF. " IF sy-subrc <> 0
    RETURN.
  ENDIF. " IF obj_stdesc_d->is_ddic_type( ) IS NOT INITIAL

* Get structure fields
  li_fields = obj_stdesc_d->get_included_view( ).

  LOOP AT li_fields INTO lst_fields.
    CLEAR :  lst_fldcat,
             lst_desc.
    lst_fldcat-col_pos   = sy-tabix.
    lst_fldcat-fieldname = lst_fields-name.
    IF lst_fields-type->is_ddic_type( ) IS NOT INITIAL.
      lst_desc           =  lst_fields-type->get_ddic_header( ).
      lst_fldcat-rollname = lst_desc-tabname.

    ELSE. " ELSE -> IF lst_fields-type->is_ddic_type( ) IS NOT INITIAL
      lst_fldcat-inttype  = lst_fields-type->type_kind.
      lst_fldcat-intlen   = lst_fields-type->length.
      lst_fldcat-decimals = lst_fields-type->decimals.
    ENDIF. " IF lst_fields-type->is_ddic_type( ) IS NOT INITIAL
    APPEND lst_fldcat TO i_fcat.
  ENDLOOP. " LOOP AT li_fields INTO lst_fields

  IF i_fcat IS INITIAL.
    RAISE no_field_catalog.
  ENDIF. " IF i_fcat IS INITIAL

  CALL SCREEN 9000.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

  SET PF-STATUS 'ZPF_PRICING_UPLOAD'.
  SET TITLEBAR 'ZTITLE_PRICNG_UP'.

  DATA: lst_layout  TYPE lvc_s_layo, " ALV control: Layout structure
        lst_variant TYPE disvariant. " Layout (External Use)

* Clear the Work Area
  CLEAR: lst_layout,
         lst_variant.

* Variants - users should be able to save their own variants
  lst_variant-report = sy-repid. " Report name
  lst_layout-excp_fname = c_fld_indictr.

  CREATE OBJECT obj_alv
    EXPORTING
      i_parent = cl_gui_custom_container=>screen0. ##subrc_ok

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF. " IF sy-subrc <> 0

  CALL METHOD obj_alv->set_table_for_first_display
    EXPORTING
      is_layout                     = lst_layout
      is_variant                    = lst_variant
      i_save                        = abap_true
    CHANGING
      it_outtab                     = <i_cond_rcs>
      it_fieldcatalog               = i_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF. " IF sy-subrc <> 0

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CONSTANTS : lc_back   TYPE syucomm VALUE 'BACK',   " Function Code
              lc_exit   TYPE syucomm VALUE 'EXIT',   " Function Code
              lc_cancel TYPE syucomm VALUE 'CANCEL'. " Function Code

  IF sy-ucomm = lc_back
    OR sy-ucomm = lc_exit
     OR sy-ucomm = lc_cancel.
    LEAVE TO SCREEN 0.
  ENDIF. " IF sy-ucomm = lc_back

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_HEADER_LINE
*&---------------------------------------------------------------------*
FORM f_validate_header_line .
  IF  p_hdr_ln IS INITIAL .
    MESSAGE e116(zqtc_r2) WITH p_tname. " Data couldnot be inserted/updated into the table &.
  ENDIF. " IF p_hdr_ln IS INITIAL
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_TNAME
*&---------------------------------------------------------------------*
*       Validate Table Name
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_tname .

  DATA:
    lst_t685  TYPE t685.

  DATA:
    li_t682ia TYPE STANDARD TABLE OF t682ia INITIAL SIZE 0.

* Read Conditions: Types
  CALL FUNCTION 'SD_COND_T685_SELECT'
    EXPORTING
      cts_kappl = p_kappl                                  "Application
      cts_kschl = p_kschl                                  "Condition Type
      cts_kvewe = c_kvewe_a                                "Usage
    IMPORTING
      cts_t685  = lst_t685.                                "Conditions: Types
  IF lst_t685 IS NOT INITIAL.
    CALL FUNCTION 'COND_READ_ACCESSES'
      EXPORTING
        i_kvewe    = c_kvewe_a                             "Usage
        i_kappl    = p_kappl                               "Application
        i_kozgf    = lst_t685-kozgf                        "Access Sequence
      TABLES
        t682ia_tab = li_t682ia.                            "Conditions: Access Sequences (Generated Form)
  ENDIF.
  IF li_t682ia IS NOT INITIAL.
*   Fetch Conditions: Structures
    SELECT kvewe,	                                         "Usage of the condition table
           kotabnr,                                        "Condition table
           kappl,                                          "Application
           kotab                                           "Condition table
      FROM t681
      INTO TABLE @DATA(li_t681)
       FOR ALL ENTRIES IN @li_t682ia
     WHERE kvewe   EQ @li_t682ia-kvewe                     "Usage of the condition table
       AND kotabnr EQ @li_t682ia-kotabnr.                  "Condition table
    IF sy-subrc EQ 0.
      SORT li_t681 BY kotab.
    ENDIF.
  ENDIF.

  READ TABLE li_t681 TRANSPORTING NO FIELDS
       WITH KEY kotab = p_tname                            "Table Name
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Message: Table "&" is not a valid condition table
    MESSAGE e026(c_) WITH p_tname.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE_NAME
*&---------------------------------------------------------------------*
*       Validate File Name
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_file_name .

  DATA:
    lv_file_ext TYPE char10.                               "File Extension

  CONSTANTS:
    lc_file_csv TYPE char3   VALUE 'CSV'.                  "File Ext: CSV

* File Naming Convention "<Cond Type>_<Table Name>"
  IF p_file NS p_tname OR                                  "Table Name
     p_file NS p_kschl.                                    "Condition Type
*   Message: The selected file name does not comply with the convention '&1'
    MESSAGE e557(sy) WITH text-m01.
  ENDIF.

* Get File Extension
  CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
    EXPORTING
      filename  = p_file                                   "File Name
    IMPORTING
      extension = lv_file_ext.                             "File Extension
  IF lv_file_ext NE lc_file_csv.                           "File Extension = CSV
*   Message: Please upload a .CSV file
    MESSAGE e085(id_fiaa_in_mc).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KEY_FIELDS
*&---------------------------------------------------------------------*
*       Validate Key Fields (Blank Values)
*----------------------------------------------------------------------*
*      -->FP_LI_FLD_LIST      text
*      -->FP_LST_KEY_FLD      text
*      <--FP_LST_KEY_FLD_ERR  text
*----------------------------------------------------------------------*
FORM f_validate_key_fields  USING    fp_li_fld_list     TYPE ddfields
                                     fp_lst_key_fld     TYPE any
                            CHANGING fp_lst_key_fld_err TYPE ty_status.

  DATA:
    li_fld_list   TYPE ddfields.

* Dynamic Key Fields
  li_fld_list[] = fp_li_fld_list[].
  DELETE li_fld_list INDEX 1.
  LOOP AT li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_lst>).
    ASSIGN COMPONENT <lst_fld_lst>-fieldname OF STRUCTURE fp_lst_key_fld
        TO FIELD-SYMBOL(<lv_fld_val>).
    IF sy-subrc EQ 0.
      IF <lv_fld_val> IS INITIAL.
*       Message: All key fields need to be filled
        MESSAGE e003(rsdmdm) INTO fp_lst_key_fld_err-fin_message_alv.
        fp_lst_key_fld_err-vvis_lights = c_alv_light_1.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
