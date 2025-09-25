*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EDU_PUBLISH_LET_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_LETTER_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_ENT_RETCO  text
*----------------------------------------------------------------------*
FORM f_processing_letter_form  CHANGING fp_v_returncode TYPE sysubrc.
*- Clear data
  PERFORM f_get_clear.
*- select print data
  PERFORM f_get_data.
  v_formname = c_form_name.
*  v_ent_screen = 'X'.
* Perform has been used to send mail with an attachment of PDF
  IF v_ent_screen  EQ abap_false.
    PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
*- Perform has been used to print preview
  ELSE.
    PERFORM  f_populate_layout USING v_formname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_FORMNAME  text
*----------------------------------------------------------------------*
FORM f_populate_layout  USING    fp_v_formname.
* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string ##NEEDED,             " String value
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        st_formoutput       TYPE fpformoutput,                " Formoutput
        lv_upd_tsk          TYPE i.
*--------------------------------------------------------------------*

*  lst_sfpoutputparams-nopributt = abap_true.
  lst_sfpoutputparams-noarchive = abap_true.
  IF v_ent_screen     = c_x.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = c_w. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
    lst_sfpoutputparams-preview = abap_false.
  ELSEIF v_ent_screen = abap_false.
    lst_sfpoutputparams-preview = abap_false.
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'

*  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = nast-ldest.
  lst_sfpoutputparams-copies    = nast-anzal.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = nast-tdarmod.
  lst_sfpoutputparams-reqimm    = nast-dimme.
  lst_sfpoutputparams-reqdel    = nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
  lst_sfpdocparams-langu     = nast-spras.

* Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.
  IF v_ent_retco = 0.
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_sfpoutputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.

      v_ent_retco = sy-subrc.

      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = sy-msgid
          msg_nr                 = sy-msgno
          msg_ty                 = sy-msgty
          msg_v1                 = sy-msgv1
          msg_v2                 = sy-msgv2
          msg_v3                 = sy-msgv3
          msg_v4                 = sy-msgv4
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.
      IF sy-subrc NE 0.
*     Nothing to do
      ENDIF. " IF sy-subrc NE 0
*    v_ent_retco = 900.

*    RETURN.
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = fp_v_formname "lc_form_name
            IMPORTING
              e_funcname = lv_funcname.

        CATCH cx_fp_api_usage INTO lr_err_usg ##NO_HANDLER.
          lr_text = lr_err_usg->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_repository INTO lr_err_rep ##NO_HANDLER.
          lr_text = lr_err_rep->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_internal INTO lr_err_int ##NO_HANDLER.
          lr_text = lr_err_int->get_text( ).
          LEAVE LIST-PROCESSING.
      ENDTRY.
* Call function module to generate LOC form
      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000157'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_hdr             = li_hdr_loc
          im_logo            = v_bmp
          im_border          = v_border     " Border
          im_sc_image        = v_sc_image   " Successfully completed image
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.

        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
      ELSE. " ELSE -> IF sy-subrc <> 0

*        PERFORM f_protocol_update. "update sucess log

        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.

          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
        ELSE.
*        PERFORM f_protocol_update. "update log
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDIF.
*- For Archiving
  IF lst_sfpoutputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.

    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = c_pdf "  class
        document                 = st_formoutput-pdf
      TABLES
        arc_i_tab                = lst_sfpdocparams-daratab
      EXCEPTIONS
        error_archiv             = 1
        error_communicationtable = 2
        error_connectiontable    = 3
        error_kernel             = 4
        error_parameter          = 5
        error_format             = 6
        OTHERS                   = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              RAISING system_error.
    ELSE. " ELSE -> IF sy-subrc <> 0
