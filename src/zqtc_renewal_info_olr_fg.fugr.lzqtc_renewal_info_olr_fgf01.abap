*----------------------------------------------------------------------
* PROGRAM NAME        : LZQTC_RENEWAL_INFO_OLR_FGF01
* PROGRAM DESCRIPTION : Subscription Renewal Information
* DEVELOPER           : Shubhanjali Sharma
* CREATION DATE       : 1/11/2017
* OBJECT ID           : I0337
* TRANSPORT NUMBER(S) : ED2K900927
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K906171, ED2K906173, ED2K906224, ED2K906258
* REFERENCE NO: JIRA Defect ERP-2160
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 17-MAy-2017
* DESCRIPTION: Tax amounts are not summing up correctly. The issue was due
* to not picking up all the entries from KONV when for all entries is used.
* To correct the same passed the full primary key in the select. Also to
* correct the population logic for Ismpubltype2.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906474
* REFERENCE NO: JIRA Defect ERP-2444
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 02-Jun-2017
* DESCRIPTION: Added additional conditions in the where clause of KONV to
* to include only statical condition types(KSTAT) and active conditions(KINAK)
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906697
* REFERENCE NO: JIRA Defect ERP-2730
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 02-Jun-2017
* DESCRIPTION: As JKSESCHED will not update for Media issues and SAP confirmed
*              thats JKSESCHED is updated only for subscription but not quotes.
*              Hence we have changed the logic to rerieve from JKSENIP table
*              to get the number of issues and also numbers of orders created.
*              Contract start dates and end dates are taken from quotation as
*              subscription has the previous year dates.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907521
* REFERENCE NO: JIRA Defect ERP-3548
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 26-Jul-2017
* DESCRIPTION: As per the previous design ISMPUBLTYPE2 field we were passing
*              converted value as 0 or 1. Now they wanted to revert back as
*              TIBCO will do the necessary conversion. Code has been reverted
*              done as part of ERP-2160 relevant for ISMPUBLTYPE2.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907736
* REFERENCE NO: ERP-3885
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 04-Aug-2017
* DESCRIPTION: As per new changes the mapping for KWERT_H and KWERT_D is
*              Changed to take it from VBAP-KZWI2 and VBAP-KZWI6.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K911268
* REFERENCE NO: ERP-6939
* DEVELOPER: WROY (Writtick Roy)
* DATE: 09-Mar-2018
* DESCRIPTION: Ignore Rejected Lines
*-----------------------------------------------------------------------*
* REVISION NO: ED2K911483
* REFERENCE NO: ERP-7171
* DEVELOPER: WROY (Writtick Roy)
* DATE: 20-Mar-2018
* DESCRIPTION: Modify logic for Validity Dates
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913244
* REFERENCE NO: ERP- 7316
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         31-Aug-2018
* DESCRIPTION:  Society name (NAME1,NAME2,NAME3 and NAME4) needs to
*               display in full on email renewal and OLR web landing page
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913530
* REFERENCE NO: CR7756
* DEVELOPER:    Nageswara Polina(NPOLINA)
* DATE:         05-Oct-2018
* DESCRIPTION:  Added new material groups
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909360
* REFERENCE NO: INC0226057
* DEVELOPER:    Nikhilesh Palla(NPALLA)
* DATE:         22-Jan-2019
* DESCRIPTION:  Changed select to correctly display the Number of Issues
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K920197
* REFERENCE NO: ERPM-15045
* DEVELOPER:    AMOHAMMED
* DATE:         11/04/2020
* DESCRIPTION:  Fetching the contract end date of the preceding document
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K912655
* REFERENCE NO: ERPM-15045 / INC0335945
* DEVELOPER:    Nikhilesh Palla(NPALLA)
* DATE:         29-Jan-2021
* DESCRIPTION:  Fetching the contract end date of the preceding document
*               If the contract dates not available form first non-zero
*               value of VBFA-POSNV, then get contract dates from the
*               header of the immediate preceeding document.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZQTC_RENEWAL_INFO_OLR_FGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&       Class (Implementation)  lclsubscription_renewal_info
*&---------------------------------------------------------------------*
*        Implementation of the different methods of class
*----------------------------------------------------------------------*
CLASS lclsubscription_renewal_info IMPLEMENTATION. " Renewal_info class

* Method to fetch data from database tables
  METHOD meth_fetch_data.

*   Local Data Declaration
    DATA:

*   Internal Tables
      li_adrc           TYPE tt_adrc,
      li_vbpa_sld       TYPE tt_vbpa,
      li_vbpa_shp       TYPE tt_vbpa,
      li_vbpa_za        TYPE tt_vbpa,
      li_mara           TYPE tt_mara,
      li_konv           TYPE tt_konv,
* Begin of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
      li_marc           TYPE TABLE OF ty_marc,
      li_mvke           TYPE TABLE OF ty_mvke,
      li_jksenip        TYPE TABLE OF ty_jksenip,
      lst_marc          TYPE  ty_marc,
      lst_mvke          TYPE ty_mvke,
      lst_jksenip       TYPE ty_jksenip,
      li_veda_quote     TYPE TABLE OF ty_veda_qt,
      lst_veda_quote    TYPE ty_veda_qt,
      lst_cntrct_dat_qt TYPE ty_cntrct_dat_qt,
      lir_cntrct_dat_qt TYPE RANGE OF vbdat_veda,
* End of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
      li_vbpa_bil       TYPE tt_vbpa,
      li_jks_temp       TYPE tt_jkses,
      li_jksesched      TYPE tt_jkses,

*   Variables
      lv_issue          TYPE ismmatnr_issue, " Media Issue
      lv_issue1         TYPE ismmatnr_issue, " Media Issue
      lv_copynr         TYPE ismheftnummer,  " Copy Number of Media Issue
      lv_kntyp          TYPE kntyp,          " Condition category (examples: tax, freight, price, cost)
      lv_kwert_h        TYPE kwert,          " Condition value
      lv_kwert_f        TYPE kwert,          " Condition value
      lv_kwert_d        TYPE kwert,          " Condition value
      lv_index_jk       TYPE syst_tabix,     " Tabix Value
      lv_vbegdat        TYPE vbdat_veda,     " Contract start date
      lv_venddat1       TYPE vndat_veda,     " Contract end date
*     Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
      lv_venddat2       TYPE vndat_veda,     " Contract end date
*     End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
      lv_record_x       TYPE i,              " Record_x of type Integers
      lv_media_issue    TYPE i,              " Media_issue of type Integers
      lv_length         TYPE i,              " Length of type Integers
      lv_length1        TYPE i,              " Length1 of type Integers
      lv_length2        TYPE i,              " Length2 of type Integers
      lv_frst           TYPE xfeld,          " Checkbox
      lv_last_fr        TYPE char4.          " Last_fr of type CHAR4


