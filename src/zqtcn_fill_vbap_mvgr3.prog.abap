*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILL_VBAP_MVGR3
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILL_VBAP_MVGR3 (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: The Material Group 3 (VBAP-MVGR3) has to be defaulted to ‘00’
*                      if Customer PO Type (VBKD- BSARK) is ‘0290’
* DEVELOPER: Yajuvendrasinh Raulji (Yraulji)
* CREATION DATE: 12/20/2017
* OBJECT ID: I0343
* TRANSPORT NUMBER(S): ED2K909950
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912837, ED2K912835
* REFERENCE NO: ERP-6401
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-07-30
* DESCRIPTION: The logic should trigger for specific Media Types only
*----------------------------------------------------------------------*
CONSTANTS:
  lc_dev_i0343 TYPE zdevid     VALUE 'I0343',       "Development ID
  lc_p_param1  TYPE rvari_vnam VALUE 'SOC_HOST_WB', "Parameter: Society Hosted Websites
  lc_p_param2  TYPE rvari_vnam VALUE 'MAT_GRP_3',   "Parameter: Material Group 3
* Begin of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
  lc_p_med_typ TYPE rvari_vnam VALUE 'MEDIA_TYPE'.  "Parameter: Media Type
* End   of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837

STATICS:
  li_constants TYPE zcat_constants.

* Begin of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
DATA:
  lir_med_type TYPE rjksd_mtype_range_tab.

DATA:
  lv_mat_genrl TYPE char30     VALUE '(SAPLMATL)MARA'.

FIELD-SYMBOLS:
  <lst_mat_gn> TYPE mara.                           "General Material Data
* End   of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837

* Check the table and varable is empty or not.
IF li_constants[] IS INITIAL.
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_i0343  "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
  SORT li_constants BY param1 param2 low.
ENDIF. " IF li_constants[] IS INITIAL

* Fill the respective entries which are maintain in zcaconstant.
IF li_constants[] IS NOT INITIAL.
* Begin of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
* Identify the valid Media Types
  READ TABLE li_constants TRANSPORTING NO FIELDS
       WITH KEY param1 = lc_p_param1
                param2 = lc_p_med_typ
       BINARY SEARCH.
  IF sy-subrc EQ 0. " If record found successfully.
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>) FROM sy-tabix.
      IF <lst_constant>-param1 NE lc_p_param1 OR
         <lst_constant>-param2 NE lc_p_med_typ.
        EXIT.
      ENDIF. " IF <lst_constant>-param1 NE lc_p_param1 OR
      APPEND INITIAL LINE TO lir_med_type ASSIGNING FIELD-SYMBOL(<lst_med_typ>).
      <lst_med_typ>-sign   = <lst_constant>-sign.
      <lst_med_typ>-option = <lst_constant>-opti.
      <lst_med_typ>-low    = <lst_constant>-low.
      <lst_med_typ>-high   = <lst_constant>-high.
    ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>) FROM sy-tabix
  ENDIF. " IF sy-subrc EQ 0

* Get the General Material Data from ABAP Stack
  ASSIGN (lv_mat_genrl) TO <lst_mat_gn>.
  IF sy-subrc EQ 0 AND
     <lst_mat_gn>-ismmediatype IN lir_med_type. "Media Type
* End   of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
    READ TABLE li_constants ASSIGNING <lst_constant>
         WITH KEY param1 = lc_p_param1
                  param2 = lc_p_param2
                  low    = vbkd-bsark
         BINARY SEARCH.
    IF sy-subrc EQ 0. " If record found successfully.
      vbap-mvgr3 = <lst_constant>-high. " Move Material Group 3 (00).
    ENDIF. " IF sy-subrc EQ 0
* Begin of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
  ENDIF. " IF sy-subrc EQ 0 AND
* End   of ADD:ERP-6401:WROY:30-JUL-2018:ED2K912837
ENDIF. " IF li_constants[] IS NOT INITIAL
