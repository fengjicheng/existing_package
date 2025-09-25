*&---------------------------------------------------------------------*
*&  Include           ZQTCC_CREATE_INVOICE_VF04_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PROF_INV_CREATE_E182
* PROGRAM DESCRIPTION: To Create Proforma Invoice for mulitple Contracts
* with same PO for billing plan type ZF5 by using BAPI
* DEVELOPER: Kiran Jagana
* CREATION DATE: 11/13/2018
* OBJECT ID: WRICEF - E182
* TRANSPORT NUMBER(S): ED2K913742
*----------------------------------------------------------------------*
* REVISION NO:   ED2K914601
* REFERENCE NO:  E182
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          03/04/2019
* DESCRIPTION:   Performance Issue fixes
*----------------------------------------------------------------------*
* REVISION NO:   ED1K912811
* REFERENCE NO:  PRB0047260
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* DATE:          25/03/2021
* DESCRIPTION:   Proforma Invoice not being created in when run with
*                blank SD Document and Sold-To Party
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED1K913888
* REFERENCE NO:  INC0407852
* DEVELOPER:     BTIRUVATHU
* DATE:          17-Nov-2021
* DESCRIPTION:   Proforma invoice creation issue
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------**
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .

  SELECT  a~fktyp,     "Billing category
          a~vkorg,     "Sales Organization
          a~fkdat,     "Billing date for billing index and printout
          a~kunnr,     "Sold-to party
          a~fkart,     "Billing Type
          a~vbeln      "Sales and Distribution Document Number
        INTO TABLE @li_vkdfs
        FROM vkdfs  AS a
        INNER JOIN vbuk AS b ON a~vbeln EQ b~vbeln
        INNER JOIN vbak AS c ON a~vbeln EQ c~vbeln
        INNER JOIN vbkd AS d ON a~vbeln EQ d~vbeln
        WHERE a~fkdat IN @s_fkdat
        AND   a~kunnr IN @s_kunnr
        AND   a~fkart IN @s_fkart
        AND   a~vbeln IN @s_vbeln
        AND   b~fksak  NE @c_complete_invoice
        AND   c~vkbur IN @s_vkbur
        AND   d~bsark IN @s_bsark
        AND   d~posnr EQ @space
        ORDER BY a~vbeln.
  IF sy-subrc EQ 0.
    DELETE ADJACENT DUPLICATES FROM li_vkdfs COMPARING ALL FIELDS.
  ENDIF.
  IF li_vkdfs[] IS NOT INITIAL.
    SELECT a~vbelv,         "Preceding sales and distribution document
           a~posnv,         "Preceding item of an SD document
           a~vbeln,         "Subsequent sales and distribution document
           a~posnn,         "Subsequent item of an SD document
           a~vbtyp_n,       "Document category of subsequent document
           b~fkart,         "Billing Type of Billing Document
           b~fksto,         "Billing document is cancelled
           b~rfbsk          "Status for transfer to accounting
       INTO TABLE @li_vbrk
       FROM vbfa AS a
       INNER JOIN vbrk AS b ON a~vbeln EQ b~vbeln
       FOR ALL ENTRIES    IN @li_vkdfs
       WHERE a~vbelv    =  @li_vkdfs-vbeln
       AND  ( a~vbtyp_n EQ @c_vbtyp_rech                     "SD Doc Category - M (Invoice) or - U (Proforma)
       OR    a~vbtyp_n  EQ @c_vbtyp_prof ).
    IF sy-subrc IS INITIAL.
* Check if the billing docs in cancelled status.
      LOOP AT li_vkdfs INTO DATA(lvv_vkdfs).
*        ED1K912811
* BOC by NPALLA ED1K912811 25/03/2021 PRB0047260
*        READ TABLE li_vbrk INTO DATA(lvv_vbrk) WITH KEY  vbelv = lvv_vkdfs-vbeln.
        READ TABLE li_vbrk INTO DATA(lvv_vbrk) WITH KEY  vbelv = lvv_vkdfs-vbeln
                                                         fkart = lvv_vkdfs-fkart.
