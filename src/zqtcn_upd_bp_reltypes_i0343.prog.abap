*&---------------------------------------------------------------------*
*&  Include  ZQTCN_UPD_BP_RELATIONSHIP_I0343
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPD_BP_RELATIONSHIP_I0343 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Subscription Order to Update
* Student Membership Relationship category at BP(Ship-to)
* Relationships if it is sent via Inbound Renewal
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI )
* CREATION DATE: 18/02/2019
* OBJECT ID: I0343 / CR#7463
* TRANSPORT NUMBER(S): ED2K914492
*----------------------------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local Types declaration
TYPES: BEGIN OF ty_reltyp,
         partner1 TYPE bu_partner,
         reltyp   TYPE bu_reltyp,
         credat   TYPE dats,
       END OF ty_reltyp,
       BEGIN OF ty_constants,
         param1 TYPE rvari_vnam,
         param2 TYPE rvari_vnam,
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_constants,
       tt_constant TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0.

* Local data declaration
DATA:
  lst_reltyp       TYPE ty_reltyp,
  lv_mem_name      TYPE char30,
  li_relations     TYPE STANDARD TABLE OF bapibus1006_relations INITIAL SIZE 0,
  li_relations_new TYPE STANDARD TABLE OF bapibus1006_relations INITIAL SIZE 0,
  li_rel_stud_memb TYPE STANDARD TABLE OF bapibus1006_relations INITIAL SIZE 0,
  lst_relations    TYPE bapibus1006_relations,
  lr_reltypes      TYPE RANGE OF bu_reltyp,
  li_zcaconstant   TYPE tt_constant,
  lv_year_t        TYPE numc4,
  lv_year          TYPE numc4,
  lv_year_to       TYPE numc4,
  lv_year_from     TYPE numc4,
  lv_validity_yr   TYPE numc2,
  lv_datet_c       TYPE char8,
  lv_datee_c       TYPE char8,
  lv_datef_c       TYPE char8,
  lv_partner2      TYPE bu_partner,    " Society Partner number
  lst_xvbpa        TYPE vbpavb.

* Local field-symbols
FIELD-SYMBOLS:
  <lst_relations>  TYPE bapibus1006_relations.

* Local constants
CONSTANTS:
  lc_e1edka1_11    TYPE edilsegtyp VALUE 'E1EDKA1',
  lc_devid_i0200   TYPE zdevid     VALUE 'I0200',
  lc_relcat_zpr008 TYPE bu_reltyp  VALUE 'ZPR008',      " Rel Cat: Full Membership
  lc_param1_relcat TYPE rvari_vnam VALUE 'REL_CATEGORY',
  lc_param2_stumem TYPE rvari_vnam VALUE 'STUDENT_MEMBER',
  lc_param2_valyr  TYPE rvari_vnam VALUE 'VALIDITY_YEAR',
  lc_0101          TYPE char4      VALUE '0101',
  lc_1231          TYPE char4      VALUE '1231',
  lc_m             TYPE char1      VALUE 'M',
  lc_parvw_we      TYPE parvw      VALUE 'WE',          " Partner function: Ship-to
  lc_parvw_za      TYPE parvw      VALUE 'ZA'.          " Society Partner function

* Fetch Student Member relationships from ZCACONSTANT
SELECT param1
       param2
       sign
       opti
       low
       high
       FROM zcaconstant " Wiley Application Constant Table
       INTO TABLE li_zcaconstant
       WHERE devid = lc_devid_i0200 AND
             param1 = lc_param1_relcat AND
             activate = abap_true.
IF sy-subrc = 0 AND li_zcaconstant[] IS NOT INITIAL.
  LOOP AT li_zcaconstant INTO DATA(lst_zcaconstant).
    IF lst_zcaconstant-param2 = lc_param2_valyr.
      lv_validity_yr = lst_zcaconstant-low.
    ELSEIF lst_zcaconstant-param2 = lc_param2_stumem.
      APPEND INITIAL LINE TO lr_reltypes ASSIGNING FIELD-SYMBOL(<lst_reltype>).
      <lst_reltype>-sign   = lst_zcaconstant-sign.
      <lst_reltype>-option = lst_zcaconstant-opti.
      <lst_reltype>-low    = lst_zcaconstant-low.
    ENDIF.
    CLEAR lst_zcaconstant.
  ENDLOOP.
ELSE.
  " Nothing to do
ENDIF.

