*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_SUBSCRIPTION_UPLOAD (Main Program)
* PROGRAM DESCRIPTION: To upload subscription orders
* DEVELOPER: Prosenjit Chaudhuri(PCHAUDHURI)
* CREATION DATE:   28/11/2016
* OBJECT ID:  E101
* TRANSPORT NUMBER(S):  ED2K903417
*----------------------------------------------------------------------*
* * BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059                 *
* REVISION NO: ED2K911059                                              *
* REFERENCE NO: ERP-6292                                               *
* DEVELOPER: Dinakar T(DTIRUKOOVA)                                     *
* DATE:  23-Feb-2018                                                   *
* DESCRIPTION: Adding New condition type columns and defalut Sales Off *
*              to 0050 as per CR 6292                                  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913082                                              *
* REFERENCE NO: ERP-7640                                               *
* DEVELOPER: Writtick Roy (WROY)                                       *
* DATE:  15-AUG-2018                                                   *
* DESCRIPTION: Add new field-Document Currency for New Order creation  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913189, ED2K913477                                  *
* REFERENCE NO: ERP7614                                               *
* DEVELOPER: Sayantan Das (SAYANDAS)                                   *
* DATE: 24-AUG-2018                                                    *
* DESCRIPTION: Add Background Processing Option                        *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913574                                              *
* REFERENCE NO: ERP-7614                                               *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12-Oct-2018                                                   *
* DESCRIPTION: Application Server paths changed to FILE from constants *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913722                                              *
* REFERENCE NO: ERP7763                                                *
* DEVELOPER: SNGUNTUPAL                                                *
* DATE:  29-Oct-2018                                                   *
* DESCRIPTION: Added Templates to DOwnload                             *
*----------------------------------------------------------------------*
* REVISION NO: ED2K914078                                              *
* REFERENCE NO: ERP7763                                                *
* DEVELOPER: Nageswar(NPOLINA)                                         *
* DATE:  29-Oct-2018                                                   *
* DESCRIPTION: Added ZSCR converted orders                             *
*----------------------------------------------------------------------*
* REVISION NO: ED2K914311                                              *
* REFERENCE NO: ERP7822                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  25-Jan-2019                                                   *
* DESCRIPTION: Added new fields in Create/Change Subscription order    *
*----------------------------------------------------------------------*
* REVISION NO: ED2K915483                                              *
* REFERENCE NO: DM1913                                                 *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  01-July-2019                                                  *
* DESCRIPTION:Order Reason A10 update                                  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K916556                                              *
* REFERENCE NO:ERPM4543                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  24-Oct-2019                                                   *
* DESCRIPTION:Condition Group2 update to ZOFL Order Items              *
*----------------------------------------------------------------------*
* REVISION NO: ED2K916854                                              *
* REFERENCE NO:ERPM2334                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  05-Dec-2019                                                   *
* DESCRIPTION: Code adjustment to work for BP and Order Upload         *
*----------------------------------------------------------------------*
* REVISION NO: ED2K919600                                              *
* REFERENCE NO: OTCM-4390                                              *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/22/2020                                                    *
* DESCRIPTION: Add condition group2 for regular order creation/change  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K919704                                             *
* REFERENCE NO: OTCM-4390                                              *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/29/2020                                                    *
* DESCRIPTION: Make Condition grp2 Mandatory when order type 'ZOR' and
* Item category ZTXD or ZTXP
*----------------------------------------------------------------------* ED2K919818
* REVISION NO: ED2K919734                                             *
* REFERENCE NO: OTCM-4390                                              *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/30/2020                                                    *
* DESCRIPTION: Add PO type to order upload template
*----------------------------------------------------------------------*
* REVISION NO: ED2K919818                                            *
* REFERENCE NO: OTCM-22276                                 *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/09/2020                                                    *
* DESCRIPTION: Add line item Content Start/End Dates to Order Upload to *
*              Accommodate Takeover Perpetual Access                    *
*----------------------------------------------------------------------*
* REVISION NO: ED2K920134                                              *
* REFERENCE NO:ERPM-27580                                              *
* DEVELOPER: AMOHAMMED                                                 *
* DATE:  29-Oct-2020                                                   *
* DESCRIPTION: ZADR Acquisition Debit Additional Enhancements          *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K922718                                              *
* REFERENCE NO:OTCM-42807                                              *
* DEVELOPER: Prabhu(PTUFARAM)                                          *
* DATE:  03-25-2021                                                    *
* DESCRIPTION: Cancellation Process To Update The end Date of the
*                            Contract Automatically                    *
*----------------------------------------------------------------------*
* REVISION NO: ED2K923278/ED2K923617                                              *
* REFERENCE NO: OTCM-44200                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  05/05/2021                                                    *
* DESCRIPTION: ZADR File template changes and new validatinos          *
* ED2K923617 - Change the data type for Identifier
*----------------------------------------------------------------------*
* REVISION NO: ED1K913075                                              *
* REFERENCE NO:INC0363877                                              *
* DEVELOPER: ARGADEELA                                                 *
* DATE:  03-June-2021                                                  *
* DESCRIPTION: Added New Order type ZCOP                               *
*----------------------------------------------------------------------*
* REVISION NO: ED2K924398                                              *
* REFERENCE NO: OTCM-47267                                             *
* DEVELOPER: Nikhilesh Palla (NPALLA)                                  *
* DATE:  29-Oct-2021                                                   *
* DESCRIPTION: Staging Changes                                         *
*----------------------------------------------------------------------*
*====================================================================*
* T A B L E S
*====================================================================*
TABLES: vbak, " Sales Document: Header Data
        mara, " General Material Data
***BOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
        sscrfields. "Screenfields
***EOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
TYPE-POOLS: icon.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*====================================================================*
* S T R U C T U R E
*====================================================================*
TYPES: BEGIN OF ty_date,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE sydatum,    " System Date
         high TYPE sydatum,    " System Date
       END OF ty_date.

TYPES: BEGIN OF ty_edit,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE fieldname,  " Field Name
         high TYPE fieldname,  " Field Name
       END OF ty_edit.

TYPES: BEGIN OF ty_excel_enhanced, "type for excel upload
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,         " Order Identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer      TYPE kunnr,      " Customer Number
         parvw         TYPE parvw,      " Partner Function
         kunnr         TYPE kunnr,      " Customer Number
         vkorg         TYPE vkorg,      "sales org. SAP mandatory
         vtweg         TYPE vtweg,      "dist. channel SAP mandatory
         spart         TYPE spart,      "division SAP mandatory
         guebg         TYPE char10,     "guebg,      "contract start date Wiley mandatory "OTCM-47267 NPALLA
         gueen         TYPE char10,     "gueen,      "contract end date Wiley mandatory   "OTCM-47267 NPALLA
         posnr         TYPE posnr,      "Item number
         matnr         TYPE matnr,      "Material
         plant         TYPE werks_d,    "Plant
         vbeln         TYPE vbeln,      "Sales and Distribution Document Number
         pstyv         TYPE pstyv,      "item category SAP mandatory
         zmeng         TYPE dzmeng,     "target quantity
         lifsk         TYPE lifsk,      "delivery block Wiley mandatory
         faksk         TYPE faksk,      "billing block Wiley mandatory
         abgru         TYPE abgru,      "reason for rejection
         auart         TYPE auart,      "Sales Document Type
         xblnr         TYPE xblnr_v1,   "Reference
         zlsch         TYPE schzw_bseg, "Payment Method
         bsark         TYPE bsark,      "PO Type
         bstnk         TYPE bstnk,      "purchase order number Wiley mandatory
         stxh          TYPE char50,     "Stxh of type CHAR200
         kschl         TYPE kschl,      "pricing condition value Wiley mandatory
         kbetr         TYPE kbetr,      "pricing Wiley mandatory
         ihrez         TYPE ihrez,      "Your Reference
         zzpromo       TYPE zpromo,     "Promo code
         kdkg4         TYPE kdkg4,      " Customer condition group 4
         kdkg5         TYPE kdkg5,      " Customer condition group 5
         kdkg3         TYPE kdkg3,      " Customer condition group 3
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
         srid          TYPE ihrez, " Your Reference
         vkbur         TYPE vkbur, " Sales Office
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
*** BOC BY SAYANDAS on 06-JULY-2018 for CR-6327
         fkdat         TYPE char10,     "fkdat, " Billing date for billing index and printout "OTCM-47267 NPALLA
*** EOC BY SAYANDAS on 06-JULY-2018 for CR-6327
*        Begin of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
         waerk         TYPE waerk, " SD Document Currency
*        End   of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
*  BOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
         zuonr         TYPE ordnr_v,  "Assignment number
* EOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
* BOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
         inv_text(264) TYPE c,  "Text for Invoice instructions
* EOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
* SOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         vaktsch       TYPE vasch_veda,    " Action
         vasda         TYPE char10,        "vasda,         " Date for Action  "OTCM-47267 NPALLA
         perio         TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte         TYPE autte,         " In Advance
         peraf         TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
* EOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         augru         TYPE augru,         " NPOLINA DM1913 E209 01/July/2019 ED2K915483
         kdkg2         TYPE kdkg2,         " NPOLINA ERPM4543 23/Oct/2019 ED2K916556
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with  ED2K919818 *
         zzconstart    TYPE char10,        "zconstart,       " Content Start Date Override "OTCM-47267 NPALLA
         zzconend      TYPE char10,        "zconend,         " Content End Date Override   "OTCM-47267 NPALLA
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with  ED2K919818 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
*         vlaufk        TYPE vlauk_veda,      "Validity period category of contract
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
         vlaufz        TYPE vlauf_veda,      "Validity period of contract
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         zlogno        TYPE balognr,              "Application log: log number
         log_handle    TYPE balloghndl,           "Application Log: Log Handle
         zoid          TYPE ze225_staging-zoid,   "Order Identifier in Upload File
         msgty         TYPE  msgty,               "Message Type
         msgv1         TYPE  msgv1,               "Message Detials
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
       END OF ty_excel_enhanced.

