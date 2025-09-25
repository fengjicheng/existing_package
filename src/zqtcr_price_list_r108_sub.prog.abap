*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_PRICE_LIST_R108_SUB (Include)
* PROGRAM DESCRIPTION: This program implemented for to display the
*                      Price List Report
* DEVELOPER:           Siva Guda (SGUDA)
* CREATION DATE:       05/27/2020
* OBJECT ID:           ERPM-6946/R108
* TRANSPORT NUMBER(S): :ED2K918317
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description: .
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZQTCR_PRICE_LIST_R108_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.

  SELECT konh~kschl konh~kotabnr konh~erdat konh~ernam konp~konwa konp~kbetr konp~knumh a927~kunwe a927~matnr a927~datab
             a927~datbi a927~kappl a927~knumh a927~kschl mara~matnr mara~extwg mara~ismpubltype makt~maktx
      FROM ( konh
             INNER JOIN konp
             ON  konp~knumh = konh~knumh
             INNER JOIN a927
             ON  a927~kappl = konp~kappl
             AND a927~knumh = konp~knumh
             AND a927~kschl = konp~kschl
             INNER JOIN mara
             ON  mara~matnr = a927~matnr
             INNER JOIN makt
             ON  makt~matnr = mara~matnr )
           INTO CORRESPONDING FIELDS OF TABLE gi_price_data
           WHERE konh~kschl EQ p_kschl
             AND konh~kotabnr EQ p_kotabn
             AND konh~ernam IN s_ernam
             AND konh~erdat IN s_erdat
             AND konp~kbetr IN s_kbetr
             AND konp~konwa IN s_konwa
             AND a927~datbi IN s_datbi
             AND a927~datab IN s_datab
             AND a927~kunwe IN s_kunwe
             AND a927~matnr IN s_matnr
             AND mara~extwg IN s_extwg
             AND mara~ismpubltype IN s_ismpub. "#EC CI_BUFFJOIN        "#EC CI_SUBRC.

  IF gi_price_data[] IS NOT INITIAL.
    DELETE ADJACENT DUPLICATES FROM gi_price_data COMPARING ALL FIELDS.
    SELECT vbpa~vbeln vbpa~posnr vbpa~parvw vbpa~kunnr vbak~vbeln vbak~audat vbak~vbtyp  vbak~auart vbak~netwr vbak~vkorg
                                    FROM ( vbpa
                                    INNER JOIN vbak
                                    ON  vbpa~vbeln = vbak~vbeln )
                                    INTO CORRESPONDING FIELDS OF TABLE gi_vbpa "#EC CI_NO_TRANSFORM
                                    FOR ALL ENTRIES IN gi_price_data "#EC CI_NO_TRANSFORM
                                    WHERE vbpa~kunnr = gi_price_data-kunwe
                                    AND   vbpa~parvw = lc_ship_to "#EC CI_SUBRC.
                                    AND   vbak~auart IN s_auart
                                    AND   vbak~vbtyp = lc_document_catg.

    IF gi_vbpa[] IS NOT INITIAL.
      SELECT vbeln  posnr matnr mwsbp "#ec ci_no_transform
               FROM  vbap "CI_NO_TRANSFOR
        INTO CORRESPONDING FIELDS OF TABLE gi_vbap "#EC CI_NO_TRANSFORM
        FOR ALL ENTRIES IN gi_vbpa                 "#EC CI_NO_TRANSFORM
        WHERE vbeln = gi_vbpa-vbeln
        AND   abgru = space.                             "#EC CI_SUBRC.
    ENDIF.
    SORT gi_vbpa BY vbeln posnr.
    SORT gi_price_data BY matnr kunwe.
    LOOP AT gi_vbap INTO gst_vbap.
      READ TABLE gi_vbpa INTO gst_vbpa WITH KEY vbeln = gst_vbap-vbeln
                                                posnr = gst_vbap-posnr
                                       BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE gi_vbpa INTO gst_vbpa WITH KEY vbeln = gst_vbap-vbeln
                                                  posnr = lc_vposn
                                         BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        READ TABLE gi_price_data INTO gst_price_data WITH KEY matnr = gst_vbap-matnr
                                                              kunwe = gst_vbpa-kunnr
                                                      BINARY SEARCH.
        IF sy-subrc EQ 0.
          gst_ship_mat-kunnr = gst_vbpa-kunnr.
          gst_ship_mat-vbeln = gst_vbap-vbeln.
          gst_ship_mat-posnr = gst_vbap-posnr.
          gst_ship_mat-matnr = gst_vbap-matnr.
          APPEND gst_ship_mat TO gi_ship_mat.
          CLEAR: gst_ship_mat,gst_vbap,gst_vbpa,gst_price_data.
        ENDIF.
      ENDIF.
    ENDLOOP.


    IF gi_ship_mat[] IS NOT INITIAL.
      SORT gi_ship_mat BY vbeln posnr.
      SELECT vbeln posnr bstkd  ihrez bstkd_e ihrez_e FROM vbkd INTO CORRESPONDING FIELDS OF TABLE gi_vbkd
              FOR ALL ENTRIES IN gi_ship_mat
              WHERE vbeln = gi_ship_mat-vbeln
              AND   posnr = gi_ship_mat-posnr.           "#EC CI_SUBRC.

      SELECT vbeln posnr parvw kunnr FROM vbpa     "#EC CI_NO_TRANSFORM
                                 INTO CORRESPONDING FIELDS OF TABLE gi_vbpa_tmp "#EC CI_NO_TRANSFORM
                                 FOR ALL ENTRIES IN gi_ship_mat "#EC CI_NO_TRANSFORM
                                 WHERE vbeln = gi_ship_mat-vbeln "#EC CI_NO_TRANSFORM
                                 AND   ( parvw = lc_sold_to OR parvw = lc_ship_to ). "CI_NO_TRANSFORM "#EC CI_SUBRC.
      SELECT vbeln vposn vbegdat FROM veda
                                 INTO CORRESPONDING FIELDS OF TABLE gi_veda
                                 FOR ALL ENTRIES IN gi_ship_mat
                                 WHERE vbeln = gi_ship_mat-vbeln.
    ENDIF.
  ENDIF.

  IF gi_vbpa[] IS NOT INITIAL.
    SELECT spras auart bezei FROM tvakt            "#EC CI_NO_TRANSFORM
                             INTO CORRESPONDING FIELDS OF TABLE gi_tvakt "#EC CI_NO_TRANSFORM
                             FOR ALL ENTRIES IN gi_vbpa "#EC CI_NO_TRANSFORM
                             WHERE spras = sy-langu
                             AND auart =  gi_vbpa-auart. "#EC CI_SUBRC.
    SELECT spras vkorg vtext FROM tvkot
                             INTO CORRESPONDING FIELDS OF TABLE gi_tvkot
                             FOR ALL ENTRIES IN gi_vbpa
                             WHERE spras = sy-langu
                             AND   vkorg = gi_vbpa-vkorg. "#EC CI_SUBRC.

  ENDIF.
  IF gi_vbpa_tmp[] IS NOT INITIAL.
    SELECT kunnr name1 katr8 FROM kna1             "#EC CI_NO_TRANSFORM
                       INTO CORRESPONDING FIELDS OF TABLE gi_kna1 "#EC CI_NO_TRANSFORM
                       FOR ALL ENTRIES IN gi_vbpa_tmp "#EC CI_NO_TRANSFORM
                       WHERE  kunnr = gi_vbpa_tmp-kunnr.  "CI_NO_TRANSFORM   "#EC CI_SUBRC.
  ENDIF.
  PERFORM f_build_final_data.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_report .
  DATA: lst_layout   TYPE slis_layout_alv.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(001).
