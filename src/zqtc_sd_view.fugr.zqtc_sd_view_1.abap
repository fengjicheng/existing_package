FUNCTION zqtc_sd_view_1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_APPLICATION_ID) TYPE  STRING OPTIONAL
*"     VALUE(IM_NAME) TYPE  SALV_DE_FUNCTION OPTIONAL
*"     VALUE(IM_SCREEN_NO) TYPE  CHAR4 OPTIONAL
*"  TABLES
*"      T_SELECTED_ROWS TYPE  SALV_T_ROW OPTIONAL
*"      T_RESULT TYPE  STANDARD TABLE
*"  CHANGING
*"     REFERENCE(CH_MESSAGE) TYPE  TDT_SDOC_MSG OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_SD_VIEW_1
* PROGRAM DESCRIPTION:Function module for Mass change
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Changes t0 ZQTC_VA05 mass change
*----------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          : 11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*----------------------------------------------------------------------*
  DATA: lv_trvog  TYPE trvog ,         " Transaction group
        lr_vbkd   TYPE REF TO ty_vbkd, " Vbkd class
        lr_vbkd1  TYPE REF TO ty_vbkd1, "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
        lst_vbkd1 TYPE ty_vbkd1.        "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mas Billing Date update VA45

  FIELD-SYMBOLS: <lst_result> TYPE any,
                 <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                 <lv_posnr>   TYPE posnr,      "line item ""++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
                 <lv_kunnr>   TYPE kunnr,      " Customer Number
                 <lv_bstkd>   TYPE bstkd.      " Customer purchase order number
*& If already mass change executed then stop it again for
*& the same instance.
  IF i_messages IS NOT INITIAL.
    CALL FUNCTION 'POPUP_DISPLAY_MESSAGE'
      EXPORTING
        titel = 'Message'(a11)
        msgid = c_mess_id
        msgty = c_error
        msgno = c_msgno.
    RETURN.
  ENDIF. " IF i_messages IS NOT INITIAL
  CLEAR v_appliction.
  i_sel_rows[] = t_selected_rows[].
  IF im_application_id = if_sdoc_select=>co_application_id-va25nn.
    v_appliction = if_sdoc_select=>co_application_id-va25nn.
    lv_trvog = 2.
  ELSEIF im_application_id = if_sdoc_select=>co_application_id-va45nn.
    v_appliction = if_sdoc_select=>co_application_id-va45nn.
    lv_trvog = 4.
* SOC by NPOLINA 08/13/2019 DM7836 ED2K915777
  ELSEIF im_application_id = if_sdoc_select=>co_application_id-va05nn.
    v_appliction = if_sdoc_select=>co_application_id-va05nn.
    lv_trvog = 0.
