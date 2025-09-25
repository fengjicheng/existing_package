*&---------------------------------------------------------------------*
*& Report  ZQTCR_TR_DEPENDENCE_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_tr_dependence_report NO STANDARD PAGE HEADING LINE-SIZE 256 LINE-COUNT 65.

TYPES : BEGIN OF ty_final,
          object        TYPE trobjtype,  "Object Type
          obj_name      TYPE sobj_name,  "Obj Name in Obj Directory
          devclass      TYPE devclass,   "Package
          strkorr       TYPE strkorr,    "Higher-Level Request
          text          TYPE as4text,    "Short Desc of Rep. Objects
          trstatus(27)  TYPE c,          "Status
          ddtext        TYPE ddtext,     "Explanatory short text
          expto         TYPE char50,     "Exported To
          line_color    TYPE char4,      "Line Color
          err_msg       TYPE natxt,      "Error Message
          dep_transport TYPE strkorr,    " Higher-Level Request
*          cellcolor     TYPE lvc_t_scol, "ALV cont:Tab for cell col
        END OF ty_final,

        BEGIN OF ty_fm,
          object     TYPE trobjtype,  "Object Type
          obj_name   TYPE sobj_name,  "Obj Name in Obj Directory
          func       TYPE rs38l_fnam, "Name of Function Module
          genflag(1) TYPE c,          "Gen flag
        END OF ty_fm.


DATA:lt_final  TYPE STANDARD TABLE OF ty_final,
     lst_final TYPE ty_final,
     lt_fm     TYPE STANDARD TABLE OF ty_fm,
     lst_fm    TYPE ty_fm.

TABLES:e070v,e070,e07t.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s01.
SELECT-OPTIONS: s_trkorr FOR e070-trkorr,
                s_des    FOR e07t-as4text,
                s_user   FOR e070v-as4user,
                s_date   FOR e070v-as4date.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION.

  SELECT *
      INTO TABLE @DATA(lt_e070)
      FROM e070
      WHERE strkorr IN @s_trkorr.
  IF sy-subrc = 0 AND lt_e070 IS NOT INITIAL.
    SELECT *
       INTO TABLE @DATA(lt_e070_t)
       FROM e070
       FOR ALL ENTRIES IN @lt_e070
       WHERE trkorr = @lt_e070-strkorr.
    IF sy-subrc = 0.
    ENDIF. " IF sy-subrc = 0
    SELECT  *
      FROM e071
      INTO TABLE @DATA(lt_e071)
      FOR ALL ENTRIES IN @lt_e070
      WHERE trkorr = @lt_e070-trkorr.

    SELECT *
         FROM e07t
         INTO TABLE @DATA(lt_e07t)
       FOR ALL ENTRIES IN @lt_e070
         WHERE ( trkorr = @lt_e070-strkorr
           OR trkorr = @lt_e070-trkorr )
           AND langu = @sy-langu.
  ENDIF.
  LOOP AT lt_e070 INTO DATA(lst_e070).
    READ TABLE lt_e071 INTO DATA(lst_e071) WITH KEY trkorr = lst_e070-trkorr.
    IF sy-subrc = 0.
      DATA(lv_tabix) = sy-tabix.
      LOOP AT lt_e071 INTO lst_e071 FROM lv_tabix."WHERE trkorr = lst_e070-trkorr
        IF lst_e071-trkorr <> lst_e070-trkorr.
          EXIT.
        ELSE.
