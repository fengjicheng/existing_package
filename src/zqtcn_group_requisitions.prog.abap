*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_GROUP_REQUISITIONS
* PROGRAM DESCRIPTION: Purchase order Enhancement (Grouping against
*                      Material Number)
* Inside this include grouping PR against Material Number .
* DEVELOPER: Writtick Roy
* CREATION DATE:   2017-02-11
* OBJECT ID: E143
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History------------------------------------------------------*
* Revision No: ED2K918016
* Reference No:  ERPM-17382(E143)
* Developer:mimmadiset
* Date:  2020-04-20
* Description:Exclude the below enhancement for Advancement courses.
*----------------------------------------------------------------------*
* Revision History------------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF lty_sort,
    ekgrp TYPE ekgrp, "Purchasing Group
    ekorg TYPE ekorg, "Purchasing Organization
    matnr TYPE matnr, "Material Number
    banfn TYPE banfn, "Purchase Requisition Number
    bnfpo TYPE bnfpo, "Item Number of Purchase Requisition
  END OF lty_sort.

DATA:
  lt_sort    TYPE STANDARD TABLE OF lty_sort INITIAL SIZE 0,
  li_const   TYPE zcat_constants,
  lir_bsart  TYPE fip_t_bsart_range,
  lv_ex_flag TYPE flag.  "Flag for exclude the logic for AC

DATA:
  lv_n_po TYPE new_po. "Flag: New purchase order
CONSTANTS:lc_devid   TYPE zdevid  VALUE 'E143',           "Development ID
          lc_param_b TYPE rvari_vnam  VALUE 'ORDER_TYPE',  "ABAP: Name of Variant Variable
          lc_param_c TYPE rvari_vnam  VALUE 'EXCLUDE'.      "ABAP: Name of Variant Variable
**BOC ED2K918016 mimmadiset
*** Below FM is used to read the constant variables based on Development id
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid
  IMPORTING
    ex_constants = li_const.
IF li_const[] IS NOT INITIAL.
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_param_b.
        CASE <lst_const>-param2.
          WHEN lc_param_c.
** lir_bsart is range table
            APPEND INITIAL LINE TO lir_bsart ASSIGNING FIELD-SYMBOL(<lst_bsart>).
            <lst_bsart>-sign   = <lst_const>-sign.
            <lst_bsart>-option = <lst_const>-opti.
            <lst_bsart>-low    = <lst_const>-low.
            <lst_bsart>-high   = <lst_const>-high.
        ENDCASE.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.
CLEAR:lv_ex_flag.
IF lir_bsart IS NOT INITIAL.
*For Advancement Courses we need to exclude this enhancement.
*AC uses PReq type ZANB and PO Type ZANB
*if lv_ex_flag is 'X' exclude the below logic else continue with existing logic
  LOOP AT t_eban INTO DATA(ls_eban) WHERE bsart IN lir_bsart.
    lv_ex_flag = abap_true.
    EXIT.
  ENDLOOP.
ENDIF.
**END ED2K918016 mimmadiset
IF lv_ex_flag IS INITIAL.
  LOOP AT t_eban ASSIGNING FIELD-SYMBOL(<lst_eban>).
    APPEND INITIAL LINE TO lt_sort ASSIGNING FIELD-SYMBOL(<lst_sort>).
    MOVE-CORRESPONDING <lst_eban> TO <lst_sort>.
    UNASSIGN: <lst_sort>.
  ENDLOOP. " LOOP AT t_eban ASSIGNING FIELD-SYMBOL(<lst_eban>)
  SORT lt_sort BY ekgrp ekorg matnr banfn bnfpo.
  SORT t_eban  BY ekgrp ekorg matnr banfn bnfpo.

  CLEAR: t_ebanx[].
  LOOP AT lt_sort ASSIGNING <lst_sort>.
    AT NEW matnr.
      lv_n_po = abap_true. "Flag: New purchase order
    ENDAT.

    APPEND INITIAL LINE TO t_ebanx ASSIGNING FIELD-SYMBOL(<lst_ebanx>).
    <lst_ebanx>-banfn      = <lst_sort>-banfn. "Purchase Requisition Number
    <lst_ebanx>-bnfpo      = <lst_sort>-bnfpo. "Item Number of Purchase Requisition
    IF lv_n_po IS NOT INITIAL.
      <lst_ebanx>-new_po   = abap_true. "New purchase order
    ELSE. " ELSE -> IF lv_n_po IS NOT INITIAL
      <lst_ebanx>-new_item = abap_true. "New purchase order item
    ENDIF. " IF lv_n_po IS NOT INITIAL

    CLEAR: lv_n_po.
  ENDLOOP. " LOOP AT lt_sort ASSIGNING <lst_sort>
ENDIF.
