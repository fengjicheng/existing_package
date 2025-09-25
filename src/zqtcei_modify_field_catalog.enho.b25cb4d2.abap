"Name: \PR:ERPSLS_CUSTOMERS\FO:FILL_FIELDCATALOG\SE:END\EI
ENHANCEMENT 0 ZQTCEI_MODIFY_FIELD_CATALOG.
*
  IF sy-uname = 'NPOLINA' OR sy-uname = 'SGURAJALA' OR sy-uname = 'SUKREDDY'.

    LOOP AT lrt_fieldcat ASSIGNING FIELD-SYMBOL(<lst_fieldcat>) .
      IF <lst_fieldcat>-fieldname = 'XDELE'.
        <lst_fieldcat>-seltext_l = 'Archiving Flag'.
        <lst_fieldcat>-seltext_m = 'Archiving Flag'.
        <lst_fieldcat>-seltext_s = 'Arch'.
      ENDIF.
    ENDLOOP.

  ENDIF.
ENDENHANCEMENT.
