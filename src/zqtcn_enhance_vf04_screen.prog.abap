*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ENHANCE_VF04_SCREEN (Include)
* PROGRAM DESCRIPTION: Add Selection Screen Fields in VF04 transaction
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/11/2019
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ES1K900339 / ES1K900345
* REFERENCE NO:  AMS_SPS_Upg_2019_VF04
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* DATE:          06/25/2019
* DESCRIPTION:   Upgrade Fix as SAP has introduced select option S_VKBUR
*                Hence changing the Select Option to S_ZVKBUR
*----------------------------------------------------------------------*
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK z1 WITH FRAME TITLE v_textb1.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 28.
*BOC - AMS_SPS_Upg_2019_VF04 - NPALLA - 06/25/2019 - ES1K900339
SELECT-OPTIONS:
*  s_vkbur FOR vkdfi-zzvkbur.                         "Sales Office
  z_vkbur FOR vkdfi-zzvkbur.                          "Sales Office
*SELECTION-SCREEN COMMENT 1(15) v_textf1 FOR FIELD s_vkbur.  "--
SELECTION-SCREEN COMMENT 1(15) v_textf1 FOR FIELD z_vkbur.   "++
*EOC - AMS_SPS_Upg_2019_VF04 - NPALLA - 06/25/2019 - ES1K900339
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK z1.
