*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_QUOTATION_PROFORMA_F027
* REPORT DESCRIPTION:    Driver Program for quotation proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Alankruta Patnaik (APATNAIK)
* CREATION DATE:         01-FEB-2017
* OBJECT ID:             F027
* TRANSPORT NUMBER(S):   ED2K904328
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906126
* REFERENCE NO: ERP-1940
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05/16/2017
* DESCRIPTION: Email to be sent to Bill-to party (not Ship-to party)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906216
* REFERENCE NO: ERP-2575
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: Modify the process to display Messages
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907523
* REFERENCE NO: F027(CR-473)
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2017-07-26
* DESCRIPTION:
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*-----------------------------------------------------------------------*
* REVISION NO:  ED2K909938
* REFERENCE NO: ERP-5571
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)/Monalisa Dutta (MODUTTA)
* DATE:  2018-01-11
* DESCRIPTION: Fixed the dump issue while generating ZSQT docs. Also Adjusted
*              the code where ever its needed.
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911672
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7332
* REFERENCE NO: ED2K911725
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         02-Apr-2018
* DESCRIPTION:  Billtrust Amount (SAP format --> External format)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0194261
* REFERENCE NO: ED1K907222
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         11-May-2018
* DESCRIPTION:  Activating print option from print preview
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0195504
* REFERENCE NO: ED1K907385
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         18-May-2018
* DESCRIPTION:  Ship To Address & Bill to Address Country missing
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0196380
* REFERENCE NO: ED1K907491
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         24-May-2018
* DESCRIPTION:  Invoice for Single Issues description not displaying
*               correctly
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0198938
* REFERENCE NO: ED1K907672
* DEVELOPER:    Writtick Roy(WROY)
* DATE:         12-June-2018
* DESCRIPTION:  Display Amounts in the first line
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7507 (CR)
* REFERENCE NO: ED1K907763
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         21-June-2018
* DESCRIPTION:  Remove anything that is ISSN, E-ISSN or Print ISSN.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-6302
* REFERENCE NO: ED2K912423
* DEVELOPER:    Sayantan Das (SAYANDAS)
* DATE:         28-JUN-2018
* DESCRIPTION:  Implement Direct Debit Mandate Logic (for F044)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0211562
* REFERENCE NO: ED1K908507
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         20-SEP-2018
* DESCRIPTION:  Proforma Missing CS Contact Details, Remit to Address & Footer
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913588
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0215390
* REFERENCE NO: ED1K908766
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         18-OCT-2018
* DESCRIPTION:  Future Changes Renewal Generated with incorrect year date
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K913797
* REFERENCE NO: ERP-7189 and 7431
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  11/14/2018
* DESCRIPTION: Need to replace MOD10 function module with MOD11
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0236212
* REFERENCE NO: ED1K909876
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         27-Mar-2019
* DESCRIPTION:  Correctly display Year in the Line Item Text in PDF output
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0236212
* REFERENCE NO: ED1K909973
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         08-Apr-2019
* DESCRIPTION:  Correctly display Prod Desc details in the Line Item Text
*               in PDF output
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR- 7841
* REFERENCE NO: ED1K910078
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         29-Apr-2019
* DESCRIPTION:  Replace the 'Year' in item section with 'Contract start date'
*               and 'Contract End Date'.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  DM - 2032
* REFERENCE NO: ED2K915965
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         29-Aug-2019
* DESCRIPTION:  Remove the Emprt line from the internal table
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-17190
* REFERENCE NO: ED2K918549
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         17-June-2020
* DESCRIPTION:  Single Issue Quote
* 1) If document type is ZSIQ then do not display the “Contract Start Date”,
*   “Contract End Date” and “Subscription Term” labels on the output
*	2) Remove the word ‘Start’ from “Start Issue” when document type is ZSIQ
* 3) The statement “Subscriptions will be entered upon receipt of payment.”
*    Should be changed to “Order will be entered upon receipt of payment”
*    when document type is ZSIQ
* 4) German translation for same is - Bestellung wird nach Zahlungseingang bearbeitet
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-2232
* REFERENCE NO: ED2K918763
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/29/2020
* DESCRIPTION:  Reflect Fright forwarder on billing documents where Ship-to currently resides.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-24393
* REFERENCE NO: ED2K919415
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/09/2020
* DESCRIPTION:  DD Mandate Enhancement for VCH Renewals and Firm Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-47818
* REFERENCE NO: ED1K913618
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         10/21/2021
* DESCRIPTION:   Indian Agent Processing
* 1) Change email address to indiaagent@wiley.com (Top Left Box on the Form)
* 2) Credit Card Option removed.
* 3) Change Wire Transfer Details as shown as below.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913785
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40086
* REFERENCE NO: ED2K924580
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         09/15/2021
* DESCRIPTION:
* 1) if Material group4 (VBRP- MVGR4= BK- eBooks, JU-eJournal, BU-eBundle
*    then print the media type as Digital
* 2) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue then print the media type as Print
* 3) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue, BK- eBooks, JU-eJournal, BU-eBundle then print
*    the media type as Print & digital.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-49271
* REFERENCE NO: ED2K925516
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         01/10/2022
* DESCRIPTION: Add volume and issue on Proformas for VCH products
*----------------------------------------------------------------------*
*&  Include           ZQTCN_QUOT_PRO_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing.
*******Local Constant Declaration
  CONSTANTS: lc_05 TYPE na_nacha VALUE '5', "Message transmission medium
             lc_07 TYPE na_nacha VALUE '7'. "Message transmission medium

*** BOC BY SAYANDAS on 05-FEB-2018
  CONSTANTS: lc_zsqt TYPE sna_kschl VALUE 'ZSQT', " Message type
             lc_zsqs TYPE sna_kschl VALUE 'ZSQS'. " Message type
*** EOC BY SAYANDAS on 05-FEB-2018
  PERFORM f_clear_variable.

* Perform to populate Wiley Logo
  PERFORM f_get_wiley_logo     CHANGING  v_xstring.


* Perform to populate society logo
  PERFORM f_get_society_logo   CHANGING  v_society_logo
                                         v_society_text.

* Perform to populate sales data from NAST table
  PERFORM f_get_data           USING     nast
                               CHANGING  st_vbco3.

* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
  PERFORM f_get_constants  CHANGING i_constant
                                    r_mtart_med_issue
                                    i_tax_id. "CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
  PERFORM f_get_stxh_data USING    v_langu
                          CHANGING i_std_text.
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376

*  Perform to fetch data
  PERFORM f_get_vbap_data      USING               st_vbco3
                               CHANGING            i_vbap
                                                   i_vbpa
                                                   st_header
                                                   st_address
                                                   st_calc
                                                   i_sub_final
                                                   i_final
                                                   v_remit_to_uk
                                                   v_remit_to_usa
                                                   v_footer1
                                                   v_footer2
                                                   v_detach
                                                   v_order
*                                                   v_credit
                                                   v_cust
                                                   v_com_uk
                                                   v_com_usa
                                                   i_makt.
* Begin of Change:CR#2032:SGUDA:29-AUG-2019:ED2K915965
  DELETE i_final WHERE prod_des = space.
* End of Change:CR#2032:SGUDA:29-AUG-2019:ED2K915965
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
  PERFORM f_populate_barcode.
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
  PERFORM f_call_drct_dbt_mndt.
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
  IF v_comm_meth EQ c_comm_method. "LET
    IF nast-kschl EQ lc_zsqt.
*     Print Preview
      PERFORM f_adobe_prnt_zsqt.
    ELSEIF nast-kschl EQ lc_zsqs.
      PERFORM f_adobe_prnt_zsoc.
    ENDIF. " IF nast-kschl EQ lc_zsqt
  ELSE. " ELSE -> IF v_comm_meth EQ c_comm_method
*   Perform has been used to send mail with an attachment of PDF
    IF nast-kschl EQ lc_zsqt.
      PERFORM f_adobe_email_output.
    ELSEIF nast-kschl EQ lc_zsqs.
      PERFORM f_adobe_email_output_soc.
    ENDIF. " IF nast-kschl EQ lc_zsqt
  ENDIF. " IF v_comm_meth EQ c_comm_method
  v_output_typ = nast-kschl.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_WILEY_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_XSTRING  text
*----------------------------------------------------------------------*
FORM f_get_wiley_logo  CHANGING fp_v_xstring TYPE xstring.
*******Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object    " GRAPHICS
      p_name         = lc_logo_name " ZJWILEY_LOGO
      p_id           = lc_id        " BMAP
      p_btype        = lc_btype     " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
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
*&      Form  F_GET_SOCIETY_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBCO3  text
*      <--P_V_SOCIETY_LOGO  text
*----------------------------------------------------------------------*
FORM f_get_society_logo CHANGING fp_v_society_logo TYPE xstring
                                 fp_v_society_text TYPE name1_gp. " Name 1
*********Local constant declaration
  CONSTANTS : lc_order  TYPE char10     VALUE 'ORDER',    " Order of type CHAR10
              lc_object TYPE tdobjectgr VALUE 'GRAPHICS', " SAPscript Graphics Management: Application object
              lc_id     TYPE tdidgr     VALUE 'BMAP',     " SAPscript Graphics Management: ID
              lc_btype  TYPE tdbtype    VALUE 'BCOL'.     " Graphic type

********Local Data declaration
  DATA: lv_society_logo TYPE char100,  "variable of society logo
        lv_vbeln        TYPE vbeln,    " Sales and Distribution Document Number
        lv_logo_name    TYPE tdobname. " Name

  CLEAR : fp_v_society_logo.

  lv_vbeln = nast-objky+0(10).
*******Get the name of LOGO for Form
  CALL FUNCTION 'ZQTC_GET_FORM_LOGO_NAME'
    EXPORTING
      im_doc_no                     = lv_vbeln " nast-objky
      im_doc_type                   = lc_order "'ORDER'
    IMPORTING
      ex_logo_name                  = lv_society_logo
*     Begin of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911361
*     ex_sold_to_name               = fp_v_society_text
*     End   of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911361
    EXCEPTIONS
      non_society_customers         = 1
      non_society_materials         = 2
      invalid_document_number       = 3
      invalid_document_type         = 4
      material_group_not_maintained = 5
      OTHERS                        = 6.
  IF sy-subrc EQ 0.
    lv_logo_name = lv_society_logo.
  ENDIF. " IF sy-subrc EQ 0
*** BOC BY SAYANDAS
  IF lv_society_logo IS INITIAL.
    CLEAR fp_v_society_text.
  ENDIF. " IF lv_society_logo IS INITIAL
*** EOC BY SAYANDAS
******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object         " GRAPHICS
      p_name         = lv_logo_name
      p_id           = lc_id             " BMAP
      p_btype        = lc_btype          " BMON
    RECEIVING
      p_bmp          = fp_v_society_logo " Image Data
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
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_BAPI_VIEW  text
*----------------------------------------------------------------------*
FORM f_get_data       USING    fp_nast     TYPE nast   " Message Status
                      CHANGING fp_st_vbco3 TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing

  fp_st_vbco3-mandt = sy-mandt.
  fp_st_vbco3-spras = fp_nast-spras.
  fp_st_vbco3-vbeln = fp_nast-objky+0(10).
  fp_st_vbco3-posnr = fp_nast-objky+10(6).
  fp_st_vbco3-kunde = fp_nast-parnr.
  fp_st_vbco3-parvw = fp_nast-parvw.
  v_langu = fp_nast-spras.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT
*&---------------------------------------------------------------------*
*       Email output
*----------------------------------------------------------------------*
FORM f_adobe_email_output .
****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_funcname_soc     TYPE funcname,        " Function name
        lv_msgv_formnm      TYPE syst_msgv,       " Message Variable
        lv_form_name        TYPE fpname,          " Name of Form Object
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string.

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_INV', " Name of Form Object
             lc_msgnr_165 TYPE sy-msgno VALUE '165',                 " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',                 " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2',             " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.                   " ABAP System Field: Message Type

  lv_form_name = tnapr-sform.
  lv_msgv_formnm = tnapr-sform.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true. "Comment by MODUTTA on 11-May-18 for INC0194261
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc IS NOT INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
    v_retcode = 900.
    RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = lc_msgid
              msg_nr                 = lc_msgnr_166
              msg_ty                 = lc_err
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          .
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.

    CALL FUNCTION lv_funcname "'/1BCDWB/SM00000068'
      EXPORTING
        /1bcdwb/docparams    = lst_sfpdocparams
        im_header            = st_header
        im_xstring           = v_xstring
        im_langu             = v_langu
        im_vbco3             = st_vbco3
        im_address           = st_address
*** BOC BY SAYANDAS
        im_sub_final         = i_sub_final
*** EOC BY SAYANDAS
        im_final             = i_final
        im_calc              = st_calc
        im_society_logo      = v_society_logo
        im_vbap              = vbap
        im_remit_to_uk       = v_remit_to_uk
        im_remit_to_usa      = v_remit_to_usa
*       im_detach            = v_detach
        im_order_uk          = v_com_uk
        im_order_usa         = v_com_usa
        im_footer1           = v_footer1
        im_footer2           = v_footer2
        im_remit_to_tbt_usa  = v_remit_to_tbt_usa
        im_remit_to_tbt_uk   = v_remit_to_tbt_uk
        im_banking1_tbt_usa  = v_banking1_tbt_usa
        im_banking1_tbt_uk   = v_banking1_tbt_uk
        im_cust_serv_tbt_usa = v_cust_serv_tbt_usa
        im_cust_serv_tbt_uk  = v_cust_serv_tbt_uk
        im_email_tbt_usa     = v_email_tbt_usa
        im_email_tbt_uk      = v_email_tbt_uk
        im_credit_tbt_usa    = v_credit_tbt_usa
        im_credit_tbt_uk     = v_credit_tbt_uk
        im_footer_tbt        = v_footer
*** BOC BY SAYANDAS
        im_v_society_text    = v_society_text
        im_comp_name         = v_comp_name
*** EOC BY SAYANDAS
        im_customer          = v_cust
        im_remit_to_scc      = v_remit_to_scc
        im_remit_to_scm      = v_remit_to_scm
        im_banking1_scc      = v_banking1_scc
        im_banking1_scm      = v_banking1_scm
        im_cust_serv_scc     = v_cust_serv_scc
        im_cust_serv_scm     = v_cust_serv_scm
        im_email_scc         = v_email_scc
        im_email_scm         = v_email_scm
        im_credit_scc        = v_credit_scc
        im_credit_scm        = v_credit_scm
        im_footer_scc        = v_footer
        im_footer_scm        = v_footer
*** BOC BY SAYANDAS
        im_barcode           = v_barcode
*** EOC BY SAYNADAS
        im_seller_reg        = v_seller_reg
        im_email             = v_email_id
        im_tax               = v_tax
*** BOC BY SAYANDAS
        im_credit_crd        = v_credit_crd
        im_payment           = v_payment
        im_payment_scc       = v_payment_scc
        im_payment_scm       = v_payment_scm
        im_mis_msg           = v_mis_msg
*** EOC BY SAYANDAS
        im_credit_email      = v_credit_crd_email "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
        im_po_type           = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IMPORTING
        /1bcdwb/formoutput   = st_formoutput
      EXCEPTIONS
        usage_error          = 1
        system_error         = 2
        internal_error       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
        v_retcode = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL

  IF v_ent_screen IS INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    IF st_formoutput-pdf IS INITIAL.
*     Message: Error occurred generating PDF file
      MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
    ENDIF. " IF st_formoutput-pdf IS INITIAL
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
    INSERT st_formoutput INTO i_formoutput INDEX 1.
*   Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
    IF st_formoutput_f044 IS NOT INITIAL.
*   End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
      INSERT st_formoutput_f044 INTO i_formoutput INDEX 2.
*   Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
    ENDIF.
*   End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
********Perform is used to convert PDF in to Binary
*    PERFORM f_convert_pdf_binary.

********Perform is used to create mail attachment with a creation of mail body
    PERFORM f_mail_attachment USING st_vbco3.
  ENDIF. " IF v_ent_screen IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBCO3  text
*      <--P_ST_VBAP  text
*----------------------------------------------------------------------*
FORM f_get_vbap_data  USING    fp_st_vbco3       TYPE vbco3              " Sales Doc.Access Methods: Key Fields: Document Printing
                      CHANGING fp_i_vbap         TYPE tt_vbap
                               fp_i_vbpa         TYPE tt_vbpa
                               fp_st_header      TYPE zstqtc_header_f027 " Header Structure for Quotation
                               fp_st_address     TYPE zstqtc_add_f027    " Structure for address node
                               fp_st_calc        TYPE zstqtc_calc        " Structure for Calculation
                               fp_i_sub_final    TYPE zttqtc_sub_item_f027
                               fp_i_final        TYPE zttqtc_item_f027
                               fp_v_remit_to_uk  TYPE thead-tdname       " Name
                               fp_v_remit_to_usa TYPE thead-tdname       " Name
                               fp_v_footer1      TYPE thead-tdname       " Name
                               fp_v_footer2      TYPE thead-tdname       " Name
                               fp_v_detach       TYPE thead-tdname       " Name
                               fp_v_order        TYPE thead-tdname       " Name
*                              fp_v_credit       TYPE thead-tdname       " Name
                               fp_v_customer     TYPE thead-tdname " Name
                               fp_v_com_uk       TYPE thead-tdname " Name
                               fp_v_com_usa      TYPE thead-tdname " Name
                               fp_i_makt         TYPE tt_makt.
******Local Data declaration
  DATA: lst_final           TYPE zstqtc_item_f027,        " Structure for item data
        lst_final_subtitle  TYPE zstqtc_item_f027,        " Structure for item data
        lst_vbak            TYPE ty_vbak,                 "Local workarea for vbak structure
        lv_total_char       TYPE char18,                  " Total_char of type CHAR18
        lv_waerk            TYPE waerk,                   "Local Variable for currency
        lv_total_amount     TYPE kzwi2,                   " Subtotal 2 from pricing procedure for condition
        lv_amt              TYPE kzwi2,                   " Subtotal 2 from pricing procedure for condition
        lv_total_tax        TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lv_header_tax       TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lv_disc             TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
        lv_total_pf         TYPE kwert,                   " Condition value
        lv_tot_pf_char      TYPE char18,                  " Tot_pf_char of type CHAR18
        lv_disc_char        TYPE char20,                  " Disc_char of type CHAR20
        lv_bukrs_vf         TYPE bukrs_vf,                "Local variable for company code
        lv_day              TYPE char2,                   " Date of type CHAR2
        lv_month_c2         TYPE char2,                   " Mnthc2 of type CHAR2
        lv_month_c3         TYPE char3,                   " Mnthc3 of type CHAR3
        lv_month            TYPE t247-ltx,                " Month long text
        lv_year             TYPE char4,                   " Year of type CHAR4
        lv_datum            TYPE char15,                  " renewal date of char 15
        lv_text_name        TYPE thead-tdname,            " Name of text to be read
        li_lines            TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines           TYPE tline,                   " Lines of text read
        li_bukrs_usa        TYPE cchry_bukrs_range,
        li_bukrs_uk         TYPE cchry_bukrs_range,
        lst_bukrs_usa       TYPE cchrs_bukrs_range,       " EHS-INT: Ranges Structure for Company Code (BUKRS)
        lst_bukrs_uk        TYPE cchrs_bukrs_range,       " EHS-INT: Ranges Structure for Company Code (BUKRS)
        lv_kwmeng           TYPE meng15,                  " Quantity field, 15 characters
        lv_kwmeng_char      TYPE char18,                  " Kwmeng_char of type CHAR18
        lv_kwmeng_qty       TYPE char22,                  " Kwmeng_qty of type CHAR22
        lv_kwmeng_dec       TYPE char13,                  " Kwmeng_dec of type CHAR13
        lv_up_char          TYPE char20,                  " Up_char of type CHAR20
        lv_unit_price       TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
        lv_amt_temp         TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
        lv_meins            TYPE meins,                   " Base Unit of Measure
        lv_amount_tax       TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
        lv_doc_line         TYPE /idt/doc_line_number,    "(++)MODUTTA on 08/08/2017 for CR#408
        lv_buyer_reg        TYPE char255,                 "(++)MODUTTA on 08/08/2017 for CR#408
        lv_tax_sum          TYPE p DECIMALS 2,            " Tax_sum of type Packed Number
        lv_tax_sum_temp     TYPE p DECIMALS 2,            " Tax_sum_temp of type Packed Number
        lv_tax_amount_temp  TYPE p DECIMALS 2,            " Tax_sum_temp of type Packed Number
