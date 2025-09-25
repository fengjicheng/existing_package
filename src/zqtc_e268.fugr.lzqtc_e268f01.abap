*----------------------------------------------------------------------*
***INCLUDE LZQTC_E268F01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923403
* REFERENCE NO: E268
* DEVELOPER: Thilina Dimantha
* DATE: 12-May-2021
* DESCRIPTION: Add PO History related fields to ME2N ME2M Output
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923969
* REFERENCE NO: E268 / OTCM-48208
* DEVELOPER: Thilina Dimantha
* DATE: 29-June-2021
* DESCRIPTION: Output Changes for ME2M and ME2N
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_BASE_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_TAB  text
*      <--P_I_TABLE_PUR_DIS  text
*----------------------------------------------------------------------*
FORM f_base_selection  USING    p_im_tab TYPE ANY TABLE
                       CHANGING p_i_table_pur_dis TYPE ztqtc_merep_outtab_purchdoc.

  i_table_pur = p_im_tab. "Copy standard table to basic view cusom table
  IF i_table_pur IS NOT INITIAL.
*Select GR Document data
    SELECT ebeln, ebelp, belnr, budat,
      menge, bwart, gjahr
      FROM ekbe
      INTO TABLE @DATA(li_grnum)
      FOR ALL ENTRIES IN @i_table_pur
      WHERE ebeln = @i_table_pur-ebeln
      AND ebelp = @i_table_pur-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND vgabe = @lc_gr
      AND vgabe IN @ir_gr_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND bewtp = @lc_grcat.
      AND bewtp IN @ir_gr_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_grnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          ebeln, ebelp, sjahr, smbln
          FROM mseg
          INTO TABLE @DATA(li_grrev)
          FOR ALL ENTRIES IN @li_grnum
          WHERE ebeln = @li_grnum-ebeln
          AND ebelp = @li_grnum-ebelp
          AND sjahr = @li_grnum-gjahr
          AND smbln = @li_grnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.

*Select IR Document Data
    SELECT ebeln, ebelp, belnr, budat,
     menge, dmbtr, waers, gjahr
     FROM ekbe
     INTO TABLE @DATA(li_irnum)
     FOR ALL ENTRIES IN @i_table_pur
     WHERE ebeln = @i_table_pur-ebeln
     AND ebelp = @i_table_pur-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND vgabe = @lc_ir
     AND vgabe IN @ir_ir_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
     AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND bewtp = @lc_ircat.
     AND bewtp IN @ir_ir_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_irnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          ebeln, ebelp, sjahr, smbln
          FROM mseg
          INTO TABLE @DATA(li_irrev)
          FOR ALL ENTRIES IN @li_irnum
          WHERE ebeln = @li_irnum-ebeln
          AND ebelp = @li_irnum-ebelp
          AND sjahr = @li_irnum-gjahr
          AND smbln = @li_irnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.
  ENDIF.
*BOC ED2K924089 TDIMANTHA 13-July-2021
**BOI ED2K923663 TDIMANTHA 04-June-2021
*  SORT li_grnum BY ebeln ebelp belnr gjahr.
*  SORT li_irnum BY ebeln ebelp belnr gjahr.
**Removing Revesed documents
*  LOOP AT li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>).
*    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnum>)
*                        WITH KEY ebeln = <lf_grrev>-ebeln
*                        ebelp = <lf_grrev>-ebelp
*                        belnr = <lf_grrev>-smbln
*                        gjahr = <lf_grrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_grnum> IS ASSIGNED.
*      DELETE li_grnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
*  LOOP AT li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>).
*    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnum>)
*                        WITH KEY ebeln = <lf_irrev>-ebeln
*                        ebelp = <lf_irrev>-ebelp
*                        belnr = <lf_irrev>-smbln
*                        gjahr = <lf_irrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_irnum> IS ASSIGNED.
*      DELETE li_irnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
**EOI ED2K923663 TDIMANTHA 04-June-2021
*EOC ED2K924089 TDIMANTHA 13-July-2021
  SORT li_grnum BY ebeln ebelp belnr.
  SORT li_irnum BY ebeln ebelp belnr.
  SORT li_grrev BY ebeln ebelp smbln sjahr.
  SORT li_irrev BY ebeln ebelp smbln sjahr.