*   Field Symbol
    FIELD-SYMBOLS: <lst_fin>       TYPE zstqtc_subscrptn_renewal_info, " I0337 Subscription Renewal Information
                   <lst_ret_msg>   TYPE zstqtc_retmsg,                 " Structure for Return Messages
                   <lst_adrc>      TYPE ty_adrc,
                   <lst_konv>      TYPE ty_konv,
                   <lst_vbpa>      TYPE ty_vbpa,
                   <lst_jksesched> TYPE ty_jkses,
                   <lst_mara>      TYPE ty_mara.

*   Constants
    CONSTANTS: lc_kdkg2_02      TYPE char2 VALUE '02',   " Kdkg2_02 of type CHAR2
               lc_yes           TYPE char1 VALUE 'Y',    " Yes of type CHAR1
               lc_no            TYPE char1 VALUE 'N',    " No of type CHAR1
               lc_c             TYPE char1 VALUE 'C',    " C of type CHAR1
               lc_konda_3       TYPE char2 VALUE '03',   " Konda_3 of type CHAR2
               lc_parvw_ag      TYPE char2 VALUE 'AG',   " Parvw_rg of type CHAR2 Sold to Party
               lc_parvw_za      TYPE char2 VALUE 'ZA',   " Parvw_za of type CHAR2
               lc_parvw_we      TYPE char2 VALUE 'WE',   " Parvw_we of type CHAR2
               lc_parvw_rg      TYPE char2 VALUE 'RG',   " Parvw_rg of type CHAR2
               lc_publtyp_mj    TYPE char2 VALUE 'MJ',   " Publtyp_mj of type CHAR2
* Begin of Comment by PBANDLAPAL on 26-Jul-2017 for ERP-3548
*               lc_publtyp_mm    TYPE char2 VALUE 'MM',   " Publtyp_mj of type CHAR2  " Insert ERP-2160
* End of Comment by PBANDLAPAL on 26-Jul-2017 for ERP-3548
               lc_kntyp_h       TYPE char1 VALUE 'H',    " Kntyp_h of type CHAR1
               lc_kntyp_f       TYPE char1 VALUE 'F',    " Kntyp_f of type CHAR1
               lc_kntyp_d       TYPE char1 VALUE 'D',    " Kntyp_d of type CHAR1
               lc_error         TYPE char1 VALUE 'E',    " Error of type CHAR1
               lc_devid         TYPE zdevid VALUE 'I0337',          " Development ID
               lc_char_blank    TYPE char1 VALUE '',   " Insert for Defect ERP-2444
               lc_char_zeros    TYPE char1 VALUE '0',
               lc_idcodtyp_zssn TYPE char4 VALUE 'ZSSN'. "'ZSSN'.

* Begin by AMOHAMMED on 11/04/2020 TR # ED2K920197
    DATA : li_renew  TYPE STANDARD TABLE OF zqtc_renwl_plan,
           lst_renew TYPE zqtc_renwl_plan,
           li_vbfa_t TYPE STANDARD TABLE OF vbfa,
           li_veda_t TYPE STANDARD TABLE OF ty_veda_qt.
    CLEAR lst_renew.
    REFRESH : li_renew, li_vbfa_t, li_veda_t.
* End by AMOHAMMED on 11/04/2020 TR # ED2K920197

    CLEAR:
    lv_index_jk,              "Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
    lv_record_x,
    lv_issue,
    lv_media_issue,
    lv_length ,
    lv_last_fr,
    lv_kntyp,
    lv_kwert_d,
    lv_kwert_h,
    lv_kwert_f.

    FREE: ex_data_tab[],
          ex_t_return_msg[].

* To validate if quotation exists in the system or not.
    IF im_quoteid IS NOT INITIAL.
      SELECT SINGLE vbeln INTO @DATA(lv_vbeln)
           FROM vbak
        WHERE vbeln = @im_quoteid.
      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
        <lst_ret_msg>-msgty = lc_error.
        CONCATENATE im_quoteid text-002 INTO <lst_ret_msg>-message SEPARATED BY space.
      ELSE.
        CLEAR lv_vbeln.
      ENDIF.
    ENDIF.

    IF ex_t_return_msg[] IS INITIAL.
*  Fetch data from ZCACONSTANT
      SELECT  devid      " Development ID
              param1     " ABAP: Name of Variant Variable
              param2     " ABAP: Name of Variant Variable
              srno       " ABAP: Current selection number
              sign       " ABAP: ID: I/E (include/exclude values)
              opti       " ABAP: Selection option (EQ/BT/CP/...)
              low        " Lower Value of Selection Condition
              high       " Upper Value of Selection Condition
        FROM zcaconstant " Wiley Application Constant Table
        INTO TABLE ch_constant
        WHERE devid = lc_devid
          AND activate = abap_true.
      IF sy-subrc EQ 0.
        SORT ch_constant BY param1.
      ENDIF. " IF sy-subrc IS INITIAL

*  Check if the subscription already exists
      SELECT vbelv, " Preceding sales and distribution document
             posnv, "Preceding item of an SD document
             vbeln, "Subsequent sales and distribution document
             posnn  "Subsequent item of an SD document
        FROM vbfa   " Sales Document Flow
        INTO TABLE @DATA(li_vbfa)
        WHERE vbeln EQ @im_quoteid.
      IF sy-subrc = 0.
        SORT li_vbfa BY vbeln.
      ENDIF. " IF sy-subrc = 0

      READ TABLE li_vbfa ASSIGNING FIELD-SYMBOL(<lst_vbfa>)
      WITH KEY vbeln = im_quoteid
      BINARY SEARCH.
      IF sy-subrc = 0.
*     Subscription already renewed only if it doesn't exist then we create a renewal order
        IF <lst_vbfa>-vbelv IS INITIAL.
          APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
          <lst_ret_msg>-msgty = lc_error.
          <lst_ret_msg>-message = text-001.
        ENDIF.
      ENDIF.
    ENDIF.

    IF ex_t_return_msg[] IS INITIAL.
*       Fetch the subscription data from the various database tables:
*       Fetch Sales document data from VBAK comparing quotation ID, then based on VBAK-VBELN
*       fetch data from tables VBAP, VBKD, VBPA, VBUK, KONV (where KNTYP = F, D, H)
*       Based on VBAP-MATNR, fetch publication details from MARA
*       Based on MARA-MATNR, fetch identification code details from
*       jptidcassign. Based on VBAP-VBELN, fetch media issue details from JKSESCHED
      SELECT DISTINCT
        vbak~vbeln,        "Sales Document
        vbak~waerk,        "SD Document Currency
        vbak~vkorg,        "Sales Organization     "Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
        vbak~knumv,        "Number of the document condition
        vbap~posnr,        "Item
        vbap~matnr ,       "Material Number
        vbap~netwr ,       "Net value of the order item in document currency
* BOI: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
        vbap~kzwi2,        " Subtotal 2 from pricing procedure for condition
        vbap~kzwi6,        " Subtotal 6 from pricing procedure for condition
