*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ZPPV_INTERFACE
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ZPPV_INTERFACE
* PROGRAM DESCRIPTION: Include for customer population Z24
* DEVELOPER: NPOLINA (Nageswara)
* CREATION DATE:   06-Nov-2019
* OBJECT ID: I0230.2/ERPM935
* TRANSPORT NUMBER(S): ED2K916726
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K917936
* REFERENCE NO:ERPM-15497
* DEVELOPER:  Prabhu(PTUFARAM)
* DATE: 04/09/2020
* DESCRIPTION:Extend the Historical ISSN codes custom table search Logic for PPV orders
*             If legacy material not found in FM, consider Token interface table
*&---------------------------------------------------------------------*

  DATA:lv_idoc_i02302  TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]',
       lv_mat_num      TYPE ismidentcode,
       lv_material_2   TYPE matnr,
       lv_idcode_2     TYPE  ismidcodetype,
       lst_ze1edp01_22 TYPE z1qtc_e1edp01_01,
       lst_e1edp01_22  TYPE e1edp01,
       lst_e1edk01_22  TYPE e1edk01,
       lst_e1edk36_22  TYPE e1edk36,
       lst_e1edka1_22  TYPE e1edka1,
       lst_e1edpa1_22  TYPE e1edpa1,
       lv_issue        TYPE ismnrimjahr,  "Issue Number (in Year Number)
       lv_issyr        TYPE ismjahrgang,  "Media issue year number
       lv_volume2      TYPE mpg_lfdnr,    "Media issue Volume
       lv_medprod      TYPE ismrefmdprod,     " Media Product
       lv_matnr_prod   TYPE ismmatnr_issue,     " Media issue
       lst_ze1edka1_22 TYPE z1qtc_e1edka1_01,
       lst_ze1edk01_22 TYPE z1qtc_e1edk01_01,
       lv_ag(1)        TYPE c,
       lv_we(1)        TYPE c,
       lv_mpr(1)       TYPE c,
       lv_segnum(6)    TYPE n,
       lv_segnum2(6)   TYPE n,
       lst_e1edp19_935 TYPE e1edp19.

  CONSTANTS: lc_e1edp19_2        TYPE edilsegtyp    VALUE 'E1EDP19',
             lc_e1edp01_2        TYPE edilsegtyp    VALUE 'E1EDP01',
             lc_e1edpa1_22       TYPE edilsegtyp    VALUE 'E1EDPA1',
             lc_e1edpt1_2        TYPE edilsegtyp    VALUE 'E1EDPT1',
             lc_e1edpt2_2        TYPE edilsegtyp    VALUE 'E1EDPT2',
             lc_e1edp05_22       TYPE edilsegtyp    VALUE 'E1EDP05',
             lc_e1edp35_22       TYPE edilsegtyp    VALUE 'E1EDP35',
             lc_e1edk01_22       TYPE edilsegtyp    VALUE 'E1EDK01',
             lc_e1edk03_22       TYPE edilsegtyp    VALUE 'E1EDK03',
             lc_e1edk36_22       TYPE edilsegtyp    VALUE 'E1EDK36',
             lc_e1edk02_22       TYPE edilsegtyp    VALUE 'E1EDK02',
             lc_e1edk14_22       TYPE edilsegtyp    VALUE 'E1EDK02',
             lc_e1edka1_22       TYPE edilsegtyp    VALUE 'E1EDKA1',
             lc_ag_22            TYPE parvw         VALUE 'AG',
             lc_we_22            TYPE parvw         VALUE 'WE',
             lc_mpr_22           TYPE kschl         VALUE 'ZMPR',
             lc_z1qtc_e1edp01_02 TYPE char16 VALUE 'Z1QTC_E1EDP01_01',
             lc_z1qtc_e1edka1_02 TYPE char16 VALUE 'Z1QTC_E1EDKA1_01',
             lc_z1qtc_e1edk01_02 TYPE char16 VALUE 'Z1QTC_E1EDK01_01',
             lc_devid2           TYPE zdevid     VALUE 'I0230.2'.

  STATICS:lv_chk(1)       TYPE c,
          lv_addr_char(1) TYPE c.

  FIELD-SYMBOLS:
    <li_idoc_rec_i02302> TYPE edidd_tt.

  IF lv_addr_char IS INITIAL.
    SELECT SINGLE low FROM zcaconstant
      INTO lv_addr_char
      WHERE devid = lc_devid2.
  ENDIF.

  CASE segment-segnam.
    WHEN lc_e1edk01_22.
