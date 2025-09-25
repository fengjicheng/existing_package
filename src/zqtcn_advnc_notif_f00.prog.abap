*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_ADVNC_NOTIF_F00(Include Program)
* REPORT DESCRIPTION:    Include for subroutines
* DEVELOPER:             Aratrika Banerjee (ARABANERJE)
* CREATION DATE:         26-Dec-2016
* OBJECT ID:             F032
* TRANSPORT NUMBER(S):   ED2K9037999
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908431
* REFERENCE NO:  ERP-4320
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  09/11/2017
* DESCRIPTION: Alignement issues in layout and also changed the logic for
*              the language to be displayed. Currently in the interface
*              we are passing ST_VBCO3-SPRAS, as this is not right one
*              changed to sold to customer language and passing it in
*              ST_ADDRESS field. Same is taken in interface and passed to V_LANGU.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907387
* REFERENCE NO: ERP-5131
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-11-29
* DESCRIPTION:
* Use Cust Cond Grp 2 in stead of Cust Cond Grp 1
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7332
* REFERENCE NO: ED2K911700
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         30-Mar-2018
* DESCRIPTION:  Billtrust Amount (SAP format --> External format)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7340
* REFERENCE NO: ED2K911700
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         30-Mar-2018
* DESCRIPTION:  Implement Archiving logic
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0194261
* REFERENCE NO: ED1K907222
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         11-May-2018
* DESCRIPTION:  Activating print option from print preview
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907933
* REFERENCE NO: INC0201178 (F032, F035 and F037)
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         09-Jul-2018
* DESCRIPTION:  Billtrust- Renewal notice form showing Ship-To address
*               on Billtrust Cover Letter, changes done to show
*               Bill-To address.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913178
* REFERENCE NO: ERP- 7119
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         8-Sep-2018
* DESCRIPTION:  Add Subscription term and change text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913666
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         24-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909062
* REFERENCE NO: RITM0093866
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         01-DECEMBER-2018
* DESCRIPTION:  Now need the dates to reflect: todays date + 20 days.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K914490
* REFERENCE NO: ERP-7873
* DEVELOPER:    PRABHU (PTUFARAM)
* DATE:         21-Feb-2019
* DESCRIPTION:  Billing date change : 10 days from sy-datum,
* either of 5th or 20th which is earliest.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR- 7841
* REFERENCE NO: ED1K910091
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         30-Apr-2019
* DESCRIPTION:  Replace the 'Year' in item section with 'Contract start date'
*               and 'Contract End Date'.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-21151
* REFERENCE NO: ED2K919110
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         10-AUG-2020
* DESCRIPTION:  Future Change Functionality for Firm Invoices
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K919534
* REFERENCE NO: OTCM-26071
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE:  17/09/2020 (DD/MM/YYYY)
* DESCRIPTION: Greman Translation Changes
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K923607
* REFERENCE NO: OTCM-37780
* DEVELOPER: Rajkumar Madavoina(MRAJKUMAR)
* DATE:  28/05/2021 (DD/MM/YYYY)
* DESCRIPTION: F032 Form changes for Billing date from Billing Information
*              instead of FM ZQTC_BILLING_DATE_E164
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K924582
* REFERENCE NO: OTCM-40086
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         15/09/2021 (DD/MM/YYYY)
* DESCRIPTION:
* 1) if Material group4 (VBRP- MVGR4= BK- eBooks, JU-eJournal, BU-eBundle
*    then print the media type as Digital
* 2) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue then print the media type as Print
* 3) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue, BK- eBooks, JU-eJournal, BU-eBundle then print
*    the media type as Print & digital.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADVNC_NOTIF_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING
*&---------------------------------------------------------------------*
*     This perform is used for all data process where all the
*     performs has been processed
*----------------------------------------------------------------------*
FORM f_processing.

*******Local Constant Declaration
  CONSTANTS: lc_01 TYPE na_nacha VALUE '1', "Message transmission Medium for Print
             lc_05 TYPE na_nacha VALUE '5'. "Message transmission medium for Email

* Perform to clear all global variables/tables.
  PERFORM f_clear_global.

* Perform to populate Wiley Logo
  PERFORM f_get_wiley_logo CHANGING v_xstring.

* Perform to populate sales data from NAST table
  PERFORM f_get_data USING nast
                  CHANGING st_vbco3.

***BOC BY SRBOSE ON 15-JAN-2018 #CR_TBD #TR:ED2K909616
  PERFORM f_get_constant.
***EOC BY SRBOSE ON 15-JAN-2018 #CR_TBD #TR:ED2K909616

* Perform to populate Bill-to-address data
  PERFORM f_get_bill_addr  USING  st_vbco3
                         CHANGING st_address.

* To format any display things as per the country.
  SET COUNTRY st_address-land1.

*  Perform to fetch data from VBAP table
  PERFORM f_get_vbap_data   USING    st_vbco3
                            CHANGING st_vbap
                                     st_final
                                     st_address.

* Perform to populate society logo
  PERFORM f_get_society_logo   USING st_vbco3
                            CHANGING v_society_logo.

*************BOC by SRBOSE on 08/08/2017 for CR# 408****************
  PERFORM f_get_seller_tax USING st_vbap
                           CHANGING v_seller_reg.

*************EOC by SRBOSE on 08/08/2017 for CR# 408****************

* Perform to populate date and Date to be collected.
  PERFORM f_get_dates CHANGING st_final.

* Perform to fetch data from VBFA Table.
*  PERFORM f_get_vbfa USING st_vbco3
*                           st_vbap
*                  CHANGING st_final.
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
  PERFORM f_get_stxh_data USING    v_langu
                          CHANGING i_std_text.
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
* Perform to populate standard text dynamically on basis of company code and cuurency key
  PERFORM f_populate_std_text  USING st_vbco3
                                     st_vbpa
* BOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
                                     st_vbap
* EOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
                            CHANGING v_footer
                                     v_compname.

* Perform too populate Direct Debit Guarantee logo
  PERFORM f_get_drct_dbt_logo CHANGING v_drct_dbt_logo.

  CHECK v_retcode = 0.

* Begin of CHANGE:CR#473:ARABANERJE:09-Aug-2017:ED2K906742
  PERFORM f_populate_barcode.
* End of CHANGE:CR#473:ARABANERJE:09-Aug-2017:ED2K906742

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF nast-nacha EQ lc_01.
* Perform from where the form has been called and print PDF
    PERFORM f_adobe_print_output.
  ELSEIF nast-nacha EQ lc_05. " ELSE -> IF nast-nacha EQ lc_01
* Perform has been used to send mail with an attachment of PDF
    PERFORM f_adobe_print_mail.
  ENDIF. " IF nast-nacha EQ lc_01

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_WILEY_LOGO
*&---------------------------------------------------------------------*
*       This perform is used to get the Wiley Logo
*----------------------------------------------------------------------*

FORM f_get_wiley_logo  CHANGING fp_v_xstring TYPE xstring.

*******Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object    " GRAPHICS
      p_name         = lc_logo_name " ZJWILEY_LOGO
      p_id           = lc_id        " BMAP
      p_btype        = lc_btype     " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       This perform is used to get data of VBELN
*       which is used in the other performs.
*       The data of VBELN of VBCO3 is coming from NAST.
*       This is mainly copied from a standard program named RVADOR01
*----------------------------------------------------------------------*
FORM f_get_data  USING    fp_nast     TYPE nast   " Message Status
                 CHANGING fp_st_vbco3 TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing


  fp_st_vbco3-mandt = sy-mandt.
  fp_st_vbco3-spras = fp_nast-spras.
  fp_st_vbco3-vbeln = fp_nast-objky+0(10).
  fp_st_vbco3-posnr = fp_nast-objky+10(6).
  fp_st_vbco3-kunde = fp_nast-parnr.
  fp_st_vbco3-parvw = fp_nast-parvw.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAP_DATA
*&---------------------------------------------------------------------*
*       This Perfrom is used to get VBAP data which is used to
*       populate the final structure(Item)
*----------------------------------------------------------------------*

FORM f_get_vbap_data  USING fp_st_vbco3 TYPE vbco3               " Sales Doc.Access Methods: Key Fields: Document Printing
                   CHANGING fp_st_vbap TYPE ty_vbap
                            fp_st_final TYPE zstqtc_final_f032   " Final structure for Renewal Notification
                            fp_st_address TYPE zstqtc_addr_f032. " Structure for address node

******Local table type declaration of type range
  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
  TYPES : BEGIN OF lty_iss_vol2,
            matnr TYPE matnr,         " Material Number
            stvol TYPE ismheftnummer, " Copy Number of Media Issue
            stiss TYPE ismnrimjahr,   " Media Issue
            noi   TYPE sytabix,       " Row Index of Internal Tables
          END OF  lty_iss_vol2.

  TYPES : BEGIN OF lty_iss_vol3,
            matnr TYPE matnr,         " Material Number
            stvol TYPE ismheftnummer, " Copy Number of Media Issue
            stiss TYPE ismnrimjahr,   " Media Issue
            noi   TYPE sytabix,       " Row Index of Internal Tables
          END OF lty_iss_vol3.
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744

  DATA : lir_vbeln           TYPE ltt_vbeln_r,         " local range table of of vbeln
         lst_vbeln           TYPE LINE OF ltt_vbeln_r, " Local workarea of range table
         lst_vbfa            TYPE ty_vbfa,             " Local workarea for vbfa table
         lst_vbak            TYPE ty_vbak,             " Local workarea for vbfa table
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*         li_veda             TYPE TABLE OF ty_veda,
*         lst_veda            TYPE ty_veda,             " Local workarea for VEDA table
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
         lst_iss_vol2        TYPE lty_iss_vol2,
         li_iss_vol2         TYPE STANDARD TABLE OF lty_iss_vol2 INITIAL SIZE 0,
         lst_iss_vol3        TYPE lty_iss_vol3,
         li_iss_vol3         TYPE STANDARD TABLE OF lty_iss_vol3 INITIAL SIZE 0,
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
*** BOC BY SAYANDAS
         li_vbap             TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
         lst_vbap            TYPE ty_vbap,
         lst_arktx           TYPE zstqtc_arktx_f032,       " Structure for product description F032
         lv_text             TYPE string,
         li_lines            TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
*** EOC BY SAYANDAS
         lv_date             TYPE vbdat_veda, " Contract start date
         lv_year             TYPE char4,      " Year of type CHAR4
         lv_text_name        TYPE tdobname,   " Name
* Begin of change by APATNAIK: 30-June-2017: #TR: ED2K906742
         lv_net              TYPE kzwi1,    " Subtotal 1 from pricing procedure for condition
         lv_tax              TYPE  kzwi6,   " Subtotal 6 from pricing procedure for condition
         lv_net_char         TYPE char25,   " Net_char of type CHAR25
         lv_tax_char         TYPE char25,   " Tax_char of type CHAR25
         lv_tot_char         TYPE char25,   " Tot_char of type CHAR25
         lv_posnr            TYPE posnr_va, " Sales Document Item
* END of change by APATNAIK: 30-June-2017: #TR: ED2K906742
* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
         li_vbfa             TYPE TABLE OF ty_vbfa, " Local Internal table for VBFA
         lv_tax_text         TYPE string,
         lv_kbetr_char       TYPE char15,           " Kbetr_char of type CHAR15
         lst_tax_dtls        TYPE ty_tax_dtls,
         li_vbap_tmp         TYPE TABLE OF ty_vbap,
         lst_vbap_tmp        TYPE ty_vbap,
         li_vbap_hcomp       TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
         li_vbap_tmp_uepos   TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0, "ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
*         lv_txtmodule_data   TYPE string,
         lv_sub_ref_id       TYPE char100,      " Sub Ref ID
         lv_identcode        TYPE char20,       " Identcode of type CHAR20
         lv_vol              TYPE char8,        " Volume
         lv_issue            TYPE char30,       " Issue
         lv_bhf              TYPE char1,        " Bhf of type CHAR1
         lv_lcf              TYPE char1,        " Lcf of type CHAR1
         lv_mlsub            TYPE char30,       " Mlsub of type CHAR30
         lv_issue_des        TYPE char255,      " Issue_des of type CHAR255
         lv_issue_desc       TYPE tdline,       " Text Line
         lv_volum            TYPE char30,       " Volume
         lv_year_1           TYPE char30,       " Year
         lv_year_2           TYPE char30,       " Year_2 of type CHAR30
         lv_cntr_end         TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_cntr_month       TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_cntr             TYPE char30,       " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_day(2)           TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_month(2)         TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_year2(4)         TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_stext            TYPE t247-ktx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_ltext            TYPE t247-ltx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910091
         lv_name1            TYPE thead-tdname, " Name
         lv_name_issn        TYPE thead-tdname, " Name
         lv_pnt_issn         TYPE char30,       "char10," Print ISSN
         lv_subscription_typ TYPE char100,      " Subscription_typ of type CHAR100
         lv_flag_di          TYPE char1,        " Flag_di of type CHAR1
         lv_flag_ph          TYPE char1,        " Flag_ph of type CHAR1
         lst_jptidcdassign1  TYPE ty_jptidcdassign,
         lv_identcode_zjcd   TYPE char20,       " Identcode of type CHAR20
         li_vbap_tmp1        TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
         li_vbap_tmp2        TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
*         lst_arktx         LIKE LINE OF i_arktx,
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
         lv_itmcomp_indx     TYPE syst_tabix, " ABAP System Field: Row Index of Internal Tables
         lst_vbap_itmcmp     TYPE ty_vbap,
         lv_txtmodule_data   TYPE string,
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
         lv_mem_num_txt      TYPE char100,      " CR#7730 KKRAVURI20181024
         lv_media1           TYPE ismmediatype, " Media Type
         lv_media_flag       TYPE xfeld,        " Checkbox
         lv_name             TYPE thead-tdname, " Name
         lst_lines           TYPE tline,        " SAPscript: Text Lines
         lv_no_uepos         TYPE vbap-uepos. "ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062

  CONSTANTS :                                   "lc_g  TYPE char1 VALUE 'G',        " G of type CHAR1
    lc_i          TYPE tvarv_sign  VALUE 'I',   "ABAP: ID: I/E (include/exclude values)
    lc_eq         TYPE tvarv_opti  VALUE 'EQ',  "ABAP: Selection option (EQ/BT/CP/...)
    lc_posnr      TYPE posnr_va VALUE '000000', " Sales Document Item
* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
    lc_percentage TYPE char1  VALUE '%', " Percentage of type CHAR1
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
    lc_year       TYPE thead-tdname VALUE 'ZQTC_YEAR_F035',       " Name
    lc_hier2      TYPE ismhierarchlvl VALUE '2',                  " Hierarchy Level (Media Product Family, Product or Issue)
    lc_hier3      TYPE ismhierarchlvl VALUE '3',                  " Hierarchy Level (Media Product Family, Product or Issue)
    lc_hyphen     TYPE char01         VALUE '-',                  "Constant for hyphen
    lc_colon      TYPE char1 VALUE ':',                           " Colon of type CHAR1
    lc_comma      TYPE char1        VALUE ',',                    " Comma of type CHAR1
    lc_colonb     TYPE char2 VALUE ': ',                          " Colonb of type CHAR2
    lc_sub_ref_id TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*    lc_stiss        TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',    " Name
    lc_volume     TYPE thead-tdname VALUE 'ZQTC_VOLUME_F035',                " Name
    lc_issue      TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',                 " Name
    lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
    lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
    lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
    lc_mlsubs     TYPE thead-tdname VALUE 'ZQTC_MSUBS_F042',                 " Name
    lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',            " Name
    lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',          " Name
    lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042',         " Name
    lc_stiss      TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',            " Name
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
*   Begin of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
* BOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*    lc_sub_term   TYPE thead-tdname VALUE 'ZQTC_F032_SUB_TERM',
    lc_sub_term   TYPE thead-tdname VALUE 'ZQTC_F032N_SUB_TERM',
* EOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*   End of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
    lc_digi_sub   TYPE thead-tdname VALUE 'ZQTC_F032_DIGITAL',  " Digi_sub of type CHAR20
    lc_print_sub  TYPE thead-tdname VALUE 'ZQTC_F032_PRINT',    " Print_sub of type CHAR20
    lc_comb_sub   TYPE thead-tdname VALUE 'ZQTC_F032_COMBINED', " Comb_sub of type CHAR20
    lc_st         TYPE thead-tdid   VALUE 'ST',                 "Text ID of text to be read
    lc_object     TYPE thead-tdobject VALUE 'TEXT',             "Object of text to be read
    lc_cntr_start TYPE thead-tdname VALUE 'ZQTC_F042_CNT_STRT_DATE',  " Contract Start Date "CR-7841:SGUDA:29-Apr-2019:ED1K910078
    lc_cntr_end   TYPE thead-tdname VALUE 'ZQTC_F042_CNT_END_DATE'.   " Contract End Date "CR-7841:SGUDA:29-Apr-2019:ED1K910078

  SELECT vbeln  " Sales Document
         posnr  " Sales Document Item
         matnr  " Material Number
         arktx  " Short text for sales order item
         uepos  " Higher-level item
         netwr  " Net amount
         kwmeng " Cumulative Order Quantity in Sales Units
         kzwi1  " Subtotal 1 from pricing procedure for condition
         kzwi2  " Subtotal 2 from pricing procedure for condition
         kzwi4  " Subtotal 4 from pricing procedure for condition
         kzwi5  " Subtotal 5 from pricing procedure for condition
         kzwi6  " Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
         mvgr4  " Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
         mvgr5
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
    FROM vbap " Sales Document: Item Data
    INTO TABLE li_vbap
    WHERE vbeln = fp_st_vbco3-vbeln
*- To restrict Reason for rejection of quotations and sales orders
    AND   abgru = space. " ERPM-21151/INC0317561 - ED1K912286
*** EOC BY SAYANDAS
  IF sy-subrc IS INITIAL.
*** BOC BY SAYNADAS
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    SORT li_vbap BY posnr.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    CLEAR : li_vbkd[].
    SELECT vbeln,
           posnr,
           fkdat,
           ihrez, " Your Reference
           kdkg2,
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
           zlsch
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
      FROM vbkd  " Sales Document: Business Data
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
      INTO TABLE @li_vbkd
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
      FOR ALL ENTRIES IN @li_vbap
      WHERE vbeln = @li_vbap-vbeln
      AND posnr = @li_vbap-posnr.
    IF sy-subrc = 0.
      SORT li_vbkd BY vbeln posnr.
    ENDIF. " IF sy-subrc = 0
*** EOC BY SAYANDAS
*** BOC BY SAYANDAS
    READ TABLE li_vbap INTO fp_st_vbap INDEX 1.
    IF sy-subrc IS INITIAL.
**** EOC BY SAYANDAS
*****Fetch Data from VBFA table:Sales Document Flow
      SELECT SINGLE vbeln " Subsequent sales and distribution document
             posnr        " Subsequent item of an SD document
             fkdat        " Billing Date "ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
             ihrez        " Your Reference
*              Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*              kdkg1        " Customer Group
             kdkg2 " Customer Group
*              End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
        FROM vbkd    "Sales Document Flow
        INTO st_vbkd "Global structure of VBFA table
        WHERE vbeln   = fp_st_vbco3-vbeln
        AND   posnr   = fp_st_vbap-posnr.
      IF sy-subrc NE 0.
*****Fetch Data from VBFA table:Sales Document Flow
        SELECT SINGLE vbeln " Subsequent sales and distribution document
               posnr        " Subsequent item of an SD document
               ihrez        " Your Reference
*              Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*              kdkg1        " Customer Group
               kdkg2 " Customer Group
*              End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
          FROM vbkd    "Sales Document Flow
          INTO st_vbkd "Global structure of VBFA table
          WHERE vbeln   = fp_st_vbco3-vbeln
          AND   posnr   = space.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF sy-subrc IS INITIAL
