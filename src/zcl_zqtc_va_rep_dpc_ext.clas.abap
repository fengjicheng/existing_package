class ZCL_ZQTC_VA_REP_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_VA_REP_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods VA05SET_GET_ENTITYSET
    redefinition .
  methods VA25SET_GET_ENTITYSET
    redefinition .
  methods VA45SET_GET_ENTITYSET
    redefinition .
  methods VA45_ALLITEMSSET_GET_ENTITYSET
    redefinition .
  methods VA45_REJECTITEMS_GET_ENTITYSET
    redefinition .
  methods VA45_SUMSET_GET_ENTITYSET
    redefinition .
  methods ZFIELDSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_VA_REP_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA: lst_bapisdh1x TYPE bapisdh1x.
    DATA: lst_bapisdh1 TYPE bapisdh1,
          lv_vbeln     TYPE vbeln.
    DATA:lt_return TYPE TABLE OF bapiret2.
    DATA:lt_return2 TYPE TABLE OF bapiret2.
    DATA:lt_so TYPE edm_vbeln_range_tt.
    DATA:lst_so TYPE edm_vbeln_range.

    DATA: lt_item   TYPE TABLE OF   bapisditm,
          lt_itemx  TYPE TABLE OF  bapisditmx,
          lst_itemx TYPE   bapisditmx,
          lst_item  TYPE   bapisditm.
    DATA : BEGIN OF  li_orders.
             INCLUDE TYPE zcl_zqtc_va_rep_mpc=>ts_delvhead.
             DATA: np_vbeln TYPE zcl_zqtc_va_rep_mpc=>tt_delvitem,
           END OF li_orders.


    DATA:        lv_cnt     TYPE i.
    DATA : lst_orders    LIKE  li_orders,
           lst_orders2   LIKE  li_orders,
           lv_lifsk      TYPE lifsk,
           lv_entity_set TYPE /iwbep/mgw_tech_name.

    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).

* Import Input
    io_data_provider->read_entry_data( IMPORTING es_data  = lst_orders ).


    CASE lv_entity_set.
      WHEN 'DelvHeadSet'.
        DATA(lv_actvt) = lst_orders-actvt.

        LOOP AT  lst_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<lst_input>).

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_input>-vbeln
            IMPORTING
              output = lv_vbeln.
          CLEAR:lst_so.
          lst_so-low = lv_vbeln.
          lst_so-sign = 'I'.
          lst_so-option = 'EQ'.

          APPEND lst_so TO lt_so.
          CLEAR lv_vbeln.
        ENDLOOP.

        IF lt_so[] IS NOT INITIAL.
          SELECT vbeln,posnr FROM vbap INTO TABLE @DATA(lt_vbap)
            WHERE vbeln IN @lt_so
              AND abgru NE @space.
        ENDIF.
        LOOP AT lt_vbap INTO DATA(lst_vbap).
*          BAPI Header
          IF lv_actvt EQ 'U'.         "Unblock Reason for Rejection
            lst_bapisdh1-dlv_block = abap_false.
          ELSEIF lv_actvt EQ 'B'.     " Block Reason for rejection
            lst_bapisdh1-dlv_block = '12'.
          ENDIF.
*          lst_bapisdh1x-dlv_block = abap_true.
          lst_bapisdh1x-updateflag = 'U'.

          CLEAR:lst_item,lst_itemx,lv_vbeln.
          FREE:lt_item[],lt_itemx[].



          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-vbeln
            IMPORTING
              output = lv_vbeln.

          lst_item-itm_number = lst_vbap-posnr.
          lst_itemx-itm_number = lst_vbap-posnr.
          IF lv_actvt EQ 'U'.                  " UnBlock Reason for rejection
            lst_item-reason_rej = ''.
          ELSEIF lv_actvt EQ 'B'.             " Block Reason for rejection
            lst_item-reason_rej = '12'.
          ENDIF.
          lst_itemx-reason_rej = abap_true.
          lst_itemx-updateflag = 'U'.

          APPEND lst_item TO lt_item.
          APPEND lst_itemx TO lt_itemx.

          AT END OF vbeln.
            FREE:lt_return[].
            CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
              EXPORTING
                salesdocument    = lv_vbeln
                order_header_in  = lst_bapisdh1
                order_header_inx = lst_bapisdh1x
              TABLES
                order_item_in    = lt_item
                order_item_inx   = lt_itemx
                return           = lt_return.

            CLEAR:lv_cnt.
            LOOP AT lt_return INTO DATA(lst_return) WHERE type = 'E' OR type = 'A'.
              lv_cnt = lv_cnt + 1.
              CASE lv_cnt.
                WHEN 1.
                  <lst_input>-msgty = 'Error'.
                  <lst_input>-msgv1 = lst_return-message.
                  lst_orders-message = <lst_input>-msgv1.
                WHEN 2.
                  <lst_input>-msgv2 = lst_return-message_v1.
                WHEN 3.
                  <lst_input>-msgv3 = lst_return-message_v2.
                WHEN 4.
                  <lst_input>-msgv4 = lst_return-message_v3.
                WHEN OTHERS.
              ENDCASE.
            ENDLOOP.


            IF <lst_input>-msgty IS INITIAL.

              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
*             IMPORTING
*               RETURN        =            .

              <lst_input>-msgty = 'Success'.
              <lst_input>-msgv1 = 'Delivery block released Successfully;'.


              SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_in)
                WHERE vbeln = @lv_vbeln.
              IF sy-subrc EQ 0.
                <lst_input>-msgv2 = 'Order is Incomplete' .

              ENDIF.

              SELECT SINGLE faksk FROM vbak INTO @DATA(lv_faksk)
                WHERE vbeln = @lv_vbeln.
              IF sy-subrc EQ 0 AND lv_faksk IS NOT INITIAL.
                <lst_input>-msgv3 = 'Order has Billing Block' .
              ENDIF.

            ENDIF.
*          IF lt_return IS NOT INITIAL.
*            me->mo_context->get_message_container( )->add_messages_from_bapi(
*                       EXPORTING it_bapi_messages = lt_return ).
*
*            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*              EXPORTING
*                message_container = me->mo_context->get_message_container( ).
*
*          ENDIF.
          ENDAT.
*        append <lst_input> to lst_orders-np_vbeln.
*        append <lst_input> to lst_orders2-np_vbeln.
*        append <lst_input> to lst_orders2-np_vbeln.
        ENDLOOP.
*lst_orders-np_vbeln = lst_orders2-np_vbeln.
        copy_data_to_ref(
          EXPORTING
              is_data = lst_orders
          CHANGING
              cr_data = er_deep_entity ).


      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD va05set_get_entityset.


    DATA: textlines TYPE TABLE OF string.
    DATA:lv_auart(4) TYPE c,
         lr_auart    TYPE tms_t_auart_range,
         lr_auart2   TYPE tms_t_auart_range,
         lst_auart   TYPE tms_s_auart_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Auart'.
            lv_auart = <ls_filter_opt>-low+0(4).
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = 'I'.
              lst_auart-option = 'EQ'.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart2.
              CLEAR:lst_auart.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    TYPES: BEGIN OF ty_header,
             col1   TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
             col5   TYPE string,
             col6   TYPE string,
             col7   TYPE string,
             col8   TYPE string,
             col9   TYPE string,
             col10  TYPE string,
             col11  TYPE string,
             col12  TYPE string,
             col13  TYPE string,
             col14  TYPE string,
             col15  TYPE string,
             col16  TYPE string,
             col17  TYPE string,
             col18  TYPE string,
             col19  TYPE string,
             col20  TYPE string,
             col21  TYPE string,
             col22  TYPE string,
             col23  TYPE string,
             col24  TYPE string,
             col25  TYPE string,
             col26  TYPE string,
             col27  TYPE string,
             col28  TYPE string,
             col29  TYPE string,
             col30  TYPE string,
             col31  TYPE string,
             col32  TYPE string,
             col33  TYPE string,
             col34  TYPE string,
             col35  TYPE string,
             col36  TYPE string,
             col37  TYPE string,
             col38  TYPE string,
             col39  TYPE string,
             col40  TYPE string,
             col41  TYPE string,
             col42  TYPE string,
             col43  TYPE string,
             col44  TYPE string,
             col45  TYPE string,
             col46  TYPE string,
             col47  TYPE string,
             col48  TYPE string,
             col49  TYPE string,
             col50  TYPE string,
             col51  TYPE string,
             col52  TYPE string,
             col53  TYPE string,
             col54  TYPE string,
             col55  TYPE string,
             col56  TYPE string,
             col57  TYPE string,
             col58  TYPE string,
             col59  TYPE string,
             col60  TYPE string,
             col61  TYPE string,
             col62  TYPE string,
             col63  TYPE string,
             col64  TYPE string,
             col65  TYPE string,
             col66  TYPE string,
             col67  TYPE string,
             col68  TYPE string,
             col69  TYPE string,
             col70  TYPE string,
             col71  TYPE string,
             col72  TYPE string,
             col73  TYPE string,
             col74  TYPE string,
             col75  TYPE string,
             col76  TYPE string,
             col77  TYPE string,
             col78  TYPE string,
             col79  TYPE string,
             col80  TYPE string,
             col81  TYPE string,
             col82  TYPE string,
             col83  TYPE string,
             col84  TYPE string,
             col85  TYPE string,
             col86  TYPE string,
             col87  TYPE string,
             col88  TYPE string,
             col89  TYPE string,
             col90  TYPE string,
             col91  TYPE string,
             col92  TYPE string,
             col93  TYPE string,
             col94  TYPE string,
             col95  TYPE string,
             col96  TYPE string,
             col97  TYPE string,
             col98  TYPE string,
             col99  TYPE string,
             col100 TYPE string,
             col101 TYPE string,
             col102 TYPE string,
             col103 TYPE string,
             col104 TYPE string,
             col105 TYPE string,
             col106 TYPE string,
             col107 TYPE string,
             col108 TYPE string,
             col109 TYPE string,
             col110 TYPE string,
             col111 TYPE string,
             col112 TYPE string,
             col113 TYPE string,
             col114 TYPE string,
             col115 TYPE string,
             col116 TYPE string,
             col117 TYPE string,
             col118 TYPE string,
             col119 TYPE string,
             col120 TYPE string,
             col121 TYPE string,
             col122 TYPE string,
             col123 TYPE string,
             col124 TYPE string,
             col125 TYPE string,
             col126 TYPE string,
             col127 TYPE string,
             col128 TYPE string,
             col129 TYPE string,
             col130 TYPE string,
             col131 TYPE string,
             col132 TYPE string,
             col133 TYPE string,
             col134 TYPE string,
             col135 TYPE string,
             col136 TYPE string,
             col137 TYPE string,
             col138 TYPE string,
             col139 TYPE string,
             col140 TYPE string,
             col141 TYPE string,
             col142 TYPE string,
             col143 TYPE string,
             col144 TYPE string,
             col145 TYPE string,
             col146 TYPE string,
             col147 TYPE string,
             col148 TYPE string,
             col149 TYPE string,
             col150 TYPE string,
             col151 TYPE string,
             col152 TYPE string,
             col153 TYPE string,
             col154 TYPE string,
             col155 TYPE string,
             col156 TYPE string,
             col157 TYPE string,
             col158 TYPE string,
             col159 TYPE string,
             col160 TYPE string,
             col161 TYPE string,
             col162 TYPE string,
             col163 TYPE string,
             col164 TYPE string,
             col165 TYPE string,
             col166 TYPE string,
             col167 TYPE string,
             col168 TYPE string,
             col169 TYPE string,
             col170 TYPE string,
             col171 TYPE string,
             col172 TYPE string,
             col173 TYPE string,
             col174 TYPE string,
             col175 TYPE string,
             col176 TYPE string,
             col177 TYPE string,
             col178 TYPE string,
             col179 TYPE string,
             col180 TYPE string,
             col181 TYPE string,
             col182 TYPE string,
             col183 TYPE string,
             col184 TYPE string,
             col185 TYPE string,
             col186 TYPE string,
             col187 TYPE string,
             col188 TYPE string,
             col189 TYPE string,
           END OF ty_header.

    DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
          lw_data      TYPE ty_header,

          lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,

          lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va05.
    DATA:lv_low TYPE sy-datum.

    DATA lv_uname TYPE sy-uname.

    lv_uname = sy-uname.

    CHECK lr_auart2[] IS NOT INITIAL.
    DATA:lr_vkorg TYPE sd_vkorg_ranges.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    CLEAR: lt_selection[].
    lv_low = sy-datum - 30.
    "------------------------------------
    lw_selection-selname = 'SERDAT'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

* Fill authorized Sales Orgs to submit to report
    LOOP AT lr_vkorg INTO DATA(ls_vkorg).
      lw_selection-selname = 'SVKORG'.
      lw_selection-kind    = 'S'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = 'EQ'.
      lw_selection-low     = ls_vkorg-low.
      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.
    ENDLOOP.
*
    SUBMIT sd_sales_document_view
           WITH SELECTION-TABLE lt_selection
           EXPORTING LIST TO MEMORY AND RETURN.
*
    DATA:list TYPE STANDARD TABLE OF abaplist.
*
*  data: list like abaplist occurs 0 with header line.
    DATA: txtlines TYPE TABLE OF char2048.


    CALL FUNCTION 'LIST_FROM_MEMORY'
      TABLES
        listobject = list
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.
*
    IF sy-subrc EQ 0.

      CALL FUNCTION 'LIST_TO_ASCI'
        EXPORTING
          list_index         = -1
*         WITH_LINE_BREAK    = ' '
        TABLES
          listasci           = txtlines        "lt_out
          listobject         = list
        EXCEPTIONS
          empty_list         = 1
          list_index_invalid = 2
          OTHERS             = 3.
*

