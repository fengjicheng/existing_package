*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_BP_ORDER_UPLD (Main Program)
* PROGRAM DESCRIPTION: To upload BP and subscription orders
* DEVELOPER: Nageswara(NPOLINA)
* CREATION DATE:   02/Dec/2019
* OBJECT ID:       E225
* TRANSPORT NUMBER(S):ED2K916854
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K919611
* REFERENCE NO: ERPM-4390
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE:   23/Sept/2020
* OBJECT ID:       E225
* DESCRIPTION: Allowing Condition grp2 to order type 'ZOR' as optional
* IF Society radio button selected
*----------------------------------------------------------------------*
* REVISION NO: ED2K919708
* REFERENCE NO: ERPM-4390
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE:   29/Sept/2020
* OBJECT ID:       E225
* DESCRIPTION: Make Condition grp2 Mandatory when order type 'ZOR' and
* Item category ZTXD or ZTXP
*----------------------------------------------------------------------*
* REVISION NO: ED2K919725
* REFERENCE NO: ERPM-4390
* DEVELOPER: Thilina Dimantha(TDIMANTHA)
* CREATION DATE:   30/Sept/2020
* OBJECT ID:       E225
* DESCRIPTION: Add PO type and make PO type mandatory to order type 'ZOR'
*----------------------------------------------------------------------*
* REVISION NO:  ED2K919820                                             *
* REFERENCE NO: OTCM-22276                                             *
* DEVELOPER: Lahiru Wathudura(LWATHUDURA)                              *
* DATE: 10/09/2020                                                     *
* DESCRIPTION: Add line item Content Start/End Dates to Order Upload to *
*              Accommodate Takeover Perpetual Access
*----------------------------------------------------------------------*
* REVISION NO: ED2K920085
* REFERENCE NO: OTCM-22276
* DEVELOPER: Lahiru Wathudura (Lwathudura)                             *
* DATE:  10/23/2020                                                    *
* DESCRIPTION: defect fixing for OTCM-22276
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K920341                                              *
* REFERENCE NO: OTCM-26293                                             *
* DEVELOPER: AMOHAMMED                                                 *
* DATE:  11/25/2020                                                    *
* DESCRIPTION: Validation of date format of different dates in         *
*              upload file                                             *
*----------------------------------------------------------------------*
* REVISION NO:ED2K921891                                               *
* REFERENCE NO:OTCM-38773                                              *
* DEVELOPER: MIMMADISET                                                *
* DATE:  02/15/2021                                                    *
* DESCRIPTION: File Validations Relation ship cate,society, order block*
*              upload file                                             *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:ED2K919818                                               *
* REFERENCE NO:OTCM-42807                                              *
* DEVELOPER: PTUAFARM(Prabhu)                                          *
* DATE:  03/25/2021                                                    *
* DESCRIPTION: Add new Fields Validity period category of contract     *
*              and Validity period of contract                         *
*----------------------------------------------------------------------*
* REVISION NO: ED2K923446                                              *
* REFERENCE NO:OTCM-42807                                              *
* DEVELOPER: Lahiru Wathudura(LWATHUDURA)                              *
* DATE:  05/17/2021                                                    *
* DESCRIPTION: Remove Validity period category of contract             *
*----------------------------------------------------------------------*
* REVISION NO: ED2K924398                                              *
* REFERENCE NO: OTCM-47267                                             *
* DEVELOPER: Nikhilesh Palla(NPALLA)                                   *
* DATE:  12/17/2021                                                    *
* DESCRIPTION: - Update Interface Staging ID field in staging table    *
*              ZE225_STAGING.                                          *
*              - Add Logic to Flip Between Old and New E101 Program    *
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download
  "225
* Popup for file path

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file " File Path
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
*&-----------------------------------*
*&      Form  F_CONVERT_EXCEL
*&-----------------------------------*
*       Convert Excel
*-----------------------------------*
*      ->P_P_FILE  text
*      <-P_I_FINAL  text
*-----------------------------------*
FORM f_convert_new_subs_ord_excel USING fp_p_file  TYPE rlgrap-filename " Local file for upload/download
                               CHANGING fp_i_final TYPE zttqtc_bporder
                                        fv_oid     TYPE numc10.  "E225

  DATA : li_excel        TYPE STANDARD TABLE OF zqtc_alsmex_tabline "alsmex_tabline " Rows for Table with Excel Data
                              INITIAL SIZE 0,                  " Rows for Table with Excel Data
         lst_excel_dummy TYPE zqtc_alsmex_tabline, "alsmex_tabline,                  " Rows for Table with Excel Data
         lst_excel       TYPE zqtc_alsmex_tabline, "alsmex_tabline,                  " Rows for Table with Excel Data
         lst_final       TYPE zstqtc_bporder,
         lv_excol        TYPE kcd_ex_col_n,
         lv_parw         TYPE parvw,
         lv_sold         TYPE parvw,
         lv_tbx          TYPE sy-tabix,
         lv_hdr          TYPE i,
         lv_loghandle    TYPE balloghndl.


  DATA:  lv_zmeng TYPE char17. " Zmeng of type CHAR17
  DATA:lv_auart_cre  TYPE auart,
       lv_col        TYPE i,
       lv_oid(10)    TYPE n,
       lv_count      TYPE i,
       li_log_handle TYPE bal_t_logh,
       lv_item       TYPE posnr,
       lv_log        TYPE balognr,
       lv_msgty      TYPE char1,
       lv_kdkg2      TYPE kdkg2.

  STATICS:lst_final3     TYPE zstqtc_bporder.
  CONSTANTS:lc_zq         TYPE inri-nrrangenr VALUE 'ZQ',
            lc_zqtc_uplid TYPE inri-object    VALUE 'ZQTC_UPLID',
            lc_quantity   TYPE inri-quantity  VALUE '1'.

  CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE' "'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = fp_p_file
      i_begin_col             = 1
      i_begin_row             = 3
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
*     i_end_col               = 67
      i_end_col               = 70
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
      i_end_row               = 65000
    TABLES
      intern                  = li_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc EQ 0.
* Now fill data from excel into final legacy data internal table

    IF NOT li_excel[] IS INITIAL.
      CLEAR: lst_final,lv_oid,fv_oid .
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = lc_zq
          object                  = lc_zqtc_uplid
          quantity                = lc_quantity
        IMPORTING
          number                  = lv_oid
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CONCATENATE text-128 lv_oid INTO DATA(lv_msg) SEPARATED BY space.
        CALL FUNCTION 'POPUP_TO_INFORM'
          EXPORTING
            titel = text-129
            txt1  = lv_msg
            txt2  = ''.
      ENDIF.

      fv_oid  = lv_oid.
      p_v_oid = lv_oid.
      LOOP AT li_excel INTO lst_excel.
        lst_excel_dummy = lst_excel.
        IF lst_excel_dummy-value(1) EQ text-sqt.
          lst_excel_dummy-value(1) = space.
          SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
        ENDIF.
        AT NEW col.

          CASE lst_excel_dummy-col.
            WHEN 1.
              IF NOT lst_final IS INITIAL.
                CLEAR:lv_msgty.      "NPOLINA 09/June/2020  ED1K911915
                PERFORM f_create_log_staging USING lst_final lv_oid lv_item
                                             CHANGING lv_log lv_msgty lv_loghandle lst_final3.
                " SOC NPOLINA 09/June/2020  ED1K911915
                IF lv_msgty IS INITIAL.
                  lv_msgty = c_i.
                ENDIF.
                " EOC NPOLINA 09/June/2020  ED1K911915

                lst_final-msgty = lv_msgty.
                lst_final-zlogno = lv_log.
                lst_final-zoid = lv_oid.
                lst_final-log_handle = lv_loghandle.

                IF lst_final-auart IS INITIAL.
                  lst_final-auart = lst_final3-auart.
                ENDIF.

                IF lst_final-vkorg IS INITIAL.
                  lst_final-vkorg = lst_final3-vkorg.
                ENDIF.

                IF lst_final-vtweg IS INITIAL.
                  lst_final-vtweg = lst_final3-vtweg.
                ENDIF.

                IF lst_final-spart IS INITIAL.
                  lst_final-spart = lst_final3-spart.
                ENDIF.

                IF lst_final-vkbur IS INITIAL.
                  lst_final-vkbur = lst_final3-vkbur.
                ENDIF.

                IF lst_final-spras IS INITIAL.
                  lst_final-spras = lst_final3-spras.
                ENDIF.
                IF lst_final-deflt_comm IS INITIAL AND lst_final3-deflt_comm IS NOT INITIAL .
                  lst_final-deflt_comm = lst_final3-deflt_comm.
                  lst_final-smtp_addr = lst_final3-smtp_addr.
                ENDIF.

                IF lst_final-bsark IS INITIAL.
                  lst_final-bsark = lst_final3-bsark.
                ENDIF.

                APPEND lst_final TO fp_i_final.
                CLEAR lst_final.
              ENDIF. " IF NOT lst_final IS INITIAL

              lst_final-identifier = lst_excel_dummy-value(10).
              lv_count = lv_count + 1.
              lst_final-snum = lv_count.
              CONDENSE lst_final-identifier.
              CLEAR lst_excel_dummy.
            WHEN 2.
              lst_final-customer = lst_excel_dummy-value(10).
              CLEAR lst_excel_dummy.

            WHEN 3.
              lst_final-parvw = lst_excel_dummy-value(2).

              IF lst_final-parvw IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
                  EXPORTING
                    input  = lst_final-parvw
                  IMPORTING
                    output = lst_final-parvw.
                IF lst_final-parvw EQ 'AG' OR lst_final-parvw EQ 'SP'.
                  CLEAR:lv_item.
                ELSE.
                  lv_item = lv_item + 10.
                ENDIF.
              ENDIF. " IF lst_final-parvw IS NOT INITIAL

            WHEN 4.

              lst_final-head_item = lst_excel_dummy-value(1).
              CLEAR lst_excel_dummy.

            WHEN 5.

              lst_final-bu_type = lst_excel_dummy-value(1).
              CLEAR lst_excel_dummy.

            WHEN 6.
              lst_final-bu_title = lst_excel_dummy-value(4).
              CLEAR lst_excel_dummy.

            WHEN 7.
              lst_final-name_f = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 8.

              lst_final-name_l = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 9.

              lst_final-suffix = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 10.

              lst_final-str_suppl2 = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 11.

              lst_final-str_suppl1 = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 12.
              lst_final-street = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 13.
              lst_final-str_suppl3 = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 14.

              lst_final-location = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 15.
              lst_final-city1 = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 16.
              SPLIT lst_excel_dummy-value AT '-' INTO DATA(lv_val1) DATA(lv_val2) DATA(lv_val3).
              CONDENSE lv_val2 NO-GAPS.
              lst_final-region = lv_val2.
              CLEAR lst_excel_dummy.

            WHEN 17.
              lst_final-country = lst_excel_dummy-value(2).
              CLEAR lst_excel_dummy.

            WHEN 18.
              lst_final-post_code1 = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 19.
              lst_final-spras = lst_excel_dummy-value(2).
              CLEAR lst_excel_dummy.

            WHEN 20.
              lst_final-deflt_comm = lst_excel_dummy-value(3).
              CLEAR lst_excel_dummy.

            WHEN 21.

              lst_final-smtp_addr = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 22.
              lst_final-tel_number = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 23.
              lst_final-reltyp = lst_excel_dummy-value(6).
              CLEAR lst_excel_dummy.
            WHEN 24.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-datfrom.
*              CLEAR lst_excel_dummy.
              DATA : lv_date TYPE sy-datum.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-datfrom.
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 25.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-dateto.
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-dateto.
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 26.
              lst_final-partner2 = lst_excel_dummy-value(10).
              CLEAR lst_excel_dummy.
            WHEN 27.
              lst_final-katr6 = lst_excel_dummy-value(3).
              CLEAR lst_excel_dummy.

            WHEN 28.
              lst_final-kdgrp = lst_excel_dummy-value(2).
              CLEAR lst_excel_dummy.

            WHEN 29.
              lst_final-auart = lst_excel_dummy-value(4).
              CLEAR lst_excel_dummy.
              IF v_auart IS INITIAL.
                v_auart = lst_final-auart.
              ENDIF.
            WHEN 30.
              lst_final-ord_reason = lst_excel_dummy-value(3).
              IF lst_final-ord_reason IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-ord_reason
                  IMPORTING
                    output = lst_final-ord_reason.
              ENDIF. " IF lst_final-augru IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 31.
              lst_final-vbeln = lst_excel_dummy-value(10).

              IF lst_final-vbeln IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vbeln
                  IMPORTING
                    output = lst_final-vbeln.
              ENDIF. " IF
              CLEAR lst_excel_dummy.

            WHEN 32.
              lst_final-vkorg = lst_excel_dummy-value(4).
              IF lst_final-vkorg IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vkorg
                  IMPORTING
                    output = lst_final-vkorg.
              ENDIF. " IF lst_final-vkorg IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 33.
              lst_final-vtweg = lst_excel_dummy-value(2).
              IF lst_final-vtweg IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vtweg
                  IMPORTING
                    output = lst_final-vtweg.
              ENDIF. " IF lst_final-vtweg IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 34.
              lst_final-spart = lst_excel_dummy-value(2).
              IF lst_final-spart IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-spart
                  IMPORTING
                    output = lst_final-spart.
              ENDIF. " IF lst_final-spart IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 35.
              lst_final-vkbur = lst_excel_dummy-value(4).
              IF lst_final-vkbur IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vkbur
                  IMPORTING
                    output = lst_final-vkbur.
              ENDIF.
              CLEAR lst_excel_dummy.
            WHEN 36.
              lst_final-waerk = lst_excel_dummy-value(4).
              CLEAR lst_excel_dummy.
            WHEN 37.
              lst_final-bstnk = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 38.
              SPLIT lst_excel_dummy-value AT  '-' INTO lst_final-bsark  DATA(lv_dum) .
              IF lst_final-bsark IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-bsark
                  IMPORTING
                    output = lst_final-bsark.
              ENDIF.
              CLEAR lst_excel_dummy.
            WHEN 39.
              lst_final-xblnr  = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 40.  "
              lst_final-zuonr = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 41.
              lst_final-zlsch = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 42.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-fkdat .
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-fkdat .
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 43.
              lst_final-stxh = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 44.              "Invoice instruction
              lst_final-invinst = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 45.              "
              lst_final-vaktsch = lst_excel_dummy-value.
              IF lst_final-vaktsch IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vaktsch
                  IMPORTING
                    output = lst_final-vaktsch.
              ENDIF.
              CLEAR lst_excel_dummy.

            WHEN 46.              "
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-vasda .
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-vasda .
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 47.
              lst_final-perio = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
            WHEN 48.
              lst_final-autte = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 49.
              lst_final-peraf = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 50.
              lst_final-lifsk = lst_excel_dummy-value(2).
              IF lst_final-lifsk IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-lifsk
                  IMPORTING
                    output = lst_final-lifsk.
              ENDIF. " IF lst_final-lifsk IS NOT INITIAL
              CLEAR lst_excel_dummy.
            WHEN 51.
              lst_final-faksk = lst_excel_dummy-value(2).
              IF lst_final-faksk IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-faksk
                  IMPORTING
                    output = lst_final-faksk.
              ENDIF. " IF lst_final-faksk IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 52.
              lst_final-posnr = lst_excel_dummy-value(6).
              IF lst_final-posnr IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-posnr
                  IMPORTING
                    output = lst_final-posnr.
              ENDIF. " IF lst_final-posnr IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 53.
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
              ENDIF.
              CLEAR lst_excel_dummy.

            WHEN 54.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-vbegdat .
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-vbegdat .
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 55.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-venddat .
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-venddat .
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 56.
              lst_final-pstyv = lst_excel_dummy-value(4).
              IF lst_final-pstyv IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-pstyv
                  IMPORTING
                    output = lst_final-pstyv.
              ENDIF. " IF lst_final-pstyv IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 57.
              lv_zmeng         =  lst_excel_dummy-value(13).
              TRY.
                  lst_final-kwmeng  = lv_zmeng.
                CATCH cx_root.
                  MESSAGE i131(o3) WITH lst_excel_dummy-value. " Quantity & is not in the correct format
                  LEAVE LIST-PROCESSING.
              ENDTRY.
              CLEAR lst_excel_dummy.

            WHEN 58.
              lst_final-augru = lst_excel_dummy-value(2).
              IF lst_final-augru IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-augru
                  IMPORTING
                    output = lst_final-augru.
              ENDIF. " IF lst_final-augru IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 59.
              lst_final-kschl = lst_excel_dummy-value.
              IF lst_final-kschl IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-kschl
                  IMPORTING
                    output = lst_final-kschl.
              ENDIF. " IF lst_final-kschl IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 60.
              TRY.
                  lst_final-kbetr = lst_excel_dummy-value(11).
                CATCH cx_root.
