*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BP_CRDTCOLL_DEF_LH_E191
*&---------------------------------------------------------------------*
*--------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BP_CRDTCOLL_DEF_LH_E191
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 27-03-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914714
*--------------------------------------------------------------------*
* PROGRAM DESCRIPTION:
* DEVELOPER: Sunil Kumar Kairamkonda ( SKKAIRAMKO )
* CREATION DATE: 5-28-2019
* OBJECT ID: INC0245406
* TRANSPORT NUMBER(S):ED1K910232
*--------------------------------------------------------------------*
* REFERENCE ID: ERP-128
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 06-13-2019
* TRANSPORT NUMBER(s): ED1K910232
* DESCRIPTION: Read Company Code against Sales Org.
*--------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920433
* REFERENCE NO: OTCM-31003
* DEVELOPER:mimmadiset
* DATE: 11/25/2020
* DESCRIPTION:If BP extend a BP from CCode 1001 to new Sales Org / CCode 1030
* and dis channel skip the PERFORM f_check_credit_management.
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:OTCM 29502: As a BP Admin, I should be prompted for any
*critical data missing/wrong with an error if the system does not
*auto derive data points when an account is managed
*----------------------------------------------------------------------*

* Local Types
  TYPES:
    tt_cvis_sales_area TYPE TABLE OF cvis_sales_area_dynpro,
    tt_constants       TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0.

  DATA:
    lst_constant    TYPE ty_constants,
    li_constants    TYPE tt_constants,
    li_but000       TYPE STANDARD TABLE OF but000,
    lt_partnerroles TYPE TABLE OF bup_partnerroles,
    lv_partner      TYPE bu_partner,
    lv_bp_type      TYPE bu_type,
    lst_sales_area  TYPE cvis_sales_area_dynpro,
    li_sales_areas  TYPE cvis_sales_area_info_t,
    lv_sales_areas  TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_SALES_AREAS[]',
    lv_constants    TYPE char50 VALUE '(SAPLZQTC_FG_BP_VALIDATIONS)I_CONSTANTS[]',
    lv_sales_area   TYPE rvari_vnam,
    lv_bukrs        TYPE bukrs,
    lr_kunnr        TYPE RANGE OF kunnr,
    lv_cgrp         TYPE ukm_cred_group,
    lv_job_num      TYPE btcjobcnt,
    lv_jobname      TYPE btcjob,
    lv_date_char    TYPE char8,
    lv_time_char    TYPE char6,
    lv_date         TYPE d,
    lv_ctime        TYPE t,
    lv_atime        TYPE t,
    lv_aktyp        TYPE bu_aktyp,       " Activity Category
    li_bapireturn   TYPE bapiret2_t,
    lst_bapiret     TYPE bapiret2,
    lv_crds_flag    TYPE char1,    " ++OTCM-29502
    lv_batch_user   TYPE sy-uname, " ++INC0245406
    lst_tvko        TYPE tvko.     " ++ERP-128

* local field-symbols
  FIELD-SYMBOLS:
    <li_constants>  TYPE tt_constants,
    <li_sales_area> TYPE tt_cvis_sales_area. " Itab: Sales Areas

* Local constants
  CONSTANTS:
    lc_parvw        TYPE rvari_vnam VALUE 'PARVW',
    lc_sales_org    TYPE char5      VALUE 'VKORG',
    lc_credit_group TYPE rvari_vnam VALUE 'CREDIT_GROUP',
    lc_bukrs_cc     TYPE rvari_vnam VALUE 'BUKRS_CC', "++OTCM-29502
    lc_bp           TYPE string     VALUE 'BP',
    lc_msg_txt      TYPE string     VALUE 'has been created. Please switch to Display BP',
    lc_hash         TYPE char1      VALUE '#',
    lc_us           TYPE char1      VALUE '_',
    lc_wait_time    TYPE char20     VALUE 'WAIT_TIME_IN_SECS',
    lc_atime        TYPE t          VALUE '000500',
    lc_person       TYPE bu_type    VALUE '1',      " BP: Person
    lc_organization TYPE bu_type    VALUE '2',     " BP: Organization
    lc_batch_user   TYPE rvari_vnam VALUE 'BATCH_USER',  "++INC0245406
    lc_btype_1      TYPE bu_type    VALUE '1',
    lc_btype_2      TYPE bu_type    VALUE '2'.
