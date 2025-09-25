*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_REPAIR_ADDRESS
* PROGRAM DESCRIPTION: This report uses a sales document order as input.
*                      The incorrect addresses in the specified document
*                      will be set to the standard address coming from
*                      customer master data. It is possible to maintain/change
*                      such a document afterwards.
*                      This report has a testflag. Please test the report
*                      carefully with this flag before changing data.
*                      - per Note 2713240 (Z_REPAIR_ADRNR_1)
* DEVELOPER:           Nikhiesh Palla (NPALLA).
* CREATION DATE:       09/13/2019
* OBJECT ID:           Z Program per OSS Note - 2713240
* TRANSPORT NUMBER(S): ED1K910781
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*
REPORT zqtcr_repair_address.


*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcr_repair_address_top.

*Include for Selection Screen
INCLUDE zqtcr_repair_address_sel.

*Include for Subroutines
INCLUDE zqtcr_repair_address_f01.



*====================================================================*
* Start of Selection
*====================================================================*
START-OF-SELECTION.

* Select Data.
  PERFORM select_data.

*  Update Address Details
  PERFORM update_address.

*====================================================================*
* End of Selection
*====================================================================*
END-OF-SELECTION.

* Display output details
  PERFORM output_details.
