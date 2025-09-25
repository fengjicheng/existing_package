*&---------------------------------------------------------------------*
*& Report  ZQTCE_GOODS_REC_OUTBOUND
*&
*&---------------------------------------------------------------------*
* REPORT NAME:           ZQTCE_GOODS_REC_OUTBOUND
* DEVELOPER:             VDPATABALL
* CREATION DATE:         04/28/2020
* OBJECT ID:
* TRANSPORT NUMBER(S):   ED2K918070
* DESCRIPTION:           This program is used for processing of the output
*                        type ZWMB for account assignments maintained in
*                        ZCACONSTANT. This will posts the goods receipt
*                        and Outbound Idoc is created.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&  Include           ZQTCN_GOODS_REC_OUTBOUND_TOP
*&---------------------------------------------------------------------*
TABLES: nast.

CONSTANTS: c_hyphen        TYPE char1 VALUE '-',
           c_bwart_zale    TYPE rvari_vnam VALUE 'BWART_ZALE',
           c_gm_code_zale  TYPE rvari_vnam VALUE 'GM_CODE_ZALE',
           c_devid_e143    TYPE zdevid     VALUE 'E143',
           c_msgtyp_abt    TYPE bapi_mtype VALUE 'A',
           c_msgtyp_err    TYPE bapi_mtype VALUE 'E',
           c_STRG_LOC_ZALE TYPE rvari_vnam VALUE 'STRG_LOC_ZALE'.

TYPES:
  tt_edidd             TYPE STANDARD TABLE OF edidd INITIAL SIZE 0. " Data record (IDoc)

DATA: v_retcode            TYPE sy-subrc,                               " ABAP System Field: Return Code of ABAP Statements
      v_zca_lgort          TYPE lgort_d,
      v_zca_gm_code        TYPE gm_code,
      i_bwart_zale         TYPE ZCAT_CONSTANTS.
