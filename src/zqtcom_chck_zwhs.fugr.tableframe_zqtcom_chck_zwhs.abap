*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZQTCOM_CHCK_ZWHS
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZQTCOM_CHCK_ZWHS   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
