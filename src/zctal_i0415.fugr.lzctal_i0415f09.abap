*----------------------------------------------------------------------*
***INCLUDE LCTALF09 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  process_knowl
*&---------------------------------------------------------------------*
*....Delete all old depedency knowledge allocations.....................
**....Dependency knowledge allocations of charact.......................
**....Dependency knowledge allocations of values........................
*....Get data...........................................................
*....Set dependency knowledge allocations...............................
*----------------------------------------------------------------------*
FORM process_knowl
    USING
      i_instance                       type ref to cl_chr_main
      it_valalloc                      type tt_valalloc
      it_valbasic                      type tt_valbasic
      it_valdescr                      type tt_valdescr
      it_valdocu                       type tt_valdocu
      it_valsource                     type tt_valsource
    CHANGING
      ef_error                         type flag.


data:
    lt_value                           type tt_chr_value,
    lw_valbasic                        type line of tt_valbasic,
    lw_valdescr                        type line of tt_valdescr,
    lw_valdocu                         type line of tt_valdocu,
    lw_valsource                       type line of tt_valsource.

field-symbols:
    <fs_valalloc>                      type line of tt_valalloc,
    <fs_value>                         type line of tt_chr_value.


check  not it_valalloc[] is initial.

sort:
    it_valalloc  by value ascending,
    it_valbasic  by value ascending,
    it_valdescr  by value ascending,
    it_valdocu   by value ascending,
    it_valsource by value ascending.


*....Delete all old depedency knowledge allocations.....................
**....Dependency knowledge allocations of charact.......................
call method i_instance->remove_knowl
    exporting
*     i_value            =
*     i_allocation       =
      if_delete_all      = 'X'
    exceptions
      changeno_not_valid =  1
      deleted            =  2
      error_copying      =  3
      error_deleting     =  4
      error_reading      =  5
      foreign_lock       =  6
      namespace          =  7
      no_authority       =  8
      overwrite          =  9
      use_ecm            = 10
      value_not_found    = 11
      others             = 12.
if not sy-subrc is initial.
  ef_error = 'X'.
  exit.
endif.

**....Dependency knowledge allocations of values........................
** Determine all values with dependency knowledge allocations.
call method i_instance->provide
*   exporting
*     i_language     =
    importing
*     es_basic       =
*     et_table       =
*     et_descr       =
*     et_restr       =
      et_value       = lt_value
*     et_valuedescr  =
    exceptions
      internal_error = 1
      deleted        = 2
      no_authority   = 3
      others         = 4.
if not sy-subrc is initial.
  clear sy-subrc.
endif.

delete lt_value
    where has_knowl is initial.

** Delete dependency knowledge allocations.
loop at lt_value
    assigning <fs_value>.
  call method i_instance->remove_knowl
      exporting
        i_value            = <fs_value>-value
*       i_allocation       =
        if_delete_all      = 'X'
      exceptions
        changeno_not_valid =  1
        deleted            =  2
        error_copying      =  3
        error_deleting     =  4
        error_reading      =  5
        foreign_lock       =  6
        namespace          =  7
        no_authority       =  8
        overwrite          =  9
        use_ecm            = 10
        value_not_found    = 11
        others             = 12.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.
endloop.

if not ef_error is initial.
  exit.
endif.


loop at it_valalloc
    assigning <fs_valalloc>.


*....Get data...........................................................
  clear:
      lw_valbasic,
      lw_valdescr,
      lw_valdocu,
      lw_valsource.
  read table it_valbasic
      into lw_valbasic
      with key value = <fs_valalloc>-value
      binary search.
  read table it_valdescr
      into lw_valdescr
      with key value = <fs_valalloc>-value
      binary search.
  read table it_valdocu
      into lw_valdocu
      with key value = <fs_valalloc>-value
      binary search.
  read table it_valsource
      into lw_valsource
      with key value = <fs_valalloc>-value
      binary search.


*....Set dependency knowledge allocations...............................
** If the allocations belong to the charact itself VALUE is empty. Thus
** no different handling is needed here.
  call method i_instance->set_knowl
      exporting
        i_value            = <fs_valalloc>-value
        it_alloc           = <fs_valalloc>-alloc
        it_basic           = lw_valbasic-basic
        it_descr           = lw_valdescr-descr
        it_docu            = lw_valdocu-docu
        it_source          = lw_valsource-source
      exceptions
        changeno_not_valid =  1
        deleted            =  2
        error_copying      =  3
        error_maintaining  =  4
        error_reading      =  5
        foreign_lock       =  6
        namespace          =  7
        no_authority       =  8
        overwrite          =  9
        use_ecm            = 10
        value_not_found    = 11
        others             = 12.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

endloop.


ENDFORM.                               " process_knowl