*------------------------------------------------------------------------*

  " Get the customer Sales Areas from ABAP Stack
  ASSIGN (lv_sales_areas) TO <li_sales_area>.
  IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.

    IF <li_sales_area> IS INITIAL.
      li_sales_areas = cvi_bdt_adapter=>get_sales_areas( ).
      LOOP AT li_sales_areas INTO DATA(lst_sa).
        MOVE-CORRESPONDING lst_sa TO lst_sales_area.
        lst_sales_area-new_sa = lst_sa-is_new.
        APPEND lst_sales_area TO <li_sales_area>.
        CLEAR: lst_sales_area, lst_sa.
      ENDLOOP.
    ENDIF.
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

      LOOP AT <li_sales_area> INTO lst_sales_area WHERE new_sa = abap_true.
        " Validate Sales Org. from constant entry and extend the BP Roles (Credit & Collection Mgmt)
        IF line_exists( li_constants[ param1 = lc_sales_org
                                      low    = lst_sales_area-sales_org ] ).
          " Check whether Sales Org. already exist or not
          " If Sales Org. (Ex: 1030) doesn't exist, then only allow BP to enhance it's roles to Credit/Collection Mgmt
          " Assumption is 'if Sales Org. already exist, then BP is already enhanced with Credit/Collection
          " management Roles
          READ TABLE <li_sales_area> WITH KEY sales_org = lst_sales_area-sales_org
                                              new_sa = abap_false TRANSPORTING NO FIELDS.
          IF sy-subrc <> 0.
            " Message text
            CONCATENATE lc_bp lc_hash INTO DATA(lv_bp_txt).
            CONCATENATE lv_bp_txt lv_partner lc_msg_txt INTO DATA(lv_msg_txt) SEPARATED BY space.

            CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
              EXPORTING
                titel        = 'Information'
                textline1    = lv_msg_txt
                textline2    = ' '
                start_column = 25
                start_row    = 6.
            IF sy-subrc = 0.
              GET TIME.
              lv_date_char = sy-datum.
              lv_time_char = sy-uzeit.
              CONCATENATE lc_bp lc_us lv_partner lc_us lv_date_char lv_time_char INTO lv_jobname.

*** BOC: ERP-128  KKRAVURI20190613  ED1K910356
              " FM call to get the Company Code of the Sales Org.
              CALL FUNCTION 'TVKO_SINGLE_READ'
                EXPORTING
                  vkorg     = lst_sales_area-sales_org
                IMPORTING
                  wtvko     = lst_tvko
                EXCEPTIONS
                  not_found = 1
                  OTHERS    = 2.
              IF sy-subrc = 0.
                lv_bukrs = lst_tvko-bukrs.
              ENDIF.
*** EOC: ERP-128  KKRAVURI20190613  ED1K910356

              lv_sales_area = lst_sales_area-sales_org && lst_sales_area-dist_channel && lst_sales_area-division.
              IF line_exists( li_constants[ param1 = lc_credit_group param2 = lv_sales_area ] ).
                lv_cgrp = li_constants[ param1 = lc_credit_group param2 = lv_sales_area ]-low+0(4).
**               BOC MIMMADISET OTCM-29502 ED2K920531
                  IF line_exists( li_constants[ param1 = lc_credit_group param2 = lv_sales_area high = lv_bp_type ] ).
                    lv_cgrp = li_constants[ param1 = lc_credit_group param2 = lv_sales_area high = lv_bp_type ]-low+0(4).
                  ENDIF.
**               EOC MIMMADISET OTCM-29502 ED2K920531
              ELSE.
                lv_cgrp = lst_sales_area-sales_org.
              ENDIF.
******BOC  MIMMADISET OTCM-29502 ED2K920531
**The below condition is to to uncheck the credit collection flag only for the Company codes mentioned in  zcaconstant.
              IF line_exists( li_constants[ param1 = lc_bukrs_cc param2 = lv_sales_area ] ).
                lv_crds_flag = abap_false.
              ELSE.
                lv_crds_flag = abap_true.
              ENDIF.
******EOC  MIMMADISET OTCM-29502 ED2K920531

              lr_kunnr = VALUE #(
                              ( sign = 'I'
                                option = 'EQ'
                                low  = lv_partner
                               ) ).
*--BOC: INC0245406 - SKKAIRAMKO - 05/28/2019
              TRY.
                  DATA(ls_constants) = li_constants[ param1 = lc_batch_user ].
                  lv_batch_user = ls_constants-low.
                CATCH cx_sy_itab_line_not_found.
              ENDTRY.
*--EOC: INC0245406 - SKKAIRAMKO - 5/28/2019

              CALL FUNCTION 'JOB_OPEN'
                EXPORTING
                  jobname          = lv_jobname
                IMPORTING
                  jobcount         = lv_job_num
                EXCEPTIONS
                  cant_create_job  = 1
                  invalid_job_data = 2
                  jobname_missing  = 3
                  OTHERS           = 4.
              IF sy-subrc = 0.
