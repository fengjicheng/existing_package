*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTRICT_PUBLISH_TYPE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_RESTRICT_PUBLISH_TYPE (Include)
*                      [Adv Billings change from Proforma to Invoice]
* PROGRAM DESCRIPTION: Restrict ZF5 by Material Publish Type
* DEVELOPER:           Nageswara Polina
* CREATION DATE:       09/25/2018
* OBJECT ID:           E164/CR7593
* TRANSPORT NUMBER(S): ED2K913451
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914057
* REFERENCE NO:  ERP7593
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          12/17/2018
* DESCRIPTION:   Contract License Start Date check added
*----------------------------------------------------------------------*
* REVISION NO:   ED2K914355
* REFERENCE NO:  ERP7593
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          01/28/2019
* DESCRIPTION:   ZF2 Billing date as Contract start date.
*----------------------------------------------------------------------*
* REVISION NO:   ED2K914975
* REFERENCE NO:  ERP7593/INC0241571
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          04/30/2019
* DESCRIPTION:   Timeout issue fix.
*----------------------------------------------------------------------*
* REVISION NO:   ED2K915739
* REFERENCE NO:  INC0245314
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          19/07/2019
* DESCRIPTION:   Different dates in billing plan for orders
*----------------------------------------------------------------------*
* REVISION NO:   ED1K912041
* REFERENCE NO:  INC0300750
* DEVELOPER:     Arjun Gadeela (ARGADEELA)
* DATE:          17/07/2020
* DESCRIPTION:   Billing date in Billing plan is incorrect issue fix
*----------------------------------------------------------------------*

TYPES: BEGIN OF lts_mara,
         matnr       TYPE matnr,
         ismpubltype TYPE ismpubltype,
       END OF lts_mara.

TYPES : BEGIN OF lty_constants,
          devid  TYPE zdevid,                                       "Devid
          param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                   "Current selection number
          sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
        END OF lty_constants.

STATICS:
  lis_constants  TYPE STANDARD TABLE OF lty_constants,              "Itab for constants
  lrs_sales_offc TYPE rjksd_vkbur_range_tab,                        "Range: Sales Office
  lrs_potype     TYPE STANDARD TABLE OF tds_rg_bsark,               "Range : PO type
  lrs_publsh_typ TYPE rjksd_publtype_range_tab,                     "Range: Publish type " CR7593 (E164)
  lrs_doc_typ    TYPE j_3rs_so_invoice_sd,                          "Range: Billing type " CR7593 (E164)
  lrs_publsh_zf2 TYPE j_3rs_so_invoice_sd,                          " ZF2 ED2K914355 NPOLINA ERP7593
  li_mara        TYPE TABLE OF lts_mara.                            " ED2K914975 NPOLINA 30/04/2019 INC0241571

* Local data declarations
DATA:
  lv_restrict_pub TYPE char1 VALUE abap_true,
*  li_mara         TYPE TABLE OF lts_mara,                       " ED2K914975 NPOLINA 30/04/2019 INC0241571
  lv_publsh_typ   TYPE ismpubltype,
  lv_vbegdat      TYPE vbdat_veda,
  lv_fkarv        TYPE fkarv.

CONSTANTS:
  lc_p1_sls_ofc1 TYPE rvari_vnam  VALUE 'SALES_OFF',             "Name of Variant Variable: Sales Office
  lc_doc_typ     TYPE rvari_vnam  VALUE 'DOC_TYPE',              "Name of Variant Variable: Sales Office
  lc_p1_pub_typ  TYPE rvari_vnam  VALUE 'PUBLISH_TYPE' ,         "Name of Variant Variable: Publish Type
  lc_p1_pub_zf2  TYPE rvari_vnam  VALUE 'PUBLISH_TYPE_UB' .      "DOc type ZF2 ED2K914355 NPOLINA ERP7593


IF lis_constants[] IS INITIAL.
* Get Cnonstant values
  SELECT devid                                                   "Devid
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                     "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE lis_constants
    WHERE devid    EQ lc_devid_e164 AND                          "Development ID
          activate EQ abap_true.                                 "Only active record
ENDIF.

IF lis_constants[] IS NOT INITIAL.
  LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value1>).
    CASE <lst_const_value1>-param1.
      WHEN lc_p1_sls_ofc1.                                        "Sales Office (SALES_OFFICE)
        APPEND INITIAL LINE TO lrs_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc2>).
        <lst_sales_offc2>-sign   = <lst_const_value1>-sign.
        <lst_sales_offc2>-option = <lst_const_value1>-opti.
        <lst_sales_offc2>-low    = <lst_const_value1>-low.
        <lst_sales_offc2>-high   = <lst_const_value1>-high.

      WHEN lc_p1_pub_typ.
        APPEND INITIAL LINE TO lrs_publsh_typ ASSIGNING FIELD-SYMBOL(<lst_publsdh_typ>).
        <lst_publsdh_typ>-sign   = <lst_const_value1>-sign.
        <lst_publsdh_typ>-option = <lst_const_value1>-opti.
        <lst_publsdh_typ>-low    = <lst_const_value1>-low.
        <lst_publsdh_typ>-high   = <lst_const_value1>-high.

      WHEN lc_doc_typ.
        APPEND INITIAL LINE TO lrs_doc_typ ASSIGNING FIELD-SYMBOL(<lst_doc_typ>).
        <lst_doc_typ>-sign   = <lst_const_value1>-sign.
        <lst_doc_typ>-option = <lst_const_value1>-opti.
        <lst_doc_typ>-low    = <lst_const_value1>-low.
        <lst_doc_typ>-high   = <lst_const_value1>-high.
