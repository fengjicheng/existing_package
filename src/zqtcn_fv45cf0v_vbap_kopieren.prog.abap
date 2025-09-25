*---------------------------------------------------------------------*
*       FORM VBAP_KOPIEREN                                            *
*---------------------------------------------------------------------*
*       Kopieren einer Position aus Referenz                          *
*---------------------------------------------------------------------*
FORM VBAP_KOPIEREN USING US_POSNR
                         US_VGTYP
                         US_VGBEL
                         US_VGPOS
                         US_VGREF.

  DATA: DA_DRAD_NEW LIKE DRAD,
        DA_DRAD_OLD LIKE DRAD.
*ENHANCEMENT-POINT VBAP_KOPIEREN_14 SPOTS ES_SAPFV45C STATIC.

* Kopieren der VBAP und VBKD
  PERFORM VBAP_KOPIEREN_VORBEREITEN USING US_POSNR
                                          US_VGTYP
                                          US_VGBEL
                                          US_VGPOS
                                          US_VGREF
                                          SPACE.

*ENHANCEMENT-POINT VBAP_KOPIEREN_10 SPOTS ES_SAPFV45C.
* Vertragsdaten kopieren.
  IF CVBRK-VBELN IS INITIAL.
*ENHANCEMENT-SECTION     VBAP_KOPIEREN_11 SPOTS ES_SAPFV45C.
*    IF NOT TVAK-VTERL IS INITIAL.
*      PERFORM VEDA_KOPIEREN_POSITION USING CVBAK-VBELN
*                                           US_POSNR.
*    ENDIF.
*END-ENHANCEMENT-SECTION.
  ENDIF.
* Fakturierungsplandaten kopieren
*  IF CVBRK-VBELN IS INITIAL.
*    IF TVAP-FKREL EQ CON_FKREL_FPLAN OR
*     ( TVAP-FKREL IS INITIAL AND       "oder Angebote
*       NOT TVAP-FPART IS INITIAL ).
*      PERFORM FPLA_KOPIEREN_POSITION.
*    ENDIF.
*  ELSE.
*    IF TVAP-FKREL EQ CON_FKREL_FPLAN OR
*     ( TVAP-FKREL IS INITIAL AND       "oder Angebote
*       NOT TVAP-FPART IS INITIAL ).
*      PERFORM FPLA_KOPIEREN_POSITION_FAKTURA.
*    ENDIF.
*  ENDIF.

*ENHANCEMENT-POINT VBAP_KOPIEREN_13 SPOTS ES_SAPFV45C.
* Dokumentenzuordnungen kopieren
  IF NOT CVBAK-VBELN IS INITIAL.
* neues Objekt
    CLEAR DA_DRAD_NEW.
    DA_DRAD_NEW-OBJKY(10)   = VBAK-VBELN.
    DA_DRAD_NEW-OBJKY+10(6) = VBAP-POSNR.
* altes Objekt
    CLEAR DA_DRAD_OLD.
    DA_DRAD_OLD-OBJKY(10)   = CVBAP-VGBEL.
    DA_DRAD_OLD-OBJKY+10(6) = CVBAP-VGPOS.

    CALL FUNCTION 'DOCUMENT_ASSIGN_COPY'
         EXPORTING
              DOKOB     = 'VBAP'
              OBJKY_NEW = DA_DRAD_NEW-OBJKY
              OBJKY_OLD = DA_DRAD_OLD-OBJKY
         EXCEPTIONS
              OTHERS    = 1.

    call function 'DRAD_UPDATES_GET'
         tables new_drad_entries = xdrad.

  ENDIF.

*ENHANCEMENT-POINT VBAP_KOPIEREN_12 SPOTS ES_SAPFV45C.

*  PERFORM VBAP_SERNR_KOPIEREN.
*ENHANCEMENT-POINT VBAP_KOPIEREN_15 SPOTS ES_SAPFV45C.


*ENHANCEMENT-POINT VBAP_KOPIEREN_20 SPOTS ES_SAPFV45C.

  if cl_ops_switch_check=>ops_sfws_sc_advret1( ) eq charx.
    PERFORM msr_check_item in program sapmv45a USING space space.
  endif.
  PERFORM VBAP_BEARBEITEN(SAPFV45P).
ENDFORM.
