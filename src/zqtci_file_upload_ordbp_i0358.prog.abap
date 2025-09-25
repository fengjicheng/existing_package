*&---------------------------------------------------------------------*
*&  Report         ZQTCI_FILE_UPLOAD_ORDBP_I0358
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_FILE_UPLOAD_ORDBP_I0358(Main Program)
* PROGRAM DESCRIPTION: Single Upload Process for BP/Order
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   08/13/2018
* OBJECT ID:  I0358
* TRANSPORT NUMBER(S):  ED2K913027
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:   1.0
* Reference No:  ERP7787
* Developer:     Nageswar (NPOLINA)
* Date:          02/18/2019
* Description:   Add Invoice Instructions to Upload
* TRANSPORT NUMBER(S):  ED2K914488
*------------------------------------------------------------------- *

REPORT zqtci_file_upload_ordbp_i0358 NO STANDARD PAGE HEADING
                                      MESSAGE-ID zqtc_r2.
** INCLUDES-------------------------------------------------------------*
INCLUDE zqtcn_file_upload_ordbp_top IF FOUND.
INCLUDE zqtcn_file_upload_ordbp_sel IF FOUND.
INCLUDE zqtcn_file_upload_ordbp_sub IF FOUND.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

*** Get the File Path for Application Server
  CALL METHOD lcl_main=>get_file_path
    IMPORTING
      ex_file_path = v_file_path.

* SOC by NPOLINA ERP7787     ED2K914488
  sscrfields-functxt_01 = text-065.
* EOC by NPOLINA ERP7787     ED2K914488

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL METHOD lcl_main=>f4help_file.

*====================================================================*
* AT SELECTION-SCREEN.
*====================================================================*
AT SELECTION-SCREEN.

* SOC by NPOLINA ERP7787     ED2K914488
  IF sy-ucomm = c_fc01.
    CALL METHOD lcl_main=>down_template.
  ELSE.
* EOC by NPOLINA ERP7787     ED2K914488
*** Validate KUNNR
  CALL METHOD lcl_main=>validate_society
    EXPORTING
      im_kunnr        = p_kunnr
    IMPORTING
      ex_kunnr        = v_kunnr
    EXCEPTIONS
      invalid_society = 01.

  IF sy-subrc = 01.
    MESSAGE e509  WITH v_kunnr. " Invalid Society Number &
  ENDIF. " IF sy-subrc = 01

 ENDIF.   "NPOLINA ERP7787     ED2K914488
*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
* Create Instance Of Class
  CREATE OBJECT o_main.
*** Call Method to fetch data from Excel
  CALL METHOD o_main->convert_excel.

*** Call Method to validate Customer
  CALL METHOD o_main->validate_customer.

*** Call Method to prepare CSV
  CALL METHOD o_main->prepare_csv.

*** Call Method to upload file to Application Server
  CALL METHOD o_main->file_upload.

*** Call Method to send an email
   CALL METHOD o_main->send_mail.
