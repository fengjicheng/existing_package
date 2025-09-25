*&---------------------------------------------------------------------*
*& Report  ZQTCR_ENC_REPORT_R093
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916190
* REFERENCE NO:  R093
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-09-18
* DESCRIPTION:   ENC_Report
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916792
* REFERENCE NO:  R093
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-11-11
* DESCRIPTION:   New Enhancement (Commission rate owed to a partner
*                                 institution added to the order)
*----------------------------------------------------------------------*
* REVISION NO:   ED2K918850
* REFERENCE NO:  R093 / ERPM-18238
* DEVELOPER:     MURALI(MIMMADISET)
* DATE:          2020-10-07
* DESCRIPTION:   Commissions Report changes
*----------------------------------------------------------------------*
REPORT zqtcr_enc_report_r093 NO STANDARD PAGE HEADING.
*&---------------------------------------------------------------------*
*---------------------------- INCLUDES USED----------------------------*
*
* INCLUDE ZQTCN_ENC_REPORT_R093_TOP             "Declarations
*
*----------------------------------------------------------------------*
INCLUDE zqtcn_enc_report_r093_top.

*----------------------------------------------------------------------*
*       CLASS lclenc_report DEFINITION
*----------------------------------------------------------------------*
CLASS lclenc_report DEFINITION FINAL.
  PUBLIC SECTION.

    METHODS:
      meth_get_data, " Data Selection
      meth_generate_output. " Generating output

*----------------------------------------------------------------------*
*----CODE_ADD_1 - Begin------------------------------------------------*
*    In this section we will define the private methods which can
*      be implemented to set the properties of the ALV
  PRIVATE SECTION.
    METHODS:
      meth_set_pf_status " Set PF Status
        CHANGING
          ch_alv TYPE REF TO cl_salv_table,
      meth_set_layout " Set layout
        CHANGING
          ch_alv TYPE REF TO cl_salv_table,
      meth_set_columns " Set the various column properties
        CHANGING
          ch_alv TYPE REF TO cl_salv_table,
      meth_set_headings " set the column headings
        IMPORTING
          i_field_name   TYPE lvc_fname
          i_long_heading TYPE char40
          i_medi_heading TYPE char20
          i_shor_heading TYPE char10
          i_length       TYPE lvc_outlen
          i_hide_column  TYPE char1 OPTIONAL
          i_edit_mask    TYPE lvc_edtmsk OPTIONAL
        CHANGING
          ch_cols        TYPE REF TO cl_salv_columns.

*----CODE_ADD_1 - End--------------------------------------------------*
*
ENDCLASS.                    "lclenc_report DEFINITION

*--------------------------- SELECTION SCREEN--------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-036.
SELECT-OPTIONS : so_pu FOR lfa1-lifnr MATCHCODE OBJECT kred_c,
                 so_cdat FOR  veda-vbegdat.
PARAMETERS     : p_grade AS CHECKBOX USER-COMMAND dummy,
                 p_hold  TYPE char1 DEFAULT 'N' OBLIGATORY MODIF ID g1.
SELECTION-SCREEN END OF BLOCK b1.

*--------------------------AT SELECTION SCREEN OUTPUT------------------*
AT SELECTION-SCREEN OUTPUT.

* Showing / hiding the p_hold field
  LOOP AT SCREEN.
    IF screen-group1 EQ 'G1'.
      IF p_grade EQ 'X'.
        screen-input  = 1.
      ELSE.
        screen-input  = 0.
      ENDIF.
    ENDIF.

* Showing input elements like mandatory
    IF screen-name EQ 'P_PU' OR screen-name EQ 'SO_CDAT-LOW'.
      screen-required = 2.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

