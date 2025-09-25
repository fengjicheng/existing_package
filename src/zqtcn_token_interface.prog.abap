*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_TOKEN_INTERFACE
* PROGRAM DESCRIPTION: Populate IDoc with sales data for each quantity
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE:   10/28/2016
* OBJECT ID: I0234
* TRANSPORT NUMBER(S): ED2K903212
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906772, ED2K906774
* REFERENCE NO: CR-555
* DEVELOPER: Writtick Roy (WROY)
* DATE: 16-JUN-2017
* DESCRIPTION: Legacy Material Number can be ISSN as well as ISBN
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910265, ED2K910267
* REFERENCE NO: ERP-5704
* DEVELOPER: Writtick Roy (WROY)
* DATE: 11-Jan-2018
* DESCRIPTION: Populate Item Category
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907343, ED1K907389
* REFERENCE NO: INC0195195
* DEVELOPER: Sayantan DAS(SAYANDAS)
* DATE: 17-MAY-2018
* DESCRIPTION: TOKEN ISSUE
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914157
* REFERENCE NO: ERP7489
* DEVELOPER: Nageswara(NPOLINA)
* DATE: 03-Jan-2019
* DESCRIPTION: Fix the issue of Failing Idocs for Tok Orders using legacy ISSN
*----------------------------------------------------------------------*
**********************************************************************
*                         TYPE DECLARATION                           *
**********************************************************************
* Type Declaration of Constant table
TYPES : BEGIN OF lty_vbak,
          vbeln TYPE vbeln_va, " Sales Document
          vkorg TYPE vkorg,    " Sales Organization
          vtweg TYPE vtweg,    " Distribution Channel
          spart TYPE spart,    " Division
          kunnr TYPE kunnr,    " Sold-to party
        END OF lty_vbak,

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

* Type declaration of VBAK
TYPES : BEGIN OF lty_xvbak2.
        INCLUDE STRUCTURE vbak. " Sales Document: Header Data
TYPES:  bstkd     TYPE vbkd-bstkd. " Customer purchase order number
TYPES:  kursk     TYPE vbkd-kursk. " Exchange Rate for Price Determination
TYPES:  zterm     TYPE vbkd-zterm. " Terms of Payment Key
TYPES:  incov     TYPE vbkd-incov. " Incoterms Version
TYPES:  inco1     TYPE vbkd-inco1. " Incoterms (Part 1)
TYPES:  inco2     TYPE vbkd-inco2. " Incoterms (Part 2)
TYPES:  inco2_l   TYPE vbkd-inco2_l. " Incoterms Location 1
TYPES:  inco3_l   TYPE vbkd-inco3_l. " Incoterms Location 2
TYPES:  prsdt     TYPE vbkd-prsdt. " Date for pricing and exchange rate
TYPES:  angbt     TYPE vbak-vbeln. " Sales Document
TYPES:  contk     TYPE vbak-vbeln. " Sales Document
TYPES:  kzazu     TYPE vbkd-kzazu. " Order Combination Indicator
TYPES:  fkdat     TYPE vbkd-fkdat. " Billing date for billing index and printout
TYPES:  fbuda     TYPE vbkd-fbuda. " Date on which services rendered
TYPES:  empst     TYPE vbkd-empst. " Receiving point
TYPES:  valdt     TYPE vbkd-valdt. " Fixed value date
TYPES:  kdkg1     TYPE vbkd-kdkg1. " Customer condition group 1
TYPES:  kdkg2     TYPE vbkd-kdkg2. " Customer condition group 2
TYPES:  kdkg3     TYPE vbkd-kdkg3. " Customer condition group 3
TYPES:  kdkg4     TYPE vbkd-kdkg4. " Customer condition group 4
TYPES:  kdkg5     TYPE vbkd-kdkg5. " Customer condition group 5
TYPES:  delco     TYPE vbkd-delco. " Agreed delivery time
TYPES:  abtnr     TYPE vbkd-abtnr. " Department number
TYPES:  dwerk     TYPE rv45a-dwerk. " Delivering Plant (Own or External)
TYPES:  angbt_ref TYPE vbkd-bstkd. " Customer purchase order number
TYPES:  contk_ref TYPE vbkd-bstkd. " Customer purchase order number
TYPES:  currdec   TYPE tcurx-currdec. " Number of decimal places
TYPES:  bstkd_e   TYPE vbkd-bstkd_e. " Ship-to Party's Purchase Order Number
TYPES:  bstdk_e   TYPE vbkd-bstdk_e. " Ship-to party's PO date
TYPES : END OF lty_xvbak2.

