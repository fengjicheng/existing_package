*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TAKEOVER_SUBSCRIP_PROCE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: RV61A905
* PROGRAM DESCRIPTION: To restrict the tax call to OneSource to be
*   triggered into the document, if the item categories are related to
*   Subscription contract, Offline and Renewal orders
* DEVELOPER: Mohammed Aslam (amohammed)
* CREATION DATE: 29-OCT-2019
* OBJECT ID: ERPM-2684-E224
* TRANSPORT NUMBER(S)ED2K916634
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916757
* REFERENCE NO:  ERPM-5846_E224
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-07-11
* DESCRIPTION:   Issue found in document. After saving the document,
*                tax condition types was activated again
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918141
* REFERENCE NO: ERPM# 10915
* DEVELOPER: KKRAVURI (Kiran Kumar R)
* DATE: 08-May-2020
* DESCRIPTION: Restrict the Tax conditions based on Order Reason
*----------------------------------------------------------------------*

* Type declaration
TYPES:
  BEGIN OF lty_const,
    devid    TYPE zdevid,                             "Development ID
    param1   TYPE rvari_vnam,                         "Parameter1
    param2   TYPE rvari_vnam,                         "Parameter2
    srno     TYPE tvarv_numb,                         "Serial Number
    sign     TYPE tvarv_sign,                         "Sign
    opti     TYPE tvarv_opti,                         "Option
    low      TYPE salv_de_selopt_low,                 "Low
    high     TYPE salv_de_selopt_high,                "High
    activate TYPE zconstactive,                       "Active/Inactive Indicator
  END OF lty_const,
  ltt_consts TYPE STANDARD TABLE OF lty_const  INITIAL SIZE 0.

* Internal Table Declaration
DATA: li_consts        TYPE ltt_consts,
      lir_ordtyp_comb  TYPE fip_t_auart_range,           "Saels doc order type
      lir_cat          TYPE rjksd_pstyv_range_tab,       "Range table for Item Category
      lv_flag          TYPE c,
* BOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141
      lir_ordtyp_alone TYPE fip_t_auart_range,
      lir_ordrsn       TYPE rjksd_augru_range_tab.
* EOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141

" Local constants
CONSTANTS:
  lc_devid TYPE zdevid     VALUE 'E224',    " Development ID
  lc_x     TYPE char1      VALUE 'X',       " Inactive indicator
  lc_auart TYPE rvari_vnam VALUE 'AUART',   " Param1: Document Type
  lc_pstyv TYPE rvari_vnam VALUE 'PSTYV',   " Param1: Item Category
* BOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141
  lc_augru TYPE rvari_vnam VALUE 'AUGRU'.   " Parameter-2: Order Reason
* EOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141

* Get data from constant table
CHECK li_consts IS INITIAL.
SELECT devid                                           "Development ID
       param1                                          "ABAP: Name of Variant Variable
       param2                                          "ABAP: Name of Variant Variable
       srno                                            "Current selection number
       sign                                            "ABAP: ID: I/E (include/exclude values)
       opti                                            "ABAP: Selection option (EQ/BT/CP/...)
       low                                             "Lower Value of Selection Condition
       high                                            "Upper Value of Selection Condition
       activate                                        "Activation indicator for constant
  FROM zcaconstant                                     "Wiley Application Constant Table
  INTO TABLE li_consts
 WHERE devid    EQ lc_devid
   AND activate EQ abap_true.                          " Only active record

CHECK sy-subrc IS INITIAL.
SORT li_consts BY param1 low.

LOOP AT li_consts ASSIGNING FIELD-SYMBOL(<lst_const1>).
  IF <lst_const1>-param1 = lc_auart AND
     <lst_const1>-param2 = lc_augru.
    " Get the Order Types from Constant Table
    APPEND INITIAL LINE TO lir_ordtyp_comb ASSIGNING FIELD-SYMBOL(<lst_ortype>).
    <lst_ortype>-sign   = <lst_const1>-sign.
    <lst_ortype>-option = <lst_const1>-opti.
    <lst_ortype>-low    = <lst_const1>-low.
    <lst_ortype>-high   = <lst_const1>-high.
  ENDIF.

  IF <lst_const1>-param1 = lc_pstyv.
    " Get the Sales document item category from constant table
    APPEND INITIAL LINE TO lir_cat ASSIGNING FIELD-SYMBOL(<ls_cat>).
    <ls_cat>-sign   = <lst_const1>-sign.
    <ls_cat>-option = <lst_const1>-opti.
    <ls_cat>-low    = <lst_const1>-low.
    <ls_cat>-high   = <lst_const1>-high.
  ENDIF.
* BOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141
  IF <lst_const1>-param1 = lc_auart AND
     <lst_const1>-param2 IS INITIAL.
    " Get the Order Types from Constant Table
    APPEND INITIAL LINE TO lir_ordtyp_alone ASSIGNING <lst_ortype>.
    <lst_ortype>-sign   = <lst_const1>-sign.
    <lst_ortype>-option = <lst_const1>-opti.
    <lst_ortype>-low    = <lst_const1>-low.
    <lst_ortype>-high   = <lst_const1>-high.
  ENDIF.
  IF <lst_const1>-param1 = lc_augru.
    " Get Order Reason from constant table
    APPEND INITIAL LINE TO lir_ordrsn ASSIGNING FIELD-SYMBOL(<lst_ordrsn>).
    <lst_ordrsn>-sign   = <lst_const1>-sign.
    <lst_ordrsn>-option = <lst_const1>-opti.
    <lst_ordrsn>-low    = <lst_const1>-low.
    <lst_ordrsn>-high   = <lst_const1>-high.
  ENDIF.
* EOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141
ENDLOOP.

*** BOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141
" Below condition check is commented and add the new
" condition checks as per ERPM#10915 requirement
*IF komk-auart IN lir_ordtyp1.
*  IF komp-pstyv IN lir_cat.
*    lv_flag = lc_x.
*  ENDIF.
*ENDIF.

* Restrict the Tax call based on both DocType & Order Reason check
IF ( lir_ordtyp_comb[] IS NOT INITIAL AND komk-auart IN lir_ordtyp_comb ) AND
   ( lir_ordrsn[] IS NOT INITIAL AND komk-augru IN lir_ordrsn ).
  IF lir_cat[] IS NOT INITIAL AND komp-pstyv IN lir_cat.
    lv_flag = lc_x.
  ENDIF.
ENDIF.

* Restrict the Tax call only based on DocType check
IF lir_ordtyp_alone[] IS NOT INITIAL AND komk-auart IN lir_ordtyp_alone.
  IF lir_cat[] IS NOT INITIAL AND komp-pstyv IN lir_cat.
    lv_flag = lc_x.
  ENDIF.
ENDIF.
*** EOC: ERPM#10915  KKRAVURI  08-MAY-2020  ED2K918141

IF lv_flag IS NOT INITIAL.
  sy-subrc = 4.
  RETURN.
ELSE.
  sy-subrc = 0.
ENDIF.
