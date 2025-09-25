*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_POP_UP_TO_INFORMTOP
* PROGRAM DESCRIPTION:Show Pop up ( TOP include )
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S)ED2K903147
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
FUNCTION-POOL zqtc_pop_up_to_inform.        "MESSAGE-ID ..

DATA v_text TYPE char100.
DATA v_ok_code TYPE char4.
DATA ok_code TYPE sy-ucomm.
CONSTANTS: c_tel  TYPE char1 VALUE '2',
           c_mail TYPE char1 VALUE '1'.
* INCLUDE LZQTC_POP_UP_TO_INFORMD...         " Local class definition
