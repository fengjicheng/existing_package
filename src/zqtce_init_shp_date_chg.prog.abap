*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_INIT_SHP_DATE_CHG
* PROGRAM DESCRIPTION: A custom program is required to update the
* order creation from date and delivery date on shipping plan and
* media issue (Latest PO Date) when an initial shipping date
*(MARA-ISMINITSHIPDATE) is updated on media issue.
* DEVELOPER: Writtick Roy/Monalisa Dutta
* CREATION DATE:   2017-01-11
* OBJECT ID: E147
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*& Report  ZQTCE_INIT_SHP_DATE_CHG
*&
*&---------------------------------------------------------------------*
REPORT zqtce_init_shp_date_chg NO STANDARD PAGE HEADING
                               LINE-SIZE  132
                               LINE-COUNT 65
                               MESSAGE-ID ob.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
*Include for top declaration
INCLUDE zqtcn_init_shp_date_chg_top IF FOUND.

*Include for declaring selection screen parameters
INCLUDE zqtcn_init_shp_date_chg_sel IF FOUND.

*Include for subroutines
INCLUDE zqtcn_init_shp_date_chg_sub IF FOUND.

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_mtyp_i[]
                                       s_stat_i[].

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_mtyp_i.
* Validate Material Type
  PERFORM f_validate_mat_type USING  s_mtyp_i[].

AT SELECTION-SCREEN ON s_stat_i.
* Validate Madia status
  PERFORM f_validate_status USING  s_stat_i[].
*--------------------------------------------------------------------*
*                START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
* Fetch and Process Records
  PERFORM f_fetch_n_process   USING    s_mtyp_i[]
                                       s_stat_i[]
                                       p_ts_upd.
