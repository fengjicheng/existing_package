*----------------------------------------------------------------------*
***INCLUDE LZQTC_SAP_JANIS_BOM_I0206F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CHECK_GUID_IDENT_OUTBOUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_guid_ident_outbound .
* ------------------------------------------------
* Check if GUIDs have to be put into outbound IDoc
* ------------------------------------------------

  clear g_flg_guid_into_idoc.

  if g_flg_guid_into_idoc_checked is initial.
    data: l_exit_name like rsexscrn-exit_name value 'BOM_EXIT'.

    call function 'SXC_EXIT_CHECK_ACTIVE'
      exporting
        exit_name         = l_exit_name
      exceptions
        not_active        = 1
        others            = 0.

    if sy-subrc eq 0.                                      "note 630047

       call method cl_exithandler=>get_instance
               exporting
                 exit_name = l_exit_name
                 null_instance_accepted = c_true           "note 630047
               changing
                 instance = g_outb_bom_exit.

    endif.                                                 "note 630047

    g_flg_guid_into_idoc_checked = 'X'.
  endif.

  if not g_outb_bom_exit is initial.
    call method g_outb_bom_exit->ale_identify_by_guid_outbound
      importing
        e_set_guid = g_flg_guid_into_idoc.
  endif.


* begin of insertion note 617329

  if g_flg_guid_into_idoc is initial.
     g_flg_guid_into_idoc = g_fl_mdm_outbound_active.
  endif.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_BOM_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BOM_ID  text
*      -->P_CHNG_PTRS_CDCHGNO  text
*      -->P_CHNG_PTRS_CDOBJID  text
*----------------------------------------------------------------------*
form read_bom_header using bom_id         like  csbom
                           cdchgno        like  bdcp-cdchgno
                           cdobjid        like  bdcp-cdobjid.

  data: i_hlp      like  sy-tabix,
        chng_docs  like  cdred      occurs 0 with header line.

* check if header already read
  check bom_id-csvkz is initial.

* reset the workareas
  clear mastb. refresh mastb.
  clear kdstb. refresh kdstb.
  clear dostb. refresh dostb.                               "note694344
  clear stzub. refresh stzub.
  clear stkob. refresh stkob.

* read BOM-table
  case bom_id-stlty.
     when c_bomtyp_mat.
        select * from mast into table mastb
               where stlnr = bom_id-stlnr
                 and stlal = bom_id-stlal
                 and cslty = ' '.
        if sy-subrc ne 0.
           exit.
        ELSE.
          SORT mastb BY matnr werks.      "Note 2167130
        endif.
*       Keep only one entry (necessary in case of plant allocations)
        read table mastb index 1.
     when c_bomtyp_ord.
        select * from kdst into table kdstb
               where stlnr = bom_id-stlnr
               and   stlal = bom_id-stlal.
        if sy-subrc ne 0.
           exit.
        ELSE.
          SORT kdstb BY vbeln vbpos matnr werks.   "Note 2167130
        endif.
*       Keep only one entry
        read table kdstb index 1.
        refresh kdstb.
        append kdstb.
*   begin of note 694344
     when c_bomtyp_doc.
        select * from dost into table dostb
               where stlnr = bom_id-stlnr
               and   stlal = bom_id-stlal.
        if sy-subrc ne 0.
           exit.
        endif.
*       Keep only one entry
        read table dostb index 1.
        refresh dostb.
        append dostb.
*   end of note 694344
  endcase.

* get bom header (STZU)
  select single * from stzu into stzub
         where stlty = bom_id-stlty
         and   stlnr = bom_id-stlnr.
  if sy-subrc ne 0.
    exit.
  endif.

* get bom header (STKO)
  select * from stko into table stkob
         where stlty = bom_id-stlty
         and   stlnr = bom_id-stlnr
         and   stlal = bom_id-stlal.
  if sy-subrc ne 0.
    exit.
  endif.
  describe table stkob lines i_hlp.
  if i_hlp gt 1.
*   find valid header (by date)
    sort stkob by datuv.
    loop at stkob.
      if stkob-datuv > bom_id-datuv.
        i_hlp = sy-tabix - 1.
        exit.
      endif.
      i_hlp = sy-tabix.
    endloop.
    read table stkob index i_hlp.
  else.
    read table stkob index 1.
  endif.

* Was STKO changed ?
  call function 'CHANGEDOCUMENT_READ'
       exporting
           changenumber         = cdchgno
           objectclass          = 'STUE_V'
           objectid             = cdobjid
           tablename            = 'STKO'
       tables
           editpos                    = chng_docs
       exceptions
           no_position_found          = 1
           wrong_access_to_archive    = 2
           time_zone_conversion_error = 3
           others                     = 4.

   if sy-subrc = 1.
      stkob-vbkz = c_vbkz_sync.
   endif.

* keep only the STKOB-entry chosen
  refresh stkob.
  append  stkob.

* mark header as read
  bom_id-csvkz = c_marked.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_EXT_BOMID_FROM_CHNGDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CHNG_DOCS  text
