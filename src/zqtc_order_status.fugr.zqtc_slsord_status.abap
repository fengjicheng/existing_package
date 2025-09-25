*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_ORD_STATUS (Enhancement Implementation)
* PROGRAM DESCRIPTION:Function Module for Subscription Order Status
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   16/09/2016
* OBJECT ID: I0228/I0218
* TRANSPORT NUMBER(S):   ED2K902846
*----------------------------------------------------------------------*
FUNCTION zqtc_slsord_status.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN_VA
*"  EXPORTING
*"     REFERENCE(EX_HDR_STATUS) TYPE  ZTQTC_ORD_HDR_STATUS
*"     REFERENCE(EX_ITM_VBUP_STATUS) TYPE  ZTQTC_ORD_ITEM_STATUS
*"     REFERENCE(EX_REJ_STATUS) TYPE  ZTQTC_TVAGT
*"     REFERENCE(EX_HDR_COND) TYPE  ZTQTC_HDR_COND
*"     REFERENCE(EX_ITM_COND) TYPE  ZTQTC_ITM_COND
*"----------------------------------------------------------------------
  IF i_hdr_status IS NOT INITIAL.


ex_hdr_status = i_hdr_status.
ex_itm_vbup_status = i_item_vbup_status.

ELSE.

*** Selecting Data from VBUK and VBUP
      SELECT b~vbeln AS vbeln,
        b~rfstk AS rfstk,
        b~rfgsk AS rfgsk,
        b~bestk AS bestk,
        b~lfstk AS lfstk,
        b~lfgsk AS lfgsk,
        b~wbstk AS wbstk,
        b~fkstk AS fkstk,
        b~fksak AS fksak,
        b~buchk AS buchk,
        b~abstk AS abstk,
        b~gbstk AS gbstk,
        b~kostk AS kostk,
        b~lvstk AS lvstk,
        b~uvals AS uvals,
        b~uvvls AS uvvls,
        b~uvfas AS uvfas,
        b~uvall AS uvall,
        b~uvvlk AS uvvlk,
        b~uvfak AS uvfak,
        b~uvprs AS uvprs,
        b~vbtyp AS vbtyp,
        b~vbobj AS vbobj,
        b~aedat AS aedat,
        b~fkivk AS fkivk,
        b~relik AS relik,
        b~uvk01 AS uvk01,
        b~uvk02 AS uvk02,
        b~uvk03 AS uvk03,
        b~uvk04 AS uvk04,
        b~uvk05 AS uvk05,
        b~uvs01 AS uvs01,
        b~uvs02 AS uvs02,
        b~uvs03 AS uvs03,
        b~uvs04 AS uvs04,
        b~uvs05 AS uvs05,
        b~pkstk AS pkstk,
        b~cmpsa AS cmpsa,
        b~cmpsb AS cmpsb,
        b~cmpsc AS cmpsc,
        b~cmpsd AS cmpsd,
        b~cmpse AS cmpse,
        b~cmpsf AS cmpsf,
        b~cmpsg AS cmpsg,
        b~cmpsh AS cmpsh,
        b~cmpsi AS cmpsi,
        b~cmpsj AS cmpsj,
        b~cmpsk AS cmpsk,
        b~cmpsl AS cmpsl,
        b~cmps0 AS cmps0,
        b~cmps1 AS cmps1,
        b~cmps2 AS cmps2,
        b~cmgst AS cmgst,
        b~trsta AS trsta,
        b~koquk AS koquk,
        b~costa AS costa,
        b~uvpas AS uvpas,
        b~uvpis AS uvpis,
        b~uvwas AS uvwas,
        b~uvpak AS uvpak,
        b~uvpik AS uvpik,
        b~uvwak AS uvwak,
        b~uvgek AS uvgek,
        b~cmpsm AS cmpsm,
        b~dcstk AS dcstk,
        b~vestk AS vestk,
        b~vlstk AS vlstk,
        b~rrsta AS rrsta,
        b~block AS block,
        b~fsstk AS fsstk,
        b~lsstk AS lsstk,
        b~spstg AS spstg,
        b~pdstk AS pdstk,
        b~fmstk AS fmstk,
        b~manek AS manek,
        b~spe_tmpid AS spe_tmpid,
        b~hdall AS hdall,
        b~hdals AS hdals,
        b~cmps_cm AS cmps_cm,
        b~cmps_te AS cmps_te,

        c~posnr AS vposn,
        c~rfsta AS rfsta,
        c~rfgsa AS rfgsa,
        c~besta AS besta,
        c~lfsta AS lfsta,
        c~lfgsa AS lfgsa,
        c~wbsta AS wbsta,
        c~fksta AS fksta,
        c~fksaa AS fksaa,
        c~absta AS absta,
        c~gbsta AS gbsta,
        c~kosta AS kosta,
        c~lvsta AS lvsta,
        c~uvall AS uvall_c,
        c~uvvlk AS uvvlk_c,
        c~uvfak AS uvfak_c,
        c~uvprs AS uvprs_c,
        c~fkivp AS fkivp,
        c~uvp01 AS uvp01,
        c~uvp02 AS uvp02,
        c~uvp03 AS uvp03,
        c~uvp04 AS uvp04,
        c~uvp05 AS uvp05,
        c~pksta AS pksta,
        c~koqua AS koqua,
        c~costa AS osta,
        c~cmppi AS mppi,
        c~cmppj AS mppj,
        c~uvpik AS uvpik_c,
        c~uvpak AS uvpak_c,
        c~uvwak AS uvwak_c,
        c~dcsta AS cdsta,
        c~rrsta AS rrsta_c,
        c~vlstp AS vlstp,
        c~fssta AS fssta,
        c~lssta AS lssta,
        c~pdsta AS pdsta,
        c~manek AS manek_c,
        c~hdall AS hdall_c

    INTO TABLE @DATA(li_final)
        FROM vbuk AS b
        INNER JOIN vbup AS c ON b~vbeln = c~vbeln
        WHERE b~vbeln = @im_vbeln

        GROUP BY   b~vbeln,
        b~rfstk,
        b~rfgsk,
        b~bestk,
        b~lfstk,
        b~lfgsk,
        b~wbstk,
        b~fkstk,
        b~fksak,
        b~buchk,
        b~abstk,
        b~gbstk,
        b~kostk,
        b~lvstk,
        b~uvals,
        b~uvvls,
        b~uvfas,
        b~uvall,
        b~uvvlk,
        b~uvfak,
        b~uvprs,
        b~vbtyp,
        b~vbobj,
        b~aedat,
        b~fkivk,
        b~relik,
        b~uvk01,
        b~uvk02,
        b~uvk03,
        b~uvk04,
        b~uvk05,
        b~uvs01,
        b~uvs02,
        b~uvs03,
        b~uvs04,
        b~uvs05,
        b~pkstk,
        b~cmpsa,
        b~cmpsb,
        b~cmpsc,
        b~cmpsd,
        b~cmpse,
        b~cmpsf,
        b~cmpsg,
        b~cmpsh,
        b~cmpsi,
        b~cmpsj,
        b~cmpsk,
        b~cmpsl,
        b~cmps0,
        b~cmps1,
        b~cmps2,
        b~cmgst,
        b~trsta,
        b~koquk,
        b~costa,
        b~uvpas,
        b~uvpis,
        b~uvwas,
        b~uvpak,
        b~uvpik,
        b~uvwak,
        b~uvgek,
        b~cmpsm,
        b~dcstk,
        b~vestk,
        b~vlstk,
        b~rrsta,
        b~block,
        b~fsstk,
        b~lsstk,
        b~spstg,
        b~pdstk,
        b~fmstk,
        b~manek,
        b~spe_tmpid,
        b~hdall,
        b~hdals,
        b~cmps_cm,
        b~cmps_te,

        c~posnr,
        c~rfsta,
        c~rfgsa,
        c~besta,
        c~lfsta,
        c~lfgsa,
        c~wbsta,
        c~fksta,
        c~fksaa,
        c~absta,
        c~gbsta,
        c~kosta,
        c~lvsta,
        c~uvall,
        c~uvvlk,
        c~uvfak,
        c~uvprs,
        c~fkivp,
        c~uvp01,
        c~uvp02,
        c~uvp03,
        c~uvp04,
        c~uvp05,
        c~pksta,
        c~koqua,
        c~costa,
        c~cmppi,
        c~cmppj,
        c~uvpik,
        c~uvpak ,
        c~uvwak ,
        c~dcsta,
        c~rrsta,
        c~vlstp,
        c~fssta,
        c~lssta,
        c~pdsta,
        c~manek,
        c~hdall

     ORDER BY b~vbeln,
              c~posnr.
    IF sy-subrc IS INITIAL.
      MOVE-CORRESPONDING: li_final TO ex_hdr_status,
                          li_final TO ex_itm_vbup_status.
      DELETE ADJACENT DUPLICATES FROM ex_hdr_status
                           COMPARING ALL FIELDS.
   i_hdr_status = ex_hdr_status.
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
    SELECT a~vbeln as vbeln,
           a~KVGR1 as kvgr1,
           a~KVGR2 AS kvgr2,
           a~KVGR3 AS kvgr3,
           a~KVGR4 AS kvgr4,
           a~KVGR5 AS kvgr5,