*       Begin of ADD:INC0198938:WROY:12-June-2018:ED1K907672
        lv_prod_des         TYPE tdline, " To swap Product Description
*       End   of ADD:INC0198938:WROY:12-June-2018:ED1K907672
* BOI: PBANDLAPAL:12-Jan-2018:ERP-5571: ED2K909938
        lv_item_tax_amt     TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
        lv_final_tax_amt    TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
        lv_amt_act_temp     TYPE p DECIMALS 2, " Amt_act_temp of type Packed Number
*        lv_tax_amt_temp1    TYPE p DECIMALS 2,
*        lv_tax_amt_temp2    TYPE p DECIMALS 2,
* EOI: PBANDLAPAL:12-Jan-2018:ERP-5571: ED2K909938
        lv_final_tax_amount TYPE char25. " Final_tax_amount of type CHAR25

*******Local constant declaration
  CONSTANTS: lc_we            TYPE parvw          VALUE 'WE',         " Ship to address
             lc_re            TYPE parvw          VALUE 'RE',         " Ship to address
             lc_ff            TYPE parvw          VALUE 'SP',         " Fright Forwarder "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
             lc_underscore    TYPE char1          VALUE '_',          " Underscore
             lc_txtname_part1 TYPE char10         VALUE 'ZQTC_F027_', " Txtname_part1 of type CHAR20
             lc_remit_to      TYPE char10         VALUE 'REMIT_TO_',  " Txtname_part2 of type CHAR6
             lc_footer1       TYPE char10         VALUE 'FOOTER1',    " Txtname_part2 of type CHAR6
             lc_footer2       TYPE char10         VALUE 'FOOTER2',    " Txtname_part2 of type CHAR6
             lc_detach        TYPE char10         VALUE 'DEATTACH',   " Detach of type CHAR10
             lc_order         TYPE char10         VALUE 'COMMENTS_',  " Order of type CHAR10
             lc_cust          TYPE char12         VALUE 'CUSTOMER',   " Cust of type CHAR12
             lc_hyphen        TYPE char01         VALUE '-',          "Constant for hyphen
             lc_id            TYPE thead-tdid     VALUE '0001',       "Text ID of text to be read
             lc_object        TYPE thead-tdobject VALUE 'VBBP',       "Object of text to be read
             lc_usa           TYPE rvari_vnam     VALUE 'CCODE_USA',  " ABAP: Name of Variant Variable
             lc_uk            TYPE rvari_vnam     VALUE 'CCODE_UK',   " ABAP: Name of Variant Variable
             lc_sign          TYPE tvarv_sign     VALUE 'I',          " ABAP: ID: I/E (include/exclude values)
             lc_op            TYPE tvarv_opti     VALUE 'EQ',         " ABAP: Selection option (EQ/BT/CP/...)
             lc_b             TYPE char1          VALUE '(',          " B of type CHAR1
             lc_bb            TYPE char1          VALUE ')',          " Bb of type CHAR1
             lc_issues        TYPE char6          VALUE 'issues',     " Issues of type CHAR6
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
             lc_hier2         TYPE ismhierarchlvl VALUE '2', " Hierarchy Level (Media Product Family, Product or Issue)
             lc_hier3         TYPE ismhierarchlvl VALUE '3', " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
             lc_banking1      TYPE char9  VALUE 'BANKING1_',     " Banking1 of type CHAR9
             lc_cust_ser      TYPE char13 VALUE 'CUST_SERVICE_', " Cust of type CHAR13
             lc_email         TYPE char6  VALUE 'EMAIL_',        " Email of type CHAR6
             lc_credit        TYPE char7  VALUE 'CREDIT_',       " Credit of type CHAR7
             lc_tbt           TYPE char3  VALUE 'TBT',           " Tbt of type CHAR3
             lc_scc           TYPE char3  VALUE 'SCC',           " Scc of type CHAR3
             lc_scm           TYPE char3  VALUE 'SCM',           " Scm of type CHAR3
             lc_sp            TYPE parvw  VALUE 'AG',            " Partner Function
             lc_za            TYPE parvw  VALUE 'ZA',            " Partner Function
             lc_st            TYPE thead-tdid     VALUE 'ST',    "Text ID of text to be read
             lc_text          TYPE thead-tdobject VALUE 'TEXT'.  "Object of text to be read

  TYPES : BEGIN OF ty_tkomv,
            knumv TYPE konv-knumv, " Number of the document condition
            kposn TYPE konv-kposn, " Condition item number
            stunr TYPE konv-stunr, " Step number
            zaehk TYPE konv-zaehk, " Condition counter
            kappl TYPE konv-kappl, " Application
            kawrt TYPE kawrt,      " Condition base value
            kbetr TYPE konv-kbetr, " Rate (condition amount or percentage)
            waers TYPE konv-waers, " Currency Key
            koaid TYPE konv-koaid, " Condition class
          END OF ty_tkomv.

*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
  TYPES : BEGIN OF lty_iss_vol2,
            matnr TYPE matnr,         " Material Number
***         BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
            year  TYPE ismjahrgang,   " Year
***         EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
            stvol TYPE ismheftnummer, " Copy Number of Media Issue
            stiss TYPE ismnrimjahr,   " Media Issue
            noi   TYPE sytabix,       " Row Index of Internal Tables
          END OF  lty_iss_vol2.

  TYPES : BEGIN OF lty_iss_vol3,
            matnr TYPE matnr,         " Material Number
            stvol TYPE ismheftnummer, " Copy Number of Media Issue
            stiss TYPE ismnrimjahr,   " Media Issue
            noi   TYPE sytabix,       " Row Index of Internal Tables
          END OF lty_iss_vol3.
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
  DATA: li_tkomv            TYPE STANDARD TABLE OF ty_tkomv, " Pricing Communications-Condition Record
        li_tkomvd           TYPE STANDARD TABLE OF komvd,    " Price Determination Communication-Cond.Record for Printing
        li_vbap_tmp         TYPE tt_vbap,
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
        li_vbap_tmp1        TYPE tt_vbap,
        li_vbap_tmp2        TYPE tt_vbap,
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
        lst_komk            TYPE komk,         " Communication Header for Pricing
        lst_komp            TYPE komp,         " Communication Item for Pricing
        lv_kbetr_desc       TYPE p DECIMALS 3, "kbetr,                      " Rate (condition amount or percentage)
*        lv_kbetr_3dec       TYPE p DECIMALS 3,
        lv_kbetr_char       TYPE char25,       " Kbetr_char of type CHAR15
        lv_year_1           TYPE char30,       " Year
        lv_year_2           TYPE char30,       " Year_2 of type CHAR30
        lv_cntr_end         TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:29-Apr-2019:ED1K910078
        lv_cntr_month       TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:29-Apr-2019:ED1K910078
        lv_cntr             TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:29-Apr-2019:ED1K910078
        lv_day1(2)          TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
        lv_month1(2)        TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910078
        lv_year2(4)         TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910078
        lv_stext            TYPE t247-ktx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910078
        lv_ltext            TYPE t247-ltx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910078
        lv_volum            TYPE char30,       " Volume
        lv_vol              TYPE char8,        " Volume
        lv_flag_di          TYPE char1,        " Flag_di of type CHAR1
        lv_flag_ph          TYPE char1,        " Flag_ph of type CHAR1
        lv_issue            TYPE char30,       " Issue
        lv_name             TYPE thead-tdname, " Name
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
        lv_bhf              TYPE char1,        " Bhf of type CHAR1
        lv_lcf              TYPE char1,        " Lcf of type CHAR1
        lv_noiv             TYPE char3,        " Noiv of type CHAR3
        lv_noit             TYPE char30,       " Noit of type CHAR30
        lv_name_issn        TYPE thead-tdname, " Name
        lv_all_des          TYPE char255,      " All_des of type CHAR255
        lv_noi_des          TYPE char255,      " Noi_des of type CHAR255
        lv_year_des         TYPE char255,      " Year_des of type CHAR255
        lv_vol_des          TYPE char255,      " Vol_des of type CHAR255
        lv_issue_des        TYPE char255,      " Issue_des of type CHAR255
        lst_jptidcdassign1  TYPE ty_jptidcdassign,
        lv_identcode_zjcd   TYPE char20,       " Identcode of type CHAR20
        lv_line             TYPE sytabix,      " Row Index of Internal Tables
        lst_iss_vol2        TYPE lty_iss_vol2,
        li_iss_vol2         TYPE STANDARD TABLE OF lty_iss_vol2 INITIAL SIZE 0,
        lst_iss_vol3        TYPE lty_iss_vol3,
        li_iss_vol3         TYPE STANDARD TABLE OF lty_iss_vol3 INITIAL SIZE 0,
        lv_pay_term         TYPE dzterm_bez,   " Description of terms of payment
        lv_iss              TYPE ismnrimjahr,  " Issue Number (in Year Number)
        lv_mlsub            TYPE char30,       " Issue
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
        lv_identcode        TYPE char20, " Identcode of type CHAR20
        lv_pnt_issn         TYPE char30, "char10," Print ISSN ++ SAYANDAS
*        lv_tax              TYPE thead-tdname, " Name
        lv_subscription_typ TYPE char100, " Subscription_typ of type CHAR100
*       Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
        lv_sub_ref_id       TYPE char100, " Sub Ref ID
*       End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
        lv_mat_text         TYPE string,
        lv_tdname           TYPE thead-tdname, " Name
        lv_posnr            TYPE posnr,        " Subtotal 2 from pricing procedure for condition
**        boc by modutta
        lv_issue_desc       TYPE tdline,               " Text Line
        lst_tax_item        TYPE ty_tax_item,
        li_tax_item         TYPE tt_tax_item,
        lv_kbetr            TYPE kbetr,                " Rate (condition amount or percentage)
        lv_tax_amount       TYPE p DECIMALS 3,         " Subtotal 6 from pricing procedure for condition
        lv_tax              TYPE kzwi6,                " Tax
        lv_tax_bom          TYPE kzwi6,                " Subtotal 6 from pricing procedure for condition
        lv_amnt             TYPE kzwi1,                " Subtotal 1 from pricing procedure for condition
        lst_tax_item_final  TYPE zstqtc_sub_item_f027, " Structure for tax components
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
        lst_vbeln           TYPE vbak, "Sales Document
        lt_vbpa_ff          TYPE vbpa_tab,       " Frighet Forwarder
        lv_ff_flag(1)       TYPE c,
        lv_multiple         TYPE c.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
*  Constant Declaration
  CONSTANTS: lc_percentage   TYPE char1 VALUE '%',                           " Percentage of type CHAR1
             lc_gjahr        TYPE gjahr VALUE '0000',                        " Fiscal Year
             lc_doc_type     TYPE /idt/document_type VALUE 'VBAK',
             lc_year         TYPE thead-tdname VALUE 'ZQTC_YEAR_F024',       " Name
             lc_cntr_start   TYPE thead-tdname VALUE 'ZQTC_F042_CNT_STRT_DATE',  " Contract Start Date "CR-7841:SGUDA:29-Apr-2019:ED1K910078
             lc_cntr_end     TYPE thead-tdname VALUE 'ZQTC_F042_CNT_END_DATE',   " Contract End Date "CR-7841:SGUDA:29-Apr-2019:ED1K910078
             lc_5            TYPE stlan        VALUE '5',                    " BOM Usage
             lc_jp           TYPE land1        VALUE 'JP',                   " Japan Contry Code-INC0193984
             lc_country      TYPE rvari_vnam   VALUE 'COUNTRY',              " Country - INC0193984
             lc_volume       TYPE thead-tdname VALUE 'ZQTC_VOLUME_F042',     " Name
             lc_pntissn      TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042', " Name
             lc_eissn        TYPE thead-tdname VALUE 'ZQTC_EISSN_F042',      " Name
             lc_issue        TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',      " Name
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
             lc_digissn      TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
             lc_combissn     TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042', " Name
             lc_stiss        TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',    " Name
             lc_stiss_zsiq   TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042_ZSIQ',    " Name ""ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
             lc_comma        TYPE char1        VALUE ',',                       " Comma of type CHAR1
             lc_uepos        TYPE uepos        VALUE '000000',                  " Higher-level item in bill of material structures
*             lc_combissn     TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042',   " Name
             lc_in           TYPE mvgr5        VALUE 'IN', " Material group 5
             lc_of           TYPE mvgr5        VALUE 'OF', " Material group 5
             lc_di           TYPE mvgr5        VALUE 'DI', " Material group 5
             lc_ma           TYPE mvgr5        VALUE 'MA', " Material group 5
             lc_wp           TYPE mvgr5        VALUE 'WP', " Material group 5
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
             lc_digt_subsc   TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
             lc_prnt_subsc   TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
             lc_comb_subsc   TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
             lc_mlsubs       TYPE thead-tdname VALUE 'ZQTC_MSUBS_F042',                 " Name
*            Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
             lc_sub_ref_id   TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*            End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
             lc_journal      TYPE ismidcodetype VALUE 'ZSSN', " Type of Identification Code
*           Added by MODUTTA on 18/08/2017
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
             lc_idcodetype_1 TYPE rvari_vnam VALUE 'IDCODETYPE_1', " ABAP: Name of Variant Variable
             lc_idcodetype_2 TYPE rvari_vnam VALUE 'IDCODETYPE_2', " ABAP: Name of Variant Variable
             lc_kvgr1        TYPE rvari_vnam VALUE 'KVGR1',        " ABAP: Name of Variant Variable
             lc_mvgr5_scc_in TYPE rvari_vnam VALUE 'MVGR5_SCC_IN', " ABAP: Name of Variant Variable
             lc_mvgr5_scc_of TYPE rvari_vnam VALUE 'MVGR5_SCC_OF', " ABAP: Name of Variant Variable
             lc_mvgr5_scm_di TYPE rvari_vnam VALUE 'MVGR5_SCM_DI', " ABAP: Name of Variant Variable
             lc_mvgr5_scm_ma TYPE rvari_vnam VALUE 'MVGR5_SCM_MA', " ABAP: Name of Variant Variable
             lc_mvgr5_tbt    TYPE rvari_vnam  VALUE 'MVGR5_TBT',   " ABAP: Name of Variant Variable
             lc_posnr        TYPE posnr VALUE '000000',            " Item number of the SD document
             lc_level2       TYPE ismhierarchlvl VALUE '2',        " Hierarchy Level (Media Product Family, Product or Issue)
             lc_level3       TYPE ismhierarchlvl VALUE '3',        " Hierarchy Level (Media Product Family, Product or Issue)
             lc_colonb       TYPE char2 VALUE ': ',                " Colonb of type CHAR2
*** EOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
             lc_colon        TYPE char1 VALUE ':',                          " Colon of type CHAR1
             lc_under        TYPE char1 VALUE '-',                          " Underscore "Contract Start Date "CR-7841:SGUDA:29-Apr-2019:ED1K910078
             lc_vat          TYPE char5      VALUE '_VAT',                  " Vat of type CHAR3
             lc_tax          TYPE char5      VALUE '_TAX',                  " Tax of type CHAR3
             lc_gst          TYPE char5      VALUE '_GST',                  " Gst of type CHAR3
             lc_class        TYPE char5      VALUE 'ZQTC_',                 " Class of type CHAR5
             lc_devid        TYPE char5      VALUE 'F027',                  " Devid of type CHAR5
             lc_pd           TYPE char50     VALUE 'Print and Digital',     " Pd of type CHAR50
             lc_pdt          TYPE char50     VALUE 'Print and Digital Tax', " Pdt of type CHAR50
             lc_d            TYPE char50     VALUE 'Digital',               " D of type CHAR50
             lc_dt           TYPE char50     VALUE 'Digital Tax',           " Dt of type CHAR50
             lc_p            TYPE char50     VALUE 'Print',                 " P of type CHAR50
             lc_pt           TYPE char50     VALUE 'Print Tax',             " Pt of type CHAR50
             lc_c            TYPE char50     VALUE 'Combined',              " C of type CHAR50
             lc_ct           TYPE char50     VALUE 'Combined Tax',          " Ct of type CHAR50
             lc_tax_text     TYPE tdobname VALUE 'ZQTC_TAX_F024',
             lc_1001         TYPE bukrs_vf   VALUE '1001'. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745           " Name
*           Added by MODUTTA on 18/08/2017
*End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

  DATA: lst_vbap    TYPE ty_vbap,
        lst_vbpa    TYPE ty_vbpa,
*        lv_kunnr_sp TYPE kunnr, " Customer Number
        lv_kunnr_za TYPE kunnr. " Customer Number

  CLEAR: lst_final,
         fp_i_final.
  CONDENSE: v_tax.

* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*Get the constants from ZCACONSTANT table
  LOOP AT i_constant INTO DATA(lst_const).
    CASE lst_const-param1.
      WHEN lc_usa.
        lst_bukrs_usa-sign = lc_sign.
        lst_bukrs_usa-option = lc_op.
        lst_bukrs_usa-low = lst_const-low.
        APPEND lst_bukrs_usa TO li_bukrs_usa.
        CLEAR:lst_bukrs_usa.
      WHEN lc_uk.
        lst_bukrs_uk-sign = lc_sign.
        lst_bukrs_uk-option = lc_op.
        lst_bukrs_uk-low = lst_const-low.
        APPEND lst_bukrs_uk TO li_bukrs_uk.
        CLEAR:lst_bukrs_uk.
      WHEN c_mtart_med_iss.
        APPEND INITIAL LINE TO r_mtart_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
        <lst_med_issue>-sign   = lst_const-sign.
        <lst_med_issue>-option = lst_const-opti.
        <lst_med_issue>-low    = lst_const-low.
        <lst_med_issue>-high   = lst_const-high.
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
      WHEN lc_idcodetype_1.
        v_idcodetype_1 = lst_const-low.
      WHEN lc_idcodetype_2.
        v_idcodetype_2 = lst_const-low.
*** EOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
      WHEN lc_kvgr1.
        v_kvgr1 = lst_const-low.
      WHEN lc_mvgr5_scc_in.
        v_mvgr5_scc_in = lst_const-low.
      WHEN lc_mvgr5_scc_of.
        v_mvgr5_scc_of = lst_const-low.
      WHEN lc_mvgr5_scm_di.
        v_mvgr5_scm_di = lst_const-low.
      WHEN lc_mvgr5_scm_ma.
        v_mvgr5_scm_ma = lst_const-low.
      WHEN lc_mvgr5_tbt.
        v_mvgr5_tbt = lst_const-low.
*** EOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
      WHEN lc_country.
**BOC by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
        fp_st_address-bill_trust = lst_const-low.
**EOC by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
      WHEN OTHERS.
***Do nothing
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant INTO DATA(lst_const)
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

  SELECT    a~vbeln  " Sales Document
            a~posnr  " Sales Document Item
            a~matnr  " Material Number
            a~arktx  " Short text for sales order item
            a~uepos  " Higher-level item in bill of material structures
            a~meins  " Base Unit of Measure
            a~kwmeng " Cumulative Order Quantity in Sales Units
            a~kzwi1  " Subtotal 1 from pricing procedure for condition
            a~kzwi2  " Subtotal 2 from pricing procedure for condition
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
            a~kzwi3
            b~netwr
            a~zmeng
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
            a~kzwi5 " Subtotal 5 from pricing procedure for condition
            a~kzwi6 " Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
            a~mvgr4 " Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
*** BOC BY SAYANDAS on 24-JAN-2018 for CR-XXX
            a~mvgr5
*** BOC BY SAYANDAS on 24-JAN-2018 for CR-XXX
            a~mwsbp " Tax amount in document currency
            b~angdt " Quotation/Inquiry is valid from
            b~vbtyp " SD document category
            b~waerk " SD Document Currency
            b~vkbur " Sales Office
            b~knumv " Number of the document condition
*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
            b~kvgr1
*** EOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
            b~bukrs_vf " Company code to be billed
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
            b~auart  "Sales Document Type
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
       FROM vbap AS a
   INNER JOIN vbak AS b
   ON a~vbeln EQ b~vbeln
   INTO TABLE fp_i_vbap
   WHERE a~vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

    DATA(li_vbap) = fp_i_vbap[].
    SORT li_vbap BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING matnr.
    SORT fp_i_vbap BY vbeln posnr.


*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
    DATA(li_vbap_temp) = fp_i_vbap[].

*** Logic for Pro-forma for Socity
    READ TABLE li_vbap_temp WITH KEY mvgr5 = v_mvgr5_tbt TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      v_tbt = abap_true.
    ELSE. " ELSE -> IF sy-subrc = 0
      READ TABLE li_vbap_temp WITH KEY mvgr5 = v_mvgr5_scc_in TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        v_scc = abap_true.
      ELSE. " ELSE -> IF sy-subrc = 0
        READ TABLE li_vbap_temp WITH KEY mvgr5 = v_mvgr5_scc_of TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          v_scc = abap_true.
        ELSE. " ELSE -> IF sy-subrc = 0
          READ TABLE li_vbap_temp WITH KEY mvgr5 = v_mvgr5_scm_di TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            v_scm = abap_true.
          ELSE. " ELSE -> IF sy-subrc = 0
            READ TABLE li_vbap_temp WITH KEY mvgr5 = v_mvgr5_scm_ma TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              v_scm = abap_true.
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc = 0
*** Fetch Data from VEDA
    SELECT vbeln,
           vposn,
           vlaufk,
           vbegdat, " Contract start date
***        BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
           venddat  " Contract end date
***        EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
      FROM veda    " Contract Data
      INTO TABLE @DATA(li_veda)
      FOR ALL ENTRIES IN @li_vbap_temp
      WHERE vbeln = @li_vbap_temp-vbeln.
    IF sy-subrc = 0.
      DATA: lst_veda LIKE LINE OF li_veda.
* Begin of CHANGE:INC0215390:SGUDA:18-OCT-2018:ED1K908766
*      READ TABLE li_veda INTO lst_veda INDEX 1.
* Begin of CHANGE:INC0236212:NPALLA:27-Mar-2019:ED1K909876
      SORT li_veda BY vbeln vposn.
* End of CHANGE:INC0236212:NPALLA:27-Mar-2019:ED1K909876
      DATA(li_veda_temp) = li_veda[].
      DELETE li_veda_temp WHERE vposn IS INITIAL.
      SORT li_veda_temp BY vbeln vposn.
      READ TABLE li_veda_temp INTO lst_veda INDEX 1.
      IF lst_veda IS INITIAL.
        READ TABLE li_veda INTO lst_veda INDEX 1.
      ENDIF.
* End of CHANGE:INC0215390:SGUDA:18-OCT-2018:ED1K908766
      DATA(lv_year1) = lst_veda-vbegdat+0(4).

      SELECT spras,
             vlaufk,
             bezei " Description
        FROM tvlzt " Validity Period Category: Texts
        INTO TABLE @DATA(li_tvlzt)
        FOR ALL ENTRIES IN @li_veda
        WHERE spras = @v_langu
        AND vlaufk = @li_veda-vlaufk.

    ENDIF. " IF sy-subrc = 0
*      AND   vposn = @li_vbap_temp-posnr.

    DATA: lst_vbap_temp LIKE LINE OF li_vbap_temp.
    READ TABLE li_vbap_temp INTO lst_vbap_temp INDEX 1.
    IF sy-subrc = 0.
      v_psb = lst_vbap_temp-kvgr1.
    ENDIF. " IF sy-subrc = 0
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
*  Fetch media values from MARA
    SELECT matnr " Material Number
           mtart " Material Type
           volum " Volume
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
           ismhierarchlevl
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
           ismsubtitle1 " Subtitle 1
           ismsubtitle2 " Subtitle 2
           ismsubtitle3 " Subtitle 3
           ismmediatype " Media Type
           ismnrinyear  " Issue Number (in Year Number)
           ismyearnr    " Media issue year number
           ismcopynr    " Copy Number of Media Issue
      FROM mara         " General Material Data
      INTO TABLE i_mara
      FOR ALL ENTRIES IN li_vbap
      WHERE matnr EQ li_vbap-matnr.
    IF sy-subrc EQ 0.
      SORT i_mara BY matnr.
*-----------Material Descriptions------------------------------------*
      SELECT matnr "Material Number
             spras "Language Key
             maktx "Material Description (Short Text)
        FROM makt  " Material Descriptions
        INTO TABLE fp_i_makt
        FOR ALL ENTRIES IN i_mara
        WHERE matnr EQ i_mara-matnr.
      IF sy-subrc EQ 0.
        SORT fp_i_makt BY matnr spras.
      ENDIF. " IF sy-subrc EQ 0

*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
      DATA(li_mara_temp2) = i_mara[].
      DELETE li_mara_temp2 WHERE ismhierarchlevl NE lc_hier2.

      IF li_mara_temp2 IS NOT INITIAL. " for level 2 product
        SELECT med_prod,
               mpg_lfdnr,
               matnr,
               ismpubldate,
               ismcopynr , " Copy Number of Media Issue
               ismnrinyear, " Issue Number (in Year Number)
***         BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
               ismyearnr   " Media issue year number
***         EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
          FROM jptmg0      " IS-M: Media Product Issue Sequence
          INTO TABLE @DATA(li_jptmg0_2)
          FOR ALL ENTRIES IN @li_mara_temp2
          WHERE med_prod = @li_mara_temp2-matnr.
        IF sy-subrc = 0.
***       BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
*          SORT li_jptmg0_2 BY ismpubldate.
          SORT li_jptmg0_2 BY med_prod ismpubldate.
***       EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973

***       BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
*          DELETE li_jptmg0_2 WHERE ismpubldate+0(4) NE lv_year1.
*          SORT li_jptmg0_2 BY med_prod mpg_lfdnr.
*
***         To get start volume & issue
*          DATA(li_jptmg) = li_jptmg0_2[].
*          DELETE ADJACENT DUPLICATES FROM li_jptmg COMPARING med_prod.
*
****         BOC by MODUTTA on 09/02/18 for CR# XXX
*          LOOP AT li_mara_temp2 INTO DATA(lst_mara_temp2).
*            READ TABLE li_jptmg0_2 INTO DATA(lst_jptmg) WITH KEY med_prod = lst_mara_temp2-matnr
*                                                                  BINARY SEARCH.
*            IF sy-subrc EQ 0.
*              DATA(lv_tabix) = sy-tabix.
*              LOOP AT li_jptmg0_2 INTO DATA(lst_jptmg0_2) FROM lv_tabix.
*                IF lst_jptmg0_2-med_prod <> lst_mara_temp2-matnr.
*                  EXIT.
*                ENDIF. " IF lst_jptmg0_2-med_prod <> lst_mara_temp2-matnr
***                Count Number of Issue
*                lst_iss_vol2-noi = lst_iss_vol2-noi + 1.
*              ENDLOOP. " LOOP AT li_jptmg0_2 INTO DATA(lst_jptmg0_2) FROM lv_tabix
*
*              READ TABLE li_jptmg WITH KEY med_prod = lst_jptmg-med_prod TRANSPORTING NO FIELDS.
*              IF sy-subrc EQ 0.
***                Material
*                lst_iss_vol2-matnr = lst_mara_temp2-matnr.
*
***                Start Volume
*                lst_iss_vol2-stvol = lst_jptmg-ismcopynr.
*
***                Start Issue
*                lst_iss_vol2-stiss = lst_jptmg-ismnrinyear.
*
*                APPEND lst_iss_vol2 TO li_iss_vol2.
*                CLEAR lst_iss_vol2.
*              ENDIF. " IF sy-subrc EQ 0
*            ENDIF. " IF sy-subrc EQ 0
*            CLEAR: lst_jptmg,lv_tabix,lst_mara_temp2.
*          ENDLOOP. " LOOP AT li_mara_temp2 INTO DATA(lst_mara_temp2)
***         EOC by MODUTTA on 09/02/18 for CR# XXX
***       EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF li_mara_temp2 IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0

* Fetch ID codes of material from JPTIDCDASSIGN table
    SELECT matnr         " Material Number
           idcodetype    " Type of Identification Code
           identcode     " Identification Code
      FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
      INTO TABLE i_jptidcdassign
      FOR ALL ENTRIES IN li_vbap
      WHERE matnr      EQ li_vbap-matnr
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*        AND idcodetype EQ lc_journal.
        AND ( idcodetype EQ v_idcodetype_1
            OR idcodetype EQ v_idcodetype_2 ).
*** EOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
    IF sy-subrc EQ 0.
      SORT i_jptidcdassign BY matnr.
    ENDIF. " IF sy-subrc EQ 0
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

*Begin of change by MODUTTA on 08-Aug-2017 CR_408 #TR: ED2K907591
    SORT li_vbap BY bukrs_vf.
    DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING bukrs_vf.
    DELETE li_vbap WHERE bukrs_vf IS INITIAL.
    CLEAR lst_vbap.
    READ TABLE li_vbap INTO lst_vbap INDEX 1.
    IF sy-subrc EQ 0.
      st_header-company_code = lst_vbap-bukrs_vf. "Added by MODUTTA on 14/11/2017 for Company name
      st_header-document_type = lst_vbap-auart. "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
    ENDIF. " IF sy-subrc EQ 0
**  BOC by MODUTTA on 31/01/18 on CR# 743
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = c_st
        language                = v_langu
        name                    = lc_tax_text
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
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_lines
        IMPORTING
          ev_text_string = v_text_tax.
      IF sy-subrc EQ 0.
        CONDENSE v_text_tax.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 31/01/18 on CR# 743

    IF fp_i_vbap IS NOT INITIAL.
      CLEAR li_vbap.
      li_vbap[] = fp_i_vbap.
      SORT li_vbap BY vbeln bukrs_vf.
      DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING vbeln bukrs_vf.
      SELECT document,
             doc_line_number,
             buyer_reg,
             seller_reg      " Seller VAT Registration Number
        FROM /idt/d_tax_data " Tax Data
        INTO TABLE @i_tax_data
        FOR ALL ENTRIES IN @li_vbap
        WHERE company_code = @li_vbap-bukrs_vf
        AND   fiscal_year = @lc_gjahr
        AND   document_type = @lc_doc_type
        AND   document = @li_vbap-vbeln.
      IF sy-subrc EQ 0.
        SORT i_tax_data BY document doc_line_number.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF fp_i_vbap IS NOT INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
*--------------No logic needed hardcoded tax cr666-------------------*
  v_tax = text-002.
*--------------------------------------------------------------------*
*END of change by MODUTTA on 08-Aug-2017 CR_408 #TR: ED2K907591

*Fetch data from VBKD and VBFA
  SELECT   p~vbeln             " Sales and Distribution Document Number
           p~posnr             " Item number of the SD document
           p~parvw             " Partner Function
           p~kunnr             " Customer Number
           p~adrnr             " Address
           p~land1             " Country Key
           h~vbelv             " Preceding sales and distribution document
           h~posnv             " Preceding item of an SD document
           h~posnn             " Subsequent item of an SD document
           h~vbtyp_n           " Document category of subsequent document
           h~vbtyp_v           " Document category of preceding SD document
           m~posnr AS line_num "Line item of VBKD table
*** BOC BY SAYANDAS on 25-JAN-2018 for CR-XXX
           m~zterm
*** EOC BY SAYANDAS on 25-JAN-2018 for CR-XXX
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
           m~zlsch
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
           m~bstkd " Customer purchase order number
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
           m~bsark "Customer purchase order type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
           m~ihrez " Your Reference   "Added by MODUTTA on 04/10/2017 for Sub Ref Id#
      FROM vbpa AS p
      LEFT OUTER JOIN vbfa AS h ON
      p~vbeln EQ h~vbeln
     LEFT OUTER JOIN vbkd AS m ON
      p~vbeln EQ m~vbeln
      INTO TABLE fp_i_vbpa
  WHERE p~vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
*BOC by MODUTTA on 10/04/17 for Sub ref Id
    DATA(li_vbpa) = fp_i_vbpa[].
    SORT li_vbpa BY vbeln line_num.
    DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING vbeln line_num.
*** BOC BY SAYANDAS on 25-JAN-2018 for CR-XXX
    READ TABLE li_vbpa INTO DATA(lst_vbpa1) WITH KEY line_num = lc_posnr.
    IF sy-subrc = 0.
**** Fetch Data from TVZBT Table
      SELECT SINGLE vtext " Description of terms of payment
        INTO lv_pay_term
        FROM tvzbt        " Customers: Terms of Payment Texts
        WHERE spras EQ v_langu
        AND zterm EQ lst_vbpa1-zterm.
      IF sy-subrc = 0.
        fp_st_header-pay_terms = lv_pay_term.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc = 0
*** EOC BY SAYANDAS on 25-JAN-2018 for CR-XXX
*EOC by MODUTTA on 10/04/17 for Sub ref Id
    SORT fp_i_vbpa BY vbeln parvw.
  ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
*    Populate header data
*--------------------------------------------------------------------*

*Population of Date field.
*-------FM to change the date format to DD_MMM_YYYY------------------*
  CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
    EXPORTING
      idate                         = sy-datum
    IMPORTING
      day                           = lv_day
      month                         = lv_month_c2
      year                          = lv_year
      ltext                         = lv_month
    EXCEPTIONS
      input_date_is_initial         = 1
      text_for_month_not_maintained = 2
      OTHERS                        = 3.
  IF sy-subrc = 0.
    lv_month_c3 = lv_month(3).
    CONCATENATE lv_day lv_month_c3 lv_year INTO lv_datum SEPARATED BY lc_hyphen.
    fp_st_header-date_rec = lv_datum.
  ENDIF. " IF sy-subrc = 0

*Begin of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
* BOC by <HIPATEL><INC0193984><05/15/2018>
* Fetch values from constant table
*  SELECT  devid,     " Development ID
*          param1,    " ABAP: Name of Variant Variable
*          param2,    " ABAP: Name of Variant Variable
*          srno,      " ABAP: Current selection number
*          sign,      " ABAP: ID: I/E (include/exclude values)
*          opti,      " ABAP: Selection option (EQ/BT/CP/..)
*          low,       " Lower Value of Selection Condition
*          high,      " Upper Value of Selection Condition
*          activate   " Activation indicator for constant
*    INTO TABLE @DATA(li_constant)
*    FROM zcaconstant " Wiley Application Constant Table
*    WHERE devid EQ @lc_devid
*      AND activate EQ @abap_true.
*  IF sy-subrc EQ 0.
*    SORT li_constant BY devid param1.
*  endif.
* EOC by <HIPATEL><INC0193984><05/15/2018>
*End of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
*------------------------------------------------------------------------*
*Read the local internal table to fetch the customer number,
*address number and country key by passing Partner Function
*as RE because for Bill-To-Party if we pass BP it has been
*converted to RE. So RE has been used to populate Bill-To-Party address
*------------------------------------------------------------------------*
  CLEAR lst_vbpa.
  READ TABLE fp_i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                                parvw = lc_re
                                       BINARY SEARCH.
  IF sy-subrc IS INITIAL.
*Populate PO Number
    fp_st_header-po_num = lst_vbpa-bstkd.
*Populate address table
    fp_st_address-kunnr_bp = lst_vbpa-kunnr. "Customer Number
    fp_st_address-adrnr_bp = lst_vbpa-adrnr. "Address Number
    fp_st_address-land1_bp = lst_vbpa-land1. "Country key

*Begin of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
*Start insert by <HIPATEL> <INC0193984> <ED1K907285> <05/15/2018>
*    if fp_st_address-land1_bp = lc_jp.       "For Japan use 'US' for Add
*      READ TABLE li_constant INTO data(lst_constant) with param1 = lc_country.
*      IF sy-subrc = 0.
*        fp_st_address-land1_bp = lst_constant-low.
*      ENDIF.                                 " IF lst_constant-param1 EQ lc_country
*    endif.
*End insert by <HIPATEL> <INC0193984> <ED1K907285> <05/15/2018>
*End of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
  ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
*Read the local internal table to fetch the customer number,
*address number and country key by passing Partner Function as WE
*--------------------------------------------------------------------*
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
  lst_vbeln-vbeln = fp_st_vbco3-vbeln.
  CALL FUNCTION 'ZQTC_FF_DETERMINE'
    EXPORTING
      im_vbak          = lst_vbeln
*     IM_VBAP          =
*     im_flag          = space
    IMPORTING
      ex_ff_flag       = lv_ff_flag
    CHANGING
      ch_vbpa          = lt_vbpa_ff
      ch_multiple_ship = lv_multiple.
  IF lt_vbpa_ff[] IS NOT INITIAL.
    DATA(li_vbpa_temp_ff) = lt_vbpa_ff[].
    DELETE li_vbpa_temp_ff WHERE parvw NE lc_ff.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_temp_ff COMPARING adrnr.
    DATA(lv_count_vbpa_ff) = lines( li_vbpa_temp_ff ).
    IF  lv_count_vbpa_ff > 1.
      fp_st_address-multiple_shipto = abap_true.
    ELSE.
      CLEAR fp_st_address-multiple_shipto.
      READ TABLE li_vbpa_temp_ff INTO DATA(lst_fright_forwarder)  INDEX 1.
      fp_st_address-kunnr_we = lst_fright_forwarder-kunnr. "Customer Number
      fp_st_address-adrnr_we = lst_fright_forwarder-adrnr. "Address Number
      fp_st_address-land1_we = lst_fright_forwarder-land1. "Country key
    ENDIF. " IF lv_count_vbpa > 1
  ENDIF.
  IF lv_multiple IS NOT INITIAL.
    fp_st_address-multiple_shipto = abap_true.
  ENDIF.
  IF  ( fp_st_address-multiple_shipto IS INITIAL
        AND fp_st_address-adrnr_we IS INITIAL ).
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
    CLEAR: lst_vbpa.
    READ TABLE fp_i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                              parvw = lc_we
                                              BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      fp_st_address-kunnr_we = lst_vbpa-kunnr. "Customer Number
      fp_st_address-adrnr_we = lst_vbpa-adrnr. "Address Number
      fp_st_address-land1_we = lst_vbpa-land1. "Country key

*Begin of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
*Start insert by <HIPATEL> <INC0193984> <ED1K907285> <05/15/2018>
*    IF fp_st_address-land1_we = lc_jp.       "For Japan use 'US' for Add
*      CLEAR lst_constant.
*      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_country.
*      IF sy-subrc = 0.
*        fp_st_address-land1_we = lst_constant-low.
*      ENDIF. " IF lst_constant-param1 EQ lc_country
*    ENDIF.
*End insert by <HIPATEL> <INC0193984> <ED1K907285> <05/15/2018>
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918763
*End of Comment by MODUTTA:INC0195504:18th-May-2018:TR# ED1K907385
  SET COUNTRY fp_st_address-land1_bp.

*******BOC by MODUTTA on 12/03/2018
  IF st_address-adrnr_bp IS NOT INITIAL.
    SELECT deflt_comm " Communication Method (Key) (Business Address Services)
      FROM adrc       " Addresses (Business Address Services)
      INTO @DATA(lv_comm_method)
      UP TO 1 ROWS
      WHERE  addrnumber EQ @st_address-adrnr_bp.
    ENDSELECT.
    IF sy-subrc EQ 0.
      v_comm_meth = lv_comm_method.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF st_address-adrnr_bp IS NOT INITIAL
*******EOC by by MODUTTA on 12/03/2018

  IF fp_i_vbap IS NOT INITIAL.
    READ TABLE fp_i_vbap INTO lst_vbap INDEX 1.
    IF sy-subrc EQ 0.
*      lst_komk-belnr = lst_vbap-vbeln.
*      lst_komk-knumv = lst_vbap-knumv.
****TAX Description for BOM
      SELECT knumv " Number of the document condition
             kposn " Condition item number
             stunr " Step number
             zaehk " Condition counter
             kappl " Application
             kawrt " Condition base value
             kbetr " Rate (condition amount or percentage)
             waers " Currency Key
             koaid " Condition class
        FROM konv  " Conditions (Transaction Data)
        INTO TABLE li_tkomv
        WHERE knumv EQ lst_vbap-knumv
        AND kinak = ''.
      IF li_tkomv IS NOT INITIAL.
