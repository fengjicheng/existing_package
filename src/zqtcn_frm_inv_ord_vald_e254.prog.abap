*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Firm Invoice Order Validation
*                      1. Programatically setting the default values
*                      2. Precedence is given for user changed values
* REFERENCE NO: E254 - ERPM-16414
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-23-2020
* TRANSPORT NUMBER(s): ED2K918988
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K920883
* REFERENCE NO: OTCM-28954_E254
* DEVELOPER:    Mohammed Aslam (AMOHAMMED)
* DATE:         12-17-2020
* DESCRIPTION:  VCH Sales Group FRM Enhancement
*               1. When
*                    VCH Customer
*                    VCH Product
*                    Sales Office 0080
*                    Material Group 5 not IN
*                    Not PSA and PSB customer group (agent)
*                    PO Type not 300 WOL, 314 OLR
*                    Payment Method J or Blank
*                    Future renewal is from FIRM to DD
*                    Future renewal is from DD to FIRM
*                  Then
*                    Sales Group FRM is populated
*                    Action Field and Action date is determined
*                    Terms of Payment is ZD09
*               2. When
*                    Material Group 5 IN
*                    PSA and PSB customer group (agent)
*                    PO Type is 300 WOL, 314 OLR
*                    Payment Method is Credit card or CWO
*                  Then
*                    Sales Group FRM NOT populated
*                    Action Field and Action date reset to blank
*                    Terms of Payment from BP Master
*               3. When
*                    Future renewal is from FIRM to DD
*                    Future renewal is from DD to FIRM
*                  Then
*                    Action date in Target document should be same as
*                    Contract end date of Target Document.
*----------------------------------------------------------------------*
* REVISION NO:  ED2K923563                                             *
* REFERENCE NO: OTCM-44639                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  05/25/2021                                                    *
* DESCRIPTION: UK Logic - Future Change functionality for firm invoices*
*              Comment the exiting Cleared VEDA-VAKTSCH ,VEDA-VASDR ,  *
*              VEDA-VASDA and keep the value as it is when it's change *
*              manually                                                *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K925900
* REFERENCE NO: OTCM-42835/45291- E254
* DEVELOPER: VDPATABALL
* DATE:  2022-03-03
* DESCRIPTION: Skipping the below FRM validation to Doc Typ 'ZCOP'
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FRM_INV_ORD_VALD_E254
*&---------------------------------------------------------------------*

* Type Declaration
TYPES : BEGIN OF lty_zcaconst,
          devid    TYPE zdevid,              " Development ID
          param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          " ABAP: Current selection number
          sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          activate TYPE zconstactive,        " Activation indicator for constant
        END OF   lty_zcaconst,
        BEGIN OF lty_static_var,
          vbeln         TYPE vbeln_va,          " Contract
          vgbel         TYPE vgbel,             " Document number of Reference document
          vkgrp         TYPE vkgrp,             " Sales Group
          vaktsch       TYPE vasch_veda,        " Action at end of contract
          zterm         TYPE dzterm ,           " Terms of Payment Key
          accept_change TYPE c,
        END OF lty_static_var.

" Static structure holds the programatically changed values
STATICS : ls_static_var TYPE lty_static_var.


* Local Constant Declaration
CONSTANTS :
  lc_e254    TYPE zdevid     VALUE 'E254',  " Development ID
  lc_land1   TYPE rvari_vnam VALUE 'LAND1', " ABAP: Name of Variant Variabl
  lc_werks   TYPE rvari_vnam VALUE 'WERKS', " ABAP: Name of Variant Variabl
  lc_sls_org TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variabl
  lc_tcode   TYPE rvari_vnam VALUE 'TCODE', " ABAP: Name of Variant Variabl
  lc_kvgr1   TYPE rvari_vnam VALUE 'KVGR1', " ABAP: Name of Variant Variabl
  lc_vkgrp   TYPE rvari_vnam VALUE 'VKGRP', " ABAP: Name of Variant Variabl
  lc_vaktsch TYPE rvari_vnam VALUE 'VAKTSCH', " ABAP: Name of Variant Variabl
  lc_zterm   TYPE rvari_vnam VALUE 'ZTERM', " ABAP: Name of Variant Variabl
  lc_doctyp  TYPE rvari_vnam VALUE 'AUART', " ABAP: Name of Variant Variabl
  lc_vkbur   TYPE rvari_vnam VALUE 'VKBUR', " ABAP: Name of Variant Variabl
  lc_zlsch   TYPE rvari_vnam VALUE 'ZLSCH', " ABAP: Name of Variant Variabl
  lc_sp      TYPE parvw      VALUE 'AG',    " Sold-to-party
  lc_sich    TYPE syst_ucomm VALUE 'SICH',  " SAVE button
  lc_bt02    TYPE syst_ucomm VALUE 'BT02',  " Ignore button
  lc_header  TYPE posnr_va   VALUE '000000', " Header Item number
  lc_xveda   TYPE char40     VALUE '(SAPLV45W)XVEDA[]',
  lc_vasdr   TYPE vasdr      VALUE '08'.    " Date rule for action.

