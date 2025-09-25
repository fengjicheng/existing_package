*----------------------------------------------------------------------*
*   INCLUDE LCSDSF03                                                   *
*----------------------------------------------------------------------*
*   Subprograms BOM-Distribution: Inbound Processing                   *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       FORM IDOC_TO_BOM_ITABS
*----------------------------------------------------------------------*
*       move and convert data from idoc to application internal tables
*  31G-45B : Segments E1STKOM and E1STPOM are used with wrong datatypes.
*            for these segments data must be transfered by other
*            fields.
*  46A     : E1STKON and E1STPON fixed the problem
*----------------------------------------------------------------------*
FORM idoc_to_bom_itabs TABLES idoc_data   STRUCTURE edidd
                              idoc_contrl STRUCTURE edidc.

  DATA:
*        edi work area
    edi_segment LIKE edidd,
*        help variables
    tmp_flag    LIKE csdata-xfeld,
    curr_index  LIKE sy-tabix,
    next_segm   LIKE sy-tabix,
    hlp_tabix   LIKE sy-tabix.

  DATA : r_bmein  LIKE stko-bmein,
         r_nlfmv  LIKE stpo-nlfmv,
         r_meins  LIKE stpo-meins,
         r_romei  LIKE stpo-romei,
         r_waers  LIKE stpo-waers,
         iso_code LIKE tcurc-isocd,
         l_bmeng  LIKE stzu-exstl,
         r_preis  LIKE stpo-preis.

  DATA: lv_struct_art TYPE abap_bool,
        ls_mara       TYPE mara,
        lv_matnr      TYPE matnr.
  CONSTANTS: cv_stlan TYPE stlan VALUE 3.

ENHANCEMENT-POINT idoc_to_bom_itabs_01 SPOTS es_saplcsds STATIC.


* reset the workareas
  CLEAR retail_flg.
  CLEAR mastb. REFRESH mastb.
  CLEAR kdstb. REFRESH kdstb.
  CLEAR dostb. REFRESH dostb.
  CLEAR stzub. REFRESH stzub.
  CLEAR stkob. REFRESH stkob.
  CLEAR stasb. REFRESH stasb.
  CLEAR stpoi. REFRESH stpoi.
  CLEAR stpub. REFRESH stpub.
  CLEAR api_dep_dat. REFRESH api_dep_dat.
  CLEAR api_dep_des. REFRESH api_dep_des.
  CLEAR api_dep_ord. REFRESH api_dep_ord.
  CLEAR api_dep_src. REFRESH api_dep_src.
  CLEAR api_dep_doc. REFRESH api_dep_doc.
  CLEAR no_data_tab. REFRESH no_data_tab.
  CLEAR api_ltx_lin. REFRESH api_ltx_lin.
  CLEAR api_stpu.    REFRESH api_stpu.                     "note 530922

* BUSINESS TRANSACTION EVENT for data
* ATTENTION : use of customer RFC will cause a 'commit work'
  CALL FUNCTION 'OPEN_FI_PERFORM_CS000160_E'
    EXPORTING
      idoc_control = idoc_contrl
    TABLES
      idoc_data    = idoc_data
    EXCEPTIONS
      idoc_error   = 1.

  IF sy-subrc <> 0.
    idoc_err_nr = sy-subrc.
  ENDIF.

* process IDoc
  LOOP AT idoc_data WHERE docnum = idoc_contrl-docnum.

    CASE idoc_data-segnam.

*-STZU----------------------
      WHEN c_segnam_e1stzum.
        e1stzum = idoc_data-sdata.
*       E1STZUM-EXSTL contains STKO-BMENG
*       E1STZUM-EXSTL_C contains STZU-EXSTL (since 46B)
        l_bmeng = e1stzum-exstl.
        e1stzum-exstl = e1stzum-exstl_c.
        e1stzum-exstl_c = l_bmeng.
        CLEAR e1stzum-stldt.                               "note 596491
        CLEAR e1stzum-stltm.                               "note 596491

*       set type of bom processing
        CASE e1stzum-msgfn.
          WHEN c_mf_change.
            stzub-vbkz  = c_bom_update.    "SMD change request
          WHEN c_mf_refresh.
            stzub-vbkz  = c_bom_change.    "direct change request
          WHEN c_mf_delete.
            stzub-vbkz  = c_bom_delete.
          WHEN OTHERS.
            stzub-vbkz  = c_bom_insert.
        ENDCASE.
*       Fill internal table, include NO_DATA-logic
        hlp_tabix = -1.
        PERFORM segment_to_itab USING 'E1STZUM' 'STZUB'
                                      'STZUB'   hlp_tabix.
*       recover ALE change number
        MOVE stzub-aenrl TO ale_aennr.
        CLEAR stzub-aenrl.
*       check date and time fields (initial value)
        APPEND stzub.
        IF NOT stzub-ltxsp IS INITIAL.
*         process bom long text
          PERFORM get_ltx_from_segments TABLES idoc_data
                                   USING  idoc_data-segnum
                                        c_segnam_e1szuth
                                        c_segnam_e1szutl
                                        '0'
                                        ''.
        ENDIF.

*-MAST----------------------
      WHEN c_segnam_e1mastm.
        e1mastm = idoc_data-sdata.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE mastb LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1MASTM' 'MASTB'
                                      'MASTB'   hlp_tabix.
        APPEND mastb.

        " Determine the material type of the header article; in case it is a structured article
        " it is not allowed to have full products as component because this functionality is not
        " available in R/3 and lower S/4 releases
        IF mastb-stlan = cv_stlan.

          CALL FUNCTION 'MARA_SINGLE_READ'
            EXPORTING
              matnr             = mastb-matnr
            IMPORTING
              wmara             = ls_mara
            EXCEPTIONS
              lock_on_material  = 1
              lock_system_error = 2
              wrong_call        = 3
              not_found         = 4
              OTHERS            = 5.

          IF sy-subrc = 0.
            IF ls_mara-attyp = 10 OR ls_mara-attyp = 11 OR ls_mara-attyp = 12.
              lv_struct_art = abap_true.
              lv_matnr      = mastb-matnr.
            ENDIF.
          ENDIF.
        ENDIF.

*-T415B (Retail : Leergut)---
      WHEN c_segnam_e1t415b.
        CALL FUNCTION 'WSTA_UNPACK_E1T415B'
          EXPORTING
            sdata = idoc_data-sdata
            stlal = '01'
          CHANGING
            found = retail_flg.


*-DOST----------------------
      WHEN c_segnam_e1dostm.
        e1dostm = idoc_data-sdata.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE dostb LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1DOSTM' 'DOSTB'
                                      'DOSTB'   hlp_tabix.
        APPEND dostb.


*-KDST----------------------
      WHEN c_segnam_e1kdstm.
        e1kdstm = idoc_data-sdata.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE kdstb LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1KDSTM' 'KDSTB' 'KDSTB'
                                      hlp_tabix.
        APPEND kdstb.


*-STKO----------------------
      WHEN c_segnam_e1stkom OR
           c_segnam_e1stkon.
        CLEAR e1stkom.
        IF idoc_data-segnam = c_segnam_e1stkon.
          e1stkon = idoc_data-sdata.
          MOVE-CORRESPONDING e1stkon TO e1stkom.
          e1stkom-bmeng_c = e1stkon-bmeng.
        ELSE.
          e1stkom = idoc_data-sdata.
        ENDIF.
