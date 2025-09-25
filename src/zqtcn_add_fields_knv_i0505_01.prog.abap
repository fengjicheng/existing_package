*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SEGMENT_FILL_I0505_01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SEGMENT_FILL_I0505_01
* PROGRAM DESCRIPTION: Logic to add custom fields as text segmants at
*                      both header and item level
*                      Constant values have been maintained in table
*                      ZCAINTEG_MAPPING
* DEVELOPER          : Jagadeeswara Rao M (JMADAKA)
* CREATION DATE      : 2022-03-31
* OBJECT ID          : I0505 (EAM-6905)
* TRANSPORT NUMBER(S): ED2K926183 / ED2K926270
*----------------------------------------------------------------------*
*** Data declerations
TYPES: BEGIN OF ty_e1edp35,
         qualz  TYPE char3,
         cusadd TYPE char35,
       END OF ty_e1edp35.
DATA: li_e1edp35  TYPE TABLE OF ty_e1edp35,
      lst_e1edp35 TYPE ty_e1edp35,
      lv_qualz    TYPE char3,
      lv_cusadd   TYPE char35.

DATA: lst_edidd_i0505       TYPE edidd, " Data record (IDoc)
      lst_edidd_i0505_tmp   TYPE edidd,
      lst_e1edk01_i0505     TYPE e1edk01, " IDoc: Document Header Partner Information
      lst_e1edka1_i0505     TYPE e1edka1, " IDoc: Document Header Partner Information
      lst_e1edp01_i0505     TYPE e1edp01, " IDoc: Document Item General Data
      lst_e1edkt1_i0505     TYPE e1edkt1,
      lst_e1edkt1_i0505_tmp TYPE e1edkt1,
      lst_e1edkt2_i0505     TYPE e1edkt2,
      lst_e1edpt1_i0505     TYPE e1edpt1,
      lst_e1edpt2_i0505     TYPE e1edpt2,
      lst_e1edp35_i0505     TYPE e1edp35.

DATA: lv_line_i0505        TYPE sytabix,
      lv_kunnr_i0505       TYPE kunnr,
      lv_expnr_i0505       TYPE edi_expnr,
      li_constants         TYPE ztca_integ_mapping,
      lv_vbeln_i0505       TYPE vbeln_va,
      lv_matnr_i0505       TYPE matnr,
      lv_laiso             TYPE laiso,
      lv_e1edkt1_not_exist TYPE char1,
      lv_stceg             TYPE stceg,
      lv_kbetr             TYPE kbetr,
      lv_kbetr_init        TYPE kbetr.


DATA: lir_mstae TYPE RANGE OF zsap_value WITH HEADER LINE,
      lir_abgru TYPE RANGE OF zsap_value WITH HEADER LINE.


