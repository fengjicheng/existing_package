*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DWNLD_INV_DETAILS_E071
* PROGRAM DESCRIPTION: Download invoice details as excel file.
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 10/04/2016
* OBJECT ID: E071
* TRANSPORT NUMBER(S): ED2K903054
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 8-Dec-2016
* DESCRIPTION: Implement the logic as per the updated FS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*

*& Report  ZQTCR_DWNLD_INV_DETAILS_E071
*&---------------------------------------------------------------------*
REPORT zqtcr_dwnld_inv_details_e071 NO STANDARD PAGE HEADING
                                      LINE-SIZE  132
                                      LINE-COUNT 65
                                      MESSAGE-ID zqtc_r2.

*===================================================================*
* Includes
*===================================================================*
"Include for Global Data Declaration
INCLUDE zqtcn_dwnld_inv_details_top.

"Include for Selection Screen
INCLUDE zqtcn_dwnld_inv_details_scr.

*Include for sub-routines
INCLUDE zqtcn_dwnld_inv_details_f00. " Include ZQTCR_DWNLD_INV_DETAILS_SUB

*===================================================================*
* INITIALIZATION
*===================================================================*
INITIALIZATION.
* Report Object Reference creation
  CREATE OBJECT o_dwnld_inv_details.

*===================================================================*
* AT SELECTION-SCREEN
*===================================================================*
AT SELECTION-SCREEN.

  CALL METHOD lcl_data_val=>validate_data(
    EXCEPTIONS
      vbeln_not_validated = 1
      fkart_not_validated = 2
      kunag_not_validated = 3
      kunrg_not_validated = 4
      vkorg_not_validated = 5
      vtweg_not_validated = 6 ).

  IF    sy-subrc EQ 1.
    MESSAGE e008. " Invalid Billing Document number!
  ELSEIF sy-subrc EQ 2.
    MESSAGE e009. " Invalid Billing Type!.
  ELSEIF sy-subrc EQ 3.
    MESSAGE e010. " Invalid Customer Number!
  ELSEIF sy-subrc EQ 4.
    MESSAGE e011. " Invalid Payer Number!
  ELSEIF sy-subrc EQ 5.
    MESSAGE e012. " Invalid Sales Organization Number!
  ELSEIF sy-subrc EQ 6.
    MESSAGE e013. " Invalid Distribution Channel!
  ENDIF. " IF sy-subrc EQ 1

*===================================================================*
* START OF SELECTION
*===================================================================*
START-OF-SELECTION.

* If Selection screen does not have any value, the throw an error
* message to stop further processing.
  IF s_vbeln IS INITIAL
   AND s_fkart IS INITIAL
   AND s_kunag IS INITIAL
   AND s_kunrg IS INITIAL
   AND s_fkdat IS INITIAL
   AND s_vkorg IS INITIAL
   AND s_vtweg IS INITIAL.
    MESSAGE i118 DISPLAY LIKE 'E'. " Please enter value in selection screen
    LEAVE LIST-PROCESSING.
  ENDIF. " IF s_vbeln IS INITIAL


* Clearing the junk values if present in the Class global variable
  CALL METHOD o_dwnld_inv_details->reset_display_mode( ).

* Set the Display mode as per the user input
  CALL METHOD o_dwnld_inv_details->set_display_mode( ).

* Get the table data from Hana CDS views
  CALL METHOD o_dwnld_inv_details->get_data(
    IMPORTING
      ex_final_inv = i_final_inv
      ex_final_crd = i_final_crd ).

END-OF-SELECTION.
*===================================================================*
* END OF SELECTION
*===================================================================*

  IF i_final_inv[] IS NOT INITIAL.
*   ALV display for Invoice: Abap Factory Method
    CALL METHOD o_dwnld_inv_details->alv_display_inv( ).
  ELSEIF i_final_crd IS NOT INITIAL.
*   ALV display for Credit data: Abap Factory Method
    CALL METHOD o_dwnld_inv_details->alv_display_crd( ).
  ELSE. " ELSE -> IF i_final_inv[] IS NOT INITIAL
    MESSAGE s015 DISPLAY LIKE c_e. " No Data found to display!
    LEAVE LIST-PROCESSING.
  ENDIF. " IF i_final_inv[] IS NOT INITIAL
