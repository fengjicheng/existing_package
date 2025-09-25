FUNCTION zqtc_edi_path_create_mestyp.
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
* REVISION NO : ED2K921900                                           *
* REFERENCE NO: OTCM-29968                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 02/15/2021                                             *
* DESCRIPTION : INC0313695 -Knewton Customer: Follett Higher Education *
*               Group requires invoices via EDI : Change the File name
*               standard with adding the date and time                 *
*----------------------------------------------------------------------*

  DATA: BEGIN OF help_path,
          field1(70),                  " directory from port
          field2(10),                  " subdirectory from receiver
          field3(1)  VALUE '_',        " directory delimiter
*                          changed 06.04.95 (was '/').
*                          Directories are not required any more.
* BOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
          " field4(8),                   " file from IDoc number
          field4(1)  VALUE '_',         " Number delimiter
          field5(8),                   " Current date
          field6(8),                   " current time
* EOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
        END OF help_path.              " total 89 bytes into 100 bytes

* BOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
  DATA : lv_ts   TYPE timestamp,
         lv_date TYPE d,
         lv_time TYPE t.
* EOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *

* the following parameters are not in use with this module
  CLEAR: datatype,
         filename,
* BOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
         lv_ts,
         lv_date,
         lv_time.
* EOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *


* take the directory from the port definition
  help_path-field1 = directory.

* take the subdirectory from the control record,
*   it is assumed that the directory exists!
  help_path-field2 = control-mestyp.
  CONCATENATE help_path-field2 'EDI' INTO help_path-field2.
  TRANSLATE help_path-field2 TO UPPER CASE.
* take the file name from the control record,
*   for MS environment take right-most 8 bytes only!
* BOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
  " help_path-field4 = control-docnum+8(8).
* EOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *


* BOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *
  GET TIME STAMP FIELD lv_ts.
  CONVERT TIME STAMP lv_ts TIME ZONE 'EST' INTO DATE lv_date TIME lv_time.
  MOVE lv_date TO help_path-field5.
  MOVE lv_time TO help_path-field6.
* EOC by Lahiru on 02/15/2021 for OTCM-29968 with ED2K921900 *

  CONDENSE help_path NO-GAPS.
  pathname = help_path.

ENDFUNCTION.
