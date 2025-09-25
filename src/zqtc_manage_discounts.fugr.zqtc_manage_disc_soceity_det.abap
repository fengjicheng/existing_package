*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_MANAGE_DISC_SOCEITY_DET (Function Module)
* PROGRAM DESCRIPTION: Determine most suitable Soceity
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07-FEB-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905792
* REFERENCE NO:  CR#490
* DEVELOPER: Writtick Roy (WROY)
* DATE:  22-MAY-2017
* DESCRIPTION: Whenever Relationship Category = ZPR003, ZPR004, ZPR005,
*              ZPR006 or ZPR010, look for condition records with
*              Relationship Category = ZPR008
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906514
* REFERENCE NO: CR#549
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: Re-determine Relationship Data if Pricing Date is changed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906690
* REFERENCE NO: ERP-2718
* DEVELOPER: Writtick Roy (WROY)
* DATE:  13-JUN-2017
* DESCRIPTION: Use the Original Relationship Category; it was getting
*              overwritten through CR#549 logic.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907861, ED2K908648, ED2K908740
* REFERENCE NO: ERP-4105
* DEVELOPER: Writtick Roy (WROY)
* DATE:  10-AUG-2017
* DESCRIPTION: Implement SAP's recommendations
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909134
* REFERENCE NO: ERP-XXXX
* DEVELOPER: Writtick Roy (WROY)
* DATE:  23-OCT-2017
* DESCRIPTION: Implement SAP's recommendations
*----------------------------------------------------------------------*
FUNCTION zqtc_manage_disc_soceity_det.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_TKOMK) TYPE  KOMK
*"     REFERENCE(IM_TKOMP) TYPE  KOMP
*"     REFERENCE(IM_KSCHL) TYPE  KSCHA
*"     REFERENCE(IM_PRC_DATE) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_ZZPARTNER2) TYPE  ZZPARTNER2
*"     REFERENCE(EX_ZZRELTYP) TYPE  BU_RELTYP
*"     REFERENCE(EX_ZZRELTYP_O) TYPE  BU_RELTYP
*"  EXCEPTIONS
*"      EXC_NO_SOCEITY
*"      EXC_INVALID_COND_TYPE
*"----------------------------------------------------------------------

  DATA:
    li_relations TYPE but050_tty,                               "BP relationships/role definitions: General data
    li_fld_names TYPE fkk_rt_fieldname,                         "Field Name
*   Begin of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
    li_constants TYPE zcat_constants,                           "Wiley Application Constant Table
*   End   of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
    li_t682ia    TYPE STANDARD TABLE OF t682ia INITIAL SIZE 0,  "Conditions: Access Sequences (Generated Form)
*   Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
    li_t682ia_r  TYPE STANDARD TABLE OF t682ia INITIAL SIZE 0,  "Conditions: Access Sequences (Generated Form)
    li_t681e     TYPE tt_cond_str,
    li_t681e_r   TYPE tt_cond_str,
*   End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
    li_soc_nprc  TYPE tt_soc_nprc.                              "Net Price against Soceities

  DATA:
    lst_cond_hdr TYPE komk,                                     "Communication Header for Pricing
    lst_cond_itm TYPE komp,                                     "Communication Item for Pricing
    lst_t685a    TYPE t685a,                                    "Conditions: Types: Additional Price Element Data
    lst_t685     TYPE t685,                                     "Conditions: Types
    lst_cond_rec TYPE vakekond,                                 "Condition record
    lst_sp_relat TYPE ty_sp_relat.

* Begin of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = c_devid_075
    IMPORTING
      ex_constants = li_constants.
  SORT li_constants BY param1 param2 low.
* End   of ADD:CR 490:WROY:22-MAY-2017:ED2K905792

* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Re-determine Relationship Data if Pricing Date is changed
  IF im_prc_date IS NOT INITIAL.                                "Change in Pricing Date