*                 Message: Amount & format is incorrect
                  MESSAGE i406(aw) WITH lst_excel_dummy-value. " Amount & format is incorrect
                  LEAVE LIST-PROCESSING.
              ENDTRY.
              CLEAR lst_excel_dummy.

            WHEN 61.
              lst_final-ihrez_e = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 62.
              lst_final-zzpromo = lst_excel_dummy-value.
              IF lst_final-zzpromo IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-zzpromo
                  IMPORTING
                    output = lst_final-zzpromo.
              ENDIF. " IF lst_final-zzpromo IS NOT INITIAL
              CLEAR lst_excel_dummy.

            WHEN 63.
              lst_final-kdkg4 = lst_excel_dummy-value(2).
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lst_final-kdkg4
                IMPORTING
                  output = lst_final-kdkg4.
              CLEAR lst_excel_dummy.

            WHEN 64.
              lst_final-kdkg4_2 = lst_excel_dummy-value(2).
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lst_final-kdkg4_2
                IMPORTING
                  output = lst_final-kdkg4_2.
              CLEAR lst_excel_dummy.

            WHEN 65.
              lst_final-pq_typ = lst_excel_dummy-value(2).
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lst_final-pq_typ
                IMPORTING
                  output = lst_final-pq_typ.
              CLEAR lst_excel_dummy.

            WHEN 66.
              lst_final-ihrez = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.

            WHEN 67.
              lst_final-kdkg2 = lst_excel_dummy-value(2).
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lst_final-kdkg2
                IMPORTING
                  output = lst_final-kdkg2.

              CLEAR lst_excel_dummy.
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
            WHEN 68.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-zzconstart .
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-zzconstart .
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
            WHEN 69.
* Begin by AMOHAMMED on 11/24/2020 TR # ED2K920341
*              WRITE lst_excel_dummy-value(8) TO lst_final-zzconend.
*              CLEAR lst_excel_dummy.
              CLEAR lv_date.
              WRITE lst_excel_dummy-value(8) TO lv_date.
              CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                  date                      = lv_date
                EXCEPTIONS
                  plausibility_check_failed = 1
                  OTHERS                    = 2.
              IF sy-subrc <> 0.
                MESSAGE i130(o3) WITH lst_excel_dummy-value.
                LEAVE LIST-PROCESSING.
              ELSE.
                WRITE lst_excel_dummy-value(8) TO lst_final-zzconend.
                CLEAR lst_excel_dummy.
              ENDIF.
* End by AMOHAMMED on 11/24/2020 TR # ED2K920341
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
            WHEN 70.
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
*              lst_final-vlaufk = lst_excel_dummy-value.
*              CLEAR lst_excel_dummy.
              lst_final-vlaufz = lst_excel_dummy-value.
              CLEAR lst_excel_dummy.
*            WHEN 71.
*              lst_final-vlaufz = lst_excel_dummy-value.
*              CLEAR lst_excel_dummy.
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
          ENDCASE.
        ENDAT.
      ENDLOOP. " LOOP AT li_excel INTO lst_excel
      FREE lv_date. " by AMOHAMMED on 11/24/2020 TR # ED2K920341
* For last row population
      IF lst_final IS NOT INITIAL.
        PERFORM f_create_log_staging USING lst_final lv_oid lv_item CHANGING lv_log lv_msgty lv_loghandle lst_final3.
        lst_final-zlogno = lv_log.
        lst_final-msgty = lv_msgty.
        lst_final-zoid = lv_oid.
        lst_final-log_handle = lv_loghandle.

        IF lst_final-auart IS INITIAL.
          lst_final-auart = lst_final3-auart.
        ENDIF.

        IF lst_final-vkorg IS INITIAL.
          lst_final-vkorg = lst_final3-vkorg.
        ENDIF.

        IF lst_final-vtweg IS INITIAL.
          lst_final-vtweg = lst_final3-vtweg.
        ENDIF.

        IF lst_final-spart IS INITIAL.
          lst_final-spart = lst_final3-spart.
        ENDIF.

        IF lst_final-vkbur IS INITIAL.
          lst_final-vkbur = lst_final3-vkbur.
        ENDIF.

        IF lst_final-spras IS INITIAL.
          lst_final-spras = lst_final3-spras.
        ENDIF.
        IF lst_final-deflt_comm IS INITIAL AND lst_final3-deflt_comm IS NOT INITIAL .
          lst_final-deflt_comm = lst_final3-deflt_comm.
          lst_final-smtp_addr = lst_final3-smtp_addr.
        ENDIF.

        IF lst_final-bsark IS INITIAL.
          lst_final-bsark = lst_final3-bsark.
        ENDIF.

        APPEND lst_final TO fp_i_final.
        MODIFY ze225_staging FROM TABLE i_staging.
        CLEAR lst_final.
      ENDIF.

    ENDIF. " IF NOT li_excel[] IS INITIAL
  ENDIF. " IF sy-subrc EQ 0

  IF i_final IS NOT INITIAL.
    SELECT kunnr,
                     vkorg,
                     vtweg,
                     spart " Division
                FROM knvv  " Customer Master Sales Data
                INTO TABLE @DATA(li_knvv)
                FOR ALL ENTRIES IN  @i_final
                WHERE kunnr = @i_final-customer.
    IF sy-subrc EQ 0.
      SORT li_knvv BY kunnr vkorg vtweg spart.
    ENDIF.
  ENDIF.

  CLEAR:lv_hdr.
  LOOP AT i_final INTO lst_final.
    lv_tbx = sy-tabix.
    DATA(lst_final2) = lst_final.
    IF lst_final2-parvw = 'WE'." AND lst_final2-head_item = 'H'.
      lv_parw = abap_true.
    ENDIF.

    IF lst_final2-head_item = 'H' AND lst_final2-parvw NE 'SP' .
      lv_hdr = lv_hdr + 1.
    ENDIF.

    IF lst_final2-head_item = 'H'.
      DATA(lst_finalh) = lst_final.
    ENDIF.

    IF lst_final2-parvw = 'AG'." AND lst_final2-head_item = 'H'.
      lv_sold = abap_true.
    ENDIF.


    AT END OF identifier.
      IF lv_parw IS INITIAL OR lv_hdr > 1 OR lv_hdr EQ 0 OR lv_sold IS INITIAL.  "ED2K918239  NPOLINA

        CLEAR:st_msg.
        st_msg-msgid = 'ZQTC_R2'.
        st_msg-msgno = '000'.
        st_msg-msgty = c_e.
        IF lv_parw IS INITIAL.
          st_msg-msgv1 = text-189.
        ELSEIF lv_hdr > 1.
          st_msg-msgv1 = text-188.
* SOC by  ED2K918239       NPOLINA  ERPM-2334 ERPM-19878
        ELSEIF lv_hdr EQ 0.
          st_msg-msgv1 = 'Header record not exist for this Order'(192).
        ELSEIF lv_sold IS INITIAL.
          st_msg-msgv1 = 'Sold-to not available at Header for this Order'(193).
* EOC by  ED2K918239       NPOLINA  ERPM-2334 ERPM-19878
        ENDIF.
        CLEAR:lv_parw,lv_hdr,lv_sold.
        FREE: li_log_handle[].
        APPEND lst_final2-log_handle TO li_log_handle.
        CALL FUNCTION 'BAL_DB_LOAD'
          EXPORTING
            i_t_log_handle     = li_log_handle
          EXCEPTIONS
            no_logs_specified  = 1
            log_not_found      = 2
            log_already_loaded = 3
            OTHERS             = 4.
        IF sy-subrc EQ 0.

          st_log_handle = lst_final2-log_handle.
          CALL FUNCTION 'BAL_LOG_MSG_ADD'
            EXPORTING
              i_log_handle     = st_log_handle
              i_s_msg          = st_msg
            EXCEPTIONS
              log_not_found    = 1
              msg_inconsistent = 2
              log_is_full      = 3
              OTHERS           = 4.

          IF sy-subrc EQ 0.
            FREE:st_loghandle[].
            APPEND st_log_handle TO st_loghandle.
            CALL FUNCTION 'BAL_DB_SAVE'
              EXPORTING
                i_client         = sy-mandt
                i_save_all       = abap_true
                i_t_log_handle   = st_loghandle
              IMPORTING
                e_new_lognumbers = i_lognum
              EXCEPTIONS
                log_not_found    = 1
                save_not_allowed = 2
                numbering_error  = 3
                OTHERS           = 4.
            IF sy-subrc EQ 0.

              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
              lst_final2-msgty = c_e.
              MODIFY i_final FROM lst_final2  INDEX lv_tbx TRANSPORTING msgty.
              READ TABLE i_staging ASSIGNING FIELD-SYMBOL(<lfs_stage23>) WITH KEY zlogno = lst_final2-zlogno.
              IF sy-subrc EQ 0.
                <lfs_stage23>-zprcstat = 'E2'.
              ENDIF.
              MODIFY ze225_staging FROM TABLE i_staging.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        CLEAR:lv_parw,lv_hdr,lv_sold.
      ENDIF.
    ENDAT.
    CLEAR:lst_final,lst_final.
  ENDLOOP.
ENDFORM.
*&-----------------------------------*
*&      Form  f_process_bp_orders
*&-----------------------------------*
*       text
*-----------------------------------*
*  ->  p1        text
*  <-  p2        text
*-----------------------------------*
FORM f_process_bp_orders .   "E225

  DATA: lv_counter TYPE sycucol VALUE 1, " Counter of type Integers
        lv_auart   TYPE auart,
        lv_debug   TYPE char1,
        lst_finalx TYPE zstqtc_bporder. "ty_excel_enhanced.


  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_string     TYPE string,
        lv_werks      TYPE char4,
        lv_abgru      TYPE char4,
        lv_stdt       TYPE char10,
        lv_enddt      TYPE char10,
        lv_fkdat      TYPE char10,
        lv_vasda      TYPE char10,
        lv_type       TYPE char1,
        lv_pre_chk    TYPE btcckstat,        " variable for pre. job status
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
        lv_zconstdat  TYPE char10,
        lv_zconendt   TYPE char10.
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *

* Remove error records before submit to E101
  READ TABLE i_const INTO DATA(lst_path) WITH KEY devid = c_e101 param1 = c_path.
  IF sy-subrc = 0.
    CLEAR v_path_fname.
    v_path_fname = lst_path-low.
  ENDIF.
  DATA(i_final2) = i_final.
  LOOP AT i_final2 ASSIGNING FIELD-SYMBOL(<lst_err2>) WHERE msgty = c_e.
    LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_err3>) WHERE identifier = <lst_err2>-identifier.
      <lst_err3>-msgty = c_e.
    ENDLOOP.
  ENDLOOP.

  IF i_final IS NOT INITIAL.
    DATA(i_final_t) = i_final.
    DELETE i_final_t WHERE msgty = c_e.
    IF i_final_t IS INITIAL.
      PERFORM f_send_email_e225.
    ENDIF.
  ENDIF.

  SELECT SINGLE vbtyp FROM tvak INTO @DATA(lv_vbtyp)
    WHERE auart = @p_auart.
  IF sy-subrc NE 0.
    CLEAR:lv_vbtyp.
  ENDIF.
  IF i_final_t IS NOT INITIAL.

    CLEAR:st_final_x.

    PERFORM f_get_file_path USING v_path_fname.


    OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc EQ 0.
      CLEAR:st_final_x.
      LOOP AT i_final INTO st_final_x.

        IF st_final_x-vaktsch IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = st_final_x-vaktsch
            IMPORTING
              output = st_final_x-vaktsch.
        ENDIF.

        CLEAR:lv_stdt,lv_enddt,lv_vasda,lv_fkdat.
        CONCATENATE st_final_x-vbegdat+4(2) '/' st_final_x-vbegdat+6(2) '/' st_final_x-vbegdat+0(4) INTO lv_stdt.
        CONCATENATE st_final_x-venddat+4(2) '/' st_final_x-venddat+6(2) '/' st_final_x-venddat+0(4) INTO lv_enddt.
        CONCATENATE st_final_x-vasda+4(2) '/' st_final_x-vasda+6(2) '/' st_final_x-vasda+0(4) INTO lv_vasda.
        CONCATENATE st_final_x-fkdat+4(2) '/' st_final_x-fkdat+6(2) '/' st_final_x-fkdat+0(4) INTO lv_fkdat.
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
        CONCATENATE st_final_x-zzconstart+4(2) '/' st_final_x-zzconstart+6(2) '/' st_final_x-zzconstart+0(4) INTO lv_zconstdat. " content start date
        CONCATENATE st_final_x-zzconend+4(2) '/' st_final_x-zzconend+6(2) '/' st_final_x-zzconend+0(4) INTO lv_zconendt.        " content end date
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
        IF st_final_x-head_item = 'H'.
          CLEAR:st_final_x-posnr.
        ENDIF.

