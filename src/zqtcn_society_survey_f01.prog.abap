*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SOCIETY_SURVEY_R043
* PROGRAM DESCRIPTION: Society Survey options Report
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-04-26
* OBJECT ID: R043
* TRANSPORT NUMBER(S): ED2K904138
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K905728
* REFERENCE NO:  ERP-2854
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-06-19
* DESCRIPTION: Header texts for CSV file has been changed as per the
* requirement.
*-------------------------------------------------------------------
* REVISION NO: ED2K907530
* REFERENCE NO:  ERP-3472
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-26
* DESCRIPTION: Salutation should have the description instead of number.
*              same has been fixed. Member Category Desc was having an
*              issue in reading BINARY search and hence used SORT to work.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918013
* REFERENCE NO: ERPM-14689
* WRICEF ID: R043
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE: 04/17/2020
* DESCRIPTION: Single date selection extend to the Date range
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SOCIETY_SURVEY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       Screen Modification
*----------------------------------------------------------------------*

FORM f_modify_screen .
**********************************************************************
*Modifying the screen with the download part visible only in case of
*selection of Save Radio-Button.
**********************************************************************
  LOOP AT SCREEN.
    IF rb_dis = abap_true.
      IF screen-group1 = c_scrgrp.
        screen-active = 0.
      ENDIF. " IF screen-group1 = c_scrgrp
    ELSE. " ELSE -> IF rb_dis = abap_true
      CLEAR rb_dis.
      IF screen-group1 = c_scrgrp.
        screen-active = 1.
      ENDIF. " IF screen-group1 = c_scrgrp
    ENDIF. " IF rb_dis = abap_true
    MODIFY SCREEN.
  ENDLOOP. " LOOP AT SCREEN
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populating default values in Selection Screem
*----------------------------------------------------------------------*

FORM f_populate_defaults  CHANGING fp_s_sub TYPE edm_auart_range_tt " Range from AUART
                                   fp_s_doc TYPE rjksd_vbtyp_range_tab
* Begin of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
                                   fp_s_erdat TYPE farric_rt_erdat.
* End of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
**********************************************************************
*Population of Subscription Category and document category
*with ZSUB and ZREW as default
**********************************************************************

  IF fp_s_sub IS INITIAL.
    APPEND INITIAL LINE TO fp_s_sub ASSIGNING FIELD-SYMBOL(<lst_sub_typ>).
    <lst_sub_typ>-sign   = c_sign_incld. "Sign: (I)nclude
    <lst_sub_typ>-option = c_opti_equal. "Option: (EQ)ual
    <lst_sub_typ>-low    = c_auart_zsub. "Subscription Type : ZSUB
    <lst_sub_typ>-high   = space.

    APPEND INITIAL LINE TO fp_s_sub ASSIGNING <lst_sub_typ>.
    <lst_sub_typ>-sign   = c_sign_incld. "Sign: (I)nclude
    <lst_sub_typ>-option = c_opti_equal. "Option: (EQ)ual
    <lst_sub_typ>-low    = c_auart_zrew. "Subscription Type : ZREW
    <lst_sub_typ>-high   = space.

  ENDIF.

  IF fp_s_doc IS INITIAL.
    APPEND INITIAL LINE TO fp_s_doc ASSIGNING FIELD-SYMBOL(<lst_doc_cat>).
    <lst_doc_cat>-sign   = c_sign_incld. "Sign: (I)nclude
    <lst_doc_cat>-option = c_opti_equal. "Option: (EQ)ual
    <lst_doc_cat>-low    = c_vbtyp_g. "Subscription Type : ZSUB
    <lst_doc_cat>-high   = space.
  ENDIF.

* Begin of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
  IF fp_s_erdat IS INITIAL.
    APPEND INITIAL LINE TO fp_s_erdat ASSIGNING FIELD-SYMBOL(<lfs_erdat>).
    <lfs_erdat>-sign   = c_sign_incld. "Sign: (I)nclude
    <lfs_erdat>-option = c_opti_equal. "Option: (EQ)ual
    <lfs_erdat>-low    = sy-datum.     "Current date of application server
*   <lfs_erdat>-high   = sy-datum.     "Current date of application server
  ENDIF.
