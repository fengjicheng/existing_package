*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_REL_ORD_PLNT (Include)
* [Called from Sales Orders Data User exit - MV45AFZB
*                                     (USEREXIT_SOURCE_DETERMINATION)]
* PROGRAM DESCRIPTION: Delivery Plant determination for Release Order.
* DEVELOPER:           Himanshu Patel (HIPATEL)
* CREATION DATE:       08/03/2018
* OBJECT ID:           RITM0036291 - E141
* TRANSPORT NUMBER(S): ED1K908130 / ED2K913295
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*---------------------------------------------------------------------*
DATA: lv_dwerk TYPE dwerk.   "Plant

DATA: lv_plant_test TYPE werks_d.
"ES1K901904
"Test Plant value import from MV45AZZ
 IMPORT lv_plant_test FROM MEMORY ID 'PLA'.
 FREE MEMORY ID 'PLA'.
"ES1K901904
SELECT SINGLE dwerk
  INTO lv_dwerk
  from mvke
  WHERE matnr eq vbap-matnr
    AND vkorg eq vbak-vkorg
    AND vtweg eq vbak-vtweg.
  IF sy-subrc = 0.
    vbap-werks = lv_dwerk.                           "Plant (Own or External)
  ENDIF.
