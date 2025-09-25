class ZLH_BP_ASSISTANCE_CL definition
  public
  inheriting from CL_WD_COMPONENT_ASSISTANCE
  create public .

public section.

  types:
    ty_rel_type_tab TYPE STANDARD TABLE OF bus_reltyp_data .
  types:
    BEGIN OF ty_counter,
        directed_type TYPE burs_relationship-directed_type,
        count         TYPE i,
      END OF ty_counter .
  types:
    tt_alv TYPE STANDARD TABLE OF zcdm_addr_chk INITIAL SIZE 0 .

  constants GC_VALID type CHAR5 value 'VALID' ##NO_TEXT.
  constants GC_X type BU_BOOLEAN value 'X' ##NO_TEXT.
  constants GC_OBJAP type BU_OBJAP value 'BUPR' ##NO_TEXT.
  constants GC_NO_XRF type BU_XRF value SPACE ##NO_TEXT.
  constants:
    BEGIN OF gc_dialog_activity,
        none    TYPE bus_dialog-activity VALUE space,
        create  TYPE bus_dialog-activity VALUE '01',
        change  TYPE bus_dialog-activity VALUE '02',
        display TYPE bus_dialog-activity VALUE '03',
        delete  TYPE bus_dialog-activity VALUE '06',
      END OF gc_dialog_activity .
  constants:
    BEGIN OF gc_type,
        unspecified  TYPE bus_partner-type VALUE ' ',
        person       TYPE bus_partner-type VALUE '1',
        organization TYPE bus_partner-type VALUE '2',
        group        TYPE bus_partner-type VALUE '3',
      END OF gc_type .
  constants:
    BEGIN OF gc_direction,
        none TYPE burs_relationship-direction VALUE 'N',
        from TYPE burs_relationship-direction VALUE 'F',
        to   TYPE burs_relationship-direction VALUE 'T',
      END OF gc_direction .
  data GT_COUNTERS type BURS_RELATIONSHIP_COUNT_T .
  data GS_ADRC type ADRC_STRUC .
  data GS_ADDR2_DATA type ADDR2_DATA .
  data GS_ADDR_CHK type ZCDM_ADDR_CHK .
  data GT_ADDR_ALV type TT_ALV .

  methods GET_ALL_REL_CAT_TYPES
    importing
      value(IV_PARTNER_TYPE) type BU_TYPE optional
    exporting
      !ET_REL_TYPES type BURS_RELATIONSHIP_DTYPE_T
      !ET_DEL_RELATIONS type TY_REL_TYPE_TAB .
  methods GET_REL_CAT_TITLE
    importing
      value(IS_DIRECTED_TYPE) type BURS_RELATIONSHIP_DTYPE optional
      value(IV_LANGUAGE) type SY-LANGU optional
    exporting
      !EV_TITLE type BU_BEZ50 .
  methods GET_COUNTER
    importing
      value(IS_DIRECTED_TYPE) type BURS_RELATIONSHIP_DTYPE optional
    exporting
      !EV_COUNT type I .
  methods GET_REL_CAT_COUNTS
    importing
      value(IV_PARTNER_NUMBER) type BU_PARTNER optional
      value(IT_DIRECTED_TYPES) type BURS_RELATIONSHIP_DTYPE_T optional
    exporting
      !ET_DIRECTED_TYPE_COUNTS type BURS_RELATIONSHIP_COUNT_T .
  methods VALIDATE_ADDR
    importing
      value(IS_ADDR_DATA) type ADDR2_DATA optional
      value(IV_PARTNER) type BU_PARTNER optional .
  methods POPULATE_ADDR_FROM_SAP
    importing
      value(IS_ADDR_DATA) type ADDR2_DATA optional .
  methods POPULATE_ADDR_FROM_CDM
    importing
      value(IS_ADDR_DATA) type ADDR2_DATA optional .
  methods ADDR_DOCT_INTERACT_VALIDATION
    importing
      value(IS_ADDR_CHECK) type ZCDM_ADDR_CHK optional
    exporting
      !ET_INTERACT_ADDR type ZINT_ADDR_CHK_T .
  methods ADDR_DOCT_BATCH_VALIDATION
    importing
      value(IS_ADDR_CHK) type ZCDM_ADDR_CHK optional
    exporting
      value(EV_STATUS) type STRING
      value(ES_ADRC) type ADRC_STRUC .
protected section.
private section.
ENDCLASS.



