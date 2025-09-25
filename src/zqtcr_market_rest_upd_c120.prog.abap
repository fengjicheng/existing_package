 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MARKET_REST_UPD_C120
*&*--------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MARKET_REST_UPD_C120
*& DESCRIPTION:           Market Restriction Conversion Program For Creating
*&                           and Deleting Of Market Restricted Products
*& DEVELOPER:             SVISHWANAT
*& CREATION DATE:         03/28/2022
*& OBJECT ID:             C120 / EAM-8340
*& TRANSPORT NUMBER(S):   ED2K926336.
*&---------------------------------------------------------------------*
 REPORT zqtcr_market_rest_upd_c120 NO STANDARD PAGE HEADING
                                                  LINE-SIZE 150
                                                  LINE-COUNT 35
                                                  MESSAGE-ID zqtc_r2.
*---Top include
 INCLUDE zqtcn_mar_res_upd_c120_top.

*---Include for Selection Screen
 INCLUDE zqtcn_mar_res_upd_c120_scr.

*--Include for Forms
 INCLUDE zqtcn_mar_res_upd_c120_f01.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
   IF r_appl IS INITIAL.
* Get F4 help for presentation server
     PERFORM f_f4_presentation USING   syst-cprog
                                       c_field
                              CHANGING p_file.
   ELSE.
* Get F4 help for application server
     PERFORM f_f4_application CHANGING p_file.
   ENDIF.

 START-OF-SELECTION.
*---Get the file and get the data into internal table
   PERFORM f_get_data_from_file_create.

 END-OF-SELECTION.
   CLEAR:  v_total_proc, v_success ,  v_error  .
   IF sy-batch = space.
*--Foreground exeution
     PERFORM f_process_disp_data_create_del.
   ELSE.
*---Background exection
     PERFORM f_market_restrict_mat_cre_del.
     PERFORM f_process_disp_data_create_del.
   ENDIF.