* Fetch the Relationship category passed from IDOC via ABAP shared memory
CONCATENATE rv45a-docnum '_REL_TYPE' INTO lv_mem_name.
IMPORT lst_reltyp FROM MEMORY ID lv_mem_name.
IF sy-subrc = 0 AND lst_reltyp-reltyp IS NOT INITIAL.
  IF lst_reltyp-credat IS INITIAL.
    MESSAGE e314(zqtc_r2).
  ENDIF.
  " Check whether the passed Relationship Category is Student member or Not
  READ TABLE lr_reltypes TRANSPORTING NO FIELDS WITH KEY low = lst_reltyp-reltyp. " BINARY SEARCH is not required as lr_reltypes has very less data
  IF sy-subrc = 0.
* If the passed Relationship Category is Student member, then only update it
* at BP(Ship-to) relationships

    " For ZREW (Renewal Subscription Order),
    " If Partner number for Ship-tp party (WE) is not passed via Idoc Segment (E1EDKA1), then fetch it from XVBPA
    IF lst_reltyp-partner1 IS INITIAL.
      READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY posnr = posnr_low
                                                 parvw = lc_parvw_we.  " BINARY SEARCH is not required as xvbpa has very less data
      IF sy-subrc = 0.
        lst_reltyp-partner1 = lst_xvbpa-kunnr.
        CLEAR lst_xvbpa.
      ENDIF.
    ENDIF.

    " Read the Society Partner function (ZA)
    READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY parvw = lc_parvw_za.  " BINARY SEARCH is not required as xvbpa has very less data
    IF sy-subrc = 0.
      lv_partner2 = lst_xvbpa-kunnr.
      CLEAR lst_xvbpa.
    ENDIF.

    IF lst_reltyp-partner1 IS NOT INITIAL AND
       lv_partner2 IS NOT INITIAL.
      " Get the existing relationships of Sold-to/Ship-to (BP)
      CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
        EXPORTING
          iv_partner       = lst_reltyp-partner1
*         BUSINESSPARTNERGUID            =
*         IV_RELATIONSHIP_CATEGORY       =
*         IV_REQ_MASK      = 'X'
        TABLES
          et_relationships = li_relations.
      IF sy-subrc = 0 AND li_relations[] IS NOT INITIAL.
* getting the existing Student member relationships from the relations of Sold-to/Ship-to (BP)
        LOOP AT li_relations ASSIGNING <lst_relations>.
          IF lr_reltypes[] IS NOT INITIAL AND
             <lst_relations>-relationshipcategory IN lr_reltypes[].
            IF <lst_relations>-validuntildate >= sy-datum.  " Student member relationship should be not be a expired one
              APPEND <lst_relations> TO li_rel_stud_memb.   " Student member relationships
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF <lst_relations> IS ASSIGNED.
          UNASSIGN <lst_relations>.
        ENDIF.
        SORT li_relations BY relationshipcategory.
        READ TABLE li_rel_stud_memb ASSIGNING <lst_relations> WITH KEY
                                    relationshipcategory = lst_reltyp-reltyp. " BINARY SEARCH is not required bcoz of less data.
        IF sy-subrc = 0.
* IF same Reletionship Category is sent for Renewal,
* then extend the current student member relationship to three more years and
* update the Full membership (ZPR008) validation dates

          " Extend the current student member relationship to three more years
          " only if the Pricing year is GT <lst_relations>-VALIDUNTILDATE(4)
          lv_year_t = <lst_relations>-validuntildate(4).  " Valid_To year of existing Student mem relationship
          lv_year = lst_reltyp-credat(4).                 " Order created year
          IF lv_year > lv_year_t.                         " IF Pricing year date is GT <lst_relations>-VALIDUNTILDATE(4)
            lv_year = lv_year + lv_validity_yr.
            <lst_relations>-validuntildate(4) = lv_year.
            <lst_relations>-relationshiptype = lc_m.
            APPEND <lst_relations> TO li_relations_new.
            IF <lst_relations> IS ASSIGNED.
              UNASSIGN <lst_relations>.
            ENDIF.
            " Update the Full membership (ZPR008) validation dates
            lv_year = lv_year + 1.
            CONCATENATE lv_year lc_0101 INTO lv_datef_c. " Full membership Validity_From date
            READ TABLE li_relations ASSIGNING <lst_relations> WITH KEY
                                    relationshipcategory = lc_relcat_zpr008
                                    BINARY SEARCH.
            IF sy-subrc = 0 AND <lst_relations> IS ASSIGNED.
              <lst_relations>-validfromdate = lv_datef_c.
              <lst_relations>-validuntildate = cl_bus_time=>gc_end_of_days.  " Full membership Validity_To date
              APPEND <lst_relations> TO li_relations_new.
            ELSE.
              lst_relations-partner1 = lst_reltyp-partner1.
              lst_relations-partner2 = lv_partner2.
              lst_relations-validfromdate = lv_datef_c.                      " Full membership Validity_From date
              lst_relations-validuntildate = cl_bus_time=>gc_end_of_days.    " Full membership Validity_To date
              lst_relations-relationshipcategory = lc_relcat_zpr008.
              APPEND lst_relations TO li_relations_new.
              CLEAR lst_relations.
            ENDIF.
          ENDIF.  " IF lv_year > lv_year_t.
        ELSE. " IF sy-subrc = 0.
