*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Firm Invoice Order Validation
*                      1. When saving the contract Display Information /
*                         Error message popups when user changed values
*                         are not same as defaults
*                      2. If user accepts the message, continue editing
*                      3. If user ignores allow to save
* REFERENCE NO: E254 - ERPM-16414
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-23-2020
* TRANSPORT NUMBER(s): ED2K918988
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K925900
* REFERENCE NO: OTCM-42835/45291- E254
* DEVELOPER: VDPATABALL
* DATE:  2022-03-03
* DESCRIPTION: Skipping the below FRM validation to Doc Typ 'ZCOP'
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FRM_INV_ORD_SAVE_E254
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
        BEGIN OF lty_but000,
          partner	   TYPE bu_partner,        " Business Partner Number
          langu_corr TYPE bu_langu_corr,     " Business Partner: Correspondence Language
        END OF lty_but000.

* Local Constant Declaration
CONSTANTS :
  lc_e254     TYPE zdevid        VALUE 'E254',  " Development ID
  lc_land1    TYPE rvari_vnam    VALUE 'LAND1', " ABAP: Name of Variant Variabl
  lc_werks    TYPE rvari_vnam    VALUE 'WERKS', " ABAP: Name of Variant Variabl
  lc_sls_org  TYPE rvari_vnam    VALUE 'VKORG', " ABAP: Name of Variant Variabl
  lc_tcode    TYPE rvari_vnam    VALUE 'TCODE', " ABAP: Name of Variant Variabl
  lc_kvgr1    TYPE rvari_vnam    VALUE 'KVGR1', " ABAP: Name of Variant Variabl
  lc_doctyp   TYPE rvari_vnam    VALUE 'AUART', " ABAP: Name of Variant Variabl "++ VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
  lc_vkbur    TYPE rvari_vnam    VALUE 'VKBUR', " ABAP: Name of Variant Variabl
  lc_zterm    TYPE rvari_vnam    VALUE 'ZTERM', " ABAP: Name of Variant Variabl
  lc_sp       TYPE parvw         VALUE 'AG',    " Sold-to-party
  lc_veda     TYPE char40        VALUE '(SAPLV45W)XVEDA[]',
  lc_header   TYPE posnr_va      VALUE '000000', " Header Item number
  lc_germany  TYPE bu_langu_corr VALUE 'DE',    " German Language
  lc_ent1(20) TYPE c             VALUE 'ENT1',  " FCODE
  lc_info     TYPE iconname      VALUE 'ICON_MESSAGE_INFORMATION', " Information message Icon
  lc_err      TYPE iconname      VALUE 'ICON_MESSAGE_ERROR'.       " Error message Icon

* local Internal Table Declaration
DATA : li_zcaconstnt  TYPE STANDARD TABLE OF lty_zcaconst INITIAL SIZE 0,
       lst_but000     TYPE lty_but000,
       lst_land1      TYPE fip_s_werks_range, " Workarea for country key
       li_land1_range TYPE fip_t_werks_range, " Range: Country Key
       li_werks_range TYPE fip_t_werks_range, " Range: Country Key
       li_vkorg_range TYPE fip_t_werks_range, " Range: Country Key
       li_tcode_range TYPE fip_t_werks_range, " Range: T-Codes
       li_kvgr1_range TYPE fip_t_werks_range, " Range: Customer Group - 1
       li_vkbur_range TYPE fip_t_werks_range, " Range: Sales Office
       lv_zterm       TYPE dzterm ,           " Terms of Payment Key
       lv_country     TYPE c,
       lv_plant       TYPE c,
       lv_sls_org     TYPE c,
       li_veda        TYPE STANDARD TABLE OF vedavb, " Reference Structure XVEDA/YVEDA
       lv_return      TYPE c,
       lv_ch          TYPE c,
       lv_msg(60)     TYPE c,
       lst_auart_e254 TYPE fssc_dp_s_rg_auart, "++ VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
       lir_auart_e254 TYPE fssc_dp_t_rg_auart. "++ VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022

* Local Field symbols declaration
FIELD-SYMBOLS:
  <lfs_veda> TYPE ztrar_vedavb. " Changed records with new values, Unchanged records with old values

CLEAR : lst_but000, lst_land1, lv_zterm, lv_country, lv_plant, lv_sls_org, lv_return, lv_ch, lv_msg.
REFRESH : li_zcaconstnt, li_land1_range, li_werks_range, li_vkorg_range,
          li_tcode_range, li_kvgr1_range, li_vkbur_range, li_veda,lir_auart_e254.

* Firm Invoice Order Validation - When saving the document
IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
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
    " Segregate the Country keys, Delivery plants and
    "   Sales orgs in separate range internal tables
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
        WHEN lc_zterm. " ZTERM
          lv_zterm = lst_land1-low.