TYPES: BEGIN OF ty_excel_ord_enhanced, "type for excel upload
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,         " Order Identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer TYPE kunnr,          " Customer Number
         parvw    TYPE parvw,          " Partner Function
         partner  TYPE kunnr,          " Customer Number
         vkorg    TYPE vkorg,          "sales org. SAP mandatory
         vtweg    TYPE vtweg,          "dist. channel SAP mandatory
         spart    TYPE spart,          "division SAP mandatory
         guebg    TYPE char10,         "guebg,          "contract start date Wiley mandatory   "OTCM-47267 NPALLA
         gueen    TYPE char10,         "gueen,          "contract end date Wiley mandatory     "OTCM-47267 NPALLA
         augru    TYPE augru,          " Order reason (reason for the business transaction)
         matnr    TYPE matnr,          "Material
         plant    TYPE werks_d,        "Plant
         vbeln    TYPE vbeln,          "Sales and Distribution Document Number
         posnr    TYPE posnr,          "Item number
         pstyv    TYPE pstyv,          "item category SAP mandatory
*         zmeng    TYPE dzmeng,         "target quantity
         kwmeng   TYPE kwmeng, " Cumulative Order Quantity in Sales Units
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr    TYPE xblnr_v1,   "Reference
         zlsch    TYPE schzw_bseg, "Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         lifsk    TYPE lifsk,    "delivery block Wiley mandatory
         faksk    TYPE faksk,    "billing block Wiley mandatory
         abgru    TYPE abgru_va, "reason for rejection
         auart    TYPE auart,    "Sales Document Type
* BOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734 *
         bsark    TYPE bsark,
* EOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734 *
         bstnk    TYPE bstnk,    "purchase order number Wiley mandatory
         stxh     TYPE char50,   "Stxh of type CHAR200
         kschl    TYPE kschl,    "pricing condition value Wiley mandatory
         kbetr    TYPE kbetr,    "pricing Wiley mandatory
         ihrez    TYPE ihrez,    "Your Reference
         ihrez_e  TYPE ihrez_e,  "Ship-to party character
         zzpromo  TYPE zpromo,   "Promo code
         kdkg4    TYPE kdkg4,    " Customer condition group 4
         kdkg5    TYPE kdkg5,    " Customer condition group 5
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3    TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*         srid     TYPE ihrez,
         vkbur    TYPE vkbur, " Sales Office
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* BOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
         kdkg2    TYPE kdkg2,
* EOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         fkdat         TYPE char10,               "Billing Date "OTCM-52926
         zlogno        TYPE balognr,              "Application log: log number
         log_handle    TYPE balloghndl,           "Application Log: Log Handle
         zoid          TYPE ze225_staging-zoid,   "Order Identifier in Upload File
         msgty         TYPE  msgty,               "Message Type
         msgv1         TYPE  msgv1,               "Message Detials
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
       END OF ty_excel_ord_enhanced.

TYPES: BEGIN OF ty_ord_alv,
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer       TYPE kunnr,   " Customer Number
         parvw          TYPE parvw,   " Partner Function
         partner        TYPE kunnr,   " Customer Number
         vkorg          TYPE vkorg,   "sales org. SAP mandatory
         vtweg          TYPE vtweg,   "dist. channel SAP mandatory
         spart          TYPE spart,   "division SAP mandatory
         guebg          TYPE char10,  "guebg,   "contract start date Wiley mandatory   "OTCM-47267 NPALLA
         gueen          TYPE char10,  "gueen,   "contract end date Wiley mandatory     "OTCM-47267 NPALLA
         augru          TYPE augru,   " Order reason (reason for the business transaction)
         matnr          TYPE matnr,   "Material
         plant          TYPE werks_d, "Plant
         vbeln          TYPE vbeln,   "Sales and Distribution Document Number
         posnr          TYPE posnr,   "Item number
         pstyv          TYPE pstyv,   "item category SAP mandatory
*         zmeng    TYPE char17,  "target quantity
         kwmeng         TYPE char15, " Kwmeng of type CHAR15
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr          TYPE xblnr_v1,   "Reference
         zlsch          TYPE schzw_bseg, "Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         lifsk          TYPE lifsk,    "delivery block Wiley mandatory
         faksk          TYPE faksk,    "billing block Wiley mandatory
         abgru          TYPE abgru_va, "reason for rejection
         auart          TYPE auart,    "Sales Document Type
* BOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734 *
         bsark          TYPE bsark,
* EOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734 *
         bstnk          TYPE bstnk,    "purchase order number Wiley mandatory
         stxh           TYPE char50,   "Stxh of type CHAR200
         kschl          TYPE kschl,    "pricing condition value Wiley mandatory
         kbetr          TYPE char16,   "pricing Wiley mandatory
         ihrez          TYPE ihrez,    "Your Reference
         ihrez_e        TYPE ihrez_e,  "Ship-to party character
         zzpromo        TYPE zpromo,   "Promo code
         kdkg4          TYPE kdkg4,    " Customer condition group 4
         kdkg5          TYPE kdkg5,    " Customer condition group 5
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3          TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         srid           TYPE ihrez, " Your Reference
         vkbur          TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* SOC by NPOLINA ERPM2334
         fkdat          TYPE char10,  "Billing Date "OTCM-52926
         bp_email       TYPE ad_smtpadr,
         zlogno         TYPE balognr,
         msgty          TYPE  msgty,
         msgv1          TYPE  msgv1,
         log_handle     TYPE balloghndl,
         zoid(10)       TYPE n,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         icon(4)        TYPE c,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
* EOC by NPOLINA ERPM2334
* BOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
         kdkg2          TYPE kdkg2,
* EOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
       END OF ty_ord_alv.

TYPES: BEGIN OF ty_output_x,
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer       TYPE kunnr,      " Customer Number
         parvw          TYPE parvw,      " Partner Function
         kunnr          TYPE kunnr,      " Customer Number
         vkorg          TYPE vkorg,      "sales org. SAP mandatory
         vtweg          TYPE vtweg,      "dist. channel SAP mandatory
         spart          TYPE spart,      "division SAP mandatory
         guebg          TYPE char10,     "contract start date Wiley mandatory
         gueen          TYPE char10,     "contract end date Wiley mandatory
         posnr          TYPE posnr,      "Item number
         matnr          TYPE matnr,      "Material
         plant          TYPE werks_d,    "Plant
         vbeln          TYPE vbeln,      "Sales and Distribution Document Number
         pstyv          TYPE pstyv,      "item category SAP mandatory
         zmeng          TYPE char17,     "target quantity
         lifsk          TYPE lifsk,      "delivery block Wiley mandatory
         faksk          TYPE faksk,      "billing block Wiley mandatory
         abgru          TYPE abgru_va,   "reason for rejection
         bsark          TYPE bsark,      "PO Type
         auart          TYPE auart,      "Sales Document Type
         xblnr          TYPE xblnr_v1,   "Reference
         zlsch          TYPE schzw_bseg, "Payment Method
         bstnk          TYPE bstnk,      "purchase order number Wiley mandatory
         stxh           TYPE char50,     "Stxh of type CHAR200
         kschl          TYPE kschl,      "pricing condition value Wiley mandatory
         kbetr          TYPE char16,     "pricing Wiley mandatory
         ihrez          TYPE ihrez,      "Your Reference
         zzpromo        TYPE zpromo,     "Promo code
         kdkg4          TYPE kdkg4,      " Customer condition group 4
         kdkg5          TYPE kdkg5,      " Customer condition group 5
         kdkg3          TYPE kdkg3,      " Customer condition group 3
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         srid           TYPE ihrez, " Your Reference
         vkbur          TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*** BOC BY SAYANDAS on 06-JULY-2018 for CR-6327
         fkdat          TYPE char10, " Fkdat of type CHAR10
*** EOC BY SAYANDAS on 06-JULY-2018 for CR-6327
*        Begin of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
         waerk          TYPE waerk, " SD Document Currency
*        End   of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
*  BOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
         zuonr          TYPE ordnr_v,  "Assignment number
* EOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
* BOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
         inv_text(264)  TYPE c,  "Text for Invoice instructions- header
* EOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
* SOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         vaktsch        TYPE vasch_veda,    " Action
         vasda          TYPE char10,         " Date for Action
         perio          TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte          TYPE autte,         " In Advance
         peraf          TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
* EOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         augru          TYPE augru,        " NPOLINA DM1913 01/July/2019 ED2K915483
         kdkg2          TYPE kdkg2,        " NPOLINA ERPM4543 23/Oct/2019 ED2K916556
* SOC by NPOLINA ERPM2334
         bp_email       TYPE ad_smtpadr,
         zlogno         TYPE balognr,
         msgty          TYPE  msgty,
         msgv1          TYPE  msgv1,
         log_handle     TYPE balloghndl,
         zoid(10)       TYPE n,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
* EOC by NPOLINA ERPM2334
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         icon(4)        TYPE c,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
         zzconstart     TYPE char10,       " Content Start Date Override
         zzconend       TYPE char10,         " Content End Date Override
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
*         vlaufk         TYPE vlauk_veda,      "Validity period category of contract
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
         vlaufz         TYPE vlauf_veda,      "Validity period of contract
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
       END OF ty_output_x.
***
* SOC by NPOLINA ERPM2334 04/Dec/2019
TYPES: BEGIN OF ty_output_e225,
         sel,
         customer       TYPE kunnr,      " Customer Number
         parvw          TYPE parvw,      " Partner Function
         kunnr          TYPE kunnr,      " Customer Number
         vkorg          TYPE vkorg,      "sales org. SAP mandatory
         vtweg          TYPE vtweg,      "dist. channel SAP mandatory
         spart          TYPE spart,      "division SAP mandatory
         guebg          TYPE char10,     "contract start date Wiley mandatory
         gueen          TYPE char10,     "contract end date Wiley mandatory
         posnr          TYPE posnr,      "Item number
         matnr          TYPE matnr,      "Material
         plant          TYPE werks_d,    "Plant
         vbeln          TYPE vbeln,      "Sales and Distribution Document Number
         pstyv          TYPE pstyv,      "item category SAP mandatory
         zmeng          TYPE char17,     "target quantity
         lifsk          TYPE lifsk,      "delivery block Wiley mandatory
         faksk          TYPE faksk,      "billing block Wiley mandatory
         abgru          TYPE abgru_va,   "reason for rejection
         bsark          TYPE bsark,      "PO Type
         auart          TYPE auart,      "Sales Document Type
         xblnr          TYPE xblnr_v1,   "Reference
         zlsch          TYPE schzw_bseg, "Payment Method
         bstnk          TYPE bstnk,      "purchase order number Wiley mandatory
         stxh           TYPE char50,     "Stxh of type CHAR200
         kschl          TYPE kschl,      "pricing condition value Wiley mandatory
         kbetr          TYPE char16,     "pricing Wiley mandatory
         ihrez          TYPE ihrez,      "Your Reference
         zzpromo        TYPE zpromo,     "Promo code
         kdkg4          TYPE kdkg4,      " Customer condition group 4
         kdkg5          TYPE kdkg5,      " Customer condition group 5
         kdkg3          TYPE kdkg3,      " Customer condition group 3
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         srid           TYPE ihrez, " Your Reference
         vkbur          TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*** BOC BY SAYANDAS on 06-JULY-2018 for CR-6327
         fkdat          TYPE char10, " Fkdat of type CHAR10
