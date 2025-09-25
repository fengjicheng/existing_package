*----------------------------------------------------------------------*
***INCLUDE LZQTC_REPDETF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_REPDETF01 (Subroutines)
* PROGRAM DESCRIPTION: Maintain Sales Rep PIGS Table Lookup
* DEVELOPER: Mintu Naskar (MNASKAR)
* CREATION DATE:   11/04/2016
* OBJECT ID:  E129
* TRANSPORT NUMBER(S):  ED2K903251
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909197
* REFERENCE NO: ERP-4832
* DEVELOPER: Writtick Roy (WROY)
* DATE:  10/26/2017
* DESCRIPTION: Suppress Additional Message
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909690
* REFERENCE NO: ERP-4832
* DEVELOPER: Writtick Roy (WROY)
* DATE:  12/03/2017
* DESCRIPTION: Add logic for Sales Rep Validation
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913679
* REFERENCE NO: ERP-7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE:  25/10/2018
* DESCRIPTION: Addition of new field (Ship-to party)
*----------------------------------------------------------------------*
FORM f_suppress_columns.

  DATA:
    lv_cb_allf TYPE char1,                                      "Display All Fields
    lv_rb_prod TYPE char1,                                      "Material / Product
    lv_rb_dprd TYPE char1,                                      "Default (Product)
    lv_rb_prft TYPE char1,                                      "Profit Center
    lv_rb_bpid TYPE char1,                                      "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
    lv_bsark   TYPE bsark,                                      "PO Type
    lv_rb_sp   TYPE char1,                                      "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
    lv_rb_dind TYPE char1,                                      "Default (Industry)
    lv_rb_cgrp TYPE char1,                                      "Customer Group
    lv_rb_pcds TYPE char1,                                      "Postal Code (Individual)
    lv_rb_pcdr TYPE char1,                                      "Postal Code (Range)
    lv_rb_regn TYPE char1,                                      "Region
    lv_rb_land TYPE char1,                                      "Country
    lv_rb_dgeo TYPE char1,                                      "Default (Geography)
    lv_p_datum TYPE sydatum,                                    "As-on Date
    lv_table   TYPE tabname,                                    "Table Name
    lv_field   TYPE fieldname,                                  "Field Name
    lv_active  TYPE flag.                                       "Flag: Field is active

  CONSTANTS:
    lc_f_datbi TYPE viewfield  VALUE 'DATBI',                   "Valid To Date
    lc_f_datab TYPE viewfield  VALUE 'DATAB',                   "Valid-From Date
    lc_f_matnr TYPE viewfield  VALUE 'MATNR',                   "Material / Product
    lc_f_prctr TYPE viewfield  VALUE 'PRCTR',                   "Profit Center
    lc_f_kunnr TYPE viewfield  VALUE 'KUNNR',                   "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
    lc_f_sp    TYPE viewfield  VALUE 'ZSHIP_TO',                "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
    lc_f_kvgr1 TYPE viewfield  VALUE 'KVGR1',                   "Customer Group
    lc_f_pst_f TYPE viewfield  VALUE 'PSTLZ_F',                 "Postal Code (From)
    lc_f_pst_t TYPE viewfield  VALUE 'PSTLZ_T',                 "Postal Code (To)
    lc_f_regio TYPE viewfield  VALUE 'REGIO',                   "Region
    lc_f_land1 TYPE viewfield  VALUE 'LAND1',                   "Country

    lc_s_hyphn TYPE char1      VALUE '-'.                       "Separator: Hyphen

  CALL FUNCTION 'ZQTC_REPDET_VALUES_GET'
    IMPORTING
      ex_rb_prod = lv_rb_prod                                   "Material / Product
      ex_rb_prft = lv_rb_prft                                   "Profit Center
      ex_rb_dprd = lv_rb_dprd                                   "Default (Product)
      ex_rb_bpid = lv_rb_bpid                                   "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
      ex_p_bsark = lv_bsark                                     "PO Type
      ex_rb_sp   = lv_rb_sp                                     "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
      ex_rb_cgrp = lv_rb_cgrp                                   "Customer Group
      ex_rb_dind = lv_rb_dind                                   "Default (Industry)
      ex_rb_pcds = lv_rb_pcds                                   "Postal Code (Individual)
      ex_rb_pcdr = lv_rb_pcdr                                   "Postal Code (Range)
      ex_rb_regn = lv_rb_regn                                   "Region
      ex_rb_land = lv_rb_land                                   "Country
      ex_rb_dgeo = lv_rb_dgeo                                   "Default (Geography)
      ex_cb_allf = lv_cb_allf                                   "Display All Fields
      ex_p_datum = lv_p_datum.                                  "As-on Date

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  zvqtc_repdet-bsark = lv_bsark.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

  LOOP AT <vim_tctrl>-cols ASSIGNING FIELD-SYMBOL(<lst_cols>).
    CLEAR: lv_table,
           lv_field,
           lv_active.

    SPLIT <lst_cols>-screen-name AT lc_s_hyphn
     INTO lv_table
          lv_field.
    CASE lv_field.
      WHEN lc_f_datbi.
        <lst_cols>-vislength = 10.                              "Visible Length

      WHEN lc_f_datab.
        <lst_cols>-vislength = 10.                              "Visible Length

      WHEN lc_f_matnr.
        <lst_cols>-vislength = 18.                              "Visible Length
        IF lv_rb_prod IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_prctr.
        <lst_cols>-vislength = 10.                              "Visible Length
        IF lv_rb_prft IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_kunnr.
        <lst_cols>-vislength = 10.                              "Visible Length
        IF lv_rb_bpid IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
      WHEN lc_f_sp.
        <lst_cols>-vislength = 10.                              "Visible Length
        IF lv_rb_sp IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

      WHEN lc_f_kvgr1.
        <lst_cols>-vislength = 3.                               "Visible Length
        IF lv_rb_cgrp IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_pst_f.
        <lst_cols>-vislength = 10.                              "Visible Length
        IF lv_rb_pcds IS NOT INITIAL OR
           lv_rb_pcdr IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_pst_t.
        <lst_cols>-vislength = 10.                              "Visible Length
        IF lv_rb_pcdr IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_regio.
        <lst_cols>-vislength = 3.                               "Visible Length
        IF lv_rb_regn IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN lc_f_land1.
        <lst_cols>-vislength = 3.                               "Visible Length
        IF lv_rb_pcds IS NOT INITIAL OR
           lv_rb_pcdr IS NOT INITIAL OR
           lv_rb_regn IS NOT INITIAL OR
           lv_rb_land IS NOT INITIAL OR
           lv_cb_allf IS NOT INITIAL.
          lv_active = abap_true.                                "Flag: Field is active
        ENDIF.
