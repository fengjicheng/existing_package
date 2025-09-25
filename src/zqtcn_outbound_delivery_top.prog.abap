*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OUTBOUND_DELIVERY_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OUTBOUND_DELIVERY (Include Program)
* PROGRAM DESCRIPTION: Outbound Delivery to JFDS
* DEVELOPER: Priyanka Mitra (PRMITRA)
* CREATION DATE:   12/23/2016
* OBJECT ID:  I0255
* TRANSPORT NUMBER(S): ED2K903844
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OUTBOUND_DELIVERY (Include Program)
* PROGRAM DESCRIPTION: Declaraing Structure for back label
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
* REVISION NO: ED2K910783                                              *
* REFERENCE NO: ERP-6478                                               *
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)                             *
* DATE:  09-Feb-2018                                                   *
* DESCRIPTION: To add a validation on the application server path for  *
*              download option to avoid any termination.               *
*----------------------------------------------------------------------*
* REVISION NO:  ED2K910947                                             *
* REFERENCE NO: ERP-6967                                               *
* DEVELOPER:    GKINTALI (Geeta Kintali)                               *
* DATE:         13-Mar-2018                                            *
* DESCRIPTION:  1. To update the file label name changes as per the    *
*               requirement.                                           *
*               2. In case of Address Line3 exceeding 50 characters in *
*               length, concatenating Address Lines2,3 and 4 and       *
*               wrapping across Address Lines2,3 and 4 holding each 50 *
*               characters with a semi-colon separator                 *
*               3. Avoiding multiple commas being concatenated in case *
*               of blank field values for Address Line3                *
*               4. Logic added to consider ADRC-STREET instead of      *
*               LFA1-STRAS or KNA1-STRAS                               *
*               5. Logic added to consider Long Description of Country *
*               (LANDX50) instead of 15-char description (LANDX)       *
*               6. Logic added to concatenate Tilte(ANRED) with NAME1  *
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
*                  during its population and in ALV as DD-MMM-YYYY      *
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
* REVISION NO: ED1K909344
* REFERENCE NO: CHG0040278 / RITM0078000
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE: 01/18/2019
* DESCRIPTION: Split based on variant name functionality changes only
*              for Main Label
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K926022
* REFERENCE NO: OTCM – 47675 , JFDS , I0255
* DEVELOPER: Bharat Saki (BSAKI)
* DATE: 03/09/2022
* DESCRIPTION: Changes for address1 and 2 fields of the data on interface
*              level
*----------------------------------------------------------------------*
*

* Global database tables
*TABLES : ekko, ekpo, lfa1, likp, mara, marc, vbkd.

* Global type declaration
TYPES : BEGIN OF ty_cmn_flds,
          jobid        TYPE numc4,           "Job ID
          zprodtype    TYPE char04,          "Product type
          vbeln        TYPE ihrez,           "vbeln_va,  "Sudscription Ref " + <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          auart1       TYPE vbeln_va,        "Free Issue Ref
          auart2       TYPE vbeln_va,        "Claim Ref
          auart3       TYPE vbeln_va,        "Sample Copy Ref
          stcd1        TYPE stcd1,           "Canadian GST Number
          zcontyp      TYPE char01,          "Consolidation Type
          type         TYPE char02,          "Type
          priority     TYPE numc2,           "Priority
          bstkd        TYPE bstkd,           "PO Reference
          docdate      TYPE datum,           "Sent Date
          cust         TYPE kunnr,           "End Use Customer
          ship_to_cust TYPE kunnr,           "Ship to Customer
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          name1        TYPE name1_gp,        "Address Line1
          name1        TYPE char50,          "Address Line1 - To pass title along with NAME1
*          name2        TYPE name2_gp,        "Address Line2
          name2        TYPE char50,          "Address Line2
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*          stras        TYPE stras_gp,        "Address Line3
          stras        TYPE string,          "Address Line3
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          ort02        TYPE ort02_gp,        "Address Line4
          ort02        TYPE char50,          "Address Line4
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
          ort01        TYPE ort01_gp,        "Address Line5
          regio        TYPE char20, " regio, " State (by GKINTALI - 05/18/2018 - ED1K907377)
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*          landx        TYPE landx,           "Country Name
          landx50      TYPE landx50,         " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
          pstlz        TYPE pstlz,           "Post Code
          land1        TYPE intca3,           " ISO country code
          telf1        TYPE telf1,           "Telephone Number
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
          tel_number   TYPE ad_tlnmbr1,      "Full Telephone Number
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
          shipping_ref TYPE char255,  "tdline,          "Shipping Reference
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
          issue_desc   TYPE char40,          "Issue Description
          ismrefmdprod TYPE ismrefmdprod,    "Acronym    "Defect#2003
          identcode    TYPE ismidentcode,     "Acroynm    "Defect#2003
          ismcopynr    TYPE ismheftnummer,   "Volume
          ismnrinyear  TYPE char7,            "Issue
          part         TYPE char10,           "PART
          supplement   TYPE char7,            "Suppl
          ismtitle     TYPE ismtitle,        "Journal Title
          ismyearnr    TYPE ismjahrgang,     "Pub Set
          society_name TYPE char40,          "Offline Socielty Name
          menge        TYPE p,               "Quantity
          lfimg        TYPE p,               "Quantity
          lifnr        TYPE lifnr,           "Vendor
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
          vkorg        TYPE vkorg, " Sales Organization
