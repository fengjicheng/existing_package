*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_AUTO_LOCKBOX_RENEWAL
* PROGRAM DESCRIPTION: Automated Lockbox Renewals Sub routines
* DEVELOPER: Anirban Saha
* CREATION DATE: 09/05/2017
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K908367
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K908320
* REFERENCE NO: ERP-5005
* DEVELOPER:    Srabanti Bose(SRBOSE)/Pavan Bandlapalli(PBANDLAPAL)
* DATE:         08-Dec-2017
* DESCRIPTION: 1.Additional filter criteria code for REference Document S_REF1
*              has been added as XREF1 field is character field its even
*              considering the records that have length less than the one
*              entered.
*              2. Custom table ZQTCLOCKBOX_UPD for field XBLNR data element is
*                changed so that only the values entered in the range are displayed.
*                As previously it was the character field it was not filtering properly.
*              3. Added the logic to populate the i_final internal table to display
*                 in the output.
*              4. Adjusted the logic for tolerance.
*              5. Added the new reason code 'X' to update in custom table to
*                 populate any error messages during order creation.
*----------------------------------------------------------------------*

REPORT zqtce_auto_lockbox_renewal NO STANDARD PAGE HEADING
                                     MESSAGE-ID zqtc_r2 LINE-COUNT 60
                                     LINE-SIZE 132.
"Includes
INCLUDE zqtcn_auto_lockbox_top_new.
INCLUDE zqtcn_auto_lockbox_scr_new.
INCLUDE zqtcn_auto_lockbox_sub_new.
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*-------------------- --------------------------------------------------*
* Validate Company Code
AT SELECTION-SCREEN ON s_bukrs.
  IF s_bukrs[] IS NOT INITIAL.
    PERFORM f_val_bukrs.
  ENDIF. " IF s_bukrs[] IS NOT INITIAL

* Validation of document Type
AT SELECTION-SCREEN ON s_blart.
  IF s_blart[] IS NOT INITIAL.
    PERFORM f_validate_blart.
  ENDIF. " IF s_blart[] IS NOT INITIAL

*&--------------------------------------------------------------------*
*&         START-OF-SELECTION
*&--------------------------------------------------------------------*
START-OF-SELECTION.
* To Fetch last run date
  PERFORM f_lastrundate.
* To fetch records from BSID VBAK VBFA tables
  PERFORM f_tab_records CHANGING i_bsid
                                 i_vbak
                                 i_vbap     " (++) PBOSE: 04-Jan-2017: ED2K903276
                                 i_constant " (++) PBOSE: 02-02-2017: ED2K903276
                                 i_vbfa
                                 i_custtab
                                 i_kna1.
*&--------------------------------------------------------------------*
*&                    END-OF-SELECTION
*&--------------------------------------------------------------------*
END-OF-SELECTION.
*Performing manipulation into final table
  PERFORM f_final_records CHANGING i_vbak[]
                                   i_vbap[]     " (++) PBOSE: 04-Jan-2017 ED2K903276
                                   i_constant[] " (++) PBOSE: 02-02-2017 ED2K903276
                                   i_vbfa[]
                                   i_custtab[]
                                   i_bsid[]
                                   i_final[].
* Perform to build the fieldcatalog for alv grid display
  PERFORM f_build_fieldcat .

* Perform to build the layout for alv grid display
  PERFORM f_layout CHANGING st_layout.

* ALV grid display
  PERFORM f_grid_display USING i_fieldcat
                               st_layout
                               i_final[].