CLASS ZLH_BP_ASSISTANCE_CL IMPLEMENTATION.


  METHOD ADDR_DOCT_BATCH_VALIDATION.

* Local data declarations
    DATA: lr_root_excep      TYPE REF TO cx_root,
          lv_msg             TYPE string,
          lr_proxy_addr_dctr TYPE REF TO zaddr_dctr_valco_common_servic,  " Reference to your Consumer proxy object - Address Doctor
          li_btcip           TYPE zaddr_dctr_valcleanse_batch_a3,
          li_btcop           TYPE zaddr_dctr_valcleanse_batch_a2,
          lst_btcreq         TYPE zaddr_dctr_valcleanse_batch_a1,
          li_btcres          TYPE zaddr_dctr_valcleanse_batc_tab,
          lst_btcres         TYPE zaddr_dctr_valcleanse_batch_ad.

* Local constants
    CONSTANTS:
      lc_defport TYPE prx_logical_port_name VALUE 'DEFAULT'.


* Prepare data for BATCH WS input - request preparation
    lst_btcreq-address_line_1 = is_addr_chk-street.      " Street
    lst_btcreq-address_line_2 = is_addr_chk-str_suppl3.  " Street 4
    lst_btcreq-address_line_3 = is_addr_chk-location.    " Street 5
    lst_btcreq-city           = is_addr_chk-city.        " City
    IF is_addr_chk-region IS NOT INITIAL.
* Get the ISO region code from SIMDQ_REGIONS table for the entered SAP region code
      SELECT SINGLE iso_regioncode
             FROM simdq_regions INTO lst_btcreq-region
             WHERE countrycode    = is_addr_chk-country AND
                   sap_regioncode = is_addr_chk-region.
      IF sy-subrc <> 0. " If no entry maintained
        lst_btcreq-region   = is_addr_chk-region.        " Region
      ENDIF.
    ENDIF.

    lst_btcreq-postal_code    = is_addr_chk-postal_code. " Postal Code
    lst_btcreq-country        = is_addr_chk-country.     " Country Key

    APPEND lst_btcreq TO li_btcip-address_validation_batch_req.
    CLEAR lst_btcreq.

** To disply  message on the status bar while validation is in progress
*    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
*      EXPORTING
*        text = 'Address validation is in progress...'(031).

    TRY.
* Instantiate the Consumer proxy object with default logical port for Addres Doctor
* Consumer Proxy Class: ZADDR_DCTR_VALCO_COMMON_SERVIC
* URL for DEV: http://esbdevtx.wiley.com:15026/SMOTC/ADDRDOCTCOMMONSERVICE
* URL for QA: http://esbsittx.wiley.com:15026/SMOTC/ADDRDOCTCOMMONSERVICE
        IF lr_proxy_addr_dctr IS NOT BOUND.
          CREATE OBJECT lr_proxy_addr_dctr
            EXPORTING
              logical_port_name = lc_defport. " 'DEFAULT'.
        ENDIF.

* Call the Address Search - BATCH operation
        TRY.
            CALL METHOD lr_proxy_addr_dctr->cleanse_batch
              EXPORTING
                input  = li_btcip
              IMPORTING
                output = li_btcop.
          CATCH cx_ai_system_fault INTO lr_root_excep. " Catch exceptions into root
            lv_msg = lr_root_excep->get_text( ).
*          MESSAGE lv_msg TYPE 'S' DISPLAY LIKE 'E'.
*          LEAVE TO SCREEN 0.
        ENDTRY.
      CATCH cx_ai_system_fault INTO lr_root_excep. " Catch exceptions into root
        lv_msg = lr_root_excep->get_text( ).
*          MESSAGE lv_msg TYPE 'S' DISPLAY LIKE 'E'.
*          LEAVE TO SCREEN 0.
    ENDTRY.

* Web service response - checking the status
    li_btcres[] = li_btcop-address_validation_batch_res[].
    READ TABLE li_btcres INTO lst_btcres INDEX 1.
* If address is VALID
    IF lst_btcres-ad_status = gc_valid.
