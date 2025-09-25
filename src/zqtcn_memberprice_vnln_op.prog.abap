*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MEMBERPRICE_VNLN_OP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_MEMBERPRICE_VNLN_OP
* PROGRAM DESCRIPTION : Price List Report for Direct/Indirect Soceities
* DEVELOPER           : NPOLINA
* CREATION DATE       : 03/Sep/2020
* OBJECT ID           : R116 / V_NLN (Tcode)
* TRANSPORT NUMBER(S) : ED2K919311/ED2K919464/ED2K919526
*----------------------------------------------------------------------*
TYPES:BEGIN OF ty_tbz9a,
        reltyp  TYPE tbz9a-reltyp,
        bez50_2 TYPE tbz9a-bez50_2,
      END OF ty_tbz9a.
TYPES: BEGIN OF ty_reltyp,
         reltyp TYPE tbz9a-reltyp,
       END OF ty_reltyp.

DATA: lt_reltyp_used  TYPE TABLE OF ty_reltyp,
      lst_reltyp_used TYPE ty_reltyp.

CONSTANTS:lc_selscr TYPE char50 VALUE '(SDPIQPRICELIST)GS_SELCRIT-ADDITIONAL_SELCRIT'.
CONSTANTS:lc_selst  TYPE char50 VALUE '(SDPIQPRICELIST)GS_SELCRIT'.

DATA:lt_partner2 TYPE piqt_string_range,
     ls_partner2 TYPE piqt_string_range.

DATA:lt_reltyp1 TYPE piqt_string_range,
     ls_reltyp1 TYPE piqt_string_range.

DATA:lt_reltyp2 TYPE piqt_string_range,
     ls_reltyp2 TYPE piqt_string_range.

DATA:lt_relmys TYPE piqt_string_range,
     ls_relmys TYPE piqt_string_range.

DATA:lt_rellps TYPE piqt_string_range,
     ls_rellps TYPE piqt_string_range.

DATA:lt_reltyp TYPE piqt_string_range,
     ls_reltyp TYPE piqt_string_range.

DATA:lt_pltyp TYPE piqt_string_range,
     ls_pltyp TYPE piqt_string_range.

DATA:lt_vlaufk TYPE piqt_string_range,
     ls_vlaufk TYPE piqt_string_range.

DATA:lt_tbz9a  TYPE TABLE OF ty_tbz9a,
     lst_tbz9a TYPE ty_tbz9a.
DATA:gt_range_string TYPE        piqt_string_range,
     lv_partner2     TYPE        kunnr,
     lv_kunnr        TYPE        kunnr,
     lv_matnr        TYPE        matnr,
     lv_vkorg        TYPE        vkorg,
     lv_vtweg        TYPE        vtweg,
     lv_spart        TYPE        spart.

TYPES: BEGIN OF ty_sold_reltyp,
         kunnr  TYPE kunnr,
         reltyp TYPE bu_reltyp,
       END OF ty_sold_reltyp.
DATA:lt_used  TYPE TABLE OF ty_sold_reltyp,
     lst_used TYPE ty_sold_reltyp.

FIELD-SYMBOLS:
  <lt_data>   TYPE table,
  <rgtab>     TYPE table,
  <lst_data>  TYPE any,
  <lfs_val>   TYPE any,
  <lft_sel>   TYPE table,
  <lft_sel2>  TYPE any,
  <fs_value>  TYPE any,
  <lst_tbz9a> TYPE any.

FIELD-SYMBOLS : <field> TYPE any.

* Read Selection screen data to local table
ASSIGN (lc_selscr) TO <lft_sel>.

* Read  Sales area from Selection Screen
ASSIGN (lc_selst) TO <lft_sel2>.
IF <lft_sel2> IS ASSIGNED.
* Sales Org
  ASSIGN COMPONENT 'VKORG' OF STRUCTURE <lft_sel2> TO <field>.
  IF sy-subrc EQ 0.
    lv_vkorg = <field> .
  ENDIF.

* Dist channel
  ASSIGN COMPONENT 'VTWEG' OF STRUCTURE <lft_sel2> TO <field>.
  IF sy-subrc EQ 0.
    lv_vtweg = <field> .
  ENDIF.

* Division
  ASSIGN COMPONENT 'SPART' OF STRUCTURE <lft_sel2> TO <field>.
  IF sy-subrc EQ 0.
    lv_spart = <field> .
  ENDIF.
