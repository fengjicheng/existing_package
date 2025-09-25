*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BUA_BUPA_PBO_BUA110_LH
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BUA_BUPA_PBO_BUA110_LH
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 19-03-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914714
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Business partner grouping field should be auto-populated with '0001'
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K912572
* REFERENCE NO: PRB0047009
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE: 02/17/2021
* DESCRIPTION: Clear Default Sales Area Details.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local data declarations
DATA:
  lst_constant     TYPE ty_constants,
  li_but000        TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,
  lv_partner       TYPE bu_partner,
  lv_bp_type       TYPE bu_type,
  lv_aktyp         TYPE bu_aktyp,
  lv_addr2_data    TYPE char25 VALUE '(SAPLSZA7)ADDR2_DATA',
  lv_*addr2_data   TYPE char25 VALUE '(SAPLSZA7)*ADDR2_DATA',
  lv_addr1_data    TYPE char25 VALUE '(SAPLSZA1)ADDR1_DATA',
  lv_*addr1_data   TYPE char25 VALUE '(SAPLSZA1)*ADDR1_DATA',
  lv_addr1_val     TYPE char25 VALUE '(SAPLSZA1)ADDR1_VAL',
  lv_bus000flds_pv TYPE char25 VALUE '(SAPLBUD0)BUS000FLDS',
  lv_busgroup      TYPE char50 VALUE '(SAPLBUPA_DIALOG_JOEL)BUS_JOEL_MAIN',
  lv_but000        TYPE char50 VALUE '(SAPLBUD0)BUT000'.

* Local Field-Symbols
FIELD-SYMBOLS:
  <lst_addr2_data>  TYPE addr2_data,
  <lst_*addr2_data> TYPE addr2_data,
  <lst_addr1_data>  TYPE addr1_data,
  <lst_*addr1_data> TYPE addr1_data,
  <lst_busgroup>    TYPE bus_joel_main,
  <lst_bus000>      TYPE bus000flds,
  <lst_but000>      TYPE but000.

* Local constants
CONSTANTS:
  lc_acttyp_01    TYPE bu_aktyp   VALUE '01',                         " Create
  lc_acttyp_02    TYPE bu_aktyp   VALUE '02',                         " Change
  lc_acttyp_03    TYPE bu_aktyp   VALUE '03',                         " Display
  lc_land1_p1     TYPE char6      VALUE 'LAND1',
  lc_int          TYPE ad_comm    VALUE 'INT',
  lc_person       TYPE bu_type    VALUE '1',      " BP: Person
  lc_group        TYPE bu_group   VALUE '0001',   " BP:wiley sold to party group
  lc_organization TYPE bu_type    VALUE '2'.      " BP: Organization


* FM call for BP Control (Create/Change/Display)
CALL FUNCTION 'BUS_PARAMETERS_ISSTA_GET'
  IMPORTING
    e_aktyp = lv_aktyp.

IF lv_aktyp = lc_acttyp_01.  " Create

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

