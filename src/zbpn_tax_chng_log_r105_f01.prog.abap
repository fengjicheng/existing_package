*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_TAX_CTRL_UPD_R238_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.
  TYPES : BEGIN OF lty_bp,           " BP structure
            partner TYPE bu_partner, " BP Number
          END OF lty_bp.
  DATA : lt_bp    TYPE TABLE OF lty_bp, " BP Internal table
         ls_bp    TYPE lty_bp,          " BP Work Area
         ls_final TYPE ty_final.        " Final work area

* Move BP numbers from T_CDPOS to LT_BP
  LOOP  AT t_cdpos ASSIGNING FIELD-SYMBOL(<f_cdpos>).
    ls_bp-partner = <f_cdpos>-objectid.
    APPEND ls_bp TO lt_bp.
    CLEAR ls_bp.
  ENDLOOP.

* Fetch Customer name
  SELECT partner, name_org1
    FROM but000
    INTO TABLE @DATA(lt_but000)
    FOR ALL ENTRIES IN @lt_bp
    WHERE partner EQ @lt_bp-partner.
  IF sy-subrc EQ 0.
    SORT lt_but000 BY partner.
  ENDIF.

* Fetch the address details
  SELECT partner, addrnumber
    FROM but020
    INTO TABLE @DATA(lt_but020)
    FOR ALL ENTRIES IN @lt_bp
    WHERE partner EQ @lt_bp-partner.
  IF sy-subrc EQ 0.
    SORT lt_but020 BY partner addrnumber.
    SELECT addrnumber, city1, post_code1, street, str_suppl1, country
      FROM adrc
      INTO TABLE @DATA(lt_adrc)
      FOR ALL ENTRIES IN @lt_but020
      WHERE addrnumber EQ @lt_but020-addrnumber.
    IF sy-subrc EQ 0.
      SORT lt_adrc BY addrnumber.
    ENDIF.
  ENDIF.

* Fetch the tax details
  SELECT kunnr, aland, tatyp
    FROM knvi
    INTO TABLE @DATA(lt_knvi)
    FOR ALL ENTRIES IN @lt_bp
    WHERE kunnr EQ @lt_bp-partner.
  IF sy-subrc EQ 0.
    SORT lt_knvi BY kunnr aland tatyp.
    " Read Country Names
    SELECT spras, land1, landx
      FROM t005t
      INTO TABLE @DATA(lt_t005t)
      FOR ALL ENTRIES IN @lt_knvi
      WHERE spras EQ @c_e
        AND land1 EQ @lt_knvi-aland.
    IF sy-subrc EQ 0.
      SORT lt_t005t BY land1.
    ENDIF.
    " Read Condition Types text
    SELECT spras, kschl, vtext
      FROM t685t
      INTO TABLE @DATA(lt_t685t)
      FOR ALL ENTRIES IN @lt_knvi
      WHERE spras EQ @c_e
        AND kschl EQ @lt_knvi-tatyp.
    IF sy-subrc EQ 0.
      SORT lt_t685t BY kschl.
    ENDIF.
    " Read Customer Taxes text
    SELECT spras, tatyp, taxkd, vtext
      FROM tskdt
      INTO TABLE @DATA(lt_tskdt)
      FOR ALL ENTRIES IN @lt_knvi
      WHERE spras EQ @c_e
        AND tatyp EQ @lt_knvi-tatyp.
    IF sy-subrc EQ 0.
      SORT lt_tskdt BY tatyp.
    ENDIF.
  ENDIF.

* Sort internal tables
  SORT lt_bp BY partner.

