*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCI_SD_INVOICE_PRINT01                       *
* PROGRAM DESCRIPTION : This Program has been copied from standard
* program“SD_INVOICE_PRINT01” to add the functionality of generating PDF
* file in Application server if required conditions are satisfied.
* Creating PDF file in Application server when output type is triggered
* for Invoice / Billing Document (VF01/VF02/VF03)
* Changes has been done inside the below tags :
* Begin of changes : SADE : 18.08.2016 : ED2K902767
* End   of changes : SADE : 18.08.2016 : ED2K902767
* DEVELOPER           : Sambit De                                      *
* CREATION DATE       : 08/18/2016                                     *
* OBJECT ID           : I0249                                           *
* TRANSPORT NUMBER(S) : ED2K902767                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  SD_INVOICE_PRINT01
*&
*&---------------------------------------------------------------------*
*&              Print Program for Billing Documents
*&
*&---------------------------------------------------------------------*

REPORT  zqtci_sd_invoice_print01 MESSAGE-ID vd_pdf.

TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        toa_dara, " SAP ArchiveLink structure of a DARA line
        vbdkr,    "#EC NEEDED sapscript
        komk,     "#EC NEEDED sapscript
        tvko.     "#EC NEEDED sapscript

*--- SD-SEPA
INCLUDE item_topdata. " SD SEPA Datendeklaration BADI_SD_SALES_ITEM
*--- SD-SEPA

TYPE-POOLS: szadr.

TYPES: BEGIN OF vbeln_posnr_s,
         vbeln TYPE vbeln, " Sales and Distribution Document Number
         posnr TYPE posnr, " Item number of the SD document
       END OF vbeln_posnr_s,
       vbeln_posnr_t TYPE TABLE OF vbeln_posnr_s.

DATA: gs_interface        TYPE invoice_s_prt_interface, " Billing Document: Interface Structure for Adobe Print
      gv_screen_display   TYPE char1,                   " Screen_display of type CHAR1
      gv_price_print_mode TYPE char1,                   " Price_print_mode of type CHAR1
      gt_komv             TYPE TABLE OF komv,           " Pricing Communications-Condition Record
      gs_komk             TYPE komk,                    " Communication Header for Pricing
      gt_vbtyp_fix_values TYPE TABLE OF dd07v,          " Generated Table for View
      gv_language         TYPE sylangu,                 " Language Key
      gv_dummy            TYPE char1,                   "#EC NEEDED
      gt_sdaccdpc_doc     TYPE vbeln_posnr_t,
      gt_sdaccdpc         TYPE sdaccdpc_t,
      gv_downpay_refresh  TYPE c,                       " Downpay_refresh of type Character
      BEGIN OF gs_nast.
        INCLUDE STRUCTURE nast. " Message Status
DATA:   email_addr TYPE ad_smtpadr, " E-Mail Address
        END OF gs_nast.

DATA: gv_badi_filter             TYPE char30. " Badi_filter of type CHAR30
DATA: bd_sd_bil                  TYPE REF TO badi_sd_bil_print01. " Sd_bil_print01 class

FIELD-SYMBOLS:
  <gs_vbdkr>      TYPE vbdkr,   " Document Header View for Billing
  <gv_returncode> TYPE sysubrc. " Return Code

CONSTANTS:
  gc_pr_kappl      TYPE char1 VALUE 'V',     " Pr_kappl of type CHAR1
  gc_true          TYPE char1 VALUE 'X',     " True of type CHAR1
  gc_false         TYPE char1 VALUE space,   " False of type CHAR1
  gc_english       TYPE char1 VALUE 'E',     " English of type CHAR1
  gc_pdf           TYPE char1 VALUE '2',     " Pdf of type CHAR1
  gc_equal         TYPE char2 VALUE 'EQ',    " Equal of type CHAR2
  gc_include       TYPE char1 VALUE 'I',     " Include of type CHAR1
  gc_cross_company TYPE char2 VALUE '56',    " Cross_company of type CHAR2
  BEGIN OF gc_nacha,
    printer       TYPE na_nacha VALUE 1,     " Message transmission medium
    fax           TYPE na_nacha VALUE 2,     " Message transmission medium
    external_send TYPE na_nacha VALUE 5,     " Message transmission medium
  END OF gc_nacha,
  BEGIN OF gc_device,
    printer    TYPE output_device VALUE 'P', " Output Device
    fax        TYPE output_device VALUE 'F', " Output Device
    email      TYPE output_device VALUE 'E', " Output Device
    web_dynpro TYPE output_device VALUE 'W', " Output Device
  END OF gc_device.

* >>>>> BUNDLING <<<<< *************************************************
INCLUDE check_bundling_print. " Include CHECK_BUNDLING_PRINT
* >>>>> BUNDLING <<<<< *************************************************

*---------------------------------------------------------------------*
*       FORM ENTRY                                                    *
*---------------------------------------------------------------------*
FORM entry                                "#EC CALLED
  USING cv_returncode        TYPE sysubrc " Return Code
        uv_screen            TYPE char1.  " Screen of type CHAR1

  TRY.
*     Get BAdI handle
      GET BADI bd_sd_bil
        FILTERS
          filter_billing = tnapr-sform.
    CATCH cx_badi_not_implemented.
*     This should not occur due to fallback class but to be save...
      CLEAR bd_sd_bil.
    CATCH cx_badi_multiply_implemented.
*     Several implementations exist for the filter 'form name'.
*     This appears to be very unlikely but to be save...
      CLEAR bd_sd_bil.
  ENDTRY.

* Assign RC
  ASSIGN cv_returncode TO <gv_returncode>.

* Refresh global data
  PERFORM initialize_data.

  gv_screen_display = uv_screen.
  gs_nast           = nast.

* start processing
  PERFORM processing.

ENDFORM. "entry

*&---------------------------------------------------------------------*
*&      Form  processing
*&---------------------------------------------------------------------*
FORM processing.

*--- Retrieve the data
  PERFORM get_data.
  CHECK <gv_returncode> IS INITIAL.

*--- Print, fax, send data
  PERFORM print_data.
  CHECK <gv_returncode> IS INITIAL.

ENDFORM. " processing

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
FORM get_data.

  DATA: ls_comwa TYPE vbco3, " Sales Doc.Access Methods: Key Fields: Document Printing
        lt_vbdpr TYPE tbl_vbdpr.
  DATA: ls_druckprofil TYPE ledruckprofil, "IBGI
        ls_nast        TYPE nast.          "IBGI

  CALL FUNCTION 'RV_PRICE_PRINT_REFRESH'
    TABLES
      tkomv = gt_komv.

  ls_comwa-mandt = sy-mandt.
  ls_comwa-spras = gs_nast-spras.
  ls_comwa-kunde = gs_nast-parnr.
  ls_comwa-parvw = gs_nast-parvw.
  IF gs_nast-objky+10(6) NE space.
    ls_comwa-vbeln = gs_nast-objky+16(10).
  ELSE. " ELSE -> IF gs_nast-objky+10(6) NE space
    ls_comwa-vbeln = gs_nast-objky.
  ENDIF. " IF gs_nast-objky+10(6) NE space

*--- Call the famous print view
  CALL FUNCTION 'RV_BILLING_PRINT_VIEW'
    EXPORTING
      comwa                        = ls_comwa
    IMPORTING
      kopf                         = gs_interface-head_detail-vbdkr
    TABLES
      pos                          = lt_vbdpr
    EXCEPTIONS
      terms_of_payment_not_in_t052 = 1
      error_message                = 2
      OTHERS                       = 3.

  IF sy-subrc = 1.
    sy-msgty = 'I'.
    PERFORM protocol_update.
  ELSEIF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc = 1

*--- Assign a global pointer to the VBDKR
  ASSIGN gs_interface-head_detail-vbdkr TO <gs_vbdkr>.

*--- Set default language
  gv_language = gs_nast-spras.

*--- Set Country for display conversions e.g. WRITE TO
  SET COUNTRY <gs_vbdkr>-land1.

*--- Get the item details
  PERFORM get_item_details   USING lt_vbdpr.
  CHECK <gv_returncode> IS INITIAL.

*--- Get the header details
  PERFORM get_head_details.
  CHECK <gv_returncode> IS INITIAL.

*  ENHANCEMENT-POINT EHP3_GET_DATA_01 SPOTS ES_SD_INVOICE_PRINT01.

*IBGI
  IF gs_interface-head_detail-vbdkr-spe_billing_ind = 'A'.
    MOVE-CORRESPONDING gs_nast TO ls_nast.
    CALL FUNCTION '/SPE/GET_PRINTER_SETTINGS_2'
      EXPORTING
        is_vbdkr                 = <gs_vbdkr>
        it_vbdpr                 = lt_vbdpr
        is_nast                  = ls_nast
      IMPORTING
        es_druckprofil           = ls_druckprofil
      EXCEPTIONS
        no_printer_profile_found = 1
        delivery_not_found       = 2
        no_invoice_items_found   = 3
        OTHERS                   = 4.

    IF sy-subrc <> 0.
      <gv_returncode> = sy-subrc.
      PERFORM protocol_update.
      RETURN.
    ELSE. " ELSE -> IF sy-subrc <> 0
      gs_nast-ldest = ls_druckprofil-padest_new.
      MOVE-CORRESPONDING ls_druckprofil TO gs_nast.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF gs_interface-head_detail-vbdkr-spe_billing_ind = 'A'

