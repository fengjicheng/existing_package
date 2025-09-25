"Name: \PR:RJKSDWORKLIST\FO:SELECTION_GET_DATA\SE:END\EI
ENHANCEMENT 0 ZSCM_ACTUAL_GA_DATE_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Enhancement for new Radio button: Actual GA Date
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-05-28
* DESCRIPTION: Journal First Print Optimization
*-----------------------------------------------------------------------*

* BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
  DATA: li_pdatu   TYPE RANGE OF dat01,
        lst_pdatu  LIKE LINE OF li_pdatu,
        li_fcat    TYPE LVC_T_FCAT,
        li_werks   TYPE RANGE OF WERKS_D,
        lst_werks  LIKE LINE OF li_werks.
* EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

  constants: con_arrivaldateac type fieldname value 'MARC~ISMARRIVALDATEAC'.

  CHECK sy-tcode = 'ZSCM_JKSD13_01' OR
        sy-tcode = 'ZSCM_JKSD13_03' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*        sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
        sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
  " Check whether the Enhancement is active ot not
  CHECK v_aflag_e223 = abap_true OR
        v_aflag_e244 = abap_true.

  " Check for 'Actual GA Date'/'Purchase Req Date' radio button selection
  CHECK rjksdworklist_changefields-xincl_phases = con_angekreuzt OR
        RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.

  " Clear the records
  refresh: pt_statuslist, lt_marc, lt_mvke.

  " Check for 'Actual GA Date' Radio button selection
  if rjksdworklist_changefields-xincl_phases = con_angekreuzt.
    t1 = con_arrivaldateac.
  endif.

* BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
  " Check for 'Purchase Req Date' Radio button selection
  IF RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.

    " Ranges for Finish Date
    lst_pdatu-sign = 'I'.
    lst_pdatu-option = 'BT'.
    lst_pdatu-low = sel_date_from.
    lst_pdatu-high = sel_date_to.
    APPEND lst_pdatu TO li_pdatu.
    CLEAR lst_pdatu.
    " Ranges for Plant
    IF gv_werk IS NOT INITIAL.
      lst_werks-sign = 'I'.
      lst_werks-option = 'EQ'.
      lst_werks-low = gv_werk.
      APPEND lst_werks TO li_werks.
      CLEAR lst_werks.
    ENDIF.

    " Fetch PIR Records
    SELECT pbim~matnr, pbim~werks, pbed~bdzei, SUM( pbed~plnmg ) AS plnmg
           FROM pbim INNER JOIN pbed
           ON pbim~bdzei = pbed~bdzei
           INTO CORRESPONDING FIELDS OF TABLE @i_pir_info
           WHERE pbim~matnr IN @gr_issue AND
                 pbim~werks IN @li_werks AND
                 pbim~bedae = 'LSF' AND
                 pbim~versb = '00' AND
                 pbed~pdatu IN @li_pdatu
           GROUP BY pbim~matnr, pbim~werks, pbed~bdzei.
    IF i_pir_info[] IS NOT INITIAL.
      SORT i_pir_info by MATNR.
      " In this MEDIA Cock-pit tool, data selection from MARC is based on
      " selected Radio Button(RB) date range. Since there is no Date field for
      " RB-'Purchase Req. Date' in MARC table, we are pulling the data from MARC
      " based on i_pir_info which is populated based on Purchase Req. Date range
      select * from marc into corresponding fields of table lt_marc
               for all entries in i_pir_info
               where matnr = i_pir_info-matnr and
                     werks = i_pir_info-werks.
    ENDIF. " i_pir_info[] is not initial.

  ENDIF. " IF RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.
* EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

* perform sel_by_PURCHDATE
  perform sel_by_marc_date
    using lt_medprod xsequence sel_date_from sel_date_to
          rjksdworklist_changefields
    changing pt_statuslist lt_marc lt_mvke.

* BOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271
  IF RJKSDWORKLIST_CHANGEFIELDS-XWITHOUT_PHASES = con_angekreuzt.
    LOOP AT pt_statuslist ASSIGNING FIELD-SYMBOL(<lst_statuslist>).
      READ TABLE i_pir_info INTO DATA(lst_pir_info) WITH key matnr = <lst_statuslist>-matnr
                            BINARY SEARCH.
      IF sy-subrc = 0.
        <lst_statuslist>-MARC_STOCK10 = lst_pir_info-plnmg.
        CLEAR lst_pir_info.
      ENDIF.
    ENDLOOP.
  ENDIF.
