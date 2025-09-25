*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTRICT_PROFORMA_CREATE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_RESTRICT_PROFORMA_CREATE (Include)
*                      [Copying Requirement Billing Doc Routine - 902]
* PROGRAM DESCRIPTION: Restrict creation of Multiple ZF5 documents
* DEVELOPER:           Randheer Kumar
* CREATION DATE:       06/29/2018
* OBJECT ID:           E174
* TRANSPORT NUMBER(S): ED2K912327
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_doc_exists TYPE flag.                                      "Flag: Target Doc already exists

DATA:
  lr_sales_offc TYPE rjksd_vkbur_range_tab,                     "Range: Sales Office
  lr_potype     TYPE STANDARD TABLE OF tds_rg_bsark.                "Range : PO type

CONSTANTS:
  lc_devid_e174 TYPE zdevid      VALUE 'E174',                  "Development ID: E174
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
  lc_p1_potype  TYPE rvari_vnam  VALUE 'PO_TYPE',               "Name of Variant PO type
  lc_p2_eal     TYPE rvari_vnam  VALUE 'EAL',                   "Name of Variant Variable: EAL
  lc_msgno_300  TYPE msgno       VALUE '300',                   "Message Number in message class ZQTC_R2
  lc_msgno_301  TYPE msgno       VALUE '301',                   "Message Number in message class ZQTC_R2
  lc_zf5_cancel TYPE rfbsk       VALUE 'E'.

DATA : lv_fksto TYPE fksto.
CLEAR: lv_fksto.

* Get Cnonstant values
SELECT devid,                                                   "Devid
       param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values)
 WHERE devid    EQ @lc_devid_e174                               "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_eal.                                       "EAL Only
            APPEND INITIAL LINE TO lr_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
      WHEN lc_p1_potype.
        APPEND INITIAL LINE TO lr_potype ASSIGNING FIELD-SYMBOL(<lst_potype>).
        <lst_potype>-sign   = <lst_const_value>-sign.
        <lst_potype>-option = <lst_const_value>-opti.
        <lst_potype>-low    = <lst_const_value>-low.
        <lst_potype>-high   = <lst_const_value>-high.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

IF vbak-vkbur IN lr_sales_offc                            "EAL Only
   AND vbak-bsark IN lr_potype.
* Check Sales Document Flow - if Target document is already created
  SELECT vbfa~vbelv,                                       "Preceding sales and distribution document
         vbfa~posnv,                                       "Preceding item of an SD document
         vbfa~vbeln,                                       "Subsequent sales and distribution document
         vbfa~posnn,                                       "Subsequent item of an SD document
         vbfa~vbtyp_n,                                     "Document category of subsequent document
         vbrk~fkart,                                       "Billing Type of Billing Document
         vbrk~fksto,                                       "Billing document is cancelled
         vbrk~rfbsk                                        "Status for transfer to accounting
    FROM vbfa INNER JOIN vbrk
      ON vbfa~vbeln EQ vbrk~vbeln
    INTO TABLE @DATA(li_paymnt)
   WHERE vbfa~vbelv EQ @vbak-vbeln                         "Sales Doc - Order / Contract (Source)
     AND ( vbfa~vbtyp_n EQ @vbtyp_rech                     "SD Doc Category - M (Invoice) or - U (Proforma)
      OR vbfa~vbtyp_n EQ @vbtyp_prof )
   ORDER BY vbfa~vbeln, vbfa~posnn.

  IF sy-subrc IS INITIAL.
* Check if the billing docs in cancelled status.

    "discard documents in cancelled status
    DELETE li_paymnt WHERE fksto EQ abap_true."this should discard ZF2 with cancel status

    "discard documents with cancelled status for transfer to accounting
    DELETE li_paymnt WHERE rfbsk EQ lc_zf5_cancel."this should discard cancelled proformas

    IF li_paymnt IS NOT INITIAL.
      "looks like few documents still exist after filtering all the cancelations
      DELETE ADJACENT DUPLICATES FROM li_paymnt COMPARING vbeln.
*      READ TABLE li_paymnt ASSIGNING <fs_wa> index 1.
      lv_doc_exists = abap_true.
    ENDIF.
  ENDIF.
ENDIF.

IF lv_doc_exists IS NOT INITIAL.                           "Target Document already exists
  CLEAR vbfs.
  MOVE-CORRESPONDING vbsk TO vbfs.
  DATA(lis_payment) = li_paymnt[ 1 ].

  vbfs-vbeln = xkomfk-vbeln.
  vbfs-posnr = posnr_low.
*  vbfs-etenr = ts_msg.
  vbfs-msgid = 'ZQTC_R2'.
  vbfs-msgty = 'E'.

  IF lis_payment-vbtyp_n = vbtyp_rech.       " IF Doc Category is M (Invoice)
    vbfs-msgno = lc_msgno_301.
*    vbfs-msgv1 = lis_payment-vbelv.
    vbfs-msgv2 = lis_payment-vbeln.
  ELSEIF lis_payment-vbtyp_n = vbtyp_prof.   " IF Doc Category is U (Proforma)
    vbfs-msgno = lc_msgno_300.
*    vbfs-msgv1 = lis_payment-vbelv.
    vbfs-msgv2 = lis_payment-vbeln.
  ENDIF.

*  vbfs-msgv1 = ts_tx1.
*  vbfs-msgv2 = ts_tx2.
*  vbfs-msgv3 = ts_tx3.
  xvbfs = vbfs.
  xvbfs_key = vbfs.
  READ TABLE xvbfs WITH KEY xvbfs_key BINARY SEARCH.
  CASE sy-subrc.
    WHEN 8.
      APPEND xvbfs.
      IF xvbfs-msgty = 'E'.
        ADD 1 TO vbsk-ernum.
      ENDIF.
    WHEN 4.
      INSERT xvbfs INDEX sy-tabix.
      IF xvbfs-msgty = 'E'.
        ADD 1 TO vbsk-ernum.
      ENDIF.
    WHEN 0.
  ENDCASE.

  sy-subrc = 4.
ELSE.                                                      "Target Document not yet created
  sy-subrc = 0.
ENDIF.
