*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SO_PAI_MODULES_E060
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_FIELDS_VBAK(Include)
* PROGRAM DESCRIPTION: Validation of VBAK Fields
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908045, ED2K908043
* REFERENCE NO: E074
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 10-Nov-2016
* DESCRIPTION: Add logic to implement the check if promo code is of one
*              time use. If yes then user can avail discount, otherwise
*              stop the transaction by throwing error message.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908045/ED2K908043/ED2K908273
* REFERENCE NO: E074 - CR#582
* DEVELOPER: Writtick Roy (WROY)
* DATE: 18-AUG-2017
* DESCRIPTION: Check for specific Promo Types for Member Prices and
*              Non-member Prices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908174
* REFERENCE NO: E152 - CR#642
* DEVELOPER: Writtick Roy (WROY)
* DATE: 23-AUG-2017
* DESCRIPTION: Validate Access Mechanism
*----------------------------------------------------------------------*
MODULE zzqtc_validate_fields_vbak INPUT.

  DATA:
    lv_knuma TYPE knuma, " Agreement (various conditions grouped together)
    lv_vkorg TYPE vkorg, " Sales Organization
    lv_vtweg TYPE vtweg, " Distribution Channel
    lv_spart TYPE spart. " Division

* Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
* Type Declaration of Constant table
  TYPES : BEGIN OF lty_constant,
            devid  TYPE zdevid,              " Development ID
            param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_constant,

*         Range Table declaration:
          BEGIN OF lty_promo_type,
            sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
            option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE boart,      " Agreement type
            high   TYPE boart,      " Agreement type
          END OF lty_promo_type.

* Data declaration
  DATA : li_constant    TYPE STANDARD TABLE OF lty_constant   INITIAL SIZE 0,  "
         lr_promo_type  TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
*        Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
         lr_promo_mbr   TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
         lr_promo_nmbr  TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
*        End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
         lv_boart       TYPE boart,        " Agreement type
         lst_promo_type TYPE lty_promo_type,
         lst_constant   TYPE lty_constant. " Constant structure declaration

* Constant Declaration
  CONSTANTS : lc_devid    TYPE zdevid        VALUE 'E074', " Type of Identification Code
*             Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
              lc_member   TYPE rvari_vnam    VALUE 'MEMBER',      " Promotion code for variant variable
              lc_n_member TYPE rvari_vnam    VALUE 'NON_MEMBER',  " Promotion code for variant variable
*             End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
              lc_promocde TYPE rvari_vnam    VALUE 'ZZPROMO'. " Promotion code for variant variable

* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  CLEAR: lr_promo_mbr,
         lr_promo_nmbr.
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  IF li_constant IS INITIAL.
* Fetch Identification Code Type from constant table.
    SELECT devid       " Development ID
           param1      " ABAP: Name of Variant Variable
           param2      " ABAP: Name of Variant Variable
           sign        " ABAP: ID: I/E (include/exclude values)
           opti        " ABAP: Selection option (EQ/BT/CP/...)
           low         " Lower Value of Selection Condition
           high        " Upper Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO TABLE li_constant
      WHERE devid    = lc_devid
        AND param1   = lc_promocde
        AND activate = abap_true.

    IF sy-subrc EQ 0.
*   Put the promo code values in the range table.
      LOOP AT li_constant INTO lst_constant.
        lst_promo_type-sign   = lst_constant-sign. " Sign (I)
        lst_promo_type-option = lst_constant-opti. " Option (EQ)
        lst_promo_type-low = lst_constant-low. " Z001/Z002/Z005
        lst_promo_type-high = lst_constant-high.
        APPEND lst_promo_type TO lr_promo_type.
*       Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
        CASE lst_constant-param2.
          WHEN lc_member.                          "'MEMBER'
            APPEND lst_promo_type TO lr_promo_mbr.
          WHEN lc_n_member.                        "'NON_MEMBER'
            APPEND lst_promo_type TO lr_promo_nmbr.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
*       End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
      ENDLOOP. " LOOP AT li_constant INTO lst_constant
      CLEAR lst_promo_type.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_constant IS INITIAL
* End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379

  CLEAR: lv_knuma,
         lv_vkorg,
         lv_vtweg,
