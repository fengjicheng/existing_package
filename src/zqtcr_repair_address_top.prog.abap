*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_REPAIR_ADDRESS_TOP
* PROGRAM DESCRIPTION: This report uses a sales document order as input.
*                      The incorrect addresses in the specified document
*                      will be set to the standard address coming from
*                      customer master data. It is possible to maintain/change
*                      such a document afterwards.
*                      This report has a testflag. Please test the report
*                      carefully with this flag before changing data.
*                      - per Note 2713240 (Z_REPAIR_ADRNR_1)
* DEVELOPER:           Nikhiesh Palla (NPALLA).
* CREATION DATE:       09/13/2019
* OBJECT ID:
* TRANSPORT NUMBER(S): ED1K910781
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*
TABLES: vbpa.
TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         adrnr TYPE kna1-adrnr,
       END OF ty_kna1,
       BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber,
       END OF ty_adrc.

DATA: st_vbpa TYPE vbpa,
      st_kna1 TYPE ty_kna1,
      st_adrc TYPE ty_adrc,
      v_tabix TYPE sy-tabix.

DATA: i_vbpa TYPE STANDARD TABLE OF vbpa,
      i_adrc TYPE STANDARD TABLE OF ty_adrc,
      i_kna1 TYPE STANDARD TABLE OF ty_kna1.

CONSTANTS: c_adrnr TYPE adrc-addrnumber VALUE '9000000000'.
