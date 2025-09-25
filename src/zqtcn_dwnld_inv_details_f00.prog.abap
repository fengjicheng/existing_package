*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DWNLD_INV_DETAILS_E071
* PROGRAM DESCRIPTION: Download invoice details and Credit details in
*                      excel file.
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 10/04/2016
* OBJECT ID: E071
* TRANSPORT NUMBER(S): ED2K903054
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DWNLD_INV_DETAILS_F00
*&---------------------------------------------------------------------*
CLASS lcl_data_val IMPLEMENTATION. " Data_val class

*====================================================================*
* Method CONSTRUCTOR ( Clear all global Variables)
*====================================================================*
  METHOD constructor.
    CLEAR : v_columns,
            v_column,
            v_layout,
            v_functions,
            v_layout_key,
            v_display,
            v_title,
            v_display_mode,
            st_column_ref,
            i_final_crd,
            i_final_inv,
            i_table,
            i_column_ref.


  ENDMETHOD.
*====================================================================*
* Method VALIDATE_DATE ( Validate data entered in selection screen)
*====================================================================*
  METHOD validate_data.
*&---------------------------------------------------------------------*
*  Add validation logic for Billing Document Number(VBELN) in Selection
*  screen.
*&---------------------------------------------------------------------*

*   Fetch Document Number to validate from check table.
    IF s_vbeln IS NOT INITIAL.
      SELECT vbeln " Sales and Distribution Document Number
        FROM vbuk  " Sales Document: Header Status and Administrative Data
        INTO @DATA(lv_vbeln)
        UP TO 1 ROWS
        WHERE vbeln IN @s_vbeln.
      ENDSELECT.
*     If user input any wrong data it stops the further processing
      IF sy-subrc NE 0.
        RAISE vbeln_not_validated .
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_vbeln IS NOT INITIAL
*&---------------------------------------------------------------------*
*          Validate Billing Type
*&---------------------------------------------------------------------*
*   Fetch Document Type to validate from check table.
    IF s_fkart IS NOT INITIAL.
      SELECT fkart " Billing Type
        FROM tvfk  " Billing: Document Types
        INTO @DATA(lv_fkart)
        UP TO 1 ROWS
        WHERE fkart IN @s_fkart.
      ENDSELECT.
*     If user input any wrong data it stops the further processing
      IF sy-subrc NE 0.
        RAISE fkart_not_validated.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_fkart IS NOT INITIAL

*&---------------------------------------------------------------------*
* Add validation logic for Customer Number(KUNAG) in Selection screen.
*&---------------------------------------------------------------------*
*   Fetch cusomer number to validate from check table.
    IF s_kunag IS NOT INITIAL.
      SELECT kunnr " Sold-to party
        FROM kna1  " General Data in Customer Master
        INTO @DATA(lv_kunag)
        UP TO 1 ROWS
        WHERE kunnr IN @s_kunag.
      ENDSELECT.
*     If user input any wrong data it stops the further processing
      IF sy-subrc NE 0.
        RAISE kunag_not_validated.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_kunag IS NOT INITIAL

*&---------------------------------------------------------------------*
* Add validation logic for Payee number(KUNRG) in Selection screen.
*&---------------------------------------------------------------------*
*   Fetch cusomer number to validate from check table.
    IF s_kunrg IS NOT INITIAL.
      SELECT kunnr " Payee
        FROM kna1  " General Data in Customer Master
        INTO @DATA(lv_kunrg)
        UP TO 1 ROWS
        WHERE kunnr IN @s_kunrg.
      ENDSELECT.

* If user input any wrong data it stops the further processing
      IF sy-subrc NE 0.
        RAISE kunrg_not_validated.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_kunrg IS NOT INITIAL

*&---------------------------------------------------------------------*
* Add validation logic for Sales Organization(VKORG) in Selection screen.
*&---------------------------------------------------------------------*
*   Fetch Sales Organization to validate from check table.
    IF s_vkorg IS NOT INITIAL.
      SELECT vkorg " Sales Organization
        FROM tvko  " Organizational Unit: Sales Organizations
        INTO @DATA(lv_vkorg)
        UP TO 1 ROWS
        WHERE vkorg IN @s_vkorg.
      ENDSELECT.
      IF sy-subrc NE 0.
        RAISE vkorg_not_validated.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_vkorg IS NOT INITIAL

*&---------------------------------------------------------------------*
* Add validation logic for Distribution channel(VTWEG) in Selection screen.
*&---------------------------------------------------------------------*
*   Fetch Distribution channel to validate from check table.
    IF s_vtweg IS NOT INITIAL.
      SELECT vtweg " Distribution Channel
        FROM tvtw  " Organizational Unit: Distribution Channels
        INTO @DATA(lv_vtweg)
        UP TO 1 ROWS
        WHERE vtweg IN @s_vtweg.
      ENDSELECT.
      IF sy-subrc NE 0.
        RAISE vtweg_not_validated.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_vtweg IS NOT INITIAL

  ENDMETHOD.
*====================================================================*
* Method GET_DATA ( to get the invoice and credit details)
*====================================================================*
  METHOD get_data.
    DATA: lv_display_mode TYPE char1. " Display_mode of type CHAR1

    CALL METHOD me->get_display_mode( IMPORTING ev_display_mode = lv_display_mode ).

    IF lv_display_mode = me->c_display_mode_inv.
      CALL METHOD me->get_inv_det
        IMPORTING
          ex_inv_det = ex_final_inv.

    ELSEIF lv_display_mode = me->c_display_mode_crdt.
      CALL METHOD me->get_crd_det
        IMPORTING
          ex_crd_det = ex_final_crd.
    ENDIF. " IF lv_display_mode = me->c_display_mode_inv


  ENDMETHOD.
*==========================================================================*
* Method GET_INV_DET ( Consume CDS View in Application Layer for invoice)
*==========================================================================*
  METHOD get_inv_det.

*    DATA : li_inv_tmp   TYPE tty_final_inv,
*           lst_inv_temp TYPE ty_final_inv,
*           lst_inv_det  TYPE ty_final_inv,
*           lst_inv      TYPE ty_final_inv.

*   Fetch data from tables as declared in CDS view based on selection screen.
    SELECT vbeln, " Billing Document
           fkart, " Billing Type
*         Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          waerk, " SD Document Currency
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
           vkorg,     " Sales Organization
           vtweg,     " Distribution Channel
           fkdat,     " Billing date for billing index and printout
           erdat,     " Date on Which Record Was Created
           kunrg,     " Payer
           kunag,     " Sold-to party
           identcode, " Product ID
           ismartist, " Name of Author or Artist
           ismtitle,  " Title
*           medium,       " Medium   "(--) PBOSE: 8-Dec-2016: SR_:ED2K903054
*          Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
*           ismmediatype, " Medium
*          End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