* IDOC data validation
      ASSIGN (lv_idoc_i02302) TO <li_idoc_rec_i02302>.
      LOOP AT <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_va>).

* Payment card authorization inputs check
        IF <lfs_va>-segnam = lc_z1qtc_e1edk01_02.
          lst_ze1edk01_22 = <lfs_va>-sdata.
          IF lst_ze1edk01_22-aunum IS INITIAL.
            MESSAGE e344(zqtc_r2) RAISING user_error.   "Auth code
          ENDIF.

          IF lst_ze1edk01_22-autwr IS INITIAL.
            MESSAGE e345(zqtc_r2) RAISING user_error.   " Auth Amt
          ENDIF.

          IF lst_ze1edk01_22-auth_order_id IS INITIAL. " ED2K917118
            MESSAGE e349(zqtc_r2) RAISING user_error.   " Auth Order ID
          ENDIF.

        ENDIF.

* Payment card details check
        IF <lfs_va>-segnam = lc_e1edk36_22.
          lst_e1edk36_22 = <lfs_va>-sdata.
          IF lst_e1edk36_22-ccnum IS INITIAL.
            MESSAGE e346(zqtc_r2) RAISING user_error.   " Payment cards: Card number
          ENDIF.

          IF lst_e1edk36_22-ccins IS INITIAL.
            MESSAGE e347(zqtc_r2) RAISING user_error.   " Payment cards: Card type
          ENDIF.

          IF lst_e1edk36_22-exdatbi IS INITIAL.
            MESSAGE e348(zqtc_r2) RAISING user_error.   " Payment Cards: Valid To
          ENDIF.
        ENDIF.

* ZPPV Order number check
        IF <lfs_va>-segnam = lc_e1edk02_22 AND <lfs_va>-sdata+0(3) = '066' AND <lfs_va>-sdata+3(35) IS INITIAL.
          MESSAGE e321(zqtc_r2) RAISING user_error.  "Order Number
        ENDIF.

* Document currency check
        IF <lfs_va>-segnam = lc_e1edk01_22 AND <lfs_va>-sdata+4(3) IS INITIAL.  "Currency
          MESSAGE e322(zqtc_r2) RAISING user_error.
        ENDIF.

* Sales data check
        IF <lfs_va>-segnam = lc_e1edk14_22 AND <lfs_va>-sdata+3(35) IS INITIAL.
          IF  <lfs_va>-sdata+0(3) = '008'.
            MESSAGE e324(zqtc_r2) RAISING user_error.     "Sales Org
          ELSEIF  <lfs_va>-sdata+0(3) = '006' .
            MESSAGE e325(zqtc_r2) RAISING user_error.     " Division
          ELSEIF  <lfs_va>-sdata+0(3) = '007'.
            MESSAGE e326(zqtc_r2) RAISING user_error.    "Distribution Channel
          ELSEIF <lfs_va>-sdata+0(3) = '012' .
            MESSAGE e327(zqtc_r2) RAISING user_error.    "Order type
          ELSEIF <lfs_va>-sdata+0(3) = '013' .
            MESSAGE e328(zqtc_r2) RAISING user_error.    "PO Type
          ELSEIF <lfs_va>-sdata+0(3) = '016'    .
*            MESSAGE e329(zqtc_r2) RAISING user_error.
          ENDIF.
        ENDIF.                                "IF <lfs_va>-segnam = 'E1EDK14'

        IF <lfs_va>-segnam = lc_e1edka1_22.  " 'E1EDKA1'.
          lst_e1edka1_22 = <lfs_va>-sdata.
          IF lst_e1edka1_22-parvw = lc_ag_22. "'AG'.
            lv_ag = abap_true.
          ENDIF.

          IF lst_e1edka1_22-parvw = lc_we_22. "'WE'.
            lv_we = abap_true.
          ENDIF.

