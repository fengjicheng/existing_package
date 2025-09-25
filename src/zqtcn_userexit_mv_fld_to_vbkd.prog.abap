*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales doc business data workaerea VBKD
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: Default 55(Special Offer) to condition group 4
*                      (VBKD-KDKG4) for Opt In scenario for the free
*                      item when creating a renewal quote.
* DEVELOPER: Anirban Saha (ANISAHA)
* CREATION DATE: 2017-10-02
* OBJECT ID: E106 - ERP 4704
* TRANSPORT NUMBER(S) ED2K908447
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910047, ED2K910049(Cust)
* REFERENCE NO:  I0230
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2018-01-02
* DESCRIPTION: To populate the condition Group4(KDKG4) for the free goods
*              item category(PSTYV) maintained in the ZCACONSTANT table.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912297, ED2K912303(Cust)
* REFERENCE NO:  I0233 (ERP-6425)
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-06-13
* DESCRIPTION: Populate Legacy subscription type (Customer Condition
*              Group 5) for YBP/OASIS Contracts
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907497
* REFERENCE NO:  E134 (RITM0028165)
* DEVELOPER: Sayantan Das(SAYANDAS)
* DATE:  2018-05-25
* DESCRIPTION: Copy Partner Detail from BOM Header to Components when
*              Ship-to Party is changed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913006
* REFERENCE NO:  I0341 (ERP-6593)
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-10
* DESCRIPTION: Add Master License Owner for Agent Orders
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912979
* REFERENCE NO:  E181
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  09-10-2018
* DESCRIPTION: To exclude enhancements selectively for any specific user
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO  : ED2K913989
* REFERENCE NO : CR7848/E164
* DEVELOPER    : Kiran Jagana(kjagana)
* DATE         : 2018-12-05
* DESCRIPTION  : ZSBP sales document type to be excluded from E107 and E164,
*while creating contract.
*-------------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Firm Invoice Order Validation
* REFERENCE NO: E254 - ERPM-16414
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-23-2020
* TRANSPORT NUMBER(s): ED2K918988
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: Fill the Sub Ref ID, PO Type, PO number,
*                      Ship To Party “Your Reference” number at line item
* REFERENCE NO: E095 - ERPM-15045
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 09-18-2020
* TRANSPORT NUMBER(s): ED2K919548
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: Defaault the Payment terms for ZCSS orders for
*                      US advertising agency
* DEVELOPER: GKAMMILI
* CREATION DATE: 11/23/2020
* OBJECT ID: E260
* TRANSPORT NUMBER(S): ED2K920422
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: Restrict E260 changes for creation only
*                      US advertising agency
* DEVELOPER: GKAMMILI
*REFERENCE NO:PRB0047246/INC0346059
* CREATION DATE: 11/23/2020
* OBJECT ID: E260
* TRANSPORT NUMBER(S): ED1K912771
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: PO type auto assignment for FTP
*                      customer orders
* DEVELOPER: TDIMANTHA
* CREATION DATE: 03/12/2021
* OBJECT ID: E265
* TRANSPORT NUMBER(S): ED2K922516
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: OTCM-39848
* DEVELOPER: TDIMANTHA
* DATE: 04/21/2021 (MM/DD/YYYY)
* TRANSPORT NUMBER(S): ED2K922991
* DESCRIPTION: Remove auto determination of po type/add warning message
* With one option
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: OTCM-37740
* DEVELOPER: Prabhu(PTUFARAM)
* OBJECT ID: E107
* DATE: 05/10/2021
* TRANSPORT NUMBER(S)
* DESCRIPTION: Update Pricing Date VBKD-PRSDT as Contract start date
*              Change will be applied only for the Document types maintained
*              in constant table
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD(Include)
*               Called from "MV45AFZZ"
* PROGRAM DESCRIPTION: Determine Validity Period Category from
*               Validity Period
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE: 05/17/2021
* OBJECT ID: E107 - OTCM-42812
* TRANSPORT NUMBER(S): ED2K923455
*----------------------------------------------------------------------*
* Begin of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
  CONSTANTS:
    lc_wricef_id_e134 TYPE zdevid VALUE 'E134', "Development ID
    lc_ser_num_e134_2 TYPE zsno   VALUE '002'.  "Serial Number

  DATA:
    lv_actv_flag_e234 TYPE zactive_flag. "Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e134
      im_ser_num     = lc_ser_num_e134_2
    IMPORTING
      ex_active_flag = lv_actv_flag_e234.

  IF lv_actv_flag_e234 EQ abap_true.
    INCLUDE zqtcn_sales_bom_partners_01 IF FOUND.
  ENDIF. " IF lv_actv_flag_e234 EQ abap_true
