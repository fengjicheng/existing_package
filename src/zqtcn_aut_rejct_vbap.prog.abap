*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_REJCT_VBAP
* PROGRAM DESCRIPTION:Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-11-10
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
TYPES: BEGIN OF lty_kotg501,
         kappl TYPE kappl,      " Application
         kschl TYPE kschg ,     "  Material listing/exclusion type
         land1 TYPE land1,      "  Country of Destination
         matnr TYPE matnr ,     "  Material Number
         datbi TYPE kodatbi,    " Validity end date of the condition record
         datab TYPE kodatab,    " Validity start date of the condition record
       END OF lty_kotg501,
       BEGIN OF lty_kotg001,
         kappl TYPE kappl,      " Application
         kschl TYPE kschg ,     "  Material listing/exclusion type
         kunnr TYPE kunnr_v,    "  Customer number
         matnr TYPE matnr ,     "  Material Number
         datbi TYPE kodatbi,    " Validity end date of the condition record
         datab TYPE kodatab,    " Validity start date of the condition record
       END OF lty_kotg001,

** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
       BEGIN OF lty_kotg509,
         kappl TYPE kappl,      " Application
         kschl TYPE kschg ,     "  Material listing/exclusion type
         kdgrp TYPE kdgrp,      "  Customer group
         matnr TYPE matnr ,     "  Material Number
         datbi TYPE kodatbi,    " Validity end date of the condition record
         datab TYPE kodatab,    " Validity start date of the condition record
       END OF lty_kotg509.
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001


****Internal Table declaration
DATA:

  lst_kotg001     TYPE lty_kotg001, " work area
  lst_kotg501     TYPE lty_kotg501, " Work area
** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
  lst_kotg509     TYPE lty_kotg509, " Work area
  lv_kdgrp_2      TYPE vbkd-kdgrp,  " Variable for customer group
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
  li_vbak_keytab  TYPE  TABLE OF vbuk_key, " Structure for array fetch to table VBUK
  lst_matnr       TYPE  blgl_matnr_range,  " Work area
  lst_const_x     TYPE  lty_const,
  lir_matnr       TYPE blgl_matnr_range_tt, " Range table
  li_xvbap        TYPE TABLE OF  vbapvb,
  lst_xvbap       TYPE  vbapvb,
  lir_country     TYPE temr_country, " Range table for country
  lst_country     TYPE tems_country, " Country
  lst_vbak_keytab TYPE vbuk_key.
CONSTANTS: lc_sold_to   TYPE parvw         VALUE 'AG', " Sold To partner function
           lc_insert    TYPE updkz VALUE 'I',
           lc_i_x       TYPE tvarv_sign    VALUE 'I', " Sign
           lc_eq_x      TYPE option        VALUE 'EQ', " Option
           lc_0         TYPE posnr         VALUE '000000',
           lc_abgru_exl TYPE rvari_vnam    VALUE 'ABGRU_EXCLUSE', " ABAP: Name of Variant Variable
           lc_e104      TYPE zdevid         VALUE 'E104',
           lc_ship_to   TYPE parvw         VALUE 'WE', " Sold To partner function
           lc_payer     TYPE parvw         VALUE 'RG', " Payer
           lc_bill_to   TYPE parvw         VALUE 'RE'. " Bill to Party
*& If reason code already populated then no need to trigger the logic
IF i_constant[] IS INITIAL.
* Fetch Identification Code Type from constant table.
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid    = lc_e104
      AND activate = abap_true
    ORDER BY param1 .
ENDIF. " IF i_constant[] IS INITIAL
READ TABLE i_constant INTO lst_const_x WITH KEY param1 = lc_abgru_exl BINARY SEARCH.
li_xvbap[] = xvbap[].
*& Keep only new entries
DELETE li_xvbap WHERE updkz <> lc_insert.
IF i_kotg501[] IS INITIAL.
  IF xvbap[] IS NOT INITIAL.
    SELECT   kappl      " Application
             kschl      "  Material listing/exclusion type
             land1      "  Country of Destination
             matnr      "  Material Number
             datbi      " Validity end date of the condition record
             datab      " Validity start date of the condition record
      FROM kotg501
      INTO TABLE i_kotg501
      FOR ALL ENTRIES IN xvbap
      WHERE
      matnr EQ xvbap-matnr.

  ENDIF.