* Type declaration of VBAP
TYPES : BEGIN OF lty_xvbap2.
        INCLUDE STRUCTURE vbap. " Sales Document: Item Data
TYPES:  matnr_output(40) TYPE c,                 " Output(40) of type Character
        wmeng(18)        TYPE c,                 " Wmeng(18) of type Character
        lfdat            TYPE vbap-abdat,        " Reconciliation Date for Agreed Cumulative Quantity
        kschl            TYPE komv-kschl,        " Condition type
        kbtrg(16)        TYPE c,                 " Kbtrg(16) of type Character
        kschl_netwr      TYPE komv-kschl,        " Condition type
        kbtrg_netwr(16)  TYPE c,                 " Netwr(16) of type Character
        inco1            TYPE vbkd-inco1,        " Incoterms (Part 1)
        inco2            TYPE vbkd-inco2,        " Incoterms (Part 2)
        inco2_l          TYPE vbkd-inco2_l,      " Incoterms Location 1
        inco3_l          TYPE vbkd-inco3_l,      " Incoterms Location 2
        incov            TYPE vbkd-incov,        " Incoterms Version
        yantlf(1)        TYPE c,                 " Yantlf(1) of type Character
        prsdt            TYPE vbkd-prsdt,        " Date for pricing and exchange rate
        hprsfd           TYPE tvap-prsfd,        " Carry out pricing
        bstkd_e          TYPE vbkd-bstkd_e,      " Ship-to Party's Purchase Order Number
        bstdk_e          TYPE vbkd-bstdk_e,      " Ship-to party's PO date
        bsark_e          TYPE vbkd-bsark_e,      " Ship-to party purchase order type
        ihrez_e          TYPE vbkd-ihrez_e,      " Ship-to party character
        posex_e          TYPE vbkd-posex_e,      " Item Number of the Underlying Purchase Order
        lpnnr            TYPE vbak-vbeln,        " Sales Document
        empst            TYPE vbkd-empst,        " Receiving point
        ablad            TYPE vbpa-ablad,        " Unloading Point
        knref            TYPE vbpa-knref,        " Customer description of partner (plant, storage location)
        lpnnr_posnr      TYPE vbap-posnr,        " Sales Document Item
        kdkg1            TYPE vbkd-kdkg1,        " Customer condition group 1
        kdkg2            TYPE vbkd-kdkg2,        " Customer condition group 2
        kdkg3            TYPE vbkd-kdkg3,        " Customer condition group 3
        kdkg4            TYPE vbkd-kdkg4,        " Customer condition group 4
        kdkg5            TYPE vbkd-kdkg5,        " Customer condition group 5
        abtnr            TYPE vbkd-abtnr,        " Department number
        delco            TYPE vbkd-delco,        " Agreed delivery time
        angbt            TYPE vbak-vbeln,        " Sales Document
        angbt_posnr      TYPE vbap-posnr,        " Sales Document Item
        contk            TYPE vbak-vbeln,        " Sales Document
        contk_posnr      TYPE vbap-posnr,        " Sales Document Item
        angbt_ref        TYPE vbkd-bstkd,        " Customer purchase order number
        angbt_posex      TYPE vbap-posex,        " Item Number of the Underlying Purchase Order
        contk_ref        TYPE vbkd-bstkd,        " Customer purchase order number
        contk_posex      TYPE vbap-posex,        " Item Number of the Underlying Purchase Order
        config_id        TYPE e1curef-config_id, " External Configuration ID (Temporary)
        inst_id          TYPE e1curef-inst_id,   " Instance Number in Configuration
        kompp            TYPE tvap-kompp,        " Form delivery group and correlate BOM components
        currdec          TYPE tcurx-currdec,     " Number of decimal places
        curcy            TYPE e1edp01-curcy,     " Currency
        valdt            TYPE vbkd-valdt,        " Fixed value date
        valtg            TYPE vbkd-valtg,        " Additional value days
        vaddi(1)         TYPE c.                 " Vaddi(1) of type Character
