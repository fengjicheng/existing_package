*&---------------------------------------------------------------------*
*& Report  ZQTC_BACK
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZQTC_BACK.

TABLES: jksdprotocol,
        jksdprotocolhead,
        rjksdprotocolsel,
        adr6.


*&---------------------------------------------------------------------*
*&  Include           RJKSDPROTOCOLTOP
*&---------------------------------------------------------------------*
************************************************************************
* Funktionscodes
************************************************************************
data okcode like sy-ucomm.
constants: con_fcode_select          type sy-ucomm value 'SELECT',
           con_fcode_save            type sy-ucomm value 'SAVE',
           con_fcode_refresh         type sy-ucomm value 'REFRESH',
           con_fcode_back            type sy-ucomm value 'BACK',
           con_fcode_cancel          type sy-ucomm value 'CANCEL',
           con_fcode_exit            type sy-ucomm value 'EXIT',
           con_fcode_show_overview   type sy-ucomm value 'SHOWOVER',
           con_fcode_hide_overview   type sy-ucomm value 'HIDEOVER',
           con_fcode_show_detail     type sy-ucomm value 'SHOWDETAIL',
           con_fcode_hide_detail     type sy-ucomm value 'HIDEDETAIL',
           con_fcode_longtext        type sy-ucomm value 'LONGTEXT',
           con_fcode_delete_protocol type sy-ucomm value 'DELETEPROT'.

************************************************************************
* Typ für Detaildaten Protokoll
************************************************************************
types: begin of t_detail.
        include structure rjksdshowprotocol.
types: logid              type jksdprotocolhead-logid,
       counter            type jksdprotocol-counter,
       cell_tab           type lvc_t_styl,
       icon               type char30,
       color(4)           type c,
       index              type sy-tabix,"Eintragsnummer
       dropdown_layer     type lvc_s_drop-handle, "Dropdownbox für
                                                  "Herkunft der Meldung
end of t_detail.

************************************************************************
* Tabellentyp zu t_detail
************************************************************************
types t_detail_tab type standard table of t_detail.

************************************************************************
* Typ für Übersicht Protokoll
************************************************************************
types: begin of t_overview.
        include structure rjksdshowprotocoloverview.
types: cell_tab type lvc_t_styl,
end of t_overview.

************************************************************************
* Tabelle mit Überblicksdaten am Bildschirm
************************************************************************
data overview_tab type standard table of t_overview.

************************************************************************
* Tabelle mit gelöschten Überblicksdaten am Bildschirm
************************************************************************
data delete_overview_tab type standard table of t_overview.

************************************************************************
* Tabelle mit Detaildaten am Bildschirm
************************************************************************
data :detail_tab type standard table of t_detail,
      tmp_data   TYPE STANDARD TABLE OF t_detail.

************************************************************************
* Containerreferenz zum Dynpro
************************************************************************
data container type ref to cl_gui_custom_container.

************************************************************************
* Protokollüberblick
************************************************************************
data protocol_overview type ref to cl_gui_alv_grid.

************************************************************************
* Protokolldetail am Bildschirm
************************************************************************
data protocol_detail type ref to cl_gui_alv_grid.

************************************************************************
* Typ für Positionsdaten Protokoll
************************************************************************
types: begin of t_jksdprotocol.
        include structure jksdprotocol.
types:  index  type sy-tabix,"Eintragsnummer
        update type char01,  "Updatekennzeichen
end of t_jksdprotocol.

************************************************************************
* Tabellentyp von t_jksdprotocol
************************************************************************
types t_jksdprotocol_tab type standard table of t_jksdprotocol.

************************************************************************
* Tabelle mit Protokollen von der Datenbank
************************************************************************
data: head_tab  type standard table of jksdprotocolhead,
      item_tab  type t_jksdprotocol_tab,
      state_tab type standard table of jksdlogorderst.

************************************************************************
* LogId für externe Selektion
************************************************************************
data logid type jksdprotocolhead-logid.

************************************************************************
* Typ für die Zuordnung Kennzeichen "Herkunft der Meldung" -> textuelle
* Bezeichnung der Herkunft der Meldung
************************************************************************
types: begin of t_dropdown_layer,
  value  type rjksdshowprotocol-layer,
  text   type text40,
  handle type lvc_s_drop-handle,
end of t_dropdown_layer.

************************************************************************
* Tabelle für die Zuordnung Kennzeichen "Herkunft der Meldung" ->
* textuelle Bezeichnung der Herkunft der Meldung
************************************************************************
data dropdown_layer_tab type standard table of t_dropdown_layer.

