*----------------------------------------------------------------------*
***INCLUDE LZQTC_ISM_MATMAS_OB_CPF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MISSING_FIELD
*&---------------------------------------------------------------------*
*       Add Messing (Required) fields
*----------------------------------------------------------------------*
*      -->FP_TABLE_NAME   Table Name
*      -->FP_FIELD_NAME   Field Name
*      -->FP_TABLE_CHECK  Check if any table field exists
*      <--FP_EX_T_CHGPTRS Change Pointers
*----------------------------------------------------------------------*
FORM f_add_missing_field  USING    fp_table_name   TYPE tabname
                                   fp_field_name   TYPE fieldname
                                   fp_table_check  TYPE flag
                          CHANGING fp_ex_t_chgptrs TYPE bdcp_tab.

  IF fp_table_check EQ abap_true.
    READ TABLE fp_ex_t_chgptrs TRANSPORTING NO FIELDS
         WITH KEY tabname = fp_table_name.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.
  ENDIF.

  READ TABLE fp_ex_t_chgptrs TRANSPORTING NO FIELDS
       WITH KEY tabname = fp_table_name
                fldname = fp_field_name.
  IF sy-subrc NE 0.
    APPEND INITIAL LINE TO fp_ex_t_chgptrs ASSIGNING FIELD-SYMBOL(<lst_chgptrs>).
    <lst_chgptrs>-tabname = fp_table_name.
    <lst_chgptrs>-fldname = fp_field_name.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELTA_SEGMENT_MARA
*&---------------------------------------------------------------------*
*       True Delta - Segments related to MARA table
*----------------------------------------------------------------------*
*      -->FP_MARA           Material General Data
*      <--FP_IDOC_CIMTYPE   Extension
*      <--FP_T_IDOC_DATA    IDOC Data Records
*----------------------------------------------------------------------*
FORM f_delta_segment_mara  USING    fp_mara         TYPE mara
                           CHANGING fp_idoc_cimtype TYPE edi_cimtyp
                                    fp_t_idoc_data  TYPE edidd_tt.

  DATA:
    li_chgptrs      TYPE bdcp_tab.

  DATA:
    lst_e1maram_s   TYPE e1maram,
    lst_e1maram_t   TYPE e1maram,
    lst_e1maraism_s TYPE e1maraism,
    lst_e1maraism_t TYPE e1maraism.

  DATA:
    lv_table_indx   TYPE sytabix.

  CALL FUNCTION 'ZQTC_ISM_MATMAS_OB_CP_GET'
    EXPORTING
      im_v_matnr   = fp_mara-matnr
      im_v_tabname = c_table_mara
    IMPORTING
      ex_t_chgptrs = li_chgptrs.

  READ TABLE fp_t_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
       WITH KEY segnam = c_s_e1maram.
  IF sy-subrc EQ 0.
    lv_table_indx = sy-tabix.

    lst_e1maram_s = <lst_idoc_data>-sdata.
    PERFORM f_transfer_fields USING    li_chgptrs
                                       lst_e1maram_s
                              CHANGING lst_e1maram_t.
    <lst_idoc_data>-sdata = lst_e1maram_t.
  ENDIF.

  CALL FUNCTION 'ISM_IDOC_MATMAS_CREATE'
    EXPORTING
      ps_i_mara         = fp_mara
      pv_i_mestyp       = c_mtyp_matmas
    IMPORTING
      ps_e_idoc_cimtype = fp_idoc_cimtype
    TABLES
      pt_e_idoc_data    = fp_t_idoc_data.
  READ TABLE fp_t_idoc_data ASSIGNING <lst_idoc_data>
       WITH KEY segnam = c_s_e1maraism.
  IF sy-subrc EQ 0.
    lv_table_indx = sy-tabix.

    lst_e1maraism_s = <lst_idoc_data>-sdata.
    PERFORM f_transfer_fields USING    li_chgptrs
                                       lst_e1maraism_s
                              CHANGING lst_e1maraism_t.
    <lst_idoc_data>-sdata = lst_e1maraism_t.
  ENDIF.

  CALL FUNCTION 'ISM_IDOC_MATMAS_CREATE_JPTMARA'
    EXPORTING
      ps_i_mara         = fp_mara
      pv_i_mestyp       = c_mtyp_matmas
    IMPORTING
      ps_e_idoc_cimtype = fp_idoc_cimtype
    TABLES
      pt_e_idoc_data    = fp_t_idoc_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TRANSFER_FIELDS
