*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  Rel 2
* REFERENCE NO: ED1K910707(Workbench) ;
* DEVELOPER:    AKHADIR (Khadir)
* DATE:         25-Jul-2019
* DESCRIPTION:  INC0244597 -- Credit Case Issue
*               Void/Delete case should reset the CL requested amount
*               and keep the existing Credit limit,
*               even if the WF as been initiated/triggered.
*               Issue/bug reported on requested credit limit
*               does not refresh properly and user has
*               to put 0.00 to reset the CL requested amount.
*               This report purpose is to kill the work item.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZRTRR_KILL_WORK_ITEM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zrtrr_kill_work_item.

DATA: lv_status    TYPE swwwihead-wi_stat.

PARAMETERS: p_wrkitm TYPE sww_wiid. " Workflow Work item ID

START-OF-SELECTION.

  CALL FUNCTION 'SWW_WI_ADMIN_CANCEL'
    EXPORTING
      wi_id                       = p_wrkitm
    IMPORTING
      new_status                  = lv_status
    EXCEPTIONS
      update_failed               = 1
      no_authorization            = 2
      infeasible_state_transition = 3
      OTHERS                      = 4.
  IF sy-subrc = 0.
    MESSAGE s000(zptp_r1b) WITH
     'Successfully executed with new status'(001) lv_status.
  ELSEIF sy-subrc = 1.
    MESSAGE s000(zptp_r1b) WITH
     'Error Update failed'(002).
  ELSEIF sy-subrc = 2.
    MESSAGE s000(zptp_r1b) WITH
     'Error No Authorization'(003).
  ELSEIF sy-subrc = 3.
    MESSAGE s000(zptp_r1b) WITH
     'Error infeasible state transition'(004).
  ELSEIF sy-subrc = 4.
    MESSAGE s000(zptp_r1b) WITH
     'Error while terminating the workitem'(005).
  ENDIF.