* Prepare final internal table
  LOOP AT t_cdpos ASSIGNING FIELD-SYMBOL(<fs_cdpos>).
    READ TABLE lt_bp ASSIGNING FIELD-SYMBOL(<fs_bp>)                  " Read BP Number
      WITH KEY partner = <fs_cdpos>-objectid BINARY SEARCH.
    IF sy-subrc EQ 0.
      READ TABLE lt_but000 ASSIGNING FIELD-SYMBOL(<fs_but000>)        " Read Customer Name
        WITH KEY partner = <fs_bp>-partner BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_final-bp_id = <fs_but000>-partner.
        ls_final-cust_nam = <fs_but000>-name_org1.
      ENDIF.
      READ TABLE lt_but020 ASSIGNING FIELD-SYMBOL(<fs_but020>)        " Read Address Number
        WITH KEY partner = <fs_bp>-partner BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE lt_adrc ASSIGNING FIELD-SYMBOL(<fs_adrc>)          " Read Address details
          WITH KEY addrnumber = <fs_but020>-addrnumber BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-addr1 = <fs_adrc>-street.
          ls_final-addr2 = <fs_adrc>-str_suppl1.
          ls_final-city = <fs_adrc>-city1.
          ls_final-post_code = <fs_adrc>-post_code1.
          ls_final-country = <fs_adrc>-country.
        ENDIF.
      ENDIF.
      READ TABLE lt_knvi ASSIGNING FIELD-SYMBOL(<fs_knvi>)            " Read Tax details
        WITH KEY kunnr = <fs_bp>-partner
                 aland = <fs_cdpos>-tabkey+13(3)
                 tatyp = <fs_cdpos>-tabkey+16(4) BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE lt_t005t ASSIGNING FIELD-SYMBOL(<fs_t005t>)        " Read Country details
          WITH KEY land1 = <fs_knvi>-aland BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-tx_cntry = <fs_t005t>-land1.
          ls_final-tx_cntry_nam = <fs_t005t>-landx.
        ENDIF.
        READ TABLE lt_t685t ASSIGNING FIELD-SYMBOL(<fs_t685t>)        " Read Tax Category details
          WITH KEY kschl = <fs_knvi>-tatyp BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-tx_cat = <fs_t685t>-kschl.
          ls_final-tx_cat_nam = <fs_t685t>-vtext.
        ENDIF.
        ls_final-old_tx_val = <fs_cdpos>-value_old.
        ls_final-cur_tx_val = <fs_cdpos>-value_new.
        LOOP AT lt_tskdt ASSIGNING FIELD-SYMBOL(<fs_tskdt>)           " Read Tax Classfication Description
          WHERE tatyp = <fs_knvi>-tatyp.
          CASE <fs_tskdt>-taxkd.
            WHEN <fs_cdpos>-value_old.
              ls_final-old_tx_desc = <fs_tskdt>-vtext.
            WHEN <fs_cdpos>-value_new.
              ls_final-cur_tx_desc = <fs_tskdt>-vtext.
          ENDCASE.
        ENDLOOP.
        READ TABLE t_cdhdr ASSIGNING FIELD-SYMBOL(<fs_cdhdr>)         " Read Username, change data and time
          WITH KEY objectclas = <fs_cdpos>-objectclas
                   objectid = <fs_cdpos>-objectid
                   changenr = <fs_cdpos>-changenr BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-username = <fs_cdhdr>-username.
          ls_final-udate    = <fs_cdhdr>-udate.
          ls_final-utime    = <fs_cdhdr>-utime.
        ENDIF.
      ENDIF.
    ENDIF.
    APPEND ls_final TO t_final.
    CLEAR ls_final.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA: lo_msg    TYPE REF TO cx_salv_msg,
        lv_string TYPE string.
  TRY.
      SORT t_final BY bp_id.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = o_alv
        CHANGING
          t_table      = t_final ).
    CATCH cx_salv_msg INTO lo_msg.
      lv_string = lo_msg->get_text( ).
      MESSAGE lv_string TYPE c_i.
  ENDTRY.

  " GUI Status
  o_alv->set_screen_status(
  report = sy-repid
  pfstatus = 'SALV_TABLE_STANDARD'
  set_functions = o_alv->c_functions_all
  ).

  " set output control
  DATA lo_dsp_set TYPE REF TO cl_salv_display_settings.
  lo_dsp_set = o_alv->get_display_settings( ).
  lo_dsp_set->set_striped_pattern( 'X' ).

  " Format Columns
  PERFORM f_set_columns.

  " Dispaly the ALV
  o_alv->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_COLUMNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_columns .
  o_cols = o_alv->get_columns( ).

* set the Column optimization
  o_cols->set_optimize( abap_false ).

* "bp_id"
  PERFORM f_set_headings USING 'BP_ID'
                               'BP ID'(003)
                               'BP ID'(003)
                               'BP ID'(003)
                               '10'.

* "cust_nam"
  PERFORM f_set_headings USING 'CUST_NAM'
                               'Customer Name'(004)
                               'Customer Name'(004)
                               'Cstmr Name'(005)
                               '40'.
* "addr1"
  PERFORM f_set_headings USING 'ADDR1'
                               'Address 1'(006)
                               'Address 1'(006)
                               'Address 1'(006)
                               '60'.

* "addr2"
  PERFORM f_set_headings USING 'ADDR2'
                               'Address 2'(007)
                               'Address 2'(007)
                               'Address 2'(007)
                               '40'.