ENDFORM. " get_data

*&---------------------------------------------------------------------*
*&      Form  protocol_update
*&---------------------------------------------------------------------*
FORM protocol_update .
  CHECK gv_screen_display = gc_false.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb = sy-msgid
      msg_nr    = sy-msgno
      msg_ty    = sy-msgty
      msg_v1    = sy-msgv1
      msg_v2    = sy-msgv2
      msg_v3    = sy-msgv3
      msg_v4    = sy-msgv4
    EXCEPTIONS
      OTHERS    = 0.
ENDFORM. " protocol_update

*&---------------------------------------------------------------------*
*&      Form  print_data
*&---------------------------------------------------------------------*
FORM print_data.

  DATA: ls_outputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        ls_docparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_form         TYPE tdsfname,        " Smart Forms: Form Name
        lv_fm_name      TYPE rs38l_fnam,      " Name of Function Module
        ls_pdf_file     TYPE fpformoutput,    " Form Output (PDF, PDL)
        lv_device       TYPE output_device,   " Output Device
        lv_failed       TYPE boole_d,         " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        lv_anzal        TYPE nast-anzal.      "Number of outputs (Orig. + Cop.)

* Begin of changes : SADE : 18.08.2016 : ED2K902767
  DATA:
    lv_amount     TYPE char24,    " Amount of type CHAR24
    lv_file_name  TYPE localfile, " Local file for upload/download
    lv_adrnr      TYPE adrnr,     " Address
    lv_deflt_comm TYPE ad_comm.   " Communication Method (Key) (Business Address Services)


  CONSTANTS:
    lc_deflt_comm_let TYPE ad_comm  VALUE 'LET'. " Communication Method (Key) (Business Address Services)
* End   of changes : SADE : 18.08.2016 : ED2K902767


  lv_form = tnapr-sform.
  IF tnapr-formtype NE gc_pdf.
    <gv_returncode> = 1.
    MESSAGE e005 WITH <gs_vbdkr>-vbeln " Document &1: Form &2 is not an Adobe form
                      tnapr-sform
                 INTO gv_dummy.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF tnapr-formtype NE gc_pdf

*--- Set output parameters
  PERFORM get_output_params CHANGING ls_outputparams
                                     ls_docparams
                                     lv_device.
  CHECK <gv_returncode> IS INITIAL.
  IF ls_outputparams-copies EQ 0.
    lv_anzal = 1.
  ELSE. " ELSE -> IF ls_outputparams-copies EQ 0
    lv_anzal = ls_outputparams-copies.
  ENDIF. " IF ls_outputparams-copies EQ 0
  ls_outputparams-copies = 1.

*       Begin of changes : SADE : 18.08.2016 : ED2K902767
  SELECT SINGLE adrnr " Address
    FROM kna1         " General Data in Customer Master
    INTO lv_adrnr
    WHERE kunnr = gs_interface-head_detail-vbdkr-kunre.
  IF sy-subrc EQ 0.

* Fetch details from Addresses (Business Address Services)
    SELECT deflt_comm             "Communication Method (Key) (Business Address Services)
      FROM adrc                   " Addresses (Business Address Services)
      INTO lv_deflt_comm          "Businees address
     UP TO 1 ROWS
     WHERE addrnumber = lv_adrnr. "Address number
    ENDSELECT.
    IF sy-subrc IS INITIAL AND
       lv_deflt_comm EQ lc_deflt_comm_let. "'LET'.
      ls_outputparams-getpdf = abap_true.
    ENDIF. " IF sy-subrc IS INITIAL AND
  ENDIF. " IF sy-subrc EQ 0

*       End   of changes : SADE : 18.08.2016 : ED2K902767


  IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL.
* >>>>> BUNDLING <<<<< *************************************************
* Check for bundling
* Import parameter from memory
    DATA:  bundling TYPE char1. " Data: bundling of type CHAR1
    CLEAR: bundling.
    IMPORT bundling FROM MEMORY ID 'BUNDLING'.
    IF sy-subrc NE 0 OR bundling NE 'X' OR
       nast-nacha NE '1'.
      CLEAR: bundling.
*   Open the spool job
      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = ls_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.
      IF sy-subrc <> 0.
        <gv_returncode> = sy-subrc.
        PERFORM protocol_update.
        RETURN.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc NE 0 OR bundling NE 'X' OR
* >>>>> BUNDLING <<<<< *************************************************
  ELSE. " ELSE -> IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL
*--- Open the spool job
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF sy-subrc <> 0.
      <gv_returncode> = sy-subrc.
      PERFORM protocol_update.
      RETURN.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL

*--- Get the name of the generated function module
  TRY.
      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = lv_form
        IMPORTING
          e_funcname = lv_fm_name.

    CATCH cx_fp_api_repository
          cx_fp_api_usage
          cx_fp_api_internal.
      <gv_returncode> = 99.
      MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
      PERFORM protocol_update.
      RETURN.
  ENDTRY.

  IF bd_sd_bil IS BOUND.
    DO lv_anzal TIMES.
      IF sy-index NE 1 AND gs_interface-head_detail-repeat NE gc_true.
        gs_interface-head_detail-repeat = gc_true.
      ENDIF. " IF sy-index NE 1 AND gs_interface-head_detail-repeat NE gc_true
*   Call BAdI for printing
      CALL BADI bd_sd_bil->print_data
        EXPORTING
          iv_fm_name    = lv_fm_name
          is_interface  = gs_interface
          is_docparams  = ls_docparams
          is_nast       = nast
        IMPORTING
          es_formoutput = ls_pdf_file
        EXCEPTIONS
          error         = 1.
    ENDDO.
  ELSE. " ELSE -> IF bd_sd_bil IS BOUND
*   No BAdI handle: Directly call the function module generated
*   from according PDF form
    DO lv_anzal TIMES.
      IF sy-index NE 1 AND gs_interface-head_detail-repeat NE gc_true.
        gs_interface-head_detail-repeat = gc_true.
      ENDIF. " IF sy-index NE 1 AND gs_interface-head_detail-repeat NE gc_true
      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams  = ls_docparams
          bil_prt_com        = gs_interface
        IMPORTING
          /1bcdwb/formoutput = ls_pdf_file
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
    ENDDO.
  ENDIF. " IF bd_sd_bil IS BOUND

*  Begin of changes : SADE : 18.08.2016 : ED2K902767

  MOVE gs_interface-head_detail-vbdkr-netwr TO lv_amount.
  CONDENSE lv_amount.
  CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
    EXPORTING
      im_customer        = gs_interface-head_detail-vbdkr-kunre
      im_invoice         = gs_interface-head_detail-vbdkr-vbeln
      im_amount          = lv_amount
      im_currency        = gs_interface-head_detail-vbdkr-waers
      im_date            = gs_interface-head_detail-vbdkr-fkdat
      im_fpformoutput    = ls_pdf_file
      im_form_identifier = 'VF'
      im_ccode           = gs_interface-head_detail-tvko-bukrs
    IMPORTING
      ex_file_name       = lv_file_name.

  IF lv_file_name IS NOT INITIAL.

  ENDIF. " IF lv_file_name IS NOT INITIAL
*  End of changes : SADE : 18.08.2016 : ED2K902767


  ls_outputparams-copies = lv_anzal.
  IF NOT sy-subrc IS INITIAL.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                 INTO gv_dummy.
    PERFORM protocol_update.
*   Do not directly return but only after closing the spool job
    lv_failed = abap_true.
  ENDIF. " IF NOT sy-subrc IS INITIAL


  IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL.
* >>>>> BUNDLING <<<<< *************************************************
    IF bundling NE 'X'.
*   Close the spool job
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
        <gv_returncode> = sy-subrc.
        MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                     INTO gv_dummy.
        PERFORM protocol_update.
        RETURN.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF bundling NE 'X'
* >>>>> BUNDLING <<<<< *************************************************
  ELSE. " ELSE -> IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL
*--- Close the spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

    IF sy-subrc <> 0.
      <gv_returncode> = sy-subrc.
      MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
      PERFORM protocol_update.
      RETURN.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF cl_ops_switch_check=>sd_sfws_sc1( ) IS NOT INITIAL


  IF NOT lv_failed IS INITIAL.
*   Now, leave processing if printing did fail
    RETURN.
  ENDIF. " IF NOT lv_failed IS INITIAL

