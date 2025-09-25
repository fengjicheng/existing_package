FUNCTION zqtc_masteridoc_create_bommat.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MESSAGE_TYPE) LIKE  TBDME-MESTYP
*"     VALUE(CREATION_DATE_HIGH) LIKE  SY-DATUM DEFAULT SY-DATUM
*"     VALUE(CREATION_TIME_HIGH) LIKE  SY-UZEIT DEFAULT SY-UZEIT
*"  EXPORTING
*"     REFERENCE(EV_SUM_OF_CRE_IDOCS) TYPE  SY-TABIX
*"----------------------------------------------------------------------

  TYPES :     BEGIN OF lty_mast,
                matnr TYPE matnr,         " Material Number
                werks TYPE werks_d,       " Plant
                stlan TYPE stlan,         " BOM Usage
                stlnr TYPE stnum,         " Bill of material
                stlal TYPE stalt,         " Alternative BOM
              END OF lty_mast,

              BEGIN OF lty_stlnr,
                stlnr TYPE stnum,         " Bill of material
              END OF lty_stlnr,

              BEGIN OF lty_bdcp2,
                mandt   TYPE  mandt,      " Client
                cpident TYPE  cpident,    " Change pointer ID
                tabname TYPE  tabname,    " Table Name
                tabkey  TYPE  cdtabkeylo, " Table Key for CDPOS in Character 254
                fldname TYPE  fieldname,  " Field Name
                cretime TYPE  cpcretime,  " Creation time of a change pointer
                acttime TYPE  cpacttime,  " Activation time of a change pointer
                usrname TYPE  cdusername, " User name of the person responsible in change document
                cdobjcl TYPE  cdobjectcl, " Object class
                cdobjid TYPE  cdobjectv,  " Object value
                cdchgno TYPE  cdchangenr, " Document change number
                cdchgid TYPE  cdchngind,  " Change Type (U, I, S, D)
              END OF lty_bdcp2,

              BEGIN OF lty_matnr,
                matnr TYPE matnr,         " Material Number
              END OF lty_matnr.

  DATA:
    li_chngpntr     TYPE STANDARD TABLE OF lty_bdcp2 INITIAL SIZE 0, " Change pointer
    li_matnr        TYPE STANDARD TABLE OF lty_matnr INITIAL SIZE 0,
    li_stlnr        TYPE STANDARD TABLE OF lty_stlnr INITIAL SIZE 0,
    lst_stlnr       TYPE lty_stlnr,
    lst_matnr       TYPE lty_matnr,
    lst_mast        TYPE lty_mast,
    li_mast         TYPE STANDARD TABLE OF lty_mast INITIAL SIZE 0,
    li_mast1        TYPE STANDARD TABLE OF lty_mast INITIAL SIZE 0,
    lst_chngpntr    TYPE lty_bdcp2,                                  " Change pointer
    chng_ptrs       LIKE bdcp       OCCURS 0 WITH HEADER LINE,       " Change pointer
    wa_chng_ptrs    LIKE bdcp,                                       " Change pointer
    cpid_done       LIKE bdicpident OCCURS 0 WITH HEADER LINE,       " Change pointer IDs
    cpid_send       LIKE bdicpident OCCURS 0 WITH HEADER LINE,       " Change pointer IDs
    chng_docs       LIKE cdred      OCCURS 0 WITH HEADER LINE,       " Change documents, display structure
    bom_stpo        LIKE stpo       OCCURS 0 WITH HEADER LINE,       " BOM item
    cptr_wa         LIKE bdcp,                                       " Change pointer
    current_cdchgno LIKE bdcp-cdchgno,                               " Document change number
    mescod          LIKE edidc-mescod,                               " Logical Message Variant
    bom_id          LIKE csbom,                                      " Structure for Triggering Data Distribution
    BEGIN OF pos_id,
      mandt LIKE stpo-mandt,                                         " Client
      stlty LIKE stpo-stlty,                                         " BOM category
      stlnr LIKE stpo-stlnr,                                         " Bill of material
      stlkn LIKE stpo-stlkn,                                         " BOM item node number
      stpoz LIKE stpo-stpoz,                                         " Internal counter
    END OF pos_id,
    lv_matnr             TYPE char18,                                " Matnr of type CHAR18
    dont_send_tab        LIKE pos_id OCCURS 0 WITH HEADER LINE,
    del_stpo             LIKE pos_id OCCURS 0 WITH HEADER LINE,
    created_comm_idocs   LIKE sy-tabix,                              " ABAP System Field: Row Index of Internal Tables
    sum_of_created_idocs LIKE sy-tabix,                              " ABAP System Field: Row Index of Internal Tables
    result               TYPE p,                                     " Result of type Packed Number
    smd_tool             TYPE char0001.                              " Tool of type CHAR0001

