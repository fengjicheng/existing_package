*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OUTBOUND_DELIVERY_SUB
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OUTBOUND_DELIVERY (Include Program)
* PROGRAM DESCRIPTION: Outbound Delivery to JFDS
* DEVELOPER: Priyanka Mitra (PRMITRA)
* CREATION DATE:   12/23/2016
* OBJECT ID:  I0255
* TRANSPORT NUMBER(S): ED2K903844
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903844                                              *
* REFERENCE NO: ERP-1599                                               *
* DEVELOPER: Paramita Bose (PBOSE)                                     *
* DATE:  02/23/2017                                                    *
* DESCRIPTION:Add logic to fetch open delivery and order for back label*
*----------------------------------------------------------------------*
* REVISION NO: ED2K903844                                              *
* REFERENCE NO: CR#371 & 435                                           *
* DEVELOPER: Monalisa Dutta                                            *
* DATE: 02/26/2017                                                     *
* DESCRIPTION:                                                         *
* 1) Split file based on variant field in ZQTC_I0255_SPLIT table       *
* 2) Send the file in email in case of manual execution                *
* 3) Display records in ALV                                            *
*----------------------------------------------------------------------*
* REVISION NO: ED2K905512                                              *
* REFERENCE NO: ERP-2003                                               *
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)                             *
* DATE:  05/09/2017                                                    *
* DESCRIPTION: To include Identification code as Acronym instead of    *
* media product. This field is extracted from JPTIDCDASSIGN-IDENTCODE. *
*----------------------------------------------------------------------*
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K906000
*** REFERENCE NO:  JIRA Defect# ERP-2048
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-11
*** DESCRIPTION: To correct the SORT of internal table as it was commented
* out commenting of the CR changes. .
***------------------------------------------------------------------- *
*** REVISION NO: ED2K906029
*** REFERENCE NO:  CR#571
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-06-29
*** DESCRIPTION: To include street4 and street5 fields from ADRC table into
***              existing stras field in the output.
*&---------------------------------------------------------------------*
*** REVISION NO: ED2K907329
*** REFERENCE NO:  ERP-3326
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-07-18
*** DESCRIPTION: During the Batch job processing the variants are run with
***              only creation date and not with material numbers. Hence
***              Selects are changed accordingly. I have done the code
***              cleaning and hence no tags are found for this defect.
***              To see the actual changes we can go to version comparison.
*&---------------------------------------------------------------------*
*** REVISION NO: ED2K908521
*** REFERENCE NO: ERP-4427
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-09-13
*** DESCRIPTION: As per the present requirement program doesn't need to take
***              care of the last run date as this will be controlled through
***              selection screen. So commenting the code of checking ZCAINTERFACE.
*&----------------------------------------------------------------------*
* REVISION NO: ED2K910783                                               *
* REFERENCE NO: ERP-6478                                                *
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)                              *
* DATE:  09-Feb-2018                                                    *
* DESCRIPTION: To add a validation on the application server path for   *
*              download option to avoid any termination.                *
*-----------------------------------------------------------------------*
* REVISION NO:  ED2K910947                                              *
* REFERENCE NO: ERP-6967                                                *
* DEVELOPER:    GKINTALI (Geeta Kintali)                                *
* DATE:         13-Mar-2018                                             *
* DESCRIPTION:  1. To update the file label name changes as per the     *
*               requirement.                                            *
*               2. In case of Address Line3 exceeding 50 characters in  *
*               length, concatenating Address Lines2,3 and 4 and        *
*               wrapping across Address Lines2,3 and 4 holding each 50  *
*               characters with a semi-colon separator                  *
*               3. Avoiding multiple commas being concatenated in case  *
*               of blank field values for Address Line3                 *
*               4. Logic added to consider ADRC-STREET instead of       *
*               LFA1-STRAS or KNA1-STRAS                                *
*               5. Logic added to consider Long Description of Country  *
*               (LANDX50) instead of 15-char description (LANDX)        *
*               6. Logic added to concatenate Tilte(ANRED) with NAME1   *
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION NO:  ED2K911914/ED2K911985                                   *
* REFERENCE NO: ERP-7404                                                *
* DEVELOPER:    GKINTALI (Geeta Kintali)/ HIPATEL (Himanshu Patel)      *
* DATE:         16-Apr-2018                                             *
* DESCRIPTION:  1. Conditional split file generation is enhanced with 2 *
*                  additional fields: VKORG (Sales Org) and KDKG2       *
*                  (Condition Group2) for both ML and BL.               *
*               2. Label File Generaton check box is added on selection *
*                  to restrict file generaton                           *
*               3. Logic is added to generate ALV report for both ML and*
*                  BL to simulate the process and show total no of files*
*                  to be generated with additional fields:VKORG, PLTYP  *
*                  and File Name in the ALV report                      *
*               4. A custom table: ZQTC_I0255_LBLSM is created and      *
*                  is updated with the required data upon each file     *
*                  generation for both ML and BL                        *
*               5. Logic added not to populate hyphen separator i.e.,   *
*                 “EM –“ or “EB – for the field: Shipping Reference with*
*                  respect to EMLO & EBLO if the Order type is “ZSRO”.  *
*               6. Logic added for Authorization check for object       *
*                  ZDEL_I0255                                           *
*               7. VAT Regn. number for Canada read from ZCACONSTANT    *
*                  table                                                *
*               8. Date Format check box is added on selection screen   *
*                  and accordingly date format is changed in the file   *
*                  during its population and in ALV as DD-MMM-YYYY      *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907377                                              *
* REFERENCE NO: RITM0025850 & CR - ERP-7478                             *
* DEVELOPER:    GKINTALI (Geeta Kintali)                                *
* DATE:         18-May-2018                                             *
* DESCRIPTION:  1. To include the field STREET2 (ADRC-STR_SUPPL1) field *
*                  in to Address.                                       *
*               2. Region code and descriptions based on the selection  *
*                  screen input                                         *
*               3. Adjusting the lgoic for Address Lines 1,2,3 and 4 to *
*                  accommodate Steet2                                   *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907411                                              *
* REFERENCE NO: RITM0025850 & CR - ERP-7478                             *
* DEVELOPER:    SGURIJALA (Siva Gurijala)                               *
* DATE:         21-May-2018                                             *
* DESCRIPTION:  If Ship-to customer partner type is Individual (1), then*
*               Address Line 3 and 4 values are changed as per the req. *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907523                                              *
* REFERENCE NO: I0255 - INC0200998 - CR - CHG0040278                    *
* DEVELOPER:    HIPATEL (Himanshu Patel)                                *
* DATE:         29-Jun-2018                                             *
* DESCRIPTION:  1. To avoid Special character Dump in FM :              *
*                  HR_KR_STRING_TO_XSTRING  Implemented same FM with    *
*                  CodePage value to avoid raise Exceptions             *
*               2. Add New ALV output Column called Subscription Number *
*               3. Populate the VBKD-IHREZ value into Subscription      *
*                  Reference                                            *
*               4. Add a check Box on selection screen called Delivery  *
*                  completed.                                           *
*                  Main Label–All EKPO-ELIKZ info should displayed      *
*                  Back Label – All VBUK-WBSTK should be displayed      *
*               5. Issue Description Field - Print first 15 Character   *
*                  of Media issue                                       *
*               6. Media Product in the Main Label naming convention    *
*                  should be replaced with first 4 character of Media   *
*                  Issue                                                *
*-----------------------------------------------------------------------*
* REVISION NO:  ED1K907899 / ED1K907981 / ED1K908132                    *
* REFERENCE NO: INC0200998 & CHG0040278                                 *
* DEVELOPER:    HIPATEL (Himanshu Patel)                                *
* DATE:         06-July-2018                                            *
* DESCRIPTION:  1. Main Label - Split based on selection screen         *
*                  Added two split Radio button - Material & Variant    *
*               2. Added field on selection screen for Subscription     *
*                  reference field character in file                    *
*               3. Added checkbox field for Variant split in custom     *
*                  table ZQTC_I0255_SPLIT. Selected variant only cover  *
*                  in Variant split                                     *
*               4. Unconditional scenario: Variant split logic added +  *
*                  Varinat name fetching from ZCACONSTANT table         *
*               5. File Naming convention changed for Material split &  *
*                  Variant split                                        *
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION NO :  ED1K908634 / ED1K908689 / ED1K908710                   *
* REFERENCE NO:  RITM0065346                                            *
* DEVELOPER   :KJAGANA(kiran jagana)/ HIPATEL (Himanshu Patel)          *
* DATE:         08-Sep-2018                                             *
* DESCRIPTION: Back label:display the subscription number in the report *
* output when subsequent sales order having it in order data            *
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909086 / ED1K909240
* REFERENCE NO: RITM0092591
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE: 12/04/2018
* DESCRIPTION: Shipping Instruction trancating after first line.
*              Increasing length of Shipping Instruction field to 255
*              character
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909344 / ED1K909717
* REFERENCE NO: CHG0040278 / RITM0078000
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE: 01/18/2019
* DESCRIPTION: 1. Split based on variant name functionality changes only
*                 for Main Label
*              2. Reverse logic implemented for ERP-7404, for remove
*                 “EM-“ for ZSRO type.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910250
* REFERENCE NO: INC0241797
* DEVELOPER: Lakshminarayana (LRRAMIREDD)
* DATE: 30/05/2019
* DESCRIPTION: Exclude the delivery item category(ZCSE,ZCNE) in BL File
* and in ALV Output
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910874
* REFERENCE NO: INC0255257
* DEVELOPER: Bharani (BTIRUVATHU)
* DATE: 22/08/2019
* DESCRIPTION: Merging of records only happens when both boxes
* are selected CheckBox and Variant Split for the option
* Split on Varname.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911472
* REFERENCE NO: INC0273232
* DEVELOPER: Nikhilesh (NPALLA)
* DATE: 12/23/2019
* DESCRIPTION: Contact Number being cut-off when order is processed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K912633
* REFERENCE NO: INC0334801
* DEVELOPER: Nikhilesh (NPALLA)
* DATE: 01/22/2021
* DESCRIPTION: Trigger email if its maintained irrespecitive of CNTRL_CIRCULATION
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K926022
* REFERENCE NO: OTCM – 47999 , JFDS , I0255
* DEVELOPER: Bharat Saki (BSAKI)
* DATE: 03/09/2022
* DESCRIPTION: Changes for address1 and 2 fields of the data on interface
*              level
*----------------------------------------------------------------------*
*
* Begin of Change by PBANDLAPAL on 06-Sep-2017 ERP-4427: ED2K908521
**&---------------------------------------------------------------------*
**&      Form  F_RUN_DATE
**&---------------------------------------------------------------------*
**       Get last run date for selection screen field
**----------------------------------------------------------------------*
**      <--P_IR_DATE[]  Document Date
**----------------------------------------------------------------------*
*FORM f_run_date  CHANGING fp_s_date  TYPE fip_t_erdat_range.
** Local constant Declaration
*  CONSTANTS: lc_param2 TYPE rvari_vnam VALUE '001'. " ABAP: Name of Variant Variable
*
*  SELECT lrdat,                   "Last run date
*         lrtime                   "Last Run time
*       FROM zcainterface          " Interface run details
*       INTO TABLE @DATA(li_zcainterface)
*       WHERE devid  = @c_devid
*         AND param2 = @lc_param2. "'001'.
*
*  IF sy-subrc = 0.
*    SORT li_zcainterface BY lrdat DESCENDING lrtime DESCENDING.
*  ELSE. " ELSE -> IF sy-subrc = 0
**  Please maintain table ZCAINTERFACE.
*    MESSAGE i104(zqtc_r2) DISPLAY LIKE c_error. " Please maintain table ZCAINTERFACE.
**    LEAVE LIST-PROCESSING.
*  ENDIF. " IF sy-subrc = 0
*
*  READ TABLE li_zcainterface ASSIGNING FIELD-SYMBOL(<lst_zcainterface>) INDEX 1.
*  IF sy-subrc = 0.
*    APPEND INITIAL LINE TO fp_s_date ASSIGNING FIELD-SYMBOL(<lst_date>).
*    <lst_date>-sign   = c_sign_incld. "Sign: (I)nclude
*    <lst_date>-option = c_opti_betwn. "Option: (B)etween
*    <lst_date>-low    = <lst_zcainterface>-lrdat. "Last run date
*    <lst_date>-high   = sy-datum.
*    DELETE fp_s_date INDEX 1.
*  ENDIF. " IF sy-subrc = 0
*
*ENDFORM.
* End of Change by PBANDLAPAL on 06-Sep-2017 ERP-4427: ED2K908521
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       Get data
*----------------------------------------------------------------------*
FORM f_get_data .
* Local data declaration
  DATA : lst_parvw         TYPE ty_parvw,
         li_main_label     TYPE tt_main_label,
         li_back_label     TYPE tt_back_label,
* Begin of Change Defect 2003
         lst_idcode_type   TYPE ty_ismidcodetype,
         lir_idcode_type   TYPE TABLE OF ty_ismidcodetype,
* End of Change Defect 2003
*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
         lir_jrnl          TYPE  tt_jrnl,
         lir_ship_to       TYPE  tt_ship_to,
         lir_konda         TYPE  tt_konda,
         lir_auart         TYPE  tt_auart,
         lir_augru         TYPE  tt_augru,
         lir_media_issue   TYPE tt_media,
         lir_media_product TYPE tt_media,
         lir_society       TYPE tt_society,
         li_split          TYPE tt_split.
*<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>

  REFRESH li_parvw.
* To build the partners range for ship to and
  lst_parvw-sign = c_sign_incld.
  lst_parvw-option = c_opti_equal.
  lst_parvw-low = c_parvw_we.
  APPEND lst_parvw TO li_parvw.

  CLEAR lst_parvw-low.
  lst_parvw-low = c_parvw_sp.
  APPEND lst_parvw TO li_parvw.

* Begin of Insert CR#371 & 435  PBANDLAPAL
  CLEAR lst_parvw-low.
  lst_parvw-low = c_parvw_ag.
  APPEND lst_parvw TO li_parvw.
* End of Insert for CR#371 & 435  PBANDLAPAL

  CLEAR lst_parvw.

* Begin of change Defect 2003
*  SELECT * INTO TABLE li_zcaconstant
*    FROM zcaconstant
*    WHERE devid = c_devid
*      AND activate = abap_true.

  LOOP AT i_constant INTO DATA(lst_zcaconstant) WHERE param1 = c_idcode_type.
*    CASE lst_zcaconstant-param1.
*      WHEN c_idcode_type.
    lst_idcode_type-sign    = lst_zcaconstant-sign.
    lst_idcode_type-option = lst_zcaconstant-opti.
    lst_idcode_type-low    = lst_zcaconstant-low.
    lst_idcode_type-high   = lst_zcaconstant-high.
    APPEND lst_idcode_type TO lir_idcode_type.
    CLEAR lst_idcode_type.
*      WHEN OTHERS.
*    ENDCASE.
    CLEAR lst_zcaconstant.
  ENDLOOP.
* End of change Defect 2003

*<<<<<<<<<<BOC by MODUTTA on 06/02/2017 for CR#371 & 435>>>>>>>>>>>>>
  IF rb3 EQ abap_true.
*    Get file from app server and display in ALV
    PERFORM f_get_app_server_data.

*    Save file in presentation server
    IF p_dwnld IS NOT INITIAL.
      PERFORM f_save_file_pres_server.
    ENDIF.
  ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 06/02/2017 for CR#371 & 435>>>>>>>>>>>>>
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
  IF cb_lbl = 'X'.
* To get the row count of the table: ZQTC_I0255_LBLSM
    CLEAR v_row_cnt.
    SELECT COUNT( * ) INTO v_row_cnt FROM zqtc_i0255_lblsm.
    IF sy-subrc <> 0.
      " Nothing to do here
    ENDIF.
  ENDIF. " IF cb_lbl = 'X'.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
  IF rb1 EQ abap_true. "Main Label
* Get main label data
    PERFORM f_get_main_label_data  USING    s_matnr[]
                                            s_plant[]
                                            s_type[]
                                            s_item[]
                                            s_acct[]
                                            s_vend[]
                                            s_doc2[]
                                            s_date[]
                                            lir_idcode_type[]  "Defect 2003
                                   CHANGING li_main_label[].


    IF NOT li_main_label[] IS INITIAL.
* Get success file record for main label
      PERFORM f_get_main_label_file  CHANGING li_main_label[]
                                              li_split.


    ELSE. " ELSE -> IF NOT li_main_label[] IS INITIAL
* Get error file record
      PERFORM f_get_error_record.
    ENDIF. " IF NOT li_main_label[] IS INITIAL
  ELSEIF rb2 EQ abap_true. "Back Label
*   Get back label data
    PERFORM f_get_back_label_data  USING    s_ship[]
                                            s_matnr[]
                                            s_type[]
                                            s_doc1[]
                                            s_date[]
                                            lir_idcode_type[]  "Defect 2003
                                   CHANGING li_back_label[]
                                            li_split.


    IF NOT li_back_label[] IS INITIAL.
* Get success file record for back label
      PERFORM f_get_back_label_file  USING li_back_label[]
                                           li_split.
    ELSE. " ELSE -> IF NOT li_back_label[] IS INITIAL
* Get error file record
      PERFORM f_get_error_record.
    ENDIF. " IF NOT li_back_label[] IS INITIAL
  ENDIF. " IF rb1 EQ abap_true

*Begin of Insert by PBANDLAPAL on 06/02/2017 for CR#371 & 435
  IF li_err_log IS NOT INITIAL.
    PERFORM error_log_for_mandate_fields.
  ENDIF.
*End of Insert by PBANDLAPAL on 06/02/2017 for CR#371 & 435
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MAIN_LABEL_DATA
*&---------------------------------------------------------------------*
*       Get main label data
*----------------------------------------------------------------------*
*  -->  p_s_matnr        Material
*  -->  p_s_plant        Plant
*  -->  p_s_type         Material Type
*  -->  p_s_item         Item category
*  -->  p_s_acct         Account Assignment
*  -->  p_s_vend         Vendor
*  -->  p_s_doc2         Document Type
*  -->  p_s_date         Document Date
*  <--  p_li_main_label  Main label Structure
*----------------------------------------------------------------------*
FORM f_get_main_label_data  USING     fp_s_matnr  TYPE fip_t_matnr_range
                                      fp_s_plant  TYPE fip_t_werks_range
                                      fp_s_type   TYPE fip_t_mtart_range
                                      fp_s_item   TYPE fip_t_pstyp_range
                                      fp_s_acct   TYPE fip_t_knttp_range
                                      fp_s_vend   TYPE fip_t_lifnr_range
                                      fp_s_doc2   TYPE fip_t_bsart_range
                                      fp_s_date   TYPE fip_t_erdat_range
                                      fp_lir_idcode_type TYPE tt_idcode_type  "Defect 2003
                            CHANGING  fp_li_main_label TYPE tt_main_label.


* Local internal table Declaration
  DATA : li_lines     TYPE STANDARD TABLE OF tline INITIAL SIZE 0, " SAPscript: Text Lines
         lst_adrnr    TYPE ty_adrnr,
*        Added by MODUTTA on 05/02/2017 for CR# 371 & 435
         li_lines_del TYPE STANDARD TABLE OF tline INITIAL SIZE 0, " SAPscript: Text Lines
         lir_jrnl     TYPE tt_jrnl,
         lst_jrnl     TYPE ty_jrnl.

* Local Variable Declaration
  DATA : lv_name           TYPE tdobname, " Name
* Begin of Change CR471
         lv_matnr          TYPE matnr,
         lv_issue          TYPE string,
         lv_mdprod         TYPE ismrefmdprod,
         lv_len            TYPE i,        " Len of type Integers
         lv_itemno         TYPE numc06,
         lst_constant      TYPE ty_constant,
* End of Change CR471
         lv_remqty         TYPE menge_d,  " Quantity
         lv_object         TYPE tdobject, " Texts: Application Object
         lst_country       TYPE ty_country,
         lst_region        TYPE ty_region, " ++GKINTALI:ED1K907377
         lst_t005u         TYPE ty_t005u,  " ++GKINTALI:ED1K907377
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 3/14/2018
         lst_tmp(256)      TYPE c,           " Temporary String Structure
         lst_tmp_name(256) TYPE c,      " Temporary String Structure          " SRREDDY 5/19/2018
         li_outlines       TYPE tt_lines,    " Internal table to hold 256-char type entries
         lst_line          TYPE ty_lines.    " 256-char structure
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 3/14/2018
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
  CONSTANTS: lc_wricef_id TYPE zdevid   VALUE 'I0255', " Development ID
             lc_jfds      TYPE zvar_key VALUE 'JFDS', " var key
             lc_ser_num   TYPE zsno     VALUE '001'.  " Serial Number
  DATA:       lv_actv_flag    TYPE zactive_flag . " Active / Inactive Flag
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022

** Get Issue no.
*  SELECT matnr,
*         ismrefmdprod,
*         ismcopynr,
*         ismnrinyear,
*         ismtitle,
*         ismyearnr,
*         ismissuetypest " Issue Variant Type - Standard (Planned)
*    FROM mara           " General Material Data
*    INTO TABLE @DATA(li_mara)
*    WHERE matnr IN @fp_s_matnr
*      AND mtart IN @fp_s_type.
*
*  IF sy-subrc EQ 0.
*    SORT li_mara BY matnr.
** Begin of Change Defect 2003
*    SELECT matnr,                         " Material Number
*       idcodetype,                    " Type of Identification Code
*       identcode                     " Identification Code
*  FROM jptidcdassign                 " IS-M: Assignment of ID Codes to Material
*  INTO TABLE @DATA(li_jptidcdassign)
*  FOR ALL ENTRIES IN @li_mara
*  WHERE matnr EQ @li_mara-matnr
*    AND idcodetype IN @fp_lir_idcode_type. "c_idcdtyp_zjcd.
*    IF sy-subrc = 0.
*      SORT li_jptidcdassign[] BY matnr.
*    ENDIF.
** End of Change Defect 2003
**<<<<<<<<<Added by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>
**    LOOP AT li_mara INTO DATA(lst_mara).
**      lst_jrnl-sign = c_sign.
**      lst_jrnl-option = c_option_eq.
**      lst_jrnl-low = lst_mara-ismrefmdprod.
**      APPEND lst_jrnl TO lir_jrnl.
**      CLEAR: lst_jrnl,lst_mara.
**    ENDLOOP.
** Begin of code Added by Pavan
*    LOOP AT li_jptidcdassign INTO DATA(lst_jptidcdassign).
*      lst_jrnl-sign = c_sign.
*      lst_jrnl-option = c_option_eq.
*      lst_jrnl-low = lst_jptidcdassign-identcode.
*      APPEND lst_jrnl TO lir_jrnl.
**      CLEAR: lst_jrnl,lst_mara.
*    ENDLOOP.
** End of code Added by Pavan
**<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*  ELSE. " ELSE -> IF sy-subrc EQ 0
**   Message: No data records found for the specified selection criteria
*    MESSAGE i004(wrf_at_generate). " No data records found for the specified selection criteria
*  ENDIF. " IF sy-subrc EQ 0


*  IF li_mara IS NOT INITIAL.
* Get PO & PO item & Priority
  SELECT h~ebeln,
         h~lifnr,
         h~aedat,
         i~ebelp,
         i~matnr,
         i~menge " Purchase Order Quantity
     FROM ekko AS h
     INNER JOIN ekpo AS i
     ON h~ebeln EQ i~ebeln
     INTO TABLE @DATA(li_po)
     WHERE i~matnr IN @fp_s_matnr
       AND i~werks IN @fp_s_plant
       AND i~pstyp IN @fp_s_item
       AND i~knttp IN @fp_s_acct
       AND h~lifnr IN @fp_s_vend
       AND h~bsart IN @fp_s_doc2
       AND h~aedat IN @fp_s_date
       AND i~loekz EQ @space.
  IF sy-subrc EQ 0.
    SORT li_po BY matnr. "ebeln ebelp.
  ENDIF. " IF sy-subrc EQ 0

*  Get Subcription Ref(vbeln)
  IF li_po[] IS NOT INITIAL.
* To retrieve the open purchase order history data
* S stands for + and H is -.
    SELECT ebeln,
           ebelp,
           belnr,
           bwart,
           menge,
           shkzg     " Debit/Credit Indicator
           FROM ekbe " History per Purchasing Document
           INTO TABLE @DATA(li_ekbe)
        FOR ALL ENTRIES IN @li_po
      WHERE ebeln = @li_po-ebeln AND
            ebelp = @li_po-ebelp AND
            bewtp = @c_bewtp_e AND
            bwart IN (@c_bwart_z01,@c_bwart_z02,@c_bwart_101,@c_bwart_102).
    IF sy-subrc EQ 0.
      SORT li_ekbe BY ebeln ebelp.
    ENDIF. " IF sy-subrc EQ 0

    SELECT ebeln,
           ebelp,
           menge,
           vbeln, " Sales and Distribution Document Number
           vbelp      " CR#371
      FROM ekkn  " Account Assignment in Purchasing Document
      INTO TABLE @DATA(li_ekkn)
      FOR ALL ENTRIES IN @li_po
      WHERE ebeln EQ @li_po-ebeln
        AND ebelp EQ @li_po-ebelp
        AND vbeln NE @c_char_blank.

    IF sy-subrc EQ 0.
      SORT li_ekkn BY ebeln ebelp.
* To delete the PO number and line items that do not contain sales orders.
      LOOP AT li_po INTO DATA(lst_po).
        DATA(lv_tabx) = sy-tabix.
        READ TABLE li_ekkn TRANSPORTING NO FIELDS WITH KEY ebeln = lst_po-ebeln
                                                           ebelp = lst_po-ebelp.
        IF sy-subrc NE 0.
          DELETE li_po INDEX lv_tabx.
        ENDIF. " IF sy-subrc NE 0
      ENDLOOP. " LOOP AT li_po INTO DATA(lst_po)
    ENDIF. " IF sy-subrc EQ 0

    IF NOT li_po[] IS INITIAL.  "+ HIPATEL - 04/18/2018
* Get Issue no.
      SELECT matnr,
             ismrefmdprod,
             ismcopynr,
             ismnrinyear,
             ismtitle,
             ismyearnr,
             ismissuetypest " Issue Variant Type - Standard (Planned)
        FROM mara           " General Material Data
        INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_po
        WHERE matnr EQ @li_po-matnr
          AND mtart IN @fp_s_type.

      IF sy-subrc EQ 0 AND li_mara IS NOT INITIAL.
        SORT li_mara BY matnr.
* Begin of Change Defect 2003
        SELECT matnr,                         " Material Number
           idcodetype,                    " Type of Identification Code
           identcode                     " Identification Code
      FROM jptidcdassign                 " IS-M: Assignment of ID Codes to Material
      INTO TABLE @DATA(li_jptidcdassign)
      FOR ALL ENTRIES IN @li_mara
      WHERE matnr EQ @li_mara-matnr
        AND idcodetype IN @fp_lir_idcode_type. "c_idcdtyp_zjcd.
        IF sy-subrc = 0.
          SORT li_jptidcdassign[] BY matnr.
        ENDIF.
* End of Change Defect 2003

        LOOP AT li_jptidcdassign INTO DATA(lst_jptidcdassign).
          lst_jrnl-sign = c_sign.
          lst_jrnl-option = c_option_eq.
          lst_jrnl-low = lst_jptidcdassign-identcode.
          APPEND lst_jrnl TO lir_jrnl.
        ENDLOOP.
      ENDIF.
    ENDIF.  "IF not li_po[] is INITIAL.
* Get Preceding sales and distribution document
    IF li_ekkn[] IS NOT INITIAL.
      SELECT vbelv,
             posnv,
             vbeln, " Subsequent sales and distribution document
             posnn
         FROM vbfa " Sales Document Flow
         INTO TABLE @DATA(li_vbfa)
         FOR ALL ENTRIES IN @li_ekkn
         WHERE vbeln EQ @li_ekkn-vbeln
           AND vbtyp_v IN (@c_vbtyp_g,@c_vbtyp_c).

      IF sy-subrc EQ 0.
        SORT li_vbfa BY vbeln.
*          DELETE ADJACENT DUPLICATES FROM li_vbfa COMPARING vbeln.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_ekkn[] IS NOT INITIAL

    IF li_vbfa[] IS NOT INITIAL.
* Get Free issue Ref & Claim Ref & Sample copy Ref
      SELECT vbeln,
             auart,  " Sales Document Type
             augru,  "Reason Code "Added by MODUTTA
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
             vkorg   " Sales Organization
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
          FROM vbak " Sales Document: Header Data
          INTO TABLE @DATA(li_vbak)
          FOR ALL ENTRIES IN @li_vbfa
          WHERE vbeln EQ @li_vbfa-vbelv.
      IF sy-subrc EQ 0.
        SORT li_vbak BY vbeln.
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF li_vbfa[] IS NOT INITIAL
* When subscription orde rnumber doesn't exist in doc flow.
* Get Free issue Ref & Claim Ref & Sample copy Ref
      IF li_ekkn[] IS NOT INITIAL.
        SELECT vbeln,
               auart,  " Sales Document Type
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
               vkorg   " Sales Organization
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
            FROM vbak  " Sales Document: Header Data
            INTO TABLE @DATA(li_vbak_m)
            FOR ALL ENTRIES IN @li_ekkn
            WHERE vbeln EQ @li_ekkn-vbeln.
        IF sy-subrc EQ 0.
          li_vbak[] = li_vbak_m[].
          SORT li_vbak BY vbeln.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_ekkn[] IS NOT INITIAL
    ENDIF. " IF li_vbfa[] IS NOT INITIAL

    IF li_ekkn[] IS NOT INITIAL.
* To get the shipping conditions for the sales orders referencing
* for the purchase orders which is needed to populate priority field in the output
      SELECT vbeln,
             auart, " Sales Document Type
             augru,   "Reason Code "Added by MODUTTA
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
             vkorg,   " Sales Organization
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
             vsbed  " Shipping condition
          FROM vbak " Sales Document: Header Data
          INTO TABLE @DATA(li_vbak_s)
          FOR ALL ENTRIES IN @li_ekkn
          WHERE vbeln EQ @li_ekkn-vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbak_s BY vbeln.
      ENDIF. " IF sy-subrc EQ 0
* Get PO reference
      SELECT vbeln,
             posnr, " Item number                  "Added by PBANDLAPAL on 02/05/2016 for CR#371 & 435
             konda, " Customer group               "Added by MODUTTA on 02/05/2016 for CR#371 & 435
             pltyp, " Price list type   " ++ by GKINTALI:ERP-7404:ED2K911914:17.04.2018
             bstkd, " Customer purchase order number
             ihrez, " Your Reference    " ++ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
             kdkg2  " Customer condition group 2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
         FROM vbkd " Sales Document: Business Data
         INTO TABLE @DATA(li_vbkd)
         FOR ALL ENTRIES IN @li_ekkn
         WHERE vbeln EQ @li_ekkn-vbeln.

      IF sy-subrc EQ 0.
        SORT li_vbkd BY vbeln.
      ENDIF. " IF sy-subrc EQ 0

* Get End user Customer & Ship to Customer
      SELECT vbeln,
             posnr,     "Added by PBANDLAPAL on 05/22/2016 for CR#371 & 435
             parvw,
             kunnr, " Customer Number
             lifnr  " Account Number of Vendor or Creditor
        FROM vbpa   " Sales Document: Partner
        INTO TABLE @DATA(li_vbpa)
        FOR ALL ENTRIES IN @li_ekkn
        WHERE vbeln EQ @li_ekkn-vbeln
          AND parvw IN @li_parvw.
      IF sy-subrc EQ 0.
        SORT li_vbpa BY vbeln posnr parvw.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF li_ekkn[] IS NOT INITIAL

    IF li_vbpa[] IS NOT INITIAL.

* Get Address Line & Country Name * Country Code & Post Code & Telephone no.
      SELECT kunnr,
             land1,
             name1,
             name2,
             ort01,
             pstlz,
             regio,
             stras,
             telf1,
             adrnr,      " Insert CR#571
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
             anred, " Title
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
             ort02,
             stcd1 " Tax Number 1
        FROM kna1  " General Data in Customer Master
        INTO TABLE @DATA(li_kna1)
        FOR ALL ENTRIES IN @li_vbpa
        WHERE kunnr EQ @li_vbpa-kunnr.

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
* Begin of Change Defect 2048
      IF sy-subrc EQ 0.
        SORT li_kna1 BY kunnr.
      ENDIF.
* End of Change Defect 2048
*<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>

* Begin of Insert for CR#371 & 435 PBANDLAPAL
      DATA(li_vbpa_ag) = li_vbpa[].
      DELETE li_vbpa_ag WHERE parvw NE c_parvw_ag.
      SORT li_vbpa_ag BY vbeln kunnr.
      IF li_vbpa_ag[] IS NOT INITIAL.
        SELECT jrnl_grp_code,
             society,
             society_acrnym
        FROM zqtc_jgc_society
        INTO TABLE @DATA(li_society)
        FOR ALL ENTRIES IN @li_vbpa_ag
        WHERE jrnl_grp_code IN @lir_jrnl
          AND society = @li_vbpa_ag-kunnr.
        IF sy-subrc EQ 0.
          SORT li_society BY jrnl_grp_code society.
        ENDIF.
      ENDIF.
* End of Insert for CR#371 & 435 PBANDLAPAL
* Get Address Line & Country Name * Country Code & Post Code & Telephone no.
* Begin of change Defect 2048
      DATA(li_vbpa_sp) = li_vbpa[].
      DELETE li_vbpa_sp WHERE lifnr = space.
      IF li_vbpa_sp IS NOT INITIAL.
* End of change Defect 2048
        SELECT lifnr,
               land1,
               name1,
               name2,
               ort01,
               pstlz,
               regio,
               stras,
               telf1,
               adrnr,      " Insert CR#571
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
               anred, " Title
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
               ort02,
               stcd1 " Tax Number 1
          FROM lfa1  " General Data in Customer Master
          INTO TABLE @DATA(li_lfa1)
          FOR ALL ENTRIES IN @li_vbpa_sp   " Change for Defect 2048
          WHERE lifnr EQ @li_vbpa_sp-lifnr.   " Change for Defect 2048

        IF sy-subrc EQ 0.
          SORT li_lfa1 BY lifnr.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.      " Insert for Defect 2048

      REFRESH: i_adrnr,    " Insert CR#571
               li_country.
* To append the country from KNA1
      LOOP AT li_kna1 INTO DATA(lst_kna1).
        lst_country-land1 = lst_kna1-land1.
        APPEND lst_country TO li_country.
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
        lst_region-land1 = lst_kna1-land1.
        lst_region-bland = lst_kna1-regio.
        APPEND lst_region TO li_region.
        CLEAR lst_region.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        lst_adrnr-kunnr = lst_kna1-kunnr.
        lst_adrnr-adrnr = lst_kna1-adrnr.
        APPEND lst_adrnr TO i_adrnr.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        CLEAR: lst_adrnr,
               lst_country.
      ENDLOOP. " LOOP AT li_kna1 INTO DATA(lst_kna1)

* To append the country from LFA1
      LOOP AT li_lfa1 INTO DATA(lst_lfa1).
        lst_country-land1 = lst_lfa1-land1.
        APPEND lst_country TO li_country.
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
        lst_region-land1 = lst_lfa1-land1.
        lst_region-bland = lst_lfa1-regio.
        APPEND lst_region TO li_region.
        CLEAR lst_region.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        lst_adrnr-lifnr = lst_lfa1-lifnr.
        lst_adrnr-adrnr = lst_lfa1-adrnr.
        APPEND lst_adrnr TO i_adrnr.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        CLEAR: lst_adrnr,
               lst_country.
      ENDLOOP. " LOOP AT li_lfa1 INTO DATA(lst_lfa1)

      SORT li_country BY land1.
      DELETE ADJACENT DUPLICATES FROM li_country COMPARING land1.

* Get Country Name
* Begin of change CR471
*        SELECT land1,
*               landx               " Country Name
*          FROM t005t               " Country Names
*          INTO TABLE @DATA(li_t005t)
*          FOR ALL ENTRIES IN @li_country
*          WHERE spras EQ @sy-langu "'E'
*            AND land1 EQ @li_country-land1.
      IF li_country[] IS NOT INITIAL.
        SELECT a~land1,
               a~intca3,
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*               b~landx               " Country Name
               b~landx50             " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
        FROM t005 AS a        " Country data
          INNER JOIN t005t AS b               " Country Names
          ON a~land1 = b~land1
        INTO TABLE @DATA(li_t005t)
        FOR ALL ENTRIES IN @li_country
        WHERE b~spras EQ @sy-langu "'E'
          AND a~land1 EQ @li_country-land1.
* End of change CR471
        IF sy-subrc EQ 0.
          SORT li_t005t BY land1.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
      SORT li_region BY land1 bland.
      DELETE ADJACENT DUPLICATES FROM li_region COMPARING land1 bland.
      IF li_region IS NOT INITIAL.
        SELECT land1 " Country Key
               bland " Region (State, Province, County)
               bezei " Description
          FROM t005u " Taxes: Region Key: Texts
          INTO TABLE li_t005u
          FOR ALL ENTRIES IN li_region
          WHERE spras EQ sy-langu
          AND   land1 EQ li_region-land1
          AND   bland EQ li_region-bland.
        SORT li_t005u BY land1 bland.
      ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
      IF i_adrnr[] IS NOT INITIAL.
        SORT i_adrnr BY kunnr lifnr adrnr.
        DELETE ADJACENT DUPLICATES FROM i_adrnr COMPARING kunnr lifnr adrnr.
        SELECT addrnumber,
               name_co,     " ++by BSAKI:03/09/2022:OTCM – 47675 ED2K926022
               street,      " ++by GKINTALI:15/03/2018:ED2K910947:ERP-6967
               str_suppl1,               "RITM0025850 - ED1K907377
               str_suppl2,               "GVS05212018 - ED1K907411
               str_suppl3,
               location,
               tel_number   " ++by NPALLA:12/23/2019:ED1K911472:INC0273232
        FROM adrc
        INTO TABLE @DATA(li_adrc)
        FOR ALL ENTRIES IN @i_adrnr
        WHERE addrnumber EQ @i_adrnr-adrnr.
      ENDIF.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
      " Get Business Partner Category Type
      IF NOT li_kna1[] IS INITIAL.
        SELECT partner,
               type,
               bu_group
          FROM but000
          INTO TABLE @DATA(li_but000)
          FOR ALL ENTRIES IN @li_kna1
          WHERE partner EQ @li_kna1-kunnr.
      ENDIF.        " IF NOT li_kna1[] IS INITIAL.
* EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
    ENDIF. " IF li_vbpa[] IS NOT INITIAL
*  ELSE. " ELSE -> IF sy-subrc EQ 0
**   Message: No data records found for the specified selection criteria
*    MESSAGE i004(wrf_at_generate). " No data records found for the specified selection criteria
  ENDIF. " IF li_po[] IS NOT INITIAL
*  ENDIF. " IF li_mara IS NOT INITIAL

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*If Main Label or Back label is checked
  IF rb1 IS NOT INITIAL.
    DATA(lv_label) = c_type_ml. "ML
  ELSE.
    lv_label = c_type_bl. "BL
  ENDIF.