TYPES : END OF lty_xvbap2.
**********************************************************************
*                     CONSTANT DECLARATION                           *
**********************************************************************
CONSTANTS : lc_e1edk01_seg TYPE edilsegtyp    VALUE 'E1EDK01',    " Segment type
            lc_e1edk02_seg TYPE edilsegtyp    VALUE 'E1EDK02',    " Segment type
            lc_e1edp19_seg TYPE edilsegtyp    VALUE 'E1EDP19',    " Segment type
*           Begin of ADD:CR#496:26-APR-2017:WROY:ED2K905681
            lc_e1edp01_seg TYPE edilsegtyp    VALUE 'E1EDP01',    " Segment type
*           End   of ADD:CR#496:26-APR-2017:WROY:ED2K905681
            lc_e1edp05_seg TYPE edilsegtyp    VALUE 'E1EDP05',    " Segment type
*           Begin of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
            lc_qualf_043   TYPE edi_qualfr    VALUE '043',        " IDOC qualifier: 043
*           End   of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
*           Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
            lc_item_cat    TYPE rvari_vnam    VALUE 'ITEM_CATEGORY', " ABAP: Name of Variant Variable
*           End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
*** BOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
            lc_g           TYPE vbtyp         VALUE 'G',
            lc_c           TYPE vbtyp_n       VALUE 'C',
*** EOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
            lc_idcode      TYPE rvari_vnam    VALUE 'IDCODETYPE', " ABAP: Name of Variant Variable
            lc_devid       TYPE zdevid        VALUE 'I0234'.      " Type of Identification Code


**********************************************************************
*                     DATA DECLARATION                               *
**********************************************************************
* Table Declaration:
* Begin of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
*DATA : li_const       TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0,
** Work area declaration:
*       lst_vbak       TYPE lty_vbak,   " VBAK structure
*       lst_const      TYPE lty_const,  " Constant structure declaration
* End   of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
* Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
STATICS : li_const    TYPE zcat_constants.
* Work area declaration:
DATA : lst_vbak       TYPE lty_vbak,   " VBAK structure
       lst_const      TYPE zcast_constant,  " Constant structure declaration
* End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
       lst_xvbap_st   TYPE lty_xvbap2, " VBAP structure declaration
       lst_e1edk01_st TYPE e1edk01,    " IDoc: Document header general data
       lst_e1edk02_st TYPE e1edk02,    " IDoc: Document header reference data
       lst_e1edp01_st TYPE e1edp01,    " IDoc: Document Item General Data
*      Begin of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
       lst_e1edp19_st TYPE e1edp19,    " IDoc: Document Item Object Identification
*      End   of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
       lst_xvbak_st   TYPE lty_xvbak2, " VBAK Structure
* Variable Declarion:
*      Begin of ADD:CR#496:26-APR-2017:WROY:ED2K905681
       lv_idoc_i0234  TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]',
*      End   of ADD:CR#496:26-APR-2017:WROY:ED2K905681
*** BOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
       lv_index_i0234 TYPE sytabix,
       lv_rfmng       TYPE rfmng,
*** EOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
       lv_devmntid    TYPE zdevid,        " For using WRICEF ID
       lv_idcode      TYPE ismidcodetype, " Type of Identification Code
       lv_mat_no      TYPE ismidentcode,  " Identification Code
       lv_bstkd       TYPE bstkd,         " Customer purchase order number
       lv_vbeln       TYPE vbeln_va.      " Sales Document