*           OR trkorr = lst_e070-strkorr.
          IF lst_e070-strkorr IS INITIAL.
            MOVE lst_e070-trkorr TO lst_final-strkorr.
          ELSE.
            MOVE lst_e070-strkorr TO lst_final-strkorr.
          ENDIF.
          MOVE lst_e071-object   TO lst_final-object.
          MOVE lst_e071-obj_name TO lst_final-obj_name.
          READ TABLE lt_e070_t INTO DATA(lst_e070_t) WITH KEY trkorr = lst_e070-strkorr.
          IF sy-subrc = 0.
            DATA(lv_status) = lst_e070_t-trstatus.
          ELSE.
            lv_status = lst_e070-trstatus.
          ENDIF.
          CASE lv_status.
            WHEN 'D'.
              MOVE 'Modifiable' TO lst_final-trstatus.
            WHEN 'L'.
              MOVE 'Modifiable, Protected' TO lst_final-trstatus.
            WHEN 'O'.
              MOVE 'Release Started' TO lst_final-trstatus.
            WHEN 'R'.
              MOVE 'Released' TO lst_final-trstatus.
            WHEN 'N'.
              MOVE 'Released (with Import)' TO lst_final-trstatus.
          ENDCASE.
          READ TABLE lt_e07t INTO DATA(lst_e07t) WITH  KEY trkorr = lst_e070-strkorr.
          IF sy-subrc = 0.
            MOVE lst_e07t-as4text TO lst_final-text.
          ELSE.
            CLEAR: lst_e07t-as4text, lst_final-text.
          ENDIF.
          CASE lst_e071-object.
            WHEN 'DTED'.
              MOVE 'DTEL' TO lst_final-object.
            WHEN 'DOMD'.
              MOVE 'DOMA' TO lst_final-object.
            WHEN 'REPO' OR 'REPS' OR 'REPT'.
              MOVE 'PROG' TO lst_final-object.
          ENDCASE.
          APPEND lst_final TO lt_final.
          IF lst_e071-object EQ 'FUNC'.
            MOVE lst_e071-obj_name TO lst_fm-func.
            MOVE lst_e071-object   TO lst_fm-object.
            APPEND lst_fm TO lt_fm.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  IF lt_fm IS NOT INITIAL.
    SELECT *
      FROM enlfdir
      INTO TABLE @DATA(lt_enlfdir)
      FOR ALL ENTRIES IN @lt_fm
        WHERE funcname = @lt_fm-func.
    IF sy-subrc = 0 AND lt_enlfdir IS NOT INITIAL.
      SELECT  *
        FROM e071
        INTO TABLE @DATA(lt_objname)
*        FOR ALL ENTRIES IN @lt_enlfdir
        WHERE pgmid  = 'R3TR'
         AND  object = 'FUGR'.
