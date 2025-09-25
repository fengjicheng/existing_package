*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_REJCT_VBAK
* PROGRAM DESCRIPTION:Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-11-10
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903001
* REFERENCE NO: E074
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 23-Nov-2016
* DESCRIPTION: Add logic to implement the check if promo code is of one
*              time use. If yes then user can avail discount, otherwise
*              stop the transaction by throwing error message.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905909
* REFERENCE NO: ERP-2861
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-JUN-2017
* DESCRIPTION: Performance Fix
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906852
* REFERENCE NO: CR_449
* DEVELOPER: Srabanti Bose
* DATE:  23-JUN-2017
* DESCRIPTION: Add logic to populate delivery block and billing block
*              instead of scenario 3
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911310
* REFERENCE NO: ERP-6970
* DEVELOPER: Writtick Roy (WROY)
* DATE:  12-MAR-2018
* DESCRIPTION: Add logic to use Price Group for determining the blocks
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912632
* REFERENCE NO: ERP-6593
* DEVELOPER: Writtick Roy (WROY)
* DATE:  12-JUL-2018
* DESCRIPTION: Do not Block if Partner with relevant Partner Function
*              (New Column in the Custom table) exists
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908228
* REFERENCE NO: E104 / INC0204808
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  21-Aug-2018
* DESCRIPTION: Add logic to use validate PO Types/Customer group 1 to
*              be excluded from Blocking Logic (from zcaconstant table).
*----------------------------------------------------------------------**SOC by NPOLINA ERPM6593 code Reversal    ED2K917623
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917623
* REFERENCE NO: ERP-6593 Code Reversal
* DEVELOPER: NPOLINA
* DATE:  20-Feb-2020
* DESCRIPTION: ERP-6593 code reversal
*----------------------------------------------------------------------*
*****Internal Table/Type/varaible declaration
TYPES:BEGIN OF lty_kona,
        knuma TYPE knuma , " Agreement (various conditions grouped together)
*       Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
        boart TYPE boart, " Agreement type
*       End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
      END OF lty_kona,
*      Type Declaration of Constant table
      BEGIN OF lty_const,
        devid  TYPE zdevid,              " Development ID
        param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
        param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
        sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
        opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
        low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
        high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
      END OF lty_const.

* Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
*         Type Declaration for Promo Code
TYPES:  BEGIN OF lty_promo,
          vbeln   TYPE vbeln,  " Sales and Distribution Document Number
          vbtyp   TYPE vbtyp,  "  SD document category
          zzpromo TYPE zpromo, " Promo code
        END OF lty_promo,

*         Type Declaration for Rejection Reason
        BEGIN OF lty_rej_rsn,
          vbeln   TYPE vbeln_va, " Sales Document
          posnr   TYPE posnr_va, " Sales Document Item
          abgru   TYPE abgru_va, " Reason for rejection of quotations and sales orders
          zzpromo TYPE zpromo,   " Promo code
        END OF lty_rej_rsn,

*        Range Table declaration:
        BEGIN OF lty_promo_type,
          sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE boart,      " Agreement type
          high   TYPE boart,      " Agreement type
        END OF lty_promo_type.
*       End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001

*       Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
*       Range Table declaration:
TYPES:  BEGIN OF lty_po_type,
          sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE bsark,      " PO type
          high   TYPE bsark,      " PO type
        END OF lty_po_type.

TYPES:  BEGIN OF lty_cust_grp,
          sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE kvgr1,      " Customer group 1
          high   TYPE kvgr1,      " Customer group 1
        END OF lty_cust_grp.
*       End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228

DATA: lst_zqtc_auto_rej TYPE zqtc_auto_rej,                                                       " Work area for Auto rejection table
      li_zqtc_auto_rej  TYPE STANDARD TABLE OF zqtc_auto_rej INITIAL SIZE 0,                      " Internal table for auto Rejection table
      li_kona           TYPE TABLE OF lty_kona WITH NON-UNIQUE KEY primary_key COMPONENTS knuma , " table for agreement version
      li_kona_x         TYPE TABLE OF lty_kona WITH NON-UNIQUE KEY primary_key COMPONENTS knuma,  " table for agreement version
      li_cdshw          TYPE STANDARD TABLE OF cdshw INITIAL SIZE 0,                              " Change documents, formatting table
      lst_cdshw         TYPE  cdshw,                                                              " Work area
      li_cdhdr          TYPE STANDARD TABLE OF cdhdr INITIAL SIZE 0,                              " Internal table for change doc header
      lst_cdhdr         TYPE cdhdr,                                                               " Work area
      lst_const         TYPE  lty_const,
      lst_kona          TYPE lty_kona,
      lv_kdgrp          TYPE vbkd-kdgrp,                                                          " Variable for customer group
      lv_lifsk_bsark    TYPE lifsk,                                                               " Billing block variable for scenario 1
      lv_faksk_bsark    TYPE faksk,                                                               " Delivery block for scenario 2
      lv_lifsk_kdgrp    TYPE lifsk,                                                               " Billing block for scenario 2
      lv_faksk_kdgrp    TYPE faksk, "
      lv_abgru_bsark    TYPE abgru,                                                               " Rejection rule
      lv_abgru_kdgrp    TYPE abgru,                                                               " Rejection rule
** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
      lv_konda          TYPE konda, " Price group (customer)
** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*     Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
      li_constant       TYPE STANDARD TABLE OF lty_constant   INITIAL SIZE 0,  "
      lr_promo_type     TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
*     Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
      lr_promo_mbr      TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
      lr_promo_nmbr     TYPE STANDARD TABLE OF lty_promo_type INITIAL SIZE 0,