*           b~POSNR AS POSNR,
           b~MVGR1 AS mvgr1,
           b~MVGR2 AS mvgr2,
           b~MVGR3 AS mvgr3,
           b~MVGR4 AS mvgr4,
           b~MVGR5 AS mvgr5,

          c~POSNR AS posnr,
          c~KDKG1 AS kdkg1,
          c~KDKG2 AS kdkg2,
          c~KDKG3 AS kdkg3,
          c~KDKG4 AS kdkg4,
          c~KDKG5 AS kdkg5

         INTO TABLE @DATA(li_cond)
         FROM vbak AS a
         INNER JOIN vbap AS b ON a~vbeln = b~vbeln
         RIGHT OUTER JOIN vbkd as c ON b~vbeln = c~vbeln
         AND b~posnr = c~posnr
         WHERE a~vbeln = @im_vbeln

         GROUP BY
           a~vbeln,
           a~KVGR1,
           a~KVGR2,
           a~KVGR3,
           a~KVGR4 ,
           a~KVGR5 ,

*           b~POSNR ,
           b~MVGR1 ,
           b~MVGR2 ,
           b~MVGR3 ,
           b~MVGR4 ,
           b~MVGR5 ,

          c~posnr,
          c~KDKG1 ,
          c~KDKG2 ,
          c~KDKG3,
          c~KDKG4 ,
          c~KDKG5

         ORDER BY a~vbeln,
                  c~posnr.

      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING: li_cond to ex_hdr_cond,
                            li_cond to ex_itm_cond.
        DELETE ex_hdr_cond INDEX 1.
        i_hdr_cond = ex_hdr_cond.
        i_itm_cond = ex_itm_cond.
      ENDIF.

    ENDIF.







ENDFUNCTION.