*- Layout
  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
*- Fieldcatlog
  PERFORM f_popul_field_catalog.
  SORT gi_final_out BY matnr kunwe  kbetr vbeln.
*- Display the report through ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = gi_fcat_out
    TABLES
      t_outtab                 = gi_final_out
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab ##NEEDED. "#EC CALLED

  SET PF-STATUS 'ZSTANDARD1'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm ##CALLED " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.

  SET PARAMETER ID 'KTN' FIELD space.
  CLEAR gst_final_out.
  READ TABLE gi_final_out INTO gst_final_out INDEX fp_lst_selfield-tabindex.
  IF sy-subrc EQ 0.
    SET PARAMETER ID 'KTN' FIELD gst_final_out-vbeln.
    CALL TRANSACTION 'VA43'  AND SKIP FIRST SCREEN.
  ENDIF.
ENDFORM. "APPLICATION_SERVER
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page ##CALLED.
*ALV Header declarations
  DATA: li_header      TYPE slis_t_listheader,
        lst_header     TYPE slis_listheader,
        lv_description TYPE char80,
        lv_amount      TYPE char20.


  lst_header-typ = lc_typ_h. "'H'
  lst_header-info = 'Selection-Criteria:'(002).
  APPEND lst_header TO li_header.
  CLEAR lst_header.