* Constant Declaration:
  CONSTANTS : lc_true TYPE char1 VALUE 'X'. " True of type CHAR1

* set smd_tool (used within MASTER_IDOC_CREATE_BOMMAT)
  smd_tool = lc_true.

* check if GUIDs have to be put into the IDoc              "note 567351

  PERFORM check_guid_ident_outbound. "note 567351

* get change pointers
  CALL FUNCTION 'CHANGE_POINTERS_READ'
    EXPORTING
      change_document_object_class = 'STUE_V' "  class
      message_type                 = message_type
      read_not_processed_pointers  = 'X'
    TABLES
      change_pointers              = chng_ptrs
    EXCEPTIONS
      error_in_date_interval       = 0
      error_in_time_interval       = 0
      OTHERS                       = 0.

********************************
  SELECT  mandt      " Client
          cpident    " Change pointer ID
          tabname    " Table Name
          tabkey     " Table Key for CDPOS in Character 254
          fldname    " Field Name
          cretime    " Creation time of a change pointer
          acttime    " Activation time of a change pointer
          usrname    " User name of the person responsible in change document
          cdobjcl    " Object class
          cdobjid    " Object value
          cdchgno    " Document change number
          cdchgid    " Change Type (U, I, S, D)
          FROM bdcp2 " Aggregated Change Pointers (BDCP, BDCPS)
          INTO TABLE li_chngpntr
          WHERE mestype EQ message_type
          AND   cdobjcl EQ 'MATERIAL'
          AND   process EQ abap_false.
  IF sy-subrc EQ 0.
    SORT li_chngpntr BY cretime cdobjid cdchgno tabname.
    LOOP AT li_chngpntr INTO lst_chngpntr.
      lst_matnr = lst_chngpntr-cdobjid+0(18).
      APPEND lst_matnr TO li_matnr.
    ENDLOOP. " LOOP AT li_chngpntr INTO lst_chngpntr
    IF li_matnr[] IS NOT INITIAL.
      SELECT matnr " Material Number
             werks " Plant
             stlan " BOM Usage
             stlnr " Bill of material
             stlal " Alternative BOM
        FROM mast  " Material to BOM Link
        INTO TABLE li_mast
        FOR ALL ENTRIES IN li_matnr
        WHERE matnr = li_matnr-matnr.
      IF sy-subrc EQ 0.
        SORT li_mast BY matnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_matnr[] IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

********************************
* process change pointers of material boms only
  DELETE chng_ptrs WHERE cdobjid+3(1) <> c_bomtyp_mat.

  IF chng_ptrs[] IS NOT INITIAL.
    LOOP AT chng_ptrs.
      lst_stlnr = chng_ptrs-cdobjid+4(8).
      APPEND lst_stlnr TO li_stlnr.
      CLEAR lst_stlnr.
    ENDLOOP. " LOOP AT chng_ptrs
    IF li_stlnr[] IS NOT INITIAL.
      SELECT matnr " Material Number
             werks " Plant
             stlan " BOM Usage
             stlnr " Bill of material
             stlal " Alternative BOM
        FROM mast  " Material to BOM Link
        INTO TABLE li_mast1
        FOR ALL ENTRIES IN li_stlnr
        WHERE stlnr = li_stlnr-stlnr.
      IF sy-subrc EQ 0.
        SORT li_mast1 BY matnr.
        APPEND LINES OF li_mast1 TO li_mast.
        SORT li_mast BY matnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_stlnr[] IS NOT INITIAL
  ENDIF. " IF chng_ptrs[] IS NOT INITIAL
  APPEND LINES OF li_chngpntr TO chng_ptrs.

