*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for customer population
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   19/08/2016
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K902770
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902882
* REFERENCE NO:  I0219
* DEVELOPER: NALLAPANENI MOUNIKA (NMOUNIKA)
* DATE:  2016-10-3
* DESCRIPTION:  Royality Share Inbound..
* Change Tag :
* BOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *
* EOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *
*-------------------------------------------------------------------
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902639
* REFERENCE NO:  I0234
* DEVELOPER: Paramita Bose(PBOSE)
* DATE:  2016-11-03
* DESCRIPTION: Token Interface
* Change Tag :
* Begin of Change by PBOSE : 3-Nov-2016: ED2K902639
* End of Change by PBOSE : 3-Nov-2016: ED2K902639
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904122
* REFERENCE NO:  C042
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-01-19
* DESCRIPTION: Open Sales Orders Conversion
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903010
* REFERENCE NO:  I0212
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  28/08/2016
* DESCRIPTION: Inbound Sales Order Interface
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904485
* REFERENCE NO:  I0341
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-02-14
* DESCRIPTION: Inbound Interface for Agent Subscription Renewal
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904999
* REFERENCE NO:  I0343
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-03-18
* DESCRIPTION: Inbound Interface for Subscription from Socity Hosted Website
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905208
* REFERENCE NO:  I0243
* DEVELOPER: SAYANDAS (Kamalendu Chakraborty)
* DATE:  2017-04-04
* DESCRIPTION: Mesage cond set to Z13
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916726
* REFERENCE NO:  I0230.2/ERPM935
* DEVELOPER: NPOLINA( Nageswara)
* DATE:  06-Nov-2019
* DESCRIPTION: Mesage cond set to Z24 to determine SAP Material for ISSN/ASSN
*-------------------------------------------------------------------
* REVISION NO : ED2K923064                                             *
* REFERENCE NO: OTCM-23859                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 04/16/2021                                             *
* DESCRIPTION : SAP/Kiara Intergration mapping the registration code   *
*               with message variant Z12                               *
*----------------------------------------------------------------------*
*-------------------------------------------------------------------
* REVISION NO : ED2K925253                                             *
* REFERENCE NO: OTCM-47818/OTCM-51088                                  *
* DEVELOPER   : Prabhu (PTUAFARM)                                      *
* DATE        : 12/14/2021                                             *
* DESCRIPTION :Process Indian Agent  Orders with Validations - I0341   *
*              Message code-Z10 and New message function-IAG           *
*----------------------------------------------------------------------*
*-------------------------------------------------------------------
* REVISION NO :  ED2K925269                                            *
* REFERENCE NO:  OTCM-44924                                            *
* DEVELOPER   : Rajkumar Madavoina(MRAJKUMAR)                          *
* DATE        : 01/27/2022                                             *
* DESCRIPTION : As part of GOBI Requirement, after succesful validation*
*               of GOBI data, IDOC will be triggered to SAP with       *
*               sold-to-party, material details Identifcation          *
*               This enhancemnt will convert the sold-to-party, materail
*               identification into sold-to-aprty, material in IDOC and*
*               process the data                                       *
*----------------------------------------------------------------------*
* REVISION NO : ED2K926658                                             *
* REFERENCE NO: EAM-8227                                               *
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)                         *
* DATE        : 04/27/2022                                             *
* DESCRIPTION : Convertion of GLN number to Customer number for        *
*               sold to party from KNV-CLEO-SAP order Idocs            *
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_i0230 TYPE zdevid VALUE 'I0230', "Constant value for WRICEF (I0230)
  lc_ser_num_i0230_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0230   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0230 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0230 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0230
            contrl-mescod
            contrl-mesfct
INTO lv_var_key_i0230.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0230  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0230_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0230    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0230. "Active / Inactive flag

IF lv_actv_flag_i0230 = abap_true.

  INCLUDE zqtcn_insub03 IF FOUND.

ENDIF. " IF lv_actv_flag_i0230 = abap_true

* BOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *

* --------------------> Enhancement for I0219
CONSTANTS:
  lc_wricef_id_i0219 TYPE zdevid VALUE 'I0219', "Constant value for WRICEF (I0230)
  lc_ser_num_i0219_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0219   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0219 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0219 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0219
            contrl-mescod
