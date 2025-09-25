*&---------------------------------------------------------------------*
*& Report  ZCUSTOMER_LINK_CHECK_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZCUSTOMER_LINK_CHECK_REPORT.

* Local type
 types:  begin of lty_bp_customer_ids,
         partner_guid  type bu_partner_guid,
         customer      type kunnr,
         del_flag      type boole-boole,
        end of lty_bp_customer_ids.

* Local data declarations
DATA:
    lv_msg                    type char255,
    lv_kunnr                  type kna1-kunnr,
    lv_dbcnt                  type char10,
    lv_partner_guid           type but000-partner_guid,
    db_customer              type cursor,
    ls_bp_customer_ids        type lty_bp_customer_ids,
    lt_bp_customer_ids        type table of lty_bp_customer_ids,
    ls_entries_to_delete      like cvi_cust_link,
    lt_entries_to_delete      like table of ls_entries_to_delete.


CONSTANTS: lc_x         type boole-boole VALUE 'X',
          lc_pkg_size  type char5       VALUE '10000'.

PARAMETERS TESTMODE TYPE boole_d AS CHECKBOX DEFAULT 'X'.

CLEAR: lv_msg,
       lv_dbcnt,
       ls_bp_customer_ids,
       ls_entries_to_delete.

REFRESH lt_entries_to_delete.

OPEN CURSOR db_customer FOR
     select PARTNER_GUID CUSTOMER from cvi_cust_link.

DO.

clear ls_bp_customer_ids.
refresh lt_bp_customer_ids.
FETCH NEXT CURSOR db_customer INTO CORRESPONDING FIELDS OF TABLE lt_bp_customer_ids
                              PACKAGE SIZE lc_pkg_size.
  IF sy-subrc <> 0.
     EXIT.
  ELSE.
    LOOP AT lt_bp_customer_ids INTO ls_bp_customer_ids.
      clear lv_partner_guid.
      select single partner_guid FROM  but000
                                INTO  lv_partner_guid
                                WHERE partner_guid = ls_bp_customer_ids-partner_guid.

        IF sy-subrc <> 0.
          ls_bp_customer_ids-del_flag = lc_x.
        ELSE.
          clear lv_kunnr.
          select single kunnr FROM  kna1
                              INTO  lv_kunnr
                              WHERE kunnr = ls_bp_customer_ids-customer.

           IF sy-subrc <> 0.
               ls_bp_customer_ids-del_flag = lc_x.
           ENDIF.
        ENDIF.
        IF ls_bp_customer_ids-del_flag = lc_x.
          CLEAR ls_entries_to_delete.
          ls_entries_to_delete-partner_guid = ls_bp_customer_ids-partner_guid.
          ls_entries_to_delete-customer = ls_bp_customer_ids-customer.
          APPEND ls_entries_to_delete TO lt_entries_to_delete.
        ENDIF.
    ENDLOOP.
  ENDIF.

ENDDO.

CLOSE CURSOR db_customer.



IF TESTMODE is INITIAL.
  IF lt_entries_to_delete is not initial.
     DELETE cvi_cust_link FROM TABLE lt_entries_to_delete.
     lv_dbcnt = sy-dbcnt.
     lv_msg = text-002.
     CONCATENATE lv_msg text-003 INTO lv_msg SEPARATED BY space.
     CONCATENATE lv_msg lv_dbcnt INTO lv_msg SEPARATED BY space.
    COMMIT WORK.
 write text-005.
 NEW-LINE.
 ULINE.
 write : 'Business partner GUID'.
 write :36 'Customer Number'.

    LOOP AT lt_entries_to_delete into ls_entries_to_delete.
       NEW-LINE.
       write:  ls_entries_to_delete-PARTNER_GUID ,space,ls_entries_to_delete-customer.
       CLEAR: ls_entries_to_delete.

   ENDLOOP.
    else.
      lv_msg = text-001.

  ENDIF.
  write lv_msg.
ELSE.
   IF lt_entries_to_delete is not initial.
 write text-004.
 NEW-LINE.
 ULINE.
 write : 'Business partner GUID'.
 write :36 'Customer Number'.

    LOOP AT lt_entries_to_delete into ls_entries_to_delete.
       NEW-LINE.
       write:  ls_entries_to_delete-PARTNER_GUID ,space,ls_entries_to_delete-customer.
       CLEAR: ls_entries_to_delete.

   ENDLOOP.
   ENDIF.
ENDIF.