* End of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       Clearing all Global variables,work area and internal tables
*----------------------------------------------------------------------*

FORM f_clear_all .

  CLEAR : i_tab_final,    "Final table
          i_fieldcatalog. "Field catalog for ALV

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_PARTNER
*&---------------------------------------------------------------------*
*       Validation of Society BP Number field
*----------------------------------------------------------------------*

FORM f_val_partner  USING fp_s_bp TYPE farr_rt_rai_partner. " Business Partner Number

* Validation of Society BP Number field
  IF fp_s_bp IS NOT INITIAL.
    SELECT SINGLE partner " Customer Number
           FROM but000    " General Data in Customer Master
      INTO @DATA(lv_partner)
      WHERE partner IN @fp_s_bp.
    IF sy-subrc <> 0.
*   Message: Invalid Society BP Number..No Society exists!
      MESSAGE e146. " Invalid Society BP Number,Please re-enter.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_s_bp IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_RELTYP
*&---------------------------------------------------------------------*
*       Validation of Relationship Category field
*----------------------------------------------------------------------*

FORM f_val_reltyp  USING fp_s_rel TYPE tt_reltyp_r. " Business Partner Relationship Category

  IF fp_s_rel IS NOT INITIAL.
    SELECT reltyp " Business Partner Relationship Category
      FROM tbz9   " BP relationship categories
      UP TO 1 ROWS
      INTO TABLE @DATA(li_rel1)
      WHERE reltyp IN @fp_s_rel.
    IF sy-subrc <> 0.
*   Message: Invalid BP Relationship Category,Please re-enter.
      MESSAGE e188. " Invalid BP Relationship Category,Please re-enter.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_s_rel IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_SUBTYP
*&---------------------------------------------------------------------*
*       Validation of Subscription Type field
*----------------------------------------------------------------------*

FORM f_val_subtyp  USING  fp_s_sub TYPE edm_auart_range_tt.

  IF  fp_s_sub IS NOT INITIAL.
    SELECT SINGLE auart " Sales Document Type
      FROM tvak         " Sales Document Types
      INTO @DATA(lv_sub)
      WHERE auart IN @fp_s_sub.
    IF sy-subrc <> 0.
*   Message: Invalid Subscription Type,Please re-enter.
      MESSAGE e189. " Invalid Subscription Type,Please re-enter.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_s_sub IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_DOCCAT
*&---------------------------------------------------------------------*
*       Validate Document Category field
*----------------------------------------------------------------------*

FORM f_val_doccat  USING  fp_s_doc TYPE rjksd_vbtyp_range_tab.

  DATA : lv_rc        TYPE sysubrc,                 " Return Code
         li_domainval TYPE STANDARD TABLE OF dd07v, " Generated Table for View
         lv_lines     TYPE i.                       " Lines of type Integers

  CONSTANTS : lc_domname TYPE domname    VALUE 'VBTYP'. " Domain name

*Validate Document Category field

  IF fp_s_doc IS NOT INITIAL . "AND fp_s_doc NS '*'.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = lc_domname
      TABLES
        values_tab      = li_domainval
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0
**********************************************************************
*The values in table li_domainval is equated with the values entered
*in the selection category.
**********************************************************************

    DESCRIBE TABLE li_domainval LINES DATA(lv_lines1).
**Delete entries from table li_domainval which has values equal to doc
** category in selection screen
    DELETE li_domainval WHERE domvalue_l IN fp_s_doc.
    DESCRIBE TABLE li_domainval LINES DATA(lv_lines2).

    IF lv_lines1 EQ lv_lines2.

      MESSAGE e194. " Invalid Document Category,Please re-enter.

    ENDIF. " IF lv_lines1 EQ lv_lines2

  ENDIF. " IF fp_s_doc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_POTYPE
*&---------------------------------------------------------------------*
*       Validation of Purchase Order Type field
*----------------------------------------------------------------------*

FORM f_val_potype  USING  fp_s_po TYPE tdt_rg_bsark.

