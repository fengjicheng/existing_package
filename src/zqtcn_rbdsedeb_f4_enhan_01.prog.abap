*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RBDSEDEB_F4_ENHAN_01
*&---------------------------------------------------------------------*

CONSTANTS : lc_mestyp_debmas_outb TYPE edi_msgtyp VALUE 'ZQTC_DEBMAS_OUTB', " Message type table
            lc_mestyp_debmas      TYPE edi_msgtyp VALUE 'DEBMAS'.           " Message type table

IF tbdme-refmestyp  <> lc_mestyp_debmas_outb
AND tbdme-refmestyp <> lc_mestyp_debmas.
  MESSAGE e101 WITH mestyp.
*   Der Nachrichtentyp & ist nicht vorhanden.
ENDIF. " IF tbdme-refmestyp <> lc_mestyp_debmas_outb