INTO lv_var_key_i0219.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0219  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0219_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0219    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0219. "Active / Inactive flag

IF lv_actv_flag_i0219 = abap_true.
* Populate the document type and billing block in DXVBAK structure
  INCLUDE zqtcn_inbound_i0219 IF FOUND.

ENDIF. " IF lv_actv_flag_i0219 = abap_true
* EOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *


**** Enhanvement for I0212 --------------->>>>>
*** This enhancement is done to convert legacy material and legacy customer
*** and modify DXVBAK structure

CONSTANTS:
  lc_wricef_id_i0212 TYPE zdevid VALUE 'I0212', "Constant value for WRICEF (I0230)
  lc_ser_num_i0212_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0212   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0212 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0212 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0212
            contrl-mescod
INTO lv_var_key_i0212.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0212  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0212_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0212    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0212. "Active / Inactive flag

IF lv_actv_flag_i0212 = abap_true.

  INCLUDE zqtcn_inord03 IF FOUND.

ENDIF. " IF lv_actv_flag_i0212 = abap_true

* BOC by SRBOSE on 17-OCT-2016 TR#ED2K903117 *

* --------------------> Enhancement for I0233.2
*** This enhancement is done to modify DXVBAK structure and set flag
*** for BSARK and also to insert email address of customer in E1EDKA3 segment
CONSTANTS:
  lc_wricef_id_i0233_2 TYPE zdevid VALUE 'I0233.2', "Constant value for WRICEF (I0233.2)
  lc_ser_num_i0233_2   TYPE zsno   VALUE '001', "Serial Number (001)
  lc_ser_num_i0233_27  TYPE zsno   VALUE '007'.

DATA:
  lv_var_key_i0233_2   TYPE zvar_key,     "Variable Key
  lv_ser_num_i0233     TYPE zsno,
  lv_actv_flag_i0233_2 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0233_2 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0233_2
            contrl-mescod
            contrl-mesfct
 INTO lv_var_key_i0233_2.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0233_2  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0233_27    "Serial Number (003)
    im_var_key     = lv_var_key_i0233_2    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0233_2. "Active / Inactive flag

IF lv_actv_flag_i0233_2 = abap_true.

  INCLUDE zqtcn_inbound_i0233_2 IF FOUND.

ENDIF. " IF lv_actv_flag_i0233_2 = abap_true
* EOC by SRBOSE on 17-OCT-2016 TR#ED2K903117 *
**********************************************************************
*                          Token Interface                           *
**********************************************************************
* Begin of Change by PBOSE : 3-Nov-2016: ED2K902639

* Data declarations
DATA: lv_var_key_i0234 TYPE zvar_key, " Variable Key
      lv_activ_flag    TYPE flag.     " General Flag

* Constant declarations
CONSTANTS: lc_wricefid_i0234 TYPE zdevid VALUE 'I0234', " Constant value for WRICEF (I021)
           lc_z13            TYPE char3 VALUE 'Z13',
           lc_ser_num_001    TYPE zsno   VALUE '001'.   " Serial Number (001)

* Populate Variable Key
lv_var_key_i0234 = contrl-mestyp. "Message Type
*** BOC by KCHAKRABOR  on 04-APR-2017 for I0234 *********************
IF contrl-mescod = lc_z13.
  lv_var_key_i0234 = contrl-mescod.
ELSE.
  CONCATENATE lv_var_key_i0234
           contrl-mescod
INTO lv_var_key_i0234.

ENDIF.
*** EOC by KCHAKRABOR  on 04-APR-2017 for I0234 *********************

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0234 " Constant value for WRICEF
    im_ser_num     = lc_ser_num_001    " Serial Number
    im_var_key     = lv_var_key_i0234  " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_activ_flag.

* If enhancement flag is on, token interface idoc should be triggered
IF lv_activ_flag = abap_true.
  INCLUDE zqtcn_token_interface IF FOUND.
ENDIF. " IF lv_activ_flag = abap_true

* End of Change by PBOSE : 3-Nov-2016: ED2K902639

