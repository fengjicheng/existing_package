*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SO_PBO_MODULES_E060
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SCREEN_MODE_VBAK (Include)
* PROGRAM DESCRIPTION: For TCode VA03 all fields to be in Display Mode
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTRN_SCREEN_MODE_VBAK
*&---------------------------------------------------------------------*
MODULE zzqtc_vbak_scrn_mode OUTPUT.

  IF t180-trtyp = chara.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'GR1'
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF t180-trtyp = 'A'
ENDMODULE.

*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SCREEN_MODE_VBAP(Include)
* PROGRAM DESCRIPTION: For TCode VA03 all fields to be in Display Mode
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913932
* REFERENCE NO: CR#7480
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 26-Nov-2018
* DESCRIPTION: Addition of new fields: 'Cover Year', 'Cover Month' in
* VA01/VA02/VA03
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTRN_SCREEN_MODE_VBAP
*&---------------------------------------------------------------------*
MODULE zzqtc_vbap_scrn_mode OUTPUT.

  IF t180-trtyp = chara.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'GR1'
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF t180-trtyp = 'A'

*** BOC: CR#7480  KKRAVURI20181126  ED2K913932
  IF sy-tcode <> 'VA01' AND sy-tcode <> 'VA02' AND
     sy-tcode <> 'VA03'.
    LOOP AT SCREEN.
      IF screen-name = 'VBAP-ZZCOVRYR' OR screen-name = 'VBAP-ZZCOVRMT'.
        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF t180-trtyp = 'A'
*** EOC: CR#7480  KKRAVURI20181126  ED2K913932
* Begin VMAMILLAPA on 26/09/2023
  INCLUDE zqtcn_modify_add_data_scrn IF FOUND.
* End VMAMILLAPA on 26/09/2023
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZZSTATUS_8459  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zzstatus_8459 OUTPUT.

  SET PF-STATUS 'STATUS'.
ENDMODULE.

*----------------------------------------------------------------------*
* PROGRAM NAME: zzqtc_vbak_zzlicgrp_display (Module name)
* PROGRAM DESCRIPTION: This module will be called from ADDITIONAL TAB 2
*                      It will make license group field dis-appear when
*                      document type is not subscription order
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID: E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
MODULE zzqtc_vbak_zzlicgrp_display OUTPUT.

  DATA : lv_flag_a TYPE flag.  " Flag

  CALL FUNCTION 'ZQTC_ORDER_TYPE_DETERMINE'
    EXPORTING
      im_auart       = vbak-auart
    IMPORTING
      ex_active_flag = lv_flag_a.

  IF lv_flag_a NE abap_true.

    LOOP AT SCREEN.
      IF screen-group2 = 'GR2'.
        screen-input = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'GR1'
    ENDLOOP. " LOOP AT SCREEN

  ENDIF.

ENDMODULE.