*         Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          bezeichnung, " SD Document Currency
*          kposn,
*          krech,
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054

           ismpubldate, " Publication Date
*          Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
           fkimg, " Order Quantity
*          End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
           lfimg,    " Actual quantity delivered (in sales units)
           list_sum, " List Price
           disc_sum, " Discount Percentage
           netwr,    " Net value of the billing item in document currency
           posnr,
*          Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
           bstnk,
*          End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
*           bstnk_vf,    " Customer purchase order number  "(--) PBOSE: 8-Dec-2016: SR_:ED2K903054
           sales_tax    " Sales Tax
      FROM zqtc_sum_inv " Generated Table for View
      INTO TABLE @DATA(li_inv_det)
      WHERE vbeln IN @s_vbeln
        AND fkart IN @s_fkart
        AND vkorg IN @s_vkorg
        AND vtweg IN @s_vtweg
        AND fkdat IN @s_fkdat
        AND kunrg IN @s_kunrg
        AND kunag IN @s_kunag
        ORDER BY vbeln, " Billing Document
                 fkart, " Billing Type
                 vkorg, " Sales Organization
                 vtweg, " Distribution Channel
                 fkdat, " Billing date for billing index and printout
                 erdat, " Date on Which Record Was Created
                 kunrg, " Payer
                 kunag. " Customer

    IF sy-subrc EQ 0.

*     Begin of Change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*     Populate values in a local internal table.
      i_inv_temp[] = li_inv_det[].

*     Subroutine to calculate discount value, Order quntity and Shipped Quantity.
      PERFORM f_pop_derived_val_inv USING i_inv_temp
                                 CHANGING ex_inv_det.

*     Begin of Change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

*     Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*      ex_inv_det[] = li_inv_det[].
*     End of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
    ENDIF. " IF sy-subrc EQ 0

  ENDMETHOD.
*=======================================================================*
* Method GET_CRD_DET ( Consume CDS View in Application Layer For Credit)
*=======================================================================*
  METHOD get_crd_det.

    SELECT vbeln, " Billing Document
           fkart, " Billing Type
*          Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
           waerk, " SD Document Currency
*          End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
           vkorg,     " Sales Organization
           vtweg,     " Distribution Channel
           fkdat,     " Billing date for billing index and printout
           erdat,     " Date on Which Record Was Created
           kunrg,     " Payer
           kunag,     " Sold-to party
           identcode, " Identification Code
           ismtitle,  " Title
*           kposn,
*           krech,
           fkimg,       " Actual Invoiced Quantity
           list_sum,    " List price
           disc_sum,    " Discount Percentage
           netwr,       " Net value of the billing item in document currency
           posnr,
           augru_auft,  " Order reason (reason for the business transaction)
           va_vgbel,    " Document number of the reference document
           sales_tax    " Sales Tax
      FROM zqtc_sum_crd " Generated Table for View
      INTO TABLE @DATA(li_crd_det)
      WHERE vbeln IN @s_vbeln
        AND fkart IN @s_fkart
        AND vkorg IN @s_vkorg
        AND vtweg IN @s_vtweg
        AND fkdat IN @s_fkdat
        AND kunrg IN @s_kunrg
        AND kunag IN @s_kunag
        ORDER BY vbeln, " Billing Document
                 fkart, " Billing Type
                 vkorg, " Sales Organization
                 vtweg, " Distribution Channel
                 fkdat, " Billing date for billing index and printout
                 erdat, " Date on Which Record Was Created
                 kunrg, " Payer
                 kunag. " Customer

    IF sy-subrc EQ 0.

*     Begin of Change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*     Populate values in a local internal table.
      i_crd_temp[] = li_crd_det[].

*     Subroutine to calculate discount value and Quntity
      PERFORM f_pop_derived_val_crd USING i_crd_temp
                                 CHANGING ex_crd_det.

*     Begin of Change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

*     Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*      ex_crd_det[] = li_crd_det[].
*     End of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
    ENDIF. " IF sy-subrc EQ 0

  ENDMETHOD.
*====================================================================*
* Method SET_DISPLAY_MODE
*====================================================================*
  METHOD set_display_mode.
    IF rb_inv IS NOT INITIAL.
      me->v_display_mode = me->c_display_mode_inv.
    ELSEIF rb_crd IS NOT INITIAL.
      me->v_display_mode = me->c_display_mode_crdt.
    ENDIF. " IF rb_inv IS NOT INITIAL
  ENDMETHOD.
*====================================================================*
* Method GET_DISPLAY_MODE
*====================================================================*
  METHOD get_display_mode.
    ev_display_mode = me->v_display_mode.
  ENDMETHOD.
*====================================================================*
* METHOD RESET_DISPLAY_MODE
*====================================================================*
  METHOD reset_display_mode.
    CLEAR me->v_display_mode.
  ENDMETHOD.
*====================================================================*
* METHOD ALV_DISPLAY_INV ( Preparing ALV Grid display of Invoice)
*====================================================================*
  METHOD alv_display_inv.

    CLEAR: i_table.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = i_table
          CHANGING
            t_table      = i_final_inv.
      CATCH cx_salv_msg .
    ENDTRY.


** Get functions details
    v_functions = i_table->get_functions( ).

**  Activate All Buttons in Tool Bar
    v_functions->set_all( if_salv_c_bool_sap=>true ).

**  Layout Settings  *******
    CLEAR : v_layout,
            v_layout_key.
    v_layout_key-report = sy-repid . "Set Report ID as Layout Key"

    IF i_table IS NOT INITIAL.
      v_layout = i_table->get_layout( ). "Get Layout of Table"
    ENDIF. " IF i_table IS NOT INITIAL
    IF v_layout IS NOT INITIAL.
      v_layout->set_key( v_layout_key ). "Set Report Id to Layout"
      v_layout->set_save_restriction( if_salv_c_layout=>restrict_none ). "No Restriction to Save Layout"
    ENDIF. " IF v_layout IS NOT INITIAL

******* Global Display Settings  *******
    CLEAR : v_display.
    v_title = 'Invoice Details Report'(005).
    IF i_table IS NOT INITIAL.
      v_display = i_table->get_display_settings( ). " Global Display settings"
    ENDIF. " IF i_table IS NOT INITIAL
    IF v_display IS NOT INITIAL.
      v_display->set_striped_pattern( if_salv_c_bool_sap=>true ). "Activate Strip Pattern"
      v_display->set_list_header( v_title ).
    ENDIF. " IF v_display IS NOT INITIAL


** Get the columns from ALV Table
    v_columns = i_table->get_columns( ).
    IF v_columns IS NOT INITIAL.
      CLEAR:i_column_ref,
            st_column_ref.
      i_column_ref = v_columns->get( ).

* Individual Column Properties.
      CALL METHOD me->column_settings_invoice( ).

** Get columns properties
      v_columns->set_optimize( if_salv_c_bool_sap=>true ).

