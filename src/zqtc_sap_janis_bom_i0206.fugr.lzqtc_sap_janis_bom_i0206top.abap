FUNCTION-POOL zqtc_sap_janis_bom_i0206. "MESSAGE-ID ..

*******************
*FUNCTION-POOL BOMMAT_EXTRACTOR.             "MESSAGE-ID ..

TYPE-POOLS mdm01.

*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
*#* General Extractor
*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

DATA: g_s_msg LIKE balmi. " Application Log: APPL_LOG_WRITE_MESSAGES interface
DEFINE message_write.
  G_S_MSG-MSGID = &2.
  G_S_MSG-MSGTY = &3.
  G_S_MSG-MSGNO = &4.
  G_S_MSG-MSGV1 = &5.
  G_S_MSG-MSGV2 = &6.
  G_S_MSG-MSGV3 = &7.
  G_S_MSG-MSGV4 = &8.
  APPEND G_S_MSG TO &1.
END-OF-DEFINITION.

* Control parameters
DATA: g_blocksize       TYPE i,        " Blocksize of type Integers
      g_no_more_data(1),
      g_cursor          LIKE sy-tabix. " ABAP System Field: Row Index of Internal Tables

* Where table
DATA: g_t_where TYPE mdm01_t_where WITH HEADER LINE.

* Selection table
DATA: g_t_select TYPE mdm01_t_select.

* change number and date
DATA g_datuv TYPE d. " Datuv of type Date
DATA g_ale_datuv TYPE d. " Ale_datuv of type Date
DATA g_aennr LIKE aenr-aennr. " Change Number
DATA g_ale_aennr LIKE aenr-aennr. " Change Number

* logical name of target-system
DATA g_rcvprn LIKE  bdaledc-rcvprn. " Partner Number of Receiver

*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
*#* Extractor specific variables
*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

TABLES: mast. " Material to BOM Link

DATA: BEGIN OF g_s_key_base,
        matnr LIKE mast-matnr, " Material Number
        werks LIKE mast-werks, " Plant
        stlan LIKE mast-stlan, " BOM Usage
        stlnr LIKE mast-stlnr, " Bill of material
        stlal LIKE mast-stlal, " Alternative BOM
      END OF g_s_key_base.

DATA: BEGIN OF g_s_key,
        datuv     LIKE sy-datum,   " ABAP System Field: Current Date of Application Server
        ale_datuv LIKE sy-datum,   " ABAP System Field: Current Date of Application Server
        ale_aennr LIKE aenr-aennr. " Change Number
        INCLUDE STRUCTURE g_s_key_base. " "
DATA: END OF g_s_key.

* all BOMs which fulfill the select criteria
DATA g_t_key LIKE g_s_key OCCURS 0 WITH HEADER LINE.
DATA g_t_key_all LIKE g_s_key OCCURS 0 WITH HEADER LINE.
DATA g_t_changed LIKE g_s_key OCCURS 0 WITH HEADER LINE.
DATA g_t_chng_ptrs LIKE bdcp OCCURS 0 WITH HEADER LINE. " Change pointer
* all changed BOMs

* BOM-related constants
* ---------------------
CONSTANTS:
  c_true          VALUE 'X',
  c_marked        VALUE 'X',
*   bom types
  c_bomtyp_mat    VALUE 'M', "material bom
  c_bomtyp_doc    VALUE 'D', "document bom

*   bom processing flags
  c_bom_delete    LIKE stzub-vbkz     VALUE 'D', " Update indicator
  c_bom_insert    LIKE stzub-vbkz     VALUE 'I', " Update indicator
  c_bom_update    LIKE stzub-vbkz     VALUE 'U', " Update indicator
*   distribution flags (change pointers)
  c_dist_retail   VALUE 'R', "CP for retail only
  c_dist_initial  VALUE 'I', "initial distribution
*   message type
  c_mestyp        TYPE mdm01_mestyp VALUE 'BOMMAT',
  c_bomtyp_ord    VALUE 'K',                       "sales order bom

  c_mescod_create LIKE bdaledc-mestyp VALUE 'CRE', " Message Type
  c_mescod_change LIKE bdaledc-mestyp VALUE 'CNG', " Message Type
  c_mescod_update LIKE bdaledc-mestyp VALUE 'UPD', " Message Type
  c_mescod_delete LIKE bdaledc-mestyp VALUE 'DEL'. " Message Type

DATA:
  mastb LIKE mastb OCCURS 1 WITH HEADER LINE, " Document table for MAST records
  stzub LIKE stzub OCCURS 1 WITH HEADER LINE, " Permanent BOM data
  stkob LIKE stkob OCCURS 1 WITH HEADER LINE, " BOM Header Document Table
  stpoi LIKE stpoi OCCURS 0 WITH HEADER LINE, " Internal BOM Items (for APIs)
  stpub LIKE stpub OCCURS 0 WITH HEADER LINE. " BOMs - sub-item documents

DATA :                                         "mastb     like mastb  occurs 1 with header line,
  dostb LIKE dostb  OCCURS 0 WITH HEADER LINE, " Document Table for DOST Records
*     EQSTB     LIKE EQSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
*     TPSTB     LIKE TPSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
  kdstb LIKE kdstb  OCCURS 0 WITH HEADER LINE, " Buffer Table for KDST Records
*     STSTB     LIKE STSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
* recursivity (objects in classes)
  clrkb LIKE csclrk OCCURS 0 WITH HEADER LINE. " Recursiveness Info on Objects in Classes for BOM



DATA  smd_flag.
TABLES: stzu, stas, stpu.

DATA c_vbkz_sync        TYPE c    VALUE  'S'. " Vbkz_sync of type Character

DATA: ale_aennr LIKE aenr-aennr,   " Change Number
      flg_chid  LIKE csdata-xfeld. " Checkbox

* table of changepointers will be set to "processed"
DATA g_t_cpid_send LIKE bdicpident OCCURS 0 WITH HEADER LINE. " Change pointer IDs
DATA: g_flg_guid_into_idoc         TYPE c,                     "note 567351
      g_outb_bom_exit              TYPE REF TO if_ex_bom_exit, "note 567351
      g_fl_mdm_inbound_active,                                 "note 617329
      g_fl_mdm_outbound_active,                                "note 617329
      g_flg_guid_into_idoc_checked TYPE c.                     "note 567351



CONSTANTS:                   gc_extobj LIKE mdmextrhead-extrobject " MDM Extraction Object
                                       VALUE 'BOMMAT_EXTRACT'.

*******************

* INCLUDE LZQTC_SAP_TO_JANIS_BOM_I020D...    " Local class definition
