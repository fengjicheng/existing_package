class ZCL_IM_QTCN_IDOC_DATA_MAP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_IDOC_DATA_MAPPER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCN_IDOC_DATA_MAP IMPLEMENTATION.


  method IF_EX_IDOC_DATA_MAPPER~PROCESS.
*----------------------------------------------------------------------*
* REVISION NO: ED2K926194 ---------------------------------------------*
* REFERENCE NO: OTCM-54171/2 (I0230)
* DEVELOPER: Polina Nageswara / Bharat kumar saki (bsaki) / Raj
* DATE: 18-April-2022
* DESCRIPTION: Item partner segment data removing if the header partner
*              segment data is same ship-to-party(WE) because
*              Contact names changing between times of invoice generation
*----------------------------------------------------------------------*
*** BOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220419 for WE-Shipto Name_CO
    CONSTANTS:
      lc_wricef_id_i0230_c TYPE zdevid VALUE 'I0230', "Constant value for WRICEF (I0230)
      lc_ser_num_i0230_1_c TYPE zsno   VALUE '001'.   "Serial Number (001)

    DATA:
      lv_var_key_i0230_c   TYPE zvar_key,     "Variable Key
      lv_actv_flag_i0230_c TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
    lv_var_key_i0230_c = control-mestyp. "Message Type
    CONCATENATE lv_var_key_i0230_c
                control-mescod
                control-mesfct
    INTO lv_var_key_i0230_c.

* Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_i0230_c  "Constant value for WRICEF (C030)
        im_ser_num     = lc_ser_num_i0230_1_c  "Serial Number (003)
        im_var_key     = lv_var_key_i0230_c    "Variable Key (Message Type)
      IMPORTING
        ex_active_flag = lv_actv_flag_i0230_c. "Active / Inactive flag
    IF lv_actv_flag_i0230_c = abap_true.
      INCLUDE ZQTCN_INSUB_NEW IF FOUND .
    ENDIF. " IF lv_actv_flag_i0230_c = abap_true
*** EOC: OTCM-54171 by NPOLINA/BSAKI ED2K926194 20220419 for WE-Shipto Name_CO
  endmethod.
ENDCLASS.
