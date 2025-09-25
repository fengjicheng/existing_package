*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_FETCH_DATA_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: Fetch additional data
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*
TYPES : BEGIN OF  ty_quantity,                         " Summarized quantity data
          vbeln TYPE jksesched-vbeln,
          posnr TYPE jksesched-posnr,
          qty   TYPE p LENGTH 16 DECIMALS 3,
        END OF ty_quantity.

TYPES : BEGIN OF ty_identitycodetype,                     " Identity code range declaration
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE ismidcodetype,
          high TYPE ismidcodetype,
        END OF ty_identitycodetype.

DATA : lis_quantity           TYPE SORTED TABLE OF ty_quantity WITH UNIQUE KEY vbeln posnr INITIAL SIZE 0,   " Sorted table for LIne item total quantity
       li_identity_code_type  TYPE STANDARD TABLE OF ty_identitycodetype INITIAL SIZE 0,
       lst_quantity           TYPE ty_quantity,
       lst_identity_code_type TYPE ty_identitycodetype,
       li_other_record        TYPE STANDARD TABLE OF t_detail.

DATA : lv_block_2 TYPE char120,
       lv_block_1 TYPE char120.

DATA : li_split        TYPE TABLE OF char40,
       lst_split       TYPE char40,
       lv_found        TYPE char01,
       lv_sdata        TYPE string,
       lv_shi_mode     TYPE string,
       lv_distribution TYPE string,
       lv_plant        TYPE string,
       lv_postal       TYPE string,
       lv_country      TYPE string,
       lv_len          TYPE i,
       lv_postal_found TYPE char01,
       lv_split        TYPE char01,
       lv_detail_index TYPE sy-tabix.

FIELD-SYMBOLS : <detail_item> TYPE t_detail.

CONSTANTS : lc_devid  TYPE zdevid     VALUE 'R112',
            lc_idcode TYPE rvari_vnam VALUE 'IDCODETYPE'.


SELECT devid,                           " Development ID
       param1,                          " ABAP: Name of Variant Variable
       param2,                          " ABAP: Name of Variant Variable
       srno,                            " Current selection number
       sign,                            " ABAP: ID: I/E (include/exclude values)
       opti,                            " ABAP: Selection option (EQ/BT/CP/...)
       low,                             " Lower Value of Selection Condition
       high,                            " Upper Value of Selection Condition
       activate                         " Activation indicator for constant
       FROM zcaconstant                 " Wiley Application Constant Table
       INTO TABLE @DATA(li_constant)
       WHERE devid    = @lc_devid
       AND   activate = @abap_true.      " Only active record
IF sy-subrc IS INITIAL.
  SORT li_constant BY param1.

  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_idcode.                                       " Check identity code
        lst_identity_code_type-sign = <lfs_constant>-sign.
        lst_identity_code_type-opti = <lfs_constant>-opti.
        lst_identity_code_type-low  = <lfs_constant>-low.
        lst_identity_code_type-high = <lfs_constant>-high.
        APPEND lst_identity_code_type TO li_identity_code_type.
        CLEAR lst_identity_code_type.
    ENDCASE.
  ENDLOOP.

ENDIF.

" Copy standard detail data to custom table to further process
DATA(li_detail) = detail_tab[].
SORT li_detail BY contract item issue.
DELETE ADJACENT DUPLICATES FROM li_detail COMPARING contract item issue.