*Validation of Purchase Order Type field
  IF fp_s_po IS NOT INITIAL.
    SELECT SINGLE bsark " Customer purchase order type
      FROM t176         " Sales Documents: Customer Order Types
      INTO @DATA(lv_t176)
      WHERE bsark IN @fp_s_po.

    IF sy-subrc <> 0.
*   Message: Invalid Purchase Order Type,Please re-enter.
      MESSAGE e190. " Invalid Purchase Order Type,Please re-enter.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_s_po IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       Fetching from tables BUT000, BUT020, BUT050 and ADRC
*----------------------------------------------------------------------*

FORM f_fetch_data  USING fp_s_bp TYPE farr_rt_rai_partner
                         fp_s_rel TYPE tt_reltyp_r
                         fp_s_sub TYPE edm_auart_range_tt
                         fp_s_doc TYPE rjksd_vbtyp_range_tab
* Begin of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
                         "fp_p_date TYPE sy-datum " ABAP System Field: Current Date of Application Server
                         fp_s_date TYPE farric_rt_erdat
* End of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
                         fp_s_po TYPE tdt_rg_bsark
                CHANGING fp_i_tab_final TYPE tt_tab_records.

  TYPES : BEGIN OF lty_tab_final,
            vbeln       TYPE vbeln_va, " Sales Document
            mem_num     TYPE kunnr,    " Customer Number
            society_num TYPE kunag,    " Customer Number
          END OF lty_tab_final,
          BEGIN OF lty_val_vbeln_list,
            vbeln       TYPE vbeln_va, " Sales Document
            erdat       TYPE erdat,    " Date on Which Record Was Created
            vbtyp       TYPE vbtyp,    " SD document category
            auart       TYPE auart,    " Sales Document Type
            bsark       TYPE bsark,    " Customer purchase order type
            parvw       TYPE parvw,    " Partner Function
            society_num TYPE kunag,    " Sold-to party
            name1       TYPE name1,    " Name
          END OF lty_val_vbeln_list.


  DATA: li_tab_final      TYPE STANDARD TABLE OF lty_tab_final,
        li_val_vbeln_list TYPE STANDARD TABLE OF lty_val_vbeln_list WITH NON-UNIQUE SORTED KEY mkey COMPONENTS vbeln.

  CONSTANTS : lc_za TYPE parvw VALUE 'ZA', " Partner Function
              lc_we TYPE parvw VALUE 'WE'. " Partner Function

*********************************************************************
* Selection from VBAK and VBPA to get the valid list of all the
* subscriptions created on the date(as given in Selection screen) for
* that society(given in Selection Screen)
**********************************************************************
  SELECT a~vbeln AS vbeln
         a~erdat                " Date on Which Record Was Created
         a~vbtyp                " SD document category
         a~auart                " Sales Document Type
         a~bsark                " Customer purchase order type
         b~parvw                " Partner Function
         b~kunnr AS society_num " Customer Number
         c~name1                " Name 1
FROM vbak AS a
INNER JOIN vbpa AS b
ON a~vbeln = b~vbeln
LEFT OUTER JOIN adrc AS c
ON b~adrnr = c~addrnumber
INTO TABLE li_val_vbeln_list
WHERE a~erdat IN fp_s_date                      "EQ fp_p_date
AND a~auart   IN fp_s_sub
AND a~vbtyp   IN fp_s_doc
AND a~bsark   IN fp_s_po
AND b~parvw   EQ lc_za
AND b~kunnr   IN fp_s_bp.

  IF sy-subrc EQ 0.
    IF fp_s_po IS NOT INITIAL.
** Excluding the Purchase Order Type entries from table(if any)!
      DELETE li_val_vbeln_list WHERE bsark IN fp_s_po.
    ENDIF. " IF fp_s_po IS NOT INITIAL
  ENDIF.
  IF li_val_vbeln_list[] IS NOT INITIAL.
* Getting a list of all valid VBELN list by removing duplicates(if any)!
    SORT li_val_vbeln_list BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_val_vbeln_list
                               COMPARING vbeln.