*       clear not yet supported fields
        IF g_flg_ident_by_guid IS INITIAL.                 "note 567351
          CLEAR e1stkom-guidx.
        ENDIF.                                             "note 567351
*       STKO-BMENG is transported via E1STZUM-EXSTL (moved to EXSTL_C)
*       STKO-BMENG is transported via E1STKOM-BMENG_C (since 46B)
        IF e1stkom-bmeng_c IS INITIAL.
          SHIFT e1stzum-exstl_c LEFT DELETING LEADING ' '.
          MOVE e1stzum-exstl_c TO e1stkom-bmeng_c.
        ENDIF.
        CLEAR e1stkom-bmeng.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE stkob LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1STKOM' 'STKOB'
                                         'STKOB'   hlp_tabix.
        IF e1stkom-msgfn = c_mf_sync.
          stkob-vbkz = c_vbkz_sync.
        ENDIF.
*       process BMENG separately
        IF e1stkom-bmeng_c = c_nodata.
          "no NO_DATA_TAB entry for BMENG_C, because not part of STKOB
          no_data_tab-tabname   = 'STKOB'.
          no_data_tab-tabix     = hlp_tabix + 1.
          no_data_tab-fieldname = 'BMENG'.
          APPEND no_data_tab.
          CLEAR stkob-bmeng.
        ELSE.
          MOVE e1stkom-bmeng_c TO stkob-bmeng.
        ENDIF.
*       convert ISO to SAP unit codes
        PERFORM unit_codes_iso_to_sap USING    stkob-bmein
                                      CHANGING r_bmein.
        stkob-bmein = r_bmein.
*       check date field (initial value)
*       IF E1STKOM-DATUV IS INITIAL.
*           CLEAR STKOB-DATUV.
*       ENDIF.

        stkob-stlty = stzub-stlty.
        APPEND stkob.
        IF NOT stkob-ltxsp IS INITIAL.
*         process bom alternative long text
          PERFORM get_ltx_from_segments TABLES idoc_data
                                   USING  idoc_data-segnum
                                        c_segnam_e1skoth
                                        c_segnam_e1skotl
                                        '1'
                                        ''.
        ENDIF.


*-STAS----------------------
      WHEN c_segnam_e1stasm.
        e1stasm = idoc_data-sdata.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE stasb LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1STASM' 'STASB'
                                      'STASB'   hlp_tabix.
        APPEND stasb.


*-STPO---------------------
      WHEN c_segnam_e1stpom OR
           c_segnam_e1stpon.
        CLEAR e1stpom.
        IF idoc_data-segnam = c_segnam_e1stpon.
          e1stpon = idoc_data-sdata.
          MOVE-CORRESPONDING e1stpon TO e1stpom.
          e1stpom-menge_c = e1stpon-menge.
          e1stpom-id_class_c = e1stpon-id_class.
          e1stpom-romen_c = e1stpon-romen.
        ELSE.
          e1stpom = idoc_data-sdata.
        ENDIF.


        " Now determine, if the article is a full product
        IF lv_struct_art = abap_true.
*          SELECT SINGLE mlgut FROM mara INTO lv_mlgut
*            WHERE matnr = e1stpom-idnrk.
          CLEAR ls_mara.
          MOVE e1stpom-idnrk TO ls_mara-matnr.

          CALL FUNCTION 'MARA_SINGLE_READ'
            EXPORTING
              matnr             = ls_mara-matnr
            IMPORTING
              wmara             = ls_mara
            EXCEPTIONS
              lock_on_material  = 1
              lock_system_error = 2
              wrong_call        = 3
              not_found         = 4
              OTHERS            = 5.

          IF sy-subrc = 0.
            IF ls_mara-mlgut = abap_true.
              idoc_err_nr  = 5.
              gv_matnr_err = lv_matnr.

              CLEAR: stzub, mastb, stkob, stpoi.
              REFRESH: stzub, mastb, stkob, stpoi.
              EXIT.
            ENDIF.
          ENDIF.
        ENDIF.

*       clear not yet supported fields
        IF g_flg_ident_by_guid IS INITIAL.               "note 567351
          CLEAR e1stpom-guidx.
        ENDIF.                                           "note 567351
        CLEAR e1stpom-itmid.
        IF e1stpom-postp = 'R'.
*          For POSTP='R' MENGE is transp. in ID_CLASS and ROMEN in ROMEN
          IF e1stpom-menge_c IS INITIAL.
            SHIFT e1stpom-id_class LEFT DELETING LEADING ' '.
            MOVE e1stpom-id_class TO e1stpom-menge_c.
          ENDIF.
          IF e1stpom-romen_c IS INITIAL.
            MOVE e1stpom-romen TO e1stpom-romen_c.
          ENDIF.
        ELSE.
*          For others MENGE is transp. in ROMEN and ID_CLASS in ID_CLASS
          IF e1stpom-menge_c IS INITIAL.
            MOVE e1stpom-romen TO e1stpom-menge_c.
          ENDIF.
          IF e1stpom-id_class_c IS INITIAL.
            MOVE e1stpom-id_class TO e1stpom-id_class_c.
          ENDIF.
        ENDIF.
        CLEAR e1stpom-menge.
        CLEAR e1stpom-romen.
        CLEAR e1stpom-id_class.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE stpoi LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1STPOM' 'STPOI'
                                      'STPOI'   hlp_tabix.
*       GUID                                              "note 567351
        IF NOT g_flg_ident_by_guid IS INITIAL.            "note 567351
          IF NOT e1stpom-id_comp_guid IS INITIAL.         "note 567351
            stpoi-id_guid = e1stpom-id_comp_guid.         "note 567351
          ELSE.                                           "note 567351
            stpoi-id_guid = stpoi-guidx.                  "note 567351
          ENDIF.                                          "note 567351
        ENDIF.                                            "note 567351
*       classname handling
*       Begin of Note_1466681

*        if e1stpom-postp = 'K'.
*          stpoi-class = e1stpom-klasse.
*        endif.

        DATA: h_t418 LIKE t418.
        CLEAR: h_t418.
        CALL FUNCTION 'T418_READ'
          EXPORTING
            postp    = e1stpom-postp
          IMPORTING
            struct   = h_t418
          EXCEPTIONS
            no_entry = 1
            OTHERS   = 2.

        IF h_t418-klpos = 'X'.
          stpoi-class = e1stpom-klasse.
        ENDIF.

*       End of Note_1466681

*       process MENGE separately
        IF e1stpom-menge_c = c_nodata.
          "no NO_DATA_TAB entry for MENGE_C, because not part of STPOI
          no_data_tab-tabname   = 'STPOI'.
          no_data_tab-tabix     = hlp_tabix + 1.
          no_data_tab-fieldname = 'MENGE'.
          APPEND no_data_tab.
          CLEAR stpoi-menge.
        ELSE.
          stpoi-menge = e1stpom-menge_c.
        ENDIF.
