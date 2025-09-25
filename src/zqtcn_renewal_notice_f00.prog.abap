*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_RENEWAL_NOTICE_F00
* REPORT DESCRIPTION:    Include for subroutine
* DEVELOPER:             Srabanti Bose (SRBOSE)
* CREATION DATE:         11-Jan-2017
* OBJECT ID:             F035
* TRANSPORT NUMBER(S):   ED2K904080
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904800
* REFERENCE NO:  ED2K905714
* DEVELOPER: Monalisa Dutta
* DATE:  04/24/2017
* DESCRIPTION: Addition of E098 FM to send multiple attachment in an email
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907419
* REFERENCE NO:
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2016-07-21
* DESCRIPTION:
* BOC by LKODWANI on 21-Jul-2016 TR#ED2K907419
* EOC by LKODWANI on 21-Jul-2016 TR#ED2K907419
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K907387
* REFERENCE NO: ERP-5131
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-11-29
* DESCRIPTION:
* Use Cust Cond Grp 2 in stead of Cust Cond Grp 1
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907387
* REFERENCE NO: ERP-5237
* DEVELOPER: Pavan Bandlapalli (PBANDLAPAL)
* DATE:  2017-11-29
* DESCRIPTION: Populated an error message when the total amount is negative
*              and processing the output type in error.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K910360
* REFERENCE NO: ERP-5914
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  01/18/2018
* DESCRIPTION: In the email some of the texts are overlapping when viewed
*              through mobile and to fix the same I have adjusted the code.
*----------------------------------------------------------------------*
* REVISION NO: ED2K910514
* REFERENCE NO: ERP-6118
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  01/25/2018
* DESCRIPTION: For Multi Journal BOM tax percentage is doubling. To correct
*              the same I have adjusted the code. Initial requirement was
*              supposed to be only for COMBO product but not for multi journal.
*----------------------------------------------------------------------*
* REVISION NO: ED2K911241
* REFERENCE NO: CR#744
* DEVELOPER: Soumi Mondal
* DATE:  03/08/2018
* DESCRIPTION: Addition of Journal code to text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7332
* REFERENCE NO: ED2K911708
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         30-Mar-2018
* DESCRIPTION:  Billtrust Amount (SAP format --> External format)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7340
* REFERENCE NO: ED2K911708
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         30-Mar-2018
* DESCRIPTION:  Implement Archiving logic
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-6302
* REFERENCE NO: ED2K912457
* DEVELOPER:    Sayantan Das (SAYANDAS)
* DATE:         28-JUN-2018
* DESCRIPTION:  Implement Direct Debit Mandate Logic (for F044)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-6307
* REFERENCE NO: ED2K912477
* DEVELOPER:    Sayantan Das (SAYANDAS)
* DATE:         05-JULY-2018
* DESCRIPTION:  Cosmetic Chnages
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907907
* REFERENCE NO: RITM0040136 (F035 and F037)
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         06-Jul-2018
* DESCRIPTION:  Clear global Int Tables, so that information of one
*               Quote do not not flow to another one
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
* REVISION NO:  ED2K913181
* REFERENCE NO: ERP-6458
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         20-Aug-2018
* DESCRIPTION:  Pass Society information for retrieving Supplement Docs
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913576
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913745
* REFERENCE NO: ERP-7189 and 7431
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  11/05/2018
* DESCRIPTION: Need to replace MOD10 function module with MOD11
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909899
* REFERENCE NO: INC0236404
* DEVELOPER:    Rajasekhar.T (RBTIRUMALA)
* DATE:         29/03/2019
* DESCRIPTION:  To Check the condition if the Total Amount gerater than
*               or equal to 0 insted of the condition greater than
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909899
* REFERENCE NO: INC0236404
* DEVELOPER:    Rajasekhar.T (RBTIRUMALA)
* DATE:         29/03/2019
* DESCRIPTION:  To Change message Email ID is not maintained for Bill to party(556)
*               Message Class ZQTC_R2
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR- 7841
* REFERENCE NO: ED1K910099
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         30-Apr-2019
* DESCRIPTION:  Replace the 'Year' in item section with 'Contract start date'
*               and 'Contract End Date'.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO  :  ERPM-8994
* REFERENCE NO :  ED2K917342
* DEVELOPER    :  Lahiru Wathudura (LWATHUDURA)
* DATE         :  01/22/2020
* DESCRIPTION  :  Add Buyer and Seller tax Numbers
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-2232
* REFERENCE NO: ED2K918755
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/29/2020
* DESCRIPTION:  Reflect Fright forwarder on billing documents where Ship-to currently resides.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-24393
* REFERENCE NO: ED2K919423
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/09/2020
* DESCRIPTION:  DD Mandate Enhancement for VCH Renewals and Firm Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913787
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40086
* REFERENCE NO: ED2K924584
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         09/15/2021
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
*&  Include           ZQTCN_RENEWAL_NOTIF_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING
*&---------------------------------------------------------------------*
*     This perform is used for all data process where all the
*     performs has been processed
*----------------------------------------------------------------------*
FORM f_processing.

*******Local Constant Declaration
  CONSTANTS: lc_01 TYPE na_nacha VALUE '1', " Message transmission medium
             lc_05 TYPE na_nacha VALUE '5'. "Message transmission medium

*  Clear all global variables
  PERFORM f_clear_global.

* Perform to populate Wiley Logo
  PERFORM f_get_wiley_logo     CHANGING  v_xstring.

* Perform to populate sales data from NAST table
  PERFORM f_get_data           USING     nast
                               CHANGING  st_vbco3.


* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
  PERFORM f_get_constants  CHANGING i_constant.
* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241


*  Perform to populate customer language and customer country
  PERFORM f_get_language       USING     st_vbco3
                               CHANGING  st_address.

  SET COUNTRY st_address-land1_we.

*  Perform to fetch data from VBAP table
  PERFORM f_get_vbap_data      USING     st_vbco3
                               CHANGING  st_vbap.
* Perform to populate address data
  PERFORM f_get_add_data       USING     st_vbco3
                               CHANGING  st_address.

* Perform to fetch data from VBFA table
  PERFORM f_get_vbfa           USING     st_vbco3
                                         st_vbap
                               CHANGING  st_final.

* Perform to fetch data from KONV table for calculation
  PERFORM f_get_konv_data.

*************BOC by SRBOSE on 08/08/2017 for CR# 408****************
************* Begin of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 *************
  PERFORM f_get_seller_tax USING st_vbap
                           CHANGING v_seller_reg
                                    v_buyer_reg.      " Buyer VAT registration number
************* End of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 *************
*************EOC by SRBOSE on 08/08/2017 for CR# 408****************

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
  PERFORM f_get_stxh_data USING     st_address
                          CHANGING  i_std_text.
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

* Perform to populate standard text dynamically on basis of company code and cuurency key
  PERFORM f_populate_std_text  USING      st_vbco3.
*                               CHANGING  v_remit_to
*                                         v_footer.

* Perform to populate society logo
  PERFORM f_get_society_logo   USING     st_vbco3
                               CHANGING  v_society_logo.

* Perform to populate item data where only one line item will be printed always
  PERFORM f_populate_data      USING     st_vbap
                               CHANGING  st_final.
  CHECK v_retcode = 0.
*************BOC by SRBOSE on 10/08/2017 for CR# 439****************
  PERFORM f_populate_barcode.
*************BOC by SRBOSE on 10/08/2017 for CR# 439****************

* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
  IF v_retcode = 0.
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
    IF nast-nacha EQ lc_01.
* Perform from where the form has been called and print PDF
      PERFORM f_adobe_print_output.
    ELSEIF nast-nacha EQ lc_05. " ELSE -> IF nast-nacha NE lc_05
* Perform has been used to send mail with an attachment of PDF
      PERFORM f_adobe_prnt_snd_mail.
    ENDIF. " IF nast-nacha EQ lc_01
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
  ENDIF. " IF v_retcode = 0
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_WILEY_LOGO
*&---------------------------------------------------------------------*
*       This perform is used to get the Wiley Logo
*----------------------------------------------------------------------*
*      <--FP_V_STRING
*----------------------------------------------------------------------*
FORM f_get_wiley_logo CHANGING fp_v_xstring TYPE xstring.

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
*----------------------------------------------------------------------*
*  -->  fp_nast
*  <--  fp_st_vbco3
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
*&      Form  F_GET_ADD_DATA
*&---------------------------------------------------------------------*
*       This perform is used to get the details of address for both
*       bill to address and ship to address
*----------------------------------------------------------------------*
*  -->  fp_st_vbco3
*  <--  fp_st_address
*----------------------------------------------------------------------*
FORM f_get_add_data USING    fp_st_vbco3   TYPE vbco3            " Sales Doc.Access Methods: Key Fields: Document Printing
                    CHANGING fp_st_address TYPE zstqtc_add_f035. " Structure for address node.

*******Local Constant declaration
  CONSTANTS: lc_we      TYPE parvw VALUE 'WE', " Ship to address
             lc_re      TYPE parvw VALUE 'RE', " Bill to address
             lc_success TYPE char1    VALUE 'S', "Success "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
             lc_sp      TYPE vbpa-parvw VALUE 'SP'.  " Forwrding Agent " ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755

********Local Data declaration
  DATA: li_vbpa       TYPE STANDARD TABLE OF ty_vbpa,
        lst_vbpa      TYPE ty_vbpa,
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
        lst_vbeln     TYPE vbak, "Sales Document
        lt_vbpa_ff    TYPE vbpa_tab,       " Frighet Forwarder
        lv_ff_flag(1) TYPE c,
        lv_multiple   TYPE c.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755


*******To populate the Bill to Address need to fetch data from VBPA table
  SELECT vbeln "Sales and Distribution Document Number
         posnr "Item number of the SD document
         parvw "Partner Function
         kunnr "Customer Number
         adrnr "Address
         land1 "Country Key
    FROM vbpa  " Sales Document: Partner
    INTO TABLE i_vbpa
    WHERE vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
********sort the local internal table
    SORT i_vbpa BY vbeln parvw posnr.
  ENDIF. " IF sy-subrc IS INITIAL

*******Read the local internal table to fetch the customer number, address number and country key
*******by passing Partner Function as RE because for Bill-To-Party if we pass BP it has been
*******converted to RE. So RE has been used to populate Bill-To-Party address
  CLEAR: lst_vbpa.
  READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                            parvw = lc_re
                                   BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    fp_st_address-kunnr_bp = lst_vbpa-kunnr. "Customer Number
    fp_st_address-adrnr_bp = lst_vbpa-adrnr. "Address Number
    fp_st_address-land1_bp = lst_vbpa-land1. "Country key
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
    v_kunnr_f044           = fp_st_address-kunnr_bp.
    v_adrnr_f044           = fp_st_address-adrnr_bp.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
  ENDIF. " IF sy-subrc IS INITIAL

*******Read the local internal table to fetch the customer number, address number and country key
*******by passing Partner Function as WE
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
  lst_vbeln-vbeln = fp_st_vbco3-vbeln.
  CALL FUNCTION 'ZQTC_FF_DETERMINE'
    EXPORTING
      im_vbak          = lst_vbeln
*     IM_VBAP          =
*     im_flag          = space
    IMPORTING
      ex_ff_flag       = lv_ff_flag
    CHANGING
      ch_vbpa          = lt_vbpa_ff
      ch_multiple_ship = lv_multiple.
  IF lt_vbpa_ff[] IS NOT INITIAL.
    DATA(li_vbpa_temp_ff) = lt_vbpa_ff[].
    DELETE li_vbpa_temp_ff WHERE parvw NE lc_sp.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_temp_ff COMPARING adrnr.
    DATA(lv_count_vbpa_ff) = lines( li_vbpa_temp_ff ).
    IF  lv_count_vbpa_ff > 1.
      fp_st_address-multiple_shipto = abap_true.
    ELSE.
      CLEAR fp_st_address-multiple_shipto.
      READ TABLE li_vbpa_temp_ff INTO DATA(lst_fright_forwarder)  INDEX 1.
      fp_st_address-kunnr_we = lst_fright_forwarder-kunnr. "Customer Number
      fp_st_address-adrnr_we = lst_fright_forwarder-adrnr. "Address Number
      fp_st_address-land1_we = lst_fright_forwarder-land1. "Country key
    ENDIF. " IF lv_count_vbpa > 1
  ENDIF.
  IF lv_multiple IS NOT INITIAL.
    fp_st_address-multiple_shipto = abap_true.
  ENDIF.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
  IF  ( fp_st_address-adrnr_we IS INITIAL
        AND fp_st_address-multiple_shipto IS INITIAL )."ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
    CLEAR: lst_vbpa.
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                              parvw = lc_we
                                              BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      fp_st_address-kunnr_we = lst_vbpa-kunnr. "Customer Number
      fp_st_address-adrnr_we = lst_vbpa-adrnr. "Address Number
      fp_st_address-land1_we = lst_vbpa-land1. "Country key
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918755
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBFA
*&---------------------------------------------------------------------*
*       This perform is used to get data from VBFA.
*       Populate renewal date and payment due date
*----------------------------------------------------------------------*
*      -->FP_VBCO3
*      <--FP_fp_st_final
*----------------------------------------------------------------------*
FORM f_get_vbfa  USING    fp_st_vbco3  TYPE vbco3            " Sales Doc.Access Methods: Key Fields: Document Printing
                          fp_st_vbap   TYPE ty_vbap
                 CHANGING fp_st_final TYPE zstqtc_head_f035. " Structure for header data of F035.

******Local table type declaration of type range
  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number

*****Local data declaration
  DATA: lst_vbak     TYPE ty_vbak,                 " Local workarea for vbak table
        li_vbkd      TYPE STANDARD TABLE OF ty_vbkd,
        lir_vbeln    TYPE ltt_vbeln_r,             " local range table of of vbeln
        lv_land1     TYPE land1,                   " Country Key
        lv_soc_text  TYPE string,                  " Society Text
        lv_text_name TYPE tdobname,                " Name
        lst_vbeln    TYPE LINE OF ltt_vbeln_r,     " Local workarea of range table
        li_lines     TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines    TYPE tline.                   " Lines of text read

******Local constant declaration
  CONSTANTS: lc_i      TYPE tvarv_sign  VALUE 'I',       "ABAP: ID: I/E (include/exclude values)
             lc_eq     TYPE tvarv_opti  VALUE 'EQ',      "ABAP: Selection option (EQ/BT/CP/...)
             lc_en     TYPE spras       VALUE 'E',       " Language Key
             lc_id     TYPE thead-tdid  VALUE '0001',    "Text ID of text to be read
             lc_object TYPE thead-tdobject VALUE 'VBBP'. "Object of text to be read
*****Fetch Data from VBFA table:Sales Document Flow
  SELECT vbelv                 "Preceding sales and distribution document
         posnv                 "Preceding item of an SD document
         vbeln                 "Subsequent sales and distribution document
         posnn                 "Subsequent item of an SD document
         vbtyp_n               "Document category of subsequent document
         vbtyp_v               "Document category of preceding SD document
    FROM vbfa                  "Sales Document Flow
    INTO st_vbfa               "Global structure of VBFA table
    UP TO 1 ROWS
    WHERE vbeln = fp_st_vbco3-vbeln  AND
          posnv NE space AND
          vbtyp_v = c_vbtyp_g. "Contract

  ENDSELECT.
  IF sy-subrc IS INITIAL.

  ENDIF. " IF sy-subrc IS INITIAL

*******Fetch data from VBKD table:Sales Document: Business Data
  SELECT
    vbeln "Sales and Distribution Document Number
    posnr "Item number of the SD document
    zterm "Terms of Payment Key
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
    zlsch
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
    bstkd "Customer purchase order number
    ihrez "Your Reference
* Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*   kdkg1      "Customer group
    kdkg2 "Customer group
* End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
     FROM vbkd " Sales Document: Business Data
    INTO TABLE li_vbkd
    WHERE vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
    SORT li_vbkd BY vbeln posnr.
  ENDIF. " IF sy-subrc IS INITIAL


*** Populate PO NUM and Sub reference number
  CLEAR: st_vbkd.
  READ TABLE li_vbkd INTO st_vbkd WITH KEY vbeln = fp_st_vbco3-vbeln
                                           posnr = fp_st_vbap-posnr.
  IF sy-subrc EQ 0.
*****Populate PO Number
    fp_st_final-po_num = st_vbkd-bstkd.
******Populate Subscription reference
    fp_st_final-sub_reference = st_vbkd-ihrez.
  ELSE. " ELSE -> IF sy-subrc EQ 0
    READ TABLE li_vbkd INTO st_vbkd WITH KEY vbeln = fp_st_vbco3-vbeln
                                             posnr = space.
    IF sy-subrc IS INITIAL.
*****Populate PO Number
      fp_st_final-po_num = st_vbkd-bstkd.
******Populate Subscription reference
      fp_st_final-sub_reference = st_vbkd-ihrez.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc EQ 0

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
  v_zlsch_f044               = st_vbkd-zlsch.
*** BOC BY SAYANDAS   on 18-JULY-2018
* v_ihrez_f044               = fp_st_final-sub_reference.
  v_ihrez_f044               = st_vbco3-vbeln.
*** EOC BY SAYANDAS   on 18-JULY-2018
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

******Populating Range for VBELN
  lst_vbeln-sign   = lc_i.
  lst_vbeln-option = lc_eq.
  lst_vbeln-low    = fp_st_vbco3-vbeln.
  APPEND lst_vbeln TO lir_vbeln.
  CLEAR lst_vbeln.


*******Fetch data from VBAK table:Sales Document: Header Data
  SELECT vbeln    "Sales Document
         angdt    "Quotation/Inquiry is valid from
         vbtyp    "SD document type
         auart    "SD document category
         waerk    "SD Document Currency
         knumv    "Number of the document condition
         kvgr1    "Customer Group  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
         vkbur    "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913787
         bukrs_vf "Company code to be billed
    FROM vbak     "Sales Document: Header Data
    INTO TABLE i_vbak
    WHERE vbeln = fp_st_vbco3-vbeln.

  IF sy-subrc IS INITIAL.

*******Sort the table by vbeln
    SORT i_vbak BY vbeln.
    CLEAR: lst_vbak.
  ENDIF. " IF sy-subrc IS INITIAL
*    ENDIF.
*  ENDIF.

* To get the country for company code to be billed
  READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln =  st_vbco3-vbeln.
  IF sy-subrc EQ 0.
    SELECT SINGLE land1 " Country Key
             INTO lv_land1
             FROM t001  " Company Codes
            WHERE bukrs = lst_vbak-bukrs_vf.
    IF sy-subrc EQ 0.
      fp_st_final-land1_bukrs  = lv_land1.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* End of change: PBANDLAPAL: 06-SEP-2017: ERP-4086 : ED2K908397
********Concatenate vbeln and posnr to get the text name
  CONCATENATE st_vbap-vbeln
              st_vbap-posnr
              INTO lv_text_name.
  CONDENSE lv_text_name NO-GAPS.

*********Populate Society text By using Read Text FM.
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
*      id                      = lc_id
*      language                = st_address-spras
*      name                    = lv_text_name
*      object                  = lc_object
*    TABLES
*      lines                   = li_lines
*    EXCEPTIONS
*      id                      = 1
*      language                = 2
*      name                    = 3
*      not_found               = 4
*      object                  = 5
*      reference_check         = 6
*      wrong_access_to_archive = 7
*      OTHERS                  = 8.
*  IF sy-subrc EQ 0.
*    IF sy-subrc IS INITIAL.
*      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*      EXPORTING
*        it_tline       = li_lines
*      IMPORTING
*        ev_text_string = lv_soc_text.
*    IF sy-subrc EQ 0.
*      CONDENSE lv_soc_text.
*    ENDIF. " IF sy-subrc EQ 0
********Populate Society Text
*      fp_st_header-society_text = lv_soc_text.
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAP_DATA
*&---------------------------------------------------------------------*
*       This Perfrom is used to get VBAP data which is used to
*       populate the final structure(Item)
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3
**      <--FP_ST_VBAP
*----------------------------------------------------------------------*
* ASSUMPTION : There will be only one line item maintained.
*----------------------------------------------------------------------*
FORM f_get_vbap_data  USING    fp_st_vbco3 TYPE vbco3 " Sales Doc.Access Methods: Key Fields: Document Printing
                      CHANGING fp_st_vbap  TYPE ty_vbap.

  DATA: lst_vbap          TYPE ty_vbap,
        lt_vbap           TYPE TABLE OF ty_vbap,
        lst_vbap_bom      TYPE ty_vbap,
        lv_matnr          TYPE matnr,               " Material Number
        lv_vbegdat        TYPE vbdat_veda,          " Contract start date
        lv_venddat        TYPE vbdat_veda,          " Contract start date
        li_veda_quote     TYPE TABLE OF ty_veda_qt,
        lst_veda_quote    TYPE ty_veda_qt,
        lst_cntrct_dat_qt TYPE ty_cntrct_dat_qt,
        lir_cntrct_dat_qt TYPE RANGE OF vbdat_veda. " Contract start date


********Fetch data from VBAP table:Sales Document: Item Data
  SELECT  vbeln "Sales Document
          posnr "Sales Document Item
          matnr "Material Number
*          arktx  "Short text for sales order item
          uepos  "Higher-level item in bill of material structures
          kwmeng "Cumulative Order Quantity in Sales Units
          kzwi1  "Subtotal 1 from pricing procedure for condition
          kzwi2  "Subtotal 2 from pricing procedure for condition
          kzwi3  "Subtotal 3 from pricing procedure for condition
          kzwi4  "Subtotal 4 from pricing procedure for condition
          kzwi5  "Subtotal 5 from pricing procedure for condition
          kzwi6  "Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
          mvgr4  "Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
          mvgr5  "Material group-5, ADD for CR#7730 KKRAVURI20181012  ED2K913576
     FROM vbap   "Sales Document: Item Data
     INTO TABLE lt_vbap
     WHERE vbeln = fp_st_vbco3-vbeln
*      Begin of ADD:ERP-6870:WROY:06-Mar-2018:ED2K911163
       AND abgru EQ space. "Ignore Rejected lines
*      End   of ADD:ERP-6870:WROY:06-Mar-2018:ED2K911163
  IF sy-subrc IS INITIAL.
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
    SORT lt_vbap BY vbeln posnr.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
    i_vbap[] = lt_vbap[].
*   Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
*   SORT lt_vbap BY vbeln posnr.
*   End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
    READ TABLE lt_vbap INTO fp_st_vbap INDEX 1.
  ENDIF. " IF sy-subrc IS INITIAL
*
  IF i_vbap IS NOT INITIAL.
    DATA(li_vbap_tmp) = i_vbap[].
    SORT li_vbap_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING matnr.
    IF li_vbap_tmp IS NOT INITIAL.
