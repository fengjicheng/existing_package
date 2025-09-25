*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_ZE225_STAGING_TOP
* PROGRAM DESCRIPTION:Include for data declarations
* DEVELOPER: GKAMMILI(Gopalakrishna K)
* CREATION DATE:   2019-12-04
* OBJECT ID:
* TRANSPORT NUMBER(S) ED2K916990
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
* DESCRIPTION:
*-------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ZE225_STAGING_TOP
*&---------------------------------------------------------------------*
*-- Types Declarations
TYPES:BEGIN OF ty_final.
        INCLUDE TYPE ze225_staging.
        TYPES:  log_type_desc TYPE zmsg_icon_desc,  "Message type with description
                stage_id_desc TYPE ddtext,  "File Type Description
      END OF ty_final.
TYPES:BEGIN OF ty_stage_id,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE ze225_staging-zintf_stage_id,
        high   TYPE ze225_staging-zintf_stage_id,
      END OF ty_stage_id.

*-- Internal tables and structures declarations
DATA: i_final    TYPE TABLE OF ty_final,                "Final internal table
      st_final   TYPE ty_final,                         "Final structure
      i_staging  TYPE TABLE OF ze225_staging,           "Internal table for ze225_staging
      i_fcat     TYPE slis_t_fieldcat_alv.              "Fieldcatalog internal table
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
DATA: st_stage_id TYPE ty_stage_id,
      ir_stage_id TYPE STANDARD TABLE OF ty_stage_id.
*DATA: i_stage_id_des  TYPE STANDARD TABLE OF dd07v,
DATA: i_stage_id_des  TYPE TABLE OF dd07v,
      st_stage_id_des TYPE dd07v.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267

*-- Variable declarations
DATA:v_zuid_upld TYPE ze225_staging-zuid_upld,          "Unique Identifier for Upload File
     v_zoid      TYPE ze225_staging-zoid,               "Order Identifier in Upload File
     v_zitem     TYPE ze225_staging-zitem,              "Item in Order in Upload File
     v_zuser     TYPE ze225_staging-zuser,              "User Name
     v_zbp       TYPE ze225_staging-zbp,                "Business Partner Number
     v_vbeln     TYPE ze225_staging-vbeln,              "Sales and Distribution Document Number
     v_zprcstat  TYPE ze225_staging-zprcstat,           "Processing Status
     v_zlogno    TYPE ze225_staging-zlogno,             "Application log: log number
     v_zcrtdat   TYPE ze225_staging-zcrtdat,            "Date record created on
     v_zcrttim   TYPE ze225_staging-zcrttim,            "Time when the record was created
     v_col_pos   TYPE sycucol.                          "Column position