* Check for Person/Organization
    IF lv_bp_type = lc_person.   " Person
      " Get 'addr2_data' from ABAP Stack
      " addr2_data refers to transfer structure of Comm. address of Person
      ASSIGN (lv_addr2_data) TO <lst_addr2_data>.
      IF sy-subrc = 0 AND <lst_addr2_data> IS ASSIGNED.
        IF <lst_addr2_data>-deflt_comm IS INITIAL.
          <lst_addr2_data>-deflt_comm = lc_int.
        ENDIF.
      ENDIF.

      IF <lst_addr2_data> IS ASSIGNED.
        IF <lst_addr2_data>-country IS NOT INITIAL.
          " Validate Country from constant entry and update Language field
          IF line_exists( i_constants[ param1 = lc_land1_p1
                                        param2 = <lst_addr2_data>-country ] ).
            lst_constant = i_constants[ param1 = lc_land1_p1 param2 = <lst_addr2_data>-country ].
            <lst_addr2_data>-langu = lst_constant-low.
            ASSIGN (lv_*addr2_data) TO <lst_*addr2_data>.
            IF sy-subrc = 0 AND <lst_*addr2_data> IS ASSIGNED.
              <lst_*addr2_data>-langu = lst_constant-low.
            ENDIF.
            " Get 'bus000flds' from ABAP Stack
            ASSIGN (lv_bus000flds_pv) TO <lst_bus000>.
            IF sy-subrc = 0 AND <lst_bus000> IS ASSIGNED.
              <lst_bus000>-langucorr = lst_constant-low.
            ENDIF.
          ENDIF.
        ENDIF. " IF <lst_addr2_data>-country IS NOT INITIAL
      ENDIF. " IF <lst_addr2_data> IS ASSIGNED

    ELSEIF lv_bp_type = lc_organization.  " Organization
      " Get 'addr1_data' from ABAP Stack
      " addr1_data refers to transfer structure of Comm. address of Org.
      ASSIGN (lv_addr1_data) TO <lst_addr1_data>.
      IF sy-subrc = 0 AND <lst_addr1_data> IS ASSIGNED.
        IF <lst_addr1_data>-deflt_comm IS INITIAL.
          <lst_addr1_data>-deflt_comm = lc_int.
        ENDIF.
      ENDIF.

      IF <lst_addr1_data> IS ASSIGNED.
        IF <lst_addr1_data>-country IS NOT INITIAL.
          " Validate Country from constant entry and update Language field
          IF line_exists( i_constants[ param1 = lc_land1_p1
                                        param2 = <lst_addr1_data>-country ] ).
            lst_constant = i_constants[ param1 = lc_land1_p1 param2 = <lst_addr1_data>-country ].
            " Get '*addr1_data' from ABAP Stack
            " *addr1_data refers to changes in address
            ASSIGN (lv_*addr1_data) TO <lst_*addr1_data>.
            IF <lst_*addr1_data> IS ASSIGNED.
              <lst_*addr1_data>-langu = lst_constant-low.
            ENDIF.
          ENDIF.
        ENDIF. " IF <lst_addr1_data>-country IS NOT INITIAL
      ENDIF. " IF <lst_addr1_data> IS ASSIGNED

    ENDIF. " IF lv_bp_type = lc_person
**BOC#ED2K920531 # OTCM-29502
    ASSIGN (lv_busgroup) TO <lst_busgroup>.
    IF sy-subrc = 0 AND <lst_busgroup> IS ASSIGNED.
      IF <lst_busgroup>-creation_group = space.
        <lst_busgroup>-creation_group = lc_group.
      ENDIF.
    ENDIF.
**BOC  Last name poulating in search term 1 based on type
    ASSIGN (lv_but000) TO <lst_but000>.
    IF sy-subrc = 0 AND <lst_but000> IS ASSIGNED.
      IF <lst_but000>-bu_sort1 IS INITIAL.
        IF <lst_but000>-type EQ lc_person.
          <lst_but000>-bu_sort1 = <lst_but000>-name_last.
        ENDIF.
      ENDIF.
    ENDIF.
**EOC#ED2K920531 # OTCM-29502
    UNASSIGN: <lst_addr1_data>, <lst_*addr1_data>, <lst_addr2_data>, <lst_bus000>,<lst_busgroup>,<lst_but000>.
    CLEAR: lv_aktyp, lst_constant, lv_bp_type.

  ENDIF.  " IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.


ENDIF. " IF lv_aktyp = lc_acttyp_01

* BOC - PRB0047009 - ED1K912572 - NPALLA - 02/17/2021
DATA: lst_tmp_sales_area TYPE cvis_sales_area.

GET PARAMETER ID 'VKO' FIELD lst_tmp_sales_area-sales_org.
IF lst_tmp_sales_area-sales_org IS NOT INITIAL.
  CLEAR: lst_tmp_sales_area.
  SET PARAMETER ID 'VKO' FIELD lst_tmp_sales_area-sales_org.
  SET PARAMETER ID 'VTW' FIELD lst_tmp_sales_area-dist_channel.
  SET PARAMETER ID 'SPA' FIELD lst_tmp_sales_area-division.
ENDIF.
* EOC - PRB0047009 - ED1K912572 - NPALLA - 02/17/2021
