"Name: \PR:ERPSLS_CUSTOMERS\FO:REUSE_ALV_LIST_DISPLAY\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_DISPLAY_ARCHIVED_CUST.
*BOC by NPOLINA on 04-Aug-2023 with ES1K901867
*To consider/display only archived customers in the report **
*  IF sy-uname = 'NPOLINA' OR sy-uname = 'SUKREDDY' OR sy-uname = 'SGURAJALA'.
*
*   TYPES: BEGIN OF lty_partner,
*            partner TYPE char10,
*            xdele   TYPE c,
*          END OF lty_partner.
*
*   DATA: li_arch_cust TYPE TABLE OF lty_partner.
*
*    IF lrt_customers IS NOT INITIAL.
*      "Fetch archived partners from BUT000
*      SELECT partner xdele
*        FROM BUT000
*        INTO TABLE li_arch_cust
*        FOR ALL ENTRIES IN lrt_customers
*        WHERE partner EQ lrt_customers-kunnr AND
*              xdele   EQ abap_true.
*      IF sy-subrc IS INITIAL.
*          SORT li_arch_cust BY partner.
*          LOOP AT lrt_customers ASSIGNING FIELD-SYMBOL(<lst_customers>).
*            READ TABLE li_arch_cust TRANSPORTING NO FIELDS WITH KEY partner = <lst_customers>-kunnr.
*            IF sy-subrc IS NOT INITIAL.
*              CLEAR: <lst_customers>-kunnr.
*            ENDIF.
*          ENDLOOP.
*          DELETE lrt_customers WHERE kunnr EQ space.
*          IF lrt_customers IS NOT INITIAL.
*            "Do nothing
*          ENDIF.
*      ENDIF.  "IF sy-subrc IS INITIAL.
*    ENDIF. "IF lrt_customers IS NOT INITIAL.
*  ENDIF. "IF sy-uname = 'NPOLINA' OR sy-uname = 'SUKREDDY' OR sy-uname = 'SGURAJALA'.
*  EOC by NPOLINA on 04-Aug-2023 with ES1K901867
ENDENHANCEMENT.
