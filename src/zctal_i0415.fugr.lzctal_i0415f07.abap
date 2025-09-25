*----------------------------------------------------------------------*
***INCLUDE LCTALF07 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  idoc_input_chrmas
*&---------------------------------------------------------------------*
*....Initialization.....................................................
*....Data extraction....................................................
*....Write start-message................................................
*....Deletion of charact................................................
*....Data conversion....................................................
*....Data Processing....................................................
**....Charact data and long texts.......................................
**....Dependency knowledge allocation...................................
*....Report and save....................................................
*----------------------------------------------------------------------*
FORM idoc_input_chrmas
    TABLES
      idoc_contrl                      structure edidc
      idoc_data                        structure edidd
      idoc_status                      structure bdidocstat
      return_variables                 structure bdwfretvar
      serialization_info               structure bdi_ser   "#EC *
    USING
      input_method                     type inputmethd     "#EC *
      mass_processing                  type mass_proc      "#EC *
    CHANGING
      workflow_result                  type wf_result
      application_variable             type appl_var
      in_update_task                   type updatetask
      call_transaction_done            type calltrans2.


data:
    lcl_instance                       type ref to cl_chr_main,
    ls_basic                           type chr_basic,
    ls_cabn                            type line of tt_cabn,
    lt_cabnt                           type tt_cabnt,
    lt_cabnz                           type tt_cabnz,
    lt_cawn                            type tt_cawn,
    lt_cawnt                           type tt_cawnt,
    lt_cukb1                           type tt_e1cukb1,
    lt_cukb2                           type tt_e1cukb2,
    lt_cukbm                           type tt_e1cukbm,
    lt_cukbt                           type tt_e1cukbt,
    lt_cukn1                           type tt_e1cukn1,
    lt_cuknm                           type tt_e1cuknm,
    lt_cutx1                           type tt_e1cutx1,
    lt_cutxm                           type tt_e1cutxm,
    lt_descr                           type tt_chr_descr,
    ls_e1datem                         type e1datem,
    lt_restr                           type tt_chr_restr,
    lt_table                           type tt_chr_table,
    lt_tcme                            type tt_tcme,
    lt_valalloc                        type tt_valalloc,
    lt_valbasic                        type tt_valbasic,
    lt_valdescr                        type tt_valdescr,
    lt_valdocu                         type tt_valdocu,
    lt_valsource                       type tt_valsource,
    lt_valtext                         type tt_valtext,
    lt_value                           type tt_chr_value,
    lt_valuedescr                      type tt_chr_valuedescr,
    l_msgv1                            type symsgv,
    lf_create                          type flag,
    lf_delete                          type flag,
    lf_error                           type flag,
    lf_error_knowl                     type flag.

field-symbols:
    <fs_idoc_control>                  type edidc.


loop at idoc_contrl
    assigning <fs_idoc_control>.


*....Initialization.....................................................
  perform start
      tables
        idoc_data
        idoc_status
      using
        <fs_idoc_control>
      changing
        in_update_task
        lf_error.

  application_variable  = space.
  call_transaction_done = space.


*....Data extraction....................................................
  if lf_error is initial.
    perform extract
        tables
          idoc_data
        using
          <fs_idoc_control>
        changing
          ls_e1datem
          ls_cabn
          lt_cabnt
          lt_cabnz
          lt_cawn
          lt_cawnt
          lt_tcme
          lt_cukb1
          lt_cukb2
          lt_cukbm
          lt_cukbt
          lt_cukn1
          lt_cuknm
          lt_cutx1
          lt_cutxm
          lt_valtext
          lf_delete.
    if not lf_error is initial.
      call method cl_cacl_message=>set_message
          exporting
            i_type   = 'E'
            i_class  = 'C1'
            i_number = '061'.
*           i_v1     =
*           i_v2     =
*           i_v3     =
*           i_v4     =
    endif.
  endif.


*....Write start-message................................................
** The start message can't be written before now (although the first
** error may already have occured) because the charact name isn't
** available sooner.
  l_msgv1 = ls_cabn-atnam.
  call method cl_cacl_message=>set_message
      exporting
        i_type   = 'S'
        i_class  = 'C1'
        i_number = '505'
        i_v1     = l_msgv1.
*       i_v2     =
*       i_v3     =
*       i_v4     =


*....Deletion of charact................................................
  if lf_error is initial.
    if not lf_delete is initial.
      perform delete
          using
            ls_cabn-atnam
            ls_e1datem-aennr
          changing
            lf_error.
      perform finish
          tables
            idoc_status
            return_variables
          using
            <fs_idoc_control>
            lcl_instance
            lf_create
            lf_error
            lf_error_knowl
          changing
            workflow_result.
      exit.
    endif.
  endif.


*....Data conversion....................................................
  if lf_error is initial.
    perform convert
        using
          ls_cabn
          lt_cabnt
          lt_cabnz
          lt_cawn
          lt_cawnt
          lt_tcme
        changing
          ls_basic
          lt_table
          lt_descr
          lt_restr
          lt_value
          lt_valuedescr
          lf_error.
    if not lf_error is initial.
      call method cl_cacl_message=>set_message
          exporting
            i_type   = 'E'
            i_class  = 'C1'
            i_number = '061'.
*           i_v1     =
*           i_v2     =
*           i_v3     =
*           i_v4     =
    endif.
  endif.

  if lf_error is initial.
    perform convert_knowl
        using
          ls_cabn-atnam
          lt_cukb1
          lt_cukb2
          lt_cukbm
          lt_cukbt
          lt_cukn1
          lt_cuknm
          lt_cutx1
          lt_cutxm
        changing
          lt_valalloc
          lt_valbasic
          lt_valdescr
          lt_valdocu
          lt_valsource.
  endif.


*....Data Processing....................................................
**....Charact data and long texts.......................................
  if lf_error is initial.
    perform process
        using
          ls_cabn-atnam
          ls_e1datem-aennr
          ls_basic
          lt_table
          lt_descr
          lt_restr
          lt_value
          lt_valuedescr
          lt_valtext
        changing
          lcl_instance
          lf_create
          lf_error.
  endif.

**....Dependency knowledge allocation...................................
  if      lf_error       is initial
      and lf_error_knowl is initial.
    perform process_knowl
        using
          lcl_instance
          lt_valalloc
          lt_valbasic
          lt_valdescr
          lt_valdocu
          lt_valsource
        changing
          lf_error_knowl.
  endif.


*....Report and save....................................................
  perform finish
      tables
        idoc_status
        return_variables
      using
        <fs_idoc_control>
        lcl_instance
        lf_create
        lf_error
        lf_error_knowl
      changing
        workflow_result.


endloop.


ENDFORM.                               " idoc_input_chrmas
