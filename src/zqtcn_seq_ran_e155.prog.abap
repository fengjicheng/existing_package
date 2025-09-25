*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SEQ_RAN_E155 (Include)
*
* PROGRAM DESCRIPTION: This include is fetching seq number range
* from custom table and assigning to appropraite variable.
* DEVELOPER: Mounika Nallapaneni (nmounika)
* CREATION DATE:   21/03/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904952
*----------------------------------------------------------------------*
DATA: lv_nrrangenr TYPE nrnr. " Number range number
*Fetching seqential number range from custom table
* based on sales org and billing type.
SELECT SINGLE
       nrrangenr               " Number range number
      FROM zqtc_seq_num_ran    " Sequential Number Range for UK&Germany
      INTO lv_nrrangenr
  WHERE vkorg = vbrk-vkorg AND "Sales Org
        fkart = vbrk-fkart.    "Billing type
IF sy-subrc EQ 0.
  us_range_intern = lv_nrrangenr.
ENDIF . " IF sy-subrc EQ 0
no_buffer = abap_true.
