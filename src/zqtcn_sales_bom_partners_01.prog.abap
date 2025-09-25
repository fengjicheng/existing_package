*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_SALES_BOM_PARTNERS_01 [Called from
*                      USEREXIT_MOVE_FIELD_TO_VBKD (MV45AFZZ)]
* PROGRAM DESCRIPTION: Copy Partner Detail from BOM Header to Components
*                      when Ship-to Party is changed
* DEVELOPER(S):        Sayantan Das
* CREATION DATE:       05/25/2018
* OBJECT ID:           E134 (RITM0028165)
* TRANSPORT NUMBER(S): ED1K907497
*----------------------------------------------------------------------*
DATA:
  li_xvbap_e134  TYPE va_vbapvb_t,
  li_xvbuv_e134  TYPE va_vbuvvb_t,
  li_hvbuv_e134  TYPE va_vbuvvb_t,
  li_xvbadr_e134 TYPE tt_sadrvb,
  li_yvbadr_e134 TYPE tt_sadrvb.

IF rv02p-weupd       EQ abap_true. " Ship-to Party is changed
  INCLUDE zqtcn_sales_bom_partners IF FOUND.

* Get data from local memory - Sales Document: Partner
  CALL FUNCTION 'SD_PARTNER_DATA_GET'
    EXPORTING
      fic_objecttype      = lv_obj_typ                      "Object type
      fic_objectkey       = lv_obj_key                      "Object key
    TABLES
      fet_xvbpa           = li_prt_det                      "Partner Details
      fet_xvbuv           = li_xvbuv_e134
      fet_hvbuv           = li_hvbuv_e134
      fet_xvbadr          = li_xvbadr_e134
      fet_yvbadr          = li_yvbadr_e134
    EXCEPTIONS
      no_object_specified = 1
      no_object_found     = 2
      merge_failed        = 3
      OTHERS              = 4.
  IF sy-subrc EQ 0.
    DELETE li_prt_det WHERE parvw NE parvw_we
                         OR posnr EQ posnr_low.
    IF li_prt_det[] IS NOT INITIAL.

      li_xvbap_e134[] = xvbap[].
      SORT li_xvbap_e134 BY vbeln uepos.
      READ TABLE li_xvbap_e134 TRANSPORTING NO FIELDS
           WITH KEY vbeln = vbap-vbeln
                    uepos = vbap-posnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT li_xvbap_e134 ASSIGNING FIELD-SYMBOL(<lst_xvbap_e134>) FROM sy-tabix.
          IF <lst_xvbap_e134>-vbeln NE vbap-vbeln OR
             <lst_xvbap_e134>-uepos NE vbap-posnr.
            EXIT.
          ENDIF.

          READ TABLE li_prt_det ASSIGNING FIELD-SYMBOL(<lst_prt_det>)
               WITH KEY vbeln = <lst_xvbap_e134>-vbeln
                        posnr = <lst_xvbap_e134>-posnr
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_xvbpa_e134>)
                 WITH KEY vbeln = <lst_xvbap_e134>-vbeln
                          posnr = <lst_xvbap_e134>-posnr
                          parvw = parvw_we.
            IF sy-subrc NE 0.
              APPEND <lst_prt_det> TO xvbpa.
            ELSEIF <lst_xvbpa_e134>-kunnr NE <lst_prt_det>-kunnr.
              IF <lst_xvbpa_e134>-updkz IS INITIAL.
                APPEND INITIAL LINE TO yvbpa ASSIGNING FIELD-SYMBOL(<lst_yvbpa_e134>).
                MOVE-CORRESPONDING <lst_xvbpa_e134> TO <lst_yvbpa_e134>.
                UNASSIGN: <lst_yvbpa_e134>.
              ENDIF.

              MOVE-CORRESPONDING <lst_prt_det> TO <lst_xvbpa_e134>.
            ENDIF.
          ENDIF.
        ENDLOOP.
        SORT: xvbpa BY vbeln posnr parvw,
              yvbpa BY vbeln posnr parvw.
        CALL FUNCTION 'SD_PARTNER_DATA_PUT'
          EXPORTING
            fic_objecttype              = lv_obj_typ                      "Object type
            fic_objectkey               = lv_obj_key                      "Object key
          TABLES
            frt_xvbpa                   = xvbpa[]
            frt_yvbpa                   = yvbpa[]
            frt_xvbuv                   = li_xvbuv_e134
            frt_hvbuv                   = li_hvbuv_e134
            frt_xvbadr                  = li_xvbadr_e134
            frt_yvbadr                  = li_yvbadr_e134
          EXCEPTIONS
            no_object_specified         = 1
            no_object_creation_possible = 2
            OTHERS                      = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
