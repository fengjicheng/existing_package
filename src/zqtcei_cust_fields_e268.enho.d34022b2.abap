"Name: \PR:SAPLMEREP\TY:LCL_REPORTING_VIEW\ME:START\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_CUST_FIELDS_E268.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923403
* REFERENCE NO: E268
* DEVELOPER: Thilina Dimantha
* DATE: 12-May-2021
* DESCRIPTION: Add PO History related fields to ME2N ME2M Output
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923969
* REFERENCE NO: E268 / OTCM-48208
* DEVELOPER: Thilina Dimantha
* DATE: 29-June-2021
* DESCRIPTION: Output Changes for ME2M and ME2N
*-----------------------------------------------------------------------*
  CONSTANTS:
      lc_wricef_id_e268 TYPE zdevid VALUE 'E268',      "Constant value for WRICEF (E268)
      lc_ser_num_e268 TYPE zsno   VALUE '001',         "Serial Number (001)
      lc_base TYPE syst-ucomm VALUE 'MEBASE',          "Basic View
      lc_schedule TYPE syst-ucomm VALUE 'MESCHEDULE',  "Schedule line view
      lc_account  TYPE syst-ucomm VALUE 'MEACCOUNT',   "Acct assignment View
      lc_p1_tcode TYPE rvari_vnam  VALUE 'TCODE',      "Name of Variant Variable: Tcode.
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      lc_p1_ircat TYPE rvari_vnam  VALUE 'IRCAT',      "Name of Variant Variable: IR Document Category.
      lc_p1_grcat TYPE rvari_vnam  VALUE 'GRCAT',      "Name of Variant Variable: GR Document Category.
      lc_p1_irtyp TYPE rvari_vnam  VALUE 'IRTYP',      "Name of Variant Variable: IR Document Type.
      lc_p1_grtyp TYPE rvari_vnam  VALUE 'GRTYP'.      "Name of Variant Variable: GR Document Type.
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    DATA:
      lv_var_key_e268   TYPE zvar_key,                 "Variable Key
*      lv_actv_flag_e268 TYPE zactive_flag, "Active / Inactive flag "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      lv_alv_flag       TYPE c,
*      li_constants      TYPE zcat_constants, "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*      lr_tcode_i        TYPE RANGE OF syst-tcode, "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      lir_ircat         TYPE TABLE OF bewtp_ran, "Range Table: IR Document Category
      lir_grcat         TYPE TABLE OF bewtp_ran, "Range Table: GR Document Category
      lir_irtyp         TYPE TABLE OF vgabe_ran, "Range Table: IR Document Type
      lir_grtyp         TYPE TABLE OF vgabe_ran. "Range Table: GR Document Type
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*   Check if enhancement needs to be triggered
  IF v_actv_flag_e268_001 IS INITIAL. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e268              "Constant value for WRICEF (E268)
        im_ser_num     = lc_ser_num_e268                "Serial Number (001)
        im_var_key     = lv_var_key_e268                "Variable Key (Credit Segment)
      IMPORTING
        ex_active_flag = v_actv_flag_e268_001. "lv_actv_flag_e268. "Active / Inactive flag "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
  ENDIF.
  IF v_actv_flag_e268_001 = abap_true. "IF lv_actv_flag_e268 = abap_true. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*Get Constants
    IF i_constants_e268 IS INITIAL. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_wricef_id_e268   "Development ID
      IMPORTING
        ex_constants = i_constants_e268. "li_constants. "Constant Values
    ENDIF.

* fill the respective entries which are maintain in zcaconstant.
  CLEAR: ir_tcode_e268. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_cnst>). "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
  LOOP AT i_constants_e268 ASSIGNING FIELD-SYMBOL(<lst_cnst>). "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    CASE <lst_cnst>-param1.
      WHEN lc_p1_tcode.
