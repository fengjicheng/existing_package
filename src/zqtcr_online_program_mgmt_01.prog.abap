*&---------------------------------------------------------------------*
*&  Report         ZQTCR_ONLINE_PROGRAM_MGMT_01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ONLINE_PROGRAM_MGMT_01 (Main Program)
* PROGRAM DESCRIPTION: Create ZOPM (Online Program Management ) contracts
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   03/06/2019
* OBJECT ID:       TBD
* TRANSPORT NUMBER(S): ED2K914619
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *

REPORT ZQTCR_ONLINE_PROGRAM_MGMT_01 NO STANDARD PAGE HEADING
                                      MESSAGE-ID zqtc_r2.
** INCLUDES-------------------------------------------------------------*
INCLUDE ZQTCN_ONLINE_PRGM_MGMT_TOP IF FOUND.

INCLUDE ZQTCN_ONLINE_PRGM_MGMT_SEL IF FOUND.

INCLUDE ZQTCN_ONLINE_PRGM_MGMT_SUB IF FOUND.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

*** Get the File Path for Application Server
  CALL METHOD lcl_main=>get_file_path
    IMPORTING
      ex_file_path = v_file_path.

  sscrfields-functxt_01 = text-065.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL METHOD lcl_main=>f4help_file.

*====================================================================*
* AT SELECTION-SCREEN.
*====================================================================*
AT SELECTION-SCREEN.

  IF sy-ucomm = c_fc01.
    CALL METHOD lcl_main=>down_template.
  ELSE.

*** Validate KUNNR
*  CALL METHOD lcl_main=>validate_society
*    EXPORTING
*      im_kunnr        = p_kunnr
*    IMPORTING
*      ex_kunnr        = v_kunnr
*    EXCEPTIONS
*      invalid_society = 01.

  IF sy-subrc = 01.
    MESSAGE e509  WITH v_kunnr. " Invalid Society Number &
  ENDIF. " IF sy-subrc = 01

 ENDIF.
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