ENDIF.
DATA:ct_head2  TYPE if_piq_api=>ty_gt_calculate_head_param.

* Assign custom fields strcuture
ASSIGN cr_result->* TO <lt_data>.

* Read Selection screen inputs data in to Range Tables
LOOP AT <lft_sel> ASSIGNING FIELD-SYMBOL(<lfs_sel>).
  FREE:gt_range_string[].

  ASSIGN COMPONENT 'FIELD' OF STRUCTURE <lfs_sel> TO <lfs_val>.
  IF <lfs_val> = 'ZZPARTNER2'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_partner2.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZRELTYP'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_reltyp.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZRELTYP_LPS'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_rellps.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZRELTYP_SD1'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_reltyp1.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZRELTYP_SD2'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_reltyp2.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZRELTYP_MYS'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_relmys.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'PLTYP'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_pltyp.
    ENDIF.
  ENDIF.

  IF <lfs_val> = 'ZZVLAUFK'.
    ASSIGN COMPONENT 'RGTAB' OF STRUCTURE  <lfs_sel> TO <rgtab>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <rgtab> TO gt_range_string.
      APPEND LINES OF gt_range_string TO lt_vlaufk.
    ENDIF.
  ENDIF.

ENDLOOP.

* Read Society BP to variable for easy reference
IF lt_partner2[] IS NOT INITIAL.
  READ TABLE lt_partner2 INTO DATA(lst_partx) INDEX 1.
  IF sy-subrc = 0.
    lv_partner2 = lst_partx-low.
*--GKAMMILI
    SELECT relnr,partner1,partner2,reltyp
            FROM but050 INTO TABLE @DATA(lt_soc_bp)
            WHERE partner2 = @lv_partner2.
*              AND date_to GE @sy-datum
*      AND date_from LE @sy-datum.
    IF sy-subrc EQ 0.
      SORT lt_soc_bp BY  partner2 reltyp.
      DELETE ADJACENT DUPLICATES FROM lt_soc_bp COMPARING partner2 reltyp.
    ENDIF.
*--GKAMMILI
  ENDIF.
ENDIF.
* selecting relationship cat. description
SELECT reltyp bez50_2
      FROM tbz9a
      INTO TABLE lt_tbz9a
      WHERE spras = 'E'.
FREE:lt_reltyp_used[].
CLEAR:lst_reltyp_used.

IMPORT lt_used TO lt_used FROM MEMORY ID 'VNLN'.
IF lt_used[] IS NOT INITIAL.
  SORT lt_used[] BY kunnr.
ENDIF.

* Fill output strcutire with Selection screen Inputs
LOOP AT <lt_data> ASSIGNING <fs_value>.
  SORT lt_reltyp_used[] BY reltyp.

  SELECT  partner1,partner2,reltyp FROM but050
    INTO TABLE @DATA(lt_050)
    WHERE partner1 = @<fs_value>+0(10)
      AND partner2 = @lv_partner2.
*      AND date_to GE @sy-datum
*    AND date_from LE @sy-datum.

  IF sy-subrc EQ 0.
    SORT lt_050[] BY partner1 partner2 reltyp.
*    IF lt_reltyp[] IS NOT INITIAL AND lv_050 IN lt_reltyp.
* Populate Society BP
    READ TABLE lt_partner2 INTO DATA(lst_part2) INDEX 1.
    IF sy-subrc = 0.

* Populate Membership type RELTYP
      READ TABLE lt_reltyp INTO DATA(lst_reltyp) INDEX 1.
      IF sy-subrc = 0.
        READ TABLE lt_050 INTO DATA(lst_050) WITH KEY reltyp = lst_reltyp-low.
*        IF sy-subrc EQ 0.
        ASSIGN COMPONENT 'ZZRELTYP' OF STRUCTURE <fs_value> TO <field>.
        IF sy-subrc EQ 0.
          <field> = lst_reltyp-low.
        ENDIF.

        ASSIGN COMPONENT 'ZZPARTNER2' OF STRUCTURE <fs_value> TO <field>.
        IF sy-subrc EQ 0.
          <field> = lst_part2-low.
        ENDIF.
*        ENDIF.
      ENDIF.

