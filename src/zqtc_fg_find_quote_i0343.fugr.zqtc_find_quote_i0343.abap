FUNCTION zqtc_find_quote_i0343.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_IHREZ) TYPE  EDI3413LA OPTIONAL
*"  EXPORTING
*"     VALUE(EX_QUOTE) TYPE  IHREZ
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_FIND_QUOTE_I0343(FM)
* PROGRAM DESCRIPTION: This FM is built to find the quote number.
* This has been called for ZREW orders inside userexit of inbound ORDERS IDoc
* DEVELOPER: Parbhu
* CREATION DATE: 02/12/2019
* OBJECT ID: I0343/CR7318
* TRANSPORT NUMBER(S): ED2K913970
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
**---------------------------------------------------------------------*
*
*-----------------------------------------------------------------------*
  TYPES :BEGIN OF lty_vbkd,
           vbeln TYPE vbeln,
         END OF lty_vbkd,
         BEGIN OF lty_vbak,
           vbeln TYPE vbeln_va,
           erdat TYPE erdat,
           erzet TYPE erzet,
         END OF   lty_vbak.
  CONSTANTS : lc_b  TYPE char1 VALUE 'B'.
  DATA: li_vbkd TYPE STANDARD TABLE OF lty_vbkd, " VBKD fields
        li_vbak TYPE STANDARD TABLE OF lty_vbak. " Vbak fields
  CLEAR : li_vbkd[],li_vbak[],ex_quote.
*--*Look for Quote directly
  IF im_ihrez IS NOT INITIAL.
    SELECT SINGLE vbeln FROM vbak INTO ex_quote WHERE vbeln = im_ihrez
                                               AND   vbtyp EQ lc_b.
    IF sy-subrc NE 0."Input is not quote
*--*Check if the reference document is matching with your reference
      SELECT vbeln FROM vbkd INTO TABLE li_vbkd
                                     WHERE ihrez EQ im_ihrez.
      IF sy-subrc EQ 0 AND li_vbkd IS NOT INITIAL.
*--*Get the multiple existing quotes
        SELECT vbeln erdat erzet FROM vbak INTO TABLE li_vbak
                                    FOR ALL ENTRIES IN li_vbkd
                                    WHERE vbeln EQ li_vbkd-vbeln
                                    AND   vbtyp EQ lc_b.
        IF sy-subrc EQ 0 AND li_vbak IS NOT INITIAL.
*--*Consider latest document
          SORT li_vbak BY erdat DESCENDING erzet DESCENDING.
          READ TABLE li_vbak INTO DATA(lst_vbak) INDEX 1.
          IF  sy-subrc EQ 0.
            ex_quote = lst_vbak-vbeln.
          ENDIF. "IF sy-subrc eq 0
        ENDIF. " I_vbak is not initail
      ENDIF. "i_vbkd is not initial
    ENDIF."IF sy-subrc ne 0
  ENDIF." IF im_ihrez IS NOT INITIAL.
ENDFUNCTION.