*       process ROMEN separately
        IF e1stpom-romen_c = c_nodata.
          "no NO_DATA_TAB entry for ROMEN_C, because not part of STPOI
          no_data_tab-tabname   = 'STPOI'.
          no_data_tab-tabix     = hlp_tabix + 1.
          no_data_tab-fieldname = 'ROMEN'.
          APPEND no_data_tab.
          CLEAR stpoi-romen.
        ELSE.
          stpoi-romen = e1stpom-romen_c.
        ENDIF.
*       process ID_CLASS separately
        stpoi-id_class = e1stpom-id_class_c.

*       convert ISO to SAP unit codes
        PERFORM unit_codes_iso_to_sap USING    stpoi-meins
                                      CHANGING r_meins.
        PERFORM unit_codes_iso_to_sap USING    stpoi-romei
                                      CHANGING r_romei.
        PERFORM unit_codes_iso_to_sap USING    stpoi-nlfmv
                                      CHANGING r_nlfmv.
        stpoi-meins = r_meins.
        stpoi-romei = r_romei.
        stpoi-nlfmv = r_nlfmv.
*       convert ISO to SAP currency code
        IF NOT stpoi-waers IS INITIAL AND
           NOT stpoi-waers EQ c_nodata.
          CALL FUNCTION 'CURRENCY_CODE_ISO_TO_SAP'
            EXPORTING
              iso_code  = e1stpom-waers                  "#EC DOM_EQUAL
            IMPORTING
              sap_code  = r_waers
              unique    = tmp_flag
            EXCEPTIONS
              not_found = 0
              OTHERS    = 0.
          stpoi-waers = r_waers.
        ENDIF.
*       convert currency amount
        IF NOT stpoi-preis IS INITIAL.
          CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
            EXPORTING
              currency    = stpoi-waers
              idoc_amount = e1stpom-preis
            IMPORTING
              sap_amount  = r_preis
            EXCEPTIONS
              OTHERS      = 0.
          stpoi-preis = r_preis.
        ENDIF.
*       convert item number (provide leading zeros)
        CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
          EXPORTING
            input  = stpoi-posnr
          IMPORTING
            output = stpoi-posnr.

ENHANCEMENT-POINT idoc_to_bom_itabs_02 SPOTS es_saplcsds.
        APPEND stpoi.
        curr_index = sy-tabix.    "save stpoi index

*       process dependencies
        IF NOT stpoi-knobj IS INITIAL.
*         set bom position identification
          stpoi-knobj = curr_index.
          MODIFY stpoi INDEX curr_index.
*         get IDoc segments with dependency data
          next_segm = idoc_data-segnum.
          DO.
            next_segm = next_segm + 1.
            READ TABLE idoc_data INDEX next_segm INTO edi_segment.
            IF sy-subrc NE 0.
              EXIT.
            ENDIF.
            CASE edi_segment-segnam.
              WHEN c_segnam_e1cukbm.
                e1cukbm = edi_segment-sdata.
                CLEAR api_dep_dat.
*               Fill internal table, include NO_DATA-logic
                DESCRIBE TABLE api_dep_dat LINES hlp_tabix.
                PERFORM segment_to_itab USING 'E1CUKBM'
                                              'API_DEP_DAT'
                                              'CSDEP_DAT'
                                               hlp_tabix.
                IF api_dep_dat-dep_intern CO numbers.
*                 local dependency
                  api_dep_dat-dep_extern = api_dep_dat-dep_intern.
                  CLEAR api_dep_dat-dep_intern.
                ENDIF.
                WRITE stpoi-knobj TO
                      api_dep_dat-identifier RIGHT-JUSTIFIED.
                api_dep_dat-object_id = '2'.
                APPEND api_dep_dat.
                MOVE-CORRESPONDING api_dep_dat TO api_dep_ord.
                api_dep_ord-dep_lineno = e1cukbm-dep_lineno.
                APPEND api_dep_ord.
              WHEN c_segnam_e1cukbt.
                e1cukbt = edi_segment-sdata.
*               Fill internal table, include NO_DATA-logic
                DESCRIBE TABLE api_dep_des LINES hlp_tabix.
                PERFORM segment_to_itab USING 'E1CUKBT'
                                              'API_DEP_DES'
                                              'CSDEP_DESC'
                                               hlp_tabix.
                api_dep_des-dep_extern = api_dep_dat-dep_extern.
                api_dep_des-identifier = api_dep_dat-identifier.
                api_dep_des-object_id = '2'.
                APPEND api_dep_des.
              WHEN c_segnam_e1cuknm.
                e1cuknm = edi_segment-sdata.
                ADD 1 TO api_dep_src-line_no.
*               Fill internal table, include NO_DATA-logic
                DESCRIBE TABLE api_dep_src LINES hlp_tabix.
                PERFORM segment_to_itab USING 'E1CUKNM'
                                              'API_DEP_SRC'
                                              'CSDEP_SORC'
                                               hlp_tabix.
                api_dep_src-dep_extern = api_dep_dat-dep_extern.
                api_dep_src-identifier = api_dep_dat-identifier.
                api_dep_src-object_id = '2'.
                APPEND api_dep_src.
              WHEN c_segnam_e1cutxm.
                e1cutxm = edi_segment-sdata.
                ADD 1 TO api_dep_doc-line_no.
*               Fill internal table, include NO_DATA-logic
                DESCRIBE TABLE api_dep_doc LINES hlp_tabix.
                PERFORM segment_to_itab USING 'E1CUTXM'
                                              'API_DEP_DOC'
                                             'CSDEP_DOC'
                                              hlp_tabix.
                api_dep_doc-dep_extern = api_dep_dat-dep_extern.
                api_dep_doc-identifier = api_dep_dat-identifier.
                api_dep_doc-object_id = '2'.
                APPEND api_dep_doc.
              WHEN c_segnam_e1stpom.
                EXIT.
            ENDCASE.
          ENDDO.
        ENDIF. "dependencies

*       process bom position long text
        IF NOT stpoi-ltxsp IS INITIAL.
*         use field knobj to hold identifier value,
*         although there are no object dependencies
          IF stpoi-knobj IS INITIAL.
            stpoi-knobj = curr_index.
            MODIFY stpoi INDEX curr_index.
          ENDIF.

          PERFORM get_ltx_from_segments TABLES idoc_data
                                   USING  idoc_data-segnum
                                        c_segnam_e1spoth
                                        c_segnam_e1spotl
                                        '2'
                                        curr_index.
        ENDIF.

        gw_idoc_data-posnr = e1stpom-posnr.
        gw_idoc_data-postp = e1stpom-postp.
        gw_idoc_data-idnrk = e1stpom-idnrk.
*           gw_idoc_data-ktext = E1STPOM-postp.
*           gw_idoc_data-menge = E1STPOM-postp.
*           gw_idoc_data-datuv = E1STPOM-postp.
*           gw_idoc_data-datub = E1STPOM-postp.

        APPEND gw_idoc_data TO gt_idoc_data.
      WHEN c_segnam_e1stpum.    "-> STPU
        e1stpum = idoc_data-sdata.
*       Fill internal table, include NO_DATA-logic
        DESCRIBE TABLE stpub LINES hlp_tabix.
        PERFORM segment_to_itab USING 'E1STPUM' 'STPUB'
                                      'STPUB'   hlp_tabix.