* Populate the records in back label file
  LOOP AT li_po ASSIGNING FIELD-SYMBOL(<lst_po>).
    READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lst_mara>)
                                 WITH KEY matnr = <lst_po>-matnr.
    IF sy-subrc EQ 0.
      APPEND INITIAL LINE TO fp_li_main_label ASSIGNING FIELD-SYMBOL(<lst_main_label>).

* Populate issue no. details
      <lst_main_label>-matnr = <lst_mara>-matnr. "Unique issueidentifier
      <lst_main_label>-ismcopynr = <lst_mara>-ismcopynr. "Volume
* Begin of Change CR471
*      <lst_main_label>-ismrefmdprod = <lst_mara>-ismrefmdprod. "Acronym
*      <lst_main_label>-ismnrinyear = <lst_mara>-ismnrinyear. "Issue
      CLEAR: lv_matnr,
             lv_mdprod,
             lv_issue,
             lv_len.

      lv_matnr = <lst_mara>-matnr.
      lv_issue = lv_matnr+8(7).
      lv_len  = strlen( lv_issue ).
      lv_mdprod = <lst_mara>-ismrefmdprod.
      <lst_main_label>-ismrefmdprod = lv_mdprod+0(4). "Media Product  " CR#371
      <lst_main_label>-mdprod = lv_mdprod+0(5).
* End of Change CR471
* Begin of Change Defect 2003
      READ TABLE li_jptidcdassign ASSIGNING FIELD-SYMBOL(<fs_jptidcassign>) WITH KEY matnr = <lst_mara>-matnr.
      IF sy-subrc EQ 0 AND <fs_jptidcassign> IS ASSIGNED.
        <lst_main_label>-identcode = <fs_jptidcassign>-identcode.  "Acronym.
      ENDIF.
* End of Change Defect 2003
      <lst_main_label>-ismtitle = <lst_mara>-ismtitle. "Journal Title
      <lst_main_label>-ismyearnr = <lst_mara>-ismyearnr. "Pub Set

* Begin of Change CR471
*      IF <lst_mara>-ismissuetypest IS NOT INITIAL. "'S1'.
** Begin of Change CR471
**        <lst_main_label>-supplement = <lst_mara>-ismissuetypest. "Supplement
*        <lst_main_label>-supplement = lv_matnr+8(lv_len).
*      ELSE.
*        <lst_main_label>-ismnrinyear = lv_matnr+8(lv_len).
** End of Change CR471
*      ENDIF. " IF <lst_mara>-ismissuetypest IS NOT INITIAL

* Populate Product type, Issue and Supplement
      IF lv_matnr+8(1) = c_char_s.
        <lst_main_label>-zprodtype = c_supp_value. "'SUPPLEMENT'.   "Product Type
        <lst_main_label>-supplement = lv_matnr+8(lv_len).     " Supplement
      ELSE. " ELSE -> IF <lst_main_label>-supplement IS NOT INITIAL
        <lst_main_label>-zprodtype = c_iss_value. "'ISS'.   "Product Type

        <lst_main_label>-ismnrinyear = lv_matnr+8(lv_len).   " Issue
      ENDIF. " IF <lst_main_label>-supplement IS NOT INITIAL
*    ENDIF. " IF sy-subrc EQ 0
* End of Change CR471

*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*Issue Description should be display first 15 character of Material Number
*      CONCATENATE <lst_main_label>-ismrefmdprod <lst_main_label>-ismcopynr
** Begin of Change CR471
**         <lst_main_label>-ismnrinyear  <lst_main_label>-part
*          <lst_main_label>-ismnrinyear
** End of Change CR471
*         <lst_main_label>-supplement INTO <lst_main_label>-issue_desc. "Issue Description
      <lst_main_label>-issue_desc = lv_matnr+0(15). "Issue Description
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

* Begin of Change CR471
* To Populate the part
      IF <lst_po>-ebeln IS ASSIGNED.
        <lst_main_label>-part = <lst_po>-ebeln.
      ENDIF.
* End of Change CR471

* Populate Offline Society name
      <lst_main_label>-society_name = space. "Offline Society Name

* Populate Document Type
*    <lst_main_label>-docdate = <lst_po>-aedat. "Sent date
      <lst_main_label>-docdate = sy-datum. "Sent date
      <lst_main_label>-lifnr = <lst_po>-lifnr. "Vendor

* Populate Type
      <lst_main_label>-type = c_type_ml. "'ML'.  "Type

* Parallel Processing technique used
* This is needed as there will be mutiple records for each EBELN and EBELP.
      READ TABLE li_ekbe TRANSPORTING NO FIELDS WITH KEY ebeln = <lst_po>-ebeln
                                                         ebelp = <lst_po>-ebelp BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_tabix) = sy-tabix.
        CLEAR lv_remqty.
        LOOP AT li_ekbe FROM lv_tabix ASSIGNING FIELD-SYMBOL(<lst_ekbe>)
                                                       WHERE ebeln = <lst_po>-ebeln
                                                        AND  ebelp = <lst_po>-ebelp.
          IF <lst_ekbe>-shkzg = c_shkzg_s.
            lv_remqty = lv_remqty + <lst_ekbe>-menge.
          ELSEIF <lst_ekbe>-shkzg = c_shkzg_h.
            lv_remqty = lv_remqty - <lst_ekbe>-menge.
          ENDIF. " IF <lst_ekbe>-shkzg = c_shkzg_s

        ENDLOOP. " LOOP AT li_ekbe FROM lv_tabix ASSIGNING FIELD-SYMBOL(<lst_ekbe>)
        IF lv_remqty IS NOT INITIAL.
          IF cb_del EQ space.   "+ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
            <lst_main_label>-menge = <lst_po>-menge - lv_remqty.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          ELSEIF cb_del EQ abap_true.
            <lst_main_label>-menge = <lst_po>-menge.
          ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        ELSE. " ELSE -> IF lv_remqty IS NOT INITIAL
          <lst_main_label>-menge = <lst_po>-menge.
        ENDIF. " IF lv_remqty IS NOT INITIAL
      ELSE. " ELSE -> IF sy-subrc EQ 0
        <lst_main_label>-menge = <lst_po>-menge.
      ENDIF. " IF sy-subrc EQ 0

* Populate Subscription Ref
      READ TABLE li_ekkn ASSIGNING FIELD-SYMBOL(<lst_ekkn>) WITH KEY ebeln = <lst_po>-ebeln
                                                                     ebelp = <lst_po>-ebelp
                                                                     BINARY SEARCH.
      IF sy-subrc = 0.
*        <lst_main_label>-vbeln = <lst_ekkn>-vbeln. "Subscription Ref. " - <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*      <lst_main_label>-menge = <lst_ekkn>-menge. "Quantity
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        <lst_main_label>-subscrno = <lst_ekkn>-vbeln.     "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

        CLEAR : lv_name, lv_object.
        lv_name = <lst_ekkn>-vbeln.
        lv_object = c_object.
* Populate Shipping Ref
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = c_tdid_ship
            language                = sy-langu
            name                    = lv_name
            object                  = lv_object
            archive_handle          = 0
            local_cat               = space
          TABLES
            lines                   = li_lines[]
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc = 0.
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*          READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX 1.
*          IF sy-subrc = 0.
*            v_ship_instruction = <lst_lines>-tdline.
*            v_ship_instruction1 = <lst_lines>-tdline. " ++ GKINTALI
*Shipping Instruction should print 255 char
          LOOP AT li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>).
            CONCATENATE v_ship_instruction <lst_lines>-tdline INTO v_ship_instruction.
            CONCATENATE v_ship_instruction1 <lst_lines>-tdline INTO v_ship_instruction1.
          ENDLOOP.
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
          IF v_ship_instruction IS NOT INITIAL.
            READ TABLE i_constant INTO lst_constant WITH KEY param1 = c_ship_inst
                                                             param2 = c_type_ml.
            IF sy-subrc EQ 0.
              CONCATENATE lst_constant-low v_ship_instruction INTO v_ship_instruction.
            ENDIF.
          ENDIF.
*          ENDIF. " IF sy-subrc = 0 "- <HIPATEL> <RITM0092591> <ED1K909240>
        ENDIF. " IF sy-subrc = 0
*<<<<<<<<<<<<<<<<<BOC by MODUTTA on 05/02/2017 for CR#371 & 435>>>>>>>>>>>>
* Populate delivery instruction
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = c_tdid_del
            language                = sy-langu
            name                    = lv_name
            object                  = lv_object
            archive_handle          = 0
            local_cat               = space
          TABLES
            lines                   = li_lines_del[]
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc = 0.
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*          READ TABLE li_lines_del ASSIGNING FIELD-SYMBOL(<lst_lines_del>) INDEX 1.
*          IF sy-subrc = 0.
*            v_delv_instruction = <lst_lines_del>-tdline. "Delivery instruction
*          ENDIF. " IF sy-subrc = 0
          LOOP AT li_lines_del ASSIGNING FIELD-SYMBOL(<lst_lines_del>).
            CONCATENATE v_delv_instruction <lst_lines_del>-tdline INTO v_delv_instruction. "Delivery instruction
          ENDLOOP.
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
        ENDIF. " IF sy-subrc = 0
        IF v_ship_instruction IS NOT INITIAL AND v_delv_instruction IS NOT INITIAL.
          CONCATENATE v_ship_instruction v_delv_instruction INTO
                                       <lst_main_label>-shipping_ref SEPARATED BY space. "Shipping Ref
        ELSEIF v_ship_instruction IS NOT INITIAL.
          <lst_main_label>-shipping_ref = v_ship_instruction.
        ELSEIF v_delv_instruction IS NOT INITIAL.
          <lst_main_label>-shipping_ref = v_delv_instruction.
        ENDIF.

*<<<<<<<<<<<<<<<<<EOC by MODUTTA on 05/02/2017 for CR#371 & 435>>>>>>>>>>>>
        READ TABLE li_vbak_s ASSIGNING FIELD-SYMBOL(<lst_vbak_s>) WITH KEY vbeln = <lst_ekkn>-vbeln BINARY SEARCH.
        IF sy-subrc = 0.
          <lst_main_label>-auart = <lst_vbak_s>-auart.
          <lst_main_label>-augru = <lst_vbak_s>-augru.
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
* Logic added to include Sales Organization
          <lst_main_label>-vkorg = <lst_vbak_s>-vkorg.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909717> <03/01/2019>
*Reverse logic implemented for ERP-7404, for remove “EM-“ for ZSRO type.
** BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
** Shipping Reference should not be preceeded with EM- or EB- in case of ZSRO order type
*          IF <lst_main_label>-auart = c_zsro.
*            IF  v_ship_instruction1 IS NOT INITIAL
*            AND v_delv_instruction IS NOT INITIAL.
*              CONCATENATE v_ship_instruction1 v_delv_instruction INTO
*                          <lst_main_label>-shipping_ref SEPARATED BY space. "Shipping Ref
*            ELSEIF v_ship_instruction1 IS NOT INITIAL.
*              <lst_main_label>-shipping_ref = v_ship_instruction1.
*            ELSEIF v_delv_instruction IS NOT INITIAL.
*              <lst_main_label>-shipping_ref = v_delv_instruction.
*            ENDIF.
*          ENDIF.  " <lst_main_label>-auart = c_zsro
** EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909717> <03/01/2019>
* Populate Priority
          IF <lst_vbak_s>-vsbed = c_shpcon_01.
            <lst_main_label>-priority = 90. "Priority
          ELSEIF <lst_vbak_s>-vsbed = c_shpcon_02. " ELSE -> IF <lst_po>-inco1 = c_inco1_ddp
            <lst_main_label>-priority = 95. "Priority
          ELSEIF <lst_vbak_s>-vsbed = c_shpcon_03.
            <lst_main_label>-priority = 80. "Priority
          ELSEIF <lst_vbak_s>-vsbed = c_char_blank.
            <lst_main_label>-priority = 90. "Priority
          ENDIF. " IF <lst_vbak_s>-vsbed = c_shpcon_01
          READ TABLE li_vbfa ASSIGNING FIELD-SYMBOL(<lst_vbfa>) WITH KEY vbeln = <lst_ekkn>-vbeln BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak_i>) WITH KEY vbeln = <lst_vbfa>-vbelv BINARY SEARCH.
            IF sy-subrc EQ 0.
              <lst_main_label>-auart = <lst_vbak_i>-auart.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
* Logic added to include Sales Organization
              <lst_main_label>-vkorg = <lst_vbak_i>-vkorg.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
            ENDIF. "  IF sy-subrc EQ 0.
          ENDIF.
          CASE <lst_main_label>-auart.
            WHEN c_free_issue OR 'ZFOC'. "'ZCOP'.
              IF <lst_vbak_s> IS ASSIGNED.
                <lst_main_label>-auart1 = <lst_vbak_s>-vbeln. "Free Issue Ref
              ENDIF.
              <lst_main_label>-auart2 = space. "Claim Ref
              <lst_main_label>-auart3 = space. "Sample Copy Ref
              CLEAR <lst_main_label>-vbeln.
            WHEN c_claim_ref. "'ZCLM'.
              <lst_main_label>-auart1 = space. "Free Issue Ref
              IF <lst_vbak_s> IS ASSIGNED.
                <lst_main_label>-auart2 = <lst_vbak_s>-vbeln. "Claim Ref
              ENDIF.
              <lst_main_label>-auart3 = space. "Sample Copy Ref
              CLEAR <lst_main_label>-vbeln.
            WHEN 'ZCSS'.
              <lst_main_label>-auart1 = space. "Free Issue Ref
              <lst_main_label>-auart2 = space. "Claim Ref
              IF <lst_vbak_s> IS ASSIGNED.
                <lst_main_label>-auart3 = <lst_vbak_s>-vbeln. "Sample Copy Ref
              ENDIF.
              CLEAR <lst_main_label>-vbeln.
            WHEN OTHERS.
          ENDCASE.
        ENDIF.
*End of change by PBANDLAPAL on 05/28/2017 for CR#371 & 435
*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
        IF <lst_main_label>-auart IS INITIAL.
          <lst_main_label>-auart = c_star.
        ENDIF.

        IF <lst_main_label>-augru IS INITIAL.
          <lst_main_label>-augru = c_star.
        ENDIF.

* Populate PO Ref
        READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) WITH KEY vbeln = <lst_ekkn>-vbeln BINARY SEARCH.
        IF sy-subrc = 0.
          <lst_main_label>-bstkd = <lst_vbkd>-bstkd. "Purchase Order Ref.
*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
          READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_itm>) WITH KEY vbeln = <lst_ekkn>-vbeln
                                                                             posnr = <lst_ekkn>-vbelp.
          IF sy-subrc EQ 0.
            <lst_main_label>-konda = <lst_vbkd_itm>-konda.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
            <lst_main_label>-kdkg2 = <lst_vbkd_itm>-kdkg2.  " Customer condition group 2
            <lst_main_label>-pltyp = <lst_vbkd_itm>-pltyp.  " Price List Type
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
            <lst_main_label>-vbeln = <lst_vbkd_itm>-ihrez.     "Subscription Ref.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          ELSE.
            READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_hdr>) WITH KEY vbeln = <lst_ekkn>-vbeln
                                                                               posnr = c_blank_zeros.
            IF sy-subrc EQ 0.
              <lst_main_label>-konda = <lst_vbkd_hdr>-konda.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
              <lst_main_label>-kdkg2 = <lst_vbkd_hdr>-kdkg2.  " Customer condition group 2
              <lst_main_label>-pltyp = <lst_vbkd_hdr>-pltyp.  " Price List Type
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
              <lst_main_label>-vbeln =  <lst_vbkd_hdr>-ihrez.     "Subscription Ref.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
            ENDIF.
          ENDIF.
          IF <lst_main_label>-konda IS INITIAL.
            <lst_main_label>-konda = c_star.
          ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
        ENDIF. " IF sy-subrc = 0

* Populate End use customer
        READ TABLE li_vbpa INTO DATA(lst_vbpa_c) WITH KEY vbeln = <lst_ekkn>-vbeln
                                                          posnr = <lst_ekkn>-vbelp   " Insert CR#371 and 435
                                                          parvw = c_parvw_we BINARY SEARCH.
        IF sy-subrc = 0.
          <lst_main_label>-cust = lst_vbpa_c-kunnr. "End use customer
          <lst_main_label>-ship_to_cust = lst_vbpa_c-kunnr. "Ship to customer
* Begin of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
        ELSE.
          READ TABLE li_vbpa INTO lst_vbpa_c WITH KEY vbeln = <lst_ekkn>-vbeln
                                                       posnr = c_blank_zeros
                                                       parvw = c_parvw_we BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_main_label>-cust = lst_vbpa_c-kunnr. "End use customer
            <lst_main_label>-ship_to_cust = lst_vbpa_c-kunnr. "Ship to customer
          ENDIF.
* End of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
        ENDIF. " IF sy-subrc = 0

* Populate ship to customer
        READ TABLE li_vbpa INTO DATA(lst_vbpa_s) WITH KEY vbeln = <lst_ekkn>-vbeln
                                                          posnr = <lst_ekkn>-vbelp  " Insert CR#371 and 435
                                                          parvw = c_parvw_sp BINARY SEARCH.
        IF sy-subrc = 0.
          <lst_main_label>-ship_to_cust = lst_vbpa_s-lifnr. "Ship to customer
* Begin of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
        ELSE.
          READ TABLE li_vbpa INTO lst_vbpa_s WITH KEY vbeln = <lst_ekkn>-vbeln
                                                      posnr = c_blank_zeros  " Insert CR#371 and 435
                                                      parvw = c_parvw_sp BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_main_label>-ship_to_cust = lst_vbpa_s-lifnr. "Ship to customer
          ENDIF.
* End of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
        ENDIF. " IF sy-subrc = 0

* Populate Consolidation Type
        IF <lst_main_label>-cust EQ <lst_main_label>-ship_to_cust.
          <lst_main_label>-zcontyp = c_contyp_d. " 'D'.    "Consolidation Type
        ELSE. " ELSE -> IF <lst_main_label>-cust EQ <lst_main_label>-ship_to_cust
          <lst_main_label>-zcontyp = c_contyp_f. "'F'.    "Consolidation Type
        ENDIF. " IF <lst_main_label>-cust EQ <lst_main_label>-ship_to_cust

        READ TABLE li_lfa1 ASSIGNING FIELD-SYMBOL(<lst_lfa1>) WITH KEY lifnr = lst_vbpa_s-lifnr BINARY SEARCH.
        IF sy-subrc = 0.
*        <lst_main_label>-land1 = <lst_lfa1>-land1. "Country Code    " Comment CR 471
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
*        <lst_main_label>-name1 = <lst_lfa1>-name1. "Address Line 1
          IF <lst_lfa1>-anred IS NOT INITIAL.
            <lst_main_label>-name1 = <lst_lfa1>-anred && ` ` && <lst_lfa1>-name1. "Address Line 1
          ELSE.
            <lst_main_label>-name1 = <lst_lfa1>-name1. "Address Line 1
          ENDIF.
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
          <lst_main_label>-name2 = <lst_lfa1>-name2. "Address Line 2
          <lst_main_label>-ort01 = <lst_lfa1>-ort01. "Address Line 5
          <lst_main_label>-pstlz = <lst_lfa1>-pstlz. "Post Code
          <lst_main_label>-ort02 = <lst_lfa1>-ort02. "Address Line 4 - District
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
*          <lst_main_label>-regio = <lst_lfa1>-regio. "State
          IF s_land1[] IS NOT INITIAL AND <lst_lfa1>-land1 IN s_land1[].
            <lst_main_label>-regio = <lst_lfa1>-regio. " State Code
          ELSE.
            READ TABLE li_t005u INTO lst_t005u WITH KEY land1 = <lst_lfa1>-land1
                                                        bland = <lst_lfa1>-regio BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_main_label>-regio = lst_t005u-bezei.  " State Description
            ELSE.
              <lst_main_label>-regio = <lst_lfa1>-regio. " State Code
            ENDIF.
          ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*        <lst_main_label>-stras = <lst_lfa1>-stras. "Address Line 3
          READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = <lst_lfa1>-adrnr.
          IF sy-subrc EQ 0.
* BOC - GKINTALI - 05/19/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
****************************Address Lines 1 and 2  *************************************
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
* Considering Street2 (ADRC-STR_SUPPL1) in the Address
            CLEAR : lv_actv_flag.
            CALL FUNCTION 'ZCA_ENH_CONTROL'
              EXPORTING
                im_wricef_id   = lc_wricef_id
                im_ser_num     = lc_ser_num
                im_var_key     = lc_jfds
              IMPORTING
                ex_active_flag = lv_actv_flag.
            IF lv_actv_flag IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
              CLEAR: lst_tmp_name.
              IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                CONCATENATE lst_tmp_name <lst_main_label>-name1 " Salutation + Name1
                                         ` `                    " Space
                                         <lst_main_label>-name2 " Name 2
                                    INTO lst_tmp_name.
                IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                              c_semicol           " Semi-colon
                              ` `                 " Space
                              lst_adrc-str_suppl1 " Street 2
                         INTO lst_tmp_name.

* Split at 50 chars and move to <lst_main_label>-name1 and <lst_main_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                  CLEAR: li_outlines, lst_line.
                  CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                    EXPORTING
                      textline            = lst_tmp_name
                      delimiter           = ' '
                      outputlen           = c_splt_len    " 50
                    TABLES
                      out_lines           = li_outlines[]
                    EXCEPTIONS
                      outputlen_too_large = 1
                      OTHERS              = 2.
                  IF sy-subrc <> 0.
*   Nothing to implement here
                  ENDIF.
                  IF li_outlines[] IS NOT INITIAL.
                    LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                      CASE sy-tabix.
                        WHEN 1.
                          <lst_main_label>-name1 = lst_line-line. " Address Line 1
                        WHEN 2.
                          <lst_main_label>-name2 = lst_line-line. " Address Line 2
                      ENDCASE.
                    ENDLOOP.
                  ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  <lst_main_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                  <lst_main_label>-name2 = lst_adrc-str_suppl1. " Street2
                ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
              ELSE.  " Street2 is blank here
* No change as Salutation + Name1 is already moved to <lst_main_label>-name1
* and Name2 to <lst_main_label>-name2
              ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
            ELSE. " ++by BSAKI ED2K926022 "IF lv_actv_flag IS INITIAL.
              IF ( <lst_main_label>-type = c_type_bl "'BL'
                OR <lst_main_label>-type = c_type_ml )
                AND v_ship_instruction IS NOT INITIAL."'ML'.
                CLEAR: lst_tmp_name.
                CONCATENATE lst_tmp_name lst_adrc-name_co          " C/O
                                            ` `                    " Space
                                         <lst_main_label>-name1    " Salutation + Name1
                                       INTO lst_tmp_name.
                <lst_main_label>-name1 = lst_tmp_name.        " C/O Name + Salutation + Name1
                CLEAR: lst_tmp_name.
                CONCATENATE lst_tmp_name <lst_main_label>-name2    " Name2
                                            ` `                    " Space
                                         lst_adrc-str_suppl1       " Street2
                                       INTO lst_tmp_name.
                <lst_main_label>-name2 = lst_tmp_name.             " Name2 + Street2
              ELSE. "IF <lst_main_label>-type = 'BL'.
                CLEAR: lst_tmp_name.
                IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                  CONCATENATE lst_tmp_name <lst_main_label>-name1 " Salutation + Name1
                                           ` `                    " Space
                                           <lst_main_label>-name2 " Name 2
                                      INTO lst_tmp_name.
                  IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                                c_semicol           " Semi-colon
                                ` `                 " Space
                                lst_adrc-str_suppl1 " Street 2
                           INTO lst_tmp_name.

* Split at 50 chars and move to <lst_main_label>-name1 and <lst_main_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                    CLEAR: li_outlines, lst_line.
                    CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                      EXPORTING
                        textline            = lst_tmp_name
                        delimiter           = ' '
                        outputlen           = c_splt_len    " 50
                      TABLES
                        out_lines           = li_outlines[]
                      EXCEPTIONS
                        outputlen_too_large = 1
                        OTHERS              = 2.
                    IF sy-subrc <> 0.
*   Nothing to implement here
                    ENDIF.
                    IF li_outlines[] IS NOT INITIAL.
                      LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                        CASE sy-tabix.
                          WHEN 1.
                            <lst_main_label>-name1 = lst_line-line. " Address Line 1
                          WHEN 2.
                            <lst_main_label>-name2 = lst_line-line. " Address Line 2
                        ENDCASE.
                      ENDLOOP.
                    ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                  ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    <lst_main_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                    <lst_main_label>-name2 = lst_adrc-str_suppl1. " Street2
                  ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                ELSE.  " Street2 is blank here
* No change as Salutation + Name1 is already moved to <lst_main_label>-name1
* and Name2 to <lst_main_label>-name2
                ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
              ENDIF. "IF <lst_main_label>-type = 'BL'.
            ENDIF. "IF lv_actv_flag IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
***********************   Address Lines 3 and 4 *******************************
            IF lst_adrc-location IS NOT INITIAL.  " Street5
              <lst_main_label>-stras = lst_adrc-location.   " Address Line3 = Street5
              CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
              IF lst_adrc-street IS NOT INITIAL.
                CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street
              ENDIF.
              IF lst_adrc-str_suppl3 IS NOT INITIAL.  " Street4
                IF lst_tmp IS NOT INITIAL.
                  CONCATENATE lst_tmp                 " Street
                              c_semicol               " Semi-Colon
                              ` `                     " Space
                              lst_adrc-str_suppl3     " Street 4
                         INTO lst_tmp.                " Street + Street4
                ELSE.
                  CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                ENDIF.
              ENDIF.
              <lst_main_label>-ort02 = lst_tmp.       " Address Line4 = Street + Street4
            ELSE.  " Stree5 is blank here
* If street is exceeding 50 characters
              IF strlen( lst_adrc-street ) > c_splt_len.  " 50
                CLEAR: lst_tmp_name, li_outlines, lst_line.
                CONCATENATE lst_adrc-street            " Street (60char field)
                            c_semicol                  " Semi-Colon
                            ` `                        " Space
                            lst_adrc-str_suppl3        " Street4 (40char field)
                       INTO lst_tmp_name.
* Calling the FM to split the concatenated string into strings of 50 char each
                CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                  EXPORTING
                    textline            = lst_tmp_name
                    delimiter           = ' '
                    outputlen           = c_splt_len    " 50
                  TABLES
                    out_lines           = li_outlines[]
                  EXCEPTIONS
                    outputlen_too_large = 1
                    OTHERS              = 2.
                IF sy-subrc <> 0.
*   Nothing to implement here
                ENDIF.
                IF li_outlines[] IS NOT INITIAL.
                  LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 3 and 4 respectively
                    CASE sy-tabix.
                      WHEN 1.
                        <lst_main_label>-stras = lst_line-line. " Address Line 3
                      WHEN 2.
                        <lst_main_label>-ort02 = lst_line-line. " Address Line 4
                    ENDCASE.
                  ENDLOOP.  " LOOP AT li_outlines INTO lst_line.
                ENDIF.  " IF li_outlines[] IS NOT INITIAL.
              ELSE.  " Street is < 50 characters here
                <lst_main_label>-stras = lst_adrc-street.     " Street  - Addr Line3
                <lst_main_label>-ort02 = lst_adrc-str_suppl3. " Street4 - Addr Line4
              ENDIF.   " IF strlen( lst_adrc-street ) > c_splt_len.  " 50
            ENDIF.   " IF lst_adrc-location IS NOT INITIAL.  " Street5
* EOC - GKINTALI - 05/19/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
***** BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
            " This logic is exclusively added to format Address line 3 & 4 values for
            " Individual business partners only
            READ TABLE li_but000 INTO DATA(lst_but000)
                                 WITH KEY partner = <lst_main_label>-ship_to_cust.
            IF sy-subrc = 0 AND lst_but000-type = c_bu_per.
              CLEAR : <lst_main_label>-stras, <lst_main_label>-ort02.
              IF NOT lst_adrc-str_suppl2 IS INITIAL.                 " Street3
                <lst_main_label>-stras = lst_adrc-str_suppl2.        " Address Line3 = Street3
                CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
                IF lst_adrc-location IS NOT INITIAL.                 " Street5
                  CONCATENATE lst_tmp lst_adrc-location INTO lst_tmp." Street5
                ENDIF.
                IF lst_adrc-street IS NOT INITIAL.
                  CONCATENATE lst_tmp                              " Street
*                               c_semicol                            " Semi-Colon
                              ` `                                  " Space
                              lst_adrc-street                      " Street
                         INTO lst_tmp.                             " Street5 + Street
                ELSE.
                  CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street5 + Street
                ENDIF.
                IF lst_adrc-str_suppl3 IS NOT INITIAL.               " Street4
                  IF lst_tmp IS NOT INITIAL.
                    CONCATENATE lst_tmp                              " Street
*                                c_semicol                            " Semi-Colon
                                ` `                                  " Space
                                lst_adrc-str_suppl3                  " Street 4
                           INTO lst_tmp.                             " Street5 + Street + Street4
                  ELSE.
                    CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                    " Street5 + Street + Street4
                  ENDIF.
                ENDIF.
                <lst_main_label>-ort02 = lst_tmp.                    " Address Line4 = Street + Street4
              ELSE.                                                  " Street3 is blank
                IF NOT lst_adrc-location IS INITIAL.                 " Street 5
                  <lst_main_label>-stras = lst_adrc-location.        " Address Line 3
                  CLEAR: lst_tmp_name, li_outlines, lst_line.
                  CONCATENATE lst_adrc-street                         " Street
*                              c_semicol                               " Semi-Colon
                              ` `                                     " Space
                              lst_adrc-str_suppl3                     " Street 4
                         INTO lst_tmp_name.
                  <lst_main_label>-ort02 = lst_tmp_name.              " Address Line 4
                ELSE.
                  <lst_main_label>-stras = lst_adrc-street.           " Address Line 3 = Street
                  <lst_main_label>-ort02 = lst_adrc-str_suppl3.       " Address Line 4 = Street 4
                ENDIF.           " IF NOT lst_adrc-location IS INITIAL.                 " Street 5
              ENDIF.             " IF NOT lst_adrc-str_suppl2 IS INITIAL.
            ENDIF.               " IF sy-subrc = 0 AND lst_but000-type = '1'.
***** EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
* BOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
*            CONCATENATE <lst_lfa1>-stras lst_adrc-str_suppl3 lst_adrc-location
*                                   INTO <lst_main_label>-stras SEPARATED BY c_comma.
* EOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
            IF lst_adrc-tel_number IS NOT INITIAL.  " Full Telephone Number
              <lst_main_label>-tel_number = lst_adrc-tel_number.
            ENDIF.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
          ELSE.
* Considering the field STREET from Vendor Master: LFA1-STRAS if ADRC does not exist
            <lst_main_label>-stras = <lst_lfa1>-stras. "Address Line 3
*            <lst_main_label>-stras = lst_adrc-street. "Address Line 3
          ENDIF.
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
          <lst_main_label>-telf1 = <lst_lfa1>-telf1. "Telephone number
* BOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
* Commented this line and added before. In case of AddressLine3 not exceeding 50char,
* this value will be continued. Otherwise, the splitted string will be overwriting this.
*          <lst_main_label>-ort02 = <lst_lfa1>-ort02. "Address Line 4
* EOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
          READ TABLE li_t005t ASSIGNING FIELD-SYMBOL(<lst_t005t_f>) WITH KEY land1 = <lst_lfa1>-land1 BINARY SEARCH.
          IF sy-subrc = 0.
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*            <lst_main_label>-landx = <lst_t005t_f>-landx. "Country Name
            <lst_main_label>-landx50 = <lst_t005t_f>-landx50. " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
            <lst_main_label>-land1 =  <lst_t005t_f>-intca3. " Country ISO code " Insert CR#471
            <lst_main_label>-country  = <lst_t005t_f>-land1. " Two character Country  " Insert for CR 371 & 435.
          ENDIF. " IF sy-subrc = 0
        ELSE. " ELSE -> IF sy-subrc = 0
* Populate Distributor
          READ TABLE li_kna1 ASSIGNING FIELD-SYMBOL(<lst_kna1>) WITH KEY kunnr = lst_vbpa_c-kunnr BINARY SEARCH.
          IF sy-subrc = 0.
*            IF <lst_kna1>-stcd1 = c_cntry_ca.
*              <lst_main_label>-stcd1 = <lst_kna1>-stcd1. "Canadian GST no.
*            ENDIF. " IF <lst_kna1>-stcd1 = c_cntry_ca

*          <lst_main_label>-land1 = <lst_kna1>-land1. "Country Code          " Comment  CR#471
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
*        <lst_main_label>-name1 = <lst_kna1>-name1. "Address Line 1
            IF <lst_kna1>-anred IS NOT INITIAL.
              <lst_main_label>-name1 = <lst_kna1>-anred && ` ` && <lst_kna1>-name1. "Address Line 1
            ELSE.
              <lst_main_label>-name1 = <lst_kna1>-name1. "Address Line 1
            ENDIF.
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
            <lst_main_label>-name2 = <lst_kna1>-name2. "Address Line 2
            <lst_main_label>-ort01 = <lst_kna1>-ort01. "Address Line 5
            <lst_main_label>-pstlz = <lst_kna1>-pstlz. "Post Code
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
            <lst_main_label>-ort02 = <lst_kna1>-ort02. "Address Line 4
*            <lst_main_label>-regio = <lst_kna1>-regio. "State
            IF s_land1[] IS NOT INITIAL AND <lst_kna1>-land1 IN s_land1[].
              <lst_main_label>-regio = <lst_kna1>-regio. "State
            ELSE.
              READ TABLE li_t005u INTO lst_t005u WITH KEY land1 = <lst_kna1>-land1
                                                          bland = <lst_kna1>-regio BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_main_label>-regio = lst_t005u-bezei.  " State Description
              ELSE.
                <lst_main_label>-regio = <lst_kna1>-regio. "State
              ENDIF.
            ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478

* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*      <lst_main_label>-stras = <lst_kna1>-stras. "Address Line 3
            CLEAR lst_adrc.
            READ TABLE li_adrc INTO lst_adrc WITH KEY addrnumber = <lst_kna1>-adrnr.
            IF sy-subrc EQ 0.
******************Begin - Address Lines 1 and 2 *******************************
* BOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
* Considering Street2 (ADRC-STR_SUPPL1) in the address
*BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
* Considering Street2 (ADRC-STR_SUPPL1) in the Address
              CLEAR : lv_actv_flag.
              CALL FUNCTION 'ZCA_ENH_CONTROL'
                EXPORTING
                  im_wricef_id   = lc_wricef_id
                  im_ser_num     = lc_ser_num
                  im_var_key     = lc_jfds
                IMPORTING
                  ex_active_flag = lv_actv_flag.
              IF lv_actv_flag IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
                CLEAR: lst_tmp_name.
                IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                  CONCATENATE lst_tmp_name <lst_main_label>-name1 " Salutation + Name1
                                           ` `                    " Space
                                           <lst_main_label>-name2 " Name 2
                                      INTO lst_tmp_name.
                  IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                                c_semicol           " Semi-colon
                                ` `                 " Space
                                lst_adrc-str_suppl1 " Street 2
                           INTO lst_tmp_name.

* Split at 50 chars and move to <lst_main_label>-name1 and <lst_main_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                    CLEAR: li_outlines, lst_line.
                    CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                      EXPORTING
                        textline            = lst_tmp_name
                        delimiter           = ' '
                        outputlen           = c_splt_len    " 50
                      TABLES
                        out_lines           = li_outlines[]
                      EXCEPTIONS
                        outputlen_too_large = 1
                        OTHERS              = 2.
                    IF sy-subrc <> 0.
*   Nothing to implement here
                    ENDIF.
                    IF li_outlines[] IS NOT INITIAL.
                      LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                        CASE sy-tabix.
                          WHEN 1.
                            <lst_main_label>-name1 = lst_line-line. " Address Line 1
                          WHEN 2.
                            <lst_main_label>-name2 = lst_line-line. " Address Line 2
                        ENDCASE.
                      ENDLOOP.
                    ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                  ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    <lst_main_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                    <lst_main_label>-name2 = lst_adrc-str_suppl1. " Street2
                  ENDIF.  " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                ELSE.
* No change as Salutation + Name1 is already moved to <lst_main_label>-name1
* and Name2 to <lst_main_label>-name2
                ENDIF.
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
              ELSE. " ++by BSAKI "IF lv_actv_flag IS INITIAL.
                IF ( <lst_main_label>-type = c_type_bl"'BL'
                  OR <lst_main_label>-type = c_type_ml )
                  AND v_ship_instruction IS NOT INITIAL. "'ML'.
                  CLEAR: lst_tmp_name.
                  CONCATENATE lst_tmp_name lst_adrc-name_co          " C/O
                                              ` `                    " Space
                                           <lst_main_label>-name1    " Salutation + Name1
                                         INTO lst_tmp_name.
                  <lst_main_label>-name1 = lst_tmp_name.        " C/O Name + Salutation + Name1
                  CLEAR: lst_tmp_name.
                  CONCATENATE lst_tmp_name <lst_main_label>-name2    " Name2
                                              ` `                    " Space
                                           lst_adrc-str_suppl1       " Street2
                                         INTO lst_tmp_name.
                  <lst_main_label>-name2 = lst_tmp_name.             " Name2 + Street2
                ELSE. " IF <lst_main_label>-type = 'BL'.
                  CLEAR: lst_tmp_name.
                  IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                    CONCATENATE lst_tmp_name <lst_main_label>-name1 " Salutation + Name1
                                             ` `                    " Space
                                             <lst_main_label>-name2 " Name 2
                                        INTO lst_tmp_name.
                    IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                      CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                                  c_semicol           " Semi-colon
                                  ` `                 " Space
                                  lst_adrc-str_suppl1 " Street 2
                             INTO lst_tmp_name.

* Split at 50 chars and move to <lst_main_label>-name1 and <lst_main_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                      CLEAR: li_outlines, lst_line.
                      CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                        EXPORTING
                          textline            = lst_tmp_name
                          delimiter           = ' '
                          outputlen           = c_splt_len    " 50
                        TABLES
                          out_lines           = li_outlines[]
                        EXCEPTIONS
                          outputlen_too_large = 1
                          OTHERS              = 2.
                      IF sy-subrc <> 0.
*   Nothing to implement here
                      ENDIF.
                      IF li_outlines[] IS NOT INITIAL.
                        LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                          CASE sy-tabix.
                            WHEN 1.
                              <lst_main_label>-name1 = lst_line-line. " Address Line 1
                            WHEN 2.
                              <lst_main_label>-name2 = lst_line-line. " Address Line 2
                          ENDCASE.
                        ENDLOOP.
                      ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                    ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                      <lst_main_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                      <lst_main_label>-name2 = lst_adrc-str_suppl1. " Street2
                    ENDIF.  " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  ELSE.
* No change as Salutation + Name1 is already moved to <lst_main_label>-name1
* and Name2 to <lst_main_label>-name2
                  ENDIF.
                ENDIF. " IF <lst_main_label>-type = 'BL'.
              ENDIF. "IF lv_actv_flag IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
