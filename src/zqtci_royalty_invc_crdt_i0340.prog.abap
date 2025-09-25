*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_ROYALTY_INVC_CRDT_I0340
* PROGRAM DESCRIPTION: Royalty Feed From Invoice_Credit.SAP system will
*                      trigger the interface to CORE via TIBCO.
* DEVELOPER(S):        Aratrika Banerjee
* CREATION DATE:       03/23/2017
* OBJECT ID:           I0340
* TRANSPORT NUMBER(S): ED2K905073
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910467
* REFERENCE NO: ERP-6094
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01/24/2018
* DESCRIPTION: Use Material Group 1 instead of Publication Type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtc_royalty_invc_crdt_i0340 NO STANDARD PAGE HEADING
                                     LINE-SIZE 132
                                     LINE-COUNT 65
                                     MESSAGE-ID zqtc_r2.

* Global Data Declaration
INCLUDE zqtcn_royalty_invc_crdt_top. " " Include ZQTCN_ROYALTY_INVC_CRDT_TOP

* Selection Screen
INCLUDE zqtcn_royalty_invc_crdt_scr. " " Include ZQTCN_ROYALTY_INVC_CRDT_SCR

* Global Subroutines
INCLUDE zqtcn_royalty_invc_crdt_f00. " " Include ZQTCN_ROYALTY_INVC_CRDT_F00

INITIALIZATION.

* Subroutine to clear the global variables
  PERFORM f_clear_variables.

* Populate Selection Screen Default Values
* Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
* PERFORM f_populate_defaults CHANGING s_ismtyp[]
* End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
* Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
  PERFORM f_populate_defaults CHANGING s_mvgr1[]
* End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
                                       s_doctyp[]
                                       s_raic[]
                                       s_status[]
* Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                                       s_pst_ct[]
* End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                                       s_rec_st[].

*Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*AT SELECTION-SCREEN ON s_ismtyp.
*  PERFORM f_validate_ismtyp USING s_ismtyp[].
*End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
AT SELECTION-SCREEN ON s_mvgr1.
  PERFORM f_validate_mat_grp_1 USING s_mvgr1[].
*End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467

AT SELECTION-SCREEN ON s_raic.
  PERFORM f_validate_raic USING s_raic[].

**********************************************************************
*Fetch Last rundate and time from ZCAINTERFACE table
**********************************************************************
  PERFORM f_fetch_last_rundate.

AT SELECTION-SCREEN OUTPUT.
* Sub Routine to select radio button for Interface Run and selection date
* range(Manual Run)
  PERFORM f_select_radio.

START-OF-SELECTION.

* Subroutine to fetch data,Control Records processing and Idoc processing
  PERFORM f_data_processing.

END-OF-SELECTION.

* submit program RSEOUT00 to process all selected idocs.
  IF i_output_det IS NOT INITIAL .
    SUBMIT rseout00 WITH mestyp-low = c_msgtyp
                    WITH p_show_w = c_b
                    AND RETURN.
  ENDIF. " IF i_output_det IS NOT INITIAL

  IF rb_1st EQ abap_true.
*   Update ZCAINTERFACE table(Last run date and Run time)
    PERFORM f_update_last_run_dat.
  ENDIF.

* Display output
  PERFORM f_display_output USING i_output_det.
