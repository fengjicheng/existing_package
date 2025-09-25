*----------------------------------------------------------------------*
* PROGRAM NAME        : LZQTC_CRT_UPDT_ISSUESF0
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* All the performs has declared inside this include.
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906883
* REFERENCE NO: CR#581
* DEVELOPER: Writtick Roy(WROY)
* DATE:  2017-06-23
* DESCRIPTION: Calculate Date Fields
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K924539
* REFERENCE NO: PBOM / RPDM-2445
* DEVELOPER: Sivareddy Guda(SGUDA)
* DATE:  15-SEP-2021
* DESCRIPTION: Copy First Publication date from Publication date
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZQTC_CRT_UPDT_ISSUESF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MED_PRODUCT
*&---------------------------------------------------------------------*
*       Validate Media Product
*----------------------------------------------------------------------*
*      -->FP_ISMREFMDPROD  Media Product (Level-2)
*      <--FP_LST_MED_PROD  General Material Data (L-2)
*----------------------------------------------------------------------*
FORM f_validate_med_product  USING    fp_ismrefmdprod TYPE matnr " Material Number
                             CHANGING fp_lst_med_prod TYPE mara. " General Material Data

* Check if the Material is an Media Product (Level-2)
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = fp_ismrefmdprod "Media Product (Level-2)
    IMPORTING
      wmara             = fp_lst_med_prod "General Material Data (L-2)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc NE 0 OR
     fp_lst_med_prod-ismhierarchlevl NE con_lvl_med_prod. "Hierarchy Level (Media Product)
*   Message: Media product & does not exist
    MESSAGE e046(jpmgen) " Media product & does not exist
       WITH fp_ismrefmdprod
    RAISING exc_med_prod_invalid.
  ENDIF. " IF sy-subrc NE 0 OR

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOCK_ISSUE_SEQUENCE
*&---------------------------------------------------------------------*
*       Lock Issue Sequence (Media Product)
*----------------------------------------------------------------------*
*      -->FP_ISMREFMDPROD  Media Product (Level-2)
*----------------------------------------------------------------------*
FORM f_lock_issue_sequence  USING    fp_ismrefmdprod TYPE matnr. " Material Number

* Try to lock the Issue Sequence (Media Product)
  CALL FUNCTION 'ENQUEUE_EJPLF'
    EXPORTING
      med_prod       = fp_ismrefmdprod "Media Product (Level-2)
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
*     Nothing to do
    WHEN 1.
*     Message: Issues of media product & blocked by user &
      syst-msgv2 = syst-msgv1.                                    " User ID
      syst-msgv1 = fp_ismrefmdprod.                               " Media Product
      MESSAGE e258(jd) " Issues of media product & blocked by user &
         WITH syst-msgv1
              syst-msgv2
      RAISING exc_med_prod_locked.
    WHEN 2.
*     Message: Locking by system not possible at present
      MESSAGE e515(jd) " Locking by system not possible at present
      RAISING exc_med_prod_locked.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_MEDIA_ISSUE
*&---------------------------------------------------------------------*
*       Check if the Media Issue needs to created / changed
*----------------------------------------------------------------------*
*      -->FP_IM_MED_ISSUE_MARA  Media Issue - General Material Data from JANIS
*      -->FP_IM_MED_ISSUE_MAKT  Media Issue - Material Descriptions from JANIS
*      <--FP_LST_ISSUE_SEQ      Media Product Issue Sequence
*----------------------------------------------------------------------*
FORM f_check_media_issue  USING    fp_im_med_issue_mara TYPE zstqtc_media_issue_mara " I0344: Media Issue - General Material Data from JANIS
                                   fp_im_med_issue_makt TYPE zstqtc_media_issue_makt " I0344: Media Issue - Material Description from JANIS
                          CHANGING fp_lst_issue_seq     TYPE jptmg0.                 " IS-M: Media Product Issue Sequence

  DATA:
    lst_med_issue TYPE mara. " General Material Data

* Check if the Media Issue is already created (Level-3)
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = fp_im_med_issue_mara-matnr "Media Issue (Level-3)
    IMPORTING
      wmara             = lst_med_issue              "General Material Data (L-3)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc NE 0.
*   Move field values from Source to target Structures (General data)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_mara
                                    CHANGING fp_lst_issue_seq.

*   Move field values from Source to target Structures (Description)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_makt
                                    CHANGING fp_lst_issue_seq.

*   IS-M: Media issue being created or already exists
    fp_lst_issue_seq-xgenerate  = abap_true.
*   IS-M: Media Issue Already Exists on Database
    fp_lst_issue_seq-xmaraexist = abap_false.
*   Higher-Level Media Product
    fp_lst_issue_seq-med_prod   = fp_im_med_issue_mara-ismrefmdprod.
