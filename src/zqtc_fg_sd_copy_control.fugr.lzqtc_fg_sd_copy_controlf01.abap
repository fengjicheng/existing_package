*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_SD_COPY_CONTROLF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  VBPA_KOPIEREN_POSITION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CVBRP_POSNR  text
*----------------------------------------------------------------------*
FORM vbpa_kopieren_position USING US_POSNR.


  MODUL-SUFF = TVCPA-GRUPA.
  IF MODUL-SUFF = 0.
*    MESSAGE A472 WITH 'VBPA'.
  ENDIF.

  PERFORM (MODUL) IN PROGRAM SAPFV45C.

  CALL FUNCTION 'KOPIERTE_PARTNER_PRUEFEN'
       EXPORTING
            PARTNERGRUPPE            = TVAP-PARGR
            POSITION                 = US_POSNR
            REFERENZ_BELEG           = VBAK-VBELN
            VERKAUFSORGANISATION     = VBAK-VKORG
            VERTRIEBSWEG             = VBAK-VTWEG
            SPARTE                   = VBAK-SPART
            ALLE_PARTNER_VORSCHLAGEN = abap_true
            KNREF_NACHLESEN          = abap_true
            KOPIEREN                 = abap_true
       TABLES
            TABELLE_XVBPA            = XVBPA
            VBUV_TAB                 = XVBUV.
ENDFORM.
