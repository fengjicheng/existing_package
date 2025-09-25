*&---------------------------------------------------------------------*
*&  Include           ZQTCR_SUBRENEWAL_R053_SUB
*&---------------------------------------------------------------------*
*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SUBRENEWAL_R053_sub
* PROGRAM DESCRIPTION: Renewals Subscription
* DEVELOPER: Mounika Nallapaneni
* CREATION DATE:   2017-06-02
* OBJECT ID: R053
* TRANSPORT NUMBER(S): ED2K906467
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K907462
* REFERENCE NO:  Defect 3595
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-26
* DESCRIPTION: VEDA table selection is modified for contract start
*              and end date combination
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908710
* REFERENCE NO:  ERP 4700
* DEVELOPER: Anirban Saha
* DATE:  2017-09-28
* DESCRIPTION: Taking out the communication method field from report
*-------------------------------------------------------------------
* REVISION NO: ED2K909671
* REFERENCE NO:  ERP 5402
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-11-30
* DESCRIPTION: Commented the code that was made to check on the PO number.
*-------------------------------------------------------------------
* REVISION NO: ED2K909489
* REFERENCE NO:  ERP-5530
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-12-14
* DESCRIPTION: To improve the performance of the program and as part
*              of this made the dates as mandatory parameters.
*-------------------------------------------------------------------
* REVISION NO: ED2K913224, ED2K913417
* REFERENCE NO:  ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-28
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO: ED2K913419
* REFERENCE NO:  ERP-7727
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-09-21
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO:  ED1K909057/ED1K909130
* REFERENCE NO: INC0217212
* DEVELOPER:    NPOLINA
* DATE:         2018-11-30
* DESCRIPTION:  Time out error, replaced Tables with CDS view
*-------------------------------------------------------------------
* REVISION NO: ED1K909215/ED1K909474
* REFERENCE NO:  RITM0080792
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2018-12-26 / 2019-01-31
* DESCRIPTION: Added new fields in Report O/P
*-------------------------------------------------------------------
* REVISION NO:   ED2K915473
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field AUGRU-Order Reason in
*                Selection Screen and Report O/P
* Imp Notes:     The is a change done to the CDS view
*                ZQTC_SALES_001 and captured in Transport
*                ED2K915477 which need to be moved simultaneously
*-------------------------------------------------------------------
* REVISION NO:   ED2K915605
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field Order Reason Description
*                and corrected existing code for Order reason
*-------------------------------------------------------------------
* REVISION NO:   ED2K915723
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-07-16
* DESCRIPTION:   Changed field description of Order Reason Description
*                and removed the field Order reason augru.
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917842
* REFERENCE NO:  ERPM-4405
* WRICEF ID: R053
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  03/24/2020
* DESCRIPTION: Avoid displaying wrong invoice numbers for subscription orders
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:   ED2K920475
* REFERENCE NO:  OTCM-25936
* DEVELOPER:     Prabhu (PTUFARAM)
* DATE:          11/25/2020
* DESCRIPTION:   1.Added new fields Media Start Issue
*                Media End Issue.
*                2.Issue sent, Issue Duw logic has been changed
* Imp Notes:     Performance Improvement
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:   ED2K920782
* REFERENCE NO:  OTCM-25936
* DEVELOPER:     Thilina (TDIMANTHA)
* DATE:          12/11/2020
* DESCRIPTION:   Implement new flow of logic to solve the performance
*                Issue when payment dates are given.
*                First fetch payment/invoice information for given
*                payment dates then fetch order information relevant
*                to invoice information
*-------------------------------------------------------------------
* REVISION NO:   ED1K913372
* REFERENCE NO:  PRB0047627
* DEVELOPER:     ARGADEELA
* DATE:          08/30/2021
* DESCRIPTION:   Fixed the bug of Net value is incorrect when pulling
*                the report based on Material and Do not display Bom components
*-------------------------------------------------------------------
* REVISION NO:   ED1K913882
* REFERENCE NO:  INC0414259
* DEVELOPER:     ARGADEELA
* DATE:          12/09/2021
* DESCRIPTION:   Fixed the bug of Net value and first/last issue is incorrect
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_vbak .

* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
  DATA: lir_cedat TYPE /grcpi/gria_t_date_range,
        lir_csdat TYPE /grcpi/gria_t_date_range,
        lst_cedat TYPE /grcpi/gria_s_date_range, " Date Range
        lst_csdat TYPE /grcpi/gria_s_date_range. " Date Range

  IF NOT p_cstaf IS INITIAL
    AND NOT p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_bt.
    lst_csdat-low     = p_cstaf.
    lst_csdat-high    = p_cstat.
    APPEND lst_csdat TO lir_csdat.
  ELSEIF NOT p_cstaf IS INITIAL
    AND p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_eq.
    lst_csdat-low     = p_cstaf.
    APPEND lst_csdat TO lir_csdat.
  ENDIF. " IF NOT p_cstaf IS INITIAL

  IF NOT p_cendf IS INITIAL
    AND NOT p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_bt.
    lst_cedat-low     = p_cendf.
    lst_cedat-high    = p_cendt.
    APPEND lst_cedat TO lir_cedat.
  ELSEIF NOT p_cendf IS INITIAL
    AND p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_eq.
    lst_cedat-low     = p_cendf .
    APPEND lst_cedat TO lir_cedat.
  ENDIF. " IF NOT p_cendf IS INITIAL
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
* SOC by NPOLINA  INC0217212 ED1K909057 30-Nov-2018
*  Replacing Tables with CDS View

*  SELECT a~vbeln,    " Sales Document
*         a~auart,    " Sales Document Type
*         a~waerk,    " SD Document Currency
*         a~vkorg,    " Sales Organization
*         a~vkbur,    " Sales Office
*         a~kunnr,    " Sold-to party
*         a~erdat,    " Creation date
*         a~lifsk,    " Delivery block
*         a~faksk,    " Billing block
*         b~posnr,    " Sales Document Item
*         b~matnr,    " Material Number
*         b~arktx,    " Material description
*         b~netwr,    " Net value of the order item in document currency
*         b~zzsubtyp, " Subscription Type
*         b~zmeng,    " Target quantity in sales units
*         b~zieme,    " Target quantity UoM
*         b~mvgr1,    " Material group 1
*         b~mvgr2,    " Material group 2
*         b~mvgr3,    " Material group 3
*         b~mvgr4,    " Material group 4
*         b~mvgr5,    " Material group 5
** BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*         c~vposn,   " Sales Document Item
*         c~vbegdat, " Contract start date
*         c~venddat, " Contract end date
** EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
**        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*         a~bukrs_vf, " Company code to be billed
*         b~vgbel,    " Document number of the reference document
**        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
**        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*         a~zzlicgrp, " License Group
*         b~mwsbp,    " Tax amount in document currency
*         b~werks,    " Plant
*         a~vtweg,    " Distribution Channel
*         a~spart,    " Division
*         c~vkuegru,  " Reason for Cancellation of Contract
*         b~uepos     " Higher-level item in bill of material structures
**        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*    INTO TABLE @i_vbak
*         FROM vbak AS a
*    INNER JOIN vbap AS b
*    ON b~vbeln = a~vbeln
** BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*    INNER JOIN veda AS c
*    ON c~vbeln = b~vbeln
*   AND ( c~vposn = b~posnr OR
*         c~vposn = @c_posnr_hd )
** EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*     WHERE  a~vbeln IN @s_saldoc
*      AND   a~auart IN @s_doctyp
*      AND   a~vkorg IN @s_vkorg
*      AND   a~vkbur IN @s_vkbur
*      AND   a~kunnr IN @s_kunnr
*      AND   a~lifsk IN @s_lifsk
*      AND   a~faksk IN @s_faksk
**     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*      AND   a~waerk IN @s_waerk " SD Document Currency / Payment Currency
**     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
**     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*      AND   b~mvgr5 IN @s_mvgr5 " Material group 5
**     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*      AND   b~matnr IN @s_matnum
** BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*     AND ( c~vbegdat IN @lir_csdat
*     AND c~venddat IN @lir_cedat )
*     AND bsark IN @s_bsark.
** EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489

  SELECT vbeln,    " Sales Document
           auart,    " Sales Document Type
           waerk,    " SD Document Currency
           vkorg,    " Sales Organization
           vkbur,    " Sales Office
           kunnr,    " Sold-to party
           erdat,    " Creation date
           lifsk,    " Delivery block
           faksk,    " Billing block
           posnr,    " Sales Document Item
           matnr,    " Material Number
           arktx,    " Material description
           netwr,    " Net value of the order item in document currency
           zzsubtyp, " Subscription Type
           zmeng,    " Target quantity in sales units
           zieme,    " Target quantity UoM
           mvgr1,    " Material group 1
           mvgr2,    " Material group 2
           mvgr3,    " Material group 3
           mvgr4,    " Material group 4
           mvgr5,    " Material group 5
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
           vposn,   " Sales Document Item
           vbegdat, " Contract start date
           venddat, " Contract end date
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
           bukrs_vf, " Company code to be billed
           vgbel,    " Document number of the reference document
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
           zzlicgrp, " License Group
           mwsbp,    " Tax amount in document currency
           werks,    " Plant
           vtweg,    " Distribution Channel
           spart,    " Division
           vkuegru,  " Reason for Cancellation of Contract
           uepos,     " Higher-level item in bill of material structures
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
           augru
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
      INTO TABLE @i_vbak
           FROM zqtc_sales_001
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
       WHERE  vbeln IN @s_saldoc
        AND   auart IN @s_doctyp
        AND   vkorg IN @s_vkorg
        AND   vkbur IN @s_vkbur
        AND   kunnr IN @s_kunnr
        AND   lifsk IN @s_lifsk
        AND   faksk IN @s_faksk
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
        AND   waerk IN @s_waerk " SD Document Currency / Payment Currency
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        AND   mvgr5 IN @s_mvgr5 " Material group 5
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        AND   matnr IN @s_matnum
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
       AND ( vbegdat IN @lir_csdat
       AND venddat IN @lir_cedat )
       AND bsark IN @s_bsark
       AND augru IN @s_augru. " Added by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
* EOC by NPOLINA  INC0217212 ED1K909057 30-Nov-2018

  IF  sy-subrc EQ 0.
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    IF cb_nocmp IS NOT INITIAL.
*     Fetch BOM Component Details
      DATA(li_vbak) = i_vbak[].
* SOC by NPOLINA  INC0217212 ED1K909057 30-Nov-2018
* Replacing Tables with CDS View

*         SELECT a~vbeln,    " Sales Document
*             a~auart,    " Sales Document Type
*             a~waerk,    " SD Document Currency
*             a~vkorg,    " Sales Organization
*             a~vkbur,    " Sales Office
*             a~kunnr,    " Sold-to party
*             a~erdat,    " Creation date
*             a~lifsk,    " Delivery block
*             a~faksk,    " Billing block
*             b~posnr,    " Sales Document Item
*             b~matnr,    " Material Number
*             b~arktx,    " Material description
*             b~netwr,    " Net value of the order item in document currency
*             b~zzsubtyp, " Subscription Type
*             b~zmeng,    " Target quantity in sales units
*             b~zieme,    " Target quantity UoM
*             b~mvgr1,    " Material group 1
*             b~mvgr2,    " Material group 2
*             b~mvgr3,    " Material group 3
*             b~mvgr4,    " Material group 4
*             b~mvgr5,    " Material group 5
*             c~vposn,    " Sales Document Item
*             c~vbegdat,  " Contract start date
*             c~venddat,  " Contract end date
*             a~bukrs_vf, " Company code to be billed
*             b~vgbel,    " Document number of the reference document
*             a~zzlicgrp, " License Group
*             b~mwsbp,    " Tax amount in document currency
*             b~werks,    " Plant
*             a~vtweg,    " Distribution Channel
*             a~spart,    " Division
*             c~vkuegru,  " Reason for Cancellation of Contract
*             b~uepos     " Higher-level item in bill of material structures
*   APPENDING TABLE @i_vbak
*        FROM vbak AS a
*       INNER JOIN vbap AS b
*          ON b~vbeln = a~vbeln
*       INNER JOIN veda AS c
*          ON c~vbeln = b~vbeln
*         AND ( c~vposn = b~posnr OR
*               c~vposn = @c_posnr_hd )
*         FOR ALL ENTRIES IN @li_vbak
*       WHERE a~vbeln EQ @li_vbak-vbeln
*         AND b~uepos EQ @li_vbak-posnr
*         AND bsark IN @s_bsark.

      SELECT vbeln,    " Sales Document
                   auart,    " Sales Document Type
                   waerk,    " SD Document Currency
                   vkorg,    " Sales Organization
                   vkbur,    " Sales Office
                   kunnr,    " Sold-to party
                   erdat,    " Creation date
                   lifsk,    " Delivery block
                   faksk,    " Billing block
                   posnr,    " Sales Document Item
                   matnr,    " Material Number
                   arktx,    " Material description
                   netwr,    " Net value of the order item in document currency
                   zzsubtyp, " Subscription Type
                   zmeng,    " Target quantity in sales units
                   zieme,    " Target quantity UoM
                   mvgr1,    " Material group 1
                   mvgr2,    " Material group 2
                   mvgr3,    " Material group 3
                   mvgr4,    " Material group 4
                   mvgr5,    " Material group 5
                   vposn,    " Sales Document Item
                   vbegdat,  " Contract start date
                   venddat,  " Contract end date
                   bukrs_vf, " Company code to be billed
                   vgbel,    " Document number of the reference document
                   zzlicgrp, " License Group
                   mwsbp,    " Tax amount in document currency
                   werks,    " Plant
                   vtweg,    " Distribution Channel
                   spart,    " Division
                   vkuegru,  " Reason for Cancellation of Contract
                   uepos,     " Higher-level item in bill of material structures
* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915605
                   augru
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915605
         APPENDING TABLE @i_vbak
              FROM zqtc_sales_001
               FOR ALL ENTRIES IN @li_vbak
             WHERE vbeln EQ @li_vbak-vbeln
               AND uepos EQ @li_vbak-posnr
               AND bsark IN @s_bsark
               AND augru IN @s_augru. " Added by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605

* EOC by NPOLINA  INC0217212 ED1K909057 30-Nov-2018
      IF sy-subrc NE 0.
*         Nothing to do
      ENDIF.
    ENDIF. " IF cb_nocmp IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

  IF i_vbak[] IS NOT INITIAL.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    i_veda[] = i_vbak[].
    SORT i_vbak BY vbeln posnr.
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
    DELETE ADJACENT DUPLICATES FROM i_vbak COMPARING vbeln posnr.
    SORT i_veda BY vbeln vposn.
    DELETE ADJACENT DUPLICATES FROM i_veda COMPARING vbeln vposn.
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489

* BOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
    SELECT * FROM tvaut INTO TABLE i_tvaut
       WHERE spras = sy-langu
       AND augru IN s_augru.
    IF sy-subrc = 0.
      SORT i_tvaut BY augru.
    ENDIF.
* EOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
  ELSE. " ELSE -> IF i_vbak[] IS NOT INITIAL
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
    LEAVE LIST-PROCESSING .
  ENDIF. " IF i_vbak[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBKD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_vbkd .
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
  DATA: lst_vbkd    TYPE ty_vbkd,
        lst_vbak    TYPE ty_vbak,
        lst_veda    TYPE ty_vbak,
        li_vbak_tmp TYPE TABLE OF ty_vbak,
        li_veda_tmp TYPE TABLE OF ty_vbak.
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
  IF i_vbak IS NOT INITIAL.
* SOC by NPOLINA ED1K909130    INC0217212
*    SELECT vbeln " Sales and Distribution Document Number
*           posnr " Item number of the SD document
*           konda " Price group (customer)
*           bstkd " Customer purchase order number
*           bsark " Customer purchase order type
*           ihrez " Your Reference
*           kdkg1 " Customer condition group 1
*           kdkg2 " Customer condition group 2
*           kdkg3 " Customer condition group 3
*           kdkg4 " Customer condition group 4
*           kdkg5 " Customer condition group 5
**          Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*           kdgrp " Customer group
*           pltyp " Price list type
**          End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*      FROM vbkd " Sales Document: Business Data
*      INTO TABLE i_vbkd
*      FOR ALL ENTRIES IN i_vbak
*      WHERE vbeln = i_vbak-vbeln
*      AND  ( posnr = i_vbak-posnr
*       OR posnr = c_posnr_hd )
**     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*      AND   ihrez IN s_ihrez " Your Reference
*      AND   konda IN s_konda " Price group (customer)
**     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
**     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*      AND   kdkg2 IN s_kdkg2 " Customer condition group 2
**     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*      AND   bstkd IN s_ponum
*      AND   bsark IN s_bsark.

    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           konda " Price group (customer)
           bstkd " Customer purchase order number
           bsark " Customer purchase order type
           ihrez " Your Reference
           kdkg1 " Customer condition group 1
           kdkg2 " Customer condition group 2
           kdkg3 " Customer condition group 3
           kdkg4 " Customer condition group 4
           kdkg5 " Customer condition group 5
*          Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
           kdgrp " Customer group
           pltyp " Price list type
*          End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*          Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
           ihrez_e " Ship-to party character
*          End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
      FROM zqtc_sales_002 " Sales Document: Business Data
      INTO TABLE i_vbkd
      FOR ALL ENTRIES IN i_vbak
      WHERE vbeln = i_vbak-vbeln
      AND  ( posnr = i_vbak-posnr
       OR posnr = c_posnr_hd )
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      AND   ihrez IN s_ihrez " Your Reference
      AND   konda IN s_konda " Price group (customer)
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      AND   kdkg2 IN s_kdkg2 " Customer condition group 2
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      AND   bstkd IN s_ponum
      AND   bsark IN s_bsark.
* EOC by NPOLINA ED1K909130    INC0217212
    IF  sy-subrc EQ 0.
      SORT i_vbkd BY vbeln posnr.
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
* To filter the records that are only satisfied for customer PO ref and PO type
      IF s_ponum[] IS NOT INITIAL OR s_bsark[] IS NOT INITIAL
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      OR s_ihrez[] IS NOT INITIAL OR s_konda[] IS NOT INITIAL
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      OR s_kdkg2[] IS NOT INITIAL.
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        LOOP AT i_vbkd INTO lst_vbkd.
          READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln = lst_vbkd-vbeln
                                                   posnr = lst_vbkd-posnr
                                                   BINARY SEARCH.
          IF sy-subrc EQ 0.
            APPEND lst_vbak TO li_vbak_tmp.
          ELSE. " ELSE -> IF sy-subrc EQ 0
            READ TABLE i_vbak INTO lst_vbak WITH KEY vbeln = lst_vbkd-vbeln
                                                     BINARY SEARCH.
            IF sy-subrc EQ 0.
              APPEND lst_vbak TO li_vbak_tmp.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
          READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbkd-vbeln
                                                   vposn = lst_vbkd-posnr
                                                   BINARY SEARCH.
          IF sy-subrc EQ 0.
            APPEND lst_veda TO li_veda_tmp.
          ELSE. " ELSE -> IF sy-subrc EQ 0
            READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbkd-vbeln
                                            BINARY SEARCH.
            IF sy-subrc EQ 0.
              APPEND lst_veda TO li_veda_tmp.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
        ENDLOOP. " LOOP AT i_vbkd INTO lst_vbkd
        IF li_vbak_tmp[] IS NOT INITIAL.
          CLEAR i_vbak.
          i_vbak[] = li_vbak_tmp[].
          CLEAR li_vbak_tmp[].
          SORT i_vbak BY vbeln posnr.
          DELETE ADJACENT DUPLICATES FROM i_vbak COMPARING vbeln posnr.
        ENDIF. " IF li_vbak_tmp[] IS NOT INITIAL
        IF li_veda_tmp IS NOT INITIAL.
          CLEAR i_veda[].
          i_veda[] = li_veda_tmp[].
          CLEAR li_veda_tmp[].
          SORT i_veda BY vbeln vposn.
          DELETE ADJACENT DUPLICATES FROM i_veda COMPARING vbeln vposn.
        ENDIF. " IF li_veda_tmp IS NOT INITIAL
      ENDIF. " IF s_ponum[] IS NOT INITIAL OR s_bsark[] IS NOT INITIAL
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    ELSE. " ELSE -> IF sy-subrc EQ 0
      MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
      LEAVE LIST-PROCESSING .
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_vbak IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_mara.

  DATA: li_vbak TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0.

  li_vbak[] = i_vbak[].
  SORT li_vbak BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING matnr.

  IF li_vbak IS NOT INITIAL.
    SELECT matnr        " Material Number
           extwg        " External Material Group
           ismtitle     " Title
           ismmediatype " Media Type
       FROM mara        " General Material Data
      INTO TABLE i_mara
      FOR ALL ENTRIES IN li_vbak
      WHERE matnr = li_vbak-matnr.
    IF  sy-subrc EQ 0.
      SORT i_mara BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_vbak IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ZQTC_RENWL_PLAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_zqtc_renwl_plan .

  DATA : li_renwl_plan TYPE STANDARD TABLE OF ty_zqtc_renwl_plan INITIAL SIZE 0.

  IF i_vbak[] IS NOT INITIAL.   "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
    SELECT vbeln           " Sales Document
           posnr           " Sales Document Item
           activity        " E095: Activity
           eadat           " Activity Date
           act_status      " Activity Status
           ren_status      " Renewal Status
      FROM zqtc_renwl_plan " E095: Renewal Plan Table
      INTO  TABLE i_zqtc_renwl_plan
      FOR ALL ENTRIES IN i_vbak
      WHERE  vbeln = i_vbak-vbeln
      AND posnr = i_vbak-posnr.
    IF sy-subrc EQ 0.
*   Begin of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   SORT i_zqtc_renwl_plan BY vbeln posnr.
*   End   of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      IF cb_unqol IS INITIAL.
        SORT i_zqtc_renwl_plan BY vbeln ASCENDING
                                  posnr ASCENDING
                                  eadat ASCENDING.
      ELSE. " ELSE -> IF cb_unqol IS INITIAL
        SORT i_zqtc_renwl_plan BY vbeln ASCENDING
                                  posnr ASCENDING
                                  eadat DESCENDING.
        DELETE ADJACENT DUPLICATES FROM i_zqtc_renwl_plan COMPARING vbeln posnr.
      ENDIF. " IF cb_unqol IS INITIAL
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224

      li_renwl_plan[] = i_zqtc_renwl_plan[].
      SORT li_renwl_plan BY activity.
      DELETE ADJACENT DUPLICATES FROM li_renwl_plan COMPARING activity.

      SELECT activity       " E095: Activity
             spras          " Language Key
             activity_d     " Description
        FROM zqtct_activity " E095: Activity Text Table
        INTO TABLE  i_zqtct_activity
        FOR ALL ENTRIES IN li_renwl_plan
        WHERE activity = li_renwl_plan-activity
        AND  spras = sy-langu.
      IF sy-subrc EQ 0.
        SORT i_zqtct_activity BY activity.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.                    "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
