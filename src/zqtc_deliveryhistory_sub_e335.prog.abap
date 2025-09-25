*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_DELIVERYHISTORY_SUB_E335 (popup outbound delivery history)
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                      *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_tab_del,
          vbeln TYPE vbeln,
        END OF ty_tab_del.

DATA: li_tab_del       TYPE STANDARD TABLE OF ty_tab_del,
      lst_tab_del      TYPE ty_tab_del,
      li_fieldcat_del  TYPE slis_t_fieldcat_alv,
      lst_fieldcat_del LIKE LINE OF li_fieldcat_del.


REFRESH : li_fieldcat_del , li_tab_del.

" Build Popup list field catalog
lst_fieldcat_del-col_pos = 1.
lst_fieldcat_del-fieldname = 'VBELN'.
lst_fieldcat_del-seltext_l = 'Outbound Delivery'.
lst_fieldcat_del-tabname = 'LI_TAB_DEL'.
APPEND lst_fieldcat_del TO li_fieldcat_del.
CLEAR lst_fieldcat_del.

IF i_delhistory IS NOT INITIAL.
  LOOP AT i_delhistory ASSIGNING FIELD-SYMBOL(<lfs_delhistory>)
                                                    WHERE kunnr = postab-zzship2party AND
                                                          matnr = postab-matnr.
    lst_tab_del-vbeln = <lfs_delhistory>-vbeln.
    APPEND lst_tab_del TO li_tab_del.
    CLEAR lst_tab_del.

  ENDLOOP.

  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = 'Outbound Delivery History'
      i_zebra               = abap_true
      i_screen_start_column = 50
      i_screen_start_line   = 5
      i_screen_end_column   = 100
      i_screen_end_line     = 20
      i_tabname             = 'LI_TAB_DEL'
      it_fieldcat           = li_fieldcat_del
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = li_tab_del
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDIF.