* TITLE
  lst_header-typ = lc_typ_s. "'S'
  IF p_kotabn IS NOT INITIAL.
    CONCATENATE 'Condition table:'(003) p_kotabn INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF p_kschl IS NOT INITIAL.
    CONCATENATE 'Condition type:'(004) p_kschl INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_auart IS NOT INITIAL.
    CONCATENATE 'Contract Type:'(005) s_auart-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_datab IS NOT INITIAL.
    CONCATENATE 'Valid from:'(006) s_datab-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_datbi IS NOT INITIAL.
    CONCATENATE 'Valid to:'(007) s_datbi-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_erdat IS NOT INITIAL.
    CONCATENATE 'Date created:' s_erdat-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_ernam IS NOT INITIAL.
    CONCATENATE 'Created by:'(008) s_ernam-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_extwg IS NOT INITIAL.
    CONCATENATE 'Journal Group Code:'(009) s_extwg-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_ismpub IS NOT INITIAL.
    CONCATENATE 'Publication Type:'(010) s_ismpub-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_kunwe IS NOT INITIAL.
    CONCATENATE 'Ship-to:'(011) s_kunwe-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF s_matnr IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = s_matnr-low
      IMPORTING
        output = s_matnr-low.
    CONCATENATE 'Material Number:'(012) s_matnr-low INTO   lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR: lst_header,lv_amount.
  lst_header-typ = lc_typ_s. "'S'
  IF s_kbetr IS NOT INITIAL.
    lv_amount = s_kbetr-low.
    CONCATENATE 'Amount'(021)  lv_amount INTO lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR: lst_header,lv_amount.
  lst_header-typ = lc_typ_s. "'S'
  IF s_konwa IS NOT INITIAL.
    lv_amount = s_konwa-low.
    CONCATENATE 'Currency'(022)  lv_amount INTO lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  lst_header-typ = lc_typ_s. "'S'
  IF gi_final_out[] IS NOT INITIAL.
    DESCRIBE TABLE gi_final_out LINES DATA(lv_lines).
    DATA lv_lines_tmp(10) TYPE c.
    lv_lines_tmp = lv_lines.
    CONDENSE lv_lines_tmp.
    CONCATENATE 'No.of Records Selected for this selection:'(041)  lv_lines_tmp INTO lst_header-info  SEPARATED BY space.
  ENDIF.
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  DELETE li_header WHERE info IS INITIAL.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM. "APPLICATION_SERVER
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_data .
  CLEAR :gi_final_out[],gi_vbpa[],gi_kna1[],gi_tvakt[],gi_tvkot[],gi_fcat_out,
         gst_final_out,gst_vbpa,gst_kna1,gst_tvakt,gst_tvkot,gst_fcat_out.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .
  REFRESH gi_fcat_out.
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat USING:
            lv_counter 'KSCHL'             'CnTy'(013),
            lv_counter 'KOTABNR'           'Tab'(014),
            lv_counter 'KUNWE'             'Ship-to'(015),
            lv_counter 'SHIP_NAME'         'Ship-to Name'(016),
            lv_counter 'KUNNR'             'Sold-to'(017),
            lv_counter 'SOLD_NAME'         'Sold-to Name'(018),
            lv_counter 'MATNR'             'Material Number'(019),
            lv_counter 'MAKTX'             'Journal Title'(020),
            lv_counter 'KBETR'             'Amount'(021),
            lv_counter 'KONWA'             'Currency'(022),
            lv_counter 'DATAB'             'Valid From'(023),
            lv_counter 'DATBI'             'Valid To'(024),
            lv_counter 'ERDAT'             'Created On'(025),
            lv_counter 'ERNAM'             'Created by'(026),
            lv_counter 'EXTWG'             'JGC',
            lv_counter 'ISMPUBLTYPE'       'PTyp'(027),
            lv_counter 'VBELN'             'Contract Number'(028),
            lv_counter 'AUDAT'             'Document Date'(029),
            lv_counter 'AUART'             'Contract Type'(030),
            lv_counter 'BEZEI'             'Contract Type Desc'(031),
            lv_counter 'VKORG'             'Sales Org'(032),
            lv_counter 'VTEXT'             'Sales Org Desc'(033),
            lv_counter 'NETWR'             'Header Net Total'(034),
            lv_counter 'MWSBP'             'Header Tax Total'(035),
            lv_counter 'BSTKD'             'Sold-to PO Number'(036),
            lv_counter 'IHREZ'             'Sold-to Your Reference'(037),
            lv_counter 'BSTKD_E'           'Ship-to PO Number'(038),
            lv_counter 'IHREZ_E'           'Ship-to Your Reference'(039),
            lv_counter 'KATR8'             'Ship-To BP Att 8'(040).
ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------
*       text
**-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132

  CONSTANTS :           lc_tabname       TYPE tabname   VALUE 'TY_FINAL'. " Table Name

  gst_fcat_out-col_pos      = fp_col + 1.
  gst_fcat_out-lowercase    = abap_true.
  gst_fcat_out-fieldname    = fp_fld.
  gst_fcat_out-tabname      = lc_tabname.
  gst_fcat_out-seltext_m    = fp_title.
  IF  gst_fcat_out-fieldname =  'VBELN'.
    gst_fcat_out-hotspot    = lc_fla_x.
  ENDIF.
  IF  gst_fcat_out-fieldname =  'MATNR'.
    gst_fcat_out-no_zero    = lc_fla_x.
  ENDIF.
  IF  gst_fcat_out-fieldname =  'KBETR'.
    gst_fcat_out-just    = lv_right.
  ENDIF.

  APPEND gst_fcat_out TO gi_fcat_out.
  CLEAR gst_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FINAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_final_data .
  DATA: lv_kunnr TYPE kna1-kunnr,
        lv_matnr TYPE mara-matnr,
        lv_date  TYPE sy-datum,
        lv_hits  TYPE char10.

  SORT gi_veda BY vbeln vposn.
  LOOP AT gi_ship_mat INTO gst_ship_mat.
    CLEAR gst_veda.
    READ TABLE gi_veda INTO gst_veda WITH KEY vbeln = gst_ship_mat-vbeln
                                              vposn = gst_ship_mat-posnr
                                            BINARY SEARCH.
    IF sy-subrc EQ 0.
      gst_ship_mat-vbegdat = gst_veda-vbegdat.
      MODIFY gi_ship_mat FROM gst_ship_mat TRANSPORTING vbegdat WHERE vbeln = gst_ship_mat-vbeln
                                                                      AND   posnr = gst_ship_mat-posnr.
    ELSE.
      CLEAR gst_veda.
      READ TABLE gi_veda INTO gst_veda WITH KEY vbeln = gst_ship_mat-vbeln
                                                vposn = lc_vposn
                                        BINARY SEARCH.
      gst_ship_mat-vbegdat = gst_veda-vbegdat.
      MODIFY gi_ship_mat FROM gst_ship_mat TRANSPORTING vbegdat WHERE vbeln = gst_ship_mat-vbeln.
