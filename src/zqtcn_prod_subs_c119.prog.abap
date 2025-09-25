*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PROD_SUBS_C119
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTCN_PROD_SUBS_C119
* PROGRAM DESCRIPTION : Populate Proposed Reason Based on The Product.
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 22-Apr-2022
* OBJECT ID           : C119
* TRANSPORT NUMBER(S) : ED2K926989.
* DESCRIPTION         : The Proposed Reason - Header Field is to be obtained
*                       from tables based on the product substituted.
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO         : ED2K926989
* REFERENCE NO        :
* DEVELOPER           : SVISHWANAT
* DATE                : 25-Apr-2022
* DESCRIPTION         : Populate Proposed Reason w.r.t Product.
*-----------------------------------------------------------------------*

  DATA:lv_sugrd TYPE sugrd_ms.

  IF time_vake-knumh IS NOT INITIAL.
    FREE:lv_sugrd.
    SELECT SINGLE sugrd
      FROM kondd
      INTO lv_sugrd
      WHERE knumh = time_vake-knumh.
    IF lv_sugrd IS NOT INITIAL.
      mv13d-sugrv = lv_sugrd.  "Reason for material substitution
    ENDIF. "IF lv_sugrd IS NOT INITIAL.
  ENDIF. "IF time_vake-knumh IS NOT INITIAL.
