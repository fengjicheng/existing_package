*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   24/08/2016
* OBJECT ID: I0229
* TRANSPORT NUMBER(S):  ED2K902781, ED2K902778(Dependent)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   24/03/2017
* OBJECT ID: I0348
* TRANSPORT NUMBER(S):  ED2K902781, ED2K902778(Dependent), ED2K905259
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Sayantan Das ( SAYANDAS)
* CREATION DATE:   03/04/2017
* OBJECT ID: I0350
* TRANSPORT NUMBER(S):  ED2K902781, ED2K902778(Dependent), ED2K905259
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K907542
* REFERENCE NO: ERP-3630
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 27-Jul-2017
* DESCRIPTION: Cancellation procedure logic validation has been changed
*              to validate the Canc. Proc maintained in ZCACONSTANT table.
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K908612
* REFERENCE NO: ERP-4331/4520
* DEVELOPER: WROY (Writtick Roy)
* DATE: 20-Sep-2017
* DESCRIPTION: Populate the License Group
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K910163
* REFERENCE NO: ERP-5774
* DEVELOPER: WROY (Writtick Roy)
* DATE: 08-Jan-2018
* DESCRIPTION: Invoice not feeding back to PQ (populate E1EDKA1-IHREZ)
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K910230
* REFERENCE NO: ERP-5764
* DEVELOPER: WROY (Writtick Roy)
* DATE: 10-Jan-2018
* DESCRIPTION: Invoice not feeding back to CSS (populate E1EDKA1-IHREZ)
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K910398
* REFERENCE NO: ERP-6071
* DEVELOPER: WROY (Writtick Roy)
* DATE: 22-Jan-2018
* DESCRIPTION: Populate Suspension Dates for BOM Items
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:  ED2K911150
* REFERENCE NO: CR 6592
* DEVELOPER: SGUDA (Siva Guda)
* DATE: 02-Mar-2018
* DESCRIPTION: Populate New custom partner function 'ZY' to E1EDKA1
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:  ED1K907438
* REFERENCE NO: INC0196251
* DEVELOPER: SAYANDAS (Sayantan Das)/ NGADRE (Niraj Gadre)
* DATE: 23-May-2018
* DESCRIPTION: Logic for population of GJAHR (Z1QTC_E1EDK01_01-GJAHR)has been
*             changed,now it will be taken from POSNR '000010' insted of header
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:  ED1K907438
* REFERENCE NO: INC0194991
* DEVELOPER: SAYANDAS (Sayantan Das)
* DATE: 23-May-2018
* DESCRIPTION: Fiscal Year (GJAHR) needs to populated correctly, irrespective
*              of user date format
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:  ED1K907438
* REFERENCE NO: CR_7722
* DEVELOPER: NPALLA (Nikhilesh Palla)
* DATE: 19-Oct-2018
* DESCRIPTION: Add - "Version" details in Header (Z1QTC_E1EDK01_01) Segment
*              Add - "Acceptance date" details in Item (Z1QTC_E1EDP01_01)
*------------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------------
* REVISION NO:  ED1K909530
* REFERENCE NO: INC0228968 / PRB0043442
* DEVELOPER: RBTIRUMALA/VDPATABALL
* DATE: 07-Feb-2019
* DESCRIPTION: Maintain the Hierarchy level sequence for custom segements
*              z1qtc_e1edka1_01 & z1qtc_e1edpa1_01 in IDOCtype ZQTCE_ORDERS05_01
*-------------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------------
* REVISION NO:  ED1K911479/ED1K911582/ED1K911584/ED1K911586/ED1K911590
* REFERENCE NO: INC0269304/PRB0045318
* DEVELOPER: NPALLA
* DATE: 26-Dec-2019
* DESCRIPTION: Fix incorrect updation on E1EDKA1 of Ship-To(WE) party details
*              Fix Duplicate Segment E1EDKA1 for Master License(ZY) partner funcion
*              Fix Duplicate Segment E1EDPA1 for Sales Rep(VE) partner funcion
*              Fix Duplicate Segment E1EDPA1 for Sales Rep2(ZE) partner funcion
*              Fix Order Acknowledgement Idoc to send "Your Reference"(E1EDKA1-IHREZ)
*               field to PQ for Partner function Master License(ZY).
*-------------------------------------------------------------------------------*
*REVISION NO :   ED2K921221                                          *
*REFERENCE NO:   OTCM-28269                                           *
*DEVELOPER  :    Lahiru Wathudura (LWATHUDURA)                        *
*WRICEF ID  :    I0229                                                *
*DATE       :    01/27/2021                                           *
*DESCRIPTION:    change for release order cancellation                *
*---------------------------------------------------------------------*
*REVISION NO :   ED2K926163/ED2K926231                                *
*REFERENCE NO:   OTCM-40685                                           *
*DEVELOPER  :    Nikhilesh Palla (NPALLA)                             *
*WRICEF ID  :    I0229                                                *
*DATE       :    03/18/2022                                           *
*DESCRIPTION:    Process E1EDP01 Segment (Action field) only when     *
*                Output Type is NOT ZOA2 (ZOA2 updated in ZQTCN_SEGMENT_FILL_I0229_09)*
*---------------------------------------------------------------------*
*** Types Declaration
TYPES:BEGIN OF lty_jptidcdassign,
        idcodetype TYPE ismidcodetype,
        identcode  TYPE ismidentcode, " Identification Code
      END OF lty_jptidcdassign.

TYPES: BEGIN OF lty_jkseinterrupt,
         vbeln      TYPE vbeln,          " Sales and Distribution Document Number
         posnr      TYPE posnr,          " Item number of the SD document
         valid_from TYPE jinterruptfrom, " IS-M: Suspension From
         valid_to   TYPE jinterruptto,   " IS-M: Suspension To
       END OF lty_jkseinterrupt.

TYPES: BEGIN OF lty_zqtc_jgc_society,
         society        TYPE zzpartner2,       " Business Partner 2 or Society number
         society_acrnym TYPE zzsociety_acrnym, " Society Name
       END OF  lty_zqtc_jgc_society.

TYPES: BEGIN OF lty_veda,
         vbeln   TYPE vbeln_va,   " Sales Document
         vposn   TYPE posnr_va,   " Sales Document Item
         vkuesch TYPE vkues_veda, " Assignment cancellation procedure/cancellation rule
         vkuegru TYPE vkgru_veda, " Reason for Cancellation of Contract
         vbedkue TYPE vbedk_veda, " Date of cancellation document from contract partner
*** BOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
         vabndat TYPE vadat_veda, " Agreement acceptance date
*** EOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
       END OF lty_veda.

TYPES: BEGIN OF lty_tvkgt,
         spras  TYPE spras,      " Language Key
         kuegru TYPE vkgru_veda, " Reason for Cancellation of Contract
         bezei  TYPE bezei40,    " Description
       END OF lty_tvkgt.

TYPES: BEGIN OF lty_but0id,
         partner  TYPE bu_partner,   " Business Partner Number
         type     TYPE bu_id_type,
         idnumber TYPE bu_id_number, " Identification Number
       END OF lty_but0id.

TYPES: BEGIN OF lty_adr6,
         addrnumber TYPE ad_addrnum, " Address number
         smtp_addr  TYPE ad_smtpadr, " E-Mail Address
       END OF lty_adr6.

TYPES: BEGIN OF lty_nast,
         objky TYPE na_objkey, " Object key
         kschl TYPE sna_kschl, " Message type
         vstat TYPE na_vstat,  " Processing status of message
       END OF lty_nast.

TYPES : BEGIN OF lty_knvv,
          kunnr TYPE kunnr, " Customer Number
          vkorg TYPE vkorg, " Sales Organization
          vtweg TYPE vtweg, " Distribution Channel
          spart TYPE spart, " Division
          kdgrp TYPE kdgrp, " Customer group
          zzfte TYPE zzfte, " Number of FTE’s
        END OF lty_knvv.

TYPES: BEGIN OF lty_mara,
         matnr        TYPE matnr, " Material Number
         ismpubltype  TYPE ismpubltype,
         ismmediatype TYPE ismmediatype,
         ismconttype  TYPE ismconttype,
       END OF lty_mara.

*** Local data declaration
DATA:
*** Local variable declaration
  lv_line              TYPE sytabix,      " Row Index of Internal Tables
  lv_line1             TYPE sytabix,      " Row Index of Internal Tables
  lv_line2             TYPE sytabix,      " Row Index of Internal Tables
  lv_vbeln             TYPE vbeln_va,     " Sales Document
  lv_vbeln1            TYPE vbeln_va,     " Sales Document
  lv_vbeln2            TYPE vbeln_va,     " Sales Document
  lv_posnr1            TYPE posnr_va,     " Sales Document Item
  lv_partn             TYPE bu_id_number, " Identification Number
  lv_uepos             TYPE uepos,        " Higher-level item in bill of material structures
  lv_count             TYPE i,            " Count of type Integers
*  lv_veflag            TYPE char1 VALUE abap_false, " Veflag of type CHAR1
  lv_kunnr             TYPE kunnr, " Customer Number
*  lv_kunnr1            TYPE kunnr,                  " Customer Number
  lv_kunnr2            TYPE kunnr, " Customer Number
  lv_vkorg             TYPE vkorg, " Sales Organization
  lv_vtweg             TYPE vtweg, " Distribution Channel
  lv_spart             TYPE spart, " Division
  lv_matnr             TYPE matnr, " Material Number
* Begin of ADD:ERP-XXXX:WROY:01-JUNE-2017:ED2K906054
  lv_matnr_ext         TYPE matnr, " Material Number
* End   of ADD:ERP-XXXX:WROY:01-JUNE-2017:ED2K906054
  lv_vbegdat2          TYPE char8,            " Vbegdat2 of type CHAR8
  lv_year              TYPE char4,            " Year of type CHAR4
  lv_vbegdat1          TYPE vbdat_veda,       " Contract start date
  lv_vbegdat           TYPE vbdat_veda,       " Contract start date
  lv_venddat           TYPE vndat_veda,       " Contract end date
  lv_valid_date_flag   TYPE char1,            " Valid_date_flag of type CHAR1
  lv_content_date_flag TYPE char1,            " Content_date_flag of type CHAR1
  lv_license_date_flag TYPE char1,            " License_date_flag of type CHAR1
  lv_sales_rep_flag    TYPE char1,            " Sales_rep_flag of type CHAR1
  lv_acronym           TYPE zzsociety_acrnym, " Society Acronym
  lv_idnumber          TYPE bu_id_number,     " Identification Number
  lv_adrnr             TYPE adrnr,            " Address
  lv_auart             TYPE auart,            " Sales Document Type
  lv_iso_country_code  TYPE intca,            " ISO Country Code
* Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
  lv_zy_seg_flag       TYPE char1,            " ZY Segment Flag
  lv_index_tmp         TYPE syst-tabix,       " Index
  lv_e1edpa1_flg       TYPE char1,            " E1EDPA1 Segment Flag
  lst_e1edpa1_tmp      TYPE e1edpa1,          " E1EDPA1 Segment
* End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*** Local internal Table and Local Work area declaration
  li_ord_status        TYPE ztqtc_ord_status,
  li_ord_status1       TYPE ztqtc_ord_status,
  li_hdr_status        TYPE ztqtc_ord_hdr_status,
  li_itm_vbup_status   TYPE ztqtc_ord_item_status,
  li_hdr_cond          TYPE ztqtc_hdr_cond,
  li_itm_cond          TYPE ztqtc_itm_cond,
  li_rej_status        TYPE ztqtc_tvagt,
  lst_ord_status       TYPE zstqtc_ord_status, " Structure for Order Type
  lst_ord_status1      TYPE zstqtc_ord_status, " Structure for Order Type
  lst_rej_status       TYPE zstqtc_tvagt,      " Structure For Rejection Status Text
*  lst_hdr_cond         TYPE zstqtc_hdr_cond,        " Structure for Header Condition Group
*  lst_itm_cond         TYPE zstqtc_itm_cond,        " Structure for Item Condition Group
  lst_hdr_status       TYPE z1qtc_e1edk01_01,       " Header General Data Entension
  lst_itm_vbup_status  TYPE z1qtc_e1edp01_01,       " IDOC Segment for STATUS Field in Item Level
  lst_jptidcdassign    TYPE lty_jptidcdassign,
  lst_knvv             TYPE lty_knvv,
  lst_vbap             TYPE vbap,                   " Sales Document: Item Data
  lst_mara             TYPE lty_mara,
  li_jkseinterrupt     TYPE STANDARD TABLE OF lty_jkseinterrupt,
  lst_jkseinterrupt    TYPE lty_jkseinterrupt,
  li_vbpa              TYPE STANDARD TABLE OF vbpa, " Sales Document: Partner
*  li_vbpa1             TYPE STANDARD TABLE OF vbpa, " Sales Document: Partner
  li_zqtc_jgc_society  TYPE STANDARD TABLE OF lty_zqtc_jgc_society,
  lst_zqtc_jgc_society TYPE lty_zqtc_jgc_society,
  lst_veda             TYPE lty_veda,
  lst_tvkgt            TYPE lty_tvkgt,
  li_but0id            TYPE STANDARD TABLE OF lty_but0id,
  lst_but0id           TYPE lty_but0id,
  lst_adr6             TYPE lty_adr6,
  lst_vbpa             TYPE vbpa,  " Sales Document: Partner
  lst_vbadr            TYPE vbadr, " Address work area
  lst_edidd            TYPE edidd, " Data record (IDoc)
  lst_edidd1           TYPE edidd, " Data record (IDoc)
  lst_edidd2           TYPE edidd, " Data record (IDoc)
* Begin of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
  lst_edidd3           TYPE edidd, " Data record (IDoc)
  lv_lines             TYPE i,     " Lines of type Integers
* End of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
  lst_e1edka1          TYPE e1edka1, " IDoc: Document Header Partner Information
* Begin of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
  lst_e1edka1_zy       TYPE e1edka1, " IDoc: Document Header Partner Information
* End of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
* Begin of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
  lst_e1edka1_tmp      TYPE e1edka1, " IDoc: Document Header Partner Information
* End   of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
  lst_e1edpa1          TYPE e1edpa1, " IDoc: Document Item Partner Information
  lst_e1edp19          TYPE e1edp19, " IDoc: Document Item Object Identification
  lst_e1edp02          TYPE e1edp02, " IDoc: Document Item Reference Data
  lst_e1edp01          TYPE e1edp01, " IDoc: Document Item General Data
  lst_e1edk03          TYPE e1edk03, " IDoc: Document header date segment
  lst_e1edp03          TYPE e1edp03, " IDoc: Document Item Date Segment
  lst_e1edka3          TYPE e1edka3, " IDoc: Document Header Partner Information Additional Data
  lst_e1edpa3          TYPE e1edpa3, " IDoc: Document Item Partner Information Additional Data
* Begin of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
  li_zcaconst_ent      TYPE zcat_constants,
  lst_zcaconst_ent     TYPE zcast_constant, " Wiley Application Constant Table
  lr_canc_proc_zca     TYPE efg_tab_ranges, " Range for Cancellation procedure.
* End of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
  lst_z1qtc_e1edka1_01 TYPE z1qtc_e1edka1_01, " Partner Information (Legacy Customer Number)
  lst_z1qtc_e1edpa1_01 TYPE z1qtc_e1edpa1_01, " Partner Information (Legacy Customer Number)
  lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
  lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
*** BOC BY NGADRE on 23-MAY-2018 for INC0196251 in ED1K907438
  li_ord_status1_tmp   TYPE ztqtc_ord_status,
*** EOC BY NGADRE on 23-MAY-2018 for INC0196251 in ED1K907438
* BOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
  lr_cancellation_proc TYPE efg_tab_ranges, " Range for Cancellation procedure.
* EOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
* BOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
  lr_kschl             TYPE STANDARD TABLE OF ty_kschl. " Range for Output Type.
* EOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*

*** Local Constant Declaration
CONSTANTS: lc_posnr            TYPE posnr_va VALUE '000000',         " Sales Document Item
           lc_z1qtc_e1edka1_01 TYPE char16 VALUE 'Z1QTC_E1EDKA1_01', " Z1qtc_e1edka1_01 of type CHAR16
           lc_z1qtc_e1edpa1_01 TYPE char16 VALUE 'Z1QTC_E1EDPA1_01', " Z1qtc_e1edka1_01 of type CHAR16
           lc_z1qtc_e1edk01_01 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01 of type CHAR16
           lc_e1edk03          TYPE char7  VALUE 'E1EDK03',          " E1edk03 of type CHAR7
           lc_e1edka1          TYPE char7  VALUE 'E1EDKA1',          " E1edka1 of type CHAR7
           lc_e1edp03          TYPE char7  VALUE 'E1EDP03',          " E1edp03 of type CHAR7
           lc_e1edp19          TYPE char7  VALUE 'E1EDP19',          " E1edp19 of type CHAR7
           lc_e1edka3          TYPE char7  VALUE 'E1EDKA3',          " E1edka3 of type CHAR7
           lc_e1edpa3          TYPE char7  VALUE 'E1EDPA3',          " E1edka3 of type CHAR7
           lc_e1edpa1          TYPE char7  VALUE 'E1EDPA1',          " E1edka3 of type CHAR7
           lc_we               TYPE char2  VALUE 'WE',               " We of type CHAR2
           lc_ag               TYPE char2  VALUE 'AG',               " Ag of type CHAR2
           lc_za               TYPE char2  VALUE 'ZA',               " Za of type CHAR2
           lc_ze               TYPE char2  VALUE 'ZE',               " Ve of type CHAR2
           lc_ve               TYPE char2  VALUE 'VE',               " Ve of type CHAR2
* Begin of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
           lc_zy               TYPE char2  VALUE 'ZY', " ZY of type char2
* End of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
* Begin of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
           lc_canc_proc        TYPE rvari_vnam VALUE 'CANC_PROC', " ABAP: Name of Variant Variable
           lc_devid_i0229      TYPE zdevid VALUE 'I0229',         " Development ID
* End of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
           lc_z1qtc_e1edp01_01 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01 of type CHAR16
           lc_qualf1           TYPE edi_qualfr VALUE '001',          " IDOC qualifier reference document
           lc_qualf2           TYPE edi_qualfr VALUE '002',          " IDOC qualifier reference document
           lc_eml              TYPE edi_qualp VALUE 'EML',           " IDOC Partner identification (e.g.Dun&Bradstreet number)
           lc_019              TYPE edi_iddat VALUE '019',           " Qualifier for IDOC date segment
           lc_020              TYPE edi_iddat VALUE '020',           " Qualifier for IDOC date segment
           lc_ssd              TYPE edi_iddat VALUE 'SSD',           " Qualifier for IDOC date segment
           lc_sed              TYPE edi_iddat VALUE 'SED',           " Qualifier for IDOC date segment
           lc_csd              TYPE edi_iddat VALUE 'CSD',           " Qualifier for IDOC date segment
           lc_ced              TYPE edi_iddat VALUE 'CED',           " Qualifier for IDOC date segment
           lc_lsd              TYPE edi_iddat VALUE 'LSD',           " Qualifier for IDOC date segment
           lc_led              TYPE edi_iddat VALUE 'LED',           " Qualifier for IDOC date segment
           lc_zwint            TYPE bu_id_type VALUE 'ZWINT',        " Identification Type
           lc_ac2              TYPE edi1229_a VALUE '002',           " Action code for the item
           lc_ac1              TYPE edi1229_a VALUE '001',           " Action code for the item
           lc_zgrc             TYPE auart VALUE 'ZGRC',              " Sales Document Type
           lc_z001             TYPE vkues_veda VALUE 'Z001',         " Assignment cancellation procedure/cancellation rule
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
           lc_h02              TYPE edi_hlevel VALUE '02',
           lc_h03              TYPE edi_hlevel VALUE '03',
           lc_h04              TYPE edi_hlevel VALUE '04',
* BOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
           lc_ac3              TYPE edi1229_a VALUE  '003'. " ABAP: Name of Variant Variable
* EOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
*** Describing IDOC Data Table
DESCRIBE TABLE int_edidd LINES lv_line.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd INTO lst_edidd INDEX lv_line.
IF sy-subrc = 0.


*** Checking segments and implementing required logic
  CASE lst_edidd-segnam.


    WHEN 'E1EDKA1'. " For Partner Information
*** Inserting Partner in header segment
      lst_e1edka1 = lst_edidd-sdata.
