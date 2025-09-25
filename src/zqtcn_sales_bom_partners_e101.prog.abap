*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_SALES_BOM_PARTNERS_E101 [Called from
*                      Function Module SD_SALES_ITEM_MAINTAIN]
* PROGRAM DESCRIPTION: Copy Partner Detail from BOM Header to Components
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       08/24/2017
* OBJECT ID:           E134
* TRANSPORT NUMBER(S): ED2K908155
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908347
* REFERENCE NO: ERP-4065
* DEVELOPER: Writtick Roy
* DATE:  09/05/2017
* DESCRIPTION: Check if BOM Component already has the Partner added
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  li_constnt TYPE zcat_constants,                               "Constant Values
  li_pf_excl TYPE zcat_constants,                               "Constant Values (Partner Functions)
  li_prt_det TYPE va_vbpavb_t.                                  "Sales Document: Partner

CONSTANTS:
  lc_id_e134 TYPE zdevid     VALUE 'E134',                      "Development ID (E134)
  lc_prtnr_f TYPE rvari_vnam VALUE 'PARTNER_FUNC_EXCL'.         "Name of Variant Variable: Partner Function

IF vbap-posnr IS NOT INITIAL AND
*  Begin of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
   vbap-uepos IS INITIAL.
*  End   of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
* Check if the Order line has any specific entry for the Partner Func
* Assumption: Standard Internal Table is already SORTed against Item#
  READ TABLE xvbpa TRANSPORTING NO FIELDS
       WITH KEY posnr = vbap-posnr                              "Line Item: BOM Header
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    DATA(lv_tabix_p) = sy-tabix.

*   Check if the current Line Item is a BOM Header
    READ TABLE xvbap TRANSPORTING NO FIELDS
         WITH KEY uepos = vbap-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_i) = sy-tabix.

*     Retrieve the Constant values
      CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
        EXPORTING
          im_devid     = lc_id_e134                             "Development ID (E134)
        IMPORTING
          ex_constants = li_constnt.                            "Constant Values
*     Partner Functions to be excluded
      li_pf_excl[] = li_constnt[].
      DELETE li_pf_excl WHERE param1 NE lc_prtnr_f.

      LOOP AT xvbpa INTO DATA(lst_xvbpa_bom_h) FROM lv_tabix_p.
        IF lst_xvbpa_bom_h-posnr NE vbap-posnr.
          EXIT.
        ENDIF.
*       Exclude certain Partner Functions
*       BINARY SEARCH not used, since the Int Table will have very limited entries
        READ TABLE li_pf_excl TRANSPORTING NO FIELDS
             WITH KEY low = lst_xvbpa_bom_h-parvw.              "Partner Function
        IF sy-subrc EQ 0.
          CONTINUE.
        ENDIF.

*       Loop through BOM Components
        LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lst_bom_itm>) FROM lv_tabix_i.
          IF <lst_bom_itm>-uepos NE vbap-posnr.
            EXIT.
          ENDIF.

*         Begin of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
          READ TABLE xvbpa INTO DATA(lst_xvbpa_bom_i)
               WITH KEY posnr = <lst_bom_itm>-posnr             "Line Item: BOM Component
                        parvw = lst_xvbpa_bom_h-parvw           "Partner Function
               BINARY SEARCH.
          IF sy-subrc NE 0.
*         End   of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
            lst_xvbpa_bom_i = lst_xvbpa_bom_h.
            lst_xvbpa_bom_i-posnr = <lst_bom_itm>-posnr.
            APPEND lst_xvbpa_bom_i TO xvbpa.
            CLEAR: lst_xvbpa_bom_i.
*         Begin of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
          ELSE.
            DATA(lv_line_indx) = sy-tabix.
*           If Partner Values (Customer Number / Vendor Number /
*           Personnel Number / Contact Person) are different
            IF lst_xvbpa_bom_i-kunnr NE lst_xvbpa_bom_h-kunnr OR
               lst_xvbpa_bom_i-lifnr NE lst_xvbpa_bom_h-lifnr OR
               lst_xvbpa_bom_i-pernr NE lst_xvbpa_bom_h-pernr OR
               lst_xvbpa_bom_i-parnr NE lst_xvbpa_bom_h-parnr.
              lst_xvbpa_bom_i = lst_xvbpa_bom_h.
              lst_xvbpa_bom_i-posnr = <lst_bom_itm>-posnr.
              MODIFY xvbpa FROM lst_xvbpa_bom_i INDEX lv_line_indx.
              CLEAR: lst_xvbpa_bom_i.
            ENDIF.
          ENDIF.
*         End   of ADD:ERP-4065:WROY:05-SEP-2017:ED2K908347
        ENDLOOP.
      ENDLOOP.
      SORT xvbpa BY vbeln posnr parvw.
    ENDIF.
  ENDIF.
ENDIF.
