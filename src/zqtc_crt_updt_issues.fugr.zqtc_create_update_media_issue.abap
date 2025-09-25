FUNCTION zqtc_create_update_media_issue.
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_CREATE_UPDATE_MEDIA_ISSUE
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* In order to create the new Media Issue with reference to the existing
* Media Issue called “Issue Template”, we hace refered the logic implemented
* inside standard program RJPMPGEN (specifically 2 of the Subroutines
* MARA_SICHERN_PREPARE and MARA_SICHERN).  Standard logic is not considering
* MPOP (table MVOP) values , we have implemented additional logic to consider these,
* since those field values are part of our Conversion / Interface requirement.
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MED_ISSUE_MARA) TYPE  ZSTQTC_MEDIA_ISSUE_MARA
*"     REFERENCE(IM_MED_ISSUE_MAKT) TYPE  ZSTQTC_MEDIA_ISSUE_MAKT
*"     REFERENCE(IM_MED_ISSUE_MARC) TYPE  ZSTQTC_MEDIA_ISSUE_MARC
*"     REFERENCE(IM_MED_ISSUE_MVKE) TYPE  ZSTQTC_MEDIA_ISSUE_MVKE
*"     REFERENCE(IM_MED_ISSUE_IDCD) TYPE  ZTQTC_MEDIA_ISSUE_IDCD
*"  EXPORTING
*"     REFERENCE(EX_IS_ERROR) TYPE  FLAG
*"     REFERENCE(EX_MESSAGE_TAB) TYPE  MERRDAT_TT
*"  EXCEPTIONS
*"      EXC_MED_PROD_INVALID
*"      EXC_MED_PROD_LOCKED
*"      EXC_TEMP_ISSUE_MISSING
*"----------------------------------------------------------------------

* Data Declaration
  DATA:
    lst_med_prod  TYPE mara,
    lst_issue_seq TYPE jptmg0.

* Validate Media Product
  PERFORM f_validate_med_product USING    im_med_issue_mara-ismrefmdprod
                                 CHANGING lst_med_prod.

* Lock Issue Sequence (Media Product)
  PERFORM f_lock_issue_sequence  USING    im_med_issue_mara-ismrefmdprod.

* Check if the Media Issue needs to created / changed
  PERFORM f_check_media_issue    USING    im_med_issue_mara
                                          im_med_issue_makt
                                 CHANGING lst_issue_seq.

* Process Media Issue
  PERFORM f_process_media_issue  USING    im_med_issue_mara
                                          im_med_issue_makt
                                          im_med_issue_marc
                                          im_med_issue_mvke
                                          im_med_issue_idcd
                                          lst_med_prod
                                          lst_issue_seq
                                 CHANGING ex_message_tab
                                          ex_is_error.

* Initialize Global Variables
  PERFORM f_init_global_vars.

ENDFUNCTION.