* Begin of ADD:CR#496:26-APR-2017:WROY:ED2K905681
FIELD-SYMBOLS:
  <li_idoc_rec_i0234> TYPE edidd_tt.
* End   of ADD:CR#496:26-APR-2017:WROY:ED2K905681

* Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
IF li_const[] IS INITIAL.
* Fetch Identification Code Type from constant table.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid
    IMPORTING
      ex_constants = li_const.
  SORT li_const BY devid param1 param2 low.
ENDIF.
* End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265

* Populate segments of the IDoc data
CASE segment-segnam.
  WHEN lc_e1edk01_seg.
    CLEAR lst_e1edk01_st.
    lst_e1edk01_st = segment-sdata.
    CLEAR lst_xvbak_st.
    lst_xvbak_st = dxvbak.
*   Passing BSART value to Order Type (AUART).
    lst_xvbak_st-auart = lst_e1edk01_st-bsart.
*   Populate VBAK structure
    dxvbak = lst_xvbak_st.

*   Begin of ADD:CR#496:26-APR-2017:WROY:ED2K905681
    ASSIGN (lv_idoc_i0234) TO <li_idoc_rec_i0234>.
    READ TABLE <li_idoc_rec_i0234> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_i0234>)
         WITH KEY segnam = lc_e1edk02_seg
*                 Begin of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
                  sdata(3) = lc_qualf_043.
*                 End   of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
    IF sy-subrc EQ 0.
*     Get the IDoc data into local work area to process further
      CLEAR lst_e1edk02_st.
      lst_e1edk02_st = <lst_idoc_rec_i0234>-sdata.
      IF lst_e1edk02_st-belnr IS NOT INITIAL.
*       Begin of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
*       SELECT vbeln,
*              posnr
*         FROM vbkd
*       End   of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
*       Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
*** BOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
*        SELECT d~vbeln,
*               d~posnr,
*               p~pstyv
*          FROM vbkd AS d INNER JOIN
*               vbap AS p
*            ON p~vbeln EQ d~vbeln
*           AND p~posnr EQ d~posnr
**       End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
*         UP TO 1 ROWS
*          INTO @DATA(lst_vbkd_i0234)
*         WHERE ihrez EQ @lst_e1edk02_st-belnr.
*        ENDSELECT.

        SELECT d~vbeln,
               d~posnr,
               p~pstyv,
               p~zmeng
          INTO TABLE @DATA(li_vbkd_i0234)
          FROM vbkd AS d INNER JOIN
               vbap AS p
            ON p~vbeln EQ d~vbeln
           AND p~posnr EQ d~posnr
         INNER JOIN vbak AS k
            ON k~vbeln EQ d~vbeln
         WHERE d~ihrez EQ @lst_e1edk02_st-belnr
           AND k~vbtyp EQ @lc_g.
        IF sy-subrc = 0 AND li_vbkd_i0234 IS NOT INITIAL.
          SORT li_vbkd_i0234 BY vbeln posnr.
*** Select Data from VBFA table
          SELECT vbelv,
                 posnv,
                 vbeln,
                 posnn,
                 rfmng
            FROM vbfa
            INTO TABLE @DATA(li_vbfa_i0234)
            FOR ALL ENTRIES IN @li_vbkd_i0234
            WHERE vbelv = @li_vbkd_i0234-vbeln
            AND   posnv = @li_vbkd_i0234-posnr
            AND   vbtyp_n = @lc_c.
          IF sy-subrc = 0.
            SORT li_vbfa_i0234 BY vbelv posnv.
          ENDIF.
        ENDIF.