*  Fetch media values from MARA
      SELECT matnr " Material Number
             mtart
             volum " Volume
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
             ismhierarchlevl
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
             ismmediatype " Media Type
             ismnrinyear  " Issue Number (in Year Number)
             ismyearnr    " Media issue year number
        FROM mara         " General Material Data
        INTO TABLE i_mara
        FOR ALL ENTRIES IN li_vbap_tmp
        WHERE matnr EQ li_vbap_tmp-matnr.
      IF sy-subrc EQ 0.
        SORT i_mara BY matnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_vbap_tmp IS NOT INITIAL
  ENDIF. " IF i_vbap IS NOT INITIAL


* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
* Fetch ID codes of material from JPTIDCDASSIGN table
  SELECT matnr         " Material Number
         idcodetype    " Type of Identification Code
         identcode     " Identification Code
    FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
    INTO TABLE i_jptidcdassign
     FOR ALL ENTRIES IN lt_vbap
   WHERE matnr      EQ lt_vbap-matnr
     AND ( idcodetype EQ v_idcodetype_1
      OR idcodetype EQ v_idcodetype_2 ).
  IF sy-subrc EQ 0.
    SORT i_jptidcdassign BY matnr idcodetype.
  ENDIF. " IF sy-subrc EQ 0
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241

ENDFORM.
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
  CONSTANTS: lc_a          TYPE koaid VALUE 'A', " Condition class
             lc_d          TYPE koaid VALUE 'D', " Condition class
             lc_char_blank TYPE kinak VALUE '',  " Condition is inactive
             lc_percentage TYPE char1 VALUE '%'. " Percentage of type CHAR1


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
*     DELETE i_konv WHERE koaid NE 'D' OR kappl NE 'TX'.
      DELETE i_konv WHERE koaid NE 'D'.
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
      DELETE i_konv WHERE kawrt IS INITIAL.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
* BOC by PBANDLAPAL on 13-Feb-2018 for CR#743
*      DELETE i_konv WHERE kbetr IS INITIAL.
* EOC by PBANDLAPAL on 13-Feb-2018 for CR#743
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SOCIETY_LOGO
*&---------------------------------------------------------------------*
*       Society logo has been populated in this perform
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3  text
*      <--FP_V_SOCIETY_LOGO
*----------------------------------------------------------------------*
FORM f_get_society_logo  USING    fp_st_vbco3       TYPE vbco3 " Sales Doc.Access Methods: Key Fields: Document Printing
                         CHANGING fp_v_society_logo TYPE xstring.

********Local constant declaration
  CONSTANTS : lc_order  TYPE char10     VALUE 'ORDER',    " Order of type CHAR10
              lc_object TYPE tdobjectgr VALUE 'GRAPHICS', " SAPscript Graphics Management: Application object
              lc_id     TYPE tdidgr     VALUE 'BMAP',     " SAPscript Graphics Management: ID
              lc_btype  TYPE tdbtype    VALUE 'BCOL'.     " Graphic type

********Local Data declaration
  DATA: lv_society_logo TYPE char100,  "variable of society logo
        lv_logo_name    TYPE tdobname. " Name
  IF v_scenario_scc = abap_true OR
     v_scenario_scm = abap_true.
*******Get the name of LOGO for Form
    CALL FUNCTION 'ZQTC_GET_FORM_LOGO_NAME'
      EXPORTING
        im_doc_no                     = fp_st_vbco3-vbeln
        im_doc_type                   = lc_order "'ORDER'
      IMPORTING
        ex_logo_name                  = lv_society_logo
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
  ENDIF. " IF v_scenario_scc = abap_true OR

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_STD_TEXT
*&---------------------------------------------------------------------*
*       This perform is usd to call the standard text dynamically
*       based on company code and currency key
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3
*      <--FP_V_REMIT_TO
*      <--FP_V_FOOTER
*----------------------------------------------------------------------*
FORM f_populate_std_text  USING    fp_st_vbco3   TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing
*                          CHANGING fp_v_remit_to TYPE thead-tdname
*                                   fp_v_footer   TYPE thead-tdname.

*******Local data declaration
  DATA: lst_vbak    TYPE ty_vbak,  "Local workarea for structure vbak
        lv_waerk    TYPE waerk,    "Local Variable for currency
        lv_bukrs_vf TYPE bukrs_vf, "Local variable for company code
* Begin of change by SRBOSE: 30-June-2017: #TR:  ED2K907341
        li_lines    TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines   TYPE tline,                   " Lines of text read
        lv_kunnr_sp TYPE kunnr,                   " Customer Number
        lv_kunnr_za TYPE kunnr,                   " Customer Number
        lst_vbpa    TYPE ty_vbpa.
* End of change by SRBOSE: 30-June-2017: #TR:  ED2K907341

*******Local Constant declaration
  CONSTANTS: lc_underscore    TYPE char1  VALUE '_',                  " Underscore
             lc_txtname_part1 TYPE char10 VALUE 'ZQTC_F035_',         " Txtname_part1 of type CHAR20
             lc_cust_service  TYPE char20 VALUE 'ZQTC_CUST_SERVICE_', " Cust_service of type CHAR20
             lc_email_id      TYPE char20 VALUE 'ZQTC_EMAIL_',        " Email_id of type CHAR20
             lc_remit         TYPE char20 VALUE 'ZQTC_REMIT_TO',      " Remit of type CHAR20
             lc_remit_to      TYPE char10 VALUE 'REMIT_TO_',          " Txtname_part2 of type CHAR6
             lc_footer        TYPE char10 VALUE 'FOOTER_',            " Txtname_part2 of type CHAR6
             lc_footer_dflt   TYPE char16 VALUE 'ZQTC_FOOTER_',       " Footer_dflt of type CHAR16
* Begin of change by SRBOSE: 29-June-2017: #TR:  ED2K906739
             lc_banking1      TYPE char9  VALUE 'BANKING1_',     " Banking1 of type CHAR9
             lc_banking2      TYPE char9  VALUE 'BANKING2_',     " Banking2 of type CHAR9
             lc_cust          TYPE char13 VALUE 'CUST_SERVICE_', " Cust of type CHAR13
             lc_email         TYPE char6  VALUE 'EMAIL_',        " Email of type CHAR6
             lc_credit        TYPE char7  VALUE 'CREDIT_',       " Credit of type CHAR7
             lc_tbt           TYPE char3  VALUE  'TBT',          " Tbt of type CHAR3
             lc_scc           TYPE char3  VALUE  'SCC',          " Scc of type CHAR3
             lc_scm           TYPE char3  VALUE  'SCM',          " Scm of type CHAR3
             lc_xxx           TYPE char3  VALUE  'XXX',          " Scm of type CHAR3
             lc_sp            TYPE parvw  VALUE 'AG',            " Partner Function
             lc_za            TYPE parvw  VALUE 'ZA',            " Partner Function
             lc_st            TYPE thead-tdid     VALUE 'ST',    "Text ID of text to be read
             lc_object        TYPE thead-tdobject VALUE 'TEXT',  "Object of text to be read
*** BOC BY SAYNADAS on 03-AUG-2018 for CR-6307
             lc_text_body_mem TYPE char30 VALUE 'ZQTC_F035_RENEWAL_BODY_MEM_PDF', " Text_body_mem of type CHAR30
             lc_text_body_sub TYPE char26 VALUE 'ZQTC_F035_RENEWAL_BODY_PDF',     " Text_body_sub of type CHAR26
*** EOC BY SAYNADAS on 03-AUG-2018 for CR-6307
* End of change by SRBOSE: 29-June-2017: #TR:  ED2K906739
             lc_comp_name     TYPE char10 VALUE 'COMP_NAME_', " Txtname for company name.
             lc_txtname_part2 TYPE char15 VALUE 'ZQTC_F032_', " Txtname_part2 of type CHAR20
             lc_bank          TYPE thead-tdname   VALUE 'ZQTC_F035_BANK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_remit1        TYPE thead-tdname   VALUE 'ZQTC_F035_CHECK_DETAILS_1001_USD'. "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785


*******The i_vbak table is already sorted.
*******Here read table is used to get the company code and currency key
  READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = fp_st_vbco3-vbeln
                                              BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    lv_waerk    = lst_vbak-waerk.
    lv_bukrs_vf = lst_vbak-bukrs_vf.
    v_kvgr1_f044  = lst_vbak-kvgr1.  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
  ENDIF. " IF sy-subrc IS INITIAL

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
  v_waerk_f044  = lv_waerk.
  v_vkorg_f044  = lv_bukrs_vf.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

* Begin of change by SRBOSE: 30-June-2017: #TR: ED2K907341
  CLEAR lst_vbpa.
  READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                           parvw = lc_sp
                                           BINARY SEARCH.
  IF  sy-subrc IS INITIAL.
    lv_kunnr_sp = lst_vbpa-kunnr.
  ENDIF. " IF sy-subrc IS INITIAL

  CLEAR lst_vbpa.

  READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                           parvw = lc_za
                                           BINARY SEARCH.
  IF  sy-subrc IS INITIAL.
    lv_kunnr_za = lst_vbpa-kunnr.
  ENDIF. " IF sy-subrc IS INITIAL


*  IF lst_vbpa-parvw NE lc_za.
  IF lv_kunnr_za IS INITIAL. " Added by PBANDLAPAL
    v_scenario_tbt = abap_true. " Added by PBANDLAPAL
********Populate remit to address
    CONCATENATE lc_txtname_part1
                lc_remit_to
                lv_bukrs_vf
                lc_underscore
                lv_waerk
                lc_underscore
                lc_tbt
           INTO v_remit_to_tbt.
    CONDENSE v_remit_to_tbt NO-GAPS.
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
    READ TABLE i_vbak INTO DATA(lst_vbak_tmp1) INDEX 1.
    IF lv_bukrs_vf IN r_comp_code AND lv_waerk IN  r_docu_currency  AND lst_vbak_tmp1-vkbur IN r_sales_office.
      CLEAR v_remit_to_tbt.
      v_remit_to_tbt  = lc_remit1.
      CONDENSE v_remit_to_tbt NO-GAPS.
    ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
****Begin of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241
    READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = v_remit_to_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_remit_to_tbt.
      CONCATENATE lc_remit
                  lc_underscore
                  lc_xxx
                  INTO v_remit_to_tbt.
    ENDIF. " IF sy-subrc NE 0
****End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate banking1
    CONCATENATE lc_txtname_part1
                lc_banking1
                lv_bukrs_vf
                lc_underscore
                lv_waerk
                lc_underscore
                lc_tbt
           INTO v_banking1_tbt.
    CONDENSE v_banking1_tbt NO-GAPS.

**********Populate banking2
    CONCATENATE lc_txtname_part1
            lc_banking2
            lv_bukrs_vf
            lc_underscore
            lv_waerk
            lc_underscore
            lc_tbt
       INTO v_banking2_tbt.
    CONDENSE v_banking2_tbt NO-GAPS.
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
    READ TABLE i_vbak INTO DATA(lst_vbak_tmp) INDEX 1.
    IF lv_bukrs_vf IN r_comp_code AND lv_waerk IN  r_docu_currency  AND lst_vbak_tmp-vkbur IN r_sales_office.
      CLEAR: v_banking2_tbt,v_banking1_tbt.
      v_banking2_tbt = v_banking1_tbt  = lc_bank.
    ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF v_remit_to_tbt CS lc_xxx OR
       st_address-country IN r_sanc_countries.
      CLEAR: v_banking1_tbt,
             v_banking2_tbt.
    ENDIF. " IF v_remit_to_tbt CS lc_xxx OR
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate Customer Service
    CONCATENATE lc_txtname_part1
        lc_cust
        lv_bukrs_vf
        lc_underscore
        lv_waerk
        lc_underscore
        lc_tbt
   INTO v_cust_serv_tbt.
    CONDENSE v_cust_serv_tbt NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_cust_serv_tbt.
      CONCATENATE lc_cust_service
                  lc_tbt
                  lc_underscore
                  lv_bukrs_vf
                  lc_underscore
                  lc_xxx
                  INTO v_cust_serv_tbt.
      CONDENSE v_cust_serv_tbt NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate email
    CONCATENATE lc_txtname_part1
    lc_email
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_tbt
INTO v_email_tbt.
    CONDENSE v_email_tbt NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_email_tbt
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_email_tbt.
      CONCATENATE lc_email_id
                  lc_xxx
                  INTO v_email_tbt.
      CONDENSE v_email_tbt NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

********Populate credit card details
    CONCATENATE lc_txtname_part1
    lc_credit
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_tbt
INTO v_credit_tbt.
    CONDENSE v_credit_tbt NO-GAPS.
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF st_address-country IN r_sanc_countries.
      CLEAR: v_credit_tbt.
    ENDIF. " IF st_address-country IN r_sanc_countries
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate footer
    CONCATENATE lc_txtname_part1
    lc_footer
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_tbt
INTO v_footer.
    CONDENSE v_footer NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_footer.
      CONCATENATE lc_footer_dflt
                  lv_bukrs_vf
                  lc_underscore
                  lc_tbt
                  INTO v_footer.
      CONDENSE v_footer NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

  ELSEIF lv_kunnr_sp = lv_kunnr_za.
    v_scenario_scc = abap_true. " Added by PBANDLAPAL
**********Populate remit to
    CONCATENATE lc_txtname_part1
          lc_remit_to
          lv_bukrs_vf
          lc_underscore
          lv_waerk
          lc_underscore
          lc_scc
     INTO v_remit_to_scc.
    CONDENSE v_remit_to_scc NO-GAPS.

****Begin of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_remit_to_scc
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_remit_to_scc.
      CONCATENATE lc_remit
                  lc_underscore
                  lc_xxx
                  INTO v_remit_to_scc.
    ENDIF. " IF sy-subrc NE 0
****End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate banking1
    CONCATENATE lc_txtname_part1
                lc_banking1
                lv_bukrs_vf
                lc_underscore
                lv_waerk
                lc_underscore
                lc_scc
           INTO v_banking1_scc.
    CONDENSE v_banking1_scc NO-GAPS.

**********Populate banking2
    CONCATENATE lc_txtname_part1
            lc_banking2
            lv_bukrs_vf
            lc_underscore
            lv_waerk
            lc_underscore
            lc_scc
       INTO v_banking2_scc.
    CONDENSE v_banking2_scc NO-GAPS.
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF v_remit_to_scc CS lc_xxx OR
       st_address-country IN r_sanc_countries.
      CLEAR: v_banking1_scc,
             v_banking2_scc.
    ENDIF. " IF v_remit_to_scc CS lc_xxx OR
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate customer service
    CONCATENATE lc_txtname_part1
        lc_cust
        lv_bukrs_vf
        lc_underscore
        lv_waerk
        lc_underscore
        lc_scc
   INTO v_cust_serv_scc.
    CONDENSE v_cust_serv_scc NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_scc
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_cust_serv_scc.
      CONCATENATE lc_cust_service
                  lc_scc
                  lc_underscore
                  lv_bukrs_vf
                  lc_underscore
                  lc_xxx
                  INTO v_cust_serv_scc.
      CONDENSE v_cust_serv_scc NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate email
    CONCATENATE lc_txtname_part1
    lc_email
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scc
INTO v_email_scc.
    CONDENSE v_email_scc NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_email_scc
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_email_scc.
      CONCATENATE lc_email_id
                  lc_xxx
                  INTO v_email_scc.
      CONDENSE v_email_scc NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

********Populate credit card details
    CONCATENATE lc_txtname_part1
    lc_credit
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scc
INTO v_credit_scc.
    CONDENSE v_credit_scc NO-GAPS.
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF st_address-country IN r_sanc_countries.
      CLEAR: v_credit_scc.
    ENDIF. " IF st_address-country IN r_sanc_countries
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate footer
    CONCATENATE lc_txtname_part1
    lc_footer
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scc
INTO v_footer.
    CONDENSE v_footer NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_footer.
      CONCATENATE lc_footer_dflt
                  lv_bukrs_vf
                  lc_underscore
                  lc_scc
                  INTO v_footer.
      CONDENSE v_footer NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

  ELSEIF lv_kunnr_sp NE lv_kunnr_za. " ELSE -> IF lv_kunnr_za IS INITIAL.
    v_scenario_scm = abap_true. " Added by PBANDLAPAL
**********Populate remit to
    CONCATENATE lc_txtname_part1
    lc_remit_to
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scm
INTO v_remit_to_scm.
    CONDENSE v_remit_to_scm NO-GAPS.

****Begin of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_remit_to_scm
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_remit_to_scm.
      CONCATENATE lc_remit
                  lc_underscore
                  lc_xxx
                  INTO v_remit_to_scm.
    ENDIF. " IF sy-subrc NE 0
****End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate banking1
    CONCATENATE lc_txtname_part1
                lc_banking1
                lv_bukrs_vf
                lc_underscore
                lv_waerk
                lc_underscore
                lc_scm
           INTO v_banking1_scm.
    CONDENSE v_banking1_scm NO-GAPS.

**********Populate banking2
    CONCATENATE lc_txtname_part1
            lc_banking2
            lv_bukrs_vf
            lc_underscore
            lv_waerk
            lc_underscore
            lc_scm
       INTO v_banking2_scm.
    CONDENSE v_banking2_scm NO-GAPS.
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF v_remit_to_scm CS lc_xxx OR
       st_address-country IN r_sanc_countries.
      CLEAR: v_banking1_scm,
             v_banking2_scm.
    ENDIF. " IF v_remit_to_scm CS lc_xxx OR
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate customer service
    CONCATENATE lc_txtname_part1
        lc_cust
        lv_bukrs_vf
        lc_underscore
        lv_waerk
        lc_underscore
        lc_scm
   INTO v_cust_serv_scm.
    CONDENSE v_cust_serv_scm NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_scm
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_cust_serv_scm.
      CONCATENATE lc_cust_service
                  lc_scm
                  lc_underscore
                  lv_bukrs_vf
                  lc_underscore
                  lc_xxx
                  INTO v_cust_serv_scm.
      CONDENSE v_cust_serv_scm NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

**********Populate email
    CONCATENATE lc_txtname_part1
    lc_email
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scm
INTO v_email_scm.
    CONDENSE v_email_scm NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_email_scm
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    OR st_address-country IN r_sanc_countries.
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      CLEAR : v_email_scm.
      CONCATENATE lc_email_id
                  lc_xxx
                  INTO v_email_scm.
      CONDENSE v_email_scm NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241

********Populate credit card details
    CONCATENATE lc_txtname_part1
    lc_credit
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scm
INTO v_credit_scm.
    CONDENSE v_credit_scm NO-GAPS.
*   Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
    IF st_address-country IN r_sanc_countries.
      CLEAR: v_credit_scm.
    ENDIF. " IF st_address-country IN r_sanc_countries
*   End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781

**********Populate footer
    CONCATENATE lc_txtname_part1
    lc_footer
    lv_bukrs_vf
    lc_underscore
    lv_waerk
    lc_underscore
    lc_scm
INTO v_footer.
    CONDENSE v_footer NO-GAPS.

***BOC SRBOSE on 19-Mar-2018 for ERP_6599 TR  ED2K911241
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : v_footer.
      CONCATENATE lc_footer_dflt
                  lv_bukrs_vf
                  lc_underscore
                  lc_scm
                  INTO v_footer.
      CONDENSE v_footer NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 19-Mar-2018: ERP_6599: TR:  ED2K911241
  ENDIF. " IF lv_kunnr_za IS INITIAL
* End of change by SRBOSE: 30-June-2017: #TR: ED2K907341

*********Populate remit to address
*  CONCATENATE lc_txtname_part1
*              lc_remit_to
*              lv_bukrs_vf
*              lc_underscore
*              lv_waerk
*         INTO fp_v_remit_to.
*
*  CONDENSE fp_v_remit_to NO-GAPS.
*
*********Populate Footer
*  CONCATENATE lc_txtname_part1
*            lc_footer
*            lv_bukrs_vf
*            lc_underscore
*            lv_waerk
*       INTO fp_v_footer.
*
*  CONDENSE fp_v_footer NO-GAPS.

* Begin of change by PBANDLAPAL on 11-Sep-2017: #TR:  ED2K908397
****** To populate the company name under wiley logo.
* we are using the F032 company name standard text as it is common to all
* renewal forms and to avoid unnecessary creation of standard texts.
  CONCATENATE lc_txtname_part2
              lc_comp_name
              lv_bukrs_vf
              lc_underscore
              lv_waerk
         INTO v_compname.
  CONDENSE v_compname NO-GAPS.
  IF v_scenario_scc = abap_true OR
     v_scenario_scm = abap_true.
    v_member = abap_true.
  ELSE. " ELSE -> IF v_scenario_scc = abap_true OR
    v_subscriber = abap_true.
  ENDIF. " IF v_scenario_scc = abap_true OR
* End of change by PBANDLAPAL on 21-Sep-2017: #TR: ED2K908397
*** BOC BY SAYNADAS on 03-AUG-2018 for CR-6307
  IF v_member = abap_true.
    st_final-text_body = lc_text_body_mem.
  ELSEIF v_subscriber = abap_true.
    st_final-text_body = lc_text_body_sub.
  ENDIF. " IF v_member = abap_true
*** EOC BY SAYNADAS on 03-AUG-2018 for CR-6307
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT
*&---------------------------------------------------------------------*
*       This perform is used to from where the form has been called
*----------------------------------------------------------------------*
*      -->P_XDRUVO  text
*      -->P_ENT_SCREEN  text
*      -->P_L_XFZ  text
*      <--P_ENT_RETCO  text
*----------------------------------------------------------------------*
FORM f_adobe_print_output.

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
  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
    lst_sfpoutputparams-preview = abap_true.
    lst_sfpoutputparams-getpdf  = abap_false.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen = c_screen_webdyn. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = c_screen_webdyn
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
  lst_sfpdocparams-langu     = nast-spras.

* Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.

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
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*    MESSAGE e071(zqtc_r2). "Error in form display
    CLEAR v_msg_txt.
    MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        CLEAR: lr_text,
               v_msg_txt.
        lr_text = lr_err_usg->get_text( ).
        MESSAGE i086(zqtc_r2) WITH lr_text INTO v_msg_txt. " An exception occurred  ##MG_MISSING
*        LEAVE LIST-PROCESSING.
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
      CATCH cx_fp_api_repository INTO lr_err_rep.
        CLEAR: lr_text,
               v_msg_txt.
        lr_text = lr_err_rep->get_text( ).
        MESSAGE e086(zqtc_r2) WITH lr_text INTO v_msg_txt. " An exception occurred
*        LEAVE LIST-PROCESSING.
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
      CATCH cx_fp_api_internal INTO lr_err_int.
        CLEAR: lr_text,
               v_msg_txt.
        lr_text = lr_err_int->get_text( ).
        MESSAGE i086(zqtc_r2) WITH lr_text INTO v_msg_txt. " An exception occurred
