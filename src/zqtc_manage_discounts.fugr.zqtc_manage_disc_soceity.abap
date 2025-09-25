FUNCTION zqtc_manage_disc_soceity.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_TKOMK) TYPE  KOMK
*"     REFERENCE(IM_TKOMP) TYPE  KOMP
*"  EXPORTING
*"     REFERENCE(EX_ZZPARTNER2) TYPE  ZZPARTNER2
*"     REFERENCE(EX_ZZRELTYP) TYPE  BU_RELTYP
*"  EXCEPTIONS
*"      EXC_NO_SOCEITY
*"----------------------------------------------------------------------

  DATA:
    li_constants TYPE zcat_constants,                           "Internal table for Constant Table
    li_price     TYPE zcat_constants,                           "Internal table for Constant Table (List Price)
    li_discount  TYPE zcat_constants,                           "Internal table for Constant Table (Discount)
    li_relations TYPE but050_tty,                               "BP relationships/role definitions: General data
    li_soc_nprc  TYPE tt_soc_nprc.                              "Net Price against Soceities

  DATA:
    lst_cond_hdr TYPE komk,                                     "Communication Header for Pricing
    lst_cond_itm TYPE komp,                                     "Communication Item for Pricing
    lst_cond_rec TYPE vakekond.                                 "Condition record

  DATA:
    lv_cond_type TYPE kschl,                                    "Condition Type
    lv_cond_tabl TYPE kotabnr,                                  "Condition Table
    lv_list_prc  TYPE kbetr,                                    "Rate: List Price
    lv_discount  TYPE kbetr,                                    "Rate: Discount
    lv_tot_disc  TYPE kbetr.                                    "Rate: Total Discount

* Fetch BP relationships/role definitions: General data
  CALL FUNCTION 'BUB_BUPR_BUT050_READ'
    EXPORTING
      e_partner       = im_tkomk-kunwe                          "Ship-to Party
    TABLES
      et_relations    = li_relations                            "BP relationships/role definitions: General data
    EXCEPTIONS
      not_found       = 1
      blocked_partner = 2
      OTHERS          = 3.
  IF sy-subrc  NE 0 OR
     li_relations IS INITIAL.
    RAISE exc_no_soceity.                                       "Nothing to do if BP relationship doesn't exist
  ENDIF.

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = c_devid_075                                "Development ID (E075)
    IMPORTING
      ex_constants = li_constants.                              "Constant Values

* Price Details
  li_price[] = li_constants[].
  DELETE li_price    WHERE param1 NE c_param_prc.
* Discount Details
  li_discount[] = li_constants[].
  DELETE li_discount WHERE param1 NE c_param_dsc.

  LOOP AT li_relations ASSIGNING FIELD-SYMBOL(<lst_relation>).
    CLEAR: lv_list_prc,
           lv_discount,
           lv_tot_disc.

    lst_cond_hdr = im_tkomk.                                    "Communication Header for Pricing
    lst_cond_itm = im_tkomp.                                    "Communication Item for Pricing

    lst_cond_hdr-zzpartner2 = <lst_relation>-partner2.          "Business Partner 2 or Society number
    lst_cond_hdr-zzreltyp   = <lst_relation>-reltyp.            "Business Partner Relationship Category

*   Get List Price
    LOOP AT li_price ASSIGNING FIELD-SYMBOL(<lst_price>).
      lv_cond_type = <lst_price>-param2.                        "Condition Type
      lv_cond_tabl = <lst_price>-low.                           "Condition Table

*     Fetch Condition Record
      CLEAR: lst_cond_rec.
      CALL FUNCTION 'CONDITION_RECORD_READ'
        EXPORTING
          pi_kappl        = c_app_sales                         "Application: Sales
          pi_kschl        = lv_cond_type                        "Condition Type
          pi_kotabnr      = lv_cond_tabl                        "Condition Table
          pi_i_komk       = lst_cond_hdr                        "Communication Header for Pricing
          pi_i_komp       = lst_cond_itm                        "Communication Item for Pricing
          pi_scale_read   = abap_true                           "Flag: Read Scales
        IMPORTING
          pe_i_vake       = lst_cond_rec                        "Condition record
*       TABLES
*         PI_T_KSCHL      =
*         PX_T_XVAKE      =
*         PE_T_VAKE       =
*         PE_T_SCALE      =
        EXCEPTIONS
          no_record_found = 1
          OTHERS          = 2.
      IF sy-subrc EQ 0 AND
         lst_cond_rec-kbetr IS NOT INITIAL.
        lv_list_prc = lst_cond_rec-kbetr.                       "List Price
        EXIT.
      ENDIF.
    ENDLOOP.
*   Do not consider the record, if List Price is not maintained
    IF lv_list_prc IS INITIAL.
      CONTINUE.
    ENDIF.

*   Get Discount
    LOOP AT li_discount ASSIGNING FIELD-SYMBOL(<lst_discount>).
      AT NEW param2.
        CLEAR: lv_discount.
      ENDAT.

      lv_cond_type = <lst_discount>-param2.                     "Condition Type
      lv_cond_tabl = <lst_discount>-low.                        "Condition Table

      IF lv_discount IS INITIAL.
        CLEAR: lst_cond_rec.
        CALL FUNCTION 'CONDITION_RECORD_READ'
          EXPORTING
            pi_kappl        = c_app_sales                       "Application: Sales
            pi_kschl        = lv_cond_type                      "Condition Type
            pi_kotabnr      = lv_cond_tabl                      "Condition Table
            pi_i_komk       = lst_cond_hdr                      "Communication Header for Pricing
            pi_i_komp       = lst_cond_itm                      "Communication Item for Pricing
          IMPORTING
            pe_i_vake       = lst_cond_rec                      "Condition record
          EXCEPTIONS
            no_record_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0 AND
           lst_cond_rec-kbetr IS NOT INITIAL.
          CASE <lst_discount>-high.
            WHEN c_calc_per.                                    "Discount: Percentage
              lv_discount = lv_list_prc * lst_cond_rec-kbetr / 1000.
            WHEN c_calc_amt.                                    "Discount: Amount
              lv_discount = lst_cond_rec-kbetr.
          ENDCASE.
        ENDIF.
      ENDIF.

      AT END OF param2.
        lv_tot_disc = lv_tot_disc + lv_discount.                "Total Discount
      ENDAT.
    ENDLOOP.

*   Maintain Net Price against Soceities
    APPEND INITIAL LINE TO li_soc_nprc ASSIGNING FIELD-SYMBOL(<lst_soc_nprc>).
    <lst_soc_nprc>-partner2  = <lst_relation>-partner2.         "Business Partner 2 or Society number
    <lst_soc_nprc>-reltyp    = <lst_relation>-reltyp.           "Business Partner Relationship Category
    <lst_soc_nprc>-net_price = lv_list_prc - lv_tot_disc.       "Net Price
  ENDLOOP.

  IF li_soc_nprc IS NOT INITIAL.
*   Get the most cost-effective Net Price (smallest amount)
    SORT li_soc_nprc BY net_price ASCENDING.
    READ TABLE li_soc_nprc ASSIGNING <lst_soc_nprc> INDEX 1.
    IF sy-subrc EQ 0.
      ex_zzpartner2 = <lst_soc_nprc>-partner2.                  "Business Partner 2 or Society number
      ex_zzreltyp   = <lst_soc_nprc>-reltyp.                    "Business Partner Relationship Category
    ENDIF.
  ELSE.
    RAISE exc_no_soceity.                                       "Nothing to do if BP relationship can not be determined
  ENDIF.

ENDFUNCTION.
