*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_ORD_BDC_I0230_22
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WLS_ORD_BDC_I0230_22(Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for WLS order creation BDC
* DEVELOPER: MIMMADISET(Murali)
* CREATION DATE:   29/04/2020
* OBJECT ID: I0230.22
* TRANSPORT NUMBER(S):ED2K918072
*----------------------------------------------------------------------*
FIELD-SYMBOLS : <li_xvbpa_wls> TYPE tt_vbpavb .
DATA: lst_bdcdata_wls  LIKE LINE OF  bdcdata, " Batch input: New table field structure
      li_dxbdcdata_wls TYPE STANDARD TABLE OF bdcdata. " Batch input: New table field structure

DATA:lst1_z1qtc_e1edka1_wls TYPE z1qtc_e1edka1_01,
     lst_e1edk14_wls        TYPE e1edk14,
     lst_e1edk02_wls        TYPE e1edk02,
     lst_e1edk01_wls        TYPE e1edk01,
     lv_xblnr_wls           TYPE xblnr_v1,   " Reference Document Number
     lv_row_wls(2)          TYPE n,
     lv_rowsel_wls(80)      TYPE c,           " Row selection
     lv_street4_wls         TYPE ad_strspp3,
     lst_e1edka1_wls        TYPE e1edka1,
     lv_name_co_wls         TYPE ad_name_co,
     lv_location_wls        TYPE ad_strspp3,
     lv_tabx_wls            TYPE sytabix,
     lv_email_wls           TYPE ad_smtpadr.

CONSTANTS:lc_idoc_pa_wls           TYPE char30     VALUE '(SAPLVEDA)XVBPA[]',
          lc1_z1qtc_e1edka1_01_wls TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
          lc_e1edk14_wls           TYPE char7      VALUE 'E1EDK14',
          lc_e1edk02_wls           TYPE char7      VALUE 'E1EDK02',
          lc_e1edk01_wls           TYPE char7      VALUE 'E1EDK01',
          lc1_e1edka1_8_wls        TYPE char7      VALUE 'E1EDKA1'.           " E1edka1_8 of type CHAR7.

STATICS:lv_flag_wls     TYPE char1,
        lv_docnum_t_wls TYPE edi_docnum.
CLEAR:lst1_z1qtc_e1edka1_wls,lst_e1edk14_wls,
     lst_e1edk02_wls,lv_xblnr_wls,
     lv_row_wls,lv_rowsel_wls,
     lv_street4_wls,lst_e1edka1_wls,
     lv_name_co_wls,lv_location_wls,
     lv_tabx_wls,lv_email_wls.
** Static variables clearing
READ TABLE didoc_data INTO DATA(lst_edidd_i0230_22) INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_t_wls NE lst_edidd_i0230_22-docnum.
    FREE:lv_flag_wls,
         lv_docnum_t_wls.
    lv_docnum_t_wls  = lst_edidd_i0230_22-docnum.
  ENDIF.
ENDIF.

FREE:li_dxbdcdata_wls[].
*DESCRIBE TABLE dxbdcdata LINES DATA(lv_tabx_wls).
READ TABLE dxbdcdata INTO DATA(lst_bdcdata_230_22)
                           WITH KEY fnam = 'BDC_OKCODE'
                                    fval = 'SICH'.
IF  sy-subrc EQ 0  AND lv_flag_wls IS INITIAL.
  lv_flag_wls = abap_true.
* Update PO type in header
  READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_230_22_wls>)  WITH KEY fnam = 'VBKD-BSARK'.
  IF sy-subrc EQ 0.
    READ TABLE didoc_data INTO DATA(lst_edidd_230_22_wls) WITH KEY
                                                          segnam = lc_e1edk14_wls
                                                          sdata+0(3) = '013'.
    IF sy-subrc EQ 0.
      lst_e1edk14_wls = lst_edidd_230_22_wls-sdata.
      <lfs_230_22_wls>-fval = lst_e1edk14_wls-orgid.
    ENDIF.
  ENDIF.
** * Update Header Partner Email,c/o name,street4
  ASSIGN (lc_idoc_pa_wls) TO <li_xvbpa_wls>.
  IF <li_xvbpa_wls> IS ASSIGNED .