* End   of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497

* Local Data declaration
  DATA:
    lv_actv_flag_e107 TYPE zactive_flag . "Active / Inactive Flag

*Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e107 TYPE zdevid  VALUE 'E107', "Development ID
    lc_sno_e107_001   TYPE zsno    VALUE '001', "Serial Number
    lc_sno_e107_002   TYPE zsno    VALUE '002'.  "Serial Number


  STATICS lv_flag_type TYPE char1 .
*  * BOC by KJAGANA ERP7848 TR:   ED2K913989
  CLEAR :lv_flag_type.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e107
      im_ser_num     = lc_sno_e107_002
    IMPORTING
      ex_active_flag = lv_actv_flag_e107.

  IF lv_actv_flag_e107 EQ abap_true.
    INCLUDE zqtc_contract_type_e107 IF FOUND.
  ELSE.
    lv_flag_type = abap_true.
  ENDIF.
  IF lv_flag_type EQ abap_true.
*  * EOC by KJAGANA ERP7848 TR:   ED2K913989

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e107
        im_ser_num     = lc_sno_e107_001
      IMPORTING
        ex_active_flag = lv_actv_flag_e107.

    IF lv_actv_flag_e107 EQ abap_true.
** Begin of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
      " Validate if any Exclusion logic is active for current user
      INCLUDE zqtc_enh_exlude_e181 IF FOUND.
      IF sy-subrc = 4.
        lv_actv_flag_e107 = abap_false.
        sy-subrc = 0.
      ENDIF.
** End of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    ENDIF. " IF lv_actv_flag_e107 EQ abap_true
    IF lv_actv_flag_e107 = abap_true.               "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
      INCLUDE zqtcn_default_contract_dates IF FOUND.
    ENDIF.                                          "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
* Begin of ADD:CR#591:WROY:10-SEP-2017:ED2K908447
  ENDIF. "lv_flag eq abap_true by KJAGANA ERP7848 TR:   ED2K913989
  DATA:
    lv_actv_flag_e106 TYPE zactive_flag . "Active / Inactive Flag

  CONSTANTS:
    lc_wricef_id_e106 TYPE zdevid  VALUE 'E106', "Development ID
    lc_sno_e106_003   TYPE zsno    VALUE '003'.  "Serial Number

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e106
      im_ser_num     = lc_sno_e106_003
    IMPORTING
      ex_active_flag = lv_actv_flag_e106.

  IF lv_actv_flag_e106 EQ abap_true.
** Begin of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    " Validate if any Exclusion logic is active for current user
    INCLUDE zqtc_enh_exlude_e181 IF FOUND.
    IF sy-subrc = 4.
      lv_actv_flag_e106 = abap_false.
      sy-subrc = 0.
    ENDIF.
** End of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
  ENDIF. " IF lv_actv_flag_e106 EQ abap_true
  IF lv_actv_flag_e106 = abap_true.  "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
    INCLUDE zqtcn_determine_volume_year IF FOUND.
  ENDIF.                            "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
* End   of ADD:CR#591:WROY:10-SEP-2017:ED2K908447


* Begin of ADD:ERP 4704:ANISAHA:02-OCT-2017:ED2K908447
  DATA:
    lv_actv_flag_e096 TYPE zactive_flag , "Active / Inactive Flag
*   Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
    lv_var_key_e096   TYPE zvar_key. "Variable Key
*   End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121

  CONSTANTS:
    lc_wricef_id_e096 TYPE zdevid  VALUE 'E096', "Development ID
    lc_sno_e096_002   TYPE zsno    VALUE '002'.  "Serial Number

* Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
  lv_var_key_e096 = vbak-vbtyp. "Variable Key: Document category of preceding SD document
* End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e096
      im_ser_num     = lc_sno_e096_002
