*&---------------------------------------------------------------------*
*& Report  ZQTCR_MBS_REPORT_R092
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916086
* REFERENCE NO:  ERPM-1645 - R092
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-09-09
* DESCRIPTION:   MBS_PO_Report
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916429
* REFERENCE NO:  ERPM-3468 - R092
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-10-11
* DESCRIPTION:   MBS Report-XLS button is not working
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916429
* REFERENCE NO:  ERPM-7040 - R092
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-11-14
* DESCRIPTION:   MBS Report - New Reqs: (R092)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K917087
* REFERENCE NO:  ERPM-7644 - R092
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-12-16
* DESCRIPTION:   PO-MBS Report - Design/Develop/Unit Test - New REQs
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K918848
* REFERENCE NO:  ERPM-18256 /R092
* DEVELOPER:     VDPATABALL
* DATE:          07/09/2020
* DESCRIPTION:   Added Higher level Material Display in Output
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
REPORT zqtcr_mbs_report_r092 NO STANDARD PAGE HEADING.
*&---------------------------------------------------------------------*
*---------------------------- INCLUDES USED----------------------------*
*
* INCLUDE ZQTCN_MBS_REPORT_R092_TOP             "Declarations
*
*----------------------------------------------------------------------*
INCLUDE zqtcn_mbs_report_r092_top.
*----------------------------------------------------------------------*
*       CLASS lclmbs_po_report DEFINITION
*----------------------------------------------------------------------*
CLASS lclmbs_po_report DEFINITION FINAL.
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
        CHANGING
          ch_cols        TYPE REF TO cl_salv_columns.

*----CODE_ADD_1 - End--------------------------------------------------*
*
ENDCLASS.                    "lclmbs_po_report DEFINITION

*--------------------------- SELECTION SCREEN--------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-047.
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
*PARAMETERS : p_po TYPE ebeln MATCHCODE OBJECT mekk_c OBLIGATORY.
SELECT-OPTIONS : s_potyp  FOR v_bsart NO INTERVALS OBLIGATORY,
                 so_vendr FOR ekko-lifnr NO INTERVALS, " Vendor
                 so_po_dt FOR ekko-aedat,              " PO Creation Date
                 so_po    FOR ekko-ebeln MATCHCODE OBJECT mekk_c.
PARAMETERS:p_repro   TYPE c AS CHECKBOX.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839

SELECTION-SCREEN END OF BLOCK b1.

*-------------------------------INITIALIZATION-------------------------*
INITIALIZATION.
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
  PERFORM f_init_po_type.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
  PERFORM f_vendor_range_restrict.

*--------------------------AT SELECTION SCREEN-------------------------*
AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'ONLI'.
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
*    SELECT SINGLE *
*             FROM ekko
*             INTO @DATA(li_ekko)
*             WHERE ebeln EQ @p_po.
*
*    IF sy-subrc NE 0.
*      sscrfields-ucomm = ' ' .
*      MESSAGE text-048 TYPE 'E'. " PO doesn't exisits
*    ENDIF.
    SELECT ebeln
      FROM ekko
      INTO TABLE @DATA(lt_ekko)
      WHERE ebeln IN @so_po
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        AND bsart IN @s_potyp
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        AND aedat IN @so_po_dt
        AND lifnr IN @so_vendr.
    IF sy-subrc NE 0.
      sscrfields-ucomm = ' ' .
      MESSAGE text-048 TYPE 'E'. " No records found
    ENDIF.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
  ENDIF.

*----------------AT SELECTION SCREEN OUTPUT----------------------------*
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'S_POTYP-LOW'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087

START-OF-SELECTION.
  DATA o_report TYPE REF TO lclmbs_po_report. " Report Object reference
  CREATE OBJECT o_report.
  o_report->meth_get_data( ).
  o_report->meth_generate_output( ).