*** EOC BY SAYANDAS on 06-JULY-2018 for CR-6327
*        Begin of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
         waerk          TYPE waerk, " SD Document Currency
*        End   of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
*  BOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
         zuonr          TYPE ordnr_v,  "Assignment number
* EOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
* BOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
         inv_text(264)  TYPE c,  "Text for Invoice instructions- header
* EOC CR#ERP - 7775 10/17/2018 : PRABHU : ED2K913574
* SOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         vaktsch        TYPE vasch_veda,    " Action
         vasda          TYPE char10,         " Date for Action
         perio          TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte          TYPE autte,         " In Advance
         peraf          TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
* EOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         augru          TYPE augru,        " NPOLINA DM1913 01/July/2019 ED2K915483
         kdkg2          TYPE kdkg2,        " NPOLINA ERPM4543 23/Oct/2019 ED2K916556
         identifier(10) TYPE n,
         oid(10)        TYPE n,
       END OF ty_output_e225.
* EOC by NPOLINA ERPM2334 04/Dec/2019
*** BOC by SAYANDAS for ERP-3104 on 19th July 2017
TYPES: BEGIN OF ty_output_x_chg,
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer      TYPE kunnr,      " Customer Number
         vbeln         TYPE vbeln,      "Sales and Distribution Document Number
         parvw         TYPE parvw,      " Partner Function
         kunnr         TYPE kunnr,      " Customer Number
         vkorg         TYPE vkorg,      "sales org. SAP mandatory
         vtweg         TYPE vtweg,      "dist. channel SAP mandatory
         spart         TYPE spart,      "division SAP mandatory
         guebg         TYPE char10,     "contract start date Wiley mandatory
         gueen         TYPE char10,     "contract end date Wiley mandatory
         posnr         TYPE posnr,      "Item number
         matnr         TYPE matnr,      "Material
         plant         TYPE werks_d,    "Plant
         pstyv         TYPE pstyv,      "item category SAP mandatory
         zmeng         TYPE char17,     "target quantity
         lifsk         TYPE lifsk,      "delivery block Wiley mandatory
         faksk         TYPE faksk,      "billing block Wiley mandatory
         abgru         TYPE abgru_va,   "reason for rejection
         bsark         TYPE bsark,      "PO Type
         auart         TYPE auart,      "Sales Document Type
         xblnr         TYPE xblnr_v1,   "Reference
         zlsch         TYPE schzw_bseg, "Payment Method
         bstnk         TYPE bstnk,      "purchase order number Wiley mandatory
         stxh          TYPE char50,     "Stxh of type CHAR200
         kschl         TYPE kschl,      "pricing condition value Wiley mandatory
         kbetr         TYPE char16,     "pricing Wiley mandatory
         ihrez         TYPE ihrez,      "Your Reference
         zzpromo       TYPE zpromo,     "Promo code
         kdkg4         TYPE kdkg4,      " Customer condition group 4
         kdkg5         TYPE kdkg5,      " Customer condition group 5
         kdkg3         TYPE kdkg3,      " Customer condition group 3
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         vkbur         TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         inv_text(264) TYPE c,     " ERP7763 SGUNTUPALL
* SOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         vaktsch       TYPE vasch_veda,    " Action
         vasda         TYPE char10,         " Date for Action
         perio         TYPE perio_fp,      " Rule for Origin of Next Billing/Invoice Date
         autte         TYPE autte,         " In Advance
         peraf         TYPE peraf_fp,      " Rule for Determination of a Deviating Billing/Invoice Date
         augru         TYPE augru,         " NPOLINA DM1913 28/June/2019 ED2K915483
* EOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
         kdkg2         TYPE kdkg2,         "NPOLINA ERPM4543 23/Oct/2019 ED2K916556
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         zlogno         TYPE balognr,
         msgty          TYPE  msgty,
         msgv1          TYPE  msgv1,
         log_handle     TYPE balloghndl,
         zoid(10)       TYPE n,
         icon(4)        TYPE c,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         zzconstart    TYPE char10,       " Content Start Date Override
         zzconend      TYPE char10,         " Content End Date Override
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
*         vlaufk        TYPE vlauk_veda,      "Validity period category of contract
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
         vlaufz        TYPE vlauf_veda,      "Validity period of contract
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
       END OF ty_output_x_chg.
*** EOC by SAYANDAS for ERP-3104 on 19th July 2017
TYPES: BEGIN OF ty_bstnk,
         bstnk TYPE bstnk, " Customer purchase order number
       END OF ty_bstnk.
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
TYPES : BEGIN OF ty_srid,
          srid TYPE ihrez, " Your Reference
        END OF ty_srid.
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365

TYPES: BEGIN OF ty_ernam,
         ernam TYPE ernam, " Name of Person who Created the Object
       END OF ty_ernam.

TYPES: BEGIN OF ty_vbeln,
         vbeln TYPE vbeln_vf, " Billing Document
       END OF ty_vbeln.

**** BOC BY SAYANDAS for BOM Partner on 23-AUG-2017
*TYPES: BEGIN OF ty_bom_partner,
*         posnr TYPE posnr, " Item number of the SD document
*         parvw TYPE parvw, " Partner Function
*         kunnr TYPE kunnr, " Customer Number
*       END OF  ty_bom_partner.
**** EOC BY SAYANDAS for BOM Partner on 23-AUG-2017

TYPES: BEGIN OF ty_exist_subs_ord,  "type for existing subs. ord., to be used for joining VBAP and VBAK
         vbeln      TYPE vbeln,       "invoice number
         auart      TYPE auart,       "doc. type SAP mandatory
         vkorg      TYPE vkorg,       "sales org. SAP mandatory
         vtweg      TYPE vtweg,       "dist. channel SAP mandatory
         spart      TYPE spart,       "division SAP mandatory
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         vkbur      TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
***BOC BY SAYANDAS on 31st AUG 2017 for ERP-4065
         guebg      TYPE guebg, "contract start date Wiley mandatory
         gueen      TYPE gueen, "contract end date Wiley mandatory
***EOC BY SAYANDAS on 31st AUG 2017 for ERP-4065
         bstnk      TYPE bstnk, "purchase order number Wiley mandatory
         ihrez      TYPE ihrez, " Your Reference
         knumv      TYPE knumv, "number of document condo.
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr      TYPE xblnr_v1, " Reference Document Number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zzpromo    TYPE zpromo,  "promo code
         lifsk      TYPE lifsk,   "delivery block Wiley mandatory
         faksk      TYPE faksk,   "billing block Wiley mandatory
         posnr      TYPE posnr,   "item number
         matnr      TYPE matnr,   "material
         werks      TYPE werks_d, "plant
         pstyv      TYPE pstyv,   "item category SAP mandatory
         abgru      TYPE abgru,   "reason for rejection
         zmeng      TYPE dzmeng,  "target quantity
         parvw      TYPE parvw,   " Partner Function
         kunnr      TYPE kunnr,   " Customer Number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zlsch      TYPE schzw_bseg, " Payment Method
         kdkg3      TYPE kdkg3,      " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg4      TYPE kdkg4, " Customer condition group 4
         kdkg5      TYPE kdkg5, " Customer condition group 5
***BOC BY SAYANDAS on 31st AUG 2017 for ERP-4065
*          guebg   TYPE vbdat_veda, " Contract start date
*          gueen   TYPE vndat_veda, " Contract end date
***EOC BY SAYANDAS on 31st AUG 2017 for ERP-4065
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*          srid    TYPE ihrez,
*          vkbur   TYPE vkbur,
*        End   of CHANGE:ERP-7640:WROY:15-AUG-2018:ED2K913082
*  BOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
         fkdat      TYPE fkdat, "Pricing date
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         bsark      TYPE bsark, "PO Type
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         waerk      TYPE waerk, " SD Document Currency
         zuonr      TYPE ordnr_v,  "Assignment number
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         kdkg2      TYPE kdkg2,   "NPOLINA ERPM4543 23/Oct/2019 ED2K916556
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
         zzconstart TYPE zconstart,       " Content Start Date Override
         zzconend   TYPE zconend,         " Content End Date Override
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
*         vlaufk     TYPE vlauk_veda,      "Validity period category of contract
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
         vlaufz     TYPE vlauf_veda,      "Validity period of contract
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
       END OF ty_exist_subs_ord.

TYPES: BEGIN OF ty_cred_memo, "type for creating credit memo, contains additional field vbeln for join
         vbeln   TYPE vbeln,  " Sales and Distribution Document Number
         auart   TYPE auart,  " Sales Document Type
         augru   TYPE augru,  " Order reason (reason for the business transaction)
         vkorg   TYPE vkorg,  " Sales Organization
         vtweg   TYPE vtweg,  " Distribution Channel
         spart   TYPE spart,  " Division
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         vkbur   TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         bstnk   TYPE bstnk, " Customer purchase order number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr   TYPE xblnr_v1, " Reference Document Number
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         vgbel   TYPE vgbel,  " Document number of the reference document
         ihrez   TYPE ihrez,  " Your Reference
         zzpromo TYPE zpromo, " Promo code
         posnr   TYPE posnr,  " Item number of the SD document
         matnr   TYPE matnr,  " Material Number
         plant   TYPE werks_d,   " NPOLINA TEMPLATE
         zmeng   TYPE dzmeng, " Target quantity in sales units
         parvw   TYPE parvw,  " Partner Function
         kunnr   TYPE kunnr,  " Customer Number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zlsch   TYPE schzw_bseg, " Payment Method
         kdkg3   TYPE kdkg3,      " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
         bstkd   TYPE bstkd, " Customer purchase order number
         bsark   TYPE bsark, " Customer purchase order type
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         pstyv   TYPE pstyv, " Sales document item category
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
       END OF ty_cred_memo,

       BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_vf, " Billing Document
         erdat TYPE erdat,    " Date on Which Record Was Created
         vkorg TYPE vkorg,    " Sales Organization
         vtweg TYPE vtweg,    " Distribution Channel
         spart TYPE spart,    " Division
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zlsch TYPE schzw_bseg, " Payment Method
         xblnr TYPE xblnr_v1,   " Reference Document Number
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         posnr TYPE posnr, " Sales Document Item
         matnr TYPE matnr, " Material Number        " Date on Which Record Was Created
         fkimg TYPE fkimg, " Actual Invoiced Quantity
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         pstyv TYPE pstyv, " Sales document item category
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
*** BOC BY SAYANDAS on 18-Dec-2017 for Multiple KSCHL
         pospa TYPE pospa, " Item number in the partner segment
