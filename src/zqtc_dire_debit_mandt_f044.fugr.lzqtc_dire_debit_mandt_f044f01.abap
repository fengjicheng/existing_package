*----------------------------------------------------------------------*
***INCLUDE LZQTC_DIRE_DEBIT_MANDT_F044F01.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-42768
* REFERENCE NO: ED2K925985
* DEVELOPER:    Madavoina Rajkumar MRAJKUMAR)
* DATE:         03/08/2022
* DESCRIPTION: As part of OTCM-42768, Reference values is changed as
*              Mandate Reference
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_ADRC_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_adrc_data USING fp_im_adrnr TYPE adrnr. " Address
*** Select data from ADRC Table

  SELECT addrnumber " Address number
         date_from  " Valid-from date - in current Release only 00010101 possible
         nation     " Version ID for International Addresses
         title      " Form-of-Address Key
         name1      " Name 1
         name2      " Name 2
         name3      " Name 3
         name4      " Name 4
         city1      " City
         post_code1 " City postal code
         street     " Street
*        Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
         country " Country Key
*        End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
    FROM adrc " Addresses (Business Address Services)
    UP TO 1 ROWS
    INTO st_adrc
    WHERE addrnumber = fp_im_adrnr.
  ENDSELECT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DRCT_DBT_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_DRCT_DBT_LOGO  text
*----------------------------------------------------------------------*
FORM f_get_drct_dbt_logo  USING fp_im_langu TYPE spras " Language Key
                          CHANGING fp_v_drct_dbt_logo TYPE xstring.

*******Local constant declaration
  CONSTANTS : lc_logo_name    TYPE tdobname   VALUE 'ZJWILEY_LOGO_F032_EN4', " Name : English
              lc_logo_name_de TYPE tdobname   VALUE 'ZJWILEY_LOGO_F032_DE2', " Name : German
              lc_object       TYPE tdobjectgr VALUE 'GRAPHICS',              " SAPscript Graphics Management: Application object
              lc_id           TYPE tdidgr     VALUE 'BMAP',                  " SAPscript Graphics Management: ID
              lc_btype        TYPE tdbtype    VALUE 'BCOL',                  " Graphic type
              lc_e            TYPE na_spras   VALUE 'E'.                     " Message language

  IF fp_im_langu = lc_e.
******To Get a BDS Graphic in BMP Format (Using a Cache)
    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = lc_object          " GRAPHICS
        p_name         = lc_logo_name       " ZJWILEY_LOGO_F032_EN3
        p_id           = lc_id              " BMAP
        p_btype        = lc_btype           " BCOL
      RECEIVING
        p_bmp          = fp_v_drct_dbt_logo " Image Data
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.

  ELSE. " ELSE -> IF fp_im_langu = lc_e
******To Get a BDS Graphic in BMP Format (Using a Cache)
    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = lc_object          " GRAPHICS
        p_name         = lc_logo_name_de    " ZJWILEY_LOGO_F032_EN3
        p_id           = lc_id              " BMAP
        p_btype        = lc_btype           " BCOL
      RECEIVING
        p_bmp          = fp_v_drct_dbt_logo " Image Data
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
  ENDIF. " IF fp_im_langu = lc_e
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DIRECT_DEBIT_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_DIRECT_DEBIT_LOGO  text
*----------------------------------------------------------------------*
FORM f_get_direct_debit_logo  CHANGING fp_v_direct_debit_logo TYPE xstring.

*******Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJDIRECT_DEBIT_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',            " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',                " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.                " Graphic type

******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object              " GRAPHICS
      p_name         = lc_logo_name           " ZJWILEY_LOGO
      p_id           = lc_id                  " BMAP
      p_btype        = lc_btype               " BMON
    RECEIVING
      p_bmp          = fp_v_direct_debit_logo " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ORIDNUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_ODNUM  text
*----------------------------------------------------------------------*
FORM f_get_oridnum  CHANGING fp_st_odnum TYPE zstqtc_odnum_f044. " Structure for Originators Indentification Number
  CONSTANTS: lc_st     TYPE tdid       VALUE 'ST',                              "Text ID of text to be read
             lc_object TYPE tdobject   VALUE 'TEXT',                            "Object of text to be read
             lc_name   TYPE tdobname  VALUE 'ZQTC_F044_ORIGINATORS_IDNUM_3310'. " Name

  DATA: li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
        lv_text  TYPE string.

  CLEAR : lv_text,
          li_lines.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = v_langu
      name                    = lc_name
      object                  = lc_object
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
*    fp_lines[] = li_lines[].
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF lv_text IS NOT INITIAL.
      CONDENSE lv_text.
    ENDIF. " IF lv_text IS NOT INITIAL
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0

  IF lv_text IS NOT INITIAL.