*     Begin of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
      lst_e1edka1_tmp = lst_edidd-sdata.
*     End   of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
*** BOC for I0348
*** code for Sales Representative
*** Calling FM to check if value is set or not
      CALL FUNCTION 'ZQTC_GET_FLAG'
        IMPORTING
          ex_sales_rep = lv_sales_rep_flag.

* Begin of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
*     Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*      LOOP AT int_edidd INTO lst_edidd3 WHERE segnam = 'E1EDKA1'.
*     Check if segment for Partner Function "ZY" already exists
      CLEAR lv_zy_seg_flag.
      LOOP AT int_edidd INTO lst_edidd3 WHERE segnam = 'E1EDKA1'.
        IF lst_edidd3-sdata+0(2) = lc_zy.
          lv_zy_seg_flag = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_zy_seg_flag IS INITIAL.
        READ TABLE int_edidd INTO lst_edidd3 WITH KEY segnam = 'E1EDKA1'.
        IF sy-subrc = 0.
*     End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
          lst_e1edka1_zy =  lst_edidd3-sdata.
*        MOVE-CORRESPONDING LST_E1EDKA1_ZY TO LST_E1EDKA1.
*       Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*        IF  lst_e1edka1_zy-parvw = lc_zy.
*          CLEAR : lst_e1edka1_zy.
*          EXIT.
*        ELSE. " ELSE -> IF lst_e1edka1_zy-parvw = lc_zy
*       End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
          DESCRIBE TABLE int_edidd LINES lv_lines.
          li_vbpa[] = dxvbpa[].
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = lc_zy
                                                    posnr = lc_posnr.
          IF sy-subrc EQ 0.
            DELETE li_vbpa WHERE parvw NE lc_zy.
            IF li_vbpa IS NOT INITIAL.
              READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = lc_posnr.
              IF sy-subrc EQ 0.
                CALL FUNCTION 'VIEW_VBADR'
                  EXPORTING
                    input   = lst_vbpa
                  IMPORTING
                    adresse = lst_vbadr
                  EXCEPTIONS
                    error   = 1
                    OTHERS  = 2.
                IF sy-subrc EQ 0.
                  lst_e1edka1_zy-parvw = lst_vbpa-parvw.
                  lst_e1edka1_zy-partn = lst_vbpa-pernr.
                  MOVE-CORRESPONDING lst_vbadr TO lst_e1edka1_zy.
*- convert postal code ------------------------------------------------*
                  PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                    USING lst_vbadr-pstlz lst_e1edka1_zy-pstlz.
*- convert postal code Post office box --------------------------------*
                  PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                    USING lst_vbadr-pstl2 lst_e1edka1_zy-pstl2.
                  WRITE lst_vbadr-spras TO lst_e1edka1_zy-spras_iso.
*- country in ISO-Code ------------------------------------------------*
                  IF NOT lst_vbpa-land1 IS INITIAL.
                    CALL FUNCTION 'SAP_TO_ISO_COUNTRY_CODE'
                      EXPORTING
                        sap_code    = lst_vbpa-land1
                      IMPORTING
                        iso_code    = lv_iso_country_code
                      EXCEPTIONS
                        not_found   = 1
                        no_iso_code = 2.

                    IF sy-subrc EQ 0.
                      lst_e1edka1_zy-land1 = lv_iso_country_code.
                    ENDIF. " IF sy-subrc EQ 0
                  ELSE. " ELSE -> IF NOT lst_vbpa-land1 IS INITIAL
                    lst_e1edka1_zy-land1 = ' '. "Ensure that values from
                  ENDIF. " IF NOT lst_vbpa-land1 IS INITIAL
                  lst_e1edka1_zy-parvw = lst_vbpa-parvw.
*                  LST_E1EDKA1_ZY-PARTN = LST_VBPA-PERNR.
                  lst_e1edka1_zy-partn = lst_vbpa-kunnr.
*                 Begin of Change:INC0269304/PRB0045318:NPALLA:29-Jan-2020:ED1K911582
                  lst_e1edka1_zy-ihrez = dxhvbkd-ihrez_e.
*                 End of Change:INC0269304/PRB0045318:NPALLA:29-Jan-2020:ED1K911582
                ENDIF. " IF sy-subrc EQ 0

                CLEAR lst_edidd.
                lst_edidd-segnam = lc_e1edka1.
                lst_edidd-sdata =  lst_e1edka1_zy.
                INSERT lst_edidd INTO int_edidd INDEX lv_lines. "LV_LINE.
                lv_kunnr = lst_e1edka1_zy-partn.
                CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
                  EXPORTING
                    im_company_code    = dxvbak-vkorg
                    im_sap_customer    = lv_kunnr
                  IMPORTING
                    ex_leg_customer    = lv_partn
                  EXCEPTIONS
                    wrong_input_values = 1
                    invalid_comp_code  = 2
                    OTHERS             = 3.

                IF sy-subrc = 0 AND
                   lv_partn IS NOT INITIAL.
                  lst_z1qtc_e1edka1_01-partner = lv_partn.
* Begin of ADD:INC0228968 / PRB0043442:RBTIRUMALA:07-FEB-2019:ED1K909530
                ELSE.
                  "Do nothing
                ENDIF. " IF sy-subrc = 0 AND

                CLEAR : lst_edidd.
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
                lst_edidd-hlevel = lc_h03." '03'.
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
*     Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*                lst_edidd-segnam = lc_z1qtc_e1edka1_01. " Adding new segment
*                lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
**                  APPEND LST_EDIDD TO INT_EDIDD.
*                INSERT lst_edidd INTO int_edidd INDEX lv_lines + 1.
                IF lst_z1qtc_e1edka1_01 IS NOT INITIAL.
                  lst_edidd-segnam = lc_z1qtc_e1edka1_01. " Adding new segment
                  lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
*                    APPEND LST_EDIDD TO INT_EDIDD.
                  INSERT lst_edidd INTO int_edidd INDEX lv_lines + 1.
                ENDIF.
*     End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
* End of ADD:INC0228968 / PRB0043442:RBTIRUMALA:07-FEB-2019:ED1K909530

*      ENDIF. " IF lst_e1edka1-parvw NE lc_we AND lst_e1edka1-parvw NE lc_ag
****   EMAIL Address ----->>
                lv_adrnr = lst_vbpa-adrnr.
**** Select data from ADR6 table
                SELECT addrnumber " Address number
                       smtp_addr  " E-Mail Address
                  FROM adr6       " E-Mail Addresses (Business Address Services)
                  UP TO 1 ROWS
                  INTO lst_adr6
                  WHERE addrnumber = lv_adrnr.
                ENDSELECT.
                IF sy-subrc = 0.
                  lst_e1edka3-qualp = lc_eml.
                  lst_e1edka3-stdpn = lst_adr6-smtp_addr.
                  CLEAR lst_edidd.
                  lst_edidd-segnam = lc_e1edka3. " Adding new segment
                  lst_edidd-sdata =  lst_e1edka3.
*                  APPEND LST_EDIDD TO INT_EDIDD.
*     Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*                  INSERT lst_edidd INTO int_edidd INDEX lv_lines + 2.
                  IF lst_z1qtc_e1edka1_01 IS NOT INITIAL.
                    INSERT lst_edidd INTO int_edidd INDEX lv_lines + 2.
                  ELSE.
                    INSERT lst_edidd INTO int_edidd INDEX lv_lines + 1.
                  ENDIF.
*     End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
                ENDIF. " IF sy-subrc = 0

*                LV_LINE = LV_LINE + 1.
                REFRESH:li_vbpa.
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF li_vbpa IS NOT INITIAL
          ENDIF. " IF sy-subrc EQ 0
*     Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*        ENDIF. " IF lst_e1edka1_zy-parvw = lc_zy
*      ENDLOOP. " LOOP AT int_edidd INTO lst_edidd3 WHERE segnam = 'E1EDKA1'
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lv_zy_seg_flag IS INITIAL.
*     End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590

* End of ADD:CR 6592:SGUDA:02-Mar-2018:ED2K911150
*     Begin of Change/Comment:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*      IF lv_sales_rep_flag = abap_false.
*
*        lv_line1 = lv_line - 1. "In order to get previous INDEX we substract 1
*        READ TABLE int_edidd INTO lst_edidd2 INDEX lv_line1.
*
*        IF sy-subrc = 0 AND lst_edidd2-segnam NE lc_e1edka1.
*          li_vbpa[] = dxvbpa[].
*          DELETE li_vbpa WHERE parvw NE lc_ve.
*
*          IF li_vbpa IS NOT INITIAL.
**** Calling the FM to set the value
*            CALL FUNCTION 'ZQTC_SET_FLAG'
*              EXPORTING
*                im_sales_rep = abap_true.
*
*            READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = lc_posnr.
*
*            IF sy-subrc EQ 0.
*              CALL FUNCTION 'VIEW_VBADR'
*                EXPORTING
*                  input   = lst_vbpa
*                IMPORTING
*                  adresse = lst_vbadr
*                EXCEPTIONS
*                  error   = 1
*                  OTHERS  = 2.
*              IF sy-subrc EQ 0.
*                MOVE-CORRESPONDING lst_vbadr TO lst_e1edka1.
**- convert postal code ------------------------------------------------*
*                PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
*                  USING lst_vbadr-pstlz lst_e1edka1-pstlz.
**- convert postal code Post office box --------------------------------*
*                PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
*                  USING lst_vbadr-pstl2 lst_e1edka1-pstl2.
*                WRITE lst_vbadr-spras TO lst_e1edka1-spras_iso.
**- country in ISO-Code ------------------------------------------------*
*                IF NOT lst_vbpa-land1 IS INITIAL.
*                  CALL FUNCTION 'SAP_TO_ISO_COUNTRY_CODE'
*                    EXPORTING
*                      sap_code    = lst_vbpa-land1
*                    IMPORTING
*                      iso_code    = lv_iso_country_code
*                    EXCEPTIONS
*                      not_found   = 1
*                      no_iso_code = 2.
*
*                  IF sy-subrc EQ 0.
*                    lst_e1edka1-land1 = lv_iso_country_code.
*                  ENDIF. " IF sy-subrc EQ 0
*                ELSE. " ELSE -> IF NOT lst_vbpa-land1 IS INITIAL
*                  lst_e1edka1-land1 = ' '. "Ensure that values from
*                ENDIF. " IF NOT lst_vbpa-land1 IS INITIAL
*                lst_e1edka1-parvw = lst_vbpa-parvw.
*                lst_e1edka1-partn = lst_vbpa-pernr.
*              ENDIF. " IF sy-subrc EQ 0
*
*              CLEAR lst_edidd.
*              lst_edidd-segnam = lc_e1edka1.
*              lst_edidd-sdata =  lst_e1edka1.
*              INSERT lst_edidd INTO int_edidd INDEX lv_line.
**             Begin of ADD:ERP-5764:WROY:10-Jan-2018:ED2K910230
*              lv_line = lv_line + 1.
**             End   of ADD:ERP-5764:WROY:10-Jan-2018:ED2K910230
*            ENDIF. " IF sy-subrc EQ 0
*          ENDIF. " IF li_vbpa IS NOT INITIAL
*        ENDIF. " IF sy-subrc = 0 AND lst_edidd2-segnam NE lc_e1edka1
*      ENDIF. " IF lv_sales_rep_flag = abap_false
*     End of Change/Comment:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*** code for Sales Representative
*** EOC for I0348
*     Begin of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
*     Previous Block of logic is overwriting some of the important field values (eg PARVW)
      lst_e1edka1 = lst_e1edka1_tmp.
