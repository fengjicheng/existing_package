FUNCTION zqtc_sd_copy_control.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SALESDOCUMENT) LIKE  BAPIVBELN-VBELN
*"     VALUE(IM_SALESDOCITEM) LIKE  VBAP-POSNR OPTIONAL
*"     VALUE(IM_DOCUMENTTYPE) LIKE  BAPISDHD1-DOC_TYPE OPTIONAL
*"  TABLES
*"      T_VBAK STRUCTURE  VBAK OPTIONAL
*"      T_VBAP STRUCTURE  VBAP OPTIONAL
*"      T_VBKD STRUCTURE  VBKD OPTIONAL
*"      T_VBPA STRUCTURE  VBPA OPTIONAL
*"      T_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SD_COPY_CONTROL (Function Module)
* PROGRAM DESCRIPTION: FM for SD Document copy controls
* Created this FM by copying standard SAP functionality of sales copy controls
* from the FM BAPI_SALESDOCUMENT_COPY.
* this can be called in CMR/DMR upload programs where the reference document
* is being passed to create a new document.
*--* Coding standards followed as per the compatability with standard SAP code.
* DEVELOPER: PRABHU (PTUFARAM)
* CREATION DATE:   10/30/2018
* OBJECT ID: ERP7774/CR6802
* TRANSPORT NUMBER(S):  ED2K913757
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
  DATA :  da_no_items.
  CLEAR : vbak,tvak,vbap,vbkd,vbpa,svbak,
          cvbap,cvbep,cvbak,cvbuk,tvcpa,cvbrk,xvbap,xvbap_high_posnr.
  REFRESH : cvbap,cvbep,cvbfa,cvbkd,cvbkd,xvbuk,cvbup,
            xvbuv,cfpla,cfplt,cvbsn,cvbrp,xvbap,xvbkd,ivbap.
*----------------------------------------------------------------------*
*---Get the Sales document type info-----------------------------------*
*----------------------------------------------------------------------*
  PERFORM tvak_select(sapmv45a) USING im_documenttype
                                        abap_true
                                        sy-subrc.

  MOVE-CORRESPONDING tvak TO vbak.
*----------------------------------------------------------------------*
*---Based on inputs sales doc,target document type fecth all the
*-- reference/source document info by building runtime internal tables
*---------------------------------------------------------------------*
  CALL FUNCTION 'RV_DOCUMENT_COPY_NO_POPUP'
    EXPORTING
      fvak       = tvak
      fvbak      = vbak
      fvbpa      = vbpa
      i_vbeln    = im_salesdocument
      i_no_items = da_no_items
    IMPORTING
      fvbak      = cvbak
      fvbuk      = cvbuk
      fvcpa      = tvcpa
      fvbrk      = cvbrk
    TABLES
      fxvbap     = cvbap
      fxvbep     = cvbep
      fxvbfa     = cvbfa
      fxvbkd     = cvbkd
      fxvbpa     = cvbpa
      fxvbuk     = xvbuk
      fxvbup     = cvbup
      fxvbuv     = xvbuv
      fxfpla     = cfpla
      fxfplt     = cfplt
      fxvbsn     = cvbsn
      fxvbrp     = cvbrp.
*----------------------------------------------------------------------*
*---Fill sales area -----------------------------------*
*----------------------------------------------------------------------*
  IF vbak-vkorg IS INITIAL OR
        vbak-vtweg IS INITIAL OR
        vbak-spart IS INITIAL.
    IF NOT cvbak-vbeln IS INITIAL.
      vbak-vkorg = cvbak-vkorg.
      vbak-vtweg = cvbak-vtweg.
      vbak-spart = cvbak-spart.
    ENDIF.
    IF NOT cvbrk-vbeln IS INITIAL.
      vbak-vkorg = cvbrk-vkorg.
      vbak-vtweg = cvbrk-vtweg.
      vbak-spart = cvbrk-spart.
    ENDIF.
    PERFORM tvta_select(sapmv45a) USING vbak-vkorg
                                        vbak-vtweg
                                        vbak-spart.
  ENDIF.
*----------------------------------------------------------------------*
*---Fille sales doc type info-----------------------------------*
*----------------------------------------------------------------------*
  PERFORM vbak-auart_pruefen(sapfv45k).
*----------------------------------------------------------------------*
*---Go through header copy controls -----------------------------------*
*----------------------------------------------------------------------*
  PERFORM tvcpa_select(sapmv45a) USING vbak-auart
                                        cvbak-auart
                                        cvbrk-fkart
                                        space
                                        space
                                        abap_true
                                        sy-subrc.
*----------------------------------------------------------------------*
*---Copy all sales header info along with target copy controls---------*
*----------------------------------------------------------------------*
  PERFORM vbak_kopieren.
*----------------------------------------------------------------------*
*---remove un selected items----------------------------------*
*----------------------------------------------------------------------*
  IF im_salesdocitem IS NOT INITIAL.
    DELETE cvbrp WHERE posnr NE im_salesdocitem.
  ENDIF.
*----------------------------------------------------------------------*
*---Fill reference docuument target info ------------------------------*
*----------------------------------------------------------------------*
  PERFORM vbrp_kopieren_pruefen.

*----------------------------------------------------------------------*
*---Process reference document items one by one------------------------------*
*----------------------------------------------------------------------*
  LOOP AT cvbrp.
*----------------------------------------------------------------------*
*---Go through Item copy controls------------------------------*
*----------------------------------------------------------------------*
    PERFORM tvcpa_select(sapmv45a) USING vbak-auart
                                             cvbak-auart
                                             cvbrk-fkart
                                             cvbrp-pstyv
                                             space
                                             space
                                             sy-subrc.
* Eintrag nicht da -> Abbruch, da er gerade noch da war
    IF sy-subrc NE 0.
      MESSAGE a473 WITH vbak-auart cvbrk-fkart cvbap-pstyv space.
    ENDIF.
* Buchungsstring lesen. Z.B. Partnergruppe
    PERFORM tvap_select(sapmv45a) USING cvbrp-pstyn
                                        space
                                        sy-subrc.
    IF sy-subrc NE 0.
      MESSAGE a478 WITH cvbrp-pstyn.
    ENDIF.

*----------------------------------------------------------------------*
*---Go through Copy control routines stadard at item level-------------*
*----------------------------------------------------------------------*
    PERFORM vbpa_kopieren_position USING cvbrp-posnr.

*----------------------------------------------------------------------*
*---Go through Copy control routines custom at item level--------------*
*----------------------------------------------------------------------*
    PERFORM vbap_kopieren USING cvbrp-posnr
                                cvbrk-vbtyp
                                cvbrp-vgbel
                                cvbrp-vgpos
                                abap_true. " Immer Vorgänger
*----------------------------------------------------------------------*
*---Build target data --------------*
*----------------------------------------------------------------------*
    APPEND vbap TO t_vbap.
    APPEND vbkd TO t_vbkd.
    APPEND vbpa TO t_vbpa.
    CLEAR : vbap,vbkd,vbpa.
  ENDLOOP.
  APPEND vbak TO t_vbak.
  CLEAR vbak.
  CALL_BAPI = ABAP_TRUE.
ENDFUNCTION.
