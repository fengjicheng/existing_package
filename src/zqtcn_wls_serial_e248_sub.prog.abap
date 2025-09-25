*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_SERIAL_E248_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_process_data USING f_lst_interface TYPE zcainterface.
  TYPES:BEGIN OF ty_sernp,
          sign   TYPE  ddsign,
          option TYPE  ddoption,
          low    TYPE  ism_pk_pstvy,
          high   TYPE  ism_pk_pstvy,
        END OF ty_sernp,
        BEGIN OF ty_nast_t,
          objky        TYPE na_objkey,         "Object key number
          sales        TYPE vbeln_va,          "Sales order number
          delivery     TYPE vbeln_vl,          "Delivery number
          invoice      TYPE vbeln_vf,          "Invoice number
          message(200) TYPE c,                 "Message
        END OF ty_nast_t.
****Local constant variables
  CONSTANTS:lc_doc_type_m TYPE char1        VALUE 'M',   " Invoice document
            lc_doc_type_j TYPE char1        VALUE 'J',   " Delivery documents
            lc_kappl      TYPE sna_kappl    VALUE 'V3',   " Application
            lc_devid_e248 TYPE zdevid       VALUE 'E248', " Development id
            lc_sernp_e248 TYPE rvari_vnam   VALUE 'SERAIL',
            lc_kschl      TYPE rvari_vnam   VALUE 'KSCHL',      "Output type
            lc_vkorg      TYPE rvari_vnam   VALUE 'VKORG',      "Output type
            lc_vbtyp_c    TYPE vbtyp_v      VALUE 'C'.
** Local data declaration.
  DATA:
    lir_sernp_range_e248 TYPE STANDARD TABLE OF ty_sernp,
    lt_nast_t            TYPE STANDARD TABLE OF ty_nast_t,
    ls_nast_t            TYPE ty_nast_t,
    lir_vkorg_range_e248 TYPE fip_t_vkorg_range,
    lv_ser_flag          TYPE c,
    lc_comm              TYPE c VALUE ',',
    li_constants_e248    TYPE zcat_constants.    "Constant Values
  FREE:lt_nast_t,li_constants_e248,lir_vkorg_range_e248.
*---Check the Constant table before going to the actual logic.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e248  "Development ID
    IMPORTING
      ex_constants = li_constants_e248. "Constant Values

  LOOP AT li_constants_e248[] ASSIGNING FIELD-SYMBOL(<lfs_constant_e248>).
*---Serial Number Profile from constant value
    IF <lfs_constant_e248>-param1   = lc_sernp_e248.
      APPEND INITIAL LINE TO lir_sernp_range_e248 ASSIGNING FIELD-SYMBOL(<lst_sernp_range>).
      <lst_sernp_range>-sign   = <lfs_constant_e248>-sign.
      <lst_sernp_range>-option = <lfs_constant_e248>-opti.
      <lst_sernp_range>-low    = <lfs_constant_e248>-low.
    ELSEIF <lfs_constant_e248>-param1 = lc_vkorg.
      APPEND INITIAL LINE TO lir_vkorg_range_e248 ASSIGNING FIELD-SYMBOL(<lst_vkorg_range>).
      <lst_vkorg_range>-sign     = <lfs_constant_e248>-sign.
      <lst_vkorg_range>-option   = <lfs_constant_e248>-opti.
      <lst_vkorg_range>-low      = <lfs_constant_e248>-low.
    ENDIF.
    IF <lfs_constant_e248>-param1   = lc_kschl.
      gv_kschl = <lfs_constant_e248>-low.
    ENDIF.
  ENDLOOP.
  IF s_erdat IS NOT INITIAL OR s_vbeln IS NOT INITIAL.
    SELECT vbeln FROM vbrk
                     INTO TABLE @DATA(lt_vbrk)
                     WHERE vbeln IN @s_vbeln AND
                           erdat IN @s_erdat AND
                           vkorg IN @lir_vkorg_range_e248.
  ELSE.
