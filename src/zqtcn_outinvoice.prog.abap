*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_OUTINVOICE
* PROGRAM DESCRIPTION: IDOC population for Invoice outbound
* DEVELOPER:           Shubanjali Sharma
* CREATION DATE:       02/10/2017
* OBJECT ID:           I0245
* TRANSPORT NUMBER(S):  ED2K904235
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910501
* REFERENCE NO: ERP-5935
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01/25/2018
* DESCRIPTION: Avoid execution of the same logic (E1EDP05) for the same
*              Line Item
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910593
* REFERENCE NO: CR#698
* DEVELOPER: SGUDA
* DATE:  01/30/2018
* DESCRIPTION: CR-698 : Adding fileds(ZSOLDTO_REF and ZSOLDTO_ITM) to
*                       strucure Z1QTC_ITEM and populate the same from
*                       Shipto/Sold to Refernce fields, VBKD-IHREZ
*                       VBAP-POSEX, VBKD-IHREZ_E, VBKD-POSEX_E
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K911088
* REFERENCE NO: CR-698 & CR-6120
* DEVELOPER: SGUDA
* DATE:  02/27/2018
* DESCRIPTION: CR-698 : As IS.
*              CR-6120: Add additional condition if VBTYP EQ 'N' send 'X'
*                       for historical credit memo
*----------------------------------------------------------------------*
* REVISION NO : ED2K921668                                             *
* REFERENCE NO: OTCM-29968                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 02/04/2021                                            *
* DESCRIPTION : INC0313695 -Knewton Customer: Follett Higher Education *
*               Group requires invoices via EDI                        *
*----------------------------------------------------------------------*
* Local types maintain
  TYPES:
    BEGIN OF lty_constant,
      devid  TYPE zdevid,                                      " Development ID
      param1 TYPE rvari_vnam,                                  " Name of Variant Variable
      param2 TYPE rvari_vnam,                                  " Name of Variant Variable
      srno   TYPE tvarv_numb,                                  " Current selection number
      sign   TYPE tvarv_sign,                                  " ID: I/E (include/exclude values)
      opti   TYPE tvarv_opti,                                  " Selection option (EQ/BT/CP/...)
      low    TYPE salv_de_selopt_low,                          " Lower Value of Selection Condition
      high   TYPE salv_de_selopt_high,                         " Higher Value of Selection Condition
    END OF lty_constant,
    BEGIN OF lty_vbtyp,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE vbtyp,                                       " Doc type
      high   TYPE vbtyp,                                       " Doc type
    END OF lty_vbtyp,

    BEGIN OF lty_mtart,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE mtart,                                       " Doc type
      high   TYPE mtart,                                       " Doc type
    END OF lty_mtart,
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    BEGIN OF lty_fkart,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE fkart,                                       " Doc type
      high   TYPE fkart,                                       " Doc type
    END OF lty_fkart,

    ltt_fkart TYPE STANDARD TABLE OF lty_fkart INITIAL SIZE 0,
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    BEGIN OF lty_vkbur,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE vkbur,                                       " Sales Office
      high   TYPE vkbur,                                       " Sales Office
    END OF lty_vkbur,

* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
    BEGIN OF lty_kschl_zekn,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE sna_kschl,                                   " Output type
      high   TYPE sna_kschl,                                   " output type
    END OF lty_kschl_zekn,
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *

    ltt_vkbur      TYPE STANDARD TABLE OF lty_vkbur INITIAL SIZE 0,
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    ltt_mtart      TYPE STANDARD TABLE OF lty_mtart INITIAL SIZE 0, " Material type
    ltt_vbtyp      TYPE STANDARD TABLE OF lty_vbtyp INITIAL SIZE 0, " Doc type
* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
    ltt_kschl_zekn TYPE STANDARD TABLE OF lty_kschl_zekn INITIAL SIZE 0.
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *

  DATA :
    li_constant    TYPE STANDARD TABLE OF
                lty_constant INITIAL SIZE 0, " Constant tab
    lr_vbtyp       TYPE ltt_vbtyp,             " Doc type
    lr_vbtyp_o     TYPE ltt_vbtyp,             " Doc type
    lr_autyp_gc    TYPE ltt_vbtyp,             " Doc type (Orders)
    lr_mtart       TYPE ltt_mtart,             " Material type
    lr_vbtyp_k     TYPE ltt_vbtyp,             " dOC TYPE
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    lr_fkart       TYPE ltt_fkart,             " Billing Doc type
    lst_fkart      TYPE lty_fkart,
    lr_vkbur       TYPE ltt_vkbur,             " Sales Office
    lst_vkbur      TYPE lty_vkbur,
*   Begin ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
    lr_vbtyp_n     TYPE ltt_vbtyp,             " dOC TYPE
*   End ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    lv_bsark_css   TYPE  bsark,                " PO type
    lv_bsark_wol   TYPE  bsark,                " PO type
    lv_bsark_pq    TYPE  bsark,                " PO type
    lst_mtart      TYPE lty_mtart,             " WA material type
    lst_vbtyp      TYPE lty_vbtyp,             " Doc type range table
* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
    lir_kschl_zekn TYPE ltt_kschl_zekn.       " Output type
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *

*Local Declaration
  DATA :

    lv_kschl_zcon    TYPE kscha , " Kschl_zcon Condition type
    lv_kschl_zacc    TYPE kscha , " Kschl_zacc Condition type
    lv_kschl_zhos    TYPE kscha , " Kschl_zhos Condition type
    lv_kschl_zcsa    TYPE kscha , " Kschl_zcsa Condition type
* Structure Declaration
    lst_e1edk01      TYPE e1edk01,      " Header general data
    lst_e1edk02      TYPE e1edk02,      " Header reference data
    lst_e1edk03      TYPE e1edk03,      " Header date segment
    lst_e1edp04      TYPE e1edp04,      " Item Taxes
    lst_e1edp01      TYPE e1edp01,      " Item General Data
    lst_e1edp02      TYPE e1edp02,      " Item General Data
    lst_e1edp19      TYPE e1edp19,      " Item Object Identification
    lst_e1edp01_temp TYPE e1edp01,      " Item General Data
    lst_edidd_n      TYPE edidd,        " Data record (IDoc)
    lst_e1edpa1      TYPE e1edpa1,      " Item partner information
    lst_z1qtc_header TYPE z1qtc_header, " Additional field for header
    lst_z1qtc_item   TYPE z1qtc_item,   " Additional field for Item
    lst_edidd        TYPE edidd,        " Data record (IDoc)
    lst_e1edp05      TYPE e1edp05,      " Item Conditions
*   Begin of ADD:CR#550:WROY:09-JUL-2017:ED2K907166
    lst_e1edka1      TYPE e1edka1,      " Partner information
*   End   of ADD:CR#550:WROY:09-JUL-2017:ED2K907166
    lst_e1edka1_zm   TYPE e1edka1,      " Partner information for ZM

* Variable Declaration
    lv_line          TYPE i,          " Line of type Integers
    lv_quantity      TYPE char15,     " Quantity
    lv_value         TYPE i,          " Quantity without Decimal
    lv_matnr         TYPE char35,     " Matnr of type CHAR35
    lv_posnr         TYPE posnr_vf,   " Item
    lv_journal       TYPE char1,      " Journal of type CHAR1
    lv_bismt         TYPE bismt,      " Old material number
    lv_abgru_vbap    TYPE abgru,      " Reason for rejection of quotations
    lv_mtart         TYPE mtart,      " Material Type
    lv_extwg         TYPE extwg,      " External Material Group
    lv_bsark         TYPE bsark,      " Customer purchase order type
    lv_flag_new      TYPE flag,       " Flag for Partner
    lv_kzwi6         TYPE kzwi6,      " Subtotal 6 from pricing procedure
    lv_netwr         TYPE netwr,      " Net Value in Document Currency
    lv_type_zwint    TYPE bu_id_type, " Identification Type
*   Begin of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
    lv_e1edp05_flag  TYPE flag,       " Flag: IDOC Segment - E1EDP05 " Siva
*   End   of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
*** BOC by SAYANDAS for ERP-2573 on 15th June 2017
    lv_inv_item      TYPE posnr_nach, " Subsequent item of an SD document
*** EOC by SAYANDAS for ERP-2573 on 15th June 2017
* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
    lv_type_zstore   TYPE bu_id_type. " Identification Type
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *


* Constant declaration
  CONSTANTS:
    lc_objid         TYPE zdevid VALUE 'I0245',            " Object id
    lc_vbtyp         TYPE rvari_vnam VALUE 'VBTYP',        " SD document category
    lc_autyp_g       TYPE rvari_vnam VALUE 'AUTYP',        " SD document category
    lc_mtart_zseb    TYPE rvari_vnam VALUE 'MTART',        " Material Type
    lc_koaid_b       TYPE rvari_vnam VALUE 'KOAID',        " Condition ID for Prices
    lc_vbtyp_o       TYPE rvari_vnam VALUE 'VBTYP_O',      " SD document category
    lc_vbtyp_k       TYPE rvari_vnam VALUE 'VBTYP_K',      " Credit Memo Request
    lc_bsark_pq      TYPE rvari_vnam VALUE 'BSARK_PQ',     " Purchase order type 0230
    lc_bsark_css     TYPE rvari_vnam VALUE 'BSARK_CSS',    " Purchase order type 0130
    lc_bsark_wol     TYPE rvari_vnam VALUE 'BSARK_WOL',    " Purchase Order Type 0300
    lc_kschl_zcon    TYPE rvari_vnam VALUE 'KSCHL_ZCON',   " zcon Condition type
    lc_kschl_zacc    TYPE rvari_vnam VALUE 'KSCHL_ZACC',   " zacc Condition type
    lc_kschl_zhos    TYPE rvari_vnam VALUE 'KSCHL_ZHOS',   " zhos Condition type
    lc_kschl_zcsa    TYPE rvari_vnam VALUE 'KSCHL_ZCSA',   " zcsa Condition type
    lc_type_zwint    TYPE rvari_vnam VALUE 'TYPE_ZWINT',   " Wintouch ID
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    lc_historical    TYPE rvari_vnam VALUE 'HISTORICAL',   " Historical
    lc_bill_catg     TYPE rvari_vnam VALUE 'BILL_CATEGORY', " Billing category
    ls_vkbur_hist    TYPE rvari_vnam VALUE 'VKBUR_HIST',    " Sales Office