*        Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
         lv_boart,
*        End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
         lv_spart.
  IF vbak-zzpromo IS NOT INITIAL.
*   Validate from Agreements Table
    SELECT SINGLE knuma " Agreement (various conditions grouped together)
                  vkorg " Sales Organization
                  vtweg " Distribution Channel
                  spart " Division
*                 Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
                  boart " Agreement Type
*                 End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
      FROM kona " Agreements
      INTO ( lv_knuma, lv_vkorg, lv_vtweg, lv_spart, lv_boart )
     WHERE knuma = vbak-zzpromo
       AND abtyp = charb.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      IF ( lv_vkorg IS NOT INITIAL AND lv_vkorg NE vbak-vkorg ) OR
         ( lv_vtweg IS NOT INITIAL AND lv_vtweg NE vbak-vtweg ) OR
         ( lv_spart IS NOT INITIAL AND lv_spart NE vbak-spart ).
        MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
      ENDIF. " IF ( lv_vkorg IS NOT INITIAL AND lv_vkorg NE vbak-vkorg ) OR

*     Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
*     If promo type is valid, then process further.
      IF lv_boart NOT IN lr_promo_type. " Check for Promo Code / Agreement type
        MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
      ENDIF. " IF lv_boart IN lr_promo_type
*     End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF. " IF vbak-zzpromo IS NOT INITIAL
ENDMODULE.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_FIELD_ZZPROMO (Include)
* PROGRAM DESCRIPTION: Validation of VBAP Field ZZPROMO
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903037
* REFERENCE NO: E074
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 10-Nov-2016
* DESCRIPTION: Add logic to implement the check if promo code is of one
*              time use. If yes then user can avail discount, otherwise
*              stop the transaction by throwing error message.
*----------------------------------------------------------------------*

MODULE zzqtc_validate_field_zzpromo INPUT.

* Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
* Type Declaration of Constant table
  TYPES : BEGIN OF lty_const,
            devid  TYPE zdevid,              " Development ID
            param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_const,

* Range Table declaration:
          BEGIN OF lty_promo_typ,
            sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
            option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE boart,      " Agreement type
            high   TYPE boart,      " Agreement type
          END OF lty_promo_typ.

  DATA : li_const      TYPE STANDARD TABLE OF lty_const      INITIAL SIZE 0,  "
         lr_promo_typ  TYPE STANDARD TABLE OF lty_promo_typ  INITIAL SIZE 0,
*        Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
         lr_promo_mb   TYPE STANDARD TABLE OF lty_promo_typ  INITIAL SIZE 0,
         lr_promo_nmb  TYPE STANDARD TABLE OF lty_promo_typ  INITIAL SIZE 0,
         lr_price_cond TYPE farr_tt_range_cond,
         li_xkomv_e074 TYPE tab_komv,
*        End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
         lst_promo_typ TYPE lty_promo_typ,
         lst_const     TYPE lty_const. " Constant structure declaration

  CONSTANTS : lc_dev_id    TYPE zdevid        VALUE 'E074',    " Type of Identification Code
              lc_comp_rej  TYPE abstk         VALUE 'C',       " Overall rejection status (C = Completed Successfully)
*             Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
              lc_actv_cond TYPE rvari_vnam    VALUE 'ACTIVE_COND', " Promotion code for variant variable
*             End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
              lc_promocode TYPE rvari_vnam    VALUE 'ZZPROMO'. " Promotion code for variant variable

* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  CLEAR: lr_promo_mbr,
         lr_promo_nmbr.
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  IF li_const IS INITIAL.
* Fetch Identification Code Type from constant table.
    SELECT devid       " Development ID
           param1      " ABAP: Name of Variant Variable
           param2      " ABAP: Name of Variant Variable
           sign        " ABAP: ID: I/E (include/exclude values)
           opti        " ABAP: Selection option (EQ/BT/CP/...)
           low         " Lower Value of Selection Condition
           high        " Upper Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO TABLE li_const
      WHERE devid    = lc_dev_id
*       Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*       AND param1   = lc_promocode
*       End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
        AND activate = abap_true.

    IF sy-subrc EQ 0.
      LOOP AT li_const INTO lst_const.
