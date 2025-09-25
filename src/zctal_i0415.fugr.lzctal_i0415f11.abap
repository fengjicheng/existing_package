*----------------------------------------------------------------------*
***INCLUDE LCTALF11 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  convert_knowl
*&---------------------------------------------------------------------*
*....Dependecy knowledge allocations of charact.........................
**....Allocation table..................................................
**....Store converted data..............................................
**....Basic data........................................................
**....Descriptions......................................................
**....Documentation.....................................................
**....Source............................................................
**....Store converted data..............................................
*....Dependecy knowledge allocations of value...........................
**....Store converted data..............................................
**....Allocation table..................................................
**....Basic data........................................................
**....Descriptions......................................................
**....Documentation.....................................................
**....Source............................................................
*----------------------------------------------------------------------*
FORM convert_knowl
    USING
      i_charact                        type atnam
      it_cukb1                         type tt_e1cukb1
      it_cukb2                         type tt_e1cukb2
      it_cukbm                         type tt_e1cukbm
      it_cukbt                         type tt_e1cukbt
      it_cukn1                         type tt_e1cukn1
      it_cuknm                         type tt_e1cuknm
      it_cutx1                         type tt_e1cutx1
      it_cutxm                         type tt_e1cutxm
    CHANGING
      et_valalloc                      type tt_valalloc
      et_valbasic                      type tt_valbasic
      et_valdescr                      type tt_valdescr
      et_valdocu                       type tt_valdocu
      et_valsource                     type tt_valsource.


data:
    lw_alloc                           type line of tt_rcuob1,
    lw_basic                           type line of tt_rcukb1,
    lw_descr                           type line of tt_rcukbt1,
    lw_docu                            type line of tt_rcukdoc1,
    lw_source                          type line of tt_rcukn1,
    lw_valalloc                        type line of tt_valalloc,
    lw_valbasic                        type line of tt_valbasic,
    lw_valdescr                        type line of tt_valdescr,
    lw_valdocu                         type line of tt_valdocu,
    lw_valsource                       type line of tt_valsource,
    l_value                            type atwrt.

field-symbols:
    <fs_cukb1>                         type line of tt_e1cukb1,
    <fs_cukb2>                         type line of tt_e1cukb2,
    <fs_cukbm>                         type line of tt_e1cukbm,
    <fs_cukbt>                         type line of tt_e1cukbt,
    <fs_cukn1>                         type line of tt_e1cukn1,
    <fs_cuknm>                         type line of tt_e1cuknm,
    <fs_cutx1>                         type line of tt_e1cutx1,
    <fs_cutxm>                         type line of tt_e1cutxm.


*....Dependecy knowledge allocations of charact.........................
clear lw_valalloc.

loop at it_cukbm
    assigning <fs_cukbm>.

**....Allocation table..................................................
  clear lw_alloc.
  if <fs_cukbm>-e1cukbm-dep_intern co c_numeric.
    lw_alloc-xknnam                    = <fs_cukbm>-e1cukbm-dep_intern.
  else.
    lw_alloc-knnam                     = <fs_cukbm>-e1cukbm-dep_intern.
  endif.
  lw_alloc-knsrt                       = <fs_cukbm>-e1cukbm-dep_lineno.
  append lw_alloc to lw_valalloc-alloc.

** In case of a global dependency nothing more is needed.
  if <fs_cukbm>-e1cukbm-dep_intern cn c_numeric.

**....Store converted data..............................................
      append lw_valalloc to et_valalloc.
      clear lw_valalloc.
      if not lw_valbasic is initial.
        append lw_valbasic to et_valbasic.
        clear lw_valbasic.
      endif.
      if not lw_valdescr is initial.
        append lw_valdescr to et_valdescr.
        clear lw_valdescr.
      endif.
      if not lw_valdocu is initial.
        append lw_valdocu to et_valdocu.
        clear lw_valdocu.
      endif.
      if not lw_valsource is initial.
        append lw_valsource to et_Valsource.
        clear lw_valsource.
      endif.

      continue.

    endif.

