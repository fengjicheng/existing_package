*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_JRNL_DISPTCH_SCHDLE
* PROGRAM DESCRIPTION: Journal Dispatch Schedule Report
* DEVELOPER:Shivani Upadhyaya
* CREATION DATE:2017-01-13
* OBJECT ID:I0268
* TRANSPORT NUMBER(S):ED2K904120
*-------------------------------------------------------------------*
*
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K905911
*** REFERENCE NO:  JIRA Defect# ERP-1976
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-08
*** DESCRIPTION: Print run calcualtion in conference Quantity is considering
*                deleted items.
***------------------------------------------------------------------- *
*** REVISION HISTORY-----------------------------------------------------*
*** REVISION NO: ED2K905960
*** REFERENCE NO:  JIRA Defect# ERP-2002
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-05-09
*** DESCRIPTION: Vendor number's leading zeros needs to be removed. If the
* Quantity is negative then we need to send zero quantity.
***------------------------------------------------------------------- *
*** REVISION NO: ED2K907999
*** REFERENCE NO:  CR#619
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-08-16
*** DESCRIPTION: To change from publication date to Initial Shipping Date.
***------------------------------------------------------------------- *
*** REVISION NO: ED2K908623
*** REFERENCE NO: ERP-4602
*** DEVELOPER: Pavan Bandlapalli
*** DATE:  2017-09-20
*** DESCRIPTION: Corrected the code to populate correctly expected
*                delivery date to populate initial shipping date.
***------------------------------------------------------------------- *
*** REVISION NO : ED2K911988
*** REFERENCE NO: ERP-7445
*** DEVELOPER   : Geeta Kintali
*** DATE        :  2018-05-01
*** DESCRIPTION: 1. Corrected the code to populate Issue Description   *
***                 field in both JDSR/WMS files as per the requirement*
***              2. ISSN field is populated with IDENTCODE value from  *
***                 the table: JPTIDCDASSIGN for high-level media      *
***                 product of the given material - only for WMS file. *
***              3. Date Format check box is added on selection screen *
***                 and accordingly date format is changed in the file *
***                 during its population as DD-MMM-YYYY for both      *
***                 JDSR and WMS files.                                *
***--------------------------------------------------------------------*
*** REVISION NO : ED2K920229
*** REFERENCE NO: OTCM-25581
*** DEVELOPER   : MIMMADISET
*** DATE        : 11-Nov-2020
*** DESCRIPTION:For all the Media Issues (Physical) a Win-shuttle script*
*** will be used to update the Gross Weight, Net Weight and Weight Unit *
** in the Product Master based on the data provided by Business for the *
** year Media issues of 2020 and 2021.*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JRNL_DSPTCH_SCHDLE_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       Clear all variables .
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_clear_all.
  CLEAR: i_mara,
         i_jptidcdassign,
         i_mver,
         i_makt,
         i_mapr,
         i_prop,
         i_plaf,
         i_eban,
         i_ekpo,
         i_vbap,
         i_vbak,
         i_jksesched,
         i_jksesched_x,
         i_final.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MARA
*&---------------------------------------------------------------------*
*     Get Data From Mara Table.
*----------------------------------------------------------------------*
*      CHANGING fp_i_mara
*               fp_i_jptidcdassign
*               fp_i_eord
*----------------------------------------------------------------------*
FORM f_get_data_mara  CHANGING fp_i_mara              TYPE tty_mara
                               fp_i_jptidcdassign     TYPE tty_jptidcdassign
                               fp_i_jptidcdassign_wms TYPE tty_jptidcdassign
                               fb_i_zqtc_inven_recon  TYPE tty_zqtc_inven_recon
                               fp_i_eord              TYPE tty_eord
                               fp_i_lfa1              TYPE tty_lfa1
                               fp_i_plaf              TYPE tty_plaf.
  TYPES:
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*    BEGIN OF lty_publdate,
*      sign   TYPE char1,       " Sign of type CHAR1
*      option TYPE char2,       " Option of type CHAR2
*      low    TYPE ismpubldate, " Publication Date
*      high   TYPE ismpubldate, " Publication Date
*    END OF lty_publdate,
    BEGIN OF lty_shipdate,
      sign   TYPE char1,       " Sign of type CHAR1
      option TYPE char2,       " Option of type CHAR2
      low    TYPE ismerstverdat, " Initial Shipping Date
      high   TYPE ismerstverdat, " Initial Shipping Date
    END OF lty_shipdate,
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

    BEGIN OF lty_mtart,
      sign   TYPE char1,       " Sign of type CHAR1
      option TYPE char2,       " Option of type CHAR2
      low    TYPE mtart,       " Material Number
      high   TYPE mtart,       " Material Number
    END OF lty_mtart.

  DATA : lv_date        TYPE sy-datum, " ABAP System Field: Current Date of Application Server
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*         lst_publdate   TYPE lty_publdate,
*         lir_publdate   TYPE TABLE OF lty_publdate INITIAL SIZE 0,
         lst_shipdate   TYPE lty_shipdate,
         lir_shipdate   TYPE TABLE OF lty_shipdate INITIAL SIZE 0,
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
         lst_mtart      TYPE lty_mtart,
         lir_mtart      TYPE TABLE OF lty_mtart INITIAL SIZE 0,
         lst_ident_type TYPE ty_ismidcodetype,
         li_eord_tmp    TYPE tty_eord.

  CONSTANTS: lc_sign          TYPE char1      VALUE 'I',               " Sign of type CHAR1
             lc_option        TYPE char2      VALUE 'BT',              " Option of type CHAR2
             lc_param1_matype TYPE rvari_vnam VALUE 'MATERIAL_TYPE',   " ABAP: Name of Variant Variable
             lc_adjst_typ     TYPE rvari_vnam VALUE 'ADJUSTMENT_TYPE'. " ABAP: Name of Variant Variable


  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_param1_matype.
        lst_mtart-sign   = <lst_constant>-sign.
        lst_mtart-option = <lst_constant>-opti .
        lst_mtart-low    = <lst_constant>-low.
        lst_mtart-high   = <lst_constant>-high.
        APPEND lst_mtart TO lir_mtart.
        CLEAR : lst_mtart.

      WHEN c_ident_code.
        lst_ident_type-sign   = <lst_constant>-sign.
        lst_ident_type-option = <lst_constant>-opti .
        lst_ident_type-low    = <lst_constant>-low.
        lst_ident_type-high   = <lst_constant>-high.
        APPEND lst_ident_type TO ir_ident_type.
        CLEAR : lst_ident_type.

        IF <lst_constant>-param2 EQ c_ident_code_wms.
          lst_ident_type-sign   = <lst_constant>-sign.
          lst_ident_type-option = <lst_constant>-opti .
          lst_ident_type-low    = <lst_constant>-low.
          lst_ident_type-high   = <lst_constant>-high.
          APPEND lst_ident_type TO ir_ident_type_wms.
          CLEAR : lst_ident_type.
        ENDIF. " IF <lst_constant>-param2 EQ c_ident_code_wms

        IF <lst_constant>-param2 EQ space.
          lst_ident_type-sign   = <lst_constant>-sign.
          lst_ident_type-option = <lst_constant>-opti .
          lst_ident_type-low    = <lst_constant>-low.
          lst_ident_type-high   = <lst_constant>-high.
          APPEND lst_ident_type TO ir_ident_type_wo_wms.
          CLEAR : lst_ident_type.
        ENDIF. " IF <lst_constant>-param2 EQ space

      WHEN lc_adjst_typ.
        v_adjtyp_jdr = <lst_constant>-low.

* No action Required
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)

* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*  IF p_pbdate IS NOT INITIAL.
*    CLEAR: lv_date,
*          lst_publdate.
*    lv_date             = sy-datum + p_pbdate. "lv_publdate.
*    lst_publdate-sign   = lc_sign.
*    lst_publdate-option = lc_option.
*    lst_publdate-low    = sy-datum.
*    lst_publdate-high   = lv_date.
*    APPEND lst_publdate TO lir_publdate.
*    CLEAR: lst_publdate, fp_i_mara[].
*  ENDIF. " IF p_pbdate IS NOT INITIAL
  IF p_shpdat IS NOT INITIAL.
    CLEAR: lv_date,
          lst_shipdate.
    lv_date             = sy-datum + p_shpdat.   " To add number of days from today.
    lst_shipdate-sign   = lc_sign.
    lst_shipdate-option = lc_option.
    lst_shipdate-low    = sy-datum.
    lst_shipdate-high   = lv_date.
    APPEND lst_shipdate TO lir_shipdate.
    CLEAR: lst_shipdate, fp_i_mara[].
  ENDIF. " IF p_shpdat IS NOT INITIAL
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

*Fetching Data from MARA Table
  SELECT matnr          " Material Number
         mtart          " Material Type
         labor          " Laboratory/design office
*BOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
         ntgew          " Net Weight
*EOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
         ismtitle       " Title
         ismrefmdprod   " Media Product
         ismpubltype    " Publication Type
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*         ismpubldate    " Publication Date
         isminitshipdate  "Initial Shipping Date
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
         ismcopynr      " Copy Number of Media Issue
         ismyearnr      " Media issue year number
         ismissuetypest " Issue Variant Type - Standard (Planned)
    FROM mara           " General Material Data
    INTO TABLE fp_i_mara
    WHERE matnr IN s_matnr[]
      AND mtart IN lir_mtart[]
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*      AND ismpubldate IN lir_publdate[] .
      AND isminitshipdate IN lir_shipdate[] .
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

  IF sy-subrc EQ 0.
    SORT fp_i_mara[] BY matnr.
*Fetching Data From PLAF Table
    SELECT   plnum " Planned order number
             matnr " Planning material
             plwrk " Planning Plant
             gsmng " Production plant in planned order
             psttr " Total planned order quantity
      INTO TABLE fp_i_plaf
      FROM  plaf   " Planned Order
      FOR ALL ENTRIES IN fp_i_mara
      WHERE matnr EQ fp_i_mara-matnr.
    IF sy-subrc EQ 0.
      SORT fp_i_plaf BY matnr plwrk.
    ENDIF. " IF sy-subrc EQ 0