* Address check
          IF lst_e1edka1_22-name1 IS INITIAL.
            MESSAGE e329(zqtc_r2) RAISING user_error.    "First Name
          ENDIF.

          IF lst_e1edka1_22-name1 IS INITIAL.
            MESSAGE e334(zqtc_r2) RAISING user_error.   "Last name
          ENDIF.

          IF lst_e1edka1_22-stras IS INITIAL.
            MESSAGE e330(zqtc_r2) RAISING user_error.   " STreet
          ENDIF.

          IF lst_e1edka1_22-ort01 IS INITIAL.
            MESSAGE e331(zqtc_r2) RAISING user_error.   " City
          ENDIF.

          IF lst_e1edka1_22-land1 IS INITIAL.
            MESSAGE e332(zqtc_r2) RAISING user_error.   "Country
          ENDIF.

          IF lst_e1edka1_22-pstlz IS INITIAL.
            MESSAGE e333(zqtc_r2) RAISING user_error.   " Postal code
          ENDIF.

          IF lst_e1edka1_22-name2 IS INITIAL.
            lst_e1edka1_22-name2 = lv_addr_char.
          ENDIF.

          IF lst_e1edka1_22-hausn IS INITIAL.
            lst_e1edka1_22-hausn = lv_addr_char.
          ENDIF.

          IF lst_e1edka1_22-regio IS INITIAL.
            lst_e1edka1_22-regio = lv_addr_char.
          ENDIF.

          IF lst_e1edka1_22-pstl2 IS INITIAL.
            lst_e1edka1_22-pstl2 = lv_addr_char.
          ENDIF.

          IF lst_e1edka1_22-pfach IS INITIAL.
            lst_e1edka1_22-pfach = lv_addr_char.
          ENDIF.

          IF lst_e1edka1_22-telf1 IS INITIAL.
            lst_e1edka1_22-telf1 = lv_addr_char.
          ENDIF.

          <lfs_va>-sdata = lst_e1edka1_22 .

          IF lst_e1edka1_22-parvw NE lc_ag_22.
            READ TABLE <li_idoc_rec_i02302>  ASSIGNING FIELD-SYMBOL(<lfs_itmpart>) WITH KEY   segnam = 'E1EDPA1'
                                                                                              sdata+0(3) = lst_e1edka1_22-parvw.
            IF sy-subrc EQ 0.
              <lfs_itmpart>-sdata = lst_e1edka1_22.
            ENDIF.
          ENDIF.
        ENDIF.                                        "IF <lfs_va>-segnam = 'E1EDKA1'.

* Email ID check
        IF <lfs_va>-segnam = lc_z1qtc_e1edka1_02. "'Z1QTC_E1EDKA1_01'.
          lst_ze1edka1_22 = <lfs_va>-sdata.
          IF lst_ze1edka1_22-type IS INITIAL.
            MESSAGE e337(zqtc_r2) RAISING user_error.   " Partner type
          ELSEIF lst_ze1edka1_22-smtp_addr IS INITIAL AND ( lst_ze1edka1_22-type EQ lc_ag_22 OR lst_ze1edka1_22-type EQ lc_we_22 ).
            MESSAGE e338(zqtc_r2) RAISING user_error.   " Email ID
          ENDIF.
        ENDIF.

        IF <lfs_va>-segnam = lc_e1edk03_22. "'E1EDK03'.
          IF <lfs_va>-sdata+0(3) = '022' AND <lfs_va>-sdata+3(8) IS INITIAL.
            MESSAGE e339(zqtc_r2) RAISING user_error.      " PO Date
          ENDIF.
        ENDIF.

* Condition Type check
        IF <lfs_va>-segnam = lc_e1edp05_22. "'E1EDP05'.
          IF <lfs_va>-sdata+3(4) = lc_mpr_22. "'ZMPR'.
            lv_mpr = abap_true.
          ENDIF.
        ENDIF.

