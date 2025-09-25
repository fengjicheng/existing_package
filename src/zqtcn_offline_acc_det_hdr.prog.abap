*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OFFLINE_ACC_DET_HDR
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_OFFLINE_ACC_DET_HDR (Include)
*                      [Requirements - Account Determination- 921]
* PROGRAM DESCRIPTION: Offline Account Determination
* DEVELOPER:           Himanshu Patel (HIPATEL)
* CREATION DATE:       11/05/2018
* OBJECT ID:           E156/CR-7660
* TRANSPORT NUMBER(S): ED2K913780
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

  SY-SUBRC = 4.
  CHECK: KOMKCV-ZZAUART1 = 'ZOFL'.
  CHECK: KOMKCV-ZZAUART = 'ZCR'.
  SY-SUBRC = 0.