ENDFORM.
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
**&---------------------------------------------------------------------*
**&      Form  F_GET_VEDA
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM f_get_veda .
**-----When only contract START date FROM is given
*  IF NOT p_cstaf IS INITIAL
*    AND  p_cstat IS INITIAL
*    AND  p_cendf IS INITIAL
*    AND  p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND vbegdat = p_cstaf.
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When only contract END date FROM is given
*  IF NOT p_cendf IS INITIAL
*    AND  p_cstat IS INITIAL
*    AND  p_cstaf IS INITIAL
*    AND  p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND venddat = p_cendf.
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract START date FROM and TO is given
*  IF NOT p_cstaf IS INITIAL
*    AND NOT p_cstat IS INITIAL
*    AND  p_cendf IS INITIAL
*    AND  p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND ( vbegdat GE p_cstaf
*  AND vbegdat LE p_cstat ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract END date FROM and TO is given
*  IF NOT p_cendf IS INITIAL
*    AND NOT p_cendt IS INITIAL
*    AND  p_cstaf IS INITIAL
*    AND  p_cstat IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND ( venddat GE p_cendf
*  AND venddat LE p_cendt ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract START FROM date and END FROM date is given
*  IF NOT p_cstaf IS INITIAL
*    AND NOT p_cendf IS INITIAL
*    AND  p_cstat IS INITIAL
*    AND  p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND vbegdat EQ p_cstaf
*  AND venddat EQ p_cendf.
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When all 4 fields are given
*  IF NOT p_cstaf IS INITIAL
*    AND NOT p_cstat IS INITIAL
*    AND NOT p_cendf IS INITIAL
*    AND NOT p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND ( vbegdat GE p_cstaf AND vbegdat LE p_cstat )
*  AND ( venddat GE p_cendf AND venddat LE p_cendt ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When all 4 fields are blank
*  IF p_cstaf IS INITIAL
*    AND p_cstat IS INITIAL
*    AND p_cendf IS INITIAL
*    AND p_cendt IS INITIAL.
*
*    SELECT  vbeln   " Sales Document
*            vposn   " Sales Document Item
*            vbegdat " Contract start date
*            venddat " Contract end date
*       FROM veda    " Contract Data
*      INTO TABLE i_veda
*      FOR ALL ENTRIES IN i_vbak
*      WHERE vbeln = i_vbak-vbeln
*      AND  ( vposn = i_vbak-posnr
*      OR  vposn = c_posnr_hd ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**Begin of Add-Anirban-07.26.2017-ED2K907462-Defect 3595
**-----When contract start from and to and End from date is given
*  IF NOT p_cstaf IS INITIAL
*    AND NOT p_cstat IS INITIAL
*    AND NOT p_cendf IS INITIAL
*    AND p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND ( vbegdat GE p_cstaf AND vbegdat LE p_cstat )
*  AND  venddat GE p_cendf.
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract start from and to and End to date is given
*  IF NOT p_cstaf IS INITIAL
*    AND NOT p_cstat IS INITIAL
*    AND p_cendf IS INITIAL
*    AND NOT p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND ( vbegdat GE p_cstaf AND vbegdat LE p_cstat )
*  AND  venddat LE p_cendt.
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract start from and End from and  to date is given
*  IF NOT p_cstaf IS INITIAL
*    AND p_cstat IS INITIAL
*    AND NOT p_cendf IS INITIAL
*    AND NOT p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND vbegdat GE p_cstaf
*  AND  ( venddat GE p_cendf AND venddat LE p_cendt ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
*
**-----When contract start to and contract End from and to date is given
*  IF p_cstaf IS INITIAL
*    AND NOT p_cstat IS INITIAL
*    AND NOT p_cendf IS INITIAL
*    AND NOT p_cendt IS INITIAL.
*    SELECT  vbeln   " Sales Document
*        vposn   " Sales Document Item
*        vbegdat " Contract start date
*        venddat " Contract end date
*   FROM veda    " Contract Data
*  INTO TABLE i_veda
*  FOR ALL ENTRIES IN i_vbak
*  WHERE vbeln = i_vbak-vbeln
*  AND  ( vposn = i_vbak-posnr
*  OR  vposn = c_posnr_hd )
*  AND vbegdat LE p_cstat
*  AND  ( venddat GE p_cendf AND venddat LE p_cendt ).
*    IF  sy-subrc EQ 0.
*      SORT i_veda BY vbeln vposn.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF.
**End of Add-Anirban-07.26.2017-ED2K907462-Defect 3595
*
***  IF NOT p_valid IS INITIAL.
***    DELETE i_veda WHERE vbegdat GT p_valid OR venddat LT p_valid.
***  ENDIF.
*ENDFORM.
**
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBPA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_vbpa .
  DATA:  lir_parvw TYPE tt_parvw_r.
  DATA:  lst_parvw TYPE LINE OF tt_parvw_r.

  CONSTANTS: lc_parvw_sh TYPE parvw VALUE 'WE', " Partner Function
             lc_parvw_sp TYPE parvw VALUE 'AG', " Partner Function
*            Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
             lc_parvw_re TYPE parvw VALUE 'RE', " Partner Function (Bill-To Party)
*            End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*            Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
             lc_parvw_fa TYPE parvw VALUE 'SP', " Partner Function (Forwarding Agent)
*            End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*             lc_parvw_za TYPE parvw VALUE 'ZA', " Partner Function
             lc_i        TYPE char1 VALUE 'I',  " I of type CHAR1
             lc_eq       TYPE char2 VALUE 'EQ'. " Eq of type CHAR2

* WE
  lst_parvw-sign   = lc_i.
  lst_parvw-option = lc_eq.
  lst_parvw-low    = lc_parvw_sh.
  APPEND lst_parvw TO lir_parvw.
  CLEAR lst_parvw.
*AG
  lst_parvw-sign   = lc_i.
  lst_parvw-option = lc_eq.
  lst_parvw-low    = lc_parvw_sp.
  APPEND lst_parvw TO lir_parvw.
  CLEAR lst_parvw.
* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* RE (Bill-To Party)
  lst_parvw-sign   = lc_i.
  lst_parvw-option = lc_eq.
  lst_parvw-low    = lc_parvw_re.
  APPEND lst_parvw TO lir_parvw.
  CLEAR lst_parvw.
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* SP (Forwarding Agent)
  lst_parvw-sign   = lc_i.
  lst_parvw-option = lc_eq.
  lst_parvw-low    = lc_parvw_fa.
  APPEND lst_parvw TO lir_parvw.
  CLEAR lst_parvw.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

*ZA
*  IF cb_parfn IS NOT INITIAL.
  IF NOT p_parvw IS INITIAL.
    lst_parvw-sign   = lc_i.
    lst_parvw-option = lc_eq.
    lst_parvw-low    = p_parvw.
    APPEND lst_parvw TO lir_parvw.
  ENDIF. " IF NOT p_parvw IS INITIAL

*  lst_parvw-sign   = lc_i.
*  lst_parvw-option = lc_eq.
*  lst_parvw-low    = lc_parvw_za.
*  APPEND lst_parvw TO lir_parvw.
*  CLEAR lst_parvw.

  IF i_vbak[] IS NOT INITIAL.   "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           parvw " Partner Function
           kunnr " Customer Number
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
           lifnr " Account Number of Vendor or Creditor
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
           adrnr " Address
      FROM vbpa  " Sales Document: Partner
      INTO TABLE i_vbpa
      FOR ALL ENTRIES IN i_vbak
      WHERE vbeln = i_vbak-vbeln
      AND ( posnr = i_vbak-posnr
      OR posnr = c_posnr_hd )
      AND parvw IN lir_parvw.
    IF  sy-subrc EQ 0.
      i_vbpa_za[] = i_vbpa[].
*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      DELETE i_vbpa_za WHERE parvw NE p_parvw.
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      IF s_partne IS NOT INITIAL.
        DELETE i_vbpa_za WHERE kunnr NOT IN s_partne.
      ENDIF. " IF s_partne IS NOT INITIAL
      SORT i_vbpa BY vbeln posnr parvw.
    ENDIF. " IF sy-subrc EQ 0
    SORT i_vbpa BY vbeln posnr parvw.
    SORT i_vbpa_za BY vbeln posnr parvw.

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    DATA(li_vbpa) = i_vbpa.
    DELETE li_vbpa WHERE parvw NE lc_parvw_sh.
    IF li_vbpa IS NOT INITIAL.
*   Customer Master Sales Data (Number of FTE's)
      SELECT kunnr " Customer Number
             vkorg " Sales Organization
             vtweg " Distribution Channel
             spart " Division
             zzfte " Number of FTE’s
        FROM knvv  " Customer Master Sales Data
        INTO TABLE i_knvv
         FOR ALL ENTRIES IN li_vbpa
       WHERE kunnr EQ li_vbpa-kunnr
       ORDER BY PRIMARY KEY.
      IF sy-subrc NE 0.
        CLEAR: i_knvv.
      ENDIF. " IF sy-subrc NE 0

*   BP: ID Numbers
      SELECT partner  " Business Partner Number
             type     " Identification Type
             idnumber " Identification Number
        FROM but0id   " BP: ID Numbers
        INTO TABLE i_but0id
         FOR ALL ENTRIES IN li_vbpa
       WHERE partner EQ li_vbpa-kunnr
         AND type    EQ c_wntch_id
       ORDER BY PRIMARY KEY.
      IF sy-subrc NE 0.
        CLEAR: i_but0id.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF li_vbpa IS NOT INITIAL
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  ENDIF .   "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ADRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_adrc.

  DATA : li_vbpa TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0.

  li_vbpa[] = i_vbpa[].
  SORT li_vbpa BY adrnr.
  DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr .

  IF li_vbpa IS NOT INITIAL.
    SELECT addrnumber " Address number
           date_from  " Valid-from date - in current Release only 00010101 possible
           nation     " Version ID for International Addresses
*          Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
*          name1      " Name 1
           title      " Form-of-Address Key
           name1      " Name 1
           name2      " Name 2
           name3      " Name 3
           name4      " Name 4
*          End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
           deflt_comm " Default communication
*          Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
           city1      " City
           post_code1 " Postal Code
           country    " Country Key
*          End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*          Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
           region     " Region (State, Province, County)
*          End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
      FROM adrc " Addresses (Business Address Services)
      INTO TABLE i_adrc
      FOR ALL ENTRIES IN li_vbpa
      WHERE addrnumber  = li_vbpa-adrnr.
    IF  sy-subrc EQ 0.
      SORT i_adrc BY addrnumber.
    ENDIF. " IF sy-subrc EQ 0

*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    SELECT addrnumber " Address number
           persnumber " Person number
           date_from  " Valid-from date - in current Release only 00010101 possible
           consnumber " Sequence Number
           smtp_addr  " E-Mail Address
      FROM adr6       " E-Mail Addresses (Business Address Services)
      INTO TABLE i_adr6
      FOR ALL ENTRIES IN li_vbpa
      WHERE addrnumber  = li_vbpa-adrnr.
    IF  sy-subrc EQ 0.
      SORT i_adr6 BY addrnumber persnumber.
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
  ENDIF. " IF li_vbpa IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_default_values .

  FIELD-SYMBOLS :<lst_auart> TYPE fip_s_auart_range. " Range: Sales Document Type

  APPEND INITIAL LINE TO s_doctyp ASSIGNING <lst_auart>.
  <lst_auart>-sign =  c_sign_i.
  <lst_auart>-option = c_opti_eq.
  <lst_auart>-low    = 'ZSUB'.

  APPEND INITIAL LINE TO s_doctyp ASSIGNING <lst_auart>.
  <lst_auart>-sign =  c_sign_i.
  <lst_auart>-option = c_opti_eq.
  <lst_auart>-low    = 'ZREW'.

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  st_variant-report = sy-repid.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = abap_true
    CHANGING
      cs_variant = st_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    p_alv_vr = st_variant-variant.
  ENDIF. " IF sy-subrc = 0
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_final .
* work area declaration
  DATA: lst_final           TYPE ty_final,
*       Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        lst_final_cmps      TYPE ty_final,
*       End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        lst_vbak            TYPE ty_vbak,
        lst_vbkd            TYPE ty_vbkd,
        lst_mara            TYPE ty_mara,
        lst_zqtc_renwl_plan TYPE ty_zqtc_renwl_plan,
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*        lst_veda            TYPE ty_veda,
        lst_veda            TYPE ty_vbak,
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
        lst_zqtct_activity  TYPE ty_zqtct_activity,
        lst_vbpa            TYPE ty_vbpa,
        lst_adrc            TYPE ty_adrc,
        lst_tvm1            TYPE tvm1t,     " Material pricing group 1: Description
        lst_tvm2            TYPE tvm2t,     " Material Pricing Group 2: Description
        lst_tvm3            TYPE tvm3t,     " Material pricing group 3: Description
        lst_tvm4            TYPE tvm4t,     " Material pricing group 4: Description
        lst_tvm5            TYPE tvm5t,     " Material pricing group 5: Description
        lst_tvkgg           TYPE tvkggt,    " Texts for Customer Condition Groups (Customer Master)
        lst_jptmg0          TYPE ty_jptmg0,
        lst_tjpmedtpt       TYPE tjpmedtpt, " Text Table for Media Types
        lst_t176t           TYPE t176t,     " Sales Documents: Customer Order Types: Texts
        lst_t188t           TYPE t188t,     " Conditions: Groups for Customer Classes: Texts
        lst_tvkot           TYPE tvkot,     " Organizational Unit: Sales Organizations: Texts
        lst_tvkbt           TYPE tvkbt,     " Organizational Unit: Sales Offices: Texts
        lst_tsact           TYPE tsact,     " Communication Method Description (Business Address Services)
        lst_subs            TYPE dd07v,     " Generated Table for View
        lst_tvlst           TYPE tvlst,     " Deliveries: Blocking Reasons/Scope: Texts
        lst_tvfst           TYPE tvfst.     " Billing : Blocking Reason Texts
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  DATA: lst_t005t           TYPE t005t.     " Country Names
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  DATA:
    lv_ismnrinyear TYPE char10, " Issue Number (in Year Number)
    lv_ismcopynr   TYPE char10. " Copy Number of Media Issue
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  DATA: lv_name1_sh_dummy TYPE full_name.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

  CONSTANTS: lc_parvw_ag TYPE parvw VALUE 'AG', " Partner Function
             lc_parvw_we TYPE parvw VALUE 'WE', " Partner Function
*            Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
             lc_parvw_re TYPE parvw VALUE 'RE', " Partner Function
*            End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*            Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
             lc_parvw_fa TYPE parvw VALUE 'SP', " Partner Function (Forwarding Agent)
*            End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
             lc_posnr    TYPE posnr VALUE '000000', " Header line #
* BOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
             lc_complete TYPE wbsta VALUE 'C',
* EOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
*  Begin of ADD: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
             lc_000000   TYPE uepos VALUE '000000'.
*  End of ADD: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:

* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  IF i_t005t[] IS INITIAL.
    SELECT * FROM t005t INTO TABLE i_t005t
      WHERE spras = sy-langu.
    IF sy-subrc = 0.
      SORT i_t005t BY land1.
    ENDIF.
  ENDIF.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  IF cb_nocmp IS NOT INITIAL.
    SORT i_vbak BY vbeln ASCENDING posnr DESCENDING.
  ENDIF. " IF cb_nocmp IS NOT INITIAL
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   Begin of Comment: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
*   Begin of ADD:ED1K913372:PRB0047627:ARGADEELA:30-Aug-2021:
*      IF cb_nocmp IS NOT INITIAL AND s_matnum[] IS NOT INITIAL.
*        DELETE i_vbak WHERE uepos IS NOT INITIAL.
*      ENDIF.
*   End of ADD:ED1K913372:PRB0047627:ARGADEELA:30-Aug-2021:
*   End of Comment: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
* To populate Sales header Details
  LOOP AT i_vbak INTO lst_vbak.

    lst_final-vbeln = lst_vbak-vbeln.
*   Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
    lst_final-erdat = lst_vbak-erdat.         " Date on Which Record Was Created
*   End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
    lst_final-augru = lst_vbak-augru.
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473

* BOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
    READ TABLE i_tvaut INTO st_tvaut
    WITH KEY augru = lst_vbak-augru BINARY SEARCH.
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-augru st_tvaut-bezei
      INTO lst_final-bezei SEPARATED BY c_hyphn.
    ENDIF.
* EOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605

    lst_final-auart = lst_vbak-auart.
    lst_final-vkorg = lst_vbak-vkorg.
    IF NOT lst_final-vkorg IS INITIAL.
      READ TABLE i_tvkot INTO lst_tvkot WITH KEY vkorg = lst_final-vkorg
                                                 BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
      IF sy-subrc = 0.
        CONCATENATE lst_final-vkorg lst_tvkot-vtext INTO lst_final-vkorg SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-vkorg IS INITIAL
    lst_final-vkbur = lst_vbak-vkbur.
    IF NOT lst_final-vkbur IS INITIAL.
      READ TABLE i_tvkbt INTO lst_tvkbt WITH KEY vkbur = lst_final-vkbur
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
      IF sy-subrc = 0.
        CONCATENATE lst_final-vkbur lst_tvkbt-bezei INTO lst_final-vkbur SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-vkbur IS INITIAL
    lst_final-posnr = lst_vbak-posnr.
    lst_final-subtyp = lst_vbak-zzsubtyp.
    lst_final-zzsubtyp = lst_vbak-zzsubtyp.

    READ TABLE i_subs INTO lst_subs WITH KEY domvalue_l = lst_final-zzsubtyp.
    IF sy-subrc = 0.
      lst_final-zzsubtyp = lst_subs-ddtext.
    ENDIF. " IF sy-subrc = 0

    lst_final-netwr = lst_vbak-netwr.
    lst_final-waerk = lst_vbak-waerk.
    lst_final-zmeng = lst_vbak-zmeng.
    lst_final-zieme = lst_vbak-zieme.
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    lst_final-zzlicgrp = lst_vbak-zzlicgrp. " License Group
    lst_final-mwsbp = lst_vbak-mwsbp. " Tax amount in document currency
    lst_final-uepos = lst_vbak-uepos. " Higher-level item in bill of material structures
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

    READ TABLE i_tvm1 INTO lst_tvm1 WITH KEY mvgr1 = lst_vbak-mvgr1
                                             BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-mvgr1 lst_tvm1-bezei INTO lst_final-mvgr1 SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-mvgr1 = lst_vbak-mvgr1.
    ENDIF. " IF sy-subrc = 0
    READ TABLE i_tvm2 INTO lst_tvm2 WITH KEY mvgr2 = lst_vbak-mvgr2
                                             BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-mvgr2 lst_tvm2-bezei INTO lst_final-mvgr2 SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-mvgr2 = lst_vbak-mvgr2.
    ENDIF. " IF sy-subrc = 0
    READ TABLE i_tvm3 INTO lst_tvm3 WITH KEY mvgr3 = lst_vbak-mvgr3
                                             BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-mvgr3 lst_tvm3-bezei INTO lst_final-mvgr3 SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-mvgr3 = lst_vbak-mvgr3.
    ENDIF. " IF sy-subrc = 0
    READ TABLE i_tvm4 INTO lst_tvm4 WITH KEY mvgr4 = lst_vbak-mvgr4
                                              BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-mvgr4 lst_tvm4-bezei INTO lst_final-mvgr4 SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-mvgr4 = lst_vbak-mvgr4.
    ENDIF. " IF sy-subrc = 0
    READ TABLE i_tvm5 INTO lst_tvm5 WITH KEY mvgr5 = lst_vbak-mvgr5
                                              BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-mvgr5 lst_tvm5-bezei INTO lst_final-mvgr5 SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-mvgr5 = lst_vbak-mvgr5.
    ENDIF. " IF sy-subrc = 0

    lst_final-arktx = lst_vbak-arktx.
    READ TABLE i_tvlst INTO lst_tvlst WITH KEY lifsp = lst_vbak-lifsk
                                                BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-lifsk lst_tvlst-vtext INTO lst_final-lifsk SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-lifsk = lst_vbak-lifsk.
    ENDIF. " IF sy-subrc = 0
    READ TABLE i_tvfst INTO lst_tvfst WITH KEY faksp = lst_vbak-faksk
                                               BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
    IF sy-subrc = 0.
      CONCATENATE lst_vbak-faksk lst_tvfst-vtext INTO lst_final-faksk SEPARATED BY c_hyphn.
    ELSE. " ELSE -> IF sy-subrc = 0
      lst_final-faksk = lst_vbak-faksk.
    ENDIF. " IF sy-subrc = 0

* To populate customer information.
    CLEAR lst_vbkd.
    READ TABLE i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbak-vbeln
                                             posnr = lst_vbak-posnr
                                             BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lst_final-bstkd = lst_vbkd-bstkd.
      lst_final-bsark = lst_vbkd-bsark.
      IF NOT lst_final-bsark IS INITIAL.
        READ TABLE i_t176t INTO lst_t176t WITH KEY bsark = lst_final-bsark
                                                    BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*        IF sy-subrc = 0 .
        IF sy-subrc = 0 AND lst_t176t-vtext IS NOT INITIAL.
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
          CONCATENATE lst_final-bsark lst_t176t-vtext INTO lst_final-bsark SEPARATED BY c_hyphn.
        ENDIF. " IF sy-subrc = 0 AND lst_t176t-vtext IS NOT INITIAL
      ELSE. " ELSE -> IF NOT lst_final-bsark IS INITIAL
        READ TABLE i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbak-vbeln
                                                 posnr = lc_posnr
                                                 BINARY SEARCH.
        IF sy-subrc = 0.
          lst_final-bsark = lst_vbkd-bsark.
          READ TABLE i_t176t INTO lst_t176t WITH KEY bsark = lst_final-bsark
                                                      BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*        IF sy-subrc = 0 .
          IF sy-subrc = 0 AND lst_t176t-vtext IS NOT INITIAL.
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
            CONCATENATE lst_final-bsark lst_t176t-vtext INTO lst_final-bsark SEPARATED BY c_hyphn.
          ENDIF. " IF sy-subrc = 0 AND lst_t176t-vtext IS NOT INITIAL
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF NOT lst_final-bsark IS INITIAL
      lst_final-konda = lst_vbkd-konda.
      IF NOT lst_final-konda IS INITIAL.
        READ TABLE i_t188t INTO lst_t188t WITH KEY konda = lst_final-konda
                                                    BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
        IF sy-subrc = 0.
          CONCATENATE lst_final-konda lst_t188t-vtext INTO lst_final-konda SEPARATED BY c_hyphn.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF NOT lst_final-konda IS INITIAL
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      lst_final-kdgrp = lst_vbkd-kdgrp. " Customer group
      IF lst_final-kdgrp IS NOT INITIAL.
        READ TABLE i_t151t INTO DATA(lst_t151t) WITH KEY kdgrp = lst_final-kdgrp
                                                BINARY SEARCH.
        IF sy-subrc = 0.
          CONCATENATE lst_final-kdgrp lst_t151t-ktext INTO lst_final-kdgrp SEPARATED BY c_hyphn.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF lst_final-kdgrp IS NOT INITIAL
      lst_final-pltyp = lst_vbkd-pltyp. " Price list type
      IF lst_final-pltyp IS NOT INITIAL.
        READ TABLE i_t189t INTO DATA(lst_t189t) WITH KEY pltyp = lst_final-pltyp
                                                BINARY SEARCH.
        IF sy-subrc = 0.
          CONCATENATE lst_final-pltyp lst_t189t-ptext INTO lst_final-pltyp SEPARATED BY c_hyphn.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF lst_final-pltyp IS NOT INITIAL
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      lst_final-ihrez = lst_vbkd-ihrez.
      lst_final-kdkg1 = lst_vbkd-kdkg1.
      lst_final-kdkg2 = lst_vbkd-kdkg2.
      lst_final-kdkg3 = lst_vbkd-kdkg3.
      lst_final-kdkg4 = lst_vbkd-kdkg4.
      lst_final-kdkg5 = lst_vbkd-kdkg5.
*     Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
      lst_final-ihrez_e = lst_vbkd-ihrez_e.
*     End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
    ENDIF. " IF sy-subrc IS INITIAL
    READ TABLE i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbak-vbeln
                                             posnr = c_posnr_hd
                                               BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      IF lst_final-bstkd  IS INITIAL.
        lst_final-bstkd = lst_vbkd-bstkd.
      ENDIF. " IF lst_final-bstkd IS INITIAL
      IF lst_final-bsark IS INITIAL.
        lst_final-bsark = lst_vbkd-bsark.
      ENDIF. " IF lst_final-bsark IS INITIAL
      IF lst_final-konda IS INITIAL.
        lst_final-konda = lst_vbkd-konda.
      ENDIF. " IF lst_final-konda IS INITIAL
      IF lst_final-ihrez IS INITIAL.
        lst_final-ihrez = lst_vbkd-ihrez.
      ENDIF. " IF lst_final-ihrez IS INITIAL
      IF lst_final-kdkg1 IS INITIAL.
        lst_final-kdkg1 = lst_vbkd-kdkg1.
      ENDIF. " IF lst_final-kdkg1 IS INITIAL
      IF lst_final-kdkg2 IS INITIAL.
        lst_final-kdkg2 = lst_vbkd-kdkg2.
      ENDIF. " IF lst_final-kdkg2 IS INITIAL
      IF lst_final-kdkg3 IS INITIAL.
        lst_final-kdkg3 = lst_vbkd-kdkg3.
      ENDIF. " IF lst_final-kdkg3 IS INITIAL
      IF lst_final-kdkg4 IS INITIAL.
        lst_final-kdkg4 = lst_vbkd-kdkg4.
      ENDIF. " IF lst_final-kdkg4 IS INITIAL
      IF lst_final-kdkg5 IS INITIAL.
        lst_final-kdkg5 = lst_vbkd-kdkg5.
      ENDIF. " IF lst_final-kdkg5 IS INITIAL

    ENDIF. " IF sy-subrc IS INITIAL

    IF NOT lst_final-kdkg1 IS INITIAL.
      READ TABLE i_tvkgg INTO lst_tvkgg WITH KEY kdkgr = lst_final-kdkg1
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
      IF sy-subrc = 0.
        CONCATENATE lst_final-kdkg1 lst_tvkgg-vtext INTO lst_final-kdkg1 SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-kdkg1 IS INITIAL
    IF NOT lst_final-kdkg2 IS INITIAL.
      READ TABLE i_tvkgg INTO lst_tvkgg WITH KEY kdkgr = lst_final-kdkg2
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
      IF sy-subrc = 0.
        CONCATENATE lst_final-kdkg2 lst_tvkgg-vtext INTO lst_final-kdkg2 SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-kdkg2 IS INITIAL
    IF NOT lst_final-kdkg3 IS INITIAL.
      READ TABLE i_tvkgg INTO lst_tvkgg WITH KEY kdkgr = lst_final-kdkg3
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
      IF sy-subrc = 0.
        CONCATENATE lst_final-kdkg3 lst_tvkgg-vtext INTO lst_final-kdkg3 SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-kdkg3 IS INITIAL
    IF NOT lst_final-kdkg4 IS INITIAL.
      READ TABLE i_tvkgg INTO lst_tvkgg WITH KEY kdkgr = lst_final-kdkg4
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
      IF sy-subrc = 0.
        CONCATENATE lst_final-kdkg4 lst_tvkgg-vtext INTO lst_final-kdkg4 SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-kdkg4 IS INITIAL
    IF NOT lst_final-kdkg5 IS INITIAL.
      READ TABLE i_tvkgg INTO lst_tvkgg WITH KEY kdkgr = lst_final-kdkg5
                                                  BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
      IF sy-subrc = 0.
        CONCATENATE lst_final-kdkg5 lst_tvkgg-vtext INTO lst_final-kdkg5 SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT lst_final-kdkg5 IS INITIAL

* BOC by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
*    IF lst_final-bstkd  IS INITIAL.
*      CONTINUE.
*    ENDIF. " IF lst_final-bstkd IS INITIAL
* EOC by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671

*To populate material master information
    CLEAR lst_mara.
    READ TABLE i_mara INTO lst_mara WITH  KEY matnr = lst_vbak-matnr
                                                       BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lst_final-matnr = lst_mara-matnr.
      lst_final-ismmediatype = lst_mara-ismmediatype.
      IF NOT lst_final-ismmediatype IS INITIAL.
        READ TABLE i_tjpmedtpt INTO lst_tjpmedtpt WITH KEY ismmediatype = lst_final-ismmediatype
                                                            BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
        IF sy-subrc EQ 0.
          CONCATENATE lst_final-ismmediatype lst_tjpmedtpt-bezeichnung INTO lst_final-ismmediatype SEPARATED BY c_hyphn.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF NOT lst_final-ismmediatype IS INITIAL
      lst_final-ismtitle = lst_mara-ismtitle.
      lst_final-extwg = lst_mara-extwg.
    ENDIF. " IF sy-subrc IS INITIAL

*   Begin of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224
**To populate volume
*   CLEAR : lst_jptmg0.
*   READ TABLE i_jptmg0 INTO lst_jptmg0 WITH KEY med_prod = lst_final-matnr
*                                                ismyearnr = lst_vbak-erdat+0(4)
*                                                BINARY SEARCH. " PBANDLAPAL 14-Dec-2017
*   IF sy-subrc = 0.
*     lst_final-volume = lst_jptmg0-ismcopynr.
*   ENDIF. " IF sy-subrc = 0
*   End   of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224

* To populate Partner Parvw = AG
* Sold to party
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                              posnr = c_posnr_hd
                                              parvw = lc_parvw_ag
                                              BINARY SEARCH.
    IF  sy-subrc EQ 0.
      lst_final-kunnr_sp = lst_vbpa-kunnr.
      READ TABLE i_adrc  INTO lst_adrc WITH KEY addrnumber = lst_vbpa-adrnr
                                                BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
      IF  sy-subrc EQ 0.
        lst_final-name1_sp = lst_adrc-name1.
*       Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
        lst_final-land1_sp = lst_adrc-country. " Country Key
*       End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
        lst_final-commm = lst_adrc-deflt_comm.
        lst_final-deflt_comm = lst_adrc-deflt_comm.
        IF NOT lst_final-deflt_comm IS INITIAL.
          READ TABLE i_tsact INTO lst_tsact WITH KEY comm_type = lst_final-deflt_comm
                                                     BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
          IF sy-subrc = 0.
            CONCATENATE lst_final-deflt_comm lst_tsact-comm_text INTO lst_final-deflt_comm SEPARATED BY c_hyphn.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF NOT lst_final-deflt_comm IS INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
    CLEAR: lst_vbpa,
           lst_adrc.

*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   Parvw = RE
*   Bill-To Party
    CLEAR lst_vbpa.
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                              posnr = lst_vbak-posnr
                                              parvw = lc_parvw_re
                                              BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                                posnr = c_posnr_hd
                                                parvw = lc_parvw_re
                                                BINARY SEARCH.
    ENDIF. " IF sy-subrc NE 0
    IF sy-subrc EQ 0.
      lst_final-kunnr_bp = lst_vbpa-kunnr.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE i_adrc  INTO lst_adrc WITH KEY addrnumber = lst_vbpa-adrnr
                                              BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
    IF  sy-subrc EQ 0.
*     Populate Address Details
      PERFORM f_populate_addr_details USING    lst_vbpa-adrnr
                                      CHANGING lst_final-name1_bp
                                               lst_final-addr1_bp
                                               lst_final-addr2_bp
                                               lst_final-addr3_bp
                                               lst_final-addr4_bp.

      lst_final-city1_bp = lst_adrc-city1. " City (Bill-To Party)
      lst_final-pstlz_bp = lst_adrc-post_code1. " Postal Code (Bill-To Party)
      lst_final-land1_bp = lst_adrc-country. " Country (Bill-To Party)

      READ TABLE i_adr6 ASSIGNING FIELD-SYMBOL(<lst_adr6>)
           WITH KEY addrnumber = lst_vbpa-adrnr
                    persnumber = space
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-email_bp = <lst_adr6>-smtp_addr. " Email Address (Bill-To Party)
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224

*Parvw = WE
* ship to party
    CLEAR lst_vbpa.
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                              posnr = lst_vbak-posnr
                                              parvw = lc_parvw_we
                                              BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-kunnr_sh = lst_vbpa-kunnr.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                                posnr = c_posnr_hd
                                                parvw = lc_parvw_we
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-kunnr_sh = lst_vbpa-kunnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE i_adrc  INTO lst_adrc WITH KEY addrnumber = lst_vbpa-adrnr
                                              BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
    IF  sy-subrc EQ 0.
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
*     Populate Address Details
      PERFORM f_populate_addr_details USING    lst_vbpa-adrnr
                                      CHANGING lv_name1_sh_dummy
                                               lst_final-addr1_sh
                                               lst_final-addr2_sh
                                               lst_final-addr3_sh
                                               lst_final-addr4_sh.
*     Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
      lst_final-title_sh  = lst_adrc-title.
      lst_final-name1_sh  = lst_adrc-name1.
      lst_final-name2_sh  = lst_adrc-name2.
      lst_final-name3_sh  = lst_adrc-name3.
      lst_final-name4_sh  = lst_adrc-name4.
      lst_final-region_sh = lst_adrc-region.
*     End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
      lst_final-city1_sh = lst_adrc-city1. " City (Ship-To Party)
      lst_final-pstlz_sh = lst_adrc-post_code1. " Postal Code (Ship-To Party)
      lst_final-land1_sh = lst_adrc-country. " Country (Ship-To Party)

*     Get Country Description
      READ TABLE i_t005t INTO lst_t005t WITH KEY land1 = lst_final-land1_sh BINARY SEARCH.
      IF sy-subrc = 0.
        lst_final-landx_sh = lst_t005t-landx.
      ENDIF.
*     End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

      READ TABLE i_adr6 ASSIGNING <lst_adr6>
           WITH KEY addrnumber = lst_vbpa-adrnr
                    persnumber = space
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-email_sh = <lst_adr6>-smtp_addr. " Email Address (Ship-To Party)
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    ENDIF. " IF sy-subrc EQ 0
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   Number FTE's
    READ TABLE i_knvv ASSIGNING FIELD-SYMBOL(<lst_knvv>)
         WITH KEY kunnr = lst_final-kunnr_sh " Ship-To Party
                  vkorg = lst_vbak-vkorg     " Sales Org
                  vtweg = lst_vbak-vtweg     " Distribution Channel
                  spart = lst_vbak-spart     " Division
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-zzfte = <lst_knvv>-zzfte.
    ENDIF. " IF sy-subrc EQ 0
*   Common Customer ID
    READ TABLE i_but0id ASSIGNING FIELD-SYMBOL(<lst_but0id>)
         WITH KEY partner = lst_final-kunnr_sh " Ship-To Party
                  type    = c_wntch_id         " Identification Type (Wintouch ID)
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-cmn_cust_id = <lst_but0id>-idnumber.
    ENDIF. " IF sy-subrc EQ 0

*   SP - Forwarding Agent
    CLEAR lst_vbpa.
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                              posnr = lst_vbak-posnr
                                              parvw = lc_parvw_fa
                                              BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE i_vbpa INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                                posnr = c_posnr_hd
                                                parvw = lc_parvw_fa
                                                BINARY SEARCH.
    ENDIF. " IF sy-subrc NE 0
    IF sy-subrc EQ 0.
      lst_final-frwd_agnt = lst_vbpa-lifnr.
    ENDIF. " IF sy-subrc EQ 0

    CLEAR lst_adrc.
    READ TABLE i_adrc  INTO lst_adrc WITH KEY addrnumber = lst_vbpa-adrnr
                                              BINARY SEARCH.
    IF  sy-subrc EQ 0.
*     Populate Address Details
      PERFORM f_populate_addr_details USING    lst_vbpa-adrnr
                                      CHANGING lst_final-name1_fa
                                               lst_final-addr1_fa
                                               lst_final-addr2_fa
                                               lst_final-addr3_fa
                                               lst_final-addr4_fa.
      lst_final-city1_fa = lst_adrc-city1. " City (Forwarding Agent)
      lst_final-pstlz_fa = lst_adrc-post_code1. " Postal Code (Forwarding Agent)
      lst_final-land1_fa = lst_adrc-country. " Country (Forwarding Agent)
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

    CLEAR: lst_vbpa,
           lst_adrc.

*Parvw = p_parfun
    IF NOT p_parvw IS INITIAL.
* Society related information
      READ TABLE i_vbpa_za INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                                posnr = lst_vbak-posnr
                                                parvw = p_parvw
                                                BINARY SEARCH.
      IF  sy-subrc EQ 0.
        lst_final-kunnr = lst_vbpa-kunnr.
        lst_final-parvw = p_parvw.
      ELSE. " ELSE -> IF sy-subrc EQ 0
        READ TABLE i_vbpa_za INTO lst_vbpa WITH KEY  vbeln = lst_vbak-vbeln
                                                   posnr = c_posnr_hd
                                                   parvw = p_parvw
                                                   BINARY SEARCH.
        IF  sy-subrc EQ 0.
          lst_final-kunnr = lst_vbpa-kunnr.
          lst_final-parvw = p_parvw.
        ELSE. " ELSE -> IF sy-subrc EQ 0
*         Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
          IF s_partne IS NOT INITIAL.
            CLEAR lst_final.
            CONTINUE.
          ENDIF. " IF s_partne IS NOT INITIAL
*         End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*         Begin of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
*         CONTINUE.
*         End   of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0

*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      IF lst_final-kunnr IS NOT INITIAL.
        READ TABLE i_soc_acrnym ASSIGNING FIELD-SYMBOL(<lst_soc_acrnym>)
             WITH KEY society = lst_final-kunnr
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_final-soc_acrnym = <lst_soc_acrnym>-society_acrnym.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_final-kunnr IS NOT INITIAL
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    ENDIF. " IF NOT p_parvw IS INITIAL


    READ TABLE i_adrc  INTO lst_adrc WITH KEY addrnumber = lst_vbpa-adrnr
                                              BINARY SEARCH. " PBANDLAPAL 14-Dec-2017.
    IF  sy-subrc EQ 0.
      lst_final-name1 = lst_adrc-name1.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR: lst_vbpa,
           lst_adrc.

* To populate contract data
    CLEAR lst_veda.
    READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbak-vbeln
                                              vposn = lst_vbak-posnr
                                              BINARY SEARCH.
    IF  sy-subrc IS NOT INITIAL.
      READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbak-vbeln
                                                vposn = c_posnr_hd
                                                BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
*       Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        CLEAR lst_final.
*       End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
        CONTINUE.
      ENDIF. " IF sy-subrc IS NOT INITIAL
    ENDIF. " IF sy-subrc IS NOT INITIAL
    lst_final-vbegdat = lst_veda-vbegdat.
    lst_final-venddat = lst_veda-venddat.
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    lst_final-rep_year  = lst_veda-vbegdat(4). " Reporting Year
    lst_final-canc_resn = lst_veda-vkuegru. " Reason for Cancellation of Contract
    IF lst_final-canc_resn IS NOT INITIAL.
      READ TABLE i_tvkgt INTO DATA(lst_tvkgt) WITH KEY kuegru = lst_final-canc_resn
                                              BINARY SEARCH.
      IF sy-subrc = 0.
        CONCATENATE lst_final-canc_resn lst_tvkgt-bezei INTO lst_final-canc_resn SEPARATED BY c_hyphn.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF lst_final-canc_resn IS NOT INITIAL
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   To populate volume
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    READ TABLE i_jksesched TRANSPORTING NO FIELDS
         WITH KEY vbeln = lst_final-vbeln
                  posnr = lst_final-posnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_jksesched) = sy-tabix.
      LOOP AT i_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>) FROM lv_tabix_jksesched.
        IF <lst_jksesched>-vbeln <> lst_final-vbeln OR
           <lst_jksesched>-posnr <> lst_final-posnr .
          EXIT.
        ENDIF. " IF <lst_jksesched>-vbeln <> lst_final-vbeln OR
        DATA(lst_jksesched) = <lst_jksesched>.

        IF lst_final-volume    IS INITIAL OR
           lst_final-volume_yr IS INITIAL.
          lst_final-volume    = <lst_jksesched>-ismcopynr.
          lst_final-volume_yr = <lst_jksesched>-ismyearnr. " Material volume year
        ENDIF. " IF lst_final-volume IS INITIAL OR
        IF lst_final-start_issue IS INITIAL.
*         Remove Leading Zeros [Copy Number of Media Issue]
          CLEAR: lv_ismcopynr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <lst_jksesched>-ismcopynr
            IMPORTING
              output = lv_ismcopynr.
*         Remove Leading Zeros [Issue Number (in Year Number)]
          CLEAR: lv_ismnrinyear.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <lst_jksesched>-ismnrinyear
            IMPORTING
              output = lv_ismnrinyear.
          CONCATENATE 'v_'(i01) lv_ismcopynr      INTO lv_ismcopynr.
          CONCATENATE 'i_'(i02) lv_ismnrinyear    INTO lv_ismnrinyear.
          CONCATENATE lv_ismcopynr lv_ismnrinyear INTO lst_final-start_issue
            SEPARATED BY space.
*--*BOC OTCM-25936 Additional fields PRABHU 11/26/2020
*--* New Field Media Start Issue
          lst_final-media_start_issue = <lst_jksesched>-issue.
        ENDIF. " IF lst_final-start_issue IS INITIAL
*        IF <lst_jksesched>-xorder_created   IS NOT INITIAL OR
*           ( <lst_jksesched>-ismarrivaldateac IS NOT INITIAL AND
*             <lst_jksesched>-ismarrivaldateac NE space ).
*          lst_final-issues_sent = lst_final-issues_sent + 1. " Issues - Sent
*        ELSE. " ELSE -> IF <lst_jksesched>-xorder_created IS NOT INITIAL OR
*          lst_final-issues_due  = lst_final-issues_due  + 1. " Issues - Due
*        ENDIF. " IF <lst_jksesched>-xorder_created IS NOT INITIAL OR
*--*Add "Issues Sent" Count for Print Media
        IF <lst_jksesched>-xorder_created   IS NOT INITIAL.
*--*If it is Print Media, check delivery is complete PGI or not
          READ TABLE i_jkseflow INTO DATA(lst_jkseflow) WITH KEY contract_vbeln = <lst_jksesched>-vbeln
                                                                 contract_posnr = <lst_jksesched>-posnr
                                                                 issue          = <lst_jksesched>-issue
                                                                 BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE i_lips INTO DATA(lst_lips) WITH KEY vgbel = lst_jkseflow-vbelnorder
                                                           vgpos = lst_jkseflow-posnrorder
                                                           BINARY SEARCH.
* BOC by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
*            IF sy-subrc EQ 0
            IF sy-subrc EQ 0 AND lst_lips-wbsta = lc_complete.
* EOC by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
              lst_final-issues_sent = lst_final-issues_sent + 1. " Issues - Sent
* BOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
            ELSEIF sy-subrc EQ 0 AND lst_lips-wbsta NE lc_complete.
              lst_final-issues_due = lst_final-issues_due + 1. " Issues - Sent
            ELSEIF sy-subrc NE 0.
              READ TABLE i_mseg INTO DATA(lst_mseg) WITH KEY kdauf = lst_jkseflow-vbelnorder
                                                           kdpos = lst_jkseflow-posnrorder
                                                           BINARY SEARCH.
              IF sy-subrc EQ 0.
                lst_final-issues_sent = lst_final-issues_sent + 1. " Issues - Sent
              ELSE.
                lst_final-issues_due = lst_final-issues_due + 1. " Issues - Sent
              ENDIF.
            ENDIF.
* EOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
          ENDIF.
*--*Add "Issue Sent" Count For Digital  Media
        ELSEIF <lst_jksesched>-ismarrivaldateac IS NOT INITIAL AND
               <lst_jksesched>-ismarrivaldateac NE space.
          lst_final-issues_sent = lst_final-issues_sent + 1. " Issues - Sent
        ELSE. " ELSE -> IF <lst_jksesched>-xorder_created IS NOT INITIAL
*--* Add Issue due count
          lst_final-issues_due  = lst_final-issues_due  + 1. " Issues - Due
        ENDIF.
*--*New Field Media Last Issue
        AT END OF posnr.
          lst_final-media_last_issue = <lst_jksesched>-issue.
        ENDAT.
*--*EOC OTCM-25936 Additional fields PRABHU 11/26/2020
      ENDLOOP. " LOOP AT i_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>) FROM lv_tabix_jksesched
    ENDIF. " IF sy-subrc EQ 0
    IF lst_jksesched IS NOT INITIAL.
*     Remove Leading Zeros [Copy Number of Media Issue]
      CLEAR: lv_ismcopynr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_jksesched-ismcopynr
        IMPORTING
          output = lv_ismcopynr.
*     Remove Leading Zeros [Issue Number (in Year Number)]
      CLEAR: lv_ismnrinyear.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_jksesched-ismnrinyear
        IMPORTING
          output = lv_ismnrinyear.
      CONCATENATE 'v_'(i01) lv_ismcopynr      INTO lv_ismcopynr.
      CONCATENATE 'i_'(i02) lv_ismnrinyear    INTO lv_ismnrinyear.
      CONCATENATE lv_ismcopynr lv_ismnrinyear INTO lst_final-last_issue
        SEPARATED BY space.
    ENDIF. " IF lst_jksesched IS NOT INITIAL
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   Begin of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   CLEAR : lst_jptmg0.
*   READ TABLE i_jptmg0 TRANSPORTING NO FIELDS
*        WITH KEY med_prod = lst_final-matnr
*        BINARY SEARCH.
*   IF sy-subrc = 0.
*     DATA(lv_tabix_jptmg0) = sy-tabix.
*     LOOP AT i_jptmg0 INTO lst_jptmg0 FROM lv_tabix_jptmg0.
*       IF lst_jptmg0-med_prod <> lst_final-matnr.
*         EXIT.
*       ENDIF. " IF lst_jptmg0-med_prod <> lst_final-matnr
*       IF lst_jptmg0-ismpubldate BETWEEN lst_final-vbegdat AND lst_final-venddat.
*         lst_final-volume    = lst_jptmg0-ismcopynr.
*         lst_final-volume_yr = lst_jptmg0-ismyearnr. " Material volume year
*         EXIT.
*       ENDIF. " IF lst_jptmg0-ismpubldate BETWEEN lst_final-vbegdat AND lst_final-venddat
*     ENDLOOP. " LOOP AT i_jptmg0 INTO lst_jptmg0 FROM lv_tabix_jptmg0
*   ENDIF. " IF sy-subrc = 0
*   End   of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419

*   Populate Payment Date
    READ TABLE i_pay_inv ASSIGNING FIELD-SYMBOL(<lst_pay_inv>)
         WITH KEY vbelv = lst_vbak-vbeln
                  posnv = lst_vbak-posnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_final-pay_date   = <lst_pay_inv>-augdt. " Payment date (through Invoice)
      lst_final-bill_doc   = <lst_pay_inv>-vbeln. " Billing Document
    ENDIF. " IF sy-subrc EQ 0

    IF lst_vbak-vgbel IS NOT INITIAL.
      READ TABLE i_pay_quote ASSIGNING FIELD-SYMBOL(<lst_pay_quote>)
           WITH KEY xref1 = lst_vbak-vgbel
                    bukrs = lst_vbak-bukrs_vf
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-pay_date   = <lst_pay_quote>-budat. " Payment date (through Quotation)
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbak-vgbel IS NOT INITIAL

    READ TABLE i_pay_cards TRANSPORTING NO FIELDS
         WITH KEY vbeln = lst_final-vbeln
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_cc) = sy-tabix.
      LOOP AT i_pay_cards ASSIGNING FIELD-SYMBOL(<lst_pay_card>) FROM lv_tabix_cc.
        IF <lst_pay_card>-vbeln <> lst_final-vbeln.
          EXIT.
        ENDIF. " IF <lst_pay_card>-vbeln <> lst_final-vbeln
        CONCATENATE <lst_pay_card>-ccins <lst_pay_card>-vtext INTO lst_final-cc_type SEPARATED BY c_hyphn. " Credit Card Type
        lst_final-cc_pay_amt = <lst_pay_card>-autwr + lst_final-cc_pay_amt. " Payment amount (By credit card)
        lst_final-pay_date   = <lst_pay_card>-audat. " Payment date (By credit card)
      ENDLOOP. " LOOP AT i_pay_cards ASSIGNING FIELD-SYMBOL(<lst_pay_card>) FROM lv_tabix_cc
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    IF lst_final-pay_date IS NOT INITIAL.
      lst_final-pay_status = 'PAID'(p01).
    ELSE. " ELSE -> IF lst_final-pay_date IS NOT INITIAL
      lst_final-pay_status = 'UNPAID'(p02).
    ENDIF. " IF lst_final-pay_date IS NOT INITIAL
    IF lst_final-canc_resn IS NOT INITIAL.
      lst_final-pay_status = 'CANCELLED'(p03).
    ENDIF. " IF lst_final-canc_resn IS NOT INITIAL

    IF cb_nocmp IS NOT INITIAL.
      IF lst_final-uepos IS NOT INITIAL. "AND
*   Begin of Change ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
**   Begin of ADD:ED1K913372:PRB0047627:ARGADEELA:30-Aug-2021:
*        s_matnum[] IS INITIAL.
**   End of ADD:ED1K913372:PRB0047627:ARGADEELA:30-Aug-2021:
* Check the BOM header for this line item.If the BOM header is not available skip the record.
      READ TABLE i_vbak into DATA(lst_vbak_bom_header) WITH KEY vbeln = lst_final-vbeln
                                                                uepos = lc_000000.
      IF sy-subrc NE 0.
        CLEAR: lst_final,
               lst_jksesched.
        CONTINUE.
      ENDIF.
        lst_final_cmps-vbeln       = lst_final-vbeln.
*   End of Chnage: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
        lst_final_cmps-uepos       = lst_final-uepos.
        lst_final_cmps-netwr       = lst_final_cmps-netwr + lst_final-netwr.
        lst_final_cmps-mwsbp       = lst_final_cmps-mwsbp + lst_final-mwsbp.
        lst_final_cmps-issues_sent = lst_final-issues_sent.
        lst_final_cmps-issues_due  = lst_final-issues_due.
        lst_final_cmps-start_issue = lst_final-start_issue.
        lst_final_cmps-last_issue  = lst_final-last_issue.
        lst_final_cmps-volume      = lst_final-volume.
        lst_final_cmps-volume_yr   = lst_final-volume_yr.
        CLEAR: lst_final,
               lst_jksesched.
        CONTINUE.
      ELSE. " ELSE -> IF lst_final-uepos IS NOT INITIAL
        IF lst_final_cmps IS NOT INITIAL AND
           lst_final_cmps-uepos EQ lst_final-posnr AND
*   Begin of Chnage: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
           lst_final_cmps-vbeln EQ lst_final-vbeln.
*   End of Chnage: ED1K913882:INC0414259:ARGADEELA:09-Dec-2021:
          lst_final-netwr       = lst_final_cmps-netwr.
          lst_final-mwsbp       = lst_final_cmps-mwsbp.
          lst_final-issues_sent = lst_final_cmps-issues_sent.
          lst_final-issues_due  = lst_final_cmps-issues_due.
          lst_final-start_issue = lst_final_cmps-start_issue.
          lst_final-last_issue  = lst_final_cmps-last_issue.
          lst_final-volume      = lst_final_cmps-volume.
          lst_final-volume_yr   = lst_final_cmps-volume_yr.
        ENDIF. " IF lst_final_cmps IS NOT INITIAL AND
      ENDIF. " IF lst_final-uepos IS NOT INITIAL
    ENDIF. " IF cb_nocmp IS NOT INITIAL
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*To populate renewal information

* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
    PERFORM f_get_title_text  USING sy-langu
                                    lst_final-title_sh
                           CHANGING lst_final-title_txt_sh.
    PERFORM f_get_region_text USING lst_final-land1_sh
                                    lst_final-region_sh
                                    sy-langu
                           CHANGING lst_final-region_txt_sh.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

    READ TABLE i_zqtc_renwl_plan TRANSPORTING NO FIELDS WITH KEY   vbeln = lst_vbak-vbeln
                                                                   posnr = lst_vbak-posnr
                                                                   BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      DATA(lv_index) = sy-tabix.

      LOOP AT  i_zqtc_renwl_plan INTO lst_zqtc_renwl_plan FROM lv_index .
        IF lst_zqtc_renwl_plan-vbeln <> lst_vbak-vbeln
        OR lst_zqtc_renwl_plan-posnr <> lst_vbak-posnr.
          EXIT.
        ENDIF. " IF lst_zqtc_renwl_plan-vbeln <> lst_vbak-vbeln

        lst_final-activity  = lst_zqtc_renwl_plan-activity.
        lst_final-eadat     = lst_zqtc_renwl_plan-eadat.
        lst_final-act_statu = lst_zqtc_renwl_plan-act_statu.
        lst_final-ren_sstatus = lst_zqtc_renwl_plan-ren_sstatus.
        IF lst_final-ren_sstatus EQ abap_true.
          lst_final-ren_sstatus = 'Renewed'.
        ELSEIF lst_final-ren_sstatus EQ 'C'.
          lst_final-ren_sstatus = 'Renewed'.
        ELSE. " ELSE -> IF lst_final-ren_sstatus EQ abap_true
          lst_final-ren_sstatus = 'Not Renewed'.
        ENDIF. " IF lst_final-ren_sstatus EQ abap_true
*To populate  description(activity-d)
        READ TABLE i_zqtct_activity INTO lst_zqtct_activity WITH KEY activity = lst_zqtc_renwl_plan-activity
                                                                      BINARY SEARCH.
        IF  sy-subrc IS INITIAL.
          lst_final-activity_d = lst_zqtct_activity-activity_d.
        ENDIF. " IF sy-subrc IS INITIAL

        APPEND lst_final TO i_final.
        CLEAR: lst_zqtct_activity,
               lst_final-activity,
               lst_final-eadat ,
               lst_final-act_statu,
               lst_final-ren_sstatus,
               lst_final-activity_d.
      ENDLOOP. " LOOP AT i_zqtc_renwl_plan INTO lst_zqtc_renwl_plan FROM lv_index
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
      APPEND lst_final TO i_final.
    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR lst_final.
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    CLEAR lst_jksesched.
    CLEAR lst_final_cmps.
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  ENDLOOP. " LOOP AT i_vbak INTO lst_vbak

* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
  IF s_land1[] IS NOT INITIAL. " Sold-To Party's Country
    DELETE i_final WHERE land1_sp NOT IN s_land1.
  ENDIF. " IF s_land1[] IS NOT INITIAL
  IF s_betdt[] IS NOT INITIAL. " Payment Date
    DELETE i_final WHERE pay_date NOT IN s_betdt.
  ENDIF. " IF s_betdt[] IS NOT INITIAL
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  IF s_shpto[] IS NOT INITIAL. " Ship-To Party
    DELETE i_final WHERE kunnr_sh NOT IN s_shpto.
  ENDIF. " IF s_shpto[] IS NOT INITIAL
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

*-----Delete records based on subs type and communication method
  IF NOT i_final IS INITIAL.
    IF NOT s_subs IS INITIAL.
      DELETE i_final WHERE subtyp NOT IN s_subs.
    ENDIF. " IF NOT s_subs IS INITIAL
*Begin of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
*    IF NOT s_comm IS INITIAL.
*      DELETE i_final WHERE commm NOT IN s_comm.
*    ENDIF.
*End of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
*   Begin of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   SORT i_final BY vbeln posnr.
*   End   of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
*   Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    SORT i_final BY vbeln posnr uepos.
*   End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  ELSE. " ELSE -> IF NOT i_final IS INITIAL
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
    LEAVE TO LIST-PROCESSING.
  ENDIF. " IF NOT i_final IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_alv_output .
  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',
              lc_usr_command TYPE slis_formname  VALUE 'F_SET_USR_COMND'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(001).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
*  PERFORM f_popul_field_cat.
  PERFORM f_popul_field_cat_new.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_top_of_page  = lc_top_of_page
      i_callback_user_command = lc_usr_command
      is_layout               = lst_layout
      it_fieldcat             = i_fcat
      i_save                  = abap_true
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      is_variant              = st_variant
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*     Begin of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
*     i_default               = space
*     End   of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
    TABLES
      t_outtab                = i_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
*FORM f_set_pf_status USING li_extab TYPE slis_t_extab. "#EC CALLED
*
*  DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
*  SET PF-STATUS 'ZSUBSCR_RENEWAL'.
*
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations

  DATA: li_header     TYPE slis_t_listheader,
        lst_header    TYPE slis_listheader,
        lv_line       TYPE slis_entry,
        lv_line_count TYPE i,      " Lines of type Integers
        lv_linesc     TYPE char10. " Linesc(10) of type Character

* Constant
  CONSTANTS : lc_typ_h TYPE char1 VALUE 'H', " Typ_h of type CHAR1
              lc_typ_s TYPE char1 VALUE 'S', " Typ_s of type CHAR1
              lc_typ_a TYPE char1 VALUE 'A'. " Typ_a of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Renewal Subscription'(006).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

* DATE
  lst_header-typ = lc_typ_s . "'S'
  lst_header-key = 'Date: '(004).
  WRITE sy-datum TO lst_header-info.
  APPEND lst_header TO li_header.
  CLEAR: lst_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE i_final LINES lv_line_count.
  lv_linesc = lv_line_count.
  CONCATENATE 'Total No. of Records Selected: '(005) lv_linesc
  INTO lv_line SEPARATED BY space.
  lst_header-typ = lc_typ_a . "'A'
  lst_header-info = lv_line.
  APPEND lst_header TO li_header.
  CLEAR: lst_header, lv_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat .
  PERFORM f_append_field_cat USING:
  '1' 'I_FINAL'(T01)  'VBELN' 'Sales Document'(D01)                 'VBAK' 'VBELN',
  '2' 'I_FINAL'(T01)  'POSNR' 'Sales Document Item'(D02)            'VBAP' 'POSNR',
  '3' 'I_FINAL'(T01)  'AUART' 'Sales Document Type'(D03)            'VBAK' 'AUART',
  '4' 'I_FINAL'(t01)  'VKORG' 'Sales Organisation'(D04)             'RJMG02' 'TEXT213',
  '5' 'I_FINAL'(T01)  'VKBUR' 'Sales Office'(D05)                   'RJMG02' 'TEXT213',
  '6' 'I_FINAL'(T01)  'ZZSUBTYP' 'Subscription Type'(D06)           'BC325V10' 'NAME',
  '7' 'I_FINAL'(T01)  'BSTKD' 'Customer Purchase Order Number'(D07) 'VBKD' 'BSTKD',
  '8' 'I_FINAL'(T01)  'BSARK' 'Customer Purchase Order Type'(D08)   'VBKD' 'BSARK',
  '9' 'I_FINAL'(T01)  'KONDA' 'Price Group'(D09)                    'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '10' 'I_FINAL'(T01) 'IHREZ' 'Your Reference'(D10)                 'VBAK' 'IHREZ',
  '11' 'I_FINAL'(T01) 'MATNR' 'Material Number'(D11)                'VBAP' 'MATNR',
  '12' 'I_FINAL'(T01) 'ARKTX' 'Order item Description'(D38)         'VBAP' 'ARKTX',
  '13' 'I_FINAL'(T01) 'ISMMEDIATYPE' 'Media Type'(D12)              'T505P' 'LTEXT',
  '14' 'I_FINAL'(T01) 'EXTWG' 'External Material Group'(D14)        'MARA' 'EXTWG',
*Begin of Del-Anirban-07.25.2017-ED2K907461-Defect 3519
*  '15' 'I_FINAL'(T01) 'NETWR' 'Net Value'(D15)                      'VBAK' 'NETWR_AK',
*End of Del-Anirban-07.25.2017-ED2K907461-Defect 3519
*Begin of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
  '15' 'I_FINAL'(T01) 'NETWR' 'Net Value'(D15)                      'VBAK' 'NETWR',
*End of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
*Begin of Del-Anirban-07.25.2017-ED2K907461-Defect 3519
*  '16' 'I_FINAL'(T01) 'WAERK' 'SD Document Currency'(D16)           'VBAK' 'NETWR_AK',
*End of Del-Anirban-07.25.2017-ED2K907461-Defect 3519
*Begin of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
  '16' 'I_FINAL'(T01) 'WAERK' 'SD Document Currency'(D16)           'VBAK' 'WAERK',
*End of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
  '17' 'I_FINAL'(T01) 'ACTIVITY' 'Activity'(D17)                    'ZQTC_RENWL_PLAN' 'ZACTIVITY_SUB',
  '18' 'I_FINAL'(T01) 'EADAT' 'Activity Date'(D18)                  'ZQTC_RENWL_PLAN' 'EADAT',
  '19' 'I_FINAL'(T01) 'ACT_STATU' 'Ativity Status'(D19)             'ZQTC_RENWL_PLAN' 'ZACT_STATUS',
  '20' 'I_FINAL'(T01) 'REN_SSTATUS' 'Renewal Status'(D20)           'BC325V10' 'NAME',
  '21' 'I_FINAL'(T01) 'ACTIVITY_D' 'Description'(D21)               'ZQTCT_ACTIVITY' 'ACTIVITY_D',
  '22' 'I_FINAL'(T01) 'KUNNR_SP' 'Sold To Party'(D22)               'VBPA' 'KUNNR',
  '23' 'I_FINAL'(T01) 'NAME1_SP' 'Sold To Party Name'(D23)          'ADRC' 'NAME1',
* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
  '24' 'I_FINAL'(T01) 'LAND1_SP' 'Sold To Party Country'(D48)       'ADRC' 'COUNTRY',
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*Begin of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
*  '24' 'I_FINAL'(T01) 'DEFLT_COMM' 'Communication Method'(D45)      'CAM1_KEYW' 'MCOM',
*End of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
  '25' 'I_FINAL'(T01) 'KUNNR_SH' 'Ship To Party '(D24)              'VBPA' 'KUNNR',
  '26' 'I_FINAL'(T01) 'NAME1_SH' 'Ship To Party Name'(D25)          'RC70D' 'FULL_NAME',
  '27' 'I_FINAL'(T01) 'KUNNR' 'Society Number'(D26)                 'VBPA' 'KUNNR',
  '28' 'I_FINAL'(T01) 'PARVW' 'Partner Function'(D27)               'VBPA' 'PARVW',
  '29' 'I_FINAL'(T01) 'NAME1' 'Society Name'(D28)                   'ADRC' 'NAME1',
  '30' 'I_FINAL'(T01) 'VBEGDAT' 'Contract start Date'(D29)          'VEDA' 'VBEGDAT',
  '31' 'I_FINAL'(T01) 'VENDDAT' 'Contract End Date'(D30)            'VEDA' 'VENDDAT',
  '32' 'I_FINAL'(T01) 'ZMENG' 'Target quantity'(D31)                'VBAP' 'ZMENG',
  '33' 'I_FINAL'(T01) 'ZIEME' 'UoM'(D32)                            'VBAP' 'ZIEME',
  '34' 'I_FINAL'(T01) 'MVGR1' 'Material group 1'(D33)               'TBE24T' 'TXT50',
  '35' 'I_FINAL'(T01) 'MVGR2' 'Material group 2'(D34)               'TBE24T' 'TXT50',
  '36' 'I_FINAL'(T01) 'MVGR3' 'Material group 3'(D35)               'TBE24T' 'TXT50',
  '37' 'I_FINAL'(T01) 'MVGR4' 'Material group 4'(D36)               'TBE24T' 'TXT50',
  '38' 'I_FINAL'(T01) 'MVGR5' 'Material group 5'(D37)               'TBE24T' 'TXT50',
  '39' 'I_FINAL'(T01) 'KDKG1' 'Flag: New VS Renew'(D39)             'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '40' 'I_FINAL'(T01) 'KDKG2' 'Soc Rel Category'(D40)               'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '41' 'I_FINAL'(T01) 'KDKG3' 'Cust Cond Grp 3'(D41)                'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '42' 'I_FINAL'(T01) 'KDKG4' 'FOC Reason'(D42)                     'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '43' 'I_FINAL'(T01) 'KDKG5' 'Subscription Type'(D43)              'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '44' 'I_FINAL'(T01) 'VOLUME' 'Volume'(D44)                        'JPTMG0' 'ISMCOPYNR',
  '45' 'I_FINAL'(T01) 'LIFSK' 'Delivery Block'(D46)                 'RJMG02' 'TEXT213',
  '46' 'I_FINAL'(T01) 'FAKSK' 'Billing block'(D47)                  'RJMG02' 'TEXT213',
* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
  '47' 'I_FINAL'(T01) 'KUNNR_BP' 'Bill To Party'(D49)               'VBDKR' 'KUNRE',
  '48' 'I_FINAL'(T01) 'NAME1_BP' 'Bill To Party Name'(D50)          'RC70D' 'FULL_NAME',
  '49' 'I_FINAL'(T01) 'ADDR1_BP' 'Bill To Party Address-1'(D51)     'ADRS' 'LINE1',
  '50' 'I_FINAL'(T01) 'ADDR2_BP' 'Bill To Party Address-2'(D52)     'ADRS' 'LINE2',
  '51' 'I_FINAL'(T01) 'ADDR3_BP' 'Bill To Party Address-3'(D53)     'ADRS' 'LINE3',
  '52' 'I_FINAL'(T01) 'ADDR4_BP' 'Bill To Party Address-4'(D54)     'ADRS' 'LINE4',
  '53' 'I_FINAL'(T01) 'CITY1_BP' 'Bill To Party City'(D55)          'ADRS' 'ORT01',
  '54' 'I_FINAL'(T01) 'PSTLZ_BP' 'Bill To Party Postal Code'(D56)   'ADRS' 'PSTLZ',
  '55' 'I_FINAL'(T01) 'LAND1_BP' 'Bill To Party Cuntry'(D57)        'ADRS' 'LAND1',
  '56' 'I_FINAL'(T01) 'EMAIL_BP' 'Bill To Party Email ID'(D58)      'ADR6' 'SMTP_ADDR',
  '57' 'I_FINAL'(T01) 'ADDR1_SH' 'Ship To Party Address-1'(D59)     'ADRS' 'LINE1',
  '58' 'I_FINAL'(T01) 'ADDR2_SH' 'Ship To Party Address-2'(D60)     'ADRS' 'LINE2',
  '59' 'I_FINAL'(T01) 'ADDR3_SH' 'Ship To Party Address-3'(D61)     'ADRS' 'LINE3',
  '60' 'I_FINAL'(T01) 'ADDR4_SH' 'Ship To Party Address-4'(D62)     'ADRS' 'LINE4',
  '61' 'I_FINAL'(T01) 'CITY1_SH' 'Ship To Party City'(D63)          'ADRS' 'ORT01',
  '62' 'I_FINAL'(T01) 'PSTLZ_SH' 'Ship To Party Postal Code'(D64)   'ADRS' 'PSTLZ',
  '63' 'I_FINAL'(T01) 'LAND1_SH' 'Ship To Party Cuntry'(D65)        'ADRS' 'LAND1',
  '64' 'I_FINAL'(T01) 'EMAIL_SH' 'Ship To Party Email ID'(D66)      'ADR6' 'SMTP_ADDR',

  '65' 'I_FINAL'(T01) 'VOLUME_YR'  'Material Volume Year'(D67)      'MARA' 'ISMYEARNR',
  '66' 'I_FINAL'(T01) 'SOC_ACRNYM' 'Society Acronym'(D68)           'ZQTC_JGC_SOCIETY' 'SOCIETY_ACRNYM',
  '67' 'I_FINAL'(T01) 'CC_TYPE'    'Credit Card Type'(D69)          'TVCINT' 'TEXT',
  '68' 'I_FINAL'(T01) 'CC_PAY_AMT' 'Payment Amount (By CC)'(D70)    'FPLTC' 'AUTWR',
  '69' 'I_FINAL'(T01) 'PAY_DATE'   'Payment Date'(D71)              'P0063' 'BETDT',
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  '70' 'I_FINAL'(T01) 'PAY_STATUS'  'Payment Status'(D80)           'J_3R_CPS_PAYMENT_INFO' 'PAYMENT_STATUS',
  '71' 'I_FINAL'(T01) 'CMN_CUST_ID' 'Common Customer ID'(D81)       'BUT0ID' 'IDNUMBER',
  '72' 'I_FINAL'(T01) 'REP_YEAR'    'Reporting Year'(D84)           'FKKPDREP_ITEM' 'AJAHR',
  '73' 'I_FINAL'(T01) 'KDGRP'       'Customer Group'(D72)           'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '74' 'I_FINAL'(T01) 'PLTYP'       'Price list type'(D73)          'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '75' 'I_FINAL'(T01) 'ZZLICGRP'    'License Group'(D74)            'VBAK' 'ZZLICGRP',
  '76' 'I_FINAL'(T01) 'MWSBP'       'Tax Amount'(D75)               'VBAP' 'MWSBP',
  '77' 'I_FINAL'(T01) 'ZZFTE'       'No Of FTEs'(D76)               'KNVV' 'ZZFTE',
  '78' 'I_FINAL'(T01) 'CANC_RESN'   'Cancellation Reason'(D77)      'RFCU4' 'VTEXT',
  '79' 'I_FINAL'(T01) 'ISSUES_SENT' 'Issues Sent'(D78)              'RJVSD_SHP_ALV1' 'CNT_ISSUES',
  '80' 'I_FINAL'(T01) 'ISSUES_DUE'  'Issues Due'(D79)               'RJVSD_SHP_ALV1' 'CNT_ISSUES_OPEN',
  '81' 'I_FINAL'(T01) 'START_ISSUE' 'Start Issue'(D82)              'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '82' 'I_FINAL'(T01) 'LAST_ISSUE'  'Last Issue'(D83)               'ANTS_TRACE_DATA' 'COUNT_TYPE',
  '83' 'I_FINAL'(T01) 'UEPOS'       'Higher-level Item'(D85)        'VBAP' 'UEPOS',
  '84' 'I_FINAL'(T01) 'BILL_DOC'    'Billing Document'(D86)         'VBRK' 'VBELN',
  '85' 'I_FINAL'(T01) 'FRWD_AGNT'   'Forwarding Agent'(D87)         'LIPOSTV' 'SPDNR',
  '86' 'I_FINAL'(T01) 'NAME1_FA'    'Forwarding Agent Name'(D88)    'RC70D' 'FULL_NAME',
  '87' 'I_FINAL'(T01) 'ADDR1_FA'    'Frwd Agent Address-1'(D89)     'ADRS' 'LINE1',
  '88' 'I_FINAL'(T01) 'ADDR2_FA'    'Frwd Agent Address-2'(D90)     'ADRS' 'LINE2',
  '89' 'I_FINAL'(T01) 'ADDR3_FA'    'Frwd Agent Address-3'(D91)     'ADRS' 'LINE3',
  '90' 'I_FINAL'(T01) 'ADDR4_FA'    'Frwd Agent Address-4'(D92)     'ADRS' 'LINE4',
  '91' 'I_FINAL'(T01) 'CITY1_FA'    'Frwd Agent City'(D93)          'ADRS' 'ORT01',
  '92' 'I_FINAL'(T01) 'PSTLZ_FA'    'Frwd Agent Postal Code'(D94)   'ADRS' 'PSTLZ',
  '93' 'I_FINAL'(T01) 'LAND1_FA'    'Frwd Agent Cuntry'(D95)        'ADRS' 'LAND1'.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_APPEND_FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0963   text
*      -->P_0964   text
*      -->P_0965   text
*      -->P_0966   text
*----------------------------------------------------------------------*
FORM f_append_field_cat  USING    fp_col_pos
                                  fp_tabname
                                  fp_fieldname
                                  fp_reptext_ddic
                                  fp_ref_tabname
                                  fp_ref_fieldname.
  DATA: lst_fld TYPE slis_fieldcat_alv.

  CLEAR lst_fld.
  lst_fld-col_pos       = fp_col_pos.
  lst_fld-tabname       = fp_tabname.
  lst_fld-fieldname     = fp_fieldname.
  lst_fld-reptext_ddic  = fp_reptext_ddic.
  lst_fld-ref_tabname   = fp_ref_tabname.
  lst_fld-ref_fieldname = fp_ref_fieldname.

  CASE fp_col_pos.
    WHEN 4.
      lst_fld-seltext_l = 'Sales Organization'.
      lst_fld-seltext_m = 'Sales Org'.
      lst_fld-seltext_s = 'S. Org'.
    WHEN 5.
      lst_fld-seltext_l = 'Sales office'.
      lst_fld-seltext_m = 'Sales off'.
      lst_fld-seltext_s = 'S. Off'.
    WHEN 6.
      lst_fld-seltext_l = 'Subscription type'.
      lst_fld-seltext_m = 'Subs type'.
      lst_fld-seltext_s = 'Subs type'.
    WHEN 9.
      lst_fld-seltext_l = 'Price Group'.
      lst_fld-seltext_m = 'Price Group'.
      lst_fld-seltext_s = 'Prc Grp'.
    WHEN 13.
      lst_fld-seltext_l = 'Media Type'.
      lst_fld-seltext_m = 'Media Type'.
      lst_fld-seltext_s = 'Media Type'.
*Begin of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
    WHEN 15.
      lst_fld-cfieldname = 'WAERK'.
      lst_fld-ctabname   = fp_tabname.
*End of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
    WHEN 20.
      lst_fld-seltext_l = 'Renewal Status'.
      lst_fld-seltext_m = 'Renw Status'.
      lst_fld-seltext_s = 'Ren Status'.
    WHEN 22.
      lst_fld-seltext_l = 'Sold To Party'.
      lst_fld-seltext_m = 'Sold To Party'.
      lst_fld-seltext_s = 'SldToParty'.
    WHEN 23.
      lst_fld-seltext_l = 'Sold To Party Name'.
      lst_fld-seltext_m = 'Sold To Party Name'.
      lst_fld-seltext_s = 'SldTo Name'.
*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   WHEN 24.
*     lst_fld-seltext_l = 'Communication Method'.
*     lst_fld-seltext_m = 'Comm Method'.
*     lst_fld-seltext_s = 'Comm Meth'.
*   END   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    WHEN 25.
      lst_fld-seltext_l = 'Ship To Party'.
      lst_fld-seltext_m = 'Ship To Party'.
      lst_fld-seltext_s = 'ShpToParty'.
    WHEN 26.
      lst_fld-seltext_l = 'Ship To Party Name'.
      lst_fld-seltext_m = 'Ship To Party Name'.
      lst_fld-seltext_s = 'ShpTo Name'.
    WHEN 27.
      lst_fld-seltext_l = 'Society Number'.
      lst_fld-seltext_m = 'Society Number'.
      lst_fld-seltext_s = 'Soc Number'.
    WHEN 29.
      lst_fld-seltext_l = 'Society Name'.
      lst_fld-seltext_m = 'Society Name'.
      lst_fld-seltext_s = 'Soc Name'.
    WHEN 34.
      lst_fld-seltext_l = 'Material Group 1'.
      lst_fld-seltext_m = 'Material Group 1'.
      lst_fld-seltext_s = 'Mat Grp 1'.
    WHEN 35.
      lst_fld-seltext_l = 'Material Group 2'.
      lst_fld-seltext_m = 'Material Group 2'.
      lst_fld-seltext_s = 'Mat Grp 2'.
    WHEN 36.
      lst_fld-seltext_l = 'Material Group 3'.
      lst_fld-seltext_m = 'Material Group 3'.
      lst_fld-seltext_s = 'Mat Grp 3'.
    WHEN 37.
      lst_fld-seltext_l = 'Material Group 4'.
      lst_fld-seltext_m = 'Material Group 4'.
      lst_fld-seltext_s = 'Mat Grp 4'.
    WHEN 38.
      lst_fld-seltext_l = 'Material Group 5'.
      lst_fld-seltext_m = 'Material Group 5'.
      lst_fld-seltext_s = 'Mat Grp 5'.
    WHEN 39.
      lst_fld-seltext_l = 'Flag: New VS Renew'.
      lst_fld-seltext_m = 'Flag: New VS Renew'.
      lst_fld-seltext_s = 'New/Renew'.
    WHEN 40.
      lst_fld-seltext_l = 'Soc Rel Category'.
      lst_fld-seltext_m = 'Soc Rel Category'.
      lst_fld-seltext_s = 'Soc Rel Ct'.
    WHEN 41.
      lst_fld-seltext_l = 'Cust Cond Grp 3'.
      lst_fld-seltext_m = 'Cust Cond Grp 3'.
      lst_fld-seltext_s = 'Cond Grp 3'.
    WHEN 42.
      lst_fld-seltext_l = 'FOC Reason'.
      lst_fld-seltext_m = 'FOC Reason'.
      lst_fld-seltext_s = 'FOC Reason'.
    WHEN 43.
      lst_fld-seltext_l = 'Subscription Type'.
      lst_fld-seltext_m = 'Subscription Type'.
      lst_fld-seltext_s = 'Subs Type'.
    WHEN 45.
      lst_fld-seltext_l = 'Delivery Block'.
      lst_fld-seltext_m = 'Delivery Block'.
      lst_fld-seltext_s = 'Del Block'.
    WHEN 46.
      lst_fld-seltext_l = 'Billing Block'.
      lst_fld-seltext_m = 'Billing Block'.
      lst_fld-seltext_s = 'Bill Block'.
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    WHEN 48.
      lst_fld-seltext_l = 'Bill To Party Name'.
      lst_fld-seltext_m = 'Bill To Party Name'.
      lst_fld-seltext_s = 'BilTo Name'.
    WHEN 49.
      lst_fld-seltext_l = 'Bill To Party Address-1'.
      lst_fld-seltext_m = 'Bill To Party Addr-1'.
      lst_fld-seltext_s = 'BilTo Adr1'.
    WHEN 50.
      lst_fld-seltext_l = 'Bill To Party Address-2'.
      lst_fld-seltext_m = 'Bill To Party Addr-2'.
      lst_fld-seltext_s = 'BilTo Adr2'.
    WHEN 51.
      lst_fld-seltext_l = 'Bill To Party Address-3'.
      lst_fld-seltext_m = 'Bill To Party Addr-3'.
      lst_fld-seltext_s = 'BilTo Adr3'.
    WHEN 52.
      lst_fld-seltext_l = 'Bill To Party Address-4'.
      lst_fld-seltext_m = 'Bill To Party Addr-4'.
      lst_fld-seltext_s = 'BilTo Adr4'.
    WHEN 53.
      lst_fld-seltext_l = 'Bill To Party City'.
      lst_fld-seltext_m = 'Bill To Party City'.
      lst_fld-seltext_s = 'BilTo City'.
    WHEN 54.
      lst_fld-seltext_l = 'Bill To Party Postal Code'.
      lst_fld-seltext_m = 'Bill To Party PostCd'.
      lst_fld-seltext_s = 'BilToPstCd'.
    WHEN 55.
      lst_fld-seltext_l = 'Bill To Party Cuntry'.
      lst_fld-seltext_m = 'Bill To Party Cuntry'.
      lst_fld-seltext_s = 'BilToCntry'.
    WHEN 56.
      lst_fld-seltext_l = 'Bill To Party Email ID'.
      lst_fld-seltext_m = 'Bill To Party Email'.
      lst_fld-seltext_s = 'BilToEmail'.
    WHEN 57.
      lst_fld-seltext_l = 'Ship To Party Address-1'.
      lst_fld-seltext_m = 'Ship To Party Addr-1'.
      lst_fld-seltext_s = 'ShpTo Adr1'.
    WHEN 58.
      lst_fld-seltext_l = 'Ship To Party Address-2'.
      lst_fld-seltext_m = 'Ship To Party Addr-2'.
      lst_fld-seltext_s = 'ShpTo Adr2'.
    WHEN 59.
      lst_fld-seltext_l = 'Ship To Party Address-3'.
      lst_fld-seltext_m = 'Ship To Party Addr-3'.
      lst_fld-seltext_s = 'ShpTo Adr3'.
    WHEN 60.
      lst_fld-seltext_l = 'Ship To Party Address-4'.
      lst_fld-seltext_m = 'Ship To Party Addr-4'.
      lst_fld-seltext_s = 'ShpTo Adr4'.
    WHEN 61.
      lst_fld-seltext_l = 'Ship To Party City'.
      lst_fld-seltext_m = 'Ship To Party City'.
      lst_fld-seltext_s = 'ShpTo City'.
    WHEN 62.
      lst_fld-seltext_l = 'Ship To Party Postal Code'.
      lst_fld-seltext_m = 'Ship To Party PostCd'.
      lst_fld-seltext_s = 'ShpToPstCd'.
    WHEN 63.
      lst_fld-seltext_l = 'Ship To Party Cuntry'.
      lst_fld-seltext_m = 'Ship To Party Cuntry'.
      lst_fld-seltext_s = 'ShpToCntry'.
    WHEN 64.
      lst_fld-seltext_l = 'Ship To Party Email ID'.
      lst_fld-seltext_m = 'Ship To Party Email'.
      lst_fld-seltext_s = 'ShpToEmail'.
    WHEN 65.
      lst_fld-seltext_l = 'Material Volume Year'.
      lst_fld-seltext_m = 'Mat Vol Year'.
      lst_fld-seltext_s = 'MatVolYear'.
    WHEN 66.
      lst_fld-seltext_l = 'Society Acronym'.
      lst_fld-seltext_m = 'Society Acronym'.
      lst_fld-seltext_s = 'SocAcrnym'.
    WHEN 67.
      lst_fld-seltext_l = 'Credit Card Type'.
      lst_fld-seltext_m = 'Credit Card Type'.
      lst_fld-seltext_s = 'CrdtCrdTyp'.
    WHEN 71.
      lst_fld-seltext_l = 'Common Customer ID'.
      lst_fld-seltext_m = 'Common Cust ID'.
      lst_fld-seltext_s = 'CmnCustID'.
    WHEN 73.
      lst_fld-seltext_l = 'Customer Group'.
      lst_fld-seltext_m = 'Customer Group'.
      lst_fld-seltext_s = 'Cust Grp'.
    WHEN 74.
      lst_fld-seltext_l = 'Price List Type'.
      lst_fld-seltext_m = 'Price List Type'.
      lst_fld-seltext_s = 'PrcLstTyp'.
    WHEN 76.
      lst_fld-cfieldname = 'WAERK'.
      lst_fld-ctabname   = fp_tabname.
    WHEN 78.
      lst_fld-seltext_l = 'Cancellation Reason'.
      lst_fld-seltext_m = 'Cancellation Reason'.
      lst_fld-seltext_s = 'Canc Resn'.
    WHEN 79.
      lst_fld-seltext_l = 'Issues Sent'.
      lst_fld-seltext_m = 'Issues Sent'.
      lst_fld-seltext_s = 'Issues Snt'.
    WHEN 80.
      lst_fld-seltext_l = 'Issues Due'.
      lst_fld-seltext_m = 'Issues Due'.
      lst_fld-seltext_s = 'Issues Due'.
    WHEN 81.
      lst_fld-seltext_l = 'Start Issue'.
      lst_fld-seltext_m = 'Start Issue'.
      lst_fld-seltext_s = 'Strt Issue'.
    WHEN 82.
      lst_fld-seltext_l = 'Last Issue'.
      lst_fld-seltext_m = 'Last Issue'.
      lst_fld-seltext_s = 'Last Issue'.
    WHEN 86.
      lst_fld-seltext_l = 'Frwd Agent Name'.
      lst_fld-seltext_m = 'Frwd Agent Name'.
      lst_fld-seltext_s = 'FAgnt Name'.
    WHEN 87.
      lst_fld-seltext_l = 'Frwd Agent Address-1'.
      lst_fld-seltext_m = 'Frwd Agent Addr-1'.
      lst_fld-seltext_s = 'FAgnt Adr1'.
    WHEN 88.
      lst_fld-seltext_l = 'Frwd Agent Address-2'.
      lst_fld-seltext_m = 'Frwd Agent Addr-2'.
      lst_fld-seltext_s = 'FAgnt Adr2'.
    WHEN 89.
      lst_fld-seltext_l = 'Frwd Agent Address-3'.
      lst_fld-seltext_m = 'Frwd Agent Addr-3'.
      lst_fld-seltext_s = 'FAgnt Adr3'.
    WHEN 90.
      lst_fld-seltext_l = 'Frwd Agent Address-4'.
      lst_fld-seltext_m = 'Frwd Agent Addr-4'.
      lst_fld-seltext_s = 'FAgnt Adr4'.
    WHEN 91.
      lst_fld-seltext_l = 'Frwd Agent City'.
      lst_fld-seltext_m = 'Frwd Agent City'.
      lst_fld-seltext_s = 'FAgnt City'.
    WHEN 92.
      lst_fld-seltext_l = 'Frwd Agent Postal Code'.
      lst_fld-seltext_m = 'Frwd Agent PostCd'.
      lst_fld-seltext_s = 'FAgntPstCd'.
    WHEN 93.
      lst_fld-seltext_l = 'Frwd Agent Cuntry'.
      lst_fld-seltext_m = 'Frwd Agent Cuntry'.
      lst_fld-seltext_s = 'FAgntCntry'.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  ENDCASE.
  APPEND lst_fld TO i_fcat.
  CLEAR : lst_fld.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VBELN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_vbeln .
  SELECT vbeln " Sales and Distribution Document Number
   FROM vbuk   " Sales Document: Header Status and Administrative Data
    UP TO 1 ROWS
    INTO @DATA(lv_vbeln)
    WHERE vbeln IN @s_saldoc.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e199(zqtc_r2). " Invalid Document Number.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_AUART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_auart .

  DATA: lir_auart TYPE fip_t_auart_range,
        lst_auart TYPE fip_s_auart_range. " Structure for Ranges Table for Sales Office

  CONSTANTS: lc_auart  TYPE rvari_vnam  VALUE 'AUART'. " Sales Document Type

  LOOP AT i_constant INTO DATA(lst_constant).
    CASE lst_constant-param1.
      WHEN lc_auart.
        lst_auart-sign   = c_sign_i.
        lst_auart-option = c_opti_eq.
        lst_auart-low    = lst_constant-low.
        APPEND lst_auart TO lir_auart.
        CLEAR lst_auart.
      WHEN OTHERS.
*Do nothing.
    ENDCASE.

  ENDLOOP. " LOOP AT i_constant INTO DATA(lst_constant)

  LOOP AT s_doctyp.
    IF s_doctyp-low NOT IN lir_auart.
      MESSAGE e200(zqtc_r2) DISPLAY LIKE 'S'. " Invalid Document type
    ENDIF. " IF s_doctyp-low NOT IN lir_auart
  ENDLOOP. " LOOP AT s_doctyp

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_KUNNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_kunnr .
  SELECT kunnr " Customer Number
     FROM kna1 " General Data in Customer Master
      UP TO 1 ROWS
      INTO @DATA(lv_kunnr)
      WHERE kunnr IN @s_kunnr.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e010(zqtc_r2). " Invalid Customer Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_matnr .
  SELECT matnr " Material Number
     FROM mara " General Material Data
      UP TO 1 ROWS
      INTO @DATA(lv_matnr)
      WHERE matnr IN @s_matnum.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e176(zqtc_r2). " Invalid Material Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BSARK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_bsark .
  SELECT bsark " Customer purchase order type
     FROM t176 " Sales Documents: Customer Order Types
      UP TO 1 ROWS
      INTO @DATA(lv_bsark)
      WHERE bsark IN @s_partne.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e190(zqtc_r2). " Invalid Purchase Order Type,Please re-enter.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VKORG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_vkorg .
  SELECT SINGLE
         vkorg " Sales Organization
     FROM tvko " Organizational Unit: Sales Organizations
     INTO @DATA(lv_vkorg)
      WHERE vkorg IN @s_vkorg.
  IF sy-subrc NE 0.
    MESSAGE e012(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_VKBUR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_vkbur .
  SELECT SINGLE
         vkbur  " Sales Office
     FROM tvbur " Organizational Unit: Sales Offices
     INTO @DATA(lv_vkbur)
      WHERE vkbur IN @s_vkbur.
  IF sy-subrc NE 0.
    MESSAGE e202(zqtc_r2). " Invalid sales Office.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_partner .

  SELECT kunnr " Customer Number
   FROM kna1   " General Data in Customer Master
    UP TO 1 ROWS
    INTO @DATA(lv_kunnr)
    WHERE kunnr IN @s_partne.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e010(zqtc_r2). " Invalid Customer Number!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  CONSTANTS:lc_devid TYPE zdevid VALUE 'R053'. " Development ID
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
         activate    " Activation indicator for constant
    INTO TABLE i_constant
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid    = lc_devid
      AND activate = abap_true
    ORDER BY PRIMARY KEY.
  IF sy-subrc EQ 0.
*Do nothing.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_text .
  SELECT * FROM tvm1t     INTO TABLE i_tvm1 WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvm1 BY mvgr1.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvm2t     INTO TABLE i_tvm2 WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvm2 BY mvgr2.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvm3t     INTO TABLE i_tvm3 WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvm3 BY mvgr3.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvm4t     INTO TABLE i_tvm4 WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvm4 BY mvgr4.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvm5t     INTO TABLE i_tvm5 WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvm5 BY mvgr5.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvkggt    INTO TABLE i_tvkgg WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvkgg BY kdkgr.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tjpmedtpt INTO TABLE i_tjpmedtpt WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tjpmedtpt BY ismmediatype.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM t176t     INTO TABLE i_t176t WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_t176t BY bsark.
  ENDIF. " IF sy-subrc EQ 0
* Conditions: Groups for Customer Classes: Texts
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM t188t     INTO TABLE i_t188t WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_t188t BY konda.
  ENDIF. " IF sy-subrc EQ 0
* Organizational Unit: Sales Organizations: Texts
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvkot     INTO TABLE i_tvkot WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvkot  BY vkorg.
  ENDIF. " IF sy-subrc EQ 0
* Organizational Unit: Sales Offices: Texts
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvkbt     INTO TABLE i_tvkbt WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvkbt BY vkbur.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tsact     INTO TABLE i_tsact WHERE langu = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tsact BY comm_type.
  ENDIF. " IF sy-subrc EQ 0
* Deliveries: Blocking Reasons/Scope: Texts
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvlst     INTO TABLE i_tvlst WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvlst BY lifsp.
  ENDIF. " IF sy-subrc EQ 0
* Billing : Blocking Reason Texts
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  SELECT * FROM tvfst     INTO TABLE i_tvfst WHERE spras = sy-langu.
* BOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
  IF sy-subrc EQ 0.
    SORT i_tvfst BY faksp.
  ENDIF. " IF sy-subrc EQ 0
* EOI by PBANDLAPAL on 30-Nov-2017 for ERP-5402: ED2K909671
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  SELECT * FROM t151t     INTO TABLE i_t151t WHERE spras = sy-langu.
  IF sy-subrc EQ 0.
    SORT i_t151t BY kdgrp.
  ENDIF. " IF sy-subrc EQ 0
  SELECT * FROM t189t     INTO TABLE i_t189t WHERE spras = sy-langu.
  IF sy-subrc EQ 0.
    SORT i_t189t BY pltyp.
  ENDIF. " IF sy-subrc EQ 0
  SELECT * FROM tvkgt     INTO TABLE i_tvkgt WHERE spras = sy-langu.
  IF sy-subrc EQ 0.
    SORT i_tvkgt BY kuegru.
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_JPTMG0
*&---------------------------------------------------------------------*
*       Get data for volume and issues
*----------------------------------------------------------------------*
FORM f_get_jptmg0 .
  DATA: li_vbak TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0.

  li_vbak[] = i_vbak[].
  SORT li_vbak BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING matnr.

  IF li_vbak IS NOT INITIAL.
    SELECT med_prod    " Higher-Level Media Product
           ismpubldate " Publication Date
           ismcopynr   " Copy Number of Media Issue
           ismnrinyear " Issue Number (in Year Number)
           ismyearnr   " Media issue year number
      FROM jptmg0      " IS-M: Media Product Issue Sequence
      INTO TABLE i_jptmg0
      FOR ALL ENTRIES IN li_vbak
      WHERE med_prod = li_vbak-matnr.
*      AND   ismyearnr = p_valid+0(4).
    IF sy-subrc = 0.
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      SORT i_jptmg0 BY med_prod ismpubldate.
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     SORT i_jptmg0 BY med_prod ismyearnr ASCENDING
*                      ismcopynr DESCENDING.
*     End   of DEL:ERP-6311:WROY:28-AUG-2018:ED2K913224
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_vbak IS NOT INITIAL
ENDFORM.
FORM f_set_usr_comnd USING fp_v_ucomm     TYPE syucomm " Function Code
                           fp_st_selfield TYPE slis_selfield.

  CASE fp_v_ucomm.
    WHEN '&IC1'.
      READ TABLE i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
           INDEX fp_st_selfield-tabindex.
      IF sy-subrc EQ 0.
        SET PARAMETER ID 'KTN' FIELD <lst_final>-vbeln.
        SET PARAMETER ID 'VPO' FIELD <lst_final>-posnr.
        CALL TRANSACTION 'VA42' AND SKIP FIRST SCREEN.
      ENDIF. " IF sy-subrc EQ 0

    WHEN OTHERS.
*     Do Nothing
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SUBS_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_subs_type .
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = 'ZSUBTYP'
      text           = 'X'
      langu          = sy-langu
    TABLES
      dd07v_tab      = i_subs
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.
ENDFORM.
* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_COUNTRY
*&---------------------------------------------------------------------*
*       Validate Country Key
*----------------------------------------------------------------------*
*      -->FP_S_LAND1[]  Country Key
*----------------------------------------------------------------------*
FORM f_validate_country  USING    fp_s_land1 TYPE shp_land1_range_t.
  SELECT land1 " Country Key
     FROM t005 " Countries
      UP TO 1 ROWS
      INTO @DATA(lv_land1)
      WHERE land1 IN @fp_s_land1.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e030(zqtc_r2). " Invalid Country!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CURRENCY
*&---------------------------------------------------------------------*
*       Validate Currency Key
*----------------------------------------------------------------------*
*      -->FP_S_WAERK[]  Currency Key
*----------------------------------------------------------------------*
FORM f_validate_currency  USING    fp_s_waerk TYPE farr_tt_waers_range.
  SELECT waers  " Currency Key
     FROM tcurc " Currency Codes
      UP TO 1 ROWS
      INTO @DATA(lv_waers)
      WHERE waers IN @fp_s_waerk.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e021(sepm_dg). " Error: Enter a valid Currency Code
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ADDR_DETAILS
*&---------------------------------------------------------------------*
*       Populate Address Details
*----------------------------------------------------------------------*
*      -->FP_ADRNR
*      <--FP_NAME1
*      <--FP_ADDR1
*      <--FP_ADDR2
*      <--FP_ADDR3
*      <--FP_ADDR4
*----------------------------------------------------------------------*
FORM f_populate_addr_details  USING    fp_adrnr TYPE adrnr     " Address
                              CHANGING fp_name1 TYPE full_name " First and Last Name in One Line
                                       fp_addr1 TYPE lines     " Address line
                                       fp_addr2 TYPE lines     " Address line
                                       fp_addr3 TYPE lines     " Address line
                                       fp_addr4 TYPE lines.    " Address line

  CONSTANTS:
    lc_addr_type_org TYPE ad_adrtype VALUE '1'. " Address type (1=Organization, 2=Person, 3=Contact person)

  DATA:
    li_address_lines TYPE szadr_printform_table.

  CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
    EXPORTING
      address_type                   = lc_addr_type_org
      address_number                 = fp_adrnr
    IMPORTING
      address_printform_table        = li_address_lines
    EXCEPTIONS
      address_blocked                = 1
      person_blocked                 = 2
      contact_person_blocked         = 3
      addr_to_be_formated_is_blocked = 4
      OTHERS                         = 5.
  IF sy-subrc EQ 0.
    LOOP AT li_address_lines ASSIGNING FIELD-SYMBOL(<lst_address_line>).
      IF <lst_address_line>-line_type CA '1234'. "1-Name1,2-Name2,3-Name3,4-Name4
        IF fp_name1 IS INITIAL.
          fp_name1 = <lst_address_line>-address_line.
        ELSE. " ELSE -> IF fp_name1 IS INITIAL
          CONCATENATE fp_name1
                      <lst_address_line>-address_line
                 INTO fp_name1
            SEPARATED BY space.
        ENDIF. " IF fp_name1 IS INITIAL
      ELSEIF <lst_address_line>-line_type NA 'CLO'. "C-Postal Code,L-Country,O-City line
        CASE space.
          WHEN fp_addr1.
            fp_addr1 = <lst_address_line>-address_line.
          WHEN fp_addr2.
            fp_addr2 = <lst_address_line>-address_line.
          WHEN fp_addr3.
            fp_addr3 = <lst_address_line>-address_line.
          WHEN fp_addr4.
            fp_addr4 = <lst_address_line>-address_line.
        ENDCASE.
      ENDIF. " IF <lst_address_line>-line_type CA '1234'
    ENDLOOP. " LOOP AT li_address_lines ASSIGNING FIELD-SYMBOL(<lst_address_line>)
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SOC_ACRONYM
*&---------------------------------------------------------------------*
*       Fetch Society Acronym
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_soc_acronym .

  IF i_vbpa_za IS INITIAL.
    RETURN.
  ENDIF. " IF i_vbpa_za IS INITIAL

* Fetch Society Acronym
  SELECT society          " Business Partner 2 or Society number
         society_acrnym   " Society Acronym
    FROM zqtc_jgc_society " I0222: Journal Group Code to Society Mapping
    INTO TABLE i_soc_acrnym
          FOR ALL ENTRIES IN i_vbpa_za
   WHERE society EQ i_vbpa_za-kunnr.
  IF sy-subrc EQ 0.
    SORT i_soc_acrnym BY society.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PAYMENT_CARD
*&---------------------------------------------------------------------*
*       Fetch Payment Card details
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_payment_card .

  CONSTANTS:
    lc_category_1 TYPE fptyp_fp VALUE '1'. "Installment plan (payment by installments, payment cards)

  DATA(li_vbak) = i_vbak.
  SORT li_vbak BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING vbeln.
  IF li_vbak[] IS NOT INITIAL.   "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
* Payment cards: Transaction data - SD
    SELECT a~vbeln " Sales and Distribution Document Number
           a~fplnr " Billing plan number / invoicing plan number
           c~fpltr " Item for billing plan/invoice plan/payment cards
           c~ccins " Payment cards: Card type
           c~autwr " Payment cards: Authorized amount
           c~audat " Payment cards: Authorization date
           t~vtext " Description
      FROM fpla   AS a INNER JOIN
           fpltc  AS c
        ON c~fplnr EQ a~fplnr INNER JOIN
           tvcint AS t
        ON t~ccins EQ c~ccins
      INTO TABLE i_pay_cards
       FOR ALL ENTRIES IN li_vbak
     WHERE a~vbeln EQ li_vbak-vbeln
       AND a~fptyp EQ lc_category_1
       AND t~spras EQ sy-langu.
    IF sy-subrc EQ 0.
      DELETE i_pay_cards WHERE autwr IS INITIAL.
      SORT i_pay_cards BY vbeln fplnr fpltr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.                 "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PAYMENT_DETAILS
*&---------------------------------------------------------------------*
*       Fetch Payment Details
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_payment_details .

  CONSTANTS:
    lc_inv_doc_cat  TYPE rvari_vnam VALUE 'INV_DOC_CATEGORY', " ABAP: Name of Variant Variable
    lc_clr_doc_typ  TYPE rvari_vnam VALUE 'CLR_DOC_TYPE',     " ABAP: Name of Variant Variable
    lc_acc_typ_cust TYPE koart      VALUE 'D',                "Account Type: Customer
    lc_ref_trn_vbrk TYPE awtyp      VALUE 'VBRK'.             "Reference Transaction

  DATA:
    lr_inv_doc_cat TYPE saco_vbtyp_ranges_tab,
    lr_clr_doc_typ TYPE bkk_r_blart.

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_inv_doc_cat.
        APPEND INITIAL LINE TO lr_inv_doc_cat ASSIGNING FIELD-SYMBOL(<lst_inv_doc_cat>).
        <lst_inv_doc_cat>-sign   = <lst_constant>-sign.
        <lst_inv_doc_cat>-option = <lst_constant>-opti.
        <lst_inv_doc_cat>-low    = <lst_constant>-low.
        <lst_inv_doc_cat>-high   = <lst_constant>-high.

      WHEN lc_clr_doc_typ.
        APPEND INITIAL LINE TO lr_clr_doc_typ ASSIGNING FIELD-SYMBOL(<lst_clr_doc_typ>).
        <lst_clr_doc_typ>-sign   = <lst_constant>-sign.
        <lst_clr_doc_typ>-option = <lst_constant>-opti.
        <lst_clr_doc_typ>-low    = <lst_constant>-low.
        <lst_clr_doc_typ>-high   = <lst_constant>-high.

    ENDCASE.
  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)

  DATA(li_vbak) = i_vbak.
  DELETE li_vbak WHERE vgbel IS INITIAL.
  IF li_vbak IS NOT INITIAL.
    SORT li_vbak BY vgbel bukrs_vf.
    DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING vgbel bukrs_vf.

*   Fetch Payment Details (through Quotation)
    SELECT bukrs " Company Code
           belnr " Accounting Document Number
           gjahr " Fiscal Year
           buzei " Number of Line Item Within Accounting Document
           budat " Posting Date in the Document
           blart " Document Type
           xref1 " Business Partner Reference Key
      FROM bsid  " Accounting: Secondary Index for Customers
      INTO TABLE i_pay_quote
       FOR ALL ENTRIES IN li_vbak
     WHERE xref1 EQ li_vbak-vgbel
       AND bukrs EQ li_vbak-bukrs_vf
       AND blart IN lr_clr_doc_typ.
    IF sy-subrc EQ 0.
      SORT i_pay_quote BY xref1 bukrs.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_vbak IS NOT INITIAL

  li_vbak = i_vbak.
  IF li_vbak IS NOT INITIAL.
    SORT li_vbak BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING vbeln posnr.

*   Fetch Payment Details (through Invoice)
    SELECT vbfa~vbelv   " Preceding sales and distribution document
           vbfa~posnv   " Preceding item of an SD document
           vbfa~vbeln   " Subsequent sales and distribution document
           vbfa~posnn   " Subsequent item of an SD document
           vbfa~vbtyp_n " Document category of subsequent document
           bseg~bukrs   " Company Code
           bseg~belnr   " Accounting Document Number
           bseg~gjahr   " Fiscal Year
           bseg~buzei   " Number of Line Item Within Accounting Document
           bseg~augdt   " Clearing Date
      FROM vbfa         " Sales Document Flow
     INNER JOIN vbrk    " Billing Document: Header Data
        ON vbrk~vbeln EQ vbfa~vbeln
       AND vbrk~fksto EQ space
     INNER JOIN bkpf    " Accounting Document Header
        ON bkpf~awtyp EQ lc_ref_trn_vbrk
       AND bkpf~awkey EQ vbrk~vbeln
     INNER JOIN bseg    " Accounting Document Segment
        ON bseg~bukrs EQ bkpf~bukrs
       AND bseg~belnr EQ bkpf~belnr
       AND bseg~gjahr EQ bkpf~gjahr
       AND bseg~koart EQ lc_acc_typ_cust
      INTO TABLE i_pay_inv
       FOR ALL ENTRIES IN li_vbak
     WHERE vbfa~vbelv   EQ li_vbak-vbeln
       AND vbfa~posnv   EQ li_vbak-posnr
       AND vbfa~vbtyp_n IN lr_inv_doc_cat
* Begin of changes by Lahiru on 03/24/2020 with ED2K917842 for ERPM-4405 *
       AND vbfa~stufe  EQ space.
* End of changes by Lahiru on 03/24/2020 with ED2K917842 for ERPM-4405*
    IF sy-subrc EQ 0.
      SORT i_pay_inv BY vbelv posnv.
    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF li_vbak IS NOT INITIAL

ENDFORM.
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*&---------------------------------------------------------------------*
*&      Form  F_GET_JKSESCHED
*&---------------------------------------------------------------------*
*       Fetch volume/issues
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_jksesched .
  IF i_vbak[] IS NOT INITIAL.   "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
* Fetch Media Schedule Lines
    SELECT jksesched~vbeln          " Sales and Distribution Document Number
           jksesched~posnr          " Item number of the SD document
           jksesched~issue          " Media Issue
           jksesched~product        " Media Product
           jksesched~sequence       " IS-M: Sequence
           jksesched~xorder_created " IS-M: Indicator Denoting that Order Was Generated
           jksesched~shipping_date  " IS-M: Delivery Date
           mara~ismcopynr           " Copy Number of Media Issue
           mara~ismnrinyear         " Issue Number (in Year Number)
           mara~ismyearnr           " Media issue year number
           marc~ismarrivaldateac    " Actual Goods Arrival Date
      FROM jksesched                " IS-M: Media Schedule Lines
     INNER JOIN mara                " General Material Data
        ON mara~matnr EQ jksesched~issue
     INNER JOIN marc                " Plant Data for Material
        ON marc~matnr EQ jksesched~issue
      INTO TABLE i_jksesched
       FOR ALL ENTRIES IN i_vbak
     WHERE jksesched~vbeln EQ i_vbak-vbeln
       AND jksesched~posnr EQ i_vbak-posnr
       AND marc~werks      EQ i_vbak-werks.
    IF sy-subrc EQ 0.
      SORT i_jksesched BY vbeln posnr issue product sequence.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.           "NPOLINA  INC0217212 ED1K909057 30-Nov-2018
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_ALV_VARIANT
*&---------------------------------------------------------------------*
*       F4 Help for ALV Variants
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_alv_variant .
  DATA:
    lst_variant TYPE disvariant. " Layout (External Use)

  DATA:
    lv_exit     TYPE char1. " Exit of type CHAR1

* Display all existing ALV variants
  lst_variant-report = sy-repid.
* Utilizing the name of the report, this function module will search for a list of
* variants and will fetch the selected one into the parameter field for variants
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = lst_variant
      i_save     = abap_true
    IMPORTING
      e_exit     = lv_exit
      es_variant = st_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE 'S'
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ELSE. " ELSE -> IF sy-subrc NE 0
    IF lv_exit = space.
      p_alv_vr = st_variant-variant.
    ENDIF. " IF lv_exit = space
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ALV_VARIANT
*&---------------------------------------------------------------------*
*       Validate ALV Variant
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_alv_variant .
  DATA:
    lst_variant TYPE disvariant. " Layout (External Use)

  lst_variant-variant = p_alv_vr.
  lst_variant-report  = sy-repid.
  CALL FUNCTION 'LVC_VARIANT_EXISTENCE_CHECK' "Check for display variant
    EXPORTING
      i_save        = space                   "Variants Can be Saved
    CHANGING
      cs_variant    = lst_variant             "Variant information
    EXCEPTIONS
      wrong_input   = 1                       "Inconsistent input parameters
      not_found     = 2                       "Variant not found
      program_error = 3.                      "Program Errors
  IF sy-subrc EQ 0.
    st_variant = lst_variant.
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE s234(tt) WITH p_alv_vr. " Variant "&" not found. Only default values are displayed
  ENDIF. " IF sy-subrc EQ 0

  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = abap_true
    CHANGING
      cs_variant = st_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    p_alv_vr = st_variant-variant.
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SHIP_TO_PARTY
*&---------------------------------------------------------------------*
*       Validate Ship To Party
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_ship_to_party .
  SELECT kunnr " Customer Number
     FROM kna1 " General Data in Customer Master
      UP TO 1 ROWS
      INTO @DATA(lv_kunnr)
      WHERE kunnr IN @s_shpto.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e010(zqtc_r2). " Invalid Customer Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUST_COND_GRP_2
*&---------------------------------------------------------------------*
*       Validate Customer Condition Group 2
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_cust_cond_grp_2 .
  SELECT kdkgr  " Customer Attribute for Condition Groups
     FROM tvkgg " Customer Condition Groups (Customer Master)
      UP TO 1 ROWS
      INTO @DATA(lv_kdkgr)
      WHERE kdkgr IN @s_kdkg2.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e502(zqtc_r2). " Please enter a valid Customer Condition Group 2.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_GRP_5
*&---------------------------------------------------------------------*
*       Validate Material Group 5
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_mat_grp_5 .
  SELECT mvgr5 " Material group 5
     FROM tvm5 " Material Pricing Group 5
      UP TO 1 ROWS
      INTO @DATA(lv_mvgr5)
      WHERE mvgr5 IN @s_mvgr5.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e501(zqtc_r2). " Please enter a valid Material Group 5.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_new .

  PERFORM f_append_field_cat_new USING:
  'I_FINAL'(T01)  'VBELN' 'Sales Document'(D01)                 'VBAK' 'VBELN',
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01)  'ERDAT' 'Created On'(E03)                     'VBAK' 'ERDAT',
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01)  'POSNR' 'Sales Document Item'(D02)            'VBAP' 'POSNR',
  'I_FINAL'(T01)  'AUART' 'Sales Document Type'(D03)            'VBAK' 'AUART',
  'I_FINAL'(t01)  'VKORG' 'Sales Organisation'(D04)             'RJMG02' 'TEXT213',
  'I_FINAL'(T01)  'VKBUR' 'Sales Office'(D05)                   'RJMG02' 'TEXT213',
  'I_FINAL'(T01)  'ZZSUBTYP' 'Subscription Type'(D06)           'BC325V10' 'NAME',
  'I_FINAL'(T01)  'BSTKD' 'Customer Purchase Order Number'(D07) 'VBKD' 'BSTKD',
  'I_FINAL'(T01)  'BSARK' 'Customer Purchase Order Type'(D08)   'VBKD' 'BSARK',
* BOI by AKHADIR on 16-Jul-2019 for DM-1995 TR-ED2K915723
  'I_FINAL'(T01) 'BEZEI'       'Order reason'(F02)               'VBAK' 'AUGRU',
* EOI by AKHADIR on 16-Jul-2019 for DM-1995 TR-ED2K915723
  'I_FINAL'(T01)  'KONDA' 'Price Group'(D09)                    'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'IHREZ' 'Your Reference'(D10)                 'VBAK' 'IHREZ',
  'I_FINAL'(T01) 'MATNR' 'Material Number'(D11)                'VBAP' 'MATNR',
  'I_FINAL'(T01) 'ARKTX' 'Order item Description'(D38)         'VBAP' 'ARKTX',
  'I_FINAL'(T01) 'ISMMEDIATYPE' 'Media Type'(D12)              'T505P' 'LTEXT',
  'I_FINAL'(T01) 'EXTWG' 'External Material Group'(D14)        'MARA' 'EXTWG',
  'I_FINAL'(T01) 'NETWR' 'Net Value'(D15)                      'VBAK' 'NETWR',
  'I_FINAL'(T01) 'WAERK' 'SD Document Currency'(D16)           'VBAK' 'WAERK',
  'I_FINAL'(T01) 'ACTIVITY' 'Activity'(D17)                    'ZQTC_RENWL_PLAN' 'ZACTIVITY_SUB',
  'I_FINAL'(T01) 'EADAT' 'Activity Date'(D18)                  'ZQTC_RENWL_PLAN' 'EADAT',
  'I_FINAL'(T01) 'ACT_STATU' 'Ativity Status'(D19)             'ZQTC_RENWL_PLAN' 'ZACT_STATUS',
  'I_FINAL'(T01) 'REN_SSTATUS' 'Renewal Status'(D20)           'BC325V10' 'NAME',
  'I_FINAL'(T01) 'ACTIVITY_D' 'Description'(D21)               'ZQTCT_ACTIVITY' 'ACTIVITY_D',
  'I_FINAL'(T01) 'KUNNR_SP' 'Sold To Party'(D22)               'VBPA' 'KUNNR',
  'I_FINAL'(T01) 'NAME1_SP' 'Sold To Party Name'(D23)          'ADRC' 'NAME1',
  'I_FINAL'(T01) 'LAND1_SP' 'Sold To Party Country'(D48)       'ADRC' 'COUNTRY',
  'I_FINAL'(T01) 'KUNNR_SH' 'Ship To Party '(D24)              'VBPA' 'KUNNR',
*  'I_FINAL'(T01) 'NAME1_SH' 'Ship To Party Name'(D25)          'RC70D' 'FULL_NAME',
  'I_FINAL'(T01) 'KUNNR' 'Society Number'(D26)                 'VBPA' 'KUNNR',
  'I_FINAL'(T01) 'PARVW' 'Partner Function'(D27)               'VBPA' 'PARVW',
  'I_FINAL'(T01) 'NAME1' 'Society Name'(D28)                   'ADRC' 'NAME1',
  'I_FINAL'(T01) 'VBEGDAT' 'Contract start Date'(D29)          'VEDA' 'VBEGDAT',
  'I_FINAL'(T01) 'VENDDAT' 'Contract End Date'(D30)            'VEDA' 'VENDDAT',
  'I_FINAL'(T01) 'ZMENG' 'Target quantity'(D31)                'VBAP' 'ZMENG',
  'I_FINAL'(T01) 'ZIEME' 'UoM'(D32)                            'VBAP' 'ZIEME',
  'I_FINAL'(T01) 'MVGR1' 'Material group 1'(D33)               'TBE24T' 'TXT50',
  'I_FINAL'(T01) 'MVGR2' 'Material group 2'(D34)               'TBE24T' 'TXT50',
  'I_FINAL'(T01) 'MVGR3' 'Material group 3'(D35)               'TBE24T' 'TXT50',
  'I_FINAL'(T01) 'MVGR4' 'Material group 4'(D36)               'TBE24T' 'TXT50',
  'I_FINAL'(T01) 'MVGR5' 'Material group 5'(D37)               'TBE24T' 'TXT50',
  'I_FINAL'(T01) 'KDKG1' 'Flag: New VS Renew'(D39)             'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'KDKG2' 'Soc Rel Category'(D40)               'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'KDKG3' 'Cust Cond Grp 3'(D41)                'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'KDKG4' 'FOC Reason'(D42)                     'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'KDKG5' 'Subscription Type'(D43)              'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'VOLUME' 'Volume'(D44)                        'JPTMG0' 'ISMCOPYNR',
  'I_FINAL'(T01) 'LIFSK' 'Delivery Block'(D46)                 'RJMG02' 'TEXT213',
  'I_FINAL'(T01) 'FAKSK' 'Billing block'(D47)                  'RJMG02' 'TEXT213',
  'I_FINAL'(T01) 'KUNNR_BP' 'Bill To Party'(D49)               'VBDKR' 'KUNRE',
  'I_FINAL'(T01) 'NAME1_BP' 'Bill To Party Name'(D50)          'RC70D' 'FULL_NAME',
  'I_FINAL'(T01) 'ADDR1_BP' 'Bill To Party Address-1'(D51)     'ADRS' 'LINE1',
  'I_FINAL'(T01) 'ADDR2_BP' 'Bill To Party Address-2'(D52)     'ADRS' 'LINE2',
  'I_FINAL'(T01) 'ADDR3_BP' 'Bill To Party Address-3'(D53)     'ADRS' 'LINE3',
  'I_FINAL'(T01) 'ADDR4_BP' 'Bill To Party Address-4'(D54)     'ADRS' 'LINE4',
  'I_FINAL'(T01) 'CITY1_BP' 'Bill To Party City'(D55)          'ADRS' 'ORT01',
  'I_FINAL'(T01) 'PSTLZ_BP' 'Bill To Party Postal Code'(D56)   'ADRS' 'PSTLZ',
  'I_FINAL'(T01) 'LAND1_BP' 'Bill To Party Cuntry'(D57)        'ADRS' 'LAND1',
  'I_FINAL'(T01) 'EMAIL_BP' 'Bill To Party Email ID'(D58)      'ADR6' 'SMTP_ADDR',
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01) 'TITLE_SH' 'Ship To Party Title'(D96)         'ADRS' 'TITLE',
  'I_FINAL'(T01) 'TITLE_TXT_SH' 'Ship To Party Title'(D96)     'TSAD3T' 'TITLE_MEDI',
  'I_FINAL'(T01) 'NAME1_SH' 'Ship To Party Name-1'(D97)        'ADRS' 'NAME1',
  'I_FINAL'(T01) 'NAME2_SH' 'Ship To Party Name-2'(D98)        'ADRS' 'NAME2',
  'I_FINAL'(T01) 'NAME3_SH' 'Ship To Party Name-3'(D99)        'ADRS' 'NAME3',
  'I_FINAL'(T01) 'NAME4_SH' 'Ship To Party Name-4'(E01)        'ADRS' 'NAME4',
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
* Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
  'I_FINAL'(T01) 'IHREZ_E'  'Ship To Party - Your Reference'(E04) 'VBKD' 'IHREZ_E',
