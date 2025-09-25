*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BUPA_PBO_CVIC70_LH
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BUPA_PBO_CVIC70_LH
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 19-03-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914714
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910381
* REFERENCE NO: Knewton update changes
* DEVELOPER: SKKAIRAMKO
* DATE: 06/17/2019
* DESCRIPTION: Update the PERNR based on sales area
*----------------------------------------------------------------------*

* Local Types
TYPES:
  tt_cvis_sales_area TYPE TABLE OF cvis_sales_area_dynpro,
  tt_knvp_dynpro     TYPE TABLE OF cvis_cust_functions_dynpro.                     " Screen Structure of Partner Functions

* Local data declarations
DATA:
  lst_constant    TYPE ty_constants,
  li_but000       TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,
  lv_partner      TYPE bu_partner,
  lv_bp_type      TYPE bu_type,
  lv_pernr        TYPE pernr,
  lv_parvw        TYPE parvw,
*  lv_sls_area     TYPE char15,
*  lv_slsorg_div   TYPE char6,
  lv_slsorg_div   TYPE char8,  "++SKKAIRAMKO
  lst_sales_area  TYPE cvis_sales_area,
  li_sales_areas  TYPE cvis_sales_area_info_t,
  lst_sls_area    TYPE cvis_sales_area_dynpro,
  lr_mo           TYPE REF TO fsbp_memory_object,
  lr_cvi_mo_knvp  TYPE REF TO cvi_mo_knvp,
  li_knvp         TYPE STANDARD TABLE OF knvp,
  lst_knvv        TYPE knvv,                                                        " Customer Master Sales Data
  lst_knvp_dynpro TYPE cvis_cust_functions_dynpro,                                  " Screen Structure of Partner Functions
  lv_knvv         TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GS_KNVV',        " Global Struc: Customer Master Sales Data (ABAP Stack)
  lv_sales_areas  TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_SALES_AREAS', " Global Struc: BP Sales Areas (ABAP Stack)
  lv_knvp_dynpro  TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_KNVP_DYNPRO'. " Global table: Customer Master Partner functions (ABAP Stack)


* Local Field-Symbols
FIELD-SYMBOLS:
  <table>          TYPE STANDARD TABLE,
  <li_knvp_dynpro> TYPE tt_knvp_dynpro,    " Itab: Partner Functions
  <li_sales_area>  TYPE tt_cvis_sales_area, " Itab: Sales Areas
  <lst_knvv>       TYPE knvv.              " Struc: Sales Area

* Local constants
CONSTANTS:
  lc_parvw        TYPE rvari_vnam VALUE 'PARVW',
  lc_pernr        TYPE rvari_vnam VALUE 'PERNR',
  lc_sales_org    TYPE char5      VALUE 'VKORG',
  lc_ep1          TYPE syst_sysid VALUE 'EP1',
  lc_person       TYPE bu_type    VALUE '1',      " BP: Person
  lc_organization TYPE bu_type    VALUE '2'.      " BP: Organization

* FM call to fetch the BP Category
CALL FUNCTION 'BUP_BUPA_BUT000_GET'
  TABLES
    et_but000 = li_but000.
IF li_but000 IS NOT INITIAL.
  lv_partner = li_but000[ 1 ]-partner.
  lv_bp_type = li_but000[ 1 ]-type.
ENDIF.

*** Run the logic only for BP Cat: Person(1)/Organization(2)
IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.

* Fetch Application constant entries
  IF i_constants[] IS INITIAL.
    SELECT param1, param2, srno, sign, opti, low, high
           FROM zcaconstant                    " Wiley Application Constant Table
           INTO TABLE @i_constants
           WHERE devid = @lc_devid_e191 AND
                 activate = @abap_true.
  ENDIF.

* Get BP Sales data (Sale Area Info) from ABAP Stack
  lst_sales_area = cvi_bdt_adapter=>get_current_sales_area( ).
*--BOC: SKKAIRAMKO - 06/17/2019

*  lv_slsorg_div = lst_sales_area-sales_org && lst_sales_area-division.
   lv_slsorg_div = lst_sales_area-sales_org && lst_sales_area-dist_channel && lst_sales_area-division.
*--EOC: SKKAIRAMKO - 06/17/2019
*  ASSIGN (lv_knvv) TO <lst_knvv>.
*  IF sy-subrc = 0 AND <lst_knvv> IS ASSIGNED.
*    lst_sales_area = <lst_knvv>-vkorg && <lst_knvv>-vtweg && <lst_knvv>-spart.
*    lv_division = <lst_knvv>-spart.
*  ENDIF.

*** Validate Sales area from constant entry and update Partner function information
*** with additional Partner function: ZM/ER (Employee Responsible)
  IF line_exists( i_constants[ param1 = lc_sales_org
                               low    = lst_sales_area-sales_org ] ).
    " Get BP Partner functions from ABAP Stack
    ASSIGN (lv_knvp_dynpro) TO <li_knvp_dynpro>.
    IF sy-subrc = 0 AND <li_knvp_dynpro> IS NOT INITIAL.
      " Fetch the Partner Function to be added from constant entries
      READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_parvw
                                                        param2 = lv_slsorg_div.         " BINARYSEARCH is not required due to less amount of data
      IF sy-subrc = 0.
        lv_parvw = lst_constant-low.
        CLEAR lst_constant.
        " Check for Partner function: ER/ZM (Employee Responsible)
        READ TABLE <li_knvp_dynpro> WITH KEY parvw = lv_parvw TRANSPORTING NO FIELDS.   " BINARYSEARCH is not required due to less amount of data
        IF sy-subrc <> 0.
          " Fetch the Partner/Employee number to be added from constant entries
          READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_pernr
                                                            param2 = lv_slsorg_div.     " BINARYSEARCH is not required due to less amount of data
          IF sy-subrc = 0.
            lv_pernr = lst_constant-low.
            CLEAR lst_constant.

            READ TABLE <li_knvp_dynpro> INTO lst_knvp_dynpro INDEX 1.                   " BINARYSEARCH is not required due to less amount of data
            lst_knvp_dynpro-parvw = lv_parvw.
            lst_knvp_dynpro-ktonr = lv_pernr.
            APPEND lst_knvp_dynpro TO <li_knvp_dynpro>.
          ENDIF. " IF sy-subrc = 0.
        ENDIF. " IF sy-subrc <> 0.
        CLEAR: lst_knvp_dynpro, lv_parvw, lv_pernr, lv_slsorg_div.
      ENDIF. " IF sy-subrc = 0.
    ENDIF.  " IF sy-subrc = 0 AND <li_knvp_dynpro> IS NOT INITIAL.
  ENDIF. " IF line_exists( i_constants[ param1