ELSE.
*& For new entries populate range table
  IF li_xvbap[] IS NOT INITIAL.
    LOOP AT li_xvbap INTO lst_xvbap.
*& Binary Search not used as there could be less entries
      READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY matnr = lst_xvbap-matnr.
      IF sy-subrc <> 0.
        lst_matnr-sign = lc_i_x.
        lst_matnr-option = lc_eq.
        lst_matnr-low = lst_xvbap-matnr.
        APPEND lst_matnr TO lir_matnr.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF NOT lir_matnr[] IS INITIAL.
    SELECT        kappl       " Application
                  kschl       "  Material listing/exclusion type
                  land1       "  Country of Destination
                  matnr       "  Material Number
                  datbi       " Validity end date of the condition record
                  datab       " Validity start date of the condition record
              FROM kotg501
             APPENDING  TABLE i_kotg501
        WHERE    matnr IN lir_matnr.
  ENDIF.



ENDIF.
IF i_kotg001[] IS INITIAL.
  IF xvbap[] IS NOT INITIAL.
    SELECT   kappl       " Application
             kschl     "  Material listing/exclusion type
             kunnr     "  Customer number
             matnr      "  Material Number
             datbi    " Validity end date of the condition record
             datab     " Validity start date of the condition record
      FROM kotg001
      INTO TABLE i_kotg001
      FOR ALL ENTRIES IN xvbap
      WHERE
      matnr EQ xvbap-matnr.
    IF sy-subrc = 0.
*        SORT t_kotg001 BY kunnr matnr.
    ENDIF.
  ENDIF.
ELSE.
*& Populate Range table for new items
  IF li_xvbap[] IS NOT INITIAL .
    LOOP AT li_xvbap INTO lst_xvbap.
      READ TABLE i_kotg001 INTO lst_kotg001 WITH KEY matnr = lst_xvbap-matnr.
      IF sy-subrc <> 0.
        lst_matnr-sign = lc_i_x.
        lst_matnr-option = lc_eq_x.
        lst_matnr-low = lst_xvbap-matnr.
        APPEND lst_matnr TO lir_matnr.
      ENDIF.
    ENDLOOP.
    SELECT         kappl     " Application
                   kschl     "  Material listing/exclusion type
                   kunnr     "  Customer number
                   matnr     "  Material Number
                   datbi     " Validity end date of the condition record
                   datab     " Validity start date of the condition record
            FROM kotg001
           APPENDING  TABLE i_kotg001
      WHERE    matnr IN lir_matnr.
  ENDIF.
ENDIF.
** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
IF i_kotg509[] IS INITIAL.
  IF xvbap[] IS NOT INITIAL.
    SELECT   kappl       " Application
             kschl     "  Material listing/exclusion type
             kdgrp     "  Customer group
             matnr      "  Material Number
             datbi    " Validity end date of the condition record
             datab     " Validity start date of the condition record
      FROM kotg509
      INTO TABLE i_kotg509
      FOR ALL ENTRIES IN xvbap
      WHERE
      matnr EQ xvbap-matnr.
    IF sy-subrc = 0.
*        SORT t_kotg001 BY kunnr matnr.
    ENDIF.
  ENDIF.
ELSE.
*& Populate Range table for new items
  IF li_xvbap[] IS NOT INITIAL .
    LOOP AT li_xvbap INTO lst_xvbap.
      READ TABLE i_kotg509 INTO lst_kotg509 WITH KEY matnr = lst_xvbap-matnr.
      IF sy-subrc <> 0.
        lst_matnr-sign = lc_i_x.
        lst_matnr-option = lc_eq_x.
        lst_matnr-low = lst_xvbap-matnr.
        APPEND lst_matnr TO lir_matnr.
      ENDIF.
    ENDLOOP.
    SELECT         kappl     " Application
                   kschl     "  Material listing/exclusion type
                   kdgrp     "  Customer number
                   matnr     "  Material Number
                   datbi     " Validity end date of the condition record
                   datab     " Validity start date of the condition record
            FROM kotg509
           APPENDING  TABLE i_kotg509
      WHERE    matnr IN lir_matnr.
  ENDIF.