* Structure to display the suggested address on BATCH screen
*    es_adrc-building   = lst_btcres-building_number.   " Building Number
*    es_adrc-streetcode = lst_btcres-street_number.     " Street Number
      es_adrc-str_suppl1 = is_addr_chk-str_suppl1.      " Street 2 - SAP
      es_adrc-str_suppl2 = is_addr_chk-str_suppl2.      " Street 3 - SAP
      es_adrc-street     = lst_btcres-address_line_1.   " Street
      es_adrc-str_suppl3 = lst_btcres-address_line_2.   " Street 4
      es_adrc-location   = lst_btcres-address_line_3.   " Street 5
      es_adrc-city1      = lst_btcres-city.             " City
      es_adrc-country    = lst_btcres-country_iso2.     " Country
      IF lst_btcres-region_cd IS NOT INITIAL.
* Get the SAP region code from SIMDQ_REGIONS table for the returned ISO region code from WS
        SELECT SINGLE sap_regioncode
               FROM simdq_regions INTO es_adrc-region
               WHERE countrycode    = es_adrc-country AND
                     iso_regioncode = lst_btcres-region_cd.
        IF sy-subrc <> 0. " If no entry maintained
          es_adrc-region  = lst_btcres-region_cd.       " State
        ENDIF.
      ENDIF.
      es_adrc-po_box     = lst_btcres-po_box.            " PO Box
      es_adrc-post_code1 = lst_btcres-postal_code.       " Postal Code

      ev_status = lst_btcres-ad_status. " VALID.

* Flag for the field: USER_OVERRIDE_FLAG
*      gv_flag = lst_btcres-user_override_flag.

* For Comparing if there is any difference between the user entered address
* and BATCH returned address w.r.t the below fields only
*      g_adrc_tmp-str_suppl1 = g_addr2_data-str_suppl1.
*      g_adrc_tmp-str_suppl2 = g_addr2_data-str_suppl2.
*      g_adrc_tmp-street     = g_addr2_data-street.
*      g_adrc_tmp-str_suppl3 = g_addr2_data-str_suppl3.
*      g_adrc_tmp-location   = g_addr2_data-location.
*      g_adrc_tmp-city1      = g_addr2_data-city1.
*      g_adrc_tmp-region     = g_addr2_data-region.
*      g_adrc_tmp-po_box     = g_addr2_data-po_box.
*      g_adrc_tmp-post_code1 = g_addr2_data-post_code1.
*      g_adrc_tmp-country    = g_addr2_data-country.

    ELSE.
* If the status of the address is invalid
      ev_status = lst_btcres-ad_status. " INVALID.
    ENDIF.



  ENDMETHOD.


  METHOD addr_doct_interact_validation.

* Declarations for Try/Catch block exception handling
    DATA: lr_exc             TYPE REF TO cx_root,
          lv_msg             TYPE string,
          lr_proxy_addr_dctr TYPE REF TO zaddr_dctr_valco_common_servic, " Proxy class Reference variable - Address Doctor
          lst_interact_chk   TYPE zint_addr_chk.

* Internal tables and work areas for Web service request and response
    DATA: lst_intip  TYPE zaddr_dctr_valcleanse_interac3,
          li_intop   TYPE zaddr_dctr_valcleanse_interac2,
          lst_intreq TYPE zaddr_dctr_valcleanse_interac1,
          li_intres  TYPE zaddr_dctr_valcleanse_inte_tab,
          lst_intres TYPE zaddr_dctr_valcleanse_interact.

* Reference to Timer Class
*    DATA: lo_receiver_int TYPE REF TO lcl_receiver_int       ##NEEDED.

    CONSTANTS:
      lc_logical_port   TYPE prx_logical_port_name VALUE 'DEFAULT'.

* Prepare the data for Interactive web service - request preparation
    lst_intreq-address_line_1 = is_addr_check-street.      " Street
    lst_intreq-address_line_2 = is_addr_check-str_suppl3.  " Street 4
    lst_intreq-address_line_3 = is_addr_check-location.    " Street 5
    lst_intreq-city           = is_addr_check-city.        " City
    lst_intreq-postal_code    = is_addr_check-postal_code. " Postal Code
    lst_intreq-country        = is_addr_check-country.     " Country
    IF is_addr_check-region IS NOT INITIAL.
* Get the ISO region code from SIMDQ_REGIONS table for the entered SAP region code
      SELECT SINGLE iso_regioncode
             FROM simdq_regions INTO lst_intreq-region
             WHERE countrycode    = is_addr_check-country AND
                   sap_regioncode = is_addr_check-region.
      IF sy-subrc <> 0. " If no entry maintained
        lst_intreq-region     = is_addr_check-region.      " Region
      ENDIF.
    ENDIF.

    lst_intip-address_validation_multi_req = lst_intreq.
    CLEAR lst_intreq.