*BOC ED2K924089 TDIMANTHA 13-July-2021
*  LOOP AT i_table_pur ASSIGNING FIELD-SYMBOL(<row1>).
*    CLEAR: lv_index, li_gr_tmp, li_ir_tmp, lv_gr_lines, lv_ir_lines.
*
*    li_gr_tmp = li_grnum.
*    li_ir_tmp = li_irnum.
*    DELETE li_gr_tmp WHERE ebeln NE <row1>-ebeln. "AND ebelp NE <row1>-ebelp.
*    DELETE li_gr_tmp WHERE ebelp NE <row1>-ebelp.
*    DELETE li_ir_tmp WHERE ebeln NE <row1>-ebeln. "AND ebelp NE <row1>-ebelp.
*    DELETE li_ir_tmp WHERE ebelp NE <row1>-ebelp.
*    lv_gr_lines = lines( li_gr_tmp ).                       "ED2K924089
*    lv_ir_lines = lines( li_ir_tmp ).
*
*    IF lv_gr_lines GE lv_ir_lines.  "IF more GR documents than IR documents
*      IF lv_gr_lines EQ 0.
*        CLEAR: ls_table_pur.
*        ls_table_pur = <row1>.
*        APPEND ls_table_pur TO i_table_pur_dis.
*      ENDIF.
*      LOOP AT li_gr_tmp ASSIGNING FIELD-SYMBOL(<lf_gr>). "Then Loop at GR documents and read corresponding IRs "#EC CI_NESTED
*
*        CLEAR: ls_table_pur.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_pur = <row1>.
*        ELSE.
*          ls_table_pur-ebeln = <row1>-ebeln.
*          ls_table_pur-ebelp = <row1>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_pur-ematn = <row1>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_pur-gr_number = <lf_gr>-belnr.
*        ls_table_pur-gr_doc_dt = <lf_gr>-budat.
*        ls_table_pur-gr_doc_qt = <lf_gr>-menge.
*        ls_table_pur-gr_mvt    = <lf_gr>-bwart.
*
*        READ TABLE li_ir_tmp ASSIGNING FIELD-SYMBOL(<lf_ir>) INDEX lv_index.
*        IF <lf_ir> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_pur-ir_number = <lf_ir>-belnr.
*          ls_table_pur-ir_doc_dt = <lf_ir>-budat.
*          ls_table_pur-ir_doc_qt = <lf_ir>-menge.
*          ls_table_pur-ir_loc_am = <lf_ir>-dmbtr.
*          ls_table_pur-ir_loc_cr = <lf_ir>-waers.
*          UNASSIGN <lf_ir>.
*        ENDIF.
*        APPEND ls_table_pur TO i_table_pur_dis.
*
*      ENDLOOP.
*    ELSE.                                   "IF more IR documents than GR documents
*      LOOP AT li_ir_tmp ASSIGNING <lf_ir>.  "Then Loop at IR documents and read corresponding GR documents "#EC CI_NESTED
*
*        CLEAR: ls_table_pur.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_pur = <row1>.
*        ELSE.
*          ls_table_pur-ebeln = <row1>-ebeln.
*          ls_table_pur-ebelp = <row1>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_pur-ematn = <row1>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_pur-ir_number = <lf_ir>-belnr.
*        ls_table_pur-ir_doc_dt = <lf_ir>-budat.
*        ls_table_pur-ir_doc_qt = <lf_ir>-menge.
*        ls_table_pur-ir_loc_am = <lf_ir>-dmbtr.
*        ls_table_pur-ir_loc_cr = <lf_ir>-waers.
*
*        READ TABLE li_gr_tmp ASSIGNING <lf_gr> INDEX lv_index.
*        IF <lf_gr> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_pur-gr_number = <lf_gr>-belnr.
*          ls_table_pur-gr_doc_dt = <lf_gr>-budat.
*          ls_table_pur-gr_doc_qt = <lf_gr>-menge.
*          ls_table_pur-gr_mvt    = <lf_gr>-bwart.
*          UNASSIGN <lf_gr>.
*        ENDIF.
*        APPEND ls_table_pur TO p_i_table_pur_dis.
*
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
*EOC ED2K924089 TDIMANTHA 13-July-2021
*BOI ED2K924089 TDIMANTHA 13-July-2021
  LOOP AT i_table_pur ASSIGNING FIELD-SYMBOL(<row2>).
    lv_no_ir_read = abap_false.
    lv_no_gr_read = abap_false.
    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_gr = sy-tabix. "Index of first GR document for current PO item
    ELSE.
      lv_no_gr_read = abap_true. "No GR Documents for current PO item
    ENDIF.
    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_ir = sy-tabix. "Index for first IR document for current PO item
    ELSE.
      lv_no_ir_read = abap_true. "No IR Documents for current PO item
    ENDIF.
    IF lv_no_gr_read = abap_true AND lv_no_ir_read = abap_true. "If NO GRs and NO IRs just append to output
      CLEAR ls_table_pur.
      ls_table_pur = <row2>.
      APPEND ls_table_pur TO p_i_table_pur_dis.
    ELSE.
      CLEAR lv_count.
      IF lv_no_gr_read = abap_false. "IF GR documents exist for PO item
        LOOP AT li_grnum ASSIGNING <lf_grnmb> FROM lv_indx_gr.
          IF ( <lf_grnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_grnmb>-ebelp NE <row2>-ebelp ).
            EXIT.
          ENDIF.
          READ TABLE li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>)
                                WITH KEY ebeln = <lf_grnmb>-ebeln ebelp = <lf_grnmb>-ebelp
                                         smbln = <lf_grnmb>-belnr sjahr = <lf_grnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
             CONTINUE. "Do not display reversed GR documents
          ENDIF.
          CLEAR: ls_table_pur.
          IF lv_count = 0. "If adding first line for current PO item
            ls_table_pur = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_pur-ebeln = <row2>-ebeln.
          ls_table_pur-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_pur-ematn = <row2>-ematn.
          ENDIF.
          ls_table_pur-gr_number = <lf_grnmb>-belnr. "Fill GR document number to current line
          ls_table_pur-gr_doc_dt = <lf_grnmb>-budat.
          ls_table_pur-gr_doc_qt = <lf_grnmb>-menge.
          ls_table_pur-gr_mvt    = <lf_grnmb>-bwart.

          IF lv_no_ir_read = abap_false. "IF IR documents exist for the same PO item
            LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
              IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
                lv_no_ir_read = abap_true.
                EXIT.
              ENDIF.
              ADD 1 TO lv_indx_ir.
              READ TABLE li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>)
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
              IF sy-subrc NE 0. "IF IR document is not reversed
                ls_table_pur-ir_number = <lf_irnmb>-belnr. "Fill both GR and IR document number to current line
                ls_table_pur-ir_doc_dt = <lf_irnmb>-budat.
                ls_table_pur-ir_doc_qt = <lf_irnmb>-menge.
                ls_table_pur-ir_loc_am = <lf_irnmb>-dmbtr.
                ls_table_pur-ir_loc_cr = <lf_irnmb>-waers.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
          APPEND ls_table_pur TO p_i_table_pur_dis.
        ENDLOOP.
      ENDIF.
      IF lv_no_ir_read = abap_false. "More IR documents exist for PO item
        LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
          IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
            lv_no_ir_read = abap_false.
            EXIT.
          ENDIF.
          READ TABLE li_irrev ASSIGNING <lf_irrev>
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE. "Do not display reversed documents
          ENDIF.
          CLEAR: ls_table_pur.
          IF lv_count = 0. "IF adding first line for current PO item
            ls_table_pur = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_pur-ebeln = <row2>-ebeln.
          ls_table_pur-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_pur-ematn = <row2>-ematn.
          ENDIF.
          ls_table_pur-ir_number = <lf_irnmb>-belnr.
          ls_table_pur-ir_doc_dt = <lf_irnmb>-budat.
          ls_table_pur-ir_doc_qt = <lf_irnmb>-menge.
          ls_table_pur-ir_loc_am = <lf_irnmb>-dmbtr.
          ls_table_pur-ir_loc_cr = <lf_irnmb>-waers.
          APPEND ls_table_pur TO p_i_table_pur_dis.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
