*&---------------------------------------------------------------------*
*& Report  ZQTCR_DELIVERYBLOCK_SALES_E351                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_SALES_E351                         *
* PROGRAM DESCRIPTION: The functionality of the program is to confirm  *
*       if the payment confirmation has been successfully received from*
*       bank or not. If there is some issue with the payment clearance *
*       then for the ZSUB/ZREW order, the delivery block will be       *
*       updated to 66-Return Direct Debit from DD -Direct Debits Order.*
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 02/09/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S):  ED2K925720                                     *
*----------------------------------------------------------------------*
REPORT ZQTCR_DELIVERYBLOCK_SALES_E351.
*----------------------------------------------------------------------*
* Includes  -----------------------------------------------------*
* ---------------------------------------------------------------------*
INCLUDE zqtcr_deliveryblock_e351_top.
INCLUDE zqtcr_deliveryblock_e351_sel.
INCLUDE zqtcr_deliveryblock_e351_f01.
*----------------------------------------------------------------------*
* Initialization-*
* ---------------------------------------------------------------------*
*INITIALIZATION.
*--*Initialize global variables and selection screen elements
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN.
* ---------------------------------------------------------------------*
*AT SELECTION-SCREEN.
*--*Validate selection screen variables
*----------------------------------------------------------------------*
* START-OF-SELECTION..
* ---------------------------------------------------------------------*
START-OF-SELECTION.
"Fetch ZCACONSTNAT table entries
  PERFORM f_fetch_constant_entries.
"Fetch Invoices and apply blocks
  PERFORM f_fetch_invoice_apply_block.
*----------------------------------------------------------------------*
* END-OF-SELECTION.
* ---------------------------------------------------------------------*
END-OF-SELECTION.
"Display the output.
   PERFORM f_delivery_block_display.
