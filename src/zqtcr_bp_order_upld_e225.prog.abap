*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_BP_ORDER_UPLD (Main Program)
* PROGRAM DESCRIPTION: To upload BP and subscription orders
* DEVELOPER: Nageswara(NPOLINA)
* CREATION DATE:   02/Dec/2019
* OBJECT ID:    E225
* TRANSPORT NUMBER(S):ED2K916854
*----------------------------------------------------------------------*
* REVISION NO: ED2K924398                                              *
* REFERENCE NO: OTCM-47267                                             *
* DEVELOPER: Nikhilesh Palla(NPALLA)                                   *
* DATE:  12/17/2021                                                    *
* DESCRIPTION: - Update Interface Staging ID field in staging table    *
*              ZE225_STAGING.                                          *
*              - Add Logic to Flip Between Old and New E101 Program    *
*----------------------------------------------------------------------*
* REVISION NO:                                                         *
* REFERENCE NO:                                                        *
* DEVELOPER:                                                           *
* DATE:                                                                *
* DESCRIPTION:                                                         *
*----------------------------------------------------------------------*

REPORT zqtcr_bp_order_upld_e225 NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.


INCLUDE zqtcn_bp_ord_upld_top  IF FOUND. "constants declaration

INCLUDE zqtcn_bp_ord_upld_sel IF FOUND. "selection screen

INCLUDE zqtcn_bp_ord_upld_sub IF FOUND. "subroutines

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
  pb_down = text-104.
  comm1 = text-106.
  comm3 = text-107.
  comm6 = text-139.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

AT SELECTION-SCREEN.
  PERFORM f_get_template_file.
  PERFORM f_validate_file USING p_file.

*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
  IF i_const IS INITIAL.
    SELECT devid                      "Development ID
            param1                     "ABAP: Name of Variant Variable
            param2                     "ABAP: Name of Variant Variable
            srno                       "Current selection number
            sign                       "ABAP: ID: I/E (include/exclude values)
            opti                       "ABAP: Selection option (EQ/BT/CP/...)
            low                        "Lower Value of Selection Condition
            high                       "Upper Value of Selection Condition
            activate                   "Activation indicator for constant
            FROM zcaconstant           " Wiley Application Constant Table
            INTO TABLE i_const
            WHERE ( devid   IN ( c_e101 , c_devid )
            AND   activate = c_x ). "Only active record
    IF sy-subrc EQ 0.
      LOOP AT i_const ASSIGNING FIELD-SYMBOL(<lst_const>).
        CASE <lst_const>-param1.
          WHEN c_auart.
            APPEND INITIAL LINE TO i_auart ASSIGNING FIELD-SYMBOL(<lst_auart>).
            <lst_auart>-sign   = <lst_const>-sign.
            <lst_auart>-option = <lst_const>-opti.
            <lst_auart>-low    = <lst_const>-low.
            <lst_auart>-high   = <lst_const>-high.

          WHEN c_auart_cnt.

            IF <lst_const>-param2 = 'HEADER'.
              APPEND INITIAL LINE TO i_auart_head ASSIGNING FIELD-SYMBOL(<lst_auarth>).
              <lst_auarth>-sign   = <lst_const>-sign.
              <lst_auarth>-option = <lst_const>-opti.
              <lst_auarth>-low    = <lst_const>-low.
              <lst_auarth>-high   = <lst_const>-high.
            ELSEIF <lst_const>-param2 = 'ITEM'.
              APPEND INITIAL LINE TO i_auart_item ASSIGNING FIELD-SYMBOL(<lst_auarti>).
              <lst_auarti>-sign   = <lst_const>-sign.
              <lst_auarti>-option = <lst_const>-opti.
              <lst_auarti>-low    = <lst_const>-low.
              <lst_auarti>-high   = <lst_const>-high.

            ENDIF.

          WHEN c_vbtyp.
            APPEND INITIAL LINE TO i_vbtyp ASSIGNING FIELD-SYMBOL(<lst_vbtyp>).
            <lst_vbtyp>-sign   = <lst_const>-sign.
            <lst_vbtyp>-option = <lst_const>-opti.
            <lst_vbtyp>-low    = <lst_const>-low.
            <lst_vbtyp>-high   = <lst_const>-high.
          WHEN c_kdkg2.
            CASE <lst_const>-param2.
              WHEN c_auart.
                APPEND INITIAL LINE TO i_auart_grp ASSIGNING FIELD-SYMBOL(<lst_auart2>).
                <lst_auart2>-sign   = <lst_const>-sign.
                <lst_auart2>-option = <lst_const>-opti.
                <lst_auart2>-low    = <lst_const>-low.
                <lst_auart2>-high   = <lst_const>-high.
*  BOC TD
              WHEN c_pstyv.
                APPEND INITIAL LINE TO i_pstyv_grp ASSIGNING FIELD-SYMBOL(<lst_pstyv>).
                <lst_pstyv>-sign   = <lst_const>-sign.
                <lst_pstyv>-option = <lst_const>-opti.
                <lst_pstyv>-low    = <lst_const>-low.
                <lst_pstyv>-high   = <lst_const>-high.
*  EOC TD
            ENDCASE.
          WHEN c_batchjob.
            iv_batchuser = <lst_const>-low.
          WHEN c_msgcount.
            v_msgcnt = <lst_const>-low.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225/E101  OTCM-47267
          WHEN c_new_logic.
            v_new_logic =  <lst_const>-low.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225/E101  OTCM-47267
        ENDCASE.
      ENDLOOP.
    ENDIF.
  ENDIF.
  IF i_auart[] IS NOT INITIAL.
    SELECT auart vbtyp FROM tvak INTO TABLE i_tvak
      FOR ALL ENTRIES IN i_auart
      WHERE auart = i_auart-low.
    IF sy-subrc EQ 0.
      SORT i_tvak BY auart.
    ENDIF.
  ENDIF.
  IF sy-batch = space.
    IF p_file IS NOT INITIAL.
      PERFORM f_convert_new_subs_ord_excel  USING    p_file     "File path
                                            CHANGING i_final[]
                                                     v_oid. "Input Data (table)

*---Get the file path from constant table
      READ TABLE i_const INTO DATA(lst_path) WITH KEY devid = c_devid param1 = c_path.
      IF sy-subrc = 0.
        CLEAR v_path_fname.
        v_path_fname = lst_path-low.
*----Get the file path
        PERFORM f_get_file_path USING v_path_fname.
*----Write the data into application layer
        PERFORM f_write_file_application USING v_path_fname.
*----Submit the processin background for BP creation
        PERFORM f_submit_program_background.
      ENDIF.
    ELSE.
      MESSAGE e193(zqtc_r2).
    ENDIF.
  ELSEIF sy-batch = abap_true.
*----Read the applicatin layer file (E225)
    PERFORM f_read_file_application.
*----Call the BP funcation and Search/Create BP
    "  ANDValidate and Submit to E225 in background
    PERFORM f_process_data.

* Validate and Submit to E101 in background
    PERFORM f_process_bp_orders.
  ENDIF.