*     End   of ADD:ERP-5774:WROY:08-Jan-2018:ED2K910163
*** To Insert IHREZ_E in Header Segment
      IF lst_e1edka1-parvw = lc_we. "ship-to-party

        lst_e1edka1-ihrez = dxhvbkd-ihrez_e.

        lst_edidd-sdata  = lst_e1edka1.
*** Modifying IDOC Data table
*       Begin of Change:INC0269304/PRB0045318:NPALLA:26-Dec-2019:ED1K911479
*        MODIFY int_edidd FROM lst_edidd INDEX lv_line TRANSPORTING sdata.  "--ED1K911479
        CLEAR: lv_index_tmp.
        READ TABLE int_edidd TRANSPORTING NO FIELDS WITH KEY segnam = lc_e1edka1
                                                             sdata  = lst_e1edka1_tmp.
        IF sy-subrc = 0.
          lv_index_tmp = sy-tabix.
          MODIFY int_edidd FROM lst_edidd INDEX lv_index_tmp TRANSPORTING sdata.
        ENDIF.
*       End of Change:INC0269304/PRB0045318:NPALLA:26-Dec-2019:ED1K911479

******** IDNUMBER  field
        CLEAR: lv_idnumber.
        lv_kunnr = lst_e1edka1-partn.
**** Fetching value from BUT0ID table
        SELECT partner  " Business Partner Number
               type     " Identification Type
               idnumber " Identification Number
          FROM but0id   " BP: ID Numbers
          INTO TABLE li_but0id
          WHERE type = lc_zwint
          AND partner = lv_kunnr.

        IF sy-subrc = 0.
          READ TABLE li_but0id INTO lst_but0id INDEX 1.
          IF sy-subrc = 0.
            lv_idnumber = lst_but0id-idnumber.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0

        IF lv_idnumber IS NOT INITIAL.

          lst_z1qtc_e1edka1_01-partner = lv_idnumber.
          lst_z1qtc_e1edka1_01-type = lc_zwint.

          CLEAR lst_edidd.
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
          lst_edidd-hlevel = lc_h03. "'03'.
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
          lst_edidd-segnam = lc_z1qtc_e1edka1_01. " Adding new segment
          lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
          APPEND lst_edidd TO int_edidd.
        ENDIF. " IF lv_idnumber IS NOT INITIAL

      ENDIF. " IF lst_e1edka1-parvw = lc_we

*** BOC of I0348
      IF lst_e1edka1-parvw = lc_ag. "sold-to-party

        CLEAR: lv_idnumber.
        lv_kunnr = lst_e1edka1-partn.
**** Fetching value from BUT0ID table
        SELECT partner  " Business Partner Number
               type     " Identification Type
               idnumber " Identification Number
          FROM but0id   " BP: ID Numbers
          INTO TABLE li_but0id
          WHERE type = lc_zwint
          AND partner = lv_kunnr.

        IF sy-subrc = 0.
          READ TABLE li_but0id INTO lst_but0id INDEX 1.
          IF sy-subrc = 0.
            lv_idnumber = lst_but0id-idnumber.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0

        IF lv_idnumber IS NOT INITIAL.

          lst_z1qtc_e1edka1_01-partner = lv_idnumber.
          lst_z1qtc_e1edka1_01-type = lc_zwint.

          CLEAR lst_edidd.
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
          lst_edidd-hlevel = lc_h03." '03'.
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
          lst_edidd-segnam = lc_z1qtc_e1edka1_01. " Adding new segment
          lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
          APPEND lst_edidd TO int_edidd.
        ENDIF. " IF lv_idnumber IS NOT INITIAL

      ENDIF. " IF lst_e1edka1-parvw = lc_ag
*** EOC for I0348


*      IF lst_e1edka1-parvw NE lc_we AND lst_e1edka1-parvw NE lc_ag.

*** Calling the FM to convert SAP Customer
      lv_kunnr = lst_e1edka1-partn.
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = dxvbak-vkorg
          im_sap_customer    = lv_kunnr
        IMPORTING
          ex_leg_customer    = lv_partn
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.

      IF sy-subrc = 0 AND
         lv_partn IS NOT INITIAL.
        lst_z1qtc_e1edka1_01-partner = lv_partn.
* Begin of ADD and Commented:INC0228968 / PRB0043442:VDPATABALL:11-FEB-2019:ED1K909558
**        CLEAR lst_edidd.
**        lst_edidd-segnam = lc_z1qtc_e1edka1_01. " Adding new segment
**        lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
**        APPEND lst_edidd TO int_edidd.
      ENDIF. " IF sy-subrc = 0 AND
      CLEAR lst_edidd.
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
      lst_edidd-hlevel = lc_h03."'03'.
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
*     Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*      lst_edidd-segnam = lc_z1qtc_e1edka1_01.
*      lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
*      APPEND lst_edidd TO int_edidd.
      IF lst_z1qtc_e1edka1_01 IS NOT INITIAL.
        lst_edidd-segnam = lc_z1qtc_e1edka1_01.
        lst_edidd-sdata =  lst_z1qtc_e1edka1_01.
        APPEND lst_edidd TO int_edidd.
      ENDIF.
*     End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
* End of ADD and Commented:INC0228968 / PRB0043442:VDPATABALL:11-FEB-2019:ED1K909558
*      ENDIF. " IF lst_e1edka1-parvw NE lc_we AND lst_e1edka1-parvw NE lc_ag

****   EMAIL Address ----->>
      lv_adrnr = dxvbpa-adrnr.

**** Select data from ADR6 table
      SELECT addrnumber " Address number
             smtp_addr  " E-Mail Address
        FROM adr6       " E-Mail Addresses (Business Address Services)
        UP TO 1 ROWS
        INTO lst_adr6
        WHERE addrnumber = lv_adrnr.
      ENDSELECT.
      IF sy-subrc = 0.
        lst_e1edka3-qualp = lc_eml.
        lst_e1edka3-stdpn = lst_adr6-smtp_addr.
        CLEAR lst_edidd.
        lst_edidd-segnam = lc_e1edka3. " Adding new segment
        lst_edidd-sdata =  lst_e1edka3.
        APPEND lst_edidd TO int_edidd.
      ENDIF. " IF sy-subrc = 0

    WHEN 'E1EDPA1'.
      lst_e1edpa1 = lst_edidd-sdata.

      IF lst_e1edpa1-parvw = lc_we. "ship-to-party
        lv_kunnr = lst_e1edpa1-partn.
**** Fetching value from BUT0ID table
        SELECT partner  " Business Partner Number
               type     " Identification Type
               idnumber " Identification Number
          FROM but0id   " BP: ID Numbers
          INTO TABLE li_but0id
          WHERE type = lc_zwint
          AND partner = lv_kunnr.

        IF sy-subrc = 0.
          READ TABLE li_but0id INTO lst_but0id INDEX 1.
          IF sy-subrc = 0.
            lv_idnumber = lst_but0id-idnumber.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0

        IF lv_idnumber IS NOT INITIAL.
          lst_z1qtc_e1edpa1_01-partner = lv_idnumber.
          lst_z1qtc_e1edpa1_01-type = lc_zwint.
        ENDIF. " IF lv_idnumber IS NOT INITIAL

        CLEAR lst_edidd.
*---Begin of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
        lst_edidd-hlevel = lc_h04.
*---End of change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
        lst_edidd-segnam = lc_z1qtc_e1edpa1_01. " Adding new segment
        lst_edidd-sdata =  lst_z1qtc_e1edpa1_01.
        APPEND lst_edidd TO int_edidd.
      ENDIF. " IF lst_e1edpa1-parvw = lc_we

****   EMAIL Address ----->>
      lv_adrnr = dxvbpa-adrnr.

**** Select data from ADR6 table
      SELECT addrnumber " Address number
             smtp_addr  " E-Mail Address
        FROM adr6       " E-Mail Addresses (Business Address Services)
        UP TO 1 ROWS
        INTO lst_adr6
        WHERE addrnumber = lv_adrnr.
      ENDSELECT.
      IF sy-subrc = 0.
        lst_e1edpa3-qualp = lc_eml.
        lst_e1edpa3-stdpn = lst_adr6-smtp_addr.
        CLEAR lst_edidd.
        lst_edidd-segnam = lc_e1edpa3. " Adding new segment
        lst_edidd-sdata =  lst_e1edpa3.
        APPEND lst_edidd TO int_edidd.
      ENDIF. " IF sy-subrc = 0

    WHEN 'E1EDP02'. " For Item Reference Data (IHREZ , BSARK)
      lst_e1edp02 = lst_edidd-sdata.
*** Inserting IHREZ and BSARK in Item segment
*** DXVBKD is a table but it contains corresponding item value in it's header
*** in standard, so we have used dxvbkd
      IF lst_e1edp02-qualf = lc_qualf1. " we will only execute aganst qualifier 001

        lst_e1edp02-ihrez = dxvbkd-ihrez.
        lst_e1edp02-bsark = dxvbkd-bsark.

        lst_edidd-sdata =  lst_e1edp02.
