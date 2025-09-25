*----------------------------------------------------------------------*
***INCLUDE LCTALF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  extract
*&---------------------------------------------------------------------*
*
* IDOC-structure:
*
*  E1CABNM                   Charact: Basic data
*  |--E1CUKBM                Knowledge charact: Basic data
*  |  |--E1CUKBT             Knowledge charact: Description
*  |  |--E1CUKNM             Knowledge charact: Source
*  |  +--E1CUTXM             Knowledge charact: Documentation
*  |--E1CABTM                Charact: Description
*  |--E1TEXTL                Charact: Long text line
*  |--E1CAWNM                Value
*  |  |--E1CUKB1             Knowledge value: basic data
*  |  |  |--E1CUKB2          Knowledge value: description
*  |  |  |--E1CUKN1          Knowledge value: source
*  |  |  +--E1CUTX1          Knowledge value: documentation
*  |  |--E1CAWTM             Value: Description
*  |  +--E1TXTL1             Value: Long text line
*  |--E1TCMEM                Charact: Restriction to class type
*  |--E1CABZM                Charact: Table field reference
*  +--E1DATEM                Change service information
*
*----------------------------------------------------------------------*
*....Charact basic data.................................................
*....Charact description................................................
*....Table field references.............................................
*....Charact values.....................................................
*....Charact value descriptions.........................................
*....Dependency knowledge allocation data...............................
**....Basic knowledge data of value.....................................
**....Text of knowledge of value........................................
**....Basic knowledge data of charact...................................
**....Text of knowledge of charact......................................
**....Knowledge source of value.........................................
**....Knowledge source of charact.......................................
**....Documentation of knowledge of value...............................
**....Documentation of knowledge of charact.............................
*....Change service information.........................................
*....Restriction to class types.........................................
*....Long text..........................................................
**....Charact...........................................................
**....Charact value.....................................................
*----------------------------------------------------------------------*
FORM extract
    TABLES
      idoc_data                        structure edidd
    USING
      is_idoc_control                  type edidc
    CHANGING
      es_e1datem                       type e1datem
      es_cabn                          type line of tt_cabn
      et_cabnt                         type tt_cabnt
      et_cabnz                         type tt_cabnz
      et_cawn                          type tt_cawn
      et_cawnt                         type tt_cawnt
      et_tcme                          type tt_tcme
      et_cukb1                         type tt_e1cukb1
      et_cukb2                         type tt_e1cukb2
      et_cukbm                         type tt_e1cukbm
      et_cukbt                         type tt_e1cukbt
      et_cukn1                         type tt_e1cukn1
      et_cuknm                         type tt_e1cuknm
      et_cutx1                         type tt_e1cutx1
      et_cutxm                         type tt_e1cutxm
      et_valtext                       type tt_valtext
      ef_delete                        type flag.

data:
    lw_cabnt                           type line of tt_cabnt,
    lw_cabnz                           type line of tt_cabnz,
    lw_cawn                            type line of tt_cawn,
    lw_cawnt                           type line of tt_cawnt,
    lw_tcme                            type line of tt_tcme,
    ls_e1cabnm                         type e1cabnm,
    ls_e1cabtm                         type e1cabtm,
    ls_e1cabzm                         type e1cabzm,
    ls_e1cawnm                         type e1cawnm,
    ls_e1cawtm                         type e1cawtm,
    ls_e1cukb1                         type e1cukb1,
    ls_e1cukb1x                        type line of tt_e1cukb1,
    ls_e1cukb2x                        type line of tt_e1cukb2,
    ls_e1cukbm                         type e1cukbm,
    ls_e1cukbmx                        type line of tt_e1cukbm,
    ls_e1cukbt                         type e1cukbt,
    ls_e1cukbtx                        type line of tt_e1cukbt,
    ls_e1cukn1x                        type line of tt_e1cukn1,
    ls_e1cuknm                         type e1cuknm,
    ls_e1cuknmx                        type line of tt_e1cuknm,
    ls_e1cutx1x                        type line of tt_e1cutx1,
    ls_e1cutxm                         type e1cutxm,
    ls_e1cutxmx                        type line of tt_e1cutxm,
    ls_e1tcmem                         type e1tcmem,
    ls_e1textl                         type e1textl,
    ls_e1txtl1                         type e1txtl1,
    ls_text                            type line of tt_chr_text,
    ls_valtext                         type line of tt_valtext,
    l_value                            type atwrt value '$$$$$'.

field-symbols:
    <fs_data>                          type edidd.


clear:
    es_cabn,
    et_cabnt[],
    et_cabnz[],
    et_cawn[],
    et_cawnt[],
    et_cukb1[],
    et_cukb2[],
    et_cukbm[],
    et_cukbt[],
    et_cukn1[],
    et_cuknm[],
    et_cutx1[],
    et_cutxm[],
    et_tcme[],
    et_valtext[].