*        LEAVE LIST-PROCESSING.
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
    ENDTRY.
    IF v_retcode = 0.
      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000066'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_xstring         = v_xstring
          im_address         = st_address
          im_vbco3           = st_vbco3
          im_society_logo    = v_society_logo
          im_final           = st_final
          im_vbap            = vbap
          im_footer          = v_footer
          im_body            = i_body
          im_remit_to        = v_remit_to
          im_renewal_text    = v_renewal_text
          im_body1           = v_body
          im_remit_to_tbt    = v_remit_to_tbt
          im_remit_to_scc    = v_remit_to_scc
          im_remit_to_scm    = v_remit_to_scm
          im_credit_scm      = v_credit_scm
          im_credit_tbt      = v_credit_tbt
          im_credit_scc      = v_credit_scc
          im_email_tbt       = v_email_tbt
          im_email_scc       = v_email_scc
          im_email_scm       = v_email_scm
          im_banking1_scm    = v_banking1_scm
          im_banking1_scc    = v_banking1_scc
          im_banking1_tbt    = v_banking1_tbt
          im_banking2_scc    = v_banking2_scc
          im_banking2_scm    = v_banking2_scm
          im_banking2_tbt    = v_banking2_tbt
          im_cust_serv_tbt   = v_cust_serv_tbt
          im_cust_serv_scc   = v_cust_serv_scc
          im_cust_serv_scm   = v_cust_serv_scm
          im_footer_scm      = v_footer_scm
          im_footer_scc      = v_footer_scc
          im_footer_tbt      = v_footer_tbt
          im_v_seller_reg    = v_seller_reg
          im_v_barcode       = v_barcode
          im_company_name    = v_compname
          im_tax_tab         = i_tax_tab
          im_arktx           = i_arktx
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
          im_year            = v_year
          im_cntr_end        = v_cntr_end "CR-7841:SGUDA:30-Apr-2019:ED1K910099
          im_issue_desc      = v_issue_desc
          im_start_issue     = v_start_issue
*** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
          im_issn            = v_issn
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
*** Begin of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
          im_v_buyer_reg     = v_buyer_reg
*** End of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*    MESSAGE e071(zqtc_r2). "Error in form display
        CLEAR v_msg_txt.
        MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*    MESSAGE e071(zqtc_r2). "Error in form display
          CLEAR v_msg_txt.
          MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
        ENDIF. " IF sy-subrc <> 0
        IF v_retcode = 0 AND v_ent_screen IS INITIAL.
*         Begin of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911708
          IF lst_sfpoutputparams-arcmode <> '1'.

            CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
              EXPORTING
                documentclass            = 'PDF' "  class
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
*             Check if the subroutine is called in update task.
              CALL METHOD cl_system_transaction_state=>get_in_update_task
                RECEIVING
                  in_update_task = lv_upd_tsk.
*             COMMINT only if the subroutine is not called in update task
              IF lv_upd_tsk EQ 0.
                COMMIT WORK.
              ENDIF. " IF lv_upd_tsk EQ 0
            ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'
*         End   of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911708
********Perform is used to call E098 FM  & convert PDF in to Binary
          PERFORM f_call_fm_output_supp CHANGING li_output.

          PERFORM send_pdf_to_app_serv USING li_output.
        ENDIF. " IF v_retcode = 0 AND v_ent_screen IS INITIAL
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF v_retcode = 0
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*       Perform is used to convert PDF into Binary
*----------------------------------------------------------------------*
*  -->  p1
*  <--  p2
*----------------------------------------------------------------------*
*FORM f_convert_pdf_binary .
*
*******CONVERT_PDF_BINARY
*  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*    EXPORTING
*      buffer     = st_formoutput-pdf
*    TABLES
*      binary_tab = i_content_hex.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       Perform is used for mail sending with an attachemnt
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mail_attachment USING fp_li_output TYPE ztqtc_output_supp_retrieval.

****Local Type declaration.
  TYPES: BEGIN OF lty_body,
*           tdline TYPE tdline, " Text Line
           tdline TYPE string,
         END OF lty_body.

  TYPES: BEGIN OF ty_lines,
           tdformat TYPE tdformat, " Tag column
           tdline   TYPE char255,  " Tdline of type CHAR255
         END OF ty_lines,

* Begin of change by SRBOSE: 29-June-2017: #TR: ED2K907341
         BEGIN OF lty_constant,
           mandt       TYPE  mandt,              "Client
           devid       TYPE  zdevid,             "Development ID
           param1      TYPE  rvari_vnam,         "ABAP: Name of Variant Variable
           param2      TYPE  rvari_vnam,         "ABAP: Name of Variant Variable
           srno        TYPE  tvarv_numb,         "ABAP: Current selection number
           sign        TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
           opti        TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
           low         TYPE  salv_de_selopt_low, "Lower Value of Selection Condition
           high        TYPE salv_de_selopt_high, "Upper Value of Selection Condition
           activate    TYPE  zconstactive,       "Activation indicator for constant
           description TYPE  zconstdesc,         "Description of constant
         END OF lty_constant.
* End of change by SRBOSE: 29-June-2017: #TR: ED2K907341

  DATA:
    lo_mr_api         TYPE REF TO if_mr_api,                   " API for MIME Repository - Basic Functions
    lo_mime_helper    TYPE REF TO cl_gbt_multirelated_service, " Help Class for Multipart/Related in Business Workplace
    lo_doc_bcs        TYPE REF TO cl_document_bcs,             " Wrapper Class for Office Documents
    lo_bcs            TYPE REF TO cl_bcs,                      " Business Communication Service
    lo_sender         TYPE REF TO if_sender_bcs,               " Interface of Sender Object in BCS
    lv_msgtxt         TYPE string,
    lv_lines2_em      TYPE i,                                  " Lines2_em of type Integers
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
    lv_lines3_em      TYPE i, " Lines3_em of type Integers
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
    lv_name_bt        TYPE string,     " First and Last Name of Bill to
    lv_name_sp        TYPE string,     " First and Last Name of Ship to
    lv_folder         TYPE boole_d,    " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
    lv_xstr           TYPE xstring,
    ls_loio           TYPE skwf_io,    " KW Framework: Object Key
    lt_solix          TYPE solix_tab,
    lv_filename       TYPE localfile,  " BCOM: Text That Is to Be Converted into MIME
    lv_obj_len        TYPE so_obj_len, " Size of Document Content
    lv_diff           TYPE i,          " Diff of type Integers
    lv_content_id     TYPE mime_cntid, " BCOM: Bodypart Content ID
*    lv_folder      TYPE boole_d,
*    lv_xstr        TYPE xstring,
    lv_subject        TYPE so_obj_des,              " Short description of contents
    lt_it_tline       TYPE ty_tline,
    ls_lines          TYPE ty_lines,
    lv_recp_id        TYPE adr6-smtp_addr,          " E-Mail Address
    lv_content        TYPE xstring,
    lv_graphic_length TYPE tdlength,                " SAPscript: Token length
    lv_offset         TYPE i,                       " Offset of type Integers
    lv_length         TYPE i,                       " Length of type Integers
    lt_it_objtext     TYPE ccrctt_text_tab,
    ls_solix          TYPE solix,                   " SAPoffice: Binary data, length 255
    lo_recipient      TYPE REF TO if_recipient_bcs, " Interface of Recipient Object in BCS
    li_email_data     TYPE solix_tab,
    lv_document_no    TYPE saeobjid,                " SAP ArchiveLink: Object ID (object identifier)
    lv_flag           TYPE xfeld.                   " Checkbox

******Local Constant Declaration
  DATA: lr_sender                      TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        li_lines1                      TYPE STANDARD TABLE OF tline,               "Lines of text read
        li_lines2                      TYPE STANDARD TABLE OF tline,               "Lines of text read
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
        li_lines3                      TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
        li_url                         TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
* BOI by PBANDLAPAL on 20-Feb-2018 for CR#743: ED2K910989
        lst_tax_tab                    TYPE zstqtc_tax_f037, " Amount and Tax Details display in F032
* EOI by PBANDLAPAL on 20-Feb-2018 for CR#743: ED2K910989
        lst_lines2                     TYPE tline,                                 " SAPscript: Text Lines
        lst_address_printform_table    TYPE adrs_print,                            " Formatted address (maximum 10 lines)
        lst_address_printform_table_we TYPE adrs_print,                            " Formatted address (maximum 10 lines)
        lst_cust_serv_dtls             TYPE soli,                                  " SAPoffice: line, length 255
        li_cust_serv_dtls              TYPE STANDARD TABLE OF soli INITIAL SIZE 0, " " SAPoffice: line, length 255
        lv_txtmodule_url               TYPE string,
        lv_view_page_txt               TYPE string,                                " standard text for view page
        lv_donot_reply_txt             TYPE string,                                " Standard text for please do not reply
        lv_vol_issues_txt              TYPE string,
        lv_sub_total_char              TYPE char15,                                " Sub_total_char of type CHAR15
        lv_tax_char                    TYPE char15,                                " Tax_char of type CHAR15
        lv_discount_char               TYPE char15,                                " Discount_char of type CHAR15
        lv_total_due                   TYPE char15,                                " Total_due of type CHAR15
        t_hex                          TYPE solix_tab,
        t_hex_1                        TYPE soli_tab,
*Convert XSTRING to ITAB
        lt_hex1                        TYPE solix_tab,
        lt_hex2                        TYPE solix_tab,
        ls_hex                         LIKE LINE OF lt_hex1,
        lv_img1_size                   TYPE sood-objlen, " Size of Document Content
        lv_img2_size                   TYPE sood-objlen, " Size of Document Content
        html_string                    TYPE string,
        xhtml_string                   TYPE xstring,
        lst_body                       TYPE lty_body,
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
        lst_body1                      TYPE lty_body,
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
        lst_credit                     TYPE lty_body,
        lst_terms                      TYPE lty_body,
        lst_footer                     TYPE lty_body,
        lst_id_body                    TYPE lty_body,
        lst_remit                      TYPE lty_body,
        lst_details                    TYPE lty_body,
        lst_values                     TYPE lty_body,
        lv_stxbitmaps                  TYPE tdbtype,          " Graphic type
        l_graphic_xstr                 TYPE string,
        lv_cust_serv_rt                TYPE thead-tdname,     " SAPscript: Text Header:Name
        o_mr_api                       TYPE REF TO if_mr_api, " API for MIME Repository - Basic Functions
        is_folder                      TYPE boole_d,          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        l_img1                         TYPE xstring,
        l_img2                         TYPE xstring,
        l_loio                         TYPE skwf_io,          " KW Framework: Object Key
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
        lv_cust_serv                   TYPE thead-tdname, " Name
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
* Begin of change by SRBOSE: 29-June-2017: #TR: ED2K907341
        lv_std_name                    TYPE thead-tdname,            " Name
        li_constant                    TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0,
        li_table                       TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_table                      TYPE tline,                   " SAPscript: Text Lines
        lv_text                        TYPE string,
*       Begin of CHANGE:ERP-7206:WROY:21-Mar-2018:ED2K911516
*       lst_constant                   TYPE lty_constant,
        lst_constant                   TYPE ty_constant,
*       End   of CHANGE:ERP-7206:WROY:21-Mar-2018:ED2K911516
        lx_document_bcs                TYPE REF TO cx_document_bcs VALUE IS INITIAL, " BCS: Document Exceptions
* End of change by SRBOSE: 29-June-2017: #TR: ED2K907341
*******Added By SRBOSE
        lv_upd_tsk                     TYPE i,          " Upd_tsk of type Integers
        lv_lines                       TYPE adrs-anzzl. " Number of lines in address

********Local Constant Declaration
  CONSTANTS: lc_raw              TYPE so_obj_tp      VALUE 'RAW',                         "Code for document class
             lc_pdf              TYPE so_obj_tp      VALUE 'PDF',                         "Document Class for Attachment
             lc_png              TYPE so_obj_tp      VALUE 'png',                         "Document Class for Attachment
             lc_i                TYPE bapi_mtype     VALUE 'I',                           "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_s                TYPE bapi_mtype     VALUE 'S',                           " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_st               TYPE thead-tdid     VALUE 'ST',                          "Text ID of text to be read
             lc_tab              TYPE char1 VALUE cl_abap_char_utilities=>horizontal_tab, " Tab of type CHAR1
             lc_object           TYPE thead-tdobject VALUE 'TEXT',                        "Object of text to be read
             lc_langu            TYPE thead-tdspras  VALUE 'E',                           "Language of text to be read
             lc_name             TYPE thead-tdname   VALUE 'ZQTC_LETTER_BODY_F037',       "Name of text to be read
             lc_name_body        TYPE thead-tdname   VALUE 'ZQTC_F035_RENEWAL_BODY',      "Name of text to be read
             lc_name_body_m      TYPE thead-tdname   VALUE 'ZQTC_F035_RENEWAL_BODY_MEM',  "Name of text to be read
             lc_name_terms       TYPE thead-tdname   VALUE 'ZQTC_F035_TERMS',             "Name of text to be read
             lc_name_credit      TYPE thead-tdname   VALUE 'ZQTC_CREDIT_CARD_F035',       "Name of text to be read
             lc_name_id          TYPE thead-tdname   VALUE 'ZQTC_F035_ID',                "Name of text to be read
             lc_name_footer      TYPE thead-tdname   VALUE 'ZQTC_F035_FOOTER_1001_USD',   "Name of text to be read
             lc_name_remit       TYPE thead-tdname   VALUE 'ZQTC_F035_REMIT_TO_1001_USD', "Name of text to be read
             lc_name_details     TYPE thead-tdname   VALUE 'ZQTC_F035_BANK_DETAILS',      "Name of text to be read
             lc_name_view_pg     TYPE tdobname   VALUE 'ZQTC_F037_VIEW_PAGE',             " View Page
             lc_name_values      TYPE thead-tdname   VALUE 'ZQTC_F035_BANK_VALUES',       "Name of text to be read
             lc_name_donot_reply TYPE tdobname VALUE 'ZQTC_F037_DONOT_REPLY',             " Please do not reply
             lc_name_url         TYPE thead-tdname   VALUE 'ZQTC_F035_URL',               "Added by MODUTTA
             lc_tdobject         TYPE tdobjectgr VALUE 'GRAPHICS',                        " SAPscript Graphics Management: Application object
             lc_tdname           TYPE tdobname VALUE 'ZJWILEY_LOGO',                      " Name
             lc_tdid             TYPE tdidgr VALUE 'BMAP',                                "whatever is you image format according to se78
             lc_tdbtype          TYPE tdbtype VALUE 'BCOL',                               "for color image and 'BMON' for black and white image
* Begin of change by SRBOSE: 29-June-2017: #TR: ED2K907341
             lc_devid            TYPE zdevid         VALUE 'F035', " Development ID
             lc_url              TYPE rvari_vnam     VALUE 'URL',  " ABAP: Name of Variant Variable
             lc_srno_1           TYPE tvarv_numb     VALUE '1',    " ABAP: Current selection number
             lc_srno_2           TYPE tvarv_numb     VALUE '2',    " ABAP: Current selection number
             lc_srno_3           TYPE tvarv_numb     VALUE '3',    " ABAP: Current selection number
             lc_ed               TYPE char2          VALUE 'ED',   " Ed of type CHAR2
             lc_ep               TYPE char2          VALUE 'EP',   " Ep of type CHAR2
             lc_eq               TYPE char2          VALUE 'EQ',   " Eq of type CHAR2
             lc_dev              TYPE rvari_vnam     VALUE 'DEV',  " ABAP: Name of Variant Variable
             lc_qa               TYPE rvari_vnam     VALUE 'QA',   " ABAP: Name of Variant Variable
             lc_prod             TYPE rvari_vnam     VALUE 'PROD', " ABAP: Name of Variant Variable
* End of change by SRBOSE: 29-June-2017: #TR: ED2K907341
             lc_mailto           TYPE tdline VALUE 'mailto:'. " Text Line

  CLASS          cl_bcs DEFINITION LOAD. " Business Communication Service

  DATA lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL. " Business Communication Service

* Message body and subject
  DATA: li_body_em        TYPE STANDARD TABLE OF lty_body INITIAL SIZE 0,
        li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL. " Interface of Recipient Object in BCS
*        lr_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL.

  FIELD-SYMBOLS: <fst_body>  TYPE lty_body,
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
                 <fst_body1> TYPE lty_body.
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018

* BOC by LKODWANI on 21-Jul-2016 TR#ED2K907419
  DATA: lst_vbak           TYPE ty_vbak,
        lv_string          TYPE string,
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
        lv_string1         TYPE string,
        lv_cust_service    TYPE string, "Added by SAYANDAS on 04-Jun-2018 for CR# 6307
        lv_cust_website    TYPE string, "Added by MODUTTA on 07-Aug-2018 for CR# 6307 Defect
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
        lv_waerk           TYPE waerk,                   " SD Document Currency
        lv_bukrs           TYPE bukrs,                   " Company Code
        lv_count           TYPE numc4,                   " Count of type Integers
        lv_sl_count        TYPE numc4,                   " Count of type Integers
        lv_iden            TYPE char10,                  " Id of type CHAR6
        lv_acnt_num        TYPE char10,                  " Account number to remove leading zeros
        lv_file_name       TYPE localfile,               " Local file for upload/download
        ls_pdf_file        TYPE fpformoutput,            " Form Output (PDF, PDL)
        lv_date            TYPE syst_datum,              " ABAP System Field: Current Date of Application Server
        lv_amount          TYPE char24,                  " Amount of type CHAR24
        lv_deflt_comm      TYPE ad_comm,                 " Communication Method (Key) (Business Address Services)
        lv_txtmodule_data  TYPE string,
        lv_txtmodule_data1 TYPE string,
        li_cust_service    TYPE STANDARD TABLE OF tline. " SAPscript: Text Lines

  CONSTANTS: lc_sl             TYPE char2   VALUE 'SL',  " Rn of type CHAR2
             lc_sap            TYPE char3   VALUE 'SAP', " Sap of type CHAR3
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'. " Communication Method (Key) (Business Address Services)
* EOC by LKODWANI on 21-Jul-2016 TR#ED2K907419

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

  IF v_retcode = 0.
*****For Bill To Address
    CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
      EXPORTING
        address_type                   = '1'
        address_number                 = st_address-adrnr_bp
        sender_country                 = st_final-land1_bukrs
        number_of_lines                = 6
      IMPORTING
        address_printform              = lst_address_printform_table
      EXCEPTIONS
        address_blocked                = 1
        person_blocked                 = 2
        contact_person_blocked         = 3
        addr_to_be_formated_is_blocked = 4
        OTHERS                         = 5.
    IF sy-subrc EQ 0.
*    No action
    ENDIF. " IF sy-subrc EQ 0

*****For Ship To Address
    CLEAR lv_lines.
    CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
      EXPORTING
        address_type                   = '1'
        address_number                 = st_address-adrnr_we
        sender_country                 = st_final-land1_bukrs
        number_of_lines                = 6
      IMPORTING
        address_printform              = lst_address_printform_table_we
        number_of_used_lines           = lv_lines
      EXCEPTIONS
        address_blocked                = 1
        person_blocked                 = 2
        contact_person_blocked         = 3
        addr_to_be_formated_is_blocked = 4
        OTHERS                         = 5.
    IF sy-subrc EQ 0.
*    Do Nothing
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = st_vbco3-vbeln
                                  BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lv_waerk    = lst_vbak-waerk.
    ENDIF. " IF sy-subrc IS INITIAL

* Begin of Insert by PBANDLAPAL on 09-oct-2017

    CLEAR: li_lines2,
           lv_string.

    PERFORM read_text USING    lc_name_url
                      CHANGING li_lines2
                               lv_string.
*  v_description = st_vbap-arktx.
    v_description = st_final-arktx.
    v_link = lv_string.
* End of Insert by PBANDLAPAL on 09-oct-2017
    CALL FUNCTION 'ZQTC_NOTICE_F035'
      EXPORTING
        im_description = v_description
        im_value       = v_value
        im_link        = v_link.

* To get body of email
    CLEAR: li_lines2,
           lv_string.

    IF v_member  = abap_true.
* To get the  email subject for member maintained in the standard text.
      CLEAR:  lv_text,
              li_lines1[].
      PERFORM read_text USING c_mem_email_subj_stxt
                        CHANGING li_lines1
                                 lv_text.
      lv_subject     = lv_text.
*    lv_subject      = 'Your Wiley Membership Renewal'(008).
      PERFORM read_text USING    lc_name_body_m
                        CHANGING li_lines2
                                 lv_string.
    ELSEIF v_subscriber  = abap_true.
* To get the  email subject for subscriber maintained in the standard text.
      CLEAR:  lv_text,
              li_lines1[].
      PERFORM read_text USING c_sub_email_subj_stxt
                        CHANGING li_lines1
                                 lv_text.
      lv_subject     = lv_text.
*    lv_subject     = 'Your Wiley Early Bird Renewal Notice'(009).
      CLEAR li_lines2[].
      PERFORM read_text USING    lc_name_body
                        CHANGING li_lines2
                                 lv_string.
    ENDIF. " IF v_member = abap_true
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
    IF v_cust_serv_tbt IS NOT INITIAL.
      lv_cust_serv = v_cust_serv_tbt.
    ELSEIF v_cust_serv_scc IS NOT INITIAL.
      lv_cust_serv = v_cust_serv_scc.
    ELSEIF v_cust_serv_scm IS NOT INITIAL.
      lv_cust_serv = v_cust_serv_scc.
    ENDIF. " IF v_cust_serv_tbt IS NOT INITIAL

    CLEAR li_lines3[].
    PERFORM read_text USING lv_cust_serv
                      CHANGING li_lines3
                               lv_cust_service.
    LOOP AT li_lines3 INTO DATA(lst_lines_cust).
      IF sy-tabix = 3.
        CLEAR lv_cust_service.
        lv_cust_service = lst_lines_cust-tdline.
        CONTINUE.
      ENDIF. " IF sy-tabix = 3
      IF sy-tabix = 4.
        CONCATENATE lv_cust_service lst_lines_cust-tdline INTO lst_lines_cust-tdline SEPARATED BY space.
        CONDENSE lst_lines_cust-tdline.
      ENDIF. " IF sy-tabix = 4
      APPEND lst_lines_cust TO li_cust_service.
      CLEAR: lst_lines_cust,lv_cust_service.
    ENDLOOP. " LOOP AT li_lines3 INTO DATA(lst_lines_cust)

    IF li_lines2 IS NOT INITIAL.
      LOOP AT li_lines2 INTO lst_lines2.
        IF lst_lines2-tdformat = ''.
          CLEAR lst_body.
          DESCRIBE TABLE li_body_em LINES lv_lines2_em.
          READ TABLE li_body_em ASSIGNING <fst_body> INDEX lv_lines2_em.
          IF sy-subrc EQ 0 AND <fst_body> IS ASSIGNED.
            CONCATENATE <fst_body>-tdline lst_lines2-tdline INTO <fst_body>-tdline
                                              SEPARATED BY space.
          ENDIF. " IF sy-subrc EQ 0 AND <fst_body> IS ASSIGNED
        ELSE. " ELSE -> IF lst_lines2-tdformat = ''
          lst_body-tdline = lst_lines2-tdline.
          APPEND lst_body TO li_body_em.
        ENDIF. " IF lst_lines2-tdformat = ''
      ENDLOOP. " LOOP AT li_lines2 INTO lst_lines2
    ENDIF. " IF li_lines2 IS NOT INITIAL