******************Begin - Address Lines 3 and 4 *******************************
              IF lst_adrc-location IS NOT INITIAL.  " Street5
                <lst_main_label>-stras = lst_adrc-location.   " Address Line3 = Street5
                CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
                IF lst_adrc-street IS NOT INITIAL.
                  CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street
                ENDIF.
                IF lst_adrc-str_suppl3 IS NOT INITIAL.
                  IF lst_tmp IS NOT INITIAL.
                    CONCATENATE lst_tmp                 " Street
                                c_semicol               " Semi-Colon
                                ` `                     " Space
                                lst_adrc-str_suppl3     " Street 4
                           INTO lst_tmp.                " Street + Street
                  ELSE.
                    CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                  ENDIF.
                ENDIF.
                <lst_main_label>-ort02 = lst_tmp.       " Address Line4 = Street + Street4
              ELSE.  " Stree5 is balnk here
* If street is exceeding 50 characters
                IF strlen( lst_adrc-street ) > c_splt_len.  " 50
                  CLEAR: lst_tmp_name, li_outlines, lst_line.
                  CONCATENATE lst_adrc-street            " Street (60char field)
                              c_semicol                  " Semi-Colon
                              ` `                        " Space
                              lst_adrc-str_suppl3+0(40)  " Street (40char field)
                         INTO lst_tmp_name.
* Calling the FM to split the concatenated string into strings of 50 char each
                  CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                    EXPORTING
                      textline            = lst_tmp_name
                      delimiter           = ' '
                      outputlen           = c_splt_len    " 50
                    TABLES
                      out_lines           = li_outlines[]
                    EXCEPTIONS
                      outputlen_too_large = 1
                      OTHERS              = 2.
                  IF sy-subrc <> 0.
*   Nothing to implement here
                  ENDIF.
                  IF li_outlines[] IS NOT INITIAL.
                    LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 3 and 4 respectively
                      CASE sy-tabix.
                        WHEN 1.
                          <lst_main_label>-stras = lst_line-line. " Address Line 3
                        WHEN 2.
                          <lst_main_label>-ort02 = lst_line-line. " Address Line 4
                      ENDCASE.
                    ENDLOOP.  " LOOP AT li_outlines INTO lst_line.
                  ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                ELSE.  " Street is < 50 characters here
                  <lst_main_label>-stras = lst_adrc-street.         " Street  - Address Line3
                  <lst_main_label>-ort02 = lst_adrc-str_suppl3.     " Street4 - Address Line4
                ENDIF.   " IF strlen( lst_adrc-street ) > c_splt_len.  " 50
              ENDIF.   " IF lst_adrc-location IS NOT INITIAL.  " Street5
* EOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
**** BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
              "This logic is exclusively added to format Address line 3 & 4 values for
              "Individual business partners only
              CLEAR lst_but000.
              READ TABLE li_but000 INTO lst_but000
                                   WITH KEY partner = <lst_main_label>-ship_to_cust.
              IF sy-subrc = 0 AND lst_but000-type = c_bu_per.
                CLEAR : <lst_main_label>-stras, <lst_main_label>-ort02.
                IF NOT lst_adrc-str_suppl2 IS INITIAL.                 " Street3
                  <lst_main_label>-stras = lst_adrc-str_suppl2.        " Address Line3 = Street3
                  CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
                  IF lst_adrc-location IS NOT INITIAL.                 " Street5
                    CONCATENATE lst_tmp lst_adrc-location INTO lst_tmp." Street5
                  ENDIF.
                  IF lst_adrc-street IS NOT INITIAL.
                    CONCATENATE lst_tmp                              " Street
*                               c_semicol                            " Semi-Colon
                                ` `                                  " Space
                                lst_adrc-street                      " Street
                           INTO lst_tmp.                             " Street5 + Street
                  ELSE.
                    CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street5 + Street
                  ENDIF.
                  IF lst_adrc-str_suppl3 IS NOT INITIAL.               " Street4
                    IF lst_tmp IS NOT INITIAL.
                      CONCATENATE lst_tmp                              " Street
*                                c_semicol                            " Semi-Colon
                                  ` `                                  " Space
                                  lst_adrc-str_suppl3                  " Street 4
                             INTO lst_tmp.                             " Street5 + Street + Street4
                    ELSE.
                      CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                      " Street5 + Street + Street4
                    ENDIF.
                  ENDIF.
                  <lst_main_label>-ort02 = lst_tmp.                    " Address Line4 = Street + Street4
                ELSE.                                                  " Street3 is blank
                  IF NOT lst_adrc-location IS INITIAL.                 " Street 5
                    <lst_main_label>-stras = lst_adrc-location.        " Address Line 3
                    CLEAR: lst_tmp_name, li_outlines, lst_line.
                    CONCATENATE lst_adrc-street                         " Street
*                              c_semicol                               " Semi-Colon
                                ` `                                     " Space
                                lst_adrc-str_suppl3                     " Street 4
                           INTO lst_tmp_name.
                    <lst_main_label>-ort02 = lst_tmp_name.              " Address Line 4
                  ELSE.
                    <lst_main_label>-stras = lst_adrc-street.           " Address Line 3 = Street
                    <lst_main_label>-ort02 = lst_adrc-str_suppl3.       " Address Line 4 = Street 4
                  ENDIF.           " IF NOT lst_adrc-location IS INITIAL.                 " Street 5
                ENDIF.             " IF NOT lst_adrc-str_suppl2 IS INITIAL.
              ENDIF.               " IF sy-subrc = 0 AND lst_but000-type = '1'.
***** EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
*              CONCATENATE <lst_kna1>-stras lst_adrc-str_suppl3 lst_adrc-location
*                                     INTO <lst_main_label>-stras SEPARATED BY c_comma.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
              IF lst_adrc-tel_number IS NOT INITIAL.  " Full Telephone Number
                <lst_main_label>-tel_number = lst_adrc-tel_number.
              ENDIF.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
            ELSE.
* Considering the field Street from Customer Master : KNA1-STRAS if ADRC does not exist
              <lst_main_label>-stras = <lst_kna1>-stras. "Address Line 3
*              <lst_main_label>-stras = lst_adrc-street. "Address Line 3
            ENDIF.
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
            <lst_main_label>-telf1 = <lst_kna1>-telf1. "Telephone number
* BOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
* Commented this line and added before. In case of AddressLine3 not exceeding 50char,
* this value will be continued. Otherwise, the splitted string will be overwriting this.
*            <lst_main_label>-ort02 = <lst_kna1>-ort02. "Address Line 4
* EOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
            READ TABLE li_t005t ASSIGNING FIELD-SYMBOL(<lst_t005t>) WITH KEY land1 = <lst_kna1>-land1 BINARY SEARCH.
            IF sy-subrc = 0.
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*              <lst_main_label>-landx = <lst_t005t>-landx. "Country Name
              <lst_main_label>-landx50 = <lst_t005t>-landx50. " Country Name (Max. 50 characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
              <lst_main_label>-land1 =  <lst_t005t>-intca3. " Country ISO code " Insert CR#471
              <lst_main_label>-country  = <lst_t005t>-land1. " Two character Country " Insert for CR 371 & 435.
            ENDIF. " IF sy-subrc = 0
* BOC - HIPATEL - ERP-7404 - ED2K911953/ED2K911985 - 26.04.2018
* VAT Registration Number read from ZCACONSTANT table for Canada
            IF <lst_main_label>-country = c_cntry_ca.
              CLEAR lst_constant.
              READ TABLE i_constant INTO lst_constant WITH KEY param1 = <lst_main_label>-vkorg.
              IF sy-subrc EQ 0.
                <lst_main_label>-stcd1 = lst_constant-low. "Canadian GST no.
              ENDIF.
            ENDIF.
* EOC - HIPATEL - ERP-7404 - ED2K911953/ED2K911985 - 26.04.2018
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0
* Begin of Change for CR#371 & 435 PBANDLAPAL
        READ TABLE li_vbpa_ag INTO DATA(lst_vbpa_ag) WITH KEY vbeln = <lst_ekkn>-vbeln
                                                              parvw = c_parvw_ag BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE li_society ASSIGNING FIELD-SYMBOL(<lst_society>) WITH KEY
                                                                   jrnl_grp_code =  <lst_main_label>-identcode
                                                                   society = lst_vbpa_ag-kunnr
                                                                   BINARY SEARCH.
          IF sy-subrc EQ 0.
            <lst_main_label>-society = <lst_society>-society_acrnym.
          ENDIF.
          IF <lst_main_label>-society IS INITIAL.
            <lst_main_label>-society = c_star.
          ENDIF.
        ENDIF.
* End of Change for CR#371 & 435 PBANDLAPAL
*      ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0

* To validate mandatory fields and raise an error messages in error log file.
      PERFORM validate_mandatory_fields_ml USING <lst_main_label>
                                                 <lst_po>-ebeln
                                                 <lst_po>-ebelp.

      CLEAR : lv_itemno,
              lst_vbpa_c,
              lst_vbpa_s,
              v_ship_instruction,
              v_ship_instruction1,  "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
              v_delv_instruction.
    ENDIF.  " Change for CR#371 & 435 PBANDLAPAL
  ENDLOOP. " LOOP AT li_po ASSIGNING FIELD-SYMBOL(<lst_po>)

  DELETE fp_li_main_label WHERE menge IS INITIAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BACK_LABEL_DATA
*&---------------------------------------------------------------------*
*       Get back label data
*----------------------------------------------------------------------*
*  -->  p_s_ship        Shipping Point
*  -->  p_s_matnr       Material
*  -->  p_s_typet       Material Type
*  -->  p_s_doc1        Document Type
*  -->  p_s_date        Document date
*  <--  p_li_back_label Back Label Structure
*----------------------------------------------------------------------*
FORM f_get_back_label_data   USING    fp_s_ship  TYPE fip_t_bsart_range
                                      fp_s_matnr TYPE fip_t_matnr_range
                                      fp_s_type  TYPE fip_t_mtart_range
                                      fp_s_doc1  TYPE fip_t_bsart_range
                                      fp_s_date  TYPE fip_t_erdat_range
                                      fp_lir_idcode_type TYPE tt_idcode_type  "Defect 2003
                            CHANGING  fp_li_back_label TYPE tt_back_label
                                      fp_li_split TYPE tt_split.

* Local internal table Declaration
  DATA : li_lines     TYPE STANDARD TABLE OF tline INITIAL SIZE 0, " SAPscript: Text Lines
*        Added by MODUTTA on 05/02/2017 for CR# 371 & 435
         li_lines_del TYPE STANDARD TABLE OF tline INITIAL SIZE 0, " SAPscript: Text Lines
*         lst_media    TYPE ty_media,
         lir_jrnl     TYPE tt_jrnl,
         lst_jrnl     TYPE ty_jrnl,
         lir_wbstk    TYPE tt_wbstk,  "Goods movement status ++ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
         lst_wbstk    TYPE ty_wbstk.  "Goods movement status ++ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

* Local Variable Declaration
  DATA :lv_name           TYPE tdobname,      " Name
* Begin of Change CR471
        lv_matnr          TYPE matnr,
        lv_issue          TYPE string,
        lv_mdprod         TYPE ismrefmdprod,
        lst_constant      TYPE ty_constant,
        lv_len            TYPE i,        " Len of type Integers
* End of Change CR471
        lst_country       TYPE ty_country,    " Structure for country
        lst_region        TYPE ty_region,     " Structure for Region codes ++GKINTALI:05/18/2018:ED1K907377
        lst_t005u         TYPE ty_t005u,      " Structure for Region Descriptions ++GKINTALI:05/18/2018:ED1K907377
        lst_adrnr         TYPE ty_adrnr,
        li_delv_final     TYPE tt_delv_final, " Final delivery table
        lst_delv_final    TYPE ty_delv_final, " Final delivery table
        lv_vbeln_ref      TYPE vbeln,         " Sales and Distribution Document Number
        lv_object         TYPE tdobject,      " Texts: Application Object
* BOC -  GKINTALI - ERP-6967 - ED2K910947 - 3/14/2018
        lst_tmp(256)      TYPE c,          " Temporary String Structure
        lst_tmp_name(256) TYPE c,     " Temporary String Structure
        li_outlines       TYPE tt_lines,   " Internal table to hold 256-char type entries
        lst_line          TYPE ty_lines,   " 256-char structure
* EOC -  GKINTALI - ERP-6967 - ED2K910947 - 3/14/2018
** BOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
        lst_deliveryitem  TYPE          ty_deliveryitemcatag,
        lir_deliveryitem  TYPE TABLE OF ty_deliveryitemcatag.
** EOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
  CONSTANTS :
    lc_not_proc TYPE wbstk VALUE 'A',   " Total goods movement status
    lc_proc     TYPE wbstk VALUE 'C'.   " Total goods movement status
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
  CONSTANTS: lc_wricef_id TYPE zdevid   VALUE 'I0255', " Development ID
             lc_jfds      TYPE zvar_key VALUE 'JFDS', " var key
             lc_ser_num   TYPE zsno     VALUE '001'.  " Serial Number
  DATA:       lv_actv_flag_b    TYPE zactive_flag . " Active / Inactive Flag
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
* Display Not yet processed and Completely processed based on Selection screen
  CLEAR lir_wbstk[].
  lst_wbstk-sign = c_sign.
  lst_wbstk-option = c_option_eq.
  lst_wbstk-low = lc_not_proc.
  APPEND lst_wbstk TO lir_wbstk.
  CLEAR lst_wbstk.

  IF cb_del = abap_true.
    lst_wbstk-sign = c_sign.
    lst_wbstk-option = c_option_eq.
    lst_wbstk-low = lc_proc.
    APPEND lst_wbstk TO lir_wbstk.
    CLEAR lst_wbstk.
  ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

* BOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
  LOOP AT i_constant INTO DATA(lst_zcaconstant1) WHERE param1 = c_doc_type
                                                   AND param2 = c_file_type.
    lst_deliveryitem-sign    = lst_zcaconstant1-sign.
    lst_deliveryitem-option = lst_zcaconstant1-opti.
    lst_deliveryitem-low    = lst_zcaconstant1-low.
    lst_deliveryitem-high   = lst_zcaconstant1-high.
    APPEND lst_deliveryitem TO lir_deliveryitem.
    CLEAR lst_deliveryitem.
    CLEAR lst_zcaconstant1.
  ENDLOOP.
* EOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
* Get Quantity , Shipping point, Document type
  SELECT lips~vbeln,
         lips~posnr,
         lips~matnr,
         lips~lfimg,
         lips~vgbel,
         lips~vgpos,
         likp~erdat,
         likp~vstel,
         likp~lfart,
         likp~inco1,                  " Incoterms (Part 1)
         vbuk~wbstk                   " Total goods movement status
     FROM lips AS lips
     INNER JOIN likp AS likp
     ON lips~vbeln EQ likp~vbeln
     INNER JOIN vbuk AS vbuk
     ON likp~vbeln EQ vbuk~vbeln
     INTO TABLE @DATA(li_delivery)
* BOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
*     WHERE lips~matnr IN @fp_s_matnr
      WHERE lips~pstyv NOT IN @lir_deliveryitem  "Exclude delivery item catagories(ZCSE,ZCNE)
       AND lips~matnr IN @fp_s_matnr
* EOC - LRRAMIREDD - INC0241797 - ED1K910250 - 30.05.2019
       AND likp~erdat IN @fp_s_date
       AND likp~vstel IN @fp_s_ship
       AND likp~lfart IN @fp_s_doc1
*       AND vbuk~wbstk = @lc_not_proc. " A. " -- <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
       AND vbuk~wbstk IN @lir_wbstk.   " C. " ++ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

  IF sy-subrc EQ 0.
    SORT li_delivery BY vgbel vgpos.
  ENDIF. " IF sy-subrc EQ 0

* Begin of Change: PBOSE: 02-23-2017: ERP-1599: ED2K903844

* Fetch Sales doc number from VBEP table.
  IF li_delivery[] IS NOT INITIAL.
    SELECT vbeln, " Sales Document
           posnr, " Sales Document Item
           banfn  " Purchase Requisition Number
      INTO TABLE @DATA(li_vbep)
      FROM vbep   " Sales Document: Schedule Line Data
      FOR ALL ENTRIES IN @li_delivery
      WHERE vbeln = @li_delivery-vgbel
        AND posnr = @li_delivery-vgpos
        AND banfn = @space.
    IF sy-subrc EQ 0.
      SORT li_vbep BY vbeln.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.
*   Populate final table
  LOOP AT li_vbep INTO DATA(lst_vbep).
    READ TABLE li_delivery INTO DATA(lst_delv_final1)
                       WITH KEY vgbel = lst_vbep-vbeln
                                vgpos = lst_vbep-posnr
                       BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_delv_final-vbeln = lst_delv_final1-vbeln.
      lst_delv_final-posnr = lst_delv_final1-posnr.
      lst_delv_final-matnr = lst_delv_final1-matnr.
      lst_delv_final-lfimg = lst_delv_final1-lfimg.
      lst_delv_final-vgbel = lst_delv_final1-vgbel.
      lst_delv_final-vgpos = lst_delv_final1-vgpos.
      lst_delv_final-erdat = lst_delv_final1-erdat.
      lst_delv_final-vstel = lst_delv_final1-vstel.
      lst_delv_final-lfart = lst_delv_final1-lfart.
      lst_delv_final-inco1 = lst_delv_final1-inco1.
      APPEND lst_delv_final TO li_delv_final.
      CLEAR lst_delv_final1.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT li_vbep INTO DATA(lst_vbep)

  SORT li_delv_final BY matnr.
* End of Change: PBOSE: 02-23-2017: ERP-1599: ED2K903844

  IF li_delv_final[] IS NOT INITIAL.
* Get Issue no.
    SELECT matnr,         " Material Number
           ismrefmdprod,  " Higher-Level Media Product
           ismcopynr,     " Copy Number of Media Issue
           ismnrinyear,   " Issue Number (in Year Number)
           ismtitle,      " Title
           ismyearnr,     " Media issue year number
           ismissuetypest " Issue Variant Type - Standard (Planned)
      FROM mara           " General Material Data
      INTO TABLE @DATA(li_mara)
      FOR ALL ENTRIES IN @li_delv_final
      WHERE matnr EQ @li_delv_final-matnr
        AND mtart IN @fp_s_type.

    IF sy-subrc EQ 0.
      SORT li_mara BY matnr.
* Begin of Change Defect 2003
      SELECT matnr,                         " Material Number
         idcodetype,                    " Type of Identification Code
         identcode                     " Identification Code
    FROM jptidcdassign                 " IS-M: Assignment of ID Codes to Material
    INTO TABLE @DATA(li_jptidcdassign)
    FOR ALL ENTRIES IN @li_mara
    WHERE matnr EQ @li_mara-matnr
      AND idcodetype IN @fp_lir_idcode_type. "c_idcdtyp_zjcd.
      IF sy-subrc = 0.
        SORT li_jptidcdassign[] BY matnr.
      ENDIF.

      LOOP AT li_jptidcdassign INTO DATA(lst_jptidcdassign).
        lst_jrnl-sign = c_sign.
        lst_jrnl-option = c_option_eq.
        lst_jrnl-low = lst_jptidcdassign-identcode.
        APPEND lst_jrnl TO lir_jrnl.
*      CLEAR: lst_jrnl,lst_mara.
      ENDLOOP.

* Get Preceding sales and distribution document
      SELECT vbelv,  " Preceding sales and distribution document
             posnv,  " Preceding Item
             vbeln,  " Subsequent sales and distribution document
             posnn,  " Subsequent Item
             vbtyp_v," Document category of preceding SD document
             stufe   " Level of the document flow record
         FROM vbfa   " Sales Document Flow
         INTO TABLE @DATA(li_vbfa)
         FOR ALL ENTRIES IN @li_delv_final
         WHERE vbeln EQ @li_delv_final-vbeln
           AND vbtyp_v IN (@c_vbtyp_g,@c_vbtyp_c,@c_vbtyp_i).

      IF sy-subrc EQ 0.
        SORT li_vbfa BY vbeln posnn.
      ENDIF. " IF sy-subrc EQ 0

* Begin of Insert PBANDLAPAL on 05-28-2017 for CR371 & 435
      SELECT vbelv,  " Preceding sales and distribution document
                posnv,  " Preceding Item
                vbeln,  " Subsequent sales and distribution document
                posnn,  " Subsequent Item
                vbtyp_v " Document category of preceding SD document
            FROM vbfa   " Sales Document Flow
            INTO TABLE @DATA(li_vbfa_d)
            FOR ALL ENTRIES IN @li_delv_final
            WHERE vbeln EQ @li_delv_final-vgbel
              AND posnn EQ @li_delv_final-vgpos
              AND vbtyp_v IN (@c_vbtyp_g,@c_vbtyp_c,@c_vbtyp_i)
              AND stufe = 00.
      IF sy-subrc EQ 0.
        SORT li_vbfa_d BY vbeln posnn.
      ENDIF. " IF sy-subrc

* End of Insert PBANDLAPAL on 05-28-2017 for CR371 & 435
      IF li_vbfa[] IS NOT INITIAL.
* Get Free issue Ref & Claim Ref & Sample copy Ref
        SELECT vbeln,
               auart,   " Sales Document Type
               augru,   "Reason Code "Insert by MODUTTA for CR#371 & 435
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
               vkorg,   " Sales Organization
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
               vsbed    " Shipping Condition "Insert by PBANDLAPAL for CR#371 & 435
            FROM vbak " Sales Document: Header Data
            INTO TABLE @DATA(li_vbak)
            FOR ALL ENTRIES IN @li_vbfa
            WHERE vbeln EQ @li_vbfa-vbelv.

        IF sy-subrc EQ 0.
          SORT li_vbak BY vbeln.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_vbfa[] IS NOT INITIAL

* To get the shipping conditions data for the reference of delivery
* which is needed to populate priprity field in the output
      SELECT vbeln,
             auart, " Sales Document Type
             vsbed  " Shipping Condition
          FROM vbak " Sales Document: Header Data
          INTO TABLE @DATA(li_vbak_s)
          FOR ALL ENTRIES IN @li_delv_final
          WHERE vbeln EQ @li_delv_final-vgbel.

      IF sy-subrc EQ 0.
        SORT li_vbak_s BY vbeln.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_delv_final[] IS NOT INITIAL

* Get PO reference
    IF li_vbak[] IS NOT INITIAL.
      SELECT vbeln,
             posnr,
             konda, "Customer group                  "Added by MODUTTA on 02/05/2017 for CR#371 & 435
             pltyp, " Price list type - ++by GKINTALI:ERP-7404:ED2K911914:17.04.2018
             bstkd, " Customer purchase order number
             ihrez, " Subscription Ref. ++ <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
             kdkg2  " Customer condition group 2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
         FROM vbkd " Sales Document: Business Data
         INTO TABLE @DATA(li_vbkd)
         FOR ALL ENTRIES IN @li_vbak
         WHERE vbeln EQ @li_vbak-vbeln.

      IF sy-subrc EQ 0.
        SORT li_vbkd BY vbeln.
      ENDIF. " IF sy-subrc EQ 0

* Get End user Customer & Ship to Customer
      SELECT vbeln,
             posnr,     "Added by PBANDLAPAL on 05/22/2016 for CR#371 & 435
             parvw,
             kunnr, " Customer Number
             lifnr  " Freight Forwarder
        FROM vbpa   " Sales Document: Partner
        INTO TABLE @DATA(li_vbpa)
        FOR ALL ENTRIES IN @li_vbak
        WHERE vbeln EQ @li_vbak-vbeln
          AND parvw IN @li_parvw.
      IF sy-subrc EQ 0.
        SORT li_vbpa BY vbeln posnr parvw.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.

* Get Address Line & Country Name * Country Code & Post Code & Telephone no.
    IF li_vbpa[] IS NOT INITIAL.
      SELECT kunnr,
             land1,
             name1,
             name2,
             ort01,
             pstlz,
             regio,
             stras,
             telf1,
             adrnr,      " Insert by PBANDLAPAL on 29-JUN-2017 for CR#571
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
             anred, " Title
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
             ort02,
             stcd1 " Tax Number 1
        FROM kna1  " General Data in Customer Master
        INTO TABLE @DATA(li_kna1)
        FOR ALL ENTRIES IN @li_vbpa
        WHERE kunnr EQ @li_vbpa-kunnr.

      IF sy-subrc EQ 0.
        SORT li_kna1 BY kunnr.
*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
        DATA(li_vbpa_ag) = li_vbpa[].
        DELETE li_vbpa_ag WHERE parvw NE c_parvw_ag.
        SORT li_vbpa_ag BY vbeln kunnr.
        IF li_vbpa_ag IS NOT INITIAL.
          SELECT jrnl_grp_code,
               society,
               society_acrnym
          FROM zqtc_jgc_society
          INTO TABLE @DATA(li_society)
          FOR ALL ENTRIES IN @li_vbpa_ag
          WHERE jrnl_grp_code IN @lir_jrnl
            AND society = @li_vbpa_ag-kunnr.
          IF sy-subrc EQ 0.
            SORT li_society BY jrnl_grp_code.
          ENDIF.
        ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
      ENDIF. " IF sy-subrc EQ 0

* Begin of change Defect 2048
      DATA(li_vbpa_sp) = li_vbpa[].
      DELETE li_vbpa_sp WHERE lifnr = space.
      IF li_vbpa_sp IS NOT INITIAL.
* End of change Defect 2048
        SELECT lifnr,
               land1,
               name1,
               name2,
               ort01,
               pstlz,
               regio,
               stras,
               telf1,
               adrnr,      " Insert by PBANDLAPAL on 29-JUN-2017 for CR#571
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
               anred, " Title
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
               ort02,
               stcd1 " Tax Number 1
          FROM lfa1  " General Data in Customer Master
          INTO TABLE @DATA(li_lfa1)
          FOR ALL ENTRIES IN @li_vbpa_sp
          WHERE lifnr EQ @li_vbpa_sp-lifnr.

        IF sy-subrc EQ 0.
          SORT li_lfa1 BY lifnr.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.

      REFRESH: i_adrnr,    " Insert by PBANDLAPAL on 29-JUN-2017 for CR#571
               li_country.
* To append the country from KNA1
      LOOP AT li_kna1 INTO DATA(lst_kna1).
        lst_country-land1 = lst_kna1-land1.
        APPEND lst_country TO li_country.
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
        lst_region-land1 = lst_kna1-land1.
        lst_region-bland = lst_kna1-regio.
        APPEND lst_region TO li_region.
        CLEAR lst_region.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        lst_adrnr-kunnr = lst_kna1-kunnr.
        lst_adrnr-adrnr = lst_kna1-adrnr.
        APPEND lst_adrnr TO i_adrnr.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        CLEAR: lst_adrnr,       " Insert by PBANDLAPAL on 29-JUN-2017 for CR#571
               lst_country.
      ENDLOOP. " LOOP AT li_kna1 INTO DATA(lst_kna1)

* To append the country from LFA1
      LOOP AT li_lfa1 INTO DATA(lst_lfa1).
        lst_country-land1 = lst_lfa1-land1.
        APPEND lst_country TO li_country.
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
        lst_region-land1 = lst_lfa1-land1.
        lst_region-bland = lst_lfa1-regio.
        APPEND lst_region TO li_region.
        CLEAR lst_region.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        lst_adrnr-lifnr = lst_lfa1-lifnr.
        lst_adrnr-adrnr = lst_lfa1-adrnr.
        APPEND lst_adrnr TO i_adrnr.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
        CLEAR: lst_adrnr,     " Insert by PBANDLAPAL on 29-JUN-2017 for CR#571
               lst_country.
      ENDLOOP. " LOOP AT li_lfa1 INTO DATA(lst_lfa1)

      SORT li_country BY land1.
      DELETE ADJACENT DUPLICATES FROM li_country COMPARING land1.
* Get Country Name
      IF li_country IS NOT INITIAL.
* Begin of change CR471
*        SELECT land1,
*               landx               " Country Name
*          FROM t005t               " Country Names
*          INTO TABLE @DATA(li_t005t)
*          FOR ALL ENTRIES IN @li_country
*          WHERE spras EQ @sy-langu "'E'
*            AND land1 EQ @li_country-land1.
        SELECT a~land1,
               a~intca3,
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*               b~landx,              " Country Name
               b~landx50             " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
        FROM t005 AS a        " Country data
          INNER JOIN t005t AS b               " Country Names
          ON a~land1 = b~land1
        INTO TABLE @DATA(li_t005t)
        FOR ALL ENTRIES IN @li_country
        WHERE b~spras EQ @sy-langu "'E'
          AND a~land1 EQ @li_country-land1.
* End of change CR471
        IF sy-subrc EQ 0.
          SORT li_t005t BY land1.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_country IS NOT INITIAL
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
      SORT li_region BY land1 bland.
      DELETE ADJACENT DUPLICATES FROM li_region COMPARING land1 bland.
      IF li_region IS NOT INITIAL.
        SELECT land1  " Country Key
               bland  " Region (State, Province, County)
               bezei  " Description
          FROM t005u  " Taxes: Region Key: Texts
          INTO TABLE li_t005u
          FOR ALL ENTRIES IN li_region
          WHERE spras EQ sy-langu
          AND   land1 EQ li_region-land1
          AND   bland EQ li_region-bland.
        SORT li_t005u BY land1 bland.
      ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
      IF i_adrnr[] IS NOT INITIAL.
        SORT i_adrnr BY kunnr lifnr adrnr.
        DELETE ADJACENT DUPLICATES FROM i_adrnr COMPARING kunnr lifnr adrnr.
        SELECT addrnumber,
               name_co,
               street,   " ++by GKINTALI:15/03/2018:ED2K910947:ERP-6967
               str_suppl1,              "ED1K907377 - RITM0025850 +
               str_suppl2,              "GVS05212018 - ED1K907411
               str_suppl3,
               location,
               tel_number   " ++by NPALLA:12/23/2019:ED1K911472:INC0273232
        FROM adrc
        INTO TABLE @DATA(li_adrc)
        FOR ALL ENTRIES IN @i_adrnr
        WHERE addrnumber EQ @i_adrnr-adrnr.
      ENDIF.
* End of Insert by PBANDLPAL on 29-Jun-2017 for CR#571
* BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
      " Get Business Partner Category Type
      IF NOT li_kna1[] IS INITIAL.
        SELECT partner,
               type,
               bu_group
          FROM but000
          INTO TABLE @DATA(li_but000)
          FOR ALL ENTRIES IN @li_kna1
          WHERE partner EQ @li_kna1-kunnr.
      ENDIF.        " IF NOT li_kna1[] IS INITIAL.
* EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
    ENDIF. " IF li_vbpa[] IS NOT INITIAL
  ENDIF. " IF li_delv_final[] IS NOT INITIAL

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*If Main Label or Back label is checked
  IF rb1 IS NOT INITIAL.
    DATA(lv_label) = c_type_ml. "ML
  ELSE.
    lv_label = c_type_bl. "BL
  ENDIF.

  LOOP AT li_delv_final ASSIGNING FIELD-SYMBOL(<lst_delivery>).
    CLEAR lv_vbeln_ref.
    READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lst_mara>)
                                 WITH KEY matnr = <lst_delivery>-matnr
                                 BINARY SEARCH.
    IF sy-subrc EQ 0.
      APPEND INITIAL LINE TO fp_li_back_label ASSIGNING FIELD-SYMBOL(<lst_back_label>).

      <lst_back_label>-matnr = <lst_mara>-matnr. "Unique issueidentifier
      <lst_back_label>-ismcopynr = <lst_mara>-ismcopynr. "Volume
* Begin of Change CR471
*      <lst_back_label>-ismnrinyear = <lst_mara>-ismnrinyear. "Issue
*      <lst_back_label>-ismrefmdprod = <lst_mara>-ismrefmdprod. "Acronym
      CLEAR: lv_matnr,
             lv_mdprod,
             lv_issue,
             lv_len.

      lv_matnr = <lst_mara>-matnr.
      lv_issue = lv_matnr+8(7).
      lv_len  = strlen( lv_issue ).
      lv_mdprod = <lst_mara>-ismrefmdprod.
      <lst_back_label>-ismrefmdprod = lv_mdprod+0(4). "Acronym  "CR#371
      <lst_back_label>-mdprod = lv_mdprod+0(5). "Media Product  "CR#371 & 435
* End of Change CR471
* Begin of Change Defect 2003
      READ TABLE li_jptidcdassign ASSIGNING FIELD-SYMBOL(<fs_jptidcassign>) WITH KEY matnr = <lst_mara>-matnr.
      IF sy-subrc EQ 0 AND <fs_jptidcassign> IS ASSIGNED.
        <lst_back_label>-identcode = <fs_jptidcassign>-identcode.  "Acronym.
      ENDIF.
* End of Change Defect 2003
      <lst_back_label>-ismtitle = <lst_mara>-ismtitle. "Journal Title
      <lst_back_label>-ismyearnr = <lst_mara>-ismyearnr. "Pub Set

* Begin of Change CR471
*      IF <lst_mara>-ismissuetypest IS NOT INITIAL.
**        <lst_back_label>-supplement = <lst_mara>-ismissuetypest. "Supplement
*        <lst_back_label>-supplement = lv_matnr+8(lv_len).
*      ELSE.
*        <lst_back_label>-ismnrinyear = lv_matnr+8(lv_len).
*      ENDIF. " IF <lst_mara>-ismissuetypest IS NOT INITIAL
*           Populate Product type, Issue and Supplement
      IF lv_matnr+8(1) = c_char_s..
        <lst_back_label>-zprodtype = c_supp_value. "'SUPPLEMENT'.   "Product Type
        <lst_back_label>-supplement = lv_matnr+8(lv_len).   " Supplement
      ELSE. " ELSE -> IF <lst_back_label>-supplement IS NOT INITIAL
        <lst_back_label>-zprodtype = c_iss_value. "'ISS'.   "Product Type
        <lst_back_label>-ismnrinyear = lv_matnr+8(lv_len).  " Issue
      ENDIF. " IF <lst_back_label>-supplement IS NOT INITIAL
* End of Change CR471

*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*Issue Description Field should be replaced with first 15 Character of Media issue
*      CONCATENATE <lst_back_label>-ismrefmdprod <lst_back_label>-ismcopynr
** Begin of Change CR471
**         <lst_back_label>-ismnrinyear  <lst_back_label>-part
*      <lst_back_label>-ismnrinyear
** End of Change CR471
*         <lst_back_label>-supplement INTO <lst_back_label>-issue_desc. "Issue Description
      <lst_back_label>-issue_desc = lv_matnr+0(15). "Issue Description
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

* Begin of Change CR471
* To Populate the part
      IF <lst_delivery>-vbeln IS ASSIGNED.
        <lst_back_label>-part = <lst_delivery>-vbeln.
      ENDIF.
* End of Change CR471

*  Populate Offline Society name (TBD)
      <lst_back_label>-society_name = space. "Offline Society Name
      <lst_back_label>-docdate = sy-datum.
      <lst_back_label>-vstel = <lst_delivery>-vstel. "Shipping point
      <lst_back_label>-lfimg = <lst_delivery>-lfimg. "Quantity
      READ TABLE li_vbfa INTO DATA(lst_vbfa_1)
                                       WITH KEY vbeln   = <lst_delivery>-vbeln
                                                posnn   = <lst_delivery>-posnr
                                                vbtyp_v = c_vbtyp_c.
      IF sy-subrc = 0.
*        <lst_back_label>-vbeln = lst_vbfa_1-vbelv. " - <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        <lst_back_label>-subscrno  = lst_vbfa_1-vbelv.    "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        <lst_back_label>-vgbel = <lst_delivery>-vgbel. " Sales Order
      ELSE.
        READ TABLE li_vbfa INTO lst_vbfa_1 WITH KEY vbeln   = <lst_delivery>-vbeln
                                                    posnn   = <lst_delivery>-posnr
                                                    vbtyp_v = c_vbtyp_i
                                                    stufe   = 00. "c_char_blank BINARY SEARCH.
        IF sy-subrc = 0.
*          <lst_back_label>-vbeln = lst_vbfa_1-vbelv. " - <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          <lst_back_label>-subscrno  = lst_vbfa_1-vbelv.    "Subscription Number
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          <lst_back_label>-vgbel = <lst_delivery>-vgbel. " Sales Order
        ENDIF.
      ENDIF. " IF sy-subrc = 0
*BOC <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*Get order data / free issues/claims
      IF NOT lst_vbfa_1 IS INITIAL.
*       Populate PO Ref
        READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) WITH KEY vbeln = lst_vbfa_1-vbelv BINARY SEARCH.
        IF sy-subrc = 0.
          <lst_back_label>-bstkd = <lst_vbkd>-bstkd. "Purchase Order Ref.
*  <<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
          READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_hdr>) WITH KEY vbeln = lst_vbfa_1-vbelv
                                                                             posnr = lst_vbfa_1-posnv.
          IF sy-subrc EQ 0.
            <lst_back_label>-konda = <lst_vbkd_hdr>-konda.
*   BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
            <lst_back_label>-kdkg2 = <lst_vbkd_hdr>-kdkg2.  " Customer condition group 2
            <lst_back_label>-pltyp = <lst_vbkd_hdr>-pltyp.  " Price List Type
*   EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*  BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
            <lst_back_label>-vbeln  =  <lst_vbkd_hdr>-ihrez.    "Subscription Ref.
*  EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
          ELSE.
            READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_hdr1>) WITH KEY vbeln = lst_vbfa_1-vbelv
                                                                                posnr = c_blank_zeros.
            IF sy-subrc EQ 0.
              <lst_back_label>-konda = <lst_vbkd_hdr1>-konda.
*   BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
              <lst_back_label>-kdkg2 = <lst_vbkd_hdr1>-kdkg2.  " Customer condition group 2
              <lst_back_label>-pltyp = <lst_vbkd_hdr1>-pltyp.  " Price List Type
*   EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*  BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
              <lst_back_label>-vbeln  = <lst_vbkd_hdr1>-ihrez.    "Subscription Ref.
*  EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
            ENDIF.
          ENDIF.
          IF <lst_back_label>-konda IS INITIAL.
            <lst_back_label>-konda = c_star.
          ENDIF.

*  <<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
        ENDIF. " IF sy-subrc = 0
      ENDIF.
*EOC <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>

      CLEAR : lv_name, lv_object.
*      lv_name = <lst_delivery>-vbeln.
      lv_name = <lst_delivery>-vgbel.
      lv_object = c_object.
*   Populate Shipping Ref
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = c_tdid_ship
          language                = sy-langu
          name                    = lv_name
          object                  = lv_object
          archive_handle          = 0
          local_cat               = space
        TABLES
          lines                   = li_lines[]
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
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*        READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX 1.
*        IF sy-subrc = 0.
*          v_ship_instruction = <lst_lines>-tdline.
**          <lst_back_label>-shipping_ref = <lst_lines>-tdline. "Shipping Ref
        LOOP AT li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>).
          CONCATENATE v_ship_instruction <lst_lines>-tdline INTO v_ship_instruction.
        ENDLOOP.
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
        IF v_ship_instruction IS NOT INITIAL.
          READ TABLE i_constant INTO lst_constant WITH KEY param1 = c_ship_inst
                                                           param2 = c_type_bl.
          IF sy-subrc EQ 0.
            CONCATENATE lst_constant-low v_ship_instruction INTO v_ship_instruction.
          ENDIF.
        ENDIF.
*        ENDIF. " IF sy-subrc = 0 "- <HIPATEL> <RITM0092591> <ED1K909240>
      ENDIF. " IF sy-subrc EQ 0

