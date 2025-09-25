*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_NEW_PROJECTMASTER_JANIS
* PROGRAM DESCRIPTION: Create Maintain Media Product Master Records
* This include has been called inside program ZQTCE_NEW_PROJECTMASTER_JANIS,
* All the Forms has declared inside this.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-02-02
* OBJECT ID:E148
* TRANSPORT NUMBER(S):ED2K904337
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907205
* REFERENCE NO: ERP-3138
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-07-10
* DESCRIPTION: Populate Initial Shipping Date on WBS element instead of
* Publication Date.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907527, ED1K907678
* REFERENCE NO: INC0196438
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE:  2018-05-28
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908492
* REFERENCE NO: DM-1479
* DEVELOPER: AGUDURKHAD
* DATE:  2018-09-19
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PROJECTMASTER_JANIS_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       Clear All the variables
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_clear_all .

  CLEAR: i_message[].

  CLEAR : v_matnr,
          v_old_wbs,
          v_success,
          v_ismrefmdprod,
          v_mtart.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*        Populate Selection Screen Default Values
*----------------------------------------------------------------------*
*      <--FP_S_MTYP_I  Material Type (Media Issue)
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_mtyp_i TYPE cfb_t_mtart_range. " Structure for Range Table for Data Element MTART

* Material Type (Media Issue)
  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING FIELD-SYMBOL(<lst_mtyp_i>).
  <lst_mtyp_i>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjip. "Material Type: ZJIP
  <lst_mtyp_i>-high   = space.

  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING <lst_mtyp_i>.
  <lst_mtyp_i>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjid. "Material Type: ZJID
  <lst_mtyp_i>-high   = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_TYPE
*&---------------------------------------------------------------------*
*       Validate Material Type
*----------------------------------------------------------------------*
*      -->P_S_MTYP_I[]  Material Type
*----------------------------------------------------------------------*
FORM f_validate_mat_type  USING   fp_s_mtyp_i TYPE cfb_t_mtart_range.

** Material Types
  SELECT mtart " Material Type
  FROM t134    " Material Types
    UP TO 1 ROWS
   INTO @DATA(lv_mtart)
   WHERE mtart IN @fp_s_mtyp_i.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid material type; check your entry
    MESSAGE e084(ob). " Invalid material type,check your entry
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MEDIA_ISSUE
*&---------------------------------------------------------------------*
*       Validate Media Issue
*----------------------------------------------------------------------*
*  -->  FP_S_ISSUE       Media Issue
*----------------------------------------------------------------------*
FORM f_validate_media_issue USING fp_s_issue TYPE fip_t_matnr_range.

  SELECT SINGLE matnr " Material Number
    FROM mara         " General Material Data
    INTO @DATA(lv_matnr)
    WHERE matnr IN @fp_s_issue.
  IF sy-subrc IS NOT INITIAL.
*   Message: Invalid Media Issue,Please re-enter.
    MESSAGE e120(zqtc_r2). " Invalid Media Issue,Please re-enter.
  ENDIF. " IF sy-subrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MEDIA_PRODUCT
*&---------------------------------------------------------------------*
*       Invalid Media Product
*----------------------------------------------------------------------*
*      -->FP_S_PROD   Media Product
*----------------------------------------------------------------------*
FORM f_validate_media_product  USING    fp_s_prod TYPE fip_t_matnr_range.

  SELECT SINGLE matnr " Material Number
    FROM mara         " General Material Data
    INTO @DATA(lv_matnr)
    WHERE matnr IN @fp_s_prod.
  IF sy-subrc IS NOT INITIAL.
*    Message: Invalid Media product,Please re-enter.
    MESSAGE e121(zqtc_r2). " Invalid Media product,Please re-enter.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*      Fetch and process selected records
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_fetch_n_process .

* Local Variable Declaration
  DATA: lv_curr_date        TYPE sydatum,   "Current/To Date
        lv_curr_time        TYPE syuzeit,   "Current/To Time
        lv_from_date        TYPE sydatum,   "From Date
        lv_from_time        TYPE syuzeit,   "From Time
        lv_proj_name        TYPE zlegproj,  " Legacy Project Number
        lv_pspid_e          TYPE ps_pspid,  " Project Definition
        lv_proj_old         TYPE zlegproj , " Project Definition
        lv_proj_defn        TYPE ps_pspid,  " Project Definition
        lv_proj_defn_i      TYPE ps_pspid,  " Project Definition
        lv_ismrefmdprod_old TYPE matnr,     " Material Number
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lv_ismcopynr_old    TYPE ismheftnummer, " Copy Number of Media Issue
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lv_id               TYPE char2, " Id of type CHAR2
        lv_no               TYPE char6. " No of type CHAR6

* Local Variable
  DATA : lv_flag_status TYPE char1 VALUE abap_false. " Status of type CHAR1

* Local Constant Declaration
  CONSTANTS :  lc_sign           TYPE char1 VALUE '.', " Sign of type CHAR1
               lc_struc_proj_def TYPE te_struc VALUE 'BAPI_TE_PROJECT_DEFINITION'. " Structure name of  BAPI table extension

* local Work Area Declaration
  DATA: lst_project          TYPE bapi_bus2001_new,           " Data Structure: Create Project Definition
        lst_extensionin      TYPE bapiparex,                  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_valuepart1       TYPE bapi_te_project_definition, " Customer Enhancement to Project Definition (CI_PROJ)
        lst_message          TYPE ty_message,
        lst_detrm_costc_prod TYPE ty_detrm_costc,             " Determine cost center on the basis of profit center n Plant
        lst_t001_prod        TYPE ty_t001,
        lst_csks_prod        TYPE ty_csks,
        lst_mvke_prod        TYPE ty_mvke,
        lst_marc_prod        TYPE ty_marc,
        lst_return           TYPE bapiret2.                   " Return Parameter

* Local Internal Table Declaration
  DATA:  li_mara        TYPE tt_mara,            "Media Issues
         li_marc        TYPE tt_marc,
         li_mvke        TYPE tt_mvke,
         li_mara_issue  TYPE tt_mara,
         li_detrm_costc TYPE tt_detrm_costc,
         li_csks        TYPE tt_csks,
         li_t001        TYPE tt_t001,
         li_prps        TYPE tt_prps,
         li_makt_prod   TYPE tt_makt,            " Material Descriptions
         li_return      TYPE TABLE OF bapiret2,  " Return Parameter
         li_extensionin TYPE TABLE OF bapiparex, " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
         li_prps_zzmpm  TYPE STANDARD TABLE OF ty_prps INITIAL SIZE 0,
         li_proj        TYPE STANDARD TABLE OF ty_proj INITIAL SIZE 0,
         li_proj_name   TYPE STANDARD TABLE OF ty_proj_name INITIAL SIZE 0.

* Consider all Materials where material type is ZJID
* and ZJIP and created / last updated date should be greater than
* last interface run date which is stored in the constant table (ZCAINTERFACE).
  IF rb_backg IS NOT INITIAL.

    lv_curr_date = sy-datum.
    lv_curr_time = sy-uzeit.

* Get last run details (Date and Time)
    PERFORM f_get_last_run_details CHANGING lv_from_date
                                            lv_from_time.

* Fetch Records being Created / Changed in Mara
    CLEAR li_mara[].
    PERFORM f_fetch_records_mara  USING s_mtyp_i[]
                                        lv_from_date
                                        lv_curr_date
                               CHANGING li_mara.

  ELSE. " ELSE -> IF rb_backg IS NOT INITIAL
* Fetch Records being Created/Changed in MARA
* When Manual Execution is selected.
    CLEAR li_mara[].
    PERFORM f_fetch_records_mara_manual  USING   s_mtyp_i[]
                                                 s_issue[]
                                                 s_prod[]
                                       CHANGING li_mara.
  ENDIF. " IF rb_backg IS NOT INITIAL


  CLEAR li_mara_issue[].
  li_mara_issue[]   = li_mara[].

  IF li_mara_issue IS NOT INITIAL.
* Checking if MPM issue is associated with a WBS element, by going to the PRPS table
* and entering MPM number in PRPS-ZZMPM.


* Concatenation of Product MATNR and Volume number from step 2 is
* assigned to any project definition in PROJ-ZZLEG_PROJ field.
    LOOP AT li_mara_issue ASSIGNING FIELD-SYMBOL(<lst_mara_issue>).
      APPEND INITIAL LINE TO li_proj_name ASSIGNING FIELD-SYMBOL(<lst_proj>).
      MOVE-CORRESPONDING <lst_mara_issue> TO <lst_proj>.
      CONCATENATE <lst_mara_issue>-ismrefmdprod <lst_mara_issue>-ismcopynr INTO <lst_proj>-proj_name.
    ENDLOOP. " LOOP AT li_mara_issue ASSIGNING FIELD-SYMBOL(<lst_mara_issue>)

* Check if concatenation of Product MATNR and Volume number from step 2 is assigned
* to any project definition in PROJ-ZZLEG_PROJ field. If not then program needs to
* create a new project definition.
    PERFORM f_get_data_proj USING li_proj_name
                            CHANGING li_proj.

* Checking if MPM issue is associated with a WBS element, by going to the PRPS table
* and entering MPM number in PRPS-ZZMPM.
    PERFORM f_get_data_prps USING  li_mara_issue
                                   li_proj
                          CHANGING li_prps
                                   li_prps_zzmpm.

* Get the product description from MAKT and Journal Code from table JPTIDCDASSIGN
    PERFORM f_get_data_makt USING li_mara_issue
                            CHANGING li_makt_prod.

* Get the Profit center from table MARC
    PERFORM f_get_data_marc USING  li_mara_issue
                            CHANGING li_marc.

* Get the Delivering plant from table MVKE
    PERFORM f_get_data_mvke USING li_mara_issue
                            CHANGING li_mvke.

* Get the cost center from Table ZQTC_DETERM_COSTC
    PERFORM f_get_cost_center    USING li_mvke
                                       li_marc
                              CHANGING  li_mara_issue
                                        li_detrm_costc.

* Get the company code from table CSKS
    PERFORM f_get_company_code USING li_detrm_costc
                               CHANGING li_csks.

*  Get the Currency Key from table T001
    PERFORM f_get_currency_key USING li_csks
                               CHANGING li_t001.

* Get the project defination
    PERFORM f_get_project_defination CHANGING lv_pspid_e.


    SORT li_mara_issue BY ismrefmdprod ismcopynr.

    LOOP AT li_mara_issue ASSIGNING <lst_mara_issue>.

      CLEAR lv_flag_status.
      IF <lst_mara_issue>-ismcopynr IS NOT INITIAL.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        IF lv_ismrefmdprod_old  <> <lst_mara_issue>-ismrefmdprod OR
           lv_ismcopynr_old     <> <lst_mara_issue>-ismcopynr.
          CLEAR: v_old_wbs,
                 v_old_wbs2.

          lv_ismcopynr_old = <lst_mara_issue>-ismcopynr. " Copy Number of Media Issue
        ENDIF. " IF lv_ismrefmdprod_old <> <lst_mara_issue>-ismrefmdprod OR
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527

        IF lv_ismrefmdprod_old  <> <lst_mara_issue>-ismrefmdprod.

          READ TABLE li_prps ASSIGNING FIELD-SYMBOL(<lst_prps>)
                                             WITH KEY zzmpm = <lst_mara_issue>-ismrefmdprod
                                             BINARY SEARCH.
          IF sy-subrc EQ 0.
*   Record is for change project or Change WBS.
*&---------------------------------------------------------------------*
            PERFORM f_change_level1_wbs USING <lst_mara_issue>
*                                               li_prps
                                              <lst_prps> " changing project/WBS
                                               li_mvke
                                               li_marc
                                               li_detrm_costc
                                               li_csks
                                               li_t001
                                               li_makt_prod
                                     CHANGING lv_flag_status.
*Begin of Change:INC0196438:WROY:13-JUNE-2018:ED1K907678
*           lv_ismrefmdprod_old = <lst_mara_issue>-ismrefmdprod.
*Begin of Change:INC0196438:WROY:13-JUNE-2018:ED1K907678
          ENDIF. " IF sy-subrc EQ 0
*Begin of Change:INC0196438:WROY:13-JUNE-2018:ED1K907678
          lv_ismrefmdprod_old = <lst_mara_issue>-ismrefmdprod.
