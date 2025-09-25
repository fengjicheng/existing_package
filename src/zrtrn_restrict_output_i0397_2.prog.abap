*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTRICT_OUTPUT_I0397_2
*&---------------------------------------------------------------------*

   TYPES: BEGIN OF ty_id_type,
            sign   TYPE ddsign,
            option TYPE ddoption,
            low    TYPE bu_id_type,
            high   TYPE bu_id_type,
          END OF ty_id_type.

   DATA:lir_id_type TYPE STANDARD TABLE OF ty_id_type.

   CONSTANTS: lc_type TYPE rvari_vnam VALUE 'BU_ID_TYPE'. " Identification Type

   LOOP AT li_const_397_2 INTO lst_const_397_2 WHERE param1 = lc_type.
     APPEND VALUE #( sign   = lst_const_397_2-sign
                     option = lst_const_397_2-opti
                     low    = lst_const_397_2-low ) TO lir_id_type.
   ENDLOOP.
   IF lir_id_type IS NOT INITIAL.
     SELECT idnumber INTO @DATA(lv_idnumber) " Identification Number
       FROM but0id UP TO 1 ROWS" BP: ID Numbers
       WHERE partner = @komkbv3-kunre "Business Partner Number
       AND type IN @lir_id_type."Identification Type
*       AND valid_date_from LE @sy-datum
*       AND valid_date_to GE @sy-datum.
     ENDSELECT.
     IF sy-subrc IS NOT INITIAL.
       lv_flag = abap_true. " Identification not maintained DO not add ZFR output
     ENDIF.
   ENDIF.
