FUNCTION zqtc_update_auto_renewal.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  TABLES
*"      T_RENWL_PLAN STRUCTURE  ZQTC_RENWL_PLAN OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_UPDATE_AUTO_RENEWAL
* PROGRAM DESCRIPTION:FM for populating auto renewal plan table
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E095
* TRANSPORT NUMBER(S)  ED2K903783
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907249
* REFERENCE NO:  Defect 3124
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-12-07
* DESCRIPTION: locking specific records instead of locking whole table
*------------------------------------------------------------------- *

*Begin of Add-Anirban-07.12.2017-ED2K907249-Defect 3124
  DATA : lt_order  TYPE STANDARD TABLE OF zqtc_renwl_plan,
         lt_order1 TYPE STANDARD TABLE OF zqtc_renwl_plan,
         lst_order TYPE zqtc_renwl_plan.
  CLEAR : lt_order, lt_order1.
  lt_order[] = t_renwl_plan[].
  SORT lt_order BY vbeln.
  DELETE ADJACENT DUPLICATES FROM lt_order COMPARING vbeln.
  LOOP AT lt_order INTO lst_order.
    CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
      EXPORTING
        mode_zqtc_renwl_plan = abap_true
        mandt                = sy-mandt
        vbeln                = lst_order-vbeln
      EXCEPTIONS
        foreign_lock         = 1
        system_failure       = 2
        OTHERS               = 3.
    IF sy-subrc <> 0.
      MESSAGE a223(zqtc_r2). "Unable to lock table ZQTC_AUTO_RENEW
    ELSE.
      lt_order1[] = t_renwl_plan[].
      DELETE lt_order1 WHERE vbeln NE lst_order-vbeln.
      MODIFY zqtc_renwl_plan FROM TABLE lt_order1.
      IF sy-subrc = 0.
        CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
          EXPORTING
            mode_zqtc_renwl_plan = abap_true
            mandt                = sy-mandt
            vbeln                = lst_order-vbeln.
      ENDIF.
    ENDIF.
    CLEAR: lt_order1.
  ENDLOOP.
  CLEAR : lt_order.
*End of Add-Anirban-07.12.2017-ED2K907249-Defect 3124

*Begin of Del-Anirban-07.12.2017-ED2K907249-Defect 3124
*  CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
*    EXPORTING
*      mode_zqtc_renwl_plan = abap_true
*      mandt                = sy-mandt
*    EXCEPTIONS
*      foreign_lock         = 1
*      system_failure       = 2
*      OTHERS               = 3.
*  IF sy-subrc <> 0.
** No Need to throw error message
*  ELSE.
*    MODIFY zqtc_renwl_plan FROM TABLE t_renwl_plan.
*    IF sy-subrc = 0.
*      CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
*        EXPORTING
*          mode_zqtc_renwl_plan = abap_true
*          mandt                = sy-mandt.
*
*    ENDIF.
*  ENDIF.
*End of Del-Anirban-07.12.2017-ED2K907249-Defect 3124




ENDFUNCTION.