* EOI: 04-Aug-2017 : PBANDLAPAL :  ERP-3885: ED2K907736
* SOC 05-Oct-2018 : NPOLINA CR7756  : ED2K913530
        vbap~mvgr1,
        vbap~mvgr2,
        vbap~mvgr3,
        vbap~mvgr4,
        vbap~mvgr5,
* EOC 05-Oct-2018 : NPOLINA CR7756   : ED2K913530
        vbfa~vbelv,        "Preceding sales and distribution document
        vbfa~posnv,        "Preceding item of sales and distribution document
*       Begin of ADD:INC0335945:NPALLA:29-Jan-2021:ED1K912655
        vbfa~stufe,        "Level of the document flow record ++ED1K912655
*       End   of ADD:INC0335945:NPALLA:29-Jan-2021:ED1K912655
        veda~vbegdat,      "Contract Start date
        veda~venddat,      "Contract End date
*       Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
        veda~vposn,        "Sales Document Item
*       End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
        vbkd~konda ,       "Price group (customer)
        vbkd~bstkd ,       "Customer Purchase Order Number
        vbkd~ihrez ,       "Your Reference
        vbkd~kdkg2 ,       "Customer condition group 2
        vbpa~parvw,        "Partner Function
        vbpa~kunnr,        "Customer
        vbpa~adrnr ,       "Address Number
        vbuk~rfstk  ,      "Reference document header status
        jpt~idcodetype,    "Type of Identification Code
        jpt~identcode  ,   "Identification Code
        mara~extwg,        "External Customer Group
        mara~ismtitle,     "Title
        mara~ismpubltype,  "Publication Type
        mara~ismmediatype, "Media Type
        mara~ismissue,     "Issue
        mara~ismpubldate,  "Publication Date
        mara~ismcopynr,    "Copy Number of Media Issue
        adrc~name1,        "Name1
        adrc~country,      "Country
        adr6~smtp_addr     "Email-address
        FROM vbak AS vbak
        INNER JOIN vbap AS vbap
        ON   ( vbap~vbeln EQ vbak~vbeln )
        LEFT OUTER JOIN vbfa
        ON   ( vbfa~vbeln EQ vbak~vbeln )
        LEFT OUTER JOIN veda AS veda
        ON   ( veda~vbeln EQ vbfa~vbelv )
*          AND veda~vposn EQ vbfa~posnv
        LEFT OUTER JOIN vbkd AS vbkd
        ON ( vbkd~vbeln EQ vbap~vbeln
        AND  vbkd~posnr EQ vbap~posnr )
        LEFT OUTER JOIN vbpa AS vbpa
        ON  ( vbpa~vbeln EQ vbap~vbeln )
*          AND vbpa~posnr EQ vbap~posnr
        AND ( vbpa~parvw IN (@lc_parvw_rg , @lc_parvw_we , @lc_parvw_za, @lc_parvw_ag) )
        LEFT OUTER JOIN vbuk AS vbuk
        ON ( vbuk~vbeln EQ vbak~vbeln )
        LEFT OUTER JOIN jptidcdassign AS jpt
        ON  ( jpt~matnr EQ vbap~matnr
        AND jpt~idcodetype EQ @lc_idcodtyp_zssn )
        LEFT OUTER JOIN mara AS mara
        ON ( mara~matnr EQ  vbap~matnr )
        LEFT OUTER JOIN adrc AS adrc
        ON ( adrc~addrnumber EQ vbpa~adrnr )
        LEFT OUTER JOIN adr6 AS adr6
        ON ( adr6~addrnumber EQ vbpa~adrnr )
        INTO TABLE @DATA(li_data)
        WHERE vbak~vbeln EQ @im_quoteid
*         Begin of ADD:ERP-6939:WROY:09-Mar-2018:ED2K911268
          AND vbap~abgru EQ @space.
*         End   of ADD:ERP-6939:WROY:09-Mar-2018:ED2K911268

*       Append error message in the message table
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
        <lst_ret_msg>-msgty = lc_error.
        <lst_ret_msg>-message = text-007.

      ELSE. " ELSE -> IF sy-subrc <> 0

        DELETE li_data WHERE posnr IS INITIAL.
*        DELETE li_data WHERE posnv IS INITIAL.
        IF li_data IS INITIAL.
*       Append error message in the message table
          APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
          <lst_ret_msg>-msgty = lc_error.
          <lst_ret_msg>-message = text-007.
        ELSE. " ELSE -> IF li_data IS INITIAL

*      Delete the document flow details where POSNV is initial
          DELETE li_vbfa WHERE posnv IS INITIAL.

*     Obtain Condition Value Details from KONV table
          DATA(li_data_temp) = li_data.
          SORT li_data_temp BY posnr knumv.
          DELETE ADJACENT DUPLICATES FROM li_data_temp COMPARING posnr knumv.
          SELECT
            knumv     "Number of the document condition
            kposn     "Condition item number
            kntyp     "Condition category (examples: tax, freight, price, cost)
* BOC by PBANDLAPAL on 05-May-2017 for ERP-2160
            stunr
            zaehk
* EOC by PBANDLAPAL on 05-May-2017 for ERP-2160
            kwert     "Condition value
            FROM konv " Conditions (Transaction Data)
            INTO TABLE li_konv
            FOR ALL ENTRIES IN li_data_temp
            WHERE knumv = li_data_temp-knumv
            AND kposn = li_data_temp-posnr
            AND kntyp IN ( lc_kntyp_h , lc_kntyp_f, lc_kntyp_d )
* Begin of Insert by PBANDLAPAL on 06/02/2017 for Defect ERP-2444
            AND kstat EQ lc_char_blank
            AND kinak EQ lc_char_blank.
* End of Insert by PBANDLAPAL on 06/02/2017 for Defect ERP-2444.

          IF sy-subrc = 0.
*          Delete records where KNTYP or KPOSN is blank
            SORT li_konv BY kposn kntyp.
            DELETE li_konv WHERE kposn IS INITIAL.
            DELETE li_konv WHERE kntyp IS INITIAL.
          ENDIF. " IF sy-subrc = 0
          FREE: li_data_temp.