*       DELETE li_tkomv WHERE koaid NE 'D' OR
*                             kappl NE 'TX'.
        DELETE li_tkomv WHERE koaid NE 'D'.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
        DELETE li_tkomv WHERE kawrt IS INITIAL.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
        SORT li_tkomv BY knumv kposn. ""CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
      ENDIF. " IF li_tkomv IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0

    li_vbap_tmp[] = fp_i_vbap[].
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
    li_vbap_tmp1[] = fp_i_vbap[].
    li_vbap_tmp2[] = fp_i_vbap[].
    SORT li_vbap_tmp2 BY posnr DESCENDING.
    DELETE li_vbap_tmp2 WHERE uepos IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp2 COMPARING uepos.
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
    SORT li_vbap_tmp BY uepos.
    DELETE li_vbap_tmp WHERE uepos IS INITIAL.

    DATA(li_tax_buyer) = i_tax_data[].
    DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING buyer_reg.
    DATA(lv_lines) = lines( li_tax_buyer ).
    IF lv_lines = 1.
      READ TABLE li_tax_buyer INTO DATA(lst_tax_data) INDEX 1.
      IF sy-subrc EQ 0.
*****          Buyer Registration Number
        st_header-buyer_reg = lst_tax_data-buyer_reg.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_lines = 1

    DATA(li_tax_seller) = i_tax_data[].
    SORT li_tax_seller BY seller_reg.
    DELETE li_tax_seller WHERE seller_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_tax_seller COMPARING seller_reg.
    SORT li_tax_seller BY document doc_line_number.
***    BOC by MODUTTA on 05/02/2018 for CR# 743
    DATA(li_vbap_tax) = fp_i_vbap[].
    DATA(li_vbpa_za) = i_vbpa[].
***    Delete all the header times where parvw = 'ZA'
    DELETE li_vbpa_za WHERE parvw NE lc_za.
***     EOC by MODUTTA on 05/02/2018 for CR#743
***     BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
    DATA: lst_jptmg0_2 LIKE LINE OF li_jptmg0_2.
    DATA: lv_tabix LIKE sy-tabix.
    DATA: lv_tabix2 LIKE sy-tabix.
***     EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
* Begin of Change:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
    IF st_header-company_code IS NOT INITIAL.
*   Fetch Company Code Details
      SELECT SINGLE land1 "Country Key
        FROM t001 " Company Codes
        INTO st_header-comp_code_country
       WHERE bukrs EQ st_header-company_code.
    ENDIF.
* End of Change:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
    LOOP AT fp_i_vbap INTO lst_vbap.
* Begin of CHANGE:INC0211562:SGUDA:20-SEP-2018:ED1K908507
      lv_tabix = sy-tabix.
* End of CHANGE:INC0211562:SGUDA:20-SEP-2018:ED1K908507
***   BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
* Begin of CHANGE:OTCM-49271:SGUDA:10-Jan-2022:ED2K925516
      DATA:lv_flag_issues TYPE abap_bool.
      CLEAR lv_flag_issues.
* End of CHANGE:OTCM-49271:SGUDA:10-Jan-2022:ED2K925516
      READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                                vposn = lst_vbap-posnr.
* Begin of CHANGE:OTCM-49271:SGUDA:10-Jan-2022:ED2K925516
      IF sy-subrc NE 0.
        READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln.
        IF sy-subrc IS INITIAL.
          lv_flag_issues = abap_true.
        ENDIF.
      ELSE.
        lv_flag_issues = abap_true.
      ENDIF.
*      IF sy-subrc IS INITIAL.
      IF lv_flag_issues = abap_true.
* End of CHANGE:OTCM-49271:SGUDA:10-Jan-2022:ED2K925516
        CLEAR: lst_iss_vol2.
        READ TABLE li_jptmg0_2 TRANSPORTING NO FIELDS WITH KEY med_prod = lst_vbap-matnr.
        IF sy-subrc IS INITIAL.
          lv_tabix2 = sy-tabix.
          LOOP AT li_jptmg0_2 INTO lst_jptmg0_2 FROM lv_tabix2.
            IF lst_jptmg0_2-med_prod <> lst_vbap-matnr.
              EXIT.
            ENDIF.
            IF lst_jptmg0_2-ismpubldate GT lst_veda-venddat.
              EXIT.
            ENDIF.
            IF lst_jptmg0_2-ismpubldate BETWEEN lst_veda-vbegdat AND lst_veda-venddat.
              IF lst_iss_vol2 IS INITIAL.
**              Material
                lst_iss_vol2-matnr = lst_vbap-matnr.
**              Year
                lst_iss_vol2-year  = lst_jptmg0_2-ismyearnr. "++
**              Start Volume
                lst_iss_vol2-stvol = lst_jptmg0_2-ismcopynr.
**              Start Issue  " First Issue of the Contract Begin Date
                lst_iss_vol2-stiss = lst_jptmg0_2-ismnrinyear.
              ENDIF.
**            Number of Issues
              lst_iss_vol2-noi = lst_iss_vol2-noi + 1.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
***   EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      READ TABLE li_vbpa INTO DATA(lst_vbpa_f044) WITH KEY vbeln = lst_vbap-vbeln
                                                           line_num = lst_vbap-posnr.
      IF sy-subrc = 0.
        v_zlsch_f044  = lst_vbpa_f044-zlsch.
*** BOC BY SAYANDAS   on 18-JULY-2018
*       v_ihrez_f044  = lst_vbpa_f044-ihrez.
        v_ihrez_f044  = st_vbco3-vbeln.
*** EOC BY SAYANDAS   on 18-JULY-2018
      ELSE. " ELSE -> IF sy-subrc = 0
        READ TABLE li_vbpa INTO lst_vbpa_f044 WITH KEY vbeln = lst_vbap-vbeln
                                                       line_num = space.
        IF sy-subrc = 0.
          v_zlsch_f044  = lst_vbpa_f044-zlsch.
*** BOC BY SAYANDAS   on 18-JULY-2018
*         v_ihrez_f044  = lst_vbpa_f044-ihrez.
          v_ihrez_f044  = st_vbco3-vbeln.
*** EOC BY SAYANDAS  on 18-July-2018
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IF lst_vbpa_f044-bsark IS NOT INITIAL AND lst_vbpa_f044-bsark IN r_po_type.
        v_po_type = abap_true.
      ELSE.
        CLEAR v_po_type.
      ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
* Begin of CHANGE:INC0211562:SGUDA:20-SEP-2018:ED1K908507
*** BOC BY SAYANDAS
*      lv_tabix = sy-tabix.
*** EOC BY SAYANDAS
* End of CHANGE:INC0211562:SGUDA:20-SEP-2018:ED1K908507
      IF lst_vbap-uepos IS INITIAL.
        lst_final-item = lv_posnr = lst_vbap-posnr.
        IF sy-tabix GT 1.
          CLEAR: lst_final.
          APPEND lst_final TO fp_i_final.
        ENDIF. " IF sy-tabix GT 1
      ELSE. " ELSE -> IF lst_vbap-uepos IS INITIAL
        lst_final-item = lv_posnr.
      ENDIF. " IF lst_vbap-uepos IS INITIAL

**Populate standard text
      IF lv_waerk IS INITIAL
        AND lv_bukrs_vf IS INITIAL. "For first time of loop execution this variables will be blank
        "and we will populate the header record i.e; vbak records
        lv_waerk    = lst_vbap-waerk.
        lv_bukrs_vf = lst_vbap-bukrs_vf.
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
        v_waerk_f044           = lv_waerk.
        v_vkorg_f044           = lv_bukrs_vf.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
        v_kvgr1_f044   = lst_vbap-kvgr1.  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
        fp_st_calc-waerk = lv_waerk.
      ENDIF. " IF lv_waerk IS INITIAL

      IF lv_kunnr_za IS INITIAL. "(++)MODUTTA on 16/08/2017
        CLEAR lst_vbpa.
        READ TABLE li_vbpa_za INTO lst_vbpa WITH KEY vbeln = lst_vbap-vbeln
                                                     parvw = lc_za
                                                     BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          lv_kunnr_za = lst_vbpa-kunnr.
          v_partner_za = abap_true.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF lv_kunnr_za IS INITIAL

**Check for UK company code
      IF lv_tabix = 1
        AND lv_waerk IS NOT INITIAL
        AND lv_bukrs_vf IS NOT INITIAL.
        IF lv_kunnr_za IS INITIAL.
          PERFORM f_populate_std_text USING     lv_waerk
                                                lv_bukrs_vf
                                                lc_tbt
                                      CHANGING  v_remit_to_tbt_uk
                                                v_banking1_tbt_uk
                                                v_cust_serv_tbt_uk
                                                v_email_tbt_uk
                                                v_credit_tbt_uk
                                                v_footer
                                                v_comp_name
                                                v_mis_msg
                                                v_payment.
        ENDIF. " IF lv_kunnr_za IS INITIAL

*          PERFORM f_populate_std_text USING     lv_waerk
*                                                lv_bukrs_vf
*                                                lc_tbt
*                                      CHANGING  v_remit_to_tbt_usa
*                                                v_banking1_tbt_usa
*                                                v_cust_serv_tbt_usa
*                                                v_email_tbt_usa
*                                                v_credit_tbt_usa
**                                                   v_footer_tbt_usa.
*                                                 v_footer_tbt
*                                                 v_comp_name.
        IF v_scc IS NOT INITIAL
          AND lv_kunnr_za IS NOT INITIAL. "Society by Contract
          PERFORM f_populate_std_text USING    lv_waerk
                                               lv_bukrs_vf
                                               lc_scc
                                     CHANGING  v_remit_to_scc
                                               v_banking1_scc
                                               v_cust_serv_scc
                                               v_email_scc
                                               v_credit_scc
                                               v_footer
                                               v_comp_name
                                               v_mis_msg
                                               v_payment_scc.
        ENDIF. " IF v_scc IS NOT INITIAL

        IF v_scm IS NOT INITIAL
          AND lv_kunnr_za IS NOT INITIAL. "Society by Member
          PERFORM f_populate_std_text USING    lv_waerk
                                                lv_bukrs_vf
                                                lc_scm
                                      CHANGING  v_remit_to_scm
                                                v_banking1_scm
                                                v_cust_serv_scm
                                                v_email_scm
                                                v_credit_scc
                                                v_footer
                                                v_comp_name
                                                v_mis_msg
                                                v_payment_scm.
        ENDIF. " IF v_scm IS NOT INITIAL
      ENDIF. " IF lv_tabix = 1
********Populate Footer1
      CONCATENATE lc_txtname_part1
                  lc_footer1
           INTO fp_v_footer1.
      CONDENSE fp_v_footer1 NO-GAPS.

********Populate Footer2
      CONCATENATE lc_txtname_part1
                  lc_footer2
           INTO fp_v_footer2.
      CONDENSE fp_v_footer2 NO-GAPS.

*********Populate Detach
*        CONCATENATE lc_txtname_part1
*                  lc_detach
*             INTO fp_v_detach.
*
*        CONDENSE fp_v_detach NO-GAPS.

*******Populate order line
      CONCATENATE lc_txtname_part1
                  lc_order
             INTO fp_v_order.
      CONDENSE fp_v_order NO-GAPS.

****Populate Customer contacts
      CONCATENATE lc_txtname_part1
                  lc_cust
        INTO fp_v_customer.
      CONDENSE fp_v_customer NO-GAPS.

********Concatenate vbeln and posnr to get the text name
      CONCATENATE lst_vbap-vbeln
                  lst_vbap-posnr
                  INTO lv_text_name.
      CONDENSE lv_text_name NO-GAPS.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_id
          language                = nast-spras
          name                    = lv_text_name
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
        READ TABLE li_lines INTO lst_lines INDEX 1.
        IF sy-subrc IS INITIAL.
*******Populate Society Text
          fp_st_header-society_text = lst_lines-tdline.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc EQ 0
*      ENDIF. " IF lv_tabix = 1

***********Population of final table

******Populate Subscription reference
      st_header-sub_reference = lst_vbak-vbeln.

*********Populate Quantity
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
*      IF lst_vbap-uepos IS INITIAL.
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
      READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap-matnr
                                                 BINARY SEARCH.
      IF sy-subrc EQ 0.

        DATA(lst_final1) = lst_final.

**********Populate product description
        CLEAR lst_final1.
****EOC by MODUTTA on 06/10/2017 for material description JIRA# 4591
        IF lst_mara-mtart IN r_mtart_med_issue. "Media Issues
          READ TABLE fp_i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>)
               WITH KEY matnr = lst_vbap-matnr
                        spras = v_langu "Customer Language
               BINARY SEARCH.
          IF sy-subrc NE 0.
            READ TABLE fp_i_makt ASSIGNING <lst_makt>
                 WITH KEY matnr = lst_vbap-matnr
                          spras = c_deflt_langu "Default Language
                 BINARY SEARCH.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*              lst_final1-prod_des = <lst_makt>-maktx. "Material Description
            CLEAR:lst_jptidcdassign1.
            READ TABLE i_jptidcdassign INTO lst_jptidcdassign1 WITH KEY matnr =  lst_vbap-matnr
                                                                          idcodetype = v_idcodetype_2
                                                                          BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              lv_identcode_zjcd = lst_jptidcdassign1-identcode.
              CONCATENATE lv_identcode_zjcd <lst_makt>-maktx INTO lst_final1-prod_des SEPARATED BY lc_hyphen.
              CONDENSE lst_final1-prod_des.
            ELSE. " ELSE -> IF sy-subrc IS INITIAL
              lst_final1-prod_des = <lst_makt>-maktx. "Material Description
            ENDIF. " IF sy-subrc IS INITIAL
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
          ENDIF. " IF sy-subrc EQ 0
        ELSE. " ELSE -> IF lst_mara-mtart IN r_mtart_med_issue
*         Fetch Material Basic Text
          CLEAR: li_lines,
                 lv_mat_text.
          lv_tdname = lst_mara-matnr.
*         Using Customer Language
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = c_id_grun "Text ID: GRUN
              language                = v_langu   "Language Key
              name                    = lv_tdname "Text Name: Material Number
              object                  = c_obj_mat "Text Object: MATERIAL
            TABLES
              lines                   = li_lines  "Text Lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc NE 0.
*           Using Default Language (English)
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                      = c_id_grun     "Text ID: GRUN
                language                = c_deflt_langu "Language Key
                name                    = lv_tdname     "Text Name: Material Number
                object                  = c_obj_mat     "Text Object: MATERIAL
              TABLES
                lines                   = li_lines      "Text Lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            DELETE li_lines WHERE tdline IS INITIAL.
*           Convert ITF text into a string
            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
              EXPORTING
                it_tline       = li_lines
              IMPORTING
                ev_text_string = lv_mat_text.
            IF sy-subrc EQ 0.
              READ TABLE i_jptidcdassign INTO lst_jptidcdassign1 WITH KEY matnr = lst_vbap-matnr
                                                                            idcodetype = v_idcodetype_2
                                                                            BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                lv_identcode_zjcd = lst_jptidcdassign1-identcode.
                CONCATENATE lv_identcode_zjcd lv_mat_text INTO lst_final1-prod_des SEPARATED BY lc_hyphen.
                CONDENSE lst_final1-prod_des.
              ELSE. " ELSE -> IF sy-subrc IS INITIAL
                lst_final1-prod_des = lv_mat_text. "Material Description
              ENDIF. " IF sy-subrc IS INITIAL
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_mara-mtart IN r_mtart_med_issue

*       Begin of DEL:INC0198938:WROY:12-June-2018:ED1K907672
*       IF lst_final1 IS NOT INITIAL.
*         APPEND lst_final1 TO fp_i_final.
*       ENDIF. " IF lst_final1 IS NOT INITIAL
*       End   of DEL:INC0198938:WROY:12-June-2018:ED1K907672
*--------------------------------------------------------------------*

        CLEAR: lv_flag_di,
               lv_flag_ph.
        IF lst_mara-ismmediatype EQ 'DI'.
          lv_flag_di = abap_true.
        ELSEIF lst_mara-ismmediatype EQ 'PH'.
          lv_flag_ph = abap_true.
        ENDIF. " IF lst_mara-ismmediatype EQ 'DI'

        lst_final-ismmediatype = lst_mara-ismmediatype.
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
        IF lst_vbap-uepos IS INITIAL.
          DATA(li_all_media_product) =  i_vbap[].
          CLEAR: lst_digital,lst_print,li_print_media_product[],li_digital_media_product[].
          LOOP AT li_all_media_product INTO DATA(lst_all_media) WHERE uepos = lst_vbap-posnr.
            IF lst_all_media-mvgr4 IN r_print_product.
              MOVE-CORRESPONDING lst_all_media TO lst_print.
              APPEND lst_print TO li_print_media_product.
              CLEAR lst_print.
            ENDIF.
            IF lst_all_media-mvgr4 IN r_digital_product.
              MOVE-CORRESPONDING lst_all_media TO lst_digital.
              APPEND lst_digital TO li_digital_media_product.
              CLEAR lst_digital.
            ENDIF.
            CLEAR lst_all_media.
          ENDLOOP.
          IF li_print_media_product[] IS INITIAL AND li_digital_media_product[] IS NOT INITIAL.
            lv_flag_di = abap_true.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS INITIAL.
            lv_flag_ph = abap_true.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS NOT INITIAL.
            CLEAR :lv_flag_ph,lv_flag_di.
          ENDIF.
        ENDIF.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
        CLEAR : lv_name,
                lv_subscription_typ.

        IF lv_flag_di EQ abap_true.
          lv_name = lc_digt_subsc.
