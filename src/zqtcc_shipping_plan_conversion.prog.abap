*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_SHIPPING_PLAN_CONVERSION (Main Program)
* PROGRAM DESCRIPTION: Shipping Plan Conversion
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   01/02/2017
* OBJECT ID:  C075
* TRANSPORT NUMBER(S): ED2K903953
*----------------------------------------------------------------------*
REPORT zqtci_shipping_plan_conversion NO STANDARD PAGE HEADING
                                        MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
INCLUDE zqtcn_shipping_plan_conv_top IF FOUND.
INCLUDE zqtcn_shipping_plan_conv_sel IF FOUND.
INCLUDE zqtcn_shipping_plan_conv_sub IF FOUND.

*** AT Selection Screen Output ***
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_screen.

*** AT Selection Screen On Value Request ***
  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_pr_ph.
*F4 validation for presentation server
    PERFORM f_localfile_f4.

*** AT Selection Screen On Value Request ***
  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ap_ph.
*F4 validation for application server
    PERFORM f_serverfile_f4.

********** START-OF-SELECTION ***************
    START-OF-SELECTION.
    IF rb_pres EQ abap_true.

      PERFORM f_upload_pres_data. " uploading pressentation Server Data

    ELSEIF rb_appl EQ abap_true.

      PERFORM f_upload_appl_data. " Uploading application server Data

    ENDIF.

    IF i_fdata[] IS NOT INITIAL.
      PERFORM f_validation_material. " Validation of Material
    ENDIF.

    IF v_erflag = abap_false. "checking error flag of validation

    PERFORM f_update_stdate_ord_gene." Update starting Date of Order Generation

    ENDIF.

    PERFORM f_build_fcat. " Building Fieldcatelouge

    PERFORM f_build_layout. " Building Layout

    PERFORM f_grid_display. " Grid Display