*   Determine Template Material for Media Product Generation
    PERFORM f_det_issue_template    USING    fp_im_med_issue_mara-ismrefmdprod
                                    CHANGING fp_lst_issue_seq-ismmatnr_pattern.

  ELSE. " ELSE -> IF sy-subrc NE 0
*   Move field values from Source to target Structures (General data)
    PERFORM f_move_source_to_target USING    lst_med_issue
                                    CHANGING fp_lst_issue_seq.
*   Move field values from Source to target Structures (Description)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_makt
                                    CHANGING fp_lst_issue_seq.

*   IS-M: Media issue being created or already exists
    fp_lst_issue_seq-xgenerate        = abap_false.
*   IS-M: Media Issue Already Exists on Database
    fp_lst_issue_seq-xmaraexist       = abap_true.
*   Higher-Level Media Product
    fp_lst_issue_seq-med_prod         = fp_im_med_issue_mara-ismrefmdprod.
*   IS-M: Template Material for Media Product Generation
    fp_lst_issue_seq-ismmatnr_pattern = fp_im_med_issue_mara-matnr.

  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVE_SOURCE_TO_TARGET
*&---------------------------------------------------------------------*
*       Move field values from Source to target Structures
*----------------------------------------------------------------------*
*      -->FP_SOURCE_STRU  Source Structure
*      <--FP_TARGET_STRU  Target Structure
*----------------------------------------------------------------------*
FORM f_move_source_to_target  USING    fp_source_stru TYPE any
                              CHANGING fp_target_stru TYPE any.

  DATA:
    lr_struct   TYPE REF TO cl_abap_structdescr. "Describe a Structure

* Get Description of data object type (Structure)
  lr_struct ?= cl_abap_typedescr=>describe_by_data( fp_target_stru ).

* Move field values from Source to target Structures  (Recursive Call)
  PERFORM f_source_to_target_recur USING    lr_struct
                                            fp_source_stru
                                   CHANGING fp_target_stru.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SOURCE_TO_TARGET_RECUR
*&---------------------------------------------------------------------*
*       Move field values from Source to target Structures  (Recursive Call)
*----------------------------------------------------------------------*
*      -->FP_LR_STRUCT    Describe a Structure
*      -->FP_SOURCE_STRU  Source Structure
*      <--FP_TARGET_STRU  Target Structure
*----------------------------------------------------------------------*
FORM f_source_to_target_recur  USING    fp_lr_struct   TYPE REF TO cl_abap_structdescr " Runtime Type Services
                                        fp_source_stru TYPE any
                               CHANGING fp_target_stru TYPE any.

  DATA:
    lr_struct   TYPE REF TO cl_abap_structdescr. "Describe a Structure

  DATA:
    li_cmpnt    TYPE abap_component_tab. "Components of a Structure

  FIELD-SYMBOLS:
    <lst_cmpnt> TYPE abap_componentdescr, "Component of a Structure
    <lv_source> TYPE any,                 "Source Field
    <lv_target> TYPE any.                 "Target Field

* Returns Component Description Table of Structure
  li_cmpnt   = fp_lr_struct->get_components( ).

* Populate existing field values
  LOOP AT li_cmpnt ASSIGNING <lst_cmpnt>.
    IF <lst_cmpnt>-as_include NE abap_true.
      ASSIGN COMPONENT <lst_cmpnt>-name OF STRUCTURE fp_target_stru TO <lv_target>.
      ASSIGN COMPONENT <lst_cmpnt>-name OF STRUCTURE fp_source_stru TO <lv_source>.
      IF <lv_source> IS ASSIGNED AND
       ( <lv_source> IS NOT INITIAL AND <lv_source> NE space ).
        <lv_target> = <lv_source>.
      ENDIF. " IF <lv_source> IS ASSIGNED AND
      UNASSIGN: <lv_source>,
                <lv_target>.
    ELSE. " ELSE -> IF <lst_cmpnt>-as_include NE abap_true
      lr_struct ?= <lst_cmpnt>-type.
*     Move field values from Source to target Structures  (Recursive Call)
      PERFORM f_source_to_target_recur USING    lr_struct
                                                fp_source_stru
                                       CHANGING fp_target_stru.
    ENDIF. " IF <lst_cmpnt>-as_include NE abap_true
  ENDLOOP. " LOOP AT li_cmpnt ASSIGNING <lst_cmpnt>

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DET_ISSUE_TEMPLATE
*&---------------------------------------------------------------------*
*       Determine Template Material for Media Product Generation
*----------------------------------------------------------------------*
*      -->FP_ISMREFMDPROD      Media Product (Level-2)
*      <--FP_ISMMATNR_PATTERN  Template Material for Media Product Generation
*----------------------------------------------------------------------*
FORM f_det_issue_template  USING    fp_ismrefmdprod     TYPE matnr  " Material Number
                           CHANGING fp_ismmatnr_pattern TYPE matnr. " Material Number

  DATA:
    lst_issue_template TYPE ty_issue_template.

  CLEAR: lst_issue_template.
  READ TABLE i_issue_template INTO lst_issue_template
       WITH KEY media_product = fp_ismrefmdprod
       BINARY SEARCH.
  IF sy-subrc NE 0.
    lst_issue_template-media_product = fp_ismrefmdprod. "Media Product

