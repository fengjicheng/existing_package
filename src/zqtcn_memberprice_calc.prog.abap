*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MEMBERPRICE_CALC
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_MEMBERPRICE_CALC
* PROGRAM DESCRIPTION : Price List Report for Direct/Indirect Soceities
* DEVELOPER           : NPOLINA
* CREATION DATE       : 03/Sep/2020
* OBJECT ID           : R116 / V_NLN(Tcode)
* TRANSPORT NUMBER(S) : ED2K919311/ED2K919464/ED2K919526
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_sold_reltyp,
         kunnr  TYPE kunnr,
         reltyp TYPE bu_reltyp,
       END OF ty_sold_reltyp.

DATA:lt_used  TYPE TABLE OF ty_sold_reltyp,
     lst_used TYPE ty_sold_reltyp.

DATA:lt_usedrel  TYPE TABLE OF ty_sold_reltyp,
     lst_usedrel TYPE ty_sold_reltyp.

DATA:lt_partner2 TYPE piqt_string_range,
     ls_partner2 TYPE piqt_string_range.

DATA:lt_reltyp1 TYPE piqt_string_range,
     ls_reltyp1 TYPE piqt_string_range.

DATA:lt_reltyp TYPE piqt_string_range,
     ls_reltyp TYPE piqt_string_range.

DATA:lt_rellps TYPE piqt_string_range,
     ls_rellps TYPE piqt_string_range.

DATA:lt_reltyp2 TYPE piqt_string_range,
     ls_reltyp2 TYPE piqt_string_range.

DATA:lt_relmys TYPE piqt_string_range,
     ls_relmys TYPE piqt_string_range.

DATA:lt_pltyp TYPE piqt_string_range,
     ls_pltyp TYPE piqt_string_range.

DATA:lt_vlaufk TYPE piqt_string_range,
     ls_vlaufk TYPE piqt_string_range.

DATA:ct_head2  TYPE if_piq_api=>ty_gt_calculate_head_param.
DATA:lst_head2 LIKE LINE OF ct_head2,
     lst_head3 LIKE LINE OF ct_head2.

TYPES: BEGIN OF ty_item,
         zzkvgr1        TYPE char3,
         	zzpartner2     TYPE char10,
         	zzpartner2_lps TYPE char10,
         	zzpartner2_mys TYPE char10,
         	zzpartner2_sd1 TYPE char10,
         	zzpartner2_sd2 TYPE char10,
         	zzreltyp       TYPE char6,
         	zzreltyp_lps   TYPE char6,
         	zzreltyp_mys   TYPE char6,
         	zzreltyp_sd1   TYPE char6,
         	zzreltyp_sd2   TYPE char6,
       END OF ty_item.
DATA:lt_item  TYPE TABLE OF ty_item,
     lst_item TYPE ty_item.

FIELD-SYMBOLS:
  <lt_data>   TYPE table,
  <lst_data>  TYPE any,      "Head
  <lst_data2> TYPE any,      "Head
  <lst_item>  TYPE any,      "Item
  <fs_value>  TYPE any.

FIELD-SYMBOLS : <field> TYPE any.

DATA:gs_selcrit            TYPE        piqs_sdpricelist_selcrit,
     gs_additional_selcrit TYPE        piqs_sdpricelist_genselcrit,
     gt_range_string       TYPE        piqt_string_range,
     lv_partner2           TYPE        kunnr,
     lv_kunnr              TYPE        kunnr,
     lv_vbeln(9)           TYPE        n,
     lv_wild(1)            TYPE        c,
     lv_tbx                TYPE        sy-tabix,
     lv_tbx1               TYPE        sy-tabix.