*<<<<<<<<<<<<<<<<<BOC by MODUTTA on 05/02/2017 for CR#371 & 435>>>>>>>>>>>>
* Populate delivery instruction
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = c_tdid_del
          language                = sy-langu
          name                    = lv_name
          object                  = lv_object
          archive_handle          = 0
          local_cat               = space
        TABLES
          lines                   = li_lines_del[]
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc = 0.
*BOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
*        READ TABLE li_lines_del ASSIGNING FIELD-SYMBOL(<lst_lines_del>) INDEX 1.
*        IF sy-subrc = 0.
*          v_delv_instruction = <lst_lines_del>-tdline. "Delivery instruction
*        ENDIF. " IF sy-subrc = 0
        LOOP AT li_lines_del ASSIGNING FIELD-SYMBOL(<lst_lines_del>).
          CONCATENATE v_delv_instruction <lst_lines_del>-tdline INTO v_delv_instruction. "Delivery instruction
        ENDLOOP.
*EOC by <HIPATEL> <RITM0092591> <ED1K909240> <12/04/2018>
      ENDIF. " IF sy-subrc = 0
      IF v_ship_instruction IS NOT INITIAL AND v_delv_instruction IS NOT INITIAL.
        CONCATENATE v_ship_instruction v_delv_instruction INTO
                                     <lst_back_label>-shipping_ref SEPARATED BY space. "Shipping Ref
      ELSEIF v_ship_instruction IS NOT INITIAL.
        <lst_back_label>-shipping_ref = v_ship_instruction. "Shipping Ref
      ELSEIF v_delv_instruction IS NOT INITIAL.
        <lst_back_label>-shipping_ref = v_delv_instruction. "Shipping Ref
      ENDIF.
*<<<<<<<<<<<<<<<<<EOC by MODUTTA on 05/02/2017 for CR#371 & 435>>>>>>>>>>>>

      <lst_back_label>-type = c_type_bl. "'BL'.  "Type
      READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak>) WITH KEY vbeln = <lst_delivery>-vgbel BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_back_label>-auart = <lst_vbak>-auart.
        <lst_back_label>-augru = <lst_vbak>-augru.
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
        <lst_back_label>-vkorg = <lst_vbak>-vkorg.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 18.04.2018
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
* Shipping Reference should not be preceeded with EM- or EB- in case of ZSRO order type
        IF <lst_back_label>-auart = c_zsro.
          IF  v_ship_instruction1 IS NOT INITIAL
          AND v_delv_instruction IS NOT INITIAL.
            CONCATENATE v_ship_instruction1 v_delv_instruction INTO
                        <lst_back_label>-shipping_ref SEPARATED BY space. "Shipping Ref
          ELSEIF v_ship_instruction1 IS NOT INITIAL.
            <lst_back_label>-shipping_ref = v_ship_instruction1.
          ELSEIF v_delv_instruction IS NOT INITIAL.
            <lst_back_label>-shipping_ref = v_delv_instruction.
          ENDIF.
        ENDIF.  " <lst_back_label>-auart = c_zsro
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
        lv_vbeln_ref = <lst_vbak>-vbeln.
** Populate Priority
        IF <lst_vbak>-vsbed = c_shpcon_01.
          <lst_back_label>-priority = 90. "Priority
        ELSEIF <lst_vbak>-vsbed = c_shpcon_02. " ELSE -> IF <lst_po>-inco1 = c_inco1_ddp
          <lst_back_label>-priority = 95. "Priority
        ELSEIF <lst_vbak>-vsbed = c_shpcon_03.
          <lst_back_label>-priority = 80. "Priority
        ELSEIF <lst_vbak>-vsbed = c_char_blank.
          <lst_back_label>-priority = 90. "Priority
        ENDIF. " IF <lst_vbak_s>-vsbed = c_shpcon_01
        READ TABLE li_vbfa_d ASSIGNING FIELD-SYMBOL(<lst_vbfa>) WITH KEY vbeln = <lst_delivery>-vgbel
                                                                       posnn = <lst_delivery>-vgpos.
        IF sy-subrc EQ 0.
          READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak_i>) WITH KEY vbeln = <lst_vbfa>-vbelv.
          IF sy-subrc EQ 0.
            IF <lst_back_label>-auart IS ASSIGNED AND
               <lst_back_label>-auart NE c_claim_ref. "'ZCLM'.
              <lst_back_label>-auart = <lst_vbak_i>-auart.
            ENDIF.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
            <lst_back_label>-vkorg = <lst_vbak_i>-vkorg.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
          ENDIF.
        ENDIF.
        CASE <lst_back_label>-auart.
          WHEN c_free_issue. "'ZCOP'.
            IF <lst_vbak> IS ASSIGNED.
              <lst_back_label>-auart1 = <lst_vbak>-vbeln. "Free Issue Ref
            ENDIF.
            <lst_back_label>-auart2 = space. "Claim Ref
            <lst_back_label>-auart3 = space. "Sample Copy Ref
*BOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*            CLEAR <lst_back_label>-vbeln.
*EOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
          WHEN 'ZFOC'. "'ZFOC'.
            IF <lst_vbak> IS ASSIGNED.
              <lst_back_label>-auart1 = <lst_vbak>-vbeln. "Free Issue Ref
            ENDIF.
            <lst_back_label>-auart2 = space. "Claim Ref
            <lst_back_label>-auart3 = space. "Sample Copy Ref
*BOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*            CLEAR <lst_back_label>-vbeln.
*EOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
          WHEN c_claim_ref. "'ZCLM'.
            <lst_back_label>-auart1 = space. "Free Issue Ref
            IF <lst_vbak> IS ASSIGNED.
              <lst_back_label>-auart2 = <lst_vbak>-vbeln. "Claim Ref
            ENDIF.
            <lst_back_label>-auart3 = space. "Sample Copy Ref
*BOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*            CLEAR <lst_back_label>-vbeln.
*EOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
          WHEN 'ZCSS'. "'ZCSS'.
            <lst_back_label>-auart1 = space. "Free Issue Ref
            <lst_back_label>-auart2 = space. "Claim Ref
            IF <lst_vbak> IS ASSIGNED.
              <lst_back_label>-auart3 = <lst_vbak>-vbeln. "Sample Copy Ref
            ENDIF.
*BOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*            CLEAR <lst_back_label>-vbeln.
*EOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
          WHEN OTHERS.
        ENDCASE.
      ENDIF.
      IF <lst_back_label>-auart IS INITIAL.
        <lst_back_label>-auart = c_star.
      ENDIF.
      IF <lst_back_label>-augru IS INITIAL.
        <lst_back_label>-augru = c_star.
      ENDIF.
* End of Changes by PBANDLAPAL on 05/28/2017 for CR#371 & 435
*BOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>
*Deleted this logic and added with LI_VBFA logic to fetch Order data for the free issues/claims as well.
**     Populate PO Ref
*      READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) WITH KEY vbeln = lv_vbeln_ref BINARY SEARCH.
*      IF sy-subrc = 0.
*        <lst_back_label>-bstkd = <lst_vbkd>-bstkd. "Purchase Order Ref.
**<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*        READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_hdr>) WITH KEY vbeln = <lst_delivery>-vgbel
*                                                                           posnr = <lst_delivery>-vgpos.
*        IF sy-subrc EQ 0.
*          <lst_back_label>-konda = <lst_vbkd_hdr>-konda.
** BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*          <lst_back_label>-kdkg2 = <lst_vbkd_hdr>-kdkg2.  " Customer condition group 2
*          <lst_back_label>-pltyp = <lst_vbkd_hdr>-pltyp.  " Price List Type
** EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
**BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*          <lst_back_label>-vbeln  =  <lst_vbkd_hdr>-ihrez.    "Subscription Ref.
**EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*        ELSE.
*          READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd_hdr1>) WITH KEY vbeln = <lst_delivery>-vgbel
*                                                                              posnr = c_blank_zeros.
*          IF sy-subrc EQ 0.
*            <lst_back_label>-konda = <lst_vbkd_hdr1>-konda.
** BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*            <lst_back_label>-kdkg2 = <lst_vbkd_hdr1>-kdkg2.  " Customer condition group 2
*            <lst_back_label>-pltyp = <lst_vbkd_hdr1>-pltyp.  " Price List Type
** EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
**BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*            <lst_back_label>-vbeln  = <lst_vbkd_hdr1>-ihrez.    "Subscription Ref.
**EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*          ENDIF.
*        ENDIF.
*        IF <lst_back_label>-konda IS INITIAL.
*          <lst_back_label>-konda = c_star.
*        ENDIF.
*
**<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*      ENDIF. " IF sy-subrc = 0
*EOD <HIPATEL> <RITM0065346> <ED1K908689> <10/11/2018>

*     Populate End use customer & Ship to customer
      READ TABLE li_vbpa INTO DATA(lst_vbpa_cb) WITH KEY vbeln = <lst_delivery>-vgbel
                                                         posnr = <lst_delivery>-vgpos
                                                         parvw = c_parvw_we. "'WE'.
      IF sy-subrc = 0.
        <lst_back_label>-cust = lst_vbpa_cb-kunnr. "End use customer
        <lst_back_label>-ship_to_cust = lst_vbpa_cb-kunnr. " Ship to Customer
* Begin of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
      ELSE.
        CLEAR lst_vbpa_cb.
        READ TABLE li_vbpa INTO lst_vbpa_cb WITH KEY vbeln = <lst_delivery>-vgbel
                                                   posnr = c_blank_zeros
                                                   parvw = c_parvw_we. "'WE'.
        IF sy-subrc EQ 0.
          <lst_back_label>-cust = lst_vbpa_cb-kunnr. "End use customer
          <lst_back_label>-ship_to_cust = lst_vbpa_cb-kunnr. " Ship to customer
        ENDIF.
* End of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
      ENDIF. " IF sy-subrc = 0

      READ TABLE li_vbpa INTO DATA(lst_vbpa_sb) WITH KEY vbeln = <lst_delivery>-vgbel
                                                         posnr = <lst_delivery>-vgpos
                                                         parvw = c_parvw_sp. "'SP' "Freight Forwarder.
      IF sy-subrc = 0.
        <lst_back_label>-ship_to_cust = lst_vbpa_sb-lifnr. " Ship to Customer
* Begin of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
      ELSE.
        READ TABLE li_vbpa INTO lst_vbpa_sb WITH KEY vbeln = <lst_delivery>-vgbel
                                                     posnr = c_blank_zeros
                                                     parvw = c_parvw_sp. "'SP' "Freight Forwarder.
        IF sy-subrc = 0.
          <lst_back_label>-ship_to_cust = lst_vbpa_sb-lifnr. " Ship to Customer
        ENDIF.
* End of Change by PBANDLAPAL on 05/24/2017 for CR#371 & 435
      ENDIF. " IF sy-subrc = 0

*       Populate Consolidation Type
      IF <lst_back_label>-cust EQ <lst_back_label>-ship_to_cust.
        <lst_back_label>-zcontyp = c_contyp_d. "'D'.    "Consolidation Type
      ELSE. " ELSE -> IF <lst_back_label>-cust EQ <lst_back_label>-ship_to_cust
        <lst_back_label>-zcontyp = c_contyp_f. "'F'.    "Consolidation Type
      ENDIF. " IF <lst_back_label>-cust EQ <lst_back_label>-ship_to_cust

*       Populate Distributor
      READ TABLE li_lfa1 ASSIGNING FIELD-SYMBOL(<lst_lfa1>)
                                       WITH KEY lifnr = lst_vbpa_sb-lifnr
                                       BINARY SEARCH.
      IF sy-subrc = 0.
*        <lst_back_label>-land1 = <lst_lfa1>-land1. "Country Code      " Comment for CR 471
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
*        <lst_back_label>-name1 = <lst_lfa1>-name1. "Address Line 1
        IF <lst_lfa1>-anred IS NOT INITIAL.
          <lst_back_label>-name1 = <lst_lfa1>-anred && ` ` && <lst_lfa1>-name1. "Address Line 1
        ELSE.
          <lst_back_label>-name1 = <lst_lfa1>-name1. "Address Line 1
        ENDIF.
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
        <lst_back_label>-name2 = <lst_lfa1>-name2. "Address Line 2
        <lst_back_label>-ort01 = <lst_lfa1>-ort01. "Address Line 5
        <lst_back_label>-pstlz = <lst_lfa1>-pstlz. "Post Code
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
        <lst_back_label>-ort02 = <lst_lfa1>-ort02. "Address Line4 - District
*        <lst_back_label>-regio = <lst_lfa1>-regio. "State
        IF s_land1[] IS NOT INITIAL AND <lst_lfa1>-land1 IN s_land1[].
          <lst_back_label>-regio = <lst_lfa1>-regio. " State Code
        ELSE.
          READ TABLE li_t005u INTO lst_t005u WITH KEY land1 = <lst_lfa1>-land1
                                                      bland = <lst_lfa1>-regio BINARY SEARCH.
          IF sy-subrc = 0.
            <lst_back_label>-regio = lst_t005u-bezei.  " State Description
          ELSE.
            <lst_back_label>-regio = <lst_lfa1>-regio. " State Code
          ENDIF.
        ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*        <lst_back_label>-stras = <lst_lfa1>-stras. "Address Line 3
        READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = <lst_lfa1>-adrnr.
        IF sy-subrc EQ 0.
* BOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
************************* Address Lines 1 and 2 *************************************
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
* Considering Street2 (ADRC-STR_SUPPL1) in the Address
          CLEAR : lv_actv_flag_b.
          CALL FUNCTION 'ZCA_ENH_CONTROL'
            EXPORTING
              im_wricef_id   = lc_wricef_id
              im_ser_num     = lc_ser_num
              im_var_key     = lc_jfds
            IMPORTING
              ex_active_flag = lv_actv_flag_b.
          IF lv_actv_flag_b IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
            CLEAR: lst_tmp_name.
            IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
              CONCATENATE lst_tmp_name <lst_back_label>-name1 " Salutation + Name 1
                                       ` `
                                       <lst_back_label>-name2 " Name 2
                                  INTO lst_tmp_name.
              IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                            c_semicol           " Semi-colon
                            ` `                 " Space
                            lst_adrc-str_suppl1 " Street 2 - Department
                       INTO lst_tmp_name.
* Split at 50 chars and move to <lst_back_label>-name1 and <lst_back_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                CLEAR: li_outlines, lst_line.
                CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                  EXPORTING
                    textline            = lst_tmp_name
                    delimiter           = ' '
                    outputlen           = c_splt_len    " 50
                  TABLES
                    out_lines           = li_outlines[]
                  EXCEPTIONS
                    outputlen_too_large = 1
                    OTHERS              = 2.
                IF sy-subrc <> 0.
*   Nothing to implement here
                ENDIF.
                IF li_outlines[] IS NOT INITIAL.
                  LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                    CASE sy-tabix.
                      WHEN 1.
                        <lst_back_label>-name1 = lst_line-line. " Address Line 1
                      WHEN 2.
                        <lst_back_label>-name2 = lst_line-line. " Address Line 2
                    ENDCASE.
                  ENDLOOP.
                ENDIF.  " IF li_outlines[] IS NOT INITIAL.
              ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                <lst_back_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                <lst_back_label>-name2 = lst_adrc-str_suppl1. " Street2 - Department
              ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
            ELSE.
* No change as Salutation + Name1 is already moved to <lst_back_label>-name1
* and Name2 to <lst_back_label>-name2
            ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
          ELSE. " ++by BSAKI
            IF ( <lst_back_label>-type = c_type_bl "'BL'
              OR <lst_back_label>-type = c_type_ml )
              AND v_ship_instruction IS NOT INITIAL. "'ML'.
              CLEAR: lst_tmp_name.
              CONCATENATE lst_tmp_name lst_adrc-name_co          " C/O
                                          ` `                    " Space
                                       <lst_back_label>-name1    " Salutation + Name1
                                     INTO lst_tmp_name.
              <lst_back_label>-name1 = lst_tmp_name.        " C/O Name + Salutation + Name1
              CLEAR: lst_tmp_name.
              CONCATENATE lst_tmp_name <lst_back_label>-name2    " Name2
                                          ` `                    " Space
                                       lst_adrc-str_suppl1       " Street2
                                     INTO lst_tmp_name.
              <lst_back_label>-name2 = lst_tmp_name.             " Name2 + Street2
            ELSE. "IF <lst_back_label>-type = 'BL'.
              CLEAR: lst_tmp_name.
              IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                CONCATENATE lst_tmp_name <lst_back_label>-name1 " Salutation + Name 1
                                         ` `
                                         <lst_back_label>-name2 " Name 2
                                    INTO lst_tmp_name.
                IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                              c_semicol           " Semi-colon
                              ` `                 " Space
                              lst_adrc-str_suppl1 " Street 2 - Department
                         INTO lst_tmp_name.
* Split at 50 chars and move to <lst_back_label>-name1 and <lst_back_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                  CLEAR: li_outlines, lst_line.
                  CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                    EXPORTING
                      textline            = lst_tmp_name
                      delimiter           = ' '
                      outputlen           = c_splt_len    " 50
                    TABLES
                      out_lines           = li_outlines[]
                    EXCEPTIONS
                      outputlen_too_large = 1
                      OTHERS              = 2.
                  IF sy-subrc <> 0.
*   Nothing to implement here
                  ENDIF.
                  IF li_outlines[] IS NOT INITIAL.
                    LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                      CASE sy-tabix.
                        WHEN 1.
                          <lst_back_label>-name1 = lst_line-line. " Address Line 1
                        WHEN 2.
                          <lst_back_label>-name2 = lst_line-line. " Address Line 2
                      ENDCASE.
                    ENDLOOP.
                  ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  <lst_back_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                  <lst_back_label>-name2 = lst_adrc-str_suppl1. " Street2 - Department
                ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
              ELSE.
* No change as Salutation + Name1 is already moved to <lst_back_label>-name1
* and Name2 to <lst_back_label>-name2
              ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
            ENDIF. "IF <lst_back_label>-type = 'BL'.
          ENDIF.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
*********************   Address Lines 3 and 4 *******************************
          IF lst_adrc-location IS NOT INITIAL.  " Street5
            <lst_back_label>-stras = lst_adrc-location.   " Address Line3 = Street5
            CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
            IF lst_adrc-street IS NOT INITIAL.
              CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street
            ENDIF.
            IF lst_adrc-str_suppl3 IS NOT INITIAL.
              IF lst_tmp IS NOT INITIAL.
                CONCATENATE lst_tmp                 " Street
                            c_semicol               " Semi-Colon
                            ` `                     " Space
                            lst_adrc-str_suppl3     " Street 4
                       INTO lst_tmp.                " Street + Street4
              ELSE.
                CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
              ENDIF.  " IF lst_tmp IS NOT INITIAL.
            ENDIF.  " IF lst_adrc-str_suppl3 IS NOT INITIAL.
            <lst_back_label>-ort02 = lst_tmp.        " Address Line4 = Street + Street4
          ELSE.  " Stree5 is blank here
* If street is exceeding 50 characters
            IF strlen( lst_adrc-street ) > c_splt_len.  " 50
              CLEAR: lst_tmp_name, li_outlines, lst_line.
              CONCATENATE lst_adrc-street            " Street (60char field)
                          c_semicol                  " Semi-Colon
                          ` `                        " Space
                          lst_adrc-str_suppl3        " Street4 (40char field)
                     INTO lst_tmp_name.
* Calling the FM to split the concatenated string into strings of 50 char each
              CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                EXPORTING
                  textline            = lst_tmp_name
                  delimiter           = ' '
                  outputlen           = c_splt_len    " 50
                TABLES
                  out_lines           = li_outlines[]
                EXCEPTIONS
                  outputlen_too_large = 1
                  OTHERS              = 2.
              IF sy-subrc <> 0.
*   Nothing to implement here
              ENDIF.
              IF li_outlines[] IS NOT INITIAL.
                LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 3 and 4 respectively
                  CASE sy-tabix.
                    WHEN 1.
                      <lst_back_label>-stras = lst_line-line. " Address Line 3
                    WHEN 2.
                      <lst_back_label>-ort02 = lst_line-line. " Address Line 4
                  ENDCASE.
                ENDLOOP.  " LOOP AT li_outlines INTO lst_line.
              ENDIF.  " IF li_outlines[] IS NOT INITIAL.
            ELSE.  " Street is < 50 characters here
              <lst_back_label>-stras = lst_adrc-street.     " Street  - Addr Line3
              <lst_back_label>-ort02 = lst_adrc-str_suppl3. " Street4 - Addr Line4
            ENDIF.   " IF strlen( lst_adrc-street ) > c_splt_len.  " 50
          ENDIF.   " IF lst_adrc-location IS NOT INITIAL.  " Street5
* EOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
***** BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
          " This logic is exclusively added to format Address line 3 & 4 values for
          " Individual business partners only
          READ TABLE li_but000 INTO DATA(lst_but000)
                               WITH KEY partner = <lst_back_label>-ship_to_cust.
          IF sy-subrc = 0 AND lst_but000-type = c_bu_per.
            CLEAR : <lst_back_label>-stras, <lst_back_label>-ort02.
            IF NOT lst_adrc-str_suppl2 IS INITIAL.                 " Street3
              <lst_back_label>-stras = lst_adrc-str_suppl2.        " Address Line3 = Street3
              CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
              IF lst_adrc-location IS NOT INITIAL.                 " Street5
                CONCATENATE lst_tmp lst_adrc-location INTO lst_tmp." Street5
              ENDIF.
              IF lst_adrc-street IS NOT INITIAL.
                CONCATENATE lst_tmp                              " Street
*                               c_semicol                            " Semi-Colon
                            ` `                                  " Space
                            lst_adrc-street                      " Street
                       INTO lst_tmp.                             " Street5 + Street
              ELSE.
                CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street5 + Street
              ENDIF.
              IF lst_adrc-str_suppl3 IS NOT INITIAL.               " Street4
                IF lst_tmp IS NOT INITIAL.
                  CONCATENATE lst_tmp                              " Street
*                                c_semicol                            " Semi-Colon
                              ` `                                  " Space
                              lst_adrc-str_suppl3                  " Street 4
                         INTO lst_tmp.                             " Street5 + Street + Street4
                ELSE.
                  CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                  " Street5 + Street + Street4
                ENDIF.
              ENDIF.
              <lst_back_label>-ort02 = lst_tmp.                    " Address Line4 = Street + Street4
            ELSE.                                                  " Street3 is blank
              IF NOT lst_adrc-location IS INITIAL.                 " Street 5
                <lst_back_label>-stras = lst_adrc-location.        " Address Line 3
                CLEAR: lst_tmp_name, li_outlines, lst_line.
                CONCATENATE lst_adrc-street                         " Street
*                              c_semicol                               " Semi-Colon
                            ` `                                     " Space
                            lst_adrc-str_suppl3                     " Street 4
                       INTO lst_tmp_name.
                <lst_back_label>-ort02 = lst_tmp_name.              " Address Line 4
              ELSE.
                <lst_back_label>-stras = lst_adrc-street.           " Address Line 3 = Street
                <lst_back_label>-ort02 = lst_adrc-str_suppl3.       " Address Line 4 = Street 4
              ENDIF.           " IF NOT lst_adrc-location IS INITIAL.                 " Street 5
            ENDIF.             " IF NOT lst_adrc-str_suppl2 IS INITIAL.
          ENDIF.               " IF sy-subrc = 0 AND lst_but000-type = '1'.
***** EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
*          CONCATENATE <lst_lfa1>-stras lst_adrc-str_suppl3 lst_adrc-location
*                                 INTO <lst_back_label>-stras SEPARATED BY c_comma.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
          IF lst_adrc-tel_number IS NOT INITIAL.  " Full Telephone Number
            <lst_back_label>-tel_number = lst_adrc-tel_number.
          ENDIF.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
        ELSE.
* Considering Street from Vendor Master: LFA1-STRAS in case if ADRC does not exist
          <lst_back_label>-stras = <lst_lfa1>-stras. "Address Line 3
*          <lst_back_label>-stras = lst_adrc-street. "Address Line 3
        ENDIF.
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
        <lst_back_label>-telf1 = <lst_lfa1>-telf1. "Telephone number
* BOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
* Commented this line and added before. In case of AddressLine3 not exceeding 50char,
* this value will be continued. Otherwise, the splitted string will be overwriting this.
*        <lst_back_label>-ort02 = <lst_lfa1>-ort02. "Address Line 4
* EOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
        READ TABLE li_t005t ASSIGNING FIELD-SYMBOL(<lst_t005t_l>)
                                          WITH KEY land1 = <lst_lfa1>-land1
                                          BINARY SEARCH.
        IF sy-subrc = 0.
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*          <lst_back_label>-landx    = <lst_t005t_l>-landx. "Country Name
          <lst_back_label>-landx50    = <lst_t005t_l>-landx50. "Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
          <lst_back_label>-land1    = <lst_t005t_l>-intca3. "Country ISO Code    " Insert CR#471
          <lst_back_label>-country  = <lst_t005t_l>-land1.  " Two Character Country " Insert for CR 371 & 435.
        ENDIF. " IF sy-subrc = 0
      ELSE. " ELSE -> IF sy-subrc = 0
        READ TABLE li_kna1 ASSIGNING FIELD-SYMBOL(<lst_kna1>)
                                         WITH KEY kunnr = lst_vbpa_cb-kunnr
                                         BINARY SEARCH.
        IF sy-subrc = 0.
* This scenario is only valid for the Canada and hence the check is done.
*          IF <lst_kna1>-land1 = c_cntry_ca.
*            <lst_back_label>-stcd1 = <lst_kna1>-stcd1. "Canadian GST no.
*          ENDIF. " IF <lst_kna1>-land1 = c_cntry_ca

*          <lst_back_label>-land1 = <lst_kna1>-land1. "Country Code            " Comment CR#471
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the title of the Customer / Vendor along with Name1 in case if it exists
*        <lst_back_label>-name1 = <lst_kna1>-name1. "Address Line 1
          IF <lst_kna1>-anred IS NOT INITIAL.
            <lst_back_label>-name1 = <lst_kna1>-anred && ` ` && <lst_kna1>-name1. "Address Line 1
          ELSE.
            <lst_back_label>-name1 = <lst_kna1>-name1. "Address Line 1
          ENDIF.
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
          <lst_back_label>-name2 = <lst_kna1>-name2. "Address Line 2
          <lst_back_label>-ort01 = <lst_kna1>-ort01. "Address Line 5
          <lst_back_label>-pstlz = <lst_kna1>-pstlz. "Post Code
* BOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
          <lst_back_label>-ort02 = <lst_kna1>-ort02. "Address Line 4
*          <lst_back_label>-regio = <lst_kna1>-regio. "State
          IF s_land1[] IS NOT INITIAL AND <lst_kna1>-land1 IN s_land1[].
            <lst_back_label>-regio = <lst_kna1>-regio. " State Code
          ELSE.
            READ TABLE li_t005u INTO lst_t005u WITH KEY land1 = <lst_kna1>-land1
                                                        bland = <lst_kna1>-regio BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_back_label>-regio = lst_t005u-bezei.  " State Description
            ELSE.
              <lst_back_label>-regio = <lst_kna1>-regio. " State Code
            ENDIF.
          ENDIF.
* EOC - GKINTALI - 05/18/2018 - ED1K907377 - RITM0025850 & CR - ERP-7478
* Begin of Change by PBANDLPAL on 29-Jun-2017 for CR#571
*        <lst_back_label>-stras = <lst_kna1>-stras. "Address Line 3
          READ TABLE li_adrc INTO lst_adrc WITH KEY addrnumber = <lst_kna1>-adrnr.
          IF sy-subrc EQ 0.
* BOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
******************** Address Lines 1 and 2*******************************
* Considering Street2 (ADRC-STR_SUPPL1) in the Address
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
* Considering Street2 (ADRC-STR_SUPPL1) in the Address
            CLEAR : lv_actv_flag_b.
            CALL FUNCTION 'ZCA_ENH_CONTROL'
              EXPORTING
                im_wricef_id   = lc_wricef_id
                im_ser_num     = lc_ser_num
                im_var_key     = lc_jfds
              IMPORTING
                ex_active_flag = lv_actv_flag_b.
            IF lv_actv_flag_b IS INITIAL.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
              CLEAR: lst_tmp_name.
              IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                CONCATENATE lst_tmp_name <lst_back_label>-name1   " Salutation + Name1
                                         ` `
                                         <lst_back_label>-name2   " Name 2
                                    INTO lst_tmp_name.
                IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                              c_semicol           " Semi-colon
                              ` `                 " Space
                              lst_adrc-str_suppl1 " Street 2
                         INTO lst_tmp_name.

* Split at 50 chars and move to <lst_back_label>-name1 and <lst_back_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                  CLEAR: li_outlines, lst_line.
                  CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                    EXPORTING
                      textline            = lst_tmp_name
                      delimiter           = ' '
                      outputlen           = c_splt_len    " 50
                    TABLES
                      out_lines           = li_outlines[]
                    EXCEPTIONS
                      outputlen_too_large = 1
                      OTHERS              = 2.
                  IF sy-subrc <> 0.
*   Nothing to implement here
                  ENDIF.
                  IF li_outlines[] IS NOT INITIAL.
                    LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                      CASE sy-tabix.
                        WHEN 1.
                          <lst_back_label>-name1 = lst_line-line. " Address Line 1
                        WHEN 2.
                          <lst_back_label>-name2 = lst_line-line. " Address Line 2
                      ENDCASE.
                    ENDLOOP.
                  ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                  <lst_back_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                  <lst_back_label>-name2 = lst_adrc-str_suppl1. " Street2
                ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
              ELSE.
* No change as Salutation + Name1 is already moved to <lst_back_label>-name1
* and Name2 to <lst_back_label>-name2
              ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
* BOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
            ELSE. " ++by BSAKI
              IF ( <lst_back_label>-type = c_type_bl"'BL'
                OR <lst_back_label>-type = c_type_ml )
                 AND v_ship_instruction IS NOT INITIAL."'ML'.
                CLEAR: lst_tmp_name.
                CONCATENATE lst_tmp_name lst_adrc-name_co          " C/O
                                            ` `                    " Space
                                         <lst_back_label>-name1    " Salutation + Name1
                                       INTO lst_tmp_name.
                <lst_back_label>-name1 = lst_tmp_name.        " C/O Name + Salutation + Name1
                CLEAR: lst_tmp_name.
                CONCATENATE lst_tmp_name <lst_back_label>-name2    " Name2
                                            ` `                    " Space
                                         lst_adrc-str_suppl1       " Street2
                                       INTO lst_tmp_name.
                <lst_back_label>-name2 = lst_tmp_name.             " Name2 + Street2
              ELSE. "IF <lst_back_label>-type = 'BL'.
                CLEAR: lst_tmp_name.
                IF lst_adrc-str_suppl1 IS NOT INITIAL.      " Street2
                  CONCATENATE lst_tmp_name <lst_back_label>-name1   " Salutation + Name1
                                           ` `
                                           <lst_back_label>-name2   " Name 2
                                      INTO lst_tmp_name.
                  IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    CONCATENATE lst_tmp_name        " Salutation + Name1 + Name2
                                c_semicol           " Semi-colon
                                ` `                 " Space
                                lst_adrc-str_suppl1 " Street 2
                           INTO lst_tmp_name.

* Split at 50 chars and move to <lst_back_label>-name1 and <lst_back_label>-name2.
* Calling the FM to split the concatenated string into strings of 50 char each
                    CLEAR: li_outlines, lst_line.
                    CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                      EXPORTING
                        textline            = lst_tmp_name
                        delimiter           = ' '
                        outputlen           = c_splt_len    " 50
                      TABLES
                        out_lines           = li_outlines[]
                      EXCEPTIONS
                        outputlen_too_large = 1
                        OTHERS              = 2.
                    IF sy-subrc <> 0.
*   Nothing to implement here
                    ENDIF.
                    IF li_outlines[] IS NOT INITIAL.
                      LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 1 and 2 respectively
                        CASE sy-tabix.
                          WHEN 1.
                            <lst_back_label>-name1 = lst_line-line. " Address Line 1
                          WHEN 2.
                            <lst_back_label>-name2 = lst_line-line. " Address Line 2
                        ENDCASE.
                      ENDLOOP.
                    ENDIF.  " IF li_outlines[] IS NOT INITIAL.
                  ELSE.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                    <lst_back_label>-name1 = lst_tmp_name.        " Salutation + Name1 + Name2
                    <lst_back_label>-name2 = lst_adrc-str_suppl1. " Street2
                  ENDIF.   " IF strlen( lst_tmp_name ) > c_splt_len. " = 50
                ELSE.
* No change as Salutation + Name1 is already moved to <lst_back_label>-name1
* and Name2 to <lst_back_label>-name2
                ENDIF.  " IF lst_adrc-str_suppl1 is not initial.      " Street2
              ENDIF. "IF <lst_back_label>-type = 'BL'.
            ENDIF.
* EOC - BSAKI - 03/08/2022 - OTCM-47675 - I0255 changes ED2K926022
********************* Address Lines 3 and 4 *******************************
            IF lst_adrc-location IS NOT INITIAL.  " Street5
              <lst_back_label>-stras = lst_adrc-location.   " Address Line3 = Street5
              CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
              IF lst_adrc-street IS NOT INITIAL.
                CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street
              ENDIF.
              IF lst_adrc-str_suppl3 IS NOT INITIAL.  " Street4
                IF lst_tmp IS NOT INITIAL.
                  CONCATENATE lst_tmp                 " Street
                              c_semicol               " Semi-Colon
                              ` `                     " Space
                              lst_adrc-str_suppl3     " Street 4
                         INTO lst_tmp.                " Street + Street4
                ELSE.
                  CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                ENDIF.
              ENDIF.
              <lst_back_label>-ort02 = lst_tmp.           " Address Line4 = Street + Street4
            ELSE.  " Stree5 is balnk here
* If street is exceeding 50 characters
              IF strlen( lst_adrc-street ) > c_splt_len.  " 50
                CLEAR: lst_tmp_name, li_outlines, lst_line.
                CONCATENATE lst_adrc-street            " Street (60char field)
                            c_semicol                  " Semi-Colon
                            ` `                        " Space
                            lst_adrc-str_suppl3        " Street (40char field)
                       INTO lst_tmp_name.
* Calling the FM to split the concatenated string into strings of 50 char each
                CALL FUNCTION 'RKD_WORD_WRAP' " Splits a string in Telstrings of given length
                  EXPORTING
                    textline            = lst_tmp_name
                    delimiter           = ' '
                    outputlen           = c_splt_len    " 50
                  TABLES
                    out_lines           = li_outlines[]
                  EXCEPTIONS
                    outputlen_too_large = 1
                    OTHERS              = 2.
                IF sy-subrc <> 0.
*   Nothing to implement here
                ENDIF.
                IF li_outlines[] IS NOT INITIAL.
                  LOOP AT li_outlines INTO lst_line.
*   Passing each of the splitted lines to Address Lines 3 and 4 respectively
                    CASE sy-tabix.
                      WHEN 1.
                        <lst_back_label>-stras = lst_line-line. " Address Line 3
                      WHEN 2.
                        <lst_back_label>-ort02 = lst_line-line. " Address Line 4
                    ENDCASE.
                  ENDLOOP.  " LOOP AT li_outlines INTO lst_line.
                ENDIF.  " IF li_outlines[] IS NOT INITIAL.
              ELSE.  " Street is < 50 characters here
                <lst_back_label>-stras = lst_adrc-street.     " Street  - Addr Line3
                <lst_back_label>-ort02 = lst_adrc-str_suppl3. " Street4 - Addr Line4
              ENDIF.   " IF strlen( lst_adrc-street ) > c_splt_len.  " 50
            ENDIF.   " IF lst_adrc-location IS NOT INITIAL.  " Street5
* EOC - GKINTALI - 05/19/2018 - ED1K907377  - RITM0025850 & CR - ERP-7478
***** BOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
            " This logic is exclusively added to format Address line 3 & 4 values for
            " Individual business partners only
            READ TABLE li_but000 INTO lst_but000
                                 WITH KEY partner = <lst_back_label>-ship_to_cust.
            IF sy-subrc = 0 AND lst_but000-type = c_bu_per.
              CLEAR : <lst_back_label>-stras, <lst_back_label>-ort02.
              IF NOT lst_adrc-str_suppl2 IS INITIAL.                 " Street3
                <lst_back_label>-stras = lst_adrc-str_suppl2.        " Address Line3 = Street3
                CLEAR: lst_tmp.
**** To avoid multiple commas / spaces consecutively being concatenated if any of the fields are blank
                IF lst_adrc-location IS NOT INITIAL.                 " Street5
                  CONCATENATE lst_tmp lst_adrc-location INTO lst_tmp." Street5
                ENDIF.
                IF lst_adrc-street IS NOT INITIAL.
                  CONCATENATE lst_tmp                              " Street
*                               c_semicol                            " Semi-Colon
                              ` `                                  " Space
                              lst_adrc-street                      " Street
                         INTO lst_tmp.                             " Street5 + Street
                ELSE.
                  CONCATENATE lst_tmp lst_adrc-street INTO lst_tmp.  " Street5 + Street
                ENDIF.
                IF lst_adrc-str_suppl3 IS NOT INITIAL.               " Street4
                  IF lst_tmp IS NOT INITIAL.
                    CONCATENATE lst_tmp                              " Street
*                                c_semicol                            " Semi-Colon
                                ` `                                  " Space
                                lst_adrc-str_suppl3                  " Street 4
                           INTO lst_tmp.                             " Street5 + Street + Street4
                  ELSE.
                    CONCATENATE lst_tmp lst_adrc-str_suppl3 INTO lst_tmp.
                    " Street5 + Street + Street4
                  ENDIF.
                ENDIF.
                <lst_back_label>-ort02 = lst_tmp.                    " Address Line4 = Street + Street4
              ELSE.                                                  " Street3 is blank
                IF NOT lst_adrc-location IS INITIAL.                 " Street 5
                  <lst_back_label>-stras = lst_adrc-location.        " Address Line 3 = Street 5
                  CLEAR: lst_tmp_name, li_outlines, lst_line.
                  CONCATENATE lst_adrc-street                         " Street
*                              c_semicol                               " Semi-Colon
                              ` `                                     " Space
                              lst_adrc-str_suppl3                     " Street 4
                         INTO lst_tmp_name.
                  <lst_back_label>-ort02 = lst_tmp_name.              " Address Line 4  = Street + Street 4
                ELSE.
                  <lst_back_label>-stras = lst_adrc-street.           " Address Line 3 = Street
                  <lst_back_label>-ort02 = lst_adrc-str_suppl3.       " Address Line 4 = Street 4
                ENDIF.           " IF NOT lst_adrc-location IS INITIAL.                 " Street 5
              ENDIF.             " IF NOT lst_adrc-str_suppl2 IS INITIAL.
            ENDIF.               " IF sy-subrc = 0 AND lst_but000-type = '1'.
***** EOC - GVS05212018 - ED1K907411 - RITM0025850 & CR - ERP-7478
*            CONCATENATE <lst_kna1>-stras lst_adrc-str_suppl3 lst_adrc-location
*                                   INTO <lst_back_label>-stras SEPARATED BY c_comma.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
            IF lst_adrc-tel_number IS NOT INITIAL.  " Full Telephone Number
              <lst_back_label>-tel_number = lst_adrc-tel_number.
            ENDIF.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
          ELSE.
* Considering the field STREET from Customer Master: KNA1-STRAS in case if ADRC does not exist
            <lst_back_label>-stras = <lst_kna1>-stras. "Address Line 3
*            <lst_back_label>-stras = lst_adrc-street. "Address Line 3
          ENDIF.