CONSTANTS: lc_star              TYPE char15 VALUE '*',
           lc_zero              TYPE char15 VALUE '000000000000000',
           lc_devid_i0505       TYPE zdevid VALUE 'I0505.1',
           lc_rejcode_bp        TYPE rvari_vnam VALUE 'REJCODE_BP',
           lc_rejcode_cp        TYPE rvari_vnam VALUE 'REJCODE_CP',
           lc_rejreason_ctr001  TYPE rvari_vnam VALUE 'REJREASON_CTR001',
           lc_rejreason_ctr002  TYPE rvari_vnam VALUE 'REJREASON_CTR002',
           lc_backord_j         TYPE rvari_vnam VALUE 'BACKORD_J',
           lc_backord_n         TYPE rvari_vnam VALUE 'BACKORD_N',
           lc_e1edk01_i0505     TYPE char7  VALUE 'E1EDK01',          " E1edka1 of type CHAR7
           lc_e1edka1_i0505     TYPE char7  VALUE 'E1EDKA1',          " E1edka1 of type CHAR7
           lc_e1edp01_i0505     TYPE char7  VALUE 'E1EDP01',          " E1edka1 of type CHAR7
           lc_we_i0505          TYPE char2  VALUE 'WE',               " We of type CHAR2
           lc_ag_i0505          TYPE char2  VALUE 'AG',               " Ag of type CHAR2
           lc_h02_i0505         TYPE edi_hlevel VALUE '02',
           lc_h03_i0505         TYPE edi_hlevel VALUE '03',
           lc_h04_i0505         TYPE edi_hlevel VALUE '04',
           lc_e1edkt1_i0505     TYPE char7 VALUE 'E1EDKT1',
           lc_e1edkt2_i0505     TYPE char7 VALUE 'E1EDKT2',
           lc_e1edpt1_i0505     TYPE char7 VALUE 'E1EDPT1',
           lc_e1edpt2_i0505     TYPE char7 VALUE 'E1EDPT2',
           lc_expnr_ag_i0505    TYPE rvari_vnam VALUE 'EXPNR_AG',
           lc_eikto_ag_i0505    TYPE rvari_vnam VALUE 'EIKTO_AG',
           lc_expnr_we_i0505    TYPE rvari_vnam VALUE 'EXPNR_WE',
           lc_eikto_we_i0505    TYPE rvari_vnam VALUE 'EIKTO_WE',
           lc_zaddqty_i0505     TYPE rvari_vnam VALUE 'ZADDQTY',
           lc_ismpubldate_i0505 TYPE rvari_vnam VALUE 'ISMPUBLDATE',
           lc_zdiffqty_i0505    TYPE rvari_vnam VALUE 'ZDIFFQTY',
           lc_zrejcod_i0505     TYPE rvari_vnam VALUE 'ZREJCOD',
           lc_zrejrea_i0505     TYPE rvari_vnam VALUE 'ZREJREA',
           lc_zbackord_i0505    TYPE rvari_vnam VALUE 'ZBACKORD',
           lc_mstae_i0505       TYPE rvari_vnam VALUE 'MSTAE',
           lc_kzwi1_i0505       TYPE rvari_vnam VALUE 'KZWI1',
           lc_kzwi2_i0505       TYPE rvari_vnam VALUE 'KZWI2',
           lc_kzwi3_i0505       TYPE rvari_vnam VALUE 'KZWI3',
           lc_kzwi4_i0505       TYPE rvari_vnam VALUE 'KZWI4',
           lc_001               TYPE char3 VALUE '001',
           lc_002               TYPE char3 VALUE '002',
           lc_003               TYPE char3 VALUE '003',
           lc_004               TYPE char3 VALUE '004',
           lc_005               TYPE char3 VALUE '005',
           lc_006               TYPE char3 VALUE '006',
           lc_007               TYPE char3 VALUE '007',
           lc_008               TYPE char3 VALUE '008',
           lc_009               TYPE char3 VALUE '009',
           lc_010               TYPE char3 VALUE '010',
           lc_tdid_k            TYPE rvari_vnam VALUE 'TDID',
           lc_augru             TYPE rvari_vnam VALUE 'AUGRU',
**           lc_augru_99          TYPE rvari_vnam VALUE 'AUGRU_99',
           lc_mstae_n           TYPE rvari_vnam VALUE 'MSTAE_N',
           lc_mstae_p           TYPE rvari_vnam VALUE 'MSTAE_P',
           lc_header_vat        TYPE rvari_vnam VALUE 'HEADER_VAT',
           lc_vat_reg           TYPE rvari_vnam VALUE 'VAT_REG_NUM',
           lc_i                 TYPE char1 VALUE 'I',
           lc_eq                TYPE char2 VALUE 'EQ',
           lc_zitr              TYPE kschl VALUE 'ZITR'.


DESCRIBE TABLE int_edidd LINES lv_line.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd INTO lst_edidd_i0505 INDEX lv_line.
IF sy-subrc = 0.

*** Get constant values from zcainteg_mapping table
  CLEAR li_constants[].
  zca_utilities=>get_integ_constants( EXPORTING im_devid = lc_devid_i0505
                                      IMPORTING et_constants = li_constants ).
  IF li_constants[] IS NOT INITIAL.
    SORT li_constants BY param1 param2 srno.
  ENDIF.

*** Get ISO code for language
  CALL FUNCTION 'CONVERT_SAP_LANG_TO_ISO_LANG'
    EXPORTING
      input            = sy-langu
    IMPORTING
      output           = lv_laiso
    EXCEPTIONS
      unknown_language = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    CLEAR lv_laiso.
  ENDIF.


  CASE lst_edidd_i0505-segnam.

    WHEN 'E1EDP01'.
