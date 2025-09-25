*-------------------------------------------------------------------
* REVISION NO :  ED2K925269                                            *
* REFERENCE NO:  OTCM-44924                                            *
* DEVELOPER   : Rajkumar Madavoina(MRAJKUMAR)                          *
* DATE        : 01/27/2022                                             *
* DESCRIPTION : As part of GOBI Requirement, after succesful validation*
*               of GOBI data, IDOC will be triggered to SAP with       *
*               sold-to-party, material details Identifcation          *
*               This enhancemnt will convert the sold-to-party, materail
*               identification into sold-to-aprty, material in IDOC and*
*               process the data                                       *
*----------------------------------------------------------------------*
"Constants Declaration
CONSTANTS: lc_e1edka           TYPE edilsegtyp    VALUE 'E1EDKA1',
           lc_e1edp19_3        TYPE edilsegtyp    VALUE 'E1EDP19',
           lc_ag1              TYPE parvw         VALUE 'AG',
           lc_we1              TYPE parvw         VALUE 'WE',
           lc_01               TYPE c    LENGTH 2 VALUE '01',
           lc_z1qtc_e1edka1    TYPE char16 VALUE 'Z1QTC_E1EDKA1_01'.
"Data declaration
DATA: lv_idoc_i0233_5  TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]',
      lst_z1qtc_e1edka1  TYPE z1qtc_e1edka1_01,
      lst_e1edp19_1      TYPE e1edp19,
      lst_e1edka1_3      TYPE e1edka1,
      lst_e1edk02_3      TYPE e1edk02.
"Field Symbol Declaration
FIELD-SYMBOLS:
    <li_idoc_rec_i0233_5> TYPE edidd_tt.
CASE segment-segnam.
  WHEN: lc_e1edka.