*       Old field e1stpum-upmng truncates the demicals. Use the new
*       field e1stpum-upmng_c for transporting the sub-item quantity
*       if upmng_c is populated in the idoc segment
        IF e1stpum-upmng_c IS INITIAL.                      "note707484
          stpub-upmng = e1stpum-upmng.
        ELSE.                                               "note707484
          stpub-upmng = e1stpum-upmng_c.                    "note707484
        ENDIF.                                              "note707484
        WRITE stpub-stlkn TO stpub-uposz RIGHT-JUSTIFIED.

*       write curr_index to stpub-stlkn right-justified.    "note 530922
        MOVE curr_index TO stpub-stlkn.                     "N_1682751
        SHIFT stpub-stlkn RIGHT DELETING TRAILING space.    "note 530922
        OVERLAY stpub-stlkn WITH '0000000000'.              "note 530922
        IF stpoi-knobj IS INITIAL.                          "note 530922
          stpoi-knobj = curr_index.                         "note 530922
          MODIFY stpoi INDEX curr_index.                    "note 530922
        ENDIF.                                              "note 530922
        MOVE-CORRESPONDING stpub TO api_stpu.               "note 530922

        APPEND api_stpu.                                    "note 530922

      WHEN 'E1OCLFM'.
        e1oclfm = idoc_data-sdata.
        gs_class_data-klart = e1oclfm-klart.
        gs_class_data-obtab  = e1oclfm-obtab.
        gs_class_data-objek  = e1oclfm-objek.
        gs_class_data-mafid   = e1oclfm-mafid.
        APPEND gs_class_data TO gt_class_data.
      WHEN 'E1KSSKM'.
        e1ksskm = idoc_data-sdata.
        gs_class_data-class = e1ksskm-class.
        gs_class_data-statu = e1ksskm-statu.
        MODIFY gt_class_data FROM gs_class_data INDEX 1 TRANSPORTING class statu .
      WHEN 'E1AUSPM'.
        e1auspm = idoc_data-sdata.
        gs_class_data-klart = e1oclfm-klart.
        gs_class_data-obtab  = e1oclfm-obtab.
        gs_class_data-objek  = e1oclfm-objek.
        gs_class_data-mafid   = e1oclfm-mafid.
        gs_class_data-atnam = e1auspm-atnam.
        gs_class_data-atwrt = e1auspm-atwrt.
        APPEND gs_class_data TO gt_class_data.
      WHEN 'E1MARAM'.
        e1maram = idoc_data-sdata.
        gs_header_data-matnr  = e1maram-matnr.
        gs_header_data-ntgew = e1maram-ntgew.
        gs_header_data-brgew   = e1maram-brgew.
        gs_header_data-meins  = e1maram-meins.
        gs_header_data-mstae  = e1maram-mstae.
        gs_header_data-mstav  = e1maram-mstav.
        gs_header_data-mstdv  = e1maram-mstdv.
        gs_header_data-spart  = e1maram-spart.
        gs_header_data-matkl = e1maram-matkl.
        gs_header_data-extwg  = e1maram-extwg.
        gs_header_data-mbrsh  = e1maram-mbrsh.
        gs_header_data-mtart  = e1maram-mtart.
      WHEN 'E1IDCDASSIGNISM'.
        e1idcdassignism = idoc_data-sdata.
        gs_ism_data-idcodetype  =  e1idcdassignism-idcodetype.
        gs_ism_data-identcode   =  e1idcdassignism-identcode.
        gs_ism_data-xmainidcode    =  e1idcdassignism-xmainidcode.
        APPEND gs_ism_data TO gt_ism_data.
        CLEAR gs_ism_data.
      WHEN 'E1MARAISM'.
        e1maraism = idoc_data-sdata.
        gs_header_data-ismpubltype  = e1maraism-ismpubltype.
        gs_header_data-ismmediatype = e1maraism-ismmediatype.
        gs_header_data-ismconttype    = e1maraism-ismconttype.
        gs_header_data-ismhierarchlevl = e1maraism-ismhierarchlevl.
        gs_header_data-ismtitle   = e1maraism-ismtitle.
        gs_header_data-ismperrule      = e1maraism-ismperrule.
      WHEN 'E1JPTMARAISM'.
        e1jptmaraism = idoc_data-sdata.
        gs_header_data-ismsstratni   = e1jptmaraism-ismsstratni.
        gs_header_data-ismniptype   = e1jptmaraism-ismniptype.
      WHEN 'E1MARCM'.
        e1marcm = idoc_data-sdata.
        gs_header_data-werks   = e1marcm-werks.
        gs_header_data-prctr  = e1marcm-prctr.
      WHEN 'E1MAKTM'.
        e1maktm =  idoc_data-sdata.
        gs_header_text-spras  = e1maktm-spras.
        gs_header_text-maktx  = e1maktm-maktx.
        APPEND gs_header_text TO gt_header_text.
        CLEAR gs_header_text.
      WHEN 'E1MTXHM'.
        e1mtxhm = idoc_data-sdata.
        gs_basic_text-tdobject = e1mtxhm-tdobject.
        gs_basic_text-tdname  = e1mtxhm-tdname.
        gs_basic_text-tdid       = e1mtxhm-tdid.
        gs_basic_text-tdspras    = e1mtxhm-tdspras.
        gs_basic_text-tdtexttype = e1mtxhm-tdtexttype.
        gs_basic_text-spras_iso  = e1mtxhm-spras_iso.
        APPEND gs_basic_text TO gt_basic_text.
        CLEAR gs_basic_text.
      WHEN 'E1MTXLM'.
        e1mtxlm = idoc_data-sdata.
        CASE e1mtxhm-tdspras.
          WHEN 'E'.
            gs_basic_text-tdline = e1mtxlm-tdline.
            MODIFY gt_basic_text FROM gs_basic_text TRANSPORTING tdline WHERE tdspras = 'E'.
          WHEN 'D'.
            gs_basic_text-tdline = e1mtxlm-tdline.
            MODIFY gt_basic_text FROM gs_basic_text TRANSPORTING tdline WHERE tdspras = 'D'.
          WHEN OTHERS.
        ENDCASE.
      WHEN 'E1MVKEM'.
        e1mvkem = idoc_data-sdata.
        gs_org_data-dwerk = e1mvkem-dwerk.
        gs_org_data-mtpos = e1mvkem-mtpos.
        gs_org_data-vkorg = e1mvkem-vkorg.
        gs_org_data-vtweg = e1mvkem-vtweg.
        gs_org_data-mvgr5 = e1mvkem-mvgr5.
        gs_org_data-prat1 = e1mvkem-prat1.
        APPEND gs_org_data TO gt_org_data.
        CLEAR gs_org_data.
      WHEN 'E1MLANM'.
        e1mlanm = idoc_data-sdata.
        gs_tax_classification-aland  = e1mlanm-aland.
        gs_tax_classification-taty1 = e1mlanm-taty1.
        gs_tax_classification-taxm1 = e1mlanm-taxm1.
        APPEND gs_tax_classification TO gt_tax_classification.
        CLEAR gs_tax_classification.
