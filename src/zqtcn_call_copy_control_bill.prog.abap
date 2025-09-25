*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCEI_CALL_COPY_CONTROL
* PROGRAM DESCRIPTION: This enhancement will copy changes from Billing into
* Sales Documents .
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CALL_COPY_CONTROL_BILL
*&---------------------------------------------------------------------*
DATA:
  lst_bill_hdr TYPE vbrk,
  lst_bill_itm TYPE vbrp,
  lst_sls_item TYPE vbap.

DATA:
  lv_form_name TYPE char20.

CONSTANTS:
  lc_inv_cr_db TYPE char3  VALUE 'MOP',                    "Invoice / Credit Memo / Debit Memo
  lc_form_name TYPE char15 VALUE 'DATEN_KOPIEREN_'.

IF vbap-vgtyp CA lc_inv_cr_db.                             "Invoice / Credit Memo / Debit Memo

  IF cvbrk-vbeln NE vbap-vgbel.
*   Selection of Billing document header
    CALL FUNCTION 'WLF_SD_VBRK_READ'
      EXPORTING
        i_vbeln   = vbap-vgbel                             "Sales and Distribution Document Number
      IMPORTING
        e_vbrk    = lst_bill_hdr                           "Billing document header
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_bill_hdr TO cvbrk.
    ENDIF.
  ENDIF.

  IF cvbrp-vbeln NE vbap-vgbel OR
     cvbrp-posnr NE vbap-vgpos.
*   Selection of Billing document item
    CALL FUNCTION 'WLF_SD_VBRP_READ'
      EXPORTING
        i_vbeln   = vbap-vgbel                             "Sales and Distribution Document Number
        i_posnr   = vbap-vgpos                             "Item number of the SD document
      IMPORTING
        e_vbrp    = lst_bill_itm                           "Billing document item
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_bill_itm TO cvbrp.
    ENDIF.
  ENDIF.

* Sales Documents: Copying Control
  CALL FUNCTION 'CSO_O_SD_TVCPA_GET'
    EXPORTING
      pi_auarn = vbak-auart                                "Copy control: Target sales document type
      pi_auarv = cvbak-auart                               "Copy control: Source of sales document type
      pi_fkarv = cvbrk-fkart                               "Copy control: Source Billing type
      pi_pstyv = cvbrp-pstyv                               "Reference item category
    IMPORTING
      pe_tvcpa = ptvcpa.                                   "Sales Documents: Copying Control

  IF ptvcpa-gruap IS INITIAL.                              "Copying requirements for data transfer VBAP
    MESSAGE a472 WITH 'VBAP'.
  ELSE.
    lst_sls_item = vbap.

*   Build the complete Data Transfer Routine Name
    CONCATENATE lc_form_name
                ptvcpa-gruap
           INTO lv_form_name.
    CONDENSE lv_form_name.
*   Call Data Transfer Routine
    PERFORM (lv_form_name) IN PROGRAM sapfv45c.

*   Populate back the fields, not required to be substituted
    vbap-vbeln = lst_sls_item-vbeln.                       "Sales Document
    vbap-posnr = lst_sls_item-posnr.                       "Sales Document Item
    vbap-vgtyp = lst_sls_item-vgtyp.                       "Document category of preceding SD document
    vbap-vgbel = lst_sls_item-vgbel.                       "Document number of the reference document
    vbap-vgpos = lst_sls_item-vgpos.                       "Item number of the reference item
    vbap-vgref = lst_sls_item-vgref.                       "Preceding document has resulted from reference
    vbap-voref = lst_sls_item-voref.                       "Complete reference indicator
    vbap-upflu = lst_sls_item-upflu.                       "Update indicator for sales document document flow
  ENDIF.
ENDIF.