* EOC by NPALLA ED1K912811 25/03/2021 PRB0047260
        IF sy-subrc NE 0.
          lst_vbeln-vbeln = lvv_vkdfs-vbeln.
          APPEND lst_vbeln TO li_vbeln.
        ENDIF.
        CLEAR: lst_vbeln,lvv_vbrk,lvv_vkdfs.
      ENDLOOP.
      "discard documents in cancelled status
      DELETE li_vbrk WHERE fksto EQ abap_true."this should discard ZF2 with cancel status

      IF li_vbrk IS NOT INITIAL.
        "looks like few documents still exist after filtering all the cancelations
* Begin of Change by BTIRUVATHU INC0407852  ED1K913888
*        DELETE ADJACENT DUPLICATES FROM li_vbrk COMPARING vbeln.
        DELETE ADJACENT DUPLICATES FROM li_vbrk COMPARING vbelv posnv rfbsk.
* End of Change by BTIRUVATHU INC0407852  ED1K913888
      ENDIF.
    ENDIF.
    li_vbrk_tmp[] = li_vbrk[].
    CLEAR lv_glb_flg.
    IF s_vbeln[] IS NOT INITIAL OR s_kunnr[] IS NOT INITIAL.
      "discard documents with cancelled status for transfer to accounting
      DELETE li_vbrk WHERE rfbsk EQ c_zf5_cancel."this should discard cancelled proformas
      SORT li_vkdfs BY vbeln fkart.
      DELETE li_vkdfs WHERE fkart NOT IN s_fkart.
* Raise error message as Document type mismatch
      LOOP AT li_vbrk INTO DATA(lv_vbrk).
        READ TABLE li_vkdfs INTO DATA(lv_vkdfs) WITH KEY vbeln = lv_vbrk-vbeln.
        lst_msg_log-vbeln   = lv_vbrk-vbelv.
        lst_msg_log-proforma   = lv_vbrk-vbeln.
        lst_msg_log-status  = 'Error'(002).
        CONCATENATE 'Contract'(024) lv_vbrk-vbelv  'already have an' '(' lv_vbrk-fkart ')'  'Invoice' lv_vbrk-vbeln  INTO
        lst_msg_log-message SEPARATED BY space.
        APPEND lst_msg_log TO li_msg_log.
        CLEAR : lst_msg_log.
      ENDLOOP.
      lv_glb_flg = c_x.
      PERFORM f_get_data_vbak_vbap.
    ELSE.

      SORT li_vbrk_tmp BY vbelv rfbsk.
      LOOP AT li_vbrk_tmp INTO DATA(lvv_vbrk_tmp) WHERE ( rfbsk = c_zf5_d OR rfbsk = c_complete_invoice ).
        DELETE li_vbrk_tmp WHERE vbelv = lvv_vbrk_tmp-vbelv.
        CLEAR lvv_vbrk_tmp.
      ENDLOOP.
      SORT li_vbrk_tmp BY vbeln fkart.
      DELETE li_vbrk_tmp WHERE fkart NOT IN s_fkart.
      LOOP AT li_vbrk_tmp INTO DATA(ls_vbrk_tmp).
        lst_vbeln-vbeln = ls_vbrk_tmp-vbelv.
        APPEND lst_vbeln TO li_vbeln.
        CLEAR: ls_vbrk_tmp,lst_vbeln.
      ENDLOOP.
      SORT li_vbeln BY vbeln.
      DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING ALL FIELDS.
      CLEAR lv_glb_flg.
      PERFORM f_get_data_vbak_vbap.
    ENDIF.
  ELSE.
    MESSAGE 'Given Selection does not have entries'(011)  TYPE c_i.
    LEAVE LIST-PROCESSING.
  ENDIF.
*  *Begin of Change by KJAGANA CR7804  ED2K913742
  IF NOT li_vbap IS INITIAL.
*Get the Customer Purchase order for the contract numbers which
*we used for creating a single invoice number.
    SELECT vbeln
           posnr
           bstkd
           bsark
      FROM vbkd
      INTO TABLE li_vbkd
      FOR ALL ENTRIES IN li_vbap
      WHERE vbeln EQ li_vbap-vbeln
      AND   posnr EQ li_vbap-posnr.
      SORT li_vbkd BY vbeln posnr.
  ENDIF.