* SOC by NPOLINA ERP7593 28/Jan/2019 ED2K914355
      WHEN lc_p1_pub_zf2.
        IF <lst_const_value1>-param2 = lc_doc_typ.
          APPEND INITIAL LINE TO lrs_publsh_zf2 ASSIGNING FIELD-SYMBOL(<lst_publsdh_zf2>).
          <lst_publsdh_zf2>-sign   = <lst_const_value1>-sign.
          <lst_publsdh_zf2>-option = <lst_const_value1>-opti.
          <lst_publsdh_zf2>-low    = <lst_const_value1>-low.
          <lst_publsdh_zf2>-high   = <lst_const_value1>-high.
        ENDIF.
* EOC by NPOLINA ERP7593 28/Jan/2019 ED2K914355
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF lis_constants IS NOT INITIAL.

* Check the conditions
IF lrs_sales_offc[] IS NOT INITIAL AND
   vbak-vkbur IN lrs_sales_offc.  " Sales office check

** Fetch Material Publish type
  IF  xvbap-matnr  IS NOT INITIAL.          " ED2K914975 NPOLINA 30/04/2019 INC0241571
    READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lfs_mara2>) WITH KEY matnr = xvbap-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      SELECT matnr ismpubltype
             FROM mara
             APPENDING TABLE li_mara        " ED2K914975 NPOLINA 30/04/2019 INC0241571
*           FOR ALL ENTRIES IN xvbap[]      " ED2K914975 NPOLINA 30/04/2019 INC0241571
             WHERE matnr = xvbap-matnr.
      IF sy-subrc IS INITIAL.
        SORT li_mara BY matnr.
      ENDIF.
    ENDIF.
  ENDIF.                                                  " ED2K914975 NPOLINA 30/04/2019
* Check Material type for each line item material
  LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lis_xfplt1>) WHERE fplnr EQ vbkd-fplnr.

    READ TABLE xvbap ASSIGNING FIELD-SYMBOL(<lis_vbap>) WITH KEY posnr = vbkd-posnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>) WITH KEY matnr = vbap-matnr BINARY SEARCH.
      IF sy-subrc EQ 0.
* Check Publish type and COntract Start date
* SOC by NPOLINA ERP7593 17/Dec/2018 ED2K914057
*        IF <lfs_mara>-ismpubltype IN lrs_publsh_typ
*                                  AND veda-vbegdat > sy-datum
*                                  AND <lis_xfplt1>-fkarv IN lrs_doc_typ.
*          <lis_xfplt1>-updkz = 'D'.
*        ENDIF.

        IF <lfs_mara>-ismpubltype IN lrs_publsh_typ AND <lis_xfplt1>-fkarv IN lrs_doc_typ.
          IF xvbap-zzlicstart LE sy-datum.    "License Start date check    ED2K914057
            <lis_xfplt1>-updkz = 'D'.
          ELSE.
            IF veda-vbegdat LE sy-datum.
              <lis_xfplt1>-updkz = 'D'.
            ENDIF.
          ENDIF.
        ENDIF.
* EOC by NPOLINA ERP7593 17/Dec/2018 ED2K914057
        " ZF2 Billing date should be current date for UBCM model orders from PQ
        IF lrs_publsh_typ[] IS NOT INITIAL AND
           <lfs_mara>-ismpubltype IN lrs_publsh_typ.
          IF NOT ( <lis_xfplt1>-fareg EQ '4' OR <lis_xfplt1>-fareg EQ '5' ).
            <lis_xfplt1>-afdat = sy-datum.   " Assign Current date as ZF2 Billing date (FPLT-AFDAT)
          ENDIF.
        ENDIF.

* SOC by NPOLINA ERP7593 28/Jan/2019 ED2K914355
        IF <lis_xfplt1>-fkarv IN lrs_publsh_zf2.
          IF <lfs_mara>-ismpubltype IN lrs_publsh_typ.

            IF xvbap-zzlicstart LE sy-datum.    "License Start date check
              <lis_xfplt1>-afdat = sy-datum.
            ELSE.
              IF xvbap-zzlicstart GT sy-datum.      " License Start date check
                <lis_xfplt1>-afdat = xvbap-zzlicstart.  " Billing date as License Start date
*                READ TABLE xfpla ASSIGNING FIELD-SYMBOL(<lfs_xfpla>) INDEX 1.   "ED2K915739 NPOLINA  INC0245314
                READ TABLE xfpla ASSIGNING FIELD-SYMBOL(<lfs_xfpla>) WITH KEY fplnr = vbkd-fplnr. "ED2K915739 NPOLINA  INC0245314
                IF sy-subrc EQ 0.
                  <lfs_xfpla>-bedat = xvbap-zzlicstart.
                  CLEAR: <lfs_xfpla>-bedar.                 "ED2K915739 NPOLINA  INC0245314
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
* BOC by ARGADEELA INC0300750 17/Jul/2020 ED1K912041
*            <lis_xfplt1>-afdat = veda-vbegdat.       " If not Material Type as UB
* EOC by ARGADEELA INC0300750 17/Jul/2020 ED1K912041
          ENDIF.
        ENDIF.
* EOC by NPOLINA ERP7593 28/Jan/2019 ED2K914355
      ENDIF.
    ENDIF.

  ENDLOOP.
  DELETE xfplt[] WHERE updkz = 'D'.

ENDIF. " IF lrs_sales_offc[] IS NOT INITIAL AND