* line up bom changes
  SORT chng_ptrs BY cretime cdobjid cdchgno tabname.

  LOOP AT chng_ptrs.
    IF chng_ptrs-cdchgno <> current_cdchgno.
*     bom is processed -> create Idoc
      CLEAR created_comm_idocs.
*      READ TABLE stpoi INDEX 1.
      IF sy-subrc = 0 OR stkob-vbkz <> c_vbkz_sync
                      AND NOT current_cdchgno IS INITIAL. "note0500567

        APPEND LINES OF cpid_done TO cpid_send.
      ENDIF. " IF sy-subrc = 0 OR stkob-vbkz <> c_vbkz_sync
*     commit (after 50 created IDocs)
      sum_of_created_idocs = sum_of_created_idocs + created_comm_idocs.
      result = sum_of_created_idocs MOD 50.
      IF result = 0 AND sum_of_created_idocs GT 0. "note500567
*       mark change pointers as processed
        CALL FUNCTION 'CHANGE_POINTERS_STATUS_WRITE'
          EXPORTING
            message_type           = message_type "note698168
          TABLES
            change_pointers_idents = cpid_send
          EXCEPTIONS
            OTHERS                 = 0.
        REFRESH cpid_send.
        COMMIT WORK.
        CALL FUNCTION 'DEQUEUE_ALL'.
      ENDIF. " IF result = 0 AND sum_of_created_idocs GT 0
*     reset variables and set current bom
      CLEAR:   mescod, ale_aennr, bom_id-csvkz,
               mastb, stzub, stkob, stpoi, cpid_done.
      REFRESH: mastb, stzub, stkob, stpoi, cpid_done.
      smd_tool = c_true.
      current_cdchgno = chng_ptrs-cdchgno.
      bom_id-stlty = c_bomtyp_mat. "note500567
      bom_id-stlnr = chng_ptrs-cdobjid+4(8).
      bom_id-stlal = chng_ptrs-cdobjid+22(2).
      bom_id-datuv = chng_ptrs-cdobjid+36(8).
      CLEAR stzu.
      SELECT SINGLE * FROM stzu WHERE stlty = bom_id-stlty
                                AND   stlnr = bom_id-stlnr.
*     process simple boms only (i.e. no Alt/Var-Boms  , should be
*              handled already in CSDS_CHECK_DISTRIBUTION)
      IF sy-subrc = 0.                                     "
        IF stzu-altst = c_true OR stzu-varst = c_true.
*          -> set CPs processed
          LOOP AT chng_ptrs WHERE cdobjid+4(8) = bom_id-stlnr.
            cpid_done = chng_ptrs-cpident.
            COLLECT cpid_done.
            DELETE chng_ptrs.
          ENDLOOP. " LOOP AT chng_ptrs WHERE cdobjid+4(8) = bom_id-stlnr
          CONTINUE.
        ENDIF. " IF stzu-altst = c_true OR stzu-varst = c_true
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF chng_ptrs-cdchgno <> current_cdchgno

*   get data
    CASE chng_ptrs-tabname.
      WHEN 'CSBOM'.
        PERFORM read_bom_header USING bom_id
                                      chng_ptrs-cdchgno
                                      chng_ptrs-cdobjid.
*       get ale change number from object-id
        ale_aennr = chng_ptrs-cdobjid+24(12).
        cpid_done = chng_ptrs-cpident.
        APPEND cpid_done.
        IF chng_ptrs-cdobjid+21(1) EQ 'X' OR
           chng_ptrs-cdobjid+21(1) EQ 'E'.