*--- Post processing
  CASE lv_device.
    WHEN gc_device-fax
      OR gc_device-email.
      PERFORM send_data USING lv_device
                              ls_pdf_file.
      IF ls_outputparams-arcmode <> '1'.
        CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
          EXPORTING
            documentclass            = 'PDF' "  class
            document                 = ls_pdf_file-pdf
          TABLES
            arc_i_tab                = ls_docparams-daratab
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
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF ls_outputparams-arcmode <> '1'
    WHEN gc_device-web_dynpro.
      EXPORT lv_pdf_file = ls_pdf_file-pdf TO MEMORY ID 'PDF_FILE'.
  ENDCASE.
  CHECK <gv_returncode> IS INITIAL.

ENDFORM. " print_data
*&---------------------------------------------------------------------*
*&      Form  get_item_details
*&---------------------------------------------------------------------*
FORM get_item_details
  USING ut_vbdpr              TYPE tbl_vbdpr.

  DATA: ls_dd07v       TYPE dd07v,                     " Generated Table for View
        ls_text        TYPE tline,                     " SAPscript: Text Lines
        ls_item_detail TYPE invoice_s_prt_item_detail. " Items Detail for PDF Print

  FIELD-SYMBOLS:
    <ls_vbdpr>       TYPE vbdpr,                     " Document Item View for Billing
    <ls_item_detail> TYPE invoice_s_prt_item_detail. " Items Detail for PDF Print

  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = 'VBTYP'
      text           = gc_true
      langu          = gv_language
    TABLES
      dd07v_tab      = gt_vbtyp_fix_values
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                 INTO gv_dummy.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  LOOP AT ut_vbdpr ASSIGNING <ls_vbdpr>.

    CLEAR ls_item_detail.

*   Clearing items (Verrechnungspositionen) will be printed only in
*   down payment requests
    IF ( <gs_vbdkr>-fktyp EQ 'P'  )
    OR    ( <gs_vbdkr>-fktyp NE 'P'
    AND     <ls_vbdpr>-fareg NA '45' ).

*--- Fill the VBDPR structure
      ls_item_detail-vbdpr = <ls_vbdpr>.

*--- Get the type text of the reference document
      IF NOT ls_item_detail-vbdpr-vbeln_vg2 IS INITIAL.
        READ TABLE gt_vbtyp_fix_values  INTO ls_dd07v
                  WITH KEY domvalue_l = ls_item_detail-vbdpr-vgtyp.

        IF sy-subrc IS INITIAL.
          ls_item_detail-vgtyp_text = ls_dd07v-ddtext.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF NOT ls_item_detail-vbdpr-vbeln_vg2 IS INITIAL

*--- Get the item prices
      PERFORM get_item_prices              CHANGING ls_item_detail.
      IF <gv_returncode> <> 0.
        RETURN.
      ENDIF. " IF <gv_returncode> <> 0

*--- Get configurations
      PERFORM get_item_characteristics     CHANGING ls_item_detail.
      IF <gv_returncode> <> 0.
        RETURN.
      ENDIF. " IF <gv_returncode> <> 0

      IF bd_sd_bil IS BOUND.
*       Call BAdI concerning item details
        CALL BADI bd_sd_bil->get_item_details
          EXPORTING
            is_vbdkr       = <gs_vbdkr>
            is_nast        = nast
            iv_language    = gv_language
          CHANGING
            cs_item_detail = ls_item_detail.
      ENDIF. " IF bd_sd_bil IS BOUND
      APPEND ls_item_detail TO gs_interface-item_detail.

    ELSEIF ( <gs_vbdkr>-fktyp NE 'P'
    AND      <ls_vbdpr>-fareg CA '45' ).
*--- Get downpayment data
      PERFORM get_item_downpayment         USING <ls_vbdpr>.
      IF <gv_returncode> <> 0.
        RETURN.
      ENDIF. " IF <gv_returncode> <> 0
    ENDIF. " IF ( <gs_vbdkr>-fktyp EQ 'P' )

  ENDLOOP. " LOOP AT ut_vbdpr ASSIGNING <ls_vbdpr>

ENDFORM. " get_item_details
*&---------------------------------------------------------------------*
*&      Form  get_item_prices
*&---------------------------------------------------------------------*
FORM get_item_prices
  CHANGING
        cs_item_detail  TYPE invoice_s_prt_item_detail. " Items Detail for PDF Print

  DATA: ls_komp  TYPE komp,  " Communication Item for Pricing
        ls_komvd TYPE komvd, " Price Determination Communication-Cond.Record for Printing
        lv_lines TYPE i.     " Lines of type Integers

  DATA: ro_print     TYPE REF TO cl_tm_invoice, " Invoice TM /ERP Integration
        lv_sim_flag  TYPE boolean,              " Boolean Variable (X=True, -=False, Space=Unknown)
        lt_tax_items TYPE komvd_t,
        ls_tax_items TYPE komvd.                " Price Determination Communication-Cond.Record for Printing

*--- Fill the communication structure
  IF gs_komk-knumv NE <gs_vbdkr>-knumv OR
     gs_komk-knumv IS INITIAL.
    CLEAR gs_komk.
    gs_komk-mandt     = sy-mandt.
    gs_komk-fkart     = <gs_vbdkr>-fkart.
    gs_komk-kalsm     = <gs_vbdkr>-kalsm.
    gs_komk-kappl     = gc_pr_kappl.
    gs_komk-waerk     = <gs_vbdkr>-waerk.
    gs_komk-knumv     = <gs_vbdkr>-knumv.
    gs_komk-knuma     = <gs_vbdkr>-knuma.
    gs_komk-vbtyp     = <gs_vbdkr>-vbtyp.
    gs_komk-land1     = <gs_vbdkr>-land1.
    gs_komk-vkorg     = <gs_vbdkr>-vkorg.
    gs_komk-vtweg     = <gs_vbdkr>-vtweg.
    gs_komk-spart     = <gs_vbdkr>-spart.
    gs_komk-bukrs     = <gs_vbdkr>-bukrs.
    gs_komk-hwaer     = <gs_vbdkr>-waers.
    gs_komk-prsdt     = <gs_vbdkr>-erdat.
    gs_komk-kurst     = <gs_vbdkr>-kurst.
    gs_komk-kurrf     = <gs_vbdkr>-kurrf.
    gs_komk-kurrf_dat = <gs_vbdkr>-kurrf_dat.
  ENDIF. " IF gs_komk-knumv NE <gs_vbdkr>-knumv OR
  ls_komp-kposn     = cs_item_detail-vbdpr-posnr.
  ls_komp-kursk     = cs_item_detail-vbdpr-kursk.
  ls_komp-kursk_dat = cs_item_detail-vbdpr-kursk_dat.
  IF <gs_vbdkr>-vbtyp CA 'HKNOT6'.
    IF cs_item_detail-vbdpr-shkzg CA ' A'.
      ls_komp-shkzg = gc_true.
    ENDIF. " IF cs_item_detail-vbdpr-shkzg CA ' A'
  ELSE. " ELSE -> IF <gs_vbdkr>-vbtyp CA 'HKNOT6'
    IF cs_item_detail-vbdpr-shkzg CA 'BX'.
      ls_komp-shkzg = gc_true.
    ENDIF. " IF cs_item_detail-vbdpr-shkzg CA 'BX'
  ENDIF. " IF <gs_vbdkr>-vbtyp CA 'HKNOT6'
  IF bd_sd_bil IS BOUND.
* BAdI
    CALL BADI bd_sd_bil->prepare_item_prices
      EXPORTING
        is_vbdkr       = <gs_vbdkr>
        iv_language    = gv_language
        is_item_detail = cs_item_detail
        is_nast        = nast
      CHANGING
        cs_komp        = ls_komp
        cs_komk        = gs_komk.
  ENDIF. " IF bd_sd_bil IS BOUND

