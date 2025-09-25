*&---------------------------------------------------------------------*
*&  Include           ZPALLETTEST_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  f_get_pallet_rpt
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_pallet_rpt .
  DATA : ls_final TYPE ty_final.
  DATA : lt_values TYPE TABLE OF dd07v.

  SELECT a~pallet_no,
         a~status,
         a~sto,
         b~return_order,
         b~return_delv
  FROM zpal_header AS a
  INNER JOIN zpal_item AS b  ON a~pallet_no = b~pallet_no
  INTO TABLE @DATA(li_pallet_data)
  WHERE a~pallet_no  IN @s_pallet.

  IF li_pallet_data[] IS NOT INITIAL.
    " Get  Return Delivery details
    SELECT a~wbstk, "status
           b~vbeln, "return delivery
           b~posnr, "return delivery line item
           b~matnr, "material
           b~lfimg, "qty
           b~ean11, "ISBN
           b~vrkme  "UoM

      FROM vbuk AS a
      INNER JOIN lips AS b ON a~vbeln EQ b~vbeln
       INTO TABLE @DATA(li_ret_delv_details)
      FOR ALL ENTRIES IN @li_pallet_data
      WHERE a~vbeln = @li_pallet_data-return_delv
      AND   b~pstyv EQ @v_e508_pstyv.

    " Get STO details
    SELECT a~ebeln, "STO
           a~aedat, "STI creation date
           b~vbeln, "Replenisment delv
           b~erdat, "Replenisment delv creation date
           c~wbstk  ""Replenisment delv PGI status
      FROM ekko AS a
      LEFT OUTER JOIN lips AS b ON a~ebeln = b~vgbel
      LEFT OUTER JOIN vbuk AS c ON c~vbeln = b~vbeln
      INTO TABLE @DATA(li_sto_details)
      FOR ALL ENTRIES IN @li_pallet_data
      WHERE a~ebeln =  @li_pallet_data-sto.
  ENDIF.

*Get Status Text
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = c_domname
      text            = 'X'
    TABLES
      values_tab      = lt_values
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  " sort the Internal tables of reading
  SORT li_pallet_data BY return_delv ASCENDING .
  SORT li_ret_delv_details BY vbeln ASCENDING .
  SORT li_sto_details BY ebeln ASCENDING.
  "prepare final Internal table
  LOOP AT li_ret_delv_details INTO DATA(ls_ret_delv).

    READ TABLE li_pallet_data INTO DATA(ls_pallet_data)
          WITH KEY return_delv = ls_ret_delv-vbeln  BINARY SEARCH .
    IF sy-subrc = 0.
      ls_final-pallet_no     = ls_pallet_data-pallet_no.

      ls_final-pallet_status = ls_pallet_data-status.

      ls_final-return_order  = ls_pallet_data-return_order.
      ls_final-return_delv   = ls_pallet_data-return_delv.
      ls_final-sto           = ls_pallet_data-sto.

      READ TABLE li_sto_details INTO DATA(ls_sto)
          WITH KEY ebeln = ls_pallet_data-sto BINARY SEARCH.
      IF sy-subrc = 0.
        ls_final-sto_create_date         = ls_sto-aedat.
        ls_final-replenishment_delv      = ls_sto-vbeln.
        ls_final-replenisment_date       = ls_sto-erdat.

        READ TABLE lt_values ASSIGNING FIELD-SYMBOL(<lst_values>) WITH KEY domvalue_l = ls_sto-wbstk.
        IF sy-subrc = 0.
          CONCATENATE ls_sto-wbstk '-(' <lst_values>-ddtext ')'
            INTO ls_final-replenisment_pgi_status.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE lt_values ASSIGNING FIELD-SYMBOL(<lst_values_1>)
           WITH KEY domvalue_l = ls_ret_delv-wbstk.
    IF sy-subrc = 0.
      CONCATENATE ls_ret_delv-wbstk '-(' <lst_values_1>-ddtext ')'
        INTO ls_final-return_delv_status.
    ENDIF.

    ls_final-return_delv_lineitem = ls_ret_delv-posnr.
    ls_final-material             = ls_ret_delv-matnr.
    ls_final-isbn                 = ls_ret_delv-ean11.
    ls_final-qty                  = ls_ret_delv-lfimg.
    ls_final-uom                  = ls_ret_delv-vrkme.

    APPEND ls_final TO i_final.
    CLEAR : ls_final.

  ENDLOOP.
*  ***** Add Pallets with no Delivery date***********
  IF li_pallet_data[] IS NOT INITIAL.
    LOOP AT li_pallet_data INTO DATA(lst_pallet_data) WHERE return_delv IS INITIAL.
      ls_final-pallet_no = lst_pallet_data-pallet_no.
      ls_final-return_order  = lst_pallet_data-return_order.
      ls_final-pallet_status = lst_pallet_data-status.

      APPEND ls_final TO i_final.


      CLEAR ls_final.

    ENDLOOP.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcatalog .
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lst_layout       TYPE slis_layout_alv,
        li_fieldcatalog  TYPE slis_t_fieldcat_alv,
        lst_sort         TYPE slis_sortinfo_alv.

  lst_fieldcatalog-fieldname   = 'PALLET_NO'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l  = 'Pallet ID'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'PALLET_STATUS'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l  = 'Pallet Status'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'RETURN_ORDER'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l  = 'Return Order'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'RETURN_DELV'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l  = 'Return Delivery'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'RETURN_DELV_STATUS'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l  = 'Return Delivery PGR Status'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'RETURN_DELV_LINEITEM'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Ret.Del Item'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MATERIAL'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Material'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'ISBN'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'ISBN'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'QTY'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Quantity'.
  lst_fieldcatalog-do_sum = 'X'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'UOM'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'UoM'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'STO'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'STO'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'STO_CREATE_DATE'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'STO Creation Date'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'REPLENISHMENT_DELV'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Rep.Del Delivery'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'REPLENISMENT_DATE'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Rep.Del Creation Date'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'REPLENISMENT_PGI_STATUS'.
  lst_fieldcatalog-tabname     = 'I_FINAL'.
  lst_fieldcatalog-seltext_l   = 'Rep.Del PGI Status'.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR  lst_fieldcatalog.

  " Determine Sort Sequence
  lst_sort-spos = 1.                           " Sort order
  lst_sort-fieldname = 'PALLET_NO'.
  lst_sort-tabname = 'I_FINAL'.
  lst_sort-up = 'X'.
  lst_sort-subtot = 'X'.                      " Sub total allowed
  lst_sort-group = 'X'.
  APPEND lst_sort TO i_sort.
  CLEAR lst_sort.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv .
  DATA : lst_layout TYPE  slis_layout_alv.
  IF i_final[] IS NOT INITIAL.
    lst_layout-colwidth_optimize = abap_true.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        is_layout     = lst_layout
        it_fieldcat   = i_fieldcat
        it_sort       = i_sort