* To disply  message on the status bar while search is in progress
*    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
*      EXPORTING
*        text = 'Address search is in progress..'(030).

* Setting Timer for the web service run; if it exceeds more than 60 seconds
* then returning to BP initial screen with a message to the user
*    IF lo_receiver_int IS INITIAL.
*      CREATE OBJECT lo_receiver_int.
*    ENDIF.
*    IF lo_receiver_int->go_timer IS INITIAL.
*      CREATE OBJECT lo_receiver_int->go_timer.
*      SET HANDLER lo_receiver_int->on_finished FOR lo_receiver_int->go_timer.
*    ENDIF.
*
** Set the time interval to 15 seconds
*    lo_receiver_int->go_timer->interval = 15.
** Activate the timer
*    CALL METHOD lo_receiver_int->go_timer->run.

    TRY.
* Instantiate the object reference for proxy with default logical port for Address Doctor
* Service Consumer: CLASZADDR_DCTR_VALCO_COMMON_SERVIC
* URL for DEV: http://esbdevtx.wiley.com:15026/SMOTC/ADDRDOCTCOMMONSERVICE
* URL for QA: http://esbsittx.wiley.com:15026/SMOTC/ADDRDOCTCOMMONSERVICE
        IF lr_proxy_addr_dctr IS NOT BOUND.
          CREATE OBJECT lr_proxy_addr_dctr
            EXPORTING
              logical_port_name = lc_logical_port. " 'DEFAULT'.
        ENDIF.

* Call the Interactive operation
        TRY.
            CALL METHOD lr_proxy_addr_dctr->cleanse_interactive
              EXPORTING
                input  = lst_intip
              IMPORTING
                output = li_intop.
          CATCH cx_ai_system_fault INTO lr_exc. " Catch the exceptions into root
            lv_msg = lr_exc->get_text( ).
        ENDTRY.
      CATCH cx_ai_system_fault INTO lr_exc. " Catch exceptions into root
        lv_msg = lr_exc->get_text( ).
    ENDTRY.

* Stop the timer if the execution is completed in less than 60 sec
*    CALL METHOD lo_receiver_int->go_timer->cancel.

* Interactive web service response
    li_intres[] = li_intop-address_validation_multi_res[].

* Prepare the data for ALV display
    LOOP AT li_intres INTO lst_intres.
* BOC - ERP-7495 - ED1K907626 (06/06/2018)
      IF lst_intres-ad_match_code = 'Q0'.
        CONCATENATE  lst_intres-ad_match_code '-' 'Insufficient information provided to generate suggestions'(073) INTO lst_intres-ad_match_code.
      ELSEIF lst_intres-ad_match_code = 'Q1'.
        CONCATENATE  lst_intres-ad_match_code '-' 'Suggested address is not complete(enter more information)'(074) INTO lst_intres-ad_match_code.
      ELSEIF lst_intres-ad_match_code = 'Q2'.
        CONCATENATE  lst_intres-ad_match_code '-' 'Suggested address is complete but combined with elements'(075) INTO lst_intres-ad_match_code.
      ELSEIF lst_intres-ad_match_code = 'Q3'.
        CONCATENATE  lst_intres-ad_match_code '-' 'Suggestions are available – complete address'(086) INTO lst_intres-ad_match_code.
      ENDIF.
* EOC - ERP-7495 - ED1K907626 (06/06/2018)
      MOVE-CORRESPONDING lst_intres TO lst_interact_chk.
      APPEND lst_interact_chk TO et_interact_addr.
      CLEAR: lst_interact_chk, lst_intres.
    ENDLOOP.

* Delete the records with score = 0 and result percentage = 0.00%
* which indicate invalid records
    DELETE et_interact_addr WHERE ad_mobility_score = 0 OR ad_result_percentage = 0.

    IF et_interact_addr IS NOT INITIAL.
* Call the Interactive ALV screen
*      SET SCREEN gc_9002.
*      LEAVE SCREEN.
    ELSE.

