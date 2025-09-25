*-------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_NEW_PROJECTMASTER_JANIS
* PROGRAM DESCRIPTION: Create Maintain Media Product Master Records
* This include has been called inside program ZQTCE_NEW_PROJECTMASTER_JANIS,
* all the global variables has declared inside this.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-02-02
* OBJECT ID:E148
* TRANSPORT NUMBER(S):ED2K904337
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908492
* REFERENCE NO:  DM-1479
* DEVELOPER:     Agudurkhad
* DATE:  2018-09-19
* DESCRIPTION:
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PROJECTMASTER_JANIS_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S
*&---------------------------------------------------------------------*

TYPES:  BEGIN OF ty_mara,
          matnr           TYPE matnr,                                        " Material number
          ersda           TYPE ersda,                                        "Created On
          laeda	          TYPE laeda,                                        " Date of Last Change
          mtart           TYPE mtart,                                        "Material type
          ismhierarchlevl TYPE ismhierarchlvl,                               " Hierarchy Level
          ismrefmdprod    TYPE ismrefmdprod,                                 " Higher-Level Media Product
          ismmediatype    TYPE ismmediatype,                                 " Media Type
          ismpubldate     TYPE ismpubldate,                                  " Publication Date
          ismorgkey       TYPE ismorgkey,                                    " Organization key
          ismcopynr       TYPE ismheftnummer,                                " Copy Number of Media Issue
          ismyearnr       TYPE ismjahrgang,                                  " Media issue year number
          isminitshipdate TYPE ismerstverdat,                                " Initial Shipping Date
          extwg	          TYPE extwg,                                        " External Material Group   DM-1479
          maktx           TYPE maktx,                                        " Material Description (Short Text)
          idcodetype      TYPE ismidcodetype,
          identcode	      TYPE ismidentcode,                                 " Identification Code
          prctr           TYPE prctr,                                        " Profit Center
          dwerk           TYPE dwerk_ext,                                    " Delivering Plant (Own or External)
        END OF ty_mara,

        BEGIN OF ty_csks,
          kokrs TYPE kokrs,                                                  " Controlling Area
          kostl TYPE kostl,                                                  " Cost Center
          datbi TYPE datbi,                                                  " Valid To Date
          bukrs TYPE bukrs,                                                  " Company Code
          prctr TYPE prctr,                                                  " Profit Center
        END OF ty_csks,

        BEGIN OF ty_t001,
          bukrs TYPE bukrs,                                                  "Company Code
          waers TYPE waers,                                                  "Currency Key
        END OF ty_t001,

        BEGIN OF ty_message,
          pspid   TYPE ps_pspid,                                             " Project Definition
          message TYPE char255,                                              " Message of type CHAR255
          matnr   TYPE matnr,                                                " Material Number
        END OF ty_message,

        BEGIN OF ty_prps,
          pspnr TYPE ps_posnr,                                               " WBS Element
          posid TYPE ps_posid,                                               " Work Breakdown Structure Element (WBS Element)
          psphi TYPE ps_psphi,                                               " Current number of the appropriate project
          pbukr	TYPE ps_pbukr,
          prctr	TYPE prctr,
          stufe TYPE ps_stufe,                                               " Level in Project Hierarchy
          slwid TYPE slwid,                                                  " Key word ID for user-defined fields
          zzmpm TYPE zzmpmissu,                                              " MPM Issue
        END OF ty_prps,

        BEGIN OF ty_proj_name,
          matnr     TYPE matnr,                                              " Material number
          ismcopynr TYPE ismheftnummer,                                      " Copy Number of Media Issue
          proj_name TYPE zlegproj,                                           " Legacy Project Number
        END OF ty_proj_name,

        BEGIN OF ty_proj,
          pspnr      TYPE ps_intnr,                                          " Project definition (internal)
          zzleg_proj TYPE zlegproj,                                          " Legacy Project Number
        END OF ty_proj,

        BEGIN OF ty_marc,
          matnr TYPE matnr,                                                  " Material Number
          werks TYPE werks_d,                                                " Plant
          prctr TYPE prctr,                                                  " Profit Center
        END OF ty_marc,

        BEGIN OF ty_mvke,
          matnr TYPE matnr,                                                  " Material Number
          vkorg TYPE vkorg,                                                  " Sales Organization
          vtweg TYPE vtweg,                                                  " Distribution Channel
          dwerk TYPE dwerk_ext,                                              " Delivering Plant (Own or External)
        END OF ty_mvke,

        BEGIN OF ty_makt,
          matnr      TYPE matnr,                                             " Material Number
          spras      TYPE spras,                                             " Language Key
          maktx      TYPE maktx,                                             " Material Description (Short Text)
          idcodetype TYPE ismidcodetype,
          identcode	 TYPE ismidentcode,                                      " Identification Code
        END OF ty_makt,

        BEGIN OF ty_detrm_costc,
*          prctr  TYPE prctr,                               "DM-1479
          extwg TYPE extwg,                                 "DM-1479
          werks	TYPE werks_d,
          kostl	TYPE kostl,
        END OF ty_detrm_costc,

        tt_makt        TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
        tt_mara        TYPE STANDARD TABLE OF ty_mara    INITIAL SIZE 0,
        tt_marc        TYPE STANDARD TABLE OF ty_marc    INITIAL SIZE 0,
        tt_mvke        TYPE STANDARD TABLE OF ty_mvke    INITIAL SIZE 0,
        tt_csks        TYPE STANDARD TABLE OF ty_csks    INITIAL SIZE 0,
        tt_t001        TYPE STANDARD TABLE OF ty_t001    INITIAL SIZE 0,
        tt_prps        TYPE STANDARD TABLE OF ty_prps          INITIAL SIZE 0,
        tt_proj_name   TYPE STANDARD TABLE OF ty_proj_name     INITIAL SIZE 0,
        tt_proj        TYPE STANDARD TABLE OF ty_proj          INITIAL SIZE 0,
        tt_detrm_costc TYPE STANDARD TABLE OF ty_detrm_costc INITIAL SIZE 0. " Determine cost center on the basis of profit center n Plant

*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA : i_message TYPE STANDARD TABLE OF ty_message INITIAL SIZE 0.

*&--------------------------------------------------------------------*
*& V A R I A B L E
*&--------------------------------------------------------------------*
DATA : v_matnr        TYPE matnr,    " Material Number
       v_success      TYPE flag,     " General Flag
       v_ismrefmdprod	TYPE ismrefmdprod,
       v_mtart        TYPE mtart,    " Material Type
       v_old_wbs2     TYPE ps_posid, " Work Breakdown Stru
       v_old_wbs      TYPE ps_posid. " Work Breakdown Structure Element (WBS Element)

*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS :  c_scrgrp     TYPE char3           VALUE 'CG1',  " Scrgrp of type CHAR3
             c_e          TYPE bapi_mtype      VALUE 'E',    " Message type: S Success, E Error, W Warning, I Info, A Abort
             c_sign_incld TYPE ddsign          VALUE 'I',    "Sign: (I)nclude
             c_opti_equal TYPE ddoption        VALUE 'EQ',   "Option: (EQ)ual
             c_opti_betwn TYPE ddoption        VALUE 'BT',   "Option: (B)e(T)ween
             c_mtart_zjip TYPE mtart           VALUE 'ZJIP', "Material Type: ZJIP
             c_mtart_zjid TYPE mtart           VALUE 'ZJID', "Material Type: ZJID
             c_idcodetype TYPE ismidcodetype   VALUE 'JRNL',
             c_devid_e148 TYPE zdevid          VALUE 'E148'. "Development ID: E148
