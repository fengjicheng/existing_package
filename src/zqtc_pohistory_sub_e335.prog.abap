*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_POHISTORY_SUB_E335 (popup purchase order history)
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                      *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_tab_po,
          ebeln TYPE ebeln,
        END OF ty_tab_po.

DATA: li_tab_po       TYPE STANDARD TABLE OF ty_tab_po,
      lst_tab_po      TYPE ty_tab_po,
      li_fieldcat_po  TYPE slis_t_fieldcat_alv,
      lst_fieldcat_po LIKE LINE OF li_fieldcat_po.


REFRESH : li_fieldcat_po , li_tab_po.

" Build Popup list field catalog
lst_fieldcat_po-col_pos = 1.
lst_fieldcat_po-fieldname = 'EBELN'.
lst_fieldcat_po-seltext_l = 'Purchase Order'.
lst_fieldcat_po-tabname = 'LI_TAB_PO'.
APPEND lst_fieldcat_po TO li_fieldcat_po.
CLEAR lst_fieldcat_po.

IF i_pohistory IS NOT INITIAL.
  LOOP AT i_pohistory ASSIGNING FIELD-SYMBOL(<lfs_pohistory>)
                                                    WHERE kunnr = postab-zzship2party AND
                                                          matnr = postab-matnr.
    lst_tab_po-ebeln = <lfs_pohistory>-ebeln.
    APPEND lst_tab_po TO li_tab_po.
    CLEAR lst_tab_po.

  ENDLOOP.

  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = 'Purchase Order History'
      i_zebra               = abap_true
      i_screen_start_column = 50
      i_screen_start_line   = 5
      i_screen_end_column   = 100
      i_screen_end_line     = 20
      i_tabname             = 'LI_TAB_PO'
      it_fieldcat           = li_fieldcat_po
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = li_tab_po
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDIF.