*** Chek if E1EDKT1/E1EDKT2 segments are populated or not.
*** If populated then check if segments with qualifier starts with 'K'.
*** If no segment with qualifier with K*** then add text segments with qualifiers K*** for custom fields
      CLEAR lv_e1edkt1_not_exist.
      IF line_exists( int_edidd[ segnam = lc_e1edkt1_i0505 ] ).
        LOOP AT int_edidd INTO lst_edidd_i0505_tmp WHERE segnam = lc_e1edkt1_i0505.
          lst_e1edkt1_i0505_tmp = lst_edidd_i0505_tmp-sdata.
          IF lst_e1edkt1_i0505_tmp-tdid CA VALUE #( li_constants[ param1 = lc_tdid_k ]-sap_value OPTIONAL ).
            lv_e1edkt1_not_exist = abap_false.
            EXIT.
          ELSE.
            lv_e1edkt1_not_exist = abap_true.
          ENDIF.
        ENDLOOP.
      ELSE.
        lv_e1edkt1_not_exist = abap_true.
      ENDIF.

      IF lv_e1edkt1_not_exist IS NOT INITIAL.

*** If E1EDKT1/E1EDKT2 segmants are not available then add now.
*** Before adding, delete row with segmant name = E1EDP01 and add it after adding header text segments
*** Move E1EDP01 record to a temporary work area
        READ TABLE int_edidd INTO lst_edidd_i0505_tmp WITH KEY segnam = lc_e1edp01_i0505.
        IF sy-subrc = 0.
*** Delete record where segment name = E1EDP01
          DELETE int_edidd WHERE segnam = lc_e1edp01_i0505.
        ENDIF.

        lst_e1edka1_i0505 = VALUE #( int_edidd[ segnam = lc_e1edka1_i0505 ]-sdata OPTIONAL ).

        CLEAR: lv_kunnr_i0505, lv_expnr_i0505.
        lv_kunnr_i0505 = lst_e1edka1_i0505-partn.
******EXPNR_AG
****** Populate EXPNR for Sold-to to E1EDKT2-TDLINE and populate qualifier KAG1 to E1EDKT1-TDID and append both segments to INT_EDIDD
***        CLEAR: lst_e1edkt1_i0505, lst_e1edkt2_i0505.
***        SELECT SINGLE expnr
***                      FROM edpar
***                      INTO lv_expnr_i0505
***                      WHERE kunnr = lv_kunnr_i0505
***                      AND   parvw = lc_ag_i0505
***                      AND   expnr IS NOT NULL.
***        IF sy-subrc = 0.
***          lst_e1edkt2_i0505-tdline = lv_expnr_i0505.
***          lst_e1edkt2_i0505-tdformat = lc_star.
***        ENDIF.
***
****** Add text segments: E1EDKT1 & E1EDKT2
***        IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
***          lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_expnr_ag_i0505 ]-sap_value OPTIONAL ).
***          lst_e1edkt1_i0505-tsspras = sy-langu.
***          lst_e1edkt1_i0505-tsspras_iso = lv_laiso.
***
***          CLEAR lst_edidd_i0505.
***          lst_edidd_i0505-hlevel = lc_h02_i0505.
***          lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
***          lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
***          APPEND lst_edidd_i0505 TO int_edidd.
***
***          CLEAR lst_edidd_i0505.
***          lst_edidd_i0505-hlevel = lc_h03_i0505.
***          lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
***          lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
***          APPEND lst_edidd_i0505 TO int_edidd.
***
***        ENDIF.

***EIKTO_AG
*** Populate EIKTO for Sold-to to E1EDKT2-TDLINE and populate qualifier KAG2 to E1EDKT1-TDID and append both segments to INT_EDIDD
        CLEAR: lst_e1edkt1_i0505, lst_e1edkt2_i0505.
        SELECT SINGLE eikto
                      FROM knb1
                      INTO @DATA(lv_eikto)
                      WHERE kunnr = @lv_kunnr_i0505
                      AND   bukrs IS NOT NULL.
        IF sy-subrc = 0.
          lst_e1edkt2_i0505-tdline = lv_eikto.
          lst_e1edkt2_i0505-tdformat = lc_star.
        ENDIF.

*** Add text segments: E1EDKT1 & E1EDKT2
        IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
          lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_eikto_ag_i0505 ]-sap_value OPTIONAL ).
          lst_e1edkt1_i0505-tsspras = sy-langu.
          lst_e1edkt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h02_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

        ENDIF.

        CLEAR: lv_kunnr_i0505, lv_expnr_i0505.
        lv_kunnr_i0505 = lst_e1edka1_i0505-partn.