*   Re-determine Relationship Data
    DELETE i_sp_relats WHERE kunwe = im_tkomk-kunwe.            "Ship-to Party
  ENDIF.
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Fetch BP relationships/role definitions: General data
  CLEAR: lst_sp_relat.
  READ TABLE i_sp_relats INTO lst_sp_relat
       WITH KEY kunwe = im_tkomk-kunwe                          "Ship-to Party
       BINARY SEARCH.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BUB_BUPR_BUT050_READ'
      EXPORTING
        e_partner       = im_tkomk-kunwe                        "Ship-to Party
      TABLES
        et_relations    = li_relations                          "BP relationships/role definitions: General data
      EXCEPTIONS
        not_found       = 1
        blocked_partner = 2
        OTHERS          = 3.
    IF sy-subrc  NE 0.
      CLEAR: li_relations.
    ELSE.
      DELETE li_relations WHERE partner1  NE im_tkomk-kunwe
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
                             OR date_to   LT im_tkomk-prsdt
                             OR date_from GT im_tkomk-prsdt.
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
*                            OR date_to   LT sy-datum
*                            OR date_from GT sy-datum.
* End   of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
    ENDIF.

    lst_sp_relat-kunwe = im_tkomk-kunwe.                        "Ship-to Party
    lst_sp_relat-relations = li_relations.                      "BP relationships/role definitions: General data
    IF li_relations[] IS NOT INITIAL.
      INSERT lst_sp_relat INTO TABLE i_sp_relats.
    ENDIF.
  ELSE.
    li_relations[] = lst_sp_relat-relations[].
  ENDIF.
  IF li_relations IS INITIAL.
    RAISE exc_no_soceity.                                       "Nothing to do if BP relationship doesn't exist
  ENDIF.

* Read Conditions: Types
  CALL FUNCTION 'SD_COND_T685_SELECT'
    EXPORTING
      cts_kappl = c_app_sales                                   "Application
      cts_kschl = im_kschl                                      "Condition Type
      cts_kvewe = c_kvewe_a                                     "Usage
    IMPORTING
      cts_t685  = lst_t685                                      "Conditions: Types
      cts_t685a = lst_t685a.                                    "Conditions: Types: Additional Price Element Data
  IF lst_t685 IS NOT INITIAL.
*   Begin of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
    READ TABLE i_t682ia TRANSPORTING NO FIELDS
         WITH KEY kvewe = c_kvewe_a                             "Usage
                  kappl = c_app_sales                           "Application
                  kozgf = lst_t685-kozgf                        "Access Sequence
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT i_t682ia ASSIGNING FIELD-SYMBOL(<lst_t682ia>) FROM sy-tabix.
        IF <lst_t682ia>-kvewe NE c_kvewe_a      OR              "Usage
           <lst_t682ia>-kappl NE c_app_sales    OR              "Application
           <lst_t682ia>-kozgf NE lst_t685-kozgf.                "Access Sequence
          EXIT.
        ENDIF.
        APPEND <lst_t682ia> TO li_t682ia.
      ENDLOOP.
    ELSE.
*   End   of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
      CALL FUNCTION 'COND_READ_ACCESSES'
        EXPORTING
          i_kvewe    = c_kvewe_a                                "Usage
          i_kappl    = c_app_sales                              "Application
          i_kozgf    = lst_t685-kozgf                           "Access Sequence
        TABLES
          t682ia_tab = li_t682ia.                               "Conditions: Access Sequences (Generated Form)
*   Begin of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
      APPEND LINES OF li_t682ia TO i_t682ia.
      SORT i_t682ia BY kvewe kappl kozgf.
    ENDIF.
*   End   of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
  ENDIF.
* Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  LOOP AT li_t682ia ASSIGNING <lst_t682ia>.
    READ TABLE i_t681e TRANSPORTING NO FIELDS
         WITH KEY kvewe   = <lst_t682ia>-kvewe                  "Usage of the condition table
                  kotabnr = <lst_t682ia>-kotabnr                "Condition table
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_tabix) = sy-tabix.
      LOOP AT i_t681e ASSIGNING FIELD-SYMBOL(<lst_t681e>) FROM lv_tabix.
        IF <lst_t681e>-kvewe   NE <lst_t682ia>-kvewe OR         "Usage of the condition table
           <lst_t681e>-kotabnr NE <lst_t682ia>-kotabnr.         "Condition table
          EXIT.
        ENDIF.
        IF <lst_t681e>-sefeld IS NOT INITIAL.
          APPEND <lst_t681e> TO li_t681e.
        ENDIF.
      ENDLOOP.
    ELSE.
      APPEND <lst_t682ia> TO li_t682ia_r.
    ENDIF.
  ENDLOOP.
  IF li_t682ia_r IS NOT INITIAL.
