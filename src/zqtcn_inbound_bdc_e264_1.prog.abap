*----------------------------------------------------------------------*
* Program Name : ZQTCN_INBOUND_BDC_E264_1                              *
* REVISION NO : ED2K922541                                             *
* REFERENCE NO: OTCM-23859                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 03/14/2021                                             *
* DESCRIPTION : SAP/Kiara Intergration mapping the registration code   *
*----------------------------------------------------------------------*
TYPES: BEGIN OF lty_xvbap_e264_1. "Position
         INCLUDE STRUCTURE vbap. " Sales Document: Item Data
         TYPES:  matnr_output(40) TYPE c. " Output(40) of type Character
TYPES:  wmeng(18) TYPE c. " Types: wmeng(18) of type Character
TYPES:  lfdat LIKE vbap-abdat. " Reconciliation Date for Agreed Cumulative Quantity
TYPES:  kschl LIKE komv-kschl. " Condition type
TYPES:  kbtrg(16) TYPE c. " Types: kbtrg(16) of type Character
TYPES:  kschl_netwr LIKE komv-kschl. " Condition type
TYPES:  kbtrg_netwr(16) TYPE c. " Netwr(16) of type Character
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms 3_L
TYPES:  incov LIKE vbkd-incov. "Incoterms v
TYPES:  yantlf(1) TYPE c. " Types: yantlf(1) of type Character
TYPES:  prsdt LIKE vbkd-prsdt. " Date for pricing and exchange rate
TYPES:  hprsfd LIKE tvap-prsfd. " Carry out pricing
TYPES:  bstkd_e LIKE vbkd-bstkd_e. " Ship-to Party's Purchase Order Number
TYPES:  bstdk_e LIKE vbkd-bstdk_e. " Ship-to party's PO date
TYPES:  bsark_e LIKE vbkd-bsark_e. " Ship-to party purchase order type
TYPES:  ihrez_e LIKE vbkd-ihrez_e. " Ship-to party character
TYPES:  posex_e LIKE vbkd-posex_e. " Item Number of the Underlying Purchase Order
TYPES:  lpnnr LIKE vbak-vbeln. " Sales Document
TYPES:  empst LIKE vbkd-empst. " Receiving point
TYPES:  ablad LIKE vbpa-ablad. " Unloading Point
TYPES:  knref LIKE vbpa-knref. " Customer description of partner (plant, storage location)
TYPES:  lpnnr_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  kdkg1 LIKE vbkd-kdkg1. " Customer condition group 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. " Customer condition group 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. " Customer condition group 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. " Customer condition group 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. " Customer condition group 5
TYPES:  abtnr LIKE vbkd-abtnr. " Department number
TYPES:  delco LIKE vbkd-delco. " Agreed delivery time
TYPES:  angbt LIKE vbak-vbeln. " Sales Document
TYPES:  angbt_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  contk LIKE vbak-vbeln. " Sales Document
TYPES:  contk_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  angbt_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  angbt_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order
TYPES:  contk_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  contk_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order

*- positionen ---------------------------------------------------------*
*- external config-id to set fcode 'POUP' on sub-item level ----*
TYPES:  config_id LIKE e1curef-config_id. " External Configuration ID (Temporary)
*- Instanznummer der Konfiguaration zum Setzen des FCODES 'POUP' bei --*
*- Unterpositionen ----------------------------------------------------*
*- instancenumber of the configuration to set fcode 'POUP' on sub-item *
*- level --------------------------------------------------------------*
TYPES:  inst_id LIKE e1curef-inst_id. " Instance Number in Configuration
TYPES:  kompp LIKE tvap-kompp. " Form delivery group and correlate BOM components
TYPES:  currdec LIKE tcurx-currdec. " Number of decimal places
TYPES:  curcy LIKE e1edp01-curcy. " Currency
TYPES:  valdt LIKE vbkd-valdt. " Fixed value date
TYPES:  valtg LIKE vbkd-valtg. " Additional value days
*- Flag  -------------------------------------------*
*- internal field additional ------------------------------------------*
TYPES:  vaddi(1) TYPE c. " Types: vaddi(1) of type Character
*- ARM Advanced Returns -----------------------------------------------*
TYPES: returns_reason     TYPE bezei40, " Description
       replace_request(1) TYPE c.       " Request(1) of type Character
TYPES: END OF lty_xvbap_e264_1.


TYPES : BEGIN OF ty_ismpubltype,        " Publication type
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE ismpubltype,
          high TYPE ismpubltype,
        END OF ty_ismpubltype.

DATA: lir_pubtype         TYPE RANGE OF mara-ismpubltype,  " Publication type
      lst_pubtype         TYPE ty_ismpubltype,
      li_vbap_e264_1      TYPE STANDARD TABLE OF lty_xvbap_e264_1 INITIAL SIZE 0,
      lst_vbap_e264_1     TYPE lty_xvbap_e264_1,
      lst_bdcdata_e264_1  LIKE LINE OF  bdcdata,          " Batch input: New table field structure
      li_dxbdcdata_e264_1 TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0, " Batch input: New table field structure
      lst_edidd_e264_1    TYPE edidd,
      lv_tabx_e264_1      TYPE sy-tabix,
      lst_ze1edp01_e264_1 TYPE z1qtc_e1edp01_01,
      lv_pos_e264_1       TYPE char6,
      lv_selkz1_e264_1    TYPE char19.