* Column pos 0
      v_columns->set_column_position( columnname = 'VBELN'(f01)
                                        position = 1 ).
* Column pos 1
      v_columns->set_column_position( columnname = 'FKART'(f02)
                                        position = 2 ).
* Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
* Column pos 2
      v_columns->set_column_position( columnname = 'WAERK'(f27)
                                        position = 3 ).
* End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054

* Column pos 3
      v_columns->set_column_position( columnname = 'VKORG'(f03)
                                        position = 4 ).
* Column pos 4
      v_columns->set_column_position( columnname = 'VTWEG'(f04)
                                        position = 5 ).
* Column pos 5
      v_columns->set_column_position( columnname = 'FKDAT'(f05)
                                        position = 6 ).
* Column pos 6
      v_columns->set_column_position( columnname = 'ERDAT'(f06)
                                        position = 7 ).
* Column pos 7
      v_columns->set_column_position( columnname = 'KUNRG'(f07)
                                        position = 8 ).
* Column pos 8
      v_columns->set_column_position( columnname = 'KUNAG'(f08)
                                        position = 9 ).
* Column pos 9
      v_columns->set_column_position( columnname = 'IDENTCODE'(f09) " identcode
                                        position = 10 ).
* Column pos 10
      v_columns->set_column_position( columnname = 'ISMARTIST'(f10)
                                        position = 11 ).
* Column pos 11
      v_columns->set_column_position( columnname = 'ISMTITLE'(f11)
                                        position = 12 ).

* Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
* Column pos 11
*      v_columns->set_column_position( columnname = 'MEDIUM'(f12)
*                                        position = 12 ).
* end of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

* Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
* Column pos 12
      v_columns->set_column_position( columnname = 'BEZEICHNUNG'(f24)
                                        position = 13 ).
* End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

* Column pos 13
      v_columns->set_column_position( columnname = 'ISMPUBLDATE'(f13)
                                        position = 14 ).

* Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
* Column pos 14
      v_columns->set_column_position( columnname = 'FKIMG'(f25)
                                        position = 15 ).
* End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

* Column pos 15
      v_columns->set_column_position( columnname = 'LFIMG'(f14)
                                        position = 16 ).
* Column pos 16
      v_columns->set_column_position( columnname = 'LIST_SUM'(f15)
                                        position = 17 ).
* Column pos 17
      v_columns->set_column_position( columnname = 'DISC_SUM'(f16)
                                        position = 18 ).
* Column pos 18
      v_columns->set_column_position( columnname = 'NETWR'(f17)
                                        position = 19 ).

* Column pos 19
      v_columns->set_column_position( columnname = 'POSNR'(f23)
                                        position = 20 ).

* Begin of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054
* Column pos 17
*      v_columns->set_column_position( columnname = 'BSTNK_VF'(f18)
*                                        position = 20 ).
* End of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054

* Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
* Column pos 20
      v_columns->set_column_position( columnname = 'BSTNK'(f26)
                                        position = 21 ).
* End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054


* Column pos 21
      v_columns->set_column_position( columnname = 'SALES_TAX'(f19)
                                        position = 22 ).


      CALL METHOD i_table->refresh( ).
      CALL METHOD i_table->display.
    ENDIF. " IF v_columns IS NOT INITIAL

  ENDMETHOD.
*====================================================================*
* METHOD COLUMN_SETTINGS_INVOICE
*====================================================================*
  METHOD column_settings_invoice.
*   Data Declaration
    DATA : lv_medm_txt TYPE scrtext_m, " Medium Field Label
           lv_long_txt TYPE scrtext_l, " Long Field Label
           lv_shrt_txt TYPE scrtext_s. " Short Field Label
    LOOP AT i_column_ref INTO st_column_ref.
      TRY.
          v_column ?= v_columns->get_column( st_column_ref-columnname ).
        CATCH cx_salv_not_found.
      ENDTRY.
      IF v_column IS NOT INITIAL.
        IF v_column->get_columnname( ) = 'VBELN'(f01).
          lv_medm_txt = 'Invoice no.'(t01).
          lv_long_txt = 'Invoice no.'(t01).
          lv_shrt_txt = 'Invoice no.'(t01).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'FKART'(f02).
          v_column->set_technical( if_salv_c_bool_sap=>true ).

*       Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
        ELSEIF v_column->get_columnname( ) = 'WAERK'(f27).
          lv_long_txt = 'Currency'(t22).
          lv_medm_txt = 'Currency'(t22).
          lv_shrt_txt = 'Currency'(t22).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054

        ELSEIF v_column->get_columnname( ) = 'VKORG'(f03).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'VTWEG'(f04).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'FKDAT'(f05).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'ERDAT'(f06).
          lv_long_txt = 'Invoice Date'(t02).
          lv_medm_txt = 'Invoice Date'(t02).
          lv_shrt_txt = 'Invoice Date'(t02).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'KUNRG'(f07).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'KUNAG'(f08).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'IDENTCODE'(f09).
*          Begin of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054
*          lv_long_txt = 'ISBN/EAN'(t03).
*          lv_medm_txt = 'ISBN/EAN'(t03).
*          lv_shrt_txt = 'ISBN/EAN'(t03).
*          End of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054
*         Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
          lv_long_txt = 'Product ID'(t20).
          lv_medm_txt = 'Product ID'(t20).
          lv_shrt_txt = 'Product ID'(t20).
*         End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).

        ELSEIF v_column->get_columnname( ) = 'ISMARTIST'(f10).
          lv_long_txt = 'Author'(t04).
          lv_medm_txt = 'Author'(t04).
          lv_shrt_txt = 'Author'(t04).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'ISMTITLE'(f11).
          lv_long_txt = 'Title'(t05).
          lv_medm_txt = 'Title'(t05).
          lv_shrt_txt = 'Title'(t05).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).

*        ELSEIF v_column->get_columnname( ) = 'MEDIUM'(f12). " (--) PBOSE: 8-Dec-2016: SR_:ED2K903054

        ELSEIF v_column->get_columnname( ) = 'ISMMEDIATYPE'(f24). " (++) PBOSE: 8-Dec-2016: SR_:ED2K903054
          lv_long_txt = 'Medium'(t06).
          lv_medm_txt = 'Medium'(t06).
          lv_shrt_txt = 'Medium'(t06).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'ISMPUBLDATE'(f13).
          lv_long_txt = 'Publication date'(t07).
          lv_medm_txt = 'Publication date'(t07).
          lv_shrt_txt = 'Publication date'(t07).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).

*      Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

        ELSEIF v_column->get_columnname( ) = 'FKIMG'(f25).
          lv_long_txt = 'Order Quantity'(t21).
          lv_medm_txt = 'Order Quantity'(t21).
          lv_shrt_txt = 'Order Quantity'(t21).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).