*      -->P_BOM_STPO  text
*      -->P_CHNG_PTRS  text
*      -->P_SPACE  text
*----------------------------------------------------------------------*
form set_ext_bomid_from_chngdoc tables cdoc structure cdred
                                      l_stpo structure stpo
                                   chng_ptrs structure bdcp
                                using hist like csdata-xfeld.

  data: l_posid like stpoid,
        wa_chng_ptr  like bdcp,
        cp_cdoc      like cdred  occurs 0 with header line,
        cdoc_sav     like cdred  occurs 0 with header line,
        curr_cdchgno like bdcp-cdchgno,
        no_set_count like sy-tabix.
  DATA: i_tab_len TYPE I. "NOTE_821757


  if hist is initial.
*   set external bom_id from 'new' position
    stpoi-id_itm_ctg = stpoi-postp.
    stpoi-id_item_no = stpoi-posnr.
    stpoi-id_comp    = stpoi-idnrk.
    stpoi-id_class   = stpoi-class.
    stpoi-id_cl_type = stpoi-klart.
    stpoi-id_doc     = stpoi-doknr.
    stpoi-id_doc_typ = stpoi-dokar.
    stpoi-id_doc_prt = stpoi-doktl.
    stpoi-id_doc_vrs = stpoi-dokvr.
    stpoi-id_sort    = stpoi-sortf.
    append lines of cdoc to cdoc_sav.
*   identify all changes to the external key
    curr_cdchgno = chng_ptrs-cdchgno.
    loop at chng_ptrs into wa_chng_ptr
                     where tabkey  =  chng_ptrs-tabkey
                       and cpident <> chng_ptrs-cpident.
*      read change documents of former changes
       if wa_chng_ptr-cdchgno <> curr_cdchgno.
          curr_cdchgno = wa_chng_ptr-cdchgno.
          clear cp_cdoc[].
          call function 'CHANGEDOCUMENT_READ'
              exporting
                    changenumber      = wa_chng_ptr-cdchgno
                    objectclass       = 'STUE_V'
                    objectid          = wa_chng_ptr-cdobjid
                    tablename         = 'STPO'
               tables
                    editpos           = cp_cdoc
               exceptions
                    no_position_found = 1
                    others            = 2.
          if sy-subrc = 0.
            read table cp_cdoc with key fname = 'SANKA'
                                        f_new = 'I'.
*           collect change documents except those of inserts
            if sy-subrc <> 0.
               delete cp_cdoc where fname = 'SANKA'.
               append lines of cp_cdoc to cdoc.
            endif.
          endif.
       endif.
    endloop.
*   sort in inverse historical order (to recreate the external
*   key only the first changes to each field is of importance )
    sort cdoc descending by udate utime.
    clear no_set_count.
    loop at cdoc where tabkey eq stpoi(28).
**    replace changed fields with 'old' values
      case cdoc-fname.
        when 'POSTP'.  stpoi-id_itm_ctg = cdoc-f_old.
        when 'POSNR'.  stpoi-id_item_no = cdoc-f_old.
        when 'IDNRK'.
          call function 'CONVERSION_EXIT_MATN1_INPUT'
            exporting
              input              = cdoc-f_old
            importing
              output             = stpoi-id_comp
            exceptions
              others             = 1.
          if sy-subrc <> 0.
          endif.
        when 'CLASS'.  stpoi-id_class   = cdoc-f_old.
        when 'KLART'.  stpoi-id_cl_type = cdoc-f_old.
        when 'DOKNR'.  stpoi-id_doc     = cdoc-f_old.
        when 'DOKAR'.  stpoi-id_doc_typ = cdoc-f_old.
        when 'DOKTL'.  stpoi-id_doc_prt = cdoc-f_old.
        when 'DOKVR'.  stpoi-id_doc_vrs = cdoc-f_old.
        when 'SORTF'.  stpoi-id_sort    = cdoc-f_old.
        when 'GUIDX'.  stpoi-id_guid    = cdoc-f_old.      "note 567351
        when others.
          no_set_count = no_set_count + 1.
      endcase.
    endloop.
*   restore change documents of current change
    cdoc = cdoc_sav.
    cdoc[] = cdoc_sav[].
    flg_chid = c_marked.
    DESCRIBE TABLE cdoc LINES i_tab_len. "NOTE_821757
    if no_set_count = sy-tfill.
*     external bom_id wasn't changend -> clear bom_id fields
      clear: stpoi-id_itm_ctg, stpoi-id_item_no,
             stpoi-id_comp, stpoi-id_class, stpoi-id_cl_type,
             stpoi-id_doc, stpoi-id_doc_typ, stpoi-id_doc_prt,
             stpoi-id_doc_vrs, stpoi-id_sort,
             flg_chid.
    endif.
  else.
    l_posid = cdoc-tabkey.
    read table l_stpo with key l_posid(28).
    stpoi-id_itm_ctg = l_stpo-postp.
    stpoi-id_item_no = l_stpo-posnr.
    stpoi-id_comp    = l_stpo-idnrk.
    stpoi-id_class   = l_stpo-class.
    stpoi-id_cl_type = l_stpo-klart.
    stpoi-id_doc     = l_stpo-doknr.
    stpoi-id_doc_typ = l_stpo-dokar.
    stpoi-id_doc_prt = l_stpo-doktl.
    stpoi-id_doc_vrs = l_stpo-dokvr.
    stpoi-id_sort    = l_stpo-sortf.
    stpoi-id_guid    = l_stpo-guidx.                       "note 567351
  endif.
ENDFORM.
