*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_SAP_TO_JANIS_BOM_I0206                    *
* PROGRAM DESCRIPTION:  This Fm is copied from standard function       *
*                       module MDM_IDOC_CREATE_SMD_BOMMAT.This FM is   *
*                       implemented to get the BDCP2 unprocessed Change*
*                       Pointer details against the message Type       *
*                       ZQTC_BOMMAT and generate IDoc for every change *
*                       triggered.                                     *
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        30/01/2017                                     *
* OBJECT ID:            I0206                                          *
* TRANSPORT NUMBER(S):  ED2K904011                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_create_smd_bommat_i0206.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MESSAGE_TYPE) LIKE  TBDME-MESTYP
*"----------------------------------------------------------------------

* Type declaration for BDCP
  DATA: BEGIN OF t_chgptrs OCCURS 10.
          INCLUDE STRUCTURE bdcp. " Change pointer
  DATA: END OF t_chgptrs.

* Type declaration for BDCP
  DATA: BEGIN OF t_chgptrs_klim OCCURS 10.
          INCLUDE STRUCTURE bdcp. " Change pointer
  DATA: END OF t_chgptrs_klim.

* Type declaration for Change pointer IDs
  DATA: BEGIN OF lt_idents OCCURS 10.
          INCLUDE STRUCTURE bdicpident. " Change pointer IDs
  DATA: END OF lt_idents .

* Data declaration
  DATA: lv_tot_cp           TYPE sy-tabix,
        lv_cdchgno          LIKE t_chgptrs-cdchgno,
        lv_current_cdchgno  TYPE cdchangenr,
        lv_ctevs            TYPE char10,
        lv_ctchps           TYPE char10,
        lv_blk_times        TYPE sy-tabix,
        lv_sum_of_cre_idocs TYPE sy-tabix,
        lv_tot_idocs_cre    TYPE sy-tabix,
        lv_sum_of_cridocs   TYPE sy-tabix.
* Reset block behavior for bommat
  CALL FUNCTION 'CHANGE_POINTERS_READ_MODE_SET'
    EXPORTING
      message_type = 'ZQTC_BOMMAT'
      block_size   = 0
    EXCEPTIONS
      OTHERS       = 4.

* Read all not processed change pointers for the given messagetype,
  CALL FUNCTION 'CHANGE_POINTERS_READ'
    EXPORTING
      message_type                = message_type
      read_not_processed_pointers = 'X'
    TABLES
      change_pointers             = t_chgptrs.

  SORT t_chgptrs BY tabname tabkey .
  CLEAR lv_tot_cp.

  DESCRIBE TABLE t_chgptrs LINES lv_tot_cp.

  lv_blk_times = lv_tot_cp DIV 50000.
  lv_blk_times = lv_blk_times + 1.

  DO lv_blk_times TIMES.
* Call standard
    CALL FUNCTION 'CHANGE_POINTERS_READ_MODE_SET'
      EXPORTING
        message_type = message_type
        block_size   = 50000
      EXCEPTIONS
        OTHERS       = 1.

    CALL FUNCTION 'ZQTC_MASTERIDOC_CREATE_BOMMAT'
      EXPORTING
        message_type        = message_type
      IMPORTING
        ev_sum_of_cre_idocs = lv_sum_of_cre_idocs.

    lv_tot_idocs_cre = lv_tot_idocs_cre + lv_sum_of_cre_idocs.
    CLEAR lv_sum_of_cre_idocs.

  ENDDO.

  MESSAGE i038(b1) WITH lv_tot_idocs_cre message_type. " & master IDocs set up for message type &

  CLEAR: lv_tot_cp,
         lv_blk_times,
         lv_tot_idocs_cre.


ENDFUNCTION .