*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        IF v_new_logic IS INITIAL.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        IF lv_vbtyp = 'G'.        "Contracts
          CLEAR:v_ord.
          v_cont = abap_true.
          CONCATENATE
          abap_true
          st_final_x-customer
          st_final_x-parvw
          st_final_x-customer
          st_final_x-vkorg
          st_final_x-vtweg
          st_final_x-spart
          lv_stdt
          lv_enddt
          st_final_x-posnr
          st_final_x-matnr
          lv_werks
          st_final_x-vbeln
          st_final_x-pstyv
          st_final_x-kwmeng
          st_final_x-lifsk
          st_final_x-faksk
          st_final_x-augru " It will map to Rejection code field ABGRU
          st_final_x-bsark
          st_final_x-auart
          st_final_x-xblnr
          st_final_x-zlsch
          st_final_x-bstnk
          st_final_x-stxh
          st_final_x-kschl
          st_final_x-kbetr
          st_final_x-ihrez_e    "Legacy Ref no
          st_final_x-zzpromo
          st_final_x-kdkg4
          st_final_x-pq_typ    "PQ Subscription Type KDKG5
          st_final_x-kdkg4_2   "Price Override Reason Code KDKG3
          st_final_x-ihrez     "Sub Ref ID
          st_final_x-vkbur
          lv_fkdat
          st_final_x-waerk
          st_final_x-zuonr
          st_final_x-invinst
          st_final_x-vaktsch
          lv_vasda
          st_final_x-perio
          st_final_x-autte
          st_final_x-peraf
          st_final_x-ord_reason
          st_final_x-kdkg2
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
          lv_zconstdat
          lv_zconendt
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
         " st_final_x-vlaufk
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
          st_final_x-vlaufz
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
          st_final_x-smtp_addr
          st_final_x-zlogno
          st_final_x-msgty
          st_final_x-msgv1
          st_final_x-log_handle
          st_final_x-zoid
          st_final_x-identifier

          INTO st_final_csv SEPARATED BY c_pipe.
        ELSEIF lv_vbtyp = 'C' OR lv_vbtyp = 'I'.     "Orders
          CLEAR:v_cont.
          v_ord = abap_true.
          CONCATENATE
                    abap_true
                    st_final_x-customer
                    st_final_x-parvw
                    st_final_x-customer
                    st_final_x-vkorg
                    st_final_x-vtweg
                    st_final_x-spart
                    lv_stdt
                    lv_enddt
                    st_final_x-ord_reason
                    st_final_x-matnr
                    lv_werks
                    st_final_x-vbeln
                    st_final_x-posnr
                    st_final_x-pstyv
                    st_final_x-kwmeng
                    st_final_x-xblnr
                    st_final_x-zlsch
                    st_final_x-lifsk
                    st_final_x-faksk
                    st_final_x-augru " It will map to Rejection code field ABGRU
                    st_final_x-auart
                    st_final_x-bstnk
                    st_final_x-stxh
                    st_final_x-kschl
                    st_final_x-kbetr
                    st_final_x-ihrez_e    "Legacy Ref no
                    st_final_x-ihrez     "Sub Ref ID
                    st_final_x-zzpromo
                    st_final_x-kdkg4
                    st_final_x-pq_typ    "PQ Subscription Type KDKG5
                    st_final_x-kdkg4_2   "Price Override Reason Code KDKG3
                    st_final_x-ihrez     "Sub Ref ID
                    st_final_x-vkbur

* BOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
                    st_final_x-bsark
* EOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
*                    lv_fkdat
*                    st_final_x-waerk
*                    st_final_x-zuonr
*                    st_final_x-invinst
*                    st_final_x-vaktsch
*                    lv_vasda
*                    st_final_x-perio
*                    st_final_x-autte
*                    st_final_x-peraf
*                    st_final_x-ord_reason
*                    st_final_x-kdkg2
*BOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
                    st_final_x-kdkg2
*EOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
                    st_final_x-smtp_addr
                    st_final_x-zlogno
                    st_final_x-msgty
                    st_final_x-msgv1
                    st_final_x-log_handle
                    st_final_x-zoid
                    st_final_x-identifier
                    INTO st_final_csv SEPARATED BY c_pipe.

        ENDIF.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        ELSEIF v_new_logic IS NOT INITIAL.
          IF lv_vbtyp = 'G'.        "Contracts
            CLEAR:v_ord.
            v_cont = abap_true.
            CONCATENATE
            abap_true
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
            st_final_x-identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
            st_final_x-customer
            st_final_x-parvw
            st_final_x-customer
            st_final_x-vkorg
            st_final_x-vtweg
            st_final_x-spart
            lv_stdt
            lv_enddt
            st_final_x-posnr
            st_final_x-matnr
            lv_werks
            st_final_x-vbeln
            st_final_x-pstyv
            st_final_x-kwmeng
            st_final_x-lifsk
            st_final_x-faksk
            st_final_x-augru " It will map to Rejection code field ABGRU
            st_final_x-bsark
            st_final_x-auart
            st_final_x-xblnr
            st_final_x-zlsch
            st_final_x-bstnk
            st_final_x-stxh
            st_final_x-kschl
            st_final_x-kbetr
            st_final_x-ihrez_e    "Legacy Ref no
            st_final_x-zzpromo
            st_final_x-kdkg4
            st_final_x-pq_typ    "PQ Subscription Type KDKG5
            st_final_x-kdkg4_2   "Price Override Reason Code KDKG3
            st_final_x-ihrez     "Sub Ref ID
            st_final_x-vkbur
            lv_fkdat
            st_final_x-waerk
            st_final_x-zuonr
            st_final_x-invinst
            st_final_x-vaktsch
            lv_vasda
            st_final_x-perio
            st_final_x-autte
            st_final_x-peraf
            st_final_x-ord_reason
            st_final_x-kdkg2
*   BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
            lv_zconstdat
            lv_zconendt
*   BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
           " st_final_x-vlaufk
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
            st_final_x-vlaufz
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
            st_final_x-smtp_addr
            st_final_x-zlogno
            st_final_x-msgty
            st_final_x-msgv1
            st_final_x-log_handle
            st_final_x-zoid
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*            st_final_x-identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
            INTO st_final_csv SEPARATED BY c_pipe.
          ELSEIF lv_vbtyp = 'C' OR lv_vbtyp = 'I'.     "Orders
            CLEAR:v_cont.
            v_ord = abap_true.
            CONCATENATE
                      abap_true
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
                      st_final_x-identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
                      st_final_x-customer
                      st_final_x-parvw
                      st_final_x-customer
                      st_final_x-vkorg
                      st_final_x-vtweg
                      st_final_x-spart
                      lv_stdt
                      lv_enddt
                      st_final_x-ord_reason
                      st_final_x-matnr
                      lv_werks
                      st_final_x-vbeln
                      st_final_x-posnr
                      st_final_x-pstyv
                      st_final_x-kwmeng
                      st_final_x-xblnr
                      st_final_x-zlsch
                      st_final_x-lifsk
                      st_final_x-faksk
                      st_final_x-augru " It will map to Rejection code field ABGRU
                      st_final_x-auart
                      st_final_x-bstnk
                      st_final_x-stxh
                      st_final_x-kschl
                      st_final_x-kbetr
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*                      st_final_x-ihrez_e    "Legacy Ref no (--Moved Below ihrez per E101)
                      st_final_x-ihrez      "Sub Ref ID (Your Reference)
                      st_final_x-ihrez_e    "Legacy Ref no (Ship-to party character) ++
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
                      st_final_x-zzpromo
                      st_final_x-kdkg4
                      st_final_x-pq_typ    "PQ Subscription Type KDKG5
                      st_final_x-kdkg4_2   "Price Override Reason Code KDKG3
                      st_final_x-ihrez     "Sub Ref ID
                      st_final_x-vkbur

* BOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
                      st_final_x-bsark
* EOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
*                      lv_fkdat
*                      st_final_x-waerk
*                      st_final_x-zuonr
*                      st_final_x-invinst
*                      st_final_x-vaktsch
*                      lv_vasda
*                      st_final_x-perio
*                      st_final_x-autte
*                      st_final_x-peraf
*                      st_final_x-ord_reason
*                      st_final_x-kdkg2
*BOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
                      st_final_x-kdkg2
*EOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267 OTCM-52926
                      lv_fkdat
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267 OTCM-52926
                      st_final_x-smtp_addr
                      st_final_x-zlogno
                      st_final_x-msgty
                      st_final_x-msgv1
                      st_final_x-log_handle
                      st_final_x-zoid
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
*                      st_final_x-identifier
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E101  OTCM-47267
                      INTO st_final_csv SEPARATED BY c_pipe.

          ENDIF.
        ENDIF.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267

        TRANSFER st_final_csv TO v_path_fname.
        CLEAR:st_final_x,st_final_csv.
      ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
      CLOSE DATASET v_path_fname.
    ENDIF.

**** Submit Program
    CLEAR lv_job_name.
    CONCATENATE c_devid c_uns sy-datum c_uns sy-uzeit c_uns sy-uname  INTO lv_job_name.

    lv_user = sy-uname.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = text-109.

    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = lv_job_name
      IMPORTING
        jobcount         = lv_job_number
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.

    IF sy-subrc = 0.
      v_job_name = lv_job_name.
      p_job   = lv_job_name.
      lv_debug = abap_true.
      IF lv_debug = abap_true.
        p_auart = v_auart.
* Submit to E101 for Order Creation
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        IF v_new_logic IS INITIAL.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        SUBMIT zqtcr_subscrip_order_upload  WITH rb_crea  = v_cont
                                            WITH rb_or_ct  = v_ord
                                            WITH p_file   = p_l_file
                                            WITH p_a_file = v_path_fname
                                            WITH p_job    = p_job
                                            WITH p_userid = p_userid
                                            WITH p_devid  = c_devid
                                            WITH p_v_oid  = p_v_oid
                                            WITH p_auart  = p_auart
                                            USER  iv_batchuser "'QTC_BATCH01'
                                            VIA JOB lv_job_name NUMBER lv_job_number
                                            AND RETURN.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        ELSEIF v_new_logic IS NOT INITIAL.
          SUBMIT zqtcr_subscrip_order_upload_v1  WITH rb_crea  = v_cont
                                                 WITH rb_or_ct  = v_ord
                                                 WITH p_file   = p_l_file
                                                 WITH p_a_file = v_path_fname
                                                 WITH p_job    = p_job
                                                 WITH p_userid = p_userid
                                                 WITH p_devid  = c_devid
                                                 WITH p_v_oid  = p_v_oid
                                                 WITH p_auart  = p_auart
                                                 USER  iv_batchuser "'QTC_BATCH01'
                                                 VIA JOB lv_job_name NUMBER lv_job_number
                                                 AND RETURN.
        ENDIF.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
      ELSE.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        IF v_new_logic IS INITIAL.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        SUBMIT zqtcr_subscrip_order_upload  WITH rb_crea  = v_cont
                                             WITH rb_or_ct = v_ord
                                             WITH p_file   = p_l_file
                                             WITH p_a_file = v_path_fname
                                             WITH p_job    = p_job
                                             WITH p_userid = p_userid
                                             WITH p_devid  = c_devid
                                             WITH p_v_oid  = p_v_oid.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
        ELSEIF v_new_logic IS NOT INITIAL.
          SUBMIT zqtcr_subscrip_order_upload_v1  WITH rb_crea  = v_cont
                                                 WITH rb_or_ct = v_ord
                                                 WITH p_file   = p_l_file
                                                 WITH p_a_file = v_path_fname
                                                 WITH p_job    = p_job
                                                 WITH p_userid = p_userid
                                                 WITH p_devid  = c_devid
                                                 WITH p_v_oid  = p_v_oid.
        ENDIF.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
      ENDIF.
** close the background job for successor jobs
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = lv_job_name
          jobcount             = lv_job_number
          predjob_checkstat    = lv_pre_chk
          sdlstrtdt            = sy-datum
          sdlstrttm            = sy-uzeit
        EXCEPTIONS
          cant_start_immediate = 01
          invalid_startdate    = 02
          jobname_missing      = 03
          job_close_failed     = 04
          job_nosteps          = 05
          job_notex            = 06
          lock_failed          = 07
          OTHERS               = 08.
      IF sy-subrc = 0.

      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc = 0
  ENDIF. "  IF i_final2 IS NOT INITIAL.
ENDFORM.
*-----------------------------------*
*      Form  F_VALIDATE_FILE
*-----------------------------------*
*      Validate File
*-----------------------------------*
FORM f_validate_file  USING   fp_file TYPE localfile. " Local file for upload/download
  DATA : lv_file_char   TYPE localfile. " Local file for upload/download

  IF fp_file IS NOT INITIAL AND sy-batch IS INITIAL.

* Reverse the string
    CALL FUNCTION 'STRING_REVERSE'
      EXPORTING
        string    = fp_file
        lang      = sy-langu
      IMPORTING
        rstring   = lv_file_char
      EXCEPTIONS
        too_small = 1
        OTHERS    = 2.
    IF sy-subrc IS INITIAL.
      IF lv_file_char+0(3) NE 'slx'  AND
         lv_file_char+0(3) NE 'SLX'  AND
         lv_file_char+0(4) NE 'xslx' AND
         lv_file_char+0(4) NE 'XSLX'.
        MESSAGE text-e18 TYPE c_e.
      ENDIF. " IF lv_file_char+0(3) NE 'slx' AND
    ENDIF. " IF sy-subrc IS INITIAL

    SELECT SINGLE * FROM ze225_staging INTO @DATA(lst_stage)
      WHERE zfilepath = @p_file.
    IF sy-subrc EQ 0 .
      MESSAGE 'File already been processed '(131)  TYPE c_e.
    ENDIF.
  ELSE.
  ENDIF. " IF fp_file IS NOT INITIAL
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE_APP_SERVER_SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_file_app_server_submit USING fp_li_output_x TYPE zttqtc_bporder. "tt_output_x. "E225
*** Local Constant Declaration
  CONSTANTS: lc_pipe       TYPE c VALUE '|',        " Tab of type Character
             lc_semico     TYPE char1 VALUE ';',    " Semico of type CHAR1
             lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv', " Extn of type CHAR4
             lc_job_name   TYPE btcjob VALUE 'E225'. " Background job name