*  *End of Change by KJAGANA CR7804  ED2K913742
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization .
  REFRESH: li_vbap,li_vbrk,li_vkdfs,
           li_billdata,li_error,li_return,
           li_success,li_msg_log,li_fieldcat.
  CLEAR:   lst_fieldcat,lst_billdata,lst_msg_log,
           st_layout,lv_glb_flg.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_INVOICE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_invoice .
  SORT li_vbak BY vbeln.
  SORT li_vkdfs BY vbeln.
  SORT li_msg_log BY vbeln.
*  *Begin of Change by KJAGANA CR7804  ED2K913742
*fill the new interanl table with PO here.
  LOOP AT li_vbap_ch ASSIGNING FIELD-SYMBOL(<lst_vbap>).
    READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) WITH KEY
                                             vbeln = <lst_vbap>-vbeln
                                             posnr = <lst_vbap>-posnr.
    IF sy-subrc EQ 0.
    <lst_vbap>-bstkd = <lst_vbkd>-bstkd.
    ENDIF.
  ENDLOOP.
* *End of Change by KJAGANA CR7804 ED2K913742
*Begin of Change by BTIRUVATHU INC0407852  ED1K913888
** Below statement helps to create single invoices for the same PO
** Number
  SORT li_vbap_ch BY bstkd vbeln posnr.
*End of Change by BTIRUVATHU INC0407852  ED1K913888
*Begin of Change by KJAGANA CR7804  ED2K913742
*  LOOP AT li_vbap INTO DATA(lst_vbap).
  LOOP AT li_vbap_ch INTO DATA(lst_vbap).
* *End of Change by KJAGANA CR7804 ED2K913742
    CLEAR lst_msg_log.
    READ TABLE li_msg_log INTO lst_msg_log WITH KEY vbeln = lst_vbap-vbeln.
*                                           BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE li_vkdfs INTO DATA(lst_vkdfs) WITH KEY vbeln = lst_vbap-vbeln
                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE li_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lst_vbap-vbeln
                                               BINARY SEARCH.
        IF sy-subrc EQ 0.

          lst_billdata-salesorg    = lst_vbak-vkorg.
          lst_billdata-distr_chan  = lst_vbak-vtweg.
          lst_billdata-division    = lst_vbak-spart.
          lst_billdata-doc_type    = lst_vbak-auart.
          lst_billdata-ordbilltyp  = lst_vkdfs-fkart.
          lst_billdata-bill_date   = sy-datum.
          lst_billdata-item_categ  = lst_vbap-pstyv.
          lst_billdata-price_date  = sy-datum.
          lst_billdata-plant       = lst_vbap-werks.
          lst_billdata-ref_doc     = lst_vbak-vbeln.
          lst_billdata-material    = lst_vbap-matnr.
          lst_billdata-req_qty     = lst_vbap-zmeng.
          lst_billdata-currency    = lst_vbap-waerk.
          lst_billdata-ref_item    = lst_vbap-posnr.
          lst_billdata-doc_number  = lst_vbak-vbeln.
          lst_billdata-itm_number  = lst_vbap-posnr.
          lst_billdata-ref_doc_ca  = lst_vbak-vbtyp.
*          *Begin of Change by KJAGANA CR7804  ED2K913742
*          Getting the PO number and passed to billdata.
          READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_d>) WITH KEY
                                                    vbeln = lst_vbap-vbeln
                                                    posnr = lst_vbap-posnr
                                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
          lst_billdata-purch_ord = <lst_vbkd_d>-bstkd.
          ENDIF.
*          *End of Change by KJAGANA CR7804 on   ED2K913742
          APPEND lst_billdata TO li_billdata.
        ELSE.
* Raise error message as Document type mismatch
          CLEAR : lst_msg_log.
          lst_msg_log-vbeln   = lst_vbak-vbeln.
          lst_msg_log-status  = 'Error'(002).
          CONCATENATE 'Given Document'(014) lst_vbak-vbeln 'does not exists'(015)
          INTO lst_msg_log-message SEPARATED BY space.
          APPEND lst_msg_log TO li_msg_log.
        ENDIF.
      ELSE.
