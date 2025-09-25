*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_REDET_RENEWAL_PROF_SEL
* PROGRAM DESCRIPTION: Include contains Form Sub routines
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-21
* OBJECT ID:E095 (CR# ERP-6293)
* TRANSPORT NUMBER(S): ED2K912365
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K912856
* REFERENCE NO: ERP-6293/7606
* DEVELOPER: Writtick Roy (WROY)
* DATE: 01-AUG-2018
* DESCRIPTION: Filter records based on missing Selection criteria
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912771
* REFERENCE NO: ERP-6343
* DEVELOPER: Writtick Roy
* DATE:  07-AUG-2018
* DESCRIPTION: Do not consider the Line Item, if CQ (Create Quotation)
*              activity is already Completed and the assigned Renewal
*              Profile is applicable for Consolidation
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED1K909654
* REFERENCE NO: INC0230765
* DEVELOPER:PRABHU
* DATE:2/20/2019
* DESCRIPTION:Licence group and action of contract on output
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K914529
* REFERENCE NO: DM1916
* DEVELOPER:PRABHU
* DATE:7/12/2019
* DESCRIPTION:Added new fields of renwals to select query to avoid dump
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANT_TABLE

*&---------------------------------------------------------------------*
*&      Form  F_ORDER
*&---------------------------------------------------------------------*
*       Validate Order number
*----------------------------------------------------------------------*

FORM f_validate_order .
  IF s_vbeln[] IS NOT INITIAL  .
    SELECT vbeln " Sales order
      FROM vbak  " Sales Document: Header Data
      UP TO 1 ROWS
      INTO v_vbeln
      WHERE
      vbeln IN s_vbeln.
    ENDSELECT.
    IF sy-subrc <> 0.
      MESSAGE e014(61) . "WITH text-001.

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF s_vbeln[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SALES_ORG
*&---------------------------------------------------------------------*
*       Validate selection screen Sales organisation details
*----------------------------------------------------------------------*

FORM f_validate_sales_org .

  IF s_vkorg[] IS INITIAL.
    RETURN.
  ENDIF. " IF s_vkorg[] IS INITIAL

* Organizational Unit: Sales Organizations
  SELECT vkorg " Sales Organization
    FROM tvko  " Organizational Unit: Sales Organizations
   UP TO 1 ROWS
    INTO @DATA(lv_vkorg)
   WHERE vkorg IN @s_vkorg.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Sales Organization Number!
    MESSAGE e012(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Preapre Field Catelouge for processing
*----------------------------------------------------------------------*
*      <--FP_I_FCAT  ALV Field Catelouge Table
*----------------------------------------------------------------------*
FORM f_build_field_catalog CHANGING fp_i_fcat TYPE slis_t_fieldcat_alv.
*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname             TYPE slis_tabname VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln           TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_posnr           TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_werks           TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_matnr           TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_mvgr5           TYPE slis_fieldname VALUE 'MVGR5',
             lc_fld_license_grp     TYPE slis_fieldname VALUE 'LICENSE_GRP',
             lc_fld_subs_type       TYPE slis_fieldname VALUE 'SUBS_TYPE',
             lc_fld_bsark           TYPE slis_fieldname VALUE 'BSARK',
             lc_fld_vkorg           TYPE slis_fieldname VALUE 'VKORG',
             lc_fld_sales_office    TYPE slis_fieldname VALUE 'SALES_OFFICE',
             lc_fld_kdgrp           TYPE slis_fieldname VALUE 'KDGRP',
             lc_fld_konda           TYPE slis_fieldname VALUE 'KONDA',
             lc_fld_pay_type        TYPE slis_fieldname VALUE 'PAY_TYPE',
             lc_fld_kdkg2           TYPE slis_fieldname VALUE 'KDKG2',
             lc_fld_zzaction        TYPE slis_fieldname VALUE 'ZZACTION',
             lc_fld_renwl_prof      TYPE slis_fieldname VALUE 'RENWL_PROF',
             lc_fld_renwl_prof_new  TYPE slis_fieldname VALUE 'RENWL_PROF_NEW',
             lc_fld_message         TYPE slis_fieldname VALUE 'MESSAGE',
             lc_fld_sold_to_country TYPE slis_fieldname VALUE 'SOLD_TO_COUNTRY',
             lc_fld_ship_to_country TYPE slis_fieldname VALUE 'SHIP_TO_COUNTRY',
             lc_fld_ship_to         TYPE slis_fieldname VALUE 'SHIP_TO',
             lc_fld_sold_to         TYPE slis_fieldname VALUE 'SOLD_TO'.

  lv_col_pos         = 0 .
* Populate field catalog

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Sales Document'(001)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Document Item'(002)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_vkorg  lc_tabname   lv_col_pos  'Sales Organisation'(003)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ship_to  lc_tabname   lv_col_pos  'Ship To Party'(029)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sold_to  lc_tabname   lv_col_pos  'Sold To Party'(030)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(004)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Material Number'(005)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mvgr5  lc_tabname   lv_col_pos  'Material Group 5'(006)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_license_grp  lc_tabname   lv_col_pos  'License Group(Header)'(007)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_subs_type  lc_tabname   lv_col_pos  'Subscription Type'(008)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_bsark  lc_tabname   lv_col_pos  'Customer PO Order typ'(009)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sales_office  lc_tabname   lv_col_pos  'Sales office'(010)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_kdgrp  lc_tabname   lv_col_pos  'Customer Group'(011)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_konda  lc_tabname   lv_col_pos  'Price Group'(012)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_pay_type  lc_tabname   lv_col_pos  'Payment Method'(013)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_kdkg2  lc_tabname   lv_col_pos  'Customer Cond. grp 2'(014)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zzaction  lc_tabname   lv_col_pos  'Action at end of Contract(Header)'(015)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sold_to_country  lc_tabname   lv_col_pos  'Sold To Country'(016)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ship_to_country  lc_tabname   lv_col_pos  'Ship To Country'(017)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_renwl_prof  lc_tabname   lv_col_pos  'Renewal Profile'(018)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_renwl_prof_new  lc_tabname   lv_col_pos  'Renewal Profile New'(019)
                       CHANGING fp_i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_message  lc_tabname   lv_col_pos  'Message'(020)
                       CHANGING fp_i_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Built ALV feild catelouge
*----------------------------------------------------------------------*
*      -->FP_FIELD    Field Name
*      -->FP_TABNAME  ALV display Table Name
*      -->FP_COL_POS  Column Position
*      -->FP_text    Column Text
*      <--FP_I_FCAT  Field Catelouge table
*----------------------------------------------------------------------*
FORM f_build_fcat          USING fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.
  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30', " Output Length
              lc_fld_vbeln TYPE slis_fieldname VALUE 'VBELN'.

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  IF fp_field EQ lc_fld_vbeln.
    lst_fcat-hotspot     = abap_true.
  ENDIF. " IF fp_field EQ lc_fld_vbeln
*--*BOC INC0230765 PRABHU ED1K909654 2/20/2019
  lst_fcat-seltext_l   = fp_text.
*--*EOC INC0230765 PRABHU ED1K909654 2/20/2019
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV Report
*----------------------------------------------------------------------*
*      -->FP_I_FCAT  Field Cat. Table
*      -->FP_I_FINAL Final data internal Table
*----------------------------------------------------------------------*
FORM f_display_alv  USING    fp_i_fcat TYPE slis_t_fieldcat_alv
                             fp_i_final TYPE tt_final.

  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',
              lc_box_sel     TYPE slis_fieldname VALUE 'SEL'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(021).

  DATA: lst_layout   TYPE slis_layout_alv.

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
  lst_layout-box_fieldname      = lc_box_sel.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = fp_i_fcat
      i_save                   = abap_true
    TABLES
      t_outtab                 = fp_i_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab. "#EC CALLED

  DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
  SET PF-STATUS 'ZQTC_REDET_PF_STATUS'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Redetermine Renewal Profile'(022).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm            " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield. "#EC CALLED

  DATA : li_bdcdata  TYPE TABLE OF bdcdata, " Batch input: New table field structure
         lst_bdcdata TYPE bdcdata.          " Batch input: New table field structure

  CONSTANTS:              lc_process    TYPE syst_ucomm     VALUE '&PROCESS', " ABAP System Field: PAI-Triggering Function Code
                          lc_rfresh     TYPE syst_ucomm     VALUE '&REFRESH', " ABAP System Field: PAI-Triggering Function Code
                          lc_click      TYPE syst_ucomm     VALUE '&IC1',     " ABAP System Field: PAI-Triggering Function Code
                          lc_fldname    TYPE char10         VALUE 'VBELN',    " Fldname of type CHAR10
                          lc_mode       TYPE char01         VALUE 'E',        " Mode of type CHAR01
                          lc_tcode_va43 TYPE sytcode        VALUE 'VA43'.     " Transaction Code

  CASE fp_ucomm.

* Process the selected Line items to re-determine the Profile and related
*activities
    WHEN lc_process.

      PERFORM process_redet_profile USING i_veda_data
                                          i_renewal_det
                                          i_renewal_plan
* Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
                                          i_renwl_p_det
* End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
                                   CHANGING i_final.

      fp_lst_selfield-refresh = abap_true.

**Refresh ALV display to update the latest records
    WHEN lc_rfresh.
      fp_lst_selfield-refresh = abap_true.

* Open the subscription document in VA43 when user Click on document Number.
    WHEN lc_click.

      CLEAR: li_bdcdata[].

      IF fp_lst_selfield-fieldname = lc_fldname.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '0102'.
        lst_bdcdata-dynbegin = abap_true.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/00'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-VBELN'.
        lst_bdcdata-fval  = fp_lst_selfield-value.
        APPEND lst_bdcdata TO li_bdcdata.

        CALL TRANSACTION lc_tcode_va43
              USING li_bdcdata
              MODE lc_mode.

      ENDIF. " IF fp_lst_selfield-fieldname = lc_fldname

    WHEN OTHERS.
* DO nothing

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_HDR_ITM_DETAILS
*&---------------------------------------------------------------------*
*       Fetch Order header / item/ partner details for processing
*----------------------------------------------------------------------*
*      <--FP_I_HDR_ITM_DATA  Order details and item details
*      <--FP_I_RENEWAL_PLAN  Renewal Plan table
*      <--FP_I_VBPA_DATA     Order Partner data
*      <--FP_I_VEDA_DATA     VEDA data
*      <--FP_I_VBKD_DATA     Order VBKD_data
*----------------------------------------------------------------------*
FORM f_fetch_hdr_itm_details  USING    fp_i_constant TYPE tt_constant
                              CHANGING fp_i_hdr_itm_data TYPE tt_hdr_itm_data
                                       fp_i_renewal_plan TYPE tt_renewal_plan
                                       fp_i_vbpa_data    TYPE tt_vbpa_data
                                       fp_i_veda_data    TYPE tt_veda_data
                                       fp_i_vbkd_data    TYPE tt_vbkd_data.


  CONSTANTS :  lc_contract TYPE vbak-vbtyp    VALUE 'G',       " Contract
               lc_pstyv    TYPE rvari_vnam VALUE 'PSTYV',      "Item Category
               lc_mtart_j  TYPE rvari_vnam VALUE 'MTART_JRNL'. "Material Type: Journal Media Product

  DATA :      li_hdr_itm_data  TYPE tt_hdr_itm_data,
              lir_pstyv_range  TYPE STANDARD TABLE OF /spe/pstyv_range, " Structure for Ranges Table for item category
              lst_pstyv_range  TYPE /spe/pstyv_range,                   " Structure for Ranges Table for item category
              lr_mat_type_jrnl TYPE md_range_t_mtart,                   " Range Table for Material Type
              lst_constant     TYPE ty_constant.

**populate the range table for PSTYV and Material Type JRNL.
  LOOP AT fp_i_constant INTO lst_constant.

    IF lst_constant-param1 = lc_pstyv.
      lst_pstyv_range-sign = lst_constant-sign.
      lst_pstyv_range-option = lst_constant-opti.
      lst_pstyv_range-low = lst_constant-low.
      lst_pstyv_range-high = lst_constant-high.
      APPEND lst_pstyv_range TO lir_pstyv_range.
      CLEAR: lst_pstyv_range,lst_constant.
    ENDIF. " IF lst_constant-param1 = lc_pstyv

    IF lst_constant-param1 = lc_mtart_j.
      APPEND INITIAL LINE TO lr_mat_type_jrnl ASSIGNING FIELD-SYMBOL(<lst_mat_type>). " Range Table for Material Type
      <lst_mat_type>-sign   = lst_constant-sign.
      <lst_mat_type>-option = lst_constant-opti.
      <lst_mat_type>-low    = lst_constant-low.
      <lst_mat_type>-high   = lst_constant-high.
    ENDIF. " IF lst_constant-param1 = lc_mtart_j

  ENDLOOP. " LOOP AT fp_i_constant INTO lst_constant


**Fetch VBAK / VBAP data based on selection screen data
  SELECT a~vbeln    " Sales Document
         a~posnr    " Sales Document Item
         a~matnr    " Material Number
         a~pstyv    " Sales document item category
         a~uepos    " Higher-level item in bill of material structures
         a~werks    " Plant (Own or External)
         a~mvgr5    " Material group 5
         a~zzsubtyp " Subscription Type
         b~vkorg    " Sales Organization
         b~bsark    " Customer purchase order type
         b~vkbur    " Sales Office
         b~zzlicgrp " License Group
         FROM vbap AS a INNER JOIN vbak AS b
         ON a~vbeln = b~vbeln
         INNER JOIN mara AS c
         ON a~matnr = c~matnr
         INTO TABLE fp_i_hdr_itm_data
         WHERE a~vbeln IN s_vbeln
           AND a~matnr IN s_matnr
           AND a~werks IN s_werks
           AND a~mvgr5 IN s_mvgr5
           AND a~zzsubtyp IN s_subtyp
           AND b~erdat IN s_erdat
           AND b~auart IN s_auart
           AND b~vkorg IN s_vkorg
           AND b~vbtyp EQ  lc_contract
           AND c~mtart IN lr_mat_type_jrnl.

  IF sy-subrc EQ 0.

    DELETE fp_i_hdr_itm_data WHERE ( uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range ).

    SORT fp_i_hdr_itm_data BY vbeln posnr.
    li_hdr_itm_data = fp_i_hdr_itm_data.

    DELETE ADJACENT DUPLICATES FROM li_hdr_itm_data
        COMPARING vbeln posnr.

  ELSE. " ELSE -> IF sy-subrc EQ 0

    MESSAGE i000(zqtc_r2) WITH 'No records Selected for processing'. " & & & &
    LEAVE LIST-PROCESSING.

  ENDIF. " IF sy-subrc EQ 0

  IF li_hdr_itm_data IS NOT INITIAL.

*Fetch the partner details for sold to party and ship to party
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           parvw " Partner Function
           kunnr " Customer Number
           land1 " Country Key
      FROM vbpa  " Sales Document: Partner
      INTO TABLE fp_i_vbpa_data
      FOR ALL ENTRIES IN li_hdr_itm_data
      WHERE vbeln = li_hdr_itm_data-vbeln
        AND ( posnr = li_hdr_itm_data-posnr
         OR posnr = c_posnr_low )
        AND parvw IN (c_sold_to, c_ship_to).

    IF sy-subrc EQ 0.

      SORT fp_i_vbpa_data BY vbeln posnr parvw.

    ENDIF. " IF sy-subrc EQ 0


    SELECT vbeln   " Sales Document
           vposn   " Sales Document Item
           vaktsch " Action at end of contract
           venddat " Contract end date
      FROM veda    " Contract Data
      INTO TABLE fp_i_veda_data
      FOR ALL ENTRIES IN li_hdr_itm_data
      WHERE vbeln EQ li_hdr_itm_data-vbeln
        AND ( vposn = li_hdr_itm_data-posnr
         OR vposn = c_posnr_low ).

    IF sy-subrc EQ 0.

      SORT fp_i_veda_data BY vbeln vposn.

    ENDIF. " IF sy-subrc EQ 0

**Fetch VBKD data
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           konda " Price group (customer)
           kdgrp " Customer group
           zlsch " Payment Method
           bsark " Customer purchase order type
           kdkg2 " Customer condition group 2
      FROM vbkd  " Sales Document: Business Data
      INTO TABLE fp_i_vbkd_data
      FOR ALL ENTRIES IN li_hdr_itm_data
      WHERE vbeln EQ li_hdr_itm_data-vbeln
        AND ( posnr EQ li_hdr_itm_data-posnr
         OR posnr EQ c_posnr_low ).

    IF sy-subrc EQ 0.

      SORT fp_i_vbkd_data BY vbeln posnr.

    ENDIF. " IF sy-subrc EQ 0

**fetch the Renewal Plan as selection criteria
    SELECT  mandt                " Client
            vbeln                " Sales Document
            posnr                " Item
            activity             " E095: Activity
            matnr                " Material no
            eadat                " Activity Date
            renwl_prof           " Renewal Profile
            promo_code           " Promo code
            act_status           " Activity Status
            ren_status           " Renewal Status
            excl_resn            " Exclusion_reason
            excl_date            " Exclusion Date
*--*BOC Prabhu for DM1916 ED2K914529 7/11/2019
            excl_resn2          " Exclusion_reason2
            excl_date2          " Exclusion Date 2
            other_cmnts         " Other_cmnts
*--*EOC Prabhu for DM1916 ED2K914529 7/11/2019
            aenam                " Name of Person Who Changed Object
            aedat                " Changed On
            aezet                " Time last change was made
            FROM zqtc_renwl_plan " E095: Renewal Plan Table
            INTO TABLE fp_i_renewal_plan
            FOR ALL ENTRIES IN li_hdr_itm_data
            WHERE vbeln EQ li_hdr_itm_data-vbeln
            AND posnr EQ li_hdr_itm_data-posnr
            AND renwl_prof IN s_prof.


    IF sy-subrc EQ 0.

*     Begin of DEL:ERP-6343:WROY:07-AUG-2018:ED2K912771
*     SORT fp_i_renewal_plan BY vbeln posnr activity act_status.
*     Begin of DEL:ERP-6343:WROY:07-AUG-2018:ED2K912771
*     Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
      SORT fp_i_renewal_plan BY vbeln posnr activity act_status ren_status.
*     End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771

    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF li_hdr_itm_data IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RENEWAL_DET_DETAILS
*&---------------------------------------------------------------------*
*       Fetch Renewnal Profile determination profile details
*----------------------------------------------------------------------*
*      <--P_I_RENEWAL_DET  text
*      <--P_I_PAY_KEY_TYP  text
*----------------------------------------------------------------------*
FORM f_fetch_renewal_det_details  CHANGING fp_i_renewal_det TYPE tt_renewal_det
                                           fp_i_pay_key_typ TYPE tt_pay_key_typ
                                           fp_i_renwl_p_det TYPE tt_renwl_p_det
                                           fp_i_notif_p_det TYPE tt_notif_p_det.

  DATA : li_renewal_det_t TYPE tt_renewal_det,
         li_notif_p_det_t TYPE tt_notif_p_det,
         lr_notif_p_det   TYPE REF TO ty_notif_p_det, " Notif_p_det class
         lr_renwl_p_det   TYPE REF TO ty_renwl_p_det. " Renwl_p_det class


  CREATE DATA : lr_notif_p_det,
                lr_renwl_p_det.

*     Mapping between Payment Method to Payment Type
*     [Only 3 fields are there in the table and 2 are going to be used]
  SELECT *
    FROM zqtc_pay_key_typ " E095: Map Payment Method to Payment Type
    INTO TABLE fp_i_pay_key_typ.
  IF sy-subrc EQ 0.
    SORT fp_i_pay_key_typ BY zlsch.
  ENDIF. " IF sy-subrc EQ 0

  SELECT  kdgrp           " Customer group
          konda           " Price group (customer)
          pay_type        " Payment Type
          sold_to_country " Sold To Country
          ship_to_country " Ship To Country
          license_grp     " Licence Group(Y/N)
          sales_office    " Sales Office
          subs_type       " Subscription Type
          kdkg2           " Customer condition group 2
          mvgr5           " Material group 5
          bsark           " Customer purchase order type
          vkorg           " Sales Organization
          werks           " Plant
          matnr           " Matnr
          zzaction        " Action
          renwl_prof      " renewal profile
  FROM zqtc_rp_deter      " E095: Renewal Profile Determination Table
  INTO TABLE fp_i_renewal_det.

  IF sy-subrc EQ 0.

    li_renewal_det_t = fp_i_renewal_det.

    SORT li_renewal_det_t BY renwl_prof.

    DELETE ADJACENT DUPLICATES FROM li_renewal_det_t COMPARING renwl_prof.

    SELECT  renwl_prof   " Renewal Profile
            quote_time   " Quote Timing
            notif_prof   " Notification Profile
            grace_start  " Grace Start Timing
            grace_period " Grace Period
            auto_renew   " Auto Renew Timing
            lapse        " Lapse
*           Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
            consolidate " Consolidated Renewals
*           End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
      FROM zqtc_renwl_p_det " E095: Renewal Profile Details Table
      INTO TABLE fp_i_renwl_p_det
      FOR ALL ENTRIES IN li_renewal_det_t
      WHERE renwl_prof = li_renewal_det_t-renwl_prof
*     Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
      ORDER BY PRIMARY KEY.
*     End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
    IF sy-subrc = 0.

      LOOP AT fp_i_renwl_p_det REFERENCE INTO lr_renwl_p_det WHERE notif_prof IS NOT INITIAL .
        lr_notif_p_det->notif_prof = lr_renwl_p_det->notif_prof.
        APPEND lr_notif_p_det->* TO li_notif_p_det_t.
        CLEAR: lr_notif_p_det->*.
      ENDLOOP. " LOOP AT fp_i_renwl_p_det REFERENCE INTO lr_renwl_p_det WHERE notif_prof IS NOT INITIAL

      DELETE ADJACENT DUPLICATES FROM li_notif_p_det_t COMPARING notif_prof.
      SELECT   notif_prof     " Notification Profile
               notif_rem      " Notification/Reminder
               rem_in_days    " Notification Reminder (in Days)
               promo_code     " Promo code
        FROM zqtc_notif_p_det " E095: Notification Profile Details Table
        INTO TABLE fp_i_notif_p_det
        FOR ALL ENTRIES IN li_notif_p_det_t
        WHERE notif_prof = li_notif_p_det_t-notif_prof.
      IF sy-subrc = 0.
*& DO nothing
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL_TABLE
*&---------------------------------------------------------------------*
*       Populate the FInal Table for processing
*----------------------------------------------------------------------*
*      -->FP_I_HDR_ITM_DATA  Internal table for Header and Item data
*      -->FP_I_RENEWAL_PLAN  Internal Table for Renewal Plan data
*      -->FP_I_VBPA_DATA    Internal table for partner details
*      -->FP_I_PAY_KEY_TYP  Internal Table for Pay key mapping
*      <--FP_I_FINAL  Final Data Table
*----------------------------------------------------------------------*
FORM f_populate_final_table  USING    fp_i_hdr_itm_data TYPE tt_hdr_itm_data
                                      fp_i_renewal_plan TYPE tt_renewal_plan
                                      fp_i_vbpa_data TYPE tt_vbpa_data
                                      fp_i_pay_key_typ TYPE tt_pay_key_typ
                                      fp_i_veda_data TYPE tt_veda_data
                                      fp_i_vbkd_data TYPE tt_vbkd_data
                             CHANGING fp_i_final TYPE tt_final.


**Populate final internal table for ALV display and futher processing
  IF fp_i_hdr_itm_data IS NOT INITIAL.

    LOOP AT fp_i_hdr_itm_data ASSIGNING FIELD-SYMBOL(<lst_hdr_itm_data>).

      APPEND INITIAL LINE TO fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>).

      <lst_final>-vbeln = <lst_hdr_itm_data>-vbeln.
      <lst_final>-posnr = <lst_hdr_itm_data>-posnr.
      <lst_final>-werks = <lst_hdr_itm_data>-werks.
      <lst_final>-matnr = <lst_hdr_itm_data>-matnr.
      <lst_final>-mvgr5 = <lst_hdr_itm_data>-mvgr5.
      <lst_final>-vkorg = <lst_hdr_itm_data>-vkorg.
      CASE <lst_hdr_itm_data>-subs_type.
        WHEN space.
          <lst_final>-subs_type = c_rolng_yr. "Rolling Year
        WHEN OTHERS.
          <lst_final>-subs_type = c_clndr_yr. "Calendar Year
      ENDCASE.

      <lst_final>-sales_office = <lst_hdr_itm_data>-vkbur.

      READ TABLE i_vbkd_data ASSIGNING FIELD-SYMBOL(<lst_vbkd_data>)
                                    WITH KEY vbeln = <lst_final>-vbeln
                                             posnr = <lst_final>-posnr
                                    BINARY SEARCH.
      IF sy-subrc NE 0.

        READ TABLE i_vbkd_data ASSIGNING <lst_vbkd_data>
                                      WITH KEY vbeln = <lst_final>-vbeln
                                               posnr = c_posnr_low
                                      BINARY SEARCH.

      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0
     AND <lst_vbkd_data> IS ASSIGNED.

        <lst_final>-bsark = <lst_vbkd_data>-bsark.
        <lst_final>-kdgrp = <lst_vbkd_data>-kdgrp.
        <lst_final>-konda = <lst_vbkd_data>-konda.
        <lst_final>-kdkg2 = <lst_vbkd_data>-kdkg2.
        <lst_final>-pay_type = <lst_vbkd_data>-pay_type.

**Get the payment Key for all details
        READ TABLE fp_i_pay_key_typ ASSIGNING FIELD-SYMBOL(<lst_pay_key_typ>)
                  WITH KEY zlsch = <lst_vbkd_data>-pay_type.
        IF sy-subrc NE 0.

          READ TABLE fp_i_pay_key_typ ASSIGNING <lst_pay_key_typ>
                    WITH KEY zlsch = space.

        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0
      AND <lst_pay_key_typ> IS ASSIGNED.

          <lst_final>-pay_type = <lst_pay_key_typ>-zpay_type.

        ENDIF. " IF sy-subrc EQ 0

        IF <lst_final>-bsark IS INITIAL.

          <lst_final>-bsark = <lst_hdr_itm_data>-bsark_ak.

        ENDIF. " IF <lst_final>-bsark IS INITIAL

      ENDIF. " IF sy-subrc EQ 0
**check if License group is present then set the flag as 'X'
      IF <lst_hdr_itm_data>-zzlicgrp IS NOT INITIAL.
        <lst_final>-license_grp = abap_true.
      ENDIF. " IF <lst_hdr_itm_data>-zzlicgrp IS NOT INITIAL
* Get the Ship to party country Key

      READ TABLE fp_i_vbpa_data ASSIGNING FIELD-SYMBOL(<lst_vbpa_data>)
               WITH KEY vbeln = <lst_final>-vbeln
                        posnr = <lst_final>-posnr
                        parvw = c_ship_to
                BINARY SEARCH.
      IF sy-subrc NE 0.

        READ TABLE fp_i_vbpa_data ASSIGNING <lst_vbpa_data>
                 WITH KEY vbeln = <lst_final>-vbeln
                          posnr = c_posnr_low
                          parvw = c_ship_to
                  BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0

      IF sy-subrc EQ 0
    AND <lst_vbpa_data> IS ASSIGNED.

        <lst_final>-ship_to_country = <lst_vbpa_data>-land1.
        <lst_final>-ship_to  = <lst_vbpa_data>-kunnr.
        UNASSIGN <lst_vbpa_data>.

      ENDIF. " IF sy-subrc EQ 0


* Get Sold To Party Country key
      READ TABLE fp_i_vbpa_data ASSIGNING FIELD-SYMBOL(<lst_vbpa_data1>)
               WITH KEY vbeln = <lst_final>-vbeln
                        posnr = c_posnr_low
                        parvw = c_sold_to
                BINARY SEARCH.
      IF sy-subrc EQ 0
    AND <lst_vbpa_data1> IS ASSIGNED.

        <lst_final>-sold_to_country = <lst_vbpa_data1>-land1.
        <lst_final>-sold_to  = <lst_vbpa_data1>-kunnr.
        UNASSIGN <lst_vbpa_data1>.
      ENDIF. " IF sy-subrc EQ 0



*Get the Existing Renewal Profile assigned to Subscription document and line item
      READ TABLE fp_i_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)
                  WITH KEY vbeln = <lst_final>-vbeln
                           posnr = <lst_final>-posnr
                  BINARY SEARCH.
      IF sy-subrc EQ 0
     AND <lst_renewal_plan> IS ASSIGNED.

        <lst_final>-renwl_prof = <lst_renewal_plan>-renwl_prof.

      ENDIF. " IF sy-subrc EQ 0

**Read the Action at end of contract date value from VEDA table
*--*BOC INC0230765 PRABHU ED1K909654 2/20/2019
*--* Get action from header always
*      READ TABLE fp_i_veda_data ASSIGNING FIELD-SYMBOL(<lst_veda_data>)
*           WITH KEY vbeln = <lst_final>-vbeln
*                    vposn = <lst_final>-posnr
*           BINARY SEARCH.
*      IF sy-subrc NE 0.
        READ TABLE fp_i_veda_data ASSIGNING FIELD-SYMBOL(<lst_veda_data>)
                WITH KEY vbeln = <lst_final>-vbeln
                         vposn = c_posnr_low
                BINARY SEARCH.
*      ENDIF. " IF sy-subrc NE 0
*--*EOC INC0230765 PRABHU ED1K909654 2/20/2019
      IF sy-subrc EQ 0
     AND <lst_veda_data> IS ASSIGNED.

        <lst_final>-zzaction = <lst_veda_data>-vaktsch.

      ENDIF. " IF sy-subrc EQ 0

    ENDLOOP. " LOOP AT fp_i_hdr_itm_data ASSIGNING FIELD-SYMBOL(<lst_hdr_itm_data>)

*Delete the final internal table based on selection screen paramters
    DELETE fp_i_final WHERE pay_type NOT IN s_paytyp.
    DELETE fp_i_final WHERE ship_to_country NOT IN s_shcoun.
    DELETE fp_i_final WHERE sold_to_country NOT IN s_socoun.
    DELETE fp_i_final WHERE zzaction NOT IN s_action.
    DELETE fp_i_final WHERE ship_to NOT IN s_shipto.
    DELETE fp_i_final WHERE sold_to NOT IN s_soldto.
    DELETE fp_i_final WHERE bsark NOT IN s_bsark.
    DELETE fp_i_final WHERE kdgrp NOT IN s_kdgrp.
    DELETE fp_i_final WHERE konda NOT IN s_konda.
    DELETE fp_i_final WHERE kdkg2 NOT IN s_kdkg2.
*   Begin of ADD:ERP-6293/7606:WROY:01-AUG-2018:ED2K912856
    DELETE fp_i_final WHERE license_grp  NOT IN s_licgrp.
    DELETE fp_i_final WHERE sales_office NOT IN s_office.
    DELETE fp_i_final WHERE renwl_prof   NOT IN s_prof.
*   End   of ADD:ERP-6293/7606:WROY:01-AUG-2018:ED2K912856

  ENDIF. " IF fp_i_hdr_itm_data IS NOT INITIAL

  IF fp_i_final IS INITIAL.

    MESSAGE i000(zqtc_r2) WITH 'No records Selected for processing'. " & & & &
    LEAVE LIST-PROCESSING.

  ENDIF. " IF fp_i_final IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_REDET_PROFILE
*&---------------------------------------------------------------------*
*      Re-Determine the Renewal Profile and related activites to update
*      Renewal Plan Table
*----------------------------------------------------------------------*
*      -->FP_I_VEDA_DATA  Internal table for VEDA entries
*      -->FP_I_RENEWAL_DET  Internal table for Renewal Profile Det
*      -->FP_I_RENEWAL_PLAN  Internal table for Renewal plan table
*      <--FP_I_FINAL  Internal table for final data
*----------------------------------------------------------------------*
FORM process_redet_profile  USING    fp_i_veda_data TYPE tt_veda_data
                                     fp_i_renewal_det TYPE tt_renewal_det
                                     fp_i_renewal_plan TYPE tt_renewal_plan
* Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
                                     fp_i_renwl_p_det TYPE tt_renwl_p_det
* End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
                            CHANGING fp_i_final TYPE tt_final.

  DATA: lr_renewal_det TYPE REF TO ty_renewal_det, " Ref variable
        lr_final       TYPE REF TO ty_final,       " Final class
        lv_subrc       TYPE sy-subrc,              " Variable
        lv_scenario    TYPE sy-subrc,              " ABAP System Field: Return Code of ABAP Statements
        li_renwl_plan  TYPE tt_renewal_plan,
        lv_upd_flag    TYPE char01.                " Upd_flag of type CHAR01
* Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
  CONSTANTS:
    lc_cr_quote        TYPE zactivity_sub VALUE 'CQ'. " Create Quotation Activity
* End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771

  READ TABLE fp_i_final TRANSPORTING NO FIELDS
                               WITH KEY sel = abap_true.
  IF sy-subrc NE 0.

    MESSAGE i000(zqtc_r2) WITH 'No records selected for processing'(026). " &1&2&3&4&5&6&7&8
    RETURN.

  ENDIF. " IF sy-subrc NE 0

*Remove non selected enties from final table
  DELETE fp_i_final WHERE sel EQ abap_false.

  CREATE DATA: lr_final.


  LOOP AT fp_i_final REFERENCE INTO lr_final.

    CLEAR : li_renwl_plan,
            lv_subrc,
            lv_scenario.

*   Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
    IF lr_final->renwl_prof IS NOT INITIAL.
      READ TABLE fp_i_renwl_p_det REFERENCE INTO DATA(lr_renwl_p_det)
           WITH KEY renwl_prof = lr_final->renwl_prof
           BINARY SEARCH.
      IF sy-subrc EQ 0 AND
         lr_renwl_p_det->consolidate IS NOT INITIAL.
        READ TABLE fp_i_renewal_plan TRANSPORTING NO FIELDS
             WITH KEY vbeln      = lr_final->vbeln
                      posnr      = lr_final->posnr
                      activity   = lc_cr_quote
                      act_status = abap_true
                      ren_status = space
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          lr_final->message = 'Subscription marked for Consolidation'(031).
          CONTINUE.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0 AND
    ENDIF. " IF lr_final->renwl_prof IS NOT INITIAL
*   End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771

    CREATE DATA: lr_renewal_det.
    IF lr_final->zzaction IS NOT INITIAL.

      READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                               pay_type = lr_final->pay_type " Payment type
                                                                               sold_to_country = lr_final->sold_to_country
                                                                               ship_to_country = lr_final->ship_to_country.
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = lr_final->pay_type " Payment type
                                                                    sold_to_country = lr_final->sold_to_country
                                                                    ship_to_country = space.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = lr_final->pay_type " Payment type
                                                                    sold_to_country = space
                                                                    ship_to_country = lr_final->ship_to_country.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = lr_final->pay_type " Payment type
                                                                    sold_to_country = space
                                                                    ship_to_country = space.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = space " Payment type
                                                                    sold_to_country = lr_final->sold_to_country
                                                                    ship_to_country = lr_final->ship_to_country.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = space
                                                                    sold_to_country = lr_final->sold_to_country
                                                                    ship_to_country = space.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = space " Payment type
                                                                    sold_to_country = space
                                                                    ship_to_country = lr_final->ship_to_country.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY zzaction = lr_final->zzaction
                                                                    pay_type = space " Payment type
                                                                    sold_to_country = space
                                                                    ship_to_country = space.
      ENDIF. " IF sy-subrc NE 0

      IF sy-subrc = 0.
        lv_scenario = 1.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF lr_final->zzaction IS NOT INITIAL


    IF lv_scenario NE 1.

      IF lr_final->bsark IS NOT INITIAL.

        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY bsark = lr_final->bsark " PO type
                                                                    matnr = lr_final->matnr        " Material no
                                                                    subs_type = lr_final->subs_type.
        IF sy-subrc NE 0.
          READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY bsark = lr_final->bsark " PO type
                                                                      matnr = lr_final->matnr        " Material no
                                                                      subs_type = space.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc NE 0.
          READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY bsark = lr_final->bsark " PO type
                                                                      matnr = space
                                                                      subs_type = lr_final->subs_type.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc NE 0.
          READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY bsark = lr_final->bsark " PO type
                                                                      matnr = space
                                                                      subs_type = space.
          IF sy-subrc <> 0.
            lv_subrc = 1.
          ELSE. " ELSE -> IF sy-subrc <> 0
            lv_scenario = 2.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF sy-subrc NE 0
      ELSE. " ELSE -> IF lr_final->bsark IS NOT INITIAL
        lv_subrc = 1.
      ENDIF. " IF lr_final->bsark IS NOT INITIAL

      IF lv_subrc = 1.
        READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = space
                                                                    konda = space
                                                                    pay_type = space
                                                                    sold_to_country = space
                                                                    ship_to_country = space
                                                                    license_grp = lr_final->license_grp
                                                                    sales_office = lr_final->sales_office
                                                                    subs_type = space
                                                                    kdkg2 = space
                                                                    mvgr5 = space
                                                                    bsark = space
                                                                    vkorg = space
                                                                    werks = space
                                                                    matnr = space
                                                                    zzaction = space.

        IF sy-subrc NE 0.
          READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = space
                                                                    konda = space
                                                                    pay_type = space
                                                                    sold_to_country = space
                                                                    ship_to_country = space
                                                                    license_grp = lr_final->license_grp
                                                                    sales_office = space
                                                                    subs_type = space
                                                                    kdkg2 = space
                                                                    mvgr5 = space
                                                                    bsark = space
                                                                    vkorg = space
                                                                    werks = space
                                                                    matnr = space
                                                                    zzaction = space.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
          lv_scenario = 3.
        ENDIF. " IF sy-subrc EQ 0

        IF lv_scenario NE 3.
          READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY vkorg = lr_final->vkorg " Sales Org
                                                                      werks = lr_final->werks        " Plant
                                                                      matnr = lr_final->matnr        " Material no
                                                                      subs_type = lr_final->subs_type.
          IF sy-subrc <> 0.
            READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY vkorg = lr_final->vkorg " Sales Org
                                                                           werks = lr_final->werks     " Plant
                                                                           matnr = lr_final->matnr     " Material no
                                                                           subs_type = space.
          ENDIF. " IF sy-subrc <> 0
          IF sy-subrc NE 0.
            READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY vkorg = lr_final->vkorg " Sales Org
                                                                        werks = lr_final->werks        " Plant
                                                                        matnr = space
                                                                        subs_type = lr_final->subs_type.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc NE 0.
            READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY vkorg = lr_final->vkorg        " Sales Org
                                                                                      werks = lr_final->werks " Plant
                                                                                      matnr = space
                                                                                      subs_type = space.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            lv_scenario = 4.
          ENDIF. " IF sy-subrc EQ 0

          IF lv_scenario NE 4.
*            CLEAR lr_renewal_det->*.
            READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                        konda = lr_final->konda        "Price group (customer)
                                                                        kdkg2 = lr_final->kdkg2        " Customer condition group 2
                                                                        pay_type = lr_final->pay_type  " Payment type
                                                                        mvgr5 = lr_final->mvgr5        " Material Group 5
                                                                        matnr = lr_final->matnr        " Material no
                                                                        subs_type = lr_final->subs_type.
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                         konda = lr_final->konda         "Price group (customer)
                                                                         kdkg2 = lr_final->kdkg2         " Customer condition group 2
                                                                         pay_type = lr_final->pay_type   " Payment type
                                                                         mvgr5 = lr_final->mvgr5         " Material Group 5
                                                                         matnr = lr_final->matnr         " Material no
                                                                         subs_type = space.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                          konda = lr_final->konda        "Price group (customer)
                                                                          kdkg2 = lr_final->kdkg2        " Customer condition group 2
                                                                          pay_type = lr_final->pay_type  " Payment type
                                                                          mvgr5 = lr_final->mvgr5        " Material Group 5
                                                                          matnr = space
                                                                          subs_type = lr_final->subs_type.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                          konda = lr_final->konda        "Price group (customer)
                                                                          kdkg2 = lr_final->kdkg2        " Customer condition group 2
                                                                          pay_type = lr_final->pay_type  " Payment type
                                                                          mvgr5 = lr_final->mvgr5        " Material Group 5
                                                                          matnr = space
                                                                          subs_type = space.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp  " Customer Group
                                                                            konda = lr_final->konda       " Price group (customer)
                                                                            kdkg2 = space                 " Customer condition group 2
                                                                            pay_type = lr_final->pay_type " Payment type
                                                                            mvgr5 = lr_final->mvgr5       " Material Group 5
                                                                            matnr = lr_final->matnr       " Material no
                                                                            subs_type = lr_final->subs_type.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                          konda = lr_final->konda        " Price group (customer)
                                                                          kdkg2 = space                  " Customer condition group 2
                                                                          pay_type = lr_final->pay_type  " Payment type
                                                                          mvgr5 = lr_final->mvgr5        " Material Group 5
                                                                          matnr = lr_final->matnr        " Material no
                                                                          subs_type = space.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp " Customer Group
                                                                          konda = lr_final->konda        " Price group (customer)
                                                                          kdkg2 = space                  " Customer condition group 2
                                                                          pay_type = lr_final->pay_type  " Payment type
                                                                          mvgr5 = lr_final->mvgr5        " Material Group 5
                                                                          matnr = space
                                                                          subs_type = lr_final->subs_type.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc NE 0.
              READ TABLE fp_i_renewal_det REFERENCE INTO lr_renewal_det WITH KEY kdgrp = lr_final->kdgrp     " Customer Group
                                                                               konda = lr_final->konda       " Price group (customer)
                                                                               kdkg2 = space                 " Customer condition group 2
                                                                               pay_type = lr_final->pay_type " Payment type
                                                                               mvgr5 = lr_final->mvgr5       " Material Group 5
                                                                               matnr = space
                                                                               subs_type = space.
            ENDIF. " IF sy-subrc NE 0
          ENDIF. " IF lv_scenario NE 4
        ENDIF. " IF lv_scenario NE 3
      ENDIF. " IF lv_subrc = 1

    ENDIF. " IF lv_scenario NE 1

    IF lr_renewal_det->renwl_prof IS NOT INITIAL.

      lr_final->renwl_prof_new = lr_renewal_det->renwl_prof.


      PERFORM f_process_renewal_plan USING fp_i_renewal_det
                                           i_renwl_p_det
                                           i_notif_p_det
                                           lr_renewal_det
                                           lv_scenario
                                           fp_i_veda_data
                                           lr_final
                                           fp_i_renewal_plan
                                  CHANGING li_renwl_plan.

      IF li_renwl_plan IS NOT INITIAL.

        IF p_test EQ abap_false.

          CLEAR lv_upd_flag.
          PERFORM f_update_renwl_plan USING li_renwl_plan
                                            lr_final->vbeln
                                            lr_final->posnr
                                      CHANGING lv_upd_flag.

          IF lv_upd_flag EQ abap_true.

            lr_final->message = 'New Profile updateed successfully'(024).

          ENDIF. " IF lv_upd_flag EQ abap_true

        ELSE. " ELSE -> IF p_test EQ abap_false

          CONCATENATE 'New Profile' lr_renewal_det->renwl_prof 'has been determined'
          INTO lr_final->message SEPARATED BY space.

        ENDIF. " IF p_test EQ abap_false

      ELSE. " ELSE -> IF li_renwl_plan IS NOT INITIAL

        lr_final->message = ' No activity exist to update'(023).

      ENDIF. " IF li_renwl_plan IS NOT INITIAL

    ELSE. " ELSE -> IF lr_renewal_det->renwl_prof IS NOT INITIAL

      lr_final->message = 'Renewal Profile is not determined'(025).

    ENDIF. " IF lr_renewal_det->renwl_prof IS NOT INITIAL

    CLEAR lr_renewal_det.

  ENDLOOP. " LOOP AT fp_i_final REFERENCE INTO lr_final




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_RENEWAL_PLAN
*&---------------------------------------------------------------------*
*       Get the all the acitivities for new Profile to update
*----------------------------------------------------------------------*
*      -->FP_I_RENEWAL_DET  text
*      -->FP_I_RENWL_P_DET  text
*      -->FP_I_NOTIF_P_DET  text
*      -->FP_LR_RENEWAL_DET  text
*      -->FP_LR_FINAL  text
*----------------------------------------------------------------------*
FORM f_process_renewal_plan  USING    fp_i_renewal_det TYPE tt_renewal_det
                                      fp_i_renwl_p_det TYPE tt_renwl_p_det
                                      fp_i_notif_p_det TYPE tt_notif_p_det
                                      fp_lr_renewal_det TYPE REF TO ty_renewal_det " Renewal_det class
                                      fp_lv_scenario TYPE sysubrc                  " Return Code
                                      fp_i_veda_data TYPE tt_veda_data
                                      fp_lr_final TYPE REF TO ty_final             " Final class
                                      fp_i_renewal_plan TYPE tt_renewal_plan
                             CHANGING fp_li_renwl_plan     TYPE tt_renewal_plan.

  CONSTANTS: lc_month    TYPE t5a4a-dlymo  VALUE '00',  " Month
             lc_year     TYPE t5a4a-dlyyr  VALUE '00',  " Year
             lc_cr_quote TYPE zactivity_sub VALUE 'CQ', " Create Quotation Activity
             lc_cr_subs  TYPE zactivity_sub VALUE 'CS', " Create Subscription activity
             lc_gr_subs  TYPE zactivity_sub VALUE 'GR', " Grace Subscription
             lc_lapse    TYPE zactivity_sub VALUE 'LP', " Lapse Subscription
             lc_not_nded TYPE zren_status   VALUE 'N'.  " Renewal Status: Not Needed - Profile Changed


  DATA : lr_renwl_plan  TYPE REF TO zqtc_renwl_plan, " Renewal_plan class
         lr_renwl_p_det TYPE REF TO ty_renwl_p_det,  " Renwl_p_det class
         lr_notif_p_det TYPE REF TO ty_notif_p_det,  " Notif_p_det class
         li_renwl_p_old TYPE tt_renewal_plan,
         lv_days        TYPE t5a4a-dlydy.            " Variable for days


  CREATE DATA : lr_renwl_plan,
  lr_renwl_p_det,
  lr_notif_p_det.


*& Populate Notification Reminder Activity
  LOOP AT fp_i_notif_p_det REFERENCE INTO lr_notif_p_det .
    lr_renwl_plan->vbeln = fp_lr_final->vbeln. " Order Number
    lr_renwl_plan->posnr = fp_lr_final->posnr. " item
    lr_renwl_plan->matnr = fp_lr_final->matnr. " Material no

    lr_renwl_plan->activity = lr_notif_p_det->notif_rem. " Notification Reminder
    READ TABLE fp_i_renwl_p_det ASSIGNING FIELD-SYMBOL(<lst_renwl_p_det>)
       WITH KEY renwl_prof = fp_lr_renewal_det->renwl_prof
                                            notif_prof = lr_notif_p_det->notif_prof
               .
    IF sy-subrc = 0.
      lr_renwl_plan->renwl_prof = <lst_renwl_p_det>-renwl_prof. " Renewal  Profile
      READ TABLE fp_i_veda_data INTO DATA(lst_veda) WITH KEY vbeln = fp_lr_final->vbeln
                                                     vposn = fp_lr_final->posnr.

      IF sy-subrc EQ 0.
        lr_renwl_plan->eadat  = lst_veda-venddat + lr_notif_p_det->rem_in_days.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                        vposn = c_posnr_low.
        IF sy-subrc = 0.
          lr_renwl_plan->eadat  = lst_veda-venddat + lr_notif_p_det->rem_in_days.

        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc EQ 0
      lr_renwl_plan->aedat = sy-datum.
      lr_renwl_plan->aenam = sy-uname.
      lr_renwl_plan->aezet = sy-uzeit.
      lr_renwl_plan->promo_code = lr_notif_p_det->promo_code.
      APPEND lr_renwl_plan->* TO fp_li_renwl_plan.
      CLEAR lr_renwl_plan->*.

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_notif_p_det REFERENCE INTO lr_notif_p_det


  LOOP AT fp_i_renwl_p_det REFERENCE INTO lr_renwl_p_det
                     WHERE renwl_prof = fp_lr_renewal_det->renwl_prof .
    CLEAR lr_renwl_plan->*.
*& Populate Quotation Create Activity
    IF lr_renwl_p_det->quote_time IS NOT INITIAL.
      lr_renwl_plan->renwl_prof =  lr_renwl_p_det->renwl_prof. " renewal Profile
      lr_renwl_plan->vbeln = fp_lr_final->vbeln. " Sales Order
      lr_renwl_plan->posnr = fp_lr_final->posnr. " Item
      lr_renwl_plan->matnr = fp_lr_final->matnr. " Material no


      lr_renwl_plan->activity = lc_cr_quote. " Quotation Create
      CLEAR lst_veda.
      READ TABLE fp_i_veda_data INTO lst_veda WITH KEY  vbeln = fp_lr_final->vbeln
                                                 vposn = fp_lr_final->posnr.
      IF sy-subrc EQ 0.
        lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->quote_time. " quotation Create Time
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                   vposn = c_posnr_low.
        IF sy-subrc = 0.
          lr_renwl_plan->eadat  = lst_veda-venddat + lr_renwl_p_det->quote_time.

        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF sy-subrc EQ 0
      lr_renwl_plan->aedat = sy-datum. " System Date
      lr_renwl_plan->aezet = sy-uzeit. " system Time
      lr_renwl_plan->aenam = sy-uname. " User Name
      APPEND lr_renwl_plan->* TO fp_li_renwl_plan.
      CLEAR lr_renwl_plan->*.
    ENDIF. " IF lr_renwl_p_det->quote_time IS NOT INITIAL
*& Populate Grace Subscription Activity Details
    IF lr_renwl_p_det->grace_period IS NOT INITIAL .
      lr_renwl_plan->renwl_prof =  fp_lr_renewal_det->renwl_prof.
      lr_renwl_plan->vbeln = fp_lr_final->vbeln.
      lr_renwl_plan->posnr = fp_lr_final->posnr.
      lr_renwl_plan->matnr = fp_lr_final->matnr. " Material no


      lr_renwl_plan->activity = lc_gr_subs.
*& If grace start days given then add the days to subscription expiry date
      IF lr_renwl_p_det->grace_start IS NOT INITIAL.

        CLEAR: lst_veda, lv_days.
 "ADD lr_renwl_p_det->grace_start TO lv_days.
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                  vposn = fp_lr_final->posnr.
        IF sy-subrc EQ 0.
          lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->grace_start.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                    vposn = c_posnr_low.

          IF sy-subrc = 0.
            lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->grace_start.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc EQ 0

      ELSE. " ELSE -> IF lr_renwl_p_det->grace_start IS NOT INITIAL
*& Otherwise it would be the very next day
        CLEAR:lst_veda, lv_days.
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                  vposn = fp_lr_final->posnr.
        IF sy-subrc EQ 0.
          DATA(lv_date) = lst_veda-venddat.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                     vposn = c_posnr_low.
          IF sy-subrc = 0.
            lv_date  = lst_veda-venddat .

          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc EQ 0
        ADD 1 TO lv_days.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lv_date "xveda-venddat
            days      = lv_days
            months    = lc_month
            years     = lc_year
          IMPORTING
            calc_date = lr_renwl_plan->eadat.
*& The FM has no exception , hence sy-subrc not used
      ENDIF. " IF lr_renwl_p_det->grace_start IS NOT INITIAL

      lr_renwl_plan->aedat = sy-datum. " System Date
      lr_renwl_plan->aezet = sy-uzeit. " System Time
      lr_renwl_plan->aenam = sy-uname. " User Name
      APPEND lr_renwl_plan->* TO fp_li_renwl_plan.
      CLEAR lr_renwl_plan->*.
    ENDIF. " IF lr_renwl_p_det->grace_period IS NOT INITIAL

    IF fp_lv_scenario = 1 . " VCH Scenario
      lr_renwl_plan->renwl_prof =  fp_lr_renewal_det->renwl_prof. " Renewal Profile
      lr_renwl_plan->posnr = fp_lr_final->posnr. " Item
      lr_renwl_plan->matnr = fp_lr_final->matnr. " Material no


      lr_renwl_plan->vbeln = fp_lr_final->vbeln. " Subscription Number
      lr_renwl_plan->activity = lc_cr_subs. " Create Subscription
*&If Autorenewal is zero, then  it would be the very next day
      IF lr_renwl_p_det->auto_renew EQ 0.

        CLEAR: lv_days,lst_veda,lv_date.
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                  vposn = fp_lr_final->posnr.
        IF sy-subrc EQ 0.
          lv_date = lst_veda-venddat.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                     vposn = c_posnr_low.
          IF sy-subrc = 0.
            lv_date  = lst_veda-venddat .

          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc EQ 0

        ADD 1 TO lv_days.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lv_date "xveda-venddat
            days      = lv_days
            months    = lc_month
            years     = lc_year
          IMPORTING
            calc_date = lr_renwl_plan->eadat.
*& The FM has no exception , hence sy-subrc not used
        lr_renwl_plan->eadat = lv_date + 1. "xveda-venddat + 1.

*                ELSEIF  lr_renwl_p_det->auto_renew GT 0 . "Commented by MODUTTA for JIRA Defect# 1865
      ELSE. " ELSE -> IF lr_renwl_p_det->auto_renew EQ 0

        CLEAR: lv_days,lst_veda,lv_date.
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                  vposn = fp_lr_final->posnr.
        IF sy-subrc EQ 0.
          lv_date = lst_veda-venddat.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                     vposn = c_posnr_low.
          IF sy-subrc = 0.
            lv_date  = lst_veda-venddat .

          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc EQ 0
*& ADD Days to a date
        lr_renwl_plan->eadat = lv_date + lr_renwl_p_det->auto_renew.
      ENDIF. " IF lr_renwl_p_det->auto_renew EQ 0
      lr_renwl_plan->aedat = sy-datum.
      lr_renwl_plan->aezet = sy-uzeit.
      lr_renwl_plan->aenam = sy-uname.
      APPEND lr_renwl_plan->* TO fp_li_renwl_plan.
      CLEAR lr_renwl_plan->*.

    ENDIF. " IF fp_lv_scenario = 1
*& Populate Lapse Activity details
    IF lr_renwl_p_det->lapse IS NOT INITIAL.
      lr_renwl_plan->vbeln = fp_lr_final->vbeln. " Order
      lr_renwl_plan->posnr = fp_lr_final->posnr. " Items
      lr_renwl_plan->matnr = fp_lr_final->matnr. " Material no

      lr_renwl_plan->activity = lc_lapse. " Lapse Activity
      lr_renwl_plan->renwl_prof =  fp_lr_renewal_det->renwl_prof. " renewal Profile
      CLEAR: lv_days,lv_date,lst_veda.
      READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                vposn = fp_lr_final->posnr.
      IF sy-subrc EQ 0.
        lv_date = lst_veda-venddat.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE fp_i_veda_data INTO lst_veda WITH KEY vbeln = fp_lr_final->vbeln
                                                   vposn = c_posnr_low.
        IF sy-subrc = 0.
          lv_date  = lst_veda-venddat .

        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc EQ 0
*& ADD Days to a date
      lr_renwl_plan->eadat = lv_date + lr_renwl_p_det->lapse.
      lr_renwl_plan->aedat = sy-datum.
      lr_renwl_plan->aezet = sy-uzeit.
      lr_renwl_plan->aenam = sy-uname.
      APPEND lr_renwl_plan->* TO fp_li_renwl_plan.
      CLEAR lr_renwl_plan->*.

    ENDIF. " IF lr_renwl_p_det->lapse IS NOT INITIAL
  ENDLOOP. " LOOP AT fp_i_renwl_p_det REFERENCE INTO lr_renwl_p_det

  IF fp_li_renwl_plan IS NOT INITIAL.

    li_renwl_p_old[] = fp_i_renewal_plan[].
    DELETE li_renwl_p_old WHERE vbeln NE fp_lr_final->vbeln.
    DELETE li_renwl_p_old WHERE posnr NE fp_lr_final->posnr.

    SORT li_renwl_p_old BY vbeln posnr activity.


** ingore the activities which are alredy been completed
    LOOP AT fp_li_renwl_plan ASSIGNING FIELD-SYMBOL(<lst_renwl_plan>).

      READ TABLE li_renwl_p_old ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)
                                        WITH KEY vbeln = <lst_renwl_plan>-vbeln
                                                 posnr = <lst_renwl_plan>-posnr
                                                 activity = <lst_renwl_plan>-activity
                                        BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF ( <lst_renewal_plan>-act_status EQ abap_true
        OR <lst_renewal_plan>-excl_resn IS NOT INITIAL ).