*----------------------------------------------------------------------*
*       CLASS lclmbs_po_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lclmbs_po_report IMPLEMENTATION.
  METHOD meth_get_data.
    CONSTANTS: lc_deletion_ind TYPE c  VALUE 'L'.
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
    DATA : lt_poitem  TYPE TABLE OF bapimepoitem,
           lw_poitem  TYPE bapimepoitem,
           lt_poitemx TYPE TABLE OF bapimepoitemx,
           lw_poitemx TYPE bapimepoitemx,
           lt_return  TYPE TABLE OF bapiret2.
    CONSTANTS : lc_err TYPE bdc_mart VALUE 'E'.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087

*   Data Selection from CDS View
    SELECT *
      FROM zcds_mbspo_001
      INTO TABLE @DATA(li_cds)
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
*      WHERE po_number EQ @p_po
      WHERE po_number     IN @so_po
        AND vendor_number IN @so_vendr
        AND po_date       IN @so_po_dt
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        AND header_deletion_indicator NE @lc_deletion_ind
        AND item_deletion_indicator   NE @lc_deletion_ind
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        AND po_type      IN @s_potyp.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
    IF sy-subrc EQ 0.
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
* If Reprocess is NOT set, Not Locked PO lines to be displayed in the report.
      SORT li_cds BY po_number item.
      IF p_repro = space.
        DELETE li_cds WHERE item_deletion_indicator EQ c_s.
      ENDIF.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
      LOOP AT li_cds INTO DATA(lw_cds).
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        w_final-vendor_number          = lw_cds-vendor_number.
        w_final-vendor_name            = lw_cds-vendor_name.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        w_final-site_program           = lw_cds-site_program.
        w_final-voucher_id             = lw_cds-voucher_id.
        w_final-student_id             = lw_cds-student_id.
        w_final-student_first_name     = lw_cds-student_first_name.
        w_final-student_middle_initial = lw_cds-student_middle_initial.
        w_final-student_last_name      = lw_cds-student_last_name.
        w_final-address_1              = lw_cds-address_1.
        w_final-address_2              = lw_cds-address_2.
        w_final-city                   = lw_cds-city.
        w_final-state                  = lw_cds-state.
        w_final-postal_code            = lw_cds-postal_code.
        w_final-country                = lw_cds-country.
        w_final-contact_no_1           = lw_cds-contact_no_1.
        w_final-contact_no_2           = lw_cds-contact_no_2.
        w_final-email_address          = lw_cds-email_address.
        w_final-course_id              = lw_cds-course_id.
*---Begin of Changes VDPATABALL ERPM-18256 07/09/2020
        w_final-matnr               = lw_cds-higher_level_material.        "Higher Material Number
        w_final-maktx               = lw_cds-higher_level_material_desc.   "Higher Material Number
*---End of Changes VDPATABALL ERPM-18256 07/09/2020
** Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        w_final-material               = lw_cds-material.
        w_final-mat_desc               = lw_cds-material_description.
** End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        w_final-start_date             = lw_cds-start_date.
        w_final-end_date               = lw_cds-end_date.
        w_final-optional_materials     = lw_cds-optional_materials.
        w_final-grade_preference       = lw_cds-grade_preference.
        w_final-shipping_preference    = lw_cds-shipping_preference.
        w_final-quantity               = lw_cds-quantity.
*        w_final-bsart                  = lw_cds-po_type.
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
        w_final-net_price              = lw_cds-net_price.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839

* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        IF lw_cds-item_deletion_indicator NE c_s.      " Process only unlocked line items
          lw_poitem-po_item = lw_cds-item.             " fill the item number
          lw_poitem-delete_ind = c_s.                  " fill the deletion indicatior with 'S'
          APPEND lw_poitem TO lt_poitem.               " Fill the poitem internal table
          lw_poitemx-po_item = lw_cds-item.            " fill the item number
          lw_poitemx-po_itemx = c_x.                   " check the item
          lw_poitemx-delete_ind = c_x.                 " check the deletion indicator
          APPEND lw_poitemx TO lt_poitemx.             " Fillthe poitemx internal table
        ENDIF.
        IF lt_poitemx IS NOT INITIAL.                  " Process only when a PO has atleast one unlocked item
          AT END OF po_number.                         " Process for each PO
            CALL FUNCTION 'BAPI_PO_CHANGE'             " Call the BAPI to change the PO
              EXPORTING
                purchaseorder = lw_cds-po_number
              TABLES
                return        = lt_return
                poitem        = lt_poitem
                poitemx       = lt_poitemx.
            IF lt_return IS NOT INITIAL.
              READ TABLE lt_return INTO DATA(ls_error)
                WITH KEY type = lc_err.
              IF sy-subrc NE 0.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'    " Commit the work
                  EXPORTING
                    wait = c_x.
              ELSE.
                w_final-message = ls_error-message.        " store the error message if PO doesn't change
                CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'. " Roll back the work
              ENDIF.
            ENDIF.
            REFRESH : lt_poitem, lt_poitemx, lt_return.
          ENDAT.
        ENDIF.
        CLEAR : lw_poitem, lw_poitemx.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        APPEND w_final TO i_final.
        CLEAR : lw_cds, w_final.
      ENDLOOP.
    ENDIF.
    IF li_cds[] IS INITIAL.
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
        SORT i_final BY voucher_id.
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
* Begin by Aslam on 10/11/2019 - JIRA Ticket:ERPM-3468, TR: ED2K916429
*    DATA: lo_functions TYPE REF TO cl_salv_functions_list.
*    lo_functions = ch_alv->get_functions( ).
*    lo_functions->set_all( abap_true ).

    DATA : lo_selections TYPE REF TO cl_salv_selections.
    ch_alv->set_screen_status(
  report = sy-repid
  pfstatus = 'SALV_TABLE_STANDARD'
  set_functions = ch_alv->c_functions_all
  ).
    lo_selections = ch_alv->get_selections( ).
    lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
* End by Aslam on 10/11/2019 - JIRA Ticket:ERPM-3468, TR: ED2K916429
  ENDMETHOD.                    "meth_set_pf_status
  METHOD meth_set_columns.
*   Get all the Columns
    DATA: lo_cols   TYPE REF TO cl_salv_columns.
    lo_cols = ch_alv->get_columns( ).

*   set the Column optimization
    lo_cols->set_optimize( abap_false ).

*   Process individual columns
*   Change the properties of the Columns

* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
*       "vendor_number"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'VENDOR_NUMBER'
        i_long_heading = 'Vendor Number'(049)
        i_medi_heading = 'Vendor Number'(049)
        i_shor_heading = 'Vndr No'(050)
        i_length       = '10'
      CHANGING
        ch_cols        = lo_cols.
*       "vendor_name"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'VENDOR_NAME'
        i_long_heading = 'Vendor Name'(051)
        i_medi_heading = 'Vendor Name'(051)
        i_shor_heading = 'Vndr Name'(052)
        i_length       = '35'
      CHANGING
        ch_cols        = lo_cols.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839

*       "site_program"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'SITE_PROGRAM'
        i_long_heading = 'Site/Program'(002)
        i_medi_heading = 'Site/Program'(002)
        i_shor_heading = 'Site/Prog'(003)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "voucher_id"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'VOUCHER_ID'
        i_long_heading = 'Voucher ID'(004)
        i_medi_heading = 'Voucher ID'(004)
        i_shor_heading = 'Voucher ID'(004)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "student_id
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'STUDENT_ID'
        i_long_heading = 'Student ID'(005)
        i_medi_heading = 'Student ID'(005)
        i_shor_heading = 'Student ID'(005)
        i_length       = '25'
      CHANGING
        ch_cols        = lo_cols.

