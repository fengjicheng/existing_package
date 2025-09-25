"Name: \PR:SD_SALES_DOCUMENT_VIEW\IC:SD_SALES_DOCUMENT_VIEW\SE:END\EI
ENHANCEMENT 0 ZQTCEI_VA05_SELECT_VALUE_HELP.
*Enhancement details
* Developer : NPOLINA
* CHANGE DESCRIPTION : Layout input parameter on selection screen
*                      ZQTC_VA05
* CREATION DATE:  8/13/2019
* OBJECT ID:  DM-7836
* TRANSPORT NUMBER(S): ED2K915777
*----------------------------------------------------------------------*
*--*Value help for Layout field on selection screen
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
INCLUDE zqtcn_value_help_layout_va05 if FOUND.
ENDENHANCEMENT.
