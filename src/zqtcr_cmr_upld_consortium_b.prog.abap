*----------------------------------------------------------------------*
* PROGRAM NAME         : ZQTCR_CMR_UPLD_CONSORTIUM_B
* PROGRAM DESCRIPTION  : Program to read Appl file and Create CMR
*                        This Program has been submitted in the program ZQTCR_CMR_UPLD_CONSORTIUM
* DEVELOPER            : Prabhu(PTUFARAM)
* CREATION DATE:       : 14 June 2018
* OBJECT ID            :
* TRANSPORT NUMBER(S)  : ED2K912334
*----------------------------------------------------------------------*
REPORT zqtcr_cmr_upld_consortium_b NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.
TYPE-POOLS : slis.

TYPES:    BEGIN OF ty_crdt_memo_crt,
            customer TYPE kunnr,      " Customer Number
            parvw    TYPE parvw,      " Partner Function
            partner  TYPE kunnr,      " Customer Number
            vkorg    TYPE vkorg,      " Sales Organization
            vtweg    TYPE vtweg,      " Distribution Channel
            spart    TYPE spart,      " Division
            auart    TYPE auart,      " Sales Document Type
            xblnr    TYPE xblnr_v1,   " Reference Document Number
            vbtyp    TYPE vbtyp,      " Ref doc category
            zlsch    TYPE schzw_bseg, " Payment Method
            augru    TYPE augru,      " Order reason (reason for the business transaction)
            vbeln    TYPE vbeln_vf,   " Billing Document
            posnr    TYPE posnr_vf,   " Billing item
            matnr    TYPE matnr,      " Material Number
            zmeng    TYPE dzmeng,     " Target Quantity
            text     TYPE tdline,     " Name
            kbetr1   TYPE kwert,      " Rate (condition amount or percentage)
            kbetr2   TYPE kwert,      " Condition value
            kbetr3   TYPE kwert,      " Condition value
            discount TYPE kwert,      "Discount
            disc_per TYPE kbetr,      " Discount percentage
            vgbel    TYPE vgbel,      " Sales Document
            kdkg3    TYPE kdkg3,      " Customer condition group 3
            vkbur    TYPE vkbur,      " Sales Office
            bstnk    TYPE bstkd,      " Customer purchase order number
            ihrez_e  TYPE ihrez_e,      " Your Reference
            posex_e  TYPE posex_e,
            bsark    TYPE bsark,      " Customer purchase order type
          END OF ty_crdt_memo_crt.
TABLES: adr6.
DATA : i_final_crme_crt TYPE STANDARD TABLE OF ty_crdt_memo_crt.

PARAMETERS :  p_file TYPE string NO-DISPLAY.
SELECT-OPTIONS :p_mail FOR adr6-smtp_addr NO INTERVALS NO-DISPLAY.
************************************************************************
*                      START-OF-SELECTION                              *
************************************************************************
START-OF-SELECTION.
  REFRESH : i_final_crme_crt.
*&---------------------------------------------------------------------*
*  Below subroutine is used to read file which is placed from the program
*--ZQTCR_CMR_UPLD_CONSORTIUM
*----------------------------------------------------------------------*
  PERFORM f_read_from_app.
*&---------------------------------------------------------------------*
* Below subroutine is used to call create Credit memo request in the
* Program ZQTCR_CMR_UPLD_CONSORTIUM
*----------------------------------------------------------------------*
  PERFORM f_create_cmr.
*&---------------------------------------------------------------------*
*&      Form  READ_FROM_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_from_app .
  DATA : lv_string   TYPE string,
         lst_crememo TYPE ty_crdt_memo_crt,
         c_tab       TYPE abap_char1 VALUE cl_abap_char_utilities=>horizontal_tab,
         lv_zmneg    TYPE char16,
         lv_kbetr1   TYPE char15,
         lv_kbetr2   TYPE char15,
         lv_kbetr3   TYPE char15,
         lv_discount TYPE char15,
         lv_disc_per TYPE char15.
*--*Read Application server path
  OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2).
    LEAVE LIST-PROCESSING.
  ENDIF.
  DO.
    READ DATASET p_file INTO lv_string.
    IF sy-subrc EQ 0.
      SPLIT lv_string AT c_tab INTO lst_crememo-customer
                                    lst_crememo-parvw
                                    lst_crememo-partner
                                    lst_crememo-vkorg
                                    lst_crememo-vtweg
                                    lst_crememo-spart
                                    lst_crememo-auart
                                    lst_crememo-xblnr
                                    lst_crememo-vbtyp
                                    lst_crememo-zlsch
                                    lst_crememo-augru
                                    lst_crememo-vbeln
                                    lst_crememo-posnr
                                    lst_crememo-matnr
                                    lv_zmneg
                                    lst_crememo-text
                                    lv_kbetr1
                                    lv_kbetr2
                                    lv_kbetr3
                                    lv_discount
                                    lv_disc_per
                                    lst_crememo-vgbel
                                    lst_crememo-kdkg3
                                    lst_crememo-vkbur
                                    lst_crememo-bstnk
                                    lst_crememo-ihrez_e
                                    lst_crememo-posex_e
                                    lst_crememo-bsark.
      CONDENSE : lv_zmneg,lv_kbetr1,lv_kbetr2,lv_kbetr3.
      lst_crememo-zmeng = lv_zmneg.
      lst_crememo-kbetr1 = lv_kbetr1.
      lst_crememo-kbetr2 = lv_kbetr2.
      lst_crememo-kbetr3 = lv_kbetr3.
      lst_crememo-discount = lv_discount.
      lst_crememo-disc_per = lv_disc_per.
      APPEND lst_crememo TO i_final_crme_crt .
      CLEAR  lst_crememo .
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  CLOSE DATASET p_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_CMR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_cmr .
*  i_final_crme_crt[] = i_final_crme_cmr[].
  PERFORM f_fill_cmr IN PROGRAM zqtcr_cmr_consortium_i0354 TABLES i_final_crme_crt p_mail.
ENDFORM.
