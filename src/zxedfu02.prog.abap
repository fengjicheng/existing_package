*----------------------------------------------------------------------*
* PROGRAM NAME:        ZXEDFU02
* PROGRAM DESCRIPTION: IDOC population for Invoice outbound
* DEVELOPER:           Shubanjali Sharma
* CREATION DATE:       02/10/2017
* OBJECT ID:           I0245
* TRANSPORT NUMBER(S):  ED2K904235
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K923561                                             *
* REFERENCE NO: OTCM-44643                                             *
* DEVELOPER   : Murali (mimmadiset)                            *
* DATE        : 05/26/2021                                             *
* OBJECT ID   : I0397                                                  *
* DESCRIPTION : As and when a billing document is generated and saved in
*SAP for this Hungarian client,it will create an IDOC and sent out to the middleware.
*The middleware than converts it into a compliant XML format and transfers
*the invoice Data to the Hungarian NAV system.                       *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION NO : ED2K926618
* REFERENCE NO: EAM-1773/I0507
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)
* DATE        : 04/12/2022
* DESCRIPTION : Custom segments population for INVOICE IDOC for APL
*----------------------------------------------------------------------*

  CONSTANTS:
    lc_wricef_id_i0245 TYPE zdevid VALUE 'I0245', "Constant value for WRICEF (I0230)
    lc_ser_num_i0245   TYPE zsno   VALUE '001'.   "Serial Number (001)

  DATA:
    lv_var_key_i0245   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0245 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key

  CONCATENATE control_record_out-mestyp  " Message Type
              control_record_out-idoctp  " Idoc type
  INTO lv_var_key_i0245.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0245  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0245  "Serial Number (003)
      im_var_key     = lv_var_key_i0245    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0245. "Active / Inactive flag

  IF lv_actv_flag_i0245 = abap_true.

    INCLUDE zqtcn_outinvoice IF FOUND.

  ENDIF. " IF lv_actv_flag_i0245 = abap_true
*BOC by murali on 05/26/2021 for OTCM-44643 with ED2K923561  *
  CONSTANTS : lc_ser_num_i0397_1 TYPE zsno VALUE '001',    "Serial Number (001)
              lc_wricef_id_i0397 TYPE zdevid VALUE 'I0397'. "Constant value for WRICEF (i0397)

  DATA : lv_var_key_i0397_1   TYPE zvar_key,     "Variable Key
         lv_actv_flag_i0397_1 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key with Output type
  lv_var_key_i0397_1 = dobject-kschl.           " dobject-kschl = 'ZM3I'

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0397       " Constant value for WRICEF (i0397)
      im_ser_num     = lc_ser_num_i0397_1       " Serial Number (001)
      im_var_key     = lv_var_key_i0397_1       " Variable Key (Output type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0397_1.    "Active / Inactive flag

  IF lv_actv_flag_i0397_1 = abap_true.
    INCLUDE zqtcn_mthree_outinv_i0397 IF FOUND.
  ENDIF.
*EOC by murali on 05/26/2021 for OTCM-44643 with ED2K923561  *
*BOC by VMAMILLAPA on 04/12/2022 for EAM1773 with ED2K926618 *
    CONSTANTS:
     lc_i0507        TYPE zdevid VALUE 'I0507', "Constant value for WRICEF (I0507)
     lc_ser_nr_001   TYPE zsno   VALUE '001'.   "Serial Number (001)

    DATA: lv_active_i0507 TYPE zactive_flag.    "Active / Inactive flag

     DATA(lv_var_key_507) = CONV zvar_key( |{  control_record_out-mestyp }| && |{  control_record_out-mescod }|  && |{  control_record_out-mesfct }| ).
     CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_i0507        "Constant value for WRICEF (I0502.1)
        im_ser_num     = lc_ser_nr_001   "Serial Number (001)
        im_var_key     = lv_var_key_507
      IMPORTING
        ex_active_flag = lv_active_i0507."Active / Inactive flag
     IF lv_active_i0507 EQ abap_true.    "Enhancement is Active
       INCLUDE zqtcn_knv_outinv_i0507 IF FOUND.
     ENDIF.
*EOC by VMAMILLAPA on 04/12/2022 for EAM1773 with ED2K926618 *
