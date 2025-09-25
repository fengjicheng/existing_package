*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SOURCE_DET (Include)
*               Called from "USEREXIT_SOURCE_DETERMINATION (MV45AFZB)"
* PROGRAM DESCRIPTION: This Userexit is used to add additional logic
*                      for finding the source of the Plant or the Item
*                      Category
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902972
* REFERENCE NO: E134
* DEVELOPER: Shivani Upadhyaya
* DATE: 2016-09-22
* DESCRIPTION: Plant override plant for BOM sub items in sales order
* Change Tag :
* BOC by SHUPADHYAY on 22-Sept-2016 TR#ED2K902977 *
* EOC by SHUPADHYAY on 22-Sept-2016 TR#ED2K902977 *
*----------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:  ED1K908130 / ED2K913295
* REFERENCE NO: RITM0036291 - E141
* DEVELOPER:    Himanshu Patel (HIPATEL)
* DATE:         08/03/2018
* DESCRIPTION:  Delivery Plant determination for Release Order.
*---------------------------------------------------------------------*

* BOC by SHUPADHYAY on 22-Sept-2016 TR#ED2K902977 *
CONSTANTS: lc_wricef_id TYPE zdevid VALUE 'E134', " Development ID
           lc_ser_num   TYPE zsno VALUE '001'. " Serial Number

DATA: lv_actv_flag TYPE zactive_flag . " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id
    im_ser_num     = lc_ser_num
  IMPORTING
    ex_active_flag = lv_actv_flag.

IF lv_actv_flag EQ abap_true.
  INCLUDE zqtcn_sales_bom_items IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true
* EOC by SHUPADHYAY on 22-Sept-2016 TR#ED2K902977 *

*BOC <HIPATEL> <RITM0036291> <ED1K908130> <08/03/2018>
  CONSTANTS:
    lc_wricef_id_e141 TYPE zdevid VALUE 'E141',       "Constant value for WRICEF (E141)
    lc_ser_num_e141_2 TYPE zsno   VALUE '002'.        "Serial Number (002)

  DATA:
    lv_actv_flag_e141 TYPE zactive_flag.              "Active / Inactive flag

* Custom Logic
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e141               "Constant value for WRICEF (E141)
      im_ser_num     = lc_ser_num_e141_2               "Serial Number (002)
    IMPORTING
      ex_active_flag = lv_actv_flag_e141.              "Active / Inactive flag
  IF lv_actv_flag_e141 = abap_true.
    INCLUDE zqtcn_rel_ord_plnt IF FOUND.
  ENDIF.
*EOC <HIPATEL> <RITM0036291> <ED1K908130> <08/03/2018>