*** EOC BY SAYANDAS on 18-Dec-2017 for Multiple KSCHL
         parvw TYPE parvw,    "Partner Function
         kunnr TYPE kunnr,    "Customer Number
       END OF ty_vbrk,

       BEGIN OF ty_crdt_memo_enh,
         sel,
         customer TYPE kunnr, " Customer Number
         parvw    TYPE parvw, " Partner Function
         partner  TYPE kunnr, " Customer Number
         vkorg    TYPE vkorg, " Sales Organization
         vtweg    TYPE vtweg, " Distribution Channel
         spart    TYPE spart, " Division
         auart    TYPE auart, " Sales Document Type
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         zlsch    TYPE schzw_bseg, " Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         augru    TYPE augru,    " Order reason (reason for the business transaction)
         vbeln    TYPE vbeln_vf, " Billing Document
         posnr    TYPE posnr_vf, " Billing item
         matnr    TYPE matnr,    " Material Number
         plant    TYPE werks_d,  " Plant
*        Begin of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
*        fkimg    TYPE char17,   " Actual Invoiced Quantity
         fkimg    TYPE fkimg, " Actual Invoiced Quantity
*        End   of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
         stxh     TYPE char50, " Name
         kschl    TYPE kschl,  " Condition Type
*        Begin of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
*        kbetr    TYPE char16,   " Rate (condition amount or percentage)
         kbetr    TYPE kbetr, " Rate (condition amount or percentage)
*        End   of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
         ihrez    TYPE ihrez, " Your Reference
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3    TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*         srid     TYPE ihrez, " Your Reference
         vkbur    TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
         bstnk    TYPE bstnk, " Customer purchase order number
         bsark    TYPE bsark, " Customer purchase order type
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         pstyv    TYPE pstyv, " Sales document item category
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
       END OF ty_crdt_memo_enh.
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
TYPES: BEGIN OF ty_crdt_memo_crt,
         sel,
         customer TYPE kunnr,      " Customer Number
         parvw    TYPE parvw,      " Partner Function
         partner  TYPE kunnr,      " Customer Number
         vkorg    TYPE vkorg,      " Sales Organization
         vtweg    TYPE vtweg,      " Distribution Channel
         spart    TYPE spart,      " Division
         auart    TYPE auart,      " Sales Document Type
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         zlsch    TYPE schzw_bseg, " Payment Method
         augru    TYPE augru,      " Order reason (reason for the business transaction)
         vbeln    TYPE vbeln_vf,   " Billing Document
         posnr    TYPE posnr_vf,   " Billing item
         matnr    TYPE matnr,      " Material Number
         plant    TYPE werks_d,    " Plant
         fkimg    TYPE fkimg,      " Actual Invoiced Quantity
         stxh     TYPE char50,     " Name
         kschl    TYPE kschl,      " Condition Type
         kbetr    TYPE kbetr,      " Rate (condition amount or percentage)
         kschl2   TYPE kschl,      " Condition Type
         kbetr2   TYPE kbetr,      " Condition value
         kschl3   TYPE kschl,      " Condition Type
         kbetr3   TYPE kbetr,      " Condition value
         ihrez    TYPE ihrez,      " Your Reference
         kdkg3    TYPE kdkg3,      " Customer condition group 3
         vkbur    TYPE vkbur,      " Sales Office
         bstnk    TYPE bstnk,      " Customer purchase order number
         bsark    TYPE bsark,      " Customer purchase order type
         pstyv    TYPE pstyv,      " Sales document item category
         tax      TYPE kbetr,      " Tax amount mandatory for ZSCR NPOLINA ERP7763 ED2K914144
       END OF ty_crdt_memo_crt.
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
TYPES: BEGIN OF ty_ord_select,
         vbeln   TYPE vbeln, " Sales and Distribution Document Number
         erdat   TYPE erdat, " Date on Which Record Was Created
         auart   TYPE auart, " Sales Document Type
         augru   TYPE augru, " Order reason (reason for the business transaction)
         vkorg   TYPE vkorg, " Sales Organization
         vtweg   TYPE vtweg, " Distribution Channel
         spart   TYPE spart, " Division
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         vkbur   TYPE vkbur, " Sales Office
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         guebg   TYPE guebg, "contract start date Wiley mandatory
         gueen   TYPE gueen, "contract end date Wiley mandatory
         lifsk   TYPE lifsk, " Delivery block (document header)
         faksk   TYPE faksk, " Billing block in SD document
         knumv   TYPE knumv, " Number of the document condition
* BOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734  *
         bsark   TYPE bsark,
* EOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734  *
         bstnk   TYPE bstnk, " Customer purchase order number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr   TYPE xblnr_v1, " Reference Document Number
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zzpromo TYPE zpromo,  " Promo code
         posnr   TYPE posnr_d, " Sequence Number for Distribution to Account Assign. Objects
         matnr   TYPE matnr,   " Material Number
*         zmeng   TYPE dzmeng,   " Target quantity in sales units
         kwmeng  TYPE kwmeng,   " Cumulative Order Quantity in Sales Units
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         werks   TYPE werks,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         pstyv   TYPE pstyv,    " Sales document item category
         abgru   TYPE abgru_va, " Reason for rejection of quotations and sales orders
         parvw   TYPE parvw,    " Partner Function
         kunnr   TYPE kunnr,    " Customer Number
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         zlsch   TYPE schzw_bseg, " Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267 OTCM-52926
         fkdat   TYPE fkdat,   "Billing Date
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267 OTCM-52926
         ihrez   TYPE ihrez,   " Your Reference
         ihrez_e TYPE ihrez_e, " Ship-to party character
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3   TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg4   TYPE kdkg4, " Customer condition group 4
         kdkg5   TYPE kdkg5, " Customer condition group 5
* BOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
         kdkg2   TYPE kdkg2, " Customer condition group 2
* EOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
       END OF ty_ord_select.

*** BOC BY SAYANDAS on 04-Dec-2017 for CMRORDCHG

TYPES: BEGIN OF ty_crdt_memo_enh_chg,
         sel,
         customer TYPE kunnr,    " Customer Number
         vbeln    TYPE vbeln_vf, " Billing Document
         parvw    TYPE parvw,    " Partner Function
         partner  TYPE kunnr,    " Customer Number
         vkorg    TYPE vkorg,    " Sales Organization
         vtweg    TYPE vtweg,    " Distribution Channel
         spart    TYPE spart,    " Division
         auart    TYPE auart,    " Sales Document Type
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         zlsch    TYPE schzw_bseg, " Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         augru    TYPE augru,    " Order reason (reason for the business transaction)
         posnr    TYPE posnr_vf, " Billing item
         matnr    TYPE matnr,    " Material Number
         plant    TYPE werks_d,  " Plant
         fkimg    TYPE char17,   " Actual Invoiced Quantity
         stxh     TYPE char50,   " Name
         kschl    TYPE kschl,    " Condition Type
         kbetr    TYPE char16,   " Rate (condition amount or percentage)
         ihrez    TYPE ihrez,    " Your Reference
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3    TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*         srid     TYPE ihrez, " Your Reference
         vkbur    TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
         bstnk    TYPE bstnk, " Customer purchase order number
         bsark    TYPE bsark, " Customer purchase order type
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         pstyv    TYPE pstyv, " Sales document item category
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
       END OF ty_crdt_memo_enh_chg.

* SOC BY NPOLINA ERP7763 ED2K914078
TYPES: BEGIN OF ty_crdt_memo_enh_down,
         customer TYPE kunnr, " Customer Number
         parvw    TYPE parvw, " Partner Function
         partner  TYPE kunnr, " Customer Number
         vkorg    TYPE vkorg, " Sales Organization
         vtweg    TYPE vtweg, " Distribution Channel
         spart    TYPE spart, " Division
         auart    TYPE auart, " Sales Document Type
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr    TYPE xblnr_v1,   " Reference Document Number
         zlsch    TYPE schzw_bseg, " Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         augru    TYPE augru,    " Order reason (reason for the business transaction)
         vbeln    TYPE vbeln_vf, " Billing Document
         posnr    TYPE posnr_vf, " Billing item
         matnr    TYPE matnr,    " Material Number
         plant    TYPE werks_d,  " Plant
*        Begin of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
*        fkimg    TYPE char17,   " Actual Invoiced Quantity
         fkimg    TYPE fkimg, " Actual Invoiced Quantity
*        End   of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
         stxh     TYPE char50, " Name
         kschl    TYPE kschl,  " Condition Type
*        Begin of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
*        kbetr    TYPE char16,   " Rate (condition amount or percentage)
         kbetr    TYPE kbetr, " Rate (condition amount or percentage)
*        End   of ADD:ERP-6389:WROY:30-Jan-2018:ED2K910587
         ihrez    TYPE ihrez, " Your Reference
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3    TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
*         srid     TYPE ihrez, " Your Reference
         vkbur    TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
         bstnk    TYPE bstnk, " Customer purchase order number
         bsark    TYPE bsark, " Customer purchase order type
* BOC by SAYANDAS on 07-Aug-2017 for ERP-3687
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         pstyv    TYPE pstyv, " Sales document item category
*** BOC BY SAYANDAS on 30-Nov-2017 for Credit Memo PSTYV Addition
         tax      TYPE kbetr,      " Tax amount mandatory for ZSCR NPOLINA ERP7763 ED2K914144
       END OF ty_crdt_memo_enh_down.
