*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SELECTION_SCREEN_R112 (Include Program)
* PROGRAM DESCRIPTION: define additional selection Screen fields
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

REPORT  zqtcr_rjksdprotocol.

TABLES: jksdprotocol,
        jksdprotocolhead,
        rjksdprotocolsel,
        adr6.

*----------------------------------------------------------------------*
* Selection-Screen
*----------------------------------------------------------------------*
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

*SELECTION-SCREEN BEGIN OF BLOCK view WITH FRAME TITLE text-106.
*PARAMETERS: logsp RADIOBUTTON GROUP gr,
*            consp RADIOBUTTON GROUP gr DEFAULT 'X'.
PARAMETERS: consp TYPE xfeld DEFAULT 'X' NO-DISPLAY,
            logsp TYPE xfeld NO-DISPLAY.
*SELECTION-SCREEN END OF BLOCK view.

SELECTION-SCREEN BEGIN OF BLOCK filter WITH FRAME TITLE text-107.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_warn AS CHECKBOX.
SELECTION-SCREEN: COMMENT 2(32) text-140 FOR FIELD p_warn.
PARAMETERS: p_sinfo AS CHECKBOX.
SELECTION-SCREEN: COMMENT 38(42) text-141 FOR FIELD p_sinfo.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK filter.

* Begin of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
SELECTION-SCREEN BEGIN OF BLOCK email WITH FRAME TITLE text-900.
SELECT-OPTIONS: s_email FOR adr6-smtp_addr.         " email address
SELECTION-SCREEN END OF BLOCK email.
* End of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *

INCLUDE zqtcn_rjksdprotocoltop.
INCLUDE zqtcn_rjksdprotocolf02.
INCLUDE zqtcn_rjksdprotocolo01.
INCLUDE zqtcn_rjksdprotocolf01.
INCLUDE zqtcn_rjksdprotocoli01.

*----------------------------------------------------------------------*
* Begin Initialisation part
*----------------------------------------------------------------------*
INITIALIZATION.
  DATA: from TYPE jksenip-shipping_date,
        to   TYPE jksenip-shipping_date.

* ParameterIDs lesen
  GET PARAMETER ID 'RJKSDPROTOCOL_FROM' FIELD from.
  GET PARAMETER ID 'RJKSDPROTOCOL_TO'   FIELD to.

* Datümer vorbelegen
  IF from IS INITIAL.
    from = sy-datum - 30.
  ENDIF.

  IF to IS INITIAL.
    to = sy-datum.
  ENDIF.

  CALL FUNCTION 'ISM_SD_DATE_BETWEEN_TO_RANGE'
    EXPORTING
      in_date_from = from
      in_date_to   = to
    IMPORTING
      range_tab    = date[].

*----------------------------------------------------------------------*
* Begin Selection part
*----------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: no_drilldown TYPE lvc_s_col-fieldname,
        overview     TYPE t_overview,
        actvt        TYPE tact-actvt.

*  actvt = '03'.
*  AUTHORITY-CHECK OBJECT 'J_ORDERGEP'
*    ID 'ACTVT' FIELD actvt.
*  IF sy-subrc <> 0.
*    MESSAGE s154(jksdprotocol).
*    EXIT.
*  ENDIF.
  IF gen_mps IS INITIAL AND
       gen_se  IS INITIAL AND
       del_mps IS INITIAL AND
       del_se IS INITIAL.
    MESSAGE s110(jksdcontract).
    EXIT.
  ENDIF.

* Begin of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
  INCLUDE zqtcn_validation_sub_r112 IF FOUND.
* End of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
  PERFORM select_data.

  IF NOT logsp IS INITIAL.
    PERFORM show_data_overview_on_screen.
  ELSE.
    PERFORM show_detail_on_screen USING overview
                                        no_drilldown.
  ENDIF.

END-OF-SELECTION.

* Begin of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
  IF sy-batch = abap_true.
    INCLUDE zqtcn_bg_process_sub_r112 IF FOUND.              " Subroutine for email & excel genaration
  ENDIF.
* End of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
