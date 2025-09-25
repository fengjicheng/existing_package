*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZQTC_SAL_ARA_REF
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZQTC_SAL_ARA_REF   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
