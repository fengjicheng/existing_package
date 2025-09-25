FUNCTION zqtc_idoc_input_orders_zmbr.
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
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_IDOC_INPUT_ORDERS_ZMBR (Function Module)
* PROGRAM DESCRIPTION : This FM is used to create ZMBR documnet type
*                     : sales contracts by using BAPI. It has been
*                       assigned to process code ZQTC_ORD_ZMBR and which
*                       is copied from ORDE (ORDERS05) Message type.
* DEVELOPER           : Prabhu Kishore T
* CREATION DATE       : 6/8/2016
* OBJECT ID           : CR#6692
* TRANSPORT NUMBER(S) : ED2K912203
*---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K926316
* REFERENCE NO: OTCM-18549/44844
* DEVELOPER   : VDPATABALL
* DATE        : 03/25/2022
* DESCRIPTION : Adding Ship to Party Address and Name deatils to BAPI process code.
*----------------------------------------------------------------------*
*Decleration Local Variables
*----------------------------------------------------------------------*
  DATA : lst_data             TYPE edidd,  "Idoc data record
         lst_control          TYPE edidc,  "Idoc control record
         lst_e1edk01          TYPE e1edk01, "To capture Segment E1EDK01
         lst_e1edk14          TYPE e1edk14, "To capture Segment E1EDK14
         lst_e1edka1          TYPE e1edka1, "To capture Segment E1EDKA1
         lst_e1edk36          TYPE e1edk36, "To capture Segment E1EDK36
         lst_e1edkt1          TYPE e1edkt1, "To capture Segment E1EDKT1
         lst_e1edkt2          TYPE e1edkt2, "To capture Segment E1EDKT2
         lst_e1edp01          TYPE e1edp01, "To capture Segment E1EDP01
         lst_e1edp02          TYPE e1edp02, "To capture Segment E1EDP02
         lst_e1edp03          TYPE e1edp03, "To capture Segment E1EDP03
         lst_e1edp05          TYPE e1edp05, "To capture Segment E1EDP05
         lst_e1edpa1          TYPE e1edpa1, "To capture Segment E1EDPA1
         lst_e1edk02          TYPE e1edk02, "To capture Segment E1EDK02
         lst_e1edk03          TYPE e1edk03, "To capture Segment E1EDK03
         lst_e1edp19          TYPE e1edp19, "To capture Segment E1EDP19
         lst_e1edpt1          TYPE e1edpt1, "To capture Segment E1EDPT1
         lst_e1edpt2          TYPE e1edpt2, "To capture Segment E1EDPT2
         lst_e1edp35          TYPE e1edp35, "To capture Segment E1EDP35
         lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, "To capture Segment z1qtc_e1edk01_0
         lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01, "To capture Segment z1qtc_e1edp01_01
         lst_idoc_status      TYPE bdidocstat, ""To build Idoc status
         lv_vbeln             TYPE vbeln, "Sales doc number
         li_data              TYPE STANDARD TABLE OF edidd,
         li_header            TYPE STANDARD TABLE OF ty_header,
         lv_item              TYPE posnr,
         lv_error             TYPE char1.
*---------------------------------------------------------------------*
*Refresh Local Variables
*----------------------------------------------------------------------*
  CLEAR : lst_data,lst_control,lst_e1edk01,lst_e1edk14,lst_e1edka1,lst_e1edk36,lst_e1edkt1,
          lst_e1edkt2,lst_e1edp01,lst_e1edp02,lst_e1edp03,lst_e1edp05,lst_e1edpa1,
          lst_e1edk02,lst_e1edk03,lst_e1edp19,lst_e1edpt1,lst_e1edpt2,lst_e1edp35,
          lst_z1qtc_e1edk01_01,lst_z1qtc_e1edp01_01,lst_idoc_status,lv_vbeln.
  REFRESH : li_data,li_header,i_po.
*---------------------------------------------------------------------*
* Process IDOC Records
*----------------------------------------------------------------------*
*--*Process control record (Idocs one by one)
  LOOP AT idoc_contrl INTO lst_control.
    v_idoc = lst_control-docnum.
