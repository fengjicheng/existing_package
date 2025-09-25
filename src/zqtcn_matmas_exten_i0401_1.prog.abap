*-------------------------------------------------------------------
* REVISION NO :  ED2K925269                                            *
* REFERENCE NO:  ASOTC-406                                             *
* DEVELOPER   : Rajkumar Madavoina(MRAJKUMAR)                          *
* DATE        : 04/05/2022                                             *
* DESCRIPTION : As part of ASOTC-496 Requirement,Updating              *
*               MARA-ZZSTEP_UUID through IDoc segment E1MARAM-MFPRN    *
*                                                                      *
*----------------------------------------------------------------------*
"CONSTANTS Declaration.
    CONSTANTS: lc_e1maram TYPE char7 VALUE 'E1MARAM'.
"Data Declaration
    DATA : lst_uuid   TYPE e1maram,
           lst_matnr  TYPE matnr,
           lst_stepid TYPE mara-zzstep_uuid.
    CLEAR: lst_stepid,
           lst_matnr,
           lst_uuid.
"Fetching UUID value from Segment
    READ TABLE idoc_data ASSIGNING FIELD-SYMBOL(<lfs_idoc>) WITH KEY segnam = lc_e1maram.
    IF  sy-subrc IS INITIAL
    AND <lfs_idoc> IS ASSIGNED
    AND <lfs_idoc>-segnam = lc_e1maram.
      lst_uuid = <lfs_idoc>-sdata.
      lst_stepid = lst_uuid-mfrpn.
      lst_matnr  = lst_uuid-matnr.
      CLEAR lst_uuid-mfrpn.
    ENDIF.
"Assigning UUID value to MARA-ZZSTEP_UUID field and Clearing MARA-MFRPN fields which is used
" to update MARA-STEP UUID field.
    LOOP AT mara_ueb
      ASSIGNING FIELD-SYMBOL(<lfs_mara>)
      WHERE matnr EQ lst_matnr.
        <lfs_mara>-zzstep_uuid = lst_stepid.
        CLEAR <lfs_mara>-mfrpn.
    ENDLOOP.