*   Fetch General Material Data
    SELECT matnr                                 "Material Number
      INTO lst_issue_template-issue_template
      FROM mara                                  " General Material Data
     UP TO 1 ROWS
     WHERE matnr           LIKE c_issue_template "Pattern: %_TEMP
       AND ismrefmdprod    EQ   fp_ismrefmdprod  "Media Product
       AND ismhierarchlevl EQ   con_lvl_med_iss. "Hierarchy Level (Media Issue)
    ENDSELECT.
    IF sy-subrc NE 0.
      CLEAR: lst_issue_template-issue_template.
    ENDIF. " IF sy-subrc NE 0
    INSERT lst_issue_template INTO TABLE i_issue_template.
  ENDIF. " IF sy-subrc NE 0

  IF lst_issue_template-issue_template IS NOT INITIAL.
    fp_ismmatnr_pattern = lst_issue_template-issue_template.
  ELSE. " ELSE -> IF lst_issue_template-issue_template IS NOT INITIAL
    CLEAR: fp_ismmatnr_pattern.
*   Message: Error: Template issue missing from generation rule
    MESSAGE e275(jpmgen) " Error: Template issue missing from generation rule
    RAISING exc_temp_issue_missing.
  ENDIF. " IF lst_issue_template-issue_template IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_MEDIA_ISSUE
*&---------------------------------------------------------------------*
*       Process Media Issue
*----------------------------------------------------------------------*
*      -->FP_IM_MED_ISSUE_MARA  Media Issue - General Material Data from JANIS
*      -->FP_IM_MED_ISSUE_MAKT  Media Issue - Material Description from JANIS
*      -->FP_IM_MED_ISSUE_MARC  Media Issue - Plant Data for Material from JANIS
*      -->FP_IM_MED_ISSUE_MVKE  Media Issue - Sales Data for Material from JANIS
*      -->FP_IM_MED_ISSUE_IDCD  Media Issue - Assignment of ID Codes from JANIS
*      -->FP_LST_MED_PROD       General Material Data (Media Product)
*      -->FP_LST_ISSUE_SEQ      Media Product Issue Sequence
*      <--FP_EX_MESSAGE_TAB     Returning Error Messages
*      <--FP_EX_IS_ERROR        Flag: If there is any Error
*----------------------------------------------------------------------*
FORM f_process_media_issue  USING    fp_im_med_issue_mara TYPE zstqtc_media_issue_mara " I0344: Media Issue - General Material Data from JANIS
                                     fp_im_med_issue_makt TYPE zstqtc_media_issue_makt " I0344: Media Issue - Material Description from JANIS
                                     fp_im_med_issue_marc TYPE zstqtc_media_issue_marc " I0344: Media Issue - Plant Data for Material from JANIS
                                     fp_im_med_issue_mvke TYPE zstqtc_media_issue_mvke " I0344: Media Issue - Sales Data for Material from JANIS
                                     fp_im_med_issue_idcd TYPE ztqtc_media_issue_idcd
                                     fp_lst_med_prod      TYPE mara                    " General Material Data
                                     fp_lst_issue_seq     TYPE jptmg0                  " IS-M: Media Product Issue Sequence
                            CHANGING fp_ex_message_tab    TYPE merrdat_tt
                                     fp_ex_is_error       TYPE flag.                   " General Flag

  DATA:
    li_mara_tab         TYPE mara_ueb_tt,       "General Material Data
    li_makt_tab         TYPE makt_ueb_tt,       "Material Descriptions
    li_marc_tab         TYPE marc_ueb_tt,       "Plant Data for Material
    li_mard_tab         TYPE mard_ueb_tt,       "Storage Location Data for Material
    li_mfhm_tab         TYPE mfhm_ueb_tt,       "Production Resource Tool (PRT) Fields in the Material Master
    li_marm_tab         TYPE marm_ueb_tt,       "Units of Measure for Material
    li_mea1_tab         TYPE mea1_ueb_tt,       "Internal Management of EANs for Material: Direct Input
    li_mbew_tab         TYPE mbew_ueb_tt,       "Material Valuation
    li_steu_tab         TYPE steu_ueb_tt,       "Tax Data Transfer
    li_stmm_tab         TYPE steumm_ueb_tt,     "Tax Data Transfer
    li_mlgn_tab         TYPE mlgn_ueb_tt,       "Material Data for Each Warehouse Number
    li_mpgd_tab         TYPE mpgd_ueb_tt,       "Change Document Structure for Material Master/Product Group
    li_mpop_tab         TYPE mpop_ueb_tt,       "Forecast Parameters
    li_mveg_tab         TYPE mveg_ueb_tt,       "Material Master Data Transfer: Total Consumption
    li_mveu_tab         TYPE mveu_ueb_tt,       "Material Master Data Transfer: Unplanned Consumption
    li_mvke_tab         TYPE mvke_ueb_tt,       "Sales Data for Material
    li_ltx1_tab         TYPE ltx1_ueb_tt,       "Data Transfer: Long Texts
    li_mprw_tab         TYPE mprw_ueb_tt,       "Data Transfer: Forecast Values
    li_mlgt_tab         TYPE mlgt_ueb_tt,       "Material Data for Each Storage Type
    li_idcode_tab       TYPE jptidcdassign_tab, "Assignment of ID Codes to Material
    li_bupa_tab         TYPE jptbupaassign_tab, "Assignment of Business Partners to Material
    li_mdma_pattern_tab TYPE tt_bapi_mdma,      "MRP Area for Material
    li_jptmara_tab      TYPE jptmara_tab,       "Media-Specific Cross-Organization Material Data

    li_errmsg           TYPE jp_merrdat_tab,    "Returning Error Messages
    li_id_errmsg        TYPE jp_merrdat_tab,    "Returning Error Messages
    li_bupa_errmsg      TYPE jp_merrdat_tab,    "Returning Error Messages
    li_cacl_errmsg      TYPE jp_merrdat_tab,    "Returning Error Messages
    li_mdma_errmsg      TYPE jp_merrdat_tab,    "Returning Error Messages
    li_jptmara_errmsg   TYPE jp_merrdat_tab.    "Returning Error Messages

  DATA:
    lv_number_errors_tr TYPE bierrnum. "Number of incorrect data records