*--- Get the item prices
* ERP TM Integration
  IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true.
    ro_print = cl_tm_invoice=>get_instance( ).
    lv_sim_flag = ro_print->get_simulation_flag( ).
    IF lv_sim_flag IS INITIAL.
      IF gv_price_print_mode EQ 'A'.
        CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
          EXPORTING
            comm_head_i = gs_komk
            comm_item_i = ls_komp
            language    = gv_language
          IMPORTING
            comm_head_e = gs_komk
            comm_item_e = ls_komp
          TABLES
            tkomv       = gt_komv
            tkomvd      = cs_item_detail-conditions.
      ELSE. " ELSE -> IF gv_price_print_mode EQ 'A'
        CALL FUNCTION 'RV_PRICE_PRINT_ITEM_BUFFER'
          EXPORTING
            comm_head_i = gs_komk
            comm_item_i = ls_komp
            language    = gv_language
          IMPORTING
            comm_head_e = gs_komk
            comm_item_e = ls_komp
          TABLES
            tkomv       = gt_komv
            tkomvd      = cs_item_detail-conditions.
      ENDIF. " IF gv_price_print_mode EQ 'A'
      DELETE cs_item_detail-conditions WHERE kbetr IS INITIAL.
    ELSE. " ELSE -> IF lv_sim_flag IS INITIAL
      lt_tax_items = cl_tm_invoice=>gt_tax_items.
      LOOP AT lt_tax_items INTO ls_tax_items WHERE kposn = cs_item_detail-vbdpr-posnr.
        APPEND ls_tax_items TO cs_item_detail-conditions.
      ENDLOOP. " LOOP AT lt_tax_items INTO ls_tax_items WHERE kposn = cs_item_detail-vbdpr-posnr
      IF NOT cs_item_detail-conditions IS INITIAL.
        cs_item_detail-ex_conditions = gc_true.
      ENDIF. " IF NOT cs_item_detail-conditions IS INITIAL
    ENDIF. " IF lv_sim_flag IS INITIAL
  ELSE. " ELSE -> IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true
    IF gv_price_print_mode EQ 'A'.
      CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
        EXPORTING
          comm_head_i = gs_komk
          comm_item_i = ls_komp
          language    = gv_language
        IMPORTING
          comm_head_e = gs_komk
          comm_item_e = ls_komp
        TABLES
          tkomv       = gt_komv
          tkomvd      = cs_item_detail-conditions.
    ELSE. " ELSE -> IF gv_price_print_mode EQ 'A'
      CALL FUNCTION 'RV_PRICE_PRINT_ITEM_BUFFER'
        EXPORTING
          comm_head_i = gs_komk
          comm_item_i = ls_komp
          language    = gv_language
        IMPORTING
          comm_head_e = gs_komk
          comm_item_e = ls_komp
        TABLES
          tkomv       = gt_komv
          tkomvd      = cs_item_detail-conditions.
    ENDIF. " IF gv_price_print_mode EQ 'A'
  ENDIF. " IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true

  IF NOT cs_item_detail-conditions IS INITIAL.
*   The conditions have always one initial line
    DESCRIBE TABLE cs_item_detail-conditions LINES lv_lines.
    IF lv_lines EQ 1.
      READ TABLE cs_item_detail-conditions INTO ls_komvd
                                           INDEX 1.
      IF NOT ls_komvd IS INITIAL.
        cs_item_detail-ex_conditions = gc_true.
      ENDIF. " IF NOT ls_komvd IS INITIAL
    ELSE. " ELSE -> IF lv_lines EQ 1
      cs_item_detail-ex_conditions = gc_true.
    ENDIF. " IF lv_lines EQ 1
  ENDIF. " IF NOT cs_item_detail-conditions IS INITIAL

*--- Fill the tax code
  CALL FUNCTION 'SD_TAX_CODE_MAINTAIN'
    EXPORTING
      key_knumv           = gs_komk-knumv
      key_kposn           = ls_komp-kposn
      i_application       = ' '
      i_pricing_procedure = gs_komk-kalsm
    TABLES
      xkomv               = gt_komv.

ENDFORM. " get_item_prices
*&---------------------------------------------------------------------*
*&      Form  get_head_details
*&---------------------------------------------------------------------*
FORM get_head_details.

*--- Get Sales Org detail
  PERFORM get_head_tvko.
  CHECK <gv_returncode> IS INITIAL.

*--- Get Campany Code texts in case of cross company
  PERFORM get_head_comp_code_texts.
  CHECK <gv_returncode> IS INITIAL.

*--- Get header prices
  PERFORM get_head_prices.
  CHECK <gv_returncode> IS INITIAL.

*--- Get dynamic texts
  PERFORM get_head_text.
  CHECK <gv_returncode> IS INITIAL.

*--- Get sending country
  PERFORM get_head_sending_country.
  CHECK <gv_returncode> IS INITIAL.

*--- Check repeat printout
  PERFORM get_head_repeat_flag.
  CHECK <gv_returncode> IS INITIAL.

*--- Get Payment_split
  PERFORM get_payment_split.
  CHECK <gv_returncode> IS INITIAL.

*--- Get Downpayment
  PERFORM get_head_downpayment.
  CHECK <gv_returncode> IS INITIAL.

*--- Get Payment Cards
  PERFORM get_head_paymentcards.
  CHECK <gv_returncode> IS INITIAL.

*--- SD SEPA: Get Mandate details
  INCLUDE sd_sepa_faktura_004_pdf. " "
*--- SD SEPA

  IF bd_sd_bil IS BOUND.
* BAdI
    CALL BADI bd_sd_bil->get_head_details
      EXPORTING
        iv_language  = gv_language
        is_nast      = nast
      CHANGING
        cs_interface = gs_interface.
  ENDIF. " IF bd_sd_bil IS BOUND
ENDFORM. " get_head_details
*&---------------------------------------------------------------------*
*&      Form  get_head_repeat_flag
*&---------------------------------------------------------------------*
FORM get_head_repeat_flag.

  DATA: lv_nast TYPE nast. " Message Status

  SELECT SINGLE * INTO lv_nast FROM nast                    " Message Status
                                WHERE kappl = gs_nast-kappl "#EC *
                                AND   objky = gs_nast-objky
                                AND   kschl = gs_nast-kschl
                                AND   spras = gs_nast-spras
                                AND   parnr = gs_nast-parnr
                                AND   parvw = gs_nast-parvw
                                AND   nacha BETWEEN '1' AND '5'
                                AND   vstat = '1'.
  IF sy-subrc IS INITIAL.
    gs_interface-head_detail-repeat = gc_true.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM. " get_head_repeat_flag
*&---------------------------------------------------------------------*
*&      Form  get_head_sending_country
*&---------------------------------------------------------------------*
FORM get_head_sending_country.

  DATA: ls_address    TYPE sdpartner_address. " Structure of Address Data in Address Scr. for Doc. Addresses

  CHECK <gs_vbdkr>-sland IS INITIAL.

  CALL FUNCTION 'SD_ADDRESS_GET'
    EXPORTING
      fif_address_number      = gs_interface-head_detail-tvko-adrnr
      fif_address_type        = '1'
    IMPORTING
      fes_sdpartner_address   = ls_address
    EXCEPTIONS
      address_not_found       = 1
      address_type_not_exists = 2
      no_person_number        = 3
      OTHERS                  = 4.

  IF sy-subrc IS INITIAL.
    <gs_vbdkr>-sland = ls_address-country.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    <gv_returncode> = sy-subrc.
    MESSAGE e004 WITH <gs_vbdkr>-vbeln " Document &1: Error determining sending country
                      gs_interface-head_detail-tvko-vkorg
                 INTO gv_dummy.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM. " get_head_sending_country

*&---------------------------------------------------------------------*
*&      Form  get_head_text
*&---------------------------------------------------------------------*
FORM get_head_text.

  DATA: ls_dd07v       TYPE dd07v. " Generated Table for View

*--- VBDKR-VBTYP
  READ TABLE gt_vbtyp_fix_values  INTO ls_dd07v
             WITH KEY domvalue_l = <gs_vbdkr>-vbtyp
 .

  IF sy-subrc IS INITIAL.
    gs_interface-head_detail-vbtyp_text = ls_dd07v-ddtext.
  ENDIF. " IF sy-subrc IS INITIAL

*--- VBDKR-VGTYP
  IF NOT <gs_vbdkr>-vbeln_vg2 IS INITIAL.
    READ TABLE gt_vbtyp_fix_values  INTO ls_dd07v
        WITH KEY domvalue_l = <gs_vbdkr>-vgtyp.

    IF sy-subrc IS INITIAL.
      gs_interface-head_detail-vgtyp_text = ls_dd07v-ddtext.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF NOT <gs_vbdkr>-vbeln_vg2 IS INITIAL

*--- Header and Footer Text
  IF gs_interface-head_detail-vbdkr-vbtyp CA '56'.
    gs_interface-head_detail-head_tdname   =
              gs_interface-head_detail-t001g-txtko.
    gs_interface-head_detail-head_tdobject = 'TEXT'.
    gs_interface-head_detail-head_tdid     = 'ADRS'.

    gs_interface-head_detail-foot_tdname   =
              gs_interface-head_detail-t001g-txtfu.
    gs_interface-head_detail-foot_tdobject = 'TEXT'.
    gs_interface-head_detail-foot_tdid     = 'ADRS'.
  ELSE. " ELSE -> IF gs_interface-head_detail-vbdkr-vbtyp CA '56'
    gs_interface-head_detail-head_tdname   =
              gs_interface-head_detail-tvko-txnam_kop.
    gs_interface-head_detail-head_tdobject = 'TEXT'.
    gs_interface-head_detail-head_tdid     = 'ADRS'.

    gs_interface-head_detail-foot_tdname   =
              gs_interface-head_detail-tvko-txnam_fus.
    gs_interface-head_detail-foot_tdobject = 'TEXT'.
    gs_interface-head_detail-foot_tdid     = 'ADRS'.
  ENDIF. " IF gs_interface-head_detail-vbdkr-vbtyp CA '56'