*** BOC by SAYANDAS  on 13-JAN-2017 TR#ED2K904122 *********************
*** This enhancement is done to convert legacy material and legacy customer
*** and modify DXVBAK structure
CONSTANTS:
  lc_wricef_id_i0297 TYPE zdevid VALUE 'I0297', "Constant value for WRICEF (I0297)
  lc_ser_num_i0297_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0297   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0297 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0297 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0297
            contrl-mescod
INTO lv_var_key_i0297.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0297  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0297_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0297    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0297. "Active / Inactive flag

IF lv_actv_flag_i0297 = abap_true.

  INCLUDE zqtcn_inso_i0297 IF FOUND.

ENDIF. " IF lv_actv_flag_i0212 = abap_true
*** EOC by SAYANDAS  on 13-JAN-2017 TR# ED2K904122 *********************
***<<<---- Enhancement for C042
*** This enhyancement is done for C042, to change DXVBAK structure
*** BOC by SAYANDAS  on 17-JAN-2017 for C042 *********************
CONSTANTS:
  lc_wricef_id_c042 TYPE zdevid VALUE 'C042', "Constant value for WRICEF (C042)
  lc_ser_num_c042_2 TYPE zsno   VALUE '002'.   "Serial Number (002)

DATA:
  lv_var_key_c042   TYPE zvar_key,     "Variable Key
  lv_actv_flag_c042 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_c042 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_c042
            contrl-mescod
INTO lv_var_key_c042.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_c042  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_c042_2  "Serial Number (003)
    im_var_key     = lv_var_key_c042    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_c042. "Active / Inactive flag

IF lv_actv_flag_c042 = abap_true.

  INCLUDE zqtcn_inso_c042 IF FOUND.

ENDIF. " IF lv_actv_flag_i0212 = abap_true
*** EOC by SAYANDAS  on 13-JAN-2017 TR# ED2K904122 *********************

*** BOC by PRMITRA  on 07-FEB-2017 for C063 *********************
**** This enhancement is for C063 to change DXVBAK structure.
CONSTANTS:
  lc_wricef_id_c063 TYPE zdevid VALUE 'C063', "Constant value for WRICEF (C042)
  lc_ser_num_c063   TYPE zsno   VALUE '001'.   "Serial Number (002)

DATA:
  lv_var_key_c063   TYPE zvar_key,     "Variable Key
  lv_actv_flag_c063 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_c063 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_c063
            contrl-mescod
INTO lv_var_key_c063.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_c063  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_c063    "Serial Number (003)
    im_var_key     = lv_var_key_c063    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_c063. "Active / Inactive flag

IF lv_actv_flag_c063 = abap_true.

  INCLUDE zqtcn_inso_c063 IF FOUND.

ENDIF. " IF lv_actv_flag_C063 = abap_true
*** EOC by PRMITRA  on 07-FEB-2017 *********************
***<<<---- Enhancement for C063
*** BOC by SAYANDAS  on 14-FEB-2017 TR# ED2K904485 *********************
*** This enhancement is done to convert legacy material and legacy customer
CONSTANTS:
  lc_wricef_id_i0341 TYPE zdevid VALUE 'I0341', "Constant value for WRICEF (I0297)
  lc_ser_num_i0341_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0341   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0341 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0341 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0341
            contrl-mescod
INTO lv_var_key_i0341.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0341  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0341_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0341    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0341. "Active / Inactive flag

IF lv_actv_flag_i0341 = abap_true.

  INCLUDE zqtcn_insub_i0341 IF FOUND.

ENDIF. " IF lv_actv_flag_i0315 = abap_true
*** EOC by SAYANDAS  on 14-FEB-2017 TR#  ED2K904485 *********************
*** BOC by SAYANDAS  on 09-MAR-2017 TR# ED2K904859 *********************
*** This enhancement is done to convert legacy material and legacy customer
CONSTANTS:
  lc_wricef_id_i0212_17 TYPE zdevid VALUE 'I0212.17', "Constant value for WRICEF (I0297)
  lc_ser_num_i0212_17_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0212_17   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0212_17 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0212_17 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0212_17
            contrl-mescod
INTO lv_var_key_i0212_17.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0212_17  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0212_17_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0212_17    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0212_17. "Active / Inactive flag

