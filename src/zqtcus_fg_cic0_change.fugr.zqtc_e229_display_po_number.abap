FUNCTION zqtc_e229_display_po_number .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_COMPONENT) TYPE  EW_OPSCOMPONENT
*"     REFERENCE(IM_PROFILE) TYPE  EW_OPSPROFILE
*"     REFERENCE(IM_SLOT) TYPE  EW_OPSSLOT
*"     REFERENCE(IM_PRESFLD) TYPE  EW_OPSPRESFLD
*"     REFERENCE(IM_USAGETYPE) TYPE  EW_OPSUSAGETYPE
*"     REFERENCE(IM_CLASS) TYPE  CCM_OP_CLASSID
*"     REFERENCE(IM_OBJKEY) TYPE  SWO_OBJID
*"     REFERENCE(IM_HIERARCHY_ACCESS) TYPE REF TO
*"        IF_CCM_NAV_HIERARCHY_ACCESS OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_VALUE) TYPE  TEXT100
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_E229_DISPLAY_PO_NUMBER
* PROGRAM DESCRIPTION: This function module displays po number of
*                      contracts and orders and their items on transaction
*                      summary tab of CIC0 T-code
* DEVELOPER:           AMOHAMMED
* CREATION DATE:       01/17/2020
* REFERENCE NO:        ERPM-7157 - E229
* TRANSPORT NUMBER(S): ED2K917340
*----------------------------------------------------------------------*
* Local Constant Declaration
  CONSTANTS : lc_sno_e229_004   TYPE zsno    VALUE '004',   "Serial Number
              lc_wricef_id_e229 TYPE zdevid  VALUE 'E229',  "Development ID
              lc_hdr_con_class  TYPE ccm_op_classid VALUE 'SD_CONTRACT',
              lc_itm_con_class  TYPE ccm_op_classid VALUE 'SD_CONTRACTITEM',
              lc_hdr_ord_class  TYPE ccm_op_classid VALUE 'SD_ORDER',
              lc_itm_ord_class  TYPE ccm_op_classid VALUE 'SD_ORDERITEM',
              lc_po_txt(3)      TYPE c VALUE 'PO#'.
* Local Data Declaration
  DATA: lv_actv_flag_e229 TYPE zactive_flag. "Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e229  "Development ID (E201)
      im_ser_num     = lc_sno_e229_004    "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e229. "Active / Inactive Flag

  IF lv_actv_flag_e229 EQ abap_true. "Check for Active Flag
    CASE im_class.
      WHEN lc_hdr_con_class OR lc_hdr_ord_class.
        SELECT SINGLE bstnk                      " Fetch PO number at header level
                 FROM vbak
                 INTO @DATA(lv_po)
                WHERE vbeln EQ @im_objkey.
      WHEN lc_itm_con_class OR lc_itm_ord_class.
        SELECT SINGLE bstkd                      " Fetch PO number at item level
                 FROM vbkd
                 INTO lv_po
                WHERE vbeln EQ im_objkey+0(10)
                  AND posnr EQ im_objkey+10(6).
    ENDCASE.
    IF lv_po IS NOT INITIAL.                     " Export PO number if found
      CONCATENATE lc_po_txt lv_po INTO ex_value.
    ENDIF.
    FREE lv_po.
  ENDIF.
ENDFUNCTION.
