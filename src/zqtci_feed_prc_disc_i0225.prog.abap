*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCI_FEED_PRC_DISC_I0225
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       04/12/2017
* OBJECT ID:           I0225
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 490
* DEVELOPER: Writtick Roy
* DATE:  05/25/2017
* DESCRIPTION: 1. Update calculation logic for Librarian XLSX file to
* reflect list and net price (after ZSD1 discount/surcharge applied).
*              2. List Price should come from specific Condition table
* (A911 or A913) depending on Relationship Category from ZSD1
*              3. Populate 2 additional IDOC fields for Soceity Number
* and Relationship Category
*              4. Retrieve Material Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 523
* DEVELOPER: Writtick Roy
* DATE:  06/22/2017
* DESCRIPTION: 1. Add All ISSNs in the XML / IDOC data (Print ISSN,
* Online ISSN, Print+Online ISSN)
*              2. Add Indicator for Multi-Journal Products
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908, ED2K907257
* REFERENCE NO:  CR# 565
* DEVELOPER: Writtick Roy
* DATE:  07/08/2017
* DESCRIPTION: 1. Additional Exclusion Criteria - "Pricing Only" and
* "Pricing and Products".
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912278
* REFERENCE NO:  CR#6341
* DEVELOPER: Rahul Tripathi
* DATE:  06/14/2018
* DESCRIPTION: Net Price for Multiyear  discount cond type ZMYS
*              "CR6341 RTR20180414 ED2K912278
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917960
* REFERENCE NO: ERPM-6898
* DEVELOPER:    AMOHAMMED & Prabhu
* DATE:         04/07/2020
* DESCRIPTION:  1. Rolling Title Status. This change is required only
*                  for Librararian XLSX view
*               2. This change is required in JPS XML file, below is
*                  the sample download file in EQ2, when ever the
*                  Customer group is 01 in Column I, Keep only the FTE
*                  range 1 and remove the lines with >1
*               3. Remove FTE Small if customer group is 1
*----------------------------------------------------------------------*
REPORT zqtci_feed_prc_disc_i0225.

INCLUDE zqtcn_feed_prc_disc_i0225_top IF FOUND.
INCLUDE zqtcn_feed_prc_disc_i0225_sel IF FOUND.
INCLUDE zqtcn_feed_prc_disc_i0225_sub IF FOUND.

INITIALIZATION.
* Populate Default values of Selection Screen fields
  PERFORM f_default_values.

* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
* Rel Cat/Soc No (Without Material)
AT SELECTION-SCREEN ON p_rs_wm1.
* Validate File Path
  PERFORM f_validate_filepath USING p_rs_wm1.
* Rel Cat/Soc No (With Material)
AT SELECTION-SCREEN ON p_rc_sn1.
* Validate File Path
  PERFORM f_validate_filepath USING p_rc_sn1.
* Soc No/Prc Typ (With Material)
AT SELECTION-SCREEN ON p_sn_pt1.
* Validate File Path
  PERFORM f_validate_filepath USING p_sn_pt1.
* Rel Category (With Material)
AT SELECTION-SCREEN ON p_rltyp1.
* Validate File Path
  PERFORM f_validate_filepath USING p_rltyp1.
* Price Type (With Material)
AT SELECTION-SCREEN ON p_prtyp1.
* Validate File Path
  PERFORM f_validate_filepath USING p_prtyp1.

* Rel Cat/Soc No (Without Material)
AT SELECTION-SCREEN ON p_rs_wm2.
* Validate File Path
  PERFORM f_validate_filepath USING p_rs_wm2.
* Rel Cat/Soc No (With Material)
AT SELECTION-SCREEN ON p_rc_sn2.
* Validate File Path
  PERFORM f_validate_filepath USING p_rc_sn2.
* Soc No/Prc Typ (With Material)
AT SELECTION-SCREEN ON p_sn_pt2.
* Validate File Path
  PERFORM f_validate_filepath USING p_sn_pt2.
* Rel Category (With Material)
AT SELECTION-SCREEN ON p_rltyp2.
* Validate File Path
  PERFORM f_validate_filepath USING p_rltyp2.
* Price Type (With Material)
AT SELECTION-SCREEN ON p_prtyp2.
* Validate File Path
  PERFORM f_validate_filepath USING p_prtyp2.

* Rel Cat/Soc No (Without Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rs_wm1.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rs_wm1.
* Rel Cat/Soc No (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rc_sn1.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rc_sn1.
* Soc No/Prc Typ (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_sn_pt1.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_sn_pt1.
* Rel Category (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rltyp1.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rltyp1.
* Price Type (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_prtyp1.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_prtyp1.

* Rel Cat/Soc No (Without Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rs_wm2.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rs_wm2.
* Rel Cat/Soc No (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rc_sn2.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rc_sn2.
* Soc No/Prc Typ (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_sn_pt2.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_sn_pt2.
* Rel Category (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rltyp2.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_rltyp2.
* Price Type (With Material)
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_prtyp2.
* Search Help for File Path
  PERFORM f_f4_help_filepath CHANGING p_prtyp2.
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908

START-OF-SELECTION.
* Fetch required details
  PERFORM f_process_details.
