*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_BDC_IND_AGT_I0341
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_INDIAN_AGT_I0341 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Interface for Indain Agent
* DEVELOPER: VDPATABALL(Venkat)
* CREATION DATE:   12/14/2021
* OBJECT ID: OTCM-47818/51088 - I0341
* TRANSPORT NUMBER(S):   ED2K925253
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*------------------------------------------------------------------- *
TYPES: BEGIN OF lty_matnr,
         matnr TYPE matnr,
       END OF lty_matnr.

DATA:li_bdcdata_i0341    TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
     li_bdcdata_i0341_t  TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
     li_bdcdata_i0341_tt TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
     lst_e1edp19         TYPE e1edp19,                   "Segment
     li_matnr            TYPE STANDARD TABLE OF lty_matnr, "Material Internal Tabl e
     lst_matnr           TYPE lty_matnr,                   "material work area
     lst_status          TYPE rjksd_mstae_range,
     lir_status          TYPE rjksd_mstae_range_tab,
     lv_vbeln            TYPE vbeln.
*--Static Variable s
STATICS: lv_count        TYPE char10,
         lv_docnum_i0341 TYPE edi_docnum,
         lv_matnr        TYPE matnr,
         lv_bdc_flag     TYPE char1.

CONSTANTS: lc_idoc_cont_z10  TYPE char30     VALUE '(SAPLVEDA)IDOC_CONTRL[]',
           lc_xvbap_cont_z10 TYPE char30     VALUE '(SAPLVEDA)XVBAP[]',
           lc_e1edp19        TYPE edilsegtyp VALUE 'E1EDP19',
           lc_iag            TYPE edi_mesfct VALUE 'IAG',
           lc_devid_i0341    TYPE zdevid     VALUE 'I0341',
           lc_mstae          TYPE rvari_vnam VALUE 'MSTAE',
           lc_level_00       TYPE stufe_vbfa VALUE '00'.

FIELD-SYMBOLS:<li_contrl_z10> TYPE edidc_tt.

*--get Control record
ASSIGN (lc_idoc_cont_z10) TO <li_contrl_z10>.

*---Clear the static variables
READ TABLE didoc_data INTO DATA(lst_edidd_i0341) INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_i0341 NE lst_edidd_i0341-docnum.
    FREE:lv_matnr,lv_bdc_flag.
    lv_docnum_i0341  = lst_edidd_i0341-docnum.
  ENDIF.
ENDIF.

*---free the all internal table and variables.
FREE:li_bdcdata_i0341,
     li_bdcdata_i0341_t,
     li_bdcdata_i0341_tt,
     lst_e1edp19,
     li_matnr,
     lv_vbeln,
     lst_matnr.

*---check the inbound idoc related to India Agent bed on the Message Funcation.
READ TABLE <li_contrl_z10> ASSIGNING FIELD-SYMBOL(<fs_contrl_z10>) INDEX 1.
IF sy-subrc = 0 AND <fs_contrl_z10>-mesfct = lc_iag.

  READ TABLE dxbdcdata INTO lst_dxbdcdata WITH KEY fnam = 'LV45C-VBELN'.
  IF <li_contrl_z10> IS ASSIGNED  AND lst_dxbdcdata-fval IS NOT INITIAL.
    IF lv_bdc_flag = abap_false.
      lv_vbeln = lst_dxbdcdata-fval.
*---Modify the BDC Action for selecting items
      lv_tabix = sy-tabix.
      lv_tabix = lv_tabix + 1.
      lst_dxbdcdata-fval = '=RUE1'.
      MODIFY dxbdcdata INDEX lv_tabix FROM lst_dxbdcdata TRANSPORTING fval.
      lv_bdc_flag = abap_true.
    ENDIF. "  IF lv_bdc_flag = abap_false.
  ENDIF. "IF <li_contrl_z10> IS ASSIGNED  AND lst_dxbdcdata-fval IS NOT INITIAL.

*--once BDC record is completed adding the Selected Line Items based on Segments
  READ TABLE dxbdcdata INTO lst_bdcdata_i0341 WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
  IF sy-subrc = 0.
    READ TABLE dxbdcdata INTO lst_dxbdcdata WITH KEY fnam = 'LV45C-VBELN'. "Checking the Quotation number
    IF sy-subrc = 0.
      lv_tabix = sy-tabix + 2.
      lv_vbeln = lst_dxbdcdata-fval. "Quotation number
    ENDIF.

    CLEAR:  lst_bdcdata_i0341.
    lst_bdcdata_i0341-program = 'SAPMV45A'.
    lst_bdcdata_i0341-dynpro  =  '4413'.
    lst_bdcdata_i0341-dynbegin   = 'X'.
    APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341.
