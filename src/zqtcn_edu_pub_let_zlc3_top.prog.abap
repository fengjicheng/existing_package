*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EDU_PUBLISH_LET_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDU_PUBLISH_LET_TOP
* PROGRAM DESCRIPTION: Decleraions
* DEVELOPER: Prabhu(MIMMADISET)
* CREATION DATE: 11/19/2019
* OBJECT ID: F055
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
TABLES : tnapr,    " Processing programs for output
         nast,     " Message Status
         toa_dara. " SAP ArchiveLink structure of a DARA line


DATA:i_content_hex TYPE solix_tab,                        " Content table
     st_formoutput TYPE fpformoutput ,     " Form Output (PDF, PDL)
     li_hdr_loc    TYPE zstqtc_edu_letter_hdr_f055 .       " Structure for LOC form

DATA:
  v_logo         TYPE salv_de_selopt_low VALUE 'ZJWILEY_LOGO_F046_AC',      "Logo
  v_bmp          TYPE xstring,                                      " Logo xsting
  v_border       TYPE xstring,                                      " Border image
  v_sc_image     TYPE xstring,                                      " Successfully completed image
  v_ent_retco    TYPE sy-subrc ,                                    " ABAP System Field: Return Code of ABAP Statements
  v_ent_screen   TYPE c ,                                           " Screen of type Character
  v_formname     TYPE fpname ,                                      " Formname.
  v_send_email   TYPE ad_smtpadr ,                                  " E-Mail Address
  v_output_typ   TYPE sna_kschl ,                                   " Message type
  v_retcode      TYPE sy-subrc,                                     " Return code
  v_trscript     TYPE string,
  ex_mime_helper TYPE REF TO cl_gbt_multirelated_service.
CONSTANTS : c_form_name TYPE fpname   VALUE 'ZQTC_FRM_LH_LOC3_F055',  " Form
            c_x         TYPE char1    VALUE 'X',                               " for x
            c_w         TYPE char1    VALUE 'W',                               " for Web
            c_1         TYPE na_nacha VALUE '1',                               " Print Function
            c_zstuid    TYPE bu_id_type VALUE 'ZSTUID',                        " Student identifiction
            c_5         TYPE na_nacha VALUE '5',                               " Email Function
            c_pdf       TYPE toadv-doc_type    VALUE 'PDF',                    " for PDF
            c_e         TYPE char1    VALUE 'E',                              " Error Message / English
            c_zqtc_r2   TYPE syst-msgid VALUE 'ZQTC_R2',                       " Message ID
            c_devid     TYPE zdevid VALUE 'F055',                              "LOC form dev id
            c_msg_no    TYPE syst-msgno VALUE '000'.                          " Message Number