*--------------------------AT SELECTION SCREEN-------------------------*
AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'ONLI'.
    IF so_pu IS INITIAL OR so_cdat IS INITIAL. " Obligatory
      MESSAGE text-042 TYPE 'E'.
    ELSE.
      SELECT *
        FROM lfa1
        INTO TABLE @DATA(lt_lfa1)
        WHERE lifnr IN @so_pu.
      IF sy-subrc NE 0.
        sscrfields-ucomm = ' ' .
        MESSAGE text-037 TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  DATA o_report TYPE REF TO lclenc_report. " Report Object reference
  CREATE OBJECT o_report.
  o_report->meth_get_data( ).
  o_report->meth_generate_output( ).

*----------------------------------------------------------------------*
*       CLASS lclenc_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lclenc_report IMPLEMENTATION.
  METHOD meth_get_data.

    DATA : li_cds TYPE TABLE OF zcds_enco_rpt.
    DATA:lv_day_out TYPE sydatum.

*   Data Selection from CDS View
    IF p_grade IS INITIAL.
      SELECT *
        FROM zcds_enco_rpt
        INTO TABLE li_cds
        WHERE university_partner IN so_pu
          AND ( start_date IN so_cdat OR
               transferred_out_date IN so_cdat OR "* Begin by mimmadiset 07/10/2020 ERPM-18238
               transferred_in_date IN so_cdat OR
               exchanged_in_date IN so_cdat OR
               exchanged_out_date IN so_cdat OR
               refunded_date IN so_cdat )."* End by mimmadiset 07/10/2020 ERPM-18238
    ELSE.
      SELECT *
        FROM zcds_enco_rpt
        INTO TABLE li_cds
        WHERE university_partner IN so_pu
          AND ( grade_date  IN so_cdat OR
                transferred_out_date IN so_cdat OR "* Begin by mimmadiset 07/10/2020 ERPM-18238
               transferred_in_date IN so_cdat OR
               exchanged_in_date IN so_cdat OR
               exchanged_out_date IN so_cdat OR
               refunded_date IN so_cdat )"* End by mimmadiset 07/10/2020 ERPM-18238
      AND hold_status EQ p_hold.
    ENDIF.
    IF sy-subrc EQ 0.
      LOOP AT li_cds INTO DATA(lw_cds).
* Begin by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
        w_final-partner_no                 = lw_cds-university_partner.
        w_final-partner_name               = lw_cds-partner_name.
* End by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
        w_final-student                    = lw_cds-student.
        w_final-contract                   = lw_cds-contract.
        w_final-item                       = lw_cds-item.
        w_final-product_code               = lw_cds-product_code.
        w_final-product_name               = lw_cds-product_name.
        CALL FUNCTION 'QSS0_FLTP_TO_CHAR_CONVERSION'
          EXPORTING
            i_number_of_digits = 0
            i_fltp_value       = lw_cds-units
          IMPORTING
            e_char_field       = w_final-units.
        w_final-street                     = lw_cds-street.
        w_final-city                       = lw_cds-city.
        w_final-state                      = lw_cds-state.
        w_final-zip                        = lw_cds-zip.
        w_final-dob                        = lw_cds-dob.
        IF lw_cds-gender_m IS NOT INITIAL.
          w_final-gender                   = 'Male'(040).
        ELSEIF lw_cds-gender_f IS NOT INITIAL.
          w_final-gender                   = 'Female'(041).
        ENDIF.
        w_final-phone                      = lw_cds-phone.
        w_final-email                      = lw_cds-email.
        w_final-total_price                = lw_cds-total_price.
        w_final-grade_value                = lw_cds-grade_value.
        w_final-grade_date                 = lw_cds-grade_date.
        w_final-start_date                 = lw_cds-start_date.
        w_final-new_product_after_transfer = lw_cds-new_product_after_transfer.
        w_final-transferred                = lw_cds-transferred.
        IF lw_cds-new_product_after_transfer EQ 1.
          w_final-transferred_date         = lw_cds-transferred_in_date.
        ENDIF.
        IF lw_cds-transferred EQ 1.
          w_final-transferred_date         = lw_cds-transferred_out_date.
        ENDIF.
        w_final-refunded                   = lw_cds-refunded.
        w_final-refunded_date              = lw_cds-refunded_date.
        w_final-new_product_after_exchange = lw_cds-new_product_after_exchange.
        w_final-exchanged                  = lw_cds-exchanged.
        IF lw_cds-new_product_after_exchange EQ 1.
          w_final-exchanged_date           = lw_cds-exchanged_in_date.
        ENDIF.
        IF lw_cds-exchanged EQ 1.
          w_final-exchanged_date           = lw_cds-exchanged_out_date.
        ENDIF.
