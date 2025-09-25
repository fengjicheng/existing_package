*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_SO_CPO_HELP_EXIT (Enhancement Implementation)
* PROGRAM DESCRIPTION:Function Module for Sales Order Search Help
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   06/10/2016
* OBJECT ID: E061
* TRANSPORT NUMBER(S): ED2K903058
*----------------------------------------------------------------------*
FUNCTION zqtc_so_cpo_help_exit.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

*** Local structure declaration
  TYPES: BEGIN OF lty_record,
           mandt    TYPE symandt,  " Client ID
           bstkd    TYPE bstkd_m,  " Customer PO number as matchcode field
           vkorg    TYPE vkorg,    " Sales Organization
           kunnr    TYPE kunag,    " Sold-to party
           vtweg    TYPE vtweg,    " Distribution Channel
           spart    TYPE spart,    " Division
           vkbur    TYPE vkbur,    " Sales Office
           vkgrp    TYPE vkgrp,    " Sales Group
           ernam    TYPE ernam,    " Name of Person who Created the Object
           auart    TYPE auart,    " Sales Document Type
           bstdk    TYPE bstdk,    " Customer purchase order date
           trvog    TYPE trvog,    " Transaction group
           posnr    TYPE posnr,    " Item number of the SD document
           vbeln    TYPE vbeln,    " Sales and Distribution Document Number
           bstkd_e  TYPE zbstkd_e, " Ship-to Purchase Order
           zzrgcode TYPE zrgcode,  " Registration code
         END OF lty_record.

  TYPES: BEGIN OF lty_vbkd,
           vbeln    TYPE vbeln,    " Sales and Distribution Document Number
           posnr    TYPE posnr,    " Item number of the SD document
           zzrgcode TYPE zrgcode,  " Registration code
           bstkd_e  TYPE zbstkd_e, " Ship-to Purchase Order
         END OF lty_vbkd.


  TYPES: BEGIN OF lty_cpo_range,
           sign   TYPE char1,   " Sign of type CHAR1
           option TYPE char2,   " Option of type CHAR2
           low    TYPE bstkd_e, " Ship-to Party's Purchase Order Number
           high   TYPE bstkd_e, " Ship-to Party's Purchase Order Number
         END OF lty_cpo_range.

  TYPES: BEGIN OF lty_rg_range,
           sign   TYPE char1,   " Sign of type CHAR1
           option TYPE char2,   " Option of type CHAR2
           low    TYPE zrgcode, " Registration code
           high   TYPE zrgcode, " Registration code
         END OF lty_rg_range.

*** Local data declaration
  DATA: li_cpo_range  TYPE STANDARD TABLE OF lty_cpo_range,
        li_rg_range   TYPE STANDARD TABLE OF lty_rg_range,
        li_record1    TYPE STANDARD TABLE OF lty_record,
        lst_cpo_range TYPE lty_cpo_range,
        lst_rg_range  TYPE lty_rg_range,
        lst_vbkd      TYPE lty_vbkd,
        lst_record1   TYPE lty_record,
        li_seltop     TYPE ddshselops,
        lst_seltop    TYPE ddshselopt, " Selection options for value selection with search help
        lst_record    TYPE seahlpres,  " Search help result structure
        lv_idx        TYPE sytabix.    " Row Index of Internal Tables.

*** Local Constant declaration
  CONSTANTS: lc_disp              TYPE ddshf4step VALUE 'DISP',             " Current step in the F4 process
             lc_zqtce_so_cpo_help TYPE shlpname VALUE  'ZQTCE_SO_CPO_HELP', " Name of a Search Help
             lc_bstkd_e           TYPE shlpfield VALUE 'BSTKD_E',           " Name of a search help parameter
             lc_zzrgcode          TYPE shlpfield VALUE 'ZZRGCODE'.          " Name of a search help parameter


  IF  callcontrol-step = lc_disp. " DISP
*   Get data from record tab and populate internal
*   table with restricted values
    LOOP AT record_tab INTO lst_record.
      lst_record1 = lst_record-string.
      APPEND lst_record1 TO li_record1.
      CLEAR: lst_record1.
    ENDLOOP. " LOOP AT record_tab INTO lst_record


