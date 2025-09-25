*----------------------------------------------------------------------*
***INCLUDE LZQTC_JGC_SOCIETYF01.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906805
* REFERENCE NO: ERP-2856
* DEVELOPER: WROY (Writtick Roy)
* DATE:  2017-06-19
* DESCRIPTION: Validate Journal Group Code to Society Mapping
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_DETERMINE_VARKEY_SOC
*&---------------------------------------------------------------------*
*       Determine Variable key
*----------------------------------------------------------------------*
*      -->FP_IDOC_CONTRL      IDoc Control Record
*      -->FP_IDOC_DATA        IDoc Data Record
*      <--FP_LST_DATA_E1KOMG  Filter segment with separated condition key
*----------------------------------------------------------------------*
FORM f_determine_varkey_soc  USING    fp_idoc_contrl     TYPE edidc_tt
                                      fp_idoc_data       TYPE edidd_tt
                             CHANGING fp_lst_data_e1komg TYPE e1komg
* Begin of ADD:ERP-2856:WROY:19-JUN-2017:ED2K906805
                                      fp_lv_error        TYPE flag.
* End   of ADD:ERP-2856:WROY:09-JUN-2017:ED2K906805

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
  DATA:
    lv_table_name   TYPE tabname16,
    lv_access_prgrm TYPE progname.

*========================================================================*
*                         WORK AREA DECLARATIONS                         *
*========================================================================*
  DATA:
    lst_komg        TYPE komg,                          "Allowed Fields for Condition Structures
    lst_varcond_soc TYPE zstqtc_varcond_society,        "Variable Condition - Society
    lst_mat_general TYPE mara.                          "General Material Data

  IF fp_lst_data_e1komg-vakey      IS NOT INITIAL OR
     fp_lst_data_e1komg-vakey_long IS NOT INITIAL.
    RETURN.
  ENDIF.

* Get the Access Program Name
  PERFORM set_access_program(sapmv130)
    USING fp_lst_data_e1komg-kvewe
          fp_lst_data_e1komg-kotabnr
          lv_access_prgrm.
  IF lv_access_prgrm IS NOT INITIAL.
    MOVE-CORRESPONDING fp_lst_data_e1komg TO lst_komg.

    CONCATENATE fp_lst_data_e1komg-kvewe
                fp_lst_data_e1komg-kotabnr
           INTO lv_table_name.
    CONDENSE lv_table_name.
    CASE lv_table_name.
      WHEN 'A911'.
*       Logic to populate Business Partner 2 or Society number
        IF fp_lst_data_e1komg-varcond IS NOT INITIAL.
          lst_varcond_soc = fp_lst_data_e1komg-varcond.
          MOVE-CORRESPONDING lst_varcond_soc TO lst_komg.
        ELSE.
          IF fp_lst_data_e1komg-matnr IS NOT INITIAL.
            CALL FUNCTION 'MARA_SINGLE_READ'
              EXPORTING
                matnr             = fp_lst_data_e1komg-matnr
              IMPORTING
                wmara             = lst_mat_general
              EXCEPTIONS
                lock_on_material  = 1
                lock_system_error = 2
                wrong_call        = 3
                not_found         = 4
                OTHERS            = 5.
            IF sy-subrc EQ 0.
*             Determine and Process Society details
              PERFORM f_det_prc_society USING    lst_mat_general-extwg
                                                 fp_idoc_contrl
                                                 fp_idoc_data
                                        CHANGING lst_komg
* Begin of ADD:ERP-2856:WROY:19-JUN-2017:ED2K906805
                                                 fp_lv_error.
* End   of ADD:ERP-2856:WROY:09-JUN-2017:ED2K906805
            ENDIF.
          ENDIF.
        ENDIF.

      WHEN 'A952' OR 'A953'.
        IF fp_lst_data_e1komg-varcond IS NOT INITIAL.
          MOVE fp_lst_data_e1komg-varcond TO lst_komg-zzpstyv.
        ENDIF.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.