*
      LOOP AT txtlines INTO DATA(ls_text).
        ls_text+0(1) = ''.
        IF sy-tabix > 4.
          SPLIT ls_text AT '|' INTO
          lw_data-col1
          lw_data-col2
          lw_data-col3
          lw_data-col4
          lw_data-col5
          lw_data-col6
          lw_data-col7
          lw_data-col8
          lw_data-col9
          lw_data-col10
          lw_data-col11
          lw_data-col12
          lw_data-col13
          lw_data-col14
          lw_data-col15
          lw_data-col16
          lw_data-col17
          lw_data-col18
          lw_data-col19
          lw_data-col20
          lw_data-col21
          lw_data-col22
          lw_data-col23
          lw_data-col24
          lw_data-col25
          lw_data-col26
          lw_data-col27
          lw_data-col28
          lw_data-col29
          lw_data-col30
          lw_data-col31
          lw_data-col32
          lw_data-col33
          lw_data-col34
          lw_data-col35
          lw_data-col36
          lw_data-col37
          lw_data-col38
          lw_data-col39
          lw_data-col40
          lw_data-col41
          lw_data-col42
          lw_data-col43
          lw_data-col44
          lw_data-col45
          lw_data-col46
          lw_data-col47
          lw_data-col48
          lw_data-col49
          lw_data-col50
          lw_data-col51
          lw_data-col52
          lw_data-col53
          lw_data-col54
          lw_data-col55
          lw_data-col56
          lw_data-col57
          lw_data-col58
          lw_data-col59
          lw_data-col60
          lw_data-col61
          lw_data-col62
          lw_data-col63
          lw_data-col64
          lw_data-col65
          lw_data-col66
          lw_data-col67
          lw_data-col68
          lw_data-col69
          lw_data-col70
          lw_data-col71
          lw_data-col72
          lw_data-col73
          lw_data-col74
          lw_data-col75
          lw_data-col76
          lw_data-col77
          lw_data-col78
          lw_data-col79
          lw_data-col80
          lw_data-col81
          lw_data-col82
          lw_data-col83
          lw_data-col84
          lw_data-col85
          lw_data-col86
          lw_data-col87
          lw_data-col88
          lw_data-col89
          lw_data-col90
          lw_data-col91
          lw_data-col92
          lw_data-col93
          lw_data-col94
          lw_data-col95
          lw_data-col96
          lw_data-col97
          lw_data-col98
          lw_data-col99
          lw_data-col100
          lw_data-col101
          lw_data-col102
          lw_data-col103
          lw_data-col104
          lw_data-col105
          lw_data-col106
          lw_data-col107
          lw_data-col108
          lw_data-col109
          lw_data-col110
          lw_data-col111
          lw_data-col112
          lw_data-col113
          lw_data-col114
          lw_data-col115
          lw_data-col116
          lw_data-col117
          lw_data-col118
          lw_data-col119
          lw_data-col120
          lw_data-col121
          lw_data-col122
          lw_data-col123
          lw_data-col124
          lw_data-col125
          lw_data-col126
          lw_data-col127
          lw_data-col128
          lw_data-col129
          lw_data-col130
          lw_data-col131
          lw_data-col132
          lw_data-col133
          lw_data-col134
          lw_data-col135
          lw_data-col136
          lw_data-col137
          lw_data-col138
          lw_data-col139
          lw_data-col140
          lw_data-col141
          lw_data-col142
          lw_data-col143
          lw_data-col144
          lw_data-col145
          lw_data-col146
          lw_data-col147
          lw_data-col148
          lw_data-col149
          lw_data-col150
          lw_data-col151
          lw_data-col152
          lw_data-col153
          lw_data-col154
          lw_data-col155
          lw_data-col156
          lw_data-col157
          lw_data-col158
          lw_data-col159
          lw_data-col160
          lw_data-col161
          lw_data-col162
          lw_data-col163
          lw_data-col164
          lw_data-col165
          lw_data-col166
          lw_data-col167
          lw_data-col168
          lw_data-col169
          lw_data-col170
          lw_data-col171
          lw_data-col172
          lw_data-col173
          lw_data-col174
          lw_data-col175
          lw_data-col176
          lw_data-col177
          lw_data-col178
          lw_data-col179
          lw_data-col180
          lw_data-col181
          lw_data-col182
          lw_data-col183
          lw_data-col184
          lw_data-col185
          lw_data-col186
          lw_data-col187
          lw_data-col188
          lw_data-col189
 .

          APPEND lw_data TO lt_data.
          CLEAR: lw_data, lw_entity.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_data INTO lw_data.
*        lw_entity-vbeln = lw_data-col4 .        "Object Type
*        lw_entity-posnr = lw_data-col5 .       "Object
        lw_entity-ebeln =  lw_data-col1.
        lw_entity-docdate =  lw_data-col2.
        lw_entity-auart =  lw_data-col3.
        lw_entity-vbeln = lw_data-col4.
        lw_entity-posnr = lw_data-col5.
        lw_entity-kunnr =  lw_data-col6.
        lw_entity-matnr =  lw_data-col7.
        lw_entity-menge =  lw_data-col8.
        lw_entity-meins =  lw_data-col9.
        lw_entity-nvitem =  lw_data-col10.
        lw_entity-waers =  lw_data-col11.
        lw_entity-overallcr1 =  lw_data-col12.
        lw_entity-overallcr2 =  lw_data-col13.
        lw_entity-shipto =  lw_data-col14.
        lw_entity-shiptoname =  lw_data-col15.
        lw_entity-shiptoname2 =  lw_data-col16.
        lw_entity-soldtoname2 =   lw_data-col17.
        lw_entity-vbpalifnr =   lw_data-col18.
        lw_entity-fwname  =  lw_data-col19.
        lw_entity-fwstreet =  lw_data-col20.
        lw_entity-fwcity =   lw_data-col21.
        lw_entity-fwpostal =   lw_data-col22.
        lw_entity-fwcountry =   lw_data-col23.
        lw_entity-billdesc =   lw_data-col24.
        lw_entity-paidstatus =   lw_data-col25.
        lw_entity-creditlimit =   lw_data-col26.
        lw_entity-namekunag =   lw_data-col27.
        lw_entity-abgru  =   lw_data-col28.
        lw_entity-vbrkvbeln  =   lw_data-col29.
        lw_entity-vbrkfkart =   lw_data-col30.
        lw_entity-vbrkfktyp =   lw_data-col31.
        lw_entity-vbrkfkdat =   lw_data-col32.
        lw_entity-vbrkkonda =   lw_data-col33.
        lw_entity-vbrpuepos =   lw_data-col34.
        lw_entity-augru =   lw_data-col35.
        lw_entity-bstnk =   lw_data-col36.
        lw_entity-ernam =   lw_data-col37.
        lw_entity-erdat =   lw_data-col38.
        lw_entity-erzet =   lw_data-col39.
        lw_entity-faksk =   lw_data-col40.
        lw_entity-ktext =   lw_data-col41.
        lw_entity-kurst =   lw_data-col42.
        lw_entity-lifsk =   lw_data-col43.
        lw_entity-netwr =   lw_data-col44.
        lw_entity-spart =   lw_data-col45.
        lw_entity-vbtyp =   lw_data-col46.
        lw_entity-vkbur =   lw_data-col47.
        lw_entity-vkgrp =   lw_data-col48.
        lw_entity-vkorg =   lw_data-col49.
        lw_entity-vtweg =   lw_data-col50.
        lw_entity-arktx =   lw_data-col51.
        lw_entity-charg =   lw_data-col52.
        lw_entity-kbmeng =   lw_data-col53.
        lw_entity-kmein =   lw_data-col54.
        lw_entity-kpein =   lw_data-col55.
        lw_entity-lgort =   lw_data-col56.
        lw_entity-netpr =   lw_data-col57.
        lw_entity-shkzg =   lw_data-col58.
        lw_entity-vrkme =   lw_data-col59.
        lw_entity-vstel =   lw_data-col60.
        lw_entity-werks =   lw_data-col61.
        lw_entity-zmeng =   lw_data-col62.
        lw_entity-bstkd =   lw_data-col63.
        lw_entity-kursk =   lw_data-col64.
        lw_entity-prsdt =   lw_data-col65.
        lw_entity-zpavw =   lw_data-col66.
        lw_entity-pernr =   lw_data-col67.
        lw_entity-parvw =   lw_data-col68.
        lw_entity-vbpaadrnr =   lw_data-col69.
        lw_entity-vbpakunnr =   lw_data-col70.
        lw_entity-namekunnr =   lw_data-col71.
        lw_entity-etenr =   lw_data-col72.
        lw_entity-edatu =   lw_data-col73.
        lw_entity-wmeng =   lw_data-col74.
        lw_entity-bmeng =   lw_data-col75.
        lw_entity-cmeng =   lw_data-col76.
        lw_entity-wadat =   lw_data-col77.
        lw_entity-mbdat =   lw_data-col78.
        lw_entity-ettyp =   lw_data-col79.
        lw_entity-vlaufz =   lw_data-col80.
        lw_entity-vlauez   =   lw_data-col81.
        lw_entity-vlaufk = lw_data-col82.
        lw_entity-vinsdat =   lw_data-col83.
        lw_entity-vabndat =   lw_data-col84.
        lw_entity-vuntdat =   lw_data-col85.
        lw_entity-vbegdat =   lw_data-col86.
        lw_entity-venddat =   lw_data-col87.
        lw_entity-vkuesch =   lw_data-col88.
        lw_entity-vaktsch =   lw_data-col89.
        lw_entity-veindat =   lw_data-col90.
        lw_entity-vwundat =   lw_data-col91.
        lw_entity-vkuepar =   lw_data-col92.
        lw_entity-vkuegru =   lw_data-col93.
        lw_entity-vbelkue = lw_data-col94.
        lw_entity-vbedkue =   lw_data-col95.
        lw_entity-vdemdat =   lw_data-col96.
        lw_entity-vasda =   lw_data-col97.
        lw_entity-gbstk =   lw_data-col98.
        lw_entity-lfgsk =   lw_data-col99.
        lw_entity-gbsta =   lw_data-col100.
        lw_entity-lfgsa =   lw_data-col101.
        lw_entity-lifskt =   lw_data-col102.
        lw_entity-fakskt =   lw_data-col103.
        lw_entity-augrut =   lw_data-col104.
        lw_entity-abgrut =   lw_data-col105.
        lw_entity-namepernr =   lw_data-col106.
        lw_entity-gbstkt =   lw_data-col107.
        lw_entity-lfgskt =   lw_data-col108.
        lw_entity-gbstat =   lw_data-col109.
        lw_entity-lfgsat =   lw_data-col110.
        lw_entity-vaktscht =   lw_data-col111.
        lw_entity-vkorgt =   lw_data-col112.
        lw_entity-vtwegt =   lw_data-col113.
        lw_entity-spartt =   lw_data-col114.
        lw_entity-auartt =   lw_data-col115.
        lw_entity-vbkdihreze =   lw_data-col116.
        lw_entity-tokenmatnr =   lw_data-col117.
        lw_entity-vbakkvgr1 =   lw_data-col118.
        lw_entity-vbakkvgr2 =   lw_data-col119.
        lw_entity-vbakkvgr3 =   lw_data-col120.
        lw_entity-vbakkvgr4 =   lw_data-col121.
        lw_entity-vbakkvgr5 =   lw_data-col122.
        lw_entity-vbakvgbel =   lw_data-col123.
        lw_entity-vbakzzsfdccase =   lw_data-col124.
        lw_entity-vbakzzfice =   lw_data-col125.
        lw_entity-vbakzznoreturn =   lw_data-col126.
        lw_entity-vbakzzholdfrom =   lw_data-col127.
        lw_entity-vbakzzholdto =   lw_data-col128.
        lw_entity-vbakzzpromo =   lw_data-col129.
        lw_entity-vbakzzwhs =   lw_data-col130.
        lw_entity-vbakzzlicgrp =   lw_data-col131.
        lw_entity-vbappstyv =   lw_data-col132.
        lw_entity-vbapmvgr1 =   lw_data-col133.
        lw_entity-vbapmvgr2 =   lw_data-col134.
        lw_entity-vbapmvgr3 =   lw_data-col135.
        lw_entity-vbapmvgr4 =   lw_data-col136.
        lw_entity-vbapmvgr5 =   lw_data-col137.
        lw_entity-vbapzzrgcode =   lw_data-col138.
        lw_entity-vbapzzcancdate =   lw_data-col139.
        lw_entity-vbapzzartno =   lw_data-col140.
        lw_entity-vbapzzisbnlan =   lw_data-col141.
        lw_entity-vbapzzshpocanc =   lw_data-col142.
        lw_entity-vbapzzpromo =   lw_data-col143.
        lw_entity-vbapzzvyp =   lw_data-col144.
        lw_entity-vbapzzaccessmech =   lw_data-col145.
        lw_entity-vbapzzconstart =   lw_data-col146.
        lw_entity-vbapzzconend =   lw_data-col147.
        lw_entity-vbapzzlicstart =   lw_data-col148.
        lw_entity-vbapzzlicend =   lw_data-col149.
        lw_entity-vbkdihrez =   lw_data-col150.
        lw_entity-vbrkgjahr =   lw_data-col151.
        lw_entity-vbrkpoper =   lw_data-col152.
        lw_entity-vbrkkdgrp =   lw_data-col153.
        lw_entity-vbrkpltyp =   lw_data-col154.
        lw_entity-vbrkinco1 =   lw_data-col155.
        lw_entity-vbrkzterm =   lw_data-col156.
        lw_entity-vbrkzlsch =   lw_data-col157.
        lw_entity-vbrkktgrd =   lw_data-col158.
        lw_entity-vbrknetwr =   lw_data-col159.
        lw_entity-vbrkzukri =   lw_data-col160.
        lw_entity-vbrkernam =   lw_data-col161.
        lw_entity-vbrkerzet =   lw_data-col162.
        lw_entity-vbrkerdat =   lw_data-col163.
        lw_entity-vbrkkunrg =   lw_data-col164.
        lw_entity-vbrkstceg =   lw_data-col165.
        lw_entity-vbrksfakn =   lw_data-col166.
        lw_entity-vbrkkurst =   lw_data-col167.
        lw_entity-vbrkmschl =   lw_data-col168.
        lw_entity-vbrkzuonr =   lw_data-col169.
        lw_entity-vbrkmwsbk =   lw_data-col170.
        lw_entity-vbrkkidno =   lw_data-col171.
        lw_entity-vbrpvbeln =   lw_data-col172.
        lw_entity-vbrpposnr =   lw_data-col173.
        lw_entity-vbrpnetwr =   lw_data-col174.
        lw_entity-vbrpkzwi1 =   lw_data-col175.
        lw_entity-vbrpkzwi2 =   lw_data-col176.
        lw_entity-vbrpkzwi3 =   lw_data-col177.
        lw_entity-vbrpkzwi4 =   lw_data-col178.
        lw_entity-vbrpkzwi5 =   lw_data-col179.
        lw_entity-vbrpkzwi6 =   lw_data-col180.
        lw_entity-vbrpprctr =   lw_data-col181.
        lw_entity-vbrptxjcd  =   lw_data-col182.
        lw_entity-podate =   lw_data-col183.
        lw_entity-likpvbeln =   lw_data-col184.
        lw_entity-deldate =   lw_data-col185.
        lw_entity-shcond =   lw_data-col186.
        lw_entity-ordtype  =   lw_data-col187.
        lw_entity-vbkdzlsch =   lw_data-col188.
        lw_entity-vbapkdmat =   lw_data-col189.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_data, lw_entity.
      ENDLOOP.
      SORT et_entityset BY vbeln posnr.
      DELETE et_entityset WHERE vbeln EQ space AND posnr IS INITIAL.
    ENDIF.
    CALL FUNCTION 'LIST_FREE_MEMORY'.

  ENDMETHOD.


  METHOD va25set_get_entityset.

    DATA: textlines TYPE TABLE OF string.
    DATA:lv_report(3) TYPE c,
         lv_auart(4)  TYPE c,
         lr_auart     TYPE tms_t_auart_range,
         lr_auart2    TYPE tms_t_auart_range,
         lst_auart    TYPE tms_s_auart_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA lv_uname TYPE sy-uname.
    DATA:lr_vkorg TYPE sd_vkorg_ranges.