*  Fetch data from VBKD and VBAP table based on recently
*  populated internal table Sales order and item wise
    IF li_record1[] IS NOT INITIAL.
      SELECT b~vbeln AS vbeln,
             b~posnr AS posnr,
             a~zzrgcode AS zzrgcode,
             b~bstkd_e AS bstkd_e
        INTO TABLE @DATA(li_vbkd)
        FROM vbkd AS b
        LEFT OUTER JOIN vbap AS a ON a~vbeln = b~vbeln
                                 AND a~posnr = b~posnr
        FOR ALL ENTRIES IN @li_record1
        WHERE b~vbeln = @li_record1-vbeln
          AND b~posnr = @li_record1-posnr.
      IF sy-subrc IS INITIAL.
        SORT li_vbkd BY vbeln
                        posnr.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF li_record1[] IS NOT INITIAL

    li_seltop[] = shlp-selopt[].

*** Checking if Ship to party Purchase Order has been entered or not
*** Binary search cannot be used as this table cannot be sorted
    READ TABLE li_seltop TRANSPORTING NO FIELDS
    WITH KEY shlpname = lc_zqtce_so_cpo_help
             shlpfield = lc_bstkd_e.
    IF sy-subrc IS INITIAL.
*** Fetching the Ship to party Purchase Order which has been entered
      LOOP AT li_seltop INTO lst_seltop
       WHERE shlpname = lc_zqtce_so_cpo_help
           AND  shlpfield = lc_bstkd_e.
        IF sy-subrc = 0.
          lst_cpo_range-sign =  lst_seltop-sign.
          lst_cpo_range-option =  lst_seltop-option.
          lst_cpo_range-low =  lst_seltop-low.
          lst_cpo_range-high =  lst_seltop-high.
          APPEND lst_cpo_range TO li_cpo_range.
        ENDIF. " IF sy-subrc = 0
      ENDLOOP. " LOOP AT li_seltop INTO lst_seltop
    ENDIF. " IF sy-subrc IS INITIAL

    CLEAR: li_seltop. " Clearing local internal table
    li_seltop[] = shlp-selopt[].
*** Binary search cannot be used as this table cannot be sorted
    READ TABLE li_seltop TRANSPORTING NO FIELDS
    WITH KEY shlpname = lc_zqtce_so_cpo_help
             shlpfield = lc_zzrgcode.
    IF sy-subrc IS INITIAL.
*** Fetching the registration code which has been entered
      LOOP AT li_seltop INTO lst_seltop
       WHERE shlpname = lc_zqtce_so_cpo_help
        AND  shlpfield = lc_zzrgcode.
        IF sy-subrc = 0.
          lst_rg_range-sign =  lst_seltop-sign.
          lst_rg_range-option =  lst_seltop-option.
          lst_rg_range-low =  lst_seltop-low.
          lst_rg_range-high =  lst_seltop-high.
          APPEND lst_rg_range TO li_rg_range.
        ENDIF. " IF sy-subrc = 0
      ENDLOOP. " LOOP AT li_seltop INTO lst_seltop
    ENDIF. " IF sy-subrc IS INITIAL

    LOOP AT record_tab INTO lst_record.
      lv_idx = sy-tabix.
      lst_record1 = lst_record-string.
      READ TABLE li_vbkd INTO lst_vbkd
      WITH KEY vbeln = lst_record1-vbeln
               posnr = lst_record1-posnr
      BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lst_record1-bstkd_e  = lst_vbkd-bstkd_e.
        lst_record1-zzrgcode = lst_vbkd-zzrgcode.
        lst_record-string = lst_record1.
        MODIFY record_tab FROM lst_record INDEX lv_idx TRANSPORTING string.
        IF li_cpo_range[] IS NOT INITIAL.
          IF lst_record1-bstkd_e NOT IN li_cpo_range.
            DELETE record_tab INDEX lv_idx.
            CONTINUE.
          ENDIF. " IF lst_record1-bstkd_e NOT IN li_cpo_range
        ENDIF. " IF li_cpo_range[] IS NOT INITIAL
        IF li_rg_range[] IS NOT INITIAL.
          IF lst_record1-zzrgcode NOT IN li_rg_range.
            DELETE record_tab INDEX lv_idx.
          ENDIF. " IF lst_record1-zzrgcode NOT IN li_rg_range
        ENDIF. " IF li_rg_range[] IS NOT INITIAL
      ELSE. " ELSE -> IF sy-subrc IS INITIAL
        IF li_cpo_range[] IS NOT INITIAL
          OR li_rg_range[] IS NOT INITIAL.
          DELETE record_tab INDEX lv_idx.
        ENDIF. " IF li_cpo_range[] IS NOT INITIAL
      ENDIF. " IF sy-subrc IS INITIAL
    ENDLOOP. " LOOP AT record_tab INTO lst_record

  ENDIF. " IF callcontrol-step = lc_disp

ENDFUNCTION.