*** BOC BY SAYANDAS   on 18-JULY-2018
    fp_st_odnum = lv_text.
*   fp_st_odnum-fld1 = lv_text+0(1).
*   fp_st_odnum-fld2 = lv_text+1(1).
*   fp_st_odnum-fld3 = lv_text+2(1).
*   fp_st_odnum-fld4 = lv_text+3(1).
*   fp_st_odnum-fld5 = lv_text+4(1).
*   fp_st_odnum-fld6 = lv_text+5(1).
*** EOC BY SAYANDAS   on 18-JULY-2018
  ENDIF. " IF lv_text IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_IHREZ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_IHREZ  text
*----------------------------------------------------------------------*
FORM f_get_ihrez USING fp_im_ihrez  TYPE ihrez                " Your Reference
                 CHANGING fp_st_ihrez TYPE zstqtc_ihrez_f044. " Your Reference

  IF fp_im_ihrez IS NOT INITIAL.
*** BOC BY SAYANDAS   on 18-JULY-2018
    fp_st_ihrez = fp_im_ihrez.
*   fp_st_ihrez-fld1 = fp_im_ihrez+0(1).
*   fp_st_ihrez-fld2 = fp_im_ihrez+1(1).
*   fp_st_ihrez-fld3 = fp_im_ihrez+2(1).
*   fp_st_ihrez-fld4 = fp_im_ihrez+3(1).
*   fp_st_ihrez-fld5 = fp_im_ihrez+4(1).
*   fp_st_ihrez-fld6 = fp_im_ihrez+5(1).
*   fp_st_ihrez-fld7 = fp_im_ihrez+6(1).
*   fp_st_ihrez-fld8 = fp_im_ihrez+7(1).
*   fp_st_ihrez-fld9 = fp_im_ihrez+8(1).
*   fp_st_ihrez-fld10 = fp_im_ihrez+9(1).
*   fp_st_ihrez-fld11 = fp_im_ihrez+10(1).
*   fp_st_ihrez-fld12 = fp_im_ihrez+11(1).
*** EOC BY SAYANDAS   on 18-JULY-2018
  ENDIF. " IF fp_im_ihrez IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STANDARD_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_standard_text1 .
  CONSTANTS: lc_txtname_part1 TYPE char10 VALUE 'ZQTC_F044_', " Txtname_part1 of type CHAR10
             lc_txtname_part2 TYPE char10 VALUE 'ZQTC_F037_', " Txtname_part1 of type CHAR20
             lc_remit_to      TYPE char10 VALUE 'REMIT_TO_',  " Txtname_part2 of type CHAR6
             lc_account       TYPE char7  VALUE 'ACCOUNT',    " Account of type CHAR7
             lc_srtcode       TYPE char9  VALUE 'SORT_CODE',  " Srtcode of type CHAR9
             lc_bnkname       TYPE char9 VALUE 'BANK_NAME',   " Bnkname of type CHAR9
             lc_pstcode       TYPE char9 VALUE 'POST_CODE',   " Pstcode of type CHAR9
             lc_underscore    TYPE char1  VALUE '_'.          " Underscore of type CHAR1

  DATA: li_lines          TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_account_no_val TYPE string,
        lv_sort_code_val  TYPE string.

*** Populate Account Number Text
  CONCATENATE lc_txtname_part1
              lc_account
              lc_underscore
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
              INTO v_account_text.
  CONDENSE v_account_text NO-GAPS.

  CLEAR: li_lines.
  PERFORM read_text USING v_account_text
                    CHANGING li_lines
                             lv_account_no_val.

  IF lv_account_no_val IS NOT INITIAL.
*** BOC BY SAYANDAS   on 18-JULY-2018
    st_accnum = lv_account_no_val.