*       Subroutine to get subscription type text (Digital subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING lv_subscription_typ.

*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
          lv_name_issn = lc_digissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX

        ELSEIF lv_flag_ph EQ abap_true.
          lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING lv_subscription_typ.
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
          lv_name_issn = lc_pntissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
        ELSE. " ELSE -> IF lv_flag_di EQ abap_true
          lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING lv_subscription_typ.

          lv_name_issn = lc_combissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
        ENDIF. " IF lv_flag_di EQ abap_true
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
        IF lst_vbap-uepos IS INITIAL.
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
          lst_final-prod_des = lv_subscription_typ.
        ENDIF. " IF lst_vbap-uepos IS INITIAL
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
      ENDIF. " IF sy-subrc EQ 0
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
*      ENDIF. " IF lst_vbap-uepos IS INITIAL
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
***BOC by MODUTTA for CR_743
      CLEAR lst_vbap_temp.
**    populate text TAX
      lst_tax_item-media_type = v_text_tax.
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
      lst_tax_item-subs_type  = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911184

***   Populate percentage
      READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbap-posnr.
*     Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
      IF sy-subrc NE 0.
        CLEAR: lst_komv.
      ELSE. " ELSE -> IF sy-subrc NE 0
*     End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
*     Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911370
*****     Populate taxable amount
*     lst_tax_item-taxable_amt = lst_komv-kawrt.
*
*     IF sy-subrc IS INITIAL.
*     End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911370
        DATA(lv_index) = sy-tabix.
        LOOP AT li_tkomv INTO lst_komv FROM lv_index.
          IF lst_komv-kposn NE lst_vbap-posnr.
            EXIT.
          ENDIF. " IF lst_komv-kposn NE lst_vbap-posnr
          lv_kbetr = lv_kbetr + lst_komv-kbetr.
*         Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
****      Populate taxable amount
          lst_tax_item-taxable_amt = lst_komv-kawrt.
*         End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911370
        ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
        lv_tax_amount = ( lv_kbetr / 10 ).
        CLEAR: lv_kbetr.
      ENDIF. " IF sy-subrc NE 0
**      Populate tax amount
      lst_tax_item-tax_amount = lst_vbap-kzwi6.

      IF lst_vbap-kzwi6 IS INITIAL.
        CLEAR lv_tax_amount.
      ENDIF. " IF lst_vbap-kzwi6 IS INITIAL

      WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
      CONCATENATE lst_tax_item-tax_percentage lc_percentage INTO lst_tax_item-tax_percentage.
      CONDENSE lst_tax_item-tax_percentage.
      CLEAR lv_tax_amount.

*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
      IF lst_tax_item-taxable_amt IS NOT INITIAL.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
        COLLECT lst_tax_item INTO li_tax_item.
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
      ENDIF. " IF lst_tax_item-taxable_amt IS NOT INITIAL
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
      CLEAR: lst_tax_item.
***EOC by MODUTTA for CR_743

***For BOM component tax calculation
      READ TABLE li_vbap_temp INTO lst_vbap_temp WITH KEY uepos = lst_vbap-posnr.
      IF sy-subrc EQ 0.
        DATA(lv_tabix_tmp) = sy-tabix.
        CLEAR lst_vbap_temp.
        LOOP AT li_vbap_temp INTO lst_vbap_temp FROM lv_tabix_tmp.
          IF lst_vbap_temp-uepos NE lst_vbap-posnr.
            EXIT.
          ENDIF. " IF lst_vbap_temp-uepos NE lst_vbap-posnr
          lv_tax_bom = lv_tax_bom + lst_vbap_temp-kzwi6.
        ENDLOOP. " LOOP AT li_vbap_temp INTO lst_vbap_temp FROM lv_tabix_tmp
        CLEAR: lst_tax_item.
      ENDIF. " IF sy-subrc EQ 0


      IF lst_vbap-uepos IS INITIAL.
********* Quantity
        IF lst_vbap-kwmeng IS NOT INITIAL.
          lv_kwmeng = lst_vbap-kwmeng.
        ELSE. " ELSE -> IF lst_vbap-kwmeng IS NOT INITIAL
          lv_kwmeng = lst_vbap-zmeng.
        ENDIF. " IF lst_vbap-kwmeng IS NOT INITIAL

        lv_meins =  lst_vbap-meins.
        lv_kwmeng_qty = trunc( lv_kwmeng ).
        lst_final-qty = lv_kwmeng_qty.
        CONDENSE lst_final-qty.
* EOC: PBANDLAPAL:11-Jan-2018:ERP-5571: ED2K909938


******** Populate Discount
        CLEAR: lv_disc_char,lv_disc.
        lv_disc = lst_vbap-kzwi5.
        WRITE lv_disc TO lv_disc_char.
        IF lst_vbap-kzwi5 LT 0.
          CONDENSE lv_disc_char. " Added by PBANDLAPAL
          lst_final-discount = lv_disc_char.

          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-discount.
        ELSEIF lst_vbap-kzwi5 EQ 0.
          lst_final-discount = lv_disc_char.
        ENDIF. " IF lst_vbap-kzwi5 LT 0
***          EOC by MODUTTA for -ve sign addition on 06/10/2017

********** Populate Unit Price
********** If lv_kwmeng have value then calculate the unit price
        IF lv_kwmeng_qty NE 0.
          lv_unit_price = lst_vbap-kzwi1 / lv_kwmeng_qty.
          lst_final-unit_price_numc = lv_unit_price.
          WRITE lv_unit_price TO lst_final-unit_price CURRENCY lv_waerk.
          CONDENSE lst_final-unit_price.
          IF lv_unit_price LT 0.
            CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
              CHANGING
                value = lst_final-unit_price.
          ENDIF. " IF lv_unit_price LT 0
        ENDIF. " IF lv_kwmeng_qty NE 0
* EOC: PBANDLAPAL:11-Jan-2018:ERP-5571: ED2K909938

***BOC by MODUTTA for CR# 743
**************Taxes
        IF lv_tax_bom IS NOT INITIAL.
          lst_vbap-kzwi6 = lv_tax_bom.
          CLEAR lv_tax_bom.
        ENDIF. " IF lv_tax_bom IS NOT INITIAL

        IF lst_vbap-kzwi6 LT 0.
          WRITE lst_vbap-kzwi6 TO lst_final-tax_amount CURRENCY lv_waerk.
          CONDENSE lst_final-tax_amount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-tax_amount.
          CONDENSE lst_final-tax_amount.
        ELSE. " ELSE -> IF lst_vbap-kzwi6 LT 0
          WRITE lst_vbap-kzwi6 TO lst_final-taxes CURRENCY lv_waerk.
          CONDENSE lst_final-taxes.
        ENDIF. " IF lst_vbap-kzwi6 LT 0
        lv_tax = lst_vbap-kzwi6 + lv_tax.
***EOC by MODUTTA for CR# 743

******   Amount
*        lv_total_amount = lst_vbap-kzwi3 + lv_tax + lv_amnt.
        CLEAR lv_amnt.
        lv_amnt = lst_vbap-kzwi3 + lst_vbap-kzwi6.
        IF lv_amnt LT 0.
          WRITE lv_amnt TO lst_final-amount CURRENCY lv_waerk.
          CONDENSE lst_final-amount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-amount.
        ELSE. " ELSE -> IF lv_amnt LT 0
          WRITE lv_amnt TO lst_final-amount CURRENCY lv_waerk.
          CONDENSE lst_final-amount.
        ENDIF. " IF lv_amnt LT 0
**    EOC by MODUTTA on 17/10/2017 for CR# 666

*       Begin of ADD:INC0198938:WROY:12-June-2018:ED1K907672
        CLEAR: lv_prod_des.
        lv_prod_des = lst_final-prod_des.
        lst_final-prod_des = lst_final1-prod_des.
*       End   of ADD:INC0198938:WROY:12-June-2018:ED1K907672
********* Amount
        IF lst_final IS NOT INITIAL.
          APPEND lst_final TO fp_i_final.
        ENDIF. " IF lst_final IS NOT INITIAL
*       Begin of ADD:INC0198938:WROY:12-June-2018:ED1K907672
        IF lv_prod_des IS NOT INITIAL.
          lst_final1-prod_des = lv_prod_des.
          APPEND lst_final1 TO fp_i_final.
        ENDIF. " IF lv_prod_des IS NOT INITIAL
*       End   of ADD:INC0198938:WROY:12-June-2018:ED1K907672
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF. " IF lst_final-prod_des+0(3) EQ v_tax

************Added by MODUTTA
****Populate Subtitle
        IF lst_final_subtitle IS NOT INITIAL.
          APPEND lst_final_subtitle TO fp_i_final.
        ENDIF. " IF lst_final_subtitle IS NOT INITIAL

*-------------------Multi-Year Subs---------------------------------*
        IF  ( nast-kschl = c_zsqt  AND st_header-document_type NOT IN r_document_type ) OR ( nast-kschl = c_zsqs ).  "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
          lv_name = lc_mlsubs.
          CLEAR: lst_final1-prod_des.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_mlsub.
          READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY vbeln = lst_vbap-vbeln
                                                         vposn = lst_vbap-posnr
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE li_tvlzt INTO DATA(lst_tvlzt1) WITH KEY spras = v_langu
                                                             vlaufk = lst_veda1-vlaufk
                                                             BINARY SEARCH.
            IF sy-subrc EQ 0
              AND lst_tvlzt1-bezei IS NOT INITIAL.
              CONCATENATE lv_mlsub lst_tvlzt1-bezei INTO lst_final1-prod_des SEPARATED BY lc_colon.
              APPEND lst_final1 TO fp_i_final.
              CLEAR lst_final1.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
        ENDIF.   "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
      ENDIF. " IF lst_vbap-uepos IS INITIAL
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
      READ TABLE li_vbap_tmp1  WITH KEY uepos = lst_vbap-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_bhf = abap_true.
      ENDIF. " IF sy-subrc = 0
      IF lv_bhf IS INITIAL.
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
********* Year
        CLEAR lst_final1.
*        lv_name = lc_year. "CR-7841:SGUDA:29-Apr-2019:ED1K910078
        lv_name = lc_cntr_start. "CR-7841:SGUDA:29-Apr-2019:ED1K910078
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_year_1.
*- Begin of Change:CR-7841:SGUDA:29-Apr-2019:ED1K910078
        lv_name = lc_cntr_end.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_cntr_end.
*- End of Change:CR-7841:SGUDA:29-Apr-2019:ED1K910078
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
* Begin of CHANGE:INC0236212:NPALLA:27-Mar-2019:ED1K909876
        CLEAR: lst_veda.
        READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                                  vposn = lst_vbap-posnr BINARY SEARCH.
        IF lst_veda-vbegdat IS INITIAL."lst_veda IS INITIAL."CR-7841:SGUDA:29-Apr-2019:ED1K910078
          READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln BINARY SEARCH.
        ENDIF.
        lv_year1 = lst_veda-vbegdat+0(4).
* End of CHANGE:INC0236212:NPALLA:27-Mar-2019:ED1K909876
*- Begin of Change:CR-7841:SGUDA:29-Apr-2019:ED1K910078
*        IF lv_year1 IS NOT INITIAL.
*          CONCATENATE lv_year_1 lc_colon INTO lv_year_2.
*          CONDENSE lv_year_2.
*          CONCATENATE lv_year_2 lv_year1 INTO lst_final1-prod_des SEPARATED BY space.
*          CONDENSE lst_final1-prod_des.
*          APPEND lst_final1 TO fp_i_final.
*          CLEAR lst_final1.
*        ENDIF. " IF lv_year1 IS NOT INITIAL
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
        IF  ( nast-kschl = c_zsqt  AND st_header-document_type NOT IN r_document_type ) OR ( nast-kschl = c_zsqs ).
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
          IF lst_veda-vbegdat IS NOT INITIAL.
            CLEAR : lv_year_2,lv_cntr_month,lv_cntr,lv_day1,lv_month1,lv_year2,lv_stext,lv_ltext.
            CONCATENATE lv_year_1 lc_colon INTO lv_year_2.
            CONDENSE lv_year_2.
            CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
              EXPORTING
                idate                         = lst_veda-vbegdat
              IMPORTING
                day                           = lv_day1
                month                         = lv_month1
                year                          = lv_year2
                stext                         = lv_stext
                ltext                         = lv_ltext
*               userdate                      =
              EXCEPTIONS
                input_date_is_initial         = 1
                text_for_month_not_maintained = 2
                OTHERS                        = 3.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
            CONCATENATE lv_day1 lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_under.
            CONDENSE lv_cntr.
            CONCATENATE lv_year_2 lv_cntr INTO lst_final1-prod_des.
            CONDENSE lst_final1-prod_des.
            APPEND lst_final1 TO fp_i_final.
            CLEAR lst_final1.
          ENDIF.
          IF lst_veda-venddat IS NOT INITIAL.
            CLEAR : lv_year_2,lv_cntr_month,lv_cntr,lv_day1,lv_month1,lv_year2,lv_stext,lv_ltext.
            CONCATENATE lv_cntr_end lc_colon INTO lv_year_2.
            CONDENSE lv_year_2.
            CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
              EXPORTING
                idate                         = lst_veda-venddat
              IMPORTING
                day                           = lv_day1
                month                         = lv_month1
                year                          = lv_year2
                stext                         = lv_stext
                ltext                         = lv_ltext
*               userdate                      =
              EXCEPTIONS
                input_date_is_initial         = 1
                text_for_month_not_maintained = 2
                OTHERS                        = 3.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
            CONCATENATE lv_day1 lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_under.
            CONDENSE lv_cntr.
            CONCATENATE lv_year_2 lv_cntr INTO lst_final1-prod_des.
            CONDENSE lst_final1-prod_des.
            APPEND lst_final1 TO fp_i_final.
            CLEAR lst_final1.
          ENDIF.
        ENDIF. "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
*- End of Change:CR-7841:SGUDA:29-Apr-2019:ED1K910078

***********************************************************************************
*** BOC by MODUTTA on 01/02/2018 for CR#_XXX
** Total of Issues, Start Volume, Start Issue
        IF lst_mara-ismhierarchlevl EQ '2'.
***       BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
*          READ TABLE li_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara-matnr.
*          IF sy-subrc EQ 0.
*            DATA(lst_issue_vol) = lst_issue_vol2.
*          ENDIF. " IF sy-subrc EQ 0
***       EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
          DATA(lst_issue_vol) = lst_iss_vol2.
        ELSEIF lst_mara-ismhierarchlevl EQ '3'.
          lst_issue_vol-stvol = lst_mara-ismcopynr.
*       BOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
*          lst_issue_vol-noi = lst_mara-ismnrinyear.
*          lst_issue_vol-stiss = '1'.
          lst_issue_vol-noi = '1'.
          lst_issue_vol-stiss = lst_mara-ismnrinyear.
*       EOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
        ENDIF. " IF lst_mara-ismhierarchlevl EQ '2'

***Start Volume
        IF lst_issue_vol IS NOT INITIAL.
*         Start Volume
          lv_name = lc_volume.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_volum.

          IF lst_issue_vol-stvol IS NOT INITIAL.
            CONCATENATE lv_volum lst_issue_vol-stvol INTO lv_issue_desc SEPARATED BY space.
            IF lst_final1-prod_des IS NOT INITIAL.
              CONCATENATE lst_final1-prod_des lc_comma lv_issue_desc INTO lst_final1-prod_des.
            ELSE. " ELSE -> IF lst_final1-prod_des IS NOT INITIAL
              lst_final1-prod_des = lv_issue_desc.
            ENDIF. " IF lst_final1-prod_des IS NOT INITIAL
            CONDENSE lst_final1-prod_des.
          ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

* Total Issues
          lv_name = lc_issue.
          CLEAR: lv_issue,lv_issue_desc.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_issue.
          IF lst_issue_vol-noi IS NOT INITIAL.
            MOVE lst_issue_vol-noi TO lv_vol.
            CONCATENATE lv_vol lv_issue INTO lv_issue_desc SEPARATED BY space.
            IF lst_final1-prod_des IS NOT INITIAL.
              CONCATENATE lst_final1-prod_des lc_comma lv_issue_desc INTO lst_final1-prod_des.
            ELSE. " ELSE -> IF lst_final1-prod_des IS NOT INITIAL
              lst_final1-prod_des = lv_issue_desc.
            ENDIF. " IF lst_final1-prod_des IS NOT INITIAL
            CONDENSE lst_final1-prod_des.
          ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL
        ENDIF. " IF lst_issue_vol IS NOT INITIAL

        IF lst_final1-prod_des IS NOT INITIAL.
          CONDENSE lst_final1-prod_des.
          APPEND lst_final1 TO fp_i_final.
          CLEAR lst_final1.
        ENDIF. " IF lst_final1-prod_des IS NOT INITIAL


*****Start Issue Number
        IF lst_issue_vol IS NOT INITIAL.
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
          IF nast-kschl = c_zsqt  AND st_header-document_type IN r_document_type.
            lv_name = lc_stiss_zsiq.
          ELSE.
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
            lv_name = lc_stiss.
          ENDIF. "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_issue.

          IF lst_issue_vol-stiss IS NOT INITIAL.
            CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_final1-prod_des SEPARATED BY space.
            CONDENSE lst_final1-prod_des.
            APPEND lst_final1 TO fp_i_final.
            CLEAR lst_final1.
          ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
        ENDIF. " IF lst_issue_vol IS NOT INITIAL


***********************************************************************************


*-------ISSN---------------------------------------------------------*

        CLEAR lst_final1.
        READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign) WITH KEY matnr = lst_vbap-matnr
                                                                         idcodetype = v_idcodetype_1 "(++ BOC by SAYANDAS for CR_XXX)
                                                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*          lv_name = lc_pntissn.
*          PERFORM f_get_text_val USING lv_name
*                                       st_header
*                              CHANGING lv_pnt_issn.
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
          IF lst_jptidcdassign-identcode IS NOT INITIAL.
            lv_identcode = lst_jptidcdassign-identcode.
*   Begin of CHANGE:CR#7507:SGUDA:21-June-2018:ED1K907763
*            CONCATENATE lv_pnt_issn lst_jptidcdassign-identcode INTO lst_final1-prod_des  SEPARATED BY lc_colonb.
            lst_final1-prod_des = lst_jptidcdassign-identcode.
*   End of CHANGE:CR#7507:SGUDA:21-June-2018:ED1K907763
            CONDENSE lst_final1-prod_des.
          ENDIF. " IF lst_jptidcdassign-identcode IS NOT INITIAL
        ENDIF. " IF sy-subrc EQ 0
*        lst_final1-prod_des = lst_vbap-arktx.
        IF lst_final1 IS NOT INITIAL.
          APPEND lst_final1 TO fp_i_final.
        ENDIF. " IF lst_final1 IS NOT INITIAL
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
      ENDIF. " IF lv_bhf IS INITIAL
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
*** BOC BY SAYANDAS on 06-MAR-2018 for BOM description
      READ TABLE li_vbap_tmp2 WITH KEY posnr = lst_vbap-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_lcf = abap_true.
      ENDIF. " IF sy-subrc = 0
      IF ( lst_vbap-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL ).
*** EOC BY SAYANDAS on 06-MAR-2018 for BOM description
*-------Sub Ref#---------------------------------------------------------*
****BOC by MODUTTA on 04/10/2017 for Sub Ref Id #
        CLEAR: lst_final1, lst_vbpa.
        READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_vbap-vbeln
                                                  line_num = lst_vbap-posnr
                                                  BINARY SEARCH.
        IF sy-subrc EQ 0 AND lst_vbpa-ihrez IS NOT INITIAL.
          lst_final1-prod_des = lst_vbpa-ihrez.
*         Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
          CLEAR: lv_sub_ref_id.
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
          IF ( r_mat_grp5[] IS NOT INITIAL AND r_output_typ[] IS NOT INITIAL ) AND
             ( lst_vbap-mvgr5 IN r_mat_grp5 AND nast-kschl IN r_output_typ ).
            PERFORM f_get_subscrption_type  USING c_membership_number
                                                  st_header
                                         CHANGING lv_sub_ref_id.
          ELSE.
            PERFORM f_get_subscrption_type USING lc_sub_ref_id
                                                 st_header
                                        CHANGING lv_sub_ref_id.
          ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
          IF lv_sub_ref_id IS NOT INITIAL.
            CONCATENATE lv_sub_ref_id
                        lst_final1-prod_des
                   INTO lst_final1-prod_des
                   SEPARATED BY space.
          ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*         End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
          APPEND lst_final1 TO fp_i_final.
        ENDIF. " IF sy-subrc EQ 0 AND lst_vbpa-ihrez IS NOT INITIAL
*      EOC by MODUTTA on 10/04/17 for Sub ref Id

*----------------------------------------------------mmukherjee b5471*

        IF st_header-buyer_reg IS INITIAL.
          CLEAR lst_tax_data.
          READ TABLE li_tax_buyer INTO lst_tax_data WITH KEY document = lst_vbap-vbeln
                                                             doc_line_number = lst_vbap-posnr
                                                             BINARY SEARCH.
          IF sy-subrc EQ 0.
            CLEAR lst_final.
            lst_final-prod_des = lst_tax_data-buyer_reg.
            IF lst_final IS NOT INITIAL.
              APPEND lst_final TO fp_i_final.
            ENDIF. " IF lst_final IS NOT INITIAL
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF st_header-buyer_reg IS INITIAL

*************BOC by MODUTTA on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
        lv_doc_line = lst_vbap-posnr.
      ENDIF. " IF ( lst_vbap-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )
      CLEAR lst_tax_data.
      READ TABLE li_tax_seller INTO lst_tax_data WITH KEY   document = lst_vbap-vbeln
                                                             doc_line_number = lst_vbap-posnr "lv_doc_line
                                                             BINARY SEARCH.
      IF sy-subrc EQ 0.
* Begin of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
        IF v_seller_reg IS INITIAL AND lst_tax_data-seller_reg IS NOT INITIAL.
          v_seller_reg = lst_tax_data-seller_reg.
        ELSEIF  v_seller_reg IS NOT INITIAL AND lst_tax_data-seller_reg IS NOT INITIAL.
          CONCATENATE lst_tax_data-seller_reg ',' v_seller_reg INTO v_seller_reg.
        ENDIF.
* End of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
*          CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.  "ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
        . "ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
* Begin of CHANGE:"CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
      ELSEIF st_address-land1_bp = st_header-comp_code_country.
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
                            WITH KEY land1 = st_address-land1_bp
                            BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg ',' v_seller_reg INTO v_seller_reg.
          ENDIF.
        ENDIF.
* End of CHANGE:"CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
      ENDIF. " IF sy-subrc EQ 0

*************EOC by MODUTTA on 08/08/2017 for CR# 408****************
*      ENDIF. " IF ( lst_vbap-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )  "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
******** Total Amount
      lv_total_amount = lv_total_amount + lv_tax.