ENDFORM. " get_head_text
*&---------------------------------------------------------------------*
*&      Form  get_item_characteristics
*&---------------------------------------------------------------------*
FORM get_item_characteristics
  CHANGING
        cs_item_detail TYPE invoice_s_prt_item_detail. " Items Detail for PDF Print

  DATA: lt_conf TYPE TABLE OF conf_out, " Configuration Output
        ls_conf TYPE conf_out,          " Configuration Output
        lt_cabn TYPE TABLE OF cabn,     " Characteristic
        ls_cabn TYPE cabn.              " Characteristic

  RANGES: lr_cabn FOR ls_cabn-atinn.

* Check appropriate config exists
  CHECK NOT cs_item_detail-vbdpr-cuobj IS INITIAL AND
            cs_item_detail-vbdpr-attyp NE '02'.

  CALL FUNCTION 'VC_I_GET_CONFIGURATION'
    EXPORTING
      instance      = cs_item_detail-vbdpr-cuobj
      language      = gv_language
      print_sales   = gc_true
    TABLES
      configuration = lt_conf
    EXCEPTIONS
      OTHERS        = 4.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    MESSAGE e001 WITH <gs_vbdkr>-vbeln " Document &1: Error determining the configuration data
                 INTO gv_dummy.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  IF NOT lt_conf IS INITIAL.
    LOOP AT lt_conf INTO ls_conf.
      lr_cabn-option = gc_equal.
      lr_cabn-sign   = gc_include.
      lr_cabn-low    = ls_conf-atinn.
      COLLECT lr_cabn.
    ENDLOOP. " LOOP AT lt_conf INTO ls_conf

    CALL FUNCTION 'CLSE_SELECT_CABN'
      TABLES
        in_cabn        = lr_cabn
        t_cabn         = lt_cabn
      EXCEPTIONS
        no_entry_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      <gv_returncode> = sy-subrc.
      MESSAGE e001 WITH <gs_vbdkr>-vbeln " Document &1: Error determining the configuration data
                   INTO gv_dummy.
      PERFORM protocol_update.
      RETURN.
    ENDIF. " IF sy-subrc <> 0

    SORT lt_cabn BY atinn.
    LOOP AT lt_conf INTO ls_conf.
      READ TABLE lt_cabn INTO ls_cabn
                         WITH KEY atinn = ls_conf-atinn
                         BINARY SEARCH.
      IF sy-subrc <> 0 OR
         ( ls_cabn-attab = 'SDCOM' AND ls_cabn-atfel = 'VKOND' )
         OR  ls_cabn-attab = 'VCSD_UPDATE'.
        DELETE lt_conf.
      ENDIF. " IF sy-subrc <> 0 OR
    ENDLOOP. " LOOP AT lt_conf INTO ls_conf

    cs_item_detail-configuration = lt_conf.

    IF NOT cs_item_detail-configuration IS INITIAL.
      cs_item_detail-ex_configuration = gc_true.
    ENDIF. " IF NOT cs_item_detail-configuration IS INITIAL
  ENDIF. " IF NOT lt_conf IS INITIAL

ENDFORM. " get_item_characteristics
*&---------------------------------------------------------------------*
*&      Form  GET_head_PRICES
*&---------------------------------------------------------------------*
FORM get_head_prices.

  DATA: ro_print      TYPE REF TO cl_tm_invoice, " Invoice TM /ERP Integration
        lv_sim_flag   TYPE boolean,              " Boolean Variable (X=True, -=False, Space=Unknown)
        lt_tax_header TYPE komvd_t.

* BAdI
  IF bd_sd_bil IS BOUND.
    CALL BADI bd_sd_bil->prepare_head_prices
      EXPORTING
        is_interface = gs_interface
        iv_language  = gv_language
        is_nast      = nast
      CHANGING
        cs_komk      = gs_komk.
  ENDIF. " IF bd_sd_bil IS BOUND

* ERP TM Integration
  IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true.
    ro_print = cl_tm_invoice=>get_instance( ).
    lv_sim_flag = ro_print->get_simulation_flag( ).
    IF lv_sim_flag IS INITIAL.
      IF gv_price_print_mode EQ 'A'.
        CALL FUNCTION 'RV_PRICE_PRINT_HEAD'
          EXPORTING
            comm_head_i = gs_komk
            language    = gv_language
          IMPORTING
            comm_head_e = gs_komk
          TABLES
            tkomv       = gt_komv
            tkomvd      = gs_interface-head_detail-conditions.
      ELSE. " ELSE -> IF gv_price_print_mode EQ 'A'
        CALL FUNCTION 'RV_PRICE_PRINT_HEAD_BUFFER'
          EXPORTING
            comm_head_i = gs_komk
            language    = gv_language
          IMPORTING
            comm_head_e = gs_komk
          TABLES
            tkomv       = gt_komv
            tkomvd      = gs_interface-head_detail-conditions.
      ENDIF. " IF gv_price_print_mode EQ 'A'
    ELSE. " ELSE -> IF lv_sim_flag IS INITIAL
      lt_tax_header = cl_tm_invoice=>gt_tax_header.
      IF lt_tax_header IS NOT INITIAL.
        gs_interface-head_detail-conditions = lt_tax_header.
      ENDIF. " IF lt_tax_header IS NOT INITIAL
      gs_interface-head_detail-gross_value =  cl_tm_invoice=>gv_total_amount.
    ENDIF. " IF lv_sim_flag IS INITIAL
  ELSE. " ELSE -> IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true
    IF gv_price_print_mode EQ 'A'.
      CALL FUNCTION 'RV_PRICE_PRINT_HEAD'
        EXPORTING
          comm_head_i = gs_komk
          language    = gv_language
        IMPORTING
          comm_head_e = gs_komk
        TABLES
          tkomv       = gt_komv
          tkomvd      = gs_interface-head_detail-conditions.
    ELSE. " ELSE -> IF gv_price_print_mode EQ 'A'
      CALL FUNCTION 'RV_PRICE_PRINT_HEAD_BUFFER'
        EXPORTING
          comm_head_i = gs_komk
          language    = gv_language
        IMPORTING
          comm_head_e = gs_komk
        TABLES
          tkomv       = gt_komv
          tkomvd      = gs_interface-head_detail-conditions.
    ENDIF. " IF gv_price_print_mode EQ 'A'
  ENDIF. " IF cl_ops_switch_check=>aci_sfws_sc_erptms_ii( ) EQ abap_true

* Fill gross value
  gs_interface-head_detail-doc_currency = gs_komk-waerk.
  IF gs_interface-head_detail-gross_value IS INITIAL.
    gs_interface-head_detail-gross_value  = gs_komk-fkwrt.
  ENDIF. " IF gs_interface-head_detail-gross_value IS INITIAL
  IF gs_interface-head_detail-supos IS INITIAL.
    gs_interface-head_detail-supos  = gs_komk-supos.
  ENDIF. " IF gs_interface-head_detail-supos IS INITIAL
  IF NOT gs_interface-head_detail-conditions IS INITIAL.
    gs_interface-head_detail-ex_conditions = gc_true.
  ENDIF. " IF NOT gs_interface-head_detail-conditions IS INITIAL

ENDFORM. " GET_head_PRICES
*&---------------------------------------------------------------------*
*&      Form  get_head_tvko
*&---------------------------------------------------------------------*
FORM get_head_tvko.

  CALL FUNCTION 'TVKO_SINGLE_READ'
    EXPORTING
      vkorg     = <gs_vbdkr>-vkorg
    IMPORTING
      wtvko     = gs_interface-head_detail-tvko
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    MESSAGE e003 WITH <gs_vbdkr>-vbeln " Document &1: Error determining the sales organization &2
                      <gs_vbdkr>-vkorg
                 INTO gv_dummy.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

ENDFORM. " get_tvko
*&---------------------------------------------------------------------*
*&      Form  get_head_comp_code_texts
*&---------------------------------------------------------------------*
FORM get_head_comp_code_texts.

  STATICS ss_t001g        TYPE t001g. " Company Code-Dependent Standard Texts

  CHECK <gs_vbdkr>-vbtyp CA gc_cross_company.

  IF ss_t001g-bukrs NE <gs_vbdkr>-bukrs.
    SELECT SINGLE * FROM t001g INTO ss_t001g
                                 WHERE bukrs EQ <gs_vbdkr>-bukrs
                                 AND   programm EQ sy-repid
                                 AND   txtid EQ 'SD'.
    IF sy-subrc <> 0.
      <gv_returncode> = sy-subrc.
      MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
      PERFORM protocol_update.
      RETURN.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF ss_t001g-bukrs NE <gs_vbdkr>-bukrs

  gs_interface-head_detail-t001g = ss_t001g.

