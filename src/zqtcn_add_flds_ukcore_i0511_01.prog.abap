*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADD_FLDS_UKCORE_I0511_01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FLDS_UKCORE_I0511_01
* PROGRAM DESCRIPTION: Logic to add custom segment fields for UK Core
*                      Constant values have been maintained in table
*                      ZCAINTEG_MAPPING
* DEVELOPER          : Jagadeeswara Rao M (JMADAKA)
* CREATION DATE      : 2022-04-14
* OBJECT ID          : I0511 (EAM-6881)
* TRANSPORT NUMBER(S): ED2K927148
*----------------------------------------------------------------------*

DATA: lst_edidd_i0511            TYPE edidd,              " Data record (IDoc)
      li_constants_i0511         TYPE ztca_integ_mapping,
      lst_e1edp01_i0511          TYPE e1edp01,            " IDoc: Document Header Partner Information
      lst_z1qtc_e1edp01_01_i0511 TYPE z1qtc_e1edp01_01,   " IDoc: Document Header Partner Information
      lv_line_i0511              TYPE sytabix,
      ls_return_i0511            TYPE bapireturn,
      li_wmdvsx                  TYPE TABLE OF bapiwmdvs,
      li_wmdvex                  TYPE TABLE OF bapiwmdve,
      lv_av_qty_plt              TYPE mng01,
      lv_com_qty                 TYPE mng06,
      lv_bmng2                   TYPE mng06,
      lv_init_qty                TYPE mng01,
      lv_ismcode                 TYPE ismidentcode,
      lv_flag                    TYPE char1,
      lv_vbeln_i0511             TYPE vbeln,
      li_cdhdr                   TYPE TABLE OF cdhdr,
      li_cdpos                   TYPE TABLE OF cdpos,
      lv_changenr                TYPE cdchangenr,
      lv_tabkey                  TYPE cdtabkey,
      lv_value_old               TYPE mng01,
      lv_value_new               TYPE mng01,
      lv_value_diff              TYPE mng01.


CONSTANTS: lc_devid_i0511            TYPE zdevid VALUE 'I0511.1',
           lc_z1qtc_e1edp01_01_i0511 TYPE edilsegtyp  VALUE 'Z1QTC_E1EDP01_01',         " Z1QTC_E1EDP01_01 of type CHAR7
           lc_zzsourcesys_i0511      TYPE rvari_vnam VALUE 'ZZSOURCESYS',
           lc_zzukrsvd_i0511         TYPE rvari_vnam VALUE 'ZZUKRSVD',
           lc_zzresadj_i0511         TYPE rvari_vnam VALUE 'ZZRESADJ',
           lc_zzclient_i0511         TYPE rvari_vnam VALUE 'ZZCLIENT',
           lc_h03_i0511              TYPE edi_hlevel VALUE '03',
           lc_zean                   TYPE char4 VALUE 'ZEAN',
           lc_check_rule             TYPE prreg VALUE 'Z1',
           lc_objectclas             TYPE cdobjectcl VALUE 'VERKBELEG',
           lc_u                      TYPE cdchngindh VALUE 'U',
           lc_tabname                TYPE tabname VALUE 'VBEP',
           lc_fname                  TYPE fieldname VALUE 'BMENG'.


DESCRIBE         TABLE int_edidd LINES lv_line_i0511.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd INTO lst_edidd_i0511 INDEX lv_line_i0511.
IF sy-subrc = 0.

*** Get constant values from zcainteg_mapping table
  CLEAR li_constants_i0511[].
  zca_utilities=>get_integ_constants( EXPORTING im_devid = lc_devid_i0511
                                      IMPORTING et_constants = li_constants_i0511 ).
  IF li_constants_i0511[] IS NOT INITIAL.
    SORT li_constants_i0511 BY param1 param2 srno.
  ENDIF.

  CASE lst_edidd_i0511-segnam.

    WHEN 'E1EDP01'.

      lst_e1edp01_i0511 = lst_edidd_i0511-sdata.

*** Matnr
      SELECT SINGLE bismt,
                    meins,
                    ismtitle
                    FROM mara
                    INTO @DATA(lst_mara_i0511)
                    WHERE matnr = @dxvbap-matnr.
      IF sy-subrc = 0.
        lst_e1edp01_i0511-matnr = lst_mara_i0511-bismt.
      ENDIF.