*       Maintain Field Attribute
        PERFORM f_maintain_attribute USING    lv_field lv_active
                                     CHANGING <lst_cols>-screen-active.

      WHEN OTHERS.
*       Do Nothing
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAINTAIN_ATTRIBUTE
*&---------------------------------------------------------------------*
*       Maintain Field Attribute
*----------------------------------------------------------------------*
*      -->FP_FIELD       Field Name
*      -->FP_FLD_ACTIVE  Flag: Field is Active
*      <--FP_FLD_ACTIVE  Screen Attribute: ACTIVE
*----------------------------------------------------------------------*
FORM f_maintain_attribute  USING    fp_field      TYPE fieldname
                                    fp_fld_active TYPE flag
                           CHANGING fp_scr_active TYPE char1.

  DATA:
    lv_rd_only TYPE vfldroflag.                                 "Maintenance attribute for view field

  CONSTANTS:
    lc_activ_0 TYPE char1      VALUE '0',                       "Inactive
    lc_activ_1 TYPE char1      VALUE '1'.                       "Active

  IF fp_fld_active IS NOT INITIAL.
    fp_scr_active = lc_activ_1.
    lv_rd_only = space.
  ELSE.
    fp_scr_active = lc_activ_0.
    lv_rd_only = vim_hidden.
  ENDIF.

  READ TABLE x_namtab ASSIGNING FIELD-SYMBOL(<lst_nmtb>)
       WITH KEY viewfield = fp_field.
  IF sy-subrc EQ 0.
    <lst_nmtb>-readonly = lv_rd_only.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FIELDS_SAVE
*&---------------------------------------------------------------------*
FORM f_populate_fields_save.

  FIELD-SYMBOLS:
    <lv_field> TYPE any.                                        "Field Value

  CONSTANTS:
    lc_f_srep1 TYPE viewfield  VALUE 'SREP1',                   "Sales Rep-1
