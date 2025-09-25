FUNCTION zqtc_manage_disc_constants.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_DEVID) TYPE  ZDEVID
*"  EXPORTING
*"     REFERENCE(EX_CONSTANTS) TYPE  ZCAT_CONSTANTS
*"----------------------------------------------------------------------

* Check for Development ID
  READ TABLE i_constants TRANSPORTING NO FIELDS
       WITH KEY devid = im_devid
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Get data from constant table
    SELECT devid                                               "Development ID
           param1                                              "ABAP: Name of Variant Variable
           param2                                              "ABAP: Name of Variant Variable
           srno                                                "ABAP: Current selection number
           sign                                                "ABAP: ID: I/E (include/exclude values)
           opti                                                "ABAP: Selection option (EQ/BT/CP/...)
           low                                                 "Lower Value of Selection Condition
           high                                                "Upper Value of Selection Condition
      FROM zcaconstant                                         "Wiley Application Constant Table
      APPENDING TABLE i_constants
     WHERE devid    EQ im_devid
       AND activate EQ abap_true.                              "Only active record
    IF sy-subrc IS INITIAL.
      SORT i_constants BY devid param1 param2 srno.
    ENDIF.
  ENDIF.

* Entries with specific Development ID
  ex_constants[] = i_constants[].
  DELETE ex_constants WHERE devid NE im_devid.

ENDFUNCTION.