**** BOC BY SAYANDAS
*    ENDIF. " IF sy-subrc IS INITIAL
*** EOC BY SAYANDAS
* Begin of Insert by PBANDLAPAL 30-OCT-2017
*****Fetch Data from VBFA table:Sales Document Flow
    SELECT vbelv         "Preceding sales and distribution document
           posnv         "Preceding item of an SD document
           vbeln         "Subsequent sales and distribution document
           posnn         "Subsequent item of an SD document
           vbtyp_n       "Document category of subsequent document
           vbtyp_v       "Document category of preceding SD document
      FROM vbfa          "Sales Document Flow
      INTO TABLE li_vbfa "Global structure of VBFA table
      WHERE vbeln   = fp_st_vbco3-vbeln.
    IF sy-subrc EQ 0.
      READ TABLE li_vbfa INTO lst_vbfa WITH KEY vbeln = fp_st_vbco3-vbeln
                                                posnn = fp_st_vbap-posnr.
      IF sy-subrc NE 0.
        READ TABLE li_vbfa INTO lst_vbfa WITH KEY vbeln = fp_st_vbco3-vbeln
                                                  posnn = space.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF sy-subrc EQ 0
* End of Insert by PBANDLAPAL 30-OCT-2017
******Populating Range for VBELN
    lst_vbeln-sign = lc_i.
    lst_vbeln-option = lc_eq.
    lst_vbeln-low = fp_st_vbco3-vbeln.
    APPEND lst_vbeln TO lir_vbeln.
    CLEAR lst_vbeln.

    lst_vbeln-sign = lc_i.
    lst_vbeln-option = lc_eq.
    lst_vbeln-low = lst_vbfa-vbelv.
    APPEND lst_vbeln TO lir_vbeln.
    CLEAR lst_vbeln.

    IF lir_vbeln[] IS NOT INITIAL.
*******Fetch data from VBAK table:Sales Document: Header Data
      SELECT a~vbeln "Sales Document
*            Begin of DEL:I0231:WROY:01-Mar-2018:ED2K911145
*            a~angdt    " Quotation/Inquiry is valid from
*            End   of DEL:I0231:WROY:01-Mar-2018:ED2K911145
*            Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
             a~guebg "Valid-from date (outline agreements, product proposals)
*            End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
             a~auart    "SD document category
             a~waerk    "SD Document Currency
             a~vkorg
             a~vtweg
             a~spart
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
             a~vkbur
             a~bsark
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
             a~knumv    " Number of the document condition
             a~kunnr
             a~kvgr1    " Customer group 1
             a~bukrs_vf "Company code to be billed
             a~vgbel    "Document number of the reference document
             b~land1    " Country Key
             b~spras    " Language Key
        FROM vbak AS a  "Sales Document: Header Data
        LEFT OUTER JOIN kna1 AS b
        ON b~kunnr = a~kunnr
        INTO TABLE i_vbak
        WHERE vbeln IN lir_vbeln.
      IF sy-subrc IS INITIAL.
*******Sort the table by vbeln
        SORT i_vbak BY vbeln.
*** BOC by SRBOSE on 15-Jan-2018 #CR_TBD #TR:  ED2K909616
        READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln = fp_st_vbco3-vbeln
                                              BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          v_psb = lst_vbak-kvgr1.
        ENDIF. " IF sy-subrc IS INITIAL
*** EOC by SRBOSE on 15-Jan-2018 #CR_TBD #TR:  ED2K909616
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF lir_vbeln[] IS NOT INITIAL
*****Fetch Data from VEDA table: Contract Data
    IF sy-subrc IS INITIAL.
      SELECT vbeln " Preceding Subscription
             vposn " Item Number
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
             vlaufk
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
             vbegdat " Contract start date
             vaktsch " Action at end of contract " ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
             venddat " Contract End Date "RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
        FROM veda    " Contract Data
        INTO TABLE li_veda
*        WHERE vbeln = lst_vbfa-vbelv. "ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
*   Begin of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
        WHERE vbeln = fp_st_vbco3-vbeln.
*   End of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
      IF sy-subrc EQ 0.
        SORT li_veda BY vbeln vposn. "ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
        DATA: lst_veda2 LIKE LINE OF li_veda.
        READ TABLE li_veda INTO lst_veda2 INDEX 1.
        DATA(lv_year1) = lst_veda2-vbegdat+0(4).
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
        DATA(lv_year_begin) = lst_veda2-vbegdat+0(4).
        DATA(lv_year_end) = lst_veda2-venddat+0(4).
        IF lv_year_begin = lv_year_end.
          lv_year1 = lv_year_begin.
        ELSE.
          lv_year1 = lv_year_end.
        ENDIF.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
        SELECT spras,
               vlaufk,
               bezei " Description
          FROM tvlzt " Validity Period Category: Texts
          INTO TABLE @DATA(li_tvlzt)
          FOR ALL ENTRIES IN @li_veda
          WHERE spras = @lst_vbak-spras
          AND vlaufk = @li_veda-vlaufk.
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
        READ TABLE li_veda INTO lst_veda WITH KEY vposn = lst_vbfa-posnv.
        IF sy-subrc EQ 0.
          lv_date = lst_veda-vbegdat.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE li_veda INTO lst_veda WITH KEY vposn = space.
          IF sy-subrc EQ 0.
            lv_date = lst_veda-vbegdat.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = lv_date
          IMPORTING
            year                          = lv_year
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.

        IF sy-subrc IS INITIAL.
          IF  fp_st_final-arktx IS NOT INITIAL.
            CONCATENATE lv_year
                        fp_st_final-arktx
                        INTO fp_st_final-arktx
                        SEPARATED BY space.
          ENDIF. " IF fp_st_final-arktx IS NOT INITIAL
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc IS INITIAL

****Assuming there will be only one item for every document

    READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln = fp_st_vbco3-vbeln   BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      v_waerk = lst_vbak-waerk.
*****BOC by ARABANERJE on 16/08/2017 for CR# ********************
      fp_st_final-currency = v_waerk.
      v_langu = lst_vbak-spras.
* BOC by PBANDLAPAL on 11-Sep-2017 for ERP-3402 ED2K908563
*      v_country = lst_vbak-land1.
      SELECT SINGLE land1 " Country Key
          INTO v_country
          FROM t001       " Company Codes
         WHERE bukrs = lst_vbak-bukrs_vf.
      IF sy-subrc EQ 0.
* To have the bukrs country for address country population.
        fp_st_address-bukrs_land1  = v_country.
      ENDIF. " IF sy-subrc EQ 0
* BOC by PBANDLAPAL on 11-Sep-2017 for ERP-3402 ED2K908563
*****EOC by ARABANERJE on 16/08/2017 for CR# ********************
    ENDIF. " IF sy-subrc IS INITIAL

*    fp_st_final-arktx =   fp_st_vbap-arktx.
    fp_st_final-reference = st_vbkd-ihrez.

* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
    IF li_vbap IS NOT INITIAL.
*** BOC BY SAYANDAS FOR ERP-6660
      i_vbap[] = li_vbap[].
*** EOC BY SAYANDAS FOR ERP-6660
      li_vbap_tmp[] = li_vbap[].
      SORT li_vbap_tmp BY matnr.
      DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING matnr.
      IF li_vbap_tmp IS NOT INITIAL.
*  Fetch media values from MARA
        SELECT matnr " Material Number
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
            volum
            ismhierarchlevl
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
           ismmediatype " Media Type
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
           ismnrinyear " Issue Number (in Year Number)
           ismyearnr   " Media issue year number
           ismcopynr   " Copy Number of Media Issue
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
          FROM mara " General Material Data
          INTO TABLE i_mara
          FOR ALL ENTRIES IN li_vbap_tmp
          WHERE matnr EQ li_vbap_tmp-matnr.
        IF sy-subrc EQ 0.
          SORT i_mara BY matnr.
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
          DATA(li_mara_temp2) = i_mara[].
          DELETE li_mara_temp2 WHERE ismhierarchlevl NE lc_hier2.

          IF li_mara_temp2 IS NOT INITIAL. " for level 2 product
            SELECT med_prod,
                   mpg_lfdnr,
                   matnr,
                   ismpubldate,
                   ismcopynr , " Copy Number of Media Issue
                   ismnrinyear " Issue Number (in Year Number)
              FROM jptmg0      " IS-M: Media Product Issue Sequence
              INTO TABLE @DATA(li_jptmg0_2)
              FOR ALL ENTRIES IN @li_mara_temp2
              WHERE med_prod = @li_mara_temp2-matnr.
            IF sy-subrc = 0.
              SORT li_jptmg0_2 BY ismpubldate.
              DELETE li_jptmg0_2 WHERE ismpubldate+0(4) NE lv_year1.
              SORT li_jptmg0_2 BY med_prod mpg_lfdnr.

**         To get start volume & issue
              DATA(li_jptmg) = li_jptmg0_2[].
              DELETE ADJACENT DUPLICATES FROM li_jptmg COMPARING med_prod.

***         BOC by MODUTTA on 09/02/18 for CR# XXX
              LOOP AT li_mara_temp2 INTO DATA(lst_mara_temp2).
                READ TABLE li_jptmg0_2 INTO DATA(lst_jptmg) WITH KEY med_prod = lst_mara_temp2-matnr
                                                                      BINARY SEARCH.
                IF sy-subrc EQ 0.
                  DATA(lv_tabix) = sy-tabix.
                  LOOP AT li_jptmg0_2 INTO DATA(lst_jptmg0_2) FROM lv_tabix.
                    IF lst_jptmg0_2-med_prod <> lst_mara_temp2-matnr.
                      EXIT.
                    ENDIF. " IF lst_jptmg0_2-med_prod <> lst_mara_temp2-matnr
**                Count Number of Issue
                    lst_iss_vol2-noi = lst_iss_vol2-noi + 1.
                  ENDLOOP. " LOOP AT li_jptmg0_2 INTO DATA(lst_jptmg0_2) FROM lv_tabix

                  READ TABLE li_jptmg WITH KEY med_prod = lst_jptmg-med_prod TRANSPORTING NO FIELDS.
                  IF sy-subrc EQ 0.
**                Material
                    lst_iss_vol2-matnr = lst_mara_temp2-matnr.

**                Start Volume
                    lst_iss_vol2-stvol = lst_jptmg-ismcopynr.

**                Start Issue
                    lst_iss_vol2-stiss = lst_jptmg-ismnrinyear.

                    APPEND lst_iss_vol2 TO li_iss_vol2.
                    CLEAR lst_iss_vol2.
                  ENDIF. " IF sy-subrc EQ 0
                ENDIF. " IF sy-subrc EQ 0
                CLEAR: lst_jptmg,lv_tabix,lst_mara_temp2.
              ENDLOOP. " LOOP AT li_mara_temp2 INTO DATA(lst_mara_temp2)
***         EOC by MODUTTA on 09/02/18 for CR# XXX
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF li_mara_temp2 IS NOT INITIAL
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
* Fetch ID codes of material from JPTIDCDASSIGN table
          SELECT matnr         " Material Number
                 idcodetype    " Type of Identification Code
                 identcode     " Identification Code
            FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
            INTO TABLE i_jptidcdassign
            FOR ALL ENTRIES IN li_vbap_tmp
            WHERE matnr      EQ li_vbap_tmp-matnr
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*        AND idcodetype EQ lc_journal.
              AND ( idcodetype EQ v_idcodetype_1
                  OR idcodetype EQ v_idcodetype_2 ).
*** EOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
          IF sy-subrc EQ 0.
            SORT i_jptidcdassign BY matnr idcodetype.
          ENDIF. " IF sy-subrc EQ 0
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_vbap_tmp IS NOT INITIAL
    ENDIF. " IF li_vbap IS NOT INITIAL
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045

  ENDIF. " IF sy-subrc IS INITIAL

* Perform to fetch data from KONV table for calculation
  PERFORM f_get_konv_data.

  CLEAR: li_vbap_hcomp[].

  li_vbap_hcomp[] = li_vbap[].
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
  CLEAR: li_vbap_tmp_uepos[],lv_no_uepos .
  li_vbap_tmp_uepos[] = li_vbap[].
  SORT li_vbap_tmp_uepos BY uepos.
  DELETE li_vbap_tmp_uepos WHERE uepos NE lc_posnr.
  DESCRIBE TABLE li_vbap_tmp_uepos LINES lv_no_uepos.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
*  DELETE li_vbap_hcomp WHERE uepos IS NOT INITIAL.
  li_vbap_tmp1[] = li_vbap[].
  li_vbap_tmp2[] = li_vbap[].
  SORT li_vbap_tmp2 BY posnr DESCENDING.
  DELETE li_vbap_tmp2 WHERE uepos IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_vbap_tmp2 COMPARING uepos.
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
  LOOP AT li_vbap_hcomp INTO lst_vbap.
***    BOC by MODUTTA on 08/01/2018 for CR_TBD
    CLEAR: lv_text.
    PERFORM read_text_matdesc  USING lst_vbap-matnr
                            CHANGING lv_text.
    IF lv_text IS NOT INITIAL.
      CONDENSE lv_text.
**      Journal/Description Text
      PERFORM read_text_module USING c_journal_txt
                               CHANGING lv_txtmodule_data.

      lst_arktx-journal_text = lv_txtmodule_data.
      CLEAR lv_txtmodule_data.

      v_arktx = lv_text.
      READ TABLE i_jptidcdassign INTO lst_jptidcdassign1 WITH KEY  matnr = lst_vbap-matnr
                                                                         idcodetype = v_idcodetype_2
                                                                         BINARY SEARCH.
      IF sy-subrc = 0.
        lv_identcode_zjcd = lst_jptidcdassign1-identcode.
        CONCATENATE lv_identcode_zjcd v_arktx INTO lst_arktx-journal_value SEPARATED BY lc_hyphen.
        CONDENSE lst_arktx-journal_value.
      ELSE. " ELSE -> IF sy-subrc = 0
        lst_arktx-journal_value = v_arktx.
      ENDIF. " IF sy-subrc = 0
*        lst_arktx = lv_text.
*      ENDIF. " IF lv_year IS NOT INITIAL
    ENDIF. " IF lv_text IS NOT INITIAL
    IF lst_arktx IS NOT INITIAL.
      APPEND lst_arktx TO i_arktx.
      CLEAR lst_arktx.
    ENDIF. " IF lst_arktx IS NOT INITIAL
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
    READ TABLE i_mara INTO DATA(lst_mara1) WITH KEY matnr = lst_vbap-matnr
                                                   BINARY SEARCH.
    IF sy-subrc = 0.
      CLEAR: lv_flag_di,
             lv_flag_ph.
      IF lst_mara1-ismmediatype EQ 'DI'.
        lv_flag_di = abap_true.
      ELSEIF lst_mara1-ismmediatype EQ 'PH'.
        lv_flag_ph = abap_true.
      ENDIF. " IF lst_mara1-ismmediatype EQ 'DI'
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
        IF lst_vbap-uepos IS INITIAL.
          DATA(li_all_media_product) =  i_vbap[].
          CLEAR: lst_digital,lst_print,li_print_media_product[],li_digital_media_product[].
          LOOP AT li_all_media_product INTO DATA(lst_all_media) WHERE uepos = lst_vbap-posnr.
            IF lst_all_media-mvgr4 IN r_print_product.
              MOVE-CORRESPONDING lst_all_media TO lst_print.
              APPEND lst_print TO li_print_media_product.
              CLEAR lst_print.
            ENDIF.
            IF lst_all_media-mvgr4 IN r_digital_product.
              MOVE-CORRESPONDING lst_all_media TO lst_digital.
              APPEND lst_digital TO li_digital_media_product.
              CLEAR lst_digital.
            ENDIF.
            CLEAR lst_all_media.
          ENDLOOP.
          IF li_print_media_product[] IS INITIAL AND li_digital_media_product[] IS NOT INITIAL.
            lv_flag_di = abap_true.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS INITIAL.
            lv_flag_ph = abap_true.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS NOT INITIAL.
            CLEAR :lv_flag_ph,lv_flag_di.
          ENDIF.
        ENDIF.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
      CLEAR : lv_name1,
              lv_subscription_typ.

      IF lv_flag_di EQ abap_true.
        lv_name1 = lc_digt_subsc.
*       Subroutine to get subscription type text (Digital subscription)
        PERFORM f_get_subscrption_type USING lv_name1
                                    CHANGING lv_subscription_typ.

*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
        lv_name_issn = lc_digissn.
        PERFORM f_get_text_val USING lv_name_issn
                            CHANGING lv_pnt_issn.
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX

      ELSEIF lv_flag_ph EQ abap_true.
        lv_name1 = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
        PERFORM f_get_subscrption_type USING lv_name1
                                    CHANGING lv_subscription_typ.
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
        lv_name_issn = lc_pntissn.
        PERFORM f_get_text_val USING lv_name_issn
                            CHANGING lv_pnt_issn.
*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
      ELSE. " ELSE -> IF lv_flag_di EQ abap_true
        lv_name1 = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
        PERFORM f_get_subscrption_type USING lv_name1
                                    CHANGING lv_subscription_typ.

        lv_name_issn = lc_combissn.
        PERFORM f_get_text_val USING lv_name_issn
                            CHANGING lv_pnt_issn.
      ENDIF. " IF lv_flag_di EQ abap_true


      IF lst_vbap-uepos IS INITIAL.
        IF lv_subscription_typ IS NOT INITIAL.
          lst_arktx-journal_value = lv_subscription_typ.
*** Subscription Type Text
          PERFORM read_text_module USING c_subtype_txt
                                   CHANGING lv_txtmodule_data.

          lst_arktx-journal_text = lv_txtmodule_data.
          CLEAR lv_txtmodule_data.
        ENDIF. " IF lv_subscription_typ IS NOT INITIAL

        IF lst_arktx IS NOT INITIAL.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF. " IF lst_arktx IS NOT INITIAL
*     Begin of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
*-------------------Multi-Year Subs---------------------------------*
*        lv_name1 = lc_mlsubs.
*        CLEAR lst_arktx.
*        PERFORM f_get_text_val USING lv_name1
*                            CHANGING lv_mlsub.
*        CONCATENATE lv_mlsub lc_colon INTO lv_mlsub.
*        lst_arktx-journal_text = lv_mlsub.
*
*        READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY vbeln = lst_vbap-vbeln
*                                                vposn = lst_vbap-posnr
*                                                BINARY SEARCH.
*        IF sy-subrc = 0.
*          READ TABLE li_tvlzt INTO DATA(lst_tvlzt1) WITH KEY spras = v_langu
*                                                             vlaufk = lst_veda1-vlaufk
*                                                             BINARY SEARCH.
*          IF sy-subrc EQ 0
*            AND lst_tvlzt1-bezei IS NOT INITIAL.
*
**            CONCATENATE lv_mlsub lst_tvlzt1-bezei INTO lst_arktx SEPARATED BY lc_colon.
*            lst_arktx-journal_value = lst_tvlzt1-bezei.
*            APPEND lst_arktx TO i_arktx.
*            CLEAR lst_arktx.
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF. " IF sy-subrc = 0
*    End of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
      ENDIF. " IF lst_vbap-uepos IS INITIAL

      READ TABLE li_vbap_tmp1  WITH KEY uepos = lst_vbap-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_bhf = abap_true.
      ENDIF. " IF sy-subrc = 0
      IF lv_bhf IS INITIAL.
****** YEAR
        CLEAR lst_arktx.
*        lv_name1 = lc_year. "CR-7841:SGUDA:30-Apr-2019:ED1K910091
        lv_name1 = lc_cntr_start. "CR-7841:SGUDA:30-Apr-2019:ED1K910091
        CLEAR lv_year_1. "CR-7841:SGUDA:30-Apr-2019:ED1K910091
        PERFORM f_get_text_val USING lv_name1
                            CHANGING lv_year_1.
* Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910091
        lv_name1 = lc_cntr_end.
        CLEAR lv_cntr_end.
        PERFORM f_get_text_val USING lv_name1
                            CHANGING lv_cntr_end.
*Begin of ADD:INC0229598:RBTIRUMALA:18.02.2019:ED1K909641
        CLEAR lst_veda.
        READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                                  vposn = lst_vbap-posnr
                                                  BINARY SEARCH.
        IF lst_veda-vbegdat IS INITIAL.
          CLEAR lst_veda.
          READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                                    vposn = lc_posnr
                                                    BINARY SEARCH.
        ENDIF.
*        IF NOT lst_veda IS INITIAL. ""CR-7841:SGUDA:30-Apr-2019:ED1K910091
*End of ADD:INC0229598:RBTIRUMALA:18.02.2019:ED1K909641
* End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910091
* Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910091
        IF lst_veda-vbegdat IS NOT INITIAL.
          CLEAR : lv_cntr, lv_cntr_month,lv_day,lv_month,lv_year2,lv_stext,lv_ltext.
          CONCATENATE lv_year_1 lc_colon INTO lst_arktx-journal_text.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = lst_veda-vbegdat
            IMPORTING
              day                           = lv_day
              month                         = lv_month
              year                          = lv_year2
              stext                         = lv_stext
              ltext                         = lv_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE lv_day lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_hyphen.
          CONDENSE lv_cntr.
          lst_arktx-journal_value  = lv_cntr.
          CONDENSE lst_arktx-journal_value.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF.
        IF lst_veda-venddat IS NOT INITIAL.
          CLEAR : lv_cntr, lv_cntr_month,lv_day,lv_month,lv_year2,lv_stext,lv_ltext.
          CONCATENATE lv_cntr_end lc_colon INTO lst_arktx-journal_text.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = lst_veda-venddat
            IMPORTING
              day                           = lv_day
              month                         = lv_month
              year                          = lv_year2
              stext                         = lv_stext
              ltext                         = lv_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE lv_day lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_hyphen.
          CONDENSE lv_cntr.
          lst_arktx-journal_value  = lv_cntr.
          CONDENSE lst_arktx-journal_value.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF.
* End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910091
** Total of Issues, Start Volume, Start Issue
        IF lst_mara1-ismhierarchlevl EQ '2'.
          READ TABLE li_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara1-matnr.
          IF sy-subrc EQ 0.
            DATA(lst_issue_vol) = lst_issue_vol2.
          ENDIF. " IF sy-subrc EQ 0
        ELSEIF lst_mara1-ismhierarchlevl EQ '3'.
          lst_issue_vol-stvol = lst_mara1-ismcopynr.
          lst_issue_vol-noi = lst_mara1-ismnrinyear.
          lst_issue_vol-stiss = '1'.
        ENDIF. " IF lst_mara1-ismhierarchlevl EQ '2'

***Start Volume
        IF lst_issue_vol IS NOT INITIAL.
*         Start Volume
          lv_name1 = lc_volume.
          PERFORM f_get_text_val USING lv_name1
                              CHANGING lv_volum.
          lst_arktx-journal_text = lv_volum.

          IF lst_issue_vol-stvol IS NOT INITIAL.
*            CONCATENATE lv_volum lst_issue_vol-stvol INTO lv_issue_desc SEPARATED BY space.
*            CONCATENATE space lst_issue_vol-stvol INTO lv_issue_desc.
            MOVE lst_issue_vol-stvol TO lv_issue_desc.
            IF lst_arktx-journal_value IS NOT INITIAL.
              CONCATENATE lst_arktx-journal_value lc_comma lv_issue_desc INTO lst_arktx-journal_value.
            ELSE. " ELSE -> IF lst_arktx-journal_value IS NOT INITIAL
              lst_arktx-journal_value = lv_issue_desc.
            ENDIF. " IF lst_arktx-journal_value IS NOT INITIAL
            CONDENSE lst_arktx-journal_value.
          ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

* Total Issues
          lv_name1 = lc_issue.
          CLEAR: lv_issue,lv_issue_desc.
          PERFORM f_get_text_val USING lv_name1
                              CHANGING lv_issue.
          IF lst_issue_vol-noi IS NOT INITIAL.
            MOVE lst_issue_vol-noi TO lv_vol.
            CONCATENATE lv_vol lv_issue INTO lv_issue_desc SEPARATED BY space.
            IF lst_arktx-journal_value IS NOT INITIAL.
              CONCATENATE lst_arktx-journal_value lc_comma lv_issue_desc INTO lst_arktx-journal_value.
            ELSE. " ELSE -> IF lst_arktx-journal_value IS NOT INITIAL
              lst_arktx-journal_value = lv_issue_desc.
            ENDIF. " IF lst_arktx-journal_value IS NOT INITIAL
            CONDENSE lst_arktx-journal_value.
          ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL

        ENDIF. " IF lst_issue_vol IS NOT INITIAL

        IF lst_arktx IS NOT INITIAL.
*          CONDENSE lst_arktx.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF. " IF lst_arktx IS NOT INITIAL

*****Start Issue Number
        IF lst_issue_vol IS NOT INITIAL.
*          lv_name1 = lc_stiss.
*          PERFORM f_get_text_val USING lv_name1
*                              CHANGING lv_issue.
          PERFORM read_text_module USING c_stissue_txt
                                   CHANGING lv_txtmodule_data.

          lst_arktx-journal_text = lv_txtmodule_data.
          CLEAR lv_txtmodule_data.

          IF lst_issue_vol-stiss IS NOT INITIAL.
*            CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_arktx SEPARATED BY space.
            lst_arktx-journal_value = lst_issue_vol-stiss.
            CONDENSE lst_arktx-journal_value.
            APPEND lst_arktx TO i_arktx.
            CLEAR lst_arktx.
          ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
        ENDIF. " IF lst_issue_vol IS NOT INITIAL

*-------ISSN---------------------------------------------------------*
        CLEAR lst_arktx.
        READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign2) WITH KEY matnr = lst_vbap-matnr
                                                                         idcodetype = v_idcodetype_1 "(++ BOC by SAYANDAS for CR_XXX)
                                                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
          CONCATENATE lv_pnt_issn lc_colon INTO lv_pnt_issn.
          lst_arktx-journal_text = lv_pnt_issn.

          IF lst_jptidcdassign2-identcode IS NOT INITIAL.
            lv_identcode = lst_jptidcdassign2-identcode.
*            CONCATENATE lv_pnt_issn lst_jptidcdassign2-identcode INTO lst_arktx  SEPARATED BY lc_colonb.
            lst_arktx-journal_value = lst_jptidcdassign2-identcode.
            CONDENSE lst_arktx-journal_value.
          ENDIF. " IF lst_jptidcdassign2-identcode IS NOT INITIAL
        ENDIF. " IF sy-subrc EQ 0
*        lst_final1-prod_des = lst_vbap-arktx.
        IF lst_arktx IS NOT INITIAL.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF. " IF lst_arktx IS NOT INITIAL

      ENDIF. " IF lv_bhf IS INITIAL
*     Begin of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
      CLEAR: lst_arktx,lv_name1,lv_mlsub.
      lv_name1 = lc_sub_term.
      PERFORM f_get_text_val USING lv_name1
                          CHANGING lv_mlsub.
      CONCATENATE lv_mlsub lc_colon INTO lv_mlsub.
      lst_arktx-journal_text = lv_mlsub.

      READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                              vposn = lst_vbap-posnr
                                              BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE li_tvlzt INTO DATA(lst_tvlzt) WITH KEY spras = v_langu
                                                           vlaufk = lst_veda-vlaufk
                                                           BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lst_tvlzt-bezei IS NOT INITIAL.
          lst_arktx-journal_value = lst_tvlzt-bezei.
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF. " IF sy-subrc EQ 0
      ELSE.
        READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE li_tvlzt INTO DATA(lst_tvlzt_tmp) WITH KEY spras = v_langu
                                                             vlaufk = lst_veda-vlaufk
                                                             BINARY SEARCH.
          IF sy-subrc EQ 0
            AND lst_tvlzt_tmp-bezei IS NOT INITIAL.
            lst_arktx-journal_value = lst_tvlzt_tmp-bezei.
            APPEND lst_arktx TO i_arktx.
            CLEAR lst_arktx.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF.
      ENDIF. " IF sy-subrc = 0
*      IF lst_arktx IS NOT INITIAL.
*        APPEND lst_arktx TO i_arktx.
*        CLEAR lst_arktx.
*      ENDIF. " IF lst_arktx IS NOT INITIAL
*     End of ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178


      READ TABLE li_vbap_tmp2 WITH KEY posnr = lst_vbap-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_lcf = abap_true.
      ENDIF. " IF sy-subrc = 0
      IF ( lst_vbap-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL ).
        CLEAR: lst_arktx.
        READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY  vbeln = lst_vbap-vbeln
                                                    posnr = lst_vbap-posnr
                                                    BINARY SEARCH.
        IF  sy-subrc EQ 0 AND lst_vbkd-ihrez IS NOT INITIAL.
          lst_arktx-journal_value = lst_vbkd-ihrez.
*         Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
          CLEAR: lv_sub_ref_id.
*          PERFORM f_get_subscrption_type USING lc_sub_ref_id
*                                      CHANGING lv_sub_ref_id.

* BOC: CR#7730 KKRAVURI20181024  ED2K913666
          IF ( r_mat_grp5[] IS NOT INITIAL AND r_output_typ[] IS NOT INITIAL ) AND
             ( lst_vbap-mvgr5 IN r_mat_grp5 AND nast-kschl IN r_output_typ ).
            PERFORM f_get_subscrption_type  USING c_membership_number
                                         CHANGING lv_mem_num_txt.
            lv_txtmodule_data = lv_mem_num_txt.
            CLEAR lv_mem_num_txt.
          ELSE.
            PERFORM read_text_module USING c_subref_txt
                                     CHANGING lv_txtmodule_data.
          ENDIF.
* EOC: CR#7730 KKRAVURI20181024  ED2K913666

          lst_arktx-journal_text = lv_txtmodule_data.
          CLEAR lv_txtmodule_data.

*          IF lv_sub_ref_id IS NOT INITIAL.
*            CONCATENATE lv_sub_ref_id
*                        lst_arktx
*                   INTO lst_arktx
*              SEPARATED BY space.
*          ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*         End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908539
          APPEND lst_arktx TO i_arktx.
          CLEAR lst_arktx.
        ENDIF. " IF sy-subrc EQ 0 AND lst_vbkd-ihrez IS NOT INITIAL
      ENDIF. " IF ( lst_vbap-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )
    ENDIF. " IF sy-subrc = 0

*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
***    EOC by MODUTTA on 08/01/2018 for CR_TBD
    READ TABLE li_vbap INTO lst_vbap_itmcmp WITH KEY uepos = lst_vbap-posnr.
    IF sy-subrc IS INITIAL.
****     Commented by MODUTTA on 08/01/2018 for CR_TBD
*      lst_arktx   = lst_vbap-arktx.
*      IF lv_year IS NOT INITIAL.
*        CONCATENATE lv_year
*                  lst_arktx
*                  INTO lst_arktx
*                  SEPARATED BY space.
*      ENDIF.
*      APPEND lst_arktx TO i_arktx.
*      CLEAR lst_arktx.
****    End of comment by MODUTTA on 08/01/2018 for CR_TBD
      lv_itmcomp_indx = sy-tabix.
      LOOP AT li_vbap INTO lst_vbap_tmp FROM lv_itmcomp_indx
                                       WHERE uepos = lst_vbap-posnr.
        lv_tax = lv_tax + lst_vbap_tmp-kzwi6.
***BOC for MODUTTA on 10/01/2018 for CR# TBD
        READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap_tmp-matnr
                                                       BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lv_name IS INITIAL.
          lv_name = lc_comb_sub.
        ENDIF. " IF sy-subrc EQ 0
***EOC for MODUTTA on 10/01/2018 for CR# TBD
* BOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
* To calculate abd build tax details
*        PERFORM calculate_and_build_taxdtls USING lst_vbap_tmp.
* EOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
        CLEAR lst_vbap_tmp.
        CLEAR: lst_arktx,lst_issue_vol,lst_issue_vol2,lv_bhf,lv_lcf.
      ENDLOOP. " LOOP AT li_vbap INTO lst_vbap_tmp FROM lv_itmcomp_indx
* For Non BOM Scenario
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
***BOC for MODUTTA on 10/01/2018 for CR# TBD
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap-matnr
                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF lst_mara-ismmediatype = c_mediatyp_dgtl.
          lv_name = lc_digi_sub.
        ELSEIF lst_mara-ismmediatype = c_mediatyp_prnt.
          lv_name = lc_print_sub.
        ELSEIF lst_mara-ismmediatype = c_mediatyp_comb.
          lv_name = lc_comb_sub.
        ENDIF. " IF lst_mara-ismmediatype = c_mediatyp_dgtl
      ENDIF. " IF sy-subrc EQ 0
***EOC for MODUTTA on 10/01/2018 for CR# TBD
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      IF lst_vbap-uepos IS INITIAL.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
        lv_tax = lv_tax + lst_vbap-kzwi6.
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      ENDIF. " IF lst_vbap-uepos IS INITIAL
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    ENDIF. " IF sy-subrc IS INITIAL

*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    IF lst_vbap-uepos IS INITIAL.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
      IF lv_no_uepos = 1.
        lv_net = lv_net + lst_vbap-kzwi2.
      ELSE.
**For net amount
        lv_net = lv_net + lst_vbap-kzwi1.
      ENDIF.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    ENDIF. " IF lst_vbap-uepos IS INITIAL
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
  ENDLOOP. " LOOP AT li_vbap_hcomp INTO lst_vbap
* Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
**For net amount
  WRITE lv_net TO lv_net_char CURRENCY v_waerk.
  CONDENSE lv_net_char.
  fp_st_final-net_amt = lv_net_char.

***For total amount
  v_tot = lv_net + lv_tax.
  WRITE v_tot TO lv_tot_char CURRENCY v_waerk.
  CONDENSE lv_tot_char.
  fp_st_final-tot_amt = lv_tot_char.
* End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265

***BOC for MODUTTA on 10/01/2018 for CR# TBD
****Get subscription type
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
* BOC by PBANDLAPAL on 30/01/2018 for CR# TBD
*     language                = nast-spras "lc_langu
      language                = st_address-spras
* EOC by PBANDLAPAL on 30/01/2018 for CR# TBD
      name                    = lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  READ TABLE li_lines INTO lst_lines INDEX 1.
  IF sy-subrc EQ 0.
    v_subs_type = lst_lines-tdline.
  ENDIF. " IF sy-subrc EQ 0
***EOC for MODUTTA on 10/01/2018 for CR# TBD

  PERFORM build_and_popul_amt_tax_dtls.
* EOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BILL_ADDR
*&---------------------------------------------------------------------*
* This perform is used to get the details of address for bill to address
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3
*----------------------------------------------------------------------*
FORM f_get_bill_addr  USING    fp_st_vbco3 TYPE vbco3             " Sales Doc.Access Methods: Key Fields: Document Printing
                    CHANGING fp_st_address TYPE zstqtc_addr_f032. " Structure for address node
*******Local Constant declaration
  CONSTANTS: lc_ag       TYPE parvw VALUE 'AG', " Ship to party
             lc_parvw_we TYPE parvw VALUE 'WE'. " Bill to Party

  DATA: lst_vbpa      TYPE   ty_vbpa.

*******To populate the Bill to Address need to fetch data from VBPA table
  SELECT vbeln "Sales and Distribution Document Number
         posnr "Item number of the SD document
         parvw "Partner Function
         kunnr " Customer Number
         adrnr "Address
         land1 "Country Key
    FROM vbpa  " Sales Document: Partner
    INTO TABLE i_vbpa
    WHERE vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
*******Read the local internal table to fetch the customer number, address number and country key
*******by passing Partner Function as AG because for Ship-To-Party if we pass BP it has been
*******converted to AG. So AG has been used to populate Ship-To-Party address
    CLEAR: st_vbpa.
    READ TABLE i_vbpa INTO st_vbpa WITH TABLE KEY parvw COMPONENTS vbeln = fp_st_vbco3-vbeln
                                                                     parvw = lc_ag.

    IF sy-subrc IS INITIAL.
      fp_st_address-kunnr = st_vbpa-kunnr. "Customer Number
      fp_st_address-adrnr = st_vbpa-adrnr. "Address Number
* BOC by PBANDLAPAL on 11-Sep-2017 for ERP-4320 ED2K908431
*      fp_st_address-land1 = st_vbpa-land1. "Country key
      SELECT SINGLE
      kunnr,    "Customer Number
      land1,    "Country Key
      spras     "Language Key
      FROM kna1 " General Data in Customer Master
      INTO @DATA(lst_kna1)
      WHERE kunnr = @st_vbpa-kunnr.
      IF sy-subrc EQ 0.
        fp_st_address-land1 = lst_kna1-land1. "Country key
        fp_st_address-spras = lst_kna1-spras. "Language key
      ENDIF. " IF sy-subrc EQ 0
* EOC by PBANDLAPAL on 11-Sep-2017 for ERP-4320 ED2K908431

    ENDIF. " IF sy-subrc IS INITIAL
    READ TABLE i_vbpa INTO lst_vbpa WITH TABLE KEY parvw COMPONENTS vbeln = fp_st_vbco3-vbeln
                                                                     parvw = lc_parvw_we.

    IF sy-subrc IS INITIAL.
      fp_st_address-adrnr_sh = lst_vbpa-adrnr. "Address Number
******      BOC by MODUTTA on 10/01/2018 for CR# TBD
      DATA(lv_ship_to_cust) = lst_vbpa-kunnr.
******      EOC by MODUTTA on 10/01/2018 for CR# TBD
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
******      BOC by MODUTTA on 10/01/2018 for CR# TBD
  IF lv_ship_to_cust IS NOT INITIAL.
    SELECT society_name     " Society Name
      FROM zqtc_jgc_society " I0222: Journal Group Code to Society Mapping
      UP TO 1 ROWS
      INTO @DATA(lv_society)
      WHERE society = @lv_ship_to_cust.
    ENDSELECT.
    IF sy-subrc EQ 0.
      v_society = lv_society.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_ship_to_cust IS NOT INITIAL
******      EOC by MODUTTA on 10/01/2018 for CR# TBD
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SOCIETY_LOGO
*&---------------------------------------------------------------------*
*        Society logo has been populated in this perform
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3  text
*      <--FP_V_SOCIETY_LOGO
*----------------------------------------------------------------------*
FORM f_get_society_logo  USING    fp_st_vbco3 TYPE vbco3 " Sales Doc.Access Methods: Key Fields: Document Printing
                         CHANGING fp_v_society_logo TYPE xstring.

********Local constant declaration
  CONSTANTS : lc_order  TYPE char10     VALUE 'ORDER',    " Order of type CHAR10
              lc_object TYPE tdobjectgr VALUE 'GRAPHICS', " SAPscript Graphics Management: Application object
              lc_id     TYPE tdidgr     VALUE 'BMAP',     " SAPscript Graphics Management: ID
              lc_btype  TYPE tdbtype    VALUE 'BCOL'.     " Graphic type

********Local Data declaration
  DATA: lv_society_logo TYPE char100,  "variable of society logo
        lv_logo_name    TYPE tdobname. " Name

*******Get the name of LOGO for Form
  CALL FUNCTION 'ZQTC_GET_FORM_LOGO_NAME'
    EXPORTING
      im_doc_no                     = fp_st_vbco3-vbeln
      im_doc_type                   = lc_order
    IMPORTING
      ex_logo_name                  = lv_society_logo