*Begin of Change:INC0196438:WROY:13-JUNE-2018:ED1K907678
        ENDIF. " IF lv_ismrefmdprod_old <> <lst_mara_issue>-ismrefmdprod
* Check if MPM issue in SAP is associated with a WBS element,
* by going to the PRPS table and entering MPM number in PRPS-ZZMPM.
* If the value exists, the MPM issue has already been assigned to a WBS element
        READ TABLE li_prps ASSIGNING <lst_prps>
                           WITH KEY zzmpm = <lst_mara_issue>-matnr
                           BINARY SEARCH.
        IF sy-subrc EQ 0.
*   Record is for change project or Change WBS.
*&---------------------------------------------------------------------*
          PERFORM f_change_level2_wbs USING <lst_mara_issue>
*                                            li_prps
                                           <lst_prps> " changing project/WBS
                                           li_detrm_costc
                                           li_csks
                                           li_t001
                                           li_makt_prod
                                   CHANGING lv_flag_status.
        ELSE. " ELSE -> IF sy-subrc EQ 0

*   There is no assignment of MPM with a WBS element and the MPM issue is a new record
          CONCATENATE <lst_mara_issue>-ismrefmdprod <lst_mara_issue>-ismcopynr INTO lv_proj_name.
*   Checking the project exist or not
          UNASSIGN <lst_proj>.
          READ TABLE li_proj ASSIGNING FIELD-SYMBOL(<lst_proj_1>) WITH KEY zzleg_proj = lv_proj_name
                                                                           BINARY SEARCH.
          IF sy-subrc EQ 0. "this is a existing project
            PERFORM f_add_issue USING <lst_mara_issue>
                                      <lst_proj_1> " adding issue to existing project\
                                      li_detrm_costc
                                      li_csks
                                      li_t001
                                      li_prps_zzmpm
                            CHANGING  lv_proj_defn
                                      lv_flag_status.

            IF lv_flag_status = abap_false.
              v_success = abap_true.
              lst_message-pspid = lv_proj_defn.
              lst_message-message = text-007.
              lst_message-matnr = <lst_mara_issue>-matnr.
              APPEND lst_message TO i_message.
              CLEAR lst_message.
            ENDIF. " IF lv_flag_status = abap_false

          ELSE. " ELSE -> IF sy-subrc EQ 0

* Create new project
*&---------------------------------------------------------------------*
            IF  lv_proj_name = lv_proj_old. " this WBS is for same Project definition
              " Update WBS Elements
              PERFORM f_update_wbs USING lv_proj_defn
                                        <lst_mara_issue>
*                                        lst_detrm_costc
*                                        lst_csks
*                                        lst_t001
                                         li_mvke
                                         li_marc
                                         li_detrm_costc
                                         li_csks
                                         li_t001
                                CHANGING lv_flag_status.
            ELSE. " ELSE -> IF lv_proj_name = lv_proj_old

              CLEAR lst_mvke_prod.
              READ TABLE li_mvke INTO lst_mvke_prod WITH KEY matnr = <lst_mara_issue>-ismrefmdprod
                                                        BINARY SEARCH.
              IF sy-subrc EQ 0.

              ENDIF. " IF sy-subrc EQ 0

* Populate Profit Center
              CLEAR lst_marc_prod.
              READ TABLE li_marc INTO lst_marc_prod WITH KEY matnr = <lst_mara_issue>-ismrefmdprod
                                                        BINARY SEARCH.
              IF sy-subrc EQ 0.
                lst_project-profit_ctr    =  lst_marc_prod-prctr.
              ENDIF. " IF sy-subrc EQ 0

              CLEAR lst_detrm_costc_prod .
              READ TABLE li_detrm_costc INTO lst_detrm_costc_prod
                                        WITH KEY extwg = <lst_mara_issue>-extwg  "prctr = lst_marc_prod-prctr
                                                 werks = lst_mvke_prod-dwerk
                                        BINARY SEARCH .
              IF sy-subrc EQ 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_detrm_costc_prod-kostl
                  IMPORTING
                    output = lst_detrm_costc_prod-kostl.

                CLEAR lst_csks_prod.
                READ TABLE li_csks INTO lst_csks_prod
                                   WITH KEY kostl = lst_detrm_costc_prod-kostl
                                   BINARY SEARCH.
                IF sy-subrc = 0.
* Populate Company Code
                  lst_project-company_code       =  lst_csks_prod-bukrs .
* Populate Controlling Area
                  lst_project-controlling_area   =  lst_csks_prod-kokrs .
                ENDIF. " IF sy-subrc = 0
              ENDIF. " IF sy-subrc EQ 0

* Populate Project Currency
              CLEAR lst_t001_prod.
              READ TABLE li_t001 INTO lst_t001_prod
                                 WITH KEY bukrs = lst_csks_prod-bukrs
                                 BINARY SEARCH.
              IF sy-subrc = 0.
                lst_project-project_currency   = lst_t001_prod-waers.
              ENDIF. " IF sy-subrc = 0

*            lv_pspid = <lst_mara_issue>-ismrefmdprod.

              CLEAR v_old_wbs2.
*         Creating the next available project defn number for creation of new project
              SPLIT  lv_pspid_e AT lc_sign INTO lv_id lv_no.
              lv_no = lv_no + 1.
              CONCATENATE lv_id lv_no INTO lv_proj_defn SEPARATED BY lc_sign.
              lv_proj_old  = lv_proj_name.
* Project Definition
              lst_project-project_definition = lv_proj_defn.

              READ TABLE li_makt_prod ASSIGNING FIELD-SYMBOL(<lst_makt>)
                                                WITH KEY matnr = <lst_mara_issue>-ismrefmdprod
                                                BINARY SEARCH .
              IF sy-subrc EQ 0.
* Description
                CONCATENATE <lst_makt>-maktx
                            <lst_mara_issue>-ismcopynr
                       INTO lst_project-description
                  SEPARATED BY space.
              ENDIF. " IF sy-subrc EQ 0

* Person Responsible
              lst_project-responsible_no     = p_respno.
* Applicant Number
              lst_project-applicant_no       = p_apppno.
* Start Date
              lst_project-start              = sy-datum.
* Final Date
              lst_project-finish             = sy-datum.
* Project Profile
              lst_project-project_profile    = p_profl .    "'Z000001'
* Statistical
              lst_project-statistical        = abap_true.

              lst_valuepart1-zzleg_proj =  lv_proj_name.

              CALL FUNCTION 'CONVERSION_EXIT_ABPSN_INPUT'
                EXPORTING
                  input  = lv_proj_defn
                IMPORTING
                  output = lv_proj_defn_i.

              lst_valuepart1-project_definition = lv_proj_defn_i.
              lst_valuepart1-zzleg_proj =  lv_proj_name.
              lst_extensionin-structure  = lc_struc_proj_def.
              lst_extensionin-valuepart1 = lst_valuepart1.
              APPEND lst_extensionin TO li_extensionin.
              CLEAR: lst_extensionin.

              CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

              CALL FUNCTION 'BAPI_BUS2001_CREATE'
                EXPORTING
                  i_project_definition = lst_project
                TABLES
                  et_return            = li_return
                  extensionin          = li_extensionin.
* Check and display error messages - if any
              LOOP AT li_return INTO lst_return.
                IF lst_return-type = c_e.
                  lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
                  lst_message-matnr = <lst_mara_issue>-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
                  APPEND lst_message TO i_message.
                  CLEAR lst_message.
                  CLEAR lst_return.
                  lv_flag_status = abap_true.
                ENDIF. " IF lst_return-type = c_e
                CLEAR lst_return.
              ENDLOOP. " LOOP AT li_return INTO lst_return
              CLEAR li_return[].

              IF lv_flag_status = abap_false.
                CALL FUNCTION 'BAPI_PS_PRECOMMIT'
                  TABLES
                    et_return = li_return.

* Check and display error messages - if any
                LOOP AT li_return INTO lst_return.
                  IF lst_return-type = c_e.
                    lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
                    lst_message-matnr = <lst_mara_issue>-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
                    APPEND lst_message TO i_message.
                    CLEAR lst_message.
                    CLEAR lst_return.
                    lv_flag_status = abap_true.
                  ENDIF. " IF lst_return-type = c_e
                  CLEAR lst_return.
                ENDLOOP. " LOOP AT li_return INTO lst_return
                CLEAR li_return[].

                IF lv_flag_status = abap_false.
                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                    EXPORTING
                      wait = abap_true.

*           Create WBS Elements for level 1
                  PERFORM f_update_wbs_level1 USING   lv_proj_defn
                                                      <lst_mara_issue>
                                                      lst_detrm_costc_prod
                                                      lst_csks_prod
                                                      lst_t001_prod
                                                      li_makt_prod
                                             CHANGING lv_flag_status.

*       Add issue in newly created project with Level 2 WBS .
                  PERFORM f_update_wbs USING lv_proj_defn
                                             <lst_mara_issue>
*                                             lst_detrm_costc
*                                             lst_csks
*                                             lst_t001
                                              li_mvke
                                              li_marc
                                              li_detrm_costc
                                              li_csks
                                              li_t001
                                     CHANGING lv_flag_status.
                  lv_pspid_e = lv_proj_defn.
                ELSE. " ELSE -> IF lv_flag_status = abap_false
                  lst_message-message = text-006. " Project cannot be created for Issue:
                  lst_message-matnr = <lst_mara_issue>-matnr.
                  APPEND lst_message TO i_message.
                  CLEAR lst_message.
                ENDIF. " IF lv_flag_status = abap_false
              ELSE. " ELSE -> IF lv_flag_status = abap_false
                lst_message-message = text-006. " Project cannot be created for Issue:
                lst_message-matnr = <lst_mara_issue>-matnr.
                APPEND lst_message TO i_message.
                CLEAR lst_message.
              ENDIF. " IF lv_flag_status = abap_false
              CLEAR lst_project.
            ENDIF. " IF lv_proj_name = lv_proj_old

            IF lv_flag_status = abap_false.
              " Release Project structure
              PERFORM f_release_wbs USING lv_proj_defn
                                          lv_pspid_e.
            ENDIF. " IF lv_flag_status = abap_false

            IF lv_flag_status = abap_false.
              v_success      = abap_true.
              lst_message-pspid = lv_proj_defn.
              lst_message-message = text-007. " - Project/WBS created succesfully for Issue :
              lst_message-matnr = <lst_mara_issue>-matnr.
              APPEND lst_message TO i_message.
              CLEAR lst_message.
            ENDIF. " IF lv_flag_status = abap_false
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF <lst_mara_issue>-ismcopynr IS NOT INITIAL
        lst_message-message = text-010.
        lst_message-matnr = <lst_mara_issue>-matnr.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
      ENDIF. " IF <lst_mara_issue>-ismcopynr IS NOT INITIAL
    ENDLOOP. " LOOP AT li_mara_issue ASSIGNING <lst_mara_issue>
*    CLEAR : lst_detrm_costc,
*            lst_csks,
*            lst_t001.

  ENDIF. " IF li_mara_issue IS NOT INITIAL

  IF rb_backg IS NOT INITIAL AND v_success IS NOT INITIAL.
    " Update zcainterface table
    PERFORM f_set_last_run_details USING  lv_curr_date
                                          lv_curr_time.
  ELSE. " ELSE -> IF rb_backg IS NOT INITIAL AND v_success IS NOT INITIAL
*   Message: Execution Date/Time is not updated in ZCAINTERFACE table!
    MESSAGE s119(zqtc_r2). " Execution Date/Time is not updated in ZCAINTERFACE table!
  ENDIF. " IF rb_backg IS NOT INITIAL AND v_success IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*      Get last run details (Date and Time)
*----------------------------------------------------------------------*
*      <--FP_LV_FROM_DATE  Last Run Date
*      <--FP_LV_FROM_TIME  Last Run Time
*----------------------------------------------------------------------*
FORM f_get_last_run_details  CHANGING fp_lv_from_date TYPE sydatum  " System Date
                                      fp_lv_from_time TYPE syuzeit. " System Time