*   st_accnum-fld1 = lv_account_no_val+0(1).
*   st_accnum-fld2 = lv_account_no_val+1(1).
*   st_accnum-fld3 = lv_account_no_val+2(1).
*   st_accnum-fld4 = lv_account_no_val+3(1).
*   st_accnum-fld5 = lv_account_no_val+4(1).
*   st_accnum-fld6 = lv_account_no_val+5(1).
*   st_accnum-fld7 = lv_account_no_val+6(1).
*   st_accnum-fld8 = lv_account_no_val+7(1).
*** EOC BY SAYANDAS   on 18-JULY-2018
  ENDIF. " IF lv_account_no_val IS NOT INITIAL

*** Populate Sort Code Text
  CONCATENATE lc_txtname_part1
              lc_srtcode
              lc_underscore
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
              INTO v_srtcode_text.
  CONDENSE v_srtcode_text NO-GAPS.

  CLEAR: li_lines.
  PERFORM read_text USING v_srtcode_text
                    CHANGING li_lines
                             lv_sort_code_val.

  IF lv_sort_code_val IS NOT INITIAL.
*** BOC BY SAYANDAS   on 18-JULY-2018
    st_srtcod = lv_sort_code_val.
*   st_srtcod-fld1 = lv_sort_code_val+0(1).
*   st_srtcod-fld2 = lv_sort_code_val+1(1).
*   st_srtcod-fld3 = lv_sort_code_val+3(1).
*   st_srtcod-fld4 = lv_sort_code_val+4(1).
*   st_srtcod-fld5 = lv_sort_code_val+6(1).
*   st_srtcod-fld6 = lv_sort_code_val+7(1).
*** EOC BY SAYANDAS   on 18-JULY-2018
  ENDIF. " IF lv_sort_code_val IS NOT INITIAL

*** Populate Bank Name Text
  CONCATENATE lc_txtname_part1
              lc_bnkname
              lc_underscore
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
              INTO v_bnkname_text.
  CONDENSE v_bnkname_text NO-GAPS.

*** Populate Remit To Text
  CONCATENATE lc_txtname_part2
              lc_remit_to
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
         INTO v_remitto_text.
  CONDENSE v_remitto_text NO-GAPS.

*** Populate Postal Code
  CONCATENATE lc_txtname_part1
              lc_pstcode
              lc_underscore
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
              INTO v_pstcode_text.
  CONDENSE v_pstcode_text NO-GAPS.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_WILEY_ADDRESS_3310  text
*      <--P_LI_LINES  text
*      <--P_LV_WILEY_ADDRESS_3310  text
*----------------------------------------------------------------------*
FORM read_text  USING    fp_name      TYPE tdobname " Name
                CHANGING fp_lines     TYPE tttext
                         fp_text      TYPE string.

  DATA:  li_lines     TYPE STANDARD TABLE OF tline. "Lines of text read


  CLEAR: fp_text,
         li_lines.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = v_langu
      name                    = fp_name
      object                  = c_object
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
        ev_text_string = fp_text.
    IF fp_text IS NOT INITIAL.
      CONDENSE fp_text.
    ENDIF. " IF fp_text IS NOT INITIAL
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ADDRESS1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_address1 .
  IF st_adrc IS NOT INITIAL.
    CONCATENATE st_adrc-title st_adrc-name1 INTO st_address-accholder SEPARATED BY space.
  ENDIF. " IF st_adrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ADDRESS2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_address2 .
  IF st_adrc IS NOT INITIAL.
    st_address-street = st_adrc-street.
    st_address-kunnr  = v_kunnr.

    CONCATENATE st_adrc-city1 st_adrc-post_code1 INTO st_address-citypo SEPARATED BY space.
  ENDIF. " IF st_adrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STANDARD_TEXT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_standard_text2 .
  CONSTANTS:lc_txtname_part1 TYPE char10 VALUE 'ZQTC_F044_', " Txtname_part1 of type CHAR10
            lc_sftcode       TYPE char10 VALUE 'SWIFT_CODE', " Sftcode of type CHAR10
            lc_underscore    TYPE char1  VALUE '_'.          " Underscore of type CHAR1

*** Populate Swift Code Text
  CONCATENATE lc_txtname_part1
              lc_sftcode
              lc_underscore
              v_vkorg
              lc_underscore
              v_waerk
              lc_underscore
              v_scenario
              INTO v_sftcode_text.
  CONDENSE v_sftcode_text NO-GAPS.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
* Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
FORM f_adobe_print_output USING fp_lr_vkorg_uk  TYPE tt_vkorg
                                fp_lr_vkorg_vch TYPE tt_vkorg.