* Fetch Selection Screen Inputs into Range tables
LOOP AT is_selcrit-additional_selcrit INTO gs_additional_selcrit.
  FREE:gt_range_string[].
  IF gs_additional_selcrit-field = 'ZZPARTNER2'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    APPEND LINES OF gt_range_string TO lt_partner2.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZRELTYP'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    APPEND LINES OF gt_range_string TO lt_reltyp.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZRELTYP_LPS'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    READ TABLE gt_range_string INTO DATA(lst_str) INDEX 1.
    IF lst_str-low = '*'.
      lv_wild = abap_true.
    ENDIF.

    APPEND LINES OF gt_range_string TO lt_rellps.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZRELTYP_SD1'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    READ TABLE gt_range_string INTO lst_str INDEX 1.
    IF lst_str-low = '*'.
      lv_wild = abap_true.
    ENDIF.
    APPEND LINES OF gt_range_string TO lt_reltyp1.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZRELTYP_SD2'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    READ TABLE gt_range_string INTO lst_str INDEX 1.
    IF lst_str-low = '*'.
      lv_wild = abap_true.
    ENDIF.
    APPEND LINES OF gt_range_string TO lt_reltyp2.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZRELTYP_MYS'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    READ TABLE gt_range_string INTO lst_str INDEX 1.
    IF lst_str-low = '*'.
      lv_wild = abap_true.
    ENDIF.

    APPEND LINES OF gt_range_string TO lt_relmys.
  ENDIF.

  IF gs_additional_selcrit-field = 'PLTYP'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    APPEND LINES OF gt_range_string TO lt_pltyp.
  ENDIF.

  IF gs_additional_selcrit-field = 'ZZVLAUFK'.
    MOVE-CORRESPONDING gs_additional_selcrit-rgtab TO gt_range_string.
    APPEND LINES OF gt_range_string TO lt_vlaufk.
  ENDIF.

ENDLOOP.

* Read Society BP
IF lt_partner2[] IS NOT INITIAL .
  READ TABLE lt_partner2 INTO DATA(lst_partnrx) INDEX 1.
  IF sy-subrc EQ 0.
    lv_partner2 = lst_partnrx-low.

*    IF  is_selcrit-kunnr[] IS INITIAL.
* Get Society BP Relationship categories
    SELECT relnr,partner1,partner2,reltyp
      FROM but050 INTO TABLE @DATA(lt_soc_bp)
      WHERE partner2 = @lv_partner2
          AND date_to GE @sy-datum
          AND date_from LE @sy-datum.
    IF sy-subrc EQ 0.
      SORT lt_soc_bp BY   partner2 reltyp.
      DELETE ADJACENT DUPLICATES FROM lt_soc_bp COMPARING partner2 reltyp.

    ENDIF.
*    ENDIF.
  ENDIF.
ENDIF.

* Get Sold-to party's Relationship categories
IF ct_head[] IS NOT INITIAL.
  SELECT partner1,partner2,reltyp FROM but050
    INTO TABLE @DATA(li_but050)
    FOR ALL ENTRIES IN @ct_head
    WHERE partner1 = @ct_head-kunnr
    AND partner2 = @lv_partner2
     AND date_to GE @sy-datum
    AND date_from LE @sy-datum.
  IF sy-subrc EQ 0.
    SORT li_but050 BY partner1 partner2 reltyp.
  ENDIF.

* Fetch Customer group of Sold-to party
  SELECT kunnr,vkorg,vtweg,spart,kvgr1 FROM knvv INTO TABLE @DATA(li_knvv)
    FOR ALL ENTRIES IN @ct_head
    WHERE kunnr = @ct_head-kunnr.
  IF sy-subrc EQ 0.
    SORT li_knvv BY kunnr vkorg vtweg spart.
  ENDIF.
ENDIF.

IF ct_item[] IS NOT INITIAL.
* Fetch Material type of Materials
  SELECT matnr, mtart FROM mara INTO TABLE @DATA(li_mara)
    FOR ALL ENTRIES IN @ct_item
    WHERE matnr = @ct_item-matnr.
  IF sy-subrc EQ 0.
    SORT li_mara BY matnr.
  ENDIF.
ENDIF.

