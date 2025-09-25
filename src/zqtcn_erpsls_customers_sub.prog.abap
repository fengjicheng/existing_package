*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ERPSLS_CUSTOMERS_SUB
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_VALUES_FOR_ZTERM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_values_for_zterm CHANGING fp_zterm.
  CALL FUNCTION 'FI_F4_ZTERM'
    IMPORTING
      e_zterm = fp_zterm.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HIDE_SCREEN_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_hide_screen_fields .

  DATA: lv_incoversion TYPE i.

  IF cl_sd_618_switch_check=>sd_sfws_inco_versions( ) EQ abap_false.
    " Using the original incoterms so inco1 and inco2
    lv_incoversion =  2000.
  ELSE.
    " Using the new incoterms so incov, inco2_l and inco3_l
    lv_incoversion = 2010.
  ENDIF.

  LOOP AT SCREEN.
    IF lv_incoversion = 2000.
      IF     screen-name CS 'sincov2'.
        screen-active = 0. " hide field
      ELSEIF screen-name CS 'sincov22'.
        screen-active = 0. " hide field
      ELSEIF screen-name CS 'sincov23'.
        screen-active = 0. " hide field
      ENDIF.
    ELSE.
      IF     screen-name CS 'sinco1'.
        screen-active = 0. " hide field
      ELSEIF screen-name CS 'sinco2'.
        screen-active = 0. " hide field
      ENDIF.
    ENDIF.

    CASE pwoorg.
      WHEN 'X'.
        IF     screen-name CS 'vkorg'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'svtweg'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sspart'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'svtweg'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'svkbur'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'svkgrp'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sbzirk'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'skonda'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'spltyp'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'svsbed'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'szterm'.
          screen-input = 0. " grey out a field
        ELSEIF     screen-name CS 'sinco1'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sinco2'.
          screen-input = 0. " grey out a field
        ELSEIF     screen-name CS 'sincov'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sincov22'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sincov23'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'saufsdv'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'slifsdv'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'sfaksdv'.
          screen-input = 0. " grey out a field
        ELSEIF screen-name CS 'ploevmv'.
          screen-input = 0. " grey out a field
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_data_selection .

  DATA: ls_tfmc     TYPE tfmc,
        ls_sname    LIKE LINE OF sname,
        ls_scity    LIKE LINE OF scity,
        ls_rg_mcode TYPE srg_char25,
        lt_rg_mcod1 TYPE trg_char25,
        lt_rg_mcod3 TYPE trg_char25.

  "If Customer name is provided, then populate the range tables for Matchcode search term
  IF NOT sname[] IS INITIAL.
    CLEAR ls_tfmc.
    SELECT SINGLE *
           FROM tfmc
           INTO ls_tfmc
           WHERE ktoid EQ 'D'
             AND fldna EQ 'NAME1'.
    IF sy-subrc = 0 AND
       ( ls_tfmc-fldnr = 1 OR
         ls_tfmc-fldnr = 3 ).
      LOOP AT sname[] INTO ls_sname.
        MOVE-CORRESPONDING ls_sname TO ls_rg_mcode.
        TRANSLATE ls_rg_mcode-low TO UPPER CASE.         "#EC TRANSLANG
        TRANSLATE ls_rg_mcode-high TO UPPER CASE.        "#EC TRANSLANG
        IF ls_tfmc-fldnr EQ 1.
          APPEND ls_rg_mcode TO lt_rg_mcod1.
        ENDIF.
        IF ls_tfmc-fldnr EQ 3.
          APPEND ls_rg_mcode TO lt_rg_mcod3.
        ENDIF.
      ENDLOOP.
      CLEAR sname.
      REFRESH sname[].
    ENDIF.
  ENDIF.

  "If Customer city is provided, then populate the range tables for Matchcode search term
  IF NOT scity[] IS INITIAL.
    CLEAR ls_tfmc.
    SELECT SINGLE *
           FROM tfmc
           INTO ls_tfmc
           WHERE ktoid EQ 'D'
             AND fldna EQ 'ORT01'.
    IF sy-subrc = 0 AND
       ( ls_tfmc-fldnr = 1 OR
         ls_tfmc-fldnr = 3 ).
      LOOP AT scity[] INTO ls_scity.
        MOVE-CORRESPONDING ls_scity TO ls_rg_mcode.
        TRANSLATE ls_rg_mcode-low TO UPPER CASE.         "#EC TRANSLANG
        TRANSLATE ls_rg_mcode-high TO UPPER CASE.        "#EC TRANSLANG
        IF ls_tfmc-fldnr EQ 1.
          APPEND ls_rg_mcode TO lt_rg_mcod1.
        ENDIF.
        IF ls_tfmc-fldnr EQ 3.
          APPEND ls_rg_mcode TO lt_rg_mcod3.
        ENDIF.
      ENDLOOP.
      CLEAR scity.
      REFRESH scity[].
    ENDIF.
  ENDIF.

