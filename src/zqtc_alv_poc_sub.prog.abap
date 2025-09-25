*&---------------------------------------------------------------------*
*&  Include           ZQTC_ALV_POC_SUB
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*

FORM get_data .
  FREE: li_tab.
  SELECT * FROM zqtc_contr_sub INTO TABLE li_tab WHERE vbeln IN s_vbeln AND kunnr IN s_kunnr.
  IF sy-subrc = 0.
    SORT li_tab BY vbeln.
    SELECT vbelv, vbeln, vbtyp_n
      FROM vbfa
      INTO TABLE @DATA(li_vbfa)
      FOR ALL ENTRIES IN @li_tab
      WHERE vbelv = @li_tab-rel_order
      AND vbtyp_n = 'M'.
    IF sy-subrc EQ 0.
      SORT li_vbfa BY vbeln.
    ENDIF.
    LOOP AT li_tab ASSIGNING FIELD-SYMBOL(<lfs_tab>).
      READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = <lfs_tab>-rel_order.
      IF sy-subrc EQ 0.
        <lfs_tab>-invoice = lst_vbfa-vbeln.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*

FORM fieldcat .
  wa_fcat-col_pos        =  '1'.
  wa_fcat-fieldname      =  'VBELN'.
  wa_fcat-tabname        =  'LI_VBAP'.
  wa_fcat-outputlen      =  11.
  wa_fcat-seltext_m      =  'Deal Number'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos        =  '2'.
  wa_fcat-fieldname      =  'REL_ORDER'.
  wa_fcat-tabname        =  'LI_VBAP'.
  wa_fcat-outputlen      =  11.
  wa_fcat-seltext_m      =  'Student Order'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos        =  '3'.
  wa_fcat-fieldname      =  'KUNNR'.
  wa_fcat-tabname        =  'LI_VBAP'.
  wa_fcat-outputlen      =  10.
  wa_fcat-seltext_m      =  'Sold To'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '4'.
  wa_fcat-fieldname         =  'SHIPTO'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  10.
  wa_fcat-seltext_m         =  'Ship To'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '5'.
  wa_fcat-fieldname         =  'BILLTO'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  10.
  wa_fcat-seltext_m         =  'Bill To'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '6'.
  wa_fcat-fieldname         =  'PAYER'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  10.
  wa_fcat-seltext_m         =  'Payer'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '7'.
  wa_fcat-fieldname         =  'INVOICE'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  10.
  wa_fcat-seltext_l         =  'Invoice'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '8'.
  wa_fcat-fieldname         =  'LAND1'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  6.
  wa_fcat-seltext_m         =  'Country'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '9'.
  wa_fcat-fieldname         =  'REGION'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  5.
  wa_fcat-seltext_m         =  'Region'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '10'.
  wa_fcat-fieldname         =  'BSTZD'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  15.
  wa_fcat-seltext_m         =  'Discount Plan Type'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '11'.
  wa_fcat-fieldname         =  'NO_OF_SUBSCR'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  12.
  wa_fcat-seltext_m         =  'Total Students'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '12'.
  wa_fcat-fieldname         =  'REL_QTY'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  16.
  wa_fcat-seltext_l         =  'Students Registered'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos           =  '13'.
  wa_fcat-fieldname         =  'BAL_SUBSCR'.
  wa_fcat-tabname           =  'LI_VBAP'.
  wa_fcat-outputlen         =  20.
  wa_fcat-seltext_l         =  'Targeted Student Count'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*

FORM sort_data .
  wa_sort-fieldname = 'VBELN'.
  wa_sort-up        = 'X'.
  APPEND wa_sort TO it_sort.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*

FORM display_data .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = 'ZQTC_ALV_POC'
      it_fieldcat        = it_fcat
      it_sort            = it_sort
      is_layout          = ws_layout
    TABLES
      t_outtab           = li_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