* SoldToParty Validation
    IF segment-sdata+0(2) EQ lc_ag1.
      DATA(lv_segnum1) = segment-segnum + 1.
      ASSIGN (lv_idoc_i0233_5) TO <li_idoc_rec_i0233_5>.
      READ TABLE <li_idoc_rec_i0233_5>
        ASSIGNING FIELD-SYMBOL(<lfs_i0233_5>)
        WITH KEY segnum = lv_segnum1.
      IF   sy-subrc IS INITIAL
      AND  <lfs_i0233_5> IS ASSIGNED
      AND  <lfs_i0233_5>-segnam EQ lc_z1qtc_e1edka1.
        CLEAR lst_z1qtc_e1edka1.
        MOVE <lfs_i0233_5>-sdata TO  lst_z1qtc_e1edka1.
        DATA(lv_soldto1) = lst_z1qtc_e1edka1-partner.
        CONDENSE lv_soldto1.
   " Fetching Sold To Partner
          CONCATENATE lc_01
                 lv_buyerid
            INTO DATA(lv_sold).
        SELECT SINGLE
               partner,
               type,
               idnumber
          FROM but0id
          INTO @DATA(li_soldtocust)
         WHERE type     IN @lir_type
           AND idnumber EQ @lv_sold.
         IF   sy-subrc IS INITIAL
         AND  li_soldtocust IS NOT INITIAL.
          MOVE: li_soldtocust-partner TO lst_z1qtc_e1edka1-partner,
                lst_z1qtc_e1edka1     TO <lfs_i0233_5>-sdata.
         ENDIF.
      ELSEIF sy-subrc IS NOT INITIAL
      AND  <lfs_i0233_5> IS NOT ASSIGNED.
        "Do Nothing.
      ENDIF.
    ELSEIF segment-sdata+0(2) EQ lc_we1.
      CLEAR lv_segnum1.
      lv_segnum1 = segment-segnum + 1.
      ASSIGN (lv_idoc_i0233_5) TO <li_idoc_rec_i0233_5>.
      READ TABLE <li_idoc_rec_i0233_5>
        ASSIGNING <lfs_i0233_5>
        WITH KEY segnum = lv_segnum1.
      IF   sy-subrc IS INITIAL
      AND  <lfs_i0233_5> IS ASSIGNED
      AND  <lfs_i0233_5>-segnam EQ lc_z1qtc_e1edka1.
        CLEAR lst_z1qtc_e1edka1.
        MOVE <lfs_i0233_5>-sdata TO  lst_z1qtc_e1edka1.
        DATA(lv_shipto1) = lst_z1qtc_e1edka1-partner.
   " Fetching Ship To Partner
        CONCATENATE lc_01
               lv_shipto1
          INTO DATA(lv_ship).
        SELECT SINGLE
               partner,
               type,
               idnumber
          FROM but0id
          INTO @DATA(li_shiptocust)
         WHERE type     IN @lir_type
           AND ( idnumber EQ @lv_ship
            OR   idnumber EQ @lv_shipto1 ).
         IF   sy-subrc IS INITIAL
         AND  li_shiptocust IS NOT INITIAL.
          MOVE: li_shiptocust-partner TO lst_z1qtc_e1edka1-partner,
                lst_z1qtc_e1edka1     TO <lfs_i0233_5>-sdata.
         ENDIF.
      ELSEIF sy-subrc IS NOT INITIAL
      AND  <lfs_i0233_5> IS NOT ASSIGNED.
        "Do Nothing.
      ENDIF.
    ENDIF.
  WHEN: lc_e1edp19_3.
     ASSIGN (lv_idoc_i0233_5) TO <li_idoc_rec_i0233_5>.
      READ TABLE <li_idoc_rec_i0233_5>
        ASSIGNING <lfs_i0233_5>
        WITH KEY segnum = segment-segnum.
      IF  sy-subrc IS INITIAL
      AND <lfs_i0233_5> IS ASSIGNED
      AND <lfs_i0233_5>-segnam EQ lc_e1edp19_3.
        CLEAR lst_e1edp19.
        MOVE <lfs_i0233_5>-sdata TO lst_e1edp19_1.
        DATA(lv_idcode1) = lst_e1edp19_1-idtnr.
        CONDENSE lv_idcode1.
        SELECT SINGLE
               a~matnr,
               a~idcodetype,
               a~identcode,
               b~mstae,
               b~ismpubldate,
               c~maktx
          FROM jptidcdassign AS a
          INNER JOIN mara AS b
             ON a~matnr = b~matnr
          INNER JOIN makt AS c
             ON c~matnr = a~matnr
          INTO @DATA(lv_product)
          WHERE a~idcodetype  IN @lir_idcodetype
            AND a~identcode EQ @lv_idcode1.
        IF  sy-subrc    IS INITIAL
        AND lv_product IS NOT INITIAL.
          MOVE: lv_product-matnr TO lst_e1edp19_1-idtnr,
                '002'            TO lst_e1edp19_1-qualf,
                lv_product-maktx TO lst_e1edp19_1-ktext,
                lst_e1edp19_1    TO <lfs_i0233_5>-sdata.
          DATA(lv_material) = lv_product-matnr .
        ENDIF.
        CLEAR: lst_e1edka1,
               lst_e1edk02.
"Fetching Customer ID
        READ TABLE <li_idoc_rec_i0233_5>
          ASSIGNING <lfs_i0233_5>
          WITH KEY segnam = 'E1EDKA1'
                   sdata+0(3) = 'WE'.
        IF  sy-subrc IS INITIAL
        AND <lfs_i0233_5> IS ASSIGNED.
          MOVE <lfs_i0233_5>-sdata TO lst_e1edka1_3.
          DATA(lv_customerid) = lst_e1edka1_3-partn.
        ENDIF.
"Validating Duplicate PO check
        SELECT a~vbeln,
               a~parvw,
               a~kunnr,
               b~matnr
          FROM vbpa AS a
          INNER JOIN vbap AS b ON a~vbeln = b~vbeln
           INTO TABLE @DATA(lt_dupcheck)
          WHERE a~parvw EQ 'WE'
            AND a~kunnr EQ @lv_customerid
            AND b~matnr EQ @lv_product-matnr.
        IF  sy-subrc IS INITIAL
        AND lt_dupcheck IS NOT INITIAL.
          MESSAGE e613(zqtc_r2) RAISING user_error.
        ENDIF.
      ELSEIF sy-subrc IS NOT INITIAL
      AND  <lfs_i0233_5> IS NOT ASSIGNED.
        "Do Nothing.
      ENDIF.
"Checking Duplicate PO No, Material and Customer ID combination
  WHEN: 'E1EDP01'.
    DATA: lv_plant_test TYPE WERKS_D.
    FREE MEMORY ID 'PLA'.
    lv_plant_test = '8013'.
    EXPORT lv_plant_test TO MEMORY ID 'PLA'.

  WHEN: OTHERS.
    "Do Nothing
ENDCASE.