* check authorizations to display customer data
  PERFORM authority_check.

  CALL FUNCTION 'ERPSLS_CUSTOMERS'
    EXPORTING
      it_rg_kunnr     = skunnr[]
      it_rg_name      = sname[]
      it_rg_street    = sstreet[]
      it_rg_street_no = sstrnum[]
      it_rg_pcode     = spcode[]
      it_rg_city      = scity[]
      it_rg_country   = scountry[]
      it_rg_sortl     = ssortl[]
      it_rg_mcod1     = lt_rg_mcod1[]
      it_rg_mcod3     = lt_rg_mcod3[]
      if_woorg        = pwoorg
      it_rg_vkorg     = svkorg[]
      it_rg_vtweg     = svtweg[]
      it_rg_spart     = sspart[]
      it_rg_vkbur     = svkbur[]
      it_rg_vkgrp     = svkgrp[]
      it_rg_aufsdz    = saufsdz[]
      it_rg_aufsdv    = saufsdv[]
      it_rg_lifsdz    = slifsdz[]
      it_rg_lifsdv    = slifsdv[]
      it_rg_faksdz    = sfaksdz[]
      it_rg_faksdv    = sfaksdv[]
      if_loevmz       = ploevmz
      if_loevmv       = ploevmv
      if_nodel        = pnodel
      it_rg_name2     = sname2[]
      it_rg_email     = semail[]
      it_rg_bzirk     = sbzirk[]
      it_rg_kukla     = skukla[]
      it_rg_brsch     = sbrsch[]
      it_rg_konda     = skonda[]
      it_rg_vsbed     = svsbed[]
      it_rg_inco1     = sinco1[]
      it_rg_inco2     = sinco2[]
      it_rg_zterm     = szterm[]
      it_rg_incov     = sincov2[]
      it_rg_inco2_l   = sincov22[]
      it_rg_inco3_l   = sincov23[]
      it_rg_pltyp     = spltyp[]
      it_rg_ktokd     = sktokd[]
    TABLES
      et_customers    = i_customers[].

  PERFORM f_update_customer_details.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM authority_check .

*   Check general application authorization
  AUTHORITY-CHECK OBJECT 'F_KNA1_APP'
    ID 'ACTVT' FIELD '03'
    ID 'APPKZ' FIELD 'V'.
  IF NOT sy-subrc IS INITIAL.
*     No general authorization for address display
    MESSAGE e322(f2) WITH space 'F_KNA1_APP' '03' 'V'.
  ENDIF.
*   Check general display authorization
  AUTHORITY-CHECK OBJECT 'F_KNA1_GEN'
    ID 'ACTVT' FIELD '03'.
  IF NOT sy-subrc IS INITIAL.
*     No general authorization for address display
    MESSAGE e371(f2) WITH 'F_KNA1_GEN' '03'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fill_fieldcatalog .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SDCUSTVIEW'
    CHANGING
      ct_fieldcat      = i_fieldcat.

  PERFORM f_update_field_catalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout .

  st_layout-colwidth_optimize = 'X'.
  st_layout-detail_initial_lines = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REUSE_ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_reuse_alv_list_display .



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY' ##FM_SUBRC_OK
    EXPORTING
      i_callback_program       = v_repid
      i_callback_pf_status_set = v_status
      i_callback_user_command  = v_user_command
      is_layout                = st_layout
      it_fieldcat              = i_fieldcat
      i_save                   = 'A'
    TABLES
      t_outtab                 = i_customers
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_CUSTOMER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_customer_details .

  IF i_customers[] IS NOT INITIAL.
    SELECT partner, xdele FROM but000 INTO TABLE @DATA(li_but000) FOR ALL ENTRIES IN @i_customers WHERE partner = @i_customers-kunnr.
    IF sy-subrc IS INITIAL.
      SORT li_but000 BY partner.
      LOOP AT i_customers ASSIGNING FIELD-SYMBOL(<lst_customers>).
        READ TABLE li_but000 INTO DATA(lst_but000) WITH KEY partner = <lst_customers>-kunnr.
        IF sy-subrc IS INITIAL.
          <lst_customers>-xdele = lst_but000-xdele.
        ENDIF.
        CLEAR: lst_but000.
      ENDLOOP.
    ENDIF.

    IF pxdele EQ abap_true.
      DELETE i_customers WHERE xdele NE abap_true.
    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_field_catalog .

  LOOP AT i_fieldcat ASSIGNING FIELD-SYMBOL(<lst_fieldcat>) .
    IF <lst_fieldcat>-fieldname = 'XDELE'.
      <lst_fieldcat>-seltext_l = 'Archiving Flag'.
      <lst_fieldcat>-seltext_m = 'Archiving Flag'.
      <lst_fieldcat>-seltext_s = 'Arch'.
    ENDIF.
  ENDLOOP.

ENDFORM.
FORM user_command USING r_ucomm     LIKE sy-ucomm
                          rs_selfield TYPE slis_selfield.

  CHECK rs_selfield-tabindex > 0.
  READ TABLE i_customers INTO st_customers INDEX rs_selfield-tabindex.
  SET PARAMETER ID 'KUN' FIELD st_customers-kunnr.
  SET PARAMETER ID 'VKO' FIELD st_customers-vkorg.
  SET PARAMETER ID 'VTW' FIELD st_customers-vtweg.
  SET PARAMETER ID 'SPA' FIELD st_customers-spart.
  CASE r_ucomm.
    WHEN  'DISPLAY'.
      CALL TRANSACTION 'VD03' AND SKIP FIRST SCREEN.     "#EC CI_CALLTA
    WHEN  'CHANGE'.
      CALL TRANSACTION 'VD02' AND SKIP FIRST SCREEN.     "#EC CI_CALLTA
  ENDCASE.

ENDFORM.
FORM set_status USING extab TYPE slis_t_extab.

  DELETE extab WHERE fcode = '&AVE'.
  DELETE extab WHERE fcode = '&OAD'.
  DELETE extab WHERE fcode = '&ERW'.
  SET PF-STATUS 'ZSTATUS_CUSTLIST_1' EXCLUDING extab.

ENDFORM.
