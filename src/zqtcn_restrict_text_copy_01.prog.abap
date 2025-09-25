*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTRICT_TEXT_COPY_01 (Include)
*               Called from Routine 900(RV45T900)
* PROGRAM DESCRIPTION: Copy Customer Text for YBP/OASIS Contracts
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 06/13/2018
* OBJECT ID: I0233 (ERP-6425)
* TRANSPORT NUMBER(S): ED2K912297
*----------------------------------------------------------------------*
DATA:
  li_constants TYPE zcat_constants.                             "Wiley Application Constant Table

DATA:
  lv_so_header TYPE char30     VALUE '(SAPFV45P)VBAK'.          "ABAP Stack: SD Header Data

FIELD-SYMBOLS:
  <lst_so_hdr> TYPE vbak.                                       "Sales Document: Header Data

CONSTANTS:
  lc_dev_i0233 TYPE zdevid     VALUE 'I0233',                   "Development ID
  lc_p_cust_po TYPE rvari_vnam VALUE 'CUST_PO_TYPE'.            "Parameter: Customer Purchase Order Type

STATICS:
  lr_cst_po_typ TYPE tdt_rg_bsark.                              "Range: Customer Purchase Order Type

IF lr_cst_po_typ IS INITIAL.                                    "Range: Customer Purchase Order Type
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_i0233                               "Development ID
    IMPORTING
      ex_constants = li_constants.                             "Constant Values
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>).
    CASE <lst_constants>-param1.
      WHEN lc_p_cust_po.                                        "Parameter: Customer Purchase Order Type
        APPEND INITIAL LINE TO lr_cst_po_typ ASSIGNING FIELD-SYMBOL(<lst_cst_po_typ>).
        <lst_cst_po_typ>-sign   = <lst_constants>-sign.
        <lst_cst_po_typ>-option = <lst_constants>-opti.
        <lst_cst_po_typ>-low    = <lst_constants>-low.
        <lst_cst_po_typ>-high   = <lst_constants>-high.

      WHEN OTHERS.
*       Do nothing.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>).
ENDIF. " IF lr_cst_po_typ IS INITIAL

bp_subrc = 4.                                                   "Text will not be copied
ASSIGN (lv_so_header) TO <lst_so_hdr>.                          "Sales Document: Header Data
IF sy-subrc EQ 0 AND
   <lst_so_hdr>-bsark IN lr_cst_po_typ.                         "Customer Purchase Order Type
  bp_subrc = 0.                                                 "Text will be copied
ENDIF.
