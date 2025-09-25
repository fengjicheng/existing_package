*----------------------------------------------------------------------*
***INCLUDE LCTALF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  start
*&---------------------------------------------------------------------*
*....Check message type.................................................
*....Special logic for UPS..............................................
*....Set ALE flag.......................................................
*....Initialize log.....................................................
*----------------------------------------------------------------------*
FORM start
    TABLES
      it_idoc_data                     structure edidd
      it_idoc_status                   structure bdidocstat
    USING
      is_idoc_control                  type edidc
    CHANGING
      e_update_task                    type updatetask
      ef_error                         type flag.


data:
    l_lognumber                        type balnrext.


*....Check message type.................................................
if is_idoc_control-mestyp ne c_mestyp.
  raise wrong_function_called.
endif.

e_update_task = 'X'.


*....Special logic for UPS..............................................
CALL FUNCTION 'OPEN_FI_PERFORM_CHR00200_E'
  EXPORTING
    IDOC_HEADER             = is_idoc_control
    FLG_APPEND_STATUS       = 'X'
  TABLES
    IDOC_DATA               = it_idoc_data
    IDOC_STATUS             = it_idoc_status
  EXCEPTIONS
    ERROR                   = 1
    OTHERS                  = 2.
if not sy-subrc is initial.
  ef_error = 'X'.
  exit.
endif.


*....Set ALE flag.......................................................
call method cl_cacl_control=>set_control_flags
    exporting
      if_ale  = 'X'.
*     if_bapi =


*....Initialize log.....................................................
l_lognumber = is_idoc_control-docnum.
call method cl_cacl_message=>init
    exporting
      i_lognumber  = l_lognumber.


ENDFORM.                               " start
