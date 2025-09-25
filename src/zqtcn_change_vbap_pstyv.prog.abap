*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CHANGE_VBAP_PSTYV (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be changed VBAP-PSTYV (
*                      Sales document item category) to ZCCT if Net price
*                      is 0.01.
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   06/14/2016
* OBJECT ID: E173
* TRANSPORT NUMBER(S): ED2K912276
*----------------------------------------------------------------------*
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : Item Category switch to ZCCT is not resetting RaR
*                      relevant flag  for that line item.  VBKD-FARR_RELTYPE
*                      has to be reset for that line item
* DEVELOPER: Randheer Kumar
* CREATION DATE:  SEP 20th, 2018
* OBJECT ID:  INC0212190
* TRANSPORT NUMBER(S): ED2K913410
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
* Data declaration
TYPES: BEGIN OF ty_const_e173,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const_e173,
*  Range Table declaration:
       BEGIN OF lty_item_cat,
         sign   TYPE tvarv_sign,            "ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti,            "ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,    "Low
         high   TYPE salv_de_selopt_high,   "High
       END OF lty_item_cat.
* local Internal Table Declaration
DATA :   li_zcaconstant_e173   TYPE STANDARD TABLE OF ty_const_e173 INITIAL SIZE 0,  " Wiley Application Constant Table
         lr_item_cat_netwr     TYPE STANDARD TABLE OF lty_item_cat INITIAL SIZE 0,   " Net Price table from Constant Table
         lr_item_matnr         TYPE STANDARD TABLE OF lty_item_cat INITIAL SIZE 0,   " Material Number from Constant Table
         lr_item_sales_office  TYPE STANDARD TABLE OF lty_item_cat INITIAL SIZE 0,    " Sales Office from Constant Table
         li_vbap_tmp           TYPE STANDARD TABLE OF vbapvb,                        " Temparory table for VBAP table
* Local Work Areas
         lst_item_matnr        TYPE lty_item_cat,                                    " Materiall Number from constant table
         lst_item_cat_netwr    TYPE lty_item_cat,                                    " Net Price from constant table
         lst_item_sales_office TYPE lty_item_cat,                                    " Sales Office from constant table
         lst_zcaconstant_e173  TYPE ty_const_e173.                                   " Wiley Application Constant Table

* Local Constant Declaration
CONSTANTS :   lc_e173       TYPE zdevid        VALUE 'E173',                      " Development ID
              lc_net_price  TYPE rvari_vnam    VALUE 'NET_PRICE',                 " ABAP: Name of Variant Variable
              lc_sales_off  TYPE rvari_vnam    VALUE 'SALES_OFFICE',              " For Sales Office
              lc_matnr      TYPE rvari_vnam    VALUE 'MATNR',                     " For Material Number
              lc_pstyv_zcct TYPE pstyv         VALUE 'ZCCT',                      " For Document Car
              lc_netwr      TYPE rvari_vnam    VALUE 'NETWR',                     " ABAP: Name of Variant Variable
              lc_tab_name   TYPE tbnam_vb      VALUE 'VBAP',                      "Incompletion log table name
              lc_field_name TYPE fdnam_vb      VALUE 'KZWI1',                     "Incompletion log field name
              lc_procedure  TYPE fehgr         VALUE 'Z8'.                        "Incompletion log processing routine

***Field symbol declaration***
FIELD-SYMBOLS: <lfs_xvbap_p> TYPE vbapvb,
               <lfs_vbkd>    TYPE VBKDVB. "ADD:INC0212190:RKUMAR2:20-SEP-2018:ED2K913410
*               <lfs_xvbap_r> TYPE vbapvb.

SELECT devid       "Development ID
       param1	     "ABAP: Name of Variant Variable
       param2	     "ABAP: Name of Variant Variable
       srno	       "ABAP: Current selection number
       sign	       "ABAP: ID: I/E (include/exclude values)
       opti	       "ABAP: Selection option (EQ/BT/CP/...)
       low         "Lower Value of Selection Condition
       high	       "Upper Value of Selection Condition
       activate    "Activation indicator for constant
  FROM zcaconstant "Wiley Application Constant Table
  INTO TABLE li_zcaconstant_e173
  WHERE devid  = lc_e173
    AND activate = abap_true.

IF sy-subrc EQ 0.
  LOOP AT li_zcaconstant_e173 INTO lst_zcaconstant_e173.
    CASE lst_zcaconstant_e173-param1.
*  Net Price
      WHEN lc_net_price.
        lst_item_cat_netwr-sign   = lst_zcaconstant_e173-sign.
        lst_item_cat_netwr-option = lst_zcaconstant_e173-opti.
        lst_item_cat_netwr-low    = lst_zcaconstant_e173-low.
        lst_item_cat_netwr-high   = lst_zcaconstant_e173-high.
        APPEND lst_item_cat_netwr TO  lr_item_cat_netwr.
        CLEAR lst_item_cat_netwr.
*  Item Cat
      WHEN lc_matnr.
        lst_item_matnr-sign   = lst_zcaconstant_e173-sign.
        lst_item_matnr-option = lst_zcaconstant_e173-opti.
        lst_item_matnr-low    = lst_zcaconstant_e173-low.
        lst_item_matnr-high   = lst_zcaconstant_e173-high.
        APPEND lst_item_matnr TO lr_item_matnr.
        CLEAR lst_item_matnr.
*- Sales Office
      WHEN lc_sales_off.
        lst_item_sales_office-sign   = lst_zcaconstant_e173-sign.
        lst_item_sales_office-option = lst_zcaconstant_e173-opti.
        lst_item_sales_office-low    = lst_zcaconstant_e173-low.
        lst_item_sales_office-high   = lst_zcaconstant_e173-high.
        APPEND lst_item_sales_office TO lr_item_sales_office.
        CLEAR lst_item_sales_office.
      WHEN OTHERS.
    ENDCASE.
    CLEAR lst_zcaconstant_e173.
  ENDLOOP.
  CLEAR: li_vbap_tmp[].
  li_vbap_tmp[] = xvbap[].
**- checking with sales Office 0050
  IF vbak-vkbur IN lr_item_sales_office.
    LOOP AT li_vbap_tmp INTO DATA(lst_xvbap_t) WHERE matnr IN lr_item_matnr.

*- Checking BOM Child items, Net Price is less than threshold and Item cat is not ZCCT
      LOOP AT xvbap ASSIGNING <lfs_xvbap_p>  WHERE uepos EQ lst_xvbap_t-posnr
                                            AND   netwr IN lr_item_cat_netwr
                                            AND   pstyv NE lc_pstyv_zcct.
*- Modifiying the only item BOM
        <lfs_xvbap_p>-pstyv = lc_pstyv_zcct.
        IF xvbuv[] IS NOT INITIAL.
          READ TABLE xvbuv WITH KEY posnr = <lfs_xvbap_p>-posnr
                                    tbnam = lc_tab_name
                                    fdnam = lc_field_name
                                    fehgr = lc_procedure
                                    TRANSPORTING NO FIELDS.
          IF sy-subrc IS INITIAL.
            DELETE xvbuv INDEX sy-tabix.
          ENDIF.
        ENDIF.
* Begin of ADD:INC0212190:RKUMAR2:20-SEP-2018:ED1K908513
        IF xvbkd[] IS NOT INITIAL.
         LOOP AT xvbkd ASSIGNING <lfs_vbkd> WHERE posnr = <lfs_xvbap_p>-posnr.
          FREE: <lfs_vbkd>-FARR_RELTYPE."Clear the RAR flag for further process
         ENDLOOP.
        ENDIF.
* End of ADD:INC0212190:RKUMAR2:20-SEP-2018:ED1K908513
      ENDLOOP.
      CLEAR lst_xvbap_t.

    ENDLOOP.
  ENDIF.
ENDIF.