*         bom was deleted
          mescod = c_mescod_delete.
          IF stzub-histk IS INITIAL.
*           bom was physically deleted
*           -> get MAST changedocument for external identification
            chng_ptrs-cdobjid = chng_ptrs-cdobjid(12).
            CALL FUNCTION 'CHANGEDOCUMENT_READ'
              EXPORTING
                objectclass                = 'STUE' "  class
                objectid                   = chng_ptrs-cdobjid
                tablename                  = 'MAST'
              TABLES
                editpos                    = chng_docs
              EXCEPTIONS
                no_position_found          = 0
                wrong_access_to_archive    = 0
                time_zone_conversion_error = 0
                OTHERS                     = 0.
            READ TABLE chng_docs WITH KEY chngind = 'D'.
            IF sy-subrc = 0.
              mastb(36) = chng_docs-tabkey.
              APPEND mastb.
              MOVE-CORRESPONDING bom_id TO stzub.
              APPEND stzub.
            ENDIF. " IF sy-subrc = 0
*           don't process any other changes of (phys.) deleted bom
            wa_chng_ptrs = chng_ptrs.
            LOOP AT chng_ptrs WHERE cdobjid+4(8) = bom_id-stlnr.
              cpid_done = chng_ptrs-cpident.
              COLLECT cpid_done.
              DELETE chng_ptrs.
            ENDLOOP. " LOOP AT chng_ptrs WHERE cdobjid+4(8) = bom_id-stlnr
            chng_ptrs = wa_chng_ptrs.
            CLEAR stpoi. REFRESH stpoi. "delete already processed chng.
          ENDIF. " IF stzub-histk IS INITIAL
        ENDIF. " IF chng_ptrs-cdobjid+21(1) EQ 'X' OR
        IF chng_ptrs-cdobjid+20(1) = c_dist_initial.
*         initial distribution requested
          CLEAR smd_tool.
          mescod = c_mescod_change.
        ENDIF. " IF chng_ptrs-cdobjid+20(1) = c_dist_initial

      WHEN 'STKO'. "note 635034

        cpid_done = chng_ptrs-cpident. "note 635034
        APPEND cpid_done. "note 635034

      WHEN 'MARA'. "note 635034

        cpid_done = chng_ptrs-cpident. "note 635034
        APPEND cpid_done. "note 635034

      WHEN 'DMAKT'.

        cpid_done = chng_ptrs-cpident. "note 635034
        APPEND cpid_done. "note 635034

      WHEN 'STPO'.

*       check dont_send_tab (non-historic only)
        IF ale_aennr IS INITIAL.
          READ TABLE dont_send_tab WITH KEY chng_ptrs-tabkey.
          IF sy-subrc = 0.
            cpid_done = chng_ptrs-cpident.
            APPEND cpid_done.
            CONTINUE. "item already processed by other CP
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF ale_aennr IS INITIAL


        IF stpoi IS INITIAL.
*         get change documents
          CALL FUNCTION 'CHANGEDOCUMENT_READ'
            EXPORTING
              changenumber      = chng_ptrs-cdchgno
              objectclass       = 'STUE_V' "  class
              objectid          = chng_ptrs-cdobjid
              tablename         = 'STPO'
            TABLES
              editpos           = chng_docs
            EXCEPTIONS
              no_position_found = 1
              OTHERS            = 2.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF. " IF sy-subrc <> 0

*         get relevant STPO entries
          CLEAR bom_stpo. REFRESH bom_stpo.
          LOOP AT chng_docs WHERE fname = 'SANKA'.
            pos_id = chng_docs-tabkey.
            SELECT SINGLE * FROM stpo INTO bom_stpo
                   WHERE stlty = pos_id-stlty
                     AND stlnr = pos_id-stlnr
                     AND stlkn = pos_id-stlkn
                     AND stpoz = pos_id-stpoz.
            IF sy-subrc NE 0.
