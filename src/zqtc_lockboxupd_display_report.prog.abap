*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_LOCKBOXUPD_DISPLAY_REPORT
* PROGRAM DESCRIPTION: To Display Lockbox ZQTCLOCKBOX_UPD Table Data
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 18/03/2019
* OBJECT ID: INC0235034
* TRANSPORT NUMBER(S): ED1K909832
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911226
* REFERENCE NO:ERPM-3463
* DEVELOPER:GKAMMILI
* DATE:  10/25/2019
* DESCRIPTION:Adding two fields(contract and billing document) to report
*             output
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911298
* REFERENCE NO:ERPM-3463
* DEVELOPER:GKAMMILI
* DATE:  11/07/2019
* DESCRIPTION:Adding Reason code as select options in selection screen and
*             variant saving option in the output
*----------------------------------------------------------------------*
REPORT zqtc_lockboxupd_display_report NO STANDARD PAGE HEADING
                                      LINE-COUNT 65
                                      LINE-SIZE 132.

*---------------------------------------------------------------------*
*                        I N C L U D E S                              *
*---------------------------------------------------------------------*

*top include
INCLUDE zqtc_lockboxupd_disp_top.
*include for selection screen
INCLUDE zqtc_lockboxupd_disp_scr.
*include for form routines
INCLUDE zqtc_lockboxupd_disp_f01.

*-- BOI by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463
*---------------------------------------------------------------------*
*  AT SELECTION-SCREEN ON VALUE-REQUEST                               *
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_rcode-low.
  PERFORM f_f4 USING s_rcode-low.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_rcode-high.
  PERFORM f_f4 USING s_rcode-high.
*-- EOI by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463
*---------------------------------------------------------------------*
*             S T A R T  -  O F  -  S E L E C T I O N                 *
*---------------------------------------------------------------------*
START-OF-SELECTION.

*To get the ZQTCLOCKBOX_UPD Data based on Claring Date(AUGDT),
*Company Code (BUKRS), Document No(BELNR) and Customer No(KUNNR)
  PERFORM f_get_table_data.
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
*-- Process the internal tables for preparing the final internal table
  PERFORM f_process_data.
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463

*---------------------------------------------------------------------*
*             E N D  -  O F  -  S E L E C T I O N                     *
*---------------------------------------------------------------------*
END-OF-SELECTION.

*To Prepare field Catelog
  PERFORM f_filed_catelog.
*To Display deletion log in ALV LIST
  PERFORM f_alv_list_display.
