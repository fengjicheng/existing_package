*---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SOCIETY_MEMBER_PRGE_SUB (Include Program)
* PROGRAM DESCRIPTION: Implementing the all the logic and data fetching
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   05/12/2020
* WRICEF ID:       R106
* TRANSPORT NUMBER(S):  ED2K918190/ ED2K918243
*---------------------------------------------------------------------*

FORM f_get_zcaconstants CHANGING
                        fp_i_constant TYPE tt_constant.

  DATA : lst_parvw TYPE ty_parvw.
  CONSTANTS : lc_parvw  TYPE rvari_vnam VALUE 'PARVW'.

  SELECT devid,                        " Development ID
         param1,                       " ABAP: Name of Variant Variable
         param2,                       " ABAP: Name of Variant Variable
         srno,                         " Current selection number
         sign,                         " ABAP: ID: I/E (include/exclude values)
         opti,                         " ABAP: Selection option (EQ/BT/CP/...)
         low,                          " Lower Value of Selection Condition
         high,                         " Upper Value of Selection Condition
         activate                      " Activation indicator for constant
       FROM zcaconstant                " Wiley Application Constant Table
       INTO TABLE @fp_i_constant
       WHERE devid    = @c_devid
       AND   activate = @abap_true.       "Only active record
  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1.
  ENDIF.

  IF i_constant IS NOT INITIAL.
    LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
      CASE <lfs_constant>-param1.      " Check partner function is ZA
        WHEN lc_parvw.
          lst_parvw-sign   = <lfs_constant>-sign.
          lst_parvw-opti   = <lfs_constant>-opti.
          lst_parvw-low    = <lfs_constant>-low.
          lst_parvw-high   = <lfs_constant>-high.
          APPEND lst_parvw TO ir_parvw.
          CLEAR lst_parvw.
      ENDCASE.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_screen_validate.