* EOC: ERPM-10175  KKRAVURI 28-MAY-2020  ED2K918271

* abhängig vom level werden gelesene Segmente gecleart
  case gv_segment_level.
    when con_level_mara.
      clear lt_marc. refresh lt_marc.
      clear lt_mvke. refresh lt_mvke.
    when con_level_mara_mvke.
      clear lt_marc. refresh lt_marc.
    when con_level_mara_marc.
      clear lt_mvke. refresh lt_mvke.
  endcase.

*  Phasenlogik (vorläufig?) wieder inaktiviert

*  if RJKSDWORKLIST_CHANGEFIELDS-xincl_phases = con_angekreuzt or
*     RJKSDWORKLIST_CHANGEFIELDS-xexcl_phases = con_angekreuzt.
*    clear lt_marc. refresh lt_marc.
*    clear lt_mvke. refresh lt_mvke.
*    perform read_JVTPHDATE using pt_statuslist
*                                 SEL_DATE_FROM SEL_DATE_to
*                        changing lt_JVTPHDATE.
*    if not lt_jvtphdate[] is initial.
*      perform merge_jvtphdate using lt_jvtphdate
*                           changing pt_statuslist.
*    endif.
*  endif.
* ---Ende-------------------------------------------"TK01022008

* Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
* ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
* (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
  perform check_industry_retail_mix
     using pt_statuslist
     changing xindustrymaterial xretailmaterial.
  if xindustrymaterial = con_angekreuzt    and
     xretailmaterial   = con_angekreuzt.
    clear pt_statuslist. refresh pt_statuslist.
    clear lt_marc.       refresh lt_marc.
    clear lt_mvke.       refresh lt_mvke.
*   EXIT. "=> Endform
  endif.
* Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Warnung, wenn (zu) viele Sperreinträge entstehen--Anfang-----"TK01072008
* Anzahl selektierter MARA-Sätze
  describe table pt_statuslist lines lv_mara_cnt.
  if gv_wl_enq_active = con_angekreuzt.
*   segmentweises Sperren aktiv: MARC/MVKE-Sätze mitzählen
    describe table lt_marc lines lv_marc_cnt.
    describe table lt_mvke lines lv_mvke_cnt.
  endif.
  lv_selected_objects_cnt = lv_mara_cnt + lv_marc_cnt + lv_mvke_cnt.
  if lv_selected_objects_cnt > gv_selection_warning_cnt.
    call screen con_dynnr_selection_warning starting at 40  15
                                            ending   at  110 22.

    if ok_code_0550 <> 'GOON'.
*     Neustart der Transaktion
      clear pt_statuslist. refresh pt_statuslist.
      clear lt_marc.       refresh lt_marc.
      clear lt_mvke.       refresh lt_mvke.
      xabort_selection = con_angekreuzt.
    endif.
  endif. " lv_selected_objects_cnt > gv_selection_warning_cnt.
* Warnung, (zu) wenn viele Sperreinträge entstehen--Ende-------"TK01072008

*-------Anfang Issue-Filterung---------------------------------"TK01402009
 if not gv_filt is initial.
   perform issue_filterung using gv_filt
                           changing pt_statuslist
                                    lt_marc
                                    lt_mvke.
 endif. " not gv_filt is initial.
*-------Ende   Issue-Filterung---------------------------------"TK01402009

* 2. ) Enhance PT_STATUSLIST by MARC and MVKE)
*      (PT:STATUSLIST contains one entry for each(!) MARA-entry)
* (Structure of PT_STATUSLIST : MARA   MARC1  MVKE1
*                                      MARC2  MVKE2
*                                             MVKE3   )

  call function 'ISM_ISSUE_STATUSTAB_ENHANCE'
    EXPORTING                                               "TK01102006
      it_baditab   = gt_badi_fields                         "TK01102006
    CHANGING
      ct_statustab = pt_statuslist
      it_marcstat  = lt_marc
      it_mvkestat  = lt_mvke.
*
* KEIN!! Sort hier               "TK14012005 Hinweis 809072
*  SORT PT_STATUSLIST BY ISMREFMDPROD SEQUENCE_LFDNR ISMPUBLDATE
*                         MARC_WERKS MVKE_VKORG MVKE_VTWEG.
*

