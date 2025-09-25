*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_BUR_EXP_TOKEN_FORM
* PROGRAM DESCRIPTION : Subroutines
* DEVELOPER           : Yraulji
* CREATION DATE       : 11/08/2017
* OBJECT ID           : I0234
* TRANSPORT NUMBER(S) : ED2K909379.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K910442 / ED2K915673
* REFERENCE NO:  INC0247446
* DEVELOPER: BTIRUVATHU
* DATE:  2019-06-25
* DESCRIPTION: Expired ZCTK Token Revenue unearned
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate default value to selection screen
*----------------------------------------------------------------------*
*      <--FP_S_AUART[]  Sales Document Type
*      <--FP_S_PSTYV[]  Sales document item category
*      <--FP_S_ENDDT[]  Contract End Date
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_auart TYPE tms_t_auart_range
                                   fp_s_pstyv TYPE rjksd_pstyv_range_tab
                                   fp_s_enddt TYPE trgr_date.
* Sales Document Type
  APPEND INITIAL LINE TO fp_s_auart ASSIGNING FIELD-SYMBOL(<lst_auart>).
  <lst_auart>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_auart>-option = c_opti_equal. "Option: (EQ)ual
  <lst_auart>-low    = c_auart_zsub. "Sales Document Type: ZSUB
  <lst_auart>-high   = space.

* Sales document item category
  APPEND INITIAL LINE TO fp_s_auart ASSIGNING <lst_auart>.
  <lst_auart>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_auart>-option = c_opti_equal. "Option: (EQ)ual
  <lst_auart>-low    = c_auart_zrew. "Sales Document Type: ZREW

*Sales Document Type: ZCOP
  APPEND INITIAL LINE TO fp_s_auart ASSIGNING <lst_auart>.
  <lst_auart>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_auart>-option = c_opti_equal. "Option: (EQ)ual
  <lst_auart>-low    = c_auart_zcop. "Sales Document Type: ZCOP

*Sales Document Type: ZTRL
  APPEND INITIAL LINE TO fp_s_auart ASSIGNING <lst_auart>.
  <lst_auart>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_auart>-option = c_opti_equal. "Option: (EQ)ual
  <lst_auart>-low    = c_auart_ztrl. "Sales Document Type: ZTRL

* Sales document item category : ZDTK
  APPEND INITIAL LINE TO fp_s_pstyv ASSIGNING FIELD-SYMBOL(<lst_pstyv>).
  <lst_pstyv>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_pstyv>-option = c_opti_equal. "Option: (EQ)ual
  <lst_pstyv>-low    = c_pstyv_zdtk. "Sales document item category: ZDTK
  <lst_pstyv>-high   = space.

* Populate value for Contract End Date.
  APPEND INITIAL LINE TO fp_s_enddt ASSIGNING FIELD-SYMBOL(<lst_enddt>).
  <lst_enddt>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_enddt>-option = c_opti_betwn. "Option: (B)e(T)ween
  <lst_enddt>-low    = sy-datum - 8.
  <lst_enddt>-high   = sy-datum - 1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       Fatch records need to post idoc.
*----------------------------------------------------------------------*
*      <--FP_S_AUART[]  Sales Document Type
*      <--FP_S_PSTYV[]  Sales document item category
*----------------------------------------------------------------------*
FORM f_fetch_n_process  USING    fp_s_auart TYPE tms_t_auart_range
                                 fp_s_pstyv TYPE rjksd_pstyv_range_tab
                                 fp_s_enddt TYPE trgr_date.

  DATA : lv_seg_no TYPE idocdsgnum,       " Number of SAP segment
         lv_menge  TYPE dzmeng,           " Segment Number variable declaration.
         li_vbfa   TYPE TABLE OF ty_vbfa, "Sales Document Flow

* IDOC Related Internal Table Declaration.
      li_edidd         TYPE edidd_tt. " Data record (IDoc)

  CONSTANTS  lc_vbtyp_c TYPE vbtyp VALUE 'C'. " SD document category

* Fatch Order Header & Item data.
  SELECT