*=====================================================================================*
* Fetching from VBPA,BUT000,ADRC and ADR6 table to get the field values on the basis of
* PARVW = 'WE'.
*=====================================================================================*
    SELECT a~vbeln AS vbeln,
           a~parvw,
           a~kunnr AS mem_num,
           a~adrnr,
           b~title,
           b~name_org1,
           b~name_last,
           b~name_first,
           c~str_suppl1,
           c~str_suppl2,
           c~street,
           c~city1,
           c~country,
           c~post_code1,
           c~tel_number,
           d~smtp_addr " E-Mail Address
FROM vbpa AS a
LEFT OUTER JOIN but000 AS b ON a~kunnr   = b~partner
LEFT OUTER JOIN adrc   AS c ON a~adrnr   = c~addrnumber
LEFT OUTER JOIN adr6   AS d ON a~adrnr   = d~addrnumber
INTO TABLE @DATA(li_val)
FOR ALL ENTRIES IN @li_val_vbeln_list
WHERE a~vbeln   EQ @li_val_vbeln_list-vbeln
AND   a~parvw   EQ @lc_we.
    IF li_val IS NOT INITIAL.
      SORT li_val BY vbeln.
      DATA(li_val_tmp) = li_val.
      SORT li_val_tmp BY vbeln country.
      DELETE ADJACENT DUPLICATES FROM li_val_tmp
                                 COMPARING vbeln
                                           country.

**********************************************************************
* Merging the above two internal tables into a final internal table
* to fetch the RELTYP from BUT050 for PARTNER1 and PARTNER2.
**********************************************************************
      MOVE-CORRESPONDING li_val TO li_tab_final.
      li_tab_final = CORRESPONDING #( li_tab_final FROM li_val_vbeln_list USING KEY mkey vbeln = vbeln ).

**********************************************************************
* Deleting for duplicate entries in case of member number and
* society number
**********************************************************************

      SORT li_tab_final BY society_num
                           mem_num.
      DELETE ADJACENT DUPLICATES FROM li_tab_final
                               COMPARING society_num
                                         mem_num.

**********************************************************************
* Selection from T005T table to get Country Names for the corresponding
* Country Key
**********************************************************************
      IF li_val_tmp[] IS NOT INITIAL.    "Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
        SELECT spras,
               land1,
               landx " Country Name
        FROM t005t   " Country Names
          INTO TABLE @DATA(li_cont)
          FOR ALL ENTRIES IN @li_val_tmp
          WHERE spras EQ @sy-langu
          AND   land1 EQ @li_val_tmp-country.
        IF sy-subrc EQ 0.
          SORT li_cont BY land1.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.     " Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
    ENDIF. " IF li_val IS NOT INITIAL

**********************************************************************
* Selection from BUT050 to get the RELTYP and selection from
* TBZ9A for Relationship type title
**********************************************************************
    IF li_tab_final IS NOT INITIAL.

      SELECT     a~partner1,
                 a~partner2,
                 a~date_to,
                 a~date_from,
                 a~reltyp,
                 b~spras,
                 b~rtitl " Title of Object Part
            FROM but050 AS a
       INNER JOIN tbz9a AS b ON
            a~reltyp = b~reltyp
       INTO TABLE @DATA(li_rel)
         FOR ALL ENTRIES IN @li_tab_final
            WHERE ( a~partner1 EQ @li_tab_final-mem_num
            AND   a~partner2   EQ @li_tab_final-society_num )
            AND   a~reltyp     IN @fp_s_rel
            AND   b~spras      EQ @sy-langu
            AND   a~date_to    GE @sy-datum
            AND   a~date_from  LE @sy-datum.
* Begin of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
* As Binary search is used for READ statement we are sorting on the same parameters
      IF sy-subrc EQ 0.
        SORT li_rel BY partner1 partner2.
      ENDIF.
* End of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
    ENDIF. " IF li_tab_final IS NOT INITIAL

* Begin of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
***********************************************************************
* To get the Salute(TITLE)'s Description from TSAD3T table for the ones
* that are picked from the internal table li_val_vbeln_list.
***********************************************************************
    DATA(li_title_tmp) = li_val[].
    SORT li_title_tmp BY title.
    DELETE ADJACENT DUPLICATES FROM li_title_tmp COMPARING title.
    IF li_title_tmp[] IS NOT INITIAL.
      SELECT langu,
             title,
             title_medi
             FROM tsad3t
             INTO TABLE @DATA(li_title_desc)
             FOR ALL ENTRIES IN @li_title_tmp
             WHERE langu EQ @sy-langu
               AND title EQ @li_title_tmp-title.
      IF sy-subrc EQ 0.
        SORT li_title_desc BY title.
      ENDIF.
    ENDIF.