* End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
  'I_FINAL'(T01) 'ADDR1_SH' 'Ship To Party Address-1'(D59)     'ADRS' 'LINE1',
  'I_FINAL'(T01) 'ADDR2_SH' 'Ship To Party Address-2'(D60)     'ADRS' 'LINE2',
  'I_FINAL'(T01) 'ADDR3_SH' 'Ship To Party Address-3'(D61)     'ADRS' 'LINE3',
  'I_FINAL'(T01) 'ADDR4_SH' 'Ship To Party Address-4'(D62)     'ADRS' 'LINE4',
  'I_FINAL'(T01) 'CITY1_SH' 'Ship To Party City'(D63)          'ADRS' 'ORT01',
  'I_FINAL'(T01) 'PSTLZ_SH' 'Ship To Party Postal Code'(D64)   'ADRS' 'PSTLZ',
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01) 'REGION_SH' 'Ship To Party Region'(E02)       'ADRS' 'REGION',
  'I_FINAL'(T01) 'REGION_TXT_SH' 'Ship To Party Region'(E02)   'T005U' 'BEZEI',
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01) 'LAND1_SH' 'Ship To Party Cuntry'(D65)        'ADRS' 'LAND1',
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01) 'LANDX_SH' 'Ship To Party Cuntry'(D65)        'ADRS' 'LANDX',
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
  'I_FINAL'(T01) 'EMAIL_SH' 'Ship To Party Email ID'(D66)      'ADR6' 'SMTP_ADDR',
  'I_FINAL'(T01) 'VOLUME_YR'  'Material Volume Year'(D67)      'MARA' 'ISMYEARNR',
  'I_FINAL'(T01) 'SOC_ACRNYM' 'Society Acronym'(D68)           'ZQTC_JGC_SOCIETY' 'SOCIETY_ACRNYM',
  'I_FINAL'(T01) 'CC_TYPE'    'Credit Card Type'(D69)          'TVCINT' 'TEXT',
  'I_FINAL'(T01) 'CC_PAY_AMT' 'Payment Amount (By CC)'(D70)    'FPLTC' 'AUTWR',
  'I_FINAL'(T01) 'PAY_DATE'   'Payment Date'(D71)              'P0063' 'BETDT',
  'I_FINAL'(T01) 'PAY_STATUS'  'Payment Status'(D80)           'J_3R_CPS_PAYMENT_INFO' 'PAYMENT_STATUS',
  'I_FINAL'(T01) 'CMN_CUST_ID' 'Common Customer ID'(D81)       'BUT0ID' 'IDNUMBER',
  'I_FINAL'(T01) 'REP_YEAR'    'Reporting Year'(D84)           'FKKPDREP_ITEM' 'AJAHR',
  'I_FINAL'(T01) 'KDGRP'       'Customer Group'(D72)           'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'PLTYP'       'Price list type'(D73)          'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'ZZLICGRP'    'License Group'(D74)            'VBAK' 'ZZLICGRP',
  'I_FINAL'(T01) 'MWSBP'       'Tax Amount'(D75)               'VBAP' 'MWSBP',
  'I_FINAL'(T01) 'ZZFTE'       'No Of FTEs'(D76)               'KNVV' 'ZZFTE',
  'I_FINAL'(T01) 'CANC_RESN'   'Cancellation Reason'(D77)      'RFCU4' 'VTEXT',
  'I_FINAL'(T01) 'ISSUES_SENT' 'Issues Sent'(D78)              'RJVSD_SHP_ALV1' 'CNT_ISSUES',
  'I_FINAL'(T01) 'ISSUES_DUE'  'Issues Due'(D79)               'RJVSD_SHP_ALV1' 'CNT_ISSUES_OPEN',
  'I_FINAL'(T01) 'START_ISSUE' 'Start Issue'(D82)              'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'LAST_ISSUE'  'Last Issue'(D83)               'ANTS_TRACE_DATA' 'COUNT_TYPE',