*     Begin of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911265
*     ex_sold_to_name               = v_society_name
*     End   of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911265
    EXCEPTIONS
      non_society_customers         = 1
      non_society_materials         = 2
      invalid_document_number       = 3
      invalid_document_type         = 4
      material_group_not_maintained = 5
      OTHERS                        = 6.

  IF sy-subrc EQ 0.
    lv_logo_name = lv_society_logo.
  ENDIF. " IF sy-subrc EQ 0

* BOC by PBANDLAPAL on 23-Jan-2018: ED2K910441
*  IF lv_society_logo IS INITIAL AND v_society_name IS INITIAL.
*    v_flag_cust = '1'.
*  ENDIF. " IF lv_society_logo IS INITIAL AND v_society_name IS INITIAL
* EOC by PBANDLAPAL on 23-Jan-2018: ED2K910441
******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object         " GRAPHICS
      p_name         = lv_logo_name
      p_id           = lc_id             " BMAP
      p_btype        = lc_btype          " BMON
    RECEIVING
      p_bmp          = fp_v_society_logo " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_STD_TEXT
*&---------------------------------------------------------------------*
*       This perform is usd to call the standard text dynamically
*       based on company code and currency key
*----------------------------------------------------------------------*

FORM f_populate_std_text  USING    fp_st_vbco3 TYPE vbco3 " Sales Doc.Access Methods: Key Fields: Document Printing
                                   fp_st_vbpa  TYPE ty_vbpa
* BOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
                                   fp_st_vbap  TYPE ty_vbap
* EOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
                          CHANGING fp_v_footer TYPE thead-tdname    " Name
                                   fp_v_compname TYPE thead-tdname. " Name

*******Local data declaration
  DATA: lst_vbak        TYPE ty_vbak,  "Local workarea for structure vbak
        lv_bukrs_vf     TYPE bukrs_vf, "Local variable for company code
        lv_days         TYPE char2,
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
        lv_credit_card1 TYPE char23, " Credit_card1 of type CHAR23
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
* BEGIN of change by APATNAIK: 30-June-2017: #TR: ED2K906742
        li_lines        TYPE STANDARD TABLE OF tline, " Lines of text read
        li_lines_d      TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines       TYPE tline,                   " Lines of text read
        lv_kunnr_sp     TYPE kunnr,                   " Customer Number
        lv_kunnr_za     TYPE kunnr.                   " Customer Number
* END of change by APATNAIK: 30-June-2017: #TR: ED2K906742
*****Local data declaration

  DATA : lv_day           TYPE char2,    " Date of type CHAR2
         lv_month_c2      TYPE char2,    " Mnthc2 of type CHAR2
         lv_month_c3      TYPE char3,    " Mnthc3 of type CHAR3
         lv_month         TYPE t247-ltx, " Month long text
         lv_year          TYPE char5,    " Year of type CHAR5
         lv_datum_advnce  TYPE char15,   " Advance date of char 15
         lv_due_datum     TYPE angdt_v,  " variable of date type angdt_v
         lv_datum_pay_due TYPE char15,   " Pay due date of char15
         lv_name1         TYPE thead-tdname, " Name
         lv_mlsub         TYPE string,
         lv_fkdat         TYPE  angdt_v.   " Advance date of char 15 ""ADD:RITM0093866:SGUDA:01-DECEMBER-2018:ED1K909062
******Local constant declaration

  CONSTANTS :      lc_hyphen TYPE char01      VALUE '-'. "Constant for hyphen
*******Local Constant declaration
  CONSTANTS: lc_underscore    TYPE char1  VALUE '_',          " Underscore
             lc_txtname_part1 TYPE char10 VALUE 'ZQTC_F032_', " Txtname_part1 of type CHAR20
* Begin of Insert by PBANDLAPAL on 11-Sep-2017 for ERP-3402: ED2K908431
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
             lc_char_1        TYPE char1 VALUE '1', " Char_1 of type CHAR1
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
             lc_comp_name     TYPE char10 VALUE 'COMP_NAME_', " Comp_name of type CHAR10
* End of Insert by PBANDLAPAL on 11-Sep-2017 for ERP-3402: ED2K908431
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
             lc_remto         TYPE char10         VALUE 'REMIT_TO_',               " Remto of type CHAR10
             lc_xxx           TYPE char3          VALUE 'XXX',                     " Xxx of type CHAR3
             lc_class         TYPE char5          VALUE 'ZQTC_',                   " Class of type CHAR5
             lc_tbt_agency1   TYPE char22         VALUE 'ZQTC_F032_CUST_AGENCY_',  " Tbt_agency1 of type CHAR22
             lc_cust_serv     TYPE char23         VALUE 'ZQTC_F032_CUST_SERVICE_', " Cust_serv of type CHAR23
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
*****BOC by ARABANERJE on 16/08/2017 for CR# ********************
             lc_footer        TYPE char10 VALUE 'FOOTER_',      " Txtname_part2 of type CHAR6
             lc_remit_to      TYPE char10 VALUE 'REMIT_TO_',    " Txtname_part2 of type CHAR6
             lc_txtname_part2 TYPE char15 VALUE 'ZQTC_F035_US', " Txtname_part1 of type CHAR20
             lc_txtname_part3 TYPE char15 VALUE 'ZQTC_F035_UK', " Txtname_part1 of type CHAR20
             lc_comp          TYPE char10 VALUE 'WILEY',        " Comp of type CHAR10
*****EOC by ARABANERJE on 16/08/2017 for CR# ********************
             lc_footer1       TYPE char10 VALUE 'FOOTER1', " Txtname_part2 of type CHAR6
             lc_cc            TYPE bukrs  VALUE '3310',    " Company Code
* BEGIN of change by APATNAIK: 30-June-2017: #TR: ED2K906742
             lc_banking1      TYPE char9  VALUE 'BANKING1_',      " Banking1 of type CHAR9
             lc_banking2      TYPE char9  VALUE 'BANKING2_',      " Banking2 of type CHAR9
             lc_cust          TYPE char13 VALUE 'CUST_SERVICE_',  " Cust of type CHAR13
             lc_agency        TYPE char13 VALUE 'CUST_AGENCY_',   " Cust of type CHAR13
             lc_email         TYPE char13  VALUE 'EMAIL_',        " Email of type CHAR6
             lc_email_agency  TYPE char13  VALUE 'EMAIL_AGENCY_', " Email of type CHAR6
             lc_credit        TYPE char7  VALUE 'CREDIT_',        " Credit of type CHAR7
             lc_tbt           TYPE char3  VALUE  'TBT',           " Tbt of type CHAR3
             lc_scc           TYPE char3  VALUE  'SCC',           " Scc of type CHAR3
             lc_scm           TYPE char3  VALUE  'SCM',           " Scm of type CHAR3
             lc_sp            TYPE parvw  VALUE 'AG',             " Partner Function
             lc_za            TYPE parvw  VALUE 'ZA',             " Partner Function
             lc_st            TYPE thead-tdid     VALUE 'ST',     "Text ID of text to be read
             lc_object        TYPE thead-tdobject VALUE 'TEXT',   "Object of text to be read
* END of change by APATNAIK: 30-June-2017: #TR: ED2K906742
* BOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*             lc_body          TYPE thead-tdname VALUE   'ZQTC_MAIL_BODY1_F032'.
             lc_body          TYPE thead-tdname VALUE   'ZQTC_MAIL_BODY1_F032N'.
* EOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
  SORT i_vbpa BY vbeln parvw.  "ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
  SORT i_std_text BY tdname.   "ADD:ERP-7119:SGUDA:8-SEP-2018:ED2K913178
  CLEAR : lst_vbak.
*******The i_vbak table is already sorted.
*******Here read table is used to get the company code and currency key
  READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = fp_st_vbco3-vbeln
                                  BINARY SEARCH.
  IF sy-subrc IS INITIAL.
*    v_waerk    = lst_vbak-waerk.
    lv_bukrs_vf = lst_vbak-bukrs_vf.
  ENDIF. " IF sy-subrc IS INITIAL


* Begin of change by APATNAIK: 30-June-2017: #TR:  ED2K906742
  CLEAR fp_st_vbpa.
  READ TABLE i_vbpa INTO fp_st_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                           parvw = lc_sp
                                           BINARY SEARCH.
  IF  sy-subrc IS INITIAL.
    lv_kunnr_sp = fp_st_vbpa-kunnr.
  ENDIF. " IF sy-subrc IS INITIAL

  CLEAR fp_st_vbpa.
  READ TABLE i_vbpa INTO fp_st_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                           parvw = lc_za
                                           BINARY SEARCH.
  IF  sy-subrc IS INITIAL.
    lv_kunnr_za = fp_st_vbpa-kunnr.
  ENDIF. " IF sy-subrc IS INITIAL

* Begin of Change by PBANDLAPAL on 11-Sep-2017 for ERP-3402: ED2K908431
******BOC by ARABANERJE on 16/08/2017 for CR# ********************
*  IF v_country EQ 'US'.
*    CONCATENATE lc_txtname_part2
*                lc_underscore
*                lc_comp
*        INTO    fp_v_compname.
*    CONDENSE fp_v_compname NO-GAPS.
*
*  ELSE. " ELSE -> IF v_country EQ 'US'
*    CONCATENATE lc_txtname_part3
*              lc_underscore
*              lc_comp
*      INTO    fp_v_compname.
*    CONDENSE fp_v_compname NO-GAPS.
*
*  ENDIF. " IF v_country EQ 'US'
******EOC by ARABANERJE on 16/08/2017 for CR# ********************
****** To populate the company name.
  CONCATENATE lc_txtname_part1
              lc_comp_name
              lv_bukrs_vf
              lc_underscore
              v_waerk
         INTO fp_v_compname.
  CONDENSE fp_v_compname NO-GAPS.
* End of Change by PBANDLAPAL on 11-Sep-2017 for ERP-3402: ED2K908431

*** If there is no ZA partner function at all then it is Title By Title
  IF fp_st_vbpa-parvw NE lc_za.
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
    v_flag_cust = lc_char_1.
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
********Populate remit to address
    CONCATENATE lc_txtname_part1
                lc_remit_to
                lv_bukrs_vf
                lc_underscore
                v_waerk
                lc_underscore
                lc_tbt
           INTO v_remit_to_tbt.
    CONDENSE v_remit_to_tbt NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
    READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = v_remit_to_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
     OR st_address-land1 IN r_sanc_countries.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
      CLEAR : v_remit_to_tbt.
      CONCATENATE lc_class
                  lc_remto
                  lc_xxx
                  INTO v_remit_to_tbt.
    ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**********Populate banking1
    CONCATENATE lc_txtname_part1
                lc_banking1
                lv_bukrs_vf
                lc_underscore
                v_waerk
                lc_underscore
                lc_tbt
           INTO v_banking1_tbt.
    CONDENSE v_banking1_tbt NO-GAPS.

**********Populate banking2
    CONCATENATE lc_txtname_part1
            lc_banking2
            lv_bukrs_vf
            lc_underscore
            v_waerk
            lc_underscore
            lc_tbt
       INTO v_banking2_tbt.
    CONDENSE v_banking2_tbt NO-GAPS.
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
    IF v_remit_to_tbt CS lc_xxx
    OR st_address-land1 IN r_sanc_countries.
      CLEAR: v_banking1_tbt,
             v_banking2_tbt.
    ENDIF.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
***********Populate customer service
**** BOC by SRBOSE on 15-JAN-2018 #CR_TBD #TR: ED2K909616
    IF v_kvgr1 EQ v_psb.
      DATA(lv_cust_serv) = lc_agency.
    ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
      lv_cust_serv  = lc_cust.
    ENDIF. " IF v_kvgr1 EQ v_psb
*  **** BOC by SRBOSE on 15-JAN-2018 #CR_TBD #TR: ED2K909616

    CONCATENATE lc_txtname_part1
        lv_cust_serv
        lv_bukrs_vf
        lc_underscore
        v_waerk
        lc_underscore
        lc_tbt
   INTO v_cust_serv_tbt.
    CONDENSE v_cust_serv_tbt NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_cust_serv_tbt.
      IF v_kvgr1 EQ v_psb.
        lv_credit_card1 = lc_tbt_agency1.
      ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
        lv_credit_card1 = lc_cust_serv.
      ENDIF. " IF v_kvgr1 EQ v_psb

      CONCATENATE lv_credit_card1
                  lv_bukrs_vf
                  lc_underscore
                  lc_tbt
                  lc_underscore
                  lc_xxx
                  INTO v_cust_serv_tbt.
      CONDENSE v_cust_serv_tbt NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**********Populate footer
    CONCATENATE lc_txtname_part1
    lc_footer
    lv_bukrs_vf
    lc_underscore
    v_waerk
    lc_underscore
    lc_tbt
INTO v_footer_tbt.
    CONDENSE v_footer_tbt NO-GAPS.
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_footer_tbt.
      CONCATENATE lc_class
                  lc_footer
                  lv_bukrs_vf
                  lc_underscore
                  lc_tbt
                  INTO v_footer_tbt.
      CONDENSE v_footer_tbt NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
**    BOC by MODUTTA on 10/01/2018 for CR# TBD
***********Populate email
** BOC by SRBOSE on 31-Jan-2018 for CR_TBD
    IF v_kvgr1 EQ v_psb.
      DATA(lv_email_body) = lc_email_agency.
    ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
      lv_email_body = lc_email.
    ENDIF. " IF v_kvgr1 EQ v_psb
** EOC by SRBOSE on 31-Jan-2018 for CR_TBD

    CONCATENATE lc_txtname_part1
    lv_email_body
    lc_tbt
    INTO v_email_tbt.
    CONDENSE v_email_tbt NO-GAPS.
**    EOC by MODUTTA on 10/01/2018 for CR# TBD

***Society by Contract – If ZA partner function = AG(sold to party) partner function.
  ELSEIF lv_kunnr_sp = lv_kunnr_za.
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
    IF fp_st_vbap-mvgr5 IN r_mvgr5_scc.
      v_flag_cust = space.
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
**********Populate remit to
      CONCATENATE lc_txtname_part1
            lc_remit_to
            lv_bukrs_vf
            lc_underscore
            v_waerk
            lc_underscore
            lc_scc
       INTO v_remit_to_scc.
      CONDENSE v_remit_to_scc NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_remit_to_scc
                                                            BINARY SEARCH.
      IF sy-subrc NE 0
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
     OR st_address-land1 IN r_sanc_countries.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
        CLEAR : v_remit_to_scc.
        CONCATENATE lc_class
                    lc_remto
                    lc_xxx
                    INTO v_remit_to_scc.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**********Populate banking1
      CONCATENATE lc_txtname_part1
                  lc_banking1
                  lv_bukrs_vf
                  lc_underscore
                  v_waerk
                  lc_underscore
                  lc_scc
             INTO v_banking1_scc.
      CONDENSE v_banking1_scc NO-GAPS.

**********Populate banking2
      CONCATENATE lc_txtname_part1
              lc_banking2
              lv_bukrs_vf
              lc_underscore
              v_waerk
              lc_underscore
              lc_scc
         INTO v_banking2_scc.
      CONDENSE v_banking2_scc NO-GAPS.
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
      IF v_remit_to_scc CS lc_xxx
      OR st_address-land1 IN r_sanc_countries.
        CLEAR: v_banking1_scc,
               v_banking2_scc.
      ENDIF.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803

*********Populate customer service
      CONCATENATE lc_txtname_part1
          lc_cust
          lv_bukrs_vf
          lc_underscore
          v_waerk
          lc_underscore
          lc_scc
     INTO v_cust_serv_scc.
      CONDENSE v_cust_serv_scc NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_scc
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : v_cust_serv_scc.
        IF v_kvgr1 EQ v_psb.
          lv_credit_card1 = lc_tbt_agency1.
        ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
          lv_credit_card1 = lc_cust_serv.
        ENDIF. " IF v_kvgr1 EQ v_psb

        CONCATENATE lv_credit_card1
                    lv_bukrs_vf
                    lc_underscore
                    lc_scc
                    lc_underscore
                    lc_xxx
                    INTO v_cust_serv_scc.
        CONDENSE v_cust_serv_scc NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**********Populate footer
      CONCATENATE lc_txtname_part1
      lc_footer
      lv_bukrs_vf
      lc_underscore
      v_waerk
      lc_underscore
      lc_scc
  INTO v_footer_tbt.
      CONDENSE v_footer_tbt NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer_tbt
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : v_footer_tbt.
        CONCATENATE lc_class
                    lc_footer
                    lv_bukrs_vf
                    lc_underscore
                    lc_scc
                    INTO v_footer_tbt.
        CONDENSE v_footer_tbt NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**    BOC by MODUTTA on 10/01/2018 for CR# TBD
********Populate email
      CONCATENATE lc_txtname_part1
      lc_email
      lc_scc
      INTO v_email_scc.
      CONDENSE v_email_scc NO-GAPS.
**    EOC by MODUTTA on 10/01/2018 for CR# TBD
    ENDIF. " IF fp_st_vbap-mvgr5 IN r_mvgr5_scc
**Society by Member - If ZA partner function is not equal to AG(sold to party) partner function.
  ELSE. " ELSE -> IF fp_st_vbpa-parvw NE lc_za
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
    IF fp_st_vbap-mvgr5 IN r_mvgr5_scm.
      v_flag_cust = space.
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
**********Populate remit to
      CONCATENATE lc_txtname_part1
      lc_remit_to
      lv_bukrs_vf
      lc_underscore
      v_waerk
      lc_underscore
      lc_scm
  INTO v_remit_to_scm.
      CONDENSE v_remit_to_scm NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_remit_to_scm
                                                            BINARY SEARCH.
      IF sy-subrc NE 0
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
     OR st_address-land1 IN r_sanc_countries.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
        CLEAR : v_remit_to_scm.
        CONCATENATE lc_class
                    lc_remto
                    lc_xxx
                    INTO v_remit_to_scm.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

**********Populate banking1
      CONCATENATE lc_txtname_part1
                  lc_banking1
                  lv_bukrs_vf
                  lc_underscore
                  v_waerk
                  lc_underscore
                  lc_scm
             INTO v_banking1_scm.
      CONDENSE v_banking1_scm NO-GAPS.

**********Populate banking2
      CONCATENATE lc_txtname_part1
              lc_banking2
              lv_bukrs_vf
              lc_underscore
              v_waerk
              lc_underscore
              lc_scm
         INTO v_banking2_scm.
      CONDENSE v_banking2_scm NO-GAPS.
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
      IF v_remit_to_scm CS lc_xxx
      OR st_address-land1 IN r_sanc_countries.
        CLEAR: v_banking1_scm,
               v_banking2_scm.
      ENDIF.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803

***********Populate customer service
      CONCATENATE lc_txtname_part1
          lc_cust
          lv_bukrs_vf
          lc_underscore
          v_waerk
          lc_underscore
          lc_scm
     INTO v_cust_serv_scm.
      CONDENSE v_cust_serv_scm NO-GAPS.
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_scm
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : v_cust_serv_scm.
        IF v_kvgr1 EQ v_psb.
          lv_credit_card1 = lc_tbt_agency1.
        ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
          lv_credit_card1 = lc_cust_serv.
        ENDIF. " IF v_kvgr1 EQ v_psb

        CONCATENATE lv_credit_card1
                    lv_bukrs_vf
                    lc_underscore
                    lc_scm
                    lc_underscore
                    lc_xxx
                    INTO v_cust_serv_scm.
        CONDENSE v_cust_serv_scm NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
**    BOC by MODUTTA on 10/01/2018 for CR# TBD
**********Populate email
      CONCATENATE lc_txtname_part1
      lc_email
      lc_scm
  INTO v_email_scm.
      CONDENSE v_email_scm NO-GAPS.