*Fetching Data From JPTIDCDASSIGN Table
    IF ir_ident_type IS NOT INITIAL.
      SELECT matnr                         " Material Number
             idcodetype                    " Type of Identification Code
             identcode                     " Identification Code
        FROM jptidcdassign                 " IS-M: Assignment of ID Codes to Material
        INTO TABLE fp_i_jptidcdassign
        FOR ALL ENTRIES IN fp_i_mara
        WHERE matnr = fp_i_mara-matnr
          AND idcodetype IN ir_ident_type. "c_idcdtyp_zjcd.
      IF sy-subrc = 0.
        SORT fp_i_jptidcdassign[] BY matnr.
***        fp_i_jptidcdassign_wms[] = fp_i_jptidcdassign[]. "-GKINTALI - 05/01/2018 - ERP-7445 - ED2K911988
* Deleting data which are not for wms
        DELETE fp_i_jptidcdassign WHERE idcodetype NOT IN ir_ident_type_wo_wms .
*          DELETE fp_i_jptidcdassign_wms WHERE idcodetype NOT IN ir_ident_type_wms.
* BOC - GKINTALI - 05/01/2018 - ERP-7445 - ED2K911988
        SELECT matnr                         " Material Number
             idcodetype                    " Type of Identification Code
             identcode                     " Identification Code
        FROM jptidcdassign                 " IS-M: Assignment of ID Codes to Material
        INTO TABLE fp_i_jptidcdassign_wms
        FOR ALL ENTRIES IN fp_i_mara
        WHERE matnr = fp_i_mara-ismrefmdprod
          AND idcodetype IN ir_ident_type_wms. " ZSSN
        IF sy-subrc = 0.
          SORT fp_i_jptidcdassign_wms[] BY matnr.
        ENDIF.
* EOC - GKINTALI - 05/01/2018 - ERP-7445 - ED2K911988
        SELECT  zadjtyp                        " Adjustment Type
                  matnr                        " Material Number
                  zevent                       " Event
                  zdate                        " Transactional date
                  zseqno                       " Sequence Num
                  zoffline                     " Offline Member Qty
                  ismrefmdprod                 " Higher-Level Media Product
                  zfgrdat
                  zlgrdat                      " Last GR Date
            FROM  zqtc_inven_recon             " Table for Inventory Reconciliation Data
            INTO TABLE fb_i_zqtc_inven_recon
            FOR ALL ENTRIES IN fp_i_mara
            WHERE zadjtyp      EQ v_adjtyp_jdr "c_adjtyp_jdr
              AND ismrefmdprod EQ fp_i_mara-ismrefmdprod.

        IF sy-subrc EQ 0.
          SORT fb_i_zqtc_inven_recon BY ismrefmdprod zlgrdat DESCENDING zfgrdat DESCENDING.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc = 0

*Fetching Data from MARC Table
      SELECT matnr " Material Number
             werks " Plant
             perkz " Period Indicator
             prctr " Profit Center
             vrbmt " Reference material for consumption
        FROM marc  " Plant Data for Material
        INTO TABLE i_marc
        FOR ALL ENTRIES IN fp_i_mara
        WHERE matnr = fp_i_mara-matnr.
      IF sy-subrc EQ 0.
        SORT i_marc[] BY matnr werks.

*Fetching Data from EORD Table
        SELECT matnr " Material Number
               werks " Plant
               lifnr " Vendor Account Number
               flifn " Indicator: Fixed vendor
               autet " Source List Usage in Materials Planning
          FROM eord  " Purchasing Source List
          INTO TABLE fp_i_eord
          FOR ALL ENTRIES IN i_marc
           WHERE matnr = i_marc-matnr
             AND werks = i_marc-werks.

        IF sy-subrc = 0.
          SORT fp_i_eord BY matnr werks.
          li_eord_tmp[] = fp_i_eord[].
          SORT li_eord_tmp BY lifnr.
          DELETE ADJACENT DUPLICATES FROM li_eord_tmp COMPARING lifnr.

          IF li_eord_tmp IS NOT INITIAL.
*Fetching Data from LFA1 Table
            SELECT lifnr " Account Number of Vendor or Creditor
                   name1 " Name 1
              FROM lfa1  " Vendor Master (General Section)
              INTO TABLE fp_i_lfa1
              FOR ALL ENTRIES IN li_eord_tmp
              WHERE lifnr = li_eord_tmp-lifnr.
            IF sy-subrc = 0.
              SORT fp_i_lfa1 BY lifnr.
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF li_eord_tmp IS NOT INITIAL
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF ir_ident_type IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MVER
*&---------------------------------------------------------------------*
*       Get Data from MVER Table
*----------------------------------------------------------------------*
*      USING fp_i_mara
*      CHANGING fp_i_mver
*----------------------------------------------------------------------*
FORM f_get_data_mver USING fp_i_marc TYPE tty_marc
                     CHANGING fp_i_mver TYPE tty_mver.

  TYPES: BEGIN OF ty_ref_mat_pl,
           matnr TYPE matnr,   " Material Number
           werks TYPE werks_d, " Plant
         END OF ty_ref_mat_pl.

  DATA: lv_datum       TYPE sy-datum, " ABAP System Field: Current Date of Application Server
        lv_year        TYPE char4,    " Year of type CHAR4
        lv_pyear       TYPE char4,    " Pyear of type CHAR4
        lst_marc       TYPE ty_marc,
        lst_mvke       TYPE ty_mvke,
        lst_ref_mat_pl TYPE ty_ref_mat_pl,
        li_ref_mat_pl  TYPE TABLE OF ty_ref_mat_pl.

  LOOP AT i_mvke INTO lst_mvke.
    CLEAR lst_marc.
    READ TABLE fp_i_marc INTO lst_marc WITH KEY matnr = lst_mvke-matnr
                                              werks = lst_mvke-dwerk BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_ref_mat_pl-matnr   = lst_marc-vrbmt.
      IF lst_mvke-dwerk IS NOT INITIAL.
        lst_ref_mat_pl-werks   = lst_mvke-dwerk.
        APPEND lst_ref_mat_pl TO li_ref_mat_pl.
      ENDIF. " IF lst_mvke-dwerk IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT i_mvke INTO lst_mvke

  SORT li_ref_mat_pl BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM li_ref_mat_pl COMPARING matnr werks.

  IF li_ref_mat_pl IS NOT INITIAL.
    lv_datum = sy-datum.
    lv_year  = lv_datum+0(4).
    lv_pyear = lv_year - 1.

*Fetching Data from MVER Table
    SELECT matnr " Material Number
           werks " Plant
           gjahr " Fiscal Year
           perkz " Period Indicator
           zahlr " Number of follow-on records in Table MVER
           mgv01 " Manually corrected total consumption
           mgv02 " Manually corrected total consumption
           mgv03 " Manually corrected total consumption
           mgv04 " Manually corrected total consumption
           mgv05 " Manually corrected total consumption
           mgv06 " Manually corrected total consumption
           mgv07 " Manually corrected total consumption
           mgv08 " Manually corrected total consumption
           mgv09 " Manually corrected total consumption
           mgv10 " Manually corrected total consumption
           mgv11 " Manually corrected total consumption
           mgv12 " Manually corrected total consumption
      FROM mver  " Material Consumption
      INTO TABLE fp_i_mver
      FOR ALL ENTRIES IN li_ref_mat_pl
      WHERE matnr = li_ref_mat_pl-matnr
        AND werks = li_ref_mat_pl-werks
        AND gjahr = lv_pyear.

    IF sy-subrc EQ 0.
      SORT fp_i_mver[] BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_ref_mat_pl IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MAKT
*&---------------------------------------------------------------------*
*       Get Data from MAKT Table
*----------------------------------------------------------------------*
*      USING fp_i_mara
*      CHANGING fp_i_makt
*----------------------------------------------------------------------*
FORM f_get_data_makt USING fp_i_mara TYPE tty_mara
                     CHANGING fp_i_makt TYPE tty_makt.

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

*Fetching Data from MAKT Table
    SELECT matnr " Material Number
           spras " Language Key
           maktx " Material Description (Short Text)
    FROM makt    " Material Descriptions
    INTO TABLE fp_i_makt
    FOR ALL ENTRIES IN fp_i_mara
    WHERE matnr = fp_i_mara-matnr
      AND spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT fp_i_makt[] BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MAPR
*&---------------------------------------------------------------------*
*      Get Data from MAPR Table
*----------------------------------------------------------------------*
*     USING fp_i_mver
*    CHANGING fp_i_mapr
*----------------------------------------------------------------------*
FORM f_get_data_mapr USING fp_i_mvke TYPE tty_mvke
                     CHANGING fp_i_mapr TYPE tty_mapr.

  DATA: li_mvke_tmp TYPE tty_mvke.
  li_mvke_tmp[] = fp_i_mvke[].
  SORT li_mvke_tmp BY dwerk matnr.
  DELETE ADJACENT DUPLICATES FROM li_mvke_tmp COMPARING dwerk
                                                        matnr.
  IF li_mvke_tmp[] IS NOT INITIAL.