loop at idoc_data
    assigning <fs_data>
    where docnum eq is_idoc_control-docnum.

  case <fs_data>-segnam.


*....Charact basic data.................................................
    when c_segnam_cabn.
      ls_e1cabnm                       = <fs_data>-sdata.
** Special logic: If charact is to be deleted this is told here.
      if ls_e1cabnm-msgfn eq c_delete.
        ef_delete = 'X'.
** We can't exit here because the segment containing the change order
** stands at the last place. The check on the deletion flag at the
** start of each segment will at least make sure the extraction isn't
** performed in this case.
      endif.
      move-corresponding ls_e1cabnm to es_cabn.            "#EC ENHOK

** Unit is transfered in ISO format but expected in internal
** format.
      perform unit_of_measure_iso_to_sap
          using
            es_cabn-msehi
            es_cabn-atfor
          changing
            es_cabn-msehi.


*....Charact description................................................
    when c_segnam_cabnt.
      check ef_delete is initial.
      clear:
          lw_cabnt,
          ls_e1cabtm.
      ls_e1cabtm                       = <fs_data>-sdata.
      move-corresponding ls_e1cabtm to lw_cabnt.
      append lw_cabnt to et_cabnt.


*....Table field references.............................................
    when c_segnam_cabnz.
      check ef_delete is initial.
      clear:
          lw_cabnz,
          ls_e1cabzm.
      ls_e1cabzm                       = <fs_data>-sdata.
      move-corresponding ls_e1cabzm to lw_cabnz.
      append lw_cabnz to et_cabnz.


*....Charact values.....................................................
    when c_segnam_cawn.
      check ef_delete is initial.
      clear:
          lw_cawn,
          ls_e1cawnm.
      ls_e1cawnm                       = <fs_data>-sdata.
      move-corresponding ls_e1cawnm to lw_cawn.            "#EC ENHOK

** Unit is transfered in ISO format but expected in internal
** format.
      if not lw_cawn-atawe is initial.
        perform unit_of_measure_iso_to_sap
            using
              lw_cawn-atawe
              es_cabn-atfor
            changing
              lw_cawn-atawe.
      endif.
      if not lw_cawn-ataw1 is initial.
        perform unit_of_measure_iso_to_sap
            using
              lw_cawn-ataw1
              es_cabn-atfor
            changing
              lw_cawn-ataw1.
      endif.

      append lw_cawn to et_cawn.

** Value has to be converted to external format because of long text
** and dependency knowledge allocations.
      clear l_value.
      perform convert_value_to_ext
          using
            es_cabn
            lw_cawn
          changing
            l_value.


*....Charact value descriptions.........................................
    when c_segnam_cawnt.
      check ef_delete is initial.
      clear:
          lw_cawnt,
          ls_e1cawtm.
      ls_e1cawtm                       = <fs_data>-sdata.
      move-corresponding ls_e1cawtm to lw_cawnt.           "#EC ENHOK
      append lw_cawnt to et_cawnt.


*....Dependency knowledge allocation data...............................
**....Basic knowledge data of value.....................................
    when c_segnam_cukb1.
      check ef_delete is initial.
      clear:
          ls_e1cukb1,
          ls_e1cukb1x.
      ls_e1cukb1                       = <fs_data>-sdata.
      ls_e1cukb1x-charact              = es_cabn-atnam.
      ls_e1cukb1x-value                = l_value.
      ls_e1cukb1x-e1cukbm              = ls_e1cukb1.
      append ls_e1cukb1x to et_cukb1.

**....Text of knowledge of value........................................
    when c_segnam_cukb2.
      check ef_delete is initial.
      clear:
          ls_e1cukb2x,
          ls_e1cukbt.
      ls_e1cukbt                       = <fs_data>-sdata.
      move-corresponding ls_e1cukb1 to ls_e1cukn1x.
      ls_e1cukb2x-charact              = es_cabn-atnam.
      ls_e1cukb2x-value                = l_value.
*     ls_e1cukb2x-dep_intern           =
*     ls_e1cukb2x-dep_extern           =
      ls_e1cukb2x-e1cukbt              = ls_e1cukbt.
      append ls_e1cukb2x to et_cukb2.

**....Basic knowledge data of charact...................................
    when c_segnam_cukbm.
      check ef_delete is initial.
      clear:
          ls_e1cukbm,
          ls_e1cukbmx.
      ls_e1cukbm                       = <fs_data>-sdata.
      ls_e1cukbmx-charact              = es_cabn-atnam.
      ls_e1cukbmx-e1cukbm              = ls_e1cukbm.
      append ls_e1cukbmx to et_cukbm.

**....Text of knowledge of charact......................................
    when c_segnam_cukbt.
      check ef_delete is initial.
      clear:
          ls_e1cukbt,
          ls_e1cukbtx.
      ls_e1cukbt                       = <fs_data>-sdata.
      move-corresponding ls_e1cukbm to ls_e1cuknmx.
      ls_e1cukbtx-charact              = es_cabn-atnam.
