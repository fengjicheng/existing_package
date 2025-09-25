*&---------------------------------------------------------------------*
*&  Include  ZXVEDU06
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------
* PROGRAM NAME        : ZXVEDU06
* PROGRAM DESCRIPTION : To clear data objects after the idoc is processed.
* DEVELOPER           : PBANDLAPAL(Pavan Bandlapalli)
* CREATION DATE       : 15-Aug-2017
* OBJECT ID           : Common to Orders
* TRANSPORT NUMBER(S) : ED2K907889
* DESCRIPTION:          To clear the global variables after each idoc processing.
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K907834
* REFERENCE NO: CR#632( ERP-3372)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE:  2017-08-15
* DESCRIPTION: To convert the journal code populated in E1EDP19 to
*              SAP journal material.
*-----------------------------------------------------------------------*

CLEAR: i_item22,
       v_vbtyp_flg_230,
       i_qty_tabix_230,
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
       i_mat_dtls_297,
       i_idoc_data_297,
       i_extwg_dtls_297,
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
       i_qty_tabix_212_17.
