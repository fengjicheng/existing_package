class ZCL_ZQTC_FUTURE_RENEWAL_E256 definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_data,
        vbeln    TYPE vbeln,
        vkorg    TYPE vkorg,
        vtweg    TYPE vtweg,
        spart    TYPE spart,
        vkbur    TYPE vkbur,
        augru    TYPE augru,
        waerk    TYPE waerk,
        kunnr    TYPE kunnr,
        kvgr1    TYPE kvgr1,
        kvgr2    TYPE kvgr2,
        kvgr3    TYPE kvgr3,
        kvgr4    TYPE kvgr4,
        kvgr5    TYPE kvgr5,
        posnr    TYPE posnr,
        matnr    TYPE matnr,
        zmeng    TYPE dzmeng,
        vgbel    TYPE vgbel,
        vgpos    TYPE vgpos,
        zzsubtyp TYPE zsubtyp,
        zzvyp    TYPE zvyp,
        mvgr1    TYPE mvgr1,
        mvgr2    TYPE mvgr2,
        mvgr3    TYPE mvgr3,
        mvgr4    TYPE mvgr4,
        mvgr5    TYPE mvgr5,
      END OF ty_data .
  types:
    BEGIN OF ty_vbkd,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
        zlsch TYPE schzw_bseg,
        zterm TYPE dzterm,
        ihrez TYPE ihrez,
        bsark TYPE bsark,
        kdkg1 TYPE kdkg1,
        kdkg2 TYPE kdkg2,
        kdkg3 TYPE kdkg3,
        kdkg4 TYPE kdkg4,
        kdkg5 TYPE kdkg5,
      END OF ty_vbkd .
  types:
    BEGIN OF ty_veda,
        vbeln   TYPE vbeln,
        vposn   TYPE posnr_va,
        vlaufz  TYPE vlauf_veda,
        vlauez  TYPE vlaue_veda,
        vlaufk  TYPE vlauk_veda,
        vbegdat TYPE vbdat_veda,
        venddat TYPE vndat_veda,
        vaktsch TYPE vasch_veda,
        vasdr   TYPE vasdr,
        vendreg TYPE rgvte,
      END OF ty_veda .
  types:
    BEGIN OF ty_kna1,
        kunnr TYPE kunnr,
        name1 TYPE name1_gp,
        name2 TYPE name2_gp,
        adrnr TYPE adrnr,
      END OF ty_kna1 .
  types:
    BEGIN OF ty_adrc,
        addrnumber TYPE adrc-addrnumber,
        deflt_comm TYPE adrc-deflt_comm,
        tel_number TYPE adrc-tel_number,
        time_zone  TYPE adrc-time_zone,
        flgdefault TYPE adr6-flgdefault,
        home_flag  TYPE adr6-home_flag,
        smtp_addr  TYPE adr6-smtp_addr,
        smtp_srch  TYPE adr6-smtp_srch,
      END OF ty_adrc .
  types:
    BEGIN OF ty_renwl,
        vbeln      TYPE vbeln,
        posnr      TYPE posnr,
        activity   TYPE zactivity_sub,
        act_status TYPE zact_status,
        ren_status TYPE zren_status,
      END OF ty_renwl .
  types:
    tt_data     TYPE STANDARD TABLE OF ty_data .
  types:
    tt_lineitem TYPE STANDARD TABLE OF zqtc_s_future_renewal .
  types:
    tt_vbkd     TYPE STANDARD TABLE OF ty_vbkd .
  types:
    tt_veda     TYPE STANDARD TABLE OF ty_veda .
  types:
    tt_kna1     TYPE STANDARD TABLE OF ty_kna1 .
  types:
    tt_adrc       TYPE STANDARD TABLE OF ty_adrc .
  types:
    tt_veda_dates TYPE STANDARD TABLE OF bapictr .
  types:
    tt_veda_datx  TYPE STANDARD TABLE OF bapictrx .
  types:
    tt_item_data TYPE STANDARD TABLE OF bapisditm .
  types:
    tt_renwl     TYPE STANDARD TABLE OF ty_renwl .

  class-methods GET_DATA
    importing
      value(IM_LINEITEM) type TT_LINEITEM optional
      value(IM_VBELN) type FIP_T_VBELN_RANGE optional
      value(IM_POSNR) type CKMCSO_POSNR_T optional
    exporting
      value(EX_DATA) type TT_DATA
      value(EX_VBKD) type TT_VBKD
      value(EX_VEDA) type TT_VEDA
      value(EX_KNA1) type TT_KNA1
      value(EX_ADRC) type TT_ADRC
      value(EX_RENEWAL) type TT_RENWL .
  class-methods VEDA_DATA
    importing
      value(IM_VEDA) type TT_VEDA optional
      value(IM_POSNR) type POSNR optional
      value(IM_VBELN) type VBELN optional
      value(IM_ZZSUBTYP) type ZSUBTYP optional
      value(IM_ZZVYP) type ZVYP optional
      value(IM_VBKD) type TT_VBKD optional
    exporting
      value(EX_VEDA_DATE) type BAPICTR
      value(EX_VEDA_DATEX) type BAPICTRX .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZQTC_FUTURE_RENEWAL_E256 IMPLEMENTATION.


  METHOD get_data.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K923857
