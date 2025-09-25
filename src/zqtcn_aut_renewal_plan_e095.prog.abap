*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOCUMENT (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* PROGRAM DESCRIPTION: 1. Validate the Ref doc number, BNAME contract
*                      2. Validate the Sub Ref ID, PO Type, PO number,
*                           Ship To Party “Your Reference” number at
*                           line item with BNAME contract
*                      3. Auto update the ZQTC_RENWL_PLAN table
* REFERENCE NO: E095 - ERPM-15045
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 09-21-2020
* TRANSPORT NUMBER(s): ED2K919548
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K921590 / ED2K921768
* REFERENCE NO: OTCM-41488
* DEVELOPER:    AMOHAMMED
* DATE:         2021-01-29
* DESCRIPTION:  INC0335885 - Allow changes on Renewal quotes with reference.
*               - Only numbers should be allowed in BNAME.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_AUT_RENEWAL_PLAN_E095
*&---------------------------------------------------------------------*

* Types Declarations
TYPES : BEGIN OF lty_vbpa_vld,
          vbeln TYPE vbeln,  "  Sales and Distribution Document Number
          posnr TYPE posnr,  "  Item number of the SD document
          parvw TYPE parvw,  "  Partner Function
          kunnr TYPE kunnr,  "  Customer Number
        END OF lty_vbpa_vld,

        BEGIN OF lty_vbkd_vld,
          vbeln   TYPE vbeln, " Sales and Distribution Document Number
          posnr	  TYPE posnr, " Item number of the SD document
          bstkd	  TYPE bstkd,   " Customer purchase order number
          bsark	  TYPE bsark,   " Customer purchase order type
          ihrez	  TYPE ihrez,   " Your Reference
          ihrez_e	TYPE ihrez_e, " Ship-to party character
        END OF lty_vbkd_vld,

        BEGIN OF lty_vbkd,
          vbeln TYPE vbeln, " Sales and Distribution Document Number
        END OF lty_vbkd,

        BEGIN OF lty_vbak,
          vbeln	TYPE vbeln_va, " Sales Document
          erdat	TYPE erdat,    " Date on Which Record Was Created
          erzet	TYPE erzet,    " Entry time
        END OF lty_vbak,

        BEGIN OF lty_vbap_ty,
          vbeln TYPE vbeln_va, " Sales Document
          posnr TYPE posnr_va, " Sales Document Item
        END OF lty_vbap_ty.

* Constants
CONSTANTS : lc_hdr        TYPE posnr         VALUE '000000',                   " Header record
            lc_er         TYPE c             VALUE 'E',                        " Error message
            lc_inf        TYPE iconname      VALUE 'ICON_MESSAGE_INFORMATION', " Information message Icon
            lc_ent(20)    TYPE c             VALUE 'ENT1',                     " FCODE
            lc_devid_e095 TYPE zdevid        VALUE 'E095',                     " Development ID
            lc_doc_typ    TYPE rvari_vnam    VALUE 'AUART_REN_CONT',           " ABAP: Name of Variant Variable
            lc_param      TYPE rvari_vnam    VALUE 'AUART_FUTURE_QUOTE',
            lc_numbers(10) TYPE n            VALUE '0123456789',               " Numbers only "++ED2K921768
            lc_parvw      TYPE rvari_vnam    VALUE 'PARVW',                    " Partner function
            lc_cq         TYPE zactivity_sub VALUE 'CQ',                       " Create Quotation Activity
            lc_g          TYPE vbtyp         VALUE 'G',                        " SD document category : Contract
            lc_cr         TYPE trtyp         VALUE 'H',                        " Transaction type
            lc_ch         TYPE trtyp         VALUE 'V'.                        " Transaction type

* Declarations
DATA : lt_vbpa_vld       TYPE STANDARD TABLE OF lty_vbpa_vld,    " Internal table
       lt_vbkd_vld       TYPE STANDARD TABLE OF lty_vbkd_vld,    " Internal table
       lt_vbkd           TYPE STANDARD TABLE OF lty_vbkd,        " Internal table
       lt_vbak           TYPE STANDARD TABLE OF lty_vbak,        " Internal table
       lt_vbap           TYPE STANDARD TABLE OF lty_vbap,        " Internal table
       lt_vbeln          TYPE STANDARD TABLE OF lty_vbkd,        " Internal table
       li_constnt        TYPE zcat_constants,                    " Internal table
       ls_const          TYPE zcast_constant,                    " Work area
       li_quote          TYPE TABLE OF edm_auart_range,
       li_auart_rang     TYPE fip_t_auart_range,                 " Range Internal table : Sales Document type
       ls_auart_range    TYPE fip_s_auart_range,                 " Range Work Area : Sales Document type
       li_parvw_rang     TYPE shp_parvw_range_t,                 " Range Internal table : Partner function
       ls_vbkd           TYPE lty_vbkd,                          " Work area
       lv_bp_valid       TYPE c,                                 " BP at header is valid
       lv_potyp_valid    TYPE c,                                 " PO Type at header is valid
       lv_subrefid_valid TYPE c,                                 " Subrefid at item is valid
       lv_update         TYPE c,                                 " Check for updating in Renewal plan table
       lv_ret            TYPE c,                                 " User Pressed button
       lv_msge           TYPE string,                            " Popup message
       lv_bname          TYPE string,                            " BNAME String for comparison "++ED2K921768
       li_renewal_plan   TYPE STANDARD TABLE OF zqtc_renwl_plan, " Internal Table for Renewal Plan
       ls_renwl_plan     TYPE zqtc_renwl_plan,                   " Work area for Renewal Plan
       lv_vbap_vgbel_chk TYPE c.                                 " Check for reference in vbap # ED2K921590

REFRESH : lt_vbpa_vld, lt_vbkd_vld, lt_vbkd, lt_vbak, lt_vbap, lt_vbeln,
          li_constnt, li_auart_rang, li_renewal_plan.
CLEAR   : ls_const, ls_auart_range, ls_vbkd, lv_bp_valid, lv_potyp_valid,
          lv_subrefid_valid, lv_update, lv_ret, lv_msge, ls_renwl_plan,
          lv_vbap_vgbel_chk. " # ED2K921590

" Works only in foreground
IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e095
    IMPORTING
      ex_constants = li_constnt.
  IF li_constnt IS NOT INITIAL.
    LOOP AT li_constnt INTO ls_const.
      CASE ls_const-param1.
        WHEN lc_doc_typ. " ZREW, ZSUB
          ls_auart_range-sign = ls_const-sign.
          ls_auart_range-option = ls_const-opti.
          ls_auart_range-low = ls_const-low.
          APPEND ls_auart_range TO li_auart_rang.
          CLEAR : ls_auart_range, ls_const.
        WHEN lc_param. " ZSQT
          APPEND INITIAL LINE TO li_quote
              ASSIGNING FIELD-SYMBOL(<lst_quote>).
          <lst_quote>-sign   = ls_const-sign.
          <lst_quote>-option = ls_const-opti.
          <lst_quote>-low    = ls_const-low.
          <lst_quote>-high   = ls_const-high.
          CLEAR: ls_const.
        WHEN lc_parvw.
          APPEND INITIAL LINE TO li_parvw_rang
          ASSIGNING FIELD-SYMBOL(<lst_parvw>).
          <lst_parvw>-sign = ls_const-sign.
          <lst_parvw>-option = ls_const-opti.
          <lst_parvw>-low = ls_const-low.
          <lst_parvw>-high = ls_const-high.
          CLEAR: ls_const.
      ENDCASE. " IF lst_constant-param1 = lc_doc_typ
    ENDLOOP.
* Trigger Only for Quotes
    IF vbak-auart IN li_quote.
      " When the reference doucment is not filled
* Begin by AMOHAMMED on 01/28/2021 # ED2K921590
*      IF vbak-vgbel IS INITIAL.
* When the quotation is created manually reference document
*   is stored at header level
* When the quotation is created using autorenewal program
*   reference document is stored at item level
      LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lft_xvbap>) WHERE vgbel IS NOT INITIAL.
        lv_vbap_vgbel_chk = abap_true.
        EXIT.
      ENDLOOP.
      IF vbak-vgbel IS INITIAL AND
         lv_vbap_vgbel_chk IS INITIAL.