*           Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_v_returncode = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROTOCOL_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_protocol_update .
*  CHECK v_ent_screen = space.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE' ##FM_SUBRC_OK
    EXPORTING
      msg_arbgb              = syst-msgid
      msg_nr                 = syst-msgno
      msg_ty                 = syst-msgty
      msg_v1                 = syst-msgv1
      msg_v2                 = syst-msgv2
      msg_v3                 = syst-msgv3
      msg_v4                 = syst-msgv4
    EXCEPTIONS
      message_type_not_valid = 1
      no_sy_message          = 2
      OTHERS                 = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_clear .
  REFRESH:i_content_hex.
  CLEAR:li_hdr_loc,st_formoutput,v_bmp,
  v_formname,v_send_email,v_output_typ,v_retcode,v_trscript,
  ex_mime_helper.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  DATA: lt_allocvaluesnum  TYPE STANDARD TABLE OF  bapi1003_alloc_values_num,
        lt_allocvalueschar TYPE STANDARD TABLE OF  bapi1003_alloc_values_char,
        lt_allocvaluescurr TYPE STANDARD TABLE OF  bapi1003_alloc_values_curr,
        lt_return_t        TYPE STANDARD TABLE OF  bapiret2,
        lv_objectkey       TYPE bapi1003_key-object,
        lv_objecttable     TYPE bapi1003_key-objecttable,
        lv_classnum        TYPE bapi1003_key-classnum,
        li_st_address      TYPE TABLE OF szadr_printform_table_line,
        lv_address_number  TYPE adrc-addrnumber,
        lv_classtype       TYPE bapi1003_key-classtype,
        lt_lines           TYPE tlinet,
        lv_text            TYPE string,
        lv_vendorno        TYPE  lifnr,
        lv_name            TYPE thead-tdname.            " Name
** Local constant Delclaration
  CONSTANTS : lc_st           TYPE thead-tdid     VALUE 'ST',          " Text ID of text to be read
              lc_object_t     TYPE thead-tdobject VALUE 'TEXT',        " Object of text to be read
              lc_id           TYPE rstxt-tdid VALUE '0001',             " Material Sales Text
              lc_object       TYPE rstxt-tdobject VALUE 'MVKE',       " Material texts, sales
              lc_charact_part TYPE atnam  VALUE 'PARTNER_UNIVERSITY',
              lc_credit_dis   TYPE atnam  VALUE 'CREDITDISPLAY',                "Credit display
              lc_loc_template TYPE atnam  VALUE 'LOC_TEMPLATE',        "LOC_TEMPLATE
              lc_credit_typ   TYPE atnam  VALUE 'CREDIT_TYPE',                  "Credit type
              lc_product_code TYPE atnam  VALUE 'PRODUCT_CODE',        "prd code
              lc_parvw_zx     TYPE parvw  VALUE 'ZX',
              lc_under        TYPE char1 VALUE '_',
              lc_com          TYPE char1  VALUE ',',
              lc_zqtcn_loc    TYPE char20 VALUE 'ZQTCN',
              lc_mara         TYPE bapi1003_key-objecttable VALUE 'MARA',        " Object Table
              lc_classnum     TYPE bapi1003_key-classnum    VALUE 'CHILD_COURSE', "Object Class
              lc_classtyp     TYPE bapi1003_key-classtype   VALUE '001',         "Class Type
              lc_logo_name1   TYPE tdobname   VALUE 'ZJWILEY_AC', " Name
              lc_sc_name      TYPE tdobname   VALUE 'ZJWILEY_SC',   " Successfully completed
              lc_border       TYPE tdobname   VALUE 'ZJWILEY_BORDER', " Border Image
              lc_object1      TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id1          TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_bmon         TYPE tdidgr     VALUE 'BMON',         " BMON
              lc_btype1       TYPE tdbtype    VALUE 'BCOL'.         " Graphic type
  v_output_typ = 'ZLC3'."nast-kschl.
  IF p_vbeln IS NOT INITIAL AND p_item IS NOT INITIAL.
    CONCATENATE p_vbeln p_item INTO nast-objky.
    nast-parvw = p_parvw.
  ENDIF.

  SELECT SINGLE vbeln,vposn,vabndat
           FROM veda
           INTO @DATA(lw_veda)
           WHERE vbeln = @nast-objky+0(10)
             AND vposn = @nast-objky+10(6).
  IF sy-subrc EQ 0.
    IF lw_veda-vabndat IS NOT INITIAL.
      CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
        EXPORTING
          date_internal            = lw_veda-vabndat
        IMPORTING
          date_external            = li_hdr_loc-grade_date
        EXCEPTIONS
          date_internal_is_invalid = 1
          OTHERS                   = 2.
      IF sy-subrc NE 0.