*       Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
        CASE lst_const-param1.
          WHEN  lc_promocode.
*       End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
            lst_promo_typ-sign   = lst_const-sign. " Sign (I)
            lst_promo_typ-option = lst_const-opti. " Option (EQ)
            lst_promo_typ-low = lst_const-low. " One time promo code(Z001/Z002/Z005/Z006)
            lst_promo_typ-high = lst_const-high.
            APPEND lst_promo_typ TO lr_promo_typ.
*       Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
            CASE lst_const-param2.
              WHEN lc_member.                          "'MEMBER'
                APPEND lst_promo_typ TO lr_promo_mb.
              WHEN lc_n_member.                        "'NON_MEMBER'
                APPEND lst_promo_typ TO lr_promo_nmb.
              WHEN OTHERS.
*           Nothing to do
            ENDCASE.

          WHEN lc_actv_cond.                          "'ACTIVE_COND'
            APPEND INITIAL LINE TO lr_price_cond ASSIGNING FIELD-SYMBOL(<lst_price_cond>).
            <lst_price_cond>-sign   = lst_const-sign. " Sign
            <lst_price_cond>-option = lst_const-opti. " Option
            <lst_price_cond>-low    = lst_const-low.  " Condition Type
            <lst_price_cond>-high   = lst_const-high. " Condition Type

          WHEN OTHERS.

        ENDCASE.
*       End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
        CLEAR lst_promo_typ.
      ENDLOOP. " LOOP AT li_const INTO lst_const
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_const IS INITIAL
* End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379

  CLEAR: lv_knuma,
         lv_vkorg,
         lv_vtweg,
*        Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
         lv_boart,
*        End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
         lv_spart.
  IF vbap-zzpromo IS NOT INITIAL.
*   Validate from Agreements Table
    SELECT SINGLE knuma " Agreement (various conditions grouped together)
                  vkorg " Sales Organization
                  vtweg " Distribution Channel
                  spart " Division
                  boart " Agreement type
      FROM kona         " Agreements
      INTO ( lv_knuma, lv_vkorg, lv_vtweg, lv_spart, lv_boart )
     WHERE knuma = vbap-zzpromo
       AND abtyp = charb.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      IF ( lv_vkorg IS NOT INITIAL AND lv_vkorg NE vbak-vkorg ) OR
         ( lv_vtweg IS NOT INITIAL AND lv_vtweg NE vbak-vtweg ) OR
         ( lv_spart IS NOT INITIAL AND lv_spart NE vbak-spart ).
        MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
      ENDIF. " IF ( lv_vkorg IS NOT INITIAL AND lv_vkorg NE vbak-vkorg ) OR
    ENDIF. " IF sy-subrc IS NOT INITIAL
*   Begin of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379
*   If promo type is valid, then process further.
    IF lv_boart NOT IN lr_promo_type. " Check for Promo Code / Agreement type
      MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
*   Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    ELSE.
*     Get the Index number from Communication Item for Pricing
      READ TABLE tkomp INTO DATA(lst_tkomp_e074)
           WITH KEY kposn = vbap-posnr                       " Condition item number
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Get details from Communication Header for Pricing
        READ TABLE tkomk INTO DATA(lst_tkomk_e074)
             INDEX lst_tkomp_e074-ix_komk.                      " Index number for internal table
      ENDIF.
      IF sy-subrc NE 0.
        lst_tkomk_e074 = tkomk.
      ENDIF.
      IF lst_tkomk_e074 IS NOT INITIAL.
        li_xkomv_e074[] = xkomv[].
        DELETE li_xkomv_e074 WHERE kposn NE vbap-posnr
                                OR kschl NOT IN lr_price_cond
                                OR kinak IS NOT INITIAL.
        IF li_xkomv_e074 IS NOT INITIAL.
          IF lv_boart IN lr_promo_mb AND
             lst_tkomk_e074-zzreltyp IS INITIAL.
            MESSAGE e233(zqtc_r2). "Promotion not allowed for Non Member Price.
          ENDIF.
          IF lv_boart IN lr_promo_nmb AND
             lst_tkomk_e074-zzreltyp IS NOT INITIAL.
            MESSAGE e234(zqtc_r2). "Promotion not allowed for Member Price.
          ENDIF.
        ENDIF.
      ENDIF.