* Prepare for creating Media Issue (fetch details from Issue Template)
  PERFORM mara_sichern_prepare IN PROGRAM rjpmpgen IF FOUND
   TABLES li_mara_tab         "General Material Data
          li_makt_tab         "Material Descriptions
          li_marc_tab         "Plant Data for Material
          li_mard_tab         "Storage Location Data for Material
          li_mfhm_tab         "Production Resource Tool (PRT) Fields in the Material Master
          li_marm_tab         "Units of Measure for Material
          li_mea1_tab         "Internal Management of EANs for Material: Direct Input
          li_mbew_tab         "Material Valuation
          li_steu_tab         "Tax Data Transfer
          li_stmm_tab         "Tax Data Transfer
          li_mlgn_tab         "Material Data for Each Warehouse Number
          li_mpgd_tab         "Change Document Structure for Material Master/Product Group
          li_mpop_tab         "Forecast Parameters
          li_mveg_tab         "Material Master Data Transfer: Total Consumption
          li_mveu_tab         "Material Master Data Transfer: Unplanned Consumption
          li_mvke_tab         "Sales Data for Material
          li_ltx1_tab         "Data Transfer: Long Texts
          li_mprw_tab         "Data Transfer: Forecast Values
          li_mlgt_tab         "Material Data for Each Storage Type
          li_idcode_tab       "Assignment of ID Codes to Material
          li_bupa_tab         "Assignment of Business Partners to Material
          li_mdma_pattern_tab "MRP Area for Material
    USING fp_lst_med_prod     "General Material Data (Media Product)
          fp_lst_issue_seq    "Media Product Issue Sequence
 CHANGING li_jptmara_tab.     "Media-Specific Cross-Organization Material Data

* Begin of ADD:CR#581:WROY:23-JUN-2017:ED2K906883
* Calculate Date Fields
  PERFORM f_calculate_dates    USING    fp_lst_issue_seq     "Media Product Issue Sequence
                                        fp_im_med_issue_mara "Media Issue - General Material Data from JANIS
                               CHANGING li_marc_tab.         "Plant Data for Material
* End   of ADD:CR#581:WROY:23-JUN-2017:ED2K906883

* Populate field values from Source System
  PERFORM f_pop_source_values  USING    fp_im_med_issue_mara "Media Issue - General Material Data from JANIS
                                        fp_im_med_issue_marc "Media Issue - Plant Data for Material from JANIS
                                        fp_im_med_issue_mvke "Media Issue - Sales Data for Material from JANIS
                                        fp_im_med_issue_idcd "Media Issue - Assignment of ID Codes from JANIS
                               CHANGING li_mara_tab          "General Material Data
                                        li_marc_tab          "Plant Data for Material
                                        li_mvke_tab          "Sales Data for Material
                                        li_idcode_tab.       "Assignment of ID Codes to Material