*&---------------------------------------------------------------------*
*       Transfer Field Values
*----------------------------------------------------------------------*
*      -->FP_LI_CHGPTRS  Change Pointers
*      -->FP_LST_SOURCE  Source Structure
*      <--FP_LST_TARGET  Target Structure
*----------------------------------------------------------------------*
FORM f_transfer_fields  USING    fp_li_chgptrs  TYPE bdcp_tab
                                 fp_lst_source  TYPE any
                        CHANGING fp_lst_target  TYPE any.

  LOOP AT fp_li_chgptrs ASSIGNING FIELD-SYMBOL(<lst_chgptr>).
    ASSIGN COMPONENT <lst_chgptr>-fldname OF STRUCTURE fp_lst_source
        TO FIELD-SYMBOL(<lv_source>).
    ASSIGN COMPONENT <lst_chgptr>-fldname OF STRUCTURE fp_lst_target
        TO FIELD-SYMBOL(<lv_target>).
    IF <lv_source> IS ASSIGNED AND
       <lv_target> IS ASSIGNED.
      <lv_target> = <lv_source>.
    ENDIF.
    UNASSIGN: <lv_source>,
              <lv_target>.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELTA_SEGMENT_MARC
*&---------------------------------------------------------------------*
*       True Delta - Segments related to MARC table
*----------------------------------------------------------------------*
*      -->FP_MARA           Material General Data
*      -->FP_MARC           Material / Plant
*      <--FP_IDOC_CIMTYPE   Extension
*      <--FP_T_IDOC_DATA    IDOC Data Records
*----------------------------------------------------------------------*
FORM f_delta_segment_marc  USING    fp_mara         TYPE mara
                                    fp_marc         TYPE marc
                           CHANGING fp_idoc_cimtype TYPE edi_cimtyp
                                    fp_t_idoc_data  TYPE edidd_tt.

  DATA:
    li_chgptrs      TYPE bdcp_tab,
    li_idoc_data_rc TYPE edidd_tt.

  DATA:
    lst_e1marcm_s   TYPE e1marcm,
    lst_e1marcm_t   TYPE e1marcm,
    lst_e1marcism_s TYPE e1marcism,
    lst_e1marcism_t TYPE e1marcism.

  DATA:
    lv_table_indx   TYPE sytabix.

  CALL FUNCTION 'ZQTC_ISM_MATMAS_OB_CP_GET'
    EXPORTING
      im_v_matnr   = fp_mara-matnr
      im_v_tabname = c_table_marc
    IMPORTING
      ex_t_chgptrs = li_chgptrs.

  LOOP AT fp_t_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
    WHERE segnam = c_s_e1marcm.
    lv_table_indx = sy-tabix.
  ENDLOOP.
  IF sy-subrc EQ 0.
    lst_e1marcm_s = <lst_idoc_data>-sdata.
    PERFORM f_transfer_fields USING    li_chgptrs
                                       lst_e1marcm_s
                              CHANGING lst_e1marcm_t.
    <lst_idoc_data>-sdata = lst_e1marcm_t.
  ENDIF.

  CLEAR: li_idoc_data_rc.
  CALL FUNCTION 'ISM_IDOC_MATMAS_CREATE_MARC'
    EXPORTING
      ps_i_mara         = fp_mara
      ps_i_marc         = fp_marc
      pv_i_mestyp       = c_mtyp_matmas
    IMPORTING
      ps_e_idoc_cimtype = fp_idoc_cimtype
    TABLES
      pt_e_idoc_data    = li_idoc_data_rc.
  READ TABLE li_idoc_data_rc ASSIGNING <lst_idoc_data>
       WITH KEY segnam = c_s_e1marcism.
  IF sy-subrc EQ 0.
    lv_table_indx = sy-tabix.

    lst_e1marcism_s = <lst_idoc_data>-sdata.
    PERFORM f_transfer_fields USING    li_chgptrs
                                       lst_e1marcism_s
                              CHANGING lst_e1marcism_t.
    <lst_idoc_data>-sdata = lst_e1marcism_t.
  ENDIF.
  APPEND LINES OF li_idoc_data_rc TO fp_t_idoc_data.

ENDFORM.