* Material group4 check
        IF <lfs_va>-segnam = lc_e1edp35_22. "'E1EDP35'.
          IF <lfs_va>-sdata+0(3) = '004' AND <lfs_va>-sdata+3(2) IS INITIAL.
            MESSAGE e340(zqtc_r2) RAISING user_error.          "Material Group 4
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lv_ag IS INITIAL.
        MESSAGE e335(zqtc_r2) RAISING user_error.   " Sold to
      ENDIF.

      IF lv_we IS INITIAL.
        MESSAGE e336(zqtc_r2) RAISING user_error.   " Ship to
      ENDIF.
      IF lv_mpr IS INITIAL.
        MESSAGE e341(zqtc_r2) RAISING user_error.   " ZMPR condition type
      ENDIF.

    WHEN lc_e1edp01_2.
      ASSIGN (lv_idoc_i02302) TO <li_idoc_rec_i02302>.
      IF <li_idoc_rec_i02302> IS ASSIGNED.
        lv_segnum = segment-segnum.
        lv_segnum = lv_segnum + 1.
        CLEAR:lv_idcode_2,lv_mat_num.
        LOOP AT <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_loop>) FROM  lv_segnum.
          IF <lfs_loop>-segnam = segment-segnam.
            EXIT.
          ELSEIF <lfs_loop>-segnam = lc_z1qtc_e1edp01_02.
            lst_ze1edp01_22 = <lfs_loop>-sdata.
            lv_idcode_2 = lst_ze1edp01_22-idcodetype.

            IF lst_ze1edp01_22-zzlicense_start_d IS INITIAL.
              MESSAGE e342(zqtc_r2) RAISING user_error.      " License Start date
            ENDIF.

            IF lst_ze1edp01_22-zzlicense_end_d IS INITIAL.
              MESSAGE e343(zqtc_r2) RAISING user_error.      " License End date
            ENDIF.
          ELSEIF <lfs_loop>-segnam = lc_e1edp19_2 AND <lfs_loop>-sdata+0(3) = '002'.
            CLEAR: lst_e1edp19_935,lv_segnum2.
            lst_e1edp19_935 = <lfs_loop>-sdata.
            lv_mat_num = lst_e1edp19_935-idtnr.
            lv_segnum2 = <lfs_loop>-segnum.
          ELSEIF <lfs_loop>-segnam = lc_e1edp19_2 AND <lfs_loop>-sdata+0(3) = '001'.
            CLEAR: lst_e1edp19_935,lv_segnum2.
            lst_e1edp19_935 = <lfs_loop>-sdata.
            IF lst_e1edp19_935-idtnr IS INITIAL.
              MESSAGE e320(zqtc_r2) RAISING user_error.         "Customer Material number
            ENDIF.
          ENDIF.

          IF lv_idcode_2 IS NOT INITIAL AND lv_mat_num IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_mat_num IS INITIAL.
          MESSAGE e318(zqtc_r2) RAISING user_error.   "Material Number
        ENDIF.

        IF lv_idcode_2 IS INITIAL.
          MESSAGE e319(zqtc_r2) RAISING user_error.   " Identification code
        ENDIF.

*   Calling FM to convert legacy material into SAP Material
        CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
          EXPORTING
            im_idcodetype      = lv_idcode_2          " Type of Identification Code
            im_legacy_material = lv_mat_num          " Legacy Material Number
          IMPORTING
            ex_sap_material    = lv_material_2 " SAP Material Number
          EXCEPTIONS
            wrong_input_values = 1
            OTHERS             = 2.
        IF sy-subrc EQ 0.
* BOC by  Prabhu ERPM-15497 #ED2K917936 4/9/2020
*--*Consider Token Interface Material number
          IF lv_material_2 IS INITIAL.
            SELECT SINGLE matnr
                     INTO @lv_material_2
                     FROM zqtc_order_token
                    WHERE issn = @lv_mat_num.
          ENDIF.