*      End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

        ELSEIF v_column->get_columnname( ) = 'LFIMG'(f14).
          lv_long_txt = 'Shipped Quantity'(t08).
          lv_medm_txt = 'Shipped Quantity'(t08).
          lv_shrt_txt = 'Shipped Quantity'(t08).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'LIST_SUM'(f15).
          lv_long_txt = 'List Price'(t09).
          lv_medm_txt = 'List Price'(t09).
          lv_shrt_txt = 'List Price'(t09).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'DISC_SUM'(f16).
          lv_long_txt = 'Discount'(t10).
          lv_medm_txt = 'Discount'(t10).
          lv_shrt_txt = 'Discount'(t10).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'NETWR'(f17).
          lv_long_txt = 'Line value'(t11).
          lv_medm_txt = 'Line value'(t11).
          lv_shrt_txt = 'Line value'(t11).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'POSNR'(f23).
          v_column->set_technical( if_salv_c_bool_sap=>true ).

*       Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
        ELSEIF v_column->get_columnname( ) = 'BSTNK'(f26).
*       End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

*        ELSEIF v_column->get_columnname( ) = 'BSTNK_VF'(f18). " PBOSE: 8-Dec-2016: SR_:ED2K903054
          lv_long_txt = 'PO number'(t12).
          lv_medm_txt = 'PO number'(t12).
          lv_shrt_txt = 'PO number'(t12).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'SALES_TAX'(f19).
          lv_long_txt = 'Sales Tax'(t13).
          lv_medm_txt = 'Sales Tax'(t13).
          lv_shrt_txt = 'Sales Tax'(t13).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ENDIF. " IF v_column->get_columnname( ) = 'VBELN'(f01)
      ENDIF. " IF v_column IS NOT INITIAL
    ENDLOOP. " LOOP AT i_column_ref INTO st_column_ref
  ENDMETHOD.
*====================================================================*
* METHOD ALV_DISPLAY_CRD
*====================================================================*
  METHOD alv_display_crd.

    CLEAR: i_table.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = i_table
          CHANGING
            t_table      = i_final_crd.
      CATCH cx_salv_msg .
    ENDTRY.


** Get functions details
    v_functions = i_table->get_functions( ).

** Activate All Buttons in Tool Bar
    v_functions->set_all( if_salv_c_bool_sap=>true ).

** Layout Settings  *******
    CLEAR : v_layout,
            v_layout_key.
    v_layout_key-report = sy-repid . "Set Report ID as Layout Key"

    IF i_table IS NOT INITIAL.
      v_layout = i_table->get_layout( ). "Get Layout of Table"
    ENDIF. " IF i_table IS NOT INITIAL
    IF v_layout IS NOT INITIAL.
      v_layout->set_key( v_layout_key ). "Set Report Id to Layout"
      v_layout->set_save_restriction( if_salv_c_layout=>restrict_none ). "No Restriction to Save Layout"
    ENDIF. " IF v_layout IS NOT INITIAL

******* Global Display Settings  *******
    CLEAR : v_display.
    v_title = 'Credit Details Report'(006).
    IF i_table IS NOT INITIAL.
      v_display = i_table->get_display_settings( ). " Global Display settings"
    ENDIF. " IF i_table IS NOT INITIAL
    IF v_display IS NOT INITIAL.
      v_display->set_striped_pattern( if_salv_c_bool_sap=>true ). "Activate Strip Pattern"
      v_display->set_list_header( v_title ).
    ENDIF. " IF v_display IS NOT INITIAL


** Get the columns from ALV Table
    v_columns = i_table->get_columns( ).
    IF v_columns IS NOT INITIAL.
      CLEAR:i_column_ref,
            st_column_ref.
      i_column_ref = v_columns->get( ).

** Individual Column Properties.
      CALL METHOD me->column_settings_credit.

** Get columns properties
      v_columns->set_optimize( if_salv_c_bool_sap=>true ).

* Column pos 0
      v_columns->set_column_position( columnname = 'VBELN'(f01)
                                        position = 1 ).
* Column pos 1
      v_columns->set_column_position( columnname = 'FKART'(f02)
                                        position = 2 ).

* Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
* Column pos 2
      v_columns->set_column_position( columnname = 'WAERK'(f27)
                                        position = 3 ).
* End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054

* Column pos 3
      v_columns->set_column_position( columnname = 'VKORG'(f03)
                                        position = 4 ).
* Column pos 4
      v_columns->set_column_position( columnname = 'VTWEG'(f04)
                                        position = 5 ).
* Column pos 5
      v_columns->set_column_position( columnname = 'FKDAT'(f05)
                                        position = 6 ).
* Column pos 6
      v_columns->set_column_position( columnname = 'ERDAT'(f06)
                                        position = 7 ).
* Column pos 7
      v_columns->set_column_position( columnname = 'KUNRG'(f07)
                                        position = 8 ).
* Column pos 8
      v_columns->set_column_position( columnname = 'KUNAG'(f08)
                                        position = 9 ).
* Column pos 9
      v_columns->set_column_position( columnname = 'IDENTCODE'(f09)
                                        position = 10 ).
* Column pos 10
      v_columns->set_column_position( columnname = 'ISMTITLE'(f11)
                                        position = 11 ).
* Column pos 11
      v_columns->set_column_position( columnname = 'FKIMG'(f20)
                                        position = 12 ).
* Column pos 12
      v_columns->set_column_position( columnname = 'LIST_SUM'(f15)
                                        position = 13 ).
* Column pos 13
      v_columns->set_column_position( columnname = 'DISC_SUM'(f16)
                                        position = 14 ).
* Column pos 14
      v_columns->set_column_position( columnname = 'NETWR'(f17)
                                        position = 15 ).
* Column pos 15
      v_columns->set_column_position( columnname = 'POSNR'(f23)
                                        position = 16 ).
* Column pos 16
      v_columns->set_column_position( columnname = 'AUGRU_AUFT'(f21)
                                        position = 17 ).
* Column pos 17
      v_columns->set_column_position( columnname = 'VA_VGBEL'(f22)
                                        position = 18 ).
* Column pos 18
      v_columns->set_column_position( columnname = 'SALES_TAX'(f19)
                                        position = 19 ).

      CALL METHOD i_table->refresh( ).
      CALL METHOD i_table->display.
    ENDIF. " IF v_columns IS NOT INITIAL
  ENDMETHOD.
*====================================================================*
* METHOD COLUMN_SETTINGS_CREDIT
*====================================================================*
  METHOD column_settings_credit.