* EOC by NPOLINA 08/13/2019 DM7836 ED2K915777
  ENDIF. " IF im_application_id = if_sdoc_select=>co_application_id-va25nn
  CREATE OBJECT r_sdoc_select_adapter
    EXPORTING
      iv_trvog          = lv_trvog
      iv_application_id = im_application_id.
  r_result_table_type = r_sdoc_select_adapter->if_sdoc_adapter~get_result_table_type( ).
  CREATE DATA r_result TYPE HANDLE r_result_table_type. " Internal ID of an object
  ASSIGN r_result->* TO <i_result>.
  <i_result>[] = t_result[].
  CASE im_application_id.
    WHEN if_sdoc_select=>co_application_id-va25nn OR
         if_sdoc_select=>co_application_id-va45nn OR
         if_sdoc_select=>co_application_id-va05nn.    "NPOLINA 08/13/2019 DM7836 ED2K915777
      CASE im_name.
        WHEN c_name.
          CLEAR i_vbkd.
          CREATE DATA lr_vbkd.
          LOOP AT i_sel_rows INTO st_sel_row.
            READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
            IF sy-subrc = 0.
              ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-bstkd OF   STRUCTURE <lst_result> TO <lv_bstkd>.
              IF <lv_bstkd> IS ASSIGNED.
                lr_vbkd->bstkd  = <lv_bstkd>.
                UNASSIGN <lv_bstkd>.
              ENDIF. " IF <lv_bstkd> IS ASSIGNED
              ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
              IF <lv_vbeln> IS ASSIGNED.
                lr_vbkd->vbeln = <lv_vbeln>.
                UNASSIGN <lv_vbeln>.
                APPEND lr_vbkd->* TO  i_vbkd.
                CLEAR lr_vbkd->*.
              ENDIF. " IF <lv_vbeln> IS ASSIGNED
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row
          CALL SCREEN im_screen_no       STARTING AT 10 10
         ENDING   AT 62 14.
        WHEN c_text.
          CALL SCREEN im_screen_no       STARTING AT 10 10
         ENDING   AT 100 33.
        WHEN c_partner.
          IF v_partner IS  INITIAL.
            LOOP AT i_sel_rows INTO st_sel_row.
              READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
              IF sy-subrc = 0.
                ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-kunnr OF   STRUCTURE <lst_result> TO <lv_kunnr>.
                IF <lv_kunnr> IS ASSIGNED.
                  v_partner = <lv_kunnr>.
                  UNASSIGN <lv_kunnr>.
                ENDIF. " IF <lv_kunnr> IS ASSIGNED
              ENDIF. " IF sy-subrc = 0
            ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row
          ENDIF. " IF v_partner IS INITIAL
          CALL SCREEN im_screen_no STARTING AT 10 10
                   ENDING   AT 40 14.
        WHEN c_mchanpocond.
          CALL SCREEN im_screen_no STARTING AT 10 10
                ENDING   AT 62 14.

        WHEN c_mchapocan.
          CALL SCREEN im_screen_no STARTING AT 10 10
                ENDING   AT 150 30.

        WHEN c_promocode.
          CLEAR i_promo.
          CALL SCREEN im_screen_no STARTING AT 10 10 ENDING AT 50 20.

        WHEN c_mchanbb.
          CALL SCREEN 9010 STARTING AT 10 10 ENDING AT 50 20.

        WHEN c_mchandb.
          CALL SCREEN 9011 STARTING AT 10 10 ENDING AT 50 20.

        WHEN c_mchanmemcat.
          CALL SCREEN 9012 STARTING AT 10 10 ENDING AT 50 20.

        WHEN c_mchanliccat.
          CALL SCREEN 9013 STARTING AT 10 10 ENDING AT 90 20.
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
*---calling screen 9014 and processing the mass billing date update
        WHEN c_mbilling.
          CLEAR i_vbkd1.
          CREATE DATA lr_vbkd1.
          LOOP AT i_sel_rows INTO st_sel_row.
            READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
            IF sy-subrc = 0.
              ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
              IF <lv_vbeln> IS ASSIGNED.
                lr_vbkd1->vbeln = <lv_vbeln>.
                UNASSIGN <lv_vbeln>.
                APPEND lr_vbkd1->* TO  i_vbkd1.
                CLEAR lr_vbkd1->*.
              ENDIF. " IF <lv_vbeln> IS ASSIGNED
              ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
              IF <lv_vbeln> IS ASSIGNED.
                lr_vbkd1->posnr = <lv_posnr>.
                UNASSIGN <lv_posnr>.
                APPEND lr_vbkd1->* TO  i_vbkd1.
                CLEAR lr_vbkd1->*.
              ENDIF. " IF <lv_vbeln> IS ASSIGNED
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row
          CALL SCREEN 9014 STARTING AT 10 10
                           ENDING   AT 90 20.
        WHEN OTHERS.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
      ENDCASE.
    WHEN OTHERS.
  ENDCASE.
  IF i_xvbfs[]  IS NOT INITIAL AND
    v_user_command = c_sich.
    PERFORM f_protocol.
  ENDIF. " IF i_xvbfs[] IS NOT INITIAL AND
  IF i_messages[] IS NOT INITIAL .
    APPEND LINES OF i_messages TO ch_message.

  ENDIF. " IF i_messages[] IS NOT INITIAL
ENDFUNCTION.
