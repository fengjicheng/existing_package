*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_EDI_DOC_ENTITLE_SAP (Main Program)
* PROGRAM DESCRIPTION: This program will Generate EDI Document for
* entitlements on subscription journals, an EDI document via a csv
* file from SAP will be sent to Allied or Aztec so they have the most
* current subscription data.
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   11/18/2016
* OBJECT ID:  I0296
* TRANSPORT NUMBER(S):   ED2K903359
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K904304
* Reference No:  CR334
* Developer: Monalisa Dutta
* Date: 2017-02-02
* Description: I0296- CR334 Adding more checks for data filteration
*------------------------------------------------------------------- *
REPORT zqtci_edi_doc_entitle_sap NO STANDARD PAGE HEADING
                                    MESSAGE-ID zqtc_r2.

** INCLUDES-------------------------------------------------------------*
INCLUDE zqtcn_edi_doc_entitle_sap_top IF FOUND.
INCLUDE zqtcn_edi_doc_entitle_sap_sel IF FOUND.
INCLUDE zqtcn_edi_doc_entitle_sap_sub IF FOUND.

**At selection-screen on Value-Request
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file. "Project Creation file

  PERFORM f_serverfile_f4.

* START OF SELECTION---------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_get_vbak_vbap.

* END OF SELECTION-----------------------------------------------------*
END-OF-SELECTION.
  IF i_final IS NOT INITIAL.
    PERFORM f_prepare_csv.
    PERFORM f_file_upload.
  ENDIF.
