*&---------------------------------------------------------------------*
*&  Include           ZQTCN_APL_DEL_IF_GR_ZI_I0510_2
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_APL_DEL_IF_GR_ZI_I0510_2                   *
* PROGRAM DESCRIPTION : Include: To Post GR for Zero Inventory Items     *
* DEVELOPER           : SRAMASUBRA (Sankarram R)                         *
* CREATION DATE       : 2022-04-29                                       *
* OBJECT ID           : I0510.2/EAM-8766                                 *
* TRANSPORT NUMBER(S) : ED2K927114                                       *
*------------------------------------------------------------------------*

*========================================================================*
*                         TYPES DECLARATIONS                             *
*========================================================================*
TYPES:
  BEGIN OF ty_delv_conf,
    vbeln   TYPE  vbeln,    "Delivery NO
    posnr   TYPE  posnr,    "Delivery Item No
    matnr   TYPE  matnr,    "Material No
    lfimg   TYPE  lfimg,    "Delivery Quantity
  END OF ty_delv_conf.

*========================================================================*
*                         VARIABLES DECLARATIONS                         *
*========================================================================*
DATA:
  lst_e1edl20         TYPE        e1edl20,                "Segment: E1ED120
  lst_e1edl24         TYPE        e1edl24,                "Segment: E1ED124

  lst_del_con         TYPE        ty_delv_conf,           "Idoc: Delv. Conf. Info
  lst_gds_mvt_hdr     TYPE        bapi2017_gm_head_01,    "Goods Mvmt. Header
  lst_gds_mvt_cde     TYPE        bapi2017_gm_code,       "Goods Mvmt. Code
  lst_gds_mvt_itm     TYPE        bapi2017_gm_item_create,"Goods Mvmt. Item details

  li_werks            TYPE STANDARD TABLE OF selopt,      "Range for Plants
  li_gds_mvt_itm      TYPE STANDARD TABLE OF bapi2017_gm_item_create,
                                                          "Goods Mvmt. Item
  li_return           TYPE TABLE OF bapiret2,             "BAPI Return Param
  li_del_con          TYPE STANDARD TABLE OF ty_delv_conf "Idoc: Delv. Conf. Info
  .


*========================================================================*
*                         CONSTANTS DECLARATIONS                         *
*========================================================================*

CONSTANTS:
  lc_eq            TYPE char2      VALUE 'EQ',       "EQ
  lc_e1edl20       TYPE edilsegtyp VALUE 'E1EDL20',  "Segment: E1EDL20
  lc_e1edl24       TYPE edilsegtyp VALUE 'E1EDL24',  "Segment: E1EDL24
  lc_gm_code       TYPE rvari_vnam VALUE 'GM_CODE',  "GM Code
  lc_mvmt_typ      TYPE rvari_vnam VALUE 'BWART',    "Goods Mvmt Type
  lc_no_atp        TYPE rvari_vnam VALUE 'MTVFP'.    "APL NO ATP - ZI
  .


*Get Constants Info for Dev Id - I0510.2
 CALL METHOD zca_utilities=>get_constants
   EXPORTING
     im_devid     = lc_i0510_2
     im_activate  = abap_on
   IMPORTING
     et_constants = DATA(li_constants)
     .

 IF line_exists( li_constants[ param1 = lc_gm_code ] ).
   "GM Code
   DATA(lv_gm_code) = CONV gm_code(
                           li_constants[ param1 = lc_gm_code ]-low ).
 ENDIF.

 IF line_exists( li_constants[ param1 = lc_mvmt_typ ] ).
   "Movement Type
   DATA(lv_mvmt_typ) = CONV bwart(
                            li_constants[ param1 = lc_mvmt_typ ]-low ).
 ENDIF.

 IF line_exists( li_constants[ param1 = lc_no_atp ] ).
   "ATP Indicator
   DATA(lv_mtvfp) = CONV mtvfp(
                         li_constants[ param1 = lc_no_atp ]-low ).
 ENDIF.

*Build Delivery & Line Item Info from Idoc into an Int. Table
 LOOP AT idoc_data ASSIGNING FIELD-SYMBOL(<lfst_data>)
   WHERE docnum = idoc_control-docnum.
   CASE <lfst_data>-segnam.
     WHEN lc_e1edl20.
       lst_e1edl20 = <lfst_data>-sdata.
       DATA(lv_delv_no)  = lst_e1edl20-vbeln.
     WHEN lc_e1edl24.
       lst_e1edl24 = <lfst_data>-sdata.

       lst_del_con-vbeln = lv_delv_no.
       lst_del_con-posnr = lst_e1edl24-posnr.
       lst_del_con-matnr = lst_e1edl24-matnr.
       lst_del_con-lfimg = lst_e1edl24-lfimg.

       APPEND lst_del_con TO li_del_con.
       CLEAR: lst_del_con.
     WHEN OTHERS.
       CLEAR:
         lst_del_con,
         lst_e1edl24,
         lst_e1edl20.
   ENDCASE.
 ENDLOOP.

 IF li_del_con IS NOT INITIAL.