* End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
* Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
* IF li_t682ia IS NOT INITIAL.
* End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
    APPEND INITIAL LINE TO li_fld_names ASSIGNING FIELD-SYMBOL(<lst_fld_name>).
    <lst_fld_name>-sign   = c_sign_i.                           "Sign: (I)nclude
    <lst_fld_name>-option = c_opti_cp.                          "Option: (C)ontans (P)attern
    <lst_fld_name>-low    = c_fld_rltyp.
    APPEND INITIAL LINE TO li_fld_names ASSIGNING <lst_fld_name>.
    <lst_fld_name>-sign   = c_sign_i.                           "Sign: (I)nclude
    <lst_fld_name>-option = c_opti_cp.                          "Option: (C)ontans (P)attern
    <lst_fld_name>-low    = c_fld_prtnr.

*   Fetch Conditions: Structures
    SELECT a~kvewe,	                                            "Usage of the condition table
           a~kotabnr,                                           "Condition table
           a~kappl,                                             "Application
           a~kotab,                                             "Condition table
           b~setyp,                                             "Fast entry type for condition tables
           b~fsetyp,                                            "Type of field in fast entry
           b~fselnr,                                            "Sequential number of the fast entry field
           b~sefeld                                             "Fast entry field (internal field name)
      FROM t681  AS a INNER JOIN
           t681e AS b
        ON a~kvewe   EQ b~kvewe
       AND a~kotabnr EQ b~kotabnr
*   Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
      INTO TABLE @li_t681e_r
       FOR ALL ENTRIES IN @li_t682ia_r
     WHERE a~kvewe   EQ @li_t682ia_r-kvewe                      "Usage of the condition table
       AND a~kotabnr EQ @li_t682ia_r-kotabnr                    "Condition table
       AND b~sefeld  IN @li_fld_names.
    IF sy-subrc EQ 0.
      SORT li_t681e_r BY kvewe kotabnr.
    ENDIF.
*   To avoid further DB hits, create dummy entries for the unsuccessful records
    LOOP AT li_t682ia_r ASSIGNING FIELD-SYMBOL(<lst_t682ia_r>).
      READ TABLE li_t681e_r TRANSPORTING NO FIELDS
           WITH KEY kvewe   = <lst_t682ia_r>-kvewe            "Usage of the condition table
                    kotabnr = <lst_t682ia_r>-kotabnr          "Condition table
           BINARY SEARCH.
      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO i_t681e ASSIGNING <lst_t681e>.
        <lst_t681e>-kvewe   = <lst_t682ia_r>-kvewe.           "Usage of the condition table
        <lst_t681e>-kotabnr = <lst_t682ia_r>-kotabnr.         "Condition table
      ENDIF.
    ENDLOOP.

    APPEND LINES OF li_t681e_r TO: li_t681e,
                                   i_t681e.
    SORT i_t681e BY kvewe kotabnr.
    CLEAR: li_t681e_r.
*   End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
*   Begin of DEL:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
*     INTO TABLE @DATA(li_t681e)
*      FOR ALL ENTRIES IN @li_t682ia
*    WHERE a~kvewe   EQ @li_t682ia-kvewe                        "Usage of the condition table
*      AND a~kotabnr EQ @li_t682ia-kotabnr                      "Condition table
*      AND b~sefeld  IN @li_fld_names.
*   IF sy-subrc EQ 0.
*     SORT li_t681e BY kotab.
*   ENDIF.
*   End   of DEL:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  ENDIF.
  IF li_t681e[] IS INITIAL.
    RAISE exc_invalid_cond_type.
* Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  ELSE.
    SORT li_t681e BY kotab.
* End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  ENDIF.

  LOOP AT li_t681e ASSIGNING <lst_t681e>.
    AT NEW kotab.
      lst_cond_hdr = im_tkomk.                                  "Communication Header for Pricing
      lst_cond_itm = im_tkomp.                                  "Communication Item for Pricing
    ENDAT.

    IF <lst_t681e>-sefeld CP c_fld_rltyp.
      ASSIGN COMPONENT <lst_t681e>-sefeld OF STRUCTURE lst_cond_hdr TO FIELD-SYMBOL(<lv_rltyp>).
    ENDIF.
    IF <lst_t681e>-sefeld CP c_fld_prtnr.
      ASSIGN COMPONENT <lst_t681e>-sefeld OF STRUCTURE lst_cond_hdr TO FIELD-SYMBOL(<lv_prtnr>).
    ENDIF.

    AT END OF kotab.
      LOOP AT li_relations ASSIGNING FIELD-SYMBOL(<lst_relation>).
        IF <lv_rltyp> IS ASSIGNED.