*   Data Declaration
    DATA : lv_medm_txt TYPE scrtext_m, " Medium Field Label
           lv_long_txt TYPE scrtext_l, " Long Field Label
           lv_shrt_txt TYPE scrtext_s. " Short Field Label
    LOOP AT i_column_ref INTO st_column_ref.
      TRY.
          v_column ?= v_columns->get_column( st_column_ref-columnname ).
        CATCH cx_salv_not_found.
      ENDTRY.
      IF v_column IS NOT INITIAL.
        IF v_column->get_columnname( ) = 'VBELN'(f01).
          lv_long_txt = 'Credit Memo no.'(t14).
          lv_medm_txt = 'Credit Memo no.'(t14).
          lv_shrt_txt = 'Credit Memo no.'(t14).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'FKART'(f02).
          v_column->set_technical( if_salv_c_bool_sap=>true ).

*       Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
        ELSEIF v_column->get_columnname( ) = 'WAERK'(f27).
          lv_long_txt = 'Currency'(t22).
          lv_medm_txt = 'Currency'(t22).
          lv_shrt_txt = 'Currency'(t22).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054

        ELSEIF v_column->get_columnname( ) = 'VKORG'(f03).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'VTWEG'(f04).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'FKDAT'(f05).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'ERDAT'(f06).
          lv_long_txt = 'Credit Memo date'(t15).
          lv_medm_txt = 'Credit Memo date'(t15).
          lv_shrt_txt = 'Credit Memo date'(t15).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'KUNRG'(f07).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'KUNAG'(f08).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'IDENTCODE'(f09).
*         Begin of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054
*          lv_long_txt = 'ISBN/EAN'(t03).
*          lv_medm_txt = 'ISBN/EAN'(t03).
*          lv_shrt_txt = 'ISBN/EAN'(t03).
*         End of DEL: PBOSE: 8-Dec-2016: SR_:ED2K903054

*         Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
          lv_long_txt = 'Product ID'(t20).
          lv_medm_txt = 'Product ID'(t20).
          lv_shrt_txt = 'Product ID'(t20).
*         End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'ISMTITLE'(f11).
          lv_long_txt = 'Title'(t05).
          lv_medm_txt = 'Title'(t05).
          lv_shrt_txt = 'Title'(t05).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'FKIMG'(f20).
          lv_long_txt = 'Quantity'(t16).
          lv_medm_txt = 'Quantity'(t16).
          lv_shrt_txt = 'Quantity'(t16).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'LIST_SUM'(f15).
          lv_long_txt = 'Price'(t17).
          lv_medm_txt = 'Price'(t17).
          lv_shrt_txt = 'Price'(t17).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'DISC_SUM'(f16).
          lv_long_txt = 'Discount'(t10).
          lv_medm_txt = 'Discount'(t10).
          lv_shrt_txt = 'Discount'(t10).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'NETWR'(f17).
          lv_long_txt = 'Line value'(t11).
          lv_medm_txt = 'Line value'(t11).
          lv_shrt_txt = 'Line value'(t11).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'POSNR'(f23).
          v_column->set_technical( if_salv_c_bool_sap=>true ).
        ELSEIF v_column->get_columnname( ) = 'AUGRU_AUFT'(f21).
          lv_long_txt = 'Rejection reason'(t18).
          lv_medm_txt = 'Rejection reason'(t18).
          lv_shrt_txt = 'Rejection reason'(t18).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'VA_VGBEL'(f22).
          lv_long_txt = 'Original Invoice no.'(t19).
          lv_medm_txt = 'Original Invoice no.'(t19).
          lv_shrt_txt = 'Original Invoice no.'(t19).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ELSEIF v_column->get_columnname( ) = 'SALES_TAX'(f19).
          lv_long_txt = 'Sales Tax'(t13).
          lv_medm_txt = 'Sales Tax'(t13).
          lv_shrt_txt = 'Sales Tax'(t13).
          v_column->set_long_text( lv_long_txt ).
          v_column->set_medium_text( lv_medm_txt ).
          v_column->set_short_text( lv_shrt_txt ).
        ENDIF. " IF v_column->get_columnname( ) = 'VBELN'(f01)
      ENDIF. " IF v_column IS NOT INITIAL
    ENDLOOP. " LOOP AT i_column_ref INTO st_column_ref
  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
*&      Form  F_POP_NUM_QUANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_INV_DET  text
*      <--P_EX_INV_DET  text
*----------------------------------------------------------------------*
FORM f_pop_derived_val_inv   USING fp_inv_temp    TYPE tty_inv_temp
                          CHANGING fp_ex_inv_det  TYPE tty_final_inv.
*  Begin of DEL: PBOSE:31-Jan-2017
*  TYPES : BEGIN OF lty_sum,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            krech TYPE krech,  " Calculation type for condition
*            ltsum TYPE kbetr,  " List Sum
*            discn TYPE kbetr,  " Discount Value
*            sltax TYPE kwert,  " Sales Tax
*          END OF lty_sum,
*
*          BEGIN OF lty_sum_val,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            ltsum TYPE kbetr,  " List Sum
*            discn TYPE kbetr,  " Discount Value
*            sltax TYPE kwert,  " Sales Tax
*          END OF lty_sum_val,
*
*          BEGIN OF lty_sum_vl,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            krech TYPE krech,  " Calculation type for condition
*            disc  TYPE char15, " Discount Value
*          END OF lty_sum_vl.
*  End of DEL: PBOSE:31-Jan-2017
*
** Data Declaration
  DATA :     li_inv_temp    TYPE tty_inv_temp,
             lst_inv_temp   TYPE ty_inv_temp,
             lst_inv_detail TYPE ty_final_inv.