*   Begin ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
    lc_vbtyp_n       TYPE rvari_vnam VALUE 'VBTYP_N',      " Credit Memo Request
*   End ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    lc_fkart_hist    TYPE rvari_vnam VALUE 'FKART_HIST',
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
    lc_qualf_009     TYPE edi_qualfr VALUE '009',          " Qualf_009
    lc_qualf_028     TYPE edi_qualfr VALUE '028',          " Qualf_028
    lc_qualf_016     TYPE edi_qualfr VALUE '016',          " Qualf_016
    lc_qualf_003     TYPE edi_qualfr VALUE '003',          " Qualf_003
    lc_qualf_002     TYPE edi_qualfr VALUE '002',          " Qualf_002
    lc_qualf_001     TYPE edi_qualfr VALUE '001',          " Qualf_001
    lc_mwskz_txc     TYPE edi5279_a VALUE 'TXC',           " Qualifier TXC
    lc_mwskz_txs     TYPE edi5279_a VALUE 'TXS',           " Qualifier TXS
    lc_mwskz_001     TYPE edi5279_a VALUE '001',           " Qualifier
    lc_mwskz_002     TYPE edi5279_a VALUE '002',           " Qualifier
    lc_mwskz_003     TYPE edi5279_a VALUE '003',           " Qualifier
    lc_mwskz         TYPE char1 VALUE '+',                 " Qualifier
    lc_posnr_low     TYPE posnr_va VALUE '000000',         " Line Item Number for Header
    lc_inv           TYPE char1 VALUE 'I',                 " Inv of type CHAR1
    lc_credit        TYPE char1 VALUE 'C',                 " Credit of type CHAR
*   Begin ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
    lc_credit_x      TYPE char1 VALUE 'X',                 " Credit of type CHAR
    lc_minus         TYPE char1 VALUE '-',                 " negative value for cancellations
*   End ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
    lc_parvw_sh      TYPE parvw VALUE 'SH',                " Ship to
    lc_parvw_sp      TYPE parvw VALUE 'AG',                " Sold to
    lc_parvw_we      TYPE parvw VALUE 'WE',                " Parvw_we of type CHAR2
    lc_parvw_zm      TYPE parvw VALUE 'ZM',                " Responsible person
    lc_zero          TYPE char1 VALUE '0',                 " Zero of type CHAR1
    lc_yes           TYPE char1 VALUE 'Y',                 " Yes of type CHAR1
    lc_no            TYPE char1 VALUE 'N',                 " No of type CHAR1
    lc_full_credit   TYPE char1 VALUE 'C',                 " Flag: Full Credit
    lc_part_credit   TYPE char1 VALUE 'P',                 " Flag: Partial Credit
    lc_custm_hdr_seg TYPE edilsegtyp VALUE 'Z1QTC_HEADER', " Custm_hdr_seg
    lc_custm_itm_seg TYPE edilsegtyp VALUE 'Z1QTC_ITEM',   " Custm_itm_seg
    lc_e1edk01       TYPE edilsegtyp VALUE 'E1EDK01',      " Segment E1EDK01
    lc_e1edk02       TYPE edilsegtyp VALUE 'E1EDK02',      " Segment E1EDK02
    lc_e1edk03       TYPE edilsegtyp VALUE 'E1EDK03',      " Segment E1EDK03
    lc_e1edp01       TYPE edilsegtyp VALUE 'E1EDP01',      " Segment E1EDP01
    lc_e1edp02       TYPE edilsegtyp VALUE 'E1EDP02',      " Segment E1EDP02
    lc_e1edp19       TYPE edilsegtyp VALUE 'E1EDP19',      " Segment E1EDP19
    lc_e1edp04       TYPE edilsegtyp VALUE 'E1EDP04',      " Segment E1EDP04
    lc_e1edp05       TYPE edilsegtyp VALUE 'E1EDP05',      " Segment E1EDP05
    lc_e1edpa1       TYPE edilsegtyp VALUE 'E1EDPA1',      " Segment E1EDPA1
    lc_e1edka1       TYPE edilsegtyp VALUE 'E1EDKA1',      " Segment E1EDKA1
* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
    lc_kschl_zekn    TYPE rvari_vnam VALUE 'KSCHL_ZEKN',   " Output type
    lc_type_zstore   TYPE rvari_vnam VALUE 'TYPE_ZSTORE'.  " Zstore value
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *


  FIELD-SYMBOLS :
    <lst_edidd_temp> TYPE edidd. " Data record (IDoc)

* Get the last line from EDIDD table and modify the same line if required
* Otherwise append new line to populate Custom header and item segments
  DESCRIBE TABLE int_edidd LINES lv_line.

  READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd>) INDEX lv_line.


********************To get Constant value***********************
* fetch constant table entry.
  SELECT devid        " Development ID
         param1       " ABAP: Name of Variant Variable
         param2       " ABAP: Name of Variant Variable
         srno         " ABAP: Current selection number
         sign         " ABAP: ID: I/E (include/exclude values)
         opti         " ABAP: Selection option (EQ/BT/CP/...)
         low          " Lower Value of Selection Condition
         high         " Higher Value of Selection Condition
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE li_constant
     WHERE devid    EQ lc_objid
     AND activate EQ abap_true.

  IF sy-subrc EQ 0.
    SORT li_constant BY devid param1 param2 low.
  ENDIF. " IF sy-subrc EQ 0

* Loop to populate range table / variables
  LOOP AT li_constant INTO DATA(lst_constant).
    CASE lst_constant-param1.

      WHEN lc_vbtyp.

        lst_vbtyp-sign = lst_constant-sign .
        lst_vbtyp-option = lst_constant-opti.
        lst_vbtyp-low = lst_constant-low.
        APPEND lst_vbtyp TO lr_vbtyp. " Invoic /Debit mem/Intercompany invoice
        CLEAR lst_vbtyp.

      WHEN lc_vbtyp_o.

        lst_vbtyp-sign = lst_constant-sign .
        lst_vbtyp-option = lst_constant-opti.
        lst_vbtyp-low = lst_constant-low.
        APPEND lst_vbtyp TO lr_vbtyp_o. " Credit memo/Inter company Credit memo
        CLEAR lst_vbtyp.

      WHEN lc_vbtyp_k.
        lst_vbtyp-sign = lst_constant-sign .
        lst_vbtyp-option = lst_constant-opti.
        lst_vbtyp-low = lst_constant-low.
        APPEND lst_vbtyp TO lr_vbtyp_k. " Credit memo
        CLEAR lst_vbtyp.
*   Begin ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
      WHEN lc_vbtyp_n.
        lst_vbtyp-sign = lst_constant-sign .
        lst_vbtyp-option = lst_constant-opti.
        lst_vbtyp-low = lst_constant-low.
        APPEND lst_vbtyp TO lr_vbtyp_n. " Credit memo
        CLEAR lst_vbtyp.
*   End ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
      WHEN lc_mtart_zseb.

        lst_mtart-sign = lst_constant-sign .
        lst_mtart-option = lst_constant-opti.
        lst_mtart-low = lst_constant-low.
        APPEND lst_mtart TO lr_mtart. " Material type
        CLEAR lst_mtart.

      WHEN lc_bsark_css.
        lv_bsark_css = lst_constant-low. " PO TYPE

      WHEN lc_bsark_wol.

        lv_bsark_wol = lst_constant-low. " PO TYPE

      WHEN lc_bsark_pq.
        lv_bsark_pq = lst_constant-low. " PO TYPE

      WHEN lc_kschl_zcon.
        lv_kschl_zcon = lst_constant-low. " Condition type

      WHEN lc_kschl_zacc.
        lv_kschl_zacc = lst_constant-low. " Condition type

      WHEN lc_kschl_zhos.
        lv_kschl_zhos = lst_constant-low. " Condition type

      WHEN lc_kschl_zcsa.
        lv_kschl_zcsa = lst_constant-low. " Condition type

      WHEN lc_autyp_g.
        lst_vbtyp-sign = lst_constant-sign .
        lst_vbtyp-option = lst_constant-opti.
        lst_vbtyp-low = lst_constant-low.
        lst_vbtyp-high = lst_constant-high.
        APPEND lst_vbtyp TO lr_autyp_gc. " Contract / Orders
        CLEAR lst_vbtyp.

*      WHEN lc_koaid_b.
*        lv_koaid_b = lst_constant-low. " Price condition
      WHEN lc_type_zwint.
        lv_type_zwint = lst_constant-low. " Indentification type
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      WHEN lc_fkart_hist.
        lst_fkart-sign   = lst_constant-sign .
        lst_fkart-option = lst_constant-opti.
        lst_fkart-low    = lst_constant-low.
        APPEND lst_fkart TO lr_fkart. " Billing Doc type
        CLEAR lst_fkart.
      WHEN ls_vkbur_hist.
        lst_vkbur-sign   = lst_constant-sign .
        lst_vkbur-option = lst_constant-opti.
        lst_vkbur-low    = lst_constant-low.
        APPEND lst_vkbur TO lr_vkbur. " Billing Doc type
        CLEAR lst_vkbur.
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
      WHEN lc_kschl_zekn.     " ZEKN output type
        APPEND INITIAL LINE TO lir_kschl_zekn ASSIGNING FIELD-SYMBOL(<lfs_kschl_zekn>).
        <lfs_kschl_zekn>-sign   = lst_constant-sign.
        <lfs_kschl_zekn>-option = lst_constant-opti.
        <lfs_kschl_zekn>-low    = lst_constant-low.
        <lfs_kschl_zekn>-high   = lst_constant-high.
      WHEN lc_type_zstore.          " Zstore Id type
        lv_type_zstore = lst_constant-low.
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
      WHEN OTHERS.
    ENDCASE.

    CLEAR : lst_constant.
  ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)

********************To get Constant value***********************

  CASE <lst_edidd>-segnam.
***************************************************
****************E1EDK01****************************
***************************************************

    WHEN lc_e1edk01. " 'E1EDK01'.
*   Obtain details in work area to append the custom segment
      lst_e1edk01 = <lst_edidd>-sdata.