*             item physically deleted -> process CPs accordingly
              IF chng_docs-f_new = c_bom_update.
                chng_docs-f_new = c_bom_delete. "->send deletion now
              ELSEIF chng_docs-f_new = c_bom_insert.
                chng_docs-f_new = 'C'. "->send nothing
              ELSE. " ELSE -> IF chng_docs-f_new = c_bom_update
                CONTINUE.
              ENDIF. " IF chng_docs-f_new = c_bom_update
              MODIFY chng_docs.
            ELSE. " ELSE -> IF sy-subrc NE 0
              APPEND bom_stpo.
            ENDIF. " IF sy-subrc NE 0
          ENDLOOP. " LOOP AT chng_docs WHERE fname = 'SANKA'

*         identify and mark deleted positions of historic changes
          IF NOT ale_aennr IS INITIAL.
            LOOP AT chng_docs WHERE fname EQ 'SANKA'
                                AND f_new NE c_bom_insert.
              pos_id = chng_docs-tabkey.
              SELECT SINGLE * FROM stas " BOMs - Item Selection
                     WHERE stlty = pos_id-stlty
                       AND stlnr = pos_id-stlnr
                       AND stlkn = pos_id-stlkn
                       AND aennr = ale_aennr
                       AND lkenz = c_marked.
              IF sy-subrc EQ 0. "delete found -> mark it
                chng_docs-f_new = c_bom_delete.
                MODIFY chng_docs.
              ENDIF. " IF sy-subrc EQ 0
            ENDLOOP. " LOOP AT chng_docs WHERE fname EQ 'SANKA'
          ENDIF. " IF NOT ale_aennr IS INITIAL
        ENDIF. " IF stpoi IS INITIAL

*       check if bom position was already processed
        pos_id = chng_ptrs-tabkey.
        READ TABLE stpoi WITH KEY pos_id.
        IF sy-subrc = 0.
          cpid_done = chng_ptrs-cpident.
          APPEND cpid_done.
          CONTINUE. "position already processed
        ENDIF. " IF sy-subrc = 0
        IF NOT ale_aennr IS INITIAL.
          READ TABLE chng_docs
                WITH KEY tabkey = pos_id
                         fname  = 'SANKA'.
          IF chng_docs-f_new  = 'D'.
            READ TABLE del_stpo WITH KEY pos_id.
            IF sy-subrc = 0.
              cpid_done = chng_ptrs-cpident.
              APPEND cpid_done.
              CONTINUE. "item processed by other CP
            ENDIF. " IF sy-subrc = 0
          ELSE. " ELSE -> IF chng_docs-f_new = 'D'
            READ TABLE dont_send_tab WITH KEY pos_id.
            IF sy-subrc = 0.
              cpid_done = chng_ptrs-cpident.
              APPEND cpid_done.
              CONTINUE. "item processed by other CP
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF chng_docs-f_new = 'D'
        ENDIF. " IF NOT ale_aennr IS INITIAL
*       get type of change
        IF ale_aennr IS INITIAL.
*         non-historic changes
          READ TABLE chng_docs WITH KEY fname = 'SANKA'
                                       tabkey = pos_id.
          CASE chng_docs-f_new.
            WHEN 'I'.
*             get new bom position data
              READ TABLE bom_stpo WITH KEY pos_id INTO stpoi.
              CLEAR stpoi-id_guid. "note 567351
              IF NOT g_flg_guid_into_idoc IS INITIAL. "note 567351
                READ TABLE chng_docs           "note 567351
                     WITH KEY fname  = 'GUIDX' "note 567351
                              tabkey = pos_id. "note 567351
                IF sy-subrc EQ 0. "note 567351
                  stpoi-id_guid = chng_docs-f_old. "note 567351
                ENDIF. " IF sy-subrc EQ 0
              ENDIF. " IF NOT g_flg_guid_into_idoc IS INITIAL
              APPEND pos_id TO dont_send_tab.
            WHEN 'U'.
*             get updated position data
              READ TABLE bom_stpo WITH KEY pos_id INTO stpoi.
              stpoi-id_guid = stpoi-guidx. "note 567351