*         AND  OBJ_NAME = @lt_enlfdir-obj_name.
      CONCATENATE sy-sysid 'K' '%' INTO DATA(lv_sysid).
      IF sy-subrc = 0 AND lt_objname IS NOT INITIAL.
        DELETE lt_objname WHERE trkorr+0(4) <> lv_sysid+0(4).
        SORT lt_objname BY trkorr DESCENDING obj_name ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_objname COMPARING obj_name.

        SELECT *
             INTO TABLE @DATA(lt_trnums)
             FROM e070
             FOR ALL ENTRIES IN @lt_objname
             WHERE trkorr = @lt_objname-trkorr.

        SELECT *
          FROM e07t
          INTO TABLE @DATA(lt_as4text)
          FOR ALL ENTRIES IN @lt_trnums
          WHERE ( trkorr = @lt_trnums-strkorr
            OR trkorr = @lt_trnums-trkorr )
            AND langu = @sy-langu.
      ENDIF.
    ENDIF.

    LOOP AT lt_enlfdir INTO DATA(lst_enlfdir).
      READ TABLE lt_objname INTO DATA(lst_objname) INDEX 1." WITH KEY obj_name = lst_enlfdir-obj_name.
      IF sy-subrc = 0.
        READ TABLE lt_trnums INTO DATA(lst_trnum)  WITH KEY trkorr = lst_objname-trkorr.
        IF sy-subrc = 0.
          lst_final-strkorr = lst_trnum-strkorr.
          CASE lst_trnum-trstatus.
            WHEN 'D'.
              MOVE 'Modifiable' TO lst_final-trstatus.
            WHEN 'L'.
              MOVE 'Modifiable, Protected' TO lst_final-trstatus.
            WHEN 'O'.
              MOVE 'Release Started' TO lst_final-trstatus.
            WHEN 'R'.
              MOVE 'Released' TO lst_final-trstatus.
            WHEN 'N'.
              MOVE 'Released (with Import)' TO lst_final-trstatus.
          ENDCASE.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0
      READ TABLE lt_as4text INTO DATA(lst_as4text) WITH KEY trkorr = lst_trnum-strkorr.
      IF sy-subrc = 0.
        lst_final-text = lst_as4text-as4text.
      ELSE.
        READ TABLE lt_as4text INTO lst_as4text WITH KEY trkorr = lst_trnum-trkorr.
        IF sy-subrc = 0.
          lst_final-text = lst_as4text-as4text.
        ENDIF.
      ENDIF.
      MOVE lst_enlfdir-area TO lst_final-obj_name.
      MOVE 'FUGR' TO lst_final-object.
      APPEND lst_final TO lt_final.
      CLEAR: lst_enlfdir, lst_final.
    ENDLOOP.
  ENDIF.


  SORT lt_final BY strkorr object obj_name .
  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING strkorr object obj_name.

  IF NOT lt_final IS INITIAL.
    SELECT object,
           obj_name,
           devclass
        FROM tadir
        INTO TABLE @DATA(lt_tadir)
        FOR ALL ENTRIES IN @lt_final
        WHERE pgmid     = 'R3TR' AND
              object    = @lt_final-object AND
              obj_name  = @lt_final-obj_name.
    IF sy-subrc = 0.
      LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<fs_lst_final>).
        IF <fs_lst_final>-object = 'FUNC'.
          READ TABLE lt_enlfdir INTO lst_enlfdir WITH KEY funcname = <fs_lst_final>-obj_name+0(30).
          IF sy-subrc = 0.
            READ TABLE lt_tadir INTO DATA(lst_tadir) WITH KEY object = 'FUGR'
                                                              obj_name = lst_enlfdir-area.
            IF sy-subrc EQ 0.
              MOVE lst_tadir-devclass TO <fs_lst_final>-devclass. "  class
            ENDIF.
          ENDIF.
        ELSE.
          READ TABLE lt_tadir INTO lst_tadir  WITH KEY object = <fs_lst_final>-object
                                                       obj_name = <fs_lst_final>-obj_name.
          IF sy-subrc EQ 0.
            MOVE lst_tadir-devclass TO <fs_lst_final>-devclass. "  class
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.



    LOOP AT lt_tadir INTO lst_tadir.
      READ TABLE lt_final INTO lst_final WITH KEY  object = lst_tadir-object
                                                   obj_name = lst_tadir-obj_name.
      IF sy-subrc EQ 0.
        PERFORM f_repository_environment USING lst_final.

      ENDIF.
    ENDLOOP.


**Checking for z/y objects
*    LOOP AT i_senvi_tab INTO wa_senvi_tab.
*      IF wa_senvi_tab-type = 'SBXL' OR
*         wa_senvi_tab-object+0(1) = c_obj_name_z  OR
*         wa_senvi_tab-object+0(1) = c_obj_name_y  OR
*         wa_senvi_tab-object+0(2) = c_obj_name_lz OR
**      begin of change  15 Jan 15
*         wa_senvi_tab-object IN  i_name_space OR
**      end of change  15 Jan 15
*        ( wa_senvi_tab-object+4(1) = c_obj_name_z AND
*         wa_senvi_tab-object+0(1) = c_obj_name_s ).
*        wa_senvi_tab-genflag = c_genflag_d.
*        MODIFY i_senvi_tab FROM wa_senvi_tab.
*      ENDIF. " IF wa_senvi_tab-type = 'SBXL' OR
*    ENDLOOP. " LOOP AT i_senvi_tab INTO wa_senvi_tab
*
*    DELETE i_senvi_tab WHERE genflag <> c_genflag_d.

* Get transport details for function module
*    PERFORM sub_tr_function_modules.

* Get the derectory informatio
*    PERFORM sub_get_from_tadir.
*
** Get transport details
*    PERFORM sub_get_transport_details.

  ENDIF. " IF lt_final IS NOT INITIAL

