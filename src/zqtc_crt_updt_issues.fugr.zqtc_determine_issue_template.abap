FUNCTION zqtc_determine_issue_template.
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_DETERMINE_ISSUE_TEMPLATE
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* In order to create the new Media Issue with reference to the existing
* Media Issue called “Issue Template”, we hace refered the logic implemented
* inside standard program RJPMPGEN (specifically 2 of the Subroutines
* MARA_SICHERN_PREPARE and MARA_SICHERN).
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MED_PRODUCT) TYPE  ISMREFMDPROD
*"  EXPORTING
*"     REFERENCE(EX_ISSUE_TEMPLATE) TYPE  MATNR
*"  EXCEPTIONS
*"      EXC_TEMP_ISSUE_MISSING
*"----------------------------------------------------------------------

* Determine Template Material for Media Product Generation
  PERFORM f_det_issue_template    USING    im_med_product
                                  CHANGING ex_issue_template.

ENDFUNCTION.