*          kdkg2        TYPE kdkg2, " Customer condition group 2
          pltyp        TYPE pltyp, " Price List Type
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
          mdprod       TYPE ismrefmdprod, "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
        END OF ty_cmn_flds.
TYPES: BEGIN OF ty_ml_cmn_flds,              "Structure for Label
*          matnr        TYPE matnr,           "Unique Issue Identifier
*          varname      TYPE zzvarname,       "Variant Name "+ <HIPATEL> <INC0200998> <ED1K907981>
         jobid        TYPE numc4,           "Job ID
         zprodtype    TYPE char04,          "Product type
         vbeln        TYPE ihrez,           "vbeln_va,  "Sudscription Ref "+ <HIPATEL> <INC0200998> <ED1K907523>
         auart1       TYPE vbeln_va,        "Free Issue Ref
         auart2       TYPE vbeln_va,        "Claim Ref
         auart3       TYPE vbeln_va,        "Sample Copy Ref
         stcd1        TYPE stcd1,           "Canadian GST Number
         zcontyp      TYPE char01,          "Consolidation Type
         type         TYPE char02,          "Type
         priority     TYPE numc2,           "Priority
         bstkd        TYPE bstkd,           "PO Reference
         docdate      TYPE datum,           "Sent Date
         cust         TYPE kunnr,           "End Use Customer
         ship_to_cust TYPE kunnr,           "Ship to Customer
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          name1        TYPE name1_gp,        "Address Line1
*          name1        TYPE char50,          "Address Line1 - To pass title along with NAME1
         name1        TYPE string,          "++by BSAKI:03/09/2022 - Address Line1 - c/o name + sanutation + name1 ED2K926022
*          name2        TYPE name2_gp,        "Address Line2
*          name2        TYPE char50,          "Address Line2
         name2        TYPE string,          "++by BSAKI:03/09/2022 - Address Line2 - Name2 + street2 ED2K926022
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*          stras        TYPE stras_gp,        "Address Line3
         stras        TYPE string,          "Address Line3
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          ort02        TYPE ort02_gp,        "Address Line4
         ort02        TYPE char50,          "Address Line4
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
         ort01        TYPE ort01_gp,        "Address Line5
         regio        TYPE char20, " regio  " State (by GKINTALI - 05/18/2018 - ED1K907377)
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*          landx        TYPE landx,           "Country Name
         landx50      TYPE landx50,         " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
         pstlz        TYPE pstlz,           "Post Code
* Begin of Change CR#471
*          land1        TYPE land1_gp,        "Country Code
         land1        TYPE intca3,           " ISO country code
* End of Change CR#471
         telf1        TYPE telf1,           "Telephone Number
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
         tel_number   TYPE ad_tlnmbr1,      "Full Telephone Number
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
         shipping_ref TYPE char255,  "tdline,          "Shipping Reference
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
         issue_desc   TYPE char40,          "Issue Description
         ismrefmdprod TYPE ismrefmdprod,    "Acronym    "Defect#2003
         identcode    TYPE ismidentcode,     "Acroynm    "Defect#2003
         ismcopynr    TYPE ismheftnummer,   "Volume
* Begin of Change CR 471
*          ismnrinyear  TYPE ismnrimjahr,     "Issue
*          part         TYPE ismausgvartyppl, "PART
*          supplement   TYPE ismausgvartyppl, "Supplement
         ismnrinyear  TYPE char7,            "Issue
         part         TYPE char10,           "PART
         supplement   TYPE char7,            "Suppl
* End of Change CR 471
         ismtitle     TYPE ismtitle,        "Journal Title
         ismyearnr    TYPE ismjahrgang,     "Pub Set
         society_name TYPE char40,          "Offline Socielty Name
*          menge        TYPE menge_d,        "Quantity
*          lfimg        TYPE lfimg,          "Quantity
         menge        TYPE p,               "Quantity
         lfimg        TYPE p,               "Quantity
         lifnr        TYPE lifnr,           "Vendor
         vstel        TYPE vstel,           "Shipping Point
         vgbel        TYPE vgbel,           " Document number of the reference document
*          Added by MODUTTA for CR# 371 & 435
*          mdprod       TYPE ismrefmdprod,    "- - <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
         augru        TYPE augru, "Reason Code
         auart        TYPE auart, "Document type
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
         vkorg        TYPE vkorg, " Sales Organization
         kdkg2        TYPE kdkg2, " Customer condition group 2
         pltyp        TYPE pltyp, " Price List Type
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
         society      TYPE zzsociety_acrnym,  "Society Acronym
         country      TYPE land1,
         konda        TYPE konda, "Customer Price Group
         email        TYPE ad_smtpadr,
