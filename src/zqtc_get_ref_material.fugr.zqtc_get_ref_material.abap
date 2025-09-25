FUNCTION zqtc_get_ref_material.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_T_MATERIAL) TYPE  DMF_T_MATNR
*"     VALUE(IM_V_IN_DATE) TYPE  SYST_DATUM
*"     VALUE(IM_V_NEXT_MONTHS) TYPE  DLYMO DEFAULT 02
*"     VALUE(IM_V_BACK_MONTHS) TYPE  DLYMO DEFAULT 03
*"  EXPORTING
*"     VALUE(EX_T_REF_MAT) TYPE  ZTQTC_REF_MATERIAL
*"  EXCEPTIONS
*"      INVALID_MATERIAL
*"      INVALID_MEDIA_PRODUCT
*"      NO_MEDIA_PRODUCT_FOUND
*"      NO_DATA_FOUND
*"----------------------------------------------------------------------
*-------------------------------------------------------------------
* PROGRAM NAME: ZQTC_GET_REF_MATERIAL
* PROGRAM DESCRIPTION: Get the Reference Material
* a. System will pick the exact media issue refering publication date
*    based on month and period,
* b. If system could not find then it  will check the nearest publication
*    within next  +60 days.
* c. If system could not find above two condition then it will check the
*    nearest publication within previous  -90 days
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------

  DATA : lv_last_date TYPE syst-datum,      " ABAP System Field: Current Date of Application Server
         lv_date      TYPE syst-datum,      " ABAP System Field: Current Date of Application Server
         lir_pub_date TYPE datum_range_tab, " Line of Range Table for Date
         lir_mon_dat  TYPE datum_range_tab. " Line of Range Table for Date

  DATA:   lv_back_lst_fst_dat TYPE begda,      " Start Date
          lv_adv_lst_fst_dat  TYPE begda,      " Start Date
          lv_advan_fg         TYPE flag,       " General Flag
          lv_adv_last_date    TYPE syst-datum, " ABAP System Field: Current Date of Application Server
          lir_adv_last_mon    TYPE datum_range_tab.


  DATA: lv_adv_count  TYPE dlymo, " Natural Number
        lv_back_count TYPE dlymo. " Natural Number

  lv_adv_count = 1.
  lv_back_count = 1.

* Get the media product for entered material from MARA table
* for one material there will be only one media procust
  SELECT  matnr,
          ismrefmdprod " Higher-Level Media Product
   FROM mara           " General Material Data
   INTO TABLE @DATA(li_mara)
   FOR ALL ENTRIES IN @im_t_material
   WHERE matnr = @im_t_material-matnr.
  IF sy-subrc <> 0 .
    RAISE no_media_product_found.
  ELSE. " ELSE -> IF sy-subrc <> 0
*    SORT li_mara BY ismrefmdprod.
*    DELETE ADJACENT DUPLICATES FROM li_mara COMPARING ismrefmdprod.
  ENDIF. " IF sy-subrc <> 0

* Get the date Range for pulication Date
************************************************************************
* Get the advance month last date
  lv_advan_fg = abap_true.

* get the advance first date of last Month
  PERFORM f_calculate_date USING  im_v_in_date
                                  im_v_next_months
                                  lv_advan_fg
                        CHANGING  lv_adv_lst_fst_dat.

* Get the last date of the Advance Month
  PERFORM f_get_first_last_date     USING lv_adv_lst_fst_dat
                                CHANGING  lir_adv_last_mon
                                          lv_adv_last_date.
  CLEAR: lv_advan_fg.