**** Local field symbol declaration
  FIELD-SYMBOLS: <lfs_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        lv_length     TYPE i,      " Length of type Integers
        lv_fnm        TYPE char70, " Fnm of type CHAR70
        li_final_csv  TYPE truxs_t_text_data.

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status



  LOOP AT fp_li_output_x ASSIGNING FIELD-SYMBOL(<lfs_outpt>).
    CLEAR:lst_final_csv.

    IF <lfs_outpt>-vaktsch IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lfs_outpt>-vaktsch
        IMPORTING
          output = <lfs_outpt>-vaktsch.
    ENDIF.

    CONCATENATE
            <lfs_outpt>-identifier
            <lfs_outpt>-customer
            <lfs_outpt>-parvw
            <lfs_outpt>-head_item
            <lfs_outpt>-bu_type
            <lfs_outpt>-bu_title
            <lfs_outpt>-name_f
            <lfs_outpt>-name_l
            <lfs_outpt>-suffix
            <lfs_outpt>-str_suppl2
            <lfs_outpt>-str_suppl1
            <lfs_outpt>-street
            <lfs_outpt>-str_suppl3
            <lfs_outpt>-location
            <lfs_outpt>-city1
            <lfs_outpt>-region
            <lfs_outpt>-country
            <lfs_outpt>-post_code1
            <lfs_outpt>-spras
            <lfs_outpt>-deflt_comm
            <lfs_outpt>-smtp_addr
            <lfs_outpt>-tel_number
            <lfs_outpt>-reltyp
            <lfs_outpt>-datfrom
            <lfs_outpt>-dateto
            <lfs_outpt>-partner2
            <lfs_outpt>-katr6
            <lfs_outpt>-kdgrp
            <lfs_outpt>-auart
            <lfs_outpt>-vbeln
            <lfs_outpt>-vkorg
            <lfs_outpt>-vtweg
            <lfs_outpt>-spart
            <lfs_outpt>-vkbur
            <lfs_outpt>-waerk
            <lfs_outpt>-bstnk
            <lfs_outpt>-bsark
            <lfs_outpt>-xblnr
            <lfs_outpt>-zuonr
            <lfs_outpt>-zlsch
            <lfs_outpt>-fkdat
            <lfs_outpt>-stxh
            <lfs_outpt>-invinst
            <lfs_outpt>-vaktsch
            <lfs_outpt>-vasda
            <lfs_outpt>-perio
            <lfs_outpt>-autte
            <lfs_outpt>-peraf
            <lfs_outpt>-lifsk
            <lfs_outpt>-faksk
            <lfs_outpt>-posnr
            <lfs_outpt>-matnr
            <lfs_outpt>-vbegdat
            <lfs_outpt>-venddat
            <lfs_outpt>-pstyv
            <lfs_outpt>-kwmeng
            <lfs_outpt>-augru
            <lfs_outpt>-kschl
            <lfs_outpt>-kbetr
            <lfs_outpt>-ihrez_e
            <lfs_outpt>-zzpromo
            <lfs_outpt>-kdkg4
            <lfs_outpt>-kdkg4_2
            <lfs_outpt>-ihrez
            <lfs_outpt>-kdkg2
        INTO lst_final_csv SEPARATED BY c_pipe.

    APPEND lst_final_csv TO li_final_csv.
    CLEAR:lst_final_csv.
  ENDLOOP.

  CLEAR v_fpath.
  CONCATENATE 'BP-ORD_UPLD'
              lc_underscore
              sy-uname
              lc_underscore
              sy-datum
              lc_underscore
              sy-uzeit
              lc_extn
              INTO
              v_path_fname.

  PERFORM f_get_file_path USING v_path_fname.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc EQ 0.
    LOOP AT li_final_csv INTO lst_final_csv.
      TRANSFER lst_final_csv TO v_path_fname.
    ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
    CLOSE DATASET v_path_fname.
  ENDIF.
**** Submit Program
  CLEAR lv_job_name.
  CONCATENATE c_devid c_uns sy-datum c_uns sy-uzeit c_uns sy-uname  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-066.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc = 0.
    v_job_name = lv_job_name.
    p_job   = lv_job_name.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
    IF v_new_logic IS INITIAL.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
    SUBMIT zqtcr_subscrip_order_upload  WITH p_file  = p_file
                                        WITH p_a_file = v_path_fname
                                        WITH p_job    = p_job
                                        WITH p_userid = sy-uname
                                        USER  'QTC_BATCH01'
                                        VIA JOB lv_job_name NUMBER lv_job_number
                                        AND RETURN.
*---BOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
    ELSEIF v_new_logic IS NOT INITIAL.
      SUBMIT zqtcr_subscrip_order_upload_v1  WITH p_file  = p_file
                                             WITH p_a_file = v_path_fname
                                             WITH p_job    = p_job
                                             WITH p_userid = sy-uname
                                             USER  'QTC_BATCH01'
                                             VIA JOB lv_job_name NUMBER lv_job_number
                                             AND RETURN.
    ENDIF.
*---EOC NPALLA Staging Changes 09/01/2021 ED2K924398 E225  OTCM-47267
** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.
    IF sy-subrc = 0.

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_log_email. "E225
  DATA: lv_con_cret TYPE char1  VALUE cl_abap_char_utilities=>cr_lf, " Con_cret of type Character
        lst_message TYPE solisti1.                               " SAPoffice: Single List with Column Length 255

  CONCATENATE text-067 text-068 text-069 text-070 text-071 text-072 text-073
  text-074 text-075  INTO i_attach SEPARATED BY ','.
  CONCATENATE lv_con_cret i_attach INTO i_attach.
  APPEND  i_attach.


  LOOP AT i_err_msg_list INTO DATA(lst_err_msg).
    CONCATENATE lst_err_msg-wbeln lst_err_msg-msgid lst_err_msg-msgty lst_err_msg-msgno lst_err_msg-natxt lst_err_msg-msgv1 lst_err_msg-msgv2
    lst_err_msg-msgv3 lst_err_msg-msgv4
    INTO i_attach SEPARATED BY ','.
    CONCATENATE lv_con_cret i_attach INTO i_attach.
    APPEND  i_attach.
  ENDLOOP. " LOOP AT i_err_msg_list INTO DATA(lst_err_msg)

  v_job_name = p_job.

*- Send file by email as .xls speadsheet
  PERFORM f_send_csv_xls_log.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log . "E225
  DATA: lst_xdocdata    TYPE sodocchgi1,                           " Data of an object which can be changed
        lst_message     TYPE  solisti1,
        lv_xcnt         TYPE i,                                    " Xcnt of type Integers
        lv_file_name    TYPE char100,                              " File_name of type CHAR100
        lst_usr21       TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6        TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        li_packing_list TYPE sopcklsti1 OCCURS 0 WITH HEADER LINE, "Itab to hold packing list for email
        li_receivers    TYPE somlreci1 OCCURS 0 WITH HEADER LINE,  "Itab to hold mail receipents
        li_attachment   TYPE solisti1 OCCURS 0 WITH HEADER LINE,   " SAPoffice: Single List with Column Length 255
        lv_n            TYPE i,                                    " N of type Integers
        lv_desc         TYPE so_obj_des.                           " Short description of contents

  CONCATENATE sy-sysid text-082 v_job_name 'Log'(114) INTO lv_desc SEPARATED BY c_uns.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.
*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  lst_message = text-078. "Dear Wiley Customer,Please find Attachmen
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'JOB NAME:' v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  lst_message = text-089.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = text-080.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = text-081.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  DESCRIBE TABLE i_attach LINES lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = 'SAPRPT'.
  lst_xdocdata-obj_descr  = lv_desc.
  CLEAR li_attachment[].
  li_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR li_packing_list.
  li_packing_list-transf_bin = space.
  li_packing_list-head_start = 1.
  li_packing_list-head_num = 0.
  li_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES li_packing_list-body_num.
  li_packing_list-doc_type = 'RAW'.
  APPEND li_packing_list.
  IF i_attach[] IS NOT INITIAL.
    lv_n = 1.
*- Create attachment notification
    li_packing_list-transf_bin = abap_true.
    li_packing_list-head_start = 1.
    li_packing_list-head_num   = 1.
    li_packing_list-body_start = lv_n.

    DESCRIBE TABLE i_attach LINES li_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZORDER_UPD' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    li_packing_list-doc_type   =  'CSV'.
    li_packing_list-obj_descr  =  lv_file_name. "p_attdescription.
    li_packing_list-obj_name   =  lv_file_name. "'CMR'."p_filename.
    li_packing_list-doc_size   =  li_packing_list-body_num * 255.
    APPEND li_packing_list.
  ENDIF. " IF i_attach[] IS NOT INITIAL

  CLEAR : lst_usr21,lst_adr6.
  SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = p_userid.
  IF sy-subrc EQ 0 AND lst_usr21 IS NOT INITIAL.
    SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                            AND   persnumber = lst_usr21-persnumber.
    IF sy-subrc NE 0.
      CLEAR:lst_adr6.
    ENDIF.
  ENDIF. " IF lst_usr21 IS NOT INITIAL
