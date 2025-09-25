*&---------------------------------------------------------------------*
*&  Include  ZQTCN_WOA_NETVALUE_VAL_I0378
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WOA_NETVALUE_VAL_I0378 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Net Value validation for Wiley OO/OA Relorder
*                      Interface
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 27-DEC-2019
* OBJECT ID: I0378 (ERPM-197)
* TRANSPORT NUMBER(S): ED2K917150
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918765
* REFERENCE NO:  ERPM-23422
* DEVELOPER: NPOLINA
* DATE:  2020-07-01
* DESCRIPTION: Logic added to align Item overview to Paranet order
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923540
* REFERENCE NO:  E267 / OTCM-28269
* DEVELOPER: MRAJKUMAR
* DATE:  24-05-2021
* DESCRIPTION: Sort the XVBFA table
*----------------------------------------------------------------------*


* Local Types
TYPES: BEGIN OF lty_vbeln,
         vbeln TYPE vbeln_va,
       END OF lty_vbeln,
       BEGIN OF lty_vbap,
         vbeln TYPE	vbeln_va,
         posnr TYPE	posnr_va,
         matnr TYPE	matnr,
         netwr TYPE netwr_ap,
       END OF lty_vbap,
       BEGIN OF lty_vbap_zoar,
         matnr TYPE	matnr,
         netwr TYPE netwr_ap,
       END OF lty_vbap_zoar,
       ltt_vbeln     TYPE STANDARD TABLE OF lty_vbeln INITIAL SIZE 0,
       ltt_vbap      TYPE STANDARD TABLE OF lty_vbap INITIAL SIZE 0,
       ltt_vbap_zoar TYPE STANDARD TABLE OF lty_vbap_zoar INITIAL SIZE 0.

* Local Variables Declaration
DATA:
  li_constants_i0378 TYPE zcat_constants,        " Itab: Constant entries
  li_orders_zoar     TYPE ltt_vbeln,             " Itab: ZOAR from VBFA
  li_vbap_zsub       TYPE ltt_vbap,              " Itab: ZSUB
  li_vbap_zoar       TYPE ltt_vbap_zoar,         " Itab: ZOAR
  lv_ref_doc_i0378   TYPE vgbel,                 " Reference document
  lv_porder_i0378    TYPE vbeln_va,              " Parent order
  lv_doctyp_zoar     TYPE auart,                 " Document type
  lv_zsub_netval     TYPE netwr_ak,              " Net value
  lv_total_i0378     TYPE netwr_ak,              " Total value
  lr_orders_zoar     TYPE farric_rt_vbeln.       " Ranges Table for Sales and Distribution Document Number

* Local Constants Declaration
CONSTANTS:
  lc_dcat_c       TYPE vbtyp_n       VALUE 'C',         " Document category: Order
  lc_sign_i_i0378 TYPE ddsign        VALUE 'I',         " Sign: I
  lc_opt_eq_i0378 TYPE ddoption      VALUE 'EQ',        " Option: EQ
  lc_doc_type     TYPE rvari_vnam    VALUE 'DOC_TYPE',  " Document Type
  lc_devid_i0378  TYPE zdevid        VALUE 'I0378',     " Type of Identification Code
  lc_sno_0001     TYPE tvarv_numb    VALUE '0001'.      " Serial Number: 0001


* Fetch Document Type from Constant entries
SELECT devid                               " Development ID
       param1                              " ABAP: Name of Variant Variable
       param2                              " ABAP: Name of Variant Variable
       srno                                " ABAP: Current selection number
       sign                                " ABAP: I/E (include/exclude values)
       opti                                " ABAP: Selection option (EQ/BT/CP/...)
       low                                 " Lower Value of Selection Condition
       high                                " Upper Value of Selection Condition
       FROM zcaconstant                    " Wiley Application Constant Table
       INTO TABLE li_constants_i0378
       WHERE devid = lc_devid_i0378 AND
             activate = abap_true.         " Only active records
