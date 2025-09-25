*&---------------------------------------------------------------------*
*& Report ZQTCR_ERPSLS_CUSTOMERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_erpsls_customers.

"Data delcarations
INCLUDE zqtcn_erpsls_customers_top IF FOUND.

"Selection screen
INCLUDE zqtcn_erpsls_customers_sel IF FOUND.

"Subroutine logic
INCLUDE zqtcn_erpsls_customers_sub IF FOUND.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR szterm-low.
  PERFORM f_get_values_for_zterm CHANGING szterm-low.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR szterm-high.
  PERFORM f_get_values_for_zterm CHANGING szterm-high.

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_hide_screen_fields.

START-OF-SELECTION .
  PERFORM f_data_selection.
  IF i_customers[] IS INITIAL.
    MESSAGE s490(vr).
    EXIT.
  ENDIF.

END-OF-SELECTION.
  PERFORM f_fill_fieldcatalog.
  PERFORM f_build_layout.
  PERFORM f_reuse_alv_list_display.
