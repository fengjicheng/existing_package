*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_ALLOCATION_U03 (Include)
*               [Called from User-Exit EXIT_SAPLCSDI_003]
* PROGRAM DESCRIPTION: Add Custom Field for "Percentage Allocation"
*                      at the BOM Component level
* DEVELOPER: Writtick Roy
* CREATION DATE:   10/30/2017
* OBJECT ID: E162 - CR#607
* TRANSPORT NUMBER(S): ED2K908513, ED2K910112
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
stpo-zzalloc     = st_custom_f-zzalloc.     "Allocation Percentage (Dec)
userdata-zzalloc = stpo-zzalloc.            "Allocation Percentage (Char)
