*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPLD_TABLE_SLS_REP_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPLD_TABLE_SLS_REP_SEL (Subroutines)
* PROGRAM DESCRIPTION: Maintain Sales Rep PIGS Table Lookup
* DEVELOPER: Mintu Naskar (MNASKAR)
* CREATION DATE:   11/04/2016
* OBJECT ID:  E129
* TRANSPORT NUMBER(S):  ED2K903251
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909197
* REFERENCE NO: ERP-4832
* DEVELOPER: Writtick Roy (WROY)
* DATE:  10/26/2017
* DESCRIPTION: Format Validation for Validity Dates
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909690
* REFERENCE NO: ERP-4832
* DEVELOPER: Writtick Roy (WROY)
* DATE:  12/03/2017
* DESCRIPTION: Add logic for Sales Rep Validation
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913679
* REFERENCE NO: ERP-7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 08-JAN-2019
* DESCRIPTION: Additon of new fields: 'Po Type', 'Ship-to party'
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download

* Popup for file path
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file "File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_convert_excel  USING    fp_p_file   TYPE rlgrap-filename " Local file for upload/download
                      CHANGING fp_i_final  TYPE tt_excel.

  DATA: li_excel        TYPE STANDARD TABLE OF alsmex_tabline INITIAL SIZE 0, " Rows for Table with Excel Data
        lst_excel_dummy TYPE                   alsmex_tabline,                " Rows for Table with Excel Data
        lst_excel       TYPE                   alsmex_tabline,                " Rows for Table with Excel Data
        lst_final       TYPE ty_excel.


  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = fp_p_file
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 19
      i_end_row               = 1000
    TABLES
      intern                  = li_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc EQ 0.
*    *************NOW FILL DATA FROM EXCEL INTO FINAL LEGACY DATA ITAB----***************
    IF NOT li_excel[] IS INITIAL.
      CLEAR lst_final.

      LOOP AT li_excel INTO lst_excel.
        lst_excel_dummy = lst_excel.
        IF lst_excel_dummy-value(1) EQ text-sqt.
          lst_excel_dummy-value(1) = space.
          SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
        ENDIF. " IF lst_excel_dummy-value(1) EQ text-sqt

        AT NEW col.

          CASE lst_excel_dummy-col.
            WHEN 1.
              APPEND lst_final TO fp_i_final.
              CLEAR lst_final.
              lst_final-vkorg = lst_excel_dummy-value(4).
              CLEAR lst_excel_dummy.
            WHEN 2.
              lst_final-vtweg = lst_excel_dummy-value(2).
              IF lst_final-vtweg IS INITIAL.
                lst_final-vtweg = c_00.
              ENDIF. " IF lst_final-vtweg IS INITIAL
              CLEAR lst_excel_dummy.
            WHEN 3.
              lst_final-spart = lst_excel_dummy-value(2).
              IF lst_final-spart IS INITIAL.
                lst_final-spart = c_00.
              ENDIF. " IF lst_final-spart IS INITIAL
              CLEAR lst_excel_dummy.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
            WHEN 4.
              lst_final-bsark = lst_excel_dummy-value(4).
              IF lst_final-bsark IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-bsark
                  IMPORTING
                    output = lst_final-bsark.
              ENDIF.
              IF lst_final-bsark IS INITIAL.
                lst_final-bsark = space.
              ENDIF. " IF lst_final-bsark IS INITIAL
              CLEAR lst_excel_dummy.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
            WHEN 5.
              lst_final-datab = lst_excel_dummy-value(8).
              CLEAR lst_excel_dummy.
            WHEN 6.
              lst_final-datbi = lst_excel_dummy-value(8).
              CLEAR lst_excel_dummy.
            WHEN 7.
              lst_final-matnr = lst_excel_dummy-value(18).
              IF lst_final-matnr IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                  EXPORTING
                    input        = lst_final-matnr
                  IMPORTING
                    output       = lst_final-matnr
                  EXCEPTIONS
                    length_error = 1
                    OTHERS       = 2.
                IF sy-subrc NE 0.
*                 Do Nothing
                ENDIF. " IF sy-subrc NE 0
              ENDIF. " IF lst_final-matnr IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 8.
              lst_final-prctr = lst_excel_dummy-value(10).
              IF lst_final-prctr IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-prctr
                  IMPORTING
                    output = lst_final-prctr.
              ENDIF. " IF lst_final-prctr IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 9.
              lst_final-kunnr = lst_excel_dummy-value(10).
              IF lst_final-kunnr IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-kunnr
                  IMPORTING
                    output = lst_final-kunnr.
              ENDIF. " IF lst_final-kunnr IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 10.
              lst_final-kvgr1 = lst_excel_dummy-value(3).
              CLEAR lst_excel_dummy.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
            WHEN 11.
              lst_final-zship_to = lst_excel_dummy-value(10).
              CLEAR lst_excel_dummy.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
            WHEN 12.
              lst_final-pstlz_f = lst_excel_dummy-value(10).
              CLEAR lst_excel_dummy.
            WHEN 13.
              lst_final-pstlz_t = lst_excel_dummy-value(10).
              CLEAR lst_excel_dummy.
            WHEN 14.
              lst_final-regio  = lst_excel_dummy-value(3).
              CLEAR lst_excel_dummy.
            WHEN 15.
              lst_final-land1 = lst_excel_dummy-value(3).
              CLEAR lst_excel_dummy.
            WHEN 16.
              lst_final-srep1 = lst_excel_dummy-value(8).
              CLEAR lst_excel_dummy.
            WHEN 17.
              lst_final-srep2 = lst_excel_dummy-value(8).
              CLEAR lst_excel_dummy.
            WHEN 18.
              lst_final-aenam = lst_excel_dummy-value(12).
              CLEAR lst_excel_dummy.
            WHEN 19.
              lst_final-aedat = lst_excel_dummy-value(8).
              CLEAR lst_excel_dummy.
            WHEN 20.
              lst_final-aezet = lst_excel_dummy-value(6).
              CLEAR lst_excel_dummy.
            WHEN 21.
              lst_final-delete = lst_excel_dummy-value(1).
              CLEAR lst_excel_dummy.
          ENDCASE.

        ENDAT.
      ENDLOOP. " LOOP AT li_excel INTO lst_excel
* For last row population
      APPEND lst_final TO fp_i_final.
      DELETE fp_i_final WHERE vkorg IS INITIAL.
      CLEAR lst_final.

    ENDIF. " IF NOT li_excel[] IS INITIAL

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_STAUS_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FLAG  text
*      <--P_MESSAGE  text
*----------------------------------------------------------------------*
FORM f_staus_output_2    USING fp_v_reason TYPE char50   " Staus_output_2 using fp of type CHAR50
                      CHANGING fp_flag     TYPE numc4    " Count parameters
                               fp_message  TYPE char200. " Message of type CHAR200


  IF fp_flag NE c_1 AND fp_flag NE c_2.
    fp_flag = c_2. " Unable to upload
    CONCATENATE text-s05 fp_v_reason INTO fp_message SEPARATED BY space.
  ENDIF. " IF fp_flag NE c_1 AND fp_flag NE c_2

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_STAUS_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FLAG  text
*      <--P_MESSAGE  text
*----------------------------------------------------------------------*
FORM f_staus_output_3  CHANGING fp_flag    TYPE numc4    " Count parameters
                                fp_message TYPE char200. " Message of type CHAR200

  IF fp_flag NE c_1 AND fp_flag NE c_2 AND fp_flag NE c_4.
    fp_flag = c_3. " Successfully uploaded
    fp_message = text-s03.
  ENDIF. " IF fp_flag NE c_1 AND fp_flag NE c_2 AND fp_flag NE c_4

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data.

  DATA li_temp    TYPE TABLE OF ty_excel.

  IF i_final[] IS NOT INITIAL.

********validate Sales Organization
    IF i_tvko IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY vkorg.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING vkorg.
      IF li_temp[] IS NOT INITIAL.
        SELECT vkorg " Sales Organization
          FROM  tvko " Organizational Unit: Sales Organizations
          INTO TABLE i_tvko
          FOR ALL ENTRIES IN li_temp
          WHERE vkorg EQ li_temp-vkorg
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*   Message: Invalid Sales Organization Number!
          MESSAGE s012(zqtc_r2). " Invalid Sales Organization Number!
          LEAVE LIST-PROCESSING.
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_tvko IS INITIAL