*Fetching Data from MAPR Table
    SELECT werks " Plant
           matnr " Material Number
           pnum1 " Pointer: forecast parameters
    FROM   mapr  " Material Index for Forecast
    INTO TABLE fp_i_mapr
    FOR ALL ENTRIES IN li_mvke_tmp
    WHERE werks = li_mvke_tmp-dwerk
      AND matnr = li_mvke_tmp-matnr.
    IF sy-subrc EQ 0.
      SORT fp_i_mapr BY werks matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mvke_tmp[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PROP
*&---------------------------------------------------------------------*
*       Get Data from PROP Table
*----------------------------------------------------------------------*
*      USING fp_i_mapr
*      CHANGING fp_i_prop
*----------------------------------------------------------------------*
FORM f_get_data_prop USING fp_i_mapr TYPE tty_mapr
                     CHANGING fp_i_prop TYPE tty_prop.

  CONSTANTS: lc_hsnum_00    TYPE hsnum VALUE '00'. " Number for history

  DATA: li_mapr_tmp TYPE tty_mapr.
  li_mapr_tmp[] = fp_i_mapr[].
  SORT li_mapr_tmp BY pnum1.
  DELETE ADJACENT DUPLICATES FROM li_mapr_tmp COMPARING pnum1.

  IF li_mapr_tmp[] IS NOT INITIAL.

*Fetching Data from PROP Table
    SELECT pnum1 " Pointer: forecast parameters
           hsnum " Number for history
           versp " Version number of forecast parameters
           pnum2 " Pointer for forecast results
    FROM prop    " Forecast parameters
    INTO TABLE fp_i_prop
    FOR ALL ENTRIES IN li_mapr_tmp
    WHERE pnum1 = li_mapr_tmp-pnum1.
    IF sy-subrc EQ 0.
      SORT fp_i_prop[] BY hsnum.
      DELETE fp_i_prop WHERE hsnum NE lc_hsnum_00.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mapr_tmp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PROW
*&---------------------------------------------------------------------*
*       Get Data from PROW Table
*----------------------------------------------------------------------*
*      USING fp_i_mapr
*      CHANGING fp_i_prop
*----------------------------------------------------------------------*
FORM f_get_data_prow USING    fp_i_prop TYPE tty_prop
                     CHANGING fp_i_prow_sum TYPE tty_prow_sum.

  DATA: li_prow      TYPE STANDARD TABLE OF ty_prow,
        lst_prow_sum TYPE ty_prow_sum,
        lst_prow_tmp TYPE ty_prow,
        lv_koprw_sum TYPE koprw, " Corrected value for forecast
        li_prop_tmp  TYPE tty_prop.

  li_prop_tmp[] = fp_i_prop[].
  SORT li_prop_tmp BY pnum2.
  DELETE ADJACENT DUPLICATES FROM li_prop_tmp COMPARING pnum2.

  IF li_prop_tmp IS NOT INITIAL.
*Fetching Data from PROW Table
    SELECT pnum2 " Pointer for forecast results
           ertag " First day of the period to which the values refer
           prwrt " Forecast value
           koprw " Corrected value for forecast
      FROM prow  " Forecast Values
      INTO TABLE li_prow
      FOR ALL ENTRIES IN li_prop_tmp
      WHERE pnum2 EQ li_prop_tmp-pnum2.
    IF sy-subrc EQ 0.
      SORT li_prow BY pnum2.
      LOOP AT li_prow INTO lst_prow_tmp.
        lv_koprw_sum = lv_koprw_sum + lst_prow_tmp-koprw.
        AT END OF pnum2.
          lst_prow_sum-pnum2 = lst_prow_tmp-pnum2.
          lst_prow_sum-koprw = lv_koprw_sum.
          APPEND lst_prow_sum TO fp_i_prow_sum.
          CLEAR: lst_prow_sum,
                  lv_koprw_sum.
        ENDAT.
      ENDLOOP. " LOOP AT li_prow INTO lst_prow_tmp
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_prop_tmp IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PLAF
*&---------------------------------------------------------------------*
*      Get Data from PLAF Table
*----------------------------------------------------------------------*
*      USING fp_i_mara
*     CHANGING fp_i_plaf
*----------------------------------------------------------------------*
FORM f_get_data_plaf  USING fp_i_mvke TYPE tty_mvke
                      CHANGING fp_i_plaf TYPE tty_plaf.

  DATA: li_mvke_tmp TYPE tty_mvke.

  li_mvke_tmp[] = fp_i_mvke[].
  SORT li_mvke_tmp BY matnr dwerk .
  DELETE ADJACENT DUPLICATES FROM li_mvke_tmp COMPARING matnr dwerk .

  IF li_mvke_tmp IS NOT INITIAL.

*Fetching Data from PLAF Table
    SELECT plnum " Planned order number
           matnr " Planning material
           plwrk " Planning Plant
           gsmng " Total planned order quantity
           psttr " Order start date in planned order
      FROM plaf  " Planned Order
      INTO TABLE fp_i_plaf
      FOR ALL ENTRIES IN li_mvke_tmp
      WHERE  matnr = li_mvke_tmp-matnr
        AND  plwrk  = li_mvke_tmp-dwerk.
    IF sy-subrc EQ 0.
      SORT fp_i_plaf[] BY  plnum matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_marc_tmp IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_EBAN
*&---------------------------------------------------------------------*
*      Get Data from EBAN Table
*----------------------------------------------------------------------*
*      USING fp_i_mara
*      CHANGING fp_i_eban
*----------------------------------------------------------------------*
FORM f_get_data_eban USING fp_i_mara TYPE tty_mara
                     CHANGING fp_i_eban TYPE tty_eban
                              fp_i_eban_zmenge1 TYPE tty_eban.

  TYPES: BEGIN OF lty_doc_type,
           sign   TYPE char1, " Sign of type CHAR1
           option TYPE char2, " Option of type CHAR2
           low    TYPE bbsrt, " Material Number
           high   TYPE bbsrt, " Material Number
         END OF lty_doc_type.
  DATA: lir_doc_type   TYPE TABLE OF lty_doc_type,
        lir_doc_type_2 TYPE TABLE OF lty_doc_type,
        lst_doc_type   TYPE  lty_doc_type.

***Constants
  CONSTANTS:lc_param1_doc_type TYPE rvari_vnam VALUE 'DOC_TYPE', " ABAP: Name of Variant Variable
            lc_serialno        TYPE tvarv_numb VALUE '0001',     " ABAP: Name of Variant Variable
            lc_serialno_2      TYPE tvarv_numb VALUE '0002'.     " ABAP: Name of Variant Variable

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_param1_doc_type.
        IF <lst_constant>-srno EQ lc_serialno.
          lst_doc_type-sign   = <lst_constant>-sign.
          lst_doc_type-option = <lst_constant>-opti .
          lst_doc_type-low    = <lst_constant>-low.
          lst_doc_type-high   = <lst_constant>-high.
          APPEND lst_doc_type TO lir_doc_type.
          CLEAR: lst_doc_type.
        ENDIF. " IF <lst_constant>-srno EQ lc_serialno
        IF <lst_constant>-srno EQ lc_serialno_2.
          lst_doc_type-sign   = <lst_constant>-sign.
          lst_doc_type-option = <lst_constant>-opti .
          lst_doc_type-low    = <lst_constant>-low.
          lst_doc_type-high   = <lst_constant>-high.
          APPEND lst_doc_type TO lir_doc_type_2.
          CLEAR: lst_doc_type.
        ENDIF. " IF <lst_constant>-srno EQ lc_serialno_2
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

*Fetching Data from EBAN Table
    IF lir_doc_type IS NOT INITIAL.
      SELECT banfn " Purchase Requisition Number
             bnfpo " Item Number of Purchase Requisition
             bsart " Purchase Requisition Document Type
             loekz " Deletion Indicator in Purchasing Document
             estkz " Creation Indicator (Purchase Requisition/Schedule Lines)
             frgzu " Release status
             frgst " Release Strategy in Purchase Requisition  " Defect ERP-1976
             matnr " Material Number
             menge " Purchase Requisition Quantity
             knttp " Account Assignment Category
             flief " Fixed Vendor
             dispo " MRP Controller (Materials Planner)
        FROM eban  " Purchase Requisition
        INTO TABLE fp_i_eban
        FOR ALL ENTRIES IN fp_i_mara
        WHERE bsart IN lir_doc_type
          AND matnr = fp_i_mara-matnr
          AND frgzu EQ abap_true         " Defect ERP-1976
          AND loekz EQ space.            " Defect ERP-1976
      IF sy-subrc EQ 0.
*      Do Nothing
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lir_doc_type IS NOT INITIAL
    IF lir_doc_type_2 IS NOT INITIAL.

      SELECT banfn " Purchase Requisition Number
             bnfpo " Item Number of Purchase Requisition
             bsart " Purchase Requisition Document Type
             loekz " Deletion Indicator in Purchasing Document
             estkz " Creation Indicator (Purchase Requisition/Schedule Lines)
             frgzu " Release status
             frgst " Release Strategy in Purchase Requisition  " Defect ERP-1976
             matnr " Material Number
             menge " Purchase Requisition Quantity
             knttp " Account Assignment Category
             flief " Fixed Vendor
             dispo " MRP Controller (Materials Planner)
        FROM eban  " Purchase Requisition
        INTO TABLE fp_i_eban_zmenge1
        FOR ALL ENTRIES IN fp_i_mara
        WHERE bsart IN lir_doc_type_2
        AND matnr = fp_i_mara-matnr
        AND loekz EQ space          " Defect ERP-1976
        AND ebakz EQ space.         " Defect ERP-1976
      IF sy-subrc EQ 0.
*      Do Nothing
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lir_doc_type_2 IS NOT INITIAL
  ENDIF. " IF fp_i_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_EKPO
*&---------------------------------------------------------------------*
*       Get Data From EKPO Table
*----------------------------------------------------------------------*
*      USING fp_i_eban
*      CHANGING fp_i_ekpo
*----------------------------------------------------------------------*
FORM f_get_data_ekpo USING fp_i_mara TYPE tty_mara
                     CHANGING fp_i_ekpo TYPE tty_ekpo.
  CONSTANTS: lc_bsart_nb1 TYPE esart VALUE 'NB', " Purchasing Document Type
             lc_knttp_p1  TYPE knttp VALUE 'P'.  " Account Assignment Category

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

*Fetching Data from EKPO Table
    SELECT a~bsart " Purchasing Document Number
           b~ebeln " Purchasing Document Number
           b~ebelp " Item Number of Purchasing Document
           b~matnr " Material Number
           b~menge " Purchase Order Quantity
           b~knttp " Account Assignment Category
           b~banfn " Purchase Requisition Number
    INTO TABLE fp_i_ekpo
      FROM ekko AS a
      INNER JOIN ekpo AS b
       ON a~ebeln = b~ebeln
   FOR ALL ENTRIES IN fp_i_mara
   WHERE b~loekz EQ space
     AND matnr = fp_i_mara-matnr
     AND bsart = lc_bsart_nb1
     AND knttp = lc_knttp_p1.
    IF sy-subrc EQ 0.
      SORT fp_i_ekpo BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       Get Process Data
*----------------------------------------------------------------------*
*      USING   fp_i_mara
*              fp_i_makt
*              fp_i_jptidcdassign
*              fp_i_eord
*              fp_i_calc_tab
*     CHANGING fp_i_final
*----------------------------------------------------------------------*
FORM f_process_data USING   fp_i_mara          TYPE tty_mara
                            fp_i_makt          TYPE tty_makt
                            fp_i_cepct         TYPE tty_cepct
                            fp_i_t024x         TYPE tty_t024x
                            fp_i_jptidcdassign TYPE tty_jptidcdassign
                            fp_i_eord          TYPE tty_eord
                            fp_i_lfa1          TYPE tty_lfa1
                            fp_i_marc          TYPE tty_marc
                            fp_i_calc_tab      TYPE tty_calc_tab
                  CHANGING  fp_i_final         TYPE tty_final.

  TYPES: BEGIN OF lty_ismissue_type,
           sign   TYPE char1,           " Sign of type CHAR1
           option TYPE char2,           " Option of type CHAR2
           low    TYPE ismausgvartyppl, " Material Number
           high   TYPE ismausgvartyppl, " Material Number
         END OF lty_ismissue_type.

  DATA: lv_string         TYPE string,
        lv_name           TYPE tdobname,                               " Name
        lv_issue          TYPE string,
*        lv_supp           TYPE string,
        lv_len            TYPE i,                                      " Len of type Integers
        lst_marc          TYPE ty_marc,
        lst_final         TYPE ty_final,
        lir_ismissue_type TYPE TABLE OF lty_ismissue_type,
        lst_ismissue_type TYPE  lty_ismissue_type,
        lv_matnr          TYPE  matnr,                                 " Material Number
        li_lines          TYPE STANDARD TABLE OF tline INITIAL SIZE 0. " SAPscript: Text Lines

  CONSTANTS: lc_autet                TYPE autet      VALUE '1',                  " Source List Usage in Materials Planning
             lc_en                   TYPE spras      VALUE 'EN',                 " Language Key
             lc_id                   TYPE tdid       VALUE 'BEST',               " Text ID
             lc_object               TYPE tdobject   VALUE 'MATERIAL',           " Texts: Application Object
             lc_y                    TYPE char1      VALUE 'Y',                  " Y of type CHAR1
             lc_n                    TYPE char1      VALUE 'N',                  " N of type CHAR1
             lc_param1_ismissue_type TYPE rvari_vnam VALUE 'ISMISSUETYPEST'.     " ABAP: Name of Variant Variable

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_param1_ismissue_type.
        lst_ismissue_type-sign   = <lst_constant>-sign.
        lst_ismissue_type-option = <lst_constant>-opti .
        lst_ismissue_type-low    = <lst_constant>-low.
        lst_ismissue_type-high   = <lst_constant>-high.
        APPEND lst_ismissue_type TO lir_ismissue_type.
        CLEAR: lst_ismissue_type.
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)