*        APPEND INITIAL LINE TO lr_tcode_i ASSIGNING FIELD-SYMBOL(<lst_tcode_i>). "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
        APPEND INITIAL LINE TO ir_tcode_e268 ASSIGNING FIELD-SYMBOL(<lst_tcode_i>). "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
        <lst_tcode_i>-sign   = <lst_cnst>-sign.
        <lst_tcode_i>-option = <lst_cnst>-opti.
        <lst_tcode_i>-low    = <lst_cnst>-low.
        <lst_tcode_i>-high   = <lst_cnst>-high.
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      WHEN lc_p1_ircat.
        APPEND INITIAL LINE TO lir_ircat ASSIGNING FIELD-SYMBOL(<lst_ir_i>).
        <lst_ir_i>-sign   = <lst_cnst>-sign.
        <lst_ir_i>-option = <lst_cnst>-opti.
        <lst_ir_i>-low    = <lst_cnst>-low.
        <lst_ir_i>-high   = <lst_cnst>-high.
      WHEN lc_p1_grcat.
        APPEND INITIAL LINE TO lir_grcat ASSIGNING FIELD-SYMBOL(<lst_gr_i>).
        <lst_gr_i>-sign   = <lst_cnst>-sign.
        <lst_gr_i>-option = <lst_cnst>-opti.
        <lst_gr_i>-low    = <lst_cnst>-low.
        <lst_gr_i>-high   = <lst_cnst>-high.
      WHEN lc_p1_irtyp.
        APPEND INITIAL LINE TO lir_irtyp ASSIGNING FIELD-SYMBOL(<lst_irtyp>).
        <lst_irtyp>-sign   = <lst_cnst>-sign.
        <lst_irtyp>-option = <lst_cnst>-opti.
        <lst_irtyp>-low    = <lst_cnst>-low.
        <lst_irtyp>-high   = <lst_cnst>-high.
      WHEN lc_p1_grtyp.
        APPEND INITIAL LINE TO lir_grtyp ASSIGNING FIELD-SYMBOL(<lst_grtyp>).
        <lst_grtyp>-sign   = <lst_cnst>-sign.
        <lst_grtyp>-option = <lst_cnst>-opti.
        <lst_grtyp>-low    = <lst_cnst>-low.
        <lst_grtyp>-high   = <lst_cnst>-high.
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

*  IF ( sy-tcode IN lr_tcode_i ) AND "For Transactions ME2N ME2M "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
  IF ( sy-tcode IN ir_tcode_e268 ) AND  "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    ( sy-ucomm IS INITIAL OR sy-ucomm EQ lc_schedule OR sy-ucomm EQ lc_account OR sy-ucomm EQ lc_base ). "For Basic/Scledule Line/Account Assig Views
    lv_alv_flag = abap_true.

* define local data objects
    DATA: lt_events1              TYPE slis_t_event,
          lt_event_exit1          TYPE slis_t_event_exit,
          lt_fcat1                TYPE lvc_t_fcat,
          ls_fcat1                TYPE lvc_s_fcat,
          ls_variant1             TYPE disvariant,
          ls_layout1              TYPE lvc_s_layo,
          lo_blade1               TYPE REF TO lcl_datablade_general,
          l_blade1                TYPE REF TO if_datablade_mm,
          l_dataref1              TYPE REF TO data,
          lr_fcat1                TYPE REF TO slis_t_fieldcat_alv,
          ls_exit_caused_by_user1 TYPE slis_exit_by_user,
          l_exit_by_caller1       TYPE mmpur_bool,
          l_repid1                TYPE sy-repid,
          ls_layout_slis1         TYPE slis_layout_alv,      "EhP4 OM
          ls_variant_slis1        TYPE disvariant,           "EhP4 OM
          ls_glay1                TYPE lvc_s_glay,
          i_table_pur_dis         TYPE STANDARD TABLE OF ZSTQTC_MEREP_OUTTAB_PURCHDOC,   "Output table for Basic View
          i_table_sche_dis        TYPE STANDARD TABLE OF ZSTQTC_MEREP_OUTTAB_SCHEDLINES, "Output table for Schedule line View
          i_table_acc_dis         TYPE STANDARD TABLE OF ZSTQTC_MEREP_OUTTAB_ACCOUNTING. "Display table for Acct Assignment view

    FIELD-SYMBOLS: <table1> TYPE STANDARD TABLE,
                   <table_dis> TYPE STANDARD TABLE.

    ex_exit = cl_mmpur_constants=>no.
    CLEAR ex_selection.

    l_repid1 = sy-repid.