**    EOC by MODUTTA on 10/01/2018 for CR# TBD
* End of change by APATNAIK: 30-June-2017: #TR:  ED2K906742
**********Populate footer
      CONCATENATE lc_txtname_part1
      lc_footer
      lv_bukrs_vf
      lc_underscore
      v_waerk
      lc_underscore
      lc_scm
  INTO v_footer_tbt.
      CONDENSE v_footer_tbt NO-GAPS.

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer_tbt
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : v_footer_tbt.
        CONCATENATE lc_class
                    lc_footer
                    lv_bukrs_vf
                    lc_underscore
                    lc_scm
                    INTO v_footer_tbt.
        CONDENSE v_footer_tbt NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

    ENDIF. " IF fp_st_vbap-mvgr5 IN r_mvgr5_scm
  ENDIF. " IF fp_st_vbpa-parvw NE lc_za
* Begin of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
******FM to change the date format to DD_MMM_YYYY
  CLEAR:lv_day,lv_month_c2,lv_year,lv_month,v_bill_date,v_text_body,
        lv_fkdat."ADD:RITM0093866:SGUDA:01-DECEMBER-2018:ED1K909062
*- Begin of ADD : ERP-7873:PRABHU:21-FEB-2019 : ED2K914491
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*  SORT li_constant_m BY devid param1 param2.
*  READ TABLE i_vbak INTO DATA(lst_vbak_tmp) WITH KEY vbeln = st_vbco3-vbeln
*                                                     auart = c_auart.
*  IF sy-subrc EQ 0.
*    READ TABLE li_constant_m INTO DATA(lv_constant) WITH KEY devid = c_devid
*                                                           param1 = c_renewal_year
*                                                           param2 = lst_vbak_tmp-bukrs_vf
*                                                    BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      lv_fkdat = sy-datum + lv_constant-low.
*    ELSE.
*      lv_fkdat = sy-datum + 20. "ADD:RITM0093866:SGUDA:01-DECEMBER-2018:ED1K909062
*    ENDIF.
*  ENDIF.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*--* Get Sales doc header data
  READ TABLE i_vbak INTO DATA(lst_vbak2) WITH KEY vbeln = st_vbco3-vbeln BINARY SEARCH.
*--*Check the conditions Document type and Po type
  IF sy-subrc EQ 0 AND lst_vbak2-auart IN r_auart AND lst_vbak2-bsark IN r_bsark.
*--*Check payment method
    READ TABLE li_vbkd INTO DATA(lst_vbkd2) WITH KEY vbeln = lst_vbak2-vbeln.
*                                                    posnr = '000000'
*                                                    BINARY SEARCH.
    IF sy-subrc EQ 0 AND lst_vbkd2-zlsch IN r_zlsch.
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*- Get Action at end of contract
      READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbak-vbeln
                                                vposn = c_0.
*- Get the Activity Date(EADAT) with reference to ACTIVITY as “CS”, Activity status(ACT_STATUS),
*   Renewal status(REN_STATUS),‘EXCL_RESN’ is space and ‘EXCL_RESN2’ should be blank.
      SELECT SINGLE * FROM zqtc_renwl_plan INTO lst_zqtc_renwl_plan
                                           WHERE vbeln = lst_vbak-vgbel
                                           AND   activity = c_cs.
*- Checking  Action at end of contract is 001 and with Renewal plan Table data
      IF sy-subrc EQ 0 AND lst_veda-vaktsch = c_001.
        v_date = lst_zqtc_renwl_plan-eadat.
        v_flag  = abap_true.
      ELSE.
*--*Check Company code and number of days
        v_date = sy-datum.
*      SORT li_constant_m BY devid param1 param2.
*      READ TABLE li_constant_m INTO DATA(lst_constant) WITH KEY devid = c_devid
*                                                          param1 = c_renewal_year
*                                                          param2 = lst_vbak2-bukrs_vf
*                                                          BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        lv_days = lst_constant-low.
*        CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
*          EXPORTING
*            im_date      = sy-datum
*            im_days      = lv_days
*          IMPORTING
*            ex_bill_date = lv_fkdat.
*      ENDIF.
      ENDIF.  "ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
      SORT li_constant_m BY devid param1 param2.
      READ TABLE li_constant_m INTO DATA(lst_constant) WITH KEY devid = c_devid
                                                          param1 = c_renewal_year
                                                          param2 = lst_vbak2-bukrs_vf
                                                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_days = lst_constant-low.
*SOC of ED2K923607 MRAJKUMAR changes
*        CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
*          EXPORTING
*            im_date      = v_date
*            im_days      = lv_days
*          IMPORTING
*            ex_bill_date = lv_fkdat.
        lv_fkdat = lst_vbkd2-fkdat.
*EOC of ED2K923607 MRAJKUMAR changes
      ENDIF.
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
    ENDIF.
  ENDIF.
  IF lv_fkdat  EQ '00000000'.
    lv_fkdat = sy-datum + 20.
  ENDIF.
*- End of ADD : ERP-7873:PRABHU:21-FEB-2019 : ED2K914491
  CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
    EXPORTING
      idate                         = lv_fkdat "st_vbkd-fkdat "ADD:RITM0093866:SGUDA:01-DECEMBER-2018:ED1K909062
    IMPORTING
      day                           = lv_day
      month                         = lv_month_c2
      year                          = lv_year
      ltext                         = lv_month
    EXCEPTIONS
      input_date_is_initial         = 1
      text_for_month_not_maintained = 2
      OTHERS                        = 3.
  IF sy-subrc = 0.
    lv_month_c3 = lv_month(3).

    CONCATENATE lv_day
                lv_month_c3
                lv_year
                INTO v_bill_date
                SEPARATED BY lc_hyphen.
  ENDIF. " IF sy-subrc = 0
  lv_name1 = lc_body.
  PERFORM f_get_text_body USING lv_name1
                      CHANGING v_text_body.
* End of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_print_output .

****Local data declaration
  DATA: li_output           TYPE ztqtc_output_supp_retrieval,
        lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Added by MODUTTA

****Local Constant declaration
*  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_ADVNC_NOTIFICATN'. " Name of Form Object
  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.
*--- Set language and default language
* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*  lst_sfpdocparams-langu     = nast-spras.
  lst_sfpdocparams-langu     = st_address-spras.
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441

  IF NOT v_ent_screen IS INITIAL.
* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*    lst_sfpoutputparams-noprint   = abap_true.
*    lst_sfpoutputparams-nopributt = abap_true.
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
    lst_sfpoutputparams-noarchive = abap_true.
    lst_sfpoutputparams-getpdf  = abap_false.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL

  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = nast-ldest.
  lst_sfpoutputparams-copies    = nast-anzal.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = nast-tdarmod.
  lst_sfpoutputparams-reqimm    = nast-dimme.
  lst_sfpoutputparams-reqdel    = nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*--- Set language and default language
*  lst_sfpdocparams-langu     = nast-spras.
  lst_sfpdocparams-langu     = st_address-spras.
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = syst-msgid
        msg_nr    = syst-msgno
        msg_ty    = syst-msgty
        msg_v1    = syst-msgv1
        msg_v2    = syst-msgv2
      EXCEPTIONS
        OTHERS    = 0.
    IF sy-subrc EQ 0.
      v_retcode = 900. RETURN.
    ENDIF. " IF sy-subrc EQ 0

  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.
        CLEAR lr_text.
      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CLEAR v_msg_txt.
          MESSAGE i086(zqtc_r2) WITH lr_text INTO v_msg_txt. " An exception occurred
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb = syst-msgid
              msg_nr    = syst-msgno
              msg_ty    = syst-msgty
              msg_v1    = syst-msgv1
              msg_v2    = syst-msgv2
            EXCEPTIONS
              OTHERS    = 0.
          IF sy-subrc EQ 0.
            v_retcode = 900. RETURN.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.


    CALL FUNCTION lv_funcname "'/1BCDWB/SM00000062'
      EXPORTING
        /1bcdwb/docparams  = lst_sfpdocparams
        im_xstring         = v_xstring
        im_vbco3           = st_vbco3
        im_society_logo    = v_society_logo
        im_vbap            = vbap
        im_final           = st_final
* BOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
        im_final_amt_tax   = i_final_amt_tax
* EOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
        im_address         = st_address
        im_drct_dbt_logo   = v_drct_dbt_logo
        im_society_name    = v_society_name
        im_flag_cust       = v_flag_cust
        im_footer          = v_footer
        im_cust_serv_scm   = v_cust_serv_scm
        im_cust_serv_scc   = v_cust_serv_scc
        im_cust_serv_tbt   = v_cust_serv_tbt
        im_barcode         = v_barcode
        im_v_seller_reg    = v_seller_reg
        im_compname        = v_compname
        im_remit_to_tbt    = v_remit_to_tbt
        im_remit_to_scc    = v_remit_to_scc
        im_remit_to_scm    = v_remit_to_scm
        im_banking1_scm    = v_banking1_scm
        im_banking1_scc    = v_banking1_scc
        im_banking1_tbt    = v_banking1_tbt
        im_banking2_scm    = v_banking2_scm
        im_banking2_scc    = v_banking2_scc
        im_banking2_tbt    = v_banking2_tbt
        im_footer_tbt      = v_footer_tbt
        im_footer_scc      = v_footer_scc
        im_footer_scm      = v_footer_scm
        im_arktx           = v_arktx
        im_subs_type       = v_subs_type
        im_email_tbt       = v_email_tbt
        im_email_scc       = v_email_scc
        im_email_scm       = v_email_scm
        im_society         = v_society
* Begin of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
        im_bill_date       = v_bill_date
        im_body            = v_text_body
* End of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
        im_arktx_desc      = i_arktx
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
      IMPORTING
        /1bcdwb/formoutput = st_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb = syst-msgid
          msg_nr    = syst-msgno
          msg_ty    = syst-msgty
          msg_v1    = syst-msgv1
          msg_v2    = syst-msgv2
        EXCEPTIONS
          OTHERS    = 0.
      IF sy-subrc EQ 0.
        v_retcode = 900. RETURN.
      ENDIF. " IF sy-subrc EQ 0

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb = syst-msgid
            msg_nr    = syst-msgno
            msg_ty    = syst-msgty
            msg_v1    = syst-msgv1
            msg_v2    = syst-msgv2
          EXCEPTIONS
            OTHERS    = 0.
        IF sy-subrc EQ 0.
          v_retcode = 900. RETURN.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc <> 0

      IF v_retcode = 0 AND v_ent_screen IS INITIAL.
*       Begin of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911700
        IF lst_sfpoutputparams-arcmode <> '1'.
          CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
            EXPORTING
              documentclass            = c_attachtyp_pdf "  class
              document                 = st_formoutput-pdf
            TABLES
              arc_i_tab                = lst_sfpdocparams-daratab
            EXCEPTIONS
              error_archiv             = 1
              error_communicationtable = 2
              error_connectiontable    = 3
              error_kernel             = 4
              error_parameter          = 5
              error_format             = 6
              OTHERS                   = 7.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                    RAISING system_error.
          ELSE. " ELSE -> IF sy-subrc <> 0
*           Check if the subroutine is called in update task.
            CALL METHOD cl_system_transaction_state=>get_in_update_task
              RECEIVING
                in_update_task = lv_upd_tsk.
*           COMMINT only if the subroutine is not called in update task
            IF lv_upd_tsk EQ 0.
              COMMIT WORK.
            ENDIF. " IF lv_upd_tsk EQ 0
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'
*       End   of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911700
********Perform is used to call E098 FM  & convert PDF in to Binary
        PERFORM f_call_fm_output_supp CHANGING li_output.

        PERFORM send_pdf_to_app_serv USING li_output.
      ENDIF. " IF v_retcode = 0 AND v_ent_screen IS INITIAL

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATES
*&---------------------------------------------------------------------*
*       To get the form date and date to be collected
*----------------------------------------------------------------------*

FORM f_get_dates  CHANGING fp_st_final TYPE zstqtc_final_f032. " Final structure for Advance Notification

*****Local data declaration

  DATA : lv_day           TYPE char2,    " Date of type CHAR2
         lv_days          TYPE char2,
         lv_month_c2      TYPE char2,    " Mnthc2 of type CHAR2
         lv_month_c3      TYPE char3,    " Mnthc3 of type CHAR3
         lv_month         TYPE t247-ltx, " Month long text
         lv_year          TYPE char5,    " Year of type CHAR5
         lv_datum_advnce  TYPE char15,   " Advance date of char 15
         lv_due_datum     TYPE angdt_v,  " variable of date type angdt_v
         lv_datum_pay_due TYPE char15.   " Pay due date of char15

******Local constant declaration

  CONSTANTS : lc_hyphen TYPE char01      VALUE '-'. "Constant for hyphen

******FM to change the date format to DD_MMM_YYYY
  CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
    EXPORTING
      idate                         = sy-datum
    IMPORTING
      day                           = lv_day
      month                         = lv_month_c2
      year                          = lv_year
      ltext                         = lv_month
    EXCEPTIONS
      input_date_is_initial         = 1
      text_for_month_not_maintained = 2
      OTHERS                        = 3.
  IF sy-subrc = 0.
    lv_month_c3 = lv_month(3).

    CONCATENATE lv_day
                lv_month_c3
                lv_year
                INTO lv_datum_advnce
                SEPARATED BY lc_hyphen.
  ENDIF. " IF sy-subrc = 0
*******Populate advance date
  fp_st_final-advnce_date = lv_datum_advnce.
*- Begin of ADD : ERP-7873:PRABHU:21-FEB-2019 : ED2K914491
******Calculation for Payment due by date
*  lv_due_datum = sy-datum + 20. ""ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
*  SORT li_constant_m BY devid param1 param2.
*  READ TABLE i_vbak INTO DATA(lst_vbak_tmp) WITH KEY vbeln = st_vbco3-vbeln
*                                                     auart = c_auart.
*  IF sy-subrc EQ 0.
*    READ TABLE li_constant_m INTO DATA(lv_constant) WITH KEY devid = c_devid
*                                                           param1 = c_renewal_year
*                                                           param2 = lst_vbak_tmp-bukrs_vf
*                                                    BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      lv_due_datum = sy-datum + lv_constant-low.
*    ELSE.
*      lv_due_datum = sy-datum + 20. "ADD:RITM0093866:SGUDA:01-DECEMBER-2018:ED1K909062
*    ENDIF.
*  ENDIF.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
  CLEAR : lv_due_datum.
*--* Get Sales doc header data
  READ TABLE i_vbak INTO DATA(lst_vbak) WITH KEY vbeln = st_vbco3-vbeln BINARY SEARCH.
*--*Check the conditions Document type and Po type
  IF sy-subrc EQ 0 AND lst_vbak-auart IN r_auart AND lst_vbak-bsark IN r_bsark.
*--*Check payment method
    READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbak-vbeln.
*                                                    posnr = '000000'
*                                                    BINARY SEARCH.
    IF sy-subrc EQ 0 AND lst_vbkd-zlsch IN r_zlsch.
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*- Get Action at end of contract
      READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_vbak-vbeln
                                                vposn = c_0.
*- Get the Activity Date(EADAT) with reference to ACTIVITY as “CS”, Activity status(ACT_STATUS),
*   Renewal status(REN_STATUS),‘EXCL_RESN’ is space and ‘EXCL_RESN2’ should be blank.
      SELECT SINGLE * FROM zqtc_renwl_plan INTO lst_zqtc_renwl_plan
                                           WHERE vbeln = lst_vbak-vgbel
                                           AND   activity = c_cs.
*- Checking  Action at end of contract is 001 and with Renewal plan Table data
      IF sy-subrc EQ 0 AND lst_veda-vaktsch = c_001.
        v_date = lst_zqtc_renwl_plan-eadat.
        v_flag = abap_true.
      ELSE.
        v_date = sy-datum.
      ENDIF.
*--*Check Company code and number of days
      SORT li_constant_m BY devid param1 param2.
      READ TABLE li_constant_m INTO lst_constat_m      WITH KEY devid = c_devid
                                                          param1 = c_renewal_year
                                                          param2 = lst_vbak-bukrs_vf
                                                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_days = lst_constat_m-low.
* SOC of ED2K923607 MRAJKUMAR changes
*        CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
*          EXPORTING
*            im_date      = v_date
*            im_days      = lv_days
*          IMPORTING
*            ex_bill_date = lv_due_datum.
        lv_due_datum = lst_vbkd-fkdat.
* EOC of ED2K923607 MRAJKUMAR changes
      ENDIF.
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
    ENDIF.
  ENDIF.

  IF lv_due_datum  EQ '00000000'.
    lv_due_datum = sy-datum + 20.
  ENDIF.
*- End of ADD : ERP-7873:PRABHU:21-FEB-2019 : ED2K914491
******FM to change the date format to DD_MMM_YYYY
  CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
    EXPORTING
      idate                         = lv_due_datum "ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
    IMPORTING
      day                           = lv_day
      month                         = lv_month_c2
      year                          = lv_year
      ltext                         = lv_month
    EXCEPTIONS
      input_date_is_initial         = 1
      text_for_month_not_maintained = 2
      OTHERS                        = 3.
  IF sy-subrc = 0.
    lv_month_c3 = lv_month(3).
    CONCATENATE lv_day
                lv_month_c3
                lv_year
                INTO lv_datum_pay_due
                SEPARATED BY lc_hyphen.

******Populate Payment due by date
    fp_st_final-pay_due_by = lv_datum_pay_due.

  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBFA
*&---------------------------------------------------------------------*
*        Populate corresponding data from VBFA Table
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3
*      -->FP_ST_VBAP
*      <--FP_ST_FINAL
*----------------------------------------------------------------------*
*FORM f_get_vbfa  USING    fp_st_vbco3 TYPE vbco3              " Sales Doc.Access Methods: Key Fields: Document Printing
*                          fp_st_vbap TYPE ty_vbap
*                 CHANGING fp_st_final TYPE zstqtc_final_f032. " Final structure for Renewal Notification
*
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DRCT_DBT_LOGO
*&---------------------------------------------------------------------*
*       to Polpulate Direct Debit Guarantee Logo
*----------------------------------------------------------------------*

FORM f_get_drct_dbt_logo CHANGING fp_v_drct_dbt_logo TYPE xstring.

*******Local constant declaration
  CONSTANTS : lc_logo_name    TYPE tdobname   VALUE 'ZJWILEY_LOGO_F032_EN4', " Name : English
              lc_logo_name_de TYPE tdobname   VALUE 'ZJWILEY_LOGO_F032_DE2', " Name : German
              lc_object       TYPE tdobjectgr VALUE 'GRAPHICS',              " SAPscript Graphics Management: Application object
              lc_id           TYPE tdidgr     VALUE 'BMAP',                  " SAPscript Graphics Management: ID
              lc_btype        TYPE tdbtype    VALUE 'BCOL',                  " Graphic type
              lc_e            TYPE na_spras   VALUE 'E'.                     " Message language

  IF v_langu = lc_e.
******To Get a BDS Graphic in BMP Format (Using a Cache)
    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = lc_object          " GRAPHICS
        p_name         = lc_logo_name       " ZJWILEY_LOGO_F032_EN3
        p_id           = lc_id              " BMAP
        p_btype        = lc_btype           " BCOL
      RECEIVING
        p_bmp          = fp_v_drct_dbt_logo " Image Data
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.

  ELSE. " ELSE -> IF v_langu = lc_e
******To Get a BDS Graphic in BMP Format (Using a Cache)
    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = lc_object          " GRAPHICS
        p_name         = lc_logo_name_de    " ZJWILEY_LOGO_F032_EN3
        p_id           = lc_id              " BMAP
        p_btype        = lc_btype           " BCOL
      RECEIVING
        p_bmp          = fp_v_drct_dbt_logo " Image Data
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
  ENDIF. " IF v_langu = lc_e
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_MAIL
*&---------------------------------------------------------------------*
*       Perform is used to send mail with an attachment of PDF
*----------------------------------------------------------------------*

