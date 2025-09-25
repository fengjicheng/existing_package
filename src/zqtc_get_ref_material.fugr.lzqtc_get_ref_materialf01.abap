*-------------------------------------------------------------------
* PROGRAM NAME: ZQTC_GET_REF_MATERIAL
* PROGRAM DESCRIPTION: Get the Reference Material
* a. System will pick the exact media issue refering publication date
*    based on month and period,
* b. If system could not find then it  will check the nearest publication
*    within next  +60 days.
* c. If system could not find above two condition then it will check the
*    nearest publication within previous  -90 days
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*----------------------------------------------------------------------*
***INCLUDE LZQTC_GET_REF_MATERIALF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_V_IN_DATE  text
*      -->P_IM_V_NEXT_DAYS  text
*      -->P_LV_ADVAN_FG  text
*      <--P_IV_ADVAN_DATE  text
*----------------------------------------------------------------------*
FORM f_calculate_date  USING    fp_date     TYPE  begda " Start Date
                                fp_month     TYPE dlymo  " Waiting Period in Days
                                fp_adv_fg   TYPE flag   " General Flag
                       CHANGING fp_cal_date TYPE begda. " Start Date

  DATA : lv_signum TYPE spli1. " No Change During Absence

  IF fp_adv_fg IS NOT INITIAL.
    lv_signum = '+'.
  ELSE. " ELSE -> IF fp_adv_fg IS NOT INITIAL
    lv_signum = '-'.
  ENDIF. " IF fp_adv_fg IS NOT INITIAL

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = fp_date
      days      = 00
      months    = fp_month
      signum    = lv_signum
      years     = 00
    IMPORTING
      calc_date = fp_cal_date.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FIRST_LAST_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_V_IN_DATE  text
*      <--P_LIR_MON_DAT  text
*----------------------------------------------------------------------*
FORM f_get_first_last_date  USING    fp_date TYPE syst_datum " ABAP System Field: Current Date of Application Server
                            CHANGING fp_lir_mon_dat TYPE datum_range_tab
                                     fp_last_date type syst_datum.


  DATA : lv_first_day TYPE  syst_datum, " ABAP System Field: Current Date of Application Server
         lv_last_day  TYPE  syst_datum. " ABAP System Field: Current Date of Application Server

  CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
    EXPORTING
*     I_MONTH     =
*     I_YEAR      =
      i_date      = fp_date
    IMPORTING
      e_first_day = lv_first_day
      e_last_day  = lv_last_day
    EXCEPTIONS
      wrong_date  = 1
      OTHERS      = 2.
  IF sy-subrc = 0.
    fp_last_date = lv_last_day.
    APPEND INITIAL LINE TO fp_lir_mon_dat ASSIGNING FIELD-SYMBOL(<lst_date>).
    <lst_date>-sign = c_i.
    <lst_date>-option = c_bt.
    <lst_date>-low  = lv_first_day.
    <lst_date>-high = lv_last_day.
  ENDIF. " IF sy-subrc = 0

ENDFORM.