* IF other student member Reletionship Category is sent for Renewal, then
* a) Update the other Relationship cat. with three years validity
* b) Make expire the current student member Reletionship Category validity dates
* c) Update the Full membership (ZPR008) validation dates

          " a) Update the other student member Relationship cat. with three years validity
          lst_relations-partner1 = lst_reltyp-partner1.
          lst_relations-partner2 = lv_partner2.
          lst_relations-relationshipcategory = lst_reltyp-reltyp.
          lv_datef_c = lst_reltyp-credat.               " lst_reltyp-credat: Pricing year date
*          lv_datef_c+4(4) = lc_0101.
          lst_relations-validfromdate = lv_datef_c.     " Validity_From date
          lv_year = lst_reltyp-credat(4).
          lv_year = lv_year + lv_validity_yr.
          CONCATENATE lv_year lc_1231 INTO lv_datet_c.  " Validity_To date
          lst_relations-validuntildate = lv_datet_c.
          APPEND lst_relations TO li_relations_new.
          CLEAR lst_relations.

          " b) Make expire the current student member Reletionship Category
          IF <lst_relations> IS ASSIGNED.
            UNASSIGN <lst_relations>.
          ENDIF.
          lv_year = lv_datef_c(4).    " lv_datef_c is the other student member Rel. cat. Valid_From date
          LOOP AT li_rel_stud_memb ASSIGNING <lst_relations>.  " li_rel_stud_memb: Existing student member relationships
            lv_year_from = <lst_relations>-validfromdate(4).
            IF lv_year_from < lv_year.
              lv_year_to = lv_year - 1.
              CONCATENATE lv_year_to lc_1231 INTO lv_datee_c.  " lv_datef_c is the current student member Reletionship Valid_To date
            ELSE. " i.e. assumption is lv_year_from = lv_year.
              CONCATENATE lv_year lc_1231 INTO lv_datee_c.     " lv_datef_c is the current student member Reletionship Valid_To date
            ENDIF.
            <lst_relations>-validuntildate = lv_datee_c.
            <lst_relations>-relationshiptype = lc_m.
            APPEND <lst_relations> TO li_relations_new.
          ENDLOOP.

          " c) Update the Full membership (ZPR008) validation dates
          IF <lst_relations> IS ASSIGNED.
            UNASSIGN <lst_relations>.
          ENDIF.
          lv_year = lv_datet_c(4).     " lv_datet_c is the other student member Rel. cat. Valid_To date
          lv_year = lv_year + 1.
          CONCATENATE lv_year lc_0101 INTO lv_datef_c. " Full membership Validity_From date
          READ TABLE li_relations ASSIGNING <lst_relations> WITH KEY
                                  relationshipcategory = lc_relcat_zpr008
                                  BINARY SEARCH.
          IF sy-subrc = 0 AND <lst_relations> IS ASSIGNED.
            <lst_relations>-validfromdate = lv_datef_c.
            <lst_relations>-validuntildate = cl_bus_time=>gc_end_of_days.
            APPEND <lst_relations> TO li_relations_new.
          ELSE.
            lst_relations-partner1 = lst_reltyp-partner1.
            lst_relations-partner2 = lv_partner2.
            lst_relations-validfromdate = lv_datef_c.                   " Full membership Validity_From date
            lst_relations-validuntildate = cl_bus_time=>gc_end_of_days. " Full membership Validity_To date
            lst_relations-relationshipcategory = lc_relcat_zpr008.
            APPEND lst_relations TO li_relations_new.
            CLEAR lst_relations.
          ENDIF.
        ENDIF.  " IF <lst_relations>-relationshipcategory = lst_reltyp-reltyp.
      ENDIF.  " IF sy-subrc = 0 AND li_relations[] IS NOT INITIAL.

* Update the student member relation ship(s)
      IF li_relations_new[] IS NOT INITIAL.
        CALL FUNCTION 'ZQTC_UPD_BP_RELTYPES_I0343' IN UPDATE TASK
          EXPORTING
            it_relationships = li_relations_new
            im_idoc_num      = rv45a-docnum
            im_vbeln         = vbak-vbeln.
      ENDIF.
    ENDIF. " IF lv_partner2 IS NOT INITIAL.
  ENDIF. " IF sy-subrc = 0.

* Clear the ABAP shared memory
  FREE MEMORY ID lv_mem_name.

ENDIF. " IF sy-subrc = 0 AND lst_reltyp-reltyp IS NOT INITIAL.