* "city"
  PERFORM f_set_headings USING 'CITY'
                               'City'(008)
                               'City'(008)
                               'City'(008)
                               '40'.

* "post_code"
  PERFORM f_set_headings USING 'POST_CODE'
                               'Postal Code'(009)
                               'Postal Code'(009)
                               'Post Code'(010)
                               '11'.

* "country"
  PERFORM f_set_headings USING 'COUNTRY'
                               'Country'(011)
                               'Country'(011)
                               'Country'(011)
                               '7'.

* "tx_cntry"
  PERFORM f_set_headings USING 'TX_CNTRY'
                               'Output Tax Country'(017)
                               'Output Tax Country'(017)
                               'Tax Cntry'(018)
                               '9'.

* "tx_cntry_nam"
  PERFORM f_set_headings USING 'TX_CNTRY_NAM'
                               'Tax Country Name'(019)
                               'Tax Country Name'(019)
                               'Tax Name'(020)
                               '16'.

* "tx_cat"
  PERFORM f_set_headings USING 'TX_CAT'
                               'Output Tax Category'(021)
                               'Output Tax Category'(021)
                               'Tax Cat'(022)
                               '19'.

* "tx_cat_nam"
  PERFORM f_set_headings USING 'TX_CAT_NAM'
                               'Output Tax Category Name'(023)
                               'Output Tax Cat Name'(024)
                               'Tx Cat Nam'(025)
                               '24'.

* "old_tx_val"
  PERFORM f_set_headings USING 'OLD_TX_VAL'
                               'Prior Tax Classification Value'(026)
                               'Prior Tax Class Val'(027)
                               'PrTx Cl Vl'(028)
                               '30'.

* "old_tx_desc"
  PERFORM f_set_headings USING 'OLD_TX_DESC'
                               'Prior Tax Classification Description'(029)
                               'Prior Tax Class Desc'(030)
                               'PrTx Cl De'(031)
                               '36'.

* "cur_tx_val"
  PERFORM f_set_headings USING 'CUR_TX_VAL'
                               'Current Tax Classification Value'(032)
                               'Curent Tax Class Val'(033)
                               'CrTx Cl Vl'(034)
                               '32'.

* "cur_tx_desc"
  PERFORM f_set_headings USING 'CUR_TX_DESC'
                               'Current Tax Classification Description'(035)
                               'Curnt Tax Class Desc'(036)
                               'CrTx Cl De'(037)
                               '38'.

* "username"
  PERFORM f_set_headings USING 'USERNAME'
                               'User ID'(038)
                               'User ID'(038)
                               'User ID'(038)
                               '12'.

* "udate"
  PERFORM f_set_headings USING 'UDATE'
                               'Date of Change'(039)
                               'Date of Change'(039)
                               'Chnge Date'(040)
                               '14'.

* "utime"
  PERFORM f_set_headings USING 'UTIME'
                               'Time of Change'(041)
                               'Time of Change'(041)
                               'Chnge Time'(042)
                               '14'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_HEADINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0639   text
*      -->P_0640   text
*      -->P_0641   text
*----------------------------------------------------------------------*
FORM f_set_headings  USING    VALUE(p_0639)
                              VALUE(p_0640)
                              VALUE(p_0641)
                              VALUE(p_0642)
                              VALUE(p_0643).
  DATA: lo_column TYPE REF TO cl_salv_column,
        lo_msg    TYPE REF TO cx_salv_not_found,
        lv_string TYPE string.
  TRY.
      lo_column = o_cols->get_column( p_0639 ).
      lo_column->set_long_text( p_0640 ).
      lo_column->set_medium_text( p_0641 ).
      lo_column->set_short_text( p_0642 ).
      lo_column->set_output_length( p_0643 ).
    CATCH cx_salv_not_found INTO lo_msg.
      lv_string = lo_msg->get_text( ).
      MESSAGE lv_string TYPE c_i.
  ENDTRY.

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
* data declarations for converting internal table to string
  DATA : lv_string      TYPE string,
         lv_data_string TYPE string.
* Constants for email attachment
  CONSTANTS : lc_codepage TYPE abap_encod  VALUE '4103', " Target Code Page in SAP Form  (Default = SAPconnect Setting)
              lc_type     TYPE so_obj_tp   VALUE 'RAW',
              lc_ext      TYPE soodk-objtp VALUE 'xls'.
