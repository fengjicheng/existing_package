*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_SALES_REP_ASSIGNMENT
* PROGRAM DESCRIPTION:Function Module for Subscription Order Status
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE:   16/11/2016
* OBJECT ID: E130
* TRANSPORT NUMBER(S):   ED2K903282
*----------------------------------------------------------------------*
FUNCTION zqtc_sales_rep_assignment.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_ADRNR) TYPE  ADRNR
*"     REFERENCE(IM_VBAK) TYPE  ZSTQTC_SALESREP
*"     REFERENCE(IM_MATNR) TYPE  MATNR OPTIONAL
*"     REFERENCE(IM_PRCTR) TYPE  PRCTR OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_SREP1) TYPE  ZZSREP1
*"     REFERENCE(EX_SREP2) TYPE  ZZSREP2
*"----------------------------------------------------------------------
  DATA: li_repdet      TYPE STANDARD TABLE OF ty_zqtc_repdet,
        li_repdet_temp TYPE STANDARD TABLE OF ty_zqtc_repdet,
        lst_adrc       TYPE ty_adrc,
        lst_repdet     TYPE ty_zqtc_repdet.


  CLEAR: lst_adrc, li_repdet[], li_repdet_temp[],ex_srep1, ex_srep2.

* Selecting address details
  SELECT post_code1     "City postal code
         post_code2     "PO Box Postal Code
         country        "Country Key
         region         "Region (State, Province, County)
    FROM adrc
    INTO lst_adrc
   WHERE addrnumber EQ im_adrnr.
  ENDSELECT.

  IF i_repdet_int IS INITIAL.
*   Selecting header data from ZQTC_REPDET table
    SELECT  vkorg          "Sales Organization
            vtweg          "Distribution Channel
            spart          "Division
            datab          "Valid-From Date
            datbi          "Valid To Date
            matnr          "Material Number
            prctr          "Profit Center
            kunnr          "Customer Number
            kvgr1          "Customer group 1
            pstlz_f        "Postal Code (From)
            pstlz_t        "Postal Code (To)
            regio          "Region (State, Province, County)
            land1          "Country Key
            srep1          "Sales Rep-1
            srep2          "Sales Rep-2
      FROM zqtc_repdet
      INTO TABLE i_repdet_int
      WHERE vkorg EQ im_vbak-vkorg     "xvbak-vkorg
       AND  vtweg EQ im_vbak-vtweg     "xvbak-vtweg
       AND  spart EQ im_vbak-spart     "xvbak-spart
       AND  datab LE im_vbak-erdat    "Valid-From Date
       AND  datbi GE im_vbak-erdat.   "Valid-To Date

    IF sy-subrc = 0.
      SORT i_repdet_int[] BY matnr.
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: W/O Product, Industry.
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    IF im_matnr IS INITIAL AND im_prctr IS INITIAL AND im_vbak-kunnr IS INITIAL AND im_vbak-kvgr1 IS INITIAL.
      li_repdet = i_repdet_int.
      DELETE li_repdet[] WHERE matnr   NE im_matnr               "XVBAP-MATNR(Material Number)
                            OR prctr   NE im_prctr               "XVBAP-PRCTR(Profit Center)
                            OR kunnr   NE im_vbak-kunnr          "XVBAK-KUNNR(Customer Number)
                            OR kvgr1   NE im_vbak-kvgr1          "XVBAK-KVGR1(Customer Group)
                            OR pstlz_f NE lst_adrc-post_code1    "Postal Code
                            OR land1   NE lst_adrc-country. "Country

      IF li_repdet[] IS NOT INITIAL.
        li_repdet_temp[] = li_repdet[].
      ENDIF.
    ENDIF.
  ENDIF.
*--------------------------------------------------------------------*
*   Data combination: W/O Product.
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    IF im_matnr IS INITIAL AND im_prctr IS INITIAL.
      li_repdet = i_repdet_int.
      DELETE li_repdet[] WHERE kunnr   NE im_vbak-kunnr          "XVBAK-KUNNR(Customer Number)
                            OR kvgr1   NE im_vbak-kvgr1          "XVBAK-KVGR1(Customer Group)
                            OR pstlz_f NE lst_adrc-post_code1    "Postal Code
                            OR land1   NE lst_adrc-country. "Country

      IF li_repdet[] IS NOT INITIAL.
        li_repdet_temp[] = li_repdet[].
      ENDIF.
    ENDIF.
  ENDIF.
*--------------------------------------------------------------------*
*   Data combination: W/O Industry
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    IF im_vbak-kunnr IS INITIAL AND im_vbak-kvgr1 IS INITIAL.
      li_repdet = i_repdet_int.
      DELETE li_repdet[] WHERE matnr   NE im_matnr               "XVBAP-MATNR(Material Number)
                            OR prctr   NE im_prctr               "XVBAP-PRCTR(Profit Center)
                            OR pstlz_f NE lst_adrc-post_code1    "Postal Code
                            OR land1   NE lst_adrc-country. "Country

      IF li_repdet[] IS NOT INITIAL.
        li_repdet_temp[] = li_repdet[].
      ENDIF.
    ENDIF.
  ENDIF.