*----BOC VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
        WHEN lc_doctyp. " AUART
          IF <lst_zcaconstnt>-param2 IS NOT INITIAL.
            FREE:lst_auart_e254,lir_auart_e254.
            lst_auart_e254-sign   = <lst_zcaconstnt>-sign.
            lst_auart_e254-option = <lst_zcaconstnt>-opti.
            lst_auart_e254-low    = <lst_zcaconstnt>-low.
            APPEND lst_auart_e254 TO lir_auart_e254.
          ENDIF.
*----EOC VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022
      ENDCASE.
      CLEAR: lst_land1.
    ENDLOOP.
    IF vbak-auart IN lir_auart_e254. "++VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022.
      " When Contract is created or changed
      IF t180-tcode IN li_tcode_range.

        " If Customer Group 1 is not equal to 'PSA' or 'PSB' then proceed
        IF vbak-kvgr1 IN li_kvgr1_range.
          EXIT.
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
          READ TABLE xvbap ASSIGNING FIELD-SYMBOL(<lst_vbap>) INDEX 1.
          IF sy-subrc EQ 0 AND
            <lst_vbap>-werks IN li_werks_range.
            lv_plant = abap_true.
          ENDIF.
          " Check for BOM items
          IF lv_plant IS INITIAL.
            LOOP AT xvbap ASSIGNING <lst_vbap> WHERE stlnr IS NOT INITIAL AND
                 werks IN li_werks_range.
              lv_plant = abap_true.
              EXIT.
            ENDLOOP.
          ENDIF.
          " Check the Sales Org is as per the ZCACONSTANT entries
          IF vbak-vkorg IN li_vkorg_range.
            lv_sls_org = abap_true.
          ENDIF.
          " If Country key, Plant and Sales Org are as per the ZCACONSTANT entries
          IF lv_country EQ abap_true AND
             lv_plant   EQ abap_true AND
             lv_sls_org EQ abap_true.

            " If Sales office is Non-EAL (0080) and Payment Method is blank
            IF vbak-vkbur IN li_vkbur_range. " Sales office
              READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
                WITH KEY vbeln = vbak-vbeln posnr = lc_header.
              IF sy-subrc EQ 0 AND <lst_vbkd>-zlsch IS INITIAL.      " Payment Method of header is initial

                CLEAR : lv_ch, lv_msg.

                " *** Sales Group logic ***
                " If Sales group value is blank
                IF vbak-vkgrp IS INITIAL.
                  " Display informative popup message
                  CLEAR lv_return.
                  CALL FUNCTION 'POPUP_TO_CONFIRM'
                    EXPORTING
                      titlebar              = 'Firm Invoice Validation'(037)
                      text_question         = 'Sales group field is blank'(036)
                      text_button_1         = 'Accept'(026)
                      text_button_2         = 'Ignore'(027)
                      display_cancel_button = ' '
                      popup_type            = lc_info " Information Icon
                    IMPORTING
                      answer                = lv_return
                    EXCEPTIONS
                      text_not_found        = 1
                      OTHERS                = 2.
                  IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                    IF lv_return EQ 1. " User pressed 'Accept' button
                      " This will stay on the same screen
                      " where the user was when clicking on 'Save'.
                      PERFORM folge_gleichsetzen(saplv00f).
                      fcode = lc_ent1.
                      SET SCREEN syst-dynnr.
                      LEAVE SCREEN.
                    ENDIF. " IF lv_return EQ 1.
                  ENDIF. " IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                ENDIF.

                " *** Action at end of contract Logic ***
                " Read XVEDA[]
                ASSIGN (lc_veda) TO <lfs_veda>.
                IF <lfs_veda> IS ASSIGNED.
                  " Get values of table XVEDA
                  li_veda[] = <lfs_veda>.
                  SORT li_veda BY vbeln vposn.
                  " Check the Action field value in the header record
                  READ TABLE li_veda ASSIGNING FIELD-SYMBOL(<lst_veda>)
                    WITH KEY vposn = lc_header.
                  IF sy-subrc EQ 0 AND <lst_veda>-vaktsch IS INITIAL.
                    " Display informative popup message
                    CLEAR lv_return.
                    CALL FUNCTION 'POPUP_TO_CONFIRM'
                      EXPORTING
                        titlebar              = 'Firm Invoice Validation'(037)
                        text_question         = 'Action field is blank'(028)
                        text_button_1         = 'Accept'(026)
                        text_button_2         = 'Ignore'(027)
                        display_cancel_button = ' '
                        popup_type            = lc_info " Information Icon
                      IMPORTING
                        answer                = lv_return
                      EXCEPTIONS
                        text_not_found        = 1
                        OTHERS                = 2.
                    IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                      IF lv_return EQ 1. " User pressed 'Accept' button
                        " This will stay on the same screen
                        " where the user was when clicking on 'Save'.
                        PERFORM folge_gleichsetzen(saplv00f).
                        fcode = lc_ent1.
                        SET SCREEN syst-dynnr.
                        LEAVE SCREEN.
                      ENDIF. " IF lv_return EQ 1.
                    ENDIF. " IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                  ENDIF. " IF sy-subrc EQ 0 AND <lst_veda>-vaktsch IS INITIAL.
                ENDIF. " IF <lfs_veda> IS ASSIGNED.

                " *** Language Logic ***
                IF <lst_vbpa> IS NOT INITIAL.
                  SELECT SINGLE partner langu_corr
                    FROM but000
                    INTO lst_but000
                    WHERE partner EQ <lst_vbpa>-kunnr.
                  IF sy-subrc EQ 0 AND lst_but000-langu_corr NE lc_germany.
                    " Display Error popup message
                    CLEAR lv_return.
                    CALL FUNCTION 'POPUP_TO_CONFIRM'
                      EXPORTING
                        titlebar              = 'Firm Invoice Validation'(037)
                        text_question         = text-029
                        text_button_1         = 'Accept'(026)
                        text_button_2         = 'Ignore'(027)
                        display_cancel_button = ' '
                        popup_type            = lc_err " Error Icon
                      IMPORTING
                        answer                = lv_return
                      EXCEPTIONS
                        text_not_found        = 1
                        OTHERS                = 2.
                    IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                      IF lv_return EQ 1. " User pressed 'Accept' button
                        " This will stay on the same screen
                        " where the user was when clicking on 'Save'.
                        PERFORM folge_gleichsetzen(saplv00f).
                        fcode = lc_ent1.
                        SET SCREEN syst-dynnr.
                        LEAVE SCREEN.
                      ENDIF. " IF lv_return EQ 1.
                    ENDIF. " IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                  ENDIF. " IF sy-subrc EQ 0 AND lst_but000-langu_corr NE lc_germany.
                ENDIF. " IF <lst_vbpa> IS NOT INITIAL.

                " *** Terms of Payment Key Logic ***
                LOOP AT xvbkd ASSIGNING FIELD-SYMBOL(<lfs_xvbkd>)
                  WHERE zterm NE lv_zterm.
                  lv_ch = abap_true.
                  lv_msg = 'For Sales group FRM Please correct the payment terms to ZD09'(033).
                  EXIT.
                ENDLOOP.
                " Display informative popup message
                IF lv_ch IS NOT INITIAL AND lv_msg IS NOT INITIAL.
                  CLEAR lv_return.
                  CALL FUNCTION 'POPUP_TO_CONFIRM'
                    EXPORTING
                      titlebar              = 'Firm Invoice Validation'(037)
                      text_question         = lv_msg
                      text_button_1         = 'Accept'(026)
                      text_button_2         = 'Ignore'(027)
                      display_cancel_button = ' '
                      popup_type            = lc_info " Information Icon
                    IMPORTING
                      answer                = lv_return
                    EXCEPTIONS
                      text_not_found        = 1
                      OTHERS                = 2.
                  IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                    IF lv_return EQ 1. " User pressed 'Accept' button
                      " This will stay on the same screen
                      " where the user was when clicking on 'Save'.
                      PERFORM folge_gleichsetzen(saplv00f).
                      fcode = lc_ent1.
                      SET SCREEN syst-dynnr.
                      LEAVE SCREEN.
                    ENDIF. " IF lv_return EQ 1.
                  ENDIF. " IF sy-subrc EQ 0 AND lv_return IS NOT INITIAL.
                ENDIF. " IF lv_ch IS NOT INITIAL AND lv_msg IS NOT INITIAL.
              ENDIF. " IF sy-subrc eq 0 and <lst_vbkd>-zlsch IS INITIAL.
            ENDIF. " IF vbak-vkbur IN li_vkbur_range. " Sales office
          ENDIF. " IF lv_country EQ lc_x AND lv_plant EQ lc_x AND lv_sls_org EQ lc_x.
        ENDIF. " IF vbak-kvgr1 IN li_kvgr1_range.
      ENDIF. " IF t180-tcode IN li_tcode_range.
    ENDIF. "++VDPATABALL OTCM-45291 :Exc. order typ ZCOP from FRM 02/28/2022.

    FREE : lst_but000, lst_land1, lv_zterm, lv_country, lv_plant, lv_sls_org, lv_return, lv_ch, lv_msg,
           li_zcaconstnt, li_land1_range, li_werks_range, li_vkorg_range, li_tcode_range, li_kvgr1_range, li_veda.
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL
