*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OUTBOUND_DELIVERY_SEL
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OUTBOUND_DELIVERY (Include Program)
* PROGRAM DESCRIPTION: Outbound Delivery to JFDS
* DEVELOPER: Priyanka Mitra (PRMITRA)
* CREATION DATE:   12/23/2016
* OBJECT ID:  I0255
* TRANSPORT NUMBER(S): ED2K903844
*----------------------------------------------------------------------*
* PROGRAM DESCRIPTION: Selection screen design
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE:   02/26/2017
* OBJECT ID:  I0255
* TRANSPORT NUMBER(S): ED2K903844
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K907329
*** REFERENCE NO:  ERP-3326
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-07-18
*** DESCRIPTION: During the Batch job processing the variants are run with
***              only creation date and not with material numbers. Hence
***              Selects are changed accordingly. I have done the code
***              cleaning and hence no tags are found for this defect.
***              To see the actual changes we can go to version comparison.
*&---------------------------------------------------------------------*
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
* REVISION NO:  ED1K907377                                              *
* REFERENCE NO: RITM0025850 & CR - ERP-7478                             *
* DEVELOPER:    GKINTALI (Geeta Kintali)                                *
* DATE:         18-May-2018                                             *
* DESCRIPTION:  1. To include the field STREET2 (ADRC-STR_SUPPL1) field *
*                  in to Address.                                       *
*               2. Region code and descriptions based on the selection  *
*                  screen input                                         *
*               3. Adjusting the lgoic for Address Lines 1,2,3 and 4 to *
*                  accommodate Steet2                                   *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907523                                              *
* REFERENCE NO: I0255 - INC0200998 - CR - CHG0040278                    *
* DEVELOPER:    HIPATEL (Himanshu Patel)                                *
* DATE:         29-Jun-2018                                             *
* DESCRIPTION:  1. To avoid Special character Dump in FM :              *
*                  HR_KR_STRING_TO_XSTRING  Implemented same FM with    *
*                  CodePage value to avoid raise Exceptions             *
*               2. Add New ALV output Column called Subscription Number *
*               3. Populate the VBKD-IHREZ value into Subscription      *
*                  Reference                                            *
*               4. Add a check Box on selection screen called Delivery  *
*                  completed.                                           *
*                  Main Label–All EKPO-ELIKZ info should displayed      *
*                  Back Label – All VBUK-WBSTK should be displayed      *
*               5. Issue Description Field - Print first 15 Character   *
*                  of Media issue                                       *
*               6. Media Product in the Main Label naming convention    *
*                  should be replaced with first 4 character of Media   *
*                  Issue                                                *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907899 / ED1K907981                                 *
* REFERENCE NO: INC0200998 & CHG0040278                                 *
* DEVELOPER:    HIPATEL (Himanshu Patel)                                *
* DATE:         06-July-2018                                            *
* DESCRIPTION:  1. Main Label - Split based on selection screen         *
*                  Added two split Radio button - Material & Variant    *
*               2. Added field on selection screen for Subscription     *
*                  reference field character in file                    *
*               3. Added checkbox field for Variant split in custom     *
*                  table ZQTC_I0255_SPLIT. Selected variant only cover  *
*                  in Variant split                                     *
*               4. Unconditional scenario: Variant split logic added +  *
*                  Varinat name fetching from ZCACONSTANT table         *
*               5. File Naming convention changed for Material split &  *
*                  Variant split                                        *
*-----------------------------------------------------------------------*
* Selection Screen Declaration
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
SELECTION-SCREEN begin of LINE.
PARAMETERS : rb1 RADIOBUTTON GROUP rdgr USER-COMMAND flag DEFAULT 'X'. "Main Label
SELECTION-SCREEN COMMENT 5(10) text-s06 FOR FIELD rb1.
SELECTION-SCREEN POSITION 78.
PARAMETERS : cb_lbl AS CHECKBOX USER-COMMAND flag MODIF ID g6.    "LBL File Generation
SELECTION-SCREEN COMMENT 79(20) text-s07 FOR FIELD cb_lbl.
SELECTION-SCREEN END of LINE.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
* BOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
SELECTION-SCREEN begin of LINE.
PARAMETERS : rb2 RADIOBUTTON GROUP rdgr. "Back Label
SELECTION-SCREEN COMMENT 5(10) text-s09 FOR FIELD rb2.
SELECTION-SCREEN POSITION 78.
PARAMETERS : cb_date AS CHECKBOX USER-COMMAND flag MODIF ID g7.    "Date Format
SELECTION-SCREEN COMMENT 79(30) text-s08 FOR FIELD cb_date.
SELECTION-SCREEN END of LINE.
* EOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
SELECTION-SCREEN begin of LINE.
PARAMETERS : rb3 RADIOBUTTON GROUP rdgr. "Added by MODUTTA for CR#371 on 06/01/2017
SELECTION-SCREEN COMMENT 5(15) text-s11 FOR FIELD rb3.
SELECTION-SCREEN POSITION 78.
PARAMETERS : cb_del AS CHECKBOX USER-COMMAND flag MODIF ID g8.    "Delivery Completed
SELECTION-SCREEN COMMENT 79(30) text-s12 FOR FIELD cb_del.
SELECTION-SCREEN END of LINE.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.

PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID g4, " Local file for upload/download
            p_dwnld TYPE rlgrap-filename MODIF ID g5. "Local file for file download
SELECTION-SCREEN END OF BLOCK b4.
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*Split Scenario-Options
SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-s13.     "Split Option
SELECTION-SCREEN begin of LINE.
PARAMETERS : rb_mat RADIOBUTTON GROUP rdsp  MODIF ID g9 DEFAULT 'X'.    "Material
SELECTION-SCREEN COMMENT 5(25) text-s14 FOR FIELD rb_mat MODIF ID g9.
SELECTION-SCREEN POSITION 32.
PARAMETERS : rb_var RADIOBUTTON GROUP rdsp MODIF ID g9.    "Variant
SELECTION-SCREEN COMMENT 79(30) text-s15 FOR FIELD rb_var MODIF ID g9.
SELECTION-SCREEN END of LINE.
SELECTION-SCREEN END OF BLOCK b6.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
SELECT-OPTIONS : s_ship FOR v_ship OBLIGATORY MODIF ID g1 DEFAULT 'Z001'. "Shipping Point
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS : s_matnr FOR v_matnr MODIF ID g3,            "Material
                 s_plant FOR v_plant OBLIGATORY MODIF ID g2 DEFAULT '1017', "Plant
                 s_type  FOR v_type  OBLIGATORY MODIF ID g3 DEFAULT 'ZJIP', "Material Type
                 s_doc1  FOR v_doc1  OBLIGATORY MODIF ID g1 DEFAULT 'ZLF', "Document Type
                 s_doc2  FOR v_doc2  OBLIGATORY MODIF ID g2 DEFAULT 'NB' , "Document Type
                 s_item  FOR v_item  MODIF ID g2 DEFAULT '5',              "Item Category
                 s_acct  FOR v_acct  OBLIGATORY MODIF ID g2 DEFAULT 'X', "Account Assignment
                 s_vend  FOR v_vend  MODIF ID g2,            "Vendor
                 s_date  FOR v_date  MODIF ID g3.            "Document Date
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
PARAMETERS: p_char  TYPE i MODIF ID g3 DEFAULT '10'.         "Subscription Reference length
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
SELECTION-SCREEN END OF BLOCK b3.
* BOC - GKINTALI - 05/18/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s10.
 SELECT-OPTIONS: s_land1 FOR v_land1 NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b5.
* EOC - GKINTALI - 05/18/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