IF lv_actv_flag_i0212_17 = abap_true.

  INCLUDE zqtcn_inso_i0212_17 IF FOUND.

ENDIF. " IF lv_actv_flag_i0315 = abap_true
*** EOC by SAYANDAS  on 09-MAR-2017 TR# ED2K904859 *********************
*** BOC by SAYANDAS  on 18-MAR-2017 TR# ED2K904999 *********************
*** This enhancement is done to convert legacy material and legacy customer
CONSTANTS:
  lc_wricef_id_i0343 TYPE zdevid VALUE 'I0343', "Constant value for WRICEF (I0343)
  lc_ser_num_i0343_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0343   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0343 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0343 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0343
            contrl-mescod
INTO lv_var_key_i0343.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0343  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_num_i0343_1  "Serial Number (003)
    im_var_key     = lv_var_key_i0343    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0343. "Active / Inactive flag

IF lv_actv_flag_i0343 = abap_true.

  INCLUDE zqtcn_insub_i0343 IF FOUND.

ENDIF. " IF lv_actv_flag_i0315 = abap_true
*** EOC by SAYANDAS  on 18-MAR-2017 TR# ED2K904999 *********************

* SOC by NPOLINA ERPM-935 06-Nov-2019 ED2K916726
* Check if enhancement needs to be triggered for Z24
DATA: lv_var_key_i0230_2 TYPE zvar_key, " Variable Key
      lv_activ_flag_1    TYPE flag.     " General Flag

* Constant declarations
CONSTANTS: lc_wricefid_i0230_2 TYPE zdevid VALUE 'I0230.2', " Constant value for WRICEF (I021)
           lc_ser_num_001_1    TYPE zsno   VALUE '001'.   " Serial Number (001)

CLEAR:lv_activ_flag.
lv_var_key_i0230_2 = contrl-mescod.    "If Z24
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0230_2 " Constant value for WRICEF
    im_ser_num     = lc_ser_num_001_1    " Serial Number
    im_var_key     = lv_var_key_i0230_2  " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_activ_flag_1.

* If enhancement flag is on, token interface idoc should be triggered
IF lv_activ_flag_1 = abap_true.
  INCLUDE zqtcn_zppv_interface_i0230_2 IF FOUND.
ENDIF. " IF lv_activ_flag = abap_true
* EOC by NPOLINA ERPM-935 06-Nov-2019 ED2K916726

*** Begin of Change: KKRAVURI  25-DEC-2019  ED2K917150
**********************************************************************
*    WOA Subscription Order Interface
**********************************************************************
* Data declarations
DATA: lv_vkey_i0378  TYPE zvar_key, " Variable Key
      lv_aflag_i0378 TYPE flag.     " General Flag

* Constant declarations
CONSTANTS:
  lc_wricefid_i0378 TYPE zdevid VALUE 'I0378', " Constant value for WRICEF (I021)
  lc_snum_001       TYPE zsno   VALUE '001'.   " Serial Number (001)

* Populate Variable Key
lv_vkey_i0378 = contrl-mescod.    " Message Variant: Z25

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0378 " Constant value for WRICEF
    im_ser_num     = lc_snum_001       " Serial Number
    im_var_key     = lv_vkey_i0378     " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_aflag_i0378.
* If enhancement flag is on, WOA Sub Ord interface idoc should be triggered
IF lv_aflag_i0378 = abap_true.
  INCLUDE zqtcn_woa_insub_ord_i0378 IF FOUND.
ENDIF.
*** End of Change: KKRAVURI  25-DEC-2019  ED2K917150

* BOC by Lahiru on 04/16/2021 for OTCM-23859 with ED2K923064  *
CONSTANTS: lc_wricef_id_e264 TYPE zdevid VALUE 'E264',  " Constant value for WRICEF (E264)
           lc_ser_num_e264   TYPE zsno   VALUE '001'.   " Serial Number (001)

DATA: lv_var_key_e264   TYPE zvar_key,     " Variable Key
      lv_actv_flag_e264 TYPE zactive_flag. " Active / Inactive flag