*                                                                     AND   posnr = l_vposn.
    ENDIF.
    CLEAR:gst_ship_mat.
  ENDLOOP.
  SORT gi_price_data BY kunwe matnr.
  SORT gi_tvakt BY spras auart.
  SORT gi_tvkot BY spras vkorg.
  SORT gi_vbpa  BY parvw kunnr vbeln.
  SORT gi_vbap  BY matnr.
  SORT gi_kna1  BY kunnr.
  SORT gi_vbpa_tmp BY vbeln posnr parvw.
  SORT gi_vbkd BY vbeln posnr.
  SORT gi_ship_mat  BY kunnr  matnr ASCENDING vbegdat DESCENDING.
  CLEAR lv_hits.
  LOOP AT gi_price_data  INTO gst_price_data.
    LOOP AT gi_ship_mat  INTO gst_ship_mat WHERE kunnr = gst_price_data-kunwe
                                            AND  matnr = gst_price_data-matnr.
      IF ( lv_kunnr NE gst_ship_mat-kunnr OR lv_matnr NE gst_ship_mat-matnr ) OR lv_date IS INITIAL.
        lv_date = gst_ship_mat-vbegdat.
        lv_kunnr = gst_ship_mat-kunnr.
        lv_matnr = gst_ship_mat-matnr.
      ENDIF.
      IF gst_ship_mat-vbegdat+0(4) GE lv_date+0(4).
        MOVE-CORRESPONDING gst_price_data TO gst_final_out.
        READ TABLE gi_vbpa INTO gst_vbpa WITH KEY parvw = lc_ship_to
                                                  kunnr = gst_ship_mat-kunnr
                                                  vbeln = gst_ship_mat-vbeln
                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
          gst_final_out-vbeln = gst_vbpa-vbeln.
          gst_final_out-audat = gst_vbpa-audat.
          gst_final_out-auart = gst_vbpa-auart.
          gst_final_out-netwr = gst_vbpa-netwr.
          gst_final_out-vkorg = gst_vbpa-vkorg.

          CLEAR : gst_final_out-mwsbp.
          LOOP AT gi_vbap INTO gst_vbap   WHERE vbeln = gst_ship_mat-vbeln. "#EC CI_NESTED
            gst_final_out-mwsbp = gst_final_out-mwsbp + gst_vbap-mwsbp.
          ENDLOOP.                                       "#EC CI_NESTED
          lv_hits = lv_hits + 1.
          READ TABLE gi_vbkd INTO gst_vbkd WITH KEY vbeln = gst_ship_mat-vbeln
                                                    posnr = gst_ship_mat-posnr
                                            BINARY SEARCH.