*--------------------------------------------------------------------*
*   Data combination: material no., customer no., postal code   1
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr               "XVBAP-MATNR(Material Number)
                          OR kunnr   NE im_vbak-kunnr          "XVBAK-KUNNR(Customer Number)
                          OR pstlz_f NE lst_adrc-post_code1    "Postal Code
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, postal code  2
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr              "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1         "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1   "Postal Code
                          OR land1   NE lst_adrc-country. "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr              "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(2)      "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1   "Postal Code
                          OR land1   NE lst_adrc-country. "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr              "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(1)      "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1   "Postal Code
                          OR land1   NE lst_adrc-country. "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer no., postal code(Range)  3
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr             "XVBAP-MATNR(Material Number)
                          OR kunnr   NE im_vbak-kunnr.       "XVBAK-KUNNR(Customer Number)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1  "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.    "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, postal code(Range)  4
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr            "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1.      "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr            "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(2).   "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr            "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(1).   "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer no., region     5
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr          "XVBAP-MATNR(Material Number)
                          OR kunnr   NE im_vbak-kunnr     "XVBAK-KUNNR(Customer Number)
                          OR regio   NE lst_adrc-region   " Region
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, region    6
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr        "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1   "XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region " Region
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr        "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(2)"XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region " Region
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr        "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(1)"XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region " Region
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer no., country    7
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr          "XVBAP-MATNR(Material Number)
                          OR kunnr   NE im_vbak-kunnr     "XVBAK-KUNNR(Customer Number)
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, country   8
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr         "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1    "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr         "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(2) "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE matnr   NE im_matnr         "XVBAP-MATNR(Material Number)
                          OR kvgr1   NE im_vbak-kvgr1(1) "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: profit center, customer no., postal code   1
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kunnr   NE im_vbak-kunnr       "XVBAK-KUNNR(Customer Number)
                          OR pstlz_f NE lst_adrc-post_code1 "Postal Code
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: profit center, customer group, postal code  2
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1       "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1 "Postal Code
                          OR land1   NE lst_adrc-country.   "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(2)    "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1 "Postal Code
                          OR land1   NE lst_adrc-country.   "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(1)    "XVBAK-KVGR1(Customer Group)
                          OR pstlz_f NE lst_adrc-post_code1 "Postal Code
                          OR land1   NE lst_adrc-country.   "Country
    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: profit center, customer no., postal code(Range)  3
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr           "XVBAP-PRCTR(Profit Center)
                          OR kunnr   NE im_vbak-kunnr.     "XVBAK-KUNNR(Customer Number)
    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1"Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.  "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, postal code(Range)  4
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1.      "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(2).   "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr            "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(1).   "XVBAK-KVGR1(Customer Group)

    DELETE li_repdet[] WHERE pstlz_f GT lst_adrc-post_code1 "Postal Code(Range)
                          OR pstlz_t LT lst_adrc-post_code1
                          OR land1   NE lst_adrc-country.   "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer no., region     5
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr          "XVBAP-PRCTR(Profit Center)
                          OR kunnr   NE im_vbak-kunnr     "XVBAK-KUNNR(Customer Number)
                          OR regio   NE lst_adrc-region   "Region
                          OR land1   NE lst_adrc-country. "Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, region    6
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1    "XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region  "Region
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(2) "XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region  "Region
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(1) "XVBAK-KVGR1(Customer Group)
                          OR regio   NE lst_adrc-region  "Region
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer no., country    7
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kunnr   NE im_vbak-kunnr    "XVBAK-KUNNR(Customer Number)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*   Data combination: material no., customer group, country   8
*--------------------------------------------------------------------*
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1    "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(2) "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.
  IF li_repdet[] IS INITIAL.
    li_repdet = i_repdet_int.
    DELETE li_repdet[] WHERE prctr   NE im_prctr         "XVBAP-PRCTR(Profit Center)
                          OR kvgr1   NE im_vbak-kvgr1(1) "XVBAK-KVGR1(Customer Group)
                          OR land1   NE lst_adrc-country."Country

    IF li_repdet[] IS NOT INITIAL.
      li_repdet_temp[] = li_repdet[].
    ENDIF.
  ENDIF.

* Populating sales representative value in export parameter
  LOOP AT li_repdet_temp INTO lst_repdet.
    IF lst_repdet-srep1 IS NOT INITIAL.
      ex_srep1 = lst_repdet-srep1.    " sales representative 1
    ENDIF.
    IF lst_repdet-srep2 IS NOT INITIAL.
      ex_srep2 = lst_repdet-srep2.    " sales representative 2
    ENDIF.
  ENDLOOP.

ENDFUNCTION.
