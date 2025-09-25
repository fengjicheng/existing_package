*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_OUTBOUND_DELIVERY (Main Program)
* PROGRAM DESCRIPTION: Outbound Delivery to JFDS
* DEVELOPER: Priyanka Mitra (PRMITRA)
* CREATION DATE:   12/23/2016
* OBJECT ID:  I0255
* TRANSPORT NUMBER(S): ED2K903844
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903844
* REFERENCE NO: ERP-1599
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 02/26/2017
* DESCRIPTION: Fetch open delivery and populate the logic for back label.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903844
* REFERENCE NO: CR#371 & 435
* DEVELOPER: Monalisa Dutta
* DATE: 02/26/2017
* DESCRIPTION:
* 1) Split file based on variant field in ZQTC_I0255_SPLIT table
* 2) Send the file in email in case of manual execution
* 3) Display records in ALV
*----------------------------------------------------------------------*
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K906000
*** REFERENCE NO:  JIRA Defect# ERP-2048
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-11
*** DESCRIPTION: To correct the SORT of internal table as it was commented
* out commenting of the CR changes. .
*&---------------------------------------------------------------------*
*** REVISION NO: ED2K906029
*** REFERENCE NO:  CR#571
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-06-29
*** DESCRIPTION: To include street4 and street5 fields from ADRC table into
***              existing stras field in the output.
*&---------------------------------------------------------------------*
*** REVISION NO: ED2K908521
*** REFERENCE NO: ERP-4427
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-09-13
*** DESCRIPTION: As per the present requirement program doesn't need to take
***              care of the last run date as this will be controlled through
***              selection screen. So commenting the code of checking ZCAINTERFACE.
*&---------------------------------------------------------------------*
* REVISION NO: ED2K910783                                              *
* REFERENCE NO: ERP-6478                                               *
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)                             *
* DATE:  09-Feb-2018                                                   *
* DESCRIPTION: To add a validation on the application server path for  *
*              download option to avoid any termination.               *
*----------------------------------------------------------------------*
* REVISION NO:  ED2K911914/ED2K911985                                   *
* REFERENCE NO: ERP-7404                                                *
* DEVELOPER:    GKINTALI (Geeta Kintali)/ HIPATEL (Himanshu Patel)      *
* DATE:         16-Apr-2018                                             *
* DESCRIPTION:  1. Conditional split file generation is enhanced with 2 *
*                  additional fields: VKORG (Sales Org) and KDKG2       *
*                  (Condition Group2) for both ML and BL.               *
*               2. Label File Generaton check box is added on selection *
*                  to restrict file generaton                           *
*               3. Logic is added to generate ALV report for both ML and*
*                  BL to simulate the process and show total no of files*
*                  to be generated with additional fields:VKORG, PLTYP  *
*                  and File Name in the ALV report                      *
*               4. A custom table: ZQTC_I0255_LBLSM is created and      *
*                  is updated with the required data upon each file     *
*                  generation for both ML and BL                        *
*               5. Logic added not to populate hyphen separator i.e.,   *
*                 “EM –“ or “EB – for the field: Shipping Reference with*
*                  respect to EMLO & EBLO if the Order type is “ZSRO”.  *
*               6. Logic added for Authorization check for object       *
*                  ZDEL_I0255                                           *
*               7. VAT Regn. number for Canada read from ZCACONSTANT    *
*                  table                                                *
*               8. Date Format check box is added on selection screen   *
*                  and accordingly date format is changed in the file   *
*                  during its population as DD-MMM-YYYY                 *
*-----------------------------------------------------------------------*
*& Report  ZQTCI_OUTBOUND_DELIVERY
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909086 / ED1K909240
* REFERENCE NO: RITM0092591
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE: 12/04/2018
* DESCRIPTION: Shipping Instruction trancating after first line.
*              Increasing length of Shipping Instruction field to 255
*              character
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910250
* REFERENCE NO: INC0241797
* DEVELOPER: Lakshminarayana (LRRAMIREDD)
* DATE: 30/05/2019
* DESCRIPTION: Exclude the delivery item category(ZCSE,ZCNE) in BL File
* and in ALV Output
*----------------------------------------------------------------------*
REPORT zqtci_outbound_delivery.

INCLUDE zqtcn_outbound_delivery_top IF FOUND.        "Declaration
INCLUDE zqtcn_outbound_delivery_sel IF FOUND.        "Selection Screen
INCLUDE zqtcn_outbound_delivery_sub IF FOUND.        "Sub routine

AT SELECTION-SCREEN OUTPUT.
* Get selection screen field
  PERFORM f_selection_screen.

INITIALIZATION.
* Begin of Change by PBANDLAPAL on 06-Sep-2017 ERP-4427: ED2K908521
* Get last run date for selection screen field
*  PERFORM f_run_date  CHANGING s_date[].
* End of Change by PBANDLAPAL on 06-Sep-2017 ERP-4427: ED2K908521

*  Get constant table
  PERFORM f_get_constant CHANGING i_constant.

AT SELECTION-SCREEN ON s_ship.
* Get validate Shipping point
  PERFORM f_validate_shippment USING s_ship[].

AT SELECTION-SCREEN ON s_matnr.
* Get validate material
  PERFORM f_validate_material USING s_matnr[].

AT SELECTION-SCREEN ON s_plant.
* Get validate plant
  PERFORM f_validate_plant USING s_plant[].

AT SELECTION-SCREEN ON s_type.
* Get validate material type
  PERFORM f_validate_material_type USING s_type[].

AT SELECTION-SCREEN ON s_doc1.
* Get validate document type
  PERFORM f_validate_doc_type1 USING s_doc1[].

AT SELECTION-SCREEN ON s_doc2.
* Get validate document type
  PERFORM f_validate_doc_type2 USING s_doc2[].

AT SELECTION-SCREEN ON s_item.
* Get validate item category
  PERFORM f_validate_item_cat USING s_item[].

AT SELECTION-SCREEN ON s_acct.
* Get validate account assignment
  PERFORM f_validate_account_assign USING s_acct[].

AT SELECTION-SCREEN ON s_vend.
* Get validate vendor
  PERFORM f_validate_vendor USING s_vend[].

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
* Get F4 help in file path
  PERFORM f_f4_file_path USING p_file.

*<<<<<<<<<<BOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dwnld.
* Get F4 help in presentation server file path
  PERFORM f_f4_pres_path USING p_dwnld.
*<<<<<<<<<<EOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>

*<<<<<<<<<<BOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>
AT SELECTION-SCREEN.
  IF rb3 EQ abap_true
* BOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
*    AND sy-ucomm = c_onli.
    AND sy-ucomm NE c_ucomm_flag.
* EOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
    PERFORM f_validate_file USING p_file.
  ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>

START-OF-SELECTION.
* Get File input path
  PERFORM f_input_data USING p_file.
* Get data
  PERFORM f_get_data.

*<<<<<<<<<<BOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>
END-OF-SELECTION.
*BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*  IF i_output IS NOT INITIAL AND rb3 EQ abap_true.
  IF i_output IS NOT INITIAL. " AND rb3 EQ abap_true.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
    PERFORM f_display_output.
  ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 02/06/2017 for CR#371 & 435>>>>>>>>>>>>>