*IF lv_wild EQ abap_true .
*
*
*  READ TABLE ct_head ASSIGNING FIELD-SYMBOL(<lst_headx>) INDEX 1.
*  IF sy-subrc EQ 0.
*    DELETE lt_soc_bp WHERE partner1 NE <lst_headx>-kunnr.
*    DESCRIBE TABLE lt_soc_bp LINES DATA(lv_relcnt).
*    IF  lv_relcnt > 1.
*      lst_head2 = <lst_headx>.
*      lv_vbeln = <lst_headx>-vbeln+1(9).
*      DO lv_relcnt -  1 TIMES.
*        lv_vbeln = lv_vbeln + 1.
*        lst_head2-vbeln+1(9) = lv_vbeln.
*        APPEND lst_head2 TO ct_head.
*      ENDDO.
*    ENDIF.
*  ENDIF.
*ENDIF.
* Populate Custom fields with Selection Screen values
LOOP AT ct_head ASSIGNING FIELD-SYMBOL(<lst_head>).
  lv_tbx1 = sy-tabix.
  SORT lt_used BY kunnr.         " For Used customers
  SORT lt_usedrel BY reltyp.     " For Used Relationships

  ASSIGN <lst_head>-caller_data->* TO <lst_data>.

  IF <lst_data> IS ASSIGNED .

* Populate Customer Group 1 to Header communication structure
    READ TABLE li_knvv INTO DATA(lst_knvv) WITH KEY kunnr = <lst_head>-kunnr
                                                          vkorg = is_selcrit-vkorg
                                                          vtweg = is_selcrit-vtweg
                                                          spart = is_selcrit-spart BINARY SEARCH.
    IF sy-subrc EQ 0 AND lst_knvv-kvgr1 IS NOT INITIAL.
      ASSIGN COMPONENT 'ZZKVGR1' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        <field> = lst_knvv-kvgr1.
      ENDIF.
    ENDIF.

*  Populate Relationship type category and Soceity BP  to Header communication structure
    IF  lt_reltyp[] IS NOT INITIAL .
      ASSIGN COMPONENT 'ZZRELTYP' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        READ TABLE lt_reltyp INTO DATA(lst_reltypn) INDEX 1.
        IF sy-subrc EQ 0.
          READ TABLE li_but050 INTO DATA(lst_050) WITH KEY partner1 = <lst_head>-kunnr
                                                           reltyp = lst_reltypn-low BINARY SEARCH.
          <field> = lst_reltypn-low.

          ASSIGN COMPONENT 'ZZPARTNER2' OF STRUCTURE <lst_data> TO <field>.
          IF sy-subrc EQ 0.
            READ TABLE lt_partner2 INTO DATA(lst_partnr) INDEX 1.
            IF sy-subrc EQ 0.
              <field> = lst_partnr-low.
            ENDIF.
          ENDIF.
*              ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR:lst_head2.
    lst_head2 = <lst_head>.
    CLEAR: lv_kunnr .
    lv_kunnr = lst_head2-kunnr.
*        CLEAR:lst_head2-caller_data.
*  Populate Relationship type category of SD1 and Soceity BP  to Header communication structure
    IF  lt_reltyp1[] IS NOT INITIAL .
      ASSIGN COMPONENT 'ZZRELTYP_SD1' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        READ TABLE lt_reltyp1 INTO DATA(lst_reltyp) INDEX 1.
        IF sy-subrc EQ 0.
          IF lst_reltyp-low NE '*'.
            CLEAR:lst_050.
            READ TABLE li_but050 INTO lst_050 WITH KEY partner1 = <lst_head>-kunnr partner2 = lv_partner2
                                                             reltyp = lst_reltyp-low BINARY SEARCH.
            IF sy-subrc EQ 0.
              <field> = lst_reltyp-low.
              ASSIGN COMPONENT 'ZZPARTNER2_SD1' OF STRUCTURE <lst_data> TO <field>.
              IF sy-subrc EQ 0.
                READ TABLE lt_partner2 INTO DATA(lst_partnr1) INDEX 1.
                IF sy-subrc EQ 0.
                  <field> = lst_partnr1-low.
                ENDIF.
              ENDIF.
            ENDIF.
