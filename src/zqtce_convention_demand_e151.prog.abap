*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_CONVENTION_DEMAND_E151
* PROGRAM DESCRIPTION: Custom report from to create conference purchase
* requisition based on the file received from JFDS
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-03-01
* OBJECT ID: E151
* TRANSPORT NUMBER(S): ED2K904707(W),ED2K904827(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K905904
* Reference No:  JIRA Defect# ERP-1947
* Developer: Monalisa Dutta
* Date:  2017-05-05
* Description: Conference  Po already exists for the issue to be displayed
* in output
*------------------------------------------------------------------- *

*&---------------------------------------------------------------------*
*& Report  ZQTCE_CONVENTION_DEMAND_E151
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtce_convention_demand_e151 NO STANDARD PAGE HEADING
                                    MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_convention_demand_top. " For top declaration

**Include for Selection Screen
INCLUDE zqtcn_convention_demand_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_convention_demand_f01. " For subroutines
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_doc_i[]
                                       s_acc_i[].

* Populate constants from ZCACONSTANT table
  PERFORM f_get_constants CHANGING i_constant.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON VALUE REQUEST                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  IF rb_appl IS INITIAL. "Presentation Server
    PERFORM f_f4_presentation USING   syst-cprog
                                      c_field
                             CHANGING p_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM f_f4_application CHANGING p_file.
  ENDIF. " IF rb_appl IS INITIAL
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                                   *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
* Validate Purchasing document type
  PERFORM f_validate_doc_type USING  s_doc_i[].

* Validate Account Assignment
  PERFORM f_validate_acc_asgnmnt USING  s_acc_i[].

  IF sy-ucomm = c_rucomm. "'RUCOMM'.
    CLEAR p_file.
  ELSEIF sy-ucomm = c_onli. "'ONLI'.
    IF rb_appl IS INITIAL. "Presentation Server
      PERFORM f_validate_presentation USING p_file.
    ELSE. " ELSE -> IF rb_appl IS INITIAL
      PERFORM f_validate_application  USING p_file.
    ENDIF. " IF rb_appl IS INITIAL
  ENDIF.
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
  IF rb_appl IS INITIAL. "If radio button presentation server is selected
    PERFORM  f_read_file_frm_pres_server USING    p_file
                                         CHANGING i_upload_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM  f_read_file_frm_app_server  USING    p_file
                                         CHANGING i_upload_file.
  ENDIF. " IF rb_appl IS INITIAL

  IF i_upload_file IS NOT INITIAL.
*    Perform to create purchase requisition
    PERFORM f_create_puchase_req USING    i_upload_file
                                 CHANGING i_output.
  ENDIF.

*--------------------------------------------------------------------*
*   END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.
  IF i_output IS NOT INITIAL.
    SORT i_output BY purchase_req
                     purchase_order
                     line_item
                     material
                     type
                     id
                     number
                     message.

    DELETE ADJACENT DUPLICATES FROM i_output COMPARING ALL FIELDS.
    IF rb_appl IS NOT INITIAL.
*      Write file in application server
      PERFORM f_write_to_app_server USING i_output
                                          p_file.
    ELSE.
*      Write file in presentation server
      PERFORM f_write_to_pres_server USING  i_output
                                            p_file.
    ENDIF.

*    Perform to display output in ALV
    PERFORM f_display_output CHANGING i_output.

  ENDIF.
