*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MBS_REPORT_R092_TOP
*&---------------------------------------------------------------------*

*--------------------------------Dynamic Workarea----------------------*
TABLES : lfa1, veda, sscrfields. " Dynamic workarea for selection screen elements
*--------------------------------TYPES---------------------------------*
*   Final output table structure
TYPES : BEGIN OF ty_final,
* Begin by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
          partner_no                 TYPE LIFNR,
          partner_name               TYPE NAME1_GP,
* End by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
          student	                   TYPE char100,
          contract                   TYPE vbeln_va,
          item                       TYPE posnr_va,
          product_code               TYPE atwrt,
          product_name               TYPE char50,
          units                      TYPE char16,
          start_date                 TYPE char8,
          street                     TYPE char100,
          city                       TYPE char50,
          state	                     TYPE char3,
          zip	                       TYPE char10,
          dob	                       TYPE bu_birthdt,
          gender                     TYPE char6,
          phone	                     TYPE char30,
          email	                     TYPE char70,
          total_price	               TYPE netwr_ap,
          grade_value                TYPE mvgr3,
          grade_date                 TYPE char8,
          new_product_after_transfer TYPE char1,
          transferred                TYPE char1,
          transferred_date           TYPE char8,
          refunded                   TYPE char1,
          refunded_date              TYPE char8,
          new_product_after_exchange TYPE char1,
          exchanged                  TYPE char1,
          exchanged_date             TYPE char8,
* Begin by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
          commission_rate             TYPE KBETR,
* End by Aslam on 11/11/2019 - JIRA Ticket:ERPM-5912, TR: ED2K916792
        END OF ty_final.

*---------------------INTERNAL TABLE, WorkArea, Objects----------------*
DATA : i_final TYPE TABLE OF ty_final,    " Final Internal Table
       w_final TYPE ty_final,             " Final Workarea
       o_alv   TYPE REF TO cl_salv_table. " ALV reference
