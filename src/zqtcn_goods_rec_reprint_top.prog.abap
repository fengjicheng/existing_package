*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_GOODS_REC_REPRINT_F00
* REPORT DESCRIPTION:    Include for subroutine
* DEVELOPER:             Pavan Bandlapalli (PBANDLAPAL)
* CREATION DATE:         23-OCT-2017
* OBJECT ID:             E143
* TRANSPORT NUMBER(S):   ED2K908861
* DESCRIPTION:           This program is used for processing of the output
*                        type ZALE for account assignments maintained in
*                        ZCACONSTANT. This will posts the goods receipt
*                        and inbound Idoc is created.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_GOODS_REC_REPRINT_TOP
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