*   Currency
      lst_e1edk01-curcy = xvbdkr-waerk.
*     Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      CLEAR: lst_constant.
      READ TABLE li_constant INTO lst_constant
           WITH KEY param1 = lc_historical
                    param2 = lc_bill_catg
                    low    = xvbdkr-fkart
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_e1edk01-fktyp = lst_constant-high.
      ELSE.
*     End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
*   Invoice /Credit
        IF xvbdkr-vbtyp IN lr_vbtyp. " M/P/5
          lst_e1edk01-fktyp = lc_inv. "Value I
        ELSEIF xvbdkr-vbtyp IN lr_vbtyp_o. " O/6
          lst_e1edk01-fktyp = lc_credit. "Value C
*   Begin ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
        ELSEIF xvbdkr-vbtyp IN lr_vbtyp_n. " N
          lst_e1edk01-fktyp = lc_credit_x. "Value X
*   End ADD:CR-698 & CR-6120:SGUDA:27-Feb-2018:ED2K911088
        ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp
*     Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      ENDIF.
*     End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      " BOC by ARABANERJE on 17th April,2017 for I0351
*      <lst_edidd>-sdata = lst_e1edk01. " Line modified
      " EOC by ARABANERJE on 17th April,2017 for I0351

*   Purchase Order Type
      IF xvbdkr-vbeln_vkt IS NOT INITIAL.
        DATA(lv_ref_doc) = xvbdkr-vbeln_vkt.
      ELSEIF xvbdkr-vbeln_vauf IS NOT INITIAL.
        lv_ref_doc = xvbdkr-vbeln_vauf.
      ENDIF. " IF xvbdkr-vbeln_vkt IS NOT INITIAL
* Populate PO type whatever value comes from VBKD
* TIBCO will format it based on value
      SELECT bsark " Customer purchase order type
        FROM vbkd  " Sales Document: Business Data
        INTO lv_bsark
        UP TO 1 ROWS
        WHERE vbeln = lv_ref_doc.
*        WHERE vbeln = dobject-objky.
      ENDSELECT.
      IF sy-subrc = 0.
        lst_z1qtc_header-bsark = lv_bsark.
      ENDIF. " IF sy-subrc = 0
      " BOC by ARABANERJE on 17th April,2017 for I0351
*   SAP Invoice Sts
      SELECT SINGLE vbeln, " Billing Document
        rfbsk,             " Status for transfer to accounting
        zzlicgrp           " License Group
*        INTO lv_rfbsk
        INTO @DATA(lst_rfbsk)
        FROM vbrk " Billing Document: Header Data
        WHERE vbeln = @dobject-objky+0(10).
      IF sy-subrc = 0.
        lst_e1edk01-belnr = lst_rfbsk-vbeln.
        lst_z1qtc_header-rfbsk = lst_rfbsk-rfbsk.
* License Population : I0351
        lst_z1qtc_header-zzlicgrp = lst_rfbsk-zzlicgrp.
      ENDIF. " IF sy-subrc = 0
      " EOC by ARABANERJE on 17th April,2017 for I0351

*   Invoice Amount
      IF xvbdkr-vbtyp IN lr_vbtyp. " M/P/5
        lst_z1qtc_header-znetwr = xvbdkr-netwr.
        CONDENSE lst_z1qtc_header-znetwr.
*   Begin ADD:CR-698 & CR-6120:RKUMAR2 :05-Mar-2018:ED2K911088
      ELSEIF xvbdkr-vbtyp IN lr_vbtyp_n. " N
        lst_z1qtc_header-znetwr = xvbdkr-netwr.
        CONDENSE lst_z1qtc_header-znetwr.
        CONCATENATE lc_minus lst_z1qtc_header-znetwr INTO lst_z1qtc_header-znetwr.
        " cancellations must be sent with '-' (minus) amounts
*   End ADD:CR-698 & CR-6120:RKUMAR2 :05-Mar-2018:ED2K911088
      ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp

*   Sales Organization
      lst_z1qtc_header-vkorg = xvbdkr-vkorg.

      " BOC by ARABANERJE on 17th April,2017 for I0351
      <lst_edidd>-sdata = lst_e1edk01. " Line modified
      " EOC by ARABANERJE on 17th April,2017 for I0351

      lst_edidd_n-sdata = lst_z1qtc_header.
      lst_edidd_n-segnam = lc_custm_hdr_seg. " Value 'Z1QTC_HEADER'.
      APPEND  lst_edidd_n TO int_edidd. " NEW line added

***************************************************
****************E1EDKA1****************************
***************************************************

    WHEN lc_e1edka1. " 'E1EDKA1'.
*     Begin of ADD:CR#550:WROY:09-JUL-2017:ED2K907166
      lst_e1edka1 = <lst_edidd>-sdata.      " Partner information
      IF lst_e1edka1-parvw EQ lc_parvw_sp.
        SELECT idnumber " Identification Number
          FROM but0id   " BP: ID Numbers
         UP TO 1 ROWS
          INTO lst_e1edka1-ilnnr
         WHERE partner EQ lst_e1edka1-partn
           AND type    EQ lv_type_zwint.
        ENDSELECT.
      ENDIF. " IF lst_e1edpa1-parvw EQ lc_parvw_we

      <lst_edidd>-sdata = lst_e1edka1. " Line is modified
*     End   of ADD:CR#550:WROY:09-JUL-2017:ED2K907166

******Begin of change ZIRA 1649 on 10/03/2017*******************
      DATA(li_edidd) = int_edidd[].
      DELETE li_edidd WHERE segnam NE lc_e1edka1.

      LOOP AT li_edidd INTO DATA(lst_partner).
        lst_e1edka1_zm = lst_partner-sdata.
        IF lst_e1edka1_zm-parvw = lc_parvw_zm.
          lv_flag_new = abap_true.
        ENDIF. " IF lst_e1edka1_zm-parvw = lc_parvw_zm
      ENDLOOP. " LOOP AT li_edidd INTO DATA(lst_partner)

* LV_FLAG_NEW = 'X' , segment is already available in IDOC
* If not , then append this value in IDOC
      IF lv_flag_new NE abap_true. " Responsible person
*****End of change ZIRA 1649 on 10/03/2017*******************
        lst_e1edka1_zm-parvw = lc_parvw_zm.
*   Person ID who created Invoice/Credit
        lst_e1edka1_zm-name1 = xvbdkr-ernam.

*   Name of the Person who created
        SELECT
        usr21~bname,      " Username
        usr21~persnumber, " Person number
        adrp~name_first,  " Firt Name
        adrp~name_last    " Last name
        INTO @DATA(lst_name)
        UP TO 1 ROWS
        FROM usr21        " User Name/Address Key Assignment
        INNER JOIN adrp   " Persons (Business Address Services)
        ON adrp~persnumber = usr21~persnumber
        WHERE usr21~bname = @xvbdkr-ernam.
        ENDSELECT.
        IF sy-subrc = 0.
          CONCATENATE lst_name-name_first
          lst_name-name_last
          INTO  lst_e1edka1_zm-name2
          SEPARATED BY space.

        ENDIF. " IF sy-subrc = 0

*****Begin of change ZIRA 1649 on 10/03/2017*******************
        lst_edidd_n-segnam = lc_e1edka1.
        lst_edidd_n-sdata = lst_e1edka1_zm.
        APPEND  lst_edidd_n TO int_edidd. " NEW line added
      ENDIF. " IF lv_flag_new NE abap_true
*****End of change ZIRA 1649 on 10/03/2017*******************

***************************************************
****************E1EDK02****************************
***************************************************

    WHEN lc_e1edk02. " 'E1EDK02'.
      lst_e1edk02 = <lst_edidd>-sdata.

      " BOC by ARABANERJE on 17th April,2017 for I0351
*  Billing Date
      IF lst_e1edk02-qualf = lc_qualf_002.
*       Posting Period
        lst_e1edk02-datum = xvbdkr-fkdat.
        <lst_edidd>-sdata = lst_e1edk02.
        CLEAR lst_e1edk02.
      ENDIF. " IF lst_e1edk02-qualf = lc_qualf_002
      " EOC added by ARABANERJE on 17th April,2017 for I0351

*  Credit Memo
      IF lst_e1edk02-qualf = lc_qualf_028.
*     If record exists with qualifier 028, update the credit memo
        IF xvbdkr-vbtyp IN lr_vbtyp_o. " O/6
          lst_e1edk02-belnr = dobject-objky+0(10).
        ELSE. " ELSE -> IF xvbdkr-vbtyp IN lr_vbtyp_o
          CLEAR lst_e1edk02-belnr.
        ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp_o
        <lst_edidd>-sdata = lst_e1edk02.
        CLEAR lst_e1edk02.
      ENDIF. " IF lst_e1edk02-qualf = lc_qualf_028

*   Invoice Number
      IF lst_e1edk02-qualf = lc_qualf_009. "'009'.
*     If record exists with qualifier 009, update the invoice
        IF xvbdkr-vbtyp IN lr_vbtyp " M/P/5
* BOC by ARABANERJE on 12/04/2017
          OR xvbdkr-vbtyp IN lr_vbtyp_o.
* EOC by ARABANERJE on 12/04/2017
          lst_e1edk02-belnr = dobject-objky+0(10).
        ELSE. " ELSE -> IF xvbdkr-vbtyp IN lr_vbtyp
          CLEAR lst_e1edk02-belnr.
        ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp
        <lst_edidd>-sdata = lst_e1edk02.
        CLEAR lst_e1edk02.

      ENDIF. " IF lst_e1edk02-qualf = lc_qualf_009

***************************************************
****************E1EDK03****************************
***************************************************

    WHEN lc_e1edk03. " 'E1EDK03'.
      lst_e1edk03 = <lst_edidd>-sdata.

      IF xvbdkr-vbtyp IN lr_vbtyp_o. " O/6

*    Posting Period 1 (.7, .11)
        IF lst_e1edk03-iddat = lc_qualf_016.
*       If the record already exists, update it
*       Posting Period
          lst_e1edk03-datum = xvbdkr-fkdat.
          <lst_edidd>-sdata = lst_e1edk03.
          CLEAR lst_e1edk03.
        ENDIF. " IF lst_e1edk03-iddat = lc_qualf_016
      ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp_o