* Begin of change by SRBOSE: 29-June-2017: #TR: ED2K907341
* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
*    SELECT
*    mandt            " Client
*    devid            " Development ID
*    param1           " ABAP: Name of Variant Variable
*    param2           " ABAP: Name of Variant Variable
*    srno             " ABAP: Current selection number
*    sign             " ABAP: ID: I/E (include/exclude values)
*    opti             " ABAP: Selection option (EQ/BT/CP/...)
*    low              " Lower Value of Selection Condition
*    high             " Upper Value of Selection Condition
*    activate         " Activation indicator for constant
*    description      " Description of constant
*    FROM zcaconstant " Wiley Application Constant Table
*    INTO TABLE li_constant
*    WHERE  devid EQ lc_devid
*    AND   param1 EQ lc_url.
*    IF sy-subrc IS INITIAL.
*      SORT li_constant BY devid
*                          param1
*                          param2
*                          srno.
*
*    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR: lst_constant,
           lv_std_name.
    IF sy-sysid+0(2) = lc_ed.
      READ TABLE i_constant INTO lst_constant WITH KEY devid = lc_devid
                                                        param1 = lc_url
                                                        param2 = lc_dev
                                                        srno  = lc_srno_1
                                                    BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_std_name = lst_constant-low.
      ENDIF. " IF sy-subrc IS INITIAL
    ELSEIF sy-sysid+0(2) = lc_eq.
      CLEAR: lst_constant,
             lv_std_name.
      READ TABLE i_constant INTO lst_constant WITH KEY devid = lc_devid
                                                      param1 = lc_url
                                                      param2 = lc_qa
                                                      srno  = lc_srno_2
                                                  BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_std_name = lst_constant-low.
      ENDIF. " IF sy-subrc IS INITIAL
    ELSEIF sy-sysid+0(2) = lc_ep.
      CLEAR: lst_constant,
             lv_std_name.
      READ TABLE i_constant INTO lst_constant WITH KEY devid = lc_devid
                                                      param1 = lc_url
                                                      param2 = lc_prod
                                                      srno  = lc_srno_3
                                                  BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_std_name = lst_constant-low.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-sysid+0(2) = lc_ed

* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241

* Begin of Change by PBANDLAPAL on 09-oct-2017
* To get the URL for the OLR.
    CLEAR: li_lines2,
          lv_text.

    PERFORM read_text  USING    lv_std_name
                       CHANGING li_lines2
                                lv_text.
    IF lv_text IS NOT INITIAL.
      CONCATENATE lv_text st_vbap-vbeln INTO lv_text.
    ENDIF. " IF lv_text IS NOT INITIAL
* End of Change by PBANDLAPAL on 09-oct-2017
* End of change by SRBOSE: 29-June-2017: #TR: ED2K907341

* Begin of Insert by PBANDLAPAL on 09-oct-2017
    CONCATENATE
    '<!DOCTYPE html>'
    ' <html> <head>'
    ' <meta charset="utf-8"> '
    '<style type="text/css"> '
      '*{ margin:0; padding:0;} html, body {height: 100%;}'
      'body{'
        'font-family:arial;'
        'font-size:14px;'
        'font-weight:normal;'
        'text-decoration:none;'
        'text-align:left;'
        'color:#000000;'
        'background:#ffffff;'
      '}'
        'img{'
      'border:none;'
      '}'
      '#wrapper{'
        'width:950px;'
        'min-height: 100%;'
        'height: auto !important;'
        'height: 100%;'
        'background:#ffffff;'
        'margin : 0 auto;'
      '}'

      '.logo{'
        'width:950px;'
        'margin:0;'
        'padding:20px 0;'
        'border-bottom:1px solid #ddd;'
      '}'
      '.logo img{'
        'position:relative;'
        'left:20px;'
        'width:180px;'
      '}'
      '.content{'
        'width:910px;'
        'margin:0;'
        'padding:0 20px;'
      '}'
       '.address{'
        'width:910px;'
        'margin:0;'
        'padding:0;'
      '}'
      '#emailparam{'
        'margin:5px 0;'
        'padding:0;'
* BOC by PBANDLAPAL on 18-Jan-2018 for ERP-5914: ED2K910360
*      'line-height:5px;'
        'line-height:15px;'
* EOC by PBANDLAPAL on 18-Jan-2018 for ERP-5914: ED2K910360
      '}'
      'table, td, th {'
        'border-collapse: collapse;'
        'border-width: 2px;'
        'border-color: #000000;'
        'border-spacing: initial;'
        'border-style: solid;'
*    'white-space: wrap;'
*    'word-break: break-all;'
        'overflow: visible;'
        'table-layout: auto'
      '}'
      '.alignleft {'
    'float: left;'
    'text-align: left;'
    'padding-right: 4px;'
  '}'
  '.alignright {'
   'float: right;'
   'text-align: right;'
   'padding-left: 4px;'
  '}'
      'td, th {'
        'padding: 4px;'
      '}'
        'td.narr {'
        'padding: 2px;'
      '}'

      '#row{'
        'background-color: #ffffff;'
        'border-width: 1px;'
        'border-color: #cccccc;'
        'border-style: solid;'
        'border-collapse: collapse;'
        'text-align: center;'
        'font-size: 14px;'
        'padding: 8px;'
      '}'
      '#rowleft{'
        'background-color: #ffffff;'
        'border-width: 0px;'
        'border-color: #cccccc;'
        'text-align: left;'
        'font-size: 14px;'
        'padding: 1px;'
      '}'
      'p.small {'
      'line-height: 5px;'
      '}'
      'p.line {'
      'line-height: 10px;'
      '}'
      'table.bdrless td{'
          'border-style: hidden;'
          'border-color: #ffffff;'
        'white-space: wrap;'
        'word-break: break-all;'
        'overflow: visible;'
        'table-layout: auto;'
*      'width: 100px; '

        '}'
        '.button {'
        'background-color: #FFC300;'
        'border-color: #FFC300;'
        'border-radius: 5px;'
        'text-align: center;'
        'padding: 10px;'
      '}'

      '.button a {'
        'color: #ffffff;'
        'display: block;'
        'font-size: 14px;'
        'text-decoration: none;'
        'text-transform: uppercase;'
      '}'
    '</style>'
      '</head>'
    '</table> '
    '<body>'
    '<div id="wrapper">'
  INTO html_string.

*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
*    LOOP AT li_cust_service INTO DATA(lst_cust_serv).
*      CONCATENATE html_string
*          '<p id="emailparam" >' lst_cust_serv-tdline
*        INTO html_string.
*    ENDLOOP. " LOOP AT li_cust_service INTO DATA(lst_cust_serv)
**BOC by MODUTTA on 07-Aug-2018 for CR# 6307 Defect
    LOOP AT li_cust_service INTO DATA(lst_cust_serv).
      IF lst_cust_serv-tdline CS ':'.
        SPLIT lst_cust_serv-tdline AT ':' INTO lv_cust_service lv_cust_website.
        CONCATENATE lc_mailto lv_cust_website INTO DATA(lv_hyperlink_website).
        CONCATENATE html_string
            '<p id="emailparam" >' lv_cust_service
            INTO html_string.
        CONCATENATE '<a href="' lv_hyperlink_website '">' lv_cust_website '</a>' '</p>'
          INTO lv_txtmodule_url.
        CONCATENATE html_string
                  lv_txtmodule_url
        INTO html_string
           SEPARATED BY ':'.
      ELSEIF lst_cust_serv-tdline CS '/'. " ELSE -> IF lst_cust_serv-tdline CS '/'
        SPLIT lst_cust_serv-tdline AT space INTO TABLE DATA(li_website).
        LOOP AT li_website INTO DATA(lv_website).
          CLEAR : lv_txtmodule_url,lv_cust_service.
          IF lv_website CS '/'.
            CONCATENATE '<a href="' lv_website '">' lv_website '</a>'
            INTO lv_txtmodule_url.
            CONCATENATE html_string
                  lv_txtmodule_url
           INTO html_string
           SEPARATED BY space.
          ELSE. " ELSE -> IF lv_website CS '/'
            CONCATENATE html_string
              lv_website INTO html_string SEPARATED BY space.
          ENDIF. " IF lv_website CS '/'
        ENDLOOP. " LOOP AT li_website INTO DATA(lv_website)
      ELSE. " ELSE -> IF lst_cust_serv-tdline CS ':'
        CONCATENATE html_string
            '<p id="emailparam" >' lst_cust_serv-tdline
            INTO html_string SEPARATED BY space.
      ENDIF. " IF lst_cust_serv-tdline CS ':'
    ENDLOOP. " LOOP AT li_cust_service INTO DATA(lst_cust_serv)
**EOC by MODUTTA on 07-Aug-2018 for CR# 6307 Defect
    CONCATENATE html_string
      '<br> </br>'
      INTO html_string.
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
    LOOP AT li_body_em INTO lst_body.
* This line to include html tags for material description to display in bold.
      REPLACE ALL OCCURRENCES OF '&V_DESCRIPTION&' IN lst_body-tdline WITH c_char_matdesc_b.
      REPLACE ALL OCCURRENCES OF '&V_DESCRIPTION&' IN lst_body-tdline WITH st_final-arktx.

* This line to include html tags for discount to display in bold.
      REPLACE ALL OCCURRENCES OF '&V_VALUE&' IN lst_body-tdline WITH c_char_disc_b.
      REPLACE ALL OCCURRENCES OF '&V_VALUE&' IN lst_body-tdline WITH v_value.

* This line to include html tags for link to display in bold.
      REPLACE  ALL OCCURRENCES OF '&V_LINK&' IN lst_body-tdline WITH c_char_link_b.
      REPLACE  ALL OCCURRENCES OF '&V_LINK&' IN lst_body-tdline WITH v_link.

      CONCATENATE html_string
  '<p id="emailparam">' lst_body-tdline  '</p>'
          INTO html_string.
    ENDLOOP. " LOOP AT li_body_em INTO lst_body

*   To get Sub Total text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_subtotal_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
      '<table class="bdrless">'
      '<tr>'
        '<td class="alignleft">     <p><b> ' lv_txtmodule_data ' </b></p>   </td>'
        '<td class="alignleft">     <p>  </p>   </td>'
        '<td class="alignright">     <p><b> ' st_final-sub_total ' </b></p>   </td>'
        '</tr>' INTO html_string.

*   To get Discount text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_discount_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
      '<tr>'
        '<td class="alignleft">     <p><b> ' lv_txtmodule_data ' </b></p>   </td>'
        '<td class="alignleft">     <p>  </p>   </td>'
        '<td class="alignright">     <p><b> ' st_final-discount ' </b></p>   </td>'
        '</tr>' INTO html_string.

* BOC by PBANDLAPAL on 20-Feb-2018 for CR#743: ED2K910989
*  CONCATENATE html_string
*    '<tr>'
*      '<td class="alignleft">     <p><b> ' st_final-print_tax_prcnt ':' ' </b></p>   </td>'
*      '<td class="alignleft">     <p>  </p>   </td>'
*      '<td class="alignright">     <p><b> ' st_final-print_tax_amount ' </b></p>   </td>'
*      '</tr>'  INTO html_string.
*
**  IF st_header-digi_tax_amount IS NOT INITIAL.
*  CONCATENATE html_string
*    '<tr>'
*      '<td class="alignleft">     <p><b> ' st_final-digi_tax_prcnt ':' ' </b></p>   </td>'
*      '<td class="alignleft">     <p>  </p>   </td>'
*      '<td class="alignright">     <p><b> ' st_final-digi_tax_amount ' </b></p>   </td>'
*      '</tr>' INTO html_string.
    LOOP AT i_tax_tab INTO lst_tax_tab.
      CONCATENATE html_string
      '<tr>'
        '<td class="alignleft">     <p><b> ' lst_tax_tab-zzdesc  ' </b></p>   </td>'
        '<td class="alignleft">     <p>  </p>   </td>'
        '<td class="alignright">     <p><b> ' lst_tax_tab-zztax_dtls ' </b></p>   </td>'
        '</tr>'  INTO html_string.
    ENDLOOP. " LOOP AT i_tax_tab INTO lst_tax_tab
* EOC by PBANDLAPAL on 20-Feb-2018 for CR#743: ED2K910989

*   To get Total Due text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_total_due_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
      '<tr>'
        '<td class="alignleft">     <p><b> ' lv_txtmodule_data ' </b></p>   </td>'
        '<td class="alignleft">     <p><b> ' st_final-currency ' </b></p>   </td>'
        '<td class="alignright">     <p><b> ' st_final-total_due ' </b></p>   </td>'
        '</tr>' INTO html_string.

*   To get Renew now text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_renew_now_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
     '</table>'
     '<div class="content">'
     '<div align="left">'
     '<table>'
         '<tr>'
             '<td class="button">'
              '<a href="' lv_text '">' lv_txtmodule_data '</a>'
             '</td>'
         '</tr>'
     '</table>'
     '</div>'
     INTO html_string.

* To Get "Title" text module
    CLEAR lv_txtmodule_data.
*    PERFORM read_text_module USING c_title_tm
*                             CHANGING lv_txtmodule_data.
*    Commented above code since Title needs to be replaced with
*    Journal Code/Description
**      Journal/Description Text
    PERFORM read_text_module USING c_journal_txt
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
*   '<p id="emailparam" >' lv_txtmodule_data  '<b>' v_matnr_desc ' </b> </p> '
    '<p id="emailparam" >' '<b>' v_matnr_desc ' </b> </p> '
                     INTO html_string.

* Member Scenario
    IF v_member = abap_true.
* Membership Type
*      CONCATENATE html_string
*      '<p id="emailparam" >' st_final-member_txt '<b>' st_final-member_value ' </b> </p> '
*                       INTO html_string.
* BOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
      CLEAR: li_lines2,
              lv_string.
* To Get the Contract start date "To get Year Standard Text "CR-7841:SGUDA:30-Apr-2019:ED1K910099
      PERFORM read_text USING    c_stxt_strt_year "c_stxt_year "CR-7841:SGUDA:30-Apr-2019:ED1K910099
                        CHANGING li_lines2
                                 lv_string.
* Contract Start Date "Year ""CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'  v_year ' </b> </p> '
                        INTO html_string.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CLEAR: li_lines1,lv_string.
* To get contract end date Standard Text
      PERFORM read_text USING    c_stxt_end_year
                        CHANGING li_lines2
                                 lv_string.
* Contract End Date
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'  v_cntr_end ' </b> </p> '
                        INTO html_string.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CLEAR: li_lines2,
              lv_string.
* To get Volume Standard Text
      PERFORM read_text USING    c_stxt_volume
                        CHANGING li_lines2
                                 lv_string.
* Volume
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'   v_issue_desc  ' </b> </p> '
                        INTO html_string.

* To Get "Start Issue" text module
      CLEAR lv_txtmodule_data.
      PERFORM read_text_module USING c_start_issue_tm
                               CHANGING lv_txtmodule_data.

      CONCATENATE html_string
      '<p id="emailparam" >' lv_txtmodule_data  '<b>'
        v_start_issue ' </b> ' INTO html_string.
* EOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033

* Membership Reference
      CONCATENATE html_string
      '<p id="emailparam" >' st_final-sub_ref_txt '<b>' st_final-sub_reference ' </b> </p> '
                       INTO html_string.

** To Get "Current Membership Expiration" text Module.
      CLEAR lv_txtmodule_data.
      PERFORM read_text_module USING c_cur_memb_exp_tm
                               CHANGING lv_txtmodule_data.
      CONCATENATE html_string
      '<p id="emailparam" >' lv_txtmodule_data   ' '
      '<b>' v_mbexp_date  '</b>' '</p> ' INTO html_string.

* Subscriber Scenario
    ELSEIF v_subscriber = abap_true.
* Subscription Type
*   To get media type text
      CLEAR: li_lines2,
             lv_string.
      PERFORM read_text USING    c_media_type
                          CHANGING li_lines2
                                   lv_string.
*      CONCATENATE html_string
*      '<p id="emailparam" >' st_final-subs_txt '<b>' st_final-subs_value ' </b> </p> '
*                       INTO html_string.
      CONCATENATE html_string
        '<p id="emailparam" >' lv_string '<b>' st_final-subs_value ' </b> </p> '
                         INTO html_string.
* BOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
      CLEAR: li_lines2,
             lv_string.
* To Get the Contract start date "To get Year Standard Text "CR-7841:SGUDA:30-Apr-2019:ED1K910099
      PERFORM read_text USING    c_stxt_strt_year "c_stxt_year "CR-7841:SGUDA:30-Apr-2019:ED1K910099
                        CHANGING li_lines2
                                 lv_string.
* Contract Start date "Year ""CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'  v_year ' </b> </p> '
                        INTO html_string.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CLEAR: li_lines1,lv_string.
* To get contract end date Standard Text
      PERFORM read_text USING    c_stxt_end_year
                        CHANGING li_lines2
                                 lv_string.
* Contract End Date
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'  v_cntr_end ' </b> </p> '
                        INTO html_string.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
      CLEAR: li_lines2,
              lv_string.
* To get Volume Standard Text
      PERFORM read_text USING    c_stxt_volume
                        CHANGING li_lines2
                                 lv_string.
* Volume
      CONCATENATE html_string
       '<p id="emailparam" >' lv_string '<b>'   v_issue_desc  ' </b> </p> '
                        INTO html_string.

* To Get "Start Issue" text module
      CLEAR lv_txtmodule_data.
      PERFORM read_text_module USING c_start_issue_tm
                               CHANGING lv_txtmodule_data.

      CONCATENATE html_string
      '<p id="emailparam" >' lv_txtmodule_data  '<b>'
        v_start_issue ' </b> ' INTO html_string.
* EOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033

* Subscription Reference
      CONCATENATE html_string
      '<p id="emailparam" >' st_final-sub_ref_txt '<b>' st_final-sub_reference ' </b> </p> '
                       INTO html_string.

** To Get "Current Subscription Expiration" text Module.
      CLEAR lv_txtmodule_data.
      PERFORM read_text_module USING c_cur_subs_exp_tm
                               CHANGING lv_txtmodule_data.
      CONCATENATE html_string
      '<p id="emailparam" >' lv_txtmodule_data   ' '
      '<b>' v_mbexp_date  '</b>' '</p> ' INTO html_string.
    ENDIF. " IF v_member = abap_true

** To Get "Account Number" text Module.
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_account_num_tm
                             CHANGING lv_txtmodule_data.

    lv_acnt_num = st_address-kunnr_bp.
    SHIFT lv_acnt_num LEFT DELETING LEADING c_zero.
    CONCATENATE html_string
    '<p id="emailparam" >' lv_txtmodule_data   ' '
    '<b>' lv_acnt_num  '</b>' '</p> ' INTO html_string.

** To Get "Renewal Number" text Module.
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_renewal_num_tm
                             CHANGING lv_txtmodule_data.
    CONCATENATE html_string
    '<p id="emailparam" >' lv_txtmodule_data   ' '
    '<b>' st_vbco3-vbeln  '</b>' '</p> ' INTO html_string.

*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
*** Journal Code
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_journal_tm
                             CHANGING lv_txtmodule_data.
    CONCATENATE html_string
    '<p id="emailparam" >' lv_txtmodule_data   ' '
    '<b>' v_matnr_desc  '</b>' '</p> ' INTO html_string.

*** ISSN
*    CLEAR lv_txtmodule_data.
*    PERFORM read_text_module USING c_issn_tm
*                             CHANGING lv_txtmodule_data.
    CONCATENATE html_string
    '<p id="emailparam" >' st_final-issn1_text   ' '
    '<b>' st_final-issn1_value  '</b>' '</p> ' INTO html_string.
*    '<b>' v_issn  '</b>' '</p> ' INTO html_string.
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018

    CONCATENATE html_string
    '<p id="emailparam" >' st_final-issn2_text   ' '
    '<b>' st_final-issn2_value  '</b>' '</p> ' INTO html_string.

** To get the text for "If you are not able to view this page ....."
    CLEAR li_lines2.
    PERFORM read_text USING lc_name_view_pg
                      CHANGING li_lines2
                               lv_view_page_txt.

** To Get "Click here" text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_click_here_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
    '<p id="emailparam" > ' lv_view_page_txt
    INTO html_string.
    CONCATENATE '<style="text-indent: 5em;">'
    '<a href="' lv_text '">'  lv_txtmodule_data  '</a>' '</p>'
    INTO lv_txtmodule_url.
    CONCATENATE html_string
                lv_txtmodule_url
    INTO html_string
    SEPARATED BY space.

** To get the text for "** Please do not reply to this email **"
    CLEAR li_lines2.
    PERFORM read_text USING lc_name_donot_reply
                      CHANGING li_lines2
                               lv_donot_reply_txt.
    CONCATENATE html_string
    '<p id="emailparam" >  <th>' lv_donot_reply_txt ' </th> </p> ' INTO html_string.

* To Get Bill to text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_bill_to_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
    '<table class="bdrless">'
      '<tr id="rowleft">'
        '<td class="narr">     <p class=”small”> <b> ' lv_txtmodule_data ' </b></p>   </td>'
        '<td class="narr">    <p class=”small”> </p>   </td>'
        '<td class="narr">    <p class=”small”> </p>   </td>'
       '<td class="narr">    <p class=”small”> </p>   </td>'
        '<td class="narr">    <p class=”small”></p>   </td>' INTO html_string.

