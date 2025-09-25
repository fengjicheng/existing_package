*&---------------------------------------------------------------------*
*& Report  ZQTCR_SALES_ORDER_ITEM_TEXT
*&
*&---------------------------------------------------------------------*
* PROGRAM NAME:ZQTCR_SALES_ORDER_ITEM_TEXT
* PROGRAM DESCRIPTION: Fetch the sale order-lineitem text elements description
* DEVELOPER: VDPATABALL
* CREATION DATE: 02/28/2019
* OBJECT ID: R082
* Change Reference:  RITM0123079
* TRANSPORT NUMBER(S):  ED1K909719
*----------------------------------------------------------------------*

REPORT zqtcr_sales_ord_item_text_r082 NO STANDARD PAGE HEADING.


INCLUDE zqtcn_sales_ord_text_r082_top IF FOUND.

INCLUDE zqtcn_sales_ord_text_r082_sel IF FOUND.

INCLUDE zqtcn_sales_ord_text_r082_sub IF FOUND.


AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_object.

  PERFORM f_validation_object.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_id.

  PERFORM f_validation_tdid.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM f_file_path.

START-OF-SELECTION.

  PERFORM f_get_data.

  IF rb_pre = abap_true.
    PERFORM f_presentation_layer.
  ELSEIF rb_appl = abap_true.
    PERFORM f_application_layer.
  ELSEIF   rb_alv = abap_true.
    PERFORM f_display.
  ENDIF.
  LEAVE LIST-PROCESSING.
