*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SET_SHIPPING_PLAN_ATTR
* PROGRAM DESCRIPTION: Create Shipping plan via BADI
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   2016-12-27
* OBJECT ID: E139
* TRANSPORT NUMBER(S): ED2K903924
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K905514
* REFERENCE NO:  CR# 335
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-04-19
* DESCRIPTION: For digital media issues, the status should be Planned
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906881
* REFERENCE NO:  CR# 581
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-06-23
* DESCRIPTION: Use Initial Shipping Date for calculating Start Date for
*              Order Generation
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911624
* REFERENCE NO: ERP-7032
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  2018-03-27
* DESCRIPTION: Adjustment of contract start date and contract end date
*              for calendar year products
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917755
* REFERENCE NO:  ERPM1155
* DEVELOPER:   Nageswara
* DATE:  2020-03-10
* DESCRIPTION:Changes to Status of shipping planning
*----------------------------------------------------------------------*
* Type Declaration of Constant table   ED2K917755
TYPES:
  BEGIN OF lty_const,
    develpmnt_id TYPE zdevid,                                        "Development ID
    param1       TYPE rvari_vnam,                                    "ABAP: Name of Variant Variable
    param2       TYPE rvari_vnam,                                    "ABAP: Name of Variant Variable
    sign         TYPE tvarv_sign,                                    "ABAP: ID: I/E (include/exclude values)
    opti         TYPE tvarv_opti,                                    "ABAP: Selection option (EQ/BT/CP/...)
    low          TYPE salv_de_selopt_low,                            "Lower Value of Selection Condition
    high         TYPE salv_de_selopt_high,                           "Upper Value of Selection Condition
  END OF lty_const.

DATA:
  lv_issue_temp  TYPE matnr,                                         "Issue Template
  lv_st_planned  TYPE jnipstatus,                                    "Status of Shipping Planning: Planned
  lv_st_cr_ordrs TYPE jnipstatus,                                    "Status of Shipping Planning: Create Orders
  lv_st_ord_crtd TYPE jnipstatus,                                    "Status of Shipping Planning: Created Orders by NPOLINA ERPM1155 ED2K917755
  lv_st_ord_init TYPE jnipstatus.                                    "Status of Shipping Planning: Inital Orders by NPOLINA ERPM1155 ED2K917755

DATA:
  li_const       TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0,    "Constant Table
  lir_digt_issue TYPE rjksd_mtype_range_tab,                         "Range: Media Type - Digital
  lir_prnt_issue TYPE rjksd_mtype_range_tab.                         "Range: Media Type - Print

DATA:
  lst_issue_temp TYPE mara,                                          "General Material Data (Issue Template)
  lst_med_issue  TYPE mara,                                          "General Material Data (Media Issue)
  lst_shpng_sch  TYPE jksenip.                                       "Shipping Schedule Data (Issue Template)

CONSTANTS:
  lc_dev_id_e139 TYPE zdevid        VALUE 'E139',                    "Development ID
  lc_st_planned  TYPE rvari_vnam    VALUE 'PLANNED',                 "Name of Variant Variable-2 (Planned)
  lc_st_cr_ordrs TYPE rvari_vnam    VALUE 'CREATE_ORDERS',           "Name of Variant Variable-2 (Create Orders)
  lc_st_ord_crtd TYPE rvari_vnam    VALUE 'ORD_CREATED',           "Name of Variant Variable-2 (Created Orders) by NPOLINA ERPM1155 ED2K917755
  lc_st_ord_init TYPE rvari_vnam    VALUE 'ORD_INITIAL',           "Name of Variant Variable-2 (Created Orders) by NPOLINA ERPM1155 ED2K917755
  lc_shp_status  TYPE rvari_vnam    VALUE 'STATUS',                  "Name of Variant Variable-1 (Status)
  lc_digital_iss TYPE rvari_vnam    VALUE 'DIGITAL',                 "Name of Variant Variable-2 (Digital)
  lc_print_iss   TYPE rvari_vnam    VALUE 'PRINT',                   "Name of Variant Variable-2 (Print)
  lc_media_type  TYPE rvari_vnam    VALUE 'MEDIA_TYPE',              "Name of Variant Variable-1 (Media Type)
  lc_x           TYPE char01        VALUE 'X',                       "True/False +<HIPATEL> <ED2K911624> <ERP-7032>
  lc_startdt     TYPE char04        VALUE '0101',                    "Start date +<HIPATEL> <ED2K911624> <ERP-7032>
  lc_enddt       TYPE char04        VALUE '1231'.                    "End date   +<HIPATEL> <ED2K911624> <ERP-7032>

