*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_SET_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BP_SET_DEFAULT_VALUES
* PROGRAM DESCRIPTION: Set Default values for BP customer Sales role
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE:   03/13/2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S):  ED2K914681
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915283
* REFERENCE NO: E191
* DEVELOPER: Sunil kumar Kairamkonda(SKKAIRAMKO)
* DATE:  06/12/2019
* DESCRIPTION: Set defalts changes extended for other company code and sales area
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915282,ED2K919041
* REFERENCE NO:  E191
* DEVELOPER:MIMMADISET(Murali)
* DATE:  06/02/2020
* DESCRIPTION:ERPM-19040,24558 Default Price List Type based on the country
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K920952
* REFERENCE NO: OTCM-30166
* DEVELOPER:MIMMADISET
* DATE: 12/22/2020
* DESCRIPTION:OTCM 30166:set the ch_knvi_tab default values for mthree
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:OTCM 29502: As a BP Admin, I should be prompted for any
*critical data missing/wrong with an error if the system does not
*auto derive data points when an account is managed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*
** Local Type(s)
TYPES: BEGIN OF ty_constants,
         param1 TYPE rvari_vnam,          " Param1
         param2 TYPE rvari_vnam,          " Param2
         srno   TYPE tvarv_numb,          " Serial Number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_constants,
       tt_knvp_dynpro TYPE TABLE OF cvis_cust_functions_dynpro.

* Local data declarations
DATA: lst_knb5 TYPE knb5,
      lv_aktyp TYPE bu_aktyp,
      lst_knvi TYPE knvi.

CONSTANTS:
  lc_sales_cust TYPE bu_partnerrolecat VALUE 'ISM000',
  lc_bukrs      TYPE char05            VALUE 'BUKRS',
  lc_zterm      TYPE char05            VALUE 'ZTERM',
  lc_kdgrp      TYPE char05            VALUE 'KDGRP',
  lc_zzfte      TYPE char05            VALUE 'ZZFTE',
  lc_sales_org  TYPE char10            VALUE 'VKORG',
  lc_hypen      TYPE char01            VALUE '-',
  lc_tab_kna1   TYPE char10            VALUE 'KNA1',
  lc_tab_knb1   TYPE char10            VALUE 'KNB1',
  lc_tab_knvv   TYPE char10            VALUE 'KNVV',
  lc_tab_knb5   TYPE char10            VALUE 'KNB5',
  lc_tab_knvi   TYPE char10            VALUE 'KNVI',
  lc_pltyp      TYPE char05            VALUE 'PLTYP',
  lc_kalks      TYPE char10            VALUE 'KNVV-KALKS',
  lc_set_knvi   TYPE char10            VALUE 'SET_KNVI',
  lc_price_list TYPE char15            VALUE 'PRICE_LIST',
****BOC  MIMMADISET OTCM-29502 ED2K920531
  lc_row        TYPE char03            VALUE 'ROW',
  lc_faksd      TYPE char05            VALUE 'FAKSD',
  lc_lifsd      TYPE char05            VALUE 'LIFSD',
  lc_butype     TYPE char07            VALUE 'BU_TYPE',
  lc_bulang     TYPE char07            VALUE 'BU_LANGU',
  lc_acttyp_01  TYPE bu_aktyp          VALUE '01',                         " Create
  lc_btype_1    TYPE bu_type           VALUE '1',
  lc_btype_2    TYPE bu_type           VALUE '2',
  lc_knvvzfte   TYPE char10            VALUE 'ZZFTE',
  lc_kvgr1      TYPE char05            VALUE 'KVGR1',
  lc_vkbur      TYPE char05            VALUE 'VKBUR',
  lc_europe(6)  TYPE c                 VALUE 'EUROPE'.
****EOC  MIMMADISET OTCM-29502 ED2K920531

* Local Field-Symbols
FIELD-SYMBOLS:
  <li_knvp_dynpro> TYPE tt_knvp_dynpro,   " Itab: Partner Functions
  <lst_knvv_gs>    TYPE knvv.             " Struc: Sales Area