*--*Process data records of Idoc based on control record Idoc num.
    LOOP AT idoc_data INTO lst_data WHERE docnum = lst_control-docnum.
*---------------------------------------------------------------------*
* Capture IDOC header segments data
*----------------------------------------------------------------------*
      CASE lst_data-segnam.
        WHEN c_e1edk01.
          lst_e1edk01 = lst_data-sdata.
          st_header-crcy = lst_e1edk01-curcy.           "Currency
          st_header-zterm = lst_e1edk01-zterm.          "Payment Term
          st_header-lifsk = lst_e1edk01-lifsk.          "Delivery Block
        WHEN c_z1qtc_e1edk01.
          lst_z1qtc_e1edk01_01 = lst_data-sdata.
          st_header-submi = lst_z1qtc_e1edk01_01-submi.         "Submi

          st_header-zzlicyr = lst_z1qtc_e1edk01_01-zzlicyr.     "License year
        WHEN c_e1edk14.
          lst_e1edk14 = lst_data-sdata.
          CASE lst_e1edk14-qualf.
            WHEN c_qualf_012.
              st_header-doctype = lst_e1edk14-orgid.     "Sales Doc type
            WHEN c_qualf_008.
              st_header-sorg = lst_e1edk14-orgid.        "Sales Org
            WHEN c_qualf_007.
              st_header-dch = lst_e1edk14-orgid.         "D.channel
            WHEN c_qualf_006.
              st_header-division = lst_e1edk14-orgid.    "Division
            WHEN c_qualf_016.
              st_header-saleoff = lst_e1edk14-orgid.    "Sales office
            WHEN c_qualf_019.
              st_header-potype = lst_e1edk14-orgid.     "PO type at header
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edk02.
          lst_e1edk02 = lst_data-sdata.
          CASE lst_e1edk02-qualf.
            WHEN  c_qualf_001.
              st_header-po = lst_e1edk02-belnr.        "Customer PO
            WHEN OTHERS.
          ENDCASE.
*---------------------------------------------------------------------*
* Capture IDOC Partners segments Info
*----------------------------------------------------------------------*
        WHEN c_e1edka1.
          lst_e1edka1 = lst_data-sdata.
          st_partner-pf = lst_e1edka1-parvw.         "Partner funcion
          st_partner-partner = lst_e1edka1-partn.    "Partner
          IF st_partner-pf EQ c_pf_ag.
            st_header-name = lst_e1edka1-bname.      "Name in Order data
          ENDIF.
          IF st_partner-pf EQ c_pf_we.            "check Ship-to partner exists
*----------------------------------------------------------------------*
*  Validate Shipto
*----------------------------------------------------------------------*
            CLEAR : lv_error.
            PERFORM f_validate_shipto CHANGING lv_error.
            IF lv_error = abap_true.
              EXIT.
            ENDIF.
            st_header-ref_1_s = lst_e1edka1-ihrez.  "Your reference in Order data
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
            IF lst_e1edka1-name1 IS NOT INITIAL.
              st_partner-name1        = lst_e1edka1-name1. "Name1
            ENDIF.
            IF lst_e1edka1-name2 IS NOT INITIAL.
              st_partner-name2        = lst_e1edka1-name2. "name2
            ENDIF.
            IF lst_e1edka1-ort01 IS NOT INITIAL.
              st_partner-city         = lst_e1edka1-ort01. "City
            ENDIF.
            IF lst_e1edka1-counc IS NOT INITIAL.
              st_partner-country      = lst_e1edka1-counc. "Country
            ENDIF.
            IF lst_e1edka1-pstlz IS NOT INITIAL.
              st_partner-postl_code   = lst_e1edka1-pstlz. "Postal Code
            ENDIF.
            IF lst_e1edka1-regio IS NOT INITIAL.
              st_partner-region       = lst_e1edka1-regio. "Region
            ENDIF.
            IF lst_e1edka1-strs2 IS NOT INITIAL.
              st_partner-str_suppl2   = lst_e1edka1-strs2. "Street3
            ENDIF.
            IF lst_e1edka1-telbx IS NOT INITIAL.
              st_partner-telephone    = lst_e1edka1-telbx. "Telephone
            ENDIF.
            IF lst_e1edka1-stras IS NOT INITIAL.
              st_partner-street       = lst_e1edka1-stras. "Street
            ENDIF.
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
          ENDIF.
          APPEND st_partner TO i_partner.
          CLEAR st_partner.