* Begin by mimmadiset 07/10/2020 ERPM-18238
**1.  If the Transfer / Drop occurs in the same month as the Contract Start date
**    Set the Commission amounts to 0 for those lines.
        DATA(lv_day_in) = lw_cds-start_date.
        IF lv_day_in IS NOT INITIAL.
          CALL FUNCTION 'LAST_DAY_OF_MONTHS'
            EXPORTING
              day_in            = lv_day_in
            IMPORTING
              last_day_of_month = lv_day_out.
          IF lw_cds-transferred_out_date BETWEEN lw_cds-start_date AND
                                                 lv_day_out.
            lw_cds-commission_rate = 0.
          ELSEIF lw_cds-refunded_date BETWEEN lw_cds-start_date AND
                                                 lv_day_out.
            lw_cds-commission_rate = 0.
          ELSE.
**2.  If the Transfer / Drop occurs in the following month as the Contract Start date
**  Set the Commission amounts to amount * -1 for those lines.
            CLEAR:lv_day_in.
            lv_day_in = lv_day_out.
            lv_day_in = lv_day_in + 1.  "following month start date
            CALL FUNCTION 'LAST_DAY_OF_MONTHS'
              EXPORTING
                day_in            = lv_day_in
              IMPORTING
                last_day_of_month = lv_day_out.
            IF lw_cds-transferred_out_date BETWEEN lv_day_in AND
                                                    lv_day_out.
              lw_cds-commission_rate = lw_cds-commission_rate * -1.
            ELSEIF lw_cds-refunded_date BETWEEN lv_day_in AND
                                                   lv_day_out.
              lw_cds-commission_rate = lw_cds-commission_rate * -1.
            ENDIF.
          ENDIF.
**  If an Exchange occurs - regardless if the month
**  Set the Commission amounts to 0 for those lines.
          IF lw_cds-exchanged_out_date IS NOT INITIAL.
            lw_cds-commission_rate = 0.
          ENDIF.
        ENDIF.
* End by mimmadiset 07/10/2020 ERPM-18238
* Begin by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
        w_final-commission_rate            = lw_cds-commission_rate.
* End by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792

        APPEND w_final TO i_final.
        CLEAR : lw_cds, w_final.
      ENDLOOP.
    ELSE.
      MESSAGE text-001 TYPE 'I' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "meth_get_data

  METHOD meth_generate_output.
* New ALV instance
*   We are calling the static Factory method which will give back
*   the ALV object reference.
*
* exception class
    DATA: lo_msg    TYPE REF TO cx_salv_msg,
          lv_string TYPE string.
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = o_alv
          CHANGING
            t_table      = i_final ).
      CATCH cx_salv_msg INTO lo_msg.
        lv_string = lo_msg->get_text( ).
        MESSAGE lv_string TYPE 'I'.
    ENDTRY.
*----------------------------------------------------------------------*
*----CODE_ADD_2 - Begin------------------------------------------------*
*    In this area we will call the methods which will set the
*      different properties to the ALV
    CALL METHOD meth_set_pf_status " Setting up the PF Status
      CHANGING
        ch_alv = o_alv.
    CALL METHOD meth_set_layout "Setting up the layout
      CHANGING
        ch_alv = o_alv.
    CALL METHOD me->meth_set_columns " Setting up the Columns
      CHANGING
        ch_alv = o_alv.
