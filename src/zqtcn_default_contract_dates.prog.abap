*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DEFAULT_CONTRACT_DATES (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales doc business data workaerea VBKD
* DEVELOPER: Arpita Biswas
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903141
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906169
* REFERENCE NO: ERP-2852
* DEVELOPER: Anirban Saha (ANISAHA)
* DATE:  2017-06-19
* DESCRIPTION: Contract Dates are not being copied from BOM Header to
*              BOM Items
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906905
* REFERENCE NO: ERP-2852
* DEVELOPER: Anirban Saha (ANISAHA)
* DATE:  2017-06-26
* DESCRIPTION: Contract Dates can not be updated in CHANGE mode - it
*              results in an Update termination
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906905
* REFERENCE NO: ERP-2944
* DEVELOPER: Anirban Saha (ANISAHA)
* DATE:  2017-06-28
* DESCRIPTION: Contract Dates not getting changed based upon the
*              Subscription Type
*----------------------------------------------------------------------*
* REVISION NO: ED2K907156
* REFERENCE NO: ERP-2772
* DEVELOPER: Pavan Bandlapalli (PBANDLAPAL)
* DATE:  2017-07-07
* DESCRIPTION: When the contract dates are passed in conversion C064, C042
*              or interface(I230) same dates are not taken into consideration.
*              Issue is corrected now by not updating the rule when there
*              is a date.
*----------------------------------------------------------------------*
* REVISION NO: ED2K906915
* REFERENCE NO: ERP-3774
* DEVELOPER: Anirban Saha
* DATE:  2017-08-08
* DESCRIPTION: Contract Dates not getting changed based upon the
*              Subscription Type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908447
* REFERENCE NO: E106 - CR#591
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-09-10
* DESCRIPTION: Determine Volume Year Product
*----------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED1K907603
* REFERENCE NO:  INC0197849
* DEVELOPER: Monalisa Dutta
* DATE:  2018-06-06
* DESCRIPTION: Copying Subscription Type from ZSUB to ZSQT
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED1K909014
* REFERENCE NO:  RITM0089235 / INC0246088
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2018-12-05
* DESCRIPTION: Copying "Subscription Type" from Source Document
*              as of now only for ZREW
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K916533
* REFERENCE NO: PRB0044846
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2019-10-23
* DESCRIPTION: JKSESCHED not updating correctly because of incorrect
*              updation of VEDA entries
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO   : ED2K924248
* REFERENCE NO  : OTCM-37069
* DEVELOPER     : VDPATABALL
* DATE          :  08/04/2021
* DESCRIPTION   : MultiYear Contract Renewal:
*                 If original contract is multiyear or single year
*student member contract (Condition group 2=05), renewal contract should
*renew for only one year. Other than Student members any multiyear contract
*should renew as multiyear contract.
*-------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DEFAULT_CONTRACT_DATES
*&---------------------------------------------------------------------*
DATA:
  lst_veda_kopf TYPE veda,                                      "Contract Data
  lst_veda_pos  TYPE veda,                                      "Contract Data
  lst_veda_itm  TYPE veda,                                      "Contract Data
  lv_fkdat      TYPE vbkd-fkdat,
  lst_veda_init TYPE veda,                                      "Contract Data
  lst_veda_bom  TYPE vedavb,                                    "Contract Data
  lst_veda_hdr  TYPE vedavb.                                    "Contract Data
*        Begin of Change - ED2K916533 - NPALLA - 10/15/2019
DATA:
  lst_veda_vb_pos TYPE vedavb.                                  "Contract Data
*        End   of Change - ED2K916533 - NPALLA - 10/15/2019
DATA:
  lv_venddat         TYPE vndat_veda,                                "Contract end date
  lv_old_veda        TYPE char40  VALUE '(SAPLV45W)*VEDA',
  lv_bom_items       TYPE flag,                                      "Flag: BOM Items
  lv_prod_attr1      TYPE prat1,                                     "ID for product attribute 1
  lv_zzsubtyp        TYPE zsubtyp,                                   "Subscription Type ++; NPALLA; RITM0089235; ED1K909014
  lv_ref_auart       TYPE auart,                                     "Ref Doc Type ++VDPATABALL
  li_consts          TYPE STANDARD TABLE OF lty_constant,            "Internal table for Constant Table          ED1K909014
  lst_consts         TYPE lty_constant,                              " Workarea for ZCACONSTANT table            ED1K909014
  lst_auart          TYPE fssc_dp_s_rg_auart,                        " Workarea for auart                        ED1K909014
  lst_kdkg2          TYPE rjksd_mstav_range,    "Customer condition group 2 Work area "++VDPATABALL 08/04/2021 OTCM-37069 multi-year
  lv_kdkg2           TYPE vbkd-kdkg2,
  lv_active_006_e107 TYPE zactive_flag . " Active / Inactive Flag

STATICS:                                                        "                                           ED1K909014
  lr_auart         TYPE fssc_dp_t_rg_auart,                        "Internal table for auart                   ED1K909014
  lr_auart_ck      TYPE fssc_dp_t_rg_auart,
  lr_auart_qut_ref TYPE fssc_dp_t_rg_auart,
  lr_kdkg2         TYPE RANGE OF kdkg2.                        "Customer condition group 2 Range Table  "++VDPATABALL 08/04/2021 OTCM-37069 multi-year
CONSTANTS:
  lc_first_day    TYPE char4   VALUE '0101',                      "First Day of a Year
  lc_subtyp_cyr   TYPE zsubtyp VALUE '01',                        "Subscription Type: 01 - Calendar Year
  lc_devid_1      TYPE zdevid  VALUE 'E107',                      "Development ID                             ED1K909014
  lc_param1_1     TYPE rvari_vnam  VALUE 'AUART_CHECK',          "                                           ED1K909014
  lc_period       TYPE vlauf_veda  VALUE '001',                  "Validity period of contract
  lc_categry      TYPE vlauk_veda  VALUE '02',                   "Validity period category of contract
  lc_kdkg2        TYPE rvari_vnam  VALUE 'KDKG2',                  "Customer condition group 2 ""++VDPATABALL 08/04/2021 OTCM-37069 multi-year
  lc_sno_e107_006 TYPE zsno      VALUE '006',  "Serial Number
  lc_key_006_e107 TYPE zvar_key  VALUE 'MULTIYEAR'. "Var Key

FIELD-SYMBOLS:
  <lst_o_veda>  TYPE veda.

IF tvak-vterl  IS NOT INITIAL AND                               "Contract data allowed for sales order type
   vbap-posnr  IS NOT INITIAL.                                  "Sales Document Item

  IF call_bapi EQ abap_true OR
     sy-batch  EQ abap_true OR
     sy-binpt  EQ abap_true.
    CALL FUNCTION 'DIALOG_SET_NO_DIALOG'.
  ENDIF.

*-----Begin of Add-BTIRUVATHU-INC0246088-05.08.2019-ED1K909014
  IF lr_auart[] IS INITIAL
    OR lr_kdkg2[] IS INITIAL. "++VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
* Get data from constant table
    SELECT devid                       "Development ID
           param1                      "ABAP: Name of Variant Variable
           param2                      "ABAP: Name of Variant Variable
           sign                        "ABAP: ID: I/E (include/exclude values)
           opti                        "ABAP: Selection option (EQ/BT/CP/...)
           low                         "Lower Value of Selection Condition
           high                        "Upper Value of Selection Condition
      FROM zcaconstant                 "Wiley Application Constant Table
      INTO TABLE li_consts
      WHERE devid    = lc_devid_1
*        AND param1   = lc_param1_1 ""--VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
        AND activate = abap_true. "Only active record
    IF sy-subrc IS INITIAL.
      SORT li_consts BY devid param1.
    ENDIF.
    FREE:lr_auart_qut_ref,lr_auart_ck,lr_auart.
    LOOP AT li_consts INTO lst_consts.
*---BOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
      CASE lst_consts-param1.
        WHEN lc_param1_1.
          IF lst_consts-param2 = 'AUART' .
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO lr_auart_ck.
            CLEAR: lst_auart,
                   lst_consts.
          ELSE.
*---EOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO lr_auart.
            CLEAR: lst_auart,
                   lst_consts.
          ENDIF.
*---BOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
        WHEN lc_kdkg2.
          lst_kdkg2-sign   = lst_consts-sign.
          lst_kdkg2-option = lst_consts-opti.
          lst_kdkg2-low    = lst_consts-low.
          lst_kdkg2-high   = lst_consts-high.
          APPEND lst_kdkg2 TO lr_kdkg2.
          CLEAR: lst_kdkg2,
                 lst_consts.
        WHEN lc_auart.
          IF lst_consts-param2 = 'QUOTATION'.
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO lr_auart_qut_ref.
            CLEAR: lst_auart,
                   lst_consts.
          ENDIF.
      ENDCASE.
*---EOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
    ENDLOOP. " LOOP AT li_const INTO lst_const

  ENDIF.
*-----End of Add-BTIRUVATHU-INC0246088-05.08.2019-ED1K909014
  IF ( vbap-zzsubtyp EQ *vbap-zzsubtyp AND vbap-zzsubtyp IS INITIAL ) AND
   ( svbkd-tabix EQ 0 OR                                        "Create data
     vbap-matnr  NE *vbap-matnr ).                              "Material Number is changed

*   Check Higher-level item in bill of material structures
    IF vbap-uepos IS INITIAL.                                   "Not a BOM Component
      IF vbap-vgbel IS INITIAL. " Added by MODUTTA on 6th-Jun-2018:INC0197849:TR# ED1K907603
*       Product attribute check to find Subscription Type
        SELECT SINGLE prat1                                     "ID for product attribute 1
          FROM mvke
          INTO lv_prod_attr1
         WHERE matnr EQ vbap-matnr                              "Material Number
           AND vkorg EQ vbak-vkorg                              "Sales Organization
           AND vtweg EQ vbak-vtweg.                             "Distribution Channel
        IF sy-subrc EQ 0.
          IF lv_prod_attr1 EQ abap_true.                        "ID for product attribute 1 is checked
            vbap-zzsubtyp = lc_subtyp_cyr.                      "Subscription Type: 01 - Calendar Year
          ELSE.
            vbap-zzsubtyp = space.                              "Subscription Type: Blank - Rolling Calendar Year
          ENDIF.
        ENDIF.
*-----Begin of Add-NPALLA-RITM0089235/INC0246088-12.05.2018-ED1K909014
      ELSE.
        IF vbak-auart IN lr_auart.
          SELECT SINGLE zzsubtyp
            FROM vbap
            INTO lv_zzsubtyp
          WHERE vbeln = vbap-vgbel
            AND posnr = vbap-vgpos.
          IF sy-subrc = 0.
            vbap-zzsubtyp = lv_zzsubtyp.
          ENDIF.
*---BOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
          SELECT SINGLE auart
            FROM vbak
            INTO lv_ref_auart
          WHERE vbeln = vbap-vgbel.
*---EOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year
        ENDIF.
*-----End of Add-NPALLA-RITM0089235/INC0246088-12.05.2018-ED1K909014
      ENDIF." Added by MODUTTA on 6th-Jun-2018:INC0197849:TR# ED1K907603
    ELSE.                                                       "BOM Component
*     Find Out BOM Header Details
      READ TABLE xvbap ASSIGNING FIELD-SYMBOL(<lst_xvbap_e107>)
           WITH
         KEY vbeln = vbap-vbeln
                    posnr = vbap-uepos.
      IF sy-subrc EQ 0.
        vbap-zzsubtyp = <lst_xvbap_e107>-zzsubtyp.              "Subscription Type: From BOM Header
      ENDIF.

*     Fetch Contract Data
      CALL FUNCTION 'SD_VEDA_GET_DATA'
        IMPORTING
          es_veda = lst_veda_itm.                               "Contract Data

      IF lst_veda_itm-vposn EQ vbap-posnr.
        lst_veda_init = lst_veda_itm.
*       Read contract data (Header)
        CALL FUNCTION 'SD_VEDA_SELECT'
          EXPORTING
            i_document_number = vbap-vbeln                      "Contract Document Number
            i_item_number     = posnr_low                       "Item Number
            i_trtyp           = t180-trtyp                      "Transaction Type
          IMPORTING
            e_vedavb          = lst_veda_hdr.                   "Contract Data (Header)
*       Read contract data and keep it in internal structure
        CALL FUNCTION 'SD_VEDA_SELECT'
          EXPORTING
            i_document_number = vbap-vbeln                      "Contract Document Number
            i_item_number     = vbap-uepos                      "Item Number
            i_trtyp           = t180-trtyp                      "Transaction Type
          IMPORTING
            e_vedavb          = lst_veda_bom.                   "Contract Data (BOM Item)

        lst_veda_itm-vbegreg = lst_veda_bom-vbegreg.            "Date rule
        lst_veda_itm-vendreg = lst_veda_bom-vendreg.            "Date rule
        lst_veda_itm-vbegdat = lst_veda_bom-vbegdat.            "Contract Start Date
        lst_veda_itm-venddat = lst_veda_bom-venddat.            "Contract End Date
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
        lst_veda_itm-vlaufk = lst_veda_bom-vlaufk. "Validity period category of contract
        lst_veda_itm-vlaufz = lst_veda_bom-vlaufz. "Validity period of contract
        lst_veda_itm-vlauez = lst_veda_bom-vlauez. "Unit of validity period of contract
*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
        IF lst_veda_init NE lst_veda_itm.
          ASSIGN (lv_old_veda) TO <lst_o_veda>.
          IF sy-subrc EQ 0.
            MOVE-CORRESPONDING lst_veda_hdr TO <lst_o_veda>.
          ENDIF.
*         Update Contract Data
*-----Begin of delete-ANISAHA-Defect 2852-06.19.2017-ED2K906169
*          CALL FUNCTION 'SD_VEDA_MAINTAIN'
*            EXPORTING
*              i_veda = lst_veda_itm.
*-----End of delete-ANISAHA-Defect 2852-06.19.2017-ED2K906169
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

* Check Higher-level item in bill of material structures
  IF vbap-uepos IS INITIAL.
    IF vbap-zzsubtyp NE *vbap-zzsubtyp.                         "Subscription Type is changed
*     Fetch Contract Data
      CALL FUNCTION 'SD_VEDA_GET_DATA'
        IMPORTING
          es_veda = lst_veda_kopf.                              "Contract Data

      IF lst_veda_kopf-vposn EQ vbap-posnr.
        lst_veda_pos = lst_veda_kopf.                           "Contract Data
*-------Begin of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
        lst_veda_init = lst_veda_kopf.
*-------End   of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
        lst_veda_kopf-vposn       = posnr_low.                  "Acceptance Date (Header)

        IF vbap-zzsubtyp = lc_subtyp_cyr.                       "Subscription Type: 01 - Calendar Year
          lst_veda_pos-vbegdat+4(4) = lc_first_day.             "Contract Start Date (First Day of the Year)
*Begin of Add-Anirban-06.28.2017-ED2K906915-Defect 3774
          IF xvbak-vgtyp IS INITIAL.                            " If not created referencing a document
            lst_veda_pos-vbegdat+0(4) = sy-datum+0(4).            "Contract Start Date (First Day of the Year)
          ENDIF.
*End of Add-Anirban-06.28.2017-ED2K906915-Defect 3774
        ELSE.                                                   "Subscription Type: Blank - Rolling Calendar Year
          lst_veda_pos-vbegdat      = sy-datum.                 "Contract Start Date (Current Date)
        ENDIF.
        IF lst_veda_pos-vbegdat NE lst_veda_kopf-vbegdat.
          lst_veda_pos-vbegreg    = space.                      "Rule for calculating contract start date
        ENDIF.
*       Calculate Contract End Date
* Begin of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772
**Begin of Add-Anirban-06.28.2017-ED2K906915-Defect 2944
*        IF lst_veda_pos-vendreg IS INITIAL.
*          lst_veda_pos-vendreg = '08'.
*        ENDIF.
**End of Add-Anirban-06.28.2017-ED2K906915-Defect 2944
        IF lst_veda_pos-vendreg IS NOT INITIAL.
* End of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772
          CALL FUNCTION 'SD_VEDA_GET_DATE'
            EXPORTING
              i_regel                    = lst_veda_pos-vendreg   "Date rule
              i_veda_kopf                = lst_veda_kopf          "Acceptance date
              i_veda_pos                 = lst_veda_pos           "Contract Start Date
            IMPORTING
              e_datum                    = lv_venddat             "Target date
            EXCEPTIONS
              basedate_and_cal_not_found = 1
              basedate_is_initial        = 2
              basedate_not_found         = 3
              cal_error                  = 4
              rule_not_found             = 5
              timeframe_not_found        = 6
              wrong_month_rule           = 7
              OTHERS                     = 8.
          IF sy-subrc EQ 0.
            lst_veda_pos-venddat = lv_venddat.                    "Contract End Date
          ENDIF.
* Begin of Insert by PBNADLAPAL on 11-Jul-2017 for ERP-2772
        ENDIF.
* End of Insert by PBNADLAPAL on 11-Jul-2017 for ERP-2772
*-------Begin of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
        ASSIGN (lv_old_veda) TO <lst_o_veda>.
        IF sy-subrc EQ 0.
          IF t180-trtyp = charv.
            MOVE-CORRESPONDING lst_veda_init TO <lst_o_veda>.
          ENDIF.
        ENDIF.
*-------End   of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
*       Update Contract Data
        CALL FUNCTION 'SD_VEDA_MAINTAIN'
          EXPORTING
            i_veda = lst_veda_pos.
      ENDIF.

    ENDIF.

    CLEAR: lv_bom_items.
*   Process BOM Line Items
    LOOP AT xvbap ASSIGNING <lst_xvbap_e107> WHERE uepos EQ vbap-posnr.
      IF lv_bom_items IS INITIAL AND
         lst_veda_pos IS INITIAL.
*------- Begin of Change - ED2K916533 - NPALLA - 10/23/2019
**       Fetch Contract Data
*        CALL FUNCTION 'SD_VEDA_GET_DATA'
*          IMPORTING
*            es_veda = lst_veda_pos.                             "Contract Data
*        IF lst_veda_pos-vposn NE vbap-posnr.
*          EXIT.
*        ENDIF.
**      Read Contract Data
        CALL FUNCTION 'SD_VEDA_SELECT'
          EXPORTING
            i_document_number = vbap-vbeln                        "Contract Document Number
            i_item_number     = vbap-posnr                        "Item Number
            i_trtyp           = t180-trtyp                        "Transaction Type
          IMPORTING
            e_vedavb          = lst_veda_vb_pos.                     "Contract Data
        IF lst_veda_vb_pos IS INITIAL.
          EXIT.
        ELSE.
          MOVE-CORRESPONDING lst_veda_vb_pos TO lst_veda_pos.
        ENDIF.
*------- End of Change - ED2K916533 - NPALLA - 10/23/2019
      ENDIF.
      lv_bom_items = abap_true.                                 "Flag: BOM Item exists

      IF <lst_xvbap_e107>-updkz IS INITIAL.
        yvbap = <lst_xvbap_e107>.
        APPEND yvbap.
        <lst_xvbap_e107>-updkz  = updkz_update.                 "Update Indicator
      ENDIF.
      <lst_xvbap_e107>-zzsubtyp = vbap-zzsubtyp.                "Subscription Type

      CLEAR: lst_veda_bom,
             lst_veda_itm,
             lst_veda_hdr.
*     Read contract data (Header)
      CALL FUNCTION 'SD_VEDA_SELECT'
        EXPORTING
          i_document_number = vbap-vbeln                        "Contract Document Number
          i_item_number     = posnr_low                         "Item Number
          i_trtyp           = t180-trtyp                        "Transaction Type
        IMPORTING
          e_vedavb          = lst_veda_hdr.                     "Contract Data (Header)
*     Read contract data and keep it in internal structure
      CALL FUNCTION 'SD_VEDA_SELECT'
        EXPORTING
          i_document_number = <lst_xvbap_e107>-vbeln            "Contract Document Number
          i_item_number     = <lst_xvbap_e107>-posnr            "Item Number
          i_trtyp           = t180-trtyp                        "Transaction Type
        IMPORTING
          e_vedavb          = lst_veda_bom.                     "Contract Data (BOM Item)

      MOVE-CORRESPONDING lst_veda_bom TO lst_veda_itm.
      lst_veda_init = lst_veda_itm.
      lst_veda_itm-vbegreg = lst_veda_pos-vbegreg.              "Date rule
      lst_veda_itm-vendreg = lst_veda_pos-vendreg.              "Date rule
      lst_veda_itm-vbegdat = lst_veda_pos-vbegdat.              "Contract Start Date
      lst_veda_itm-venddat = lst_veda_pos-venddat.              "Contract End Date
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
      lst_veda_itm-vlaufk = lst_veda_pos-vlaufk. "Validity period category of contract
      lst_veda_itm-vlaufz = lst_veda_pos-vlaufz. "Validity period of contract
      lst_veda_itm-vlauez = lst_veda_pos-vlauez. "Unit of validity period of contract
*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years

      IF lst_veda_init NE lst_veda_itm.
        ASSIGN (lv_old_veda) TO <lst_o_veda>.
        IF sy-subrc EQ 0.
*---------Begin of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
          IF t180-trtyp = charh.
*---------End   of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
            MOVE-CORRESPONDING lst_veda_hdr TO <lst_o_veda>.
*---------Begin of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
          ELSE.
            MOVE-CORRESPONDING lst_veda_init TO <lst_o_veda>.
          ENDIF.
*---------End   of add-ANISAHA-Defect 2852-06.26.2017-ED2K906905
        ENDIF.
*       Update Contract Data
        CALL FUNCTION 'SD_VEDA_MAINTAIN'
          EXPORTING
            i_veda = lst_veda_itm.                              "Contract Data (BOM Item)
*       Begin of ADD:CR#591:WROY:10-SEP-2017:ED2K908447
*       Determine Volume Year Product
        PERFORM zz_determine_volume_year IN PROGRAM sapmv45a IF FOUND
          USING vbak-vbtyp                                      "Document Category
                <lst_xvbap_e107>-pstyv                          "Item Category
                <lst_xvbap_e107>-matnr                          "Media Product
                lst_veda_itm-vbegdat                            "Contract Start Date
                lst_veda_itm-venddat                            "Contract End Date
       CHANGING <lst_xvbap_e107>-zzvyp.                         "Volume Year Product
*       End   of ADD:CR#591:WROY:10-SEP-2017:ED2K908447
      ENDIF.
    ENDLOOP.

    IF lv_bom_items IS NOT INITIAL.
*     Read contract data and keep it in internal structure
      CALL FUNCTION 'SD_VEDA_SELECT'
        EXPORTING
          i_document_number = vbap-vbeln                        "Contract Document Number
          i_item_number     = vbap-posnr                        "Item Number
          i_trtyp           = t180-trtyp                        "Transaction Type
        IMPORTING
          e_vedavb          = lst_veda_bom.                     "Contract Data
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
    ELSE.
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_devid_1
          im_ser_num     = lc_sno_e107_006
          im_var_key     = lc_key_006_e107
        IMPORTING
          ex_active_flag = lv_active_006_e107.
      IF lv_active_006_e107 = abap_true.
* check higher-level item in bill of material structures
        IF ( vbap-zzsubtyp EQ *vbap-zzsubtyp  ) AND
           ( svbkd-tabix EQ 0 OR                                        "Create data
             vbap-matnr  NE *vbap-matnr ).                              "Material Number is changed

          IF vbap-uepos IS INITIAL AND vbap-vgbel IS NOT INITIAL.
            IF vbak-auart IN lr_auart.
              SELECT SINGLE zzsubtyp
                FROM vbap
                INTO lv_zzsubtyp
              WHERE vbeln = vbap-vgbel
                AND posnr = vbap-vgpos.
              IF sy-subrc = 0.
                vbap-zzsubtyp = lv_zzsubtyp.
              ENDIF.
              IF lv_ref_auart IS INITIAL.
                SELECT SINGLE auart
                  FROM vbak
                  INTO lv_ref_auart
                WHERE vbeln = vbap-vgbel.
              ENDIF.
            ENDIF.

            IF lv_ref_auart IN lr_auart_ck.
              IF vbak-auart IN lr_auart.
*     Fetch Contract Data
                CALL FUNCTION 'SD_VEDA_GET_DATA'
                  IMPORTING
                    es_veda = lst_veda_kopf.                              "Contract Data

                IF lst_veda_kopf-vposn EQ vbap-posnr.
                  lst_veda_pos = lst_veda_kopf.                           "Contract Data

*       Calculate Contract End Date
                  IF lst_veda_pos-vendreg IS NOT INITIAL.
                    IF vbkd-kdkg2 IN lr_kdkg2." '05'  For student member renewal
                      lst_veda_pos-vlaufz = lc_period ."'001'.
                      lst_veda_pos-vlaufk = lc_categry."'02'.
                    ENDIF.

                    CALL FUNCTION 'SD_VEDA_GET_DATE'
                      EXPORTING
                        i_regel                    = lst_veda_pos-vendreg   "Date rule
                        i_veda_kopf                = lst_veda_kopf          "Acceptance date
                        i_veda_pos                 = lst_veda_pos           "Contract Start Date
                      IMPORTING
                        e_datum                    = lv_venddat             "Target date
                      EXCEPTIONS
                        basedate_and_cal_not_found = 1
                        basedate_is_initial        = 2
                        basedate_not_found         = 3
                        cal_error                  = 4
                        rule_not_found             = 5
                        timeframe_not_found        = 6
                        wrong_month_rule           = 7
                        OTHERS                     = 8.
                    IF sy-subrc EQ 0.
                      lst_veda_pos-venddat = lv_venddat.                    "Contract End Date
                      IF lst_veda_pos-vbegdat NE sy-datum.
                        CLEAR:lst_veda_pos-vbegreg.
                      ENDIF.
                    ENDIF.
                  ENDIF.

                  ASSIGN (lv_old_veda) TO <lst_o_veda>.
                  IF sy-subrc EQ 0.
                    IF t180-trtyp = charv.
                      MOVE-CORRESPONDING lst_veda_init TO <lst_o_veda>.
                    ENDIF.
                  ENDIF.
*       Update Contract Data
                  CALL FUNCTION 'SD_VEDA_MAINTAIN'
                    EXPORTING
                      i_veda = lst_veda_pos.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF. " IF lv_active_006_e107 = abap_true.

*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years

    ENDIF.
  ENDIF.
ENDIF.