*     End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
      li_promo          TYPE STANDARD TABLE OF lty_promo      INITIAL SIZE 0,
      li_rej_rsn        TYPE STANDARD TABLE OF lty_rej_rsn    INITIAL SIZE 0,
*     Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
      lr_po_type        TYPE STANDARD TABLE OF lty_po_type    INITIAL SIZE 0,
      lst_po_type       TYPE lty_po_type,
      lr_cust_grp       TYPE STANDARD TABLE OF lty_cust_grp   INITIAL SIZE 0,
      lst_cust_grp      TYPE lty_cust_grp,
*     End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
      lst_promo         TYPE lty_promo,
      lst_rej_rsn       TYPE lty_rej_rsn,
      lst_promo_type    TYPE lty_promo_type,
      lst_constant      TYPE lty_constant. " Constant structure declaration
*     End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001

CONSTANTS: lc_devid       TYPE zdevid        VALUE 'E104',         " Type of Identification Code
           lc_abgru       TYPE rvari_vnam    VALUE 'ABGRU',        " ABAP: Name of Variant Variable
           lc_faksk       TYPE rvari_vnam    VALUE 'FAKSK',        " ABAP: Name of Variant Variable
           lc_lifsk       TYPE rvari_vnam    VALUE 'LIFSK',        " ABAP: Name of Variant Variable
           lc_netwr_lifsk TYPE rvari_vnam    VALUE 'NETWR_LAFSK',  " ABAP: Name of Variant Variable
           lc_netwr_faksk TYPE rvari_vnam    VALUE 'NETWR_FAKSK',  " ABAP: Name of Variant Variable
           lc_objekt      TYPE cdhdr-objectclas VALUE 'VERKBELEG', " Object class
*          Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
           lc_dev_id      TYPE zdevid        VALUE 'E074',    " Type of Identification Code
           lc_promocde    TYPE rvari_vnam    VALUE 'ZZPROMO', " Promotion code for variant variable
*          End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
*          Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
           lc_po_type     TYPE rvari_vnam    VALUE 'BSARK', " Promotion code for variant variable
           lc_cust_grp    TYPE rvari_vnam    VALUE 'KVGR1', " Customer group 1
*          End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
*          Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
           lc_member      TYPE rvari_vnam    VALUE 'MEMBER',     " Promotion code for variant variable
           lc_n_member    TYPE rvari_vnam    VALUE 'NON_MEMBER', " Promotion code for variant variable
*          End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
**Begin Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
           lc_faksk_01    TYPE rvari_vnam VALUE 'FAKSK_01', " ABAP: Name of Variant Variable
           lc_lifsk_01    TYPE rvari_vnam VALUE 'LIFSK_01'. " ABAP: Name of Variant Variable
**End Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852

* Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
* Fetch Identification Code Type from constant table.
* (ZCACONSTANT table is hit for the second time as the Dev. ID
* and Parameters are different from the above where clause

SELECT devid       " Development ID
       param1      " ABAP: Name of Variant Variable
       param2      " ABAP: Name of Variant Variable
       sign        " ABAP: ID: I/E (include/exclude values)
       opti        " ABAP: Selection option (EQ/BT/CP/...)
       low         " Lower Value of Selection Condition
       high        " Upper Value of Selection Condition
  FROM zcaconstant " Wiley Application Constant Table
  INTO TABLE li_constant
  WHERE devid    = lc_dev_id
    AND param1   = lc_promocde
    AND activate = abap_true.

IF sy-subrc EQ 0.
*   Put the promo code values in the range table.
  LOOP AT li_constant INTO lst_constant.
    lst_promo_type-sign   = lst_constant-sign.
    lst_promo_type-option = lst_constant-opti.
    lst_promo_type-low = lst_constant-low. " Z001/Z002/Z005
    lst_promo_type-high = lst_constant-high.
    APPEND lst_promo_type TO lr_promo_type.
*   Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    CASE lst_constant-param2.
      WHEN lc_member. "'MEMBER'
        APPEND lst_promo_type TO lr_promo_mbr.
      WHEN lc_n_member. "'NON_MEMBER'
        APPEND lst_promo_type TO lr_promo_nmbr.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
*   End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    CLEAR lst_promo_type.
  ENDLOOP. " LOOP AT li_constant INTO lst_constant
  CLEAR lst_promo_type.
ENDIF. " IF sy-subrc EQ 0
* End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001

* Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
* Fetch PO Type to be excluded from Blocking Logic from constant table.
* (ZCACONSTANT table is hit for the third time as the Dev. ID
* and Parameters are different from the above where clause).

SELECT devid       " Development ID
       param1      " ABAP: Name of Variant Variable
       param2      " ABAP: Name of Variant Variable
       sign        " ABAP: ID: I/E (include/exclude values)
       opti        " ABAP: Selection option (EQ/BT/CP/...)
       low         " Lower Value of Selection Condition
       high        " Upper Value of Selection Condition
  FROM zcaconstant " Wiley Application Constant Table
  INTO TABLE li_constant
  WHERE devid    = lc_devid
    AND ( param1   = lc_po_type OR param1   = lc_cust_grp )
    AND activate = abap_true.

IF sy-subrc EQ 0.
* Put the PO Type values in the range table.
  LOOP AT li_constant INTO lst_constant.
    CASE lst_constant-param1.
      WHEN lc_po_type.
        lst_po_type-sign   = lst_constant-sign.
        lst_po_type-option = lst_constant-opti.
        lst_po_type-low = lst_constant-low.
        lst_po_type-high = lst_constant-high.
        APPEND lst_po_type TO lr_po_type.
        CLEAR lst_po_type.
      WHEN lc_cust_grp.
        lst_cust_grp-sign   = lst_constant-sign.
        lst_cust_grp-option = lst_constant-opti.
        lst_cust_grp-low = lst_constant-low.
        lst_cust_grp-high = lst_constant-high.
        APPEND lst_cust_grp TO lr_cust_grp.
        CLEAR lst_cust_grp.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constant INTO lst_constant
  CLEAR lst_po_type.
ENDIF. " IF sy-subrc EQ 0
* End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228

**************Fetch data from custom table
SELECT mandt " client
       auart " Sales Document Type
       vkorg " Organization
       vtweg " Distribution Channel
       spart " Division
       bsark " Customer purchase order type
** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*       kdgrp         " Customer group 1
       konda " Price group (customer)
       kvgr1 " Customer group 1
** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
       lifsk         " Delivery block (document header)
       faksk         " Billing block in SD document
       abgru         " Reason for rejection of quotations and sales orders
*      Begin of ADD:ERP-6593:WROY:12-JUL-2018:ED2K912632
*       parvw         " Partner Function   *commented by NPOLINA ERPM6593 code Reversal    ED2K917623
*      End   of ADD:ERP-6593:WROY:12-JUL-2018:ED2K912632
  FROM zqtc_auto_rej " E104: Automatic Rejection Rule
  INTO TABLE li_zqtc_auto_rej
  WHERE auart = vbak-auart
  AND   vkorg = vbak-vkorg
  AND   vtweg = vbak-vtweg
  AND   spart = vbak-spart.

IF sy-subrc IS INITIAL.
  lst_cdhdr-objectclas = lc_objekt.
  lst_cdhdr-objectid  = vbak-vbeln.
  IF i_cdshw[] IS INITIAL AND  vbak-vbeln IS NOT INITIAL .


    CALL FUNCTION 'CHANGEDOCUMENT_READ_HEADERS'
      EXPORTING
        date_of_change    = lst_cdhdr-udate
        objectclass       = lst_cdhdr-objectclas "  class
        objectid          = lst_cdhdr-objectid
        time_of_change    = lst_cdhdr-utime
        username          = lst_cdhdr-username
      TABLES
        i_cdhdr           = li_cdhdr
      EXCEPTIONS
        no_position_found = 1
        OTHERS            = 2.
    IF sy-subrc = 0.
      LOOP AT li_cdhdr INTO lst_cdhdr.
        CLEAR li_cdshw.
        CALL FUNCTION 'CHANGEDOCUMENT_READ_POSITIONS'
          EXPORTING
            changenumber            = lst_cdhdr-changenr
          TABLES
            editpos                 = li_cdshw
          EXCEPTIONS
            no_position_found       = 1
            wrong_access_to_archive = 2
            OTHERS                  = 3.
        IF sy-subrc <> 0.
* do nothing
        ELSE. " ELSE -> IF sy-subrc <> 0
          APPEND LINES OF li_cdshw TO i_cdshw.
        ENDIF. " IF sy-subrc <> 0

      ENDLOOP. " LOOP AT li_cdhdr INTO lst_cdhdr

    ENDIF. " IF sy-subrc = 0

*Begin Of Change By MODUTTA on 22-Jun-2017 #TR:ED2K906852
    DATA(li_cdshw_faksk) = i_cdshw[].
    DELETE li_cdshw_faksk WHERE fname <> lc_faksk.
*End Of Change By MODUTTA on 22-Jun-2017 #TR:ED2K906852

    DELETE i_cdshw WHERE fname <> lc_lifsk.
  ENDIF. " IF i_cdshw[] IS INITIAL AND vbak-vbeln IS NOT INITIAL
* Begin of DEL:ERP-6970:WROY:12-Mar-2018:ED2K911310
*  IF vbak-bsark IS NOT INITIAL.
**& Binary search not used as there would be less no of entries
*    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej WITH KEY bsark = vbak-bsark
*** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
**                                                                kdgrp = space.
*                                                                 konda = space.
*** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*    IF sy-subrc IS INITIAL.
*      lv_lifsk_bsark = lst_zqtc_auto_rej-lifsk.
*      lv_faksk_bsark = lst_zqtc_auto_rej-faksk.
*      lv_abgru_bsark = lst_zqtc_auto_rej-abgru.
*
*** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*    ELSE. " ELSE -> IF sy-subrc IS INITIAL
*      READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej WITH KEY bsark = vbak-bsark
*                                                                  kvgr1 = space.
*      IF sy-subrc IS INITIAL.
*        lv_lifsk_bsark = lst_zqtc_auto_rej-lifsk.
*        lv_faksk_bsark = lst_zqtc_auto_rej-faksk.
*        lv_abgru_bsark = lst_zqtc_auto_rej-abgru.
*      ENDIF. " IF sy-subrc IS INITIAL
*** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF vbak-bsark IS NOT INITIAL
*
*
*  CLEAR: lv_kdgrp.
*  READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd_e104>)
*       WITH KEY vbeln = vbak-vbeln
*                posnr = posnr_low.
*  IF sy-subrc EQ 0.
*
** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*    lv_kdgrp = <lst_xvbkd_e104>-kdgrp.
*    lv_konda = <lst_xvbkd_e104>-konda.
*  ENDIF. " IF sy-subrc EQ 0
**  IF lv_kdgrp   IS INITIAL AND
**     knvv-kdgrp IS NOT INITIAL.
**    lv_kdgrp = knvv-kdgrp.
**  ENDIF. " IF lv_kdgrp IS INITIAL AND
**  IF lv_kdgrp IS NOT INITIAL.
**  IF lv_konda IS NOT INITIAL.
** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
*
***** Begin of change: SRBOSE: 27-JUN-2017: ED2K906739
**& Binary search not used as there would be less no of entries
**    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej WITH KEY bsark = space
**** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
***                                                               kdgrp = lv_kdgrp.
**                                                                konda = lv_konda.
**** End Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
**    IF sy-subrc IS INITIAL.
**      lv_lifsk_kdgrp = lst_zqtc_auto_rej-lifsk.
**      lv_faksk_kdgrp = lst_zqtc_auto_rej-faksk.
**      lv_abgru_kdgrp = lst_zqtc_auto_rej-abgru.
**    ENDIF. " IF sy-subrc IS INITIAL
*** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
**  ELSE. " ELSE -> IF lv_konda IS NOT INITIAL
*
***** End of change: SRBOSE: 27-JUN-2017: ED2K906739
*
*  IF vbak-kvgr1 IS NOT INITIAL.
*    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej WITH KEY bsark = space
*                                                                kvgr1 = vbak-kvgr1.
*
*    IF sy-subrc IS INITIAL.
*      lv_lifsk_kdgrp = lst_zqtc_auto_rej-lifsk.
*      lv_faksk_kdgrp = lst_zqtc_auto_rej-faksk.
*      lv_abgru_kdgrp = lst_zqtc_auto_rej-abgru.
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF vbak-kvgr1 IS NOT INITIAL
*** Begin Of Change By SRBOSE on 22-Feb-2017: E104 #TR:ED2K903001
* End   of DEL:ERP-6970:WROY:12-Mar-2018:ED2K911310
* Begin of ADD:ERP-6970:WROY:12-Mar-2018:ED2K911310
  SORT li_zqtc_auto_rej BY bsark konda kvgr1.

  READ TABLE xvbap ASSIGNING FIELD-SYMBOL(<lst_xvbap_e104>) INDEX 1.
  IF sy-subrc EQ 0.
    READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd_e104>)
         WITH KEY vbeln = vbak-vbeln
                  posnr = <lst_xvbap_e104>-posnr.
    IF sy-subrc NE 0.
      READ TABLE xvbkd ASSIGNING <lst_xvbkd_e104>
           WITH KEY vbeln = vbak-vbeln
                    posnr = posnr_low.
    ENDIF. " IF sy-subrc NE 0
    IF sy-subrc EQ 0.
      lv_konda = <lst_xvbkd_e104>-konda.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

* Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
IF vbak-bsark IN lr_po_type[] AND
   vbak-kvgr1 IN lr_cust_grp[].
* Skip Blocking Logic
ELSE.
* Check for Blockinng.
* End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
  CLEAR: lst_zqtc_auto_rej.
  READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej
       WITH KEY bsark = vbak-bsark
                konda = lv_konda
                kvgr1 = space
       BINARY SEARCH.
  IF sy-subrc NE 0.
    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej
         WITH KEY bsark = vbak-bsark
                  konda = space
                  kvgr1 = vbak-kvgr1
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc NE 0.
    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej
         WITH KEY bsark = vbak-bsark
                  konda = space
                  kvgr1 = space
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc NE 0.
    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej
         WITH KEY bsark = space
                  konda = lv_konda
                  kvgr1 = space
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc NE 0.
    READ TABLE li_zqtc_auto_rej INTO lst_zqtc_auto_rej
         WITH KEY bsark = space
                  konda = space
                  kvgr1 = vbak-kvgr1
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc EQ 0.
    lv_lifsk_bsark = lst_zqtc_auto_rej-lifsk.
    lv_faksk_bsark = lst_zqtc_auto_rej-faksk.
    lv_abgru_bsark = lst_zqtc_auto_rej-abgru.
*SOC by NPOLINA ERPM6593 code Reversal    ED2K917623
**   Begin of ADD:ERP-6593:WROY:12-JUL-2018:ED2K912632
*    IF lst_zqtc_auto_rej-parvw IS NOT INITIAL.
*      READ TABLE xvbpa TRANSPORTING NO FIELDS
*           WITH KEY vbeln = vbak-vbeln
*                    posnr = posnr_low
*                    parvw = lst_zqtc_auto_rej-parvw.
*      IF sy-subrc EQ 0.
*        CLEAR: lv_lifsk_bsark,
*               lv_faksk_bsark,
*               lv_abgru_bsark.
*      ENDIF.
*    ENDIF. " IF lst_zqtc_auto_rej-parvw IS NOT INITIAL
**   End   of ADD:ERP-6593:WROY:12-JUL-2018:ED2K912632
*EOC by NPOLINA ERPM6593 code Reversal     ED2K917623
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:ERP-6970:WROY:12-Mar-2018:ED2K911310
* Begin of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228
ENDIF.
* End of Change: NPALLA: 21-Aug-2018: E104:INC0204808 ED1K908228


*  ENDIF. " IF lv_konda IS NOT INITIAL
*& Checking if Scenario 1 has already been triggered
*& Binary search not used as there would be less no of entries
  IF v_lifsk_01 IS INITIAL.
    READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
                                               f_old = lv_lifsk_bsark.
    IF sy-subrc = 0.
      v_lifsk_01 = lv_lifsk_bsark.
    ELSE. " ELSE -> IF sy-subrc = 0
*& Binary search not used as there would be less no of entries
      READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
                                                 f_new = lv_lifsk_bsark.
      IF sy-subrc = 0.
        v_lifsk_01 = lv_lifsk_bsark.

      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF v_lifsk_01 IS INITIAL
