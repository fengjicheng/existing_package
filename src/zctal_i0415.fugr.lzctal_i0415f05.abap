*----------------------------------------------------------------------*
***INCLUDE LCTALF05 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  finish
*&---------------------------------------------------------------------*
*....Set status.........................................................
*....Handle workflow....................................................
*....Handle changes on charact..........................................
*....Set success message................................................
*....Save log...........................................................
*----------------------------------------------------------------------*
FORM finish
    TABLES
      ct_idoc_status                   structure bdidocstat
      ct_return_variables              structure bdwfretvar
    USING
      is_idoc_control                  type edidc
      i_instance                       type ref to cl_chr_main
      if_create                        type flag
      if_error                         type flag
      if_error_knowl                   type flag
    CHANGING
      e_workflow_result                type wf_result.


data:
    lw_idoc_status                     type bdidocstat,
    lw_inst                            type line of tt_inst,
    lw_return_variables                type bdwfretvar.


*....Set status.........................................................
lw_idoc_status-docnum                  = is_idoc_control-docnum.
** No error.
if      if_error       is initial
    and if_error_knowl is initial.
  lw_idoc_status-status                = c_idoc_ok.
** Error.
else.
  lw_idoc_status-status                = c_idoc_nok.
  lw_idoc_status-msgid                 = 'C1'.
  lw_idoc_status-msgty                 = 'E'.
  lw_idoc_status-msgno                 = '149'.
endif.
append lw_idoc_status to ct_idoc_status.


*....Handle workflow....................................................
lw_return_variables-doc_number         = is_idoc_control-docnum.
** No error.
if      if_error       is initial
    and if_error_knowl is initial.
  lw_return_variables-wf_param         = 'Processed_IDOCs'.
  e_workflow_result                    = '0'.
** Error.
else.
  lw_return_variables-wf_param         = 'Error_IDOCs'.
  e_workflow_result                    = '99999'.
endif.
append lw_return_variables to ct_return_variables.


*....Handle changes on charact..........................................
** The canges are saved even if an error on dependency knowledge allo-
** cation occured in order to avoid dead locks (dependencies may use
** characts as well...).
** No error: Prepare posting of changes.
if if_error is initial.
  lw_inst-inst = i_instance.
  append lw_inst to gt_inst.
  perform post_on_commit on commit.
** Error: If instance had been created initialize it.
else.
  if i_instance is bound.
    call method i_instance->init.
  endif.
endif.


*....Set success message................................................
if if_error is initial.
  if if_create is initial.
    call method cl_cacl_message=>set_message
        exporting
          i_type   = 'S'
          i_class  = 'C1'
          i_number = '022'.
*         i_v1     =
*         i_v2     =
*         i_v3     =
*         i_v4     =
  else.
    call method cl_cacl_message=>set_message
        exporting
          i_type   = 'S'
          i_class  = 'C1'
          i_number = '021'.
*         i_v1     =
*         i_v2     =
*         i_v3     =
*         i_v4     =
  endif.
endif.


*....Save log...........................................................
call method cl_cacl_message=>save.


ENDFORM.                               " finish