*- Add the recipients email address
  CLEAR li_receivers.
  li_receivers-receiver = lst_adr6-smtp_addr.
  li_receivers-rec_type = 'U'.
  li_receivers-com_type = 'INT'.
  li_receivers-notif_del = abap_true.
  li_receivers-notif_ndel = abap_true.
  APPEND li_receivers.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_true
      commit_work                = abap_true
    TABLES
      packing_list               = li_packing_list
      contents_bin               = li_attachment
      contents_txt               = i_message
      receivers                  = li_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc NE 0.
    MESSAGE text-083 TYPE c_e. "Error in sending Email
  ELSE. " ELSE -> IF sy-subrc NE 0
    MESSAGE text-084 TYPE c_s. "Email sent with Success log file
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_MOVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_move_file .  "E225

  DATA:
    lv_dirtemp   TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_path      TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_directory TYPE btcxpgpar,                               " Parameters of external program (string)                          " Directory of Files
    li_exec_move TYPE STANDARD TABLE OF btcxpm INITIAL SIZE 0. " Log message from external program to calling program

  IF p_a_file IS NOT INITIAL.
    lv_path = p_a_file.
    READ TABLE i_err_msg TRANSPORTING NO FIELDS WITH KEY msgty = c_e.
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF '/E101/in' IN lv_path WITH '/E101/err'.
    ELSE. " ELSE -> IF sy-subrc = 0
      REPLACE ALL OCCURRENCES OF '/E101/in' IN lv_path WITH '/E101/prc'.
    ENDIF. " IF sy-subrc = 0

    i_err_msg1 = i_err_msg.
    PERFORM transfer_add_error_msg IN PROGRAM saplwlf5
      TABLES i_err_msg1 i_err_msg_list.
    PERFORM f_send_log_email.

    lv_dirtemp = p_a_file.
    CONCATENATE lv_dirtemp
                lv_path
          INTO lv_directory
          SEPARATED BY space.

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = 'ZSSPMOVE'
        additional_parameters         = lv_directory
      TABLES
        exec_protocol                 = li_exec_move
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR: li_exec_move[],
           lv_directory,
           lv_dirtemp.
  ENDIF. " IF p_a_file IS NOT INITIAL

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING   fp_lv_filename.  "E225
  DATA : lv_path         TYPE filepath-pathintern .
  DATA:lv_path_fname TYPE string.
  CLEAR : lv_path_fname,lv_path.
  DATA:lv_file TYPE string."V_PATH_FNAME
  IF sy-batch IS INITIAL.
    CONCATENATE  'E225_ORD_UPLD' sy-uname v_oid  INTO lv_file SEPARATED BY c_uns.
    CONCATENATE  lv_file c_extn  INTO lv_file .
    CONDENSE  lv_file NO-GAPS.
  ELSE.
    CLEAR v_fpath.
    CONCATENATE 'E225_ORD_UPLD_' sy-datum c_uns sy-uzeit c_uns sy-uname
                " Log number / Order Id
                 c_extn
                 INTO
                 lv_file.
    CONDENSE  lv_file NO-GAPS.
  ENDIF.
  lv_path = fp_lv_filename.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = lv_file
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ELSE.
    v_path_fname = lv_path_fname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_template_file . "E225
  DATA : lst_filecontent TYPE zca_templates,
         lv_xstr_content TYPE xstring,
         li_content      TYPE STANDARD TABLE OF tdline,              " Data Declaration for File upload
         lv_len          TYPE i,
         lv_fname        TYPE string,
         lv_fpath        TYPE string,
         lv_path         TYPE string.
  CLEAR : lst_filecontent.
  IF sy-ucomm = c_fc01.
    SELECT SINGLE * FROM zca_templates            " Select file content based on selection screen value
      INTO lst_filecontent
      WHERE program_name  = sy-repid
        AND active        = abap_true
        AND wricef_id     = c_devid.
    IF sy-subrc IS INITIAL.
      lv_xstr_content = lst_filecontent-file_content.
    ENDIF.

    "Convert xstring/rawstring to binary itab
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_xstr_content
      IMPORTING
        output_length = lv_len
      TABLES
        binary_tab    = li_content.

    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        default_extension = 'XLS'
        window_title      = 'Save dialog'
      CHANGING
        filename          = lv_fname
        path              = lv_path
        fullpath          = lv_fpath.
    IF sy-subrc EQ 0.
      " Download file to presentation server from SAP
      CALL METHOD cl_gui_frontend_services=>gui_download
        EXPORTING
          bin_filesize            = lv_len
          filename                = lv_fpath
          filetype                = 'BIN'
        CHANGING
          data_tab                = li_content
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21
          not_supported_by_gui    = 22
          error_no_gui            = 23
          OTHERS                  = 24.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        MESSAGE s010(zfilupload).
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_APPSERV_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FINAL_X  text
*      -->P_1438   text
*      -->P_TYPE   text
*----------------------------------------------------------------------*
FORM f_fill_appserv_log_data  USING    fp_st_final_x TYPE zstqtc_bporder "ty_excel_enhanced
                                       fp_text TYPE string
                                       fp_type TYPE c.
  DATA: lv_kwmeng TYPE char20,
        lv_kdkg   TYPE kdkg3,
        lv_plant  TYPE werks_d.

  IF fp_type =  c_s.
    CLEAR:lv_kwmeng.
    lv_kwmeng = st_final_x-kwmeng.

    CONCATENATE
                abap_true
                fp_st_final_x-customer
                fp_st_final_x-parvw
                fp_st_final_x-partner2
                fp_st_final_x-vkorg
                fp_st_final_x-vtweg
                fp_st_final_x-spart
                fp_st_final_x-vbegdat
                fp_st_final_x-venddat
                fp_st_final_x-posnr
                fp_st_final_x-matnr
                lv_plant
                fp_st_final_x-vbeln
                fp_st_final_x-pstyv
                lv_kwmeng
                fp_st_final_x-lifsk
                fp_st_final_x-faksk
                fp_st_final_x-augru  "dummy for  abgru
                fp_st_final_x-bsark
                fp_st_final_x-auart
                fp_st_final_x-xblnr
                fp_st_final_x-zlsch
                fp_st_final_x-bstnk
                fp_st_final_x-stxh
                fp_st_final_x-kschl
                fp_st_final_x-kbetr
                fp_st_final_x-ihrez
                fp_st_final_x-zzpromo
                fp_st_final_x-kdkg4
                fp_st_final_x-pq_typ
                fp_st_final_x-kdkg4_2
                fp_st_final_x-ihrez_e
                fp_st_final_x-vkbur
                fp_st_final_x-fkdat
                fp_st_final_x-waerk
                fp_st_final_x-zuonr
                fp_st_final_x-invinst  "inv_text
                fp_st_final_x-vaktsch
                fp_st_final_x-vasda
                fp_st_final_x-perio
                fp_st_final_x-autte
                fp_st_final_x-peraf
                fp_st_final_x-ord_reason
                fp_st_final_x-kdkg2
            INTO st_final_csv SEPARATED BY c_pipe.

    APPEND st_final_csv TO i_final_csv.
    CLEAR:st_final_csv.
  ELSEIF fp_type EQ c_e.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG_STAGING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_log_staging USING fp_lst_final TYPE zstqtc_bporder
                                fp_oid  TYPE numc10
                                fp_item TYPE posnr
                              CHANGING   fp_lv_log TYPE balognr
                                fp_msgty TYPE c
                                fp_loghandle TYPE balloghndl
                                fp_lst_final3 TYPE zstqtc_bporder.


  STATICS:lst_final2     TYPE zstqtc_bporder,
          lv_logno       TYPE balognr,
          lst_log_handle TYPE balloghndl.
  DATA:lv_save TYPE char1.
  IF  fp_lst_final-identifier IS INITIAL.
    fp_lst_final-identifier = 'DUMMY'.
  ENDIF.
  IF lst_final2-identifier NE  fp_lst_final-identifier.
    CLEAR:v_error,lst_log_handle.
    IF fp_lst_final-identifier NE 'DUMMY'.
      lst_final2    = fp_lst_final.
      fp_lst_final3 = fp_lst_final.
    ENDIF.
    iv_identifier     = fp_lst_final-identifier.
    st_log-object     = 'ZQTC'.
    st_log-subobject  = 'ZBP_ORDER'.
    st_log-extnumber  = fp_oid.
    st_log-aldate     = sy-datum.
    st_log-altime     = sy-uzeit.
    st_log-aluser     = sy-uname.
    st_log-alprog     = sy-repid.

    IF fp_lst_final-auart IS NOT INITIAL AND fp_lst_final-auart IN i_auart.
      CLEAR:v_error.
    ELSE.
      v_error = abap_true.
    ENDIF.

    CLEAR:st_log_handle.
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = st_log
      IMPORTING
        e_log_handle            = st_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.

    IF st_log_handle IS NOT INITIAL.
      lst_log_handle = st_log_handle.
      CLEAR:st_msg.
      st_msg-msgty = c_i.
      IF v_error IS NOT INITIAL.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-auart.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 = text-112.
      ENDIF.
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*---identification number
    IF  fp_lst_final-identifier = 'DUMMY'.
      CLEAR fp_lst_final-identifier.
    ENDIF.
    IF fp_lst_final-identifier IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Identification Number is missing in the file'(151).
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Partner Function
    IF fp_lst_final-parvw IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Partner Function is missing in the file'(152) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Header/Item Identifier
    IF fp_lst_final-head_item IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Header/Item Identifier is missing in the file'(153) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
    IF fp_lst_final-customer IS NOT INITIAL AND fp_lst_final-parvw  NE 'SP'.
      SELECT SINGLE partner,
                    xblck,
                    xdele
         FROM but000
        INTO @DATA(ls_but000)
        WHERE partner = @fp_lst_final-customer.
      IF sy-subrc NE 0.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-customer.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'BP Number does not exist'(186) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
      IF  ls_but000-xblck IS NOT INITIAL
        OR ls_but000-xdele IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-customer.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'BP Number has Central block'(187) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ELSE.
*-----BP Type
      IF fp_lst_final-bu_type IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 =  'BP Type is missing in the file'(154) .
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.

      ENDIF.
*-----First Name
      IF fp_lst_final-name_f IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 = 'First Name is missing in the file'(155) .
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Last Name
      IF fp_lst_final-name_l IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Last Name is missing in the file'(156) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Address1
      IF fp_lst_final-street IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Address1 is missing in the file'(157) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----City
      IF fp_lst_final-city1 IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'City is missing in the file'(158) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Region
      IF fp_lst_final-region IS INITIAL AND fp_lst_final-country = 'US' .
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Region is missing in the file'(159) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Country
      IF fp_lst_final-country IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Country is missing in the file'(160) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Postal Code
      IF fp_lst_final-post_code1 IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Postal Code is missing in the file'(161) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Language Code
      IF fp_lst_final-spras IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Language Code is missing in the file'(162) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Communication Method
      IF fp_lst_final-deflt_comm IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Communication Method is missing in the file'(163) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.

*-----If the Society Presence
      IF rb_soc IS NOT INITIAL.
*-----BP Relationship Category
        IF fp_lst_final-reltyp IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
*          st_msg-msgv1 = fp_lst_final-customer.
*          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'BP Relationship Category  is missing in the file'(164) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
*-----Validity Date from
        IF fp_lst_final-datfrom IS INITIAL.
          CLEAR st_msg.
          st_msg-msgty = c_e.
*          st_msg-msgv1 = fp_lst_final-customer.
*          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Validity Date from  is missing in the file'(165) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
*-----Validity Date to
        IF fp_lst_final-dateto IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
*          st_msg-msgv1 = fp_lst_final-customer.
*          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Validity Date to is missing in the file'(166) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
*-----Society BP Number
        IF fp_lst_final-partner2 IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
*          st_msg-msgv1 = fp_lst_final-customer.
*          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Society BP Number is missing in the file'(167) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
      ENDIF.

*-----Customer group
      IF fp_lst_final-kdgrp IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
*        st_msg-msgv1 = fp_lst_final-customer.
*        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Customer group is missing in the file'(168) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.
*-----Sales Document Type
    IF fp_lst_final-auart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Sales Document Type is missing in the file'(169) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Sales Organization
    IF fp_lst_final-vkorg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Sales Organization is missing in the file'(170) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Distribution Channel
    IF fp_lst_final-vtweg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Distribution Channel is missing in the file'(171) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Division
    IF fp_lst_final-spart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Division is missing in the file'(172) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Sales Office
    IF fp_lst_final-vkbur IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Sales Office is missing in the file'(173) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Purchase Order Type
    IF fp_lst_final-bsark IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Purchase Order Type is missing in the file'(174) .
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----If the Sales document type category is 'G'
*    READ TABLE i_tvak ASSIGNING FIELD-SYMBOL(<lfs_tvak>) WITH KEY auart = fp_lst_final-auart BINARY SEARCH.
*    IF <lfs_tvak>-vbtyp = 'G'.
**-----Contract Start date
*      IF fp_lst_final-vbegdat IS INITIAL.
*        CLEAR:st_msg.
*        st_msg-msgty = c_e.
*        st_msg-msgv1 =  'Contract Start Date is missing in the file'(177) .
*        PERFORM f_adding_log USING fp_lst_final fp_item
*                             CHANGING   fp_lv_log
*                                        fp_msgty
*                                        fp_loghandle.
*      ENDIF.
**-----Contract End date
*      IF fp_lst_final-venddat IS INITIAL.
*        CLEAR:st_msg.
*        st_msg-msgty = c_e.
*        st_msg-msgv1 =  'Contract End date is missing in the file'(178) .
*        PERFORM f_adding_log USING fp_lst_final fp_item
*                             CHANGING   fp_lv_log
*                                        fp_msgty
*                                        fp_loghandle.
*      ENDIF.
*    ENDIF.
    IF fp_lst_final-auart IN i_auart_head."
*-----contract start date
      IF fp_lst_final-vbegdat IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Contract Start Date is missing in the file'(177) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Contract End date
      IF fp_lst_final-venddat IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Contract End date is missing in the file'(178) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.
    IF fp_lst_final-head_item = c_i  OR fp_lst_final-head_item = c_i_s..    "ERPM-19878  ED2K918239
*-----Order Qty
      IF fp_lst_final-kwmeng IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 =  'Order Qty is missing in the file'(179) .
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.

*-----If the Order Type is ZOFL
      IF fp_lst_final-auart = 'ZOFL'.
*-----Customer condition group 2
        IF fp_lst_final-kdkg2 IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv3 = fp_lst_final-posnr.
          st_msg-msgv2 = text-t10.
          st_msg-msgv1 =  'Customer condition group 2 is missing in the file'(181) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.
* ------ PO Type ----------------------
* BOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
    IF fp_lst_final-auart EQ c_zor AND fp_lst_final-bsark IS INITIAL.

      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv3 = fp_lst_final-posnr.
      st_msg-msgv2 = text-t10.
      st_msg-msgv1 =  'PO Type is missing in file for Order type'(194).
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.

    ENDIF.
* EOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
*** BOC MIMMADISET ED2K921891 OTCM-39536
*-----Society BP Number
    IF rb_soc IS NOT INITIAL.
      IF fp_lst_final-partner2 IS NOT INITIAL AND ( fp_lst_final-parvw EQ 'SP'
        OR fp_lst_final-parvw EQ 'AG' ).
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv2 =  'Sold to party'(197).
        st_msg-msgv3 =  ' line should not contain society field in the file'(195) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----BP Relationship Category
      IF fp_lst_final-reltyp IS NOT INITIAL AND ( fp_lst_final-parvw EQ 'SP'
        OR fp_lst_final-parvw EQ 'AG' ).
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 =  'Sold to party should not have any relationship category in the file'(196).
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.
*** EOC MIMMADISET ED2K921891 OTCM-39536
  ELSE.  "Line item details

*---identification number
    IF  fp_lst_final-identifier = 'DUMMY'.
      CLEAR fp_lst_final-identifier.
    ENDIF.
    IF fp_lst_final-identifier IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv3 = 'Identification Number is missing in the file'(151).
      st_msg-msgv1 = fp_lst_final-posnr.
      st_msg-msgv2 = text-t10.
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Partner Function
    IF fp_lst_final-parvw IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv3 =  'Partner Function is missing in the file'(152) .
      st_msg-msgv1 = fp_lst_final-posnr.
      st_msg-msgv2 = text-t10.
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
*-----Header/Item Identifier
    IF fp_lst_final-head_item IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv3 =  'Header/Item Identifier is missing in the file'(153) .
      st_msg-msgv1 = fp_lst_final-posnr.
      st_msg-msgv2 = text-t10.
      PERFORM f_adding_log USING fp_lst_final fp_item
                           CHANGING   fp_lv_log
                                      fp_msgty
                                      fp_loghandle.
    ENDIF.
    IF fp_lst_final-customer IS NOT INITIAL.
      IF  fp_lst_final-parvw NE 'SP'.
        FREE:ls_but000.
        SELECT SINGLE partner
                      xblck
                      xdele
          FROM but000
          INTO ls_but000
          WHERE partner = fp_lst_final-customer.
        IF sy-subrc NE 0.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-customer.
          st_msg-msgv3 =  'BP Number is does not exist'(186) .
          st_msg-msgv2 = text-t10.
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
        IF  ls_but000-xblck IS NOT INITIAL
                OR ls_but000-xdele IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-customer.
          st_msg-msgv2 = fp_lst_final-posnr.
          st_msg-msgv3 =  'BP Number has Central block'(187) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.

      ELSEIF fp_lst_final-parvw EQ 'SP'.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = fp_lst_final-customer
          IMPORTING
            output = fp_lst_final-customer.

        SELECT SINGLE lifnr INTO @DATA(lv_lifnr)
          FROM lfa1
          WHERE lifnr = @fp_lst_final-customer.
        IF sy-subrc NE 0 AND lv_lifnr IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-posnr.
          st_msg-msgv2 =  ' Forwarding Agent is not valid :'(191) .
          st_msg-msgv3 =  fp_lst_final-customer .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ELSE.
          CLEAR :lv_lifnr.
        ENDIF.
      ENDIF.                    "fp_lst_final-parvw NE 'SP'.

    ELSE.
*-----BP Type
      IF fp_lst_final-bu_type IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv3 =  'BP Type is missing in the file'(154) .
        st_msg-msgv2 = text-t10.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----First Name
      IF fp_lst_final-name_f IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 = 'First Name is missing in the file'(155) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Last Name
      IF fp_lst_final-name_l IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Last Name is missing in the file'(156) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Address1
      IF fp_lst_final-street IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Address1 is missing in the file'(157) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----City
      IF fp_lst_final-city1 IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'City is missing in the file'(158) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Region
      IF fp_lst_final-region IS INITIAL AND fp_lst_final-country = 'US' .
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Region is missing in the file'(159) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Country
      IF fp_lst_final-country IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgty = c_e.
        st_msg-msgv3 =  'Country is missing in the file'(160) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Postal Code
      IF fp_lst_final-post_code1 IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Postal Code is missing in the file'(161) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Language Code
      IF fp_lst_final-spras IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Language Code is missing in the file'(162) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Communication Method
      IF fp_lst_final-deflt_comm IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Communication Method is missing in the file'(163) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.

*-----If the Society Presence
      IF rb_soc IS NOT INITIAL.