ENDFORM. " get_t001g
*&---------------------------------------------------------------------*
*&      Form  send_data
*&---------------------------------------------------------------------*
FORM send_data
  USING uv_device           TYPE output_device " Output Device
        us_pdf_file         TYPE fpformoutput. " Form Output (PDF, PDL)

  DATA: lv_date(14)       TYPE c,               " Date(14) of type Character
        lv_mail_subject   TYPE so_obj_des,      " Short description of contents
        lt_mail_text      TYPE bcsy_text,
        lv_send_to_all    TYPE os_boolean,      " Boolean
        lt_adsmtp         TYPE TABLE OF adsmtp, " SMTP Addresses Data Transfer Structure (Bus. Addr. Services)
        ls_adsmtp         TYPE adsmtp,          " SMTP Addresses Data Transfer Structure (Bus. Addr. Services)
        lt_adfax          TYPE TABLE OF adfax,  " Transfer Structure for Fax Numbers (Business Addr. Services)
        ls_adfax          TYPE adfax,           " Transfer Structure for Fax Numbers (Business Addr. Services)
        ls_address        TYPE sdprt_addr_s,    " Structure with E-Mail Address Data
        lv_vbeln          TYPE vbeln,           " Sales and Distribution Document Number

*output control badi change

        ls_enh_flag       TYPE char1,                     " Enh_flag of type CHAR1
        ls_email_rcp      TYPE smtp_sd_sls_addr_s,        " Structure for Email address data
        ls_email_sendr    TYPE smtp_sd_sls_addr_s,        " Structure for Email address data
        lo_cl_bcs         TYPE REF TO cl_bcs,             " Business Communication Service
        ls_file_attribs   TYPE file_attributes_s,         " File attributes for attachment
        lo_badi_mapper    TYPE REF TO badi_sd_obj_mapper, " Sd_obj_mapper class
        lt_email_addr     TYPE adr6_tt,
        lo_badi_sls_email TYPE REF TO badi_sd_sls_email.  " Sd_sls_email class

  CHECK gv_screen_display NE gc_true.

*--- Determine the subject text
  lv_mail_subject = gs_nast-tdcovtitle.
  IF lv_mail_subject = space.
    WRITE <gs_vbdkr>-fkdat TO lv_date.
    WRITE <gs_vbdkr>-vbeln TO lv_vbeln NO-ZERO.
* Type, number, date
    CONCATENATE gs_interface-head_detail-vbtyp_text
                lv_vbeln
                lv_date
           INTO lv_mail_subject
           SEPARATED BY space.
  ENDIF. " IF lv_mail_subject = space

  CASE uv_device.

    WHEN gc_device-email.
*o/p contrl badi enhancement
      TRY.

          GET BADI lo_badi_sls_email
            FILTERS
              sd_email_progs = if_sd_email_process_constant=>invoice_print01.

          IF lo_badi_sls_email IS BOUND.

            IF lo_badi_sls_email->imps IS NOT INITIAL.

              ls_enh_flag = abap_true.

            ENDIF. " IF lo_badi_sls_email->imps IS NOT INITIAL
          ENDIF. " IF lo_badi_sls_email IS BOUND
*Catch not implemented exception or multiple implementation
        CATCH cx_badi_not_implemented.
          ls_enh_flag = abap_false.
          CLEAR lo_badi_sls_email.
      ENDTRY.
*end of o/p contrl badi enhancement


*--- Get the e-mail-text
      PERFORM get_mail_body CHANGING lt_mail_text.
      CHECK <gv_returncode> IS INITIAL.

*--- Get the e-mail address of the recipient
      ls_address-recip_email_addr = gs_nast-email_addr.

*--- Get the e-mail address of the sender
*     Try to get the e-mail of the sales org.
*     Otherwise takes the user's e-mail
      CALL FUNCTION 'ADDR_COMM_GET'
        EXPORTING
          address_number    = gs_interface-head_detail-tvko-adrnr
          language          = gv_language
          table_type        = 'ADSMTP'
        TABLES
          comm_table        = lt_adsmtp
        EXCEPTIONS
          parameter_error   = 1
          address_not_exist = 2
          internal_error    = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        <gv_returncode> = sy-subrc.
        PERFORM protocol_update.
        RETURN.
      ENDIF. " IF sy-subrc <> 0

      READ TABLE lt_adsmtp INTO ls_adsmtp
           WITH KEY flgdefault = gc_true.

      IF sy-subrc IS INITIAL.
        ls_address-sender_email_addr = ls_adsmtp-smtp_addr.
      ENDIF. " IF sy-subrc IS INITIAL

    WHEN gc_device-fax.

*--- Get the e-mail address of the recipient
      ls_address-recip_fax_country = gs_nast-tland.
      ls_address-recip_fax_number = gs_nast-telfx(30).

*--- Get the fax address of the sender
*     Try to get the fax address of the sales org.
*     Otherwise takes the user's
      CALL FUNCTION 'ADDR_COMM_GET'
        EXPORTING
          address_number    = gs_interface-head_detail-tvko-adrnr
          language          = gv_language
          table_type        = 'ADFAX'
        TABLES
          comm_table        = lt_adfax
        EXCEPTIONS
          parameter_error   = 1
          address_not_exist = 2
          internal_error    = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        <gv_returncode> = sy-subrc.
        PERFORM protocol_update.
        RETURN.
      ENDIF. " IF sy-subrc <> 0

      READ TABLE lt_adfax INTO ls_adfax
           WITH KEY flgdefault = gc_true.

      IF sy-subrc IS INITIAL.
        ls_address-sender_fax_country = ls_adfax-country.
        ls_address-sender_fax_number  = ls_adfax-fax_number.
      ENDIF. " IF sy-subrc IS INITIAL

  ENDCASE.

*   o/p control badi call

  IF ls_enh_flag EQ abap_true.

    IF lo_badi_sls_email IS BOUND.

      TRY.

*   get Badi handle for obj mapper
*   filters  any filters implement here
          GET BADI lo_badi_mapper
            FILTERS
              sd_process_filter = if_sd_email_process_constant=>invoice_print01.

*  Catch not implemented exception or multiple implementation
        CATCH cx_badi_not_implemented.
          CLEAR lo_badi_mapper.
      ENDTRY.

      IF lo_badi_mapper IS BOUND.

        IF lo_badi_mapper->imps IS NOT INITIAL.

          CALL BADI lo_badi_mapper->set_sd_inv_to_generic
            EXPORTING
              is_inv_details = gs_interface.

*    Call BAdI for modify email details
          CALL BADI lo_badi_sls_email->set_mapper
            EXPORTING
              io_mapper = lo_badi_mapper->imp.

          IF sy-subrc <> 0.
            RETURN.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lo_badi_mapper->imps IS NOT INITIAL
      ENDIF. " IF lo_badi_mapper IS BOUND
*  move default rcp address to badi impl
      ls_email_rcp-email_addr = ls_address-recip_email_addr.

      CALL BADI lo_badi_sls_email->modify_email
        EXPORTING
          iv_language      = gv_language
          is_email_rcp     = ls_email_rcp
          is_email_sendr   = ls_email_sendr
        CHANGING
          io_cl_bcs        = lo_cl_bcs
        EXCEPTIONS
          exc_send_req_bcs = 1
          exc_address_bcs  = 2
          OTHERS           = 3.

      IF sy-subrc <> 0.
        MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
        PERFORM protocol_update.
        <gv_returncode> = 99.
        RETURN.
      ENDIF. " IF sy-subrc <> 0


*   add Exceptions for process document method and check response.
      ls_file_attribs-pdf_file = us_pdf_file.
      CALL BADI lo_badi_sls_email->process_document
        EXPORTING
          iv_language      = gv_language
          iv_text          = lt_mail_text
          iv_subject       = lv_mail_subject
          is_file_attribs  = ls_file_attribs
        CHANGING
          io_cl_bcs        = lo_cl_bcs
        EXCEPTIONS
          exc_send_req_bcs = 1
          exc_document_bcs = 2
          OTHERS           = 3.

      IF sy-subrc <> 0.
        MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
        PERFORM protocol_update.
        <gv_returncode> = 99.
        RETURN.

      ENDIF. " IF sy-subrc <> 0

*   Send Document
      CALL BADI lo_badi_sls_email->send_document
        EXPORTING
          io_cl_bcs        = lo_cl_bcs
        CHANGING
          ev_send_to_all   = lv_send_to_all
        EXCEPTIONS
          exc_send_req_bcs = 1
          OTHERS           = 2.

      IF sy-subrc <> 0.
        MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                      INTO gv_dummy.
        PERFORM protocol_update.
        <gv_returncode> = 99.
        RETURN.
      ENDIF. " IF sy-subrc <> 0

      IF lv_send_to_all = gc_true.
*     Write success message into log
        MESSAGE i022(so) " Document sent
                INTO gv_dummy.
        PERFORM protocol_update.
      ELSE. " ELSE -> IF lv_send_to_all = gc_true
*     Write fail message into log
        MESSAGE i023(so) " Document <&> could not be sent
                WITH <gs_vbdkr>-vbeln
                INTO gv_dummy.
        PERFORM protocol_update.
      ENDIF. " IF lv_send_to_all = gc_true
    ENDIF. " IF lo_badi_sls_email IS BOUND