*       i_default     = 'X'
        i_save        = 'A'
      TABLES
        t_outtab      = i_final
      EXCEPTIONS
        program_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      CLEAR i_fieldcat[].

    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_STO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_sto .

  DATA : lr_pallet    TYPE RANGE OF ekko-ihrez,
         li_matnr_sum TYPE tt_matnr_sum,
         li_lips_temp TYPE tt_matnr_sum,
         ls_poitem    TYPE  bapimepoitem,
         li_poitem    TYPE STANDARD TABLE OF  bapimepoitem,
         ls_sto_final TYPE  ty_sto_final.

  CONSTANTS : lc_close TYPE  char10 VALUE 'CLOSED',
              lc_open  TYPE  char10 VALUE 'OPEN'.
  " Get the Pallet Hader details
  SELECT * FROM zpal_header INTO TABLE @DATA(li_pal_header)
    WHERE pallet_no IN @s_pallet.
  "AND status = @lc_status.

  IF sy-subrc = 0.

    i_pallet_header = li_pal_header[].

    " If STO is created for the pallet then ignore the Pallet ID
    SELECT ebeln,aedat,ihrez FROM ekko
    INTO TABLE @DATA(li_ekko)
    FOR ALL ENTRIES IN @li_pal_header
    WHERE ihrez = @li_pal_header-pallet_no
    AND   bukrs = @v_e508_bukrs
    AND   bsart = @v_e508_bsart
    AND   reswk = @v_e508_werks_1.

    IF sy-subrc = 0.
      SORT li_ekko BY ihrez.
    ENDIF.
    IF li_ekko[] IS NOT INITIAL.
      i_pallet_rejected = VALUE #( FOR ls_ekko IN li_ekko ( pallet_no   = ls_ekko-ihrez
                                                            status      = c_wbstk
                                                            created_on = ls_ekko-aedat
                                                            sto = ls_ekko-ebeln
                                                            ) ).
      SORT i_pallet_rejected BY pallet_no.

*      lr_pallet = VALUE #( FOR ls_ekko IN li_ekko ( sign   = 'I'
*                                                    option = 'EQ'
*                                                    low    = ls_ekko-ihrez
*                        ) ).
*
*      IF lr_pallet[] IS NOT INITIAL.
*        DELETE li_pal_header WHERE pallet_no IN lr_pallet.
*      ENDIF.

*      LOOP AT li_ekko INTO DATA(ls_ekko).
*        READ TABLE i_pal_header INTO DATA(ls_pal_header) WITH KEY pallet_no = ls_ekko-ihrez.
*        IF sy-subrc = 0.
*          MOVE-CORRESPONDING ls_pal_header TO ls_sto_final.
*          ls_sto_final-not_process = 'X'.
*          ls_sto_final-sto_status  = 'X'.
*
*          APPEND ls_sto_final TO i_sto_final.
*
*        ENDIF.
*        CLEAR : ls_sto_final.
*      ENDLOOP.
    ENDIF. "li_ekko
  ENDIF. "li_pal_header

  IF li_pal_header[] IS NOT INITIAL.
    SELECT * FROM zpal_item
      INTO TABLE @i_pallet_item
      FOR ALL ENTRIES IN @li_pal_header
      WHERE pallet_no EQ @li_pal_header-pallet_no.
    IF sy-subrc = 0.
      SELECT vbeln,wbstk FROM vbuk INTO TABLE @DATA(li_vbuk)
        FOR ALL ENTRIES IN @i_pallet_item
        WHERE vbeln = @i_pallet_item-return_delv
        AND   wbstk = 'C'.
    ENDIF. "i_pallet_item

    DATA(i_pallet_item_temp) = i_pallet_item[].
    SORT i_pallet_item_temp BY pallet_no.
    SORT li_vbuk BY vbeln.

    "Consider only Pallet whose all the retun delivery is in status 'C'
    LOOP AT i_pallet_item_temp INTO DATA(ls_pal_item).
      " proceed only is pallet in not rejected from above step
      READ TABLE i_pallet_rejected INTO ls_pallet_rejected
            WITH KEY pallet_no = ls_pal_item-pallet_no
            BINARY SEARCH.
      IF sy-subrc NE 0.

        READ TABLE li_vbuk INTO DATA(ls_vbuk) WITH KEY vbeln = ls_pal_item-return_delv
                                                       wbstk = 'C' BINARY SEARCH.
        IF sy-subrc NE 0.
          DATA(lv_reject_pallet) = abap_true.
        ENDIF.

        AT END OF pallet_no.
          IF lv_reject_pallet = abap_true .
