*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ENHANCE_VF04_SCREEN_TXT (Include)
* PROGRAM DESCRIPTION: Maintain Selection Texts for VF04 transaction
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/11/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Get Selection Screen texts
PERFORM f_sel_screen_texts IN PROGRAM zqtce_sdbilldl IF FOUND
                           CHANGING v_textb1
                                    v_textf1.