*-----Validity Date from
        IF fp_lst_final-datfrom IS INITIAL.
          CLEAR st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-posnr.
          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Validity Date from  is missing in the file'(165) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
*-----Validity Date to
        IF fp_lst_final-dateto IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-posnr.
          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Validity Date to is missing in the file'(166) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
      ENDIF.

*-----Customer group
      IF fp_lst_final-kdgrp IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv2 = text-t10.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv3 =  'Customer group is missing in the file'(168) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.      ENDIF.
    ENDIF.
    IF fp_lst_final-head_item = c_i OR  fp_lst_final-head_item = c_i_s. "ERPM-19878  ED2K918239
*-----Sales Document Item
      IF fp_lst_final-posnr IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Sales Document Item is missing in the file'(175) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Material Number
      IF fp_lst_final-matnr IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Material Number is missing in the file'(176) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*---Email Address validation
      IF fp_lst_final-matnr IS NOT INITIAL.
        SELECT SINGLE ismmediatype
          FROM mara
          INTO @DATA(ls_mediatyp)
          WHERE matnr = @fp_lst_final-matnr.
        IF sy-subrc = 0 AND ( ls_mediatyp = 'DI' ).         "ED1K911917
          IF fp_lst_final-smtp_addr IS INITIAL.
            CLEAR:st_msg.
            st_msg-msgty = c_e.
            st_msg-msgv1 = fp_lst_final-posnr.
            st_msg-msgv2 = text-t10.
            st_msg-msgv3 =  'Email ID is missing in the file'.
            PERFORM f_adding_log USING fp_lst_final fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*** BOC MIMMADISET ED2K921891 OTCM-39536
    IF fp_lst_final-customer IS NOT INITIAL AND ( fp_lst_final-parvw EQ 'SH'
      OR fp_lst_final-parvw EQ 'WE' ).
      READ TABLE i_final INTO DATA(ls_sales)
      WITH KEY identifier = fp_lst_final-identifier head_item = 'H'.
      IF sy-subrc = 0 AND ls_sales-vkorg IS NOT INITIAL
        AND ls_sales-vtweg IS NOT INITIAL
        AND ls_sales-spart IS NOT INITIAL.
** Fecth Customer overall sales block
        SELECT SINGLE kunnr, aufsd
          FROM knvv INTO @DATA(ls_knvv)
          WHERE kunnr = @fp_lst_final-customer AND
                vkorg = @ls_sales-vkorg AND
                vtweg = @ls_sales-vtweg AND
                spart = @ls_sales-spart AND
                aufsd NE @space.
        IF sy-subrc = 0.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-customer.
          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Selected sales area is blocked'(194) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
      ENDIF.
      SELECT SINGLE kunnr,aufsd
        FROM kna1 INTO @DATA(ls_kna1)
        WHERE kunnr = @fp_lst_final-customer AND
              aufsd NE @space.
      IF sy-subrc = 0.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-customer.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'All Sales areas is blocked'(194) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.
    IF rb_soc IS NOT INITIAL.
*-----Society BP Number
      IF fp_lst_final-partner2 IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Society BP Number is missing in the file'(167) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----BP Relationship Category
      IF fp_lst_final-reltyp IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'BP Relationship Category  is missing in the file'(164) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.

*** EOC MIMMADISET ED2K921891 OTCM-39536
*-----If the Sales document item category is 'G'
*    READ TABLE i_tvak ASSIGNING FIELD-SYMBOL(<lst_vbty>) WITH KEY auart = lst_final2-auart BINARY SEARCH.
*    IF sy-subrc EQ 0 AND <lst_vbty>-vbtyp EQ 'G' AND lst_final2-auart NE 'ZSBP' AND lst_final2-auart EQ 'ZSUB'.
    IF lst_final2-auart  IN i_auart_item.
*-----Contract Start date
      IF fp_lst_final-vbegdat IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Contract Start Date is missing in the file'(177) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
*-----Contract End date
      IF fp_lst_final-venddat IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgv3 =  'Contract End date is missing in the file'(178) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.
    ENDIF.
    IF fp_lst_final-head_item = c_i OR fp_lst_final-head_item = c_i_s. "ERPM-19878  ED2K918239
*-----Order Qty
      IF fp_lst_final-kwmeng IS INITIAL.
        CLEAR:st_msg.
        st_msg-msgv1 = fp_lst_final-posnr.
        st_msg-msgv2 = text-t10.
        st_msg-msgty = c_e.
        st_msg-msgv3 =  'Order Qty is missing in the file'(179) .
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.

*-----If the condition is presence
      IF fp_lst_final-kschl IS NOT INITIAL.
*-----Price Condition Value
        IF fp_lst_final-kbetr IS INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 = fp_lst_final-posnr.
          st_msg-msgv2 = text-t10.
          st_msg-msgv3 =  'Price Condition Value is missing in the file'(180) .
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.
      ENDIF.
* BOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
      IF rb_soc IS NOT INITIAL.
*      IF fp_lst_final-kdkg2 IS NOT INITIAL AND lst_final2-auart IS NOT INITIAL AND lst_final2-auart NE c_zofl.
        IF fp_lst_final-kdkg2 IS NOT INITIAL AND lst_final2-auart IS NOT INITIAL AND lst_final2-auart NOT IN i_auart_grp.
* EOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611

          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv3 = text-113.
          st_msg-msgv2 = text-t10.
          st_msg-msgv1 = fp_lst_final-posnr.
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
* BOC by Thilina on 09/29/2020 for ERPM-4390 with ED2K919708
        ELSEIF fp_lst_final-kdkg2 IS INITIAL AND lst_final2-auart IS NOT INITIAL AND lst_final2-auart EQ c_zor
          AND fp_lst_final-pstyv IN i_pstyv_grp.

          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv3 = 'Condition Group2 is missing in file for Order type'(183).
          st_msg-msgv2 = text-t10.
          st_msg-msgv1 = fp_lst_final-posnr.
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
* EOC by Thilina on 09/29/2020 for ERPM-4390 with ED2K919708
        ENDIF.
* BOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
      ELSE.

        IF fp_lst_final-kdkg2 IS NOT INITIAL AND lst_final2-auart IS NOT INITIAL AND lst_final2-auart NE c_zofl.

          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv3 = text-113.
          st_msg-msgv2 = text-t10.
          st_msg-msgv1 = fp_lst_final-posnr.
          PERFORM f_adding_log USING fp_lst_final fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
        ENDIF.

      ENDIF.
* EOC by Thilina on 09/23/2020 for ERPM-4390 with ED2K919611
      IF fp_lst_final-kdkg2 IS INITIAL AND lst_final2-auart IS NOT INITIAL AND lst_final2-auart EQ c_zofl.

        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 = 'Condition Group2 is missing in file for Order type'(183).
        st_msg-msgv2 = text-t10.
        st_msg-msgv1 = fp_lst_final-posnr.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
      ENDIF.

*  BOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725
      IF lst_final2-auart EQ c_zor AND fp_lst_final-bsark IS INITIAL.

        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv3 = 'PO Type is missing in file for Order type'(194).
        st_msg-msgv2 = text-t10.
        st_msg-msgv1 = fp_lst_final-posnr.
        PERFORM f_adding_log USING fp_lst_final fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.

      ENDIF.
*  EOC by Thilina on 09/30/2020 for ERPM-4390 with ED2K919725

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_FILE_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_write_file_application USING fp_path_fname.
  DATA:lv_file TYPE string.

  p_a_file = fp_path_fname."lv_file.
  CONDENSE  p_a_file NO-GAPS.
  CLOSE DATASET p_a_file.


  OPEN DATASET p_a_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_final INTO DATA(lst_final).
      CONCATENATE lst_final-identifier
                  lst_final-customer
                  lst_final-parvw
                  lst_final-head_item
                  lst_final-bu_type
                  lst_final-bu_title
                  lst_final-name_f
                  lst_final-name_l
                  lst_final-suffix
                  lst_final-str_suppl2
                  lst_final-str_suppl1
                  lst_final-street
                  lst_final-str_suppl3
                  lst_final-location
                  lst_final-city1
                  lst_final-region
                  lst_final-country
                  lst_final-post_code1
                  lst_final-spras
                  lst_final-deflt_comm
                  lst_final-smtp_addr
                  lst_final-tel_number
                  lst_final-reltyp
                  lst_final-datfrom
                  lst_final-dateto
                  lst_final-partner2
                  lst_final-katr6
                  lst_final-kdgrp
                  lst_final-auart
                  lst_final-ord_reason
                  lst_final-vbeln
                  lst_final-vkorg
                  lst_final-vtweg
                  lst_final-spart
                  lst_final-vkbur
                  lst_final-waerk
                  lst_final-bstnk
                  lst_final-bsark
                  lst_final-xblnr
                  lst_final-zuonr
                  lst_final-zlsch
                  lst_final-fkdat
                  lst_final-stxh
                  lst_final-invinst
                  lst_final-vaktsch
                  lst_final-vasda
                  lst_final-perio
                  lst_final-autte
                  lst_final-peraf
                  lst_final-lifsk
                  lst_final-faksk
                  lst_final-posnr
                  lst_final-matnr
                  lst_final-vbegdat
                  lst_final-venddat
                  lst_final-pstyv
                  lst_final-kwmeng
                  lst_final-augru
                  lst_final-kschl
                  lst_final-kbetr
                  lst_final-ihrez_e
                  lst_final-zzpromo
                  lst_final-kdkg4
                  lst_final-kdkg4_2
                  lst_final-pq_typ
                  lst_final-ihrez
                  lst_final-kdkg2
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
                  lst_final-zzconstart
                  lst_final-zzconend
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820/ED2K920085 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
                  "lst_final-vlaufk
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
                  lst_final-vlaufz
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
                  lst_final-zlogno
                  lst_final-msgty
                  lst_final-msgv1
                  lst_final-log_handle
                  lst_final-zoid
                  lst_final-snum


                  INTO DATA(lv_data) SEPARATED BY c_pipe.
      TRANSFER lv_data TO p_a_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET p_a_file.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_PROGRAM_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_submit_program_background .
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  CONSTANTS: lc_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_p_file      TYPE rsscr_name VALUE 'P_A_FILE',
             lc_tbt         TYPE rsscr_name VALUE 'RB_TBT',
             lc_ftp         TYPE rsscr_name VALUE 'RB_FTP',
             lc_soc         TYPE rsscr_name VALUE 'RB_SOC',
             lc_file        TYPE rsscr_name VALUE 'P_L_FILE',
             lc_v_oid       TYPE rsscr_name VALUE 'P_V_OID',
             lc_user        TYPE rsscr_name VALUE 'P_USERID',
             lc_auart       TYPE rsscr_name VALUE 'P_AUART'.

  DATA:lv_bjob TYPE char1.

  CLEAR:lst_params.
  lst_params-selname = lc_p_file.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = p_a_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_tbt.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = rb_tbt.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_ftp.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = rb_ftp.
  APPEND lst_params TO li_params.
  CLEAR lst_params.
  lst_params-selname = lc_soc.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = rb_soc.
  APPEND lst_params TO li_params.
  CLEAR lst_params.
  lst_params-selname = lc_user.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = sy-uname.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_file.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = p_file.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_v_oid.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = p_v_oid.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_auart.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = v_auart.
  p_auart     = v_auart.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE c_devid c_uns v_oid c_uns sy-datum    INTO lv_jobname.
  CONDENSE lv_jobname NO-GAPS.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    lv_bjob = abap_true.
    IF lv_bjob = abap_true.
      SUBMIT zqtcr_bp_order_upld_e225 WITH SELECTION-TABLE li_params
                                      WITH i_stage = i_staging
                                      USER  iv_batchuser  "'QTC_BATCH01'
                                      VIA JOB lv_jobname NUMBER lv_number
                                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_bp_order_upld_e225 WITH SELECTION-TABLE li_params
                                      WITH i_stage = i_staging.

    ENDIF.
  ENDIF.

  IF sy-subrc = 0.
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_number   "Job number
        jobname              = lv_jobname  "Job name
        strtimmed            = abap_true   "Start immediately
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        OTHERS               = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  MESSAGE i261(zqtc_r2) WITH lv_jobname.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_file_application .
  DATA:lv_data TYPE string.
  FREE:st_final_x,lv_data,i_final.
  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    DO.
      READ DATASET p_a_file INTO lv_data.
      IF sy-subrc = 0.
        SPLIT lv_data AT '|' INTO :
                  st_final_x-identifier
                  st_final_x-customer
                  st_final_x-parvw
                  st_final_x-head_item
                  st_final_x-bu_type
                  st_final_x-bu_title
                  st_final_x-name_f
                  st_final_x-name_l
                  st_final_x-suffix
                  st_final_x-str_suppl2
                  st_final_x-str_suppl1
                  st_final_x-street
                  st_final_x-str_suppl3
                  st_final_x-location
                  st_final_x-city1
                  st_final_x-region
                  st_final_x-country
                  st_final_x-post_code1
                  st_final_x-spras
                  st_final_x-deflt_comm
                  st_final_x-smtp_addr
                  st_final_x-tel_number
                  st_final_x-reltyp
                  st_final_x-datfrom
                  st_final_x-dateto
                  st_final_x-partner2
                  st_final_x-katr6
                  st_final_x-kdgrp
                  st_final_x-auart
                  st_final_x-ord_reason
                  st_final_x-vbeln
                  st_final_x-vkorg
                  st_final_x-vtweg
                  st_final_x-spart
                  st_final_x-vkbur
                  st_final_x-waerk
                  st_final_x-bstnk
                  st_final_x-bsark
                  st_final_x-xblnr
                  st_final_x-zuonr
                  st_final_x-zlsch
                  st_final_x-fkdat
                  st_final_x-stxh
                  st_final_x-invinst
                  st_final_x-vaktsch
                  st_final_x-vasda
                  st_final_x-perio
                  st_final_x-autte
                  st_final_x-peraf
                  st_final_x-lifsk
                  st_final_x-faksk
                  st_final_x-posnr
                  st_final_x-matnr
                  st_final_x-vbegdat
                  st_final_x-venddat
                  st_final_x-pstyv
                  st_final_x-kwmeng
                  st_final_x-augru
                  st_final_x-kschl
                  st_final_x-kbetr
                  st_final_x-ihrez_e
                  st_final_x-zzpromo
                  st_final_x-kdkg4
                  st_final_x-kdkg4_2
                  st_final_x-pq_typ
                  st_final_x-ihrez
                  st_final_x-kdkg2
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
                  st_final_x-zzconstart
                  st_final_x-zzconend
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
*--BOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
* BOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
*                  st_final_x-vlaufk
* EOC by Lahiru on 05/17/2021 for OTCM-42807 with  ED2K923446 *
                  st_final_x-vlaufz