********validate Distribution Channel
    IF i_tvtw IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY vtweg.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING vtweg.
      IF li_temp[] IS NOT INITIAL.
        SELECT vtweg " Distribution Channel
          FROM  tvtw " Organizational Unit: Distribution Channels
          INTO TABLE i_tvtw
          FOR ALL ENTRIES IN li_temp
          WHERE vtweg EQ li_temp-vtweg
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*   Message: Invalid Distribution Channel!
          MESSAGE s013(zqtc_r2). " Invalid Distribution Channel!
          LEAVE LIST-PROCESSING.
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_tvtw IS INITIAL

********validate Division
    IF i_tspa IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY spart.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING spart.
      IF li_temp[] IS NOT INITIAL.
        SELECT spart " Division
          FROM  tspa " Organizational Unit: Sales Divisions
          INTO TABLE i_tspa
          FOR ALL ENTRIES IN li_temp
          WHERE spart EQ li_temp-spart
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*   Message: Invalid Division!
          MESSAGE s021(zqtc_r2). " Invalid Division!
          LEAVE LIST-PROCESSING.
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_tspa IS INITIAL

********validate Material Number
    IF i_mvke IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY matnr vkorg vtweg.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING matnr vkorg vtweg.
      IF li_temp[] IS NOT INITIAL.
        SELECT matnr " Material Number
               vkorg " Sales Organization
               vtweg " Distribution Channel
          FROM mvke  " Sales Data for Material
          INTO TABLE i_mvke
          FOR ALL ENTRIES IN li_temp
          WHERE matnr EQ li_temp-matnr
            AND vkorg EQ li_temp-vkorg
            AND vtweg EQ li_temp-vtweg
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*       Do nothing
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_mvke IS INITIAL

********validate Profit Center
    IF i_cepc IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY prctr.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING prctr.
      IF li_temp[] IS NOT INITIAL.
        SELECT prctr " Profit Center
               datbi " Valid To Date
               datab " Valid-From Date
          FROM cepc  " Profit Center Master Data Table
          INTO TABLE i_cepc
          FOR ALL ENTRIES IN li_temp
          WHERE prctr EQ li_temp-prctr.
        IF sy-subrc NE 0.
*       Do nothing
        ELSE. " ELSE -> IF sy-subrc NE 0
          SORT i_cepc BY prctr.
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_cepc IS INITIAL

********validate Customer
    IF i_kna1 IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING kunnr.
      IF li_temp[] IS NOT INITIAL.
        SELECT kunnr " Customer
               land1 " Country key
          FROM kna1  " General Data in Customer Master
          INTO TABLE i_kna1
          FOR ALL ENTRIES IN li_temp
          WHERE kunnr EQ li_temp-kunnr
          ORDER BY PRIMARY KEY.
        IF sy-subrc EQ 0.
          SORT i_kna1 BY kunnr land1.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF. " IF i_kna1 IS INITIAL

    IF i_knvv IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY kunnr vkorg vtweg spart.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING kunnr vkorg vtweg spart.
      IF li_temp[] IS NOT INITIAL.
        SELECT kunnr " Customer
               vkorg " Sales Organization
               vtweg " Distribution Channel
               spart " Division
          FROM knvv  " Customer Master Sales Data
          INTO TABLE i_knvv
          FOR ALL ENTRIES IN li_temp
          WHERE kunnr EQ li_temp-kunnr
            AND vkorg EQ li_temp-vkorg
            AND vtweg EQ li_temp-vtweg
            AND spart EQ li_temp-spart
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*       Do nothing
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_knvv IS INITIAL

*** BOC: CR#7764  KKRAVURI20190127
    IF i_shipto IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY zship_to vkorg vtweg spart.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING zship_to vkorg vtweg spart.
      IF li_temp[] IS NOT INITIAL.
        SELECT kunnr " Customer
               vkorg " Sales Organization
               vtweg " Distribution Channel
               spart " Division
          FROM knvv  " Customer Master Sales Data
          INTO TABLE i_shipto
          FOR ALL ENTRIES IN li_temp
          WHERE kunnr EQ li_temp-zship_to
            AND vkorg EQ li_temp-vkorg
            AND vtweg EQ li_temp-vtweg
            AND spart EQ li_temp-spart
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*       Do nothing
        ELSEIF sy-subrc = 0.
          SORT i_shipto BY kunnr vkorg vtweg spart.
        ENDIF. " IF sy-subrc NE 0
      ENDIF. " IF li_temp[] IS NOT INITIAL
    ENDIF. " IF i_shipto IS INITIAL

    IF i_potype[] IS INITIAL.
      SELECT low FROM zcaconstant INTO TABLE i_potype
             WHERE devid = c_devid AND
                   param1 = c_param1 AND
                   param2 = c_param2 AND
                   activate = abap_true.
      IF sy-subrc NE 0.
*       Do nothing
      ELSEIF sy-subrc = 0.
        SORT i_potype BY bsark.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF i_potype IS INITIAL

    IF i_potype_t176[] IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY bsark.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING bsark.
      IF li_temp[] IS NOT INITIAL.
        SELECT bsark
          FROM t176  " Sales Documents: Customer Order Types
          INTO TABLE i_potype_t176
          FOR ALL ENTRIES IN li_temp
          WHERE bsark = li_temp-bsark.
        IF sy-subrc NE 0.
*       Do nothing
        ELSEIF sy-subrc = 0.
          SORT i_potype_t176 BY bsark.
        ENDIF. " IF sy-subrc NE 0
      ENDIF. " IF li_temp[] IS NOT INITIAL
    ENDIF. " IF i_potype_t176 IS INITIAL

*** EOC: CR#7764  KKRAVURI20190127

********validate Customer group 1
    IF i_tvv1 IS INITIAL.
      SELECT kvgr1 " Customer group 1
        FROM tvv1  " Customer Group 1
        INTO TABLE i_tvv1.
      IF sy-subrc EQ 0.
        LOOP AT i_tvv1 INTO st_tvv1.
          st_tvv1-kvgr1_2 = st_tvv1-kvgr1(2).
          st_tvv1-kvgr1_1 = st_tvv1-kvgr1(1).
          MODIFY i_tvv1 FROM st_tvv1 TRANSPORTING kvgr1_2 kvgr1_1.
          CLEAR: st_tvv1.
        ENDLOOP. " LOOP AT i_tvv1 INTO st_tvv1
        SORT i_tvv1 BY kvgr1_1 kvgr1_2 kvgr1.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF i_tvv1 IS INITIAL

********validate Region
    IF i_t005s IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY regio.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING regio.
      IF li_temp[] IS NOT INITIAL.
        SELECT land1 " Country
               bland " Region
          FROM t005s " Taxes: Region (Province) Key
          INTO TABLE i_t005s
          FOR ALL ENTRIES IN li_temp
          WHERE bland EQ li_temp-regio
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*       Do nothing
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_t005s IS INITIAL

********validate Country
    IF i_t005 IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY land1.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING land1.
      IF li_temp[] IS NOT INITIAL.
        SELECT land1 " Country
          FROM t005  " Countries
          INTO TABLE i_t005
          FOR ALL ENTRIES IN li_temp
          WHERE land1 EQ li_temp-land1
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*       Do nothing
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_t005 IS INITIAL

********validate Sales Rep
    IF i_pa0003 IS INITIAL.
      li_temp[] = i_final[].
      SORT li_temp BY srep1 srep2.
      DELETE ADJACENT DUPLICATES FROM li_temp COMPARING srep1 srep2.
      IF li_temp[] IS NOT INITIAL.
        SELECT pernr  "Sales Rep
          FROM pa0003 " HR Master Record: Infotype 0003 (Payroll Status)
          INTO TABLE i_pa0003
          FOR ALL ENTRIES IN li_temp
          WHERE pernr EQ li_temp-srep1
             OR pernr EQ li_temp-srep2
          ORDER BY PRIMARY KEY.
        IF sy-subrc NE 0.
