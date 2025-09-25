*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_SD_VIEWO01
* PROGRAM DESCRIPTION:Include for form declaration
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *

*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       Setting The PF status and Title bar
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  PERFORM f_set_status USING sy-dynnr.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_LIST_BOX  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_list_box OUTPUT.
  CONSTANTS :  lc_name         TYPE vrm_id      VALUE 'ST_RSTEXT1-TDID'. " List Control Name
  PERFORM f_init_list_box USING c_9003
                              lc_name.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_TEXT_EDITOR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_text_editor OUTPUT.
  PERFORM   f_init_text_editor.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_LIST  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_list OUTPUT.
  PERFORM f_init_list_box USING c_9004
                                 'V_PAR_FUN'
                                  .
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  9004_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       PBO Module for screen 9004
*----------------------------------------------------------------------*
MODULE pbo_9004 OUTPUT.
  CLEAR: i_partner, i_fielcat_par.
  IF r_docking IS INITIAL.
*create a docking container and dock the control at the botton
    CREATE OBJECT r_docking
      EXPORTING
        dynnr     = c_9004
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.

*create the alv grid for display the table
    CREATE OBJECT r_grid
      EXPORTING
        i_parent = r_docking.

*create custome container for alv
    CREATE OBJECT r_cont_cust
      EXPORTING
        container_name = c_part_cont.


  ENDIF. " IF r_docking IS INITIAL
*building the fieldcatalogue for the initial display
  IF i_fielcat_par[] IS  INITIAL.
    PERFORM f_build_fieldcat USING sy-dynnr
                             CHANGING i_fielcat_par .

  ENDIF. " IF i_fielcat_par[] IS INITIAL
  PERFORM f_dropdown USING i_list
                           i_tvkgt
                           i_tvkst
                           i_tvagt
                           sy-dynnr
                           v_appliction
                      CHANGING r_grid
                           i_fielcat_par.
  IF i_excl_func IS INITIAL.
    PERFORM f_exclude_function CHANGING i_excl_func.
  ENDIF. " IF i_excl_func IS INITIAL


  PERFORM f_display_alv USING v_hd_partner
                        CHANGING   i_partner.


* optimize column width of grid displaying fieldcatalog
  i_layout_par-cwidth_opt = 'X'.
  CALL METHOD r_grid->set_frontend_fieldcatalog
    EXPORTING
      it_fieldcatalog = i_fielcat_par. " Field Catalog

*Alv display for the T006 table at the bottom
  i_partner_final[] = i_partner[].
  DATA(lv_count) = lines( i_partner_final ).
  IF lv_count > 1.
    DELETE i_partner_final FROM 2 TO lv_count.
  ENDIF. " IF lv_count > 1

  CALL METHOD r_grid->set_table_for_first_display
    EXPORTING
      it_toolbar_excluding = i_excl_func
      is_layout            = i_layout_par
    CHANGING
      it_outtab            = i_partner_final
      it_fieldcatalog      = i_fielcat_par[].
* set editable cells to ready for input
  CALL METHOD r_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.
  CALL METHOD r_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SUPPRESS_DIALOG  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE suppress_dialog OUTPUT.
  SUPPRESS DIALOG.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  9007_PBO  OUTPUT
*&---------------------------------------------------------------------*
*     Module 9007 PBO
*----------------------------------------------------------------------*
MODULE pbo_9007 OUTPUT.

  IF r_promo_docking IS NOT BOUND.
*create a docking container and dock the control at the Left
    CREATE OBJECT r_promo_docking
      EXPORTING
        dynnr     = c_9007
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.
*create the alv grid for display the table
    CREATE OBJECT r_promo_grid
      EXPORTING
        i_parent = r_promo_docking.
*create custome container for alv
    CREATE OBJECT r_cont_promo
      EXPORTING
        container_name = c_promo_cont.

