*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCR_UPDATE_JPCMS_DATE_MATMAS (Report)
* PROGRAM DESCRIPTION: Report to update JPCMS date in material master
*                      (Program documentation maintained)
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE: 22/12/2016
* OBJECT ID: E145
* TRANSPORT NUMBER(S): ED2K903846
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906306
* REFERENCE NO: ERP-2217
* DEVELOPER: Writtick Roy
* DATE:  2017-05-22
* DESCRIPTION: Swap the population logic of Material Availability Date
*              (MARC-ISMAVAILDATE) and Planned Goods Arrival Date
*              (MARC-ISMARRIVALDATEPL)
*              Add Z01 as Default Movement Type (along with 101)
*----------------------------------------------------------------------*
* REVISION NO: ED2K906985
* REFERENCE NO: ERP-2935
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-06-28
* DESCRIPTION: As currently we are displaying as error message when no
*              records are found the batch jobs are terminating and
*              getting cancelled. To avoid this we are displaying it as
*               information message.
*----------------------------------------------------------------------*
* REVISION NO: ED2K907255
* REFERENCE NO: ERP-3168
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-12
* DESCRIPTION: Dates are not getting updated when legacy system sends space.
*              Ideally it should update the dates in this scenario.
*----------------------------------------------------------------------*
* REVISION NO: ED2K910759
* REFERENCE NO: ERP-6470
* DEVELOPER: Writtick ROY (WROY)
* DATE:  2018-02-08
* DESCRIPTION: Add Manual Execution Option with checkboxes to choose
*              individual Date fields.
*----------------------------------------------------------------------*
* REVISION NO: ED1K909755
* REFERENCE NO: RITM0116455
* DEVELOPER: Arjun Reddy (ARGADEELA)
* DATE:  2019-03-05
* DESCRIPTION: Update Actual Goods Arr Date (MARC-ISMARRIVALDATEAC)
*               for all the plants activated for the same material.
*&---------------------------------------------------------------------*
*& Report  ZQTCR_UPDATE_JPCMS_DATE_MATMAS
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_update_jpcms_date_matmas.

*----------------------------------------------------------------------*
*                           I N C L U D E S                            *
*----------------------------------------------------------------------*
* Include for global data declaration
INCLUDE zqtcn_update_jpcms_date_top IF FOUND.

* Include for selection screen
INCLUDE zqtcn_update_jpcms_date_sel IF FOUND.

* Include for perform logic details
INCLUDE zqtcn_update_jpcms_date_sub IF FOUND.

* Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
*----------------------------------------------------------------------*
*                      I N I T I A L I Z A T I O N                     *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate Default Values of the Selection Screen Fields
  PERFORM f_populate_defauls.
* End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306

* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
*----------------------------------------------------------------------*
*           A T  S E L E C T I O N - S C R E E N  O U T P U T          *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
* Control display of the Selection Screen Fields
  PERFORM f_modify_screen.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759

*----------------------------------------------------------------------*
*                 S T A R T     O F    S E L E C T I O N               *
*----------------------------------------------------------------------*
START-OF-SELECTION.

* Perform to get the date range value
  PERFORM f_get_date_val           CHANGING v_curr_date
                                            v_curr_time
                                            v_from_date
                                            v_from_time.

* Perform to fetch data for printer purchase order
  PERFORM f_fetch_data_printer_po     USING v_curr_date
                                            v_curr_time
                                            v_from_date
                                            v_from_time
                                   CHANGING i_ekpo.

* Perform to fetch data for distributor purchase order
  PERFORM f_fetch_data_distributor_po USING i_ekko
                                   CHANGING i_ekpo_dis.

* Perform to fetch data for goods issue
  PERFORM f_fetch_data_goods_issue    USING v_curr_date
                                            v_curr_time
                                            v_from_date
                                            v_from_time
                                   CHANGING i_ekbe.

* Perform to get final table
  PERFORM f_populate_final_tab        USING i_ekpo
                                            i_ekpo_dis
                                            i_ekbe
                                   CHANGING i_marc.

* perform to update material master date field
  PERFORM f_update_date_matmas        USING i_marc
                                            i_nast
                                            i_ekpo
                                            i_ekpo_dis
                                            i_ekbe.

*----------------------------------------------------------------------*
*                     E N D    O F    S E L E C T I O N                *
*----------------------------------------------------------------------*
END-OF-SELECTION.

* Perform to set the latest date value
  PERFORM f_set_date_val              USING v_curr_date
                                            v_curr_time.

* Perform to generate ALV display output
  PERFORM f_display_alv.