** Get the invoice numbers from based on creation date
    SELECT vbeln FROM vbrk
                   INTO TABLE lt_vbrk
                   WHERE erdat GE f_lst_interface-lrdat AND
                    vkorg IN lir_vkorg_range_e248.
  ENDIF.
  IF lt_vbrk[] IS NOT INITIAL.
    SELECT vbeln,posnr,aubel,aupos,matnr,werks
                 FROM vbrp
                 INTO TABLE @DATA(lt_vbrp)
                 FOR ALL ENTRIES IN @lt_vbrk
                 WHERE vbeln = @lt_vbrk-vbeln.
*                       vgtyp = @lc_vbtyp_c. "Order invoices
    IF sy-subrc = 0.
      SORT lt_vbrp BY vbeln posnr.
    ENDIF.
    DATA(lt_vbrp_mat) = lt_vbrp[].
    SORT lt_vbrp_mat BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_vbrp_mat COMPARING matnr werks.
    IF lt_vbrp_mat[] IS NOT INITIAL.
****** Check the materil number in MARC table
***   Identify the eligible Serial number materials from field MARC-SERNP having the value “ZWLS”.
      SELECT matnr,werks FROM marc
                         INTO TABLE @DATA(lt_marc)
                         FOR ALL ENTRIES IN @lt_vbrp_mat
                         WHERE matnr = @lt_vbrp_mat-matnr AND
                               werks = @lt_vbrp_mat-werks AND
                               sernp IN @lir_sernp_range_e248.
      REFRESH:lt_vbrp_mat[].
***Loop the invoice number and append eligible Serial number invoice materias
** to another internal table
      LOOP AT lt_vbrp INTO DATA(ls_vbrp_mat).
        READ TABLE lt_marc INTO DATA(ls_marc) WITH KEY matnr = ls_vbrp_mat-matnr.
        IF sy-subrc = 0.
          APPEND ls_vbrp_mat TO lt_vbrp_mat.
          CLEAR:ls_vbrp_mat.
        ENDIF.
      ENDLOOP.
      IF lt_marc[] IS NOT INITIAL AND lt_vbrp_mat[] IS NOT INITIAL.
        " Fetch Delivery number and invoice number of the sales order
        SELECT vbelv,
             posnv,
             vbeln,
             posnn,
             vbtyp_n,
             vbtyp_v,
             matnr
                 FROM vbfa
                 INTO TABLE @DATA(lt_vbfa_ord)
                 FOR ALL ENTRIES IN @lt_vbrp_mat
                 WHERE vbelv = @lt_vbrp_mat-aubel
                 AND posnv = @lt_vbrp_mat-aupos.
*                 AND vbtyp_n = @lc_doc_type_j.
*                 AND vbtyp_v = @lc_vbtyp_c.
        " Fetch object list number based on delivery number

          DELETE lt_vbfa_ord WHERE vbtyp_n NE lc_doc_type_j.
        IF lt_vbfa_ord[] IS NOT INITIAL.
          SELECT obknr, lief_nr,posnr
            FROM ser01
            INTO TABLE @DATA(li_ser01)
            FOR ALL ENTRIES IN @lt_vbfa_ord
            WHERE lief_nr EQ @lt_vbfa_ord-vbeln AND
                  posnr EQ @lt_vbfa_ord-posnn.
        ENDIF.
        IF li_ser01 IS NOT INITIAL.
          SORT li_ser01 BY obknr.
          " Fetch serial number and material based on object lis number
          SELECT obknr, sernr, matnr
            FROM objk
            INTO TABLE @DATA(li_objk)
            FOR ALL ENTRIES IN @li_ser01
            WHERE obknr EQ @li_ser01-obknr.
        ENDIF.
        LOOP AT lt_vbrp_mat INTO DATA(ls_vbrp).
          READ TABLE lt_vbfa_ord INTO DATA(ls_vbfa_ord)
          WITH KEY vbelv =  ls_vbrp-aubel  "order number
          posnv = ls_vbrp-aupos vbtyp_n = lc_doc_type_j.   "item in order
          IF sy-subrc = 0." AND ls_vbfa_ord-vbtyp_v = lc_vbtyp_c.
            CLEAR:lv_ser_flag.
