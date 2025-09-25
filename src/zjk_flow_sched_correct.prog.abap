*&---------------------------------------------------------------------*
*& Report  ZJK_FLOW_SCHED_CORRECT
*&
*&---------------------------------------------------------------------*
*& Find/Fix data inconsistencies between JKSEFLOW and VBAP/JKSESCHED
*& because some VBAP items were not created via JKSEORDER01 (Report
*& RJKSEORDERGEN) although JKSEFLOW entry exists.
*& A corresponding JKSESCHED entry with field XORDGER_CREATED = 'X'
*& exists also. This is an inconsisteny too.
*&
*& If testrun = 'X' only analysis no update on database.
*& If testrun = ' ' fixing data in two steps.
*&  Step 1-> Deletion of incorrect JHSEFLWOW entry.
*&  Step 2-> Set field field XORDGER_CREATED to SPACE in corresponding
*&           JKSESCHED entry.
*&---------------------------------------------------------------------*

REPORT  ZJK_FLOW_SCHED_CORRECT.

selection-screen begin of block dateframe with frame.
parameter shipfrom like jkseflow-shipping_date default sy-datum.
parameter shipto   like jkseflow-shipping_date default '99991231'.
selection-screen end   of block dateframe.

parameter testrun as checkbox default 'X'.

* Type for selecting data inconsistencies
types: BEGIN OF ty_missing_vbap,
         contract_vbeln type jkseflow-contract_vbeln,
         contract_posnr type jkseflow-contract_posnr,
         flow_vbeln type vbap-vbeln,
         flow_posnr type vbap-posnr,
         nip   type jkseflow-nip,
         vbeln      type vbap-vbeln,
         posnr      type vbap-posnr,
      END of ty_missing_vbap.

data: ls_missing_vbap type ty_missing_vbap.
data: lt_missing_vbap type table of ty_missing_vbap.
data: lv_missing_items type i.

* avoid initial value
if shipfrom is initial.
  shipfrom = sy-datum.
endif.

* avoid initial value
if shipto is initial.
  shipto = '99991231'.
endif.

* Select via outer join to find out the inconsistencies
select flow~contract_vbeln flow~contract_posnr flow~vbelnorder flow~posnrorder flow~nip ap~vbeln ap~posnr
  from jkseflow as flow
    left outer join vbap as ap on flow~vbelnorder = ap~vbeln
                              and flow~posnrorder = ap~posnr
  into table lt_missing_vbap
  where flow~shipping_date between shipfrom and shipto.

* delete the consistent entries to take later care about the
* inconsistencies.
delete lt_missing_vbap where vbeln is not initial.
sort lt_missing_vbap by flow_vbeln flow_posnr.
describe table lt_missing_vbap lines lv_missing_items.

write: / 'Report started on', sy-datum, sy-uzeit.
write: /.

case lv_missing_items.
  when 0.
    write: / 'No data inconsitencies detected'.
    exit.
  when 1.
    write: / lv_missing_items, 'Order item was not created'.
  when others.
    write: / lv_missing_items, 'Order items were not created'.
endcase.

write: /.
write: /'Not existing order items in VBAP'.
write: 'with JKSEFLOW-SHIPPING_DATE between', shipfrom, 'and', shipto.
write: /.
write: /'Order', 12 'Item'.
loop at lt_missing_vbap into ls_missing_vbap.
  write: / ls_missing_vbap-flow_vbeln, ls_missing_vbap-flow_posnr.
  if testrun is initial.
    delete from JKSEFLOW
          where nip            = ls_missing_vbap-nip
            and CONTRACT_VBELN = ls_missing_vbap-contract_vbeln
            and CONTRACT_POSNR = ls_missing_vbap-contract_posnr
            and VBELNORDER     = ls_missing_vbap-flow_vbeln
            and POSNRORDER     = ls_missing_vbap-flow_posnr.
   if sy-subrc = 0.
      write: 'JKSEFLOW fixed'.
      update JKSESCHED set xorder_created = space
        where nip = ls_missing_vbap-nip
        and VBELN = ls_missing_vbap-contract_vbeln
        and POSNR = ls_missing_vbap-contract_posnr.
      if sy-subrc = 0.
        write 'JKSESCHED fixed'.
      endif.
    endif.
  endif.
endloop.

if testrun is initial.
  commit work.
endif.

write: /.
write: / 'Report finished on', sy-datum, sy-uzeit.