* Populate Variable Key
lv_var_key_e264 = dxmescod.           " Message variant Z12

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e264    " Constant value for WRICEF (E264)
    im_ser_num     = lc_ser_num_e264      " Serial Number (001)
    im_var_key     = lv_var_key_e264      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_e264.   " Active / Inactive flag

IF lv_actv_flag_e264 = abap_true.
  INCLUDE zqtcn_kiara_ord_fill_e264_1 IF FOUND.
ENDIF.
* EOC by Lahiru on 04/16/2021 for OTCM-23859 with ED2K923064  *

***************************************************************************
*--*BOC Prabhu OTCM-47818/OTCM-51088 TR ED2K925253 12/14/2021
*** This enhancement is to process Indian agent orders
CONSTANTS:
  lc_ser_num_i0341_5 TYPE zsno   VALUE '005'.   "Serial Number (005)
DATA:
  lv_var_key_i0341_005 TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0341_5 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0341_005 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0341_005
            contrl-mescod contrl-mesfct
INTO lv_var_key_i0341_005.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0341      "Constant value for WRICEF (I0341)
    im_ser_num     = lc_ser_num_i0341_5      "Serial Number (005)
    im_var_key     = lv_var_key_i0341_005    "Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0341_5. "Active / Inactive flag

IF lv_actv_flag_i0341_5 = abap_true.
  INCLUDE zqtcn_insub_indian_agt_i0341 IF FOUND.
ENDIF. " IF lv_actv_flag_i0341_5 = abap_true
*--*EOC Prabhu OTCM-47818/OTCM-51088 TR ED2K925253 12/14/2021
***************************************************************************
* SOC by MRAJKUMAR OTCM-44924 27-Jan-2022 ED2K925269
* Check if enhancement needs to be triggered for Z15
DATA: lv_var_key_i0233_5_2 TYPE zvar_key, " Variable Key
      lv_activ_flag_2    TYPE flag.     " General Flag

* Constant declarations
CONSTANTS: lc_i                  TYPE char1  VALUE 'I',
           lc_eq                 TYPE char2  VALUE 'EQ',
           lc_wricefid_i0233_5_2 TYPE zdevid VALUE 'I0233.5', " Constant value for WRICEF (I021)
           lc_ser_num_001_2      TYPE zsno   VALUE '002',   " Serial Number (001)
           lc_mescod             TYPE char6  VALUE 'MESCOD',
           lc_mesfct             TYPE char6  VALUE 'MESFCT',
           lc_sndpor             TYPE char6  VALUE 'SNDPOR',
           lc_buyerid            TYPE c LENGTH 7 VALUE 'BUYERID',"MRAJKUMAR OTCM-44924 07-Feb-2022 ED2K925700
           lc_partnertype        TYPE c LENGTH 12 VALUE 'PARTNER TYPE',
           lc_idcodetype         TYPE c LENGTH 10  VALUE 'IDCODETYPE'.
*Tables declarations
 DATA: lir_mescod TYPE RANGE OF edi_mescod,
       lv_mescod  LIKE LINE OF lir_mescod,
       lir_mesfct TYPE RANGE OF edi_mesfct,
       lv_mesfct  LIKE LINE OF lir_mesfct,
       lir_sndpor TYPE RANGE OF edi_sndpor,
       lv_sndpor  LIKE LINE OF lir_sndpor,
       lv_buyerid TYPE char35,"MRAJKUMAR OTCM-44924 07-Feb-2022 ED2K925700
       lir_type   TYPE TABLE OF  zukm_s_range_bu_id_type,
       lir_idcodetype     TYPE RANGE OF ismidcodetype,
       lv_idcodetype      LIKE LINE OF lir_idcodetype,
       lv_type            TYPE zukm_s_range_bu_id_type.
"Free the internal tables
 FREE: lir_mescod,
       lir_mesfct,
       lir_sndpor,
       lir_type.
"Clear the variables
 CLEAR: lv_mescod,
        lv_mesfct,
        lv_sndpor,
        lv_type.
CLEAR:lv_activ_flag.
lv_var_key_i0233_5_2 = contrl-mescod.    "If Z15
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0233_5_2 " Constant value for WRICEF
    im_ser_num     = lc_ser_num_001_2    " Serial Number
    im_var_key     = lv_var_key_i0233_5_2  " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_activ_flag_2.