* End of Change by PBANDLPAL on 29-Jun-2017 for CR#571
          <lst_back_label>-telf1 = <lst_kna1>-telf1. "Telephone number
* BOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
* Commented this line and added before. In case of AddressLine3 not exceeding 50char,
* this value will be continued. Otherwise, the splitted string will be overwriting this.
*          <lst_back_label>-ort02 = <lst_kna1>-ort02. "Address Line 4
* EOC - GKINTALI - 14/03/2018 - ED2K910947 - ERP-6967
          READ TABLE li_t005t ASSIGNING FIELD-SYMBOL(<lst_t005t_k>)
                                            WITH KEY land1 = <lst_kna1>-land1
                                            BINARY SEARCH.
          IF sy-subrc = 0.
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*            <lst_back_label>-landx = <lst_t005t_k>-landx. "Country Name
            <lst_back_label>-landx50 = <lst_t005t_k>-landx50. " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
            <lst_back_label>-land1 = <lst_t005t_k>-intca3. "Country ISO Code    " Insert CR#471
            <lst_back_label>-country = <lst_t005t_k>-land1. " Two Character Country " Insert for CR 371 & 435.
          ENDIF. " IF sy-subrc = 0
* BOC - HIPATEL - ERP-7404 - ED2K911953 - 26.04.2018
* VAT Registration Number read from ZCACONSTANT table for Canada
          IF <lst_back_label>-country = c_cntry_ca.
            CLEAR lst_constant.
            READ TABLE i_constant INTO lst_constant WITH KEY param1 = <lst_back_label>-vkorg.
            IF sy-subrc EQ 0.
              <lst_back_label>-stcd1 = lst_constant-low. "Canadian GST no.
            ENDIF.
          ENDIF.
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 26.04.2018
        ENDIF. " IF sy-subrc = 0
* Begin of Change for CR#371 & 435 PBANDLAPAL
        READ TABLE li_vbpa_ag INTO DATA(lst_vbpa_ag) WITH KEY vbeln = <lst_delivery>-vgbel
                                                              parvw = c_parvw_ag BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE li_society ASSIGNING FIELD-SYMBOL(<lst_society>) WITH KEY
                                                                   jrnl_grp_code =  <lst_back_label>-identcode
                                                                   society = lst_vbpa_ag-kunnr
                                                                   BINARY SEARCH.
          IF sy-subrc EQ 0.
            <lst_back_label>-society = <lst_society>-society_acrnym.
          ENDIF.
          IF <lst_back_label>-society IS INITIAL.
            <lst_back_label>-society = c_star.
          ENDIF.
        ENDIF.
* End of Change for CR#371 & 435 PBANDLAPAL
      ENDIF. " IF sy-subrc = 0
*    ENDIF. " IF sy-subrc EQ 0 " Commented by GKINTALI:20/03/2018:ED2K910947:ERP-6967

* To validate mandatory fields and raise an error messages in error log file.
      PERFORM validate_mandatory_fields_bl USING <lst_back_label>
                                                 <lst_delivery>-vbeln
                                                 <lst_delivery>-posnr.
* BOC -  GKINTALI - 20/03/2018 - ED2K910947 - ERP-6967
* To avoid the runtime error:GETWA_NOT_ASSIGNED at line no: 2247 while calling
* the sub-routine: VALIDATE_MANDATORY_FIELDS_BL in case if <LST_BACK_LABEL> is not assigned
    ENDIF. " IF sy-subrc EQ 0
* EOC -  GKINTALI - 20/03/2018 - ED2K910947 - ERP-6967
    CLEAR: lst_vbpa_sb,
           lst_vbpa_cb,
           v_ship_instruction,
           v_ship_instruction1,  "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
           v_delv_instruction.
  ENDLOOP. " LOOP AT li_delv_final ASSIGNING FIELD-SYMBOL(<lst_delivery>)


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*       Get selection screen field
*----------------------------------------------------------------------*
FORM f_selection_screen .
* BOC - HIPATEL - ERP-7404 - ED2K911953 - 26.04.2018
* Authority Check to generate Files
* If authorized, enable the for File generation check box(CB_LBL)
  AUTHORITY-CHECK OBJECT 'ZDEL_I0255'
      ID 'ACTVT'  FIELD '16'.
  IF sy-subrc <> 0.
    CLEAR cb_lbl.
* Code for deactivating the Check box on the Selection screen.
    LOOP AT SCREEN.
      IF screen-group1 = 'G6'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G6'
    ENDLOOP.
  ENDIF.
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 26.04.2018
  IF rb1 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'G1'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G1'
      IF screen-group1 = 'G2'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
      IF screen-group1 = 'G3'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G4'
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
        AND cb_lbl = space.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'G4' AND
             cb_lbl = abap_true.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G5'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      IF screen-group1 = 'G9'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G9'
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
    ENDLOOP. " LOOP AT SCREEN
  ELSEIF rb2 EQ abap_true.
    " ELSE -> IF rb1 EQ abap_true
    LOOP AT SCREEN.
      IF screen-group1 = 'G1'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G1'
      IF screen-group1 = 'G2'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
      IF screen-group1 = 'G3'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G4'
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
        AND cb_lbl = space.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'G4' AND
             cb_lbl = abap_true.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G5'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      IF screen-group1 = 'G9'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G9'
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
    ENDLOOP. " LOOP AT SCREEN
  ELSEIF rb3 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'G1'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G1'
      IF screen-group1 = 'G2'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G3'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G3'
      IF screen-group1 = 'G4'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
      IF screen-group1 = 'G5'.
        screen-invisible = 0.
        screen-active = 1.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G2'
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      IF screen-group1 = 'G9'.
        screen-invisible = 1.
        screen-active = 0.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'G9'
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF rb1 EQ abap_true
  CLEAR sy-ucomm.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SHIPPMENT
*&---------------------------------------------------------------------*
*    Get validate Shipping point
*----------------------------------------------------------------------*
*      -->P_S_SHIP[]  Shipping Point
*----------------------------------------------------------------------*
FORM f_validate_shippment  USING  fp_s_ship TYPE fip_t_bsart_range.
  SELECT vstel "Shipping Point
     FROM tvst " Organizational Unit: Shipping Points
     UP TO 1 ROWS
     INTO @DATA(lv_vstel)
     WHERE vstel IN @fp_s_ship.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Shipping Point!
    MESSAGE e090(zqtc_r2). " Invalid Shipping Point!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATERIAL
*&---------------------------------------------------------------------*
*       Get validate Material
*----------------------------------------------------------------------*
*      -->P_S_MATNR[]  Material
*----------------------------------------------------------------------*
FORM f_validate_material  USING  fp_s_matnr TYPE fip_t_matnr_range.
  SELECT matnr "Material
    FROM mara  " General Material Data
    UP TO 1 ROWS
    INTO @DATA(lv_matnr)
    WHERE matnr IN @fp_s_matnr.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Material Number!
    MESSAGE e027(zqtc_r2). " Invalid Material Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PLANT
*&---------------------------------------------------------------------*
*       Get validate Plant
*----------------------------------------------------------------------*
*      -->P_S_PLANT[]  Plant
*----------------------------------------------------------------------*
FORM f_validate_plant  USING  fp_s_plant TYPE fip_t_werks_range.
  SELECT werks "Plant
    FROM t001w " Plants/Branches
    UP TO 1 ROWS
    INTO @DATA(lv_werks)
    WHERE werks IN @fp_s_plant.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Plant!
    MESSAGE e102(zqtc_r2). " Invalid Plant!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATERIAL_TYPE
*&---------------------------------------------------------------------*
*       Get validate Material Type
*----------------------------------------------------------------------*
*      -->P_S_TYPE[]  Material Type
*----------------------------------------------------------------------*
FORM f_validate_material_type  USING  fp_s_type TYPE fip_t_mtart_range.
  SELECT mtart  "Material type
      FROM t134 " Material Types
      UP TO 1 ROWS
      INTO @DATA(lv_mtart)
      WHERE mtart IN @fp_s_type.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Material Type!
    MESSAGE e103(zqtc_r2). " Invalid Material Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DOC_TYPE1
*&---------------------------------------------------------------------*
*       Get validate Document
*----------------------------------------------------------------------*
*      -->P_S_DOC1[]  text
*----------------------------------------------------------------------*
FORM f_validate_doc_type1  USING  fp_s_doc1 TYPE fip_t_bsart_range.
  SELECT lfart  "Delivery Type!
      FROM tvlk " Delivery Types
      UP TO 1 ROWS
      INTO @DATA(lv_lfart)
      WHERE lfart IN @fp_s_doc1.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Delivery Type!
    MESSAGE e091(zqtc_r2). " Invalid Delivery Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DOC_TYPE2
*&---------------------------------------------------------------------*
*       Get validate Document Type
*----------------------------------------------------------------------*
*      -->P_S_DOC2[]  Document Type
*----------------------------------------------------------------------*
FORM f_validate_doc_type2  USING  fp_s_doc2 TYPE fip_t_bsart_range.

*  SELECT bsart  "Purchasing Document type
*      FROM ekko " Purchasing Document Header
*      UP TO 1 ROWS
*      INTO @DATA(lv_bsart)
*      WHERE bsart IN @fp_s_doc2.
*  ENDSELECT.
  SELECT bsart
        FROM t161
     UP TO 1 ROWS
    INTO @DATA(lv_bsart)
      WHERE bsart IN @fp_s_doc2.
  ENDSELECT.
  IF sy-subrc NE 0.
*  Invalid Purchasing Document Type!
    MESSAGE e092(zqtc_r2). " Invalid Purchasing Document Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ITEM_CAT
*&---------------------------------------------------------------------*
*       Get validate Item catergory
*----------------------------------------------------------------------*
*      -->P_S_ITEM[]  Item category
*----------------------------------------------------------------------*
FORM f_validate_item_cat  USING  fp_s_item TYPE fip_t_pstyp_range.
*  SELECT  pstyp "Item category
*    FROM ekpo   " Purchasing Document Item
*    UP TO 1 ROWS
*    INTO @DATA(lv_pstyp)
*    WHERE pstyp IN @fp_s_item.
*  ENDSELECT.
  SELECT pstyp "Item category
    FROM t163   " Item Categories in Purchasing Document
    UP TO 1 ROWS
    INTO @DATA(lv_pstyp)
    WHERE pstyp IN @fp_s_item.
  ENDSELECT.
  IF sy-subrc NE 0.
*  Invalid Item Category!
    MESSAGE e093(zqtc_r2). " Invalid Item Category!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ACCOUNT_ASSIGN
*&---------------------------------------------------------------------*
*       Get validate Account assignment
*----------------------------------------------------------------------*
*      -->P_S_ACCT[]  Account assignment
*----------------------------------------------------------------------*
FORM f_validate_account_assign  USING  fp_s_acct TYPE fip_t_knttp_range.
*  SELECT  knttp "Account assignment
*      FROM ekpo " Purchasing Document Item
*      UP TO 1 ROWS
*      INTO @DATA(lv_knttp)
*      WHERE knttp IN @fp_s_acct.
*  ENDSELECT.

  SELECT  knttp "Account assignment
      FROM t163k " Purchasing Document Item
      UP TO 1 ROWS
      INTO @DATA(lv_knttp)
      WHERE knttp IN @fp_s_acct.
  ENDSELECT.
  IF sy-subrc NE 0.
*  Invalid Account Assignment Type!
    MESSAGE e094(zqtc_r2). " Invalid Account Assignment Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VENDOR
*&---------------------------------------------------------------------*
*       Get validate  Vendor
*----------------------------------------------------------------------*
*      -->P_S_VEND[]  Vendor
*----------------------------------------------------------------------*
FORM f_validate_vendor  USING  fp_s_vend TYPE fip_t_lifnr_range.
  SELECT  lifnr " Account Number of Vendor or Creditor
      FROM lfa1 " Vendor Master (General Section)
      UP TO 1 ROWS
      INTO @DATA(lv_lifnr)
      WHERE lifnr IN @fp_s_vend.
  ENDSELECT.

  IF sy-subrc NE 0.
*  Invalid Vendor ID!
    MESSAGE e095(zqtc_r2). " Invalid Vendor ID!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MAIN_LABEL_FILE
*&---------------------------------------------------------------------*
*       Get success file record for main label
*----------------------------------------------------------------------*
*      -->P_LI_MAIN_LABEL[]  Main Label Structure
*----------------------------------------------------------------------*
FORM f_get_main_label_file CHANGING fp_li_main_label TYPE tt_main_label
                                    fp_li_split TYPE tt_split.
*  Local Data Declaration
  DATA : lst_main_label1 TYPE string,
         lst_main_label2 TYPE string,
         lst_heading1    TYPE string,
         lst_heading2    TYPE string.

*  Local Variable Declaration
  DATA : lv_fname        TYPE string,
         lv_count        TYPE i,      " Count of type Integers
         lv_filename     TYPE string,
         lv_filename1    TYPE sood-objdes,
         lv_process      TYPE string,
         lv_date         TYPE char10, " Date of type CHAR10
         lv_menge        TYPE char17, " Menge of type CHAR17
         lv_string       TYPE string,
         lv_email        TYPE ad_smtpadr,
         lv_fileopen_suc TYPE char1,  " Fileopen_suc of type CHAR1
         lv_lifnr        TYPE lifnr.  " Account Number of Vendor or Creditor
*
  DATA:lir_ship_to       TYPE tt_ship_to,
       lir_konda         TYPE tt_konda,
       lir_auart         TYPE tt_auart,
       lir_augru         TYPE tt_augru,
       lir_media_issue   TYPE tt_media,
       lir_society       TYPE tt_society,
       lir_mdprd         TYPE tt_mdprd,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
       lir_salesorg      TYPE tt_salesorg,
       lir_condgrp2      TYPE tt_condgrp2,
       lst_salesorg      TYPE ty_salesorg,
       lst_condgrp2      TYPE ty_condgrp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
       lst_mdprd         TYPE ty_mdprd,
       lst_media         TYPE ty_media,
       lst_konda         TYPE ty_konda,
       lst_auart         TYPE ty_auart,
       lst_augru         TYPE ty_augru,
       lst_society       TYPE ty_society,
       lst_main_label    TYPE ty_label,
       li_mainlbl_split  TYPE tt_main_label,
       li_mlabel_split   TYPE tt_mlabel_var,
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
       li_var_split      TYPE tt_main_label,
       li_ml_mdprod      TYPE tt_ml_mdprod,
       lst_ml_mdprod     TYPE ty_ml_mdprod,
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
       lst_mlbl_split    TYPE ty_mlabel_var,
       lst_mlabel_split  TYPE ty_mlabel_var,
       lst_mlabel_split1 TYPE string,
       lst_ship_to       TYPE ty_ship_to.
*       lst_main_attach  TYPE ty_attach_main.

  IF p_file IS NOT INITIAL.
    lv_process = p_file.
  ELSE. " ELSE -> IF p_file IS NOT INITIAL
    CONCATENATE v_fpath_df c_slash c_fldr_in INTO lv_process.
  ENDIF. " IF p_file IS NOT INITIAL

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
**Fetch data from custom table
  IF rb1 IS NOT INITIAL.
    DATA(lv_label) = c_type_ml. "ML
  ELSE.
    lv_label = c_type_bl. "BL
  ENDIF.

  DATA(li_main_label_mprod) = fp_li_main_label[].
  SORT li_main_label_mprod BY mdprod.
  DELETE ADJACENT DUPLICATES FROM li_main_label_mprod COMPARING mdprod.
  IF li_main_label_mprod IS NOT INITIAL.
    SELECT labltp,
           varname,
           zseqno,
           media_product,
           media_issue,
           price_grp,
           ship_to_code,
           society_grp_code,
           reason_code,
           subscription_cls,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
           sales_org,
           condition_grp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
           cntrl_circulation,
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
           varsplit,
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
           email
      FROM zqtc_i0255_split
      INTO TABLE @fp_li_split
*      FOR ALL ENTRIES IN @li_main_label_mprod             " Not required #7404
      WHERE labltp = @lv_label.
*        AND media_product = @li_main_label_mprod-mdprod.  " Not required #7404
    IF sy-subrc EQ 0.
      SORT fp_li_split DESCENDING BY media_issue
                                     price_grp
                                     ship_to_code
                                     society_grp_code
                                     reason_code
                                     subscription_cls
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                     sales_org
                                     condition_grp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                     media_product
                                     varname.
    ENDIF.
  ENDIF.

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
**Check Wrong entry maintained in ZQTC_I0255_SPLIT
*If more than one entry found for Media Product so its a wrong entry
  IF rb_var EQ abap_true.
    LOOP AT fp_li_split INTO DATA(lst_ml_split) WHERE varsplit EQ abap_true.
      lst_ml_mdprod-media_product     = lst_ml_split-media_product.
      lst_ml_mdprod-cntrl_circulation = lst_ml_split-cntrl_circulation.
      lst_ml_mdprod-varsplit          = lst_ml_split-varsplit.
      COLLECT lst_ml_mdprod INTO li_ml_mdprod.
    ENDLOOP.
  ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

  LOOP AT fp_li_split INTO DATA(lst_split).
    CLEAR: lir_mdprd, lir_konda, lir_ship_to, lir_augru, lir_society, lir_auart, lir_media_issue,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
           lir_salesorg, lir_condgrp2, lst_salesorg, lst_condgrp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
           lst_media, lst_ship_to, lst_augru, lst_auart, lst_konda, lst_society.
*      Media Product range
    lst_mdprd-sign = c_sign.
    IF lst_split-media_product EQ space.
      lst_mdprd-option = c_option_cp.
      lst_mdprd-low = c_star.
    ELSE.
      lst_mdprd-option = c_option_eq.
      lst_mdprd-low = lst_split-media_product.
    ENDIF.

    APPEND lst_mdprd TO lir_mdprd.
    CLEAR: lst_media.

* To build Media Issue(material).
    lst_media-sign = c_sign.
    IF lst_split-media_issue EQ space.
      lst_media-option = c_option_cp.
      lst_media-low = c_star.
    ELSE.
      lst_media-option = c_option_eq.
      lst_media-low = lst_split-media_issue.
    ENDIF.

    APPEND lst_media TO lir_media_issue.
    CLEAR: lst_media.

*      Price Group Range
    lst_konda-sign = c_sign.
    IF lst_split-price_grp EQ space.
      lst_konda-option = c_option_cp.
      lst_konda-low =  c_star.
    ELSE.
      lst_konda-option = c_option_eq.
      lst_konda-low = lst_split-price_grp.
    ENDIF.

    APPEND lst_konda TO lir_konda.
    CLEAR: lst_konda.
*      Ship To Code Range
    lst_ship_to-sign = c_sign.
    IF lst_split-ship_to_code EQ space.
      lst_ship_to-option = c_option_cp.
      lst_ship_to-low = c_star.
    ELSE.
      lst_ship_to-option = c_option_eq.
      lst_ship_to-low = lst_split-ship_to_code.
    ENDIF.

    APPEND lst_ship_to TO lir_ship_to.
    CLEAR: lst_ship_to.

*      Society Range
    lst_society-sign = c_sign.
    IF lst_split-society_grp_code EQ space.
      lst_society-option = c_option_cp.
      lst_society-low = c_star..
    ELSE.
      lst_society-option = c_option_eq.
      lst_society-low = lst_split-society_grp_code.
    ENDIF.

    APPEND lst_society TO lir_society.
    CLEAR: lst_ship_to.
*      Reason Code range
    lst_augru-sign = c_sign.
    IF lst_split-reason_code EQ space.
      lst_augru-option = c_option_cp.
      lst_augru-low = c_star.
    ELSE.
      lst_augru-option = c_option_eq.
      lst_augru-low = lst_split-reason_code.
    ENDIF.

    APPEND lst_augru TO lir_augru.
    CLEAR: lst_augru.

*      Subscription Class
    lst_auart-sign = c_sign.
    IF lst_split-subscription_cls EQ space.
      lst_auart-option = c_option_cp.
      lst_auart-low = c_star.
    ELSE.
      lst_auart-option = c_option_eq.
      lst_auart-low = lst_split-subscription_cls.
    ENDIF.

    APPEND lst_auart TO lir_auart.
    CLEAR: lst_auart.

* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
* To build Sales Organization data.
    lst_salesorg-sign = c_sign.
    IF lst_split-sales_org EQ space.
      lst_salesorg-option = c_option_cp.
      lst_salesorg-low    = c_star.
    ELSE.
      lst_salesorg-option = c_option_eq.
      lst_salesorg-low    = lst_split-sales_org.
    ENDIF.

    APPEND lst_salesorg TO lir_salesorg.
    CLEAR: lst_salesorg.

* To build Condition Group2 data.
    lst_condgrp2-sign = c_sign.
    IF lst_split-condition_grp2 EQ space.
      lst_condgrp2-option = c_option_cp.
      lst_condgrp2-low    = c_star.
    ELSE.
      lst_condgrp2-option = c_option_eq.
      lst_condgrp2-low    = lst_split-condition_grp2.
    ENDIF.

    APPEND lst_condgrp2 TO lir_condgrp2.
    CLEAR: lst_condgrp2.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
    IF rb_var EQ abap_true.
**Mark all Media Product which is maintained both flag 'X' in table ZQTC_I0255_SPLIT
      CLEAR lst_main_label.
      READ TABLE fp_li_main_label INTO lst_main_label WITH KEY mdprod = lst_split-media_product.
      IF sy-subrc EQ 0 AND lst_split-cntrl_circulation IS NOT INITIAL AND lst_split-varsplit IS NOT INITIAL.
        lst_main_label-cntrl_var = abap_true.
        MODIFY fp_li_main_label FROM lst_main_label TRANSPORTING cntrl_var WHERE mdprod = lst_split-media_product.
      ENDIF.
**Check Wrong entry maintained in ZQTC_I0255_SPLIT
*If more than one entry found for Media Product so its a wrong entry
      DATA(li_ml_mdprod_tmp) = li_ml_mdprod[].
      DELETE li_ml_mdprod_tmp WHERE media_product NE lst_split-media_product.
      DESCRIBE TABLE li_ml_mdprod_tmp LINES lv_count.
      IF lv_count > 1.
        CLEAR lst_main_label.
        READ TABLE fp_li_main_label INTO lst_main_label WITH KEY mdprod = lst_split-media_product.
        IF sy-subrc EQ 0.
          lst_main_label-cntrl_var = abap_true.
          MODIFY fp_li_main_label FROM lst_main_label TRANSPORTING cntrl_var WHERE mdprod = lst_split-media_product.
        ENDIF.
      ENDIF.
    ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

*  Assigning the entries of main internal table to temporaray local table
    DATA(li_main_label_tmp) = fp_li_main_label[].
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
*    SORT li_main_label_tmp BY matnr land1 mdprod augru auart society konda.
    SORT li_main_label_tmp BY matnr land1 mdprod augru auart vkorg kdkg2 society konda.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
    DELETE li_main_label_tmp WHERE matnr NOT IN lir_media_issue
                                OR country NOT IN lir_ship_to
                                OR mdprod NOT IN lir_mdprd
                                OR augru NOT IN lir_augru
                                OR auart NOT IN lir_auart
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                OR vkorg NOT IN lir_salesorg
                                OR kdkg2 NOT IN lir_condgrp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                OR society NOT IN lir_society
                                OR konda NOT IN lir_konda.

    DELETE fp_li_main_label WHERE matnr IN lir_media_issue
                                  AND country IN lir_ship_to
                                  AND mdprod IN lir_mdprd
                                  AND augru IN lir_augru
                                  AND auart IN lir_auart
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                  AND vkorg IN lir_salesorg
                                  AND kdkg2 IN lir_condgrp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 16.04.2018
                                  AND society IN lir_society
                                  AND konda IN lir_konda.
    CLEAR lst_main_label.
    READ TABLE li_main_label_tmp INTO lst_main_label INDEX 1.
    IF sy-subrc EQ 0.
      lst_main_label-varname = lst_split-varname.
      IF lst_split-cntrl_circulation IS NOT INITIAL.
        lst_main_label-email = lst_split-email.
      ENDIF.
      MODIFY li_main_label_tmp FROM lst_main_label TRANSPORTING varname WHERE varname IS INITIAL.
      APPEND LINES OF li_main_label_tmp TO li_mainlbl_split.
    ENDIF.
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
    IF rb_var EQ abap_true.
**Remove mark from Unconditional records where Media Product which is maintained both flag 'X'
*in table ZQTC_I0255_SPLIT but exist in Conditional records table
      CLEAR lst_main_label.
      READ TABLE li_mainlbl_split INTO lst_main_label WITH KEY mdprod = lst_split-media_product.
      IF sy-subrc EQ 0 AND lst_split-cntrl_circulation IS NOT INITIAL AND lst_split-varsplit IS NOT INITIAL.
        lst_main_label-cntrl_var = space.
        MODIFY fp_li_main_label FROM lst_main_label TRANSPORTING cntrl_var WHERE mdprod = lst_split-media_product.
      ENDIF.
    ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
    REFRESH: li_main_label_tmp.
  ENDLOOP.

  MOVE-CORRESPONDING li_mainlbl_split[] TO li_mlabel_split[].

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*Removing SP_JUNK Functionality as no longer needed
**BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
**Split criteria based on selection screen input
**  SORT li_mlabel_split BY matnr varname.
*    READ TABLE i_constant INTO data(lst_constant) with key param1 = c_uncond_var
*                                                           param2 = c_type_ml.
*    IF sy-subrc = 0.
*      CLEAR lst_main_label.
*      READ TABLE fp_li_main_label INTO lst_main_label INDEX 1.
*      IF sy-subrc = 0.
*        lst_main_label-varname = lst_constant-low.
*        MODIFY fp_li_main_label FROM lst_main_label TRANSPORTING varname WHERE varname IS INITIAL.
*      ENDIF.
*    ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
  IF rb_mat EQ abap_true.
    li_var_split[] = fp_li_main_label[].
  ENDIF.

  IF rb_var EQ abap_true.
*Only records maintain in  ZQTC_I0255_SPLIT table are required
    LOOP AT li_ml_mdprod INTO lst_ml_mdprod.
      DATA(li_var_split_tmp) = fp_li_main_label[].
      DELETE li_var_split_tmp WHERE mdprod NE lst_ml_mdprod-media_product.
      lst_main_label-cntrl_var = space.
      MODIFY li_var_split_tmp FROM lst_main_label TRANSPORTING cntrl_var WHERE mdprod = lst_ml_mdprod-media_product.
      APPEND LINES OF li_var_split_tmp TO li_var_split.
    ENDLOOP.
  ENDIF.
  IF rb_var EQ abap_true.
    CLEAR fp_li_main_label[].
  ENDIF.
*  ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

  IF rb_mat EQ abap_true.
    SORT li_mlabel_split BY matnr varname.    "Material Number
    SORT fp_li_main_label BY matnr varname.   "Material Number
  ELSEIF rb_var EQ abap_true.
    SORT li_mlabel_split BY varname matnr.    "Variant Name
    SORT fp_li_main_label BY varname matnr.   "Variant name
    SORT li_var_split BY mdprod varname matnr.      "Media Product "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

* BOC - HIPATEL - ERP-7404 - ED2K911914 - 17.04.2018
  IF cb_lbl = 'X'.
* Logic for Main Label File Data
    PERFORM f_get_file_ml USING li_mlabel_split
                                fp_li_split
                                fp_li_main_label
                                lv_process
                                li_var_split. "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ELSE.
* Logic for Main Label ALV Data
    PERFORM f_get_alv_ml USING li_mlabel_split
                               fp_li_split
                               fp_li_main_label
                               li_var_split. "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ENDIF.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 17.04.2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BACK_LABEL_FILE
*&---------------------------------------------------------------------*
*       Get success file record for back label
*----------------------------------------------------------------------*
*      -->P_LI_BACK_LABEL[]  Back Label Structure
*----------------------------------------------------------------------*
FORM f_get_back_label_file  USING    fp_li_back_label  TYPE tt_back_label
                                     fp_li_split TYPE tt_split.

*  Local Data Declaration
  DATA : li_back_label   TYPE tt_back_label,
         lst_back_label1 TYPE string,
         lst_back_label  TYPE ty_back_label,
         lst_heading1    TYPE string,
         lst_heading2    TYPE string,
         lst_heading3    TYPE string.

*  Local Variable Declaration
  DATA : lv_fname        TYPE string,
         lv_count        TYPE i,          " Count of type Integers
         lv_seqno        TYPE numc4,      " Sequence number - GKINTALI:13/03/2018:ED2K910947:ERP-6967
         lv_filename     TYPE string,
         lv_process      TYPE string,
         lv_time_stmp    TYPE timestampl, " Time in CHAR Format
         lv_time_stmp_s  TYPE string,
         lv_date         TYPE char10,     " Date of type CHAR10
         lv_fdate        TYPE char8,
         lv_lfimg        TYPE char17,     " Lfimg of type CHAR17
         lv_string       TYPE string,
         lv_email        TYPE ad_smtpadr,
         lv_filename1    TYPE sood-objdes,
         lv_fileopen_suc TYPE char1.      " Fileopen_suc of type CHAR1

  DATA:lir_ship_to       TYPE tt_ship_to,
       lir_konda         TYPE tt_konda,
       lir_auart         TYPE tt_auart,
       lir_augru         TYPE tt_augru,
       lir_media_issue   TYPE tt_media,
       lir_media_product TYPE tt_media,
       lir_society       TYPE tt_society,
       lst_media         TYPE ty_media,
       lst_konda         TYPE ty_konda,
       lst_auart         TYPE ty_auart,
       lst_augru         TYPE ty_augru,
       lst_society       TYPE ty_society,
       lst_ship_to       TYPE ty_ship_to,
       lir_mdprd         TYPE tt_mdprd,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
       lir_salesorg      TYPE tt_salesorg,
       lir_condgrp2      TYPE tt_condgrp2,
       lst_salesorg      TYPE ty_salesorg,
       lst_condgrp2      TYPE ty_condgrp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
       lst_mdprd         TYPE ty_mdprd,
       li_label_split    TYPE tt_blabel_var,
       li_backlbl_split  TYPE tt_back_label,
       lst_lbl_split     TYPE ty_blabel_var,
       lst_label_split   TYPE ty_blabel_var,
       lst_label_split1  TYPE string.

  IF p_file IS NOT INITIAL.
    lv_process = p_file.
  ELSE. " ELSE -> IF p_file IS NOT INITIAL
    CONCATENATE v_fpath_df c_slash c_fldr_in INTO lv_process.
  ENDIF. " IF p_file IS NOT INITIAL

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>

*<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
*If Main Label or Back label is checked
  IF rb1 IS NOT INITIAL.
    DATA(lv_label) = c_type_ml. "ML
  ELSE.
    lv_label = c_type_bl. "BL
  ENDIF.

  DATA(li_back_label_mprod) = fp_li_back_label[].
  SORT li_back_label_mprod BY mdprod.
  DELETE ADJACENT DUPLICATES FROM li_back_label_mprod COMPARING mdprod.
  IF li_back_label_mprod IS NOT INITIAL.
    SELECT labltp,
           varname,
           zseqno,
           media_product,
           media_issue,
           price_grp,
           ship_to_code,
           society_grp_code,
           reason_code,
           subscription_cls,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
           sales_org,
           condition_grp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
           cntrl_circulation,
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
          varsplit,
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
           email
      FROM zqtc_i0255_split
      INTO TABLE @fp_li_split
*      FOR ALL ENTRIES IN @li_back_label_mprod               " Not required #7404
      WHERE labltp = @lv_label.
*        AND media_product = @li_back_label_mprod-mdprod.    " Not required #7404
    IF sy-subrc EQ 0.
      SORT fp_li_split DESCENDING BY media_issue
                                     price_grp
                                     ship_to_code
                                     society_grp_code
                                     reason_code
                                     subscription_cls
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                     sales_org
                                     condition_grp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                     media_product
                                     varname.
    ENDIF.
  ENDIF.

  LOOP AT fp_li_split INTO DATA(lst_split).
    CLEAR: lir_mdprd, lir_konda, lir_ship_to, lir_augru, lir_society, lir_auart, lir_media_issue,
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
           lir_salesorg, lir_condgrp2, lst_salesorg, lst_condgrp2,
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
               lst_media, lst_ship_to, lst_augru, lst_auart, lst_konda, lst_society.
*      Media Product range
    lst_mdprd-sign = c_sign.
    IF lst_split-media_product EQ space.
      lst_mdprd-option = c_option_cp.
      lst_mdprd-low = c_star.
    ELSE.
      lst_mdprd-option = c_option_eq.
      lst_mdprd-low = lst_split-media_product.
    ENDIF.

    APPEND lst_mdprd TO lir_mdprd.
    CLEAR: lst_media.

* To build Media Issue(material).
    lst_media-sign = c_sign.
    IF lst_split-media_issue EQ space.
      lst_media-option = c_option_cp.
      lst_media-low = c_star.
    ELSE.
      lst_media-option = c_option_eq.
      lst_media-low = lst_split-media_issue.
    ENDIF.

    APPEND lst_media TO lir_media_issue.
    CLEAR: lst_media.

*      Price Group Range
    lst_konda-sign = c_sign.
    IF lst_split-price_grp EQ space.
      lst_konda-option = c_option_cp.
      lst_konda-low =  c_star.
    ELSE.
      lst_konda-option = c_option_eq.
      lst_konda-low = lst_split-price_grp.
    ENDIF.

    APPEND lst_konda TO lir_konda.
    CLEAR: lst_konda.
*      Ship To Code Range
    lst_ship_to-sign = c_sign.
    IF lst_split-ship_to_code EQ space.
      lst_ship_to-option = c_option_cp.
      lst_ship_to-low = c_star.
    ELSE.
      lst_ship_to-option = c_option_eq.
      lst_ship_to-low = lst_split-ship_to_code.
    ENDIF.

    APPEND lst_ship_to TO lir_ship_to.
    CLEAR: lst_ship_to.

*      Society Range
    lst_society-sign = c_sign.
    IF lst_split-society_grp_code EQ space.
      lst_society-option = c_option_cp.
      lst_society-low = c_star.
    ELSE.
      lst_society-option = c_option_eq.
      lst_society-low = lst_split-society_grp_code.
    ENDIF.

    APPEND lst_society TO lir_society.
    CLEAR: lst_ship_to.
*      Reason Code range
    lst_augru-sign = c_sign.
    IF lst_split-reason_code EQ space.
      lst_augru-option = c_option_cp.
      lst_augru-low = c_star.
    ELSE.
      lst_augru-option = c_option_eq.
      lst_augru-low = lst_split-reason_code.
    ENDIF.

    APPEND lst_augru TO lir_augru.
    CLEAR: lst_augru.

*      Subscription Class
    lst_auart-sign = c_sign.
    IF lst_split-subscription_cls EQ space.
      lst_auart-option = c_option_cp.
      lst_auart-low = c_star.
    ELSE.
      lst_auart-option = c_option_eq.
      lst_auart-low = lst_split-subscription_cls.
    ENDIF.

    APPEND lst_auart TO lir_auart.
    CLEAR: lst_auart.

* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
* To build Sales Organization data.
    lst_salesorg-sign = c_sign.
    IF lst_split-sales_org EQ space.
      lst_salesorg-option = c_option_cp.
      lst_salesorg-low    = c_star.
    ELSE.
      lst_salesorg-option = c_option_eq.
      lst_salesorg-low    = lst_split-sales_org.
    ENDIF.

    APPEND lst_salesorg TO lir_salesorg.
    CLEAR: lst_salesorg.

* To build Condition Group2 data.
    lst_condgrp2-sign = c_sign.
    IF lst_split-condition_grp2 EQ space.
      lst_condgrp2-option = c_option_cp.
      lst_condgrp2-low    = c_star.
    ELSE.
      lst_condgrp2-option = c_option_eq.
      lst_condgrp2-low    = lst_split-condition_grp2.
    ENDIF.

    APPEND lst_condgrp2 TO lir_condgrp2.
    CLEAR: lst_condgrp2.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018

*  Assigning the entries of main internal table to temporaray local table
    DATA(li_back_label_tmp) = fp_li_back_label[].
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*    SORT li_back_label_tmp BY matnr land1 ismrefmdprod augru auart society konda.
    SORT li_back_label_tmp BY matnr land1 ismrefmdprod augru auart vkorg kdkg2 society konda.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
    DELETE li_back_label_tmp WHERE matnr NOT IN lir_media_issue
                                OR country NOT IN lir_ship_to
                                OR mdprod NOT IN lir_mdprd
                                OR augru NOT IN lir_augru
                                OR auart NOT IN lir_auart
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                OR vkorg NOT IN lir_salesorg
                                OR kdkg2 NOT IN lir_condgrp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                OR society NOT IN lir_society
                                OR konda NOT IN lir_konda.

    DELETE fp_li_back_label WHERE matnr IN lir_media_issue
                                  AND country IN lir_ship_to
                                  AND mdprod IN lir_mdprd
                                  AND augru IN lir_augru
                                  AND auart IN lir_auart
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                  AND vkorg IN lir_salesorg
                                  AND kdkg2 IN lir_condgrp2
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
                                  AND society IN lir_society
                                  AND konda IN lir_konda.
    CLEAR lst_back_label.
    READ TABLE li_back_label_tmp INTO lst_back_label INDEX 1.
    IF sy-subrc EQ 0.
      lst_back_label-varname = lst_split-varname.
      MODIFY li_back_label_tmp FROM lst_back_label TRANSPORTING varname WHERE varname IS INITIAL.
      APPEND LINES OF li_back_label_tmp TO li_backlbl_split.
    ENDIF.
    REFRESH: li_back_label_tmp.
  ENDLOOP.
  MOVE-CORRESPONDING li_backlbl_split[] TO li_label_split[].
  SORT li_label_split BY vstel varname.

* BOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
  IF cb_lbl = 'X'.
* Logic for Back Label File Generation
    PERFORM f_get_file_bl USING li_label_split
                                fp_li_split
                                fp_li_back_label
                                lv_process.
  ELSE.
* Logic for Back Label ALV Data
    PERFORM f_get_alv_bl USING li_label_split
                               fp_li_split
                               fp_li_back_label.
  ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ERROR_RECORD
*&---------------------------------------------------------------------*
*       Get error file record
*----------------------------------------------------------------------*
FORM f_get_error_record .
* Local constant Declaration
  CONSTANTS : lc_param2_in TYPE rvari_vnam VALUE 'in'. " ABAP: Name of Variant Variable

*  Local Variable Declaration
  DATA : lv_fname     TYPE string,
         lv_filename  TYPE string,
         lst_heading1 TYPE string,
         lv_err_fpath TYPE string.

*  IF p_file IS NOT INITIAL.
*    lv_err_fpath = p_file.
*  ELSE. " ELSE -> IF p_file IS NOT INITIAL
*    CONCATENATE v_fpath_df c_slash lc_param2_in INTO lv_err_fpath.
*  ENDIF. " IF p_file IS NOT INITIAL
*
*  CLEAR : lv_fname, lv_filename.
** Populate File Name
**  No valid records found for File!
*  MESSAGE e098(zqtc_r2) INTO lv_filename. " No valid records found for File!

* Populate File path
*  CONCATENATE lv_err_fpath c_slash text-f03 c_dot c_csv INTO lv_fname.
* MM01 - Requirement - CSV File not needed, TXT file needed.
*  CONCATENATE lv_err_fpath c_slash text-f03 c_dot c_txt INTO lv_fname.