* Fetch user authorized Sales Orgs
    lv_uname = sy-uname.

    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Auart'.
            lv_auart = <ls_filter_opt>-low+0(4).
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = 'I'.
              lst_auart-option = 'EQ'.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart2.
              CLEAR:lst_auart.
            ENDIF.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    TYPES: BEGIN OF ty_header,
             col1   TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
             col5   TYPE string,
             col6   TYPE string,
             col7   TYPE string,
             col8   TYPE string,
             col9   TYPE string,
             col10  TYPE string,
             col11  TYPE string,
             col12  TYPE string,
             col13  TYPE string,
             col14  TYPE string,
             col15  TYPE string,
             col16  TYPE string,
             col17  TYPE string,
             col18  TYPE string,
             col19  TYPE string,
             col20  TYPE string,
             col21  TYPE string,
             col22  TYPE string,
             col23  TYPE string,
             col24  TYPE string,
             col25  TYPE string,
             col26  TYPE string,
             col27  TYPE string,
             col28  TYPE string,
             col29  TYPE string,
             col30  TYPE string,
             col31  TYPE string,
             col32  TYPE string,
             col33  TYPE string,
             col34  TYPE string,
             col35  TYPE string,
             col36  TYPE string,
             col37  TYPE string,
             col38  TYPE string,
             col39  TYPE string,
             col40  TYPE string,
             col41  TYPE string,
             col42  TYPE string,
             col43  TYPE string,
             col44  TYPE string,
             col45  TYPE string,
             col46  TYPE string,
             col47  TYPE string,
             col48  TYPE string,
             col49  TYPE string,
             col50  TYPE string,
             col51  TYPE string,
             col52  TYPE string,
             col53  TYPE string,
             col54  TYPE string,
             col55  TYPE string,
             col56  TYPE string,
             col57  TYPE string,
             col58  TYPE string,
             col59  TYPE string,
             col60  TYPE string,
             col61  TYPE string,
             col62  TYPE string,
             col63  TYPE string,
             col64  TYPE string,
             col65  TYPE string,
             col66  TYPE string,
             col67  TYPE string,
             col68  TYPE string,
             col69  TYPE string,
             col70  TYPE string,
             col71  TYPE string,
             col72  TYPE string,
             col73  TYPE string,
             col74  TYPE string,
             col75  TYPE string,
             col76  TYPE string,
             col77  TYPE string,
             col78  TYPE string,
             col79  TYPE string,
             col80  TYPE string,
             col81  TYPE string,
             col82  TYPE string,
             col83  TYPE string,
             col84  TYPE string,
             col85  TYPE string,
             col86  TYPE string,
             col87  TYPE string,
             col88  TYPE string,
             col89  TYPE string,
             col90  TYPE string,
             col91  TYPE string,
             col92  TYPE string,
             col93  TYPE string,
             col94  TYPE string,
             col95  TYPE string,
             col96  TYPE string,
             col97  TYPE string,
             col98  TYPE string,
             col99  TYPE string,
             col100 TYPE string,
             col101 TYPE string,
             col102 TYPE string,
             col103 TYPE string,
             col104 TYPE string,
             col105 TYPE string,
             col106 TYPE string,
             col107 TYPE string,
             col108 TYPE string,
             col109 TYPE string,
             col110 TYPE string,
             col111 TYPE string,
             col112 TYPE string,
             col113 TYPE string,
             col114 TYPE string,
             col115 TYPE string,
             col116 TYPE string,
             col117 TYPE string,
             col118 TYPE string,
             col119 TYPE string,
             col120 TYPE string,
             col121	TYPE string,
             col122	TYPE string,
             col123	TYPE string,
             col124	TYPE string,
             col125	TYPE string,
             col126	TYPE string,
             col127	TYPE string,
             col128	TYPE string,
             col129	TYPE string,
             col130	TYPE string,
             col131	TYPE string,
             col132	TYPE string,
             col133	TYPE string,
             col134	TYPE string,
             col135	TYPE string,
             col136	TYPE string,
             col137	TYPE string,
             col138	TYPE string,
             col139	TYPE string,
             col140	TYPE string,
             col141	TYPE string,
             col142	TYPE string,
             col143	TYPE string,
             col144	TYPE string,
             col145	TYPE string,
             col146	TYPE string,
             col147	TYPE string,
           END OF ty_header.

    DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
          lw_data      TYPE ty_header,
          lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va25.

    DATA:lv_low TYPE sy-datum.

    CHECK lr_auart2[] IS NOT INITIAL.
    CLEAR: lt_selection[].
    lv_low = sy-datum - 60.
    "------------------------------------
    lw_selection-selname = 'SERDAT'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'VALIDITY'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSQT'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSIQ'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'SQT'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSR'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.
* Fill authorized Sales Orgs to submit to report
    LOOP AT lr_vkorg INTO DATA(ls_vkorg).
      lw_selection-selname = 'SVKORG'.
      lw_selection-kind    = 'S'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = 'EQ'.
      lw_selection-low     = ls_vkorg-low.
      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.
    ENDLOOP.

*
    SUBMIT sd_sales_document_va25
           WITH SELECTION-TABLE lt_selection
           EXPORTING LIST TO MEMORY AND RETURN.
    break npolina.
    DATA:list TYPE STANDARD TABLE OF abaplist.

*  data: list like abaplist occurs 0 with header line.
    DATA: txtlines TYPE TABLE OF char4000.

    CALL FUNCTION 'LIST_FROM_MEMORY'
      TABLES
        listobject = list
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.
*
    IF sy-subrc EQ 0.

      CALL FUNCTION 'LIST_TO_ASCI'
        EXPORTING
          list_index         = -1
*         WITH_LINE_BREAK    = ' '
        TABLES
          listasci           = txtlines        "lt_out
          listobject         = list
        EXCEPTIONS
          empty_list         = 1
          list_index_invalid = 2
          OTHERS             = 3.
*