* Populate Membership type MYS
      READ TABLE lt_relmys INTO DATA(lst_relmys) INDEX 1.
      IF sy-subrc = 0.
        IF lst_relmys-low NE '*'.
          CLEAR:lst_050.
          READ TABLE lt_050 INTO lst_050 WITH KEY partner1 = <fs_value>+0(10) partner2 = lv_partner2
                           reltyp = lst_relmys-low BINARY SEARCH.
          IF sy-subrc EQ 0.
            ASSIGN COMPONENT 'ZZRELTYP_MYS' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_relmys-low.
            ENDIF.

            ASSIGN COMPONENT 'ZZPARTNER2_MYS' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_part2-low.
            ENDIF.
            READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_relmys-low.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
              IF sy-subrc EQ 0.
                <field> = lst_tbz9a-bez50_2.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSEIF lst_relmys-low EQ '*'.
          LOOP AT lt_soc_bp INTO DATA(lst_soc_mys) ."WHERE partner1 = <lst_head>-kunnr.
            READ TABLE lt_reltyp_used INTO DATA(lst_relusedmys) WITH KEY reltyp = lst_soc_mys-reltyp BINARY SEARCH.
            IF sy-subrc NE 0.
              CLEAR:lst_050.
              READ TABLE lt_050 INTO DATA(lst_socbp_mys) WITH KEY partner1 = <fs_value>+0(10)
                                                              partner2 = lv_partner2
                                                              reltyp = lst_soc_mys-reltyp BINARY SEARCH.
              IF sy-subrc EQ 0.
                ASSIGN COMPONENT 'ZZPARTNER2_MYS' OF STRUCTURE <fs_value> TO <field>.
                IF sy-subrc EQ 0.
                  READ TABLE lt_partner2 INTO DATA(lst_partnrbp_mys) INDEX 1.
                  IF sy-subrc EQ 0.
                    <field> = lst_partnrbp_mys-low.
                  ENDIF.
                ENDIF.

                ASSIGN COMPONENT 'ZZRELTYP_MYS' OF STRUCTURE <fs_value> TO <field>.
                IF <fs_value> IS ASSIGNED .
*                  <field> = lst_soc_mys-reltyp.
                  CLEAR:lst_reltyp_used.

                  CLEAR:lst_used.
                  READ TABLE lt_used INTO lst_used WITH KEY kunnr = <fs_value>+0(10) BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    <field> = lst_used-reltyp.
                    lst_reltyp_used-reltyp = lst_used-reltyp.
*                  lst_reltyp_used-reltyp = lst_soc_mys-reltyp.
                  ENDIF.

                  APPEND lst_reltyp_used TO lt_reltyp_used.
                ENDIF.
                READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_used-reltyp ."lst_soc_mys-reltyp.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
                  IF sy-subrc EQ 0.
                    <field> = lst_tbz9a-bez50_2.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.

* Populate Membership type SD1
      READ TABLE lt_reltyp1 INTO DATA(lst_reltyp1) INDEX 1.
      IF sy-subrc = 0.
        IF lst_reltyp1-low NE '*'.
          CLEAR:lst_050.
          READ TABLE lt_050 INTO lst_050 WITH KEY partner1 = <fs_value>+0(10) partner2 = lv_partner2 reltyp = lst_reltyp1-low BINARY SEARCH.
          IF sy-subrc EQ 0.
            ASSIGN COMPONENT 'ZZRELTYP_SD1' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_reltyp1-low.
            ENDIF.

            ASSIGN COMPONENT 'ZZPARTNER2_SD1' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_part2-low.
            ENDIF.
            READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_reltyp1-low.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
              IF sy-subrc EQ 0.
                <field> = lst_tbz9a-bez50_2.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSEIF lst_reltyp1-low = '*'.

          LOOP AT lt_soc_bp INTO DATA(lst_soc) ."WHERE partner1 = <lst_head>-kunnr.

            READ TABLE lt_reltyp_used INTO DATA(lst_relusedsd1) WITH KEY reltyp = lst_soc-reltyp BINARY SEARCH.
            IF sy-subrc NE 0.
              CLEAR:lst_050.
              READ TABLE lt_050 INTO DATA(lst_socbp) WITH KEY partner1 = <fs_value>+0(10)
                                                              partner2 = lv_partner2
                                                              reltyp = lst_soc-reltyp BINARY SEARCH.
              IF sy-subrc EQ 0.
                ASSIGN COMPONENT 'ZZPARTNER2_SD1' OF STRUCTURE <fs_value> TO <field>.
                IF sy-subrc EQ 0.
                  READ TABLE lt_partner2 INTO DATA(lst_partnrbp) INDEX 1.
                  IF sy-subrc EQ 0.
                    <field> = lst_partnrbp-low.
                  ENDIF.
                ENDIF.

                ASSIGN COMPONENT 'ZZRELTYP_SD1' OF STRUCTURE <fs_value> TO <field>.
                IF <fs_value> IS ASSIGNED .
