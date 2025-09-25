*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZCA_BAPI_VBAK_AP
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZCA_BAPI_VBAK_AP   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
