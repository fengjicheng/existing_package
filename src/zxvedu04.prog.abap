
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU04 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   19/08/2016
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K902770
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* TRANSPOERT NO: ED2K903010
* REFERENCE NO:  I0212
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  28/08/2016
* DESCRIPTION: Inbound Sales Order Interface
*-------------------------------------------------------------------
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
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902885
* REFERENCE NO:  C042
* DEVELOPER: SWAGATA MUKHERJEE (SWMUKHERJE)
* DATE:  2016-10-20
* DESCRIPTION:  Open sales order conversion
* Change Tag :
* BOC by SWMUKHERJE on 20-OCT-2016 TR#ED2K902885 *
* EOC by SWMUKHERJE on 20-OCT-2016 TR#ED2K902885 *
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904485
* REFERENCE NO:  I0341
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-02-14
* DESCRIPTION: Inbound Interface for Agent Subscription Renewal
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904859
* REFERENCE NO:  I0212.17
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-03-09
* DESCRIPTION: Inbound Sales Order from WOL Book Store
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904999
* REFERENCE NO:  I0343
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-03-18
* DESCRIPTION: Inbound Interface for Subscription for Socity Hosted Website
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905681
* REFERENCE NO:  I0234 (CR 528 )
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2017-05-22
* DESCRIPTION: Inbound Token Interface
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:  E097 (CR# 384 )
* DEVELOPER: PBOSE (Paramita Bose)
* DATE:  2017-06-27
* DESCRIPTION: Populate payment method and Reference document number
*              while creating renewal order.
*-------------------------------------------------------------------
* REVISION NO: ED2K909381
* REFERENCE NO: SAP Recommendations
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE: 20-Nov-2017
* DESCRIPTION: As per SAP recommendations we have optimized the code to ensure
*              that only once each screen is called to avoid unnecessary navigation.
*              Created a new include and commented the existing one.
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:  I0358
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE:  2018-08-16
* DESCRIPTION: Single File Upload for Order and Society.
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916260
* REFERENCE NO:  I0230.1
* DEVELOPER:     NPOLINA (Nageswara)
* DATE:          2019-09-25
* DESCRIPTION:   ZACO Order Creation with Message Variant Z20.
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916726
* REFERENCE NO:  I0230.2/ERPM935
* DEVELOPER: NPOLINA( Nageswara)
* DATE:  06-Nov-2019
* DESCRIPTION: Mesage cond set to Z14 to custom population
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918072
* REFERENCE NO:  I0230.22/ERPM-11341
* DEVELOPER: mimmadiset(murali)
* DATE: 29-04-2020
* DESCRIPTION: WLS order creation with message variant Z26
*-------------------------------------------------------------------
* REVISION NO : ED2K922541                                             *
* REFERENCE NO: OTCM-23859                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 03/14/2021                                             *
* DESCRIPTION : SAP/Kiara Intergration mapping the registration code   *
*               with message variant Z12                               *
*----------------------------------------------------------------------*
* REVISION NO : ED2K924060                                             *
* REFERENCE NO: OTCM- 45037                                            *
* DEVELOPER   : Murali (mimmadiset)                                    *
* DATE        : 07/10/2021                                             *
* DESCRIPTION : populate header Sold-to Email ID for standing orders from
*               custom segment  if supplementary PO is ‘SO’.           *
*               with message variant Z12                               *
*----------------------------------------------------------------------*
*-------------------------------------------------------------------
* REVISION NO : ED2K925253                                             *
* REFERENCE NO: OTCM-47818/OTCM-51088                                  *
* DEVELOPER   : VDPATABALL                                      *
* DATE        : 12/14/2021                                             *
* DESCRIPTION :Process Indian Agent  Orders with Validations - I0341   *
*              Message code-Z10 and New message function-IAG           *
*----------------------------------------------------------------------*
* REVISION NO : ED2K926658                                             *
* REFERENCE NO: EAM-8227                                               *
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)                         *
* DATE        : 04/27/2022                                             *
* DESCRIPTION : Enhancement to populate ship to party reference        *
*               for message code APL                                   *
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0230 TYPE zdevid VALUE 'I0230', "Constant value for WRICEF (C030)
    lc_ser_num_i0230_2 TYPE zsno   VALUE '002'.   "Serial Number (003)

  DATA:
    lv_var_key_i0230   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0230 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0230 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0230  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0230_2  "Serial Number (003)
      im_var_key     = lv_var_key_i0230    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0230. "Active / Inactive flag

  IF lv_actv_flag_i0230 = abap_true.
