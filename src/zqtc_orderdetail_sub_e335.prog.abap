*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ORDERDETAIL_SUB_E335 (Display the order history)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/28/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
TYPES : BEGIN OF ty_tab,
          auart TYPE auart,
          count TYPE char9,
        END OF ty_tab.

DATA: li_tab             TYPE STANDARD TABLE OF ty_tab,
      lst_tab            TYPE ty_tab,
      li_fieldcat_order  TYPE slis_t_fieldcat_alv,
      lst_fieldcat_order LIKE LINE OF li_fieldcat_order.

DATA : lv_order_count   TYPE char9.

REFRESH : li_fieldcat_order , li_tab.

" Build Popup list field catalog
lst_fieldcat_order-col_pos = 1.
lst_fieldcat_order-fieldname = 'AUART'.
lst_fieldcat_order-seltext_l = 'Order Type'.
lst_fieldcat_order-tabname = 'LI_TAB'.
APPEND lst_fieldcat_order TO li_fieldcat_order.
CLEAR lst_fieldcat_order.

lst_fieldcat_order-col_pos = 2.
lst_fieldcat_order-fieldname = 'COUNT'.
lst_fieldcat_order-seltext_l = 'Order History'.
lst_fieldcat_order-tabname = 'LI_TAB'.
APPEND lst_fieldcat_order TO li_fieldcat_order.
CLEAR lst_fieldcat_order.

LOOP AT is_sum_ortypewise ASSIGNING FIELD-SYMBOL(<lfs_sum_ordertypewise>)
                                                  WHERE kunnr = postab-zzship2party AND
                                                        matnr = postab-matnr.
  CLEAR lv_order_count.
  WRITE <lfs_sum_ordertypewise>-count TO lv_order_count DECIMALS 0.
  CONDENSE lv_order_count NO-GAPS.
  lst_tab-auart = <lfs_sum_ordertypewise>-auart.
  lst_tab-count = lv_order_count.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

ENDLOOP.

" Popup the list with filed names
CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
  EXPORTING
    i_title               = 'Order History'
    i_zebra               = abap_true
    i_screen_start_column = 50
    i_screen_start_line   = 5
    i_screen_end_column   = 100
    i_screen_end_line     = 20
    i_tabname             = 'LI_TAB'
    it_fieldcat           = li_fieldcat_order
    i_callback_program    = sy-repid
  TABLES
    t_outtab              = li_tab
  EXCEPTIONS
    program_error         = 1
    OTHERS                = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