*---------------------------------------------------------------------*
* Capture IDOC Credit card info segments data
*----------------------------------------------------------------------*
        WHEN c_e1edk36.
          lst_e1edk36 = lst_data-sdata.
          st_header-cardtype = lst_e1edk36-ccins.      "Credit card type
          st_header-cardnum  = lst_e1edk36-ccnum.      "Card Number
          st_header-cardname = lst_e1edk36-ccname.     "Name on card
          st_header-expdate = lst_e1edk36-exdatbi.     "Expiry date
        WHEN c_e1edk03.
          lst_e1edk03 = lst_data-sdata.
          CASE lst_e1edk03-iddat.
            WHEN c_qualf_022. "PO date VBKD-BSTDK
              st_header-podate = lst_e1edk03-datum.         "Requested PO date
            WHEN c_qualf_016. "Billing date VBAK-FKDAT
*              st_header-billdate = lst_e1edk03-datum.         "Requested bill date
            WHEN c_qualf_002. "Requested del date VBAK-VDATU
              st_header-reqdate = lst_e1edk03-datum.         "Requested del.date
            WHEN c_qualf_026. "VBKD-AFDAT
              st_header-billdate = lst_e1edk03-datum.
            WHEN OTHERS.
          ENDCASE.

*---------------------------------------------------------------------*
* Capture IDOC text info at header level segments data
*----------------------------------------------------------------------*
        WHEN c_e1edkt1.
          lst_e1edkt1 = lst_data-sdata.
          st_text-tdid = lst_e1edkt1-tdid.            "Text Id
        WHEN c_e1edkt2.
          lst_e1edkt2 = lst_data-sdata.
          st_text-text = lst_e1edkt2-tdline.          "Text
          st_text-format = lst_e1edkt2-tdformat.      "Text format
          APPEND st_text TO i_text.
*          CLEAR st_text.
          CLEAR: st_text-text,st_text-format.
*---------------------------------------------------------------------*
* Capture IDOC Item level segments data
*----------------------------------------------------------------------*
        WHEN c_e1edp01.
          CLEAR : st_item.
          lst_e1edp01 = lst_data-sdata.
          ADD 10 TO lv_item.
          st_item-item = lv_item.                    "Item
          st_item-poitem = lst_e1edp01-posex.        "PO item
          st_item-menge = lst_e1edp01-menge.         "Quantity
          st_item-pstyv = lst_e1edp01-pstyv.         "PO Item category
          APPEND st_item TO i_item.
*---------------------------------------------------------------------*
* Capture IDOC Item level Additional segments data
*----------------------------------------------------------------------*
        WHEN c_z1qtc_e1edp01_01.
          lst_z1qtc_e1edp01_01 = lst_data-sdata.
          st_item_cust-vposn = st_item-item.                   " Item
          st_item_cust-vbegdat = lst_z1qtc_e1edp01_01-vbegdat. "Contract start date
          st_item_cust-venddat = lst_z1qtc_e1edp01_01-venddat. "Contract end date
          st_item_cust-zzcontent_start_d = lst_z1qtc_e1edp01_01-zzcontent_start_d. "Content start date
          st_item_cust-zzcontent_end_d = lst_z1qtc_e1edp01_01-zzcontent_end_d.     "Content end date
          st_item_cust-zzlicense_start_d = lst_z1qtc_e1edp01_01-zzlicense_start_d. "License start date
          st_item_cust-zzlicense_end_d = lst_z1qtc_e1edp01_01-zzlicense_end_d.     "License end date
          st_item_cust-zzclustyp = lst_z1qtc_e1edp01_01-zzclustyp.
          st_item_cust-zzdealtyp = lst_z1qtc_e1edp01_01-zzdealtyp.
          APPEND st_item_cust TO i_item_cust.
          CLEAR st_item_cust.
        WHEN c_e1edp02.
          lst_e1edp02 = lst_data-sdata.
          CASE lst_e1edp02-qualf.
            WHEN c_qualf_44.
              st_poitem-item = st_item-item.           "PO Item
              st_poitem-zeile = lst_e1edp02-zeile.      "Item at Shipito party PO
              APPEND st_poitem TO i_poitem.
              CLEAR st_poitem.
            WHEN c_qualf_001.
