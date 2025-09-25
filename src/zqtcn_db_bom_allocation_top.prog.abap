*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_ALLOCATION_TOP (Include)
*               [Global Data Declarations]
* PROGRAM DESCRIPTION: Add Custom Fields for [1] Year, [2] Currency at
*                      the BOM Header level and for [3] Percentage
*                      Allocation at the BOM Component level
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
TABLES:
  stko,                                     "BOM Header
  stpo.                                     "BOM item

TYPES:
  BEGIN OF ty_custom_f,
    zzalloc TYPE rai_percentage_kk,         "Percentage Allocation
  END OF ty_custom_f.

DATA:
  st_ctrldata TYPE cstsd01,                 "Outline of transaction control data for customer enhancemnts
  st_custom_f TYPE ty_custom_f.             "Custom Fields

CONSTANTS:
  c_grp_dbm   TYPE char3     VALUE 'DBM',   "Screen Group: DBM
  c_disp_mode TYPE trtyp     VALUE 'A'.     "Transaction type: Display
