*----------------------------------------------------------------------*
***INCLUDE LCTALF06 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  post_on_commit
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM post_on_commit .


field-symbols:
    <fs_inst>                          type line of tt_inst.


sort gt_inst.
delete adjacent duplicates from gt_inst.

loop at gt_inst
    assigning <fs_inst>.
  call method <fs_inst>-inst->post.
endloop.

clear gt_inst[].


ENDFORM.                               " post_on_commit