*            DELETE i_pallet_item WHERE pallet_no EQ ls_pal_item-pallet_no.
            ls_pallet_rejected-pallet_no = ls_pal_item-pallet_no.
            ls_pallet_rejected-status = 'B'.
            APPEND ls_pallet_rejected TO i_pallet_rejected.
            CLEAR ls_pallet_rejected.
          ENDIF.
          CLEAR : lv_reject_pallet.
        ENDAT.

        CLEAR : ls_vbuk, ls_pal_item.
      ENDIF.
    ENDLOOP.
    REFRESH : i_pallet_item_temp[].
  ENDIF."li_pal_headers

  SORT i_pallet_rejected BY pallet_no.
  DELETE ADJACENT DUPLICATES FROM i_pallet_rejected COMPARING pallet_no.
**** Get return delivery details*************
  IF i_pallet_item[] IS NOT INITIAL.
    SELECT a~pallet_no,
           a~return_order,
           b~vbeln,
           b~posnr,
           b~pstyv,
           b~matnr,
           b~ean11,
           b~lfimg,
           b~vrkme
      FROM zpal_item AS a
      INNER JOIN lips AS b
      ON a~return_delv = b~vbeln
      INTO TABLE @DATA(li_lips)
      WHERE pallet_no IN @s_pallet.

    IF sy-subrc = 0.
      li_lips_temp = CORRESPONDING #( li_lips[] ).
      SORT li_lips_temp BY pallet_no matnr.
      LOOP AT li_lips_temp INTO DATA(ls_matnr_sum).
        COLLECT ls_matnr_sum INTO li_matnr_sum.
        CLEAR ls_matnr_sum.
      ENDLOOP.
    ENDIF.
  ENDIF.

  " prepare PO item table
  IF li_matnr_sum[] IS NOT INITIAL.
    SORT :li_matnr_sum BY pallet_no matnr,
          li_lips  BY pallet_no matnr.

    LOOP AT li_matnr_sum INTO ls_matnr_sum.
      READ TABLE li_lips INTO DATA(ls_lips)
             WITH KEY pallet_no = ls_matnr_sum-pallet_no
                      matnr = ls_matnr_sum-matnr
                      BINARY SEARCH.
      IF sy-subrc = 0.
        ls_sto_final-return_delv  = ls_lips-vbeln.
        ls_sto_final-return_delv_lineitem = ls_lips-posnr.
        ls_sto_final-material  = ls_lips-matnr.
        ls_sto_final-isbn      = ls_lips-ean11.
        ls_sto_final-qty       = ls_matnr_sum-lfimg.
        ls_sto_final-uom       = ls_lips-vrkme.
        ls_sto_final-item_cat  = ls_lips-pstyv.
        ls_sto_final-plant     = v_e508_werks_2.
        ls_sto_final-stge_loc  = v_e508_lgort.
        ls_sto_final-pallet_no = ls_lips-pallet_no.
        ls_sto_final-return_order = ls_lips-return_order.

*        READ TABLE i_pallet_item INTO ls_pal_item WITH KEY return_delv = ls_lips-vbeln.
*        IF sy-subrc = 0.
*          ls_sto_final-pallet_no = ls_pal_item-pallet_no.
*          ls_sto_final-return_order = ls_pal_item-return_order.
        READ TABLE i_pallet_header INTO is_pal_header WITH KEY pallet_no = ls_lips-pallet_no.
        IF sy-subrc = 0.
          ls_sto_final-pallet_status = is_pal_header-status.

        ENDIF.
*        ENDIF.

        " if the pallet is rejected from above step set the status as not processed
        READ TABLE i_pallet_rejected INTO ls_pallet_rejected
              WITH KEY pallet_no = ls_lips-pallet_no
              BINARY SEARCH.
        IF sy-subrc = 0.
          IF ls_pallet_rejected-status = c_wbstk AND ls_sto_final-pallet_status NE lc_open.
            ls_sto_final-sto = ls_pallet_rejected-sto.
            ls_sto_final-sto_create_date = ls_pallet_rejected-created_on.
            ls_sto_final-message = 'STO already exists'(005).
          ELSEIF ls_pallet_rejected-status = 'B' AND ls_sto_final-pallet_status NE lc_open.
            ls_sto_final-message = 'All deliveries are NOT Complete(C)'(007).
          ENDIF.
          ls_sto_final-not_process = abap_true.
          ls_sto_final-sto_status = 'Not Processed'(003).

        ENDIF.
        APPEND ls_sto_final TO i_sto_final.
      ENDIF.

      CLEAR: ls_sto_final,ls_matnr_sum,ls_pal_item.
    ENDLOOP.
  ENDIF.


  SORT i_sto_final BY pallet_no.
  "call bapi
  PERFORM f_bapi_po_create  .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_PO_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_POITEM  text
*----------------------------------------------------------------------*

FORM f_bapi_po_create .

  DATA: ls_header  TYPE bapimepoheader,
        ls_headerx TYPE bapimepoheaderx,
        ls_poitem  TYPE  bapimepoitem,
        li_poitem  TYPE  bapimepoitem_tp,
        li_poitemx TYPE bapimepoitemx_tp,
        ls_poitemx TYPE bapimepoitemx,
        li_return  TYPE bapiret2_tt,
        lv_ebeln   TYPE ekko-ebeln,
        lv_msg     TYPE string.

  CONSTANTS :lc_close TYPE  char20 VALUE 'CLOSED',
             lc_open  TYPE  char20 VALUE 'OPEN',
             lc_item  TYPE  ebelp  VALUE 00010.

  ls_header-comp_code =  v_e508_bukrs.
  ls_header-doc_type   = v_e508_bsart.
  ls_header-purch_org  = v_e508_ekorg.
  ls_header-pur_group  = v_e508_ekgrp.
  ls_header-suppl_plnt = v_e508_werks_1.


  ls_headerx-comp_code  = abap_true.
  ls_headerx-doc_type   = abap_true.
  ls_headerx-purch_org  = abap_true.
  ls_headerx-pur_group  = abap_true.
  ls_headerx-suppl_plnt = abap_true.