*** Menge
      CLEAR lv_flag.
      IF dxvbap-erdat = sy-datum OR dxvbap-aedat = sy-datum.
        LOOP AT dxvbep INTO DATA(lst_dxvbep) WHERE posnr = dxvbap-posnr.
          IF lst_dxvbep-bmeng IS NOT INITIAL.
            lv_flag = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_flag IS NOT INITIAL.
          CLEAR: lv_av_qty_plt, ls_return_i0511, li_wmdvsx[], li_wmdvex[], lv_init_qty.
          CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
            EXPORTING
              plant      = dxvbap-werks
              material   = dxvbap-matnr
              unit       = lst_mara_i0511-meins
              check_rule = lc_check_rule
            IMPORTING
              av_qty_plt = lv_av_qty_plt
              return     = ls_return_i0511
            TABLES
              wmdvsx     = li_wmdvsx
              wmdvex     = li_wmdvex.
          IF li_wmdvex[] IS NOT INITIAL.
*** EDC Firm stock
            lst_e1edp01_i0511-menge = lv_av_qty_plt.
            CONDENSE lst_e1edp01_i0511-menge.



*** EDC VCH Reserved stock
            CLEAR: lv_com_qty, lv_bmng2.
            lv_com_qty =  VALUE #( li_wmdvex[ 1 ]-com_qty OPTIONAL ).

            IF sy-tcode = 'VKM3'.
              LOOP AT dxvbep INTO lst_dxvbep WHERE posnr = dxvbap-posnr.
                IF lst_dxvbep-bmeng IS NOT INITIAL.
                  lv_com_qty = lv_com_qty - lst_dxvbep-bmeng.
                ENDIF.
              ENDLOOP.
            ENDIF.

*** When changing the order quantity in change mode(VA02) BAPI BAPI_MATERIAL_AVAILABILITY is not giving accurate values.
*** Hence, implimented below logic
            IF sy-tcode = 'VA02'.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = dxvbak-vbeln
                IMPORTING
                  output = lv_vbeln_i0511.

              SELECT * FROM cdhdr
                       INTO TABLE li_cdhdr
                       WHERE objectclas = lc_objectclas
                       AND objectid = lv_vbeln_i0511
                       AND change_ind = lc_u.
              IF sy-subrc = 0.
                SORT li_cdhdr BY udate utime DESCENDING.
                lv_changenr = VALUE #( li_cdhdr[ 1 ]-changenr OPTIONAL ).

                SELECT * FROM cdpos
                         INTO TABLE li_cdpos
                         WHERE objectclas = lc_objectclas
                         AND   objectid = lv_vbeln_i0511
                         AND   changenr = lv_changenr
                         AND   tabname = lc_tabname
                         AND   fname = lc_fname
                         AND   chngind = lc_u.
                IF sy-subrc = 0.
                  SORT li_cdpos BY tabkey.
                  LOOP AT dxvbep INTO lst_dxvbep WHERE posnr = dxvbap-posnr.
                    IF lst_dxvbep-bmeng IS NOT INITIAL.
                      lv_tabkey = | { sy-mandt }{ lst_dxvbep-vbeln }{ lst_dxvbep-posnr }{ lst_dxvbep-etenr } |.
                      CONDENSE lv_tabkey.
                      IF lst_dxvbep-bmeng <> VALUE #( li_cdpos[ tabkey = lv_tabkey ]-value_old OPTIONAL ).
                        lv_value_old = VALUE #( li_cdpos[ tabkey = lv_tabkey ]-value_old OPTIONAL ).
                        lv_value_new = VALUE #( li_cdpos[ tabkey = lv_tabkey ]-value_new OPTIONAL ).
                        lv_value_diff = lv_value_old - lv_value_new.
                        lv_com_qty = lv_com_qty + lv_value_diff.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ENDIF.

            lv_bmng2 = lv_av_qty_plt - lv_com_qty.
            lst_e1edp01_i0511-bmng2 = lv_bmng2.
            CONDENSE lst_e1edp01_i0511-bmng2.
          ELSE.
            IF lst_e1edp01_i0511-bmng2 IS INITIAL.
              lst_e1edp01_i0511-bmng2 = lv_init_qty.
              CONDENSE lst_e1edp01_i0511-bmng2 NO-GAPS.
            ENDIF.
          ENDIF.