IF li_detail IS NOT INITIAL.

  SELECT vbeln,posnr,matnr,netwr,waerk
    FROM vbap INTO TABLE @DATA(li_vbap)
    FOR ALL ENTRIES IN @li_detail
    WHERE vbeln = @li_detail-contract AND
          posnr = @li_detail-item.
  IF sy-subrc = 0.
    SORT li_vbap BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING vbeln posnr.

    " Fetch total media issue quantity from schedule line
    SELECT vbeln,posnr,issue,product,sequence,quantity
      FROM jksesched INTO TABLE @DATA(li_jksesched)
      FOR ALL ENTRIES IN @li_vbap
      WHERE vbeln = @li_vbap-vbeln AND
            posnr = @li_vbap-posnr.
    IF sy-subrc = 0.
      SORT li_jksesched BY vbeln posnr.

      " Summarized Quantity for Sales doc and line item
      LOOP AT li_jksesched ASSIGNING FIELD-SYMBOL(<lfs_jksesched>).
        lst_quantity-vbeln = <lfs_jksesched>-vbeln.
        lst_quantity-posnr = <lfs_jksesched>-posnr.
        lst_quantity-qty = <lfs_jksesched>-quantity.

        COLLECT lst_quantity INTO lis_quantity.
        CLEAR lst_quantity.
      ENDLOOP.
    ENDIF.
  ENDIF.

  " fecth identity code for media issue
  SELECT matnr,idcodetype,identcode
    FROM jptidcdassign INTO TABLE @DATA(li_jptidcdassign)
    FOR ALL ENTRIES IN @li_detail
    WHERE matnr = @li_detail-issue AND
          idcodetype IN @li_identity_code_type.   " Fetch 'ZJCD' values only
  IF sy-subrc = 0.
    SORT li_jptidcdassign BY matnr.
  ENDIF.


  " Delete duplicate information the detail table.
  SORT detail_tab BY contract item issue msg.
  DELETE ADJACENT DUPLICATES FROM detail_tab COMPARING contract item issue msg.
  REFRESH li_other_record.

  " Assigning additional data to output table
  LOOP AT detail_tab ASSIGNING <detail_item>.

    lv_detail_index = sy-tabix.
    CLEAR : lv_split.
    IF li_vbap IS NOT INITIAL.
      " Read Media product,Currency and per unit value
      READ TABLE li_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>) WITH KEY vbeln = <detail_item>-contract  posnr = <detail_item>-item BINARY SEARCH.
      IF sy-subrc = 0.
        <detail_item>-matnr = <lfs_vbap>-matnr.      " Media Product.
        <detail_item>-waerk = <lfs_vbap>-waerk.      " Currency

        " Potential value of release orders(Per unit value)
        IF lis_quantity IS NOT INITIAL.
          READ TABLE lis_quantity ASSIGNING FIELD-SYMBOL(<lfs_quantity>) WITH KEY vbeln = <detail_item>-contract  posnr = <detail_item>-item BINARY SEARCH.
          IF sy-subrc = 0.
            IF <lfs_quantity>-qty NE 0.      " Check summarized Quantity not equal to zero
              <detail_item>-netwr = <lfs_vbap>-netwr / <lfs_quantity>-qty.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

    " Read Identity code(Journal code)
    IF li_jptidcdassign IS NOT INITIAL.
      READ TABLE li_jptidcdassign ASSIGNING FIELD-SYMBOL(<li_jptidcdassign>) WITH KEY matnr = <detail_item>-issue BINARY SEARCH.
      IF sy-subrc = 0.
        <detail_item>-identcode = <li_jptidcdassign>-identcode.
      ENDIF.
    ENDIF.

    " Check specific msg and apply separation logic
    IF <detail_item>-msg CS text-977.

      lv_split = abap_true.     " Identify the messege split is done
      lv_block_1 =  <detail_item>-msg.
      CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
        EXPORTING
          string            = lv_block_1
          pos               = 68
          langu             = sy-langu
        IMPORTING
          string1           = lv_block_1
          string2           = lv_block_2
*         POS_NEW           =
        EXCEPTIONS
          string1_too_small = 1
          string2_too_small = 2
          pos_not_valid     = 3
          OTHERS            = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      lv_block_2 = reverse( lv_block_2 ).   " reverse the 2nd part of the string to get the ship mode to first

      SPLIT lv_block_2 AT space INTO TABLE li_split.      " Split string using the spaces
      IF li_split IS NOT INITIAL.
        CLEAR : lv_found , lv_shi_mode ,lv_postal_found.
        LOOP AT li_split ASSIGNING FIELD-SYMBOL(<lst_split>).
          lv_sdata = <lst_split>.
          IF lv_found NE abap_true.
            FIND REGEX '[[:alpha:]]' IN lv_sdata.   " Check letters for identify the next data
            IF sy-subrc = 0.
              CONCATENATE lv_shi_mode lv_sdata INTO lv_shi_mode SEPARATED BY space.
              CONTINUE.
            ELSE.
              lv_found = abap_true.               " Completed the Ship mode data
              lv_len = strlen( lv_sdata ).
              IF lv_len GT 5.                     " Distributor
                lv_distribution = lv_sdata.
              ELSE.                               " Plant
                lv_plant = lv_sdata.
              ENDIF.
              CONTINUE.
            ENDIF.
          ENDIF.

          " Postal code completion check
          IF lv_postal_found NE abap_true.
            lv_postal = lv_sdata.
            lv_postal_found = abap_true.
            CONTINUE.
          ENDIF.

          " Allow mutiple times for country
          CONCATENATE lv_country lv_sdata INTO lv_country SEPARATED BY space.

        ENDLOOP.

        " Reverse the string to actual value
        lv_shi_mode = reverse( lv_shi_mode ).
        lv_distribution = reverse( lv_distribution ).
        lv_plant = reverse( lv_plant ).
        lv_postal = reverse( lv_postal ).
        lv_country = reverse( lv_country ).

        <detail_item>-ship_method = lv_shi_mode.
        <detail_item>-vendor  = lv_distribution.
        <detail_item>-plant = lv_plant.
        <detail_item>-postal_code = lv_postal.
        <detail_item>-country = lv_country.

        FREE : lv_country , lv_postal , lv_plant , lv_distribution , lv_shi_mode , lv_block_1 , lv_block_2.
        CLEAR : li_split.

      ENDIF.

    ENDIF.

    " Apply custom sorting based on specific messege
    IF lv_split = abap_false.
      APPEND INITIAL LINE TO li_other_record ASSIGNING FIELD-SYMBOL(<other_detail_item>).
      MOVE-CORRESPONDING <detail_item> TO <other_detail_item>.
      DELETE detail_tab INDEX lv_detail_index.
    ENDIF.

  ENDLOOP.

  " Append skip data bottom of the final itab. (record rank according to the given text)
  IF li_other_record IS NOT INITIAL.
    APPEND LINES OF li_other_record TO detail_tab.
  ENDIF.

ENDIF.