* Raise error message as Document type mismatch
        CLEAR : lst_msg_log.
        lst_msg_log-vbeln   = lst_vbak-vbeln.
        lst_msg_log-status  = 'Error'(002).
        CONCATENATE 'Invoice is already created for'(016) lst_vbak-vbeln
        INTO lst_msg_log-message SEPARATED BY space.
        APPEND lst_msg_log TO li_msg_log.
      ENDIF.
    ELSE.
* Error messages
    ENDIF.
**     *Begin of Change by KJAGANA CR7804  ED2K913742
*Mulitple contracts are with SAME PO(BSTKD),so put the
*condition on PO to send all li_billdata to BAPI.
*    AT END OF vbeln.
    AT END OF BSTKD.
**     *End of Change by KJAGANA CR7804  ED2K913742

* Process BAPI to create Invoice
      IF li_billdata IS NOT INITIAL.
        CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
          TABLES
            billingdatain = li_billdata
*           CONDITIONDATAIN       =
*           CCARDDATAIN   =
*           TEXTDATAIN    =
            errors        = li_error
            return        = li_return
            success       = li_success.
* Error messages
        IF li_error IS NOT INITIAL.
*--*If BAPI returns error or abort Rollback Transaction
*--* And build the Idoc status record with status 51
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          LOOP AT li_error INTO DATA(lst_error).
            CLEAR : lst_msg_log.
            lst_msg_log-vbeln   = lst_error-ref_doc.
            lst_msg_log-posnr   = lst_error-ref_doc_item.
            lst_msg_log-status  = 'Error'(002).
            lst_msg_log-message = lst_error-message.
          ENDLOOP.
        ENDIF.
* Sucess messages
        IF  li_success IS NOT INITIAL.
*--*If BAPI return no error then commit the transaction
*--* and build the Idoc status record with status 53.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = c_x.
          LOOP AT li_success INTO DATA(lst_success).
            CLEAR : lst_msg_log.
            lst_msg_log-vbeln   = lst_success-ref_doc.
            lst_msg_log-posnr   = lst_success-ref_doc_item.
            lst_msg_log-proforma   = lst_success-bill_doc.
            lst_msg_log-item   = lst_success-bill_doc_item.
            lst_msg_log-status  = 'Success'(004).
            lst_msg_log-message = 'Document Created Successfully'(028).
            APPEND lst_msg_log TO li_msg_log.
          ENDLOOP.
        ENDIF.
* Any other error messages
        IF li_error IS INITIAL AND
           li_success IS INITIAL AND
           li_return IS NOT INITIAL.
