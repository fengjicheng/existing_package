*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCE_SALES_REP_CHG
* PROGRAM DESCRIPTION:This enhancement will change the sales rep
* after the order has been billed. Individual orders will be manually
* changed, however, mass changes will be allowed through this enhancement.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908586
* REFERENCE NO: INC0207762
* DEVELOPER: RTR (rtripat2)
* DATE: 28/09/2018
* DESCRIPTION:Output report should should only Inovices with order type
*             ZCSS (Order Document type added in selection screen)
*             Creation of Credit/Debit Memo through BAPI_DOCUMENT_COPY
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914088
* REFERENCE NO: CR#7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 20/12/2018
* DESCRIPTION: Adding Document Types: ZSUB, ZREW
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtce_sales_rep_chg NO STANDARD PAGE HEADING
                           LINE-SIZE 132
                           LINE-COUNT 65
                           MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_e131_sales_rep_chg_top. " Include ZQTCN_E131_SALES_REP_CHG_TOP

*Include for Selection Screen
INCLUDE zqtcn_e131_sales_rep_chg_sel. " Include ZQTCN_E131_SALES_REP_CHG_SEL

*Include for Subroutines
INCLUDE zqtcn_e131_sales_rep_chg_f01. " Include ZQTCN_E131_SALES_REP_CHG_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Clear all variables.
  PERFORM f_clear_all.

* Get constant value from ZCACONSTANT Table.
  PERFORM f_get_constants.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN
*----------------------------------------------------------------------*
*** BOC: CR#7764 KKRAVURI20181219  ED2K914088
AT SELECTION-SCREEN OUTPUT.
* Modify Selection Screen Display
  PERFORM f_screen_mode.
*** EOC: CR#7764 KKRAVURI20181219  ED2K914088

* Selection Screen data validation for Sales Organization
AT SELECTION-SCREEN ON s_vkorg.
  IF s_vkorg[] IS NOT INITIAL.
    PERFORM f_validate_vkorg.
  ENDIF. " IF s_vkorg[] IS NOT INITIAL

* Selection Screen data validation for Customer Number
AT SELECTION-SCREEN ON s_kunnr.
  IF s_kunnr[] IS NOT INITIAL.
    PERFORM f_validate_kunnr.
  ENDIF. " IF s_kunnr[] IS NOT INITIAL

* Selection Screen data validation for Country
AT SELECTION-SCREEN ON p_land1.
  IF p_land1 IS NOT INITIAL.
    PERFORM f_validate_land1.
  ENDIF. " IF p_land1 IS NOT INITIAL

AT SELECTION-SCREEN.
* Selection Screen data validation for Region
  IF s_bland IS NOT INITIAL.
    PERFORM f_validate_bland.
  ENDIF. " IF s_bland IS NOT INITIAL

* Selection Screen data validation for Postal Code
  IF s_pcode IS NOT INITIAL.
    PERFORM f_validate_postalcode.
  ENDIF. " IF s_pcode IS NOT INITIAL

  PERFORM f_validate_sales_rep.
*** BOC: CR#7764 KKRAVURI20181220  ED2K914088
* Below doc type validation is commented as the Sales Document Type
* field is non-editable
** BC RTR   INC0207762 ED1K908586
*  IF s_auart IS NOT INITIAL.
*    PERFORM f_validate_doc_type.
*  ENDIF.
*** EOC: CR#7764 KKRAVURI20181220  ED2K914088

*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Get Billing Header data from table VBRK
  PERFORM f_get_data_vbrk.

* Get Billing Item data from table VBRP
  PERFORM f_get_data_vbrp.

* Get Data from VBFA table
  PERFORM f_populate_vbfa.

* Get the Sales rep from table VBPA
  PERFORM f_get_data_vbpa.

* Popolate final Table.
  PERFORM f_populate_final.

*&--------------------------------------------------------------------*
*&  END OF SELECTION EVENT:                                           *
*&--------------------------------------------------------------------*
END-OF-SELECTION.
* Prepare the ALV Report:
  PERFORM f_display_records_alv.