* End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
*FORM f_adobe_print_output.
* End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_form_name        TYPE fpname.          " Name of Form Object
*       lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
*       lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
*       lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
*       lr_text             TYPE string,
*       lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers

* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* CONSTANTS: lc_form_name_3310 TYPE fpname VALUE 'ZQTC_FRM_DRCT_DEBT_FST_F044', " Name of Form Object
*            lc_form_name_5501 TYPE fpname VALUE 'ZQTC_FRM_DRCT_DEBT_SND_F044', " Name of Form Object
*            lc_3310           TYPE vkorg VALUE '3310',                         " Sales Organization
*            lc_5501           TYPE vkorg VALUE '5501'.                         " Sales Organization
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385

*** Populating Standard Text
* Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* IF v_vkorg IN fp_lr_vkorg_uk.
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
  IF st_dd_mndt-dd_process EQ c_dd_uk.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
* End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
* IF v_vkorg = lc_3310.
* End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829

    st_standard_text-acc_num = st_accnum.
    st_standard_text-sort_code = st_srtcod.
    st_standard_text-bank_name = v_bnkname_text.
    st_standard_text-remit_to = v_remitto_text.
    st_standard_text-post_code = v_pstcode_text.

* Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* ELSEIF v_vkorg IN fp_lr_vkorg_vch.
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
  ELSEIF st_dd_mndt-dd_process EQ c_dd_uk.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
* End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
* ELSEIF v_vkorg = lc_5501.
* End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829

    st_standard_text-bic = v_sftcode_text.

  ENDIF. " IF st_dd_mndt-dd_process EQ c_dd_uk
* Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427

  IF v_ref_text IS NOT INITIAL.
    IF v_langu = 'E'.
      v_reference_text  = 'Membership Number:'.
    ELSEIF v_langu = 'D'.
      v_reference_text  = 'Mitgliedsnummer:'.
    ENDIF.
  ELSE.
    IF v_langu = 'E'.