*----CODE_ADD_2 - End--------------------------------------------------*

    o_alv->display( ). " Displaying the ALV
  ENDMETHOD.                    "meth_generate_output

*----------------------------------------------------------------------*
*----CODE_ADD_3 - Begin------------------------------------------------*
*    In this area we will implement the methods which are defined in
*      the class definition
  METHOD meth_set_pf_status.
    DATA : lo_selections TYPE REF TO cl_salv_selections.
    ch_alv->set_screen_status(
report = sy-repid
pfstatus = 'SALV_TABLE_STANDARD'
set_functions = ch_alv->c_functions_all
).
    lo_selections = ch_alv->get_selections( ).
    lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  ENDMETHOD.                    "meth_set_pf_status
  METHOD meth_set_layout.
    DATA: lo_layout  TYPE REF TO cl_salv_layout,
          lf_variant TYPE slis_vari,
          ls_key     TYPE salv_s_layout_key.

    " GET layout OBJECT
    lo_layout = ch_alv->get_layout( ).

    " SET LAYOUT save restriction
    "  1. SET LAYOUT KEY .. unique key identifies the differenet alvs
    ls_key-report = sy-repid.
    lo_layout->set_key( ls_key ).

    " 2. remove save layout the restriction.
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

    " SET INITIAL LAYOUT
    lo_layout->set_initial_layout( lf_variant ).

  ENDMETHOD.                    "meth_set_pf_status
  METHOD meth_set_columns.
*   Get all the Columns
    DATA: lo_cols        TYPE REF TO cl_salv_columns,
          lv_hide_column TYPE c,
          lo_msg         TYPE REF TO cx_sy_dyn_call_illegal_type,
          lv_string      TYPE string.

    CONSTANTS : lc_edit_mask TYPE lvc_edtmsk VALUE '==PDATE'. " MM/DD/YYYY format
    lo_cols = ch_alv->get_columns( ).

*   set the Column optimization
    lo_cols->set_optimize( abap_true ).

*   Process individual columns
*   Change the properties of the Columns
    IF p_grade IS NOT INITIAL.
      lv_hide_column = 'X'.
    ELSE.
      CLEAR lv_hide_column.
    ENDIF.
    TRY.
* Begin by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
*       "Partner Number
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'PARTNER_NO'
            i_long_heading = 'Partner No'(045)
            i_medi_heading = 'Partner No'(045)
            i_shor_heading = 'Partner No'(045)
            i_length       = '10'
          CHANGING
            ch_cols        = lo_cols.

*       "Partner Name
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'PARTNER_NAME'
            i_long_heading = 'Partner Name'(046)
            i_medi_heading = 'Partner Name'(046)
            i_shor_heading = 'Partner Name'(047)
            i_length       = '10'
          CHANGING
            ch_cols        = lo_cols.
* End by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792

*       "Student"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'STUDENT'
            i_long_heading = 'Student'(002)
            i_medi_heading = 'Student'(002)
            i_shor_heading = 'Student'(002)
            i_length       = '100'
          CHANGING
            ch_cols        = lo_cols.

*       "Contract"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'CONTRACT'
            i_long_heading = 'Contract'(043)
            i_medi_heading = 'Contract'(043)
            i_shor_heading = 'Contract'(043)
            i_length       = '10'
          CHANGING
            ch_cols        = lo_cols.

*       "Item"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'ITEM'
            i_long_heading = 'Item'(044)
            i_medi_heading = 'Item'(044)
            i_shor_heading = 'Item'(044)
            i_length       = '6'
          CHANGING
            ch_cols        = lo_cols.

*       "Product Code"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'PRODUCT_CODE'
            i_long_heading = 'Product Code'(003)
            i_medi_heading = 'Product Code'(003)
            i_shor_heading = 'Prdct Code'(004)
            i_length       = '10'
          CHANGING
            ch_cols        = lo_cols.

