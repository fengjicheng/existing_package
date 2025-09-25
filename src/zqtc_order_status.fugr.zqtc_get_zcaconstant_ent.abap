*-------------------------------------------------------------------
* PROGRAM NAME: ZQTC_GET_ZCACONSTANT_ENT
* PROGRAM DESCRIPTION: To get ZCA_CONSTANT table entries for given wricef id
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* CREATION DATE:   27-Jul-2027
* OBJECT ID:       This is a common FM.
* TRANSPORT NUMBER(S): ED2K907542
* DESCRIPTION: To develop a common function module to retrieve the
*              ZCACONSTANT entries based on give input paramter WRICEF id.
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------
FUNCTION zqtc_get_zcaconstant_ent .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_DEVID) TYPE  ZDEVID
*"  EXPORTING
*"     REFERENCE(EX_T_ZCACONS_ENT) TYPE  ZCAT_CONSTANTS
*"----------------------------------------------------------------------

  IF i_zcaconst_ent[] IS INITIAL.
    SELECT devid
           param1
           param2
           srno
           sign
           opti
           low
           high
           INTO TABLE i_zcaconst_ent
           FROM zcaconstant
           WHERE devid = im_devid
             AND activate = abap_true.
    IF sy-subrc EQ 0.
      ex_t_zcacons_ent[] = i_zcaconst_ent[].
    ENDIF.
  ELSE.
    ex_t_zcacons_ent[] = i_zcaconst_ent[].
  ENDIF.


ENDFUNCTION.