* Avoid the report run with '*' symbol
  FIND REGEX '[[:punct:]]' IN s_socbp.  " Alphanumeric validation
  IF sy-subrc = 0.
    MESSAGE s567(zqtc_r2) DISPLAY LIKE c_errtype.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM f_socbp_val_on_request CHANGING
                            fp_s_socbp TYPE but050-partner2.

  DATA : li_return  TYPE STANDARD TABLE OF ddshretval,
         lst_return TYPE ddshretval.

  DATA: li_fieldtab  TYPE STANDARD TABLE OF dfies,
        lst_fieldtab TYPE dfies.

  REFRESH i_view.

  " Fetch only Society partners for the F4 search help
  SELECT a~kunnr,
         b~name1,
         b~name2,
         b~name3,
         b~name4 FROM vbpa AS a
    INNER JOIN kna1 AS b ON a~kunnr = b~kunnr
    INTO TABLE @i_view
    WHERE a~parvw IN @ir_parvw.
  IF sy-subrc EQ 0.

    SORT i_view BY kunnr.
    DELETE ADJACENT DUPLICATES FROM i_view COMPARING kunnr.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'KUNNR'
        value_org       = 'S'
        window_title    = text-002
      TABLES
        value_tab       = i_view
        field_tab       = li_fieldtab
        return_tab      = li_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF li_return IS NOT INITIAL.
      READ TABLE li_return INTO lst_return INDEX 1. " Return selected value to screen fields
      IF sy-subrc EQ 0.
        fp_s_socbp = lst_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_fetch_data CHANGING
                  fp_i_socbp TYPE tt_socbp
                  fp_i_membp TYPE tt_membp.


  REFRESH i_view[].                     " Clear the Itab

  SELECT a~kunnr,
         b~name1,
         b~name2,
         b~name3,
         b~name4  FROM vbpa AS a
    INNER JOIN kna1 AS b ON a~kunnr = b~kunnr
    INTO TABLE @i_view
    WHERE a~kunnr IN @s_socbp AND
    a~parvw IN @ir_parvw.
  IF sy-subrc IS INITIAL.               " If ZA value found

    SELECT a~partner1,                  " Fetch Society Member details
           a~partner2,
           a~reltyp,
           a~date_to,
           a~date_from,
           a~crusr,
           a~crdat,
           a~chusr,
           a~chdat,
           b~land1,
           b~name1,
           b~name2,
           b~ort01,
           b~pstlz,
           b~regio,
           b~stras,
           b~name3,
           b~name4,
           c~bez50_2
      FROM but050 AS a
      INNER JOIN kna1 AS b ON a~partner2 = b~kunnr
      INNER JOIN tbz9a AS c ON a~reltyp = c~reltyp
      INTO TABLE @fp_i_socbp
      WHERE a~partner2 IN @s_socbp AND          " Society BP number
            a~date_from LE @sy-datum AND        " System date
            a~reltyp  IN @s_reltyp AND          " Relationship category
            c~spras = @sy-langu.                " System language

    IF sy-subrc IS INITIAL.
      IF s_reltyp IS NOT INITIAL.               " Check screen relationship field null
        DATA(lt_tmp_socbp) = fp_i_socbp[].      " copy data to temporary table
        DELETE ADJACENT DUPLICATES FROM lt_tmp_socbp COMPARING ALL FIELDS.  " Delete duplicate from temporary table
        REFRESH fp_i_socbp[].

        SELECT a~partner1,                  " Fetch members data based on selected relationship category
               a~partner2,
               a~reltyp,
               a~date_to,
               a~date_from,
               a~crusr,
               a~crdat,
               a~chusr,
               a~chdat,
               b~land1,
               b~name1,
               b~name2,
               b~ort01,
               b~pstlz,
               b~regio,
               b~stras,
               b~name3,
               b~name4,
               c~bez50_2
          FROM but050 AS a
          INNER JOIN kna1 AS b ON a~partner2 = b~kunnr
          INNER JOIN tbz9a AS c ON a~reltyp = c~reltyp
          INTO TABLE @fp_i_socbp
          FOR ALL ENTRIES IN @lt_tmp_socbp
          WHERE a~partner1 = @lt_tmp_socbp-partner1 AND          " Member BP
                a~partner2 = @lt_tmp_socbp-partner2 AND          " Society BP
                a~date_from LE @sy-datum AND                     " current date
                c~spras = @sy-langu.
        IF sy-subrc IS INITIAL.
          " Nothing to do
        ENDIF.
      ENDIF.

      SELECT kunnr,                                              " Fetch Member Master data
             land1,
             name1,
             name2,
             ort01,
             pstlz,
             regio,
             stras,
             name3,
             name4
      FROM kna1 INTO TABLE @fp_i_membp
      FOR ALL ENTRIES IN @fp_i_socbp
      WHERE kunnr = @fp_i_socbp-partner1.
      IF sy-subrc = 0.
        SORT fp_i_membp BY kunnr.
      ENDIF.
    ELSE.
      MESSAGE s563(zqtc_r2).                 " Output itab is empty and return the Message to selection screen
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    MESSAGE s568(zqtc_r2) DISPLAY LIKE c_errtype.       " Selection Screen BP is not relevant to the ZA partner function
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM f_build_data USING
                  fp_i_socbp TYPE tt_socbp
                  fp_i_membp TYPE tt_membp.

  DATA : lv_count TYPE i.
  FIELD-SYMBOLS : <lfs_final> TYPE ty_final.

  SORT fp_i_socbp DESCENDING BY partner1 date_from.         " Sort Itab to descending order to get the latest validity start date

  LOOP AT fp_i_socbp ASSIGNING FIELD-SYMBOL(<lfs_socbp>).
    AT NEW partner1.                " If new member, add new row to output
      CLEAR lv_count.
      APPEND INITIAL LINE TO i_final ASSIGNING <lfs_final>.
      <lfs_final>-society = <lfs_socbp>-partner2.
      CONCATENATE <lfs_socbp>-name1 <lfs_socbp>-name2 <lfs_socbp>-name3 <lfs_socbp>-name4
              INTO <lfs_final>-soc_name SEPARATED BY space.
      <lfs_final>-crusr    = <lfs_socbp>-chusr.
      <lfs_final>-crdat    = <lfs_socbp>-crdat.
      <lfs_final>-chusr    = <lfs_socbp>-chusr.
      <lfs_final>-chdat    = <lfs_socbp>-chdat.
      <lfs_final>-soc_stras  = <lfs_socbp>-stras.
      <lfs_final>-soc_ort01  = <lfs_socbp>-ort01.
      <lfs_final>-soc_pstlz  = <lfs_socbp>-pstlz.
      <lfs_final>-soc_land1  = <lfs_socbp>-land1.
      <lfs_final>-soc_regio  = <lfs_socbp>-regio.
      <lfs_final>-member     = <lfs_socbp>-partner1.
      <lfs_final>-c_reltyp   = <lfs_socbp>-reltyp.
      <lfs_final>-c_descrp   = <lfs_socbp>-bez50_2.
      <lfs_final>-c_dfrom    = <lfs_socbp>-date_from.
      <lfs_final>-c_dto      = <lfs_socbp>-date_to.
    ENDAT.

    " Read member master data
    READ TABLE i_membp ASSIGNING FIELD-SYMBOL(<lfs_membp>) WITH KEY kunnr = <lfs_socbp>-partner1 BINARY SEARCH.
    IF sy-subrc = 0.
      CONCATENATE <lfs_membp>-name1 <lfs_membp>-name2 <lfs_membp>-name3 <lfs_membp>-name4
                INTO <lfs_final>-mem_nam SEPARATED BY space.
      <lfs_final>-mem_stras = <lfs_membp>-stras.
      <lfs_final>-mem_ort01 = <lfs_membp>-ort01.
      <lfs_final>-mem_pstlz = <lfs_membp>-pstlz.
      <lfs_final>-mem_land1 = <lfs_membp>-land1.
      <lfs_final>-mem_regio = <lfs_membp>-regio.
    ENDIF.
    lv_count = lv_count + 1.                            " To identify the same member

    CASE lv_count.
      WHEN 2.                                           " Assign previous relationship type
        <lfs_final>-c1_reltyp   = <lfs_socbp>-reltyp.
        <lfs_final>-c1_descrp   = <lfs_socbp>-bez50_2.
        <lfs_final>-c1_dfrom    = <lfs_socbp>-date_from.
        <lfs_final>-c1_dto      = <lfs_socbp>-date_to.
      WHEN 3.                                           " Assign previous to previous relationship type
        <lfs_final>-c2_reltyp   = <lfs_socbp>-reltyp.
        <lfs_final>-c2_descrp   = <lfs_socbp>-bez50_2.
        <lfs_final>-c2_dfrom    = <lfs_socbp>-date_from.
        <lfs_final>-c2_dto      = <lfs_socbp>-date_to.
      WHEN OTHERS.
        CONTINUE.                                       " Exceed the third relationship it will return to next line
    ENDCASE.

  ENDLOOP.