*       "Product Name"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'PRODUCT_NAME'
            i_long_heading = 'Product Name'(005)
            i_medi_heading = 'Product Name'(005)
            i_shor_heading = 'Prdct Name'(006)
            i_length       = '40'
          CHANGING
            ch_cols        = lo_cols.

*       "Units"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'UNITS'
            i_long_heading = 'Units'(007)
            i_medi_heading = 'Units'(007)
            i_shor_heading = 'Units'(007)
            i_length       = '30'
          CHANGING
            ch_cols        = lo_cols.

*       "Start Date"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'START_DATE'
            i_long_heading = 'Start Date'(008)
            i_medi_heading = 'Start Date'(008)
            i_shor_heading = 'Start Date'(008)
            i_length       = '10'
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "Street
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'STREET'
            i_long_heading = 'Street'(009)
            i_medi_heading = 'Street'(009)
            i_shor_heading = 'Street'(009)
            i_length       = '60'
          CHANGING
            ch_cols        = lo_cols.

*       "City"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'CITY'
            i_long_heading = 'City'(010)
            i_medi_heading = 'City'(010)
            i_shor_heading = 'City'(010)
            i_length       = '40'
          CHANGING
            ch_cols        = lo_cols.

*       "State"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'STATE'
            i_long_heading = 'State'(011)
            i_medi_heading = 'State'(011)
            i_shor_heading = 'State'(011)
            i_length       = '5'
          CHANGING
            ch_cols        = lo_cols.

*       "ZIP"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'ZIP'
            i_long_heading = 'Zip'(012)
            i_medi_heading = 'Zip'(012)
            i_shor_heading = 'Zip'(012)
            i_length       = '10'
          CHANGING
            ch_cols        = lo_cols.

*       "DOB"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'DOB'
            i_long_heading = 'DOB'(013)
            i_medi_heading = 'DOB'(013)
            i_shor_heading = 'DOB'(013)
            i_length       = '10'
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "Gender"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'GENDER'
            i_long_heading = 'Gender'(014)
            i_medi_heading = 'Gender'(014)
            i_shor_heading = 'Gender'(014)
            i_length       = '6'
          CHANGING
            ch_cols        = lo_cols.

*       "Phone"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'PHONE'
            i_long_heading = 'Phone'(015)
            i_medi_heading = 'Phone'(015)
            i_shor_heading = 'Phone'(015)
            i_length       = '30'
          CHANGING
            ch_cols        = lo_cols.

*       "Email"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'EMAIL'
            i_long_heading = 'Student Email'(016)
            i_medi_heading = 'Student Email'(016)
            i_shor_heading = 'Std Email'(017)
            i_length       = '50'
          CHANGING
            ch_cols        = lo_cols.

*       "Total Price"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'TOTAL_PRICE'
            i_long_heading = 'Total Price'(018)
            i_medi_heading = 'Total Price'(018)
            i_shor_heading = 'Tot Price'(019)
            i_length       = '16'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Grade"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'GRADE_VALUE'
            i_long_heading = 'Grade'(020)
            i_medi_heading = 'Grade'(020)
            i_shor_heading = 'Grade'(020)
            i_length       = '5'
          CHANGING
            ch_cols        = lo_cols.