*   Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
    lc_f_srep2 TYPE viewfield  VALUE 'SREP2',                   "Sales Rep-2
*   End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
    lc_f_aenam TYPE viewfield  VALUE 'AENAM',                   "Name of Person Who Changed Object
    lc_f_aedat TYPE viewfield  VALUE 'AEDAT',                   "Changed On
    lc_f_aezet TYPE viewfield  VALUE 'AEZET'.                   "Time last change was made

  LOOP AT total.
    IF <action> = neuer_eintrag OR                              "Create New Entry (N)
       <action> = aendern.                                      "Change Entry (U)
*     Check Sales Rep-1
      ASSIGN COMPONENT lc_f_srep1 OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        IF <lv_field> IS INITIAL.                               "Sales Rep-1
          vim_abort_saving = abap_true.
          MESSAGE s022(zqtc_r2) DISPLAY LIKE 'E'.
*     Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        ELSE.
*         Validate Sales Rep
          PERFORM f_sales_rep_validation USING <lv_field>.
        ENDIF.
      ENDIF.
*     Check Sales Rep-2
      ASSIGN COMPONENT lc_f_srep2 OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        IF <lv_field> IS NOT INITIAL.                           "Sales Rep-2
*         Validate Sales Rep
          PERFORM f_sales_rep_validation USING <lv_field>.
*     End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        ENDIF.
      ENDIF.
*     Name of Person Who Changed Object
      ASSIGN COMPONENT lc_f_aenam OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uname.                                  "Name of Current User
      ENDIF.
*     Changed On
      ASSIGN COMPONENT lc_f_aedat OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-datum.                                  "Current Date of Application Server
      ENDIF.
*     Time last change was made
      ASSIGN COMPONENT lc_f_aezet OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uzeit.                                  "Current Time of Application Server
      ENDIF.
      MODIFY total.

      READ TABLE extract WITH KEY <vim_xtotal_key>.
      IF sy-subrc EQ 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDLOOP.

  sy-subrc = 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FIELDS
*&---------------------------------------------------------------------*
FORM f_validate_fields.

  DATA:
    li_tot_tab TYPE STANDARD TABLE OF zvqtc_repdet INITIAL SIZE 0,
*** BOC: CR#7764 KKRAVURI20190128  ED2K914367
    li_update  TYPE STANDARD TABLE OF zqtc_repdet INITIAL SIZE 0,
    lst_update TYPE zqtc_repdet.
*** EOC: CR#7764 KKRAVURI20190128  ED2K914367

  DATA:
    lv_cb_allf TYPE char1,                                      "Display All Fields
    lv_rb_prod TYPE char1,                                      "Material / Product
    lv_rb_prft TYPE char1,                                      "Profit Center
    lv_rb_bpid TYPE char1,                                      "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
    lv_bsark   TYPE bsark,                                      "PO Type
    lv_rb_sp   TYPE char1,                                      "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
    lv_rb_cgrp TYPE char1,                                      "Customer Group
    lv_rb_pcds TYPE char1,                                      "Postal Code (Individual)
    lv_rb_pcdr TYPE char1,                                      "Postal Code (Range)
    lv_rb_regn TYPE char1,                                      "Region
    lv_rb_land TYPE char1,                                      "Country
    lv_p_datum TYPE sydatum,                                    "As-on Date
    lv_table   TYPE tabname,                                    "Table Name
    lv_field   TYPE fieldname,                                  "Field Name
    lv_active  TYPE flag.                                       "Flag: Field is active

  CONSTANTS:
    lc_vt_date           TYPE sydatum  VALUE '99991231',                        "Valid To Date
    lc_sp_validation_txt TYPE string VALUE 'Enter a ship-to party',   "Ship-to Validation Text
    lc_vfdat_val_txt     TYPE string VALUE 'Valid-From date should be >= current date'.

  CALL FUNCTION 'ZQTC_REPDET_VALUES_GET'
    IMPORTING
      ex_rb_prod = lv_rb_prod                                   "Material / Product
      ex_rb_prft = lv_rb_prft                                   "Profit Center
      ex_rb_bpid = lv_rb_bpid                                   "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
      ex_p_bsark = lv_bsark                                     "PO Type
      ex_rb_sp   = lv_rb_sp                                     "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
      ex_rb_cgrp = lv_rb_cgrp                                   "Customer Group
      ex_rb_pcds = lv_rb_pcds                                   "Postal Code (Individual)
      ex_rb_pcdr = lv_rb_pcdr                                   "Postal Code (Range)
      ex_rb_regn = lv_rb_regn                                   "Region
      ex_rb_land = lv_rb_land                                   "Country
      ex_cb_allf = lv_cb_allf                                   "Display All Fields
      ex_p_datum = lv_p_datum.                                  "As-on Date

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  zvqtc_repdet-bsark = lv_bsark.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

  IF zvqtc_repdet-datab   IS INITIAL.
    zvqtc_repdet-datab = lv_p_datum.                            "Valid From Date
  ENDIF.

  IF zvqtc_repdet-datbi   IS INITIAL.
    zvqtc_repdet-datbi = lc_vt_date.                            "Valid To Date
  ENDIF.