FORM f_adobe_print_mail .

  CONSTANTS: lc_i      TYPE bapi_mtype     VALUE 'I'. "Message type: S Success, E Error, W Warning, I Info, A Abort

* ****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        li_output           TYPE ztqtc_output_supp_retrieval,
        lv_upd_tsk          TYPE i.                           "Added by MODUTTA

********Get email id from ADR6 table
* To Validate if the email is maintained in the Ship to address or not.
  SELECT smtp_addr "E-Mail Address
    FROM adr6      "E-Mail Addresses (Business Address Services)
    INTO v_email_shipto
    UP TO 1 ROWS
    WHERE addrnumber EQ st_address-adrnr_sh.
  ENDSELECT.
  IF sy-subrc NE 0.
    v_retcode = 900. RETURN.
    IF v_ent_screen IS INITIAL.
* Email Address is not maintained for Ship to Customer.
      MESSAGE i243(zqtc_r2). " Email ID is not maintained for Ship to Customer
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = syst-msgid
          msg_nr                 = syst-msgno
          msg_ty                 = c_msgtyp_err
          msg_v1                 = syst-msgv1
          msg_v2                 = syst-msgv2
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.
    ELSE. " ELSE -> IF v_ent_screen IS INITIAL
      MESSAGE text-005 TYPE  lc_i . "'I'.
    ENDIF. " IF v_ent_screen IS INITIAL
  ENDIF. " IF sy-subrc NE 0

  IF v_retcode = 0.
    lv_form_name = tnapr-sform.
    lst_sfpoutputparams-getpdf = abap_true.
    lst_sfpoutputparams-preview = abap_false.

**********BOC by MODUTTA on 20/07/2017 for archive****************************
    IF NOT v_ent_screen IS INITIAL.
* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*      lst_sfpoutputparams-noprint   = abap_true."Comment by MODUTTA on 11-May-18 for INC0194261
      lst_sfpoutputparams-nopributt = abap_true.
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
      lst_sfpoutputparams-noarchive = abap_true.
    ENDIF. " IF NOT v_ent_screen IS INITIAL
    IF v_ent_screen     = abap_true.
      lst_sfpoutputparams-getpdf  = abap_false.
      lst_sfpoutputparams-preview = abap_true.
    ELSEIF v_ent_screen = c_screen_webdyn. " 'W'. "Web dynpro
      lst_sfpoutputparams-getpdf  = abap_true.
    ENDIF. " IF v_ent_screen = abap_true
    lst_sfpoutputparams-nodialog  = abap_true.
    lst_sfpoutputparams-dest      = nast-ldest.
    lst_sfpoutputparams-copies    = nast-anzal.
    lst_sfpoutputparams-dataset   = nast-dsnam.
    lst_sfpoutputparams-suffix1   = nast-dsuf1.
    lst_sfpoutputparams-suffix2   = nast-dsuf2.
    lst_sfpoutputparams-cover     = nast-tdocover.
    lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
    lst_sfpoutputparams-authority = nast-tdautority.
    lst_sfpoutputparams-receiver  = nast-tdreceiver.
    lst_sfpoutputparams-division  = nast-tddivision.
    lst_sfpoutputparams-arcmode   = nast-tdarmod.
    lst_sfpoutputparams-reqimm    = nast-dimme.
    lst_sfpoutputparams-reqdel    = nast-delet.
    lst_sfpoutputparams-senddate  = nast-vsdat.
    lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*  lst_sfpdocparams-langu     = nast-spras.
    lst_sfpdocparams-langu     = st_address-spras.
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441

* Archiving
    APPEND toa_dara TO lst_sfpdocparams-daratab.
**********EOC by MODUTTA on 20/07/2017 for archive****************************

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_sfpoutputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb = syst-msgid
          msg_nr    = syst-msgno
          msg_ty    = syst-msgty
          msg_v1    = syst-msgv1
          msg_v2    = syst-msgv2
        EXCEPTIONS
          OTHERS    = 0.
      IF sy-subrc EQ 0.
        v_retcode = 900. RETURN.
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_form_name "lc_form_name
            IMPORTING
              e_funcname = lv_funcname.
          CLEAR lr_text.
        CATCH cx_fp_api_usage INTO lr_err_usg.
          lr_text = lr_err_usg->get_text( ).
        CATCH cx_fp_api_repository INTO lr_err_rep.
          lr_text = lr_err_rep->get_text( ).
        CATCH cx_fp_api_internal INTO lr_err_int.
          lr_text = lr_err_int->get_text( ).
          IF lr_text IS NOT INITIAL.
            CLEAR v_msg_txt.
            MESSAGE i086(zqtc_r2) WITH lr_text INTO v_msg_txt. " An exception occurred
            CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
              EXPORTING
                msg_arbgb              = syst-msgid
                msg_nr                 = syst-msgno
                msg_ty                 = syst-msgty
                msg_v1                 = syst-msgv1
                msg_v2                 = syst-msgv2
              EXCEPTIONS
                message_type_not_valid = 1
                no_sy_message          = 2
                OTHERS                 = 3.
            IF sy-subrc EQ 0.
              v_retcode = 900. RETURN.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lr_text IS NOT INITIAL
      ENDTRY.

      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000062'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_xstring         = v_xstring
          im_vbco3           = st_vbco3
          im_society_logo    = v_society_logo
          im_vbap            = vbap
          im_final           = st_final
* BOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
          im_final_amt_tax   = i_final_amt_tax
* EOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
          im_address         = st_address
          im_drct_dbt_logo   = v_drct_dbt_logo
          im_society_name    = v_society_name
          im_flag_cust       = v_flag_cust
          im_footer          = v_footer
          im_cust_serv_scm   = v_cust_serv_scm
          im_cust_serv_scc   = v_cust_serv_scc
          im_cust_serv_tbt   = v_cust_serv_tbt
          im_barcode         = v_barcode
          im_v_seller_reg    = v_seller_reg
          im_compname        = v_compname
          im_remit_to_tbt    = v_remit_to_tbt
          im_remit_to_scc    = v_remit_to_scc
          im_remit_to_scm    = v_remit_to_scm
          im_banking1_scm    = v_banking1_scm
          im_banking1_scc    = v_banking1_scc
          im_banking1_tbt    = v_banking1_tbt
          im_banking2_scm    = v_banking2_scm
          im_banking2_scc    = v_banking2_scc
          im_banking2_tbt    = v_banking2_tbt
          im_footer_tbt      = v_footer_tbt
          im_footer_scc      = v_footer_scc
          im_footer_scm      = v_footer_scm
          im_arktx           = v_arktx
          im_subs_type       = v_subs_type
          im_email_tbt       = v_email_tbt
          im_email_scc       = v_email_scc
          im_email_scm       = v_email_scm
          im_society         = v_society
* Begin of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
          im_bill_date       = v_bill_date
          im_body            = v_text_body
* End of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
          im_arktx_desc      = i_arktx
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = syst-msgid
            msg_nr                 = syst-msgno
            msg_ty                 = syst-msgty
            msg_v1                 = syst-msgv1
            msg_v2                 = syst-msgv2
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc EQ 0.
          v_retcode = 900. RETURN.
        ENDIF. " IF sy-subrc EQ 0

      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = syst-msgid
              msg_nr                 = syst-msgno
              msg_ty                 = syst-msgty
              msg_v1                 = syst-msgv1
              msg_v2                 = syst-msgv2
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc EQ 0.
            v_retcode = 900. RETURN.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0

    IF v_retcode = 0 AND v_ent_screen IS INITIAL.
**********BOC by MODUTTA on 20/07/2017 for archive****************************
*  post form processing
*     Begin of DEL:ERP-7340:WROY:30-Mar-2018:ED2K911700
*     IF lst_sfpoutputparams-arcmode <> '1' AND
*       nast-nacha NE '1' AND           "Print output
*       v_comm_method NE c_comm_method. "Letter
*     End   of DEL:ERP-7340:WROY:30-Mar-2018:ED2K911700
*     Begin of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911700
      IF lst_sfpoutputparams-arcmode <> '1'.
*     End   of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911700

        CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
          EXPORTING
            documentclass            = c_attachtyp_pdf "  class
            document                 = st_formoutput-pdf
          TABLES
            arc_i_tab                = lst_sfpdocparams-daratab
          EXCEPTIONS
            error_archiv             = 1
            error_communicationtable = 2
            error_connectiontable    = 3
            error_kernel             = 4
            error_parameter          = 5
            error_format             = 6
            OTHERS                   = 7.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                  RAISING system_error.
        ELSE. " ELSE -> IF sy-subrc <> 0
*         Check if the subroutine is called in update task.
          CALL METHOD cl_system_transaction_state=>get_in_update_task
            RECEIVING
              in_update_task = lv_upd_tsk.
*         COMMINT only if the subroutine is not called in update task
          IF lv_upd_tsk EQ 0.
            COMMIT WORK.
          ENDIF. " IF lv_upd_tsk EQ 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'
**********EOC by MODUTTA on 20/07/2017 for archive****************************

********Perform is used to call E098 FM  & convert PDF in to Binary
      PERFORM f_call_fm_output_supp CHANGING li_output.

********Perform is used to create mail attachment with a creation of mail body
      PERFORM f_mail_attachment USING li_output.
    ENDIF. " IF v_retcode = 0 AND v_ent_screen IS INITIAL
  ENDIF. " IF v_retcode = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*       Perform is used to convert PDF into Binary
*----------------------------------------------------------------------*

FORM f_call_fm_output_supp CHANGING fp_li_output TYPE ztqtc_output_supp_retrieval.
*  Local data declaration
  DATA: lst_output TYPE zstqtc_output_supp_retrieval, " Output structure for E098-Output Supplement Retrieval
        li_input   TYPE ztqtc_supplement_ret_input,
        lst_input  TYPE zstqtc_supplement_ret_input.  " Input Paramter for E098 Supplement retrieval

*** BOC BY SAYANDAS
  TYPES : BEGIN OF lty_constant,
            sign TYPE	tvarv_sign,	                                                                                                                              "ABAP: ID: I/E (include/exclude values)
            opti TYPE	tvarv_opti,	                                                                                                                              "ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE  salv_de_selopt_low, "Lower Value of Selection Condition
            high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          END OF lty_constant.

  DATA : li_constant TYPE STANDARD TABLE OF lty_constant.

  CONSTANTS: lc_devid TYPE zdevid         VALUE 'E098',  " Development ID
             lc_kschl TYPE rvari_vnam     VALUE 'KSCHL'. " ABAP: Name of Variant Variable
*** EOC BY SAYANDAS

* Populate material and customer group
  lst_input-product_no = st_vbap-matnr.
  lst_input-cust_grp = st_vbkd-kdkg2.
  APPEND lst_input TO li_input. "Material

  READ TABLE i_vbak INTO DATA(lst_vbak) WITH KEY vbeln = st_vbap-vbeln BINARY SEARCH.
  IF sy-subrc EQ 0.
    DATA(lv_auart) = lst_vbak-auart.
  ENDIF. " IF sy-subrc EQ 0

*** BOC BY SAYANDAS
*** Fetch data from ZCACONSTANT
  SELECT sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_constant
    WHERE devid EQ lc_devid
    AND param1 EQ lc_kschl.
  IF sy-subrc IS INITIAL.
    SORT li_constant BY low.
  ENDIF. " IF sy-subrc IS INITIAL

  IF nast-kschl IN li_constant.
*** EOC BY SAYANDAS
*Call FM to get the list of PDF attachments for the particular material
*and attachment name ending with KDKG1
    CALL FUNCTION 'ZQTC_OUTPUT_SUPP_RETRIEVAL'
      EXPORTING
        im_input  = li_input
        im_auart  = lv_auart
      IMPORTING
        ex_output = fp_li_output.
*** BOC BY SAYANDAS
  ENDIF. " IF nast-kschl IN li_constant
*** EOC BY SAYANDAS
  CLEAR lst_output.
  lst_output-attachment_name = 'Advance Notification'(003).
  lst_output-pdf_stream = st_formoutput-pdf.
* APPEND lst_output TO fp_li_output.
  INSERT lst_output INTO fp_li_output INDEX 1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       Perform is used for mail sending with an attachemnt
*----------------------------------------------------------------------*

FORM f_mail_attachment USING fp_li_output TYPE ztqtc_output_supp_retrieval.

******Local Constant Declaration
  DATA: lr_sender      TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
*        lv_send        TYPE adr6-smtp_addr,                        "variable to store email id
        li_lines       TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines      TYPE tline,                   " SAPscript: Text Lines
        li_email_data  TYPE solix_tab,
        lv_document_no TYPE saeobjid.                " SAP ArchiveLink: Object ID (object identifier)


********Local Constant Declaration
  CONSTANTS: lc_raw    TYPE so_obj_tp      VALUE 'RAW',  "Code for document class
             lc_pdf    TYPE so_obj_tp      VALUE 'PDF',  "Document Class for Attachment
             lc_i      TYPE bapi_mtype     VALUE 'I',    "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_s      TYPE bapi_mtype     VALUE 'S',    "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_st     TYPE thead-tdid     VALUE 'ST',   "Text ID of text to be read
             lc_object TYPE thead-tdobject VALUE 'TEXT', "Object of text to be read
*             lc_name   TYPE thead-tdname   VALUE 'ZQTC_EMAIL_BODY_F032'. "Name of text to be read
             lc_name   TYPE thead-tdname   VALUE 'ZQTC_EMAIL_F032'. " Name


  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service

  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions

  TRY .
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lv_flag           TYPE xfeld,                                    " Checkbox
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i.                                        " Upd_tsk of type Integers

********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
* BOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
*     language                = nast-spras "lc_langu
      language                = st_address-spras
* EOC by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
      name                    = lc_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lst_message_body-line = lst_lines-tdline.
      lst_message_body-line = lst_lines-tdline.
      lst_message_body-line = lst_lines-tdline.
      lst_message_body-line = lst_lines-tdline.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0

*  Populate email body
  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw "'RAW'
      i_text = li_message_body
      i_subject = 'Advance Notification'(003) ).
    CATCH cx_document_bcs.
    CATCH cx_send_req_bcs.
  ENDTRY.

********Get email id from ADR6 table
*  SELECT smtp_addr "E-Mail Address
*    FROM adr6      "E-Mail Addresses (Business Address Services)
*    INTO lv_send
*    UP TO 1 ROWS
*    WHERE addrnumber EQ st_address-adrnr_sh.
*  ENDSELECT.
*  IF sy-subrc NE 0.
*    MESSAGE text-005 TYPE  lc_i . "'I'.
*  ENDIF. " IF sy-subrc NE 0
*****************
  IF fp_li_output IS NOT INITIAL.
    LOOP AT fp_li_output INTO DATA(lst_output).
      lv_flag = abap_true.
      IF lst_output-attachment_name =  text-003.
        CLEAR lv_flag.
      ENDIF. " IF lst_output-attachment_name = text-003
*    For passing in document number
      lv_document_no = st_vbap-vbeln.
      CALL FUNCTION 'ZQTC_OUTPUT_SUPP_SAVE_OR_SEND'
        EXPORTING
*         IM_SAVE_FILE       =
          im_send_email      = abap_true
          im_doc_number      = lv_document_no
          im_pdf_stream      = lst_output-pdf_stream
          im_attachment_name = lst_output-attachment_name
          im_order           = abap_true
          im_attach_doc      = lv_flag
        IMPORTING
          ex_email_data      = li_email_data
        EXCEPTIONS
          file_not_found     = 1
          OTHERS             = 2.
      IF sy-subrc <> 0.
        RAISE file_not_found.
      ENDIF. " IF sy-subrc <> 0

*      IF li_email_data IS NOT INITIAL AND lv_send IS NOT INITIAL.
      IF li_email_data IS NOT INITIAL AND v_email_shipto IS NOT INITIAL.
*        Send email with the attachments we are getting from FM
        TRY.
            lr_document->add_attachment(
            EXPORTING
            i_attachment_type = lc_pdf "'PDF'
            i_attachment_subject = lst_output-attachment_name+0(50)
            i_att_content_hex = li_email_data ).
          CATCH cx_document_bcs INTO lx_document_bcs.
*Exception handling not required
        ENDTRY.

* Add attachment
        TRY.
            CALL METHOD lr_send_request->set_document( lr_document ).
          CATCH cx_send_req_bcs.
*Exception handling not required
        ENDTRY.
        CLEAR: lst_output,li_email_data.
      ENDIF. " IF li_email_data IS NOT INITIAL AND v_email_shipto IS NOT INITIAL
    ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
  ENDIF. " IF fp_li_output IS NOT INITIAL
  IF v_email_shipto IS NOT INITIAL.
* Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).

* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.

* Create recipient
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_email_shipto ).
** Set recipient
        lr_send_request->add_recipient(
        EXPORTING
        i_recipient = lr_recipient
        i_express = abap_true ).
      CATCH cx_address_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.

* Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
* Begin of change by ANISAHA
* Removed this commit work as this was giving dump during update task
*        COMMIT WORK.
* End of change by ANISAHA

*BOC by MODUTTA if the process in not commited in update tas then use COMMIT WORK
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
*EOC by MODUTTA
        MESSAGE text-004 TYPE lc_s . "'I'.
      CATCH cx_send_req_bcs.
    ENDTRY.
  ENDIF. " IF v_email_shipto IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL
*&---------------------------------------------------------------------*
*       Sub-routine to clear all global variables,work area and tables
*----------------------------------------------------------------------*
FORM f_clear_global.

  CLEAR : v_tot,
          v_langu,
          v_waerk,
          v_country,
          v_xstring,
          v_retcode,
          v_society_logo,
          v_drct_dbt_logo,
          v_flag_cust,
          v_society,
          v_society_name,
          v_footer,
          v_compname,
*          v_ent_screen,
          v_seller_reg,
          v_barcode,
          st_vbap,
          st_vbpa,
          st_vbkd,
          st_vbco3,
          i_vbpa,
          i_vbak,
          i_tax_data,
*          i_tax_dtls,
*** BOC BY SAYANDAS
          i_arktx,
          i_vbap,
          v_idcodetype_1,
          v_idcodetype_2,
*** EOC BY SAYANDAS
          st_final,
          st_address,
          st_formoutput,
* BOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
          r_mvgr5_scc,
          r_mvgr5_scm,
          i_final_amt_tax,
* EOI by PBANDLAPAL on 23-Jan-2018 for CR#743: ED2K910441
          v_email_shipto,
          v_footer_tbt,
          v_footer_scc,
          v_footer_scm,
          v_remit_to_tbt,
          v_remit_to_scc,
          v_remit_to_scm,
          v_banking1_tbt,
          v_banking1_scc,
          v_banking1_scm,
          v_banking2_tbt,
          v_banking2_scc,
          v_banking2_scm,
          v_cust_serv_tbt,
          v_cust_serv_scc,
          v_cust_serv_scm,
          v_arktx,
          v_subs_type,
          v_email_tbt,
          v_email_scc,
          v_email_scm,
          r_mat_grp5,   " ADD:CR#7730 KKRAVURI20181024
          r_output_typ. " ADD:CR#7730 KKRAVURI20181024

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BARCODE
*&---------------------------------------------------------------------*
*       Populating the bar code at the bottom part of form
*----------------------------------------------------------------------*

FORM f_populate_barcode .

  DATA: lv_amount   TYPE char11, " Amount of type CHAR11
*        lv_invoice  TYPE char10, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
        lv_invoice  TYPE char16, " Invoice of type CHAR16 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
        lv_inv_chk  TYPE char1,  " Inv_chk of type CHAR1
        lv_amnt_chk TYPE char1,  " Amnt_chk of type CHAR1
*        lv_bar      TYPE char30, " Bar of type CHAR30 ""ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
        lv_bar      TYPE char100, " Bar of type CHAR100 ""ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
        lv_bar_chk  TYPE char1.  " Bar_chk of type CHAR1

