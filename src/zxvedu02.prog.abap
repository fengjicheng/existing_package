*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   24/08/2016
* OBJECT ID: I0229
* TRANSPORT NUMBER(S): ED2K902778, ED2K90781 (Dependent)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Murali (MIMMADISET)
* CREATION DATE:   11/11/2019
* OBJECT ID: I0229.9 (ERPM-5900)
* TRANSPORT NUMBER(S):Contract start and end date mismatching in ALM and Moodle
*due to these date are not in SAP IDOC
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K921221
* REFERENCE NO:  OTCM-28269
* WRICEF NO   :  I0229
* DEVELOPER:     Lahiru Wathudura (LWATHUDURA)
* DATE:          01/27/2021
* DESCRIPTION:   change for release order cancellation
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K921759
* REFERENCE NO:  OTCM-1375
* WRICEF NO   :  I0229
* DEVELOPER:     Lahiru Wathudura (LWATHUDURA)
* DATE:          01/27/2021
* DESCRIPTION:   Acceptance Date interface
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K921925
* REFERENCE NO:  OTCM-1375/OTCM-28269
* WRICEF NO   :  I0229
* DEVELOPER:     Lahiru Wathudura (LWATHUDURA)
* DATE:          01/27/2021
* DESCRIPTION:   Separate TR for remove the Confilct for OTCM-1375
*                OTCM-28269
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K921925
* REFERENCE NO:  OTCM-40685
* WRICEF NO   :  I0229
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* DATE:          09/21/2021
* DESCRIPTION:   Update ACTION field for Output Type ZOA2
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K926544
* REFERENCE NO:  EAM-6905
* WRICEF NO   :  I0505
* DEVELOPER:     Jagadeeswara Rao M (JMADAKA)
* DATE:          03/23/2022
* DESCRIPTION:   Logic to fill and populate custom fields for KNV as part
*                APL project
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  ED2K926811
* REFERENCE NO:  EAM-6881
* WRICEF NO   :  I0511
* DEVELOPER:     Jagadeeswara Rao M (JMADAKA)
* DATE:          04/14/2022
* DESCRIPTION:   Logic to fill and populate custom fields to UK Core as part
*                APL project
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0229 TYPE zdevid VALUE 'I0229', "Constant value for WRICEF (I0229)
    lc_ser_num_i0229_1 TYPE zsno   VALUE '001',   "Serial Number (001)
    lc_wricef_id_i0228 TYPE zdevid VALUE 'I0228', "Constant value for WRICEF (I0228)
    lc_ser_num_i0228_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

  DATA:
    lv_var_key_i0229   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0229 TYPE zactive_flag, "Active / Inactive flag
    lv_var_key_i0228   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0228 TYPE zactive_flag. "Active / Inactive flag

* BOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568/ED2K924881*
* Implementing I0229/009 Logic Before I0229/001 as 001 is adding new segment "Z1QTC_E1EDP01_01"
  CONSTANTS: lc_ser_num_i0229_09 TYPE zsno   VALUE '009'.     " Sequence Number (009)

  DATA: lv_var_key_i0229_09   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0229_09   TYPE zsno,          " Serial Number
        lv_actv_flag_i0229_09 TYPE zactive_flag.  " Active / Inactive flag

  lv_var_key_i0229_09 = control_record_out-mestyp. "Message Type

  CONCATENATE lv_var_key_i0229_09         " Message Type
              control_record_out-mesfct   " Message Function  mescod
  INTO lv_var_key_i0229_09.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229       " Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_09       " Serial Number (009)
      im_var_key     = lv_var_key_i0229_09       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_09.    "Active / Inactive flag
  IF lv_actv_flag_i0229_09 = abap_true .
    INCLUDE zqtcn_segment_fill_i0229_09 IF FOUND.
  ENDIF.
* EOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568/ED2K924881*