*** BOC: CR#7764 KKRAVURI20190130  ED2K914387
  IF zvqtc_repdet-datab IS NOT INITIAL.
    IF zvqtc_repdet-datab < sy-datum.
      " Message: Valid-From date should be >= current date
      MESSAGE lc_vfdat_val_txt TYPE 'E'.
    ENDIF.
  ENDIF.
*** EOC: CR#7764 KKRAVURI20190130  ED2K914387

  IF zvqtc_repdet-datab   GT zvqtc_repdet-datbi.
*   Message: Valid To Date must greater than or equal to Valid From Date
    MESSAGE e500(grpcrta_ecm).
  ENDIF.

  IF zvqtc_repdet-matnr   IS INITIAL AND
     lv_rb_prod           IS NOT INITIAL.
*   Message: Enter a material number
    MESSAGE e262(m3).
  ENDIF.

  IF zvqtc_repdet-prctr   IS INITIAL AND
     lv_rb_prft           IS NOT INITIAL.
*   Message: Enter a profit center
    MESSAGE e544(km).
  ENDIF.

  IF zvqtc_repdet-kunnr   IS INITIAL AND
     lv_rb_bpid           IS NOT INITIAL.
*   Message: Enter a sold-to party
    MESSAGE e287(e9).
  ENDIF.

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  IF zvqtc_repdet-zship_to IS INITIAL AND
     lv_rb_sp IS NOT INITIAL.
*   Message: Enter a ship-to party
    MESSAGE lc_sp_validation_txt TYPE 'E'.
  ENDIF.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

  IF zvqtc_repdet-kvgr1   IS INITIAL AND
     lv_rb_cgrp           IS NOT INITIAL.
*   Message: Enter a customer group
    MESSAGE e130(cpe_erp).
  ENDIF.

  IF zvqtc_repdet-pstlz_f IS INITIAL AND
   ( lv_rb_pcds           IS NOT INITIAL OR
     lv_rb_pcdr           IS NOT INITIAL ).
*   Message: Enter a postal code
    MESSAGE e135(n1).
  ENDIF.

  IF zvqtc_repdet-pstlz_t IS INITIAL AND
     lv_rb_pcdr           IS NOT INITIAL.
*   Message: Enter a postal code
    MESSAGE e135(n1).
  ENDIF.

  IF zvqtc_repdet-regio   IS INITIAL AND
     lv_rb_regn           IS NOT INITIAL.
*   Message: Enter a region
    MESSAGE e212(8a).
  ENDIF.

  IF zvqtc_repdet-land1   IS INITIAL AND
   ( lv_rb_pcds           IS NOT INITIAL OR
     lv_rb_pcdr           IS NOT INITIAL OR
     lv_rb_regn           IS NOT INITIAL OR
     lv_rb_land           IS NOT INITIAL ).
*   Message: Enter a country
    MESSAGE e098(n1).
  ENDIF.

* Validate Customer Data
  PERFORM f_validate_customer  USING zvqtc_repdet-kunnr
                                     zvqtc_repdet-land1.

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
* Validate Customer Data (Ship-to party)
  PERFORM f_validate_ship_to  USING zvqtc_repdet-zship_to
                                    zvqtc_repdet-vkorg
                                    zvqtc_repdet-vtweg
                                    zvqtc_repdet-spart.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