***** SGUDA
    ENDCASE.  "segnam (plain bom data)

  ENDLOOP.   "idoc_data

* BUSINESS TRANSACTION EVENT for inbound tables
* ATTENTION : use of customer RFC will cause a 'commit work'
  CALL FUNCTION 'OPEN_FI_PERFORM_CS000170_E'
    EXPORTING
      idoc_control = idoc_contrl
    TABLES
      l_stzub      = stzub
      l_mastb      = mastb
      l_dostb      = dostb
      l_kdstb      = kdstb
      l_stkob      = stkob
      l_stasb      = stasb
      l_stpoi      = stpoi
      l_stpub      = stpub
    EXCEPTIONS
      idoc_error   = 1.

  IF sy-subrc <> 0.
    idoc_err_nr = sy-subrc.
  ENDIF.


ENDFORM.  "IDOC_TO_BOM_ITABS
*&---------------------------------------------------------------------*
*&      Form  ITABS_TO_API
*&---------------------------------------------------------------------*
*       convert data from internal tables to API data                  *
*       For usage of APIs in CSAP                                      *
*----------------------------------------------------------------------*
FORM itabs_to_api USING stlal LIKE stko-stlal.

  READ TABLE stkob WITH KEY stlal = stlal.

* bom header: fill api_stko1

* --- begin of deletion note 567351
*dIF stkob-vbkz = c_vbkz_sync.
*d   CLEAR API_STKO1.
*dELSE.
*d*  STKO
*d   PERFORM ITAB_TO_API_INIT USING 'STKOB'
*d                                   sy-tabix
*d                                  'API_STKO1'
*d                                  'STKO_API01'
*d                                   c_true.
* --- end of deletion note 567351

* --- begin of insertion note 567351
  PERFORM itab_to_api_init USING 'STKOB'
                                  sy-tabix
                                 'API_STKO1'
                                 'STKO_API01'
                                  c_true.

  PERFORM itab_to_api USING 'GUIDX' 'ID_GUID'.

  IF stkob-vbkz NE c_vbkz_sync.
* --- end of insertion note 567351

    PERFORM itab_to_api USING 'STLST' 'BOM_STATUS'.
    PERFORM itab_to_api USING 'BMENG' 'BASE_QUAN'.
    PERFORM itab_to_api USING 'BMEIN' 'BASE_UNIT'.
    PERFORM itab_to_api USING 'STKTX' 'ALT_TEXT'.
    PERFORM itab_to_api USING 'LABOR' 'LABORATORY'.
    PERFORM itab_to_api USING 'LOEKZ' 'DELETE_IND'.
*    mapping customer fields stkob -> api_stko1
    PERFORM itab_customerfields_to_api USING 'CSCI_STKO'.
*    STZU
    PERFORM itab_to_api_init USING 'STZUB'
                                    0
                                   'API_STKO1'
                                   'STKO_API01'
                                    c_true.
    PERFORM itab_to_api USING 'ZTEXT' 'BOM_TEXT'.
    PERFORM itab_to_api USING 'EXSTL' 'BOM_GROUP'.
    PERFORM itab_to_api USING 'STLBE' 'AUTH_GROUP'.
  ENDIF.

* bom positions: fill api_stko1/3
  IF stasb IS INITIAL.
*   all bom positions are valid
    LOOP AT stpoi.
      PERFORM stpo_internal_to_api USING sy-tabix.
      APPEND api_stpo1.
    ENDLOOP.
  ELSE.
*   select bom positions via STAS
*   NOTE: we could check here for the timewise validtiy
*         (but that was already done at the sending site and we have
*          a BOM with its validity proven for a single day already)
    LOOP AT stasb WHERE stlal = stlal.
      READ TABLE stpoi WITH KEY stlkn = stasb-stlkn.
      PERFORM stpo_internal_to_api USING sy-tabix.
      APPEND api_stpo1.
    ENDLOOP. "STAS (pos selection)
  ENDIF.
ENDFORM.     "ITABS_TO_API

*----------------------------------------------------------------------*
*       FORM CREATE_PLANT_ALLOC
*----------------------------------------------------------------------*
*       creates and deletes plant allocations for a single
*       bom alternative
*----------------------------------------------------------------------*
FORM create_plant_alloc TABLES pallocs STRUCTURE mastb.

  DATA: e_plant     LIKE mast-werks,          "existing plant
*d        T_PLANT LIKE PLANT_API OCCURS 5 WITH HEADER LINE, "note0524506
        t_plant_cre LIKE plant_api OCCURS 5               "note0524506
                         WITH HEADER LINE,                "note0524506
        t_plant_del LIKE plant_api OCCURS 5               "note0524506
                         WITH HEADER LINE,                "note0524506
        ext_matnr   LIKE csap_mbom-matnr,
        plant_found TYPE c.

* identify bom
  LOOP AT pallocs WHERE auskz = c_marked.
    SELECT SINGLE * FROM mast
           WHERE matnr = pallocs-matnr
             AND werks = pallocs-werks
             AND stlan = pallocs-stlan
             AND stlal = pallocs-stlal.
    IF sy-subrc = 0.
*     bom found
      e_plant = pallocs-werks.
      plant_found = 'X'.
      EXIT.
    ENDIF.
  ENDLOOP.

* set plant table
  LOOP AT pallocs WHERE auskz IS INITIAL.
    SELECT SINGLE * FROM mast
           WHERE matnr = pallocs-matnr
             AND werks = pallocs-werks
             AND stlan = pallocs-stlan
             AND stlal = pallocs-stlal.

    IF pallocs-vbkz NE c_bom_delete.                       "note0524506
      IF sy-subrc = 0.
*       alloc already exists -> message in appl-log
        IF pallocs-vbkz NE c_bom_change.                   "note0524506
          PERFORM appl_log_write_single_message USING c_warn c_mcbom '011'
                  pallocs-matnr pallocs-werks pallocs-stlan pallocs-stlal.
        ENDIF.                                             "note0524506
        e_plant = pallocs-werks.
        plant_found = 'X'.
      ELSE.
*d      T_PLANT = PALLOCS-WERKS.                           "note0524506
*d      APPEND T_PLANT.                                    "note0524506
        t_plant_cre = pallocs-werks.                       "note0524506
        APPEND t_plant_cre.                                "note0524506
      ENDIF.
    ELSE.                                                  "note0524506
      IF sy-subrc EQ 0.                                    "note0524506
        t_plant_del = pallocs-werks.                       "note0524506
        APPEND t_plant_del.                                "note0524506
        plant_found = 'X'.                                 "note0524506
      ELSE.                                                "note0524506
*       allocation has already been deleted                "note0524506
      ENDIF.                                               "note0524506
    ENDIF.                                                 "note0524506
  ENDLOOP.

  IF plant_found IS INITIAL.
*   bom does not exist -> message in appl-log ...
    PERFORM appl_log_write_single_message USING
*                                  c_warn c_mc29 '001' '' '' '' ''.
                                  c_error c_mc29 '001' '' '' '' ''.     "note_2154666.
    bom_error = c_true.
    EXIT.
  ENDIF.