******** Populate total tax
* BOC: PBANDLAPAL:12-Jan-2018:ERP-5571: ED2K90993
*      lv_total_tax = lv_total_tax + lst_final-taxes + lv_header_tax.
      IF lst_vbap-uepos IS INITIAL.
        lv_total_tax = lv_total_tax + lv_tax.
      ENDIF. " IF lst_vbap-uepos IS INITIAL
***       BOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
*      CLEAR: lst_final, lst_vbap, lst_vbak, lv_header_tax,lst_issue_vol,lst_issue_vol2,lv_bhf,lv_lcf.
      CLEAR: lst_final, lst_vbap, lst_vbak, lv_header_tax,lst_issue_vol,lv_bhf,lv_lcf.
***       EOC by NPALLA on 08-Apr-2019 for INC0236212:ED1K909973
    ENDLOOP. " LOOP AT fp_i_vbap INTO lst_vbap
  ENDIF. " IF fp_i_vbap IS NOT INITIAL

*******Populatopn of Sub total
  READ TABLE li_vbap INTO DATA(lst_vbak_temp) INDEX 1.
  IF sy-subrc EQ 0.
    fp_st_calc-sub_total  = lst_vbak_temp-netwr. "lv_total_amount.
  ENDIF. " IF sy-subrc EQ 0

*******Population of Taxes
  fp_st_calc-taxable = lv_tax.

*******Populate total due with the currency
  lv_total_pf = fp_st_calc-sub_total + lv_tax. "lv_total_amount + lv_total_tax.
  fp_st_calc-total_due = lv_total_pf.


***BOC by MODUTTA for CR#743
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY lv_waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY lv_waerk.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_sub_final.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR#743
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail USING fp_st_vbco3       TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing
******Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_INV'. " Name of Form Object

*** BOC BY SAYANDAS
  CONSTANTS: lc_zsqt           TYPE sna_kschl VALUE 'ZSQT', " Message type
             lc_zsqs           TYPE sna_kschl VALUE 'ZSQS', " Message type
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.    " Communication Method (Key) (Business Address Services)

  IF nast-kschl EQ lc_zsqt.
    PERFORM f_adobe_prnt_zsqt.
  ELSEIF nast-kschl EQ lc_zsqs.
    PERFORM f_adobe_prnt_zsoc.
  ENDIF. " IF nast-kschl EQ lc_zsqt

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_convert_pdf_binary.
*******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = st_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mail_attachment USING fp_st_vbco3       TYPE vbco3 . " Sales Doc.Access Methods: Key Fields: Document Printing
******Local Constant Declaration
  DATA: lr_sender   TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        lv_send     TYPE adr6-smtp_addr,                        "variable to store email id
        li_lines    TYPE STANDARD TABLE OF tline,               "Lines of text read
        lst_lines   TYPE tline,                                 " SAPscript: Text Lines
        t_hex       TYPE solix_tab,
        lv_subject  TYPE so_obj_des,                            " Short description of contents
        lv_tabix    TYPE i,                                     " Tabix of type Integers
        lv_pdf_name TYPE so_obj_des.                            " Pdf_name of type CHAR30

********Local Constant Declaration
  CONSTANTS: lc_pdf    TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
             lc_i      TYPE bapi_mtype     VALUE 'I',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_st     TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
             lc_object TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
             lc_langu  TYPE thead-tdspras  VALUE 'E',                     "Language of text to be read
             lc_name   TYPE thead-tdname   VALUE 'ZQTC_LETTER_BODY_F027'. "Name of text to be read


  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service

  DATA: lr_send_request   TYPE REF TO cl_bcs VALUE IS INITIAL, " Business Communication Service
* Message body and subject
        li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i.                                        " Upd_tsk of type Integers


  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
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
    LOOP AT li_lines INTO lst_lines.
      lst_message_body-line = lst_lines-tdline.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0

  CONCATENATE text-005 fp_st_vbco3-vbeln INTO lv_subject SEPARATED BY space.
  TRY.
      lr_document = cl_document_bcs=>create_document(
      i_type = 'RAW' "lc_raw "'RAW'
  i_text = li_message_body
      i_hex    = t_hex
      i_subject = lv_subject ).
    CATCH cx_document_bcs.
*Exception handling not required
    CATCH cx_send_req_bcs.
*Exception handling not required
  ENDTRY.

  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions

  IF v_comm_meth NE c_comm_method.
*******Get email id from ADR6 table
    SELECT smtp_addr "E-Mail Address
      FROM adr6      "E-Mail Addresses (Business Address Services)
      INTO lv_send
      UP TO 1 ROWS
*   Begin of CHANGE:ERP-1940:WROY:16-MAY-2017:ED2K906126
*   Send Email to Bill-to Party, instead of Ship-to Party
      WHERE addrnumber EQ st_address-adrnr_bp.
*   WHERE addrnumber EQ st_address-adrnr_we.
*   End   of CHANGE:ERP-1940:WROY:16-MAY-2017:ED2K906126
    ENDSELECT.
  ENDIF. " IF v_comm_meth NE c_comm_method
*End of CHANGE:JIRA#4591:MMUKHERJEE:22-Sep-2017: ED2K908539

  IF lv_send IS NOT INITIAL
    AND v_comm_meth NE c_comm_meth.

    LOOP AT i_formoutput INTO DATA(lst_formoutput).
      lv_tabix = lv_tabix + 1.
      PERFORM f_convert_pdf_binary_f044 USING lst_formoutput.
      IF lv_tabix = 1.
        CONCATENATE text-006 fp_st_vbco3-vbeln INTO lv_pdf_name SEPARATED BY space.
      ELSEIF lv_tabix = 2.
        lv_pdf_name = 'Direct Debit Mandate'(013).
      ENDIF. " IF lv_tabix = 1

* -------------Attachment------------------------------------*
      TRY.
          lr_document->add_attachment(
          EXPORTING
          i_attachment_type = lc_pdf         "'PDF'
          i_attachment_subject = lv_pdf_name "text-006 "'Quotation Proforma'(001)
          i_att_content_hex = i_content_hex ).
        CATCH cx_document_bcs INTO lx_document_bcs.
*Exception handling not required
      ENDTRY.
* Add attachment

      TRY.
          CALL METHOD lr_send_request->set_document( lr_document ).
        CATCH cx_send_req_bcs.
*Exception handling not required
      ENDTRY.
      CLEAR: lv_pdf_name, lst_formoutput,i_content_hex.
    ENDLOOP. " LOOP AT i_formoutput INTO DATA(lst_formoutput)
* Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).
* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

* Create recipient
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_send ).
** Set recipient
        lr_send_request->add_recipient(
        EXPORTING
        i_recipient = lr_recipient
        i_express = abap_true ).
      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.
* Send email
    TRY.
* Send email
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.
********  BOC by MODUTTA for JIRA# ERP-3357 on 21/07/2017**********
*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0
********  EOC by MODUTTA for JIRA# ERP-3357 on 21/07/2017**********

*  ELSE. " ELSE -> IF lv_send IS NOT INITIAL
**   Begin of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216
**   MESSAGE text-003 TYPE  lc_i . "'I'.
*    MESSAGE e000 WITH text-003 INTO DATA(lv_msg_txt).
*    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*      EXPORTING
*        msg_arbgb = syst-msgid
*        msg_nr    = syst-msgno
*        msg_ty    = syst-msgty
*        msg_v1    = syst-msgv1
*        msg_v2    = syst-msgv2
*      EXCEPTIONS
*        OTHERS    = 0.
*    IF sy-subrc EQ 0.
*      v_retcode = 999.
*    ENDIF. " IF sy-subrc EQ 0
**   End   of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216
  ENDIF. " IF lv_send IS NOT INITIAL

ENDFORM. " MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tt_constant
                               fp_r_mtart_med_issue  TYPE fip_t_mtart_range " Material Types: Media Issues
                               fp_i_tax_id   TYPE tt_tax_id. "Tax Id "CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
  CONSTANTS: lc_devid         TYPE zdevid         VALUE 'F027', " Development ID
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
             lc_sanctioned_c  TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
             lc_vkorg         TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variable
             lc_zlsch         TYPE rvari_vnam VALUE 'ZLSCH', " ABAP: Name of Variant Variable
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
             lc_cust_group    TYPE rvari_vnam VALUE 'CUST_GROUP',  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
             lc_mat_grp5      TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
             lc_output_typ    TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_tax_id        TYPE rvari_vnam VALUE 'TAX_ID',
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
             lc_document_type TYPE rvari_vnam VALUE 'DOCUMENT_TYPE',
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
             lc_po_type       TYPE rvari_vnam VALUE 'FTP_BSARK',
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE',
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
             lc_print         TYPE rvari_vnam VALUE 'PRINT_MEDIA_PRODUCT',
             lc_digital       TYPE rvari_vnam VALUE 'DIGITAL_MEDIA_PRODUCT'.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
***Fetch from ZCACONSTANT to create a range table for the company code
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         srno        " ABAP: Current selection number
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = lc_devid.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
    LOOP AT fp_i_constant INTO DATA(lst_constant).
      IF lst_constant-param1 EQ c_mtart_med_iss. " Material Types: Media Issues
        APPEND INITIAL LINE TO fp_r_mtart_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
        <lst_med_issue>-sign   = lst_constant-sign.
        <lst_med_issue>-option = lst_constant-opti.
        <lst_med_issue>-low    = lst_constant-low.
        <lst_med_issue>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ c_mtart_med_iss
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
      IF lst_constant-param1 EQ lc_sanctioned_c.
        APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
        <lst_sanc_country>-sign   = lst_constant-sign.
        <lst_sanc_country>-option = lst_constant-opti.
        <lst_sanc_country>-low    = lst_constant-low.
        <lst_sanc_country>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_sanctioned_c
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      IF lst_constant-param1 EQ lc_vkorg.
        APPEND INITIAL LINE TO r_vkorg_f044 ASSIGNING FIELD-SYMBOL(<lst_vkorg_f044>).
        <lst_vkorg_f044>-sign   = lst_constant-sign.
        <lst_vkorg_f044>-option = lst_constant-opti.
        <lst_vkorg_f044>-low    = lst_constant-low.
        <lst_vkorg_f044>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_vkorg
      IF lst_constant-param1 EQ lc_zlsch.
        APPEND INITIAL LINE TO r_zlsch_f044 ASSIGNING FIELD-SYMBOL(<lst_zlsch_f044>).
        <lst_zlsch_f044>-sign   = lst_constant-sign.
        <lst_zlsch_f044>-option = lst_constant-opti.
        <lst_zlsch_f044>-low    = lst_constant-low.
        <lst_zlsch_f044>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_zlsch
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*   Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
      IF lst_constant-param1 EQ lc_cust_group.
        APPEND INITIAL LINE TO r_kvgr1_f044 ASSIGNING FIELD-SYMBOL(<lst_kvgr1_f044>).
        <lst_kvgr1_f044>-sign   = lst_constant-sign.
        <lst_kvgr1_f044>-option = lst_constant-opti.
        <lst_kvgr1_f044>-low    = lst_constant-low.
        <lst_kvgr1_f044>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_cust_group
*    End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
      IF lst_constant-param1 EQ lc_mat_grp5.
        APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
        <lst_mat_grp5>-sign   = lst_constant-sign.
        <lst_mat_grp5>-option = lst_constant-opti.
        <lst_mat_grp5>-low    = lst_constant-low.
        <lst_mat_grp5>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_output_typ.
        APPEND INITIAL LINE TO r_output_typ ASSIGNING FIELD-SYMBOL(<lst_output_typ>).
        <lst_output_typ>-sign   = lst_constant-sign.
        <lst_output_typ>-option = lst_constant-opti.
        <lst_output_typ>-low    = lst_constant-low.
        <lst_output_typ>-high   = lst_constant-high.
      ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*      IF lst_constant-param1 EQ lc_tax_id.
*        v_tax_id    = lst_constant-low.
*      ENDIF.
      IF lst_constant-param1 EQ lc_tax_id. " TAX IDs
        APPEND INITIAL LINE TO fp_i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>).
        <lst_tax_id>-land1 = lst_constant-param2.
        <lst_tax_id>-stceg = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_tax_id
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
      IF lst_constant-param1 EQ lc_document_type.
        APPEND INITIAL LINE TO r_document_type ASSIGNING FIELD-SYMBOL(<lst_document_type>).
        <lst_document_type>-sign   = lst_constant-sign.
        <lst_document_type>-option = lst_constant-opti.
        <lst_document_type>-low    = lst_constant-low.
        <lst_document_type>-high   = lst_constant-high.
      ENDIF.
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
*- Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IF lst_constant-param1 EQ lc_po_type.
        APPEND INITIAL LINE TO r_po_type ASSIGNING FIELD-SYMBOL(<lst_po_type>).
        <lst_po_type>-sign   = lst_constant-sign.
        <lst_po_type>-option = lst_constant-opti.
        <lst_po_type>-low    = lst_constant-low.
        <lst_po_type>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      IF lst_constant-param1 EQ lc_comp_code.
        APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
        <lst_comp_code>-sign   = lst_constant-sign.
        <lst_comp_code>-option = lst_constant-opti.
        <lst_comp_code>-low    = lst_constant-low.
        <lst_comp_code>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_docu_currency.
        APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
        <lst_docu_currency>-sign   = lst_constant-sign.
        <lst_docu_currency>-option = lst_constant-opti.
        <lst_docu_currency>-low    = lst_constant-low.
        <lst_docu_currency>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_sales_office.
        APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
        <lst_sales_office>-sign   = lst_constant-sign.
        <lst_sales_office>-option = lst_constant-opti.
        <lst_sales_office>-low    = lst_constant-low.
        <lst_sales_office>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
      IF lst_constant-param1 EQ lc_print.
        APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lst_print_product>).
        <lst_print_product>-sign   = lst_constant-sign.
        <lst_print_product>-option = lst_constant-opti.
        <lst_print_product>-low    = lst_constant-low.
        <lst_print_product>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_digital.
        APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lst_digital_product>).
        <lst_digital_product>-sign   = lst_constant-sign.
        <lst_digital_product>-option = lst_constant-opti.
        <lst_digital_product>-low    = lst_constant-low.
        <lst_digital_product>-high   = lst_constant-high.
      ENDIF.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
    ENDLOOP. " LOOP AT fp_i_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_STD_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBCO3  text
*      -->P_LC_SCM  text
*      <--P_V_REMIT_TO_scm  text
*      <--P_V_BANKING1_SCM_USA  text
*      <--P_V_CUST_SERV_SCM_USA  text
*      <--P_V_EMAIL_SCM_USA  text
*      <--P_V_CREDIT_SCM_USA  text
*      <--P_V_FOOTER_SCM_USA  text
*----------------------------------------------------------------------*
FORM f_populate_std_text  USING    fp_waerk        TYPE waerk         " SD Document Currency
                                   fp_bukrs_vf     TYPE bukrs_vf      " Company code to be billed
                                   fp_lc_suffix    TYPE char3         " Lc_suffix of type CHAR3
                          CHANGING fp_v_remit_to   TYPE thead-tdname  " Name
                                   fp_v_banking1   TYPE thead-tdname  " Name
                                   fp_v_cust_serv  TYPE thead-tdname  " Name
                                   fp_v_email      TYPE thead-tdname  " Name
                                   fp_v_credit     TYPE thead-tdname  " Name
                                   fp_v_footer     TYPE thead-tdname  " Name
                                   fp_v_comp_name  TYPE thead-tdname  " Name
                                   fp_v_mis_msg    TYPE thead-tdname  " Name
                                   fp_v_payment    TYPE thead-tdname. " Name


*******Local Constant declaration
  CONSTANTS: lc_underscore       TYPE char1          VALUE '_',          " Underscore
             lc_txtname_part1    TYPE char10         VALUE 'ZQTC_F027_', " Txtname_part1 of type CHAR20
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
             lc_txtname_part2    TYPE char5          VALUE 'ZQTC_',                  " Txtname_part1 of type CHAR20
             lc_xxx              TYPE char3          VALUE 'XXX',                    " Xxx of type CHAR3
             lc_crdcd            TYPE char11         VALUE 'CREDIT_CARD',            " Crdcd of type CHAR11
             lc_tbt_agency1      TYPE char30         VALUE 'ZQTC_CUST_SERV_AGENCY_', " Tbt_agency1 of type CHAR30
             lc_cust_serv        TYPE char15         VALUE 'ZQTC_CUST_SERV_',        " Cust_serv of type CHAR15
             lc_footer1          TYPE char12         VALUE 'ZQTC_FOOTER_',           " Footer1 of type CHAR12
             lc_ftp              TYPE char3          VALUE 'FTP',   "ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
             lc_0161             TYPE char4          VALUE '0161',   "ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
*** BOC BY SAYANDAS on 09-Apr-2018 in TR  ED2K911882 for compname
             lc_txtname_part3    TYPE char10 VALUE 'ZQTC_F032_', " Txtname_part1 of type CHAR20
             lc_comp_name        TYPE char10 VALUE 'COMP_NAME_', " Comp_name of type CHAR10
*** EOC BY SAYANDAS on 09-Apr-2018 in TR  ED2K911882 for compname
             lc_remit_to         TYPE char10         VALUE 'REMIT_TO_',     " Txtname_part2 of type CHAR6
             lc_banking1         TYPE char9          VALUE 'BANKING1_',     " Banking1 of type CHAR9
             lc_banking2         TYPE char9          VALUE 'BANKING2_',     " Banking2 of type CHAR9
             lc_cust_ser         TYPE char13         VALUE 'CUST_SERVICE_', " Cust of type CHAR13
             lc_email            TYPE char6          VALUE 'EMAIL_',        " Email of type CHAR6
             lc_credit           TYPE char10         VALUE 'CREDIT_',       " Credit of type CHAR7
             lc_credit_email     TYPE char15         VALUE 'CREDIT_EMAIL_',  " Credit of type CHAR7
             lc_payment          TYPE char10         VALUE 'PAYMENT_',      " Credit of type CHAR7
             lc_footer           TYPE char10         VALUE 'FOOTER_',       " Txtname_part2 of type CHAR6
             lc_st               TYPE thead-tdid     VALUE 'ST',            " Text ID of text to be read
             lc_object           TYPE thead-tdobject VALUE 'TEXT',          " Object of text to be read
*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
             lc_tbt_agency       TYPE char30         VALUE 'ZQTC_F027_AGENCY_',       " Tbt_agency of type CHAR30
             lc_tbt_crd_card_det TYPE char30         VALUE 'ZQTC_F027_CUST_SERVICE_', " Tbt_crd_card_det of type CHAR30
*** EOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
             lc_name_email       TYPE thead-tdname   VALUE 'ZQTC_DETTACH_EMAIL_F027', " Name of text to be read
             lc_mis_msg          TYPE thead-tdname   VALUE 'ZQTC_F027_MIS_MSG_',      " Name
             lc_zsiq             TYPE thead-tdname   VALUE '_ZSIQ', "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
             lc_bank             TYPE thead-tdname   VALUE 'ZQTC_F027_BANK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_credit_d         TYPE thead-tdname   VALUE 'ZQTC_F027_CREDIT_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_remit            TYPE thead-tdname   VALUE 'ZQTC_F027_CHECK_DETAILS_1001_USD'. "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785

  DATA: lv_spras    TYPE spras,                   " Language Key
        li_email_id TYPE STANDARD TABLE OF tline, "Lines of text read
        li_email    TYPE STANDARD TABLE OF tline. "Lines of text read


  lv_spras = v_langu.
*** BOC BY SAYANDAS on 09-Apr-2018 in TR  ED2K911882 for compname
****** To populate the company name.
  CONCATENATE lc_txtname_part3
              lc_comp_name
              fp_bukrs_vf
              lc_underscore
              fp_waerk
         INTO fp_v_comp_name.
  CONDENSE fp_v_comp_name NO-GAPS.
