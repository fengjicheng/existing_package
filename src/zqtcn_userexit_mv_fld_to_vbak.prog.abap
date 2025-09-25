*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAK (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales dokument header workaerea VBAK
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAK (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move LICENSE
*                      GROUP into the sales header workaerea VBAK
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID:       E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : Update credit rep group(VBAK-SBGRP)
*            by gathering payer information and Company code
* DEVELOPER: Randheer Kumar
* CREATION DATE:  March 26th, 2018
* OBJECT ID:  E149, seq#3, ERP-6968
* TRANSPORT NUMBER(S): ED2K911611
*----------------------------------------------------------------------*
* CHANGE DESCRIPTION : Populate Order Reason for Credit / Debit Memo
*                      Requests being created for Sales Rep Change
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:  August 13th, 2018
* OBJECT ID:  E131 / INC0205683
* TRANSPORT NUMBER(S): ED1K908183
*----------------------------------------------------------------------*
* Developer : Siva Guda (SGUDA)
* CHANGE DESCRIPTION : To Control credit check
* CREATION DATE:  09-10-2018
* OBJECT ID:  E181
* TRANSPORT NUMBER(S):ED2K912979
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:ED1K908548
* REFERENCE NO:INC0193784
* DEVELOPER:SGUDA
* DATE:09/24/2018
* DESCRIPTION: Added FM ZRTR_CRDT_CHK_SUSPENSIONS for Credit check while
*              we are changing MQ number
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: Add Forwarding Agent(CR) as Partner Function at document header.
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   05/14/2020
* OBJECT ID: E241(ERPM-11672)
* TRANSPORT NUMBER(S):ED2K918215
*----------------------------------------------------------------------*
**Local variable and constant declaration
  CONSTANTS:
    lc_wricef_id_e106 TYPE zdevid  VALUE 'E106', "Constant value for WRICEF (E106)
    lc_ser_num_e106   TYPE zsno    VALUE '001',   "Serial Number (001)
    lc_wricef_id_e149 TYPE zdevid  VALUE 'E149', "Constant value for WRICEF (E149)  "added for ERP-6968
    lc_wricef_id_e241 TYPE zdevid  VALUE 'E241', "Development ID
    lc_sno_e241_001   TYPE zsno    VALUE '001',  "Serial Number
    lc_ser_num_e149_3 TYPE zsno    VALUE '003'.  "Serial Number (003)              "added for ERP-6968

  DATA:
    lv_var_key_e106   TYPE zvar_key,     "Variable Key
    lv_actv_flag_e106 TYPE zactive_flag, "Active / Inactive flag
    lv_var_key_e149   TYPE zvar_key,     "Variable Key
    lv_actv_flag_e241 TYPE zactive_flag,                          "added for ERP-6968
    lv_actv_flag_e149 TYPE zactive_flag. "Active / Inactive flag                 "added for ERP-6968


* Check if enhancement needs to be triggered
* This enhancement will determine license group for
* particular order type

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e106  "Constant value for WRICEF (E106)
      im_ser_num     = lc_ser_num_e106  "Serial Number (003)
      im_var_key     = lv_var_key_e106    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e106. "Active / Inactive flag

  IF lv_actv_flag_e106 = abap_true.
** Begin of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    INCLUDE zqtc_enh_exlude_e181 IF FOUND.
    IF sy-subrc = 4.
      lv_actv_flag_e106 = abap_false.
      sy-subrc = 0.
    ENDIF.
** End of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
  ENDIF. " IF lv_actv_flag_E106 = abap_true
  IF lv_actv_flag_e106 = abap_true.          "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    INCLUDE zqtcn_license_group_determine IF FOUND.
  ENDIF.                                     "ADD:E181:SGUDA:10-SEP-2018:ED2K912979

*BOC for ERP-6968
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e149  "Constant value for WRICEF (E149)
      im_ser_num     = lc_ser_num_e149_3  "Serial Number (003)
      im_var_key     = lv_var_key_e149    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e149. "Active / Inactive flag
* Begin of ADD:INC0193784:SGUDA:24-SEP-2018:ED1K908548
** Begin of ADD:E181:SGUDA:10-SEP-2018:ED1K908465
*  IF lv_actv_flag_e149 = abap_true.
*    INCLUDE zqtc_enh_exlude_e181 IF FOUND.
*    IF sy-subrc = 4.
*      lv_actv_flag_e149 = abap_false.
*      sy-subrc = 0.
*    ENDIF.
*  ENDIF.
** End of ADD:E181:SGUDA:10-SEP-2018:ED1K908465
* End of ADD:INC0193784:SGUDA:24-SEP-2018:ED1K908548
  IF lv_actv_flag_e149 = abap_true. "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    INCLUDE zqtc_credit_rep_group_determin IF FOUND.
  ENDIF.                            "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
*BOC for ERP-6968

* Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
  CONSTANTS:
    lc_wricef_id_e131 TYPE zdevid VALUE 'E131',  "Constant value for WRICEF (E131)
    lc_ser_num_e131_2 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_actv_flag_e131 TYPE zactive_flag.         "Active / Inactive flag

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e131  "Constant value for WRICEF (E131)
      im_ser_num     = lc_ser_num_e131_2  "Serial Number (002)
    IMPORTING
      ex_active_flag = lv_actv_flag_e131. "Active / Inactive flag

  IF lv_actv_flag_e131 = abap_true.
    INCLUDE zqtcn_ord_res_sls_rp_crdt_debt IF FOUND.
  ENDIF.
* End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
**Boc mimmadiset E241(ERPM-11672) ED2K918215
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e241
      im_ser_num     = lc_sno_e241_001
    IMPORTING
      ex_active_flag = lv_actv_flag_e241.

  IF lv_actv_flag_e241 EQ abap_true.
    INCLUDE zqtcn_wls_fill_vbap_parvw_e241 IF FOUND.
  ENDIF.
**Eoc mimmadiset E241(ERPM-11672) ED2K918215

**BOC VMAMILLAPA 28-Sep-2022 SNAP PAY POC
**  TYPES: BEGIN OF ty_edid4,
**          segnum  TYPE idocdsgnum,
**          segnam  TYPE edi_segnam,
**          psgnum  TYPE edi_psgnum,
**          sdata   TYPE edi_sdata,
**         END OF ty_edid4.
*  DATA:li_edid4 TYPE STANDARD TABLE OF edid4.
*  IF  vbak-msr_id IS INITIAL.
* IF idoc_number IS NOT INITIAL.
**   SELECT segnum
**          segnam
**         DTINT2
**          sdata
**          psgnum
**          tdobname
*   SELECT *
*   FROM edid4
**   FROM DTINT2
*   INTO TABLE li_edid4
*   WHERE docnum = idoc_number AND
*         segnam = 'E1EDKT1'.
**         ( segnam = 'E1EDKT1' OR
**           segnam = 'E1EDKT2' ).
*   IF sy-subrc IS INITIAL.
*     DATA: lst_e1edkt1 TYPE e1edkt1,
*           lst_e1edkt2 TYPE e1edkt2,
*           lv_sdata TYPE char100.
*     LOOP AT li_edid4 ASSIGNING FIELD-SYMBOL(<lfs_edid4>) WHERE segnam = 'E1EDKT1'.
**       IF line_exists( li_edid4[ psgnum = <lfs_edid4>-segnum ] ).
***         lst_e1edkt2 = li_edid4[ psgnum = <lfs_edid4>-segnum ]-sdata.*
**       ENDIF.
*        lst_e1edkt1 = <lfs_edid4>-sdata.
**     IF lst_e1edkt2-tdline IS NOT INITIAL.
*     IF lst_e1edkt1-tdobname IS NOT INITIAL.
*       CASE lst_e1edkt1-tdid.
*         WHEN 'SN01'.
**           vbak-msr_id = lst_e1edkt2-tdline.
*           vbak-msr_id = lst_e1edkt1-tdobname.
*         WHEN 'SN02'.
**           vbak-handoverloc = lst_e1edkt2-tdline.
*           vbak-handoverloc = lst_e1edkt1-tdobname.
*         WHEN OTHERS.
*       ENDCASE.
*
*     ENDIF.
*     CLEAR:lst_e1edkt1,lst_e1edkt2,lv_sdata.
*     ENDLOOP.
*   ENDIF.
*   ENDIF.
*
*ENDIF.
**EOC VMAMILLAPA 28-Sep-2022 SNAP PAY POC
**OTCM-72898 Cancellation Notice on Cancelled Contracts/Orders/Proformas on Overview screen

  CONSTANTS: lc_xveda TYPE char30 VALUE '(SAPLV45W)XVEDA[]'.
  FIELD-SYMBOLS : <li_xveda> TYPE ztrar_vedavb.
  DATA: li_xveda TYPE ztrar_vedavb.
  STATICS : lv_flag_cancel TYPE c.
  IF sy-tcode = 'VA02' OR sy-tcode = 'VA42' OR sy-tcode = 'VA22'.
    IF lv_flag_cancel IS INITIAL.
      ASSIGN (lc_xveda) TO <li_xveda>.
      IF sy-subrc EQ 0.
        li_xveda[] =  <li_xveda>[].
      ENDIF.
      READ TABLE xvbap TRANSPORTING NO FIELDS WITH KEY abgru = ' '.
      IF sy-subrc NE 0.
        MESSAGE 'Contract/Order is Canccelled/Rejected' TYPE 'I'.
        lv_flag_cancel = abap_true.
      ENDIF.
      IF vbak-vbtyp = 'G'.
        DELETE li_xveda WHERE vposn = '000000'. "Cancellation gets assigned at item only
        READ TABLE li_xveda TRANSPORTING NO FIELDS WITH KEY vkuegru = ' '.
        IF sy-subrc NE 0.
          MESSAGE 'Contract/Order is Canccelled/Rejected' TYPE 'I'.
          lv_flag_cancel = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
