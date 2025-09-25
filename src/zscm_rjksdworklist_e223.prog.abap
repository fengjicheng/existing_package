*&---------------------------------------------------------------------*
*& Modulpool  ZRJKSDWORKLIST
*&
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Module Pool Program of 9910 Screen
*-----------------------------------------------------------------------*
PROGRAM ZSCM_RJKSDWORKLIST_E223.

TABLES: RJKSDWORKLIST_CHANGEFIELDS.

data: gv_pedex2_active type xfeld.

INCLUDE MJ_XFELD.
INCLUDE zscm_rjksdworklist_module_e223.