* No data found from interactive web service
* Return to initial SAP screen with no changes
*      CLEAR: gv_option_9000, gv_option_9001.
*      IF go_grid_cdm IS NOT INITIAL.
**   Free CDM alv grid and container
*        go_grid_cdm->free( ).
*        go_cust_container_cdm->free( ).
*        CLEAR go_grid_cdm.
*        CLEAR go_cust_container_cdm.
*        cl_gui_cfw=>dispatch( ).
*        cl_gui_cfw=>flush( ).
*        SUPPRESS DIALOG.
*      ENDIF.
*
** Return the OK code to have no changes in the input data
*      gv_option_9000 = 'CANCEL'(042).
*      IF lv_msg IS NOT INITIAL. " Exception has been raised by the web service operation
*        MESSAGE 'Communication Error with the Address Doctor Web Service. The address is not validated...'(058) TYPE 'S' DISPLAY LIKE 'W'.
*      ELSE. " No validated data found from the web service
*        MESSAGE 'No validated address found for the given data.'(036) TYPE 'S' DISPLAY LIKE 'W'.
*      ENDIF.
*      LEAVE TO SCREEN 0.
    ENDIF. " IF et_interact_addr is NOT INITIAL .


  ENDMETHOD.


  METHOD get_all_rel_cat_types.

*   Local data.
    DATA: lv_from           TYPE bu_boolean,
          lv_to             TYPE bu_boolean,
          ls_directed_type  TYPE burs_relationship-directed_type,
          ls_reltyp_data    TYPE bus_reltyp_data,
          ls_reltyp_data2   TYPE bus_reltyp_data,
          lt_reltyp_data    TYPE STANDARD TABLE OF bus_reltyp_data,
          lt_reltyp_data2   TYPE STANDARD TABLE OF bus_reltyp_data,
          lt_directed_types TYPE burs_relationship_dtype_t,
          lt_tbz0a          TYPE TABLE OF tbz0a,
          ls_tbz0a          TYPE tbz0a,
          lt_tb920          TYPE TABLE OF tb920.

    CALL FUNCTION 'BUS_RELTYP_GET_MULTIPLE'
      EXPORTING
        i_xrf         = gc_no_xrf
      TABLES
        t_reltyp_data = lt_reltyp_data
        t_roles       = lt_tb920.

    DELETE lt_reltyp_data WHERE xsuppress = gc_x.

*   Exclude reltypes whose application is not active
    CALL FUNCTION 'BDT_TBZ0A_GET'
      EXPORTING
        iv_objap             = gc_objap
      TABLES
        et_tbz0a             = lt_tbz0a
      EXCEPTIONS
        not_found_with_objap = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
    ENDIF.

    LOOP AT lt_reltyp_data INTO ls_reltyp_data.
      READ TABLE lt_tbz0a INTO ls_tbz0a
                          WITH KEY appli = ls_reltyp_data-appli_tab.
      IF sy-subrc = 0 AND  ls_tbz0a-xaktv IS INITIAL.
        DELETE lt_reltyp_data.
      ENDIF.
      CLEAR ls_reltyp_data.
    ENDLOOP.

*Need to do an authority check here do display only those that the user is allowed to see
    LOOP AT lt_reltyp_data INTO ls_reltyp_data.
      AUTHORITY-CHECK OBJECT 'B_BUPR_BZT'
               ID 'ACTVT' FIELD gc_dialog_activity-display
               ID 'RELTYP' FIELD ls_reltyp_data-reltyp.

      IF NOT sy-subrc IS INITIAL.
        DELETE lt_reltyp_data WHERE reltyp = ls_reltyp_data-reltyp.
        APPEND ls_reltyp_data TO et_del_relations.
      ENDIF.
      CLEAR ls_reltyp_data.
    ENDLOOP.

*   Sort table by position number (the filled ones first)
    ls_reltyp_data-posnr = ls_reltyp_data-posnr_2 = '999'.
    MODIFY lt_reltyp_data FROM ls_reltyp_data TRANSPORTING posnr
           WHERE posnr IS INITIAL.
    MODIFY lt_reltyp_data FROM ls_reltyp_data TRANSPORTING posnr_2
           WHERE posnr_2 IS INITIAL.