* End of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3472
  ELSE. " ELSE -> IF li_val_vbeln_list[] IS NOT INITIAL
    MESSAGE i174. "No Data to process
    LEAVE LIST-PROCESSING.
  ENDIF. " IF li_val_vbeln_list[] IS NOT INITIAL

**********************************************************************
* Populating the data into the final internal table to create the report
**********************************************************************

  LOOP AT li_val_vbeln_list ASSIGNING FIELD-SYMBOL(<lst_val_vbeln_list>).
    READ TABLE li_val ASSIGNING FIELD-SYMBOL(<lst_val>) WITH KEY vbeln = <lst_val_vbeln_list>-vbeln
                                         BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      APPEND INITIAL LINE TO fp_i_tab_final ASSIGNING FIELD-SYMBOL(<lst_tab_final>).

      <lst_tab_final>-first_name    = <lst_val>-name_first. "First name
      <lst_tab_final>-last_name     = <lst_val>-name_last. "Last Name
      <lst_tab_final>-email         = <lst_val>-smtp_addr. "Email
      <lst_tab_final>-ext_data_ref  = space. "External Data Reference
* Begin of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3472
*      <lst_tab_final>-salutation    = <lst_val>-title. "Salutation
      READ TABLE li_title_desc ASSIGNING FIELD-SYMBOL(<lfs_st_title_desc>)
                                               WITH KEY title = <lst_val>-title.
      IF sy-subrc EQ 0.
        <lst_tab_final>-salutation    = <lfs_st_title_desc>-title_medi. "Salutation Desc
      ENDIF.
* End of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3472
      <lst_tab_final>-inst_name     = <lst_val>-str_suppl1. "Institute name
      <lst_tab_final>-dept_name     = <lst_val>-str_suppl2. "Department Name
      <lst_tab_final>-street        = <lst_val>-street. "Street
      <lst_tab_final>-city          = <lst_val>-city1. "City
      <lst_tab_final>-post_code     = <lst_val>-post_code1. "Post code
      <lst_tab_final>-telephone     = <lst_val>-tel_number. "Telephone
      <lst_tab_final>-mem_num       = <lst_val>-mem_num. "Member Number
      <lst_tab_final>-society_num   = <lst_val_vbeln_list>-society_num. "Society Number
      <lst_tab_final>-society_name  = <lst_val_vbeln_list>-name1. "Society Name
      <lst_tab_final>-subscrptn_num = <lst_val_vbeln_list>-vbeln. "Subscription Number

***Read table to get the country
      READ TABLE li_cont INTO DATA(lst_cont) WITH KEY land1 = <lst_val>-country
                                             BINARY SEARCH.
      IF sy-subrc EQ 0.

        <lst_tab_final>-country       = lst_cont-landx. "Country

      ENDIF. " IF sy-subrc EQ 0

***Read table to populate the member category
      READ TABLE li_rel INTO DATA(lst_rel) WITH KEY partner1 = <lst_val>-mem_num
                                                    partner2 = <lst_val_vbeln_list>-society_num
                                                    BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        <lst_tab_final>-mem_cat = lst_rel-rtitl. "Member Category
      ENDIF. " IF sy-subrc IS INITIAL

      CLEAR: lst_cont,
             lst_rel.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDLOOP. " LOOP AT li_val_vbeln_list ASSIGNING FIELD-SYMBOL(<lst_val_vbeln_list>)

  DELETE fp_i_tab_final WHERE email IS INITIAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PRES_F4
*&---------------------------------------------------------------------*
*       F4 help for Prsentation Server file path
*----------------------------------------------------------------------*

FORM f_pres_f4  USING fp_p_file TYPE localfile. " Local file for upload/download

  DATA: lv_path_str TYPE string,
        lv_text     TYPE string.

  lv_text = text-026.