*Populating Final Table
  LOOP AT fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>).
*Issue Material Number
    lst_final-matnr          = <lst_mara>-matnr.

    READ TABLE i_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
      lst_final-werks      = <lst_mvke>-dwerk.
    ENDIF.

*Issue Number
    lv_matnr = <lst_mara>-matnr.

    lst_final-labor          = <lst_mara>-labor.
*Title Description
    lst_final-ismtitle       = <lst_mara>-ismtitle.
    lst_final-ismpubltype    = <lst_mara>-ismpubltype.

*Expected Delivery Date
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*    CONCATENATE <lst_mara>-ismpubldate+6(2) <lst_mara>-ismpubldate+4(2)
*                <lst_mara>-ismpubldate+0(4) INTO lst_final-ismpubldate
*                SEPARATED BY c_slash.
    CONCATENATE <lst_mara>-isminitshipdate+6(2) <lst_mara>-isminitshipdate+4(2)
                <lst_mara>-isminitshipdate+0(4) INTO lst_final-isminitshipdate
                SEPARATED BY c_slash.
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*Volume Number
    lst_final-ismcopynr      = <lst_mara>-ismcopynr.
    lst_final-ismyearnr      = <lst_mara>-ismyearnr.

*Supplement Number
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*    IF <lst_mara>-ismissuetypest IS NOT INITIAL.
*      CLEAR: lv_issue,
*             lv_supp,
*             lv_len.
*      lv_issue = lv_matnr+8(7).
*      lv_len  = strlen( lv_issue ).
*      IF lv_len GT 1.
*        lst_final-suplimentno = <lst_mara>-matnr+8(lv_len).
*      ELSEIF lv_len EQ 1.
*        lst_final-suplimentno = <lst_mara>-matnr+8(1).
*      ENDIF.
**Journal Type
*      lst_final-jrnltype = c_jtyp_supp.
*    ELSEIF <lst_mara>-ismissuetypest = c_char_blank.
**Journal Type
*      lst_final-jrnltype = c_jtyp_iss.
*      lst_final-issueno  = lv_matnr+8(7).
*    ENDIF. " IF <lst_mara>-ismissuetypest IN lir_ismissue_type
    CLEAR: lv_issue,
           lv_len.
    lv_issue = lv_matnr+8(7).
    lv_len  = strlen( lv_issue ).
    IF lv_matnr+8(1) = c_char_s.
      lst_final-suplimentno = lv_matnr+8(lv_len).
*Journal Type
      lst_final-jrnltype = c_jtyp_supp.
    ELSE.
      lst_final-issueno  = lv_matnr+8(lv_len).
*Journal Type
      lst_final-jrnltype = c_jtyp_iss.
    ENDIF.
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*Issue Description
    READ TABLE fp_i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>) WITH KEY matnr = <lst_mara>-matnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-maktx = <lst_makt>-maktx.
    ENDIF. " IF sy-subrc EQ 0