*--EOC by Prabhu  OTCM-42807 ED2K922718 03/25/2021
                  st_final_x-zlogno
                  st_final_x-msgty
                  st_final_x-msgv1
                  st_final_x-log_handle
                  st_final_x-zoid
                  st_final_x-snum.

        .
        APPEND st_final_x TO i_final.
        CLEAR st_final_x.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  ELSE.
    MESSAGE e256(zqtc_r2) WITH p_a_file.
  ENDIF.
  CLOSE DATASET p_a_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_data .
  DATA:lv_im_source  TYPE tpm_source_name,
       lst_bp_data   TYPE zsqtc_bp_update,
       lv_proc_file  TYPE string,
       lv_error_file TYPE string,
       li_final_t    TYPE zttqtc_bporder.

  DATA:li_log_handle TYPE bal_t_logh,
       lv_tbx2       TYPE sy-tabix.
  CONSTANTS:lc_tbt    TYPE char3  VALUE 'TBT',
            lc_ftp    TYPE char3  VALUE 'FTP',
            lc_source TYPE char10 VALUE 'SOCIETY'.
  FREE:i_bp_data,lst_bp_data,lv_im_source.
  IF  rb_tbt IS NOT INITIAL.
    lv_im_source = lc_tbt.
  ELSEIF rb_ftp IS NOT INITIAL.
    lv_im_source = lc_ftp.
  ELSEIF rb_soc IS NOT INITIAL.
    lv_im_source = lc_source.
  ENDIF.

  IF i_final IS NOT INITIAL.
    DATA(i_final22) = i_final.
    LOOP AT i_final22 ASSIGNING FIELD-SYMBOL(<lst_err22>) WHERE msgty = c_e.
      LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_err32>) WHERE identifier = <lst_err22>-identifier.
        <lst_err32>-msgty = c_e.
      ENDLOOP.
    ENDLOOP.

    FREE:li_final_t.
    li_final_t = i_final.
    DELETE i_final    WHERE msgty = c_e.
    DELETE li_final_t WHERE msgty NE c_e.

    SELECT * FROM ze225_staging INTO TABLE i_staging
      FOR ALL ENTRIES IN i_final
      WHERE zlogno = i_final-zlogno.
    IF sy-subrc EQ 0.
      SORT i_staging[] BY zlogno.
    ENDIF.
*---Mapping final data to funcational module struture
    LOOP AT i_final INTO DATA(lst_final).
*      IF lst_final-customer IS INITIAL OR rb_soc IS NOT INITIAL.
      MOVE-CORRESPONDING lst_final TO lst_bp_data.
      APPEND lst_bp_data TO i_bp_data.
*      ENDIF.
      CLEAR:lst_final,lst_bp_data.
    ENDLOOP.

*---BP search and BP creation FM
    IF i_bp_data IS NOT INITIAL.
      CALL FUNCTION 'ZQTC_BP_SEARCH_CREATE_E225'
        EXPORTING
          im_source = lv_im_source
          im_devid  = c_devid
        TABLES
          t_file    = i_bp_data
          t_log     = i_staging.
*    ELSE.
*      DATA(lv_email_flag) = abap_true.
    ENDIF.
    LOOP AT i_final  ASSIGNING FIELD-SYMBOL(<lfs_final>).
      READ TABLE i_bp_data INTO lst_bp_data  WITH KEY snum = <lfs_final>-snum.
      IF sy-subrc = 0 AND lst_bp_data NE 'SP'.
        <lfs_final>-msgty    =  lst_bp_data-msgty.
        <lfs_final>-customer =  lst_bp_data-customer.
      ENDIF.
    ENDLOOP.
    CLEAR:lst_final.

    LOOP AT li_final_t INTO lst_final.
      APPEND lst_final TO i_final.
      CLEAR:lst_final.
    ENDLOOP.

    IF i_final IS NOT INITIAL.
      SELECT kunnr,
                       vkorg,
                       vtweg,
                       spart " Division
                  FROM knvv  " Customer Master Sales Data
                  INTO TABLE @DATA(li_knvv)
                  FOR ALL ENTRIES IN  @i_final
                  WHERE kunnr = @i_final-customer.
      IF sy-subrc EQ 0.
        SORT li_knvv BY kunnr vkorg vtweg spart.
      ENDIF.

*      SOC by NPOLINA 05/Apr/2021 ED2K922879 OTCM-38772
*      LOOP AT i_final INTO lst_final WHERE parvw NE 'SP' AND msgty NE c_e. "NPOLINA 09/June/2020  ED1K911915
      LOOP AT i_final INTO lst_final WHERE parvw NE 'SP' ."AND msgty NE c_e.
*      EOC by NPOLINA 05/Apr/2021 ED2K922879 OTCM-38772
        lv_tbx2 = sy-tabix.
        IF lst_final-head_item = 'H'.
          DATA(lst_finalh) = lst_final.
        ENDIF.

*      SOC by NPOLINA 05/Apr/2021 ED2K922879 OTCM-38772
        IF lst_final-msgty EQ c_e.
          CONTINUE.
        ENDIF.
*      EOC by NPOLINA 05/Apr/2021 ED2K922879 OTCM-38772

        READ TABLE li_knvv ASSIGNING FIELD-SYMBOL(<lst_knvv3>) WITH KEY kunnr = lst_final-customer
                                                                            vkorg = lst_finalh-vkorg
                                                                            vtweg = lst_finalh-vtweg
                                                                            spart = lst_finalh-spart BINARY SEARCH.
        IF sy-subrc NE 0.

          CLEAR:st_msg.
          st_msg-msgid = 'ZQTC_R2'.
          st_msg-msgno = '000'.
          st_msg-msgty = c_e.
          st_msg-msgv1 = lst_final-posnr.
          CONCATENATE text-190 lst_final-customer
          INTO st_msg-msgv2 SEPARATED BY space.
          CONCATENATE  ':' lst_finalh-vkorg lst_finalh-vtweg lst_finalh-spart
                                INTO st_msg-msgv3 SEPARATED BY space.

          FREE: li_log_handle[].
          APPEND lst_final-log_handle TO li_log_handle.
          CALL FUNCTION 'BAL_DB_LOAD'
            EXPORTING
              i_t_log_handle     = li_log_handle
            EXCEPTIONS
              no_logs_specified  = 1
              log_not_found      = 2
              log_already_loaded = 3
              OTHERS             = 4.
          IF sy-subrc EQ 0.
            FREE:st_log_handle.
            st_log_handle = lst_final-log_handle.
            CALL FUNCTION 'BAL_LOG_MSG_ADD'
              EXPORTING
                i_log_handle     = st_log_handle
                i_s_msg          = st_msg
              EXCEPTIONS
                log_not_found    = 1
                msg_inconsistent = 2
                log_is_full      = 3
                OTHERS           = 4.

            IF sy-subrc EQ 0.
              FREE:st_loghandle[].
              APPEND st_log_handle TO st_loghandle.
              CALL FUNCTION 'BAL_DB_SAVE'
                EXPORTING
                  i_client         = sy-mandt
                  i_save_all       = abap_true
                  i_t_log_handle   = st_loghandle
                IMPORTING
                  e_new_lognumbers = i_lognum
                EXCEPTIONS
                  log_not_found    = 1
                  save_not_allowed = 2
                  numbering_error  = 3
                  OTHERS           = 4.
              IF sy-subrc EQ 0.

                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                lst_final-msgty = c_e.
                MODIFY i_final FROM lst_final  INDEX lv_tbx2 TRANSPORTING msgty.
                READ TABLE i_staging ASSIGNING FIELD-SYMBOL(<lfs_stageh>) WITH KEY zlogno = lst_final-zlogno.
                IF sy-subrc EQ 0.
                  <lfs_stageh>-zprcstat = 'E2'.
                ENDIF.
                MODIFY ze225_staging FROM TABLE i_staging.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.    "SELECT KNVV

        CLEAR:lst_final.
      ENDLOOP.

    ENDIF.
    PERFORM f_moving_next_level.            " moving to PROC and deleteing from IN
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVING_NEXT_LEVEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_moving_next_level .
  DATA:
    lv_dirtemp   TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_path      TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_directory TYPE btcxpgpar,                               " Parameters of external program (string)                          " Directory of Files
    li_exec_move TYPE STANDARD TABLE OF btcxpm INITIAL SIZE 0. " Log message from external program to calling program
  FREE:lv_dirtemp,lv_path,lv_directory,li_exec_move.
  IF p_a_file IS NOT INITIAL.
    lv_path = p_a_file.
    READ TABLE i_final INTO DATA(lst_final) WITH KEY msgty = c_e.
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF '/E225/in/' IN lv_path WITH '/E225/err/'.
    ELSE. " ELSE -> IF sy-subrc = 0
      REPLACE ALL OCCURRENCES OF '/E225/in/' IN lv_path WITH '/E225/prc/'.
    ENDIF. " IF sy-subrc = 0

    lv_dirtemp = p_a_file.
    CONCATENATE lv_dirtemp
                lv_path
          INTO lv_directory
          SEPARATED BY space.

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = 'ZSSPMOVE'
        additional_parameters         = lv_directory
      TABLES
        exec_protocol                 = li_exec_move
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR: li_exec_move[],
           lv_directory,
           lv_dirtemp.
  ENDIF. " IF p_a_file IS NOT INITIAL
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_ADDING_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_MSG_MSGV1  text
*----------------------------------------------------------------------*
FORM f_adding_log USING fp_lst_final TYPE zstqtc_bporder
                        fp_item TYPE posnr
                   CHANGING   fp_lv_log   TYPE balognr
                              fp_msgty    TYPE c
                              fp_loghandle TYPE balloghndl.
  DATA:lv_logno       TYPE balognr,
       lst_log_handle TYPE balloghndl.
  st_msg-msgid = 'ZQTC_R2'.
  st_msg-msgno = '000'.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = st_log_handle
      i_s_msg          = st_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
*  st_log_handle = st_log_handle.
  APPEND st_log_handle TO st_loghandle.
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_client         = sy-mandt
      i_save_all       = abap_true
      i_t_log_handle   = st_loghandle
    IMPORTING
      e_new_lognumbers = i_lognum
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc EQ 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    IF sy-subrc EQ 0.
      CLEAR:st_staging.
    ENDIF.
    READ TABLE i_lognum ASSIGNING FIELD-SYMBOL(<lfs_lognum>) INDEX 1.
    IF sy-subrc EQ 0.
      st_staging-zlogno = <lfs_lognum>-lognumber.
      lv_logno =  <lfs_lognum>-lognumber.
      fp_loghandle = <lfs_lognum>-log_handle.
    ELSE.
      st_staging-zlogno =  fp_lv_log  ."lv_logno.
    ENDIF.
    st_staging-mandt = sy-mandt.
    st_staging-zuid_upld =  p_v_oid."FIle Identifier
    st_staging-zoid = iv_identifier."Order Identifier.
    st_staging-zitem = fp_item.
    st_staging-zuser = sy-uname.
    st_staging-zfilepath = p_file.
    st_staging-zbp = fp_lst_final-customer.
    st_staging-zcrtdat = sy-datum.
    st_staging-zcrttim = sy-uzeit.
    IF v_error EQ abap_true.
      st_staging-zprcstat = 'E2'.
    ENDIF.
    fp_lv_log = st_staging-zlogno.
    fp_msgty = st_msg-msgty.
    fp_loghandle = fp_loghandle."lst_log_handle.
*---BOC NPALLA Staging Changes 12/17/2021  E225 ED2K924398 OTCM-47267
    PERFORM f_get_intf_stage_id CHANGING st_staging.
*---EOC NPALLA Staging Changes 12/17/2021  E225 ED2K924398 OTCM-47267
    APPEND st_staging TO i_staging.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_E225
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_e225 .
  DATA:
    lv_xls            TYPE so_obj_tp  VALUE 'xls',
    lv_htm            TYPE so_obj_tp  VALUE 'HTM',
    lv_sub            TYPE string,
    lv_mailto         TYPE ad_smtpadr,
    lv_status         TYPE val_text,
    lv_flag_exit      TYPE xchar,
    li_log_handle     TYPE bal_t_logh,
    li_log_numbers    TYPE bal_t_lgnm,
    lst_msg           TYPE bal_s_msg,
    lv_noofmsgs       TYPE i,
    lv_lncnt          TYPE i,
    li_msg            TYPE STANDARD TABLE OF bal_s_msg,
    lv_log_handle     TYPE balloghndl,
    lv_msg_handle     TYPE  balmsghndl,
    lst_text          TYPE so_text255,
    li_text           TYPE bcsy_text,
    lv_subject        TYPE sood-objdes,
    lv_subject2       TYPE sood-objdes,
    lv_binary_content TYPE solix_tab,
    lv_excel          TYPE string,
    lv_count          TYPE string,
    lv_hgt_cnt        TYPE string,
    lv_size           TYPE so_obj_len,
    lv_sent_to_all    TYPE os_boolean,
    lv_document       TYPE REF TO cl_document_bcs,
    bcs_exception     TYPE REF TO cx_bcs,
    lv_sender         TYPE REF TO cl_cam_address_bcs,
    lv_send_request   TYPE REF TO cl_bcs,
    lv_recipient      TYPE REF TO if_recipient_bcs,
    lt_dd07v_tab      TYPE STANDARD TABLE OF dd07v,
    li_final_tmp      TYPE zttqtc_bporder.

  CONSTANTS:lc_ep1      TYPE sy-sysid VALUE 'EP1'.

  FREE:lv_sub,         lv_log_handle,     lv_size,              li_msg,
       lv_mailto,      lv_msg_handle,     lv_sent_to_all,       lv_count,
       lv_status,      lst_text,          lv_document,          lv_hgt_cnt,
       lv_flag_exit,   li_text,           bcs_exception,        lt_dd07v_tab,
       li_log_handle,  lv_subject,        lv_sender,            li_final_tmp,
       li_log_numbers, lv_binary_content, lv_send_request,
       lst_msg,        lv_excel,          lv_recipient.

  IF i_final IS NOT INITIAL.
    APPEND LINES OF i_final TO li_final_tmp.
    SORT li_final_tmp[] BY zoid identifier.
    DELETE ADJACENT DUPLICATES FROM li_final_tmp[] COMPARING  zoid identifier.