* ---- begin of insertion note0524506
* Only for message code "CNG": identify those plant allocations, which
* have to be deleted
  IF pallocs-vbkz EQ c_bom_change.
    SELECT * FROM mast
             WHERE matnr = pallocs-matnr
               AND stlan = pallocs-stlan
               AND stlal = pallocs-stlal.

      READ TABLE pallocs WITH KEY werks = mast-werks.
      IF sy-subrc NE 0.
        t_plant_del = mast-werks.
        APPEND t_plant_del.
      ENDIF.
    ENDSELECT.
  ENDIF.
* ---- end of insertion note0524506

*dIF T_PLANT[] IS INITIAL.                                 "note0524506
*d  all requested plant allocations already exist          "note0524506
*d  EXIT.                                                  "note0524506
*dENDIF.                                                   "note0524506

  WRITE pallocs-matnr TO ext_matnr.

  IF NOT t_plant_cre[] IS INITIAL.                         "note0524506
    CALL FUNCTION 'CSAP_MAT_BOM_ALLOC_CREATE'
      EXPORTING
        material    = ext_matnr
        plant       = e_plant
        bom_usage   = pallocs-stlan
        alternative = pallocs-stlal
      TABLES
*d          T_PLANT          = T_PLANT                     "note0524506
        t_plant     = t_plant_cre                 "note0524506
      EXCEPTIONS
        error       = 1
        OTHERS      = 2.
    IF sy-subrc NE 0.
      bom_error = c_true.
    ENDIF.
  ENDIF.                                                   "note0524506

* ---- begin of insertion note0524506
  IF NOT t_plant_del[] IS INITIAL.
    CALL FUNCTION 'CSAP_MAT_BOM_ALLOC_DELETE'
      EXPORTING
        material    = ext_matnr
        plant       = e_plant
        bom_usage   = pallocs-stlan
        alternative = pallocs-stlal
*       FL_NO_CHANGE_DOC         = ' '
*       FL_COMMIT_AND_WAIT       = ' '
      TABLES
        t_plant     = t_plant_del
      EXCEPTIONS
        error       = 1
        OTHERS      = 2.

    IF sy-subrc <> 0.
      bom_error = c_true.
    ENDIF.
  ENDIF.
* ---- end of insertion note0524506

ENDFORM.  "CREATE_PLANT_ALLOC
*&---------------------------------------------------------------------*
*&      Form  SEGMENT_TO_ITAB
*&---------------------------------------------------------------------*
*  Processes an IDOC-segment to a BOM internal table :
*     - NO_DATA_SIGN for charecter fields is moved there
*     - NO_DATA_SIGN for other fields is stored in NO_DATA_TAB
*     - DATE, TIME and TIMESTAMP field are initialized separately if
*       necessary
*----------------------------------------------------------------------*
FORM segment_to_itab USING    p_segname  LIKE dntab-tabname
                              p_itabname LIKE dntab-tabname
                              p_itabstrc LIKE dntab-tabname
                              p_tabix    LIKE sy-tabix.


  DATA: segfields  LIKE dfies OCCURS 0 WITH HEADER LINE,
        itabfields LIKE dfies OCCURS 0 WITH HEADER LINE,
        hlp_tabix  LIKE sy-tabix.


  FIELD-SYMBOLS: <in>       TYPE any,                              " UC-Test
                 <out>      TYPE any,                             " UC-Test
                 <instruc>,
                 <outstruc>.


  ASSIGN (p_segname)  TO <instruc>.
  ASSIGN (p_itabname) TO <outstruc>.

  hlp_tabix = p_tabix + 1.

* get fields of segemnt
  CALL FUNCTION 'DDIF_NAMETAB_GET'
    EXPORTING
      tabname   = p_segname
    TABLES
      dfies_tab = segfields
    EXCEPTIONS
      OTHERS    = 0.

* get fields of itab
  CALL FUNCTION 'DDIF_NAMETAB_GET'
    EXPORTING
      tabname   = p_itabstrc
    TABLES
      dfies_tab = itabfields
    EXCEPTIONS
      OTHERS    = 0.

  LOOP AT segfields.

    READ TABLE itabfields WITH KEY fieldname = segfields-fieldname.
    CHECK sy-subrc EQ 0.

*    INPUT-field of segment
    ASSIGN COMPONENT segfields-fieldname
        OF STRUCTURE <instruc>
                  TO <in>.
*    OUTPUT-field of itab
    ASSIGN COMPONENT segfields-fieldname
        OF STRUCTURE <outstruc>
                  TO <out>.

    IF itabfields-inttype = 'N' OR
       itabfields-inttype = 'C'.
*       character type
      MOVE <in> TO <out>.
    ELSE.
      IF segfields-inttype = 'C'.
*          numeric and other types
        IF <in> NE c_nodata.
          MOVE <in> TO <out>.
*             CLEAR date & time fields
          IF <in> IS INITIAL.
            IF itabfields-inttype = 'D' OR
               itabfields-inttype = 'S' OR
               itabfields-inttype = 'T'.
              CLEAR <out>.
            ENDIF.
          ENDIF.
        ELSE.
*             numeric & NO_DATA : store in separate table
          CLEAR <out>.
          no_data_tab-tabname   = p_itabname.
          no_data_tab-tabix     = hlp_tabix.
          no_data_tab-fieldname = segfields-fieldname.
          APPEND no_data_tab.
        ENDIF.
      ELSE.
        IF itabfields-inttype = segfields-inttype.
          MOVE <in> TO <out>.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.   "segfields

ENDFORM.                    " SEGMENT_TO_ITAB

*&---------------------------------------------------------------------*
*&      Form  ITAB_TO_API_INIT
*&---------------------------------------------------------------------*
*  Initialization for datatransfer of interlan BOM tables to APIs.
*----------------------------------------------------------------------*
FORM itab_to_api_init USING    p_itabname LIKE dntab-tabname
                               p_tabix    LIKE sy-tabix
                               p_apiname  LIKE dntab-tabname
                               p_apistrct LIKE dntab-tabname
                               p_resetsgn LIKE csdata-xfeld.


  val_to_api-itabname = p_itabname.
  val_to_api-tabix    = p_tabix.
  val_to_api-apiname  = p_apiname.
  val_to_api-resetsgn = p_resetsgn.

  IF val_to_api-apistrct NE  p_apistrct.

    val_to_api-apistrct = p_apistrct.

    REFRESH val_to_api-apifields.

*    get fields of segment
    CALL FUNCTION 'DDIF_NAMETAB_GET'
      EXPORTING
        tabname   = val_to_api-apistrct
      TABLES
        dfies_tab = val_to_api-apifields
      EXCEPTIONS
        OTHERS    = 0.

  ENDIF.

ENDFORM.                    " ITAB_TO_API_INIT