*   For directed types we need two entries, both having their data
*   (sort number and description) in the same fields for both directions
*   (POSNR and BEZ50). This is to allow sorting both directions
*   correctly.
    LOOP AT lt_reltyp_data INTO ls_reltyp_data WHERE xdirection = gc_x.
      ls_reltyp_data2 = ls_reltyp_data.
      ls_reltyp_data2-posnr = ls_reltyp_data2-posnr_2.
      ls_reltyp_data2-bez50 = ls_reltyp_data2-bez50_2.
      CLEAR: ls_reltyp_data2-xorga_p1, ls_reltyp_data2-xpers_p1,
             ls_reltyp_data2-xgrou_p1.
      APPEND ls_reltyp_data2 TO lt_reltyp_data2.
      CLEAR: ls_reltyp_data-xorga_p2, ls_reltyp_data-xpers_p2,
             ls_reltyp_data-xgrou_p2.
      MODIFY lt_reltyp_data FROM ls_reltyp_data.
    ENDLOOP.

    APPEND LINES OF lt_reltyp_data2 TO lt_reltyp_data.

    SORT lt_reltyp_data BY posnr bez50 AS TEXT.

    LOOP AT lt_reltyp_data INTO ls_reltyp_data.
*     Determine if source partner type is relevant.
      CLEAR lv_from.
      CASE iv_partner_type.
        WHEN gc_type-unspecified.
          lv_from = gc_x.
          lv_to = gc_x.
        WHEN gc_type-person.
          lv_from = ls_reltyp_data-xpers_p1.
          lv_to = ls_reltyp_data-xpers_p2.
        WHEN gc_type-organization.
          lv_from = ls_reltyp_data-xorga_p1.
          lv_to = ls_reltyp_data-xorga_p2.
        WHEN gc_type-group.
          lv_from = ls_reltyp_data-xgrou_p1.
          lv_to = ls_reltyp_data-xgrou_p2.
      ENDCASE.

      ls_directed_type-type-reltyp = ls_reltyp_data-reltyp.
      ls_directed_type-type-xrf    = ls_reltyp_data-xrf.

      IF ls_reltyp_data-xdirection IS INITIAL.
        IF lv_from = gc_x.
          ls_directed_type-direction = gc_direction-none.
          APPEND ls_directed_type TO et_rel_types.
        ENDIF.
      ELSE.
        IF lv_from = gc_x.
          ls_directed_type-direction = gc_direction-from.
          APPEND ls_directed_type TO et_rel_types.
        ENDIF.
        IF lv_to = gc_x.
          ls_directed_type-direction = gc_direction-to.
          APPEND ls_directed_type TO et_rel_types.
        ENDIF.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD get_counter.

*   Local data.
    DATA ls_counter TYPE ty_counter.

    READ TABLE gt_counters
               WITH TABLE KEY directed_type = is_directed_type
               INTO ls_counter.
    IF sy-subrc IS INITIAL.
      ev_count = ls_counter-count.
    ELSE.
      CLEAR ev_count.
    ENDIF.

  ENDMETHOD.


  METHOD get_rel_cat_counts.