*  Begin of DEL: PBOSE:31-Jan-2017
*  li_sum         TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
*         li_sum1        TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
**         li_sum2        TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
*         li_sum_val     TYPE STANDARD TABLE OF lty_sum_val  INITIAL SIZE 0,
*         li_sum_vl      TYPE STANDARD TABLE OF lty_sum_vl  INITIAL SIZE 0,
*         lst_sum        TYPE lty_sum,
**         lst_sum_dummy  TYPE lty_sum,
*         lst_sum_val    TYPE lty_sum_val,
**         lst_sum_vl     TYPE lty_sum_vl,
*         lst_inv_det    TYPE ty_inv_temp,
*         lv_temp        TYPE char13,   " Temp of type CHAR13
*         lv_index       TYPE sy-index, " ABAP System Field: Loop Index
*         lv_sales_tax   TYPE kwert,    " Condition value
*         lv_discn_sum   TYPE kbetr,    " Rate (condition amount or percentage)
*         lv_list_sum    TYPE kbetr.    " Rate (condition amount or percentage)
**         lv_disc_val_b  TYPE kbetr,    " Rate (condition amount or percentage)
**         lv_disc_val_a  TYPE kbetr,    " Rate (condition amount or percentage)
**         lv_ds_val      TYPE kbetr,    " Rate (condition amount or percentage)
**         lv_discnt_per  TYPE char15.   " Discnt_per of type CHAR15
*
** Constant Declare
**  CONSTANTS : lc_b   TYPE krech VALUE 'B', " Calculation type for condition : Fixed Amount
**              lc_pcn TYPE char1 VALUE '%', " Pcn of type CHAR1
**              lc_a   TYPE krech VALUE 'A'. " Calculation type for condition : Percentage
*
** Calculate sales tax and list sum values as per item number.
*  LOOP AT fp_inv_temp INTO lst_inv_det.
*    lst_sum-vbeln = lst_inv_det-vbeln.
*    lst_sum-posnr = lst_inv_det-posnr.
*    lst_sum-kposn = lst_inv_det-kposn.
*    lst_sum-ltsum = lst_inv_det-list_sum.
*    lst_sum-discn = lst_inv_det-disc_percent.
*    lst_sum-sltax = lst_inv_det-sales_tax.
*    lst_sum-krech = lst_inv_det-krech.
*    APPEND lst_sum TO li_sum.
*    CLEAR lst_sum.
*  ENDLOOP. " LOOP AT fp_inv_temp INTO lst_inv_det
*
*  li_sum1[] = li_sum.
*  SORT li_sum1 BY vbeln posnr kposn.
*  LOOP AT li_sum1 INTO lst_sum.
*    AT NEW kposn.
*      CLEAR : lv_sales_tax,
*              lst_sum_val,
*              lv_list_sum.
*    ENDAT.
*
*    lv_sales_tax = lv_sales_tax + lst_sum-sltax.
*    lv_list_sum  = lv_list_sum  + lst_sum-ltsum.
*    lv_discn_sum = lv_discn_sum + lst_sum-discn.
*    AT END OF kposn.
*      lst_sum_val-vbeln = lst_sum-vbeln.
*      lst_sum_val-posnr = lst_sum-posnr.
*      lst_sum_val-kposn = lst_sum-kposn.
*      lst_sum_val-ltsum = lv_list_sum.
*      lst_sum_val-discn = lv_discn_sum.
*      lst_sum_val-sltax = lv_sales_tax.
*      APPEND lst_sum_val TO li_sum_val.
*      CLEAR lst_sum_val.
*    ENDAT.
*  ENDLOOP. " LOOP AT li_sum1 INTO lst_sum
*
**  li_sum2[] = li_sum.
**  SORT li_sum2 BY vbeln posnr kposn krech.
**  LOOP AT li_sum2 INTO lst_sum.
**    lst_sum_dummy = lst_sum.
**    AT NEW krech.
**      CLEAR : lv_disc_val_b,
**              lst_sum_val,
**              lv_disc_val_a.
**    ENDAT.
**    IF lst_sum-krech EQ lc_b.
**      lv_disc_val_b = lv_disc_val_b + lst_sum_dummy-discn.
**    ENDIF. " IF lst_sum-krech EQ lc_b
**
**    IF lst_sum-krech EQ lc_a.
**      lv_disc_val_a = lv_disc_val_a + lst_sum_dummy-discn.
**    ENDIF. " IF lst_sum-krech EQ lc_a
**
**    AT END OF krech.
**      lst_sum_vl-vbeln = lst_sum-vbeln.
**      lst_sum_vl-posnr = lst_sum-posnr.
**      lst_sum_vl-kposn = lst_sum-kposn.
**      lst_sum_vl-krech = lst_sum-krech.
**      IF lst_sum_dummy-krech EQ  lc_a.
**          lv_ds_val = ( lv_disc_val_a / 10 ).
**          lv_temp = lv_ds_val.
**          CONCATENATE lv_temp lc_pcn INTO lv_discnt_per.
**          lst_sum_vl-disc = lv_discnt_per.
**          APPEND lst_sum_vl TO li_sum_vl.
**          CLEAR : lst_sum_vl,
**                  lv_temp,
**                  lv_ds_val,
**                  lv_discnt_per.
**      ELSEIF   lst_sum_dummy-krech EQ lc_b.
**          lst_sum_vl-disc = lv_disc_val_b.
**          APPEND lst_sum_vl TO li_sum_vl.
**          CLEAR lst_sum_vl.
**      ENDIF. " IF lst_sum_dummy-krech EQ lc_a
**    ENDAT.
**  ENDLOOP. " LOOP AT li_sum2 INTO lst_sum
*  End of DEL: PBOSE:31-Jan-2017

  li_inv_temp[] = fp_inv_temp[].
*  Begin of DEL: PBOSE:31-Jan-2017
*  SORT :li_inv_temp  BY vbeln
*                        posnr,
*        li_sum_val   BY vbeln
*                        kposn.
**        li_sum_vl    BY vbeln
**                        kposn
**                        krech.
*
*
**  LOOP AT li_sum_vl INTO lst_sum_vl.
**    READ TABLE li_sum_val INTO lst_sum_val WITH KEY vbeln = lst_sum_vl-vbeln
**                                                    posnr = lst_sum_vl-posnr
**                                             BINARY SEARCH.
**    IF sy-subrc EQ 0.
**      READ TABLE li_inv_temp INTO lst_inv_temp
**                             WITH KEY vbeln = lst_sum_vl-vbeln
**                                                    posnr = lst_sum_vl-posnr
**                                             BINARY SEARCH.
**      IF sy-subrc IS INITIAL.
*  End of DEL: PBOSE:31-Jan-2017
  LOOP AT li_inv_temp INTO lst_inv_temp.
*    Begin of DEL: PBOSE:31-Jan-2017
*    READ TABLE li_sum_val INTO lst_sum_val WITH KEY vbeln = lst_inv_temp-vbeln
*                                                    posnr = lst_inv_temp-posnr
*                                               BINARY SEARCH.
*    IF sy-subrc EQ 0.
*  End of DEL: PBOSE:31-Jan-2017

    lst_inv_detail-vbeln       = lst_inv_temp-vbeln.
    lst_inv_detail-fkart       = lst_inv_temp-fkart.
    lst_inv_detail-waerk       = lst_inv_temp-waerk.
    lst_inv_detail-vkorg       = lst_inv_temp-vkorg.
    lst_inv_detail-vtweg       = lst_inv_temp-vtweg.
    lst_inv_detail-fkdat       = lst_inv_temp-fkdat.
    lst_inv_detail-erdat       = lst_inv_temp-erdat.
    lst_inv_detail-kunrg       = lst_inv_temp-kunrg.
    lst_inv_detail-kunag       = lst_inv_temp-kunag.
    lst_inv_detail-identcode   = lst_inv_temp-identcode.
    lst_inv_detail-ismartist   = lst_inv_temp-ismartist.
    lst_inv_detail-ismtitle    = lst_inv_temp-ismtitle.
    lst_inv_detail-bezeichnung = lst_inv_temp-bezeichnung.
    lst_inv_detail-ismpubldate = lst_inv_temp-ismpubldate.
    lst_inv_detail-fkimg       = lst_inv_temp-fkimg.
    lst_inv_detail-lfimg       = lst_inv_temp-lfimg.
    lst_inv_detail-netwr       = lst_inv_temp-netwr.
    lst_inv_detail-posnr       = lst_inv_temp-posnr.
    lst_inv_detail-bstnk       = lst_inv_temp-bstnk.