*&---------------------------------------------------------------------*
*&      Form  ITAB_TO_API
*&---------------------------------------------------------------------*
*  Datatransfer from internal BOM table to API-structure.
*     - WRITE statement ensures external data format
*     - NO-DATA-logic only for changes
*     - NO_DATA_SIGNEs can only be written in API character fields
*     - for no character fields in internal BOM tables the NO_DATA_SIGN
*       is restored from NO_DATA_TAB
*     - NO_DATA_SIGN is transformed to INITIAL    in API-structure
*     - INITIAL      is transformed to RESET_SIGN in API-structure
*----------------------------------------------------------------------*
FORM itab_to_api USING   p_itabfield  LIKE dntab-fieldname
                         p_apifield   LIKE dntab-fieldname.


  DATA : hlp_fld      TYPE c.
  DATA:  flg_unit   TYPE c.                                "note 562112


  FIELD-SYMBOLS : <itabstruc>,
                  <apistruc>,
                  <itab>      TYPE any,                           " UC-Test
                  <api>       TYPE any.                           " UC-Test


  ASSIGN (val_to_api-itabname) TO <itabstruc>.
  ASSIGN (val_to_api-apiname)  TO <apistruc>.

  ASSIGN COMPONENT p_itabfield
      OF STRUCTURE <itabstruc>
                TO <itab>.
  ASSIGN COMPONENT p_apifield
      OF STRUCTURE <apistruc>
                TO <api>.

* Make sure that RESET_SIGN or NO_DATA_SIGN are not         "note 562112
* converted by conversion exit CUNIT.                       "note 562112
  PERFORM itab_to_api_check_unit_field                      "note 562112
          USING    val_to_api                               "note 562112
                   p_itabfield                              "note 562112
          CHANGING flg_unit.                                "note 562112

  IF NOT flg_unit IS INITIAL.                               "note 562112
    IF <itab> EQ c_nodata OR <itab> EQ c_data_reset.        "note 562112
      MOVE <itab> TO <api>.                                 "note 562112
    ELSE.                                                   "note 562112
      WRITE <itab> TO <api>.                                "note 562112
    ENDIF.                                                  "note 562112
  ELSE.                                                     "note 562112
    WRITE <itab> TO <api>.
  ENDIF.                                                    "note 562112

  READ TABLE val_to_api-apifields INTO val_to_api-apifield
                                  WITH KEY fieldname = p_apifield.

  IF sy-subrc = 0.
*     RESET_SIGN / NO_DATA_SIGN for character-fields in API only.
    IF val_to_api-apifield-inttype = 'C'.
      READ TABLE no_data_tab WITH KEY tabname   = val_to_api-itabname
                                      tabix     = val_to_api-tabix
                                      fieldname = p_itabfield.
      IF sy-subrc = 0.
        <api> = c_nodata.
      ENDIF.
    ENDIF.

*     Convert NO_DATA_SIGN to INITIAL and INITIAL to RESET_SIGN
    IF val_to_api-apifield-inttype = 'C'.
      WRITE <api> TO hlp_fld.                                "UC-Test
      IF <api> <> c_nodata AND <itab> IS INITIAL.
        IF val_to_api-resetsgn = c_true.
          <api> = c_data_reset.
        ELSE.
          CLEAR <api>.
        ENDIF.
      ELSEIF hlp_fld = c_nodata.
        CLEAR <api>.
      ENDIF.
    ENDIF.
  ENDIF.

*  For INSERT, no RESET_SIGN is supported
  CHECK stzub-vbkz EQ c_bom_insert.
  CHECK val_to_api-apifield-inttype = 'C'.

  IF <api> = c_data_reset.
    CLEAR <api>.
  ENDIF.

ENDFORM.                    " ITAB_TO_API


*&-------------------------------------------------------*
*
*&      Form  CHECK_VALFL
*
*&-------------------------------------------------------*
FORM check_valfl USING p_stlty LIKE stko-stlty.

  CONSTANTS : c_29 LIKE tcs03-agb29 VALUE '29'.

  TABLES : tcs03.

  SELECT SINGLE * FROM tcs03
     WHERE agb29 EQ c_29.

  CHECK sy-subrc = 0.
  CHECK tcs03-valfl IS INITIAL.

  CLEAR ale_aennr.

  CASE p_stlty.
    WHEN 'M'.   CLEAR api_mbom-datuv.
    WHEN 'D'.   CLEAR api_dbom-datuv.
    WHEN 'K'.   CLEAR api_kbom-datuv.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  itab_customerfields_to_api
*&---------------------------------------------------------------------*
*       Mapping of customer fields: CSCI -> API
*----------------------------------------------------------------------*
*      -->P_TABNAME   table name 'CSCI_STKO' or 'CSCI_STPO'
*----------------------------------------------------------------------*
FORM itab_customerfields_to_api  USING  p_tabname TYPE ddobjname.

  DATA: lt_fields LIKE dfies OCCURS 0,
        ls_fields LIKE LINE OF lt_fields.

  FIELD-SYMBOLS : <itabstruc>,
                  <apistruc>,
                  <itab>      TYPE any,                           " UC-Test
                  <api>       TYPE any.                            " UC-Test

*- Get all fieldnames of CSCI_STKO or CSCI_STPO
  CALL FUNCTION 'DDIF_NAMETAB_GET'
    EXPORTING
      tabname   = p_tabname
      all_types = 'X'
    TABLES
      dfies_tab = lt_fields
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

* Presuppostion:
* 1. Customer fields have to have the same fieldnames
*    in CSCI and in the customer IDOC segment
*    => customer fields have the same names in ITABSTRUC
*       and in APISTRUC
* 2. Customer fields should have CHAR format otherwise
*    data reset by RESET_SIGN ('!') is not possible.
* 3. NODATA ('/') logic is not possible in case of customer fields
*    i.e. the inbound idoc has to contain the customer IDOC segment
*    always. No customer IDOC segment is equal to customer segment with
*    initial values. In this case the customer fields will be
*    initialized.

  LOOP AT lt_fields INTO ls_fields.
* filter dummy field of tables CSCI_STKO or CSCI_STPO
    CHECK ls_fields-fieldname <> 'DUMMY'.

    READ TABLE val_to_api-apifields INTO val_to_api-apifield
                               WITH KEY fieldname = ls_fields-fieldname.

* Currently customer fields have the same format in ITAB and API because
* API and ITAB includes customer fields via CSCI structure.
* PERFORM ITAB_TO_API is only useable if the API field format is
* character.
* In case of non character API customer fields we MOVE <itab> TO <api>.
*
* 'CASE val_to_api-apifield-inttype' instead of 'CASE ls_fields-inttype'
* will call PERFORM ITAB_TO_API if in future it will be possible to
* to map non character ITAB customer fields to character API
* customer fields.
    CASE val_to_api-apifield-inttype.

      WHEN 'C'.
        PERFORM itab_to_api USING ls_fields-fieldname
                                  ls_fields-fieldname.

      WHEN OTHERS.
*          RESET_SIGN for character-fields in API only
        ASSIGN (val_to_api-itabname) TO <itabstruc>.
        ASSIGN (val_to_api-apiname)  TO <apistruc>.

        ASSIGN COMPONENT ls_fields-fieldname
            OF STRUCTURE <itabstruc>
                      TO <itab>.
        ASSIGN COMPONENT ls_fields-fieldname
            OF STRUCTURE <apistruc>
                      TO <api>.

        MOVE <itab> TO <api>.

    ENDCASE.

  ENDLOOP.

