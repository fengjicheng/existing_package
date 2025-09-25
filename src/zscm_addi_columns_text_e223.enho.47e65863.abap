"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\SE:IMPLEMENTATION\SE:END\EI
ENHANCEMENT 0 ZSCM_ADDI_COLUMNS_TEXT_E223.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 21-AUG-2020
* DESCRIPTION: Event Handler Method: HANDLE_HOTSPOT_CLICK Implementation
* for LITHO Report
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K921719
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 05-FEB-2021
* DESCRIPTION: Aditional fields for Digital/Litho
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K922275
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 03-MARCH-2021
* DESCRIPTION: Fix sub total calc issue
*-----------------------------------------------------------------------*
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K923103
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 23-APR-2021
* DESCRIPTION: Fixing Refresh Issue
*--------------------------------------------------------------------*
METHOD HANDLE_HOTSPOT_CLICK.

   TYPES: BEGIN OF ty_msg_info,
           date     TYPE BALDATE,
           time     TYPE BALTIME,
           text     TYPE ZCOMMENTS,  " P22_COMMENTS,
          END OF ty_msg_info.

   DATA: lv_lognumber     TYPE balognr,
         lv_external_num  TYPE balnrext,
         lv_numberof_logs TYPE SYST_TABIX,
         li_header_data   TYPE STANDARD TABLE OF BALHDR INITIAL SIZE 0,
         li_messages      TYPE STANDARD TABLE OF BALM INITIAL SIZE 0,
         li_msg_info      TYPE STANDARD TABLE OF ty_msg_info,
         lst_msg_info     TYPE ty_msg_info,
         lv_timestamp_c   TYPE char22,
         lo_alv           TYPE REF TO cl_salv_table, " Basis Class for Simple Tables
         lr_functions     TYPE REF TO cl_salv_functions_list, " Generic and User-Defined Functions in List-Type Tables
         lr_display       TYPE REF TO cl_salv_display_settings,
         lv_start_column  TYPE i, " Start_column of type Integers
         lv_end_column    TYPE i, " End_column of type Integers
         lv_start_line    TYPE i, " Start_line of type Integers
         lv_end_line      TYPE i, " End_line of type Integers
         lv_adjustment    TYPE char13, "TD
         lv_omactual TYPE numc13. "TD
*BOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
**BOI ED2K923103 TDIMANTHA 27.04.2021
*         lv_upd_omplan    TYPE c.
**EOI ED2K923103 TDIMANTHA 27.04.2021
*EOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
   CONSTANTS: lc_comments  TYPE text25 VALUE '@0Q\QMaintain Comments@',
*BOI ED2K923103 TDIMANTHA 27.04.2021
              lc_all       TYPE char1  VALUE '*',
              lc_blbf      TYPE char4  VALUE 'BLBF',
              lc_rprd      TYPE char4  VALUE 'RPRD',
              lc_subs      TYPE char4  VALUE 'SUBS',
              lc_om        TYPE char4  VALUE 'OM',
              lc_y         TYPE char4  VALUE 'Y',
              lc_n         TYPE char4  VALUE 'N'.
*EOI ED2K923103 TDIMANTHA 27.04.2021
   " Read selected line
   READ TABLE gt_outtab INTO DATA(lst_outtab) INDEX e_row_id-index.
   IF sy-subrc = 0.
     " Nothing to do
   ENDIF.
*BOI ED2K923103 TDIMANTHA 27.04.2021
   " Fetch the Renewal Period for Subs/BL-Buffer information
          SELECT tm_type, matnr, sub_type, act_date,
                 sub_flag, quantity, aenam, aedat
                 FROM zscm_litho_tm INTO TABLE @DATA(li_litho_tm_dig).
          IF sy-subrc = 0.
            SORT li_litho_tm_dig BY tm_type sub_type matnr.
          ENDIF.