* REFERENCE NO: ERPM25282/OTCM-47292
* DEVELOPER:Prabhu(PTUFARAM)
* DATE:  6/16/2021
* DESCRIPTION:Renewals App additional UI changes
*----------------------------------------------------------------------*
    DATA:lc_cs TYPE zactivity_sub VALUE 'CS'.
    SELECT vbeln
           posnr
           activity
           act_status
           ren_status
      FROM zqtc_renwl_plan
      INTO TABLE ex_renewal
      WHERE vbeln IN im_vbeln
        AND posnr IN im_posnr
        AND activity = lc_cs.

    SELECT vk~vbeln
           vk~vkorg
           vk~vtweg
           vk~spart
           vk~vkbur
           vk~augru
           vk~waerk
           vk~kunnr
           vk~kvgr1
           vk~kvgr2
           vk~kvgr3
           vk~kvgr4
           vk~kvgr5
           vb~posnr
           vb~matnr
           vb~zmeng
           vb~vgbel
           vb~vgpos
           vb~zzsubtyp
           vb~zzvyp
           vb~mvgr1
           vb~mvgr2
           vb~mvgr3
           vb~mvgr4
           vb~mvgr5
       FROM vbak AS vk
       INNER JOIN vbap AS vb  ON vb~vbeln = vk~vbeln
       INTO TABLE ex_data
       WHERE vb~vbeln IN im_vbeln
         AND vb~posnr IN im_posnr
         AND vb~abgru = space.

    IF ex_data IS NOT INITIAL.
      SELECT vbeln
             posnr
             zlsch
             zterm
             ihrez
             bsark
             kdkg1
             kdkg2
             kdkg3
             kdkg4
             kdkg5
        FROM vbkd
        INTO TABLE ex_vbkd
        FOR ALL ENTRIES IN ex_data
        WHERE vbeln = ex_data-vbeln.
      SELECT vbeln
             vposn
             vlaufz
             vlauez
             vlaufk
             vbegdat
             venddat
             vaktsch
             vasdr
             vendreg
        FROM veda
        INTO TABLE ex_veda
        FOR ALL ENTRIES IN ex_data
        WHERE vbeln = ex_data-vbeln.
    ENDIF.

    IF im_lineitem IS NOT INITIAL.
      SELECT kunnr name1 name2 adrnr
        FROM kna1
        INTO TABLE ex_kna1
        FOR ALL ENTRIES IN im_lineitem
        WHERE kunnr = im_lineitem-kunwe OR  kunnr = im_lineitem-kunag.
      IF ex_kna1 IS NOT INITIAL.
        SELECT adrc~addrnumber
               adrc~deflt_comm
               adrc~tel_number
               adrc~time_zone
               adr6~flgdefault
               adr6~home_flag
               adr6~smtp_addr
               adr6~smtp_srch
          INTO TABLE ex_adrc
          FROM adrc
          INNER JOIN adr6 ON adrc~addrnumber = adr6~addrnumber
          FOR ALL ENTRIES IN ex_kna1
          WHERE adrc~addrnumber = ex_kna1-adrnr.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD veda_data.
    DATA:lv_days        TYPE t5a4a-dlydy,                                 " Days
         lv_year        TYPE t5a4a-dlyyr,
         lst_veda_date  TYPE bapictr,
         lv_venddat     TYPE vndat_veda,
         lst_veda_kopf  TYPE veda,
         lst_veda_pos   TYPE veda,
         lst_veda_datex TYPE bapictrx,
         lst_kdkg2      TYPE rjksd_mstav_range,
         lr_kdkg2       TYPE RANGE OF kdkg2,
         li_constants   TYPE zcat_constants.

    CONSTANTS: lc_days    TYPE t5a4a-dlydy VALUE '00',  " Days
               lc_month   TYPE t5a4a-dlymo VALUE '00', " Month
               lc_year    TYPE t5a4a-dlyyr VALUE '00', " Year
               lc_devid   TYPE zdevid      VALUE 'E256',
               lc_kdkg2   TYPE rvari_vnam  VALUE 'KDKG2',
               lc_vasdr   TYPE rvari_vnam  VALUE 'VASDR',
               lc_period  TYPE vlauf_veda  VALUE '001',      "Validity period of contract
               lc_categry TYPE vlauk_veda  VALUE '02'.       "Validity period category of contract

