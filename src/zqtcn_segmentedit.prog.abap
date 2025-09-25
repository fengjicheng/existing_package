**&---------------------------------------------------------------------*
**&  Include  ZQTCN_SEGMENT_CHNAGE
**&---------------------------------------------------------------------*
**----------------------------------------------------------------------*
** PROGRAM NAME: ZQTCN_SEGMENT_CHNAGE
** PROGRAM DESCRIPTION: Defaault the Payment terms for ZCSS orders for
**                      US advertising agency
** DEVELOPER: GKAMMILI
** CREATION DATE: 11/23/2020
** OBJECT ID: E260
** TRANSPORT NUMBER(S): ED2K920422
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO: <DER OR TPR OR SCR>
** DEVELOPER:
** DATE: MM/DD/YYYY
** DESCRIPTION:
**&---------------------------------------------------------------------*
*CONSTANTS:
*  lc_dev_e260    TYPE zdevid     VALUE 'E260',       "Development ID
*  lc_p_usage_i   TYPE rvari_vnam VALUE 'VKAUS', "Parameter: Uasge Indicator
*  lc_p_zterm     TYPE rvari_vnam VALUE 'ZTERM',   "Parameter: Payment term
*  lc_p_ord_type  TYPE rvari_vnam VALUE 'AUART',   "Parameter: Order Type
*  lc_p_sales_org TYPE rvari_vnam VALUE 'VKORG',   "Parameter: Sales Organization
*  lc_p_cust_grp  TYPE rvari_vnam VALUE 'KVGR1',   "Parameter: Customer group
*  lc_z1qtc_e1edk01_01  TYPE edilsegtyp VALUE 'Z1QTC_E1EDK01_01',  "Segmwnt Z1QTC_E1EDK01_01
*  lc_e1edk01     TYPE edilsegtyp VALUE 'E1EDK01',    "Segment E1EDK01
*  lc_e1edk14     TYPE edilsegtyp VALUE 'E1EDK14',
*  lc_qualf_012   TYPE edi_qualfo VALUE '012',
*  lc_qualf_008   TYPE edi_qualfo VALUE '008',
*  lc_n           TYPE char1      VALUE 'N'.
** Declare Ranges: So value can be store till last call.
*DATA:
*  lr_usage_i    TYPE RANGE OF vbak-abrvw,           "Payment Method
*  lr_ord_type   TYPE RANGE OF vbak-auart,           "Order Type
*  lr_sales_org  TYPE RANGE OF vbak-vkorg,           "Sales Organization
*  lr_cust_grp   TYPE RANGE OF knvv-kvgr1,           "Customer Group
*  lv_zterms     TYPE vbkd-zterm,                    "Terms of Payment Key
*  lv_flg        TYPE char1,                         "Flag
*  lv_docnum     TYPE edi_docnum,
*  lst_edidc     TYPE  edidc,
*  li_edidd      TYPE TABLE OF edidd,
*  li_edidd_chg  TYPE TABLE OF edidd,
*  lst_edidd_chg TYPE edidd,
*  lst_edidd     TYPE edidd,
*  li_status     TYPE TABLE OF edi_ds40,
*  li_constants  TYPE zcat_constants,
*  lst_e1edk01   TYPE e1edk01,
*  lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01,
*  lst_e1edk14   TYPE e1edk14,
*  lv_abrvw      TYPE abrvw,
*  lv_kvgr1      TYPE kvgr1,
*  lv_auart      TYPE auart,
*  lv_vkorg      TYPE vkorg.
** Check the table and varable is empty or not.
*IF lr_usage_i   IS INITIAL AND
*   lr_ord_type  IS INITIAL AND
*   lr_sales_org IS INITIAL AND
*   lr_cust_grp  IS INITIAL AND
*   lv_zterms   IS INITIAL.
*
** Fetch Constant Values
*  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
*    EXPORTING
*      im_devid     = lc_dev_e260   "Development ID
*    IMPORTING
*      ex_constants = li_constants. "Constant Values
** fill the respective entries which are maintain in zcaconstant.
*  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>).
*    CASE <lst_constants>-param1.
*      WHEN lc_p_usage_i.
*        APPEND INITIAL LINE TO lr_usage_i ASSIGNING FIELD-SYMBOL(<lst_usage_i>).
*        <lst_usage_i>-sign   = <lst_constants>-sign.
*        <lst_usage_i>-option = <lst_constants>-opti.
*        <lst_usage_i>-low    = <lst_constants>-low.
*        <lst_usage_i>-high   = <lst_constants>-high.
*      WHEN lc_p_ord_type.
*        APPEND INITIAL LINE TO lr_ord_type ASSIGNING FIELD-SYMBOL(<lst_ord_type>).
*        <lst_ord_type>-sign   = <lst_constants>-sign.
*        <lst_ord_type>-option = <lst_constants>-opti.
*        <lst_ord_type>-low    = <lst_constants>-low.
*        <lst_ord_type>-high   = <lst_constants>-high.
*      WHEN lc_p_sales_org.
*        APPEND INITIAL LINE TO lr_sales_org ASSIGNING FIELD-SYMBOL(<lst_sales_org>).
*        <lst_sales_org>-sign   = <lst_constants>-sign.
*        <lst_sales_org>-option = <lst_constants>-opti.
*        <lst_sales_org>-low    = <lst_constants>-low.
*        <lst_sales_org>-high   = <lst_constants>-high.
*      WHEN lc_p_cust_grp.
*        APPEND INITIAL LINE TO lr_cust_grp ASSIGNING FIELD-SYMBOL(<lst_cust_grp>).
*        <lst_cust_grp>-sign   = <lst_constants>-sign.
*        <lst_cust_grp>-option = <lst_constants>-opti.
*        <lst_cust_grp>-low    = <lst_constants>-low.
*        <lst_cust_grp>-high   = <lst_constants>-high.
*      WHEN lc_p_zterm.
*        lv_zterms = <lst_constants>-low.
*      WHEN OTHERS.
**       Do nothing.
*    ENDCASE.
*  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>)
*ENDIF. " IF lr_usage_i IS INITIAL
*LOOP AT dedidd INTO lst_edidd.
*  CASE lst_edidd-segnam.
*    WHEN lc_e1edk01.
*      lst_e1edk01 = lst_edidd-sdata.
*      lv_abrvw = lst_e1edk01-abrvw.
*    WHEN lc_z1qtc_e1edk01_01.
*      lst_z1qtc_e1edk01_01 = lst_edidd-sdata.
*      lv_kvgr1 = lst_z1qtc_e1edk01_01-kvgr1.
*    WHEN lc_e1edk14.
*      lst_e1edk14 = lst_edidd-sdata.
*      IF lst_e1edk14-QUALF = lc_QUALF_012 .
*        lv_auart  = lst_e1edk14-orgid.
*      ELSEIF lst_e1edk14-QUALF = lc_QUALF_008.
*        lv_vkorg  = lst_e1edk14-orgid.
*      ENDIF.
*
*    WHEN OTHERS.
*  ENDCASE.
*
*ENDLOOP.
*
*  IF lv_abrvw IN lr_usage_i  AND
*     lv_auart IN lr_ord_type AND
*     lv_vkorg IN lr_sales_org AND
*     lv_kvgr1 IN lr_cust_grp.
*    lv_flg = abap_true.
*  ENDIF. " IF vbak-abrvw IN lr_usage_i
*
*
*
*IF lv_flg = abap_true.
*  lv_docnum = docnum.
*  CALL FUNCTION 'EDI_DOCUMENT_OPEN_FOR_EDIT'
*    EXPORTING
*      document_number               = lv_docnum
*      already_open                  = lc_n"'N'
*    IMPORTING
*      idoc_control                  = lst_edidc
*    TABLES
*      idoc_data                     = li_edidd
*    EXCEPTIONS
*      document_foreign_lock         = 1
*      document_not_exist            = 2
*      document_not_open             = 3
*      status_is_unable_for_changing = 4
*      OTHERS                        = 5.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  LOOP AT  li_edidd INTO lst_edidd WHERE segnam = lc_e1edk01."'E1EDK01'.
*    lst_edidd_chg = lst_edidd.
*    lst_e1edk01   = lst_edidd_chg-sdata.
*    lst_e1edk01-zterm = lv_zterms. "'ZD09'.
*    lst_edidd_chg-sdata = lst_e1edk01.
*    APPEND lst_edidd_chg TO li_edidd_chg.
*    CLEAR : lst_edidd,lst_edidd_chg.
*  ENDLOOP.
*
*  CALL FUNCTION 'EDI_CHANGE_DATA_SEGMENTS'
*    TABLES
*      idoc_changed_data_range = li_edidd_chg
*    EXCEPTIONS
*      idoc_not_open           = 1
*      data_record_not_exist   = 2
*      OTHERS                  = 3.
*
*  CALL FUNCTION 'EDI_DOCUMENT_CLOSE_EDIT'
*    EXPORTING
*      document_number  = lv_docnum
*      do_commit        = abap_true
*      do_update        = abap_true
*      write_all_status = abap_true
*      status_75        = ' '
*    TABLES
*      status_records   = li_status
*    EXCEPTIONS
*      idoc_not_open    = 1
*      db_error         = 2
*      OTHERS           = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*ENDIF.