*--*BOC OTCM-25936 Additional fields PRABHU 11/26/2020
  'I_FINAL'(T01) 'MEDIA_START_ISSUE' 'Media Start Issue'(E05)   'ANTS_TRACE_DATA' 'COUNT_TYPE',
  'I_FINAL'(T01) 'MEDIA_LAST_ISSUE'  'Media End Issue'(E06)    'ANTS_TRACE_DATA' 'COUNT_TYPE',
*--*EOC OTCM-25936 Additional fields PRABHU 11/26/2020
  'I_FINAL'(T01) 'UEPOS'       'Higher-level Item'(D85)        'VBAP' 'UEPOS',
  'I_FINAL'(T01) 'BILL_DOC'    'Billing Document'(D86)         'VBRK' 'VBELN',
  'I_FINAL'(T01) 'FRWD_AGNT'   'Forwarding Agent'(D87)         'LIPOSTV' 'SPDNR',
  'I_FINAL'(T01) 'NAME1_FA'    'Forwarding Agent Name'(D88)    'RC70D' 'FULL_NAME',
  'I_FINAL'(T01) 'ADDR1_FA'    'Frwd Agent Address-1'(D89)     'ADRS' 'LINE1',
  'I_FINAL'(T01) 'ADDR2_FA'    'Frwd Agent Address-2'(D90)     'ADRS' 'LINE2',
  'I_FINAL'(T01) 'ADDR3_FA'    'Frwd Agent Address-3'(D91)     'ADRS' 'LINE3',
  'I_FINAL'(T01) 'ADDR4_FA'    'Frwd Agent Address-4'(D92)     'ADRS' 'LINE4',
  'I_FINAL'(T01) 'CITY1_FA'    'Frwd Agent City'(D93)          'ADRS' 'ORT01',
  'I_FINAL'(T01) 'PSTLZ_FA'    'Frwd Agent Postal Code'(D94)   'ADRS' 'PSTLZ',
  'I_FINAL'(T01) 'LAND1_FA'    'Frwd Agent Cuntry'(D95)        'ADRS' 'LAND1'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_APPEND_FIELD_CAT_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0963   text