*   Get Header data from Idoc Structure to add the address custom segment functionality
** Below loop is used to add the address related bdcdata in header level.
** Here Purchase order type field is mandatory field by using that we are identing the sy-tabix
** number from dxbdcdata to add the below address  bdcdata
    LOOP AT dxbdcdata INTO DATA(ls_bdc_wls) WHERE fnam = 'VBKD-BSARK'.
      lv_tabx_wls = sy-tabix.
      LOOP AT dxbdcdata INTO ls_bdc_wls FROM lv_tabx_wls.
        lv_tabx_wls = sy-tabix.
        IF ls_bdc_wls-fnam = 'BDC_OKCODE'.
          EXIT.
        ENDIF.
      ENDLOOP.
      EXIT.
    ENDLOOP.
************ Updating the reference document number in Accounting tab
    CLEAR:lst_edidd_230_22_wls.
    READ TABLE didoc_data INTO lst_edidd_230_22_wls WITH KEY
                                                      segnam = lc_e1edk02_wls
                                                      sdata+0(3) = '011'.
    IF sy-subrc EQ 0.
      lst_e1edk02_wls = lst_edidd_230_22_wls-sdata.
      lv_xblnr_wls = lst_e1edk02_wls-belnr.
      IF lv_xblnr_wls IS NOT INITIAL.
        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_22-fval = 'T\05'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-program = 'SAPMV45A'.
        lst_bdcdata_230_22-dynpro = '4002'.
        lst_bdcdata_230_22-dynbegin = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_CURSOR'.
        lst_bdcdata_230_22-fval = 'VBAK-XBLNR'.
        APPEND lst_bdcdata_e097 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'VBAK-XBLNR'.
        lst_bdcdata_230_22-fval = lv_xblnr_wls.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls. " Appending Assignment
      ENDIF.
    ENDIF.
********End logic**********************
    LOOP AT didoc_data INTO DATA(lst_edidd_230_22) WHERE segnam = lc1_e1edka1_8_wls.
      CLEAR:lv_email_wls,lv_row_wls,lv_street4_wls,lv_name_co_wls,
      lv_location_wls,lst1_z1qtc_e1edka1_wls,lst_e1edka1_wls.
      lst_e1edka1_wls = lst_edidd_230_22-sdata.
      READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_zka1_wls>) WITH KEY segnam = lc1_z1qtc_e1edka1_01
                                                                           sdata+60(2) = lst_e1edka1_wls-parvw.
      IF sy-subrc EQ 0.
        READ TABLE <li_xvbpa_wls> ASSIGNING FIELD-SYMBOL(<lfs_pa1_wls>) WITH KEY parvw = lst_e1edka1_wls-parvw.
        IF sy-subrc EQ 0.
          lv_row_wls = sy-tabix.
          lst1_z1qtc_e1edka1_wls = <lfs_zka1_wls>-sdata.
          lv_email_wls = lst1_z1qtc_e1edka1_wls-smtp_addr.
          lv_street4_wls = lst1_z1qtc_e1edka1_wls-str_suppl3.
          lv_name_co_wls = lst1_z1qtc_e1edka1_wls-name_co.
          lv_location_wls = lst1_z1qtc_e1edka1_wls-location.
          CLEAR:lv_rowsel_wls.
          CONCATENATE 'GVS_TC_DATA-SELKZ(' lv_row_wls ')' INTO lv_rowsel_wls.
          CONDENSE lv_rowsel_wls NO-GAPS.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.

      IF lv_email_wls IS NOT INITIAL OR
        lv_street4_wls IS NOT INITIAL OR
        lv_name_co_wls IS NOT INITIAL OR
        lv_name_co_wls IS INITIAL OR
        lv_location_wls IS NOT INITIAL.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_22-fval = 'T\08'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-program = 'SAPMV45A'.
        lst_bdcdata_230_22-dynpro = '4002'.
        lst_bdcdata_230_22-dynbegin = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = lv_rowsel_wls.
        lst_bdcdata_230_22-fval = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_22-fval = 'PSDE'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-program = 'SAPLV09C'.
        lst_bdcdata_230_22-dynpro = '5000'.
        lst_bdcdata_230_22-dynbegin = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