* Begin of Comment on 18-JuL-2017 by PBANDLAPAL for ERP-2730
**     Obtain Issue details from JKSESCHED table
*          DATA(li_vbfa_temp) = li_vbfa[].
** Begin of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
**          SORT li_vbfa_temp BY vbelv posnv.
**          DELETE ADJACENT DUPLICATES FROM li_vbfa_temp COMPARING vbelv posnv.
** End of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
*          SELECT
*            vbeln          "Sales and Distribution Document Number
*            posnr          "Item Number of the SD Document
*            issue          "Media Issue
*            product        "Media Product
*            sequence       "Sequence
*            xorder_created "IS-M: Indicator Denoting that Order Was Generated
*            FROM jksesched " IS-M: Media Schedule Lines
*            INTO TABLE li_jksesched
** Begin of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
**            FOR ALL ENTRIES IN li_vbfa_temp
**            WHERE vbeln = li_vbfa_temp-vbelv
**            AND posnr = li_vbfa_temp-posnv.
*            WHERE vbeln = im_quoteid.
** End of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
*          IF sy-subrc = 0.
*            SORT li_jksesched BY posnr issue ASCENDING.
*            li_jks_temp[] = li_jksesched[].
*            SORT li_jks_temp BY issue.
*            DELETE ADJACENT DUPLICATES FROM li_jks_temp COMPARING issue.
*            IF li_jks_temp IS NOT INITIAL.
*
*              SELECT
*                matnr     "Material Number
*                ismcopynr "Number of copies
*                FROM mara " General Material Data
*                INTO TABLE li_mara
*                FOR ALL ENTRIES IN li_jks_temp
*                WHERE matnr = li_jks_temp-issue.
*              IF sy-subrc = 0.
*                SORT li_mara BY matnr ASCENDING.
*              ENDIF. " IF sy-subrc = 0
*              FREE: li_jks_temp.
*            ENDIF. " IF li_jks_temp IS NOT INITIAL
*          ENDIF. " IF sy-subrc = 0
* End of Comment on 18-JuL-2017 by PBANDLAPAL for ERP-2730
* Begin of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
          SELECT vbeln
                 vposn
                 vbegdat
                 venddat
                 INTO TABLE li_veda_quote
                 FROM veda
                 WHERE vbeln = im_quoteid.
          IF sy-subrc EQ 0.
* We are reading only the first entry from VEDA because header and item always
* will have the same contract start and end dates.
*           Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
*           Ignore Header Dates (If Item level data is available)
            SORT li_veda_quote BY vposn.
            DATA(li_veda_quote_t) = li_veda_quote.
            DELETE li_veda_quote WHERE vposn IS INITIAL.
            IF li_veda_quote IS INITIAL.
              li_veda_quote = li_veda_quote_t.
            ENDIF.
*           End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
            READ TABLE li_veda_quote  INTO lst_veda_quote INDEX 1.
            IF sy-subrc EQ 0.
*             Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
              lv_venddat2 = lst_veda_quote-venddat.
              lv_vbegdat  = lst_veda_quote-vbegdat.
*             End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
              lst_cntrct_dat_qt-sign  = c_sign_i.
              lst_cntrct_dat_qt-option = c_option_bt.
              lst_cntrct_dat_qt-low    = lst_veda_quote-vbegdat.
              lst_cntrct_dat_qt-high   = lst_veda_quote-venddat.
              APPEND lst_cntrct_dat_qt TO lir_cntrct_dat_qt.
            ENDIF.
          ENDIF.
          li_data_temp[] = li_data[].
          SORT li_data_temp BY matnr vkorg.
          DELETE ADJACENT DUPLICATES FROM li_data_temp COMPARING matnr vkorg.
          IF li_data_temp[] IS NOT  INITIAL.
            SELECT product
                   issue
                   shipping_date
                   status
                   INTO TABLE li_jksenip
                   FROM jksenip
                   FOR ALL ENTRIES IN li_data_temp
                   WHERE product = li_data_temp-matnr
*                    Begin of Change:INC0226057:NPALLA:22-Jan-2019:ED1K909360
*                     AND shipping_date IN lir_cntrct_dat_qt.
                     AND ( sub_valid_from  IN lir_cntrct_dat_qt
                      OR   sub_valid_until IN lir_cntrct_dat_qt ).
*                    End of Change:INC0226057:NPALLA:22-Jan-2019:ED1K909360
            IF sy-subrc EQ 0 AND li_jksenip[] IS NOT INITIAL.
              DELETE li_jksenip WHERE status EQ c_stats_04 OR
                                      status EQ c_stats_10.
              SORT li_jksenip BY product issue shipping_date.
              SELECT matnr
                     dwerk
                     INTO TABLE li_mvke
                     FROM mvke
                     FOR ALL ENTRIES IN li_jksenip
                     WHERE matnr = li_jksenip-issue.
              IF sy-subrc EQ 0 AND li_mvke IS NOT INITIAL.
                SORT li_mvke BY matnr dwerk.
                SELECT matnr
                       werks
                       ismarrivaldateac
                       INTO TABLE li_marc
                       FROM marc
                       FOR ALL ENTRIES IN li_mvke
                       WHERE matnr = li_mvke-matnr
                         AND werks = li_mvke-dwerk.
                IF sy-subrc EQ 0.
                  SORT li_marc BY matnr werks.
                ENDIF.
              ENDIF.
              SELECT matnr
                     ismcopynr
                     ismnrinyear
                    INTO TABLE li_mara
                   FROM mara
                   FOR ALL ENTRIES IN li_jksenip
                   WHERE matnr = li_jksenip-issue.
              IF sy-subrc EQ 0.
                SORT li_mara BY matnr.
              ENDIF.
            ENDIF.
          ENDIF.
          FREE: li_data_temp.
* End of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730

*     Obtain the address details from ADRC table
          li_data_temp[] = li_data[].
          SORT li_data_temp BY adrnr.
          DELETE ADJACENT DUPLICATES FROM li_data_temp
          COMPARING adrnr.
          IF li_data_temp[] IS NOT INITIAL.
            SELECT
              addrnumber "Address Number
              name1      "Name1
*     Begin of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
              name2      "Name2
              name3      "Name3
              name4      "Name4
*     End of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
              street     "Street
              house_num1 "House Number
              city1      "City
              region     "Region
              post_code1 "Post Code1
              country    "Country
              FROM adrc  " Addresses (Business Address Services)
              INTO TABLE li_adrc
              FOR ALL ENTRIES IN li_data_temp
              WHERE addrnumber EQ li_data_temp-adrnr
              AND date_from < sy-datum
              AND date_to > sy-datum.

            IF sy-subrc = 0.
              SORT li_adrc BY addrnumber.
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF li_data_temp[] IS NOT INITIAL
          FREE: li_data_temp.

*      Obtain the bill-to and ship-to information in different tables
          li_data_temp[] = li_data[].
          SORT li_data_temp BY vbeln posnr parvw.
          DELETE ADJACENT DUPLICATES FROM li_data_temp COMPARING vbeln posnr parvw.
          LOOP AT li_data_temp ASSIGNING FIELD-SYMBOL(<lst_data>).
*           Obtain data in Bill-to table
            IF <lst_data>-parvw = lc_parvw_rg .
              APPEND INITIAL LINE TO li_vbpa_bil ASSIGNING <lst_vbpa>.
              <lst_vbpa>-vbeln = <lst_data>-vbeln.
              <lst_vbpa>-posnr = <lst_data>-posnr.
              <lst_vbpa>-parvw = <lst_data>-parvw.
              <lst_vbpa>-adrnr = <lst_data>-adrnr.
              <lst_vbpa>-kunnr = <lst_data>-kunnr.