*EOI ED2K924089 TDIMANTHA 13-July-2021
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCHEDULE_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_ITAB  text
*      <--P_I_TABLE_SCHE_DIS  text
*----------------------------------------------------------------------*
FORM f_schedule_selection  USING    p_im_itab TYPE ANY TABLE
                           CHANGING p_i_table_sche_dis TYPE ztqtc_merep_outtab_schedlines.

  i_table_sche = p_im_itab.        "Copy standard table to Schedule Line view cusom table
  IF i_table_sche IS NOT INITIAL.
*Select GR Document data
    SELECT ebeln, ebelp, belnr, budat,
      menge, bwart, gjahr
      FROM ekbe
      INTO TABLE @DATA(li_grnum)
      FOR ALL ENTRIES IN @i_table_sche
      WHERE ebeln = @i_table_sche-ebeln
      AND ebelp = @i_table_sche-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND vgabe = @lc_gr
      AND vgabe IN @ir_gr_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND bewtp = @lc_grcat.
      AND bewtp IN @ir_gr_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_grnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          ebeln, ebelp, sjahr, smbln
          FROM mseg
          INTO TABLE @DATA(li_grrev)
          FOR ALL ENTRIES IN @li_grnum
          WHERE ebeln = @li_grnum-ebeln
          AND ebelp = @li_grnum-ebelp
          AND sjahr = @li_grnum-gjahr
          AND smbln = @li_grnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.
