*----------------------------------------------------------------------*
*   INCLUDE LCSDSF02                                                   *
*----------------------------------------------------------------------*
*   Subprograms BOM-Distribution: Outbound Processing                  *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  MAT_BOM_READ_CSS4
*&---------------------------------------------------------------------*
*       read BOM via CSS4 functions (bom explosion)                    *
*----------------------------------------------------------------------*
form mat_bom_read_css4 using matnr like mast-matnr
                             werk  like mast-werks
                             stlan like mast-stlan
                             stlal like mast-stlal
                             datuv like stko-datuv
                             mescod like edidc-mescod.
  data:
* local data
  topmat     like cstmat,
  dstst      like csdata-xfeld,
  stb        like stpox occurs 0 with header line,
  stpub_save like stpub occurs 0,
  lt_vgknt   type vgknt_type occurs 0 with header line,    "note 567351
  lt_guid    type guid_type  occurs 0 with header line.    "note 567351

* initialize the internal bom tables
  perform initialize_bom_itabs.                             "note809610

* explode bom
  call function 'CS_BOM_EXPL_MAT_V2'
       exporting
            alekz                 = c_true                "note 582821
            capid                 = space
            datuv                 = datuv
            mtnrv                 = matnr
            stlal                 = stlal
            stlan                 = stlan
            werks                 = werk
       importing
            topmat                = topmat
            dstst                 = dstst
       tables
            stb                   = stb
       exceptions
            alt_not_found         = 1
            call_invalid          = 2
            material_not_found    = 3
            missing_authorization = 4
            no_bom_found          = 5
            no_plant_data         = 6
            no_suitable_bom_found = 7
            others                = 8.

  if sy-subrc ne 0.
    if mescod = c_mescod_delete.
       mastb-matnr = matnr.
       mastb-werks = werk.
       mastb-stlan = stlan.
       mastb-stlal = stlal.
       append mastb.
       if not mastb is initial.
          clear sy-subrc.
          exit.
       endif.
    endif.
    raise no_bom_found.
  endif.

* move data to internal tables

* -> bom header (single alternative)
  move-corresponding topmat to mastb. append mastb.
  move-corresponding topmat to stzub.

  select single ltxsp ztext stldt stltm                     "note 596491
          from stzu
          into corresponding fields of stzub
         where stlty = stzub-stlty
         and   stlnr = stzub-stlnr.      "read bom text
  append stzub.
  move-corresponding topmat to stkob. append stkob.
  call function 'GET_STKO'
       exporting
            all             = 'X'
            datuv           = datuv
            set             = 'X'
            valid           = 'X'
            del             = 'X'                           "note 636126
       tables
            wa              = stkob
       exceptions
            others          = 1 .
   read table stkob index 1.

* --- begin of insertion note 567351
* Collect Information on preceding nodes
  if not g_flg_guid_into_idoc is initial.
      if not stb[] is initial.                              "NOTE_815446
          select stlty stlnr stlkn stpoz vgknt vgpzl
           from stpo into table lt_vgknt
           for all entries in stb
           where stlty = stb-stlty and
                 stlnr = stb-stlnr and
                 stlkn = stb-stlkn and
                 stpoz = stb-stpoz.
 if lt_vgknt[] is not INITIAL.
    select stlkn stpoz guidx from stpo into table lt_guid
           for all entries in lt_vgknt
           where stlty = lt_vgknt-stlty and
                 stlnr = lt_vgknt-stlnr and
                 stlkn = lt_vgknt-vgknt and
                 stpoz = lt_vgknt-vgpzl.
      endif.
      endif.                                               "NOTE_815446
   endif.
* --- end of insertion note 567351

* -> bom positions
  loop at stb.
    clear stpoi.                                            "note630112
    move-corresponding stb to stpoi.
    stpoi-matkl = stb-itmmk.
* --- begin of insertion note 567351
*   retrieve GUID of preceding node
    if not g_flg_guid_into_idoc is initial.
      read table lt_vgknt with key stlkn = stb-stlkn
                                   stpoz = stb-stpoz.
      if sy-subrc eq 0 and lt_vgknt-vgknt ne 0 and
                           lt_vgknt-vgpzl ne 0.
        read table lt_guid with key stlkn = lt_vgknt-vgknt
                                    stpoz = lt_vgknt-vgpzl.
        if sy-subrc eq 0.
          stpoi-id_guid = lt_guid-guid.
        endif.
      endif.
    endif.
* --- end of insertion note 567351
    append stpoi.
    if not stpoi-upskz is initial.
*     get bom sub-positions (STPU)
      stpub-stlty = c_bomtyp_mat.
      stpub-stlnr = mastb-stlnr.
      stpub-stlkn = stpoi-stlkn.
      stpub-stpoz = stpoi-stpoz.
      call function 'GET_STPU'
           exporting
                all             = c_true
                set             = c_true
           tables
                wa              = stpub
           exceptions
                call_invalid    = 1
                end_of_table    = 2
                get_without_set = 3
                key_incomplete  = 4
                no_record_found = 5
                others          = 6.
      case sy-subrc.
        when 0.   "ok -> continue
        when 5.   "no record -> continue
        when others.
          exit.
      endcase.
      append lines of stpub to stpub_save.
    endif.
  endloop. "STB
  stpub[] = stpub_save[].

* get dependency data
  perform dependency_read using datuv.

endform.                    " MAT_BOM_READ_CSS4

*&---------------------------------------------------------------------*
*&      Form  DOC_BOM_READ_CSS7
*&---------------------------------------------------------------------*
*       read BOM via CSS7 functions (bom explosion)                    *
*----------------------------------------------------------------------*
form doc_bom_read_css7 using doc_number  like dost-doknr
                             doc_type    like dost-dokar
                             doc_part    like dost-doktl
                             doc_version like dost-dokvr
                             datuv       like stko-datuv.

  data:
* local data
  topdoc     like cstdoc,
  doccat     like cscdoc occurs 0 with header line,
  stb        like stpox  occurs 0 with header line,
  stpub_save like stpub  occurs 0,
  lt_vgknt   type vgknt_type occurs 0 with header line,    "note 567351
  lt_guid    type guid_type  occurs 0 with header line.    "note 567351

* initialize the internal bom tables
  perform initialize_bom_itabs.                             "note809610