*Journal Code
    READ TABLE fp_i_jptidcdassign ASSIGNING FIELD-SYMBOL(<lst_jptidcdassign>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
      lst_final-identcode = <lst_jptidcdassign>-identcode.
    ENDIF. " IF sy-subrc EQ 0

*Office
    READ TABLE fp_i_t024x ASSIGNING FIELD-SYMBOL(<lst_t024x>) WITH KEY labor = <lst_mara>-labor BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-office = <lst_t024x>-lbtxt.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE fp_i_marc INTO lst_marc WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
*ProductLine
      READ TABLE fp_i_cepct ASSIGNING FIELD-SYMBOL(<lst_cepct>) WITH KEY prctr = lst_marc-prctr BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-productline = <lst_cepct>-ktext.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.

*Calculations
    READ TABLE fp_i_calc_tab ASSIGNING FIELD-SYMBOL(<lst_calc_tab>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc = 0.
*Print Run
* To remove the deciamls part
      lst_final-zmenge1 = <lst_calc_tab>-zmenge1.
      CONDENSE lst_final-zmenge1.

*EstMLR
* To remove the deciamls part
      lst_final-zmenge2 = <lst_calc_tab>-zmenge2.
      CONDENSE lst_final-zmenge2.

*OfflineSubs
* To remove the deciamls part
      lst_final-zmenge3 = <lst_calc_tab>-zmenge3.
      CONDENSE lst_final-zmenge3.

*ReturnBySea
* To remove the deciamls part
      lst_final-zmenge4 = <lst_calc_tab>-zmenge4.
      CONDENSE lst_final-zmenge4.

*EstBalanceofStock
* To remove the deciamls part
      lst_final-eblstock = <lst_calc_tab>-zmenge1 - ( <lst_calc_tab>-zmenge2 + <lst_calc_tab>-zmenge3 + <lst_calc_tab>-zmenge4 ).
      CONDENSE lst_final-eblstock.
* Begin of Change Defect 2002
      IF lst_final-eblstock LT 0.
        lst_final-eblstock = 0.
      ENDIF.
* End of Change Defect 2002
    ENDIF. " IF sy-subrc = 0

*OfflineFlag
    IF lst_final-zmenge3 GT 0.
      lst_final-oflflag = lc_y.
    ELSE. " ELSE -> IF lst_final-zmenge3 IS NOT INITIAL
      lst_final-oflflag = lc_n.
    ENDIF. " IF lst_final-zmenge3 IS NOT INITIAL
*ExpeditorCode

    READ TABLE fp_i_eord ASSIGNING FIELD-SYMBOL(<lst_eord>) WITH KEY matnr = <lst_mara>-matnr
                                                                     werks = lst_final-werks
                                                                     autet = lc_autet.
*Binary Search is not possible according to the conditions
    IF sy-subrc EQ 0.
      lst_final-werks  = <lst_eord>-werks.
*Printer_
      READ TABLE fp_i_lfa1 ASSIGNING FIELD-SYMBOL(<lst_lfa1>) WITH KEY lifnr = <lst_eord>-lifnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-printr = <lst_lfa1>-name1.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0


    READ TABLE fp_i_eord ASSIGNING <lst_eord> WITH KEY matnr = <lst_mara>-matnr
                                                       werks = lst_final-werks
                                                       flifn = abap_true.
*Binary Search is not possible according to the conditions
    IF sy-subrc EQ 0.
* Begin of Change Defect 2002
*      lst_final-expcode = <lst_eord>-lifnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <lst_eord>-lifnr
        IMPORTING
          output = lst_final-expcode.
* End of Change Defect 2002
      lst_final-werks  = <lst_eord>-werks.
    ENDIF. " IF sy-subrc EQ 0

*Special Shipping Instructions
    lv_name = <lst_mara>-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = lc_id
        language                = lc_en
        name                    = lv_name
        object                  = lc_object
        archive_handle          = 0
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
    IF sy-subrc = 0 AND li_lines[] IS NOT INITIAL.
      LOOP AT li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>).
        CONCATENATE lv_string <lst_lines>-tdline INTO lv_string SEPARATED BY space.
      ENDLOOP. " LOOP AT li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>)
    ENDIF. " IF sy-subrc = 0 AND li_lines[] IS NOT INITIAL

    lst_final-mat_txt = lv_string.
    CONDENSE lst_final-mat_txt.
*BOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
    IF <lst_mara>-ntgew IS NOT INITIAL.
      lst_final-ntgew   = <lst_mara>-ntgew. " Net Weight
      CONDENSE lst_final-ntgew.
    ENDIF.
*EOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
    CLEAR: lv_string,
           lv_matnr.
    APPEND lst_final TO fp_i_final.
    CLEAR: lst_final.
*    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_mara

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SALES_DATA
*&---------------------------------------------------------------------*
*       Get Data from VBAP  and VBAK table
*----------------------------------------------------------------------*
*  USING    fp_i_mara
*  CHANGING fp_i_vbap
*           fp_i_vbak
*----------------------------------------------------------------------*
FORM f_get_sales_data  USING    fp_i_mara TYPE tty_mara
                       CHANGING fp_i_vbap TYPE tty_vbap
                                fp_i_vbak TYPE tty_vbak.

  DATA: lst_vbap        TYPE ty_vbap,
        lv_tot_qty      TYPE kwmeng,         " Cumulative Order Quantity in Sales Units
        lst_ord_qty     TYPE ty_ord_qty,
        lst_vbap_orders TYPE ty_vbap_orders.

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

*Fetching Data from VBAP Table
    SELECT vbeln  " Sales Document
           posnr  " Sales Document Item
           matnr  " Material Number
           kwmeng " Order Quantity
           vgbel  " Document number of the reference document
           vgpos  " Item number of the reference item
           vgtyp  " Document category of preceding SD document
      FROM vbap   " Sales Document: Item Data
      INTO TABLE fp_i_vbap
      FOR ALL ENTRIES IN fp_i_mara
      WHERE matnr = fp_i_mara-matnr.
    IF sy-subrc EQ 0.
*  Suitable table error handling will be taken care in next steps
    ENDIF. " IF sy-subrc EQ 0
    IF fp_i_vbap IS NOT INITIAL .

      SORT fp_i_vbap[] BY vbeln posnr.

*Fetching Data from VBAK Table
      SELECT vbeln " Sales Document
             auart " Sales Document Type
        FROM vbak  " Sales Document: Header Data
        INTO TABLE fp_i_vbak
        FOR ALL ENTRIES IN fp_i_vbap
        WHERE vbeln = fp_i_vbap-vbeln.
      IF sy-subrc EQ 0.
        SORT fp_i_vbak[] BY vbeln.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF fp_i_vbap IS NOT INITIAL

* To get the direct sales order for which contract doesn't exist.
* Get from VBAP for VGTYP is not equal to G and with that orders go to VBEP to get the actual confirmed quantity.
    LOOP AT i_vbap INTO lst_vbap.
      lst_vbap_orders-matnr = lst_vbap-matnr.
      lst_vbap_orders-vbeln = lst_vbap-vbeln.
      lst_vbap_orders-posnr = lst_vbap-posnr.
      lst_vbap_orders-kwmeng = lst_vbap-kwmeng.
      APPEND lst_vbap_orders TO i_vbap_orders.
      CLEAR lst_vbap_orders.
    ENDLOOP. " LOOP AT i_vbap INTO lst_vbap

    SORT i_vbap_orders BY matnr vbeln posnr.

    CLEAR: lv_tot_qty.

    CLEAR lst_vbap_orders.
    LOOP AT i_vbap_orders INTO lst_vbap_orders.
      lv_tot_qty  = lv_tot_qty + lst_vbap_orders-kwmeng.
      AT END OF matnr.
        lst_ord_qty-matnr = lst_vbap_orders-matnr.
        lst_ord_qty-kwmeng = lv_tot_qty.
        APPEND lst_ord_qty TO i_ord_qty.
        CLEAR: lv_tot_qty,
               lst_ord_qty.
      ENDAT.
    ENDLOOP. " LOOP AT i_vbap_orders INTO lst_vbap_orders

  ENDIF. " IF fp_i_mara IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_JKSESCHED
*&---------------------------------------------------------------------*
*      Get Data From JKSESCHED Table
*----------------------------------------------------------------------*
*    USING    fp_i_vbap
*    CHANGING fp_i_jksesched
*             fp_i_jksesched_x
*             fp_i_vbep
*----------------------------------------------------------------------*
FORM f_get_jksesched  USING    fp_i_mara            TYPE tty_mara.


  DATA: li_jksesched    TYPE STANDARD TABLE OF ty_jksesched,
        li_jksesched_x  TYPE STANDARD TABLE OF ty_jksesched,
        li_issue_tmp_x  TYPE STANDARD TABLE OF ty_issue,
        lst_jkschtmp    TYPE ty_jksesched,
        lst_issue_tmp   TYPE ty_issue,
        lst_issue       TYPE ty_issue,
        lv_issue        TYPE ismmatnr_issue, " Media Issue
        lv_quantity_sum TYPE jmquantity.     " Target quantity in sales units

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

*Fetching Data from JKSESCHED Table
    SELECT vbeln          " Sales and Distribution Document Number
           posnr          " Item number of the SD document
           issue          " Media Issue
           product        " Media Product
           sequence       " IS-M: Sequence
           quantity       " Target quantity in sales units
           xorder_created " IS-M: Indicator Denoting that Order Was Generated
      FROM jksesched      " IS-M: Media Schedule Lines
      INTO TABLE li_jksesched
      FOR ALL ENTRIES IN fp_i_mara
      WHERE issue = fp_i_mara-matnr.

    IF sy-subrc EQ 0.
      DELETE li_jksesched WHERE xorder_created EQ abap_true.
      SORT li_jksesched[] BY issue. "vblen posnr.
      li_jksesched_x[] = li_jksesched[].

*--------------------------------------------------------------------*
*      ZMENGE2
*--------------------------------------------------------------------*
      LOOP AT li_jksesched_x INTO lst_jkschtmp.
        lst_issue_tmp-issue    =  lst_jkschtmp-issue.
        lst_issue_tmp-quantity = lst_jkschtmp-quantity.
        APPEND lst_issue_tmp TO li_issue_tmp_x.
        CLEAR lst_issue_tmp.
      ENDLOOP. " LOOP AT li_jksesched_x INTO lst_jkschtmp

      LOOP AT li_issue_tmp_x INTO lst_issue_tmp.
        IF lv_issue = lst_issue_tmp-issue.
          lv_quantity_sum = lv_quantity_sum + lst_issue_tmp-quantity.
        ELSE. " ELSE -> IF lv_issue = lst_issue_tmp-issue
          CLEAR: lv_quantity_sum.
          lv_quantity_sum = lst_issue_tmp-quantity.
        ENDIF. " IF lv_issue = lst_issue_tmp-issue
        lv_issue = lst_issue_tmp-issue.

        AT END OF issue.
          lst_issue-issue = lst_issue_tmp-issue.
          lst_issue-quantity = lv_quantity_sum.
          APPEND lst_issue TO i_issue.
          CLEAR: lst_issue,
                 lv_quantity_sum.
        ENDAT.
      ENDLOOP. " LOOP AT li_issue_tmp_x INTO lst_issue_tmp

      CLEAR:  lv_quantity_sum, lv_issue.
    ENDIF.

  ENDIF. " IF fp_i_mara IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_PATH
*&---------------------------------------------------------------------*
*      For F4 Help for local file
*----------------------------------------------------------------------*
*      CHANGING fp_p_file
*----------------------------------------------------------------------*
FORM f_f4_file_path  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download

  DATA: lv_localfile TYPE localfile, " Local file for upload/download
        lv_year      TYPE char4,     " Year of type CHAR4
        lv_date      TYPE char4.     " Date of type CHAR4


*** Calling FM for F4 help
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = lv_localfile
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc EQ 0.

    fp_p_file = lv_localfile.

  ELSE. " ELSE -> IF sy-subrc EQ 0
*   Error Message
    MESSAGE ID sy-msgid  "Message Class
          TYPE c_e       "Message Type: Error
        NUMBER sy-msgno  "Message Number
          WITH sy-msgv1  "Message Variable-1
               sy-msgv2  "Message Variable-2
               sy-msgv3  "Message Variable-3
               sy-msgv4. "Message Variable-4

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA
*&---------------------------------------------------------------------*
*       To Upload and download the local file
*----------------------------------------------------------------------*
* USING fp_p_file
*       fp_i_final
*----------------------------------------------------------------------*
FORM f_upload_data  USING fp_p_file TYPE rlgrap-filename " Local file for upload/download
                          fp_i_final TYPE tty_final.
  DATA:
    lv_data   TYPE string,
    lst_final TYPE ty_final.

  DATA: lv_mon_name TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7445:02.05.2018:ED2K911988
        lv_mon_no   TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7445:02.05.2018:ED2K911988
  CONSTANTS:
    lc_separator TYPE char1  VALUE '|'.             " Separator of type CHAR1

  IF fp_p_file IS NOT INITIAL.
    CLEAR: v_date,
           v_month,
           v_year,
           v_hour,
           v_min,
           v_sec.

    v_date  = sy-datum+6(2).
    v_month = sy-datum+4(2).
    v_year  = sy-datum+0(4).
    v_hour  = sy-uzeit+0(2).
    v_min   = sy-uzeit+2(2).
    v_sec   = sy-uzeit+4(2).

    CONCATENATE fp_p_file
                c_slash
                c_flnm_jdsr
                v_year
                c_dash
                v_month
                c_dash
                v_date
                c_dash
                v_hour
                c_dash
                v_min
                c_dash
                v_sec
                c_extn_txt
             INTO fp_p_file.

    CONDENSE fp_p_file NO-GAPS.

*Uploading File into Application Server
    OPEN DATASET fp_p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc NE 0.
      MESSAGE i100 DISPLAY LIKE c_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc NE 0

    CLEAR: lst_final, lv_data.

    LOOP AT fp_i_final INTO lst_final.
* BOC - GKINTALI - 05/02/2018 - ERP-7445 - ED2K911988
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
      IF cb_date = 'X'.
        CLEAR: lv_mon_name, lv_mon_no.
        MOVE lst_final-isminitshipdate+3(2) TO lv_mon_no.
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

        CONCATENATE lst_final-isminitshipdate+0(2) c_dash
                    lv_mon_name                    c_dash
                    lst_final-isminitshipdate+6(4)
             INTO lst_final-isminitshipdate.
      ENDIF.
* EOC - GKINTALI - 05/02/2018 - ERP-7445 - ED2K911988
      CONCATENATE c_char_dquote lst_final-matnr c_char_dquote lc_separator
                  c_char_dquote lst_final-identcode c_char_dquote lc_separator
                  c_char_dquote lst_final-ismcopynr c_char_dquote lc_separator
                  c_char_dquote lst_final-issueno c_char_dquote lc_separator
                  c_char_dquote lst_final-suplimentno c_char_dquote lc_separator
* BOC - GKINTALI - 05/01/2018 - ERP-7445 - ED2K911988
* 6th column - Issue Description - should be populated as a first 15 digit of Material
                  c_char_dquote lst_final-matnr+0(15) c_char_dquote lc_separator
* EOC - GKINTALI - 05/01/2018 - ERP-7445 - ED2K911988
                  c_char_dquote lst_final-ismtitle c_char_dquote lc_separator
                  c_char_dquote lst_final-jrnltype c_char_dquote lc_separator
                  c_char_dquote lst_final-office c_char_dquote lc_separator
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*                  c_char_dquote lst_final-ismpubldate c_char_dquote lc_separator
                  c_char_dquote lst_final-isminitshipdate c_char_dquote lc_separator
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
                  c_char_dquote lst_final-zmenge1 c_char_dquote lc_separator
                  c_char_dquote lst_final-zmenge2 c_char_dquote lc_separator
                  c_char_dquote lst_final-zmenge3 c_char_dquote lc_separator
                  c_char_dquote lst_final-eblstock c_char_dquote lc_separator
                  c_char_dquote lst_final-zmenge4 c_char_dquote lc_separator
                  c_char_dquote lst_final-productline c_char_dquote lc_separator
                  c_char_dquote lst_final-printr c_char_dquote lc_separator
                  c_char_dquote lst_final-oflflag c_char_dquote lc_separator
                  c_char_dquote lst_final-expcode c_char_dquote lc_separator
                  c_char_dquote lst_final-mat_txt c_char_dquote lc_separator
*BOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
                  c_char_dquote lst_final-ntgew c_char_dquote lc_separator
*EOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
      INTO lv_data.


*TRANSFER moves the above fields from workarea to file  with comma
*delimited format
      TRANSFER lv_data TO fp_p_file.
      CLEAR: lst_final, lv_data.
    ENDLOOP. " LOOP AT fp_i_final INTO lst_final
* close the file
    CLOSE DATASET fp_p_file.
    IF sy-subrc IS INITIAL . "AND lv_answer EQ lc_yes.
      MESSAGE s003.
      LEAVE LIST-PROCESSING.
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
      MESSAGE s088  DISPLAY LIKE c_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_DATA
*&---------------------------------------------------------------------*
*       To Calucate data
*----------------------------------------------------------------------*
*    USING    fp_i_mara
*             fp_i_mver
*             fp_i_mapr
*             fp_i_prop
*             fp_i_prow
*             fp_i_eban
*             fp_i_ekpo
*             fp_i_vbap
*             fp_i_jksesched
*             fp_i_jksesched_x
*             fp_i_vbep
*    CHANGING fp_i_calc_tab
*----------------------------------------------------------------------*
FORM f_calculate_data  USING  fp_i_mara             TYPE tty_mara
                              fp_i_mver             TYPE tty_mver
                              fp_i_marc             TYPE tty_marc
                              fp_i_mapr             TYPE tty_mapr
                              fp_i_prow_sum         TYPE tty_prow_sum
                              fp_i_eban             TYPE tty_eban
                              fp_i_eban_zmenge1     TYPE tty_eban
                              fp_i_ekpo             TYPE tty_ekpo
                              fp_i_issue            TYPE tty_issue
                              fp_i_zqtc_inven_recon TYPE tty_zqtc_inven_recon
                              fp_i_plaf             TYPE tty_plaf
                     CHANGING fp_i_calc_tab         TYPE tty_calc_tab
                              fp_i_prop             TYPE tty_prop.
  DATA:
    lst_marc            TYPE ty_marc,
    lst_calc_tab        TYPE ty_calc_tab,
    lst_eban            TYPE ty_eban,
    li_eban_tmp         TYPE STANDARD TABLE OF ty_eban,
    li_eban_zmenge4     TYPE STANDARD TABLE OF ty_eban,
    li_zqtc_inven_recon TYPE tty_zqtc_inven_recon.

  li_eban_tmp[] = fp_i_eban_zmenge1[].

  SORT li_eban_tmp BY matnr.
  li_eban_zmenge4[] = fp_i_eban[].

* DELETE li_eban_zmenge4[] WHERE frgzu EQ abap_false.  " Defect ERP-1976

  SORT li_eban_zmenge4 BY matnr.
  li_zqtc_inven_recon[] = fp_i_zqtc_inven_recon[].
  SORT li_zqtc_inven_recon BY matnr.

  SORT fp_i_prop BY pnum1.

  SORT fp_i_mapr BY matnr werks. "++ GKINTALI:ERP-7445:04.05.2018:ED2K912012
* Populating table with calculation fields for jounral dispatch

  LOOP AT fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>).
    lst_calc_tab-matnr = <lst_mara>-matnr.

    READ TABLE i_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
      lst_calc_tab-werks = <lst_mvke>-dwerk.
    ENDIF.
    IF <lst_mvke> IS ASSIGNED.
      READ TABLE fp_i_marc INTO lst_marc WITH KEY matnr = <lst_mara>-matnr
                                                  werks = <lst_mvke>-dwerk.
    ENDIF.