*** Modifying IDOC Data table
        MODIFY int_edidd FROM lst_edidd INDEX lv_line TRANSPORTING sdata.

      ENDIF. " IF lst_e1edp02-qualf = lc_qualf1

    WHEN 'E1EDK03'. " For Header date (Contract start and end date)


      lv_vbeln = dxvbak-vbeln.
*** Calling FM to get contract start date and contract end date For HEADER
      CALL FUNCTION 'ZQTC_ORD_STATUS'
        EXPORTING
          im_vbeln      = lv_vbeln
        IMPORTING
          ex_itm_status = li_ord_status.

*** reading internal table to get contract start date and end date
      READ TABLE li_ord_status  INTO lst_ord_status
      WITH KEY vposn = lc_posnr.                            "000000
      IF sy-subrc = 0.

        lv_vbegdat = lst_ord_status-vbegdat.
        lv_venddat = lst_ord_status-venddat.

      ENDIF. " IF sy-subrc = 0

      lv_line1 = lv_line - 1. "In order to get previous INDEX we substract 1
      READ TABLE int_edidd INTO lst_edidd1 INDEX lv_line1.
*** Checking if previous segment is E1EDK14 or not
      IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edk03.
*** Inserting contract start date and contract end date in header
        IF lv_vbegdat IS NOT INITIAL.

          lst_e1edk03-iddat = lc_019.
          lst_e1edk03-datum = lv_vbegdat.
          lst_edidd-segnam = lc_e1edk03.
          lst_edidd-sdata =  lst_e1edk03.
          APPEND lst_edidd TO int_edidd.

        ENDIF. " IF lv_vbegdat IS NOT INITIAL

        CLEAR: lst_edidd , lst_e1edk03.

        IF lv_venddat IS NOT INITIAL.

          lst_e1edk03-iddat = lc_020.
          lst_e1edk03-datum = lv_venddat.
          lst_edidd-segnam = lc_e1edk03.
          lst_edidd-sdata =  lst_e1edk03.
          APPEND lst_edidd TO int_edidd.

        ENDIF. " IF lv_venddat IS NOT INITIAL

      ENDIF. " IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edk03



    WHEN 'E1EDP03'. " For Item Date (Contract Start and end date)

*** Calling FM to get contract start date and contract end date

      lv_vbeln = dxvbak-vbeln.

      CALL FUNCTION 'ZQTC_ORD_STATUS'
        EXPORTING
          im_vbeln      = lv_vbeln
        IMPORTING
          ex_itm_status = li_ord_status.



*** reading internal table to get contract start date and end date
*** DXVBAP is a table but it contains corresponding item value in it's header
*** in standard, so we have used dxvbap
      READ TABLE li_ord_status  INTO lst_ord_status
      WITH KEY vposn = dxvbap-posnr.
      IF sy-subrc NE 0.
        READ TABLE li_ord_status  INTO lst_ord_status
        WITH KEY vposn = lc_posnr.                          "000000
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc = 0.

        lv_vbegdat = lst_ord_status-vbegdat.
        lv_venddat = lst_ord_status-venddat.

      ENDIF. " IF sy-subrc = 0
      lv_line1 = lv_line - 1. "In order to get previous INDEX we substract 1
      READ TABLE int_edidd INTO lst_edidd1 INDEX lv_line1.
*** Checking if previous segment is E1EDP02 or not
      IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edp03.

*** Inserting contract start date and contract end date in item
        IF lv_vbegdat IS NOT INITIAL.

          lst_e1edp03-iddat = lc_019.
          lst_e1edp03-datum = lv_vbegdat.
          lst_edidd-segnam = lc_e1edp03.
          lst_edidd-sdata =  lst_e1edp03.
          APPEND lst_edidd TO int_edidd.

        ENDIF. " IF lv_vbegdat IS NOT INITIAL

        CLEAR: lst_edidd , lst_e1edp03.

        IF lv_venddat IS NOT INITIAL.

          lst_e1edp03-iddat = lc_020.
          lst_e1edp03-datum = lv_venddat.
          lst_edidd-segnam = lc_e1edp03.
          lst_edidd-sdata =  lst_e1edp03.
          APPEND lst_edidd TO int_edidd.

        ENDIF. " IF lv_venddat IS NOT INITIAL

*** Suspended start date and Suspended end date
*** Calling FM to check if value is set or not
        CALL FUNCTION 'ZQTC_GET_FLAG'
          IMPORTING
            ex_valid_date = lv_valid_date_flag.

        IF lv_valid_date_flag = abap_false.


          lv_vbeln1 = dxvbap-vbeln.
          lv_posnr1 = dxvbap-posnr.

*** Select data from JKSEINTERRUPT
          SELECT vbeln         " Sales and Distribution Document Number
                 posnr         " Item number of the SD document
                 valid_from    " IS-M: Suspension From
                 valid_to      " IS-M: Suspension To
            FROM jkseinterrupt " IS-M: Suspensions
            INTO TABLE li_jkseinterrupt
            WHERE vbeln = lv_vbeln1
            AND posnr = lv_posnr1.
          IF sy-subrc = 0.
            SORT li_jkseinterrupt BY valid_from valid_to.
            IF sy-subrc = 0.
              DESCRIBE TABLE li_jkseinterrupt LINES lv_line2.
              READ TABLE li_jkseinterrupt INTO lst_jkseinterrupt INDEX lv_line2.
              IF sy-subrc = 0.
                CLEAR :lst_edidd, lst_e1edp03.
                IF lst_jkseinterrupt-valid_from IS NOT INITIAL.
                  lst_e1edp03-iddat = lc_ssd.
                  lst_e1edp03-datum = lst_jkseinterrupt-valid_from.
                  lst_edidd-segnam = lc_e1edp03.
                  lst_edidd-sdata =  lst_e1edp03.
                  APPEND lst_edidd TO int_edidd.
                ENDIF. " IF lst_jkseinterrupt-valid_from IS NOT INITIAL

                CLEAR: lst_edidd , lst_e1edp03.

                IF lst_jkseinterrupt-valid_to IS NOT INITIAL.
                  lst_e1edp03-iddat = lc_sed.
                  lst_e1edp03-datum = lst_jkseinterrupt-valid_to.
                  lst_edidd-segnam = lc_e1edp03.
                  lst_edidd-sdata =  lst_e1edp03.
                  APPEND lst_edidd TO int_edidd.
                ENDIF. " IF lst_jkseinterrupt-valid_to IS NOT INITIAL
              ENDIF. " IF sy-subrc = 0
*** Calling the FM to set the value
              CALL FUNCTION 'ZQTC_SET_FLAG'
                EXPORTING
                  im_valid_date = abap_true.


            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF lv_valid_date_flag = abap_false
      ENDIF. " IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edp03

    WHEN 'E1EDK01'. " For Header Status

      lv_vbeln = dxvbak-vbeln.
*** calling FM to get header status

      CALL FUNCTION 'ZQTC_ORD_STATUS'
        EXPORTING
          im_vbeln           = lv_vbeln
        IMPORTING
          ex_itm_status      = li_ord_status
          ex_hdr_status      = li_hdr_status
          ex_itm_vbup_status = li_itm_vbup_status
          ex_hdr_cond        = li_hdr_cond
          ex_itm_cond        = li_itm_cond.


*** Read table to get header status
*** We are using INDEX 1 as this contains only one field i.e. for Header
      READ TABLE li_hdr_status INTO lst_hdr_status INDEX 1.
      IF sy-subrc = 0.
*** Inserting new segment

        MOVE lst_hdr_status TO lst_z1qtc_e1edk01_01.

      ENDIF. " IF sy-subrc = 0

*** BOC for I0348
*** GJAHR field ----->>
*      lst_z1qtc_e1edk01_01-gjahr = dxhvbkd-gjahr.
*** modified logic of YEAR of contract start year
      lv_vbeln2 = dxvbak-vbeln.
*** Calling FM to get contract start date and contract end date For HEADER
      CALL FUNCTION 'ZQTC_ORD_STATUS'
        EXPORTING
          im_vbeln      = lv_vbeln2
        IMPORTING
          ex_itm_status = li_ord_status1.

*** reading internal table to get contract start date and end date
*** BOC BY SAYANDAS on 23-MAY-2018 for INC0196251 in ED1K907438
*      READ TABLE LI_ORD_STATUS1  INTO LST_ORD_STATUS1
*      WITH KEY VPOSN = LC_POSNR.                            "000000
      CLEAR li_ord_status1_tmp[].
      li_ord_status1_tmp = li_ord_status1.

      DELETE li_ord_status1_tmp WHERE vposn = lc_posnr.
**if no line item exit from VEDA table then pick the first line and get the
**contract date. if only one line present in table then read the data with value
** 000000
      IF li_ord_status1_tmp IS NOT INITIAL.
        SORT li_ord_status1_tmp BY vposn.
        READ TABLE li_ord_status1_tmp  INTO lst_ord_status1 INDEX 1.
      ELSE. " ELSE -> IF li_ord_status1_tmp IS NOT INITIAL
        READ TABLE li_ord_status1  INTO lst_ord_status1
        WITH KEY vposn = lc_posnr.                          "000000
      ENDIF. " IF li_ord_status1_tmp IS NOT INITIAL
*** EOC BY SAYANDAS on 23-MAY-2018 for INC0196251 in ED1K907438
      IF sy-subrc = 0.

        lv_vbegdat1 = lst_ord_status1-vbegdat.
*** BOC BY SAYANDAS on 23-MAY-2018 for INC0194991 in ED1K907438
*        WRITE lv_vbegdat1 TO lv_vbegdat2.
*        lv_year = lv_vbegdat2+4(4).
        lv_year = lv_vbegdat1+0(4).
*** EOC BY SAYANDAS on 23-MAY-2018 for INC0194991 in ED1K907438
        WRITE lv_year TO lst_z1qtc_e1edk01_01-gjahr.
      ENDIF. " IF sy-subrc = 0
*** EOC for I0348

*** KONDA field ---->>
      lst_z1qtc_e1edk01_01-konda = dxhvbkd-konda.

*** SUBMI field ----->>
      lst_z1qtc_e1edk01_01-submi = dxvbak-submi.