*---Email ID
    CONCATENATE p_userid  '@WILEY.COM' INTO lv_mailto.

    IF lv_mailto IS NOT INITIAL.
*----email subject
      IF sy-sysid NE lc_ep1..
        CONCATENATE sy-sysid 'BP and Order file status log for upload identifier '(184) p_v_oid INTO lv_sub SEPARATED BY space.
      ELSE.
        CONCATENATE 'BP and Order file status log for upload identifier '(184) p_v_oid INTO lv_sub SEPARATED BY space.
      ENDIF.
      CLEAR:lst_text.
      lst_text   = 'Dear User,'(078).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

      lst_text = '<br><br>'(116).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

      lst_text = '<body>'(141).
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
                   'The BP/Order upload file is not processed due to errors.'(143)
                    '</p>'
                   INTO lst_text SEPARATED BY space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
                         'Please find the attached excel file for error logs.'(182)
                          '</p>'
                         INTO lst_text SEPARATED BY space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      lst_text = space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
               'File name :'(145) p_l_file '</p>'(144)
               INTO lst_text SEPARATED BY space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      lst_text = space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      lst_text = '<br><br>'(116).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

*---Body of the EMAIL
      CONCATENATE '<font color = "BLACK" style="font-family:arial;font-size:95%;">'(146) 'Thanks,'(080) '<br/>'(147)
      INTO lst_text.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      CONCATENATE  '<font color = "BLACK" style="font-family:arial;font-size:95%;">'(146) 'WILEY ERP Team.'(081) '<br/>'(147)
      INTO lst_text.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      lst_text = '</body>'(148).
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      lv_subject2 = lv_sub.
      CLEAR:lv_sub.                "NPOLINA E225 ED2K918020
      CONCATENATE 'BP and Order log for identifier:' p_v_oid INTO lv_sub SEPARATED BY space. "NPOLINA E225 ED2K918020

      IF li_final_tmp[] IS NOT INITIAL.
*---Staging table

        IF i_staging IS NOT INITIAL.
          SORT i_staging BY zuid_upld zoid.
          LOOP AT li_final_tmp[] ASSIGNING FIELD-SYMBOL(<fst_final>).
            READ TABLE i_staging INTO DATA(lst_e225_staging) WITH KEY zuid_upld = <fst_final>-zoid
                                                                            zoid      = <fst_final>-identifier.
            IF sy-subrc = 0.
              <fst_final>-vbeln = lst_e225_staging-vbeln.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*---total lines
      CLEAR lv_count.
      DESCRIBE TABLE li_final_tmp[] LINES lv_count.
      lv_count = lv_count + 20.
      CONDENSE lv_count.

      CONCATENATE
  ' <?xml version="1.0"?>'
  ' <?mso-application progid="Excel.Sheet"?>'
  ' <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'
  ' xmlns:o="urn:schemas-microsoft-com:office:office"'
  ' xmlns:x="urn:schemas-microsoft-com:office:excel"'
  ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'
  ' xmlns:html="http://www.w3.org/TR/REC-html40">'
  ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'
  ' </DocumentProperties>'
  ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'
  ' <AllowPNG/>'
  ' </OfficeDocumentSettings>'
  ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'
  ' <WindowHeight>8070</WindowHeight>'
  ' <WindowWidth>19365</WindowWidth>'
  ' <WindowTopX>32767</WindowTopX>'
  ' <WindowTopY>32767</WindowTopY>'
  ' <ProtectStructure>False</ProtectStructure>'
  ' <ProtectWindows>False</ProtectWindows>'
  ' </ExcelWorkbook>'
  ' <Styles>'
  ' <Style ss:ID="Default" ss:Name="Normal">'
  ' <Alignment ss:Vertical="Bottom"/>'
  ' <Borders/>'
  ' <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'
  ' <Interior/>'
  ' <NumberFormat/>'
  ' <Protection/>'
  ' </Style>'
  ' <Style ss:ID="s63">'
  ' <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>'
  ' </Style>'
  ' <Style ss:ID="s64">'
  ' <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'
  ' ss:Bold="1"/>'
  ' <Interior ss:Color="#DBDBDB" ss:Pattern="Solid"/>'
  ' </Style>'
  ' </Styles>'
  ' <Worksheet ss:Name="Sheet1">'
  ' <Table ss:ExpandedColumnCount="14" ss:ExpandedRowCount="'lv_count'" x:FullColumns="1"'
  ' x:FullRows="1" ss:DefaultRowHeight="15">'
  ' <Column ss:Width="79.5"/>'
  ' <Column ss:Width="55.5"/>'
  ' <Column ss:Width="55.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Column ss:AutoFitWidth="0" ss:Width="320.25"/>'
  ' <Row>'
  ' <Cell ss:StyleID="s64"><Data ss:Type="String">Order Identifier</Data></Cell>'
  ' <Cell ss:StyleID="s64"><Data ss:Type="String">Status</Data></Cell>'
  ' <Cell ss:StyleID="s64"><Data ss:Type="String">Order</Data></Cell>'
  ' <Cell ss:StyleID="s64"><Data ss:Type="String">Log</Data></Cell>'
  ' </Row>'
        INTO lv_excel.
      LOOP AT li_final_tmp[] INTO DATA(lst_final).
        CLEAR lv_status.
        IF lst_final-vbeln IS NOT INITIAL.
          lv_status = 'Completed'(149).
        ELSE.
          lv_status = 'Error'(150).
        ENDIF.
*---Get the log data
        FREE:li_log_handle,lv_log_handle,lv_flag_exit,lv_msg_handle.
        lv_log_handle = lst_final-log_handle.   "LOG GUI ID
        APPEND lv_log_handle TO li_log_handle.
        IF li_log_handle IS NOT INITIAL.
          CALL FUNCTION 'BAL_DB_LOAD'
            EXPORTING
              i_t_log_handle     = li_log_handle
            EXCEPTIONS
              no_logs_specified  = 1
              log_not_found      = 2
              log_already_loaded = 3
              OTHERS             = 4.
          IF sy-subrc = 1.
            CONCATENATE 'No Log Specified'(122) lst_final-zlogno
            INTO DATA(lv_msg) SEPARATED BY space.
            MESSAGE lv_msg TYPE c_e.
          ELSEIF sy-subrc = 2.
            CLEAR lv_msg.
            CONCATENATE 'Log not found'(123) lst_final-zlogno
           INTO lv_msg SEPARATED BY space.
            MESSAGE lv_msg TYPE c_e.
          ELSEIF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ELSEIF sy-subrc = 0.
            CLEAR:lv_noofmsgs.
            WHILE lv_flag_exit IS INITIAL.
              CLEAR:lst_msg.
              lv_msg_handle-log_handle = lv_log_handle.
              lv_msg_handle-msgnumber  = lv_msg_handle-msgnumber + 1 .
              CALL FUNCTION 'BAL_LOG_MSG_READ'
                EXPORTING
                  i_s_msg_handle = lv_msg_handle
                IMPORTING
                  e_s_msg        = lst_msg
                EXCEPTIONS
                  log_not_found  = 1
                  msg_not_found  = 2
                  OTHERS         = 3.
              IF sy-subrc <> 0.
* Implement suitable error handling here
                lv_flag_exit = abap_true.
              ELSEIF sy-subrc = 0.
                IF lst_msg IS NOT INITIAL .
                  lv_lncnt = v_msgcnt.
                  lv_noofmsgs = lv_noofmsgs + 1.
                  IF lv_noofmsgs <= lv_lncnt.

                    CONCATENATE lv_message
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message).
                    APPEND lst_msg TO li_msg.
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 2 ).
                    CONCATENATE lv_message1
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message1).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 3 ).
                    CONCATENATE lv_message2
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message2).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 4 ).
                    CONCATENATE lv_message3
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message3).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 5 ).
                    CONCATENATE lv_message4
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message4).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 6 ).
                    CONCATENATE lv_message5
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message5).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 7 ).
                    CONCATENATE lv_message6
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message6).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 8 ).
                    CONCATENATE lv_message7
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message7).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 9 ).
                    CONCATENATE lv_message8
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message8).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 10 ).
                    CONCATENATE lv_message9
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message9).
                  ELSEIF lv_noofmsgs > lv_lncnt  AND ( lv_noofmsgs <= lv_lncnt * 11 ).
                    CONCATENATE lv_message10
                                lst_msg-msgv1
                                lst_msg-msgv2
                                lst_msg-msgv3
                                lst_msg-msgv4
                                '&#10;'
                                INTO DATA(lv_message10).
                  ENDIF.
                ENDIF.
                CLEAR lst_msg.
              ENDIF.
            ENDWHILE.
          ENDIF.
        ENDIF.
        sy-subrc = 0.
        FREE:lv_msg_handle,lv_msg_handle,lv_hgt_cnt,lv_lncnt.
        DESCRIBE TABLE li_msg LINES lv_hgt_cnt.
        lv_hgt_cnt = lv_hgt_cnt  * 30.
        CONDENSE: lv_hgt_cnt,
                  lv_status,
                  lst_final-identifier,
                  lst_final-vbeln,
                  lv_message.
        CONCATENATE  lv_excel
          ' <Row ss:Height="'lv_hgt_cnt'">'
          ' <Cell><Data ss:Type="String">'lst_final-identifier'</Data></Cell>'
          ' <Cell><Data ss:Type="String">'lv_status'</Data></Cell>'
          ' <Cell><Data ss:Type="String">'lst_final-vbeln'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message1'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message2'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message3'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message4'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message5'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message6'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message7'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message8'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message9'</Data></Cell>'
          ' <Cell ss:StyleID="s63"><Data ss:Type="String">'lv_message10'</Data></Cell>'

          ' </Row>'
            INTO lv_excel.
        FREE:lv_message,li_msg,lst_msg,lv_noofmsgs,lv_message1,lv_message2,lv_message3,
        lv_message4,lv_message5,lv_message6,lv_message7,lv_message8,lv_message9,lv_message10.
      ENDLOOP.

      CONCATENATE lv_excel
    ' </Table>'
    ' <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'
    ' <PageSetup>'
    ' <Header x:Margin="0.3"/>'
    ' <Footer x:Margin="0.3"/>'
    ' <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>'
    ' </PageSetup>'
    ' <Selected/>'
    ' <TopRowVisible>1</TopRowVisible>'
    ' <Panes>'
    ' <Pane>'
    ' <Number>3</Number>'
    ' <ActiveRow>'lv_count'</ActiveRow>'
    ' <RangeSelection>R1:R1048576</RangeSelection>'
    ' </Pane>'
    ' </Panes>'
    ' <ProtectObjects>False</ProtectObjects>'
    ' <ProtectScenarios>False</ProtectScenarios>'
    ' </WorksheetOptions>'
    ' </Worksheet>'
    ' </Workbook>'
      INTO lv_excel.

      TRY.

          cl_bcs_convert=>string_to_solix(

          EXPORTING
            iv_string = lv_excel
            iv_codepage = '4103' "suitable for MS Excel, leave empty
            iv_add_bom  = abap_true  "for other doc types
          IMPORTING
            et_solix = lv_binary_content
            ev_size  = lv_size ).
        CATCH cx_bcs.
          MESSAGE e445(so).
      ENDTRY.

      TRY.
* -------- create persistent send request ------------------------
          lv_send_request = cl_bcs=>create_persistent( ).
          CALL METHOD cl_cam_address_bcs=>create_internet_address
            EXPORTING
              i_address_string = 'no-reply@wiley.com'
              i_address_name   = 'SAP ERP Team'
            RECEIVING
              result           = lv_sender.
          lv_subject = lv_sub.
          CALL METHOD lv_send_request->set_sender
            EXPORTING
              i_sender = lv_sender.
* -------- create and set document with attachment ---------------
          lv_document = cl_document_bcs=>create_document(
                      i_type = lv_htm
                      i_text = li_text
                      i_subject = lv_subject2 ).            "#EC NOTEXT

* add the spread sheet as attachment to document object
          lv_document->add_attachment(
          i_attachment_type = lv_xls                        "#EC NOTEXT
          i_attachment_subject = lv_subject                 "#EC NOTEXT
*          i_attachment_subject = lv_subject                 "#EC NOTEXT
          i_attachment_size = lv_size
          i_att_content_hex = lv_binary_content ).

          TRY.
              CALL METHOD lv_send_request->set_message_subject
                EXPORTING
                  ip_subject = lv_sub.
            CATCH cx_send_req_bcs.
          ENDTRY.
* add document object to send request

          lv_send_request->set_document( lv_document ).

* --------- add recipient (e-mail address) -----------------------

* create recipient object

          lv_recipient = cl_cam_address_bcs=>create_internet_address( lv_mailto ).

* add recipient object to send request

          lv_send_request->add_recipient( lv_recipient ).

* ---------- send document ---------------------------------------

          lv_sent_to_all = lv_send_request->send( i_with_error_screen = abap_true ).

          COMMIT WORK.

          IF lv_sent_to_all IS INITIAL.

            MESSAGE i500(sbcoms) WITH lv_mailto.

          ELSE.

            MESSAGE s022(so).

          ENDIF.

* ------------ exception handling ----------------------------------

* replace this rudimentary exception handling with your own one !!!

        CATCH cx_bcs INTO bcs_exception.

          MESSAGE i865(so) WITH bcs_exception->error_type.

      ENDTRY.
    ENDIF.
    FREE:li_final_tmp[].
  ENDIF.
ENDFORM.
*---BOC NPALLA Staging Changes 12/17/2021  E225 ED2K924398 OTCM-47267
*&---------------------------------------------------------------------*
*&      Form  F_GET_INTF_STAGE_ID
*&---------------------------------------------------------------------*
*  Based on Selected Option on Selection Screen update Staging table
*----------------------------------------------------------------------*
FORM f_get_intf_stage_id  CHANGING fp_225_staging  TYPE ze225_staging.

* Based on Selected Option on Selection Screen update Stageing ID
  IF rb_tbt IS NOT INITIAL.
    fp_225_staging-zintf_stage_id = '1A'.  "E225 - TBT
*
  ELSEIF rb_ftp IS NOT INITIAL.
    fp_225_staging-zintf_stage_id = '1B'.  "E225 - FTP
*
  ELSEIF rb_soc IS NOT INITIAL.
    fp_225_staging-zintf_stage_id = '1C'.  "E225 - Society
  ENDIF.

ENDFORM.
*---EOC NPALLA Staging Changes 12/17/2021  E225 ED2K924398 OTCM-47267