* Invoice Number
  MOVE st_vbco3-vbeln TO lv_invoice.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_invoice
    IMPORTING
      output = lv_invoice.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_invoice
*    IMPORTING
*      check_digit = lv_inv_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_invoice
    IMPORTING
      check_digit = lv_inv_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237 :TR# ED2K907387
  IF v_tot GT 0.
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237 :TR# ED2K907387
* Amount
    WRITE v_tot TO lv_amount CURRENCY v_waerk.
    REPLACE ALL OCCURRENCES OF '.' IN lv_amount WITH space.
    REPLACE ALL OCCURRENCES OF ',' IN lv_amount WITH space.
    CONDENSE lv_amount.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_amount
      IMPORTING
        output = lv_amount.

*  MOVE st_calc-total_due TO lv_amount.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_amount
*      IMPORTING
*        check_digit = lv_amnt_chk.
    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_amount
      IMPORTING
        check_digit = lv_amnt_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
    CONCATENATE lv_invoice
                lv_inv_chk
                lv_amount
                lv_amnt_chk
                INTO lv_bar.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_bar
*      IMPORTING
*        check_digit = lv_bar_chk.
    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_bar
      IMPORTING
        check_digit = lv_bar_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913739
    CONCATENATE lv_invoice
                lv_inv_chk
                lv_amount
                lv_amnt_chk
                lv_bar_chk
                INTO v_barcode
                SEPARATED BY space.
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: TR# ED2K907387
* If total value is negative then we are raising a message
  ELSE. " ELSE -> IF v_tot GT 0
    CLEAR v_msg_txt.
    MESSAGE i239(zqtc_r2) INTO v_msg_txt. "Total Amount can't be negative
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = syst-msgid
        msg_nr    = syst-msgno
        msg_ty    = syst-msgty
        msg_v1    = syst-msgv1
        msg_v2    = syst-msgv2
      EXCEPTIONS
        OTHERS    = 0.
    IF sy-subrc EQ 0.
      v_retcode = 900. RETURN.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_tot GT 0
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237 :TR# ED2K907387
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SELLER_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBAP  text
*      <--P_V_SELLER_REG  text
*----------------------------------------------------------------------*
FORM f_get_seller_tax  USING    fp_st_vbap TYPE ty_vbap
                       CHANGING p_v_seller_reg TYPE tdline. " Seller VAT Registration Number

*Local data declaration
  DATA: lv_doc_line  TYPE /idt/doc_line_number, " Document Line Number
        lv_buyer_reg TYPE char255.              " Buyer_reg of type CHAR255
* Local constant declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBAK',
*** BOC BY SAYANDAS
             lc_undscr   TYPE char1      VALUE '_',          " Undscr of type CHAR1
             lc_vat      TYPE char3      VALUE 'VAT',        " Vat of type CHAR3
             lc_tax      TYPE char3      VALUE 'TAX',        " Tax of type CHAR3
             lc_gst      TYPE char3      VALUE 'GST',        " Gst of type CHAR3
             lc_class    TYPE char5      VALUE 'ZQTC_',      " Class of type CHAR5
             lc_devid    TYPE char5      VALUE '_F024',      " Devid of type CHAR5
             lc_st       TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
             lc_object   TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_colon    TYPE char1      VALUE ':',          " Colon of type CHAR1
             lc_comma    TYPE char1      VALUE ',',   "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_1001     TYPE bukrs_vf   VALUE '1001'. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745


  DATA: li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
        lv_text   TYPE string,
        lv_tax    TYPE thead-tdname,            " Name
        lv_ind    TYPE xegld,                   " Indicator: European Union Member?
        lvv_index TYPE sy-index.             " Index Value "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745

  lv_doc_line = st_vbap-posnr+2(4).

  READ TABLE i_vbak INTO DATA(lst_vbak) WITH KEY vbeln = st_vbco3-vbeln
                                          BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    DATA(lv_vbeln) = lst_vbak-vbeln.
    DATA(lv_bukrs) = lst_vbak-bukrs_vf.
  ENDIF. " IF sy-subrc IS INITIAL

  SELECT document,
          doc_line_number,
          buyer_reg,
          seller_reg      " Seller VAT Registration Number
     FROM /idt/d_tax_data " Tax Data
    INTO TABLE @i_tax_data
    WHERE company_code = @lv_bukrs
    AND fiscal_year = @lc_gjahr
    AND document_type = @lc_doc_type
    AND document = @lv_vbeln.
  IF sy-subrc IS INITIAL.
    SORT i_tax_data BY seller_reg.
    DELETE ADJACENT DUPLICATES FROM i_tax_data COMPARING seller_reg.
    DELETE i_tax_data WHERE seller_reg = space. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    LOOP AT i_tax_data INTO DATA(lst_tax_data).
      IF lst_tax_data-seller_reg IS NOT INITIAL.
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        lvv_index = sy-tabix.
        IF lvv_index = 1.
          v_seller_reg = lst_tax_data-seller_reg.
        ELSE.
          CONCATENATE lst_tax_data-seller_reg lc_comma v_seller_reg INTO v_seller_reg.
        ENDIF.
*        CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      ENDIF. " IF lst_tax_data-seller_reg IS NOT INITIAL
    ENDLOOP. " LOOP AT i_tax_data INTO DATA(lst_tax_data)
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    CLEAR lst_vbak.
    READ TABLE i_vbak INTO lst_vbak INDEX 1.
    IF v_seller_reg IS INITIAL AND lst_vbak-bukrs_vf = lc_1001.
      v_seller_reg = r_tax_id.
    ENDIF.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
* Begin of Comment by PBANDLAPAL on 20-Sep-2017 TR ED2K908563
*    IF v_seller_reg IS NOT INITIAL.
*      CONCATENATE lv_text v_seller_reg INTO v_seller_reg SEPARATED BY lc_colon.
*    ENDIF. " IF v_seller_reg IS NOT INITIAL
* End of Comment by PBANDLAPAL on 20-Sep-2017 TR ED2K908563
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
* Begin of change: PBANDLAPAL: 24-OCT-2017: ED2K909045
*&---------------------------------------------------------------------*
*&      Form  F_GET_KONV_DATA
*&---------------------------------------------------------------------*
*       This perform is used to calculate total, taxable and surcharges
*----------------------------------------------------------------------*
*      -->FP_VBCO3
*----------------------------------------------------------------------*
FORM f_get_konv_data . " USING fp_st_vbap TYPE ty_vbap.


******Local Data declaration
  DATA: lst_konv       TYPE ty_konv,                                  "Local workarea for konv structure
        lst_konv_tmp   TYPE ty_konv,                                  "Local workarea for konv structure
        lst_vbak       TYPE ty_vbak,                                  "Local workarea for vbak structure
        lv_kwert       TYPE kwert,                                    " Condition value
        lv_kbetr       TYPE kbetr,                                    " Rate (condition amount or percentage)
        lv_kwert_tax   TYPE kwert,                                    " Condition value
        lv_kbetr_tax   TYPE kbetr,                                    " Rate (condition amount or percentage)
        lv_kwert_total TYPE kwert,                                    " Condition value
        lv_total_char  TYPE char20,                                   " Total_char of type CHAR20
        lv_tax_amt     TYPE char15,                                   " Tax_amt of type CHAR15
        li_konv        TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0, "Local interna table
        li_konv_tmp    TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0, "Local interna table
        li_konv_temp   TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0. "Local interna table


*******Local constant declaration
  CONSTANTS: lc_a          TYPE koaid VALUE 'A',  " Condition class
             lc_koaid_d    TYPE koaid VALUE 'D',  " Condition class
             lc_kappl_tx   TYPE kappl VALUE 'TX', " Condition Application Tax
             lc_char_blank TYPE kinak VALUE '',   " Condition is inactive
             lc_percentage TYPE char1 VALUE '%'.  " Percentage of type CHAR1


******Table i_vbak is already sorted
  CLEAR:        lst_vbak.
  READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = st_vbco3-vbeln
                                  BINARY SEARCH.
  IF sy-subrc IS INITIAL.
*******Fetch DATA from KONV table:Conditions (Transaction Data)
    SELECT knumv "Number of the document condition
           kposn "Condition item number
           stunr "Step number
           zaehk "Condition counter
           kappl " Application
           kawrt "Condition base value
           kbetr "Rate (condition amount or percentage)
           kwert "Condition value
           kinak "Condition is inactive
           koaid "Condition class
      FROM konv  "Conditions (Transaction Data)
      INTO TABLE i_konv
      WHERE knumv = lst_vbak-knumv
        AND kinak = lc_char_blank.
*      AND   kposn = fp_st_vbap-posnr.
    IF sy-subrc IS INITIAL.
      SORT i_konv BY kposn.
*     DELETE i_konv WHERE koaid NE lc_koaid_d OR kappl NE lc_kappl_tx.
      DELETE i_konv WHERE koaid NE lc_koaid_d.
*     Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
*     DELETE i_konv WHERE kbetr IS INITIAL.
*     End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      DELETE i_konv WHERE kawrt IS INITIAL.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_MATDESC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBAP_MATNR  text
*      <--P_LST_FINAL_PROD_DES  text
*----------------------------------------------------------------------*
FORM read_text_matdesc  USING    fp_matnr
                        CHANGING fp_prod_des.
  DATA: lv_text      TYPE string,
        li_lines     TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_text_name TYPE tdobname.                " Name

  lv_text_name  = fp_matnr.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_txtid_grun
      language                = st_address-spras
      name                    = lv_text_name
      object                  = c_txtobj_material
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    DELETE li_lines WHERE tdline IS INITIAL.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_prod_des = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_MODULE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_RENEWAL_NOTICE_TM  text
*      <--P_LV_TXTMODULE_DATA  text
*----------------------------------------------------------------------*
FORM read_text_module  USING    fp_txtmod_name  TYPE tdsfname " Smart Forms: Form Name
                       CHANGING fp_txtmodule_data_c   TYPE string.
  DATA:
    lst_language_tm TYPE ssfrlang,                " Smart Forms: Languages at Runtime
    lst_lines       TYPE tline,                   " SAPscript: Text Lines
    li_lines        TYPE STANDARD TABLE OF tline. " SAPscript: Text Lines.

  lst_language_tm-langu1  = st_address-spras.

  CALL FUNCTION 'SSFRT_READ_TEXTMODULE'
    EXPORTING
      i_textmodule       = fp_txtmod_name
      i_languages        = lst_language_tm
    IMPORTING
*     O_LANGU            =
      o_text             = li_lines
    EXCEPTIONS
      error              = 1
      language_not_found = 2
      OTHERS             = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE. " ELSE -> IF sy-subrc <> 0
    READ TABLE li_lines INTO lst_lines INDEX 1.
    IF sy-subrc EQ 0.
      fp_txtmodule_data_c = lst_lines-tdline.
      CONDENSE fp_txtmodule_data_c.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALCULATE_AND_BUILD_TAXDTLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBAP  text
*----------------------------------------------------------------------*
FORM calculate_and_build_taxdtls   USING fp_lst_vbap      TYPE ty_vbap.

  DATA: lst_mara      TYPE ty_mara,
        lst_konv      TYPE ty_konv,
        lst_tax_dtls  TYPE ty_tax_dtls,
        lv_konv_index TYPE syst_tabix,   " ABAP System Field: Row Index of Internal Tables
        lv_kbetr_desc TYPE p DECIMALS 3. " Rate (condition amount or percentage).

* BOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
*  READ TABLE i_konv INTO lst_konv WITH KEY kposn = fp_lst_vbap-posnr.
*  IF sy-subrc IS INITIAL.
*    lv_konv_index = sy-tabix.
*    CLEAR lv_kbetr_desc.
*    LOOP AT i_konv INTO lst_konv FROM lv_konv_index WHERE kposn = fp_lst_vbap-posnr.
*      lv_kbetr_desc = lv_kbetr_desc + lst_konv-kbetr .
*    ENDLOOP. " LOOP AT i_konv INTO lst_konv FROM lv_konv_index WHERE kposn = fp_lst_vbap-posnr
*  ENDIF. " IF sy-subrc IS INITIAL
*
*  IF lv_kbetr_desc IS NOT INITIAL.
*    lv_kbetr_desc = ( lv_kbetr_desc / 10 ).
*  ENDIF. " IF lv_kbetr_desc IS NOT INITIAL
*  READ TABLE i_mara INTO lst_mara WITH KEY matnr = fp_lst_vbap-matnr.
*  IF sy-subrc EQ 0.
*    lst_tax_dtls-ismmediatype = lst_mara-ismmediatype.
*    IF lv_kbetr_desc IS INITIAL.
*      lst_tax_dtls-kbetr        = c_initial_prc.
*    ELSE. " ELSE -> IF lv_kbetr_desc IS INITIAL
*      lst_tax_dtls-kbetr        = lv_kbetr_desc.
*    ENDIF. " IF lv_kbetr_desc IS INITIAL
*    IF fp_lst_vbap-kzwi6 IS INITIAL.
*      lst_tax_dtls-kzwi6        = c_initial_amt.
*    ELSE. " ELSE -> IF fp_lst_vbap-kzwi6 IS INITIAL
*      lst_tax_dtls-kzwi6        = fp_lst_vbap-kzwi6.
*    ENDIF. " IF fp_lst_vbap-kzwi6 IS INITIAL
*    COLLECT lst_tax_dtls INTO i_tax_dtls.
*  ENDIF. " IF sy-subrc EQ 0
* EOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_PDF_TO_APP_SERV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_OUTPUT  text
*----------------------------------------------------------------------*
FORM send_pdf_to_app_serv  USING    fp_li_output    TYPE ztqtc_output_supp_retrieval.

  CONSTANTS: lc_sl             TYPE char2   VALUE 'SL',  " Rn of type CHAR2
             lc_sap            TYPE char3   VALUE 'SAP', " Sap of type CHAR3
*            Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
             lc_bus_prcs_renwl TYPE zbus_prcocess VALUE 'R',  " Business Process - Renewal
             lc_prnt_vend_qi   TYPE zprint_vendor VALUE 'Q',  " Third Party System (Print Vendor) - QuickIssue
             lc_prnt_vend_bt   TYPE zprint_vendor VALUE 'B',  " Third Party System (Print Vendor) - BillTrust
             lc_parvw_re       TYPE parvw         VALUE 'RE', " Partner Function: Bill-To Party
*            End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'. " Communication Method (Key) (Business Address Services)

  DATA: lv_flag         TYPE char1, " Flag of type CHAR1
*        lv_send         TYPE ad_smtpadr,                              " Variable to store email id
        lst_vbak        TYPE ty_vbak,
        lv_string       TYPE string,
        lv_waerk        TYPE waerk, " SD Document Currency
*       Begin of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911700
        lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
*       End   of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911700
        lv_bukrs        TYPE bukrs,     " Company Code
        lv_count        TYPE numc4,     " Count of type Integers
        lv_sl_count     TYPE numc4,     " Count of type Integers
        lv_iden         TYPE char10,    " Id of type CHAR6
        lv_acnt_num     TYPE char10,    " Account number to remove leading zeros
        lv_file_name    TYPE localfile, " Local file for upload/download
*       Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
        lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region, " Print Region
        lv_country_sort TYPE zcountry_sort, " Country Sorting Key
        lv_file_loc     TYPE file_no,       " Application Server File Path
*       End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
        ls_pdf_file     TYPE fpformoutput,                            " Form Output (PDF, PDL)
        lv_date         TYPE syst_datum,                              " ABAP System Field: Current Date of Application Server
        lv_amount       TYPE char24,                                  " Amount of type CHAR24
        li_email_data   TYPE solix_tab,
        lv_deflt_comm   TYPE ad_comm,                                 " Communication Method (Key) (Business Address Services)
        lv_document_no  TYPE  saeobjid,                               " SAP ArchiveLink: Object ID (object identifier)
        lr_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL, " Wrapper Class for Office Documents
        lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions

*****************
  IF fp_li_output IS NOT INITIAL.
* SOC by NPOLINA ED1K908772  Bill to Def com method
*     Get  Bill-to Party Address number
    READ TABLE i_vbpa INTO DATA(lst_vbpabp)
         WITH TABLE KEY parvw COMPONENTS vbeln = st_vbco3-vbeln
                                         parvw = lc_parvw_re.
    IF sy-subrc EQ 0.
* Fetch details from Addresses (Business Address Services)
      SELECT deflt_comm    "Communication Method (Key) (Business Address Services)
        FROM adrc          " Addresses (Business Address Services)
        INTO lv_deflt_comm "Businees address
       UP TO 1 ROWS
*     WHERE addrnumber = st_address-adrnr_sh. "NPOLINA ED1K908772
        WHERE addrnumber = lst_vbpabp-adrnr.    "NPOLINA ED1K908772
      ENDSELECT.
      IF sy-subrc IS INITIAL.
*   do nonthing
      ENDIF. " IF sy-subrc IS INITIAL
* EOC by NPOLINA ED1K908772  Bill to Def com method
    ENDIF.
*   Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
    IF lv_deflt_comm EQ lc_deflt_comm_let.
*     Identify Bill-to Party Details
      READ TABLE i_vbpa INTO DATA(lst_vbpa)
           WITH TABLE KEY parvw COMPONENTS vbeln = st_vbco3-vbeln
                                           parvw = lc_parvw_re.
      IF sy-subrc NE 0.
        CLEAR: lst_vbpa.
      ENDIF. " IF sy-subrc NE 0

      CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
        EXPORTING
          im_bus_prcocess     = lc_bus_prcs_renwl "Business Process (Renewal)
          im_country          = lst_vbpa-land1    "Bill-to Party Country
          im_output_type      = nast-kschl        "Output Type
        IMPORTING
          ex_print_vendor     = lv_print_vendor   "Third Party System (Print Vendor)
          ex_print_region     = lv_print_region   "Print Region
          ex_country_sort     = lv_country_sort   "Country Sorting Key
          ex_file_loc         = lv_file_loc       "Application Server File Path
        EXCEPTIONS
          exc_invalid_bus_prc = 1
          exc_no_entry_found  = 2
          OTHERS              = 3.
      IF sy-subrc NE 0.
        CLEAR: lv_print_vendor.
      ENDIF. " IF sy-subrc NE 0

*     Trigger different logic based on Third Party System (Print Vendor)
      CASE lv_print_vendor.
        WHEN lc_prnt_vend_qi. "Third Party System (Print Vendor) - QuickIssue
          CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
            EXPORTING
              im_outputs           = fp_li_output      "PDF Contents
              im_bus_prcocess      = lc_bus_prcs_renwl "Business Process (Renewal)
              im_print_region      = lv_print_region   "Print Region
              im_country_sort      = lv_country_sort   "Country Sorting Key
              im_file_loc          = lv_file_loc       "Application Server File Path
              im_country           = lst_vbpa-land1    "Bill-to Party Country
              im_customer          = lst_vbpa-kunnr    "Bill-to Party Customer
              im_doc_number        = st_vbco3-vbeln    "SD Document Number
              im_ref_contract      = st_vbco3-vbeln    "SD Document Number (For Renewal Profile Determination)
            EXCEPTIONS
              exc_missing_dir_path = 1
              exc_err_opening_file = 2
              OTHERS               = 3.
          IF sy-subrc NE 0.
*           Update Processing Log
            CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
              EXPORTING
                msg_arbgb = syst-msgid
                msg_nr    = syst-msgno
                msg_ty    = syst-msgty
                msg_v1    = syst-msgv1
                msg_v2    = syst-msgv2
              EXCEPTIONS
                OTHERS    = 0.
            IF sy-subrc EQ 0.
              v_retcode = 900. RETURN.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc NE 0

        WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
*   End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
          LOOP AT fp_li_output INTO DATA(lst_output).