*  Posting Period
      IF lst_e1edk03-iddat = lc_qualf_003.
*     If the record already exists, update it
        IF xvbdkr-vbtyp IN lr_vbtyp. " m/p/5
          lst_e1edk03-datum = xvbdkr-fkdat.
        ELSE. " ELSE -> IF xvbdkr-vbtyp IN lr_vbtyp
          CLEAR lst_e1edk03-datum.
        ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp
        <lst_edidd>-sdata = lst_e1edk03.
      ENDIF. " IF lst_e1edk03-iddat = lc_qualf_003


*   Posting Period 2 (Sheet .7, .12)
      IF lst_e1edk03-iddat = lc_qualf_001.
        SELECT posnr,
          aubel     " Sales Document
          FROM vbrp " Billing Document: Item Data
          INTO TABLE @DATA(li_vbrp_dt)
          WHERE vbeln = @dobject-objky+0(10).
        IF sy-subrc = 0.

          IF xvbdkr-vbtyp IN lr_vbtyp. " m/p/5

            SELECT vbeln ,
              audat     " Document Date (Date Received/Sent)
              FROM vbak " Sales Document: Header Data
              INTO @DATA(lst_vbak_temp)
              UP TO 1 ROWS
              FOR ALL ENTRIES IN @li_vbrp_dt
              WHERE vbeln = @li_vbrp_dt-aubel.
            ENDSELECT.
            IF sy-subrc = 0.
              lst_e1edk03-datum = lst_vbak_temp-audat.
              <lst_edidd>-sdata = lst_e1edk03.
            ENDIF. " IF sy-subrc = 0
          ELSEIF xvbdkr-vbtyp IN lr_vbtyp_o. "O/6
            SELECT
            vbeln     " Preceding sales and distribution document
            FROM vbfa " Sales Document Flow
            INTO @DATA(lv_vbeln)
            UP TO 1 ROWS
            FOR ALL ENTRIES IN @li_vbrp_dt
            WHERE vbelv = @li_vbrp_dt-aubel
            AND vbtyp_v IN @lr_autyp_gc.
            ENDSELECT.
            IF sy-subrc = 0.
              SELECT SINGLE
              audat     " Document Date (Date Received/Sent)
              FROM vbak " Sales Document: Header Data
              INTO @DATA(lv_audat)
              WHERE vbeln = @lv_vbeln.
              IF sy-subrc = 0.
                lst_e1edk03-datum = lst_vbak_temp-audat.
                <lst_edidd>-sdata = lst_e1edk03.
              ENDIF. " IF sy-subrc = 0
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF lst_e1edk03-iddat = lc_qualf_001


***************************************************
****************E1EDP01****************************
***************************************************

    WHEN lc_e1edp01. " 'E1EDP01'.

*     Obtain the data in a field symbol
      lst_e1edp01 = <lst_edidd>-sdata.
*     Begin of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
*     New Line Item - Reset the Flag for IDOC Segment E1EDP05
      CALL FUNCTION 'ZQTC_OB_INVOIC_SET_FLAGS'
        EXPORTING
          im_e1edp05 = abap_false.
*     End   of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501

* Append a dummy segment name as Z1QTC_ITEM first
* This is done to maintain the sequence of segments
* The value of this segment will be modified later on in diff segment
      lst_edidd-segnam = lc_custm_itm_seg. "Value 'Z1QTC_ITEM'
      APPEND lst_edidd TO int_edidd.

*   Billed Quantity, Material, Plant and Access Revoked
      lv_posnr = lst_e1edp01-posex.
      SELECT SINGLE posnr,     " Billing item
        fkimg,                 " Actual Invoiced Quantity
        netwr,                 " Net value of the billing item in document currency
        aubel,                 " Sales Document
        matnr,                 " Material Number
        werks                  " Plant
        FROM vbrp              " Billing Document: Item Data
        INTO @DATA(lst_vbrp_t) "( lv_fkimg , lv_matnr , lv_werks )
        WHERE vbeln = @dobject-objky+0(10)
        AND posnr = @lv_posnr.
      IF sy-subrc = 0.

*       Billed Quantity
        lv_quantity = lst_vbrp_t-fkimg.
        CONDENSE lv_quantity.
        lv_value = lv_quantity.
        lst_e1edp01-menge = lv_value. " lst_vbrp_t-fkimg.
        CONDENSE lst_e1edp01-menge.
*       Material (in external format)
        DATA(lv_matnr_i0245) = lst_vbrp_t-matnr.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = lv_matnr_i0245
          IMPORTING
            output = lv_matnr_i0245.
        lst_e1edp01-matnr = lv_matnr_i0245.

*       Plant
        lst_e1edp01-werks = lst_vbrp_t-werks.


*     Access Revoked
        IF lst_vbrp_t IS NOT INITIAL AND
          ( xvbdkr-vbtyp IN lr_vbtyp_o ). " O/6

          SELECT vbelv, "Preceding SD Document
             posnv,     "Preceding SD Document Item
            vbeln ,     "Subsequent SD Document
            posnn       " Subsequent item of an SD document
            INTO TABLE @DATA(li_vbfa_t)
            FROM vbfa   " Sales Document Flow
            WHERE vbelv = @lst_vbrp_t-aubel
            AND posnv = @lst_vbrp_t-posnr.
          IF sy-subrc = 0.

*           Compare the NETWR in VBAP with NETWR in VBRP
            SELECT abgru " Reason for rejection of quotations and sales orders
              FROM vbap  " Sales Document: Item Data
              INTO ( lv_abgru_vbap )
              UP TO 1 ROWS
              FOR ALL ENTRIES IN li_vbfa_t
              WHERE vbeln = li_vbfa_t-vbeln
              AND posnr = li_vbfa_t-posnn.
            ENDSELECT.
            IF sy-subrc = 0.
*             Populate the value of Access Revoked based on ABGRU
              IF lv_abgru_vbap IS NOT INITIAL.
                lst_e1edp01-abgru = lc_yes. "Value Y
              ELSE. " ELSE -> IF lv_abgru_vbap IS NOT INITIAL
                lst_e1edp01-abgru = lc_no. "Value 'N'.
              ENDIF. " IF lv_abgru_vbap IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF lst_vbrp_t IS NOT INITIAL AND
      ENDIF. " IF sy-subrc = 0

      <lst_edidd>-sdata = lst_e1edp01. " Modified the line

***************************************************
****************E1EDP19****************************
***************************************************

    WHEN lc_e1edp19. " 'E1EDP19'.

*   Rename the dummy segment to the custom item segment
*      READ TABLE int_edidd
*      ASSIGNING FIELD-SYMBOL(<lst_edidd_dummy>)
*      WITH KEY segnam = lc_custm_itm_seg.  "Value'Z1QTC_ITEM
      LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_dummy>)
      WHERE segnam = lc_custm_itm_seg. "Value'Z1QTC_ITEM
      ENDLOOP. " LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_dummy>)
* Here SY-SUBRC will always be 0 , because item segment
* has been added in E1EDP01 segment
      IF sy-subrc EQ 0.

* Obtain the item nunmber from E1EDP01 segment , item number is required
* to get Invoice line item price and reference document no
*        READ TABLE int_edidd
*        ASSIGNING <lst_edidd_temp>
*        WITH KEY segnam = lc_e1edp01.  " 'E1EDP01'.
        LOOP AT int_edidd ASSIGNING <lst_edidd_temp>
        WHERE segnam = lc_e1edp01. " 'E1EDP01'.
        ENDLOOP. " LOOP AT int_edidd ASSIGNING <lst_edidd_temp>
        IF sy-subrc = 0.
          lst_e1edp01_temp = <lst_edidd_temp>-sdata.
        ENDIF. " IF sy-subrc = 0

*   Get thge customers for Ship To, Sold To
        SELECT
          posnr,    " Line Item Number
          parvw,    " Partner Function
          kunnr     " Customer Number
          INTO TABLE @DATA(li_kunnr)
          FROM vbpa " Sales Document: Partner
          WHERE vbeln = @xtvbdpr-vbeln_vauf
*          AND posnr = @lst_e1edp01_temp-posex
          AND ( posnr = @xtvbdpr-posnr_vauf
           OR   posnr = @lc_posnr_low )
          AND parvw IN ( @lc_parvw_sh , @lc_parvw_we , @lc_parvw_sp ).

        IF sy-subrc = 0.
          SORT li_kunnr BY posnr parvw.
*     Ship-To
* Entry will be less , so BINARY search is not required
          READ TABLE li_kunnr ASSIGNING FIELD-SYMBOL(<lst_kunnr>)
          WITH KEY posnr = xtvbdpr-posnr_vauf
                   parvw = lc_parvw_we. "Value'WE'
          IF sy-subrc NE 0.
            READ TABLE li_kunnr ASSIGNING <lst_kunnr>
            WITH KEY posnr = lc_posnr_low
                     parvw = lc_parvw_we. "Value'WE'
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc = 0.
            lst_z1qtc_item-zshipto = <lst_kunnr>-kunnr.
          ENDIF. " IF sy-subrc = 0

*     Sold To
* Entry will be less , so BINARY search is not required
          READ TABLE li_kunnr ASSIGNING <lst_kunnr>
          WITH KEY posnr = lc_posnr_low
                   parvw = lc_parvw_sp. "Value 'SP'
          IF sy-subrc = 0.
            lst_z1qtc_item-zsoldto = <lst_kunnr>-kunnr.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0


        lst_e1edp19 = <lst_edidd>-sdata.
        IF lst_e1edp19-qualf = lc_qualf_002. "Value '002'.
*      Material number sent in field IDTNR when QUALF (Qualifier) = 002
          lv_matnr = lst_e1edp19-idtnr.

*     ISBN 13/Material Number
          SELECT SINGLE
            bismt     " Old material number
            mtart     " Material Type
            extwg     " External Material Group
            FROM mara " General Material Data
            INTO ( lv_bismt , lv_mtart , lv_extwg )
            WHERE matnr = lv_matnr.

          IF sy-subrc = 0.
            lst_z1qtc_item-zisbncode = lv_bismt.
          ENDIF. " IF sy-subrc = 0

          CLEAR lv_bismt.