* Validate Customer group 1
  PERFORM f_validate_cust_grp1 USING zvqtc_repdet-kvgr1.

* Validate Postal Code (From)
  PERFORM f_address_validation USING zvqtc_repdet-land1
                                     zvqtc_repdet-pstlz_f.
* Validate Postal Code (To)
  PERFORM f_address_validation USING zvqtc_repdet-land1
                                     zvqtc_repdet-pstlz_t.

* Begin of DEL:ERP-4832:WROY:26-Oct-2017:ED2K909197
* IF zvqtc_repdet-srep1 IS INITIAL.
**  Message: Sales Rep-1 is a mandatory field!
*   MESSAGE i022(zqtc_r2) DISPLAY LIKE 'E'.
* ENDIF.
* End   of DEL:ERP-4832:WROY:26-Oct-2017:ED2K909197
* Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
  IF zvqtc_repdet-srep1 IS NOT INITIAL.
*   Validate Sales Rep
    PERFORM f_sales_rep_validation USING zvqtc_repdet-srep1.
  ENDIF.

  IF zvqtc_repdet-srep2 IS NOT INITIAL.
*   Validate Sales Rep
    PERFORM f_sales_rep_validation USING zvqtc_repdet-srep2.
  ENDIF.
* End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690

* Consider all existing entries to check overlapping dates
  li_tot_tab[] = total[].
* Ignore the current entry
  READ TABLE li_tot_tab TRANSPORTING NO FIELDS
       WITH KEY <f1_x> BINARY SEARCH.                       "#EC WARNOK
  IF sy-subrc EQ 0.
    DELETE li_tot_tab INDEX sy-tabix.
  ENDIF.

*** BOC: CR#7764 KKRAVURI20190128  ED2K914367
  LOOP AT li_tot_tab INTO DATA(lst_zqtcrepdet).

    IF lst_zqtcrepdet-vkorg   = zvqtc_repdet-vkorg AND
       lst_zqtcrepdet-vtweg   = zvqtc_repdet-vtweg AND
       lst_zqtcrepdet-spart   = zvqtc_repdet-spart AND
       lst_zqtcrepdet-bsark   = zvqtc_repdet-bsark AND
       lst_zqtcrepdet-matnr   = zvqtc_repdet-matnr AND
       lst_zqtcrepdet-prctr   = zvqtc_repdet-prctr AND
       lst_zqtcrepdet-kunnr   = zvqtc_repdet-kunnr AND
       lst_zqtcrepdet-kvgr1   = zvqtc_repdet-kvgr1 AND
       lst_zqtcrepdet-pstlz_f = zvqtc_repdet-pstlz_f AND
       lst_zqtcrepdet-pstlz_t = zvqtc_repdet-pstlz_t AND
       lst_zqtcrepdet-regio   = zvqtc_repdet-regio AND
       lst_zqtcrepdet-land1   = zvqtc_repdet-land1 AND
       lst_zqtcrepdet-zship_to = zvqtc_repdet-zship_to.


      IF zvqtc_repdet-datab <= lst_zqtcrepdet-datbi AND  " New record Valid_From date is LE Old record Valid_To date AND
         zvqtc_repdet-datbi > lst_zqtcrepdet-datbi.      " New record Valid_To date is GT Old record Valid_To date
        MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.   " New record --> Excel File record
        " In this case update the Old record Valid_To date with New record Valid_From date - 1
        lst_update-datbi = zvqtc_repdet-datab - 1.
        lst_update-aenam = sy-uname.
* To get latest time
        GET TIME.
        lst_update-aedat = sy-datum.
        lst_update-aezet = sy-uzeit.
        APPEND lst_update TO li_update.
        CLEAR lst_update.
      ELSEIF zvqtc_repdet-datab > lst_zqtcrepdet-datbi AND  " New record Valid_From date is GT Old record Valid_To date AND
             zvqtc_repdet-datbi > lst_zqtcrepdet-datbi.     " New record Valid_To date is GT Old record Valid_To date
        " In this case no need to update the existing record
        " Just save the new record into DB table
      ELSEIF ( zvqtc_repdet-datab > lst_zqtcrepdet-datab AND zvqtc_repdet-datab < lst_zqtcrepdet-datbi ) AND
             ( zvqtc_repdet-datbi < lst_zqtcrepdet-datbi ).
        " New record Valid_From date is GT Old record Valid_From date AND New record Valid_From date is LT Old record Valid_To date AND
        " New record Valid_To date is LT Old record Valid_To date
        " In this case update the Old record Valid_To date with New record Valid_From date - 1
        MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.
        lst_update-datbi = zvqtc_repdet-datab - 1.
        lst_update-aenam = sy-uname.
