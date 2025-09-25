*&---------------------------------------------------------------------*
*&  Include           ZRTRN_CR_ACK_ADD_I0229
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ZCR_IDOC_ACK_VALID_I0229(FM)
* PROGRAM DESCRIPTION: Restrict O/P Type ZCR based on conditions
* DEVELOPER          : Prabhu
* CREATION DATE      : 2019-06-07
* OBJECT ID          : I0229 (ERP-7664)
* TRANSPORT NUMBER(S): ED2K915222
*----------------------------------------------------------------------*
TYPES : BEGIN OF ty_vbkd,
          ihrez   TYPE ihrez,     "Your ref soldto
          ihrez_e TYPE ihrez_e, "Your ref shipto
        END OF ty_vbkd.
DATA : lv_subrc       TYPE sy-subrc,
       li_const       TYPE zcat_constants,
       lv_cr          TYPE c,
       lv_index       TYPE i,
       lv_index_zsub  TYPE i,
       lv_vgbel       TYPE vgbel,
       lv_auart_cr    TYPE auart,
       lir_cond_type  TYPE kschl_ran_tab,
       lst_cond_type  LIKE LINE OF lir_cond_type,
       lst_vbkd       TYPE ty_vbkd,
       lst_e1edp01_cr TYPE e1edp01,
       lst_e1edpa1_cr TYPE e1edpa1,
       lst_e1edka1_cr TYPE e1edka1,
       li_e1edp05_cr  TYPE STANDARD TABLE OF e1edp05,
       lst_e1edk02_cr TYPE e1edk02,
       lst_e1edp05_cr TYPE e1edp05. " IDoc: Document Item General Data.
CONSTANTS : lc_cond_type   TYPE rvari_vnam VALUE 'COND_TYPE',
            lc_e1edp05_cr  TYPE char7 VALUE 'E1EDP05',
            lc_e1edp01_cr  TYPE char7 VALUE 'E1EDP01',
            lc_e1edka1_cr  TYPE char7 VALUE 'E1EDKA1',
            lc_e1edk02_cr  TYPE char7 VALUE 'E1EDK02',
            lc_e1edpa1_cr  TYPE char7 VALUE 'E1EDPA1',
            lc_posnr_hdr   TYPE char6 VALUE '000000',
            lc_posnr_first TYPE char6 VALUE '000010',
            lc_ve_parvw    TYPE parvw VALUE 'VE',
            lc_ag_parvw    TYPE parvw VALUE 'AG',
            lc_we_parvw    TYPE parvw VALUE 'WE',
            lc_auart_zmbr  TYPE auart VALUE 'ZMBR',
            lc_param_b     TYPE rvari_vnam VALUE 'CR'.
*--*Get Constants
CALL FUNCTION 'ZQTC_ZCR_IDOC_ACK_VALID_I0229'
  EXPORTING
    im_vbak  = dxvbak
  IMPORTING
    ex_subrc = lv_subrc
    ex_cr    = lv_cr
    ex_const = li_const.
*--*build additional constants
IF lv_subrc IS INITIAL AND lv_cr EQ abap_true.
  LOOP AT li_const INTO DATA(lst_const) WHERE param1 = lc_cond_type
                                           AND param2 = lc_param_b.

    lst_cond_type-sign   = lst_const-sign.
    lst_cond_type-option = lst_const-opti.
    lst_cond_type-low    = lst_const-low.
    lst_cond_type-high   = lst_const-high.
    APPEND lst_cond_type TO lir_cond_type.
    CLEAR lst_cond_type.
  ENDLOOP.
*** Describing IDOC Data Table
  DESCRIBE TABLE int_edidd LINES lv_index.
*** Reading last record of IDOC Data Table
  READ TABLE int_edidd INTO DATA(lst_data) INDEX lv_index.
  IF sy-subrc = 0.
    CASE lst_data-segnam.
      WHEN 'E1EDP01'.
        lst_e1edp01_cr = lst_data-sdata.
*--*Get ZSUB document number
        READ TABLE int_edidd INTO DATA(lst_zsub) WITH KEY segnam = lc_e1edk02_cr.
        IF sy-subrc EQ 0.
          lv_index_zsub = sy-tabix.
          lst_e1edk02_cr = lst_zsub-sdata.
          IF lst_e1edp01_cr-posex = lc_posnr_first.
            CASE lst_e1edk02_cr-qualf.
              WHEN '001'.
*--* Reference document for the first item which is Invoice
                READ TABLE dxvbap INTO DATA(lst_dxvbap) WITH KEY posnr = lst_e1edp01_cr-posex.
                IF sy-subrc EQ 0.