*           Obtain data in ship-to table
            ELSEIF <lst_data>-parvw = lc_parvw_we .
              APPEND INITIAL LINE TO li_vbpa_shp ASSIGNING <lst_vbpa>.
              <lst_vbpa>-vbeln = <lst_data>-vbeln.
              <lst_vbpa>-posnr = <lst_data>-posnr.
              <lst_vbpa>-parvw = <lst_data>-parvw.
              <lst_vbpa>-adrnr = <lst_data>-adrnr.
              <lst_vbpa>-kunnr = <lst_data>-kunnr.
            ELSEIF <lst_data>-parvw = lc_parvw_za.
              APPEND INITIAL LINE TO li_vbpa_za ASSIGNING <lst_vbpa>.
              <lst_vbpa>-vbeln = <lst_data>-vbeln.
              <lst_vbpa>-posnr = <lst_data>-posnr.
              <lst_vbpa>-parvw = <lst_data>-parvw.
              <lst_vbpa>-adrnr = <lst_data>-adrnr.
              <lst_vbpa>-kunnr = <lst_data>-kunnr.
            ELSEIF <lst_data>-parvw = lc_parvw_ag.
              <lst_data>-parvw = lc_parvw_ag.
              APPEND INITIAL LINE TO li_vbpa_sld ASSIGNING <lst_vbpa>.
              <lst_vbpa>-vbeln = <lst_data>-vbeln.
              <lst_vbpa>-posnr = <lst_data>-posnr.
              <lst_vbpa>-parvw = <lst_data>-parvw.
              <lst_vbpa>-adrnr = <lst_data>-adrnr.
              <lst_vbpa>-kunnr = <lst_data>-kunnr.
            ENDIF. " IF <lst_data>-parvw = lc_parvw_rg
          ENDLOOP. " LOOP AT li_data_temp ASSIGNING FIELD-SYMBOL(<lst_data>)
          SORT li_vbpa_shp BY adrnr.
          SORT li_vbpa_bil BY adrnr.
          SORT li_vbpa_za BY posnr.

          FREE: li_data_temp.

*     Obtain the contract dates for the first non-zero value of
*      VBFA-POSNV,
*     if the contract dates not available form first non-zero value of VBFA-POSNV   ++
*     then get contract dates from the header of the immediate preceeding document. ++
*          Begin of DEL:INC0335945:NPALLA:29-Jan-2021:ED1K912655
*          li_data_temp[] = li_data[].
*          SORT li_data_temp BY posnv ASCENDING.
**         Begin of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483
**         DELETE li_data_temp WHERE posnv IS INITIAL.
**         End   of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483
**         Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
*          DELETE li_data_temp WHERE vposn IS INITIAL.
*          IF li_data_temp IS INITIAL.
*            li_data_temp[] = li_data[].
*            SORT li_data_temp BY posnv ASCENDING.
*          ENDIF.
**         End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
*
*          IF li_data_temp IS NOT INITIAL.
*            READ TABLE li_data_temp ASSIGNING <lst_data>
*            INDEX 1.
*          End   of DEL:INC0335945:NPALLA:29-Jan-2021:ED1K912655
*         Begin of ADD:INC0335945:NPALLA:29-Jan-2021:ED1K912655
          CONSTANTS: lc_00 TYPE stufe_vbfa VALUE '00'.
          li_data_temp[] = li_data[].
          SORT li_data_temp BY posnv ASCENDING.
          LOOP AT li_data_temp ASSIGNING <lst_data> WHERE stufe = lc_00.
            lv_venddat1 = <lst_data>-venddat.
            IF <lst_data>-posnv IS NOT INITIAL.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF sy-subrc = 0.
*         End   of ADD:INC0335945:NPALLA:29-Jan-2021:ED1K912655

* Begin by AMOHAMMED on 11/04/2020 TR # ED2K920197
* Commentted old code
*            lv_venddat1 = <lst_data>-venddat.

* When the Quotation is created without reference but using BNAME field
* Fetching the contract end date of the preceding document
            IF <lst_data>-venddat IS NOT INITIAL.
              lv_venddat1 = <lst_data>-venddat.
            ELSEIF sy-subrc EQ 0 AND <lst_data>-venddat IS INITIAL.
              " Pass the quotation to the FM and get the preceding document (Contract number)
              lst_renew-vbeln = im_quoteid.
              APPEND lst_renew TO li_renew.
              CALL FUNCTION 'ZQTC_GET_CONTRACT_FUTURE_E095'
                TABLES
                  t_renew = li_renew
                  t_vbfa  = li_vbfa_t.
              IF li_vbfa_t IS NOT INITIAL.
                READ TABLE li_vbfa_t ASSIGNING FIELD-SYMBOL(<lst_vbfa_t>) INDEX 1.
                IF sy-subrc EQ 0 AND <lst_vbfa_t>-vbelv IS NOT INITIAL.
                  " When contract found, fetch the contract end date from VEDA table
                  SELECT vbeln vposn vbegdat venddat FROM veda INTO TABLE li_veda_t WHERE vbeln EQ <lst_vbfa_t>-vbelv.
                  IF sy-subrc EQ 0.
                    SORT li_veda_t BY vposn DESCENDING.
                    " If line item is available assign the contract end date of line item
                    " If only header is available assign the contract end date of header
                    LOOP AT li_veda_t ASSIGNING FIELD-SYMBOL(<lst_veda>).
                      lv_venddat1 = <lst_data>-venddat = <lst_veda>-venddat.
                      MODIFY li_data FROM <lst_data> TRANSPORTING venddat WHERE vbeln EQ im_quoteid.
                      EXIT.
                    ENDLOOP.
                  ENDIF. " IF sy-subrc EQ 0.
                ENDIF. " IF sy-subrc EQ 0 AND <lst_vbfa_t>-vbelv IS NOT INITIAL.
              ENDIF. " IF li_vbfa_t IS NOT INITIAL.
            ENDIF. " IF <lst_data>-venddat IS NOT INITIAL.
* End by AMOHAMMED on 11/04/2020 TR # ED2K920197

*           Begin of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483
*           lv_vbegdat  = <lst_data>-vbegdat.
*           End   of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483
          ENDIF. " IF li_data_temp IS NOT INITIAL

          FREE: li_data_temp.

          FREE: li_data_temp.

          SORT li_data BY posnr matnr parvw.
          DELETE ADJACENT DUPLICATES FROM li_data COMPARING posnr matnr.

          SORT li_data BY posnr.

*     Populate the final table
          LOOP AT li_data ASSIGNING <lst_data>.
            APPEND INITIAL LINE TO ex_data_tab ASSIGNING <lst_fin>.
*
*       Your Reference
            <lst_fin>-ihrez = <lst_data>-ihrez.

*       Contract End Date
            <lst_fin>-venddat1 = lv_venddat1.

*       Price Group (Customer)
            <lst_fin>-konda1 = <lst_data>-konda.