**-  error handling
*      v_ent_retco = sy-subrc.
*      PERFORM f_protocol_update.
      ENDIF.
    ENDIF.
  ENDIF.

***Material Sales text logic
  SELECT SINGLE vbeln,vkorg,vtweg                             " Fetch Sales org Dis channel
          FROM vbak
          INTO @DATA(lw_vbak)
          WHERE vbeln = @nast-objky+0(10).
  IF sy-subrc EQ 0.
    SELECT SINGLE vbeln, posnr, matnr, mvgr3
                          FROM vbap
                          INTO @DATA(lw_vbap)
                          WHERE vbeln = @nast-objky+0(10)
                            AND posnr = @nast-objky+10(6).
    IF sy-subrc EQ 0.
      SELECT SINGLE matnr, vkorg, vtweg
               FROM mvke
               INTO @DATA(lw_mvke)
               WHERE matnr EQ @lw_vbap-matnr
                 AND vkorg EQ @lw_vbak-vkorg
                 AND vtweg EQ @lw_vbak-vtweg.
      IF sy-subrc = 0.
        CONCATENATE lw_mvke-matnr lw_mvke-vkorg lw_mvke-vtweg INTO lv_name.
        PERFORM read_text USING lc_id c_e lv_name lc_object
              CHANGING lt_lines
                       lv_text.
        li_hdr_loc-sales_text = lv_text.  "pop mat sales text
      ENDIF.

** Read Product Code
      lv_objecttable = lc_mara.
      lv_objectkey   = lw_vbap-matnr.
      lv_classnum    = lc_classnum.
      lv_classtype   = lc_classtyp.
*---Get the material classification details
      CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
        EXPORTING
          objectkey       = lv_objectkey
          objecttable     = lv_objecttable
          classnum        = lv_classnum
          classtype       = lv_classtype
        TABLES
          allocvaluesnum  = lt_allocvaluesnum
          allocvalueschar = lt_allocvalueschar
          allocvaluescurr = lt_allocvaluescurr
          return          = lt_return_t.
      IF lt_allocvalueschar IS NOT INITIAL.
        READ TABLE lt_allocvalueschar INTO DATA(lst_allocvalueschar) WITH KEY charact = lc_charact_part.
        IF sy-subrc = 0.
** Read Partner University Number
          li_hdr_loc-univ_id = lst_allocvalueschar-value_char.
        ENDIF.
** Read Credit Display value from the material master characteristics
        READ TABLE lt_allocvalueschar INTO lst_allocvalueschar WITH KEY charact = lc_credit_dis.
        IF sy-subrc = 0.
** Ex data:3 Graduate Credits
          SPLIT lst_allocvalueschar-value_char AT space INTO DATA(lv_value) DATA(lv_val2).
          li_hdr_loc-credit_dis = lv_value.
          CONDENSE li_hdr_loc-credit_dis NO-GAPS.
          li_hdr_loc-good_for = lst_allocvalueschar-value_char.
        ENDIF.
** Read lc_credit_typ graduateCredit or continuingEducation
        READ TABLE lt_allocvalueschar INTO lst_allocvalueschar WITH KEY charact = lc_credit_typ.
        IF sy-subrc = 0.
          li_hdr_loc-credit_type = lst_allocvalueschar-value_char.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*--Logo