*                  <field> = lst_soc-reltyp.
                  CLEAR:lst_reltyp_used.

                  CLEAR:lst_used.
                  READ TABLE lt_used INTO lst_used WITH KEY kunnr = <fs_value>+0(10) BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    <field> = lst_used-reltyp.
                    lst_reltyp_used-reltyp = lst_used-reltyp.
*                  lst_reltyp_used-reltyp = lst_soc-reltyp.
                  ENDIF.

                  APPEND lst_reltyp_used TO lt_reltyp_used.
                ENDIF.
                READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_used-reltyp. "lst_soc-reltyp.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
                  IF sy-subrc EQ 0.
                    <field> = lst_tbz9a-bez50_2.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.

* Populate Membership type SD2
      READ TABLE lt_reltyp2 INTO DATA(lst_reltyp2) INDEX 1.
      IF sy-subrc = 0.
        IF lst_reltyp2-low NE '*'.
          CLEAR:lst_050.
          READ TABLE lt_050 INTO lst_050 WITH KEY partner1 = <fs_value>+0(10) partner2 = lv_partner2 reltyp = lst_reltyp2-low BINARY SEARCH.
          IF sy-subrc EQ 0.
            ASSIGN COMPONENT 'ZZRELTYP_SD2' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_reltyp2-low.
            ENDIF.

            ASSIGN COMPONENT 'ZZPARTNER2_SD2' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_part2-low.
            ENDIF.
            READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_reltyp2-low.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
              IF sy-subrc EQ 0.
                <field> = lst_tbz9a-bez50_2.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSEIF lst_reltyp2-low EQ '*'.
          LOOP AT lt_soc_bp INTO DATA(lst_soc_sd2) ."WHERE partner1 = <lst_head>-kunnr.
            READ TABLE lt_reltyp_used INTO DATA(lst_relused) WITH KEY reltyp = lst_soc_sd2-reltyp BINARY SEARCH.
            IF sy-subrc NE 0.
              CLEAR:lst_050.
              READ TABLE lt_050 INTO DATA(lst_socbp_sd2) WITH KEY partner1 = <fs_value>+0(10)
                                                              partner2 = lv_partner2
                                                              reltyp = lst_soc_sd2-reltyp BINARY SEARCH.
              IF sy-subrc EQ 0.
                ASSIGN COMPONENT 'ZZPARTNER2_SD2' OF STRUCTURE <fs_value> TO <field>.
                IF sy-subrc EQ 0.
                  READ TABLE lt_partner2 INTO DATA(lst_partnrbp_sd2) INDEX 1.
                  IF sy-subrc EQ 0.
                    <field> = lst_partnrbp_sd2-low.
                  ENDIF.
                ENDIF.

                ASSIGN COMPONENT 'ZZRELTYP_SD2' OF STRUCTURE <fs_value> TO <field>.
                IF <fs_value> IS ASSIGNED .
*                  <field> = lst_soc_sd2-reltyp.
                  CLEAR:lst_reltyp_used.

                  CLEAR:lst_used.
                  READ TABLE lt_used INTO lst_used WITH KEY kunnr = <fs_value>+0(10) BINARY SEARCH.
                  IF sy-subrc EQ 0.
                     <field> = lst_used-reltyp.
                    lst_reltyp_used-reltyp = lst_used-reltyp.
*                  lst_reltyp_used-reltyp = lst_soc_sd2-reltyp.
                  ENDIF.
                  APPEND lst_reltyp_used TO lt_reltyp_used.
                ENDIF.
                READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_used-reltyp."lst_soc_sd2-reltyp.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
                  IF sy-subrc EQ 0.
                    <field> = lst_tbz9a-bez50_2.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.