*---------------ZMENGE4--------------------------------------------*
* Calculation for conference & exhibition

    IF li_eban_zmenge4 IS NOT INITIAL.
* Parellel cursor has been used here for eban
      READ TABLE li_eban_zmenge4 TRANSPORTING NO FIELDS WITH KEY matnr = <lst_mara>-matnr
      BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT li_eban_zmenge4 FROM sy-tabix INTO lst_eban WHERE matnr = <lst_mara>-matnr.
          lst_calc_tab-zmenge4 = lst_calc_tab-zmenge4 + lst_eban-menge.
        ENDLOOP. " LOOP AT li_eban_zmenge4 FROM sy-tabix INTO lst_eban WHERE matnr = <lst_mara>-matnr
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_eban_zmenge4 IS NOT INITIAL

*--------------ZMENGE1------------------------------------------------------*
* Calculation of Print run for Purchase Order Created
*  Begin of Change Defect ERP-1976
*    READ TABLE fp_i_ekpo ASSIGNING FIELD-SYMBOL(<lst_ekpo>) WITH KEY matnr = <lst_mara>-matnr BINARY SEARCH.
*    IF sy-subrc = 0.
*      lst_calc_tab-zmenge1 = <lst_ekpo>-menge.
*    ENDIF. " IF sy-subrc = 0
    LOOP AT fp_i_ekpo ASSIGNING FIELD-SYMBOL(<lst_ekpo>) WHERE matnr = <lst_mara>-matnr.
      lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + <lst_ekpo>-menge.
    ENDLOOP.
*  End of Change Defect ERP-1976

* Calculation of Print run for Purchase Requisition.
    IF lst_calc_tab-zmenge1 IS INITIAL.
* pareller cursor has been used.
      READ TABLE li_eban_tmp TRANSPORTING NO FIELDS WITH KEY matnr = <lst_mara>-matnr
      BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT li_eban_tmp FROM sy-tabix INTO lst_eban WHERE matnr = <lst_mara>-matnr.
* Begin of Change Defect 1976
*          lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + lst_eban-menge.
          IF lst_eban-frgzu = abap_true AND lst_eban-frgst IS NOT INITIAL.
            lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + lst_eban-menge.
          ELSEIF lst_eban-frgzu IS INITIAL AND lst_eban-frgst IS INITIAL.
            lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + lst_eban-menge.
          ENDIF.
* End of Change Defect 1976
          CLEAR: lst_eban.
        ENDLOOP. " LOOP AT li_eban_tmp FROM sy-tabix INTO lst_eban WHERE matnr = <lst_mara>-matnr
        lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + lst_calc_tab-zmenge4. " PR quantity + Conference Quantity
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_calc_tab-zmenge1 IS INITIAL

* Calculation of Print run for Planned Order
    IF lst_calc_tab-zmenge1 IS INITIAL.
      READ TABLE fp_i_plaf ASSIGNING FIELD-SYMBOL(<lst_plaf>) WITH KEY matnr = <lst_mara>-matnr
                                                                       plwrk = lst_calc_tab-werks.
      " BINARY SEARCH. "-- GKINTALI:ERP-7445:04.05.2018:ED2K912012
      IF sy-subrc EQ 0.
        lst_calc_tab-zmenge1 = <lst_plaf>-gsmng + lst_calc_tab-zmenge4.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lst_calc_tab-zmenge1 IS INITIAL

