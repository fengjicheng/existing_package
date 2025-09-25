FUNCTION zqtc_edipath_create_mestyp_apl.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(DATATYPE) LIKE  EDIPO-ACTRIG
*"     VALUE(DIRECTORY) LIKE  EDIPO-OUTPUTDIR
*"     VALUE(FILENAME) LIKE  EDIPO-OUTPUTFILE
*"     VALUE(CONTROL) LIKE  EDIDC STRUCTURE  EDIDC
*"  EXPORTING
*"     VALUE(PATHNAME) LIKE  EDI_PATH-PTHNAM
*"----------------------------------------------------------------------

*----------------------------------------------------------------------*
* REVISION NO : ED2K926183                                             *
* REFERENCE NO: QTC_I0505.1   "OTCM-29968                              *
* DEVELOPER   : Jagadeeswara Rao M (JMADAKA)                           *
* DATE        : 03/21/2022                                             *
* DESCRIPTION : Change the File name                                   *
*               standard with adding the date and time                 *
*----------------------------------------------------------------------*

  DATA: BEGIN OF help_path,
          field1(70),                  " directory from port
          field2(10),                  " subdirectory from receiver
          field3(1)  VALUE '_',        " directory delimiter
          field4(16) TYPE c,           " file from IDoc number
          field5(1)  VALUE '_',        " Number delimiter
          field6(8),                   " Current date
          field7(8),                   " current time
        END OF help_path.              " total 89 bytes into 100 bytes

  DATA : lv_ts   TYPE timestamp,
         lv_date TYPE d,
         lv_time TYPE t.

* the following parameters are not in use with this module
  CLEAR: datatype,
         filename,
         lv_ts,
         lv_date,
         lv_time.

* Take the directory from the port definition
  help_path-field1 = directory.

* Take the subdirectory from the control record,
*   it is assumed that the directory exists!
  help_path-field2 = control-mestyp.
  CONCATENATE '/' help_path-field2 'EDI_' INTO help_path-field2.
  TRANSLATE help_path-field2 TO UPPER CASE.
* Take IDoc Number from the control record,

  help_path-field4 = control-docnum.
  SHIFT help_path-field4 LEFT DELETING LEADING '0'.

  GET TIME STAMP FIELD lv_ts.
  CONVERT TIME STAMP lv_ts TIME ZONE 'EST' INTO DATE lv_date TIME lv_time.
  MOVE lv_date TO help_path-field6.
  MOVE lv_time TO help_path-field7.

  CONDENSE help_path NO-GAPS.
  pathname = help_path.

ENDFUNCTION.
