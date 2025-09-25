*----------------------------------------------------------------------*
***INCLUDE LCTALF12 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  delete
*&---------------------------------------------------------------------*
*....Get instance.......................................................
*....Execute deletion...................................................
*----------------------------------------------------------------------*
FORM delete
    USING
      i_charact                        type atnam
      i_changeno                       type aennr
    CHANGING
      ef_error                         type flag.


data:
    lcl_instance                       type ref to cl_chr_main.


*....Get instance.......................................................
call method cl_chr_main=>factory
    exporting
      i_charact            = i_charact
*     i_charact_id         =
*     i_class              =
*     i_class_type         =
      i_changeno           = i_changeno
*     i_changeno_date      =
*     i_language           =
    importing
      e_instance           = lcl_instance
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


*....Execute deletion...................................................
call method lcl_instance->delete
    exceptions
      changeno_not_valid = 1
      foreign_lock       = 2
      internal_error     = 3
      namespace          = 4
      no_authority       = 5
      usage              = 6
      use_ecm            = 7
      others             = 8.
if not sy-subrc is initial.
  ef_error = 'X'.
  exit.
endif.


ENDFORM.                               " delete