*     Begin of ADD:ERP-4331/4520:WROY:20-SEP-2017:ED2K908612
***   License Group field ----->>
      lst_z1qtc_e1edk01_01-zzlicgrp = dxvbak-zzlicgrp.
*     End   of ADD:ERP-4331/4520:WROY:20-SEP-2017:ED2K908612

*** BOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
*** VSNMR_V field ----->>
      IF dxvbak-vsnmr_v IS NOT INITIAL."Pass the feild only if its available
        lst_z1qtc_e1edk01_01-vsnmr_v = dxvbak-vsnmr_v.    "Version
      ENDIF.
*** EOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438

*** ZLSCH field ----->>
      lst_z1qtc_e1edk01_01-zlsch = dxhvbkd-zlsch.

*** BOC for I0348
*** ZZFTE and KDGRP field ---->>
      lv_kunnr2 = dxvbak-kunnr.
      lv_vkorg = dxvbak-vkorg.
      lv_vtweg = dxvbak-vtweg.
      lv_spart = dxvbak-spart.

*** select data from KNVV table
      SELECT SINGLE kunnr " Customer Number
                vkorg     " Sales Organization
                vtweg     " Distribution Channel
                spart     " Division
                kdgrp     " Customer group
                zzfte     " Number of FTE’s
        FROM knvv         " Customer Master Sales Data
        INTO lst_knvv
        WHERE kunnr = lv_kunnr2
        AND vkorg = lv_vkorg
        AND vtweg = lv_vtweg
        AND spart = lv_spart.

      IF sy-subrc = 0.
        lst_z1qtc_e1edk01_01-kdgrp = lst_knvv-kdgrp.
        lst_z1qtc_e1edk01_01-zzfte = lst_knvv-zzfte.
      ENDIF. " IF sy-subrc = 0
*** EOC for I0348

      CLEAR lst_edidd.
*---Begin of change VDPATABALLA 02/12/2019  INC0228968 / PRB0043442
      lst_edidd-hlevel = lc_h02."'02'.
*---End of change VDPATABALLA 02/12/2019  INC0228968 / PRB0043442
      lst_edidd-segnam = lc_z1qtc_e1edk01_01.
      lst_edidd-sdata =  lst_z1qtc_e1edk01_01.
      APPEND lst_edidd TO int_edidd.

    WHEN 'E1EDP19'. " For Material

*** Change for BISMT BY SAYANDAS
*** Fetching Material Number
      lst_e1edp19 = lst_edidd-sdata.

      IF lst_e1edp19-qualf = lc_qualf2. "002

        lv_matnr = lst_e1edp19-idtnr.
*       Begin of ADD:ERP-XXXX:WROY:01-JUNE-2017:ED2K906054
*       Convert Material Number from Internal to External Format
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = lv_matnr      "Internal Format
          IMPORTING
            output = lv_matnr_ext. "External Format

*       Modifying IDOC Data table
        lst_e1edp19-idtnr = lv_matnr_ext.
        lst_edidd-sdata   = lst_e1edp19.
        MODIFY int_edidd FROM lst_edidd INDEX lv_line TRANSPORTING sdata.

        LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_e1edp01>)
             WHERE segnam EQ 'E1EDP01'.
        ENDLOOP. " LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_e1edp01>)
        IF sy-subrc EQ 0.
          lst_e1edp01         = <lst_e1edp01>-sdata.
          lst_e1edp01-matnr   = lv_matnr.
          <lst_e1edp01>-sdata = lst_e1edp01.
        ENDIF. " IF sy-subrc EQ 0
*       End   of ADD:ERP-XXXX:WROY:01-JUNE-2017:ED2K906054

      ENDIF. " IF lst_e1edp19-qualf = lc_qualf2

      CLEAR lst_e1edp19.
*** Change for BISMT BY SAYANDAS

      lv_line1 = lv_line - 1. "In order to get previous INDEX we substract 1
      READ TABLE int_edidd INTO lst_edidd1 INDEX lv_line1.
*** Checking if previous segment is E1EDP19 or not
      IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edp19.
        li_vbpa[] = dxvbpa[].
        DELETE li_vbpa WHERE parvw NE lc_za.
        IF li_vbpa IS NOT INITIAL.
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = dxvbap-posnr.
          IF sy-subrc NE 0.
            READ TABLE li_vbpa INTO lst_vbpa WITH  KEY posnr = lc_posnr.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            CALL FUNCTION 'VIEW_VBADR'
              EXPORTING
                input   = lst_vbpa
              IMPORTING
                adresse = lst_vbadr
              EXCEPTIONS
                error   = 1
                OTHERS  = 2.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_vbadr TO lst_e1edpa1.
*- convert postal code ------------------------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstlz lst_e1edpa1-pstlz.
*- convert postal code Post office box --------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstl2 lst_e1edpa1-pstl2.
              WRITE lst_vbadr-spras TO lst_e1edpa1-spras_iso.
*- country in ISO-Code ------------------------------------------------*
              IF NOT lst_vbpa-land1 IS INITIAL.
                CALL FUNCTION 'SAP_TO_ISO_COUNTRY_CODE'
                  EXPORTING
                    sap_code    = lst_vbpa-land1
                  IMPORTING
                    iso_code    = lv_iso_country_code
                  EXCEPTIONS
                    not_found   = 1
                    no_iso_code = 2.

                IF sy-subrc EQ 0.
                  lst_e1edpa1-land1 = lv_iso_country_code.
                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF NOT lst_vbpa-land1 IS INITIAL
                lst_e1edpa1-land1 = ' '. "Ensure that values from
              ENDIF. " IF NOT lst_vbpa-land1 IS INITIAL
              lst_e1edpa1-parvw = lst_vbpa-parvw.
              lst_e1edpa1-partn = lst_vbpa-kunnr.
            ENDIF. " IF sy-subrc EQ 0

            CLEAR lst_edidd.
            lst_edidd-segnam = lc_e1edpa1.
            lst_edidd-sdata =  lst_e1edpa1.
            INSERT lst_edidd INTO int_edidd INDEX lv_line.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF li_vbpa IS NOT INITIAL
*       Adding Line Item Level Sales Rep details
        li_vbpa[] = dxvbpa[].
        DELETE li_vbpa WHERE parvw NE lc_ve.
        IF li_vbpa IS NOT INITIAL.
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = dxvbap-posnr.
          IF sy-subrc NE 0.
            READ TABLE li_vbpa INTO lst_vbpa WITH  KEY posnr = lc_posnr.
          ENDIF. " IF sy-subrc NE 0
*         Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*         Fix to check if E1EDPA1 Segment for "Sales Rep"(VE) Partner Function already exists
          IF sy-subrc EQ 0.
            CLEAR: lv_e1edpa1_flg,
                   lv_index_tmp.
            LOOP AT int_edidd INTO lst_edidd3 WHERE segnam = 'E1EDP01'.
              lv_index_tmp = sy-tabix.
            ENDLOOP.
            IF sy-subrc = 0.
              LOOP AT int_edidd INTO lst_edidd3 FROM lv_index_tmp WHERE segnam = 'E1EDPA1'.
                lst_e1edpa1_tmp = lst_edidd3-sdata.
                IF lst_e1edpa1_tmp-parvw = lc_ve.
                  lv_e1edpa1_flg = abap_true.
                  EXIT.
                ENDIF. " IF lst_e1edpa1_tmp-parvw = lc_ve.
              ENDLOOP.
              "E1EDPA1 Segment for "Sales Rep" Partner Function - already Exists
              IF lv_e1edpa1_flg EQ abap_true.
                sy-subrc = 4.
              ELSE.
                sy-subrc = 0.
              ENDIF. " IF lv_e1edpa1_flg EQ abap_true.
            ENDIF. " IF sy-subrc = 0.
          ENDIF.  "IF sy-subrc EQ 0.
*         End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
          IF sy-subrc EQ 0.
            CALL FUNCTION 'VIEW_VBADR'
              EXPORTING
                input   = lst_vbpa
              IMPORTING
                adresse = lst_vbadr
              EXCEPTIONS
                error   = 1
                OTHERS  = 2.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_vbadr TO lst_e1edpa1.
*- convert postal code ------------------------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstlz lst_e1edpa1-pstlz.
*- convert postal code Post office box --------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstl2 lst_e1edpa1-pstl2.
              WRITE lst_vbadr-spras TO lst_e1edpa1-spras_iso.
*- country in ISO-Code ------------------------------------------------*
              IF NOT lst_vbpa-land1 IS INITIAL.
                CALL FUNCTION 'SAP_TO_ISO_COUNTRY_CODE'
                  EXPORTING
                    sap_code    = lst_vbpa-land1
                  IMPORTING
                    iso_code    = lv_iso_country_code
                  EXCEPTIONS
                    not_found   = 1
                    no_iso_code = 2.

                IF sy-subrc EQ 0.
                  lst_e1edpa1-land1 = lv_iso_country_code.
                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF NOT lst_vbpa-land1 IS INITIAL
                lst_e1edpa1-land1 = ' '. "Ensure that values from
              ENDIF. " IF NOT lst_vbpa-land1 IS INITIAL
              lst_e1edpa1-parvw = lst_vbpa-parvw.
              lst_e1edpa1-partn = lst_vbpa-pernr.
            ENDIF. " IF sy-subrc EQ 0

            CLEAR lst_edidd.
            lst_edidd-segnam = lc_e1edpa1.
            lst_edidd-sdata =  lst_e1edpa1.
            INSERT lst_edidd INTO int_edidd INDEX lv_line.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF li_vbpa IS NOT INITIAL

*       Adding Line Item Level Sales Rep2 details
        li_vbpa[] = dxvbpa[].
        DELETE li_vbpa WHERE parvw NE lc_ze.
        IF li_vbpa IS NOT INITIAL.
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = dxvbap-posnr.
          IF sy-subrc NE 0.
            READ TABLE li_vbpa INTO lst_vbpa WITH  KEY posnr = lc_posnr.
          ENDIF. " IF sy-subrc NE 0