*          varname      TYPE zzvarname,  "- <HIPATEL> <INC0200998> <ED1K907981>
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         subscrno     TYPE vbeln_va,        "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       END OF ty_ml_cmn_flds,
* <<<<<<<<<<<<<BOC by MODUTTA on 23/05/2016 for CR# 371 & 435>>>>>>>>>>>>>>>>>>>>>>>>>>>
       BEGIN OF ty_output,               "Structure for Output
         jobid        TYPE numc4,           "Job ID
         zprodtype    TYPE char04,          "Product type
         cust         TYPE kunnr,           "End Use Customer
         vbeln        TYPE ihrez,           "vbeln_va,    "Sudscription Ref "+ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         auart1       TYPE vbeln_va,        "Free Issue Ref
         auart2       TYPE vbeln_va,        "Claim Ref
         auart3       TYPE vbeln_va,        "Sample Copy Ref
         bstkd        TYPE bstkd,           "PO Reference
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
         shipping_ref TYPE char255,  "tdline,          "Shipping Reference
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
         stcd1        TYPE stcd1,           "Canadian GST Number
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*          menge        TYPE char17,          "Quantity
         menge        TYPE p,           "Quantity
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         issue_desc   TYPE char40,          "Issue Description
         identcode    TYPE ismidentcode,    "Acronym
         ismcopynr    TYPE ismheftnummer,   "Volume
         ismnrinyear  TYPE char7,            "Issue
         part         TYPE char10,           "PART
         supplement   TYPE char7,            "Suppl
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          name1        TYPE name1_gp,        "Address Line1
*          name1        TYPE char50,          "Address Line1 - To pass title along with NAME1
         name1        TYPE string,          "++by BSAKI:03/09/2022 - Address Line1 - c/o name + sanutation + name1 ED2K926022
*          name2        TYPE name2_gp,        "Address Line2
*          name2        TYPE char50,         "Address Line2
         name2        TYPE string,          "++by BSAKI:03/09/2022 - Address Line2 - Name2 + street2 ED2K926022
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*          stras        TYPE stras_gp,        "Address Line3
         stras        TYPE string,          "Address Line3
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          ort02        TYPE ort02_gp,        "Address Line4
         ort02        TYPE char50,          "Address Line4
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
         ort01        TYPE ort01_gp,        "Address Line5
         regio        TYPE char20, " regio, " State (by GKINTALI - 05/18/2018 - ED1K907377)
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*          landx        TYPE landx,           "Country Name
         landx50      TYPE landx50,         " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
         pstlz        TYPE pstlz,           "Post Code
         land1        TYPE intca3,           " ISO country code
         ship_to_cust TYPE kunnr,           "Ship to Customer
         zcontyp      TYPE char01,          "Consolidation Type
         matnr        TYPE matnr,          "Material Number
         type         TYPE char02,          "Type
         priority     TYPE numc2,           "Priority
* BOC - GKINTALI - ERP-7404 - ED2K912007 - 03.05.2018
*          date         TYPE char10,           "Date
         date         TYPE char11,           "Date
* EOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
         society_name TYPE char40,          "Offline Socielty Name
         telf1        TYPE telf1,           "Telephone Number
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
         tel_number   TYPE ad_tlnmbr1,      "Full Telephone Number
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
         ismtitle     TYPE ismtitle,        "Journal Title
         ismyearnr    TYPE ismjahrgang,     "Pub Set
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
         price_list   TYPE pltyp,           "Price List Type
         filename     TYPE zzflname,        "File Name (Variant Name)
         sales_org    TYPE vkorg,           " Sales Organization ++ GKINTALI
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         subscrno     TYPE vbeln_va,        "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       END OF ty_output,
* <<<<<<<<<<<<<EOC by MODUTTA on 23/05/2016 for CR# 371 & 435>>>>>>>>>>>>>>>>>>>>>>>>>>>

* <<<<<<<<<<<<<BOC by MODUTTA on 02/06/2016 for CR# 371 & 435>>>>>>>>>>>>>>>>>>>>>>>>>>>
       BEGIN OF ty_constant,
         devid  TYPE zdevid,              " Development ID
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno   TYPE tvarv_numb,          " ABAP: Current selection number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_constant,
* <<<<<<<<<<<<<EOC by MODUTTA on 02/06/2016 for CR# 371 & 435>>>>>>>>>>>>>>>>>>>>>>>>>>>

*       Type declaration for back label
       BEGIN OF ty_back_label,              "Structure for Label
         vstel        TYPE vstel,           "Shipping Point
         jobid        TYPE numc4,           "Job ID
         zprodtype    TYPE char04,          "Product type
         vbeln        TYPE ihrez,           "vbeln_va,  "Sudscription Ref "+ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         auart1       TYPE vbeln_va,        "Free Issue Ref
         auart2       TYPE vbeln_va,        "Claim Ref
         auart3       TYPE vbeln_va,        "Sample Copy Ref
         stcd1        TYPE stcd1,           "Canadian GST Number
         zcontyp      TYPE char01,          "Consolidation Type
         type         TYPE char02,          "Type
         priority     TYPE numc2,           "Priority
         bstkd        TYPE bstkd,           "PO Reference
         docdate      TYPE datum,           "Sent Date
         cust         TYPE kunnr,           "End Use Customer
         ship_to_cust TYPE kunnr,           "Ship to Customer
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          name1        TYPE name1_gp,        "Address Line1
*          name1        TYPE char50,          "Address Line1 - To pass the title along with NAME1
         name1        TYPE string,          "++by BSAKI:03/09/2022 - Address Line1 - c/o name + sanutation + name1 ED2K926022
*          name2        TYPE name2_gp,        "Address Line2
*          name2        TYPE char50,          "Address Line2
         name2        TYPE string,          "++by BSAKI:03/09/2022 - Address Line2 - Name2 + street2 ED2K926022
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*          stras        TYPE stras_gp,        "Address Line3
         stras        TYPE string,          "Address Line3
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
*          ort02        TYPE ort02_gp,        "Address Line4
         ort02        TYPE char50,         "Address Line4
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
         ort01        TYPE ort01_gp,        "Address Line5
         regio        TYPE char20, " regio, "State (by GKINTALI - 05/18/2018 - ED1K907377)
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*          landx        TYPE landx,           "Country Name
         landx50      TYPE landx50,         " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
         pstlz        TYPE pstlz,           "Post Code