*   Map fields from Communication structure to Variable Key
    PERFORM fill_vakey_from_komg IN PROGRAM (lv_access_prgrm)
      USING fp_lst_data_e1komg-vakey_long
            lst_komg.
    IF strlen( fp_lst_data_e1komg-vakey_long ) LE 50.
      fp_lst_data_e1komg-vakey = fp_lst_data_e1komg-vakey_long.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DET_PRC_SOCIETY
*&---------------------------------------------------------------------*
*       Determine and Process Society details
*----------------------------------------------------------------------*
*      -->FP_EXTWG       External Material Group
*      -->FP_IDOC_CONTRL IDoc Control Record
*      -->FP_IDOC_DATA   IDoc Data Record
*      <--FP_LST_KOMG    Allowed Fields for Condition Structures
*----------------------------------------------------------------------*
FORM f_det_prc_society  USING    fp_extwg       TYPE extwg
                                 fp_idoc_contrl TYPE edidc_tt
                                 fp_idoc_data   TYPE edidd_tt
                        CHANGING fp_lst_komg    TYPE komg
* Begin of ADD:ERP-2856:WROY:19-JUN-2017:ED2K906805
                                 fp_lv_error    TYPE flag.
* End   of ADD:ERP-2856:WROY:09-JUN-2017:ED2K906805

  DATA:
    li_society TYPE ztqtc_varcond_society.

* Fetch Journal Group Code to Society Mapping
  SELECT reltyp                                            "Business Partner Relationship Category
         society                                           "Business Partner 2 or Society number
    FROM zqtc_jgc_society
    INTO TABLE li_society
   WHERE jrnl_grp_code    EQ fp_extwg
     AND pricing_relevant EQ abap_true.
  IF sy-subrc EQ 0.
    READ TABLE li_society ASSIGNING FIELD-SYMBOL(<lst_society>)
         INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <lst_society> TO fp_lst_komg.
      UNASSIGN: <lst_society>.
      DELETE li_society INDEX 1.
    ENDIF.
* Begin of ADD:ERP-2856:WROY:19-JUN-2017:ED2K906805
  ELSE.
    fp_lv_error = abap_true.
*   Message: Entry missing in Table
    MESSAGE e902(gj) WITH fp_extwg 'ZQTC_JGC_SOCIETY' INTO DATA(lv_msg_txt).
* End   of ADD:ERP-2856:WROY:09-JUN-2017:ED2K906805
  ENDIF.

  IF li_society[] IS NOT INITIAL.
    CALL FUNCTION 'ZQTC_JGC_SOCIETY_TRIGGER_IDOC'
      IN BACKGROUND TASK
      EXPORTING
        im_idoc_contrl = fp_idoc_contrl
        im_idoc_data   = fp_idoc_data
        im_jgc_society = li_society.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUSTOM_FIELDS
*&---------------------------------------------------------------------*
*       Validate Custom Fields
*----------------------------------------------------------------------*
*      -->FP_LST_DATA_E1KOMG  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_custom_fields  USING    fp_lst_data_e1komg TYPE e1komg
                               CHANGING fp_lv_error        TYPE flag.

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
  DATA:
    lv_access_prgrm TYPE progname.                      "ABAP Program Name

*========================================================================*
*                         WORK AREA DECLARATIONS                         *
*========================================================================*
  DATA:
    lst_komg        TYPE komg.                          "Allowed Fields for Condition Structures

  IF fp_lst_data_e1komg-vakey      IS INITIAL AND
     fp_lst_data_e1komg-vakey_long IS INITIAL.
    RETURN.
  ENDIF.

* Get the Access Program Name
  PERFORM set_access_program(sapmv130)
    USING fp_lst_data_e1komg-kvewe
          fp_lst_data_e1komg-kotabnr
          lv_access_prgrm.
  IF lv_access_prgrm IS NOT INITIAL.
*   Map fields from Variable Key to Communication structure
    PERFORM fill_komg_from_vakey IN PROGRAM (lv_access_prgrm)
      USING lst_komg
            fp_lst_data_e1komg-vakey_long.

    IF fp_lv_error IS INITIAL.
*     Validate Header Fields
      PERFORM f_validate_comm_hdr USING    lst_komg
                                  CHANGING fp_lv_error.
    ENDIF.
    IF fp_lv_error IS INITIAL.