*         Nothing to do
*** BOC: CR#7764 KKRAVURI20190127
* Below validation is commented as part of CR#7764 changes
*   Message: Invalid Sales Rep!
*          MESSAGE s031(zqtc_r2). " Invalid Sales Rep!
*          LEAVE LIST-PROCESSING.
*** EOC: CR#7764 KKRAVURI20190127
        ENDIF. " IF sy-subrc NE 0
      ENDIF.
    ENDIF. " IF i_pa0003 IS INITIAL

    SELECT vkorg       " Sales Organization
           vtweg       " Distribution Channel
           spart       " Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           bsark       " Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           matnr       " Material Number
           prctr       " Profit Center
           kunnr       " Customer Number
           kvgr1       " Customer group 1
           pstlz_f     " Postal Code (From)
           pstlz_t     " Postal Code (To)
           regio       " Region (State, Province, County)
           land1       " Country Key
           datab       " Valid-From Date
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           zship_to    " Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           datbi       " Valid To Date
           srep1       " Sales Rep-1
           srep2       " Sales Rep-2
           aenam       " Name of Person Who Changed Object
           aedat       " Changed On
           aezet       " Time last change was made
      FROM zqtc_repdet " E129: Sales Rep PIGS Table
      INTO TABLE i_zqtc_repdet
      FOR ALL ENTRIES IN i_final
      WHERE vkorg    = i_final-vkorg
        AND vtweg    = i_final-vtweg
        AND spart    = i_final-spart
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
        AND bsark    = i_final-bsark
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
        AND matnr   = i_final-matnr
        AND prctr   = i_final-prctr
        AND kunnr   = i_final-kunnr
        AND kvgr1   = i_final-kvgr1
        AND pstlz_f = i_final-pstlz_f
        AND pstlz_t = i_final-pstlz_t
        AND regio   = i_final-regio
        AND land1   = i_final-land1
* BOC: CR#7764 KKRAVURI20190127
        AND zship_to = i_final-zship_to