*--If Batch user is not maintained, system will take the user who created BP
                IF lv_batch_user IS NOT INITIAL.
                  SUBMIT zrtrr_bp_crdt_coll_dflts_e191
                         WITH p_bukrs EQ lv_bukrs
                         WITH s_kunnr IN lr_kunnr
                         WITH p_vkorg EQ lst_sales_area-sales_org "++mimmadiset 11/23/2020 salea org Divison , and distrub chl
                         WITH p_vtweg EQ lst_sales_area-dist_channel "++mimmadiset 11/23/2020 salea org Divison , and distrub chl
                         WITH p_spart EQ lst_sales_area-division "+mimmadiset 11/23/2020 salea org Divison , and distrub chl
                         WITH p_crdtg EQ lv_cgrp
                         WITH p_crds EQ lv_crds_flag "++MIMMADISET OTCM-29502 ED2K920531 "abap_true
                         WITH p_cols EQ abap_true
                         WITH p_batch EQ abap_true
                         USER lv_batch_user  "INC0245406 ++skkairamko
                         VIA JOB lv_jobname NUMBER lv_job_num
                         AND RETURN.
                ELSE. "No Batch user
                  SUBMIT zrtrr_bp_crdt_coll_dflts_e191
                       WITH p_bukrs EQ lv_bukrs
                       WITH s_kunnr IN lr_kunnr
                       WITH p_vkorg EQ lst_sales_area-sales_org "++mimmadiset 11/23/2020 salea org Divison , and distrub chl
                       WITH p_vtweg EQ lst_sales_area-dist_channel "++mimmadiset 11/23/2020 salea org Divison , and distrub chl
                       WITH p_spart EQ lst_sales_area-division "+mimmadiset 11/23/2020 salea org Divison , and distrub chl
                       WITH p_crdtg EQ lv_cgrp
                       WITH p_crds EQ lv_crds_flag " MIMMADISET OTCM-29502 ED2K920531 "abap_true
                       WITH p_cols EQ abap_true
                       WITH p_batch EQ abap_true
                       VIA JOB lv_jobname NUMBER lv_job_num
                       AND RETURN.
                ENDIF.
                IF sy-subrc = 0.
                  " Get the current Date & Time
                  GET TIME.
                  lv_date = sy-datum.   " Current date
                  lv_ctime = sy-uzeit.  " Current time
                  READ TABLE li_constants INTO lst_constant WITH KEY param1 = lc_wait_time. " BINARY SEARCH is not required as i_constants
                  IF sy-subrc = 0.                                                          " has very less data
                    lv_atime = lst_constant-low.
                    CLEAR lst_constant.
                  ELSE.
                    lv_atime = lc_atime.
                  ENDIF.
                  " Get the current time with addition of 5 mins
                  CALL FUNCTION 'C14B_ADD_TIME'
                    EXPORTING
                      i_starttime = lv_ctime
                      i_startdate = lv_date
                      i_addtime   = lv_atime
                    IMPORTING
                      e_endtime   = lv_ctime
                      e_enddate   = lv_date.
                  " FM Call to close the JOB
                  CALL FUNCTION 'JOB_CLOSE'
                    EXPORTING
                      jobcount             = lv_job_num
                      jobname              = lv_jobname
                      sdlstrtdt            = lv_date
                      sdlstrttm            = lv_ctime
                    EXCEPTIONS
                      cant_start_immediate = 1
                      invalid_startdate    = 2
                      jobname_missing      = 3
                      job_close_failed     = 4
                      job_nosteps          = 5
                      job_notex            = 6
                      lock_failed          = 7
                      OTHERS               = 8.
                  IF sy-subrc <> 0.
                    " Nothing to do
                  ENDIF.
                ENDIF. " IF sy-subrc = 0. Relevant to SUBMIT
              ENDIF. " IF sy-subrc = 0. Relevant to JOB_OPEN
            ENDIF. " IF sy-subrc = 0. Relevant to POPUP_TO_DISPALY_TEXT

            " Exit from the loop
            EXIT.
          ENDIF. " IF sy-subrc <> 0.
        ENDIF. " IF line_exists( li_constants[ param1 = lc_sales_org
        CLEAR lst_sales_area.
      ENDLOOP.

    ENDIF. " IF lv_bp_type = lc_person OR lv_bp_type = lc_organization.

  ENDIF. " IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
