"Name: \PR:RM07MLBS\EX:EHP604_RM07MLBS_30\EI
ENHANCEMENT 0 ZQTCEI_MB52_ADD_DATA.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_MB52_ADD_DATA
* PROGRAM DESCRIPTION: To Add New Fields to the MB52 Standrd report
* DEVELOPER:           Siva Guda
* CREATION DATE:       07/24/2020
* OBJECT ID:           E255
* TRANSPORT NUMBER(S): ED2K918997
*----------------------------------------------------------------------*
CONSTANTS: lc_del_type TYPE vbbe-vbtyp VALUE 'J'.  "SD document category

fieldcat-fieldname     = 'ISMYEARNR'. "Volume Year
fieldcat-tabname       = 'BESTAND'.
fieldcat-ref_tabname   = 'MARA'.
fieldcat-col_pos       = '32'.
APPEND fieldcat.
CLEAR fieldcat.
fieldcat-fieldname     = 'ISMARRIVALDATEAC'.  "Get Actual Goods Arrival Date
fieldcat-tabname       = 'BESTAND'.
fieldcat-ref_tabname   = 'MARC'.
fieldcat-col_pos       = '33'.
APPEND fieldcat.
CLEAR fieldcat.
fieldcat-fieldname     = 'OMENG'.  "Schd. for Delivery
fieldcat-tabname       = 'BESTAND'.
fieldcat-ref_tabname   = 'VBBE'.
fieldcat-qfieldname    = 'MEINS'.
fieldcat-seltext_l     = 'Schd. for Delivery'.
fieldcat-col_pos       = '34'.
APPEND fieldcat.
CLEAR fieldcat.
IF bestand[] IS NOT INITIAL.
*- To get Volume Year
  SELECT matnr,
         ismyearnr
    INTO TABLE @DATA(li_mara)
    FROM mara
    FOR ALL ENTRIES IN @bestand
    WHERE matnr = @bestand-matnr.
*- To Get Actual Goods Arrival Date
  SELECT matnr,
         werks,
         ismarrivaldateac
    INTO TABLE @DATA(li_marc)
    FROM marc
    FOR ALL ENTRIES IN @bestand
    WHERE matnr = @bestand-matnr
    AND   werks = @bestand-werks.
*- To get Schd. for Delivery
  SELECT *
    INTO TABLE @DATA(li_vbbe)
    FROM vbbe
    FOR ALL ENTRIES IN @bestand
    WHERE matnr = @bestand-matnr
    AND   werks = @bestand-werks
    AND   lgort = @bestand-lgort
    AND   vbtyp = @lc_del_type.

  SORT li_vbbe BY matnr werks lgort.
  SORT li_marc BY matnr werks.
  SORT li_mara BY matnr.
ENDIF.

LOOP AT bestand.
  READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = bestand-matnr
                                         BINARY SEARCH.
  IF sy-subrc EQ 0.
    bestand-ismyearnr = lst_mara-ismyearnr.  "Volume Year
  ENDIF.
  READ TABLE li_marc INTO DATA(lst_marc) WITH KEY matnr = bestand-matnr
                                                  werks = bestand-werks
                                         BINARY SEARCH.
  IF sy-subrc EQ 0.
    bestand-ismarrivaldateac = lst_marc-ismarrivaldateac.  "Actual Goods Arrival Date
  ENDIF.
  LOOP AT li_vbbe INTO DATA(lst_vbbe) WHERE matnr = bestand-matnr
                                      AND   werks = bestand-werks
                                      AND   lgort = bestand-lgort.
    bestand-omeng  = bestand-omeng + lst_vbbe-omeng.  "Schd. for Delivery
  ENDLOOP.
  MODIFY bestand TRANSPORTING ismyearnr ismarrivaldateac omeng WHERE matnr = bestand-matnr
                                                               AND   werks = bestand-werks
                                                               AND   lgort = bestand-lgort.
ENDLOOP.
ENDENHANCEMENT.