* To Get Ship to text module
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_ship_to_tm
                             CHANGING lv_txtmodule_data.

    CONCATENATE html_string
     '<td>     <p><b>' lv_txtmodule_data '</b></p>    </td>'
   '</tr>'
   '<tr id="rowleft">'
     '<td>     <p>' lst_address_printform_table-line0' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line0'</p>    </td>'
   '</tr>'
     '<tr id="rowleft">'
     '<td>     <p class=”small”>' lst_address_printform_table-line1' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line1'</p>    </td>'
   '</tr>'
     '<tr id="rowleft">'
     '<td>     <p class=”small”>' lst_address_printform_table-line2' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line2'</p>    </td>'
   '</tr>'
     '<tr id="rowleft">'
     '<td>     <p class=”small”>' lst_address_printform_table-line3' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line3'</p>    </td>'
   '</tr>'
     '<tr id="rowleft">'
     '<td>     <p class=”small”>' lst_address_printform_table-line4' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line4'</p>    </td>'
   '</tr>'
     '<tr id="rowleft">'
     '<td>     <p class=”small”>' lst_address_printform_table-line5' </p>    </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
     '<td class="narr">      <p class=”small”></p>   </td>'
    '<td class="narr">    <p class=”small”></p>   </td>'
     '<td class="narr">    <p class=”small”></p>   </td>'
     '<td>     <p class=”small”>' lst_address_printform_table_we-line5'</p>    </td>'
   '</tr>'
  '</table>'

  '<p id="emailparam" >---------------------------------------------------------------------------------------------------</p>'
   '<img src="cid:Wiley_Logo.png">'
   '</TABLE>'
  '</div>'
   '</div>'
  '</body>'
  '</html>'
   INTO html_string.

* End of Insert by PBANDLAPAL on 09-oct-2017
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = html_string
      IMPORTING
        buffer = xhtml_string
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = xhtml_string
        TABLES
          binary_tab = t_hex.
    ENDIF. " IF sy-subrc IS INITIAL

    TRY.
        lr_document = cl_document_bcs=>create_document(
         i_type = 'HTM'
         i_hex    = t_hex
*       i_text    = lt_it_objtext
*       i_subject = 'Early Bird Renewal Notice'(007) )
          i_subject = lv_subject ).
    ENDTRY.

*** BOC by PBANDLAPAL on 21-Aug-2017
    IF o_mr_api IS INITIAL.
      o_mr_api = cl_mime_repository_api=>if_mr_api~get_api( ).
    ENDIF. " IF o_mr_api IS INITIAL

    CALL METHOD o_mr_api->get
      EXPORTING
        i_url              = '/SAP/PUBLIC/Wiley_Logo.png'
      IMPORTING
        e_is_folder        = is_folder
        e_content          = l_img1
        e_loio             = l_loio
      EXCEPTIONS
        parameter_missing  = 1
        error_occured      = 2
        not_found          = 3
        permission_failure = 4
        OTHERS             = 5.

    CLEAR : lt_hex1, lt_hex2, ls_hex, lv_img1_size, lv_img2_size.

    WHILE l_img1 IS NOT INITIAL.
      ls_hex-line = l_img1.
      APPEND ls_hex TO lt_hex1.
      SHIFT l_img1 LEFT BY 255 PLACES IN BYTE MODE.
    ENDWHILE.

*Findthe Size of the image
    DESCRIBE TABLE lt_hex1 LINES lv_img1_size.
    lv_img1_size = lv_img1_size * 255.
*--------------------------------------------------------------------*
*Attach Images
*--------------------------------------------------------------------*
    lr_document->add_attachment(
      EXPORTING
        i_attachment_type     =  lc_png            " Document Class for Attachment
        i_attachment_subject  =  'Wiley_Logo'(010) " Attachment Title
        i_attachment_size     =  lv_img1_size      " Size of Document Content
        i_att_content_hex     =  lt_hex1           " Content (Binary)
    ).

*********************************************************************
* Begin of Changes by PBANDLAPAL on 12-Oct-2017
    LOOP AT fp_li_output INTO DATA(lst_output).

*    lst_output-attachment_name =  text-007.
      lv_document_no = st_vbap-vbeln.
      CALL FUNCTION 'ZQTC_OUTPUT_SUPP_SAVE_OR_SEND'
        EXPORTING
*         im_save_file       = abap_true
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

      IF li_email_data IS NOT INITIAL
        AND v_send_email IS NOT INITIAL.