*     Journal Grp Code
*     Obtain the first character
          SHIFT lv_bismt LEFT DELETING LEADING lc_zero. "Value 0.
          lv_journal = lv_bismt. " 1st 4 character
          lst_z1qtc_item-zjournal = lv_journal.

*     Journal Group Code 2
          IF lv_mtart IN lr_mtart. " Material type
            lst_z1qtc_item-zjournal1 = lv_extwg.
          ELSE. " ELSE -> IF lv_mtart IN lr_mtart
            SHIFT lv_matnr LEFT DELETING LEADING lc_zero.
*            lst_z1qtc_item-zjournal1 = lv_matnr+4.
            lst_z1qtc_item-zjournal1 = lv_matnr+0(4).
          ENDIF. " IF lv_mtart IN lr_mtart
        ENDIF. " IF lst_e1edp19-qualf = lc_qualf_002


* Get invoice line item data for particular line
        SELECT SINGLE vbeln,      " Billing Document
                      posnr,      " Billing item
                      aubel,      " Sales Document
                      aupos,      " Sales Document Item
                      arktx,      " Short text for sales order item
                      augru_auft, " Order reason (reason for the business transaction)
                      netwr       " Net value of the billing item in document currency
          FROM vbrp               " Billing Document: Item Data
          INTO @DATA(lst_line_item)
          WHERE vbeln EQ @dobject-objky+0(10)
          AND posnr EQ @lst_e1edp01_temp-posex.

        IF sy-subrc EQ 0.
* Population of field Product Description for I0351.
          IF lst_e1edp19-qualf = lc_qualf_002. "Value '002'.
*      Product Description sent in field KTEXT when QUALF (Qualifier) = 002
            lst_e1edp19-ktext = lst_line_item-arktx.
          ENDIF. " IF lst_e1edp19-qualf = lc_qualf_002

* Now populate CREDIT REASON
* FIrst check if BSARK is CSS , then go to VBAK table and check
* if it is Credit memo request , then populate VBRP-AUGRU_AUFT
*          SELECT vbeln,posnr,bsark
*            FROM vbkd " Sales Document: Business Data
*            INTO TABLE @DATA(li_credit_reason)
**            WHERE vbeln EQ @lst_line_item-vbeln
**            AND posnr EQ @lst_line_item-posnr
*            WHERE vbeln EQ @lst_line_item-aubel
*            AND ( posnr EQ @lst_line_item-aupos
*             OR   posnr EQ @lc_posnr_low )
*            AND bsark EQ @lv_bsark_css.
*          IF sy-subrc EQ 0.

          SELECT SINGLE vbeln, " Sales Document
                        vbtyp  " SD document category
            FROM vbak          " Sales Document: Header Data
            INTO @DATA(lst_credit_memo)
            WHERE vbeln EQ @lst_line_item-aubel.
          IF sy-subrc EQ 0 AND lst_credit_memo-vbtyp IN lr_vbtyp_k.
            lst_z1qtc_item-zaugru = lst_line_item-augru_auft. " Credit Reason
*         Begin of ADD:CR#495:WROY:09-JUL-2017:ED2K907166
          ELSEIF lst_credit_memo-vbtyp IN lr_autyp_gc.
*           Fetch Contract Data
            SELECT SINGLE vkuegru                 " Reason for Cancellation of Contract
              FROM veda
              INTO @DATA(lv_vkuegru)
             WHERE vbeln EQ @lst_line_item-aubel  " Sales Document
               AND vposn EQ @lst_line_item-aupos. " Sales Document Item
            IF sy-subrc EQ 0 AND
               lv_vkuegru IS NOT INITIAL.
              lst_z1qtc_item-zaugru = lv_vkuegru. " Reason for Cancellation of Contract
            ENDIF.
*         End   of ADD:CR#495:WROY:09-JUL-2017:ED2K907166
          ENDIF. " IF sy-subrc EQ 0 AND lst_credit_memo-vbtyp IN lr_vbtyp_k

*          ENDIF. " IF sy-subrc EQ 0


* NOW populate PARTIAL/COMPLETE field and SUBSCRIPTION fields

* Subscription Number (Sheet .7, .12)
          IF xvbdkr-vbtyp IN lr_vbtyp. " M/P/5
            lst_z1qtc_item-zinvoice  = xvbdkr-vbeln.
            lst_z1qtc_item-zinv_date = xvbdkr-erdat.

            lst_z1qtc_item-zsubscrip = lst_line_item-aubel.
            lst_z1qtc_item-zord_itm  = lst_line_item-aupos.

          ELSEIF xvbdkr-vbtyp IN lr_vbtyp_o. " O/6
            lst_z1qtc_item-zinvoice = xvbdkr-vbeln_vg2.
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
            CLEAR: lst_constant.
            READ TABLE li_constant INTO lst_constant
                      WITH KEY param1 = lc_historical
                               param2 = lc_bill_catg
                               low    = xvbdkr-fkart
                      BINARY SEARCH.
            IF sy-subrc EQ 0 AND lst_constant-high IS NOT INITIAL.
              lst_z1qtc_item-zinvoice  = xvbdkr-vbeln.
              lst_z1qtc_item-zinv_date = xvbdkr-erdat.
            ENDIF.
*   END ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593

*            SELECT vbelv,posnv,vbtyp_v " Preceding sales and distribution document
*             FROM vbfa                 " Sales Document Flow
*             INTO @DATA(lst_vbelv)
*             UP TO 1 ROWS
*             WHERE vbeln EQ @lst_line_item-aubel
*              AND posnn EQ @lst_line_item-aupos.
**              AND posnn EQ @lst_line_item-posnr.
*            ENDSELECT.
            SELECT vbelv,   " Preceding sales and distribution document
                   posnv,   " Preceding item of an SD document
                   vbeln,   " Subsequent sales and distribution document
                   posnn,   " Subsequent item of an SD document
                   vbtyp_n, " Document category of subsequent document
                   vbtyp_v  " Preceding sales and distribution document
             FROM vbfa      " Sales Document Flow
             INTO TABLE @DATA(li_vbfa)
             WHERE vbeln EQ @lst_line_item-aubel
               AND posnn EQ @lst_line_item-aupos.

            IF sy-subrc = 0.
              IF lst_z1qtc_item-zinvoice IS INITIAL.
                DATA(li_vbfa_inv) = li_vbfa.
                DELETE li_vbfa_inv WHERE vbtyp_v NOT IN lr_vbtyp.
                IF li_vbfa_inv IS NOT INITIAL.
                  SORT li_vbfa_inv BY vbeln posnn.
                  READ TABLE li_vbfa_inv ASSIGNING FIELD-SYMBOL(<lst_vbfa_inv>)
                       WITH KEY vbeln = lst_line_item-aubel
                                posnn = lst_line_item-aupos
                       BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lst_z1qtc_item-zinvoice = <lst_vbfa_inv>-vbelv.
                  ENDIF. " IF sy-subrc EQ 0
                ENDIF. " IF li_vbfa_inv IS NOT INITIAL
              ENDIF. " IF lst_z1qtc_item-zinvoice IS INITIAL

              DELETE li_vbfa WHERE vbtyp_v NOT IN lr_autyp_gc.
              IF li_vbfa IS NOT INITIAL.
                SORT li_vbfa BY vbeln posnn.
                READ TABLE li_vbfa ASSIGNING FIELD-SYMBOL(<lst_vbfa>) WITH KEY vbeln = lst_line_item-aubel
                                                                               posnn = lst_line_item-aupos
                                                                      BINARY SEARCH.

                IF sy-subrc IS INITIAL AND <lst_vbfa> IS ASSIGNED.
                  lst_z1qtc_item-zsubscrip = <lst_vbfa>-vbelv. " Subscription
                  lst_z1qtc_item-zord_itm  = <lst_vbfa>-posnv. " Subscription Item

* Compare the NETWR in VBAP with NETWR in VBRP
                  SELECT SINGLE
                    abgru,    " Reason for rejection of quotations and sales orders
                    netwr     " Net value of the order item in document currency
                    FROM vbap " Sales Document: Item Data
                    INTO @DATA(lst_vbap_netwr)
*                    WHERE vbeln EQ @lst_vbelv-vbelv
*                    AND posnr EQ @lst_vbelv-posnv.
                    WHERE vbeln = @<lst_vbfa>-vbelv
                    AND posnr = @<lst_vbfa>-posnv.
                  IF sy-subrc = 0.
*                 populate value of partial/complete based on comparison of vbap-netwr
*                 and VBRP-NETWR
                    IF lst_line_item-netwr EQ lst_vbap_netwr-netwr.
* Check if Billing Quantity = Order Quantity VBAP-NETWR = VBRP-NETWR
*                     lst_z1qtc_item-zcomplete = space. "Value 'N'
                      lst_z1qtc_item-zcomplete = lc_full_credit. "Value 'C'
                    ELSE. " ELSE -> IF lst_line_item-netwr EQ lst_vbap_netwr-netwr
*                     lst_z1qtc_item-zcomplete = lc_yes. "Value 'Y'
                      lst_z1qtc_item-zcomplete = lc_part_credit. "Value 'P'
                    ENDIF. " IF lst_line_item-netwr EQ lst_vbap_netwr-netwr
                  ENDIF. " IF sy-subrc = 0
                ELSE. " ELSE -> IF sy-subrc IS INITIAL AND <lst_vbfa> IS ASSIGNED
* Compare the NETWR in VBAP with NETWR in VBRP
                  SELECT SINGLE
                    augru_auft, " Reason for rejection of quotations and sales orders
                    netwr       " Net value of the order item in document currency
                    FROM vbrp   " Sales Document: Item Data
                    INTO @DATA(lst_vbrp_netwr)
*                    WHERE vbeln EQ @lst_vbelv-vbelv
*                    AND posnr EQ @lst_vbelv-posnv.
                    WHERE vbeln EQ @<lst_vbfa>-vbelv
                    AND posnr EQ @<lst_vbfa>-posnv.
                  IF sy-subrc = 0.
*                 populate value of partial/complete based on comparison of vbap-netwr
*                 and VBRP-NETWR
                    IF lst_line_item-netwr EQ lst_vbrp_netwr-netwr.