*
      LOOP AT txtlines INTO DATA(ls_text).
        ls_text+0(1) = ''.
        IF sy-tabix > 4.
          SPLIT ls_text AT '|' INTO
          lw_data-col1
          lw_data-col2
          lw_data-col3
          lw_data-col4
          lw_data-col5
          lw_data-col6
          lw_data-col7
          lw_data-col8
          lw_data-col9
          lw_data-col10
          lw_data-col11
          lw_data-col12
          lw_data-col13
          lw_data-col14
          lw_data-col15
          lw_data-col16
          lw_data-col17
          lw_data-col18
          lw_data-col19
          lw_data-col20
          lw_data-col21
          lw_data-col22
          lw_data-col23
          lw_data-col24
          lw_data-col25
          lw_data-col26
          lw_data-col27
          lw_data-col28
          lw_data-col29
          lw_data-col30
          lw_data-col31
          lw_data-col32
          lw_data-col33
          lw_data-col34
          lw_data-col35
          lw_data-col36
          lw_data-col37
          lw_data-col38
          lw_data-col39
          lw_data-col40
          lw_data-col41
          lw_data-col42
          lw_data-col43
          lw_data-col44
          lw_data-col45
          lw_data-col46
          lw_data-col47
          lw_data-col48
          lw_data-col49
          lw_data-col50
          lw_data-col51
          lw_data-col52
          lw_data-col53
          lw_data-col54
          lw_data-col55
          lw_data-col56
          lw_data-col57
          lw_data-col58
          lw_data-col59
          lw_data-col60
          lw_data-col61
          lw_data-col62
          lw_data-col63
          lw_data-col64
          lw_data-col65
          lw_data-col66
          lw_data-col67
          lw_data-col68
          lw_data-col69
          lw_data-col70
          lw_data-col71
          lw_data-col72
          lw_data-col73
          lw_data-col74
          lw_data-col75
          lw_data-col76
          lw_data-col77
          lw_data-col78
          lw_data-col79
          lw_data-col80
          lw_data-col81
          lw_data-col82
          lw_data-col83
          lw_data-col84
          lw_data-col85
          lw_data-col86
          lw_data-col87
          lw_data-col88
          lw_data-col89
          lw_data-col90
          lw_data-col91
          lw_data-col92
          lw_data-col93
          lw_data-col94
          lw_data-col95
          lw_data-col96
          lw_data-col97
          lw_data-col98
          lw_data-col99
          lw_data-col100
          lw_data-col101
          lw_data-col102
          lw_data-col103
          lw_data-col104
          lw_data-col105
          lw_data-col106
          lw_data-col107
          lw_data-col108
          lw_data-col109
          lw_data-col110
          lw_data-col111
          lw_data-col112
          lw_data-col113
          lw_data-col114
          lw_data-col115
          lw_data-col116
          lw_data-col117
          lw_data-col118
          lw_data-col119
          lw_data-col120
          lw_data-col121
          lw_data-col122
          lw_data-col123
          lw_data-col124
          lw_data-col125
          lw_data-col126
          lw_data-col127
          lw_data-col128
          lw_data-col129
          lw_data-col130
          lw_data-col131
          lw_data-col132
          lw_data-col133
          lw_data-col134
          lw_data-col135
          lw_data-col136
          lw_data-col137
          lw_data-col138
          lw_data-col139
          lw_data-col140
          lw_data-col141
          lw_data-col142
          lw_data-col143
          lw_data-col144
          lw_data-col145
          lw_data-col146
          lw_data-col147.
          APPEND lw_data TO lt_data.
          CLEAR: lw_data, lw_entity.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_data INTO lw_data.
        lw_entity-kunnr = lw_data-col1.
        lw_entity-docdate = lw_data-col2.
        lw_entity-auart = lw_data-col3.
        lw_entity-angdt = lw_data-col4.
        lw_entity-bnddt = lw_data-col5.
        lw_entity-vbeln = lw_data-col6 .        "Object Type
        lw_entity-posnr = lw_data-col7 .       "Object
        lw_entity-matnr = lw_data-col8.
        lw_entity-menge = lw_data-col9.
        lw_entity-vbegdat = lw_data-col10.
        lw_entity-venddat = lw_data-col11.
        lw_entity-bstnk = lw_data-col12.
        lw_entity-vrkme = lw_data-col13.
        lw_entity-nvitem = lw_data-col14.
        lw_entity-waers = lw_data-col15.
        lw_entity-vbpalifnr = lw_data-col16.
        lw_entity-fwname = lw_data-col17.
        lw_entity-fwstreet = lw_data-col18.
        lw_entity-fwcity = lw_data-col19.
        lw_entity-fwpostal = lw_data-col20.
        lw_entity-fwcountry = lw_data-col21.
        lw_entity-augru = lw_data-col22.
        lw_entity-bstkd = lw_data-col23.
        lw_entity-ernam = lw_data-col24.
        lw_entity-erdat = lw_data-col25.
        lw_entity-erzet = lw_data-col26.
        lw_entity-faksk = lw_data-col27.
        lw_entity-arktx = lw_data-col28.
        lw_entity-kurst = lw_data-col29.
        lw_entity-lifsk = lw_data-col30.
        lw_entity-netwr = lw_data-col31.
        lw_entity-spart = lw_data-col32.
        lw_entity-vbtyp = lw_data-col33.
        lw_entity-vkbur = lw_data-col34.
        lw_entity-vkgrp = lw_data-col35.
        lw_entity-vkorg = lw_data-col36.
        lw_entity-vtweg = lw_data-col37.
        lw_entity-vbakawahr = lw_data-col38.
        lw_entity-namekunag = lw_data-col39.
        lw_entity-abgru = lw_data-col40.
        lw_entity-ktext = lw_data-col41.
        lw_entity-awahr = lw_data-col42.
        lw_entity-charg = lw_data-col43.
        lw_entity-kbmeng = lw_data-col44.
        lw_entity-kmein = lw_data-col45.
        lw_entity-kpein = lw_data-col46.
        lw_entity-lgort = lw_data-col47.
        lw_entity-meins = lw_data-col48.
        lw_entity-netpr = lw_data-col49.
        lw_entity-shkzg = lw_data-col50.
        lw_entity-vstel = lw_data-col51.
        lw_entity-werks = lw_data-col52.
        lw_entity-zmeng = lw_data-col53.
        lw_entity-kursk = lw_data-col54.
        lw_entity-prsdt = lw_data-col55.
        lw_entity-zpavw = lw_data-col56.
        lw_entity-pernr = lw_data-col57.
        lw_entity-parvw = lw_data-col58.
        lw_entity-vbpaadrnr = lw_data-col59.
        lw_entity-vbpakunnr = lw_data-col60.
        lw_entity-namekunnr = lw_data-col61.
        lw_entity-etenr = lw_data-col62.
        lw_entity-edatu = lw_data-col63.
        lw_entity-wmeng = lw_data-col64.
        lw_entity-bmeng = lw_data-col65.
        lw_entity-cmeng = lw_data-col66.
        lw_entity-wadat = lw_data-col67.
        lw_entity-mbdat = lw_data-col68.
        lw_entity-ettyp = lw_data-col69.
        lw_entity-vlaufz = lw_data-col70.
        lw_entity-vlauez = lw_data-col71.
        lw_entity-vlaufk = lw_data-col72.
        lw_entity-vinsdat = lw_data-col73.
        lw_entity-vabndat = lw_data-col74.
        lw_entity-vuntdat = lw_data-col75.
        lw_entity-vkuesch = lw_data-col76.
        lw_entity-vaktsch = lw_data-col77.
        lw_entity-veindat = lw_data-col78.
        lw_entity-vwundat = lw_data-col79.
        lw_entity-vkuepar = lw_data-col80.
        lw_entity-vkuegru = lw_data-col81.
        lw_entity-vbelkue = lw_data-col82.
        lw_entity-vbedkue = lw_data-col83.
        lw_entity-vdemdat = lw_data-col84.
        lw_entity-vasda = lw_data-col85.
        lw_entity-gbstk = lw_data-col86.
        lw_entity-rfgsk = lw_data-col87.
        lw_entity-gbsta = lw_data-col88.
        lw_entity-rfgsa = lw_data-col89.
        lw_entity-lifskt = lw_data-col90.
        lw_entity-fakskt = lw_data-col91.
        lw_entity-augrut = lw_data-col92.
        lw_entity-abgrut = lw_data-col93.
        lw_entity-namepernr = lw_data-col94.
        lw_entity-gbstkt = lw_data-col95.
        lw_entity-rfgskt = lw_data-col96.
        lw_entity-gbstat = lw_data-col97.
        lw_entity-rfgsat = lw_data-col98.
        lw_entity-vaktscht = lw_data-col99.
        lw_entity-vkorgt = lw_data-col100.
        lw_entity-vtwegt =  lw_data-col101.
        lw_entity-spartt =  lw_data-col102.
        lw_entity-auartt =  lw_data-col103.
        lw_entity-zzpromo =	lw_data-col104.
        lw_entity-vbapkdmat = lw_data-col105.
        lw_entity-vbakkvgr1 = lw_data-col106.
        lw_entity-vbakkvgr2 = lw_data-col107.
        lw_entity-vbakkvgr3 = lw_data-col108.
        lw_entity-vbakkvgr4 = lw_data-col109.
        lw_entity-vbakkvgr5 = lw_data-col110.
        lw_entity-vbakbsark = lw_data-col111.
        lw_entity-vbappstyv = lw_data-col112.
        lw_entity-vbapmvgr1 = lw_data-col113.
        lw_entity-vbapmvgr2 = lw_data-col114.
        lw_entity-vbapmvgr3 = lw_data-col115.
        lw_entity-vbapmvgr4 = lw_data-col116.
        lw_entity-vbapmvgr5 = lw_data-col117.
        lw_entity-vbkdihrez = lw_data-col118.
        lw_entity-vbkdkonda = lw_data-col119.
        lw_entity-vbkdkdkg2 = lw_data-col120.
        lw_entity-vbpaparvw =  lw_data-col121.
        lw_entity-vbakzzsfdccase =  lw_data-col122.
        lw_entity-vbakzzfice =  lw_data-col123.
        lw_entity-vbakzzholdfrom =  lw_data-col124.
        lw_entity-vbakzzholdto =  lw_data-col125.
        lw_entity-vbakzzpromo =  lw_data-col126.
        lw_entity-vbakzzlicgrp =  lw_data-col127.
        lw_entity-vbapzzpromo = lw_data-col128.
        lw_entity-vbapzzrgcode =  lw_data-col129.
        lw_entity-vbapzzartno = lw_data-col130.
        lw_entity-vbapzzisbnlan = lw_data-col131.
        lw_entity-vbapzzvyp = lw_data-col132.
        lw_entity-vbapzzaccessmech = lw_data-col133.
        lw_entity-vbapzzconstart =  lw_data-col134.
        lw_entity-vbapzzconend =  lw_data-col135.
        lw_entity-vbapzzlicstart = lw_data-col136.
        lw_entity-vbapzzlicend = lw_data-col137.
        lw_entity-vbfavbtypn = lw_data-col138.
        lw_entity-vbfavbeln = lw_data-col139.
        lw_entity-overallcr1 = lw_data-col140.
        lw_entity-overallcr2 = lw_data-col141.
        lw_entity-creditlimit = lw_data-col142.
        lw_entity-shipto = lw_data-col143.
        lw_entity-shiptoname = lw_data-col144.
        lw_entity-shiptoname2 =	lw_data-col145.
        lw_entity-soldtoname2 = lw_data-col146.
        lw_entity-vbkdzlsch = lw_data-col147.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_data, lw_entity.
      ENDLOOP.
      SORT et_entityset BY vbeln posnr.
      DELETE et_entityset WHERE vbeln EQ space AND posnr IS INITIAL.
    ENDIF.
    CALL FUNCTION 'LIST_FREE_MEMORY'.


  ENDMETHOD.


  METHOD va45set_get_entityset.

    DATA: textlines TYPE TABLE OF string.
    DATA:lv_report(3) TYPE c,
         lv_auart(4)  TYPE c,
         lr_auart     TYPE tms_t_auart_range,
         lr_auart2    TYPE tms_t_auart_range,
         lst_auart    TYPE tms_s_auart_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA lv_uname TYPE sy-uname.
    DATA:lr_vkorg TYPE sd_vkorg_ranges.

* Fetch user authorized Sales Orgs
    lv_uname = sy-uname.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Auart'.   " Passing Sales Document Type
            lv_auart = <ls_filter_opt>-low+0(4).
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = 'I'.
              lst_auart-option = 'EQ'.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart2.
              CLEAR:lst_auart.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    TYPES: BEGIN OF ty_header,
             col1   TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
             col5   TYPE string,
             col6   TYPE string,
             col7   TYPE string,
             col8   TYPE string,
             col9   TYPE string,
             col10  TYPE string,
             col11  TYPE string,
             col12  TYPE string,
             col13  TYPE string,
             col14  TYPE string,
             col15  TYPE string,
             col16  TYPE string,
             col17  TYPE string,
             col18  TYPE string,
             col19  TYPE string,
             col20  TYPE string,
             col21  TYPE string,
             col22  TYPE string,
             col23  TYPE string,
             col24  TYPE string,
             col25  TYPE string,
             col26  TYPE string,
             col27  TYPE string,
             col28  TYPE string,
             col29  TYPE string,
             col30  TYPE string,
             col31  TYPE string,
             col32  TYPE string,
             col33  TYPE string,
             col34  TYPE string,
             col35  TYPE string,
             col36  TYPE string,
             col37  TYPE string,
             col38  TYPE string,
             col39  TYPE string,
             col40  TYPE string,
             col41  TYPE string,
             col42  TYPE string,
             col43  TYPE string,
             col44  TYPE string,
             col45  TYPE string,
             col46  TYPE string,
             col47  TYPE string,
             col48  TYPE string,
             col49  TYPE string,
             col50  TYPE string,
             col51  TYPE string,
             col52  TYPE string,
             col53  TYPE string,
             col54  TYPE string,
             col55  TYPE string,
             col56  TYPE string,
             col57  TYPE string,
             col58  TYPE string,
             col59  TYPE string,
             col60  TYPE string,
             col61  TYPE string,
             col62  TYPE string,
             col63  TYPE string,
             col64  TYPE string,
             col65  TYPE string,
             col66  TYPE string,
             col67  TYPE string,
             col68  TYPE string,
             col69  TYPE string,
             col70  TYPE string,
             col71  TYPE string,
             col72  TYPE string,
             col73  TYPE string,
             col74  TYPE string,
             col75  TYPE string,
             col76  TYPE string,
             col77  TYPE string,
             col78  TYPE string,
             col79  TYPE string,
             col80  TYPE string,
             col81  TYPE string,
             col82  TYPE string,
             col83  TYPE string,
             col84  TYPE string,
             col85  TYPE string,
             col86  TYPE string,
             col87  TYPE string,
             col88  TYPE string,
             col89  TYPE string,
             col90  TYPE string,
             col91  TYPE string,
             col92  TYPE string,
             col93  TYPE string,
             col94  TYPE string,
             col95  TYPE string,
             col96  TYPE string,
             col97  TYPE string,
             col98  TYPE string,
             col99  TYPE string,
             col100 TYPE string,
             col101 TYPE string,
             col102 TYPE string,
             col103 TYPE string,
             col104 TYPE string,
             col105 TYPE string,
             col106 TYPE string,
             col107 TYPE string,
             col108 TYPE string,
             col109 TYPE string,
             col110 TYPE string,
             col111 TYPE string,
             col112 TYPE string,
             col113 TYPE string,
             col114 TYPE string,
             col115 TYPE string,
             col116 TYPE string,
             col117 TYPE string,
             col118 TYPE string,
             col119 TYPE string,
             col120 TYPE string,
             col121	TYPE string,
             col122	TYPE string,
             col123	TYPE string,
             col124	TYPE string,
             col125	TYPE string,
             col126	TYPE string,
             col127	TYPE string,
             col128	TYPE string,
             col129	TYPE string,
             col130	TYPE string,
             col131	TYPE string,
             col132	TYPE string,
             col133	TYPE string,
             col134	TYPE string,
             col135	TYPE string,
             col136	TYPE string,
             col137	TYPE string,
             col138	TYPE string,
             col139	TYPE string,
             col140	TYPE string,
             col141	TYPE string,
             col142	TYPE string,
             col143	TYPE string,
             col144	TYPE string,
             col145	TYPE string,
             col146	TYPE string,
             col147	TYPE string,
             col148	TYPE string,
             col149	TYPE string,
             col150	TYPE string,
             col151	TYPE string,
             col152	TYPE string,
             col153	TYPE string,
             col154	TYPE string,
             col155	TYPE string,
             col156	TYPE string,
             col157	TYPE string,
             col158	TYPE string,
             col159	TYPE string,
             col160	TYPE string,
             col161	TYPE string,
             col162	TYPE string,
             col163	TYPE string,
             col164	TYPE string,
             col165	TYPE string,
             col166	TYPE string,
             col167	TYPE string,
             col168	TYPE string,
             col169	TYPE string,
             col170	TYPE string,
             col171	TYPE string,
             col172	TYPE string,
             col173	TYPE string,
             col174	TYPE string,
             col175	TYPE string,
             col176	TYPE string,
             col177	TYPE string,
             col178	TYPE string,
             col179	TYPE string,
             col180	TYPE string,
             col181	TYPE string,
             col182	TYPE string,
             col183	TYPE string,
             col184	TYPE string,
             col185	TYPE string,
             col186	TYPE string,
             col187	TYPE string,
             col188	TYPE string,
             col189	TYPE string,
             col190	TYPE string,
             col191	TYPE string,
             col192	TYPE string,
             col193	TYPE string,
             col194	TYPE string,
             col195	TYPE string,
             col196	TYPE string,
             col197	TYPE string,
             col198	TYPE string,
             col199	TYPE string,
             col200	TYPE string,
             col201	TYPE string,
             col202	TYPE string,
             col203	TYPE string,
             col204	TYPE string,
             col205	TYPE string,
             col206	TYPE string,
             col207	TYPE string,
             col208	TYPE string,
             col209	TYPE string,
             col210	TYPE string,
             col211	TYPE string,
             col212	TYPE string,


           END OF ty_header.

    DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
          lw_data      TYPE ty_header,
          lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va45.



    DATA:lv_low TYPE sy-datum.

    CHECK lr_auart2[] IS NOT INITIAL.
    CLEAR: lt_selection[].
    lv_low = sy-datum - 30.
    "------------------------------------
    lw_selection-selname = 'SERDAT'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'VALIDITY'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSUB'.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSBP'.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZREW'.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

