"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\SE:PUBLIC\SE:PROCEDURES\EI
ENHANCEMENT 0 ZSCM_CUSTOM_METHODS_R096.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 21-AUG-2020
* DESCRIPTION: Event Handler Method: HANDLE_HOTSPOT_CLICK Definition
* for LITHO Report
*-----------------------------------------------------------------------*

  methods: HANDLE_HOTSPOT_CLICK
           FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
           IMPORTING E_ROW_ID E_COLUMN_ID ES_ROW_NO.

ENDENHANCEMENT.
