*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_AUTO_LOCKBOX_RENEWAL
* PROGRAM DESCRIPTION: Automated Lockbox Renewals
* DEVELOPER: Shivangi Priya
* CREATION DATE: 11/14/2016
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K903276
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905720
* REFERENCE NO: CR# 384
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 15-05-2017
* DESCRIPTION: Changes are made for:
*              1. Create Renewal Subscription Order
*              2. To correct the logic for sub order as multiple order
*                 was created for a quation
*              3. Calcuation logic of amount(5%) very needs to be changed.

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907088
* REFERENCE NO: ERP-3018
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 03-07-2017
* DESCRIPTION: Change the receiver and sender port.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907585
* REFERENCE NO: E097 ERP-3178/ERP_3016/ERP_3683
* DEVELOPER: Lucky Kodwani
* DATE: 28/07/2017
* DESCRIPTION:
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

REPORT zqtce_auto_lockbox_renewal NO STANDARD PAGE HEADING
                                     MESSAGE-ID zqtc_r2 LINE-COUNT 60
                                     LINE-SIZE 132.
"Includes
INCLUDE zqtcn_auto_lockbox_top IF FOUND. " Include ZQTCE_AUTO_LOCKBOX_TOP
INCLUDE zqtcn_auto_lockbox_scr IF FOUND. " Include ZQTCE_AUTO_LOCKBOX_SCR
INCLUDE zqtcn_auto_lockbox_sub IF FOUND. " Include ZQTCE_AUTO_LOCKBOX_SUB
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*-------------------- --------------------------------------------------*
* Validate Company Code
AT SELECTION-SCREEN ON s_bukrs.
  IF s_bukrs[] IS NOT INITIAL.
    PERFORM f_val_bukrs.
  ENDIF. " IF s_bukrs[] IS NOT INITIAL

* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
* Validation of document Type

AT SELECTION-SCREEN ON s_blart.
  IF s_blart[] IS NOT INITIAL.
    PERFORM f_validate_blart.
  ENDIF. " IF s_blart[] IS NOT INITIAL
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

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