**********************************************************************
*F4 help for the presenation file path
**********************************************************************

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = lv_text
    CHANGING
      selected_folder = lv_path_str
    EXCEPTIONS
      cntl_error      = 1.

  IF sy-subrc EQ 0.
*   Nothing to be done
  ENDIF. " IF sy-subrc EQ 0

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2.
  IF sy-subrc EQ 0.
*   Nothing to be done
  ENDIF. " IF sy-subrc EQ 0

  fp_p_file = lv_path_str.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_APP_F4
*&---------------------------------------------------------------------*
*  F4 help for the application file path
*----------------------------------------------------------------------*
*      -->fp_p_file type localfile
*----------------------------------------------------------------------*
FORM f_app_f4  USING fp_p_file TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc EQ 0.
*   Nothing to be done
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       ALV Display for the Report
*----------------------------------------------------------------------*

FORM f_display_output  USING  fp_i_tab_final TYPE tt_tab_records.

*  Build Fieldcatalog
  PERFORM f_build_fieldcatalog.

*  Display ALV
  PERFORM f_display_alv USING fp_i_tab_final.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       Build Field Catalog
*----------------------------------------------------------------------*

FORM f_build_fieldcatalog .

  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv.

  CONSTANTS : lc_first_name    TYPE slis_fieldname VALUE 'FIRST_NAME',
              lc_last_name     TYPE slis_fieldname VALUE 'LAST_NAME',
              lc_email         TYPE slis_fieldname VALUE 'EMAIL',
              lc_data_ref      TYPE slis_fieldname VALUE 'EXT_DATA_REF',
              lc_salutation    TYPE slis_fieldname VALUE 'SALUTATION',
              lc_inst_name     TYPE slis_fieldname VALUE 'INST_NAME',
              lc_dept_name     TYPE slis_fieldname VALUE 'DEPT_NAME',
              lc_street        TYPE slis_fieldname VALUE 'STREET',
              lc_city          TYPE slis_fieldname VALUE 'CITY',
              lc_post_code     TYPE slis_fieldname VALUE 'POST_CODE',
              lc_country       TYPE slis_fieldname VALUE 'COUNTRY',
              lc_telephone     TYPE slis_fieldname VALUE 'TELEPHONE',
              lc_mem_num       TYPE slis_fieldname VALUE 'MEM_NUM',
              lc_society_num   TYPE slis_fieldname VALUE 'SOCIETY_NUM',
              lc_society_name  TYPE slis_fieldname VALUE 'SOCIETY_NAME',
              lc_subscrptn_num TYPE slis_fieldname VALUE 'SUBSCRPTN_NUM',
              lc_mem_cat       TYPE slis_fieldname VALUE 'MEM_CAT'.