*     Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
      im_var_key     = lv_var_key_e096
*     End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910121
    IMPORTING
      ex_active_flag = lv_actv_flag_e096.

  IF lv_actv_flag_e096 EQ abap_true.
    INCLUDE zqtcn_populate_spl_offer IF FOUND.
  ENDIF. " IF lv_actv_flag_e096 EQ abap_true
* End   of ADD:ERP 4704:ANISAHA:02-OCT-2017:ED2K908447

* Begin of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
* Local Data declaration
  DATA:
    lv_actv_flag_e164 TYPE zactive_flag, "Active / Inactive Flag
    lv_var_key_e164   TYPE zvar_key.     "Variable Key

* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e164 TYPE zdevid  VALUE 'E164', "Development ID
    lc_sno_e164_005   TYPE zsno    VALUE '005',  "Serial Number
    lc_sno_e164_009   TYPE zsno    VALUE '009'.  "Serial Number
*  * BOC by KJAGANA ERP7848 TR:   ED2K913989
* To check enhancement is active or not
  CLEAR lv_flag_type.
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e164
      im_ser_num     = lc_sno_e164_009
    IMPORTING
      ex_active_flag = lv_actv_flag_e164.

  IF lv_actv_flag_e164 EQ abap_true.
    INCLUDE zqtc_contract_type_e164 IF FOUND.
  ELSE.
    lv_flag_type = abap_true.
  ENDIF.

  IF lv_flag_type EQ abap_true.
*  * EOC by KJAGANA ERP7848 TR:   ED2K913989

    lv_var_key_e164 = vbak-vgtyp. "Variable Key: Document category of preceding SD document
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e164
        im_ser_num     = lc_sno_e164_005
        im_var_key     = lv_var_key_e164
      IMPORTING
        ex_active_flag = lv_actv_flag_e164.

    IF lv_actv_flag_e164 EQ abap_true.
      INCLUDE zqtcn_renewals_billing_date IF FOUND.
    ENDIF. " IF lv_actv_flag_e164 EQ abap_true
* End   of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
  ENDIF."lv_flag eq abap_true."by KJAGANA ERP7848 TR:   ED2K913989
* Begin of ADD:E168:Yraulji:21-NOV-2017:ED2K909533
* Local Data declaration
  DATA:
    lv_actv_flag_e168 TYPE zactive_flag. "Active / Inactive Flag

* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e168 TYPE zdevid  VALUE 'E168', "Development ID
    lc_sno_e168_001   TYPE zsno    VALUE '001'.  "Serial Number

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e168
      im_ser_num     = lc_sno_e168_001
    IMPORTING
      ex_active_flag = lv_actv_flag_e168.

  IF lv_actv_flag_e168 EQ abap_true.
    INCLUDE zqtcn_override_payment_term IF FOUND.
  ENDIF. " IF lv_actv_flag_e168 EQ abap_true
* End   of ADD:E168:Yraulji:21-NOV-2017:ED2K909533

* Begin of DEL:E172:WROY:24-JUL-2018:ED2K912756
** Begin of ADD: I0230: PBANDLAPAL: 02-JAN-2018: ED2K909533
** Local Data declaration
*  DATA:
*    lv_actv_flag_i0230 TYPE zactive_flag.         "Active / Inactive Flag
*
** Local constant Declaration
*  CONSTANTS:
*    lc_sno_i0230_003   TYPE zsno    VALUE '003',   "Serial Number
*    lc_wricef_id_i0230 TYPE zdevid  VALUE 'I0230'. "Development ID
*
** To Populate the condition Group4 for Free Goods
*
** To check enhancement is active or not
*  CALL FUNCTION 'ZCA_ENH_CONTROL'
*    EXPORTING
*      im_wricef_id   = lc_wricef_id_i0230
*      im_ser_num     = lc_sno_i0230_003
*    IMPORTING
*      ex_active_flag = lv_actv_flag_i0230.
*
*  IF lv_actv_flag_i0230 EQ abap_true.
*    INCLUDE zqtcn_upd_condgrp4_freegoods IF FOUND.
*  ENDIF.
** End of ADD: I0230: PBANDLAPAL: 02-JAN-2018: ED2K909533
* End   of DEL:E172:WROY:24-JUL-2018:ED2K912756
* Begin of ADD:E172:WROY:24-JUL-2018:ED2K912756
* Local Data declaration
  DATA:
    lv_actv_flag_e172 TYPE zactive_flag. "Active / Inactive Flag