* Get the first date of back month
  PERFORM f_calculate_date USING  im_v_in_date
                                  im_v_back_months
                                  lv_advan_fg
                        CHANGING  lv_back_lst_fst_dat.

  APPEND INITIAL LINE TO lir_pub_date ASSIGNING FIELD-SYMBOL(<lst_date>).
  <lst_date>-sign   = c_i.
  <lst_date>-option = c_bt.
  <lst_date>-low  =  lv_back_lst_fst_dat.
  <lst_date>-high =  lv_adv_last_date.

  IF li_mara IS NOT INITIAL .
    SELECT matnr,
           ismrefmdprod,
           ismpubldate " Publication Date
      FROM mara        " General Material Data
      INTO TABLE @DATA(li_mara_issue)
      FOR ALL ENTRIES IN @li_mara
      WHERE ismrefmdprod  = @li_mara-ismrefmdprod
      AND   ismpubldate IN @lir_pub_date.
    IF sy-subrc EQ 0.
      SORT li_mara_issue BY ismrefmdprod ismpubldate.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      RAISE no_data_found.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mara IS NOT INITIAL

  LOOP AT li_mara INTO DATA(lst_mara).

    APPEND INITIAL LINE TO ex_t_ref_mat ASSIGNING FIELD-SYMBOL(<lst_ref_mat>).
    <lst_ref_mat>-ismrefmdprod = lst_mara-ismrefmdprod.
    <lst_ref_mat>-matnr        = lst_mara-matnr.

    READ TABLE li_mara_issue INTO DATA(lst_mara_issue) WITH KEY ismrefmdprod = lst_mara-ismrefmdprod
                                                                ismpubldate   = im_v_in_date
                                                                BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lst_ref_mat>-ismpubldate = lst_mara_issue-ismpubldate.
      <lst_ref_mat>-ref_material = lst_mara_issue-matnr.
    ELSE. " ELSE -> IF sy-subrc EQ 0

      READ TABLE li_mara_issue TRANSPORTING NO FIELDS WITH KEY ismrefmdprod = lst_mara-ismrefmdprod
                                                                  BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_mara_index) = sy-tabix.
        LOOP AT li_mara_issue INTO lst_mara_issue FROM lv_mara_index.

          IF lst_mara_issue-ismrefmdprod <> lst_mara-ismrefmdprod.
            EXIT.
          ENDIF. " IF lst_mara_issue-ismrefmdprod <> lst_mara-ismrefmdprod

* Check any material is present in Current Month + 30days ( Next Month)

          WHILE ( lv_adv_count LT im_v_next_months ).
            lv_advan_fg = abap_true.
            CLEAR lv_date.
            PERFORM f_calculate_date USING   im_v_in_date
                                             lv_adv_count
                                             lv_advan_fg
                                   CHANGING  lv_date.
            CLEAR: lir_mon_dat,
                    lv_last_date.
            PERFORM f_get_first_last_date   USING lv_date
                                         CHANGING lir_mon_dat
                                                  lv_last_date.

            IF lst_mara_issue-ismpubldate IN lir_mon_dat.
              <lst_ref_mat>-ismpubldate = lst_mara_issue-ismpubldate.
              <lst_ref_mat>-ref_material = lst_mara_issue-matnr.
              EXIT.
            ENDIF. " IF lst_mara_issue-ismpubldate IN lir_mon_dat
            lv_adv_count = lv_adv_count + 1.
          ENDWHILE.

* Exit from outer loop.
          IF <lst_ref_mat>-ref_material IS NOT INITIAL.
            EXIT.
          ENDIF. " IF <lst_ref_mat>-ref_material IS NOT INITIAL

* Check any material is present in Current month + 60 days .
          IF lv_adv_count EQ im_v_next_months.
            IF lst_mara_issue-ismpubldate IN lir_adv_last_mon.
              <lst_ref_mat>-ismpubldate = lst_mara_issue-ismpubldate.
              <lst_ref_mat>-ref_material = lst_mara_issue-matnr.
              EXIT.
            ENDIF. " IF lst_mara_issue-ismpubldate IN lir_adv_last_mon
          ENDIF. " IF lv_adv_count EQ im_v_next_months


* Check any material is present in back date.
          CLEAR lv_advan_fg.
          WHILE ( lv_back_count LE im_v_back_months ).
            CLEAR lv_date.
            PERFORM f_calculate_date USING   im_v_in_date
                                             lv_back_count
                                             lv_advan_fg
                                   CHANGING  lv_date.
            CLEAR: lir_mon_dat,
                  lv_last_date.

            PERFORM f_get_first_last_date   USING lv_date
                                          CHANGING lir_mon_dat
                                                   lv_last_date.

            IF lst_mara_issue-ismpubldate IN lir_mon_dat.
              <lst_ref_mat>-ismpubldate = lst_mara_issue-ismpubldate.
              <lst_ref_mat>-ref_material = lst_mara_issue-matnr.
              EXIT.
            ENDIF. " IF lst_mara_issue-ismpubldate IN lir_mon_dat
            lv_back_count = lv_back_count + 1.
          ENDWHILE.

* Exit from outer loop.
          IF <lst_ref_mat>-ref_material IS NOT INITIAL.
            EXIT.
          ENDIF. " IF <lst_ref_mat>-ref_material IS NOT INITIAL

        ENDLOOP. " LOOP AT li_mara_issue INTO lst_mara_issue FROM lv_mara_index
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

  ENDLOOP. " LOOP AT li_mara INTO DATA(lst_mara)
  SORT ex_t_ref_mat BY matnr.

ENDFUNCTION.
