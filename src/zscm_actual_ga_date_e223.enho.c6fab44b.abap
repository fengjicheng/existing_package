"Name: \PR:RJKSDWORKLIST\FO:MARC_SELECT_ISMDATE\SE:BEGIN\EI
ENHANCEMENT 0 ZSCM_ACTUAL_GA_DATE_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Enhancement for new Radio button: Actual GA Date
*-----------------------------------------------------------------------*

   " Check whether the Enhancement is active ot not
   CHECK v_aflag_e223 = abap_true.

   CHECK rjksdworklist_changefields-xincl_phases = con_angekreuzt.

   IF rjksdworklist_changefields-xincl_phases = con_angekreuzt.
     v_agadt = rjksdworklist_changefields-xincl_phases.
   ELSE.
     CLEAR v_agadt.
   ENDIF.

   concatenate t1 ls_and_from into ls_and_from.
   concatenate t1 ls_and_to into ls_and_to.

ENDENHANCEMENT.