*  APPEND ls_poitemx TO li_poitemx.
  DATA(lv_item_count) = lc_item.
  LOOP AT i_sto_final ASSIGNING FIELD-SYMBOL(<st_sto_final>)
                 WHERE not_process NE abap_true.
    IF <st_sto_final>-pallet_status EQ lc_close.

      ls_poitem-po_item =  lv_item_count.
      ls_poitem-material = <st_sto_final>-material.
      ls_poitem-quantity = <st_sto_final>-qty.
      ls_poitem-po_unit  = <st_sto_final>-uom.
      ls_poitem-plant    = <st_sto_final>-plant.
      ls_poitem-stge_loc = <st_sto_final>-stge_loc.

      APPEND ls_poitem TO li_poitem.

      ls_poitemx-po_item =  lv_item_count.
      ls_poitemx-po_itemx = abap_true.
      ls_poitemx-material = abap_true.
      ls_poitemx-plant    = abap_true.
      ls_poitemx-stge_loc = abap_true.
      ls_poitemx-quantity = abap_true.
      ls_poitemx-po_unit  = abap_true.
      APPEND ls_poitemx TO li_poitemx.

      DATA(lv_pallet_no) = <st_sto_final>-pallet_no.
      AT END OF pallet_no.
        ls_header-ref_1       = lv_pallet_no.
        ls_headerx-ref_1       = abap_true.

        CALL FUNCTION 'BAPI_PO_CREATE1'
          EXPORTING
            poheader         = ls_header
            poheaderx        = ls_headerx
          IMPORTING
            exppurchaseorder = lv_ebeln
          TABLES
            return           = li_return
            poitem           = li_poitem
            poitemx          = li_poitemx.

        IF lv_ebeln IS NOT INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

          READ TABLE i_pallet_header ASSIGNING FIELD-SYMBOL(<lst_pallet_header>)
           WITH KEY pallet_no = <st_sto_final>-pallet_no.
          IF sy-subrc = 0.

            <lst_pallet_header>-sto = lv_ebeln.
            MODIFY zpal_header FROM <lst_pallet_header> .
          ENDIF.

        ELSE.
          READ TABLE li_return INTO DATA(ls_return) WITH KEY type = 'E'.
          IF sy-subrc = 0.
            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
              EXPORTING
                msgid               = ls_return-id          "Messg class
                msgnr               = ls_return-number      "Messg No.
                msgv1               = ls_return-message_v1
                msgv2               = ls_return-message_v2
                msgv3               = ls_return-message_v3
                msgv4               = ls_return-message_v4
              IMPORTING
                message_text_output = lv_msg.

            <st_sto_final>-sto_status = lv_msg.
          ENDIF.
        ENDIF.
        CLEAR : li_poitem[],lv_item_count,li_poitemx[],li_return[].
      ENDAT.
    ENDIF.
    lv_item_count = lv_item_count + 10.
    CLEAR : ls_poitem,lv_pallet_no,ls_poitemx.
  ENDLOOP.

*STO Output Table population
  LOOP AT i_sto_final ASSIGNING <st_sto_final>
                WHERE not_process = abap_false.
    READ TABLE i_pallet_header ASSIGNING FIELD-SYMBOL(<lst_pal_header>)
                WITH KEY pallet_no = <st_sto_final>-pallet_no.
    IF sy-subrc = 0 AND <lst_pal_header>-sto IS NOT INITIAL.
      <st_sto_final>-sto = <lst_pal_header>-sto.
      <st_sto_final>-sto_create_date = |{ sy-datum }| && |{ sy-uzeit }| .
      <st_sto_final>-sto_status = 'STO Created'(002).
    ELSE .
      <st_sto_final>-sto_status = 'Not Processed'(003).
    ENDIF.

