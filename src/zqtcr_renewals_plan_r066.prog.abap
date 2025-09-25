*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_RENEWALS_PLAN_R066
* PROGRAM DESCRIPTION: To display Renewal plan details based on
*                      specific selection criteria
* DEVELOPER: Dinakar T
* CREATION DATE:   2018-03-19
* OBJECT ID: R066
* TRANSPORT NUMBER(S): ED2K911447
*-------------------------------------------------------------------
REPORT zqtcr_renewals_plan_r066 NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

* Include for Data Declarations
INCLUDE zqtcr_renewals_plan_top_01 IF FOUND.
* Include for selection screen
INCLUDE zqtcr_renewals_plan_sel_01 IF FOUND.
