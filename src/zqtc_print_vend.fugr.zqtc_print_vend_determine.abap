*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PRINT_VEND_DETERMINE (Function Module)
* PROGRAM DESCRIPTION: Determine Print Vendor
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   01/15/2018
* OBJECT ID: I0231
* TRANSPORT NUMBER(S): ED2K910309
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_print_vend_determine.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_BUS_PRCOCESS) TYPE  ZBUS_PRCOCESS
*"     REFERENCE(IM_COUNTRY) TYPE  LAND1
*"     REFERENCE(IM_OUTPUT_TYPE) TYPE  NA_KSCHL
*"  EXPORTING
*"     REFERENCE(EX_PRINT_VENDOR) TYPE  ZPRINT_VENDOR
*"     REFERENCE(EX_PRINT_REGION) TYPE  ZPRINT_REGION
*"     REFERENCE(EX_COUNTRY_SORT) TYPE  ZCOUNTRY_SORT
*"     REFERENCE(EX_FILE_LOC) TYPE  FILE_NO
*"  EXCEPTIONS
*"      EXC_INVALID_BUS_PRC
*"      EXC_NO_ENTRY_FOUND
*"----------------------------------------------------------------------
* Buffering Concept to avoid multiple SELECTs
  READ TABLE i_print_vend TRANSPORTING NO FIELDS
       WITH KEY bus_prcocess = im_bus_prcocess                  "Business Process
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Fetch Print Vendor Details
*   SELECT * is used, since almost all the fields are required
    SELECT *
      FROM zqtc_print_vend
      INTO TABLE i_print_vend
     WHERE bus_prcocess EQ im_bus_prcocess                      "Business Process
     ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
*     Message: No entries exist for business process <Business Process>
      MESSAGE e040(ela) WITH im_bus_prcocess
      RAISING exc_invalid_bus_prc.
    ENDIF.
  ENDIF.

* Specific Country and Specific Currency
  READ TABLE i_print_vend ASSIGNING FIELD-SYMBOL(<lst_print_vend>)
       WITH KEY country     = im_country                        "Country
                output_type = im_output_type                    "Output Type
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Generic Country and Specific Currency
    READ TABLE i_print_vend ASSIGNING <lst_print_vend>
         WITH KEY country     = space                           "Country
                  output_type = im_output_type                  "Output Type
         BINARY SEARCH.
  ENDIF.
  IF sy-subrc NE 0.
*   Specific Country and Generic Currency
    READ TABLE i_print_vend ASSIGNING <lst_print_vend>
         WITH KEY country     = im_country                      "Country
                  output_type = space                           "Output Type
         BINARY SEARCH.
  ENDIF.
  IF sy-subrc NE 0.
*   Generic Country and Generic Currency
    READ TABLE i_print_vend ASSIGNING <lst_print_vend>
         WITH KEY country     = space                           "Country
                  output_type = space                           "Output Type
         BINARY SEARCH.
  ENDIF.
  IF sy-subrc EQ 0.
    ex_print_vendor = <lst_print_vend>-print_vendor.            "Third Party System (Print Vendor)
    ex_print_region = <lst_print_vend>-print_region.            "Print Region
    ex_country_sort = <lst_print_vend>-country_sort.            "Country Sorting Key
    ex_file_loc     = <lst_print_vend>-file_loc.                "Application Server File Path
  ELSE.
*   Message: No suitable entry found in table <Table Name>
    MESSAGE e001(jyedd) WITH 'ZQTC_PRINT_VEND'
    RAISING exc_no_entry_found.
  ENDIF.

ENDFUNCTION.