**************** For I0229 ------------------------->>>>>>>>>>>>>>
*** This Enhancement is for Outbound IDOC for Subscription Order
*** Segment population is done within the include
* Populate Variable Key
* The following is used for all Subscription Order Outbound Interface
* The include is used for different segment population of IDOC
* Which is not done by standard
  lv_var_key_i0229 = control_record_out-mestyp. "Message Type

  CONCATENATE lv_var_key_i0229            " Message Type
              control_record_out-mescod   " Message Function
  INTO lv_var_key_i0229.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229  "Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_1  "Serial Number (001)
      im_var_key     = lv_var_key_i0229    "Variable Key (Message Type + Message Function)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229. "Active / Inactive flag

  IF lv_actv_flag_i0229 = abap_true.

    INCLUDE zqtcn_ousub02 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0229 = abap_true
********<<<<<<<<<<<<<<--------------------------- For I0229  ******************

**************** For I0228 ------------------------->>>>>>>>>>>>>>
*** This Enhancement is for Outbound IDOC for Sales Order
*** Segment population is done within the include
* Populate Variable Key
  lv_var_key_i0228 = control_record_out-mestyp. "Message Type

  CONCATENATE lv_var_key_i0228            " Message Type
              control_record_out-mescod   " Message Function
  INTO lv_var_key_i0228.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0228  "Constant value for WRICEF (I0228)
      im_ser_num     = lc_ser_num_i0228_1  "Serial Number (001)
      im_var_key     = lv_var_key_i0228    "Variable Key (Message Type + Message Function)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0228. "Active / Inactive flag

  IF lv_actv_flag_i0228 = abap_true.

    INCLUDE zqtcn_ouord02 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0228 = abap_true
********<<<<<<<<<<<<<<--------------------------- For I0228  ******************
*  data: l_flag TYPE xfeld.
*  do.
*    if l_flag = 'X'.
*      exit.
*    endif.
*  enddo.
********<<<<<<<<<<<<<<-----------For I0229 Credit memo  ******************
  CONSTANTS:
    lc_wricef_id_i0229_cr TYPE zdevid VALUE 'I0229',     "Constant value for WRICEF (I0229)
    lc_ser_num_i0229_5    TYPE zsno   VALUE '005'.       "Serial Number (005)

  DATA:
    lv_actv_flag_i0229_cr TYPE zactive_flag.             "Active / Inactive flag

* Custom Logic
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229_cr             "Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_5               "Serial Number (005)
      im_var_key     = lv_var_key_i0229                "Message type + Message code
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_cr.            "Active / Inactive flag
  IF lv_actv_flag_i0229_cr = abap_true.
    INCLUDE zqtcn_cr_ack_add_fields_i0229 IF FOUND.
  ENDIF.
********<<<<<<<<<<<<<<-----------For I0229 Credit memo  ******************
**************** For I0229.9 ------------------------->>>>>>>>>>>>>>
*** This Enhancement is for Outbound IDOC for AC B2C Ord
*** Segment population is done within the include
* Populate Variable Key
* The following is used for all AC B2C Order Outbound Interface
* The include is used for different segment population of IDOC
* Which is not done by standard
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0229_9 TYPE zdevid VALUE 'I0229.9', "Constant value for WRICEF (I0229.9)
    lc_ser_num_i0229_1_9 TYPE zsno   VALUE '001'.   "Serial Number (001)

  DATA:
    lv_var_key_i0229_9   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0229_9 TYPE zactive_flag. "Active / Inactive flag

  lv_var_key_i0229_9 = control_record_out-mestyp. "Message Type

  CONCATENATE lv_var_key_i0229_9            " Message Type
              control_record_out-mescod   " Message Function
  INTO lv_var_key_i0229_9.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229_9  "Constant value for WRICEF (I0229.9)
      im_ser_num     = lc_ser_num_i0229_1_9  "Serial Number (001)
      im_var_key     = lv_var_key_i0229_9    "Variable Key (Message Type + Message Function)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_9. "Active / Inactive flag

  IF lv_actv_flag_i0229_9 = abap_true.

    INCLUDE  zqtcn_outbound_i0229_9 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0229 = abap_true