* EOC by NPOLINA ERP7763 ED2K914078
TYPES: BEGIN OF ty_ord_alv_chg,
         sel,
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         identifier(10) TYPE n,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         customer TYPE kunnr,   " Customer Number
         vbeln    TYPE vbeln,   "Sales and Distribution Document Number
         parvw    TYPE parvw,   " Partner Function
         partner  TYPE kunnr,   " Customer Number
         vkorg    TYPE vkorg,   "sales org. SAP mandatory
         vtweg    TYPE vtweg,   "dist. channel SAP mandatory
         spart    TYPE spart,   "division SAP mandatory
         guebg    TYPE char10,  "guebg,   "contract start date Wiley mandatory   "OTCM-47267 NPALLA
         gueen    TYPE char10,  "gueen,   "contract end date Wiley mandatory     "OTCM-47267 NPALLA
         augru    TYPE augru,   " Order reason (reason for the business transaction)
         matnr    TYPE matnr,   "Material
         plant    TYPE werks_d, "Plant
         posnr    TYPE posnr,   "Item number
         pstyv    TYPE pstyv,   "item category SAP mandatory
*         zmeng    TYPE char17,  "target quantity
         kwmeng         TYPE char15, " Kwmeng of type CHAR15 "OTCM-47267
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         xblnr    TYPE xblnr_v1,   "Reference
         zlsch    TYPE schzw_bseg, "Payment Method
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         lifsk    TYPE lifsk,    "delivery block Wiley mandatory
         faksk    TYPE faksk,    "billing block Wiley mandatory
         abgru    TYPE abgru_va, "reason for rejection
         auart    TYPE auart,    "Sales Document Type
* BOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734  *
         bsark    TYPE bsark,
* EOC by Lahiru on 09/30/2020 for OTCM-4390 with ED2K919734  *
         bstnk    TYPE bstnk,    "purchase order number Wiley mandatory
         stxh     TYPE char50,   "Stxh of type CHAR200
         kschl    TYPE kschl,    "pricing condition value Wiley mandatory
         kbetr    TYPE char16,   "pricing Wiley mandatory
         ihrez    TYPE ihrez,    "Your Reference
         ihrez_e  TYPE ihrez_e,  "Ship-to party character
         zzpromo  TYPE zpromo,   "Promo code
         kdkg4    TYPE kdkg4,    " Customer condition group 4
         kdkg5    TYPE kdkg5,    " Customer condition group 5
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
         kdkg3    TYPE kdkg3, " Customer condition group 3
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907081
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
         srid     TYPE ihrez, " Your Reference
         vkbur    TYPE vkbur, " Sales Office
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
* BOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
         kdkg2    TYPE kdkg2, " Customer condition group 2
* EOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919600 *
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
         fkdat          TYPE char10,  "Billing Date "OTCM-52926
         zlogno         TYPE balognr,
         msgty          TYPE  msgty,
         msgv1          TYPE  msgv1,
         log_handle     TYPE balloghndl,
         zoid(10)       TYPE n,
         icon(4)        TYPE c,
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
       END OF ty_ord_alv_chg.
*** BOC BY SAYANDAS on 04-Dec-2017 for CMRORDCHG
TYPES: BEGIN OF ty_vbpa,       "for sold to customer nad partner function from VBPA
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE parvw,      " Partner Function
         high TYPE parvw,      " Partner Function
       END OF ty_vbpa,

*** BOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type
       BEGIN OF ty_cmauart,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE auart,      " Sales Document Type
         high TYPE auart,      " Sales Document Type
       END OF ty_cmauart,
*** EOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type

       BEGIN OF ty_bom_items,
         old_posnr TYPE posnr, " Item number of the SD document
         new_posnr TYPE posnr, " Item number of the SD document
       END OF ty_bom_items.

TYPES : BEGIN OF ty_rfbsk,
          sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE rfbsk,      " Status for transfer to accounting
          high   TYPE rfbsk,      " Status for transfer to accounting
        END OF   ty_rfbsk,

        tt_rfbsk TYPE STANDARD TABLE OF ty_rfbsk INITIAL SIZE 0.

* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
TYPES : BEGIN OF ty_cond_type,
          sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE kschl,      " Condition type
          high   TYPE kschl,      " Condition type
        END OF ty_cond_type,

        tt_cond_type TYPE STANDARD TABLE OF ty_cond_type INITIAL SIZE 0.
TYPES : BEGIN OF ty_cond_class,
          kappl TYPE kappl,                                            " Application
          kschl TYPE kscha,                                            " Condition Type
          krech TYPE krech,                                            " Condition Class
        END OF ty_cond_class,
        tt_cond_class TYPE STANDARD TABLE OF ty_cond_class INITIAL SIZE 0,
        tt_bapicond   TYPE STANDARD TABLE OF bapicond INITIAL SIZE 0,  " Communication Fields for Maintaining Conditions in the Order
        tt_bapicondx  TYPE STANDARD TABLE OF bapicondx INITIAL SIZE 0. " Communication Fields for Maintaining Conditions in the Order
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059

* SOC by NPOLINA E101 Paths  ED2K913574 ERP7614
*--*Structure to hold constant table
TYPES: BEGIN OF ty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const.

* EOC by NPOLINA E101 Paths  ED2K913574 ERP7614
TYPES: BEGIN OF ty_addr,
         partner    TYPE kunnr, " ABAP: ID: I/E (include/exclude values)
         parvw      TYPE parvw, " ABAP: Selection option (EQ/BT/CP/...)
         posnr      TYPE posnr,  " Field Name
         email(241) TYPE c,  " Field Name
       END OF ty_addr.
*====================================================================*
* T A B L E  T Y P E S
*====================================================================*
TYPES: tt_edit              TYPE STANDARD TABLE OF ty_edit
                          INITIAL SIZE 0,
       tt_excel_enh         TYPE STANDARD TABLE OF ty_excel_enhanced
                          INITIAL SIZE 0,
       tt_exist_subs_ord    TYPE STANDARD TABLE OF ty_exist_subs_ord
                          INITIAL SIZE 0,
       tt_order_alv         TYPE STANDARD TABLE OF ty_ord_alv
                          INITIAL SIZE 0 ,
       tt_crdt_memo_enh     TYPE STANDARD TABLE OF ty_crdt_memo_enh
                          INITIAL SIZE 0,
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
       tt_crdt_memo_crt     TYPE STANDARD TABLE OF ty_crdt_memo_crt
                          INITIAL SIZE 0,
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059

*** BOC BY SAYANDAS on 04-Dec-2017 for CMRORDCHG
       tt_crdt_memo_enh_chg TYPE STANDARD TABLE OF ty_crdt_memo_enh_chg
                          INITIAL SIZE 0,
       tt_order_alv_chg     TYPE STANDARD TABLE OF ty_ord_alv_chg
                          INITIAL SIZE 0 ,
*** BOC BY SAYANDAS on 04-Dec-2017 for CMRORDCHG
       tt_output_x          TYPE STANDARD TABLE OF ty_output_x
                          INITIAL SIZE 0,
*** BOC by SAYANDAS for ERP-3104 on 19th July 2017
       tt_output_x_chg      TYPE STANDARD TABLE OF ty_output_x_chg
                          INITIAL SIZE 0,
*** EOC by SAYANDAS for ERP-3104 on 19th July 2017
       tt_bom_items         TYPE STANDARD TABLE OF ty_bom_items
                          INITIAL SIZE 0,
       tt_vbrk              TYPE STANDARD TABLE OF ty_vbrk
                          INITIAL SIZE 0,
       tt_date              TYPE STANDARD TABLE OF ty_date
                          INITIAL SIZE 0,
       tt_ord_alv           TYPE STANDARD TABLE OF ty_ord_alv
                          INITIAL SIZE 0,
       tt_final_ord         TYPE STANDARD TABLE OF ty_excel_ord_enhanced
                          INITIAL SIZE 0,
       tt_ord_select        TYPE STANDARD TABLE OF ty_ord_select
                          INITIAL SIZE 0,
       tt_vbpa              TYPE STANDARD TABLE OF ty_vbpa
                          INITIAL SIZE 0,
*** BOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type
       tt_cmauart           TYPE STANDARD TABLE OF ty_cmauart
                          INITIAL SIZE 0,
*** EOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
       tt_err_msg           TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                          INITIAL SIZE 0,
       tt_err_msg_list      TYPE STANDARD TABLE OF wlf1_err_li
                          INITIAL SIZE 0,
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
       tt_cred_memo         TYPE STANDARD TABLE OF ty_cred_memo
                          INITIAL SIZE 0,
       tt_addr              TYPE STANDARD TABLE OF ty_addr INITIAL SIZE 0.
*====================================================================*
*  I N T E R N A L  T A B L E
*====================================================================*
DATA: i_vbeln          TYPE STANDARD TABLE OF  ty_vbeln " For order type as credit memo or subscription
                           INITIAL SIZE 0,
      i_vbrk           TYPE STANDARD TABLE OF  ty_vbrk
                           INITIAL SIZE 0,
      i_edit           TYPE tt_edit,
      i_ord_alv        TYPE STANDARD TABLE OF  ty_ord_alv
                           INITIAL SIZE 0,
      i_final_ord      TYPE STANDARD TABLE OF  ty_excel_ord_enhanced
                           INITIAL SIZE 0,
      i_vbpa           TYPE STANDARD TABLE OF  ty_vbpa
                           INITIAL SIZE 0,
*** BOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type
      i_cmauart        TYPE STANDARD TABLE OF ty_cmauart
                           INITIAL SIZE 0,
