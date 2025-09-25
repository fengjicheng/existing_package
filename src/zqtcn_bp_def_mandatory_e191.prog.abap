*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BP_DEF_MANDATORY_E191
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Set defalts changes for mandatory checks
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K921317
* REFERENCE NO: FMM-2143
* DEVELOPER:mimmadiset
* DATE:  01/19/2021
* DESCRIPTION:MKO validation for I0200
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
** Local Type(s)
TYPES:tt_cvis_sales_area TYPE TABLE OF cvis_sales_area_dynpro.
TYPES: BEGIN OF ty_constants_m,
         param1      TYPE rvari_vnam,          " Param1
         param2      TYPE rvari_vnam,          " Param2
         srno        TYPE tvarv_numb,          " Serial Number
         sign        TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti        TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low         TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high        TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         description TYPE zconstdesc,     " Description
       END OF ty_constants_m,
       tt_knvp_dynpro TYPE TABLE OF cvis_cust_functions_dynpro.

CONSTANTS:lc_m         TYPE char01     VALUE 'M',
          lc_regio     TYPE char10     VALUE 'REGION',
          lc_msg_id    TYPE sy-msgid   VALUE 'ZQTC_R2',                    " Message Class
          lc_msg_typ_e TYPE sy-msgty   VALUE 'E',                          " Message Type: E
          lc_msg_typ_i TYPE sy-msgty   VALUE 'I',                          " Message Type: I
          lc_msgno_000 TYPE syst_msgno VALUE '000',
          lc_dev_e191  TYPE zdevid     VALUE 'E191',
          lc_region    TYPE string     VALUE 'Region must not be blank',
          lc_in        TYPE land1      VALUE 'IN',
          lc_hypen     TYPE char01     VALUE '-',
          lc_acttyp_01 TYPE bu_aktyp          VALUE '01',                         " Create
          lc_tab_adrc  TYPE fsbp_table_name VALUE 'ADRC',
          lc_tab_knvv  TYPE fsbp_table_name VALUE 'KNVV'. "Table Name: KNVV
* Local Field-Symbols
FIELD-SYMBOLS:
  <li_knvp_dynpro> TYPE tt_knvp_dynpro,   " Itab: Partner Functions
  <li_sales_area>  TYPE tt_cvis_sales_area, " Itab: Sales Areas
  <lst_knvv_gs>    TYPE knvv.             " Struc: Sales Area

DATA: lv_tab         TYPE char10,
      lv_msg         TYPE zconstdesc,
      lv_sales_areas TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_SALES_AREAS',
      lv_field       TYPE char10.
* Statics data
STATICS:
  li_constants_m TYPE STANDARD TABLE OF ty_constants_m INITIAL SIZE 0.
DATA:
  li_knvv  TYPE STANDARD TABLE OF knvv INITIAL SIZE 0,
  li_adrc  TYPE STANDARD TABLE OF adrc INITIAL SIZE 0,
  lv_aktyp TYPE bu_aktyp,
  ls_knvv  TYPE knvv.
FREE:li_knvv,li_adrc.

* FM call for BP Control (Create/Change/Display)
CALL FUNCTION 'BUS_PARAMETERS_ISSTA_GET'
  IMPORTING
    e_aktyp = lv_aktyp.

* Fetch Application constant entries of E191
IF li_constants_m[] IS INITIAL.
  SELECT param1, param2, srno, sign, opti, low, high, description
         FROM zcaconstant                    " Wiley Application Constant Table
         INTO TABLE @li_constants_m
         WHERE devid = 'E191' AND
               param2 = @lc_m AND
               activate = @abap_true.
  IF sy-subrc EQ 0.

  ELSE.
*        do nothing
  ENDIF.
ENDIF.
IF cvi_bdt_adapter=>get_current_sales_area( ) IS NOT INITIAL.
* step 1: update xo memory from dypro structure
  cvi_bdt_adapter=>get_current_bp_sales_data(
    EXPORTING
      i_table_name = lc_tab_knvv
    IMPORTING
      e_data_table = li_knvv[]
  ).
  IF li_knvv[] IS NOT INITIAL.
    READ TABLE li_knvv INTO ls_knvv INDEX 1.
    " Get the customer Sales Areas from ABAP Stack
    ASSIGN (lv_sales_areas) TO <li_sales_area>.
    IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
      READ TABLE <li_sales_area> ASSIGNING FIELD-SYMBOL(<fs_area>)
        WITH KEY sales_org = ls_knvv-vkorg new_sa = abap_true.
      IF sy-subrc = 0.
