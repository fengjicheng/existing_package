*&---------------------------------------------------------------------*
*&  Include           ZQTCR_PAYMENT_BLOCK_AUTOMATTOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_PAYMENT_BLOCK_AUTOMATTOP
* PROGRAM DESCRIPTION: Top include for ZQTCE_PAYMENT_BLOCK_AUTO_E247
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE: 6/22/2020
* OBJECT ID: E247
* TRANSPORT NUMBER(S): ED2K918595
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPE-POOLS : slis.
TABLES : bsad,vbak,adr6.
TYPES : BEGIN OF ty_bsad,
          bukrs TYPE  bukrs,
          kunnr	TYPE kunnr,
          umsks	TYPE umsks,
          umskz	TYPE umskz,
          augdt	TYPE augdt,
          augbl	TYPE augbl,
          zuonr	TYPE dzuonr,
          gjahr	TYPE gjahr,
          belnr	TYPE belnr_d,
*          buzei  TYPE buzei,
          blart TYPE blart,
        END OF ty_bsad,
        BEGIN OF ty_vbak,
          vbeln TYPE vbeln,
          auart TYPE auart,
          kunnr TYPE kunnr,
          lifsk TYPE lifsk,
          augru TYPE augru,
        END  OF ty_vbak,
        BEGIN OF ty_vbfa,
          vbelv	  TYPE vbeln_von,
          posnv	  TYPE posnr_von,
          vbeln	  TYPE vbeln_nach,
          posnn	  TYPE posnr_nach,
          vbtyp_n	TYPE vbtyp_n,
        END OF ty_vbfa,
        BEGIN OF ty_final,
          vbelnc   TYPE vbeln_va,
          auart    TYPE auart,
          vbelno   TYPE vbeln_va,
          auart2   TYPE auart,
          vbelni   TYPE vbeln_vf,
          msg_type TYPE c,
          message(200)  TYPE c,
        END OF ty_final.
DATA : i_bsad           TYPE STANDARD TABLE OF ty_bsad,
       i_vbak           TYPE STANDARD TABLE OF ty_vbak,
       i_vbak_ord       TYPE STANDARD TABLE OF ty_vbak,
       i_vbfa           TYPE STANDARD TABLE OF ty_vbfa,
       i_vbfa_ord       TYPE STANDARD TABLE OF ty_vbfa,
       i_return         TYPE STANDARD TABLE OF bapiret2,
       i_final          TYPE STANDARD TABLE OF ty_final,
       i_fcat           TYPE slis_t_fieldcat_alv,
       i_attach         TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE,
       i_attachment     LIKE solisti1 OCCURS 0 WITH HEADER LINE,
       i_packing_list   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
       i_receivers      LIKE somlreci1 OCCURS 0 WITH HEADER LINE,
       st_fcat          TYPE slis_fieldcat_alv,
       st_final         TYPE ty_final,
       st_vbfa          TYPE ty_vbfa,
       st_vbak          TYPE ty_vbak,
       st_bsad          TYPE ty_bsad,
       st_return        TYPE bapiret2,
       st_order_headerx TYPE bapisdh1x,
       st_interface     TYPE zcainterface.

CONSTANTS : c_u     TYPE c VALUE 'U',
            c_m     TYPE c VALUE 'M',
            c_g     TYPE c VALUE 'G',
            c_c     TYPE c VALUE 'C',
            c_s     TYPE c VALUE 'S',
            c_e     TYPE c VALUE 'E',
            c_i     TYPE c VALUE 'I',
            c_int   TYPE char3 VALUE 'INT',
            c_xls   TYPE char4 VALUE 'XLS',
            c_raw   TYPE char3 VALUE 'RAW',
            c_ep1   TYPE sy-sysid    VALUE 'EP1',
            c_devid TYPE zdevid    VALUE 'E247'.