*& Checking if Scenario 1 has already been triggered
  IF v_lifsk_02 IS INITIAL.
*& Binary search not used as there would be less no of entries
    READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
                                               f_old = lv_lifsk_kdgrp.
    IF sy-subrc = 0.
      v_lifsk_02 = lv_lifsk_kdgrp.
    ELSE. " ELSE -> IF sy-subrc = 0
*& Binary search not used as there would be less no of entries
      READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
                                                 f_new = lv_lifsk_kdgrp.
      IF sy-subrc = 0.
        v_lifsk_02 = lv_lifsk_kdgrp.

      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF v_lifsk_02 IS INITIAL

*& Scenario 1 and scenario 2
*& Passing Delivery Block( Purchase Order and Customer group scenario )

  IF   (  lv_lifsk_bsark IS NOT INITIAL   OR lv_lifsk_kdgrp IS NOT INITIAL )
    AND (  vbak-lifsk IS INITIAL ).
*       AND ( xvbak-lifsk NE lv_lifsk ) .
    IF  yvbak-lifsk IS INITIAL.
*& Scenrio1 did not happend and also scenario 2 did not happend in the past
      IF ( lv_lifsk_bsark IS NOT INITIAL ) AND ( v_lifsk_01 IS INITIAL AND v_lifsk_02 IS INITIAL ) .
        vbak-lifsk = lv_lifsk_bsark.
*& Once delivery block is set then set the global variable.
        v_lifsk_01 = lv_lifsk_bsark.

      ELSE. " ELSE -> IF ( lv_lifsk_bsark IS NOT INITIAL ) AND ( v_lifsk_01 IS INITIAL AND v_lifsk_02 IS INITIAL )
*& Scenario 2 also did not happend in the past
        IF v_lifsk_02 IS INITIAL.
          vbak-lifsk = lv_lifsk_kdgrp.
*& Once delivery block is set then set the global variable.
          v_lifsk_02 = lv_lifsk_kdgrp.
        ENDIF. " IF v_lifsk_02 IS INITIAL


      ENDIF. " IF ( lv_lifsk_bsark IS NOT INITIAL ) AND ( v_lifsk_01 IS INITIAL AND v_lifsk_02 IS INITIAL )

    ELSE. " ELSE -> IF yvbak-lifsk IS INITIAL
*& If the first condition is not met then block depending
      IF ( yvbak-lifsk NE lv_lifsk_bsark AND
           yvbak-lifsk NE lv_lifsk_kdgrp ).
        IF v_lifsk_01 IS INITIAL AND v_lifsk_02 IS INITIAL.
*& Pass the first block
          vbak-lifsk = lv_lifsk_bsark.
*& Once delivery block is set then set the global variable.
          v_lifsk_01 = lv_lifsk_bsark.

        ENDIF. " IF v_lifsk_01 IS INITIAL AND v_lifsk_02 IS INITIAL

      ELSE. " ELSE -> IF ( yvbak-lifsk NE lv_lifsk_bsark AND
        IF ( yvbak-lifsk NE lv_lifsk_kdgrp ) AND v_lifsk_02 IS INITIAL.
          vbak-lifsk = lv_lifsk_kdgrp.
*& Once delivery block is set then set the global variable.
          v_lifsk_02 = lv_lifsk_kdgrp.
        ENDIF. " IF ( yvbak-lifsk NE lv_lifsk_kdgrp ) AND v_lifsk_02 IS INITIAL
      ENDIF. " IF ( yvbak-lifsk NE lv_lifsk_bsark AND
    ENDIF. " IF yvbak-lifsk IS INITIAL
  ENDIF. " IF ( lv_lifsk_bsark IS NOT INITIAL OR lv_lifsk_kdgrp IS NOT INITIAL )
*& Passing Billing Block( Purchase Order and Customer group scenario )
  IF   (  lv_faksk_bsark IS NOT INITIAL   OR lv_faksk_kdgrp IS NOT INITIAL )
    AND (  vbak-faksk IS INITIAL ).
*       AND ( xvbak-lifsk NE lv_lifsk ) .
    IF  yvbak-faksk IS INITIAL.
      IF ( lv_faksk_bsark IS NOT INITIAL ) AND (  vbak-lifsk IS NOT INITIAL ).

        vbak-faksk = lv_faksk_bsark.
      ELSEIF lv_faksk_kdgrp IS  NOT INITIAL AND ( vbak-lifsk IS NOT INITIAL ).
        vbak-faksk = lv_faksk_kdgrp.
      ENDIF. " IF ( lv_faksk_bsark IS NOT INITIAL ) AND ( vbak-lifsk IS NOT INITIAL )

    ELSE. " ELSE -> IF yvbak-faksk IS INITIAL
*& If the first condition is not met then block depending
      IF ( yvbak-faksk NE lv_faksk_bsark AND
           yvbak-faksk NE lv_faksk_kdgrp ).
*& Pass the first block

        vbak-faksk = lv_faksk_bsark.

      ELSE. " ELSE -> IF ( yvbak-faksk NE lv_faksk_bsark AND
        IF ( yvbak-faksk NE lv_faksk_kdgrp ) .
          vbak-faksk = lv_faksk_kdgrp.
        ENDIF. " IF ( yvbak-faksk NE lv_faksk_kdgrp )

      ENDIF. " IF ( yvbak-faksk NE lv_faksk_bsark AND
    ENDIF. " IF yvbak-faksk IS INITIAL

  ENDIF. " IF ( lv_faksk_bsark IS NOT INITIAL OR lv_faksk_kdgrp IS NOT INITIAL )
