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
FUNCTION zrtrn_modif_cr_value_update.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_CASE_ID) TYPE  SCMG_EXT_KEY OPTIONAL
*"     VALUE(I_BP) TYPE  BU_PARTNER OPTIONAL
*"     VALUE(I_SEGMENT) TYPE  UKM_CREDIT_SGMNT OPTIONAL
*"     VALUE(IT_WORK_ITEM) TYPE  SWRTWIHDR OPTIONAL
*"----------------------------------------------------------------------

  DATA: ls_work_item      TYPE swr_wihdr,
        lv_status         TYPE swwwihead-wi_stat,
        lv_jobname        TYPE tbtcjob-jobname,
        lv_jobcount       TYPE tbtcjob-jobcount,
        lv_error_flag(01),
        lv_released       TYPE btch0000-char1.

  CONSTANTS: lc_jobname TYPE char20 VALUE 'ZRTRR_KILL_WORK_ITEM'.

**  DATA: lv_exit_flag TYPE c.
**  DO.
**    IF lv_exit_flag IS NOT INITIAL.
**      EXIT.
**    ENDIF.
**  ENDDO.

*--Calling Below FM with rejection functionality
  CALL FUNCTION 'ZRTR_AR_SCASE_BP_CONFIRM'
    EXPORTING
      iv_cr_partner = i_bp
      iv_cr_seg     = i_segment
      iv_stat_flg   = 'R'         " Reject of type CHAR1
* IMPORTING
*     EV_CONFIRMED  =
    EXCEPTIONS
      conf_failed   = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE it_work_item INTO ls_work_item INDEX 1.
  IF sy-subrc = 0.
    CALL FUNCTION 'ZRTRN_KILL_WORK_ITEM_FM' STARTING NEW TASK 'UPDATE' DESTINATION 'NONE'
      EXPORTING
        i_wi_id = ls_work_item-wi_id.
  ENDIF.


ENDFUNCTION.