* general settings
    lt_events1 = get_lvc_events( ).
    lt_event_exit1 = get_lvc_event_exit( ).
    ls_glay1   = build_glay( ).
    IF im_screen_start_column NE 0 AND
       im_screen_start_line NE 0 AND
       im_screen_end_column NE 0 AND
       im_screen_end_line NE 0.
      my_popup = cl_mmpur_constants=>yes.
    ENDIF.
    my_sel = im_sel.

    DO.

      ls_layout1 = get_layout( im_sel = im_sel ).

      my_model_changed = cl_mmpur_constants=>no.

      IF my_model IS INITIAL. EXIT. ENDIF.

* get data from model
      CALL METHOD my_model->get_data
        EXPORTING
          im_name         = 'DEFAULT'
        IMPORTING
          ex_fieldcatalog = lt_fcat1
          et_fieldcat_new = lr_fcat1 "SR
          ex_table_ref    = l_dataref1.

      IF l_dataref1 IS INITIAL. EXIT. ENDIF.
      ASSIGN l_dataref1->* TO <table1>.

      CLEAR: i_table_pur_dis, i_table_sche_dis, i_table_acc_dis.

      CALL FUNCTION 'ZQTC_GET_TABLE_E268'
        EXPORTING
          im_usr_com       = sy-ucomm
          im_itab          = <table1>
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
          im_ircat_tab     = lir_ircat
          im_grcat_tab     = lir_grcat
          im_irtyp_tab     = lir_irtyp
          im_grtyp_tab     = lir_grtyp
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
       IMPORTING
         EX_BASETAB       = i_table_pur_dis
         EX_SCHETAB       = i_table_sche_dis
         EX_ACCTAB        = i_table_acc_dis.

*Append New fields to field catalog
        CLEAR: ls_fcat1.
        ls_fcat1-fieldname = 'GR_NUMBER'.
        ls_fcat1-ref_field = 'GR_NUMBER'.
        ls_fcat1-coltext   = 'GR Doc Number'. ##NO_TEXT
        ls_fcat1-seltext   = 'GR Doc Number'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        ls_fcat1-hotspot   = abap_true.       "ED2K923663 03-June_2021 by TDIMANTHA
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'GR_DOC_DT'.
        ls_fcat1-ref_field = 'GR_DOC_DT'.
        ls_fcat1-coltext   = 'GR Doc Date'. ##NO_TEXT
        ls_fcat1-seltext   = 'GR Doc Date'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'GR_DOC_QT'.
        ls_fcat1-ref_field = 'GR_DOC_QT'.
        ls_fcat1-coltext   = 'GR Doc Quantity'. ##NO_TEXT
        ls_fcat1-seltext   = 'GR Doc Quantity'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'GR_MVT'.
        ls_fcat1-ref_field = 'GR_MVT'.
        ls_fcat1-coltext   = 'GR Movement Type'.  ##NO_TEXT
        ls_fcat1-seltext   = 'GR Movement Type'.  ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'IR_NUMBER'.
        ls_fcat1-ref_field = 'IR_NUMBER'.
        ls_fcat1-coltext   = 'IR Doc Number'. ##NO_TEXT
        ls_fcat1-seltext   = 'IR Doc Number'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        ls_fcat1-hotspot   = abap_true.       "ED2K923663 03-June_2021 by TDIMANTHA
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'IR_DOC_DT'.
        ls_fcat1-ref_field = 'IR_DOC_DT'.
        ls_fcat1-coltext   = 'IR Doc Date'. ##NO_TEXT
        ls_fcat1-seltext   = 'IR Doc Date'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'IR_DOC_QT'.
        ls_fcat1-ref_field = 'IR_DOC_QT'.
        ls_fcat1-coltext   = 'IR Doc Quantity'. ##NO_TEXT
        ls_fcat1-seltext   = 'IR Doc Quantity'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'IR_LOC_AM'.
        ls_fcat1-ref_field = 'IR_LOC_AM'.
        ls_fcat1-coltext   = 'IR Doc Local Amount'. ##NO_TEXT
        ls_fcat1-seltext   = 'IR Doc Local Amount'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

        CLEAR:ls_fcat1.
        ls_fcat1-fieldname = 'IR_LOC_CR'.
        ls_fcat1-ref_field = 'IR_LOC_CR'.
        ls_fcat1-coltext   = 'IR Doc Currency'. ##NO_TEXT
        ls_fcat1-seltext   = 'IR Doc Currency'. ##NO_TEXT
        ls_fcat1-col_opt   = abap_true.
        APPEND ls_fcat1 TO lt_fcat1.

