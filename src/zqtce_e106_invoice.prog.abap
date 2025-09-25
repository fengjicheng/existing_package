*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_E106_INVOICE
*               Called from Standard program
* PROGRAM DESCRIPTION: Module pool program to add custom fields in
*                      VF01/VF02/VF03 transaction
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID:       E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
PROGRAM zqtce_e106_invoice.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
* License group field will come in display mode for VFXX transactions
*----------------------------------------------------------------------*
MODULE status_0001 OUTPUT.

  LOOP AT SCREEN.
    IF screen-group1 = 'GR1'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


ENDMODULE.