*--* Reference document for the invoice document which is ZSUB
                  SELECT SINGLE vgbel FROM vbrp INTO lv_vgbel WHERE vbeln = lst_dxvbap-vgbel
                                                                AND posnr = lst_dxvbap-vgpos.
                  IF sy-subrc EQ 0.
                    lst_e1edk02_cr-belnr = lv_vgbel.
                    lst_data-sdata = lst_e1edk02_cr.
                    MODIFY int_edidd FROM lst_data INDEX lv_index_zsub TRANSPORTING sdata.
                  ENDIF.
                ENDIF.
              WHEN OTHERS.
            ENDCASE.
          ENDIF.
        ENDIF.
*--* Get Legacy reference Info for ZSUB
        IF lv_vgbel IS NOT INITIAL AND lst_e1edp01_cr-posex = lc_posnr_first.
          SELECT SINGLE ihrez ihrez_e FROM vbkd INTO lst_vbkd WHERE vbeln = lv_vgbel
                                                               AND posnr = lc_posnr_hdr.
          IF sy-subrc EQ 0.
            LOOP AT int_edidd INTO DATA(lst_legacy) WHERE segnam = lc_e1edka1_cr.
              lst_e1edka1_cr = lst_legacy-sdata.
*--*Pass your reference to Partner Sold to
              CASE lst_e1edka1_cr-parvw.
                WHEN lc_ag_parvw.
                  lst_e1edka1_cr-ihrez = lst_vbkd-ihrez.
                  lst_data-sdata = lst_e1edka1_cr.
                  MODIFY int_edidd FROM lst_data INDEX sy-tabix TRANSPORTING sdata.
*--*Pass your reference to Partner Ship to
                WHEN lc_we_parvw.
                  lst_e1edka1_cr-ihrez = lst_vbkd-ihrez_e.
                  lst_data-segnam = lc_e1edka1_cr.
                  lst_data-sdata = lst_e1edka1_cr.
                  MODIFY int_edidd FROM lst_data INDEX sy-tabix TRANSPORTING sdata.
                WHEN OTHERS.
              ENDCASE.
            ENDLOOP.
          ENDIF.
        ENDIF.
      WHEN 'E1EDPA1'.
        lst_e1edpa1_cr = lst_data-sdata.
*--*Get latest Item number
        LOOP AT int_edidd INTO DATA(lst_data1) WHERE segnam = lc_e1edp01_cr.
          lst_e1edp01_cr = lst_data1-sdata.
        ENDLOOP.
*--*Get Legacy reference info of ZMBR mapping
*--*Ship-to
        IF lst_e1edpa1_cr-parvw = lc_we_parvw.
*--* Reference document for the each item
          READ TABLE dxvbap INTO DATA(lst_dxvbap_item) WITH KEY posnr = lst_e1edp01_cr-posex.
          IF sy-subrc EQ 0.
*--* Reference document type
            CLEAR : lv_auart.
            SELECT SINGLE auart FROM vbak INTO lv_auart_cr WHERE vbeln = lst_dxvbap_item-vgbel.
*--*Check if it is ZMBR
            IF sy-subrc EQ 0 AND lv_auart_cr = lc_auart_zmbr.
              READ TABLE dxvbkd INTO DATA(lst_dxvbkd_item) WITH KEY vbeln = dxvbak-vbeln
                                                                    posnr = lst_e1edp01_cr-posex.
              IF sy-subrc EQ 0.
                lst_e1edpa1_cr-ihrez = lst_dxvbkd_item-ihrez_e.
                lst_data-segnam = lc_e1edpa1_cr.
                lst_data-sdata =  lst_e1edpa1_cr.
                MODIFY int_edidd FROM lst_data INDEX lv_index TRANSPORTING sdata.
              ENDIF.
            ENDIF.
          ENDIF.
*--*Populate extra conditions info
          FREE : li_e1edp05_cr.
          LOOP AT lir_cond_type INTO lst_cond_type.
            READ TABLE dikomv INTO DATA(lst_komv) WITH KEY kposn = lst_e1edp01_cr-posex
                                                           kschl = lst_cond_type-low.
            IF sy-subrc EQ 0.
              lst_e1edp05_cr-kschl = lst_cond_type-low.
              lst_e1edp05_cr-betrg = lst_komv-kwert.
              lst_e1edp05_cr-preis = lst_komv-kpein.
              CONDENSE : lst_e1edp05_cr-betrg,lst_e1edp05_cr-preis.
              lst_data-segnam = lc_e1edp05_cr.
              lst_data-sdata =  lst_e1edp05_cr.
              INSERT lst_data INTO int_edidd INDEX lv_index." - 1.
              CLEAR lst_data.
            ENDIF.
          ENDLOOP.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.
ENDIF.