*      -->P_0964   text
*      -->P_0965   text
*      -->P_0966   text
*----------------------------------------------------------------------*
FORM f_append_field_cat_new  USING    fp_tabname
                                      fp_fieldname
                                      fp_reptext_ddic
                                      fp_ref_tabname
                                      fp_ref_fieldname.
  DATA: lst_fld TYPE slis_fieldcat_alv.
  STATICS: lv_col_pos TYPE sy-cucol.

  CLEAR lst_fld.
  lv_col_pos = lv_col_pos + 1.
  lst_fld-col_pos       = lv_col_pos.
  lst_fld-tabname       = fp_tabname.
  lst_fld-fieldname     = fp_fieldname.
  lst_fld-reptext_ddic  = fp_reptext_ddic.
  lst_fld-ref_tabname   = fp_ref_tabname.
  lst_fld-ref_fieldname = fp_ref_fieldname.

  CASE fp_fieldname.
    WHEN 'VKORG'.
      lst_fld-seltext_l = 'Sales Organization'.
      lst_fld-seltext_m = 'Sales Org'.
      lst_fld-seltext_s = 'S. Org'.
    WHEN 'VKBUR'.
      lst_fld-seltext_l = 'Sales office'.
      lst_fld-seltext_m = 'Sales off'.
      lst_fld-seltext_s = 'S. Off'.
    WHEN 'ZZSUBTYP'.
      lst_fld-seltext_l = 'Subscription type'.
      lst_fld-seltext_m = 'Subs type'.
      lst_fld-seltext_s = 'Subs type'.
    WHEN 'KONDA'.
      lst_fld-seltext_l = 'Price Group'.
      lst_fld-seltext_m = 'Price Group'.
      lst_fld-seltext_s = 'Prc Grp'.
    WHEN 'ISMMEDIATYPE'.
      lst_fld-seltext_l = 'Media Type'.
      lst_fld-seltext_m = 'Media Type'.
      lst_fld-seltext_s = 'Media Type'.
