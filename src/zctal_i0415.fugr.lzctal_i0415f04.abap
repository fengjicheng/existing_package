*----------------------------------------------------------------------*
***INCLUDE LCTALF04 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  process
*&---------------------------------------------------------------------*
*....Check existence....................................................
*....Create charact.....................................................
*....Change charact.....................................................
**....Get instance......................................................
**....Execute change....................................................
*....Long text..........................................................
**....Delete all old longtexts..........................................
***....Longtexts of charact.............................................
***....Longtexts of values..............................................
**....Set new longtexts.................................................
*----------------------------------------------------------------------*
FORM process
    USING
      i_charact                        type atnam
      i_changeno                       type aennr
      is_basic                         type chr_basic
      it_table                         type tt_chr_table
      it_descr                         type tt_chr_descr
      it_restr                         type tt_chr_restr
      it_value                         type tt_chr_value
      it_valuedescr                    type tt_chr_valuedescr
      it_valtext                       type tt_valtext
    CHANGING
      e_instance                       type ref to cl_chr_main
      ef_create                        type flag
      ef_error                         type flag.


data:
    lt_value                           type tt_chr_value.

field-symbols:
    <fs_valtext>                       type line of tt_valtext,
    <fs_value>                         type line of tt_chr_value.


*....Check existence....................................................
call method cl_chr_main=>existence_check
    exporting
      i_charact         = i_charact
*     i_charact_id      =
*     i_class           =
*     i_class_type      =
      i_changeno        = i_changeno
*     i_chagneno_date   =
*   importing
*     e_caharact        =
*     e_caharact_id     =
*     ef_overwrite      =
    exceptions
      charact_not_found = 1
      no_authority      = 2
      wrong_input       = 3.

case sy-subrc.
  when 0.
  when 1.
    ef_create = 'X'.
  when others.
    ef_error = 'X'.
    exit.
endcase.


*....Create charact.....................................................
if not ef_create is initial.

  call method cl_chr_main=>create
      exporting
        i_charact            = i_charact
*       i_class              =
*       i_class_type         =
        i_changeno           = i_changeno
        is_basic             = is_basic
        it_table             = it_table
        it_descr             = it_descr
        it_restr             = it_restr
        it_value             = it_value
        it_valuedescr        = it_valuedescr
      importing
        e_instance           = e_instance
      exceptions
        changeno_not_found   =  1
        changeno_not_valid   =  2
        check_error          =  3
        exists_already       =  4
        foreign_lock         =  5
        internal_error       =  6
        invalid_name         =  7
        key_error            =  8
        namespace            =  9
        no_authority         = 10
        use_ecm              = 11
        wrong_input          = 12
        class_initialization = 13
        others               = 14.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

*....Change charact.....................................................
else.

**....Get instance......................................................
  call method cl_chr_main=>factory
      exporting
        i_charact            = i_charact
*       i_charact_id         =
*       i_class              =
*       i_class_type         =
        i_changeno           = i_changeno
*       i_changeno_date      =
*       i_language           =
      importing
        e_instance           = e_instance
      exceptions
        changeno_not_found   =  1
        charact_not_found    =  2
        class_initialization =  3
        internal_error       =  4
        foreign_lock         =  5
        no_authority         =  6
        providing_error      =  7
        validity_error       =  8
        wrong_input          =  9
        others               = 10.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

**....Execute change....................................................
  call method e_instance->change
      exporting
        is_basic            = is_basic
        it_table            = it_table
        it_descr            = it_descr
        it_restr            = it_restr
        it_value            = it_value
        it_valuedescr       = it_valuedescr
*       if_del_value_anyway =
      exceptions
        check_error         = 1
        deleted             = 2
        internal_error      = 3
        changeno_not_valid  = 4
        foreign_lock        = 5
        namespace           = 6
        no_authority        = 7
        use_ecm             = 8
        others              = 9.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

endif.


*....Long text..........................................................
**....Delete all old longtexts..........................................
if ef_create is initial.

***....Longtexts of charact.............................................
  call method e_instance->remove_longtext
*     exporting
*       i_value            =
*       i_language         =
      exceptions
        changeno_not_valid =  1
        deleted            =  2
        foreign_lock       =  3
        namespace          =  4
        no_authority       =  5
        overwrite          =  6
        text_error         =  7
        use_ecm            =  8
        value_not_found    =  9
        others             = 10.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

***....Longtexts of values..............................................
** Determine all values with dependency knowledge allocations.
  call method e_instance->provide
*     exporting
*       i_language     =
      importing
*       es_basic       =
*       et_table       =
*       et_descr       =
*       et_restr       =
        et_value       = lt_value
*       et_valuedescr  =
      exceptions
        internal_error = 1
        deleted        = 2
        no_authority   = 3
        others         = 4.
  if not sy-subrc is initial.
    clear sy-subrc.
  endif.

  delete lt_value
      where has_text is initial.

** Delete long texts.
  loop at lt_value
      assigning <fs_value>.
    call method e_instance->remove_longtext
        exporting
          i_value            = <fs_value>-value
*         i_language         =
        exceptions
          changeno_not_valid =  1
          deleted            =  2
          foreign_lock       =  3
          namespace          =  4
          no_authority       =  5
          overwrite          =  6
          text_error         =  7
          use_ecm            =  8
          value_not_found    =  9
          others             = 10.
    if not sy-subrc is initial.
      ef_error = 'X'.
      exit.
    endif.
  endloop.

  if not ef_error is initial.
    exit.
  endif.

endif.

**....Set new longtexts.................................................
loop at it_valtext
    assigning <fs_valtext>.

  call method e_instance->set_longtext
      exporting
        i_value            = <fs_valtext>-value
        it_text            = <fs_valtext>-text
      exceptions
        changeno_not_valid =  1
        deleted            =  2
        foreign_lock       =  3
        namespace          =  4
        no_authority       =  5
        overwrite          =  6
        text_error         =  7
        text_missing       =  8
        use_ecm            =  9
        value_not_found    = 10
        others             = 11.
  if not sy-subrc is initial.
    ef_error = 'X'.
    exit.
  endif.

endloop.

if not ef_error is initial.
  exit.
endif.


ENDFORM.                               " process
