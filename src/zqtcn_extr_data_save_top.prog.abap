*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EXTR_DATA_SAVE_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_EXTR_DATA_SAVE
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:        ZQTCR_EXTR_DATA_SAVE
*& PROGRAM DESCRIPTION: Program to update Custom table from extractor data
*& DEVELOPER:           Krishna & Rajkumar Madavoina
*& CREATION DATE:       04/20/2021
*& OBJECT ID:
*& TRANSPORT NUMBER(S): ED2K923107
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES:BEGIN OF ty_stxh,
        tdobject    TYPE stxh-tdobject,
        tdname      TYPE stxh-tdname,
        tdid        TYPE stxh-tdid,
        tdspras     TYPE stxh-tdspras,
        tdfuser     TYPE stxh-tdfuser,
        tdfdate     TYPE stxh-tdfdate,
        tdluser     TYPE stxh-tdluser,
        tdldate     TYPE stxh-tdldate,
        dltdate     TYPE sy-datum,
        vbeln       TYPE vbap-vbeln,
        posnr       TYPE vbap-posnr,
        zvalue(256) TYPE c,
        auart       TYPE vbak-auart,
      END OF ty_stxh,
      BEGIN OF ty_stxh1,
        tdobject TYPE stxh-tdobject,
        tdname   TYPE stxh-tdname,
        tdid     TYPE stxh-tdid,
        tdspras  TYPE stxh-tdspras,
        tdfuser  TYPE stxh-tdfuser,
        tdfdate  TYPE stxh-tdfdate,
        tdluser  TYPE stxh-tdluser,
        tdldate  TYPE stxh-tdldate,
      END OF ty_stxh1.


DATA:gt_fin  TYPE STANDARD TABLE OF ty_stxh1,
     gt_data TYPE STANDARD TABLE OF zqtc_txt_ext,
     gd_head TYPE thead,
     gt_line TYPE STANDARD TABLE OF tline.

DATA:gv_date        TYPE zqtc_txt_ext-dltdate,
     gr_tdobj_vbbk  TYPE RANGE OF tdobject,
     gr_tdobj_vbbp  TYPE RANGE OF tdobject,
     gr_tdid_vbbp   TYPE RANGE OF tdid,
     gr_tdid_vbbk   TYPE RANGE OF tdid,
     gv_vbeln       TYPE vbap-vbeln,
     gv_posnr       TYPE vbap-posnr,
     gv_auart       TYPE zqtc_txt_ext-auart,
     gv_zcainterface TYPE zcainterface.

CONSTANTS: gc_eq   TYPE c LENGTH 2 VALUE 'EQ',
           gc_bt   TYPE c LENGTH 2 VALUE 'BT',
           gc_i    TYPE c LENGTH 1 VALUE 'I',
           gc_e    TYPE c LENGTH 1 VALUE 'E',
           gc_vbbp TYPE c LENGTH 4 VALUE 'VBBP',
           gc_vbbk TYPE c LENGTH 4 VALUE 'VBBK',
           gc_04   TYPE c LENGTH 4 VALUE '0004',
           gc_12   TYPE c LENGTH 4 VALUE '0012',
           gc_17   TYPE c LENGTH 4 VALUE '0017',
           gc_19   TYPE c LENGTH 4 VALUE '0019',
           gc_20   TYPE c LENGTH 4 VALUE '0020',
           gc_43   TYPE c LENGTH 4 VALUE '0043',
           gc_50   TYPE c LENGTH 4 VALUE '0050',
           gc_devid   TYPE zdevid     VALUE 'R139',
           gc_runtime TYPE RVARI_VNAM VALUE 'RUN DATE-1'.