*{ BOC by MRAJKUMAR OTCM-42768_F044  ED2K925985  03/08/2022
*      v_reference_text  = 'Reference:'.
      v_reference_text  = 'Mandate Reference:'.
*{ EOC by MRAJKUMAR OTCM-42768_F044  ED2K925985  03/08/2022
    ELSEIF v_langu = 'D'.
      v_reference_text  = 'Mandatsreferenz:'.
    ENDIF.
  ENDIF.
  IF v_crd_no IS NOT INITIAL.
    IF v_langu = 'E'.
      CONCATENATE 'Creditor Identification Number:      ' v_crd_no INTO v_crd_no_text SEPARATED BY space.
    ELSEIF v_langu = 'D'.
      CONCATENATE 'Gläubiger-ldentifikationsnummer:     ' v_crd_no INTO v_crd_no_text SEPARATED BY space.
    ENDIF.
  ENDIF.


* End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*** Determining Form Name
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
  lv_form_name = st_dd_mndt-sform.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
**Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* IF v_vkorg IN fp_lr_vkorg_uk.
**End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
**Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
**IF v_vkorg = lc_3310.
**End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
*   lv_form_name = lc_form_name_3310.
**Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* ELSEIF v_vkorg IN fp_lr_vkorg_vch.
**End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
**Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
**ELSEIF v_vkorg = lc_5501.
**End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
*   lv_form_name = lc_form_name_5501.
* ENDIF. " IF v_vkorg IN fp_lr_vkorg_uk
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385

*** Populating sfpoutputparams Structure
  lst_sfpoutputparams-getpdf = abap_true.
*  lst_sfpoutputparams-nodialog = abap_true.
*  lst_sfpoutputparams-preview = abap_false.
**--- Set language and default language
  lst_sfpdocparams-langu     = v_langu.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc = 0.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lv_form_name
      IMPORTING
        e_funcname = lv_funcname.
    IF lv_funcname IS NOT INITIAL.
      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000060'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_langu           = v_langu
          im_standard_text   = st_standard_text
          im_adrc            = st_address
          im_ihrez           = st_ihrez
          im_oidnum          = st_odnum
          im_drct_dbt_logo   = v_drct_dbt_logo
          im_debit_logo      = v_direct_debit_logo
          im_wiley_logo      = v_xstring
          im_reference_text  = v_reference_text
          im_crd_no          = v_crd_no_text
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*           No action
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_funcname IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LR_VKORG_UK  text
*      <--P_LR_VKORG_VCH  text
*----------------------------------------------------------------------*
FORM f_get_constant_data  CHANGING fp_lr_vkorg_uk TYPE tt_vkorg
                                   fp_lr_vkorg_vch TYPE tt_vkorg
*                                  Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
                                   fp_lv_langu_uk  TYPE spras  " Language Key
                                   fp_lv_langu_vch TYPE spras. " Language Key
*                                  End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829

  CONSTANTS: lc_devid       TYPE zdevid     VALUE 'F044',  " Development ID
             lc_param1      TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
             lc_param1_lang TYPE rvari_vnam VALUE 'LANGUAGE', " ABAP: Name of Variant Variable
*            End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
             lc_uk          TYPE rvari_vnam VALUE 'UK',  " ABAP: Name of Variant Variable
             lc_vch         TYPE rvari_vnam VALUE 'VCH', " ABAP: Name of Variant Variable
             lc_crd_no      TYPE rvari_vnam VALUE 'CREDITOR_NO'. " Creditor Number "ERPM-24393

*** Select Data from ZCACONSTANT Table
  SELECT
       devid,           " Development ID
       param1,          " ABAP: Name of Variant Variable
       param2,          " ABAP: Name of Variant Variable
       srno,            " ABAP: Current selection number
       sign,            " ABAP: ID: I/E (include/exclude values)
       opti,            " ABAP: Selection option (EQ/BT/CP/...)
       low,             " Lower Value of Selection Condition
       high             " Upper Value of Selection Condition
       FROM zcaconstant " Wiley Application Constant Table
       INTO TABLE @DATA(li_constant)
       WHERE  devid EQ @lc_devid.
  IF sy-subrc = 0.
    SORT li_constant BY param1 param2.
    LOOP AT li_constant INTO DATA(lst_constant).
      IF lst_constant-param1 = lc_param1 AND lst_constant-param2 = lc_uk.
        APPEND INITIAL LINE TO fp_lr_vkorg_uk ASSIGNING FIELD-SYMBOL(<lst_vkorg_uk>).
        <lst_vkorg_uk>-sign   = lst_constant-sign.
        <lst_vkorg_uk>-option = lst_constant-opti.
        <lst_vkorg_uk>-low    = lst_constant-low.
        <lst_vkorg_uk>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 = lc_param1 AND lst_constant-param2 = lc_uk

      IF lst_constant-param1 = lc_param1 AND lst_constant-param2 = lc_vch.
        APPEND INITIAL LINE TO fp_lr_vkorg_vch ASSIGNING FIELD-SYMBOL(<lst_vkorg_vch>).
        <lst_vkorg_vch>-sign   = lst_constant-sign.
        <lst_vkorg_vch>-option = lst_constant-opti.
        <lst_vkorg_vch>-low    = lst_constant-low.
        <lst_vkorg_vch>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 = lc_param1 AND lst_constant-param2 = lc_vch

*       Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
      IF lst_constant-param1 = lc_param1_lang AND lst_constant-param2 = lc_uk.
        fp_lv_langu_uk    = lst_constant-low.
      ENDIF. " IF lst_constant-param1 = lc_param1_lang AND lst_constant-param2 = lc_uk
      IF lst_constant-param1 = lc_param1_lang AND lst_constant-param2 = lc_vch.
        fp_lv_langu_vch   = lst_constant-low.
      ENDIF. " IF lst_constant-param1 = lc_param1_lang AND lst_constant-param2 = lc_vch
*       End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
*     Begin of ADD:ERPM-24393:SGUDA:10/06/2020
      IF lst_constant-param1 = lc_crd_no.
        v_crd_no   = lst_constant-low.
      ENDIF.
*     End of ADD:ERPM-24393:SGUDA:10/06/2020
    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc = 0

ENDFORM.
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
*&---------------------------------------------------------------------*
*&      Form  F_GET_DD_PROCESS
*&---------------------------------------------------------------------*
*       Identify Direct Debit Process
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_dd_process .

* Direct Debit Mandate Process
  SELECT SINGLE dd_process " Direct Debit Process
                sform      " PDF-Based Forms: Form Name
    FROM zqtc_dd_mndt      " F044: Direct Debit Mandate
    INTO st_dd_mndt
   WHERE vkorg EQ v_vkorg
     AND waers EQ v_waerk
     AND land1 EQ st_adrc-country.
  IF sy-subrc NE 0.
    CLEAR: st_dd_mndt.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
