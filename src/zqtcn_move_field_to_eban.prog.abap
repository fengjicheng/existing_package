*&---------------------------------------------------------------------*
*&  Include  ZQTCN_MOVE_FIELD_TO_EBAN
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MOVE_FIELD_TO_EBAN
* PROGRAM DESCRIPTION: Incldue to move values to EBAN & EBKN
* DEVELOPER: SKKAIRAMKO
* CREATION DATE:   10/30/2019
* OBJECT ID: E222
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917084
* REFERENCE NO:
* DEVELOPER:     MIMMADISET(Murali)
* DATE:          2019-12-13
* DESCRIPTION:1.contrac start date and contract end date should update in the main line item
*instead Sub line itme
*2.Fixed vendor field value is not populating in sub line item.
*-------------------------------------------------------------------
*IF xvbak-auart = 'ZACO' AND
*   xvbap-pstyv = 'ZACG'.
*eban-flief = xvbkd-ihrez.
*ENDIF.

CONSTANTS:
  lc_devid_e222 TYPE    zdevid        VALUE 'E222',                      "Development ID: E106
  lc_sno_001    TYPE    zsno          VALUE '001',
  lc_pstyv      TYPE    rvari_vnam    VALUE 'PSTYV',
  lc_auart      TYPE    rvari_vnam    VALUE 'AUART'.

DATA:
  li_constants  TYPE zcat_constants.


DATA: lr_pstyv TYPE TABLE OF  /spe/pstyv_range,                       "Range: Document Categories
      lr_auart TYPE TABLE OF saco_s_auart.
**BOC-MIMMADISET-ED2K917084
TYPES:BEGIN OF ty_eban,
        docunum TYPE edi_docnum,
        posnr   TYPE posnr,
        ihrez   TYPE ihrez,
      END OF ty_eban.
DATA:ls_eban TYPE ty_eban,
     lv_id   TYPE char22.
STATICS:lt_eban TYPE STANDARD TABLE OF ty_eban.
**EOC-MIMMADISET-ED2K917084
*--------------------------------------------------------------------*

* Get Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e222                                  "Development ID: E106
  IMPORTING
    ex_constants = li_constants.
"Constant Values
LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).

  CASE <lst_constant>-param1.

    WHEN lc_pstyv.                                         "Parameter: Item Categories
      APPEND INITIAL LINE TO lr_pstyv ASSIGNING FIELD-SYMBOL(<lst_item_cat>).
      <lst_item_cat>-sign   = <lst_constant>-sign.
      <lst_item_cat>-option = <lst_constant>-opti.
      <lst_item_cat>-low    = <lst_constant>-low.
      <lst_item_cat>-high   = <lst_constant>-high.

    WHEN lc_auart.                                    "Parameter: Document Type
      APPEND INITIAL LINE TO lr_auart  ASSIGNING FIELD-SYMBOL(<lst_doc_type>).

      <lst_doc_type>-sign    = <lst_constant>-sign.
      <lst_doc_type>-option  = <lst_constant>-opti.
      <lst_doc_type>-low     = <lst_constant>-low.
      <lst_doc_type>-high    = <lst_constant>-high.

    WHEN OTHERS.
*           Nothing to do
*       Nothing to do
  ENDCASE.
ENDLOOP.


IF  xvbak-auart IN lr_auart AND
    xvbap-pstyv IN lr_pstyv.
**BOC-ED2K917084- MIMMADISET
  IF idoc_number IS NOT INITIAL.
** EXPORT statement is written in include ZQTCN_INBOUND_BDC_I0230_20
    CONCATENATE 'E222' idoc_number INTO lv_id.
    IMPORT lt_eban FROM MEMORY ID lv_id.
    IF sy-subrc = 0.
      FREE MEMORY ID lv_id."Clear the header shared memory
    ENDIF."IF SY-SUBRC = 0.
    READ TABLE lt_eban INTO ls_eban WITH KEY docunum = idoc_number
    posnr = ebkn-vbelp.
    IF sy-subrc = 0.
      eban-flief = ls_eban-ihrez.  "Fixed Vendor
    ENDIF."IF SY-SUBRC = 0.
  ELSE.
    eban-flief = xvbkd-ihrez_e.  "Fixed Vendor
  ENDIF.
**EOC-ED2K917084- MIMMADISET
*  eban-flief = xvbkd-ihrez_e.  "Fixed Vendor
ENDIF.