* BOC by PBANDLAPAL on 20-Nov-2017 ED2K909381
*    INCLUDE zqtcn_insub04 IF FOUND.
    INCLUDE zqtcn_insub04_new IF FOUND.
* EOC by PBANDLAPAL on 20-Nov-2017 ED2K909381
  ENDIF. " IF lv_actv_flag_i0230 = abap_true

* Begin of change: PBOSE: 27-06-2017: CR#384: ED2K905720
  CONSTANTS:
    lc_wricef_id_e097 TYPE zdevid VALUE 'E097', "Constant value for WRICEF (C030)
    lc_ser_num_e097   TYPE zsno   VALUE '001'.  "Serial Number (003)

  DATA:
    lv_var_key_e097   TYPE zvar_key,     "Variable Key
    lv_actv_flag_e097 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_e097 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e097  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_e097    "Serial Number (003)
      im_var_key     = lv_var_key_e097    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e097. "Active / Inactive flag

  IF lv_actv_flag_e097 = abap_true.

    INCLUDE zqtcn_lockbox_renew IF FOUND.

  ENDIF. " IF lv_actv_flag_e097 = abap_true

* End of change: PBOSE: 27-06-2017: CR#384: ED2K905720

* BOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *
* -----> Enhancement for I0219

  CONSTANTS:
    lc_wricef_id_i0219 TYPE zdevid VALUE 'I0219', "Constant value for WRICEF (I0230)
    lc_ser_num_i0219_1 TYPE zsno   VALUE '002'.   "Serial Number (001)

  DATA:
    lv_var_key_i0219   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0219 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0219 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0219  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0219_1  "Serial Number (003)
      im_var_key     = lv_var_key_i0219    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0219. "Active / Inactive flag

  IF lv_actv_flag_i0219 = abap_true.

* This enhancement is required to modify the BDC table (BDCDATA),
* which is used to create the sales order in idoc.
* We are populating billing block (VBAK-FAKSK) value.

    INCLUDE zqtcn_inbound_bdc_i0219 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0219 = abap_true

* EOC by NMOUNIKA on 3-OCT-2016 TR#ED2K902882 *
*----------------------->>>>>> Enhancement for I0212
***This include is to change BDCDATA table. KUNNR, FAKSK, BSTKD is inserted within BDCDATA.
  CONSTANTS:
    lc_wricef_id_i0212 TYPE zdevid VALUE 'I0212', "Constant value for WRICEF (I0230)
    lc_ser_num_i0212_1 TYPE zsno   VALUE '002'.   "Serial Number (001)

  DATA:
    lv_var_key_i0212   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0212 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0212 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0212  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0212_1  "Serial Number (003)
      im_var_key     = lv_var_key_i0212    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0212. "Active / Inactive flag

  IF lv_actv_flag_i0212 = abap_true.

    INCLUDE zqtcn_inbound_bdc_i0212 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0212 = abap_true



* --------------------> Enhancement for I0233.2
*** This enhancement is to change BDCDATA table. VBEGDAT, BSTDK, FKDDAT, KONDA
*** fields are inserted in BDCDATA table
  CONSTANTS:
    lc_wricef_id_i0233_2 TYPE zdevid VALUE 'I0233.2', "Constant value for WRICEF (I0233.2)
    lc_ser_num_i0233_2   TYPE zsno   VALUE '002', "Serial Number (001)
    lc_ser_num_i0233_8   TYPE zsno   VALUE '008'. " Serial Number

  DATA:
    lv_var_key_i0233_2   TYPE zvar_key,     "Variable Key
    lv_ser_num_i0233     TYPE zsno,         " Serial Number
    lv_actv_flag_i0233_2 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0233_2 = dxmescod. "Message Code

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0233_2  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0233_8    "Serial Number (003)
      im_var_key     = lv_var_key_i0233_2    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0233_2. "Active / Inactive flag

  IF lv_actv_flag_i0233_2 = abap_true.

    INCLUDE zqtcn_inbound_bdc_i0233_2 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0233_2 = abap_true

