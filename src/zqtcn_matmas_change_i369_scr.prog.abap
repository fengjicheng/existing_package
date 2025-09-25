* Include Name       :  ZQTCN_MATMAS_CHANGE_I369_SCR
* PROGRAM DESCRIPTION:  Report to get the BDCP2 unprocessed            *
*                       Change Pointer details against the Message Type*
*                       and Submit program “RBDSEMAT” (Tcode BD10)with *
*                       materials and Update the process indicator = ‘X’
*                       using FM CHANGE_POINTERS_STATUS_WRITE
* DEVELOPER:            MIMMADISET                                     *
* CREATION DATE:        03/30/2021                                     *
* OBJECT ID:            I0369.1                                        *
* TRANSPORT NUMBER(S):  ED2K922771                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
PARAMETERS: p_mestyp LIKE edmsg-msgtyp OBLIGATORY MODIF ID in.
SELECT-OPTIONS: s_mat FOR gv_matnr.
PARAMETERS:p_rep AS CHECKBOX USER-COMMAND cmd.
SELECT-OPTIONS:s_date FOR syst-datum MODIF ID gp1,
               s_time for syst-uzeit no-EXTENSION MODIF ID gp1.