*      OR <lst_renewal_plan>-ren_status IS NOT INITIAL ).

          CLEAR: <lst_renwl_plan>-vbeln,
                 <lst_renwl_plan>-posnr.

        ENDIF. " IF ( <lst_renewal_plan>-act_status EQ abap_true

        CLEAR <lst_renewal_plan>-mandt.

      ENDIF. " IF sy-subrc EQ 0

    ENDLOOP. " LOOP AT fp_li_renwl_plan ASSIGNING FIELD-SYMBOL(<lst_renwl_plan>)

    DELETE fp_li_renwl_plan WHERE vbeln IS INITIAL
                                 AND posnr IS INITIAL.

* Modify / Cancel the entries those are not needed anymore
    DELETE li_renwl_p_old  WHERE mandt      IS INITIAL
                             OR act_status IS NOT INITIAL
                             OR excl_resn  IS NOT INITIAL.

    LOOP AT li_renwl_p_old ASSIGNING <lst_renewal_plan>.

      <lst_renewal_plan>-act_status = abap_true.
      <lst_renewal_plan>-ren_status = lc_not_nded.
      <lst_renewal_plan>-aedat      = sy-datum. " System Date
      <lst_renewal_plan>-aezet      = sy-uzeit. " System Time
      <lst_renewal_plan>-aenam      = sy-uname. " User Name
      APPEND <lst_renewal_plan> TO fp_li_renwl_plan.

    ENDLOOP. " LOOP AT li_renwl_p_old ASSIGNING <lst_renewal_plan>

  ENDIF. " IF fp_li_renwl_plan IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RENWL_PLAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_RENWL_PLAN  text
