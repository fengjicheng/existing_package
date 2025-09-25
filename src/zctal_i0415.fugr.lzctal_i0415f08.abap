*----------------------------------------------------------------------*
***INCLUDE LCTALF08 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  convert_value_to_ext
*&---------------------------------------------------------------------*
*....Match trivial conversion without FM-call...........................
*....Check buffer.......................................................
*....Process conversion.................................................
*----------------------------------------------------------------------*
FORM convert_value_to_ext
    USING
      is_cabn                          type line of tt_cabn
      is_cawn                          type line of tt_cawn
    CHANGING
      e_value                          type atwrt.


statics:
    scl_valueformat                    type ref to cl_cacl_valueformat,
    ss_format_int                      type ctcv_01.

data:
    lt_cawn                            type tt_cawn,
    lw_cawn                            type line of tt_cawn,
    ls_format_ext                      type line of tt_chr_format,
    ls_format_int                      type ctcv_01.


*....Match trivial conversion without FM-call...........................
if      is_cabn-atfor ne 'CURR'
    and is_cabn-atfor ne 'DATE'
    and is_cabn-atfor ne 'NUM'
    and is_cabn-atfor ne 'TIME'.
  e_value = is_cawn-atwrt.
  exit.
endif.

clear:
    e_value.


*....Check buffer.......................................................
move-corresponding is_cabn to ls_format_int.
ls_format_int-atint = 'X'.

** Compare input format to last one.
if ls_format_int ne ss_format_int.

  ss_format_int = ls_format_int.

** Convert format data to external format.
  call method cl_chr_conversion=>convert_format_to_ext
      exporting
        is_format_int = ls_format_int
      importing
        es_format_ext = ls_format_ext.

** Get an instance for value handling.
  call method cl_cacl_valueformat=>factory
      exporting
*       i_charact      =
*       i_charact_id   =
*       if_intervals   =
        is_format      = ls_format_ext
      importing
        e_instance     = scl_valueformat
      exceptions
        internal_error = 1
        wrong_input    = 2
        others         = 3.
  if not sy-subrc is initial.
    exit.
  endif.

endif.


*....Process conversion.................................................
clear lt_cawn[].
append is_cawn to lt_cawn.

call method scl_valueformat->convert_to_ext
    changing
      ct_cawn          = lt_cawn
    exceptions
      conversion_error = 1
      others           = 2.
if not sy-subrc is initial.
  exit.
endif.

read table lt_cawn
    into lw_cawn
    index 1.
e_value = lw_cawn-atwrt.


ENDFORM.                               " convert_value_to_ext