* Local constant Declaration
  CONSTANTS:
    lc_sno_e172_001   TYPE zsno    VALUE '001',  "Serial Number
    lc_wricef_id_e172 TYPE zdevid  VALUE 'E172'. "Development ID

* To Populate the condition Group4 for Free Goods
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e172
      im_ser_num     = lc_sno_e172_001
    IMPORTING
      ex_active_flag = lv_actv_flag_e172.

  IF lv_actv_flag_e172 EQ abap_true.
    INCLUDE zqtcn_upd_condgrp4_freegoods IF FOUND.
  ENDIF. " IF lv_actv_flag_e172 EQ abap_true
* End   of ADD:E172:WROY:24-JUL-2018:ED2K912756

* Begin of ADD:I0233(ERP-6425):WROY:13-JUN-2018:ED2K909533
* Local Variable Declaration
  DATA:
    lv_actv_flag_i0233 TYPE zactive_flag. "Active / Inactive Flag

* Local Constant Declaration
  CONSTANTS:
    lc_sno_i0233_001   TYPE zsno    VALUE '001',   "Serial Number
    lc_wricef_id_i0233 TYPE zdevid  VALUE 'I0233'. "Development ID

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0233  "Development ID (I0233)
      im_ser_num     = lc_sno_i0233_001    "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0233. "Active / Inactive Flag

  IF lv_actv_flag_i0233 EQ abap_true. "Check for Active Flag
    INCLUDE zqtcn_upd_cust_cond_grp5_01 IF FOUND.
  ENDIF. " IF lv_actv_flag_i0233 EQ abap_true
* End   of ADD:I0233(ERP-6425):WROY:13-JUN-2018:ED2K909533

* Begin of ADD:I0341(ERP-6593):WROY:10-AUG-2018:ED2K913006
* Local Variable Declaration
  DATA:
    lv_actv_flag_i0341 TYPE zactive_flag. "Active / Inactive Flag

* Local Constant Declaration
  CONSTANTS:
    lc_sno_i0233_004   TYPE zsno    VALUE '004',   "Serial Number
    lc_wricef_id_i0341 TYPE zdevid  VALUE 'I0341'. "Development ID

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0341  "Development ID (I0341)
      im_ser_num     = lc_sno_i0233_004    "Serial Number (004)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0341. "Active / Inactive Flag

  IF lv_actv_flag_i0341 EQ abap_true. "Check for Active Flag
    INCLUDE zqtcn_mstr_lic_ownr_agnt_ords IF FOUND.
  ENDIF. " IF lv_actv_flag_i0341 EQ abap_true
* End   of ADD:I0341(ERP-6593):WROY:10-AUG-2018:ED2K913006

* Begin by AMOHAMMED on 07-23-2020 TR# ED2K918988
  CONSTANTS: lc_wricef_id_e254 TYPE zdevid VALUE 'E254', " Development ID
             lc_ser_num_e254   TYPE zsno   VALUE '001'.  " Serial Number

  DATA: lv_actv_flag_e254    TYPE zactive_flag . " Active / Inactive Flag

  IF t180-trtyp = lc_create OR " Create Mode
     t180-trtyp = lc_change.   " Change Mode
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e254
        im_ser_num     = lc_ser_num_e254
      IMPORTING
        ex_active_flag = lv_actv_flag_e254.

    IF lv_actv_flag_e254 EQ abap_true.
      INCLUDE zqtcn_frm_inv_ord_vald_e254 IF FOUND.
    ENDIF. " IF lv_actv_flag EQ abap_true
  ENDIF. " IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
* Begin by AMOHAMMED on 07-23-2020 TR# ED2K918988