* Fetch IWiley Application Constant Table entries
SELECT devid                                                         "Development ID
       param1                                                        "ABAP: Name of Variant Variable
       param2                                                        "ABAP: Name of Variant Variable
       sign                                                          "ABAP: ID: I/E (include/exclude values)
       opti                                                          "ABAP: Selection option (EQ/BT/CP/...)
       low                                                           "Lower Value of Selection Condition
       high                                                          "Upper Value of Selection Condition
  FROM zcaconstant                                                   "Wiley Application Constant Table
  INTO TABLE li_const
 WHERE devid    EQ lc_dev_id_e139
   AND activate EQ abap_true.
IF sy-subrc IS INITIAL.
  SORT li_const BY develpmnt_id param1 param2.

  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_media_type.
        CASE <lst_const>-param2.
*         Media Type: Digital
          WHEN lc_digital_iss.
            APPEND INITIAL LINE TO lir_digt_issue ASSIGNING FIELD-SYMBOL(<lst_digt_iss>).
            <lst_digt_iss>-sign   = <lst_const>-sign.                "ID: I/E (include/exclude values)
            <lst_digt_iss>-option = <lst_const>-opti.                "Selection option (EQ/BT/CP/...)
            <lst_digt_iss>-low    = <lst_const>-low.                 "Lower Value of Selection Condition
            <lst_digt_iss>-high   = <lst_const>-high.                "Upper Value of Selection Condition
            UNASSIGN: <lst_digt_iss>.
*         Media Type: Print
          WHEN lc_print_iss.
            APPEND INITIAL LINE TO lir_prnt_issue ASSIGNING FIELD-SYMBOL(<lst_prnt_iss>).
            <lst_prnt_iss>-sign   = <lst_const>-sign.                "ID: I/E (include/exclude values)
            <lst_prnt_iss>-option = <lst_const>-opti.                "Selection option (EQ/BT/CP/...)
            <lst_prnt_iss>-low    = <lst_const>-low.                 "Lower Value of Selection Condition
            <lst_prnt_iss>-high   = <lst_const>-high.                "Upper Value of Selection Condition
            UNASSIGN: <lst_prnt_iss>.
        ENDCASE.

      WHEN lc_shp_status.
        CASE <lst_const>-param2.
*         Status of Shipping Planning: Planned
          WHEN lc_st_planned.
            lv_st_planned         = <lst_const>-low.                 "Lower Value of Selection Condition
*         Status of Shipping Planning: Create Orders
          WHEN lc_st_cr_ordrs.
            lv_st_cr_ordrs        = <lst_const>-low.                 "Lower Value of Selection Condition
* SOC by NPOLINA ERPM1155 ED2K917755
*         Status of Shipping Planning: Create Orders
          WHEN lc_st_ord_crtd.
            lv_st_ord_crtd        = <lst_const>-low.                 "Lower Value of Selection Condition
          WHEN lc_st_ord_init.
            lv_st_ord_init        = <lst_const>-low.                 "Lower Value of Selection Condition
* SOC by NPOLINA ERPM1155 ED2K917755
        ENDCASE.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

* Determine Issue Template
CALL FUNCTION 'ZQTC_DETERMINE_ISSUE_TEMPLATE'
  EXPORTING
    im_med_product         = product                                 "Media Product
  IMPORTING
    ex_issue_template      = lv_issue_temp                           "Issue Template
  EXCEPTIONS
    exc_temp_issue_missing = 1
    OTHERS                 = 2.
IF sy-subrc EQ 0.
* Fetch General Material Data of Issue Template
  CLEAR: lst_issue_temp.
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = lv_issue_temp                              "Issue Template
    IMPORTING
      wmara             = lst_issue_temp                             "General Material Data (Issue Template)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc NE 0.
    CLEAR: lst_issue_temp.
  ENDIF. " IF sy-subrc NE 0

* Fetch Shipping Schedule Data of Issue Template
  CLEAR: lst_shpng_sch.
  READ TABLE i_shipping_sch INTO lst_shpng_sch
       WITH KEY product = product                                    "Media Product
                issue   = lv_issue_temp                              "Issue Template
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   IS-M: Shipping Schedule
    SELECT *
      FROM jksenip                                                   "IS-M: Shipping Schedule
      INTO lst_shpng_sch
     UP TO 1 ROWS
     WHERE product EQ product                                        "Media Product
       AND issue   EQ lv_issue_temp.                                 "Issue Template
    ENDSELECT.
    IF sy-subrc NE 0.
      lst_shpng_sch-product = product.                               "Media Product
      lst_shpng_sch-issue   = lv_issue_temp.                         "Issue Template
    ENDIF. " IF sy-subrc NE 0

    APPEND lst_shpng_sch TO i_shipping_sch.
    SORT i_shipping_sch BY product issue.
  ENDIF. " IF sy-subrc NE 0