** Get the interface Run Details from table ZCAINTERFACE
  SELECT SINGLE lrdat      " Last run date
                lrtime     " Last run time
         FROM zcainterface " Interface run details
    INTO (fp_lv_from_date,
          fp_lv_from_time)
    WHERE devid =  c_devid_e148
      AND param1 = space
      AND param2 = space.
  IF sy-subrc NE 0.
    CLEAR: fp_lv_from_date,
           fp_lv_from_time.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_MARA
*&---------------------------------------------------------------------*
*  Fetch the records from mara table
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type
*      -->FP_LV_FROM_DATE  From Date
*      -->FP_LV_CURR_DATE  To Date
*      <--FP_LI_mara  Media Issues Created/Changed
*----------------------------------------------------------------------*
FORM f_fetch_records_mara  USING    fp_s_mtyp_i     TYPE cfb_t_mtart_range
                                    fp_lv_from_date TYPE sydatum " System Date
                                    fp_lv_curr_date TYPE sydatum " System Date
                           CHANGING fp_li_mara TYPE tt_mara.

  DATA : lir_date    TYPE trgr_date,
         lst_message TYPE ty_message.

* Populate Range table for Date
  APPEND INITIAL LINE TO lir_date ASSIGNING FIELD-SYMBOL(<lst_date>).
  <lst_date>-sign    = c_sign_incld.
  <lst_date>-option  = c_opti_betwn. "Option: (B)e(T)ween
  <lst_date>-low     = fp_lv_from_date. "From Date
  <lst_date>-high    = fp_lv_curr_date.

* Get Media issues from Mara table
  SELECT a~matnr,           " Material
         a~ersda,           " Created On
         a~laeda,           " Date of Last Change
         a~mtart,           " Material Type
         a~ismhierarchlevl, " Hierarchy Level (Media Product Family, Product or Issue)
         a~ismrefmdprod,    " Higher-Level Media Product
         a~ismmediatype,    " Media Type
         a~ismpubldate,     " Publication Date
         a~ismorgkey,       " Organization key
         a~ismcopynr,       " Copy Number of Media Issue
         a~ismyearnr,       " Media issue year number
         a~isminitshipdate, " Initial Shipping Date
         a~extwg,           " External Material Group
         b~maktx,           " Material Description (Short Text)
         c~idcodetype,      " Type of Identification Code
         c~identcode        " Identification Code
    FROM mara AS a
   INNER JOIN makt AS b
   ON a~matnr EQ b~matnr
  INNER JOIN jptidcdassign AS c
   ON a~matnr EQ c~matnr
   INTO TABLE @fp_li_mara
   WHERE a~matnr NOT LIKE '%_TEMP%'
   AND   mtart IN @fp_s_mtyp_i
   AND ( ersda IN @lir_date
    OR  laeda IN @lir_date )
    AND spras = @sy-langu
   AND idcodetype = @c_idcodetype.
  IF sy-subrc IS NOT INITIAL.
    lst_message-message = text-008.
    APPEND lst_message TO i_message.
    CLEAR lst_message.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_MARA_MANUAL
*&---------------------------------------------------------------------*
*   Get the data from MARA table when Manual execution is selected
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type
*      -->FP_S_ISSUE   Media Issue
*      -->FP_S_PROD    Media Product
*      <--FP_LI_mara  Media Issues
*----------------------------------------------------------------------*
FORM f_fetch_records_mara_manual  USING fp_s_mtyp_i TYPE cfb_t_mtart_range
                                        fp_s_issue  TYPE fip_t_matnr_range
                                        fp_s_prod   TYPE fip_t_matnr_range
                               CHANGING fp_li_mara TYPE tt_mara.

  DATA : lst_message TYPE ty_message.

* Get Media issues from Mara table
  SELECT a~matnr,           " Material
         a~ersda,           " Created On
         a~laeda,           " Date of Last Change
         a~mtart,           " Material Type
         a~ismhierarchlevl, " Hierarchy Level (Media Product Family, Product or Issue)
         a~ismrefmdprod,    " Higher-Level Media Product
         a~ismmediatype,    " Media Type
         a~ismpubldate,     " Publication Date
         a~ismorgkey,       " Organization key
         a~ismcopynr,       " Copy Number of Media Issue
         a~ismyearnr,       " Media issue year number
         a~isminitshipdate, " Initial Shipping Date
         a~extwg,           " Material External Group          "DM-1479
         b~maktx,           " Material Description (Short Text)
         c~idcodetype,      " Type of Identification Code
         c~identcode        " Identification Code
    FROM mara AS a
   INNER JOIN makt AS b
   ON a~matnr EQ b~matnr
   INNER JOIN jptidcdassign AS c
   ON a~matnr EQ c~matnr
   INTO TABLE @fp_li_mara
   WHERE  a~matnr  IN @fp_s_issue
    AND  a~matnr NOT LIKE '%_TEMP%'
    AND  a~mtart        IN @fp_s_mtyp_i
    AND  a~ismrefmdprod IN @fp_s_prod
    AND  b~spras = @sy-langu
    AND idcodetype = @c_idcodetype.
  IF sy-subrc IS NOT INITIAL.
    lst_message-message = text-008.
    APPEND lst_message TO i_message.
    CLEAR lst_message.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PROJECT_DEFINATION
*&---------------------------------------------------------------------*
*   * Get the project defination
*----------------------------------------------------------------------*
*  <--  fp_pspid  Project Definition
*----------------------------------------------------------------------*
FORM f_get_project_defination  CHANGING fp_pspid TYPE ps_pspid. " Project Definition

  DATA : lv_lines   TYPE char10,   " Lines of type CHAR10
         lv_pspid_i TYPE ps_pspid. " Project Definition


  CONSTANTS: lc_wbsid TYPE char3    VALUE 'JP%',       " Wbsid of type CHAR3
             lc_pspid TYPE ps_pspid VALUE 'JP.100000'. " Project Definition

* For fetching the last record of the PROJ table
  SELECT pspnr,                " Project definition (internal)
         pspid                 " Project Definition
    FROM proj                  " Project definition
    INTO TABLE @DATA(li_proj_defn)
    WHERE pspid LIKE @lc_wbsid "JP%
    ORDER BY pspid.
  IF sy-subrc = 0.
* searching the last project def number
    DESCRIBE TABLE li_proj_defn LINES lv_lines.
    READ TABLE li_proj_defn ASSIGNING FIELD-SYMBOL(<lst_proj_def>) INDEX lv_lines.
    IF sy-subrc = 0.
      lv_pspid_i = <lst_proj_def>-pspid.
      CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
        EXPORTING
          input  = lv_pspid_i
        IMPORTING
          output = fp_pspid.
    ELSE. " ELSE -> IF sy-subrc = 0
      fp_pspid = lc_pspid. "'JP.100000'
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_COST_CENTER
*&---------------------------------------------------------------------*
*       Get the cost center
*----------------------------------------------------------------------*
*      -->FP_LI_MVKE      MVKE Table
*      -->FP_LI_MVRC      Marc Table
*      <--FP_li_mara_issue   Mara Issues
*      <--FP_li_detrm_costc
*----------------------------------------------------------------------*
FORM f_get_cost_center  USING    fp_li_mvke        TYPE tt_mvke
                                 fp_li_marc        TYPE tt_marc
                        CHANGING fp_li_mara_issue  TYPE tt_mara
                                 fp_li_detrm_costc TYPE tt_detrm_costc.

  DATA : li_mara_tmp  TYPE tt_mara,
         li_mara_tmp2 TYPE tt_mara,
         lst_mara     TYPE ty_mara.

  LOOP AT fp_li_mara_issue ASSIGNING FIELD-SYMBOL(<lst_mara>).

    READ TABLE fp_li_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>)
                                     WITH KEY matnr = <lst_mara>-matnr
                                     BINARY SEARCH.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <lst_mvke> TO <lst_mara>.

    ENDIF. " IF sy-subrc EQ 0

    READ TABLE fp_li_marc ASSIGNING FIELD-SYMBOL(<lst_marc>)
                                     WITH KEY matnr = <lst_mara>-matnr
                                     BINARY SEARCH.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <lst_marc> TO <lst_mara>.
    ENDIF. " IF sy-subrc EQ 0

  ENDLOOP. " LOOP AT fp_li_mara_issue ASSIGNING FIELD-SYMBOL(<lst_mara>)

  li_mara_tmp2[] = fp_li_mara_issue[].
  li_mara_tmp[] = fp_li_mara_issue[].
  SORT li_mara_tmp2 BY ismrefmdprod.
  DELETE ADJACENT DUPLICATES FROM li_mara_tmp2 COMPARING ismrefmdprod.

  LOOP AT li_mara_tmp2 ASSIGNING <lst_mara>.

    lst_mara-matnr = <lst_mara>-ismrefmdprod.
    READ TABLE fp_li_mvke ASSIGNING <lst_mvke>
                          WITH KEY matnr = <lst_mara>-ismrefmdprod
                          BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_mara-dwerk = <lst_mvke>-dwerk.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE fp_li_marc ASSIGNING <lst_marc>
                          WITH KEY matnr = <lst_mara>-ismrefmdprod
                          BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_mara-prctr = <lst_marc>-prctr.
    ENDIF. " IF sy-subrc EQ 0
    APPEND lst_mara TO li_mara_tmp.
    CLEAR lst_mara.

  ENDLOOP. " LOOP AT li_mara_tmp2 ASSIGNING <lst_mara>

  SORT li_mara_tmp BY prctr dwerk.
  DELETE ADJACENT DUPLICATES FROM li_mara_tmp COMPARING prctr dwerk.

  IF li_mara_tmp[] IS NOT INITIAL.
* Table ZQTC_DETRM_COSTC is having only 7 fields
* so select* has been used .
    SELECT extwg            "prctr            " Profit Center "DM-1479
           werks            " Plant
           kostl            " Cost Center
      FROM zqtc_detrm_costc " Determine cost center on the basis of profit center n Plant
      INTO TABLE fp_li_detrm_costc
      FOR ALL ENTRIES IN li_mara_tmp
      WHERE extwg = li_mara_tmp-extwg   "prctr = li_mara_tmp-prctr "DM-1479
      AND   werks = li_mara_tmp-dwerk.
    IF sy-subrc EQ 0.
