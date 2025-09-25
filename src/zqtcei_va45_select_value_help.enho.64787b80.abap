"Name: \PR:SD_SALES_DOCUMENT_VA45\IC:SD_SALES_DOCUMENT_VA45\SE:END\EI
ENHANCEMENT 0 ZQTCEI_VA45_SELECT_VALUE_HELP.
*Enhancement details
* Developer : Prabhu (PTUFARAM)
* CHANGE DESCRIPTION : Layout input parameter on selection screen
*                      ZQTC_VA45
* CREATION DATE:  5/15/2019
* OBJECT ID:  DM-1791
* TRANSPORT NUMBER(S): ED2K915044
*----------------------------------------------------------------------*
*--*Value help for Layout field on selection screen
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
INCLUDE zqtcn_value_help_layout if FOUND.
ENDENHANCEMENT.
