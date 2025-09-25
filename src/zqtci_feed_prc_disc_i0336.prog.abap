*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCI_FEED_PRC_DISC_I0336
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Anirban Saha
* CREATION DATE:       05/01/2017
* OBJECT ID:           I0336
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917919
* REFERENCE NO: ERPM-6882
* DEVELOPER:    AMOHAMMED
* DATE:         04/07/2020
* DESCRIPTION:  1. Only in the CSV file should say "No of Issue"
*                  instead of No Copies in the Header
*               2. Add Titles for components in addition to Material
*                  number in separate new column as specified in example
*               3. For titles that are included in a Multi-journal
*                  package if they are not already shown on the price
*                  list on their own, we need to make sure that the
*                  individual component titles are also shown on the price list.
*               4. Rolling title status. This is needed for XLS view,
*                  to add a note or comment indicating when a title is rolling.
*----------------------------------------------------------------------*
REPORT zqtci_feed_prc_disc_i0336.

INCLUDE ZQTCN_FEED_PRC_DISC_I0336_TOP IF FOUND.
INCLUDE ZQTCN_FEED_PRC_DISC_I0336_SEL IF FOUND.
INCLUDE ZQTCN_FEED_PRC_DISC_I0336_SUB IF FOUND.

INITIALIZATION.
* Populate Default values of Selection Screen fields
  PERFORM f_default_values.

START-OF-SELECTION.
  CALL SCREEN 100.
