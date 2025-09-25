*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DEFAULT_BILLING_DATE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DEFAULT_BILLING_DATE (Include Program)
* PROGRAM DESCRIPTION: Invoice cancellation - Default billing date
* DEVELOPER: Prabhu
* CREATION DATE: 8/22/2019
* OBJECT ID: ERPM-934/E-213
* TRANSPORT NUMBER(S):ED2K915949
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
CONSTANTS : lc_devid_e213 TYPE zdevid      VALUE 'E213',                  "Development ID: E213
            lc_doc_cat    TYPE rvari_vnam VALUE 'DOC_CAT'.
DATA : lv_index TYPE sy-tabix.
IF lis_const_e213 IS INITIAL.
* Get Cnonstant values
  SELECT devid,                                                  "Devid
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @lis_const_e213
   WHERE devid    EQ @lc_devid_e213                               "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT lis_const_e213 ASSIGNING FIELD-SYMBOL(<lst_const_e213>).
      CASE <lst_const_e213>-param1.
        WHEN lc_doc_cat.                          " Sales doc category
          APPEND INITIAL LINE TO lrs_doc_cat ASSIGNING FIELD-SYMBOL(<lst_doc_cat>).
          <lst_doc_cat>-sign   = <lst_const_e213>-sign.
          <lst_doc_cat>-option = <lst_const_e213>-opti.
          <lst_doc_cat>-low    = <lst_const_e213>-low.
          <lst_doc_cat>-high   = <lst_const_e213>-high.
        WHEN OTHERS.
*           Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDIF.
*--*Default billing date as current date for invoice cancellation
*IF vbrk-vbtyp IN lrs_doc_cat AND
IF invoice_date IS INITIAL.
  LOOP AT xvbrk INTO DATA(lst_xvbrk).
    lv_index = sy-tabix.
*--*Check constant table entry
    READ TABLE lrs_doc_cat INTO DATA(lst_doc_cat) WITH KEY low = lst_xvbrk-vbtyp.
    IF sy-subrc EQ 0.
      lst_xvbrk-fkdat = sy-datum.
      MODIFY xvbrk FROM lst_xvbrk INDEX lv_index TRANSPORTING fkdat .
      CLEAR : lst_xvbrk.
    ENDIF.
  ENDLOOP.
ENDIF.