* SOC
          ELSEIF lst_reltyp-low = '*'.  " Logic for wild card scenario

            lv_wild = abap_true.
            <lst_head>-kunnr = abap_true.
            DELETE lt_soc_bp WHERE reltyp EQ abap_true.
            LOOP AT lt_soc_bp INTO DATA(lst_soc_sd1) .

              CLEAR:lv_tbx.
              lv_tbx = sy-tabix.
              CLEAR:lst_used.
* Check Customer already matched with Relationships, should not repeat same customer
              READ TABLE lt_used INTO DATA(lst_used2) WITH KEY kunnr = lst_head2-kunnr BINARY SEARCH .
              IF sy-subrc NE 0.
                CLEAR:lst_usedrel.
* Check Relationship  already matched with Customer , same Relationships should not repeat
                READ TABLE lt_usedrel INTO DATA(lst_usedrel2) WITH KEY reltyp = lst_soc_sd1-reltyp BINARY SEARCH .
                IF sy-subrc NE 0.

                  CLEAR:lst_050.
                  READ TABLE li_but050 INTO DATA(lst_socbp_sd1) WITH KEY partner1 = lst_head2-kunnr
                                                                    partner2 = lv_partner2
                                                                   reltyp = lst_soc_sd1-reltyp BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    ASSIGN lst_head2-caller_data->* TO <lst_data2>.
                    IF <lst_data2> IS ASSIGNED .

                      ASSIGN COMPONENT 'ZZPARTNER2_SD1' OF STRUCTURE <lst_data2> TO <field>.
                      IF sy-subrc EQ 0.
                        READ TABLE lt_partner2 INTO DATA(lst_partnrbp_sd1) INDEX 1.
                        IF sy-subrc EQ 0.
                          <field> = lst_partnrbp_sd1-low.
                          lst_used-kunnr = lst_head2-kunnr.
                        ENDIF.
                      ENDIF.

                      ASSIGN COMPONENT 'ZZRELTYP_SD1' OF STRUCTURE <lst_data2> TO <field>.
                      IF <lst_data2> IS ASSIGNED .
                        <field> = lst_soc_sd1-reltyp.
                        lst_used-reltyp = lst_soc_sd1-reltyp.
                      ENDIF.

                      APPEND lst_used TO lt_used.
                      APPEND lst_used TO lt_usedrel.
                      CLEAR:lst_used.
                      SORT lt_used BY kunnr.
                      SORT lt_usedrel BY reltyp.
                    ENDIF.
                    lv_vbeln = lv_vbeln + 1.
                    <lst_head>-kunnr = abap_true.
                    lst_head2-vbeln+1(9) = lv_vbeln.
                    APPEND  lst_head2 TO ct_head2.

                    lst_soc_sd1-reltyp = abap_true.
                    MODIFY lt_soc_bp FROM lst_soc_sd1 INDEX lv_tbx TRANSPORTING reltyp.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
