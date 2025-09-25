*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCA_BAPI_VBAK_AP................................*
DATA:  BEGIN OF STATUS_ZCA_BAPI_VBAK_AP              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCA_BAPI_VBAK_AP              .
CONTROLS: TCTRL_ZCA_BAPI_VBAK_AP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCA_BAPI_VBAK_AP              .
TABLES: ZCA_BAPI_VBAK_AP               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
