*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_PRC_PREP_TKOMP (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move additional
*                      fields into the communication table which is
*                      used for pricing: TKOMP for item fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_01
* PROGRAM DESCRIPTION: Replace Pricing Reference Material
* DEVELOPER: Writtick Roy(WROY)
* CREATION DATE: 10-NOV-2016
* OBJECT ID: E075
* TRANSPORT NUMBER(S)ED2K903315
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_LICENSE_GROUP_DETERMINE (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This determines price group , ZA partner function
*                      & member type for a particular subscription types
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID:       E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ACCESS_TRCKNG_SCTY (Include)
* PROGRAM DESCRIPTION: This enhancement will capture the online access code
* recognized by ALM in the created subscription which will be determined by
* the society and the product in the subscription
* DEVELOPER: Aratrika Banerjee
* CREATION DATE:   17/03/2017
* OBJECT ID: E152
* TRANSPORT NUMBER(S): ED2K904991
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_ENH_EXLUDE_E181 (Include)
* PROGRAM DESCRIPTION: This enhancement will use for to control credit check
* DEVELOPER: Siva Guda
* CREATION DATE:   09/10/201
* OBJECT ID: E181
* TRANSPORT NUMBER(S): ED2K912979
*----------------------------------------------------------------------*

PERFORM xvbpa_lesen(sapfv45k) USING 'ZW' vbap-posnr sy-tabix.

MOVE xvbpa-lifnr TO tkomp-zzws_partner.


CONSTANTS:
  lc_wricef_id_e075 TYPE zdevid   VALUE 'E075', " Development ID
  lc_ser_num_1_e075 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e075 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_1_e075
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  INCLUDE zqtcn_manage_discounts_01 IF FOUND.
ENDIF. " IF lv_actv_flag_e075 EQ abap_true
*********************************************************************
************************E106*****************************************
* This enhancement will update price group , ZA partner & member type
*********************************************************************
CONSTANTS:
  lc_wricef_id_e106 TYPE zdevid   VALUE 'E106', " Development ID
  lc_ser_num_1_e106 TYPE zsno     VALUE '002'.  " Serial Number

DATA:
  lv_actv_flag_e106 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e106
    im_ser_num     = lc_ser_num_1_e106
  IMPORTING
    ex_active_flag = lv_actv_flag_e106.

IF lv_actv_flag_e106 EQ abap_true.
* Begin of ADD:E181:SGUDA:09-SEP-2018:ED2K912979
  INCLUDE zqtc_enh_exlude_e181 IF FOUND.
  IF sy-subrc = 4.
    lv_actv_flag_e106 = abap_false.
    sy-subrc = 0.
  ENDIF.
* End of ADD:E181:SGUDA:09-SEP-2018:ED2K912979
  IF  lv_actv_flag_e106 = abap_true.            "ADD:E181:SGUDA:09-SEP-2018:ED2K912979
    INCLUDE zqtcn_member_partner_price IF FOUND.
  ENDIF.                                         "ADD:E181:SGUDA:09-SEP-2018:ED2K912979

ENDIF. " IF lv_actv_flag_e106 EQ abap_true

*********************************************************************
************************E152*****************************************
* This enhancement will capture the online access code recognized
* by ALM in the created subscription which will be determined by the
* society and the product in the subscription
*********************************************************************
CONSTANTS:
  lc_wricef_id_e152 TYPE zdevid   VALUE 'E152', " Development ID
  lc_ser_num_1_e152 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e152 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e152
    im_ser_num     = lc_ser_num_1_e152
  IMPORTING
    ex_active_flag = lv_actv_flag_e152.

IF lv_actv_flag_e152 EQ abap_true.
  INCLUDE zqtcn_access_trckng_scty IF FOUND.
ENDIF. " IF lv_actv_flag_e152 EQ abap_true

INCLUDE zqtcn_profile_billing_plan IF FOUND.

*Begin VMAMILLAPA on 20-Mar-2022
*INCLUDE zqtcn_modify_dis_conditions IF FOUND.
*End VMAMILLAPA on 20-Mar-2022


*Begin SGUNDLAPAL on 07/12/2024

DATA: lv_ism_identcode TYPE mara-bismt,
      lv_mstae TYPE mara-mstae.

SELECT SINGLE bismt mstae
  INTO (lv_ism_identcode, lv_mstae)
  FROM mara
  WHERE matnr = tkomp-matnr.

IF sy-subrc = 0.
  tkomp-ismidentcode = lv_ism_identcode.
  tkomp-mstae = lv_mstae.
ENDIF.



*SELECT bismt,mstae
*  FROM mara
*  INTO @DATA(lwa_mara)
*  WHERE matnr EQ @tkomp-matnr.
*IF sy-subrc = 0.
*  tkomp-ismidentcode = lwa_mara-bismt.
*  tkomp-mstae = lwa_mara-mstae.
*ENDIF.
*End SGUNDLAPAL on 07/12/2024