IF sy-subrc = 0 AND li_constants_i0378[] IS NOT INITIAL.
  LOOP AT li_constants_i0378 ASSIGNING FIELD-SYMBOL(<lst_constant_i0378>).
    CASE <lst_constant_i0378>-param1.
      WHEN lc_doc_type.
        CASE <lst_constant_i0378>-srno.
          WHEN lc_sno_0001.
            lv_doctyp_zoar = <lst_constant_i0378>-low.

          WHEN OTHERS.
            " Nothing to do
        ENDCASE.

      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc = 0 AND

" Net value validation is applicable only for child orders (ZOAR Orders)
" Hence check the Document type of child orders
IF vbak-auart = lv_doctyp_zoar.

  " Get Reference document from VBAK-VGBEL
  lv_ref_doc_i0378 = vbak-vgbel.

  " Parent Order (Subscription order)
  lv_porder_i0378 = lv_ref_doc_i0378.

  " Get the net value of all the Materials of Parent Sales Order (ZSUB) from VBAK
  SELECT vbeln posnr matnr netwr FROM vbap INTO TABLE li_vbap_zsub
         WHERE vbeln = lv_porder_i0378.
  IF sy-subrc = 0.
    SORT li_vbap_zsub BY matnr.
    " Get the Child orders from Document flow (VBFA), if any
    SELECT vbeln FROM vbfa INTO TABLE li_orders_zoar
                 WHERE vbelv = lv_porder_i0378 AND
                       vbtyp_n = lc_dcat_c.
    IF sy-subrc = 0 AND li_orders_zoar[] IS NOT INITIAL.
      " If Child orders are there with reference to Parent order
      " then build the ranges table with option: EQ for all the
      " child orders
      SORT li_orders_zoar BY vbeln.
      DELETE ADJACENT DUPLICATES FROM li_orders_zoar COMPARING vbeln.
      LOOP AT li_orders_zoar ASSIGNING FIELD-SYMBOL(<lst_corders>).
        APPEND INITIAL LINE TO lr_orders_zoar ASSIGNING FIELD-SYMBOL(<lst_vbeln>).
        <lst_vbeln>-sign = lc_sign_i_i0378.
        <lst_vbeln>-option = lc_opt_eq_i0378.
        <lst_vbeln>-low = <lst_corders>-vbeln.
      ENDLOOP.
      " Get the net value of all the Materials of child orders (ZOAR) from VBAK
      SELECT matnr SUM( netwr ) AS netwr FROM vbap INTO TABLE li_vbap_zoar
             WHERE vbeln IN lr_orders_zoar
             GROUP BY matnr.
      IF sy-subrc = 0.
        SORT li_vbap_zoar BY matnr.
      ENDIF.
      " Iterate the order items and validate the item net value with Parent order net value
      LOOP AT xvbap INTO DATA(lst_xvbap_i0378).
        DATA(lv_tbx) = sy-tabix.                     "ERPM-23422  ED2K918765 NPOLINA
        " Get Reference Material (XVBKD-IHREZ) from XVBKD
        READ TABLE xvbkd INTO DATA(lst_xvbkd_i0378) WITH KEY vbeln = lst_xvbap_i0378-vbeln
                                                             posnr = lst_xvbap_i0378-posnr.
        IF sy-subrc = 0.
          " Read Subscription order item based on Reference Material (XVBKD-IHREZ)
          READ TABLE li_vbap_zsub INTO DATA(lst_vbap_zsub) WITH KEY
                                       matnr = lst_xvbkd_i0378-ihrez
                                       BINARY SEARCH.
          IF sy-subrc = 0.
            lv_zsub_netval = lst_vbap_zsub-netwr.
* SOC by    ERPM-23422  ED2K918765 NPOLINA
            xvbfa-posnv = lst_vbap_zsub-posnr.
            lst_xvbap_i0378-vgbel = lst_vbap_zsub-vbeln.
            lst_xvbap_i0378-vgpos = lst_vbap_zsub-posnr.
            MODIFY xvbap FROM lst_xvbap_i0378 INDEX lv_tbx TRANSPORTING vgbel vgpos.
            APPEND xvbfa.
