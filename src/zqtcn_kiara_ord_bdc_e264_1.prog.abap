*----------------------------------------------------------------------*
* Program Name : ZQTCN_INBOUND_BDC_E264_1                              *
* REVISION NO : ED2K922541                                             *
* REFERENCE NO: OTCM-23859                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 03/14/2021                                             *
* DESCRIPTION : SAP/Kiara Intergration - Mapping the registration code *
*               for Order processing with Z12 message variant.At the   *
*               line item level updating the registration code to identify
*               the licencing info and based on the licence info addressing
*               revenue
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K927278
* REFERENCE NO: OTCM-18549/44844- E264
* DEVELOPER: VDPATABALL
* DATE: 05/10/2022
* DESCRIPTION: Removing lineitem -ship to from XVBADR
*----------------------------------------------------------------------*
TYPES : BEGIN OF ty_ismpubltype,        " Publication type
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE ismpubltype,
          high TYPE ismpubltype,
        END OF ty_ismpubltype.

DATA: lir_pubtype         TYPE RANGE OF mara-ismpubltype,                               " Range declaration for Publication type
      lst_pubtype         TYPE ty_ismpubltype,
      lst_bdcdata_e264_1  LIKE LINE OF  bdcdata,                                        " Batch input: New table field structure
      li_dxbdcdata_e264_1 TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0,                " Batch input: New table field structure
      lst_edidd_e264_1    TYPE edidd,
      lv_tabx_e264_1      TYPE sy-tabix,
      lst_ze1edp01_e264_1 TYPE z1qtc_e1edp01_01,
      lv_pos_e264_1       TYPE char6,
      lv_selkz1_e264_1    TYPE char19.

STATICS : lv_posnr_e264_1  TYPE char6,                                                   " Handling the current line item
          lv_posval_e264_1 TYPE posnr,                                                   " Handling the previous line item value
          lv_docnum_e264_1 TYPE edi_docnum.                                              " IDOC number

CONSTANTS : lc_devid           TYPE zdevid     VALUE 'E264',              " WRICEF ID
            lc_ismpubltype     TYPE rvari_vnam VALUE 'ISMPUBLTYPE',       " Publication type
            lc_ze1edp01_e264_1 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01'.  " Line Item Extended fields

*Static Variable clearing based on DOCNUM field (IDOC Number).
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

LOOP AT dxbdcdata INTO lst_bdcdata_e264_1 WHERE fnam+0(10) = 'VBAP-POSEX'.
  lv_tabx_e264_1 = sy-tabix.        " Get current index of the Itab

  CLEAR:lst_edidd_e264_1,lv_posnr_e264_1.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lst_bdcdata_e264_1-fval
    IMPORTING
      output = lv_posnr_e264_1.

  " Read Custom Item Segment for each Item for Contract Dates
  READ TABLE didoc_data INTO lst_edidd_e264_1 WITH KEY segnam = lc_ze1edp01_e264_1
                                                      sdata+0(6) = lv_posnr_e264_1.

  " check the current line item and previous line item is not equal
  IF sy-subrc EQ 0 AND lv_posval_e264_1 NE lv_posnr_e264_1 AND lv_posnr_e264_1 GT lv_posval_e264_1 .
    lst_ze1edp01_e264_1 = lst_edidd_e264_1-sdata.
    lv_posval_e264_1 = lv_posnr_e264_1.

    lv_pos_e264_1 = lst_bdcdata_e264_1-fnam+10(3).  " Current line item value in the segment
    CONDENSE lv_pos_e264_1 NO-GAPS.

    CLEAR lst_bdcdata_e264_1.
    lst_bdcdata_e264_1-program = 'SAPMV45A'.
    lst_bdcdata_e264_1-dynpro = '4001'.
    lst_bdcdata_e264_1-dynbegin = 'X'.
    APPEND lst_bdcdata_e264_1 TO li_dxbdcdata_e264_1.

    " build the current line item selection
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

    " Add the new BDC code for next index of itab
    lv_tabx_e264_1 = lv_tabx_e264_1 + 1.
    INSERT LINES OF li_dxbdcdata_e264_1 INTO dxbdcdata INDEX lv_tabx_e264_1.
    FREE : li_dxbdcdata_e264_1.
  ENDIF.
ENDLOOP.
*---BOC VDPATABALL 05/16/2022 ED2K927278 Line Item Ship to remvoing Z12
*---New enhancement for Line Item Ship to removing from XVBADR.
TYPES: BEGIN OF lty_xvbadr ."OCCURS 10.        "Partner
TYPES:  posnr TYPE vbap-posnr,
        parvw TYPE vbpa-parvw,
        kunnr TYPE rv02p-kunde,
        ablad TYPE vbpa-ablad,
        knref TYPE knvp-knref.
        INCLUDE STRUCTURE vbadr.
        TYPES: END OF lty_xvbadr.

TYPES:tt_xvbadr TYPE STANDARD TABLE OF lty_xvbadr.
FIELD-SYMBOLS:<li_xvbadr_e264> TYPE tt_xvbadr .

CONSTANTS:lc_ser_num_e264_2 TYPE zsno   VALUE '002',   " Serial Number (002)
          lc_xvbadr_e264    TYPE char30 VALUE '(SAPLVEDA)XVBADR[]'.

* Populate Variable Key
lv_var_key_e264 = dxmescod.           " Message variant Z12
* Check if enhancement needs to be triggered
FREE:lv_actv_flag_e264.
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e264    " Constant value for WRICEF (E264)
    im_ser_num     = lc_ser_num_e264_2      " Serial Number (001)
    im_var_key     = lv_var_key_e264      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_e264.   " Active / Inactive flag

IF lv_actv_flag_e264 = abap_true.
*---get the Partner Function details
  ASSIGN (lc_xvbadr_e264) TO <li_xvbadr_e264>.
  IF <li_xvbadr_e264> IS ASSIGNED .
*---Removing line item ship to's  from XVBADR
    DELETE <li_xvbadr_e264> WHERE posnr NE '000000' AND parvw = lc_we_8.
  ENDIF.
ENDIF.
*---EOC VDPATABALL 05/16/2022 ED2K927278 Line Item Ship to remvoing Z12