* To get latest time
        GET TIME.
        lst_update-aedat = sy-datum.
        lst_update-aezet = sy-uzeit.
        APPEND lst_update TO li_update.
        CLEAR lst_update.
*      ELSEIF ( zvqtc_repdet-datab < lst_zqtcrepdet-datab AND zvqtc_repdet-datab < lst_zqtcrepdet-datbi ) AND
*             ( zvqtc_repdet-datbi > lst_zqtcrepdet-datab AND zvqtc_repdet-datbi < lst_zqtcrepdet-datbi ).
*        " In this case, update the Old record Valid_From date with New record Valid_To date + 1
*        " Since Valid_From date is part of table Key, a new record is created in this case. Hence delete the old
*        " record for which a new record is created in this case. In this coding part logic for deleting the old record
*        " is not implemented. Hence implement it if this ELSEIF condition is necessary updation Validity dates validation
*        " This new ELSEIF condition is identified while testing the Validity dates updation
*        MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.
*        lst_update-datab = zvqtc_repdet-datbi + 1.
*        lst_update-aenam = sy-uname.
** To get latest time
*        GET TIME.
*        lst_update-aedat = sy-datum.
*        lst_update-aezet = sy-uzeit.
*        APPEND lst_update TO li_update.
*        CLEAR lst_update.
      ENDIF.

    ENDIF.

    CLEAR lst_zqtcrepdet.
  ENDLOOP.
  IF li_update[] IS NOT INITIAL.
    SORT li_update BY vkorg
                      vtweg
                      spart
                      bsark
                      matnr
                      prctr
                      kunnr
                      kvgr1
                      pstlz_f
                      pstlz_t
                      regio
                      land1
                      datab
                      zship_to
                      datbi.
    DELETE ADJACENT DUPLICATES FROM li_update COMPARING
                    vkorg vtweg spart bsark matnr prctr
                    kunnr kvgr1 pstlz_f pstlz_t regio land1
                    datab zship_to datbi.
    MODIFY zqtc_repdet FROM TABLE li_update.
    REFRESH li_update.
  ENDIF.
*** EOC: CR#7764 KKRAVURI20190128  ED2K914367

*** BOC: CR#7764 KKRAVURI20190128
*** Below logic for 'Date overlapping' validation is commented as part of CR#7764

** Identify entries for a Key combination (except dates)
*  DELETE li_tot_tab WHERE matnr   NE zvqtc_repdet-matnr
*                       OR prctr   NE zvqtc_repdet-prctr
*                       OR kunnr   NE zvqtc_repdet-kunnr
*                       OR zship_to NE zvqtc_repdet-zship_to  " ADD:CR#7764 KKRAVURI20181025  ED2K913679
*                       OR kvgr1   NE zvqtc_repdet-kvgr1
*                       OR pstlz_f NE zvqtc_repdet-pstlz_f
*                       OR pstlz_t NE zvqtc_repdet-pstlz_t
*                       OR regio   NE zvqtc_repdet-regio
*                       OR land1   NE zvqtc_repdet-land1.
** Validate overlapping dates
*  LOOP AT li_tot_tab ASSIGNING FIELD-SYMBOL(<lst_total>).
*    IF zvqtc_repdet-datab GE <lst_total>-datab  AND
*       zvqtc_repdet-datab LE <lst_total>-datbi.
**     Message: Date specified overlaps with existing dates
*      MESSAGE e357(n9).
*    ENDIF.
*    IF zvqtc_repdet-datbi GE <lst_total>-datab  AND
*       zvqtc_repdet-datbi LE <lst_total>-datbi.
**     Message: Date specified overlaps with existing dates
*      MESSAGE e357(n9).
*    ENDIF.
*    IF <lst_total>-datab  GE zvqtc_repdet-datab AND
*       <lst_total>-datab  LE zvqtc_repdet-datbi.
**     Message: Date specified overlaps with existing dates
*      MESSAGE e357(n9).
*    ENDIF.
*    IF <lst_total>-datbi  GE zvqtc_repdet-datab AND
*       <lst_total>-datbi  LE zvqtc_repdet-datbi.
**     Message: Date specified overlaps with existing dates
*      MESSAGE e357(n9).
*    ENDIF.
*  ENDLOOP.