* Begin of Change CR#471
*          land1        TYPE land1_gp,        "Country Code
         land1        TYPE intca3,           " ISO country code
* End of Change CR#471
         telf1        TYPE telf1,           "Telephone Number
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
         tel_number   TYPE ad_tlnmbr1,      "Full Telephone Number
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
         shipping_ref TYPE char255,  "tdline,          "Shipping Reference
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*          matnr        TYPE matnr,           "Unique Issue Identifier "Comment CR 371
         issue_desc   TYPE char40,          "Issue Description
         ismrefmdprod TYPE ismrefmdprod,    "Media Produc  "Defect#2003
         identcode    TYPE ismidentcode,    "Acroynm    "Defect#2003
         ismcopynr    TYPE ismheftnummer,   "Volume
* Begin of Change CR 471
*          ismnrinyear  TYPE ismnrimjahr,     "Issue
*          part         TYPE ismausgvartyppl, "PART
*          supplement   TYPE ismausgvartyppl, "Supplement
         ismnrinyear  TYPE char7,            "Issue
         part         TYPE char10,           "PART
         supplement   TYPE char7,            "Suppl
* End of Change CR 471
         ismtitle     TYPE ismtitle,        "Journal Title
         ismyearnr    TYPE ismjahrgang,     "Pub Set
         society_name TYPE char40,          "Offline Socielty Name
*          menge        TYPE menge_d,         "Quantity
*          lfimg        TYPE lfimg,           "Quantity
         menge        TYPE p,                "Quantity
         lfimg        TYPE p,                "Quantity
         lifnr        TYPE lifnr,           "Vendor
         vgbel        TYPE vgbel,           " Document number of the reference document
         matnr        TYPE matnr,           "Unique Issue Identifier
*          Added by MODUTTA for CR# 371 & 435
         mdprod       TYPE ismrefmdprod,
         augru        TYPE augru, "Reason Code
         auart        TYPE auart, "Document Type
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
         vkorg        TYPE vkorg, " Sales Organization
         kdkg2        TYPE kdkg2, " Customer condition group 2
         pltyp        TYPE pltyp, " Price List Type
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
         society      TYPE zzsociety_acrnym,  "Society Acronym
         konda        TYPE konda, "Customer Price Group
         country      TYPE land1,
         email        TYPE ad_smtpadr,
         varname      TYPE zzvarname,
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         subscrno     TYPE vbeln_va,        "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       END OF ty_back_label,

*       Type declaration for country
       BEGIN OF ty_country,
         land1 TYPE land1, " Country Key
       END OF ty_country,
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
*       Type declaration for region codes
       BEGIN OF ty_region,
         land1 TYPE land1,   " Country Key
         bland TYPE regio,   " Region (State, Province, County)
       END OF ty_region,
       BEGIN OF ty_t005u,
         land1 TYPE land1,   " Country Key
         bland TYPE regio,   " Region (State, Province, County)
         bezei TYPE bezei20, " State - Description
       END OF ty_t005u,
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
       BEGIN OF ty_adrnr,
         kunnr TYPE kunnr,
         lifnr TYPE lifnr,
         adrnr TYPE adrnr,
       END OF ty_adrnr,
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571

*       Range type declaration for Partner
       BEGIN OF ty_parvw,
         sign   TYPE sign,   " Debit/Credit Sign (+/-)
         option TYPE option, " Option for ranges tables
         low    TYPE parvw,  " Partner Function
         high   TYPE parvw,  " Partner Function
       END OF ty_parvw,

*       Type declaration final delivery
       BEGIN OF ty_delv_final,
         vbeln TYPE vbeln_vl, " Delivery
         posnr TYPE posnr,    " Item number of the SD document
         matnr TYPE matnr,    " Material Number
         lfimg TYPE lfimg,    " Actual quantity delivered (in sales units)
         vgbel TYPE vgbel,    " Document number of the reference document
         vgpos TYPE vgpos,    " Item number
         erdat TYPE erdat,    " Date on Which Record Was Created
         vstel TYPE vstel,    " Shipping Point/Receiving Point
         lfart TYPE lfart,    " Delivery Type
         inco1 TYPE inco1,    " Incoterms (Part 1)
       END OF ty_delv_final,
* Begin of change Defect 2003
       BEGIN OF ty_ismidcodetype,
         sign   TYPE char1,               " Sign of type CHAR1
         option TYPE char2,               " Option of type CHAR2
         low    TYPE ismidcodetype,       " Type of Identification Code
         high   TYPE ismidcodetype,       " Type of Identification Code
       END OF ty_ismidcodetype,

* End of change Defect 2003
* BOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
       BEGIN OF ty_deliveryitemcatag,
         sign   TYPE char1,               " Sign of type CHAR1
         option TYPE char2,               " Option of type CHAR2
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_deliveryitemcatag,
* EOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
       BEGIN OF ty_mdprd,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE ismrefmdprod,
         high   TYPE ismrefmdprod,
       END OF ty_mdprd,

       BEGIN OF ty_jrnl,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE zzjrnl_grp_code,
         high   TYPE zzjrnl_grp_code,
       END OF ty_jrnl,

       BEGIN OF ty_ship_to,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE land1,
         high   TYPE land1,
       END OF ty_ship_to,

       BEGIN OF ty_konda,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE konda,
         high   TYPE konda,
       END OF ty_konda,

       BEGIN OF ty_augru,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE augru,
         high   TYPE augru,
       END OF ty_augru,

       BEGIN OF ty_auart,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE auart,
         high   TYPE auart,
       END OF ty_auart,

       BEGIN OF ty_media,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE matnr,
         high   TYPE matnr,
       END OF ty_media,

       BEGIN OF ty_society,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE zzsociety_acrnym,
         high   TYPE zzsociety_acrnym,
       END OF ty_society,

