*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MBS_REPORT_R092_TOP
*&---------------------------------------------------------------------*

*--------------------------------Dynamic Workarea----------------------*
TABLES : sscrfields. " Dynamic workarea for selection screen elements
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
TABLES : ekko.       " Dynamic workarea for Vendor input
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
*--------------------------------TYPES---------------------------------*
*   Final output table structure
TYPES : BEGIN OF ty_final,
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
          vendor_number          TYPE elifn,
          vendor_name            TYPE name1_gp,
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
          site_program           TYPE char10,
          voucher_id             TYPE char30,
          student_id             TYPE ekunnr,
          student_first_name     TYPE	bu_namep_f,
          student_middle_initial TYPE	bu_namemid,
          student_last_name      TYPE bu_namep_l,
          address_1	             TYPE char100,
          address_2	             TYPE char50,
          city                   TYPE char50,
          state                  TYPE char3,
          postal_code            TYPE char10,
          country                TYPE char3,
          contact_no_1           TYPE char30,
          contact_no_2           TYPE char30,
          email_address          TYPE char70,
          matnr                  TYPE matnr,  "++VDPATABALL ERPM-18256 07/09/2020
          maktx                  TYPE maktx,  "++VDPATABALL ERPM-18256 07/09/2020
          course_id              TYPE bismt,
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
          material               TYPE matnr,
          mat_desc               TYPE maktx,
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
          start_date             TYPE char8,
          end_date               TYPE char8,
          optional_materials     TYPE char1,
          grade_preference       TYPE char2,
          shipping_preference    TYPE char10,
          quantity               TYPE bstmg,
          school_note            TYPE char100,
* Begin by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
          net_price              TYPE bprei,
* End by Aslam on 11/14/2019 - JIRA Ticket:ERPM-7040, TR: ED2K916839
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
          message                TYPE char200,
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
        END OF ty_final.

*---------------------INTERNAL TABLE, WorkArea, Objects----------------*
DATA : i_final TYPE TABLE OF ty_final,    " Final Internal Table
       w_final TYPE ty_final,             " Final Workarea
       v_bsart TYPE bsart,                " Po type
       o_alv   TYPE REF TO cl_salv_table. " ALV reference
*-------------------------------CONSTANTS------------------------------*
* Begin by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
CONSTANTS : c_devid TYPE char10   VALUE 'R092',        " Development ID
            c_s     TYPE char1    VALUE 'S',           " Checked
            c_x     TYPE char1    VALUE 'X'.           " Checked
* End by Aslam on 12/16/2019 - JIRA Ticket: ERPM-7644, TR:ED2K917087