* Check if Billing Quantity = Order Quantity VBAP-NETWR = VBRP-NETWR
*                      lst_z1qtc_item-zcomplete = space. "Value 'N'
                      lst_z1qtc_item-zcomplete = lc_full_credit.
                    ELSE. " ELSE -> IF lst_line_item-netwr EQ lst_vbrp_netwr-netwr
*                      lst_z1qtc_item-zcomplete = lc_yes. "Value 'Y'
                      lst_z1qtc_item-zcomplete = lc_part_credit.
                    ENDIF. " IF lst_line_item-netwr EQ lst_vbrp_netwr-netwr
                  ENDIF. " IF sy-subrc = 0
                ENDIF. " IF sy-subrc IS INITIAL AND <lst_vbfa> IS ASSIGNED
              ENDIF. " IF li_vbfa IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0

            IF lst_z1qtc_item-zsubscrip IS INITIAL AND
               lst_z1qtc_item-zord_itm  IS INITIAL.
              lst_z1qtc_item-zsubscrip = lst_line_item-aubel.
              lst_z1qtc_item-zord_itm  = lst_line_item-aupos.


            ENDIF. " IF lst_z1qtc_item-zsubscrip IS INITIAL AND
          ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp

          IF lst_z1qtc_item-zsubscrip IS NOT INITIAL.
*           Get the Order Date
            SELECT SINGLE audat " Document Date (Date Received/Sent)
              FROM vbak         " Sales Document: Header Data
              INTO @DATA(lv_audat_ord)
             WHERE vbeln EQ @lst_z1qtc_item-zsubscrip.
            IF sy-subrc EQ 0.
              lst_z1qtc_item-zord_date = lv_audat_ord.
            ENDIF. " IF sy-subrc EQ 0

*            SELECT vbeln,       " Sales Document
*                   vposn,       " Sales Document Item
*                   vbegdat      " Contract start date
*              FROM veda
*              INTO TABLE @DATA(li_veda_ord)
*             WHERE vbeln EQ @lst_z1qtc_item-zsubscrip
*             ORDER BY PRIMARY KEY.
*            IF sy-subrc EQ 0.
*              READ TABLE li_veda_ord ASSIGNING FIELD-SYMBOL(<lst_veda_ord>)
*                   WITH KEY vbeln = lst_z1qtc_item-zsubscrip
*                            vposn = lst_z1qtc_item-zord_itm
*                   BINARY SEARCH.
*              IF sy-subrc NE 0.
*                READ TABLE li_veda_ord ASSIGNING <lst_veda_ord>
*                     WITH KEY vbeln = lst_z1qtc_item-zsubscrip
*                              vposn = lc_posnr_low
*                     BINARY SEARCH.
*              ENDIF.
*              IF sy-subrc EQ 0.
*                lst_z1qtc_item-zord_date = <lst_veda_ord>-vbegdat.
*              ENDIF.
*            ENDIF.

            IF lst_z1qtc_item-zinvoice IS INITIAL.
              SELECT vbelv,   " Preceding sales and distribution document
                     posnv,   " Preceding item of an SD document
                     vbeln,   " Subsequent sales and distribution document
                     posnn,   " Subsequent item of an SD document
                     vbtyp_n, " Document category of subsequent document
                     vbtyp_v  " Preceding sales and distribution document
               FROM vbfa      " Sales Document Flow
               INTO TABLE @li_vbfa_inv
               WHERE vbelv   EQ @lst_z1qtc_item-zsubscrip
                 AND posnv   EQ @lst_z1qtc_item-zord_itm
                 AND vbtyp_n IN @lr_vbtyp
                ORDER BY PRIMARY KEY.
              IF sy-subrc EQ 0.
                READ TABLE li_vbfa_inv ASSIGNING <lst_vbfa_inv>
                     WITH KEY vbelv = lst_z1qtc_item-zsubscrip
                              posnv = lst_z1qtc_item-zord_itm
                     BINARY SEARCH.
                IF sy-subrc EQ 0.
                  lst_z1qtc_item-zinvoice = <lst_vbfa_inv>-vbeln.
*** BOC by SAYANDAS for ERP-2573 on 15th June 2017
                  lv_inv_item = <lst_vbfa_inv>-posnn.
*** EOC by SAYANDAS for ERP-2573 on 15th June 2017
                ENDIF. " IF sy-subrc EQ 0
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF lst_z1qtc_item-zinvoice IS INITIAL
          ENDIF. " IF lst_z1qtc_item-zsubscrip IS NOT INITIAL

          IF lst_z1qtc_item-zinvoice  IS NOT INITIAL AND
             lst_z1qtc_item-zinv_date IS INITIAL.
            SELECT SINGLE erdat " Date on Which Record Was Created
              FROM vbrk         " Billing Document: Header Data
              INTO @DATA(lv_erdat)
             WHERE vbeln EQ @lst_z1qtc_item-zinvoice.
            IF sy-subrc EQ 0.
              lst_z1qtc_item-zinv_date = lv_erdat.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lst_z1qtc_item-zinvoice IS NOT INITIAL AND
*** BOC by SAYANDAS for ERP-2573 on 15th June 2017
* Compare the NETWR in VBAP with NETWR in VBRP
          IF lst_z1qtc_item-zinvoice IS NOT INITIAL AND
             lv_inv_item             IS NOT INITIAL.
            SELECT SINGLE
              augru_auft, " Reason for rejection of quotations and sales orders
              netwr       " Net value of the order item in document currency
              FROM vbrp   " Sales Document: Item Data
              INTO @DATA(lst_vbrp1_netwr)

              WHERE vbeln EQ @lst_z1qtc_item-zinvoice
              AND posnr EQ @lv_inv_item.
            IF sy-subrc = 0.
*                 populate value of partial/complete based on comparison of vbap-netwr
*                 and VBRP-NETWR
              IF lst_line_item-netwr EQ lst_vbrp1_netwr-netwr.
* Check if Billing Quantity = Order Quantity VBAP-NETWR = VBRP-NETWR
*                      lst_z1qtc_item-zcomplete = space. "Value 'N'
                lst_z1qtc_item-zcomplete = lc_full_credit.
              ELSE. " ELSE -> IF lst_line_item-netwr EQ lst_vbrp1_netwr-netwr
*                      lst_z1qtc_item-zcomplete = lc_yes. "Value 'Y'
                lst_z1qtc_item-zcomplete = lc_part_credit.
              ENDIF. " IF lst_line_item-netwr EQ lst_vbrp1_netwr-netwr
            ENDIF. " IF sy-subrc = 0
          ENDIF.
*** EOC by SAYANDAS for ERP-2573 on 15th June 2017
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0

*     Begin of ADD:CR#527:WROY:09-JUL-2017:ED2K907166
      IF lst_z1qtc_item-zsubscrip IS NOT INITIAL AND
         lst_z1qtc_item-zord_itm  IS NOT INITIAL.
*       Fetch Sales Document: Business Data
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
        SELECT SINGLE vkbur " Document Date (Date Received/Sent)
          FROM vbak         " Sales Document: Header Data
          INTO @DATA(lv_vkbur_ord)
         WHERE vbeln EQ @lst_z1qtc_item-zsubscrip.
*        SELECT SINGLE posex_e                      " Item Number of the Underlying Purchase Order
*          FROM vbkd
*         INTO @DATA(lv_posex_e)
        SELECT SINGLE ihrez, posex_e               " Item Number of the Underlying Purchase Order
          FROM vbkd
         INTO @DATA(lst_refdata)
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
         WHERE vbeln EQ @lst_z1qtc_item-zsubscrip  " Sales and Distribution Document Number
           AND posnr EQ @lst_z1qtc_item-zord_itm.  " Item number of the SD document
        IF sy-subrc EQ 0.
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
*          lst_z1qtc_item-zposex_e = lv_posex_e.    " Item Number of the Underlying Purchase Order
          lst_z1qtc_item-zposex_e    = lst_refdata-posex_e.     " Item Number of the Underlying Purchase Order
* Populate only for Historical credit memo Billing doc ZHCR/ZHDR
          IF xvbdkr-fkart IN lr_fkart AND
             lr_fkart IS NOT INITIAL AND
            lv_vkbur_ord IN lr_vkbur AND
             lr_vkbur IS NOT INITIAL.
* Sold to Your Reference data
            lst_z1qtc_item-zsoldto_ref = lst_refdata-ihrez.
          ENDIF.
*   End ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
        ENDIF.
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
* Populate only for Historical credit memo Billing doc ZHCR/ZHDR
        IF xvbdkr-fkart IN lr_fkart AND
           lr_fkart IS NOT INITIAL AND
           lv_vkbur_ord IN lr_vkbur AND
            lr_vkbur IS NOT INITIAL.
* Sold to Purchase order item
          SELECT SINGLE posex
                   INTO @DATA(lv_posex)
                   FROM vbap
                  WHERE vbeln EQ @lst_z1qtc_item-zsubscrip  " Sales and Distribution Document Number
                    AND posnr EQ @lst_z1qtc_item-zord_itm.  " Item number of the SD document
          IF sy-subrc EQ 0.
            lst_z1qtc_item-zsoldto_itm = lv_posex.
          ENDIF.
        ENDIF.
*   End   ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      ENDIF.
*     End   of ADD:CR#527:WROY:09-JUL-2017:ED2K907166

      <lst_edidd_dummy>-sdata = lst_z1qtc_item.
*      ENDIF. " IF sy-subrc EQ 0

**************************************************
***************E1EDPA1****************************
**************************************************

    WHEN lc_e1edpa1. " 'E1EDPA1'.
      lst_e1edpa1 = <lst_edidd>-sdata.

*     Obtain the item nunmber from E1EDP01 segment
*      READ TABLE int_edidd
*      ASSIGNING FIELD-SYMBOL(<lst_edidd_item>)
*      WITH KEY segnam = lc_e1edp01. " 'E1EDP01'.
      LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_item>)
      WHERE segnam = lc_e1edp01. "Value'E1EDP01
      ENDLOOP. " LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_item>)
      IF sy-subrc = 0.
        lst_e1edp01_temp = <lst_edidd_item>-sdata.
        lv_posnr = lst_e1edp01_temp-posex.
      ENDIF. " IF sy-subrc = 0