*      ENDIF. " IF sy-subrc IS INITIAL  "(-) PBOSE:31-Jan-2017
    lst_inv_detail-list_sum    = lst_inv_temp-list_sum.
    lst_inv_detail-sales_tax   = lst_inv_temp-sales_tax.
    lst_inv_detail-disc_sum    = lst_inv_temp-disc_sum.
*    ENDIF. " IF sy-subrc EQ 0     " (-) PBOSE:31-Jan-2017
**    ENDIF. " IF sy-subrc EQ 0    " (-) PBOSE:31-Jan-2017
**    lst_inv_detail-disc_sum    = lst_sum_vl-disc.  " (-) PBOSE:31-Jan-2017
    APPEND lst_inv_detail TO fp_ex_inv_det.
    CLEAR lst_inv_detail.
  ENDLOOP. " LOOP AT li_inv_temp INTO lst_inv_temp
*
**  ENDLOOP. " LOOP AT li_sum_vl INTO lst_sum_vl
*
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_DERIVED_VAL_CRD
*&---------------------------------------------------------------------*
* Populate credit memo values
*----------------------------------------------------------------------*
*      -->FP_I_CRD_TEMP
*      <--FP_EX_CRD_DET
*----------------------------------------------------------------------*
FORM f_pop_derived_val_crd  USING    fp_crd_temp   TYPE tty_crd_temp
                            CHANGING fp_ex_crd_det TYPE tty_final_crd.

*  Begin of DEL: PBOSE:31-Jan-2017
*  TYPES : BEGIN OF lty_sum,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            krech TYPE krech,  " Calculation type for condition
*            ltprc TYPE kbetr,  " List Price
*            discn TYPE kbetr,  " Discount Value
*            sltax TYPE kwert,  " Sales Tax
*          END OF lty_sum,
*
*          BEGIN OF lty_sum_val,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            ltprc TYPE kbetr,  " List Sum
*            sltax TYPE kwert,  " Sales Tax
*          END OF lty_sum_val,
*
*          BEGIN OF lty_sum_vl,
*            vbeln TYPE vbeln,  " Sales and Distribution Document Number
*            posnr TYPE posnr,  " Item number of the SD document
*            kposn TYPE kposn,  " Condition item number
*            krech TYPE krech,  " Calculation type for condition
*            disc  TYPE char15, " Discount Value
*          END OF lty_sum_vl.
*  End of DEL: PBOSE:31-Jan-2017

* Data Declaration
  DATA :
*  Begin of DEL: PBOSE:31-Jan-2017
*         li_sum         TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
*         li_sum1        TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
*         li_sum2        TYPE STANDARD TABLE OF lty_sum      INITIAL SIZE 0,
*         li_sum_val     TYPE STANDARD TABLE OF lty_sum_val  INITIAL SIZE 0,
*         li_sum_vl      TYPE STANDARD TABLE OF lty_sum_vl   INITIAL SIZE 0,
*         lst_sum        TYPE lty_sum,
*         lst_sum_dummy  TYPE lty_sum,
*         lst_sum_val    TYPE lty_sum_val,
*         lst_sum_vl     TYPE lty_sum_vl,
*         lst_crd_det    TYPE ty_crd_temp,
*         lv_disc_percnt TYPE kbetr,  " Rate (condition amount or percentage)
*         lv_temp        TYPE char13, " Temp of type CHAR13
*         lv_ds_val      TYPE kbetr,  " Rate (condition amount or percentage)
*         lv_sales_tax   TYPE kwert,  " Condition value
*         lv_list_price  TYPE kbetr,  " Rate (condition amount or percentage)
*         lv_disc_val_b  TYPE kbetr,  " Rate (condition amount or percentage)
*         lv_disc_val_a  TYPE kbetr,  " Rate (condition amount or percentage)
*         lv_discnt_per  TYPE char15, " Discnt_per of type CHAR15
*  End of DEL: PBOSE:31-Jan-2017
    li_crd_temp    TYPE tty_crd_temp,
    lst_crd_temp   TYPE ty_crd_temp,
    lst_crd_detail TYPE ty_final_crd,
    lv_textname    TYPE char16, " Textname of type CHAR16
    lv_rejrsn      TYPE char30. " Rejrsn of type CHAR132

*  Begin of DEL: PBOSE:31-Jan-2017
* Constant Declare
*  CONSTANTS : lc_b   TYPE krech VALUE 'B', " Calculation type for condition : Fixed Amount
*              lc_pcn TYPE char1 VALUE '%', " Pcn of type CHAR1
*              lc_a   TYPE krech VALUE 'A'. " Calculation type for condition : Percentage

* Calculate sales tax and list sum values as per item number.
*  LOOP AT fp_crd_temp INTO lst_crd_det.
*    lst_sum-vbeln = lst_crd_det-vbeln.
*    lst_sum-posnr = lst_crd_det-posnr.
*    lst_sum-kposn = lst_crd_det-kposn.
*    lst_sum-ltprc = lst_crd_det-list_sum.
*    lst_sum-discn = lst_crd_det-disc_percent.
*    lst_sum-sltax = lst_crd_det-sales_tax.
*    lst_sum-krech = lst_crd_det-krech.
*    APPEND lst_sum TO li_sum.
*    CLEAR lst_sum.
*  ENDLOOP. " LOOP AT fp_crd_temp INTO lst_crd_det
*