DATA: lv_tab   TYPE char10,
      lv_field TYPE char10.

* Statics data
STATICS:
  li_constants TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0.

*--------------------------------------------------------------------*


* Fetch Application constant entries of E191
IF li_constants[] IS INITIAL.
  SELECT param1, param2, srno, sign, opti, low, high
         FROM zcaconstant                    " Wiley Application Constant Table
         INTO TABLE @li_constants
         WHERE devid = @lc_devid_e191 AND
               activate = @abap_true.
  IF sy-subrc EQ 0.

  ELSE.
*        do nothing
  ENDIF.
ENDIF.
****BOC  MIMMADISET OTCM-29502 ED2K920531
* FM call for BP Control (Create/Change/Display)
CALL FUNCTION 'BUS_PARAMETERS_ISSTA_GET'
  IMPORTING
    e_aktyp = lv_aktyp.
****EOC  MIMMADISET OTCM-29502 ED2K920531
*-- During Creation of Sales Customer
IF line_exists( im_bprole_tab[ rolecategory = lc_sales_cust ] ). "ISM000

*--Check the company code if exists in constants table , default values for that company code only
  IF line_exists( li_constants[ param1 = lc_bukrs
                                low    = im_bukrs ] ).

    LOOP AT li_constants INTO DATA(lst_constants).


      IF lst_constants-param1 CA lc_hypen.
        SPLIT lst_constants-param1 AT lc_hypen INTO lv_tab lv_field.
      ELSE.
        CLEAR lv_field.
      ENDIF.
*-- Set default values for KNB1
      CASE lv_tab.

        WHEN lc_tab_knb1.

*--BOC  Skkairamko - 6/12/2019
*--Check if condition in PARAM2 with company code already exits for the field

          IF lst_constants-param2 IS NOT INITIAL AND
             lst_constants-param2 EQ im_bukrs.

            TRY.
*          ASSIGN COMPONENT lst_constants-param1 OF STRUCTURE ch_knb1 TO FIELD-SYMBOL(<lst_knb1>).
                ASSIGN COMPONENT lv_field OF STRUCTURE ch_knb1 TO FIELD-SYMBOL(<lst_knb1>).
                IF <lst_knb1> IS ASSIGNED.
                  <lst_knb1> = lst_constants-low.
                ENDIF.
              CATCH cx_sy_assign_cast_error.
            ENDTRY.



          ELSEIF lst_constants-param2 IS NOT INITIAL AND
                 lst_constants-param2 <> im_bukrs.

*     do nothing don't update

          ELSE. "when PARAM2 IS blank
*--If zcaconsntant-param2 is blank check if already with same field with param2 condition records exists.
*--if exists dont do anyting, if no records exists then update the value

            IF line_exists( li_constants[ param1 = lst_constants-param1
                                          param2 = im_bukrs  ] ).
*        dont do anyting
            ELSE.  "update record value

              TRY.
                  ASSIGN COMPONENT lv_field OF STRUCTURE ch_knb1 TO <lst_knb1>.
                  IF <lst_knb1> IS ASSIGNED.
                    <lst_knb1> = lst_constants-low.
                  ENDIF.
                CATCH cx_sy_assign_cast_error.
              ENDTRY.


            ENDIF.

          ENDIF.



*-- Set Defaults for KNB5
        WHEN lc_tab_knb5.

          IF lst_constants-param2 IS NOT INITIAL AND
             lst_constants-param2 EQ im_bukrs.


            TRY.
*          ASSIGN COMPONENT lst_constants-param1 OF STRUCTURE lst_knb5 TO FIELD-SYMBOL(<lst_knb5>).
                ASSIGN COMPONENT lv_field OF STRUCTURE lst_knb5 TO FIELD-SYMBOL(<lst_knb5>).
                IF <lst_knb5> IS ASSIGNED.
                  <lst_knb5>     = lst_constants-low.
                ENDIF.
              CATCH cx_sy_assign_cast_error.
            ENDTRY.


          ELSEIF lst_constants-param2 IS NOT INITIAL AND
                 lst_constants-param2 <> im_bukrs.

