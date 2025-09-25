*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_VBKD_SINGLE_READ (Function Module)
* PROGRAM DESCRIPTION: Read VBKD entry (Buffered)
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/19/2017
* OBJECT ID:           N/A
* TRANSPORT NUMBER(S): ED2K907268
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
FUNCTION zqtc_vbkd_single_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"     REFERENCE(IM_POSNR) TYPE  POSNR
*"     REFERENCE(IM_REFRESH_BUFFER) TYPE  FLAG DEFAULT SPACE
*"  EXPORTING
*"     REFERENCE(EX_VBKD) TYPE  VBKD
*"  EXCEPTIONS
*"      EXC_RECORD_NOT_FOUND
*"----------------------------------------------------------------------
* Refresh the Buffer, if requested
  IF im_refresh_buffer IS NOT INITIAL.
    CLEAR: i_buff_vbkd.
  ENDIF.

* Check if any entry exists for the SD Document Number
  READ TABLE i_buff_vbkd TRANSPORTING NO FIELDS
       WITH KEY vbeln = im_vbeln
       BINARY SEARCH.
  IF sy-subrc NE 0.                                        "If entry doesn't exist
*   Fetch details from Database (Sales Document: Business Data)
    SELECT *                                               "All Fields (can be used depending on business need)
      FROM vbkd                                            "Sales Document: Business Data
 APPENDING TABLE i_buff_vbkd
     WHERE vbeln EQ im_vbeln.
    IF sy-subrc EQ 0.
      SORT i_buff_vbkd BY vbeln posnr.
    ENDIF.
  ENDIF.

* Check with specific Item number of the SD document
  READ TABLE i_buff_vbkd INTO DATA(lst_buff_vbkd)
       WITH KEY vbeln = im_vbeln
                posnr = im_posnr
       BINARY SEARCH.
  IF sy-subrc NE 0.                                        "If entry doesn't exist
*   Cehck with generic (header) Item number of the SD document
    READ TABLE i_buff_vbkd INTO lst_buff_vbkd
         WITH KEY vbeln = im_vbeln
                  posnr = c_posnr_hdr
         BINARY SEARCH.
  ENDIF.
  IF sy-subrc EQ 0.
    ex_vbkd = lst_buff_vbkd.                               "Sales Document: Business Data
  ELSE.
    RAISE exc_record_not_found.
  ENDIF.

ENDFUNCTION.
