*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SO_ORD_BDC_E263_2
*&---------------------------------------------------------------------*
* Include     :ZQTCN_SO_ORD_BDC_E263_2                                 *
* Transpor NO : ED2K924060                                             *
* REFERENCE NO: OTCM- 45037                                            *
* DEVELOPER   : Murali (mimmadiset)                                    *
* DATE        : 07/10/2021                                             *
* DESCRIPTION : populate header  Email ID for standing orders from
*               custom segment  if supplementary PO is ‘SO’.           *
*               with message variant Z12                               *
*----------------------------------------------------------------------*
FIELD-SYMBOLS : <li_xvbpa_e263> TYPE tt_vbpavb.
CONSTANTS:lc1_e1edka1_e263 TYPE char7      VALUE 'E1EDKA1',
          lc1_email_e263   TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
          lc_devid_e263    TYPE zdevid     VALUE 'E263',
          lc1_e1edk01      TYPE edilsegtyp VALUE 'E1EDK01',
          lc_bstzd_e263    TYPE rvari_vnam VALUE 'SUPPLEMENT_PO',
          lc_parvw_e263    TYPE rvari_vnam VALUE 'PARVW_EMAIL',
          lc_idoc_pa_e263  TYPE char30     VALUE '(SAPLVEDA)XVBPA[]'.


STATICS:lv_flag_e263     TYPE char1,
        lv_docnum_t_e263 TYPE edi_docnum.

DATA: lst_bdcdata_e263   LIKE LINE OF  bdcdata, " Batch input: New table field structure
      li_dxbdcdata_e263  TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      li_constants_e263  TYPE zcat_constants,    "Constant Values
      lst_e1edk01        TYPE e1edk01,
      lst1_z1qtc_e1edka1 TYPE z1qtc_e1edka1_01,
      lst_e1edka1_e263   TYPE e1edka1,
      r_supplement_po    TYPE RANGE OF salv_de_selopt_low,
      r_parvw            TYPE RANGE OF salv_de_selopt_low,
      lv_row_e263(2)     TYPE n,
      lv_tabx_e263       TYPE sytabix,

      lv_email_e263      TYPE ad_smtpadr.
** Static variables clearing
READ TABLE didoc_data INTO DATA(lst_edidd_e263_2) INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_t_e263 NE lst_edidd_e263_2-docnum.
    FREE:lv_flag_e263,lv_docnum_t_e263.
    lv_docnum_t_e263  = lst_edidd_e263_2-docnum.
  ENDIF.
ENDIF.
CLEAR:lst_bdcdata_e263,
      li_dxbdcdata_e263[],
      li_constants_e263[],
      lst_e1edk01,
      lst1_z1qtc_e1edka1,
      lst_e1edka1_e263,
      r_supplement_po[],
      r_parvw[],
      lv_row_e263,
      lv_tabx_e263,
      lv_email_e263.
*---Check the Constant table before going to the actual logiC.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e263  "Development ID
  IMPORTING
    ex_constants = li_constants_e263. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
IF li_constants_e263[] IS NOT INITIAL.
  LOOP AT li_constants_e263[] INTO DATA(lst_const_e263).
    IF lst_const_e263-param1 = lc_bstzd_e263.
      APPEND INITIAL LINE TO r_supplement_po ASSIGNING FIELD-SYMBOL(<lst_supplement_po>).
      <lst_supplement_po>-sign   = lst_const_e263-sign.
      <lst_supplement_po>-option = lst_const_e263-opti.
      <lst_supplement_po>-low    = lst_const_e263-low.
      <lst_supplement_po>-high   = lst_const_e263-high.
    ELSEIF lst_const_e263-param1 = lc_parvw_e263.
      APPEND INITIAL LINE TO r_parvw ASSIGNING FIELD-SYMBOL(<lst_parvw>).
      <lst_parvw>-sign   = lst_const_e263-sign.
      <lst_parvw>-option = lst_const_e263-opti.
      <lst_parvw>-low    = lst_const_e263-low.
      <lst_parvw>-high   = lst_const_e263-high.
    ENDIF.
  ENDLOOP.
ENDIF.
IF r_supplement_po IS NOT INITIAL.
  FREE:li_dxbdcdata_e263[].
  READ TABLE dxbdcdata INTO DATA(lst_bdcdata_e263_2)
                             WITH KEY fnam = 'BDC_OKCODE'
                                      fval = 'SICH'.
  IF  sy-subrc EQ 0  AND lv_flag_e263 IS INITIAL.
    READ TABLE didoc_data INTO DATA(lst_edidd_263) WITH KEY
                                                   segnam = lc1_e1edk01.
    IF sy-subrc = 0.
      lst_e1edk01 = lst_edidd_263-sdata.
      IF lst_e1edk01-bstzd IS NOT INITIAL.
        IF lst_e1edk01-bstzd IN r_supplement_po.
          lv_flag_e263 = abap_true.