*             set external position identification
              PERFORM set_ext_bomid_from_chngdoc
                      TABLES chng_docs bom_stpo chng_ptrs
                      USING  space.
*             process multiple non-historic CPs
              IF flg_chid IS INITIAL. "external ID not changed
*               are there more non-historic CPs for that item ?
                LOOP AT chng_ptrs WHERE tabkey(28)   EQ  pos_id
                                  AND cdchgno        NE current_cdchgno
                                  AND cdobjid+24(12) IS INITIAL.
                ENDLOOP. " LOOP AT chng_ptrs WHERE tabkey(28) EQ pos_id
                IF sy-subrc EQ 0. "-> more CPs found, dont sent this one
                  LOOP AT chng_ptrs WHERE tabkey(28)   EQ  pos_id
                                      AND cdchgno EQ current_cdchgno.
                    cpid_done = chng_ptrs-cpident.
                    APPEND cpid_done. "set CP to processed
                    DELETE chng_ptrs.
                  ENDLOOP. " LOOP AT chng_ptrs WHERE tabkey(28) EQ pos_id
                  CONTINUE. "-> next item
                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF flg_chid IS INITIAL
                APPEND pos_id TO dont_send_tab.
              ENDIF. " IF flg_chid IS INITIAL
*
            WHEN 'D'.
              CLEAR stpoi.
              stpoi(28) = pos_id.
*             set external position identification
              PERFORM set_ext_bomid_from_chngdoc
                      TABLES chng_docs bom_stpo chng_ptrs
                      USING  space.
*             set deletion flag
              stpoi-lkenz = c_marked.
              COLLECT pos_id INTO dont_send_tab.
              COLLECT pos_id INTO del_stpo.

            WHEN 'C'. "continue-flag
              stpoi(28) = pos_id. "de-init stpoi
              COLLECT pos_id INTO dont_send_tab.
              COLLECT pos_id INTO del_stpo.
              cpid_done = chng_ptrs-cpident.
              APPEND cpid_done. "set CP to processed
              CONTINUE.

          ENDCASE.
        ELSE. " ELSE -> IF ale_aennr IS INITIAL
*         historic changes
          READ TABLE chng_docs WITH KEY fname = 'SANKA' tabkey = pos_id.
          CASE chng_docs-f_new.
            WHEN c_bom_delete.
*             delete or historic update
              PERFORM set_ext_bomid_from_chngdoc
                    TABLES chng_docs bom_stpo chng_ptrs
                    USING  c_true.
              READ TABLE bom_stpo WITH KEY pos_id.
              IF sy-subrc <> 0.
                cpid_done = chng_ptrs-cpident.
                APPEND cpid_done. "set CP to processed
                CONTINUE.
              ENDIF. " IF sy-subrc <> 0
              MOVE-CORRESPONDING bom_stpo TO stpoi.
              stpoi-lkenz = c_marked.
*             check if update (rather than delete)
              LOOP AT chng_docs WHERE fname = 'SANKA'
                                  AND f_new = c_bom_insert.
                READ TABLE bom_stpo WITH KEY chng_docs-tabkey(28).
                IF stpoi-stlkn EQ bom_stpo-vgknt.
*                 matching insert found -> historic update
                  MOVE-CORRESPONDING bom_stpo TO stpoi.
                  CLEAR stpoi-lkenz.
                  DELETE chng_docs.
                  EXIT.
                ENDIF. " IF stpoi-stlkn EQ bom_stpo-vgknt
              ENDLOOP. " LOOP AT chng_docs WHERE fname = 'SANKA'
              COLLECT pos_id INTO dont_send_tab.
              IF stpoi-lkenz = c_marked.
                APPEND pos_id TO del_stpo.
              ENDIF. " IF stpoi-lkenz = c_marked
            WHEN c_bom_insert.
*             insert or historic update
              READ TABLE bom_stpo WITH KEY pos_id INTO stpoi.
              CLEAR stpoi-id_guid. "note 567351