*--*If BAPI returns error or abort Rollback Transaction
*--* And build the Idoc status record with status 51
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          LOOP AT li_return INTO DATA(lst_return).
            CLEAR : lst_msg_log.
            lst_msg_log-vbeln   = lst_vbak-vbeln.
            IF lst_return-type = c_e.
              lst_msg_log-status = 'Error'(002).
            ELSEIF lst_return-type = c_w.
              lst_msg_log-status = 'Warning'(020).
            ENDIF.
            lst_msg_log-message = lst_return-message.
            APPEND lst_msg_log TO li_msg_log.
          ENDLOOP.
        ENDIF.
      ENDIF.
      REFRESH : li_billdata,
                li_error,
                li_return,
                li_success.
    ENDAT.
    CLEAR : lst_billdata.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_log .
  DATA : lv_cnt   TYPE i.

  lv_cnt = 1.
  PERFORM build_fieldcat USING lv_cnt 'VBELN'     'Sales Document'(006).
  lv_cnt = 2.
  PERFORM build_fieldcat USING lv_cnt 'POSNR'     'Sales Item no'(007).
  lv_cnt = 3.
  PERFORM build_fieldcat USING lv_cnt 'PROFORMA'  'Invoice/Proforma No'(021).
  lv_cnt = 4.
  PERFORM build_fieldcat USING lv_cnt 'ITEM'      'Invoice/Proforma Item No'(022).
  lv_cnt = 5.
  PERFORM build_fieldcat USING lv_cnt 'STATUS'    'Message Status'(008).
  lv_cnt = 6.
  PERFORM build_fieldcat USING lv_cnt 'MESSAGE'   'Message Description'(009).

  st_layout-colwidth_optimize = c_x.
  st_layout-zebra = c_x.
  SORT li_msg_log BY vbeln posnr.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      is_layout                = st_layout
      it_fieldcat              = li_fieldcat
    TABLES
      t_outtab                 = li_msg_log
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_CNT  text
*      -->P_0559   text
*      -->P_0560   text
*----------------------------------------------------------------------*
FORM build_fieldcat  USING  p_lv_cnt  TYPE i
                            p_fld     TYPE fieldname
                            p_title   TYPE itex132.
  DATA : lc_length TYPE i VALUE 90.
  lst_fieldcat-col_pos      = p_lv_cnt.
  lst_fieldcat-fieldname    = p_fld.
  lst_fieldcat-seltext_m    = p_title.
  IF p_lv_cnt = 6.
    lst_fieldcat-outputlen = lc_length.
  ENDIF.
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR : lst_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DYNAMIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic .
*- Define the object to be passed to the RESTRICTION parameter
  DATA: lst_restrict TYPE sscr_restrict,
        lst_optlist  TYPE sscr_opt_list,
        lst_ass      TYPE sscr_ass.
* Constant Declaration
  CONSTANTS: lc_name              TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lc_flag              TYPE flag       VALUE 'X',          " General Flag
             lc_kind              TYPE rsscr_kind VALUE 'S',          " ABAP: Type of selection
             lc_name1             TYPE blockname  VALUE 'S_FKART',    " Block name on selection screen
             lc_vkbur             TYPE blockname  VALUE 'S_VKBUR',    " Block name on selection screen
             lc_bsark             TYPE blockname  VALUE 'S_BSARK',    " Block name on selection screen
             lc_sg_main           TYPE raldb_sign VALUE 'I',          " SIGN field in creation of SELECT-OPTIONS tables
             lc_sg_addy           TYPE raldb_sign VALUE space,        " SIGN field in creation of SELECT-OPTIONS tables
             lc_op_main           TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lc_devid_e182        TYPE zdevid      VALUE 'E182',                "Development ID: E182
             lc_billing_from_date TYPE rvari_vnam VALUE 'BILLING_FROM_DATE'.
  CLEAR: lst_optlist , lst_ass.
* Restricting the KURST selection to only EQ.
  lst_optlist-name = lc_name.
  lst_optlist-options-eq = lc_flag.
  APPEND lst_optlist TO lst_restrict-opt_list_tab.

  lst_ass-kind = lc_kind.
  lst_ass-name = lc_name1.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CLEAR lst_ass.
  lst_ass-kind = lc_kind.
  lst_ass-name = lc_vkbur.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CLEAR lst_ass.
  lst_ass-kind = lc_kind.
  lst_ass-name = lc_bsark.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lst_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*- Dynamic selection for Billing date from
  IF li_const_values_e182[] IS INITIAL.
    SELECT param1                                                  "ABAP: Name of Variant Variable
           param2                                                  "ABAP: Name of Variant Variable
           srno                                                    "Current selection number
           sign                                                    "ABAP: ID: I/E (include/exclude values)
           opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
           low                                                     "Lower Value of Selection Condition
           high                                                     "Upper Value of Selection Condition
      FROM zcaconstant
      INTO TABLE li_const_values_e182
     WHERE devid    EQ lc_devid_e182                              "Development ID
       AND activate EQ abap_true.
  ENDIF.
  IF li_const_values_e182[] IS NOT INITIAL.
    READ TABLE li_const_values_e182 INTO st_const_values WITH KEY param1 = lc_billing_from_date.
    IF sy-subrc EQ 0.
      s_fkdat-low = sy-datum - st_const_values-low.
    ENDIF.
  ENDIF.
  s_fkdat-high = sy-datum.
  APPEND s_fkdat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FKDAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_fkdat .
  SELECT SINGLE fkdat                                   "#EC CI_NOFIRST
    FROM vkdfs
     INTO @DATA(lv_fkdat)
     WHERE fkdat IN @s_fkdat.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given Billing document dates does not have data'(019).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VBELN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_vbeln .
  SELECT SINGLE vbeln
    FROM vkdfs
     INTO @DATA(lv_vbeln)
     WHERE vbeln IN @s_vbeln.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given Sales document does not exist'(018).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KUNNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_kunnr .
  SELECT SINGLE kunnr                                   "#EC CI_NOFIRST
    FROM vkdfs
     INTO @DATA(lv_kunnr)
     WHERE kunnr IN @s_kunnr.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given Sold-to does not exist'(017).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FKART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_fkart .
  SELECT SINGLE fkart                                   "#EC CI_NOFIRST
    FROM vkdfs
     INTO @DATA(lv_fkart)
     WHERE fkart IN @s_fkart.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given Billing Type does not exist'(025).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VKBUR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_vkbur .
  SELECT SINGLE vkbur                                   "#EC CI_NOFIELD
    FROM vbak
     INTO @DATA(lv_vkbur)
     WHERE vkbur IN @s_vkbur.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given Sales Office does not exist'(026).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BSARK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_bsark .
  SELECT SINGLE bsark                                   "#EC CI_NOFIELD
    FROM vbkd
     INTO @DATA(lv_bsark)
     WHERE bsark IN @s_bsark.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Given PO Type does not exist'(027).
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_VBAK_VBAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_vbak_vbap .
  IF lv_glb_flg IS INITIAL.
