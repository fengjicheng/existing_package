*&---------------------------------------------------------------------*
*&  Include  ZQTCN_LICENSE_GROUP_DETERMINE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_LICENSE_GROUP_DETERMINE (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move LICENSE
*                      GROUP into the sales header workaerea VBAK
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID:       E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K907273
* REFERENCE NO:  Defect 2974
* DEVELOPER: Anriban Saha
* DATE:  2017-07-13
* DESCRIPTION: Restrict the select query to be executed once
*              for the same customer
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K912831
* REFERENCE NO: ERP-6117
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-07-30
* DESCRIPTION: Use Header Ship-to Party instead of Sold-to Party for
*              determining License Group
*----------------------------------------------------------------------*
DATA :
  lv_flag       TYPE char1,        " Flag
  lv_idnumber   TYPE bu_id_number, " ID number
  lv_zlgrp      TYPE bu_id_type,   " ID type
  lv_vbak_kunnr TYPE kunnr.        " Customer

*Begin of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
TYPES: BEGIN OF lty_but0id,
         partner  TYPE bu_partner,   " Business Partner Number
         type     TYPE bu_id_type,
         idnumber TYPE bu_id_number, " Identification Number
       END   OF lty_but0id.

STATICS: li_but0id  TYPE SORTED TABLE OF lty_but0id
                    WITH UNIQUE KEY partner type.
DATA : lst_but0id TYPE lty_but0id.
*End of Add-Anirban-07.13.2017-ED2K907273-Defect 2974

* Begin of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
* Re-determine License Group if Ship-to Party is changed
IF rv02p-weupd EQ abap_true. " Ship-to Party is changed
  CLEAR: vbak-zzlicgrp.
ENDIF. " IF rv02p-weupd EQ abap_true
* End   of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831

* This will determine license group from cistomer number
* present in sales order header (VBAK-KUNNR) for partcular
* order type maintain in Z chanstant table
IF vbak-zzlicgrp IS INITIAL.

  CALL FUNCTION 'ZQTC_ORDER_TYPE_DETERMINE'
    EXPORTING
      im_auart       = vbak-auart
    IMPORTING
      ex_active_flag = lv_flag
      ex_licgrp      = lv_zlgrp.
* Begin of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
* IF lv_flag EQ abap_true AND vbak-kunnr IS NOT INITIAL.
* End   of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
* Begin of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
  IF lv_flag EQ abap_true AND kuwev-kunnr IS NOT INITIAL.
* End   of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831

*Begin of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
    CLEAR: lst_but0id.
    READ TABLE li_but0id INTO lst_but0id
*        Begin of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
*        WITH KEY partner = vbak-kunnr
*        End   of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
*        Begin of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
         WITH KEY partner = kuwev-kunnr
*        End   of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
         BINARY SEARCH.
    IF sy-subrc NE 0.
*End of Add-Anirban-07.13.2017-ED2K907273-Defect 2974

* assign customer number
*     Begin of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
*     lv_vbak_kunnr = vbak-kunnr.
*     End   of DEL:ERP-6117:WROY:30-JUL-2018:ED2K912831
*     Begin of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
      lv_vbak_kunnr = kuwev-kunnr.
*     End   of ADD:ERP-6117:WROY:30-JUL-2018:ED2K912831
      SELECT idnumber        " Identification Number
        FROM but0id          " BP: ID Numbers
        INTO lv_idnumber
        UP TO 1 ROWS
        WHERE partner = lv_vbak_kunnr
        AND type = lv_zlgrp. " 'ZLGRP'.   " License type
      ENDSELECT.
      IF sy-subrc = 0.
* Pass License Group from BUT0ID to VBAK structure
        vbak-zzlicgrp = lv_idnumber.

*Begin of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
        lst_but0id-partner = lv_vbak_kunnr.
        lst_but0id-type = lv_zlgrp.
        lst_but0id-idnumber = lv_idnumber.
        INSERT lst_but0id INTO TABLE li_but0id.
        CLEAR: lst_but0id.
      ELSE. " ELSE -> IF sy-subrc = 0
        lst_but0id-partner = lv_vbak_kunnr.
        lst_but0id-type = lv_zlgrp.
        lst_but0id-idnumber = space.
        INSERT lst_but0id INTO TABLE li_but0id.
        CLEAR: lst_but0id.
*End of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
      ENDIF. " IF sy-subrc = 0
*Begin of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
    ELSE. " ELSE -> IF sy-subrc NE 0
      vbak-zzlicgrp = lst_but0id-idnumber.
    ENDIF. " IF sy-subrc NE 0
*End of Add-Anirban-07.13.2017-ED2K907273-Defect 2974
  ENDIF. " IF lv_flag EQ abap_true AND vbak-kunnr IS NOT INITIAL
ENDIF. " IF vbak-zzlicgrp IS INITIAL