* local Internal Table Declaration
DATA : li_zcaconstnt  TYPE STANDARD TABLE OF lty_zcaconst INITIAL SIZE 0,
       lst_land1      TYPE fip_s_werks_range, " Workarea for country key
       li_land1_range TYPE fip_t_werks_range, " Range: Country Key
       li_werks_range TYPE fip_t_werks_range, " Range: Plants
       li_vkorg_range TYPE fip_t_werks_range, " Range: Sales Org
       li_tcode_range TYPE fip_t_werks_range, " Range: T-Codes
       li_kvgr1_range TYPE fip_t_werks_range, " Range: Customer Group - 1
       li_vkbur_range TYPE fip_t_werks_range, " Range: Sales Office
       li_zlsch_range TYPE fip_t_werks_range, " Range: Sales Office
       lv_vkgrp       TYPE vkgrp,             " Sales Group
       lv_vaktsch     TYPE vasch_veda,        " Action at end of contract
       lv_zterm       TYPE dzterm,            " Terms of Payment Key
       lv_zrew        TYPE auart,             " Document type
       lv_country     TYPE c,
       lv_plant       TYPE c,
       lv_sls_org     TYPE c,
       lv_tabix       TYPE syst_tabix,
       li_xveda       TYPE STANDARD TABLE OF vedavb, " Reference Structure XVEDA/YVEDA
       lv_knvv_zterm  TYPE dzterm, " Terms of Payment Key
       ls_veda_kopf   TYPE veda,
       ls_veda        TYPE veda,
       lst_auart_e254 TYPE fssc_dp_s_rg_auart, "++ VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
       lir_auart_e254 TYPE fssc_dp_t_rg_auart. "++ VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022

* Local Field symbols declaration
FIELD-SYMBOLS : <lfs_xveda> TYPE ztrar_vedavb. " Changed records with new values, Unchanged records with old values

* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
DATA : lv_mvgr5       TYPE mvgr5,        " Material Group 5.
       li_bsark_range TYPE tdt_rg_bsark, " Range: Purchase Order type.
       lv_mvgr5_chk   TYPE c,
       lv_j           TYPE schzw_bseg,   " Payment Method
       li_xvbap       LIKE xvbap[]. " Document Structure for XVBAP/YVBAP
CONSTANTS : lc_mvgr5 TYPE rvari_vnam VALUE 'MVGR5', " ABAP: Name of Variant Variable
            lc_bsark TYPE rvari_vnam VALUE 'BSARK', " ABAP: Name of Variant Variable
            lc_two   TYPE tvarv_numb VALUE '0002',  " ABAP: Current selection number
            lc_i     TYPE c          VALUE 'I'.     " Insert
CLEAR : lv_mvgr5, lv_mvgr5_chk, lv_j.
REFRESH : li_bsark_range.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883

CLEAR : lst_land1, lv_vkgrp, lv_vaktsch, lv_zterm,
        lv_country, lv_plant, lv_sls_org, lv_tabix, lv_knvv_zterm, ls_veda, ls_veda_kopf.
REFRESH : li_zcaconstnt, li_land1_range, li_werks_range, li_vkorg_range,
          li_tcode_range, li_kvgr1_range, li_vkbur_range, li_xveda.

* Firm Invoice Order Validation
* 1. Programatically setting the default values
* 2. Precedence is given for user changed values
* 3. Should work in both foreground (sy-batch, sy-binpt, call_bapi are initial) and background(sy-batch, call_bapi are not initial)