*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       BEGIN OF ty_wbstk,  "Total goods movement status
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE wbstk,
         high   TYPE wbstk,
       END OF ty_wbstk,
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
       BEGIN OF ty_salesorg,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE vkorg,
         high   TYPE vkorg,
       END OF ty_salesorg,

       BEGIN OF ty_condgrp2,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE kdkg2,
         high   TYPE kdkg2,
       END OF ty_condgrp2,

       BEGIN OF ty_i0255_lblsm,
         mandt         TYPE sy-mandt,
         srno          TYPE zzsrno,
         filename      TYPE zzflname,
         zdate         TYPE datum,
         labltp        TYPE zzlbltyp,
         zlifnr        TYPE zzlifnr,
         media_product TYPE ismrefmdprod,
         media_issue   TYPE matnr,
         sales_org     TYPE vkorg,
         zrecord       TYPE zzrecord,
         zcopies       TYPE zzcopies,
         zfrcopies     TYPE zzfrcopies,
         zpdcopies     TYPE zzpdcopies,
         price_list    TYPE pltyp,
         zquantity     TYPE zzquantity,
         zuserid       TYPE uname,      "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
       END OF ty_i0255_lblsm,

       BEGIN OF ty_lblsm_tmp,
         zlifnr        TYPE zzlifnr,
         media_product TYPE ismrefmdprod,
         media_issue   TYPE matnr,
         sales_org     TYPE vkorg,
         price_list    TYPE pltyp,
         zrecord       TYPE i, " zzrecord,
         zcopies       TYPE i, " zzcopies,
         zfrcopies     TYPE i, " zzfrcopies,
         zpdcopies     TYPE i, "zzpdcopies,
         zquantity     TYPE zzquantity,
       END OF ty_lblsm_tmp,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
       BEGIN OF ty_err_log,
         msg TYPE string,
       END OF ty_err_log,
       BEGIN OF ty_i0255_split,
         labltp            TYPE zzlbltyp,
         varname           TYPE zzvarname,
         zseqno            TYPE fin_seqno,
         media_product     TYPE ismrefmdprod,
         media_issue       TYPE matnr,
         price_grp         TYPE konda,
         ship_to_code      TYPE land1,
         society_grp_code  TYPE zzsociety_acrnym,
         reason_code       TYPE augru,
         subscription_cls  TYPE auart,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
         sales_org         TYPE vkorg,
         condition_grp2    TYPE kdkg2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
         cntrl_circulation TYPE xfeld,
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
         varsplit          TYPE zzvarsplit,    "Variant based Split checkbox
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
         email             TYPE ad_smtpadr,
       END OF ty_i0255_split.
TYPES: BEGIN OF  ty_mlabel_var.
TYPES:  matnr    TYPE matnr,            "Unique Issue Identifier
        varname  TYPE zzvarname.        " Variant name
        INCLUDE TYPE ty_cmn_flds.

        TYPES: vstel    TYPE vstel,           "Shipping Point
        vgbel    TYPE vgbel,           " Document number of the reference document
        mdprd    TYPE ismrefmdprod,
        augru    TYPE augru, "Reason Code
        auart    TYPE auart, "Document type
        society  TYPE zzsociety_acrnym,  "Society Acronym
        konda    TYPE konda, "Customer Price Group
        country  TYPE land1,
        email    TYPE ad_smtpadr,
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        subscrno TYPE vbeln_va.        "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
TYPES: cntrl_var TYPE c.               "Cneteral Cir.+varsplit = 'X'. "+<HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
TYPES END OF ty_mlabel_var.

*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
TYPES: BEGIN OF  ty_mlabel_mat.
TYPES:  varname  TYPE zzvarname,        " Variant name
        matnr    TYPE matnr.            "Unique Issue Identifier
        INCLUDE TYPE ty_cmn_flds.

        TYPES: vstel    TYPE vstel,           "Shipping Point
        vgbel    TYPE vgbel,           " Document number of the reference document
        mdprd    TYPE ismrefmdprod,
        augru    TYPE augru, "Reason Code
        auart    TYPE auart, "Document type
        society  TYPE zzsociety_acrnym,  "Society Acronym
        konda    TYPE konda, "Customer Price Group
        country  TYPE land1,
        email    TYPE ad_smtpadr,
        subscrno TYPE vbeln_va.        "Subscription Number
TYPES: cntrl_var TYPE c.               "Cneteral Cir.+varsplit = 'X'. "+<HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
TYPES END OF ty_mlabel_mat.

*Types for Unconditional File
TYPES: BEGIN OF ty_label.
TYPES:  matnr     TYPE matnr,           "Unique Issue Identifier
        varname   TYPE zzvarname,       "Variant Name "+ <HIPATEL> <INC0200998> <ED1K907981>
        mdprod    TYPE ismrefmdprod.    "Media Product "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
        INCLUDE TYPE ty_ml_cmn_flds.
        TYPES:  cntrl_var TYPE c.               "Cneteral Cir.+varsplit = 'X'. "+<HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
TYPES END OF ty_label.

