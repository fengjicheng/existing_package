*----------------------------------------------------------------------*
* Program Name : ZQTCN_ZADR_SUBCOMP_UPDATE_E101                        *
* REVISION NO :  ED2K924543                                            *
* REFERENCE NO: OTCM-44200                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 09/16/2021                                             *
* DESCRIPTION : ZADR Document BOM sub component reference document and *
*               line item update| both VBAP and VBFA tables            *
*----------------------------------------------------------------------*

DATA : li_ordtype    TYPE TABLE OF edm_auart_range,                 " Order type range declaration
       li_constant   TYPE          zcat_constants,                  " Internal table for constant value
       lv_refdoc     TYPE          vgbel,                           " Referenc document
       lv_refdoc_itm TYPE          vgpos,                          " Reference document line item
       lv_vbfa_item  TYPE          POSNR_NACH.

CONSTANTS : lc_uepos       TYPE uepos        VALUE '000000',      " BOM Header dentification
            lc_doc_typ     TYPE rvari_vnam   VALUE 'AUART',       " ABAP: Name of Variant Variable
            lc_devid_exxxx TYPE zdevid       VALUE 'EXXX'.        " WRICEF ID

FIELD-SYMBOLS : <lfs_tmp_xvfa_xxxx> TYPE xvbfa.

REFRESH : li_constant , li_ordtype.
CLEAR   : lv_refdoc, lv_refdoc_itm , lv_vbfa_item.

" Works only for BAPI Calls
IF call_bapi IS NOT INITIAL.
  " Fetch constant value
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_exxxx
    IMPORTING
      ex_constants = li_constant.

  IF li_constant IS NOT INITIAL.
    SORT li_constant BY param1.
    LOOP AT li_constant INTO DATA(lst_constant).
      CASE param1.
        WHEN lc_doc_typ. " Document type
          APPEND INITIAL LINE TO li_ordtype ASSIGNING FIELD-SYMBOL(<lst_ordtyp>).
          <lst_ordtyp>-sign = lst_constant-sign.
          <lst_ordtyp>-option = lst_constant-opti.
          <lst_ordtyp>-low = lst_constant-low.
          <lst_ordtyp>-high = lst_constant-high.
        WHEN OTHERS.
          " Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF vbak-auart IN li_ordtype. " Check document type is equals to ZADR

    LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lfs_xvbap_xxxx>).
      IF <lfs_xvbap_xxxx>-uepos = lc_uepos.     " Check the BOM header compenent and get the ref doc and line item
        CLEAR : lv_refdoc , lv_refdoc_itm , lv_vbfa_item.

        lv_refdoc = <lfs_xvbap_xxxx>-vgbel.
        lv_refdoc_itm = <lfs_xvbap_xxxx>-vgpos.

        " Read Doucmnet flow table(VBFA) with BOM header component and get the header component data.
        READ TABLE xvbfa ASSIGNING FIELD-SYMBOL(<lfs_xvbfa_xxxx>) WITH KEY vbelv = lv_refdoc posnv = lv_refdoc_itm BINARY SEARCH.
        IF sy-subrc = 0.
          ASSIGN <lfs_xvbfa_xxxx> TO <lfs_tmp_xvfa_xxxx>.   " xvbfa data assign to temporary structure.
          lv_vbfa_item = <lfs_xvbfa_xxxx>-posnn.
        ENDIF.
      ELSE.                                     " BOM Sub component.
        <lfs_xvbap_xxxx>-vgbel = lv_refdoc.

        lv_refdoc_itm = lv_refdoc_itm + 10.     " Get next Line item
        <lfs_xvbap_xxxx>-vgpos = lv_refdoc_itm.

        " Append new records to vbfa table with BOM sub component reference document , line item and price.
        APPEND INITIAL LINE TO xvbfa ASSIGNING <lfs_tmp_xvfa_xxxx>.
        <lfs_tmp_xvfa_xxxx>-vbelv = lv_refdoc.                  " Reference doument
        <lfs_tmp_xvfa_xxxx>-posnv = lv_refdoc_itm.              " Reference document line item
        lv_vbfa_item  = lv_vbfa_item + 10.
        <lfs_tmp_xvfa_xxxx>-posnn = lv_vbfa_item.               " ZADR document line item
        <lfs_tmp_xvfa_xxxx>-rfwrt = <lfs_xvbap_xxxx>-netwr.     " Sub component price

      ENDIF.
    ENDLOOP.

    REFRESH : li_constant, li_ordtype.
    CLEAR   : lv_refdoc, lv_refdoc_itm , lv_vbfa_item.

  ENDIF.
ENDIF.