* BOC by SWMUKHERJE on 20-OCT-2016 TR#ED2K902885 *************
************* Start of Enhancement for C042*******************
*** This enhancement is for C042 and this is to change BDCDATA structure.
  CONSTANTS:
    lc_wricef_id_c042 TYPE zdevid VALUE 'C042', "Constant value for WRICEF (C042)
    lc_ser_num_c042   TYPE zsno   VALUE '001'.  "Serial Number (001)

  DATA:
    lv_var_key_c042   TYPE zvar_key,     "Variable Key
    lv_actv_flag_c042 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_c042 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_c042  "Constant value for WRICEF (C042)
      im_ser_num     = lc_ser_num_c042    "Serial Number (001)
      im_var_key     = lv_var_key_c042    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_c042. "Active / Inactive flag

  IF lv_actv_flag_c042 = abap_true.

    INCLUDE zqtcn_sales_order_conv_c042 IF FOUND.

  ENDIF. " IF lv_actv_flag_c042 = abap_true
************** End of Enhancement for C042*******************
* EOC by SWMUKHERJE on 20-OCT-2016 TR#ED2K902885 ***********

*** BOC by SAYANDAS  on 13-JAN-2017 TR#ED2K904122 *********************
*** This Enhancement is to Modify BDCDATA, we are inserting Promocode, Article number
**** in BDCDATA
  CONSTANTS:
    lc_wricef_id_i0297 TYPE zdevid VALUE 'I0297', "Constant value for WRICEF (I0297)
    lc_ser_num_i0297_1 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_var_key_i0297   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0297 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0297 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0297  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0297_1  "Serial Number (003)
      im_var_key     = lv_var_key_i0297    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0297. "Active / Inactive flag

  IF lv_actv_flag_i0297 = abap_true.

    INCLUDE zqtcn_inso_bdc_i0297 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0297 = abap_true
*** EOC by SAYANDAS  on 13-JAN-2017 TR#ED2K904122 *********************

*** BOC by PRMITRA  on 07-FEB-2017 TR# ED2K904103 *********************
  CONSTANTS:
    lc_wricef_id_c063 TYPE zdevid VALUE 'C063', "Constant value for WRICEF (I0297)
    lc_ser_num_c063   TYPE zsno   VALUE '002'.  "Serial Number (002)

  DATA:
    lv_var_key_c063   TYPE zvar_key,     "Variable Key
    lv_actv_flag_c063 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_c063 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_c063  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_c063    "Serial Number (003)
      im_var_key     = lv_var_key_c063    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_c063. "Active / Inactive flag

  IF lv_actv_flag_c063 = abap_true.

    INCLUDE zqtcn_subs_order_conv_c063 IF FOUND.

  ENDIF. " IF lv_actv_flag_c063 = abap_true
*** EOC by PRMITRA  on 07-FEB-2017 TR# ED2K904103 *********************
*** BOC by SAYANDAS  on 14-FEB-2017 TR# ED2K904485 *********************
*** This Enhancement is to Modify BDCDATA, we are inserting Assignment, Contract Date
**** , Transportation ID in BDCDATA
  CONSTANTS:
    lc_wricef_id_i0341 TYPE zdevid VALUE 'I0341', "Constant value for WRICEF (I0341)
    lc_ser_num_i0341_1 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_var_key_i0341   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0341 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0341 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0341  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0341_1  "Serial Number (003)
      im_var_key     = lv_var_key_i0341    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0341. "Active / Inactive flag

  IF lv_actv_flag_i0341 = abap_true.

    INCLUDE zqtcn_insub_bdc_i0341 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0341 = abap_true
