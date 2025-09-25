*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_SALES_REP_ASSMNT_DET_NEW
* PROGRAM DESCRIPTION: Function Module for Sales Rep determination
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 19/11/2018
* OBJECT ID: E130
* TRANSPORT NUMBER(S): ED2K913891
*----------------------------------------------------------------------*
FUNCTION zqtc_sales_rep_assmnt_det_new.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SREP_DET) TYPE  ZSTQTC_SALESREP
*"  EXPORTING
*"     REFERENCE(EX_SREP1) TYPE  ZZSREP1
*"     REFERENCE(EX_SREP2) TYPE  ZZSREP2
*"----------------------------------------------------------------------

  DATA:
    li_slsrep_def  TYPE tt_slsrep_det,
    lst_slsrep_def TYPE ty_slsrep_det.

  FIELD-SYMBOLS
    <lst_slsrep_det> TYPE ty_slsrep_det.

  CONSTANTS:
    lc_ctry_us   TYPE land1 VALUE 'US',
    lc_seperator TYPE char1 VALUE '-'.

* Selecting address details
  IF st_adrc IS INITIAL.
    SELECT post_code1,     "City postal code
           post_code2,     "PO Box Postal Code
           country,        "Country Key
           region          "Region (State, Province, County)
      FROM adrc
      INTO @st_adrc
     WHERE addrnumber EQ @im_srep_det-adrnr.
    ENDSELECT.
  ENDIF.
  IF st_adrc-post_code1 IS NOT INITIAL.
    IF st_adrc-country = lc_ctry_us.
      SPLIT st_adrc-post_code1 AT lc_seperator INTO DATA(lv_pcode1) DATA(lv_pcode2).
      IF sy-subrc = 0 AND
         lv_pcode1 IS NOT INITIAL.
        st_adrc-post_code1 = lv_pcode1.
      ENDIF.
    ENDIF.
  ENDIF.

  IF i_slsrep_int[] IS INITIAL.
* Selecting header data from ZQTC_REPDET table
    SELECT vkorg,                                     "Sales Organization
           vtweg,                                     "Distribution Channel
           spart,                                     "Division
           bsark,                                     "PO Type
           matnr,                                     "Material Number
           prctr,                                     "Profit Center
           kunnr,                                     "Customer Number
           kvgr1,                                     "Customer group 1
           pstlz_f,                                   "Postal Code (From)
           pstlz_t,                                   "Postal Code (To)
           regio,                                     "Region (State, Province, County)
           land1,                                     "Country Key
           datab,                                     "Valid-From Date
           zship_to,                                  "Ship-to
           datbi,                                     "Valid To Date
           srep1,                                     "Sales Rep-1
           srep2                                      "Sales Rep-2
      FROM zqtc_repdet
      INTO TABLE @i_slsrep_int
      WHERE vkorg = @im_srep_det-vkorg AND           "Sales Organization
            vtweg = @im_srep_det-vtweg AND           "Distribution Channel
            spart = @im_srep_det-spart AND           "Division
            datab <= @im_srep_det-erdat AND          "Valid-From Date
            datbi >= @im_srep_det-erdat.             "Valid-To Date
    IF sy-subrc EQ 0.
*   Nothing to do
    ENDIF.
  ENDIF.

  IF <lst_slsrep_det> IS ASSIGNED.
    UNASSIGN <lst_slsrep_det>.
  ENDIF.

  IF i_slsrep_int[] IS NOT INITIAL.