***Logic to read Student name and address
**Check the adrnr in item and if not exist check in the header level
  SELECT SINGLE vbeln, posnr, parvw, kunnr, parnr, adrnr                  " Student address number
            FROM vbpa
            INTO @DATA(lw_vbpa_itm)
            WHERE vbeln = @nast-objky+0(10)
              AND posnr = @nast-objky+10(6)
              AND parvw = @nast-parvw.
  IF sy-subrc EQ 0.
    DATA(lw_vbpa) = lw_vbpa_itm.
  ELSE.
    SELECT SINGLE vbeln, posnr, parvw, kunnr, parnr, adrnr                  " Student address number
             FROM vbpa
             INTO @DATA(lw_vbpa_hdr)
             WHERE vbeln = @nast-objky+0(10)
               AND posnr = @space
               AND parvw = @nast-parvw.
    IF sy-subrc EQ 0.
      lw_vbpa = lw_vbpa_hdr.
    ENDIF.
  ENDIF.
  IF lw_vbpa IS NOT INITIAL.
    SELECT SINGLE addrnumber, " Address number
             name1,      " Name 1
             city1,      " City
             post_code1, " City postal code
             street,     " Street
             country,    " Country Key
             region     " Region (State, Province, County)
              FROM adrc
              INTO @DATA(ls_adrc)
              WHERE addrnumber EQ @lw_vbpa-adrnr.
    IF sy-subrc EQ 0.
      li_hdr_loc-st_name = ls_adrc-name1.
      li_hdr_loc-addr1 = ls_adrc-name1.
** Populate Street
      li_hdr_loc-addr2 = ls_adrc-street.
** Logic to read the Region Description
      SELECT SINGLE * FROM t005u
                      INTO @DATA(ls_t005u)
                      WHERE spras = @sy-langu AND
                            land1 = @ls_adrc-country AND
                            bland = @ls_adrc-region.
      IF sy-subrc = 0.
        CONCATENATE ls_t005u-bezei lc_com INTO li_hdr_loc-addr3.
      ENDIF.
** Populate postal code
      CONCATENATE li_hdr_loc-addr3 ls_adrc-city1 ls_adrc-post_code1
                 INTO li_hdr_loc-addr3  SEPARATED BY space.
    ENDIF.
    SELECT addrnumber, persnumber, date_from, consnumber, smtp_addr, valid_to " Fetch Student E-Mail Address
      FROM adr6
      INTO TABLE @DATA(lt_adr6)
      WHERE addrnumber EQ @lw_vbpa-adrnr.
    IF sy-subrc EQ 0.
      SORT lt_adr6 BY valid_to ASCENDING.
      READ TABLE lt_adr6 INTO DATA(lw_adr6) INDEX 1.
      IF sy-subrc EQ 0 AND lw_adr6-smtp_addr IS NOT INITIAL.
        li_hdr_loc-st_email = lw_adr6-smtp_addr.
      ENDIF.
    ENDIF.
  ENDIF.
** Read logo image
  PERFORM f_get_logo USING lc_object1 lc_id1 lc_btype1 lc_logo_name1
               CHANGING v_bmp.
** Read Successfully completed image.
  PERFORM f_get_logo USING lc_object1 lc_id1 lc_bmon lc_sc_name
               CHANGING v_sc_image.
** Read border image
  PERFORM f_get_logo USING lc_object1 lc_id1 lc_btype1 lc_border
               CHANGING v_border.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_HDR_ITM_FOR_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_hdr_itm_for_form .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail  CHANGING p_fp_v_returncode.
  DATA: st_outputparams  TYPE sfpdocparams ##NEEDED,      " Form Processing Output Parameter
        lv_form          TYPE tdsfname,                   " Smart Forms: Form Name
        lv_fm_name       TYPE funcname,                   " Name of Function Module
        lv_upd_tsk       TYPE i,                          " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,            " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams,               " Form Parameters for Form Processing
        lv_person_numb   TYPE prelp-pernr,                " Person Number
        lv_text          TYPE char255.                    " For text message
  IF li_hdr_loc-st_email IS NOT INITIAL.
    IF v_ent_retco = 0 .
      lv_form = c_form_name."tnapr-sform.
      lst_outputparams-getpdf = abap_true.
      lst_outputparams-preview = abap_false.
    ENDIF. " IF fp_v_returncode = 0
