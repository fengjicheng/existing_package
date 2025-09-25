FUNCTION zqtc_billing_date_e164.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DATE) TYPE  SY-DATUM
*"     VALUE(IM_DAYS) TYPE  CHAR2 DEFAULT '10'
*"  EXPORTING
*"     VALUE(EX_BILL_DATE) TYPE  SY-DATUM
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_FIND_QUOTE_I0343(FM)
* PROGRAM DESCRIPTION: This FM is built to find the target billing date.
* This has been called for ZREW orders inside userexit of MV45AFZZ
* DEVELOPER: Parbhu
* CREATION DATE: 02/18/2019
* OBJECT ID: CR7873
* TRANSPORT NUMBER(S): ED2K914491
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923580
* REFERENCE NO:  OTCM-37780
* DEVELOPER: Krishna Srikanth (Ksrikanth)
* DATE:  2021-05-26
* DESCRIPTION:  Add the logic to get the next business date.
*------------------------------------------------------------------- *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
**---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  DATA : lv_day     TYPE scal-indicator,
         lv_in_date TYPE sy-datum.

  lv_in_date = im_date.
*--*Target date = input date + no of days(dafault 10)
  ex_bill_date = lv_in_date + im_days.

  DO.
    CALL FUNCTION 'DATE_COMPUTE_DAY'
      EXPORTING
        date = lv_in_date
      IMPORTING
        day  = lv_day.
*--*6 = Saturday 7 = Sunday
    IF lv_day = '6' OR lv_day = '7'.
      ex_bill_date = ex_bill_date + 1. "Consider next working day
    ENDIF.
*--*Increment input date by one for next loop pass
    lv_in_date = lv_in_date + 1.
*--*Check if the target date is reached and makesure target date is not falling in weekends
    IF lv_in_date GT ex_bill_date AND lv_day NE '6' AND lv_day NE '7'.
      EXIT.
    ENDIF.
  ENDDO.
*--*Check if the target dates falls between 20th to next month 4th, if yes make target date is 5th else 20th.
***  IF ex_bill_date+6(2) BETWEEN 20 AND 31 OR ex_bill_date+6(2) BETWEEN 01 AND 04.
  IF ex_bill_date+6(2) BETWEEN 20 AND 31.
    ex_bill_date+6(2) = 05.
***    ADD 1 TO ex_bill_date+4(2).
  ELSEIF ex_bill_date+6(2) BETWEEN 01 AND 04.
    ex_bill_date+6(2) = 05.
  ELSE.
    ex_bill_date+6(2) = 20.
  ENDIF.
"++ Begin of Changes By Krishna On_26052021
" Commentting the old logic as per new change in the logic.
"  Make sure that target date should be next business day.
****--*Check each and every date, whether it falls in weekends
****--*Make sure target month should be fall in next month when day gets modified
  IF ex_bill_date LE im_date.
    ADD 1 TO ex_bill_date+4(2).
    IF ex_bill_date+4(2) = 13.
      ex_bill_date+4(2) = 01.
    ENDIF.
  ENDIF.
*--* Make sure target year should be fall in next year when requested date is in year end
  IF ex_bill_date LE im_date..
    ADD 1 TO ex_bill_date+0(4).
  ENDIF.
****------------------------------------------------------------------------------*
**** Additional checks if Target date falls in weekend.
****------------------------------------------------------------------------------*
***  DO.
***    CLEAR : lv_day.
***    CALL FUNCTION 'DATE_COMPUTE_DAY'
***      EXPORTING
***        date = ex_bill_date
***      IMPORTING
***        day  = lv_day.
****--*6 = Saturday 7 = Sunday
***    IF lv_day = '6' OR lv_day = '7'.
***      IF ex_bill_date+6(2) = 05. "If 5 th falls in weekend then consider 20th
***        ex_bill_date+6(2) = 20.
***      ENDIF.
***    ENDIF.
****--* Check the target date again if it falls in weekends
***    CALL FUNCTION 'DATE_COMPUTE_DAY'
***      EXPORTING
***        date = ex_bill_date
***      IMPORTING
***        day  = lv_day.
****--*6 = Saturday 7 = Sunday
***    IF lv_day = '6' OR lv_day = '7'. "If 20th falls in weeknd then conside 5th of next month
***      ex_bill_date+6(2) = 05.
***      ADD 1 TO ex_bill_date+4(2).  "Add 1 for next month
***      IF ex_bill_date+4(2) = 13.  "Makesure if it is december
***        ex_bill_date+4(2) = 01.   "Jan
***      ENDIF.
***      IF ex_bill_date LE im_date. "Change year
***        ADD 1 TO ex_bill_date+0(4).
***      ENDIF.
***    ENDIF.

*  DO.
    CLEAR : lv_day.
    CALL FUNCTION 'DATE_COMPUTE_DAY'
      EXPORTING
        date = ex_bill_date
      IMPORTING
        day  = lv_day.
*--*6 = Saturday 7 = Sunday
    IF lv_day = '6'.
      ADD 2 TO ex_bill_date.
    ELSEIF lv_day = '7'.
      ADD 1 TO ex_bill_date.
    ENDIF.
"++ End of Changes By Krishna On_26052021
***Keep checking Target date if it falls in weekends
**--* Check the target date again if it falls in weekends
*    CALL FUNCTION 'DATE_COMPUTE_DAY'
*      EXPORTING
*        date = ex_bill_date
*      IMPORTING
*        day  = lv_day.
**--*6 = Saturday 7 = Sunday
*    IF lv_day NE '6'.
*      IF lv_day NE '7'.
*        EXIT.
*      ENDIF.
*    ENDIF.
*  ENDDO.
ENDFUNCTION.