*    READ TABLE i_pallet_item INTO DATA(lst_pallet_item)
*    WITH KEY pallet_no = <st_sto_final>-pallet_no
*             return_delv = <st_sto_final>-return_delv.
*    IF sy-subrc NE 0.
*      is_sto_final_temp-pallet_no = <st_sto_final>-pallet_no.
*      is_sto_final_temp-pallet_status = <st_sto_final>-pallet_status.
*      is_sto_final_temp-return_order  = <st_sto_final>-return_order.
*      is_sto_final_temp-sto_status    = 'Not Processed'(003).
*
*      APPEND is_sto_final_temp TO i_sto_final_temp.
*      CLEAR is_sto_final_temp.
*    ENDIF.
  ENDLOOP.
  IF i_pallet_item[] IS NOT INITIAL.
    LOOP AT i_pallet_item INTO DATA(lst_pal_item) WHERE return_delv IS INITIAL.
      is_sto_final_temp-pallet_no = lst_pal_item-pallet_no.

      is_sto_final_temp-return_order  = lst_pal_item-return_order.
      is_sto_final_temp-sto_status    = 'Not Processed'(003).

      READ TABLE i_pallet_header ASSIGNING <lst_pal_header>
               WITH KEY pallet_no = lst_pal_item-pallet_no.
      IF sy-subrc = 0 .
        is_sto_final_temp-pallet_status = <lst_pal_header>-status.
      ENDIF.

      APPEND is_sto_final_temp TO i_sto_final.


      CLEAR: i_sto_final_temp,lst_pal_item.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_STO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_sto_data .
  DATA : lst_layout TYPE  slis_layout_alv,
         lst_sort   TYPE slis_sortinfo_alv.
  CONSTANTS : lc_save TYPE char1 VALUE 'A'.

  IF i_sto_final IS NOT INITIAL.
    SORT i_sto_final BY pallet_no.
    lst_sort-spos = 1.                           " Sort order
    lst_sort-fieldname = 'PALLET_NO'.
    lst_sort-tabname = 'I_FINAL'.
    lst_sort-up = 'X'.
    lst_sort-subtot = 'X'.                      " Sub total allowed
    lst_sort-group = 'X'.
    APPEND lst_sort TO i_sort.
    CLEAR lst_sort.

    PERFORM f_fieldcat USING : 'PALLET_NO'           'Pallete ID',
                               'PALLET_STATUS'       'Pallete Status',
                               'RETURN_ORDER'         'Return Order',
                               'RETURN_DELV'          'Return Delivery',
                               'RETURN_DELV_LINEITEM'     'Ret.Del Item',
                               'ITEM_CAT'             'Item Category',
                               'MATERIAL'                'Material',
                               'ISBN'                 'ISBN',
                               'QTY'                  'Quantity',
                               'UOM'                  'UoM',
                               'STO'                  'STO',
                               'STO_CREATE_DATE'        'STO Creation Date',
                               'STO_STATUS'           'STO Processed Status',
                               'MESSAGE'              'Message'.


    lst_layout-colwidth_optimize = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = lst_layout
        it_fieldcat        = i_fieldcat
        it_sort            = i_sort
        i_save             = lc_save
      TABLES
        t_outtab           = i_sto_final
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0318   text
*      -->P_0319   text
*----------------------------------------------------------------------*
FORM f_fieldcat  USING    fp_fieldname TYPE slis_fieldname
                      fp_seltext   TYPE dd03p-scrtext_l.
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv.

  lst_fieldcatalog-fieldname = fp_fieldname.
  lst_fieldcatalog-seltext_l = fp_seltext.
  APPEND lst_fieldcatalog TO i_fieldcat.
  CLEAR lst_fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_pgi_data.

  SELECT *                                                      "Pallete Header Details
         FROM zpal_header
         INTO TABLE i_pallete_header
         WHERE pallet_no IN s_pallet.
  IF i_pallete_header IS NOT INITIAL.
    SORT i_pallete_header BY pallet_no.
    SELECT *                                                    "Pallete Item Details
           FROM zpal_item
           INTO TABLE i_pallete_item
           FOR ALL ENTRIES IN i_pallete_header
           WHERE pallet_no = i_pallete_header-pallet_no.
    IF i_pallete_item IS NOT INITIAL.
      SORT i_pallete_item BY pallet_no.
      SELECT vbeln                                              "Return Delivery Number
             posnr                                              "Return Delivery Line Item
             pstyv                                              "Item Category
             matnr                                              "Material
             ean11                                              "ISBN
             lfimg                                              "Quantity
             vrkme                                              "UoM
             FROM lips
             INTO TABLE i_ret_del
             FOR ALL ENTRIES IN i_pallete_item
             WHERE vbeln = i_pallete_item-return_delv.
      IF i_ret_del IS NOT INITIAL.
        SORT i_ret_del BY ret_del.
        SELECT vbeln                                            "Return Delivery Number
               wbstk                                            "Goods Movement Status
               FROM vbuk
               INTO TABLE i_ret_del_stat
               FOR ALL ENTRIES IN i_ret_del
               WHERE vbeln = i_ret_del-ret_del.
        IF i_ret_del_stat IS NOT INITIAL.
          SORT i_ret_del_stat BY vbeln.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT ebeln                                                "STO Number
           aedat                                                "STO Creation Date
           FROM ekko
           INTO TABLE i_sto
           FOR ALL ENTRIES IN i_pallete_header
           WHERE ebeln = i_pallete_header-sto.
    IF i_sto IS NOT INITIAL.
      SORT i_sto BY sto.
    ENDIF.
    SELECT vbeln                                                "Delivery Number
           posnr                                                "Delivery Line Item
           vgbel                                                "STO Number
           vgpos                                                "STO line item
           matnr                                                "Article Number
           lfimg                                                "Quantity
           vrkme                                                "Sales Unit
           ean11                                                "ISBN
           FROM lips
           INTO TABLE i_sto_del
           FOR ALL ENTRIES IN i_pallete_header
           WHERE vgbel = i_pallete_header-sto
             AND vgbel <> abap_false.
    IF i_sto_del IS NOT INITIAL.
      SORT i_sto_del BY sto.
      DATA(li_replen) = i_sto_del[].
      SORT li_replen BY sto_del.
      DELETE ADJACENT DUPLICATES FROM li_replen COMPARING sto_del.
      IF li_replen IS NOT INITIAL.
        SORT li_replen BY sto_del.
        SELECT vbeln                                            "Replen Delivery Number
               erdat                                            "Replen Delivery Creation Date
               FROM likp
               INTO TABLE i_replen_del
               FOR ALL ENTRIES IN li_replen
               WHERE vbeln = li_replen-sto_del.
        IF i_replen_del IS NOT INITIAL.
          SORT i_replen_del BY vbeln.
        ENDIF.
      ENDIF.
      SELECT vbeln                                              "Replen Delivery Number
             wbstk                                              "Goods Movement Status
             FROM vbuk
             INTO TABLE i_sto_del_stat
             FOR ALL ENTRIES IN i_sto_del
             WHERE vbeln = i_sto_del-sto_del.
      IF i_sto_del_stat IS NOT INITIAL.
        SORT i_sto_del_stat BY vbeln.
      ENDIF.
    ENDIF.
    LOOP AT i_pallet_id INTO st_pallet.
      IF NOT line_exists( i_pallete_header[ pallet_no = st_pallet-pallet_no ] ).
        st_log-pallete_id = st_pallet-pallet_no.
        APPEND st_log TO i_log.
        CLEAR st_log.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = c_domname
        text            = abap_true
      TABLES
        values_tab      = i_pgi_statdesc
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PGI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_pgi.
  IF i_pallete_header IS NOT INITIAL.
    SORT i_pallete_header BY sto DESCENDING.
    LOOP AT i_pallete_header ASSIGNING FIELD-SYMBOL(<lst_sto>).
      st_log-pallete_id = <lst_sto>-pallet_no.                             "Pallete No
      st_log-pallete_status = <lst_sto>-status.                             "Pallete Status

      IF <lst_sto>-sto IS NOT INITIAL.
        READ TABLE i_sto_del ASSIGNING FIELD-SYMBOL(<lst_sto_del_1>)
                              WITH KEY sto = <lst_sto>-sto
                              BINARY SEARCH.
        IF sy-subrc = 0.
          DATA(lv_tabix) = sy-tabix.
