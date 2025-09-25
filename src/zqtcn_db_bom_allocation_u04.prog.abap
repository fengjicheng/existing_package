*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_ALLOCATION_U04 (Include)
*               [Called from User-Exit EXIT_SAPLCSDI_004]
* PROGRAM DESCRIPTION: Add Custom Fields for "Year" and "Currency" at
*                      the BOM Header Level
* DEVELOPER: Writtick Roy
* CREATION DATE:   10/30/2017
* OBJECT ID: E162 - CR#607
* TRANSPORT NUMBER(S): ED2K908513
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
stko-zzwaers = userdata-zzwaers.            "Currency
stko-zzbegjj = userdata-zzbegjj.            "Year

st_ctrldata  = ctrldata.                    "Outline of transaction control data for customer enhancemnts
