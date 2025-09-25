*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_PRODUCT_LANG_REP_R089
* PROGRAM DESCRIPTION: This report used to display Product text from
*                      Material Master.
* DEVELOPER:           Nageswara
* CREATION DATE:       08/19/2019
* OBJECT ID:           R089
* TRANSPORT NUMBER(S): ED2K915908
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include          ZQTCN_PROD_LANG_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_matnr .
  IF s_matnr IS NOT INITIAL.
*   Validate Input Material
    SELECT SINGLE matnr
           FROM mara
           INTO @DATA(iv_matnr)
           WHERE matnr IN @s_matnr.
    IF sy-subrc <> 0.
      MESSAGE text-001 TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_WERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_werks .
  IF s_werks IS NOT INITIAL.
*    Validate Input Plant
    SELECT SINGLE werks
           FROM t001w
           INTO @DATA(iv_werks)
           WHERE werks IN @s_werks.
    IF sy-subrc <> 0.
      MESSAGE text-002 TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MATERIAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_material_data .
  FREE:i_material[].
* Get Material details from tables
  SELECT mara~matnr mara~ersda mara~mtart mara~ismtitle
         marc~werks makt~spras makt~maktx
  INTO TABLE i_material
  FROM mara

  INNER JOIN marc
  ON marc~matnr = mara~matnr

  INNER JOIN makt
  ON makt~matnr = mara~matnr

  WHERE mara~matnr IN s_matnr
    AND marc~werks IN s_werks
    AND mara~ersda IN s_erdat.


  IF sy-subrc EQ 0 AND i_material[] IS NOT INITIAL.
    SORT i_material BY matnr.

* Count no. of Languages in Short Text
    DATA(lt_mat) = i_material.
    SORT lt_mat BY matnr spras.
    DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING matnr spras.
* Hold only Short texts for each material from MAKT
    i_makt_txt[] = lt_mat[].
    SORT lt_mat BY  spras.
    DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING spras.
    DESCRIBE TABLE lt_mat LINES v_makt_lines.
    FREE:lt_mat[].
* Get Product Descriptions from STXH
    SELECT tdobject tdname tdid tdspras tdtitle
       FROM stxh
       INTO TABLE i_stxh
       FOR ALL ENTRIES IN i_material
       WHERE tdobject = c_material
         AND tdname = i_material-matnr
         AND tdid = c_grun.
    IF sy-subrc EQ 0.
      SORT i_stxh[] BY tdname tdspras.
* Count no. of Languages in STXH
      DATA(lt_stxh2) = i_stxh.
      SORT lt_stxh2 BY tdspras.
      DELETE ADJACENT DUPLICATES FROM lt_stxh2 COMPARING tdspras.
      DESCRIBE TABLE lt_stxh2 LINES v_stxh_lines.
      FREE:lt_stxh2.
* Pull Basic Text of materials
      PERFORM f_basic_text.
    ENDIF.
  ELSE.
    MESSAGE text-008 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DYNAMIC_TABLE_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic_table_create .

  DATA: lt_newtab  TYPE REF TO data,
        lt_newline TYPE REF TO data,
        lv_text    TYPE char40,
        lv_cnt     TYPE sy-tabix,
        lv_tabx    TYPE char2.

*create field catelog with known fields
  FREE:i_fldcat[].
  CLEAR:st_fldcat,lv_cnt.
* Material
  lv_cnt = lv_cnt + 1.
  st_fldcat-fieldname = 'MATNR'.
  st_fldcat-datatype = 'CHAR'.
  st_fldcat-intlen = 20.
  st_fldcat-col_pos = lv_cnt.
  st_fldcat-seltext = 'Material ID'(003).
  st_fldcat-outputlen = 20.
  APPEND st_fldcat TO i_fldcat.

* Material Description
  CLEAR:st_fldcat.
  lv_cnt = lv_cnt + 1.
  st_fldcat-fieldname = 'MAKTX'.
  st_fldcat-datatype = 'CHAR'.
  st_fldcat-intlen = 40.
  st_fldcat-col_pos = lv_cnt.
  st_fldcat-seltext = 'Material Description (Product Level)'(004).
  st_fldcat-outputlen = 40.
  APPEND st_fldcat TO i_fldcat.