*** Loop to check the quantity
        LOOP AT li_vbkd_i0234 INTO DATA(lst_vbkd_i0234).
          CLEAR: lv_rfmng.
          READ TABLE li_vbfa_i0234 TRANSPORTING NO FIELDS
            WITH KEY vbelv = lst_vbkd_i0234-vbeln
                     posnv = lst_vbkd_i0234-posnr
            BINARY SEARCH.
          IF sy-subrc = 0.
            lv_index_i0234 = sy-tabix.
            LOOP AT li_vbfa_i0234 INTO DATA(lst_vbfa_i0234) FROM lv_index_i0234.
              IF lst_vbfa_i0234-vbelv <> lst_vbkd_i0234-vbeln OR
                 lst_vbfa_i0234-posnv <> lst_vbkd_i0234-posnr.
                EXIT.
              ENDIF.
              lv_rfmng = lv_rfmng + lst_vbfa_i0234-rfmng.
            ENDLOOP.
          ENDIF.

          IF lst_vbkd_i0234-zmeng GT lv_rfmng.
            EXIT.
          ELSE.
            CLEAR: lst_vbkd_i0234.
            CONTINUE.
          ENDIF.
        ENDLOOP.

        IF lst_vbkd_i0234 IS NOT INITIAL.
          lst_e1edk02_st-belnr = lst_vbkd_i0234-vbeln.
          lst_e1edk02_st-posnr = lst_vbkd_i0234-posnr.
*** EOC BY SAYANDAS on 17-May-2018 for Token Issue in  ED1K907343
          <lst_idoc_rec_i0234>-sdata = lst_e1edk02_st.
          UNASSIGN: <lst_idoc_rec_i0234>.

          READ TABLE <li_idoc_rec_i0234> ASSIGNING <lst_idoc_rec_i0234>
               WITH KEY segnam = lc_e1edp01_seg.
          IF sy-subrc EQ 0.
            lst_e1edp01_st = <lst_idoc_rec_i0234>-sdata.
            lst_e1edp01_st-posex = lst_vbkd_i0234-posnr.
*           Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
*           Populate Item Category (if maintained)
            READ TABLE li_const INTO lst_const TRANSPORTING high
                 WITH KEY devid  = lc_devid
                          param1 = lc_item_cat
                          param2 = space
                          low    = lst_vbkd_i0234-pstyv
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_e1edp01_st-pstyv = lst_const-high.
            ENDIF.
*           End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
            <lst_idoc_rec_i0234>-sdata = lst_e1edp01_st.
            UNASSIGN: <lst_idoc_rec_i0234>.
          ENDIF.
*       Begin of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
        ELSE.
          DATA(lv_belnr) = lst_e1edk02_st-belnr.
          CLEAR: lst_e1edk02_st-belnr,
                 lst_e1edk02_st-posnr.

          <lst_idoc_rec_i0234>-sdata = lst_e1edk02_st.
          UNASSIGN: <lst_idoc_rec_i0234>.

*         Message: Reference document & does not exist
          MESSAGE e802(gc) WITH lv_belnr
          RAISING user_error.
*       End   of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
        ENDIF.
      ENDIF.
    ENDIF.
*   End   of ADD:CR#496:26-APR-2017:WROY:ED2K905681

  WHEN lc_e1edk02_seg.
*   Get the IDoc data into local work area to process further
    CLEAR lst_e1edk02_st.
    lst_e1edk02_st = segment-sdata.

    CLEAR lst_xvbak_st.
    lst_xvbak_st = dxvbak.

    CLEAR lv_vbeln.
    IF lst_e1edk02_st-belnr IS NOT INITIAL AND
*      Begin of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
       lst_e1edk02_st-qualf EQ lc_qualf_043.
*      End   of ADD:ABAP Dump:WROY:29-NOV-2017:ED2K909381
*     Add conversion exit to add leading zeros
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_e1edk02_st-belnr
        IMPORTING
          output = lv_vbeln.

*     Fetch sales related data from VBAK table
      SELECT SINGLE
             vbeln " Sales Document
             vkorg " Sales Organization
             vtweg " Distribution Channel
             spart " Division
             kunnr " Sold-to party
        FROM vbak  " Sales Document: Header Data
        INTO lst_vbak
        WHERE vbeln = lv_vbeln.

      IF sy-subrc EQ 0.