ENDIF. " IF sy-subrc IS INITIAL
*& Scenario 5: Block orders due to incorrect promotion #
*& Validation for Promo code
*& Populating header promocode.

CLEAR: li_kona,lst_kona.
IF vbak-zzpromo IS NOT INITIAL .
  lst_kona-knuma = xvbak-zzpromo.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lst_kona-knuma
    IMPORTING
      output = lst_kona-knuma.
  APPEND lst_kona TO li_kona.
ENDIF. " IF vbak-zzpromo IS NOT INITIAL


LOOP AT xvbap.
  IF xvbap-zzpromo IS NOT INITIAL.
    lst_kona-knuma = xvbap-zzpromo.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_kona-knuma
      IMPORTING
        output = lst_kona-knuma.
    APPEND lst_kona TO li_kona.
    CLEAR lst_kona.
  ENDIF. " IF xvbap-zzpromo IS NOT INITIAL

ENDLOOP. " LOOP AT xvbap

*  Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
* Fetch Promo code values from VBAK table
CLEAR : li_promo,
        li_rej_rsn,
        lst_rej_rsn,
        lst_promo.

IF vbak-zzpromo IS NOT INITIAL.
* Fetch Promo Code from VBAk table.
  SELECT vbeln    " Sales Document
         vbtyp    " SD document category
         zzpromo  " Promo code
        FROM vbak " Sales Document: Header Data
        INTO TABLE li_promo
        WHERE zzpromo EQ vbak-zzpromo.
  IF sy-subrc EQ 0.
    SORT li_promo BY zzpromo.
* Fetch Rejection reason and promo Code from Item Table: VBAP
    SELECT vbeln   " Sales Document
           posnr   " Sales Document Item
           abgru   " Reason for rejection of quotations and sales orders
           zzpromo " Promo code
      INTO TABLE li_rej_rsn
      FROM vbap    " Sales Document: Item Data
      FOR ALL ENTRIES IN li_promo
      WHERE vbeln   = li_promo-vbeln
        AND zzpromo = li_promo-zzpromo.
    IF sy-subrc EQ 0.
      SORT li_rej_rsn BY zzpromo vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ELSEIF xvbap IS NOT INITIAL.
* Begin of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
  IF li_kona IS NOT INITIAL.
* End   of ADD:ERP-2861:WROY:20-JUN-2017:ED2K905909
*   Fetch Promo Code from VBAk table.
    SELECT vbeln    " Sales Document
           vbtyp    " SD document category
           zzpromo  " Promo code
          FROM vbak " Sales Document: Header Data
          INTO TABLE li_promo
          FOR ALL ENTRIES IN li_kona
          WHERE zzpromo EQ li_kona-knuma.
    IF sy-subrc EQ 0.
      SORT li_promo BY zzpromo.
    ENDIF. " IF sy-subrc EQ 0
*   Fetch Rejection reason and promo Code from Item Table: VBAP
    SELECT vbeln   " Sales Document
           posnr   " Sales Document Item
           abgru   " Reason for rejection of quotations and sales orders
           zzpromo " Promo code
      INTO TABLE li_rej_rsn
      FROM vbap    " Sales Document: Item Data
      FOR ALL ENTRIES IN li_kona
      WHERE zzpromo = li_kona-knuma.
    IF sy-subrc EQ 0.
      SORT li_rej_rsn BY zzpromo vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_kona IS NOT INITIAL
* End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
ENDIF. " IF vbak-zzpromo IS NOT INITIAL

CLEAR li_kona_x.
SORT  li_kona BY knuma.

IF li_kona[] IS NOT INITIAL.
  SELECT DISTINCT knuma
*   Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
                  boart  "
*   End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
    FROM kona
    INTO TABLE li_kona_x
    FOR ALL ENTRIES IN li_kona
    WHERE
    knuma EQ li_kona-knuma.
ENDIF. " IF li_kona[] IS NOT INITIAL

*& Validating Header Promo code
IF vbak-zzpromo IS NOT INITIAL.
  READ TABLE li_kona_x INTO lst_kona WITH TABLE KEY primary_key COMPONENTS knuma = vbak-zzpromo.
  IF sy-subrc <> 0.
    IF vbak-lifsk IS INITIAL .
      READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_lifsk BINARY SEARCH.
      IF sy-subrc = 0 .
        vbak-lifsk = lst_const-low.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF vbak-lifsk IS INITIAL
    IF vbak-faksk IS INITIAL .
      READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_faksk BINARY SEARCH.
      IF sy-subrc = 0 .
        vbak-faksk = lst_const-low.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF vbak-faksk IS INITIAL
* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  ELSE. " ELSE -> IF sy-subrc <> 0
    lv_boart = lst_kona-boart.
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  ENDIF. " IF sy-subrc <> 0
*    Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
*     If promo type is one time and document category is order (C)
*     then process further.
  IF lv_boart IS NOT INITIAL AND
     lv_boart NOT IN lr_promo_type. " Agreement Type/ Promo code is one time usuable
*   Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*   CLEAR lst_rej_rsn.
*   READ TABLE li_rej_rsn INTO lst_rej_rsn WITH KEY zzpromo = lst_promo-zzpromo
*                                                  BINARY SEARCH.
*   IF sy-subrc EQ 0.
*     IF lst_rej_rsn-abgru IS INITIAL.
*   End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
    MESSAGE e042(zqtc_r2). " You have entered one time promo code,Please use another!!!
*   Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*     ENDIF. " IF lst_rej_rsn-abgru IS INITIAL
*   ENDIF. " IF sy-subrc EQ 0
*   End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
  ENDIF. " IF lv_boart IS NOT INITIAL AND