* EOC by    ERPM-23422  ED2K918765 NPOLINA

          ENDIF.
        ENDIF. " IF sy-subrc = 0. --> READ TABLE xvbkd

        " Read existing child order (ZOAR) item based on Material Number
        READ TABLE li_vbap_zoar INTO DATA(lst_vbap_zoar) WITH KEY
                                matnr = lst_xvbap_i0378-matnr BINARY SEARCH.
        IF sy-subrc = 0.
          lv_total_i0378 = lst_xvbap_i0378-netwr + lst_vbap_zoar-netwr.
          IF lv_total_i0378 > lv_zsub_netval.
            " Sum total of all the release orders exceed the parent order by &
            MESSAGE e353(zqtc_r2) WITH lv_total_i0378.
          ENDIF.
        ELSE.
          IF lst_xvbap_i0378-netwr > lv_zsub_netval.
            " Sum total of all the release orders exceed the parent order by &
            MESSAGE e353(zqtc_r2) WITH lst_xvbap_i0378-netwr.
          ENDIF.
        ENDIF.
        CLEAR: lst_xvbap_i0378,
               lst_xvbkd_i0378,
               lst_vbap_zsub,
               lst_vbap_zoar,
               lv_zsub_netval,
               lv_total_i0378.
      ENDLOOP.
*SOC by E267/OTCM-28269 ED2K923540 MRAJKUMAR
            SORT xvbfa
              BY mandt
                 vbelv
                 posnv
                 vbeln
                 posnn
                 vbtyp_n.
*EOC by E267/OTCM-28269 ED2K923540 MRAJKUMAR
    ELSE. " IF sy-subrc = 0 AND li_orders_zoar[] IS NOT INITIAL.
      " First Child Order
      " Iterate the order items and validate the item net value with Parent order net value
      LOOP AT xvbap INTO lst_xvbap_i0378.
         DATA(lv_tbx2) = sy-tabix.                     "ERPM-23422  ED2K918765 NPOLINA
        " Get Reference Material (XVBKD-IHREZ) from XVBKD
        READ TABLE xvbkd INTO lst_xvbkd_i0378 WITH KEY vbeln = lst_xvbap_i0378-vbeln
                                                       posnr = lst_xvbap_i0378-posnr.
        IF sy-subrc = 0.
          " Read Subscription order item based on Reference Material (XVBKD-IHREZ)
          READ TABLE li_vbap_zsub INTO lst_vbap_zsub WITH KEY
                                  matnr = lst_xvbkd_i0378-ihrez
                                  BINARY SEARCH.
          IF sy-subrc = 0.

* SOC by    ERPM-23422  ED2K918765 NPOLINA
            xvbfa-posnv = lst_vbap_zsub-posnr.
            lst_xvbap_i0378-vgbel = lst_vbap_zsub-vbeln.
            lst_xvbap_i0378-vgpos = lst_vbap_zsub-posnr.
            MODIFY xvbap FROM lst_xvbap_i0378 INDEX lv_tbx2 TRANSPORTING vgbel vgpos .
            APPEND xvbfa.
* EOC by    ERPM-23422  ED2K918765 NPOLINA
            lv_zsub_netval = lst_vbap_zsub-netwr.
            IF lst_xvbap_i0378-netwr > lv_zsub_netval.
              " Sum total of all the release orders exceed the parent order by &
              MESSAGE e353(zqtc_r2) WITH lst_xvbap_i0378-netwr.
            ENDIF.
          ENDIF.
        ENDIF. " IF sy-subrc = 0. --> READ TABLE xvbkd

        CLEAR: lst_xvbap_i0378,
               lst_xvbkd_i0378,
               lst_vbap_zsub,
               lv_zsub_netval.
      ENDLOOP.
*SOC by E267/OTCM-28269 ED2K923540 MRAJKUMAR
            SORT xvbfa
              BY mandt
                 vbelv
                 posnv
                 vbeln
                 posnn
                 vbtyp_n.
*EOC by E267/OTCM-28269 ED2K923540 MRAJKUMAR
    ENDIF. " IF sy-subrc = 0 AND li_orders_zoar[] IS NOT INITIAL.

  ENDIF. " IF sy-subrc = 0.  SELECT of VBAP
ENDIF. " IF vbak-auart = lv_doctyp_zoar.
