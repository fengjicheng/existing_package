*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_INVRECON_DEL_TOP
* PROGRAM DESCRIPTION: To Delete Data from Inventory Recon table
*                      ZQTC_INVEN_RECON based on
*                      Adjustment Type
*                      Material No
*                      Date
*                      Plant
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 21/03/2019
* OBJECT ID: RITM0126734
* TRANSPORT NUMBER(S): ED1K909853
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_INVRECON_DEL_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.  " SLIS contains all the ALV data types

***Global data declaration
data : v_ADJTYP type ZQTC_INVEN_RECON-ZADJTYP, "Adjustment Type
       v_MATNR  type ZQTC_INVEN_RECON-MATNR,   "Material Number
       v_ZDATE  type ZQTC_INVEN_RECON-ZDATE,   "Transactional date
       v_WERKS  type ZQTC_INVEN_RECON-WERKS,   "Delivering Plant

***Internal table Declaration
       i_invrecon  type STANDARD TABLE OF ZQTC_INVEN_RECON,

***Work Area Declaration
       st_invrecon type ZQTCLOCKBOX_UPD,

*** ALV Declarations
       i_fieldcat  TYPE slis_t_fieldcat_alv,
       st_fieldcat TYPE slis_fieldcat_alv.
