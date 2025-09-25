*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_SD_VIEWP01
* PROGRAM DESCRIPTION:Include for local class implementation
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
**************************************************************
* LOCAL CLASS implementation for data changed in fieldcatalog ALV
**************************************************************
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD meth_handle_data_changed.
    DATA lr_good TYPE REF TO  lvc_s_modi.
    lv_error_in_data = space.
    LOOP AT er_data_changed->mt_good_cells REFERENCE INTO lr_good.
      CASE lr_good->fieldname.
        WHEN c_price.
          CALL METHOD meth_check_price
            EXPORTING
              im_good_kbetr      = lr_good->*
              im_pr_data_changed = er_data_changed.
        WHEN c_promo_n.
          CALL METHOD meth_check_promo
            EXPORTING
              im_good_promo      = lr_good->*
              im_pr_data_changed = er_data_changed.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
*§7.Display application log if an error has occured.
    IF lv_error_in_data EQ abap_true.
      CALL METHOD er_data_changed->display_protocol.
    ENDIF.
  ENDMETHOD.
  METHOD meth_check_price.
    DATA: lv_kbetr   TYPE  p DECIMALS 2,
          lv_kschl   TYPE konv-kschl,
          lv_kschl_x TYPE char30,
          lv_krech   TYPE t685a-krech.
*& Constants
    CONSTANTS lc_v TYPE kappl VALUE 'V'.

    CALL METHOD im_pr_data_changed->get_cell_value
      EXPORTING
        i_row_id    = im_good_kbetr-row_id  " Row ID
*       i_tabix     =     " Table Index
        i_fieldname = im_good_kbetr-fieldname   " Field Name
      IMPORTING
        e_value     = lv_kbetr.    " Cell Content
    IF lv_kbetr LT 0.
      CALL METHOD im_pr_data_changed->add_protocol_entry
        EXPORTING
          i_msgid     = '0K'
          i_msgno     = '000'
          i_msgty     = c_error
          i_msgv1     = text-m01           "Flugzeugtyp
          i_msgv2     = lv_kbetr
          i_fieldname = im_good_kbetr-fieldname
          i_row_id    = im_good_kbetr-row_id.

      lv_error_in_data = abap_true.
      RETURN.

    ENDIF.
    CALL METHOD im_pr_data_changed->get_cell_value
      EXPORTING
        i_row_id    = im_good_kbetr-row_id  " Row ID
*       i_tabix     =     " Table Index
        i_fieldname = c_kschl  "'KSCHL'  " Field Name
      IMPORTING
        e_value     = lv_kschl_x.    " Cell Content
    lv_kschl = lv_kschl_x+0(4).
    SELECT SINGLE krech FROM t685a
      INTO lv_krech
      WHERE
      kappl = lc_v
      AND kschl = lv_kschl.
*& If it's Percentage and more than 100 then throw error message
    IF ( lv_krech EQ c_a OR
        lv_krech EQ c_h OR
        lv_krech EQ c_i ) AND ( lv_kbetr GT 100
).
      CALL METHOD im_pr_data_changed->add_protocol_entry
        EXPORTING
          i_msgid     = 'ZQTC_R2'
          i_msgno     = '054'
          i_msgty     = c_error
*         i_msgv1     = text-m01           "Flugzeugtyp
          i_msgv1     = lv_kbetr
*         i_msgv3     = text-m05           "exitstiert nicht
          i_fieldname = im_good_kbetr-fieldname
          i_row_id    = im_good_kbetr-row_id.

      lv_error_in_data = abap_true.
      RETURN.

    ENDIF.
  ENDMETHOD.
  METHOD meth_check_promo.
    TYPES: BEGIN OF lty_vbak,
             vbeln TYPE vbak-vbeln,
             vkorg TYPE   vkorg,
             vtweg TYPE  vtweg,
             spart TYPE   spart,
             vkgrp TYPE   vkgrp,
           END OF lty_vbak,