ENDFORM.

FORM f_display_data.

  PERFORM f_build_fieldcat_r106.        " Build field catalog
  IF i_fieldcat_r106[] IS NOT INITIAL.
    PERFORM f_display_alv.              " Display ALV output
  ENDIF.

ENDFORM.

FORM f_build_fieldcat_r106.

  CLEAR : st_fieldcat_r106 ,i_fieldcat_r106[].

  PERFORM f_build_fcat_r106 USING : 'MEMBER' 'I_FINAL' text-003 '10' '' abap_false,
                                    'MEM_NAM' 'I_FINAL' text-004 '35' '' abap_false,
                                    'C_RELTYP' 'I_FINAL' text-005 '6' '' abap_false,
                                    'C_DESCRP' 'I_FINAL' text-006 '50' '' abap_false,
                                    'C_DFROM' 'I_FINAL' text-007 '' '' abap_false,
                                    'C_DTO' 'I_FINAL' text-008 '' '' abap_false,
                                    'C1_RELTYP' 'I_FINAL' text-009 '6' '' abap_false,
                                    'C1_DESCRP' 'I_FINAL' text-010 '50' '' abap_false,
                                    'C1_DFROM' 'I_FINAL' text-011 '' '' abap_false,
                                    'C1_DTO' 'I_FINAL' text-012 '' '' abap_false,
                                    'C2_RELTYP' 'I_FINAL' text-013 '6' '' abap_false,
                                    'C2_DESCRP' 'I_FINAL' text-014 '50' '' abap_false,
                                    'C2_DFROM' 'I_FINAL' text-015 '' '' abap_false,
                                    'C2_DTO' 'I_FINAL' text-016 '' '' abap_false,
                                    'SOCIETY' 'I_FINAL' text-017 '10' '' abap_false,
                                    'SOC_NAME' 'I_FINAL' text-018 '35' '' abap_false,
                                    'CRUSR' 'I_FINAL' text-019 '12' '' abap_true,
                                    'CRDAT' 'I_FINAL' text-020 '' '' abap_true,
                                    'CHUSR' 'I_FINAL' text-021 '12' '' abap_true,
                                    'CHDAT' 'I_FINAL' text-022 '' '' abap_true,
                                    'MEM_STRAS' 'I_FINAL' text-023 '35' '' abap_true,
                                    'MEM_ORT01' 'I_FINAL' text-024 '35' '' abap_true,
                                    'MEM_PSTLZ' 'I_FINAL' text-025 '10' '' abap_true,
                                    'MEM_LAND1' 'I_FINAL' text-026 '3' '' abap_true,
                                    'MEM_REGIO' 'I_FINAL' text-027 '3' '' abap_true,
                                    'SOC_STRAS' 'I_FINAL' text-028 '35' '' abap_true,
                                    'SOC_ORT01' 'I_FINAL' text-029 '35' '' abap_true,
                                    'SOC_PSTLZ' 'I_FINAL' text-030 '10' '' abap_true,
                                    'SOC_LAND1' 'I_FINAL' text-031 '3' '' abap_true,
                                    'SOC_REGIO' 'I_FINAL' text-032 '3' '' abap_true.

