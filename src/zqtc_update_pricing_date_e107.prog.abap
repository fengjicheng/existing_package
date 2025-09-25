*&---------------------------------------------------------------------*
*&  Include  ZQTC_UPDATE_PRICING_DATE_E107
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_UPDATE_PRICING_DATE_E107 (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Pricing date update with contract start date
* DEVELOPER: Prabhu(PTUFARAM)O
* CREATION DATE: 05/10/2021
* OBJECT ID: E107 - OTCM-37740
* TRANSPORT NUMBER(S): ED2K923359
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO   : ED2K924288
* REFERENCE NO  : OTCM-49901
* DEVELOPER     : VDPATABALL
* DATE          : 08/10/2021
* DESCRIPTION   : Pricing dates are determining same as contract start
*date in Quotation/ Contract at item level
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO   : ED2K924925
* REFERENCE NO  : OTCM-54031
* DEVELOPER     : VDPATABALL
* DATE          : 08/11/2021
* DESCRIPTION   : If user is going to change mode then Header price
* should not be change.
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* DEVELOPER:
* DATE:
* TRANSPORT NUMBER(S):
* DESCRIPTION: *
*&---------------------------------------------------------------------*

TYPES:BEGIN OF ty_uepos,
        posnr TYPE posnr,
        matnr TYPE matnr,
        uepos TYPE posnr,
      END OF ty_uepos.
STATICS:lr_auart_e107 TYPE fssc_dp_t_rg_auart,
        lr_auart_ref  TYPE fssc_dp_t_rg_auart,
        lr_auart_qut  TYPE fssc_dp_t_rg_auart,
        lv_flag_ctoc  TYPE char1,
        lv_flag_cquot TYPE char1,
        li_uepos      TYPE STANDARD TABLE OF ty_uepos,
        lv_uepos_cnt  TYPE i.
DATA:lv_auart_ref  TYPE auart.

CONSTANTS : lc_devid_e107   TYPE zdevid       VALUE 'E107',   "  Development ID
            lc_param1_e107  TYPE rvari_vnam   VALUE 'AUART_PRICING_DATE',  "Name of Variant Variable
            lc_header_item  TYPE posnr        VALUE '000000',
            lc_createmd     TYPE t180-trtyp   VALUE 'H',       "Create Mode
            lc_changemd     TYPE t180-trtyp   VALUE 'V',       "Change Mode
            lc_sno_e107_005 TYPE zsno         VALUE '005',  "Serial Number
            lc_key_005_e107 TYPE zvar_key     VALUE 'PRSDT'. "Var Key

DATA: lst_veda_data      TYPE veda,
      lv_flag_ok         TYPE c,
      lv_active_005_e107 TYPE zactive_flag . " Active / Inactive Flag


IF t180-trtyp = lc_createmd OR t180-trtyp = lc_changemd.
*FM is Retrieve the all sales document types from zcaconstant table for E107
*----BOC of VDPATABALL 10/04/2021 OTCM-49901:Tech Spike for OTCM-37740 Pricing Date

**  IF lv_doc_type_e107 IS INITIAL. "Check static Variable
**     CALL FUNCTION 'ZQTC_CONTRACT_TYPE_DETERMINE'
**       EXPORTING
**         im_objectid    = lc_devid_e107
**         im_param1      = lc_param1_e107
**         im_auart       = vbak-auart
**       IMPORTING
**         ex_active_flag = lv_flag_ok.
**     IF lv_flag_ok EQ abap_true.
**       lv_doc_type_e107 = vbak-auart.
**     ENDIF.
*----Get constant Entries
  IF lr_auart_e107 IS INITIAL
    OR lr_auart_ref IS INITIAL
    OR lr_auart_qut IS INITIAL.
    CALL METHOD zca_utilities=>get_constants
      EXPORTING
        im_devid     = lc_devid_e107            "E107
      IMPORTING
        et_constants = DATA(li_const_auart).          "Constant Values
*    DELETE li_const_auart WHERE  param1 NE lc_param1_e107.
    LOOP AT li_const_auart INTO DATA(lst_const_auart) .
      CASE lst_const_auart-param1.
        WHEN lc_param1_e107.
          lst_auart-sign   = lst_const_auart-sign.
          lst_auart-option = lst_const_auart-opti.
          lst_auart-low    = lst_const_auart-low.
          lst_auart-high   = lst_const_auart-high.
          APPEND lst_auart TO lr_auart_e107[].
          CLEAR: lst_auart,
                 lst_const_auart.
        WHEN lc_param1_1.
          IF lst_const_auart-param2 = 'AUART' .
            lst_auart-sign   = lst_const_auart-sign.
            lst_auart-option = lst_const_auart-opti.
            lst_auart-low    = lst_const_auart-low.
            lst_auart-high   = lst_const_auart-high.
            APPEND lst_auart TO lr_auart_ref.
            CLEAR: lst_auart,
                   lst_const_auart.
          ENDIF.
        WHEN lc_auart.
          IF lst_const_auart-param2 = 'QUOTATION' .
            CLEAR: lst_auart.
            lst_auart-sign   = lst_const_auart-sign.
            lst_auart-option = lst_const_auart-opti.
            lst_auart-low    = lst_const_auart-low.
            lst_auart-high   = lst_const_auart-high.
            APPEND lst_auart TO lr_auart_qut.
            CLEAR: lst_auart,
                   lst_const_auart.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF. "IF lr_auart_e107 IS NOT INITIAL.

  IF vbak-auart IN lr_auart_e107[].

*--As per new Logic Price date should be contract start or User entered date
*---If Quote to Contract ZQT ->ZSUB/ZSQT->ZREW same Quotation date has to populate in Contract
*---if Contract to Contract ZSUB->ZREW price date should be Contract start date or User Date.
*---If the below Enhancement Flag is active then it will execute above points logic otherwise
*--- (deactive) means existing production old logic
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_devid_e107
        im_ser_num     = lc_sno_e107_005
        im_var_key     = lc_key_005_e107
      IMPORTING
        ex_active_flag = lv_active_005_e107.

    IF lv_active_005_e107 = abap_true.
**      read contract data
      CALL FUNCTION 'SD_VEDA_SELECT'
        EXPORTING
          i_document_number = vbap-vbeln                        "Contract Document Number
          i_item_number     = vbap-posnr                        "Item Number
          i_trtyp           = t180-trtyp                        "Transaction Type
        IMPORTING
          e_vedavb          = lst_veda_vb_pos.                     "Contract Data

**      ENDIF.
**      IF lv_doc_type_e107 IS NOT INITIAL.
*  Fetch Contract Data
**    CALL FUNCTION 'SD_VEDA_GET_DATA'
**      IMPORTING
**        es_veda = lst_veda_data.
*--*Update item pricing date with Contract start date at Item level
      IF  call_bapi = abap_false.
        CLEAR:lv_auart_ref.
        SELECT SINGLE auart
          FROM vbak
          INTO lv_auart_ref
          WHERE vbeln = vbap-vgbel.
*----Quotation Creation with Refence of Contracts
        IF lv_auart_ref IN lr_auart_ref.
          IF *vbkd-prsdt  NE vbkd-prsdt
            AND lst_veda_vb_pos-vposn EQ lc_header_item.
          ELSE.
**      IF lst_veda_data-vbegdat NE vbkd-prsdt
*----EOC of VDPATABALL 10/04/2021 OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
            IF lst_veda_vb_pos-vbegdat NE *veda-vbegdat
              AND lst_veda_vb_pos-vposn NE lc_header_item
              OR vbkd-prsdt IS INITIAL ""++VDPATABALL 10/04/2021 OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
              OR lst_veda_vb_pos-vbegdat EQ vbkd-prsdt. "++VDPATABALL 10/04/2021 OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
              vbkd-prsdt = lst_veda_vb_pos-vbegdat.
            ENDIF.
          ENDIF. "IF *vbkd-prsdt  NE vbkd-prsdt
*----Contract Creation with Refence of Contracts
          IF vbak-auart IN lr_auart_ref
              AND lv_auart_ref IN lr_auart_ref
             AND t180-trtyp = lc_createmd.
            IF lv_flag_ctoc = abap_false AND vbap-uepos IS INITIAL.
              IF li_uepos IS INITIAL.
                SELECT posnr matnr uepos FROM vbap INTO TABLE li_uepos WHERE vbeln = vbap-vgbel.
                IF sy-subrc = 0.
                  SORT li_uepos BY uepos.
                  DELETE li_uepos WHERE uepos IS NOT INITIAL.
                  FREE:lv_uepos_cnt.
                  DESCRIBE TABLE li_uepos LINES lv_uepos_cnt.
                  SORT li_uepos BY posnr.
                ENDIF.
              ENDIF.
              READ TABLE li_uepos INTO DATA(lst_uepos) INDEX lv_uepos_cnt.
              IF lst_veda_vb_pos-vbegdat  = *veda-vbegdat
                AND *vbkd-prsdt NE *veda-vbegdat
                AND  vbkd-prsdt NE  lst_veda_vb_pos-vbegdat."veda-vbegdat.
                IF vbap-posnr IS NOT INITIAL.
                  vbkd-prsdt =   veda-vbegdat.
                  IF lst_uepos-posnr  = vbap-posnr .
                    lv_flag_ctoc = abap_true.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

*-----ZSUB->ZREW->ZRSQT ( Manual Payment )
          IF vbak-auart IN lr_auart_qut
            AND lv_auart_ref IN lr_auart_ref
             AND t180-trtyp = lc_createmd
            AND vbap-vgbel IS NOT INITIAL
            AND vbap-uepos IS INITIAL.
            IF lv_flag_cquot = abap_false AND  vbap-uepos IS INITIAL.
              IF li_uepos IS INITIAL.
                SELECT posnr matnr uepos FROM vbap INTO TABLE li_uepos WHERE vbeln = vbap-vgbel.
                IF sy-subrc = 0.
                  SORT li_uepos BY uepos.
                  DELETE li_uepos WHERE uepos IS NOT INITIAL.
                  FREE:lv_uepos_cnt.
                  DESCRIBE TABLE li_uepos LINES lv_uepos_cnt.
                  SORT li_uepos BY posnr.
                ENDIF.
              ENDIF.
              CLEAR:lst_uepos.
              READ TABLE li_uepos INTO lst_uepos INDEX lv_uepos_cnt.
              IF vbap-zzsubtyp NE lc_subtyp_cyr.
                IF vbkd-prsdt <> *vbkd-prsdt
                  AND *vbkd-prsdt <> *veda-vbegdat
                  AND *veda-vbegdat = veda-vbegdat .
                  vbkd-prsdt =   veda-vbegdat.
                  IF lst_uepos-posnr  = vbap-posnr .
                    lv_flag_cquot = abap_true.
                  ENDIF.
                ELSEIF  vbap-zzsubtyp = lc_subtyp_cyr.
                  IF vbkd-prsdt = *vbkd-prsdt
                    AND vbkd-prsdt NE veda-vbegdat.
                    vbkd-prsdt =   veda-vbegdat.
                    IF lst_uepos-posnr  = vbap-posnr .
                      lv_flag_cquot = abap_true.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

*----Contract/Quotation Creation without Refence of
        ELSEIF vbap-vgbel IS INITIAL
          AND lv_auart_ref IS INITIAL. "IF lv_auart_ref IN lr_auart_ref."Without of reference
          IF *vbkd-prsdt  NE vbkd-prsdt
          AND lst_veda_vb_pos-vposn EQ vbap-posnr.
*            vbkd-prsdt = lst_veda_vb_pos-vbegdat.
          ELSE.
            IF t180-trtyp = lc_createmd
              OR ( t180-trtyp =  lc_changemd AND vbkd-posnr NE lc_header_item )."++VDPATABALL OTCM-54031 ED2K924925  Header check 11/08/2021
              IF vbap-zzsubtyp NE lc_subtyp_cyr.
                IF ( vbkd-prsdt = *vbkd-prsdt AND   " PRSDT nicht von Hand
                  veda-vbegdat <> *veda-vbegdat AND " VBEGDAT wurde geändert
                   vbkd-prsdt <> *veda-vbegdat ).
                  IF vbkd-posnr IS NOT INITIAL.
                    vbkd-prsdt =   veda-vbegdat.
                  ENDIF.
                ENDIF.
              ELSE.
                IF lst_veda_vb_pos-vbegdat NE *veda-vbegdat
                  AND lst_veda_vb_pos-vposn NE lc_header_item
                  OR vbkd-prsdt IS INITIAL
                  OR lst_veda_vb_pos-vbegdat EQ vbkd-prsdt.
                  vbkd-prsdt = lst_veda_vb_pos-vbegdat.
                ENDIF.
              ENDIF.
            ENDIF. ""++VDPATABALL OTCM-54031 ED2K924925  Header check 11/08/2021
          ENDIF. "IF *vbkd-prsdt  NE vbkd-prsdt
*----Contract creation with Refernce Quotation and Price date is equal to System date scenario
        ELSEIF vbap-vgbel IS NOT INITIAL
           AND lv_auart_ref IN lr_auart_qut.
          IF lst_veda_vb_pos-vbegdat NE *veda-vbegdat
          AND t180-trtyp = lc_createmd.
            CLEAR:*vbkd-prsdt.
          ELSEIF ( vbkd-prsdt = *vbkd-prsdt AND   " PRSDT nicht von Hand
              veda-vbegdat <> *veda-vbegdat AND " VBEGDAT wurde geändert
               vbkd-prsdt <> *veda-vbegdat ).
            IF vbkd-posnr IS NOT INITIAL.
              vbkd-prsdt =   veda-vbegdat.
            ENDIF.
          ENDIF.
        ENDIF. "IF lv_auart_ref IN lr_auart_ref. "++VDPATABALL 10/04/2021OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
      ENDIF. "++VDPATABALL 10/04/2021OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
    ELSE.

      "Existing Cin Production
      CALL FUNCTION 'SD_VEDA_GET_DATA'
        IMPORTING
          es_veda = lst_veda_data.
*--*Update item pricing date with Contract start date at Item level
      IF lst_veda_data-vbegdat NE vbkd-prsdt AND lst_veda_data-vposn NE lc_header_item.
        vbkd-prsdt = lst_veda_data-vbegdat.
      ENDIF.
    ENDIF. "IF lv_active_005_e107 = abap_true.

  ENDIF. "++VDPATABALL 10/04/2021 OTCM-49901:Tech Spike for OTCM-37740 Pricing Date
ENDIF.