*        Create PGI only if Delivery is Open i.e. VBUK-WBSTK = A
          READ TABLE i_sto_del_stat ASSIGNING FIELD-SYMBOL(<lst_vbuk>)
                                     WITH KEY vbeln = <lst_sto_del_1>-sto_del
                                     BINARY SEARCH.
          IF sy-subrc = 0.
            IF <lst_vbuk>-wbstk = c_wbstk.
              LOOP AT i_sto_del ASSIGNING FIELD-SYMBOL(<lst_sto_del>) FROM lv_tabix.
                IF <lst_sto_del>-sto = <lst_sto>-sto.
                  st_vbpok-vbeln_vl  = <lst_sto_del>-sto_del.             "Delivery Num
                  st_vbpok-posnr_vl  = <lst_sto_del>-sto_del_itm.         "Delivery Line Item
                  st_vbpok-vbeln     = <lst_sto_del>-sto_del.             "Delivery Num
                  st_vbpok-posnn     = <lst_sto_del>-sto_del_itm.         "Delivery Line Item
                  st_vbpok-vbtyp_n   = v_e508_vbtyp_n.                    "Document Category = 'Q'
                  st_vbpok-matnr     = <lst_sto_del>-matnr.               "Material
                  st_vbpok-werks     = v_e508_werks_1.                    "Werks = 5512
                  st_vbpok-taqui     = abap_true.                         "TO Confirmed = X
                  st_vbpok-pikmg     = <lst_sto_del>-lfimg.               "Picked Qty
                  st_vbpok-lfimg     = <lst_sto_del>-lfimg.               "Actual Del Qty
                  st_vbpok-lgmng     = <lst_sto_del>-lfimg.               "Actual Del Qty
                  st_vbpok-vrkme     = <lst_sto_del>-vrkme.               "UoM
                  st_vbpok-lgort     = v_e508_lgort.                      "Storage Location = B001
                  APPEND st_vbpok TO i_vbpok.
                  CLEAR st_vbpok.
                ELSE.
                  EXIT.
                ENDIF.
              ENDLOOP.

*         Call BAPI to Create PGI
              st_vbkok-vbeln_vl = <lst_sto_del_1>-sto_del.                  "Delivery No
              st_vbkok-vbeln = <lst_sto_del_1>-sto_del.                     "Delievry No
              st_vbkok-wabuc = abap_true.                                 "Auto PGI = X
              CALL FUNCTION 'WS_DELIVERY_UPDATE'
                EXPORTING
                  vbkok_wa       = st_vbkok
                  commit         = abap_true
                  delivery       = <lst_sto_del_1>-sto_del
                  update_picking = abap_true
                TABLES
                  vbpok_tab      = i_vbpok.

              WAIT UP TO 1 SECONDS.

              st_log-pallete_id = <lst_sto>-pallet_no.                               "Pallete No
              st_log-pallete_status = <lst_sto>-status.                               "Pallete Status
              st_log-sto = <lst_sto>-sto.                                             "STO
              READ TABLE i_sto ASSIGNING FIELD-SYMBOL(<lst_sto_date>)
                                WITH KEY sto = <lst_sto>-sto
                                BINARY SEARCH.
              IF sy-subrc = 0.
                st_log-sto_cred_date = <lst_sto_date>-aedat.                          "STO Creation Date
              ENDIF.
              st_log-replen_del = <lst_sto_del_1>-sto_del.                              "Replen Delivery
              READ TABLE i_replen_del ASSIGNING FIELD-SYMBOL(<lst_replen_del>)
                                       WITH KEY vbeln = <lst_sto_del_1>-sto_del
                                       BINARY SEARCH.
              IF sy-subrc = 0.
                st_log-replen_del_date = <lst_replen_del>-erdat.                      "Replen Delv Creation Date
              ENDIF.

              APPEND st_log TO i_log_head.
              CLEAR st_log.
            ELSE.
              st_log-sto = <lst_sto_del_1>-sto.
              READ TABLE i_sto ASSIGNING FIELD-SYMBOL(<lst_sto_date_1>)
                                WITH KEY sto = <lst_sto>-sto
                                BINARY SEARCH.
              IF sy-subrc = 0.
                st_log-sto_cred_date = <lst_sto_date_1>-aedat.                          "STO Creation Date
              ENDIF.
              st_log-replen_del = <lst_sto_del_1>-sto_del.

              READ TABLE i_replen_del ASSIGNING FIELD-SYMBOL(<lst_replen_del_1>)
                                       WITH KEY vbeln = <lst_sto_del_1>-sto_del
                                       BINARY SEARCH.
              IF sy-subrc = 0.
                st_log-replen_del_date = <lst_replen_del_1>-erdat.                      "Replen Delv Creation Date
              ENDIF.