* EOC by  Prabhu ERPM-15497 #ED2K917936 4/9/2020
*   Get the VBAP structure data into local work area to process further
          IF lv_mat_num NE lv_material_2.
* Fetch Media issue product from JPTMGO

* Issue Volume
            READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read2>) WITH KEY segnam = lc_e1edpt1_2   "'E1EDPT1'
                                                                                          sdata+0(4) = '0033'.
            IF sy-subrc EQ 0.
              lv_segnum = sy-tabix + 1.
              READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read3>) WITH KEY segnam = lc_e1edpt2_2  "'E1EDPT2'
                                                                              segnum = lv_segnum.
              IF sy-subrc EQ 0.
                lv_volume2 = <lfs_read3>-sdata.
              ENDIF.
            ENDIF.

* Issue number
            READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read4>) WITH KEY segnam = lc_e1edpt1_2  "'E1EDPT1'
                                                                                          sdata+0(4) = '0026'.
            IF sy-subrc EQ 0.
              lv_segnum = sy-tabix + 1.
              READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read5>) WITH KEY segnam = lc_e1edpt2_2  "'E1EDPT2'
                                                                              segnum = lv_segnum.
              IF sy-subrc EQ 0.
                lv_issue = <lfs_read5>-sdata.
              ENDIF.
            ENDIF.

* Issue Year
            READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read6>) WITH KEY segnam = 'E1EDPT1'
                                                                                          sdata+0(4) = '0047'.
            IF sy-subrc EQ 0.
              lv_segnum = sy-tabix + 1.
              READ TABLE  <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_read7>) WITH KEY segnam = 'E1EDPT2'
                                                                              segnum = lv_segnum.
              IF sy-subrc EQ 0.
                lv_issyr = <lfs_read7>-sdata.
              ENDIF.
            ENDIF.

            IF lv_material_2 IS NOT INITIAL AND lv_volume2 IS NOT  INITIAL AND lv_issue IS NOT INITIAL AND lv_issyr IS NOT INITIAL.
              SELECT SINGLE matnr FROM jptmg0 INTO @DATA(lv_issmat2)
                WHERE med_prod = @lv_material_2
                  AND mpg_lfdnr = @lv_volume2
                  AND ismnrinyear = @lv_issue
                  AND ismyearnr = @lv_issyr.
              IF sy-subrc EQ 0.
                lv_material_2 = lv_issmat2.
              ENDIF.
            ENDIF.
            CLEAR lst_xvbap_st.
            lst_xvbap_st = dxvbap.
            lst_xvbap_st-matnr = lv_material_2.
            dxvbap = lst_xvbap_st.

            READ TABLE <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_idt>) WITH KEY segnum = lv_segnum2.
            IF sy-subrc EQ 0.
              lst_e1edp19_935 = <lfs_idt>-sdata.
              lst_e1edp19_935-idtnr = lv_material_2.
              <lfs_idt>-sdata = lst_e1edp19_935.
            ENDIF.
          ENDIF .
        ENDIF.
      ENDIF.
    WHEN lc_e1edpa1_22.
* IDOC data populating Header Partner info to Item partner info
      lst_e1edpa1_22 = segment-sdata.
      ASSIGN (lv_idoc_i02302) TO <li_idoc_rec_i02302>.
      READ TABLE <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_va2>) WITH KEY segnam = lc_e1edka1_22
                                                                                          sdata+0(3) = lst_e1edpa1_22-parvw.
      IF sy-subrc EQ 0.
        lst_e1edka1_22 = <lfs_va2>-sdata.
        MOVE-CORRESPONDING lst_e1edka1_22 TO lst_e1edpa1_22.
        READ TABLE <li_idoc_rec_i02302> ASSIGNING FIELD-SYMBOL(<lfs_va3>) WITH KEY segnam = lc_e1edpa1_22
                                                                                            sdata+0(3) = lst_e1edpa1_22-parvw.
        IF sy-subrc EQ 0.
          <lfs_va3>-sdata = lst_e1edpa1_22.
        ENDIF.
      ENDIF.
  ENDCASE.