" Get the Country keys, Delivery plants and Sales Orgs from zcaconstant Table
SELECT devid       "Development ID
       param1	     "ABAP: Name of Variant Variable
       param2	     "ABAP: Name of Variant Variable
       srno	       "ABAP: Current selection number
       sign	       "ABAP: ID: I/E (include/exclude values)
       opti	       "ABAP: Selection option (EQ/BT/CP/...)
       low         "Lower Value of Selection Condition
       high	       "Upper Value of Selection Condition
       activate    "Activation indicator for constant
  FROM zcaconstant "Wiley Application Constant Table
  INTO TABLE li_zcaconstnt
 WHERE devid  = lc_e254
   AND activate = abap_true.
IF sy-subrc EQ 0.
  SORT li_zcaconstnt BY param1.
  " Segregate the Country keys, Delivery plants, Sales Orgs,
  "   t-codes, Customer group -1, Sales Group, Action Field,
  "   Terms of Payment values in separate range internal tables
  LOOP AT li_zcaconstnt ASSIGNING FIELD-SYMBOL(<lst_zcaconstnt>).
    lst_land1-sign = <lst_zcaconstnt>-sign.
    lst_land1-option = <lst_zcaconstnt>-opti.
    lst_land1-low = <lst_zcaconstnt>-low.
    CASE <lst_zcaconstnt>-param1.
      WHEN lc_land1. " LAND1
        APPEND lst_land1 TO li_land1_range.
      WHEN lc_werks. " WERKS
        APPEND lst_land1 TO li_werks_range.
      WHEN lc_sls_org. " VKORG
        APPEND lst_land1 TO li_vkorg_range.
      WHEN lc_tcode. " TCODE
        APPEND lst_land1 TO li_tcode_range.
      WHEN lc_kvgr1. " KVGR1
        APPEND lst_land1 TO li_kvgr1_range.
      WHEN lc_vkbur. " VKBUR
        APPEND lst_land1 TO li_vkbur_range.
      WHEN lc_zlsch.
        APPEND lst_land1 TO li_zlsch_range.
* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
        " Read payment method 'J' from ZCACONSTANT table
        IF <lst_zcaconstnt>-srno EQ lc_two.
          lv_j = lst_land1-low.
        ENDIF.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
      WHEN lc_vkgrp. " VKGRP
        lv_vkgrp = lst_land1-low.
      WHEN lc_vaktsch. " VAKTSCH
        lv_vaktsch = lst_land1-low.
      WHEN lc_zterm. " ZTERM
        lv_zterm = lst_land1-low.
      WHEN lc_doctyp. " AUART
        IF <lst_zcaconstnt>-param2 IS INITIAL. "++VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
          lv_zrew = lst_land1-low.
*----BOC VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
        ELSEIF <lst_zcaconstnt>-param2 IS NOT INITIAL.
          FREE:lst_auart_e254,lir_auart_e254.
          lst_auart_e254-sign   = <lst_zcaconstnt>-sign.
          lst_auart_e254-option = <lst_zcaconstnt>-opti.
          lst_auart_e254-low    = <lst_zcaconstnt>-low.
          APPEND lst_auart_e254 TO lir_auart_e254.
        ENDIF.
*----EOC VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
        " Read Material group 5 'IN' from ZCACONSTANT table
      WHEN lc_mvgr5.
        lv_mvgr5 = lst_land1-low.
        " Read PO type values from ZCACONSTANT table
      WHEN lc_bsark.
        APPEND lst_land1 TO li_bsark_range.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
    ENDCASE.
    CLEAR: lst_land1.
  ENDLOOP.

  IF vbak-auart IN lir_auart_e254. "++VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022.
    " When Contract is created
    IF t180-tcode IN li_tcode_range.
      " If Customer Group 1 is not equal to 'PSA' or 'PSB' then proceed (OR)
      IF vbak-kvgr1 IN li_kvgr1_range OR
* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
         " If Purchase Order type is not equal to '0300' or '0314' then proceed
         vbak-bsark IN li_bsark_range.
        " Clear the static variable of sales group
        CLEAR : ls_static_var-vkgrp, vbak-vkgrp.

        " Read XVEDA[]
        ASSIGN (lc_xveda) TO <lfs_xveda>.
        IF <lfs_xveda> IS ASSIGNED.
          " Get values of table XVEDA
          li_xveda[] = <lfs_xveda>.
          SORT li_xveda BY vbeln vposn.
          " Check and Update the Action field value in the header record only
          READ TABLE li_xveda ASSIGNING FIELD-SYMBOL(<lst_xveda>)
            WITH KEY vposn = lc_header.
          IF sy-subrc EQ 0.
            lv_tabix = sy-tabix.
            " Clear the Action Field and Rule of Action date fields
            CLEAR : ls_static_var-vaktsch,  " Clear the static variable
                    <lst_xveda>-vaktsch, <lst_xveda>-vasdr, <lst_xveda>-vasda.
            MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
          ENDIF.
        ENDIF.

        CLEAR : ls_static_var-zterm. " Clear the static variable
        " Assign terms of payment from BP master if available
        SELECT SINGLE zterm
          FROM knvv
          INTO lv_knvv_zterm
          WHERE kunnr = vbak-kunnr
            AND vkorg = vbak-vkorg
            AND vtweg = vbak-vtweg
            AND spart = vbak-spart.
        IF sy-subrc EQ 0.
          vbkd-zterm = lv_knvv_zterm.
        ELSE.
          CLEAR vbkd-zterm. " Clear terms of payment screen field
        ENDIF.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
      ELSE.
        " Check the Country key is as per the ZCACONSTANT entries
        READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
          WITH KEY parvw = lc_sp " Sold-to-party
                   kunnr = vbak-kunnr.
        IF sy-subrc EQ 0 AND
           <lst_vbpa>-land1 IN li_land1_range.
          lv_country = abap_true.
        ENDIF.
        " Check the Delivery plant is as per the ZCACONSTANT entries
        IF xvbap[] IS INITIAL.
          CLEAR : ls_static_var.
        ELSE.
          li_xvbap[] = xvbap[].
          SORT li_xvbap BY abgru ASCENDING stlnr ASCENDING updkz ASCENDING.
          READ TABLE li_xvbap ASSIGNING FIELD-SYMBOL(<lst_vbap>)
            WITH KEY abgru = space
                     stlnr = space
                     updkz = lc_i BINARY SEARCH.
* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
*        IF sy-subrc EQ 0 AND <lst_vbap>-werks IN li_werks_range.
*          lv_plant = abap_true.
*        ENDIF.
          IF sy-subrc EQ 0.
            " Check the Delivery plant is as per the ZCACONSTANT entries
            IF <lst_vbap>-werks IN li_werks_range.
              lv_plant = abap_true.
            ENDIF.
            " Check the Material Group is not as per the ZCACONSTANT entries then proceed
            IF <lst_vbap>-mvgr5 NE lv_mvgr5.
              lv_mvgr5_chk = abap_true.
            ELSE.
              " Clear the static variable of sales group
              CLEAR : ls_static_var-vkgrp, vbak-vkgrp.

              " Read XVEDA[]
              ASSIGN (lc_xveda) TO <lfs_xveda>.
              IF <lfs_xveda> IS ASSIGNED.
                " Get values of table XVEDA
                li_xveda[] = <lfs_xveda>.
                SORT li_xveda BY vbeln vposn.
                " Check and Update the Action field value in the header record only
                READ TABLE li_xveda ASSIGNING <lst_xveda>
                  WITH KEY vposn = lc_header.
                IF sy-subrc EQ 0.
                  lv_tabix = sy-tabix.
                  " Clear the Action Field and Rule of Action date fields
                  CLEAR : ls_static_var-vaktsch,  " Clear the static variable
                          <lst_xveda>-vaktsch, <lst_xveda>-vasdr, <lst_xveda>-vasda.
                  MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
                ENDIF.
              ENDIF.

              CLEAR : ls_static_var-zterm. " Clear the static variable
              " Assign terms of payment from BP master if available
              SELECT SINGLE zterm
                FROM knvv
                INTO lv_knvv_zterm
                WHERE kunnr = vbak-kunnr
                  AND vkorg = vbak-vkorg
                  AND vtweg = vbak-vtweg
                  AND spart = vbak-spart.
              IF sy-subrc EQ 0.
                vbkd-zterm = lv_knvv_zterm.
              ELSE.
                CLEAR vbkd-zterm. " Clear terms of payment screen field
              ENDIF.
            ENDIF.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
          ENDIF.
          " Check for BOM items
          LOOP AT li_xvbap ASSIGNING <lst_vbap> WHERE abgru IS INITIAL
                                                  AND stlnr IS NOT INITIAL
                                                  AND updkz EQ lc_i.
            IF lv_plant IS INITIAL AND <lst_vbap>-werks IN li_werks_range.
              lv_plant = abap_true.
            ENDIF.
            IF lv_mvgr5_chk IS INITIAL AND <lst_vbap>-mvgr5 NE lv_mvgr5.
              lv_mvgr5_chk = abap_true.
            ENDIF.
          ENDLOOP.
          REFRESH li_xvbap.
        ENDIF.
        " Check the Sales Org is as per the ZCACONSTANT entries
        IF vbak-vkorg IN li_vkorg_range.
          lv_sls_org = abap_true.
        ENDIF.
        " If Country key, Plant and Sales Org are as per the ZCACONSTANT entries
        IF lv_country EQ abap_true AND
           lv_plant   EQ abap_true AND
           lv_sls_org EQ abap_true AND
           lv_mvgr5_chk EQ abap_true. " by AMOHAMMED on 12-17-2020 TR # ED2K920883

          " When SAVE / Ignore button is not pressed yet
          IF sy-ucomm NE lc_sich AND sy-ucomm NE lc_bt02.

            " *** Sales Group logic ***

            " Clear and free the static memory
            IF ls_static_var-vbeln NE vbak-vbeln OR " When the contract number is changed in VA41
               ls_static_var-vgbel NE vbak-vgbel.   " When the Reference document is changed
              CLEAR ls_static_var.
              FREE ls_static_var.
            ENDIF.

* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
            " When Sales office is Non-EAL (0080) and Payment Method is neither blank nor 'J'
            IF vbak-vkbur IN li_vkbur_range AND ( vbkd-zlsch IS NOT INITIAL AND vbkd-zlsch NE lv_j ).
              " Clear the static variable of sales group
              CLEAR : ls_static_var-vkgrp, vbak-vkgrp.

              " Read XVEDA[]
              ASSIGN (lc_xveda) TO <lfs_xveda>.
              IF <lfs_xveda> IS ASSIGNED.
                " Get values of table XVEDA
                li_xveda[] = <lfs_xveda>.
                SORT li_xveda BY vbeln vposn.
                " Check and Update the Action field value in the header record only
                READ TABLE li_xveda ASSIGNING <lst_xveda>
                  WITH KEY vposn = lc_header.
                IF sy-subrc EQ 0.
                  lv_tabix = sy-tabix.
                  " Clear the Action Field and Rule of Action date fields
****    BOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
*                CLEAR : ls_static_var-vaktsch,  " Clear the static variable
*                        <lst_xveda>-vaktsch, <lst_xveda>-vasdr, <lst_xveda>-vasda.
*                MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
****    EOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
                ENDIF.
              ENDIF.
*          " When Sales office is Non-EAL (0080) and Payment Method is blank
*          IF vbak-vkbur IN li_vkbur_range AND vbkd-zlsch IS INITIAL.
              " When Sales office is Non-EAL (0080) and Payment Method is blank or 'J'
            ELSEIF vbak-vkbur IN li_vkbur_range AND ( vbkd-zlsch IS INITIAL OR vbkd-zlsch EQ lv_j ).
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
              " Store the current contract number, Reference number in static memory
              ls_static_var-vbeln = vbak-vbeln.
              ls_static_var-vgbel = vbak-vgbel.
              " When programatically changed sales group is not equal to user changed sales group
              IF ls_static_var-vkgrp NE vbak-vkgrp.
                " When sales group is changed programatically and user changed the sales group
                IF ls_static_var-vkgrp IS NOT INITIAL.
                  EXIT.
                ELSE.
                  " When sales group is not changed programtcially and
                  "   sales group is changed by other programs and not by user
                  IF vbak-vkgrp NE lv_vkgrp AND vbak-vkgrp IS NOT INITIAL.
                    ls_static_var-vkgrp = vbak-vkgrp = lv_vkgrp.
                  ENDIF.
                ENDIF.
              ELSE.
                " Initially when screen field Sales group is blank, default the value 'FRM'
                IF vbak-vkgrp IS INITIAL AND ls_static_var-vkgrp IS INITIAL.
                  ls_static_var-vkgrp = vbak-vkgrp = lv_vkgrp.
                ENDIF.
              ENDIF.
              " If Sales office is not Non-EAL (0080) or Payment Method is 'U' or 'J'
            ELSEIF ( vbak-vkbur NE *vbak-vkbur AND vbak-vkbur NOT IN li_vkbur_range ) OR
              vbkd-zlsch IN li_zlsch_range.
              " Clear the static variable of sales group
              CLEAR : ls_static_var-vkgrp.

              IF vbkd-zlsch IN li_zlsch_range.
                CLEAR vbak-vkgrp.
              ENDIF.

              " For ERPM-21151 when creating renewal contract DD with reference to Firm invoice
              " i.e. changing payment method from blanck to U or J Action field should not be cleared
              " OCTM - 27488 (Conflict when creating Future renewal due to ERPM-16414 on Action field)
              " TR :  ED2K919596
              IF vbak-auart EQ lv_zrew AND
                 vbak-vkbur IN li_vkbur_range AND
                 vbkd-zlsch IN li_zlsch_range.
                " Do not clear the Action field
              ELSE.
                " Read XVEDA[]
                ASSIGN (lc_xveda) TO <lfs_xveda>.
                IF <lfs_xveda> IS ASSIGNED.
                  " Get values of table XVEDA
                  li_xveda[] = <lfs_xveda>.
                  SORT li_xveda BY vbeln vposn.
                  " Check and Update the Action field value in the header record only
                  READ TABLE li_xveda ASSIGNING <lst_xveda>
                    WITH KEY vposn = lc_header.
                  IF sy-subrc EQ 0.
                    lv_tabix = sy-tabix.
                    " Clear the Action Field and Rule of Action date fields