************************************************************************
* Arbeitsbereich
************************************************************************
data dynnr_workarea type sy-dynnr.

************************************************************************
* Konstanten für Arbeitsbereich
************************************************************************
constants:
 con_screen_overview        type sy-dynnr value '0110',
 con_screen_detail          type sy-dynnr value '0120',
 con_screen_overview_detail type sy-dynnr value '0130'.

************************************************************************
* Typ für Funktionscodes
************************************************************************
types: begin of t_fcode,
        fcode type rsmpe-func,
end of t_fcode.

************************************************************************
* Tabellenzyp für Funktionscodes
************************************************************************
types t_fcode_tab type standard table of tcode.

SELECTION-SCREEN BEGIN OF BLOCK contract WITH FRAME TITLE text-103.
SELECT-OPTIONS:
   vkorg          FOR jksdprotocol-vkorg,
   vtweg          FOR jksdprotocol-vtweg,
   spart          FOR jksdprotocol-spart,
   vkbur          FOR jksdprotocol-vkbur,
   vkgrp          FOR jksdprotocol-vkgrp,
   contract       FOR jksdprotocol-contract,
   item           FOR jksdprotocol-item.
SELECTION-SCREEN END OF BLOCK contract.

SELECTION-SCREEN BEGIN OF BLOCK bp WITH FRAME TITLE text-102.
SELECT-OPTIONS:
   ag             FOR jksdprotocol-ag,
   we             FOR jksdprotocol-we.
SELECTION-SCREEN END OF BLOCK bp.

SELECTION-SCREEN BEGIN OF BLOCK phasemdl WITH FRAME TITLE text-104.
SELECT-OPTIONS:
   phasemdl       FOR jksdprotocol-phasemdl,
   phasenbr       FOR jksdprotocol-phasenbr.
SELECTION-SCREEN END OF BLOCK phasemdl.

SELECTION-SCREEN BEGIN OF BLOCK issue WITH FRAME TITLE text-100.
SELECT-OPTIONS:
   issue          FOR jksdprotocol-issue.
SELECTION-SCREEN END OF BLOCK issue.

SELECTION-SCREEN BEGIN OF BLOCK mps WITH FRAME TITLE text-108.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: gen_mps AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 3(29) text-111 FOR FIELD gen_mps.
PARAMETERS: del_mps AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 35(29) text-112 FOR FIELD del_mps.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK mps.

SELECTION-SCREEN BEGIN OF BLOCK se WITH FRAME TITLE text-109.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: gen_se AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 3(29) text-111 FOR FIELD gen_se.
PARAMETERS: del_se AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 35(29) text-112 FOR FIELD del_se.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK se.

SELECTION-SCREEN BEGIN OF BLOCK creation WITH FRAME TITLE text-105.
SELECT-OPTIONS:
   date           FOR rjksdprotocolsel-generationdate,
   time           FOR jksdprotocolhead-generationtime,
   erfuser        FOR jksdprotocolhead-erfuser.
SELECTION-SCREEN END OF BLOCK creation.

SELECTION-SCREEN BEGIN OF BLOCK view WITH FRAME TITLE text-106.
PARAMETERS: logsp RADIOBUTTON GROUP gr  DEFAULT 'X',
            consp RADIOBUTTON GROUP gr.
SELECTION-SCREEN END OF BLOCK view.

SELECTION-SCREEN BEGIN OF BLOCK filter WITH FRAME TITLE text-107.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_warn AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 2(32) text-140 FOR FIELD p_warn.
PARAMETERS: p_sinfo AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: COMMENT 38(42) text-141 FOR FIELD p_sinfo.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK filter.

SELECTION-SCREEN BEGIN OF BLOCK email WITH FRAME TITLE text-900.
SELECT-OPTIONS: s_email FOR adr6-smtp_addr.         " email address
SELECTION-SCREEN END OF BLOCK email.

START-OF-SELECTION.

PERFORM select_data.

form select_data.

  data not_locked_tab type rjksdprotocollocked_tab.

BREAK-POINT.
* 1. Selektion der Daten
  perform do_selection_on_db(RJKSDPROTOCOL) tables   head_tab[]
                                      state_tab[]
                             changing item_tab
                                      not_locked_tab.

* 2. Aufbereiten der Kopfdaten zur Dynprodarstellung
  perform fill_overview_tab(RJKSDPROTOCOL) tables head_tab[]
                                   state_tab[]
                            using  not_locked_tab.

  IF sy-batch eq abap_true.
MESSAGE 'lkjhhdddddddddddd' TYPE 'I'.

ENDIF.
endform.