*       Customer Condition Group
            IF <lst_data>-kdkg2 EQ lc_kdkg2_02.
              <lst_fin>-kdkg2 = lc_yes.
            ELSE. " ELSE -> IF <lst_data>-kdkg2 EQ lc_kdkg2_02
              <lst_fin>-kdkg2 = lc_no.
            ENDIF. " IF <lst_data>-kdkg2 EQ lc_kdkg2_02

*       Publication Type
            IF <lst_data>-ismpubltype = lc_publtyp_mj.
              <lst_fin>-ismpubltype1 = lc_yes.
            ELSE. " ELSE -> IF <lst_data>-ismpubltype = lc_publtyp_mj
              <lst_fin>-ismpubltype1 = lc_no.
            ENDIF. " IF <lst_data>-ismpubltype = lc_publtyp_mj


*       Identification Code 1
            IF <lst_data>-idcodetype = lc_idcodtyp_zssn.
              <lst_fin>-identcode1 = <lst_data>-identcode.
            ENDIF. " IF <lst_data>-idcodetype = lc_idcodtyp_zssn

*       Reference document header status
            IF <lst_data>-rfstk = lc_c.
              <lst_fin>-rfstk = lc_yes.
            ELSE. " ELSE -> IF <lst_data>-rfstk = lc_c
              <lst_fin>-rfstk = lc_no.
            ENDIF. " IF <lst_data>-rfstk = lc_c

*       First Name and Customer
            READ TABLE li_vbpa_za ASSIGNING <lst_vbpa>
            WITH KEY posnr = <lst_data>-posnr
                     BINARY SEARCH.
            IF sy-subrc = 0.
*           First Name
              READ TABLE li_adrc INTO DATA(lst_adrc_za) WITH KEY addrnumber = <lst_vbpa>-adrnr.
              IF sy-subrc EQ 0.
                <lst_fin>-name1 = lst_adrc_za-name1.
*     Begin of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
                <lst_fin>-name2 = lst_adrc_za-name2.
                <lst_fin>-name3 = lst_adrc_za-name3.
                <lst_fin>-name4 = lst_adrc_za-name4.
*     End of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
              ENDIF.

*           Customer
              <lst_fin>-kunnr = <lst_vbpa>-kunnr.

            ENDIF. " IF sy-subrc = 0

* To pass BP customer ID (sold to)
            READ TABLE li_vbpa_sld ASSIGNING <lst_vbpa>
               WITH KEY posnr = <lst_data>-posnr
                        BINARY SEARCH.
            IF sy-subrc EQ 0.
              <lst_fin>-bpkunnr = <lst_vbpa>-kunnr.
            ENDIF.
*      External Customer Group
            <lst_fin>-extwg = <lst_data>-extwg.

*       ISM Title
            <lst_fin>-ismtitle = <lst_data>-ismtitle.

*       Identification Code 2
            IF <lst_data>-idcodetype = lc_idcodtyp_zssn.
              <lst_fin>-identcode2 = <lst_data>-identcode.
            ENDIF. " IF <lst_data>-idcodetype = lc_idcodtyp_zssn

*       Publication Type
* Begin of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3548
* As this conversion is being done in the TIBCO they want to revert it from SAP
** BOC by PBANDLAPAL on 18-May-2017 for ERP-2160
            <lst_fin>-ismpubltype2 = <lst_data>-ismpubltype.
*            IF <lst_data>-ismpubltype = lc_publtyp_mj OR
*               <lst_data>-ismpubltype = lc_publtyp_mm.
*              <lst_fin>-ismpubltype2 = 0.
*            ELSE.
*              <lst_fin>-ismpubltype2 = 1.
*            ENDIF.
** EOC by PBANDLAPAL on 18-May-2017 for ERP-2160
* End of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3548

*       Media Type
            <lst_fin>-ismmediatype = <lst_data>-ismmediatype.

** Begin of Comment on 18-Jul-2017 by PBANDLAPAL for ERP-2730
** Begin of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
**            READ TABLE li_vbfa ASSIGNING <lst_vbfa>
**            WITH KEY posnn = <lst_data>-posnr.
**            IF sy-subrc = 0.
**              CLEAR: lv_frst.
**              LOOP AT li_jksesched ASSIGNING <lst_jksesched>
**                 WHERE posnr = <lst_vbfa>-posnv.
*            CLEAR: lv_frst.
*            LOOP AT li_jksesched ASSIGNING <lst_jksesched>
*                     WHERE posnr = <lst_data>-posnr.
** End of Change on 12-Jun-2017 by PBANDLAPAL for ERP-2730
*              IF lv_frst IS INITIAL.
*                lv_frst = abap_true.
*                CLEAR:
*                lv_copynr,
*                lv_media_issue,
*                lv_last_fr,
*                lv_record_x.
*
**             Read the copynr from MARA based on first issue
*                READ TABLE li_mara ASSIGNING <lst_mara>
*                WITH KEY matnr = <lst_jksesched>-issue
*                BINARY SEARCH.
*                IF sy-subrc = 0.
**           Copy Number of Media Issue
*                  <lst_fin>-ismcopynr = <lst_mara>-ismcopynr.
*                  SHIFT <lst_fin>-ismcopynr LEFT DELETING LEADING lc_char_zeros.
*                  lv_copynr = <lst_mara>-ismcopynr.
*                ENDIF. " IF sy-subrc = 0
*
*                IF <lst_jksesched>-issue IS NOT INITIAL.
*                  lv_issue1 = <lst_jksesched>-issue.
*                  lv_length = strlen( <lst_jksesched>-issue ).
*                  lv_length1 = lv_length - 1.
*                  lv_issue = <lst_jksesched>-issue+0(lv_length1).
*                  lv_length2 = lv_length - 5.
*
**             Obtain last 4 digits of media issue
*                  lv_last_fr = lv_issue+lv_length2.
*
**            Media Issue
*                  <lst_fin>-issue = lv_last_fr.
*                  SHIFT <lst_fin>-issue LEFT DELETING LEADING lc_char_zeros.
**            Media Issue 2
*                  lv_media_issue = lv_media_issue + 1.
*
**           Count the number of X-Order Created
*                  IF <lst_jksesched>-xorder_created = abap_false.
*                    lv_record_x = lv_record_x + 1.
*                  ENDIF. " IF <lst_jksesched>-xorder_created = abap_false
*                ENDIF. " IF <lst_jksesched>-issue IS NOT INITIAL
**                    lv_frst = abap_false.
*              ELSE. " ELSE -> IF lv_frst IS INITIAL
*                lv_media_issue = lv_media_issue + 1.
*                IF <lst_jksesched>-xorder_created = abap_false.
*                  lv_record_x = lv_record_x + 1.
*                ENDIF. " IF <lst_jksesched>-xorder_created = abap_false
*              ENDIF. " IF lv_frst IS INITIAL
*            ENDLOOP. " LOOP AT li_jksesched ASSIGNING <lst_jksesched>
**            ENDIF. " IF sy-subrc = 0     " Comment  ERP-2730
* End of Comment on 18-Jul-2017 by PBANDLAPAL for ERP-2730
* Begin of Insert on 18-Jul-2017 by PBANDLAPAL for ERP-2730
            CLEAR: lv_index_jk,
                   lv_media_issue,
                   lv_record_x.
            READ TABLE li_jksenip INTO lst_jksenip WITH KEY product = <lst_data>-matnr
                                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
              lv_index_jk = sy-tabix.
              READ TABLE li_mara ASSIGNING <lst_mara> WITH KEY matnr = lst_jksenip-issue
                                                       BINARY SEARCH.
              IF sy-subrc = 0.