*              st_item-date = lst_e1edp02-datum.
            WHEN OTHERS.
          ENDCASE.
        WHEN c_e1edp03.
          lst_e1edp03 = lst_data-sdata.
          st_item_date-item = st_item-item.          "Item
          CASE lst_e1edp03-iddat.
            WHEN c_qualf_026.
              st_item_date-billdate = lst_e1edp03-datum.
            WHEN c_qualf_022. "PO date VBKD-BSTDK
              st_item_date-podate = lst_e1edp03-datum.         "Requested PO date
            WHEN c_qualf_016. "Billing date VBAK-FKDAT
*              st_item_date-billdate = lst_e1edp03-datum.
            WHEN OTHERS.
          ENDCASE.
          APPEND st_item_date TO i_item_date.
          CLEAR : st_item_date.
*---------------------------------------------------------------------*
* Capture IDOC Item level Pricing segments data
*----------------------------------------------------------------------*
        WHEN c_e1edp05.
          lst_e1edp05 = lst_data-sdata.
          st_cond-item = st_item-item.               "Item
          st_cond-kschl = lst_e1edp05-kschl.         "Condition type
          st_cond-betrg = lst_e1edp05-betrg.         "Price
          APPEND st_cond TO i_cond.
          CLEAR st_cond.
*---------------------------------------------------------------------*
* Capture IDOC Item level Partners segments data
*----------------------------------------------------------------------*
        WHEN c_e1edpa1.
          lst_e1edpa1 = lst_data-sdata.
          st_partner-item = st_item-item.        "PO Item
          st_partner-pf = lst_e1edpa1-parvw.      "Partner function
          st_partner-partner = lst_e1edpa1-partn. "Partner
          st_partner-ref_1_s = lst_e1edpa1-ihrez. "Your ref
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
          IF st_partner-pf  EQ c_pf_we.            "check Ship-to partner exists
            IF lst_e1edpa1-name1 IS NOT INITIAL.
              st_partner-name1        = lst_e1edpa1-name1. "Name1
            ENDIF.
            IF lst_e1edpa1-name2 IS NOT INITIAL.
              st_partner-name2        = lst_e1edpa1-name2. "name2
            ENDIF.
            IF lst_e1edpa1-ort01 IS NOT INITIAL.
              st_partner-city         = lst_e1edpa1-ort01. "City
            ENDIF.
            IF lst_e1edpa1-counc IS NOT INITIAL.
              st_partner-country      = lst_e1edpa1-counc. "Country
            ENDIF.
            IF lst_e1edpa1-pstlz IS NOT INITIAL.
              st_partner-postl_code   = lst_e1edpa1-pstlz. "Postal Code
            ENDIF.
            IF lst_e1edpa1-regio IS NOT INITIAL.
              st_partner-region       = lst_e1edpa1-regio. "Region
            ENDIF.
            IF lst_e1edpa1-strs2 IS NOT INITIAL.
              st_partner-str_suppl2   = lst_e1edpa1-strs2. "Street3
            ENDIF.
            IF lst_e1edpa1-telbx IS NOT INITIAL.
              st_partner-telephone    = lst_e1edpa1-telbx. "Telephone
            ENDIF.
            IF lst_e1edpa1-stras IS NOT INITIAL.
              st_partner-street       = lst_e1edpa1-stras. "Street
            ENDIF.
          ENDIF.
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
          APPEND st_partner TO i_partner.

          CLEAR st_partner.
