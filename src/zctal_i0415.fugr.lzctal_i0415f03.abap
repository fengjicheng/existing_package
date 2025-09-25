*----------------------------------------------------------------------*
***INCLUDE LCTALF03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  convert
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM convert
    USING
      is_cabn                          type line of tt_cabn
      it_cabnt                         type tt_cabnt
      it_cabnz                         type tt_cabnz
      it_cawn                          type tt_cawn
      it_cawnt                         type tt_cawnt
      it_tcme                          type tt_tcme
    CHANGING
      es_basic                         type chr_basic
      et_table                         type tt_chr_table
      et_descr                         type tt_chr_descr
      et_restr                         type tt_chr_restr
      et_value                         type tt_chr_value
      et_valuedescr                    type tt_chr_valuedescr
      ef_error                         type flag.


data:
    ls_cabn                            type line of tt_cabn,
    lt_cabnt                           type tt_cabnt,
    lw_cabnt                           type line of tt_cabnt,
    lt_cabnz                           type tt_cabnz,
    lw_cabnz                           type line of tt_cabnz,
    lt_cawn                            type tt_cawn,
    lw_cawn                            type line of tt_cawn,
    lt_cawnt                           type tt_cawnt,
    lw_cawnt                           type line of tt_cawnt,
    lt_tcme                            type tt_tcme,
    lw_tcme                            type line of tt_tcme.


** Dummy ATINN for conversion.
ls_cabn    = is_cabn.
lt_cabnt[] = it_cabnt[].
lt_cabnz[] = it_cabnz[].
lt_cawn[]  = it_cawn[].
lt_cawnt[] = it_cawnt[].
lt_tcme[]  = it_tcme[].

ls_cabn-atinn = '9999999999'.
lw_cabnt-atinn = ls_cabn-atinn.
modify lt_cabnt
    from lw_cabnt
    transporting atinn
    where atinn ne ls_cabn-atinn.
lw_cabnz-atinn = ls_cabn-atinn.
modify lt_cabnz
    from lw_cabnz
    transporting atinn
    where atinn ne ls_cabn-atinn.
lw_cawn-atinn = ls_cabn-atinn.
modify lt_cawn
    from lw_cawn
    transporting atinn
    where atinn ne ls_cabn-atinn.
lw_cawnt-atinn = ls_cabn-atinn.
modify lt_cawnt
    from lw_cawnt
    transporting atinn
    where atinn ne ls_cabn-atinn.
lw_tcme-atinn = ls_cabn-atinn.
modify lt_tcme
    from lw_tcme
    transporting atinn
    where atinn ne ls_cabn-atinn.

call method cl_chr_conversion=>convert_all_to_ext
    exporting
      is_cabn          = ls_cabn
*     is_cabn_org      =
      it_cabnz         = lt_cabnz
      it_cabnt         = lt_cabnt
      it_cawn          = lt_cawn
      it_cawnt         = lt_cawnt
      it_tcme          = lt_tcme
    importing
      es_basic         = es_basic
*     es_knowl         =
      et_table         = et_table
      et_descr         = et_descr
      et_restr         = et_restr
      et_value         = et_value
      et_valuedescr    = et_valuedescr
*     et_valueknowl    =
*     et_valuetext     =
    exceptions
      conversion_error = 1
      wrong_input      = 2
      others           = 3.
if not sy-subrc is initial.
  ef_error = 'X'.
  exit.
endif.


ENDFORM.                               " convert
