*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_ORD_STATUS (Enhancement Implementation)
* PROGRAM DESCRIPTION:Function Module for Subscription Order Status
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   24/08/2016
* OBJECT ID: I0229/I0218
* TRANSPORT NUMBER(S):   ED2K902846
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905390
* REFERENCE NO: ERP-4229
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-09-11
* DESCRIPTION: Check Buffer against Order Number (During Batch
* processing, multiple Orders can be processed in the same session)
*----------------------------------------------------------------------*
FUNCTION zqtc_ord_status.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN_VA
*"  EXPORTING
*"     REFERENCE(EX_ITM_STATUS) TYPE  ZTQTC_ORD_STATUS
*"     REFERENCE(EX_HDR_STATUS) TYPE  ZTQTC_ORD_HDR_STATUS
*"     REFERENCE(EX_ITM_VBUP_STATUS) TYPE  ZTQTC_ORD_ITEM_STATUS
*"     REFERENCE(EX_REJ_STATUS) TYPE  ZTQTC_TVAGT
*"     REFERENCE(EX_HDR_COND) TYPE  ZTQTC_HDR_COND
*"     REFERENCE(EX_ITM_COND) TYPE  ZTQTC_ITM_COND
*"----------------------------------------------------------------------
* Begin of DEL:ERP-4229:WROY:11-Sep-2017:ED2K905390
* IF i_status IS NOT INITIAL.
* End   of DEL:ERP-4229:WROY:11-Sep-2017:ED2K905390
* Begin of ADD:ERP-4229:WROY:11-Sep-2017:ED2K905390
  READ TABLE i_status TRANSPORTING NO FIELDS
       WITH KEY vbeln = im_vbeln.
  IF sy-subrc EQ 0.
* End   of ADD:ERP-4229:WROY:11-Sep-2017:ED2K905390

    ex_itm_status = i_status.
    ex_hdr_status = i_hdr_status.
    ex_itm_vbup_status = i_item_vbup_status.

  ELSE.


******* Selecting Data from Three Tables
*   Fetch Contract Data
    SELECT vbeln   AS vbeln,
           vposn   AS vposn,
           vbegdat AS vbegdat,
           venddat AS venddat,
           vbelkue AS vbelkue
      FROM veda
      INTO TABLE @DATA(li_final_veda)
     WHERE vbeln EQ @im_vbeln
     ORDER BY vbeln,
              vposn.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING: li_final_veda TO ex_itm_status.
      i_status = ex_itm_status.
    ENDIF.

*   Fetch Sales Document: Header Status and Administrative Data
*   SELECT * is being used, since almose all the fields will be mapped
    SELECT *
      FROM vbuk
      INTO TABLE @DATA(li_final_vbuk)
     WHERE vbeln EQ @im_vbeln
     ORDER BY vbeln.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING: li_final_vbuk TO ex_hdr_status.
      i_hdr_status = ex_hdr_status.
    ENDIF.

*   Fetch Sales Document: Item Status
*   SELECT * is being used, since almose all the fields will be mapped
    SELECT *
      FROM vbup
      INTO TABLE @DATA(li_final_vbup)
     WHERE vbeln EQ @im_vbeln
     ORDER BY vbeln,
              posnr.
    IF sy-subrc EQ 0.
      LOOP AT li_final_vbup ASSIGNING FIELD-SYMBOL(<lst_final_vbup>).
        APPEND INITIAL LINE TO ex_itm_vbup_status ASSIGNING FIELD-SYMBOL(<lst_tm_vbup_status>).
        MOVE-CORRESPONDING: <lst_final_vbup> TO <lst_tm_vbup_status>.
        <lst_tm_vbup_status>-vposn = <lst_final_vbup>-posnr.
      ENDLOOP.
      i_item_vbup_status = ex_itm_vbup_status.
    ENDIF.

  ENDIF.

  IF i_tvagt IS NOT INITIAL.

    ex_rej_status = i_tvagt.

  ELSE.

**** Selecting BEZEI field

    SELECT abgru,
           bezei
      FROM tvagt INTO TABLE @DATA(li_tvagt)
      WHERE spras = @sy-langu.

    IF sy-subrc  = 0.

      MOVE-CORRESPONDING li_tvagt TO ex_rej_status.
      i_tvagt = ex_rej_status.

    ENDIF.
  ENDIF.

  IF i_hdr_cond IS NOT INITIAL.
    ex_hdr_cond = i_hdr_cond.
    ex_itm_cond = i_itm_cond.

  ELSE.

*** Selecting Condition Groups
    SELECT a~vbeln AS vbeln,
           a~kvgr1 AS kvgr1,
           a~kvgr2 AS kvgr2,
           a~kvgr3 AS kvgr3,
           a~kvgr4 AS kvgr4,
           a~kvgr5 AS kvgr5,

*           b~POSNR AS POSNR,
           b~mvgr1 AS mvgr1,
           b~mvgr2 AS mvgr2,
           b~mvgr3 AS mvgr3,
           b~mvgr4 AS mvgr4,
           b~mvgr5 AS mvgr5,

          c~posnr AS posnr,
          c~kdkg1 AS kdkg1,
          c~kdkg2 AS kdkg2,
          c~kdkg3 AS kdkg3,
          c~kdkg4 AS kdkg4,
          c~kdkg5 AS kdkg5

         INTO TABLE @DATA(li_cond)
         FROM vbak AS a
         INNER JOIN vbap AS b ON a~vbeln = b~vbeln
         RIGHT OUTER JOIN vbkd AS c ON b~vbeln = c~vbeln
         AND b~posnr = c~posnr
         WHERE a~vbeln = @im_vbeln

         GROUP BY
           a~vbeln,
           a~kvgr1,
           a~kvgr2,
           a~kvgr3,
           a~kvgr4 ,
           a~kvgr5 ,

*           b~POSNR ,
           b~mvgr1 ,
           b~mvgr2 ,
           b~mvgr3 ,
           b~mvgr4 ,
           b~mvgr5 ,

          c~posnr,
          c~kdkg1 ,
          c~kdkg2 ,
          c~kdkg3,
          c~kdkg4 ,
          c~kdkg5

         ORDER BY a~vbeln,
                  c~posnr.

    IF sy-subrc IS INITIAL.
      MOVE-CORRESPONDING: li_cond TO ex_hdr_cond,
                          li_cond TO ex_itm_cond.
      DELETE ex_hdr_cond INDEX 1.
      i_hdr_cond = ex_hdr_cond.
      i_itm_cond = ex_itm_cond.
    ENDIF.

  ENDIF.
ENDFUNCTION.