FORM f_repository_environment USING plst_final.


  TYPES: l_x_tab_page      TYPE tsffbcntpa,
         l_x_tab_window    TYPE tsffbcntwi,
         l_x_tab_text_item TYPE tsffbcntti,
         l_x_tab_graphic   TYPE tsffbcntgr,
         l_x_tab_address   TYPE tsffbcntad,
         l_x_tab_command   TYPE tsffbcntcm,
         l_x_tab_code      TYPE tsffbcntco,
         l_x_tab_condition TYPE tsffbcntcd,

         l_x_tab_section   TYPE tsffbcntse,
         l_x_tab_event     TYPE tsffbcntev,
         l_x_tab_outattr   TYPE tsffbcntoa.

  TYPES: BEGIN OF l_x_text_items,
           name TYPE tdline,     " Text Line
         END OF l_x_text_items,

         BEGIN OF l_x_style,
           style TYPE tdssname,  " SAP Smart Styles: Style name
         END OF l_x_style,

         BEGIN OF l_x_barcode,
           barcode TYPE char120, " Barcode of type CHAR120
         END OF l_x_barcode.

  DATA: i_senvi_tab TYPE STANDARD TABLE OF senvi   INITIAL SIZE 0.
  " SINFO_ENVIRONMENT for Remote Interface (Compatibility)
  DATA: l_i_rsfind   TYPE STANDARD TABLE OF rsfind  INITIAL SIZE 0,
        " Search Strings for RS_EU_CROSSREFERENCE
        t_xml        TYPE efg_tab_xml_smartform,
        l_i_text     TYPE STANDARD TABLE OF l_x_text_items INITIAL SIZE
        0,
        l_i_style    TYPE STANDARD TABLE OF l_x_style,
        l_i_string   TYPE STANDARD TABLE OF ssfstrings,
        " Smart Styles: Character Format Entry
        l_i_barcode  TYPE STANDARD TABLE OF ssfstrings,
        " Smart Styles: Character Format Entry
        l_i_barcodes TYPE STANDARD TABLE OF l_x_barcode,
        l_i_e071k    TYPE STANDARD TABLE OF e071k   INITIAL SIZE 0.
  " Change & Transport System: Key Entries of Requests/Tasks

  DATA: l_form   TYPE efg_strn_smartform, " Smart Form
        l_values TYPE REF TO cl_ssf_fb_smart_form,
        " CL_SSF_FB_SMART_FORM
        variant  TYPE tdvariant.          " Smart Forms: Variant
  " Smart Forms: Variant

  DATA:
    l_w_style   TYPE l_x_style,
    l_w_text    TYPE l_x_text_items,
    l_w_string  TYPE ssfstrings,
    " Smart Styles: Character Format Entry
    l_w_barcode TYPE l_x_barcode,
    l_w_logo    TYPE  ssfgkeybdl,
    " Smart Forms: Graphic Key (BDS) (Long)
    l_i_logo    TYPE STANDARD TABLE OF ssfgkeybdl.
  " Smart Forms: Graphic Key (BDS) (Long)

  DATA: l_varheader  LIKE LINE OF l_values->varheader,
        l_pages      TYPE l_x_tab_page      WITH HEADER LINE,
        l_windows    TYPE l_x_tab_window    WITH HEADER LINE,
        l_text_items TYPE l_x_tab_text_item WITH HEADER LINE,
        l_graphics   TYPE l_x_tab_graphic   WITH HEADER LINE,
        l_addresses  TYPE l_x_tab_address   WITH HEADER LINE,
        l_commands   TYPE l_x_tab_command   WITH HEADER LINE,
        l_codes      TYPE l_x_tab_code      WITH HEADER LINE,
        l_conditions TYPE l_x_tab_condition WITH HEADER LINE,
        l_sections   TYPE l_x_tab_section   WITH HEADER LINE,
        l_events     TYPE l_x_tab_event     WITH HEADER LINE,
        lv_comp_rel  TYPE saprelease, " SAP Release
        l_outattrs   TYPE l_x_tab_outattr   WITH HEADER LINE.