*           Copy Number of Media Issue
                <lst_fin>-ismcopynr = <lst_mara>-ismcopynr.
                SHIFT <lst_fin>-ismcopynr LEFT DELETING LEADING lc_char_zeros.
                <lst_fin>-issue = <lst_mara>-ismnrinyear.
                SHIFT <lst_fin>-issue LEFT DELETING LEADING lc_char_zeros.
              ENDIF.
              LOOP AT li_jksenip INTO lst_jksenip FROM lv_index_jk.
                IF lst_jksenip-product NE <lst_data>-matnr.
                  EXIT.
                ENDIF.
                READ TABLE li_mvke INTO lst_mvke WITH KEY matnr = lst_jksenip-issue.
                IF sy-subrc EQ 0.
                  READ TABLE li_marc INTO lst_marc WITH KEY matnr = lst_jksenip-issue
                                                            werks = lst_mvke-dwerk.
                  IF sy-subrc EQ 0.
                    IF lst_marc-ismarrivaldateac IS INITIAL OR lst_marc-ismarrivaldateac EQ space.
                      lv_record_x = lv_record_x + 1.
                    ENDIF.

                  ENDIF.
                ENDIF.
                lv_media_issue = lv_media_issue + 1.
              ENDLOOP.
            ENDIF.
* End of Insert on 18-Jul-2017 by PBANDLAPAL for ERP-2730

*       Media Issue 2
            <lst_fin>-issue2 = lv_media_issue.

*       IS-M: Indicator Denoting that Order Was Generated
            <lst_fin>-xorder_created = lv_record_x.

*       Contract Start Date
            <lst_fin>-vbegdat = lv_vbegdat.

*       Contract End Date
*           Begin of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
            <lst_fin>-venddat2 = lv_venddat2.
*           End   of ADD:ERP-7171:WROY:20-Mar-2018:ED2K911483
*           Begin of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483
*           <lst_fin>-venddat2 = lv_venddat1.
*           End   of DEL:ERP-7171:WROY:20-Mar-2018:ED2K911483

*       SD Document Currency
            <lst_fin>-waerk = <lst_data>-waerk.

*       Obtain cumulated condition values per item and condition type
            LOOP AT li_konv ASSIGNING <lst_konv>.
              IF <lst_konv>-kposn = <lst_data>-posnr.
                AT NEW kntyp.
                  CLEAR: lv_kntyp,
* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
*                  lv_kwert_d,
*                  lv_kwert_h,
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
                  lv_kwert_f.
                  lv_kntyp = <lst_konv>-kntyp.
                ENDAT.

* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
*                IF lv_kntyp = lc_kntyp_h.
*                  lv_kwert_h = lv_kwert_h + <lst_konv>-kwert.
*                ENDIF. " IF lv_kntyp = lc_kntyp_h
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736

                IF lv_kntyp = lc_kntyp_f.
                  lv_kwert_f = lv_kwert_f + <lst_konv>-kwert.
                ENDIF. " IF lv_kntyp = lc_kntyp_f

* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
*                IF lv_kntyp = lc_kntyp_d.
*                  lv_kwert_d = lv_kwert_d + <lst_konv>-kwert.
*                ENDIF. " IF lv_kntyp = lc_kntyp_d
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736

                AT END OF kntyp.
* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
*                  IF lv_kntyp = lc_kntyp_h.
*                    <lst_fin>-kwert_h = lv_kwert_h.
*                  ENDIF. " IF lv_kntyp = lc_kntyp_h
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736

                  IF lv_kntyp = lc_kntyp_f.
                    <lst_fin>-kwert_f = lv_kwert_f .
                  ENDIF. " IF lv_kntyp = lc_kntyp_f

* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
*                  IF lv_kntyp = lc_kntyp_d.
*                    <lst_fin>-kwert_d = lv_kwert_d.
*                  ENDIF. " IF lv_kntyp = lc_kntyp_d
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736

                ENDAT.


              ENDIF.
            ENDLOOP. " LOOP AT li_konv ASSIGNING <lst_konv>

* BOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736
* Price
            <lst_fin>-kwert_h = <lst_data>-kzwi2.
* Tax
            <lst_fin>-kwert_d = <lst_data>-kzwi6.
* EOC: 04-Aug-2017 : PBANDLAPAL : ERP-3885: ED2K907736

* SOC 05-Oct-2018 : NPOLINA : CR7756 F037 ED2K913530
            <lst_fin>-mvgr1 =  <lst_data>-mvgr1.
            <lst_fin>-mvgr2 =  <lst_data>-mvgr2.
            <lst_fin>-mvgr3 =  <lst_data>-mvgr3.
            <lst_fin>-mvgr4 =  <lst_data>-mvgr4.
            <lst_fin>-mvgr5 =  <lst_data>-mvgr5.
* EOC 05-Oct-2018 : NPOLINA : CR7756 F037 ED2K913530
*       Net value of the order item in document currency
            <lst_fin>-netwr = <lst_fin>-kwert_d + <lst_fin>-kwert_h + <lst_fin>-kwert_f.

*       E-Mail Address
            <lst_fin>-smtp_addr = <lst_data>-smtp_addr.

*       Customer Purcahse Order Number
            IF <lst_data>-konda = lc_konda_3.
              <lst_fin>-bstkd = <lst_data>-bstkd.
            ENDIF. " IF <lst_data>-konda = lc_konda_3

*       Country Key
            <lst_fin>-country = <lst_data>-country.

*       Shipping Address
            READ TABLE li_vbpa_shp ASSIGNING <lst_vbpa>
                                   WITH KEY posnr = <lst_data>-posnr
                                   BINARY SEARCH.
            IF sy-subrc = 0 .
              READ TABLE li_adrc ASSIGNING <lst_adrc>
                                 WITH KEY addrnumber = <lst_vbpa>-adrnr
                                 BINARY SEARCH.
              IF sy-subrc = 0.
*           Name 1
                <lst_fin>-name1_shp = <lst_adrc>-name1.

*           Name 2
                <lst_fin>-name2_shp = <lst_adrc>-name2.

*           Street
                <lst_fin>-street_shp = <lst_adrc>-street.

*           House Number
                <lst_fin>-house_num1_shp = <lst_adrc>-house_num1.

*           City
                <lst_fin>-city1_shp = <lst_adrc>-city1.

*           Region (State, Province, County)
                <lst_fin>-region_shp = <lst_adrc>-region.

