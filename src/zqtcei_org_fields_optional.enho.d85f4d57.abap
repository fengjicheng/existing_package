"Name: \PR:SAPMV13A\EX:MV13AF0F_01\EI
ENHANCEMENT 0 ZQTCEI_ORG_FIELDS_OPTIONAL.
* Screen enhancement done to make field not mandatory
CASE screen-group2.
  WHEN 'ORG'.
    PERFORM field_not_obligate.
  WHEN others.
    CASE screen-name.
      WHEN 'KONA-WAERS'.
        PERFORM field_not_obligate.
      WHEN OTHERS.
*      Nothing to do
    ENDCASE.
ENDCASE.
ENDENHANCEMENT.