* explode bom
  call function 'CS_BOM_EXPL_DOC_V1'
       exporting
            alekz                    = c_true             "note 582821
            datuv                    = datuv
            docnr                    = doc_number
            docar                    = doc_type
            doctl                    = doc_part
            docvr                    = doc_version
       importing
            topdoc                   = topdoc
       tables
            stb                      = stb
            doccat                   = doccat
       exceptions
            call_invalid             = 1
            document_not_found       = 2
            missing_authorization    = 3
            no_bom_found             = 4
            no_suitable_bom_found    = 5
            bom_not_active           = 6
            bom_flagged_for_deletion = 7
            bom_without_positions    = 8
            others                   = 9.

  if sy-subrc ne 0.
    raise no_bom_found.
  endif.

* move data to internal tables

* -> bom header (single alternative)
  move-corresponding topdoc to dostb. append dostb.
  move-corresponding topdoc to stzub.

  select single ltxsp ztext stldt stltm                     "note 596491
          from stzu
          into corresponding fields of stzub
         where stlty = stzub-stlty
         and   stlnr = stzub-stlnr.      "read bom text
  append stzub.
  move-corresponding topdoc to stkob. append stkob.
  call function 'GET_STKO'
       exporting
            all             = 'X'
            datuv           = datuv
            set             = 'X'
            valid           = 'X'
       tables
            wa              = stkob
       exceptions
            others          = 1 .
   read table stkob index 1.

* --- begin of insertion note 567351
* Collect Information on preceding nodes
  if not g_flg_guid_into_idoc is initial.
    if not stb[] is initial.                                "Note 835054
      select stlty stlnr stlkn stpoz vgknt vgpzl
             from stpo into table lt_vgknt
             for all entries in stb
             where stlty = stb-stlty and
                   stlnr = stb-stlnr and
                   stlkn = stb-stlkn and
                   stpoz = stb-stpoz.
IF lt_vgknt[] IS NOT INITIAL.
      select stlkn stpoz guidx from stpo into table lt_guid
             for all entries in lt_vgknt
             where stlty = lt_vgknt-stlty and
                   stlnr = lt_vgknt-stlnr and
                   stlkn = lt_vgknt-vgknt and
                   stpoz = lt_vgknt-vgpzl.
ENDIF.
    endif.                                                  "Note 835054
   endif.
* --- end of insertion note 567351

* -> bom positions
  loop at stb.
    clear stpoi.                                            "note630112
    move-corresponding stb to stpoi.
* --- begin of insertion note 567351
*   retrieve GUID of preceding node
    if not g_flg_guid_into_idoc is initial.
      read table lt_vgknt with key stlkn = stb-stlkn
                                   stpoz = stb-stpoz.
      if sy-subrc eq 0 and lt_vgknt-vgknt ne 0 and
                           lt_vgknt-vgpzl ne 0.
        read table lt_guid with key stlkn = lt_vgknt-vgknt
                                    stpoz = lt_vgknt-vgpzl.
        if sy-subrc eq 0.
          stpoi-id_guid = lt_guid-guid.
        endif.
      endif.
    endif.
* --- end of insertion note 567351
    append stpoi.
    if not stpoi-upskz is initial.
*     get bom sub-positions (STPU)
      stpub-stlty = c_bomtyp_doc.
      stpub-stlnr = mastb-stlnr.
      stpub-stlkn = stpoi-stlkn.
      stpub-stpoz = stpoi-stpoz.
      call function 'GET_STPU'
           exporting
                all             = c_true
                set             = c_true
           tables
                wa              = stpub
           exceptions
                call_invalid    = 1
                end_of_table    = 2
                get_without_set = 3
                key_incomplete  = 4
                no_record_found = 5
                others          = 6.
      case sy-subrc.
        when 0.   "ok -> continue
        when 5.   "no record -> continue
        when others.
          exit.
      endcase.
      append lines of stpub to stpub_save.
    endif.
  endloop. "STB
  stpub[] = stpub_save[].

* get dependency data
  perform dependency_read using datuv.

endform.                    " DOC_BOM_READ_CSS7

*&---------------------------------------------------------------------*
*&      Form  DEPENDENCY_READ
*&---------------------------------------------------------------------*
*       read dependencies for bom positions                            *
*----------------------------------------------------------------------*
form dependency_read using datuv like sy-datum.

* local data
data:
  cs_dep_id   like csident,
  xdep_data   like rcukb1   occurs 0 with header line,
  xdep_descr  like rcukbt1  occurs 0 with header line,
  xdep_source like rcukn1   occurs 0 with header line,
  xdep_order  like rcuob1   occurs 0 with header line,
  xdep_doc    like rcukdoc1 occurs 0 with header line.


* initialize global data
  clear api_dep_dat. refresh api_dep_dat.
  clear api_dep_des. refresh api_dep_des.
  clear api_dep_ord. refresh api_dep_ord.
  clear api_dep_src. refresh api_dep_src.
  clear api_dep_doc. refresh api_dep_doc.

* get dependencies
  loop at stpoi where not knobj is initial.
    call function 'CUKD_API_ALLOCATIONS_READ'
        exporting
             allocation_number   = stpoi-knobj
             table               = 'STPO'
             date                = datuv
        tables
             allocations       = xdep_order
             basic_data        = xdep_data
             names             = xdep_descr
             docus             = xdep_doc
             sources           = xdep_source
        exceptions
             error             = 1
             others            = 2.

    if sy-subrc = 1. continue. endif.  "next bom position

*   set bom position identification
    cs_dep_id-bom_no     = stpoi-stlnr.
    cs_dep_id-item_node  = stpoi-stlkn.
    cs_dep_id-item_count = stpoi-stpoz.

*   sort dependencies by order
    sort xdep_order by knsrt.

*   fill API tables
*   get basic data of local and global dependencies
    loop at xdep_order.  "(local and global dependencies)
*     get basic data of local and global dependencies
      read table xdep_data with key knnam = xdep_order-knnam.
      move-corresponding cs_dep_id to api_dep_dat.
      api_dep_dat-dep_intern = xdep_data-knnam.
      api_dep_dat-dep_extern = xdep_data-xknnam.      "xknnam is empty !
      api_dep_dat-dep_type   = xdep_data-knart.
      api_dep_dat-status     = xdep_data-knsta.
      api_dep_dat-group      = xdep_data-kngrp.
      api_dep_dat-whr_to_use = xdep_data-knbeo.
      api_dep_dat-fldelete   = xdep_data-lkenz.
      append api_dep_dat.