****          DATA: lst_atpcs TYPE atpcs,
****                li_atpcs  TYPE TABLE OF atpcs.
****          CLEAR: lst_atpcs, li_atpcs.
****          lst_atpcs-matnr = dxvbap-matnr.
****          lst_atpcs-werks = dxvbap-werks.
****          lst_atpcs-prreg = lc_check_rule.
****          lst_atpcs-chmod = 'EXP'.
****          lst_atpcs-delkz = 'VC'.
****          lst_atpcs-xline = 1.
****          lst_atpcs-trtyp = 'A'.
****          lst_atpcs-idxatp = '1'.
****          lst_atpcs-resmd = 'X'.
****          lst_atpcs-chkflg = 'X'.
****
****          APPEND lst_atpcs TO li_atpcs.
****          CLEAR lst_atpcs.
****          CALL FUNCTION 'AVAILABILITY_CHECK'
****            TABLES
****              p_atpcsx = li_atpcs.
****          IF sy-subrc = 0.
****            lst_e1edp01_i0511-menge = VALUE #( li_atpcs[ 1 ]-sumzg OPTIONAL ).
****            CONDENSE lst_e1edp01_i0511-menge.
****
****            lst_e1edp01_i0511-bmng2 = VALUE #( li_atpcs[ 1 ]-sumba OPTIONAL ).
****            CONDENSE lst_e1edp01_i0511-bmng2.
****          ENDIF.

        ELSE.

          IF lst_e1edp01_i0511-bmng2 IS INITIAL.
            lst_e1edp01_i0511-bmng2 = lv_init_qty.
            CONDENSE lst_e1edp01_i0511-bmng2 NO-GAPS.
          ENDIF.

        ENDIF.
      ENDIF.

*** Modify int_edidd internal table
      lst_edidd_i0511-sdata = lst_e1edp01_i0511.
      MODIFY int_edidd FROM lst_edidd_i0511 INDEX lv_line_i0511 TRANSPORTING sdata.


*** Fill custom segment
*** ISBN
      CLEAR lv_ismcode.
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
        EXPORTING
          im_idcodetype      = lc_zean
          im_sap_material    = dxvbap-matnr
        IMPORTING
          ex_legacy_material = lv_ismcode
        EXCEPTIONS
          wrong_input_values = 1
          OTHERS             = 2.
      IF sy-subrc           = 0.
        lst_z1qtc_e1edp01_01_i0511-vkuegru_text = lv_ismcode.
      ENDIF.

      lst_z1qtc_e1edp01_01_i0511-zzrgcode = lst_mara_i0511-ismtitle.
      lst_z1qtc_e1edp01_01_i0511-zzshpocanc = VALUE #( li_constants_i0511[ param1 = lc_zzsourcesys_i0511 ]-sap_value OPTIONAL ).
      lst_z1qtc_e1edp01_01_i0511-zzdealtyp = VALUE #( li_constants_i0511[ param1 = lc_zzukrsvd_i0511 ]-sap_value OPTIONAL ).
      lst_z1qtc_e1edp01_01_i0511-zzclustyp = VALUE #( li_constants_i0511[ param1 = lc_zzresadj_i0511 ]-sap_value OPTIONAL ).
      lst_z1qtc_e1edp01_01_i0511-zzvyp = VALUE #( li_constants_i0511[ param1 = lc_zzclient_i0511 ]-sap_value OPTIONAL ).

      CLEAR lst_edidd_i0511.
      lst_edidd_i0511-hlevel = lc_h03_i0511.
      lst_edidd_i0511-segnam = lc_z1qtc_e1edp01_01_i0511. " Adding new segment
      lst_edidd_i0511-sdata =  lst_z1qtc_e1edp01_01_i0511.
      APPEND lst_edidd_i0511 TO int_edidd.
      CLEAR lst_edidd_i0511.

  ENDCASE.

ENDIF.