*     Validate Header Fields
      PERFORM f_validate_comm_itm USING    lst_komg
                                  CHANGING fp_lv_error.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_COMM_HDR
*&---------------------------------------------------------------------*
*       Validate Header Fields
*----------------------------------------------------------------------*
*      -->FP_LST_KOMG  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_comm_hdr  USING    fp_lst_komg TYPE komg
                          CHANGING fp_lv_error TYPE flag.

  CONSTANTS:
    lc_komk_str TYPE tabname16 VALUE 'ZZAKOMKAZ'.

  DATA:
    li_fld_list TYPE ddfields.

  FIELD-SYMBOLS:
    <lv_field>  TYPE any.

* Get the list of custom fields
  PERFORM f_get_field_list USING    lc_komk_str
                           CHANGING li_fld_list.

  LOOP AT li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_det>).
    ASSIGN COMPONENT <lst_fld_det>-fieldname OF STRUCTURE fp_lst_komg TO <lv_field>.
    IF sy-subrc   EQ 0 AND
       <lv_field> IS NOT INITIAL.
      CASE <lst_fld_det>-fieldname.
        WHEN 'ZZPARTNER2'.
*         Validate Business Partner 2 or Society number
          PERFORM f_validate_partner2 USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN 'ZZRELTYP'.
*         Validate Business Partner Relationship Category
          PERFORM f_validate_reltyp   USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN 'ZZKVGR1'.
*         Validate Customer group 1
          PERFORM f_validate_kvgr1    USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_COMM_ITM
*&---------------------------------------------------------------------*
*       Validate Header Fields
*----------------------------------------------------------------------*
*      -->FP_LST_KOMG  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_comm_itm  USING    fp_lst_komg TYPE komg
                          CHANGING fp_lv_error TYPE flag.

  CONSTANTS:
    lc_komp_str TYPE tabname16 VALUE 'ZZAKOMPAZ'.

  DATA:
    li_fld_list TYPE ddfields.

  FIELD-SYMBOLS:
    <lv_field>  TYPE any.

* Get the list of custom fields
  PERFORM f_get_field_list USING    lc_komp_str
                           CHANGING li_fld_list.

  LOOP AT li_fld_list ASSIGNING FIELD-SYMBOL(<lst_fld_det>).
    ASSIGN COMPONENT <lst_fld_det>-fieldname OF STRUCTURE fp_lst_komg TO <lv_field>.
    IF sy-subrc   EQ 0 AND
       <lv_field> IS NOT INITIAL.
      CASE <lst_fld_det>-fieldname.
        WHEN 'ZZPROMO'.
*         Validate Promo code
          PERFORM f_validate_promo    USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN 'ZZISMPUBLTYPE'.
*         Validate Publication Type
          PERFORM f_validate_publtype USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN 'ZZVLAUFK'.
*         Validate Validity period category of contract
          PERFORM f_validate_vlaufk   USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN 'ZZPSTYV'.
*         Validate Sales document item category
          PERFORM f_validate_pstyv    USING    <lv_field>
                                      CHANGING fp_lv_error.
          IF fp_lv_error IS NOT INITIAL.
            EXIT.
          ENDIF.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FIELD_LIST
*&---------------------------------------------------------------------*
*       Get the list of custom fields
*----------------------------------------------------------------------*
*      -->FP_P_TNAME  text
*      <--FP_LI_FLD_LIST  text
*----------------------------------------------------------------------*
FORM f_get_field_list  USING    fp_p_tname      TYPE tabname16
                       CHANGING fp_li_fld_list  TYPE ddfields.

* Data Declaration
  DATA:
    lr_struc_desc TYPE REF TO cl_abap_structdescr. "Describe a Structure

* Get Description of data object type (Table)
  lr_struc_desc ?= cl_abap_typedescr=>describe_by_name( fp_p_tname ).