*Begin of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
    WHEN 'NETWR'.
      lst_fld-cfieldname = 'WAERK'.
      lst_fld-ctabname   = fp_tabname.
*End of Add-Anirban-07.25.2017-ED2K907461-Defect 3519
    WHEN 'REN_SSTATUS'.
      lst_fld-seltext_l = 'Renewal Status'.
      lst_fld-seltext_m = 'Renw Status'.
      lst_fld-seltext_s = 'Ren Status'.
    WHEN 'KUNNR_SP'.
      lst_fld-seltext_l = 'Sold To Party'.
      lst_fld-seltext_m = 'Sold To Party'.
      lst_fld-seltext_s = 'SldToParty'.
    WHEN 'NAME1_SP'.
      lst_fld-seltext_l = 'Sold To Party Name'.
      lst_fld-seltext_m = 'Sold To Party Name'.
      lst_fld-seltext_s = 'SldTo Name'.
*   Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*   WHEN 24.
*     lst_fld-seltext_l = 'Communication Method'.
*     lst_fld-seltext_m = 'Comm Method'.
*     lst_fld-seltext_s = 'Comm Meth'.
*   END   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
    WHEN 'KUNNR_SH'.
      lst_fld-seltext_l = 'Ship To Party'.
      lst_fld-seltext_m = 'Ship To Party'.
      lst_fld-seltext_s = 'ShpToParty'.
