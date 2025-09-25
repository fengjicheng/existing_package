*-------------------------------------------------------------------
* PROGRAM NAME: ZVENDOR_LINK_CHECK_REPORT
* PROGRAM DESCRIPTION: OSS 974504_Inconsistencies in link tables of
* master data sync (Table CVI_VEND_LINK)
* DEVELOPER: SAP / OSS implementation done by KBOSE
* CREATION DATE:   2017-02-07
* OBJECT ID: NA
* TRANSPORT NUMBER(S): ED1K904888
*-------------------------------------------------------------------
REPORT zvendor_link_check_report.

* Local type
TYPES:  BEGIN OF lty_bp_vendor_ids,
          partner_guid TYPE bu_partner_guid, " Business Partner GUID
          vendor       TYPE lifnr,           " Account Number of Vendor or Creditor
          del_flag     TYPE boole-boole,     " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        END OF lty_bp_vendor_ids.

* Local data declarations
DATA:
  lv_msg               TYPE char255,             " Msg of type CHAR255
  lv_lifnr             TYPE lfa1-lifnr,          " Account Number of Vendor or Creditor
  lv_dbcnt             TYPE char10,              " Dbcnt of type CHAR10
  lv_partner_guid      TYPE but000-partner_guid, " Business Partner GUID
  db_vendor            TYPE cursor,
  ls_bp_vendor_ids     TYPE lty_bp_vendor_ids,
  lt_bp_vendor_ids     TYPE TABLE OF lty_bp_vendor_ids,
  ls_entries_to_delete LIKE cvi_vend_link,       " Assignment Between Vendor and Business Partner
  lt_entries_to_delete LIKE TABLE OF ls_entries_to_delete.

CONSTANTS: lc_x        TYPE boole-boole VALUE 'X',     " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
           lc_pkg_size TYPE char5       VALUE '10000'. " Pkg_size of type CHAR5

CLEAR: lv_msg,
       lv_dbcnt,
       ls_bp_vendor_ids,
       ls_entries_to_delete.

REFRESH lt_entries_to_delete.

OPEN CURSOR db_vendor FOR
     SELECT partner_guid vendor FROM cvi_vend_link.

DO.

  CLEAR ls_bp_vendor_ids.
  REFRESH lt_bp_vendor_ids.

  FETCH NEXT CURSOR db_vendor INTO CORRESPONDING FIELDS OF TABLE lt_bp_vendor_ids
                              PACKAGE SIZE lc_pkg_size.

  IF sy-subrc <> 0.
    EXIT.
  ELSE. " ELSE -> IF sy-subrc <> 0
    LOOP AT lt_bp_vendor_ids INTO ls_bp_vendor_ids.
      CLEAR lv_partner_guid.
      SELECT SINGLE partner_guid FROM  but000 " BP: General data I
                                INTO  lv_partner_guid
                                WHERE partner_guid = ls_bp_vendor_ids-partner_guid.

      IF sy-subrc <> 0.
        ls_bp_vendor_ids-del_flag = lc_x.
      ELSE. " ELSE -> IF sy-subrc <> 0
        CLEAR lv_lifnr.
        SELECT SINGLE lifnr FROM  lfa1 " Vendor Master (General Section)
                            INTO  lv_lifnr
                            WHERE lifnr = ls_bp_vendor_ids-vendor.

        IF sy-subrc <> 0.
          ls_bp_vendor_ids-del_flag = lc_x.
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
      IF ls_bp_vendor_ids-del_flag = lc_x.
        CLEAR ls_entries_to_delete.
        ls_entries_to_delete-partner_guid = ls_bp_vendor_ids-partner_guid.
        ls_entries_to_delete-vendor = ls_bp_vendor_ids-vendor.
        APPEND ls_entries_to_delete TO lt_entries_to_delete.
      ENDIF. " IF ls_bp_vendor_ids-del_flag = lc_x
    ENDLOOP. " LOOP AT lt_bp_vendor_ids INTO ls_bp_vendor_ids
  ENDIF. " IF sy-subrc <> 0

ENDDO.

CLOSE CURSOR db_vendor.

IF lt_entries_to_delete IS NOT INITIAL.
  DELETE cvi_vend_link FROM TABLE lt_entries_to_delete.
  lv_dbcnt = sy-dbcnt.
  lv_msg = text-002.
  CONCATENATE lv_msg text-003 INTO lv_msg SEPARATED BY space.
  CONCATENATE lv_msg lv_dbcnt INTO lv_msg SEPARATED BY space.
ELSE. " ELSE -> IF lt_entries_to_delete IS NOT INITIAL
  lv_msg = text-001.
ENDIF. " IF lt_entries_to_delete IS NOT INITIAL

COMMIT WORK.

WRITE lv_msg.