*  Get Delivery Line Item Info
   SELECT
       vbeln,    "Delivery No
       posnr,    "Delivery Item
       matnr,    "Material No
       werks,    "Plant
       lgort,    "Storage Location
       lfimg,    "Quantity
       vrkme     "Sales Unit
     INTO TABLE @DATA(li_lips)
     FROM lips
     FOR ALL ENTRIES IN @li_del_con
     WHERE vbeln = @li_del_con-vbeln
     AND   posnr = @li_del_con-posnr.
   IF sy-subrc = 0.
     SORT li_lips BY vbeln posnr.
     "Building Range for Plant to be passed to MARC
*     li_werks = VALUE #( FOR lst_value IN li_lips
*                             ( sign   = sy-abcde+8(1) "I
*                               option = lc_eq
*                               low    = lst_value-werks ) ).
*     SORT li_werks BY low.
*     DELETE ADJACENT DUPLICATES FROM li_werks
*       COMPARING low.
   ENDIF.

*  Get Material Plant Info
   SELECT
       matnr,  "Material No
       werks,  "Plant
       mtvfp   "NO ATP Indicator
     FROM marc
     INTO TABLE @DATA(li_marc)
     FOR ALL ENTRIES IN @li_del_con
     WHERE matnr =  @li_del_con-matnr
     AND   werks IN @li_werks
     AND   mtvfp =  @lv_mtvfp.   "ZI
   IF sy-subrc = 0.
     SORT li_marc BY matnr werks.
   ENDIF.

**  Get Material/Stock Posting Info
*   SELECT
*       mblnr,    "Matrl. Doc. No
*       mjahr,    "Year
*       zeile,    "Item
*       matnr,    "Material No
*       werks,    "Plant
*       lgort,    "Storage Locn.
*       vbeln_im, "Delivery No
*       vbelp_im  "Delivery Item
*     FROM mseg
*     INTO TABLE @DATA(li_mseg)
*     FOR ALL ENTRIES IN @li_lips
*     WHERE werks    IN @li_werks
*     AND   vbeln_im = @li_lips-vbeln
*     AND   vbelp_im = @li_lips-posnr.
*   IF sy-subrc = 0.
*     SORT li_mseg BY vbeln_im vbelp_im.
*   ENDIF.
 ENDIF.

 LOOP AT li_del_con ASSIGNING FIELD-SYMBOL(<lfst_del>).
   READ TABLE li_lips INTO DATA(lst_lips)
     WITH KEY vbeln = <lfst_del>-vbeln
              posnr = <lfst_del>-posnr
     BINARY SEARCH.
   IF sy-subrc = 0.
     READ TABLE li_marc INTO DATA(lst_marc)
       WITH KEY matnr = <lfst_del>-matnr
                werks = lst_lips-werks
       BINARY SEARCH.
     IF sy-subrc = 0.
*      Skip the record if any Stock already posted
*       IF line_exists( li_mseg[ vbeln_im = lst_lips-vbeln
*                                vbelp_im = lst_lips-posnr ] ).
*         CONTINUE.
*       ENDIF.

*      Populate Goods Movement Header
       lst_gds_mvt_hdr-doc_date    = sy-datum.
       lst_gds_mvt_hdr-pstng_date  = sy-datum.
       lst_gds_mvt_hdr-ref_doc_no  = <lfst_del>-vbeln.

       lst_gds_mvt_cde             = lv_gm_code.

*      Populate Goods Movement Item details
       lst_gds_mvt_itm-mvt_ind     = space.
       lst_gds_mvt_itm-material    = <lfst_del>-matnr.
       lst_gds_mvt_itm-plant       = lst_lips-werks.
       lst_gds_mvt_itm-stge_loc    = lst_lips-lgort.
       lst_gds_mvt_itm-move_type   = lv_mvmt_typ.
       lst_gds_mvt_itm-entry_qnt   = <lfst_del>-lfimg.
       lst_gds_mvt_itm-entry_uom   = lst_lips-vrkme.

       APPEND lst_gds_mvt_itm TO li_gds_mvt_itm.
       CLEAR  lst_gds_mvt_itm.

*========================================================================*
*           CALL BAPI: BAPI_GOODSMVT_CREATE                             *
*========================================================================*
       CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
           EXPORTING
             goodsmvt_header = lst_gds_mvt_hdr
             goodsmvt_code   = lst_gds_mvt_cde
           TABLES
             goodsmvt_item   = li_gds_mvt_itm
             return          = li_return.
       IF li_return IS NOT INITIAL.
         READ TABLE li_return TRANSPORTING NO FIELDS
           WITH KEY type = sy-abcde+4(1).  "E
         IF sy-subrc = 0.
           CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
         ENDIF.
       ELSE.
         CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait   = abap_on .
         EXIT.
       ENDIF.
     ENDIF.
   ENDIF.
 ENDLOOP.