*     ls_e1cukbtx-dep_intern           =
*     ls_e1cukbtx-dep_extern           =
      ls_e1cukbtx-e1cukbt              = ls_e1cukbt.
      append ls_e1cukbtx to et_cukbt.

**....Knowledge source of value.........................................
    when c_segnam_cukn1.
      check ef_delete is initial.
      clear:
          ls_e1cukn1x,
          ls_e1cuknm.
      ls_e1cuknm                       = <fs_data>-sdata.
      move-corresponding ls_e1cukb1 to ls_e1cukn1x.
      ls_e1cukn1x-charact              = es_cabn-atnam.
      ls_e1cukn1x-value                = l_value.
*     ls_e1cukn1x-dep_intern           =
*     ls_e1cukn1x-dep_extern           =
      ls_e1cukn1x-e1cuknm              = ls_e1cuknm.
      append ls_e1cukn1x to et_cukn1.

**....Knowledge source of charact.......................................
    when c_segnam_cuknm.
      check ef_delete is initial.
      clear:
          ls_e1cuknm,
          ls_e1cuknmx.
      ls_e1cuknm                       = <fs_data>-sdata.
      move-corresponding ls_e1cukbm to ls_e1cuknmx.
      ls_e1cuknmx-charact              = es_cabn-atnam.
      ls_e1cuknmx-value                = l_value.
*     ls_e1cuknmx-dep_intern           =
*     ls_e1cuknmx-dep_extern           =
      ls_e1cuknmx-e1cuknm              = ls_e1cuknm.
      append ls_e1cuknmx to et_cuknm.

**....Documentation of knowledge of value...............................
    when c_segnam_cutx1.
      check ef_delete is initial.
      clear:
          ls_e1cutx1x,
          ls_e1cutxm.
      ls_e1cutxm                       = <fs_data>-sdata.
      move-corresponding ls_e1cukb1 to ls_e1cukn1x.
      ls_e1cutx1x-charact              = es_cabn-atnam.
      ls_e1cutx1x-value                = l_value.
*     ls_e1cutx1x-dep_intern           =
*     ls_e1cutx1x-dep_extern           =
      ls_e1cutx1x-e1cutxm              = ls_e1cutxm.
      append ls_e1cutx1x to et_cutx1.

**....Documentation of knowledge of charact.............................
    when c_segnam_cutxm.
      check ef_delete is initial.
      clear:
          ls_e1cutxmx,
          ls_e1cutxm.
      ls_e1cutxm                       = <fs_data>-sdata.
      move-corresponding ls_e1cukbm to ls_e1cuknmx.
      ls_e1cutxmx-charact              = es_cabn-atnam.
      ls_e1cutxmx-value                = l_value.
*     ls_e1cutxmx-dep_intern           =
*     ls_e1cutxmx-dep_extern           =
      ls_e1cutxmx-e1cutxm              = ls_e1cutxm.
      append ls_e1cutxmx to et_cutxm.


*....Change service information.........................................
    when c_segnam_date.
      es_e1datem                       = <fs_data>-sdata.


*....Restriction to class types.........................................
    when c_segnam_tcme.
      check ef_delete is initial.
      clear:
          lw_tcme,
          ls_e1tcmem.
      ls_e1tcmem                       = <fs_data>-sdata.
      move-corresponding ls_e1tcmem to lw_tcme.
      append lw_tcme to et_tcme.


*....Long text..........................................................
**....Charact...........................................................
    when c_segnam_textl.
      check ef_delete is initial.
      clear:
          ls_e1textl,
          ls_text.
      ls_e1textl                       = <fs_data>-sdata.
      write ls_e1textl-language_iso to ls_text-spras.
      ls_text-tdformat                 = ls_e1textl-tdformat.
      ls_text-tdline                   = ls_e1textl-tdline.
      append ls_text to ls_valtext-text.

**....Charact value.....................................................
    when c_segnam_txtl1.
      check ef_delete is initial.
      clear:
          ls_e1txtl1,
          ls_text.
      ls_e1txtl1                       = <fs_data>-sdata.
      if ls_valtext-value ne l_value.
        if not ls_valtext is initial.
          append ls_valtext to et_valtext.
          clear ls_valtext.
        endif.
        ls_valtext-value               = l_value.
      endif.
      write ls_e1txtl1-language_iso to ls_text-spras.
      ls_text-tdformat                 = ls_e1txtl1-tdformat.
      ls_text-tdline                   = ls_e1txtl1-tdline.
      append ls_text to ls_valtext-text.

  endcase.

endloop.


** Finish last long text.
if not ls_valtext is initial.
  append ls_valtext to et_valtext.
endif.


ENDFORM.                               " extract