* Populate Transaction Code (Change Scenario)
  PERFORM f_populate_tcode     USING    fp_lst_issue_seq "Media Product Issue Sequence
                               CHANGING li_mara_tab.     "General Material Data
* Begin of ADD:PBOM/RPDM-2445:SGUDA:15-SEP-2021:ED2K924539
  DATA : lv_index TYPE sy-tabix.
  LOOP AT li_mara_tab INTO DATA(lst_mara_tab).
    lv_index = sy-tabix.
* Checking First pub date and Pub date are same or not, if not same
    IF lst_mara_tab-ismpubldate NE lst_mara_tab-ismfrstpubldate.
* if not same, copy first Pub date with Pub date
      lst_mara_tab-ismfrstpubldate = lst_mara_tab-ismpubldate.
      MODIFY li_mara_tab FROM lst_mara_tab INDEX lv_index TRANSPORTING ismfrstpubldate.
    ENDIF.
    CLEAR:lst_mara_tab,lv_index.
  ENDLOOP.
* End of ADD:PBOM/RPDM-2445:SGUDA:15-SEP-2021:ED2K924539
* Create Media Issue (combination of Issue Template and Source System field values)
  PERFORM mara_sichern IN PROGRAM rjpmpgen IF FOUND
   TABLES li_errmsg           "Returning Error Messages
          li_mara_tab         "General Material Data
          li_makt_tab         "Material Descriptions
          li_marc_tab         "Plant Data for Material
          li_mard_tab         "Storage Location Data for Material
          li_mfhm_tab         "Production Resource Tool (PRT) Fields in the Material Master
          li_marm_tab         "Units of Measure for Material
          li_mea1_tab         "Internal Management of EANs for Material: Direct Input
          li_mbew_tab         "Material Valuation
          li_steu_tab         "Tax Data Transfer
          li_stmm_tab         "Tax Data Transfer
          li_mlgn_tab         "Material Data for Each Warehouse Number
          li_mpgd_tab         "Change Document Structure for Material Master/Product Group
          li_mpop_tab         "Forecast Parameters
          li_mveg_tab         "Material Master Data Transfer: Total Consumption
          li_mveu_tab         "Material Master Data Transfer: Unplanned Consumption
          li_mvke_tab         "Sales Data for Material
          li_ltx1_tab         "Data Transfer: Long Texts
          li_mprw_tab         "Data Transfer: Forecast Values
          li_mlgt_tab         "Material Data for Each Storage Type
          li_idcode_tab       "Assignment of ID Codes to Material
          li_bupa_tab         "Assignment of Business Partners to Material
          li_mdma_pattern_tab "MRP Area for Material
    USING abap_false          "Flag: Test run
          fp_lst_issue_seq    "Media Product Issue Sequence
          li_jptmara_tab      "Media-Specific Cross-Organization Material Data
 CHANGING lv_number_errors_tr "Number of incorrect data records
          li_id_errmsg        "Returning Error Messages
          li_jptmara_errmsg   "Returning Error Messages
          li_bupa_errmsg      "Returning Error Messages
          li_cacl_errmsg      "Returning Error Messages
          li_mdma_errmsg.     "Returning Error Messages

* Collect Messages
  LOOP AT li_errmsg ASSIGNING FIELD-SYMBOL(<lst_errmsg>).
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_errmsg ASSIGNING FIELD-SYMBOL(<lst_errmsg>)
  LOOP AT li_id_errmsg ASSIGNING <lst_errmsg>.
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_id_errmsg ASSIGNING <lst_errmsg>
  LOOP AT li_bupa_errmsg ASSIGNING <lst_errmsg>.
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_bupa_errmsg ASSIGNING <lst_errmsg>
  LOOP AT li_cacl_errmsg ASSIGNING <lst_errmsg>.
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_cacl_errmsg ASSIGNING <lst_errmsg>
  LOOP AT li_mdma_errmsg ASSIGNING <lst_errmsg>.
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_mdma_errmsg ASSIGNING <lst_errmsg>
  LOOP AT li_jptmara_errmsg ASSIGNING <lst_errmsg>.
    APPEND <lst_errmsg> TO fp_ex_message_tab.
  ENDLOOP. " LOOP AT li_jptmara_errmsg ASSIGNING <lst_errmsg>

* Save / Rollback DB records
  IF lv_number_errors_tr IS INITIAL.
    COMMIT WORK.
  ELSE. " ELSE -> IF lv_number_errors_tr IS INITIAL
    fp_ex_is_error = abap_true.
    ROLLBACK WORK.
  ENDIF. " IF lv_number_errors_tr IS INITIAL

* Unlock everything
  CALL FUNCTION 'DEQUEUE_ALL'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_SOURCE_VALUES