* Populate Membership type LPS
      READ TABLE lt_rellps INTO DATA(lst_rellps) INDEX 1.
      IF sy-subrc = 0.
        IF lst_rellps-low NE '*'.
          CLEAR:lst_050.
          READ TABLE lt_050 INTO lst_050 WITH KEY partner1 = <fs_value>+0(10) partner2 = lv_partner2 reltyp = lst_rellps-low BINARY SEARCH.
          IF sy-subrc EQ 0.
            ASSIGN COMPONENT 'ZZRELTYP_LPS' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_rellps-low.
            ENDIF.

            ASSIGN COMPONENT 'ZZPARTNER2_LPS' OF STRUCTURE <fs_value> TO <field>.
            IF sy-subrc EQ 0.
              <field> = lst_part2-low.
            ENDIF.
            READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_rellps-low.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
              IF sy-subrc EQ 0.
                <field> = lst_tbz9a-bez50_2.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSEIF lst_rellps-low EQ '*'.
          LOOP AT lt_soc_bp INTO DATA(lst_soc_lps) ."WHERE partner1 = <lst_head>-kunnr.
            READ TABLE lt_reltyp_used INTO DATA(lst_relusedlps) WITH KEY reltyp = lst_soc_lps-reltyp BINARY SEARCH.
            IF sy-subrc NE 0.
              CLEAR:lst_050.
              READ TABLE lt_050 INTO DATA(lst_socbp_lps) WITH KEY partner1 = <fs_value>+0(10)
                                                              partner2 = lv_partner2
                                                              reltyp = lst_soc_lps-reltyp BINARY SEARCH.
              IF sy-subrc EQ 0.
                ASSIGN COMPONENT 'ZZPARTNER2_LPS' OF STRUCTURE <fs_value> TO <field>.
                IF sy-subrc EQ 0.
                  READ TABLE lt_partner2 INTO DATA(lst_partnrbp_lps) INDEX 1.
                  IF sy-subrc EQ 0.
                    <field> = lst_partnrbp_lps-low.
                  ENDIF.
                ENDIF.

                ASSIGN COMPONENT 'ZZRELTYP_LPS' OF STRUCTURE <fs_value> TO <field>.
                IF <fs_value> IS ASSIGNED .
*                  <field> = lst_soc_lps-reltyp.
                  CLEAR:lst_reltyp_used.

                  CLEAR:lst_used.
                  READ TABLE lt_used INTO lst_used WITH KEY kunnr = <fs_value>+0(10) BINARY SEARCH.
                  IF sy-subrc EQ 0.
                     <field> = lst_used-reltyp.
                    lst_reltyp_used-reltyp = lst_used-reltyp.
*                  lst_reltyp_used-reltyp = lst_soc_lps-reltyp.
                  ENDIF.
                  APPEND lst_reltyp_used TO lt_reltyp_used.
                ENDIF.
                READ TABLE lt_tbz9a INTO lst_tbz9a WITH KEY reltyp = lst_used-reltyp ."lst_soc_lps-reltyp.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT 'BEZ50_2' OF STRUCTURE <fs_value> TO <field>.
                  IF sy-subrc EQ 0.
                    <field> = lst_tbz9a-bez50_2.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

* Populate Membership type LPS
  READ TABLE lt_vlaufk INTO DATA(lst_vlaufk) INDEX 1.
  IF sy-subrc = 0.
    ASSIGN COMPONENT 'ZZVLAUFK' OF STRUCTURE <fs_value> TO <field>.
    IF sy-subrc EQ 0.
      <field> = lst_vlaufk-low.
    ENDIF.
  ENDIF.

* Populated Customer Group1 to output
  ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <fs_value> TO <field>.
  IF sy-subrc EQ 0.
    lv_kunnr = <field>.
    SELECT SINGLE kvgr1 INTO @DATA(lv_kvgr1) FROM knvv
      WHERE kunnr = @lv_kunnr
        AND vkorg = @lv_vkorg
        AND vtweg = @lv_vtweg
        AND spart = @lv_spart.
    IF sy-subrc EQ 0 AND lv_kvgr1 IS NOT INITIAL.
      ASSIGN COMPONENT 'ZZKVGR1' OF STRUCTURE <fs_value> TO <field>.
      IF sy-subrc EQ 0.
        <field> = lv_kvgr1.
      ENDIF.
    ENDIF.
  ENDIF.

* Populated Material Type to output
  ASSIGN COMPONENT 'MATNR' OF STRUCTURE <fs_value> TO <field>.
  IF sy-subrc EQ 0.
    lv_matnr = <field>.
    SELECT SINGLE mtart FROM mara INTO @DATA(lv_mtart)
      WHERE matnr = @lv_matnr.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT 'MTART' OF STRUCTURE <fs_value> TO <field>.
      IF sy-subrc EQ 0.
        <field> = lv_mtart.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.