*** Above logic for 'Date overlapping' validation is commented as part of CR#7764
*** EOC: CR#7764 KKRAVURI20190128

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADDRESS_VALIDATION
*&---------------------------------------------------------------------*
*       Validate Postal Code
*----------------------------------------------------------------------*
*      -->FP_LAND1  Country
*      -->FP_PSTLZ  Postal Code
*----------------------------------------------------------------------*
FORM f_address_validation  USING    fp_land1 TYPE land1
                                    fp_pstlz TYPE pstlz.

  IF fp_land1 IS INITIAL OR
     fp_pstlz IS INITIAL.
    RETURN.
  ENDIF.

* Validate Postal Code
  CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
    EXPORTING
      country                        = fp_land1                 "Country
      postal_code_city               = fp_pstlz                 "Postal Code
    EXCEPTIONS
      country_not_valid              = 1
      region_not_valid               = 2
      postal_code_city_not_valid     = 3
      postal_code_po_box_not_valid   = 4
      postal_code_company_not_valid  = 5
      po_box_missing                 = 6
      postal_code_po_box_missing     = 7
      postal_code_missing            = 8
      postal_code_pobox_comp_missing = 9
      po_box_region_not_valid        = 10
      po_box_country_not_valid       = 11
      pobox_and_poboxnum_filled      = 12
      OTHERS                         = 13.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUSTOMER
*&---------------------------------------------------------------------*
*       Validate Customer Data
*----------------------------------------------------------------------*
*      -->FP_KUNNR  Customer Number
*      -->FP_LAND1  Country
*----------------------------------------------------------------------*
FORM f_validate_customer  USING    fp_kunnr TYPE kunnr
                                   fp_land1 TYPE land1.

  CONSTANTS:
    lc_sold_to TYPE ktokd VALUE '0001'.               "Customer Account Group: Sold-to Party

  IF fp_kunnr IS INITIAL.
    RETURN.
  ENDIF.

* Fetch General Data in Customer Master
  SELECT SINGLE kunnr,                                "Customer Number
                ktokd,                                "Customer Account Group
                land1                                 "Country Key
    FROM kna1
    INTO @DATA(lst_kna1)
   WHERE kunnr EQ @fp_kunnr.
  IF sy-subrc EQ 0.
    IF lst_kna1-ktokd NE lc_sold_to.
*     Message: Customer &1 is not a sold-to party
      MESSAGE e323(9j) WITH lst_kna1-kunnr.
    ENDIF.

    IF fp_land1 IS NOT INITIAL AND
       lst_kna1-land1 NE fp_land1.
*     Message: The system did not find the country in the address of customer &1.
      MESSAGE e025(eip) WITH lst_kna1-kunnr.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SHIP_TO
*&---------------------------------------------------------------------*
*       Validate Ship_to party
*----------------------------------------------------------------------*
*      -->FP_SHIP_TO  Customer Number
*      -->FP_LAND1  Country
*----------------------------------------------------------------------*
FORM f_validate_ship_to  USING  fp_ship_to TYPE kunnr
                                fp_vkorg   TYPE vkorg
                                fp_vtweg   TYPE vtweg
                                fp_spart   TYPE spart.

  DATA(liv_validation_txt) = 'Ship-to party is not valid'.

  IF fp_ship_to IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE kunnr,    "Customer Number
                vkorg,    "Sales Organization
                vtweg,    "Distribution Channel
                spart     "Division
         FROM knvv
         INTO @DATA(lst_kna1)
         WHERE kunnr EQ @fp_ship_to AND
               vkorg EQ @fp_vkorg AND
               vtweg EQ @fp_vtweg AND
               spart EQ @fp_spart.
  IF sy-subrc <> 0.
*   Message: Ship-to party is not valid
    MESSAGE liv_validation_txt TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUST_GRP1