*         Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
          DATA(lv_reltyp_o) = <lst_relation>-reltyp.            "Business Partner Relationship Category
*         End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
*         Begin of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
*         Whenever Relationship Category = ZPR003, ZPR004, ZPR005, ZPR006 or ZPR010,
*         look for condition records with Relationship Category = ZPR008
          READ TABLE li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
               WITH KEY param1 = c_param_rlc
                        param2 = im_kschl
                        low    = <lst_relation>-reltyp
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            <lst_relation>-reltyp = <lst_constant>-high.
          ENDIF.
*         End   of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
          <lv_rltyp> = <lst_relation>-reltyp.                   "Business Partner Relationship Category
        ENDIF.
        IF <lv_prtnr> IS ASSIGNED.
          <lv_prtnr> = <lst_relation>-partner2.                 "Business Partner 2 or Society number
        ENDIF.

*       Fetch Condition Record
        CLEAR: lst_cond_rec.
        CALL FUNCTION 'CONDITION_RECORD_READ'
          EXPORTING
            pi_kappl        = c_app_sales                       "Application: Sales
            pi_kschl        = im_kschl                          "Condition Type
            pi_kotabnr      = <lst_t681e>-kotabnr               "Condition Table
            pi_i_komk       = lst_cond_hdr                      "Communication Header for Pricing
            pi_i_komp       = lst_cond_itm                      "Communication Item for Pricing
            pi_scale_read   = abap_true                         "Flag: Read Scales
          IMPORTING
            pe_i_vake       = lst_cond_rec                      "Condition record
*       TABLES
*           PI_T_KSCHL      =
*           PX_T_XVAKE      =
*           PE_T_VAKE       =
*           PE_T_SCALE      =
          EXCEPTIONS
            no_record_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0 AND
           lst_cond_rec-kbetr IS NOT INITIAL.
*         Maintain Net Price against Soceities
          APPEND INITIAL LINE TO li_soc_nprc ASSIGNING FIELD-SYMBOL(<lst_soc_nprc>).
          <lst_soc_nprc>-partner2  = <lst_relation>-partner2.   "Business Partner 2 or Society number
          <lst_soc_nprc>-reltyp    = <lst_relation>-reltyp.     "Business Partner Relationship Category
          <lst_soc_nprc>-net_price = lst_cond_rec-kbetr.        "Net Price
*         Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
          <lst_soc_nprc>-reltyp_o  = lv_reltyp_o.               "Business Partner Relationship Category
*         End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
        ENDIF.
      ENDLOOP.
      UNASSIGN: <lv_rltyp>,
                <lv_prtnr>.
    ENDAT.
  ENDLOOP.

  IF li_soc_nprc IS NOT INITIAL.
    CASE lst_t685a-krech.                                       "Calculation type for condition.
      WHEN c_krech_prc.
*       Get the most cost-effective Net Price (largest percentage)
        SORT li_soc_nprc BY net_price ASCENDING.                "Considering Negative Sign for Discounts
      WHEN c_krech_qty.
*       Get the most cost-effective Net Price (smallest amount)
        SORT li_soc_nprc BY net_price ASCENDING.
    ENDCASE.

    READ TABLE li_soc_nprc ASSIGNING <lst_soc_nprc> INDEX 1.
    IF sy-subrc EQ 0.
      ex_zzpartner2 = <lst_soc_nprc>-partner2.                  "Business Partner 2 or Society number
      ex_zzreltyp   = <lst_soc_nprc>-reltyp.                    "Business Partner Relationship Category
*     Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
      ex_zzreltyp_o = <lst_soc_nprc>-reltyp_o.                  "Business Partner Relationship Category
*     End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
    ENDIF.
  ELSE.
    RAISE exc_no_soceity.                                       "Nothing to do if BP relationship can not be determined
  ENDIF.

ENDFUNCTION.