*           City Postal Code
                <lst_fin>-post_code1_shp = <lst_adrc>-post_code1.

*           Country Key
                <lst_fin>-country_shp = <lst_adrc>-country.
              ENDIF. " IF sy-subrc = 0
            ENDIF. " IF sy-subrc = 0
*         Billing Address
            READ TABLE li_vbpa_bil ASSIGNING <lst_vbpa>
                                               WITH KEY posnr = <lst_data>-posnr
                                               BINARY SEARCH.
            IF sy-subrc = 0 .
              READ TABLE li_adrc ASSIGNING <lst_adrc>
                                 WITH KEY addrnumber = <lst_vbpa>-adrnr
                                 BINARY SEARCH.
              IF sy-subrc = 0.

*           Name 1
                <lst_fin>-name1_bil = <lst_adrc>-name1.

*           Name 2
                <lst_fin>-name2_bil = <lst_adrc>-name2.

*           Street
                <lst_fin>-street_bil = <lst_adrc>-street.

*           House Number
                <lst_fin>-house_num1_bil = <lst_adrc>-house_num1.

*           City
                <lst_fin>-city1_bil = <lst_adrc>-city1.

*           Region (State, Province, County)
                <lst_fin>-region_bil = <lst_adrc>-region.

*           City Postal Code
                <lst_fin>-post_code1_bil = <lst_adrc>-post_code1.

*           Country Key
                <lst_fin>-country_bil = <lst_adrc>-country.

              ENDIF. " IF sy-subrc = 0

            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT li_data ASSIGNING <lst_data>

        ENDIF. " IF li_data IS INITIAL

      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF <lst_vbfa>-vbelv IS INITIAL

* Unassign the field symbols
    IF <lst_fin> IS ASSIGNED .
      UNASSIGN <lst_fin>.
    ENDIF. " IF <lst_fin> IS ASSIGNED

    IF <lst_adrc> IS ASSIGNED .
      UNASSIGN <lst_adrc>.
    ENDIF. " IF <lst_adrc> IS ASSIGNED

    IF <lst_data> IS ASSIGNED .
      UNASSIGN <lst_data>.
    ENDIF. " IF <lst_data> IS ASSIGNED

    IF <lst_ret_msg> IS ASSIGNED .
      UNASSIGN <lst_ret_msg>.
    ENDIF. " IF <lst_ret_msg> IS ASSIGNED
  ENDMETHOD.

* Method to send email as error notification
  METHOD meth_send_email.
    DATA :
      lv_email_subject TYPE so_obj_des, " Short description of contents
      lv_lines_txt     TYPE so_bd_num.  " Lines_txt of type Integers

    DATA :
      lst_objtxt   TYPE solisti1,   " SAPoffice: Single List with Column Length 255
      lst_objpack  TYPE sopcklsti1, " SAPoffice: Description of Imported Object Components
      lst_reclist  TYPE somlreci1,  " SAPoffice: Structure of the API Recipient List
      lst_doc_chng TYPE sodocchgi1. " Data of an object which can be changed

* local internal table declaration
    DATA:
      li_objpack TYPE STANDARD TABLE OF sopcklsti1 INITIAL SIZE 0, " SAPoffice: Description of Imported Object Components
      li_objtxt  TYPE STANDARD TABLE OF solisti1  INITIAL SIZE 0,  " SAPoffice: Single List with Column Length 255
      li_reclist TYPE STANDARD TABLE OF somlreci1 INITIAL SIZE 0.  " SAPoffice: Structure of the API Recipient List

* Local Constant Declaration
    CONSTANTS :
      lc_sensitivty_f TYPE so_obj_sns  VALUE 'F',   " Object: Sensitivity (private, functional, ...)
      lc_success      TYPE char1       VALUE 'I',
      lc_error        TYPE char1       VALUE 'E',
      lc_doc_type_raw TYPE so_obj_tp   VALUE 'RAW', " Code for document class
      lc_head_start_1 TYPE so_hd_strt  VALUE '1',                     " Start line of object header in transport packet
      lc_head_num_0   TYPE so_hd_num   VALUE '0',                      " Number of lines of an object header in object packet
      lc_body_start_1 TYPE so_bd_strt  VALUE '1',
      lc_variable     TYPE rvari_vnam VALUE 'EMAIL',
      lc_rec_type_u   TYPE so_escape   VALUE 'U'.  " Specification of recipient type

    FIELD-SYMBOLS: <lst_ret_msg>   TYPE zstqtc_retmsg.                 " Structure for Return Messages


* Create email body .
    LOOP AT  im_t_error
      ASSIGNING FIELD-SYMBOL(<lst_msg>).
      lst_objtxt-line = <lst_msg>-message.
      APPEND lst_objtxt TO li_objtxt.
      CLEAR lst_objtxt.
    ENDLOOP.

    DESCRIBE TABLE li_objtxt LINES lv_lines_txt.

    CLEAR lst_objtxt.
    READ TABLE li_objtxt INTO lst_objtxt INDEX lv_lines_txt.
    IF sy-subrc EQ 0.

*   Create Subject line of Email
      lv_email_subject = 'Subscription Renewal RFC Errors'(003).
      lst_doc_chng-obj_descr  = lv_email_subject.
      lst_doc_chng-sensitivty = lc_sensitivty_f.
      lst_doc_chng-doc_size   = lv_lines_txt * 255.
    ENDIF.

    CLEAR lst_objpack-transf_bin.
    lst_objpack-head_start = lc_head_start_1.
    lst_objpack-head_num   = lc_head_num_0.
    lst_objpack-body_start = lc_body_start_1.
    lst_objpack-body_num   = lv_lines_txt.
    lst_objpack-doc_type   = lc_doc_type_raw.
    APPEND lst_objpack TO  li_objpack.

*   Populate the receiver list
    LOOP AT im_constant INTO DATA(lst_constant).
      IF lst_constant-param1 = lc_variable.
        lst_reclist-receiver = lst_constant-low+0(17). "smiglin@wiley.com
        lst_reclist-rec_type =  lc_rec_type_u  .
        APPEND lst_reclist TO li_reclist.
        CLEAR lst_reclist.
      ENDIF.
    ENDLOOP.

* Send email
    CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
      EXPORTING
        document_data              = lst_doc_chng
        put_in_outbox              = abap_true
        commit_work                = abap_true
      TABLES
        packing_list               = li_objpack
        contents_txt               = li_objtxt
        receivers                  = li_reclist
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.
    IF sy-subrc <> 0.
*       Append error message in the message table
      APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
      <lst_ret_msg>-msgty = lc_error.
      <lst_ret_msg>-message = text-005.

    ELSE.
*       Append success message in the message table
      APPEND INITIAL LINE TO ex_t_return_msg ASSIGNING <lst_ret_msg>.
      <lst_ret_msg>-msgty = lc_success.
      <lst_ret_msg>-message = text-004.

    ENDIF. " IF sy-subrc <> 0

  ENDMETHOD.
ENDCLASS.