*   End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001

ENDIF. " IF vbak-zzpromo IS NOT INITIAL

LOOP AT xvbap.
*& Validating Item Promocode
  IF xvbap-zzpromo IS NOT INITIAL.
    CLEAR lst_kona.
    READ TABLE li_kona_x INTO lst_kona WITH TABLE KEY primary_key COMPONENTS knuma = xvbap-zzpromo.

    IF sy-subrc <> 0.
      IF vbak-lifsk IS INITIAL .
        READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_lifsk BINARY SEARCH.
        IF sy-subrc = 0 .
          vbak-lifsk = lst_const-low.
        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF vbak-lifsk IS INITIAL
      IF vbak-faksk IS INITIAL .
        READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_faksk BINARY SEARCH.
        IF sy-subrc = 0 .
          vbak-faksk = lst_const-low.
        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF vbak-faksk IS INITIAL
*&    Rejecting text for Promo code
      IF xvbap-abgru IS INITIAL .
        READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_abgru BINARY SEARCH.
        IF sy-subrc = 0.
          xvbap-abgru = lst_const-low.
          MODIFY xvbap TRANSPORTING abgru.
        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF xvbap-abgru IS INITIAL
*   Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    ELSE. " ELSE -> IF sy-subrc <> 0
      lv_boart = lst_kona-boart.
*   End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
    ENDIF. " IF sy-subrc <> 0
*      Begin of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
*     If promo type is one time and document category is order (C)
*     then process further.
    IF lv_boart IS NOT INITIAL AND
       lv_boart NOT IN lr_promo_type. " Agreement Type/ Promo code is one time usuable
*     Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*     CLEAR lst_rej_rsn.
*     READ TABLE li_rej_rsn INTO lst_rej_rsn WITH KEY zzpromo = xvbap-zzpromo
*                                            BINARY SEARCH.
*     IF sy-subrc EQ 0.
*       IF lst_rej_rsn-abgru IS INITIAL.
*     End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*     Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
      IF xvbap-abgru IS INITIAL.
*     End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
        MESSAGE e042(zqtc_r2). " You have entered one time promo code,Please use another!!!
      ENDIF. " IF xvbap-abgru IS INITIAL
*     Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*     ENDIF. " IF sy-subrc EQ 0
*     End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
    ENDIF. " IF lv_boart IS NOT INITIAL AND

*  End of Change: PBOSE: 23-Nov-2016: E074:ED2K903001
  ENDIF. " IF xvbap-zzpromo IS NOT INITIAL

*Begin Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
*& Scenario 3: Block created order when changed due to price difference
  READ TABLE yvbap WITH KEY posnr = xvbap-posnr.
  IF sy-subrc = 0 AND xvbap-netwr <> yvbap-netwr.
    IF vbak-lifsk IS INITIAL .
      READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_netwr_lifsk BINARY SEARCH.
      IF sy-subrc = 0 .
        vbak-lifsk = lst_const-low.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF vbak-lifsk IS INITIAL
    IF vbak-faksk IS INITIAL .
      READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_netwr_faksk BINARY SEARCH.
      IF sy-subrc = 0 .
        vbak-faksk = lst_const-low.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF vbak-faksk IS INITIAL

  ENDIF. " IF sy-subrc = 0 AND xvbap-netwr <> yvbap-netwr