* Title
  CLEAR:st_fldcat.
  lv_cnt = lv_cnt + 1.
  st_fldcat-fieldname = 'ISMTITLE'.
  st_fldcat-datatype = 'CHAR'.
  st_fldcat-intlen = 80.
  st_fldcat-col_pos = lv_cnt.
  st_fldcat-seltext = 'Title (Product Level)'(005).
  st_fldcat-outputlen = 80.
  APPEND st_fldcat TO i_fldcat.

* Material Type
  CLEAR:st_fldcat.
  lv_cnt = lv_cnt + 1.
  st_fldcat-fieldname = 'MTART'.
  st_fldcat-datatype = 'CHAR'.
  st_fldcat-intlen = 4.
  st_fldcat-col_pos = lv_cnt.
  st_fldcat-seltext = 'Material Type'(006).
  st_fldcat-outputlen = 15.
  APPEND st_fldcat TO i_fldcat.

* Plant
  CLEAR:st_fldcat.
  lv_cnt = lv_cnt + 1.
  st_fldcat-fieldname = 'WERKS'.
  st_fldcat-datatype = 'CHAR'.
  st_fldcat-intlen = 4.
  st_fldcat-col_pos = lv_cnt.
  st_fldcat-seltext = 'Plant'(007).
  st_fldcat-outputlen = 10.
  APPEND st_fldcat TO i_fldcat.
  v_total = lv_cnt + v_makt_lines + v_stxh_lines + v_makt_lines + v_stxh_lines. "Each text has two columns (Lang & Descr)

* Create Short Text Fields dynamically
  DO v_makt_lines TIMES.
    CLEAR:st_fldcat,lv_tabx,v_fname,lv_text.
    lv_cnt = lv_cnt + 1.
    lv_tabx = sy-index.
    CONDENSE lv_tabx NO-GAPS.

* Short Text Langugae field
    CONCATENATE c_st_lang lv_tabx INTO v_fname IN CHARACTER MODE .
    CONCATENATE c_st_lan lv_tabx INTO lv_text IN CHARACTER MODE .
    CONDENSE v_fname NO-GAPS.
    st_fldcat-fieldname = v_fname.
    st_fldcat-datatype = 'CHAR'.
    st_fldcat-intlen = 4.
    st_fldcat-col_pos = lv_cnt.
    st_fldcat-seltext = lv_text.
    st_fldcat-outputlen = 16.
    APPEND st_fldcat TO i_fldcat.

* Short text description field
    CLEAR:st_fldcat,v_fname,lv_text.
    lv_cnt = lv_cnt + 1.
    CONCATENATE c_short_txt lv_tabx INTO v_fname IN CHARACTER MODE .
    CONCATENATE c_st_txt lv_tabx INTO lv_text IN CHARACTER MODE .
    CONDENSE v_fname NO-GAPS.
    st_fldcat-fieldname = v_fname.
    st_fldcat-datatype = 'CHAR'.
    st_fldcat-intlen = 80.
    st_fldcat-col_pos = lv_cnt.
    st_fldcat-seltext = lv_text.
    st_fldcat-outputlen = 80.
    APPEND st_fldcat TO i_fldcat.
  ENDDO.

* Create Basic  Text Fields dynamically
  DO v_stxh_lines TIMES.
    CLEAR:st_fldcat,lv_tabx,v_fname,lv_text.
    lv_cnt = lv_cnt + 1.
    lv_tabx = sy-index.
    CONDENSE lv_tabx NO-GAPS.
* Basic Text Langugae field
    CONCATENATE c_ba_lang lv_tabx INTO v_fname IN CHARACTER MODE . " Field Name
    CONCATENATE c_ba_lan lv_tabx INTO lv_text IN CHARACTER MODE .  " Filed Desctption
    CONDENSE v_fname NO-GAPS.
    st_fldcat-fieldname = v_fname.
    st_fldcat-datatype = 'CHAR'.
    st_fldcat-intlen = 4.
    st_fldcat-col_pos = lv_cnt.
    st_fldcat-seltext = lv_text.
    st_fldcat-outputlen = 16.
    APPEND st_fldcat TO i_fldcat.

