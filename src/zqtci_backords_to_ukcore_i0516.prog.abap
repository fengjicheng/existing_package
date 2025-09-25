*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCI_BORDERS_SAP_TO_UKC_I0516 (Main Program)           *
* PROGRAM DESCRIPTION:Back Orders from SAP to UK Core                  *
* DEVELOPER: SivaramiReddy (SISIREDDY)                                 *
* CREATION DATE:   04/22/2022                                          *
* OBJECT ID:  I0516.1                                                  *
* TRANSPORT NUMBER(S):ED2K926235                                       *
*----------------------------------------------------------------------*
REPORT zqtci_bkords_sap_to_ukco_i0516 NO STANDARD PAGE HEADING
                                      MESSAGE-ID zqtc_r2.
*INCLUDES--------------------------------------------------------------*
INCLUDE zqtcn_bkords_sap_to_ukcore_top IF FOUND.
INCLUDE zqtcn_bkords_sap_to_ukcore_sel IF FOUND.
INCLUDE zqtcn_bkords_sap_to_ukcore_sub IF FOUND.
***********************************************************************
*    Object declaration                                               *
***********************************************************************
DATA:o_sel  TYPE REF TO lcl_sel,
     o_main TYPE REF TO lcl_main.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
* Create Instance Of Class
  CREATE OBJECT:o_sel,
                o_main    EXPORTING ref_sel = o_sel.

*** Get the File Path for Application Server
  CALL METHOD lcl_main=>get_file_path
    IMPORTING
      ex_file_path = v_file_path.
*Mandatory: Order Creation Date – from (60 days from system date) | To (System date)
*as <60 days from the system date & then, later can be reduced to <30 days from system date as needed
  s_erdat-high = sy-datum.
  s_erdat-low  = sy-datum - 60.
  s_erdat-sign   = c_i.
  s_erdat-option = c_bt.
  APPEND s_erdat.

*====================================================================*
* AT SELECTION-SCREEN.
*====================================================================*
AT SELECTION-SCREEN.
*Valodate Check Boxes for Which Documents need to send UK Core
  o_sel->check_docs( EXPORTING ch_pos = ch_pos ch_sos = ch_sos ).

*Valodate the Plant
AT SELECTION-SCREEN ON s_werks.
  o_sel->check_werks( EXPORTING s_werks = s_werks[] ).
*Valodate the Material Type
AT SELECTION-SCREEN ON s_mtart.
  o_sel->check_mtart( EXPORTING s_mtart = s_mtart[] ).
*Valodate the Material Number
AT SELECTION-SCREEN ON s_matnr.
  o_sel->check_matnr( EXPORTING s_matnr = s_matnr[] ).
* Valodate the Creation Date
AT SELECTION-SCREEN ON s_erdat.
  o_sel->check_erdat( EXPORTING s_erdat = s_erdat[] ).
*Valodate the Stock Transport Orders Type
AT SELECTION-SCREEN ON s_bsart.
  o_sel->check_bsart( EXPORTING ch_pos = ch_pos s_bsart = s_bsart[] ).
*Valodate the  Company Code
AT SELECTION-SCREEN ON s_bukrs.
  o_sel->check_bukrs( EXPORTING ch_pos = ch_pos s_bukrs = s_bukrs[] ).
*Valodate the Purchasing Organization
 AT SELECTION-SCREEN ON s_ekorg.
  o_sel->check_ekorg( EXPORTING ch_pos = ch_pos s_ekorg = s_ekorg[] ).
*Valodate the Purchasing Group
 AT SELECTION-SCREEN ON s_ekgrp.
  o_sel->check_ekgrp( EXPORTING ch_pos = ch_pos s_ekgrp = s_ekgrp[] ).
*Valodate the Sales Orders Type
 AT SELECTION-SCREEN ON s_auart.
  o_sel->check_auart( EXPORTING ch_sos = ch_sos s_auart = s_auart[] ).
*Valodate the Sales Organization
 AT SELECTION-SCREEN ON s_vkorg.
  o_sel->check_vkorg( EXPORTING ch_sos = ch_sos s_vkorg = s_vkorg[] ).
*Valodate the Distribution Channel
 AT SELECTION-SCREEN ON s_vtweg.
  o_sel->check_vtweg( EXPORTING ch_sos = ch_sos s_vtweg = s_vtweg[] ).
*Valodate the Division
 AT SELECTION-SCREEN ON s_spart.
  o_sel->check_spart( EXPORTING ch_sos = ch_sos s_spart = s_spart[] ).

*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
  o_sel->s_matnr  = s_matnr[] . "Material Number
  o_sel->s_werks  = s_werks[] .
  o_sel->s_mtart  = s_mtart[] .
  o_sel->s_erdat  = s_erdat[] .
  o_sel->ch_pos   = ch_pos .
  o_sel->s_bsart  = s_bsart[] .
  o_sel->s_bukrs  = s_bukrs[] .
  o_sel->s_ekorg  = s_ekorg[] .
  o_sel->s_ekgrp  = s_ekgrp[] .
  o_sel->ch_sos   = ch_sos .
  o_sel->s_auart  = s_auart[] .
  o_sel->s_vkorg  = s_vkorg[] .
  o_sel->s_vtweg  = s_vtweg[] .
  o_sel->s_spart  = s_spart[] .

*** Call Method to Back Orders  file to Application Server where UK Core Team will pick the file
  CALL METHOD o_main->send_backordersfile_to_ukcore.