*** Validate Sales Areas & Update the KNVP information into memory with additional Partner function: ZM/ER (Employee Responsible)
*** when the Customer/BP extends to multiple sales areas at a time
  " Get the customer Sales Areas from ABAP Stack
  ASSIGN (lv_sales_areas) TO <li_sales_area>.
  IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
    IF <li_sales_area> IS INITIAL.
      li_sales_areas = cvi_bdt_adapter=>get_sales_areas( ).
      LOOP AT li_sales_areas INTO DATA(lst_sa).
        MOVE-CORRESPONDING lst_sa TO lst_sls_area.
        lst_sls_area-new_sa = lst_sa-is_new.
        APPEND lst_sls_area TO <li_sales_area>.
        CLEAR: lst_sls_area, lst_sa.
      ENDLOOP.
    ENDIF.
    " Fetch the KNVP Information from memory
    DELETE <li_sales_area> WHERE sales_org IS INITIAL.
    lr_mo ?= fsbp_memory_factory=>get_instance(
      i_partner    = lv_partner
      i_table_name = 'KNVP'
    ).
    lr_mo->get_data_new( IMPORTING e_data_new = li_knvp[] ).
    DATA(lv_lines_old) = lines( li_knvp ).
    " Iterate the existing sales areas to find the Sales area (1030,00,10) relevant to LH (Learning House)
    LOOP AT <li_sales_area> INTO lst_sls_area.
      lv_slsorg_div = lst_sls_area-sales_org && lst_sls_area-division.
      " Validate Sales Org. from constant entry and update Partner function (KNVP) information
      IF line_exists( i_constants[ param1 = lc_sales_org
                                   low    = lst_sls_area-sales_org ] ).
        " Fetch the Partner Function to be added from constant entries
        READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_parvw
                                                          param2 = lv_slsorg_div.        " BINARYSEARCH is not required due to less amount of data
        IF sy-subrc = 0.
          lv_parvw = lst_constant-low.
          CLEAR lst_constant.

          IF li_knvp[] IS NOT INITIAL.
            " Check for Partner function: ER/ZM (Employee Responsible)
            READ TABLE li_knvp WITH KEY kunnr = lv_partner vkorg = lst_sls_area-sales_org
                                        vtweg = lst_sls_area-dist_channel spart = lst_sls_area-division
                                        parvw = lv_parvw TRANSPORTING NO FIELDS.          " BINARYSEARCH is not required due to less amount of data
            IF sy-subrc <> 0.
              " Fetch the Partner/Employee number to be added from constant entries
              READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_pernr
                                                                param2 = lv_slsorg_div.   " BINARYSEARCH is not required due to less amount of data
              IF sy-subrc = 0.
                lv_pernr = lst_constant-low.
                CLEAR lst_constant.

                APPEND INITIAL LINE TO li_knvp ASSIGNING FIELD-SYMBOL(<lst_knvp>).
                <lst_knvp>-kunnr = lv_partner.
                <lst_knvp>-vkorg = lst_sls_area-sales_org.
                <lst_knvp>-vtweg = lst_sls_area-dist_channel.
                <lst_knvp>-spart = lst_sls_area-division.
                <lst_knvp>-parvw = lv_parvw.
                <lst_knvp>-kunn2 = lv_pernr.
              ENDIF. " IF sy-subrc = 0.
            ENDIF. " IF sy-subrc <> 0.
          ENDIF.  " IF li_knvp[] IS NOT INITIAL.

          CLEAR: lv_parvw, lv_pernr.
        ENDIF. " IF sy-subrc = 0.
      ENDIF. " IF line_exists( i_constants[
      CLEAR: lst_sls_area, lv_slsorg_div.
    ENDLOOP.

    DATA(lv_lines_new) = lines( li_knvp ).
    " Set the new KNVP data into memory
    IF lv_lines_new > lv_lines_old.
      lr_cvi_mo_knvp ?= lr_mo.
      IF lr_cvi_mo_knvp IS BOUND.
        CALL METHOD lr_cvi_mo_knvp->if_xo_memory_object~set_data_new
          EXPORTING
            i_data_new = li_knvp.
      ENDIF.
      " For testing, check the KNVP data after it is updated into memory
      IF sy-sysid <> lc_ep1.
        lr_mo->get_data_new( IMPORTING e_data_new = li_knvp[] ).
      ENDIF.
    ENDIF. " IF lv_lines_new > lv_lines_old.

    CLEAR: lr_cvi_mo_knvp, lr_mo, li_knvp[].
  ENDIF. " IF SY-SUBRC = 0 AND <li_sales_ares> IS ASSIGNED.

  UNASSIGN: <li_sales_area>, <lst_knvv>.
ENDIF.  " IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.