*         Begin of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
*         Fix to check if E1EDPA1 Segment for "Sales Rep 2"(ZE) Partner Function already exists
          IF sy-subrc EQ 0.
            CLEAR: lv_e1edpa1_flg,
                   lv_index_tmp.
            LOOP AT int_edidd INTO lst_edidd3 WHERE segnam = 'E1EDP01'.
              lv_index_tmp = sy-tabix.
            ENDLOOP.
            IF sy-subrc = 0.
              LOOP AT int_edidd INTO lst_edidd3 FROM lv_index_tmp WHERE segnam = 'E1EDPA1'.
                lst_e1edpa1_tmp = lst_edidd3-sdata.
                IF lst_e1edpa1_tmp-parvw = lc_ze.
                  lv_e1edpa1_flg = abap_true.
                  EXIT.
                ENDIF. " IF lst_e1edpa1_tmp-parvw = lc_ze.
              ENDLOOP.
              "E1EDPA1 Segment for "Sales Rep" Partner Function - already Exists
              IF lv_e1edpa1_flg EQ abap_true.
                sy-subrc = 4.
              ELSE.
                sy-subrc = 0.
              ENDIF. " IF lv_e1edpa1_flg EQ abap_true.
            ENDIF. " IF sy-subrc = 0.
          ENDIF.  "IF sy-subrc EQ 0.
*         End of Change:INC0269304/PRB0045318:NPALLA:03-Feb-2020:ED1K911590
          IF sy-subrc EQ 0.
            CALL FUNCTION 'VIEW_VBADR'
              EXPORTING
                input   = lst_vbpa
              IMPORTING
                adresse = lst_vbadr
              EXCEPTIONS
                error   = 1
                OTHERS  = 2.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_vbadr TO lst_e1edpa1.
*- convert postal code ------------------------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstlz lst_e1edpa1-pstlz.
*- convert postal code Post office box --------------------------------*
              PERFORM convert_postal_code IN PROGRAM saplvedc IF FOUND
                USING lst_vbadr-pstl2 lst_e1edpa1-pstl2.
              WRITE lst_vbadr-spras TO lst_e1edpa1-spras_iso.
*- country in ISO-Code ------------------------------------------------*
              IF NOT lst_vbpa-land1 IS INITIAL.
                CALL FUNCTION 'SAP_TO_ISO_COUNTRY_CODE'
                  EXPORTING
                    sap_code    = lst_vbpa-land1
                  IMPORTING
                    iso_code    = lv_iso_country_code
                  EXCEPTIONS
                    not_found   = 1
                    no_iso_code = 2.

                IF sy-subrc EQ 0.
                  lst_e1edpa1-land1 = lv_iso_country_code.
                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF NOT lst_vbpa-land1 IS INITIAL
                lst_e1edpa1-land1 = ' '. "Ensure that values from
              ENDIF. " IF NOT lst_vbpa-land1 IS INITIAL
              lst_e1edpa1-parvw = lst_vbpa-parvw.
              lst_e1edpa1-partn = lst_vbpa-pernr.
            ENDIF. " IF sy-subrc EQ 0

            CLEAR lst_edidd.
            lst_edidd-segnam = lc_e1edpa1.
            lst_edidd-sdata =  lst_e1edpa1.
            INSERT lst_edidd INTO int_edidd INDEX lv_line.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF li_vbpa IS NOT INITIAL
      ENDIF. " IF sy-subrc = 0 AND lst_edidd1-segnam NE lc_e1edp19

** Change for BISMT BY SAYANDAS
*** Fetching Material Number
      SELECT SINGLE bismt " Old material number
        FROM mara         " General Material Data
        INTO @DATA(lv_bismt)
       WHERE matnr EQ @lv_matnr.
      IF sy-subrc EQ 0.
        IF lv_bismt IS INITIAL.
          lv_bismt = lv_matnr.
        ENDIF. " IF lv_bismt IS INITIAL

        lst_e1edp19-qualf = 'OMN'.
        lst_e1edp19-idtnr = lv_bismt.

        CLEAR lst_edidd.
        lst_edidd-segnam = lc_e1edp19. " Adding new segment
        lst_edidd-sdata =  lst_e1edp19.
        APPEND lst_edidd TO int_edidd.
        CLEAR: lst_e1edp19.
      ENDIF. " IF sy-subrc EQ 0
** Change for BISMT BY SAYANDAS

*** Select Data from JPTIDCDASSIGN
      SELECT idcodetype,
             identcode     " Identification Code
        FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
       UP TO 2 ROWS
        INTO TABLE @DATA(li_jptidcdassign)
        WHERE matnr = @lv_matnr.
*** loop is used to insert all Type of Identification Code
      LOOP AT li_jptidcdassign INTO lst_jptidcdassign.

        lst_e1edp19-qualf = lst_jptidcdassign-idcodetype.
        lst_e1edp19-idtnr = lst_jptidcdassign-identcode.

        CLEAR lst_edidd.
        lst_edidd-segnam = lc_e1edp19. " Adding new segment
        lst_edidd-sdata =  lst_e1edp19.
        APPEND lst_edidd TO int_edidd.
        CLEAR lst_jptidcdassign.
      ENDLOOP. " LOOP AT li_jptidcdassign INTO lst_jptidcdassign


    WHEN 'E1EDP01'. " For Item general Data (ZMENG, Status)
      lst_e1edp01 = lst_edidd-sdata.
*** DXVBAP is a table but it contains corresponding item value in it's header
*** in standard, so we have used dxvbap
      lv_vbeln1 = dxvbap-vbeln.
      lv_posnr1 = dxvbap-posnr.
      lv_auart = dxvbak-auart.
*** Inserting Target Quantity field
      IF dxvbap-zmeng IS NOT INITIAL.
        lst_e1edp01-menge = dxvbap-zmeng.
      ELSE. " ELSE -> IF dxvbap-zmeng IS NOT INITIAL
        lst_e1edp01-menge = dxvbap-kwmeng.
      ENDIF. " IF dxvbap-zmeng IS NOT INITIAL
      CONDENSE lst_e1edp01-menge.

* Logic for AUART = ZGRC
      IF lv_auart = lc_zgrc.
        lst_e1edp01-action = lc_ac1.
      ENDIF. " IF lv_auart = lc_zgrc
* Logic for Cancellation
* Begin of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
* To get ZCACONSTANT entries for the I0229 Wricefs.
      CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
        EXPORTING
          im_devid         = lc_devid_i0229
        IMPORTING
          ex_t_zcacons_ent = li_zcaconst_ent.

      LOOP AT li_zcaconst_ent INTO lst_zcaconst_ent
                                    WHERE param1 = lc_canc_proc.
        APPEND INITIAL LINE TO lr_canc_proc_zca ASSIGNING FIELD-SYMBOL(<fst_canc_proc_zca>).
        <fst_canc_proc_zca>-sign   = lst_zcaconst_ent-sign.
        <fst_canc_proc_zca>-option = lst_zcaconst_ent-opti.
        <fst_canc_proc_zca>-low    = lst_zcaconst_ent-low.
        <fst_canc_proc_zca>-high   = lst_zcaconst_ent-high.
* BOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
        IF lst_zcaconst_ent-param1 = lc_canc_proc AND lst_zcaconst_ent-param2 = lc_ac3.
          APPEND INITIAL LINE TO lr_cancellation_proc ASSIGNING FIELD-SYMBOL(<lfs_cancellation_proc>).
          <lfs_cancellation_proc>-sign   = lst_zcaconst_ent-sign.
          <lfs_cancellation_proc>-option = lst_zcaconst_ent-opti.
          <lfs_cancellation_proc>-low    = lst_zcaconst_ent-low.
          <lfs_cancellation_proc>-high   = lst_zcaconst_ent-high.
        ENDIF.
* EOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
      ENDLOOP. " LOOP AT li_zcaconst_ent INTO lst_zcaconst_ent
*  End of Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
* BOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
      LOOP AT li_zcaconst_ent INTO lst_zcaconst_ent.
        IF lst_zcaconst_ent-param1 = lc_kschl.
          APPEND INITIAL LINE TO lr_kschl[] ASSIGNING FIELD-SYMBOL(<lfs_kschl_01>).
          <lfs_kschl_01>-sign = lst_zcaconst_ent-sign.
          <lfs_kschl_01>-option = lst_zcaconst_ent-opti.
          <lfs_kschl_01>-low =  lst_zcaconst_ent-low.
          <lfs_kschl_01>-high = lst_zcaconst_ent-high.
        ENDIF.
      ENDLOOP. " LOOP AT li_zcaconst_ent INTO lst_zcaconst_ent
* EOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
***** select data from VEDA
      SELECT  SINGLE vbeln   " Sales Document
                     vposn   " Sales Document Item
                     vkuesch " Assignment cancellation procedure/cancellation rule
                     vkuegru " Reason for Cancellation of Contract
                     vbedkue " Date of cancellation document from contract partner
        FROM veda            " Contract Data
        INTO lst_veda
        WHERE vbeln = lv_vbeln1
        AND vposn = lv_posnr1.
      IF sy-subrc = 0.
* BOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
       IF dobject-kschl NOT IN lr_kschl[]. "Execute only for Output Type is NOT ZOA2 (Retain Action Code for ZOA2)
* EOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
* Begin of Change by PBANDLAPAL on 27-Jul-2017 for ERP-3630
*        IF lst_veda-vkuesch = lc_z001.
        IF lst_veda-vkuesch IN lr_canc_proc_zca.
* End of Change by PBANDLAPAL on 27-Jul-2017 for ERP-3630
          lst_e1edp01-action = lc_ac2.
* BOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
        ELSEIF lst_veda-vkuesch IN lr_cancellation_proc.
          lst_e1edp01-action = lc_ac3.
* EOC by Lahiru on 01/14/2021 for OTCM-28269 with ED2K921221*
        ENDIF. " IF lst_veda-vkuesch IN lr_canc_proc_zca
* BOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
       ENDIF. "IF dobject-kschl NOT IN lr_kschl[]. "Execute only for Output Type is NOT ZOA2
* EOC by NPALLA on 03/18/2022 for OTCM-40685 with ED2K926163*
      ENDIF. " IF sy-subrc = 0

      lst_edidd-sdata =  lst_e1edp01.
      MODIFY int_edidd FROM lst_edidd INDEX lv_line TRANSPORTING sdata.
      CLEAR lst_e1edp01.

      lv_vbeln = dxvbak-vbeln.