*      do nothing

          ELSE.
*--If zcaconsntant-param2 is blank check if already with same field with param2 condition records exists.
*--if exists dont do anyting, if no records exists then update the value


            IF line_exists( li_constants[ param1 = lst_constants-param1
                                          param2 = im_bukrs  ] ).
*        dont do anyting

            ELSE.  "update

              TRY.
                  ASSIGN COMPONENT lv_field OF STRUCTURE lst_knb5 TO <lst_knb5>.

                  IF <lst_knb5> IS ASSIGNED.
                    <lst_knb5>  = lst_constants-low.
                  ENDIF.

                CATCH cx_sy_assign_cast_error.
              ENDTRY.

            ENDIF.


          ENDIF.
      ENDCASE.

      IF <lst_knb1> IS ASSIGNED.
        UNASSIGN <lst_knb1>.
      ENDIF.

      IF <lst_knb5> IS ASSIGNED.
        UNASSIGN <lst_knb5>.
      ENDIF.

      CLEAR: lv_tab,
             lv_field.


    ENDLOOP.

  ENDIF.


*-- Validate Sales area from constant value and update sales area information
  IF line_exists( li_constants[ param1 = lc_sales_org
                                low    = im_vkorg  ] ).


    DATA(lv_kdgrp_cond) = im_vkorg && ch_but000-type.  "Payment Terms condition
    DATA(lv_type)       = ch_but000-type. ""++SKKAIRAMKO 06/13/2019
    DATA(lv_zterm_cond) = im_vkorg && im_spart.        "Customer Grop condition
    DATA(lv_sales_area) = im_vkorg && im_vtweg && im_spart. "++SKKAIRAMKO 06/13/2019

    LOOP AT li_constants INTO lst_constants.


      IF lst_constants-param1 CA lc_hypen.
        SPLIT lst_constants-param1 AT lc_hypen INTO lv_tab lv_field.
      ELSE.
*      lv_field = lst_constants-param1.
        CLEAR lv_field.
      ENDIF.

      CASE lv_tab.

        WHEN lc_tab_knvv.


          TRY.
              ASSIGN COMPONENT lv_field OF STRUCTURE ch_knvv TO FIELD-SYMBOL(<lst_knvv>).
              IF <lst_knvv> IS ASSIGNED.

                CASE  lv_field.

*                  WHEN lc_pltyp.
*--BOC: SKKAIRAMKO - 06/14/2019

*                WHEN lc_zterm.   "Terms of Payment
*
*                IF lst_constants-param2 EQ lv_zterm_cond.
*                  <lst_knvv> = lst_constants-low.
*                ENDIF.
*                  WHEN lc_kdgrp.  "Customer Group
*
*                    IF lst_constants-param2 EQ lv_kdgrp_cond.
*                      <lst_knvv> = lst_constants-low.
*                    ENDIF.
*               WHEN lc_zzfte.  "Number of FTE's
*
*               IF lst_constants-param2 EQ im_vkorg.
*                 <lst_knvv> = lst_constants-low.
*               ENDIF.


                  WHEN lc_kdgrp." "Customer Group

                    IF lst_constants-param2 IS NOT INITIAL AND
                       lst_constants-param2 EQ lv_sales_area.

                      IF lv_type EQ lst_constants-high.
                        <lst_knvv> = lst_constants-low.
                      ENDIF.


                    ELSEIF lst_constants-param2 IS NOT INITIAL AND
                      lst_constants-param2 <> lv_sales_area.

*                     dont update

                    ELSE.


                      IF line_exists( li_constants[ param1 = lst_constants-param1
                                                    param2 = lv_sales_area  ] ).
*                        do nothing
                      ELSE.

                        IF lv_type EQ lst_constants-high.
                          <lst_knvv> = lst_constants-low.
                        ENDIF.


                      ENDIF.

                    ENDIF.