*         Range Table declaration:
           BEGIN OF lty_promo_type,
             sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
             option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
             low    TYPE boart,      " Agreement type
             high   TYPE boart,      " Agreement type
           END OF lty_promo_type,
           BEGIN OF lty_constant,
             devid  TYPE zdevid,              " Development ID
             param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
             param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
             sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
             opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
             low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
             high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
           END OF lty_constant.
    DATA:
      lst_promo_type TYPE lty_promo_type,
      lr_promo_type  TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
      lst_constant   TYPE lty_constant,
      li_constant    TYPE STANDARD TABLE OF lty_constant   INITIAL SIZE 0,  "
      lst_vbak       TYPE lty_vbak,
      lv_knuma       TYPE knuma, " Agreement (various conditions grouped together)
      lv_vbeln       TYPE vbak-vbeln,
      lv_vkorg       TYPE vkorg, " Sales Organization
      lv_vtweg       TYPE vtweg, " Distribution Channel
      lv_spart       TYPE spart. " Division
    CONSTANTS: lc_b        TYPE char1 VALUE 'B',
               lc_devid    TYPE zdevid        VALUE 'E074',    " Type of Identification Code
               lc_in       TYPE char1         VALUE 'I',       " Inclusive value
               lc_eql      TYPE char2         VALUE 'EQ',      " Equal
               lc_promocde TYPE rvari_vnam    VALUE 'ZZPROMO'. " Promotion code for variant variable
* Fetch Identification Code Type from constant table.
    SELECT devid       " Development ID
           param1      " ABAP: Name of Variant Variable
           param2      " ABAP: Name of Variant Variable
           sign        " ABAP: ID: I/E (include/exclude values)
           opti        " ABAP: Selection option (EQ/BT/CP/...)
           low         " Lower Value of Selection Condition
           high        " Upper Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO TABLE li_constant
      WHERE devid    = lc_devid
        AND param1   = lc_promocde
        AND activate = abap_true.
    IF sy-subrc = 0.

*   Put the promo code values in the range table.
      lst_promo_type-sign   = lc_in. " Sign (I)
      lst_promo_type-option = lc_eql. " Option (EQ)
      LOOP AT li_constant INTO lst_constant.
        lst_promo_type-low = lst_constant-low. " Z001/Z002/Z005
        APPEND lst_promo_type TO lr_promo_type.
      ENDLOOP.
      CLEAR lst_promo_type.

      CALL METHOD im_pr_data_changed->get_cell_value
        EXPORTING
          i_row_id    = im_good_promo-row_id  " Row ID
*         i_tabix     =     " Table Index
          i_fieldname = im_good_promo-fieldname   " Field Name
        IMPORTING
          e_value     = lv_knuma.    " Cell Content
      CALL METHOD im_pr_data_changed->get_cell_value
        EXPORTING
          i_row_id    = im_good_promo-row_id  " Row ID
*         i_tabix     =     " Table Index
          i_fieldname = 'VBELN'  "'KSCHL'  " Field Name
        IMPORTING
          e_value     = lv_vbeln.    " Cell Content
      IF NOT lv_vbeln IS INITIAL.
        SELECT SINGLE  vbeln
                     vkorg
                     vtweg
                     spart
                     vkgrp
          FROM   vbak
          INTO lst_vbak
          WHERE
          vbeln = lv_vbeln.
      ENDIF.
      IF NOT lv_knuma IS INITIAL.

*   Validate from Agreements Table
        SELECT SINGLE knuma " Agreement (various conditions grouped together)
                      vkorg " Sales Organization
                      vtweg " Distribution Channel
                      spart " Division
          FROM kona " Agreements
          INTO ( lv_knuma, lv_vkorg, lv_vtweg, lv_spart )
         WHERE knuma = lv_knuma
           AND abtyp = lc_b.
        IF sy-subrc = 0.
          IF ( lv_vkorg IS NOT INITIAL AND lv_vkorg NE lst_vbak-vkorg ) OR
             ( lv_vtweg IS NOT INITIAL AND lv_vtweg NE lst_vbak-vtweg ) OR
             ( lv_spart IS NOT INITIAL AND lv_spart NE lst_vbak-spart ).
            CALL METHOD im_pr_data_changed->add_protocol_entry
              EXPORTING
                i_msgid     = 'ZQTC_R2'
                i_msgno     = 016
                i_msgty     = c_error
                i_msgv2     = lv_knuma
                i_fieldname = im_good_promo-fieldname
                i_row_id    = im_good_promo-row_id.

            lv_error_in_data = abap_true.
            RETURN.
*          MESSAGE e016(zqtc_r2). " Enter a valid Promo Code
          ENDIF.
        ELSE.
          CALL METHOD im_pr_data_changed->add_protocol_entry
            EXPORTING
              i_msgid     = 'ZQTC_R2'
              i_msgno     = 016
              i_msgty     = c_error
              i_msgv2     = lv_knuma
              i_fieldname = im_good_promo-fieldname
              i_row_id    = im_good_promo-row_id.

          lv_error_in_data = abap_true.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