* Basic text description field
    CLEAR:st_fldcat,v_fname,lv_text.
    lv_cnt = lv_cnt + 1.
    CONCATENATE c_basic_txt lv_tabx INTO v_fname IN CHARACTER MODE . " Field Name
    CONCATENATE c_ba_txt lv_tabx INTO lv_text IN CHARACTER MODE .    " Filed Desctption
    CONDENSE v_fname NO-GAPS.
    st_fldcat-fieldname = v_fname.
    st_fldcat-datatype = 'CHAR'.
    st_fldcat-intlen = 80.
    st_fldcat-col_pos = lv_cnt.
    st_fldcat-seltext = lv_text.
    st_fldcat-outputlen = 80.
    APPEND st_fldcat TO i_fldcat.
  ENDDO.

* Create Dynamic Internal Table and Assign to FS
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog           = i_fldcat
    IMPORTING
      ep_table                  = lt_newtab
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.
  IF sy-subrc EQ 0.

    ASSIGN lt_newtab->* TO <dyn_table>.

* Create Dynamic work area
    CREATE DATA lt_newline LIKE LINE OF <dyn_table>.
    ASSIGN lt_newline->* TO <dyn_wa>.   " Define work area
    DESCRIBE TABLE i_fldcat LINES v_columns.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_report .
  DATA:lst_material TYPE  ty_material,
       lv_comp      TYPE i,
       lv_fname     TYPE char20,
       lv_fval      TYPE char40,
       lv_tbx       TYPE char4,
       lv_ind       TYPE char3.
  FIELD-SYMBOLS: <lfs>.
  CONSTANTS :lc_en  TYPE sy-langu VALUE 'EN'.

  CLEAR:<dyn_table>,lv_comp.
  DATA(lv_maktlines) = v_makt_lines * 2.  " Each text has Lang and Description columns
  SORT i_material BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM i_material COMPARING matnr werks.
* Fill Dynamic Internal Table with Values
  LOOP AT i_material INTO lst_material.
    lv_comp = lv_comp + 1.
    ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
    <lfs> = lst_material-matnr.

    lv_comp = lv_comp + 1.
    ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
    READ TABLE i_makt_txt ASSIGNING FIELD-SYMBOL(<lfs_desc>) WITH KEY matnr = lst_material-matnr
                                                                      spras = lc_en BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lfs> = <lfs_desc>-maktx.
    ENDIF.

    lv_comp = lv_comp + 1.
    ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
    <lfs> = lst_material-ismtitle.

    lv_comp = lv_comp + 1.
    ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
    <lfs> = lst_material-mtart.

    lv_comp = lv_comp + 1.
    ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
    <lfs> = lst_material-werks.
    DATA(lv_flds) = lv_comp. " This helps to jump to Basic Text columns if no short text

* Populate Short Text to ALV
    LOOP AT i_makt_txt ASSIGNING FIELD-SYMBOL(<lfs_mtxt>) WHERE matnr = lst_material-matnr..
      lv_comp = lv_comp + 1.
      ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
      CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
        EXPORTING
          input  = <lfs_mtxt>-spras
        IMPORTING
          output = <lfs>.

      lv_comp = lv_comp + 1.
      ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
      <lfs> = <lfs_mtxt>-maktx.
    ENDLOOP.

* Populate Basic Text to ALV
    lv_comp = lv_flds + lv_maktlines.  "Position Basic text column to start
    LOOP AT i_text ASSIGNING FIELD-SYMBOL(<lfs_text>) WHERE matnr = lst_material-matnr.

      lv_comp = lv_comp + 1.
      ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
      CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
        EXPORTING
          input  = <lfs_text>-spras
        IMPORTING
          output = <lfs>.

      lv_comp = lv_comp + 1.
      ASSIGN COMPONENT lv_comp OF STRUCTURE <dyn_wa> TO <lfs>.
      <lfs> = <lfs_text>-text.

    ENDLOOP.
    APPEND <dyn_wa> TO <dyn_table>.
    CLEAR:lst_material,lv_comp.
    IF <dyn_wa> IS ASSIGNED.
      CLEAR: <dyn_wa>.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv .
  DATA:lv_string   TYPE string,
       lv_fname    TYPE string,
       lv_fullpath TYPE localfile,
       lv_cnt      TYPE i.
  DATA : lv_path         TYPE filepath-pathintern .
  FIELD-SYMBOLS: <lfs>.

  CONSTANTS: lc_r089       TYPE zdevid VALUE 'R089',     " Dev ID
             lc_logic      TYPE rvari_vnam VALUE 'LOGICAL_PATH',  " Logical Path
             lc_underscore TYPE char1 VALUE '_',
             lc_comma      TYPE char1 VALUE ',',
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.XLS'. " Extn of type CHAR4

  FREE:i_alvfc[].
  CLEAR:st_alvfc.