*  Populate fieldcatalog : First Name
  lst_fieldcatalog-fieldname   = lc_first_name.
  lst_fieldcatalog-seltext_m   = 'First Name'(007).
  lst_fieldcatalog-col_pos     = 0.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Last Name
  lst_fieldcatalog-fieldname   = lc_last_name.
  lst_fieldcatalog-seltext_m   = 'Last Name'(008).
  lst_fieldcatalog-col_pos     = 1.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Email
  lst_fieldcatalog-fieldname   = lc_email.
  lst_fieldcatalog-seltext_m   = 'Primary Email'(009).
  lst_fieldcatalog-col_pos     = 2.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Email
  lst_fieldcatalog-fieldname   = lc_data_ref.
  lst_fieldcatalog-seltext_m   = 'External Data Reference'(023).
  lst_fieldcatalog-col_pos     = 3.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Salutation
  lst_fieldcatalog-fieldname   = lc_salutation.
  lst_fieldcatalog-seltext_m   = 'Salutation'(010).
  lst_fieldcatalog-col_pos     = 4.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Institution Name
  lst_fieldcatalog-fieldname   = lc_inst_name.
  lst_fieldcatalog-seltext_m   = 'Institution Name'(011).
  lst_fieldcatalog-col_pos     = 5.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Department Name
  lst_fieldcatalog-fieldname   = lc_dept_name.
  lst_fieldcatalog-seltext_m   = 'Department Name'(012).
  lst_fieldcatalog-col_pos     = 6.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Street Address
  lst_fieldcatalog-fieldname   = lc_street.
  lst_fieldcatalog-seltext_m   = 'Street Address'(013).
  lst_fieldcatalog-col_pos     = 7.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : City
  lst_fieldcatalog-fieldname   = lc_city.
  lst_fieldcatalog-seltext_m   = 'City'(014).
  lst_fieldcatalog-col_pos     = 8.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Postal Code
  lst_fieldcatalog-fieldname   = lc_post_code.
  lst_fieldcatalog-seltext_m   = 'Postal Code'(015).
  lst_fieldcatalog-col_pos     = 9.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Country
  lst_fieldcatalog-fieldname   = lc_country.
  lst_fieldcatalog-seltext_m   = 'Country'(016).
  lst_fieldcatalog-col_pos     = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Telephone
  lst_fieldcatalog-fieldname   = lc_telephone.
  lst_fieldcatalog-seltext_m   = 'Telephone'(017).
  lst_fieldcatalog-col_pos     = 11.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Member Number
  lst_fieldcatalog-fieldname   = lc_mem_num.
  lst_fieldcatalog-seltext_m   = 'Member Number'(018).
  lst_fieldcatalog-col_pos     = 12.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Society Number
  lst_fieldcatalog-fieldname   = lc_society_num.
  lst_fieldcatalog-seltext_m   = 'Society Number'(019).
  lst_fieldcatalog-col_pos     = 13.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Society Name
  lst_fieldcatalog-fieldname   = lc_society_name.
  lst_fieldcatalog-seltext_m   = 'Society Name'(020).
  lst_fieldcatalog-col_pos     = 14.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Subscription Number
  lst_fieldcatalog-fieldname   = lc_subscrptn_num.
  lst_fieldcatalog-seltext_m   = 'Subscription Number'(021).
  lst_fieldcatalog-col_pos     = 15.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog : Member Category Desc
  lst_fieldcatalog-fieldname   = lc_mem_cat.
  lst_fieldcatalog-seltext_m   = 'Member Category Desc'(022).
  lst_fieldcatalog-col_pos     = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*      Output of a simple list (single-line)
*----------------------------------------------------------------------*

FORM f_display_alv  USING fp_i_tab_final TYPE tt_tab_records.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = i_fieldcatalog[]
      i_save             = abap_true
    TABLES
      t_outtab           = fp_i_tab_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_fieldcatalog[].
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_FILE_PRES
*&---------------------------------------------------------------------*
*       Downloading file to Presentation Server
*----------------------------------------------------------------------*

FORM f_upload_file_pres  USING  fp_i_final_csv TYPE truxs_t_text_data
                                fp_p_file TYPE localfile. " Local file for upload/download


  CONSTANTS :lc_file_name  TYPE char9 VALUE 'QUALTRICS', " File_name of type CHAR9
             lc_underscore TYPE char1 VALUE '_',         " Underscore of type CHAR1
             lc_slash      TYPE char1 VALUE '/',         " Slash of type CHAR1
             lc_ext        TYPE string VALUE '.CSV',
             lc_asc        TYPE char10   VALUE 'ASC'. " Asc of type CHAR10
*** Local structure and internal table declaration
  DATA lv_file_path  TYPE string.

  CLEAR lv_file_path.
  lv_file_path = fp_p_file.

  CONCATENATE lv_file_path
              lc_slash
              lc_file_name
              lc_underscore
              sy-datum
              lc_ext
              INTO
              lv_file_path.

  CONDENSE lv_file_path NO-GAPS.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_file_path
      filetype                = lc_asc
      write_field_separator   = c_x
    TABLES
      data_tab                = fp_i_final_csv
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE e191 .
  ELSE. " ELSE -> IF sy-subrc <> 0
    MESSAGE s192.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_FILE_APP
*&---------------------------------------------------------------------*
* This perform is used to store .CSV file into application server file path
*----------------------------------------------------------------------*