*       "student_first_name"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'STUDENT_FIRST_NAME'
        i_long_heading = 'Student''s First Name'(006)
        i_medi_heading = 'Student''s First Name'(006)
        i_shor_heading = 'Std''s FNam'(007)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.

*       "student_middle_initial"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'STUDENT_MIDDLE_INITIAL'
        i_long_heading = 'Student''s Middle Initial'(008)
        i_medi_heading = 'Student''s M_Initial'(009)
        i_shor_heading = 'Std''s MInt'(010)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.

*       "student_last_name
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'STUDENT_LAST_NAME'
        i_long_heading = 'Student''s Last Name'(011)
        i_medi_heading = 'Student''s Last Name'(011)
        i_shor_heading = 'Std''s LNa'(012)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.

*       "address_1"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'ADDRESS_1'
        i_long_heading = 'Student''s Address 1'(013)
        i_medi_heading = 'Student''s Address 1'(013)
        i_shor_heading = 'Std''s Adr1'(014)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.

*       "address_2"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'ADDRESS_2'
        i_long_heading = 'Student''s Address 2'(015)
        i_medi_heading = 'Student''s Address 2'(015)
        i_shor_heading = 'Std''s Adr2'(016)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.

*       "city"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'CITY'
        i_long_heading = 'Student''s City'(017)
        i_medi_heading = 'Student''s City'(017)
        i_shor_heading = 'Std''s City'(018)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "state"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'STATE'
        i_long_heading = 'Student''s State'(019)
        i_medi_heading = 'Student''s State'(019)
        i_shor_heading = 'Std''s Stat'(020)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "postal_code"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'POSTAL_CODE'
        i_long_heading = 'Student''s Postal Code'(021)
        i_medi_heading = 'Student''s Pstl_Code'(022)
        i_shor_heading = 'Std''s PCod'(023)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "country"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'COUNTRY'
        i_long_heading = 'Student''s Country Code'(024)
        i_medi_heading = 'Student''s cntry_Code'(025)
        i_shor_heading = 'Std''s CCod'(026)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "contact_no_1"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'CONTACT_NO_1'
        i_long_heading = 'Student''s Contact Phone1'(027)
        i_medi_heading = 'Student''s C_Phone1'(028)
        i_shor_heading = 'Std''s CPh1'(029)
        i_length       = '24'
      CHANGING
        ch_cols        = lo_cols.

*       "contact_no_2"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'CONTACT_NO_2'
        i_long_heading = 'Student''s Contact Phone2'(030)
        i_medi_heading = 'Student''s C_Phone2'(031)
        i_shor_heading = 'Std''s CPh2'(032)
        i_length       = '24'
      CHANGING
        ch_cols        = lo_cols.

*       "email_address"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'EMAIL_ADDRESS'
        i_long_heading = 'Student''s email'(033)
        i_medi_heading = 'Student''s email'(033)
        i_shor_heading = 'Std''s mail'(034)
        i_length       = '30'
      CHANGING
        ch_cols        = lo_cols.
*---Begin of Changes VDPATABALL ERPM-18256 07/09/2020
*---Higher Level Item COURSE Material number
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'MATNR'
        i_long_heading = 'Course Material Number'
        i_medi_heading = 'Course Mat Number'
        i_shor_heading = 'Course Mat'
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.
*---Higher Level Item COURSE Material Description
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'MAKTX'
        i_long_heading = 'Course Material Description'
        i_medi_heading = 'Course Mat Desc'
        i_shor_heading = 'Course Des'
        i_length       = '40'
      CHANGING
        ch_cols        = lo_cols.