****    BOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
*                  CLEAR : ls_static_var-vaktsch,  " Clear the static variable
*                          <lst_xveda>-vaktsch, <lst_xveda>-vasdr, <lst_xveda>-vasda.
*                  MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
****    EOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
                  ENDIF.
                ENDIF.
              ENDIF.

              CLEAR : ls_static_var-zterm. " Clear the static variable
              " When sales office is other than 0080, assign terms of payment from BP master if available
              SELECT SINGLE zterm
                FROM knvv
                INTO lv_knvv_zterm
                WHERE kunnr = vbak-kunnr
                  AND vkorg = vbak-vkorg
                  AND vtweg = vbak-vtweg
                  AND spart = vbak-spart.
              IF sy-subrc EQ 0.
                vbkd-zterm = lv_knvv_zterm.
              ELSE.
                CLEAR vbkd-zterm. " Clear terms of payment screen field
              ENDIF.
            ENDIF.

            " If Sales group value is 'FRM'
            IF vbak-vkgrp EQ lv_vkgrp.

              " *** action at end of contract logic ***

              " Read XVEDA[]
              ASSIGN (lc_xveda) TO <lfs_xveda>.
              IF <lfs_xveda> IS ASSIGNED.
                " Get values of table XVEDA
                li_xveda[] = <lfs_xveda>.
                SORT li_xveda BY vbeln vposn.
                " Check and Update the Action field value in the header record only
                READ TABLE li_xveda ASSIGNING <lst_xveda>
                  WITH KEY vposn = lc_header.
                IF sy-subrc EQ 0.
                  lv_tabix = sy-tabix.
                  " When programatically changed Action field is not equal to user changed Action field
                  IF ls_static_var-vaktsch NE <lst_xveda>-vaktsch.
                    " When Action field is changed programatically and user changed the Action field
                    IF ls_static_var-vaktsch IS NOT INITIAL.
                      EXIT.
                    ELSE.
                      " When Action field is not changed programtcially and
                      "   Action field is changed by other programs and not by user
                      IF <lst_xveda>-vaktsch NE lv_vaktsch AND <lst_xveda>-vaktsch IS NOT INITIAL.
                        " Update Action Field
                        ls_static_var-vaktsch = <lst_xveda>-vaktsch = lv_vaktsch.
                        " Update the dependent "Date rule for action" field with "08 - Contract Start Date + Contract Validity Period"
                        <lst_xveda>-vasdr = lc_vasdr.
                        MOVE-CORRESPONDING : <lst_xveda> TO ls_veda_kopf,
                                             <lst_xveda> TO ls_veda.
                        CALL FUNCTION 'SD_VEDA_GET_DATE'
                          EXPORTING
                            i_regel                    = <lst_xveda>-vasdr
                            i_veda_kopf                = ls_veda_kopf
                            i_veda_pos                 = ls_veda
                          IMPORTING
                            e_datum                    = <lst_xveda>-vasda
                          EXCEPTIONS
                            basedate_and_cal_not_found = 1
                            basedate_is_initial        = 2
                            basedate_not_found         = 3
                            cal_error                  = 4
                            rule_not_found             = 5
                            timeframe_not_found        = 6
                            wrong_month_rule           = 7
                            OTHERS                     = 8.
                        CASE sy-subrc.
                          WHEN 1.                          "BASEDATE_AND_CALE_NOT_FOUND
                            MESSAGE e011 WITH <lst_xveda>-vasdr.
                          WHEN 2.                          "BASEDATE_IS_INITIAL
                            IF <lst_xveda>-vasda IS INITIAL.
                              MESSAGE i008 WITH <lst_xveda>-vasdr.
                            ENDIF.
                          WHEN 4.                          "CAL_ERROR
                            MESSAGE e013 WITH <lst_xveda>-vasdr.
                          WHEN 3.                          "BASEDATE_NOT_FOUND
                            MESSAGE e007 WITH <lst_xveda>-vasdr.
                          WHEN 5.                          "RULE_NOT_FOUND
                            MESSAGE e005 WITH <lst_xveda>-vasdr.
                          WHEN 6.                          "TIMEFRAME_NOT_FOUND
                            MESSAGE w037 WITH <lst_xveda>-vasdr.
                          WHEN 7.                          "WRONG_MONTH_RULE
                            MESSAGE w041.
                        ENDCASE.
                        MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
                      ENDIF.
                    ENDIF.
                  ELSE.
                    " Initially when screen field Action field is blank, default the value '0001'
                    IF <lst_xveda>-vaktsch IS INITIAL AND ls_static_var-vaktsch IS INITIAL.
                      " Update Action Field
                      ls_static_var-vaktsch = <lst_xveda>-vaktsch = lv_vaktsch.
                      " Update the dependent "Date rule for action" field with "08 - Contract Start Date + Contract Validity Period"
                      <lst_xveda>-vasdr = lc_vasdr.
                      MOVE-CORRESPONDING : <lst_xveda> TO ls_veda_kopf,
                                           <lst_xveda> TO ls_veda.
                      CALL FUNCTION 'SD_VEDA_GET_DATE'
                        EXPORTING
                          i_regel                    = <lst_xveda>-vasdr
                          i_veda_kopf                = ls_veda_kopf
                          i_veda_pos                 = ls_veda
                        IMPORTING
                          e_datum                    = <lst_xveda>-vasda
                        EXCEPTIONS
                          basedate_and_cal_not_found = 1
                          basedate_is_initial        = 2
                          basedate_not_found         = 3
                          cal_error                  = 4
                          rule_not_found             = 5
                          timeframe_not_found        = 6
                          wrong_month_rule           = 7
                          OTHERS                     = 8.
                      CASE sy-subrc.
                        WHEN 1.                          "BASEDATE_AND_CALE_NOT_FOUND
                          MESSAGE e011 WITH <lst_xveda>-vasdr.
                        WHEN 2.                          "BASEDATE_IS_INITIAL
                          IF <lst_xveda>-vasda IS INITIAL.
                            MESSAGE i008 WITH <lst_xveda>-vasdr.
                          ENDIF.
                        WHEN 4.                          "CAL_ERROR
                          MESSAGE e013 WITH <lst_xveda>-vasdr.
                        WHEN 3.                          "BASEDATE_NOT_FOUND
                          MESSAGE e007 WITH <lst_xveda>-vasdr.
                        WHEN 5.                          "RULE_NOT_FOUND
                          MESSAGE e005 WITH <lst_xveda>-vasdr.
                        WHEN 6.                          "TIMEFRAME_NOT_FOUND
                          MESSAGE w037 WITH <lst_xveda>-vasdr.
                        WHEN 7.                          "WRONG_MONTH_RULE
                          MESSAGE w041.
                      ENDCASE.
                      MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.



              " *** Terms of Payment Key Logic ***
              " Update the field at Header only ( At item automatically updated)
              IF vbkd-posnr EQ lc_header.
                " Cleaer the static variable when the Sales office is changed by user
                IF vbak-vkbur NE *vbak-vkbur.
                  CLEAR ls_static_var-accept_change.
                ENDIF.
                " When programatically changed Terms of Payment is not equal to user changed Terms of Payment
                IF ls_static_var-zterm NE vbkd-zterm.
                  IF ls_static_var-accept_change IS INITIAL.
                    " When Terms of Payment is changed programatically and user changed the Terms of Payment
                    IF ls_static_var-zterm IS NOT INITIAL AND vbkd-zterm NE *vbkd-zterm.
                      ls_static_var-accept_change = abap_true.
                      EXIT.
                    ELSE.
                      " When Terms of Payment is not changed programtcially
                      IF vbkd-zterm NE lv_zterm AND vbkd-zterm EQ *vbkd-zterm.
                        ls_static_var-zterm = vbkd-zterm = lv_zterm.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ELSE.
                  " Initially when screen field Terms of Payment is blank, default the value 'ZD09'
                  IF vbkd-posnr EQ lc_header AND
                     vbkd-zterm IS INITIAL AND
                     ls_static_var-zterm IS INITIAL.
                    ls_static_var-zterm = vbkd-zterm = lv_zterm.
                  ENDIF.
                ENDIF. " IF ls_static_var-zterm NE vbkd-zterm.
              ENDIF. " IF vbkd-posnr EQ lc_header.
            ENDIF. " IF vbak-vkgrp EQ lc_vkgrp.
          ENDIF. " IF sy-ucomm NE 'SICH' AND sy-ucomm NE 'OPT2'.
        ELSE.
          " Clear the static variable of sales group
          CLEAR : ls_static_var-vkgrp, vbak-vkgrp.

          " Read XVEDA[]
          ASSIGN (lc_xveda) TO <lfs_xveda>.
          IF <lfs_xveda> IS ASSIGNED.
            " Get values of table XVEDA
            li_xveda[] = <lfs_xveda>.
            SORT li_xveda BY vbeln vposn.
            " Check and Update the Action field value in the header record only
            READ TABLE li_xveda ASSIGNING <lst_xveda>
              WITH KEY vposn = lc_header.
            IF sy-subrc EQ 0.
              lv_tabix = sy-tabix.
              " Clear the Action Field and Rule of Action date fields
