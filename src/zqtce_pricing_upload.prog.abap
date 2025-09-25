*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCE_PRICING_UPLOAD
* PROGRAM DESCRIPTION: Pricing Upload for Non-Interface Prices
* DEVELOPER: Writtick Roy/Lucky Kodwani
* CREATION DATE:   2017-01-13
* OBJECT ID: E081
* TRANSPORT NUMBER(S): ED2K904117
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K906023
* REFERENCE NO: CR# 512
* DEVELOPER: Writtick Roy
* DATE:  2017-05-11
* DESCRIPTION: In stead of Sales Deal, Search Term has to be used
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Report  ZQTCE_PRICING_UPLOAD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtce_pricing_upload NO STANDARD PAGE HEADING
                            LINE-SIZE  132
                            LINE-COUNT 65
                            MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_pricing_upload_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtcn_pricing_upload_sel IF FOUND.

*Include for Subroutines
INCLUDE zqtcn_pricing_upload_sub IF FOUND.

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Clear all variables .
  PERFORM f_clear_all.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                                *
*----------------------------------------------------------------------*
* Validate Applications
AT SELECTION-SCREEN ON p_kappl.
  PERFORM f_validate_kappl.

* Validate Condition Type
AT SELECTION-SCREEN ON p_kschl.
  PERFORM f_validate_kschl.

* Validate Table Name
AT SELECTION-SCREEN ON p_tname.
  PERFORM f_validate_tname.

* Validate File Name
AT SELECTION-SCREEN ON p_file.
  PERFORM f_validate_file_name.

AT SELECTION-SCREEN ON p_hdr_ln.
  PERFORM f_validate_header_line.
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON VALUE REQUEST                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  IF rb_appl IS INITIAL. "Presentation Server
* Get F4 help for presentation server
    PERFORM f_f4_presentation USING   syst-cprog
                                      c_field
                             CHANGING p_file.

  ELSE. " ELSE -> IF rb_appl IS INITIAL
* Get F4 help for application server
    PERFORM f_f4_application CHANGING p_file.
  ENDIF. " IF rb_appl IS INITIAL

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF sy-ucomm = c_rucomm. "'RUCOMM'.
    CLEAR p_file.
  ELSEIF sy-ucomm = c_onli. "'ONLI'.
    IF rb_appl IS INITIAL. "Presentation Server
* Validate presentation Server
      PERFORM f_validate_presentation USING p_file.
    ELSE. " ELSE -> IF rb_appl IS INITIAL
* Validate application Server
      PERFORM f_validate_application  USING p_file.
    ENDIF. " IF rb_appl IS INITIAL
  ENDIF. " IF sy-ucomm = c_rucomm

*----------------------------------------------------------------------*
*                      START-OF-SELECTION                              *
*----------------------------------------------------------------------*
START-OF-SELECTION.
* Processing Steps
  PERFORM f_processing_steps USING p_kappl
                                   p_kschl
                                   p_tname
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
                                   p_s_term.
*                                  p_sls_dl.
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023

*----------------------------------------------------------------------*
*                      END-OF-SELECTION                                *
*----------------------------------------------------------------------*
END-OF-SELECTION.
* Display Alv
  PERFORM  f_display_alv   USING  <st_cond_rc>.