*    WHEN 'NAME1_SH'.
*      lst_fld-seltext_l = 'Ship To Party Name'.
*      lst_fld-seltext_m = 'Ship To Party Name'.
*      lst_fld-seltext_s = 'ShpTo Name'.
    WHEN 'KUNNR'.
      lst_fld-seltext_l = 'Society Number'.
      lst_fld-seltext_m = 'Society Number'.
      lst_fld-seltext_s = 'Soc Number'.
    WHEN 'NAME1'.
      lst_fld-seltext_l = 'Society Name'.
      lst_fld-seltext_m = 'Society Name'.
      lst_fld-seltext_s = 'Soc Name'.
    WHEN 'MVGR1'.
      lst_fld-seltext_l = 'Material Group 1'.
      lst_fld-seltext_m = 'Material Group 1'.
      lst_fld-seltext_s = 'Mat Grp 1'.
    WHEN 'MVGR2'.
      lst_fld-seltext_l = 'Material Group 2'.
      lst_fld-seltext_m = 'Material Group 2'.
      lst_fld-seltext_s = 'Mat Grp 2'.
    WHEN 'MVGR3'.
      lst_fld-seltext_l = 'Material Group 3'.
      lst_fld-seltext_m = 'Material Group 3'.
      lst_fld-seltext_s = 'Mat Grp 3'.
    WHEN 'MVGR4'.
      lst_fld-seltext_l = 'Material Group 4'.
      lst_fld-seltext_m = 'Material Group 4'.
      lst_fld-seltext_s = 'Mat Grp 4'.
    WHEN 'MVGR5'.
      lst_fld-seltext_l = 'Material Group 5'.
      lst_fld-seltext_m = 'Material Group 5'.
      lst_fld-seltext_s = 'Mat Grp 5'.
    WHEN 'KDKG1'.
      lst_fld-seltext_l = 'Flag: New VS Renew'.
      lst_fld-seltext_m = 'Flag: New VS Renew'.
      lst_fld-seltext_s = 'New/Renew'.
    WHEN 'KDKG2'.
      lst_fld-seltext_l = 'Soc Rel Category'.
      lst_fld-seltext_m = 'Soc Rel Category'.
      lst_fld-seltext_s = 'Soc Rel Ct'.
    WHEN 'KDKG3'.
      lst_fld-seltext_l = 'Cust Cond Grp 3'.
      lst_fld-seltext_m = 'Cust Cond Grp 3'.
      lst_fld-seltext_s = 'Cond Grp 3'.
    WHEN 'KDKG4'.
      lst_fld-seltext_l = 'FOC Reason'.
      lst_fld-seltext_m = 'FOC Reason'.
      lst_fld-seltext_s = 'FOC Reason'.
    WHEN 'KDKG5'.
      lst_fld-seltext_l = 'Subscription Type'.
      lst_fld-seltext_m = 'Subscription Type'.
      lst_fld-seltext_s = 'Subs Type'.
    WHEN 'LIFSK'.
      lst_fld-seltext_l = 'Delivery Block'.
      lst_fld-seltext_m = 'Delivery Block'.
      lst_fld-seltext_s = 'Del Block'.
    WHEN 'FAKSK'.
      lst_fld-seltext_l = 'Billing Block'.
      lst_fld-seltext_m = 'Billing Block'.
      lst_fld-seltext_s = 'Bill Block'.
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
    WHEN 'NAME1_BP'.
      lst_fld-seltext_l = 'Bill To Party Name'.
      lst_fld-seltext_m = 'Bill To Party Name'.
      lst_fld-seltext_s = 'BilTo Name'.
    WHEN 'ADDR1_BP'.
      lst_fld-seltext_l = 'Bill To Party Address-1'.
      lst_fld-seltext_m = 'Bill To Party Addr-1'.
      lst_fld-seltext_s = 'BilTo Adr1'.
    WHEN 'ADDR2_BP'.
      lst_fld-seltext_l = 'Bill To Party Address-2'.
      lst_fld-seltext_m = 'Bill To Party Addr-2'.
      lst_fld-seltext_s = 'BilTo Adr2'.
    WHEN 'ADDR3_BP'.
      lst_fld-seltext_l = 'Bill To Party Address-3'.
      lst_fld-seltext_m = 'Bill To Party Addr-3'.
      lst_fld-seltext_s = 'BilTo Adr3'.
    WHEN 'ADDR4_BP'.
      lst_fld-seltext_l = 'Bill To Party Address-4'.
      lst_fld-seltext_m = 'Bill To Party Addr-4'.
      lst_fld-seltext_s = 'BilTo Adr4'.
    WHEN 'CITY1_BP'.
      lst_fld-seltext_l = 'Bill To Party City'.
      lst_fld-seltext_m = 'Bill To Party City'.
      lst_fld-seltext_s = 'BilTo City'.
    WHEN 'PSTLZ_BP'.
      lst_fld-seltext_l = 'Bill To Party Postal Code'.
      lst_fld-seltext_m = 'Bill To Party PostCd'.
      lst_fld-seltext_s = 'BilToPstCd'.
    WHEN 'LAND1_BP'.
      lst_fld-seltext_l = 'Bill To Party Cuntry'.
      lst_fld-seltext_m = 'Bill To Party Cuntry'.
      lst_fld-seltext_s = 'BilToCntry'.
    WHEN 'EMAIL_BP'.
      lst_fld-seltext_l = 'Bill To Party Email ID'.
      lst_fld-seltext_m = 'Bill To Party Email'.
      lst_fld-seltext_s = 'BilToEmail'.
*+Begin of Change NPALLA
    WHEN 'TITLE_SH'.
      lst_fld-no_out = abap_true.
    WHEN 'TITLE_TXT_SH'.
      lst_fld-seltext_l = 'Ship To Party Title'.
      lst_fld-seltext_m = 'Ship To Party Title'.
      lst_fld-seltext_s = 'ShpTo Title'.
    WHEN 'NAME1_SH'.
      lst_fld-seltext_l = 'Ship To Party Name-1'.
      lst_fld-seltext_m = 'Ship To Party Name-1'.
      lst_fld-seltext_s = 'ShpTo Nam1'.
    WHEN 'NAME2_SH'.
      lst_fld-seltext_l = 'Ship To Party Name-2'.
      lst_fld-seltext_m = 'Ship To Party Name-2'.
      lst_fld-seltext_s = 'ShpTo Nam2'.
    WHEN 'NAME3_SH'.
      lst_fld-seltext_l = 'Ship To Party Name-3'.
      lst_fld-seltext_m = 'Ship To Party Name-3'.
      lst_fld-seltext_s = 'ShpTo Nam3'.
    WHEN 'NAME4_SH'.
      lst_fld-seltext_l = 'Ship To Party Name-4'.
      lst_fld-seltext_m = 'Ship To Party Name-4'.
      lst_fld-seltext_s = 'ShpTo Nam4'.
*+End of Change NPALLA
* Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
    WHEN 'IHREZ_E'.
      lst_fld-seltext_l = 'Ship To Party - Your Reference'.
      lst_fld-seltext_m = 'Ship-to - Your Ref.'.
      lst_fld-seltext_s = 'ShpTo YRef'.