*---------------------------------------------------------------------*
* Capture IDOC Item level Material segments data
*----------------------------------------------------------------------*
        WHEN c_e1edp19.
          lst_e1edp19 = lst_data-sdata.
          CASE lst_e1edp19-qualf.
            WHEN c_qalf_002.
              st_mat-item = st_item-item.       "Item
              st_mat-matnr = lst_e1edp19-idtnr.  "Material
              CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                EXPORTING
                  input        = st_mat-matnr
                IMPORTING
                  output       = st_mat-matnr
                EXCEPTIONS
                  length_error = 1
                  OTHERS       = 2.
              IF sy-subrc <> 0.
*                MESSAGE text-002 TYPE c_e.
              ENDIF.
              APPEND st_mat TO i_mat.
              CLEAR st_mat.
            WHEN c_qalf_001.
              st_mat-item = st_item-item.      "Item
              st_mat-kdmat = lst_e1edp19-idtnr. "Customer Material
              APPEND st_mat TO i_mat.
              CLEAR st_mat.
            WHEN OTHERS.
          ENDCASE.
*---------------------------------------------------------------------*
* Capture IDOC Item level Additional DATA A segments data
*----------------------------------------------------------------------*
        WHEN c_e1edp35.
          lst_e1edp35 = lst_data-sdata.
          st_item_add-item = st_item-item.
          CASE lst_e1edp35-qualz.
            WHEN c_qualf_001.
              st_item_add-mvgr1 = lst_e1edp35-cusadd.  "mat Price group 1
              APPEND st_item_add TO i_item_add.
              CLEAR st_item_add.
            WHEN c_qualf_002.
              st_item_add-mvgr2 = lst_e1edp35-cusadd.  "mat Price group 1
              APPEND st_item_add TO i_item_add.
              CLEAR st_item_add.
            WHEN c_qualf_003.
              st_item_add-mvgr3 = lst_e1edp35-cusadd.     "Mat price group3
              APPEND st_item_add TO i_item_add.
              CLEAR st_item_add.
*            WHEN c_qualf_005.
*              st_item_add-cusadd = lst_e1edp35-cusadd.     "Price grp3
*              APPEND st_item_add TO i_item_add.
*              CLEAR st_item_add.
            WHEN c_qualf_009.
              st_item_add-kdkg4 = lst_e1edp35-cusadd.     "Cust Price grp4
              APPEND st_item_add TO i_item_add.
              CLEAR st_item_add.
            WHEN c_qualf_010.
              st_item_add-kdkg5 = lst_e1edp35-cusadd. "Customer group5
              APPEND st_item_add TO i_item_add.
              CLEAR st_item_add.
            WHEN OTHERS.
          ENDCASE.
*---------------------------------------------------------------------*
* Capture IDOC Item level Text segments data
*----------------------------------------------------------------------*
        WHEN c_e1edpt1.
          lst_e1edpt1 = lst_data-sdata.
          st_text-item = st_item-item.           "PO Item
          st_text-tdid = lst_e1edpt1-tdid.        "Text ID
        WHEN c_e1edpt2.
          lst_e1edpt2 = lst_data-sdata.
          st_text-text = lst_e1edpt2-tdline.      "Text
          st_text-format = lst_e1edpt2-tdformat.  "Text format
          APPEND st_text TO i_text.
          CLEAR : st_text.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
    CLEAR : lv_item.
    SORT : i_item BY item,i_item_add BY item,i_poitem BY item,i_item_date BY item, i_partner BY item.
*---------------------------------------------------------------------*
* This subroutene is used to Process ZMBR contract
*----------------------------------------------------------------------*
    IF lv_error IS INITIAL.
      PERFORM f_create_contract_zmbr.
    ENDIF.
*---------------------------------------------------------------------*
* Refresh and clear global variables
*----------------------------------------------------------------------*
    REFRESH : i_item,i_partner,i_cond,i_text,i_item_add,i_mat,i_item_date,i_item,i_item_cust,i_poitem.
    CLEAR : st_header,st_partner,st_text,st_item,st_cond,st_mat,st_item_cust,st_poitem,st_item_date,
            st_item_add,v_doc, lv_error.
  ENDLOOP.
ENDFUNCTION.
