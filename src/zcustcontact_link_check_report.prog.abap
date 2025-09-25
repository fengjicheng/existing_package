*-------------------------------------------------------------------
* PROGRAM NAME: ZCUSTCONTACT_LINK_CHECK_REPORT
* PROGRAM DESCRIPTION: OSS 974504_Inconsistencies in link tables of
* master data sync (Table CVI_CUST_CT_LINK)
* REQUIREMENT NO. SR_217290
* DEVELOPER: SAP / OSS implementation done by KBOSE
* CREATION DATE:   2017-02-07
* OBJECT ID: NA
* TRANSPORT NUMBER(S): ED1K904888
*-------------------------------------------------------------------
REPORT ZCUSTCONTACT_LINK_CHECK_REPORT.

* Local type
TYPES:  BEGIN OF lty_bp_cust_contact_ids,
          partner_guid  TYPE bu_partner_guid, " Business Partner GUID
          person_guid   TYPE bu_partner_guid, " Business Partner GUID
          customer_cont TYPE parnr,           " Number of contact person
          del_flag      TYPE boole-boole,     " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        END OF lty_bp_cust_contact_ids.

* Local data declarations
DATA:
  lv_msg                 TYPE char255,             " Msg of type CHAR255
  lv_dbcnt               TYPE char10,              " Dbcnt of type CHAR10
  lv_parnr               TYPE knvk-parnr,          " Number of contact person
  lv_person              TYPE bu_partner,          " Business Partner Number
  lv_partner             TYPE bu_partner,          " Business Partner Number
  lv_partnertmp          TYPE bu_partner,          " Business Partner Number
  lv_partner_guid        TYPE but000-partner_guid, " Business Partner GUID
  lv_person_guid         TYPE but000-partner_guid, " Business Partner GUID
  db_cust_contact        TYPE cursor,
  ls_bp_cust_contact_ids TYPE lty_bp_cust_contact_ids,
  lt_bp_cust_contact_ids TYPE TABLE OF lty_bp_cust_contact_ids,
  ls_entries_to_delete   LIKE cvi_cust_ct_link,    " Connec. Between Relationship + Activity Partner for Customer
  lt_entries_to_delete   LIKE TABLE OF ls_entries_to_delete.

CONSTANTS: lc_x        TYPE boole-boole VALUE 'X',      " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
           lc_reltyp   TYPE char6       VALUE 'BUR001', " Reltyp of type CHAR6
           lc_pkg_size TYPE char5       VALUE '10000'.  " Pkg_size of type CHAR5

CLEAR: lv_msg,
       lv_dbcnt,
       ls_entries_to_delete.

REFRESH lt_entries_to_delete.

OPEN CURSOR db_cust_contact FOR
     SELECT partner_guid person_guid customer_cont FROM cvi_cust_ct_link.

DO.

  CLEAR ls_bp_cust_contact_ids.
  REFRESH lt_bp_cust_contact_ids.

  FETCH NEXT CURSOR db_cust_contact INTO CORRESPONDING FIELDS OF TABLE lt_bp_cust_contact_ids
                                    PACKAGE SIZE lc_pkg_size.

  IF sy-subrc <> 0.
    EXIT.
  ELSE. " ELSE -> IF sy-subrc <> 0
    LOOP AT lt_bp_cust_contact_ids INTO ls_bp_cust_contact_ids.
      CLEAR lv_partner.
      SELECT SINGLE partner FROM  but000 " BP: General data I
                                INTO  lv_partner
                                WHERE partner_guid = ls_bp_cust_contact_ids-partner_guid.

      IF sy-subrc <> 0.
        ls_bp_cust_contact_ids-del_flag = lc_x.
      ELSE. " ELSE -> IF sy-subrc <> 0
        CLEAR lv_person.
        SELECT SINGLE partner FROM  but000 " BP: General data I
                                  INTO  lv_person
                                  WHERE partner_guid = ls_bp_cust_contact_ids-person_guid.

        IF sy-subrc <> 0.
          ls_bp_cust_contact_ids-del_flag = lc_x.
        ELSE. " ELSE -> IF sy-subrc <> 0
          CLEAR: lv_partnertmp.
          SELECT SINGLE partner1 FROM but051 " BP Relationship: Contact Person Relationship
                                 INTO lv_partnertmp
                                 WHERE ( partner1     = lv_partner
                                         AND partner2 = lv_person
                                         AND reltyp   = lc_reltyp )
                                       OR
                                       ( partner1     = lv_person
                                         AND partner2 = lv_partner
                                         AND reltyp   = lc_reltyp ).

          IF sy-subrc <> 0.
            ls_bp_cust_contact_ids-del_flag = lc_x.
          ELSE. " ELSE -> IF sy-subrc <> 0
            CLEAR lv_parnr.
            SELECT SINGLE parnr FROM  knvk " Customer Master Contact Partner
                               INTO  lv_parnr
                               WHERE parnr = ls_bp_cust_contact_ids-customer_cont.

            IF sy-subrc <> 0.
              ls_bp_cust_contact_ids-del_flag = lc_x.
            ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
      IF ls_bp_cust_contact_ids-del_flag = lc_x.
        CLEAR ls_entries_to_delete.
        ls_entries_to_delete-partner_guid = ls_bp_cust_contact_ids-partner_guid.
        ls_entries_to_delete-person_guid = ls_bp_cust_contact_ids-person_guid.
        ls_entries_to_delete-customer_cont = ls_bp_cust_contact_ids-customer_cont.
        APPEND ls_entries_to_delete TO lt_entries_to_delete.
      ENDIF. " IF ls_bp_cust_contact_ids-del_flag = lc_x
    ENDLOOP. " LOOP AT lt_bp_cust_contact_ids INTO ls_bp_cust_contact_ids
  ENDIF. " IF sy-subrc <> 0

ENDDO.

CLOSE CURSOR db_cust_contact.

IF lt_entries_to_delete IS NOT INITIAL.
  DELETE cvi_cust_ct_link FROM TABLE lt_entries_to_delete.
  lv_dbcnt = sy-dbcnt.
  lv_msg = text-002.
  CONCATENATE lv_msg text-003 INTO lv_msg SEPARATED BY space.
  CONCATENATE lv_msg lv_dbcnt INTO lv_msg SEPARATED BY space.
ELSE. " ELSE -> IF lt_entries_to_delete IS NOT INITIAL
  lv_msg = text-001.
ENDIF. " IF lt_entries_to_delete IS NOT INITIAL

COMMIT WORK.

WRITE lv_msg.