* Begin by AMOHAMMED on 09-18-2020 TR# ED2K919548
  CONSTANTS: lc_wricef_id_e095 TYPE zdevid VALUE 'E095', " Development ID
             lc_ser_num_e095   TYPE zsno   VALUE '007'.  " Serial Number

  DATA: lv_actv_flag_e095    TYPE zactive_flag . " Active / Inactive Flag

  IF t180-trtyp = lc_create OR " Create Mode
     t180-trtyp = lc_change.   " Change Mode
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e095
        im_ser_num     = lc_ser_num_e095
      IMPORTING
        ex_active_flag = lv_actv_flag_e095.

    IF lv_actv_flag_e095 EQ abap_true.
      INCLUDE zqtcn_fill_subref_id_e095 IF FOUND.
    ENDIF. " IF lv_actv_flag EQ abap_true
  ENDIF. " IF t180-trtyp = lc_create.
* End by AMOHAMMED on 09-18-2020 TR# ED2K919548
*-- BOC by GKAMMILI on 11-23-2020 for OTCM 26951 TR# ED2K920422
  IF t180-trtyp = lc_create. " Create Mode "Added by GKAMMILI for INC0346059: ED1K912771:03/16/2021
    CONSTANTS: lc_wricef_id_e260 TYPE zdevid VALUE 'E260', " Development ID
               lc_ser_num_e260   TYPE zsno   VALUE '001'.  " Serial Number

    DATA: lv_actv_flag_e260      TYPE zactive_flag . " Active / Inactive Flag

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e260
        im_ser_num     = lc_ser_num_e260
      IMPORTING
        ex_active_flag = lv_actv_flag_e260.

    IF lv_actv_flag_e260 EQ abap_true.
      INCLUDE zqtcn_default_payment_term_css IF FOUND.
    ENDIF. " IF lv_actv_flag EQ abap_true
  ENDIF. " IF t180-trtyp = lc_create. "Added by GKAMMILI for INC0346059: ED1K912771:03/16/2021
*-- EOC by GKAMMILI on 11-23-2020 for OTCM 26951 TR# ED2K920422
*-- BOC by TDIMANTHA on 03-12-2021 for OTCM-39849 TR # ED2K922516

  CONSTANTS: lc_wricef_id_e265 TYPE zdevid VALUE 'E265', " Development ID
             lc_ser_num_e265   TYPE zsno   VALUE '001'.  " Serial Number

  DATA: lv_actv_flag_e265      TYPE zactive_flag . " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e265
      im_ser_num     = lc_ser_num_e265
    IMPORTING
      ex_active_flag = lv_actv_flag_e265.

  IF lv_actv_flag_e265 EQ abap_true.
    INCLUDE zqtcn_auto_asign_potype_e265 IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true

*-- EOC by TDIMANTHA on 03-12-2021 for OTCM-39849 TR# ED2K922516
*-- BOC by Prabhu on 05-10-2021 for OTCM-37740 TR #  ED2K923359
*Local Variables Declaration
  CONSTANTS:lc_sno_e107_003   TYPE zsno    VALUE '003'.  "Serial Number
  DATA      lv_active_003_e107 TYPE zactive_flag . " Active / Inactive Flag
  STATICS lv_doc_type_e107 TYPE auart."Static Variable to avoid fetching constant table data

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e107
      im_ser_num     = lc_sno_e107_003
    IMPORTING
      ex_active_flag = lv_active_003_e107.

  IF lv_active_003_e107 EQ abap_true.
    INCLUDE zqtc_update_pricing_date_e107 IF FOUND.
  ENDIF.
*-- EOC by Prabhu on 05-10-2021 for OTCM-37740 TR #  ED2K923359
*-- BOC by TDIMANTHA on 05-17-2021 for OTCM-42812 TR #  ED2K923455
*Local Variables Declaration
  CONSTANTS:lc_sno_e107_004   TYPE zsno    VALUE '004'.  "Serial Number
  DATA      lv_active_004_e107 TYPE zactive_flag . " Active / Inactive Flag
*  STATICS lv_doc_type_e107 TYPE auart."Static Variable to avoid fetching constant table data

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e107
      im_ser_num     = lc_sno_e107_004
    IMPORTING
      ex_active_flag = lv_active_004_e107.

  IF lv_active_004_e107 EQ abap_true.
    INCLUDE zqtcn_upd_valid_perio_cat_e107 IF FOUND.
  ENDIF.
*-- EOC by TDIMANTHA on 05-17-2021 for OTCM-42812 TR #  ED2K923455