*** EOC by SAYANDAS  on 14-FEB-2017 TR# ED2K904485 *********************
*** BOC by SAYANDAS  on 09-MAR-2017 TR# ED2K904859 *********************
*** This Enhancement is to Modify BDCDATA, we are inserting Assignment, Contract Date
**** , Transportation ID in BDCDATA
  CONSTANTS:
    lc_wricef_id_i0212_17 TYPE zdevid VALUE 'I0212.17', "Constant value for WRICEF (I0212.17)
    lc_ser_num_i0212_17_1 TYPE zsno   VALUE '002'. "Serial Number (002)

  DATA:
    lv_var_key_i0212_17   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0212_17 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0212_17 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0212_17  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0212_17_1  "Serial Number (003)
      im_var_key     = lv_var_key_i0212_17    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0212_17. "Active / Inactive flag

  IF lv_actv_flag_i0212_17 = abap_true.

    INCLUDE zqtcn_inso_bdc_i0212_17 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0212_17 = abap_true
*** EOC by SAYANDAS  on 09-MAR-2017 TR# ED2K904859 *********************
*** BOC by SAYANDAS  on 18-MAR-2017 TR# ED2K904999 *********************
*** This Enhancement is to Modify BDCDATA, we are inserting Assignment, Contract Date
**** , Transportation ID in BDCDATA
  CONSTANTS:
    lc_wricef_id_i0343 TYPE zdevid VALUE 'I0343', "Constant value for WRICEF (I0212.17)
    lc_ser_num_i0343_2 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_var_key_i0343   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0343 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0343 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0343  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0343_2  "Serial Number (003)
      im_var_key     = lv_var_key_i0343    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0343. "Active / Inactive flag

  IF lv_actv_flag_i0343 = abap_true.

    INCLUDE zqtcn_insub_bdc_i0343 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0343 = abap_true
*** EOC by SAYANDAS  on 18-MAR-2017 TR# ED2K904999 *********************
*** BOC by ARABANERJE  on 07-APR-2017 TR#ED2K905240*********************
* Creating quotation without reference(ZQT) and with reference to Subscription Order(ZSQT)
  CONSTANTS:
    lc_wricef_id_c064 TYPE zdevid VALUE 'C064', "Constant value for WRICEF (C064)
    lc_ser_num_c064   TYPE zsno   VALUE '001'.  "Serial Number (002)

  DATA:
    lv_var_key_c064   TYPE zvar_key,     "Variable Key
    lv_actv_flag_c064 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_c064 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_c064  "Constant value for WRICEF (C064)
      im_ser_num     = lc_ser_num_c064    "Serial Number (003)
      im_var_key     = lv_var_key_c064    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_c064. "Active / Inactive flag

  IF lv_actv_flag_c064 = abap_true.

    INCLUDE zqtcn_quot_order_conv_c064 IF FOUND.

  ENDIF. " IF lv_actv_flag_c064 = abap_true
*** EOC by ARABANERJE  on 07-APR-2017 TR#ED2K905240*********************

*** BOC by SAYANDAS  on 22-MAY-2017 TR#ED2K905681*********************
  CONSTANTS:
    lc_wricef_id_i0234 TYPE zdevid VALUE 'I0234', "Constant value for WRICEF (I0234)
    lc_ser_num_i0234_2 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_var_key_i0234   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0234 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0234 = dxmescod. "Message Code


* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0234  "Constant value for WRICEF (I0234)
      im_ser_num     = lc_ser_num_i0234_2  "Serial Number (002)
      im_var_key     = lv_var_key_i0234    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0234. "Active / Inactive flag

  IF lv_actv_flag_i0234 = abap_true.

    INCLUDE zqtcn_token_interface_bdc IF FOUND.

  ENDIF. " IF lv_actv_flag_i0234 = abap_true
*** BOC by SAYANDAS  on 22-MAY-2017 TR#ED2K905681*********************

*** BOC by SAYANDAS  on 16-AUG-2018 TR# ED2K913027*********************
  CONSTANTS:
    lc_wricef_id_i0358 TYPE zdevid VALUE 'I0358', "Constant value for WRICEF (I0234)
    lc_ser_num_i0358_2 TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_var_key_i0358   TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0358 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0358 = dxmescod. "Message Code


* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0358  "Constant value for WRICEF (I0234)
      im_ser_num     = lc_ser_num_i0358_2  "Serial Number (002)
      im_var_key     = lv_var_key_i0358    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0358. "Active / Inactive flag

  IF lv_actv_flag_i0358 = abap_true.

    INCLUDE zqtcn_file_upload_bdc_i0358 IF FOUND.

  ENDIF. " IF lv_actv_flag_i0358 = abap_true
