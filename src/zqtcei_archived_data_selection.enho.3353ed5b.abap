"Name: \PR:ERPSLS_CUSTOMERS\FO:DATA_SELECTION\SE:END\EI
ENHANCEMENT 0 ZQTCEI_ARCHIVED_DATA_SELECTION.
*
  IF sy-uname = 'NPOLINA' OR sy-uname = 'SGURAJALA' OR sy-uname = 'SUKREDDY'.
    IF lrt_customers[] IS NOT INITIAL.
      SELECT partner, xdele FROM BUT000 INTO TABLE @DATA(li_but000) FOR ALL ENTRIES IN @lrt_customers WHERE partner = @lrt_customers-kunnr.
        IF sy-subrc IS INITIAL.
          SORT li_but000 BY partner.
          LOOP AT lrt_Customers ASSIGNING FIELD-SYMBOL(<lst_customers>).
            READ TABLE li_but000 INTO DATA(lst_but000) WITH KEY partner = <lst_customers>-kunnr.
            IF sy-subrc IS INITIAL.
              <lst_customers>-xdele = lst_but000-xdele.
            ENDIF.
            CLEAR: lst_but000.
          ENDLOOP.
        ENDIF.
    ENDIF.
  ENDIF.

ENDENHANCEMENT.
