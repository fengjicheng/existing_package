FUNCTION-POOL ZQTC_LICGRP               . "MESSAGE-ID ...

* INCLUDE LZQTC_LICGRPD...                   " Local class definition
*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_LICGRPTOP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move LICENSE
*                      GROUP into the sales header workaerea VBAK
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*

CONSTANTS :
  c_auart TYPE rvari_vnam VALUE 'AUART',   " document type
  c_type  TYPE rvari_vnam VALUE 'TYPE'.    " lic grp