* get the handle and build the variant
      l_blade1 = my_model->get_current_datablade( ).
      IF l_blade1 IS INITIAL. EXIT. ENDIF.
      ls_variant1-report    = l_blade1->class_id.
      ls_variant1-handle    = l_blade1->get_handle( ).
      ls_variant1-log_group = l_blade1->get_log_group( ).

* header
      IF NOT gt_list_top_of_page IS INITIAL.
        CLEAR ls_glay1-top_p_only.
      ENDIF.

      CASE sy-ucomm.
      WHEN '' OR lc_base.
*BOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
        ASSIGN i_table_pur_dis TO <table_cust>.
** restrict access only to SubContracting Cockpit -> Outsourced Manufacturing
*      IF cl_ops_switch_check=>mm_om1_sfws_sc( ) EQ cl_mmpur_constants=>yes
*         AND l_blade1->get_handle( ) EQ c_handle_subcon.
*
*        MOVE-CORRESPONDING: ls_layout1  TO ls_layout_slis1,
*                            ls_variant1 TO ls_variant_slis1.
**  set selection box field
*        ls_layout_slis1-box_fieldname = 'SEL_FLAG'.
*
*        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*          EXPORTING
*            i_callback_program      = l_repid1
*            i_grid_settings         = ls_glay1
*            is_layout               = ls_layout_slis1
*            it_fieldcat             = lr_fcat1->*
*            i_save                  = 'A'
*            is_variant              = ls_variant_slis1
*            it_events               = lt_events1
*            it_event_exit           = lt_event_exit1
*            i_screen_start_column   = im_screen_start_column
*            i_screen_start_line     = im_screen_start_line
*            i_screen_end_column     = im_screen_end_column
*            i_screen_end_line       = im_screen_end_line
*          IMPORTING
*            e_exit_caused_by_caller = l_exit_by_caller1
*            es_exit_caused_by_user  = ls_exit_caused_by_user1
*          TABLES
*            t_outtab                = <table1>
*          EXCEPTIONS
*            OTHERS                  = 0.
*      ELSE.
*        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
*          EXPORTING
*            i_callback_program      = l_repid1
*            is_layout_lvc           = ls_layout1
*            it_fieldcat_lvc         = lt_fcat1
*            i_save                  = 'A'
*            i_grid_settings         = ls_glay1
*            is_variant              = ls_variant1
*            it_events               = lt_events1
*            it_event_exit           = lt_event_exit1
*            i_screen_start_column   = im_screen_start_column
*            i_screen_start_line     = im_screen_start_line
*            i_screen_end_column     = im_screen_end_column
*            i_screen_end_line       = im_screen_end_line
*          IMPORTING
*            e_exit_caused_by_caller = l_exit_by_caller1
*            es_exit_caused_by_user  = ls_exit_caused_by_user1
*          TABLES
*            t_outtab                = i_table_pur_dis
*          EXCEPTIONS
*            OTHERS                  = 0.
*      ENDIF.
*EOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      WHEN lc_schedule.
*BOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
        ASSIGN i_table_sche_dis TO <table_cust>.