*    Sales Document : Item Data.
         vbap~vbeln,  "Sales Document
         vbap~posnr,  "Sales Document Item
         vbap~matnr,  "Material Number
         vbap~uepos,  "Higher-level item in bill of material structures
         vbap~meins,  "Base Unit of Measure
         vbap~netwr,  "Net value of the order item in document currency
         vbap~waerk,  "SD Document Currency
         vbap~kwmeng, "Cumulative Order Quantity in Sales Units
         vbap~zmeng,  "Target quantity in sales units
         vbap~zieme,  "Target quantity UoM
         vbap~werks,  "SD Document Currency
         vbap~pstyv,  " Sales document item category

*    Sales Document : Header Data.
         vbak~erdat, "Date on Which Record Was Created
         vbak~erzet, "Entry time
         vbak~vbtyp, "SD document category
         vbak~auart  "Sales Document Type

    FROM vbap        " Sales Document: Item Data
   INNER JOIN vbak   " Sales Document: Header Data

      ON vbap~vbeln EQ vbak~vbeln

    INTO TABLE @DATA(li_ord_items)

   WHERE vbak~auart IN @fp_s_auart
     AND vbap~pstyv IN @fp_s_pstyv.

  IF sy-subrc EQ 0.

* Get valid contract data
    SELECT
           vbeln, "Sales Document
           vposn, "Sales Document Item
           venddat  "Contract End Date
      FROM veda   " Contract Data

      INTO TABLE @DATA(li_cont_data)
      FOR ALL ENTRIES IN @li_ord_items

      WHERE vbeln = @li_ord_items-vbeln
      AND ( vposn = @li_ord_items-posnr
      OR    vposn = '000000').

    IF sy-subrc <> 0.
*   No action required.
    ENDIF. " IF sy-subrc EQ 0

    SELECT
         vbelv,   "Preceding sales and distribution document
         posnv,   "Preceding item of an SD document
         vbeln,   "Subsequent sales and distribution document
         posnn,   "Subsequent item of an SD document
         vbtyp_n, "Document category of subsequent document
         rfmng    " Referenced quantity in base unit of measure

    FROM vbfa     " Sales Document Flow
    INTO TABLE @DATA(li_doc_flow)
    FOR ALL ENTRIES IN @li_ord_items

    WHERE vbelv   = @li_ord_items-vbeln
    AND   posnv   = @li_ord_items-posnr
    AND   vbtyp_n = @lc_vbtyp_c.
    IF sy-subrc <> 0.
*   No action required.
    ENDIF. " IF sy-subrc <> 0

    SELECT
           vbeln, "Sales and Distribution Document Number
           posnr, "Item number of the SD document
           ihrez  " Your Reference

      FROM vbkd   " Sales Document: Business Data
      INTO TABLE @DATA(li_vbkd)
      FOR ALL ENTRIES IN @li_ord_items

      WHERE vbeln = @li_ord_items-vbeln
      AND   posnr = @li_ord_items-posnr.
    IF sy-subrc <> 0.
*   No action required.
    ENDIF. " IF sy-subrc <> 0
    IF li_doc_flow IS NOT INITIAL.
      LOOP AT li_doc_flow ASSIGNING FIELD-SYMBOL(<ls_doc_flow>).
        st_vbfa-vbelv    = <ls_doc_flow>-vbelv  .
        st_vbfa-posnv    = <ls_doc_flow>-posnv  .
        st_vbfa-vbtyp_n  = <ls_doc_flow>-vbtyp_n.
        st_vbfa-rfmng    = <ls_doc_flow>-rfmng  .
        COLLECT st_vbfa INTO li_vbfa.
        CLEAR st_vbfa.
      ENDLOOP. " LOOP AT li_doc_flow ASSIGNING FIELD-SYMBOL(<ls_doc_flow>)
    ENDIF. " IF li_doc_flow IS NOT INITIAL

  ENDIF. " IF sy-subrc EQ 0

* Control Record For Inbound IDOC
  PERFORM f_control_data.

  SORT : li_ord_items BY vbeln posnr,
         li_cont_data BY vbeln vposn,
         li_vbkd      BY vbeln posnr,