* Priority-1
* Sales area/PO Type/Material/Customer Group 1/Postal Code/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                ( prctr NE space OR
                                  kunnr NE space OR
                                  pstlz_t NE space OR
                                  regio   NE space OR
                                  zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr kvgr1 = im_srep_det-kvgr1
           pstlz_f = st_adrc-post_code1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-2
* Sales area/PO Type/Material/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
         st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark <> im_srep_det-bsark AND
                                   matnr <> im_srep_det-matnr AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark = im_srep_det-bsark AND
                                   matnr = im_srep_det-matnr AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( prctr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND lst_slsrep_def-bsark = im_srep_det-bsark AND
             lst_slsrep_def-matnr = im_srep_det-matnr AND lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* Priority-3
* Sales area/PO Type/Material/Customer Group 1/Region/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-region IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr kvgr1 = im_srep_det-kvgr1
           regio = st_adrc-region    land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-4
* Sales area/PO Type/Material/Customer Group 1/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr kvgr1 = im_srep_det-kvgr1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-5
* Sales area/PO Type/Material/Customer Group 1
    IF im_srep_det-bsark IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-6
* Sales area/PO Type/Material/Ship to
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 zship_to <> im_srep_det-ship_to.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 zship_to = im_srep_det-ship_to AND
                                 ( prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr zship_to = im_srep_det-ship_to.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-7
* Sales area/PO Type/Material/Sold to
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr AND
                                 kunnr <> im_srep_det-kunnr .
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 kunnr = im_srep_det-kunnr AND
                                 ( prctr NE space OR
                                   kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr kunnr = im_srep_det-kunnr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-8
* Sales area/PO Type/Material
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 matnr <> im_srep_det-matnr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 matnr = im_srep_det-matnr AND
                                 ( prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           matnr = im_srep_det-matnr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-9
* Sales area/PO Type/Profit center/Customer Group 1/Postal Code/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1
           pstlz_f = st_adrc-post_code1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-10
* Sales area/PO Type/Profit center/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL AND
         im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
         st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark <> im_srep_det-bsark AND
                                   prctr <> im_srep_det-prctr AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark = im_srep_det-bsark AND
                                   prctr = im_srep_det-prctr AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( matnr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND lst_slsrep_def-bsark = im_srep_det-bsark AND
             lst_slsrep_def-prctr = im_srep_det-prctr AND lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* Priority-11
* Sales area/PO Type/Profit center/Customer Group 1/Region/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-region IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1
           regio = st_adrc-region land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-12
* Sales area/PO Type/Profit center/Customer Group 1/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-13
* Sales area/PO Type/Profit center/Customer Group 1
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-14
* Sales area/PO Type/Profit center/Ship to
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 zship_to <> im_srep_det-ship_to.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 zship_to = im_srep_det-ship_to AND
                                 ( matnr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr zship_to = im_srep_det-ship_to.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-15
* Sales area/PO Type/Profit center/Sold to
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr AND
                                 kunnr <> im_srep_det-kunnr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 kunnr = im_srep_det-kunnr AND
                                 ( matnr NE space OR
                                   kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr kunnr = im_srep_det-kunnr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-16
* Sales area/PO Type/Profit center
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 prctr <> im_srep_det-prctr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 prctr = im_srep_det-prctr AND
                                 ( matnr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           prctr = im_srep_det-prctr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-1
* Sales area/PO Type/Customer Group 1/Postal Code/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                             vtweg = im_srep_det-vtweg AND
                             spart = im_srep_det-spart AND
                             bsark = im_srep_det-bsark AND
                             kvgr1 = im_srep_det-kvgr1 AND
                             pstlz_f = st_adrc-post_code1 AND
                             land1 = st_adrc-country AND
                             ( matnr NE space OR prctr NE space OR
                               kunnr NE space OR
                               pstlz_t NE space OR
                               regio   NE space OR
                               zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           kvgr1 = im_srep_det-kvgr1 pstlz_f = st_adrc-post_code1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-2
* Sales area/PO Type/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
         st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark <> im_srep_det-bsark AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark = im_srep_det-bsark AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( matnr NE space OR prctr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND lst_slsrep_def-bsark = im_srep_det-bsark AND
             lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* New Priority-3
* Sales area/PO Type/Customer Group 1/Region/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-region IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           kvgr1 = im_srep_det-kvgr1 regio = st_adrc-region
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-4
* Sales area/PO Type/Customer Group 1/Country
    IF im_srep_det-bsark IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           kvgr1 = im_srep_det-kvgr1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-5
* Sales area/PO Type/Customer Group 1
    IF im_srep_det-bsark IS NOT INITIAL AND
       im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-6
* Sales area/PO Type/Ship-to
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 zship_to <> im_srep_det-ship_to.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 zship_to = im_srep_det-ship_to AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           zship_to = im_srep_det-ship_to.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-7
* Sales area/PO Type/Sold-to
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 kunnr <> im_srep_det-kunnr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 kunnr = im_srep_det-kunnr AND
                                 ( matnr NE space OR prctr NE space OR
                                   kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           kunnr = im_srep_det-kunnr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-8
* Sales area/PO Type/Postal Code/Country
    IF im_srep_det-bsark IS NOT INITIAL AND
       st_adrc-post_code1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           pstlz_f = st_adrc-post_code1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-9
* Sales area/PO Type/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-bsark IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
         st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark <> im_srep_det-bsark AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   bsark = im_srep_det-bsark AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( matnr NE space OR prctr NE space OR
                                     kunnr NE space OR kvgr1 NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND lst_slsrep_def-bsark = im_srep_det-bsark AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* New Priority-10
* Sales area/PO Type/Region/Country
    IF im_srep_det-bsark IS NOT INITIAL AND st_adrc-region IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           regio = st_adrc-region land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-11
* Sales area/PO Type/Country
    IF im_srep_det-bsark IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 land1 = st_adrc-country AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-17 --- Default Sales Rep
* Sales area/PO Type
    IF im_srep_det-bsark IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark <> im_srep_det-bsark.

      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 bsark = im_srep_det-bsark AND
                                 ( matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart bsark = im_srep_det-bsark.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-18
* Sales area/Material/Customer Group 1/Postal Code/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart matnr = im_srep_det-matnr
           kvgr1 = im_srep_det-kvgr1 pstlz_f = st_adrc-post_code1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-19
* Sales area/Material/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
         st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   matnr <> im_srep_det-matnr AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country .
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   matnr = im_srep_det-matnr AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( bsark NE space OR
                                     prctr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND
             lst_slsrep_def-matnr = im_srep_det-matnr AND lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* Priority-20
* Sales area/Material/Customer Group 1/Region/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-region IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           matnr = im_srep_det-matnr kvgr1 = im_srep_det-kvgr1
           regio = st_adrc-region land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-21
* Sales area/Material/Customer Group 1/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart matnr = im_srep_det-matnr
           kvgr1 = im_srep_det-kvgr1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-22
* Sales area/Material/Customer Group 1
    IF im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr <> im_srep_det-matnr AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 matnr = im_srep_det-matnr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( bsark NE space OR
                                   prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart matnr = im_srep_det-matnr
           kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-23
* Sales area/Material/Ship to
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr <> im_srep_det-matnr AND
                               zship_to <> im_srep_det-ship_to.
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr = im_srep_det-matnr AND
                               zship_to = im_srep_det-ship_to AND
                               ( bsark NE space OR
                                 prctr NE space OR
                                 kunnr NE space OR kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
         vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
         spart = im_srep_det-spart matnr = im_srep_det-matnr
         zship_to = im_srep_det-ship_to.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
* Priority-24
* Sales area/Material/Sold to
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr <> im_srep_det-matnr AND
                               kunnr <> im_srep_det-kunnr.
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr = im_srep_det-matnr AND
                               kunnr = im_srep_det-kunnr AND
                               ( bsark NE space OR
                                 prctr NE space OR
                                 kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space OR
                                 zship_to IS NOT INITIAL ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
         vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
         spart = im_srep_det-spart matnr = im_srep_det-matnr
         kunnr = im_srep_det-kunnr.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
* Priority-25
* Sales area/Material
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr <> im_srep_det-matnr.
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               matnr = im_srep_det-matnr AND
                               ( bsark NE space OR
                                 prctr NE space OR
                                 kunnr NE space OR kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space OR
                                 zship_to IS NOT INITIAL ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
         vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
         spart = im_srep_det-spart matnr = im_srep_det-matnr.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
* Priority-26
* Sales area/Profit center/Customer Group 1/Postal Code/Country
    IF im_srep_det-prctr IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart prctr = im_srep_det-prctr
           kvgr1 = im_srep_det-kvgr1 pstlz_f = st_adrc-post_code1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-27
* Sales area/Profit center/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-prctr IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
         st_adrc-post_code1 IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   prctr <> im_srep_det-prctr AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   prctr = im_srep_det-prctr AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( bsark NE space OR
                                     matnr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND
             lst_slsrep_def-prctr = im_srep_det-prctr AND lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* Priority-28
* Sales area/Profit center/Customer Group 1/Region/Country
    IF im_srep_det-prctr IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-region IS NOT INITIAL AND st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1
           regio = st_adrc-region land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-29
* Sales area/Profit center/Customer Group 1/Country
    IF im_srep_det-prctr IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart prctr = im_srep_det-prctr
           kvgr1 = im_srep_det-kvgr1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-30
* Sales area/Profit center/Customer Group 1
    IF im_srep_det-prctr IS NOT INITIAL AND im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           prctr = im_srep_det-prctr kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-31
* Sales area/Profit center/Ship to
    IF im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 zship_to <> im_srep_det-ship_to.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 zship_to = im_srep_det-ship_to AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           prctr = im_srep_det-prctr zship_to = im_srep_det-ship_to.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-32
* Sales area/Profit center/Sold to
    IF im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr AND
                                 kunnr <> im_srep_det-kunnr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 kunnr = im_srep_det-kunnr AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           prctr = im_srep_det-prctr kunnr = im_srep_det-kunnr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-33
* Sales area/Profit center
    IF im_srep_det-prctr IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr <> im_srep_det-prctr.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 prctr = im_srep_det-prctr AND
                                 ( bsark NE space OR
                                   matnr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart
           prctr = im_srep_det-prctr.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-12
* Sales area/Customer Group 1/Postal Code/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart kvgr1 = im_srep_det-kvgr1
           pstlz_f = st_adrc-post_code1 land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-13
* Sales area/Customer Group 1/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-post_code1 IS NOT INITIAL AND
         st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   kvgr1 <> im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   kvgr1 = im_srep_det-kvgr1 AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( bsark NE space OR
                                     matnr NE space OR prctr NE space OR
                                     kunnr NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND
             lst_slsrep_def-kvgr1 = im_srep_det-kvgr1 AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* New Priority-14
* Sales area/Customer Group 1/Region/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND st_adrc-region IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart kvgr1 = im_srep_det-kvgr1
           regio = st_adrc-region land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-15
* Sales area/Customer Group 1/Country
    IF im_srep_det-kvgr1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 <> im_srep_det-kvgr1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart kvgr1 = im_srep_det-kvgr1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-16
* Sales area/Customer Group 1
    IF im_srep_det-kvgr1 IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 <> im_srep_det-kvgr1.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 kvgr1 = im_srep_det-kvgr1 AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   land1   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart kvgr1 = im_srep_det-kvgr1.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-17
* Sales area/Ship-to
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               zship_to <> im_srep_det-ship_to.
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               zship_to = im_srep_det-ship_to AND
                               ( bsark NE space OR
                                 matnr NE space OR prctr NE space OR
                                 kunnr NE space OR kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
         vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
         spart = im_srep_det-spart zship_to = im_srep_det-ship_to.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
* New Priority-18
* Sales area/Sold-to
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               kunnr <> im_srep_det-kunnr.
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               kunnr = im_srep_det-kunnr AND
                               ( bsark NE space OR
                                 matnr NE space OR prctr NE space OR
                                 kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space OR
                                 zship_to IS NOT INITIAL ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
         vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
         spart = im_srep_det-spart kunnr = im_srep_det-kunnr.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
* New Priority-19
* Sales area/Postal Code/Country
    IF st_adrc-post_code1 IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 pstlz_f <> st_adrc-post_code1 AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 pstlz_f = st_adrc-post_code1 AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart pstlz_f = st_adrc-post_code1
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-20
* Sales area/Postal Code from/Postal Code to/Country
* Postal Code from/Postal Code to combination should work only for US
    IF st_adrc-country = lc_ctry_us.
      IF st_adrc-post_code1 IS NOT INITIAL AND
         st_adrc-country IS NOT INITIAL.
        li_slsrep_def[] = i_slsrep_int[].
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 <> st_adrc-country.
        DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                   vtweg = im_srep_det-vtweg AND
                                   spart = im_srep_det-spart AND
                                   pstlz_f = space AND pstlz_t = space AND
                                   land1 = st_adrc-country AND
                                   ( bsark NE space OR
                                     matnr NE space OR prctr NE space OR
                                     kunnr NE space OR kvgr1 NE space OR
                                     regio NE space OR
                                     zship_to IS NOT INITIAL ).
        LOOP AT li_slsrep_def INTO lst_slsrep_def.
          IF lst_slsrep_def-vkorg = im_srep_det-vkorg AND lst_slsrep_def-vtweg = im_srep_det-vtweg AND
             lst_slsrep_def-spart = im_srep_det-spart AND
             st_adrc-post_code1 >= lst_slsrep_def-pstlz_f AND st_adrc-post_code1 <= lst_slsrep_def-pstlz_t AND
             lst_slsrep_def-land1 = st_adrc-country.
            ex_srep1 = lst_slsrep_def-srep1.     " Sales Representative 1
            ex_srep2 = lst_slsrep_def-srep2.     " Sales Representative 2
            IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
              CLEAR lst_slsrep_def.
              EXIT.
            ENDIF.
          ENDIF.
          CLEAR lst_slsrep_def.
        ENDLOOP.
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF. " IF st_adrc-country = lc_ctry_us.
* New Priority-21
* Sales area/Region/Country
    IF st_adrc-region IS NOT INITIAL AND
       st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 regio <> st_adrc-region AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 regio = st_adrc-region AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart regio = st_adrc-region
           land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* New Priority-22
* Sales area/Country
    IF st_adrc-country IS NOT INITIAL.
      li_slsrep_def[] = i_slsrep_int[].
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 land1 <> st_adrc-country.
      DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                                 vtweg = im_srep_det-vtweg AND
                                 spart = im_srep_det-spart AND
                                 land1 = st_adrc-country AND
                                 ( bsark NE space OR
                                   matnr NE space OR prctr NE space OR
                                   kunnr NE space OR kvgr1 NE space OR
                                   pstlz_f NE space OR
                                   pstlz_t NE space OR
                                   regio   NE space OR
                                   zship_to IS NOT INITIAL ).
      READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
           vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
           spart = im_srep_det-spart land1 = st_adrc-country.
      IF sy-subrc = 0.
        ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
        ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
        IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* Priority-34 --- Consider Default Sales Rep with Sales Area (1001, 3310, 5501, 8001)
* Sales area
    li_slsrep_def[] = i_slsrep_int[].
    DELETE li_slsrep_def WHERE vkorg = im_srep_det-vkorg AND
                               vtweg = im_srep_det-vtweg AND
                               spart = im_srep_det-spart AND
                               ( bsark NE space OR
                                 matnr NE space OR prctr NE space OR
                                 kunnr NE space OR kvgr1 NE space OR
                                 pstlz_f NE space OR
                                 pstlz_t NE space OR
                                 regio   NE space OR
                                 land1   NE space OR
                                 zship_to IS NOT INITIAL ).
    READ TABLE li_slsrep_def ASSIGNING <lst_slsrep_det> WITH KEY
               vkorg = im_srep_det-vkorg vtweg = im_srep_det-vtweg
               spart = im_srep_det-spart.
    IF sy-subrc = 0.
      ex_srep1 = <lst_slsrep_det>-srep1.     " Sales Representative 1
      ex_srep2 = <lst_slsrep_det>-srep2.     " Sales Representative 2
      IF ex_srep1 IS NOT INITIAL OR ex_srep2 IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.

  ENDIF.  " IF i_slsrep_int[] IS NOT INITIAL


ENDFUNCTION.