*     get dependencies order
      move-corresponding api_dep_dat to api_dep_ord.
      api_dep_ord-dep_lineno = xdep_order-knsrt.
      append api_dep_ord.
    endloop.

*   get descripition, source and docu of local dependencies only
    loop at xdep_order where knnam co numbers.
*     get descripitions (local dependencies only)
      loop at xdep_descr where knnam = xdep_order-knnam.
        move-corresponding cs_dep_id to api_dep_des.
        api_dep_des-dep_intern = xdep_descr-knnam.
        api_dep_des-dep_extern = xdep_descr-xknnam.
        api_dep_des-language   = xdep_descr-langu.
        api_dep_des-descript   = xdep_descr-knktxt.
        api_dep_des-fldelete   = xdep_descr-lkenz.
        append api_dep_des.
      endloop.
*     get source (local dependencies only)
      loop at xdep_source where knnam = xdep_order-knnam.
        move-corresponding cs_dep_id to api_dep_src.
        api_dep_src-dep_intern = xdep_source-knnam.
        api_dep_src-dep_extern = xdep_source-xknnam.
        api_dep_src-line_no    = xdep_source-line_no.
        api_dep_src-line       = xdep_source-line.
        append api_dep_src.
      endloop.
*     get documentation (local dependencies only)
      loop at xdep_doc where knnam = xdep_order-knnam.
        move-corresponding cs_dep_id to api_dep_doc.
        api_dep_doc-dep_intern = xdep_doc-knnam.
        api_dep_doc-dep_extern = xdep_doc-xknnam.
        api_dep_doc-language   = xdep_doc-langu.
        api_dep_doc-line_no    = xdep_doc-line_no.
        api_dep_doc-txt_form   = xdep_doc-format.
        api_dep_doc-txt_line   = xdep_doc-line.
        append api_dep_doc.
      endloop.
    endloop. "xdep_order

  endloop. "bom positions

  if sy-subrc = 4. clear sy-subrc. endif.   "no dependencies defined

endform.                    " DEPENDENCY_READ

*&---------------------------------------------------------------------*
*&      Form  READ_LONG_TEXT
*&---------------------------------------------------------------------*
*       read bom long text                                             *
*----------------------------------------------------------------------*
form read_long_text using ltx_table type c.

  clear:   ltx_head, ltx_lines.
  refresh:           ltx_lines.

* set header data
  case ltx_table.
    when ltx_stzu.
      ltx_head-tdid(1)     = stzub-stlty.
      ltx_head-tdid+1(2)   = ltx_stzu.
      ltx_head-tdspras     = stzub-ltxsp.
      ltx_head-tdname(3)   = sy-mandt.
      ltx_head-tdname+3(1) = stzub-stlty.
      ltx_head-tdname+4(8) = stzub-stlnr.
    when ltx_stko.
      ltx_head-tdid(1)      = stkob-stlty.
      ltx_head-tdid+1(2)    = ltx_stko.
      ltx_head-tdspras      = stkob-ltxsp.
      ltx_head-tdname(3)    = sy-mandt.
      ltx_head-tdname+3(1)  = stkob-stlty.
      ltx_head-tdname+4(8)  = stkob-stlnr.
      ltx_head-tdname+12(2) = stkob-stlal.
      ltx_head-tdname+14(8) = stkob-stkoz.
    when ltx_stpo.
      ltx_head-tdid(1)      = stpoi-stlty.
      ltx_head-tdid+1(2)    = ltx_stpo.
      ltx_head-tdspras      = stpoi-ltxsp.
      ltx_head-tdname(3)    = sy-mandt.
      ltx_head-tdname+3(1)  = stpoi-stlty.
      ltx_head-tdname+4(8)  = stpoi-stlnr.
      ltx_head-tdname+12(8) = stpoi-stlkn.
      ltx_head-tdname+20(8) = stpoi-stpoz.
  endcase.  "ltx_table

* read text
  call function 'READ_TEXT'
       exporting
*           CLIENT                  = SY-MANDT
            id                      = ltx_head-tdid
            language                = ltx_head-tdspras
            name                    = ltx_head-tdname
            object                  = c_ltx_object
*           ARCHIVE_HANDLE          = 0
       importing
            header                  = ltx_head
       tables
            lines                   = ltx_lines
       exceptions
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            others                  = 8.

* sy-subrc is analysed after this form
   if sy-subrc = 0.
   endif.

endform.                    " READ_LONG_TEXT

*----------------------------------------------------------------------*
*       FORM bom_itabs_to_idoc
*----------------------------------------------------------------------*
*       create idoc data from application internal tables
*----------------------------------------------------------------------*
form bom_itabs_to_idoc tables idoc_data    structure edidd
                       using  ale_aennr    like      aenr-aennr
                              ale_datuv    like      stkob-datuv
                              idoc_control like      edidc
                              mescod       like      edidc-mescod.

data:
      msgfn     like e1stzum-msgfn,   "message function
      loc_waers like tcurc-isocd.

* set the message function number
  case mescod.
    when c_mescod_create.
      msgfn = c_mf_create.    "create new bom (refuse if already exists)
    when c_mescod_change.
      msgfn = c_mf_refresh.   "direct change request
    when c_mescod_delete.
      msgfn = c_mf_delete.    "delete bom
    when others.
      msgfn = c_mf_change.    "SMD change request
  endcase.

* put the application data records to the IDoc segments
* and append records to IDoc data table

*  BE AWARE OF
*  -> convert SAP codes to ISO codes
*  -> convert currency amounts from SAP internal to neutral format
*  -> left justify all non character fields


* -> STZU
  e1stzum-msgfn = msgfn.
  move-corresponding stzub to e1stzum.
* E1STZUM-EXSTL carries E1STKOM-BMENG (for releases < 46B)
***  MOVE stkob-bmeng TO e1stzum-exstl.  "DEL_Note_2304392
  move stzub-exstl to e1stzum-exstl_c.
  write stzub-ltxsp to e1stzum-ltxsp_iso.              "ISO-Language 4.0
* use AENRL to store ALE Change Number
  e1stzum-aenrl = ale_aennr.