** lv_ser_flag purpoase,if deliver number having two eligible materials for serial number
** If one material is having Snumber and other is not have Snumber then Nast entry should not create
            READ TABLE li_ser01 INTO DATA(ls_ser01)
                                WITH KEY lief_nr = ls_vbfa_ord-vbeln "Deliver number
                                         posnr = ls_vbfa_ord-posnn. "Item
            IF sy-subrc = 0.
              READ TABLE li_objk INTO DATA(ls_objk) WITH KEY obknr = ls_ser01-obknr.
              IF sy-subrc = 0 AND ls_objk-sernr IS NOT INITIAL. "Serial number exist for that delivery
                lv_ser_flag = abap_true."If serial number validation sucess, output would be determined
              ENDIF.
            ELSE.
              lv_ser_flag = abap_false."No serial number exist for material
            ENDIF.
            READ TABLE lt_nast_t ASSIGNING FIELD-SYMBOL(<fs_nast>)
                           WITH KEY invoice = ls_vbrp-vbeln.
            IF sy-subrc NE 0.
              ls_nast_t-objky = ls_vbrp-vbeln.
              ls_nast_t-sales = ls_vbrp-aubel.
              ls_nast_t-delivery = ls_vbfa_ord-vbeln.
              ls_nast_t-invoice = ls_vbrp-vbeln.
              IF lv_ser_flag = abap_false.
                ls_nast_t-message = text-018.
              ENDIF.
              APPEND ls_nast_t TO lt_nast_t.
            ENDIF.
            CLEAR:ls_nast_t,lv_ser_flag.
          ELSE.
*            IF ls_vbfa_ord-vbtyp_v = lc_vbtyp_c.
            "Delivery is not exist for the invoice, No output would be determined
            ls_nast_t-objky = ls_vbrp-vbeln.
            ls_nast_t-sales = ls_vbrp-aubel.
            ls_nast_t-invoice = ls_vbrp-vbeln.
            ls_nast_t-message = text-019.
            APPEND ls_nast_t TO lt_nast_t.
            CLEAR:ls_nast_t.
*            ENDIF.
          ENDIF."IF sy-subrc = 0.
        ENDLOOP."LOOP AT lt_vbrp INTO DATA(ls_vbrp).
      ENDIF."lt_marc[] IS NOT INITIAL AND lt_vbrp_mat[] IS NOT INITIAL.
    ENDIF." IF lt_vbrp_mat[] IS NOT INITIAL.
  ENDIF."IF lt_vbrp[] IS NOT INITIAL.
  IF lt_nast_t IS NOT INITIAL.
    SORT lt_nast_t BY objky.
    DELETE ADJACENT DUPLICATES FROM lt_nast_t COMPARING objky.
    SELECT objky FROM nast INTO TABLE @DATA(lt_nast)
      FOR ALL ENTRIES IN @lt_nast_t
      WHERE kappl = @lc_kappl AND
      objky = @lt_nast_t-objky AND
      kschl = @gv_kschl.
    LOOP AT lt_nast_t INTO ls_nast_t.
      READ TABLE lt_nast TRANSPORTING NO FIELDS WITH KEY objky = ls_nast_t-objky.
      IF sy-subrc NE 0.
*If there are line items eligible for Serial number then allow the Output to be processed.
        lst_output-sales =  ls_nast_t-sales.
        lst_output-deliv = ls_nast_t-delivery.
        lst_output-invoice = ls_nast_t-invoice.
        IF ls_nast_t-message IS NOT INITIAL.
          lst_output-message = ls_nast_t-message. "No serial number exist for invoices
        ELSE.
          lst_output-message = text-002. "Serial number exists for invoices
          lst_output-flag_nast = abap_true.
        ENDIF.
        lst_output-objky = ls_nast_t-objky.
        APPEND lst_output TO i_output.
        CLEAR:lst_output.
      ENDIF.
      CLEAR:ls_nast_t.
    ENDLOOP.
  ENDIF.
  IF i_output IS NOT INITIAL.
    PERFORM create_nast_entry.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RUN_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_run_date .