*---End of Changes VDPATABALL ERPM-18256 07/09/2020
*       "course_id"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'COURSE_ID'
        i_long_heading = 'Course ID'(035)
        i_medi_heading = 'Course ID'(035)
        i_shor_heading = 'Course ID'(035)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
    "material"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'MATERIAL'
        i_long_heading = 'Material'(053)
        i_medi_heading = 'Material'(053)
        i_shor_heading = 'Mat No'(054)
        i_length       = '18'
      CHANGING
        ch_cols        = lo_cols.

    "mat_desc"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'MAT_DESC'
        i_long_heading = 'Material Description'(055)
        i_medi_heading = 'Material Description'(055)
        i_shor_heading = 'Mat Desc'(056)
        i_length       = '40'
      CHANGING
        ch_cols        = lo_cols.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839

*       "start_date"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'START_DATE'
        i_long_heading = 'Start Date'(036)
        i_medi_heading = 'Start Date'(036)
        i_shor_heading = 'Start Date'(036)
        i_length       = '10'
      CHANGING
        ch_cols        = lo_cols.

*       "end_date"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'END_DATE'
        i_long_heading = 'End Date'(037)
        i_medi_heading = 'End Date'(037)
        i_shor_heading = 'End Date'(037)
        i_length       = '10'
      CHANGING
        ch_cols        = lo_cols.

*       "optional_materials
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'OPTIONAL_MATERIALS'
        i_long_heading = 'Optional materials'(038)
        i_medi_heading = 'Optional materials'(038)
        i_shor_heading = 'Opt Matrls'(039)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "grade_preference"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'GRADE_PREFERENCE'
        i_long_heading = 'Grade Preference'(040)
        i_medi_heading = 'Grade Preference'(040)
        i_shor_heading = 'Grd Pref'(041)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "shipping_preference
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'SHIPPING_PREFERENCE'
        i_long_heading = 'Shipping Preference'(042)
        i_medi_heading = 'Shipping Preference'(042)
        i_shor_heading = 'Shpng Pref'(043)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "quantity"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'QUANTITY'
        i_long_heading = 'QTY'(044)
        i_medi_heading = 'QTY'(044)
        i_shor_heading = 'QTY'(044)
        i_length       = '20'
      CHANGING
        ch_cols        = lo_cols.

*       "school_note"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'SCHOOL_NOTE'
        i_long_heading = 'School Notes'(045)
        i_medi_heading = 'School Notes'(045)
        i_shor_heading = 'Schl Notes'(046)
        i_length       = '40'
      CHANGING
        ch_cols        = lo_cols.

* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
    "net_price"
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'NET_PRICE'
        i_long_heading = 'Net Price'(057)
        i_medi_heading = 'Net Price'(057)
        i_shor_heading = 'Net Price'(057)
        i_length       = '11'
      CHANGING
        ch_cols        = lo_cols.
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
    CALL METHOD meth_set_headings " Setting up the Column headings
      EXPORTING
        i_field_name   = 'MESSAGE'
        i_long_heading = 'Message'(058)
        i_medi_heading = 'Message'(058)
        i_shor_heading = 'Message'(058)
        i_length       = '40'
      CHANGING
        ch_cols        = lo_cols.
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
  ENDMETHOD.                    "meth_SET_COLUMNS
  METHOD meth_set_headings.
    DATA: lo_column TYPE REF TO cl_salv_column,
          lo_msg    TYPE REF TO cx_salv_not_found,
          lv_string TYPE string.
    TRY.
        lo_column = ch_cols->get_column( i_field_name ).
        lo_column->set_long_text( i_long_heading ).
        lo_column->set_medium_text( i_medi_heading ).
        lo_column->set_short_text( i_shor_heading ).
        lo_column->set_output_length( i_length ).
      CATCH cx_salv_not_found INTO lo_msg.
        lv_string = lo_msg->get_text( ).
        MESSAGE lv_string TYPE 'I'.
    ENDTRY.
  ENDMETHOD.                    "meth_set_headings
*----CODE_ADD_3 - End--------------------------------------------------*
ENDCLASS.                    "lclmbs_po_report IMPLEMENTATION

INCLUDE zqtcr_mbs_report_r092_f01.