*  begin of insertion note 641632

   if e1stzum-stlan is initial.
      loop at mastb.
         e1stzum-stlan = mastb-stlan.
         exit.
      endloop.
      loop at kdstb.
         e1stzum-stlan = kdstb-stlan.
         exit.
      endloop.
   endif.

*  end of insertion note 641632

  idoc_data-segnam = c_segnam_e1stzum.
  idoc_data-sdata  = e1stzum.
  append idoc_data.
  if not stzub-ltxsp is initial.
    e1szuth-msgfn = msgfn.
*   read long text (bom) and fill segments
    perform read_long_text using ltx_stzu.
    if sy-subrc = 0.
      move-corresponding ltx_head to e1szuth.
      write ltx_head-tdspras to e1szuth-tdspras_iso.   "ISO-Language 4.0
      idoc_data-segnam = c_segnam_e1szuth.
      idoc_data-sdata  = e1szuth.
      append idoc_data.
      loop at ltx_lines.
        move-corresponding ltx_lines to e1szutl.
        idoc_data-segnam = c_segnam_e1szutl.
        idoc_data-sdata  = e1szutl.
        append idoc_data.
      endloop.
    endif.
  endif.


* -> MAST
  loop at mastb.
    e1mastm-msgfn = msgfn.
    move-corresponding mastb to e1mastm.
*   left-justify data
    condense: e1mastm-losvn, e1mastm-losbs.
    idoc_data-segnam = c_segnam_e1mastm.
    idoc_data-sdata  = e1mastm.
    append idoc_data.
*   Absprung für Leergutstücklisten (Retail)
    call function 'WSTA_PACK_E1T415B'
         exporting
             msgfn   =  msgfn
             segnam  =  c_segnam_e1t415b
             matnr   =  mastb-matnr
             stlan   =  mastb-stlan
             stlal   =  mastb-stlal
         tables
             idoc_data = idoc_data
             .
  endloop.


* -> DOST
  loop at dostb.
    e1dostm-msgfn = msgfn.
    move-corresponding dostb to e1dostm.
    idoc_data-segnam = c_segnam_e1dostm.
    idoc_data-sdata  = e1dostm.
    append idoc_data.
  endloop.


* -> KDST
  loop at kdstb.
    e1kdstm-msgfn = msgfn.
    move-corresponding kdstb to e1kdstm.
    idoc_data-segnam = c_segnam_e1kdstm.
    idoc_data-sdata  = e1kdstm.
    append idoc_data.
  endloop.


* -> STKO
  loop at stkob.
    move-corresponding stkob to e1stkom.
    if g_flg_guid_into_idoc is initial.                    "note 567351
      clear e1stkom-guidx.
    endif.                                                 "note 567351
*   populate new fields for quantity handling
    move stkob-bmeng to e1stkom-bmeng_c.
    clear e1stkom-bmeng.
    if stkob-vbkz = 'S'.
       e1stkom-msgfn = c_mf_sync.
    else.
       e1stkom-msgfn = msgfn.
       e1stkom-datuv = ale_datuv.
    endif.
    write stkob-ltxsp to e1stkom-ltxsp_iso.            "ISO-Language 4.0
*   convert SAP units
    perform unit_codes_sap_to_iso using      stkob-bmein
                                  changing e1stkom-bmein.
    if idoc_control-mestyp <> c_mestyp_bomord.
       idoc_data-segnam = c_segnam_e1stkom.
       idoc_data-sdata  = e1stkom.
    else.
       move-corresponding e1stkom to e1stkon.
       move e1stkom-bmeng_c to e1stkon-bmeng.

       idoc_data-segnam = c_segnam_e1stkon.
       idoc_data-sdata  = e1stkon.
    endif.

    append idoc_data.

    if not stkob-ltxsp is initial.
      e1skoth-msgfn = msgfn.
*     read long text (bom alternative) and fill segments
      perform read_long_text using ltx_stko.
      if sy-subrc = 0.
        move-corresponding ltx_head to e1skoth.
        write ltx_head-tdspras to e1skoth-tdspras_iso. "ISO-Language 4.0
        idoc_data-segnam = c_segnam_e1skoth.
        idoc_data-sdata  = e1skoth.
        append idoc_data.
        loop at ltx_lines.
          move-corresponding ltx_lines to e1skotl.
          idoc_data-segnam = c_segnam_e1skotl.
          idoc_data-sdata  = e1skotl.
          append idoc_data.
        endloop.
      endif.
    endif.
  endloop.

  if mescod = c_mescod_delete and stkob is initial.        "note0577493
    if idoc_control-mestyp <> c_mestyp_bomord.             "note0577493
       e1stkom-msgfn = c_mf_sync.                          "note0577493
* Begin of note 902448
* Physically deleted BOM is sent through Change pointer
* And hence the datuv has to be populated with ale_datuv
       e1stkom-datuv = ale_datuv.
* End of note 902448
       idoc_data-segnam = c_segnam_e1stkom.                "note0577493
       idoc_data-sdata  = e1stkom.                         "note0577493
    else.                                                  "note0577493
       e1stkon-msgfn = c_mf_sync.                          "note0577493
       idoc_data-segnam = c_segnam_e1stkon.                "note0577493
       idoc_data-sdata  = e1stkon.                         "note0577493
    endif.                                                 "note0577493
    append idoc_data.                                      "note0577493
  endif.

* -> STAS
  loop at stasb.
    e1stasm-msgfn = msgfn.
    move-corresponding stasb to e1stasm.
    idoc_data-segnam = c_segnam_e1stasm.
    idoc_data-sdata  = e1stasm.
    append idoc_data.
  endloop.


* -> STPO
  loop at stpoi.
    clear e1stpom.                                          "note630112
    e1stpom-msgfn = msgfn.
    move-corresponding stpoi to e1stpom.
*   clear not yet supported fields
    if g_flg_guid_into_idoc is initial.                  "note 567351
      clear e1stpom-guidx.
    endif.                                               "note 567351
    clear e1stpom-itmid.
*   populate new fields for quantity handling
    move stpoi-menge    to e1stpom-menge_c.
    move stpoi-id_class to e1stpom-id_class_c.
    move stpoi-romen    to e1stpom-romen_c.