**....Basic data........................................................
  clear lw_basic.
  lw_basic-xknnam                      = <fs_cukbm>-e1cukbm-dep_intern.
  lw_basic-knart                       = <fs_cukbm>-e1cukbm-dep_type.
  lw_basic-knsta                       = <fs_cukbm>-e1cukbm-status.
  lw_basic-kngrp                       = <fs_cukbm>-e1cukbm-group.
  lw_basic-knbeo                       = <fs_cukbm>-e1cukbm-whr_to_use.
  CALL FUNCTION 'DEPENDENCY_GET_INT_TYPE'
      EXPORTING
        DEPENDENCY_TYPE_EXT            = <fs_cukbm>-e1cukbm-dep_type
      IMPORTING
        DEPENDENCY_TYPE_INT            = lw_basic-knart
      EXCEPTIONS
        DEP_TYPE_INVALID               = 1
        OTHERS                         = 2.
  if not sy-subrc is initial.
    clear sy-subrc.
  endif.
  append lw_basic to lw_valbasic-basic.

**....Descriptions......................................................
  loop at it_cukbt
      assigning <fs_cukbt>
      where charact    eq i_charact
        and dep_intern eq <fs_cukbm>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukbm>-e1cukbm-dep_extern.
    clear lw_descr.
    lw_descr-xknnam                    = <fs_cukbt>-dep_intern.
    lw_descr-langu                     = <fs_cukbt>-e1cukbt-language.
    lw_descr-knktxt                    = <fs_cukbt>-e1cukbt-descript.
    append lw_descr to lw_valdescr-descr.
  endloop.

**....Documentation.....................................................
  loop at it_cutxm
      assigning <fs_cutxm>
      where charact    eq i_charact
        and dep_intern eq <fs_cukbm>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukbm>-e1cukbm-dep_extern.
    clear lw_docu.
    lw_docu-xknnam                     = <fs_cutxm>-dep_intern.
    lw_docu-line_no                    = sy-tabix.
    lw_docu-langu                      = <fs_cutxm>-e1cutxm-language.
    lw_docu-format                     = <fs_cutxm>-e1cutxm-txt_form.
    lw_docu-line                       = <fs_cutxm>-e1cutxm-txt_line.
    append lw_docu to lw_valdocu-docu.
  endloop.

**....Source............................................................
  loop at it_cuknm
      assigning <fs_cuknm>
      where charact    eq i_charact
        and dep_intern eq <fs_cukbm>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukbm>-e1cukbm-dep_extern.
    clear lw_source.
    lw_source-xknnam                   = <fs_cuknm>-dep_intern.
    lw_source-line_no                  = sy-tabix.
    lw_source-line                     = <fs_cuknm>-e1cuknm-line.
    append lw_source to lw_valsource-source.
  endloop.

**....Store converted data..............................................
  append lw_valalloc to et_valalloc.
  clear lw_valalloc.
  if not lw_valbasic is initial.
    append lw_valbasic to et_valbasic.
    clear lw_valbasic.
  endif.
  if not lw_valdescr is initial.
    append lw_valdescr to et_valdescr.
    clear lw_valdescr.
  endif.
  if not lw_valdocu is initial.
    append lw_valdocu to et_valdocu.
    clear lw_valdocu.
  endif.
  if not lw_valsource is initial.
    append lw_valsource to et_Valsource.
    clear lw_valsource.
  endif.

endloop.


*....Dependecy knowledge allocations of value...........................
loop at it_cukb1
    assigning <fs_cukb1>.

**....Store converted data..............................................
  if l_value is initial.
    l_value = <fs_cukb1>-value.
  endif.

  if <fs_cukb1>-value ne l_value.
    l_value = <fs_cukb1>-value.
    append lw_valalloc to et_valalloc.
    clear lw_valalloc.
    if not lw_valbasic is initial.
      append lw_valbasic to et_valbasic.
      clear lw_valbasic.
    endif.
    if not lw_valdescr is initial.
      append lw_valdescr to et_valdescr.
      clear lw_valdescr.
    endif.
    if not lw_valdocu is initial.
      append lw_valdocu to et_valdocu.
      clear lw_valdocu.
    endif.
    if not lw_valsource is initial.
      append lw_valsource to et_Valsource.
      clear lw_valsource.
    endif.
  endif.