ENDFORM.

FORM f_build_fcat_r106 USING fp_field TYPE any    " Field Name
                             fp_tab TYPE any      " Itab Name
                             fp_text TYPE any     " Display Text
                             fp_ddout TYPE any    " ALV filtering box length
                             fp_outlen TYPE any   " Output length in ALV grid
                             fp_output TYPE any.  " Decimal output

  st_fieldcat_r106-fieldname = fp_field.
  st_fieldcat_r106-tabname   = fp_tab.
  st_fieldcat_r106-seltext_l   = fp_text.
  st_fieldcat_r106-lowercase  = abap_true.
  st_fieldcat_r106-ddic_outputlen = fp_ddout.
  st_fieldcat_r106-outputlen = fp_outlen.
  st_fieldcat_r106-no_out   = fp_output.

  APPEND st_fieldcat_r106 TO i_fieldcat_r106.
  CLEAR st_fieldcat_r106.

  v_layout-no_input = abap_true.
  v_layout-colwidth_optimize = abap_true.
  v_layout-zebra = abap_true.

ENDFORM.

FORM f_display_alv .

  IF i_final IS NOT INITIAL. " Check whether itab is empty
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid               " Program name
        is_layout          = v_layout               " Layout
        it_fieldcat        = i_fieldcat_r106[]      " Field catalog
        it_sort            = i_sort                 " Sort
        i_save             = c_standard             " Variant save
        it_events          = i_events               " ALV events
      TABLES
        t_outtab           = i_final                " result output table
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDFORM.