ENDFORM.                    " itab_customerfields_to_api
*&---------------------------------------------------------------------*
*&      Form  get_ltx_from_segments
*&---------------------------------------------------------------------*
*       extract long text lines from segments. header infos are
*       not relevant
*----------------------------------------------------------------------*
FORM get_ltx_from_segments
                     TABLES idoc_data         STRUCTURE edidd
                     USING  VALUE(segnum)     LIKE edidd-segnum
*d                          not_relevant_segm like edidd-segnam
*d                          relevant_segm     like edidd-segnam
                            header_segm       LIKE edidd-segnam "n542891
                            info_segm         LIKE edidd-segnam "n542891
                            object_id         LIKE csident-object_id
                            identifier        LIKE sy-tabix.

  DATA: edi_segment      LIKE LINE OF idoc_data,
        flg_header_found TYPE c VALUE space.               "note0542891

  DO.
    segnum = segnum + 1.
    READ TABLE idoc_data INDEX segnum INTO edi_segment.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
    CASE edi_segment-segnam.
*d    when not_relevant_segm.                              "note0542891
**d     no relevant information                            "note0542891
      WHEN header_segm.                                    "note0542891
        flg_header_found = 'X'.                            "note0542891
*d    when relevant_segm.                                  "note0542891
      WHEN info_segm.                                      "note0542891
        IF NOT flg_header_found IS INITIAL.                "note0542891
          CLEAR api_ltx_lin.
          api_ltx_lin-object_id  = object_id.
          IF NOT identifier IS INITIAL.
            WRITE identifier TO api_ltx_lin-identifier
                  RIGHT-JUSTIFIED.
            SHIFT api_ltx_lin-identifier RIGHT DELETING TRAILING space.
            OVERLAY api_ltx_lin-identifier WITH '0000000000'.
          ENDIF.
          api_ltx_lin-tdformat   = edi_segment-sdata(2).   "Note 2315689
          api_ltx_lin-tdline     = edi_segment-sdata+2.
          APPEND api_ltx_lin.
        ENDIF.                                             "note0542891
      WHEN OTHERS.
        IF NOT flg_header_found IS INITIAL.                "note0542891
          EXIT.
        ENDIF.                                             "note0542891
    ENDCASE.
  ENDDO.

ENDFORM.                    " get_ltx_from_segments
*&---------------------------------------------------------------------*
*&      Form  ITAB_TO_API_CHECK_UNIT_FIELD
*&---------------------------------------------------------------------*
*       note 562112
*----------------------------------------------------------------------*
*      -->P_VAL_TO_API_ITABNAME  text
*      -->P_P_ITABFIELD  text
*      <--P_FLG_UNIT  text
*----------------------------------------------------------------------*
FORM itab_to_api_check_unit_field
             USING    val_to_api          TYPE val_to_api_type
                      itabfield           LIKE dntab-fieldname
             CHANGING flg_unit            TYPE c.

  CLEAR flg_unit.

  IF itab_to_api_dfies_tab IS INITIAL OR
     val_to_api-itabname NE itab_to_api_last_itab.

    CALL FUNCTION 'DDIF_NAMETAB_GET'
      EXPORTING
        tabname   = val_to_api-itabname
      TABLES
        dfies_tab = itab_to_api_dfies_tab
      EXCEPTIONS
        OTHERS    = 1.

    IF sy-subrc NE 0.
      EXIT.
    ENDIF.

    itab_to_api_last_itab = val_to_api-itabname.

  ENDIF.

  IF NOT itab_to_api_dfies_tab IS INITIAL.
    READ TABLE itab_to_api_dfies_tab
               WITH KEY fieldname = itabfield.

    IF sy-subrc EQ 0.
      IF itab_to_api_dfies_tab-convexit EQ 'CUNIT'.
        flg_unit = 'X'.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " ITAB_TO_API_CHECK_UNIT_FIELD
*&---------------------------------------------------------------------*
*&      Form  check_ident_method
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_guid_ident_inbound
     TABLES idoc_contrl STRUCTURE edidc.

* ---------------------------------------------------------
* Check if GUID-identification for BOM headers and items
* is activated.
*
* Table IDOC_CONTRL allows to enable GUID-identification
* independently for different sending systems.
* ---------------------------------------------------------

  CLEAR g_flg_ident_by_guid.

  IF g_flg_ident_by_guid_checked IS INITIAL.
    DATA: l_exit_name LIKE rsexscrn-exit_name VALUE 'BOM_EXIT'.

    CALL FUNCTION 'SXC_EXIT_CHECK_ACTIVE'
      EXPORTING
        exit_name  = l_exit_name
      EXCEPTIONS
        not_active = 1
        OTHERS     = 0.

    IF sy-subrc EQ 0.                                      "note 630047

      CALL METHOD cl_exithandler=>get_instance
        EXPORTING
          exit_name              = l_exit_name
          null_instance_accepted = c_true             "note 630047
        CHANGING
          instance               = g_inb_bom_exit.

    ENDIF.                                                 "note 630047

    g_flg_ident_by_guid_checked = 'X'.
  ENDIF.

  IF NOT g_inb_bom_exit IS INITIAL.
    DATA: wa_idoc_contrl TYPE edidc.

    READ TABLE idoc_contrl INDEX 1 INTO wa_idoc_contrl.

    CALL METHOD g_inb_bom_exit->ale_identify_by_guid_inbound
      EXPORTING
        i_idoc_contrl      = wa_idoc_contrl
      IMPORTING
        e_identify_by_guid = g_flg_ident_by_guid.
  ENDIF.

* begin of insertion note 617329

  IF g_flg_ident_by_guid IS INITIAL.
    g_flg_ident_by_guid = g_fl_mdm_inbound_active.
  ENDIF.

* end of insertion note 617329

ENDFORM.                    " check_ident_method

FORM check_guid_ident_outbound.

* ------------------------------------------------
* Check if GUIDs have to be put into outbound IDoc
* ------------------------------------------------

  CLEAR g_flg_guid_into_idoc.

  IF g_flg_guid_into_idoc_checked IS INITIAL.
    DATA: l_exit_name LIKE rsexscrn-exit_name VALUE 'BOM_EXIT'.

    CALL FUNCTION 'SXC_EXIT_CHECK_ACTIVE'
      EXPORTING
        exit_name  = l_exit_name
      EXCEPTIONS
        not_active = 1
        OTHERS     = 0.

    IF sy-subrc EQ 0.                                      "note 630047

      CALL METHOD cl_exithandler=>get_instance
        EXPORTING
          exit_name              = l_exit_name
          null_instance_accepted = c_true           "note 630047
        CHANGING
          instance               = g_outb_bom_exit.

    ENDIF.                                                 "note 630047

    g_flg_guid_into_idoc_checked = 'X'.
  ENDIF.

  IF NOT g_outb_bom_exit IS INITIAL.
    CALL METHOD g_outb_bom_exit->ale_identify_by_guid_outbound
      IMPORTING
        e_set_guid = g_flg_guid_into_idoc.
  ENDIF.


* begin of insertion note 617329

  IF g_flg_guid_into_idoc IS INITIAL.
    g_flg_guid_into_idoc = g_fl_mdm_outbound_active.
  ENDIF.

* end of insertion note 617329

ENDFORM.                    " check_ident_method
