*&---------------------------------------------------------------------*
*&  Include           ZXTRKU04
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU04                                         *
* PROGRAM DESCRIPTION : Add-on Change to Post GR for Zero Inventory Items*
* DEVELOPER           : SRAMASUBRA (Sankarram R)                         *
* CREATION DATE       : 2022-04-29                                       *
* OBJECT ID           : I0510.2/EAM-8766                                 *
* TRANSPORT NUMBER(S) : ED2K927114                                       *
*------------------------------------------------------------------------*

*========================================================================*
*                         VARIABLES DECLARATIONS                         *
*========================================================================*
DATA:
  lv_active_i0510_2   TYPE        zactive_flag           "Active / Inactive flag
  .

*========================================================================*
*                         CONSTANTS DECLARATIONS                         *
*========================================================================*

CONSTANTS:
   lc_i0510_2       TYPE zdevid     VALUE 'I0510.2',  "Constant value for WRICEF (I0510.2)
   lc_ser_nr_001    TYPE zsno       VALUE '001'       "Serial Number (001)
   .


* Populate the Idoc Control Record's Msg. Type, Msg. Code, Msg. Function values
DATA(lv_shpcon_key) = CONV zvar_key( |{ idoc_control-mestyp }| && |_| &&
                                     |{ idoc_control-mescod }| && |_| &&
                                     |{ idoc_control-mesfct }| ) .
CONDENSE: lv_shpcon_key.

* Enhancement Control Check
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_i0510_2         "Constant value for WRICEF (I0512.1)
    im_ser_num     = lc_ser_nr_001      "Serial Number (001)
    im_var_key     = lv_shpcon_key      "Idoc Control Record Partner Profile Key
  IMPORTING
    ex_active_flag = lv_active_i0510_2. "Active / Inactive flag

IF lv_active_i0510_2 IS NOT INITIAL.
* Call Enchancement Include to Post GR For ZI
  INCLUDE zqtcn_apl_del_if_gr_zi_i0510_2 IF FOUND.
ENDIF.