*&---------------------------------------------------------------------*
*       Populate field values from Source System
*----------------------------------------------------------------------*
*      -->FP_IM_MED_ISSUE_MARA  Media Issue - General Material Data from JANIS
*      -->FP_IM_MED_ISSUE_MARC  Media Issue - Plant Data for Material from JANIS
*      -->FP_IM_MED_ISSUE_MVKE  Media Issue - Sales Data for Material from JANIS
*      -->FP_IM_MED_ISSUE_IDCD  Media Issue - Assignment of ID Codes from JANIS
*      <--FP_LI_MARA_TAB        General Material Data
*      <--FP_LI_MARC_TAB        Plant Data for Material
*      <--FP_LI_MVKE_TAB        Sales Data for Material
*      <--FP_LI_IDCODE_TAB      Assignment of ID Codes to Material
*----------------------------------------------------------------------*
FORM f_pop_source_values  USING    fp_im_med_issue_mara TYPE zstqtc_media_issue_mara " I0344: Media Issue - General Material Data from JANIS
                                   fp_im_med_issue_marc TYPE zstqtc_media_issue_marc " I0344: Media Issue - Plant Data for Material from JANIS
                                   fp_im_med_issue_mvke TYPE zstqtc_media_issue_mvke " I0344: Media Issue - Sales Data for Material from JANIS
                                   fp_im_med_issue_idcd TYPE ztqtc_media_issue_idcd
                          CHANGING fp_li_mara_tab       TYPE mara_ueb_tt
                                   fp_li_marc_tab       TYPE marc_ueb_tt
                                   fp_li_mvke_tab       TYPE mvke_ueb_tt
                                   fp_li_idcode_tab     TYPE jptidcdassign_tab.

* General Material Data
  LOOP AT fp_li_mara_tab ASSIGNING FIELD-SYMBOL(<lst_mara>).
*   Move field values from Source to target Structures (General data)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_mara
                                    CHANGING <lst_mara>.
  ENDLOOP. " LOOP AT fp_li_mara_tab ASSIGNING FIELD-SYMBOL(<lst_mara>)

* Plant Data for Material
  LOOP AT fp_li_marc_tab ASSIGNING FIELD-SYMBOL(<lst_marc>).
*   Move field values from Source to target Structures (Plant Data for Material)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_marc
                                    CHANGING <lst_marc>.
  ENDLOOP. " LOOP AT fp_li_marc_tab ASSIGNING FIELD-SYMBOL(<lst_marc>)

* Sales Data for Material
  LOOP AT fp_li_mvke_tab ASSIGNING FIELD-SYMBOL(<lst_mvke>).
*   Move field values from Source to target Structures (Sales Data for Material)
    PERFORM f_move_source_to_target USING    fp_im_med_issue_mvke
                                    CHANGING <lst_mvke>.
  ENDLOOP. " LOOP AT fp_li_mvke_tab ASSIGNING FIELD-SYMBOL(<lst_mvke>)

* Assignment of ID Codes to Material
  LOOP AT fp_im_med_issue_idcd ASSIGNING FIELD-SYMBOL(<lst_idcd>).
    READ TABLE fp_li_idcode_tab ASSIGNING FIELD-SYMBOL(<lst_idcode>)
         WITH KEY idcodetype = <lst_idcd>-idcodetype.
    IF sy-subrc EQ 0.
*     Move field values from Source to target Structures (Assignment of ID Codes to Material)
      PERFORM f_move_source_to_target USING    <lst_idcd>
                                      CHANGING <lst_idcode>.
    ELSE. " ELSE -> IF sy-subrc EQ 0