*       "Grade Date"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'GRADE_DATE'
            i_long_heading = 'Grade Date'(021)
            i_medi_heading = 'Grade Date'(021)
            i_shor_heading = 'Grade Date'(021)
            i_length       = '10'
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "New Product After Transfer"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'NEW_PRODUCT_AFTER_TRANSFER'
            i_long_heading = 'New Product After Transfer'(022)
            i_medi_heading = 'New Prd Aftr Trnsfr'(038)
            i_shor_heading = 'NPA_Trnsfr'(023)
            i_length       = '10'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Transferred"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'TRANSFERRED'
            i_long_heading = 'Transferred'(024)
            i_medi_heading = 'Transferred'(024)
            i_shor_heading = 'Trnsferd'(025)
            i_length       = '10'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Transferred Date"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'TRANSFERRED_DATE'
            i_long_heading = 'Transferred Date'(026)
            i_medi_heading = 'Transferred Date'(026)
            i_shor_heading = 'Trnsfrd Dt'(027)
            i_length       = '10'
            i_hide_column  = lv_hide_column
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "Refunded"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'REFUNDED'
            i_long_heading = 'Refunded'(028)
            i_medi_heading = 'Refunded'(028)
            i_shor_heading = 'Refunded'(028)
            i_length       = '8'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Refunded Date"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'REFUNDED_DATE'
            i_long_heading = 'Refunded Date'(029)
            i_medi_heading = 'Refunded Date'(029)
            i_shor_heading = 'Rfnd Date'(030)
            i_length       = '10'
            i_hide_column  = lv_hide_column
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "New Product After Exchange"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'NEW_PRODUCT_AFTER_EXCHANGE'
            i_long_heading = 'New Product After Exchange'(031)
            i_medi_heading = 'New Prd Aftr Exchnge'(039)
            i_shor_heading = 'N Prd A Ex'(032)
            i_length       = '10'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Exchanged"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'EXCHANGED'
            i_long_heading = 'Exchanged'(033)
            i_medi_heading = 'Exchanged'(033)
            i_shor_heading = 'Exchanged'(033)
            i_length       = '9'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

*       "Exchanged Date"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'EXCHANGED_DATE'
            i_long_heading = 'Exchanged Date'(034)
            i_medi_heading = 'Exchanged Date'(034)
            i_shor_heading = 'Exchgd Dt'(035)
            i_length       = '10'
            i_hide_column  = lv_hide_column
            i_edit_mask    = lc_edit_mask
          CHANGING
            ch_cols        = lo_cols.

*       "Commission Rate"
        CALL METHOD meth_set_headings " Setting up the Column headings
          EXPORTING
            i_field_name   = 'COMMISSION_RATE'
            i_long_heading = 'Commission Rate'(048)
            i_medi_heading = 'Commission Rate'(048)
            i_shor_heading = 'Comm Rate'(049)
            i_length       = '10'
            i_hide_column  = lv_hide_column
          CHANGING
            ch_cols        = lo_cols.

      CATCH cx_sy_dyn_call_illegal_type INTO lo_msg.
        lv_string = lo_msg->get_text( ).
        MESSAGE lv_string TYPE 'I'.
    ENDTRY.
  ENDMETHOD.                    "meth_SET_COLUMNS
  METHOD meth_set_headings.
    DATA: lo_column TYPE REF TO cl_salv_column,
          lo_msg    TYPE REF TO cx_salv_not_found,
          lv_string TYPE string.
    TRY.
        lo_column = ch_cols->get_column( i_field_name ).
        IF i_hide_column IS NOT INITIAL.
          CALL METHOD lo_column->set_visible
            EXPORTING
              value = if_salv_c_bool_sap=>false.
          RETURN.
        ENDIF.
        lo_column->set_long_text( i_long_heading ).
        lo_column->set_medium_text( i_medi_heading ).
        lo_column->set_short_text( i_shor_heading ).
        lo_column->set_output_length( i_length ).
        IF i_edit_mask IS NOT INITIAL.
          CALL METHOD lo_column->set_edit_mask
            EXPORTING
              value = i_edit_mask.
        ENDIF.
      CATCH cx_salv_not_found INTO lo_msg.
        lv_string = lo_msg->get_text( ).
        MESSAGE lv_string TYPE 'I'.
    ENDTRY.
  ENDMETHOD.                    "meth_set_headings
*----CODE_ADD_3 - End--------------------------------------------------*
ENDCLASS.                    "lclenc_report IMPLEMENTATION