* BOC by Lahiru on 02/16/2021 for OTCM-28269/OTCM-1375 with ED2K921925*
* BOC by Lahiru on 01/27/2021 for OTCM-28269 with ED2K921221*
* IDOC with Message Variant ---- ,
  CONSTANTS: lc_ser_num_i0229_7 TYPE zsno   VALUE '007'.     " Sequence Number (007)

  DATA: lv_var_key_i0229_7   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0229_7   TYPE zsno,          " Serial Number
        lv_actv_flag_i0229_7 TYPE zactive_flag.  " Active / Inactive flag

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229       " Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_7       " Serial Number (007)
      im_var_key     = lv_var_key_i0229_7       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_7.    "Active / Inactive flag
  IF lv_actv_flag_i0229_7 = abap_true .
    INCLUDE zqtcn_segment_fill_i0229_7 IF FOUND.
  ENDIF.
* EOC by Lahiru on 01/27/2021 for OTCM-28269 with ED2K921221*


* BOC by Lahiru on 01/26/2021 for OTCM-1375 with ED2K921759*
  CONSTANTS: lc_ser_num_i0229_8 TYPE zsno   VALUE '008'.     " Sequence Number (008)

  DATA: lv_var_key_i0229_8   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0229_8   TYPE zsno,          " Serial Number
        lv_actv_flag_i0229_8 TYPE zactive_flag.  " Active / Inactive flag

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229       " Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_8       " Serial Number (008)
      im_var_key     = lv_var_key_i0229_8       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_8.    "Active / Inactive flag
  IF lv_actv_flag_i0229_8 = abap_true .
    INCLUDE zqtcn_segment_fill_i0229_8 IF FOUND.
  ENDIF.
* EOC by Lahiru on 01/26/2021 for OTCM-1375 with ED2K921759*
* EOC by Lahiru on 02/16/2021 for OTCM-28269/OTCM-1375 with ED2K921925*

* BOC by JMADAKA on 03/23/2022 for EAM-6905/I0505 with ED2K926544*
  CONSTANTS: lc_wricef_id_i0505 TYPE zdevid VALUE 'I0505.1', "Constant value for WRICEF (I0505)
             lc_ser_num_i0505_1 TYPE zsno   VALUE '001'.     " Sequence Number (001)

  DATA: lv_var_key_i0505_1   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0505_1   TYPE zsno,          " Serial Number
        lv_actv_flag_i0505_1 TYPE zactive_flag.  " Active / Inactive flag

  CONCATENATE control_record_out-mestyp   " Message Type
              control_record_out-mescod   " Message Variant
              control_record_out-mesfct   " Message Function
  INTO lv_var_key_i0505_1.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0505       " Constant value for WRICEF (I0505)
      im_ser_num     = lc_ser_num_i0505_1       " Serial Number (001)
      im_var_key     = lv_var_key_i0505_1       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0505_1.    "Active / Inactive flag
  IF lv_actv_flag_i0505_1 = abap_true.
    INCLUDE zqtcn_add_fields_knv_i0505_01 IF FOUND.
  ENDIF.
* EOC by JMADAKA on 03/23/2022 for EAM-6905/I0505 with ED2K926544*

* BOC by JMADAKA on 04/14/2022 for EAM-6881/I0511 with ED2K926811*
  CONSTANTS: lc_wricef_id_i0511 TYPE zdevid VALUE 'I0511.1', "Constant value for WRICEF (I0511)
             lc_ser_num_i0511_1 TYPE zsno   VALUE '001'.     " Sequence Number (001)

  DATA: lv_var_key_i0511_1   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0511_1   TYPE zsno,          " Serial Number
        lv_actv_flag_i0511_1 TYPE zactive_flag.  " Active / Inactive flag

  CONCATENATE control_record_out-mestyp   " Message Type
              control_record_out-mescod   " Message Variant
              control_record_out-mesfct   " Message Function
  INTO lv_var_key_i0511_1.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0511       " Constant value for WRICEF (I0511)
      im_ser_num     = lc_ser_num_i0511_1       " Serial Number (001)
      im_var_key     = lv_var_key_i0511_1       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0511_1.    "Active / Inactive flag
  IF lv_actv_flag_i0511_1 = abap_true.
    INCLUDE zqtcn_add_flds_ukcore_i0511_01 IF FOUND.
  ENDIF.
* EOC by JMADAKA on 04/14/2022 for EAM-6881/I0511 with ED2K926811*