******EXPNR_WE
****** Populate EXPNR for Ship-to to E1EDKT2-TDLINE and populate qualifier KWE1 to E1EDKT1-TDID and append both segments to INT_EDIDD
***        CLEAR: lst_e1edkt1_i0505, lst_e1edkt2_i0505.
***        SELECT SINGLE expnr
***                      FROM edpar
***                      INTO lv_expnr_i0505
***                      WHERE kunnr = lv_kunnr_i0505
***                      AND   parvw = lc_we_i0505
***                      AND   expnr IS NOT NULL.
***        IF sy-subrc = 0.
***          lst_e1edkt2_i0505-tdline = lv_expnr_i0505.
***          lst_e1edkt2_i0505-tdformat = lc_star.
***        ENDIF.
***
****** Add text segments: E1EDKT1 & E1EDKT2
***        IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
***          lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_expnr_we_i0505 ]-sap_value OPTIONAL ).
***          lst_e1edkt1_i0505-tsspras = sy-langu.
***          lst_e1edkt1_i0505-tsspras_iso = lv_laiso.
***
***          CLEAR lst_edidd_i0505.
***          lst_edidd_i0505-hlevel = lc_h02_i0505.
***          lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
***          lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
***          APPEND lst_edidd_i0505 TO int_edidd.
***
***          CLEAR lst_edidd_i0505.
***          lst_edidd_i0505-hlevel = lc_h03_i0505.
***          lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
***          lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
***          APPEND lst_edidd_i0505 TO int_edidd.
***
***        ENDIF.

***EIKTO_WE
*** Populate EIKTO for Ship-to to E1EDKT2-TDLINE and populate qualifier KWE1 to E1EDKT1-TDID and append both segments to INT_EDIDD
        CLEAR: lst_e1edkt1_i0505, lst_e1edkt2_i0505.
        SELECT SINGLE eikto
                    FROM knb1
                    INTO lv_eikto
                    WHERE kunnr = lv_kunnr_i0505
                    AND   bukrs IS NOT NULL.
        IF sy-subrc = 0.
          lst_e1edkt2_i0505-tdline = lv_eikto.
          lst_e1edkt2_i0505-tdformat = lc_star.
        ENDIF.

*** Add text segments: E1EDKT1 & E1EDKT2
        IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
          lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_eikto_we_i0505 ]-sap_value OPTIONAL ).
          lst_e1edkt1_i0505-tsspras = sy-langu.
          lst_e1edkt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h02_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** Header level VAT

        DATA(li_dikomv) = dikomv[].
        DELETE li_dikomv WHERE kschl <> lc_zitr.
        SORT li_dikomv BY kbetr ASCENDING.
        DELETE li_dikomv WHERE kbetr IS INITIAL.

        CLEAR: lst_e1edkt1_i0505, lst_e1edkt2_i0505.
        IF li_dikomv[] IS NOT INITIAL.
          lv_kbetr = VALUE #( li_dikomv[ 1 ]-kbetr OPTIONAL ).
          lv_kbetr = lv_kbetr / 10.
          lst_e1edkt2_i0505-tdline = lv_kbetr.
        ELSE.
          CLEAR lv_kbetr_init.
          lst_e1edkt2_i0505-tdline = lv_kbetr_init.
        ENDIF.

        CONDENSE lst_e1edkt2_i0505-tdline.
        lst_e1edkt2_i0505-tdformat = lc_star.
*** Add text segments: E1EDKT1 & E1EDKT2
        IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
          lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_header_vat ]-sap_value OPTIONAL ).
          lst_e1edkt1_i0505-tsspras = sy-langu.
          lst_e1edkt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h02_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** VAT Registration Number
        CLEAR lv_kunnr_i0505.
        lv_kunnr_i0505 = lst_e1edka1_i0505-partn.
        SELECT SINGLE stceg
               FROM kna1
               INTO lv_stceg
               WHERE kunnr = lv_kunnr_i0505.
        IF sy-subrc = 0.
          lst_e1edkt2_i0505-tdline = lv_stceg.
          CONDENSE lst_e1edkt2_i0505-tdline.
          lst_e1edkt2_i0505-tdformat = lc_star.