*   Local data
    DATA: lv_reltyp              TYPE bu_reltyp,
          lv_count               TYPE i,
          ls_directed_type       TYPE burs_relationship-directed_type,
          ls_directed_type_count TYPE burs_relationship_count,
          ls_reltyp_range        TYPE bus050_btr,
          lt_reltyp_range        TYPE bureltyprng,
          lt_reltyp_count_sort   TYPE burs_relationship_count_t,
          lt_action              TYPE bub01_action_rngtab,
          ls_action              LIKE LINE OF lt_action,
          lt_partner             TYPE RANGE OF bu_partner,
          ls_partner             LIKE LINE OF lt_partner,
          ls_relationship_lm     TYPE bus050___i,
          lt_relationships_lm    TYPE TABLE OF bus050___i.

    ls_reltyp_range-sign   = 'I'.
    ls_reltyp_range-option = 'EQ'.
    LOOP AT it_directed_types INTO  ls_directed_type
                              WHERE direction = gc_direction-from
                                 OR direction = gc_direction-none.
      ls_reltyp_range-low = ls_directed_type-type-reltyp.
      APPEND ls_reltyp_range TO lt_reltyp_range.
      CLEAR ls_reltyp_range.
    ENDLOOP.

    SELECT reltyp COUNT(*) INTO (lv_reltyp, lv_count)
                           FROM  but050
                           WHERE partner1 =  iv_partner_number
                           AND   reltyp   IN lt_reltyp_range
                           GROUP BY partner1 reltyp.
      CHECK NOT lv_count IS INITIAL.
      LOOP AT it_directed_types INTO ls_directed_type
                                WHERE type-reltyp = lv_reltyp
                                  AND ( direction = gc_direction-from
                                   OR   direction = gc_direction-none ).
        ls_directed_type_count-directed_type = ls_directed_type.
        ls_directed_type_count-count         = lv_count.
        APPEND ls_directed_type_count TO et_directed_type_counts.
      ENDLOOP.
    ENDSELECT.

    CLEAR lt_reltyp_range.
    LOOP AT it_directed_types INTO  ls_directed_type
                              WHERE direction = gc_direction-to
                                 OR direction = gc_direction-none.
      ls_reltyp_range-low = ls_directed_type-type-reltyp.
      APPEND ls_reltyp_range TO lt_reltyp_range.
      CLEAR ls_reltyp_range.
    ENDLOOP.

    SELECT reltyp COUNT(*) INTO (lv_reltyp, lv_count)
                           FROM  but050
                           WHERE partner2 =  iv_partner_number
                           AND   reltyp   IN lt_reltyp_range
                           GROUP BY partner2 reltyp.
      CHECK NOT lv_count IS INITIAL.
      LOOP AT it_directed_types INTO ls_directed_type
                                WHERE type-reltyp = lv_reltyp
                                  AND ( direction = gc_direction-to
                                   OR   direction = gc_direction-none ).
        IF ls_directed_type-direction EQ gc_direction-none.
          READ TABLE et_directed_type_counts
                     INTO ls_directed_type_count
                     WITH KEY directed_type = ls_directed_type.
          IF sy-subrc EQ 0.
            ls_directed_type_count-count = ls_directed_type_count-count
                                           + lv_count.
            MODIFY et_directed_type_counts FROM ls_directed_type_count
                                           INDEX sy-tabix.
          ELSE.
            ls_directed_type_count-directed_type = ls_directed_type.
            ls_directed_type_count-count         = lv_count.
            APPEND ls_directed_type_count TO et_directed_type_counts.
          ENDIF.
        ELSE.
          ls_directed_type_count-directed_type = ls_directed_type.
          ls_directed_type_count-count         = lv_count.
          APPEND ls_directed_type_count TO et_directed_type_counts.
        ENDIF.
      ENDLOOP.
    ENDSELECT.

*   Search in the global memories of relationship maintenance for
*   take over mode
    ls_action-sign   = 'I'.
    ls_action-option = 'EQ'.
    ls_action-low    = 'I'.
    APPEND ls_action TO lt_action.
    ls_action-low    = 'D'.
    APPEND ls_action TO lt_action.

    ls_partner-sign   = 'I'.
    ls_partner-option = 'EQ'.
    ls_partner-low    = iv_partner_number.
    APPEND ls_partner TO lt_partner.

    CALL FUNCTION 'BUB_BUPR_BUT050_LM_READ'
      EXPORTING
        i_xlm1         = space
        i_xlm2         = gc_x
        i_xdb          = space
        i_xrf          = space
        i_xall         = gc_x
        iv_xcheck_only = space
      TABLES
        t_partner1     = lt_partner
        t_action       = lt_action
        t_relations_lm = lt_relationships_lm.

    LOOP AT lt_relationships_lm INTO ls_relationship_lm.
      IF ls_relationship_lm-partner1 EQ iv_partner_number.
        LOOP AT it_directed_types INTO ls_directed_type
                WHERE type-reltyp = ls_relationship_lm-reltyp
                  AND ( direction = gc_direction-from
                   OR   direction = gc_direction-none ).
          READ TABLE et_directed_type_counts
                     INTO ls_directed_type_count
                     WITH KEY directed_type = ls_directed_type.
          IF sy-subrc EQ 0.
            IF ls_relationship_lm-action EQ 'I'.
              ls_directed_type_count-count =
              ls_directed_type_count-count + 1.
              MODIFY et_directed_type_counts
                     FROM ls_directed_type_count
                     INDEX sy-tabix.
            ELSEIF ls_relationship_lm-action EQ 'D'.
              ls_directed_type_count-count =
              ls_directed_type_count-count - 1.
              IF ls_directed_type_count-count < 1.
                DELETE et_directed_type_counts INDEX sy-tabix.
              ELSE.
                MODIFY et_directed_type_counts
                       FROM ls_directed_type_count
                       INDEX sy-tabix.
              ENDIF.
            ENDIF.
          ELSE.
            IF ls_relationship_lm-action EQ 'I'.
              ls_directed_type_count-directed_type = ls_directed_type.
              ls_directed_type_count-count         = 1.
              APPEND ls_directed_type_count TO et_directed_type_counts.
