*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_BG_PROCESS_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: Excel file and email genaration via background mode
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/01/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------**
TYPES : BEGIN OF ty_msgtype,                                                  " Identity code range declaration
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE jmsgty,
          high TYPE jmsgty,
        END OF ty_msgtype.

DATA: li_msgtype      TYPE STANDARD TABLE OF ty_msgtype INITIAL SIZE 0,
      lst_msgtype     TYPE ty_msgtype,
      li_bg_detail    TYPE STANDARD TABLE OF t_detail,                         " background processing details
      li_other_record TYPE STANDARD TABLE OF t_detail.

DATA : lv_index TYPE sy-tabix,                                               " current index for temporary table
       v_sender TYPE soextreci1-receiver.

CONSTANTS :lc_devid TYPE zdevid     VALUE 'R112',
           lc_msgid TYPE rvari_vnam VALUE 'MSGTY',
           lc_email TYPE rvari_vnam VALUE 'E_MAIL'.


" Fecth Constant values for respective WRICEF ID.
SELECT devid,                           " Development ID
       param1,                          " ABAP: Name of Variant Variable
       param2,                          " ABAP: Name of Variant Variable
       srno,                            " Current selection number
       sign,                            " ABAP: ID: I/E (include/exclude values)
       opti,                            " ABAP: Selection option (EQ/BT/CP/...)
       low,                             " Lower Value of Selection Condition
       high,                            " Upper Value of Selection Condition
       activate                         " Activation indicator for constant
       FROM zcaconstant                 " Wiley Application Constant Table
       INTO TABLE @DATA(li_constant)
       WHERE devid    = @lc_devid
       AND   activate = @abap_true.      " Only active record
IF sy-subrc IS INITIAL.
  SORT li_constant BY param1.

  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_msgid.                                       " Check Messsege ID.
        lst_msgtype-sign = <lfs_constant>-sign.
        lst_msgtype-opti = <lfs_constant>-opti.
        lst_msgtype-low  = <lfs_constant>-low.
        lst_msgtype-high = <lfs_constant>-high.
        APPEND lst_msgtype TO li_msgtype.
        CLEAR lst_msgtype.
    ENDCASE.
  ENDLOOP.

  FREE : v_sender.
  " Get Sender email adress
  READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_email BINARY SEARCH.
  IF sy-subrc = 0.
    v_sender = <lfs_constant>-low.      " Set Sender email address
  ENDIF.

ENDIF.

IF s_email IS NOT INITIAL.
  " Validate email address is maitained in SAP
  SELECT addrnumber,smtp_addr
    FROM adr6 INTO TABLE @DATA(li_adr6)
    WHERE smtp_addr IN @s_email.

ENDIF.

IF li_adr6 IS NOT INITIAL.              " Check email is empty

  IF detail_tab IS NOT INITIAL.         " Check final result table is empty
    REFRESH : li_bg_detail , li_other_record.

    " Detail data assign into temporary table for further processing.
    DATA(li_tmp_detail) = detail_tab[].

    " Keep the Error and information messege only.
    SORT li_tmp_detail BY msgty.
    DELETE li_tmp_detail WHERE msgty NOT IN li_msgtype.

    IF li_tmp_detail IS NOT INITIAL.

      " Delete duplicate information
      SORT li_tmp_detail BY contract item issue msg.
      DELETE ADJACENT DUPLICATES FROM li_tmp_detail COMPARING contract item issue msg.

      " Separate "Release Order Generation Stopped Due To Distribution Restriction" messeges.
      CLEAR lv_index.
      LOOP AT li_tmp_detail ASSIGNING FIELD-SYMBOL(<lfs_tmp_detail>).
        lv_index = sy-tabix.
        IF <lfs_tmp_detail>-msg CS text-977.
          APPEND INITIAL LINE TO li_bg_detail ASSIGNING FIELD-SYMBOL(<lfs_bg_detail>).
          MOVE-CORRESPONDING <lfs_tmp_detail> TO <lfs_bg_detail>.
          DELETE li_tmp_detail INDEX lv_index.
        ELSE.
          APPEND INITIAL LINE TO li_other_record ASSIGNING FIELD-SYMBOL(<lfs_other_record>).
          MOVE-CORRESPONDING <lfs_tmp_detail> TO <lfs_other_record>.
        ENDIF.
      ENDLOOP.

      " Check other error is null
      IF li_other_record IS NOT INITIAL.
        " Append skip data bottom of the final itab. (record rank according to the given text)
        APPEND LINES OF li_other_record TO li_bg_detail.
      ENDIF.

      INCLUDE zqtcn_addition_logic_sub_r112 IF FOUND.         " Additional output filteration from ALV layout data
      INCLUDE zqtcn_excel_genarate_sub_r112 IF FOUND.         " Excel file genarate subroutine
      INCLUDE zqtcn_email_genarate_sub_r112 IF FOUND.         " Email generate subroutine

    ELSE.
      MESSAGE text-974 TYPE lc_msgtype_i.                       " Error & information messeges not found
    ENDIF.
  ELSE.
    MESSAGE text-975 TYPE lc_msgtype_i.                         " No data for the current selection
  ENDIF.
ELSE.
  MESSAGE text-976 TYPE lc_msgtype_i.
ENDIF.