*--- Set output parameters
    lst_outputparams-nopributt = abap_true. " no print buttons in the preview
    lst_outputparams-noarchive = abap_true. " no archiving in the preview
    lst_outputparams-nodialog  = abap_true. " suppress printer dialog popup
    lst_outputparams-dest      = nast-ldest.
    lst_outputparams-copies    = nast-anzal.
    lst_outputparams-dataset   = nast-dsnam.
    lst_outputparams-suffix1   = nast-dsuf1.
    lst_outputparams-suffix2   = nast-dsuf2.
    lst_outputparams-cover     = nast-tdocover.
    lst_outputparams-covtitle  = nast-tdcovtitle.
    lst_outputparams-authority = nast-tdautority.
    lst_outputparams-receiver  = nast-tdreceiver.
    lst_outputparams-division  = nast-tddivision.
    lst_outputparams-arcmode   = nast-tdarmod.
    lst_outputparams-reqimm    = nast-dimme.
    lst_outputparams-reqdel    = nast-delet.
    lst_outputparams-senddate  = nast-vsdat.
    lst_outputparams-sendtime  = nast-vsura.
*--- Set language and default language
    st_outputparams-langu    = nast-spras.

* Archiving
    APPEND toa_dara TO  lst_sfpdocparams-daratab.

*--- Open the spool job
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc.
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

*--- Get the name of the generated function module
    IF v_ent_retco  = 0.
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_form
            IMPORTING
              e_funcname = lv_fm_name.

        CATCH cx_fp_api_repository
              cx_fp_api_usage
              cx_fp_api_internal ##NO_HANDLER.
          v_ent_retco = sy-subrc.
          PERFORM f_protocol_update.
      ENDTRY.
    ENDIF.

    IF v_ent_retco = 0.
*--- Call the generated function module

      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_hdr             = li_hdr_loc
          im_logo            = v_bmp
          im_border          = v_border     " Border
          im_sc_image        = v_sc_image   " Successfully completed image
        IMPORTING
          /1bcdwb/formoutput = st_formoutput "lst_sfpdocparams "lst_docparams "st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        v_ent_retco = sy-subrc .
        PERFORM f_protocol_update.
      ELSE.
        v_ent_retco = sy-subrc .
        PERFORM f_protocol_update.  "Update processing log when sucess
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
*--- Close the spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc .
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

    IF lst_outputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.

      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = c_pdf "  class
          document                 = st_formoutput-pdf
        TABLES
          arc_i_tab                = lst_sfpdocparams-daratab
        EXCEPTIONS
          error_archiv             = 1
          error_communicationtable = 2
          error_connectiontable    = 3
          error_kernel             = 4
          error_parameter          = 5
          error_format             = 6
          OTHERS                   = 7.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE c_e NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                RAISING system_error.
      ELSE. " ELSE -> IF sy-subrc <> 0
*           Check if the subroutine is called in update task.
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF fp_v_returncode = 0
  ENDIF.
********Perform is used to call E098 FM  & convert PDF in to Binary
*  IF p_fp_v_returncode = 0.
  IF v_ent_retco = 0.
******CONVERT_PDF_BINARY
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = st_formoutput-pdf
      TABLES
        binary_tab = i_content_hex.
********Perform is used to create mail attachment with a creation of mail body
    v_send_email = li_hdr_loc-st_email.
    IF v_send_email IS NOT INITIAL.
      PERFORM f_mail_attachment
      CHANGING v_ent_retco.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_OUTPUT  text
*      <--P_FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_mail_attachment  CHANGING p_fp_v_returncode ##NEEDED.
*Declaration
  DATA: lr_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines TYPE tline.

* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
        lv_sub            TYPE string,                                   " Mail subject
        lv_name           TYPE thead-tdname,                             " SO10 text variable for body
        lv_img1           TYPE thead-tdname,                             " Flag image
        lv_img2           TYPE thead-tdname,                             " Addition instruction image button
        lv_img3           TYPE thead-tdname,                             " Rate your Exp
        lv_img4           TYPE thead-tdname,                             " Wiley Log
        lv_doc_cat        TYPE char30,
        st_formoutput     TYPE fpformoutput ,                     " Form Output (PDF, PDL)
        lv_e_content      TYPE xstring.
*Local Constant Declaration
  CONSTANTS : lc_tdobjectgr TYPE  tdobjectgr VALUE 'GRAPHICS',
              lc_tdidgr     TYPE  tdidgr  VALUE 'BMAP',
              lc_tdbtype    TYPE  tdbtype VALUE 'BCOL',
              lc_st         TYPE thead-tdid     VALUE 'ST',          " Text ID of text to be read
              lc_object_t   TYPE thead-tdobject VALUE 'TEXT',        " Object of text to be read
              lc_flag_n     TYPE  char30 VALUE 'ZJWILEY_A_256',
              lc_ai         TYPE  char30 VALUE 'ZJWILEY_AI_256',
              lc_re         TYPE  char30 VALUE 'ZJWILEY_RYE_256',
              lc_footer_l   TYPE  char30 VALUE 'ZWILEY_LOGO_AC_256',
              lc_ce_body    TYPE thead-tdname VALUE 'ZQTC_AC_MAIL_BODY_CE_F055',
              lc_gc_body    TYPE thead-tdname VALUE 'ZQTC_AC_MAIL_BODY_GC_F055',
              lc_ce         TYPE char30 VALUE 'CONTINUINGEDUCATION',
              lc_ge         TYPE char30 VALUE 'GRADUATECREDIT',
              lc_s          TYPE  char1  VALUE 'S',
              lc_bmp        TYPE  char5  VALUE '.BMP',
              lc_pdf        TYPE so_obj_tp      VALUE 'PDF'.                   "Document Class for Attachment
* Credit Type (graduateCredit or continuingEducation)
  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service
  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL ##NEEDED, " BCS: Document Exceptions
        lt_lines        TYPE tlinet,
        lv_text         TYPE string,
        lv_app          TYPE string,
        lv_next         TYPE sytabix,
        lv_subject      TYPE so_obj_des.                              " Short description of contents
*--------------------------------------------------------------------*
  TRY .
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.
  CREATE OBJECT ex_mime_helper.
  CLEAR:lv_name.
  lv_subject = 'Advancement Courses - Letter of Completion'(001).
  lv_sub = lv_subject.
** Read Flag image content
  lv_img1 = lc_flag_n.
  PERFORM read_image USING lv_img1.
  CONCATENATE lv_img1 lc_bmp INTO lv_img1.
** Read Additional Instructions image button content
  lv_img2 = lc_ai.
  PERFORM read_image USING lv_img2.
  CONCATENATE lv_img2 lc_bmp INTO lv_img2.
** Read Rate of your Exp image button content
  lv_img3 = lc_re.
  PERFORM read_image USING lv_img3.
  CONCATENATE lv_img3 lc_bmp INTO lv_img3.