**....Allocation table..................................................
  lw_valalloc-value                    = <fs_cukb1>-value.
  clear lw_alloc.
  if <fs_cukb1>-e1cukbm-dep_intern co c_numeric.
    lw_alloc-xknnam                    = <fs_cukb1>-e1cukbm-dep_intern.
  else.
    lw_alloc-knnam                     = <fs_cukb1>-e1cukbm-dep_intern.
  endif.
  lw_alloc-knsrt                       = <fs_cukb1>-e1cukbm-dep_lineno.
  append lw_alloc to lw_valalloc-alloc.

** In case of a global dependency nothing more is needed.
  if <fs_cukb1>-e1cukbm-dep_intern cn c_numeric.
    continue.
  endif.

**....Basic data........................................................
  lw_valbasic-value                    = <fs_cukb1>-value.
  clear lw_basic.
  lw_basic-xknnam                      = <fs_cukb1>-e1cukbm-dep_intern.
  lw_basic-knart                       = <fs_cukb1>-e1cukbm-dep_type.
  lw_basic-knsta                       = <fs_cukb1>-e1cukbm-status.
  lw_basic-kngrp                       = <fs_cukb1>-e1cukbm-group.
  lw_basic-knbeo                       = <fs_cukb1>-e1cukbm-whr_to_use.
  CALL FUNCTION 'DEPENDENCY_GET_INT_TYPE'
      EXPORTING
        DEPENDENCY_TYPE_EXT            = <fs_cukb1>-e1cukbm-dep_type
      IMPORTING
        DEPENDENCY_TYPE_INT            = lw_basic-knart
      EXCEPTIONS
        DEP_TYPE_INVALID               = 1
        OTHERS                         = 2.
  if not sy-subrc is initial.
    clear sy-subrc.
  endif.
  append lw_basic to lw_valbasic-basic.

**....Descriptions......................................................
  lw_valdescr-value                    = <fs_cukb1>-value.
  loop at it_cukb2
      assigning <fs_cukb2>
      where charact    eq i_charact
        and value      eq <fs_cukb1>-value
        and dep_intern eq <fs_cukb1>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukb1>-e1cukbm-dep_extern.
    clear lw_descr.
    lw_descr-xknnam                    = <fs_cukb2>-dep_intern.
    lw_descr-langu                     = <fs_cukb2>-e1cukbt-language.
    lw_descr-knktxt                    = <fs_cukb2>-e1cukbt-descript.
    append lw_descr to lw_valdescr-descr.
  endloop.

**....Documentation.....................................................
  lw_valdocu-value                     = <fs_cukb1>-value.
  loop at it_cutx1
      assigning <fs_cutx1>
      where charact    eq i_charact
        and value      eq <fs_cukb1>-value
        and dep_intern eq <fs_cukb1>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukb1>-e1cukbm-dep_extern.
    clear lw_docu.
    lw_docu-xknnam                     = <fs_cutx1>-dep_intern.
    lw_docu-line_no                    = sy-tabix.
    lw_docu-langu                      = <fs_cutx1>-e1cutxm-language.
    lw_docu-format                     = <fs_cutx1>-e1cutxm-txt_form.
    lw_docu-line                       = <fs_cutx1>-e1cutxm-txt_line.
    append lw_docu to lw_valdocu-docu.
  endloop.

**....Source............................................................
  lw_valsource-value                   = <fs_cukb1>-value.
  loop at it_cukn1
      assigning <fs_cukn1>
      where charact    eq i_charact
        and value      eq <fs_cukb1>-value
        and dep_intern eq <fs_cukb1>-e1cukbm-dep_intern
        and dep_extern eq <fs_cukb1>-e1cukbm-dep_extern.
    clear lw_source.
    lw_source-xknnam                   = <fs_cukn1>-dep_intern.
    lw_source-line_no                  = sy-tabix.
    lw_source-line                     = <fs_cukn1>-e1cuknm-line.
    append lw_source to lw_valsource-source.
  endloop.

endloop.

** Store last data.
if not lw_valalloc-alloc[] is initial.
  append lw_valalloc to et_valalloc.
endif.
if not lw_valbasic is initial.
  append lw_valbasic to et_valbasic.
endif.
if not lw_valdescr is initial.
  append lw_valdescr to et_valdescr.
endif.
if not lw_valdocu is initial.
  append lw_valdocu to et_valdocu.
endif.
if not lw_valsource is initial.
  append lw_valsource to et_Valsource.
endif.


ENDFORM.                               " convert_knowl
