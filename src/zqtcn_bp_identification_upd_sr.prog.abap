*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_BP_IDENTIFICATION_UPD_SR (Include Program)      *
*REVISION NO :  ED2K919818                                            *
*REFERENCE NO:  OTCM-29968                                            *
*DEVELOPER  :   Lahiru Wathudura (LWATHUDURA)                         *
*WRICEF ID  :   E344                                                      *
*DATE       :  02/03/2021                                             *
*DESCRIPTION:  BP Identification creation                             *
*---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-001.
PARAMETERS:r_id  RADIOBUTTON GROUP abc USER-COMMAND rad DEFAULT 'X',
           r_cid RADIOBUTTON GROUP abc,
           r_pre RADIOBUTTON GROUP abc MODIF ID chg,
           r_pro RADIOBUTTON GROUP abc MODIF ID chg.

PARAMETERS: p_file TYPE rlgrap-filename,
            p_pre  TYPE bu_id_number MODIF ID pre,
            p_pro  TYPE bu_id_number MODIF ID pro.

SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.


  LOOP AT SCREEN.
*    IF screen-group1 = 'FIL'." OR screen-group1 = 'PRE'.
*      IF r_id IS INITIAL.
*        screen-input = 0.
*        screen-invisible = 1.
*      ENDIF.
*    ENDIF.
* BOC by Lahiru on 02/03/2021
    IF r_cid IS NOT INITIAL.
      IF screen-group1 = 'CHG'.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
* EOC by Lahiru on 02/03/2021

    IF screen-group1 = 'PRE'.
      IF r_pre IS INITIAL.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    IF screen-group1 = 'PRO'.
      IF r_pro IS INITIAL.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