*---get the constant entries
    CALL METHOD zca_utilities=>get_constants
      EXPORTING
        im_devid     = lc_devid_i0341            "I0341
      IMPORTING
        et_constants = DATA(li_const_i0341).     "Constant Values
    FREE:lir_status.
    LOOP AT  li_const_i0341 INTO DATA(lst_const_i0341) WHERE param1 =  lc_mstae.
      lst_status-sign    = lst_const_i0341-sign.
      lst_status-option  = lst_const_i0341-opti.
      lst_status-low     = lst_const_i0341-low.
      APPEND lst_status TO lir_status.
      CLEAR lst_status.
    ENDLOOP.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_vbeln
      IMPORTING
        output = lv_vbeln.


*---get the quotation material numbers
    SELECT vbeln, posnr, matnr,  abgru
       FROM vbap
       INTO TABLE @DATA(li_vbap_tmp)
       WHERE vbeln = @lv_vbeln
         AND uepos = '000000'.
    IF sy-subrc = 0 AND li_vbap_tmp IS NOT INITIAL.
      SORT li_vbap_tmp BY vbeln posnr.
*---get the Materials Status
      SELECT matnr, mstae
        FROM mara
        INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_vbap_tmp
         WHERE matnr = @li_vbap_tmp-matnr
           AND mstae IN @lir_status
           AND mstdv LT @sy-datum.

      SELECT vbelv, posnv
        FROM vbfa
        INTO TABLE @DATA(li_vbfa)
        FOR ALL ENTRIES IN @li_vbap_tmp
        WHERE vbelv = @li_vbap_tmp-vbeln
          AND posnv = @li_vbap_tmp-posnr
          AND vbtyp_n = @lc_g
          AND stufe   = @lc_level_00.
    ENDIF.