*** EOC by SAYANDAS  on 16-AUG-2018 TR# ED2K913027*********************

* SOC by NPOLINA I0230.1 25/Sep/2019  ED2K916260
* IDOC with Message Variant Z20 , Order Type ZACO
  CONSTANTS:
    lc_wricef_id_i0230_1 TYPE zdevid VALUE 'I0230.1', "Constant value for WRICEF (I0233.2)
    lc_ser_num_i0230_1_1 TYPE zsno   VALUE '001'. "Serial Number (001)

  DATA:
    lv_var_key_i0230_1   TYPE zvar_key,     "Variable Key
    lv_ser_num_i0230_1   TYPE zsno,         " Serial Number
    lv_actv_flag_i0230_1 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0230_1 = dxmescod. "Message Code Z20

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0230_1  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0230_1_1    "Serial Number (003)
      im_var_key     = lv_var_key_i0230_1    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0230_1. "Active / Inactive flag
  IF lv_actv_flag_i0230_1 = abap_true.

    INCLUDE zqtcn_inbound_bdc_i0230_1 IF FOUND.

  ENDIF.
* EOC by NPOLINA I0230.1 25/Sep/2019  ED2K916260

* SOC by NPOLINA I0230.2 06/Nov/2019  ED2K916726
* IDOC with Message Variant Z24 , Order Type ZPPV
  CONSTANTS:
    lc_wricef_id_i0230_2 TYPE zdevid VALUE 'I0230.2', "Constant value for WRICEF (I0230.2)
    lc_ser_num_i0230_1_2 TYPE zsno   VALUE '001'. "Serial Number (001)

  DATA:
    lv_var_key_i0230_2   TYPE zvar_key,     "Variable Key
    lv_ser_num_i0230_2   TYPE zsno,         " Serial Number
    lv_actv_flag_i0230_2 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0230_2 = dxmescod. "Message Code Z24

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0230_2  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_i0230_1_2    "Serial Number (003)
      im_var_key     = lv_var_key_i0230_2    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0230_2. "Active / Inactive flag
  IF lv_actv_flag_i0230_2 = abap_true .
    INCLUDE zqtcn_inb_bdc_i0230_2 IF FOUND.
  ENDIF.
* EOC by NPOLINA I0230.2 06/Nov/2019  ED2K916726

*** BOC: KKRAVURI  Date#25-DEC-2019  TR#ED2K917150
  CONSTANTS:
    lc_wricef_id_i0378 TYPE zdevid VALUE 'I0378', "Constant value for WRICEF (I0234)
    lc_snum_2          TYPE zsno   VALUE '002'.   "Serial Number (002)

  DATA:
    lv_vkey_i0378  TYPE zvar_key,     " Variable Key
    lv_aflag_i0378 TYPE zactive_flag. " Active / Inactive flag

* Populate Variable Key
  lv_vkey_i0378 = dxmescod.           " Message Variant 'Z25'

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0378  " Constant value for WRICEF (I0234)
      im_ser_num     = lc_snum_2           " Serial Number (002)
      im_var_key     = lv_vkey_i0378       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_aflag_i0378.     " Active / Inactive flag

  IF lv_aflag_i0378 = abap_true.
    INCLUDE zqtcn_woa_insub_ord_bdc_i0378 IF FOUND.
  ENDIF.
*** EOC: KKRAVURI  Date#25-DEC-2019  TR#ED2K917150

*** BOC:MIMMADISET  Date#29-APR-2020  TR#ED2K918072
  CONSTANTS:
    lc_wricef_id_i0230_22 TYPE zdevid VALUE 'I0230.22', "Constant value for WRICEF (I0230.22)
    lc_snum_1             TYPE zsno   VALUE '001'.   "Serial Number (002)

  DATA:
    lv_vkey_i0230_22  TYPE zvar_key,     " Variable Key
    lv_aflag_i0230_22 TYPE zactive_flag. " Active / Inactive flag