*--EOC: SKKAIRAMKO - 06/13/2019

                  WHEN OTHERS.  "Others Fields

                    IF lst_constants-param2 IS NOT INITIAL.  "++skkairamko

                      IF lst_constants-param2 EQ lv_sales_area.
                        <lst_knvv> = lst_constants-low.
                      ENDIF.
**BOC  MIMMADISET OTCM-29502 ED2K920531
** Below if condition is used to populate the LOW value based on person or org.
                      IF lst_constants-high IS NOT INITIAL
                        AND lst_constants-param2 EQ lv_sales_area
                        AND ( lst_constants-high EQ lc_btype_1 OR
                          lst_constants-high EQ lc_btype_2 ).
                        READ TABLE li_constants INTO DATA(ls_const)
                            WITH KEY param1 = lst_constants-param1
                            param2 = lv_sales_area
                            high = lv_type.
                        IF sy-subrc EQ 0.
                          <lst_knvv> = ls_const-low.
                        ELSE.
                          <lst_knvv> = space.
                        ENDIF.
                      ENDIF.
**EOC  MIMMADISET OTCM-29502 ED2K920531
                    ELSEIF lst_constants-param2 IS NOT INITIAL AND
                           lst_constants-param2 <> lv_sales_area.


                    ELSE.  "param2 value is blank

                      IF line_exists( li_constants[ param1 = lst_constants-param1
                                                    param2 = lv_sales_area  ] ).
*                        do nothing
                      ELSE.

                        <lst_knvv> = lst_constants-low.

                      ENDIF.


                    ENDIF.

*--EOC: SKKAIRAMKO - 06/13/2019
                ENDCASE.

              ENDIF.
            CATCH cx_sy_assign_cast_error.
          ENDTRY.




        WHEN lc_tab_knvi.

          IF ch_knvi_tab IS NOT INITIAL.

            LOOP AT ch_knvi_tab ASSIGNING FIELD-SYMBOL(<lst_knvi>).

              IF lst_constants-param2 IS NOT INITIAL   "++SKKAIRAMKO - 06/13/2019
             AND lst_constants-param2 EQ lv_sales_area.


                TRY.
                    ASSIGN COMPONENT lv_field OF STRUCTURE <lst_knvi> TO FIELD-SYMBOL(<lst_knvi_val>).
                    IF <lst_knvi_val> IS ASSIGNED.
                      <lst_knvi_val> = lst_constants-low.
                    ENDIF.
                  CATCH cx_sy_assign_cast_error.
                ENDTRY.


              ELSEIF lst_constants-param2 IS NOT INITIAL AND
                     lst_constants-param2 <> lv_sales_area.

*          do nothing

              ELSE.


                IF line_exists( li_constants[ param1 = lst_constants-param1
                                              param2 = lv_sales_area  ] ).
*                        do nothing
                ELSE.


                  TRY.
                      ASSIGN COMPONENT lv_field OF STRUCTURE <lst_knvi> TO <lst_knvi_val>.
                      IF <lst_knvi_val> IS ASSIGNED.
                        <lst_knvi_val> = lst_constants-low.
                      ENDIF.
                    CATCH cx_sy_assign_cast_error.
                  ENDTRY.

                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

      ENDCASE.

      IF <lst_knvv> IS ASSIGNED.
        UNASSIGN <lst_knvv>.
      ENDIF.

      IF <lst_knvi> IS ASSIGNED.
        UNASSIGN <lst_knvi>.
      ENDIF.

      IF <lst_knvi_val> IS ASSIGNED.
        UNASSIGN <lst_knvi_val>.
      ENDIF.

      CLEAR: lv_tab,
             lv_field.


    ENDLOOP.