*Start of comment by MODUTTA
*  DATA: lv_delivery TYPE lifsk, " Delivery block (document header)
*        lv_billing  TYPE faksk. " Billing block in SD document
*
*  READ TABLE i_sub_tot INTO DATA(lst_sub_tot)
*     WITH KEY kposn = xvbap-posnr
*     BINARY SEARCH.
*  IF sy-subrc EQ 0 AND
*   ( lst_sub_tot-worke LT 0 OR
*     lst_sub_tot-workg LT 0 ).
***** For delivery block
*    CLEAR: lst_const.
*    READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_lifsk_01 BINARY SEARCH.
*    IF sy-subrc IS INITIAL.
*      lv_delivery = lst_const-low.
*    ENDIF. " IF sy-subrc IS INITIAL
*
***** For Billing Block
*    CLEAR: lst_const.
*    READ TABLE i_constant INTO lst_const WITH KEY param1 = lc_faksk_01 BINARY SEARCH.
*    IF sy-subrc IS INITIAL.
*      lv_billing = lst_const-low.
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF sy-subrc EQ 0 AND
**& Binary search not used as there would be less no of entries
*  IF v_delivery IS INITIAL.
*    READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
*                                               f_old = lv_delivery.
*    IF sy-subrc IS INITIAL.
*      v_delivery = lv_delivery.
*    ELSE. " ELSE -> IF sy-subrc IS INITIAL
**& Binary search not used as there would be less no of entries
*      READ TABLE i_cdshw INTO lst_cdshw WITH KEY fname = lc_lifsk
*                                                f_new = lv_delivery.
*      IF sy-subrc IS INITIAL.
*        v_delivery = lv_delivery.
*      ENDIF. " IF sy-subrc IS INITIAL
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF v_delivery IS INITIAL
*
*  IF v_billing IS INITIAL.
*    CLEAR lst_cdshw.
*    READ TABLE li_cdshw_faksk INTO lst_cdshw WITH KEY fname = lc_faksk
*                                                      f_old = lv_billing.
*    IF sy-subrc IS INITIAL.
*      v_billing = lv_billing.
*    ELSE. " ELSE -> IF sy-subrc IS INITIAL
**& Binary search not used as there would be less no of entries
*      READ TABLE li_cdshw_faksk INTO lst_cdshw WITH KEY fname = lc_faksk
*                                                        f_new = lv_billing.
*      IF sy-subrc IS INITIAL.
*        v_billing = lv_billing.
*      ENDIF. " IF sy-subrc IS INITIAL
*    ENDIF. " IF sy-subrc IS INITIAL
*  ENDIF. " IF v_billing IS INITIAL
*
****Passing Delivery Block
*  IF  lv_delivery IS NOT INITIAL AND  vbak-lifsk IS INITIAL.
*    IF yvbak-lifsk IS INITIAL.
*      IF lv_delivery IS NOT INITIAL AND v_delivery IS INITIAL.
*        vbak-lifsk = lv_delivery.
**& Once delivery block is set then set the global variable.
*        v_delivery = lv_delivery.
*      ENDIF. " IF lv_delivery IS NOT INITIAL AND v_delivery IS INITIAL
*    ELSE. " ELSE -> IF yvbak-lifsk IS INITIAL
**& If the first condition is not met then block depending
*      IF ( yvbak-lifsk NE lv_delivery ).
*        IF v_delivery IS INITIAL.
**& Pass the first block
*          vbak-lifsk = lv_delivery.
**& Once delivery block is set then set the global variable.
*          v_delivery = lv_delivery.
*        ENDIF. " IF v_delivery IS INITIAL
*      ENDIF. " IF ( yvbak-lifsk NE lv_delivery )
*    ENDIF. " IF yvbak-lifsk IS INITIAL
*    "Added by MODUTTA
*  ELSEIF lv_delivery IS NOT INITIAL AND vbak-lifsk IS NOT INITIAL.
**    If we want to change the VBAK-LIFSK with the same blocking as in constant
**    table then we will not be able to change it to the previous value
*    IF v_delivery IS NOT INITIAL AND vbak-lifsk EQ lv_delivery
*      AND yvbak-lifsk IS NOT INITIAL.
*      vbak-lifsk = yvbak-lifsk.
*      v_delivery = vbak-lifsk.
*      "For change in VBAK-LIFSK value first time after creation of the quotation
*    ELSEIF v_delivery IS INITIAL AND vbak-lifsk EQ lv_delivery.
*      vbak-lifsk = lv_delivery.
*      v_delivery = vbak-lifsk.
*    ENDIF. " IF v_delivery IS NOT INITIAL AND vbak-lifsk EQ lv_delivery
*  ENDIF. " IF lv_delivery IS NOT INITIAL AND vbak-lifsk IS INITIAL
**  End of addition
*
*****Passing Billing Block
*  IF lv_billing IS NOT INITIAL AND vbak-faksk IS INITIAL.
*    IF yvbak-faksk IS INITIAL.
*      IF lv_billing IS NOT INITIAL AND v_billing IS INITIAL.
*        vbak-faksk = lv_billing.
*        v_billing = vbak-faksk.
*      ENDIF. " IF ( lv_billing IS NOT INITIAL ) AND ( vbak-lifsk IS NOT INITIAL )
*    ELSE. " ELSE -> IF yvbak-faksk IS INITIAL
**& If the first condition is not met then block depending
*      IF ( yvbak-faksk NE lv_billing ).
**& Pass the first block
*        vbak-faksk = lv_billing.
*        v_billing = vbak-faksk.
*      ENDIF. " IF ( yvbak-faksk NE lv_billing )
*    ENDIF. " IF yvbak-faksk IS INITIAL
*    "Added by MODUTTA
*  ELSEIF lv_billing IS NOT INITIAL AND vbak-faksk IS NOT INITIAL.
**    If we want to change the VBAK-LIFSK with the same blocking as in constant
**    table then we will not be able to change it to the previous value
*    IF v_billing IS NOT INITIAL AND vbak-faksk EQ lv_billing
*      AND yvbak-faksk IS NOT INITIAL.
*      vbak-faksk = yvbak-faksk.
*      v_billing = vbak-faksk.
*      "For change in VBAK-LIFSK value first time after creation of the quotation
*    ELSEIF v_billing IS INITIAL AND vbak-faksk EQ lv_billing.
*      vbak-faksk = lv_billing.
*      v_billing = vbak-faksk.
*    ENDIF.
*  ENDIF. " IF lv_billing IS NOT INITIAL AND vbak-faksk IS INITIAL
**End Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
*Commented by MODUTTA

*& Scenario 4: Reject orders ( Populate Rejection text )
  IF ( vbak-lifsk = lv_lifsk_bsark AND
       lv_lifsk_bsark IS NOT INITIAL ).
    IF lv_abgru_bsark IS NOT INITIAL AND xvbap-abgru IS  INITIAL .
      xvbap-abgru = lv_abgru_bsark.
      MODIFY xvbap TRANSPORTING abgru.
    ENDIF. " IF lv_abgru_bsark IS NOT INITIAL AND xvbap-abgru IS INITIAL


  ELSEIF ( vbak-lifsk = lv_lifsk_kdgrp AND
           lv_lifsk_kdgrp IS NOT INITIAL ).
    IF lv_abgru_kdgrp IS NOT INITIAL  AND xvbap-abgru IS  INITIAL.
      xvbap-abgru = lv_abgru_kdgrp.
      MODIFY xvbap TRANSPORTING abgru.
    ENDIF. " IF lv_abgru_kdgrp IS NOT INITIAL AND xvbap-abgru IS INITIAL
  ENDIF. " IF ( vbak-lifsk = lv_lifsk_bsark AND

ENDLOOP. " LOOP AT xvbap