**c/o name updation
        IF lv_name_co_wls IS NOT INITIAL OR lv_name_co_wls IS INITIAL.
          CLEAR lst_bdcdata_230_22.
          lst_bdcdata_230_22-fnam = 'ADDR1_DATA-NAME_CO'.
          lst_bdcdata_230_22-fval = lv_name_co_wls.
          APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
        ENDIF.

*-----street4 field
        IF lv_street4_wls IS NOT INITIAL.
          CLEAR lst_bdcdata_230_22.
          lst_bdcdata_230_22-fnam = 'ADDR1_DATA-STR_SUPPL1'.
          lst_bdcdata_230_22-fval = lv_street4_wls.
          APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
        ENDIF.
*** Location field updation
        IF lv_location_wls IS NOT INITIAL.
          CLEAR lst_bdcdata_230_22.
          lst_bdcdata_230_22-fnam = 'ADDR1_DATA-STR_SUPPL3'.
          lst_bdcdata_230_22-fval = lv_location_wls.
          APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
        ENDIF.
        IF lv_email_wls IS NOT INITIAL.
          CLEAR lst_bdcdata_230_22.
          lst_bdcdata_230_22-fnam = 'SZA1_D0100-SMTP_ADDR'.
          lst_bdcdata_230_22-fval = lv_email_wls.
          APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

          CLEAR lst_bdcdata_230_22.
          lst_bdcdata_230_22-fnam = 'ADDR1_DATA-DEFLT_COMM'.
          lst_bdcdata_230_22-fval = 'INT'.
          APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
        ENDIF.
        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_22-fval = 'ENT1'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-program = 'SAPMV45A'.
        lst_bdcdata_230_22-dynpro = '4002'.
        lst_bdcdata_230_22-dynbegin = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.
      ENDIF.                    " if lv_email_wls is not initial
    ENDLOOP.
************ Updating the shipping method in Shipping tab
    CLEAR:lst_edidd_230_22_wls.
    READ TABLE didoc_data INTO lst_edidd_230_22_wls WITH KEY
                                                      segnam = lc_e1edk01_wls.
    IF sy-subrc EQ 0.
      lst_e1edk01_wls = lst_edidd_230_22_wls-sdata.
      DATA(lv_vsbed_wls) = lst_e1edk01_wls-vsart.
      IF lv_vsbed_wls IS NOT INITIAL.
        READ TABLE dxbdcdata ASSIGNING <lfs_230_22_wls> WITH KEY fnam = 'VBAK-VSBED'.
        IF sy-subrc EQ 0.
          READ TABLE didoc_data INTO lst_edidd_230_22_wls WITH KEY
                                                                segnam = lc_e1edk01_wls.
          IF sy-subrc EQ 0.
            <lfs_230_22_wls>-fval = space.
          ENDIF.
        ENDIF.
        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_22-fval = 'T\02'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-program = 'SAPMV45A'.
        lst_bdcdata_230_22-dynpro = '4002'.
        lst_bdcdata_230_22-dynbegin = 'X'.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'BDC_CURSOR'.
        lst_bdcdata_230_22-fval = 'VBAK-VSBED'.
        APPEND lst_bdcdata_e097 TO li_dxbdcdata_wls.

        CLEAR lst_bdcdata_230_22.
        lst_bdcdata_230_22-fnam = 'VBAK-VSBED'.
        lst_bdcdata_230_22-fval = lv_vsbed_wls.
        APPEND lst_bdcdata_230_22 TO li_dxbdcdata_wls. " Appending Assignment
      ENDIF.
    ENDIF.
********End logic**********************

    IF li_dxbdcdata_wls IS NOT INITIAL AND lv_tabx_wls IS NOT INITIAL.
      INSERT LINES OF li_dxbdcdata_wls INTO  dxbdcdata INDEX lv_tabx_wls.
    ENDIF.
    FREE:li_dxbdcdata_wls.
  ENDIF.
ENDIF.