*      -->P_LI_RENWL_PLAN_DEL  text
*      -->P_LR_FINAL_>VBELN  text
*      -->P_LR_FINAL_>POSNR  text
*      <--P_LV_UPD_FLAG  text
*----------------------------------------------------------------------*
FORM f_update_renwl_plan  USING    fp_li_renwl_plan TYPE tt_renewal_plan
                                   fp_lr_final_vbeln TYPE vbeln_va " Sales Document
                                   fp_lr_final_posnr TYPE posnr_va " Sales Document Item
                          CHANGING fp_lv_upd_flag TYPE char01.     " Lv_upd_flag of type CHAR01

  IF fp_li_renwl_plan IS NOT INITIAL.

    CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
      EXPORTING
        mode_zqtc_renwl_plan = abap_true
        mandt                = sy-mandt
        vbeln                = fp_lr_final_vbeln
        posnr                = fp_lr_final_posnr
      EXCEPTIONS
        foreign_lock         = 1
        system_failure       = 2
        OTHERS               = 3.
    IF sy-subrc <> 0.
      MESSAGE a223(zqtc_r2). "Unable to lock table ZQTC_AUTO_RENEW
    ELSE. " ELSE -> IF sy-subrc <> 0
      MODIFY zqtc_renwl_plan FROM TABLE fp_li_renwl_plan.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        fp_lv_upd_flag = abap_true.

        CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
          EXPORTING
            mode_zqtc_renwl_plan = abap_true
            mandt                = sy-mandt
            vbeln                = fp_lr_final_vbeln
            posnr                = fp_lr_final_posnr.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF fp_li_renwl_plan IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZE_VARIABLES