* Check for mandatory fields
        DATA(lv_sales_area) = ls_knvv-vkorg && ls_knvv-vtweg && ls_knvv-spart.

        LOOP AT li_constants_m INTO DATA(lst_const_m) WHERE param2 = lc_m.
          IF lst_const_m-param1 CA lc_hypen.
            SPLIT lst_const_m-param1 AT lc_hypen INTO lv_tab lv_field.
          ELSE.
            CLEAR lv_field.
          ENDIF.
          CASE lv_tab.
            WHEN lc_tab_knvv.
              TRY.
                  ASSIGN COMPONENT lv_field OF STRUCTURE ls_knvv TO FIELD-SYMBOL(<lst_knvvm>).
                  IF <lst_knvvm> IS ASSIGNED.
                    IF <lst_knvvm> IS INITIAL.
*                  *--if exists dont do anyting,
                      IF line_exists( li_constants_m[ param1 = lst_const_m-param1
                                                    param2 = lst_const_m-param2
                                                    low = lv_sales_area  ] ).
                        "Skip mandatory
                      ELSE.
                        lv_msg = lst_const_m-description.
                        IF lv_msg IS NOT INITIAL.
                          CALL FUNCTION 'BUS_MESSAGE_STORE'
                            EXPORTING
                              arbgb = lc_msg_id
                              msgty = lc_msg_typ_e
                              txtnr = lc_msgno_000
                              msgv1 = lv_msg.
                        ENDIF.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                CATCH cx_sy_assign_cast_error.
              ENDTRY.
          ENDCASE.
          IF <lst_knvvm> IS ASSIGNED.
            UNASSIGN <lst_knvvm>.
          ENDIF.
          CLEAR:lv_field,lv_tab.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF."IF li_knvv[] IS NOT INITIAL.
ENDIF."cvi_bdt_adapter=>get_current_sales_area( ) IS NOT INITIAL.
**Verify that the Region field is mandatory (Because Country is INDIA)
CALL FUNCTION 'BUA_BUPA_ADRC_GET'
  TABLES
    t_adrc = li_adrc.
IF li_adrc IS NOT INITIAL AND lv_aktyp = lc_acttyp_01.  " Create.
  READ TABLE li_adrc INTO DATA(ls_adrc) INDEX 1.
  LOOP AT li_constants_m INTO lst_const_m WHERE param2 = lc_m.
    IF lst_const_m-param1 CA lc_hypen.
      SPLIT lst_const_m-param1 AT lc_hypen INTO lv_tab lv_field.
    ELSE.
      CLEAR lv_field.
    ENDIF.
    CASE lv_tab.
      WHEN lc_tab_adrc.
        CASE lv_field.
          WHEN lc_regio.
            TRY.
                ASSIGN COMPONENT lv_field OF STRUCTURE ls_adrc TO FIELD-SYMBOL(<lst_adrc>).
                IF <lst_adrc> IS ASSIGNED.
                  IF <lst_adrc> IS INITIAL AND ls_adrc-country EQ lst_const_m-low.
                    lv_msg = lst_const_m-description.
                    IF lv_msg IS NOT INITIAL.
                      CALL FUNCTION 'BUS_MESSAGE_STORE'
                        EXPORTING
                          arbgb = lc_msg_id
                          msgty = lc_msg_typ_e
                          txtnr = lc_msgno_000
                          msgv1 = lv_msg.
                    ENDIF.
                  ENDIF.
                ENDIF.
              CATCH cx_sy_assign_cast_error.
            ENDTRY.
            IF <lst_adrc> IS ASSIGNED.
              UNASSIGN <lst_adrc>.
            ENDIF.
        ENDCASE.
    ENDCASE.
  ENDLOOP.
ENDIF."IF li_adrc IS NOT INITIAL.
