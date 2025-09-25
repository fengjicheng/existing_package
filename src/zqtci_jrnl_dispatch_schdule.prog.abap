***-------------------------------------------------------------------*
*** PROGRAM NAME:ZQTCI_JRNL_DISPATCH_SCHDULE
*** PROGRAM DESCRIPTION: Journal Dispatch Schedule Report
*** DEVELOPER:Shivani Upadhyaya
*** CREATION DATE:2017-01-13
*** OBJECT ID:I0268
*** TRANSPORT NUMBER(S):ED2K904120
***-------------------------------------------------------------------*
**
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K905911
*** REFERENCE NO:  JIRA Defect# ERP-1976
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-08
*** DESCRIPTION: Print run calcualtion in conference Quantity is considering
*                deleted items.
***------------------------------------------------------------------- *
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K905960
*** REFERENCE NO:  JIRA Defect# ERP-2002
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-09
*** DESCRIPTION: Vendor number's leading zeros needs to be removed. If the
* Quantity is negative then we need to send zero quantity.
***------------------------------------------------------------------- *
*** REVISION NO: ED2K907999
*** REFERENCE NO:  CR#619
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-08-16
*** DESCRIPTION: To change from publication date to Initial Shipping Date.
***------------------------------------------------------------------- *
*** REVISION NO: ED2K908623
*** REFERENCE NO: ERP-4602
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-09-20
*** DESCRIPTION: Corrected the code to populate correctly expected
*                delivery date to populate initial shipping date.
***------------------------------------------------------------------- *
*** REVISION NO:  ED1K907393
*** REFERENCE NO: ERP-7478
*** DEVELOPER: SRREDDY
*** DATE:  2018-05-20
*** DESCRIPTION: Remove 'No. of Shipping days' population in sel. screen
***              for WMS (Warehouse) File
***------------------------------------------------------------------- *
**

REPORT zqtci_jrnl_dispatch_schdule
NO STANDARD PAGE HEADING MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_jrnl_dsptch_schdle_top IF FOUND. "Include ZQTCN_JRNL_DSPTCH_SCHDLE_TOP

**Include for Selection Screen
INCLUDE zqtcn_jrnl_dsptch_schdle_sel IF FOUND. "Include ZQTCN_JRNL_DSPTCH_SCHDLE_SEL

*Include for Subroutines
INCLUDE zqtcn_jrnl_dsptch_schdle_f01 IF FOUND. "Include ZQTCN_JRNL_DISPTCH_SCHDLE_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Perform to clear internal tables
  PERFORM f_clear_all.

*Perform to get constant from ZCACONSTANT Table
  PERFORM f_get_constants.

*----------------------------------------------------------------------*
*              AT SELECTION SCREEN ON VALUE REQUEST                    *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_matnr.
  PERFORM f_validate_matrn.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
* Get F4 help in file path
  PERFORM f_f4_file_path CHANGING p_file.

*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

*Perform to fetch data for Material Data from MARA Table
  PERFORM f_get_data_mara  CHANGING i_mara
                                    i_jptidcdassign
                                    i_jptidcdassign_wms
                                    i_zqtc_inven_recon
                                    i_eord
                                    i_lfa1
                                    i_plaf.

*Perform to fetch data for Laboratory/office Texts
  PERFORM f_get_data_t024x USING i_mara
                           CHANGING i_t024x.
*--------------------------------------------------------------------*
  IF rb_jd = abap_true.
*Perform to fecth data from CEPCT Table (Texts for Profit Center Master Data)
    PERFORM f_get_data_cepct USING i_marc
                             CHANGING i_cepct.

  ENDIF. " IF rb_jd = abap_true

*Perform to fetch data for Sales Data for Material
  PERFORM f_get_data_mvke USING i_mara
                          CHANGING i_mvke.


*Perform to fetch data for Material Consumption from MVER Table
  PERFORM f_get_data_mver  USING    i_marc
                           CHANGING i_mver.

*Perform to fetch data for Material Description from MAKT Table
  PERFORM f_get_data_makt  USING i_mara
                           CHANGING i_makt.

*Perform to fetch data for Material Index for Forecast from MAPR Table
  PERFORM f_get_data_mapr  USING i_mvke
                           CHANGING i_mapr.

*Perform to fetch data for Forecast parameters from PROP Table
  PERFORM f_get_data_prop  USING i_mapr
                           CHANGING i_prop.

*Perform to fetch data for Forecast Values from PROW Table
  PERFORM f_get_data_prow  USING i_prop
                           CHANGING i_prow_sum.

*Perform to fetch data for Planned Order from PLAF Table
  PERFORM f_get_data_plaf  USING i_mvke
                           CHANGING i_plaf.

*Perform to fetch data for Purchase Requisition from EBAN Table
  PERFORM f_get_data_eban  USING i_mara
                           CHANGING i_eban
                                    i_eban_zmenge1.

*Perform to feth data for Purchasing Document Item from EKPO Table
  PERFORM f_get_data_ekpo  USING i_mara
                           CHANGING i_ekpo.

*Perform to fetch data for Sales Document from VBAP and VBAK Table
  PERFORM f_get_sales_data USING i_mara
                           CHANGING i_vbap
                                    i_vbak.

*Perform to fetch data for IS-M: Media Schedule Lines from JKSESCHED Table
  PERFORM f_get_jksesched  USING i_mara.


*--------------------------------------------------------------------*
*  END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.

*Perform for calculation fields
  PERFORM f_calculate_data USING i_mara
                                 i_mver
                                 i_marc
                                 i_mapr
                                 i_prow_sum
                                 i_eban
                                 i_eban_zmenge1
                                 i_ekpo
                                 i_issue
                                 i_zqtc_inven_recon
                                 i_plaf
                        CHANGING i_calc_tab
                                 i_prop.

  IF rb_jd EQ abap_true.
*Perform for populating final table
    PERFORM f_process_data USING i_mara
                                 i_makt
                                 i_cepct
                                 i_t024x
                                 i_jptidcdassign
                                 i_eord
                                 i_lfa1
                                 i_marc
                                 i_calc_tab
                         CHANGING i_final.

    IF i_final IS NOT INITIAL.
*Perform for Uploading File into Application Server
      PERFORM f_upload_data USING p_file
                                  i_final.
    ENDIF. " IF i_final IS NOT INITIAL
  ELSEIF rb_wms EQ abap_true.

*Perform for populating final table
    PERFORM f_process_data_wms USING i_mara
                                 i_makt
                                 i_t024x
                                 i_jptidcdassign
                                 i_jptidcdassign_wms
                                 i_marc
                                 i_calc_tab
                         CHANGING i_final.

    IF i_final IS NOT INITIAL.
*Perform for Uploading File into Application Server

      PERFORM f_upload_data_wms USING p_file
                                 i_final.
    ENDIF. " IF i_final IS NOT INITIAL


  ENDIF. " IF rb_jd EQ abap_true