* BOC - BTIRUVATHU - INC0247446 - 2019/06/25 - ED1K910442
         li_vbfa      BY vbelv posnv.
  LOOP AT li_ord_items ASSIGNING FIELD-SYMBOL(<ls_item>).

    CLEAR: st_itab,lv_menge,lv_seg_no,li_edidd[].

    READ TABLE li_vbfa
    ASSIGNING FIELD-SYMBOL(<ls_vbfa>)
    WITH KEY vbelv = <ls_item>-vbeln
             posnv = <ls_item>-posnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_menge = <ls_item>-zmeng - <ls_vbfa>-rfmng.
    ELSE.
      lv_menge = <ls_item>-zmeng.
    ENDIF.

*  LOOP AT li_vbfa ASSIGNING FIELD-SYMBOL(<ls_vbfa>).
*
*    CLEAR: st_itab,lv_menge,lv_seg_no,li_edidd[].

*    READ TABLE li_ord_items
*    ASSIGNING FIELD-SYMBOL(<ls_item>)
*    WITH KEY vbeln = <ls_vbfa>-vbelv
*             posnr = <ls_vbfa>-posnv BINARY SEARCH.

*    IF sy-subrc IS INITIAL.
*      lv_menge = <ls_item>-zmeng - <ls_vbfa>-rfmng.
* EOC - BTIRUVATHU - INC0247446 - 2019/06/25 - ED1K910442

      READ TABLE li_cont_data
      ASSIGNING FIELD-SYMBOL(<ls_veda>)
      WITH KEY vbeln = <ls_item>-vbeln
               vposn = <ls_item>-posnr BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE li_cont_data
        ASSIGNING <ls_veda>
        WITH KEY vbeln = <ls_item>-vbeln
                 vposn = '000000' BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0

      IF sy-subrc IS INITIAL AND
         <ls_veda>-venddat IN fp_s_enddt AND
         lv_menge > 0.
        APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<st_edidd>).

        IF p_auart IS NOT INITIAL.
          st_seg_k01-bsart = p_auart.
          <st_edidd>-hlevel = '1'.
          lv_seg_no = lv_seg_no + 1.
          <st_edidd>-segnum = lv_seg_no.
          <st_edidd>-segnam = c_seg_k01.
          <st_edidd>-sdata  = st_seg_k01.
        ENDIF. " IF p_auart IS NOT INITIAL

        READ TABLE li_vbkd
        ASSIGNING FIELD-SYMBOL(<ls_vbkd>)
        WITH KEY vbeln = <ls_item>-vbeln
                 posnr = <ls_item>-posnr BINARY SEARCH.
        IF sy-subrc  IS INITIAL.
          st_seg_k02-belnr = <ls_vbkd>-ihrez.
          st_seg_k02-qualf = c_qualf_043. "IDOC qualifier reference document (043)
          APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
          <st_edidd>-hlevel = '2'.
          lv_seg_no = lv_seg_no + 1.
          <st_edidd>-segnum = lv_seg_no.
          <st_edidd>-segnam = c_seg_k02.
          <st_edidd>-sdata  = st_seg_k02.
