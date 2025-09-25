*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BUPA_EVENT_DTAKE_LH_E191
*&---------------------------------------------------------------------*
*--------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_BUP_BUPA_EVENT_DTAKE
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 01-04-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914845
*--------------------------------------------------------------------*

* Local Type(s)
  TYPES:
    tt_mem_but100      TYPE STANDARD TABLE OF vbut100 INITIAL SIZE 0,
    tt_cvis_sales_area TYPE TABLE OF cvis_sales_area_dynpro,
    tt_constants       TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0.

* Local Data
  DATA:
    lst_constant       TYPE ty_constants,
    li_constants       TYPE tt_constants,
    lst_but100         TYPE vbut100,
    li_but000          TYPE STANDARD TABLE OF but000,
    lv_partner         TYPE bu_partner,
    lv_bp_type         TYPE bu_type,
    lv_aktyp           TYPE bu_aktyp,       " Activity Category
    lv_role_valid_from TYPE bu_role_valid_from,
    lv_role_valid_to   TYPE bu_role_valid_to,
    lv_role_vf_c       TYPE char15,
    lv_role_vt_c       TYPE char15,
    lst_sales_area     TYPE cvis_sales_area_dynpro,
    lv_constants       TYPE char50 VALUE '(SAPLZQTC_FG_BP_VALIDATIONS)I_CONSTANTS[]',
    lv_sales_areas     TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_SALES_AREAS[]',
    lv_mem_but100      TYPE char25 VALUE '(SAPLBUD0)MEM_BUT100[]'.

* Local Field-Symbols
  FIELD-SYMBOLS:
    <li_mem_but100> TYPE tt_mem_but100,
    <li_constants>  TYPE tt_constants,
    <li_sales_area> TYPE tt_cvis_sales_area.

* Local constants
  CONSTANTS:
    lc_flcu00       TYPE bu_partnerrole VALUE 'FLCU00', " BP Role: FI Customer
    lc_sales_org    TYPE char5          VALUE 'VKORG',
    lc_vf_time      TYPE char6          VALUE '000000',
    lc_vt_time      TYPE char6          VALUE '235959',
    lc_acttyp_01    TYPE bu_aktyp       VALUE '01',     " Create
    lc_person       TYPE bu_type        VALUE '1',      " BP: Person
    lc_organization TYPE bu_type        VALUE '2'.      " BP: Organization


  " Get the customer Sales Areas from ABAP Stack
  ASSIGN (lv_sales_areas) TO <li_sales_area>.
  IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
    IF <li_sales_area> IS NOT INITIAL.
      " FM Call to fetch the BP General Info
      CALL FUNCTION 'BUPA_GENERAL_CALLBACK'
        TABLES
          et_but000_new = li_but000.
      IF li_but000[] IS NOT INITIAL.
        lv_partner = li_but000[ 1 ]-partner.
        lv_bp_type = li_but000[ 1 ]-type.
      ENDIF.
      " Run the logic only for BP Cat: Person(1)/Organization(2)
      IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.

        " Fetch I_CONSTANTS[] from ABAP stack
        ASSIGN (lv_constants) TO <li_constants>.
        IF sy-subrc = 0 AND <li_constants> IS NOT INITIAL.
          li_constants = <li_constants>.
        ENDIF.

        " Fetch Application constant entries
        IF li_constants[] IS INITIAL.
          SELECT param1, param2, srno, sign, opti, low, high
                 FROM zcaconstant                    " Wiley Application Constant Table
                 INTO TABLE @li_constants
                 WHERE devid = @lc_devid_e191 AND
                       activate = @abap_true.
        ENDIF.

        LOOP AT <li_sales_area> INTO lst_sales_area.
          " Validate Sales Org. from constant entry and add BP Role: FLCU00 (FI Customer)
          IF line_exists( li_constants[ param1 = lc_sales_org
                                        low    = lst_sales_area-sales_org ] ).
            " Check the BP Role: FLCU00 existing or Not
            SELECT SINGLE rltyp FROM but100 INTO @DATA(lv_rltyp_flcu00)
                                            WHERE partner = @lv_partner AND
                                                  rltyp   = @lc_flcu00.
            IF sy-subrc <> 0.
              " Fetch mem_but100[] from ABAP stack
              ASSIGN (lv_mem_but100) TO <li_mem_but100>.
              IF sy-subrc = 0 AND <li_mem_but100> IS ASSIGNED.
                READ TABLE <li_mem_but100> WITH KEY rltyp = lc_flcu00 TRANSPORTING NO FIELDS.  " BINARY SEARCH is not required as <li_mem_but100> has
                IF sy-subrc <> 0.                                                              " very less data
                  lv_role_vf_c = sy-datum.
                  CONCATENATE lv_role_vf_c lc_vf_time INTO lv_role_vf_c.
                  lv_role_vt_c = cl_bus_time=>gc_end_of_days.
                  CONCATENATE lv_role_vt_c lc_vt_time INTO lv_role_vt_c.
                  APPEND INITIAL LINE TO <li_mem_but100> ASSIGNING FIELD-SYMBOL(<lst_mem_but100>).
                  <lst_mem_but100>-partner = lv_partner.
                  <lst_mem_but100>-rltyp = lc_flcu00.
                  <lst_mem_but100>-valid_from = lv_role_vf_c.
                  <lst_mem_but100>-valid_to = lv_role_vt_c.

                  " Exit from the LOOP
                  EXIT.
                ENDIF. " IF sy-subrc <> 0.
              ENDIF. " IF sy-subrc = 0 AND <li_mem_but100> IS ASSIGNED.
            ENDIF. " IF sy-subrc <> 0.
          ENDIF. " IF line_exists( li_constants[ param1 = lc_sales_org
          CLEAR lst_sales_area.
        ENDLOOP.

      ENDIF. " IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.
    ENDIF. " IF <li_sales_area> IS NOT INITIAL.
  ENDIF. " IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