* WOC: CR#7764 KKRAVURI20190127
    ORDER BY PRIMARY KEY.
    IF sy-subrc EQ 0.
      SORT i_zqtc_repdet BY vkorg
                            vtweg
                            spart
                            bsark     " ADD: CR#7764 KKRAVURI20190108  ED2K913679
                            matnr
                            prctr
                            kunnr
                            kvgr1
                            pstlz_f
                            pstlz_t
                            regio
                            land1
                            datab
                            zship_to  " ADD: CR#7764 KKRAVURI20190108  ED2K913679
                            datbi
                            srep1
                            srep2.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_final[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_download_data.

  IF rb_dwnl = c_x.
    SELECT vkorg       "Sales Organization
           vtweg       "Distribution Channel
           spart       "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           bsark       "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           matnr       "Material Number
           prctr       "Profit Center
           kunnr       "Customer Number
           kvgr1       "Customer group 1
           pstlz_f     "Postal Code (From)
           pstlz_t     "Postal Code (To)
           regio       "Region (State, Province, County)
           land1       "Country Key
           datab       "Valid-From Date
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           zship_to    "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           datbi       "Valid To Date
           srep1       "Sales Rep-1
           srep2       "Sales Rep-2
           aenam       "Name of Person Who Changed Object
           aedat       "Changed On
           aezet       "Time last change was made
      FROM zqtc_repdet " E129: Sales Rep PIGS Table
      INTO TABLE i_display.

    IF i_display[] IS NOT INITIAL.
      PERFORM f_download_data_options.
    ELSE. " ELSE -> IF i_display[] IS NOT INITIAL
      MESSAGE s006(zqtc_r2). "No data was found for your request
      LEAVE LIST-PROCESSING.
    ENDIF. " IF i_display[] IS NOT INITIAL

  ENDIF. " IF rb_dwnl = c_x
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv.

  REFRESH i_fcat_out.

  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers

  PERFORM f_buildcat USING:
            lv_counter 'MESSAGE'   text-019    , "Message
            lv_counter 'VKORG'     text-001    , "Sales Organization
            lv_counter 'VTWEG'     text-002    , "Distribution Channel
            lv_counter 'SPART'     text-003    , "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
            lv_counter 'BSARK'     text-046    , "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
            lv_counter 'DATAB'     text-004    , "Valid-From Date
            lv_counter 'DATBI'     text-005    , "Valid-to Date
            lv_counter 'MATNR'     text-006    , "Material Number
            lv_counter 'PRCTR'     text-007    , "Profit Center
            lv_counter 'KUNNR'     text-008    , "Customer Number
            lv_counter 'KVGR1'     text-009    , "Customer group 1
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
            lv_counter 'ZSHIP_TO'  text-047    , "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
            lv_counter 'PSTLZ_F'   text-010    , "Postal Code (From)
            lv_counter 'PSTLZ_T'   text-011    , "Postal Code (To)
            lv_counter 'REGIO'     text-012    , "Region (State, Province, County)
            lv_counter 'LAND1'     text-013    , "Country Key
            lv_counter 'SREP1'     text-014    , "Sales Rep-1
            lv_counter 'SREP2'     text-015    , "Sales Rep-2
            lv_counter 'AENAM'     text-016    , "Name of Person Who Changed Object
            lv_counter 'AEDAT'     text-017    , "Changed On
            lv_counter 'AEZET'     text-018    . "Time last change was made


  IF    i_output_x[] IS NOT INITIAL
    AND i_fcat_out IS NOT INITIAL.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = 'X'
        is_layout          = st_layout
        it_fieldcat        = i_fcat_out
      TABLES
        t_outtab           = i_output_x
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.

      MESSAGE e000 WITH text-008.

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF i_output_x[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA_OPTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_download_data_options.
  TYPES: BEGIN OF lty_display_x,
           vkorg    TYPE vkorg,   "Sales Organization
           vtweg    TYPE char3,   "Distribution Channel
           spart    TYPE char3,   "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           bsark    TYPE bsark,   "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           datab    TYPE datab,   "Valid-From Date
           datbi    TYPE datbi,   "Valid To Date
           matnr    TYPE char18,  "Material / Product
           prctr    TYPE char10,  "Profit Center
           kunnr    TYPE char10,  "Customer
           kvgr1    TYPE kvgr1,   "Customer Group
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
           zship_to TYPE zship_to, "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
           pstlz_f  TYPE char13,  "Postal Code (From)
           pstlz_t  TYPE char13,  "Postal Code (To)
           regio    TYPE regio,   "Region
           land1    TYPE land1,   "Country
           srep1    TYPE zzsrep1, "Sales Rep-1
           srep2    TYPE zzsrep2, "Sales Rep-2
           aenam    TYPE aenam,   "Name of Person Who Changed Object
           aedat    TYPE aedat,   "Changed On
           aezet    TYPE char9,   "Time last change was made
         END OF lty_display_x.

  DATA: BEGIN OF lst_header OCCURS 0,
          lv_head(50) TYPE c, " Line(50) of type Character
        END OF lst_header.

  DATA: li_display_x  TYPE TABLE OF lty_display_x,
        lst_display_x TYPE lty_display_x.

  lst_header-lv_head           = text-001. "Sales Organization
  APPEND lst_header.
  lst_header-lv_head           = text-002. "Distribution Channel
  APPEND lst_header.
  lst_header-lv_head           = text-003. "Division
  APPEND lst_header.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
  lst_header-lv_head           = text-046. "PO Type
  APPEND lst_header.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
  lst_header-lv_head           = text-004. "Valid-From Date
  APPEND lst_header.
  lst_header-lv_head           = text-005. "Valid To Date
  APPEND lst_header.
  lst_header-lv_head           = text-006. "Material Number
  APPEND lst_header.
  lst_header-lv_head           = text-007. "Profit Center
  APPEND lst_header.
  lst_header-lv_head           = text-008. "Customer Number
  APPEND lst_header.
  lst_header-lv_head           = text-009. "Customer group 1
  APPEND lst_header.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
  lst_header-lv_head           = text-047. "Ship-to party
  APPEND lst_header.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
  lst_header-lv_head           = text-010. "Postal Code (From)
  APPEND lst_header.
  lst_header-lv_head           = text-011. "Postal Code (To)
  APPEND lst_header.
  lst_header-lv_head           = text-012. "Region (State, Province, County)
  APPEND lst_header.
  lst_header-lv_head           = text-013. "Country Key
  APPEND lst_header.
  lst_header-lv_head           = text-014. "Sales Rep-1
  APPEND lst_header.
  lst_header-lv_head           = text-015. "Sales Rep-2
  APPEND lst_header.
  lst_header-lv_head           = text-016. "Name of Person Who Changed Object
  APPEND lst_header.
  lst_header-lv_head           = text-017. "Changed On
  APPEND lst_header.
  lst_header-lv_head           = text-018. "Time last change was made
  APPEND lst_header.

*******to download the file to presentation server
  DATA : lv_fname TYPE string, "FILE NAME
         lv_path  TYPE string, "FILE PATH
         lv_fpath TYPE string. "FULL FILE PATH

  DATA: lv_windo TYPE string.
  lv_windo = text-020. "Save dialog
*  *to save the file dialog
  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title      = lv_windo
      default_extension = 'XLS'
    CHANGING
      filename          = lv_fname
      path              = lv_path
      fullpath          = lv_fpath.

  IF sy-subrc <> 0.
    MESSAGE e000 WITH text-005.  "Valid To Date
  ENDIF. " IF sy-subrc <> 0

*to download the file to presentation server

  IF lv_fpath IS NOT INITIAL.
    LOOP AT i_display INTO st_display.
      lst_display_x-vkorg   = st_display-vkorg.
      lst_display_x-vtweg   = st_display-vtweg.
      lst_display_x-spart   = st_display-spart.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
      lst_display_x-bsark   = st_display-bsark.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
      lst_display_x-datab   = st_display-datab.
      lst_display_x-datbi   = st_display-datbi.
      lst_display_x-matnr   = st_display-matnr.
      lst_display_x-prctr   = st_display-prctr.
      lst_display_x-kunnr   = st_display-kunnr.
      lst_display_x-kvgr1   = st_display-kvgr1.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
      lst_display_x-zship_to = st_display-zship_to.
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
      lst_display_x-pstlz_f = st_display-pstlz_f.
      lst_display_x-pstlz_t = st_display-pstlz_t.
      lst_display_x-regio   = st_display-regio.
      lst_display_x-land1   = st_display-land1.
      lst_display_x-srep1   = st_display-srep1.
      lst_display_x-srep2   = st_display-srep2.
      lst_display_x-aenam   = st_display-aenam.
      lst_display_x-aedat   = st_display-aedat.
      lst_display_x-aezet   = st_display-aezet.

      IF lst_display_x-vtweg IS NOT INITIAL.
        SHIFT lst_display_x-vtweg LEFT DELETING LEADING space.
        CONCATENATE text-sqt lst_display_x-vtweg   INTO lst_display_x-vtweg.
      ENDIF. " IF lst_display_x-vtweg IS NOT INITIAL
      IF lst_display_x-spart IS NOT INITIAL.
        SHIFT lst_display_x-spart LEFT DELETING LEADING space.
        CONCATENATE text-sqt lst_display_x-spart   INTO lst_display_x-spart.
      ENDIF. " IF lst_display_x-spart IS NOT INITIAL
      IF lst_display_x-pstlz_f IS NOT INITIAL.
        SHIFT lst_display_x-pstlz_f LEFT DELETING LEADING space.
        CONCATENATE text-sqt lst_display_x-pstlz_f INTO lst_display_x-pstlz_f.
      ENDIF. " IF lst_display_x-pstlz_f IS NOT INITIAL
      IF lst_display_x-pstlz_t IS NOT INITIAL.
        SHIFT lst_display_x-pstlz_t LEFT DELETING LEADING space.
        CONCATENATE text-sqt lst_display_x-pstlz_t INTO lst_display_x-pstlz_t.
      ENDIF. " IF lst_display_x-pstlz_t IS NOT INITIAL
      IF lst_display_x-aezet IS NOT INITIAL.
        SHIFT lst_display_x-aezet   LEFT DELETING LEADING space.
        CONCATENATE text-sqt lst_display_x-aezet   INTO lst_display_x-aezet.
      ENDIF. " IF lst_display_x-aezet IS NOT INITIAL
      APPEND lst_display_x TO li_display_x.
      CLEAR : lst_display_x, st_display.
    ENDLOOP. " LOOP AT i_display INTO st_display

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = lv_fpath
        filetype              = c_asc
        write_field_separator = c_x " 'X'
      TABLES
        data_tab              = li_display_x
        fieldnames            = lst_header
      EXCEPTIONS
        OTHERS                = 22.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH text-021.   "Error in download
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lv_fpath IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXIST_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_exist_output.

  DATA lst_zqtc_repdet TYPE ty_final.
  READ TABLE i_zqtc_repdet INTO lst_zqtc_repdet WITH KEY vkorg   = st_output_x-vkorg
                                                         vtweg   = st_output_x-vtweg
                                                         spart   = st_output_x-spart
                                                         bsark   = st_output_x-bsark      " ADD: CR#7764 KKRAVURI20190108  ED2K913679
                                                         matnr   = st_output_x-matnr
                                                         prctr   = st_output_x-prctr
                                                         kunnr   = st_output_x-kunnr
                                                         kvgr1   = st_output_x-kvgr1
                                                         pstlz_f = st_output_x-pstlz_f
                                                         pstlz_t = st_output_x-pstlz_t
                                                         regio   = st_output_x-regio
                                                         land1   = st_output_x-land1
                                                         datab   = st_output_x-datab
                                                         zship_to = st_output_x-zship_to  " ADD: CR#7764 KKRAVURI20190108  ED2K913679
                                                         datbi   = st_output_x-datbi
                                                         srep1   = st_output_x-srep1
                                                         srep2   = st_output_x-srep2
                                                         BINARY SEARCH.
  IF sy-subrc EQ 0.
    st_output_x-flag = c_1. " Existing data
    st_output_x-message = text-s04.      "Existing data
    IF st_output_x-delete = c_x.
      st_output_x-flag = c_4. " Deleted
      st_output_x-message = text-s08.       "Deleted
    ENDIF. " IF st_output_x-delete = c_x
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  IF i_output_x[] IS NOT INITIAL.
    PERFORM f_display_alv.
  ENDIF. " IF i_output_x[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1151   text
*      -->P_1152   text
*      -->P_1153   text
*      -->P_1154   text
*      -->P_1155   text
*----------------------------------------------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132

  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-seltext_m    = fp_title.

  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_data_process.

  DATA: lv_table   TYPE tabname,              " Table Name
* Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        lv_err_msg TYPE char50,               " Error Message Text
* End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        li_update  TYPE TABLE OF zqtc_repdet, " E129: Sales Rep PIGS Table
        li_delete  TYPE TABLE OF zqtc_repdet, " E129: Sales Rep PIGS Table
        lst_update TYPE zqtc_repdet.          " E129: Sales Rep PIGS Table

  lv_table = 'ZQTC_REPDET'.

********final item processing
*--------------------------------------------------------------------*
* flag = 4 = Deleted
* flag = 3 = Sucessful Update
* flag = 1 = Existing data
* flag = 2 = Unsuccesful Update
*--------------------------------------------------------------------*
  LOOP AT i_final INTO st_final_x.
    CLEAR: st_output_x.
    st_output_x-vkorg     = st_final_x-vkorg.
    st_output_x-vtweg     = st_final_x-vtweg.
    st_output_x-spart     = st_final_x-spart.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
    st_output_x-bsark     = st_final_x-bsark.
    st_output_x-zship_to  = st_final_x-zship_to.
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
    st_output_x-datab     = st_final_x-datab.
    st_output_x-datbi     = st_final_x-datbi.
    st_output_x-matnr     = st_final_x-matnr.
    st_output_x-prctr     = st_final_x-prctr.
    st_output_x-kunnr     = st_final_x-kunnr.
    st_output_x-kvgr1     = st_final_x-kvgr1.
    st_output_x-pstlz_f   = st_final_x-pstlz_f.
    st_output_x-pstlz_t   = st_final_x-pstlz_t.
    st_output_x-regio     = st_final_x-regio.
    st_output_x-land1     = st_final_x-land1.
    st_output_x-srep1     = st_final_x-srep1.
    st_output_x-srep2     = st_final_x-srep2.
    st_output_x-aenam     = sy-uname.
    st_output_x-aedat     = sy-datum.
    st_output_x-aezet     = sy-uzeit.
    st_output_x-delete    = st_final_x-delete.

    PERFORM f_salesrep_check.
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    PERFORM f_exist_output.
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*** BOC by SARMUKHERJ on 19-12-16 TR#ED2K903282 for validation on validity date range
    PERFORM f_validydate_check USING st_output_x
                                     i_output_x
                                     i_zqtc_repdet.
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2
*** EOC by SARMUKHERJ on 19-12-16 TR#ED2K903282 for validation on validity date range

*--------------------------------------------------------------------*
* Get the status of output data
*--------------------------------------------------------------------*
    READ TABLE i_tvko INTO st_tvko WITH KEY vkorg = st_output_x-vkorg BINARY SEARCH.

    IF sy-subrc EQ 0.
      PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ELSE. " ELSE -> IF sy-subrc EQ 0
      v_reason = text-024. "'Sales Org. not found'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF sy-subrc EQ 0

*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    READ TABLE i_tvtw INTO st_tvtw WITH KEY vtweg = st_output_x-vtweg BINARY SEARCH.

    IF sy-subrc EQ 0.
      PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ELSE. " ELSE -> IF sy-subrc EQ 0
      v_reason = text-025. "'Distribution Channel not found'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF sy-subrc EQ 0

*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    READ TABLE i_tspa INTO st_tspa WITH KEY spart = st_output_x-spart BINARY SEARCH.

    IF sy-subrc EQ 0.
      PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ELSE. " ELSE -> IF sy-subrc EQ 0
      v_reason = text-026. "'Division not found'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF sy-subrc EQ 0
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-matnr IS NOT INITIAL.
      READ TABLE i_mvke INTO st_mvke WITH KEY matnr = st_output_x-matnr
                                              vkorg = st_output_x-vkorg
                                              vtweg = st_output_x-vtweg BINARY SEARCH.

      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-027. "'Material not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-matnr IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-prctr IS NOT INITIAL.
      READ TABLE i_cepc INTO st_cepc WITH KEY prctr = st_output_x-prctr BINARY SEARCH.

      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-028. "'Profit Center not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-prctr IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*   validation matnr vs prctr
    IF st_output_x-matnr IS NOT INITIAL AND st_output_x-prctr IS NOT INITIAL.
      v_reason = text-029. "'Material & Profit center not allowed together'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF st_output_x-matnr IS NOT INITIAL AND st_output_x-prctr IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*** BOC: CR#7764  KKRAVURI20190127
    IF st_output_x-zship_to IS NOT INITIAL.
      READ TABLE i_shipto TRANSPORTING NO FIELDS WITH KEY kunnr = st_output_x-zship_to
                                                          vkorg = st_output_x-vkorg
                                                          vtweg = st_output_x-vtweg
                                                          spart = st_output_x-spart
                                                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-048. "Ship-to party not found
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-zship_to IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-bsark IS NOT INITIAL.
      READ TABLE i_potype TRANSPORTING NO FIELDS
                          WITH KEY bsark = st_output_x-bsark BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE i_potype_t176 TRANSPORTING NO FIELDS
                                 WITH KEY bsark = st_output_x-bsark BINARY SEARCH.
        IF sy-subrc = 0.
          PERFORM  f_staus_output_3  CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
        ELSE.
          v_reason = text-050. "PO Type is not valid
          PERFORM  f_staus_output_2     USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
        ENDIF.
      ELSE.
        READ TABLE i_potype_t176 TRANSPORTING NO FIELDS
                                 WITH KEY bsark = st_output_x-bsark BINARY SEARCH.
        IF sy-subrc <> 0.
          v_reason = text-050. "PO Type is not valid
          PERFORM  f_staus_output_2     USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
        ELSE.
          v_reason = text-049. "PO Type is not active for PIGS table
          PERFORM  f_staus_output_2     USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
        ENDIF.
      ENDIF.
    ENDIF.

*** EOC: CR#7764  KKRAVURI20190127

    IF st_output_x-kunnr IS NOT INITIAL.
      READ TABLE i_knvv INTO st_knvv WITH KEY kunnr = st_output_x-kunnr
                                              vkorg = st_output_x-vkorg
                                              vtweg = st_output_x-vtweg
                                              spart = st_output_x-spart
                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-030. "'Customer not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-kunnr IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2
*   validation kunnr vs kvgr1
    IF st_output_x-kunnr IS NOT INITIAL AND st_output_x-kvgr1 IS NOT INITIAL.
      v_reason = text-031. "'Customer & Customer Grp not allowed together'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF st_output_x-kunnr IS NOT INITIAL AND st_output_x-kvgr1 IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*   Validate Customer group 1
    IF st_output_x-kvgr1 IS NOT INITIAL.
      CASE strlen( st_output_x-kvgr1 ).
        WHEN 1.
          READ TABLE i_tvv1 INTO st_tvv1 WITH KEY kvgr1_1 = st_output_x-kvgr1
                                                  BINARY SEARCH.
        WHEN 2.
          READ TABLE i_tvv1 INTO st_tvv1 WITH KEY kvgr1_1 = st_output_x-kvgr1(1)
                                                  kvgr1_2 = st_output_x-kvgr1
                                                  BINARY SEARCH.
        WHEN 3.
          READ TABLE i_tvv1 INTO st_tvv1 WITH KEY kvgr1_1 = st_output_x-kvgr1(1)
                                                  kvgr1_2 = st_output_x-kvgr1(2)
                                                  kvgr1   = st_output_x-kvgr1
                                                  BINARY SEARCH.
      ENDCASE.
      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-042. "'Customer Group 1 not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-kvgr1 IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-land1 IS NOT INITIAL.
      READ TABLE i_t005 INTO st_t005 WITH KEY land1 = st_output_x-land1 BINARY SEARCH.

      IF sy-subrc EQ 0.
        IF st_output_x-kunnr IS NOT INITIAL.
          READ TABLE i_kna1 INTO st_kna1 WITH KEY kunnr = st_output_x-kunnr
                                                  land1 = st_output_x-land1 BINARY SEARCH.
          IF sy-subrc EQ 0.
            PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                                  st_output_x-message. "Message
          ELSE. " ELSE -> IF sy-subrc EQ 0
            v_reason = text-032. "'Customer not found for country'
            PERFORM  f_staus_output_2       USING v_reason
                                         CHANGING st_output_x-flag     "Success/Unsuccessful
                                                  st_output_x-message. "Message
          ENDIF. " IF sy-subrc EQ 0
        ELSE. " ELSE -> IF st_output_x-kunnr IS NOT INITIAL
          PERFORM  f_staus_output_3    CHANGING st_output_x-flag       "Success/Unsuccessful
                                                st_output_x-message.   "Message
        ENDIF. " IF st_output_x-kunnr IS NOT INITIAL
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-033. "'Country not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-land1 IS NOT INITIAL

    IF st_output_x-regio IS NOT INITIAL.
      READ TABLE i_t005s INTO st_t005s WITH KEY land1 = st_output_x-land1
      bland = st_output_x-regio BINARY SEARCH.

      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-034. "'Region not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-regio IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2


    IF st_output_x-pstlz_f IS NOT INITIAL.
* Validate Postal Code
      CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
        EXPORTING
          country                        = st_output_x-land1   "Country
          postal_code_city               = st_output_x-pstlz_f "Postal Code
        EXCEPTIONS
          country_not_valid              = 1
          region_not_valid               = 2
          postal_code_city_not_valid     = 3
          postal_code_po_box_not_valid   = 4
          postal_code_company_not_valid  = 5
          po_box_missing                 = 6
          postal_code_po_box_missing     = 7
          postal_code_missing            = 8
          postal_code_pobox_comp_missing = 9
          po_box_region_not_valid        = 10
          po_box_country_not_valid       = 11
          pobox_and_poboxnum_filled      = 12
          OTHERS                         = 13.

      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-035. "'Postal code(From) not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-pstlz_f IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-pstlz_t IS NOT INITIAL.
* Validate Postal Code
      CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
        EXPORTING
          country                        = st_output_x-land1   "Country
          postal_code_city               = st_output_x-pstlz_t "Postal Code
        EXCEPTIONS
          country_not_valid              = 1
          region_not_valid               = 2
          postal_code_city_not_valid     = 3
          postal_code_po_box_not_valid   = 4
          postal_code_company_not_valid  = 5
          po_box_missing                 = 6
          postal_code_po_box_missing     = 7
          postal_code_missing            = 8
          postal_code_pobox_comp_missing = 9
          po_box_region_not_valid        = 10
          po_box_country_not_valid       = 11
          pobox_and_poboxnum_filled      = 12
          OTHERS                         = 13.

      IF sy-subrc EQ 0.
        PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-036. "'Postal code(To) not found'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_output_x-pstlz_t IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*   validation pstlz_f vs pstlz_t
    IF st_output_x-pstlz_f IS INITIAL AND st_output_x-pstlz_t IS NOT INITIAL.
      v_reason = text-037. "'Postal code(From) & Postal code(To) not allowed together'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF st_output_x-pstlz_f IS INITIAL AND st_output_x-pstlz_t IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

*   validation pstlz_f vs regio
    IF st_output_x-pstlz_f IS NOT INITIAL AND st_output_x-regio IS NOT INITIAL.
      v_reason = text-038. "'Postal code(From) & Region not allowed together'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag     "Success/Unsuccessful
                                            st_output_x-message. "Message
    ENDIF. " IF st_output_x-pstlz_f IS NOT INITIAL AND st_output_x-regio IS NOT INITIAL
*   Continue
    IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
      APPEND st_output_x TO i_output_x.
      CONTINUE.
    ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2

    IF st_output_x-srep1 IS NOT INITIAL.
      READ TABLE i_pa0003 TRANSPORTING NO FIELDS
           WITH KEY pernr = st_output_x-srep1
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        CLEAR: lv_err_msg.
*       Validate Sales Rep
        PERFORM f_sales_rep_validation USING    st_output_x-srep1
                                       CHANGING lv_err_msg.
        IF lv_err_msg IS INITIAL.
*       End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
          PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                                st_output_x-message. "Message
*       Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        ELSE.
          v_reason = lv_err_msg. "'Invalid Sales Rep-1'
          PERFORM  f_staus_output_2       USING v_reason
                                       CHANGING st_output_x-flag     "Success/Unsuccessful
                                                st_output_x-message. "Message
        ENDIF.
*       End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-039. "'Invalid Sales Rep-1'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0

*     Continue
      IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
        APPEND st_output_x TO i_output_x.
        CONTINUE.
      ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2
    ENDIF. " IF st_output_x-srep1 IS NOT INITIAL

    IF st_output_x-srep2 IS NOT INITIAL.
      READ TABLE i_pa0003 TRANSPORTING NO FIELDS
           WITH KEY pernr = st_output_x-srep2
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        CLEAR: lv_err_msg.
*       Validate Sales Rep
        PERFORM f_sales_rep_validation USING    st_output_x-srep2
                                       CHANGING lv_err_msg.
        IF lv_err_msg IS INITIAL.
*       End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
          PERFORM  f_staus_output_3    CHANGING st_output_x-flag     "Success/Unsuccessful
                                                st_output_x-message. "Message
*       Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
        ELSE.
          v_reason = lv_err_msg. "'Invalid Sales Rep-1'
          PERFORM  f_staus_output_2       USING v_reason
                                       CHANGING st_output_x-flag     "Success/Unsuccessful
                                                st_output_x-message. "Message
        ENDIF.
*       End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
      ELSE. " ELSE -> IF sy-subrc EQ 0
        v_reason = text-040. "'Invalid Sales Rep-2'
        PERFORM  f_staus_output_2       USING v_reason
                                     CHANGING st_output_x-flag     "Success/Unsuccessful
                                              st_output_x-message. "Message
      ENDIF. " IF sy-subrc EQ 0

*     Continue
      IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2.
        APPEND st_output_x TO i_output_x.
        CONTINUE.
      ENDIF. " IF st_output_x-flag EQ c_1 OR st_output_x-flag EQ c_2
    ENDIF. " IF st_output_x-srep2 IS NOT INITIAL

    APPEND st_output_x TO i_output_x.
    IF st_output_x-flag EQ c_3.
      MOVE-CORRESPONDING st_output_x TO lst_update.
      APPEND lst_update TO li_update.
    ENDIF. " IF st_output_x-flag EQ c_3
    IF st_output_x-flag EQ c_4.
      MOVE-CORRESPONDING st_output_x TO lst_update.
      APPEND lst_update TO li_delete.
    ENDIF. " IF st_output_x-flag EQ c_4

    CLEAR: st_final_x, st_output_x.

  ENDLOOP. " LOOP AT i_final INTO st_final_x
* Lock table
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      mode_rstable   = c_lock_md_e "Lock Mode - Write Lock
      tabname        = lv_table    "Table Name
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
*   Commit work
    IF li_update IS NOT INITIAL.
      MODIFY zqtc_repdet FROM TABLE li_update.
*** BOC: CR#7764  KKRAVAURI20190128  ED2K914344
      IF i_expiry[] IS NOT INITIAL.
        SORT i_expiry BY vkorg
                         vtweg
                         spart
                         bsark
                         matnr
                         prctr
                         kunnr
                         kvgr1
                         pstlz_f
                         pstlz_t
                         regio
                         land1
                         datab
                         zship_to
                         datbi.
        DELETE ADJACENT DUPLICATES FROM i_expiry COMPARING
                        vkorg vtweg spart bsark matnr prctr
                        kunnr kvgr1 pstlz_f pstlz_t regio land1
                        datab zship_to datbi.
        MODIFY zqtc_repdet FROM TABLE i_expiry.
        REFRESH i_expiry.
      ENDIF.
      REFRESH li_update.
*** EOC: CR#7764  KKRAVAURI20190128  ED2K914344
      COMMIT WORK AND WAIT.
      MESSAGE s000 WITH text-s07.       "Data Saved
    ENDIF. " IF li_update IS NOT INITIAL

    IF li_delete IS NOT INITIAL.
      DELETE zqtc_repdet FROM TABLE li_delete.
      COMMIT WORK AND WAIT.
      MESSAGE s000 WITH text-s07.   "Data Saved
    ENDIF. " IF li_delete IS NOT INITIAL
  ELSE. " ELSE -> IF sy-subrc = 0
    MESSAGE s000 WITH text-s06.     "Table locked
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc = 0

*   Unlock table
  CALL FUNCTION 'DEQUEUE_E_TABLE'
    EXPORTING
      mode_rstable = c_lock_md_e "Lock Mode - Write Lock
      tabname      = lv_table.   "Table Name

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SALESREP_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_salesrep_check.
  IF st_output_x-srep1 IS INITIAL AND st_output_x-srep2 IS INITIAL.
    v_reason = text-022. "'Sales Rep value Blank'
    PERFORM  f_staus_output_2       USING v_reason
                                 CHANGING st_output_x-flag     "Success/Unsuccessful
                                          st_output_x-message. "Message
  ENDIF. " IF st_output_x-srep1 IS INITIAL AND st_output_x-srep2 IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDYDATE_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validydate_check USING fp_st_output_x   TYPE ty_output_x
                              fp_i_output_x    TYPE tt_output_x
                              fp_i_zqtc_repdet TYPE tt_final.

  DATA: lst_repdet         TYPE ty_final,
        lst_output_x       TYPE ty_output_x,
*       Begin of ADD:ERP-4832:WROY:26-Oct-2017:ED2K909197
        lv_error           TYPE flag,
*       End   of ADD:ERP-4832:WROY:26-Oct-2017:ED2K909197
        li_zqtcrepdet_temp TYPE STANDARD TABLE OF ty_final,
        li_output_temp     TYPE STANDARD TABLE OF ty_output_x,
        lst_update         TYPE zqtc_repdet.  " ADD: CR#7764  KKRAVURI20190128

* Begin of ADD:ERP-4832:WROY:26-Oct-2017:ED2K909197
  IF fp_st_output_x-datab IS NOT INITIAL.
    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = fp_st_output_x-datab
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.
    IF sy-subrc NE 0.
      v_reason = text-043. " 'Invalid Valid-From Date (YYYYMMDD)'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag           "Success/Unsuccessful
                                            st_output_x-message.       "Message
      lv_error = abap_true.
    ENDIF.
  ENDIF.
  IF fp_st_output_x-datbi IS NOT INITIAL.
    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = fp_st_output_x-datbi
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.
    IF sy-subrc NE 0.
      v_reason = text-044. " 'Invalid Valid-To Date (YYYYMMDD)'
      PERFORM  f_staus_output_2       USING v_reason
                                   CHANGING st_output_x-flag           "Success/Unsuccessful
                                            st_output_x-message.       "Message
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  IF lv_error IS INITIAL AND
     fp_st_output_x-datab GT fp_st_output_x-datbi.
    v_reason = text-045. " 'Valid-From Date can not be greater than Valid-To Date'
    PERFORM  f_staus_output_2    USING v_reason
                              CHANGING st_output_x-flag             "Success/Unsuccessful
                                       st_output_x-message.         "Message
    lv_error = abap_true.
  ENDIF.
*** BOC: CR#7764 KKRAVURI20190130  ED2K914387
  IF lv_error IS INITIAL AND
     fp_st_output_x-datab < sy-datum.
    v_reason = text-051. " Valid-From Date should be GE sy-datum (current date)'
    PERFORM  f_staus_output_2    USING v_reason
                              CHANGING st_output_x-flag             "Success/Unsuccessful
                                       st_output_x-message.         "Message
    lv_error = abap_true.
  ENDIF.
*** EOC: CR#7764 KKRAVURI20190130  ED2K914387
  IF lv_error IS NOT INITIAL.
    RETURN.
  ENDIF.
* End   of ADD:ERP-4832:WROY:26-Oct-2017:ED2K909197

**** BOC: CR#7764 KKRAVURI20190128  ED2K914367
* Validity date range check for ZQTC_REPDET table data
  IF i_zqtc_repdet[] IS NOT INITIAL.
    " i_zqtc_repdet_[] has the database records matched the with Excel file data based on
    " DB Table (ZQTC_REPDET) key combination except Valaid_From date field
    li_zqtcrepdet_temp[] = i_zqtc_repdet[].
    DELETE li_zqtcrepdet_temp WHERE vkorg = st_output_x-vkorg AND
                                    vtweg = st_output_x-vtweg AND
                                    spart = st_output_x-spart AND
                                    bsark <> st_output_x-bsark.

    IF fp_st_output_x-message IS INITIAL.
      LOOP AT li_zqtcrepdet_temp INTO DATA(lst_zqtcrepdet).

        IF lst_zqtcrepdet-vkorg   = fp_st_output_x-vkorg AND
           lst_zqtcrepdet-vtweg   = fp_st_output_x-vtweg AND
           lst_zqtcrepdet-spart   = fp_st_output_x-spart AND
           lst_zqtcrepdet-bsark   = fp_st_output_x-bsark AND
           lst_zqtcrepdet-matnr   = fp_st_output_x-matnr AND
           lst_zqtcrepdet-prctr   = fp_st_output_x-prctr AND
           lst_zqtcrepdet-kunnr   = fp_st_output_x-kunnr AND
           lst_zqtcrepdet-kvgr1   = fp_st_output_x-kvgr1 AND
           lst_zqtcrepdet-pstlz_f = fp_st_output_x-pstlz_f AND
           lst_zqtcrepdet-pstlz_t = fp_st_output_x-pstlz_t AND
           lst_zqtcrepdet-regio   = fp_st_output_x-regio AND
           lst_zqtcrepdet-land1   = fp_st_output_x-land1 AND
           lst_zqtcrepdet-zship_to = fp_st_output_x-zship_to.


          IF fp_st_output_x-datab <= lst_zqtcrepdet-datbi AND  " New record Valid_From date is LE Old record Valid_To date AND
             fp_st_output_x-datbi > lst_zqtcrepdet-datbi.      " New record Valid_To date is GT Old record Valid_To date
            MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.   " New record --> Excel File record
            " In this case update the Old record Valid_To date with New record Valid_From date - 1
            lst_update-datbi = fp_st_output_x-datab - 1.
            lst_update-aenam = sy-uname.
* To get latest time
            GET TIME.
            lst_update-aedat = sy-datum.
            lst_update-aezet = sy-uzeit.
            APPEND lst_update TO i_expiry.
            CLEAR lst_update.
          ELSEIF fp_st_output_x-datab > lst_zqtcrepdet-datbi AND  " New record Valid_From date is GT Old record Valid_To date AND
                 fp_st_output_x-datbi > lst_zqtcrepdet-datbi.     " New record Valid_To date is GT Old record Valid_To date
            " In this case no need to update the existing record
            " Just save the new record into DB table
          ELSEIF ( fp_st_output_x-datab > lst_zqtcrepdet-datab AND fp_st_output_x-datab < lst_zqtcrepdet-datbi ) AND
                 ( fp_st_output_x-datbi < lst_zqtcrepdet-datbi ).
            " New record Valid_From date is GT Old record Valid_From date AND New record Valid_From date is LT Old record Valid_To date AND
            " New record Valid_To date is LT Old record Valid_To date
            " In this case update the Old record Valid_To date with New record Valid_From date - 1
            MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.
            lst_update-datbi = fp_st_output_x-datab - 1.
            lst_update-aenam = sy-uname.
* To get latest time
            GET TIME.
            lst_update-aedat = sy-datum.
            lst_update-aezet = sy-uzeit.
            APPEND lst_update TO i_expiry.
            CLEAR lst_update.
*          ELSEIF ( fp_st_output_x-datab < lst_zqtcrepdet-datab AND fp_st_output_x-datab < lst_zqtcrepdet-datbi ) AND
*                 ( fp_st_output_x-datbi > lst_zqtcrepdet-datab AND fp_st_output_x-datbi < lst_zqtcrepdet-datbi ).
*            " In this case, update the Old record Valid_From date with New record Valid_To date + 1
*            " Since Valid_From date is part of table Key, a new record is created in this case. Hence delete the old
*            " record for which a new record is created in this case. In this coding part logic for deleting the old record
*            " is not implemented. Hence implement it if this ELSEIF condition is necessary updation Validity dates validation
*            " This new ELSEIF condition is identified while testing the Validity dates
*            MOVE-CORRESPONDING lst_zqtcrepdet TO lst_update.
*            lst_update-datab = fp_st_output_x-datbi + 1.
*            lst_update-aenam = sy-uname.
** To get latest time
*            GET TIME.
*            lst_update-aedat = sy-datum.
*            lst_update-aezet = sy-uzeit.
*            APPEND lst_update TO i_expiry.
*            CLEAR lst_update.
          ENDIF.

        ENDIF.

        CLEAR lst_zqtcrepdet.
      ENDLOOP.
    ENDIF. " IF fp_st_output_x-message IS INITIAL

  ENDIF. " IF i_zqtc_repdet[] IS NOT INITIAL

*** EOC: CR#7764 KKRAVURI20190128  ED2K914367

*** BOC: CR#7764 KKRAVURI20190128
*** Below logic for 'Date overlapping' validation is commented as part of CR#7764
** Validity date range check for ZQTC_REPDET table data
*  IF i_zqtc_repdet[] IS NOT INITIAL.
*** BOC: CR#7764 KKRAVURI20190128
*** SORT stmt is added as the below READ stmt has BINARY SEARCH.
*    SORT li_zqtcrepdet_temp BY vkorg
*                               vtweg
*                               spart
*                               bsark
*                               matnr
*                               prctr
*                               kunnr
*                               kvgr1
*                               pstlz_f
*                               pstlz_t
*                               regio
*                               land1
*                               zship_to.
*** EOC: CR#7764 KKRAVURI20190128
*    READ TABLE li_zqtcrepdet_temp ASSIGNING FIELD-SYMBOL(<lst_zqtc>)
*         WITH KEY vkorg   = st_output_x-vkorg
*                  vtweg   = st_output_x-vtweg
*                  spart   = st_output_x-spart
*                  bsark   = st_output_x-bsark
*                  matnr   = st_output_x-matnr
*                  prctr   = st_output_x-prctr
*                  kunnr   = st_output_x-kunnr
*                  kvgr1   = st_output_x-kvgr1
*                  pstlz_f = st_output_x-pstlz_f
*                  pstlz_t = st_output_x-pstlz_t
*                  regio   = st_output_x-regio
*                  land1   = st_output_x-land1
*                  zship_to = st_output_x-zship_to
*                  BINARY SEARCH.
*    IF sy-subrc = 0.
*      IF fp_st_output_x-message IS INITIAL.
*        MOVE-CORRESPONDING <lst_zqtc> TO lst_update.
*        lst_update-datbi = fp_st_output_x-datab.
*        APPEND lst_update TO i_expiry.
*        CLEAR lst_update.
*      ENDIF. " IF fp_st_output_x-message IS INITIAL
*    ENDIF. " IF sy-subrc = 0.

*    li_zqtcrepdet_temp = fp_i_zqtc_repdet.
*   Identify entries for a Key combination (except dates)
*    DELETE li_zqtcrepdet_temp WHERE matnr   NE fp_st_output_x-matnr
*                                 OR prctr   NE fp_st_output_x-prctr
*                                 OR kunnr   NE fp_st_output_x-kunnr
*                                 OR kvgr1   NE fp_st_output_x-kvgr1
*                                 OR pstlz_f NE fp_st_output_x-pstlz_f
*                                 OR pstlz_t NE fp_st_output_x-pstlz_t
*                                 OR regio   NE fp_st_output_x-regio
*                                 OR land1   NE fp_st_output_x-land1
*                                 OR zship_to NE fp_st_output_x-zship_to. " ADD: CR#7764  KKRAVURI20190127

*   Ignore the same entry (key combinations)
*    READ TABLE li_zqtcrepdet_temp TRANSPORTING NO FIELDS
*         WITH KEY vkorg   = st_output_x-vkorg
*                  vtweg   = st_output_x-vtweg
*                  spart   = st_output_x-spart
*                  bsark   = st_output_x-bsark      " ADD: CR#7764 KKRAVURI20190108  ED2K913679
*                  matnr   = st_output_x-matnr
*                  prctr   = st_output_x-prctr
*                  kunnr   = st_output_x-kunnr
*                  kvgr1   = st_output_x-kvgr1
*                  pstlz_f = st_output_x-pstlz_f
*                  pstlz_t = st_output_x-pstlz_t
*                  regio   = st_output_x-regio
*                  land1   = st_output_x-land1
*                  datab   = st_output_x-datab
*                  zship_to = st_output_x-zship_to  " ADD: CR#7764 KKRAVURI20190127
*                  BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      DELETE li_zqtcrepdet_temp INDEX sy-tabix.
*    ENDIF. " IF sy-subrc EQ 0

*    IF fp_st_output_x-datab IS NOT INITIAL AND
*       fp_st_output_x-datbi IS NOT INITIAL.
*
*      LOOP AT li_zqtcrepdet_temp ASSIGNING FIELD-SYMBOL(<lst_zqtc>).
*        IF fp_st_output_x-message IS INITIAL.
*          IF fp_st_output_x-datab GE <lst_zqtc>-datab  AND
*             fp_st_output_x-datab LE <lst_zqtc>-datbi.
*            v_reason = text-023. " 'Date overlapping'
*            PERFORM  f_staus_output_2       USING v_reason
*                                         CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                  st_output_x-message. "Message
*          ENDIF. " IF fp_st_output_x-datab GE <lst_zqtc>-datab AND
*          IF fp_st_output_x-datbi GE <lst_zqtc>-datab  AND
*             fp_st_output_x-datbi LE <lst_zqtc>-datbi.
*            v_reason = text-023. " 'Date overlapping'
*            PERFORM  f_staus_output_2       USING v_reason
*                                         CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                  st_output_x-message. "Message
*          ENDIF. " IF fp_st_output_x-datbi GE <lst_zqtc>-datab AND
*          IF <lst_zqtc>-datab  GE fp_st_output_x-datab AND
*             <lst_zqtc>-datab  LE fp_st_output_x-datbi.
*            v_reason = text-023. " 'Date overlapping'
*            PERFORM  f_staus_output_2       USING v_reason
*                                         CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                  st_output_x-message. "Message
*          ENDIF. " IF <lst_zqtc>-datab GE fp_st_output_x-datab AND
*          IF <lst_zqtc>-datbi  GE fp_st_output_x-datab AND
*             <lst_zqtc>-datbi  LE fp_st_output_x-datbi.
*            v_reason = text-023. " 'Date overlapping'
*            PERFORM  f_staus_output_2       USING v_reason
*                                         CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                  st_output_x-message. "Message
*          ENDIF. " IF <lst_zqtc>-datbi GE fp_st_output_x-datab AND
*        ENDIF. " IF fp_st_output_x-message IS INITIAL
*      ENDLOOP. " LOOP AT li_zqtcrepdet_temp ASSIGNING FIELD-SYMBOL(<lst_zqtc>)

*    ENDIF. " IF fp_st_output_x-datab IS NOT INITIAL AND

*  ENDIF. " IF i_zqtc_repdet IS NOT INITIAL

*** Above logic for 'Date overlapping' validation is commented as part of CR#7764
*** EOC: CR#7764 KKRAVURI20190128

*** BOC: CR#7764 KKRAVURI20190128
*** Below logic for 'Date overlapping' validation is commented as part of CR#7764
* Validity date range check for uploading file data
*  IF i_output_x IS NOT INITIAL AND
*     fp_st_output_x-message IS INITIAL.
*
*    li_output_temp = i_output_x.
*
**   Identify entries for a Key combination (except dates)
*    DELETE li_output_temp WHERE     matnr    NE fp_st_output_x-matnr
*                                 OR prctr    NE fp_st_output_x-prctr
*                                 OR kunnr    NE fp_st_output_x-kunnr
*                                 OR kvgr1    NE fp_st_output_x-kvgr1
*                                 OR pstlz_f  NE fp_st_output_x-pstlz_f
*                                 OR pstlz_t  NE fp_st_output_x-pstlz_t
*                                 OR regio    NE fp_st_output_x-regio
*                                 OR land1    NE fp_st_output_x-land1
*                                 OR zship_to NE fp_st_output_x-zship_to. " ADD: CR#7764 KKRAVURI20190127
*
*    IF fp_st_output_x-datab IS NOT INITIAL AND
*                  fp_st_output_x-datbi IS NOT INITIAL.
*      LOOP AT li_output_temp ASSIGNING FIELD-SYMBOL(<lst_output_x>).
*        IF fp_st_output_x-message IS INITIAL.
*          IF <lst_output_x>-message EQ text-s03.
*            IF fp_st_output_x-datab GE <lst_output_x>-datab  AND
*               fp_st_output_x-datab LE <lst_output_x>-datbi.
*              v_reason = text-041. " 'Date overlapping'
*              PERFORM  f_staus_output_2       USING v_reason
*                                           CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                    st_output_x-message. "Message
*            ENDIF. " IF fp_st_output_x-datab GE <lst_output_x>-datab AND
*            IF fp_st_output_x-datbi GE <lst_output_x>-datab  AND
*               fp_st_output_x-datbi LE <lst_output_x>-datbi.
*              v_reason = text-041. " 'Date overlapping'
*              PERFORM  f_staus_output_2       USING v_reason
*                                           CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                    st_output_x-message. "Message
*            ENDIF. " IF fp_st_output_x-datbi GE <lst_output_x>-datab AND
*            IF <lst_output_x>-datab  GE fp_st_output_x-datab AND
*               <lst_output_x>-datab  LE fp_st_output_x-datbi.
*              v_reason = text-041. " 'Date overlapping'
*              PERFORM  f_staus_output_2       USING v_reason
*                                           CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                    st_output_x-message. "Message
*            ENDIF. " IF <lst_output_x>-datab GE fp_st_output_x-datab AND
*            IF <lst_output_x>-datbi  GE fp_st_output_x-datab AND
*               <lst_output_x>-datbi  LE fp_st_output_x-datbi.
*              v_reason = text-041. " 'Date overlapping'
*              PERFORM  f_staus_output_2       USING v_reason
*                                           CHANGING st_output_x-flag     "Success/Unsuccessful
*                                                    st_output_x-message. "Message
*            ENDIF. " IF <lst_output_x>-datbi GE fp_st_output_x-datab AND
*          ENDIF. " IF <lst_output_x>-message EQ text-s03
*        ENDIF. " IF fp_st_output_x-message IS INITIAL
*      ENDLOOP. " LOOP AT li_output_temp ASSIGNING FIELD-SYMBOL(<lst_output_x>)
*    ENDIF. " IF fp_st_output_x-datab IS NOT INITIAL AND
*
*  ENDIF. " IF i_output_x IS NOT INITIAL

*** Above logic for 'Date overlapping' validation is commented as part of CR#7764
*** EOC: CR#7764 KKRAVURI20190128


ENDFORM.
* Begin of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
*&---------------------------------------------------------------------*
*&      Form  F_SALES_REP_VALIDATION
*&---------------------------------------------------------------------*
*       Sales Rep Validation
*----------------------------------------------------------------------*
*      -->FP_SALES_REP   Sales Rep
*      <--FP_LV_ERR_MSG  Error Message Text
*----------------------------------------------------------------------*
FORM f_sales_rep_validation  USING    fp_sales_rep  TYPE p_pernr
                             CHANGING fp_lv_err_msg TYPE char50.

* Check Personnel Number against HR Master Record
  CALL FUNCTION 'RP_CHECK_PERNR'
    EXPORTING
      beg               = sy-datum
      pnr               = fp_sales_rep
    EXCEPTIONS
      data_fault        = 1
      person_not_active = 2
      person_unknown    = 3
      exit_fault        = 4
      pernr_missing     = 5
      date_missing      = 6
      OTHERS            = 7.
  CASE sy-subrc.
    WHEN 0.
*     Nothing to do
    WHEN 2.
      MESSAGE e002(vpd) WITH 'Employee'(z01) fp_sales_rep
         INTO fp_lv_err_msg.
    WHEN OTHERS.
      MESSAGE ID sy-msgid
            TYPE sy-msgty
          NUMBER sy-msgno
            WITH sy-msgv1
                 sy-msgv2
                 sy-msgv3
                 sy-msgv4
            INTO fp_lv_err_msg.
  ENDCASE.

ENDFORM.
* End   of ADD:ERP-4832:WROY:03-Dec-2017:ED2K909690