* Populate Variable Key
  lv_vkey_i0230_22 = dxmescod.           " Message Variant 'Z26'

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0230_22  " Constant value for WRICEF (I0230_22)
      im_ser_num     = lc_snum_1           " Serial Number (001)
      im_var_key     = lv_vkey_i0230_22       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_aflag_i0230_22.     " Active / Inactive flag

  IF lv_aflag_i0230_22 = abap_true.
    INCLUDE zqtcn_wls_ord_bdc_i0230_22 IF FOUND.
  ENDIF.
*** EOC: MIMMADISET  Date#29-APR-2020  TR#ED2K918072


* BOC by Lahiru on 03/14/2021 for OTCM-23859 with ED2K922541  *
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
    INCLUDE zqtcn_kiara_ord_bdc_e264_1 IF FOUND.
  ENDIF.
* EOC by Lahiru on 03/14/2021 for OTCM-23859 with ED2K922541  *
*BOC by Murali on 07/10/2021 for OTCM-45037 with  ED2K924060*
  CONSTANTS: lc_wricef_id_e263 TYPE zdevid VALUE 'E263',  " Constant value for WRICEF (E263)
             lc_ser_num_e263   TYPE zsno   VALUE '002'.   " Serial Number (002)

  DATA: lv_var_key_e263   TYPE zvar_key,     " Variable Key
        lv_actv_flag_e263 TYPE zactive_flag. " Active / Inactive flag

* Populate Variable Key
  lv_var_key_e263 = dxmescod.           " Message variant Z12

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e263    " Constant value for WRICEF (E263)
      im_ser_num     = lc_ser_num_e263      " Serial Number (001)
      im_var_key     = lv_var_key_e263      " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e263.   " Active / Inactive flag

  IF lv_actv_flag_e263 = abap_true.
    INCLUDE zqtcn_so_ord_bdc_e263_2 IF FOUND.
  ENDIF.
*EOC by Murali on 07/10/2021 for OTCM-45037 with  ED2K924060*

*--*BOC VDPATABALL OTCM-47818/OTCM-51088 TR ED2K925253 12/20/2021
*** This enhancement is to process Indian agent orders
  CONSTANTS:
    lc_ser_num_i0341_6 TYPE zsno   VALUE '006'.   "Serial Number (005)
  DATA:
    lv_var_key_i0341_006 TYPE zvar_key,     "Variable Key
    lv_actv_flag_i0341_6 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
  lv_var_key_i0341_006 = dxmescod. "Message Type

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0341      "Constant value for WRICEF (I0341)
      im_ser_num     = lc_ser_num_i0341_6      "Serial Number (006)
      im_var_key     = lv_var_key_i0341_006    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0341_6. "Active / Inactive flag

  IF lv_actv_flag_i0341_6 = abap_true.
    INCLUDE zqtcn_insub_bdc_ind_agt_i0341 IF FOUND.
  ENDIF. " IF lv_actv_flag_i0341_6 = abap_true
*--*EOC VDPATABALL OTCM-47818/OTCM-51088 TR ED2K925253 12/20/2021
*   BOC by VMAMILLAPA EAM-8227 07-Apr-2022 ED2K926658
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
  CONSTANTS:
    lc_i0504_1        TYPE zdevid VALUE 'I0504.1', "Constant value for WRICEF (I0502.1)
    lc_ser_nr_003     TYPE zsno   VALUE '003'.   "Serial Number (003)
*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
  DATA:lv_active_i0504_1 TYPE zactive_flag.         "Active / Inactive flag
*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
  DATA(lv_var_key_504) =  CONV zvar_key( dxmescod ).
* Enhancement to populate ship to reference
  CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_i0504_1         "Constant value for WRICEF (I0502.1)
    im_ser_num     = lc_ser_nr_003      "Serial Number (002)
    im_var_key     = lv_var_key_504     "Variable Key
  IMPORTING
    ex_active_flag = lv_active_i0504_1. "Active / Inactive flag
  IF lv_active_i0504_1 IS NOT INITIAL.
    INCLUDE zqtcn_inb_ord_bdc_knv_i0504 IF FOUND.
  ENDIF.
* EOC by VMAMILLAPA EAM-8227 07-Apr-2022 ED2K926658