*  end of o/p contrl badi call. continue old way in else.
  ELSE. " ELSE -> IF ls_enh_flag EQ abap_true

    CALL FUNCTION 'SD_PDF_SEND_DATA'
      EXPORTING
        iv_device        = uv_device
        iv_email_subject = lv_mail_subject
        it_email_text    = lt_mail_text
        is_main_data     = us_pdf_file
        iv_language      = gv_language
        is_address       = ls_address
      IMPORTING
        ev_send_to_all   = lv_send_to_all
      EXCEPTIONS
        exc_document     = 1
        exc_send_request = 2
        exc_address      = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE e000 WITH <gs_vbdkr>-vbeln " Document &1: Serious error during message processing
                   INTO gv_dummy.
      PERFORM protocol_update.
      <gv_returncode> = 99.
      RETURN.
    ENDIF. " IF sy-subrc <> 0

    IF lv_send_to_all = gc_true.
      MESSAGE i022(so) INTO gv_dummy. " Document sent
      PERFORM protocol_update.
    ELSE. " ELSE -> IF lv_send_to_all = gc_true
      MESSAGE i023(so) WITH <gs_vbdkr>-vbeln " Document <&> could not be sent
              INTO gv_dummy.
      PERFORM protocol_update.
    ENDIF. " IF lv_send_to_all = gc_true
  ENDIF. " IF ls_enh_flag EQ abap_true
ENDFORM. " send_data
*&---------------------------------------------------------------------*
*&      Form  get_output_params
*&---------------------------------------------------------------------*
FORM get_output_params
   CHANGING
        cs_outputparams  TYPE sfpoutputparams " Form Processing Output Parameter
        cs_docparams     TYPE sfpdocparams    " Form Parameters for Form Processing
        cv_device        TYPE output_device.  " Output Device

  DATA: lv_comm_type   TYPE ad_comm,
        ls_comm_values TYPE szadr_comm_values.

  CASE gs_nast-nacha.
    WHEN gc_nacha-external_send.

      IF NOT gs_nast-tcode IS INITIAL.
        CALL FUNCTION 'ADDR_GET_NEXT_COMM_TYPE'
          EXPORTING
            strategy           = gs_nast-tcode
            address_type       = <gs_vbdkr>-address_type
            address_number     = <gs_vbdkr>-adrnr
            person_number      = <gs_vbdkr>-adrnp
          IMPORTING
            comm_type          = lv_comm_type
            comm_values        = ls_comm_values
          EXCEPTIONS
            address_not_exist  = 1
            person_not_exist   = 2
            no_comm_type_found = 3
            internal_error     = 4
            parameter_error    = 5
            OTHERS             = 6.

        IF sy-subrc <> 0.
          <gv_returncode> = sy-subrc.
          PERFORM protocol_update.
          RETURN.
        ENDIF. " IF sy-subrc <> 0

        CASE lv_comm_type.
          WHEN 'INT'. "e-mail
            cs_outputparams-getpdf = gc_true.
            cv_device              = gc_device-email.
            gs_nast-email_addr     = ls_comm_values-adsmtp-smtp_addr.
          WHEN 'FAX'.
            cs_outputparams-getpdf = gc_true.
            cv_device              = gc_device-fax.
            gs_nast-telfx          = ls_comm_values-adfax-fax_number.
            gs_nast-tland          = ls_comm_values-adfax-country.
          WHEN 'LET'. "Printer
            cv_device              = gc_device-printer.
        ENDCASE.
      ELSE. " ELSE -> IF NOT gs_nast-tcode IS INITIAL
        cv_device              = gc_device-printer.
      ENDIF. " IF NOT gs_nast-tcode IS INITIAL

    WHEN gc_nacha-printer.
      cv_device              = gc_device-printer.
    WHEN gc_nacha-fax.
      cs_outputparams-getpdf = gc_true.
      cv_device              = gc_device-fax.
  ENDCASE.

* The original document should be printed only once
  IF NOT gv_screen_display IS INITIAL
  AND gs_interface-head_detail-repeat EQ gc_false.
    cs_outputparams-noprint   = gc_true.
    cs_outputparams-nopributt = gc_true.
    cs_outputparams-noarchive = gc_true.
  ENDIF. " IF NOT gv_screen_display IS INITIAL
  IF gv_screen_display     = 'X'.
    cs_outputparams-getpdf  = gc_false.
    cs_outputparams-preview = gc_true.
  ELSEIF gv_screen_display = 'W'. "Web dynpro
    cs_outputparams-getpdf  = gc_true.
    cv_device               = gc_device-web_dynpro.
  ENDIF. " IF gv_screen_display = 'X'
  cs_outputparams-nodialog  = gc_true.
  cs_outputparams-dest      = gs_nast-ldest.
  cs_outputparams-copies    = gs_nast-anzal.
  cs_outputparams-dataset   = gs_nast-dsnam.
  cs_outputparams-suffix1   = gs_nast-dsuf1.
  cs_outputparams-suffix2   = gs_nast-dsuf2.
  cs_outputparams-cover     = gs_nast-tdocover.
  cs_outputparams-covtitle  = gs_nast-tdcovtitle.
  cs_outputparams-authority = gs_nast-tdautority.
  cs_outputparams-receiver  = gs_nast-tdreceiver.
  cs_outputparams-division  = gs_nast-tddivision.
  cs_outputparams-arcmode   = gs_nast-tdarmod.
  cs_outputparams-reqimm    = gs_nast-dimme.
  cs_outputparams-reqdel    = gs_nast-delet.
  cs_outputparams-senddate  = gs_nast-vsdat.
  cs_outputparams-sendtime  = gs_nast-vsura.

*--- Set language and default language
  cs_docparams-langu     = gv_language.
  cs_docparams-replangu1 = <gs_vbdkr>-spras_vko.
  cs_docparams-replangu2 = gc_english.
  cs_docparams-country   = <gs_vbdkr>-land1.

* Archiving
  APPEND toa_dara TO cs_docparams-daratab.

ENDFORM. " get_output_params
*&---------------------------------------------------------------------*
*&      Form  get_mail_body
*&---------------------------------------------------------------------*
FORM get_mail_body
  CHANGING
        ct_mail_text    TYPE bcsy_text.

  DATA: ls_options TYPE itcpo,          " SAPscript output interface
        lt_lines   TYPE TABLE OF tline, " SAPscript: Text Lines
        lt_otfdata TYPE TABLE OF itcoo. " OTF Structure

  CHECK NOT tnapr-fonam IS INITIAL.

  ls_options-tdgetotf = gc_true.
  ls_options-tddest   = gs_nast-ldest.
  ls_options-tdprogram = tnapr-pgnam.

  vbdkr = <gs_vbdkr>.
  komk  = gs_komk.
  tvko  = gs_interface-head_detail-tvko.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      dialog                      = ' '
      form                        = tnapr-fonam
      language                    = gv_language
      options                     = ls_options
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'MAIL_BODY'
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3 "  of type
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  CALL FUNCTION 'CLOSE_FORM'
    TABLES
      otfdata                  = lt_otfdata
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      OTHERS                   = 6.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  CALL FUNCTION 'CONVERT_OTF'
    TABLES
      otf                   = lt_otfdata
      lines                 = lt_lines
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      err_bad_otf           = 4
      OTHERS                = 5.

  IF sy-subrc <> 0.
    <gv_returncode> = sy-subrc.
    PERFORM protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

  CALL FUNCTION 'CONVERT_ITF_TO_STREAM_TEXT'
    EXPORTING
      language    = gv_language
    TABLES
      itf_text    = lt_lines
      text_stream = ct_mail_text.

ENDFORM. " get_mail_body
*&---------------------------------------------------------------------*
*&      Form  get_item_downpayment
*&---------------------------------------------------------------------*
FORM get_item_downpayment
  USING us_vbdpr        TYPE vbdpr. " Document Item View for Billing

  DATA: lv_xfilkd       TYPE xfilkd_vf, " Branch/head office relationship
        ls_sdaccdpc_doc TYPE vbeln_posnr_s.

  CHECK <gs_vbdkr>-fktyp NE 'P'.
  CHECK us_vbdpr-fareg CA '45'.

* Can there be a head office?
  CASE <gs_vbdkr>-xfilkd.
*   Ordering party
    WHEN 'A'.
      IF <gs_vbdkr>-knkli IS INITIAL OR
         <gs_vbdkr>-knkli EQ <gs_vbdkr>-kunag.
        lv_xfilkd = <gs_vbdkr>-xfilkd.
      ENDIF. " IF <gs_vbdkr>-knkli IS INITIAL OR
*   Payer
    WHEN 'B'.
      lv_xfilkd = <gs_vbdkr>-xfilkd.
  ENDCASE.