* Fetch General Material Data of Media Issue
  CLEAR: lst_med_issue.
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = issue                                      "Media Issue (L-3)
    IMPORTING
      wmara             = lst_med_issue                              "General Material Data (Media Issue)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc NE 0.
    CLEAR: lst_med_issue.
  ENDIF. " IF sy-subrc NE 0
ENDIF. " IF sy-subrc EQ 0

IF lst_issue_temp IS NOT INITIAL AND
   lst_shpng_sch  IS NOT INITIAL AND
   lst_med_issue  IS NOT INITIAL.
* IS-M: Start Date for Order Generation
* Begin of DEL:CR#581:WROY:23-JUN-2017:ED2K906881
* gen_start_date  = lst_med_issue-ismpubldate -                      "Publication Date of the Media Issue
*                 ( lst_issue_temp-ismpubldate -                     "Publication Date of the Issue Template
* End   of DEL:CR#581:WROY:23-JUN-2017:ED2K906881
* Begin of ADD:CR#581:WROY:23-JUN-2017:ED2K906881
  gen_start_date  = lst_med_issue-isminitshipdate -                  "Initial Shipping Date
                  ( lst_issue_temp-isminitshipdate -                 "Initial Shipping Date
* End   of ADD:CR#581:WROY:23-JUN-2017:ED2K906881
                    lst_shpng_sch-gen_start_date ).                  "Start Date for Order Generation of the Issue Template

* IS-M: End Date for Order Generation
  gen_end_date    = c_end_date.

*Start insert by <HIPATEL> <ED2K911624> <ERP-7032> <3/27/2018>
  SELECT SINGLE matnr,    "Media Product(Material Number)
                prat1     "ID for product attribute 1
    INTO @DATA(lst_mvke)
    FROM mvke             "Material Sales organization data
    WHERE matnr EQ @lst_shpng_sch-product
      AND prat1 EQ @lc_x.
  IF sy-subrc = 0.
    IF lst_med_issue-ismpubldate+0(4) GT lst_med_issue-ismyearnr.
      CONCATENATE lst_med_issue-ismyearnr lc_enddt INTO lst_med_issue-ismpubldate.
    ELSEIF lst_med_issue-ismpubldate+0(4) LT lst_med_issue-ismyearnr.
      CONCATENATE lst_med_issue-ismyearnr lc_startdt INTO lst_med_issue-ismpubldate.
    ENDIF.
  ENDIF.
*End insert by <HIPATEL> <ED2K911624> <ERP-7032> <3/27/2018>
* IS-M: Subscription Valid From
  sub_valid_from  = lst_med_issue-ismpubldate.                       "Publication Date of the Media Issue

* IS-M: Subscription Valid To
  sub_valid_until = lst_med_issue-ismpubldate.                       "Publication Date of the Media Issue

* IS-M: Status of Shipping Planning
  IF lst_med_issue-ismmediatype IN lir_digt_issue.                   "Digital Issue
*   status        = lv_st_cr_ordrs.                                  "Status: Create Orders
    status        = lv_st_planned.           "ERPM1135 NPOLINA      "Status: Planned

*  Logic for Degital media ERPM1155
* SOC by NPOLINA ED2K917755 ERPM1155
    IF lst_med_issue-ismissuetypest = '01' .
      status        = lv_st_planned.   "01 Planned
    ELSEIF lst_med_issue-ismissuetypest = '02' .
      status      =  lv_st_ord_init. "'00'.          " Order Initial
    ENDIF.
* EOC by NPOLINA ED2K917755 ERPM1155
  ENDIF. " IF lst_med_issue-ismmediatype EQ lv_dig_issue


  IF lst_med_issue-ismmediatype IN lir_prnt_issue.                   "Print Issue
    IF lst_med_issue-ismpubldate LT sy-datum.
      status      = lv_st_cr_ordrs.                                  "Status: Create Orders
    ELSE. " ELSE -> IF lst_med_issue-ismpubldate LT sy-datum
      status      = lv_st_planned.                                   "Status: Planned
    ENDIF. " IF lst_med_issue-ismpubldate LT sy-datum
*  Logic for Print media ERPM1155
* SOC by NPOLINA ED2K917755 ERPM1155
    IF lst_med_issue-ismissuetypest = '01' AND lst_med_issue-ismpubldate LT sy-datum.
      status      = lv_st_cr_ordrs.   "'02'. create Order
    ELSEIF lst_med_issue-ismissuetypest = '01' AND lst_med_issue-ismpubldate GT sy-datum.
      status      =  lv_st_planned. "'01'. Planned
    ELSEIF lst_med_issue-ismissuetypest = '02' .
      status      = lv_st_ord_init. "'00'. Order Initial
    ENDIF.
* EOC by NPOLINA ED2K917755 ERPM1155
  ENDIF. " IF lst_med_issue-ismmediatype EQ lv_print_issue
ENDIF. " IF lst_issue_tmp IS NOT INITIAL AND