*      i_cmauart    TYPE RANGE OF ty_cmauart
*                           INITIAL SIZE 0,
*** EOC BY SAYANDAS on 29-Nov-2017 for Credit Memo Order Type
      i_cred_memo      TYPE STANDARD TABLE OF  ty_cred_memo " For manipulation before alv display of existing invoices
                           INITIAL SIZE 0,
      i_final_crdt     TYPE STANDARD TABLE OF  ty_crdt_memo_enh
                           INITIAL SIZE 0,
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
      i_final_crme_crt TYPE STANDARD TABLE OF  ty_crdt_memo_crt
                           INITIAL SIZE 0,
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059

      i_final          TYPE STANDARD TABLE OF ty_excel_enhanced
                           INITIAL SIZE 0,             " This internal table would be used for data storing during validation
      i_output_x       TYPE STANDARD TABLE OF ty_output_x
                           INITIAL SIZE 0,             " For the ALV display
      i_output_tmp     TYPE STANDARD TABLE OF ty_output_x     "++VDPATABALL Dump internal table E225
                        INITIAL SIZE 0,             " For the ALV display
      i_fcat_out       TYPE slis_t_fieldcat_alv,
      i_orders         TYPE tt_ord_select,
      i_bstnk          TYPE STANDARD TABLE OF ty_bstnk " For f4 of purch. doc.
                           INITIAL SIZE 0,
      i_ernam          TYPE STANDARD TABLE OF ty_ernam " For F4 of user id
                           INITIAL SIZE 0,
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
      i_srid           TYPE STANDARD TABLE OF ty_srid
                           INITIAL SIZE 0,
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
**** BOC BY SAYANDAS for BOM Partner on 23-AUG-2017
*      i_bom_partner TYPE STANDARD TABLE OF ty_bom_partner
*                                   INITIAL SIZE 0,
**** BOC BY SAYANDAS for BOM Partner on 23-AUG-2017
      i_err_msg        TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                           INITIAL SIZE 0,
      i_err_msg1       TYPE STANDARD TABLE OF wlf1_error " Vendor Billing Document: Error Message Structure
                           INITIAL SIZE 0,
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
      i_cond_type      TYPE tt_cond_type,
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      i_message        TYPE STANDARD TABLE OF solisti1,                  " SAPoffice: Single List with Column Length 255
      i_attach         TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
      i_err_msg_list   LIKE wlf1_err_li                                  " Agency business: Error message structure, list processor
                         OCCURS 0 WITH HEADER LINE,
      i_final_csv      TYPE truxs_t_text_data,
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      i_const          TYPE STANDARD TABLE OF ty_const,   "NPOLINA ERP7614  ED2K913574
      i_e225_stage     TYPE STANDARD TABLE OF ze225_staging ,  "NPOLINA ERPM2334  04/Dec/2019
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
      i_e101_stage     TYPE STANDARD TABLE OF ze225_staging ,  "NPALLA OTCM-47267
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
      i_bapi_addr      TYPE STANDARD TABLE OF bapiaddr1 INITIAL SIZE 0,  "NPOLINA "ERPM2334
      st_bapi_addr     TYPE bapiaddr1 ,  "NPOLINA "ERPM2334
      st_loghandle     TYPE bal_t_logh,
      i_lognum         TYPE bal_t_lgnm,
      st_lognum        TYPE bal_s_lgnm,
      i_return         TYPE STANDARD TABLE OF bapiret2,   "NPOLINA ERPM2334  04/Dec/2019
      st_return        TYPE bapiret2,   "NPOLINA ERPM2334  04/Dec/2019
      i_addr           TYPE STANDARD TABLE OF ty_addr,
      st_addr          TYPE ty_addr.

*====================================================================*
*   W O R K - A R E A
*====================================================================*
DATA: st_fcat_out    TYPE slis_fieldcat_alv, " ALV specific tables and structures
      st_err_msg     TYPE wlf1_error,        " Vendor Billing Document: Error Message Structure
      st_final_x     TYPE ty_excel_enhanced, " For subscription order
      st_output_x    TYPE ty_output_x,       " For create subscription order alv
      st_output_e225 TYPE ty_output_e225,       " For create subscription order alv   "NPOLINA ERPM2334 04/Dec/2019
      st_layout      TYPE slis_layout_alv,
      st_e225_stage  TYPE ze225_staging ,    "NPOLINA ERPM2334  04/Dec/2019
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
      st_e101_stage  TYPE ze225_staging ,    "NPALLA OTCM-47267
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
      st_msg         TYPE bal_s_msg,
      st_log         TYPE bal_s_log,
      st_log_handle  TYPE balloghndl.
*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_titlebar   TYPE sy-title, " For consolidated error message
      v_tdid       TYPE tdid,     " Text ID
*** BOC for ERP-5932 BY SAYANDAS on 30-JAN-2017
      v_cre        TYPE auart    , "for credit memo
*** EOC for ERP-5932 BY SAYANDAS on 30-JAN-2017
      v_e101       TYPE salv_de_selopt_low,  "NPOLINA ERP7614  ED2K913574
*====================================================================*
* C L A S S
*====================================================================*
      o_ref_grid   TYPE REF TO cl_gui_alv_grid, " ALV List Viewer
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
      v_vkbur      TYPE vkbur, " Sales Office
      v_billblk    TYPE faksk, " Billing block in SD document
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      v_fpath      TYPE localfile,       " Local file for upload/download
      v_path_fname TYPE localfile,       " Local file for upload/download
      v_job_name   TYPE tbtcjob-jobname, " Background job name
      v_msgcnt     TYPE i,               " Messages count E225
      v_err        TYPE c,
      v_line_lmt   TYPE sytabix.         " Row Index of Internal Tables
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
DATA: v_oid        TYPE numc10.          " File Identification Number
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*====================================================================*
* C O N S T A N T S
*====================================================================*

CONSTANTS: c_x          TYPE char1    VALUE 'X',        "for marking the radiobutton as selected
           c_inv        TYPE auart    VALUE 'ZRK',      "for invoice
           c_zscr       TYPE auart    VALUE 'ZSCR',      "for Credit Memo  " CR7763 NPOLINA
           c_format     TYPE tdformat VALUE '*',        " Tag column
           c_vbbk       TYPE tdobject VALUE 'VBBK',     " Texts: Application Object
           c_vbbp       TYPE tdobject VALUE 'VBBP',     " Texts: Application Object
           c_cre        TYPE auart    VALUE 'ZCR',      "for credit memo
* Begin of Change INC0211601:20/09/2018:RBTIRUMALA:ED2K913481
           c_zofl       TYPE auart     VALUE 'ZOFL',    "Order type ZOFL
* Begin of Change INC0363877:06/03/2021:ARGADEELA:ED1K913075
           c_zcop       TYPE auart    VALUE 'ZCOP',    "Order type ZCOP
* End of Change INC0363877:06/03/2021:ARGADEELA:ED1K913075
* End of Change INC0211601:20/09/2018:RBTIRUMALA:ED2K913481
           c_sub        TYPE auart    VALUE 'ZSUB',     "for subscription
           c_rew        TYPE auart    VALUE 'ZREW',     "for return
           c_zor        TYPE auart    VALUE 'ZOR',      "for Normal Order
           c_ag         TYPE char2    VALUE 'AG',       "sold to party
           c_we         TYPE char2    VALUE 'WE',       "ship to party
           c_u          TYPE char1    VALUE 'U',        "update flag
           c_i          TYPE char1    VALUE 'I',        "update flag
           c_e          TYPE char1    VALUE 'E',        "update flag
           c_s          TYPE char1    VALUE 'S',        "update flag
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
           c_w          TYPE char1    VALUE 'W',        "update flag
           c_d1         TYPE char2    VALUE 'D1',       "Processing Status "Completed
           c_e2         TYPE char2    VALUE 'E2',       "Processing Status "File Order Error
           c_f1         TYPE char2    VALUE 'F1',       "Processing Status "File Validation Error
           c_hyphen     TYPE char1    VALUE '-',        "Hyphen Character
           c_init_date  TYPE char10   VALUE '00/00/0000', "Initial Date in Char Format
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
           c_eq         TYPE char2    VALUE 'EQ',       "update flag
           c_z1         TYPE char2    VALUE 'Z1',       "modif ID for filepath
           c_m3         TYPE char2    VALUE 'M3',       "modif ID for filepath
           c_m5         TYPE char2    VALUE 'M5',       "modif ID for filepath
           c_m7         TYPE char2    VALUE 'M7',       "modif ID for filepath
           c_m9         TYPE char2    VALUE 'M9',       "modif ID for filepath
           c_s1         TYPE char2    VALUE 'S1',       "modif ID for filepath
           c_s2         TYPE char2    VALUE 'S2',       "modif ID for filepath
           c_s3         TYPE char2    VALUE 'S3',       "modif ID for filepath
           c_s9         TYPE char2    VALUE 'S9',       "modif ID for filepath
           c_s10        TYPE char3    VALUE 'S10',      "modif ID for filepath
           c_s11        TYPE char3    VALUE 'S11',      " Modif ID for filepath
           c_s12        TYPE char3    VALUE 'S12',      " Modif ID for filepath
           c_s13        TYPE char3    VALUE 'S13',      " Modif ID for filepath
           c_s99        TYPE char3    VALUE 'S99',      " Modif ID for filepath
           c_userid     TYPE dynfnam  VALUE 'S_USERID', " Field name
           c_crd_by     TYPE dynfnam  VALUE 'S_CRD_BY', " Field name
           c_user1      TYPE dynfnam  VALUE 'S_USER1',  " Field name
           c_bstnk      TYPE dynfnam  VALUE 'S_BSTNK',  " Field name
           c_bstnk1     TYPE dynfnam  VALUE 'S_BSTNK1', " Field name
*  BOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
           c_sp         TYPE parvw    VALUE  'SP',         "Forwarding agent
* EOC CR#ERP-7712 9/25/2018 :PRABHU :  ED2K913443
           c_00010      TYPE posnr    VALUE '00010',    " Item number of the SD document
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*           c_devid      TYPE zdevid   VALUE 'E101',             " NPOLINA ED2K913574 ERP7614
           c_e101       TYPE zdevid   VALUE 'E101',       "NPALLA  OTCM-47267 09/01/2021 ED2K924398
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
           c_path       TYPE rvari_vnam   VALUE 'LOGICAL_PATH', " NPOLINA ED2K913574 ERP7614
***BOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
           c_dld        TYPE char8    VALUE 'Download',
           c_fc01       TYPE sy-ucomm VALUE 'FC01',
           c_custo      TYPE char10   VALUE 'CUSTOMER',
           c_parvw      TYPE char10   VALUE 'PARVW',
           c_kunnr      TYPE char10   VALUE 'KUNNR',
           c_vkorg      TYPE char10   VALUE 'VKORG',
           c_vtweg      TYPE char10   VALUE 'VTWEG',
           c_spart      TYPE char10   VALUE 'SPART',
           c_guebg      TYPE char10   VALUE 'GUEBG',
           c_gueen      TYPE char10   VALUE 'GUEEN',
           c_posnr      TYPE char10   VALUE 'POSNR',
           c_matnr      TYPE char10   VALUE 'MATNR',
           c_plant      TYPE char10   VALUE 'PLANT',
           c_vbeln      TYPE char10   VALUE 'VBELN',
           c_pstyv      TYPE char10   VALUE 'PSTYV',
           c_zmeng      TYPE char10   VALUE 'ZMENG',
           c_lifsk      TYPE char10   VALUE 'LIFSK',
           c_faksk      TYPE char10   VALUE 'FAKSK',
           c_abgru      TYPE char10   VALUE 'ABGRU',
           c_auart      TYPE char10   VALUE 'AUART',
           c_xblnr      TYPE char10   VALUE 'XBLNR',
           c_zlsch      TYPE char10   VALUE 'ZLSCH',
           c_bsark      TYPE char10   VALUE 'BSARK',
           c_bstn       TYPE char10   VALUE 'BSTNK',
           c_stxh       TYPE char10   VALUE 'STXH',
           c_kschl      TYPE char10   VALUE 'KSCHL',
           c_kbetr      TYPE char10   VALUE 'KBETR',
           c_ihrez      TYPE char10   VALUE 'IHREZ',
           c_ihreze     TYPE char10   VALUE 'IHREZ_E',
           c_zzpro      TYPE char10   VALUE 'ZZPROMO',
           c_kdkg4      TYPE char10   VALUE 'KDKG4',
           c_kdkg5      TYPE char10   VALUE 'KDKG5',
           c_kdkg3      TYPE char10   VALUE 'KDKG3',
           c_srid       TYPE char10   VALUE 'SRID',
           c_vkbur      TYPE char10   VALUE 'VKBUR',
           c_fkdat      TYPE char10   VALUE 'FKDAT',
           c_waerk      TYPE char10   VALUE 'WAERK',
           c_zuonr      TYPE char10   VALUE 'ZUONR',
           c_invtx      TYPE char10   VALUE 'INV_TEXT',
           c_fkimg      TYPE char10   VALUE 'FKIMG',
           c_kwmeng     TYPE char10   VALUE 'KWMENG',
           c_augru      TYPE char10   VALUE 'AUGRU',
           c_kschl2     TYPE char10   VALUE 'KSCHL2',
           c_kbetr2     TYPE char10   VALUE 'KBETR2',
           c_kschl3     TYPE char10   VALUE 'KSCHL3',
           c_kbetr3     TYPE char10   VALUE 'KBETR3',
           c_ztax       TYPE char4    VALUE 'ZTAX',       "NPOLINA ERP7763 ED2K914144
           c_tax        TYPE char4    VALUE 'TAX',        "NPOLINA ERP7763 ED2K914144
           c_kdkg2      TYPE char10   VALUE 'KDKG2',      "NPOLINA ERPM4543 23/Oct/2019 ED2K916556
           c_e225       TYPE zdevid   VALUE 'E225',       "NPOLINA ERPM2334 05/Dec/2019
* BOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919704 *
           c_ortype     TYPE auart    VALUE 'ZOR',        " Lahiru
           c_itmcat1    TYPE pstyv    VALUE 'ZTXD', "
           c_itmcat2    TYPE pstyv    VALUE 'ZTXP',
* EOC by Lahiru on 09/22/2020 for OTCM-4390 with ED2K919704 *
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
           c_zzconstart TYPE char10 VALUE  'ZZCONSTART',     " Content Start Date Override
           c_zzconend   TYPE char08 VALUE  'ZZCONEND',       " Content End Date Override
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919818 *
***EOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
*           c_vlaufk     TYPE char6 VALUE 'VLAUFK',      "Validity period category of contract
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923278 *
           c_vlaufz     TYPE char6 VALUE 'VLAUFZ'.      "Validity period of contract
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* SOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311
DATA: v_posnr       TYPE posnr,
      v_fplnr       TYPE fplnr,
      it_fpla       TYPE TABLE OF fplavb,
      it_fpla_old   TYPE TABLE OF fplavb,
      it_fplt       TYPE TABLE OF fpltvb,
      it_fplt_old   TYPE TABLE OF fpltvb,
      wa_output     TYPE ty_output_x,
      wa_output_chg TYPE ty_output_x_chg,
      v_error       TYPE char1,           "NPOLINA ERPM4543 24/Oct/2019
      v_error_file  TYPE char1.           "NPALLA

CONSTANTS:c_vaktsch TYPE char10     VALUE 'VAKTSCH',    " Action
          c_vasda   TYPE char10     VALUE 'VASDA',      " Date for Action
          c_perio   TYPE char10     VALUE 'PERIO',      " Rule for Origin of Next Billing/Invoice Date
          c_autte   TYPE char10     VALUE 'AUTTE',      " In Advance
          c_peraf   TYPE char10     VALUE 'PERAF',      " Rule for Determination of a Deviating Billing/Invoice Date
          c_zsbp    TYPE auart      VALUE 'ZSBP',        "for subscription
          c_va42    TYPE sy-tcode   VALUE 'VA42'.        "for subscription

DATA: i_bdcdata TYPE TABLE OF bdcdata,
      i_messtab TYPE TABLE OF bdcmsgcoll .   " messages of call transaction
* EOC by NPOLINA 01/25/2019 ERP7822 : ED2K914311

* SOC by NPOLINA 28/June/2019 ED2K915483 DM1913
DATA:v_augru TYPE augru.
CONSTANTS:
  c_devid_e209 TYPE zdevid      VALUE 'E209'.
* EOC by NPOLINA 28/June/2019 ED2K915483 DM1913

TYPE-POOLS:   ixml.  " XML Library Types
TYPES: BEGIN OF ty_xml_line,  " Structure for xml line
         data(255) TYPE x,
       END OF ty_xml_line.
DATA:obj_ixml          TYPE REF TO   if_ixml,
     obj_streamfactory TYPE REF TO   if_ixml_stream_factory,
     obj_ostream       TYPE REF TO   if_ixml_ostream,
     obj_renderer      TYPE REF TO   if_ixml_renderer,
     obj_document      TYPE REF TO   if_ixml_document,
     obj_element_root  TYPE REF TO   if_ixml_element,
     obj_ns_attribute  TYPE REF TO   if_ixml_attribute,
     obj_element_pro   TYPE REF TO   if_ixml_element,
     obj_worksheet     TYPE REF TO   if_ixml_element,
     obj_table         TYPE REF TO   if_ixml_element,
     obj_column        TYPE REF TO   if_ixml_element,
     obj_row           TYPE REF TO   if_ixml_element,
     obj_cell          TYPE REF TO   if_ixml_element,
     obj_data          TYPE REF TO   if_ixml_element,
     v_value           TYPE          string,
     obj_styles        TYPE REF TO   if_ixml_element,
     obj_style         TYPE REF TO   if_ixml_element,
     obj_style1        TYPE REF TO   if_ixml_element,
     obj_style2        TYPE REF TO   if_ixml_element,
     obj_format        TYPE REF TO   if_ixml_element,
     obj_border        TYPE REF TO   if_ixml_element,
     i_xml_table       TYPE TABLE OF ty_xml_line,
     st_xml            TYPE          ty_xml_line,
     gt_fcat           TYPE          lvc_t_fcat,
     gr_credat         TYPE          fkk_rt_chdate,
     c_att             TYPE e070a-attribute VALUE 'SAP_CTS_PROJECT'.

* Begin by AMOHAMMED on 10/29/2020 TR # ED2K920134
TYPES: BEGIN OF ty_dbt_memo_crt,
         sel,
         identifier TYPE posnr_va,   " Identifier
         customer   TYPE kunnr,      " Customer Number
         parvw      TYPE parvw,      " Partner Function
         partner    TYPE kunnr,      " Customer Number
         vkorg      TYPE vkorg,      " Sales Organization
         vtweg      TYPE vtweg,      " Distribution Channel
         spart      TYPE spart,      " Division
         auart      TYPE auart,      " Sales Document Type
         xblnr      TYPE xblnr_v1,   " Reference Document Number
         zlsch      TYPE schzw_bseg, " Payment Method
         augru      TYPE augru,      " Order reason (reason for the business transaction)
         vbeln      TYPE vbeln_vf,   " Contract Document
         posnr      TYPE posnr_va,   " Contract item
         posnr1     TYPE posnr_va,   " Target item number
         matnr      TYPE matnr,      " Material Number
         plant      TYPE werks_d,    " Plant
         fkimg      TYPE fkimg,      " Target Quantity
         stxh       TYPE char50,     " Name
         kschl      TYPE kschl,      " Condition Type
         kbetr      TYPE kbetr,      " Rate (condition amount or percentage)
         waers      TYPE waers,      " Currency " by AMOHAMMED on 12/8/2020 TR # ED2K920719
         kschl2     TYPE kschl,      " Condition Type
         kbetr2     TYPE kbetr,      " Condition value
         kschl3     TYPE kschl,      " Condition Type
         kbetr3     TYPE kbetr,      " Condition value
         ihrez      TYPE ihrez,      " Your Reference
         kdkg3      TYPE kdkg3,      " Customer condition group 3
         vkbur      TYPE vkbur,      " Sales Office
         bstnk      TYPE bstnk,      " Customer purchase order number
         bsark      TYPE bsark,      " Customer purchase order type
         pstyv      TYPE pstyv,      " Sales document item category
         tax        TYPE kbetr,      " Tax amount mandatory for ZSCR NPOLINA ERP7763 ED2K914144
         uepos      TYPE uepos,      "Higher level Item
       END OF ty_dbt_memo_crt,
       tt_dbt_memo_crt TYPE STANDARD TABLE OF ty_dbt_memo_crt " Table type
                                 INITIAL SIZE 0.
DATA : i_final_dbm_crt TYPE STANDARD TABLE OF ty_dbt_memo_crt " Internal table
                            INITIAL SIZE 0,
       v_dbt           TYPE auart, "for debit memo
       v_cnt           TYPE vbtyp, "for debit memo
       v_cntrct_check  TYPE c,
       v_condtyp_chk   TYPE c,
       v_doctype_check TYPE c.