STATICS : lv_posnr_e264_1  TYPE char6,
          lv_posval_e264_1 TYPE posnr,
          lv_docnum_e264_1 TYPE edi_docnum.

CONSTANTS : lc_devid           TYPE zdevid     VALUE 'E264',              " WRICEF ID
            lc_ismpubltype     TYPE rvari_vnam VALUE 'ISMPUBLTYPE',       " Publication type
            lc_ze1edp01_e264_1 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01'.  " Line Item Extended fields

SELECT devid,
       param1,
       param2,
       srno,
       sign,
       opti,
       low ,
       high,
       activate
   FROM zcaconstant
   INTO TABLE @DATA(li_constant)
   WHERE devid    = @lc_devid         " WRICEF ID
   AND   activate = @abap_true.       " Only active record
IF sy-subrc IS INITIAL.
  SORT li_constant BY param1.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_ismpubltype.
        lst_pubtype-sign   = <lfs_constant>-sign.
        lst_pubtype-opti   = <lfs_constant>-opti.
        lst_pubtype-low    = <lfs_constant>-low.
        lst_pubtype-high   = <lfs_constant>-high..
        APPEND lst_pubtype TO lir_pubtype.
        CLEAR lst_pubtype.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

" Line Item assign to local variable for further processing
CLEAR lst_vbap_e264_1.
lst_vbap_e264_1 = dxvbap.

*---Static Variable clearing based on DOCNUM field (IDOC Number).
CLEAR lst_edidd_e264_1.
READ TABLE didoc_data INTO lst_edidd_e264_1 INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_e264_1 NE lst_edidd_e264_1-docnum.
    FREE: lv_posnr_e264_1,
          lv_posval_e264_1,
          lv_docnum_e264_1.
    lv_docnum_e264_1  = lst_edidd_e264_1-docnum.
  ENDIF.
ENDIF.

* Fetch Publicatoin type for the particular material
SELECT matnr, ismpubltype
  FROM mara INTO TABLE @DATA(li_mara)
  WHERE matnr = @lst_vbap_e264_1-matnr AND
        ismpubltype IN @lir_pubtype.
IF sy-subrc = 0.            " record found for KIARA materials (Publication type = KB)

  LOOP AT dxbdcdata INTO lst_bdcdata_e264_1 WHERE fnam+0(10) = 'VBAP-POSEX'.
    lv_tabx_e264_1 = sy-tabix.

    CLEAR:lst_edidd_e264_1,lv_posnr_e264_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lst_bdcdata_e264_1-fval
      IMPORTING
        output = lv_posnr_e264_1.

    " Read Custom Item Segment for each Item for Contract Dates
    READ TABLE didoc_data INTO lst_edidd_e264_1 WITH KEY segnam = lc_ze1edp01_e264_1
                                                        sdata+0(6) = lv_posnr_e264_1.

    IF sy-subrc EQ 0 AND lv_posval_e264_1 NE lv_posnr_e264_1 AND lv_posnr_e264_1 GT lv_posval_e264_1 .

      lst_ze1edp01_e264_1 = lst_edidd_e264_1-sdata.
      lv_posval_e264_1 = lv_posnr_e264_1.

      IF lst_ze1edp01_e264_1-zzrgcode IS NOT INITIAL.   " Check registration code is null for the KIARA

        lv_pos_e264_1 = lst_bdcdata_e264_1-fnam+10(3).
        CONDENSE lv_pos_e264_1 NO-GAPS.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-program = 'SAPMV45A'.
        lst_bdcdata_e264_1-dynpro = '4001'.
        lst_bdcdata_e264_1-dynbegin = 'X'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos_e264_1 INTO lv_selkz1_e264_1.
        CONDENSE lv_selkz1_e264_1 NO-GAPS.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-fnam = lv_selkz1_e264_1.
        lst_bdcdata_e264_1-fval = 'X'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-fnam = 'BDC_OKCODE'.
        lst_bdcdata_e264_1-fval = '=PZKU'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-program = 'SAPMV45A'.
        lst_bdcdata_e264_1-dynpro = '4003'.
        lst_bdcdata_e264_1-dynbegin = 'X'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-fnam = 'BDC_CURSOR'.
        lst_bdcdata_e264_1-fval = 'VBAP-ZZRGCODE'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.                                   " Registration code
        lst_bdcdata_e264_1-fnam = 'VBAP-ZZRGCODE'.
        lst_bdcdata_e264_1-fval = lst_ze1edp01_e264_1-zzrgcode.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-fnam = 'BDC_OKCODE'.
        lst_bdcdata_e264_1-fval = '/EBACK'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        CLEAR lst_bdcdata_e264_1.
        lst_bdcdata_e264_1-program = 'SAPMV45A'.
        lst_bdcdata_e264_1-dynpro = '4001'.
        lst_bdcdata_e264_1-dynbegin = 'X'.
        APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

        lv_tabx_e264_1 = lv_tabx_e264_1 + 1.
        INSERT LINES OF li_dxbdcdata_e264_1 INTO dxbdcdata INDEX lv_tabx_e264_1.
        FREE : li_dxbdcdata_e264_1.
      ELSE.      " Registration code is not in the line item for kIARA Orders IDOC should be failed
        MESSAGE e587(zqtc_r2) RAISING user_error.  "
      ENDIF.

    ENDIF.
  ENDLOOP.
ENDIF.