FORM f_upload_file_app  USING  fp_i_final_csv TYPE truxs_t_text_data
                               fp_p_file TYPE localfile. " Local file for upload/download

  DATA: lv_fname      TYPE aco_string,      " String
        lv_file       TYPE char50,          " File of type CHAR50
        lv_length     TYPE i,               " Length of type Integers
        lv_fnm        TYPE char50,          " Fnm of type CHAR50
        lv_underscore TYPE char1 VALUE '_', " Underscore of type CHAR1
        lst_final_csv TYPE LINE OF truxs_t_text_data.

  CONSTANTS: lc_slash     TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extension TYPE char4 VALUE '.csv'. " Extension of type CHAR4

  CONCATENATE text-025 lv_underscore sy-datum INTO lv_file.

*** checking if last character of file path is / or not
*** if not then then appending one /.
  lv_fnm = fp_p_file.
  lv_length = strlen( lv_fnm ).
  lv_length = lv_length - 1.
  IF lv_fnm+lv_length(1) NE lc_slash.
    CONCATENATE lv_fnm lc_slash INTO lv_fnm.
  ENDIF. " IF lv_fnm+lv_length(1) NE lc_slash
*** Preparing file name
  CONCATENATE lv_fnm lv_file lc_extension INTO lv_fname.

  OPEN DATASET lv_fname FOR OUTPUT IN TEXT  MODE ENCODING UTF-8. " Output type
  " opening file
  IF sy-subrc NE 0. " if file not opened showing error message
    MESSAGE e045(zqtc_r2). " File cannot be opened.
    RETURN.
  ENDIF. " IF sy-subrc NE 0

  LOOP AT fp_i_final_csv  INTO lst_final_csv.
    TRANSFER lst_final_csv TO lv_fname. " transfering data
  ENDLOOP. " LOOP AT fp_i_final_csv INTO lst_final_csv

  CLOSE DATASET  lv_fname. " closing file

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_CSV
*&---------------------------------------------------------------------*
*   Preparing a CSV file
*----------------------------------------------------------------------*
*      --> fp_i_tab_final
*          fp_i_final_csv
*----------------------------------------------------------------------*
FORM f_prepare_csv  USING fp_i_tab_final TYPE tt_tab_records
                  CHANGING fp_i_final_csv TYPE truxs_t_text_data.

*** Local Constant Declaration
  CONSTANTS: lc_comma  TYPE char1 VALUE ',', " Comma of type CHAR1
             lc_semico TYPE char1 VALUE ';'. " Comma of type CHAR1

**** Local field symbol declaration
  FIELD-SYMBOLS: <lst_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        li_final_csv  TYPE truxs_t_text_data.

* Calling FM to Convert the file to CSV format
  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = lc_semico
    TABLES
      i_tab_sap_data       = fp_i_tab_final
    CHANGING
      i_tab_converted_data = li_final_csv[] " CSV file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF. " IF sy-subrc <> 0

  LOOP AT li_final_csv ASSIGNING <lst_final_csv>.
    REPLACE ALL OCCURRENCES OF lc_semico IN <lst_final_csv> WITH lc_comma.
  ENDLOOP. " LOOP AT li_final_csv ASSIGNING <lst_final_csv>

**********************************************************************
*  Header Data
**********************************************************************
  CLEAR lst_final_csv.
  CONCATENATE 'First Name'(007)
             'Last Name'(008)
             'PrimaryEmail'(H15)
             'ExternalDataReference'(H14)
             '01_Salutation'(H01)
             '02_Institution'(H02)
             '03_Department'(H03)
             '04_Street Address'(H04)
             '05_City'(H05)
             '06_Postcode'(H06)
             '07_Country'(H07)
             '08_Tel. Number'(H08)
             '09_Member Number'(H09)
             '10_Society Number'(H10)
             '11_Society'(H11)
             '12_Subscription Number'(H12)
             '13_Member Category'(H13)
              INTO lst_final_csv
              SEPARATED BY lc_comma.

  INSERT lst_final_csv INTO  li_final_csv INDEX 1. " Inserting Header

  IF li_final_csv[] IS NOT INITIAL.
    fp_i_final_csv[] = li_final_csv[].
  ENDIF. " IF li_final_csv[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHCK_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_chck_file  USING    fp_p_file TYPE localfile. " Local file for upload/download

  IF fp_p_file IS  INITIAL.

    MESSAGE e193. "Please provide file path.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF fp_p_file IS INITIAL

ENDFORM.