* Local constant Declaration
  DATA : lst_interface    TYPE zcainterface, " Interface run details
         lst_zcainterface TYPE zcainterface.
  SELECT SINGLE *
       FROM zcainterface          " Interface run details
       INTO lst_zcainterface
       WHERE devid  = c_devid.
  IF sy-subrc = 0.
    PERFORM f_get_process_data USING lst_zcainterface.
  ELSE.
*    *  Please maintain table ZCAINTERFACE.
    MESSAGE i104(zqtc_r2) DISPLAY LIKE c_error. " Please maintain table ZCAINTERFACE.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc = 0
  IF lst_zcainterface IS NOT INITIAL AND p_test IS INITIAL.
* Update the table ZCAINTERFACE with last run date & time
* Lock the Table entry
    CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
      EXPORTING
        mode_zcainterface = abap_true                 "Lock mode
        mandt             = sy-mandt                  "01th enqueue argument (Client)
        devid             = c_devid                   "02th enqueue argument (Development ID)
        param1            = lst_zcainterface-param1 "03th enqueue argument (ABAP: Name of Variant Variable)
*       param2            = lc_param2                 "04th enqueue argument (ABAP: Name of Variant Variable)
      EXCEPTIONS
        foreign_lock      = 1
        system_failure    = 2
        OTHERS            = 3.

    IF sy-subrc EQ 0.
      lst_interface-mandt  = sy-mandt. "Client
      lst_interface-devid  = c_devid. "Development ID
      lst_interface-param1 = space.
      lst_interface-lrdat  = sy-datum. "Last run date
      lst_interface-lrtime = sy-uzeit. "Last run time

* Modify (Insert / Update) the Table entry
      MODIFY zcainterface FROM lst_interface.

* Unlock the Table entry
      CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
    ELSE. " ELSE -> IF sy-subrc EQ 0
*   Error Message
      MESSAGE ID sy-msgid  "Message Class
            TYPE c_info    "Message Type: Information
          NUMBER sy-msgno  "Message Number
            WITH sy-msgv1  "Message Variable-1
                 sy-msgv2  "Message Variable-2
                 sy-msgv3  "Message Variable-3
                 sy-msgv4. "Message Variable-4
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
FORM f_display_output .
*  Build Fieldcatalog
  PERFORM f_build_fieldcatalog.
*  Display ALV
  PERFORM f_display_alv.
ENDFORM.
FORM f_build_fieldcatalog .
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lv_col_pos       TYPE i.

*  Populate fieldcatalog
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SALES'.
  lst_fieldcatalog-seltext_m   = 'Sales Document'(004).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'DELIV'.
  lst_fieldcatalog-seltext_m   = 'Delivery Number'(005).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'INVOICE'.
  lst_fieldcatalog-seltext_m   = 'Invoice Number'(006).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'KSCHL'.
  lst_fieldcatalog-seltext_m   = 'Output Type'(014).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'MEDIUM'.
  lst_fieldcatalog-seltext_m   = 'Medium'(009).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PARVW'.
  lst_fieldcatalog-seltext_m   = 'Function'(010).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PARNR'.
  lst_fieldcatalog-seltext_m   = 'Partner'(011).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SPRAS'.
  lst_fieldcatalog-seltext_m   = 'Language'(012).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 10.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_l   = 'Message'(007).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 50.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