TYPES: BEGIN OF ty_label_var.
TYPES:  varname   TYPE zzvarname,       "Variant Name "+ <HIPATEL> <INC0200998> <ED1K907981>
        matnr     TYPE matnr,           "Unique Issue Identifier
        mdprod    TYPE ismrefmdprod.    "Media Product  "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
        INCLUDE TYPE ty_ml_cmn_flds.
        TYPES:  cntrl_var TYPE c.               "Cneteral Cir.+varsplit = 'X'. "+<HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
TYPES END OF ty_label_var.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*New Type for Variant Split new condition
TYPES: BEGIN OF ty_split_var.
TYPES:  mdprod    TYPE ismrefmdprod,    "Media Product
        varname   TYPE zzvarname,       "Variant Name
        matnr     TYPE matnr.           "Unique Issue Identifier
        INCLUDE TYPE ty_ml_cmn_flds.
        TYPES:  cntrl_var TYPE c.               "Cneteral Cir.
TYPES END OF ty_split_var.

TYPES: BEGIN OF ty_ml_mdprod,
         media_product     TYPE ismrefmdprod,
         cntrl_circulation TYPE xfeld,
         varsplit          TYPE zzvarsplit,    "Variant based Split checkbox
       END OF ty_ml_mdprod.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

TYPES: BEGIN OF  ty_blabel_var.
TYPES: vstel    TYPE vstel,           "Shipping Point
       varname  TYPE zzvarname,
       matnr    TYPE matnr.           "Unique Issue Identifier
       INCLUDE TYPE ty_cmn_flds.

       TYPES: vgbel    TYPE vgbel,           " Document number of the reference document
       mdprd    TYPE ismrefmdprod,
       augru    TYPE augru, "Reason Code
       auart    TYPE auart, "Document type
       society  TYPE zzsociety_acrnym,  "Society Acronym
       konda    TYPE konda, "Customer Price Group
       country  TYPE land1,
       email    TYPE ad_smtpadr,
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       subscrno TYPE vbeln_va.        "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
TYPES END OF ty_blabel_var.
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018
TYPES: BEGIN OF ty_lines,  " Structure for Line of 256 characters
         line(256) TYPE c,
       END OF ty_lines.
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 03/14/2018

* BOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
TYPES: BEGIN OF ty_email_str,
         email_body TYPE string,
       END OF ty_email_str,
       tt_email_str TYPE STANDARD TABLE OF ty_email_str INITIAL SIZE 0.
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

* Global table type Declaration
TYPES : tt_back_label  TYPE STANDARD TABLE OF ty_back_label INITIAL SIZE 0,
        tt_delv_final  TYPE STANDARD TABLE OF ty_delv_final INITIAL SIZE 0,
        tt_main_label  TYPE STANDARD TABLE OF ty_label INITIAL SIZE 0,
        tt_idcode_type TYPE STANDARD TABLE OF ty_ismidcodetype INITIAL SIZE 0, "Defect 2003
        tt_jrnl        TYPE STANDARD TABLE OF ty_jrnl INITIAL SIZE 0,
        tt_augru       TYPE STANDARD TABLE OF ty_augru INITIAL SIZE 0,
        tt_auart       TYPE STANDARD TABLE OF ty_auart INITIAL SIZE 0,
        tt_konda       TYPE STANDARD TABLE OF ty_konda INITIAL SIZE 0,
        tt_media       TYPE STANDARD TABLE OF ty_media INITIAL SIZE 0,
        tt_mdprd       TYPE STANDARD TABLE OF ty_mdprd INITIAL SIZE 0,
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        tt_wbstk       TYPE STANDARD TABLE OF ty_wbstk INITIAL SIZE 0,
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
        tt_salesorg    TYPE STANDARD TABLE OF ty_salesorg INITIAL SIZE 0,
        tt_condgrp2    TYPE STANDARD TABLE OF ty_condgrp2 INITIAL SIZE 0,
        tt_lblsm_tmp   TYPE STANDARD TABLE OF ty_lblsm_tmp INITIAL SIZE 0,
        tt_i0255_lblsm TYPE STANDARD TABLE OF ty_i0255_lblsm INITIAL SIZE 0,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
        tt_society     TYPE STANDARD TABLE OF ty_society INITIAL SIZE 0,
        tt_ship_to     TYPE STANDARD TABLE OF ty_ship_to INITIAL SIZE 0,
*        tt_split       TYPE STANDARD TABLE OF zqtc_i0255_split INITIAL SIZE 0.
        tt_mlabel_var  TYPE STANDARD TABLE OF ty_mlabel_var INITIAL SIZE 0,
        tt_blabel_var  TYPE STANDARD TABLE OF ty_blabel_var INITIAL SIZE 0,
        tt_split       TYPE STANDARD TABLE OF ty_i0255_split INITIAL SIZE 0,
        tt_constant    TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.
*<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
TYPES:  tt_lines       TYPE STANDARD TABLE OF ty_lines    INITIAL SIZE 0.   " ++ by GKINTALI:ERP-6967:ED2K910947

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
TYPES: tt_split_var TYPE STANDARD TABLE OF ty_split_var INITIAL SIZE 0,
       tt_ml_mdprod TYPE STANDARD TABLE OF ty_ml_mdprod INITIAL SIZE 0.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