* data declarations for email attachment
  DATA : lt_binary_content TYPE solix_tab,
         lv_size           TYPE so_obj_len,
         lt_main_text      TYPE bcsy_text,
         ls_line           TYPE soli-line,
         lo_send_request   TYPE REF TO cl_bcs,
         lo_document       TYPE REF TO cl_document_bcs,
         lo_recepient      TYPE REF TO if_recipient_bcs,
         lv_sent_to_all    TYPE os_boolean,
         lo_bcs_exception  TYPE REF TO cx_bcs,
         lv_date           TYPE char10,
         lv_time           TYPE char8.
* Add Column Headings
  CONCATENATE text-003 text-004 text-006 text-007
              text-008 text-009 text-011 text-017
              text-019 text-021 text-023 text-026
              text-029 text-032 text-035 text-038
              text-039 text-041
         INTO lv_data_string
         SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
****** convert internal table to string
  CLEAR : lv_date,
          lv_time.
  LOOP AT t_final ASSIGNING FIELD-SYMBOL(<fs_final>).
    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = <fs_final>-udate
      IMPORTING
        output = lv_date.
    CONCATENATE <fs_final>-utime+0(2) ':'
                <fs_final>-utime+2(2) ':'
                <fs_final>-utime+4(2)
           INTO lv_time.
    CONCATENATE <fs_final>-bp_id        <fs_final>-cust_nam
                <fs_final>-addr1        <fs_final>-addr2
                <fs_final>-city         <fs_final>-post_code
                <fs_final>-country      <fs_final>-tx_cntry
                <fs_final>-tx_cntry_nam <fs_final>-tx_cat
                <fs_final>-tx_cat_nam   <fs_final>-old_tx_val
                <fs_final>-old_tx_desc  <fs_final>-cur_tx_val
                <fs_final>-cur_tx_desc  <fs_final>-username
                lv_date                 lv_time
           INTO lv_string
           SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    CONCATENATE lv_data_string lv_string INTO lv_data_string
    SEPARATED BY cl_abap_char_utilities=>newline.
    CLEAR: lv_string.
  ENDLOOP.

****** convert data to binary
  TRY.
      cl_bcs_convert=>string_to_solix(
      EXPORTING
      iv_string   = lv_data_string " Input data
      iv_codepage = lc_codepage
      iv_add_bom  = c_x            " Add Byte-Order Mark
      IMPORTING
      et_solix    =  lt_binary_content " Output data
      ev_size     =  lv_size           " Size of Document Content
      ).
    CATCH cx_bcs.
      MESSAGE text-043 TYPE c_e. " Error while trasferring document
  ENDTRY.

****** create persistent send_request
  TRY .
      lo_send_request = cl_bcs=>create_persistent( ).
      ls_line = 'Hello Team,'(049).
      APPEND ls_line TO lt_main_text.
      CLEAR ls_line.
      APPEND ls_line TO lt_main_text.
      ls_line = 'Please find attached is the manual change log report in the Business partner Tax control/classification for your reference.'(050).
      APPEND ls_line TO lt_main_text.
      CLEAR ls_line.
      APPEND ls_line TO lt_main_text.
      ls_line = 'Thanks,'(051).
      APPEND ls_line TO lt_main_text.
****** create and set document with attachment
      lo_document = cl_document_bcs=>create_document(
      i_type          = lc_type
      i_subject       = 'Business Partner Tax control change log report'(047)
      i_text          = lt_main_text
      ).

****** add excel as attachment to document
      lo_document->add_attachment(
      EXPORTING
      i_attachment_type     = lc_ext            " Document Class for Attachment
      i_attachment_subject  = 'Business Partner Tax control change log'(048) " Attachment Title
      i_attachment_size     = lv_size           " Size of Document Content
      i_att_content_hex     = lt_binary_content " Content (Binary)
      ).

****** add document to send request
      lo_send_request->set_document( i_document = lo_document ).
      LOOP AT so_email.
        lo_recepient = cl_cam_address_bcs=>create_internet_address( so_email-low ).
        CALL METHOD lo_send_request->add_recipient
          EXPORTING
            i_recipient = lo_recepient " Recipient of Message
            i_express   = c_x.         " Send As Express Message
      ENDLOOP.

      lv_sent_to_all = lo_send_request->send( i_with_error_screen = c_x ).
      COMMIT WORK.
      MESSAGE text-045 TYPE c_i.
    CATCH cx_bcs INTO lo_bcs_exception.
      MESSAGE i865(so) WITH lo_bcs_exception->error_type.
  ENDTRY.
ENDFORM.