****Application server open to create file
*  OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
*  IF sy-subrc = 0.
* Populate heading for first line
* MM01 - Requirement - No Header needed.
*    CONCATENATE 'Job ID'(h01) c_comma 'Product Type'(h02) c_comma 'End Use Customer'(h03) c_comma
*         'Subscription Reference'(h04) c_comma 'Free Issue Reference'(h05) c_comma 'Claim Reference'(h06) c_comma
*         'Sample Copy Reference'(h07) c_comma 'PO Reference'(h08) c_comma'Shipping Reference'(h09) c_comma
*         'Canadian GST Number'(h10) c_comma 'Quantity'(h11) c_comma 'Issue Description'(h12) c_comma 'Acronym'(h13) c_comma
*         'Volume'(h14) c_comma 'Issue'(h15) c_comma 'Part'(h16) c_comma 'Supplement'(h17) c_comma 'Address Line 1'(h18) c_comma
*         'Address Line 2'(h19) c_comma 'Address Line 3'(h20) c_comma 'Address Line 4'(h21) c_comma 'Address Line 5'(h22) c_comma
*         'State'(h23) c_comma 'Country Name'(h24) c_comma 'Postcode'(h25) c_comma 'Country Code'(h26) c_comma
*         'Ship to Customer'(h27) c_comma 'Consolidation Type'(h28) c_comma 'Unique Issue Number'(h29) c_comma
*         'Type'(h30) c_comma 'Priority'(h31) c_comma 'Sent Date'(h32) c_comma 'Offline Society Name'(h33) c_comma
*         'Telephone Number'(h34) c_comma 'Journal Title'(h35) c_comma 'Pub Set'(h36) INTO lst_heading1.
*
* " Record's heading are moving to application server
*    TRANSFER: lst_heading1 TO lv_fname.

*  ENDIF. " IF sy-subrc = 0
*  CLOSE DATASET lv_fname.

*  IF sy-subrc EQ 0.
*  File processed to Application server successfully!
  MESSAGE i123(zqtc_r2) DISPLAY LIKE c_success. " No Records found for the given input parameters
  LEAVE LIST-PROCESSING.
*  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_PATH
*&---------------------------------------------------------------------*
*       Get F4 help in file path
*----------------------------------------------------------------------*
*      -->P_P_FILE  File Path
*----------------------------------------------------------------------*
FORM f_f4_file_path  USING  fp_p_file TYPE rlgrap-filename. " Local file for upload/download

* BOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
*    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
*      IMPORTING
*        serverfile       = fp_p_file
*      EXCEPTIONS
*        canceled_by_user = 1
*        OTHERS           = 2.
*
  DATA: lv_file      TYPE rlgrap-filename, " Local file for upload/download
        lt_dynpread  TYPE TABLE OF dynpread,
        lst_dynpread TYPE dynpread.

*** Calling FM for F4 help
  lst_dynpread-fieldname =  'P_FILE'.
  APPEND lst_dynpread TO lt_dynpread.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynpread
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc NE 0.
* Implement suitable error handling here
*   Error Message
    MESSAGE ID sy-msgid  "Message Class
          TYPE c_info    "Message Type: Information
        NUMBER sy-msgno  "Message Number
          WITH sy-msgv1  "Message Variable-1
               sy-msgv2  "Message Variable-2
               sy-msgv3  "Message Variable-3
               sy-msgv4. "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF.

  READ TABLE lt_dynpread INTO lst_dynpread WITH KEY fieldname = 'P_FILE'.
  IF sy-subrc EQ 0.
    lv_file = lst_dynpread-fieldvalue.
  ENDIF.
  IF lv_file IS INITIAL.
    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
      IMPORTING
        serverfile       = fp_p_file
      EXCEPTIONS
        canceled_by_user = 1
        OTHERS           = 2.
    IF sy-subrc NE 0.
*   Error Message
      MESSAGE ID sy-msgid  "Message Class
            TYPE c_info    "Message Type: Information
          NUMBER sy-msgno  "Message Number
            WITH sy-msgv1  "Message Variable-1
                 sy-msgv2  "Message Variable-2
                 sy-msgv3  "Message Variable-3
                 sy-msgv4. "Message Variable-4
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
      EXPORTING
        directory        = lv_file
*       FILEMASK         = ' '
      IMPORTING
        serverfile       = fp_p_file
      EXCEPTIONS
        canceled_by_user = 1
        OTHERS           = 2.
    IF sy-subrc NE 0.
*   Error Message
      MESSAGE ID sy-msgid  "Message Class
            TYPE c_info    "Message Type: Information
          NUMBER sy-msgno  "Message Number
            WITH sy-msgv1  "Message Variable-1
                 sy-msgv2  "Message Variable-2
                 sy-msgv3  "Message Variable-3
                 sy-msgv4. "Message Variable-4
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
* EOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
  IF sy-subrc NE 0.
*   Error Message
    MESSAGE ID sy-msgid  "Message Class
          TYPE c_info    "Message Type: Information
        NUMBER sy-msgno  "Message Number
          WITH sy-msgv1  "Message Variable-1
               sy-msgv2  "Message Variable-2
               sy-msgv3  "Message Variable-3
               sy-msgv4. "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INPUT_DATA
*&---------------------------------------------------------------------*
*       Get input Data
*----------------------------------------------------------------------*
*      -->P_P_FILE  File path
*----------------------------------------------------------------------*
FORM f_input_data  USING  fp_p_file  TYPE rlgrap-filename. " Local file for upload/download

  IF fp_p_file IS INITIAL.
    READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_param1_file
                                                           BINARY SEARCH.

** Get file path from constant table for file Input
*    SELECT low         " Lower Value of Selection Condition
*      FROM zcaconstant " Wiley Application Constant Table
*      INTO @DATA(lv_fpath)
*      WHERE devid  = @c_devid
*        AND param1 = @c_param1_file
*        AND activate = @abap_true.
*    ENDSELECT.
* Populate File path
    IF sy-subrc EQ 0.
      v_fpath_df = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0
* Populate File path
  ENDIF. " IF fp_p_file IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RUN_DATE
*&---------------------------------------------------------------------*
*      Modify the table with updated date
*----------------------------------------------------------------------*
FORM f_update_run_date .
* Local constant Declaration
  CONSTANTS: lc_param2 TYPE rvari_vnam VALUE '001'. " ABAP: Name of Variant Variable

* Local Data Declaration
  DATA : lst_interface TYPE zcainterface. " Interface run details

  SELECT param1,
         lrdat,                   "Last run date
         lrtime                   "Last Run time
       FROM zcainterface          " Interface run details
       INTO TABLE @DATA(li_zcainterface)
       WHERE devid  = @c_devid
         AND param2 = @lc_param2. "'001'.

  IF sy-subrc = 0.
    SORT li_zcainterface BY lrdat DESCENDING lrtime DESCENDING.
  ELSE. " ELSE -> IF sy-subrc = 0
*  Please maintain table ZCAINTERFACE.
    MESSAGE i104(zqtc_r2) DISPLAY LIKE c_error. " Please maintain table ZCAINTERFACE.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc = 0

  READ TABLE li_zcainterface ASSIGNING FIELD-SYMBOL(<lst_zcainterface>) INDEX 1.
  IF sy-subrc = 0.
* Update the table ZCAINTERFACE with last run date & time
* Lock the Table entry
    CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
      EXPORTING
        mode_zcainterface = abap_true                 "Lock mode
        mandt             = sy-mandt                  "01th enqueue argument (Client)
        devid             = c_devid                   "02th enqueue argument (Development ID)
        param1            = <lst_zcainterface>-param1 "03th enqueue argument (ABAP: Name of Variant Variable)
        param2            = lc_param2                 "04th enqueue argument (ABAP: Name of Variant Variable)
      EXCEPTIONS
        foreign_lock      = 1
        system_failure    = 2
        OTHERS            = 3.

    IF sy-subrc EQ 0.
      lst_interface-mandt  = sy-mandt. "Client
      lst_interface-devid  = c_devid. "Development ID
      lst_interface-param1 = sy-datum+0(4). "ABAP: Name of Variant Variable
      lst_interface-param2 = lc_param2. "ABAP: Name of Variant Variable
      lst_interface-lrdat  = sy-datum. "Last run date
      lst_interface-lrtime = sy-uzeit. "Last run time

* Modify (Insert / Update) the Table entry
      MODIFY zcainterface FROM lst_interface.

* Unlock the Table entry
      CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
    ELSE. " ELSE -> IF sy-subrc EQ 0
*   Error Message
      MESSAGE ID sy-msgid  "Message Class
            TYPE c_info    "Message Type: Information
          NUMBER sy-msgno  "Message Number
            WITH sy-msgv1  "Message Variable-1
                 sy-msgv2  "Message Variable-2
                 sy-msgv3  "Message Variable-3
                 sy-msgv4. "Message Variable-4
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       Send EMAIL
*----------------------------------------------------------------------*
FORM f_send_email USING fp_lv_string    TYPE string
                        fp_lv_email     TYPE ad_smtpadr
                        fp_lv_filename  TYPE sood-objdes
                        fp_email_str    TYPE tt_email_str.

  DATA: lv_email       TYPE adr6-smtp_addr,
        lv_data_string TYPE string.

  DATA: li_binary_email   TYPE solix_tab.  "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
  CONSTANTS:lc_txt TYPE char3 VALUE 'TXT'.

*Email id
  lv_email = fp_lv_email.
*  String
  lv_data_string = fp_lv_string.

*Prepare Mail Object
  DATA:  lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL.
  CLASS cl_bcs DEFINITION LOAD.

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Message body and subject
  DATA: lr_document TYPE REF TO cl_document_bcs VALUE IS INITIAL. "document object

  TRY.
*Create Email document
      lr_document = cl_document_bcs=>create_document( "create document
      i_type = 'TXT' "Type of document HTM, TXT etc
      i_subject = 'JFDS File'(001) ). "email subject here p_sub input parameter
*Exception handling not required
    CATCH cx_document_bcs.
*Exception handling not required
    CATCH cx_send_req_bcs.
  ENDTRY.

  TRY.
* Pass the document to send request
      lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs.
  ENDTRY.

  DATA lv_xstring TYPE xstring .

  LOOP AT fp_email_str INTO DATA(lst_email_str). "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
    lv_data_string = lst_email_str-email_body.   "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
* BOC - ERP-7404 - GKINTALI -  ED2K911953 - 05.01.2018
* Adding line feed to all the lines except the first record to avoid multiple lines
* being populated in a single line in the tect attachment
    IF sy-tabix <> 1.
      CONCATENATE cl_abap_char_utilities=>cr_lf lv_data_string INTO lv_data_string.
    ENDIF.
* EOC - ERP-7404 - GKINTALI -  ED2K911953 - 05.01.2018
**Convert string to xstring
    CLEAR lv_xstring.
    CALL FUNCTION 'HR_KR_STRING_TO_XSTRING'
      EXPORTING
*       codepage_to      = '8300'
        unicode_string   = lv_data_string
*       OUT_LEN          =
      IMPORTING
        xstring_stream   = lv_xstring
      EXCEPTIONS
        invalid_codepage = 1
        invalid_string   = 2
        OTHERS           = 3.
    IF sy-subrc <> 0.
*      RAISE exception.  -<HIPATEL> <ED1K907523> <05/26/2018>
*BOC <HIPATEL> <> <ED1K907523> <05/26/2018>
*To avoid Special charactor Dump - Implemented
*below FM with CodePage value to avoid Exceptions
**Convert string to xstring
      CLEAR lv_xstring.
      CALL FUNCTION 'HR_KR_STRING_TO_XSTRING'
        EXPORTING
          codepage_to      = '8300'
          unicode_string   = lv_data_string
*         OUT_LEN          =
        IMPORTING
          xstring_stream   = lv_xstring
        EXCEPTIONS
          invalid_codepage = 1
          invalid_string   = 2
          OTHERS           = 3.
*EOC <HIPATEL> <> <ED1K907523> <05/26/2018>
    ENDIF.

    DATA: li_binary_content TYPE solix_tab,
          lx_document_bcs   TYPE REF TO cx_document_bcs VALUE IS INITIAL.
***Xstring to binary
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = lv_xstring
      TABLES
        binary_tab = li_binary_content.

    APPEND LINES OF li_binary_content TO li_binary_email. "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
  ENDLOOP.                                              "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

  DATA  lv_attsubject   TYPE sood-objdes.
**add attachment name
  CLEAR lv_attsubject .
  lv_attsubject = fp_lv_filename.
* Create Attachment
  TRY.
      lr_document->add_attachment( EXPORTING
                                      i_attachment_type = lc_txt
                                      i_attachment_subject = lv_attsubject
                                      i_att_content_hex = li_binary_email ).  "li_binary_content  ). "+HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

*Set Sender
  DATA: lr_sender  TYPE REF TO if_sender_bcs VALUE IS INITIAL.

  TRY.
      lr_sender = cl_sapuser_bcs=>create( sy-uname ). "sender is the logged in user
* Set sender to send request
      lr_send_request->set_sender(
      EXPORTING
      i_sender = lr_sender ).
    CATCH cx_address_bcs.
    CATCH cx_send_req_bcs.
****Catch exception here
  ENDTRY.

**Set recipient
  DATA: lr_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL.

  TRY.
      lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ). "Here Recipient is email input p_email

      lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
    CATCH cx_address_bcs.
*Exception handling not required
    CATCH cx_send_req_bcs.
*Exception handling not required
  ENDTRY.

*Set immediate sending
  TRY.
      CALL METHOD lr_send_request->set_send_immediately
        EXPORTING
          i_send_immediately = abap_true.
**Catch exception here
    CATCH cx_send_req_bcs.
  ENDTRY.

  TRY.
** Send email
      lr_send_request->send(
      EXPORTING
      i_with_error_screen = abap_true ).
      MESSAGE s000(zqtc_r2) WITH text-002.
    CATCH cx_send_req_bcs.
*catch exception here
  ENDTRY.
  COMMIT WORK.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       Display Output
*----------------------------------------------------------------------*
FORM f_display_output .
*  Build Fieldcatalog
  PERFORM f_build_fieldcatalog.

*  Display ALV
  PERFORM f_display_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       Build Fieldcatalog
*----------------------------------------------------------------------*
FORM f_build_fieldcatalog .
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lv_col_pos       TYPE i.

*  Populate fieldcatalog
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'JOBID'.
  lst_fieldcatalog-seltext_m   = 'Job ID'(h01).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ZPRODTYPE'.
  lst_fieldcatalog-seltext_m   = 'Product Type'(h02).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'CUST'.
  lst_fieldcatalog-seltext_m   = 'End Use Customer'(h03).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*Populate Subscription Number
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SUBSCRNO'.
  lst_fieldcatalog-seltext_m   = 'Subscription Number'(h44).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'VBELN'.
  lst_fieldcatalog-seltext_m   = 'Subscription Reference'(h04).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'AUART1'.
  lst_fieldcatalog-seltext_m   = 'Free Issue Reference'(h05).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'AUART2'.
  lst_fieldcatalog-seltext_m   = 'Claim Reference'(h06).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'AUART3'.
  lst_fieldcatalog-seltext_m   = 'Sample Copy Reference'(h07).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'BSTKD'.
  lst_fieldcatalog-seltext_m   = 'PO Reference'(h08).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SHIPPING_REF'.
  lst_fieldcatalog-seltext_m   = 'Shipping Reference'(h09).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'STCD1'.
  lst_fieldcatalog-seltext_m   = 'Canadian GST Number'(h10).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'MENGE'.
  lst_fieldcatalog-seltext_m   = 'Quantity'(h11).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ISSUE_DESC'.
  lst_fieldcatalog-seltext_m   = 'Issue Description'(h12).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'IDENTCODE'.
  lst_fieldcatalog-seltext_m   = 'Identification Code'(h38).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ISMCOPYNR'.
  lst_fieldcatalog-seltext_m   = 'Copy Number'(h40).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ISMNRINYEAR'.
  lst_fieldcatalog-seltext_m   = 'Issue'(h15).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PART'.
  lst_fieldcatalog-seltext_m   = 'Part'(h16).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SUPPLEMENT'.
  lst_fieldcatalog-seltext_m   = 'Supplement'(h17).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'NAME1'.
  lst_fieldcatalog-seltext_m   = 'Address Line 1'(h18).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'NAME2'.
  lst_fieldcatalog-seltext_m   = 'Address Line 2'(h19).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'STRAS'.
  lst_fieldcatalog-seltext_m   = 'Address Line 3'(h20).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ORT02'.
  lst_fieldcatalog-seltext_m   = 'Address Line 4'(h21).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ORT01'.
  lst_fieldcatalog-seltext_m   = 'Address Line 5'(h22).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'REGIO'.
  lst_fieldcatalog-seltext_m   = 'State'(h23).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
  lv_col_pos = lv_col_pos + 1.
*  lst_fieldcatalog-fieldname   = 'LANDX'.
  lst_fieldcatalog-fieldname   = 'LANDX50'.   " Country Name (Max. 50 Characters)
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
  lst_fieldcatalog-seltext_m   = 'Country Name'(h24).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PSTLZ'.
  lst_fieldcatalog-seltext_m   = 'Postcode'(h25).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'LAND1'.
  lst_fieldcatalog-seltext_m   = 'Country Code'(h26).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SHIP_TO_CUST'.
  lst_fieldcatalog-seltext_m   = 'Ship to Customer'(h27).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ZCONTYP'.
  lst_fieldcatalog-seltext_m   = 'Consolidation Type'(h28).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'MATNR'.
  lst_fieldcatalog-seltext_l   = 'Material Number'(h37).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'TYPE'.
  lst_fieldcatalog-seltext_m   = 'Type'(h30).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PRIORITY'.
  lst_fieldcatalog-seltext_m   = 'Priority'(h31).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'DATE'.
  lst_fieldcatalog-seltext_m   = 'Sent Date'(h32).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SOCIETY_NAME'.
  lst_fieldcatalog-seltext_m   = 'Offline Society Name'(h33).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'TELF1'.
  lst_fieldcatalog-seltext_m   = 'Telephone Number'(h34).
  lst_fieldcatalog-col_pos     = lv_col_pos.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
  lst_fieldcatalog-no_out      = abap_true.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'TEL_NUMBER'.
  lst_fieldcatalog-seltext_m   = 'Telephone Number'(h34).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ISMTITLE'.
  lst_fieldcatalog-seltext_m   = 'Journal Title'(h35).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'ISMYEARNR'.
  lst_fieldcatalog-seltext_m   = 'Pub Set'(h36).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'SALES_ORG'.
  lst_fieldcatalog-seltext_m   = 'Sales Organization'(h43).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'PRICE_LIST'.
  lst_fieldcatalog-seltext_m   = 'Price List Type'(h41).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lv_col_pos = lv_col_pos + 1.
  lst_fieldcatalog-fieldname   = 'FILENAME'.
  lst_fieldcatalog-seltext_m   = 'File Name'(h42).
  lst_fieldcatalog-col_pos     = lv_col_pos.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 16.04.2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV
*----------------------------------------------------------------------*
FORM f_display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = i_fieldcatalog[]
      i_save             = abap_true
    TABLES
      t_outtab           = i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_fieldcatalog[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_MANDATORY_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*       -->P_<LST_MAIN_LABEL>  text
*       -->P_<LST_BACK_LABEL>  text
*      -->P_<LST_DELIVERY>_VBELN  text
*      -->P_<LST_DELIVERY>_POSNR  text
*----------------------------------------------------------------------*
FORM validate_mandatory_fields_ml  USING fp_lst_main_label   TYPE ty_label
                                         fp_ref_doc_no       TYPE ebeln
                                         fp_ref_item_no      TYPE ebelp.
  DATA: lv_item_no_c   TYPE char6,
        lst_err_log    TYPE ty_err_log,
        lst_label_data TYPE ty_label.

* Move corresponding is used to avoid unnecessary code lines. Here two structures has
* different order of fields.
  IF fp_lst_main_label IS NOT INITIAL.
*    MOVE-CORRESPONDING fp_lst_main_label TO lst_label_data.
    lst_label_data = fp_lst_main_label.
  ENDIF.

  lv_item_no_c = fp_ref_item_no.
  IF lst_label_data-zprodtype IS INITIAL.
    CONCATENATE 'Product type is blank - refer'(t01) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.
  IF lst_label_data-cust IS INITIAL OR lst_label_data-ship_to_cust IS INITIAL.
    CONCATENATE ' Freight Forwarder or Ship to Party is blank - refer'(t02)
                           fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-vbeln IS INITIAL AND  lst_label_data-auart1 IS INITIAL AND
     lst_label_data-auart2 IS INITIAL AND  lst_label_data-auart3 IS INITIAL.
    CONCATENATE 'Reference Document is blank - refer'(t04) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-ismcopynr IS INITIAL.
    CONCATENATE 'Volume number is blank - refer material in'(t05) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.


  IF lst_label_data-supplement IS INITIAL AND lst_label_data-ismnrinyear IS INITIAL.
    CONCATENATE 'Supplement or Issue number is blank - refer material in'(t11) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-land1 IS INITIAL.
    CONCATENATE 'Country Code is blank - refer ship to party in'(t06) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_MANDATORY_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*       -->P_<LST_MAIN_LABEL>  text
*       -->P_<LST_BACK_LABEL>  text
*      -->P_<LST_DELIVERY>_VBELN  text
*      -->P_<LST_DELIVERY>_POSNR  text
*----------------------------------------------------------------------*
FORM validate_mandatory_fields_bl  USING fp_lst_back_label   TYPE ty_back_label
                                         fp_ref_doc_no       TYPE vbeln
                                         fp_ref_item_no      TYPE posnr.
  DATA: lv_item_no_c   TYPE char6,
        lst_err_log    TYPE ty_err_log,
        lst_label_data TYPE ty_back_label.

* Move corresponding is used to avoid unnecessary code lines. Here two structures has
* different order of fields.

  IF fp_lst_back_label IS NOT INITIAL.
    lst_label_data = fp_lst_back_label.
  ENDIF.

  lv_item_no_c = fp_ref_item_no.

  IF lst_label_data-zprodtype IS INITIAL.
    CONCATENATE 'Product type is blank - refer'(t01) fp_ref_doc_no lv_item_no_c
                                          INTO lst_err_log-msg SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-cust IS INITIAL OR lst_label_data-ship_to_cust IS INITIAL.
    CONCATENATE ' Freight Forwarder or Ship to Party is blank - refer'(t02)
                           fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-vbeln IS INITIAL AND  lst_label_data-auart1 IS INITIAL AND
     lst_label_data-auart2 IS INITIAL AND  lst_label_data-auart3 IS INITIAL.
    CONCATENATE 'Reference Document is blank - refer'(t04) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.


  IF lst_label_data-ismcopynr IS INITIAL.
    CONCATENATE 'Volume number is blank - refer material in'(t05) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-supplement IS INITIAL AND lst_label_data-ismnrinyear IS INITIAL.
    CONCATENATE 'Supplement or Issue number is blank - refer material in'(t11) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

  IF lst_label_data-land1 IS INITIAL.
    CONCATENATE 'Country Code is blank - refer ship to party in'(t06) fp_ref_doc_no lv_item_no_c INTO lst_err_log-msg
                                                     SEPARATED BY space.
    APPEND lst_err_log TO li_err_log.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_APP_SERVER_DATA
*&---------------------------------------------------------------------*
*       Get file from application server
*----------------------------------------------------------------------*
FORM f_get_app_server_data .
  DATA: lv_file       TYPE string,
        lst_file      TYPE string,
        lv_fname_comp TYPE chkfile,
        lv_fname      TYPE sdba_actid,
        lv_menge      TYPE char17,    "Quantity "++<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
        lst_label     TYPE ty_output.

  lv_file = p_file.

  IF lv_file IS NOT INITIAL.
    TRY.
*  Open dataset
        OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
        IF sy-subrc EQ 0.
          DO.
            CLEAR lst_file.
*  Read Dataset
            READ DATASET lv_file INTO lst_file.
            IF sy-subrc NE 0.
              EXIT.
            ELSE. " ELSE -> IF sy-subrc NE 0
              CLEAR lst_label.
              SHIFT lst_file BY 1 PLACES LEFT.
              SPLIT lst_file AT '","' INTO
                                lst_label-jobid
                                lst_label-zprodtype
                                lst_label-cust
                                lst_label-vbeln
                                lst_label-auart1
                                lst_label-auart2
                                lst_label-auart3
                                lst_label-bstkd
                                lst_label-shipping_ref
                                lst_label-stcd1
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*                                lst_label-menge
                                lv_menge
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
                                lst_label-issue_desc
                                lst_label-identcode
                                lst_label-ismcopynr
                                lst_label-ismnrinyear
                                lst_label-part
                                lst_label-supplement
                                lst_label-name1
                                lst_label-name2
                                lst_label-stras
                                lst_label-ort02
                                lst_label-ort01
                                lst_label-regio
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*                                lst_label-landx
                                lst_label-landx50
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
                                lst_label-pstlz
                                lst_label-land1
                                lst_label-ship_to_cust
                                lst_label-zcontyp
                                lst_label-matnr
                                lst_label-type
                                lst_label-priority
                                lst_label-date
                                lst_label-society_name
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*                                lst_label-telf1
                                lst_label-tel_number
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
                                lst_label-ismtitle
                                lst_label-ismyearnr.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
              MOVE lv_menge TO lst_label-menge.
              CLEAR lv_menge.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
              APPEND lst_label TO i_output.
              CLEAR  lst_label.
            ENDIF.
          ENDDO.
          CLOSE DATASET lv_file.
* BOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
        ELSE.
          MESSAGE e196(zqtc_r2) WITH ',ensure file is selected using F4'(005).
* EOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
        ENDIF. " IF sy-subrc NE 0
      CATCH cx_sy_file_open.
      CATCH cx_root.
    ENDTRY.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       To get ZCACONSTANAT data
*----------------------------------------------------------------------*
FORM f_get_constant  CHANGING fp_i_constant TYPE tt_constant..
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = c_devid
    AND   activate = abap_true.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE
*&---------------------------------------------------------------------*
*       Validate file path
*----------------------------------------------------------------------*
FORM f_validate_file  USING  fp_p_file TYPE localfile.
*  Local type declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE salv_de_selopt_low,
           high   TYPE salv_de_selopt_high,
         END OF lty_range.

*  Local data declaration
  DATA: lv_file       TYPE char200,
        lv_rstring    TYPE char100,
        lv_name       TYPE char100,
        lv_path       TYPE localfile,
        lst_range     TYPE lty_range,
* BOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
        lv_extn       TYPE sdba_funct,
        lv_fname_comp TYPE chkfile,
        lv_fname      TYPE sdba_actid,
* EOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
        lir_file_path TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0.

  IF fp_p_file IS NOT INITIAL.
    LOOP AT i_constant INTO DATA(lst_constant) WHERE param1 = c_file_path.
      lst_range-sign = lst_constant-sign.
      lst_range-option = lst_constant-opti.
      lst_range-low = lst_constant-low.
      lst_range-high = lst_constant-high.
      APPEND lst_range TO lir_file_path.
      CLEAR lst_range.
    ENDLOOP.
* BOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
    lv_fname_comp = fp_p_file.
    CALL FUNCTION 'SPLIT_FILENAME'
      EXPORTING
        long_filename  = lv_fname_comp
      IMPORTING
        pure_filename  = lv_fname
        pure_extension = lv_extn.
    IF lv_fname IS INITIAL OR lv_extn IS INITIAL.
      " File name can't be blank, ensure file is selected using F4
      MESSAGE e000(zqtc_r2) WITH 'File name is either blank or no file extension,'(003) space
                                  'ensure file is selected using F4'(004) space.
    ENDIF.
* EOI by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
* BOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
*    CALL FUNCTION 'STRING_REVERSE'
*      EXPORTING
*        string    = lv_file
*        lang      = sy-langu
*      IMPORTING
*        rstring   = lv_rstring
*      EXCEPTIONS
*        too_small = 1
*        OTHERS    = 2.
*
*    IF sy-subrc = 0.
*      SPLIT lv_rstring AT '/' INTO lv_name lv_path.
*
*      CLEAR lv_rstring.
*      CALL FUNCTION 'STRING_REVERSE'
*        EXPORTING
*          string    = lv_path
*          lang      = sy-langu
*        IMPORTING
*          rstring   = lv_rstring
*        EXCEPTIONS
*          too_small = 1
*          OTHERS    = 2.
*      IF sy-subrc EQ 0.
*        IF lv_rstring NOT IN lir_file_path.
*          MESSAGE e198(zqtc_r2).
*        ENDIF.
*      ENDIF.
*    ENDIF.
* EOC by PBANDLAPAL on 09-Feb-2018 for ERP-6478: ED2K910783
  ELSE.
    MESSAGE e206(zqtc_r2). "File Path cannot be blank
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG_FOR_MANDATE_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM error_log_for_mandate_fields .

  CONSTANTS: lc_err  TYPE char3 VALUE 'err'.

  DATA: lv_fname     TYPE string,
        lv_err_fpath TYPE string,
        lst_err_log  TYPE ty_err_log.

  READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_param1_file
                                                             BINARY SEARCH.
* Populate File path
  IF sy-subrc EQ 0.
    v_fpath_df = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  IF v_fpath_df IS NOT INITIAL.
    CONCATENATE v_fpath_df c_slash lc_err INTO lv_err_fpath.

    CONCATENATE lv_err_fpath c_slash sy-datum c_file_undsc sy-uzeit c_dot c_txt INTO lv_fname.

***Application server open to create file
    OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc = 0.
      LOOP AT li_err_log INTO lst_err_log.
        TRANSFER lst_err_log-msg TO lv_fname.
      ENDLOOP.
    ENDIF.

    CLOSE DATASET lv_fname.
  ELSE.
    MESSAGE i198(zqtc_r2) DISPLAY LIKE c_error.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE_PRES_SERVER
*&---------------------------------------------------------------------*
*       Save file in presentation server
*----------------------------------------------------------------------*
FORM f_save_file_pres_server .
*  Local data declaration
  DATA: li_output(4096) TYPE c OCCURS 0,
        lv_path         TYPE string.

  lv_path = p_dwnld.
  CALL FUNCTION 'SAP_CONVERT_TO_TEX_FORMAT'
    EXPORTING
      i_field_seperator    = ','
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = i_output
    CHANGING
      i_tab_converted_data = li_output
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = lv_path
      TABLES
        data_tab = li_output
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc NE 0.
      MESSAGE i191(zqtc_r2).
    ELSE.
      MESSAGE i192(zqtc_r2).
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRES_PATH
*&---------------------------------------------------------------------*
*       F4 help for presentation server file path
*----------------------------------------------------------------------*
FORM f_f4_pres_path  USING fp_p_dwnld TYPE localfile.
* To get the file from presentation server when radio button Presentation
* Server is selected
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = syst-cprog
      field_name   = c_field_dwn
    IMPORTING
      file_name    = fp_p_dwnld.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_ML
*&---------------------------------------------------------------------*
*       To generate files for ML
*----------------------------------------------------------------------*
*      -->LI_MLABEL_SPLIT   text
*      -->FP_LI_SPLIT       text
*      -->FP_LI_MAIN_LABEL  text
*      -->LV_PROCESS        text
*----------------------------------------------------------------------*
FORM f_get_file_ml USING li_mlabel_split   TYPE tt_mlabel_var
                         fp_li_split       TYPE tt_split
                         fp_li_main_label  TYPE tt_main_label
                         lv_process        TYPE string
                         fp_li_split_var   TYPE tt_split_var. "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>

*  Local Data Declaration
  DATA : lst_main_label1 TYPE string,
         lst_main_label2 TYPE string.

*  Local Variable Declaration
  DATA : lv_fname        TYPE string,
         lv_count        TYPE i,      " Count of type Integers
         lv_filename     TYPE string,
         lv_filename1    TYPE sood-objdes,
*         lv_date         TYPE char10, " Date of type CHAR10 "-- GKINTALI:ERP-7404:02.05.2018:ED2K911985
         lv_date         TYPE char11, " Date of type CHAR11 "++ GKINTALI:ERP-7404:02.05.2018:ED2K911985
         lv_menge        TYPE char17, " Menge of type CHAR17
         lv_string       TYPE string,
         lv_email        TYPE ad_smtpadr,
         lv_fileopen_suc TYPE char1,  " Fileopen_suc of type CHAR1
         lv_lifnr        TYPE lifnr,  " Account Number of Vendor or Creditor
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
         lv_len          TYPE i,      " Length  ++<HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
         lv_fsplitnm     TYPE string. "File Naming convension
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>

  DATA: lst_mlbl_split    TYPE ty_mlabel_var,
        lst_mlabel_split  TYPE ty_mlabel_var,
        lst_mlabel_split1 TYPE string,
        lst_ship_to       TYPE ty_ship_to,
        lir_salesorg      TYPE tt_salesorg,
        lir_condgrp2      TYPE tt_condgrp2,
        lst_salesorg      TYPE ty_salesorg,
        lst_condgrp2      TYPE ty_condgrp2,
        lst_lblsm_tmp     TYPE ty_lblsm_tmp,
        lst_i0255_lblsm   TYPE ty_i0255_lblsm.

* BOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
  DATA: li_email_str  TYPE STANDARD TABLE OF ty_email_str,
        lst_email_str TYPE ty_email_str,
        lv_mon_name   TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7404:ED2K911985:02.05.2018
        lv_mon_no     TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7404:ED2K911985:02.05.2018
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
  IF rb_mat EQ abap_true.
    ASSIGN i_dyn_table1->* TO <i_dyn_table_split>.
*  ASSIGN i_dyn_table3->* to <i_dyn_table>.      "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ELSEIF rb_var EQ abap_true.
    ASSIGN i_dyn_table2->* TO <i_dyn_table_split>.
*  ASSIGN i_dyn_table4->* to <i_dyn_table>.      "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ENDIF.
  ASSIGN lst_main_lable TO <lst_main_label>.

  MOVE-CORRESPONDING li_mlabel_split[] TO <i_dyn_table_split>[].
*MOVE-CORRESPONDING fp_li_main_label[] to <i_dyn_table>[].     "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>


* Conditional based split file generation
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*  LOOP AT li_mlabel_split INTO lst_mlbl_split.
  LOOP AT <i_dyn_table_split> ASSIGNING FIELD-SYMBOL(<lst_table>).
    MOVE-CORRESPONDING <lst_table> TO lst_mlbl_split.
    CLEAR lst_mlabel_split.
    lst_mlabel_split = lst_mlbl_split.
*Split based on Selection screen condition
    IF rb_mat EQ abap_true.
      READ TABLE fp_li_split INTO DATA(lst_split_ml) WITH KEY labltp = c_type_ml
                                                              media_product  = lst_mlbl_split-mdprod "+<HIPATEL> <CHG0040278/RITM0078000>
                                                              varsplit = abap_true.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.
      v_field = c_matnr.    "Material Number
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
    ELSEIF rb_var EQ abap_true.
      READ TABLE fp_li_split INTO lst_split_ml WITH KEY varname = lst_mlbl_split-varname
                                                        media_product  = lst_mlbl_split-mdprod
                                                        varsplit = abap_true.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.
* BOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
      IF lst_split_ml-cntrl_circulation NE abap_true.
        v_field = c_matnr.    "Material Number
        ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
      ELSE.
* EOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
        v_field = c_varnm.    "Variant Name
        ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
* BOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
      ENDIF.
* EOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
    ENDIF.
*    AT NEW varname.
    AT NEW <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      CLEAR : lv_fname,
              lv_count,
              lv_lifnr,
              lv_filename,
              lst_mlabel_split1,
              li_email_str[],  "+ HIPATEL - ERP-7404 - ED2K911953
              lv_fsplitnm.     "+ <HIPATEL> <INC0200998> <ED1K907981>

* Populate file name
      lv_lifnr = lst_mlabel_split-lifnr.
      SHIFT lv_lifnr LEFT DELETING LEADING c_zero.
* BOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
*      CONCATENATE lv_lifnr lst_mlabel_split-type lst_mlabel_split-ismrefmdprod
*      lst_mlabel_split-ismcopynr c_file_undsc lst_mlabel_split-ismnrinyear lst_mlabel_split-supplement
*      c_file_undsc lst_mlabel_split-varname lst_mlabel_split-ismyearnr INTO lv_filename.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*      IF rb_mat eq abap_true.                  "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
      IF lst_mlabel_split-cntrl_var EQ space.   "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
        CONCATENATE c_file_undsc
                    lst_mlabel_split-matnr+0(4)    " Media Issue
                    c_file_undsc                   " Underscore
                    lst_mlabel_split-ismcopynr     " Volume
                    c_file_undsc                   " Underscore
                    lst_mlabel_split-ismnrinyear   " Issue
                    lst_mlabel_split-supplement    " Supplement
               INTO lv_fsplitnm.
*      ELSEIF rb_var eq abap_true.
      ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
* Additional underscores added as per the new requirement
      CONCATENATE lv_lifnr                       " Vendor Number
                  lst_mlabel_split-type          " ML
**                  c_file_undsc                   " Underscore   ++by GKINTALI
*                  lst_mlabel_split-ismrefmdprod  " Acronym      --<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
**                  lst_mlabel_split-matnr+0(4)    " Media Issue  ++<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018> "now
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
                  lv_fsplitnm
*                  c_file_undsc                   " Underscore   ++by GKINTALI
*                  lst_mlabel_split-ismcopynr     " Volume
*                  c_file_undsc                   " Underscore
*                  lst_mlabel_split-ismnrinyear   " Issue
*                  lst_mlabel_split-supplement    " Supplement
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
             INTO lv_filename.
      IF rb_var EQ abap_true.
        CONCATENATE lv_filename
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
                    c_file_undsc                   " Underscore
                    lst_mlabel_split-varname       " Variant Name
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
               INTO lv_filename.
      ENDIF.
      IF lst_mlabel_split-cntrl_var EQ space.
        CONCATENATE lv_filename
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
                    c_file_undsc                   " Underscore   ++by GKINTALI
                    lst_mlabel_split-ismyearnr     " Pub Set
               INTO lv_filename.
      ENDIF.      "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
* EOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
      CONCATENATE lv_process c_slash lv_filename c_dot c_txt INTO lv_fname.
      CONDENSE lv_fname.

*      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    ENDAT.

    CLEAR lst_mlabel_split1.
    lv_count = lv_count + 1. "Job ID
    lst_mlabel_split-jobid = lv_count. "Job ID
    lv_menge = lst_mlabel_split-menge. "Quantity changing from quan to char data type
    CONDENSE lv_menge.
    CONCATENATE lst_mlabel_split-docdate+6(2) c_hypen
                lst_mlabel_split-docdate+4(2) c_hypen
                lst_mlabel_split-docdate+0(4)
           INTO lv_date.
* BOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_mlabel_split-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_mlabel_split-docdate+6(2) c_hypen
                  lv_mon_name                   c_hypen
                  lst_mlabel_split-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018

*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*Subscription reference field length in file based on selection screen
    IF lst_mlabel_split-vbeln IS INITIAL.
      lst_mlabel_split-vbeln = lst_mlabel_split-subscrno.   "Subscription Number
    ENDIF.
    lv_len = strlen( lst_mlabel_split-vbeln ).
    IF NOT p_char IS INITIAL AND lv_len GE p_char.
      lv_len = lv_len - p_char.
      lst_mlabel_split-vbeln = lst_mlabel_split-vbeln+lv_len(p_char).
    ENDIF.

*Populate '0' in Free issue reference field, if Free issue ref /Claim refer/Sample ref is Blank
    IF lst_mlabel_split-auart1 IS INITIAL AND
       lst_mlabel_split-auart2 IS INITIAL AND
       lst_mlabel_split-auart3 IS INITIAL.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                             param2 = c_type_ml.
      IF sy-subrc = 0.
        lst_mlabel_split-auart1 = lst_constant-low.   "'0'.
      ENDIF.
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

* MM01 - Requirement - All the values should be displayed in quotes.
* Populate Main label File record
    CONCATENATE  c_quote lst_mlabel_split-jobid        c_quote c_comma
                 c_quote lst_mlabel_split-zprodtype    c_quote c_comma
                 c_quote lst_mlabel_split-cust         c_quote c_comma
                 c_quote lst_mlabel_split-vbeln        c_quote c_comma
                 c_quote lst_mlabel_split-auart1       c_quote c_comma
                 c_quote lst_mlabel_split-auart2       c_quote c_comma
                 c_quote lst_mlabel_split-auart3       c_quote c_comma
                 c_quote lst_mlabel_split-bstkd        c_quote c_comma
                 c_quote lst_mlabel_split-shipping_ref c_quote c_comma
                 c_quote lst_mlabel_split-stcd1        c_quote c_comma
                 c_quote lv_menge                      c_quote c_comma
                 c_quote lst_mlabel_split-issue_desc   c_quote c_comma
                 c_quote lst_mlabel_split-identcode    c_quote c_comma
*                 c_quote lst_mlabel_split-ismrefmdprod c_quote c_comma
                 c_quote lst_mlabel_split-ismcopynr    c_quote c_comma
                 c_quote lst_mlabel_split-ismnrinyear  c_quote c_comma
                 c_quote lst_mlabel_split-part         c_quote c_comma
                 c_quote lst_mlabel_split-supplement   c_quote c_comma
                 c_quote lst_mlabel_split-name1        c_quote c_comma
                 c_quote lst_mlabel_split-name2        c_quote c_comma
                 c_quote lst_mlabel_split-stras        c_quote c_comma
                 c_quote lst_mlabel_split-ort02        c_quote c_comma
                 c_quote lst_mlabel_split-ort01        c_quote c_comma
                 c_quote lst_mlabel_split-regio        c_quote c_comma
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*                 c_quote lst_mlabel_split-landx        c_quote c_comma
                 c_quote lst_mlabel_split-landx50      c_quote c_comma
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
                 c_quote lst_mlabel_split-pstlz        c_quote c_comma
                 c_quote lst_mlabel_split-land1        c_quote c_comma
                 c_quote lst_mlabel_split-ship_to_cust c_quote c_comma
                 c_quote lst_mlabel_split-zcontyp      c_quote c_comma
                 c_quote lst_mlabel_split-matnr        c_quote c_comma
                 c_quote lst_mlabel_split-type         c_quote c_comma
                 c_quote lst_mlabel_split-priority     c_quote c_comma
                 c_quote lv_date                       c_quote c_comma
                 c_quote lst_mlabel_split-society_name c_quote c_comma
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*                 c_quote lst_mlabel_split-telf1        c_quote c_comma
                 c_quote lst_mlabel_split-tel_number   c_quote c_comma
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
                 c_quote lst_mlabel_split-ismtitle     c_quote c_comma
                 c_quote lst_mlabel_split-ismyearnr c_quote INTO lst_mlabel_split1.

* BOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
    lst_email_str-email_body = lst_mlabel_split1.
    APPEND lst_email_str TO li_email_str.
    CLEAR lst_email_str.
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

*      IF lv_fileopen_suc = abap_true.
    TRANSFER: lst_mlabel_split1 TO lv_fname. " Main label records are moving to application server
*      ENDIF. " IF lv_fileopen_suc = abap_true
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
* Preparation of data for the temporary internal table: I_LBLSM_TMP.
    lst_lblsm_tmp-zlifnr        = lst_mlabel_split-lifnr.
*   lst_lblsm_tmp-media_product = lst_mlabel_split-ismrefmdprod. "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_product = lst_mlabel_split-mdprod.        "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_issue   = lst_mlabel_split-matnr.
    lst_lblsm_tmp-sales_org     = lst_mlabel_split-vkorg.
    lst_lblsm_tmp-zrecord       = 1.  " It gets accumulated for each record using collect statement
    lst_lblsm_tmp-zcopies       = lst_mlabel_split-menge.

* Total no of free copies
    IF lst_mlabel_split-auart1 IS NOT INITIAL OR " ZFOC / ZCOP Order Types
       lst_mlabel_split-auart3 IS NOT INITIAL.   " ZCSS Order Types
      lst_lblsm_tmp-zfrcopies   = lst_mlabel_split-menge.
    ELSE.
* Total no of paid copies
      lst_lblsm_tmp-zpdcopies   = lst_mlabel_split-menge.
    ENDIF.
    lst_lblsm_tmp-price_list    = lst_mlabel_split-pltyp.
    lst_lblsm_tmp-zquantity     = lst_mlabel_split-menge.
    COLLECT lst_lblsm_tmp INTO i_lblsm_tmp.

    CLEAR lst_lblsm_tmp.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*    AT END OF varname.
    AT END OF <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      CLOSE DATASET lv_fname.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
      LOOP AT i_lblsm_tmp INTO lst_lblsm_tmp.
        v_row_cnt = v_row_cnt + 1.
        lst_i0255_lblsm-mandt         = sy-mandt.    " Client
        lst_i0255_lblsm-srno          = v_row_cnt.
        lst_i0255_lblsm-filename      = lv_filename.
        lst_i0255_lblsm-zdate         = lst_mlabel_split-docdate.
        lst_i0255_lblsm-labltp        = lst_mlabel_split-type.
        lst_i0255_lblsm-zlifnr        = lst_lblsm_tmp-zlifnr.
        lst_i0255_lblsm-media_product = lst_lblsm_tmp-media_product.
        lst_i0255_lblsm-media_issue   = lst_lblsm_tmp-media_issue.
        lst_i0255_lblsm-sales_org     = lst_lblsm_tmp-sales_org.
        lst_i0255_lblsm-zrecord       = lst_lblsm_tmp-zrecord.
        lst_i0255_lblsm-zcopies       = lst_lblsm_tmp-zcopies.
        lst_i0255_lblsm-zfrcopies     = lst_lblsm_tmp-zfrcopies.
        lst_i0255_lblsm-zpdcopies     = lst_lblsm_tmp-zpdcopies.
        lst_i0255_lblsm-price_list    = lst_lblsm_tmp-price_list.
        lst_i0255_lblsm-zquantity     = lst_lblsm_tmp-zquantity.
        lst_i0255_lblsm-zuserid       = sy-uname.                   " ED2K911953+

* Modify (Insert / Update) the Table entry
        MODIFY zqtc_i0255_lblsm FROM lst_i0255_lblsm.
        CLEAR: lst_lblsm_tmp, lst_i0255_lblsm.
      ENDLOOP.
      CLEAR: i_lblsm_tmp[].
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
*  If field control circulation is checked and email is not blank send email
* BOC - NPALLA - INC0334801 - ED1K912633 - 01/22/2021
*      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY varname = lst_mlabel_split-varname
*                                                     cntrl_circulation = abap_true.
      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY varname = lst_mlabel_split-varname
                                                           media_product = lst_mlabel_split-mdprod.
* EOC - NPALLA - INC0334801 - ED1K912633 - 01/22/2021
      IF sy-subrc EQ 0 AND lst_split-email IS NOT INITIAL.
        lv_string = lst_mlabel_split1.
        lv_email = lst_split-email.
        CONCATENATE lst_mlabel_split-varname c_file_undsc sy-datum INTO lv_filename1.
*      Subroutine to send email
        PERFORM f_send_email USING lv_string
                                   lv_email
                                   lv_filename1
                                   li_email_str.
      ENDIF.

    ENDAT.
    CLEAR: lv_filename1,lv_email,lv_string,lst_split.
  ENDLOOP.
  IF sy-subrc EQ 0.
**  Main Label Split File processed to Application server successfully!
    MESSAGE i203(zqtc_r2) WITH text-t07 DISPLAY LIKE c_success. " Main Label Split File processed to Application server successfully!
  ENDIF.
**<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
  CLEAR lv_count.
*  SORT fp_li_main_label BY matnr.  "-<HIPATEL> <INC0200998> <ED1K907981>


* Unconditional Scenario for Main Label
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
  IF rb_mat EQ abap_true.
    IF fp_li_main_label[] IS NOT INITIAL.
      UNASSIGN <i_dyn_table>.
      ASSIGN i_dyn_table3->* TO <i_dyn_table>.
      MOVE-CORRESPONDING fp_li_main_label[] TO <i_dyn_table>[].
      PERFORM f_unconditional_data_file USING lv_process
                                              fp_li_split.
    ENDIF.
  ELSEIF rb_var EQ abap_true.
*  All Unconditional records required only sort for Media Product
    IF fp_li_split_var[] IS NOT INITIAL.
      UNASSIGN <i_dyn_table>.
      ASSIGN i_dyn_table5->* TO <i_dyn_table>.
      MOVE-CORRESPONDING fp_li_split_var[] TO <i_dyn_table>[].
      PERFORM f_unconditional_data_file USING lv_process
                                              fp_li_split.
    ENDIF.
  ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

*  IF sy-subrc EQ 0.
* Modify the table with updated date
*    PERFORM f_update_run_date.
*  File transferred to Application server successfully!
*    MESSAGE i099(zqtc_r2) DISPLAY LIKE c_success. " File processed to Application server successfully!
  IF sy-subrc EQ 0.
**  Main Label File processed to Application server successfully!
    MESSAGE i203(zqtc_r2) WITH text-t09 DISPLAY LIKE c_success. " Main Label File processed to Application server successfully!
*    LEAVE LIST-PROCESSING.
*  ELSE. " ELSE -> IF sy-subrc EQ 0
*  File does not transfer to Application server
*    MESSAGE i100(zqtc_r2) DISPLAY LIKE c_error. " File does not transfer to Application server
*    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.               " F_GET_FILE_ML
*&---------------------------------------------------------------------*
*&      Form  F_GET_ALV_ML
*&---------------------------------------------------------------------*
*       To display ML data in ALV format
*----------------------------------------------------------------------*
*      -->LI_MLABEL_SPLIT   text
*      -->FP_LI_SPLIT       text
*      -->FP_LI_MAIN_LABEL  text
*----------------------------------------------------------------------*
FORM f_get_alv_ml  USING  li_mlabel_split   TYPE tt_mlabel_var
                          fp_li_split       TYPE tt_split
                          fp_li_main_label  TYPE tt_main_label
                          fp_li_split_var   TYPE tt_split_var. "+ <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>

* Local Variable Declaration
  DATA : lv_fname TYPE string,
         lv_count TYPE i,      " Count of type Integers
         lv_fcnt  TYPE i,      " To increment the file counter - GKINTALI:ERP-7404
*         lv_date  TYPE char10, " Date of type CHAR10 "-- GKINTALI:ERP-7404:03.05.2018:ED2K912007
         lv_date  TYPE char11, " Date of type CHAR10  "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
         lv_menge TYPE char17. " Menge of type CHAR17

* Local Structures Declaration
  DATA: lst_mlbl_split    TYPE ty_mlabel_var,
*        lst_mlabel_split  TYPE ty_mlabel_var,
        lst_mlabel_split1 TYPE string,
        lst_label         TYPE ty_output,
        lst_lblsm_tmp     TYPE ty_lblsm_tmp,
        lst_i0255_lblsm   TYPE ty_i0255_lblsm.

  DATA: lv_mon_name TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
        lv_mon_no   TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007

*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
  IF rb_mat EQ abap_true.
    ASSIGN i_dyn_table1->* TO <i_dyn_table_split>.
*  ASSIGN i_dyn_table3->* to <i_dyn_table>.      "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ELSEIF rb_var EQ abap_true.
    ASSIGN i_dyn_table2->* TO <i_dyn_table_split>.
*  ASSIGN i_dyn_table4->* to <i_dyn_table>.      "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
  ENDIF.
  ASSIGN lst_main_lable TO <lst_main_label>.

  MOVE-CORRESPONDING li_mlabel_split[] TO <i_dyn_table_split>[].
*MOVE-CORRESPONDING fp_li_main_label[] to <i_dyn_table>[].     "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>


* Condition based split scenario for Main Label
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*  LOOP AT li_mlabel_split INTO lst_mlbl_split.
  LOOP AT <i_dyn_table_split> ASSIGNING FIELD-SYMBOL(<lst_table>).
    MOVE-CORRESPONDING <lst_table> TO lst_mlbl_split.
*    CLEAR lst_mlabel_split.
*    lst_mlabel_split = lst_mlbl_split.

*Split based on Selection screen condition
    IF rb_mat EQ abap_true.
      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY labltp = c_type_ml
*                                                            varname = lst_mlbl_split-varname     "-<HIPATEL> <RITM0078000>
                                                           media_product = lst_mlbl_split-mdprod "+<HIPATEL> <RITM0078000>
                                                           varsplit = abap_true.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.
      v_field = c_matnr.    "Material Number
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
    ELSEIF rb_var EQ abap_true.
      READ TABLE fp_li_split INTO lst_split WITH KEY labltp = c_type_ml
                                                     varname = lst_mlbl_split-varname
                                                     varsplit = abap_true.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.
* BOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
      IF lst_split-cntrl_circulation NE abap_true.
        v_field = c_matnr.    "Material Number
        ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
      ELSE.
* EOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
        v_field = c_varnm.    "Variant Name
        ASSIGN COMPONENT v_field OF STRUCTURE <lst_table> TO <fs_comp>.
* BOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
      ENDIF.
* EOC - BTIRUVATHU - INC0255257- 2019/08/22 - ED1K910874
    ENDIF.
*    AT NEW varname.
    AT NEW <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      CLEAR : lv_fname,
              lv_count,
              lst_mlabel_split1.

* To populate the file counter as file name in the ALV
      lv_fcnt  = lv_fcnt + 1.
      lv_fname = c_file_str && lv_fcnt.
    ENDAT.

    CLEAR lst_mlabel_split1.
    lv_count = lv_count + 1.            " Job ID
    lst_mlbl_split-jobid = lv_count.  " Job ID
***    lv_menge = lst_mlabel_split-menge. "Quantity changing from quan to char data type
***    CONDENSE lv_menge.
    CONCATENATE lst_mlbl_split-docdate+6(2) c_hypen
                lst_mlbl_split-docdate+4(2) c_hypen
                lst_mlbl_split-docdate+0(4)
           INTO lv_date.
* BOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_mlbl_split-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*         Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_mlbl_split-docdate+6(2) c_hypen
                  lv_mon_name                   c_hypen
                  lst_mlbl_split-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
    lst_label-jobid        = lst_mlbl_split-jobid.
    lst_label-zprodtype    = lst_mlbl_split-zprodtype.
    lst_label-cust         = lst_mlbl_split-cust.
    lst_label-vbeln        = lst_mlbl_split-vbeln.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    IF lst_mlbl_split-auart1 IS INITIAL AND
       lst_mlbl_split-auart2 IS INITIAL AND
       lst_mlbl_split-auart3 IS INITIAL.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                             param2 = c_type_ml.
      IF sy-subrc = 0.
        lst_label-auart1 = lst_constant-low.    "'0'.
      ENDIF.
    ELSE.
      lst_label-auart1 = lst_mlbl_split-auart1.
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    lst_label-auart2       = lst_mlbl_split-auart2.
    lst_label-auart3       = lst_mlbl_split-auart3.
    lst_label-bstkd        = lst_mlbl_split-bstkd.
    lst_label-shipping_ref = lst_mlbl_split-shipping_ref.
    lst_label-stcd1        = lst_mlbl_split-stcd1.
    lst_label-menge        = lst_mlbl_split-menge.
    lst_label-issue_desc   = lst_mlbl_split-issue_desc.
    lst_label-identcode    = lst_mlbl_split-identcode.
    lst_label-ismcopynr    = lst_mlbl_split-ismcopynr.
    lst_label-ismnrinyear  = lst_mlbl_split-ismnrinyear.
    lst_label-part         = lst_mlbl_split-part.
    lst_label-supplement   = lst_mlbl_split-supplement.
    lst_label-name1        = lst_mlbl_split-name1.
    lst_label-name2        = lst_mlbl_split-name2.
    lst_label-stras        = lst_mlbl_split-stras.
    lst_label-ort02        = lst_mlbl_split-ort02.
    lst_label-ort01        = lst_mlbl_split-ort01.
    lst_label-regio        = lst_mlbl_split-regio.
    lst_label-landx50      = lst_mlbl_split-landx50.
    lst_label-pstlz        = lst_mlbl_split-pstlz.
    lst_label-land1        = lst_mlbl_split-land1.
    lst_label-ship_to_cust = lst_mlbl_split-ship_to_cust.
    lst_label-zcontyp      = lst_mlbl_split-zcontyp.
    lst_label-matnr        = lst_mlbl_split-matnr.
    lst_label-type         = lst_mlbl_split-type.
    lst_label-priority     = lst_mlbl_split-priority.
    lst_label-date         = lv_date.
    lst_label-society_name = lst_mlbl_split-society_name.
    lst_label-telf1        = lst_mlbl_split-telf1.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-tel_number   = lst_mlbl_split-tel_number.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-ismtitle     = lst_mlbl_split-ismtitle.
    lst_label-ismyearnr    = lst_mlbl_split-ismyearnr.
    lst_label-price_list   = lst_mlbl_split-pltyp.
    lst_label-filename     = lv_fname.
    lst_label-sales_org    = lst_mlbl_split-vkorg.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    lst_label-subscrno     = lst_mlbl_split-subscrno.   "Subscription Number
    IF lst_label-vbeln IS INITIAL.
      lst_label-vbeln      = lst_mlbl_split-subscrno.   "Subscription Reference
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    APPEND lst_label TO i_output.
    CLEAR  lst_label.
  ENDLOOP.  " LOOP AT li_mlabel_split INTO lst_mlbl_split.

* Unconditional Scenario for Main Label
  CLEAR lv_count.
*  SORT fp_li_main_label BY matnr.  " - <HIPATEL> <INC0200998> <ED1K907981>

*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
  IF rb_mat EQ abap_true.
    IF fp_li_main_label[] IS NOT INITIAL.
      UNASSIGN <i_dyn_table>.
      ASSIGN i_dyn_table3->* TO <i_dyn_table>.
      MOVE-CORRESPONDING fp_li_main_label[] TO <i_dyn_table>[].
      PERFORM f_unconditional_data_alv USING lv_fcnt
                                             fp_li_split.
    ENDIF.
  ELSEIF rb_var EQ abap_true.
* All Unconditional records required for Sort by Media Product only
    IF fp_li_split_var[] IS NOT INITIAL.
      UNASSIGN <i_dyn_table>.
      ASSIGN i_dyn_table5->* TO <i_dyn_table>.
      MOVE-CORRESPONDING fp_li_split_var[] TO <i_dyn_table>[].
      PERFORM f_unconditional_data_alv USING lv_fcnt
                                             fp_li_split.
    ENDIF.
  ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>

ENDFORM.               " F_GET_ALV_ML
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_BL
*&---------------------------------------------------------------------*
*       To generate files for BL
*----------------------------------------------------------------------*
*      -->LI_LABEL_SPLIT    text
*      -->FP_LI_SPLIT       text
*      -->FP_LI_BACK_LABEL  text
*      -->LV_PROCESS        text
*----------------------------------------------------------------------*
FORM f_get_file_bl  USING li_label_split   TYPE tt_blabel_var
                          fp_li_split      TYPE tt_split
                          fp_li_back_label TYPE tt_back_label
                          lv_process       TYPE string.

*  Local Data Declaration
  DATA : lst_back_label1 TYPE string,
         lst_back_label  TYPE ty_back_label.

*  Local Variable Declaration
  DATA : lv_fname        TYPE string,
         lv_count        TYPE i,          " Count of type Integers
         lv_seqno        TYPE numc4,      " Sequence number - GKINTALI:13/03/2018:ED2K910947:ERP-6967
         lv_filename     TYPE string,
         lv_time_stmp    TYPE timestampl, " Time in CHAR Format
         lv_time_stmp_s  TYPE string,
*         lv_date         TYPE char10,     " Date of type CHAR10 "-- GKINTALI:ERP-7404:02.05.2018:ED2K911985
         lv_date         TYPE char11, " Date of type CHAR11 "++ GKINTALI:ERP-7404:02.05.2018:ED2K911985
         lv_fdate        TYPE char8,
         lv_lfimg        TYPE char17,     " Lfimg of type CHAR17
         lv_string       TYPE string,
         lv_email        TYPE ad_smtpadr,
         lv_filename1    TYPE sood-objdes,
         lv_fileopen_suc TYPE char1,      " Fileopen_suc of type CHAR1
         lv_len          TYPE i.          " Sub Ref Length - +<HIPATEL> <INC0200998> <ED1K907899>

  DATA: li_backlbl_split TYPE tt_back_label,
        lst_lbl_split    TYPE ty_blabel_var,
        lst_label_split  TYPE ty_blabel_var,
        lst_label_split1 TYPE string.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
  DATA: lst_lblsm_tmp   TYPE ty_lblsm_tmp,
        lst_i0255_lblsm TYPE ty_i0255_lblsm.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
* BOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
  DATA: li_email_str  TYPE STANDARD TABLE OF ty_email_str,
        lst_email_str TYPE ty_email_str,
        lv_mon_name   TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7404:ED2K911985:02.05.2018
        lv_mon_no     TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7404:ED2K911985:02.05.2018
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

* Splitting Files based on Condition
  LOOP AT li_label_split INTO lst_lbl_split.
    CLEAR lst_label_split.
    lst_label_split = lst_lbl_split.
    AT NEW varname.
      CLEAR: lv_count,
             lv_fname,
             lv_filename,
             lv_time_stmp,
             lv_time_stmp_s,
             lv_fileopen_suc,
             li_email_str[].  "+ HIPATEL - ERP-7404 - ED2K911953

* Populate File Name
      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+2(2) INTO lv_fdate.
* BOC - GKINTALI - 13/04/2018 - ED2K910947 - ERP-6967
*      CONCATENATE lst_label_split-vstel lst_label_split-type
*                  c_file_undsc lst_label_split-varname lv_fdate INTO lv_filename.  " Change for CR#371 & 435
* Additional underscore added as per the new requirement and sequence number added
      lv_seqno = lv_seqno + 1.   " Incrementing the sequence number for each back label file
      CONCATENATE lst_label_split-vstel   " Shipping Point - Warehouse File Code
                  lst_label_split-type    " BL
                  c_file_undsc            " Underscore
                  lst_label_split-varname " Variant Name
                  c_file_undsc            " Underscore       ++by GKINTALI
                  lv_fdate                " Current System Date in 'ddmmyy' format
                  lv_seqno                " 4- digit sequence number  ++by GKINTALI
             INTO lv_filename.
* EOC - GKINTALI - 13/04/2018 - ED2K910947 - ERP-6967
      CONCATENATE lv_process c_slash lv_filename c_dot c_txt INTO lv_fname.
      CONDENSE lv_fname.

      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
      IF sy-subrc EQ 0.
        lv_fileopen_suc = abap_true.
      ENDIF. " IF sy-subrc EQ 0
    ENDAT.

    CLEAR : lst_label_split1.
*   Populate Jobid
    lv_count = lv_count + 1. "Job ID
    lst_label_split-jobid = lv_count. "Job ID

    lv_lfimg = lst_label_split-lfimg. "Quantity changing from quan to char data type
    CONDENSE lv_lfimg.
    CONCATENATE lst_label_split-docdate+6(2) c_hypen
                lst_label_split-docdate+4(2) c_hypen
                lst_label_split-docdate+0(4)
           INTO lv_date.

* BOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_label_split-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_label_split-docdate+6(2) c_hypen
                  lv_mon_name                  c_hypen
                  lst_label_split-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*Subscription reference field length in file based on selection screen
    IF lst_label_split-vbeln IS INITIAL.
      lst_label_split-vbeln = lst_label_split-subscrno.   "Subscription Number
    ENDIF.
    lv_len = strlen( lst_label_split-vbeln ).
    IF NOT p_char IS INITIAL AND lv_len GE p_char.
      lv_len = lv_len - p_char.
      lst_label_split-vbeln = lst_label_split-vbeln+lv_len(p_char).
    ENDIF.

*Populate '0' in Free issue reference field, if Free issue ref /Claim refer/Sample ref is Blank
    IF lst_label_split-auart1 IS INITIAL AND
       lst_label_split-auart2 IS INITIAL AND
       lst_label_split-auart3 IS INITIAL.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                             param2 = c_type_bl.
      IF sy-subrc = 0.
        lst_label_split-auart1 = lst_constant-low.   "'0'.
      ENDIF.
    ELSE.
      CLEAR lst_label_split-vbeln.       "+ <HIPATEL> <INC0200998> <ED1K908120>/<ED1K908710>
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

* MM01 - Requirement - All the values should be displayed in quotes.
* Populate Back label File record
    CONCATENATE c_quote lst_label_split-jobid           c_quote c_comma
                c_quote lst_label_split-zprodtype       c_quote c_comma
                c_quote lst_label_split-cust            c_quote c_comma
                c_quote lst_label_split-vbeln           c_quote c_comma
                c_quote lst_label_split-auart1          c_quote c_comma
                c_quote lst_label_split-auart2          c_quote c_comma
                c_quote lst_label_split-auart3          c_quote c_comma
                c_quote lst_label_split-bstkd           c_quote c_comma
                c_quote lst_label_split-shipping_ref    c_quote c_comma
                c_quote lst_label_split-stcd1           c_quote c_comma
                c_quote lv_lfimg                        c_quote c_comma
                c_quote lst_label_split-issue_desc      c_quote c_comma
                c_quote lst_label_split-identcode      c_quote c_comma
*                c_quote lst_label_split-ismrefmdprod    c_quote c_comma
                c_quote lst_label_split-ismcopynr       c_quote c_comma
                c_quote lst_label_split-ismnrinyear     c_quote c_comma
                c_quote lst_label_split-part            c_quote c_comma
                c_quote lst_label_split-supplement      c_quote c_comma
                c_quote lst_label_split-name1           c_quote c_comma
                c_quote lst_label_split-name2           c_quote c_comma
                c_quote lst_label_split-stras           c_quote c_comma
                c_quote lst_label_split-ort02           c_quote c_comma
                c_quote lst_label_split-ort01           c_quote c_comma
                c_quote lst_label_split-regio           c_quote c_comma
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*                c_quote lst_label_split-landx           c_quote c_comma
                c_quote lst_label_split-landx50         c_quote c_comma
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
                c_quote lst_label_split-pstlz           c_quote c_comma
                c_quote lst_label_split-land1           c_quote c_comma
                c_quote lst_label_split-ship_to_cust    c_quote c_comma
                c_quote lst_label_split-zcontyp         c_quote c_comma
                c_quote lst_label_split-matnr           c_quote c_comma
                c_quote lst_label_split-type            c_quote c_comma
                c_quote lst_label_split-priority        c_quote c_comma
                c_quote lv_date                        c_quote c_comma
                c_quote lst_label_split-society_name    c_quote c_comma
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*                c_quote lst_label_split-telf1        c_quote c_comma
                c_quote lst_label_split-tel_number   c_quote c_comma
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
                c_quote lst_label_split-ismtitle        c_quote c_comma
                c_quote lst_label_split-ismyearnr       c_quote
                INTO lst_label_split1.
* BOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018
    lst_email_str-email_body = lst_label_split1.
    APPEND lst_email_str TO li_email_str.
    CLEAR lst_email_str.
* EOC - HIPATEL - ERP-7404 - ED2K911953 - 05.01.2018

****Application server open to create file
    IF lv_fileopen_suc = abap_true.
      TRANSFER: lst_label_split1 TO lv_fname. " Back label records are moving to application server
    ENDIF.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
* Preparation of data for the temporary internal table: I_LBLSM_TMP.
*   lst_lblsm_tmp-zlifnr        = lst_label_split-lifnr.          "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-zlifnr        = lst_label_split-vstel.            "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
*   lst_lblsm_tmp-media_product = lst_label_split-ismrefmdprod.   "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_product = lst_label_split-mdprod.          "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_issue   = lst_label_split-matnr.
    lst_lblsm_tmp-sales_org     = lst_label_split-vkorg.
    lst_lblsm_tmp-zrecord       = 1.
    lst_lblsm_tmp-zcopies       = lst_label_split-lfimg.

* Total no of free copies
    IF lst_label_split-auart1 IS NOT INITIAL OR  " ZFOC / ZCOP Order Types
       lst_label_split-auart3 IS NOT INITIAL.    " ZCSS Order Types
      lst_lblsm_tmp-zfrcopies     = lst_label_split-lfimg.
    ELSE.
* Total no of paid copies
      lst_lblsm_tmp-zpdcopies     = lst_label_split-lfimg.
    ENDIF.

    lst_lblsm_tmp-price_list    = lst_label_split-pltyp.
    lst_lblsm_tmp-zquantity     = lst_label_split-lfimg.
    COLLECT lst_lblsm_tmp INTO i_lblsm_tmp.

    CLEAR lst_lblsm_tmp.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018

    AT END OF varname.
      CLOSE DATASET lv_fname.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
      LOOP AT i_lblsm_tmp INTO lst_lblsm_tmp.
        v_row_cnt = v_row_cnt + 1.
        lst_i0255_lblsm-mandt         = sy-mandt.    " Client
        lst_i0255_lblsm-srno          = v_row_cnt.
        lst_i0255_lblsm-filename      = lv_filename.
        lst_i0255_lblsm-zdate         = lst_label_split-docdate.
        lst_i0255_lblsm-labltp        = lst_label_split-type.
        lst_i0255_lblsm-zlifnr        = lst_lblsm_tmp-zlifnr.
        lst_i0255_lblsm-media_product = lst_lblsm_tmp-media_product.
        lst_i0255_lblsm-media_issue   = lst_lblsm_tmp-media_issue.
        lst_i0255_lblsm-sales_org     = lst_lblsm_tmp-sales_org.
        lst_i0255_lblsm-zrecord       = lst_lblsm_tmp-zrecord.
        lst_i0255_lblsm-zcopies       = lst_lblsm_tmp-zcopies.
        lst_i0255_lblsm-zfrcopies     = lst_lblsm_tmp-zfrcopies.
        lst_i0255_lblsm-zpdcopies     = lst_lblsm_tmp-zpdcopies.
        lst_i0255_lblsm-price_list    = lst_lblsm_tmp-price_list.
        lst_i0255_lblsm-zquantity     = lst_lblsm_tmp-zquantity.
        lst_i0255_lblsm-zuserid       = sy-uname.                  "ED2K911953+

* Modify (Insert / Update) the Table entry
        MODIFY zqtc_i0255_lblsm FROM lst_i0255_lblsm.
        CLEAR: lst_lblsm_tmp, lst_i0255_lblsm.
      ENDLOOP.
      CLEAR: i_lblsm_tmp[].
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
**<<<<<<<<<<BOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>
* BOC - NPALLA - INC0334801 - ED1K912633 - 01/22/2021
*      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY varname = lst_label_split-varname
*                                                     cntrl_circulation = abap_true.
      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY varname = lst_label_split-varname
                                                           media_product = lst_label_split-mdprod.
* BOC - NPALLA - INC0334801 - ED1K912633 - 01/22/2021
      IF sy-subrc EQ 0 AND lst_split-email IS NOT INITIAL.
        lv_string = lst_label_split1.
        lv_email = lst_split-email.
        CONCATENATE lst_label_split-varname c_file_undsc sy-datum INTO lv_filename1.
*      Subroutine to send email
        PERFORM f_send_email USING lv_string
                                   lv_email
                                   lv_filename1
                                   li_email_str.
      ENDIF.
    ENDAT.
    CLEAR: lv_filename1,lv_email,lv_string,lst_split.
  ENDLOOP.

  IF sy-subrc EQ 0.
**  Back Label Split File processed to Application server successfully!
    MESSAGE i203(zqtc_r2) WITH text-t08 DISPLAY LIKE c_success. " Back Label Split File processed to Application server successfully!
  ENDIF.
**<<<<<<<<<<EOC by MODUTTA on 05/03/2017 for CR#371 & 435>>>>>>>>>>>>>

* Unconditional Files Generation
  CLEAR lv_seqno. " GKINTALI - 15/03/2018 - ED2K910947 - ERP-6967
  SORT fp_li_back_label BY vstel.
  LOOP AT fp_li_back_label INTO DATA(lst_back_labl).
    lst_back_label = lst_back_labl.
    AT NEW vstel.

      CLEAR: lv_count,
             lv_fname,
             lv_filename,
             lv_time_stmp,
             lv_time_stmp_s,
             lv_fileopen_suc.

* Populate File Name
* Begin of Change for CR 471
*      CONCATENATE lst_back_label-vstel lst_back_label-type lst_back_label-ismrefmdprod
*      lst_back_label-ismcopynr c_file_undsc lst_back_label-ismnrinyear lst_back_label-supplement
*      lst_back_label-ismyearnr INTO lv_filename.
      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+2(2) INTO lv_fdate.
* BOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
*      CONCATENATE lst_back_label-vstel lst_back_label-type lv_fdate INTO lv_filename.
* Additional underscores added as per the new requirement and sequence number added
      lv_seqno = lv_seqno + 1.   " Incrementing the sequence number for each back label file
      CONCATENATE lst_back_label-vstel    " Shipping Point - Warehouse File Code
                  lst_back_label-type     " BL
                  c_file_undsc            " Underscore       ++by GKINTALI
                  lv_fdate                " Date in 'ddmmyy' format
                  lv_seqno                " 4- digit sequence number  ++by GKINTALI
             INTO lv_filename.
* EOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967

*      lst_back_label-ismcopynr c_file_undsc lst_back_label-ismnrinyear lst_back_label-supplement
*      lst_back_label-ismyearnr INTO lv_filename.
* End of Change for CR 471

** Populate File path
*      CONCATENATE lv_process c_slash lv_filename c_dot c_csv INTO lv_fname.
* MM01 - Requirement - CSV File not needed, TXT file needed.
      CONCATENATE lv_process c_slash lv_filename c_dot c_txt INTO lv_fname.
      CONDENSE lv_fname.

      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
      IF sy-subrc EQ 0.
        lv_fileopen_suc = abap_true.
      ENDIF. " IF sy-subrc EQ 0
* MM01 - Requirement - No Header needed.
* Populate heading for first line
*      CONCATENATE 'Job ID'(h01) c_comma 'Product Type'(h02) c_comma 'End Use Customer'(h03) c_comma
*           'Subscription Reference'(h04) c_comma 'Free Issue Reference'(h05) c_comma 'Claim Reference'(h06) c_comma
*           'Sample Copy Reference'(h07) c_comma 'PO Reference'(h08) c_comma'Shipping Reference'(h09) c_comma
*           'Canadian GST Number'(h10) c_comma 'Quantity'(h11) c_comma 'Issue Description'(h12) c_comma 'Acronym'(h13) c_comma
*           'Volume'(h14) c_comma 'Issue'(h15) c_comma 'Part'(h16) c_comma 'Supplement'(h17) c_comma 'Address Line 1'(h18) c_comma
*           'Address Line 2'(h19) c_comma 'Address Line 3'(h20) c_comma 'Address Line 4'(h21) c_comma 'Address Line 5'(h22) c_comma
*           'State'(h23) c_comma 'Country Name'(h24) c_comma 'Postcode'(h25) c_comma 'Country Code'(h26) c_comma
*           'Ship to Customer'(h27) c_comma 'Consolidation Type'(h28) c_comma 'Unique Issue Number'(h29) c_comma
*           'Type'(h30) c_comma 'Priority'(h31) c_comma 'Sent Date'(h32) c_comma 'Offline Society Name'(h33) c_comma
*           'Telephone Number'(h34) c_comma 'Journal Title'(h35) c_comma 'Pub Set'(h36) INTO lst_heading1.
*
* " Record's heading are moving to application server
*      TRANSFER: lst_heading1 TO lv_fname.
    ENDAT.

    CLEAR : lst_back_label1.
*   Populate Jobid
    lv_count = lv_count + 1.         " Job ID
    lst_back_label-jobid = lv_count. " Job ID

    lv_lfimg = lst_back_label-lfimg. "Quantity changing from quan to char data type
    CONDENSE lv_lfimg.
    CONCATENATE lst_back_label-docdate+6(2) c_hypen lst_back_label-docdate+4(2) c_hypen
                                               lst_back_label-docdate+0(4) INTO lv_date.

* BOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_back_label-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_back_label-docdate+6(2) c_hypen
                  lv_mon_name                 c_hypen
                  lst_back_label-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*Subscription reference field length in file based on selection screen
    IF lst_back_label-vbeln IS INITIAL.
      lst_back_label-vbeln = lst_back_label-subscrno.   "Subscription Number
    ENDIF.
    lv_len = strlen( lst_back_label-vbeln ).
    IF NOT p_char IS INITIAL AND lv_len GE p_char.
      lv_len = lv_len - p_char.
      lst_back_label-vbeln = lst_back_label-vbeln+lv_len(p_char).
    ENDIF.
*Populate '0' in Free issue reference field, if Free issue ref /Claim refer/Sample ref is Blank
    IF lst_back_label-auart1 IS INITIAL AND
       lst_back_label-auart2 IS INITIAL AND
       lst_back_label-auart3 IS INITIAL.
      CLEAR lst_constant.
      READ TABLE i_constant INTO lst_constant WITH KEY param1 = c_issue_ref
                                                       param2 = c_type_bl.
      IF sy-subrc = 0.
        lst_back_label-auart1 = lst_constant-low.  "'0'.
      ENDIF.
    ELSE.
      CLEAR lst_back_label-vbeln.       "+ <HIPATEL> <INC0200998> <ED1K908120>/<ED1K908710>
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

* MM01 - Requirement - All the values should be displayed in quotes.
* Populate Back label File record
    CONCATENATE c_quote lst_back_label-jobid           c_quote c_comma
                c_quote lst_back_label-zprodtype       c_quote c_comma
                c_quote lst_back_label-cust            c_quote c_comma
                c_quote lst_back_label-vbeln           c_quote c_comma
                c_quote lst_back_label-auart1          c_quote c_comma
                c_quote lst_back_label-auart2          c_quote c_comma
                c_quote lst_back_label-auart3          c_quote c_comma
                c_quote lst_back_label-bstkd           c_quote c_comma
                c_quote lst_back_label-shipping_ref    c_quote c_comma
                c_quote lst_back_label-stcd1           c_quote c_comma
                c_quote lv_lfimg                       c_quote c_comma
                c_quote lst_back_label-issue_desc      c_quote c_comma
* Begin of Change Defect 2003
*                c_quote lst_back_label-ismrefmdprod    c_quote c_comma
                c_quote lst_back_label-identcode       c_quote c_comma
* End of Change Defect 2003
                c_quote lst_back_label-ismcopynr       c_quote c_comma
                c_quote lst_back_label-ismnrinyear     c_quote c_comma
                c_quote lst_back_label-part            c_quote c_comma
                c_quote lst_back_label-supplement      c_quote c_comma
                c_quote lst_back_label-name1           c_quote c_comma
                c_quote lst_back_label-name2           c_quote c_comma
                c_quote lst_back_label-stras           c_quote c_comma
                c_quote lst_back_label-ort02           c_quote c_comma
                c_quote lst_back_label-ort01           c_quote c_comma
                c_quote lst_back_label-regio           c_quote c_comma
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*                c_quote lst_back_label-landx           c_quote c_comma
                c_quote lst_back_label-landx50         c_quote c_comma
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
                c_quote lst_back_label-pstlz           c_quote c_comma
                c_quote lst_back_label-land1           c_quote c_comma
                c_quote lst_back_label-ship_to_cust    c_quote c_comma
                c_quote lst_back_label-zcontyp         c_quote c_comma
                c_quote lst_back_label-matnr           c_quote c_comma
                c_quote lst_back_label-type            c_quote c_comma
                c_quote lst_back_label-priority        c_quote c_comma
                c_quote lv_date                        c_quote c_comma
                c_quote lst_back_label-society_name    c_quote c_comma
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*                c_quote lst_back_label-telf1           c_quote c_comma
                c_quote lst_back_label-tel_number      c_quote c_comma
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
                c_quote lst_back_label-ismtitle        c_quote c_comma
                c_quote lst_back_label-ismyearnr       c_quote
                INTO lst_back_label1.

****Application server open to create file
    IF lv_fileopen_suc = abap_true.
      TRANSFER: lst_back_label1 TO lv_fname. " Main label records are moving to application server
    ENDIF. " IF lv_fileopen_suc = abap_true
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
* Preparation of data for the temporary internal table: I_LBLSM_TMP.
*   lst_lblsm_tmp-zlifnr        = lst_back_label-lifnr.        "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-zlifnr        = lst_back_label-vstel.          "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
*   lst_lblsm_tmp-media_product = lst_back_label-ismrefmdprod. "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_product = lst_back_label-mdprod.        "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_issue   = lst_back_label-matnr.
    lst_lblsm_tmp-sales_org     = lst_back_label-vkorg.
    lst_lblsm_tmp-zrecord       = 1.
    lst_lblsm_tmp-zcopies       = lst_back_label-lfimg.

* Total no of free copies
    IF lst_back_label-auart1 IS NOT INITIAL OR   " ZFOC / ZCOP Order Types
       lst_back_label-auart3 IS NOT INITIAL.     " ZCSS Order Type
      lst_lblsm_tmp-zfrcopies   = lst_back_label-lfimg.
    ELSE.
* Total no of paid copies
      lst_lblsm_tmp-zpdcopies   = lst_back_label-lfimg.
    ENDIF.

    lst_lblsm_tmp-price_list    = lst_back_label-pltyp.
    lst_lblsm_tmp-zquantity     = lst_back_label-lfimg.
    COLLECT lst_lblsm_tmp INTO i_lblsm_tmp.
    CLEAR lst_lblsm_tmp.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
    AT END OF vstel.
      CLOSE DATASET lv_fname.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 178.04.2018
      LOOP AT i_lblsm_tmp INTO lst_lblsm_tmp.
        v_row_cnt = v_row_cnt + 1.
        lst_i0255_lblsm-mandt         = sy-mandt.    " Client
        lst_i0255_lblsm-srno          = v_row_cnt.
        lst_i0255_lblsm-filename      = lv_filename.
        lst_i0255_lblsm-zdate         = lst_back_label-docdate.
        lst_i0255_lblsm-labltp        = lst_back_label-type.
        lst_i0255_lblsm-zlifnr        = lst_lblsm_tmp-zlifnr.
        lst_i0255_lblsm-media_product = lst_lblsm_tmp-media_product.
        lst_i0255_lblsm-media_issue   = lst_lblsm_tmp-media_issue.
        lst_i0255_lblsm-sales_org     = lst_lblsm_tmp-sales_org.
        lst_i0255_lblsm-zrecord       = lst_lblsm_tmp-zrecord.
        lst_i0255_lblsm-zcopies       = lst_lblsm_tmp-zcopies.
        lst_i0255_lblsm-zfrcopies     = lst_lblsm_tmp-zfrcopies.
        lst_i0255_lblsm-zpdcopies     = lst_lblsm_tmp-zpdcopies.
        lst_i0255_lblsm-price_list    = lst_lblsm_tmp-price_list.
        lst_i0255_lblsm-zquantity     = lst_lblsm_tmp-zquantity.
        lst_i0255_lblsm-zuserid       = sy-uname.                  "ED2K911953+

* Modify (Insert / Update) the Table entry
        MODIFY zqtc_i0255_lblsm FROM lst_i0255_lblsm.
        CLEAR: lst_lblsm_tmp, lst_i0255_lblsm.
      ENDLOOP.
      CLEAR: i_lblsm_tmp[].
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
    ENDAT.
  ENDLOOP. " LOOP AT fp_li_back_label INTO DATA(lst_back_labl)
  IF sy-subrc EQ 0.
**  Back Label File processed to Application server successfully!
    MESSAGE i203(zqtc_r2) WITH text-t10 DISPLAY LIKE c_success. " Back Label File processed to Application server successfully!
*    LEAVE LIST-PROCESSING.
*  ELSE. " ELSE -> IF sy-subrc EQ 0
**  File does not transfer to Application server
*    MESSAGE i100(zqtc_r2) DISPLAY LIKE c_error. " File does not transfer to Application server
*    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.               " F_GET_FILE_BL
*&---------------------------------------------------------------------*
*&      Form  F_GET_ALV_BL
*&---------------------------------------------------------------------*
*       To display BL data in ALV format
*----------------------------------------------------------------------*
*      -->LI_LABEL_SPLIT    text
*      -->FP_LI_SPLIT       text
*      -->FP_LI_BACK_LABEL  text
*----------------------------------------------------------------------*
FORM f_get_alv_bl  USING li_label_split   TYPE tt_blabel_var
                         fp_li_split      TYPE tt_split
                         fp_li_back_label TYPE tt_back_label.
*  Local Structures Declaration
  DATA : lst_back_label  TYPE ty_back_label,
         lst_label       TYPE ty_output, " Structure to populate ALV data
         lst_lbl_split   TYPE ty_blabel_var,
         lst_label_split TYPE ty_blabel_var.

*  Local Variables Declaration
  DATA : lv_fname TYPE string,    " Steig Variable for File Name
         lv_count TYPE i,         " Integer Count to populate job ID
         lv_fcnt  TYPE i,         " To increment the file counter - GKINTALI:ERP-7404
*         lv_date  TYPE char10.    " Date of type CHAR10  "-- GKINTALI:ERP-7404:03.05.2018:ED2K912007
         lv_date  TYPE char11.    " Date of type CHAR10  "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007

  DATA: lv_mon_name TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
        lv_mon_no   TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
* Condition based split scenario for Back Label
  LOOP AT li_label_split INTO lst_lbl_split.
    CLEAR: lst_label_split,
           lst_label.
    lst_label_split = lst_lbl_split.
    AT NEW varname.
*   Populate Jobid
      CLEAR: lv_count, " Used to populate Job ID
             lv_fname.

* To populate the file counter as file name in the ALV
      lv_fcnt  = lv_fcnt + 1.
      lv_fname = c_file_str && lv_fcnt.
    ENDAT.

    lv_count = lv_count + 1.          " Job ID
    lst_label_split-jobid = lv_count. " Job ID

***    lv_lfimg = lst_label_split-lfimg. "Quantity changing from quan to char data type
***    CONDENSE lv_lfimg.
    CONCATENATE lst_label_split-docdate+6(2) c_hypen
                lst_label_split-docdate+4(2) c_hypen
                lst_label_split-docdate+0(4)
           INTO lv_date.
* BOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_label_split-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*         Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_label_split-docdate+6(2) c_hypen
                  lv_mon_name                  c_hypen
                  lst_label_split-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
    lst_label-jobid        = lst_label_split-jobid.
    lst_label-zprodtype    = lst_label_split-zprodtype.
    lst_label-cust         = lst_label_split-cust.
    lst_label-vbeln        = lst_label_split-vbeln.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    IF lst_label_split-auart1 IS INITIAL AND
       lst_label_split-auart2 IS INITIAL AND
       lst_label_split-auart3 IS INITIAL.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                             param2 = c_type_bl.
      IF sy-subrc = 0.
        lst_label-auart1 = lst_constant-low.   "'0'.
      ENDIF.
      IF lst_label-vbeln IS INITIAL.
        lst_label-vbeln      = lst_label_split-subscrno.  "Subscription Reference  "+ <HIPATEL> <INC0200998> <ED1K908132>
      ENDIF.
    ELSE.
      lst_label-auart1 = lst_label_split-auart1.
*** Begin of change DEL  RITM0065346 : KJAGANA : ED1K908634: 08-Oct-2017
*      CLEAR lst_label-vbeln.       "+ <HIPATEL> <INC0200998> <ED1K908120>
*** End of change DEL  RITM0065346 : KJAGANA : ED1K908634: 08-Oct-2017
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    lst_label-auart2       = lst_label_split-auart2.
    lst_label-auart3       = lst_label_split-auart3.
    lst_label-bstkd        = lst_label_split-bstkd.
    lst_label-shipping_ref = lst_label_split-shipping_ref.
    lst_label-stcd1        = lst_label_split-stcd1.
    lst_label-menge        = lst_label_split-lfimg.
    lst_label-issue_desc   = lst_label_split-issue_desc.
    lst_label-identcode    = lst_label_split-identcode.
    lst_label-ismcopynr    = lst_label_split-ismcopynr.
    lst_label-ismnrinyear  = lst_label_split-ismnrinyear.
    lst_label-part         = lst_label_split-part.
    lst_label-supplement   = lst_label_split-supplement.
    lst_label-name1        = lst_label_split-name1.
    lst_label-name2        = lst_label_split-name2.
    lst_label-stras        = lst_label_split-stras.
    lst_label-ort02        = lst_label_split-ort02.
    lst_label-ort01        = lst_label_split-ort01.
    lst_label-regio        = lst_label_split-regio.
    lst_label-landx50      = lst_label_split-landx50.
    lst_label-pstlz        = lst_label_split-pstlz.
    lst_label-land1        = lst_label_split-land1.
    lst_label-ship_to_cust = lst_label_split-ship_to_cust.
    lst_label-zcontyp      = lst_label_split-zcontyp.
    lst_label-matnr        = lst_label_split-matnr.
    lst_label-type         = lst_label_split-type.
    lst_label-priority     = lst_label_split-priority.
    lst_label-date         = lv_date.
    lst_label-society_name = lst_label_split-society_name.
    lst_label-telf1        = lst_label_split-telf1.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-tel_number   = lst_label_split-tel_number.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-ismtitle     = lst_label_split-ismtitle.
    lst_label-ismyearnr    = lst_label_split-ismyearnr.
    lst_label-price_list   = lst_label_split-pltyp.
    lst_label-filename     = lv_fname.
    lst_label-sales_org    = lst_label_split-vkorg.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    lst_label-subscrno     = lst_label_split-subscrno.  "Subscription Number
*    IF lst_label-vbeln is INITIAL.
*      lst_label-vbeln      = lst_label_split-subscrno.  "Subscription Reference  " - <HIPATEL> <INC0200998> <ED1K908120>
*    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    APPEND lst_label TO i_output.
    CLEAR  lst_label.
  ENDLOOP. " LOOP AT li_label_split INTO lst_lbl_split.

* Unconditional Scenario for Back Label
  SORT fp_li_back_label BY vstel.
  LOOP AT fp_li_back_label INTO DATA(lst_back_labl).
    lst_back_label = lst_back_labl.
    AT NEW vstel.
      CLEAR: lv_count,
             lv_fname.

* To populate the file counter as file name in the ALV
      lv_fcnt = lv_fcnt + 1.
      lv_fname = c_file_str && lv_fcnt.
    ENDAT.
* To Populate Jobid
    CLEAR : lst_label.
    lv_count = lv_count + 1.         " Job ID
    lst_back_label-jobid = lv_count. " Job ID

***    lv_lfimg = lst_back_label-lfimg. "Quantity changing from quan to char data type
***    CONDENSE lv_lfimg.
    CONCATENATE lst_back_label-docdate+6(2) c_hypen
                lst_back_label-docdate+4(2) c_hypen
                lst_back_label-docdate+0(4)
           INTO lv_date.
* BOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE lst_back_label-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*         Implement suitable error handling here
      ENDIF.

      CONCATENATE lst_back_label-docdate+6(2) c_hypen
                  lv_mon_name                 c_hypen
                  lst_back_label-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
    lst_label-jobid        = lst_back_label-jobid.
    lst_label-zprodtype    = lst_back_label-zprodtype.
    lst_label-cust         = lst_back_label-cust.
    lst_label-vbeln        = lst_back_label-vbeln.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    IF lst_back_label-auart1 IS INITIAL AND
       lst_back_label-auart2 IS INITIAL AND
       lst_back_label-auart3 IS INITIAL.
      CLEAR lst_constant.
      READ TABLE i_constant INTO lst_constant WITH KEY param1 = c_issue_ref
                                                       param2 = c_type_bl.
      IF sy-subrc = 0.
        lst_label-auart1 = lst_constant-low.   "'0'.
      ENDIF.
      IF lst_label-vbeln IS INITIAL.
        lst_label-vbeln      = lst_back_label-subscrno.  "Subscription Reference  "+ <HIPATEL> <INC0200998> <ED1K908132>
      ENDIF.
    ELSE.
      lst_label-auart1 = lst_back_label-auart1.
*** Begin of change DEL  RITM0065346 : KJAGANA : ED1K908634: 08-Oct-2017
*      CLEAR lst_label-vbeln.       "+ <HIPATEL> <INC0200998> <ED1K908120>
*** End of change DEL  RITM0065346 : KJAGANA : ED1K908634: 08-Oct-2017
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    lst_label-auart2       = lst_back_label-auart2.
    lst_label-auart3       = lst_back_label-auart3.
    lst_label-bstkd        = lst_back_label-bstkd.
    lst_label-shipping_ref = lst_back_label-shipping_ref.
    lst_label-stcd1        = lst_back_label-stcd1.
    lst_label-menge        = lst_back_label-lfimg.
    lst_label-issue_desc   = lst_back_label-issue_desc.
    lst_label-identcode    = lst_back_label-identcode.
    lst_label-ismcopynr    = lst_back_label-ismcopynr.
    lst_label-ismnrinyear  = lst_back_label-ismnrinyear.
    lst_label-part         = lst_back_label-part.
    lst_label-supplement   = lst_back_label-supplement.
    lst_label-name1        = lst_back_label-name1.
    lst_label-name2        = lst_back_label-name2.
    lst_label-stras        = lst_back_label-stras.
    lst_label-ort02        = lst_back_label-ort02.
    lst_label-ort01        = lst_back_label-ort01.
    lst_label-regio        = lst_back_label-regio.
    lst_label-landx50      = lst_back_label-landx50.
    lst_label-pstlz        = lst_back_label-pstlz.
    lst_label-land1        = lst_back_label-land1.
    lst_label-ship_to_cust = lst_back_label-ship_to_cust.
    lst_label-zcontyp      = lst_back_label-zcontyp.
    lst_label-matnr        = lst_back_label-matnr.
    lst_label-type         = lst_back_label-type.
    lst_label-priority     = lst_back_label-priority.
    lst_label-date         = lv_date.
    lst_label-society_name = lst_back_label-society_name.
    lst_label-telf1        = lst_back_label-telf1.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-tel_number   = lst_back_label-tel_number.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-ismtitle     = lst_back_label-ismtitle.
    lst_label-ismyearnr    = lst_back_label-ismyearnr.
    lst_label-price_list   = lst_back_label-pltyp.
    lst_label-filename     = lv_fname.
    lst_label-sales_org    = lst_back_label-vkorg.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    lst_label-subscrno     = lst_back_label-subscrno.   "Subscription Number
*    IF lst_label-vbeln is INITIAL.
*      lst_label-vbeln      = lst_back_label-subscrno.   "Subscription Reference  " - <HIPATEL> <INC0200998> <ED1K908120>
*    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    APPEND lst_label TO i_output.
    CLEAR  lst_label.
  ENDLOOP. " LOOP AT fp_li_back_label INTO DATA(lst_back_labl)
ENDFORM.               " F_GET_ALV_BL
*&---------------------------------------------------------------------*
*&      Form  F_UNCONDITIONAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_unconditional_data_alv USING lv_fcnt TYPE i
                                    fp_li_split  TYPE tt_split.

* Local Variable Declaration
  DATA : lv_fname TYPE string,
         lv_count TYPE i,      " Count of type Integers
*         lv_fcnt  TYPE i,      " To increment the file counter - GKINTALI:ERP-7404
*         lv_date  TYPE char10, " Date of type CHAR10 "-- GKINTALI:ERP-7404:03.05.2018:ED2K912007
         lv_date  TYPE char11, " Date of type CHAR10  "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
         lv_menge TYPE char17. " Menge of type CHAR17

* Local Structures Declaration
  DATA: lst_mlbl_split    TYPE ty_mlabel_var,
*        lst_mlabel_split  TYPE ty_mlabel_var,
        lst_mlabel_split1 TYPE string,
        lst_label         TYPE ty_output,
        lst_lblsm_tmp     TYPE ty_lblsm_tmp,
        lst_i0255_lblsm   TYPE ty_i0255_lblsm.

  DATA: lv_mon_name TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007
        lv_mon_no   TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7404:03.05.2018:ED2K912007

*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*  LOOP AT fp_li_main_label ASSIGNING FIELD-SYMBOL(<lst_main_label>).
  LOOP AT <i_dyn_table> ASSIGNING FIELD-SYMBOL(<lst_label>).
    MOVE-CORRESPONDING <lst_label> TO <lst_main_label>.
*Split based on Selection screen condition
    IF rb_mat EQ abap_true.
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*Ignore Media Products are selected for Variant Split
      READ TABLE fp_li_split INTO DATA(lst_split) WITH KEY labltp = c_type_ml
                                                           media_product = <lst_main_label>-mdprod
                                                           varsplit = abap_true.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
      v_field = c_matnr.    "Material Number
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_label> TO <fs_comp>.
    ELSEIF rb_var EQ abap_true.
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
**Generate File based on Media Product OR Variant
      v_field = c_mdprod.    "Media Product
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*       v_field = c_varnm.    "Variant Name   " - <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_label> TO <fs_comp>.
    ENDIF.
*    AT NEW matnr.
    AT NEW <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*      AT NEW matnr.
      CLEAR : lv_fname, lv_count.
* To populate the file counter as file name in the ALV
      lv_fcnt = lv_fcnt + 1.
      lv_fname = c_file_str && lv_fcnt.
    ENDAT.

    lv_count = lv_count + 1.            " Job ID
    <lst_main_label>-jobid = lv_count.  " Job ID
***    lv_menge = <lst_main_label>-menge. "Quantity changing from quan to char data type
***    CONDENSE lv_menge.
    CONCATENATE <lst_main_label>-docdate+6(2) c_hypen
                <lst_main_label>-docdate+4(2) c_hypen
                <lst_main_label>-docdate+0(4)
           INTO lv_date.
* BOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE <lst_main_label>-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*         Implement suitable error handling here
      ENDIF.

      CONCATENATE <lst_main_label>-docdate+6(2) c_hypen
                  lv_mon_name                   c_hypen
                  <lst_main_label>-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K912007   - 03.05.2018
    lst_label-jobid        = <lst_main_label>-jobid.
    lst_label-zprodtype    = <lst_main_label>-zprodtype.
    lst_label-cust         = <lst_main_label>-cust.
    lst_label-vbeln        = <lst_main_label>-vbeln.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    IF <lst_main_label>-auart1 IS INITIAL AND
       <lst_main_label>-auart2 IS INITIAL AND
       <lst_main_label>-auart3 IS INITIAL.
*      CLEAR lst_constant.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                       param2 = c_type_ml.
      IF sy-subrc = 0.
        lst_label-auart1 = lst_constant-low.   "'0'.
      ENDIF.
    ELSE.
      lst_label-auart1 = <lst_main_label>-auart1.
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
    lst_label-auart2       = <lst_main_label>-auart2.
    lst_label-auart3       = <lst_main_label>-auart3.
    lst_label-bstkd        = <lst_main_label>-bstkd.
    lst_label-shipping_ref = <lst_main_label>-shipping_ref.
    lst_label-stcd1        = <lst_main_label>-stcd1.
    lst_label-menge        = <lst_main_label>-menge.
    lst_label-issue_desc   = <lst_main_label>-issue_desc.
    lst_label-identcode    = <lst_main_label>-identcode.
    lst_label-ismcopynr    = <lst_main_label>-ismcopynr.
    lst_label-ismnrinyear  = <lst_main_label>-ismnrinyear.
    lst_label-part         = <lst_main_label>-part.
    lst_label-supplement   = <lst_main_label>-supplement.
    lst_label-name1        = <lst_main_label>-name1.
    lst_label-name2        = <lst_main_label>-name2.
    lst_label-stras        = <lst_main_label>-stras.
    lst_label-ort02        = <lst_main_label>-ort02.
    lst_label-ort01        = <lst_main_label>-ort01.
    lst_label-regio        = <lst_main_label>-regio.
    lst_label-landx50      = <lst_main_label>-landx50.
    lst_label-pstlz        = <lst_main_label>-pstlz.
    lst_label-land1        = <lst_main_label>-land1.
    lst_label-ship_to_cust = <lst_main_label>-ship_to_cust.
    lst_label-zcontyp      = <lst_main_label>-zcontyp.
    lst_label-matnr        = <lst_main_label>-matnr.
    lst_label-type         = <lst_main_label>-type.
    lst_label-priority     = <lst_main_label>-priority.
    lst_label-date         = lv_date.
    lst_label-society_name = <lst_main_label>-society_name.
    lst_label-telf1        = <lst_main_label>-telf1.
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-tel_number   = <lst_main_label>-tel_number.
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
    lst_label-ismtitle     = <lst_main_label>-ismtitle.
    lst_label-ismyearnr    = <lst_main_label>-ismyearnr.
    lst_label-price_list   = <lst_main_label>-pltyp.
    lst_label-filename     = lv_fname.
    lst_label-sales_org   = <lst_main_label>-vkorg.
*BOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    lst_label-subscrno     = <lst_main_label>-subscrno.   "Subscription Number
    IF lst_label-vbeln IS INITIAL.
      lst_label-vbeln      = <lst_main_label>-subscrno.   "Subscription reference
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
    APPEND lst_label TO i_output.
    CLEAR  lst_label.
  ENDLOOP. " LOOP AT fp_li_main_label ASSIGNING FIELD-SYMBOL(<lst_main_label>)
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UNCONDITIONAL_DATA_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_FCNT  text
*----------------------------------------------------------------------*
FORM f_unconditional_data_file USING  lv_process  TYPE string
                                      fp_li_split       TYPE tt_split.

*  Local Data Declaration
  DATA : lst_main_label1 TYPE string,
         lst_main_label2 TYPE string.

*  Local Variable Declaration
  DATA : lv_fname    TYPE string,
         lv_count    TYPE i,      " Count of type Integers
         lv_filename TYPE string,
         lv_date     TYPE char11, " Date of type CHAR11 "++ GKINTALI:ERP-7404:02.05.2018:ED2K911985
         lv_menge    TYPE char17, " Menge of type CHAR17
         lv_lifnr    TYPE lifnr,  " Account Number of Vendor or Creditor
         lv_len      TYPE i,      " Length
         lv_fsplitnm TYPE string. "File Naming convension

  DATA: li_email_str  TYPE STANDARD TABLE OF ty_email_str,
        lst_email_str TYPE ty_email_str,
        lv_mon_name   TYPE char3, " 3-char Month Name
        lv_mon_no     TYPE fcmnr. " Month Number

  DATA: lst_lblsm_tmp   TYPE ty_lblsm_tmp,
        lst_i0255_lblsm TYPE ty_i0255_lblsm.

*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*  LOOP AT fp_li_main_label ASSIGNING FIELD-SYMBOL(<lst_main_label>).
  LOOP AT <i_dyn_table> ASSIGNING FIELD-SYMBOL(<lst_label>).
    MOVE-CORRESPONDING <lst_label> TO <lst_main_label>.
*Split based on Selection screen condition
    IF rb_mat EQ abap_true.
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
      READ TABLE fp_li_split INTO DATA(lst_split_ml) WITH KEY labltp = c_type_ml
                                                        media_product = <lst_main_label>-mdprod
                                                        varsplit = abap_true.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
      v_field = c_matnr.    "Material Number
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_label> TO <fs_comp>.
    ELSEIF rb_var EQ abap_true.
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*File generation based on condition in table ZQTC_I0255_SPLIT
**Generate file for field Media Product
      v_field = c_mdprod.    "Media Product
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
*       v_field = c_varnm.    "Variant Name    " - <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
      ASSIGN COMPONENT v_field OF STRUCTURE <lst_label> TO <fs_comp>.
    ENDIF.
*    AT NEW matnr.
    AT NEW <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*    AT NEW matnr.
      CLEAR : lv_fname, lv_filename,
              lv_count, lst_main_label1, lst_main_label2,
              lv_fsplitnm.  "+<HIPATEL> <INC0200998> <ED1K907981>

* Populate file name
* MM01 - Requirement - remove leading zeroes from vendor number
      lv_lifnr = <lst_main_label>-lifnr.
      SHIFT lv_lifnr LEFT DELETING LEADING c_zero.
* BOC - GKINTALI - 13/03/2018 - ED2K910947 - ERP-6967
*      CONCATENATE lv_lifnr <lst_main_label>-type <lst_main_label>-ismrefmdprod
*      <lst_main_label>-ismcopynr c_file_undsc <lst_main_label>-ismnrinyear <lst_main_label>-supplement
*      c_file_undsc <lst_main_label>-ismyearnr INTO lv_filename.
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*      IF rb_mat eq abap_true.                   "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
      CONCATENATE c_file_undsc                    " Underscore   ++by GKINTALI
                  <lst_main_label>-matnr+0(4)     " Media Issue  ++<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
                  c_file_undsc                    " Underscore
                  <lst_main_label>-ismcopynr      " Volume
                  c_file_undsc                    " Underscore
                  <lst_main_label>-ismnrinyear    " Issue
                  <lst_main_label>-supplement     " Supplement
             INTO lv_fsplitnm.
*      ELSEIF rb_var eq abap_true.
*      ENDIF.                                     "- <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344>
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
* Additional underscores added as per the new requirement
      CONCATENATE lv_lifnr                        " SAP Vendor Number
                  <lst_main_label>-type           " ML
*                  c_file_undsc                    " Underscore   ++by GKINTALI
*                  <lst_main_label>-ismrefmdprod  " Acronym --<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*                  <lst_main_label>-matnr+0(4)     " Media Issue  ++<HIPATEL> <INC0200998> <ED1K907523> <06/29/2018>
*BOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
                  lv_fsplitnm
*                  c_file_undsc                    " Underscore   ++by GKINTALI
*                  <lst_main_label>-ismcopynr      " Volume
*                  c_file_undsc                    " Underscore
*                  <lst_main_label>-ismnrinyear    " Issue
*                  <lst_main_label>-supplement     " Supplement
*EOC <HIPATEL> <INC0200998> <ED1K907981> <07/16/2018>
*BOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
          INTO   lv_filename.

      IF <lst_main_label>-cntrl_var EQ abap_true.
        CONCATENATE lv_filename
                    c_file_undsc                    " Underscore
                   <lst_main_label>-varname        " Variant Name
              INTO lv_filename.
      ENDIF.
      CONCATENATE lv_filename
*EOC <HIPATEL> <CHG0040278/RITM0078000> <ED1K909344> <01/18/2019>
                  c_file_undsc                    " Underscore
                  <lst_main_label>-ismyearnr      " Pub Set
             INTO lv_filename.
* EOC - GKINTALI - 13/03/2018 - ED2K910947

*      CONCATENATE lv_filename c_file_undsc lv_time_stmp_s INTO lv_filename.
*      CONDENSE lv_filename.
* Populate File path
*      CONCATENATE lv_process c_slash lv_filename c_dot c_csv INTO lv_fname.
* MM01 - Requirement - CSV File not needed, TXT file needed.
      CONCATENATE lv_process c_slash lv_filename c_dot c_txt INTO lv_fname.
      CONDENSE lv_fname.

      OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
*      IF sy-subrc EQ 0.
*        lv_fileopen_suc = abap_true.
*      ENDIF. " IF sy-subrc EQ 0

* MM01 - Requirement - No Header needed.
* Populate heading for first line
*      CONCATENATE 'Job ID'(h01) c_comma 'Product Type'(h02) c_comma 'End Use Customer'(h03) c_comma
*           'Subscription Reference'(h04) c_comma 'Free Issue Reference'(h05) c_comma 'Claim Reference'(h06) c_comma
*           'Sample Copy Reference'(h07) c_comma 'PO Reference'(h08) c_comma'Shipping Reference'(h09) c_comma
*           'Canadian GST Number'(h10) c_comma 'Quantity'(h11) c_comma 'Issue Description'(h12) c_comma 'Acronym'(h13) c_comma
*           'Volume'(h14) c_comma 'Issue'(h15) c_comma 'Part'(h16) c_comma 'Supplement'(h17) c_comma 'Address Line 1'(h18) c_comma
*           'Address Line 2'(h19) c_comma 'Address Line 3'(h20) c_comma 'Address Line 4'(h21) c_comma 'Address Line 5'(h22) c_comma
*           'State'(h23) c_comma 'Country Name'(h24) c_comma 'Postcode'(h25) c_comma 'Country Code'(h26) c_comma
*           'Ship to Customer'(h27) c_comma 'Consolidation Type'(h28) c_comma 'Unique Issue Number'(h29) c_comma
*           'Type'(h30) c_comma 'Priority'(h31) c_comma 'Sent Date'(h32) c_comma 'Offline Society Name'(h33) c_comma
*           'Telephone Number'(h34) c_comma 'Journal Title'(h35) c_comma 'Pub Set'(h36) INTO lst_heading1.
*
* " Record's heading are moving to application server
*      TRANSFER: lst_heading1 TO lv_fname.
    ENDAT.

    lv_count = lv_count + 1. "Job ID
    <lst_main_label>-jobid = lv_count. "Job ID
    lv_menge = <lst_main_label>-menge. "Quantity changing from quan to char data type
    CONDENSE lv_menge.
    CONCATENATE <lst_main_label>-docdate+6(2) c_hypen <lst_main_label>-docdate+4(2) c_hypen <lst_main_label>-docdate+0(4) INTO lv_date.

* BOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
    IF cb_date = 'X'.
      CLEAR: lv_mon_name, lv_mon_no.
      MOVE <lst_main_label>-docdate+4(2) TO lv_mon_no.
      CALL FUNCTION 'ISP_GET_MONTH_NAME'
        EXPORTING
          language     = sy-langu " 'EN'
          month_number = lv_mon_no " '00'
        IMPORTING
          shorttext    = lv_mon_name
        EXCEPTIONS
          calendar_id  = 1
          date_error   = 2
          not_found    = 3
          wrong_input  = 4
          OTHERS       = 5.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

      CONCATENATE <lst_main_label>-docdate+6(2) c_hypen
                  lv_mon_name                   c_hypen
                  <lst_main_label>-docdate+0(4)
           INTO lv_date.
    ENDIF.
* EOC - GKINTALI - ERP-7404 - ED2K911985 - 02.05.2018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*Subscription reference field length in file based on selection screen
    IF <lst_main_label>-vbeln IS INITIAL.
      <lst_main_label>-vbeln = <lst_main_label>-subscrno.  "Subscription Number
    ENDIF.
    lv_len = strlen( <lst_main_label>-vbeln ).
    IF NOT p_char IS INITIAL AND lv_len GE p_char.
      lv_len = lv_len - p_char.
      <lst_main_label>-vbeln = <lst_main_label>-vbeln+lv_len(p_char).
    ENDIF.

*Populate '0' in Free issue reference field, if Free issue ref /Claim refer/Sample ref is Blank
    IF <lst_main_label>-auart1 IS INITIAL AND
       <lst_main_label>-auart2 IS INITIAL AND
       <lst_main_label>-auart3 IS INITIAL.
      READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = c_issue_ref
                                                       param2 = c_type_ml.
      IF sy-subrc = 0.
        <lst_main_label>-auart1 = lst_constant-low.   "'0'.
      ENDIF.
    ENDIF.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>

* MM01 - Requirement - All the values should be displayed in quotes.
* Populate Main label File record
    CONCATENATE  c_quote <lst_main_label>-jobid        c_quote c_comma
                 c_quote <lst_main_label>-zprodtype    c_quote c_comma
                 c_quote <lst_main_label>-cust         c_quote c_comma
                 c_quote <lst_main_label>-vbeln        c_quote c_comma
                 c_quote <lst_main_label>-auart1       c_quote c_comma
                 c_quote <lst_main_label>-auart2       c_quote c_comma
                 c_quote <lst_main_label>-auart3       c_quote c_comma
                 c_quote <lst_main_label>-bstkd        c_quote c_comma
                 c_quote <lst_main_label>-shipping_ref c_quote c_comma
                 c_quote <lst_main_label>-stcd1        c_quote c_comma
                 c_quote lv_menge                      c_quote c_comma
                 c_quote <lst_main_label>-issue_desc   c_quote c_comma
* Begin of Change Defect 2003
*                 c_quote <lst_main_label>-ismrefmdprod c_quote c_comma
                 c_quote <lst_main_label>-identcode c_quote c_comma
* End of Change Defect 2003
                 c_quote <lst_main_label>-ismcopynr    c_quote c_comma
                 c_quote <lst_main_label>-ismnrinyear  c_quote c_comma
                 c_quote <lst_main_label>-part         c_quote c_comma
                 c_quote <lst_main_label>-supplement   c_quote c_comma
                 c_quote <lst_main_label>-name1        c_quote c_comma
                 c_quote <lst_main_label>-name2        c_quote c_comma
                 c_quote <lst_main_label>-stras        c_quote c_comma
                 c_quote <lst_main_label>-ort02        c_quote c_comma
                 c_quote <lst_main_label>-ort01        c_quote c_comma
                 c_quote <lst_main_label>-regio        c_quote c_comma
* BOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
* To populate the Long (50 Char) Description of the country in the final output instead of 15-char Description
*                 c_quote <lst_main_label>-landx        c_quote c_comma
                 c_quote <lst_main_label>-landx50      c_quote c_comma
* EOC- GKINTALI - 22/03/2018 - ERP-6967 - ED2K910947
                 c_quote <lst_main_label>-pstlz        c_quote c_comma
                 c_quote <lst_main_label>-land1        c_quote c_comma
                 c_quote <lst_main_label>-ship_to_cust c_quote c_comma
                 c_quote <lst_main_label>-zcontyp      c_quote c_comma
                 c_quote <lst_main_label>-matnr        c_quote c_comma
                 c_quote <lst_main_label>-type         c_quote c_comma
                 c_quote <lst_main_label>-priority     c_quote c_comma
                 c_quote lv_date                       c_quote c_comma
                 c_quote <lst_main_label>-society_name c_quote c_comma
*BOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
*                 c_quote <lst_main_label>-telf1        c_quote c_comma
                 c_quote <lst_main_label>-tel_number   c_quote c_comma
*EOC by <NPALLA> <INC0273232> <ED1K911472> <12/23/2019>
                 c_quote <lst_main_label>-ismtitle     c_quote c_comma
                 c_quote <lst_main_label>-ismyearnr c_quote INTO lst_main_label1.

*    IF lv_fileopen_suc = abap_true.
    TRANSFER: lst_main_label1 TO lv_fname. " Main label records are moving to application server
*    ENDIF. " IF lv_fileopen_suc = abap_true
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 17.04.2018
* Preparation of data for the temporary internal table: I_LBLSM_TMP.
    lst_lblsm_tmp-zlifnr        = <lst_main_label>-lifnr.
*   lst_lblsm_tmp-media_product = <lst_main_label>-ismrefmdprod.  "- HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_product = <lst_main_label>-mdprod.        "+ HIPATEL - ERP-7404 - ED2K911953 - 23.04.2018
    lst_lblsm_tmp-media_issue   = <lst_main_label>-matnr.
    lst_lblsm_tmp-sales_org     = <lst_main_label>-vkorg.
    lst_lblsm_tmp-zrecord       = 1.
    lst_lblsm_tmp-zcopies       = <lst_main_label>-menge.

* Total no of free copies
    IF <lst_main_label>-auart1 IS NOT INITIAL OR  " ZFOC / ZCOP Order Types
       <lst_main_label>-auart3 IS NOT INITIAL.    " ZCSS Order Type
      lst_lblsm_tmp-zfrcopies   = <lst_main_label>-menge.
    ELSE.
* Total no of paid copies
      lst_lblsm_tmp-zpdcopies   = <lst_main_label>-menge.
    ENDIF.

    lst_lblsm_tmp-price_list    = <lst_main_label>-pltyp.
    lst_lblsm_tmp-zquantity     = <lst_main_label>-menge.
    COLLECT lst_lblsm_tmp INTO i_lblsm_tmp.
    CLEAR lst_lblsm_tmp.
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
*BOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
*    AT END OF matnr.
    AT END OF <fs_comp>.
*EOC <HIPATEL> <INC0200998> <ED1K907899> <07/06/2018>
      CLOSE DATASET lv_fname.
* BOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
      LOOP AT i_lblsm_tmp INTO lst_lblsm_tmp.
        v_row_cnt = v_row_cnt + 1.
        lst_i0255_lblsm-mandt         = sy-mandt.    " Client
        lst_i0255_lblsm-srno          = v_row_cnt.
        lst_i0255_lblsm-filename      = lv_filename.
        lst_i0255_lblsm-zdate         = <lst_main_label>-docdate.
        lst_i0255_lblsm-labltp        = <lst_main_label>-type.
        lst_i0255_lblsm-zlifnr        = lst_lblsm_tmp-zlifnr.
        lst_i0255_lblsm-media_product = lst_lblsm_tmp-media_product.
        lst_i0255_lblsm-media_issue   = lst_lblsm_tmp-media_issue.
        lst_i0255_lblsm-sales_org     = lst_lblsm_tmp-sales_org.
        lst_i0255_lblsm-zrecord       = lst_lblsm_tmp-zrecord.
        lst_i0255_lblsm-zcopies       = lst_lblsm_tmp-zcopies.
        lst_i0255_lblsm-zfrcopies     = lst_lblsm_tmp-zfrcopies.
        lst_i0255_lblsm-zpdcopies     = lst_lblsm_tmp-zpdcopies.
        lst_i0255_lblsm-price_list    = lst_lblsm_tmp-price_list.
        lst_i0255_lblsm-zquantity     = lst_lblsm_tmp-zquantity.
        lst_i0255_lblsm-zuserid       = sy-uname.

* Modify (Insert / Update) the Table entry
        MODIFY zqtc_i0255_lblsm FROM lst_i0255_lblsm.
        CLEAR: lst_lblsm_tmp, lst_i0255_lblsm.
      ENDLOOP.
      CLEAR: i_lblsm_tmp[].
* EOC - GKINTALI - ERP-7404 - ED2K911914 - 18.04.2018
    ENDAT.
  ENDLOOP. " LOOP AT fp_li_main_label ASSIGNING FIELD-SYMBOL(<lst_main_label>)
ENDFORM.