*&---------------------------------------------------------------------*
*       Validate Customer group 1
*----------------------------------------------------------------------*
*      -->FP_KVGR1  Customer group 1
*----------------------------------------------------------------------*
FORM f_validate_cust_grp1  USING    fp_kvgr1 TYPE kvgr1.

  DATA:
    lir_kvgr1 TYPE tt_kvgr1_rng.                                "Range: Customer group 1

  DATA:
    lv_kvgr1  TYPE kvgr1.                                       "Customer group 1

* Pattern: Customer group 1
  CONCATENATE fp_kvgr1
              c_pattern
         INTO lv_kvgr1.
  CONDENSE lv_kvgr1.

* Populate a Range Table
  APPEND INITIAL LINE TO lir_kvgr1 ASSIGNING FIELD-SYMBOL(<lst_kvgr1>).
  <lst_kvgr1>-sign   = c_sign_incld.                            "Sign: (I)nclude
  IF lv_kvgr1 CA c_pattern.
    <lst_kvgr1>-opti = c_option_cp.                             "Option: (C)ontains (P)attern
  ELSE.
    <lst_kvgr1>-opti = c_option_eq.                             "Option: (EQ)uals
  ENDIF.
  <lst_kvgr1>-low    = lv_kvgr1.                                "Lower Value of Cust Grp 1
  <lst_kvgr1>-high   = space.                                   "Upper Value of Cust Grp 1

* Fetch Customer Group 1
  SELECT kvgr1                                                  "Customer group 1
    FROM tvv1
   UP TO 1 ROWS
    INTO lv_kvgr1
   WHERE kvgr1 IN lir_kvgr1.                                    "Range: Customer group 1
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Customer group &1 is not defined
    MESSAGE e418(v1) WITH fp_kvgr1.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_NEW_ENTRY
*&---------------------------------------------------------------------*
FORM f_validate_new_entry.

  CONSTANTS:
    lc_vt_date TYPE sydatum  VALUE '99991231'.                  "Valid To Date

  IF zvqtc_repdet-datab GT zvqtc_repdet-datbi.
    zvqtc_repdet-datbi = lc_vt_date.                            "Valid To Date
  ENDIF.
  PERFORM f_validate_fields.

ENDFORM.
* Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
*&---------------------------------------------------------------------*
*&      Form  F_SALES_REP_VALIDATION
*&---------------------------------------------------------------------*
*       Sales Rep Validation
*----------------------------------------------------------------------*
*      -->FP_SALES_REP  Sales Rep
*----------------------------------------------------------------------*
FORM f_sales_rep_validation  USING fp_sales_rep TYPE p_pernr.

* Check Personnel Number against HR Master Record
  CALL FUNCTION 'RP_CHECK_PERNR'
    EXPORTING
      beg               = sy-datum
      pnr               = fp_sales_rep
    EXCEPTIONS
      data_fault        = 1
      person_not_active = 2
      person_unknown    = 3
      exit_fault        = 4
      pernr_missing     = 5
      date_missing      = 6
      OTHERS            = 7.
  CASE sy-subrc.
    WHEN 0.
*     Nothing to do
    WHEN OTHERS.
      IF fcode = 'SAVE'.
        vim_abort_saving = abap_true.
      ENDIF.
      CASE sy-subrc.
        WHEN 2.
          MESSAGE s002(vpd) WITH 'Employee'(z01) fp_sales_rep
          DISPLAY LIKE 'E'.
        WHEN OTHERS.
          MESSAGE ID sy-msgid
                TYPE 'S'
              NUMBER sy-msgno
                WITH sy-msgv1
                     sy-msgv2
                     sy-msgv3
                     sy-msgv4
             DISPLAY LIKE 'E'.
      ENDCASE.
  ENDCASE.

ENDFORM.
* End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
*&---------------------------------------------------------------------*
*&      Module  ZCLEAR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zclear OUTPUT.

  DATA lv_bsark TYPE string VALUE '(ZQTCR_MAINTAIN_REPDET_TABL)P_BSARK'.

  ASSIGN (lv_bsark) TO FIELD-SYMBOL(<lf_bsark>).
  IF <lf_bsark> IS ASSIGNED AND <lf_bsark> IS INITIAL.
    CLEAR zvqtc_repdet-bsark.
  ELSEIF <lf_bsark> IS ASSIGNED AND <lf_bsark> IS NOT INITIAL.
    zvqtc_repdet-bsark = <lf_bsark>.
  ENDIF.

ENDMODULE.