* ----------- BADI zum füllen der Kundenfelder----------- "TK01102006
*  data: gt_change_worklist type jksdmaterialstatustab.

  gt_change_worklist[] = pt_statuslist[].

* aufruf Badi zum Füllen der Kundenfelder
  if not worklist_add_fields is initial.
    call badi worklist_add_fields->fill_customer_fields
      EXPORTING
        tcode              = sy-tcode   "Transaktionsvarianten
      CHANGING
        gt_change_worklist = gt_change_worklist.
  endif.

* Test Badi für Lesen und Füllen der Kundenfelder-------
* perform test_fill_customer_fields
*              changing gt_change_worklist .
* Test Badi für Lesen und Füllen der Kundenfelder-------

  pt_statuslist[] = gt_change_worklist[].
* ----------- BADI zum füllen der Kundenfelder----------- "TK01102006

* Save DB-Tables before change in dialog
  clear pt_dbtab. refresh pt_dbtab.
  pt_dbtab[] = pt_statuslist[].

* --- Anfang-----------optimistisches Sperren----- "TK01042008

* komlette Satzbetten müssen jetzt nachgelesen werden
*
*  data: ls_statuslist like line of pt_statuslist.
*  data: ls_marcstat type jksdmarcstat.
*  data: ls_mvkestat type jksdmvkestat.

* MARA:
* DB-Zustand MARA merken in GT_MARA_DB.
  clear pt_mara_db. refresh pt_mara_db.
* loop at pt_statuslist into ls_statuslist.             "TK25092009 hint1389068
*   select * from mara appending table pt_mara_db       "TK25092009 hint1389068
*     where matnr    = ls_statuslist-matnr.             "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  if not pt_statuslist[] is initial.                    "TK25092009 hint1389068
    select * from mara into table pt_mara_db            "TK25092009 hint1389068
      for all entries in pt_statuslist                  "TK25092009 hint1389068
      where matnr = pt_statuslist-matnr.                "TK25092009 hint1389068
  endif.                                                "TK25092009 hint1389068

* MARC:
* DB-Zustand MARC merken in GT_MARC_DB.
  clear pt_marc_db. refresh pt_marc_db.
* loop at lt_marc into ls_marcstat.                     "TK25092009 hint1389068
*   select * from marc appending table pt_marc_db       "TK25092009 hint1389068
*     where matnr    = ls_marcstat-matnr                "TK25092009 hint1389068
*     and   werks    = ls_marcstat-werks.               "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  if not lt_marc[] is initial.                          "TK25092009 hint1389068
    select * from marc into table pt_marc_db            "TK25092009 hint1389068
      for all entries in lt_marc                        "TK25092009 hint1389068
      where matnr = lt_marc-matnr                       "TK25092009 hint1389068
      and   werks = lt_marc-werks.                      "TK25092009 hint1389068
  endif.                                                "TK25092009 hint1389068

* MVKE:
* DB-Zustand MVKE merken in GT_MVKE_DB.
  clear pt_mvke_db. refresh pt_mvke_db.
* loop at lt_mvke into ls_mvkestat.                     "TK25092009 hint1389068
*   select * from mvke appending table pt_mvke_db       "TK25092009 hint1389068
*     where matnr    = ls_mvkestat-matnr                "TK25092009 hint1389068
*     and   vkorg    = ls_mvkestat-vkorg                "TK25092009 hint1389068
*     and   vtweg    = ls_mvkestat-vtweg.               "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  if not lt_mvke[] is initial.                          "TK25092009 hint1389068
    select * from mvke into table pt_mvke_db            "TK25092009 hint1389068
      for all entries in lt_mvke                        "TK25092009 hint1389068
      where matnr = lt_mvke-matnr                       "TK25092009 hint1389068
      and   vkorg = lt_mvke-vkorg                       "TK25092009 hint1389068
      and   vtweg = lt_mvke-vtweg.                      "TK25092009 hint1389068
  endif.                                                "TK25092009 hint1389068

  sort pt_mara_db.
  delete adjacent duplicates from pt_mara_db.
  sort pt_marc_db.
  delete adjacent duplicates from pt_marc_db.
  sort pt_mvke_db.
  delete adjacent duplicates from pt_mvke_db.

ENDENHANCEMENT.