*            UNASSIGN <lst_data2>.
*            lv_wild = abap_true.
*            <lst_head>-kunnr = abap_true.
*            DELETE lt_soc_bp WHERE reltyp EQ abap_true.
*            DELETE lt_soc_bp WHERE partner1 NE lv_kunnr.
*            ASSIGN lst_head2-caller_data->* TO <lst_data2>.
*
*            LOOP AT lt_soc_bp INTO DATA(lst_soc) WHERE partner1 = lv_kunnr.
*              CLEAR:lst_used.
**              READ TABLE lt_used INTO DATA(lst_used2) WITH KEY kunnr = lst_head2-kunnr BINARY SEARCH .
**              IF sy-subrc NE 0.
**                CLEAR:lst_usedrel.
**                READ TABLE lt_usedrel INTO DATA(lst_usedrel2) WITH KEY reltyp = lst_soc-reltyp BINARY SEARCH .
**                IF sy-subrc NE 0.
*
*              CLEAR:lv_tbx.
*              lv_tbx = sy-tabix.
**              CLEAR:lst_050.
**                  READ TABLE li_but050 INTO DATA(lst_socbp) WITH KEY partner1 = lst_head2-kunnr
**                                                                    partner2 = lv_partner2
**                                                                   reltyp = lst_soc-reltyp BINARY SEARCH.
**                  IF sy-subrc EQ 0.
*
**              DATA:lst_temp type REF TO <lst_data2>.
*              IF <lst_data2> IS ASSIGNED .
*
*
**                UNASSIGN  <field> .
**                ASSIGN COMPONENT 'ZZPARTNER2_SD1' OF STRUCTURE <lst_data2> TO <field>.
**                IF sy-subrc EQ 0.
*                READ TABLE lt_partner2 INTO DATA(lst_partnrbp) INDEX 1.
*                IF sy-subrc EQ 0.
**                    <field> = lst_partnrbp-low.
*                  <lst_data2>+33(10) = lst_partnrbp-low.
*                  <lst_data2>+71(6) = lst_soc-reltyp.
*
**                    lst_used-kunnr = lst_head2-kunnr.
**                  ENDIF.
*                ENDIF.
*
**                UNASSIGN  <field> .
**                ASSIGN COMPONENT 'ZZRELTYP_SD1' OF STRUCTURE <lst_data2> TO <field>.
**                IF <lst_data2> IS ASSIGNED .
**                  <field> = lst_soc-reltyp.
***                  lst_used-reltyp = lst_soc-reltyp.
**                ENDIF.
**                APPEND lst_used TO lt_used.
**                APPEND lst_used TO lt_usedrel.
**                CLEAR:lst_used.
**                SORT lt_used BY kunnr.
**                SORT lt_usedrel BY reltyp.
*              ENDIF.
*              lv_vbeln = lv_vbeln + 10.
*              <lst_head>-kunnr = abap_true.
*              lst_head2-kunnr = lv_kunnr.
*              lst_head2-spras = <lst_head>-spras.
*              lst_head2-vbeln+1(9) = lv_vbeln.
*
*              lst_item = <lst_data2>.
*              APPEND lst_item TO lt_item.
*
**              APPEND  lst_head2 TO ct_head2.
*              INSERT lst_head2 INTO   ct_head2 INDEX lv_tbx1.
*              lst_soc-reltyp = abap_true.
*              MODIFY lt_soc_bp FROM lst_soc INDEX lv_tbx TRANSPORTING reltyp.
*              EXIT.
**                  ENDIF.
**                ENDIF.
**              ENDIF.
*            ENDLOOP.
* EOC
***********************
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*  Populate Relationship type category and Soceity BP  of SD2 to Header communication structure
    IF lt_reltyp2[] IS NOT INITIAL .
      ASSIGN COMPONENT 'ZZRELTYP_SD2' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        READ TABLE lt_reltyp2 INTO DATA(lst_reltyp2) INDEX 1.
        IF sy-subrc EQ 0.
          IF lst_reltyp2-low NE '*'.
            CLEAR:lst_050.
            READ TABLE li_but050 INTO lst_050 WITH KEY partner1 = <lst_head>-kunnr partner2 = lv_partner2
                                                             reltyp = lst_reltyp2-low BINARY SEARCH.
            IF sy-subrc EQ 0.
              <field> = lst_reltyp2-low.

              ASSIGN COMPONENT 'ZZPARTNER2_SD2' OF STRUCTURE <lst_data> TO <field>.
              IF sy-subrc EQ 0.
                READ TABLE lt_partner2 INTO DATA(lst_partnr2) INDEX 1.
                IF sy-subrc EQ 0.
                  <field> = lst_partnr2-low.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSEIF lst_reltyp2-low EQ '*'.
            lv_wild = abap_true.
            <lst_head>-kunnr = abap_true.
            DELETE lt_soc_bp WHERE reltyp EQ abap_true.
            LOOP AT lt_soc_bp INTO DATA(lst_soc_sd2) ."WHERE partner1 = <lst_head>-kunnr.
              CLEAR:lv_tbx.
              lv_tbx = sy-tabix.
              CLEAR:lst_used2.
              READ TABLE lt_used INTO lst_used2 WITH KEY kunnr = lst_head2-kunnr BINARY SEARCH .
              IF sy-subrc NE 0.

                CLEAR:lst_usedrel2.
                READ TABLE lt_usedrel INTO lst_usedrel2 WITH KEY reltyp = lst_soc_sd2-reltyp BINARY SEARCH .
                IF sy-subrc NE 0.

                  CLEAR:lst_050.
                  READ TABLE li_but050 INTO DATA(lst_socbp_sd2) WITH KEY partner1 = lst_head2-kunnr
                                                                    partner2 = lv_partner2
                                                                   reltyp = lst_soc_sd2-reltyp BINARY SEARCH.
                  IF sy-subrc EQ 0.

                    ASSIGN lst_head2-caller_data->* TO <lst_data2>.
                    IF <lst_data2> IS ASSIGNED .

                      ASSIGN COMPONENT 'ZZPARTNER2_SD2' OF STRUCTURE <lst_data2> TO <field>.
                      IF sy-subrc EQ 0.
                        READ TABLE lt_partner2 INTO DATA(lst_partnrbp_sd2) INDEX 1.
                        IF sy-subrc EQ 0.
                          <field> = lst_partnrbp_sd2-low.
                          lst_used-kunnr = lst_head2-kunnr.
                        ENDIF.
                      ENDIF.

                      ASSIGN COMPONENT 'ZZRELTYP_SD2' OF STRUCTURE <lst_data2> TO <field>.
                      IF <lst_data2> IS ASSIGNED .
                        <field> = lst_soc_sd2-reltyp.
                        lst_used-reltyp = lst_soc_sd2-reltyp.
                      ENDIF.

                      APPEND lst_used TO lt_used.
                      APPEND lst_used TO lt_usedrel.
                      CLEAR:lst_used.
                      SORT lt_used BY kunnr.
                      SORT lt_usedrel BY reltyp.
                    ENDIF.
                    lv_vbeln = lv_vbeln + 1.
                    <lst_head>-kunnr = abap_true.
                    lst_head2-vbeln+1(9) = lv_vbeln.
                    APPEND  lst_head2 TO ct_head2.

                    lst_soc_sd2-reltyp = abap_true.
                    MODIFY lt_soc_bp FROM lst_soc_sd2 INDEX lv_tbx TRANSPORTING reltyp.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