*         pURCHASE ORDER DETAILS.

          st_seg_k02-belnr = p_bstkd.
          st_seg_k02-qualf = '001'. "IDOC qualifier reference document (043)
          APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
          <st_edidd>-hlevel = '2'.
          lv_seg_no = lv_seg_no + 1.
          <st_edidd>-segnum = lv_seg_no.
          <st_edidd>-segnam = c_seg_k02.
          <st_edidd>-sdata  = st_seg_k02.
        ENDIF. " IF sy-subrc IS INITIAL

        st_seg_p01-posex = <ls_item>-posnr.
        st_seg_p01-menge = lv_menge. "DIFFERENCE QUANTITY.
        CONDENSE st_seg_p01-menge.
        APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
        <st_edidd>-hlevel = '2'.
        lv_seg_no = lv_seg_no + 1.
        <st_edidd>-segnum = lv_seg_no.
        <st_edidd>-segnam = c_seg_p01.
        <st_edidd>-sdata  = st_seg_p01.

        st_seg_p03-datum = sy-datum.
        st_seg_p03-iddat = c_iddat_acd. " Qualifier for IDOC date segment (ACD)
        APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
        <st_edidd>-hlevel = '3'.
        lv_seg_no = lv_seg_no + 1.
        <st_edidd>-segnum = lv_seg_no.
        <st_edidd>-psgnum = 2. "E1EDP01
        <st_edidd>-segnam = c_seg_p03.
        <st_edidd>-sdata  = st_seg_p03.

        IF p_kschl IS NOT INITIAL.
          st_seg_p05-kschl = p_kschl. " Condition type (ZTRL)
          APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
          <st_edidd>-hlevel = '3'.
          lv_seg_no = lv_seg_no + 1.
          <st_edidd>-segnum = lv_seg_no.
          <st_edidd>-psgnum = 2. "E1EDP01
          <st_edidd>-segnam = c_seg_p05.
          <st_edidd>-sdata  = st_seg_p05.
        ENDIF. " IF p_kschl IS NOT INITIAL

        IF <ls_item>-matnr IS NOT INITIAL.
          st_seg_p19-idtnr = <ls_item>-matnr.
          APPEND INITIAL LINE TO li_edidd ASSIGNING <st_edidd>.
          <st_edidd>-hlevel = '3'.
          lv_seg_no = lv_seg_no + 1.
          <st_edidd>-segnum = lv_seg_no.
          <st_edidd>-psgnum = 2. "E1EDP01
          <st_edidd>-segnam = c_seg_p19.
          <st_edidd>-sdata  = st_seg_p19.
        ENDIF. " IF <ls_item>-matnr IS NOT INITIAL

*      FILL OUTPUT ALV STRUCTURE.
        st_itab-vbeln = <ls_item>-vbeln.
        st_itab-posnr = <ls_item>-posnr.
        st_itab-menge = lv_menge.
        st_itab-zieme = <ls_item>-zieme.

        PERFORM f_send_idoc TABLES li_edidd.
      ENDIF. " IF sy-subrc IS INITIAL AND lv_menge > 0
*    ENDIF. " IF sy-subrc IS INITIAL                        "INC0247446 - ED1K910442
  ENDLOOP. " LOOP AT li_vbfa ASSIGNING FIELD-SYMBOL(<ls_vbfa>)
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_IDOC
*&---------------------------------------------------------------------*
*       Send IDOC
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_idoc TABLES fp_t_edidd TYPE edidd_tt.

  DATA : lst_edidc   TYPE edidc. " Control record (IDoc)

  CALL FUNCTION 'EDI_DOCUMENT_OPEN_FOR_CREATE'
    EXPORTING
      idoc_control         = st_edidc
*     PI_RFC_MULTI_CP      = '    '
    IMPORTING
      identifier           = v_docnum
    EXCEPTIONS
      other_fields_invalid = 1
      OTHERS               = 2.

  IF sy-subrc IS INITIAL.
    CALL FUNCTION 'EDI_SEGMENTS_ADD_BLOCK'
      EXPORTING
        identifier                    = v_docnum
      TABLES
        idoc_containers               = fp_t_edidd
      EXCEPTIONS
        identifier_invalid            = 1
        idoc_containers_empty         = 2
        parameter_error               = 3
        segment_number_not_sequential = 4
        OTHERS                        = 5.

    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'EDI_DOCUMENT_CLOSE_CREATE'
        EXPORTING
          identifier          = v_docnum
*         NO_DEQUEUE          = ' '
*         SYN_ACTIVE          = ' '
        IMPORTING
          idoc_control        = lst_edidc
*         SYNTAX_RETURN       =
        EXCEPTIONS
          document_not_open   = 1
          document_no_key     = 2
          failure_in_db_write = 3
          parameter_error     = 4
          OTHERS              = 5.

      IF sy-subrc = 0  AND lst_edidc-status = c_status_50.

        st_itab-idocn = lst_edidc-docnum.
        APPEND st_itab TO i_itab.

        COMMIT WORK.
*         Call submit program to change the Idoc status from 51 to 64.
        SUBMIT rc1_idoc_set_status
          WITH p_idoc   EQ lst_edidc-docnum " Idoc Number
          WITH p_mestyp EQ lst_edidc-mestyp " Message Type
          WITH p_status EQ c_status_50      " Current Status -> '50'
          WITH p_staneu EQ c_status_64      " To Be status -> '64'
          WITH p_test   EQ abap_false
          EXPORTING LIST TO MEMORY
          AND RETURN.

      ENDIF. " IF sy-subrc = 0 AND lst_edidc-status = c_status_50
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_CONTROLL_REOCRD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_control_data. " Control record (IDoc)