*         AND lv_flag IS NOT INITIAL.
*        Send email with the attachments we are getting from FM
        TRY.
            lr_document->add_attachment(
            EXPORTING
            i_attachment_type = c_attachtyp_pdf "'PDF'
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
      ENDIF. " IF li_email_data IS NOT INITIAL
    ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
* End of Changes by PBANDLAPAL on 12-Oct-2017
**********************************************************************


    IF v_send_email IS NOT INITIAL.
* Pass the document to send request
      TRY.
          lr_send_request->set_document( lr_document ).

* Create sender
          lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
          lr_send_request->set_sender(
*        lo_bcs->set_sender(
          EXPORTING
          i_sender = lr_sender ).
        CATCH cx_address_bcs.
        CATCH cx_send_req_bcs.
      ENDTRY.

* Create recipient
      TRY.
          lr_recipient = cl_cam_address_bcs=>create_internet_address( v_send_email ).

** Set recipient
          lr_send_request->add_recipient(
*        lo_bcs->add_recipient(
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

*****Added By SRBOSE
          CALL METHOD cl_system_transaction_state=>get_in_update_task
            RECEIVING
              in_update_task = lv_upd_tsk.
          IF lv_upd_tsk EQ 0.
            COMMIT WORK.
          ENDIF. " IF lv_upd_tsk EQ 0
******Added By SRBOSE
          IF lv_sent_to_all = abap_true.
            MESSAGE text-004  TYPE lc_s. "'I'.
          ENDIF. " IF lv_sent_to_all = abap_true
        CATCH cx_send_req_bcs.
      ENDTRY.
    ENDIF. " IF v_send_email IS NOT INITIAL
  ENDIF. " IF v_retcode = 0

ENDFORM. " MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       Perform is used to send mail with an attachment of PDF
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail.

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

  IF v_ent_screen = abap_true.
    SELECT SINGLE b~smtp_addr
           INTO v_send_email
           FROM usr21 AS a INNER JOIN adr6 AS b ON
           a~addrnumber = b~addrnumber AND
           a~persnumber = b~persnumber
           WHERE bname = sy-uname.
    IF sy-subrc NE 0.
      v_retcode = 900. RETURN.
* Email ID is not maintained in the user profile
      MESSAGE e244(zqtc_r2). " Email ID is not maintained in the user profile
    ENDIF. " IF sy-subrc NE 0
  ELSE. " ELSE -> IF v_ent_screen = abap_true
*******Get email id from ADR6 table
    SELECT smtp_addr "E-Mail Address
      FROM adr6      "E-Mail Addresses (Business Address Services)
      INTO v_send_email
      UP TO 1 ROWS
*      WHERE addrnumber EQ st_address-adrnr_we. "commented as part of RITM0075120, rkumar2 ED1K908758
      WHERE addrnumber EQ st_address-adrnr_bp. "logic added as part of RITM0075120, rkumar2 ED1K908758
    ENDSELECT.
    IF sy-subrc NE 0.
* Begin of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*        MESSAGE i243(zqtc_r2). " Email ID is not maintained for Ship to Customer
* End of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
      MESSAGE i556(zqtc_r2). " Email ID is not maintained for Bill to party
* End of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb = syst-msgid
          msg_nr    = syst-msgno
          msg_ty    = c_msgtyp_err
          msg_v1    = syst-msgv1
          msg_v2    = syst-msgv2
        EXCEPTIONS
          OTHERS    = 0.
      IF sy-subrc EQ 0.
        v_retcode = 900. RETURN.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF v_ent_screen = abap_true

  IF v_retcode = 0.
    lv_form_name = tnapr-sform.

    IF NOT v_ent_screen IS INITIAL.
      lst_sfpoutputparams-nopributt = abap_true.
      lst_sfpoutputparams-noarchive = abap_true.
    ENDIF. " IF NOT v_ent_screen IS INITIAL

**********BOC by MODUTTA on 20/07/2017 for archive****************************
    lst_sfpoutputparams-getpdf    = abap_false.
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
    lst_sfpdocparams-langu     = nast-spras.

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
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*    MESSAGE e071(zqtc_r2). "Error in form display
      CLEAR v_msg_txt.
      MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_form_name "lc_form_name
            IMPORTING
              e_funcname = lv_funcname.

        CATCH cx_fp_api_usage INTO lr_err_usg.
          lr_text = lr_err_usg->get_text( ).
          MESSAGE i086(zqtc_r2) WITH lr_text. " An exception occurred  ##MG_MISSING
*        LEAVE LIST-PROCESSING.
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
        CATCH cx_fp_api_repository INTO lr_err_rep.
          lr_text = lr_err_rep->get_text( ).
          MESSAGE i086(zqtc_r2) WITH lr_text. " An exception occurred
*        LEAVE LIST-PROCESSING.
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
        CATCH cx_fp_api_internal INTO lr_err_int.
          lr_text = lr_err_int->get_text( ).
          MESSAGE i086(zqtc_r2) WITH lr_text. " An exception occurred
*        LEAVE LIST-PROCESSING.
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
      ENDTRY.

      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000066'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_xstring         = v_xstring
          im_address         = st_address
          im_vbco3           = st_vbco3
          im_society_logo    = v_society_logo
          im_final           = st_final
          im_vbap            = vbap
          im_footer          = v_footer
          im_body            = i_body
          im_remit_to        = v_remit_to
          im_renewal_text    = v_renewal_text
          im_body1           = v_body
          im_remit_to_tbt    = v_remit_to_tbt
          im_remit_to_scc    = v_remit_to_scc
          im_remit_to_scm    = v_remit_to_scm
          im_credit_scm      = v_credit_scm
          im_credit_tbt      = v_credit_tbt
          im_credit_scc      = v_credit_scc
          im_email_tbt       = v_email_tbt
          im_email_scc       = v_email_scc
          im_email_scm       = v_email_scm
          im_banking1_scm    = v_banking1_scm
          im_banking1_scc    = v_banking1_scc
          im_banking1_tbt    = v_banking1_tbt
          im_banking2_scc    = v_banking2_scc
          im_banking2_scm    = v_banking2_scm
          im_banking2_tbt    = v_banking2_tbt
          im_cust_serv_tbt   = v_cust_serv_tbt
          im_cust_serv_scc   = v_cust_serv_scc
          im_cust_serv_scm   = v_cust_serv_scm
          im_footer_scm      = v_footer_scm
          im_footer_scc      = v_footer_scc
          im_footer_tbt      = v_footer_tbt
          im_v_seller_reg    = v_seller_reg
          im_v_barcode       = v_barcode
          im_company_name    = v_compname
          im_tax_tab         = i_tax_tab
          im_arktx           = i_arktx
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
          im_year            = v_year
          im_cntr_end        = v_cntr_end "CR-7841:SGUDA:30-Apr-2019:ED1K910099
          im_issue_desc      = v_issue_desc
          im_start_issue     = v_start_issue
*** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
          im_issn            = v_issn
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
*** Begin of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
          im_v_buyer_reg     = v_buyer_reg
*** End of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.

      IF sy-subrc <> 0.
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*      MESSAGE e071(zqtc_r2). "Error in form display
        CLEAR v_msg_txt.
        MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341

      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*        MESSAGE e071(zqtc_r2). "Error in form display
          CLEAR v_msg_txt.
          MESSAGE e071(zqtc_r2) INTO v_msg_txt. "Error in form display
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
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF v_retcode = 0

  IF v_retcode = 0.
**********BOC by MODUTTA on 20/07/2017 for archive****************************
*  post form processing
*   Begin of DEL:ERP-7340:WROY:30-Mar-2018:ED2K911708
*   IF lst_sfpoutputparams-arcmode <> '1' AND
*      nast-nacha NE '1' AND           "Print output
*      v_comm_method NE c_comm_method. "Letter.
*   End   of DEL:ERP-7340:WROY:30-Mar-2018:ED2K911708
*   Begin of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911708
    IF lst_sfpoutputparams-arcmode <> '1' AND
       v_ent_screen IS INITIAL.
*   End   of ADD:ERP-7340:WROY:30-Mar-2018:ED2K911708
      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = 'PDF' "  class
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
*       Check if the subroutine is called in update task.
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
*       COMMINT only if the subroutine is not called in update task
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF lst_sfpoutputparams-arcmode <> '1' AND
**********EOC by MODUTTA on 20/07/2017 for archive****************************
********Perform is used to convert PDF in to Binary
*  PERFORM f_convert_pdf_binary.
********Perform is used to call E098 FM  & convert PDF in to Binary
    PERFORM f_call_fm_output_supp CHANGING li_output.

********Perform is used to create mail attachment with a creation of mail body
    PERFORM f_mail_attachment USING li_output.
  ENDIF. " IF v_retcode = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBAP  text
*      <--P_ST_FINAL  text
*----------------------------------------------------------------------*
FORM f_populate_data  USING    fp_st_vbap TYPE ty_vbap
                      CHANGING fp_st_final TYPE zstqtc_head_f035. " Structure for header data of F035.

*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char2,    " Low of type CHAR2
           high   TYPE char2,    " High of type CHAR2
         END OF lty_range.

******Local Data Declaration
  DATA: lv_day             TYPE char2,                   " Date of type CHAR2
        lv_month_c2        TYPE char2,                   " Mnthc2 of type CHAR2
        lv_month_c3        TYPE char3,                   " Mnthc3 of type CHAR3
        lv_month           TYPE t247-ltx,                " Month long text
        lv_datum           TYPE char15,                  " renewal date of char 15
        lv_year            TYPE char4,                   " Year of type CHAR4
        lst_vbak           TYPE ty_vbak,                 " Local workarea for vbak table
        lv_kzwi5           TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
        lv_kzwi6           TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lv_kzwi1           TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
        lv_text            TYPE string,
        lst_line           TYPE tline,                   " SAPscript: Text Lines
        lv_disc_char       TYPE char20,                  " Disc_char of type CHAR20
        lv_disc            TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
        lv_percentage_c    TYPE char5,                   " Percentage of type CHAR5
        lv_percentage      TYPE p,                       " Percentage of type Packed
        lv_total           TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lv_issues          TYPE i,                       " No. of Issues.
        lv_waerk           TYPE waerk,                   " SD Document Currency
        li_lines           TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines          TYPE tline,                   " Lines of text read
        lst_vbfa           TYPE ty_vbfa,
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
*        lv_issue_desc      TYPE tdline, " Text Line
        lv_issue_str       TYPE string,
        lv_issue           TYPE char30, " Issue of type CHAR30
        lv_vol_des         TYPE char30, " Vol_des of type CHAR30
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
* Begin of change: PBANDLAPAL: 06-SEP-2017: ERP-4086 : ED2K908397
        lv_tax             TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
        lst_konv           TYPE ty_konv,
        lst_mara           TYPE ty_mara,
        lst_vbap           TYPE ty_vbap,
        lv_tax_text        TYPE string,
        lv_comp_tax        TYPE string,
        lst_vbap_tmp       TYPE ty_vbap,
        lst_tax_dtls       TYPE ty_tax_dtls,
        li_vbap_hcomp      TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
        lv_kbetr_desc      TYPE p DECIMALS 3, " Rate (condition amount or percentage)
        lv_kbetr_char      TYPE char15,       " Kbetr_char of type CHAR15
        lv_konv_index      TYPE syst_tabix,   " ABAP System Field: Row Index of Internal Tables
        lv_itmcomp_indx    TYPE syst_tabix,   " ABAP System Field: Row Index of Internal Tables
        lst_vbap_itmcmp    TYPE ty_vbap,
        lv_txtmodule_data  TYPE string,       " Text Line
        lv_vol_issues_txt  TYPE string,
* End of change: PBANDLAPAL: 06-SEP-2017: ERP-4086 : ED2K908397
        lst_komv           TYPE ty_konv,
        lv_kawrt           TYPE kawrt,                           " Condition base value
        lst_renwl_plan     TYPE ty_renwl_plan,                   " Local workarea of type ty_renwl_plan
        li_renwl_plan      TYPE STANDARD TABLE OF ty_renwl_plan, " Local workarea of type ty_renwl_plan
        li_range           TYPE STANDARD TABLE OF lty_range,
        lst_range          TYPE lty_range,
        lv_tax_amount      TYPE p DECIMALS 3,                    " Tax_amount of type Packed Number
        lv_taxable_amt     TYPE kzwi1,                           " Subtotal 1 from pricing procedure for condition
        lv_kbetr           TYPE kbetr,                           " Rate (condition amount or percentage)
        lst_tax_item       TYPE ty_tax_dtls,
        li_tax_item        TYPE STANDARD TABLE OF ty_tax_dtls,
        lst_tax_tab        TYPE zstqtc_tax_f035,                 " Amount and Tax Details display in F032
        lv_taxable_char    TYPE char100,                         " Taxable_char of type CHAR100
        lv_tabix_hcomp     TYPE i,                               " Tabix_hcomp of
        lv_multi_bom_flg   TYPE xfeld,                           " Checkbox
        lv_tax_amount_char TYPE char100,                         " Tax_amount_char of type CHAR100
        lv_matnr           TYPE matnr,                           " Material Number
        lv_name_issn       TYPE tdobname,                        " Name
        lv_pnt_issn        TYPE string,
        li_dummy           TYPE STANDARD TABLE OF tline.         " Itab: Dummy -- ADD for CR#7730 KKRAVURI20181012  ED2K913576

  CONSTANTS: lc_hyphen     TYPE char01         VALUE '-',                      "Constant for hyphen
             lc_g          TYPE vbtyp          VALUE 'G',                      "Local constant for vbtyp field of vbak table when it is 'G'
             lc_r          TYPE char2          VALUE 'R*',                     " R of type CHAR2
             lc_bb         TYPE char1          VALUE ')',                      " Bb of type CHAR1
             lc_percent    TYPE char1          VALUE '%',                      " Percent of type CHAR1
             lc_name       TYPE thead-tdname   VALUE 'ZQTC_F035_RENEWAL_TEXT', "Name of text to be read
             lc_status     TYPE zact_status    VALUE 'X',                      "Activity Status
             lc_name_body  TYPE thead-tdname   VALUE 'ZQTC_F035_RENEWAL_BODY', "Name of text to be read
             lc_sign       TYPE ddsign         VALUE 'I',                      " Type of SIGN component in row type of a Ranges type
             lc_option     TYPE ddoption       VALUE 'CP',                     " Type of OPTION component in row type of a Ranges type
             lc_minus      TYPE char1          VALUE '-',                      " B of type CHAR1
             lc_undscr     TYPE char1          VALUE '_',                      " Undscr of type CHAR1
             lc_vat        TYPE char3          VALUE 'VAT',                    " Vat of type CHAR3
             lc_tax        TYPE char3          VALUE 'TAX',                    " Tax of type CHAR3
             lc_gst        TYPE char3          VALUE 'GST',                    " Gst of type CHAR3
             lc_class      TYPE char5          VALUE 'ZQTC_',                  " Class of type CHAR5
             lc_devid      TYPE char5          VALUE '_F037',                  " Devid of type CHAR5
             lc_colon      TYPE char1          VALUE ':',                      " Colon of type CHAR1
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
             lc_issue      TYPE thead-tdname   VALUE 'ZQTC_ISSUE_F042', " Name
             lc_comma      TYPE char1          VALUE ',',               " Comma of type CHAR1
*** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue
* BOC by PBANDLAPAL on 29-Nov-2017 ERP-5303
             lc_sign_ex    TYPE ddsign         VALUE 'E',  " Type of SIGN component in row type of a Ranges type
             lc_option_eq  TYPE ddoption       VALUE 'EQ', " Type of OPTION component in row type of a Ranges type
             lc_actvity_rn TYPE char2          VALUE 'RN', " Actvity_rn of type CHAR2
* EOC by PBANDLAPAL on 29-Nov-2017 ERP-5303
             lc_percentage TYPE char1         VALUE '%',                      " Percentage of type CHAR1
             lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',    " Name
             lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
             lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042'. " Name

*** Populate local range table
  lst_range-sign   = lc_sign.
  lst_range-option = lc_option.
  lst_range-low    = lc_r.
  APPEND lst_range TO li_range.
* BOC by PBANDLAPAL on 29-Nov-2017 ERP-5303
* Need to exclude the RN activity as Reminder is not needed for this.
  CLEAR lst_range.
  lst_range-sign   = lc_sign_ex.
  lst_range-option = lc_option_eq.
  lst_range-low    = lc_actvity_rn.
  APPEND lst_range TO li_range.
* EOC by PBANDLAPAL on 29-Nov-2017 ERP-5303
*******Fetch Data from ZQTC_RENWL_PLAN table
  SELECT vbeln           " Sales Document
         posnr           " Sales Document Item
         activity        " E095: Activity
         eadat           " Activity Date
         renwl_prof      " Renewal Profile
         promo_code      " Promo code
         act_status      " Activity Status
         ren_status      " Renewal Status
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE li_renwl_plan
    WHERE vbeln = st_vbfa-vbelv
    AND   posnr = st_vbfa-posnv
    AND  activity IN li_range
    AND   eadat LE sy-datum
    AND act_status = lc_status.
  IF sy-subrc IS INITIAL.
*    SORT li_renwl_plan BY vbeln posnr act_status.
    SORT li_renwl_plan BY eadat DESCENDING.
  ENDIF. " IF sy-subrc IS INITIAL
********Populate reminder number
*  LOOP AT li_renwl_plan INTO lst_renwl_plan.
  READ TABLE li_renwl_plan INTO lst_renwl_plan INDEX 1.
  IF sy-subrc IS INITIAL.
    fp_st_final-notice = lst_renwl_plan-activity+1(2).
  ENDIF. " IF sy-subrc IS INITIAL
  IF fp_st_final-notice IS INITIAL.
    fp_st_final-notif = 1.

  ENDIF. " IF fp_st_final-notice IS INITIAL

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
                INTO lv_datum
                SEPARATED BY lc_hyphen.
  ENDIF. " IF sy-subrc = 0

*******Populate renewal date
  fp_st_final-renewal_date = lv_datum.
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
  v_year = lv_year.
*** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue
******Populate currency key
  CLEAR: lst_vbak.
  READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = st_vbco3-vbeln
                                  BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    fp_st_final-currency = lst_vbak-waerk.
  ENDIF. " IF sy-subrc IS INITIAL

* Begin of change: PBANDLAPAL: 24-OCT-2017: CR#666 : ED2K908397
* As per the latest design irrespective of the country we are showing as Tax
* Hence removed all the irrelevant code.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.

  CLEAR: li_lines,
         lv_text.

  PERFORM read_text USING v_tax
                  CHANGING li_lines
                           lv_text.
  IF lv_text IS NOT INITIAL.
    CONDENSE lv_text.
  ENDIF. " IF lv_text IS NOT INITIAL
* End of change: PBANDLAPAL: 24-OCT-2017: CR#666 : ED2K909045

  CLEAR: li_vbap_hcomp[].

  li_vbap_hcomp[] = i_vbap[].
  DELETE li_vbap_hcomp WHERE uepos IS NOT INITIAL.

  PERFORM f_fetch_issue_seq  USING i_vbap
                             CHANGING i_issue_seq
                                      lv_matnr.

* Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
* LOOP AT i_konv INTO lst_komv.
* End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
* Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
  LOOP AT i_konv INTO DATA(lst_komv_tmp).
    lst_komv = lst_komv_tmp.
*   Check to identify if the Line is already "Rejected"
    READ TABLE i_vbap INTO lst_vbap
         WITH KEY posnr = lst_komv-kposn
         BINARY SEARCH.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF. " IF sy-subrc NE 0
* End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241

***   Populate percentage
    lv_kbetr = lv_kbetr + lst_komv-kbetr.
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
*** Populate tax amount
    lst_tax_item-tax_amount = lst_tax_item-tax_amount + lst_komv-kwert.

    AT END OF kposn.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
      IF lv_kbetr IS NOT INITIAL.
        lv_tax_amount = ( lv_kbetr / 10 ).
      ENDIF. " IF lv_kbetr IS NOT INITIAL
      WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
      CONCATENATE lst_tax_item-tax_percentage lc_percentage INTO lst_tax_item-tax_percentage.
      CONDENSE lst_tax_item-tax_percentage.
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
      READ TABLE i_mara INTO lst_mara
           WITH KEY matnr = lst_vbap-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_tax_item-ismmediatype = lst_mara-ismmediatype.
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241

      READ TABLE li_tax_item ASSIGNING FIELD-SYMBOL(<lfs_tax_item>)
                                         WITH KEY tax_percentage = lst_tax_item-tax_percentage
*                                                 Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
                                                  ismmediatype   = lst_tax_item-ismmediatype.
*                                                 End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
      IF sy-subrc EQ 0.
        <lfs_tax_item>-taxable_amt = <lfs_tax_item>-taxable_amt + lst_komv-kawrt.
*       Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
*       <lfs_tax_item>-tax_amount = <lfs_tax_item>-tax_amount + lst_komv-kwert.
*       End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
*       Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
        <lfs_tax_item>-tax_amount = <lfs_tax_item>-tax_amount + lst_tax_item-tax_amount.
*       End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
*       **        Populate text TAX
        <lfs_tax_item>-media_type = lv_text.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       Begin of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
*       lst_tax_item-tax_amount = lst_komv-kwert.
*       End   of DEL:CR#743:WROY:13-Mar-2018:ED2K911241
*       **        Populate text TAX
        lst_tax_item-media_type = lv_text.
        APPEND lst_tax_item TO li_tax_item.
      ENDIF. " IF sy-subrc EQ 0
      CLEAR: lv_tax_amount,lst_komv,lst_tax_item,lv_kbetr,lv_kawrt.
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
    ENDAT.
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
  ENDLOOP. " LOOP AT i_konv INTO DATA(lst_komv_tmp)

  DATA(li_vbap) = i_vbap[].
***    BOC by MODUTTA on 05/02/18 for CR# 743
  LOOP AT i_vbap INTO DATA(lst_vbap_temp).
    lv_tax = lv_tax + lst_vbap_temp-kzwi6.

    CLEAR lst_vbap.
    READ TABLE li_vbap_hcomp INTO lst_vbap WITH KEY vbeln = lst_vbap_temp-vbeln
                                                    posnr = lst_vbap_temp-posnr.

    IF sy-subrc EQ 0.
* Description
* Begin of change: PBANDLAPAL: 24-OCT-2017: ED2K90904\5
*    fp_st_final-arktx   = lst_vbap-arktx.
      PERFORM read_text_matdesc  USING lst_vbap-matnr
                             CHANGING fp_st_final-arktx.
* End of change: PBANDLAPAL: 24-OCT-2017: ED2K909045
      READ TABLE i_mara INTO DATA(lst_mara_tmp) WITH KEY matnr = lst_vbap-matnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF lst_mara_tmp-mtart IN r_mtart_multi_bom. "Added by MODUTTA
          lv_multi_bom_flg = abap_true.
        ENDIF. " IF lst_mara_tmp-mtart IN r_mtart_multi_bom
      ENDIF. " IF sy-subrc EQ 0

* To Calculate the discount percentage.
      IF lst_vbap-kzwi1 IS NOT INITIAL.
        lv_percentage = ( lst_vbap-kzwi5 / lst_vbap-kzwi1 ) * 100.
      ENDIF. " IF lst_vbap-kzwi1 IS NOT INITIAL

      IF lv_percentage LT 0.
        lv_percentage = lv_percentage * ( -1 ).
      ENDIF. " IF lv_percentage LT 0

      WRITE lv_percentage TO lv_percentage_c.

      CONDENSE lv_percentage_c NO-GAPS.
      CONCATENATE lv_percentage_c
                  lc_percent
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      fp_st_final-disc_prcnt = v_value.

*    Populate Sub Total
      v_sub_total = v_sub_total + lst_vbap-kzwi1.

**    Tax
*    v_taxes     =  v_taxes + lv_tax + lst_vbap-kzwi6.

*  Discount in Subtotal footer
      v_discount = v_discount + lst_vbap-kzwi5.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbap_temp-vbeln
                                                       uepos = lst_vbap_temp-posnr.
    IF sy-subrc NE 0.
*    Media Type
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap_temp-matnr.
      IF sy-subrc EQ 0.
        CLEAR: lv_pnt_issn,
               lv_name_issn,
               li_lines[].
        CASE lst_mara-ismmediatype.
          WHEN c_mediatyp_dgtl.
            lv_name_issn = lc_digissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.

          WHEN c_mediatyp_prnt.
            lv_name_issn = lc_pntissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.

          WHEN c_mediatyp_combo.
            lv_name_issn = lc_combissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.

          WHEN OTHERS.
        ENDCASE.
* Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924578
        IF lst_vbap_temp-uepos IS INITIAL.
          DATA(li_all_media_product) =  i_vbap[].
          CLEAR: lst_digital,lst_print,li_print_media_product[],li_digital_media_product[].
          LOOP AT li_all_media_product INTO DATA(lst_all_media) WHERE uepos = lst_vbap_tmp-posnr.
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
            lv_name_issn = lc_digissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS INITIAL.
            lv_name_issn = lc_pntissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.
          ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS NOT INITIAL.
            lv_name_issn = lc_combissn.
            PERFORM read_text   USING lv_name_issn
                                CHANGING  li_lines
                                             lv_pnt_issn.
          ENDIF.
        ENDIF.
* End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924578

** ISSN
        READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign1) WITH KEY matnr =  lst_vbap_temp-matnr
                                                                          idcodetype = v_idcodetype_1
                                                                          BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF lv_pnt_issn IS NOT INITIAL.
            IF st_final-issn1_text IS INITIAL.
              CONCATENATE lv_pnt_issn lc_colon INTO st_final-issn1_text.
              CONDENSE st_final-issn1_text.
            ELSE. " ELSE -> IF st_final-issn1_text IS INITIAL
              CONCATENATE lv_pnt_issn lc_colon INTO st_final-issn2_text.
              CONDENSE st_final-issn2_text.
            ENDIF. " IF st_final-issn1_text IS INITIAL
          ENDIF. " IF lv_pnt_issn IS NOT INITIAL
          IF lst_jptidcdassign1-identcode IS NOT INITIAL.
            IF st_final-issn1_value IS INITIAL.
              st_final-issn1_value = lst_jptidcdassign1-identcode.
              CONDENSE st_final-issn1_value.
            ELSE. " ELSE -> IF st_final-issn1_value IS INITIAL
              IF st_final-issn2_value IS INITIAL.
                st_final-issn2_value = lst_jptidcdassign1-identcode.
                CONDENSE st_final-issn2_value.
              ENDIF. " IF st_final-issn2_value IS INITIAL
            ENDIF. " IF st_final-issn1_value IS INITIAL
          ENDIF. " IF lst_jptidcdassign1-identcode IS NOT INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc NE 0
  ENDLOOP. " LOOP AT i_vbap INTO DATA(lst_vbap_temp)

*    Total
  v_total = v_sub_total + v_discount + lv_tax.

***BOC by MODUTTA for CR# 743 on 05/02/2018
  CLEAR lst_tax_item.
  LOOP AT li_tax_item INTO lst_tax_item.
*    lst_tax_tab-zzdesc = lst_tax_item-media_type.
    CONCATENATE lst_tax_item-media_type c_semicoln_char INTO lst_tax_tab-zzdesc. " Added by PBANDLAPAL

    WRITE lst_tax_item-taxable_amt TO lv_taxable_char CURRENCY lv_waerk.
    CONCATENATE lv_taxable_char '@' INTO lv_taxable_char.
    CONDENSE lv_taxable_char.

    WRITE lst_tax_item-tax_amount TO lv_tax_amount_char CURRENCY lv_waerk.
    CONDENSE lv_tax_amount_char.

    CONCATENATE lst_tax_item-tax_percentage  '=' INTO lst_tax_item-tax_percentage .
    CONDENSE lst_tax_item-tax_percentage.

    CONCATENATE lv_taxable_char ' ' lst_tax_item-tax_percentage ' ' lv_tax_amount_char INTO lst_tax_tab-zztax_dtls SEPARATED BY space.
    APPEND lst_tax_tab TO i_tax_tab.
    CLEAR lst_tax_tab.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR# 743 on 05/02/2018

  IF lv_multi_bom_flg IS INITIAL.
** To Append Volume Details in the PDF document.
    CALL FUNCTION 'ZQTC_VOL_ISSUES_F037'
      EXPORTING
        im_volume      = v_volume_iss
        im_start_issue = v_start_issue
        im_tot_issue   = v_tot_issue.

**** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
    CLEAR li_lines.
    PERFORM read_text USING lc_issue
                      CHANGING li_lines
                               lv_issue_str.
    lv_issue = lv_issue_str.
    IF v_volume_iss IS NOT INITIAL.
      CONCATENATE v_volume_iss lc_comma INTO lv_vol_des.
    ENDIF. " IF v_volume_iss IS NOT INITIAL

    IF v_tot_issue IS NOT INITIAL.
      CONCATENATE v_tot_issue lv_issue INTO lv_issue SEPARATED BY space.
      CONCATENATE lv_vol_des lv_issue INTO v_issue_desc SEPARATED BY space.
    ELSE. " ELSE -> IF v_tot_issue IS NOT INITIAL
      v_issue_desc = lv_vol_des.
    ENDIF. " IF v_tot_issue IS NOT INITIAL
    CONDENSE v_issue_desc.
  ENDIF. " IF lv_multi_bom_flg IS INITIAL
  CLEAR lv_multi_bom_flg.
**** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue

* To convert the values to negative.
* To convert sub total values based on the currency and display accordingly
  WRITE v_sub_total  TO v_sub_total_c CURRENCY fp_st_final-currency.
  CONDENSE  v_sub_total_c.

  IF v_sub_total LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_sub_total_c.
  ENDIF. " IF v_sub_total LT 0
  fp_st_final-sub_total = v_sub_total_c.
* To convert total values based on the currency and display accordingly
  WRITE v_total  TO v_total_c CURRENCY fp_st_final-currency.
  CONDENSE  v_total_c.
  IF v_total LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_total_c.
  ENDIF. " IF v_total LT 0
  fp_st_final-total_due = v_total_c.

* To convert sub total values based on the currency and display accordingly
  WRITE v_discount  TO v_discount_c CURRENCY fp_st_final-currency.
  CONDENSE  v_discount_c.
  IF v_discount LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_discount_c.
  ENDIF. " IF v_discount LT 0
  fp_st_final-discount = v_discount_c.
* End of Change by PBANDLAPAL on 07-Oct-2017


*  BOC by MODUTTA on 10-Oct-2017 for subsype/mem type
*****For Membership Scenario************************
** To Get "Member Ship Type" text Module.
  IF v_scenario_scm = abap_true
    OR v_scenario_scc = abap_true.
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_membership_type_tm
                             CHANGING lv_txtmodule_data.
    fp_st_final-member_txt = lv_txtmodule_data.
** To Get Membership Electronic/Print.
    CLEAR: lst_vbap,lst_mara.
    READ TABLE i_vbap INTO lst_vbap INDEX 1.
    IF sy-subrc EQ 0.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap-matnr.
      IF sy-subrc EQ 0.
        CASE lst_mara-ismmediatype.
          WHEN c_mediatyp_dgtl.
** To Get "Membership Digital" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_membership_digi_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-member_value = lv_txtmodule_data.
          WHEN c_mediatyp_prnt.
** To Get "Membership Print" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_membership_print_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-member_value = lv_txtmodule_data.
          WHEN c_mediatyp_combo.
** To Get "Membership Combo" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_membership_combo_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-member_value = lv_txtmodule_data.
          WHEN OTHERS.
        ENDCASE.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
** To Get "Member Ship Reference" text Module.
    CLEAR lv_txtmodule_data.
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
    IF ( r_mat_grp5[] IS NOT INITIAL AND r_output_typ[] IS NOT INITIAL ) AND
       ( st_vbap-mvgr5 IN r_mat_grp5 AND nast-kschl IN r_output_typ ).
      PERFORM read_text  USING c_membership_number
                      CHANGING li_dummy
                               lv_txtmodule_data.
    ELSE.
      PERFORM read_text_module USING c_membership_ref_tm
                               CHANGING lv_txtmodule_data.
    ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
    fp_st_final-sub_ref_txt = lv_txtmodule_data.

*****For Subscription Scenario************************
  ELSEIF v_scenario_tbt = abap_true. " Subscription Scenario
* For Subscription Scenario we will be having all subscription related texts.
    CLEAR lv_txtmodule_data.
    PERFORM read_text_module USING c_subscription_type_tm
                             CHANGING lv_txtmodule_data.
    fp_st_final-subs_txt = lv_txtmodule_data.
** To Get subscription Electronic/Print.
    READ TABLE i_vbap INTO lst_vbap INDEX 1.
    IF sy-subrc EQ 0.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap-matnr.
      IF sy-subrc EQ 0.
        CASE lst_mara-ismmediatype.
          WHEN c_mediatyp_dgtl.
** To Get "Digital" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_med_type_digi_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-subs_value = lv_txtmodule_data.
          WHEN c_mediatyp_prnt.
** To Get " Print" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_med_type_print_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-subs_value = lv_txtmodule_data.
          WHEN c_mediatyp_combo.
** To Get " Combo" text Module.
            CLEAR lv_txtmodule_data.
            PERFORM read_text_module USING c_med_type_combo_tm
                                     CHANGING lv_txtmodule_data.
            fp_st_final-subs_value = lv_txtmodule_data.
          WHEN OTHERS.
        ENDCASE.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
** To Get "Subscription Reference" text Module.
    CLEAR lv_txtmodule_data.
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
    IF st_vbap-mvgr5 IN r_mat_grp5 AND
       nast-kschl IN r_output_typ.
      PERFORM read_text  USING c_membership_number
                      CHANGING li_dummy
                               lv_txtmodule_data.
    ELSE.
      PERFORM read_text_module    USING c_subscription_ref_tm
                               CHANGING lv_txtmodule_data.
    ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
    fp_st_final-sub_ref_txt = lv_txtmodule_data.
  ENDIF. " IF v_scenario_scm = abap_true
*  EOC by MODUTTA on 10-Oct-2017 for subsype/mem type
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_FM_OUTPUT_SUPP
*&---------------------------------------------------------------------*
*       To get the output from FM of E098
*----------------------------------------------------------------------*
FORM f_call_fm_output_supp  CHANGING fp_li_output TYPE ztqtc_output_supp_retrieval.
*  Local data declaration
  DATA: lst_output TYPE zstqtc_output_supp_retrieval, " Output structure for E098-Output Supplement Retrieval
        lv_kdkg    TYPE kdkgr,                        " Customer Attribute for Condition Groups
        li_kdkg    TYPE ztqtc_customer_group,         " Customer Attribute for Condition Groups
        lv_matnr   TYPE matnr,                        " Material Number
        li_matnr   TYPE matnr_tty,                    " Material Number
        li_input   TYPE ztqtc_supplement_ret_input,
        lst_input  TYPE zstqtc_supplement_ret_input.  " Input Paramter for E098 Supplement retrieval

*** BOC BY SAYANDAS
  TYPES : BEGIN OF lty_constant,
            sign TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
            opti TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE  salv_de_selopt_low, "Lower Value of Selection Condition
            high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          END OF lty_constant.

  DATA : li_constant TYPE STANDARD TABLE OF lty_constant.

  CONSTANTS: lc_devid    TYPE zdevid       VALUE 'E098',   " Development ID
             lc_kschl    TYPE rvari_vnam   VALUE 'KSCHL',  " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913181
             lc_parvw_za TYPE parvw        VALUE 'ZA',     " Partner Function
             lc_parvw_ag TYPE parvw        VALUE 'AG',     " Partner Function
             lc_posnr_h  TYPE posnr        VALUE '000000', " Item number of the SD document
*            End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913181
             lc_nacha_01 TYPE na_nacha     VALUE '1'.      " Message transmission medium (Print).
*** EOC BY SAYANDAS


* Populate material and customer group
  lst_input-product_no = st_vbap-matnr.
  lst_input-cust_grp = st_vbkd-kdkg2.
* Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913181
  READ TABLE i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
       WITH KEY vbeln = st_vbap-vbeln
                parvw = lc_parvw_za
                posnr = st_vbap-posnr
       BINARY SEARCH.
  IF sy-subrc NE 0.
    READ TABLE i_vbpa ASSIGNING <lst_vbpa>
         WITH KEY vbeln = st_vbap-vbeln
                  parvw = lc_parvw_za
                  posnr = lc_posnr_h
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc NE 0.
    READ TABLE i_vbpa ASSIGNING <lst_vbpa>
         WITH KEY vbeln = st_vbap-vbeln
                  parvw = lc_parvw_ag
                  posnr = lc_posnr_h
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc EQ 0.
    lst_input-society = <lst_vbpa>-kunnr.
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913181
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
*Call FM to get the list of PDF attachments for the particular material
*and attachment name ending with KDKG1
    CALL FUNCTION 'ZQTC_OUTPUT_SUPP_RETRIEVAL'
      EXPORTING
        im_input  = li_input
        im_auart  = lv_auart
      IMPORTING
        ex_output = fp_li_output.

    IF nast-nacha EQ lc_nacha_01.
      CLEAR lst_output.
      lst_output-attachment_name = 'Early Bird Renewal Notice'(007).
      lst_output-pdf_stream = st_formoutput-pdf.
*     APPEND lst_output TO fp_li_output.
      INSERT lst_output INTO fp_li_output INDEX 1.
    ENDIF. " IF nast-nacha EQ lc_nacha_01
  ENDIF. " IF nast-kschl IN li_constant

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
*** Calling FM for F044 related changes
  IF v_vkorg_f044 IN r_vkorg_f044
    AND v_zlsch_f044 NOT IN r_zlsch_f044
    AND v_kvgr1_f044 NOT IN r_kvgr1_f044.   " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423

    IF v_scenario_tbt = abap_true.
      v_scenario_f044 = 'TBT'.
    ELSEIF v_scenario_scc = abap_true.
      v_scenario_f044 = 'SCC'.
    ELSEIF v_scenario_scm = abap_true.
      v_scenario_f044 = 'SCM'.
    ENDIF. " IF v_scenario_tbt = abap_true

    CALL FUNCTION 'ZQTC_DIR_DEBIT_MANDT_F044'
      EXPORTING
        im_vkorg      = v_vkorg_f044
*       IM_ZLSCH      =
        im_waerk      = v_waerk_f044
        im_scenario   = v_scenario_f044
        im_ihrez      = v_ihrez_f044
        im_adrnr      = v_adrnr_f044
        im_kunnr      = v_kunnr_f044
        im_langu      = v_langu_f044
        im_xstring    = v_xstring
      IMPORTING
        ex_formoutput = st_formoutput_f044.
  ENDIF. " IF v_vkorg_f044 IN r_vkorg_f044
  IF st_formoutput_f044-pdf IS NOT INITIAL.
    CLEAR lst_output.
    lst_output-attachment_name = 'Direct Debit Mandate'(009).
    lst_output-pdf_stream = st_formoutput_f044-pdf.
    IF fp_li_output IS INITIAL.
      INSERT lst_output INTO fp_li_output INDEX 1.
    ELSE. " ELSE -> IF fp_li_output IS INITIAL
      INSERT lst_output INTO fp_li_output INDEX 2.
    ENDIF. " IF fp_li_output IS INITIAL
  ENDIF. " IF st_formoutput_f044-pdf IS NOT INITIAL
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LANGUAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBCO3  text
*      <--P_fp_st_final  text
*----------------------------------------------------------------------*
FORM f_get_language  USING    fp_st_vbco3    TYPE vbco3             " Sales Doc.Access Methods: Key Fields: Document Printing
                     CHANGING fp_st_address  TYPE zstqtc_add_f035 . " Structure for address node.
*  Local type declaration
  TYPES: BEGIN OF lty_vbak,
           vbeln TYPE  vbeln_va, "Sales Document
           kunnr TYPE  kunag,    "Sold-to party
         END OF lty_vbak,

         BEGIN OF lty_kna1,
           kunnr TYPE kunnr,     "Customer Number
           land1 TYPE  land1_gp, "Country Key
           spras TYPE spras,     "Language Key
         END OF lty_kna1.

* Local data declaration
  DATA : lst_vbak TYPE lty_vbak,
         lst_kna1 TYPE lty_kna1.

* Fetch data from VBAK table
  SELECT SINGLE vbeln "Sales Document
         kunnr        "Sold-to party
    FROM vbak         " Sales Document: Header Data
    INTO lst_vbak
    WHERE vbeln = fp_st_vbco3-vbeln.
  IF sy-subrc IS INITIAL.
    SELECT SINGLE
      kunnr     "Customer Number
      land1     "Country Key
      spras     "Language Key
      FROM kna1 " General Data in Customer Master
      INTO lst_kna1
      WHERE kunnr = lst_vbak-kunnr.
    IF sy-subrc IS INITIAL.
      fp_st_address-spras = lst_kna1-spras.
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      v_langu_f044      = lst_kna1-spras.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*** BOC BY SAYANDAS
      fp_st_address-country = lst_kna1-land1.
*** EOC BY SAYANDAS
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL

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
                       CHANGING fp_v_seller_reg TYPE tdline   " Seller VAT Registration Number
                                fp_v_buyer_reg  TYPE tdline.  " Buyer VAT Registration number
*  *Local data declaration
  DATA: lv_doc_line  TYPE /idt/doc_line_number, " Document Line Number
        lv_buyer_reg TYPE char255,              " Buyer_reg of type CHAR255
        lvv_index    TYPE sy-index.             " Index Value "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
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
             lc_colon    TYPE char1      VALUE ':',         " Colon of type CHAR1
             lc_1001     TYPE bukrs_vf   VALUE '1001'. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745

  DATA: li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
        lv_text  TYPE string,
        lv_tax   TYPE thead-tdname,            " Name
        lv_ind   TYPE xegld.                   " Indicator: European Union Member?

* Begin of Comment by PBANDLAPAL on 20-OCT-2017
** Retrieve European member indicator from T005 table
*  SELECT SINGLE xegld " Indicator: European Union Member?
*           INTO lv_ind
*           FROM t005  " Countries
*           WHERE land1 = st_address-country.
*
** Fetch VAT/TAX/GST based on condition
*  IF lv_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO lv_tax.
*
*  ELSEIF st_address-country EQ 'US'.
*    CONCATENATE lc_class
*                lc_tax
*                lc_devid
*           INTO lv_tax.
*  ELSE. " ELSE -> IF lv_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO lv_tax.
*
*  ENDIF. " IF lv_ind EQ abap_true
*
*  CLEAR: li_lines,
*         lv_text.
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
*      id                      = lc_st
*      language                = st_address-spras
*      name                    = lv_tax
*      object                  = lc_object
*    TABLES
*      lines                   = li_lines
*    EXCEPTIONS
*      id                      = 1
*      language                = 2
*      name                    = 3
*      not_found               = 4
*      object                  = 5
*      reference_check         = 6
*      wrong_access_to_archive = 7
*      OTHERS                  = 8.
*  IF sy-subrc EQ 0.
*    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*      EXPORTING
*        it_tline       = li_lines
*      IMPORTING
*        ev_text_string = lv_text.
*    IF sy-subrc EQ 0.
*      CONDENSE lv_text.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF sy-subrc EQ 0
**** BOC BY SAYANDAS
* End of Comment by PBANDLAPAL on 20-OCT-2017

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
*** Begin of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
    i_tax_data_buyer[] = i_tax_data[].
*** End of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
    SORT i_tax_data BY seller_reg.
    DELETE i_tax_data WHERE seller_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM i_tax_data COMPARING seller_reg.
    CLEAR lvv_index."ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    LOOP AT i_tax_data INTO DATA(lst_tax_data).
      IF lst_tax_data-seller_reg IS NOT INITIAL.
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        lvv_index = sy-tabix.
        IF lvv_index = 1.
          v_seller_reg = lst_tax_data-seller_reg.
        ELSE.
          CONCATENATE lst_tax_data-seller_reg c_comma v_seller_reg INTO v_seller_reg.
        ENDIF.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*        ENDIF.
*        CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      ENDIF. " IF lst_tax_data-seller_reg IS NOT INITIAL
    ENDLOOP. " LOOP AT i_tax_data INTO DATA(lst_tax_data)
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    READ TABLE i_vbak INTO lst_vbak INDEX 1.
    IF v_seller_reg IS INITIAL AND lst_vbak-bukrs_vf = lc_1001.
      v_seller_reg = v_tax_id.
    ENDIF.
*** Begin of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
    SORT i_tax_data_buyer BY buyer_reg.
    DELETE i_tax_data_buyer WHERE buyer_reg IS INITIAL.
    IF i_tax_data_buyer IS NOT INITIAL.
      DELETE ADJACENT DUPLICATES FROM i_tax_data_buyer COMPARING buyer_reg.
      CLEAR lvv_index.
      LOOP AT i_tax_data_buyer INTO DATA(lst_tax_data_buyer).
        IF lst_tax_data_buyer-buyer_reg IS NOT INITIAL.
          lvv_index = sy-tabix.
          IF lvv_index = 1.
            fp_v_buyer_reg = lst_tax_data_buyer-buyer_reg.
          ELSE.
            CONCATENATE lst_tax_data_buyer-buyer_reg c_comma fp_v_buyer_reg INTO fp_v_buyer_reg.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
*** End of Changes by Lahiru on 01/22/2020 for ERPM-8994 with ED2K917342 ***
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BARCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_barcode.
  DATA: lv_amount   TYPE char11, " Amount of type CHAR18
*        lv_amount   TYPE char18, " Amount of type CHAR18
*        lv_order    TYPE char10, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        lv_order    TYPE char16, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        lv_inv_chk  TYPE char1,  " Inv_chk of type CHAR1
        lv_amnt_chk TYPE char1,  " Amnt_chk of type CHAR1
        lv_bar      TYPE char100, " Bar of type CHAR30
        lv_bar_chk  TYPE char1.  " Bar_chk of type CHAR1

* Order Number
  MOVE st_vbco3-vbeln TO lv_order.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_order
    IMPORTING
      output = lv_order.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_order
*    IMPORTING
*      check_digit = lv_inv_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_order
    IMPORTING
      check_digit = lv_inv_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
*  WRITE st_final-total_due TO lv_amount CURRENCY st_final-currency.
* Begin of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*  IF v_total GT 0.
* End of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
  IF v_total GE 0.
* End of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
    WRITE v_total TO lv_amount CURRENCY st_final-currency.
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387

    REPLACE ALL OCCURRENCES OF '.' IN lv_amount WITH space.
*** BOC BY SAYANDAS
    REPLACE ALL OCCURRENCES OF ',' IN lv_amount WITH space.
*** EOC BY SAYANDAS
    CONDENSE lv_amount.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_amount
      IMPORTING
        output = lv_amount.

*  MOVE st_calc-total_due TO lv_amount.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
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
*  End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    CONCATENATE lv_order
              lv_inv_chk
              lv_amount
              lv_amnt_chk
              INTO lv_bar.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
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
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    CONCATENATE lv_order
                lv_inv_chk
                lv_amount
                lv_amnt_chk
                lv_bar_chk
                INTO v_barcode
                SEPARATED BY space.
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
* If total value is negative then we are raising a message
  ELSE. " ELSE -> IF v_total GT 0
    CLEAR v_msg_txt.
    MESSAGE e239(zqtc_r2) INTO v_msg_txt. "Total Amount can't be negative
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
  ENDIF. " IF v_total GT 0
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL
*&---------------------------------------------------------------------*
*       Clear global variables
*----------------------------------------------------------------------*
FORM f_clear_global.
  CLEAR: v_xstring,
         st_address,
         v_society_logo,
         st_final,
         v_footer,
         i_body,
*        Begin of ADD:RITM0040136:WROY:06-JUL-2018:ED1K907907
         i_std_text,
         i_vbak,
         i_mara_vol,
         i_issue_seq,
         i_constant,
         i_tvlzt,
         i_iss_vol2,
         i_iss_vol3,
         i_tax_data,
         i_konv,
         i_content_hex,
         i_vbap,
         i_mara,
         i_jptidcdassign,
         i_vbpa,
*        End   of ADD:RITM0040136:WROY:06-JUL-2018:ED1K907907
*        Begin of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913489
         v_vkorg_f044,
         v_waerk_f044,
         v_scenario_f044,
         v_ihrez_f044,
         v_adrnr_f044,
         v_kunnr_f044,
         v_langu_f044,
         st_formoutput_f044,
*        End   of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913489
* BOC by PBANDLAPAL on 21-Aug-2017
         i_arktx,
         i_id_body,
         i_terms,
         i_remit,
         i_footer,
         i_details,
         i_values,
         i_jksenip,
         i_tax_dtls,
         i_tax_tab,
         v_total,
         v_total_c,
         v_sub_total,
         v_sub_total_c,
         v_volume_iss,
         v_tot_issue,
         v_discount,
         v_discount_c,
         i_credit_body,
         v_scenario_tbt,
         v_scenario_scc,
         v_scenario_scm,
* EOC by PBANDLAPAL on 21-Aug-2017
         v_remit_to,
         v_renewal_text,
         v_body,
         v_remit_to_tbt,
         v_remit_to_scc,
         v_remit_to_scm,
         v_credit_scm,
         v_credit_tbt,
         v_credit_scc,
         v_email_tbt,
         v_email_scc,
         v_email_scm,
         v_banking1_scm,
         v_banking1_scc,
         v_banking1_tbt,
         v_banking2_scc,
         v_banking2_scm,
         v_banking2_tbt,
         v_cust_serv_tbt,
         v_cust_serv_scc,
         v_cust_serv_scm,
         v_footer_scm,
         v_footer_scc,
         v_footer_tbt,
         v_seller_reg,
         v_barcode,
         v_compname,
         r_mat_grp5,    " ADD:CR#7730 KKRAVURI20181012
         r_output_typ,  " ADD:CR#7730 KKRAVURI20181012
         v_buyer_reg,        " Add ERPM-8994 by Lahiru with ED2K917342
         i_tax_data_buyer.   " Add ERPM-8994 by Lahiru with ED2K917342
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_MODULE
*&---------------------------------------------------------------------*
*       To read text modules
*----------------------------------------------------------------------*
*      -->P_C_RENEWAL_NOTICE_TM  text
*      <--P_LV_TXTMODULE_DATA  text
*----------------------------------------------------------------------*
FORM read_text_module  USING    fp_txtmod_name  TYPE tdsfname      " Smart Forms: Form Name
                       CHANGING fp_txtmodule_data_c   TYPE string. " Text Line
  DATA:
    lst_language_tm TYPE ssfrlang,                " Smart Forms: Languages at Runtime
    lst_lines       TYPE tline,                   " SAPscript: Text Lines
    li_lines        TYPE STANDARD TABLE OF tline. " SAPscript: Text Lines.

  lst_language_tm-langu1  =  st_address-spras.

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
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_NAME  text
*      <--P_LV_TEXT  text
*----------------------------------------------------------------------*
FORM read_text  USING    fp_name      TYPE tdobname " Name
                CHANGING fp_lines     TYPE tttext
                         fp_text      TYPE string.

  DATA:  li_lines     TYPE STANDARD TABLE OF tline. "Lines of text read


  CLEAR: fp_text,
         li_lines.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_address-spras
      name                    = fp_name
      object                  = c_object
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
    fp_lines[] = li_lines[].
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = fp_text.
    IF sy-subrc EQ 0.
      CONDENSE fp_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ISSUE_SEQ
*&---------------------------------------------------------------------*
*       Fetch Media Product Issue Sequence
*----------------------------------------------------------------------*
*      -->P_I_VBAP  text
*      <--P_I_ISSUE_SEQ  text
*----------------------------------------------------------------------*
FORM f_fetch_issue_seq  USING    fp_i_vbap      TYPE tt_vbap
                        CHANGING fp_li_issue_sq TYPE tt_issue_sq
                                 fp_lv_matnr    TYPE matnr. " Material Number
  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number

  DATA:
    lst_vbap          TYPE ty_vbap,
    lt_vbap           TYPE TABLE OF ty_vbap,
    lir_vbeln         TYPE ltt_vbeln_r,                             " local range table of of vbeln
    lst_vbeln         TYPE LINE OF ltt_vbeln_r,                     " Local workarea of range table
    lst_mara_vol      TYPE ty_mara_vol,
    lst_vbap_bom      TYPE ty_vbap,
    lv_matnr          TYPE matnr,                                   " Material Number
    lv_day            TYPE char2,                                   " Date of type CHAR2
    lv_month_c2       TYPE char2,                                   " Mnthc2 of type CHAR2
    lv_month_c3       TYPE char3,                                   " Mnthc3 of type CHAR3
    lv_year           TYPE char4,                                   " Year of type CHAR4
    lv_month          TYPE fcltx,                                   " Month
    lv_vbegdat        TYPE vbdat_veda,                              " Contract start date
    lv_venddat        TYPE vbdat_veda,                              " Contract start date
    lv_cntr_month     TYPE char30,                                  " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_cntr           TYPE char30,                                  " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_day1(2)        TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_month1(2)      TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_year2(4)       TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_stext          TYPE t247-ktx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    lv_ltext          TYPE t247-ltx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
    li_veda           TYPE TABLE OF ty_veda_qt,
    lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL, " Wrapper Class for Office Documents
    lv_venddat_subs   TYPE vbdat_veda,                              " Contract start date
    lv_vbegdat_subs   TYPE vbdat_veda,                              " Contract start date
    lst_veda_subs     TYPE ty_veda_qt,
    lst_veda_quote    TYPE ty_veda_qt,
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
    lst_veda_qtemp    TYPE ty_veda_qt,
    lst_iss_vol2      TYPE ty_iss_vol2,
    lst_iss_vol3      TYPE ty_iss_vol3,
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
    lst_cntrct_dat_qt TYPE ty_cntrct_dat_qt,
    lir_cntrct_dat_qt TYPE RANGE OF vbdat_veda, " Contract start date
    lv_issues         TYPE i,                   " No. of Issues.
    lv_vol_count      TYPE syst_tabix,          " ABAP System Field: Row Index of Internal Tables
    lv_volume_st      TYPE ismheftnummer,       " Volume Start
    lv_volume         TYPE string.              "Volume

*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
  CONSTANTS: lc_hier2  TYPE ismhierarchlvl VALUE '2', " Hierarchy Level (Media Product Family, Product or Issue)
             lc_hier3  TYPE ismhierarchlvl VALUE '3', " Hierarchy Level (Media Product Family, Product or Issue)
             lc_hyphen TYPE char01        VALUE '-',  " Constant for hyphen
             lc_posnr  TYPE posnr VALUE '000000'.     " Item number of the SD document
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX


  IF fp_i_vbap IS INITIAL.
    RETURN.
  ENDIF. " IF fp_i_vbap IS INITIAL

  DATA(li_vbap) = fp_i_vbap.
  READ TABLE li_vbap INTO lst_vbap INDEX 1.

  READ TABLE li_vbap INTO lst_vbap_bom WITH KEY uepos = lst_vbap-posnr.
  IF sy-subrc EQ 0.
    fp_lv_matnr = lst_vbap_bom-matnr.
  ELSE. " ELSE -> IF sy-subrc EQ 0
    fp_lv_matnr = lst_vbap-matnr.
  ENDIF. " IF sy-subrc EQ 0

* To build the range for veda with subscription and quotations
  CLEAR lir_vbeln[].
  lst_vbeln-sign   =  c_sign_i.
  lst_vbeln-option =  c_option_eq.
* To pass quotation number
  lst_vbeln-low    =  lst_vbap-vbeln.
  APPEND lst_vbeln TO lir_vbeln.
* To pass the subscription number
  lst_vbeln-low    =  st_vbfa-vbelv.
  APPEND lst_vbeln TO lir_vbeln.

  SELECT vbeln " Sales Document
         vposn " Sales Document Item
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         vlaufk
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         vbegdat   " Contract start date
         venddat   " Contract end date
         INTO TABLE li_veda
         FROM veda " Contract Data
         WHERE vbeln IN lir_vbeln.
  IF sy-subrc EQ 0.
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
    DATA: lst_veda LIKE LINE OF li_veda.
    SORT li_veda BY vbeln vposn.
*    READ TABLE li_veda INTO lst_veda INDEX 1.
*    DATA(lv_year1) = lst_veda-vbegdat+0(4).

    SELECT spras  " Language Key
           vlaufk " Validity period category of contract
           bezei  " Description
      FROM tvlzt  " Validity Period Category: Texts
      INTO TABLE i_tvlzt
      FOR ALL ENTRIES IN li_veda
      WHERE spras = st_vbco3-spras
      AND vlaufk = li_veda-vlaufk.
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
    IF lst_vbap_bom IS NOT INITIAL.
      READ TABLE li_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                       vposn = lst_vbap_bom-posnr.
      IF lst_veda_quote-vbegdat IS NOT INITIAL."sy-subrc EQ 0. "CR-7841:SGUDA:30-Apr-2019:ED1K910099
        lv_vbegdat = lst_veda_quote-vbegdat.
        lv_venddat = lst_veda_quote-venddat.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE li_veda  INTO lst_veda_quote WITH KEY  vbeln = lst_vbap-vbeln
                                                          vposn = lc_posnr.
        lv_vbegdat = lst_veda_quote-vbegdat.
        lv_venddat = lst_veda_quote-venddat.
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF lst_vbap_bom IS NOT INITIAL
      READ TABLE li_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                       vposn = lst_vbap-posnr.
      IF lst_veda_quote-vbegdat IS NOT INITIAL."sy-subrc EQ 0. ""CR-7841:SGUDA:30-Apr-2019:ED1K910099
        lv_vbegdat = lst_veda_quote-vbegdat.
        lv_venddat = lst_veda_quote-venddat.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE li_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                         vposn = lc_posnr.
        lv_vbegdat = lst_veda_quote-vbegdat.
        lv_venddat = lst_veda_quote-venddat.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbap_bom IS NOT INITIAL
    IF lv_vbegdat IS NOT INITIAL OR lv_venddat IS NOT INITIAL.
      lst_cntrct_dat_qt-sign  = c_sign_i.
      lst_cntrct_dat_qt-option = c_option_bt.
      lst_cntrct_dat_qt-low    = lv_vbegdat.
      lst_cntrct_dat_qt-high   = lv_venddat.
      APPEND lst_cntrct_dat_qt TO lir_cntrct_dat_qt.
    ENDIF. " IF lv_vbegdat IS NOT INITIAL OR lv_venddat IS NOT INITIAL
*   Begin of ADD:ERP-6937:WROY:08-Feb-2018:ED2K911241
* Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
*    IF lv_vbegdat IS NOT INITIAL.
*      v_year = lv_vbegdat(4).
*    ENDIF. " IF lv_vbegdat IS NOT INITIAL
    IF lv_vbegdat IS NOT INITIAL.
      CLEAR: v_year,lv_cntr,lv_cntr_month,lv_day1,lv_month1,lv_year2,lv_stext,lv_ltext.
      CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
        EXPORTING
          idate                         = lv_vbegdat
        IMPORTING
          day                           = lv_day1
          month                         = lv_month1
          year                          = lv_year2
          stext                         = lv_stext
          ltext                         = lv_ltext
*         userdate                      =
        EXCEPTIONS
          input_date_is_initial         = 1
          text_for_month_not_maintained = 2
          OTHERS                        = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      CONCATENATE lv_day1 lv_stext lv_year2 INTO  lv_cntr SEPARATED BY c_char_hyphen.
      CONDENSE lv_cntr.
      v_year = lv_cntr.
    ENDIF.
    IF lv_venddat IS NOT INITIAL.
      CLEAR:lv_cntr_month,lv_cntr,v_cntr_end,lv_day,lv_month,lv_year2,lv_stext,lv_ltext.
      CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
        EXPORTING
          idate                         = lv_venddat
        IMPORTING
          day                           = lv_day1
          month                         = lv_month1
          year                          = lv_year2
          stext                         = lv_stext
          ltext                         = lv_ltext
*         userdate                      =
        EXCEPTIONS
          input_date_is_initial         = 1
          text_for_month_not_maintained = 2
          OTHERS                        = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      CONCATENATE lv_day1 lv_stext lv_year2 INTO  lv_cntr SEPARATED BY c_char_hyphen.
      CONDENSE lv_cntr.
      v_cntr_end = lv_cntr.
    ENDIF.
*  End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910099
*   End   of ADD:ERP-6937:WROY:08-Feb-2018:ED2K911241
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
*      DATA(li_mara_temp2) = i_mara[].
*      DELETE li_mara_temp2 WHERE ismhierarchlevl NE lc_hier2.
*    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = fp_lv_matnr.
*    IF sy-subrc = 0.
*      IF lst_mara-ismhierarchlevl = lc_hier2.
*        SELECT med_prod,
*               matnr,
*               ismpubldate,
*               ismcopynr , " Copy Number of Media Issue
*               ismnrinyear " Issue Number (in Year Number)
*          FROM jptmg0      " IS-M: Media Product Issue Sequence
*          INTO TABLE @DATA(li_jptmg0_2)
**          FOR ALL ENTRIES IN @li_mara_temp2
*          WHERE med_prod = @fp_lv_matnr.
*        IF sy-subrc = 0.
*          DATA(li_jptmg0_2_iss) = li_jptmg0_2.
*          DELETE li_jptmg0_2_iss WHERE ismpubldate+0(4) NE v_year."lv_year1.
*          SORT li_jptmg0_2_iss BY ismnrinyear.
*          SORT li_jptmg0_2 BY matnr ismcopynr.
*
*          DATA: lst_jptmg0_2 LIKE LINE OF li_jptmg0_2.
*          DELETE li_jptmg0_2 WHERE ismpubldate+0(4) NE v_year."lv_year1.
*
*          IF li_jptmg0_2 IS NOT INITIAL.
*            READ TABLE li_jptmg0_2 INTO lst_jptmg0_2 INDEX 1.
*            IF sy-subrc = 0.
*              DATA(lv_st_vol) = lst_jptmg0_2-ismcopynr. "start volume
*            ENDIF. " IF sy-subrc = 0
*
*            READ TABLE li_jptmg0_2_iss INTO DATA(lst_jptmg0_2_iss) INDEX 1.
*            IF sy-subrc = 0.
*              DATA(lv_st_iss) = lst_jptmg0_2_iss-ismnrinyear.
*            ENDIF. " IF sy-subrc = 0
*
*            DATA(lv_line1) = lines( li_jptmg0_2 ).
*            lst_iss_vol2-matnr = lst_jptmg0_2-med_prod.
*            lst_iss_vol2-stvol = lv_st_vol.
*            lst_iss_vol2-stiss = lv_st_iss.
*            lst_iss_vol2-noi   = lv_line1.
*            APPEND lst_iss_vol2 TO i_iss_vol2.
*            CLEAR lst_iss_vol2.
*          ENDIF. " IF li_jptmg0_2 IS NOT INITIAL
*        ENDIF. " IF sy-subrc = 0
*      ENDIF. " IF lst_mara-ismhierarchlevl = lc_hier2
*    ENDIF. " IF sy-subrc = 0

** To get the current contract expiration.
    READ TABLE li_veda INTO lst_veda_subs WITH KEY vbeln = st_vbfa-vbelv
*  READ TABLE li_veda INTO lst_veda_subs WITH KEY vbeln = lst_vbap-vbeln
                                                    vposn = st_vbfa-posnv.
    IF sy-subrc EQ 0.
      lv_vbegdat_subs = lst_veda_subs-vbegdat.
      lv_venddat_subs  = lst_veda_subs-venddat.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE li_veda INTO lst_veda_subs WITH KEY vbeln = st_vbfa-vbelv
*    READ TABLE li_veda INTO lst_veda_subs WITH KEY vbeln = lst_vbap-vbeln
                                                      vposn = lc_posnr.
      IF sy-subrc EQ 0.
        lv_vbegdat_subs = lst_veda_subs-vbegdat.
        lv_venddat_subs  = lst_veda_subs-venddat.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
    IF lv_venddat_subs IS NOT INITIAL.
      CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
        EXPORTING
          idate                         = lv_venddat_subs
        IMPORTING
          day                           = lv_day
          month                         = lv_month_c2
          year                          = lv_year
          ltext                         = lv_month
        EXCEPTIONS
          input_date_is_initial         = 1
          text_for_month_not_maintained = 2
          OTHERS                        = 3.
      IF sy-subrc EQ 0.
        lv_month_c3 = lv_month(3).
        CONCATENATE lv_day
                    lv_month_c3
                    lv_year
                    INTO v_mbexp_date
                    SEPARATED BY lc_hyphen.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_venddat_subs IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

  IF i_iss_vol2 IS NOT INITIAL. " For Level 2 Product
    CLEAR lst_iss_vol2.
    READ TABLE i_iss_vol2 INTO lst_iss_vol2 WITH KEY matnr = fp_lv_matnr.
    IF sy-subrc = 0.
      v_start_issue = lst_iss_vol2-stiss. " Start Issue
      SHIFT v_start_issue LEFT DELETING LEADING c_zero.
      lv_volume_st = lst_iss_vol2-stvol.
      SHIFT lv_volume_st LEFT DELETING LEADING c_zero.
      v_volume_iss = lv_volume_st. "  Volume

      v_tot_issue = lst_iss_vol2-noi. " Total No. of Issue
      CONDENSE v_tot_issue.
    ENDIF. " IF sy-subrc = 0
  ELSE. " ELSE -> IF i_iss_vol2 IS NOT INITIAL

    IF fp_lv_matnr IS NOT INITIAL.
      SELECT product       " Media Product
             issue         " Media Issue
             shipping_date " IS-M: Delivery Date
             status        " IS-M: Status of Shipping Planning
             INTO TABLE i_jksenip
             FROM jksenip  " IS-M: Shipping Schedule
             WHERE product = fp_lv_matnr
*              AND shipping_date IN lir_cntrct_dat_qt.
               AND ( sub_valid_from  IN lir_cntrct_dat_qt
                OR   sub_valid_until IN lir_cntrct_dat_qt ).
      IF sy-subrc EQ 0 AND i_jksenip[] IS NOT INITIAL.
        DELETE i_jksenip WHERE status EQ c_stats_04 OR
                               status EQ c_stats_10.
      ENDIF. " IF sy-subrc EQ 0 AND i_jksenip[] IS NOT INITIAL
    ENDIF. " IF fp_lv_matnr IS NOT INITIAL

    IF i_jksenip IS NOT INITIAL.
      SELECT matnr       " Material Number
             ismnrinyear " Issue Number (in Year Number)matnr
             ismcopynr   " Volume
             INTO TABLE i_mara_vol
             FROM mara   " General Material Data
             FOR ALL ENTRIES IN i_jksenip
            WHERE matnr = i_jksenip-issue.
      IF sy-subrc EQ 0.
        SORT i_mara_vol BY matnr ismnrinyear ismcopynr.

        READ TABLE i_mara_vol INTO lst_mara_vol INDEX 1.
        v_start_issue = lst_mara_vol-ismnrinyear.
        SHIFT v_start_issue LEFT DELETING LEADING c_zero.
        DATA(li_mara_vol_tmp) = i_mara_vol[].

*  CLEAR lv_issues.
        SORT li_mara_vol_tmp BY ismcopynr.
        DELETE ADJACENT DUPLICATES FROM li_mara_vol_tmp COMPARING ismcopynr.
        DELETE li_mara_vol_tmp WHERE ismcopynr IS INITIAL.
        CLEAR lst_mara_vol.
        READ TABLE li_mara_vol_tmp INTO lst_mara_vol INDEX 1.
        lv_volume_st = lst_mara_vol-ismcopynr.
        SHIFT lv_volume_st LEFT DELETING LEADING c_zero.

        DESCRIBE TABLE li_mara_vol_tmp LINES lv_vol_count.
        IF lv_vol_count GT 1.
          READ TABLE li_mara_vol_tmp INTO lst_mara_vol INDEX lv_vol_count.
          IF sy-subrc EQ 0.
            SHIFT lst_mara_vol-ismcopynr LEFT DELETING LEADING c_zero.
            IF lv_volume_st IS NOT INITIAL.
              CONCATENATE lv_volume_st lst_mara_vol-ismcopynr INTO v_volume_iss
                                          SEPARATED BY c_char_hyphen.
            ELSE. " ELSE -> IF lv_volume_st IS NOT INITIAL
              v_volume_iss = lst_mara_vol-ismcopynr.
            ENDIF. " IF lv_volume_st IS NOT INITIAL
          ENDIF. " IF sy-subrc EQ 0
        ELSE. " ELSE -> IF lv_vol_count GT 1
          v_volume_iss = lv_volume_st.
        ENDIF. " IF lv_vol_count GT 1

* To get the total issues
        DESCRIBE TABLE i_jksenip LINES lv_issues.
        v_tot_issue = lv_issues.
        CONDENSE v_tot_issue.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF i_jksenip IS NOT INITIAL
  ENDIF. " IF i_iss_vol2 IS NOT INITIAL
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
*            Begin of ADD:I0231:WROY:02-Mar-2018:ED2K911163
             lc_bus_prcs_renwl TYPE zbus_prcocess VALUE 'R',  " Business Process - Renewal
             lc_prnt_vend_qi   TYPE zprint_vendor VALUE 'Q',  " Third Party System (Print Vendor) - QuickIssue
             lc_prnt_vend_bt   TYPE zprint_vendor VALUE 'B',  " Third Party System (Print Vendor) - BillTrust
             lc_parvw_re       TYPE parvw         VALUE 'RE', " Partner Function: Bill-To Party
*            End   of ADD:I0231:WROY:02-Mar-2018:ED2K911163
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'. " Communication Method (Key) (Business Address Services)

  DATA: lv_flag         TYPE char1, " Flag of type CHAR1
        lst_vbak        TYPE ty_vbak,
        lv_string       TYPE string,
        lv_waerk        TYPE waerk, " SD Document Currency
*       Begin of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911708
        lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
*       End   of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911708
        lv_bukrs        TYPE bukrs,     " Company Code
        lv_count        TYPE numc4,     " Count of type Integers
        lv_sl_count     TYPE numc4,     " Count of type Integers
        lv_iden         TYPE char10,    " Id of type CHAR6
        lv_acnt_num     TYPE char10,    " Account number to remove leading zeros
        lv_file_name    TYPE localfile, " Local file for upload/download
*       Begin of ADD:I0231:WROY:02-Mar-2018:ED2K911163
        lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region, " Print Region
        lv_country_sort TYPE zcountry_sort, " Country Sorting Key
        lv_file_loc     TYPE file_no,       " Application Server File Path
*       End   of ADD:I0231:WROY:02-Mar-2018:ED2K911163
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
* Fetch details from Addresses (Business Address Services)
    SELECT deflt_comm    " Communication Method (Key) (Business Address Services)
      FROM adrc          " Addresses (Business Address Services)
      INTO lv_deflt_comm " Businees address
     UP TO 1 ROWS
*     WHERE addrnumber = st_address-adrnr_we.
     WHERE addrnumber = st_address-adrnr_bp. "ED2K913751  NPOLINA
    ENDSELECT.
    IF sy-subrc IS INITIAL.
*   do nonthing
    ENDIF. " IF sy-subrc IS INITIAL

*   Begin of ADD:I0231:WROY:02-Mar-2018:ED2K911163
    IF lv_deflt_comm EQ lc_deflt_comm_let.
*     Identify Bill-to Party Details
      READ TABLE i_vbpa INTO DATA(lst_vbpa)
           WITH KEY vbeln = st_vbco3-vbeln
                    parvw = lc_parvw_re
           BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR: lst_vbpa.
      ENDIF. " IF sy-subrc NE 0

      CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
        EXPORTING
          im_bus_prcocess     = lc_bus_prcs_renwl " Business Process (Renewal)
          im_country          = lst_vbpa-land1    " Bill-to Party Country
          im_output_type      = nast-kschl        " Output Type
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
              im_ref_contract      = st_vbfa-vbelv     "SD Document Number (For Renewal Profile Determination)
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
*   End   of ADD:I0231:WROY:02-Mar-2018:ED2K911163
          LOOP AT fp_li_output INTO DATA(lst_output).
*           For passing in document number

*           Begin of DEL:I0231:WROY:02-Mar-2018:ED2K911163
*           IF lv_deflt_comm EQ lc_deflt_comm_let.
*           End   of DEL:I0231:WROY:02-Mar-2018:ED2K911163
*           Begin of DEL:ERP-7332:WROY:30-Mar-2018:ED2K911708
*           MOVE st_final-total_due TO lv_amount.
*           CONDENSE lv_amount.
*           End   of DEL:ERP-7332:WROY:30-Mar-2018:ED2K911708

            lv_count = lv_count + 1.
            READ TABLE i_vbak INTO lst_vbak WITH  KEY vbeln = st_vbco3-vbeln
                                                        BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              lv_waerk    = lst_vbak-waerk.
              lv_bukrs    = lst_vbak-bukrs_vf.
              lv_date     = lst_vbak-angdt.
            ENDIF. " IF sy-subrc IS INITIAL
*           Begin of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911708
            lv_bapi_amount = v_total.
*           Converts a currency amount from SAP format to External format
            CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
              EXPORTING
                currency    = lv_waerk        " Currency
                sap_amount  = lv_bapi_amount  " SAP format
              IMPORTING
                bapi_amount = lv_bapi_amount. " External format
            MOVE lv_bapi_amount TO lv_amount.
            CONDENSE lv_amount.
*           End   of ADD:ERP-7332:WROY:30-Mar-2018:ED2K911708

            IF lv_count <> 1.
              lv_sl_count = lv_sl_count + 1.
              CONCATENATE lc_sl
                          lv_sl_count
                      INTO lv_iden.
            ELSE. " ELSE -> IF lv_count <> 1
              lv_iden = lc_sap.
            ENDIF. " IF lv_count <> 1

*           ls_pdf_file-pdf = st_formoutput-pdf.
            ls_pdf_file-pdf = lst_output-pdf_stream.

            CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
              EXPORTING
                im_fpformoutput    = ls_pdf_file
*Begin of change NPALLA for INC0201178 on 09-Jul-2018 ED1K907933
*               im_customer        = st_vbco3-kunde  "-ED1K907933
                im_customer        = lst_vbpa-kunnr "+ED1K907933
*End of change NPALLA for INC0201178 on 03-Jul-2018 ED1K907933
                im_invoice         = st_vbco3-vbeln
                im_amount          = lv_amount
                im_currency        = lv_waerk
                im_date            = lv_date
                im_form_identifier = lv_iden
                im_ccode           = lv_bukrs
*               Begin of ADD:I0231:WROY:02-Mar-2018:ED2K911163
                im_file_loc        = lv_file_loc
*               End   of ADD:I0231:WROY:02-Mar-2018:ED2K911163
              IMPORTING
                ex_file_name       = lv_file_name.
            IF lv_file_name IS NOT INITIAL.

            ENDIF. " IF lv_file_name IS NOT INITIAL
*           Begin of DEL:I0231:WROY:02-Mar-2018:ED2K911163
*           ENDIF. " IF lv_deflt_comm EQ lc_deflt_comm_let
*           End   of DEL:I0231:WROY:02-Mar-2018:ED2K911163

          ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
*   Begin of ADD:I0231:WROY:02-Mar-2018:ED2K911163
        WHEN OTHERS.
*         Nothing to Do
      ENDCASE.
    ENDIF. " IF lv_deflt_comm EQ lc_deflt_comm_let
*   End   of ADD:I0231:WROY:02-Mar-2018:ED2K911163
  ENDIF. " IF fp_li_output IS NOT INITIAL
ENDFORM.
* Begin of change: PBANDLAPAL: 24-OCT-2017: ED2K909045
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
  DATA: lv_text           TYPE string,
        lv_txtmodule_data TYPE string,
        lst_arktx         TYPE zstqtc_arktx_f035,       " Structure for product description F035
        li_lines          TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_text_name      TYPE tdobname.                " Name

* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
  DATA: lst_jptidcdassign TYPE ty_jptidcdassign,
        lv_identcode      TYPE char20. " Identcode of type CHAR20

  CONSTANTS: lc_hyphen        TYPE char01         VALUE '-'. "Constant for hyphen
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241

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
      CONDENSE fp_prod_des.
* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
      CLEAR:lst_jptidcdassign.
      READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr =  st_vbap-matnr
                                                                 idcodetype = v_idcodetype_2
                                                                            BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_identcode = lst_jptidcdassign-identcode.
*** BOC BY SAYANDAS for CR6307 on 03-AUG-2018
*        CONCATENATE lv_identcode lv_text INTO lv_text SEPARATED BY lc_hyphen.
*        CONDENSE lv_text.
        lv_text = lv_identcode. " as we need only the Journal Code not the description
*** EOC BY SAYANDAS for CR6307 on 03-AUG-2018
      ENDIF. " IF sy-subrc IS INITIAL
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
*      READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign1) WITH KEY matnr =  st_vbap-matnr
*                                                                        idcodetype = v_idcodetype_1
*                                                                        BINARY SEARCH.
*      IF sy-subrc IS INITIAL.
*        v_issn = lst_jptidcdassign1-identcode.
****      Global variables has been used as the Form Intercae has been designed so
*      ENDIF. " IF sy-subrc IS INITIAL
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
**      Journal/description value
      CONCATENATE lv_text lst_arktx-journal_value INTO lst_arktx-journal_value.
      v_matnr_desc = lv_text. "This is added to use it in email portion
      CONDENSE v_matnr_desc.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

**      Journal/Description Text
  PERFORM read_text_module USING c_journal_txt
                           CHANGING lv_txtmodule_data.

  lst_arktx-journal_text = lv_txtmodule_data.
  APPEND lst_arktx TO i_arktx.
  CLEAR lst_arktx.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALCULATE_AND_BUILD_TAXDTLS
*&---------------------------------------------------------------------*
*  To Calculate and build tax details to populate in the form and email.
*----------------------------------------------------------------------*
*      -->P_LST_VBAP
*----------------------------------------------------------------------*
*FORM calculate_and_build_taxdtls  USING    fp_lst_vbap      TYPE ty_vbap.
*
*  DATA: lst_mara      TYPE ty_mara,
*        lst_konv      TYPE ty_konv,
*        lst_tax_dtls  TYPE ty_tax_dtls,
*        lv_konv_index TYPE syst_tabix,   " ABAP System Field: Row Index of Internal Tables
*        lv_kbetr_desc TYPE p DECIMALS 3. " Rate (condition amount or percentage).
*
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
** BOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
**    COLLECT lst_tax_dtls INTO i_tax_dtls.
** It is expected that the tax percentages will be same for the same product type
** if not our current design will not work.
*    READ TABLE i_tax_dtls ASSIGNING FIELD-SYMBOL(<fs_lst_tax_dtls>)
*                          WITH KEY ismmediatype = lst_mara-ismmediatype.
*    IF sy-subrc EQ 0.
*      IF <fs_lst_tax_dtls>-kbetr = lv_kbetr_desc AND fp_lst_vbap-kzwi6 IS NOT INITIAL.
*        <fs_lst_tax_dtls>-kzwi6 = <fs_lst_tax_dtls>-kzwi6 + fp_lst_vbap-kzwi6.
*      ENDIF.
*    ELSE.
*      IF lv_kbetr_desc IS NOT INITIAL AND fp_lst_vbap-kzwi6 IS INITIAL.
*        lst_tax_dtls-kbetr        = c_initial_prc.
*      ENDIF.
*      APPEND lst_tax_dtls TO i_tax_dtls.
*    ENDIF.
** EOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
*  ENDIF. " IF sy-subrc EQ 0
*
*ENDFORM.
* End of change: PBANDLAPAL: 24-OCT-2017: ED2K909045

* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_CONSTANT  text
*      <--P_R_IDCODETYPE  text
*----------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tt_constant.

  DATA: lst_constant   TYPE ty_constant.

  CONSTANTS: lc_devid        TYPE zdevid     VALUE 'F035',         " Development ID
             lc_idcodetype_1 TYPE rvari_vnam VALUE 'IDCODETYPE_1', " ABAP: Name of Variant Variable
             lc_idcodetype_2 TYPE rvari_vnam VALUE 'IDCODETYPE_2', " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
             lc_sanctioned_c TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*            End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
             lc_mtart_multi  TYPE rvari_vnam VALUE 'MULTI_JRNL_BOM', " ABAP: Name of Variant Variable
             lc_mtart_combo  TYPE rvari_vnam VALUE 'COMBO_BOM',      " ABAP: Name of Variant Variable
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
             lc_vkorg        TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variable
             lc_zlsch        TYPE rvari_vnam VALUE 'ZLSCH', " ABAP: Name of Variant Variable
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
             lc_kvgr1        TYPE rvari_vnam VALUE 'KVGR1', " ABAP: Name of Variant Variable  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
             lc_mat_grp5     TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
             lc_output_typ   TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_tax_id       TYPE rvari_vnam VALUE 'TAX_ID',
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE',
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
             lc_print        TYPE rvari_vnam VALUE 'PRINT_MEDIA_PRODUCT',
             lc_digital      TYPE rvari_vnam VALUE 'DIGITAL_MEDIA_PRODUCT'.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
  SELECT
     devid            " Development ID
     param1           " ABAP: Name of Variant Variable
     param2           " ABAP: Name of Variant Variable
     srno             " ABAP: Current selection number
     sign             " ABAP: ID: I/E (include/exclude values)
     opti             " ABAP: Selection option (EQ/BT/CP/...)
     low              " Lower Value of Selection Condition
     high             " Upper Value of Selection Condition
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE fp_i_constant
     WHERE  devid EQ lc_devid.

  IF sy-subrc IS INITIAL.
    SORT fp_i_constant BY param1.

    LOOP AT fp_i_constant INTO lst_constant.
      CASE lst_constant-param1.
        WHEN lc_idcodetype_1.
          v_idcodetype_1 = lst_constant-low.
        WHEN lc_idcodetype_2.
          v_idcodetype_2 = lst_constant-low.
        WHEN lc_mtart_multi.
          APPEND INITIAL LINE TO r_mtart_multi_bom ASSIGNING FIELD-SYMBOL(<lst_mtart_multi>).
          <lst_mtart_multi>-sign   = lst_constant-sign.
          <lst_mtart_multi>-option = lst_constant-opti.
          <lst_mtart_multi>-low    = lst_constant-low.
          <lst_mtart_multi>-high   = lst_constant-high.
        WHEN lc_mtart_combo.
          APPEND INITIAL LINE TO r_mtart_combo_bom ASSIGNING FIELD-SYMBOL(<lst_mtart_combo>).
          <lst_mtart_combo>-sign   = lst_constant-sign.
          <lst_mtart_combo>-option = lst_constant-opti.
          <lst_mtart_combo>-low    = lst_constant-low.
          <lst_mtart_combo>-high   = lst_constant-high.
*       Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
        WHEN lc_sanctioned_c.
          APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
          <lst_sanc_country>-sign   = lst_constant-sign.
          <lst_sanc_country>-option = lst_constant-opti.
          <lst_sanc_country>-low    = lst_constant-low.
          <lst_sanc_country>-high   = lst_constant-high.
*       End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
        WHEN lc_vkorg.
          APPEND INITIAL LINE TO r_vkorg_f044 ASSIGNING FIELD-SYMBOL(<lst_vkorg_f044>).
          <lst_vkorg_f044>-sign   = lst_constant-sign.
          <lst_vkorg_f044>-option = lst_constant-opti.
          <lst_vkorg_f044>-low    = lst_constant-low.
          <lst_vkorg_f044>-high   = lst_constant-high.

        WHEN lc_zlsch.
          APPEND INITIAL LINE TO r_zlsch_f044 ASSIGNING FIELD-SYMBOL(<lst_zlsch_f044>).
          <lst_zlsch_f044>-sign   = lst_constant-sign.
          <lst_zlsch_f044>-option = lst_constant-opti.
          <lst_zlsch_f044>-low    = lst_constant-low.
          <lst_zlsch_f044>-high   = lst_constant-high.
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*   Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
        WHEN lc_kvgr1.
          APPEND INITIAL LINE TO r_kvgr1_f044 ASSIGNING FIELD-SYMBOL(<lst_kvgr1_f044>).
          <lst_kvgr1_f044>-sign   = lst_constant-sign.
          <lst_kvgr1_f044>-option = lst_constant-opti.
          <lst_kvgr1_f044>-low    = lst_constant-low.
          <lst_kvgr1_f044>-high   = lst_constant-high.
*    End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
        WHEN lc_mat_grp5.
          APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
          <lst_mat_grp5>-sign   = lst_constant-sign.
          <lst_mat_grp5>-option = lst_constant-opti.
          <lst_mat_grp5>-low    = lst_constant-low.
          <lst_mat_grp5>-high   = lst_constant-high.

        WHEN lc_output_typ.
          APPEND INITIAL LINE TO r_output_typ ASSIGNING FIELD-SYMBOL(<lst_output_typ>).
          <lst_output_typ>-sign   = lst_constant-sign.
          <lst_output_typ>-option = lst_constant-opti.
          <lst_output_typ>-low    = lst_constant-low.
          <lst_output_typ>-high   = lst_constant-high.
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        WHEN lc_tax_id.
          v_tax_id  = lst_constant-low.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
        WHEN lc_comp_code.
          APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
          <lst_comp_code>-sign   = lst_constant-sign.
          <lst_comp_code>-option = lst_constant-opti.
          <lst_comp_code>-low    = lst_constant-low.
          <lst_comp_code>-high   = lst_constant-high.
        WHEN lc_docu_currency.
          APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
          <lst_docu_currency>-sign   = lst_constant-sign.
          <lst_docu_currency>-option = lst_constant-opti.
          <lst_docu_currency>-low    = lst_constant-low.
          <lst_docu_currency>-high   = lst_constant-high.
        WHEN lc_sales_office.
          APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
          <lst_sales_office>-sign   = lst_constant-sign.
          <lst_sales_office>-option = lst_constant-opti.
          <lst_sales_office>-low    = lst_constant-low.
          <lst_sales_office>-high   = lst_constant-high.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
        WHEN lc_print.
          APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lst_print_product>).
          <lst_print_product>-sign   = lst_constant-sign.
          <lst_print_product>-option = lst_constant-opti.
          <lst_print_product>-low    = lst_constant-low.
          <lst_print_product>-high   = lst_constant-high.
        WHEN lc_digital.
          APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lst_digital_product>).
          <lst_digital_product>-sign   = lst_constant-sign.
          <lst_digital_product>-option = lst_constant-opti.
          <lst_digital_product>-low    = lst_constant-low.
          <lst_digital_product>-high   = lst_constant-high.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
        WHEN OTHERS.
          " No need of OTHERS in this case
      ENDCASE.
      CLEAR lst_constant.
    ENDLOOP. " LOOP AT fp_i_constant INTO lst_constant
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_ADDRESS  text
*      <--P_I_STD_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_stxh_data  USING    fp_st_address  TYPE zstqtc_add_f035 " Structure for address node.
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
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F035*', " R of type CHAR10
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
    FROM stxh " STXD SAPscript text file header
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st
    AND tdspras = fp_st_address-spras.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