*     Create a New Entry (Assignment of ID Codes to Material)
      APPEND INITIAL LINE TO fp_li_idcode_tab ASSIGNING <lst_idcode>.
      MOVE-CORRESPONDING <lst_idcd> TO <lst_idcode>.
      <lst_idcode>-matnr = fp_im_med_issue_mara-matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT fp_im_med_issue_idcd ASSIGNING FIELD-SYMBOL(<lst_idcd>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MISSING_STRUCS
*&---------------------------------------------------------------------*
*       Fetch details of missing structures (not fetched by standard logic)
*----------------------------------------------------------------------*
*      -->FP_LST_ISSUE_SEQ  Media Product Issue Sequence
*      -->FP_LI_MARC_TAB    Plant Data for Material
*      <--FP_LI_MPOP_TAB    Forecast Parameters
*----------------------------------------------------------------------*
FORM f_get_missing_strucs  USING    fp_lst_issue_seq TYPE jptmg0 " IS-M: Media Product Issue Sequence
                                    fp_li_marc_tab   TYPE marc_ueb_tt "Plant Data for Material
                           CHANGING fp_li_mpop_tab   TYPE mpop_ueb_tt.

  DATA:
    li_mvop_tab TYPE STANDARD TABLE OF mvop INITIAL SIZE 0. " Material data material versions

  DATA:
    lst_forecst TYPE mpop.

  IF fp_li_mpop_tab IS INITIAL.
*   Fetch Material Index for Forecast
    SELECT werks,                                                "Plant
           matnr                                                 "Material Number
      FROM mapr
      INTO TABLE @DATA(li_mapr)
     WHERE matnr = @fp_lst_issue_seq-ismmatnr_pattern.           "IS-M: Template Material for Media Product Generation
    IF sy-subrc EQ 0.
      LOOP AT li_mapr ASSIGNING FIELD-SYMBOL(<lst_mapr>).
*       Fetch Forecast Parameters
        CLEAR: lst_forecst.
        CALL FUNCTION 'MPOP_SINGLE_READ'
          EXPORTING
            matnr      = <lst_mapr>-matnr                        "Material Number
            werks      = <lst_mapr>-werks                        "Plant
          IMPORTING
            wmpop      = lst_forecst                             "Forecast Parameters
          EXCEPTIONS
            not_found  = 1
            wrong_call = 2
            OTHERS     = 3.
        IF sy-subrc EQ 0.
          APPEND INITIAL LINE TO fp_li_mpop_tab ASSIGNING FIELD-SYMBOL(<lst_mpop>).
          MOVE-CORRESPONDING lst_forecst TO <lst_mpop>.
          <lst_mpop>-matnr = fp_lst_issue_seq-matnr.
*         Get the Transaction counter for data transfer
*         BINARY SEARCH not used, sine there will be very limited number of entres (less that 20)
          READ TABLE fp_li_marc_tab ASSIGNING FIELD-SYMBOL(<lst_marc>)
               WITH KEY matnr = <lst_mpop>-matnr
                        werks = <lst_mpop>-werks.
          IF sy-subrc EQ 0.
            <lst_mpop>-tranc = <lst_marc>-tranc.
          ENDIF.

          UNASSIGN: <lst_mpop>.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF. " IF fp_li_mpop_tab IS INITIAL

  i_mpop_tab[] = fp_li_mpop_tab[]. "Forecast Parameters

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_GLOBAL_VARS
*&---------------------------------------------------------------------*
*       Initialize Global Variables
*----------------------------------------------------------------------*
*  -->  No Parameter
*  <--  No Parameter
*----------------------------------------------------------------------*
FORM f_init_global_vars .

  CLEAR:
    i_mpop_tab,
    v_update_ind.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_TCODE
*&---------------------------------------------------------------------*
*       Populate Transaction Code (Change Scenario)
*----------------------------------------------------------------------*
*      -->FP_LST_ISSUE_SEQ  Media Product Issue Sequence
*      <--FP_LI_MARA_TAB    Material General Data
*----------------------------------------------------------------------*
FORM f_populate_tcode  USING    fp_lst_issue_seq TYPE jptmg0 " IS-M: Media Product Issue Sequence
                       CHANGING fp_li_mara_tab   TYPE mara_ueb_tt.

* Change scenario: Media Issue is same as the Template Material for
* Media Product Generation
  IF fp_lst_issue_seq-matnr EQ fp_lst_issue_seq-ismmatnr_pattern.
    LOOP AT fp_li_mara_tab ASSIGNING FIELD-SYMBOL(<lst_mara>).
      <lst_mara>-tcode = con_med_issue_change.             "Transaction Code: Media Issue Change (JP28)
    ENDLOOP.
    v_update_ind = abap_true.                              "Update indicator
  ENDIF.

ENDFORM.
* Begin of ADD:CR#581:WROY:23-JUN-2017:ED2K906883
*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_DATES
*&---------------------------------------------------------------------*
*       Calculate Date Fields
*----------------------------------------------------------------------*
*      -->FP_IM_MED_ISSUE_MARA  Media Issue - General Material Data from JANIS
*      -->FP_LST_ISSUE_SEQ      IS-M: Media Product Issue Sequence
*      <--FP_LI_MARC_TAB        Plant Data for Material
*----------------------------------------------------------------------*
FORM f_calculate_dates  USING    fp_lst_issue_seq     TYPE jptmg0                  " IS-M: Media Product Issue Sequence
                                 fp_im_med_issue_mara TYPE zstqtc_media_issue_mara " I0344: Media Issue - General Material Data from JANIS
                        CHANGING fp_li_marc_tab       TYPE marc_ueb_tt.

  DATA:
    li_makt_tab_pattern TYPE makt_ueb_tt,       "Material Descriptions
    li_marc_tab_pattern TYPE marc_ueb_tt,       "Plant Data for Material
    li_mard_tab_pattern TYPE mard_ueb_tt,       "Storage Location Data for Material
    li_mfhm_tab_pattern TYPE mfhm_ueb_tt,       "Production Resource Tool (PRT) Fields in the Material Master
    li_marm_tab_pattern TYPE marm_ueb_tt,       "Units of Measure for Material
    li_mea1_tab_pattern TYPE mea1_ueb_tt,       "Internal Management of EANs for Material: Direct Input
    li_mbew_tab_pattern TYPE mbew_ueb_tt,       "Material Valuation
    li_steu_tab_pattern TYPE steu_ueb_tt,       "Tax Data Transfer
    li_stmm_tab_pattern TYPE steumm_ueb_tt,     "Tax Data Transfer
    li_mlgn_tab_pattern TYPE mlgn_ueb_tt,       "Material Data for Each Warehouse Number
    li_mpgd_tab_pattern TYPE mpgd_ueb_tt,       "Change Document Structure for Material Master/Product Group
    li_mpop_tab_pattern TYPE mpop_ueb_tt,       "Forecast Parameters
    li_mveg_tab_pattern TYPE mveg_ueb_tt,       "Material Master Data Transfer: Total Consumption
    li_mveu_tab_pattern TYPE mveu_ueb_tt,       "Material Master Data Transfer: Unplanned Consumption
    li_mvke_tab_pattern TYPE mvke_ueb_tt,       "Sales Data for Material
    li_ltx1_tab_pattern TYPE ltx1_ueb_tt,       "Data Transfer: Long Texts
    li_mprw_tab_pattern TYPE mprw_ueb_tt,       "Data Transfer: Forecast Values
    li_mlgt_tab_pattern TYPE mlgt_ueb_tt,       "Material Data for Each Storage Type
    li_mdma_tab_pattern TYPE tt_bapi_mdma.      "MRP Area for Material

  DATA:
    lst_issue_seq       TYPE jpmg0,             "Media Product Publication Calendar: Attributes
    lst_mara_pattern    TYPE mara,              "General Material Data
    lst_jptmara_pattern TYPE jptmara.           "Media-Specific Cross-Organization Material Data

  IF fp_lst_issue_seq-ismmatnr_pattern    EQ fp_lst_issue_seq-matnr OR  "Scenario: CHANGE
     fp_im_med_issue_mara-isminitshipdate IS INITIAL.                   "Initial Shipping Date is not provided
    RETURN.
  ENDIF.

* Media Product Publication Calendar: Attributes
  MOVE-CORRESPONDING fp_lst_issue_seq TO lst_issue_seq.
* Fetch details of Template Material for Media Product Generation
  PERFORM pattern_read IN PROGRAM sapljpmm01 IF FOUND
   TABLES li_makt_tab_pattern
          li_marc_tab_pattern
          li_mvke_tab_pattern
          li_mard_tab_pattern
          li_mfhm_tab_pattern
          li_marm_tab_pattern
          li_mea1_tab_pattern
          li_mbew_tab_pattern
          li_mlgn_tab_pattern
          li_mlgt_tab_pattern
          li_mpgd_tab_pattern
          li_mpop_tab_pattern
          li_mveg_tab_pattern
          li_mveu_tab_pattern
          li_ltx1_tab_pattern
          li_mprw_tab_pattern
          li_steu_tab_pattern
          li_stmm_tab_pattern
          li_mdma_tab_pattern
    USING lst_issue_seq
 CHANGING lst_mara_pattern
          lst_jptmara_pattern.

  SORT li_marc_tab_pattern BY werks.

  LOOP AT fp_li_marc_tab ASSIGNING FIELD-SYMBOL(<lst_marc>).
    READ TABLE li_marc_tab_pattern ASSIGNING FIELD-SYMBOL(<lst_marc_pattern>)
         WITH KEY werks = <lst_marc>-werks
         BINARY SEARCH.
    IF sy-subrc EQ 0.
*     Material Staging/Availability Date
      IF <lst_marc_pattern>-ismavaildate IS INITIAL OR
         <lst_marc_pattern>-ismavaildate EQ space.
        CLEAR: <lst_marc>-ismavaildate.
      ENDIF.
*     Planned Goods Arrival Date
      IF <lst_marc_pattern>-ismarrivaldatepl IS INITIAL OR
         <lst_marc_pattern>-ismarrivaldatepl EQ space.
        CLEAR: <lst_marc>-ismarrivaldatepl.
      ENDIF.
*     Latest Possible Purchase Order Date
      IF <lst_marc_pattern>-ismpurchasedate IS INITIAL OR
         <lst_marc_pattern>-ismpurchasedate EQ space.
        CLEAR: <lst_marc>-ismpurchasedate.
      ELSE.
        <lst_marc>-ismpurchasedate = fp_im_med_issue_mara-isminitshipdate -
                                   ( lst_mara_pattern-isminitshipdate - <lst_marc_pattern>-ismpurchasedate ).
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
* End   of ADD:CR#581:WROY:23-JUN-2017:ED2K906883