*        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
*          EXPORTING
*            i_callback_program      = l_repid1
*            is_layout_lvc           = ls_layout1
*            it_fieldcat_lvc         = lt_fcat1
*            i_save                  = 'A'
*            i_grid_settings         = ls_glay1
*            is_variant              = ls_variant1
*            it_events               = lt_events1
*            it_event_exit           = lt_event_exit1
*            i_screen_start_column   = im_screen_start_column
*            i_screen_start_line     = im_screen_start_line
*            i_screen_end_column     = im_screen_end_column
*            i_screen_end_line       = im_screen_end_line
*          IMPORTING
*            e_exit_caused_by_caller = l_exit_by_caller1
*            es_exit_caused_by_user  = ls_exit_caused_by_user1
*          TABLES
*            t_outtab                = i_table_sche_dis
*          EXCEPTIONS
*            OTHERS                  = 0.
*EOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      WHEN lc_account.
*BOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
        ASSIGN i_table_acc_dis TO <table_cust>.
*        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
*          EXPORTING
*            i_callback_program      = l_repid1
*            is_layout_lvc           = ls_layout1
*            it_fieldcat_lvc         = lt_fcat1
*            i_save                  = 'A'
*            i_grid_settings         = ls_glay1
*            is_variant              = ls_variant1
*            it_events               = lt_events1
*            it_event_exit           = lt_event_exit1
*            i_screen_start_column   = im_screen_start_column
*            i_screen_start_line     = im_screen_start_line
*            i_screen_end_column     = im_screen_end_column
*            i_screen_end_line       = im_screen_end_line
*          IMPORTING
*            e_exit_caused_by_caller = l_exit_by_caller1
*            es_exit_caused_by_user  = ls_exit_caused_by_user1
*          TABLES
*            t_outtab                = i_table_acc_dis
*          EXCEPTIONS
*            OTHERS                  = 0.
*EOC ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      ENDCASE.
*BOI ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      IF <table_cust> IS ASSIGNED.
        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
          EXPORTING
            i_callback_program      = l_repid1
            is_layout_lvc           = ls_layout1
            it_fieldcat_lvc         = lt_fcat1
            i_save                  = 'A'
            i_grid_settings         = ls_glay1
            is_variant              = ls_variant1
            it_events               = lt_events1
            it_event_exit           = lt_event_exit1
            i_screen_start_column   = im_screen_start_column
            i_screen_start_line     = im_screen_start_line
            i_screen_end_column     = im_screen_end_column
            i_screen_end_line       = im_screen_end_line
          IMPORTING
            e_exit_caused_by_caller = l_exit_by_caller1
            es_exit_caused_by_user  = ls_exit_caused_by_user1
          TABLES
            t_outtab                = <table_cust>
          EXCEPTIONS
            OTHERS                  = 0.
      ENDIF.
*EOI ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      CLEAR: <table1>, i_table_pur_dis, i_table_sche_dis, i_table_acc_dis.

      IF l_exit_by_caller1 is initial.
* in case of changed ALV trigger user decission
        lo_blade1 ?= l_blade1.
        lo_blade1->get_changed( ).
        me->my_model->unregister_events( ).
* whenever the controller decided to terminate the grid we
* assume that a new datablade should be displayed and we restart
* at the beginning. Otherwise we leave the method.
        IF ls_exit_caused_by_user1-back = 'X'.       "F3
          IF sy-binpt NE space OR sy-calld NE space.
            ex_exit = cl_mmpur_constants=>yes.
          ENDIF.
        ELSE.
          ex_exit = cl_mmpur_constants=>yes.
        ENDIF.
        ex_selection = my_selection.
        EXIT.
      ENDIF.
    ENDDO.

 ENDIF.
 ENDIF.
 CHECK lv_alv_flag = abap_false.
ENDENHANCEMENT.