* Fill ALV field catelog from table creation field catalog
  LOOP AT i_fldcat INTO st_fldcat.
    st_alvfc-fieldname = st_fldcat-fieldname.
    st_alvfc-seltext_l = st_fldcat-seltext.
    st_alvfc-outputlen = st_fldcat-outputlen.
    IF sy-tabix > 1.
      CONCATENATE lv_string st_fldcat-seltext INTO lv_string
      SEPARATED BY cl_abap_char_utilities=>horizontal_tab
          IN CHARACTER MODE.
    ELSE.
      lv_string = st_fldcat-seltext.
    ENDIF.
    APPEND st_alvfc TO i_alvfc.
    CLEAR:st_alvfc.
  ENDLOOP.

* Check Run mode
  IF sy-batch IS INITIAL .
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        it_fieldcat   = i_alvfc
      TABLES
        t_outtab      = <dyn_table>
      EXCEPTIONS
        program_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSEIF sy-batch IS NOT INITIAL.
* Get Logical Path name
    SELECT SINGLE low FROM zcaconstant INTO @DATA(lv_logical)
       WHERE devid = @lc_r089
         AND param1 = @lc_logic
         AND activate = @abap_true.
    IF sy-subrc EQ 0.
* Generate File name in AL11
      CONCATENATE 'VCH_Prod_Lang_Rep'
                lc_underscore
                sy-datum
                lc_underscore
                sy-uzeit
                lc_extn
                INTO
                lv_fname.

      lv_path = lv_logical.
*--*Read file path from transaction FILE and create complete file path
      CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
        EXPORTING
          client                     = sy-mandt
          logical_path               = lv_path
          operating_system           = sy-opsys
          file_name                  = lv_fname
          eleminate_blanks           = abap_true
        IMPORTING
          file_name_with_path        = lv_fullpath
        EXCEPTIONS
          path_not_found             = 1
          missing_parameter          = 2
          operating_system_not_found = 3
          file_system_not_found      = 4
          OTHERS                     = 5.
      IF sy-subrc EQ 0.
* Place file in App server
        OPEN DATASET lv_fullpath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
        IF sy-subrc EQ 0.
          TRANSFER lv_string TO lv_fullpath.   " Column Names to AL11
          LOOP AT <dyn_table> INTO <dyn_wa>.
            CLEAR:lv_string.
            DO v_total TIMES.

              ASSIGN COMPONENT sy-index OF STRUCTURE <dyn_wa> TO <lfs>.
              IF sy-index > 1.
                CONCATENATE lv_string <lfs> INTO lv_string
                SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
              ELSE.
                lv_string = <lfs>.
              ENDIF.
            ENDDO.
            TRANSFER lv_string TO lv_fullpath.
          ENDLOOP.
          CLOSE DATASET lv_fullpath.
          CLEAR lv_string .
          CONCATENATE 'File processed at'(009) lv_fullpath 'successfully'(010) INTO lv_string SEPARATED BY space IN CHARACTER MODE.
          MESSAGE  lv_string TYPE 'S'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BASIC_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_basic_text .
  DATA: lt_lines TYPE TABLE OF tline,
        lst_text TYPE ty_text.
* Get for Basic text for each Material and Language
  LOOP AT i_stxh ASSIGNING FIELD-SYMBOL(<lfs_stxh>).

    FREE:lt_lines[].
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = c_grun
        language                = <lfs_stxh>-tdspras
        name                    = <lfs_stxh>-tdname
        object                  = c_material
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc EQ 0.
      CLEAR:lst_text.
      lst_text-matnr = <lfs_stxh>-tdname.
      lst_text-spras = <lfs_stxh>-tdspras.
      READ TABLE lt_lines ASSIGNING FIELD-SYMBOL(<lfs_line>) INDEX 1.
      IF sy-subrc EQ 0.
        lst_text-text = <lfs_line>-tdline.
        APPEND lst_text TO i_text.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