*   GUID of preceding node                                 "note 567351
    if not g_flg_guid_into_idoc is initial.                "note 567351
      if not stpoi-id_guid is initial.                     "note 567351
        move stpoi-id_guid  to e1stpom-id_comp_guid.       "note 567351
      endif.                                               "note 567351
    endif.                                                 "note 567351
*   classname handling

*   Begin of Note_1466681

*    if stpoi-postp = 'K'.
*       clear e1stpom-class.
*       e1stpom-klasse = stpoi-class.
*    endif.

    data: h_t418 like t418.
    clear: h_t418.
    call function 'T418_READ'
       exporting
            postp    = stpoi-postp
       importing
            struct   = h_t418
       exceptions
            no_entry  = 1
            others    = 2.

    if h_t418-klpos = 'X'.
       clear e1stpom-class.
       e1stpom-klasse = stpoi-class.
    endif.

*   End of Note_1466681

*   quantity handling
    clear e1stpom-menge.
    if stpoi-postp = 'R'.
       e1stpom-id_class = stpoi-menge.
    else.
       e1stpom-romen = stpoi-menge.
    endif.
    write stpoi-ltxsp to e1stpom-ltxsp_iso.            "ISO-Language 4.0
*   set ALE valid_from date
    e1stpom-datuv = ale_datuv.
    if not stpoi-lkenz is initial.
*      position will be deleted -> set message function accordingly
       e1stpom-msgfn = c_mf_delete.
       idoc_data-segnam = c_segnam_e1stpom.
       idoc_data-sdata  = e1stpom.
       append idoc_data.
       continue.
    endif.

*   convert SAP unit codes
    perform unit_codes_sap_to_iso using      stpoi-meins
                                  changing e1stpom-meins.
    perform unit_codes_sap_to_iso using      stpoi-romei
                                  changing e1stpom-romei.
    perform unit_codes_sap_to_iso using      stpoi-nlfmv
                                  changing e1stpom-nlfmv.

*   convert currency amount
    if not stpoi-preis is initial.
      call function 'CURRENCY_AMOUNT_SAP_TO_IDOC'
           exporting
                currency    = stpoi-waers
                sap_amount  = stpoi-preis
           importing
                idoc_amount = e1stpom-preis
           exceptions
                others      = 0.
    endif.

*   convert currency unit
    if not stpoi-waers is initial.
      call function 'CURRENCY_CODE_SAP_TO_ISO'
           exporting
                sap_code = stpoi-waers
           importing
                iso_code = loc_waers
           exceptions
                not_found   = 0
                others      = 0.
      e1stpom-waers = loc_waers.
    endif.

    if idoc_control-mestyp <> c_mestyp_bomord.
*      left-justify data
       condense: e1stpom-ausch, e1stpom-avoau, e1stpom-nlfzt,
                 e1stpom-ewahr, e1stpom-lifzt, e1stpom-preis,
                 e1stpom-peinh, e1stpom-roanz, e1stpom-roms1,
                 e1stpom-roms2, e1stpom-roms3, e1stpom-romen,
                 e1stpom-webaz, e1stpom-csstr, e1stpom-nlfzv.
       idoc_data-segnam = c_segnam_e1stpom.
       idoc_data-sdata  = e1stpom.
    else.
       move-corresponding e1stpom to e1stpon.
       move e1stpom-menge_c to e1stpon-menge.
       move e1stpom-id_class_c to e1stpon-id_class.
       move e1stpom-romen_c to e1stpon-romen.
*      left-justify data
       condense: e1stpon-ausch, e1stpon-avoau, e1stpon-nlfzt,
                 e1stpon-ewahr, e1stpon-lifzt, e1stpon-preis,
                 e1stpon-peinh, e1stpon-roanz, e1stpon-roms1,
                 e1stpon-roms2, e1stpon-roms3, e1stpon-romen,
                 e1stpon-webaz, e1stpon-csstr, e1stpon-nlfzv.
       idoc_data-segnam = c_segnam_e1stpon.
       idoc_data-sdata  = e1stpon.
    endif.
    append idoc_data.
ENHANCEMENT-POINT MAT_BOM_READ_CSS4_01 SPOTS ES_SAPLCSDS.

*   dependencies
    if not stpoi-knobj is initial.
      loop at api_dep_dat where item_node = stpoi-stlkn
                          and  item_count = stpoi-stpoz.
*       basic data (local and global depndencies)
        e1cukbm-msgfn = msgfn.
        move-corresponding api_dep_dat to e1cukbm.
        read table api_dep_ord with key
*       Begin of Note 789904
*                   dep_intern = api_dep_dat-dep_intern.
                    dep_intern = api_dep_dat-dep_intern
                    item_node  = api_dep_dat-item_node
                    item_count = api_dep_dat-item_count.
*       End of Note 789904
        e1cukbm-dep_lineno = api_dep_ord-dep_lineno.
        idoc_data-segnam = c_segnam_e1cukbm.
        idoc_data-sdata  = e1cukbm.
        append idoc_data.
        if api_dep_dat-dep_intern co numbers.
*         descripition, source and docu of local dependencies only
          loop at api_dep_des where dep_intern = api_dep_dat-dep_intern.
            e1cukbt-msgfn = msgfn.
            move-corresponding api_dep_des to e1cukbt.
            idoc_data-segnam = c_segnam_e1cukbt.
            idoc_data-sdata  = e1cukbt.
            append idoc_data.
          endloop.
          loop at api_dep_src where dep_intern = api_dep_dat-dep_intern.
            clear e1cuknm.
            move-corresponding api_dep_src to e1cuknm.
            if not e1cuknm is initial.       "skip empty lines of source
              e1cuknm-msgfn = msgfn.
              idoc_data-segnam = c_segnam_e1cuknm.
              idoc_data-sdata  = e1cuknm.
              append idoc_data.
            endif.
          endloop.
          loop at api_dep_doc where dep_intern = api_dep_dat-dep_intern.
            e1cutxm-msgfn = msgfn.
            move-corresponding api_dep_doc to e1cutxm.
            idoc_data-segnam = c_segnam_e1cutxm.
            idoc_data-sdata  = e1cutxm.
            append idoc_data.
          endloop.
        endif.      "local dependencies
      endloop.   "api_dep_dat
    endif.   "dependencies