*      SORT fp_li_detrm_costc BY prctr werks.  "DM-1479
      SORT fp_li_detrm_costc BY extwg werks.                "DM-1479
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mara_tmp[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_COMPANY_CODE
*&---------------------------------------------------------------------*
*       Get the company Code
*----------------------------------------------------------------------*
*      -->FP_LI_DETRM_COSTC  Cost Center Table
*      <--FP_LI_CSKS  CSKS table
*----------------------------------------------------------------------*
FORM f_get_company_code  USING    fp_li_detrm_costc TYPE tt_detrm_costc
                         CHANGING fp_li_csks TYPE tt_csks.

  DATA : li_costc_tmp TYPE tt_detrm_costc.

  li_costc_tmp[] = fp_li_detrm_costc[].
  SORT li_costc_tmp BY kostl.
  DELETE ADJACENT DUPLICATES FROM li_costc_tmp COMPARING kostl.

  IF li_costc_tmp[] IS NOT INITIAL.
    SELECT kokrs " Controlling Area
           kostl " Cost Center
           datbi " Valid To Date
           bukrs " Company Code
           prctr " Profit Center
      FROM csks  " Cost Center Master Data
      INTO TABLE fp_li_csks
      FOR ALL ENTRIES IN li_costc_tmp
      WHERE kostl = li_costc_tmp-kostl.
    IF sy-subrc = 0.
      SORT fp_li_csks BY kostl.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_costc_tmp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CURRENCY_KEY
*&---------------------------------------------------------------------*
*       Get the currency key from T_001 Table
*----------------------------------------------------------------------*
*      -->P_LI_CSKS  CSKS table
*      <--P_LI_T001  T001 table
*----------------------------------------------------------------------*
FORM f_get_currency_key  USING    fp_li_csks TYPE tt_csks
                         CHANGING fp_li_t001 TYPE tt_t001.

  DATA : li_csks_tmp TYPE tt_csks.

  li_csks_tmp[] = fp_li_csks[].
  SORT li_csks_tmp BY bukrs .
  DELETE ADJACENT DUPLICATES FROM li_csks_tmp COMPARING bukrs .

  IF li_csks_tmp IS NOT INITIAL.
    SELECT bukrs " Company Code
           waers " Currency Key
      FROM t001  " Company Codes
      INTO TABLE fp_li_t001
      FOR ALL ENTRIES IN li_csks_tmp
      WHERE bukrs = li_csks_tmp-bukrs.
    IF sy-subrc = 0.
      SORT fp_li_t001 BY bukrs.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_csks_tmp IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_ISSUE
*&---------------------------------------------------------------------*
*       Change existing project and WBS elements
*----------------------------------------------------------------------*
*   --> fp_lst_mara_issue
*   --> fp_lst_prps
*   --> fp_li_detrm_costc
*   --> fp_li_csks
*   --> fp_li_t001
*   --> fp_li_makt_prod
*   <-- fp_lv_flag_status
*----------------------------------------------------------------------*
FORM f_change_level2_wbs USING fp_lst_mara_issue TYPE ty_mara
*                          fp_li_prps        TYPE tt_prps
                          fp_lst_prps       TYPE ty_prps
                          fp_li_detrm_costc TYPE tt_detrm_costc
                          fp_li_csks        TYPE tt_csks
                          fp_li_t001        TYPE tt_t001
                          fp_li_makt_prod   TYPE tt_makt
                 CHANGING fp_lv_flag_status TYPE char1. " Lv_flag_status of type CHAR1

* Local Variable Declaration
  DATA :  lv_exist_proj_defn TYPE ps_pspid, " Project Definition
          lv_posid_e         TYPE ps_posid. " Work Breakdown Structure Element (WBS Element)

* Local Work Area Declaration
  DATA: lst_wbs_element2   TYPE bapi_bus2054_chg, " Data Structure: Change WBS Element
        lst_wbs_element2_u TYPE bapi_bus2054_upd, " Update Structure: Change WBS Element
        lst_prps           TYPE ty_prps,
        lst_csks           TYPE ty_csks,
        lst_t001           TYPE ty_t001,
        lst_message        TYPE ty_message,
        lst_project2       TYPE bapi_bus2001_chg, " Data Structure: Change Project Definition
        lst_project2_u     TYPE bapi_bus2001_upd, " Update Structure: Change Project Definition
        lst_return         TYPE bapiret2.         " Return Parameter

* Local Internal Table
  DATA : li_wbs_element2   TYPE TABLE OF bapi_bus2054_chg, " Data Structure: Change WBS Element
         li_wbs_element2_u TYPE TABLE OF bapi_bus2054_upd, " Update Structure: Change WBS Element
         li_return         TYPE TABLE OF bapiret2.         " Return Parameter

* Local Constant Declaration
  CONSTANTS: lc_slwid TYPE slwid VALUE 'Z000001'. " Key word ID for user-defined fields

*Change WBS

* Checking if it is journal project
  IF fp_lst_prps-slwid = lc_slwid.
* Fetching the project definition number
    CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
      EXPORTING
        input  = fp_lst_prps-psphi
      IMPORTING
        output = lv_exist_proj_defn.

    CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
      EXPORTING
        input  = fp_lst_prps-posid
      IMPORTING
        output = lv_posid_e.

* Populate WBS Element
    lst_wbs_element2-wbs_element                     = lv_posid_e.
* Description
    lst_wbs_element2-description                     = fp_lst_mara_issue-maktx.


    READ TABLE fp_li_detrm_costc ASSIGNING FIELD-SYMBOL(<lst_detrm_costc>)
                                  WITH KEY extwg = fp_lst_mara_issue-extwg   "prctr = fp_lst_mara_issue-prctr
                                           werks = fp_lst_mara_issue-dwerk
                                  BINARY SEARCH .
    IF sy-subrc EQ 0.
* Responsible Cost Center
      lst_wbs_element2-respsbl_cctr       = <lst_detrm_costc>-kostl .

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_detrm_costc>-kostl
        IMPORTING
          output = <lst_detrm_costc>-kostl.

      READ TABLE fp_li_csks INTO lst_csks
                            WITH KEY kostl = <lst_detrm_costc>-kostl
                            BINARY SEARCH.
      IF sy-subrc = 0.
* Populate Company Code
        lst_wbs_element2-company_code       = lst_csks-bukrs .
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc EQ 0

*  Populate Project Currency
    READ TABLE fp_li_t001 INTO lst_t001
                          WITH KEY bukrs = lst_csks-bukrs
                          BINARY SEARCH.
    IF sy-subrc = 0.
      lst_wbs_element2-currency   = lst_t001-waers .
    ENDIF. " IF sy-subrc = 0

* Profit Center
    lst_wbs_element2-profit_ctr                       = fp_lst_mara_issue-prctr.

    lst_wbs_element2-user_field_char20_1              = fp_lst_mara_issue-identcode.
*    lst_wbs_element2-user_field_char20_2              = fp_lst_mara_issue-identcode.
* Publication/ In-Service Date (user defined field)
    lst_wbs_element2-user_field_date1                = fp_lst_mara_issue-isminitshipdate . "Estimated Publication Date (user defined field)

* Estimated Publication Date (user defined field)
*   Begin of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205
*   lst_wbs_element2-user_field_date2                = fp_lst_mara_issue-ismpubldate.
    lst_wbs_element2-user_field_date2                = fp_lst_mara_issue-isminitshipdate.
*   End   of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205
    APPEND lst_wbs_element2 TO li_wbs_element2.
    CLEAR: lst_wbs_element2.

    lst_wbs_element2_u-wbs_element                     = lv_posid_e.
    lst_wbs_element2_u-description                     = abap_true.
    lst_wbs_element2_u-company_code                    = abap_true.
    lst_wbs_element2_u-profit_ctr                      = abap_true.
    lst_wbs_element2_u-currency                        = abap_true.
    lst_wbs_element2_u-user_field_char20_1               = abap_true.
*    lst_wbs_element2-user_field_char20_2               = abap_true.
    lst_wbs_element2_u-user_field_date1                = abap_true.
    lst_wbs_element2_u-user_field_date2                = abap_true.
    APPEND lst_wbs_element2_u TO li_wbs_element2_u.
    CLEAR: lst_wbs_element2_u.

*     Additionally Update Level-1 WBS Element as well
*     Level-1 WBS will have the same name as the Project Definition
*    CLEAR lst_prps.
*    READ TABLE  fp_li_prps INTO lst_prps  WITH KEY  zzmpm = fp_lst_mara_issue-ismrefmdprod
*                                                     BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      lst_wbs_element2-company_code                    = lst_prps-pbukr.
*      lst_wbs_element2-profit_ctr                      = lst_prps-prctr.
*    ENDIF. " IF sy-subrc EQ 0
*    lst_wbs_element2-wbs_element                     = lv_exist_proj_defn.
*    lst_wbs_element2-currency                        = lst_t001-waers.
**   Description
*    READ TABLE fp_li_makt_prod ASSIGNING FIELD-SYMBOL(<lst_makt>)
*                                    WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
*                                    BINARY SEARCH .
*    IF sy-subrc EQ 0.
*      CONCATENATE <lst_makt>-maktx
*                  fp_lst_mara_issue-ismcopynr
*             INTO lst_wbs_element2-description
*        SEPARATED BY space.
*      lst_wbs_element2_u-description                   = abap_true.
*
*      lst_wbs_element2-user_field_char20_1              = <lst_makt>-identcode.
*      lst_wbs_element2_u-user_field_char20_1           = abap_true.
*    ENDIF. " IF sy-subrc EQ 0
*    APPEND lst_wbs_element2 TO li_wbs_element2.
*    CLEAR: lst_wbs_element2.

*    lst_wbs_element2_u-wbs_element                   = lv_exist_proj_defn.
*    lst_wbs_element2_u-company_code                  = abap_true.
*    lst_wbs_element2_u-profit_ctr                    = abap_true.
*    lst_wbs_element2_u-currency                      = abap_true.
*    APPEND lst_wbs_element2_u TO li_wbs_element2_u.
*    CLEAR: lst_wbs_element2_u.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.
*
    CALL FUNCTION 'BAPI_BUS2054_CHANGE_MULTI'
      EXPORTING
        i_project_definition  = lv_exist_proj_defn
      TABLES
        it_wbs_element        = li_wbs_element2
        it_update_wbs_element = li_wbs_element2_u
        et_return             = li_return.

    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.

      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          lst_message-matnr = fp_lst_mara_issue-ismrefmdprod.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

      IF fp_lv_flag_status = abap_true.
        lst_message-message  = 'Project/WBS cannot be changed for MPM Issue :'(011).
        lst_message-matnr   =  fp_lst_mara_issue-matnr.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        RETURN.
      ELSE. " ELSE -> IF fp_lv_flag_status = abap_true
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF. " IF fp_lv_flag_status = abap_true
    ENDIF. " IF fp_lv_flag_status = abap_false
    CLEAR fp_lv_flag_status .

* change Project
    READ TABLE fp_li_makt_prod ASSIGNING FIELD-SYMBOL(<lst_makt>)
                                    WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                                    BINARY SEARCH .
    IF sy-subrc EQ 0.
      CONCATENATE <lst_makt>-maktx
                  fp_lst_mara_issue-ismcopynr
             INTO lst_project2-description
        SEPARATED BY space.
    ENDIF. " IF sy-subrc EQ 0

* Change project
    lst_project2-project_definition = lv_exist_proj_defn.
    lst_project2-responsible_no   = p_respno .
    lst_project2-applicant_no     = p_apppno .
    lst_project2-start              = sy-datum .
    lst_project2-finish             = sy-datum .
    lst_project2-company_code       = lst_csks-bukrs.
    lst_project2-profit_ctr         = fp_lst_mara_issue-prctr.


    lst_project2_u-description        = abap_true .
    lst_project2_u-responsible_no     = abap_true .
    lst_project2_u-applicant_no       = abap_true .
    lst_project2_u-start              = abap_true .
    lst_project2_u-finish             = abap_true .
    lst_project2_u-company_code       = abap_true.
    lst_project2_u-profit_ctr         = abap_true.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

    CLEAR li_return.
    CALL FUNCTION 'BAPI_BUS2001_CHANGE'
      EXPORTING
        i_project_definition     = lst_project2
        i_project_definition_upd = lst_project2_u
      TABLES
        et_return                = li_return.

    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-pspid   = lv_exist_proj_defn.
        lst_message-matnr   = fp_lst_mara_issue-matnr.
        lst_message-message = lst_return-message.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.
      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-pspid   = lv_exist_proj_defn.
          lst_message-matnr   = fp_lst_mara_issue-matnr.
          lst_message-message = lst_return-message.
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

      IF fp_lv_flag_status = abap_false.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF. " IF fp_lv_flag_status = abap_false
    ENDIF. " IF fp_lv_flag_status = abap_false

    IF fp_lv_flag_status = abap_false.
      v_success = abap_true.
      lst_message-pspid = lv_exist_proj_defn.
      lst_message-message = text-015. " - Project/WBS changed succesfully for Issue :
      lst_message-matnr = fp_lst_mara_issue-matnr.
      APPEND lst_message TO i_message.
      CLEAR lst_message.
    ENDIF. " IF fp_lv_flag_status = abap_false

  ENDIF. " IF fp_lst_prps-slwid = lc_slwid
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PRPS
*&---------------------------------------------------------------------*
*       Get Data from PRPS table
*----------------------------------------------------------------------*
*      -->FP_LI_MARA_ISSUE
*      <--FP_LI_PRPS
*----------------------------------------------------------------------*
FORM f_get_data_prps  USING    fp_li_mara_issue TYPE tt_mara
                               fp_li_proj       TYPE tt_proj
                      CHANGING fp_li_prps       TYPE tt_prps
                               fp_li_prps_zzmpm TYPE tt_prps.


  IF fp_li_mara_issue IS NOT INITIAL.
* checking if the zzmpm number exists in PRPS (not assigned to any WBS)
    SELECT pspnr " WBS Element
           posid " Work Breakdown Structure Element (WBS Element)
           psphi " Current number of the appropriate project
           pbukr " Company code for WBS element
           prctr " Profit Center
           stufe " Level in Project Hierarchy
           slwid " Key word ID for user-defined fields
           zzmpm " MPM Issue
     FROM prps   " WBS (Work Breakdown Structure) Element Master Data
     INTO TABLE fp_li_prps
     FOR ALL ENTRIES IN fp_li_mara_issue
     WHERE ( zzmpm = fp_li_mara_issue-matnr
      OR zzmpm = fp_li_mara_issue-ismrefmdprod ) .
    IF sy-subrc = 0.
*   If the value exists, the MPM issue has already been assigned to a WBS element
*   and this record should be ignored for creation.
      SORT fp_li_prps BY zzmpm.
*      fp_li_prps_zzmpm[] = fp_li_prps[].
*      SORT fp_li_prps_zzmpm BY posid DESCENDING.
    ENDIF. " IF sy-subrc = 0

    IF fp_li_proj IS NOT INITIAL.
      SELECT pspnr " WBS Element
            posid  " Work Breakdown Structure Element (WBS Element)
            psphi  " Current number of the appropriate project
            pbukr  " Company code for WBS element
            prctr  " Profit Center
            stufe  " Level in Project Hierarchy
            slwid  " Key word ID for user-defined fields
            zzmpm  " MPM Issue
      FROM prps    " WBS (Work Breakdown Structure) Element Master Data
      INTO TABLE fp_li_prps_zzmpm
      FOR ALL ENTRIES IN fp_li_proj
      WHERE psphi = fp_li_proj-pspnr.
      IF sy-subrc = 0.
*   If the value exists, the MPM issue has already been assigned to a WBS element
*   and this record should be ignored for creation.
*      fp_li_prps_zzmpm[] = fp_li_prps[].
        SORT fp_li_prps_zzmpm BY psphi posid DESCENDING.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF fp_li_proj IS NOT INITIAL
  ENDIF. " IF fp_li_mara_issue IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_ISSUE
*&---------------------------------------------------------------------*
*       Add media issues to project with assigning Level 2 WBS
*----------------------------------------------------------------------*
*      -->FP_LST_MARA_ISSUE  text
*      -->FP_LST_PROJ  text
*      -->FP_LI_DETRM_COSTC  text
*      -->FP_LI_CSKS  text
*      -->FP_LI_T001  text
*      -->FP_LI_PRPS_ZZMPM  text
*      <--FP_LV_PROJ_DEFN
*      <--FP_LV_FLAG_STATUS  text
*----------------------------------------------------------------------*
FORM f_add_issue  USING    fp_lst_mara_issue  TYPE ty_mara
                           fp_lst_proj        TYPE ty_proj
                           fp_li_detrm_costc  TYPE tt_detrm_costc
                           fp_li_csks         TYPE tt_csks
                           fp_li_t001         TYPE tt_t001
                           fp_li_prps_zzmpm   TYPE tt_prps
                 CHANGING  fp_lv_proj_defn    TYPE ps_pspid " Project Definition
                           fp_lv_flag_status  TYPE char1.   " Lv_flag_status of type CHAR1


  DATA: li_wbs_element  TYPE TABLE OF bapi_bus2054_new,    " Data Structure: Create WBS Element
        lst_wbs_element TYPE          bapi_bus2054_new,    " Data Structure: Create WBS Element
        li_return       TYPE TABLE OF bapiret2,            " Return Parameter
        lst_return      TYPE          bapiret2,            " Return Parameter
        li_extensionin  TYPE TABLE OF bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_extensionin TYPE          bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_valuepart1  TYPE          bapi_te_wbs_element, " Customer Enhancement to WBS Element (CI_PRPS)
        lst_prps_zzmpm  TYPE ty_prps,
        lst_csks        TYPE ty_csks,
        lst_t001        TYPE ty_t001,
        lst_message     TYPE ty_message.

  DATA : lv_exist_proj_defn TYPE ps_pspid, " Project Definition
         lv_wbsno1          TYPE ps_pspid, " Project Definition
         lv_wbsno2_i        TYPE ps_pspid, " Project Definition
         lv_wbsno2_e        TYPE ps_pspid, " Project Definition
         lv_id              TYPE char2,    " Id of type CHAR2
         lv_no              TYPE char6,    " No of type CHAR6
         lv_no2             TYPE numc2.    " Two digit number

  CONSTANTS :  lc_sign      TYPE char1 VALUE '.', " Sign of type CHAR1
               lc_proj_type TYPE char2 VALUE 'ZA',
               lc_inv_rsn   TYPE char2 VALUE 'Z1',       " Inv_rsn of type CHAR2
               lc_med_type1 TYPE char2 VALUE 'PH',       " Med_type1 of type CHAR2
               lc_objcls    TYPE scope_ld VALUE 'OCOST', " Object class, language-dependent
               lc_func_area TYPE fkber VALUE 'PROJ',     " Functional Area
               lc_med_type2 TYPE char2 VALUE 'DI'.       " Med_type2 of type CHAR2

  CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
    EXPORTING
      input  = fp_lst_proj-pspnr "changed st_prps_zzmpm-psphi "changed from lst_prps_zzmpm to st_prps_zzmpm
    IMPORTING
      output = lv_exist_proj_defn.

*Existed project number
  fp_lv_proj_defn = lv_exist_proj_defn.

* level 1 wbs element
  lv_wbsno1 = lv_exist_proj_defn.

***Create level 2 wbs element
  READ TABLE fp_li_prps_zzmpm INTO lst_prps_zzmpm WITH KEY psphi = fp_lst_proj-pspnr
                                                             BINARY SEARCH.
  IF sy-subrc = 0.
    IF v_old_wbs IS INITIAL.
      lv_wbsno2_i = lst_prps_zzmpm-posid.
      CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
        EXPORTING
          input  = lv_wbsno2_i
        IMPORTING
          output = lv_wbsno2_e.
    ELSE. " ELSE -> IF v_old_wbs IS INITIAL
      lv_wbsno2_e  = v_old_wbs.
    ENDIF. " IF v_old_wbs IS INITIAL

    SPLIT  lv_wbsno2_e AT lc_sign INTO lv_id lv_no lv_no2.
    lv_no2 = lv_no2 + 1.
    CONCATENATE lv_id lv_no lv_no2 INTO lv_wbsno2_e SEPARATED BY lc_sign.
    lst_wbs_element-wbs_element   = lv_wbsno2_e.
    lst_wbs_element-wbs_up        = lv_wbsno1.
    lst_valuepart1-wbs_element    = lv_wbsno2_e.

  ENDIF. " IF sy-subrc = 0

  IF lst_wbs_element-wbs_element IS NOT INITIAL.
    READ TABLE fp_li_detrm_costc ASSIGNING FIELD-SYMBOL(<lst_detrm_costc>)
                                 WITH KEY extwg = fp_lst_mara_issue-extwg  " prctr = fp_lst_mara_issue-prctr
                                           werks = fp_lst_mara_issue-dwerk
                                  BINARY SEARCH .
    IF sy-subrc EQ 0.
* Responsible Cost Center
      lst_wbs_element-respsbl_cctr       = <lst_detrm_costc>-kostl.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_detrm_costc>-kostl
        IMPORTING
          output = <lst_detrm_costc>-kostl.

      READ TABLE fp_li_csks INTO lst_csks
                             WITH KEY kostl = <lst_detrm_costc>-kostl
                             BINARY SEARCH.
      IF sy-subrc = 0.
* Populate Company Code
        lst_wbs_element-company_code       = lst_csks-bukrs.
        lst_wbs_element-controlling_area   = lst_csks-kokrs.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc EQ 0

* Populate Project Currency
    READ TABLE fp_li_t001  INTO lst_t001
                            WITH KEY bukrs = lst_csks-bukrs
                            BINARY SEARCH.
    IF sy-subrc = 0.
      lst_wbs_element-currency   = lst_t001-waers .
    ENDIF. " IF sy-subrc = 0

* Profit Center
    lst_wbs_element-profit_ctr                      = fp_lst_mara_issue-prctr.

* Publication/ In-Service Date (user defined field)
    lst_wbs_element-user_field_date1                = fp_lst_mara_issue-isminitshipdate . "Estimated Publication Date (user defined field)

* Estimated Publication Date (user defined field)
*   Begin of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205
*   lst_wbs_element-user_field_date2                = fp_lst_mara_issue-ismpubldate.
    lst_wbs_element-user_field_date2                = fp_lst_mara_issue-isminitshipdate.
*   End   of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205

    lst_wbs_element-description                     = fp_lst_mara_issue-maktx.
    lst_wbs_element-proj_type                       = lc_proj_type. "'ZA- Journal Production'
    lst_wbs_element-wbs_planning_element            = abap_true.
    lst_wbs_element-wbs_account_assignment_element  = abap_true.
    lst_wbs_element-user_field_char20_1             = fp_lst_mara_issue-identcode.
*
    IF fp_lst_mara_issue-ismmediatype = lc_med_type1.
      lst_wbs_element-user_field_flag1 = abap_true.
    ELSEIF fp_lst_mara_issue-ismmediatype = lc_med_type2.
      lst_wbs_element-user_field_flag2 = abap_true.
    ENDIF. " IF fp_lst_mara_issue-ismmediatype = lc_med_type1

    lst_wbs_element-objectclass                     = lc_objcls . "'OCOST'.
    lst_wbs_element-inv_reason                      = lc_inv_rsn . "'Z1'
    lst_wbs_element-func_area                       = lc_func_area. "'PROJ'.
    APPEND lst_wbs_element TO li_wbs_element.
    CLEAR: lst_wbs_element.

***Create the WBS Elements

    lst_valuepart1-zzmpm = fp_lst_mara_issue-matnr .
    lst_extensionin-structure  = 'BAPI_TE_WBS_ELEMENT'.

    lst_extensionin-valuepart1 = lst_valuepart1.

    APPEND lst_extensionin TO li_extensionin.
    CLEAR lst_extensionin.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

    CALL FUNCTION 'BAPI_BUS2054_CREATE_MULTI'
      EXPORTING
        i_project_definition = lv_exist_proj_defn
      TABLES
        it_wbs_element       = li_wbs_element
        et_return            = li_return
        extensionin          = li_extensionin.

* Check and display error messages - if any
    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.

      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

      IF fp_lv_flag_status = abap_false.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        v_old_wbs =  lv_wbsno2_e.
      ELSE. " ELSE -> IF fp_lv_flag_status = abap_false
        lst_message-message = text-006.
        lst_message-matnr = fp_lst_mara_issue-matnr.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
      ENDIF. " IF fp_lv_flag_status = abap_false

    ELSE. " ELSE -> IF fp_lv_flag_status = abap_false
      lst_message-message = text-006.
      lst_message-matnr = fp_lst_mara_issue-matnr.
      APPEND lst_message TO i_message.
      CLEAR lst_message.
    ENDIF. " IF fp_lv_flag_status = abap_false

  ELSE. " ELSE -> IF lst_wbs_element-wbs_element IS NOT INITIAL
    lst_message-message = text-013.
    lst_message-matnr = fp_lst_mara_issue-matnr.
    APPEND lst_message TO i_message.
    CLEAR lst_message.
    fp_lv_flag_status = abap_true.
  ENDIF. " IF lst_wbs_element-wbs_element IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PROJ
*&---------------------------------------------------------------------*
*       Get Data from PROJ table
*----------------------------------------------------------------------*
*      -->P_LI_PROJ_NAME  text
*      <--P_LI_PROJ  text
*----------------------------------------------------------------------*
FORM f_get_data_proj  USING    fp_li_proj_name TYPE tt_proj_name
                      CHANGING fp_li_proj   TYPE tt_proj.

  IF fp_li_proj_name[] IS NOT INITIAL.
    SELECT pspnr      " Project definition (internal)
           zzleg_proj " Legacy Project Number
     FROM proj        " Project definition
     INTO TABLE fp_li_proj
     FOR ALL ENTRIES IN fp_li_proj_name
     WHERE zzleg_proj = fp_li_proj_name-proj_name.
    IF sy-subrc EQ 0.
      SORT fp_li_proj BY zzleg_proj.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_li_proj_name[] IS NOT INITIAL

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_WBS_LEVEL1
*&---------------------------------------------------------------------*
*      Update WBS element
*----------------------------------------------------------------------*
*     -->Fp_lv_proj_defn
*     -->Fp_lst_mara_issue
*     -->fp_lst_detrm_costc
*     -->fp_lst_csks
*     -->fp_lst_t001
*     -->fp_li_makt_prod
*     <--FP_LV_FLAG_STATUS
*----------------------------------------------------------------------*
FORM f_update_wbs_level1  USING    fp_lv_proj_defn     TYPE ps_pspid       " Project Definition
                                   fp_lst_mara_issue TYPE ty_mara
                                   fp_lst_detrm_costc  TYPE ty_detrm_costc " Determine cost center on the basis of profit center n Plant
                                   fp_lst_csks         TYPE ty_csks
                                   fp_lst_t001         TYPE ty_t001
                                   fp_li_makt_prod     TYPE tt_makt
                          CHANGING fp_lv_flag_status   TYPE char1.         " Lv_flag_status of type CHAR1

  DATA: li_wbs_element  TYPE TABLE OF bapi_bus2054_new, " Data Structure: Create WBS Element
        lst_wbs_element TYPE          bapi_bus2054_new, " Data Structure: Create WBS Element
        lst_message     TYPE ty_message,
        li_return       TYPE TABLE OF bapiret2,         " Return Parameter
        lst_return      TYPE          bapiret2.         " Return Parameter

  DATA: li_extensionin  TYPE TABLE OF bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_extensionin TYPE          bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_valuepart1  TYPE          bapi_te_wbs_element. " Customer Enhancement to WBS Element (CI_PRPS)

  CONSTANTS: lc_objcls    TYPE scope_ld VALUE 'OCOST', " Object class, language-dependent
             lc_func_area TYPE fkber VALUE 'PROJ',     " Functional Area
             lc_med_type1 TYPE char2 VALUE 'PH',       " Med_type1 of type CHAR2
             lc_med_type2 TYPE char2 VALUE 'DI',       " Med_type2 of type CHAR2
             lc_proj_type TYPE char2 VALUE 'ZA',
             lc_inv_rsn   TYPE char2 VALUE 'Z1'.       " Inv_rsn of type CHAR2

  READ TABLE fp_li_makt_prod ASSIGNING FIELD-SYMBOL(<lst_makt>)
                             WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                             BINARY SEARCH.
  IF sy-subrc EQ 0.
*   Description
    CONCATENATE <lst_makt>-maktx
                fp_lst_mara_issue-ismcopynr
           INTO lst_wbs_element-description
      SEPARATED BY space.
    lst_wbs_element-user_field_char20_1             = <lst_makt>-identcode.
  ENDIF. " IF sy-subrc EQ 0

  lst_wbs_element-wbs_element                     = fp_lv_proj_defn .
  lst_wbs_element-company_code                    = fp_lst_csks-bukrs.
  lst_wbs_element-controlling_area                = fp_lst_csks-kokrs. "'JWCO'.  "lc_kokrs .
  lst_wbs_element-profit_ctr                      = fp_lst_csks-prctr.
  lst_wbs_element-proj_type                       = lc_proj_type. "'ZA
  lst_wbs_element-wbs_planning_element            = abap_true .
  lst_wbs_element-wbs_account_assignment_element  = abap_true .
  lst_wbs_element-respsbl_cctr                    = fp_lst_detrm_costc-kostl.
  lst_wbs_element-currency                        = fp_lst_t001-waers.
  lst_wbs_element-user_field_date1                = fp_lst_mara_issue-isminitshipdate . "Estimated Publication Date (user defined field)
* Begin of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205
* lst_wbs_element-user_field_date2                = fp_lst_mara_issue-ismpubldate . "Actual Publication Date (user defined field)
  lst_wbs_element-user_field_date2                = fp_lst_mara_issue-isminitshipdate.
* End   of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205

  IF fp_lst_mara_issue-ismmediatype = lc_med_type1.
    lst_wbs_element-user_field_flag1 = abap_true.
  ELSEIF fp_lst_mara_issue-ismmediatype = lc_med_type2.
    lst_wbs_element-user_field_flag2 = abap_true.
  ENDIF. " IF fp_lst_mara_issue-ismmediatype = lc_med_type1

  lst_wbs_element-objectclass                     = lc_objcls . "'OCOST'.
  lst_wbs_element-inv_reason                      = lc_inv_rsn . "'Z1'
  lst_wbs_element-func_area                       = lc_func_area. "'PROJ'.
  APPEND lst_wbs_element TO li_wbs_element.
  CLEAR: lst_wbs_element.

  lst_valuepart1-zzmpm = fp_lst_mara_issue-ismrefmdprod.
  lst_valuepart1-wbs_element = fp_lv_proj_defn.
  lst_extensionin-structure  = 'BAPI_TE_WBS_ELEMENT'.
  lst_extensionin-valuepart1 = lst_valuepart1.

  APPEND lst_extensionin TO li_extensionin.
  CLEAR lst_extensionin.

  CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

  CALL FUNCTION 'BAPI_BUS2054_CREATE_MULTI'
    EXPORTING
      i_project_definition = fp_lv_proj_defn
    TABLES
      it_wbs_element       = li_wbs_element
      et_return            = li_return
      extensionin          = li_extensionin.

*Check and display error messages - if any
  LOOP AT li_return INTO lst_return.
    IF lst_return-type = c_e.
      lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
      lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
      APPEND lst_message TO i_message.
      CLEAR lst_message.
      fp_lv_flag_status = abap_true.
    ENDIF. " IF lst_return-type = c_e
    CLEAR lst_return.
  ENDLOOP. " LOOP AT li_return INTO lst_return
  CLEAR li_return[].

  IF fp_lv_flag_status = abap_false.

    CALL FUNCTION 'BAPI_PS_PRECOMMIT'
      TABLES
        et_return = li_return.

    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

*In case of any error - delete the Project
    IF fp_lv_flag_status = abap_true.
      lst_message-message = text-006.
      lst_message-matnr =  fp_lst_mara_issue-matnr .
      APPEND lst_message TO i_message.
      CLEAR lst_message.
      PERFORM f_delete_project USING fp_lv_proj_defn.
    ELSE. " ELSE -> IF fp_lv_flag_status = abap_true
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
*********** Release the project structure ******************
    ENDIF. " IF fp_lv_flag_status = abap_true

  ELSE. " ELSE -> IF fp_lv_flag_status = abap_false
    lst_message-message = text-006.
    lst_message-matnr =  fp_lst_mara_issue-matnr .
    APPEND lst_message TO i_message.
    CLEAR lst_message.
    PERFORM f_delete_project USING fp_lv_proj_defn.
  ENDIF. " IF fp_lv_flag_status = abap_false

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_PROJECT
*&---------------------------------------------------------------------*
*       Delete project
*----------------------------------------------------------------------*
*  -->  fp_lv_proj_defn       Project Defination
*----------------------------------------------------------------------*
FORM f_delete_project USING fp_lv_proj_defn     TYPE ps_pspid  . " Project Definition

  DATA: li_return TYPE TABLE OF bapiret2. " Return Parameter

  CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

  CALL FUNCTION 'BAPI_BUS2001_DELETE'
    EXPORTING
      i_project_definition = fp_lv_proj_defn
    TABLES
      et_return            = li_return.

  CALL FUNCTION 'BAPI_PS_PRECOMMIT'
    TABLES
      et_return = li_return.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

  RETURN.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RELEASE_WBS
*&---------------------------------------------------------------------*
*       Release WBS
*----------------------------------------------------------------------*
*      -->FP_LV_PROJ_DEFN    Project Definition
*      -->FP_LV_PSPID_E      Project Definition in external formate
*----------------------------------------------------------------------*
FORM f_release_wbs  USING    fp_lv_proj_defn TYPE ps_pspid " Project Definition
                             fp_lv_pspid_e TYPE ps_pspid.  " Project Definition

  DATA: lst_return1 TYPE          bapireturn1, " Return Parameter
        li_return   TYPE TABLE OF bapiret2.    " Return Parameter

  CONSTANTS : lc_rel TYPE bapi_system_status_text VALUE 'REL'. " System Status Text

  CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

  CALL FUNCTION 'BAPI_BUS2001_SET_STATUS'
    EXPORTING
      project_definition = fp_lv_proj_defn
      set_system_status  = lc_rel
    IMPORTING
      return             = lst_return1.

  CALL FUNCTION 'BAPI_PS_PRECOMMIT'
    TABLES
      et_return = li_return.

  READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_e. " Return into lst_ of type
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF. " IF sy-subrc NE 0

* Updating the last created project number
  fp_lv_pspid_e = fp_lv_proj_defn.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_WBS
*&---------------------------------------------------------------------*
*       Update WBS elements
*----------------------------------------------------------------------*
*      -->FP_V_PROJ_DEFN
*      -->FP_<LST_MARA_ISSUE>
*      -->FP_<LST_DETRM_COSTC>
*      -->FP_<LST_CSKS>
*      -->FP_<LST_T001>
*      <--FP_LV_FLAG_STATUS
*----------------------------------------------------------------------*
FORM f_update_wbs  USING    fp_lv_proj_defn     TYPE ps_pspid       " Project Definition
                            fp_lst_mara_issue   TYPE ty_mara
                            fp_li_mvke          TYPE tt_mvke
                            fp_li_marc          TYPE tt_marc
                            fp_li_detrm_costc   TYPE tt_detrm_costc " Determine cost center on the basis of profit center n Plant
                            fp_li_csks          TYPE tt_csks
                            fp_li_t001          TYPE tt_t001
                   CHANGING fp_lv_flag_status   TYPE char1.         " Lv_flag_status of type CHAR1

  CONSTANTS :
    lc_sign      TYPE char1    VALUE '.', " Sign of type CHAR1
    lc_objcls    TYPE scope_ld VALUE 'OCOST', " Object class, language-dependent
    lc_func_area TYPE fkber    VALUE 'PROJ',  " Functional Area
    lc_med_type1 TYPE char2    VALUE 'PH',    " Med_type1 of type CHAR2
    lc_med_type2 TYPE char2    VALUE 'DI',    " Med_type2 of type CHAR2
    lc_proj_type TYPE char2    VALUE 'ZA',
    lc_inv_rsn   TYPE char2    VALUE 'Z1'.    " Inv_rsn of type CHAR2

  DATA: lv_id       TYPE char2,    " Id of type CHAR2
        lv_no       TYPE char6,    " No of type CHAR6
        lv_no2      TYPE numc2,    " Two digit number
        lv_wbsno2_i TYPE ps_pspid, " Project Definition
        lv_wbsno2_e TYPE ps_pspid, " Project Definition
        lv_wbsno1   TYPE ps_pspid. " Project Definition

  DATA: li_wbs_element  TYPE TABLE OF bapi_bus2054_new,    " Data Structure: Create WBS Element
        lst_wbs_element TYPE          bapi_bus2054_new,    " Data Structure: Create WBS Element
        li_return       TYPE TABLE OF bapiret2,            " Return Parameter
        lst_return      TYPE          bapiret2,            " Return Parameter
        li_extensionin  TYPE TABLE OF bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_extensionin TYPE          bapiparex,           " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_message     TYPE          ty_message,
        lst_detrm_costc TYPE ty_detrm_costc,               " Determine cost center on the basis of profit center n Plant
        lst_t001        TYPE ty_t001,
        lst_csks        TYPE ty_csks,
        lst_mvke        TYPE ty_mvke,
        lst_marc        TYPE ty_marc,
        lst_valuepart1  TYPE          bapi_te_wbs_element. " Customer Enhancement to WBS Element (CI_PRPS)



* level 1 wbs element
  lv_wbsno1 =  fp_lv_proj_defn.

  IF v_old_wbs2 IS INITIAL.
    lv_wbsno2_i = fp_lv_proj_defn.
    CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
      EXPORTING
        input  = lv_wbsno2_i
      IMPORTING
        output = lv_wbsno2_e.
  ELSE. " ELSE -> IF v_old_wbs2 IS INITIAL
    lv_wbsno2_e  = v_old_wbs2.
  ENDIF. " IF v_old_wbs2 IS INITIAL

  SPLIT  lv_wbsno2_e AT lc_sign INTO lv_id lv_no lv_no2.
  lv_no2 = lv_no2 + 1.
  CONCATENATE lv_id lv_no lv_no2 INTO lv_wbsno2_e SEPARATED BY lc_sign.
  lst_wbs_element-wbs_element   = lv_wbsno2_e.
  lst_wbs_element-wbs_up        = lv_wbsno1.
  lst_valuepart1-wbs_element    = lv_wbsno2_e.

  IF lst_wbs_element-wbs_element IS NOT INITIAL.
    CLEAR lst_mvke.
    READ TABLE fp_li_mvke INTO lst_mvke WITH KEY matnr = fp_lst_mara_issue-matnr
                                              BINARY SEARCH.
    IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0

* Populate Profit Center
    CLEAR lst_marc.
    READ TABLE fp_li_marc INTO lst_marc WITH KEY matnr = fp_lst_mara_issue-matnr
                                              BINARY SEARCH.
    IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0

    CLEAR lst_detrm_costc.
    READ TABLE fp_li_detrm_costc INTO lst_detrm_costc
                               WITH KEY extwg = fp_lst_mara_issue-extwg    "prctr = lst_marc-prctr "DM
                                       werks = lst_mvke-dwerk
                              BINARY SEARCH .
    IF sy-subrc EQ 0.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_detrm_costc-kostl
        IMPORTING
          output = lst_detrm_costc-kostl.
      lst_wbs_element-respsbl_cctr                    = lst_detrm_costc-kostl.
      CLEAR lst_csks.
      READ TABLE fp_li_csks INTO lst_csks
                         WITH KEY kostl = lst_detrm_costc-kostl
                         BINARY SEARCH.
      IF sy-subrc = 0.
        lst_wbs_element-company_code                    = lst_csks-bukrs.
        lst_wbs_element-controlling_area                = lst_csks-kokrs.
        lst_wbs_element-profit_ctr                      = lst_csks-prctr.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc EQ 0

* Populate Currency
    CLEAR lst_t001.
    READ TABLE fp_li_t001 INTO lst_t001
                          WITH KEY bukrs = lst_csks-bukrs
                          BINARY SEARCH.
    IF sy-subrc = 0.
      lst_wbs_element-currency                      = lst_t001-waers.
    ENDIF. " IF sy-subrc = 0

    lst_wbs_element-description                     = fp_lst_mara_issue-maktx.
    lst_wbs_element-proj_type                       = lc_proj_type. "'ZC'
    lst_wbs_element-wbs_planning_element            = abap_true .
    lst_wbs_element-wbs_account_assignment_element  = abap_true .

    lst_wbs_element-user_field_char20_1             = fp_lst_mara_issue-identcode.
    lst_wbs_element-user_field_date1                = fp_lst_mara_issue-isminitshipdate  . "Estimated Publication Date (user defined field)
*   Begin of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205
*   lst_wbs_element-user_field_date2                = fp_lst_mara_issue-ismpubldate . "Actual Publication Date (user defined field)
    lst_wbs_element-user_field_date2                = fp_lst_mara_issue-isminitshipdate.
*   End   of CHANGE:ERP-3138:WROY:10-JUL-2017:ED2K907205

    IF fp_lst_mara_issue-ismmediatype = lc_med_type1.
      lst_wbs_element-user_field_flag1 = abap_true.
    ELSEIF fp_lst_mara_issue-ismmediatype = lc_med_type2.
      lst_wbs_element-user_field_flag2 = abap_true.
    ENDIF. " IF fp_lst_mara_issue-ismmediatype = lc_med_type1

    lst_wbs_element-objectclass                     = lc_objcls . "'OCOST'.
    lst_wbs_element-inv_reason                      = lc_inv_rsn . "'Z1'
    lst_wbs_element-func_area                       = lc_func_area. "'PROJ'.

    APPEND lst_wbs_element TO li_wbs_element.
    CLEAR: lst_wbs_element.

***Create the WBS Elements
    lst_valuepart1-zzmpm = fp_lst_mara_issue-matnr.

    lst_extensionin-structure  = 'BAPI_TE_WBS_ELEMENT'.
    lst_extensionin-valuepart1 = lst_valuepart1.
    APPEND lst_extensionin TO li_extensionin.
    CLEAR lst_extensionin.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

    CALL FUNCTION 'BAPI_BUS2054_CREATE_MULTI'
      EXPORTING
        i_project_definition = fp_lv_proj_defn
      TABLES
        it_wbs_element       = li_wbs_element
        et_return            = li_return
        extensionin          = li_extensionin.

*Check and display error messages - if any
    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.

      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          lst_message-matnr = fp_lst_mara_issue-matnr.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

*In case of any error - delete the Project
      IF fp_lv_flag_status = abap_true.

        CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

        CALL FUNCTION 'BAPI_BUS2001_DELETE'
          EXPORTING
            i_project_definition = fp_lv_proj_defn
          TABLES
            et_return            = li_return.

        CALL FUNCTION 'BAPI_PS_PRECOMMIT'
          TABLES
            et_return = li_return.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        lst_message-message = text-006.
        lst_message-matnr = fp_lst_mara_issue-matnr .
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        RETURN.
      ELSE. " ELSE -> IF fp_lv_flag_status = abap_true
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        v_old_wbs2 =  lv_wbsno2_e.
*********** Release the project structure ******************
      ENDIF. " IF fp_lv_flag_status = abap_true

    ELSE. " ELSE -> IF fp_lv_flag_status = abap_false
      lst_message-message = text-006.
      lst_message-matnr = fp_lst_mara_issue-matnr .
      APPEND lst_message TO i_message.
      CLEAR lst_message.
    ENDIF. " IF fp_lv_flag_status = abap_false

  ELSE. " ELSE -> IF lst_wbs_element-wbs_element IS NOT INITIAL
    lst_message-message = text-013.
    lst_message-matnr = fp_lst_mara_issue-matnr.
    APPEND lst_message TO i_message.
    CLEAR lst_message.
    fp_lv_flag_status = abap_true.
  ENDIF. " IF lst_wbs_element-wbs_element IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*      Update ZCAINTERFACE table with last run Date and time
*----------------------------------------------------------------------*
*      -->FP_LV_CURR_DATE  Current date
*      -->FP_LV_CURR_TIME  Current Time
*----------------------------------------------------------------------*
FORM f_set_last_run_details  USING    fp_lv_curr_date TYPE sydatum  " System Date
                                      fp_lv_curr_time TYPE syuzeit. " System Time

  CONSTANTS :lc_msgty_info TYPE symsgty         VALUE 'I'. "Message Type: Information

  DATA:
      lst_interface TYPE zcainterface. "Interface run details

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true    "Lock mode
      mandt             = sy-mandt     "01th enqueue argument (Client)
      devid             = c_devid_e148 "02th enqueue argument (Development ID)
      param1            = space        "03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = space        "04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.
  IF sy-subrc EQ 0.
    lst_interface-mandt  = sy-mandt. "Client
    lst_interface-devid  = c_devid_e148. "Development ID
    lst_interface-param1 = space. "ABAP: Name of Variant Variable
    lst_interface-param2 = space. "ABAP: Name of Variant Variable
    lst_interface-lrdat  = fp_lv_curr_date. "Last run date
    lst_interface-lrtime = fp_lv_curr_time. "Last run time
*   Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_interface.
*   Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
    MESSAGE s132(zqtc_r2). " Execution Date/Time is updated in ZCAINTERFACE table!
  ELSE. " ELSE -> IF sy-subrc EQ 0
*   Error Message
    MESSAGE ID sy-msgid      "Message Class
          TYPE lc_msgty_info "Message Type: Information
        NUMBER sy-msgno      "Message Number
          WITH sy-msgv1      "Message Variable-1
               sy-msgv2      "Message Variable-2
               sy-msgv3      "Message Variable-3
               sy-msgv4.     "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MESSAGE
*&---------------------------------------------------------------------*
*    Display all messages in ALV
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_get_message .

  DATA : li_fieldcat  TYPE slis_t_fieldcat_alv,
         lst_fieldcat TYPE slis_fieldcat_alv,
         lst_layout   TYPE slis_layout_alv,
         lv_repid     TYPE sy-repid.

  CONSTANTS : lc_fld_pspid TYPE slis_fieldname VALUE 'PSPID',
              lc_fld_matnr TYPE slis_fieldname VALUE 'MATNR',
              lc_fld_msg   TYPE slis_fieldname VALUE 'MESSAGE',
              lc_tabname   TYPE slis_tabname VALUE 'I_MESSAGE'.


* Creating fieldcatalog
  lst_fieldcat-fieldname  = lc_fld_pspid.
  lst_fieldcat-tabname    = lc_tabname .
  lst_fieldcat-reptext_ddic = 'Project Number'(004).
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR  lst_fieldcat.

  lst_fieldcat-fieldname  = lc_fld_msg.
  lst_fieldcat-tabname    = lc_tabname.
  lst_fieldcat-reptext_ddic = 'Message'(005).
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR  lst_fieldcat.

  lst_fieldcat-fieldname  = lc_fld_matnr.
  lst_fieldcat-tabname    = lc_tabname.
  lst_fieldcat-reptext_ddic = 'MPM Issues & Products'(009).
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR  lst_fieldcat.

  SORT i_message BY matnr.
* Creating layout
  CLEAR : lst_layout.
  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.
* Creating display
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = lv_repid
      is_layout          = lst_layout
      it_fieldcat        = li_fieldcat
    TABLES
      t_outtab           = i_message
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MARC
*&---------------------------------------------------------------------*
*      Get data from MARC table
*----------------------------------------------------------------------*
*      -->FP_LI_MARA
*      <--FP_LI_MARC
*----------------------------------------------------------------------*
FORM f_get_data_marc  USING    fp_li_mara TYPE tt_mara
                      CHANGING fp_li_marc TYPE tt_marc.

  IF fp_li_mara IS NOT INITIAL.
    SELECT  matnr " Material Number
            werks " Plant
            prctr " Profit Center
       FROM marc  " Plant Data for Material
      INTO TABLE fp_li_marc
      FOR ALL ENTRIES IN fp_li_mara
      WHERE ( matnr = fp_li_mara-matnr
      OR   matnr = fp_li_mara-ismrefmdprod ).
    IF sy-subrc EQ 0.
      SORT fp_li_marc BY matnr.
    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF fp_li_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MVKE
*&---------------------------------------------------------------------*
*      Get Data from MVKE table
*----------------------------------------------------------------------*
*      -->FP_LI_MARA
*      <--FP_LI_MVKE
*----------------------------------------------------------------------*
FORM f_get_data_mvke  USING    fp_li_mara TYPE tt_mara
                      CHANGING fp_li_mvke TYPE tt_mvke.

  SELECT matnr " Material Number
         vkorg " Sales Organization
         vtweg " Distribution Channel
         dwerk " Delivering Plant (Own or External)
    FROM mvke  " Sales Data for Material
    INTO TABLE fp_li_mvke
    FOR ALL ENTRIES IN fp_li_mara
    WHERE ( matnr = fp_li_mara-matnr
    OR   matnr = fp_li_mara-ismrefmdprod ).
  IF sy-subrc EQ 0.
    SORT fp_li_mvke BY matnr.
    DELETE fp_li_mvke WHERE dwerk IS INITIAL.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MAKT
*&---------------------------------------------------------------------*
*    Get Data from MAKT table
*----------------------------------------------------------------------*
*      -->FP_LI_MARA_ISSUE
*      <--FP_LI_MAKT_PROD
*----------------------------------------------------------------------*
FORM f_get_data_makt  USING    fp_li_mara_issue TYPE tt_mara
                      CHANGING fp_li_makt_prod TYPE tt_makt.

  IF fp_li_mara_issue[] IS NOT INITIAL .
* Table MAKT will be having only 5 Fields
* So Select * has used.
    SELECT a~matnr,    " Material Number
           a~spras,    " Language Key
           a~maktx,    " Material Description (Short Text)
           b~idcodetype,
           b~identcode " Identification Code
      FROM makt AS a   " Material Descriptions
      INNER JOIN jptidcdassign AS b
      ON a~matnr = b~matnr
      INTO TABLE @fp_li_makt_prod
      FOR ALL ENTRIES IN @fp_li_mara_issue
      WHERE a~matnr  = @fp_li_mara_issue-ismrefmdprod
      AND a~spras = @sy-langu
      AND b~idcodetype = @c_idcodetype.
    IF sy-subrc EQ 0.
      SORT fp_li_makt_prod BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_li_mara_issue[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_LEVEL1_WBS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<LST_MARA_ISSUE>  text
*      -->P_LI_PRPS  text
*      -->P_<LST_PRPS>  text
*      -->P_LI_MVKE  text
*      -->P_LI_MARC  text
*      -->P_LI_DETRM_COSTC  text
*      -->P_LI_CSKS  text
*      -->P_LI_T001  text
*      -->P_LI_MAKT_PROD  text
*      <--P_LV_FLAG_STATUS  text
*----------------------------------------------------------------------*
FORM f_change_level1_wbs USING fp_lst_mara_issue TYPE ty_mara
*                                fp_li_prps        TYPE tt_prps
                                fp_lst_prps       TYPE ty_prps
                                fp_li_mvke       TYPE tt_mvke
                                fp_li_marc       TYPE tt_marc
                                fp_li_detrm_costc TYPE tt_detrm_costc
                                fp_li_csks        TYPE tt_csks
                                fp_li_t001        TYPE tt_t001
                                fp_li_makt_prod   TYPE tt_makt
                       CHANGING fp_lv_flag_status TYPE char1. " Lv_flag_status of type CHAR1

* Local Variable Declaration
  DATA :  lv_exist_proj_defn TYPE ps_pspid, " Project Definition
          lv_posid_e         TYPE ps_posid. " Work Breakdown Structure Element (WBS Element)

* Local Work Area Declaration
  DATA: lst_wbs_element2   TYPE bapi_bus2054_chg, " Data Structure: Change WBS Element
        lst_wbs_element2_u TYPE bapi_bus2054_upd, " Update Structure: Change WBS Element
        lst_prps           TYPE ty_prps,
        lst_csks           TYPE ty_csks,
        lst_mvke           TYPE ty_mvke,
        lst_marc           TYPE ty_marc,
        lst_t001           TYPE ty_t001,
        lst_message        TYPE ty_message,
        lst_project2       TYPE bapi_bus2001_chg, " Data Structure: Change Project Definition
        lst_project2_u     TYPE bapi_bus2001_upd, " Update Structure: Change Project Definition
        lst_return         TYPE bapiret2.         " Return Parameter

* Local Internal Table
  DATA : li_wbs_element2   TYPE TABLE OF bapi_bus2054_chg, " Data Structure: Change WBS Element
         li_wbs_element2_u TYPE TABLE OF bapi_bus2054_upd, " Update Structure: Change WBS Element
         li_return         TYPE TABLE OF bapiret2.         " Return Parameter

* Local Constant Declaration
  CONSTANTS: lc_slwid TYPE slwid VALUE 'Z000001'. " Key word ID for user-defined fields

*Change WBS

* Checking if it is journal project
  IF fp_lst_prps-slwid = lc_slwid.

* Fetching the project definition number
    CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
      EXPORTING
        input  = fp_lst_prps-psphi
      IMPORTING
        output = lv_exist_proj_defn.

*    CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
*      EXPORTING
*        input  = fp_lst_prps-posid
*      IMPORTING
*        output = lv_posid_e.

** Populate WBS Element
*    lst_wbs_element2-wbs_element                     = lv_posid_e.
** Description
*    lst_wbs_element2-description                     = fp_lst_mara_issue-maktx.


    READ TABLE fp_li_mvke INTO lst_mvke WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                                                 BINARY SEARCH .
    IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0
    READ TABLE fp_li_marc INTO lst_marc WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                                                  BINARY SEARCH .
    IF sy-subrc EQ 0.
      lst_wbs_element2-profit_ctr       = lst_marc-prctr.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE fp_li_detrm_costc ASSIGNING FIELD-SYMBOL(<lst_detrm_costc>)
                                   WITH KEY extwg = fp_lst_mara_issue-extwg                     "prctr = lst_marc-prctr
                                           werks = lst_mvke-dwerk
                                  BINARY SEARCH .
    IF sy-subrc EQ 0.
* Responsible Cost Center
      lst_wbs_element2-respsbl_cctr       = <lst_detrm_costc>-kostl.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_detrm_costc>-kostl
        IMPORTING
          output = <lst_detrm_costc>-kostl.

      READ TABLE fp_li_csks INTO lst_csks
                            WITH KEY kostl = <lst_detrm_costc>-kostl
                            BINARY SEARCH.
      IF sy-subrc = 0.
* Populate Company Code
        lst_wbs_element2-company_code       = lst_csks-bukrs .

      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc EQ 0

*  Populate Project Currency
    READ TABLE fp_li_t001 INTO lst_t001
                          WITH KEY bukrs = lst_csks-bukrs
                          BINARY SEARCH.
    IF sy-subrc = 0.
      lst_wbs_element2-currency   = lst_t001-waers .
    ENDIF. " IF sy-subrc = 0

** Profit Center
*    lst_wbs_element2-profit_ctr                       = fp_lst_mara_issue-prctr.
*
*    lst_wbs_element2-user_field_char20_1              = fp_lst_mara_issue-identcode.
**    lst_wbs_element2-user_field_char20_2              = fp_lst_mara_issue-identcode.
** Publication/ In-Service Date (user defined field)
*    lst_wbs_element2-user_field_date1                = fp_lst_mara_issue-isminitshipdate . "Estimated Publication Date (user defined field)
*
** Estimated Publication Date (user defined field)
*    lst_wbs_element2-user_field_date2                = fp_lst_mara_issue-ismpubldate.
*    APPEND lst_wbs_element2 TO li_wbs_element2.
*    CLEAR: lst_wbs_element2.
*
*    lst_wbs_element2_u-wbs_element                     = lv_posid_e.
*    lst_wbs_element2_u-description                     = abap_true.
*    lst_wbs_element2_u-company_code                    = abap_true.
*    lst_wbs_element2_u-profit_ctr                      = abap_true.
*    lst_wbs_element2_u-currency                        = abap_true.
*    lst_wbs_element2_u-user_field_char20_1               = abap_true.
**    lst_wbs_element2-user_field_char20_2               = abap_true.
*    lst_wbs_element2_u-user_field_date1                = abap_true.
*    lst_wbs_element2_u-user_field_date2                = abap_true.
*    APPEND lst_wbs_element2_u TO li_wbs_element2_u.
*    CLEAR: lst_wbs_element2_u.

*     Additionally Update Level-1 WBS Element as well
*     Level-1 WBS will have the same name as the Project Definition

*      lst_wbs_element2-company_code                    = lst_prps-pbukr.
*      lst_wbs_element2-profit_ctr                      = lst_prps-prctr.
    lst_wbs_element2-wbs_element                     = lv_exist_proj_defn.
*    lst_wbs_element2-currency                        = lst_t001-waers.
*   Description
    READ TABLE fp_li_makt_prod ASSIGNING FIELD-SYMBOL(<lst_makt>)
                                    WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                                    BINARY SEARCH .
    IF sy-subrc EQ 0.
      CONCATENATE <lst_makt>-maktx
                  fp_lst_mara_issue-ismcopynr
             INTO lst_wbs_element2-description
        SEPARATED BY space.
      lst_wbs_element2_u-description                   = abap_true.

      lst_wbs_element2-user_field_char20_1              = <lst_makt>-identcode.
      lst_wbs_element2_u-user_field_char20_1           = abap_true.
    ENDIF. " IF sy-subrc EQ 0
    APPEND lst_wbs_element2 TO li_wbs_element2.
    CLEAR: lst_wbs_element2.

    lst_wbs_element2_u-wbs_element                   = lv_exist_proj_defn.
    lst_wbs_element2_u-company_code                  = abap_true.
    lst_wbs_element2_u-profit_ctr                    = abap_true.
    lst_wbs_element2_u-currency                      = abap_true.
    APPEND lst_wbs_element2_u TO li_wbs_element2_u.
    CLEAR: lst_wbs_element2_u.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.
*
    CALL FUNCTION 'BAPI_BUS2054_CHANGE_MULTI'
      EXPORTING
        i_project_definition  = lv_exist_proj_defn
      TABLES
        it_wbs_element        = li_wbs_element2
        it_update_wbs_element = li_wbs_element2_u
        et_return             = li_return.

    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        lst_message-matnr = fp_lst_mara_issue-ismrefmdprod.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.

      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-message = lst_return-message.
*Begin of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          lst_message-matnr = fp_lst_mara_issue-ismrefmdprod.
*End of Change:INC0196438:NGADRE:28-MAY-2018:ED1K907527
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

      IF fp_lv_flag_status = abap_true.
        lst_message-message  = 'Project/WBS cannot be changed for MPM Product :'(012).
        lst_message-matnr   =  fp_lst_mara_issue-ismrefmdprod.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        RETURN.
      ELSE. " ELSE -> IF fp_lv_flag_status = abap_true
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF. " IF fp_lv_flag_status = abap_true
    ENDIF. " IF fp_lv_flag_status = abap_false
    CLEAR fp_lv_flag_status .

* change Project
    READ TABLE fp_li_makt_prod ASSIGNING <lst_makt>
                                    WITH KEY matnr = fp_lst_mara_issue-ismrefmdprod
                                    BINARY SEARCH .
    IF sy-subrc EQ 0.
      CONCATENATE <lst_makt>-maktx
                  fp_lst_mara_issue-ismcopynr
             INTO lst_project2-description
        SEPARATED BY space.
    ENDIF. " IF sy-subrc EQ 0

* Change project
    lst_project2-project_definition = lv_exist_proj_defn.
    lst_project2-responsible_no   = p_respno .
    lst_project2-applicant_no     = p_apppno .
    lst_project2-start              = sy-datum .
    lst_project2-finish             = sy-datum .
    lst_project2-company_code       = lst_csks-bukrs.
    lst_project2-profit_ctr         = fp_lst_mara_issue-prctr.


    lst_project2_u-description        = abap_true .
    lst_project2_u-responsible_no     = abap_true .
    lst_project2_u-applicant_no       = abap_true .
    lst_project2_u-start              = abap_true .
    lst_project2_u-finish             = abap_true .
    lst_project2_u-company_code       = abap_true.
    lst_project2_u-profit_ctr         = abap_true.

    CALL FUNCTION 'BAPI_PS_INITIALIZATION'.

    CLEAR li_return.
    CALL FUNCTION 'BAPI_BUS2001_CHANGE'
      EXPORTING
        i_project_definition     = lst_project2
        i_project_definition_upd = lst_project2_u
      TABLES
        et_return                = li_return.

    LOOP AT li_return INTO lst_return.
      IF lst_return-type = c_e.
        lst_message-pspid   = lv_exist_proj_defn.
        lst_message-matnr   = fp_lst_mara_issue-ismrefmdprod.
        lst_message-message = lst_return-message.
        APPEND lst_message TO i_message.
        CLEAR lst_message.
        CLEAR lst_return.
        fp_lv_flag_status = abap_true.
      ENDIF. " IF lst_return-type = c_e
      CLEAR lst_return.
    ENDLOOP. " LOOP AT li_return INTO lst_return
    CLEAR li_return[].

    IF fp_lv_flag_status = abap_false.
      CALL FUNCTION 'BAPI_PS_PRECOMMIT'
        TABLES
          et_return = li_return.

      LOOP AT li_return INTO lst_return.
        IF lst_return-type = c_e.
          lst_message-pspid   = lv_exist_proj_defn.
          lst_message-matnr   = fp_lst_mara_issue-ismrefmdprod.
          lst_message-message = lst_return-message.
          APPEND lst_message TO i_message.
          CLEAR lst_message.
          CLEAR lst_return.
          fp_lv_flag_status = abap_true.
        ENDIF. " IF lst_return-type = c_e
        CLEAR lst_return.
      ENDLOOP. " LOOP AT li_return INTO lst_return
      CLEAR li_return[].

      IF fp_lv_flag_status = abap_false.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF. " IF fp_lv_flag_status = abap_false
    ENDIF. " IF fp_lv_flag_status = abap_false

    IF fp_lv_flag_status = abap_false.
      v_success = abap_true.
      lst_message-pspid = lv_exist_proj_defn.
      lst_message-message = text-016. " - Project/WBS changed succesfully for Issue :
      lst_message-matnr = fp_lst_mara_issue-ismrefmdprod.
      APPEND lst_message TO i_message.
      CLEAR lst_message.
    ENDIF. " IF fp_lv_flag_status = abap_false

  ENDIF. " IF fp_lst_prps-slwid = lc_slwid
ENDFORM.