*  Populate Relationship type category  and Soceity BP of Multi year structure to Header communication structure
    IF  lt_relmys[] IS NOT INITIAL .
      ASSIGN COMPONENT 'ZZRELTYP_MYS' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        READ TABLE lt_relmys INTO DATA(lst_reltypm) INDEX 1.
        IF sy-subrc EQ 0.
          IF lst_reltypm-low NE '*'.
            CLEAR:lst_050.
            READ TABLE li_but050 INTO lst_050 WITH KEY partner1 = <lst_head>-kunnr partner2 = lv_partner2
                                                             reltyp = lst_reltypm-low BINARY SEARCH.
            IF sy-subrc EQ 0.
              <field> = lst_reltypm-low.

              ASSIGN COMPONENT 'ZZPARTNER2_MYS' OF STRUCTURE <lst_data> TO <field>.
              IF sy-subrc EQ 0.
                READ TABLE lt_partner2 INTO DATA(lst_partnrm) INDEX 1.
                IF sy-subrc EQ 0.
                  <field> = lst_partnrm-low.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSEIF lst_reltypm-low EQ '*'.
            lv_wild = abap_true.
            <lst_head>-kunnr = abap_true.
            DELETE lt_soc_bp WHERE reltyp EQ abap_true.
            LOOP AT lt_soc_bp INTO DATA(lst_soc_mys) ."WHERE partner1 = <lst_head>-kunnr.
              CLEAR:lv_tbx.
              lv_tbx = sy-tabix.
              CLEAR:lst_used2.
              READ TABLE lt_used INTO lst_used2 WITH KEY kunnr = lst_head2-kunnr BINARY SEARCH .
              IF sy-subrc NE 0.

                CLEAR:lst_usedrel2.
                READ TABLE lt_usedrel INTO lst_usedrel2 WITH KEY reltyp = lst_soc_mys-reltyp BINARY SEARCH .
                IF sy-subrc NE 0.

                  CLEAR:lst_050.
                  READ TABLE li_but050 INTO DATA(lst_socbp_mys) WITH KEY partner1 = lst_head2-kunnr
                                                                    partner2 = lv_partner2
                                                                   reltyp = lst_soc_mys-reltyp BINARY SEARCH.
                  IF sy-subrc EQ 0.

                    ASSIGN lst_head2-caller_data->* TO <lst_data2>.
                    IF <lst_data2> IS ASSIGNED .

                      ASSIGN COMPONENT 'ZZPARTNER2_MYS' OF STRUCTURE <lst_data2> TO <field>.
                      IF sy-subrc EQ 0.
                        READ TABLE lt_partner2 INTO DATA(lst_partnrbp_mys) INDEX 1.
                        IF sy-subrc EQ 0.
                          <field> = lst_partnrbp_mys-low.
                          lst_used-kunnr = lst_head2-kunnr.
                        ENDIF.
                      ENDIF.

                      ASSIGN COMPONENT 'ZZRELTYP_MYS' OF STRUCTURE <lst_data2> TO <field>.
                      IF <lst_data2> IS ASSIGNED .
                        <field> = lst_soc_mys-reltyp.
                        lst_used-reltyp = lst_soc_mys-reltyp.
                      ENDIF.

                      APPEND lst_used TO lt_used.
                      APPEND lst_used TO lt_usedrel.
                      CLEAR:lst_used.
                      SORT lt_used BY kunnr.
                      SORT lt_usedrel BY reltyp.
                    ENDIF.
                    lv_vbeln = lv_vbeln + 1.
                    <lst_head>-kunnr = abap_true.
                    lst_head2-vbeln+1(9) = lv_vbeln.
                    APPEND  lst_head2 TO ct_head2.

                    lst_soc_mys-reltyp = abap_true.
                    MODIFY lt_soc_bp FROM lst_soc_mys INDEX lv_tbx TRANSPORTING reltyp.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

