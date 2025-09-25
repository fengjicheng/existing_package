*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ALT_BOM_SEL_FOR_DBM (Include)
*               [Called from User-Exit EXIT_SAPLCSDI_001]
* PROGRAM DESCRIPTION: Identify appropriate Alternate BOM
* DEVELOPER: Writtick Roy
* CREATION DATE:   12/08/2017
* OBJECT ID: E162 - CR#607
* TRANSPORT NUMBER(S): ED2K908513
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF lty_bom_hdr,
    matnr     TYPE matnr,                                  "Material Number
    werks     TYPE werks_d,                                "Plant
    stlan     TYPE stlan,                                  "BOM Usage
    stlnr     TYPE stnum,                                  "Bill of material
    stlal     TYPE stalt,                                  "Alternative BOM
    stlty     TYPE stlty,                                  "BOM category
    int_count TYPE cim_count,                              "Internal counter
  END OF lty_bom_hdr.

DATA:
  lst_bom_hdr TYPE lty_bom_hdr.                            "BOM Header Details

DATA:
  li_db_dates TYPE ztqtc_db_bom_dates,                     "DB BOM - Contract Start Date
  li_constant TYPE zcat_constants,                         "Constant Values
  lir_db_bom  TYPE rjksd_pstyv_range_tab.                  "Range Table for Item Category

DATA:
  lv_mem_name TYPE char30,                                 "Memory ID Name
  lv_db_year  TYPE begjj,                                  "Year
  lv_def_curr TYPE waers.                                  "Default Currency: Database BOM

CONSTANTS:
  lc_param_bi TYPE rvari_vnam  VALUE 'BOM_ITEMS',          "ABAP: Name of Variant Variable
  lc_param_ic TYPE rvari_vnam  VALUE 'DB_BOM_HDR_ITM_CAT', "ABAP: Name of Variant Variable
  lc_param_dc TYPE rvari_vnam  VALUE 'DB_BOM_DEFLT_CURR',  "ABAP: Name of Variant Variable
  lc_devid_75 TYPE zdevid      VALUE 'E075'.               "Development ID

* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_75
  IMPORTING
    ex_constants = li_constant.
IF li_constant[] IS NOT INITIAL.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_param_bi.                                    "ABAP: Name of Variant Variable (BOM_ITEMS)
        CASE <lst_const>-param2.
          WHEN lc_param_ic.                                "Item Category: Database BOM
            APPEND INITIAL LINE TO lir_db_bom ASSIGNING FIELD-SYMBOL(<lst_db_bom>).
            <lst_db_bom>-sign   = <lst_const>-sign.
            <lst_db_bom>-option = <lst_const>-opti.
            <lst_db_bom>-low    = <lst_const>-low.
            <lst_db_bom>-high   = <lst_const>-high.

          WHEN lc_param_dc.                                "Default Currency Key: Database BOM
            lv_def_curr         = <lst_const>-low.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

IF vbap-pstyv IN lir_db_bom.                               "Database BOM Only
* Prepare the Memory ID Name
  CONCATENATE rv45a-docnum
              '_DB_BOM_DATES'
         INTO lv_mem_name.
* Get the DB BOM - Contract Start Dates from Memory ID
* The Memory ID is getting populated in Include ZQTCN_INSUB04_NEW (EXIT_SAPLVEDA_002)
  IMPORT li_db_dates FROM MEMORY ID lv_mem_name.
  IF li_db_dates[] IS NOT INITIAL.

    lv_db_year = sy-datum(4).
    READ TABLE li_db_dates ASSIGNING FIELD-SYMBOL(<lst_db_date>)
         WITH KEY posex = vbap-posex
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_db_year = <lst_db_date>-vbegdat(4).
    ENDIF.

* Fetch BOM Header Details using Contract Currency
    SELECT m~matnr                                         "Material Number
           m~werks                                         "Plant
           m~stlan                                         "BOM Usage
           m~stlnr                                         "Bill of material
           m~stlal                                         "Alternative BOM
           k~stlty                                         "BOM category
           k~stkoz                                         "Internal counter
      FROM mast AS m INNER JOIN
           stko AS k
        ON m~stlnr EQ k~stlnr
       AND m~stlal EQ k~stlal
     UP TO 1 ROWS
      INTO lst_bom_hdr
     WHERE m~matnr   EQ vbap-matnr                         "Material Number
       AND m~werks   EQ da_werks                           "Plant
       AND k~zzwaers EQ vbak-waerk                         "Currency Key
       AND k~zzbegjj EQ lv_db_year.                        "Year
    ENDSELECT.
    IF sy-subrc EQ 0.
      vbapd-stlal = lst_bom_hdr-stlal.                     "Alternative BOM
    ELSE.
*   Fetch BOM Header Details using Default Currency
      SELECT m~matnr                                       "Material Number
             m~werks                                       "Plant
             m~stlan                                       "BOM Usage
             m~stlnr                                       "Bill of material
             m~stlal                                       "Alternative BOM
             k~stlty                                       "BOM category
             k~stkoz                                       "Internal counter
        FROM mast AS m INNER JOIN
             stko AS k
          ON m~stlnr EQ k~stlnr
         AND m~stlal EQ k~stlal
       UP TO 1 ROWS
        INTO lst_bom_hdr
       WHERE m~matnr   EQ vbap-matnr                       "Material Number
         AND m~werks   EQ da_werks                         "Plant
         AND k~zzwaers EQ lv_def_curr                      "Currency Key
         AND k~zzbegjj EQ lv_db_year.                      "Year
      ENDSELECT.
      IF sy-subrc EQ 0.
        vbapd-stlal = lst_bom_hdr-stlal.                   "Alternative BOM
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