*EOI ED2K923103 TDIMANTHA 27.04.2021

   IF E_COLUMN_ID = 'COMMENTS'.

     " Call popup screen
     CALL FUNCTION 'ZSCM_MI_COMMENTS_POPUP_R096'
       EXPORTING
         IM_START_COLUMN       = 1
         IM_START_ROW          = 1
         IM_MEDIA_ISSUE        = lst_outtab-matnr
         IM_PLANT              = lst_outtab-marc_werks
       IMPORTING
         E_LOGNUMBER           = lv_lognumber.
     IF lv_lognumber IS NOT INITIAL.
       IF lst_outtab-view_comments IS INITIAL.
         lst_outtab-view_comments = c_icon_text.
         MODIFY gt_outtab FROM lst_outtab INDEX e_row_id-index
                          TRANSPORTING view_comments.
         CALL METHOD ME->REGISTER_REFRESH.
         CALL METHOD GV_LIST->EXECUTE_REFRESH.
       ENDIF.
     ENDIF.
*BOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
   ELSEIF E_COLUMN_ID = 'ADJUSTMENT_TXT'.  "ADJUST_CHNG

     " Call popup screen
     CALL FUNCTION 'ZSCM_MI_ADJUSTMENT_POPUP_R096'
       EXPORTING
         IM_START_COLUMN       = 1
         IM_START_ROW          = 1
         IM_MEDIA_PRODUCT      = lst_outtab-ismrefmdprod
         IM_MEDIA_ISSUE        = lst_outtab-matnr
         IM_PUB_DATE           = lst_outtab-ismpubldate
         IM_PLANT              = lst_outtab-marc_werks
         IM_OMACTUAL           = lst_outtab-om_actual
*BOI ED2K923103 TDIMANTHA 23.04.2021
         IM_ADJUSTMENT         = lst_outtab-adjustment
*EOI ED2K923103 TDIMANTHA 23.04.2021
       IMPORTING
         E_ADJUSTMENT          = lv_adjustment.

       lst_outtab-adjustment = lv_adjustment.
       lst_outtab-total_po_qty = lst_outtab-sub_total + lst_outtab-c_and_e + lst_outtab-author_copies + lst_outtab-emlo_copies + lst_outtab-adjustment.
*BOI ED2K923103 TDIMANTHA 27.04.2021
       lst_outtab-estimated_soh = lst_outtab-total_po_qty - lst_outtab-ml_cyear - lst_outtab-om_actual -
                                             lst_outtab-c_and_e - lst_outtab-author_copies - lst_outtab-emlo_copies.
*EOI ED2K923103 TDIMANTHA 27.04.2021
       lst_outtab-adjustment_txt = lst_outtab-adjustment.
       CONDENSE lst_outtab-adjustment_txt.
       CONCATENATE lc_comments lst_outtab-adjustment_txt INTO lst_outtab-adjustment_txt SEPARATED BY space.
       MODIFY gt_outtab FROM lst_outtab INDEX e_row_id-index
                        TRANSPORTING adjustment total_po_qty adjustment_txt estimated_soh.
       CALL METHOD ME->REGISTER_REFRESH.
       CALL METHOD GV_LIST->EXECUTE_REFRESH.

   ELSEIF E_COLUMN_ID = 'OM_ACTUAL_TXT'.
*BOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
**BOI ED2K923103 TDIMANTHA 27.04.2021
*     IF lst_outtab-om_plan = lst_outtab-om_actual.
*       lv_upd_omplan = abap_true.
*     ENDIF.
**EOI ED2K923103 TDIMANTHA 27.04.2021
*EOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
     " Call popup screen
     CALL FUNCTION 'ZSCM_MI_OMACTUAL_POPUP_R096'
       EXPORTING
         IM_START_COLUMN       = 1
         IM_START_ROW          = 1
         IM_MEDIA_PRODUCT      = lst_outtab-ismrefmdprod
         IM_MEDIA_ISSUE        = lst_outtab-matnr
         IM_PUB_DATE           = lst_outtab-ismpubldate
         IM_PLANT              = lst_outtab-marc_werks
         IM_ADJUSTMENT         = lst_outtab-adjustment