* List of Dictionary Descriptions for all Components
  CALL METHOD lr_struc_desc->get_ddic_field_list
    EXPORTING
      p_langu                  = sy-langu       "Language Key
      p_including_substructres = abap_true      "List Also for Substructures
    RECEIVING
      p_field_list             = fp_li_fld_list "List of Dictionary Descriptions for the Components
    EXCEPTIONS
      not_found                = 1
      no_ddic_type             = 2
      OTHERS                   = 3.
  IF sy-subrc NE 0.
    CLEAR: fp_li_fld_list.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PARTNER2
*&---------------------------------------------------------------------*
*       Validate Business Partner 2 or Society number
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  Business Partner Number
*      <--FP_LV_ERROR  Flag: Error
*----------------------------------------------------------------------*
FORM f_validate_partner2  USING    fp_lv_field TYPE bu_partner
                          CHANGING fp_lv_error TYPE flag.

* BP: General data
  SELECT SINGLE partner
    FROM but000
    INTO @DATA(lv_partner)
   WHERE partner EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Error: Invalid Business Partner ID: &1
    MESSAGE e108(sepm_dg) WITH fp_lv_field INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_RELTYP
*&---------------------------------------------------------------------*
*       Validate Business Partner Relationship Category
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_reltyp  USING    fp_lv_field TYPE bu_reltyp
                        CHANGING fp_lv_error TYPE flag.

* BP relationship categories
  SELECT reltyp
    FROM tbz9
   UP TO 1 ROWS
    INTO @DATA(lv_reltyp)
   WHERE reltyp EQ @fp_lv_field.
  ENDSELECT.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Relationship category & is not defined
    MESSAGE e055(b0) WITH fp_lv_field INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KVGR1
*&---------------------------------------------------------------------*
*       Validate Customer group 1
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD   text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_kvgr1  USING    fp_lv_field TYPE kvgr1
                       CHANGING fp_lv_error TYPE flag.

* Customer Group 1
  SELECT SINGLE kvgr1
    FROM tvv1
    INTO @DATA(lv_kvgr1)
   WHERE kvgr1 EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Error: Customer group &1 does not exist
    MESSAGE e092(w_cb) WITH fp_lv_field INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PROMO
*&---------------------------------------------------------------------*
*       Validate Promo code
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_promo  USING    fp_lv_field TYPE zpromo
                       CHANGING fp_lv_error TYPE flag.

* Agreements
  SELECT SINGLE knuma
    FROM kona
    INTO @DATA(lv_knuma)
   WHERE knuma EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Enter a valid Promo Code
    MESSAGE e016(zqtc_r2) INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PUBLTYPE
*&---------------------------------------------------------------------*
*       Validate Publication Type
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_publtype  USING    fp_lv_field TYPE ismpubltype
                          CHANGING fp_lv_error TYPE flag.

* Publication Type Customizing Table
  SELECT SINGLE ismpubltype
    FROM tjppubtp
    INTO @DATA(lv_publtype)
   WHERE ismpubltype EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Invalid Publication Type &1.
    MESSAGE e135(zqtc_r2) WITH fp_lv_field INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VLAUFK
*&---------------------------------------------------------------------*
*       Validate Validity period category of contract
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_vlaufk  USING    fp_lv_field TYPE vlauk_veda
                        CHANGING fp_lv_error TYPE flag.

* Validity Period Category
  SELECT SINGLE vlaufk
    FROM tvlz
    INTO @DATA(lv_vlaufk)
   WHERE vlaufk EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Enter a valid period category
    MESSAGE e225(fkkbi) INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PSTYV
*&---------------------------------------------------------------------*
*       Validate Sales document item category
*----------------------------------------------------------------------*
*      -->FP_LV_FIELD  text
*      <--FP_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_validate_pstyv  USING    fp_lv_field TYPE pstyv
                       CHANGING fp_lv_error TYPE flag.

* Sales documents: Item categories
  SELECT SINGLE pstyv
    FROM tvpt
    INTO @DATA(lv_pstyv)
   WHERE pstyv EQ @fp_lv_field.
  IF sy-subrc NE 0.
    fp_lv_error = abap_true.
*   Message: Invalid item category
    MESSAGE e097(61) INTO DATA(lv_err_txt).
  ENDIF.

ENDFORM.