** Read Footer image content
  lv_img4 = lc_footer_l.
  PERFORM read_image USING lv_img4.
  CONCATENATE lv_img4 lc_bmp INTO lv_img4.
  TRANSLATE li_hdr_loc-credit_type TO UPPER CASE.
  IF li_hdr_loc-credit_type = lc_ce.
    lv_name = lc_ce_body.
  ELSEIF li_hdr_loc-credit_type = lc_ge.
    lv_name = lc_gc_body.
  ENDIF.
  IF lv_name IS NOT INITIAL.
    PERFORM read_text USING lc_st c_e lv_name lc_object_t
                CHANGING lt_lines
                         lv_text.
    LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
      lv_next = sy-tabix + 1.
      REPLACE ALL OCCURRENCES OF '&IMNAME1&' IN <fs_lines>-tdline
      WITH lv_img1.
      REPLACE ALL OCCURRENCES OF '&IMNAME2&' IN <fs_lines>-tdline
      WITH lv_img2.
      REPLACE ALL OCCURRENCES OF '&IMNAME3&' IN <fs_lines>-tdline
      WITH lv_img3.
      REPLACE ALL OCCURRENCES OF '&IMNAME4&' IN <fs_lines>-tdline
      WITH lv_img4.
      CONCATENATE lv_app <fs_lines>-tdline INTO lv_app SEPARATED BY space.
      READ TABLE lt_lines INTO  DATA(ls_lines) INDEX lv_next.
      IF sy-subrc = 0.
        IF ls_lines-tdformat = '*'.
          lst_message_body-line = lv_app.
          APPEND lst_message_body-line TO li_message_body.
          CLEAR lv_app.
        ENDIF.
      ELSE.
** Logic to append last line
        lst_message_body-line = lv_app.
        APPEND lst_message_body-line TO li_message_body.
        CLEAR lv_app.
      ENDIF."IF sy-subrc = 0.
    ENDLOOP.
  ENDIF."IF lv_name IS NOT INITIAL.
  CALL METHOD ex_mime_helper->set_main_html
    EXPORTING
      content = li_message_body.
*     filename    = lc_htmlfile
*      description = 'WILEY LOGO AC Title'(011).
  TRY .

      lr_document = cl_document_bcs=>create_from_multirelated(
      i_subject           = lv_subject
      i_multirel_service  = ex_mime_helper ).
    CATCH cx_document_bcs ##NO_HANDLER.
    CATCH cx_bcom_mime ##NO_HANDLER.
    CATCH cx_gbt_mime ##NO_HANDLER.

  ENDTRY.
*        Send email with the attachments we are getting from FM
  TRY.
      lr_document->add_attachment(
      EXPORTING
      i_attachment_type = lc_pdf "'PDF'
      i_attachment_subject = lv_subject "'Letter of completion form'
      i_att_content_hex = i_content_hex ).
    CATCH cx_document_bcs INTO lx_document_bcs ##NO_HANDLER.
*Exception handling not required
  ENDTRY.

  TRY.
      CALL METHOD lr_send_request->set_message_subject
        EXPORTING
          ip_subject = lv_sub.
    CATCH cx_send_req_bcs.
  ENDTRY.
* Add attachment
  TRY.
      CALL METHOD lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
*Exception handling not required
  ENDTRY.

  IF v_send_email IS NOT INITIAL.
* Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).
* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
* Create recipient
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_send_email ).
** Set recipient
        lr_send_request->add_recipient(
        EXPORTING
        i_recipient = lr_recipient
        i_express = abap_true ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs. ##NO_HANDLER
    ENDTRY.
* Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
      MESSAGE text-002 TYPE lc_s . "Email sent successfully
    ENDIF. " IF lv_upd_tsk EQ 0

    IF lv_sent_to_all = abap_true.
      MESSAGE text-002 TYPE lc_s . "Email sent successfully
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF v_send_email IS NOT INITIAL



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_IMAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_image USING fp_name TYPE tdobname.
  DATA:    lv_e_content      TYPE xstring.

  CONSTANTS : lc_tdobjectgr TYPE  tdobjectgr VALUE 'GRAPHICS',
              lc_tdidgr     TYPE  tdidgr VALUE 'BMAP',
              lc_tdbtype    TYPE  tdbtype VALUE 'BCOL'.
  CLEAR:lv_e_content.
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object  = lc_tdobjectgr
      p_name    = fp_name
      p_id      = lc_tdidgr
      p_btype   = lc_tdbtype
    RECEIVING
      p_bmp     = lv_e_content
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  IF sy-subrc EQ 0 AND lv_e_content IS NOT INITIAL.
    DATA : lv_obj_len        TYPE so_obj_len,
           lv_graphic_length TYPE tdlength,
           lv_xstr           TYPE xstring,
           lv_offset         TYPE i,
           lv_length         TYPE i,
           lt_solix          TYPE TABLE OF solix,
           lw_solix          TYPE solix,
           lv_diff           TYPE i.
    CONSTANTS : lc_length TYPE i VALUE 255.
    lv_obj_len = xstrlen( lv_e_content ).
    lv_graphic_length = xstrlen( lv_e_content ).
    CLEAR lv_xstr.
    lv_xstr = lv_e_content(lv_obj_len).
    lv_offset = 0.
    lv_length = lc_length.
    CLEAR lw_solix.
    REFRESH lt_solix.
    WHILE lv_offset LT lv_graphic_length.
      lv_diff = lv_graphic_length - lv_offset.
      IF lv_diff GT lv_length.
        lw_solix-line = lv_xstr+lv_offset(lv_length).
      ELSE.
        lw_solix-line = lv_xstr+lv_offset(lv_diff).
      ENDIF.
      APPEND lw_solix TO lt_solix.
      ADD lv_length TO lv_offset.
    ENDWHILE.
    IF lt_solix IS NOT INITIAL.
      DATA:lv_filename   TYPE string , "VALUE 'ZJWILEY_LOGO_F046_AC.BMP',
           lv_content_id TYPE string, "VALUE 'ZJWILEY_LOGO_F046_AC.BMP',
           lv_htmlfile   TYPE mime_text. " VALUE 'ZJWILEY_LOGO_F046_AC.htm'.
      CONCATENATE fp_name '.BMP' INTO lv_filename.
      CALL METHOD ex_mime_helper->add_binary_part
        EXPORTING
          content      = lt_solix
          filename     = lv_filename
          extension    = 'BMP'
*         description  = 'LH/WES AC LOGO'
          content_type = 'image/bmp'(003)
          length       = lv_obj_len
          content_id   = lv_filename. "lc_content_id.
    ENDIF.
  ELSE.
*    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_ID  text
*      -->P_LV_LANGU  text
*      -->P_LV_NAME  text
*      -->P_LC_OBJECT  text
*----------------------------------------------------------------------*
FORM read_text  USING    fp_id TYPE tdid
                         fp_langu TYPE spras        " Language Key
                         fp_name TYPE tdobname      " Name
                         fp_object TYPE tdobject    " Object Name
                 CHANGING fp_lines   TYPE tttext
                         fp_text    TYPE string.
  DATA:  li_lines     TYPE STANDARD TABLE OF tline. "Lines of text read
  CLEAR:fp_text,li_lines.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_id
      language                = fp_langu
      name                    = fp_name
      object                  = fp_object
    TABLES
      lines                   = li_lines
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
    fp_lines[] = li_lines[].
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = fp_text. ##FM_SUBRC_OK
    IF sy-subrc EQ 0.
      CONDENSE fp_text.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
FORM f_get_logo USING fp_object TYPE tdobjectgr
              fp_id TYPE tdidgr
              fp_btype TYPE tdbtype
              fp_name TYPE tdobname
              CHANGING fp_v_xstring TYPE xstring..

** Local constant declaration
*  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO_F046_AC', " Name
*              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
*              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
*              lc_btype     TYPE tdbtype    VALUE 'BCOL'.         " Graphic type

* To Get a BDS Graphic in BMP Format
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = fp_object    " GRAPHICS
      p_name         = fp_name " ZJWILEY_LOGO
      p_id           = fp_id        " BMAP
      p_btype        = fp_btype     " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc NE 0.
    CLEAR fp_v_xstring.
  ENDIF. " IF sy-subrc NE 0.

ENDFORM.