* Remember the headno and itemno
  IF NOT us_vbdpr-vbelv IS INITIAL.
    ls_sdaccdpc_doc-vbeln = us_vbdpr-vbelv.
    ls_sdaccdpc_doc-posnr = us_vbdpr-posnv.
  ELSE. " ELSE -> IF NOT us_vbdpr-vbelv IS INITIAL
    ls_sdaccdpc_doc-vbeln = us_vbdpr-vbeln_vauf.
    ls_sdaccdpc_doc-posnr = us_vbdpr-posnr_vauf.
  ENDIF. " IF NOT us_vbdpr-vbelv IS INITIAL
  APPEND ls_sdaccdpc_doc TO gt_sdaccdpc_doc.


  CALL FUNCTION 'SD_DOWNPAYMENT_READ'
    EXPORTING
      i_waerk           = <gs_vbdkr>-waerk
      i_bukrs           = <gs_vbdkr>-bukrs
      i_kunnr           = <gs_vbdkr>-kunrg
      i_vbel2           = ls_sdaccdpc_doc-vbeln
      i_vbeln           = <gs_vbdkr>-vbeln
      i_sfakn           = <gs_vbdkr>-sfakn
      i_xfilkd          = lv_xfilkd
      i_gesanz          = gc_true
    TABLES
      t_sdaccdpc        = gt_sdaccdpc
    CHANGING
      c_downpay_refresh = gv_downpay_refresh
    EXCEPTIONS
      no_downpayments   = 1
      in_downpayments   = 2
      OTHERS            = 3.

ENDFORM. " get_item_downpayment
*&---------------------------------------------------------------------*
*&      Form  get_head_downpayment
*&---------------------------------------------------------------------*
FORM get_head_downpayment .

  DATA: ls_sdaccdpc TYPE sdaccdpc. " Payments to be cleared

  SORT gt_sdaccdpc_doc BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM gt_sdaccdpc_doc.

  LOOP AT gt_sdaccdpc INTO ls_sdaccdpc.
    READ TABLE gt_sdaccdpc_doc WITH KEY vbeln = ls_sdaccdpc-vgbel
                                        posnr = ls_sdaccdpc-vgpos
                                        BINARY SEARCH
                                        TRANSPORTING NO FIELDS.
    IF NOT sy-subrc IS INITIAL.
      DELETE gt_sdaccdpc.
    ENDIF. " IF NOT sy-subrc IS INITIAL

  ENDLOOP. " LOOP AT gt_sdaccdpc INTO ls_sdaccdpc

  IF NOT <gs_vbdkr>-dpval IS INITIAL.
    <gs_vbdkr>-dpend = gs_interface-head_detail-gross_value.
    SUBTRACT <gs_vbdkr>-dpval FROM <gs_vbdkr>-dpend.
    <gs_vbdkr>-dpmws_end = <gs_vbdkr>-mwsbk - <gs_vbdkr>-dpmws.
  ENDIF. " IF NOT <gs_vbdkr>-dpval IS INITIAL

  gs_interface-head_detail-down_payments = gt_sdaccdpc.

  IF NOT gs_interface-head_detail-down_payments IS INITIAL.
    gs_interface-head_detail-ex_down_payments = gc_true.
  ENDIF. " IF NOT gs_interface-head_detail-down_payments IS INITIAL

ENDFORM. " get_head_downpayment
*&---------------------------------------------------------------------*
*&      Form  initialize_data
*&---------------------------------------------------------------------*
FORM initialize_data .

  CLEAR: gs_interface,
         gv_screen_display,
         gv_price_print_mode,
         gt_komv,
         gs_komk,
         gt_vbtyp_fix_values,
         gv_language,
         gv_dummy,
         gt_sdaccdpc_doc,
         gt_sdaccdpc,
         gs_nast,
         gv_downpay_refresh,
         <gv_returncode>.

* BAdI
  IF bd_sd_bil IS BOUND.
    CALL BADI bd_sd_bil->initialize_data.
  ENDIF. " IF bd_sd_bil IS BOUND
ENDFORM. " initialize_data
*&---------------------------------------------------------------------*
*&      Form  get_head_paymentcards
*&---------------------------------------------------------------------*
FORM get_head_paymentcards.

  DATA: lt_fplt          TYPE TABLE OF fpltvb,         " Reference Structure for XFPLT/YFPLT
        ls_fplt          TYPE fpltvb,                  " Reference Structure for XFPLT/YFPLT
        ls_payment_cards TYPE bil_s_prt_payment_cards. " Structure for Payment Cards

  STATICS:
        ss_tvcint        TYPE tvcint. " Description of payment card type

  CHECK NOT <gs_vbdkr>-rplnr IS INITIAL.
* Read from the Database
  CALL FUNCTION 'BILLING_SCHEDULE_READ'
    EXPORTING
      fplnr         = <gs_vbdkr>-rplnr
    TABLES
      zfplt         = lt_fplt
    EXCEPTIONS
      error_message = 0
      OTHERS        = 0.

* Loop at Cards
  LOOP AT lt_fplt INTO ls_fplt.
    ls_payment_cards = ls_fplt.
*   Get text
    IF ls_fplt-ccins NE ss_tvcint-ccins.
      SELECT SINGLE * FROM tvcint INTO ss_tvcint
             WHERE spras = gv_language
             AND   ccins = ls_fplt-ccins.
      IF sy-subrc =  0.
        ls_payment_cards-description = ss_tvcint-vtext.
      ELSE. " ELSE -> IF sy-subrc = 0
        ls_payment_cards-description = ls_fplt-ccins.
      ENDIF. " IF sy-subrc = 0
    ELSE. " ELSE -> IF ls_fplt-ccins NE ss_tvcint-ccins
      ls_payment_cards-description = ss_tvcint-vtext.
    ENDIF. " IF ls_fplt-ccins NE ss_tvcint-ccins
    APPEND ls_payment_cards TO gs_interface-head_detail-payment_cards.

    ADD ls_fplt-fakwr TO <gs_vbdkr>-ccval.
  ENDLOOP. " LOOP AT lt_fplt INTO ls_fplt

  IF NOT gs_interface-head_detail-payment_cards IS INITIAL.
    gs_interface-head_detail-ex_payment_cards = gc_true.
  ENDIF. " IF NOT gs_interface-head_detail-payment_cards IS INITIAL

ENDFORM. " get_paymentcards
*&---------------------------------------------------------------------*
*&      Form  GET_PAYMENT_SPLIT
*&---------------------------------------------------------------------*
FORM get_payment_split .

  DATA: h_skfbt LIKE acccr-skfbt. " Amnt Eligible for Cash Disc.in the Curr.of the Curr.Types
  DATA: h_fkdat LIKE <gs_vbdkr>-fkdat.
  DATA: h_fkwrt LIKE acccr-wrbtr. " Amount or tax amount in the currency of the currency types
  DATA : BEGIN OF payment_split OCCURS 3.
          INCLUDE STRUCTURE vtopis. " Information Structure for Installment Payment Terms
  DATA : END OF payment_split.
  DATA ls_payment_split TYPE bil_s_prt_payment_split. " Information Structure for Installment Payment Terms

  CHECK <gs_vbdkr>-zterm NE space.

  h_skfbt = <gs_vbdkr>-skfbk.
  h_fkwrt = gs_komk-fkwrt.
  h_fkdat = <gs_vbdkr>-fkdat.
  IF <gs_vbdkr>-valdt NE 0.
    h_fkdat = <gs_vbdkr>-valdt.
  ENDIF. " IF <gs_vbdkr>-valdt NE 0
  IF <gs_vbdkr>-valtg NE 0.
    h_fkdat = <gs_vbdkr>-fkdat + <gs_vbdkr>-valtg.
  ENDIF. " IF <gs_vbdkr>-valtg NE 0
  CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT_SPLI'
    EXPORTING
      i_country                     = <gs_vbdkr>-land1
      bldat                         = h_fkdat
      budat                         = h_fkdat
      cpudt                         = h_fkdat
      language                      = gv_language
      terms_of_payment              = <gs_vbdkr>-zterm
      wert                          = h_fkwrt "Warenwert + Tax
      waerk                         = <gs_vbdkr>-waerk
      fkdat                         = <gs_vbdkr>-fkdat
      skfbt                         = h_skfbt
      i_company_code                = <gs_vbdkr>-bukrs
    TABLES
      top_text_split                = payment_split
    EXCEPTIONS
      terms_of_payment_not_in_t052  = 01
      terms_of_payment_not_in_t052s = 02.

  LOOP AT payment_split.

    MOVE payment_split-line  TO ls_payment_split-line.
    APPEND ls_payment_split TO gs_interface-head_detail-payment_split.

  ENDLOOP. " LOOP AT payment_split

  IF NOT gs_interface-head_detail-payment_split IS INITIAL.
    gs_interface-head_detail-ex_payment_split = gc_true.
  ENDIF. " IF NOT gs_interface-head_detail-payment_split IS INITIAL

ENDFORM. "PAYMENT_SPLIT