* End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
    WHEN 'ADDR1_SH'.
      lst_fld-seltext_l = 'Ship To Party Address-1'.
      lst_fld-seltext_m = 'Ship To Party Addr-1'.
      lst_fld-seltext_s = 'ShpTo Adr1'.
    WHEN 'ADDR2_SH'.
      lst_fld-seltext_l = 'Ship To Party Address-2'.
      lst_fld-seltext_m = 'Ship To Party Addr-2'.
      lst_fld-seltext_s = 'ShpTo Adr2'.
    WHEN 'ADDR3_SH'.
      lst_fld-seltext_l = 'Ship To Party Address-3'.
      lst_fld-seltext_m = 'Ship To Party Addr-3'.
      lst_fld-seltext_s = 'ShpTo Adr3'.
    WHEN 'ADDR4_SH'.
      lst_fld-seltext_l = 'Ship To Party Address-4'.
      lst_fld-seltext_m = 'Ship To Party Addr-4'.
      lst_fld-seltext_s = 'ShpTo Adr4'.
    WHEN 'CITY1_SH'.
      lst_fld-seltext_l = 'Ship To Party City'.
      lst_fld-seltext_m = 'Ship To Party City'.
      lst_fld-seltext_s = 'ShpTo City'.
    WHEN 'PSTLZ_SH'.
      lst_fld-seltext_l = 'Ship To Party Postal Code'.
      lst_fld-seltext_m = 'Ship To Party PostCd'.
      lst_fld-seltext_s = 'ShpToPstCd'.
*+Begin of Change NPALLA
    WHEN 'REGION_SH'.
      lst_fld-seltext_l = 'Ship To Party Region'.
      lst_fld-seltext_m = 'Ship To Party Region'.
      lst_fld-seltext_s = 'ShpToRegn'.
    WHEN 'REGION_TXT_SH'.
      lst_fld-seltext_l = 'Ship To Party Region'.
      lst_fld-seltext_m = 'Ship To Party Region'.
      lst_fld-seltext_s = 'ShpTo Reg'.
*+End of Change NPALLA
    WHEN 'LAND1_SH'.
      lst_fld-seltext_l = 'Ship To Party Cuntry'.
      lst_fld-seltext_m = 'Ship To Party Cuntry'.
      lst_fld-seltext_s = 'ShpToCntry'.
*+Begin of Change NPALLA
    WHEN 'LANDX_SH'.
      lst_fld-seltext_l = 'Ship To CountryDesc'.
      lst_fld-seltext_m = 'Ship To CountryDesc'.
      lst_fld-seltext_s = 'ShpToCntry'.
*+End of Change NPALLA
    WHEN 'EMAIL_SH'.
      lst_fld-seltext_l = 'Ship To Party Email ID'.
      lst_fld-seltext_m = 'Ship To Party Email'.
      lst_fld-seltext_s = 'ShpToEmail'.
    WHEN 'VOLUME_YR'.  "65
      lst_fld-seltext_l = 'Material Volume Year'.
      lst_fld-seltext_m = 'Mat Vol Year'.
      lst_fld-seltext_s = 'MatVolYear'.
    WHEN 'SOC_ACRNYM'.
      lst_fld-seltext_l = 'Society Acronym'.
      lst_fld-seltext_m = 'Society Acronym'.
      lst_fld-seltext_s = 'SocAcrnym'.
    WHEN 'CC_TYPE'.
      lst_fld-seltext_l = 'Credit Card Type'.
      lst_fld-seltext_m = 'Credit Card Type'.
      lst_fld-seltext_s = 'CrdtCrdTyp'.
    WHEN 'CMN_CUST_ID'.
      lst_fld-seltext_l = 'Common Customer ID'.
      lst_fld-seltext_m = 'Common Cust ID'.
      lst_fld-seltext_s = 'CmnCustID'.
    WHEN 'KDGRP'.
      lst_fld-seltext_l = 'Customer Group'.
      lst_fld-seltext_m = 'Customer Group'.
      lst_fld-seltext_s = 'Cust Grp'.
    WHEN 'PLTYP'.
      lst_fld-seltext_l = 'Price List Type'.
      lst_fld-seltext_m = 'Price List Type'.
      lst_fld-seltext_s = 'PrcLstTyp'.
    WHEN 'MWSBP'.
      lst_fld-cfieldname = 'WAERK'.
      lst_fld-ctabname   = fp_tabname.
    WHEN 'CANC_RESN'.
      lst_fld-seltext_l = 'Cancellation Reason'.
      lst_fld-seltext_m = 'Cancellation Reason'.
      lst_fld-seltext_s = 'Canc Resn'.
    WHEN 'ISSUES_SENT'.
      lst_fld-seltext_l = 'Issues Sent'.
      lst_fld-seltext_m = 'Issues Sent'.
      lst_fld-seltext_s = 'Issues Snt'.
    WHEN 'ISSUES_DUE'.
      lst_fld-seltext_l = 'Issues Due'.
      lst_fld-seltext_m = 'Issues Due'.
      lst_fld-seltext_s = 'Issues Due'.
    WHEN 'START_ISSUE'.
      lst_fld-seltext_l = 'Start Issue'.
      lst_fld-seltext_m = 'Start Issue'.
      lst_fld-seltext_s = 'Strt Issue'.
    WHEN 'LAST_ISSUE'.
      lst_fld-seltext_l = 'Last Issue'.
      lst_fld-seltext_m = 'Last Issue'.
      lst_fld-seltext_s = 'Last Issue'.
    WHEN 'NAME1_FA'.
      lst_fld-seltext_l = 'Frwd Agent Name'.
      lst_fld-seltext_m = 'Frwd Agent Name'.
      lst_fld-seltext_s = 'FAgnt Name'.
    WHEN 'ADDR1_FA'.
      lst_fld-seltext_l = 'Frwd Agent Address-1'.
      lst_fld-seltext_m = 'Frwd Agent Addr-1'.
      lst_fld-seltext_s = 'FAgnt Adr1'.
    WHEN 'ADDR2_FA'.
      lst_fld-seltext_l = 'Frwd Agent Address-2'.
      lst_fld-seltext_m = 'Frwd Agent Addr-2'.
      lst_fld-seltext_s = 'FAgnt Adr2'.
    WHEN 'ADDR3_FA'.
      lst_fld-seltext_l = 'Frwd Agent Address-3'.
      lst_fld-seltext_m = 'Frwd Agent Addr-3'.
      lst_fld-seltext_s = 'FAgnt Adr3'.
    WHEN 'ADDR4_FA'.
      lst_fld-seltext_l = 'Frwd Agent Address-4'.
      lst_fld-seltext_m = 'Frwd Agent Addr-4'.
      lst_fld-seltext_s = 'FAgnt Adr4'.
    WHEN 'CITY1_FA'.
      lst_fld-seltext_l = 'Frwd Agent City'.
      lst_fld-seltext_m = 'Frwd Agent City'.
      lst_fld-seltext_s = 'FAgnt City'.
    WHEN 'PSTLZ_FA'.
      lst_fld-seltext_l = 'Frwd Agent Postal Code'.
      lst_fld-seltext_m = 'Frwd Agent PostCd'.
      lst_fld-seltext_s = 'FAgntPstCd'.
    WHEN 'LAND1_FA'.
      lst_fld-seltext_l = 'Frwd Agent Cuntry'.
      lst_fld-seltext_m = 'Frwd Agent Cuntry'.
      lst_fld-seltext_s = 'FAgntCntry'.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  ENDCASE.
  APPEND lst_fld TO i_fcat.
  CLEAR : lst_fld.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_TITLE_TEXT
*&---------------------------------------------------------------------*
*       Get Title texts
*----------------------------------------------------------------------*
*      -->FP_SPRAS
*      -->FP_TITLE
*      <--FP_TITLE_TXT
*----------------------------------------------------------------------*
FORM f_get_title_text  USING    fp_spras
                                fp_title
                       CHANGING fp_title_txt.

* Get all the Title Texts
  IF i_tsad3t[] IS INITIAL.
    SELECT *
      FROM tsad3t
      INTO TABLE i_tsad3t
      WHERE langu = sy-langu.
    IF sy-subrc = 0.
      SORT i_tsad3t BY langu title.
    ENDIF.
  ENDIF.

  IF fp_spras IS NOT INITIAL.
    READ TABLE i_tsad3t INTO st_tsad3t WITH KEY langu = fp_spras
                                                title = fp_title
                                                BINARY SEARCH.
  ELSE.
    READ TABLE i_tsad3t INTO st_tsad3t WITH KEY langu = sy-langu
                                                title = fp_title
                                                BINARY SEARCH.
  ENDIF.
  IF sy-subrc = 0.
    fp_title_txt = st_tsad3t-title_medi.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_REGION_TEXT
*&---------------------------------------------------------------------*
*       Get the Retion Description Texts
*----------------------------------------------------------------------*
*      -->FP_LAND1
*      -->FP_REGION
*      -->FP_SPRAS
*      <--FP_REGION_TXT
*----------------------------------------------------------------------*
FORM f_get_region_text  USING    fp_land1
                                 fp_region
                                 fp_spras
                        CHANGING fp_region_txt.

  READ TABLE i_t005u INTO st_t005u WITH KEY spras = fp_spras
                                            land1 = fp_land1
                                            bland = fp_region
                                            BINARY SEARCH.
  IF sy-subrc = 0.
    fp_region_txt = st_t005u-bezei.
  ELSE.
    SELECT *
      FROM t005u
      APPENDING TABLE i_t005u
      WHERE spras = sy-langu
        AND land1 = fp_land1.
    IF sy-subrc = 0.
      SORT i_t005u BY spras land1 bland.
      READ TABLE i_t005u INTO st_t005u WITH KEY spras = fp_spras
                                                land1 = fp_land1
                                                bland = fp_region
                                                BINARY SEARCH.
      IF sy-subrc = 0.
        fp_region_txt = st_t005u-bezei.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215

* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_AUGRU
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_augru .
  IF s_augru-low IS NOT INITIAL.
    SELECT SINGLE
           augru  " Order reason
       FROM tvau " Sales Documents: Order Reasons
       INTO @DATA(lv_augru)
        WHERE augru IN @s_augru.
    IF sy-subrc NE 0.
      MESSAGE e000(zqtc_r2) WITH 'Invalid Order Reasons.'(002).
    ENDIF. " IF sy-subrc NE 0
  ENDIF.
ENDFORM.
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
*&---------------------------------------------------------------------*
*&      Form  F_GET_DELIVERY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_delivery .
  CLEAR : i_jkseflow,i_lips.
  IF i_jksesched IS NOT INITIAL.
*--*Get Release Orders Info
    SELECT nip,
           contract_vbeln,
           contract_posnr,
           issue,
           vbelnorder,
           posnrorder
           FROM jkseflow INTO TABLE @i_jkseflow
                        FOR ALL ENTRIES IN @i_jksesched
                        WHERE contract_vbeln = @i_jksesched-vbeln
                         AND contract_posnr = @i_jksesched-posnr
                         AND issue = @i_jksesched-issue.
    IF sy-subrc EQ 0 AND i_jkseflow IS NOT INITIAL.
      SORT i_jkseflow BY vbelnorder posnrorder.
*--*Get the Dlivery with PGI Complete
      SELECT a~vbeln,
             a~posnr,
             a~vgbel,
             a~vgpos,
* BOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
             b~wbsta
* EOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
             FROM lips AS a INNER JOIN vbup AS b ON a~vbeln = b~vbeln
                                            AND a~posnr = b~posnr
                             INTO TABLE @i_lips
                             FOR ALL ENTRIES IN @i_jkseflow
                             WHERE a~vgbel = @i_jkseflow-vbelnorder
                              AND  a~vgpos = @i_jkseflow-posnrorder.
* BOC by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
*                              AND b~wbsta = 'C'.
* EOC by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
      IF sy-subrc EQ 0.
        SORT i_lips BY vgbel vgpos.
      ENDIF.
* BOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
      SELECT mblnr,
             mjahr,
             zeile,
             kdauf,
             kdpos
        FROM mseg
        INTO TABLE @i_mseg
        FOR ALL ENTRIES IN @i_jkseflow
        WHERE kdauf = @i_jkseflow-vbelnorder
        AND kdpos = @i_jkseflow-posnrorder.

      IF sy-subrc EQ 0.
        SORT i_mseg BY kdauf kdpos.
      ENDIF.
* EOI by TDIMANTHA on 07-Jan-2021 for OTCM-25936: ED2K920782
      SORT i_jkseflow BY contract_vbeln contract_posnr issue.
    ENDIF.
  ENDIF.
ENDFORM.
* BOI by TDIMANTHA on 08-Dec-2020 for OTCM-25936: ED2K920782
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAK_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_vbak_new .

  DATA: lir_cedat TYPE /grcpi/gria_t_date_range,
        lir_csdat TYPE /grcpi/gria_t_date_range,
        lst_cedat TYPE /grcpi/gria_s_date_range, " Date Range
        lst_csdat TYPE /grcpi/gria_s_date_range. " Date Range

  IF NOT p_cstaf IS INITIAL
    AND NOT p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_bt.
    lst_csdat-low     = p_cstaf.
    lst_csdat-high    = p_cstat.
    APPEND lst_csdat TO lir_csdat.
  ELSEIF NOT p_cstaf IS INITIAL
    AND p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_eq.
    lst_csdat-low     = p_cstaf.
    APPEND lst_csdat TO lir_csdat.
  ENDIF. " IF NOT p_cstaf IS INITIAL

  IF NOT p_cendf IS INITIAL
    AND NOT p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_bt.
    lst_cedat-low     = p_cendf.
    lst_cedat-high    = p_cendt.
    APPEND lst_cedat TO lir_cedat.
  ELSEIF NOT p_cendf IS INITIAL
    AND p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_eq.
    lst_cedat-low     = p_cendf .
    APPEND lst_cedat TO lir_cedat.
  ENDIF. " IF NOT p_cendf IS INITIAL

  SELECT vbeln,    " Sales Document
           auart,    " Sales Document Type
           waerk,    " SD Document Currency
           vkorg,    " Sales Organization
           vkbur,    " Sales Office
           kunnr,    " Sold-to party
           erdat,    " Creation date
           lifsk,    " Delivery block
           faksk,    " Billing block
           posnr,    " Sales Document Item
           matnr,    " Material Number
           arktx,    " Material description
           netwr,    " Net value of the order item in document currency
           zzsubtyp, " Subscription Type
           zmeng,    " Target quantity in sales units
           zieme,    " Target quantity UoM
           mvgr1,    " Material group 1
           mvgr2,    " Material group 2
           mvgr3,    " Material group 3
           mvgr4,    " Material group 4
           mvgr5,    " Material group 5
           vposn,   " Sales Document Item
           vbegdat, " Contract start date
           venddat, " Contract end date
           bukrs_vf, " Company code to be billed
           vgbel,    " Document number of the reference document
           zzlicgrp, " License Group
           mwsbp,    " Tax amount in document currency
           werks,    " Plant
           vtweg,    " Distribution Channel
           spart,    " Division
           vkuegru,  " Reason for Cancellation of Contract
           uepos,     " Higher-level item in bill of material structures
           augru
      INTO TABLE @i_vbak
           FROM zqtc_sales_001
      FOR ALL ENTRIES IN @i_pay_inv
       WHERE  vbeln IN @s_saldoc
        AND   vbeln EQ @i_pay_inv-vbelv
        AND   posnr EQ @i_pay_inv-posnv
        AND   auart IN @s_doctyp
        AND   vkorg IN @s_vkorg
        AND   vkbur IN @s_vkbur
        AND   kunnr IN @s_kunnr
        AND   lifsk IN @s_lifsk
        AND   faksk IN @s_faksk
        AND   waerk IN @s_waerk " SD Document Currency / Payment Currency
        AND   mvgr5 IN @s_mvgr5 " Material group 5
        AND   matnr IN @s_matnum
       AND ( vbegdat IN @lir_csdat
       AND venddat IN @lir_cedat )
       AND bsark IN @s_bsark
       AND augru IN @s_augru.

  IF  sy-subrc EQ 0.

    IF cb_nocmp IS NOT INITIAL.
*     Fetch BOM Component Details
      DATA(li_vbak) = i_vbak[].

      SELECT vbeln,    " Sales Document
                   auart,    " Sales Document Type
                   waerk,    " SD Document Currency
                   vkorg,    " Sales Organization
                   vkbur,    " Sales Office
                   kunnr,    " Sold-to party
                   erdat,    " Creation date
                   lifsk,    " Delivery block
                   faksk,    " Billing block
                   posnr,    " Sales Document Item
                   matnr,    " Material Number
                   arktx,    " Material description
                   netwr,    " Net value of the order item in document currency
                   zzsubtyp, " Subscription Type
                   zmeng,    " Target quantity in sales units
                   zieme,    " Target quantity UoM
                   mvgr1,    " Material group 1
                   mvgr2,    " Material group 2
                   mvgr3,    " Material group 3
                   mvgr4,    " Material group 4
                   mvgr5,    " Material group 5
                   vposn,    " Sales Document Item
                   vbegdat,  " Contract start date
                   venddat,  " Contract end date
                   bukrs_vf, " Company code to be billed
                   vgbel,    " Document number of the reference document
                   zzlicgrp, " License Group
                   mwsbp,    " Tax amount in document currency
                   werks,    " Plant
                   vtweg,    " Distribution Channel
                   spart,    " Division
                   vkuegru,  " Reason for Cancellation of Contract
                   uepos,     " Higher-level item in bill of material structures
                   augru
         APPENDING TABLE @i_vbak
              FROM zqtc_sales_001
               FOR ALL ENTRIES IN @li_vbak
             WHERE vbeln EQ @li_vbak-vbeln
               AND uepos EQ @li_vbak-posnr
               AND bsark IN @s_bsark
               AND augru IN @s_augru.

      IF sy-subrc NE 0.
*         Nothing to do
      ENDIF.
    ENDIF. " IF cb_nocmp IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

  IF i_vbak[] IS NOT INITIAL.
    i_veda[] = i_vbak[].
    SORT i_vbak BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM i_vbak COMPARING vbeln posnr.
    SORT i_veda BY vbeln vposn.
    DELETE ADJACENT DUPLICATES FROM i_veda COMPARING vbeln vposn.

    SELECT * FROM tvaut INTO TABLE i_tvaut
       WHERE spras = sy-langu
       AND augru IN s_augru.
    IF sy-subrc = 0.
      SORT i_tvaut BY augru.
    ENDIF.
  ELSE. " ELSE -> IF i_vbak[] IS NOT INITIAL
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
    LEAVE LIST-PROCESSING .
  ENDIF. " IF i_vbak[] IS NOT INITIAL

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_PAYMENT_DETAILS_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_payment_details_new .

  CONSTANTS:
    lc_acc_typ_cust TYPE koart      VALUE 'D',                "Account Type: Customer
    lc_ref_trn_vbrk TYPE awtyp      VALUE 'VBRK',             "Reference Transaction
    lc_pstng_key    TYPE awtyp      VALUE 'BSCHL',            " ABAP: Name of Variant Variable
    lc_actvt        TYPE vorgn      VALUE 'SD00',
    lc_trsn         TYPE rmvct      VALUE '',
    lc_doccat       TYPE blart      VALUE 'RV'.

  DATA:
    lr_pstng_key   TYPE TABLE OF bbp_rng_bschl.

  DATA: lir_cedat TYPE /grcpi/gria_t_date_range,
        lir_csdat TYPE /grcpi/gria_t_date_range,
        lst_cedat TYPE /grcpi/gria_s_date_range, " Date Range
        lst_csdat TYPE /grcpi/gria_s_date_range. " Date Range

  IF NOT p_cstaf IS INITIAL
    AND NOT p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_bt.
    lst_csdat-low     = p_cstaf.
    lst_csdat-high    = p_cstat.
    APPEND lst_csdat TO lir_csdat.
  ELSEIF NOT p_cstaf IS INITIAL
    AND p_cstat IS INITIAL.
    lst_csdat-sign    = c_sign_i.
    lst_csdat-option  = c_opti_eq.
    lst_csdat-low     = p_cstaf.
    APPEND lst_csdat TO lir_csdat.
  ENDIF. " IF NOT p_cstaf IS INITIAL

  IF NOT p_cendf IS INITIAL
    AND NOT p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_bt.
    lst_cedat-low     = p_cendf.
    lst_cedat-high    = p_cendt.
    APPEND lst_cedat TO lir_cedat.
  ELSEIF NOT p_cendf IS INITIAL
    AND p_cendt IS INITIAL.
    lst_cedat-sign    = c_sign_i.
    lst_cedat-option  = c_opti_eq.
    lst_cedat-low     = p_cendf .
    APPEND lst_cedat TO lir_cedat.
  ENDIF. " IF NOT p_cendf IS INITIAL

  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>) WHERE param1 EQ lc_pstng_key.

    APPEND INITIAL LINE TO lr_pstng_key ASSIGNING FIELD-SYMBOL(<lst_inv_doc_cat>).
    <lst_inv_doc_cat>-sign   = <lst_constant>-sign.
    <lst_inv_doc_cat>-option = <lst_constant>-opti.
    <lst_inv_doc_cat>-low    = <lst_constant>-low.
    <lst_inv_doc_cat>-high   = <lst_constant>-high.

  ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lst_constant>)


*   Fetch Payment Details (through Invoice)
  SELECT vbfa~vbelv   " Preceding sales and distribution document
         vbfa~posnv   " Preceding item of an SD document
         vbfa~vbeln   " Subsequent sales and distribution document
         vbfa~posnn   " Subsequent item of an SD document
         vbfa~vbtyp_n " Document category of subsequent document
         bseg~bukrs   " Company Code
         bseg~belnr   " Accounting Document Number
         bseg~gjahr   " Fiscal Year
         bseg~buzei   " Number of Line Item Within Accounting Document
         bseg~augdt   " Clearing Date
*           bseg~vertn   " Contract Number
    FROM vbfa         " Sales Document Flow
   INNER JOIN vbrk    " Billing Document: Header Data
      ON vbrk~vbeln EQ vbfa~vbeln
     AND vbrk~fksto EQ space
   INNER JOIN bkpf    " Accounting Document Header
      ON bkpf~awtyp EQ lc_ref_trn_vbrk
     AND bkpf~awkey EQ vbrk~vbeln
   INNER JOIN bseg    " Accounting Document Segment
      ON bseg~bukrs EQ bkpf~bukrs
     AND bseg~belnr EQ bkpf~belnr
     AND bseg~gjahr EQ bkpf~gjahr
     AND bseg~koart EQ lc_acc_typ_cust
    INTO TABLE i_pay_inv
   WHERE bseg~augdt IN s_betdt
     AND bseg~vorgn EQ lc_actvt
*       AND vbfa~vbelv IN s_saldoc
     AND bseg~bewar EQ lc_trsn
     AND bseg~bschl IN lr_pstng_key
     AND vbfa~stufe  EQ space
     AND bkpf~blart EQ lc_doccat.

  IF sy-subrc EQ 0.
    SORT i_pay_inv BY vbelv posnv.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
* EOI by TDIMANTHA on 08-Dec-2020 for OTCM-25936: ED2K920782