*---Get the Material details from E1EDP19
    LOOP AT didoc_data INTO lst_edidd_i0341 WHERE segnam = lc_e1edp19.
      lst_e1edp19 = lst_edidd_i0341-sdata.
      lst_matnr-matnr = lst_e1edp19-idtnr.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = lst_matnr-matnr
        IMPORTING
          output       = lst_matnr-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      APPEND lst_matnr TO li_matnr.
      CLEAR:lst_e1edp19,lst_matnr.
    ENDLOOP.

    SORT:li_matnr BY matnr,
         li_vbfa  BY vbelv posnv.

    LOOP AT li_vbap_tmp INTO DATA(lst_vbap_tmp) WHERE abgru IS INITIAL.
      READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lst_vbap_tmp-vbeln posnv = lst_vbap_tmp-posnr BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE li_mara INTO DATA(lst_mara) WITH  KEY matnr = lst_vbap_tmp-matnr BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE li_matnr INTO lst_matnr WITH KEY matnr = lst_vbap_tmp-matnr BINARY SEARCH.
          IF sy-subrc NE 0.

            CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
            lst_bdcdata_i0341-program = 'SAPMV45A'.
            lst_bdcdata_i0341-dynpro  =  '4001'.
            lst_bdcdata_i0341-dynbegin   = 'X'.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.

            CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
            lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
            lst_bdcdata_i0341-fval = '=POPO'. "get the Popup
            APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.

            CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
            lst_bdcdata_i0341-program = 'SAPMV45A'.
            lst_bdcdata_i0341-dynpro  =  '0251'.
            lst_bdcdata_i0341-dynbegin   = 'X'.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.


            CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
            lst_bdcdata_i0341-fnam = 'RV45A-POSNR'.
            lst_bdcdata_i0341-fval = lst_vbap_tmp-posnr.
            APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.


            CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
            lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
            lst_bdcdata_i0341-fval = '=POSI'. "select that particular line item
            APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.


            CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
            lst_bdcdata_i0341-program = 'SAPMV45A'.
            lst_bdcdata_i0341-dynpro  =  '4001'.
            lst_bdcdata_i0341-dynbegin   = 'X'.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.

            CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
            lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
            lst_bdcdata_i0341-fval = '=POLO'. "Delete action
            APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_tt.

          ELSE. "READ TABLE li_matnr INTO lst_matnr WITH KEY matnr = lst_vbap_tmp-matnr BINARY SEARCH.

            READ TABLE dxbdcdata INTO lst_bdcdata WITH KEY fnam = 'VBAP-MATNR(2)'.
            IF sy-subrc = 0.
              DATA(lv_tabix_1) = sy-tabix - 3.
              READ TABLE dxbdcdata INTO lst_bdcdata WITH KEY  fnam = 'RV45A-PO_MATNR'.
              IF  sy-subrc = 0.
                DATA(lv_tabix_2) = sy-tabix .
              ENDIF.
              IF lv_tabix_2 GE lv_tabix_1.
                DATA(lv_tabix_3) = lv_tabix_2 - lv_tabix_1 + 1.
              ENDIF.

              DO lv_tabix_3 TIMES.
                DELETE dxbdcdata INDEX lv_tabix_1. "removing extra BDC lines for Materials from E1EDP19
              ENDDO.

              lv_tabix_1  = lv_tabix_1 + 2.

              READ TABLE dxbdcdata INTO DATA(lst_bdcdata_tmp) INDEX lv_tabix_1.
              IF sy-subrc = 0 AND lst_bdcdata_tmp-fnam = 'RV45A-VBAP_SELKZ(1)'.
                DATA(lv_tabix_4) = sy-tabix - 1.
                FREE:li_bdcdata_i0341_t.
                CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
                lst_bdcdata_i0341-program = 'SAPMV45A'.
                lst_bdcdata_i0341-dynpro  =  '4001'.
                lst_bdcdata_i0341-dynbegin   = 'X'.
                APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_t.

                CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
                lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
                lst_bdcdata_i0341-fval = '=POPO'.  "get the Popup
                APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_t.

                CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
                lst_bdcdata_i0341-program = 'SAPMV45A'.
                lst_bdcdata_i0341-dynpro  =  '0251'.
                lst_bdcdata_i0341-dynbegin   = 'X'.
                APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_t.


                CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
                lst_bdcdata_i0341-fnam = 'RV45A-POSNR'.
                lst_bdcdata_i0341-fval = lst_vbap_tmp-posnr.
                APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_t.


                CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
                lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
                lst_bdcdata_i0341-fval = '=POSI'.  "select that particular line item
                APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341_t.
                INSERT LINES OF li_bdcdata_i0341_t INTO dxbdcdata INDEX lv_tabix_4.
                FREE:li_bdcdata_i0341_t.
              ENDIF. "   IF sy-subrc = 0 AND lst_bdcdata_tmp-fnam = 'RV45A-VBAP_SELKZ(1)'.
            ENDIF. "READ TABLE dxbdcdata INTO lst_bdcdata WITH KEY fnam = 'VBAP-MATNR(2)'.
          ENDIF. "READ TABLE li_matnr INTO lst_matnr WITH KEY matnr = lst_vbap_tmp-matnr BINARY SEARCH.
        ENDIF. "READ TABLE li_mara INTO DATA(lst_mara) WITH  KEY matnr = lst_vbap_tmp-matnr BINARY SEARCH.
      ENDIF. "READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lst_vbap_tmp-vbeln posnv = lst_vbap_tmp-posnr BINARY SEARCH.
    ENDLOOP.


    CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
    lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
    lst_bdcdata_i0341-fval = '=RUEB'. "Coping the line Item to Contract line Item screen
    APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341.

    CLEAR:  lst_bdcdata_i0341." Clearing work area for BDC data
    lst_bdcdata_i0341-program = 'SAPMV45A'.
    lst_bdcdata_i0341-dynpro  =  '4001'.
    lst_bdcdata_i0341-dynbegin   = 'X'.
    APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341.

    CLEAR lst_bdcdata_i0341. " Clearing work area for BDC data
    lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
    lst_bdcdata_i0341-fval = '/00'.
    APPEND  lst_bdcdata_i0341 TO li_bdcdata_i0341.

    IF li_bdcdata_i0341_tt IS NOT INITIAL.
      APPEND LINES OF li_bdcdata_i0341_tt TO li_bdcdata_i0341.
    ENDIF.
*---inserting the new coping and selecting BDC lines
    INSERT LINES OF li_bdcdata_i0341 INTO dxbdcdata INDEX lv_tabix.
    FREE:li_bdcdata_i0341.

  ENDIF. " IF <li_contrl_z10> IS ASSIGNED  AND lst_dxbdcdata-fval IS NOT INITIAL.
ENDIF. "IF sy-subrc = 0 AND <fs_contrl_z10>-mesfct = 'IAG'.