*Select IR Document data
    SELECT ebeln, ebelp, belnr, budat,
     menge, dmbtr, waers, gjahr
     FROM ekbe
     INTO TABLE @DATA(li_irnum)
     FOR ALL ENTRIES IN @i_table_sche
     WHERE ebeln = @i_table_sche-ebeln
     AND ebelp = @i_table_sche-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND vgabe = @lc_ir
     AND vgabe IN @ir_ir_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
     AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND bewtp = @lc_ircat.
    AND bewtp IN @ir_ir_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_irnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          ebeln, ebelp, sjahr, smbln
          FROM mseg
          INTO TABLE @DATA(li_irrev)
          FOR ALL ENTRIES IN @li_irnum
          WHERE ebeln = @li_irnum-ebeln
          AND ebelp = @li_irnum-ebelp
          AND sjahr = @li_irnum-gjahr
          AND smbln = @li_irnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.
  ENDIF.
*BOC ED2K924089 TDIMANTHA 13-July-2021
**BOI ED2K923663 TDIMANTHA 04-June-2021
*  SORT li_grnum BY ebeln ebelp belnr gjahr.
*  SORT li_irnum BY ebeln ebelp belnr gjahr.
**Removing Revesed documents
*  LOOP AT li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>).
*    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnum>)
*                        WITH KEY ebeln = <lf_grrev>-ebeln
*                        ebelp = <lf_grrev>-ebelp
*                        belnr = <lf_grrev>-smbln
*                        gjahr = <lf_grrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_grnum> IS ASSIGNED.
*      DELETE li_grnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
*  LOOP AT li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>).
*    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnum>)
*                        WITH KEY ebeln = <lf_irrev>-ebeln
*                        ebelp = <lf_irrev>-ebelp
*                        belnr = <lf_irrev>-smbln
*                        gjahr = <lf_irrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_irnum> IS ASSIGNED.
*      DELETE li_irnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
**EOI ED2K923663 TDIMANTHA 04-June-2021
*EOC ED2K924089 TDIMANTHA 13-July-2021
  SORT li_grnum BY ebeln ebelp belnr.
  SORT li_irnum BY ebeln ebelp belnr.
  SORT li_grnum BY ebeln ebelp belnr gjahr.
  SORT li_irnum BY ebeln ebelp belnr gjahr.