* Calculation of Print run for Forecasting
    IF lst_calc_tab-zmenge1 IS INITIAL.
      READ TABLE fp_i_mapr ASSIGNING FIELD-SYMBOL(<lst_mapr>) WITH KEY matnr = <lst_mara>-matnr
                                                                       werks = lst_calc_tab-werks BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE fp_i_prop ASSIGNING FIELD-SYMBOL(<lst_prop>) WITH KEY pnum1 = <lst_mapr>-pnum1 BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE fp_i_prow_sum ASSIGNING FIELD-SYMBOL(<lst_prow>) WITH KEY pnum2 = <lst_prop>-pnum2 BINARY SEARCH.
          IF sy-subrc = 0.
            lst_calc_tab-zmenge1 = <lst_prow>-koprw + lst_calc_tab-zmenge4. "	Forecasting Quantity + Conference Quantity
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF lst_calc_tab-zmenge1 IS INITIAL
* Calculation of Print run for Historical consumption
    IF lst_calc_tab-zmenge1 IS INITIAL.
      READ TABLE fp_i_mver ASSIGNING FIELD-SYMBOL(<lst_mver>) WITH KEY matnr = lst_marc-vrbmt.
      IF sy-subrc = 0.
        IF <lst_mver>-perkz EQ lst_marc-perkz.
          lst_calc_tab-zmenge1 = <lst_mver>-mgv01 + <lst_mver>-mgv02 + <lst_mver>-mgv03 + <lst_mver>-mgv04
                               + <lst_mver>-mgv05 + <lst_mver>-mgv06 + <lst_mver>-mgv07 + <lst_mver>-mgv08
                               + <lst_mver>-mgv09 + <lst_mver>-mgv10 + <lst_mver>-mgv11 + <lst_mver>-mgv12.

        ENDIF. " IF <lst_mver>-perkz NE space
      ENDIF. " IF sy-subrc = 0
      lst_calc_tab-zmenge1 = lst_calc_tab-zmenge1 + lst_calc_tab-zmenge4. " Consumption Quantity + Conference Quantity
    ENDIF. " IF lst_calc_tab-zmenge1 IS INITIAL

*---------------ZMENGE2--------------------------------------------*
* calculation of Estimated Subscription
    READ TABLE fp_i_issue ASSIGNING FIELD-SYMBOL(<lst_jksesched>) WITH KEY issue = <lst_mara>-matnr.
    IF sy-subrc = 0.
      lst_calc_tab-zmenge2 = <lst_jksesched>-quantity.
    ENDIF. " IF sy-subrc = 0

    READ TABLE i_ord_qty ASSIGNING FIELD-SYMBOL(<lst_ord_qty>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
      lst_calc_tab-zmenge2 = lst_calc_tab-zmenge2 + <lst_ord_qty>-kwmeng.
    ENDIF. " IF sy-subrc EQ 0
*---------------ZMENGE3--------------------------------------------*

* Parellel cursor has been used.
    READ TABLE fp_i_zqtc_inven_recon ASSIGNING FIELD-SYMBOL(<lst_zqtc_inven_recon>)
                                      WITH KEY  ismrefmdprod = <lst_mara>-ismrefmdprod.
    IF sy-subrc EQ 0.
      READ TABLE li_zqtc_inven_recon TRANSPORTING NO FIELDS WITH KEY  matnr = <lst_zqtc_inven_recon>-matnr.
      IF sy-subrc EQ 0.
        LOOP AT li_zqtc_inven_recon ASSIGNING FIELD-SYMBOL(<lst_zqtc_inven_recon1>)
                                       FROM sy-tabix WHERE matnr = <lst_zqtc_inven_recon>-matnr.
          lst_calc_tab-zmenge3 = lst_calc_tab-zmenge3 + <lst_zqtc_inven_recon1>-zoffline.
        ENDLOOP. " LOOP AT li_zqtc_inven_recon ASSIGNING FIELD-SYMBOL(<lst_zqtc_inven_recon1>)
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

    APPEND lst_calc_tab TO fp_i_calc_tab.
    CLEAR: lst_calc_tab.
  ENDLOOP. " LOOP AT fp_i_marc INTO lst_marc

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .

  CONSTANTS: lc_devid_i0268  TYPE zdevid VALUE 'I0268'. " Development ID
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid  = lc_devid_i0268
    AND activate = abap_true.

  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1
                       param2.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_MVKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_MARA  text
*      <--P_I_MVKE  text
*----------------------------------------------------------------------*
FORM f_get_data_mvke  USING    fp_i_mara TYPE tty_mara
                      CHANGING fp_i_mvke TYPE tty_mvke.

*As matnr is the primary key of MARA so we will always get unique record when comparing with matnr
*so delete adjacent duplicates comparing matnr not required.
  IF fp_i_mara IS NOT INITIAL.

    SELECT matnr " Material Number
           vkorg " Sales Organization
           vtweg " Distribution Channel
           dwerk " Delivering Plant (Own or External)
    FROM mvke    " Sales Data for Material
    INTO TABLE fp_i_mvke
    FOR ALL ENTRIES IN fp_i_mara
    WHERE matnr = fp_i_mara-matnr.
    IF sy-subrc EQ 0.
      SORT fp_i_mvke BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_T024X
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_MARA  text
*      <--P_I_T024X  text
*----------------------------------------------------------------------*
FORM f_get_data_t024x  USING    fp_i_mara TYPE tty_mara
                       CHANGING fp_i_t024x TYPE tty_t024x.
  DATA: li_mara_tmp TYPE tty_mara.

  li_mara_tmp[] = fp_i_mara[].
  SORT li_mara_tmp BY labor.
  DELETE ADJACENT DUPLICATES FROM li_mara_tmp COMPARING labor.

  IF li_mara_tmp IS NOT INITIAL.
    SELECT spras " Language Key
           labor " Laboratory/design office
           lbtxt " Description of the laboratory/engineering office
      FROM t024x " Laboratory/Office Texts
      INTO TABLE fp_i_t024x
      FOR ALL ENTRIES IN li_mara_tmp
      WHERE labor = li_mara_tmp-labor
      AND spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT fp_i_t024x[] BY labor.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mara_tmp IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_CEPCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_MARC  text
*      <--P_I_CEPCT  text
*----------------------------------------------------------------------*
FORM f_get_data_cepct  USING    fp_i_marc  TYPE tty_marc
                       CHANGING fp_i_cepct TYPE tty_cepct.

  DATA: li_marc_tmp TYPE tty_marc.

  li_marc_tmp[] = fp_i_marc[].
  SORT li_marc_tmp BY prctr.
  DELETE ADJACENT DUPLICATES FROM li_marc_tmp COMPARING prctr.

  IF li_marc_tmp IS NOT INITIAL.
    SELECT spras " Language Key
           prctr " Profit Center
           datbi " Valid To Date
           kokrs " Controlling Area
           ktext " General Name
    FROM cepct   " Sales Data for Material
    INTO TABLE fp_i_cepct
    FOR ALL ENTRIES IN li_marc_tmp
    WHERE prctr = li_marc_tmp-prctr
      AND spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT fp_i_cepct BY prctr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_marc_tmp IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATRN
*&---------------------------------------------------------------------*
*       Validation material number
*----------------------------------------------------------------------*
FORM f_validate_matrn .
  IF s_matnr IS NOT INITIAL.
    SELECT
      matnr     " Material Number
      FROM mara " General Material Data
      INTO @DATA(lv_matnr)
      UP TO 1 ROWS
      WHERE matnr IN @s_matnr.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE e137 WITH lv_matnr.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF s_matnr IS NOT INITIAL


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA_WMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_MARA  text
*      -->P_I_MAKT  text
*      -->P_I_CEPCT  text
*      -->P_I_T024X  text
*      -->P_I_JPTIDCDASSIGN  text
*      -->P_I_EORD  text
*      -->P_I_LFA1  text
*      -->P_I_MARC  text
*      -->P_I_CALC_TAB  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_process_data_wms  USING     fp_i_mara              TYPE tty_mara
                                   fp_i_makt              TYPE tty_makt
                                   fp_i_t024x             TYPE tty_t024x
                                   fp_i_jptidcdassign     TYPE tty_jptidcdassign
                                   fp_i_jptidcdassign_wms TYPE tty_jptidcdassign
                                   fp_i_marc              TYPE tty_marc
                                   fp_i_calc_tab          TYPE tty_calc_tab
                  CHANGING         fp_i_final             TYPE tty_final.

  TYPES: BEGIN OF lty_ismissue_type,
           sign   TYPE char1,           " Sign of type CHAR1
           option TYPE char2,           " Option of type CHAR2
           low    TYPE ismausgvartyppl, " Material Number
           high   TYPE ismausgvartyppl, " Material Number
         END OF lty_ismissue_type.

  DATA:
    lv_issue          TYPE string,
    lv_supp           TYPE string,
    lv_len            TYPE i,                                      " Len of type Integers
    lst_marc          TYPE ty_marc,
    lst_final         TYPE ty_final,
    lir_ismissue_type TYPE TABLE OF lty_ismissue_type,
    lst_ismissue_type TYPE  lty_ismissue_type,
    lv_matnr          TYPE  matnr.                                 " Material Number

  CONSTANTS: lc_param1_ismissue_type TYPE rvari_vnam VALUE 'ISMISSUETYPEST'.     " ABAP: Name of Variant Variable

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_param1_ismissue_type.
        lst_ismissue_type-sign   = <lst_constant>-sign.
        lst_ismissue_type-option = <lst_constant>-opti .
        lst_ismissue_type-low    = <lst_constant>-low.
        lst_ismissue_type-high   = <lst_constant>-high.
        APPEND lst_ismissue_type TO lir_ismissue_type.
        CLEAR: lst_ismissue_type.
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)

*Populating Final Table
  LOOP AT fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>).
*Issue Material Number
    lst_final-matnr          = <lst_mara>-matnr.

    READ TABLE i_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc EQ 0.
      lst_final-werks      = <lst_mvke>-dwerk.
    ENDIF.
