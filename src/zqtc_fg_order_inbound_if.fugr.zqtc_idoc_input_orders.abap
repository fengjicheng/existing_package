FUNCTION zqtc_idoc_input_orders.
*"----------------------------------------------------------------------
*"*"Global Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWFAP_PAR-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWFAP_PAR-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"     VALUE(DOCUMENT_NUMBER) LIKE  VBAK-VBELN
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"      EDI_TEXT STRUCTURE  EDIORDTXT1 OPTIONAL
*"      EDI_TEXT_LINES STRUCTURE  EDIORDTXT2 OPTIONAL
*"----------------------------------------------------------------------
  DATA : lst_data             TYPE edidd,
         lst_control          TYPE edidc,
         lst_e1edk01          TYPE e1edk01,
         lst_e1edk14          TYPE e1edk14,
         lst_e1edka1          TYPE e1edka1,
         lst_e1edk36          TYPE e1edk36,
         lst_e1edkt1          TYPE e1edkt1,
         lst_e1edkt2          TYPE e1edkt2,
         lst_e1edp01          TYPE e1edp01,
         lst_e1edp02          TYPE e1edp02,
         lst_e1edp03          TYPE e1edp03,
         lst_e1edp05          TYPE e1edp05,
         lst_e1edpa1          TYPE e1edpa1,
         lst_e1edk02          TYPE e1edk02,
         lst_e1edk03          TYPE e1edk03,
         lst_e1edp19          TYPE e1edp19,
         lst_e1edpt1          TYPE e1edpt1,
         lst_e1edpt2          TYPE e1edpt2,
         lst_e1edp35          TYPE e1edp35,
         lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01,
         lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01.

  PERFORM f_initialize_variables.

  LOOP AT idoc_contrl INTO lst_control.
    gv_idoc = lst_control-docnum.
    LOOP AT idoc_data INTO lst_data WHERE docnum = lst_control-docnum.
      CASE lst_data-segnam.
        WHEN c_e1edk01.
          lst_e1edk01 = lst_data-sdata.
          gst_header-crcy = lst_e1edk01-curcy.
          gst_header-zterm = lst_e1edk01-zterm.
          gst_header-lifsk = lst_e1edk01-lifsk.
        WHEN c_z1qtc_e1edk01.
          lst_z1qtc_e1edk01_01 = lst_data-sdata.
          gst_header-submi = lst_z1qtc_e1edk01_01-submi.
        WHEN c_e1edk14.
          lst_e1edk14 = lst_data-sdata.
          CASE lst_e1edk14-qualf.
            WHEN c_qualf_012.
              gst_header-doctype = lst_e1edk14-orgid.
            WHEN c_qualf_008.
              gst_header-sorg = lst_e1edk14-orgid.
            WHEN c_qualf_007.
              gst_header-dch = lst_e1edk14-orgid.
            WHEN c_qualf_006.
              gst_header-division = lst_e1edk14-orgid.
            WHEN c_qualf_016.
              gst_header-saleoff = lst_e1edk14-orgid.
            WHEN c_qualf_019.
              gst_header-potype = lst_e1edk14-orgid.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edk02.
          lst_e1edk02 = lst_data-sdata.
          CASE lst_e1edk02-qualf.
            WHEN  c_qualf_001.
              gst_header-po = lst_e1edk02-belnr.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edka1.
          lst_e1edka1 = lst_data-sdata.
          gst_partner-pf = lst_e1edka1-parvw.
          gst_partner-partner = lst_e1edka1-partn.
          IF gst_partner-pf EQ c_pf_ag.
            gst_header-name = lst_e1edka1-bname.
          ENDIF.
          IF gst_partner-pf EQ c_pf_we.
            gst_header-ref_1_s = lst_e1edka1-ihrez.
          ENDIF.
          APPEND gst_partner TO gi_partner.
          CLEAR gst_partner.
        WHEN c_e1edk36.
          lst_e1edk36 = lst_data-sdata.
          gst_header-cardtype = lst_e1edk36-ccins.
          gst_header-cardnum  = lst_e1edk36-ccnum.
          gst_header-cardname = lst_e1edk36-ccname.
          gst_header-expdate = lst_e1edk36-exdatbi.
        WHEN c_e1edk03.
          lst_e1edk03 = lst_data-sdata.
          gst_header-date = lst_e1edk03-datum.
        WHEN c_e1edkt1.
          lst_e1edkt1 = lst_data-sdata.
          gst_text-tdid = lst_e1edkt1-tdid.
        WHEN c_e1edkt2.
          lst_e1edkt2 = lst_data-sdata.
          gst_text-text = lst_e1edkt2-tdline.
          gst_text-format = lst_e1edkt2-tdformat.
          APPEND gst_text TO gi_text.
          CLEAR gst_text.
        WHEN c_e1edp01.
          lst_e1edp01 = lst_data-sdata.
          gst_item-item = lst_e1edp01-posex.
          gst_item-menge = lst_e1edp01-menge.
          gst_item-pstyv = lst_e1edp01-pstyv.
          APPEND gst_item TO gi_item.
        WHEN c_z1qtc_e1edp01_01.
          lst_z1qtc_e1edp01_01 = lst_data-sdata.
          gst_item_cust-vposn = lst_z1qtc_e1edp01_01-vposn.
          gst_item_cust-vbegdat = lst_z1qtc_e1edp01_01-vbegdat.
          gst_item_cust-venddat = lst_z1qtc_e1edp01_01-venddat.
          gst_item_cust-zzcontent_start_d = lst_z1qtc_e1edp01_01-zzcontent_start_d.
          gst_item_cust-zzcontent_end_d = lst_z1qtc_e1edp01_01-zzcontent_end_d.
          gst_item_cust-zzlicense_start_d = lst_z1qtc_e1edp01_01-zzlicense_start_d.
          gst_item_cust-zzlicense_end_d = lst_z1qtc_e1edp01_01-zzlicense_end_d.
          APPEND gst_item_cust TO gi_item_cust.
          CLEAR gst_item_cust.
        WHEN c_e1edp02.
          lst_e1edp02 = lst_data-sdata.
          CASE lst_e1edp02-qualf.
            WHEN c_qualf_44.
              gst_poitem-item = gst_item-item.
              gst_poitem-zeile = lst_e1edp02-zeile.
              APPEND gst_poitem TO gi_poitem.
              CLEAR gst_poitem.
            WHEN c_qualf_001.