*** Calling the FM to get Status field


      CALL FUNCTION 'ZQTC_ORD_STATUS'
        EXPORTING
          im_vbeln           = lv_vbeln
        IMPORTING
          ex_itm_status      = li_ord_status
          ex_hdr_status      = li_hdr_status
          ex_itm_vbup_status = li_itm_vbup_status
          ex_rej_status      = li_rej_status
          ex_hdr_cond        = li_hdr_cond
          ex_itm_cond        = li_itm_cond.



      lst_e1edp01 = lst_edidd-sdata.

**** For Item Status and ihrez_e ------------>>
      SORT li_itm_vbup_status BY vposn.
      READ TABLE li_itm_vbup_status INTO lst_itm_vbup_status
      WITH KEY vposn = lst_e1edp01-posex BINARY SEARCH.
      IF sy-subrc = 0.
**** Inserting Status field in new segment

        MOVE lst_itm_vbup_status TO lst_z1qtc_e1edp01_01.

      ENDIF. " IF sy-subrc = 0



******* For KONDA field ----------->>
      IF dxvbkd-konda IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-konda = dxvbkd-konda.
      ELSEIF dxhvbkd-konda IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-konda = dxhvbkd-konda.
      ENDIF. " IF dxvbkd-konda IS NOT INITIAL
********** For ZZACCESS_MECH and ZZSUBTYP field --------->>
      IF dxvbap-zzaccess_mech IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzaccess_mech = dxvbap-zzaccess_mech.
      ENDIF. " IF dxvbap-zzaccess_mech IS NOT INITIAL
      IF dxvbap-zzsubtyp IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzsubtyp = dxvbap-zzsubtyp.
      ENDIF. " IF dxvbap-zzsubtyp IS NOT INITIAL

*********** For ZZSOCIETY_ACRNYM field ---------->>
      li_vbpa[] = dxvbpa[].
      DELETE li_vbpa WHERE parvw NE lc_za.
      IF li_vbpa IS NOT INITIAL.

        READ TABLE li_vbpa INTO lst_vbpa WITH KEY posnr = dxvbap-posnr.
        IF sy-subrc EQ 0.
          lv_kunnr = lst_vbpa-kunnr.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE li_vbpa INTO lst_vbpa WITH  KEY posnr = lc_posnr.
          IF sy-subrc EQ 0.
            lv_kunnr = lst_vbpa-kunnr.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0

*** Select value from ZQTC_JGC_SOCIETY Table
        SELECT society          " Business Partner 2 or Society number
               society_acrnym   " Society Acronym
          FROM zqtc_jgc_society " I0222: Journal Group Code to Society Mapping
          INTO TABLE li_zqtc_jgc_society
          WHERE society = lv_kunnr.
        IF sy-subrc = 0.
          READ TABLE li_zqtc_jgc_society INTO lst_zqtc_jgc_society INDEX 1.
          IF sy-subrc = 0.
            lv_acronym = lst_zqtc_jgc_society-society_acrnym.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF li_vbpa IS NOT INITIAL
      IF lv_acronym IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-acrnym = lv_acronym.
      ENDIF. " IF lv_acronym IS NOT INITIAL

********* Fetch Data for BEZEI field ------------>>
*** DXVBAP is a table but it contains corresponding item value in it's header
*** in standard, so we have used dxvbap
      SORT  li_rej_status BY abgru.
      READ TABLE li_rej_status INTO lst_rej_status
      WITH KEY abgru = dxvbap-abgru BINARY SEARCH.
      IF sy-subrc = 0.

        lst_z1qtc_e1edp01_01-bezei = lst_rej_status-bezei.

      ENDIF. " IF sy-subrc = 0

********** BEZEI field and VBEDKUE field ------->>
***** select data from VEDA
      SELECT  SINGLE vbeln   " Sales Document
                     vposn   " Sales Document Item
                     vkuesch " Assignment cancellation procedure/cancellation rule
                     vkuegru " Reason for Cancellation of Contract
                     vbedkue " Date of cancellation document from contract partner
*** BOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
                     vabndat " Agreement acceptance date
*** EOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
        FROM veda            " Contract Data
        INTO lst_veda
        WHERE vbeln = dxvbap-vbeln
        AND vposn = dxvbap-posnr.

      IF sy-subrc = 0 . "AND lst_veda-vkuegru IS NOT INITIAL.
*** BOC for I0348
        IF lst_veda-vbedkue IS NOT INITIAL.
          lst_z1qtc_e1edp01_01-vbedkue = lst_veda-vbedkue.
        ENDIF. " IF lst_veda-vbedkue IS NOT INITIAL
*** EOC for I0348
*** BOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
        IF lst_veda-vabndat IS NOT INITIAL.   " Acceptance date
          lst_z1qtc_e1edp01_01-vabndat = lst_veda-vabndat.
        ENDIF.
*** EOC BY NPALLA on 19-Oct-2018 for CR_7722 in ED1K907438
        IF lst_veda-vkuegru IS NOT INITIAL.
*** BOC for I0348
          lst_z1qtc_e1edp01_01-vkuegru = lst_veda-vkuegru.
*** EOC for I0348

**** Select Data from TVKGT
          SELECT SINGLE spras  " Language Key
                        kuegru " Reason for Cancellation of Contract
                        bezei  " Description
            FROM tvkgt         " Sales Documents: Reasons for Cancellation: Texts
            INTO lst_tvkgt
            WHERE spras = sy-langu
            AND kuegru = lst_veda-vkuegru.
          IF sy-subrc = 0 AND lst_tvkgt-bezei IS NOT INITIAL.
*          lst_z1qtc_e1edp01_01-vkuegru = lst_veda-vkuegru.
            lst_z1qtc_e1edp01_01-vkuegru_text = lst_tvkgt-bezei.
          ENDIF. " IF sy-subrc = 0 AND lst_tvkgt-bezei IS NOT INITIAL
        ENDIF. " IF lst_veda-vkuegru IS NOT INITIAL
      ENDIF. " IF sy-subrc = 0

*** BOC for I0348
***** ISMCOPYNR field
*** Select data from JKSESCHED table
      SELECT COUNT(*)
        FROM jksesched " IS-M: Media Schedule Lines
        INTO lv_count
        WHERE vbeln = dxvbap-vbeln
        AND posnr = dxvbap-posnr.
      IF sy-subrc = 0.
        WRITE lv_count TO lst_z1qtc_e1edp01_01-ismcopynr.
        CONDENSE lst_z1qtc_e1edp01_01-ismcopynr.
      ENDIF. " IF sy-subrc = 0

****** ISMMEDITYPE, ISMPUBLTYPE , ISMCONNTYPE field
      SELECT SINGLE matnr        " Material Number
                    ismpubltype  " Publication Type
                    ismmediatype " Media Type
                    ismconttype  " Content Category
       FROM mara                 " General Material Data
       INTO lst_mara
       WHERE matnr = dxvbap-matnr.
      IF sy-subrc = 0.
        IF lst_mara-ismpubltype IS NOT INITIAL.
          lst_z1qtc_e1edp01_01-ismpubltype = lst_mara-ismpubltype.
        ENDIF. " IF lst_mara-ismpubltype IS NOT INITIAL
        IF lst_mara-ismmediatype IS NOT INITIAL.
          lst_z1qtc_e1edp01_01-ismmediatype = lst_mara-ismmediatype.
        ENDIF. " IF lst_mara-ismmediatype IS NOT INITIAL
        IF lst_mara-ismconttype IS NOT INITIAL.
          lst_z1qtc_e1edp01_01-ismconttype = lst_mara-ismconttype.
        ENDIF. " IF lst_mara-ismconttype IS NOT INITIAL
      ENDIF. " IF sy-subrc = 0

*** UEPOSMATNR field
      lv_uepos = dxvbap-uepos.
      READ TABLE dxvbap INTO lst_vbap WITH KEY posnr = lv_uepos.
      IF sy-subrc = 0.
        lst_z1qtc_e1edp01_01-ueposmatnr = lst_vbap-matnr.
      ENDIF. " IF sy-subrc = 0
*** EOC for I0348
*** BOC for I0350
*** KZWI1 field
      IF dxvbap-kzwi1 IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-kzwi1 = dxvbap-kzwi1.
      ENDIF. " IF dxvbap-kzwi1 IS NOT INITIAL

*** KZWI5 field
      IF dxvbap-kzwi5 IS NOT INITIAL.
        IF dxvbap-kzwi5 GE 0.
          DATA(lv_kzwi5) = dxvbap-kzwi5.
        ELSE. " ELSE -> IF dxvbap-kzwi5 GE 0
          lv_kzwi5 = dxvbap-kzwi5 * -1.
        ENDIF. " IF dxvbap-kzwi5 GE 0

        lst_z1qtc_e1edp01_01-kzwi5 = lv_kzwi5.
      ENDIF. " IF dxvbap-kzwi5 IS NOT INITIAL
*** EOC for I0350
*******<<------------------

***** Content start date and content end date
      IF dxvbap-zzconstart IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzcontent_start_d = dxvbap-zzconstart.
      ENDIF. " IF dxvbap-zzconstart IS NOT INITIAL
      IF dxvbap-zzconend IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzcontent_end_d = dxvbap-zzconend.
      ENDIF. " IF dxvbap-zzconend IS NOT INITIAL

***** License start date and license end date
      IF dxvbap-zzlicstart IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzlicense_start_d = dxvbap-zzlicstart.
      ENDIF. " IF dxvbap-zzlicstart IS NOT INITIAL
      IF dxvbap-zzlicend IS NOT INITIAL.
        lst_z1qtc_e1edp01_01-zzlicense_end_d = dxvbap-zzlicend.
      ENDIF. " IF dxvbap-zzlicend IS NOT INITIAL

      CLEAR lst_edidd.
*---Begin of Change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
      lst_edidd-hlevel = lc_h03." '03'.
*---End of Change VDPATABALL 02/12/2019  INC0228968 / PRB0043442
      lst_edidd-segnam = lc_z1qtc_e1edp01_01. " Adding new segment
      lst_edidd-sdata =  lst_z1qtc_e1edp01_01.
      APPEND lst_edidd TO int_edidd.
****<<----------------

*     Begin of ADD:ERP-6071:WROY:22-Jan-2018:ED2K910398
      CALL FUNCTION 'ZQTC_SET_FLAG'
        EXPORTING
          im_valid_date = abap_false.
*     End   of ADD:ERP-6071:WROY:22-Jan-2018:ED2K910398

  ENDCASE.
ENDIF. " IF sy-subrc = 0
