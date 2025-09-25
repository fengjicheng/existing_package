FUNCTION zqtc_ff_determine.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBAK) TYPE  VBAK OPTIONAL
*"     REFERENCE(IM_VBAP) TYPE  VBAP OPTIONAL
*"     REFERENCE(IM_VBRP) TYPE  VBRP OPTIONAL
*"     REFERENCE(IM_FLAG) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_VBRK) TYPE  VBRK OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_FF_FLAG) TYPE  CHAR1
*"  CHANGING
*"     REFERENCE(CH_VBPA) TYPE  VBPA_TAB
*"     REFERENCE(CH_MULTIPLE_SHIP) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_FF_DETERMINE(FM)
* PROGRAM DESCRIPTION: This FM is built to find the Freight forwarder
* DEVELOPER: Siva Guda
* CREATION DATE: 06/24/2020
* OBJECT ID: E246
* TRANSPORT NUMBER(S):  ED2K918605,ED2K919084
*----------------------------------------------------------------------*



  CONSTANTS : lc_devid         TYPE zdevid       VALUE 'E246',              " Development ID
              lc_document_type TYPE rvari_vnam   VALUE 'DOCUMENT_TYPE',     " Document Type
              lc_cust_group    TYPE rvari_vnam   VALUE 'CUST_GROUP',        " Customer Group
              lc_sp            TYPE vbpa-parvw   VALUE 'SP',                " Frighet Forwarder
              lc_ph            TYPE ismmediatype VALUE 'PH',                " Physical Material
              lv_posnr         TYPE posnr        VALUE '000000'.            " Header Partner

  DATA : r_document_type TYPE RANGE OF salv_de_selopt_low,                  " Document Type
         r_cust_group    TYPE RANGE OF salv_de_selopt_low,                  " Customer Group
         lt_vbrp         TYPE STANDARD TABLE OF vbrp,                       " Invoice Item Data
         lst_vbpa        TYPE vbpa,                                         " Partner Data
         lv_ff_cnt       TYPE char10,                                       " Frighet Forwarder Count
         lv_sh_cnt       TYPE char10.                                       " Ship-to Count


* Fetch values from constant table
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/...)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @DATA(li_constant)
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @lc_devid
      AND activate EQ @abap_true.

* Populate the document types and customer groups into seperate range tables.
  LOOP AT li_constant INTO DATA(lst_constant).
    IF lst_constant-param1 EQ lc_document_type.
      APPEND INITIAL LINE TO r_document_type ASSIGNING FIELD-SYMBOL(<lst_r_document_type>).
      <lst_r_document_type>-sign   = lst_constant-sign.
      <lst_r_document_type>-option = lst_constant-opti.
      <lst_r_document_type>-low    = lst_constant-low.
      <lst_r_document_type>-high   = lst_constant-high.
    ENDIF.
    IF lst_constant-param1 EQ lc_cust_group.
      APPEND INITIAL LINE TO r_cust_group ASSIGNING FIELD-SYMBOL(<lst_r_cust_group>).
      <lst_r_cust_group>-sign   = lst_constant-sign.
      <lst_r_cust_group>-option = lst_constant-opti.
      <lst_r_cust_group>-low    = lst_constant-low.
      <lst_r_cust_group>-high   = lst_constant-high.
    ENDIF.
  ENDLOOP.


*Assigning data to local variables.
  DATA(ls_vbak) = im_vbak.
  DATA(ls_vbap) = im_vbap.
  DATA(ls_vbrk) = im_vbrk.
  DATA(ls_vbrp) = im_vbrp.

  IF im_flag IS INITIAL.
* Fetch Invoice Data
    IF im_vbrk-vbeln IS NOT INITIAL.
      SELECT SINGLE * FROM vbrk
                      INTO ls_vbrk
                      WHERE vbeln = im_vbrk-vbeln.
    ENDIF.

* Fetch doc type and customer group if VBELN is not initial
    IF im_vbak-vbeln IS NOT INITIAL.
      SELECT SINGLE * FROM vbak
               INTO ls_vbak
               WHERE vbeln = im_vbak-vbeln.

      IF sy-subrc = 0.
* validate Line item data
        SELECT * FROM vbap
                 INTO TABLE @DATA(lt_vbap)
                 WHERE vbeln = @ls_vbak-vbeln.
      ENDIF.

    ENDIF.
  ENDIF.


  IF im_flag IS NOT INITIAL AND  ls_vbap IS NOT INITIAL.
    APPEND ls_vbap TO lt_vbap.
  ENDIF.