** Here Purchase order number supplement field is mandatory field by using that
** we are identfing the sy-tabix number from dxbdcdata to add the below email id  bdcdata
          LOOP AT dxbdcdata INTO DATA(ls_bdc_e263) WHERE fnam = 'VBAK-BSTZD'.
            lv_tabx_e263 = sy-tabix.
            LOOP AT dxbdcdata INTO ls_bdc_e263 FROM lv_tabx_e263.
              lv_tabx_e263 = sy-tabix.
              IF ls_bdc_e263-fnam = 'BDC_OKCODE'.
                EXIT.
              ENDIF.
            ENDLOOP.
            EXIT.
          ENDLOOP.
** * Find the  Header bill to party row to update the email
          ASSIGN (lc_idoc_pa_e263) TO <li_xvbpa_e263>.
          IF <li_xvbpa_e263> IS ASSIGNED AND sy-subrc EQ 0.
*   Get Header data from Idoc Structure to populate custom segment email id functionality for AG
            LOOP AT  didoc_data INTO DATA(lst_edidd_e263) WHERE segnam = lc1_e1edka1_e263
                                                             AND sdata+0(3) IN r_parvw.
              CLEAR:lst1_z1qtc_e1edka1,lv_row_e263,lv_email_e263.
              lst_e1edka1_e263 = lst_edidd_e263-sdata.
              READ TABLE didoc_data INTO DATA(ls_seg_email) WITH KEY segnam = lc1_email_e263
                                                                     sdata+60(2) = lst_e1edka1_e263-parvw.
              IF sy-subrc EQ 0.
                READ TABLE <li_xvbpa_e263> TRANSPORTING NO FIELDS WITH KEY parvw = lst_e1edka1_e263-parvw.
                IF sy-subrc EQ 0.
                  lv_row_e263 = sy-tabix.
                  lst1_z1qtc_e1edka1 = ls_seg_email-sdata.
                  lv_email_e263 = lst1_z1qtc_e1edka1-smtp_addr.
                  CONCATENATE 'GVS_TC_DATA-SELKZ(' lv_row_e263 ')' INTO DATA(lv_rowsel_e263).
                  CONDENSE lv_rowsel_e263 NO-GAPS.
                ENDIF.
              ELSE.
                CONTINUE.
              ENDIF.
              IF lv_email_e263 IS NOT INITIAL AND lv_rowsel_e263 IS NOT INITIAL.
                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = 'BDC_OKCODE'.
                lst_bdcdata_e263-fval = 'T\09'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-program = 'SAPMV45A'.
                lst_bdcdata_e263-dynpro = '4002'.
                lst_bdcdata_e263-dynbegin = 'X'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = lv_rowsel_e263.
                lst_bdcdata_e263-fval = 'X'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = 'BDC_OKCODE'.
                lst_bdcdata_e263-fval = 'PSDE'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-program = 'SAPLV09C'.
                lst_bdcdata_e263-dynpro = '5000'.
                lst_bdcdata_e263-dynbegin = 'X'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = 'SZA1_D0100-SMTP_ADDR'.
                lst_bdcdata_e263-fval = lv_email_e263.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = 'ADDR1_DATA-DEFLT_COMM'.
                lst_bdcdata_e263-fval = 'INT'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-fnam = 'BDC_OKCODE'.
                lst_bdcdata_e263-fval = 'ENT1'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.

                CLEAR lst_bdcdata_e263.
                lst_bdcdata_e263-program = 'SAPMV45A'.
                lst_bdcdata_e263-dynpro = '4002'.
                lst_bdcdata_e263-dynbegin = 'X'.
                APPEND lst_bdcdata_e263 TO li_dxbdcdata_e263.
                CLEAR:lv_email_e263,lv_rowsel_e263.
              ENDIF.
            ENDLOOP.
            IF li_dxbdcdata_e263 IS NOT INITIAL AND lv_tabx_e263 IS NOT INITIAL.
              INSERT LINES OF li_dxbdcdata_e263 INTO  dxbdcdata INDEX lv_tabx_e263.
            ENDIF.
            CLEAR:lv_tabx_e263.
            FREE:li_dxbdcdata_e263.
          ENDIF."IF <li_xvbpa_e263> IS ASSIGNED .
        ENDIF."IF lst_e1edk01-bstzd  IN r_supplement_po.
      ENDIF."IF lst_e1edk01-bstzd IS NOT INITIAL.
    ENDIF." IF sy-subrc = 0.
  ENDIF." IF  sy-subrc EQ 0  AND lv_flag_e263 IS INITIAL.
ENDIF." IF r_supplement_po IS NOT INITIAL.
