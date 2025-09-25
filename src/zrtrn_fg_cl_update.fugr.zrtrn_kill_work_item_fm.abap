*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  Rel 2
* REFERENCE NO: ED1K910707(Workbench) ;
* DEVELOPER:    AKHADIR (Khadir)
* DATE:         25-Jul-2019
* DESCRIPTION:  DM-2082 INC0244597 -- Credit Case Issue
*               Void/Delete case should reset the CL requested amount
*               and keep the existing Credit limit,
*               even if the WF as been initiated/triggered.
*               Issue/bug reported on requested credit limit
*               does not refresh properly and user has
*               to put 0.00 to reset the CL requested amount.
*----------------------------------------------------------------------*
FUNCTION zrtrn_kill_work_item_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_WI_ID) TYPE  SWW_WIID OPTIONAL
*"----------------------------------------------------------------------

  DATA: lv_status    TYPE swwwihead-wi_stat.

**  DATA: lv_exit_flag TYPE c.
**  DO.
**    IF lv_exit_flag IS NOT INITIAL.
**      EXIT.
**    ENDIF.
**  ENDDO.

**Note this FM has default commit in it
  CALL FUNCTION 'SWW_WI_ADMIN_CANCEL'
    EXPORTING
      wi_id                       = i_wi_id
    IMPORTING
      new_status                  = lv_status
    EXCEPTIONS
      update_failed               = 1
      no_authorization            = 2
      infeasible_state_transition = 3
      OTHERS                      = 4.
  IF sy-subrc <> 0.
** message
  ENDIF.



ENDFUNCTION.