*           Begin of DEL:I0231:WROY:01-Mar-2018:ED2K911145
*           IF lv_deflt_comm EQ lc_deflt_comm_let.
*           End   of DEL:I0231:WROY:01-Mar-2018:ED2K911145
*           Begin of DEL:ERP-7332:WROY:30-Mar-2018:ED2K911700
*           MOVE st_final-tot_amt TO lv_amount.
*           CONDENSE lv_amount.
*           End   of DEL:ERP-7332:WROY:30-Mar-2018:ED2K911700

            lv_count = lv_count + 1.
            READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = st_vbco3-vbeln
                                                        BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              lv_waerk    = lst_vbak-waerk.
              lv_bukrs    = lst_vbak-bukrs_vf.
              lv_date     = lst_vbak-angdt.
            ENDIF. " IF sy-subrc IS INITIAL
*           Begin of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911700
            lv_bapi_amount = v_tot.
*           Converts a currency amount from SAP format to External format
            CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
              EXPORTING
                currency    = lv_waerk        " Currency
                sap_amount  = lv_bapi_amount  " SAP format
              IMPORTING
                bapi_amount = lv_bapi_amount. " External format
            MOVE lv_bapi_amount TO lv_amount.
            CONDENSE lv_amount.
*           End   of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911700

            IF lv_count <> 1.
              lv_sl_count = lv_sl_count + 1.
              CONCATENATE lc_sl
                          lv_sl_count
                      INTO lv_iden.
            ELSE. " ELSE -> IF lv_count <> 1
              lv_iden = lc_sap.
            ENDIF. " IF lv_count <> 1

*       ls_pdf_file-pdf = st_formoutput-pdf.
            ls_pdf_file-pdf = lst_output-pdf_stream.

            CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
              EXPORTING
                im_fpformoutput    = ls_pdf_file
*Begin of change NPALLA for INC0201178 on 09-Jul-2018 ED1K907933
*               im_customer        = st_vbco3-kunde  "-ED1K907933
                im_customer        = lst_vbpa-kunnr   "+ED1K907933
*End of change NPALLA for INC0201178 on 03-Jul-2018 ED1K907933
                im_invoice         = st_vbco3-vbeln
                im_amount          = lv_amount
                im_currency        = lv_waerk
                im_date            = lv_date
                im_form_identifier = lv_iden
                im_ccode           = lv_bukrs
*               Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
                im_file_loc        = lv_file_loc
*               End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
              IMPORTING
                ex_file_name       = lv_file_name.
            IF lv_file_name IS NOT INITIAL.

            ENDIF. " IF lv_file_name IS NOT INITIAL
*           Begin of DEL:I0231:WROY:01-Mar-2018:ED2K911145
*           ENDIF. " IF lv_deflt_comm EQ lc_deflt_comm_let
*           End   of DEL:I0231:WROY:01-Mar-2018:ED2K911145
          ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
*   Begin of ADD:I0231:WROY:01-Mar-2018:ED2K911145
        WHEN OTHERS.
*         Nothing to Do
      ENDCASE.
    ENDIF. " IF lv_deflt_comm EQ lc_deflt_comm_let
*   End   of ADD:I0231:WROY:01-Mar-2018:ED2K911145
  ENDIF. " IF fp_li_output IS NOT INITIAL
ENDFORM.
* End of change: PBANDLAPAL: 24-OCT-2017: ED2K909045
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constant .

**Local Constants declaration:
  CONSTANTS: lc_devid        TYPE zdevid VALUE 'F032',      " Development ID
             lc_kvgr1        TYPE rvari_vnam VALUE 'KVGR1', " ABAP: Name of Variant Variable
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
             lc_idcodetype_1 TYPE rvari_vnam VALUE 'IDCODETYPE_1', " ABAP: Name of Variant Variable
             lc_idcodetype_2 TYPE rvari_vnam VALUE 'IDCODETYPE_2', " ABAP: Name of Variant Variable
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
             lc_sanctioned_c TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
             lc_mvgr5_scc    TYPE rvari_vnam VALUE 'MVGR5_SCC', " ABAP: Name of Variant Variable
             lc_mvgr5_scm    TYPE rvari_vnam VALUE 'MVGR5_SCM', " ABAP: Name of Variant Variable
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
* BOC: CR#7730 KKRAVURI20181024  ED2K913666
             lc_mat_grp5     TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
             lc_output_typ   TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
* EOC: CR#7730 KKRAVURI20181024  ED2K913666
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_tax_id       TYPE rvari_vnam VALUE 'TAX_ID',
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
             lc_process_time TYPE rvari_vnam VALUE 'PROCESS_TIME',
             lc_disp_time    TYPE rvari_vnam VALUE 'VSZTP',
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
             lc_debit        TYPE rvari_vnam  VALUE 'DEBIT',                 "Constant for DEBIT
             lc_zlsch        TYPE rvari_vnam  VALUE 'ZLSCH',                 "Constant for payment method
             lc_auart        TYPE rvari_vnam  VALUE 'AUART',                 "Constnat for Doc type
             lc_bsark        TYPE rvari_vnam  VALUE 'BSARK',                 "Constnat for PO type
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
             lc_print        TYPE rvari_vnam  VALUE 'PRINT_MEDIA_PRODUCT',
             lc_digital      TYPE rvari_vnam  VALUE 'DIGITAL_MEDIA_PRODUCT'.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
* Fetch values from constant table
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/...)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @DATA(li_constant)
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @lc_devid
      AND activate EQ @abap_true.

  IF sy-subrc IS INITIAL.
    li_constant_m[] = li_constant[].
    SORT li_constant BY devid param1.
* BOC by PBANDLAPAL on 23-Jan-2018: ED2K910441
*    READ TABLE li_constant INTO DATA(lst_constant) WITH KEY param1 = lc_kvgr1
*                                                   BINARY SEARCH.
*    IF sy-subrc IS INITIAL.
*      v_kvgr1 = lst_constant-low.
*    ENDIF.
    LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
      CASE <lst_constant>-param1.
        WHEN lc_kvgr1.
          v_kvgr1 = <lst_constant>-low.
        WHEN lc_mvgr5_scc.
          APPEND INITIAL LINE TO r_mvgr5_scc ASSIGNING FIELD-SYMBOL(<lst_mvgr5_scc>).
          <lst_mvgr5_scc>-sign   = <lst_constant>-sign.
          <lst_mvgr5_scc>-option = <lst_constant>-opti.
          <lst_mvgr5_scc>-low    = <lst_constant>-low.
          <lst_mvgr5_scc>-high    = <lst_constant>-high.
        WHEN lc_mvgr5_scm.
          APPEND INITIAL LINE TO r_mvgr5_scm ASSIGNING FIELD-SYMBOL(<lst_mvgr5_scm>).
          <lst_mvgr5_scm>-sign   = <lst_constant>-sign.
          <lst_mvgr5_scm>-option = <lst_constant>-opti.
          <lst_mvgr5_scm>-low    = <lst_constant>-low.
          <lst_mvgr5_scm>-high    = <lst_constant>-high.
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
        WHEN lc_idcodetype_1.
          v_idcodetype_1 = <lst_constant>-low.
        WHEN lc_idcodetype_2.
          v_idcodetype_2 = <lst_constant>-low.
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
        WHEN lc_sanctioned_c.
          APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
          <lst_sanc_country>-sign   = <lst_constant>-sign.
          <lst_sanc_country>-option = <lst_constant>-opti.
          <lst_sanc_country>-low    = <lst_constant>-low.
          <lst_sanc_country>-high   = <lst_constant>-high.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
* BOC: CR#7730 KKRAVURI20181024  ED2K913666
        WHEN lc_mat_grp5.
          APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
          <lst_mat_grp5>-sign   = <lst_constant>-sign.
          <lst_mat_grp5>-option = <lst_constant>-opti.
          <lst_mat_grp5>-low    = <lst_constant>-low.
          <lst_mat_grp5>-high   = <lst_constant>-high.
        WHEN lc_output_typ.
          APPEND INITIAL LINE TO r_output_typ ASSIGNING FIELD-SYMBOL(<lst_output_typ>).
          <lst_output_typ>-sign   = <lst_constant>-sign.
          <lst_output_typ>-option = <lst_constant>-opti.
          <lst_output_typ>-low    = <lst_constant>-low.
          <lst_output_typ>-high   = <lst_constant>-high.
* EOC: CR#7730 KKRAVURI20181024  ED2K913666
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        WHEN lc_tax_id.
          r_tax_id = <lst_constant>-low.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
        WHEN lc_auart.
          CASE <lst_constant>-param2.
            WHEN lc_debit.
              APPEND INITIAL LINE TO r_auart ASSIGNING FIELD-SYMBOL(<lfs_auart>).
              <lfs_auart>-sign   = <lst_constant>-sign.
              <lfs_auart>-option = <lst_constant>-opti.
              <lfs_auart>-low    = <lst_constant>-low.
              <lfs_auart>-high   = <lst_constant>-high.
            WHEN OTHERS.
          ENDCASE.
        WHEN lc_zlsch.
          CASE <lst_constant>-param2.
            WHEN lc_debit.
              APPEND INITIAL LINE TO r_zlsch ASSIGNING FIELD-SYMBOL(<lfs_zlsch>).
              <lfs_zlsch>-sign   = <lst_constant>-sign.
              <lfs_zlsch>-option = <lst_constant>-opti.
              <lfs_zlsch>-low    = <lst_constant>-low.
              <lfs_zlsch>-high   = <lst_constant>-high.
            WHEN OTHERS.
          ENDCASE.
        WHEN lc_bsark.
          CASE <lst_constant>-param2.
            WHEN lc_debit.
              APPEND INITIAL LINE TO r_bsark ASSIGNING FIELD-SYMBOL(<lfs_bsark>).
              <lfs_bsark>-sign   = <lst_constant>-sign.
              <lfs_bsark>-option = <lst_constant>-opti.
              <lfs_bsark>-low    = <lst_constant>-low.
              <lfs_bsark>-high   = <lst_constant>-high.
            WHEN OTHERS.
          ENDCASE.
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
        WHEN lc_process_time.
          v_process_time = <lst_constant>-low.
          CONDENSE v_process_time.
        WHEN lc_disp_time.
          v_disp_time = <lst_constant>-low.
          CONDENSE v_disp_time.
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
        WHEN  lc_print.
          APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lfs_print_product>).
          <lfs_print_product>-sign   = <lst_constant>-sign.
          <lfs_print_product>-option = <lst_constant>-opti.
          <lfs_print_product>-low    = <lst_constant>-low.
          <lfs_print_product>-high   = <lst_constant>-high.
        WHEN lc_digital.
          APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lfs_digital_product>).
          <lfs_digital_product>-sign   = <lst_constant>-sign.
          <lfs_digital_product>-option = <lst_constant>-opti.
          <lfs_digital_product>-low    = <lst_constant>-low.
          <lfs_digital_product>-high   = <lst_constant>-high.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
        WHEN OTHERS.
*       Do nothing.
      ENDCASE.
    ENDLOOP. " LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)
* EOC by PBANDLAPAL on 23-Jan-2018: ED2K910441
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
* BOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
*&---------------------------------------------------------------------*
*&      Form  BUILD_AND_POPUL_AMT_TAX_DTLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_and_popul_amt_tax_dtls.

  DATA: lst_konv          TYPE ty_konv,
        lv_netwr_c        TYPE char25,              " Netwr_c of type CHAR25
        lv_kbetr_c        TYPE char25,              " Kbetr_c of type CHAR25
        lv_tax_amt_c      TYPE char25,              " Tax_amt_c of type CHAR25
        li_tax_dtls       TYPE TABLE OF ty_tax_dtls,
        lst_tax_dtls      TYPE ty_tax_dtls,
        lv_kbetr_desc     TYPE p DECIMALS 3,        " Rate (condition amount or percentage).
        lst_tax_dtls_tmp  TYPE ty_tax_dtls,
        lst_final_amt_tax TYPE zstqtc_amt_tax_f032, " Final Amount and Tax Details
        lv_txtmodule_data TYPE string.

* Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
* LOOP AT i_konv INTO lst_konv.
*   lv_kbetr_desc = lst_konv-kbetr.
* End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
* Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
  LOOP AT i_konv INTO DATA(lst_konv_tmp).
    lst_konv = lst_konv_tmp.
*   Check to identify if the Line is already "Rejected"
    READ TABLE i_vbap INTO DATA(lst_vbap_tmp1)
         WITH KEY posnr = lst_konv-kposn
         BINARY SEARCH.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF. " IF sy-subrc NE 0
    lv_kbetr_desc = lv_kbetr_desc + lst_konv-kbetr.
    lst_tax_dtls-kwert = lst_tax_dtls-kwert + lst_konv-kwert.

    AT END OF kposn.
* End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      IF lv_kbetr_desc IS NOT INITIAL.
        lst_tax_dtls-kbetr = ( lv_kbetr_desc / 10 ).
      ELSE. " ELSE -> IF lv_kbetr_desc IS NOT INITIAL
        lst_tax_dtls-kbetr = c_initial_prc.
      ENDIF. " IF lv_kbetr_desc IS NOT INITIAL
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      READ TABLE i_mara INTO DATA(lst_mara)
           WITH KEY matnr = lst_vbap_tmp1-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_tax_dtls-ismmediatype = lst_mara-ismmediatype.
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265

      READ TABLE li_tax_dtls ASSIGNING FIELD-SYMBOL(<lfs_tax_dtls>)
                                      WITH KEY kbetr = lst_tax_dtls-kbetr
*                                              Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
                                               ismmediatype = lst_tax_dtls-ismmediatype.
*                                              End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      IF sy-subrc EQ 0.
        <lfs_tax_dtls>-netwr = <lfs_tax_dtls>-netwr + lst_konv-kawrt.
*       Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
        <lfs_tax_dtls>-kwert = <lfs_tax_dtls>-kwert + lst_tax_dtls-kwert.
*       End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
*       Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
*       <lfs_tax_dtls>-kwert = <lfs_tax_dtls>-kwert + lst_konv-kwert.
*       End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
      ELSE. " ELSE -> IF sy-subrc EQ 0
        lst_tax_dtls-netwr = lst_konv-kawrt.
*       Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
****BOC BY SAYANDAS  FOR ERP-6660
*       IF lst_tax_dtls-netwr IS INITIAL.
*         READ TABLE i_vbap INTO DATA(lst_vbap_tmp1) WITH KEY vbeln = st_vbco3-vbeln
*                                                             posnr = lst_konv-kposn.
*         IF sy-subrc = 0.
*           lst_tax_dtls-netwr = lst_vbap_tmp1-netwr.
*         ENDIF. " IF sy-subrc = 0
*       ENDIF. " IF lst_tax_dtls-netwr IS INITIAL
****EOC BY SAYANDAS FOR ERP-6660
*       lst_tax_dtls-kwert = lst_konv-kwert.
*       End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911265
        APPEND lst_tax_dtls TO li_tax_dtls.
      ENDIF. " IF sy-subrc EQ 0
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
      CLEAR: lst_tax_dtls, lv_kbetr_desc.
    ENDAT.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
  ENDLOOP. " LOOP AT i_konv INTO DATA(lst_konv_tmp)

* To Populate the final table related to taxes and total Amounts.

* To Populate the Sub Total Text .
  CLEAR lv_txtmodule_data.
  PERFORM read_text_module USING c_sub_total_tm
                           CHANGING lv_txtmodule_data.
  lst_final_amt_tax-zzdesc = lv_txtmodule_data.
  lst_final_amt_tax-amount = st_final-net_amt.
  lst_final_amt_tax-waerk  = st_final-currency.
  APPEND lst_final_amt_tax TO i_final_amt_tax.

* To Populate the Tax Value.
  CLEAR: lst_final_amt_tax,
         lv_txtmodule_data.
  PERFORM read_text_module USING c_tax_tm
                           CHANGING lv_txtmodule_data.

  LOOP AT li_tax_dtls INTO lst_tax_dtls.

    CONCATENATE lv_txtmodule_data c_semicoln_char
                                  INTO lst_final_amt_tax-zzdesc.

    lst_final_amt_tax-waerk  = st_final-currency.
    WRITE lst_tax_dtls-netwr TO lv_netwr_c CURRENCY st_final-currency.
    CONDENSE lv_netwr_c.

    WRITE lst_tax_dtls-kbetr TO lv_kbetr_c.
    CONDENSE lv_kbetr_c.

    CONCATENATE lv_netwr_c c_char_attherate lv_kbetr_c c_char_perc c_char_equal
                INTO lst_final_amt_tax-zztax_dtls.
    CONDENSE lst_final_amt_tax-zztax_dtls.

    WRITE lst_tax_dtls-kwert TO lst_final_amt_tax-amount CURRENCY st_final-currency.
    CONDENSE lst_final_amt_tax-amount.

    APPEND lst_final_amt_tax TO i_final_amt_tax.
    CLEAR lst_final_amt_tax.
  ENDLOOP. " LOOP AT li_tax_dtls INTO lst_tax_dtls


* To Populate the Total Amount Text .
  CLEAR: lst_final_amt_tax,
         lv_txtmodule_data.
  PERFORM read_text_module USING c_total_amt_tm
                           CHANGING lv_txtmodule_data.

  lst_final_amt_tax-zzdesc = lv_txtmodule_data.
  lst_final_amt_tax-amount = st_final-tot_amt.
  lst_final_amt_tax-waerk  = st_final-currency.
  APPEND lst_final_amt_tax TO i_final_amt_tax.

ENDFORM.
* EOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
*&---------------------------------------------------------------------*
*&      Form  F_GET_SUBSCRPTION_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_NAME  text
*      <--P_LV_SUBSCRIPTION_TYP  text
*----------------------------------------------------------------------*
FORM f_get_subscrption_type  USING    fp_lv_name TYPE thead-tdname
                             CHANGING fp_v_subscription_typ TYPE char100. " V_subscription_typ of type CHAR100

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.

  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_v_subscription_typ = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT_VAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_NAME_ISSN  text
*      <--P_LV_PNT_ISSN  text
*----------------------------------------------------------------------*
FORM f_get_text_val  USING    fp_lv_name  TYPE thead-tdname " Name
                     CHANGING fp_lv_value TYPE char30.      " Lv_value of type CHAR30


  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_lv_value = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LANGU  text
*      <--P_I_STD_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_stxh_data  USING    fp_v_langu TYPE spras " Language Key
                      CHANGING fp_i_std_text TYPE tt_std_text.

*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char10,   " Low of type CHAR2
           high   TYPE char10,   " High of type CHAR2
         END OF lty_range.

***Local Variable Declaration
  DATA: lst_range TYPE lty_range,
        lir_range TYPE STANDARD TABLE OF lty_range.

***Local constant declaration
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F032*', " R of type CHAR10
             lc_sign   TYPE ddsign         VALUE 'I',          " Type of SIGN component in row type of a Ranges type
             lc_option TYPE ddoption       VALUE 'CP'.         " Type of OPTION component in row type of a Ranges type

***Populate local range table
  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_r.
  APPEND lst_range TO lir_range.

*** Fetch data from STXH table
  SELECT
  tdname      " Name
    FROM stxh " STXD SAPscript text file lines
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st
    AND tdspras = v_langu.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT_BODY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_NAME1  text
*      <--P_V_TEXT_BODY  text
*----------------------------------------------------------------------*
FORM f_get_text_body  USING    p_lv_name1
                      CHANGING p_v_text_body TYPE string.
  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Data declaration
  DATA : li_lines   TYPE STANDARD TABLE OF tline, "Lines of text read
         li_lines_d TYPE STANDARD TABLE OF tline, "Lines of text read
         st_lines   TYPE tline,
         lv_text    TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = p_lv_name1
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO st_lines.
      REPLACE ALL OCCURRENCES OF '&V_BILL_DATE&' IN st_lines-tdline WITH v_bill_date.
      APPEND st_lines TO li_lines_d.
      CLEAR st_lines.
    ENDLOOP.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines_d
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      p_v_text_body = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