ENDFORM.
FORM f_display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = i_fieldcatalog[]
      i_save             = abap_true
    TABLES
      t_outtab           = i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_fieldcatalog[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_NAST_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_nast_entry .
  DATA : lw_nast        TYPE nast,
         lv_subrc       TYPE syst_subrc,
         li_dd07v_tab_a TYPE dd07v_tab,                    "View on fixed values and domain texts
         li_dd07v_tab_n TYPE dd07v_tab.                    "View on fixed values and domain texts
  CONSTANTS: lc_kappl    TYPE char2    VALUE 'V3',          " Application for message conditions
*             lc_nacha_5  TYPE char1    VALUE 5,             " Message transmission medium
*             lc_nacha_1  TYPE char1    VALUE 1,             " Message transmission medium
             lc_proc_suc TYPE na_vstat VALUE '1',     " sucessfully processed
             lc_ldest    TYPE char4    VALUE 'LP01',        " Spool: Output device
             lc_objtype  TYPE char10   VALUE 'VBRK',        " Object type
             lc_int      TYPE ad_comm VALUE 'INT',          " email
             lc_dm_nacha TYPE domname VALUE 'NA_NACHA',     "Message transmission medium domain name
             lc_let      TYPE ad_comm VALUE 'LET'.          " print
  FREE:li_dd07v_tab_a,li_dd07v_tab_n,lw_nast.
**Condition Types: Additional Data for Sending Output
  SELECT SINGLE * FROM t685b
                 INTO @DATA(ls_t685b)
                 WHERE kschl = @gv_kschl
                 AND   kappl = @lc_kappl.
  IF sy-subrc = 0.
    SELECT vbeln,parvw,kunnr FROM vbpa
                       INTO TABLE @DATA(lt_vbpa)
                       FOR ALL ENTRIES IN @i_output
                       WHERE vbeln = @i_output-invoice
                       AND parvw = @ls_t685b-parvw.
  ENDIF.
* Fetch Domain Values
  CALL FUNCTION 'DD_DOMA_GET'
    EXPORTING
      domain_name   = lc_dm_nacha                  "Domain Name: NA_NACHA
      withtext      = abap_true
    TABLES
      dd07v_tab_a   = li_dd07v_tab_a                  "View on fixed values and domain texts
      dd07v_tab_n   = li_dd07v_tab_n                  "View on fixed values and domain texts
    EXCEPTIONS
      illegal_value = 1
      op_failure    = 2
      OTHERS        = 3.
  IF sy-subrc NE 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  LOOP AT i_output ASSIGNING FIELD-SYMBOL(<fs_out>) WHERE flag_nast = abap_true.
    READ TABLE lt_vbpa INTO DATA(lw_vbpa) WITH KEY vbeln = <fs_out>-invoice.
    IF sy-subrc = 0.
      READ TABLE li_dd07v_tab_a INTO DATA(ls_text)
                                WITH KEY domvalue_l = p_nacha.
      IF sy-subrc = 0.
        <fs_out>-medium = ls_text-ddtext.
      ENDIF.
      <fs_out>-parvw = lw_vbpa-parvw.
      <fs_out>-parnr = lw_vbpa-kunnr.
      <fs_out>-spras = sy-langu.
      IF p_test IS INITIAL.
        lw_nast-parnr = lw_vbpa-kunnr.
        lw_nast-parvw = lw_vbpa-parvw.
        lw_nast-kappl = lc_kappl.
        lw_nast-objky = lw_vbpa-vbeln.
        lw_nast-kschl = gv_kschl.
        lw_nast-spras = sy-langu.
        lw_nast-erdat = sy-datum.
        lw_nast-eruhr = sy-uzeit.
        lw_nast-nacha = p_nacha..                        "Message transmission medium
*        lw_nast-vsztp = p_vsztp.                             "Dispatch time
        lw_nast-usnam = sy-uname.
        lw_nast-ldest = lc_ldest.                             "Output device
        IF ls_t685b-strategy IS NOT INITIAL.
          lw_nast-tcode = ls_t685b-strategy.                    "Comm strategy.
        ENDIF.
        lw_nast-tdarmod = ls_t685b-tdarmod.                     "Print: Archiving mode
        lw_nast-objtype = lc_objtype.
        CALL FUNCTION 'WFMC_MESSAGE_SINGLE'
          EXPORTING
            pi_nast  = lw_nast
          IMPORTING
            pe_rcode = lv_subrc.
        IF lv_subrc = 0.
          <fs_out>-message = text-003.
        ELSE.
          <fs_out>-message = text-017.
        ENDIF.
        CLEAR:lw_nast.
      ENDIF.
    ENDIF."lt_vbpa IF sy-subrc = 0.
  ENDLOOP.
ENDFORM.