IF   sy-subrc IS INITIAL
AND  lv_activ_flag_2 IS NOT INITIAL.
"Fetching Entries from Constant Table
   SELECT devid,
          param1,
          param2,
          srno,
          sign,
          opti,
          low,
          high,
          activate
     FROM zcaconstant
     INTO TABLE @DATA(li_const_entries)
    WHERE devid    EQ @lc_wricefid_i0233_5_2
      AND activate EQ @abap_true.
   IF  sy-subrc           IS INITIAL
   AND li_const_entries   IS NOT INITIAL.
     LOOP AT li_const_entries
       INTO DATA(wa_constant).
       CASE: wa_constant-param1.
         WHEN: lc_mescod.
           lv_mescod-sign   = lc_i.
           lv_mescod-option = lc_eq.
           lv_mescod-low    = wa_constant-low.
           APPEND lv_mescod TO lir_mescod.
           CLEAR lv_mescod.
         WHEN: lc_mesfct.
           lv_mesfct-sign   = lc_i.
           lv_mesfct-option = lc_eq.
           lv_mesfct-low    = wa_constant-low.
           APPEND lv_mesfct TO lir_mesfct.
           CLEAR lv_mesfct.
         WHEN: lc_sndpor.
           lv_sndpor-sign   = lc_i.
           lv_sndpor-option = lc_eq.
           lv_sndpor-low    = wa_constant-low.
           APPEND lv_sndpor TO lir_sndpor.
           CLEAR lv_sndpor.
         WHEN: lc_partnertype.
           lv_type-sign   = lc_i.
           lv_type-option = lc_eq.
           lv_type-low    = wa_constant-low.
           APPEND lv_type TO lir_type.
           CLEAR lv_type.
         WHEN: lc_idcodetype.
           lv_idcodetype-sign   = lc_i.
           lv_idcodetype-option = lc_eq.
           lv_idcodetype-low    = wa_constant-low.
           APPEND lv_idcodetype TO lir_idcodetype.
           CLEAR lv_idcodetype.
* Stat of Change by MRAJKUMAR OTCM-44924 07-Feb-2022 ED2K925700
         WHEN: lc_buyerid.
           lv_buyerid           = wa_constant-low.
* End of change by MRAJKUMAR OTCM-44924 07-Feb-2022 ED2K925700
       ENDCASE.
     ENDLOOP.
* Checking MESCOD, MESFCT and SNPOR details from control record with constant table
* entries. If satisfies then changing sold-to-party,ship-to-party  and material details
     IF  contrl-mescod IN lir_mescod[]
     AND contrl-mesfct IN lir_mesfct[]
     AND contrl-sndpor IN lir_sndpor[].
       INCLUDE zqtcn_gobi_idoc_i0233_5 IF FOUND.
     ENDIF.
   ENDIF.
ENDIF.
* EOC by MRAJKUMAR OTCM-44924 27-Jan-2022 ED2K925269
* BOC by VMAMILLAPA EAM-8227 07-Apr-2022 ED2K926658
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
  CONSTANTS:
    lc_i0504_1        TYPE zdevid VALUE 'I0504.1', "Constant value for WRICEF (I0502.1)
    lc_ser_nr_002     TYPE zsno   VALUE '002'.   "Serial Number (003)
*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
  DATA:lv_active_i0504_1 TYPE zactive_flag.         "Active / Inactive flag
*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
  DATA(lv_var_key) = CONV zvar_key( |{ contrl-mestyp }| && |_| && |{ contrl-mescod }| && |_| && |{ contrl-mesfct }| ).

  CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_i0504_1         "Constant value for WRICEF (I0502.1)
    im_ser_num     = lc_ser_nr_002      "Serial Number (002)
    im_var_key     = lv_var_key         "Variable Key
  IMPORTING
    ex_active_flag = lv_active_i0504_1. "Active / Inactive flag
  IF lv_active_i0504_1 IS NOT INITIAL.
    INCLUDE zqtcn_inb_ord_conv_knv_i0504 IF FOUND.
  ENDIF.
* EOC by VMAMILLAPA EAM-8227 07-Apr-2022 ED2K926658