ENDIF.
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001

*READ TABLE i_constant INTO lst_const_x WITH KEY param1 = lc_abg_ex BINARY SEARCH.
*& Looping on the sales order items where reason code is not there
CLEAR v_abgru.
LOOP AT xvbap WHERE abgru IS INITIAL.
  CLEAR v_abgru.
  READ TABLE xvbpa WITH KEY posnr = posnr_null
                            parvw = gc_partner_sold_to_party.
  IF sy-subrc = 0.
*& No binary search required as no of entries are less
    READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY land1 = xvbpa-land1
                                                   matnr = xvbap-matnr.
    IF sy-subrc = 0 .
*& Set the global variable for Rejection reason
      v_abgru = abap_true.

    ELSE.
*& No binary search required as no of entries are less
      READ TABLE i_kotg001 INTO lst_kotg001 WITH KEY kunnr = xvbpa-kunnr
                                                    matnr = xvbap-matnr.
      IF sy-subrc = 0 .
*& Set the global variable for Rejection reason
        v_abgru = abap_true.
      ENDIF.
    ENDIF.
  ENDIF.
  IF v_abgru <> abap_true.
    READ TABLE xvbpa WITH KEY posnr = posnr_null
                              parvw = gc_partner_bill_to_party.
    IF sy-subrc = 0.
      READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY land1 = xvbpa-land1
                                                     matnr = xvbap-matnr.
      IF sy-subrc = 0 AND xvbap-abgru IS INITIAL.
*& Set the global variable for Rejection reason
        v_abgru = abap_true.
*          xvbap-abgru =
        CONTINUE.
      ENDIF.
    ENDIF.
  ENDIF.


** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
  IF v_abgru <> abap_true.
  CLEAR: lv_kdgrp_2.
  READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd1_e104>)
       WITH KEY vbeln = vbak-vbeln
                posnr = posnr_low.
  IF sy-subrc EQ 0.
    lv_kdgrp_2 = <lst_xvbkd1_e104>-kdgrp.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE i_kotg509 INTO lst_kotg509 WITH KEY kdgrp = lv_kdgrp_2
                                                 matnr = xvbap-matnr.

  IF sy-subrc IS INITIAL.
*& Set the global variable for Rejection reason
    v_abgru = abap_true.
  ENDIF.
 ENDIF.
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001


  IF v_abgru <> abap_true.
    READ TABLE xvbpa WITH KEY posnr = posnr_null
                              parvw = lc_payer.
    IF sy-subrc = 0 .
      READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY land1 = xvbpa-land1
                                                     matnr = xvbap-matnr.
      IF sy-subrc = 0 AND xvbap-abgru IS INITIAL.
*& Set the global variable for Rejection reason
        v_abgru = abap_true.

      ENDIF.
    ENDIF.
  ENDIF.
  IF v_abgru <> abap_true.
    READ TABLE xvbpa WITH KEY posnr = xvbap-posnr
                              parvw = gc_partner_ship_to_party.
    IF sy-subrc = 0 .
      READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY land1 = xvbpa-land1
                                                     matnr = xvbap-matnr.
      IF sy-subrc = 0 AND xvbap-abgru IS INITIAL.
*& Set the global variable for Rejection reason
        v_abgru = abap_true.

      ENDIF.
    ENDIF.
  ENDIF.
  IF xvbap-abgru IS INITIAL AND v_abgru IS NOT INITIAL.

    IF xvbap-updkz IS INITIAL.
      APPEND xvbap TO yvbap.
      xvbap-updkz = 'U'.
    ENDIF.
    xvbap-abgru = lst_const_x-low.
    MODIFY xvbap TRANSPORTING abgru updkz.

  ENDIF. " IF xvbap-abgru IS INITIAL AND v_abgru IS NOT INITIAL
*& Check each partner entry

ENDLOOP.