*   Reference
*      SELECT
*        vbrp~vbeln,
*        vbrp~posnr,
*        vbrp~aubel,
*        vbrp~autyp,
*        vbkd~ihrez_e    " Ship-to party character
*        INTO  @DATA(lst_data)
*        UP TO 1 ROWS
*        FROM vbrp       " Billing Document: Item Data
*        INNER JOIN vbkd " Sales Document: Business Data
**        ON vbkd~vbeln EQ vbrp~vbeln
**        AND vbkd~posnr EQ vbrp~posnr
*        ON vbkd~vbeln EQ vbrp~aubel
*        AND vbkd~posnr EQ vbrp~aupos
*        WHERE vbrp~vbeln EQ @dobject-objky
*        AND vbrp~posnr EQ @lv_posnr
*        AND vbrp~autyp EQ @lv_autyp_g.
*      ENDSELECT.
      SELECT
         vbrp~vbeln,
         vbrp~posnr,
         vbrp~aubel,
         vbrp~aupos,
         vbrp~autyp,
         vbap~vbelv,
         vbap~posnv,    " Originating item
         vbap~vgbel,
         vbap~vgpos     " Item number of the reference item
        INTO  @DATA(lst_data)
        UP TO 1 ROWS
        FROM vbrp       " Billing Document: Item Data
        INNER JOIN vbap " Sales Document: Business Data
        ON vbap~vbeln EQ vbrp~aubel
        AND vbap~posnr EQ vbrp~aupos
        WHERE vbrp~vbeln EQ @dobject-objky+0(10)
        AND vbrp~posnr EQ @lv_posnr.
      ENDSELECT.
      IF sy-subrc EQ 0.
        IF lst_data-autyp IN lr_autyp_gc.
          SELECT SINGLE ihrez_e " Ship-to party character
            FROM vbkd           " Sales Document: Business Data
            INTO @DATA(lv_ihrez_e)
           WHERE vbeln = @lst_data-aubel
             AND posnr = @lst_data-aupos.
        ELSE. " ELSE -> IF lst_data-autyp IN lr_autyp_gc
          IF lst_data-vbelv IS INITIAL OR
             lst_data-posnv IS INITIAL.
            SELECT SINGLE aubel " Sales Document
                          aupos " Sales Document Item
              FROM vbrp         " Billing Document: Item Data
              INTO (lst_data-vbelv, lst_data-posnv)
             WHERE vbeln EQ lst_data-vgbel
               AND posnr EQ lst_data-vgpos.
            IF sy-subrc NE 0.
*             Begin of ADD:ERP-5670:WROY:14-Dec-2017:ED2K909893
              lst_data-vbelv = lst_data-aubel.
              lst_data-posnv = lst_data-aupos.
*             End   of ADD:ERP-5670:WROY:14-Dec-2017:ED2K909893
            ENDIF. " IF sy-subrc NE 0
          ENDIF. " IF lst_data-vbelv IS INITIAL OR
          SELECT SINGLE ihrez_e " Ship-to party character
            FROM vbkd           " Sales Document: Business Data
            INTO lv_ihrez_e
           WHERE vbeln = lst_data-vbelv
             AND posnr = lst_data-posnv.
        ENDIF. " IF lst_data-autyp IN lr_autyp_gc
      ENDIF. " IF sy-subrc EQ 0
      IF sy-subrc = 0.
*        lst_e1edpa1-ihrez = lst_data-ihrez_e.
        lst_e1edpa1-ihrez = lv_ihrez_e.
      ENDIF. " IF sy-subrc = 0

*   Reference (.7 .11) IHREZ
      IF xvbdkr-vbtyp IN lr_vbtyp_o. " o/6
*        lst_e1edpa1-knref = lst_data-ihrez_e.
        lst_e1edpa1-knref = lv_ihrez_e.

      ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp_o
*   Begin ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      IF xvbdkr-fkart IN lr_fkart AND
         lr_fkart IS NOT INITIAL.
        lst_e1edpa1-ihrez = lv_ihrez_e.
      ENDIF.
*   End ADD:CR#698:SGUDA:30-JAN-2018:ED2K910593
      IF lst_e1edpa1-parvw EQ lc_parvw_we.
        SELECT idnumber " Identification Number
          FROM but0id   " BP: ID Numbers
          UP TO 1 ROWS
          INTO lst_e1edpa1-ilnnr
          WHERE partner = lst_e1edpa1-partn
          AND type = lv_type_zwint.
        ENDSELECT.
      ENDIF. " IF lst_e1edpa1-parvw EQ lc_parvw_we

* BOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *
      IF ( lst_e1edpa1-parvw EQ lc_parvw_we ) AND ( dobject-kschl IN lir_kschl_zekn ).  " Shipto party , ZEKN output
        SELECT SINGLE partner,idnumber      " Fetch identification Number based on the l/item ship to party
         FROM but0id
         INTO @DATA(lst_but0id)
         WHERE partner = @lst_e1edpa1-partn
         AND type = @lv_type_zstore.          " type is equlas to 'ZSTORE'
        IF sy-subrc = 0.
          lst_e1edpa1-ilnnr = lst_but0id-idnumber.    " Identification number assign to the segment
        ENDIF.
      ENDIF.
* EOC by Lahiru on 02/04/2021 for OTCM-29968 with ED2K921668 *

      <lst_edidd>-sdata = lst_e1edpa1. " Line is modified

*      IF lst_e1edpa1-parvw NE lc_parvw_sp.
**     Obtain the item nunmber from E1EDP01 segment
*        READ TABLE int_edidd
*        ASSIGNING <lst_edidd_temp>
*        WITH KEY segnam = lc_e1edp01. " 'E1EDP01'.
*        IF sy-subrc = 0.
*          lst_e1edp01_temp = <lst_edidd_temp>-sdata.
*          lv_posnr = lst_e1edp01_temp-posex.
*        ENDIF. " IF sy-subrc = 0
*
**     Fetch Customer from VBPA
*        SELECT SINGLE kunnr "Customer
*          FROM vbpa         " Sales Document: Partner
*          INTO @DATA(lv_kunnr_sp)
*          WHERE vbeln = @dobject-objky
*          AND posnr = @lv_posnr
*          AND parvw = @lc_parvw_sp.
*        IF sy-subrc = 0.
*          SELECT idnumber " Identification Number
*          FROM but0id     " BP: ID Numbers
*          UP TO 1 ROWS
*          INTO @DATA(lv_idnumber_t)
*          WHERE partner = @lv_kunnr_sp
*          AND type = @lv_type_zwint.
*          ENDSELECT.
*          IF sy-subrc = 0.
*            CLEAR lst_e1edpa1.
*            lst_e1edpa1-partn = lv_idnumber_t.
*            lst_e1edpa1-partn = lc_parvw_sp.
*            lst_edidd-sdata = lst_e1edpa1.
*            APPEND lst_edidd TO int_edidd. " Line is added
*          ENDIF. " IF sy-subrc = 0
*        ENDIF. " IF sy-subrc = 0
*
*      ENDIF. " IF lst_e1edpa1-parvw NE lc_parvw_sp

***************************************************
****************E1EDP04****************************
***************************************************

    WHEN lc_e1edp04. " 'E1EDP04'.

*     Obtain the item nunmber from E1EDP01 segment
      READ TABLE int_edidd
      ASSIGNING <lst_edidd_temp>
      WITH KEY segnam = lc_e1edp01. " 'E1EDP01'.
      IF sy-subrc = 0.
        lst_e1edp01_temp = <lst_edidd_temp>-sdata.
        lv_posnr = lst_e1edp01_temp-posex.
      ENDIF. " IF sy-subrc = 0

*   Populate Total Credit Amount (.12 Sheet)
      IF xvbdkr-vbtyp IN lr_vbtyp_o. " O/6
        SELECT SINGLE
          netwr                 " Net value of the billing item in document currency
          FROM vbrp             " Billing Document: Item Data
          INTO lv_netwr
          WHERE vbeln = dobject-objky+0(10)
          AND posnr = lv_posnr. "lst_e1edp01_temp-posex.
        IF sy-subrc = 0.
          lst_e1edp04-mwsbt = lv_netwr.
          lst_e1edp04-mwskz = lc_mwskz_001. "Value '001' for .12 sheet
          IF lst_edidd IS NOT INITIAL.
            lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
            lst_edidd-sdata = lst_e1edp04.
            APPEND lst_edidd TO int_edidd.
          ENDIF. " IF lst_edidd IS NOT INITIAL

*   Populate Total Credit Amount (.7 Sheet)
          CLEAR : lst_e1edp04,lst_edidd.
          SELECT SINGLE
            bsark     " Customer purchase order type
            FROM vbkd " Sales Document: Business Data
            INTO @DATA(lv_bsark_temp)
            WHERE vbeln = @dobject-objky+0(10)
            AND  posnr = @lv_posnr.
          IF sy-subrc = 0.
            IF ( lv_bsark_temp = lv_bsark_css
            OR lv_bsark_temp = lv_bsark_pq ).
              lst_e1edp04-mwsbt = lv_netwr.
              lst_e1edp04-mwskz = lc_mwskz_002. "Value '002' for .7 sheet
              IF lst_edidd IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
                lst_edidd-sdata = lst_e1edp04.
                APPEND lst_edidd TO int_edidd.
              ENDIF. " IF lst_edidd IS NOT INITIAL
            ELSEIF  lv_bsark_temp = lv_bsark_wol.
              lst_e1edp04-mwsbt = lv_netwr.
              lst_e1edp04-mwskz = lc_mwskz_003. "Value '003' for .12 sheet
              IF lst_edidd IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
                lst_edidd-sdata = lst_e1edp04.
                APPEND lst_edidd TO int_edidd.
              ENDIF. " IF lst_edidd IS NOT INITIAL
            ENDIF. " IF ( lv_bsark_temp = lv_bsark_css
          ENDIF. " IF sy-subrc = 0

        ENDIF. " IF sy-subrc = 0

