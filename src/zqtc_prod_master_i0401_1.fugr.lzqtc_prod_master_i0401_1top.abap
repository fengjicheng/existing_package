*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_PROD_MASTER_I0401_1TOP (Top Include)
*               For Functional Group ZQTC_PROD_MASTER_I0401_1"
* PROGRAM DESCRIPTION: Add Custom fields to Product Master
*                      orders
* DEVELOPER: TDIMANTHA
* CREATION DATE: 03/02/2022
* OBJECT ID: I0401.1
* TRANSPORT NUMBER(S): ED2K925933
*----------------------------------------------------------------------*
FUNCTION-POOL ZQTC_PROD_MASTER_I0401_1
                   MESSAGE-ID M3.

INCLUDE MMMGTRBB.
INCLUDE MMMGBBAU.
* Retail-Spezifische Deklarationen
INCLUDE MMMWTRBB.
INCLUDE MMMWBBAU.
*---------------------------------
INCLUDE wstr_definition. "Holds BADI global definition

LOAD-OF-PROGRAM.
  IF 1 = 2. ENDIF.                                        "Note 2668968