*** Add text segments: E1EDKT1 & E1EDKT2
          IF lst_e1edkt2_i0505-tdline IS NOT INITIAL.
            lst_e1edkt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_vat_reg ]-sap_value OPTIONAL ).
            lst_e1edkt1_i0505-tsspras = sy-langu.
            lst_e1edkt1_i0505-tsspras_iso = lv_laiso.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h02_i0505.
            lst_edidd_i0505-segnam = lc_e1edkt1_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edkt1_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h03_i0505.
            lst_edidd_i0505-segnam = lc_e1edkt2_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edkt2_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.
          ENDIF.
        ENDIF.

*** After adding header text segments, add deleted E1EDP01 record from temporary work area
        APPEND lst_edidd_i0505_tmp TO int_edidd.
        CLEAR lst_edidd_i0505_tmp.

      ENDIF.


    WHEN 'E1EDP35' .
*** E1EDP35 segments are being populated based on item MVGR1/MVGR2/MVGR3/MVGR4/MVGR5/KDKG1/KDKG2/KDKG3/KDKG4/KDKG5 values.
*** So, checking for last iteration of E1EDP35 segment
      CLEAR: lst_e1edp35, li_e1edp35[], lv_qualz, lv_cusadd.

      lst_e1edp35_i0505 = int_edidd-sdata.

      IF dxvbap-mvgr1 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_001.
        lst_e1edp35-cusadd = dxvbap-mvgr1.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.
      IF dxvbap-mvgr2 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_002.
        lst_e1edp35-cusadd = dxvbap-mvgr2.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.
      IF dxvbap-mvgr3 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_003.
        lst_e1edp35-cusadd = dxvbap-mvgr3.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.
      IF dxvbap-mvgr4 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_004.
        lst_e1edp35-cusadd = dxvbap-mvgr4.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.
      IF dxvbap-mvgr5 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_005.
        lst_e1edp35-cusadd = dxvbap-mvgr5.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      IF dxvbkd-kdkg1 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_006.
        lst_e1edp35-cusadd = dxvbkd-kdkg1.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      IF dxvbkd-kdkg2 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_007.
        lst_e1edp35-cusadd = dxvbkd-kdkg2.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      IF dxvbkd-kdkg3 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_008.
        lst_e1edp35-cusadd = dxvbkd-kdkg3.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      IF dxvbkd-kdkg4 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_009.
        lst_e1edp35-cusadd = dxvbkd-kdkg4.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      IF dxvbkd-kdkg5 IS NOT INITIAL.
        lst_e1edp35-qualz = lc_010.
        lst_e1edp35-cusadd = dxvbkd-kdkg5.
        APPEND lst_e1edp35 TO li_e1edp35.
        CLEAR lst_e1edp35.
      ENDIF.

      SORT li_e1edp35 BY qualz.
      DELETE li_e1edp35 WHERE cusadd IS INITIAL.
      SORT li_e1edp35 BY qualz DESCENDING.

*** Get current E1EDP35 qualifier number
      lv_qualz = VALUE #( li_e1edp35[ 1 ]-qualz OPTIONAL ).
*** Get current E1EDP35 qualifier value
      lv_cusadd = VALUE #( li_e1edp35[ 1 ]-cusadd OPTIONAL ).

*** Check for last E1EDP35 segment for line item
      IF lv_qualz = lst_e1edp35_i0505-qualz AND lv_cusadd = lst_e1edp35_i0505-cusadd.
        CLEAR: lir_mstae[], lir_abgru[].

        lir_mstae-sign = lc_i.
        lir_mstae-option = lc_eq.
        lir_mstae-low = VALUE #( li_constants[ param1 = lc_mstae_n ]-sap_value OPTIONAL ).
        APPEND lir_mstae.

        lir_mstae-sign = lc_i.
        lir_mstae-option = lc_eq.
        lir_mstae-low = VALUE #( li_constants[ param1 = lc_mstae_p ]-sap_value OPTIONAL ).
        APPEND lir_mstae.

        LOOP AT li_constants INTO DATA(lst_constants) WHERE param1 = lc_augru.
          lir_abgru-sign = lc_i.
          lir_abgru-option = lc_eq.
          lir_abgru-low = lst_constants-sap_value.
          APPEND lir_abgru.
        ENDLOOP.

*** Add item level text segmants
        lst_e1edk01_i0505 = VALUE #( int_edidd[ segnam = lc_e1edk01_i0505 ]-sdata OPTIONAL ).
        lv_vbeln_i0505 = lst_e1edk01_i0505-belnr.