*BOI ED2K923103 TDIMANTHA 23.04.2021
         IM_OMACTUAL           = lst_outtab-om_actual
*EOI ED2K923103 TDIMANTHA 23.04.2021
       IMPORTING
         E_OMACTUAL            = lv_omactual.

       lst_outtab-om_actual = lv_omactual.
*BOC: OTCM-30221(R096) TDIMANTHA 03-MARCH-2021  ED2K922275
*       lst_outtab-sub_total = lst_outtab-om_actual + lst_outtab-new_subs + lst_outtab-bl_buffer.
*BOC ED2K923103 TDIMANTHA 23.04.2021
*       lst_outtab-sub_total = lst_outtab-om_actual + lst_outtab-purchase_req + lst_outtab-bl_buffer.
       lst_outtab-sub_total = lst_outtab-om_actual + lst_outtab-purchase_req.
*EOC ED2K923103 TDIMANTHA 23.04.2021
*EOC: OTCM-30221(R096) TDIMANTHA 03-MARCH-2021  ED2K922275
       lst_outtab-total_po_qty = lst_outtab-sub_total + lst_outtab-c_and_e + lst_outtab-author_copies + lst_outtab-emlo_copies + lst_outtab-adjustment.
*BOI ED2K923103 TDIMANTHA 27.04.2021
*BOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
"OM Plan
*       IF lv_upd_omplan = abap_true.
*         lst_outtab-om_plan = lst_outtab-om_actual.
*         CLEAR lv_upd_omplan.
*       ENDIF.
*EOC OTCM-46971 ED2K924280 TDIMANTHA 9-Aug-2021
" OM to Print
              READ TABLE li_litho_tm_dig INTO DATA(lst_litho_tm_dig) WITH KEY tm_type = lc_rprd
                                                                sub_type = lc_om
                                                                matnr = lst_outtab-matnr BINARY SEARCH.
              IF sy-subrc = 0.
                IF lst_litho_tm_dig-sub_flag = lc_y.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_outtab-om_to_print = lst_outtab-om_plan + lst_outtab-ob_plan.
                  ENDIF.
                ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                  IF sy-datum >= lst_litho_tm_dig-act_date.
                    lst_outtab-om_to_print = lst_outtab-om_actual + lst_outtab-ob_plan.
                  ENDIF.
                ENDIF.
                CLEAR lst_litho_tm_dig.
              ELSE.
                READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                                  sub_type = lc_om
                                                                  matnr = lst_outtab-ismrefmdprod BINARY SEARCH.
                IF sy-subrc = 0.
                  IF lst_litho_tm_dig-sub_flag = lc_y.
                    IF sy-datum >= lst_litho_tm_dig-act_date.
                      lst_outtab-om_to_print = lst_outtab-om_plan + lst_outtab-ob_plan.
                    ENDIF.
                  ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                    IF sy-datum >= lst_litho_tm_dig-act_date.
                      lst_outtab-om_to_print = lst_outtab-om_actual + lst_outtab-ob_plan.
                    ENDIF.
                  ENDIF.
                  CLEAR lst_litho_tm_dig.
                ELSE.
                  READ TABLE li_litho_tm_dig INTO lst_litho_tm_dig WITH KEY tm_type = lc_rprd
                                                                    sub_type = lc_om
                                                                    matnr = lc_all BINARY SEARCH.
                  IF sy-subrc = 0.
                    IF lst_litho_tm_dig-sub_flag = lc_y.
                      IF sy-datum >= lst_litho_tm_dig-act_date.
                        lst_outtab-om_to_print = lst_outtab-om_plan + lst_outtab-ob_plan.
                      ENDIF.
                    ELSEIF lst_litho_tm_dig-sub_flag = lc_n.
                      IF sy-datum >= lst_litho_tm_dig-act_date.
                       lst_outtab-om_to_print = lst_outtab-om_actual + lst_outtab-ob_plan.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                  CLEAR lst_litho_tm_dig.
                ENDIF.
              ENDIF.  " IF sy-subrc = 0.
       " Estimated SOH
       lst_outtab-estimated_soh = lst_outtab-total_po_qty - lst_outtab-ml_cyear - lst_outtab-om_actual -
                                             lst_outtab-c_and_e - lst_outtab-author_copies - lst_outtab-emlo_copies.