* End by AMOHAMMED on 01/28/2021 # ED2K921590
        " When the BNAME field is not filled with reference contract
*        IF vbak-bname IS INITIAL.                           "--ED2K921768
          " Display a message to fill the BNAME field
*          MESSAGE e572(zqtc_r2). " DISPLAY LIKE lc_er.      "--ED2K921768
        lv_bname = vbak-bname.                               "++ED2K921768
        IF vbak-bname IS INITIAL OR                          "++ED2K921768
           NOT ( lv_bname CO lc_numbers ).                   "++ED2K921768
          IF vbak-bname IS INITIAL.                          "++ED2K921768
            MESSAGE e572(zqtc_r2). " DISPLAY LIKE lc_er.     "++ED2K921768
          ELSEIF NOT ( lv_bname CO lc_numbers ).             "++ED2K921768
            " Only numbers should be allowed in BNAME.       "++ED2K921768
            MESSAGE e572(zqtc_r2). " DISPLAY LIKE lc_er.     "++ED2K921768
          ENDIF.                                             "++ED2K921768
          " This will display a message about the problem
          " or the reason for not saving the document
          PERFORM folge_gleichsetzen(saplv00f).
          fcode = lc_ent1.
          SET SCREEN syst-dynnr.
          LEAVE SCREEN.
          " When the BNAME field is filled with reference contract
        ELSE.
          IF t180-trtyp EQ lc_cr. " Creation Mode
            DATA(lv_doc) = vbak-bname.
          ELSEIF t180-trtyp EQ lc_ch. " Change Mode
            lv_doc = vbak-vbeln.
          ENDIF.
          IF lv_doc IS NOT INITIAL.
            " Fetch data from VBPA table based on BNAME field value / Quotation
            SELECT vbeln posnr parvw kunnr
              FROM vbpa
              INTO TABLE lt_vbpa_vld
              WHERE vbeln EQ lv_doc
                AND parvw IN li_parvw_rang.
            IF sy-subrc EQ 0.
              SORT lt_vbpa_vld BY posnr.
              LOOP AT lt_vbpa_vld INTO DATA(ls_vbpa_vld).
                READ TABLE xvbpa[] INTO DATA(ls_xvbpa)
                  WITH KEY posnr = lc_hdr
                           parvw = ls_vbpa_vld-parvw
                           kunnr = ls_vbpa_vld-kunnr.
                IF sy-subrc NE 0.
                  lv_bp_valid = abap_false.
                  EXIT.
                ELSE.
                  lv_bp_valid = abap_true.
                ENDIF.
              ENDLOOP.
              IF lv_bp_valid EQ abap_false.
                " Display informative popup message
                lv_msge = text-045.
                REPLACE '&1' IN lv_msge WITH vbak-bname.
                CALL FUNCTION 'POPUP_TO_CONFIRM'
                  EXPORTING
                    titlebar              = 'Order Data Validation'(039)
                    text_question         = lv_msge
                    text_button_1         = 'Accept'(026)
                    text_button_2         = 'Ignore'(027)
                    display_cancel_button = ' '
                    popup_type            = lc_inf " Information Icon
                  IMPORTING
                    answer                = lv_ret
                  EXCEPTIONS
                    text_not_found        = 1
                    OTHERS                = 2.
                IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
                  IF lv_ret EQ 1. " User pressed 'Accept' button
                    " This will stay on the same screen
                    " where the user was when clicking on 'Save'.
                    PERFORM folge_gleichsetzen(saplv00f).
                    fcode = lc_ent.
                    SET SCREEN syst-dynnr.
                    LEAVE SCREEN.
                  ELSEIF lv_ret EQ 2. " User pressed 'Ignore' button
                    lv_bp_valid = abap_true.
                  ENDIF. " IF lv_ret EQ 1.
                  CLEAR : lv_msge, lv_ret.
                ENDIF. " IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
              ENDIF.
            ENDIF.
            " Fetch data from VBKD table based on BNAME field value / Quotation
            SELECT vbeln posnr bstkd bsark ihrez ihrez_e
              FROM vbkd
              INTO TABLE lt_vbkd_vld
              WHERE vbeln EQ lv_doc.
            IF sy-subrc EQ 0.
              SORT lt_vbkd_vld BY posnr.
              DATA(lt_vbkd_tmp) = xvbkd[].
              SORT lt_vbkd_tmp BY posnr.

              " Validate the PO Type at header level
              " Read the header record
              READ TABLE lt_vbkd_tmp INTO DATA(ls_vbkd_hdr)
                WITH KEY posnr = lc_hdr.
              IF sy-subrc EQ 0.
                " Compare header record
                READ TABLE lt_vbkd_vld TRANSPORTING NO FIELDS
                  WITH KEY posnr = lc_hdr
                           bsark = ls_vbkd_hdr-bsark. " PO Type
                IF sy-subrc EQ 0.
                  lv_potyp_valid = abap_true.
                ELSE.
                  " Display informative popup message
                  lv_msge = text-044.
                  REPLACE '&1' IN lv_msge WITH vbak-bname.
                  CALL FUNCTION 'POPUP_TO_CONFIRM'
                    EXPORTING
                      titlebar              = 'Order Data Validation'(039)
                      text_question         = lv_msge
                      text_button_1         = 'Accept'(026)
                      text_button_2         = 'Ignore'(027)
                      display_cancel_button = ' '
                      popup_type            = lc_inf " Information Icon
                    IMPORTING
                      answer                = lv_ret
                    EXCEPTIONS
                      text_not_found        = 1
                      OTHERS                = 2.
                  IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
                    IF lv_ret EQ 1. " User pressed 'Accept' button
                      " This will stay on the same screen
                      " where the user was when clicking on 'Save'.
                      PERFORM folge_gleichsetzen(saplv00f).
                      fcode = lc_ent.
                      SET SCREEN syst-dynnr.
                      LEAVE SCREEN.
                    ELSEIF lv_ret EQ 2. " User pressed 'Ignore' button
                      lv_potyp_valid = abap_true.
                    ENDIF. " IF lv_ret EQ 1.
                    CLEAR : lv_msge, lv_ret.
                  ENDIF. " IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
                ENDIF.
              ENDIF.

              " Validate the PO Number, PO Type, Sub Ref ID, Ship-to party Your reference at item level
              " Delete the header record
              DELETE lt_vbkd_tmp WHERE posnr EQ lc_hdr.
              " Sort by item numbers
              SORT lt_vbkd_tmp BY posnr.
              " Read the first record
              READ TABLE lt_vbkd_tmp ASSIGNING FIELD-SYMBOL(<lfst_vbkd>) INDEX 1.
              IF sy-subrc EQ 0.
                READ TABLE lt_vbkd_vld TRANSPORTING NO FIELDS
                  WITH KEY bstkd   = <lfst_vbkd>-bstkd    " PO Number
                           bsark   = <lfst_vbkd>-bsark    " PO Type
                           ihrez   = <lfst_vbkd>-ihrez    " Your Reference (Sub Ref ID)
                           ihrez_e = <lfst_vbkd>-ihrez_e. " Your Reference (Ship-to party character).
                IF sy-subrc EQ 0.
                  lv_subrefid_valid = abap_true.
                ELSE.
                  " Display informative popup message
                  lv_msge = text-043.
                  REPLACE '&1' IN lv_msge WITH vbak-bname.
                  CALL FUNCTION 'POPUP_TO_CONFIRM'
                    EXPORTING
                      titlebar              = 'Order Data Validation'(039)
                      text_question         = lv_msge
                      text_button_1         = 'Accept'(026)
                      text_button_2         = 'Ignore'(027)
                      display_cancel_button = ' '
                      popup_type            = lc_inf " Information Icon
                    IMPORTING
                      answer                = lv_ret
                    EXCEPTIONS
                      text_not_found        = 1
                      OTHERS                = 2.
                  IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
                    IF lv_ret EQ 1. " User pressed 'Accept' button
                      " This will stay on the same screen
                      " where the user was when clicking on 'Save'.
                      PERFORM folge_gleichsetzen(saplv00f).
                      fcode = lc_ent.
                      SET SCREEN syst-dynnr.
                      LEAVE SCREEN.
                    ELSEIF lv_ret EQ 2. " User pressed 'Ignore' button
                      lv_subrefid_valid = abap_true.
                    ENDIF. " IF lv_ret EQ 1.
                    FREE : lv_msge, lv_ret.
                  ENDIF. " IF sy-subrc EQ 0 AND lv_ret IS NOT INITIAL.
                ENDIF.
              ENDIF.
            ENDIF. " IF sy-subrc EQ 0.
            IF t180-trtyp EQ lc_cr. " Creation Mode
              IF lv_bp_valid EQ abap_true AND
                 lv_potyp_valid EQ abap_true AND
                 lv_subrefid_valid EQ abap_true.
                lv_update = abap_true.
              ENDIF.
              IF lv_update EQ abap_true.
                " If document type is 'ZSUB' or 'ZREW'
                IF li_auart_rang IS NOT INITIAL.
                  " When SubRefID is filled
                  IF <lfst_vbkd>-ihrez IS NOT INITIAL.
                    " Fetch the document numbers based on SubRefID from VBKD table
                    SELECT vbeln
                      FROM vbkd
                      INTO TABLE lt_vbkd
                      WHERE ihrez EQ <lfst_vbkd>-ihrez.
                    IF sy-subrc EQ 0.
                      " Fetch the document numbers based on VBKD internal table from VBAK
                      SELECT vbeln erdat erzet
                        FROM vbak
                        INTO TABLE lt_vbak
                        FOR ALL ENTRIES IN lt_vbkd
                        WHERE vbeln EQ lt_vbkd-vbeln
                          AND vbtyp EQ lc_g
                          AND auart IN li_auart_rang.
                      IF sy-subrc EQ 0.
                        " Sort with latest document first
                        SORT lt_vbak BY erdat DESCENDING erzet DESCENDING.
                        " Read the latest document number
                        READ TABLE lt_vbak ASSIGNING FIELD-SYMBOL(<ls_vbak>) INDEX 1.
                        IF sy-subrc EQ 0.
                          " Fetch the item number of the document number
                          SELECT vbeln posnr
                            FROM vbap
                            INTO TABLE lt_vbap
                            WHERE vbeln EQ <ls_vbak>-vbeln.
                          IF sy-subrc EQ 0.
                            " Read the item number of the document number
                            READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>) INDEX 1.
                            IF sy-subrc EQ 0.
                              " Fetch the "CQ" record from the renewal plan table
                              SELECT SINGLE *
                                FROM zqtc_renwl_plan
                                INTO ls_renwl_plan
                                WHERE vbeln EQ <ls_vbap>-vbeln
                                  AND posnr EQ <ls_vbap>-posnr
                                  AND activity EQ lc_cq.
                              IF sy-subrc EQ 0.
                                " Update with Activity status and log
                                ls_renwl_plan-act_status = abap_true.       " Activity status
                                ls_renwl_plan-aedat      = sy-datum.        " System Date
                                ls_renwl_plan-aezet      = sy-uzeit.        " System Time
                                ls_renwl_plan-aenam      = sy-uname.        " User Name
                                APPEND ls_renwl_plan TO li_renewal_plan.
                                FREE ls_renwl_plan.
                                CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL' IN UPDATE TASK
                                  TABLES
                                    t_renwl_plan = li_renewal_plan.
                              ENDIF. " IF sy-subrc EQ 0.
                            ENDIF. " IF sy-subrc EQ 0.
                          ENDIF. " IF sy-subrc EQ 0.
                        ENDIF. "IF sy-subrc EQ 0.
                      ENDIF. " IF sy-subrc EQ 0.
                    ENDIF. " IF sy-subrc EQ 0.
                  ELSE.
                    " Display a message "SubRefID is Mandatory when quotation is created without reference"
                    MESSAGE e574(zqtc_r2).
                    " This will display a message about the problem
                    " or the reason for not saving the document
                    PERFORM folge_gleichsetzen(saplv00f).
                    fcode = lc_ent1.
                    SET SCREEN syst-dynnr.
                    LEAVE SCREEN.
                  ENDIF. " IF <lfst_vbkd>-ihrez IS NOT INITIAL.
                ENDIF. " IF li_auart_rang IS NOT INITIAL.
              ENDIF. " IF lv_update EQ abap_true.
            ENDIF. " IF t180-trtyp EQ lc_cr. " Creation Mode
          ENDIF. " IF lv_doc IS NOT INITIAL.
        ENDIF. " IF vbak-bname IS INITIAL.
      ENDIF. " IF vbak-vgbel IS INITIAL.
      FREE : lt_vbpa_vld, lt_vbkd_vld, lt_vbkd,
             lt_vbak, lt_vbap, lt_vbeln, li_constnt,
             li_auart_rang, li_renewal_plan, ls_const, ls_auart_range, ls_vbkd,
             lv_bp_valid, lv_potyp_valid, lv_subrefid_valid, lv_update, lv_doc.
    ENDIF. " vbak-auart IN li_quote.
  ENDIF. " IF li_constnt IS NOT INITIAL.
ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