*** EOC BY SAYANDAS on 09-Apr-2018 in TR  ED2K911882 for compname
********Populate remit to address
  CONCATENATE lc_txtname_part1
              lc_remit_to
              fp_bukrs_vf
              lc_underscore
              fp_waerk
              lc_underscore
              fp_lc_suffix
         INTO fp_v_remit_to.
  CONDENSE fp_v_remit_to NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  IF v_po_type = abap_true.
    CLEAR fp_v_remit_to.
    CONCATENATE lc_txtname_part1
                lc_remit_to
                lc_ftp
                lc_underscore
                lc_0161
           INTO fp_v_remit_to.
    CONDENSE fp_v_remit_to NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE i_vbap INTO DATA(lst_vbap_tmp1) INDEX 1.
  IF st_header-company_code IN r_comp_code AND fp_waerk IN  r_docu_currency  AND lst_vbap_tmp1-vkbur IN r_sales_office.
    CLEAR fp_v_remit_to.
    fp_v_remit_to  = lc_remit.
    CONDENSE fp_v_remit_to NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
  READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = fp_v_remit_to
                                                        BINARY SEARCH.
  IF sy-subrc NE 0
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
    OR st_address-land1_bp IN r_sanc_countries.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
    CLEAR : fp_v_remit_to.
    CONCATENATE lc_txtname_part2
                lc_remit_to
                lc_xxx
                INTO fp_v_remit_to.
  ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
**********Populate banking1
  CONCATENATE lc_txtname_part1
              lc_banking1
              fp_bukrs_vf
              lc_underscore
              fp_waerk
              lc_underscore
              fp_lc_suffix
         INTO fp_v_banking1.
  CONDENSE fp_v_banking1 NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  IF v_po_type = abap_true.
    CLEAR fp_v_banking1.
    CONCATENATE lc_txtname_part1
                lc_banking1
                lc_xxx
                lc_underscore
                lc_ftp
                lc_underscore
                lc_xxx
           INTO fp_v_banking1.
    CONDENSE fp_v_banking1 NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE i_vbap INTO DATA(lst_vbap_tmp) INDEX 1.
  IF st_header-company_code IN r_comp_code AND fp_waerk IN  r_docu_currency  AND lst_vbap_tmp-vkbur IN r_sales_office.
    CLEAR fp_v_banking1.
    fp_v_banking1  = lc_bank.
    CONDENSE fp_v_banking1 NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
  IF fp_v_remit_to CS lc_xxx OR
     st_address-land1_bp IN r_sanc_countries.
    CLEAR: fp_v_banking1.
  ENDIF. " IF fp_v_remit_to CS lc_xxx OR
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795

*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
***********Populate customer service
*  CONCATENATE lc_txtname_part1
*      lc_cust_ser
*      fp_bukrs_vf
*      lc_underscore
*      fp_waerk
*      lc_underscore
*      fp_lc_suffix
* INTO fp_v_cust_serv.
*  CONDENSE fp_v_cust_serv NO-GAPS. " Commented BY SAYANDAS
  IF v_kvgr1 EQ v_psb.
    DATA(lv_credit_card) = lc_tbt_agency.
  ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
    lv_credit_card = lc_tbt_crd_card_det.
  ENDIF. " IF v_kvgr1 EQ v_psb

  CONCATENATE lv_credit_card
      fp_bukrs_vf
      lc_underscore
      fp_waerk
      lc_underscore
      fp_lc_suffix
 INTO fp_v_cust_serv.
  CONDENSE fp_v_cust_serv NO-GAPS.
*** EOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  IF v_po_type = abap_true.
    CLEAR fp_v_cust_serv.
    CONCATENATE lv_credit_card
        fp_bukrs_vf
        lc_underscore
        lc_ftp
        lc_underscore
        fp_waerk
        lc_underscore
        fp_lc_suffix
   INTO fp_v_cust_serv.
    CONDENSE fp_v_cust_serv NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_serv
                                                        BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR : fp_v_cust_serv.
    IF v_kvgr1 EQ v_psb.
      DATA(lv_credit_card1) = lc_tbt_agency1.
    ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
      lv_credit_card1 = lc_cust_serv.
    ENDIF. " IF v_kvgr1 EQ v_psb

    CONCATENATE lv_credit_card1
                fp_bukrs_vf
                lc_underscore
                fp_lc_suffix
                lc_underscore
                lc_xxx
                INTO fp_v_cust_serv.
    CONDENSE fp_v_cust_serv NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
    IF v_po_type = abap_true.
      CLEAR fp_v_cust_serv.
      CONCATENATE lv_credit_card1
                  fp_bukrs_vf
                  lc_underscore
                  lc_ftp
                  lc_underscore
                  fp_lc_suffix
                  lc_underscore
                  lc_xxx
                  INTO fp_v_cust_serv.
      CONDENSE fp_v_cust_serv NO-GAPS.
    ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  ENDIF. " IF sy-subrc NE 0

***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376

**********Populate email
  CONCATENATE lc_txtname_part1
  lc_email
  fp_bukrs_vf
  lc_underscore
  fp_waerk
  lc_underscore
  fp_lc_suffix
INTO fp_v_email.
  CONDENSE fp_v_email NO-GAPS.


  CONCATENATE lc_txtname_part1
   lc_credit
   fp_bukrs_vf
   lc_underscore
   fp_waerk
   lc_underscore
   fp_lc_suffix
 INTO v_credit_crd.
  CONDENSE v_credit_crd NO-GAPS.
* Begin of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
  CONCATENATE lc_txtname_part1
   lc_credit_email
   fp_bukrs_vf
   lc_underscore
   fp_waerk
   lc_underscore
   fp_lc_suffix
 INTO v_credit_crd_email.
  CONDENSE v_credit_crd_email  NO-GAPS.
* End of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  IF v_po_type = abap_true.
    CLEAR v_credit_crd_email.
    CONCATENATE lc_txtname_part1
     lc_credit_email
     lc_xxx
     lc_underscore
     lc_ftp
     lc_underscore
     lc_xxx
   INTO v_credit_crd_email.
    CONDENSE v_credit_crd_email  NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE i_vbap INTO DATA(lst_vbap_tmp11) INDEX 1.
  IF st_header-company_code IN r_comp_code AND fp_waerk IN  r_docu_currency  AND lst_vbap_tmp11-vkbur IN r_sales_office.
    CLEAR  v_credit_crd_email.
    v_credit_crd_email  = lc_credit_d.
    CONDENSE v_credit_crd_email NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_credit_crd
                                                        BINARY SEARCH.
  IF sy-subrc NE 0
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
  OR st_address-land1_bp IN r_sanc_countries.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
    CLEAR : v_credit_crd.
    CONCATENATE lc_txtname_part2
                lc_crdcd
                lc_underscore
                lc_xxx
                INTO v_credit_crd.
  ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376

  CONCATENATE lc_txtname_part1
   lc_payment
   fp_bukrs_vf
   lc_underscore
   fp_waerk
   lc_underscore
   fp_lc_suffix
 INTO v_payment.
  CONDENSE v_payment NO-GAPS.
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
  IF st_address-land1_bp  IN r_sanc_countries.
    CLEAR: v_payment.
  ENDIF. " IF st_address-land1_bp IN r_sanc_countries
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795

*  Added by MODUTTA
*  Populate email id from SO10 text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = lv_spras
      name                    = fp_v_email
      object                  = lc_object
    TABLES
      lines                   = li_email_id
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0 AND li_email_id IS NOT INITIAL.
    READ TABLE li_email_id INTO DATA(lst_email_id) INDEX 1.
    IF sy-subrc EQ 0.
      v_email_id = lst_email_id-tdline.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0 AND li_email_id IS NOT INITIAL

**********Populate credit card details
  CONCATENATE lc_txtname_part1
  lc_credit
  fp_bukrs_vf
  lc_underscore
  fp_waerk
  lc_underscore
  fp_lc_suffix
INTO fp_v_credit.
  CONDENSE fp_v_credit NO-GAPS.
* Begin of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
  CONCATENATE lc_txtname_part1
   lc_credit_email
   fp_bukrs_vf
   lc_underscore
   fp_waerk
   lc_underscore
   fp_lc_suffix
 INTO v_credit_crd_email.
  CONDENSE v_credit_crd_email  NO-GAPS.
* End of CHANGE:CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
  IF v_po_type = abap_true.
    CLEAR v_credit_crd_email.
    CONCATENATE lc_txtname_part1
     lc_credit_email
     lc_xxx
     lc_underscore
     lc_ftp
     lc_underscore
     lc_xxx
   INTO v_credit_crd_email.
    CONDENSE v_credit_crd_email  NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE i_vbap INTO DATA(lst_vbap_p) INDEX 1.
  IF st_header-company_code IN r_comp_code AND fp_waerk IN  r_docu_currency  AND lst_vbap_p-vkbur IN r_sales_office.
    CLEAR  v_credit_crd_email.
    v_credit_crd_email  = lc_credit_d.
    CONDENSE v_credit_crd_email NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
**********Populate footer
  CONCATENATE lc_txtname_part1
  lc_footer
  fp_bukrs_vf
  lc_underscore
  fp_waerk
  lc_underscore
  fp_lc_suffix
INTO fp_v_footer.
  CONDENSE fp_v_footer NO-GAPS.

***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_footer
                                                        BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR : fp_v_footer.
    CONCATENATE lc_footer1
                fp_bukrs_vf
                lc_underscore
                fp_lc_suffix
                INTO fp_v_footer.
    CONDENSE fp_v_footer NO-GAPS.
  ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
  IF nast-kschl = c_zsqt  AND st_header-document_type IN r_document_type.
    CONCATENATE lc_mis_msg
                fp_lc_suffix
                lc_zsiq
                INTO fp_v_mis_msg.
    CONDENSE fp_v_mis_msg.
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
  ELSE.
    CONCATENATE lc_mis_msg
                fp_lc_suffix
                INTO fp_v_mis_msg.
    CONDENSE fp_v_mis_msg.
  ENDIF.    "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BARCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_barcode.

  DATA: lv_amount   TYPE char11, " Amount of type CHAR11
*        lv_invoice  TYPE char10, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
        lv_invoice  TYPE char16, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
        lv_inv_chk  TYPE char1,  " Inv_chk of type CHAR1
        lv_amnt_chk TYPE char1,  " Amnt_chk of type CHAR1
*        lv_bar      TYPE char30, " Bar of type CHAR30 "ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
        lv_bar      TYPE char100, " Bar of type CHAR100 ""ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
        lv_bar_chk  TYPE char1.  " Bar_chk of type CHAR1

* Invoice Number
  MOVE st_vbco3-vbeln TO lv_invoice.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_invoice
    IMPORTING
      output = lv_invoice.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_invoice
*    IMPORTING
*      check_digit = lv_inv_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_invoice
    IMPORTING
      check_digit = lv_inv_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
* Amount
  WRITE st_calc-total_due TO lv_amount CURRENCY st_calc-waerk.
  REPLACE ALL OCCURRENCES OF '.' IN lv_amount WITH space. "Added by MODUTTA
  REPLACE ALL OCCURRENCES OF ',' IN lv_amount WITH space.
  CONDENSE lv_amount.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_amount
    IMPORTING
      output = lv_amount.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
*  MOVE st_calc-total_due TO lv_amount.
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_amount
*    IMPORTING
*      check_digit = lv_amnt_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_amount
    IMPORTING
      check_digit = lv_amnt_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
  CONCATENATE lv_invoice
              lv_inv_chk
              lv_amount
              lv_amnt_chk
              INTO lv_bar.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_bar
*    IMPORTING
*      check_digit = lv_bar_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_bar
    IMPORTING
      check_digit = lv_bar_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
  CONCATENATE lv_invoice
              lv_inv_chk
              lv_amount
              lv_amnt_chk
              lv_bar_chk
              INTO v_barcode
              SEPARATED BY space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SUBSCRPTION_TYPE
*&---------------------------------------------------------------------*
* Subroutine to populate subscription type
*----------------------------------------------------------------------*
*      -->FP_LV_NAME  text
*      -->FP_ST_HEADER  text
*      <--FP_V_SUBSCRIPTION_TYP  text
*----------------------------------------------------------------------*
FORM f_get_subscrption_type  USING    fp_lv_name             TYPE thead-tdname
                                      fp_st_header           TYPE zstqtc_header_f027 " Structure for Header detail of invoice form
                             CHANGING fp_v_subscription_typ  TYPE char100.           " V_subscription_typ of type CHAR100

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.

  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
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
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_v_subscription_typ = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
* Get standard text values
*----------------------------------------------------------------------*
*      -->P_LV_NAME  text
*      -->P_ST_HEADER  text
*      <--P_LV_YEAR  text
*----------------------------------------------------------------------*
FORM f_get_text_val  USING    fp_lv_name   TYPE thead-tdname       " Name
                              fp_st_header TYPE zstqtc_header_f027 " Structure for Header detail of invoice form
                     CHANGING fp_lv_value  TYPE char30.            "char10. " Lv_value of type CHAR10 ++SAYANDAS

  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
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
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_lv_value = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_variable .

  CLEAR: v_retcode          ,
*        v_ent_screen       ,
         v_xstring          ,
         v_msg_txt          ,
         v_remit_to_uk      ,
         v_remit_to_usa     ,
         v_footer1          ,
         v_footer,
         v_footer2          ,
         st_vbco3           ,
         v_society_logo     ,
         v_detach           ,
         v_order            ,
         v_comm_meth          ,
         v_cust             ,
         v_com_uk           ,
         v_com_usa          ,
         st_address         ,
         st_header          ,
         i_vbpa             ,
         i_vbap             ,
         i_content_hex      ,
         i_final            ,
         i_credit           ,
         st_formoutput      ,
         st_calc            ,
         i_constant         ,
         v_remit_to_tbt_uk  ,
         v_credit_tbt_uk    ,
         v_email_tbt_uk     ,
         v_banking1_tbt_uk  ,
         v_cust_serv_tbt_uk ,
         v_remit_to_scc  ,
         v_credit_scc    ,
         v_email_scc     ,
         v_banking1_scc  ,
         v_cust_serv_scc ,
         v_remit_to_scm  ,
         v_credit_scm    ,
         v_email_scm     ,
         v_banking1_scm  ,
         v_cust_serv_scm ,
         v_footer_tbt       ,
         v_footer_scc    ,
         v_footer_scm,
         v_remit_to_tbt_usa ,
         v_credit_tbt_usa  ,
         v_email_tbt_usa  ,
         v_banking1_tbt_usa   ,
          v_cust_serv_tbt_usa  ,
          v_remit_to_scc   ,
          v_credit_scc     ,
          v_email_scc      ,
          v_banking1_scc   ,
          v_cust_serv_scc  ,
          v_footer_scc     ,
          v_barcode            ,
          v_seller_reg         ,
          i_tax_data           ,
          i_mara               ,
          i_sub_final          ,
          i_jptidcdassign      ,
          v_langu              ,
          v_email_id           ,
          v_tax                ,
          v_scc,
          v_scm,
          v_partner_za,
          v_mis_msg,
          v_credit_crd,
          v_payment_scc,
          v_payment_scm,
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
*         Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
          st_formoutput_f044,
          v_zlsch_f044,
*         End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
*         Begin of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913493
          i_formoutput,
*         End   of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913493
          v_vkorg_f044,
          v_waerk_f044,
          v_ihrez_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
          r_mat_grp5,      " ADD:CR#7730 KKRAVURI20181012
          r_output_typ.    " ADD:CR#7730 KKRAVURI20181012

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHAR_TO_NUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_SUB_FINAL_TEMP_UNIT_PRICE  text
*      <--P_LV_TAX_SUM_TEMP  text
*----------------------------------------------------------------------*
FORM f_char_to_num  USING    fp_char TYPE char25 " Char_to_num using fp_ch of type CHAR25
                    CHANGING fp_num  LIKE v_num.

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      chr             = fp_char
    IMPORTING
      num             = fp_num
    EXCEPTIONS
      convt_no_number = 1
      convt_overflow  = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT_SOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_email_output_soc .
****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_form_name        TYPE fpname,          " Name of Form Object
        lv_funcname_soc     TYPE funcname,        " Function name
        lv_msgv_formnm      TYPE syst_msgv,       " Message Variable
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string.

****Local Constant declaration
  CONSTANTS: lc_form_soc  TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_ZSOC', " Name of Form Object
             lc_msgnr_165 TYPE sy-msgno VALUE '165',                  " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',                  " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2',              " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.                    " ABAP System Field: Message Type

  lv_form_name = tnapr-sform.
  lv_msgv_formnm = tnapr-sform.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true. "Comment by MODUTTA on 11-May-18 for INC0194261
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc IS NOT INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
    v_retcode = 900.
    RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = lc_msgid
              msg_nr                 = lc_msgnr_166
              msg_ty                 = lc_err
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          .
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.

    CALL FUNCTION lv_funcname "'/1BCDWB/SM00000068'
      EXPORTING
        /1bcdwb/docparams    = lst_sfpdocparams
        im_header            = st_header
        im_xstring           = v_xstring
        im_langu             = v_langu
        im_vbco3             = st_vbco3
        im_address           = st_address
*** BOC BY SAYANDAS
        im_sub_final         = i_sub_final
*** EOC BY SAYANDAS
        im_final             = i_final
        im_calc              = st_calc
        im_society_logo      = v_society_logo
        im_vbap              = vbap
        im_remit_to_uk       = v_remit_to_uk
        im_remit_to_usa      = v_remit_to_usa
*       im_detach            = v_detach
        im_order_uk          = v_com_uk
        im_order_usa         = v_com_usa
        im_footer1           = v_footer1
        im_footer2           = v_footer2
        im_remit_to_tbt_usa  = v_remit_to_tbt_usa
        im_remit_to_tbt_uk   = v_remit_to_tbt_uk
        im_banking1_tbt_usa  = v_banking1_tbt_usa
        im_banking1_tbt_uk   = v_banking1_tbt_uk
        im_cust_serv_tbt_usa = v_cust_serv_tbt_usa
        im_cust_serv_tbt_uk  = v_cust_serv_tbt_uk
        im_email_tbt_usa     = v_email_tbt_usa
        im_email_tbt_uk      = v_email_tbt_uk
        im_credit_tbt_usa    = v_credit_tbt_usa
        im_credit_tbt_uk     = v_credit_tbt_uk
        im_footer_tbt        = v_footer
*** BOC BY SAYANDAS
        im_v_society_text    = v_society_text
        im_comp_name         = v_comp_name
*** EOC BY SAYANDAS
        im_customer          = v_cust
        im_remit_to_scc      = v_remit_to_scc
        im_remit_to_scm      = v_remit_to_scm
        im_banking1_scc      = v_banking1_scc
        im_banking1_scm      = v_banking1_scm
        im_cust_serv_scc     = v_cust_serv_scc
        im_cust_serv_scm     = v_cust_serv_scm
        im_email_scc         = v_email_scc
        im_email_scm         = v_email_scm
        im_credit_scc        = v_credit_scc
        im_credit_scm        = v_credit_scm
        im_footer_scc        = v_footer
        im_footer_scm        = v_footer
*** BOC BY SAYANDAS
        im_barcode           = v_barcode
*** EOC BY SAYNADAS
        im_seller_reg        = v_seller_reg
        im_email             = v_email_id
        im_tax               = v_tax
*** BOC BY SAYANDAS
        im_credit_crd        = v_credit_crd
        im_payment           = v_payment
        im_payment_scc       = v_payment_scc
        im_payment_scm       = v_payment_scm
        im_mis_msg           = v_mis_msg
*** EOC BY SAYANDAS
        im_credit_email      = v_credit_crd_email "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
        im_po_type           = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IMPORTING
        /1bcdwb/formoutput   = st_formoutput
      EXCEPTIONS
        usage_error          = 1
        system_error         = 2
        internal_error       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
        v_retcode = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL

  IF v_ent_screen IS INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    IF st_formoutput-pdf IS INITIAL.
*     Message: Error occurred generating PDF file
      MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
    ENDIF. " IF st_formoutput-pdf IS INITIAL
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
    APPEND st_formoutput TO i_formoutput.
*   Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
    IF st_formoutput_f044 IS NOT INITIAL.
*   End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
      APPEND st_formoutput_f044 TO i_formoutput.
*   Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
    ENDIF.
*   End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
********Perform is used to convert PDF in to Binary
*    PERFORM f_convert_pdf_binary.