*  Populate Relationship type category and Soceity BP  of LPS to Header communication structure
    IF lt_rellps[] IS NOT INITIAL .

      ASSIGN COMPONENT 'ZZRELTYP_LPS' OF STRUCTURE <lst_data> TO <field>.
      IF sy-subrc EQ 0.
        READ TABLE lt_rellps INTO DATA(lst_rellps) INDEX 1.
        IF sy-subrc EQ 0.
          IF lst_rellps-low NE '*'.
            CLEAR:lst_050.
            READ TABLE li_but050 INTO lst_050 WITH KEY partner1 = <lst_head>-kunnr partner2 = lv_partner2
                                                             reltyp = lst_rellps-low BINARY SEARCH.
            IF sy-subrc EQ 0.
              <field> = lst_rellps-low.

              ASSIGN COMPONENT 'ZZPARTNER2_LPS' OF STRUCTURE <lst_data> TO <field>.
              IF sy-subrc EQ 0.
                READ TABLE lt_partner2 INTO DATA(lst_partnrl) INDEX 1.
                IF sy-subrc EQ 0.
                  <field> = lst_partnrl-low.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSEIF lst_rellps-low EQ '*'.
            <lst_head>-kunnr = abap_true.
            lv_wild = abap_true.
            DELETE lt_soc_bp WHERE reltyp EQ abap_true.
            LOOP AT lt_soc_bp INTO DATA(lst_soc_lps) ."WHERE partner1 = <lst_head>-kunnr.
              CLEAR:lv_tbx.
              lv_tbx = sy-tabix.
              CLEAR:lst_used2.
              READ TABLE lt_used INTO lst_used2 WITH KEY kunnr = lst_head2-kunnr BINARY SEARCH .
              IF sy-subrc NE 0.

                CLEAR:lst_usedrel2.
                READ TABLE lt_usedrel INTO lst_usedrel2 WITH KEY reltyp = lst_soc_lps-reltyp BINARY SEARCH .
                IF sy-subrc NE 0.

                  CLEAR:lst_050.
                  READ TABLE li_but050 INTO DATA(lst_socbp_lps) WITH KEY partner1 = lst_head2-kunnr
                                                                    partner2 = lv_partner2
                                                                   reltyp = lst_soc_lps-reltyp BINARY SEARCH.
                  IF sy-subrc EQ 0.

                    ASSIGN lst_head2-caller_data->* TO <lst_data2>.
                    IF <lst_data2> IS ASSIGNED .

                      ASSIGN COMPONENT 'ZZPARTNER2_LPS' OF STRUCTURE <lst_data2> TO <field>.
                      IF sy-subrc EQ 0.
                        READ TABLE lt_partner2 INTO DATA(lst_partnrbp_lps) INDEX 1.
                        IF sy-subrc EQ 0.
                          <field> = lst_partnrbp_lps-low.
                          lst_used-kunnr = lst_head2-kunnr.
                        ENDIF.
                      ENDIF.

                      ASSIGN COMPONENT 'ZZRELTYP_LPS' OF STRUCTURE <lst_data2> TO <field>.
                      IF <lst_data2> IS ASSIGNED .
                        <field> = lst_soc_lps-reltyp.
                        lst_used-reltyp = lst_soc_lps-reltyp.
                      ENDIF.

                      APPEND lst_used TO lt_used.
                      APPEND lst_used TO lt_usedrel.
                      CLEAR:lst_used.
                      SORT lt_used BY kunnr.
                      SORT lt_usedrel BY reltyp.
                    ENDIF.
                    lv_vbeln = lv_vbeln + 1.
                    <lst_head>-kunnr = abap_true.
                    lst_head2-vbeln+1(9) = lv_vbeln.
                    APPEND  lst_head2 TO ct_head2.
                    lst_soc_lps-reltyp = abap_true.
                    MODIFY lt_soc_bp FROM lst_soc_lps INDEX lv_tbx TRANSPORTING reltyp.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.

