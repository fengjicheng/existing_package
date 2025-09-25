*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_QTC_DF_SAP_CWS_I0322 (Main Program)
* PROGRAM DESCRIPTION: For print media at Wiley, all journals are initially
* shipped directly from a third party distributor, therefore the distributor
* address will be used. The distributor for each journal will be designated
* as the fixed vendor on the source list. From the source list we will pull
* the fixed vendor and send the address of the vendor as the “ship-from”
* for that product.
* DEVELOPER:            Aratrika Banerjee (ARABANERJE)
* CREATION DATE:        02/08/2017
* OBJECT ID:            I0322
* TRANSPORT NUMBER(S):  ED2K904348
*----------------------------------------------------------------------*
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K906016
*** REFERENCE NO:  JIRA Defect# ERP-2029
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-11
*** DESCRIPTION: To ensure that any change to fixed vendor also Idoc needs
* to be triggered.
***------------------------------------------------------------------- *

REPORT zqtci_qtc_df_sap_cws_i0322 NO STANDARD PAGE HEADING
                                     LINE-SIZE 132
                                     LINE-COUNT 65
                                     MESSAGE-ID zqtc_r2.

* Global Data Declaration
INCLUDE zqtcn_sap_cws_shpd_from_top. " Include ZQTCN_SAP_CWS_SHPD_FROM_TOP

* Selection Screen
INCLUDE zqtcn_sap_cws_shpd_from_scr. " Include ZQTCN_SAP_CWS_SHPD_FROM_SCR

* Global Subroutines
INCLUDE zqtcn_sap_cws_shpd_from_f00. " Include ZQTCN_SAP_CWS_SHPD_FROM_F00

INITIALIZATION.

* Subroutine to clear the global variables
  PERFORM f_clear_variables.

**********************************************************************
*Fetch Last rundate and time from ZCAINTERFACE table
**********************************************************************
  PERFORM f_fetch_last_rundate.


START-OF-SELECTION.

  IF v_flag = abap_false.
**********************************************************************
* Initial Load : Logic to retrieve distributor address for digital
* products and Physical Address: Company Code address from material
* master for all level 2 journals
**********************************************************************

    PERFORM f_initial_load_detail_fetch.

  ELSE. " ELSE -> IF v_flag = abap_false

**********************************************************************
* Delta Load : Logic to retrieve distributor address for digital
* products and Physical Address for changes.
**********************************************************************
    PERFORM f_delta_load_detail_fetch.

  ENDIF. " IF v_flag = abap_false

END-OF-SELECTION.
* Begin of change Defect 2029
  IF v_idoc_prc = abap_true.
    MESSAGE i195(zqtc_w2).
  ENDIF.
* End of change Defect 2029
CLEAR v_idoc_prc.
*  Update ZCAINTERFACE table(Last run date and Run time)
  PERFORM f_update_last_run_dat.