*building the fieldcatalogue for the initial display
    IF i_fielcat_pro[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fielcat_pro .
    ENDIF. " IF i_fielcat_pro[] IS INITIAL
    IF i_excl_func IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.
    ENDIF. " IF i_excl_func IS INITIAL
    PERFORM f_promo_code USING i_sel_rows
                               <i_result>
                               CHANGING i_promo.
    CALL METHOD r_promo_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fielcat_pro. " Field Catalog

    i_promo_final[] = i_promo[].
    DATA(lv_count1) = lines( i_promo_final ).
    IF lv_count1 > 1.
      DELETE i_promo_final FROM 2 TO lv_count1.
    ENDIF. " IF lv_count1 > 1
    CALL METHOD r_promo_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
        is_layout            = i_layout_par
      CHANGING
        it_outtab            = i_promo_final
        it_fieldcatalog      = i_fielcat_pro[].
* set editable cells to ready for input
    CALL METHOD r_promo_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_promo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

* register events for the editable alv
    CALL METHOD r_promo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.
    CREATE OBJECT r_event_receiver.
    SET HANDLER r_event_receiver->meth_handle_data_changed FOR r_promo_grid.
  ENDIF. " IF r_promo_docking IS NOT BOUND
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  9008_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       PBO Module for building ALV and showing data to cancel Order
*----------------------------------------------------------------------*
MODULE pbo_9008 OUTPUT.
  CLEAR i_cancel.
  IF r_docking_can IS INITIAL.
*create a docking container and dock the control at the Left
    CREATE OBJECT r_docking_can
      EXPORTING
        dynnr     = c_9008
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.
*create the alv grid for display the table
    CREATE OBJECT r_can_grid
      EXPORTING
        i_parent = r_docking_can.
*create custome container for alv
    CREATE OBJECT r_cont_cancel
      EXPORTING
        container_name = c_cancel_cont.
*building the fieldcatalogue for the initial display
    IF i_fielcat_can[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fielcat_can .
    ENDIF. " IF i_fielcat_can[] IS INITIAL
    IF i_excl_func IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.
    ENDIF. " IF i_excl_func IS INITIAL

    PERFORM f_fetch_ord_reason USING v_appliction
                                CHANGING i_tvkgt
                                         i_tvkst
                                         i_tvagt .
    PERFORM f_cancel_ord_data USING i_sel_rows
                           <i_result>
                           CHANGING i_cancel.
    PERFORM f_dropdown USING i_list
                             i_tvkgt
                             i_tvkst
                             i_tvagt
                             sy-dynnr
                             v_appliction
                        CHANGING r_can_grid
                             i_fielcat_can.

    CALL METHOD r_can_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fielcat_can. " Field Catalog

    i_cancel_final[] = i_cancel[].
    DATA(lv_count2) = lines( i_cancel_final ).
    IF lv_count2 > 1.
      DELETE i_cancel_final FROM 2 TO lv_count2.
    ENDIF. " IF lv_count > 1

    CALL METHOD r_can_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
        is_layout            = i_layout_par
      CHANGING
        it_outtab            = i_cancel_final[]
        it_fieldcatalog      = i_fielcat_can[].
* set editable cells to ready for input
    CALL METHOD r_can_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_can_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  ENDIF. " IF r_docking_can IS INITIAL
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_LIST_BOX_9006  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_list_box_9006 OUTPUT.
  CLEAR :  i_item,
           i_cond.
  PERFORM f_init_list_box USING c_9006
                                space.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  9005_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       PBO Module for Screen 9005
*----------------------------------------------------------------------*
MODULE pbo_9005 OUTPUT.
  PERFORM f_create_alv.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_9008  OUTPUT
*&---------------------------------------------------------------------*
*       PBO for 9008 screen
*----------------------------------------------------------------------*
MODULE init_9008 OUTPUT.
  PERFORM f_init_list_box USING c_9008
                                space.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_9010  OUTPUT
*&---------------------------------------------------------------------*
*       PBO for screen no 9010
*----------------------------------------------------------------------*
* Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
MODULE pbo_9010 OUTPUT.
  PERFORM f_create_alv_bilblk.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_9010  OUTPUT
*&---------------------------------------------------------------------*
*       Populate list box for Billing Block
*----------------------------------------------------------------------*
MODULE init_9010 OUTPUT.
  PERFORM f_init_list_box USING c_9010
                                space.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_9011  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_9011 OUTPUT.
  PERFORM f_init_list_box USING c_9011
                                space.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_9011  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_9011 OUTPUT.
  PERFORM f_create_alv_delvblk.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_9012  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_9012 OUTPUT.
  PERFORM f_init_list_box USING c_9012
                                space.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_9012  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_9012 OUTPUT.
  PERFORM f_create_alv_custgrp.
ENDMODULE.
* End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
