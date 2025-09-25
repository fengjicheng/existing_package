*&---------------------------------------------------------------------*
*&  Include           RJKSDPROTOCOLTOP
*&---------------------------------------------------------------------*
************************************************************************
* Funktionscodes
************************************************************************
DATA okcode LIKE sy-ucomm.
CONSTANTS: con_fcode_select          TYPE sy-ucomm VALUE 'SELECT',
           con_fcode_save            TYPE sy-ucomm VALUE 'SAVE',
           con_fcode_refresh         TYPE sy-ucomm VALUE 'REFRESH',
           con_fcode_back            TYPE sy-ucomm VALUE 'BACK',
           con_fcode_cancel          TYPE sy-ucomm VALUE 'CANCEL',
           con_fcode_exit            TYPE sy-ucomm VALUE 'EXIT',
           con_fcode_show_overview   TYPE sy-ucomm VALUE 'SHOWOVER',
           con_fcode_hide_overview   TYPE sy-ucomm VALUE 'HIDEOVER',
           con_fcode_show_detail     TYPE sy-ucomm VALUE 'SHOWDETAIL',
           con_fcode_hide_detail     TYPE sy-ucomm VALUE 'HIDEDETAIL',
           con_fcode_longtext        TYPE sy-ucomm VALUE 'LONGTEXT',
           con_fcode_delete_protocol TYPE sy-ucomm VALUE 'DELETEPROT'.

************************************************************************
* Typ für Detaildaten Protokoll
************************************************************************
TYPES: BEGIN OF t_detail.
         INCLUDE STRUCTURE rjksdshowprotocol.
         TYPES: logid          TYPE jksdprotocolhead-logid,
         counter        TYPE jksdprotocol-counter,
         cell_tab       TYPE lvc_t_styl,
         icon           TYPE char30,
         color(4)       TYPE c,
         index          TYPE sy-tabix, "Eintragsnummer
         dropdown_layer TYPE lvc_s_drop-handle, "Dropdownbox für
         "Herkunft der Meldung
         netwr          TYPE netwr_ap,        " Potential value of release orders
         waerk          TYPE waerk,           " Currency
         matnr          TYPE matnr,           " Media Product
         identcode      TYPE ismidentcode,    " Identity code
         country        TYPE landx,           " Country
         postal_code    TYPE pstlz,           " Postal code
         vendor         TYPE lifnr,           " Distributor
         plant          TYPE dwerk_ext,       " Plant
         ship_method    TYPE vsbed_bez,       " Ship Methos
       END OF t_detail.

************************************************************************
* Tabellentyp zu t_detail
************************************************************************
TYPES t_detail_tab TYPE STANDARD TABLE OF t_detail.

************************************************************************
* Typ für Übersicht Protokoll
************************************************************************
TYPES: BEGIN OF t_overview.
         INCLUDE STRUCTURE rjksdshowprotocoloverview.
         TYPES: cell_tab TYPE lvc_t_styl,
       END OF t_overview.

************************************************************************
* Tabelle mit Überblicksdaten am Bildschirm
************************************************************************
DATA overview_tab TYPE STANDARD TABLE OF t_overview.

************************************************************************
* Tabelle mit gelöschten Überblicksdaten am Bildschirm
************************************************************************
DATA delete_overview_tab TYPE STANDARD TABLE OF t_overview.

************************************************************************
* Tabelle mit Detaildaten am Bildschirm
************************************************************************
DATA :detail_tab TYPE STANDARD TABLE OF t_detail,
      tmp_data   TYPE STANDARD TABLE OF t_detail.

************************************************************************
* Containerreferenz zum Dynpro
************************************************************************
DATA container TYPE REF TO cl_gui_custom_container.

************************************************************************
* Protokollüberblick
************************************************************************
DATA protocol_overview TYPE REF TO cl_gui_alv_grid.

************************************************************************
* Protokolldetail am Bildschirm
************************************************************************
DATA protocol_detail TYPE REF TO cl_gui_alv_grid.

************************************************************************
* Typ für Positionsdaten Protokoll
************************************************************************
TYPES: BEGIN OF t_jksdprotocol.
         INCLUDE STRUCTURE jksdprotocol.
         TYPES:  index       TYPE sy-tabix, "Eintragsnummer
         update      TYPE char01,  "Updatekennzeichen
         netwr       TYPE netwr_ap,        " Potential value of release orders
         waerk       TYPE waerk,           " Currency
         matnr       TYPE matnr,           " Media Product
         identcode   TYPE ismidentcode,    " Identity code
         country     TYPE landx,           " Country
         postal_code TYPE pstlz,           " Postal code
         vendor      TYPE lifnr,           " Distributor
         plant       TYPE dwerk_ext,       " Plant
         ship_method TYPE vsbed_bez,       " Ship Methos
       END OF t_jksdprotocol.

************************************************************************
* Tabellentyp von t_jksdprotocol
************************************************************************
TYPES t_jksdprotocol_tab TYPE STANDARD TABLE OF t_jksdprotocol.

************************************************************************
* Tabelle mit Protokollen von der Datenbank
************************************************************************
DATA: head_tab  TYPE STANDARD TABLE OF jksdprotocolhead,
      item_tab  TYPE t_jksdprotocol_tab,
      state_tab TYPE STANDARD TABLE OF jksdlogorderst.

************************************************************************
* LogId für externe Selektion
************************************************************************
DATA logid TYPE jksdprotocolhead-logid.

************************************************************************
* Typ für die Zuordnung Kennzeichen "Herkunft der Meldung" -> textuelle
* Bezeichnung der Herkunft der Meldung
************************************************************************
TYPES: BEGIN OF t_dropdown_layer,
         value  TYPE rjksdshowprotocol-layer,
         text   TYPE text40,
         handle TYPE lvc_s_drop-handle,
       END OF t_dropdown_layer.

************************************************************************
* Tabelle für die Zuordnung Kennzeichen "Herkunft der Meldung" ->
* textuelle Bezeichnung der Herkunft der Meldung
************************************************************************
DATA dropdown_layer_tab TYPE STANDARD TABLE OF t_dropdown_layer.

************************************************************************
* Arbeitsbereich
************************************************************************
DATA dynnr_workarea TYPE sy-dynnr.

************************************************************************
* Konstanten für Arbeitsbereich
************************************************************************
CONSTANTS:
  con_screen_overview        TYPE sy-dynnr VALUE '0110',
  con_screen_detail          TYPE sy-dynnr VALUE '0120',
  con_screen_overview_detail TYPE sy-dynnr VALUE '0130'.

************************************************************************
* Typ für Funktionscodes
************************************************************************
TYPES: BEGIN OF t_fcode,
         fcode TYPE rsmpe-func,
       END OF t_fcode.

************************************************************************
* Tabellenzyp für Funktionscodes
************************************************************************
TYPES t_fcode_tab TYPE STANDARD TABLE OF tcode.

TYPES : BEGIN OF  ty_subtotal,                         " Summarized quantity data
          msgty TYPE jksdprotocol-msgty,
          netwr TYPE vbap-netwr,
        END OF ty_subtotal.

DATA : i_subtotal  TYPE SORTED TABLE OF ty_subtotal WITH UNIQUE KEY msgty INITIAL SIZE 0,
       st_subtotal TYPE ty_subtotal.