*   If VBTYP <> 'O' or '6', send blank values
      ELSE. " ELSE -> IF xvbdkr-vbtyp IN lr_vbtyp_o
        CLEAR : lst_edidd,lst_e1edp04-mwsbt.
        lst_e1edp04-mwskz = lc_mwskz_001. "Value '001'.
        IF lst_edidd IS NOT INITIAL.
          lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
          lst_edidd-sdata = lst_e1edp04.
          APPEND lst_edidd TO int_edidd.
        ENDIF. " IF lst_edidd IS NOT INITIAL

        CLEAR : lst_edidd,lst_e1edp04-mwsbt.
        lst_e1edp04-mwskz = lc_mwskz_002. "Value '002'.
        IF lst_edidd IS NOT INITIAL.
          lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
          lst_edidd-sdata = lst_e1edp04.
          APPEND lst_edidd TO int_edidd.
        ENDIF. " IF lst_edidd IS NOT INITIAL

        CLEAR lst_e1edp04-mwsbt.
        lst_e1edp04-mwskz = lc_mwskz_003. "Value '003'.
        IF lst_edidd IS NOT INITIAL.
          lst_edidd-segnam = lc_e1edp04. " 'E1EDP04'.
          lst_edidd-sdata = lst_e1edp04.
          APPEND lst_edidd TO int_edidd.
        ENDIF. " IF lst_edidd IS NOT INITIAL

      ENDIF. " IF xvbdkr-vbtyp IN lr_vbtyp_o

***************************************************
****************E1EDP05****************************
***************************************************

    WHEN lc_e1edp05. " 'E1EDP05'.

*     Begin of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
*     Get the Flag for IDOC Segment E1EDP05 to ensure that the same
*     logic is not repeated again for the same Line Item
      CALL FUNCTION 'ZQTC_OB_INVOIC_GET_FLAGS'
        IMPORTING
          ex_e1edp05 = lv_e1edp05_flag.
      IF lv_e1edp05_flag IS INITIAL.
*     End   of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
*       If condition document exists
        IF xvbdkr-knumv IS NOT INITIAL.

*       Obtain the item nunmber from E1EDP01 segment
*        READ TABLE int_edidd
*        ASSIGNING <lst_edidd_temp>
*        WITH KEY segnam = lc_e1edp01. " 'E1EDP01'.
          LOOP AT int_edidd ASSIGNING <lst_edidd_temp>
          WHERE segnam = lc_e1edp01. " 'E1EDP01'.
          ENDLOOP. " LOOP AT int_edidd ASSIGNING <lst_edidd_temp>
          IF sy-subrc = 0.
            lst_e1edp01_temp = <lst_edidd_temp>-sdata.
          ENDIF. " IF sy-subrc = 0

* Obtain Condition Value for Condition Document
* for different condition types .Consider only
* active condition types
          SELECT knumv, " Number of the document condition
            kposn,      " Condition item number
            kschl,      " Condition type
            kwert,      " Condition value
            kinak,      " Condition is inactive
            koaid       " Condition class
            INTO TABLE @DATA(li_konv)
            FROM konv   " Conditions (Transaction Data)
            WHERE knumv EQ @xvbdkr-knumv
            AND kposn EQ @lst_e1edp01_temp-posex.
*         Begin of DEL:CR#550:WROY:09-JUL-2017:ED2K907166
*         AND kinak   EQ ' '.
*         End   of DEL:CR#550:WROY:09-JUL-2017:ED2K907166
*          AND koaid EQ @lv_koaid_b.
          IF sy-subrc = 0.
            SORT li_konv BY kschl.
          ENDIF. " IF sy-subrc = 0

*        Populate the values of Content Credit, Access Credit, Hosting Credit
*        Based on condition type

*       Content Credit
          READ TABLE li_konv TRANSPORTING NO FIELDS
          WITH KEY kschl = lv_kschl_zcon "Value 'ZCON'
          BINARY SEARCH.
          IF sy-subrc = 0.
            LOOP AT li_konv ASSIGNING FIELD-SYMBOL(<lst_konv>) FROM sy-tabix.
              IF <lst_konv>-kschl NE lv_kschl_zcon.
                EXIT.
              ENDIF. " IF <lst_konv>-kschl NE lv_kschl_zcon

              CLEAR lst_e1edp05.
*           Populate Content Credit
              lst_e1edp05-kobtr = <lst_konv>-kwert.
*           Populate Condition Type
              lst_e1edp05-kschl = <lst_konv>-kschl.
              IF lst_e1edp05 IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp05.
                lst_edidd-sdata = lst_e1edp05.
                APPEND lst_edidd TO int_edidd.
                CLEAR: lst_edidd.
              ENDIF. " IF lst_e1edp05 IS NOT INITIAL
            ENDLOOP. " LOOP AT li_konv ASSIGNING FIELD-SYMBOL(<lst_konv>) FROM sy-tabix
          ENDIF. " IF sy-subrc = 0

*        Access Credit
          READ TABLE li_konv TRANSPORTING NO FIELDS
           WITH KEY kschl = lv_kschl_zacc "Value'ZACC'
          BINARY SEARCH.
          IF sy-subrc = 0.
            LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix.
              IF <lst_konv>-kschl NE lv_kschl_zacc.
                EXIT.
              ENDIF. " IF <lst_konv>-kschl NE lv_kschl_zacc

              CLEAR lst_e1edp05.
*           Populate Access Credit
              lst_e1edp05-kobtr = <lst_konv>-kwert.
*           Populate Condition Type
              lst_e1edp05-kschl = <lst_konv>-kschl.
              IF lst_e1edp05 IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp05.
                lst_edidd-sdata = lst_e1edp05.
                APPEND lst_edidd TO int_edidd.
                CLEAR: lst_edidd.
              ENDIF. " IF lst_e1edp05 IS NOT INITIAL
            ENDLOOP. " LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix
          ENDIF. " IF sy-subrc = 0

*        Hosting Credit
          READ TABLE li_konv TRANSPORTING NO FIELDS
          WITH KEY kschl = lv_kschl_zhos "Value 'ZHOS'
          BINARY SEARCH.
          IF sy-subrc = 0.
            LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix.
              IF <lst_konv>-kschl NE lv_kschl_zhos.
                EXIT.
              ENDIF. " IF <lst_konv>-kschl NE lv_kschl_zhos

              CLEAR lst_e1edp05.
*           Populate Content Credit
              lst_e1edp05-kobtr = <lst_konv>-kwert.
*           Populate Condition Type
              lst_e1edp05-kschl = <lst_konv>-kschl.
              IF lst_e1edp05 IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp05.
                lst_edidd-sdata = lst_e1edp05.
                APPEND lst_edidd TO int_edidd.
                CLEAR : lst_edidd.
              ENDIF. " IF lst_e1edp05 IS NOT INITIAL
            ENDLOOP. " LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix
          ENDIF. " IF sy-subrc = 0

*       Agent Discount
          READ TABLE li_konv TRANSPORTING NO FIELDS
          WITH KEY kschl = lv_kschl_zcsa "Value 'ZCSA'
          BINARY SEARCH.
          IF sy-subrc = 0.
            LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix.
              IF <lst_konv>-kschl NE lv_kschl_zcsa.
                EXIT.
              ENDIF. " IF <lst_konv>-kschl NE lv_kschl_zcsa

              CLEAR lst_e1edp05.
*           Populate Agent Discount
              lst_e1edp05-kobtr = <lst_konv>-kwert.
*           Populate Condition Type
              lst_e1edp05-kschl = <lst_konv>-kschl.
              IF lst_e1edp05 IS NOT INITIAL.
                lst_edidd-segnam = lc_e1edp05.
                lst_edidd-sdata = lst_e1edp05.
                APPEND lst_edidd TO int_edidd.
                CLEAR : lst_edidd.
              ENDIF. " IF lst_e1edp05 IS NOT INITIAL
            ENDLOOP. " LOOP AT li_konv ASSIGNING <lst_konv> FROM sy-tabix
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF xvbdkr-knumv IS NOT INITIAL

*     Populate Sales Tax Amount, Tax Amount
        CLEAR : lst_e1edp05,lst_edidd.
        SELECT SINGLE kzwi6 " Subtotal 6 from pricing procedure for condition
          FROM vbrp         " Billing Document: Item Data
          INTO lv_kzwi6
          WHERE vbeln = dobject-objky+0(10)
          AND posnr = lst_e1edp01_temp-posex.
        IF sy-subrc = 0.

*       Sales Tax Amount ( Sheet .7)
          CLEAR : lst_e1edp05,lst_edidd.
          IF lv_kzwi6 IS NOT INITIAL.
            lst_e1edp05-kobtr = lv_kzwi6.
            lst_e1edp05-alckz = lc_mwskz. "Value '+'.
            lst_edidd-sdata = lst_e1edp05.
            lst_edidd-segnam = lc_e1edp05.
            APPEND lst_edidd TO int_edidd.
            CLEAR lst_edidd.
          ENDIF. " IF lv_kzwi6 IS NOT INITIAL

*       Tax Amount (Sheet .12)
          IF lv_kzwi6 IS NOT INITIAL.
            CLEAR : lst_e1edp05,lst_edidd.
            lst_e1edp05-kobtr = lv_kzwi6.
            lst_e1edp05-mwskz = lc_mwskz_txs. "Value 'TXS'.
            lst_edidd-sdata = lst_e1edp05.
            lst_edidd-segnam = lc_e1edp05.
            APPEND lst_edidd TO int_edidd.
            CLEAR lst_edidd.
          ENDIF. " IF lv_kzwi6 IS NOT INITIAL

*       Sales Tax Amount (Sheet .12)
          CLEAR : lst_e1edp05,lst_edidd.
          IF lv_kzwi6 IS NOT INITIAL.
            lst_e1edp05-kobtr = lv_kzwi6.
            lst_e1edp05-mwskz = lc_mwskz_txc. "Value'TXC'.
            lst_edidd-sdata = lst_e1edp05.
            lst_edidd-segnam = lc_e1edp05.
            APPEND lst_edidd TO int_edidd.
          ENDIF. " IF lv_kzwi6 IS NOT INITIAL

        ENDIF. " IF sy-subrc = 0
*     Begin of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501
*       Set the Flag for IDOC Segment E1EDP05, so that the same logic is
*       not repeated again for the same Line Item
        CALL FUNCTION 'ZQTC_OB_INVOIC_SET_FLAGS'
          EXPORTING
            im_e1edp05 = abap_true.
      ENDIF.
*     End   of ADD:ERP-5935:WROY:25-Jan-2018:ED2K910501

    WHEN OTHERS.

  ENDCASE.