*       Populate Sales data in VBAK structure
        lst_xvbak_st-vkorg = lst_vbak-vkorg. " Sales Organisation
        lst_xvbak_st-vtweg = lst_vbak-vtweg. " Distribution Channel
        lst_xvbak_st-spart = lst_vbak-spart. " Division
        lst_xvbak_st-kunnr = lst_vbak-kunnr. " Sol-To-Party
        dxvbak = lst_xvbak_st.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_e1edk02_st-belnr IS NOT INITIAL

  WHEN lc_e1edp19_seg.

*   Begin of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
*   Get the IDoc data into local work area to process further
    CLEAR lst_e1edp19_st.
    lst_e1edp19_st = segment-sdata.
*   End   of ADD:CR#555:WROY:16-JUN-2017:ED2K906772

* Begin of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
** Fetch Identification Code Type from constant table.
*    SELECT devid       " Development ID
*           param1      " ABAP: Name of Variant Variable
*           param2      " ABAP: Name of Variant Variable
*           sign        " ABAP: ID: I/E (include/exclude values)
*           opti        " ABAP: Selection option (EQ/BT/CP/...)
*           low         " Lower Value of Selection Condition
*           high        " Upper Value of Selection Condition
*      FROM zcaconstant " Wiley Application Constant Table
*      INTO TABLE li_const
*      WHERE devid    = lc_devid
*        AND param1   = lc_idcode
*        AND activate = abap_true.
*
*    IF sy-subrc EQ 0.
**     Begin of DEL:CR#555:WROY:16-JUN-2017:ED2K906772
**     SORT li_const BY devid param1.
**     End   of DEL:CR#555:WROY:16-JUN-2017:ED2K906772
**     Begin of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
*      SORT li_const BY devid param1 param2.
**     End   of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
* End   of DEL:ERP-5704:WROY:11-Jan-2018:ED2K910265
* Begin of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
    IF li_const[] IS NOT INITIAL.
* End   of ADD:ERP-5704:WROY:11-Jan-2018:ED2K910265
*     Read constant table by development Id to get identification code
      READ TABLE li_const INTO lst_const WITH KEY devid  = lc_devid
                                                  param1 = lc_idcode
*     Begin of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
                                                  param2 = lst_e1edp19_st-qualf
*     End   of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
                                         BINARY SEARCH.

      IF sy-subrc EQ 0.
        lv_idcode = lst_const-low. " Type of Identification Code
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

*   Get the VBAP structure data into local work area to process further
    CLEAR lst_xvbap_st.
    lst_xvbap_st = dxvbap.
*   Begin of DEL:CR#555:WROY:16-JUN-2017:ED2K906772
*   lv_mat_no    = lst_xvbap_st-matnr. " Legacy Material Number
*   End   of DEL:CR#555:WROY:16-JUN-2017:ED2K906772
*   Begin of ADD:CR#555:WROY:16-JUN-2017:ED2K906772
    lv_mat_no    = lst_e1edp19_st-idtnr. " Legacy Material Number
*   End   of ADD:CR#555:WROY:16-JUN-2017:ED2K906772

*   Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lv_idcode          " Type of Identification Code
        im_legacy_material = lv_mat_no          " Legacy Material Number
      IMPORTING
        ex_sap_material    = lst_xvbap_st-matnr " SAP Material Number
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc EQ 0.
       dxvbap = lst_xvbap_st.
* SOC by  NPOLINA ERP7489 ED2K914157
       IF lst_xvbap_st-matnr IS INITIAL.
      SELECT SINGLE matnr
               INTO lst_xvbap_st-matnr
               FROM zqtc_order_token
              WHERE issn = lv_mat_no.
        IF sy-subrc EQ 0.
          dxvbap = lst_xvbap_st.
        ENDIF.
     ENDIF.
* EOC by  NPOLINA ERP7489 ED2K914157
    ENDIF. " IF sy-subrc EQ 0
ENDCASE.
