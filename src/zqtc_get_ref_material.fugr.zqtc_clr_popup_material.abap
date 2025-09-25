FUNCTION zqtc_clr_popup_material.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      I_BDCDATA STRUCTURE  BDCDATA
*"----------------------------------------------------------------------
*" PROGRAM NAME:        ZQTCN_INSUB_BDC_I0343
*" PROGRAM DESCRIPTION: Include for Inbound Subscription
*" DEVELOPER:           AMOHAMMED
*" CREATION DATE:       01/15/2021
*" OBJECT ID:           I0343
*" TRANSPORT NUMBER(S): ED2K921163
*" DESCRIPTION:         When the POPO ok-code popup is filled with old
*"                      material then clear the field
*"----------------------------------------------------------------------
*" REVISION HISTORY-----------------------------------------------------
*" REVISION NO:
*" REFERENCE NO:
*" DEVELOPER:
*" DATE:
*" DESCRIPTION:
*"----------------------------------------------------------------------
  CONSTANTS : lc_fnam_bdc_okcode     TYPE fnam_____4 VALUE 'BDC_OKCODE',
              lc_fval_popo           TYPE bdc_fval   VALUE 'POPO',
              lc_fnam_rv45a_po_matnr TYPE fnam_____4 VALUE 'RV45A-PO_MATNR'.
  " Check whether the POPO OK-CODE record is filled in BDCDATA internal table
  " i.e. POPO will be triggered
  READ TABLE i_bdcdata TRANSPORTING NO FIELDS
       WITH KEY fnam = lc_fnam_bdc_okcode
                fval = lc_fval_popo.
  IF sy-subrc EQ 0.
    " Check whether the material field in the popup is filled
    READ TABLE i_bdcdata ASSIGNING FIELD-SYMBOL(<fst_bdcdata>)
         WITH KEY fnam = lc_fnam_rv45a_po_matnr.
    IF sy-subrc EQ 0 AND <fst_bdcdata>-fval IS NOT INITIAL.
      " clear the material field
      CLEAR : <fst_bdcdata>-fval.
      MODIFY i_bdcdata INDEX sy-tabix FROM <fst_bdcdata> TRANSPORTING fval.
    ENDIF.
  ENDIF.
ENDFUNCTION.
