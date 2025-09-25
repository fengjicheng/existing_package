class ZCL_ISM_WL_SEL_FILTER_R096 definition
  public
  create public .

public section.

*"* public components of class ZCL_ISM_WL_SEL_FILTER_R096
*"* do not include other source files here!!!
  interfaces IF_ISM_WORKLIST_SEL_FILTER .
protected section.
*"* protected components of class ZCL_ISM_WL_SEL_FILTER_R096
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ISM_WL_SEL_FILTER_R096
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ISM_WL_SEL_FILTER_R096 IMPLEMENTATION.


METHOD if_ism_worklist_sel_filter~worklist_filter_selection.

* In this method all selected issues according to worklist selection are available
* in input table I_ISSUE_TAB.
* Depending on the filter I_FILTER_ID it is possible to additionally filter
* this selected issues.
* Worklist will be processed only for issues which are copied from table I_ISSUE_TAB
* to table E_ISSUE_TAB.

* Local Types
  TYPES: BEGIN OF ty_mi_plant,
           matnr TYPE matnr,
           werks TYPE werks_d,
           loggr TYPE loggr,
         END OF ty_mi_plant.

* Local Data
  DATA: ls_plant     TYPE string VALUE '(RJKSDWORKLIST)GV_WERK',
        lv_plant     TYPE werks_d,
        lv_mtyp      TYPE loggr,
        lir_plant    TYPE ranges_werks_tt,
        li_mat_plant TYPE STANDARD TABLE OF ty_mi_plant INITIAL SIZE 0.

* Local Constants
  CONSTANTS:
    lc_digital TYPE loggr VALUE '0001',
    lc_print   TYPE loggr VALUE '0002',
    lc_zd      TYPE char2 VALUE 'ZD',    " ZD --> Printing Type: Digital
    lc_zl      TYPE char2 VALUE 'ZL'.    " ZL --> Printing Type: Litho (Print)

  " Check for the transaction code
  IF sy-tcode = 'ZSCM_JKSD13_01' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*     sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
    sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* Get Selected Plant
    ASSIGN (ls_plant) TO FIELD-SYMBOL(<lfs_plant>).
    IF sy-subrc = 0 AND <lfs_plant> IS ASSIGNED.
      lv_plant = <lfs_plant>.
    ENDIF.

    " Build Range table for Plant
    IF lv_plant IS NOT INITIAL.
      APPEND INITIAL LINE TO lir_plant ASSIGNING FIELD-SYMBOL(<lst_plant>).
      <lst_plant>-sign   = 'I'.
      <lst_plant>-option = 'EQ'.
      <lst_plant>-low = lv_plant.
    ENDIF.

* Set the Printing Type: DIGITAL(ZD)/LITHO(ZL)
    IF i_filter_id = lc_zd.
      lv_mtyp = lc_digital.
    ELSEIF i_filter_id = lc_zl.
      lv_mtyp = lc_print.
    ENDIF.

*** Fetch all the Media Issues From MARC
    IF lv_mtyp IS NOT INITIAL.
      IF i_issue_tab[] IS NOT INITIAL.
        SELECT matnr, werks, loggr FROM marc INTO TABLE @li_mat_plant
               FOR ALL ENTRIES IN @i_issue_tab
               WHERE matnr = @i_issue_tab-table_line AND
                     werks IN @lir_plant AND
                     loggr = @lv_mtyp.  " To filter the Media Issues based on Filter criteria from selection screen
        IF sy-subrc = 0.
          LOOP AT li_mat_plant INTO DATA(lst_mat_plant).
            " Assign Filtered Media Issues to Final Itab: E_ISSUE_TAB
            APPEND lst_mat_plant-matnr TO e_issue_tab.
            CLEAR lst_mat_plant.
          ENDLOOP.
        ENDIF.
      ENDIF. " IF I_ISSUE_TAB[] IS NOT INITIAL.
    ENDIF. " IF lv_mtyp IS NOT INITIAL.

  ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01'.



ENDMETHOD.
ENDCLASS.
