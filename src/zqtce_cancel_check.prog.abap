***&---------------------------------------------------------------------*
***&  Include           ZQTCE_CANCEL_CHECK
***&---------------------------------------------------------------------*
*** -------------------------------------------------------------------- *
*** © Copyright 2019 First Data All rights reserved.
*** Description: Tokenizer Integration
*** Product: Snappay
*** Component: GUI Override
*** Developer: Rakesh Tripathy
*** Creation Date: 2019/06
*** -------------------------------------------------------------------- *
*** Revision History
*** -------------------------------------------------------------------- *
*** Revision No:                            Reference No:
*** Developer:                              Date: yyyy/mm/dd
*** Description:
*** -------------------------------------------------------------------- *
***Sales Overview Screen
***This will give the ability to swap out the Standard Gui Status with
***a custom Gui Status.
*** DATA: lv_auart      TYPE auart,
***       lv_eipp_flag  TYPE char1,
***       lt_comp_codes TYPE /spay/compcode_t,
***       lt_sales_org  TYPE /spay/salesorg_t,
***       lv_override   TYPE char1.
**
** IF modul-pool EQ 'SAPMV45B'.
**   IF t185v-status EQ 'U'     "Sales Order Overview Screen
**   OR t185v-status EQ 'U   CONT' .    "Contracts
**
***     lv_eipp_flag = /spay/cl_co_parameters=>get_eipp_flag( ).
***     IF lv_eipp_flag IS INITIAL.
***       CLEAR lv_auart.
**
***       CALL FUNCTION 'CONVERSION_EXIT_AUART_INPUT'
***         EXPORTING
***           input  = vbak-auart
***         IMPORTING
***           output = lv_auart.
***
***       SELECT SINGLE auart FROM tvak INTO lv_auart
***       WHERE auart = lv_auart AND
***             rpart = '03'.  "Payment Card Active for Order type
***       IF sy-subrc = 0.
***         lv_override = 'Y'.
***
**** Get the filter at Company Code nd Sales org to manage Enter Card button
***         lt_comp_codes = /spay/cl_co_parameters=>get_company_code( ).
***         lt_sales_org = /spay/cl_co_parameters=>get_sales_org( ).
***
***         IF ( lt_comp_codes IS NOT INITIAL AND vbak-bukrs_vf NOT IN lt_comp_codes
***         AND vbak-bukrs_vf IS NOT INITIAL ).
***           lv_override = 'N'.
***         ENDIF.
***
***         IF ( lt_sales_org IS NOT INITIAL AND vbak-vkorg NOT IN lt_sales_org ).
***           lv_override = 'N'.
***         ENDIF.
**
***         IF lv_override = 'Y'.
**           IF t185v-status EQ 'U'.     "Sales Order Overview Screen
**             SET PF-STATUS t185v-status EXCLUDING cua_exclude
**             OF PROGRAM 'ZQTCE_CANCELLATION_NOTICE'.    "This contains 'ZTOK'
**           ENDIF.
**           IF t185v-status EQ 'U   CONT' .    "Contracts
**             SET PF-STATUS 'UCONT' EXCLUDING cua_exclude
**             OF PROGRAM 'ZQTCE_CANCELLATION_NOTICE'.    "This contains 'ZTOK'
**           ENDIF.
***         ENDIF.
***       ENDIF.
***     ENDIF.
**   ENDIF.
** ENDIF.