*- To get Sales information like sales org, contract, net price, contract dates.
          IF sy-subrc EQ 0.
            gst_final_out-bstkd = gst_vbkd-bstkd.
            gst_final_out-ihrez = gst_vbkd-ihrez.
            gst_final_out-bstkd_e = gst_vbkd-bstkd_e.
            gst_final_out-ihrez_e = gst_vbkd-ihrez_e.
          ENDIF.
*- To Get sales document type description
          READ TABLE gi_tvakt INTO gst_tvakt WITH KEY spras = sy-langu
                                                      auart = gst_vbpa-auart
                                             BINARY SEARCH.
          IF  sy-subrc EQ 0.
            gst_final_out-bezei = gst_tvakt-bezei.
          ENDIF.
*- To Get Sales Org description
          READ TABLE gi_tvkot INTO gst_tvkot WITH KEY spras = sy-langu
                                                      vkorg = gst_vbpa-vkorg
                                         BINARY SEARCH.
          IF  sy-subrc EQ 0.
            gst_final_out-vtext = gst_tvkot-vtext.
          ENDIF.
*- To get Sold-to and name
          CLEAR gst_vbpa_tmp.
          READ TABLE gi_vbpa_tmp INTO gst_vbpa_tmp WITH KEY vbeln = gst_vbpa-vbeln
                                                            parvw = lc_sold_to
                                                   BINARY SEARCH.
          IF  sy-subrc EQ 0.
            CLEAR gst_kna1.
            READ TABLE gi_kna1 INTO gst_kna1 WITH KEY kunnr = gst_vbpa_tmp-kunnr
                                            BINARY SEARCH.
            IF sy-subrc EQ 0.
              gst_final_out-kunnr   = gst_kna1-kunnr.
              gst_final_out-sold_name = gst_kna1-name1.
            ENDIF.
          ENDIF.
