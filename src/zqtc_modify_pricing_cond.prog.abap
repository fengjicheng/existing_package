*&---------------------------------------------------------------------*
*&  Include           ZQTC_MODIFY_PRICING_COND
*&---------------------------------------------------------------------*
IF sy-tcode = 'VA01'.
  ASSIGN ('(SAPFV45C)TVAK-AUART') TO FIELD-SYMBOL(<lfs_auart>).
  IF <lfs_auart> IS ASSIGNED AND <lfs_auart> = 'ZCR'.
    IF konv-koaid = 'A' OR konv-koaid = 'B' .
      konv-ksteu = 'C'.
    ENDIF.
  ENDIF.
ENDIF.