*            st_log-pgi_stat = <lst_vbuk>-wbstk.
              st_log-message = 'Delivery is not relevant for PGI'(004).

              APPEND st_log TO i_log_head.
              CLEAR st_log.
            ENDIF.                                                                    "IF....ENDIF <lst_vbuk>-wbstk = c_wbstk
          ENDIF.  "IF....ENDIF i_Sto_del_status
        ELSE.
          st_log-sto = <lst_sto>-sto.
          READ TABLE i_sto ASSIGNING FIELD-SYMBOL(<lst_sto_date_2>)
                              WITH KEY sto = <lst_sto>-sto
                              BINARY SEARCH.
          IF sy-subrc = 0.
            st_log-sto_cred_date = <lst_sto_date_2>-aedat.                          "STO Creation Date
          ENDIF.
          st_log-message = 'Replenishment Delv. Not created'(006).
          APPEND st_log TO i_log_head.
          CLEAR st_log.
        ENDIF.                                                                        "IF....ENDIF i_sto_del
      ELSE.
        st_log-message = 'STO Not created'(008).
        APPEND st_log TO i_log_head.
        CLEAR st_log.
      ENDIF.
      CLEAR : st_log,
              st_vbkok,
              st_vbpok, i_vbpok[].

    ENDLOOP.

    PERFORM f_upd_item.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upd_item.

  IF i_log_head[] IS NOT INITIAL.

    SELECT vbfa~vbelv,
           vbfa~vbeln,
           vbfa~erdat,
           vbfa~erzet,
           vbuk~wbstk
           FROM vbfa
           LEFT OUTER JOIN vbuk
           ON vbfa~vbelv = vbuk~vbeln
           INTO TABLE @DATA(li_pgi)
           FOR ALL ENTRIES IN @i_log_head
           WHERE vbelv = @i_log_head-replen_del
             AND vbelv <> @abap_false
             AND vbtyp_v = @v_e508_vbtyp_v
             AND vbtyp_n = @v_e508_vbtyp_pgi.
    IF sy-subrc = 0.
      SORT li_pgi BY vbelv erdat erzet DESCENDING.
      DELETE ADJACENT DUPLICATES FROM li_pgi COMPARING vbelv.
      SORT li_pgi BY vbelv.
    ENDIF.
  ENDIF.

  LOOP AT i_log_head ASSIGNING FIELD-SYMBOL(<lst_head>).
    READ TABLE li_pgi ASSIGNING FIELD-SYMBOL(<lst_pgi>)
          WITH KEY vbelv = <lst_head>-replen_del BINARY SEARCH.
    IF sy-subrc = 0.

      READ TABLE i_pgi_statdesc ASSIGNING FIELD-SYMBOL(<lst_pgi_statdesc>)
                   WITH KEY domvalue_l = <lst_pgi>-wbstk.
      IF sy-subrc = 0.
        CONCATENATE <lst_pgi>-wbstk '-(' <lst_pgi_statdesc>-ddtext ')'
        INTO  <lst_head>-pgi_stat.
      ENDIF.
      <lst_head>-message = 'PGI done Successfully'(001).
    ENDIF.
    MOVE <lst_head> TO st_log.
    READ TABLE i_pallete_item ASSIGNING FIELD-SYMBOL(<lst_itm>)
                                       WITH KEY pallet_no = <lst_head>-pallete_id
                                       BINARY SEARCH.
    IF sy-subrc = 0.
      DATA(lv_item) = sy-tabix.


      LOOP AT i_pallete_item ASSIGNING FIELD-SYMBOL(<lst_itm_1>) FROM lv_item.
        IF <lst_itm_1>-pallet_no = <lst_head>-pallete_id.
*          st_log-ret_ord = <lst_itm_1>-return_order.

          READ TABLE i_ret_del ASSIGNING FIELD-SYMBOL(<lst_ret_del_1>)
                                WITH KEY ret_del = <lst_itm_1>-return_delv
                                BINARY SEARCH.
          IF sy-subrc = 0.
            DATA(lv_index) = sy-tabix.
            LOOP AT i_ret_del ASSIGNING FIELD-SYMBOL(<lst_ret_del>) FROM lv_index.
              IF <lst_ret_del>-ret_del = <lst_itm_1>-return_delv.
                MOVE <lst_head> TO st_log.
                READ TABLE i_ret_del_stat ASSIGNING FIELD-SYMBOL(<lst_ret_del_stat>)
                       WITH KEY vbeln = <lst_ret_del>-ret_del
                       BINARY SEARCH.
                IF sy-subrc = 0.
                  READ TABLE i_pgi_statdesc ASSIGNING FIELD-SYMBOL(<lst_pgi_statdesc_1>)
                  WITH KEY domvalue_l = <lst_ret_del_stat>-wbstk.
                  IF sy-subrc = 0.
                    CONCATENATE <lst_ret_del_stat>-wbstk '-(' <lst_pgi_statdesc_1>-ddtext ')'
                    INTO  st_log-ret_del_pgi_stat.
                  ENDIF.
                ENDIF.

                st_log-ret_ord = <lst_itm_1>-return_order.
                st_log-ret_del = <lst_ret_del>-ret_del.
                st_log-ret_del_lin_item = <lst_ret_del>-ret_del_itm.                      "Return Delv Line Item
                st_log-item_cat = <lst_ret_del>-item_cat.                                 "Item category
                st_log-matnr = <lst_ret_del>-matnr.                                       "Material
                st_log-isbn = <lst_ret_del>-ean11.                                        "ISBN
                st_log-quantity = <lst_ret_del>-lfimg.                                    "Delv Quantity
                st_log-uom = <lst_ret_del>-vrkme.                                         "UoM
                APPEND st_log TO i_log.