*To get the dependent Objects related to the objects from se09.

  IF lst_final-object IS NOT INITIAL.
    IF lst_final-object = 'SSFO'.
      "Smartform " Check whether it is a text module or a smartform
      DATA:lv_fmname    TYPE  rs38l_fnam,
           lv_smartform TYPE  tdsfname.

      lv_smartform = lst_final-obj_name.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = lv_smartform
        IMPORTING
          fm_name            = lv_fmname
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.

      IF sy-subrc = 0.
        SELECT
          SINGLE pname " Program Name
          FROM tfdir   " Function Module
          INTO @DATA(lv_prog)
          WHERE funcname = @lv_fmname.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF lst_final-object = 'SSFO'
    DATA:lv_obj_type TYPE seu_obj.
*               lv_prog     TYPE tadir-obj_name.
    MOVE lst_final-object TO lv_obj_type.
  ENDIF. " IF lst_final-object IS NOT INITIAL
  IF lst_final-obj_name IS NOT INITIAL.
    MOVE lst_final-obj_name TO lv_prog.
  ENDIF.
*      ENDIF.


  IF NOT lv_obj_type IS INITIAL AND
       lv_prog IS NOT INITIAL.
    IF lv_fmname IS INITIAL.
      IF lst_final-object = 'SXCI'.
        SELECT imp_class  " Object Type Name
          FROM sxc_class
          " Exit, implementation side: Class assignment (multiple)
          INTO @DATA(lst_prog)
          UP TO 1  ROWS
          WHERE imp_name = @lst_final-obj_name+0(20).
        ENDSELECT.
      ENDIF. " IF wa_curr-object = 'SXCI'
*      ENDIF.
*    ENDIF.
      IF lst_prog IS NOT INITIAL.
*
*        CALL FUNCTION 'REPOSITORY_ENVIRONMENT_ALL'
*              EXPORTING
*                obj_type          = lv_obj_type
**                environment_types = wa_envi_types
*                object_name       = lv_prog
*                deep              = '1'
**          deep = 2
*              TABLES
**                environment_tab   = l_i_senvi_tab
*                source_objects    = l_i_rsfind.
*      ELSE. " ELSE -> IF l_prog IS NOT INITIAL
*        CALL FUNCTION 'REPOSITORY_ENVIRONMENT_ALL'
*              EXPORTING
*                obj_type          = v_obj_type
**                environment_types = wa_envi_types
**                object_name       = p_prog
*                deep              = '1'
**          deep = 2
*              TABLES
*                environment_tab   = l_i_senvi_tab
*                source_objects    = l_i_rsfind.
*
*      ENDIF. " IF l_prog IS NOT INITIAL

      ELSE. " ELSE -> IF l_fmname IS INITIAL