*Issue Number
    CLEAR: lv_issue,
           lv_len.
    lv_matnr = <lst_mara>-matnr.

    lv_issue = lv_matnr+8(7).

*Title Description
    lst_final-ismtitle       = <lst_mara>-ismtitle.

*Expected Delivery Date
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*    CONCATENATE <lst_mara>-ismpubldate+6(2) <lst_mara>-ismpubldate+4(2)
*                <lst_mara>-ismpubldate+0(4) INTO lst_final-ismpubldate.
    CONCATENATE <lst_mara>-isminitshipdate+6(2) <lst_mara>-isminitshipdate+4(2)
                    <lst_mara>-isminitshipdate+0(4) INTO lst_final-isminitshipdate.
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

*Volume Number
    lst_final-ismcopynr      = <lst_mara>-ismcopynr.
    lst_final-ismyearnr      = <lst_mara>-ismyearnr.

*Supplement Number
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*    IF <lst_mara>-ismissuetypest IS NOT INITIAL.
*      CLEAR lv_supp.
*      lv_len  = strlen( lv_issue ).
*      IF lv_len GT 1.
*        lst_final-suplimentno = <lst_mara>-matnr+8(lv_len).
*      ELSEIF lv_len EQ 1.
*        lst_final-suplimentno = <lst_mara>-matnr+8(1).
*      ENDIF.
*
**Journal Type
*      lst_final-jrnltype = c_jtyp_supp.
*    ELSEIF <lst_mara>-ismissuetypest = c_char_blank.
*
**Journal Type
*      lst_final-jrnltype = c_jtyp_iss.
*      lst_final-issueno  = lv_matnr+8(7).
*    ENDIF. " IF <lst_mara>-ismissuetypest IN lir_ismissue_type
    CLEAR: lv_issue,
           lv_len.
    lv_issue = lv_matnr+8(7).
    lv_len  = strlen( lv_issue ).
    IF lv_matnr+8(1) = c_char_s.
      lst_final-suplimentno = lv_matnr+8(lv_len).
*Journal Type
      lst_final-jrnltype = c_jtyp_supp.
    ELSE.
      lst_final-issueno  = lv_matnr+8(lv_len).
*Journal Type
      lst_final-jrnltype = c_jtyp_iss.
    ENDIF.
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

*Issue Description
    READ TABLE fp_i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>) WITH KEY matnr = <lst_mara>-matnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-maktx = <lst_makt>-maktx.
    ENDIF. " IF sy-subrc EQ 0
*Journal Code
    READ TABLE fp_i_jptidcdassign ASSIGNING FIELD-SYMBOL(<lst_jptidcdassign>) WITH KEY matnr = <lst_mara>-matnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-identcode = <lst_jptidcdassign>-identcode.
    ENDIF. " IF sy-subrc EQ 0

*Office
    READ TABLE fp_i_t024x ASSIGNING FIELD-SYMBOL(<lst_t024x>) WITH KEY labor = <lst_mara>-labor BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-office = <lst_t024x>-lbtxt.
    ENDIF. " IF sy-subrc EQ 0
*Calculations
    READ TABLE fp_i_calc_tab ASSIGNING FIELD-SYMBOL(<lst_calc_tab>) WITH KEY matnr = <lst_mara>-matnr.
    IF sy-subrc = 0.
*Print Run
      lst_final-zmenge1 = <lst_calc_tab>-zmenge1.
      CONDENSE lst_final-zmenge1.
* ISSN
* BOC - GKINTALI - 05/01/2018 - ERP-7445
**      READ TABLE fp_i_jptidcdassign_wms ASSIGNING <lst_jptidcdassign> WITH KEY matnr = <lst_mara>-matnr BINARY SEARCH.
      READ TABLE fp_i_jptidcdassign_wms ASSIGNING <lst_jptidcdassign> WITH KEY matnr = <lst_mara>-ismrefmdprod BINARY SEARCH.
* EOC - GKINTALI - 05/01/2018 - ERP-7445
      IF sy-subrc EQ 0.
        lst_final-issn = <lst_jptidcdassign>-identcode.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc = 0
    APPEND lst_final TO fp_i_final.
    CLEAR: lst_final.

  ENDLOOP. " LOOP AT fp_i_marc INTO lst_marc

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA_WMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      -->P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_upload_data_wms  USING   fp_p_file TYPE rlgrap-filename " Local file for upload/download
                                fp_i_final TYPE tty_final.
  DATA:
    lv_data   TYPE string,
    lv_sydate TYPE char11, "datum, "++ HIPATEL:ERP-7445:02.05.2018:ED2K911988
    lst_final TYPE ty_final.
  DATA: lv_mon_name TYPE char3, " 3-char Month Name "++ GKINTALI:ERP-7445:02.05.2018:ED2K911988
        lv_mon_no   TYPE fcmnr. " Month Number      "++ GKINTALI:ERP-7445:02.05.2018:ED2K911988
  CONSTANTS:
    lc_separator TYPE char1      VALUE ',',            " Separator of type CHAR1
    lc_u         TYPE char1      VALUE 'U',            " U of type CHAR1
    lc_0         TYPE char1      VALUE '0'.            " 0 of type CHAR1

  IF fp_p_file IS NOT INITIAL.
    CLEAR: v_date,
           v_month,
           v_year,
           v_hour,
           v_min,
           v_sec.

    v_date  = sy-datum+6(2).
    v_month = sy-datum+4(2).
    v_year  = sy-datum+0(4).
    v_hour  = sy-uzeit+0(2).
    v_min   = sy-uzeit+2(2).
    v_sec   = sy-uzeit+4(2).

    CONCATENATE fp_p_file
                c_slash
                c_flnm_wms
                v_year
                c_dash
                v_month
                c_dash
                v_date
                c_dash
                v_hour
                c_dash
                v_min
                c_dash
                v_sec
                c_extn_dat
             INTO fp_p_file.

    CONDENSE fp_p_file NO-GAPS.

*Uploading File into Application Server
    OPEN DATASET fp_p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc NE 0.
      MESSAGE i100 DISPLAY LIKE c_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc NE 0

    CLEAR: lst_final, lv_data.

    CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) INTO lv_sydate.

    LOOP AT fp_i_final INTO lst_final.
* BOC - GKINTALI - 05/02/2018 - ERP-7445 - ED2K911988
* If the check box is selected, then the date format should be changed to DD-MMM-YYYY
      IF cb_date = 'X'.
        CLEAR: lv_mon_name, lv_mon_no.
        MOVE lst_final-isminitshipdate+2(2) TO lv_mon_no.
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

        CONCATENATE lst_final-isminitshipdate+0(2) c_dash
                    lv_mon_name                    c_dash
                    lst_final-isminitshipdate+4(4)
             INTO lst_final-isminitshipdate.

***If the check box is selected, then the date format should be changed to DD-MMM-YYYY
        IF sy-tabix = 1.
          CLEAR: lv_mon_name, lv_mon_no.
          MOVE lv_sydate+2(2) TO lv_mon_no.
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
*          Implement suitable error handling here
          ENDIF.

          CONCATENATE lv_sydate+0(2) c_dash
                      lv_mon_name    c_dash
                      lv_sydate+4(4)
               INTO lv_sydate.
        ENDIF.
      ENDIF.
* EOC - GKINTALI - 05/02/2018 - ERP-7445 - ED2K911988
      CONCATENATE c_char_dquote lc_u c_char_dquote lc_separator
                  c_char_dquote lst_final-identcode c_char_dquote lc_separator
                  c_char_dquote lst_final-matnr c_char_dquote lc_separator
* BOC - GKINTALI - 05/01/2018 - ERP-7445
* 4th column - Issue Description - should be populated as a first 15 digit of Material
                  c_char_dquote lst_final-matnr+0(15) c_char_dquote lc_separator
* EOC - GKINTALI - 05/01/2018 - ERP-7445
                  c_char_dquote lst_final-ismtitle c_char_dquote lc_separator
                  c_char_dquote lst_final-ismcopynr c_char_dquote lc_separator
                  c_char_dquote lst_final-issueno c_char_dquote lc_separator
                  c_char_dquote lst_final-suplimentno c_char_dquote lc_separator
                  c_char_dquote lc_0 c_char_dquote lc_separator
                  c_char_dquote lst_final-office c_char_dquote lc_separator
                  c_char_dquote lc_0 c_char_dquote lc_separator
                  c_char_dquote lc_0 c_char_dquote lc_separator
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*                  c_char_dquote lst_final-ismpubldate c_char_dquote lc_separator
*                  c_char_dquote lst_final-ismpubldate c_char_dquote lc_separator
* BOC : PBANDLAPAL : 20-Sep-2017 : ERP-4602: ED2K908623
*                  c_char_dquote lst_final-ismpubtype c_char_dquote lc_separator
                  c_char_dquote lst_final-isminitshipdate c_char_dquote lc_separator
* EOC : PBANDLAPAL : 20-Sep-2017 : ERP-4602 : ED2K908623
                  c_char_dquote lst_final-isminitshipdate c_char_dquote lc_separator
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
                  c_char_dquote lv_sydate c_char_dquote lc_separator
                  c_char_dquote lst_final-zmenge1 c_char_dquote lc_separator
                  c_char_dquote lst_final-issn c_char_dquote lc_separator
                  c_char_dquote lst_final-ismyearnr c_char_dquote
      INTO lv_data.

*TRANSFER moves the above fields from workarea to file  with comma
*delimited format

      TRANSFER lv_data TO fp_p_file.
      CLEAR: lst_final, lv_data.

    ENDLOOP. " LOOP AT fp_i_final INTO lst_final
* close the file
    CLOSE DATASET fp_p_file.
    IF sy-subrc IS INITIAL . "AND lv_answer EQ lc_yes.
      MESSAGE s003.     "File uploaded Successfully
      LEAVE LIST-PROCESSING.
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
      MESSAGE s088  DISPLAY LIKE c_e.   "File not Uploaded Successfully!!!
      LEAVE LIST-PROCESSING.

    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF.

ENDFORM.