*** Fetch reuired values from VBAP table
        SELECT SINGLE kwmeng,
               kbmeng,
               kzwi1,
               kzwi2,
               kzwi3,
               kzwi4,
               kzwi5
               FROM vbap
               INTO @DATA(ls_vbap)
               WHERE vbeln = @lv_vbeln_i0505
               AND   posnr = @dxvbap-posnr.
        IF sy-subrc <> 0.
          CLEAR ls_vbap.
        ENDIF.

        lv_matnr_i0505 = dxvbap-matnr.

*** Fetch mstae and ismpubldate from mara
        SELECT SINGLE mstae, ismpubldate
                      FROM mara
                      INTO @DATA(ls_mara)
                      WHERE matnr = @lv_matnr_i0505.
        IF sy-subrc <> 0.
          CLEAR ls_mara.
        ENDIF.

*** ADDITIONAL DELIVERY QUANTITY
*** If mstae is in range lir_mstae of values then populate with value of vbap-kwmeng - vbap-kbmeng
*** If not is range then populate with all zeros
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
        IF ls_mara-mstae IN lir_mstae[].
          lst_e1edpt2_i0505-tdline = ls_vbap-kwmeng - ls_vbap-kbmeng.
        ELSE.
          lst_e1edpt2_i0505-tdline = lc_zero.
        ENDIF.
        CONDENSE lst_e1edpt2_i0505-tdline.
        lst_e1edpt2_i0505-tdformat = lc_star.

*** Add text segments
        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_zaddqty_i0505 ]-sap_value OPTIONAL ).     "KP01
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** AVAILABILITY DATE 1
*** Populate mara-ismpubldate to tdline
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
        lst_e1edpt2_i0505-tdline = ls_mara-ismpubldate.
        lst_e1edpt2_i0505-tdformat = lc_star.

        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_ismpubldate_i0505 ]-sap_value OPTIONAL ).   "KP02
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** QUANTITY DELIVERED DEVIATION
*** If vbap-kbmeng NE 0 the populate value of vbap-kwmeng - vbap-kbmeng
*** else populate with vbap-kwmeng
        IF ls_vbap-kwmeng <> ls_vbap-kbmeng.
          CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
          IF ls_vbap-kbmeng <> 0.
            lst_e1edpt2_i0505-tdline = ls_vbap-kwmeng - ls_vbap-kbmeng.
          ELSE.
            lst_e1edpt2_i0505-tdline = ls_vbap-kwmeng.
          ENDIF.
          CONDENSE lst_e1edpt2_i0505-tdline.
          lst_e1edpt2_i0505-tdformat = lc_star.

          IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
            lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_zdiffqty_i0505 ]-sap_value OPTIONAL ).      "KP03
            lst_e1edpt1_i0505-tsspras = sy-langu.
            lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h03_i0505.
            lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h04_i0505.
            lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.
          ENDIF.
        ENDIF.

*** TYPE OF QUANTITY DELIVERED DEVIATION
*** If mara-mstae is not in lir_mstae range of values then populate constant value with parameter REJCODE_CP
        IF ls_vbap-kwmeng <> ls_vbap-kbmeng.
          CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
          IF ls_mara-mstae NOT IN lir_mstae[].
            lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejcode_cp ]-sap_value OPTIONAL ).
          ELSE.
*** If mara-mstae is in lir_mstae range of values then populate constant value with parameter REJCODE_BP
            lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejcode_bp ]-sap_value OPTIONAL ).
          ENDIF.
          lst_e1edpt2_i0505-tdformat = lc_star.

          IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
            lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_zrejcod_i0505 ]-sap_value OPTIONAL ).       "KP04
            lst_e1edpt1_i0505-tsspras = sy-langu.
            lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h03_i0505.
            lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.

            CLEAR lst_edidd_i0505.
            lst_edidd_i0505-hlevel = lc_h04_i0505.
            lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
            lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
            APPEND lst_edidd_i0505 TO int_edidd.
          ENDIF.
        ENDIF.