*   read long text (bom position) and fill segments
    if not stpoi-ltxsp is initial.
      e1spoth-msgfn = msgfn.
      perform read_long_text using ltx_stpo.
      if sy-subrc = 0.
        move-corresponding ltx_head to e1spoth.
        write ltx_head-tdspras to e1spoth-tdspras_iso. "ISO-Language 4.0
        idoc_data-segnam = c_segnam_e1spoth.
        idoc_data-sdata  = e1spoth.
        append idoc_data.
        loop at ltx_lines.
          move-corresponding ltx_lines to e1spotl.
          idoc_data-segnam = c_segnam_e1spotl.
          idoc_data-sdata  = e1spotl.
          append idoc_data.
        endloop.
      endif.
    endif.


* -> STPU
    loop at stpub where stlkn = stpoi-stlkn
                    and stpoz = stpoi-stpoz.
       e1stpum-msgfn = msgfn.
       move-corresponding stpub to e1stpum.
*      STPU-UPOSZ has to be transferred
       e1stpum-stlkn = stpub-uposz.
*      populate new field for sub-item quantity handling
       e1stpum-upmng_c = stpub-upmng.                       "note707484
       idoc_data-segnam = c_segnam_e1stpum.
       idoc_data-sdata  = e1stpum.
       append idoc_data.
    endloop.

  endloop. "stpoi


* BUSINESS TRANSACTION EVENT for data
  call function 'OPEN_FI_PERFORM_CS000110_E'
       exporting
          idoc_control    = idoc_control
       tables
          idoc_data       = t_idoc_data
       exceptions
          idoc_error      = 1.

  if sy-subrc = 1.
     raise customer_error.
  endif.


endform.  "BOM_ITABS_TO_IDOC

*&---------------------------------------------------------------------*
*&      Form  READ_BOM_HEADER
*&---------------------------------------------------------------------*
*       read bom header data into internal tables
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

endform.                    " READ_BOM_HEADER

*&---------------------------------------------------------------------*
*&      Form  SET_EXT_BOMID_FROM_CHNGDOC
*&---------------------------------------------------------------------*
*       set the external bom position identification from the
*       data stored in the STUE_V changedocument
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
endform.                    " SET_EXT_BOMID_FROM_CHNGDOC

*&---------------------------------------------------------------------*
*&      Form  CHECK_DLOCK
*&---------------------------------------------------------------------*
*       check if bom status allows distribution
*----------------------------------------------------------------------*
form check_dlock using dlock_ignore type dlock_ignore.

check dlock_ignore is initial.

select single * from t415s where stlst = stkob-stlst.
if t415s-dlock = c_true.
  raise distribution_lock.
endif.

endform.                    " CHECK_DLOCK
*&---------------------------------------------------------------------*
*&      Form  SEND_STTMAT_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CURRENT_CDCHGID  text
*      <--P_SUM_OF_CREATED_IDOCS  text
*      -->P_STOCKABLE_TYPES  text
*      -->P_CPID_SEND  text
*      -->P_CPID_DONE  text
*----------------------------------------------------------------------*
form send_sttmat_idoc
                tables   p_stockable_types structure mast_apicn
                         p_cpid_send       structure bdicpident
                         p_cpid_done       structure bdicpident
                using    p_current_cdchgid like bdcp-cdchgid
                         p_stlnr           like stko-stlnr
                         p_smd_tool        type char0001
                         p_mestyp          type edi_mestyp  "note731473
                changing p_sum_of_created_idocs.

data :  sum_of_idocs  like sy-tabix,
        mescod        like edidc-mescod.
*        DLOCK         LIKE DATATYPE-CHAR0001.


    check not p_cpid_send is initial.

    case p_current_cdchgid.
       when 'U'.
          mescod = c_mescod_change.
       when 'D'.
          mescod = c_mescod_delete.
       when others.
          mescod = c_mescod_create.
    endcase.


    call function 'MASTER_IDOC_CREATE_STTMAT'
        exporting
*           RCVPRN              =
            mescod              = mescod
            dlock_ignore        = c_true             "already done
            stlnr               = p_stlnr
            smd_tool            = p_smd_tool
            message_type        = p_mestyp                  "note731473
        importing
            created_comm_idocs  = sum_of_idocs
        tables
            config_mats         = p_stockable_types
        exceptions
            general_bom_failure = 1
            no_bom_found        = 2
            different_boms      = 3
            general_ale_failure = 4
            no_ref_found        = 5
            others              = 6.
    if sy-subrc = 0 or
       sy-subrc = 2 or
       sy-subrc = 5.
       append lines of p_cpid_send to p_cpid_done.
    endif.

    clear   : p_cpid_send,
              p_stockable_types.
    refresh : p_cpid_send,
              p_stockable_types.

    p_sum_of_created_idocs = p_sum_of_created_idocs + sum_of_idocs.

endform.                    " SEND_STTMAT_IDOC
*&---------------------------------------------------------------------*
*&      Form  ADD_STTMAT_TO_CPID_SEND
*&---------------------------------------------------------------------*
*   - Distribution, if one STKO-entry in in status without'dlock'
*   - Distribution for 'deletion' in any case (not STKO available)
*----------------------------------------------------------------------*
*      -->P_STOCKABLE_TYPES  text
*      -->P_CPID_SEND  text
*      <--P_CURRENT_CDOBJID  text
*      <--P_CURRENT_CDCHGID  text
*      <--P_CURRENT_TABKEY  text
*----------------------------------------------------------------------*
form add_sttmat_to_cpid_send
           tables   p_stockable_types structure mast_apicn
                    p_chng_ptrs       structure bdcp
                    p_cpid_send       structure bdicpident
                    p_cpid_done       structure bdicpident
                    p_itab_ptrs       type      ptrs_tab
           changing p_current_cdobjid like bdcp-cdobjid
                    p_current_cdchgid like bdcp-cdchgid
                    p_current_tabkey  like bdcp-tabkey.


data : wa_mast   like mast,
       wa_ptrs   type ptrs_type.


      wa_mast-matnr = p_chng_ptrs-tabkey+3(18).
      wa_mast-werks = p_chng_ptrs-tabkey+21(4).
      wa_mast-stlan = p_chng_ptrs-tabkey+25(1).
      wa_mast-stlal = p_chng_ptrs-tabkey+34(2).