* fetch constant values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid      "Development ID
      IMPORTING
        ex_constants = li_constants. "Constant Values
    SORT li_constants BY param1 param2 low.
    FREE:lr_kdkg2,lst_kdkg2.
    LOOP AT li_constants INTO DATA(lst_constants) WHERE param1 = lc_kdkg2.
      lst_kdkg2-sign   = lst_constants-sign.
      lst_kdkg2-option = lst_constants-opti.
      lst_kdkg2-low    = lst_constants-low.
      lst_kdkg2-high   = lst_constants-high.
      APPEND lst_kdkg2 TO lr_kdkg2.
      CLEAR: lst_kdkg2,
             lst_constants.
    ENDLOOP.


    READ TABLE im_veda INTO DATA(lst_veda)  WITH KEY vbeln = im_vbeln
                                                     vposn = im_posnr.
    IF sy-subrc = 0.
      lst_veda_kopf-vposn   = lst_veda_date-itm_number = im_posnr.
      lst_veda_kopf-vbegdat =  lst_veda_date-con_st_dat = lst_veda-venddat + 1.

      lst_veda_kopf-vlaufz  =  lst_veda_date-val_per    = lst_veda-vlaufz. "Validity period of contract
      lst_veda_kopf-vlauez  =  lst_veda_date-val_per_un = lst_veda-vlauez. "Unit of validity period of contract
      lst_veda_kopf-vlaufk  =  lst_veda_date-val_per_ca = lst_veda-vlaufk. "Validity period category of contract
      lst_veda_kopf-vendreg =  lst_veda_date-con_en_rul = lst_veda-vendreg.
      IF lst_veda_date-con_en_rul IS INITIAL.
        READ TABLE li_constants INTO lst_constants WITH KEY param1 = lc_vasdr.
        IF sy-subrc = 0.
          lst_veda_date-con_en_rul  = lst_constants-low.
        ENDIF.
      ENDIF.
      lst_veda_kopf-vendreg = lst_veda_date-con_en_rul.
      READ TABLE im_vbkd INTO DATA(ls_vbkd) WITH KEY vbeln = im_vbeln
                                                     posnr = im_posnr.
      IF sy-subrc = 0.
        IF ls_vbkd-kdkg2 IN lr_kdkg2.
          lst_veda_kopf-vlaufz  = lst_veda_date-val_per     = lc_period ."'001'.
          lst_veda_kopf-vlaufk  = lst_veda_date-val_per_ca  = lc_categry."'02'.
        ENDIF.
      ENDIF.

      MOVE-CORRESPONDING lst_veda_kopf TO lst_veda_pos.
      CLEAR:lv_venddat.
      CALL FUNCTION 'SD_VEDA_GET_DATE'
        EXPORTING
          i_regel                    = lst_veda_date-con_en_rul     "Date rule
          i_veda_kopf                = lst_veda_kopf          "Acceptance date
          i_veda_pos                 = lst_veda_pos          "Contract Start Date
        IMPORTING
          e_datum                    = lv_venddat             "Target date
        EXCEPTIONS
          basedate_and_cal_not_found = 1
          basedate_is_initial        = 2
          basedate_not_found         = 3
          cal_error                  = 4
          rule_not_found             = 5
          timeframe_not_found        = 6
          wrong_month_rule           = 7
          OTHERS                     = 8.
      IF sy-subrc EQ 0.
        lst_veda_date-con_en_dat   = lv_venddat.                    "Contract End Date
      ENDIF.

      IF im_posnr IS INITIAL.
        lst_veda_date-con_en_act  = lst_veda-vaktsch.
        lst_veda_date-act_datrul  = lst_veda-vasdr.
        IF lst_veda_date-act_datrul IS INITIAL.
          READ TABLE li_constants INTO lst_constants WITH KEY param1 = lc_vasdr.
          IF sy-subrc = 0.
            lst_veda_date-act_datrul  = lst_constants-low.
          ENDIF.
        ENDIF.
        lst_veda_datex-con_en_act = abap_true.
        lst_veda_datex-act_datrul = abap_true.
        lst_veda_date-action_dat  = sy-datum.
        CLEAR lv_year.
        MOVE 1 TO lv_year.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lst_veda_date-action_dat
            days      = lc_days
            months    = lc_month
            years     = lv_year
          IMPORTING
            calc_date = lst_veda_date-action_dat.
        lst_veda_datex-action_dat = abap_true.
      ENDIF.

      MOVE lst_veda_date TO ex_veda_date.
      lst_veda_datex-itm_number = im_posnr.
      lst_veda_datex-con_st_dat = abap_true.
      lst_veda_datex-con_en_dat = abap_true.
      lst_veda_datex-val_per    = abap_true.
      lst_veda_datex-val_per_un = abap_true.
      lst_veda_datex-val_per_ca = abap_true.
      lst_veda_datex-con_en_rul = abap_true.
      MOVE lst_veda_datex TO ex_veda_datex.
    ELSE.
      READ TABLE im_veda INTO lst_veda  WITH KEY vbeln = im_vbeln
                                                 vposn = '000000'.
      IF sy-subrc = 0.
        lst_veda_date-itm_number = im_posnr.
        lst_veda_date-con_st_dat = lst_veda-venddat.
        CLEAR lv_days.
        MOVE 1 TO lv_days.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lst_veda_date-con_st_dat
            days      = lv_days
            months    = lc_month
            years     = lc_year
          IMPORTING
            calc_date = lst_veda_date-con_st_dat.

        CLEAR lv_year.
        MOVE 1 TO lv_year.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lst_veda_date-con_st_dat
            days      = lc_days
            months    = lc_month
            years     = lv_year
          IMPORTING
            calc_date = lst_veda_date-con_en_dat.
        lst_veda_date-con_en_dat = lst_veda_date-con_en_dat - 1.
        IF im_posnr IS INITIAL.
          lst_veda_date-con_en_act  = lst_veda-vaktsch.
          lst_veda_date-act_datrul  = lst_veda-vasdr.
          IF lst_veda_date-act_datrul IS INITIAL.
            CLEAR lst_constants.
            READ TABLE li_constants INTO lst_constants WITH KEY param1 = lc_vasdr.
            IF sy-subrc = 0.
              lst_veda_date-act_datrul  = lst_constants-low.
            ENDIF.
          ENDIF.
          lst_veda_datex-con_en_act = abap_true.
          lst_veda_datex-act_datrul = abap_true.
          lst_veda_date-action_dat  = sy-datum.
          CLEAR lv_year.
          MOVE 1 TO lv_year.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lst_veda_date-action_dat
              days      = lc_days
              months    = lc_month
              years     = lv_year
            IMPORTING
              calc_date = lst_veda_date-action_dat.
        ENDIF.
        MOVE lst_veda_date TO ex_veda_date.
        lst_veda_datex-itm_number = im_posnr.
        lst_veda_datex-con_st_dat = abap_true.
        lst_veda_datex-con_en_dat = abap_true.
        MOVE lst_veda_datex TO ex_veda_datex.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