* SOC by "NPOLINA ED2K914601 04/03/2019 Performance Issue
*    IF li_vbrk[] IS NOT INITIAL.
    IF li_vbeln[] IS NOT INITIAL.
* EOC by "NPOLINA ED2K914601 04/03/2019 Performance Issue
      SELECT vbeln   "Sales Document

             vbtyp   "SD document category
             auart   "Sales Document Type
             vkorg   "Sales Organization
             vtweg   "Distribution Channel
             spart   "Division
             vkbur   "Sales Office
        FROM vbak
        INTO TABLE li_vbak
        FOR ALL ENTRIES IN li_vbeln
        WHERE vbeln = li_vbeln-vbeln.
      IF li_vbak[] IS NOT INITIAL.
        SELECT vbeln,  "Sales Document
               posnr,  "Sales Document Item
               matnr,  "Material Number
               pstyv,  "Sales document item category
               zmeng,  "Target quantity in sales units
               waerk,  "SD Document Currency
               werks   "Plant (Own or External)
          INTO  TABLE @li_vbap
          FROM vbap
          FOR ALL ENTRIES IN @li_vbak
          WHERE vbeln = @li_vbak-vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbap BY vbeln posnr.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    IF li_vkdfs[] IS NOT INITIAL.
      SELECT vbeln   "Sales Document
             vbtyp   "SD document category
             auart   "Sales Document Type
             vkorg   "Sales Organization
             vtweg   "Distribution Channel
             spart   "Division
             vkbur   "Sales Office
        FROM vbak
        INTO TABLE li_vbak
        FOR ALL ENTRIES IN li_vkdfs
        WHERE vbeln = li_vkdfs-vbeln.
      IF li_vbak[] IS NOT INITIAL.
        SELECT vbeln,  "Sales Document
               posnr,  "Sales Document Item
               matnr,  "Material Number
               pstyv,  "Sales document item category
               zmeng,  "Target quantity in sales units
               waerk,  "SD Document Currency
               werks   "Plant (Own or External)
          INTO  TABLE @li_vbap
          FROM vbap
          FOR ALL ENTRIES IN @li_vbak
          WHERE vbeln = @li_vbak-vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbap BY vbeln posnr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*  *Begin of Change by KJAGANA CR7804  ED2K913742
*Passing the data to new internal table..later fill the
*PO,..Before process the data to BAPI.
MOVE-CORRESPONDING li_vbap to li_vbap_ch.
*  *End of Change by KJAGANA CR7804  ED2K913742
ENDFORM.
