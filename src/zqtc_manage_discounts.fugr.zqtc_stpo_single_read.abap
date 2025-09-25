*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_STPO_SINGLE_READ
* PROGRAM DESCRIPTION: Read BOM item
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07-JUN-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K906514
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909707
* REFERENCE NO: ERP-5406
* DEVELOPER: Writtick Roy (WROY)
* DATE:  04-DEC-2017
* DESCRIPTION: Fix the logic to identify the last BOM Item
*----------------------------------------------------------------------*
FUNCTION zqtc_stpo_single_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_ST_STPO_KEY) TYPE  RMXMS_STPO_TKEY
*"  EXPORTING
*"     REFERENCE(EX_ST_STPO_DET) TYPE  STPO
*"     REFERENCE(EX_LAST_BOM_COMP) TYPE  FLAG
*"  EXCEPTIONS
*"      EXC_INVALID_INPUT
*"----------------------------------------------------------------------

  READ TABLE i_stpo_detl TRANSPORTING NO FIELDS
       WITH KEY stlty = im_st_stpo_key-stlty                    "BOM category
                stlnr = im_st_stpo_key-stlnr                    "Bill of material
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Fetch BOM Items
*   SELECT * is being used, since this will be used as a Buffered
*   Function Module and will be used for future purposes as well.
    SELECT STPO~*,
           stas~stlal                                           "Alternate BOM
      FROM stpo
     INNER JOIN stas
        ON stas~stlty EQ stpo~stlty
       AND stas~stlnr EQ stpo~stlnr
       AND stas~stlkn EQ stpo~stlkn
      APPENDING TABLE @i_stpo_detl
     WHERE stpo~stlty = @im_st_stpo_key-stlty                   "BOM category
       AND stpo~stlnr = @im_st_stpo_key-stlnr.                  "Bill of material
    IF sy-subrc EQ 0.
      SORT i_stpo_detl BY stlty stlnr stlkn stpoz.

      i_stpo_sort[] = i_stpo_detl[].
      SORT i_stpo_sort BY stlty ASCENDING
                          stlnr ASCENDING
                          stlal ASCENDING
                          posnr DESCENDING.
    ENDIF.
  ENDIF.

  READ TABLE i_stpo_detl INTO DATA(lst_stpo_det)
     WITH KEY stlty = im_st_stpo_key-stlty                      "BOM category
              stlnr = im_st_stpo_key-stlnr                      "Bill of material
              stlkn = im_st_stpo_key-stlkn                      "BOM item node number
              stpoz = im_st_stpo_key-stpoz                      "Internal counter
     BINARY SEARCH.
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING lst_stpo_det TO ex_st_stpo_det.          "BOM item

    READ TABLE i_stpo_sort INTO DATA(lst_stpo_sort)
         WITH KEY stlty = lst_stpo_det-stlty                    "BOM category
                  stlnr = lst_stpo_det-stlnr                    "Bill of material
                  stlal = lst_stpo_det-stlal                    "Alternative BOM
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF lst_stpo_sort-stlkn = im_st_stpo_key-stlkn AND
         lst_stpo_sort-stpoz = im_st_stpo_key-stpoz.
        ex_last_bom_comp = abap_true.
      ENDIF.
    ENDIF.
  ELSE.
    RAISE exc_invalid_input.
  ENDIF.

ENDFUNCTION.