*              st_item-date = lst_e1edp02-datum.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edp03.
          lst_e1edp03 = lst_data-sdata.
          gst_item_date-item = gst_item-item.
          gst_item_date-date = lst_e1edp03-datum.
          APPEND gst_item_date TO gi_item_date.
          CLEAR : gst_item_date.
        WHEN c_e1edp05.
          lst_e1edp05 = lst_data-sdata.
          gst_cond-item = gst_item-item.
          gst_cond-kschl = lst_e1edp05-kschl.
          gst_cond-betrg = lst_e1edp05-betrg.
          APPEND gst_cond TO gi_cond.
          CLEAR gst_cond.
        WHEN c_e1edpa1.
          lst_e1edpa1 = lst_data-sdata.
          gst_partner-item = gst_item-item.
          gst_partner-pf = lst_e1edpa1-parvw.
          gst_partner-partner = lst_e1edpa1-partn.
          APPEND gst_partner TO gi_partner.
          CLEAR gst_partner.
        WHEN c_e1edp19.
          lst_e1edp19 = lst_data-sdata.
          CASE lst_e1edp19-qualf.
            WHEN c_qalf_002.
              gst_mat-item = gst_item-item.
              gst_mat-matnr = lst_e1edp19-idtnr.
              APPEND gst_mat TO gi_mat.
              CLEAR gst_mat.
            WHEN c_qalf_001.
              gst_mat-item = gst_item-item.
              gst_mat-kdmat = lst_e1edp19-idtnr.
              APPEND gst_mat TO gi_mat.
              CLEAR gst_mat.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edp35.
          lst_e1edp35 = lst_data-sdata.
          gst_item_add-item = gst_item-item.
          CASE lst_e1edp35-qualz.
            WHEN c_qualf_001.
              gst_item_add-prc_group1 = lst_e1edp35-cusadd.
              APPEND gst_item_add TO gi_item_add.
              CLEAR gst_item_add.
            WHEN c_qualf_005.
              gst_item_add-cusadd = lst_e1edp35-cusadd.
              APPEND gst_item_add TO gi_item_add.
              CLEAR gst_item_add.
            WHEN c_qualf_010.
              gst_item_add-cstcndgrp5 = lst_e1edp35-cusadd.
              APPEND gst_item_add TO gi_item_add.
              CLEAR gst_item_add.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edpt1.
          lst_e1edpt1 = lst_data-sdata.
          gst_text-item = gst_item-item.
          gst_text-tdid = lst_e1edpt1-tdid.
        WHEN c_e1edpt2.
          lst_e1edpt2 = lst_data-sdata.
          gst_text-text = lst_e1edpt2-tdline.
          gst_text-format = lst_e1edpt2-tdformat.
          APPEND gst_text TO gi_text.
          CLEAR gst_text.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    PERFORM f_create_contract_zsub.
    IF gv_doc IS NOT INITIAL.
      PERFORM f_create_contract_zmbr.
    ENDIF.
    REFRESH : gi_item,gi_partner,gi_cond,gi_text,gi_item_add,gi_item_date,gi_item,gi_item_cust,gi_poitem.
    CLEAR : gst_header,gv_doc.

  ENDLOOP.
ENDFUNCTION.