*****BOC MIMMADISET ERPM-19040,24558
*Below logic for Default the Pricing procedure,Price list type based on the Country Key / LAND1 of the BP.
    LOOP AT li_constants INTO lst_constants
      WHERE ( param1 = lc_pltyp OR
            param1 = lc_kalks ) AND
             param2 = lv_sales_area AND high IS NOT INITIAL.
      CLEAR lv_field.
      IF lst_constants-param1 CA lc_hypen.
        SPLIT lst_constants-param1 AT lc_hypen INTO lv_tab lv_field.
      ELSE.
        lv_field = lst_constants-param1.
      ENDIF.
      TRY.
          ASSIGN COMPONENT lv_field OF STRUCTURE ch_knvv TO FIELD-SYMBOL(<lst_knvvpl>).
          IF <lst_knvvpl> IS ASSIGNED.
* For US and GB/UK ....
            READ TABLE li_constants ASSIGNING FIELD-SYMBOL(<lfs_plusa>)
            WITH KEY param1 = lst_constants-param1
            param2 = lv_sales_area
            high = im_busadrdata-country.
            IF sy-subrc EQ 0.
              <lst_knvvpl> = <lfs_plusa>-low.
            ELSE.
* For Rest of World
              READ TABLE li_constants ASSIGNING FIELD-SYMBOL(<lfs_plrow>)
              WITH KEY param1 = lst_constants-param1
                       param2 = lv_sales_area
                       high =  lc_row.
              IF sy-subrc EQ 0.
                <lst_knvvpl> = <lfs_plrow>-low.
              ENDIF.
            ENDIF.
          ENDIF.
        CATCH cx_sy_assign_cast_error.
      ENDTRY.
      IF <lst_knvvpl> IS ASSIGNED.
        UNASSIGN <lst_knvvpl>.
      ENDIF.
    ENDLOOP.
*******BOC MIMMADISET OTCM-30166
* Below logic is used to set the ch_knvi_tab default values
    IF ch_knvi_tab IS NOT INITIAL.
      IF line_exists( li_constants[ param1 = lc_set_knvi
                                    param2 = im_vkorg  ] ).
        ism_cvi_adapter=>knvi_set(
           EXPORTING
             it_knvi = ch_knvi_tab ).
      ENDIF.
    ENDIF.
*******EOC MIMMADISET OTCM-30166
*******BOC MIMMADISET OTCM-30166
    IF line_exists( li_constants[ param1 = lc_price_list
                                  param2 = lv_sales_area  ] ).
      SELECT SINGLE price_list
                   FROM zqtc_sal_ara_ref
                   INTO @DATA(lv_price_list)
                   WHERE country_sap = @im_busadrdata-country.
      IF sy-subrc = 0.
        lv_field = lc_pltyp.
        ASSIGN COMPONENT lv_field OF STRUCTURE ch_knvv TO FIELD-SYMBOL(<lst_knvvp2>).
        IF <lst_knvvp2> IS ASSIGNED.
          <lst_knvvp2> = lv_price_list.
        ENDIF.
        IF <lst_knvvp2> IS ASSIGNED.
          UNASSIGN <lst_knvvp2>.
        ENDIF.
      ENDIF.
    ENDIF.
*******EOC MIMMADISET OTCM-30166
*****EOC MIMMADISET ERPM-19040,24558
  ENDIF.
****BOC  MIMMADISET OTCM-29502 ED2K920531
ENDIF.
IF lv_aktyp = lc_acttyp_01.  " Create
  IF ch_but000 IS NOT INITIAL.
    IF ch_but000-type EQ lc_btype_1.
      ch_but000-bu_sort1 = ch_but000-name_last.
    ELSEIF ch_but000-type EQ lc_btype_2.
      ch_but000-bu_sort1 = ch_but000-name_org1.
    ENDIF.
    ch_but000-bu_sort2  = im_busadrdata-post_code1.
  ENDIF.
ENDIF.
****EOC  MIMMADISET OTCM-29502 ED2K920531
*-- Dunning procedure
IF lst_knb5 IS NOT INITIAL.
  lst_knb5-bukrs = im_bukrs.          "Company code
  lst_knb5-kunnr = ch_but000-partner. "Customer
  APPEND lst_knb5 TO ch_knb5_tab.
ENDIF.