*             check if update (rather than insert)
              LOOP AT chng_docs WHERE fname = 'SANKA'
                                  AND f_new = c_bom_delete.
                READ TABLE bom_stpo WITH KEY chng_docs-tabkey(28).
                IF stpoi-vgknt EQ bom_stpo-stlkn.
*                 matching delete found -> update
                  PERFORM set_ext_bomid_from_chngdoc
                          TABLES chng_docs bom_stpo chng_ptrs"
                          USING  c_true.
                  READ TABLE chng_ptrs WITH KEY
                                       tabkey = chng_docs-tabkey
                                       cdchgno = current_cdchgno
                                       INTO cptr_wa.
                  IF sy-tabix GT 0. "note0519633
                    DELETE chng_ptrs INDEX sy-tabix. "note0519633
                  ENDIF. " IF sy-tabix GT 0
                  cpid_done = cptr_wa-cpident. "set D cptr to processed
                  APPEND cpid_done.
                  DELETE chng_docs.
                  EXIT.
                ENDIF. " IF stpoi-vgknt EQ bom_stpo-stlkn
              ENDLOOP. " LOOP AT chng_docs WHERE fname = 'SANKA'
              COLLECT pos_id INTO dont_send_tab.
            WHEN c_bom_update.
*             update with same change number -> handled like non-hist
              READ TABLE bom_stpo WITH KEY pos_id INTO stpoi.
              stpoi-id_guid = stpoi-guidx. "note 567351
              PERFORM set_ext_bomid_from_chngdoc
                      TABLES chng_docs bom_stpo chng_ptrs
                      USING  space.
              COLLECT pos_id INTO dont_send_tab.
            WHEN 'C'. "continue-flag
              stpoi(28) = pos_id. "de-init stpoi
              COLLECT pos_id INTO dont_send_tab.
              COLLECT pos_id INTO del_stpo.
              cpid_done = chng_ptrs-cpident.
              APPEND cpid_done. "set CP to processed
              CONTINUE.
          ENDCASE. "Del, Ins or Upd (historic)
        ENDIF. " IF ale_aennr IS INITIAL
        APPEND stpoi.
        cpid_done = chng_ptrs-cpident.
        APPEND cpid_done.
    ENDCASE. "tabname
  ENDLOOP. " LOOP AT chng_ptrs

  LOOP AT li_mast INTO lst_mast.

* send bom processed last
    CLEAR created_comm_idocs.
    READ TABLE stpoi INDEX 1.
    IF sy-subrc = 0 OR stkob-vbkz <> c_vbkz_sync.
      CALL FUNCTION 'MASTER_IDOC_CREATE_BOMMAT'
        EXPORTING
          matnr               = lst_mast-matnr
          werk                = lst_mast-werks
          stlan               = lst_mast-stlan
          stlal               = lst_mast-stlal
          message_type        = message_type
        IMPORTING
          created_comm_idocs  = created_comm_idocs
        EXCEPTIONS
          general_bom_failure = 1
          no_bom_found        = 2
          general_ale_failure = 3
          OTHERS              = 4.
    ENDIF. " IF sy-subrc = 0 OR stkob-vbkz <> c_vbkz_sync
    APPEND LINES OF cpid_done TO cpid_send.
    sum_of_created_idocs = sum_of_created_idocs + created_comm_idocs.
  ENDLOOP. " LOOP AT li_mast INTO lst_mast

* CP is sent for both mess-types, otherwise CP can be processed for
* BOMMAT and BOMMAT2 -> 2 IDOCs for 1 CP !
  CALL FUNCTION 'CHANGE_POINTERS_STATUS_WRITE'
    EXPORTING
      message_type           = message_type
    TABLES
      change_pointers_idents = cpid_send
    EXCEPTIONS
      OTHERS                 = 0.

* final commit
  COMMIT WORK.
  CALL FUNCTION 'DEQUEUE_ALL'.

  ev_sum_of_cre_idocs = sum_of_created_idocs.

ENDFUNCTION.