*                CLEAR st_log.
              ELSE.
                EXIT.
              ENDIF.

            ENDLOOP.
          ELSE.
            MOVE <lst_head> TO st_log.
            st_log-ret_ord = <lst_itm_1>-return_order.
            APPEND st_log TO i_log.
            CLEAR st_log.
          ENDIF.
        ELSE.
          EXIT.
        ENDIF.
        CLEAR st_log.
      ENDLOOP.
    ELSE.
      APPEND st_log TO i_log.
      CLEAR st_log.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_pgi_data.
  DATA : lst_layout TYPE  slis_layout_alv.
  CONSTANTS : lc_save TYPE char1 VALUE 'A'.
  DATA:lst_sort         TYPE slis_sortinfo_alv.

  IF i_log IS NOT INITIAL.

    PERFORM f_fieldcat USING : 'PALLETE_ID'           'Pallete ID',
                               'PALLETE_STATUS'       'Pallete Status',
                               'RET_ORD'              'Return Order',
                               'RET_DEL'              'Return Delivery',
                               'RET_DEL_PGI_STAT'     'Return Delivery PGR Status',
                               'RET_DEL_LIN_ITEM'     'Return Delivery line item no',
                               'ITEM_CAT'             'Item Category',
                               'MATNR'                'Material',
                               'ISBN'                 'ISBN',
                               'QUANTITY'             'Quantity',
                               'UOM'                  'UoM',
                               'STO'                  'STO',
                               'STO_CRED_DATE'        'STO Creation Date',
                               'REPLEN_DEL'           'Replenishment Delivery',
                               'REPLEN_DEL_DATE'      'Replen. Delivery Creation Date',
                               'PGI_STAT'             'Replen Delivery PGI Status',
                               'MESSAGE'              'Message'.

    " Determine Sort Sequence
    lst_sort-spos = 1.                           " Sort order
    lst_sort-fieldname = 'PALLETE_ID'.
    lst_sort-tabname = 'I_LOG'.
    lst_sort-up = 'X'.
    lst_sort-subtot = 'X'.                      " Sub total allowed
    lst_sort-group = 'X'.
    APPEND lst_sort TO i_sort.
    CLEAR lst_sort.

    lst_layout-colwidth_optimize = abap_true.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = lst_layout
        it_fieldcat        = i_fieldcat
        it_sort            = i_sort
        i_save             = lc_save
      TABLES
        t_outtab           = i_log
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .

  IF i_const[] IS INITIAL.
    SELECT devid                      "Development ID
           param1                     "ABAP: Name of Variant Variable
           param2                     "ABAP: Name of Variant Variable
           srno                       "Current selection number
           sign                       "ABAP: ID: I/E (include/exclude values)
           opti                       "ABAP: Selection option (EQ/BT/CP/...)
           low                        "Lower Value of Selection Condition
           high                       "Upper Value of Selection Condition
           activate                   "Activation indicator for constant
           FROM zcaconstant           " Wiley Application Constant Table
           INTO TABLE i_const
           WHERE devid    = c_devid
           AND   activate = abap_true. "Only active record
    IF sy-subrc EQ 0.
      SORT i_const BY devid param1.
    ENDIF.

*Storage Location
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_lgort>)
         WITH KEY devid = c_devid param1 = c_lgort_1 BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_lgort = <lst_e208_lgort>-low.
    ENDIF.

*Document Category
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_vbtyp_n>)
         WITH KEY devid = c_devid param1 = c_vbtyp_n BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_vbtyp_n = <lst_e208_vbtyp_n>-low.
    ENDIF.

*Document Category
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_vbtyp_pgi>)
         WITH KEY devid = c_devid param1 = c_vbtyp_pgi BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_vbtyp_pgi = <lst_e208_vbtyp_pgi>-low.
    ENDIF.

*Document Category
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_vbtyp_v>)
         WITH KEY devid = c_devid param1 = c_vbtyp_v BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_vbtyp_v = <lst_e208_vbtyp_v>-low.
    ENDIF.

*Plant
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_werks_1>)
         WITH KEY devid = c_devid param1 = c_werks_1 BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_werks_1 = <lst_e208_werks_1>-low.
    ENDIF.

*Document Type
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_bsart>)
         WITH KEY devid = c_devid param1 = c_bsart BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_bsart = <lst_e208_bsart>-low.
    ENDIF.


*Company Code
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_bukrs>)
         WITH KEY devid = c_devid param1 = c_bukrs BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_bukrs = <lst_e208_bukrs>-low.
    ENDIF.


*Purchasing Group
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_ekgrp>)
         WITH KEY devid = c_devid param1 = c_ekgrp BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_ekgrp = <lst_e208_ekgrp>-low.
    ENDIF.


*Purchasing Org.
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_ekorg>)
         WITH KEY devid = c_devid param1 = c_ekorg BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_ekorg = <lst_e208_ekorg>-low.
    ENDIF.


*Plant 2
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_werks_2>)
         WITH KEY devid = c_devid param1 = c_werks_2 BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_werks_2 = <lst_e208_werks_2>-low.
    ENDIF.

*Ship. Point
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_vstel>)
         WITH KEY devid = c_devid param1 = c_vstel BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_vstel = <lst_e208_vstel>-low.
    ENDIF.

*Item Catg
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e208_pstyv>)
         WITH KEY devid = c_devid param1 = c_pstyv BINARY SEARCH.
    IF sy-subrc = 0.
      v_e508_pstyv = <lst_e208_pstyv>-low.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_AUTH_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_auth_check .
  IF rad1 = abap_true.

    AUTHORITY-CHECK OBJECT 'M_BEST_WRK'
             ID 'ACTVT' FIELD '01'
             ID 'ACTVT' FIELD '02'
             ID 'ACTVT' FIELD '03'
             ID 'WERKS' FIELD v_e508_werks_1.
    IF sy-subrc <> 0.
      CONCATENATE 'You are not authorized for STO creation related to Plant:'(010)
                  v_e508_werks_1 INTO DATA(lv_auth_text).
      MESSAGE lv_auth_text TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ELSEIF rad3 = abap_true.
    AUTHORITY-CHECK OBJECT 'V_LIKP_VST'
              ID 'ACTVT' FIELD '01'
              ID 'ACTVT' FIELD '02'
              ID 'ACTVT' FIELD '03'
              ID 'VSTEL' FIELD v_e508_vstel.
    IF sy-subrc <> 0.
      CONCATENATE 'You are not authorized for PGI creation related to Ship. Pt:'(011)
                 v_e508_vstel INTO DATA(lv_auth_text_1).
      MESSAGE lv_auth_text_1 TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.