*           ELSEIF ls_relationship_lm-action EQ 'D'.
*             Should not be happened.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ELSE.
        LOOP AT it_directed_types INTO ls_directed_type
                WHERE type-reltyp = ls_relationship_lm-reltyp
                  AND ( direction = gc_direction-to
                   OR   direction = gc_direction-none ).
          READ TABLE et_directed_type_counts
                     INTO ls_directed_type_count
                     WITH KEY directed_type = ls_directed_type.
          IF sy-subrc EQ 0.
            IF ls_relationship_lm-action EQ 'I'.
              ls_directed_type_count-count =
              ls_directed_type_count-count + 1.
              MODIFY et_directed_type_counts
                     FROM ls_directed_type_count
                     INDEX sy-tabix.
            ELSEIF ls_relationship_lm-action EQ 'D'.
              ls_directed_type_count-count =
              ls_directed_type_count-count - 1.
              IF ls_directed_type_count-count < 1.
                DELETE et_directed_type_counts INDEX sy-tabix.
              ELSE.
                MODIFY et_directed_type_counts
                       FROM ls_directed_type_count
                       INDEX sy-tabix.
              ENDIF.
            ENDIF.
          ELSE.
            IF ls_relationship_lm-action EQ 'I'.
              ls_directed_type_count-directed_type = ls_directed_type.
              ls_directed_type_count-count         = 1.
              APPEND ls_directed_type_count TO et_directed_type_counts.
*           ELSEIF ls_relationship_lm-action EQ 'D'.
*             Should not be happened.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

*   Adjust the relationship counter according to the customizing
    LOOP AT it_directed_types INTO ls_directed_type.
      LOOP AT et_directed_type_counts INTO ls_directed_type_count
              WHERE directed_type = ls_directed_type.
        APPEND ls_directed_type_count TO lt_reltyp_count_sort.
      ENDLOOP.
    ENDLOOP.
    gt_counters[] = lt_reltyp_count_sort[].


  ENDMETHOD.


  METHOD get_rel_cat_title.

*   Local data.
    DATA ls_reltyp_data TYPE bus_reltyp_data.

    CALL FUNCTION 'BUS_RELTYP_GET'
      EXPORTING
        i_reltyp      = is_directed_type-type-reltyp
        i_xrf         = is_directed_type-type-xrf
        i_spras       = iv_language
        i_xdata       = gc_x
        i_xtext       = gc_x
      IMPORTING
        e_reltyp_data = ls_reltyp_data
      EXCEPTIONS
        OTHERS        = 1.

    CASE is_directed_type-direction.
      WHEN gc_direction-none.
        ev_title = ls_reltyp_data-bez50.
      WHEN gc_direction-from.
        ev_title = ls_reltyp_data-bez50.
      WHEN gc_direction-to.
        ev_title = ls_reltyp_data-bez50_2.
      WHEN OTHERS.
        ev_title = is_directed_type.
    ENDCASE.

  ENDMETHOD.


  method POPULATE_ADDR_FROM_CDM.


  endmethod.


  method POPULATE_ADDR_FROM_SAP.




  endmethod.


  METHOD validate_addr.

    IF iv_partner IS INITIAL.
      populate_addr_from_sap( is_addr_data ).
      populate_addr_from_cdm( is_addr_data ).
    ENDIF.

* Keeping the input data to display on BATCH screen - under 'Your Address' block
    gs_addr2_data = is_addr_data.

    IF gt_addr_alv IS NOT INITIAL.

    ELSE.
      gs_addr_chk-city        = gs_addr2_data-city1.       " City
      gs_addr_chk-postal_code = gs_addr2_data-post_code1.  " Postal Code
      gs_addr_chk-str_suppl1  = gs_addr2_data-str_suppl1.  " Street 2
      gs_addr_chk-str_suppl2  = gs_addr2_data-str_suppl2.  " Street 3
      gs_addr_chk-street      = gs_addr2_data-street.      " Street
      gs_addr_chk-str_suppl3  = gs_addr2_data-str_suppl3.  " Street 4
      gs_addr_chk-location    = gs_addr2_data-location.    " Street 5
      gs_addr_chk-country     = gs_addr2_data-country.     " Country
      gs_addr_chk-region      = gs_addr2_data-region.      " Region
    ENDIF.









  ENDMETHOD.
ENDCLASS.