*EOI ED2K923103 TDIMANTHA 27.04.2021
       lst_outtab-om_actual_txt = lst_outtab-om_actual.
       SHIFT lst_outtab-om_actual_txt LEFT DELETING LEADING '0'.
       CONDENSE lst_outtab-om_actual_txt.
       CONCATENATE lc_comments lst_outtab-om_actual_txt INTO lst_outtab-om_actual_txt SEPARATED BY space.

       MODIFY gt_outtab FROM lst_outtab INDEX e_row_id-index
                        TRANSPORTING om_actual sub_total total_po_qty om_actual_txt om_to_print estimated_soh om_plan.
       CALL METHOD ME->REGISTER_REFRESH.
       CALL METHOD GV_LIST->EXECUTE_REFRESH.

*EOI: OTCM-30221(R096) TDIMANTHA 05-FEB-2021  ED2K921719
   ELSEIF E_COLUMN_ID = 'VIEW_COMMENTS'.
     " External Id
     lv_external_num = |{ lst_outtab-matnr }{ lst_outtab-marc_werks }|.
     " FM Call: Read Logs from DB
     CALL FUNCTION 'APPL_LOG_READ_DB'
       EXPORTING
         OBJECT                   = c_object
         SUBOBJECT                = c_subobj
         EXTERNAL_NUMBER          = lv_external_num
       IMPORTING
         NUMBER_OF_LOGS           = lv_numberof_logs
       TABLES
         HEADER_DATA              = li_header_data
         MESSAGES                 = li_messages.
      IF li_messages[] IS NOT INITIAL.
*        DELETE li_messages WHERE altext <> lst_outtab-marc_werks.
        SORT li_messages by LOGNUMBER DESCENDING MSGNUMBER.
        LOOP AT li_messages INTO DATA(lst_msg).
          MESSAGE ID lst_msg-msgid TYPE lst_msg-msgty NUMBER lst_msg-msgno
                  INTO DATA(lv_msg_text)
                  WITH lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4.
          lst_msg_info-text = lv_msg_text.
          lv_timestamp_c = lst_msg-time_stmp.
          lst_msg_info-date = lv_timestamp_c(8).
          lst_msg_info-time = lv_timestamp_c+8(6).
          APPEND lst_msg_info TO li_msg_info.
          CLEAR: lst_msg_info, lst_msg, lv_timestamp_c.
        ENDLOOP.

       " Display the Log Info in the Pop-up
       TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = li_msg_info[] ).
        CATCH cx_salv_msg.
       ENDTRY.

       lr_functions = lo_alv->get_functions( ).
       lr_functions->set_all( abap_true ).

       lr_display = lo_alv->get_display_settings( ).
       lr_display->set_list_header( 'Comments' ).

       lv_start_column  = 1.
       lv_end_column    = 100.
       lv_start_line    = 1.
       lv_end_line      = 10.

       IF lo_alv IS BOUND.
          lo_alv->set_screen_popup(
            start_column = lv_start_column
            end_column  = lv_end_column
            start_line  = lv_start_line
            end_line    = lv_end_line ).
          " Display ALV
          lo_alv->display( ).
       ENDIF. " IF lo_alv IS BOUND

      ENDIF. " IF li_messages[] IS NOT INITIAL.

   ENDIF. " IF E_COLUMN_ID = 'COMMENTS'.


ENDMETHOD.

ENDENHANCEMENT.
