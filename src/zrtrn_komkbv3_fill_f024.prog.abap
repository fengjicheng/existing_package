*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_KOMKBV3_FILL_F024 (Include)
*                      [Called from USEREXIT_KOMKBV3_FILL (RVCOMFZZ)]
* PROGRAM DESCRIPTION: Communication structure update with additional
*                      field values
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       03/10/2017
* OBJECT ID:           F024
* TRANSPORT NUMBER(S): ED2K904894
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION: Populate Material group 5
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911002
* REFERENCE NO: ERP-6712
* DEVELOPER: Writtick Roy (WROY)
* DATE:  02/21/2018
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917462
* REFERENCE NO: ERP-1172
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  02/05/2020
* DESCRIPTION: Addd customer group 3
*----------------------------------------------------------------------*
DATA:
  lst_cust_gen TYPE kna1,                                  "General Data in Customer Master
  lst_sd_headr TYPE vbak.                                  "Sales Document: Header Data

* Begin of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646
DATA:
  li_so_prtnrs TYPE tab_vbpa.                              "Sales Document: Partners
* End   of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646

CONSTANTS:
  lc_posnr_low TYPE posnr_vf VALUE '000000',               "Billing item: Header
* Begin of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646
  lc_parvw_za  TYPE parvw    VALUE 'ZA',                   "Partner Function: Society Partner
* End   of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646
  lc_parvw_re  TYPE parvw    VALUE 'RE'.                   "Partner Function: Bill-To Party

* Get Billing item information
READ TABLE com_vbrp_tab ASSIGNING FIELD-SYMBOL(<lst_com_vbrp>) INDEX 1.
IF sy-subrc EQ 0.
  com_kbv3-zzkvgr1   = <lst_com_vbrp>-kvgr1.               "Customer group 1
  com_kbv3-zzkvgr3   = <lst_com_vbrp>-kvgr3.               "Customer group 3 "ADD:ERP-1172:SGUDA:05-FEB-2020:ED2K917462
  com_kbv3-zzvkbur   = <lst_com_vbrp>-vkbur.               "Sales Office
* Begin of ADD:ERP-4961:WROY:28-NOV-2017:ED2K909607
  com_kbv3-zzkonda   = <lst_com_vbrp>-konda_auft.          "Price group of sales order
* End   of ADD:ERP-4961:WROY:28-NOV-2017:ED2K909607
* Begin of ADD:ERP-6712:WROY:21-FEB-2018:ED2K911002
  com_kbv3-zzmvgr5   = <lst_com_vbrp>-mvgr5.               "Material group 5
* End   of ADD:ERP-6712:WROY:21-FEB-2018:ED2K911002

* Fetch Sales Document: Header Data
  CALL FUNCTION 'SD_VBAK_SINGLE_READ'
    EXPORTING
      i_vbeln          = <lst_com_vbrp>-aubel              "Sales Document
    IMPORTING
      e_vbak           = lst_sd_headr                      "Sales Document: Header Data
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc EQ 0.
    com_kbv3-zzbstzd = lst_sd_headr-bstzd.                 "Purchase order number supplement
  ENDIF.

* Begin of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646
* Fetch Partner Details of the Reference Document
  CALL FUNCTION 'SD_VBPA_READ_WITH_VBELN'
    EXPORTING
      i_vbeln          = <lst_com_vbrp>-aubel              "Sales Document
    TABLES
      et_vbpa          = li_so_prtnrs                      "Sales Document: Partners
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc EQ 0.
*   Check if there is at least one Society Partner
*   Since number of entries in the Internal table will be very limited,
*   SORT and BINARY SEARCH is not being used
    READ TABLE li_so_prtnrs TRANSPORTING NO FIELDS
         WITH KEY parvw = lc_parvw_za.
    IF sy-subrc EQ 0.
      com_kbv3-zzsoc_ord = abap_true.
    ENDIF.
  ENDIF.
* End   of ADD:ERP-2681:WROY:31-JUL-2017:ED2K907646
ENDIF.

* Get the Bill-To Party information
READ TABLE com_vbpa     ASSIGNING FIELD-SYMBOL(<lst_com_vbpa>)
     WITH KEY vbeln = com_vbrk-vbeln                       "Billing Document Number
              posnr = lc_posnr_low                         "Billing item: Header
              parvw = lc_parvw_re.                         "Partner Function: Bill-To Party
IF sy-subrc EQ 0.
* Fetch General Data in Customer Master
  CALL FUNCTION 'KNA1_SINGLE_READ'
    EXPORTING
      kna1_kunnr    = <lst_com_vbpa>-kunnr                 "Customer Number
    IMPORTING
      wkna1         = lst_cust_gen                         "General Data in Customer Master
    EXCEPTIONS
      not_found     = 1
      kunnr_blocked = 2
      OTHERS        = 3.
  IF sy-subrc EQ 0.
    com_kbv3-zzkatr6 = lst_cust_gen-katr6.                 "Attribute 6
  ENDIF.

ENDIF.