*&---------------------------------------------------------------------*
*       Initilize all the Globle Tables
*----------------------------------------------------------------------*
FORM f_initialize_variables .

  CLEAR : i_fcat,
          i_final,
          i_hdr_itm_data,
          i_vbpa_data,
          i_renewal_plan,
          i_renewal_det,
          i_pay_key_typ,
          i_veda_data ,
          i_renwl_p_det,
          i_notif_p_det,
          i_vbkd_data.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DEFAULT_DATE_RANGE
*&---------------------------------------------------------------------*
*       Set the Default date on selection screen
*----------------------------------------------------------------------*

FORM f_default_date_range .

*Local constant declaration
  CONSTANTS:   lc_day   TYPE t5a4a-dlydy  VALUE '00', " day
               lc_year  TYPE t5a4a-dlyyr  VALUE '00', " Year
               lc_month TYPE t5a4a-dlymo  VALUE '01', " Month
               lc_opt   TYPE char02       VALUE 'BT', " BT
               lc_sign  TYPE char01       VALUE 'I'.  "I


** pass date range as (Current date - 1 month to Current date)
  s_erdat-option = lc_opt.
  s_erdat-sign = lc_sign.
  s_erdat-high = sy-datum.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = s_erdat-high
      days      = lc_day
      months    = lc_month
      signum    = '-'
      years     = lc_year
    IMPORTING
      calc_date = s_erdat-low.
  .
  APPEND s_erdat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_DATA
*&---------------------------------------------------------------------*
*       Read constant table data from ZCACONSTANT
*----------------------------------------------------------------------*
*      <--FP_I_CONSTANT  constant data
*----------------------------------------------------------------------*
FORM f_get_constant_data  CHANGING fp_i_constant TYPE tt_constant.

  CONSTANTS : lc_devid TYPE zdevid VALUE 'E095'. " Development ID

  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = lc_devid.

  IF sy-subrc EQ 0.

    SORT fp_i_constant BY param1.

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
