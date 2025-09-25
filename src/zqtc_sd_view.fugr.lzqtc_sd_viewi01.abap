*----------------------------------------------------------------------*
***INCLUDE LZQTC_SD_VIEWI01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_SD_VIEWI01
* PROGRAM DESCRIPTION:Include for PAI
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          : 11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.
  PERFORM exit_command .
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.

  CASE v_user_command.
    WHEN c_abbr.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN c_sich.
      CASE sy-dynnr.
        WHEN c_9001.
*          IF  v_po_number IS NOT INITIAL .  "Commented by MODUTTA for JIRA#5090 on 10 Nov 2017
          PERFORM f_change_po_number USING v_po_number.
*          ENDIF. " IF v_po_number IS NOT INITIAL

        WHEN c_9003.
          PERFORM f_change_po_text USING st_rstext1-tdid
                                        v_radio_1
                                        v_radio_2.
        WHEN c_9004.
          CALL METHOD r_grid->check_changed_data.
          PERFORM f_change_partner USING i_partner
                                         v_hd_partner
                                         v_itm_partner
                                        .
        WHEN c_9005.
          CALL METHOD r_cond_grid->check_changed_data.
          PERFORM f_chang_condition USING i_item CHANGING i_messages
                                            i_xvbfs.
        WHEN c_9006.
          CALL SCREEN 9005 STARTING AT  10 10
         ENDING   AT 100 33.
        WHEN c_9002.
          CALL FUNCTION 'SD_PRINT_PROTOCOL'
            TABLES
              protokoll = i_xvbfs.
          REFRESH i_xvbfs.
        WHEN c_9007.
          CALL METHOD r_promo_grid->check_changed_data.
          PERFORM f_update_promo_code USING i_promo.
        WHEN c_9008.
          CALL METHOD r_can_grid->check_changed_data.
          PERFORM f_cancel_order USING i_cancel
                                       v_appliction
                                  CHANGING i_messages
                                            i_xvbfs.
        WHEN c_9009.
          CALL SCREEN c_9004 STARTING AT 10 10
          ENDING AT 100 33.

*      Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
        WHEN c_9010.
          CALL METHOD r_bill_grid->check_changed_data.
          PERFORM f_update_bill_block USING i_faksk_final
                                   CHANGING i_messages
                                            i_faksk
                                            i_xvbfs.

        WHEN c_9011.
          CALL METHOD r_delv_grid->check_changed_data.
          PERFORM f_update_delv_block USING i_lifsk_final
                                   CHANGING i_messages
                                            i_xvbfs
                                            i_lifsk.
        WHEN c_9012.
          CALL METHOD r_cust_grid->check_changed_data.
          PERFORM f_update_cust_block USING i_kdkg2
                                            i_kdkg2_final
                                   CHANGING i_xvbfs
                                            i_messages.

        WHEN c_9013.
*          IF v_licn_grp IS NOT INITIAL. "Commented by MODUTTA for JIRA#5090 on 10 Nov 2017
          PERFORM f_update_licn_grp USING v_licn_grp.
*          ENDIF. " IF v_licn_grp IS NOT INITIAL

*    End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342  Billing Date Button ED2K919999
        WHEN c_9014.
          PERFORM f_update_billing_date USING v_billing_date.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342  Billing Date Button ED2K919999
      ENDCASE.
    WHEN OTHERS.


  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  LEAVE_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE leave_screen INPUT.
  CASE sy-dynnr.
    WHEN c_9004.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.


      IF r_grid IS NOT INITIAL.
        CALL METHOD r_grid->free.
      ENDIF. " IF r_grid IS NOT INITIAL
      IF r_docking IS NOT INITIAL.
        CALL METHOD r_docking->free.
      ENDIF. " IF r_docking IS NOT INITIAL
      IF r_cont_cust IS NOT INITIAL.
        CALL METHOD r_cont_cust->free.
      ENDIF. " IF r_cont_cust IS NOT INITIAL
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR: r_grid,
             r_docking,
             r_cont_cust.
    WHEN c_9007.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_promo_grid IS BOUND.
        CALL METHOD r_promo_grid->free.

      ENDIF. " IF r_promo_grid IS BOUND
      IF r_cont_promo IS BOUND.
        CALL METHOD r_cont_promo->free.
      ENDIF. " IF r_cont_promo IS BOUND

      IF r_promo_docking IS BOUND.
        CALL METHOD r_promo_docking->free.

      ENDIF. " IF r_promo_docking IS BOUND
      CLEAR: r_promo_grid,
             r_cont_promo,
             r_promo_docking.
      CALL METHOD cl_gui_cfw=>flush.
    WHEN c_9008.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_can_grid IS BOUND.
        CALL METHOD r_can_grid->free.
      ENDIF. " IF r_can_grid IS BOUND
      IF r_cont_cancel IS BOUND.
        CALL METHOD r_cont_cancel->free.
      ENDIF. " IF r_cont_cancel IS BOUND
      IF r_docking_can IS BOUND.
        CALL METHOD r_docking_can->free.
      ENDIF. " IF r_docking_can IS BOUND
      CLEAR: r_can_grid,
             r_cont_cancel,
              r_docking_can.
      CALL METHOD cl_gui_cfw=>flush.
    WHEN c_9005.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_cond_grid IS BOUND.
        CALL METHOD r_cond_grid->free.
      ENDIF. " IF r_cond_grid IS BOUND
      IF r_cont_cust IS  BOUND.
        CALL METHOD r_cont_cust->free.
      ENDIF. " IF r_cont_cust IS BOUND

      IF r_docking_condition IS BOUND.
        CALL METHOD r_docking_condition->free.

      ENDIF. " IF r_docking_condition IS BOUND

      CLEAR:  r_cond_grid,
              r_cont_cust,
              r_docking_condition,
              i_item.
      CALL METHOD cl_gui_cfw=>flush.
    WHEN OTHERS.
  ENDCASE.
  IF v_user_command = c_sich.
    SET SCREEN 0.
    LEAVE SCREEN .

  ENDIF. " IF v_user_command = c_sich
ENDMODULE.

MODULE f4_date.
  CALL FUNCTION 'F4_DATE'
    EXPORTING
      date_for_first_month         = sy-datum
    IMPORTING
      select_date                  = v_billing_date
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      date_after_range             = 2
      date_before_range            = 3
      date_invalid                 = 4
      factory_calendar_not_found   = 5
      holiday_calendar_not_found   = 6
      parameter_conflict           = 7
      OTHERS                       = 8.

ENDMODULE.