*<<<<<<<<<<BOC by MODUTTA on 05/30/2017 for CR#371 & 435>>>>>>>>>>>>>
DATA: i_output       TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
      i_i0255_lblsm  TYPE STANDARD TABLE OF ty_i0255_lblsm INITIAL SIZE 0,
      i_lblsm_tmp    TYPE STANDARD TABLE OF ty_lblsm_tmp INITIAL SIZE 0,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
      i_constant     TYPE tt_constant,
      i_fieldcatalog TYPE slis_t_fieldcat_alv. "fieldcatalog table
*<<<<<<<<<<EOC by MODUTTA on 05/30/2017 for CR#371 & 435>>>>>>>>>>>>>

* Global variable declaration
DATA : v_ship              TYPE likp-vstel,        " Shipping Point/Receiving Point
       v_matnr             TYPE mara-matnr,        " Material Number
       v_plant             TYPE ekpo-werks,        " Plant
       v_type              TYPE mara-mtart,        " Material Type
       v_doc1              TYPE likp-lfart,        " Delivery Type
       v_doc2              TYPE ekko-bsart,        " Purchasing Document Type
       v_item              TYPE ekpo-pstyp,        " Item Category in Purchasing Document
       v_acct              TYPE ekpo-knttp,        " Account Assignment Category
       v_vend              TYPE lfa1-lifnr,        " Account Number of Vendor or Creditor
       v_date              TYPE likp-erdat,        " Date on Which Record Was Created
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
       i_adrnr             TYPE TABLE OF ty_adrnr,
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
       li_parvw            TYPE TABLE OF ty_parvw, " Range table for partners
       li_err_log          TYPE TABLE OF ty_err_log,
       li_country          TYPE TABLE OF ty_country,
       li_region           TYPE TABLE OF ty_region,
       li_t005u            TYPE TABLE OF ty_t005u,
*BOC by MODUTTA on 05/30/2017 for CR#371 & 435
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*Shipping Instruction should be 255 char
       v_ship_instruction  TYPE char255, "tdline,
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*Shipping Instruction should be 255 char
       v_ship_instruction1 TYPE char255, "tdline,
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
       v_row_cnt           TYPE i,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*Delivery Instruction should be 255 char
       v_delv_instruction  TYPE char255, "tdline,
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*EOC by MODUTTA on 05/30/2017 for CR#371 & 435
       v_fpath_df          TYPE string,
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
       v_field             TYPE string.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
FIELD-SYMBOLS: <fs_comp>  TYPE any.

*Data for Conditional
DATA i_dyn_table1  TYPE REF TO data.
CREATE DATA i_dyn_table1 TYPE TABLE OF ty_mlabel_var.

DATA i_dyn_table2  TYPE REF TO data.
CREATE DATA i_dyn_table2 TYPE TABLE OF ty_mlabel_mat.

FIELD-SYMBOLS <i_dyn_table_split>  TYPE ANY TABLE.
*FIELD-SYMBOLS <lst_table>  TYPE ANY.

*Data for Un-conditional
DATA i_dyn_table3  TYPE REF TO data.
CREATE DATA i_dyn_table3 TYPE TABLE OF ty_label.

DATA i_dyn_table4  TYPE REF TO data.
CREATE DATA i_dyn_table4 TYPE TABLE OF ty_label_var.

FIELD-SYMBOLS <i_dyn_table>  TYPE ANY TABLE.
FIELD-SYMBOLS <lst_main_label>  TYPE ty_label.
DATA: lst_main_lable TYPE ty_label.

*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*Data for Un-conditional
DATA i_dyn_table5  TYPE REF TO data.
CREATE DATA i_dyn_table5 TYPE TABLE OF ty_split_var.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

* Global constant declaration
CONSTANTS:
  c_sign_incld  TYPE ddsign      VALUE 'I',     "Sign: (I)nclude
  c_opti_equal  TYPE ddoption    VALUE 'EQ',    "Option: (EQ)ual
  c_opti_betwn  TYPE ddoption    VALUE 'BT',    "Option: (B)e(T)ween
  c_shkzg_s     TYPE shkzg       VALUE 'S',     " Debit/Credit Indicator
  c_shkzg_h     TYPE shkzg       VALUE 'H',     " Debit/Credit Indicator
  c_devid       TYPE zdevid      VALUE 'I0255', "Development ID
  c_error       TYPE char1       VALUE 'E',     "Error message
  c_success     TYPE char1       VALUE 'S',     "Success message
  c_info        TYPE char1       VALUE 'I',     "Information message
  c_comma       TYPE char1       VALUE ',',     "Comma separator
  c_quote       TYPE char1       VALUE '"',     "qoute separator
  c_dot         TYPE char1       VALUE '.',     "Dot Seperator
  c_slash       TYPE char1       VALUE '/',              "Slash Seperator
  c_hypen       TYPE char1       VALUE '-',              " Hypen separator
  c_bewtp_e     TYPE bewtp       VALUE 'E',              " Goods receipt
  c_char_s      TYPE char1       VALUE 'S',              " Character S for supplement
  c_bwart_101   TYPE bwart       VALUE '101',            " Positive movement type
  c_bwart_102   TYPE bwart       VALUE '102',            " Negative movement type
  c_bwart_z01   TYPE bwart       VALUE 'Z01',            " Positive movement type
  c_bwart_z02   TYPE bwart       VALUE 'Z02',            " Negative movement type
  c_file_undsc  TYPE char1       VALUE '_',              " File_undsc of type CHAR1
  c_cntry_ca    TYPE land1       VALUE 'CA',             " Canadian country
  c_fldr_in     TYPE char2       VALUE 'in',             " Fldr_in of type CHAR2
  c_char_blank  TYPE char1       VALUE '',               " Blank Character.
  c_quotation   TYPE char2       VALUE '"',              "Double quotation
  c_blank_zeros TYPE posnr       VALUE '000000',         "Item Number "CR#317
* BOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
  c_ucomm_flag  TYPE syucomm     VALUE 'FLAG', " Function Code
* EOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
  c_csv         TYPE char3       VALUE 'csv',            "File type
  c_txt         TYPE char3       VALUE 'TXT',            "File type
  c_tdid_del    TYPE tdid        VALUE '0008',           "TDID for delivery instruction
*****Added by MODUTTA on 05/02/2017 for CR# 371 & 435
  c_tdid_ship   TYPE tdid        VALUE '0020',           "TDID for shipping instruction
  c_file_path   TYPE rvari_vnam  VALUE 'FILE_PATH',
  c_ship_inst   TYPE rvari_vnam  VALUE 'SHIPPING_INSTR',
  c_txt1        TYPE char4       VALUE '.TXT',
  c_txt2        TYPE char4       VALUE '.txt',
****************
  c_object      TYPE tdobject    VALUE 'VBBK',           "TDOBJECT
  c_supp_value  TYPE char4       VALUE 'SUPP',           "Supplement value
  c_iss_value   TYPE char4       VALUE 'ISS',            "Issue value
  c_type_ml     TYPE char2       VALUE 'ML',             "Type : Main label
  c_type_bl     TYPE char2       VALUE 'BL',             "Type : Back label
  c_free_issue  TYPE auart       VALUE 'ZCOP',           "Sales doc type value
  c_claim_ref   TYPE auart       VALUE 'ZCLM',           "Sales doc type value
  c_copy_ref    TYPE auart       VALUE 'ZTRL',           "Sales doc type value
  c_parvw_ag    TYPE parvw       VALUE 'AG',             "Sold to Party
  c_parvw_we    TYPE parvw       VALUE 'WE',             "Ship to Party
  c_parvw_sp    TYPE parvw       VALUE 'SP',             "Freight forwarder - Vendor
  c_shpcon_01   TYPE vsbed       VALUE '01',             " Air label
  c_shpcon_02   TYPE vsbed       VALUE '02',             " Courier
  c_shpcon_03   TYPE vsbed       VALUE '03',             " Delivery Duty Paid
  c_del_ind_s   TYPE eloek       VALUE 'S',              "Deletion Indicator
  c_del_ind_l   TYPE eloek       VALUE 'L',              "Deletion Indicator
  c_contyp_d    TYPE char1       VALUE 'D',              "Consolidation Type
  c_contyp_f    TYPE char1       VALUE 'F',              "Consolidation Type
  c_vbtyp_g     TYPE vbtyp       VALUE 'G',              "SD doc category
  c_vbtyp_c     TYPE vbtyp       VALUE 'C',              "SD doc category
  c_vbtyp_i     TYPE vbtyp       VALUE 'I',              "SD doc category

  c_param1_file TYPE rvari_vnam  VALUE 'APPL.FILE PATH', "File path variable name
* Begin of change Defect 2003
  c_idcode_type TYPE rvari_vnam  VALUE 'IDCODE_TYPE',    "Type of Identification code
* End of change Defect 2003
* BOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
  c_doc_type    TYPE rvari_vnam  VALUE 'PROOF_OF_AD',
  c_file_type   TYPE rvari_vnam  VALUE 'BL',
* EOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019

  c_zero        TYPE char1       VALUE '0',
*<<<<<<<<<<BOC by MODUTTA on 05/02/2017 for CR# 371 & 435>>>>>>>>>>>>>>>
  c_field       TYPE dynfnam VALUE 'P_FILE', " Field name: for Local file
  c_sign        TYPE ddsign VALUE 'I',
  c_option_eq   TYPE ddoption VALUE 'EQ',
  c_option_cp   TYPE ddoption VALUE 'CP',
  c_field_dwn   TYPE dynfnam VALUE 'P_DWNLD', " Field name: for Local file
  c_star        TYPE char1 VALUE '*',
  c_onli        TYPE syucomm VALUE 'ONLI', " Function Code
*<<<<<<<<<<EOC by MODUTTA on 05/02/2017 for CR# 371 & 435>>>>>>>>>>>>>>>
* BOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
  c_splt_len    TYPE i     VALUE '50',   " Constant for split length
  c_semicol     TYPE char1 VALUE ';',    " Semi-Colon Separator
* EOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
  c_zsro        TYPE auart VALUE 'ZSRO',
  c_file_str    TYPE char4 VALUE 'FILE',
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
  c_bu_per      TYPE bu_type VALUE '1',                   " Person   " ED1K907411 GVS05212018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
  c_matnr       TYPE char05 VALUE 'MATNR',                      "Material Number
  c_varnm       TYPE char07 VALUE 'VARNAME',                    "Variant Name
  c_uncond_var  TYPE rvari_vnam  VALUE 'UNCONDITIONAL_VAR',     "Unconditional Variant name
  c_issue_ref   TYPE rvari_vnam  VALUE 'ISSUE_REF',             "Issue reference Value
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
  c_mdprod      TYPE c LENGTH 6 VALUE 'MDPROD'.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

DATA: v_land1 TYPE t005s-land1. " by GINTALI:05/19/2018:ED1K907377:RITM0025850 & CR - ERP-7478