IF  lv_wild EQ abap_true.
  EXPORT lt_used FROM lt_used TO MEMORY ID 'VNLN'.
  FREE: ct_head[].
  CLEAR:lv_vbeln.
*  LOOP AT lt_item INTO lst_item.
*    lv_vbeln = lv_vbeln + 1.
*    READ TABLE ct_head2 INTO lst_head2 INDEX sy-tabix.
*    ASSIGN lst_head2-caller_data->* TO <lst_data>.
*    lst_head2-vbeln+0(1) = '$'.
*    lst_head2-vbeln+1(9) = lv_vbeln.
*    lst_head2-kunnr = lv_kunnr.
*    lst_head2-spras = 'E'.
*    <lst_data> = lst_item.
*    APPEND lst_head2 TO ct_head.
*  ENDLOOP.
  APPEND LINES OF ct_head2 TO ct_head.
  IF ct_head[] IS INITIAL.
    FREE:ct_item[].
    MESSAGE 'No customers found with Society BP Relationship Categories' TYPE 'E' DISPLAY LIKE 'S'.
    LEAVE  LIST-PROCESSING.
  ENDIF.
ENDIF.

* Fill Item level Validity Period from selection screen
LOOP AT ct_item ASSIGNING FIELD-SYMBOL(<lst_ctitem>).
  ASSIGN <lst_ctitem>-caller_data->* TO <lst_item>.
  IF <lst_item> IS ASSIGNED.
    ASSIGN COMPONENT 'ZZVLAUFK' OF STRUCTURE <lst_item> TO <field>.
    IF sy-subrc EQ 0.
      READ TABLE lt_vlaufk INTO DATA(lst_valfk) INDEX 1.
      IF sy-subrc EQ 0.
        <field> = lst_valfk-low.
      ENDIF.
    ENDIF.

* Populate Material type to Item communication structure
    READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = <lst_ctitem>-matnr BINARY SEARCH.
    IF sy-subrc EQ 0 AND lst_mara-mtart IS NOT INITIAL.
      ASSIGN COMPONENT 'MTART' OF STRUCTURE <lst_item> TO <field>.
      IF sy-subrc EQ 0.
        <field> = lst_mara-mtart.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.