*- To get Ship-to and Name
          CLEAR gst_vbpa_tmp.
          READ TABLE gi_vbpa_tmp INTO gst_vbpa_tmp WITH KEY vbeln = gst_vbpa-vbeln
                                                            kunnr = gst_price_data-kunwe
                                                            parvw = lc_ship_to.
          IF sy-subrc EQ 0.
            CLEAR gst_kna1.
            READ TABLE gi_kna1 INTO gst_kna1 WITH KEY kunnr = gst_vbpa_tmp-kunnr
                                            BINARY SEARCH.
            IF sy-subrc EQ 0.
              gst_final_out-kunwe     = gst_kna1-kunnr.
              gst_final_out-ship_name = gst_kna1-name1.
              gst_final_out-katr8     = gst_kna1-katr8.
              IF lv_hits LE  p_hits.
                APPEND gst_final_out TO gi_final_out.
                CONTINUE.
                CLEAR gst_final_out.
              ELSE.
                APPEND gst_final_out TO gi_final_out.
                CLEAR gst_final_out.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
        ENDIF.
      ELSE.
      ENDIF.
      CLEAR :gst_final_out,gst_kna1,gst_vbpa,gst_tvkot,gst_tvakt.
    ENDLOOP.
    CLEAR :gst_final_out,gst_kna1,gst_vbpa,gst_tvkot,gst_tvakt.
  ENDLOOP.
  DELETE gi_final_out WHERE vbeln EQ space.
  SORT gi_final_out BY kunwe matnr kbetr vbeln.
  DELETE ADJACENT DUPLICATES FROM gi_final_out COMPARING kunwe matnr kbetr vbeln.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DISABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_disable .

  LOOP AT SCREEN.
    IF screen-name = 'P_KSCHL' OR screen-name = 'P_KOTABN'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_dynamics .
* Type Declaration
  TYPES:
    BEGIN OF ty_zcaconstant,
      devid    TYPE zdevid,                                       "Development ID
      param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
      param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
      srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
      sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
      opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
      low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
      high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
      activate TYPE zconstactive,                                 "Activation indicator for constant
    END OF ty_zcaconstant.

* Local Variables Declaration
  DATA:
    li_const_v  TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0,
    lst_const_v TYPE ty_zcaconstant.

* Local Constants Declarations
  CONSTANTS:
    lc_id_r105   TYPE zdevid     VALUE 'R108',          " Development ID
    lc_cond_tab  TYPE rvari_vnam VALUE 'COND_TABLE',    " ABAP: Name of Variant Variable
    lc_cond_type TYPE rvari_vnam VALUE 'COND_TYPE'.     " ABAP: Name of Variant Variable

  CLEAR : p_kschl,p_kotabn.

* Fetch the constants
  SELECT devid                                                  "Development ID
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "ABAP: Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                    "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant                                            "Wiley Application Constant Table
    INTO TABLE li_const_v
    WHERE devid    EQ lc_id_r105
     AND  activate EQ abap_true.
  IF sy-subrc EQ 0.
    LOOP AT li_const_v INTO lst_const_v.
      CASE lst_const_v-param1.
*- Condition Table
        WHEN lc_cond_tab.
          p_kotabn = lst_const_v-low.
*- Condition type
        WHEN lc_cond_type.
          p_kschl = lst_const_v-low.
        WHEN OTHERS.
      ENDCASE.
      CLEAR: lst_const_v.
    ENDLOOP.
  ENDIF.
ENDFORM.