*LOCAL constant declaration
  CONSTANTS :
    lc_idoctp    TYPE edi_idoctp VALUE 'ORDERS05', "Basic type
    lc_dir_in    TYPE edi_direct VALUE '2',        "Direction for IDoc (Inbound)
    lc_sys_sap   TYPE char3      VALUE 'SAP',      "Sap of type CHAR3
    lc_part_type TYPE edi_sndprt VALUE 'LS',       "Partner Type: Logical Syatem (LS)
    lc_snd_tibco TYPE char5      VALUE 'TIBCO'.    " Snd_tibco of type CHAR5

*Populate EDIDC Data
  st_edidc-direct = lc_dir_in. "DIRECTION FOR IDOC-INBOUND(2)
  st_edidc-idoctp = lc_idoctp. "Basic type (ORDERS05)
  st_edidc-sndpor = lc_snd_tibco.

  st_edidc-mestyp = p_mestyp. "Message type from selection
  st_edidc-mescod = p_mescod. "Message Code from Selection
  st_edidc-mesfct = p_mesfct. "Messge Function code from selection

* Fetch details from Partner Profile: inbound (technical parameters)
  SELECT
    sndprn   " Partner Number of Sender
    sndprt   " Partner Type of Sender
    sndpfc   " Partner function of sender
    UP TO 1 ROWS
  FROM edp21 " PARTNER PROFILE: INBOUND
    INTO
    ( st_edidc-sndprn,
      st_edidc-sndprt,
      st_edidc-sndpfc )
   WHERE  sndprn = lc_snd_tibco
   AND    mestyp = p_mestyp
   AND    mescod = p_mescod.
  ENDSELECT.

  IF sy-subrc NE 0.
    CLEAR :
    st_edidc-sndprn,
    st_edidc-sndprt,
    st_edidc-sndpfc.
  ENDIF. " IF sy-subrc NE 0

  CONCATENATE lc_sys_sap
              sy-sysid
              INTO st_edidc-rcvpor. "
  CONDENSE st_edidc-rcvpor.

  st_edidc-rcvprt = lc_part_type. "Receiver : Partner Type   (LS)

* Get sender information (Current System)
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = st_edidc-rcvprn "Partner Number of Sender
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_edidc-rcvprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV Grid as Posted IDOC Log.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_grid .
  DATA: lr_err_message TYPE REF TO cx_salv_msg, " ALV: General Error Class with Message
        lv_text        TYPE string.             " ALV: General Error Class with Message
  IF i_itab[] IS NOT INITIAL.
    TRY.
        cl_salv_table=>factory(
        IMPORTING
          r_salv_table = r_alv_table
        CHANGING
          t_table      = i_itab ).
        r_alv_columns = r_alv_table->get_columns( ).

        PERFORM f_build_layout. "       Build layout for ALV
        PERFORM f_build_catlog. "       Build Catalog for ALV
        PERFORM f_build_toobar. "       Make available Toolbar Function for ALV
        PERFORM f_report_heading. "     Report Heading for ALV

      CATCH cx_salv_msg INTO lr_err_message.
*   Add error processing
        lv_text = lr_err_message->get_text( ).
        MESSAGE lv_text TYPE c_msgty_i.
    ENDTRY.

    PERFORM f_publish_alv. "       Display ALV Grid.
  ELSE.
    WRITE:/ 'No record to Display.'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       Build layout for ALV
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout .
  DATA: lr_layout TYPE REF TO cl_salv_layout. " Settings for Layout
  DATA: lc_layout_key      TYPE salv_s_layout_key. " Layout Key

  lr_layout            = r_alv_table->get_layout( ).
  lc_layout_key-report = sy-repid.

  lr_layout->set_key( lc_layout_key ).
  lr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_CATLOG