*  LOOP AT i_table_sche ASSIGNING FIELD-SYMBOL(<row2>).
*    CLEAR: lv_index, li_gr_tmp, li_ir_tmp, lv_gr_lines, lv_ir_lines.
*
*    li_gr_tmp = li_grnum.
*    li_ir_tmp = li_irnum.
*    DELETE li_gr_tmp WHERE ebeln NE <row2>-ebeln. "AND ebelp NE <row2>-ebelp.
*    DELETE li_gr_tmp WHERE ebelp NE <row2>-ebelp.
*    DELETE li_ir_tmp WHERE ebeln NE <row2>-ebeln. "AND ebelp NE <row2>-ebelp.
*    DELETE li_ir_tmp WHERE ebelp NE <row2>-ebelp.
*    lv_gr_lines = lines( li_gr_tmp ).
*    lv_ir_lines = lines( li_ir_tmp ).
*
*    IF lv_gr_lines GE lv_ir_lines.
*      IF lv_gr_lines EQ 0.
*        CLEAR: ls_table_sche.
*        ls_table_sche = <row2>.
*        APPEND ls_table_sche TO i_table_sche_dis.
*      ENDIF.
*      LOOP AT li_gr_tmp ASSIGNING FIELD-SYMBOL(<lf_gr>). "#EC CI_NESTED
*
*        CLEAR: ls_table_sche.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_sche = <row2>.
*        ELSE.
*          ls_table_sche-ebeln = <row2>-ebeln.
*          ls_table_sche-ebelp = <row2>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_sche-ematn = <row2>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_sche-gr_number = <lf_gr>-belnr.
*        ls_table_sche-gr_doc_dt = <lf_gr>-budat.
*        ls_table_sche-gr_doc_qt = <lf_gr>-menge.
*        ls_table_sche-gr_mvt    = <lf_gr>-bwart.
*
*        READ TABLE li_ir_tmp ASSIGNING FIELD-SYMBOL(<lf_ir>) INDEX lv_index.
*        IF <lf_ir> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_sche-ir_number = <lf_ir>-belnr.
*          ls_table_sche-ir_doc_dt = <lf_ir>-budat.
*          ls_table_sche-ir_doc_qt = <lf_ir>-menge.
*          ls_table_sche-ir_loc_am = <lf_ir>-dmbtr.
*          ls_table_sche-ir_loc_cr = <lf_ir>-waers.
*          UNASSIGN <lf_ir>.
*        ENDIF.
*        APPEND ls_table_sche TO i_table_sche_dis.
*
*      ENDLOOP.
*    ELSE.
*      LOOP AT li_ir_tmp ASSIGNING <lf_ir>.               "#EC CI_NESTED
*
*        CLEAR: ls_table_sche.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_sche = <row2>.
*        ELSE.
*          ls_table_sche-ebeln = <row2>-ebeln.
*          ls_table_sche-ebelp = <row2>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_sche-ematn = <row2>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_sche-ir_number = <lf_ir>-belnr.
*        ls_table_sche-ir_doc_dt = <lf_ir>-budat.
*        ls_table_sche-ir_doc_qt = <lf_ir>-menge.
*        ls_table_sche-ir_loc_am = <lf_ir>-dmbtr.
*        ls_table_sche-ir_loc_cr = <lf_ir>-waers.
*
*        READ TABLE li_gr_tmp ASSIGNING <lf_gr> INDEX lv_index.
*        IF <lf_gr> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_sche-gr_number = <lf_gr>-belnr.
*          ls_table_sche-gr_doc_dt = <lf_gr>-budat.
*          ls_table_sche-gr_doc_qt = <lf_gr>-menge.
*          ls_table_sche-gr_mvt    = <lf_gr>-bwart.
*          UNASSIGN <lf_gr>.
*        ENDIF.
*        APPEND ls_table_sche TO p_i_table_sche_dis.
*
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
*BOI ED2K924089 TDIMANTHA 13-July-2021
  LOOP AT i_table_sche ASSIGNING FIELD-SYMBOL(<row2>).
    lv_no_ir_read = abap_false.
    lv_no_gr_read = abap_false.
    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_gr = sy-tabix. "Index of first GR document for current PO item
    ELSE.
      lv_no_gr_read = abap_true. "No GR Documents for current PO item
    ENDIF.
    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_ir = sy-tabix. "Index for first IR document for current PO item
    ELSE.
      lv_no_ir_read = abap_true. "No IR Documents for current PO item
    ENDIF.
    IF lv_no_gr_read = abap_true AND lv_no_ir_read = abap_true. "If NO GRs and NO IRs just append to output
      CLEAR ls_table_sche.
      ls_table_sche = <row2>.
      APPEND ls_table_sche TO p_i_table_sche_dis.
    ELSE.
      CLEAR lv_count.
      IF lv_no_gr_read = abap_false. "IF GR documents exist for PO item
        LOOP AT li_grnum ASSIGNING <lf_grnmb> FROM lv_indx_gr.
          IF ( <lf_grnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_grnmb>-ebelp NE <row2>-ebelp ).
            EXIT.
          ENDIF.
          READ TABLE li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>)
                                WITH KEY ebeln = <lf_grnmb>-ebeln ebelp = <lf_grnmb>-ebelp
                                         smbln = <lf_grnmb>-belnr sjahr = <lf_grnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE. "Do not display reversed GR documents
          ENDIF.
          CLEAR: ls_table_sche.
          IF lv_count = 0. "If adding first line for current PO item
            ls_table_sche = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_sche-ebeln = <row2>-ebeln.
          ls_table_sche-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_sche-ematn = <row2>-ematn.
          ENDIF.
          ls_table_sche-gr_number = <lf_grnmb>-belnr. "Fill GR document number to current line
          ls_table_sche-gr_doc_dt = <lf_grnmb>-budat.
          ls_table_sche-gr_doc_qt = <lf_grnmb>-menge.
          ls_table_sche-gr_mvt    = <lf_grnmb>-bwart.

          IF lv_no_ir_read = abap_false. "IF IR documents exist for the same PO item
            LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
              IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
                lv_no_ir_read = abap_true.
                EXIT.
              ENDIF.
              ADD 1 TO lv_indx_ir.
              READ TABLE li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>)
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
              IF sy-subrc NE 0. "IF IR document is not reversed
                ls_table_sche-ir_number = <lf_irnmb>-belnr. "Fill both GR and IR document number to current line
                ls_table_sche-ir_doc_dt = <lf_irnmb>-budat.
                ls_table_sche-ir_doc_qt = <lf_irnmb>-menge.
                ls_table_sche-ir_loc_am = <lf_irnmb>-dmbtr.
                ls_table_sche-ir_loc_cr = <lf_irnmb>-waers.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
          APPEND ls_table_sche TO p_i_table_sche_dis.
        ENDLOOP.
      ENDIF.
      IF lv_no_ir_read = abap_false. "More IR documents exist for PO item
        LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
          IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
            lv_no_ir_read = abap_false.
            EXIT.
          ENDIF.
          READ TABLE li_irrev ASSIGNING <lf_irrev>
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE. "Do not display reversed documents
          ENDIF.
          CLEAR: ls_table_sche.
          IF lv_count = 0. "IF adding first line for current PO item
            ls_table_sche = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_sche-ebeln = <row2>-ebeln.
          ls_table_sche-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_sche-ematn = <row2>-ematn.
          ENDIF.
          ls_table_sche-ir_number = <lf_irnmb>-belnr.
          ls_table_sche-ir_doc_dt = <lf_irnmb>-budat.
          ls_table_sche-ir_doc_qt = <lf_irnmb>-menge.
          ls_table_sche-ir_loc_am = <lf_irnmb>-dmbtr.
          ls_table_sche-ir_loc_cr = <lf_irnmb>-waers.
          APPEND ls_table_sche TO p_i_table_sche_dis.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