*  nicht gesperrt : Verteilen ok
   read table p_stockable_types
      with key matnr = wa_mast-matnr
               werks = wa_mast-werks
               stlan = wa_mast-stlan
               stlal = wa_mast-stlal.
   if sy-subrc = 0.
*     condensed stockable type is already to be sent : set all real to
*     done
      loop at p_itab_ptrs into wa_ptrs where cond = p_chng_ptrs-cpident.
         p_cpid_done = wa_ptrs-real.
         append p_cpid_done.
      endloop.
   else.
*     add key-data for distribution
      move-corresponding wa_mast to p_stockable_types.
      append  p_stockable_types.
      loop at p_itab_ptrs into wa_ptrs where cond = p_chng_ptrs-cpident.
         p_cpid_send = wa_ptrs-real.
         append p_cpid_send to p_cpid_send.
      endloop.
*     set new current values
      p_current_cdobjid = p_chng_ptrs-cdobjid.
      p_current_cdchgid = p_chng_ptrs-cdchgid.
      p_current_tabkey  = p_chng_ptrs-tabkey.
   endif.

endform.                    " ADD_STTMAT_TO_CPID_SEND
*&---------------------------------------------------------------------*
*&      Form  KDA_BOM_READ_CSS4
*&---------------------------------------------------------------------*
*       Expolosion for sales order BOM
*----------------------------------------------------------------------*
*      -->P_VBELN  text
*      -->P_VPOSI  text
*      -->P_MATNR  text
*      -->P_WERK  text
*      -->P_STLAN  text
*      -->P_STLAL  text
*      -->P_DATUV  text
*----------------------------------------------------------------------*
form kda_bom_read_css4 using    p_vbeln like kdst-vbeln
                                p_vbpos like kdst-vbpos
                                p_matnr like kdst-matnr
                                p_werk  like kdst-werks
                                p_stlan like kdst-stlan
                                p_stlal like kdst-stlal
                                p_datuv like stko-datuv.

   data:
*     local data
      topmat     like cstmat,
      matcat     like cscmat occurs 0 with header line,
      stb        like stpox  occurs 0 with header line,
      stpub_save like stpub  occurs 0,
      lt_vgknt   type vgknt_type occurs 0 with header line, "n567351
      lt_guid    type guid_type  occurs 0 with header line. "n567351

*  initialize the internal bom tables
   perform initialize_bom_itabs.                             "note809610

*  explode bom
   call function 'CS_BOM_EXPL_KND_V1'
         exporting
              alekz = c_true                               "note 582821
              capid = space
              vbeln = p_vbeln
              vbpos = p_vbpos
              mtnrv = p_matnr
              werks = p_werk
              stlan = p_stlan
              stlal = p_stlal
              datuv = p_datuv
         importing
              topmat = topmat
         tables
              stb    = stb
              matcat = matcat
         exceptions
              alt_not_found         = 1
              call_invalid          = 2
              material_not_found    = 3
              missing_authorization = 4
              no_bom_found          = 5
              no_plant_data         = 6
              no_suitable_bom_found = 7
              conversion_error      = 8
              others                = 9
              .

   if sy-subrc ne 0.
     raise no_bom_found.
   endif.

*  move data to internal tables

*  -> bom header (single alternative)
   move-corresponding topmat to kdstb.
      kdstb-vbeln = p_vbeln.
      kdstb-vbpos = p_vbpos.
      append kdstb.
   move-corresponding topmat to stzub.

  select single ltxsp ztext stldt stltm                     "note 596491
          from stzu
          into corresponding fields of stzub
          where stlty = stzub-stlty
          and   stlnr = stzub-stlnr.      "read bom text
   append stzub.
   move-corresponding topmat to stkob. append stkob.
  call function 'GET_STKO'
       exporting
            all             = 'X'
            datuv           = p_datuv
            set             = 'X'
            valid           = 'X'
       tables
            wa              = stkob
       exceptions
            others          = 1 .
   read table stkob index 1.

* --- begin of insertion note 567351
* Collect Information on preceding nodes
  if not g_flg_guid_into_idoc is initial.
    IF ( stb[] IS NOT INITIAL ).
    select stlty stlnr stlkn stpoz vgknt vgpzl
           from stpo into table lt_vgknt
           for all entries in stb
           where stlty = stb-stlty and
                 stlnr = stb-stlnr and
                 stlkn = stb-stlkn and
                 stpoz = stb-stpoz.
      endif.
IF lt_vgknt[] IS NOT initial.
    select stlkn stpoz guidx from stpo into table lt_guid
           for all entries in lt_vgknt
           where stlty = lt_vgknt-stlty and
                 stlnr = lt_vgknt-stlnr and
                 stlkn = lt_vgknt-vgknt and
                 stpoz = lt_vgknt-vgpzl.
 ENDIF.
   endif.
* --- end of insertion note 567351

*  -> bom positions
   loop at stb.
     clear stpoi.                                            "note630112
     move-corresponding stb to stpoi.
     stpoi-matkl = stb-itmmk.
* -- begin of insertion note 567351
*    retrieve GUID of preceding node
     if not g_flg_guid_into_idoc is initial.
       read table lt_vgknt with key stlkn = stb-stlkn
                                    stpoz = stb-stpoz.
       if sy-subrc eq 0 and lt_vgknt-vgknt ne 0 and
                            lt_vgknt-vgpzl ne 0.
         read table lt_guid with key stlkn = lt_vgknt-vgknt
                                     stpoz = lt_vgknt-vgpzl.
         if sy-subrc eq 0.
           stpoi-id_guid = lt_guid-guid.
         endif.
       endif.
     endif.
* -- end of insertion note 567351
     append stpoi.
     if not stpoi-upskz is initial.
*      get bom sub-positions (STPU)
       stpub-stlty = c_bomtyp_ord.
*d     STPUB-STLNR = MASTB-STLNR.                          "note0530922
       stpub-stlnr = kdstb-stlnr.                          "note0530922
       stpub-stlkn = stpoi-stlkn.
       stpub-stpoz = stpoi-stpoz.
       call function 'GET_STPU'
            exporting
                 all             = c_true
                 set             = c_true
            tables
                 wa              = stpub
            exceptions
                 call_invalid    = 1
                 end_of_table    = 2
                 get_without_set = 3
                 key_incomplete  = 4
                 no_record_found = 5
                 others          = 6.

       case sy-subrc.
         when 0.   "ok -> continue
         when 5.   "no record -> continue
         when others.
           exit.
       endcase.
       append lines of stpub to stpub_save.
     endif.
   endloop. "STB
   stpub[] = stpub_save[].

*  get dependency data
   perform dependency_read using p_datuv.

endform.                    " KDA_BOM_READ_CSS4
*&---------------------------------------------------------------------*
*&      Form  CONDENSE_PTRS_STT
*&---------------------------------------------------------------------*
*  Determine from the CP-functions of each stockable type what fuction
*  has to be performed in the target system. Therefore the first and
*  last function in the source system are evaluated :
*
*   first    last    |    target
*   ----------------------------
*     I        I     |      I
*     I        C     |      I
*     I        D     |     none
*     C        I     |      C
*     C        C     |      C
*     C        D     |      D
*     D        I     |      C
*     D        C     |      C
*     D        D     |      D
*
*----------------------------------------------------------------------*
*      -->P_CHNG_PTRS  text
*----------------------------------------------------------------------*
form condense_ptrs_stt tables p_chng_ptrs structure bdcp
                              p_itab_ptrs type      ptrs_tab
                              p_cpid_done structure bdicpident.

data : new_ptrs       like bdcp occurs 0 with header line,
       curr_ptr       like bdcp,
       chgid_last     like bdcp-cdchgid,
       wa_ptrs        type ptrs_type.


  clear   new_ptrs.    refresh new_ptrs.
  clear   wa_ptrs.     refresh p_itab_ptrs.

* Sort Change-pointers to get ALE-functions
  sort p_chng_ptrs by tabkey acttime.

* process all CPs
  clear curr_ptr.
  loop at p_chng_ptrs.

*    different stockable type
     if p_chng_ptrs-tabkey <> curr_ptr-tabkey.

        if not curr_ptr is initial.
*          end processing of recent one
           new_ptrs = curr_ptr.
           case curr_ptr-cdchgid.
              when 'I'.
                 if chgid_last <> 'D'.         "I - I/U : Insert
                    new_ptrs-cdchgid = 'I'.
                 else.                         "I - D   : no IDOC
                    clear new_ptrs.
                   "move CPs to processed
                    loop at p_itab_ptrs
                          where cond = curr_ptr-cpident.
                       p_cpid_done = p_itab_ptrs-real.
                       delete p_itab_ptrs index sy-tabix.
                       append p_cpid_done.
                    endloop.
                 endif.
              when 'U'.
                 if chgid_last <> 'D'.         "U - I/U : Change
                    new_ptrs-cdchgid = 'U'.
                 else.                         "U - D   : Delete
                    new_ptrs-cdchgid = 'D'.
                 endif.
              when 'D'.
                 if chgid_last <> 'D'.         "D - I/U : Change
                    new_ptrs-cdchgid = 'U'.
                 else.                         "D - D   : Delete
                    new_ptrs-cdchgid = 'D'.
                 endif.
           endcase.
           if not new_ptrs is initial.
              append new_ptrs.
           endif.
        endif.

*       start processing current one
        curr_ptr = p_chng_ptrs.
     endif.

*    for every CP
     chgid_last = p_chng_ptrs-cdchgid.
     wa_ptrs-real = p_chng_ptrs-cpident.
     wa_ptrs-cond = curr_ptr-cpident.
     append wa_ptrs to p_itab_ptrs.

  endloop.

* end processing of recent one
  new_ptrs = curr_ptr.
  case curr_ptr-cdchgid.
      when 'I'.
         if chgid_last <> 'D'.         "I - I/U : Insert
            new_ptrs-cdchgid = 'I'.
         else.                         "I - D   : no IDOC
            clear new_ptrs.
           "move CPs to processed
            loop at p_itab_ptrs
                  where cond = curr_ptr-cpident.
               p_cpid_done = p_itab_ptrs-real.
               delete p_itab_ptrs index sy-tabix.
               append p_cpid_done.
            endloop.
         endif.
      when 'U'.
         if chgid_last <> 'D'.         "U - I/U : Change
            new_ptrs-cdchgid = 'U'.
         else.                         "U - D   : Delete
            new_ptrs-cdchgid = 'D'.
         endif.
      when 'D'.
         if chgid_last <> 'D'.         "D - I/U : Change
            new_ptrs-cdchgid = 'U'.
         else.                         "D - D   : Delete
            new_ptrs-cdchgid = 'D'.
         endif.
   endcase.
   if not new_ptrs is initial.
      append new_ptrs.
   endif.

   clear p_chng_ptrs.
   p_chng_ptrs[] = new_ptrs[].

endform.                    " CONDENSE_PTRS_STT
*&---------------------------------------------------------------------*
*&      Form  UPOS_READ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form upos_read using i_stlty like stzu-stlty.

  data:  l_stpub like stpub occurs 0 with header line.

  clear stpub. refresh stpub.

  loop at stpoi where not upskz is initial.

    l_stpub-stlty = i_stlty.
    l_stpub-stlnr = stpoi-stlnr.
    l_stpub-stlkn = stpoi-stlkn.
    l_stpub-stpoz = stpoi-stpoz.

    call function 'GET_STPU'
         exporting
              all             = c_true
              set             = c_true
         tables
              wa              = l_stpub
         exceptions
              call_invalid    = 1
              end_of_table    = 2
              get_without_set = 3
              key_incomplete  = 4
              no_record_found = 5
              others          = 6.
    case sy-subrc.
      when 0.   "ok -> continue
      when 5.   "no record -> continue
      when others.
        exit.
    endcase.
    append lines of l_stpub to stpub.

  endloop.
endform.                    " UPOS_READ
*&---------------------------------------------------------------------*
*&      Form  initialize_bom_itabs
*&---------------------------------------------------------------------*
*       new form routine via note 809610
*----------------------------------------------------------------------*
form initialize_bom_itabs .

  clear mastb. refresh mastb.
  clear dostb. refresh dostb.
  clear kdstb. refresh kdstb.
  clear stzub. refresh stzub.
  clear stkob. refresh stkob.
  clear stasb. refresh stasb.
  clear stpoi. refresh stpoi.
  clear stpub. refresh stpub.

endform.                    " initialize_bom_itabs