* Validate Physical Material againest to Material
  IF lt_vbap[] IS NOT INITIAL.
    SELECT *
    FROM mara
    INTO TABLE @DATA(lt_mara)
    FOR ALL ENTRIES IN @lt_vbap
    WHERE matnr = @lt_vbap-matnr
      AND ismmediatype = @lc_ph.
    IF sy-subrc = 0.
      SORT lt_mara  BY matnr.
    ENDIF.
*- Fetch Partner Data
    IF ch_vbpa IS INITIAL.
      SELECT * FROM  vbpa
               INTO TABLE @DATA(lt_vbpa)
               FOR ALL ENTRIES IN @lt_vbap
               WHERE vbeln = @lt_vbap-vbeln
               AND   parvw = @lc_sp.
    ENDIF.
  ENDIF.
*- For Invoice Document type
  IF im_vbrk-vbeln IS NOT INITIAL AND im_flag IS INITIAL.
    ls_vbak-auart = ls_vbrk-fkart.
  ENDIF.
* validate doc type and customer group against constnat table entries
  IF  ( ls_vbak-auart IN r_document_type
    AND ls_vbak-kvgr1 IN r_cust_group ) .
    IF im_flag IS INITIAL.
* Check Fetch frieght forward and retrieve address number.
      SORT lt_vbpa  BY vbeln posnr.
      SORT lt_mara  BY matnr ismmediatype.
      LOOP AT lt_vbap INTO DATA(lst_vbap).
* Validae the material type shoudl be physical.
        READ TABLE lt_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap-matnr
                                                        ismmediatype = lc_ph
                                               BINARY SEARCH.
        IF sy-subrc EQ 0.
* Check Fetch frieght forward and retrieve address number.
          READ TABLE lt_vbpa INTO lst_vbpa  WITH KEY vbeln = lst_vbap-vbeln
                                                     posnr = lst_vbap-posnr
                                                 BINARY SEARCH.
          IF sy-subrc NE 0.
            READ TABLE lt_vbpa INTO lst_vbpa  WITH KEY vbeln = lst_vbap-vbeln
                                                       posnr = lv_posnr
                                              BINARY SEARCH.
          ENDIF.
          IF lst_vbpa IS NOT INITIAL.
            lv_ff_cnt = lv_ff_cnt + 1.
            APPEND lst_vbpa  TO ch_vbpa.
           ELSE.
            lv_sh_cnt = lv_sh_cnt + 1.
          ENDIF.
        ELSE.
          lv_sh_cnt = lv_sh_cnt + 1.
        ENDIF.
* read the FF & ship-to determination count on the order
        IF lv_ff_cnt IS NOT INITIAL AND lv_sh_cnt IS NOT INITIAL.
          ch_multiple_ship = abap_true.
          EXIT.
        ELSEIF lv_ff_cnt IS INITIAL AND lv_sh_cnt IS NOT INITIAL.
          ch_multiple_ship = abap_false.
        ELSEIF lv_ff_cnt IS NOT INITIAL AND lv_sh_cnt IS INITIAL.
          ch_multiple_ship = abap_false.
        ENDIF.
        CLEAR: lst_vbpa,lst_mara,lst_vbpa.
      ENDLOOP.
      IF lv_sh_cnt IS NOT INITIAL AND lv_ff_cnt IS NOT INITIAL.
        CLEAR ch_vbpa[].
      ENDIF.
    ELSE.
* Validation of Freight forward for enhancemnets calls at order & invoice level.
      IF ch_vbpa IS INITIAL.
        ch_vbpa[] = lt_vbpa[].
      ENDIF.
      DATA(lt_vbpa_tmp) =  ch_vbpa[].
      SORT lt_vbpa_tmp BY vbeln posnr parvw.
      CLEAR ch_vbpa.
* Validae the material type shoudl be physical.
      READ TABLE lt_mara INTO lst_mara INDEX 1.
      IF sy-subrc EQ 0.
* Read freight forward at order item level.
        READ TABLE lt_vbpa_tmp INTO DATA(lst_vbpa_tmp) WITH KEY posnr = im_vbap-posnr
                                                                parvw = lc_sp.

        IF sy-subrc <> 0.
* Read freight forward at order header level.
          READ TABLE lt_vbpa_tmp INTO lst_vbpa_tmp WITH KEY posnr = lv_posnr
                                                            parvw = lc_sp.
        ENDIF.
        IF sy-subrc = 0.
          APPEND lst_vbpa_tmp TO ch_vbpa.
        ENDIF.
      ENDIF.
    ENDIF.
*--*Prabhu
    ELSE.
      CLEAR : ch_vbpa[].
  ENDIF.
ENDFUNCTION.