*  li_sum1[] = li_sum.
*  SORT li_sum1 BY vbeln posnr kposn.
*  LOOP AT li_sum1 INTO lst_sum.
*    AT NEW kposn.
*      CLEAR : lv_sales_tax,
*              lst_sum_val,
*              lv_list_price.
*    ENDAT.
*
*    lv_sales_tax  = lv_sales_tax  + lst_sum-sltax.
*    lv_list_price = lv_list_price + lst_sum-ltprc.
*
*    AT END OF kposn.
*      lst_sum_val-vbeln = lst_sum-vbeln.
*      lst_sum_val-posnr = lst_sum-posnr.
*      lst_sum_val-kposn = lst_sum-kposn.
*      lst_sum_val-ltprc = lv_list_price.
*      lst_sum_val-sltax = lv_sales_tax.
*      APPEND lst_sum_val TO li_sum_val.
*      CLEAR lst_sum_val.
*    ENDAT.
*  ENDLOOP. " LOOP AT li_sum1 INTO lst_sum
*
*  li_sum2[] = li_sum.
*  SORT li_sum2 BY vbeln posnr kposn krech.
*  LOOP AT li_sum2 INTO lst_sum.
*    lst_sum_dummy = lst_sum.
*    AT NEW krech.
*      CLEAR : lv_disc_val_b,
*              lst_sum_val,
*              lv_disc_val_a.
*    ENDAT.
*    IF lst_sum-krech EQ lc_b.
*      lv_disc_val_b = lv_disc_val_b + lst_sum_dummy-discn.
*    ENDIF. " IF lst_sum-krech EQ lc_b
*
*    IF lst_sum-krech EQ lc_a.
*      lv_disc_val_a = lv_disc_val_a + lst_sum_dummy-discn.
*    ENDIF. " IF lst_sum-krech EQ lc_a
*
*    AT END OF krech.
*      lst_sum_vl-vbeln = lst_sum-vbeln.
*      lst_sum_vl-posnr = lst_sum-posnr.
*      lst_sum_vl-kposn = lst_sum-kposn.
*      lst_sum_vl-krech = lst_sum-krech.
*      IF lst_sum_dummy-krech EQ  lc_a.
*        lv_ds_val = ( lv_disc_val_a / 10 ).
*        lv_temp = lv_ds_val.
*        CONCATENATE lv_temp lc_pcn INTO lv_discnt_per.
*        lst_sum_vl-disc = lv_discnt_per.
*        APPEND lst_sum_vl TO li_sum_vl.
*        CLEAR : lst_sum_vl,
*                lv_temp,
*                lv_ds_val,
*                lv_discnt_per.
*      ELSEIF   lst_sum_dummy-krech EQ lc_b.
*        lst_sum_vl-disc = lv_disc_val_b.
*        APPEND lst_sum_vl TO li_sum_vl.
*        CLEAR lst_sum_vl.
*      ENDIF. " IF lst_sum_dummy-krech EQ lc_a
*    ENDAT.
*  ENDLOOP. " LOOP AT li_sum2 INTO lst_sum
*  End of DEL: PBOSE:31-Jan-2017
  li_crd_temp[] = fp_crd_temp[].
*  Begin of DEL: PBOSE:31-Jan-2017
*  SORT : li_crd_temp  BY vbeln
*                        posnr,
*         li_sum_val   BY vbeln
*                        kposn,
*         li_sum_vl    BY vbeln
*                        kposn
*                        krech.

*  LOOP AT li_sum_vl INTO lst_sum_vl.
*    READ TABLE li_sum_val INTO lst_sum_val WITH KEY vbeln = lst_sum_vl-vbeln
*                                                    posnr = lst_sum_vl-posnr
*                                             BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      READ TABLE li_crd_temp INTO lst_crd_temp
*                             WITH KEY vbeln = lst_sum_vl-vbeln
*                                      posnr = lst_sum_vl-posnr
*                                      BINARY SEARCH.
*      IF sy-subrc IS INITIAL.
*  End of DEL: PBOSE:31-Jan-2017
  LOOP AT li_crd_temp INTO lst_crd_temp.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_crd_temp-vbeln
      IMPORTING
        output = lst_crd_temp-vbeln.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_crd_temp-posnr
      IMPORTING
        output = lst_crd_temp-posnr.

    CONCATENATE lst_crd_temp-vbeln lst_crd_temp-posnr INTO lv_textname.
    PERFORM f_pop_rej_resn USING    lv_textname
                           CHANGING lv_rejrsn.

    lst_crd_detail-vbeln       = lst_crd_temp-vbeln.
    lst_crd_detail-fkart       = lst_crd_temp-fkart.
    lst_crd_detail-waerk       = lst_crd_temp-waerk.
    lst_crd_detail-vkorg       = lst_crd_temp-vkorg.
    lst_crd_detail-vtweg       = lst_crd_temp-vtweg.
    lst_crd_detail-fkdat       = lst_crd_temp-fkdat.
    lst_crd_detail-erdat       = lst_crd_temp-erdat.
    lst_crd_detail-kunrg       = lst_crd_temp-kunrg.
    lst_crd_detail-kunag       = lst_crd_temp-kunag.
    lst_crd_detail-identcode   = lst_crd_temp-identcode.
    lst_crd_detail-ismtitle    = lst_crd_temp-ismtitle.
    lst_crd_detail-fkimg       = lst_crd_temp-fkimg.
    lst_crd_detail-netwr       = lst_crd_temp-netwr.
    lst_crd_detail-posnr       = lst_crd_temp-posnr.
    lst_crd_detail-augru_auft  = lv_rejrsn.
    lst_crd_detail-va_vgbel    = lst_crd_temp-va_vgbel.
*      ENDIF. " IF sy-subrc IS INITIAL   " (-)PBOSE:31-Jan-2017
    lst_crd_detail-list_sum    = lst_crd_temp-list_sum.
    lst_crd_detail-sales_tax   = lst_crd_temp-sales_tax.
*    ENDIF. " IF sy-subrc EQ 0      " (-)PBOSE:31-Jan-2017
    lst_crd_detail-disc_sum    = lst_crd_temp-disc_sum.
    APPEND lst_crd_detail TO fp_ex_crd_det.
    CLEAR lst_crd_detail.

  ENDLOOP. " LOOP AT li_crd_temp INTO lst_crd_temp

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_REJ_RESN
*&---------------------------------------------------------------------*
*  Populate rejection reason
*----------------------------------------------------------------------*
*      -->FP_LV_TEXTNAME  Concatinaton of VBELN and POSNR
*      <--FP_LV_REJRSN    Rejection Reason
*----------------------------------------------------------------------*
FORM f_pop_rej_resn  USING    fp_lv_textname TYPE char16  " Pop_rej_resn using fp_l of type CHAR16
                     CHANGING fp_lv_rejrsn   TYPE char30. " Lv_rejrsn of type CHAR132

* Constant Declaration:
  CONSTANTS : lc_obj TYPE tdobject VALUE 'VBBP', " Texts: Application Object
              lc_id  TYPE tdid     VALUE '0001'. " Text ID

* Data Declaration
  DATA : li_lines         TYPE STANDARD TABLE OF tline INITIAL SIZE 0, " SAPscript: Text Lines
         lv_reject_rsn    TYPE char30,                                 " Reject_rsn of type CHAR132
         lv_txt_string    TYPE char30,                                 " Txt_string of type CHAR30
         lst_line         TYPE tline,                                  " SAPscript: Text Lines
         lv_txtname       TYPE tdobname,                               " Name
         lv_txt_string_nw TYPE cmsuquestiontext.                       " CMS: Question Text for Decision Dialog Box


  lv_txtname = fp_lv_textname.
* Get the text name.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = lc_id
      language                = sy-langu
      name                    = lv_txtname
      object                  = lc_obj
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF sy-subrc IS INITIAL.
    READ TABLE li_lines INTO lst_line INDEX 1.
    IF sy-subrc IS INITIAL.
      lv_reject_rsn = lst_line-tdline+0(29).
    ENDIF. " IF sy-subrc IS INITIAL

    fp_lv_rejrsn = lv_reject_rsn.

  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