*EOI ED2K924089 TDIMANTHA 13-July-2021
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ACCOUNT_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_ITAB  text
*      <--P_I_TABLE_ACC_DIS  text
*----------------------------------------------------------------------*
FORM f_account_selection  USING    p_im_itab TYPE ANY TABLE
                          CHANGING p_i_table_acc_dis TYPE ztqtc_merep_outtab_accounting.

  i_table_acc = p_im_itab.             "Copy standard table to Acct Assignment view cusom table

  IF i_table_acc IS NOT INITIAL.
*Select GR Document data
    SELECT ebeln, ebelp, belnr, budat,
      menge, bwart, gjahr
      FROM ekbe
      INTO TABLE @DATA(li_grnum)
      FOR ALL ENTRIES IN @i_table_acc
      WHERE ebeln = @i_table_acc-ebeln
      AND ebelp = @i_table_acc-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND vgabe = @lc_gr
      AND vgabe IN @ir_gr_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      AND bewtp = @lc_grcat.
     AND bewtp IN @ir_gr_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_grnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,
          ebeln, ebelp, sjahr, smbln "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          FROM mseg
          INTO TABLE @DATA(li_grrev)
          FOR ALL ENTRIES IN @li_grnum
          WHERE ebeln = @li_grnum-ebeln
          AND ebelp = @li_grnum-ebelp
          AND sjahr = @li_grnum-gjahr
          AND smbln = @li_grnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.
*Select IR Document data
    SELECT ebeln, ebelp, belnr, budat,
     menge, dmbtr, waers, gjahr
     FROM ekbe
     INTO TABLE @DATA(li_irnum)
     FOR ALL ENTRIES IN @i_table_acc
     WHERE ebeln = @i_table_acc-ebeln
     AND ebelp = @i_table_acc-ebelp
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND vgabe = @lc_ir
     AND vgabe IN @ir_ir_typ
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
     AND shkzg = @lc_debit
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*     AND bewtp = @lc_ircat.
     AND bewtp IN @ir_ir_cat.
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
    IF sy-subrc EQ 0.
*BOI ED2K923663 TDIMANTHA 04-June-2021
*Checking for reversed documents
      IF li_irnum IS NOT INITIAL.
        SELECT mblnr, mjahr, zeile,  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          ebeln, ebelp, sjahr, smbln
          FROM mseg
          INTO TABLE @DATA(li_irrev)
          FOR ALL ENTRIES IN @li_irnum
          WHERE ebeln = @li_irnum-ebeln
          AND ebelp = @li_irnum-ebelp
          AND sjahr = @li_irnum-gjahr
          AND smbln = @li_irnum-belnr.
      ENDIF.
*EOI ED2K923663 TDIMANTHA 04-June-2021
    ENDIF.
  ENDIF.
*BOC ED2K924089 TDIMANTHA 13-July-2021
**BOI ED2K923663 TDIMANTHA 04-June-2021
*  SORT li_grnum BY ebeln ebelp belnr gjahr.
*  SORT li_irnum BY ebeln ebelp belnr gjahr.
**Removing Revesed documents
*  LOOP AT li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>).
*    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnum>)
*                        WITH KEY ebeln = <lf_grrev>-ebeln
*                        ebelp = <lf_grrev>-ebelp
*                        belnr = <lf_grrev>-smbln
*                        gjahr = <lf_grrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_grnum> IS ASSIGNED.
*      DELETE li_grnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
*  LOOP AT li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>).
*    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnum>)
*                        WITH KEY ebeln = <lf_irrev>-ebeln
*                        ebelp = <lf_irrev>-ebelp
*                        belnr = <lf_irrev>-smbln
*                        gjahr = <lf_irrev>-sjahr
*                        BINARY SEARCH.
*    IF sy-subrc = 0 AND <lf_irnum> IS ASSIGNED.
*      DELETE li_irnum INDEX sy-tabix.
*    ENDIF.
*  ENDLOOP.
**EOI ED2K923663 TDIMANTHA 04-June-2021
*EOC ED2K924089 TDIMANTHA 13-July-2021
  SORT li_grnum BY ebeln ebelp belnr.
  SORT li_irnum BY ebeln ebelp belnr.
  SORT li_grnum BY ebeln ebelp belnr gjahr.
  SORT li_irnum BY ebeln ebelp belnr gjahr.
