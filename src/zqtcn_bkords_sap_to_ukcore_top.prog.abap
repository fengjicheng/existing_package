*&---------------------------------------------------------------------*
*&  Include          ZQTCN_BKORDS_SAP_TO_UKCORE_TOP                    *
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_BKORDS_SAP_TO_UKCORE_TOP(Include Program)         *
* PROGRAM DESCRIPTION:Send Back Orders to UK core                      *
* DEVELOPER: Sivarami Reddy (SISIREDDY)                                *
* CREATION DATE:   03/02/2022                                          *
* OBJECT ID:  I0516                                                    *
* TRANSPORT NUMBER(S):ED2K926235                                       *
*----------------------------------------------------------------------*
************************************************************************
*Variables                                                             *
************************************************************************
DATA: v_file_path TYPE localfile, " Local file for upload/download
      v_log       TYPE string.    "
DATA :v_werks TYPE werks_d,
      v_mtart TYPE mara-mtart,
      v_matnr TYPE matnr,
      v_erdat TYPE erdat,
      v_auart TYPE auart,
      v_vkorg TYPE vkorg,
      v_vtweg TYPE vtweg,
      v_spart TYPE spart,
      v_bsart TYPE bsart,
      v_bukrs TYPE bukrs,
      v_ekorg TYPE ekorg,
      v_ekgrp TYPE ekgrp.
************************************************************************
*Constants                                                             *
************************************************************************
CONSTANTS:c_werks_default TYPE werks_d VALUE '5534',
          c_mtart_default TYPE mtart   VALUE 'ZBKP',
          c_bsart_default TYPE bsart   VALUE 'ZAUB',
          c_bukrs_default TYPE bukrs   VALUE '5501',
          c_ekorg_default TYPE ekorg   VALUE 'JWPO',
          c_ekgrp_default TYPE ekgrp   VALUE 'PB1',
          c_auart_default TYPE auart   VALUE 'ZAOR',
          c_vkorg_default TYPE vkorg   VALUE '5501',
          c_zean          TYPE ismidcodetype   VALUE 'ZEAN',
          c_e             TYPE char1   VALUE  'E',
          c_i             TYPE char1   VALUE  'I',
          c_bt            TYPE char2   VALUE  'BT'.
