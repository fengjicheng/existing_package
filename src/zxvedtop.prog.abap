*&---------------------------------------------------------------------*
*&  Include  ZXVEDTOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDTOP.
* PROGRAM DESCRIPTION: Global Top Include for Orders user exits includes.
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* CREATION DATE:
* OBJECT ID: Common to all order Interfaces that uses user exit.
* TRANSPORT NUMBER(S):  ED2K907888
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907834
* REFERENCE NO: CR#632( ERP-3372)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE:  2017-08-15
* DESCRIPTION: To convert the journal code populated in E1EDP19 to
*              SAP journal material.
*----------------------------------------------------------------------*
* REVISION NO: ED2K908513
* REFERENCE NO: E162 - CR#607
* DEVELOPER: Writtick Roy (WROY)
* DATE: 08-Dec-2017
* DESCRIPTION: Store Contract Start Dates for DB BOM
*----------------------------------------------------------------------*
* REVISION NO: ED2K912174
* REFERENCE NO: I0230 - CR#6142, CR#6122
* DEVELOPER: Kira Kumar Ravuri (KKRAVURI/KKR)
* DATE: 31-May-2018
* DESCRIPTION: Addition of new custom fields (PQ Deal Type, Cluster Type
*  and License Year) to Subscription Order Interface
*----------------------------------------------------------------------*
* REVISION NO: ED2K913701 ---------------------------------------------*
* REFERENCE NO: I0230 - CR#7480
* DEVELOPER: Kira Kumar Ravuri (KKRAVURI/KKR)
* DATE: 26-OCTOBER-2018
* DESCRIPTION: Addition of new custom fields (Cover Year, Cover Month)
* to Subscription Order Interface
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K913969                                             *
* REFERENCE NO: CR7318                                                 *
* DEVELOPER:    Prabhu(PTUFARAM)                                       *
* DATE:         11-Feb-2109                                            *
* DESCRIPTION:Customer shoulbe able to use Sub ref ID of Quote Number  *
*             while create subreneal orders(ZREW) through IDoc         *
*                                                                      *
* REVISION HISTORY-----------------------------------------------------*
CONSTANTS:
  c_qualf_012      TYPE edi_qualfo VALUE '012',
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
  c_medtyp_di      TYPE ismmediatype VALUE 'DI',
  c_mtart_zsbe     TYPE mtart VALUE 'ZSBE',
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
  c_devid_i0230    TYPE zdevid VALUE 'I0230',
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
  c_fld_idoc_data  TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]',
  c_idcodetyp_zjcd TYPE ismidcodetype VALUE 'ZJCD'.
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834

TYPES: BEGIN OF ty_item,
         posex     TYPE posex,      "Item Number
         mvgr1     TYPE mvgr1,      " Material Group 1
         mvgr3     TYPE mvgr3,      " Material Group 3
         zzpromo   TYPE zpromo,     " Promo Code
         zzartno   TYPE zartno,     " Article Number
         vbegdat   TYPE vbdat_veda, " Contract Start Date
         venddat   TYPE vndat_veda, " Contract End Date
         csd       TYPE zconstart,  " Content Start Date Override
         ced       TYPE zconend,    " Content End Date Override
         lsd       TYPE zlicstar,   " License Start Date Override
         led       TYPE zlicend,    " License End Date Override
*        Begin of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
         st_date   TYPE vbdat_veda, " Contract Start Date
*        End   of ADD:CR#607:WROY:08-DEC-2017:ED2K908513
* Begin Of: CR#6142 KKR20180531  ED2K912174
         zzdealtyp TYPE zzdealtyp,  " PQ Deal type
         zzclustyp TYPE zzclustyp,  " Cluster type
* End of: CR#6142 KKR20180531  ED2K912174
* BOC: CR#7480 KKRAVURI20181026  ED2K913701
         zzcovryr  TYPE zzcovryr,   " Cover Year
         zzcovrmt  TYPE zzcovrmt,   " Cover Month
* EOC: CR#7480 KKRAVURI20181026  ED2K913701
       END OF ty_item,
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
       BEGIN OF ty_mat_dtls_297,
         matnr        TYPE matnr,
         identcode    TYPE ismidentcode,
         mtart        TYPE mtart,
         extwg        TYPE extwg,
         ismmediatype TYPE ismmediatype,
       END OF ty_mat_dtls_297,
       BEGIN OF ty_extwg_dtls_297,
         matnr TYPE matnr,
         extwg TYPE extwg,
       END OF ty_extwg_dtls_297,
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
       BEGIN OF ty_qty_tabix_230,
         posnr TYPE posnr_va,    " Line Item Number
         tabix TYPE syst_tabix,  " Index
       END OF ty_qty_tabix_230,
* Begin Of: CR#6142 & CR#6122 KKR20180611  ED2K912174
       BEGIN OF ty_zcaconstant,
         devid  TYPE zdevid,
         param1 TYPE rvari_vnam,
         param2 TYPE rvari_vnam,
         srno   TYPE tvarv_numb,
         sign	  TYPE tvarv_sign,
         opti   TYPE tvarv_opti,
         low    TYPE salv_de_selopt_low,
         high   TYPE salv_de_selopt_high,
       END OF ty_zcaconstant,
       BEGIN OF ty_enh_ctrl,
         wricef_id   TYPE zdevid,
         ser_num     TYPE zsno,
         var_key     TYPE zvar_key,
         active_flag TYPE zactive_flag,
       END OF ty_enh_ctrl.
* End of: CR#6142 & CR#6122 KKR20180611  ED2K912174

DATA:
  i_item22                      TYPE TABLE OF ty_item INITIAL SIZE 0,
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
  i_idoc_data_297               TYPE edidd_tt,
  i_mat_dtls_297                TYPE TABLE OF ty_mat_dtls_297 INITIAL SIZE 0,
  i_extwg_dtls_297              TYPE TABLE OF ty_extwg_dtls_297 INITIAL SIZE 0,
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
  i_qty_tabix_230               TYPE TABLE OF ty_qty_tabix_230 INITIAL SIZE 0,
  i_qty_tabix_212_17            TYPE TABLE OF ty_qty_tabix_230 INITIAL SIZE 0,
  v_vbtyp_flg_230               TYPE char1,
* Begin Of: CR#6142 & CR#6122 KKR20180611  ED2K912174
  igt_zcaconstant               TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0,
  igt_enh_ctrl                  TYPE STANDARD TABLE OF ty_enh_ctrl INITIAL SIZE 0,
  igv_aflag_dealclus_type_i0230 TYPE zactive_flag, " Active/Inactive flag
  igv_actv_flag_lic_year_i0230  TYPE zactive_flag, " Active/Inactive flag
  igv_actv_flag_bill_date_i0230 TYPE zactive_flag, " Active/Inactive flag
* End Of: CR#6142 & CR#6122 KKR20180611  ED2K912174
* BOC: CR6310 KKRAVURI20181122  ED2K913920
  v_actv_flag_name_co_i0230     TYPE zactive_flag.
* EOC: CR6310 KKRAVURI20181122  ED2K913920

* BOC: CR#7318 KJAGANA20181129  ED2K913969
DATA :  v_quote TYPE ihrez.                        " Quote
*      * EOC: CR#7318 KJAGANA20181129  ED2K913969