*  LOOP AT i_table_acc ASSIGNING FIELD-SYMBOL(<row3>).
*    CLEAR: lv_index, li_gr_tmp, li_ir_tmp, lv_gr_lines, lv_ir_lines.
*
*    li_gr_tmp = li_grnum.
*    li_ir_tmp = li_irnum.
*    DELETE li_gr_tmp WHERE ebeln NE <row3>-ebeln. "AND ebelp NE <row3>-ebelp.
*    DELETE li_gr_tmp WHERE ebelp NE <row3>-ebelp.
*    DELETE li_ir_tmp WHERE ebeln NE <row3>-ebeln. "AND ebelp NE <row3>-ebelp.
*    DELETE li_ir_tmp WHERE ebelp NE <row3>-ebelp.
*    lv_gr_lines = lines( li_gr_tmp ).
*    lv_ir_lines = lines( li_ir_tmp ).
*
*    IF lv_gr_lines GE lv_ir_lines.
*      IF lv_gr_lines EQ 0.
*        CLEAR: ls_table_acc.
*        ls_table_acc = <row3>.
*        APPEND ls_table_acc TO i_table_acc_dis.
*      ENDIF.
*      LOOP AT li_gr_tmp ASSIGNING FIELD-SYMBOL(<lf_gr>). "#EC CI_NESTED
*
*        CLEAR: ls_table_acc.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_acc = <row3>.
*        ELSE.
*          ls_table_acc-ebeln = <row3>-ebeln.
*          ls_table_acc-ebelp = <row3>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_acc-ematn = <row3>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_acc-gr_number = <lf_gr>-belnr.
*        ls_table_acc-gr_doc_dt = <lf_gr>-budat.
*        ls_table_acc-gr_doc_qt = <lf_gr>-menge.
*        ls_table_acc-gr_mvt    = <lf_gr>-bwart.
*
*        READ TABLE li_ir_tmp ASSIGNING FIELD-SYMBOL(<lf_ir>) INDEX lv_index.
*        IF <lf_ir> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_acc-ir_number = <lf_ir>-belnr.
*          ls_table_acc-ir_doc_dt = <lf_ir>-budat.
*          ls_table_acc-ir_doc_qt = <lf_ir>-menge.
*          ls_table_acc-ir_loc_am = <lf_ir>-dmbtr.
*          ls_table_acc-ir_loc_cr = <lf_ir>-waers.
*          UNASSIGN <lf_ir>.
*        ENDIF.
*        APPEND ls_table_acc TO i_table_acc_dis.
*
*      ENDLOOP.
*    ELSE.
*      LOOP AT li_ir_tmp ASSIGNING <lf_ir>.               "#EC CI_NESTED
*
*        CLEAR: ls_table_acc.
*        ADD 1 TO lv_index.
*        IF lv_index EQ 1.
*          ls_table_acc = <row3>.
*        ELSE.
*          ls_table_acc-ebeln = <row3>-ebeln.
*          ls_table_acc-ebelp = <row3>-ebelp.
*          IF sy-tcode = lc_me2m.
*            ls_table_acc-ematn = <row3>-ematn.
*          ENDIF.
*        ENDIF.
*        ls_table_acc-ir_number = <lf_ir>-belnr.
*        ls_table_acc-ir_doc_dt = <lf_ir>-budat.
*        ls_table_acc-ir_doc_qt = <lf_ir>-menge.
*        ls_table_acc-ir_loc_am = <lf_ir>-dmbtr.
*        ls_table_acc-ir_loc_cr = <lf_ir>-waers.
*
*        READ TABLE li_gr_tmp ASSIGNING <lf_gr> INDEX lv_index.
*        IF <lf_gr> IS ASSIGNED AND sy-subrc EQ 0.
*          ls_table_acc-gr_number = <lf_gr>-belnr.
*          ls_table_acc-gr_doc_dt = <lf_gr>-budat.
*          ls_table_acc-gr_doc_qt = <lf_gr>-menge.
*          ls_table_acc-gr_mvt    = <lf_gr>-bwart.
*          UNASSIGN <lf_gr>.
*        ENDIF.
*        APPEND ls_table_acc TO p_i_table_acc_dis.
*
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
*BOI ED2K924089 TDIMANTHA 13-July-2021
  LOOP AT i_table_acc ASSIGNING FIELD-SYMBOL(<row2>).
    lv_no_ir_read = abap_false.
    lv_no_gr_read = abap_false.
    READ TABLE li_grnum ASSIGNING FIELD-SYMBOL(<lf_grnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_gr = sy-tabix. "Index of first GR document for current PO item
    ELSE.
      lv_no_gr_read = abap_true. "No GR Documents for current PO item
    ENDIF.
    READ TABLE li_irnum ASSIGNING FIELD-SYMBOL(<lf_irnmb>)
                        WITH KEY ebeln = <row2>-ebeln ebelp = <row2>-ebelp
                        BINARY SEARCH.
    IF sy-subrc = 0.
      lv_indx_ir = sy-tabix. "Index for first IR document for current PO item
    ELSE.
      lv_no_ir_read = abap_true. "No IR Documents for current PO item
    ENDIF.
    IF lv_no_gr_read = abap_true AND lv_no_ir_read = abap_true. "If NO GRs and NO IRs just append to output
      CLEAR ls_table_acc.
      ls_table_acc = <row2>.
      APPEND ls_table_acc TO p_i_table_acc_dis.
    ELSE.
      CLEAR lv_count.
      IF lv_no_gr_read = abap_false. "IF GR documents exist for PO item
        LOOP AT li_grnum ASSIGNING <lf_grnmb> FROM lv_indx_gr.
          IF ( <lf_grnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_grnmb>-ebelp NE <row2>-ebelp ).
            EXIT.
          ENDIF.
          READ TABLE li_grrev ASSIGNING FIELD-SYMBOL(<lf_grrev>)
                                WITH KEY ebeln = <lf_grnmb>-ebeln ebelp = <lf_grnmb>-ebelp
                                         smbln = <lf_grnmb>-belnr sjahr = <lf_grnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE. "Do not display reversed GR documents
          ENDIF.
          CLEAR: ls_table_acc.
          IF lv_count = 0. "If adding first line for current PO item
            ls_table_acc = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_acc-ebeln = <row2>-ebeln.
          ls_table_acc-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_acc-ematn = <row2>-ematn.
          ENDIF.
          ls_table_acc-gr_number = <lf_grnmb>-belnr. "Fill GR document number to current line
          ls_table_acc-gr_doc_dt = <lf_grnmb>-budat.
          ls_table_acc-gr_doc_qt = <lf_grnmb>-menge.
          ls_table_acc-gr_mvt    = <lf_grnmb>-bwart.

          IF lv_no_ir_read = abap_false. "IF IR documents exist for the same PO item
            LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
              IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
                lv_no_ir_read = abap_true.
                EXIT.
              ENDIF.
              ADD 1 TO lv_indx_ir.
              READ TABLE li_irrev ASSIGNING FIELD-SYMBOL(<lf_irrev>)
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
              IF sy-subrc NE 0. "IF IR document is not reversed
                ls_table_acc-ir_number = <lf_irnmb>-belnr. "Fill both GR and IR document number to current line
                ls_table_acc-ir_doc_dt = <lf_irnmb>-budat.
                ls_table_acc-ir_doc_qt = <lf_irnmb>-menge.
                ls_table_acc-ir_loc_am = <lf_irnmb>-dmbtr.
                ls_table_acc-ir_loc_cr = <lf_irnmb>-waers.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
          APPEND ls_table_acc TO p_i_table_acc_dis.
        ENDLOOP.
      ENDIF.
      IF lv_no_ir_read = abap_false. "More IR documents exist for PO item
        LOOP AT li_irnum ASSIGNING <lf_irnmb> FROM lv_indx_ir.
          IF ( <lf_irnmb>-ebeln NE <row2>-ebeln ) OR ( <lf_irnmb>-ebelp NE <row2>-ebelp ).
            lv_no_ir_read = abap_false.
            EXIT.
          ENDIF.
          READ TABLE li_irrev ASSIGNING <lf_irrev>
                                WITH KEY ebeln = <lf_irnmb>-ebeln ebelp = <lf_irnmb>-ebelp
                                         smbln = <lf_irnmb>-belnr sjahr = <lf_irnmb>-gjahr
                                BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE. "Do not display reversed documents
          ENDIF.
          CLEAR: ls_table_acc.
          IF lv_count = 0. "IF adding first line for current PO item
            ls_table_acc = <row2>.
          ENDIF.
          ADD 1 TO lv_count.
          ls_table_acc-ebeln = <row2>-ebeln.
          ls_table_acc-ebelp = <row2>-ebelp.
          IF sy-tcode = lc_me2m.
            ls_table_acc-ematn = <row2>-ematn.
          ENDIF.
          ls_table_acc-ir_number = <lf_irnmb>-belnr.
          ls_table_acc-ir_doc_dt = <lf_irnmb>-budat.
          ls_table_acc-ir_doc_qt = <lf_irnmb>-menge.
          ls_table_acc-ir_loc_am = <lf_irnmb>-dmbtr.
          ls_table_acc-ir_loc_cr = <lf_irnmb>-waers.
          APPEND ls_table_acc TO p_i_table_acc_dis.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
*EOI ED2K924089 TDIMANTHA 13-July-2021
ENDFORM.
