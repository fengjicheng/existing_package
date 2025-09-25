FUNCTION-POOL ZQTC_FG_SD_COPY_CONTROL MESSAGE-ID A.

* INCLUDE LZQTC_FG_SD_COPY_CONTROLD...       " Local class definition

*---------------------------------------------------------------------*
*       Tabellen / Feldleisten für Funktionsbaustein                  *
*       RV_DOCUMENT_COPY                                              *
*---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       interne Tabellen / Feldleisten                                *
*---------------------------------------------------------------------*
INCLUDE RVDIREKT.
INCLUDE VBAKDATA.
INCLUDE VBAPDATA.
INCLUDE VBKDDATA.
INCLUDE MV45ACOM.
INCLUDE COPYDATA.
INCLUDE VBUPDATA.
*INCLUDE RVMESSAGE.

TABLES : VBPA,TVCPA,VBRP,maapv.
DATA:    BEGIN OF XVBUK OCCURS 2.
           INCLUDE STRUCTURE VBUKVB.
DATA:    END OF XVBUK.
DATA:    BEGIN OF XVBUV OCCURS 9.
           INCLUDE STRUCTURE VBUVVB.
DATA:    END OF XVBUV.
DATA:
  BEGIN OF modul,
           name(15) VALUE 'DATEN_KOPIEREN_',
           suff(3),
  END OF modul.
  DATA: BEGIN OF XVBPA OCCURS 0.                   "#EC ENHOK
        INCLUDE STRUCTURE VBPAVB.
DATA: END OF XVBPA.
DATA  gs_tvak TYPE tvak.
INCLUDE ZQTCN_FV45CF0V_VBAK_KOPIEREN.
INCLUDE ZQTCN_FV45CF0V_VBAP_KOPIEREN."FV45CF0V_VBAP_KOPIEREN.
INCLUDE ZQTCN_FV45CF0V_VBAP_KOPIEREN_V.
INCLUDE ZQTCN_FV45CF0V_VBRP_KOPIEREN_P.
INCLUDE FV45CF0C_CVBKD_LESEN_VORLAGE.
INCLUDE FV45CF0V_VBAP_COPY_DATA_STANDA.
INCLUDE FV45CF0V_VBKD_COPY_DATA_STANDA.
INCLUDE FV45CF0V_VBAP_COPY_LOGIC.
INCLUDE FV45CF0V_VBAP_FUSSZEILE_FUELLE.
INCLUDE FV45CF0V_VBKD_KOPIEREN_KOPF.
INCLUDE FV45CF0C_CVBAP_LESEN_UEPOS.
