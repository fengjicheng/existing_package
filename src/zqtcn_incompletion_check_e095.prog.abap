*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INCOMPLETION_CHECK_E095
* PROGRAM DESCRIPTION: Populate Incompletion Log
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   2017-12-18
* OBJECT ID: E095
* TRANSPORT NUMBER(S) ED2K909954
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K914776
* REFERENCE NO:  ERP7777
* DEVELOPER:     Nageswar
* DATE:          2019-03-26
* DESCRIPTION:   Removed duplicates rom XVBUV to avoid short dump
*----------------------------------------------------------------------*
TYPES:
  ltt_price_gr TYPE RANGE OF   konda INITIAL SIZE 0.       "Range: Price Group

CONSTANTS:
  lc_dev_e095  TYPE zdevid     VALUE 'E095',               "Development ID
  lc_tnam_vbkd TYPE tbnam_vb   VALUE 'VBKD',               "Table for documents in sales and distribution (VBKD)
  lc_fnam_kdk2 TYPE tbnam_vb   VALUE 'KDKG2',              "Document field name (KDKG2)
  lc_add_dt_a  TYPE FCODE_FE   VALUE 'PGRU',               "Function Code (Additional Data A)
  lc_p_inc_prc TYPE rvari_vnam VALUE 'INCMPLT_PROC',       "Parameter: Incompletion procedure
  lc_p_sts_grp TYPE rvari_vnam VALUE 'STATUS_GRP',         "Parameter: Status group
  lc_p_prc_grp TYPE rvari_vnam VALUE 'PRICE_GRP',          "Parameter: Price Group
  lc_p_member  TYPE rvari_vnam VALUE 'MEMBER'.             "Parameter: Member Rate

DATA:
  li_constants TYPE zcat_constants.                        "Constant Values

STATICS:
  lv_inc_proc  TYPE fehgr,                                 "Incompletion procedure
  lv_stats_grp TYPE statg,                                 "Status Group
  lr_price_grp TYPE ltt_price_gr.                          "Range: Price Group - Member

DATA:
  lv_incmplt_f TYPE flag.                                  "Flag: Incomplete

IF lv_inc_proc  IS INITIAL AND
   lv_stats_grp IS INITIAL AND
   lr_price_grp IS INITIAL.
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e095                           "Development ID
    IMPORTING
      ex_constants = li_constants.                         "Constant Values
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_p_prc_grp.                                   "Parameter: Price Group
        CASE <lst_constant>-param2.
          WHEN lc_p_member.                                "Parameter: Member Rate
*           Populate Range: Price Group - Member
            APPEND INITIAL LINE TO lr_price_grp ASSIGNING FIELD-SYMBOL(<lst_price_grp>).
            <lst_price_grp>-sign   = <lst_constant>-sign.
            <lst_price_grp>-option = <lst_constant>-opti.
            <lst_price_grp>-low    = <lst_constant>-low.
            <lst_price_grp>-high   = <lst_constant>-high.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_p_inc_prc.                                   "Parameter: Incompletion procedure
        CASE <lst_constant>-param2.
          WHEN lc_p_sts_grp.                               "Parameter: Status Group
            lv_inc_proc  = <lst_constant>-low.             "Incompletion procedure
            lv_stats_grp = <lst_constant>-high.            "Status Group

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

LOOP AT xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd_e095>).
  CLEAR: lv_incmplt_f.
  IF <lst_xvbkd_e095>-posnr IS NOT INITIAL.
    IF <lst_xvbkd_e095>-konda IN lr_price_grp AND
       <lst_xvbkd_e095>-kdkg2 IS INITIAL.
      lv_incmplt_f = abap_true.
    ENDIF.

    IF lv_incmplt_f IS NOT INITIAL.
      READ TABLE xvbuv TRANSPORTING NO FIELDS
           WITH KEY vbeln = vbak-vbeln
                    posnr = <lst_xvbkd_e095>-posnr
                    etenr = etenr_low
                    parvw = space
                    tdid  = space
                    tbnam = lc_tnam_vbkd
                    fdnam = lc_fnam_kdk2
           BINARY SEARCH.
      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO xvbuv ASSIGNING FIELD-SYMBOL(<lst_xvbuv_e095>).
        <lst_xvbuv_e095>-mandt = sy-mandt.
        <lst_xvbuv_e095>-vbeln = vbak-vbeln.
        <lst_xvbuv_e095>-posnr = <lst_xvbkd_e095>-posnr.
        <lst_xvbuv_e095>-etenr = etenr_low.
        <lst_xvbuv_e095>-parvw = space.
        <lst_xvbuv_e095>-tdid  = space.
        <lst_xvbuv_e095>-tbnam = lc_tnam_vbkd.
        <lst_xvbuv_e095>-fdnam = lc_fnam_kdk2.
        <lst_xvbuv_e095>-fehgr = lv_inc_proc.
        <lst_xvbuv_e095>-statg = lv_stats_grp.
        <lst_xvbuv_e095>-fcode = lc_add_dt_a.
        <lst_xvbuv_e095>-sortf = 9999.
        <lst_xvbuv_e095>-lfdnr = 0000.
        <lst_xvbuv_e095>-updkz = updkz_new.
      ENDIF.

    ELSE.
      READ TABLE xvbuv ASSIGNING <lst_xvbuv_e095>
           WITH KEY vbeln = vbak-vbeln
                    posnr = <lst_xvbkd_e095>-posnr
                    etenr = etenr_low
                    parvw = space
                    tdid  = space
                    tbnam = lc_tnam_vbkd
                    fdnam = lc_fnam_kdk2
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_tabix_e095) = sy-tabix.
        CASE <lst_xvbuv_e095>-updkz.
          WHEN space.
            APPEND INITIAL LINE TO yvbuv ASSIGNING FIELD-SYMBOL(<lst_yvbuv_e095>).
            MOVE-CORRESPONDING <lst_xvbuv_e095> TO <lst_yvbuv_e095>.
            UNASSIGN: <lst_yvbuv_e095>.

            <lst_xvbuv_e095>-updkz = updkz_delete.

          WHEN updkz_update.
            <lst_xvbuv_e095>-updkz = updkz_delete.

          WHEN updkz_new.
            DELETE xvbuv INDEX lv_tabix_e095.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.

* SOC by NPOLINA ERP7777 ED2K914776
IF xvbuv[] IS NOT INITIAL.
  SORT:xvbuv[].
  DELETE ADJACENT DUPLICATES FROM xvbuv COMPARING ALL FIELDS.
ENDIF.
* EOC by NPOLINA ERP7777 ED2K914776