********Perform is used to create mail attachment with a creation of mail body
    PERFORM f_mail_attachment USING st_vbco3.
  ENDIF. " IF v_ent_screen IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_PDF_APPLICTN_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_pdf_applictn_server .

  CONSTANTS : lc_iden          TYPE char10 VALUE 'VF', " Iden of type CHAR10
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911587
              lc_bus_prcs_bill TYPE zbus_prcocess VALUE 'B',  " Business Process - Billing
              lc_prnt_vend_qi  TYPE zprint_vendor VALUE 'Q',  " Third Party System (Print Vendor) - QuickIssue
              lc_prnt_vend_bt  TYPE zprint_vendor VALUE 'B',  " Third Party System (Print Vendor) - BillTrust
              lc_parvw_re      TYPE parvw         VALUE 'RE'. " Partner Function: Bill-To Party

  DATA: li_output   TYPE ztqtc_output_supp_retrieval.

  DATA: lst_output  TYPE zstqtc_output_supp_retrieval. " Output structure for E098-Output Supplement Retrieval
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911587

  DATA: lv_filename     TYPE localfile, " BCOM: Text That Is to Be Converted into MIME
*       Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911587
        lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region, " Print Region
        lv_country_sort TYPE zcountry_sort, " Country Sorting Key
        lv_file_loc     TYPE file_no,       " Application Server File Path
*       End   of ADD:I0231:WROY:25-Mar-2018:ED2K911587
        lv_datum        TYPE sydatum, " System Date
*       Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911725
        lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
*       End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911725
        lv_amount       TYPE char24. " Amount of type CHAR24

* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911587
  CLEAR lst_output.
  lst_output-attachment_name = 'SAP Proforma'(012).
  lst_output-pdf_stream = st_formoutput-pdf.
  INSERT lst_output INTO li_output INDEX 1.

* Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
  IF st_formoutput_f044 IS NOT INITIAL.
* End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
    CLEAR lst_output.
    lst_output-attachment_name = 'Direct Debit Mandate'(013).
    lst_output-pdf_stream = st_formoutput_f044-pdf.
    INSERT lst_output INTO li_output INDEX 2.
* Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
  ENDIF.
* End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507

* Identify Bill-to Party Details
  READ TABLE i_vbpa INTO DATA(lst_vbpa)
       WITH KEY vbeln = st_vbco3-vbeln
                parvw = lc_parvw_re
       BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR: lst_vbpa.
  ENDIF. " IF sy-subrc NE 0

* Determine Print Vendor
  CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
    EXPORTING
      im_bus_prcocess     = lc_bus_prcs_bill " Business Process (Billing)
      im_country          = lst_vbpa-land1   " Bill-to Party Country
      im_output_type      = nast-kschl       " Output Type
    IMPORTING
      ex_print_vendor     = lv_print_vendor  " Third Party System (Print Vendor)
      ex_print_region     = lv_print_region  " Print Region
      ex_country_sort     = lv_country_sort  " Country Sorting Key
      ex_file_loc         = lv_file_loc      " Application Server File Path
    EXCEPTIONS
      exc_invalid_bus_prc = 1
      exc_no_entry_found  = 2
      OTHERS              = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_print_vendor.
  ENDIF. " IF sy-subrc NE 0

* Trigger different logic based on Third Party System (Print Vendor)
  CASE lv_print_vendor.
    WHEN lc_prnt_vend_qi. " Third Party System (Print Vendor) - QuickIssue
      CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
        EXPORTING
          im_outputs           = li_output        " PDF Contents
          im_bus_prcocess      = lc_bus_prcs_bill " Business Process (Renewal)
          im_print_region      = lv_print_region  " Print Region
          im_country_sort      = lv_country_sort  " Country Sorting Key
          im_file_loc          = lv_file_loc      " Application Server File Path
          im_country           = lst_vbpa-land1   " Bill-to Party Country
          im_customer          = lst_vbpa-kunnr   " Bill-to Party Customer
          im_doc_number        = st_vbco3-vbeln   " SD Document Number (Quotation)
        EXCEPTIONS
          exc_missing_dir_path = 1
          exc_err_opening_file = 2
          OTHERS               = 3.
      IF sy-subrc NE 0.
*       Update Processing Log
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb = syst-msgid
            msg_nr    = syst-msgno
            msg_ty    = syst-msgty
            msg_v1    = syst-msgv1
            msg_v2    = syst-msgv2
          EXCEPTIONS
            OTHERS    = 0.
        IF sy-subrc EQ 0.
          v_retcode = 900.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc NE 0

    WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911587
*     Begin of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911725
*     MOVE st_calc-total_due TO lv_amount.
*     End   of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911725
*     Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911725
      lv_bapi_amount = st_calc-total_due.
*     Converts a currency amount from SAP format to External format
      CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
        EXPORTING
          currency    = st_calc-waerk   " Currency
          sap_amount  = lv_bapi_amount  " SAP format
        IMPORTING
          bapi_amount = lv_bapi_amount. " External format
      MOVE lv_bapi_amount TO lv_amount.
*     End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911725
      CONDENSE lv_amount.

*     MOVE st_header-date_rec TO lv_datum.
      MOVE sy-datum TO lv_datum.

      CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
        EXPORTING
          im_fpformoutput    = st_formoutput
          im_customer        = st_vbco3-kunde
          im_invoice         = st_vbco3-vbeln
          im_amount          = lv_amount
          im_currency        = st_calc-waerk
          im_date            = lv_datum
          im_form_identifier = lc_iden
          im_ccode           = st_header-company_code
*         Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911587
          im_file_loc        = lv_file_loc
*         End   of ADD:I0231:WROY:25-Mar-2018:ED2K911587
        IMPORTING
          ex_file_name       = lv_filename.

      IF lv_filename IS NOT INITIAL.
        CLEAR: lv_amount , lv_datum.
      ENDIF. " IF lv_filename IS NOT INITIAL
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911587
    WHEN OTHERS.
*     Nothing to Do
  ENDCASE.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911587
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL_ZSQT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_zsqt.

*  * ****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers

****Local Constant declaration
  CONSTANTS: lc_form_name      TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_INV', " Name of Form Object
             lc_msgnr_165      TYPE sy-msgno VALUE '165',                 " ABAP System Field: Message Number
             lc_msgnr_166      TYPE sy-msgno VALUE '166',                 " ABAP System Field: Message Number
             lc_msgid          TYPE sy-msgid VALUE 'ZQTC_R2',             " ABAP System Field: Message ID
             lc_err            TYPE sy-msgty VALUE 'E',                   " ABAP System Field: Message Type
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.                  " Communication Method (Key) (Business Address Services)

  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true. "Comment by MODUTTA on 11-May-18 for INC0194261
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc IS NOT INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
    v_retcode = 900.
    RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = lc_msgid
              msg_nr                 = lc_msgnr_166
              msg_ty                 = lc_err
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          .
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.

    CALL FUNCTION lv_funcname "'/1BCDWB/SM00000068'
      EXPORTING
        /1bcdwb/docparams    = lst_sfpdocparams
        im_header            = st_header
        im_xstring           = v_xstring
        im_langu             = v_langu
        im_vbco3             = st_vbco3
        im_address           = st_address
*** BOC BY SAYANDAS
        im_sub_final         = i_sub_final
*** EOC BY SAYANDAS
        im_final             = i_final
        im_calc              = st_calc
        im_society_logo      = v_society_logo
        im_vbap              = vbap
        im_remit_to_uk       = v_remit_to_uk
        im_remit_to_usa      = v_remit_to_usa
*       im_detach            = v_detach
        im_order_uk          = v_com_uk
        im_order_usa         = v_com_usa
        im_footer1           = v_footer1
        im_footer2           = v_footer2
        im_remit_to_tbt_usa  = v_remit_to_tbt_usa
        im_remit_to_tbt_uk   = v_remit_to_tbt_uk
        im_banking1_tbt_usa  = v_banking1_tbt_usa
        im_banking1_tbt_uk   = v_banking1_tbt_uk
        im_cust_serv_tbt_usa = v_cust_serv_tbt_usa
        im_cust_serv_tbt_uk  = v_cust_serv_tbt_uk
        im_email_tbt_usa     = v_email_tbt_usa
        im_email_tbt_uk      = v_email_tbt_uk
        im_credit_tbt_usa    = v_credit_tbt_usa
        im_credit_tbt_uk     = v_credit_tbt_uk
        im_footer_tbt        = v_footer
*** BOC BY SAYANDAS
        im_v_society_text    = v_society_text
        im_comp_name         = v_comp_name
*** EOC BY SAYANDAS
        im_customer          = v_cust
        im_remit_to_scc      = v_remit_to_scc
        im_remit_to_scm      = v_remit_to_scm
        im_banking1_scc      = v_banking1_scc
        im_banking1_scm      = v_banking1_scm
        im_cust_serv_scc     = v_cust_serv_scc
        im_cust_serv_scm     = v_cust_serv_scm
        im_email_scc         = v_email_scc
        im_email_scm         = v_email_scm
        im_credit_scc        = v_credit_scc
        im_credit_scm        = v_credit_scm
        im_footer_scc        = v_footer
        im_footer_scm        = v_footer
*** BOC BY SAYANDAS
        im_barcode           = v_barcode
*** EOC BY SAYNADAS
        im_seller_reg        = v_seller_reg
        im_email             = v_email_id
        im_tax               = v_tax
*** BOC BY SAYANDAS
        im_credit_crd        = v_credit_crd
        im_payment           = v_payment
        im_payment_scc       = v_payment_scc
        im_payment_scm       = v_payment_scm
        im_mis_msg           = v_mis_msg
*** EOC BY SAYANDAS
        im_credit_email      = v_credit_crd_email "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
        im_po_type           = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IMPORTING
        /1bcdwb/formoutput   = st_formoutput
      EXCEPTIONS
        usage_error          = 1
        system_error         = 2
        internal_error       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
        v_retcode = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL
*** BOC BY SAYNADAS on 08-MAR-2018 for save PDF in application server
*  IF i_vbpa[] IS NOT INITIAL.
*    DATA(li_vbpa) = i_vbpa[].
*    SORT li_vbpa BY adrnr.
*    DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr.

* Fetch title and name
*    SELECT addrnumber, " Address number
*           title,      " Form-of-Address Key
*           name1,      " Name 1
*           deflt_comm  " Communication Method (Key) (Business Address Services)
*      INTO TABLE @DATA(li_adrc)
*      FROM adrc        " Addresses (Business Address Services)
*      FOR ALL ENTRIES IN @li_vbpa
*      WHERE addrnumber EQ @li_vbpa-adrnr.
*    IF sy-subrc EQ 0.
*      SORT li_adrc  BY addrnumber.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF i_vbpa[] IS NOT INITIAL
*  READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_address-adrnr_bp
*                                                   BINARY SEARCH.
*
*  IF sy-subrc EQ 0.
  IF v_comm_meth = lc_deflt_comm_let
*  Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
 AND v_ent_screen        IS INITIAL.
*  End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115

    PERFORM f_save_pdf_applictn_server.
  ENDIF. " IF v_comm_meth = lc_deflt_comm_let

*** EOC BY SAYNADAS on 08-MAR-2018 for save PDF in application server
************BOC by MODUTTA on 18.07.2017 for print & archive****************************
*  post form processing
  IF lst_sfpoutputparams-arcmode <> '1' AND
     v_ent_screen        IS INITIAL.
    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = 'PDF' "  class
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
*     Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
*     COMMINT only if the subroutine is not called in update task
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1' AND
*  ENDIF. " IF lv_trtyp NE lc_a

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT_ZSOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_zsoc.

* ****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers
****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_ZSOC'. " Name of Form Object
*** BOC BY SAYANDAS
  CONSTANTS: lc_zsqt           TYPE sna_kschl VALUE 'ZSQT',   " Message type
             lc_zsqs           TYPE sna_kschl VALUE 'ZSQS',   " Message type
             lc_msgnr_165      TYPE sy-msgno  VALUE '165',     " ABAP System Field: Message Number
             lc_msgnr_166      TYPE sy-msgno  VALUE '166',     " ABAP System Field: Message Number
             lc_msgid          TYPE sy-msgid  VALUE 'ZQTC_R2', " ABAP System Field: Message ID
             lc_err            TYPE sy-msgty  VALUE 'E',       " ABAP System Field: Message Type
             lc_deflt_comm_let TYPE ad_comm   VALUE 'LET'.      " Communication Method (Key) (Business Address Services)


  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true. "Comment by MODUTTA on 11-May-18 for INC0194261
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc IS NOT INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
    v_retcode = 900.
    RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = lc_msgid
              msg_nr                 = lc_msgnr_166
              msg_ty                 = lc_err
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          .
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.

    CALL FUNCTION lv_funcname "'/1BCDWB/SM00000068'
      EXPORTING
        /1bcdwb/docparams    = lst_sfpdocparams
        im_header            = st_header
        im_xstring           = v_xstring
        im_langu             = v_langu
        im_vbco3             = st_vbco3
        im_address           = st_address
*** BOC BY SAYANDAS
        im_sub_final         = i_sub_final
*** EOC BY SAYANDAS
        im_final             = i_final
        im_calc              = st_calc
        im_society_logo      = v_society_logo
        im_vbap              = vbap
        im_remit_to_uk       = v_remit_to_uk
        im_remit_to_usa      = v_remit_to_usa
*       im_detach            = v_detach
        im_order_uk          = v_com_uk
        im_order_usa         = v_com_usa
        im_footer1           = v_footer1
        im_footer2           = v_footer2
        im_remit_to_tbt_usa  = v_remit_to_tbt_usa
        im_remit_to_tbt_uk   = v_remit_to_tbt_uk
        im_banking1_tbt_usa  = v_banking1_tbt_usa
        im_banking1_tbt_uk   = v_banking1_tbt_uk
        im_cust_serv_tbt_usa = v_cust_serv_tbt_usa
        im_cust_serv_tbt_uk  = v_cust_serv_tbt_uk
        im_email_tbt_usa     = v_email_tbt_usa
        im_email_tbt_uk      = v_email_tbt_uk
        im_credit_tbt_usa    = v_credit_tbt_usa
        im_credit_tbt_uk     = v_credit_tbt_uk
        im_footer_tbt        = v_footer
*** BOC BY SAYANDAS
        im_v_society_text    = v_society_text
        im_comp_name         = v_comp_name
*** EOC BY SAYANDAS
        im_customer          = v_cust
        im_remit_to_scc      = v_remit_to_scc
        im_remit_to_scm      = v_remit_to_scm
        im_banking1_scc      = v_banking1_scc
        im_banking1_scm      = v_banking1_scm
        im_cust_serv_scc     = v_cust_serv_scc
        im_cust_serv_scm     = v_cust_serv_scm
        im_email_scc         = v_email_scc
        im_email_scm         = v_email_scm
        im_credit_scc        = v_credit_scc
        im_credit_scm        = v_credit_scm
        im_footer_scc        = v_footer
        im_footer_scm        = v_footer
*** BOC BY SAYANDAS
        im_barcode           = v_barcode
*** EOC BY SAYNADAS
        im_seller_reg        = v_seller_reg
        im_email             = v_email_id
        im_tax               = v_tax
*** BOC BY SAYANDAS
        im_credit_crd        = v_credit_crd
        im_payment           = v_payment
        im_payment_scc       = v_payment_scc
        im_payment_scm       = v_payment_scm
        im_mis_msg           = v_mis_msg
*** EOC BY SAYANDAS
        im_credit_email      = v_credit_crd_email "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
        im_po_type           = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      IMPORTING
        /1bcdwb/formoutput   = st_formoutput
      EXCEPTIONS
        usage_error          = 1
        system_error         = 2
        internal_error       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
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
        v_retcode = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL
*** BOC BY SAYNADAS on 08-MAR-2018 for save PDF in application server
*  IF i_vbpa[] IS NOT INITIAL.
*    DATA(li_vbpa) = i_vbpa[].
*    SORT li_vbpa BY adrnr.
*    DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr.

** Fetch title and name
*    SELECT addrnumber, " Address number
*           title,      " Form-of-Address Key
*           name1,      " Name 1
*           deflt_comm  " Communication Method (Key) (Business Address Services)
*      INTO TABLE @DATA(li_adrc)
*      FROM adrc        " Addresses (Business Address Services)
*      FOR ALL ENTRIES IN @li_vbpa
*      WHERE addrnumber EQ @li_vbpa-adrnr.
*    IF sy-subrc EQ 0.
*      SORT li_adrc  BY addrnumber.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF i_vbpa[] IS NOT INITIAL
*  READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_address-adrnr_bp
*                                                   BINARY SEARCH.
*
*  IF sy-subrc EQ 0.
  IF v_comm_meth = lc_deflt_comm_let
*  Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  AND v_ent_screen        IS INITIAL.
*  End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
    PERFORM f_save_pdf_applictn_server.
  ENDIF. " IF v_comm_meth = lc_deflt_comm_let

*** EOC BY SAYNADAS on 08-MAR-2018 for save PDF in application server
************BOC by MODUTTA on 18.07.2017 for print & archive****************************
*  post form processing
  IF lst_sfpoutputparams-arcmode <> '1' AND
     v_ent_screen        IS INITIAL.
    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = 'PDF' "  class
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
*     Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
*     COMMINT only if the subroutine is not called in update task
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1' AND

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LANGU  text
*      <--P_I_STD_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_stxh_data  USING    fp_v_langu TYPE syst_langu " ABAP System Field: Language Key of Text Environment
                      CHANGING fp_i_std_text TYPE tt_std_text.

*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char10,   " Low of type CHAR2
           high   TYPE char10,   " High of type CHAR2
         END OF lty_range.

***Local Variable Declaration
  DATA: lst_range TYPE lty_range,
        lir_range TYPE STANDARD TABLE OF lty_range.

***Local constant declaration
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F027*', " R of type CHAR10
             lc_sign   TYPE ddsign         VALUE 'I',          " Type of SIGN component in row type of a Ranges type
             lc_option TYPE ddoption       VALUE 'CP'.         " Type of OPTION component in row type of a Ranges type

***Populate local range table
  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_r.
  APPEND lst_range TO lir_range.

*** Fetch data from STXH table
  SELECT
  tdname      " Name
    FROM stxh " STXD SAPscript text file lines
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st
    AND tdspras = v_langu.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF. " IF sy-subrc IS INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_DRCT_DBT_MNDT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_call_drct_dbt_mndt .
  DATA: lv_scenario_f044 TYPE char3,      " Scenario_f044 of type CHAR3
        lv_adrnr_f044    TYPE adrnr,      " Address
        lv_kunnr_f044    TYPE kunnr,      " Customer Number
        lv_langu_f044    TYPE spras.      " Language Key

*  Assign language to variable
  lv_langu_f044     = v_langu.
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
  lv_kunnr_f044           = st_address-kunnr_bp.
  lv_adrnr_f044           = st_address-adrnr_bp.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*** Calling FM for F044 related changes
  IF v_vkorg_f044 IN r_vkorg_f044
    AND v_zlsch_f044 NOT IN r_zlsch_f044
    AND v_kvgr1_f044 NOT IN r_kvgr1_f044.  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421

    IF v_tbt = abap_true.
      lv_scenario_f044 = 'TBT'.
    ELSEIF v_scc = abap_true.
      lv_scenario_f044 = 'SCC'.
    ELSEIF v_scm = abap_true.
      lv_scenario_f044 = 'SCM'.
    ENDIF. " IF v_tbt = abap_true

    CALL FUNCTION 'ZQTC_DIR_DEBIT_MANDT_F044'
      EXPORTING
        im_vkorg      = v_vkorg_f044
*       IM_ZLSCH      =
        im_waerk      = v_waerk_f044
        im_scenario   = lv_scenario_f044
        im_ihrez      = v_ihrez_f044
        im_adrnr      = lv_adrnr_f044
        im_kunnr      = lv_kunnr_f044
        im_langu      = lv_langu_f044
        im_xstring    = v_xstring
      IMPORTING
        ex_formoutput = st_formoutput_f044.
  ENDIF. " IF lv_vkorg_f044 IN r_vkorg_f044
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY_F044
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_FORMOUTPUT  text
*----------------------------------------------------------------------*
FORM f_convert_pdf_binary_f044 USING fp_lst_formoutput TYPE fpformoutput. " Form Output (PDF, PDL)
*******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = fp_lst_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.