****    BOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
*            CLEAR : ls_static_var-vaktsch,  " Clear the static variable
*                    <lst_xveda>-vaktsch, <lst_xveda>-vasdr, <lst_xveda>-vasda.
*            MODIFY <lfs_xveda> FROM <lst_xveda> INDEX lv_tabix.
****    EOC by Lahiru on 05/25/2021 for OTCM-44639 with ED2K923563 ****
            ENDIF.
          ENDIF.

          CLEAR : ls_static_var-zterm. " Clear the static variable
          " Assign terms of payment from BP master if available
          SELECT SINGLE zterm
            FROM knvv
            INTO lv_knvv_zterm
            WHERE kunnr = vbak-kunnr
              AND vkorg = vbak-vkorg
              AND vtweg = vbak-vtweg
              AND spart = vbak-spart.
          IF sy-subrc EQ 0.
            vbkd-zterm = lv_knvv_zterm.
          ELSE.
            CLEAR vbkd-zterm. " Clear terms of payment screen field
          ENDIF.
        ENDIF. " IF lv_country EQ lc_x AND lv_plant EQ lc_x AND lv_sls_org EQ lc_x.
      ENDIF. " IF vbak-kvgr1 IN li_kvgr1_range.
    ENDIF. " IF t180-tcode IN li_tcode_range.
  ENDIF. "++VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022.
  FREE : lst_land1, lv_vkgrp, lv_vaktsch, lv_zterm,
         lv_country, lv_plant, lv_sls_org, lv_tabix, ls_veda, ls_veda_kopf,
         li_zcaconstnt, li_land1_range, li_werks_range, li_vkorg_range,
         li_tcode_range, li_kvgr1_range, li_vkbur_range, li_xveda, lv_knvv_zterm,
* Begin by AMOHAMMED on 12-17-2020 TR # ED2K920883
         lv_mvgr5, lv_mvgr5_chk, lv_j, li_bsark_range.
* End by AMOHAMMED on 12-17-2020 TR # ED2K920883
ENDIF. " IF sy-subrc EQ 0
