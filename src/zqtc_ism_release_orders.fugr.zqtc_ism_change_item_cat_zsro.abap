FUNCTION zqtc_ism_change_item_cat_zsro.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(CONTRACT) TYPE  VBAK-VBELN OPTIONAL
*"     REFERENCE(ITEM) TYPE  VBAP-POSNR OPTIONAL
*"     REFERENCE(NIP) TYPE REF TO  CL_ISM_SE_NIP OPTIONAL
*"     REFERENCE(ISSUE) TYPE  MARA-MATNR OPTIONAL
*"     REFERENCE(PRODUCT) TYPE  MARA-MATNR OPTIONAL
*"     REFERENCE(QUANTITY) TYPE  RJKSEORDERGENADD-QUANTITY OPTIONAL
*"     REFERENCE(UNIT) TYPE  RJKSEORDERGENADD-UNIT OPTIONAL
*"     REFERENCE(NEXTISSUE) TYPE  CHAR01 OPTIONAL
*"     REFERENCE(MSG) TYPE REF TO  CL_ISM_SD_MESSAGE OPTIONAL
*"     REFERENCE(BUFFER_REFRESH) TYPE  CHAR01 OPTIONAL
*"  EXPORTING
*"     REFERENCE(CONDITION) TYPE  FUNCNAME
*"     REFERENCE(AUART) TYPE  VBAK-AUART
*"     REFERENCE(PSTYV) TYPE  VBAP-PSTYV
*"  EXCEPTIONS
*"      NOT_FOUND
*"----------------------------------------------------------------------
CONSTANTS:
     lc_pstyv_zdup    TYPE pstyv    VALUE 'ZDUP',
     lc_pstyv_zsro    TYPE pstyv    VALUE 'ZSRO',
     lc_stufe_01      TYPE char02   VALUE '01',
     lc_stufe_00      TYPE char02   VALUE '00',
     lc_contract      TYPE char01   VALUE 'G',
     lc_auart_grc     TYPE auart    VALUE 'ZGRC'.
*--------------------------------------------------------------------*
*

*
BREAK-POINT.
*CALL FUNCTION 'ISM_SE_SELECT_TJSEORDERTYPE'
*  EXPORTING
*    contract             = contract
*    item                 = item
*    nip                  = nip
*    issue                = issue
*    product              = product
*    quantity             = quantity
*    unit                 = unit
*    nextissue            = nextissue
*    msg                  = msg
*   buffer_refresh       = abap_true
* IMPORTING
*   condition            = condition
*   auart                = auart
*   pstyv                = pstyv
* EXCEPTIONS
*   not_found            = 1
*   OTHERS               = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*BREAK-POINT.
*
**--Get the Main Subscription(ZSUB) order from ZREW
*SELECT SINGLE
*       vbelv,   "main sub
*       posnv,
*       vbeln,   "Renewal order
*       posnn,
*       stufe
*  FROM vbfa
*  INTO @DATA(lst_vbfa_main)
*  WHERE vbeln   EQ @contract    AND
*       posnn    EQ @item        AND
*       vbtyp_n  EQ @lc_contract AND   "'G'
*       stufe    EQ @lc_stufe_01.      "'01'
*
*  IF sy-subrc EQ 0.
*
**--Get the Gracing document (ZGRC) From Main Sub
*    SELECT SINGLE
*           a~vbelv, "main sub
*           a~posnv,
*           a~vbeln, "Grace order
*           a~posnn,
*           a~vbtyp_n,
*           a~stufe,
*           b~auart
*       FROM vbfa AS a
*       INNER JOIN vbak AS b ON ( b~vbeln EQ a~vbeln )
*       INTO @DATA(lst_vbfa_grace)
*       WHERE a~vbelv   EQ @lst_vbfa_main-vbelv AND
*             a~posnv   EQ @lst_vbfa_main-posnv AND
*             a~vbtyp_n EQ @lc_contract         AND    "'G'
*             a~stufe   EQ @lc_stufe_00         AND    "'00'
*             b~auart   EQ @lc_auart_grc.              "'ZGRC'.
*
*
*    IF sy-subrc EQ 0.  "if found
*
**--If Grace order found check if release order created for Grace
*
*    SELECT SINGLE
*            vbeln,  "Grace order
*            posnr,
*            issue,
*            xorder_created
*      FROM jksesched
*      INTO @DATA(lst_jksesched)
*      WHERE vbeln EQ @lst_vbfa_grace-vbeln AND
*            posnr EQ @lst_vbfa_grace-posnn AND
*            issue EQ @issue                AND
*            xorder_created EQ @abap_true.
*
*        IF sy-subrc EQ 0. "Order Created
*
*          pstyv = lc_pstyv_zdup.
*
*         ELSE. "No Release order created
*
*          pstyv = lc_pstyv_zsro.
*
*        ENDIF.
*
*
*    ELSE. "if no Grace order found
*
*       pstyv = lc_pstyv_zsro.
*
*    ENDIF.
*
*
*
*
*  ENDIF.








ENDFUNCTION.