* Fill authorized Sales Orgs to submit to report
    LOOP AT lr_vkorg INTO DATA(ls_vkorg).
      lw_selection-selname = 'SVKORG'.
      lw_selection-kind    = 'S'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = 'EQ'.
      lw_selection-low     = ls_vkorg-low.
      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.
    ENDLOOP.


    SUBMIT sd_sales_document_va45
           WITH SELECTION-TABLE lt_selection
           EXPORTING LIST TO MEMORY AND RETURN.

    DATA:list TYPE STANDARD TABLE OF abaplist.


    DATA: txtlines TYPE TABLE OF char2048.

    CALL FUNCTION 'LIST_FROM_MEMORY'
      TABLES
        listobject = list
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'LIST_TO_ASCI'
        EXPORTING
          list_index         = -1
        TABLES
          listasci           = txtlines        "lt_out
          listobject         = list
        EXCEPTIONS
          empty_list         = 1
          list_index_invalid = 2
          OTHERS             = 3.

      LOOP AT txtlines INTO DATA(ls_text).
        ls_text+0(1) = ''.
        IF sy-tabix > 4.
          SPLIT ls_text AT '|' INTO
          lw_data-col1
          lw_data-col2
          lw_data-col3
          lw_data-col4
          lw_data-col5
          lw_data-col6
          lw_data-col7
          lw_data-col8
          lw_data-col9
          lw_data-col10
          lw_data-col11
          lw_data-col12
          lw_data-col13
          lw_data-col14
          lw_data-col15
          lw_data-col16
          lw_data-col17
          lw_data-col18
          lw_data-col19
          lw_data-col20
          lw_data-col21
          lw_data-col22
          lw_data-col23
          lw_data-col24
          lw_data-col25
          lw_data-col26
          lw_data-col27
          lw_data-col28
          lw_data-col29
          lw_data-col30
          lw_data-col31
          lw_data-col32
          lw_data-col33
          lw_data-col34
          lw_data-col35
          lw_data-col36
          lw_data-col37
          lw_data-col38
          lw_data-col39
          lw_data-col40
          lw_data-col41
          lw_data-col42
          lw_data-col43
          lw_data-col44
          lw_data-col45
          lw_data-col46
          lw_data-col47
          lw_data-col48
          lw_data-col49
          lw_data-col50
          lw_data-col51
          lw_data-col52
          lw_data-col53
          lw_data-col54
          lw_data-col55
          lw_data-col56
          lw_data-col57
          lw_data-col58
          lw_data-col59
          lw_data-col60
          lw_data-col61
          lw_data-col62
          lw_data-col63
          lw_data-col64
          lw_data-col65
          lw_data-col66
          lw_data-col67
          lw_data-col68
          lw_data-col69
          lw_data-col70
          lw_data-col71
          lw_data-col72
          lw_data-col73
          lw_data-col74
          lw_data-col75
          lw_data-col76
          lw_data-col77
          lw_data-col78
          lw_data-col79
          lw_data-col80
          lw_data-col81
          lw_data-col82
          lw_data-col83
          lw_data-col84
          lw_data-col85
          lw_data-col86
          lw_data-col87
          lw_data-col88
          lw_data-col89
          lw_data-col90
          lw_data-col91
          lw_data-col92
          lw_data-col93
          lw_data-col94
          lw_data-col95
          lw_data-col96
          lw_data-col97
          lw_data-col98
          lw_data-col99
          lw_data-col100
          lw_data-col101
          lw_data-col102
          lw_data-col103
          lw_data-col104
          lw_data-col105
          lw_data-col106
          lw_data-col107
          lw_data-col108
          lw_data-col109
          lw_data-col110
          lw_data-col111
          lw_data-col112
          lw_data-col113
          lw_data-col114
          lw_data-col115
          lw_data-col116
          lw_data-col117
          lw_data-col118
          lw_data-col119
          lw_data-col120
          lw_data-col121
          lw_data-col122
          lw_data-col123
          lw_data-col124
          lw_data-col125
          lw_data-col126
          lw_data-col127
          lw_data-col128
          lw_data-col129
          lw_data-col130
          lw_data-col131
          lw_data-col132
          lw_data-col133
          lw_data-col134
          lw_data-col135
          lw_data-col136
          lw_data-col137
          lw_data-col138
          lw_data-col139
          lw_data-col140
          lw_data-col141
          lw_data-col142
          lw_data-col143
          lw_data-col144
          lw_data-col145
          lw_data-col146
          lw_data-col147
          lw_data-col148
          lw_data-col149
          lw_data-col150
          lw_data-col151
          lw_data-col152
          lw_data-col153
          lw_data-col154
          lw_data-col155
          lw_data-col156
          lw_data-col157
          lw_data-col158
          lw_data-col159
          lw_data-col160
          lw_data-col161
          lw_data-col162
          lw_data-col163
          lw_data-col164
          lw_data-col165
          lw_data-col166
          lw_data-col167
          lw_data-col168
          lw_data-col169
          lw_data-col170
          lw_data-col171
          lw_data-col172
          lw_data-col173
          lw_data-col174
          lw_data-col175
          lw_data-col176
          lw_data-col177
          lw_data-col178
          lw_data-col179
          lw_data-col180
          lw_data-col181
          lw_data-col182
          lw_data-col183
          lw_data-col184
          lw_data-col185
          lw_data-col186
          lw_data-col187
          lw_data-col188
          lw_data-col189
          lw_data-col190
          lw_data-col191
          lw_data-col192
          lw_data-col193
          lw_data-col194
          lw_data-col195
          lw_data-col196
          lw_data-col197
          lw_data-col198
          lw_data-col199
          lw_data-col200
          lw_data-col201
          lw_data-col202
          lw_data-col203
          lw_data-col204
          lw_data-col205
          lw_data-col206
          lw_data-col207
          lw_data-col208
          lw_data-col209
          lw_data-col210
          lw_data-col211
          lw_data-col212.

          APPEND lw_data TO lt_data.
          CLEAR: lw_data, lw_entity.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_data INTO lw_data.

        lw_entity-vbeln       = lw_data-col1.   "Object Type
        lw_entity-posnr       = lw_data-col2.   "Object
        lw_entity-auart       = lw_data-col3.
        lw_entity-audat       = lw_data-col4.
        lw_entity-augru       = lw_data-col5.
        lw_entity-bstnk       = lw_data-col6.
        lw_entity-ernam       = lw_data-col7.   "Purchase order number
        lw_entity-erdat       = lw_data-col8.
        lw_entity-erzet       = lw_data-col9.
        lw_entity-faksk       = lw_data-col10.
        lw_entity-ktext       = lw_data-col11.
        lw_entity-kunnr       = lw_data-col12.
        lw_entity-kurst       = lw_data-col13.
        lw_entity-lifsk       = lw_data-col14.
        lw_entity-netwr       = lw_data-col15.
        lw_entity-spart       = lw_data-col16.
        lw_entity-vbtyp       = lw_data-col17.
        lw_entity-vkbur       = lw_data-col18.
        lw_entity-vkgrp       = lw_data-col19.
        lw_entity-vkorg       = lw_data-col20.
        lw_entity-vtweg       = lw_data-col21.
        lw_entity-waerk       = lw_data-col21.
        lw_entity-guebg       = lw_data-col23.
        lw_entity-gueen       = lw_data-col24.
        lw_entity-namekunag   = lw_data-col25.
        lw_entity-abgru       = lw_data-col26.
        lw_entity-arktx       = lw_data-col27.
        lw_entity-charg       = lw_data-col28.
        lw_entity-kbmeng      = lw_data-col29.
        lw_entity-kmein       = lw_data-col30.
        lw_entity-kpein       = lw_data-col31.
        lw_entity-kwmeng      = lw_data-col32.
        lw_entity-lgort       = lw_data-col33.
        lw_entity-matnr       = lw_data-col34.
        lw_entity-meins       = lw_data-col35.
        lw_entity-netpr       = lw_data-col36.
        lw_entity-vbapnetwr   = lw_data-col37.
        lw_entity-shkzg       = lw_data-col38.
        lw_entity-vrkme       = lw_data-col39.
        lw_entity-vstel       = lw_data-col40.
        lw_entity-werks       = lw_data-col41.
        lw_entity-zmeng       = lw_data-col42.
        lw_entity-bstkd       = lw_data-col43.
        lw_entity-kursk       = lw_data-col44.
        lw_entity-prsdt       = lw_data-col45.
        lw_entity-zpavw       = lw_data-col46.
        lw_entity-pernr       = lw_data-col47.
        lw_entity-parvw       = lw_data-col48.
        lw_entity-vbpaadrnr   = lw_data-col49.
        lw_entity-vbpakunnr   = lw_data-col50.
        lw_entity-namekunnr   = lw_data-col51.
        lw_entity-etenr       = lw_data-col52.
        lw_entity-edatu       = lw_data-col53.
        lw_entity-wmeng       = lw_data-col54.
        lw_entity-bmeng       = lw_data-col55.
        lw_entity-cmeng       = lw_data-col56.
        lw_entity-wadat       = lw_data-col57.
        lw_entity-mbdat       = lw_data-col58.
        lw_entity-ettyp       = lw_data-col59.
        lw_entity-vlaufz      = lw_data-col60.
        lw_entity-vlauez      = lw_data-col61.
        lw_entity-vlaufk      = lw_data-col62.
        lw_entity-vinsdat     = lw_data-col63.
        lw_entity-vabndat     = lw_data-col64.
        lw_entity-vuntdat     = lw_data-col65.
        lw_entity-vbegdat     = lw_data-col66.
        lw_entity-venddat     = lw_data-col67.
        lw_entity-vkuesch     = lw_data-col68.
        lw_entity-vaktsch     = lw_data-col69.
        lw_entity-veindat     = lw_data-col70.
        lw_entity-vwundat     = lw_data-col71.
        lw_entity-vkuepar     = lw_data-col72.
        lw_entity-vkuegru     = lw_data-col73.
        lw_entity-vbelkue     = lw_data-col74.
        lw_entity-vbedkue     = lw_data-col75.
        lw_entity-vdemdat     = lw_data-col76.
        lw_entity-vasda       = lw_data-col77.
        lw_entity-gbstk       = lw_data-col78.
        lw_entity-rfgsk       = lw_data-col79.
        lw_entity-gbsta       = lw_data-col80.
        lw_entity-rfgsa       = lw_data-col81.
        lw_entity-lifskt      = lw_data-col82.
        lw_entity-fakskt      = lw_data-col83.
        lw_entity-augrut      = lw_data-col84.
        lw_entity-abgrut      = lw_data-col85.
        lw_entity-namepernr   = lw_data-col86.
        lw_entity-gbstkt      = lw_data-col87.
        lw_entity-rfgskt      = lw_data-col88.
        lw_entity-gbstat      = lw_data-col89.
        lw_entity-rfgsat      = lw_data-col90.
        lw_entity-vaktscht    = lw_data-col91.
        lw_entity-vkorgt      = lw_data-col92.
        lw_entity-vtwegt      = lw_data-col93.
        lw_entity-spartt      = lw_data-col94.
        lw_entity-auartt      = lw_data-col95.
        lw_entity-zzpromo     = lw_data-col96.
        lw_entity-vbkdhreze   = lw_data-col97.
        lw_entity-vbrkvbeln   = lw_data-col98.
        lw_entity-vbrkfkdat   = lw_data-col99.
        lw_entity-vbrkfkart   = lw_data-col100.
        lw_entity-vbrkfktyp   = lw_data-col101.
        lw_entity-vbrkgjahr   = lw_data-col102.
        lw_entity-vbrkpoper   = lw_data-col103.
        lw_entity-vbrkkonda   = lw_data-col104.
        lw_entity-vbrkkdgrp   = lw_data-col105.
        lw_entity-vbrkpltyp   = lw_data-col106.
        lw_entity-vbrkinco1   = lw_data-col107.
        lw_entity-vbrkzterm   = lw_data-col108.
        lw_entity-vbrkzlsch   = lw_data-col109.
        lw_entity-vbrkktgrd   = lw_data-col110.
        lw_entity-vbrknetwr   = lw_data-col111.
        lw_entity-vbrkzukri   = lw_data-col112.
        lw_entity-vbrkernam   = lw_data-col113.
        lw_entity-vbrkerzet   = lw_data-col114.
        lw_entity-vbrkerdat   = lw_data-col115.
        lw_entity-vbrkkunrg   = lw_data-col116.
        lw_entity-vbrkstceg   = lw_data-col117.
        lw_entity-vbrksfakn   = lw_data-col118.
        lw_entity-vbrkkurst   = lw_data-col119.
        lw_entity-vbrkmschl   = lw_data-col120.
        lw_entity-vbrkzuonr   = lw_data-col121.
        lw_entity-vbrkmwsbk   = lw_data-col122.
        lw_entity-vbrkkidno   = lw_data-col123.
        lw_entity-vbrpvbeln   = lw_data-col124.
        lw_entity-vbrpposnr   = lw_data-col125.
        lw_entity-vbrpuepos   = lw_data-col126.
        lw_entity-vbrpnetwr   = lw_data-col127.
        lw_entity-vbrpkzwi1   = lw_data-col128.
        lw_entity-vbrpkzwi2   = lw_data-col129.
        lw_entity-vbrpkzwi3   = lw_data-col130.
        lw_entity-vbrpkzwi4   = lw_data-col131.
        lw_entity-vbrpkzwi5   = lw_data-col132.
        lw_entity-vbrpkzwi6   = lw_data-col133.
        lw_entity-vbrpprctr   = lw_data-col134.
        lw_entity-vbrptxjcd   = lw_data-col135.
        lw_entity-vbakkvgr1   = lw_data-col136.
        lw_entity-vbakkvgr2   = lw_data-col137.
        lw_entity-vbakkvgr3   = lw_data-col138.
        lw_entity-vbakkvgr4   = lw_data-col139.
        lw_entity-vbakkvgr5   = lw_data-col140.
        lw_entity-vbakfaksk   = lw_data-col141.
        lw_entity-vbakvgbel           = lw_data-col142.
        lw_entity-vbakzzsfdccase      = lw_data-col143.
        lw_entity-vbakzzfice          = lw_data-col144.
        lw_entity-vbakzznoreturn      = lw_data-col145.
        lw_entity-vbakzzholdfrom      = lw_data-col146.
        lw_entity-vbakzzholdto        = lw_data-col147.
        lw_entity-vbakzzpromo         = lw_data-col148.
        lw_entity-vbakzzwhs           = lw_data-col149.
        lw_entity-vbakzzlicgrp        = lw_data-col150.
        lw_entity-vbakzuonr           = lw_data-col151.
        lw_entity-vbappstyv           = lw_data-col152.
        lw_entity-vbapmvgr1           = lw_data-col153.
        lw_entity-vbapmvgr2           = lw_data-col154.
        lw_entity-vbapmvgr3           = lw_data-col155.
        lw_entity-vbapmvgr4           = lw_data-col156.
        lw_entity-vbapmvgr5           = lw_data-col157.
        lw_entity-vbapmwsbp           = lw_data-col158.
        lw_entity-vbapzzpromo         = lw_data-col159.
        lw_entity-vbapzzrgcode        = lw_data-col160.
        lw_entity-vbapzzcancdate      = lw_data-col161.
        lw_entity-vbapzzartno         = lw_data-col162.
        lw_entity-vbapzzisbnlan       = lw_data-col163.
        lw_entity-vbapzzshpocanc      = lw_data-col164.
        lw_entity-vbapzzsubtyp        = lw_data-col165.
        lw_entity-vbapzzvyp           = lw_data-col166.
        lw_entity-vbapzzaccessmech    = lw_data-col167.
        lw_entity-vbapzzconstart      = lw_data-col168.
        lw_entity-vbapzzconend        = lw_data-col169.
        lw_entity-vbapzzlicstart      = lw_data-col170.
        lw_entity-vbapzzlicend        = lw_data-col171.
        lw_entity-vbukbuchk           = lw_data-col172.
        lw_entity-vbkdbsark           = lw_data-col173.
        lw_entity-vbkdihrez           = lw_data-col174.
        lw_entity-vbkdkonda           = lw_data-col175.
        lw_entity-vbkdkdkg2           = lw_data-col176.
        lw_entity-vbakbname           = lw_data-col177.
        lw_entity-knvvzzfte           = lw_data-col178.
        lw_entity-spaddrnumber        = lw_data-col179.
        lw_entity-spemail             = lw_data-col180.
        lw_entity-spstreet            = lw_data-col181.
        lw_entity-spstreet2           = lw_data-col182.
        lw_entity-spcity              = lw_data-col183.
        lw_entity-spregion            = lw_data-col184.
        lw_entity-sppostal            = lw_data-col185.
        lw_entity-spcountry           = lw_data-col186.
        lw_entity-shipto              = lw_data-col187.
        lw_entity-shiptoname1         = lw_data-col188.
        lw_entity-shiptoname2         = lw_data-col189.
        lw_entity-shstreet            = lw_data-col190.
        lw_entity-shstreet2           = lw_data-col191.
        lw_entity-shcity              = lw_data-col192.
        lw_entity-shregion            = lw_data-col193.
        lw_entity-shpostal            = lw_data-col194.
        lw_entity-shcountry           = lw_data-col195.
        lw_entity-shipemail           = lw_data-col196.
        lw_entity-mediatype           = lw_data-col197.
        lw_entity-tdline              = lw_data-col198.
        lw_entity-vbpalifnr           = lw_data-col199.
        lw_entity-fwname              = lw_data-col200.
        lw_entity-fwstreet            = lw_data-col201.
        lw_entity-fwcity              = lw_data-col202.
        lw_entity-fwpostal            = lw_data-col203.
        lw_entity-fwcountry           = lw_data-col204.
        lw_entity-crstatus            = lw_data-col205.
        lw_entity-crdesc              = lw_data-col206.
        lw_entity-billdesc            = lw_data-col207.
        lw_entity-paidstatus          = lw_data-col208.
        lw_entity-creditlimit         = lw_data-col209.
        lw_entity-soldtoname2         = lw_data-col210.
        lw_entity-vbkdzlsch           = lw_data-col211.
        lw_entity-vbapkdmat           = lw_data-col212.


        APPEND lw_entity TO et_entityset.
        CLEAR: lw_data, lw_entity.

      ENDLOOP.

      SORT et_entityset BY vbeln posnr.
      DELETE et_entityset WHERE vbeln EQ space AND posnr IS INITIAL.
    ENDIF.
    CALL FUNCTION 'LIST_FREE_MEMORY'.


  ENDMETHOD.


