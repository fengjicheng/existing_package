*----------------------------------------------------------------------*
***INCLUDE ZRJKSDWORKLIST_PBO_9910O01.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Modules of 9910 Screen
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_9910  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_9910 OUTPUT.

  PERFORM pbo_9910_output.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI9910  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai9910 INPUT.

  PERFORM pai_9910_input.

ENDMODULE.

FORM pbo_9910_output.

  STATICS: x_310_processed TYPE xfeld.
  IF x_310_processed IS INITIAL.
    x_310_processed = con_angekreuzt.
*   screen modifikation der PDEX2-Felder erfolgt über Schalter
*   in der SE51 ! Hier ist nichts zu tun.
    IF gv_pedex2_active IS INITIAL.
*     PEDEX2 nicht aktiv: Neue Datums-Selektionen werden ausgeblendet
    ELSE.
*     PEDEX2 aktiv: Neue Datums-Selektionen bleiben eingeblendet
    ENDIF.
  ENDIF. " x_310_processed is initial.

ENDFORM. " pbo_310_output.

FORM pai_9910_input.

  IF rjksdworklist_changefields-date_from >
     rjksdworklist_changefields-date_to.
    MESSAGE e068(jksdworklist).
  ENDIF.

ENDFORM. " pai_310_input.
