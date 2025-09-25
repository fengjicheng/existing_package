*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_INVRECON_DEL_REPORT
* PROGRAM DESCRIPTION: To Delete Data from Inventory Recon table
*                      ZQTC_INVEN_RECON based on
*                      Adjustment Type
*                      Material No
*                      Date
*                      Plant
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 21/03/2019
* OBJECT ID: RITM0126734
* TRANSPORT NUMBER(S): ED1K909853
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtc_invrecon_del_report NO STANDARD PAGE HEADING
                                      LINE-COUNT 65
                                      LINE-SIZE 132.

*---------------------------------------------------------------------*
*                        I N C L U D E S                              *
*---------------------------------------------------------------------*

*top include
INCLUDE zqtcn_invrecon_del_top.
*include for selection screen
INCLUDE zqtcn_invrecon_del_scr.
*include for form routines
INCLUDE zqtcn_invrecon_del_f01.

*---------------------------------------------------------------------*
*             S T A R T  -  O F  -  S E L E C T I O N                 *
*---------------------------------------------------------------------*
START-OF-SELECTION.

* To get the ZQTC_INVEN_RECON Data based on Adjustment Type(ZADJTYP),
* Material No(MATNR), Transactional Date(ZDATE) and Delivery Plant (WERKS)
  PERFORM f_get_table_data.

*---------------------------------------------------------------------*
*             E N D  -  O F  -  S E L E C T I O N                     *
*---------------------------------------------------------------------*
END-OF-SELECTION.

*To Prepare field Catelog
  PERFORM f_filed_catelog.
*To Display deletion log in ALV LIST
  PERFORM f_alv_list_display.