METHOD va45_allitemsset_get_entityset.

  DATA : lst_filter TYPE /iwbep/s_mgw_select_option,
         li_vbeln   TYPE /iwbep/t_cod_select_options.

  DATA : lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va45_allitems.

  DATA : lv_host    TYPE string,
         lv_port    TYPE string,
         lw_linkref TYPE string.

  CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

  DATA : lv_uname TYPE sy-uname.
  DATA : lr_vkorg TYPE sd_vkorg_ranges.
*    DATA : lt_selection TYPE TABLE OF rsparams,
*           lw_selection LIKE LINE OF  lt_selection.

  lv_uname = sy-uname.


  CALL FUNCTION 'ZQTC_AUTH_SALESORG'
    EXPORTING
      im_uname = lv_uname
    TABLES
      et_vkorg = lr_vkorg.


  LOOP AT it_filter_select_options INTO lst_filter.
    CASE lst_filter-property.
      WHEN 'VBELN'.
        li_vbeln = lst_filter-select_options.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
    CLEAR lst_filter.
  ENDLOOP.


  cl_http_server=>if_http_server~get_location(
    IMPORTING host = lv_host
              port = lv_port ).


  SELECT vbeln, posnr, matnr,
          matkl, uepos, arktx,
          pstyv,  abgru, netwr,
          waerk, zmeng, vrkme,
          brgew, ntgew, gewei,
          netpr, kpein, kmein,
          mvgr1
        FROM vbap
        INTO TABLE @DATA(lt_vbap)
        WHERE vbeln IN @li_vbeln.
  IF sy-subrc EQ 0.
    SORT lt_vbap BY vbeln.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.

    SELECT abgru, bezei
        FROM tvagt
        INTO TABLE @DATA(lt_tvagt)
        FOR ALL ENTRIES IN @lt_vbap
       WHERE spras = @sy-langu
        AND abgru EQ @lt_vbap-abgru.
    IF sy-subrc = 0.
    ENDIF.

    SELECT vbeln, vposn, vbegdat, venddat
        FROM veda
       INTO TABLE @DATA(lt_veda)
        FOR ALL ENTRIES IN @lt_vbap
        WHERE vbeln EQ @lt_vbap-vbeln AND
         vposn EQ @lt_vbap-posnr AND
         vposn NE '000000'.
    IF sy-subrc = 0.
    ENDIF.

    SELECT vbeln, posnr, konda,kdgrp, bzirk,
        bstkd, bsark, ihrez, ihrez_e
       FROM vbkd
       INTO TABLE @DATA(lt_vbkd)
       FOR ALL ENTRIES IN @lt_vbap
       WHERE vbeln EQ @lt_vbap-vbeln AND
       posnr EQ @lt_vbap-posnr.
    IF sy-subrc = 0.
      SORT lt_vbap BY vbeln posnr.

      LOOP AT lt_vbap INTO DATA(lw_vbap) WHERE vbeln IS NOT INITIAL.

        READ TABLE lt_veda INTO DATA(lw_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-vbegdat = lw_veda-vbegdat.
          lw_entity-venddat = lw_veda-venddat.
        ENDIF.

        READ TABLE lt_vbkd INTO DATA(lw_vbkd) WITH KEY vbeln = lw_vbap-vbeln posnr = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-konda = lw_vbkd-konda.
          lw_entity-kdgrp = lw_vbkd-kdgrp.
          lw_entity-bzirk = lw_vbkd-bzirk.
          lw_entity-bstkd = lw_vbkd-bstkd.
          lw_entity-bsark = lw_vbkd-bsark.
          lw_entity-ihrez = lw_vbkd-ihrez.
          lw_entity-ihreze = lw_vbkd-ihrez_e.
        ENDIF.

        lw_entity-vbeln = lw_vbap-vbeln.
        lw_entity-posnr = lw_vbap-posnr.
        lw_entity-matnr = lw_vbap-matnr.
        lw_entity-matkl = lw_vbap-matkl.
        lw_entity-uepos = lw_vbap-uepos.
        lw_entity-arktx = lw_vbap-arktx.
        lw_entity-pstyv = lw_vbap-pstyv.
        lw_entity-netwr = lw_vbap-netwr.
        lw_entity-waerk = lw_vbap-waerk.
        lw_entity-kwmeng = lw_vbap-zmeng.
        lw_entity-vrkme = lw_vbap-vrkme.
        lw_entity-brgew = lw_vbap-brgew.
        lw_entity-ntgew = lw_vbap-ntgew.
        lw_entity-gewei = lw_vbap-gewei.
        lw_entity-netpr = lw_vbap-netpr.
        lw_entity-kmein = lw_vbap-kmein.
        lw_entity-kpein = lw_vbap-kpein.
        lw_entity-mvgr1 = lw_vbap-mvgr1.
        lw_entity-abgru = lw_vbap-abgru.

        READ TABLE lt_tvagt INTO DATA(lw_tvagt) WITH KEY abgru = lw_vbap-abgru.
        IF sy-subrc EQ 0.
          lw_entity-abgrut = lw_tvagt-bezei.
        ENDIF.

        CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_entity-vbeln INTO lw_linkref.
        lw_entity-link = lw_linkref.

        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.

      ENDLOOP.

    ENDIF.

  ENDIF.

ENDMETHOD.


METHOD va45_rejectitems_get_entityset.

  DATA : lst_filter TYPE /iwbep/s_mgw_select_option,
         lv_vbeln   TYPE /iwbep/t_cod_select_options.

  DATA : lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va45_rejectitems.

  DATA : lv_host    TYPE string,
         lv_port    TYPE string,
         lw_linkref TYPE string.

  CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

  DATA : lv_uname TYPE sy-uname.
  DATA : lr_vkorg TYPE sd_vkorg_ranges.
  DATA : lt_selection TYPE TABLE OF rsparams,
         lw_selection LIKE LINE OF  lt_selection.

  lv_uname = sy-uname.

  CALL FUNCTION 'ZQTC_AUTH_SALESORG'
    EXPORTING
      im_uname = lv_uname
    TABLES
      et_vkorg = lr_vkorg.

  LOOP AT it_filter_select_options INTO lst_filter.
    CASE lst_filter-property.
      WHEN 'VBELN'.
        lv_vbeln = lst_filter-select_options.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
    CLEAR lst_filter.
  ENDLOOP.

  cl_http_server=>if_http_server~get_location(
  IMPORTING host = lv_host
            port = lv_port ).


  SELECT vbeln, posnr, matnr,matkl, uepos, arktx,
          pstyv,  abgru, netwr, waerk, zmeng, vrkme,
          brgew, ntgew, gewei,netpr, kpein, kmein,mvgr1
         FROM vbap
         INTO TABLE @DATA(lt_vbap)
         WHERE vbeln IN @lv_vbeln AND
               abgru NE ' '.

  IF sy-subrc EQ 0.
    SORT lt_vbap BY vbeln.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.

    SELECT abgru, bezei
           FROM tvagt
           INTO TABLE @DATA(lt_tvagt)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE spras = @sy-langu AND
                 abgru EQ @lt_vbap-abgru.
    IF sy-subrc = 0.
    ENDIF.


    SELECT vbeln, vposn,  vbegdat, venddat
           FROM veda
           INTO TABLE @DATA(lt_veda)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE vbeln EQ @lt_vbap-vbeln AND
                 vposn EQ @lt_vbap-posnr .
    IF sy-subrc = 0.
    ENDIF.

    SELECT vbeln, posnr, konda,kdgrp,
           bzirk, bstkd, bsark, ihrez, ihrez_e
           FROM vbkd
           INTO TABLE @DATA(lt_vbkd)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE vbeln EQ @lt_vbap-vbeln AND
                 posnr EQ @lt_vbap-posnr.
    IF sy-subrc = 0.
      SORT lt_vbap BY vbeln posnr.

      LOOP AT lt_vbap INTO DATA(lw_vbap) WHERE vbeln IS NOT INITIAL.
        READ TABLE lt_veda INTO DATA(lw_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-vbegdat = lw_veda-vbegdat.
          lw_entity-venddat = lw_veda-venddat.
        ENDIF.
        READ TABLE lt_vbkd INTO DATA(lw_vbkd) WITH KEY vbeln = lw_vbap-vbeln posnr = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-konda  = lw_vbkd-konda.
          lw_entity-kdgrp  = lw_vbkd-kdgrp.
          lw_entity-bzirk  = lw_vbkd-bzirk.
          lw_entity-bstkd  = lw_vbkd-bstkd.
          lw_entity-bsark  = lw_vbkd-bsark.
          lw_entity-ihrez  = lw_vbkd-ihrez.
          lw_entity-ihreze = lw_vbkd-ihrez_e.
        ENDIF.
        lw_entity-vbeln  = lw_vbap-vbeln.
        lw_entity-posnr  = lw_vbap-posnr.
        lw_entity-matnr  = lw_vbap-matnr.
        lw_entity-matkl  = lw_vbap-matkl.
        lw_entity-uepos  = lw_vbap-uepos.
        lw_entity-arktx  = lw_vbap-arktx.
        lw_entity-pstyv  = lw_vbap-pstyv.
        lw_entity-abgru  = lw_vbap-abgru.
        lw_entity-netwr  = lw_vbap-netwr.
        lw_entity-waerk  = lw_vbap-waerk.
        lw_entity-kwmeng = lw_vbap-zmeng.
        lw_entity-vrkme  = lw_vbap-vrkme.
        lw_entity-brgew  = lw_vbap-brgew.
        lw_entity-ntgew  = lw_vbap-ntgew.
        lw_entity-gewei  = lw_vbap-gewei.
        lw_entity-netpr  = lw_vbap-netpr.
        lw_entity-kpein  = lw_vbap-kpein.
        lw_entity-kmein  = lw_vbap-kmein.
        lw_entity-mvgr1  = lw_vbap-mvgr1.

        READ TABLE lt_tvagt INTO DATA(lw_tvagt) WITH KEY abgru = lw_vbap-abgru.
        IF sy-subrc EQ 0.
          lw_entity-abgrut = lw_tvagt-bezei.
        ENDIF.
        CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_entity-vbeln INTO lw_linkref.
        lw_entity-link = lw_linkref.
        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDMETHOD.


  METHOD va45_sumset_get_entityset.
    DATA: textlines TYPE TABLE OF string.
    DATA:lv_report(3) TYPE c,
         lv_auart(4)  TYPE c,
         lr_auart     TYPE tms_t_auart_range,
         lr_auart2    TYPE tms_t_auart_range,
         lst_auart    TYPE tms_s_auart_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA lv_uname TYPE sy-uname.
    DATA:lr_vkorg TYPE sd_vkorg_ranges.

    DATA :lv_host    TYPE string,
          lv_port    TYPE string,
          lw_linkref TYPE string.
    CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

    TYPES: BEGIN OF ts_va45_sum,
             vbeln    TYPE vbeln_va,
             posnr    TYPE posnr_va,
             auart    TYPE c LENGTH 10,
             audat    TYPE c LENGTH 10,
             bstnk    TYPE c LENGTH 20,
             budat    TYPE c LENGTH 10,
             kunnr    TYPE c LENGTH 10,
             name1    TYPE c LENGTH 40,
             quantity TYPE c LENGTH 10,
             zeime    TYPE c LENGTH 10,
             netwr    TYPE c LENGTH 20,
             curr     TYPE c LENGTH 5,
             vkrme    TYPE c LENGTH 10,
             datuv    TYPE c LENGTH 10,
             ernam    TYPE c LENGTH 20,
             vtweg    TYPE c LENGTH 5,
             spart    TYPE c LENGTH 2,
             csdate   TYPE c LENGTH 10,
             cedate   TYPE c LENGTH 10,
             matnr    TYPE c LENGTH 20,
             linkref  TYPE string,
             angdt    TYPE c LENGTH 10,
             bnddt    TYPE c LENGTH 10,
           END OF ts_va45_sum .

    DATA: lt_sumdata TYPE STANDARD TABLE OF ts_va45_sum,
          lw_sumdata TYPE ts_va45_sum.

    TYPES: BEGIN OF ty_header,
             col1   TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
             col5   TYPE string,
             col6   TYPE string,
             col7   TYPE string,
             col8   TYPE string,
             col9   TYPE string,
             col10  TYPE string,
             col11  TYPE string,
             col12  TYPE string,
             col13  TYPE string,
             col14  TYPE string,
             col15  TYPE string,
             col16  TYPE string,
             col17  TYPE string,
             col18  TYPE string,
             col19  TYPE string,
             col20  TYPE string,
             col21  TYPE string,
             col22  TYPE string,
             col23  TYPE string,
             col24  TYPE string,
             col25  TYPE string,
             col26  TYPE string,
             col27  TYPE string,
             col28  TYPE string,
             col29  TYPE string,
             col30  TYPE string,
             col31  TYPE string,
             col32  TYPE string,
             col33  TYPE string,
             col34  TYPE string,
             col35  TYPE string,
             col36  TYPE string,
             col37  TYPE string,
             col38  TYPE string,
             col39  TYPE string,
             col40  TYPE string,
             col41  TYPE string,
             col42  TYPE string,
             col43  TYPE string,
             col44  TYPE string,
             col45  TYPE string,
             col46  TYPE string,
             col47  TYPE string,
             col48  TYPE string,
             col49  TYPE string,
             col50  TYPE string,
             col51  TYPE string,
             col52  TYPE string,
             col53  TYPE string,
             col54  TYPE string,
             col55  TYPE string,
             col56  TYPE string,
             col57  TYPE string,
             col58  TYPE string,
             col59  TYPE string,
             col60  TYPE string,
             col61  TYPE string,
             col62  TYPE string,
             col63  TYPE string,
             col64  TYPE string,
             col65  TYPE string,
             col66  TYPE string,
             col67  TYPE string,
             col68  TYPE string,
             col69  TYPE string,
             col70  TYPE string,
             col71  TYPE string,
             col72  TYPE string,
             col73  TYPE string,
             col74  TYPE string,
             col75  TYPE string,
             col76  TYPE string,
             col77  TYPE string,
             col78  TYPE string,
             col79  TYPE string,
             col80  TYPE string,
             col81  TYPE string,
             col82  TYPE string,
             col83  TYPE string,
             col84  TYPE string,
             col85  TYPE string,
             col86  TYPE string,
             col87  TYPE string,
             col88  TYPE string,
             col89  TYPE string,
             col90  TYPE string,
             col91  TYPE string,
             col92  TYPE string,
             col93  TYPE string,
             col94  TYPE string,
             col95  TYPE string,
             col96  TYPE string,
             col97  TYPE string,
             col98  TYPE string,
             col99  TYPE string,
             col100 TYPE string,
             col101 TYPE string,
             col102 TYPE string,
             col103 TYPE string,
             col104 TYPE string,
             col105 TYPE string,
             col106 TYPE string,
             col107 TYPE string,
             col108 TYPE string,
             col109 TYPE string,
             col110 TYPE string,
             col111 TYPE string,
             col112 TYPE string,
             col113 TYPE string,
             col114 TYPE string,
             col115 TYPE string,
             col116 TYPE string,
             col117 TYPE string,
             col118 TYPE string,
             col119 TYPE string,
             col120 TYPE string,
             col121	TYPE string,
             col122	TYPE string,
             col123	TYPE string,
             col124	TYPE string,
             col125	TYPE string,
             col126	TYPE string,
             col127	TYPE string,
             col128	TYPE string,
             col129	TYPE string,
             col130	TYPE string,
             col131	TYPE string,
             col132	TYPE string,
             col133	TYPE string,
             col134	TYPE string,
             col135	TYPE string,
             col136	TYPE string,
             col137	TYPE string,
             col138	TYPE string,
             col139	TYPE string,
             col140	TYPE string,
             col141	TYPE string,
             col142	TYPE string,
             col143	TYPE string,
             col144	TYPE string,
             col145	TYPE string,
             col146	TYPE string,
             col147	TYPE string,
             col148	TYPE string,
             col149	TYPE string,
             col150	TYPE string,
             col151	TYPE string,
             col152	TYPE string,
             col153	TYPE string,
             col154	TYPE string,
             col155	TYPE string,
             col156	TYPE string,
             col157	TYPE string,
             col158	TYPE string,
             col159	TYPE string,
             col160	TYPE string,
             col161	TYPE string,
             col162	TYPE string,
             col163	TYPE string,
             col164	TYPE string,
             col165	TYPE string,
             col166	TYPE string,
             col167	TYPE string,
             col168	TYPE string,
             col169	TYPE string,
             col170	TYPE string,
             col171	TYPE string,
             col172	TYPE string,
             col173	TYPE string,
             col174	TYPE string,
             col175	TYPE string,
             col176	TYPE string,
             col177	TYPE string,
             col178	TYPE string,
             col179	TYPE string,
             col180	TYPE string,
             col181	TYPE string,
             col182	TYPE string,
             col183	TYPE string,
             col184	TYPE string,
             col185	TYPE string,
             col186	TYPE string,
             col187	TYPE string,
             col188	TYPE string,
             col189	TYPE string,
             col190	TYPE string,
             col191	TYPE string,
             col192	TYPE string,
             col193	TYPE string,
             col194	TYPE string,
             col195	TYPE string,
             col196	TYPE string,
             col197	TYPE string,
             col198	TYPE string,
             col199	TYPE string,
             col200	TYPE string,
             col201	TYPE string,
             col202	TYPE string,
             col203	TYPE string,
             col204	TYPE string,
             col205	TYPE string,
             col206	TYPE string,
             col207	TYPE string,
             col208	TYPE string,
             col209	TYPE string,
             col210	TYPE string,
             col211	TYPE string,
             col212	TYPE string,
           END OF ty_header.

    DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
          lw_data      TYPE ty_header,
          lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          lw_entity    TYPE zcl_zqtc_va_rep_mpc=>ts_va45_sum.
*    DATA: lt_vbap TYPE STANDARD TABLE OF vbap,
*          lw_vbap TYPE vbap.

    DATA: lv_low TYPE sy-datum.
    DATA:lv_flag(4) TYPE c.
* Fetch user authorized Sales Orgs
    lv_uname = sy-uname.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'AUART'.  "Passing Sales Document Type
            lv_auart = <ls_filter_opt>-low+0(4).
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = 'I'.
              lst_auart-option = 'EQ'.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart2.
              CLEAR:lst_auart.
            ENDIF.
          WHEN 'FLAG'.
            lv_flag = <ls_filter_opt>-low+0(4).
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    CLEAR: lt_selection[].

    lv_low = sy-datum - 30.
    "------------------------------------
    lw_selection-selname = 'SERDAT'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'VALIDITY'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSUB'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZSBP'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lw_selection-selname = 'AUART'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'EQ'.
    lw_selection-low     = 'ZREW'.
*    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.

    lv_low = sy-datum - 90.

    lw_selection-selname = 'SVALID'.
    lw_selection-kind    = 'S'.
    lw_selection-sign    = 'I'.
    lw_selection-option  = 'BT'.
    lw_selection-low     = lv_low.
    lw_selection-high     = sy-datum.
    APPEND lw_selection TO lt_selection.
    CLEAR lw_selection.
* Fill authorized Sales Orgs to submit to report
    LOOP AT lr_vkorg INTO DATA(ls_vkorg).
      lw_selection-selname = 'SVKORG'.
      lw_selection-kind    = 'S'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = 'EQ'.
      lw_selection-low     = ls_vkorg-low.
      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.
    ENDLOOP.

    IF lv_flag EQ 'Key2'.

      SUBMIT sd_sales_document_va45
             WITH SELECTION-TABLE lt_selection
             EXPORTING LIST TO MEMORY AND RETURN.
*
      DATA:list TYPE STANDARD TABLE OF abaplist.

*  data: list like abaplist occurs 0 with header line.
*    DATA: txtlines TYPE TABLE OF char2048.
      DATA: txtlines TYPE TABLE OF text4096.

      CALL FUNCTION 'LIST_FROM_MEMORY'
        TABLES
          listobject = list
        EXCEPTIONS
          not_found  = 1
          OTHERS     = 2.
*
      IF sy-subrc EQ 0.

        CALL FUNCTION 'LIST_TO_ASCI'
          EXPORTING
            list_index         = -1
*           WITH_LINE_BREAK    = ' '
          TABLES
            listasci           = txtlines        "lt_out
            listobject         = list
          EXCEPTIONS
            empty_list         = 1
            list_index_invalid = 2
            OTHERS             = 3.
*
        LOOP AT txtlines INTO DATA(ls_text).
          ls_text+0(1) = ''.
          IF sy-tabix > 4.
            SPLIT ls_text AT '|' INTO
            lw_data-col1
            lw_data-col2
            lw_data-col3
            lw_data-col4
            lw_data-col5
            lw_data-col6
            lw_data-col7
            lw_data-col8
            lw_data-col9
            lw_data-col10
            lw_data-col11
            lw_data-col12
            lw_data-col13
            lw_data-col14
            lw_data-col15
            lw_data-col16
            lw_data-col17
            lw_data-col18
            lw_data-col19
            lw_data-col20
            lw_data-col21
            lw_data-col22
            lw_data-col23
            lw_data-col24
            lw_data-col25
            lw_data-col26
            lw_data-col27
            lw_data-col28
            lw_data-col29
            lw_data-col30
            lw_data-col31
            lw_data-col32
            lw_data-col33
            lw_data-col34
            lw_data-col35
            lw_data-col36
            lw_data-col37
            lw_data-col38
            lw_data-col39
            lw_data-col40
            lw_data-col41
            lw_data-col42
            lw_data-col43
            lw_data-col44
            lw_data-col45
            lw_data-col46
            lw_data-col47
            lw_data-col48
            lw_data-col49
            lw_data-col50
            lw_data-col51
            lw_data-col52
            lw_data-col53
            lw_data-col54
            lw_data-col55
            lw_data-col56
            lw_data-col57
            lw_data-col58
            lw_data-col59
            lw_data-col60
            lw_data-col61
            lw_data-col62
            lw_data-col63
            lw_data-col64
            lw_data-col65
            lw_data-col66
            lw_data-col67
            lw_data-col68
            lw_data-col69
            lw_data-col70
            lw_data-col71
            lw_data-col72
            lw_data-col73
            lw_data-col74
            lw_data-col75
            lw_data-col76
            lw_data-col77
            lw_data-col78
            lw_data-col79
            lw_data-col80
            lw_data-col81
            lw_data-col82
            lw_data-col83
            lw_data-col84
            lw_data-col85
            lw_data-col86
            lw_data-col87
            lw_data-col88
            lw_data-col89
            lw_data-col90
            lw_data-col91
            lw_data-col92
            lw_data-col93
            lw_data-col94
            lw_data-col95
            lw_data-col96
            lw_data-col97
            lw_data-col98
            lw_data-col99
            lw_data-col100
            lw_data-col101
            lw_data-col102
            lw_data-col103
            lw_data-col104
            lw_data-col105
            lw_data-col106
            lw_data-col107
            lw_data-col108
            lw_data-col109
            lw_data-col110
            lw_data-col111
            lw_data-col112
            lw_data-col113
            lw_data-col114
            lw_data-col115
            lw_data-col116
            lw_data-col117
            lw_data-col118
            lw_data-col119
            lw_data-col120
            lw_data-col121
            lw_data-col122
            lw_data-col123
            lw_data-col124
            lw_data-col125
            lw_data-col126
            lw_data-col127
            lw_data-col128
            lw_data-col129
            lw_data-col130
            lw_data-col131
            lw_data-col132
            lw_data-col133
            lw_data-col134
            lw_data-col135
            lw_data-col136
            lw_data-col137
            lw_data-col138
            lw_data-col139
            lw_data-col140
            lw_data-col141
            lw_data-col142
            lw_data-col143
            lw_data-col144
            lw_data-col145
            lw_data-col146
            lw_data-col147
            lw_data-col148
            lw_data-col149
            lw_data-col150
            lw_data-col151
            lw_data-col152
            lw_data-col153
            lw_data-col154
            lw_data-col155
            lw_data-col156
            lw_data-col157
            lw_data-col158
            lw_data-col159
            lw_data-col160
            lw_data-col161
            lw_data-col162
            lw_data-col163
            lw_data-col164
            lw_data-col165
            lw_data-col166
            lw_data-col167
            lw_data-col168
            lw_data-col169
            lw_data-col170
            lw_data-col171
            lw_data-col172
            lw_data-col173
            lw_data-col174
            lw_data-col175
            lw_data-col176
            lw_data-col177
            lw_data-col178
            lw_data-col179
            lw_data-col180
            lw_data-col181
            lw_data-col182
            lw_data-col183
            lw_data-col184
            lw_data-col185
            lw_data-col186
            lw_data-col187
            lw_data-col188
            lw_data-col189
            lw_data-col190
            lw_data-col191
            lw_data-col192
            lw_data-col193
            lw_data-col194
            lw_data-col195
            lw_data-col196
            lw_data-col197
            lw_data-col198
            lw_data-col199
            lw_data-col200
            lw_data-col201
            lw_data-col202
            lw_data-col203
            lw_data-col204
            lw_data-col205
            lw_data-col206
            lw_data-col207
            lw_data-col208
            lw_data-col209
            lw_data-col210
            lw_data-col211
            lw_data-col212.
            APPEND lw_data TO lt_data.
            CLEAR: lw_data, lw_entity.
          ENDIF.
        ENDLOOP.

        DATA: lw_sum      TYPE dmbtr,
              lw_netwr    TYPE char20,
              lw_quantity TYPE menge_d,
              lw_rejquan  TYPE menge_d,
              lw_rejsum   TYPE dmbtr,
              lw_rejitems TYPE i.

        FREE lt_sumdata.
        CLEAR lw_sumdata.

        cl_http_server=>if_http_server~get_location(
          IMPORTING host = lv_host
                    port = lv_port ).

        LOOP AT lt_data INTO lw_data.
          lw_sumdata-vbeln       = lw_data-col3.   "Object Type
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lw_sumdata-vbeln
            IMPORTING
              output = lw_sumdata-vbeln.
          lw_sumdata-posnr       = lw_data-col5.
          lw_sumdata-auart       = lw_data-col4.   "Object
          lw_sumdata-audat       = lw_data-col2.
          lw_sumdata-bstnk       = lw_data-col1.
*        lw_sumdata-budat       = lw_data-col1.  "Purchase order number
          lw_sumdata-kunnr       = lw_data-col10.
          lw_sumdata-quantity    = lw_data-col7.
          lw_sumdata-netwr       = lw_data-col11.
          lw_sumdata-curr        = lw_data-col12.
          lw_sumdata-vkrme       = lw_data-col8.
          lw_sumdata-datuv       = lw_data-col9.
          lw_sumdata-ernam       = lw_data-col13.
          lw_sumdata-vtweg       = lw_data-col14.
          lw_sumdata-csdate      = lw_data-col15.
          lw_sumdata-cedate       = lw_data-col16.
          lw_sumdata-matnr     = lw_data-col6.
          APPEND lw_sumdata TO lt_sumdata.
          CLEAR lw_sumdata.
        ENDLOOP.
        SORT lt_sumdata BY vbeln.
        IF lt_sumdata IS NOT INITIAL.
          SELECT kunnr,name1 FROM kna1 INTO TABLE @DATA(lt_kna1)
                      FOR ALL ENTRIES IN @lt_sumdata
           WHERE kunnr EQ @lt_sumdata-kunnr.
          IF sy-subrc = 0.
            SORT lt_kna1 BY kunnr.
          ENDIF.
          SELECT vbeln,
                 posnr,
                 abgru,
                 zmeng,
                 zieme,
                 netwr
            FROM vbap
            INTO TABLE @DATA(lt_vbap)
            FOR ALL ENTRIES IN @lt_sumdata
           WHERE vbeln EQ @lt_sumdata-vbeln
             AND posnr EQ @lt_sumdata-posnr.
          IF  sy-subrc IS INITIAL.
            SELECT abgru, bezei
               FROM tvagt
               INTO TABLE @DATA(lt_tvagt)
               FOR ALL ENTRIES IN @lt_vbap
              WHERE spras = @sy-langu
               AND abgru EQ @lt_vbap-abgru.
            IF sy-subrc = 0.
            ENDIF.
          ENDIF.

          SELECT vbeln,
                 auart,
                 vkorg,
                 vtweg,
                 vkbur,
                 faksk,
                 erdat,
                 spart
            FROM vbak
            INTO TABLE @DATA(lt_vbak)
             FOR ALL ENTRIES IN @lt_sumdata
           WHERE vbeln EQ @lt_sumdata-vbeln.
          IF sy-subrc IS INITIAL.

          ENDIF.
*   begin of change1
          SELECT vbeln, ihrez_e
            FROM vbkd
            INTO TABLE @DATA(lt_vbkd)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln
            AND posnr EQ @lt_sumdata-posnr.
          IF sy-subrc IS INITIAL.
          ENDIF.
          SELECT vbeln, gbstk
            FROM vbuk
            INTO TABLE @DATA(lt_vbuk)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln.
          IF sy-subrc IS INITIAL.
          ENDIF.
          SELECT vbeln, adrnr FROM vbpa
            INTO TABLE @DATA(lt_vbpa)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln.
          IF sy-subrc IS INITIAL.
            SELECT addrnumber, name1 FROM adrc
              INTO TABLE @DATA(lt_adrc)
           FOR ALL ENTRIES IN @lt_vbpa
           WHERE addrnumber EQ @lt_vbpa-adrnr.
            IF sy-subrc IS INITIAL.
            ENDIF.
          ENDIF.
*    end of change1
          CLEAR lw_sumdata.
          LOOP AT lt_sumdata
            INTO lw_sumdata.
            READ TABLE lt_vbap
              INTO DATA(lw_vbap)
              WITH KEY vbeln = lw_sumdata-vbeln
                       posnr = lw_sumdata-posnr.
            IF  sy-subrc IS INITIAL.
*          AND lw_vbap-abgru IS INITIAL.
              IF lw_vbap-abgru IS INITIAL.
                ADD lw_sumdata-quantity TO lw_quantity.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-netwr WITH ' '.
                CONDENSE lw_sumdata-netwr.
                ADD lw_sumdata-netwr TO lw_sum.
              ENDIF.
              IF lw_vbap-abgru IS NOT INITIAL.
                lw_entity-abgru = lw_vbap-abgru.
                READ TABLE lt_tvagt INTO DATA(lw_tvagt) WITH KEY abgru = lw_vbap-abgru.
                IF sy-subrc EQ 0.
                  lw_entity-abgrut = lw_tvagt-bezei.
                ENDIF.
                ADD 1 TO lw_rejitems.
                ADD lw_sumdata-quantity TO lw_rejquan.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-netwr WITH ' '.
                CONDENSE lw_sumdata-netwr.
                ADD lw_sumdata-netwr TO lw_rejsum.
              ENDIF.
              AT END OF vbeln.
                READ TABLE lt_sumdata
                  INTO DATA(lw_sumdata1)
                  WITH KEY vbeln = lw_sumdata-vbeln.
                IF sy-subrc IS INITIAL.
                  lw_entity-vbeln    = lw_sumdata1-vbeln.
                  lw_entity-auart    = lw_sumdata1-auart.
                  lw_entity-audat    = lw_sumdata1-audat.
                  lw_entity-bstnk    = lw_sumdata1-bstnk.
                  lw_entity-budat    = lw_sumdata1-budat.
                  lw_entity-kunnr    = lw_sumdata1-kunnr.
                  lw_entity-quantity = lw_quantity.
*                  lw_entity-zeime    = lw_vbap-zieme.
                  lw_entity-netwr    = lw_sum.
                  lw_entity-curr     = lw_sumdata1-curr.
                  lw_entity-posnr    = lw_sumdata1-posnr.
                  READ TABLE lt_vbak
                    INTO DATA(lw_vbak)
                    WITH KEY vbeln = lw_sumdata1-vbeln.
                  IF sy-subrc IS INITIAL.
                    lw_entity-vkorg    = lw_vbak-vkorg.
                    lw_entity-vtweg    = lw_vbak-vtweg.
                    lw_entity-spart    = lw_vbak-spart.
                    lw_entity-vkbur    = lw_vbak-vkbur.
                    lw_entity-faksk    = lw_vbak-faksk.
                    lw_entity-erdat    = lw_vbak-erdat.
                  ENDIF.
*                begin of change1
                  READ TABLE lt_vbkd
                    INTO DATA(lw_vbkd)
                    WITH KEY vbeln = lw_sumdata1-vbeln.
                  IF sy-subrc IS INITIAL.
                    lw_entity-ihreze  = lw_vbkd-ihrez_e.
                  ENDIF.
                  READ TABLE lt_vbuk
                    INTO DATA(lw_vbuk)
                    WITH KEY vbeln = lw_sumdata1-vbeln.
                  IF sy-subrc IS INITIAL.
                    lw_entity-gbstk  = lw_vbuk-gbstk.
                    IF lw_entity-gbstk = 'A'.
                      lw_entity-gbstkt = 'Not yet processed'.
                    ELSEIF lw_entity-gbstk = 'B'.
                      lw_entity-gbstkt = 'Partially processed'.
                    ELSEIF lw_entity-gbstk = 'C'.
                      lw_entity-gbstkt = 'Completely processed'.
                    ELSE.
                      lw_entity-gbstkt = 'Not Relevant'.
                    ENDIF.
                  ENDIF.
                  READ TABLE lt_vbpa
                    INTO DATA(lw_vbpa)
                    WITH KEY vbeln = lw_sumdata1-vbeln.
                  lw_entity-adrnr = lw_vbpa-adrnr.
                  IF sy-subrc IS INITIAL.
                    READ TABLE lt_adrc
                     INTO DATA(lw_adrc)
                     WITH KEY addrnumber = lw_vbpa-adrnr.
                    IF sy-subrc IS INITIAL.
                      lw_entity-adrcname = lw_adrc-name1.
                    ENDIF.
                  ENDIF.

*                 end of change1
                  READ TABLE lt_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lw_entity-kunnr BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lw_entity-name1 = lst_kna1-name1.
                  ENDIF.
                  lw_entity-vkrme    = lw_sumdata1-vkrme.
                  lw_entity-datuv    = lw_sumdata1-datuv.
                  lw_entity-ernam    = lw_sumdata1-ernam.

                  lw_entity-csdate   = lw_sumdata1-csdate.
                  lw_entity-cedate   = lw_sumdata1-cedate.
*                  lw_entity-matnr    = lw_sumdata1-matnr.
                  lw_entity-rejamount  = lw_rejsum.
                  lw_entity-rejquan    = lw_rejquan.
                  lw_entity-rejitems   = lw_rejitems.
                  CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_sumdata1-vbeln INTO lw_linkref.
                  lw_entity-linkref    = lw_linkref.
                  lw_entity-angdt = lv_low.
                  lw_entity-bnddt = sy-datum.
                  APPEND lw_entity TO et_entityset.
                  CLEAR: lw_entity, lw_sum,lw_quantity, lw_sumdata,lw_rejsum, lw_rejquan,
                         lw_rejitems, lw_linkref.
                ENDIF.
              ENDAT.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CALL FUNCTION 'LIST_FREE_MEMORY'.
    ENDIF.
  ENDMETHOD.


  METHOD zfieldsset_get_entityset.
    DATA:lv_tcode        TYPE sy-tcode.
    DATA:lst_const TYPE zcl_zqtc_va_rep_mpc=>ts_zfields.

    CONSTANTS: lc_devid TYPE zdevid      VALUE 'ZVA' .
    CONSTANTS: lc_param1 TYPE rvari_vnam      VALUE 'Param1' .

    FIELD-SYMBOLS: <ls_filter>     LIKE LINE OF it_filter_select_options,
                   <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN lc_param1.
            lv_tcode = <ls_filter_opt>-low.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF    lv_tcode IS NOT INITIAL.
* Get TCode selection screen fields
      SELECT  * FROM zcaconstant
       INTO TABLE @DATA(li_constants)
       WHERE devid = @lc_devid
         AND param1 = @lv_tcode
         AND activate = @abap_true
         AND high NE @space.
      IF sy-subrc EQ 0.

        LOOP AT li_constants INTO DATA(lst_constants).
          CLEAR:lst_const.
          lst_const-devid = lst_constants-devid .
          lst_const-param1 = lst_constants-param1.
          lst_const-param2 = lst_constants-param2.
          lst_const-sign   = lst_constants-sign.
          lst_const-opti = lst_constants-opti.
          lst_const-low    = lst_constants-low.
          lst_const-high    = lst_constants-high.
          lst_const-description    = lst_constants-description.
          APPEND lst_const TO et_entityset.
          CLEAR lst_const.
        ENDLOOP.
        SORT et_entityset BY high low .
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