CONSTANTS : c_zadr   TYPE auart    VALUE 'ZADR',     " for Debit Memo
            c_posnr1 TYPE char10   VALUE 'POSNR1',   " Target Item Number
            c_zmpr   TYPE kschl    VALUE 'ZMPR',     " Condition type
* End by AMOHAMMED on 10/29/2020 TR # ED2K920134
            c_waers  TYPE char10   VALUE 'WAERS'.    " Currency " by AMOHAMMED on 12/8/2020 TR # ED2K920719

* BOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *
TYPES: BEGIN OF ty_dbt_memo_excel,
* BOC by Lahiru on 05/28/2021 for OTCM-44200 with ED2K923617 *
         identifier TYPE string,     " Identifier
* EOC by Lahiru on 05/28/2021 for OTCM-44200 with ED2K923617 *
         customer   TYPE string,     " Customer Number
         parvw      TYPE string,     " Partner Function
         vkorg      TYPE vkorg,      " Sales Organization
         vtweg      TYPE vtweg,      " Distribution Channel
         spart      TYPE spart,      " Division
*         acc_ref    TYPE xblnr_v1,   " Accounting reference "OTCM-44200
         zlsch      TYPE schzw_bseg, " Payment Method
         "SOC of MRAJKUMAR OTCM-44200
*         vbeln      TYPE vbeln_va,   " Contract Document
         vbeln      TYPE string,   " Contract Document
         "EOC of MRAJKUMAR OTCM-44200
*         stxh       TYPE char50,     " Stxh of type CHAR200  "OTCM-44200
         bstnk      TYPE bstnk,      " Customer purchase order number
       END OF ty_dbt_memo_excel.

TYPES: BEGIN OF ty_vbak_vbap,
         vbeln TYPE vbeln_va,
         augru TYPE augru,
         waerk TYPE waerk,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         spart TYPE spart,
         vkbur TYPE vkbur,
         knumv TYPE knumv,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
         abgru TYPE abgru,
         werks TYPE werks_ext,
         uepos TYPE uepos,
         zmeng TYPE dzmeng,
       END OF ty_vbak_vbap,
       tt_vbak_vbap TYPE STANDARD TABLE OF ty_vbak_vbap " Table type
                             INITIAL SIZE 0.

TYPES : BEGIN OF ty_dbt_vbpa,
          vbeln TYPE vbeln,
          parvw TYPE parvw,
          kunnr TYPE kunnr,
        END OF ty_dbt_vbpa,
        tt_dbt_vbpa TYPE STANDARD TABLE OF ty_dbt_vbpa
                    INITIAL SIZE 0.

TYPES : BEGIN OF ty_dbt_konv,
          knumv TYPE knumv,
          kposn TYPE kposn,
          kschl TYPE kscha,
          kbetr TYPE kbetr,
        END OF ty_dbt_konv,
        tt_dbt_konv TYPE STANDARD TABLE OF ty_dbt_konv
                    INITIAL SIZE 0.

TYPES : BEGIN OF ty_dbt_knvv,
          kunnr TYPE kunnr,
          vkorg TYPE vkorg,
          vtweg TYPE vtweg,
          spart TYPE spart,
          waers TYPE waers_v02d,
        END OF ty_dbt_knvv,
        tt_dbt_knvv TYPE STANDARD TABLE OF ty_dbt_knvv
              INITIAL SIZE 0.

TYPES : BEGIN OF ty_dbt_vbfa,
          vbeln TYPE vbeln_va,
          auart TYPE auart,
          posnr TYPE posnr_va,
          abgru TYPE abgru,
        END OF ty_dbt_vbfa,
        tt_dbt_vbfa TYPE STANDARD TABLE OF ty_dbt_vbfa
              INITIAL SIZE 0.

TYPES : BEGIN OF ty_dbt_vbfa_l,
          vbelv   TYPE vbeln_von,
          vbeln   TYPE vbeln_nach,
          vbtyp_n TYPE vbtyp_n,
        END OF ty_dbt_vbfa_l.

DATA : i_vbak_vbap     TYPE STANDARD TABLE OF ty_vbak_vbap INITIAL SIZE 0,
       i_dbt_vbpa      TYPE STANDARD TABLE OF ty_dbt_vbpa INITIAL SIZE 0,
       i_dbt_konv      TYPE STANDARD TABLE OF ty_dbt_konv INITIAL SIZE 0,
       i_dbt_knvv      TYPE STANDARD TABLE OF ty_dbt_knvv INITIAL SIZE 0,
       i_dbt_vbak_vbfa TYPE STANDARD TABLE OF ty_dbt_vbfa INITIAL SIZE 0,
       i_dbt_vbfa_l    TYPE STANDARD TABLE OF ty_dbt_vbfa_l INITIAL SIZE 0,
       i_dbt_duplicate TYPE STANDARD TABLE OF ty_dbt_memo_crt INITIAL SIZE 0.

DATA : i_dbt_memo_excel TYPE STANDARD TABLE OF ty_dbt_memo_excel INITIAL SIZE 0. " Internal table for excel file

CONSTANTS : c_accref        TYPE xblnr_v1   VALUE 'ACC_REF',
            c_identifier    TYPE char10     VALUE 'IDENTIFIER',
            c_errtype       TYPE char1      VALUE 'E',
            c_debitmemo     TYPE rvari_vnam VALUE 'DEBIT_MEMO',
            c_doctype       TYPE rvari_vnam VALUE 'DOC_TYP',
            c_srno_1        TYPE tvarv_numb VALUE '0001',
            c_srno_2        TYPE tvarv_numb VALUE '0002',
            c_parvw_dbt     TYPE rvari_vnam VALUE 'PARVW',
            c_part_role_dbt TYPE rvari_vnam VALUE 'PART_ROLE',
            c_header        TYPE posnr      VALUE '000000',
            c_bsark_dbt     TYPE rvari_vnam VALUE 'BSARK',
            c_zqtc_r2       TYPE arbgb      VALUE 'ZQTC_R2'.

DATA : v_bsark         TYPE bsark,       " Cutomer PO type
       v_ord_reason    TYPE augru,       " Order reason
       v_ref_doc_type  TYPE vbtyp_n,     " Reference doc category
       v_exist_zadr    TYPE vbeln_va,    " ZADR doc no
       v_duplicate_cnt TYPE char1,      " Duplicate order flag
       v_log_index     TYPE i.
* EOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *

*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
* Get Partner Function
TYPES: BEGIN OF ty_parvw,
         parvw TYPE parvw,
       END OF  ty_parvw.
DATA: i_parvw  TYPE STANDARD TABLE OF ty_parvw.
* Get Sales Organization (TVKO)
TYPES: BEGIN OF ty_vkorg,
         vkorg TYPE vkorg,
       END OF  ty_vkorg.
DATA: i_vkorg  TYPE STANDARD TABLE OF ty_vkorg.
* Get Distribution Channel (TVTW)
TYPES: BEGIN OF ty_vtweg,
         vtweg TYPE vtweg,
       END OF  ty_vtweg.
DATA: i_vtweg  TYPE STANDARD TABLE OF ty_vtweg.
* Get Division (TSPA)
TYPES: BEGIN OF ty_spart,
         spart TYPE spart,
       END OF  ty_spart.
DATA: i_spart  TYPE STANDARD TABLE OF ty_spart.
* Get Sales Office (TVBUR)
TYPES: BEGIN OF ty_vkbur,
         vkbur TYPE vkbur,
       END OF  ty_vkbur.
DATA: i_vkbur  TYPE STANDARD TABLE OF ty_vkbur.
* Get Sales Document Type (TVAK)
TYPES: BEGIN OF ty_auart,
         auart TYPE auart,
       END OF  ty_auart.
DATA: i_auart  TYPE STANDARD TABLE OF ty_auart.
* Get Sales Document Type (T176)
TYPES: BEGIN OF ty_bsark,
         bsark TYPE bsark,
       END OF  ty_bsark.
DATA: i_bsark  TYPE STANDARD TABLE OF ty_bsark.
* Get Material (MARA)
TYPES: BEGIN OF ty_matnr,
         matnr TYPE matnr,
       END OF  ty_matnr.
TYPES: tt_matnr TYPE STANDARD TABLE OF ty_matnr.
DATA: i_matnr  TYPE STANDARD TABLE OF ty_matnr.
* Get Material Group 5
TYPES: BEGIN OF ty_mvke,
         matnr TYPE matnr,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         mvgr5 TYPE mvgr5,
       END OF ty_mvke.
TYPES: tt_mvke TYPE STANDARD TABLE OF ty_mvke.
DATA: i_mvke  TYPE STANDARD TABLE OF ty_mvke.
* Get Customer.
TYPES: BEGIN OF ty_customer,
         partner TYPE bu_partner,
       END OF ty_customer.
TYPES: tt_customer TYPE STANDARD TABLE OF ty_customer.
DATA: i_customer TYPE STANDARD TABLE OF ty_customer.
* Get Vendor.
TYPES: BEGIN OF ty_vendor,
         lifnr TYPE lifnr,
       END OF ty_vendor.
TYPES: tt_vendor TYPE STANDARD TABLE OF ty_vendor.
DATA: i_vendor TYPE STANDARD TABLE OF ty_vendor.
* Ranges for Material group 5
TYPES: BEGIN OF ty_mvgr5,       "for Material group 5
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE mvgr5,      " Material group 5
         high TYPE mvgr5,      " Material group 5
       END OF ty_mvgr5.
DATA: ir_mvgr5 TYPE STANDARD TABLE OF ty_mvgr5.
* Ranges for Material group 5
TYPES: BEGIN OF ty_row_txt,       "for Material group 5
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE salv_de_selopt_low,         " Text
         high TYPE salv_de_selopt_high,        " Text
       END OF ty_row_txt.
DATA: ir_row_txt TYPE STANDARD TABLE OF ty_row_txt.

CONSTANTS: c_zq         TYPE inri-nrrangenr VALUE 'ZQ',
           c_zqtc_uplid TYPE inri-object    VALUE 'ZQTC_UPLID',
           c_quantity   TYPE inri-quantity  VALUE '1'.

*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