*&---------------------------------------------------------------------*
*       Build Catalog for ALV
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_catlog .
  DATA: lr_err_notfound TYPE REF TO cx_salv_not_found, " ALV: General Error Class (Checked During Syntax Check)
        lv_text         TYPE string.

  CONSTANTS : lc_vbeln  TYPE name_feld  VALUE 'VBELN', "Sales Document
              lc_posnr  TYPE name_feld  VALUE 'POSNR', "Sales Document Item
              lc_menge  TYPE name_feld  VALUE 'MENGE', "Quantity in units
              lc_zieme  TYPE name_feld  VALUE 'ZIEME', "Quantity UoM
              lc_idocn  TYPE name_feld  VALUE 'IDOCN', "Idoc Number
              lc_len_20 TYPE lvc_outlen VALUE '20'.    "Output Length

  TRY.
      r_single_column = r_alv_columns->get_column( lc_vbeln ).
      r_single_column->set_short_text(    text-s08  ). " Ord.No
      r_single_column->set_medium_text(   text-s09  ). " Order No
      r_single_column->set_long_text(     text-s10  ). " Ord./Contract Number
      r_single_column->set_output_length( lc_len_20 ). "Output Length as 20

      r_single_column = r_alv_columns->get_column( lc_posnr ).
      r_single_column->set_short_text(    text-s11  ). "Item.No
      r_single_column->set_medium_text(   text-s12  ). " Item.No
      r_single_column->set_long_text(     text-s13  ). " Order Item No
      r_single_column->set_output_length( lc_len_20 ). "Output Length as 20

      r_single_column = r_alv_columns->get_column( lc_menge ).
      r_single_column->set_short_text(    text-s14  ). " Diff.Qty
      r_single_column->set_medium_text(   text-s15  ). " Diff. Quantity
      r_single_column->set_long_text(     text-s16  ). " Diff./Open Qty.
      r_single_column->set_output_length( lc_len_20 ). "Output Length as 20

      r_single_column = r_alv_columns->get_column( lc_zieme ).
      r_single_column->set_short_text(    text-s17  ). "Uom
      r_single_column->set_medium_text(   text-s18  ). "Unit of Measure
      r_single_column->set_long_text(     text-s18  ). "Unit of Measure
      r_single_column->set_output_length( lc_len_20 ). "Output Length as 20


      r_single_column = r_alv_columns->get_column( lc_idocn ).
      r_single_column->set_short_text(    text-s19  ). "IDOC No
      r_single_column->set_medium_text(   text-s19  ). "IDOC No
      r_single_column->set_long_text(     text-s20  ). "IDOC Number
      r_single_column->set_output_length( lc_len_20 ). "Output Length as 20

    CATCH cx_salv_not_found INTO lr_err_notfound.
*   Add error processing
      lv_text = lr_err_notfound->get_text( ).
      MESSAGE lv_text TYPE c_msgty_i.
  ENDTRY.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REPORT_HEADING
*&---------------------------------------------------------------------*
*       Report Heading for ALV
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_report_heading .
  DATA: lr_report_settings TYPE REF TO cl_salv_display_settings. " Appearance of the ALV Output

  lr_report_settings = r_alv_table->get_display_settings( ).
  lr_report_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  lr_report_settings->set_list_header( text-s21 ). "Posted IDOC List
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PUBLISH_ALV
*&---------------------------------------------------------------------*
*       Display ALV Grid.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_publish_alv .
* set_optimize will set columns optimised based on data and will remove
* any width specification setup within build_fieldcatalog column setup
*  it_columns->set_optimize( ).

  r_alv_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_TOOBAR
*&---------------------------------------------------------------------*
*       Make available Toolbar Function for ALV
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_toobar .
  DATA: lr_toolbar_functions TYPE REF TO cl_salv_functions_list. " Generic and User-Defined Functions in List-Type Tables

  lr_toolbar_functions = r_alv_table->get_functions( ).
  lr_toolbar_functions->set_all( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
* Clear Global Variable + Internal Table.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_all .
  CLEAR :

* Clearing Variables.
  v_docnum, " IDoc number

* Clearing Internal tables.
  i_itab[],  "Output Table

* Clearing Work Area.
  st_vbfa,  "Sales Document Flow
  st_edidc, "Idoc Data Records.
  st_itab.  "Output Table
ENDFORM.