*      CALL FUNCTION 'REPOSITORY_ENVIRONMENT_ALL'
*        EXPORTING
*          obj_type          = 'PROG'
*          environment_types = wa_envi_types
*          object_name       = l_prog
**          deep = 2
*          deep              = l_c_deep_1
*        TABLES
*          environment_tab   = l_i_senvi_tab
*          source_objects    = l_i_rsfind.
*
**Fetch other details like logos, text modules, text module translations
**,
**styles , barcodes
*      CALL FUNCTION 'EFG_SMARTFORM_READ'
*        EXPORTING
*          x_smartform      = l_smartform
*        IMPORTING
*          y_strn_smartform = l_form
*        EXCEPTIONS
*          not_qualified    = 1
*          not_found        = 2
*          failed           = 3
*          OTHERS           = 4.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF. " IF sy-subrc <> 0
*
*      t_xml[] = l_form-t_xml[].
*      CALL FUNCTION 'OCS_COMPONENT_LATEST_PATCH'
*        EXPORTING
*          iv_component            = 'SAP_ABA'
*       IMPORTING
*         ev_comp_rel             = lv_comp_rel
**   EV_COMP_LEVEL           = lv_comp_level
**   EV_COMP_TYPE            =
**   EV_LAST_PATCH           =
*       EXCEPTIONS
*         unknown_component       = 1
*         spam_in_progress        = 2
*         internal_error          = 3
*         OTHERS                  = 4
*                .
*      IF sy-subrc = 0.
*        IF lv_comp_rel <= 700.
*          CALL FUNCTION 'EFG_SMARTFORM_GET_FROM_XML'
*            EXPORTING
*              x_strn_smartform = l_form
*            IMPORTING
*              y_rcl_smartform  = l_values
*            EXCEPTIONS
*              not_qualified    = 1
*              failed           = 2
*              OTHERS           = 3.
*          IF sy-subrc <> 0.
** Implement suitable error handling here
*          ENDIF. " IF sy-subrc <> 0
*        ELSE. " ELSE -> IF lv_comp_rel <= 700
*          CALL FUNCTION 'EFG_SMARTFORM_GET_FROM_XML'
*            EXPORTING
*              x_strn_smartform = l_form
*            IMPORTING
*              y_ref_smartform  = l_values
*            EXCEPTIONS
*              not_qualified    = 1
*              failed           = 2
*              OTHERS           = 3.
*          IF sy-subrc <> 0.
** Implement suitable error handling here
*          ENDIF. " IF sy-subrc <> 0
*        ENDIF. " IF lv_comp_rel <= 700
*
*      ENDIF. " IF sy-subrc = 0
*      PERFORM get_varheader IN PROGRAM saplstxb
*                                 USING l_values
*                                       variant
*                              CHANGING l_varheader.
*
*      PERFORM get_all_nodes IN PROGRAM saplstxb
*        TABLES l_pages
*               l_windows
*               l_text_items
*               l_graphics
*               l_addresses
*               l_commands
*               l_codes
*               l_conditions
*               l_sections
*               l_events
*               l_outattrs
*         USING l_values.
*
**Find the logo
*      LOOP AT l_graphics.
*        l_w_logo = l_graphics-obj->gkeybds.
*        APPEND l_w_logo TO l_i_logo.
*      ENDLOOP. " LOOP AT l_graphics
*      IF l_i_logo[] IS NOT INITIAL.
*        SELECT *
*          FROM stxbitmaps " SAPscript Graphics Management
*          INTO TABLE i_docid
*          FOR ALL ENTRIES IN l_i_logo
*          WHERE tdobject = l_i_logo-object+0(10)
*          AND   tdname   = l_i_logo-name+0(70)
*          AND   tdid     = l_i_logo-id+0(4)
*          AND   tdbtype  = l_i_logo-btype+0(4).
*
*        IF sy-subrc = 0.
*          LOOP AT i_docid INTO wa_docid.
*            wa_senvi_tab-pgmid = 'R3TR'.
*            wa_senvi_tab-type = 'SBXL'.
*            wa_senvi_tab-object = wa_docid-docid+10(32).
*            APPEND  wa_senvi_tab TO l_i_senvi_tab.
*            CLEAR: wa_senvi_tab, wa_docid.
*          ENDLOOP. " LOOP AT i_docid INTO wa_docid
*        ENDIF. " IF sy-subrc = 0
*      ENDIF. " IF l_i_logo[] IS NOT INITIAL
*      l_w_style-style = l_varheader-stdstyle.
*      APPEND l_w_style TO l_i_style.
*      LOOP AT l_text_items.
*        IF l_text_items-obj->style_name+0(1) = 'Z' AND
*           l_text_items-obj->style_name NE l_varheader-stdstyle .
*          l_w_style-style = l_text_items-obj->style_name.
*          APPEND l_w_style TO l_i_style.
*        ENDIF. " IF l_text_items-obj->style_name+0(1) = 'Z' AND
*
*        IF l_text_items-obj->ref_style+0(1) = 'Z'
*          AND  l_text_items-obj->ref_style NE l_varheader-stdstyle .
*
*          l_w_style-style = l_text_items-obj->ref_style.
*          APPEND l_w_style TO l_i_style.
*
*        ENDIF. " IF l_text_items-obj->ref_style+0(1) = 'Z'
*
*        IF l_text_items-obj->ttype = 'R'. "Text module
*          IF l_text_items-obj->ref_name+0(1) = 'Y'
*            OR  l_text_items-obj->ref_name+0(1) = 'Z'.
*            l_w_text-name = l_text_items-obj->ref_name.
*            APPEND l_w_text TO l_i_text.
*          ENDIF. " IF l_text_items-obj->ref_name+0(1) = 'Y'
*        ENDIF. " IF l_text_items-obj->ttype = 'R'
*      ENDLOOP. " LOOP AT l_text_items
*
**Find if any custom barcode is used in any character format
*      LOOP AT l_i_style INTO l_w_style.
*        CALL FUNCTION 'SSF_READ_STYLE'
*          EXPORTING
*            i_style_name             = l_w_style-style
*            i_style_active_flag      = 'A'
*          TABLES
*            e_strings                = l_i_string
*          EXCEPTIONS
*            no_name                  = 1
*            no_style                 = 2
*            active_style_not_found   = 3
*            inactive_style_not_found = 4
*            no_variant               = 5
*            no_main_variant          = 6
*            cancelled                = 7
*            no_access_permission     = 8
*            OTHERS                   = 9.
*        IF sy-subrc = 0.
**Implement suitable error handling here
*          wa_senvi_tab-type = 'SSST'.
*          wa_senvi_tab-object = l_w_style-style.
*          APPEND  wa_senvi_tab TO l_i_senvi_tab.
*          CLEAR: wa_senvi_tab.
*
*        ENDIF. " IF sy-subrc = 0
*        DELETE l_i_string WHERE tdbarcode+0(1) NE 'Z'.
*        IF l_i_string[] IS NOT INITIAL.
*          APPEND LINES OF l_i_string TO l_i_barcode.
*        ENDIF. " IF l_i_string[] IS NOT INITIAL
*      ENDLOOP. " LOOP AT l_i_style INTO l_w_style
*
*      LOOP AT l_i_barcode INTO l_w_string.
*        l_w_barcode-barcode = l_w_string-tdbarcode.
*        APPEND l_w_barcode TO l_i_barcodes.
*      ENDLOOP. " LOOP AT l_i_barcode INTO l_w_string
*
*      IF l_i_barcode[] IS NOT INITIAL.
*
*      ENDIF. " IF l_i_barcode[] IS NOT INITIAL
*
**Find out if text is translated in any other language
*      IF l_i_text[] IS NOT INITIAL.
*        SELECT *
*           FROM stxftxt " SAP Smart Forms: Texts
*           INTO TABLE i_texts
*           FOR ALL ENTRIES IN l_i_text
*           WHERE txtype = 'F'
*           AND formname = l_i_text-name+0(30).
*
*        IF sy-subrc = 0.
*
*          DELETE i_texts WHERE tdline IS INITIAL.
*          SORT i_texts BY spras formname.
*          DELETE ADJACENT DUPLICATES FROM i_texts COMPARING spras
*          formname.
*          LOOP AT i_texts INTO wa_text.
*            wa_senvi_tab-object =  wa_text-formname.
*            wa_senvi_tab-type = 'SSFO'.
*            APPEND  wa_senvi_tab TO l_i_senvi_tab.
*          ENDLOOP. " LOOP AT i_texts INTO wa_text
*        ENDIF. " IF sy-subrc = 0
*      ENDIF. " IF l_i_text[] IS NOT INITIAL
**    ENDIF. " IF l_fmname IS INITIAL
*
*    MOVE v_obj_type TO wa_itab-object.
*    MOVE p_prog TO wa_itab-obj_name.
*    MOVE v_obj_type TO wa_senvi_tab-type.
*    MOVE p_prog TO wa_senvi_tab-object.
*    APPEND wa_itab TO i_itab.
*
*    CLEAR: wa_itab, wa_senvi_tab.
*    APPEND LINES OF l_i_senvi_tab TO i_senvi_tab.
*    APPEND LINES OF l_i_rsfind TO i_rsfind.
**    ENDLOOP.
      ENDIF. " IF NOT v_obj_type IS INITIAL AND
    ENDIF. " IF NOT v_obj_type IS INITIAL AND
  ENDIF. " IF NOT v_obj_type IS INITIAL AND
ENDFORM.