*   End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    ENDIF. " IF lv_boart IN lr_promo_type
*   End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037/ED2K903379

  ENDIF. " IF vbap-zzpromo IS NOT INITIAL
*     End of Change: PBOSE: 10-Nov-2016: E074:ED2K903037
ENDMODULE.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_FIELD_ZZVYP (Include)
* PROGRAM DESCRIPTION: Validation of VBAP Field ZZVYP
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
MODULE zzqtc_validate_field_zzvyp INPUT.
  DATA :      lv_flag  TYPE flag. " General Flag
  CONSTANTS : lc_zero TYPE char1 VALUE '0'. " Zero of type CHAR1
**************Validation for VBAP-ZZVYP field**********************
  IF vbap-zzvyp IS NOT INITIAL.
    CALL FUNCTION 'VALIDATE_YEAR'
      EXPORTING
        i_year     = vbap-zzvyp
      IMPORTING
        e_record   = vbap-zzvyp
        e_valid    = lv_flag
      EXCEPTIONS
        incomplete = 1
        OTHERS     = 2.

    IF lv_flag = lc_zero.
      MESSAGE e018(zqtc_r2). " Enter Valid Year
    ENDIF. " IF lv_flag = lc_zero
  ENDIF. " IF vbap-zzvyp IS NOT INITIAL

ENDMODULE.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE__DATE(Include)
* PROGRAM DESCRIPTION: Validation of Sales Order Header Date Fields
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
MODULE zzqtc_validate_date INPUT.

  IF vbak-zzholdfrom IS NOT INITIAL OR vbak-zzholdto IS NOT INITIAL.

    IF vbak-zzholdfrom GT vbak-zzholdto.
      MESSAGE e019(zqtc_r2). " The 'Date From' must preceed the 'Date To'
    ENDIF. " IF vbak-zzholdfrom GT vbak-zzholdto

  ENDIF. " IF vbak-zzholdfrom IS NOT INITIAL OR vbak-zzholdto IS NOT INITIAL

ENDMODULE.
*----------------------------------------------------------------------*
* MODULE: ZZQTC_VALIDATE_ZZLICYR INPUT
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI/KKR)
* CREATION DATE: 06/06/2018
* OBJECT ID: I0230 - CR#6142
* TRANSPORT NUMBER(S): ED2K912174
*----------------------------------------------------------------------*
MODULE zzqtc_validate_zzlicyr INPUT.

  DATA: lv_zzlicyr_tmp TYPE salv_de_selopt_low,
        lv_zzlicyr     TYPE zzlicyr.
  CONSTANTS: lc_devid_i0230 TYPE zdevid VALUE 'I0230',
             lc_param1_ly   TYPE rvari_vnam VALUE 'LICENSE_YEAR',
             lc_param2_zly  TYPE rvari_vnam VALUE 'ZZLICYR'.
  IF vbak-zzlicyr IS NOT INITIAL.
    SELECT SINGLE low FROM zcaconstant INTO lv_zzlicyr_tmp
                      WHERE devid = lc_devid_i0230 AND
                            param1 = lc_param1_ly AND
                            param2 = lc_param2_zly AND
                            activate = abap_true.
    IF sy-subrc = 0.
      lv_zzlicyr = lv_zzlicyr_tmp.
      IF vbak-zzlicyr < lv_zzlicyr.
        MESSAGE e249(zqtc_r2) WITH lv_zzlicyr. " License Year Should be >= 2011
        CLEAR lv_zzlicyr.
      ENDIF. " IF vbak-zzlicyr < lv_zzlicyr
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF vbak-zzlicyr IS NOT INITIAL

ENDMODULE.
* Begin of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
*&---------------------------------------------------------------------*
*&      Module  ZZQTC_VALIDATE_FIELD_ACS_MECH  INPUT
*&---------------------------------------------------------------------*
*       Validate Access Mechanism
*----------------------------------------------------------------------*
MODULE zzqtc_validate_field_acs_mech INPUT.
  INCLUDE zqtcn_access_trckng_scty_vld IF FOUND.
ENDMODULE.
* End   of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