*** REASON FOR THE QUANTITY DELIVERED DEVIATION
*** If mara-mstae is in lir_mstae range table and vbap-abgru is 99 then populate constant value with parameter REJREASON_CTR001
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
**        IF ls_mara-mstae IN lir_mstae[] AND dxvbap-abgru = VALUE #( li_constants[ param1 = lc_augru_99 ]-sap_value OPTIONAL ).
**          lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejreason_ctr001 ]-sap_value OPTIONAL ).
***** If mara-mstae is not in lir_mstae range table and vbap-abgru is 99 then populate constant value with parameter REJREASON_CTR002
**        ELSEIF ls_mara-mstae NOT IN lir_mstae[] AND dxvbap-abgru = VALUE #( li_constants[ param1 = lc_augru_98 ]-sap_value OPTIONAL ).
**          lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejreason_ctr002 ]-sap_value OPTIONAL ).
**        ENDIF.
        IF dxvbap-abgru IN lir_abgru.
          IF ls_mara-mstae IN lir_mstae[].
            lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejreason_ctr001 ]-sap_value OPTIONAL ).
          ELSE.
            lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_rejreason_ctr002 ]-sap_value OPTIONAL ).
          ENDIF.

        ENDIF.

        lst_e1edpt2_i0505-tdformat = lc_star.

        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_zrejrea_i0505 ]-sap_value OPTIONAL ).       "KP05
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** CODE BACK ORDER
*** If mara-mstae is not in lir_mstae range table then populate constant value with parameter BACKORD_N
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
        IF ls_mara-mstae NOT IN lir_mstae[].
          lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_backord_n ]-sap_value OPTIONAL ).
*** If mara-mstae is not in lir_mstae range table then populate constant value with parameter BACKORD_J
        ELSE.
          lst_e1edpt2_i0505-tdline = VALUE #( li_constants[ param1 = lc_backord_j ]-sap_value OPTIONAL ).
        ENDIF.
        lst_e1edpt2_i0505-tdformat = lc_star.

        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_zbackord_i0505 ]-sap_value OPTIONAL ).      "KP06
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** REPORT CODE
*** Populate mara-mstae to tdline
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.
        lst_e1edpt2_i0505-tdline = ls_mara-mstae.
        lst_e1edpt2_i0505-tdformat = lc_star.

        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_mstae_i0505 ]-sap_value OPTIONAL ).         "KP07
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** INFORMATION PRICE FIXED EXCLUDING TAXES
*** Populate with vbap-kzwi1
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.

        lst_e1edpt2_i0505-tdline = dxvbap-kzwi1.
        CONDENSE lst_e1edpt2_i0505-tdline.
        lst_e1edpt2_i0505-tdformat = lc_star.
        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_kzwi1_i0505 ]-sap_value OPTIONAL ).         "KP09
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** NET COSTING INCLUDING TAXES
*** Populate with vbap-kzwi2
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.

        lst_e1edpt2_i0505-tdline = dxvbap-kzwi2.
        CONDENSE lst_e1edpt2_i0505-tdline.
        lst_e1edpt2_i0505-tdformat = lc_star.
        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_kzwi2_i0505 ]-sap_value OPTIONAL ).         "KP10
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** NET COSTING EXCLUDING TAXES
*** Populate with vbap-kzwi3
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.

        lst_e1edpt2_i0505-tdline = dxvbap-kzwi3.
        CONDENSE lst_e1edpt2_i0505-tdline.
        lst_e1edpt2_i0505-tdformat = lc_star.
        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_kzwi3_i0505 ]-sap_value OPTIONAL ).         "KP11
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

*** INFORMATION PRICE RECOMMENDED EXCLUDING TAXES
*** Populate with vbap-kzwi4
        CLEAR: lst_e1edpt1_i0505, lst_e1edpt2_i0505.

        lst_e1edpt2_i0505-tdline = dxvbap-kzwi4.
        CONDENSE lst_e1edpt2_i0505-tdline.
        lst_e1edpt2_i0505-tdformat = lc_star.
        IF lst_e1edpt2_i0505-tdline IS NOT INITIAL.
          lst_e1edpt1_i0505-tdid = VALUE #( li_constants[ param1 = lc_kzwi4_i0505 ]-sap_value OPTIONAL ).       "KP12
          lst_e1edpt1_i0505-tsspras = sy-langu.
          lst_e1edpt1_i0505-tsspras_iso = lv_laiso.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h03_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt1_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt1_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.

          CLEAR lst_edidd_i0505.
          lst_edidd_i0505-hlevel = lc_h04_i0505.
          lst_edidd_i0505-segnam = lc_e1edpt2_i0505. " Adding new segment
          lst_edidd_i0505-sdata =  lst_e1edpt2_i0505.
          APPEND lst_edidd_i0505 TO int_edidd.
        ENDIF.

      ENDIF.

  ENDCASE.

ENDIF.
