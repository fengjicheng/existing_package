*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_REMINDER_ARCHIVE (FM)
* PROGRAM DESCRIPTION:   FM to link the pdf form to BP
* DEVELOPER:             AGUDURKHAD
* CREATION DATE:         11/11/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtcr_reminder_archive.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PARTNER) TYPE  BU_PARTNER
*"     REFERENCE(IV_DOCUMENT) TYPE  XSTRING
*"     VALUE(IV_COMMIT) TYPE  FLAG OPTIONAL
*"  EXCEPTIONS
*"      ERROR_ARCHIV
*"      ERROR_COMMUNICATIONTABLE
*"      ERROR_CONNECTIONTABLE
*"      ERROR_KERNEL
*"      ERROR_PARAMETER
*"      ERROR_FORMAT
*"      BLOCKED_BY_POLICY
*"      BP_NOT_FOUND
*"      NOT_VALID_DOCUMENT
*"----------------------------------------------------------------------
  PERFORM clear_global_variables.
  PERFORM validate_input USING iv_partner
                               iv_document.

  PERFORM archive USING iv_partner
                        iv_document
                        iv_commit.
ENDFUNCTION.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_GLOBAL_VARIABLES
*&---------------------------------------------------------------------*
*       Clear all the global varaibles used
*----------------------------------------------------------------------*
FORM clear_global_variables.
  CLEAR lt_arc_i_tab.
ENDFORM.               " CLEAR_GLOBAL_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_INPUT
*&---------------------------------------------------------------------*
*       Validate the input data
*----------------------------------------------------------------------*
FORM validate_input USING iv_partner  TYPE  bu_partner
                          iv_document TYPE  xstring.
  DATA: lv_partner TYPE bu_partner,
        length     TYPE i.

  SELECT SINGLE partner
         INTO  lv_partner
         FROM  but000
         WHERE partner = iv_partner.
  IF sy-subrc <> 0.
    RAISE bp_not_found.
  ENDIF.

  length = xstrlen( iv_document ).

  IF length <= 0.
    RAISE not_valid_document.
  ENDIF.
ENDFORM.               " VALIDATE_INPUT
*&---------------------------------------------------------------------*
*&      Form  ARCHIVE
*&---------------------------------------------------------------------*
*     Attaching the pdf to the partner
*----------------------------------------------------------------------*
FORM archive  USING iv_partner  TYPE  bu_partner
                    iv_document TYPE  xstring
                    iv_commit   TYPE  flag.

  ls_arc_i_tab-sap_object = gc_sap_object.
  ls_arc_i_tab-object_id  = iv_partner.
  ls_arc_i_tab-ar_object  = gc_ar_object.
  ls_arc_i_tab-formarchiv = gc_formarchiv.
  ls_arc_i_tab-reserve    = 'PDF'.
  APPEND ls_arc_i_tab TO lt_arc_i_tab.
  CLEAR ls_arc_i_tab.

  CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
    EXPORTING
      documentclass            = 'PDF'
      document                 = iv_document
*     VSCAN_PROFILE            = '/SCMS/KPRO_CREATE'
    TABLES
      arc_i_tab                = lt_arc_i_tab
*     PDF                      =
    EXCEPTIONS
      error_archiv             = 1
      error_communicationtable = 2
      error_connectiontable    = 3
      error_kernel             = 4
      error_parameter          = 5
      error_format             = 6
      blocked_by_policy        = 7
      OTHERS                   = 8.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        RAISE error_archiv.
      WHEN 2.
        RAISE error_communicationtable.
      WHEN 3.
        RAISE error_connectiontable.
      WHEN 4.
        RAISE error_kernel.
      WHEN 5.
        RAISE error_parameter.
      WHEN 6.
        RAISE error_format.
      WHEN 7.
        RAISE blocked_by_policy.
      WHEN OTHERS.
        RAISE others.
    ENDCASE.
  ELSE.
    IF iv_commit EQ 'X'.
      COMMIT WORK.
    ENDIF  .
  ENDIF.   " IF sy-subrc <> 0.
ENDFORM.               " ARCHIVE
