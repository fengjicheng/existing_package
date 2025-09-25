*&---------------------------------------------------------------------*
*&  Include  ZQTCN_WOA_INSUB_ORD_BDC_I0378
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WOA_INSUB_ORD_BDC_I0378 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for BDC Mapping for
*                      Wiley OO/OA Relorder Interface
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 25-DEC-2019
* OBJECT ID: I0378 (ERPM-197)
* TRANSPORT NUMBER(S): ED2K917150
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *

*** Local Types
TYPES: BEGIN OF lty_item_i0378,
         item      TYPE char5,      " Item position
         posex     TYPE posnr_va,   " Item Number
         licsdate  TYPE char10,     " License Start Date Override
         licedate  TYPE char10,     " License End Date Override
         accepdate TYPE char10,     " Acceptance date
         artno     TYPE zartno,     " Article Number
         subtype   TYPE zsubtyp,    " Subscription Type
         coveryr   TYPE zzcovryr,   " Cover Year
         ihrez     TYPE ihrez,      " Your reference (Sold-to party)
         ihrez_e   TYPE ihrez_e,    " Your reference (Ship-to party)
       END OF lty_item_i0378,
       ltt_item_i0378 TYPE STANDARD TABLE OF lty_item_i0378 INITIAL SIZE 0.

* Type declaration of VBAK
TYPES: BEGIN OF lty_xvbak2_i0378.
         INCLUDE STRUCTURE vbak.       " Sales Document: Header Data
         TYPES:  bstkd     TYPE bstkd, " Customer purchase order number
         kursk     TYPE kursk,         " Exchange Rate for Price Determination
         zterm     TYPE dzterm,        " Terms of Payment Key
         incov     TYPE incov,         " Incoterms Version
         inco1     TYPE inco1,         " Incoterms (Part 1)
         inco2     TYPE inco2,         " Incoterms (Part 2)
         inco2_l   TYPE inco2_l,       " Incoterms Location 1
         inco3_l   TYPE inco3_l,       " Incoterms Location 2
         prsdt     TYPE prsdt,         " Date for pricing and exchange rate
         angbt     TYPE vbeln_va,      " Sales Document
         contk     TYPE vbeln_va,      " Sales Document
         kzazu     TYPE kzazu_d,       " Order Combination Indicator
         fkdat     TYPE fkdat,         " Billing date for billing index and printout
         fbuda     TYPE fbuda,         " Date on which services rendered
         empst     TYPE empst,         " Receiving point
         valdt     TYPE valdt,         " Fixed value date
         kdkg1     TYPE kdkg1,         " Customer condition group 1
         kdkg2     TYPE kdkg2,         " Customer condition group 2
         kdkg3     TYPE kdkg3,         " Customer condition group 3
         kdkg4     TYPE kdkg4,         " Customer condition group 4
         kdkg5     TYPE kdkg5,         " Customer condition group 5
         delco     TYPE delco,         " Agreed delivery time
         abtnr     TYPE abtnr,         " Department number
         dwerk     TYPE dwerk_ext,     " Delivering Plant (Own or External)
         angbt_ref TYPE bstkd,         " Customer purchase order number
         contk_ref TYPE bstkd,         " Customer purchase order number
         currdec   TYPE currdec,       " Number of decimal places
         bstkd_e   TYPE bstkd_e,       " Ship-to Party's Purchase Order Number
         bstdk_e   TYPE bstdk_e.       " Ship-to party's PO date
TYPES: END OF lty_xvbak2_i0378.

*** Statics
STATICS:
  li_item_i0378      TYPE ltt_item_i0378,                     " Itab: Items
  lv_ihrez_we_i0378  TYPE ihrez_e,                            " Your reference (Header Lvl: Ship-to party)
  lv_idoc_num        TYPE edi_docnum,                         " Idoc Number
  lv_addr_ident      TYPE char5,                              " Addr Fields Identifier
  li_constants_i0378 TYPE zcat_constants,                     " Itab: Constant entries
  lv_data_populate   TYPE abap_bool VALUE abap_true.          " Flag

*** Local Data Declaration
DATA: lst_item_i0378          TYPE lty_item_i0378,            " Structure: Item data
      lst_bdcdata_i0378       TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc_i0378          TYPE edidd,                     " Data record (IDoc)
      lst_z1qtc_e1edp01_i0378 TYPE z1qtc_e1edp01_01,          " Segment: z1qtc_e1edp01_01
      lst_e1edka1_i0378       TYPE e1edka1,                   " Segment: E1EDKA1-Document Header Partner Information
      lst_e1edk02_i0378       TYPE e1edk02,                   " IDoc: Document header reference data
      lv_licsdate             TYPE char10,                    " License start date
      lv_licedate             TYPE char10,                    " License end date
      lv_accepdate            TYPE char10,                    " Acceptance date
      lv_vbeln_i0378          TYPE vbeln_va,                  " Sales Document
*      lv_pos_i0378            TYPE char3,                     " Pos of type CHAR3
      lv_item_num             TYPE i,                         " Item number
*      lv_item_i0378           TYPE posnr_va,                  " Val of type CHAR6
      lv_selkz_i0378          TYPE char25,                    " Selkz of type CHAR19
      li_bdcdata_i0378        TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      li_bdcdata_fcode        TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_xvbak_i0378         TYPE lty_xvbak2_i0378,          " VBAK Structure
      lv_tabix_i0378          TYPE sytabix,                   " Row Index of Internal Tables
      lv_line_i0378           TYPE sytabix.                   " Row Index of Internal Tables

*** Local Constant Declaration
CONSTANTS:
  lc_we_i0378               TYPE char2       VALUE 'WE',               " Partner Function: WE
  lc_e1edka1_i0378          TYPE char7       VALUE 'E1EDKA1',          " Segment: E1EDKA1
  lc_e1edk02_i0378          TYPE edilsegtyp  VALUE 'E1EDK02',          " Segment type: E1EDK02
  lc_e1edp01_i0378          TYPE edilsegtyp  VALUE 'E1EDP01',          " Segment type: E1EDP01
  lc_z1qtc_e1edp01_01_i0378 TYPE char16      VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_8 of type CHAR16
  lc_qualf_043_i0378        TYPE edi_qualfr  VALUE '043',              " Qualifier: Reference Doc no
  lc_addr_char_p1           TYPE rvari_vnam  VALUE 'ADDR_CHAR',        " Param1: Address Identifier
  lc_devid_i0378            TYPE zdevid      VALUE 'I0378'.            " Development Id

*************************************************************************************

* Fetch Document Type from Constant entries
IF li_constants_i0378[] IS INITIAL.
  SELECT devid                               " Development ID
         param1                              " ABAP: Name of Variant Variable
         param2                              " ABAP: Name of Variant Variable
         srno                                " ABAP: Current selection number
         sign                                " ABAP: I/E (include/exclude values)
         opti                                " ABAP: Selection option (EQ/BT/CP/...)
         low                                 " Lower Value of Selection Condition
         high                                " Upper Value of Selection Condition
         FROM zcaconstant                    " Wiley Application Constant Table
         INTO TABLE li_constants_i0378
         WHERE devid = lc_devid_i0378 AND
               activate = abap_true.         " Only active records
  IF sy-subrc = 0 AND
     li_constants_i0378[] IS NOT INITIAL.
    LOOP AT li_constants_i0378 ASSIGNING FIELD-SYMBOL(<lst_constant_i0378>).
      CASE <lst_constant_i0378>-param1.
        WHEN lc_addr_char_p1.
          lv_addr_ident = <lst_constant_i0378>-low.

        WHEN OTHERS.
          " Nothing to do

      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc = 0 AND
ENDIF. " IF li_constants_i0378[] IS INITIAL.

" Data population from IDoc
IF lv_idoc_num <> didoc_data-docnum.
  lv_idoc_num = didoc_data-docnum.
  lv_data_populate = abap_true.
ENDIF.

IF lv_data_populate = abap_true.
  lv_data_populate = abap_false.

  LOOP AT didoc_data INTO lst_idoc_i0378.

    CASE lst_idoc_i0378-segnam.

      WHEN lc_e1edk02_i0378.
        " Get the IDoc data into local work area to process further
        lst_e1edk02_i0378 = lst_idoc_i0378-sdata.
        IF lst_e1edk02_i0378-qualf = lc_qualf_043_i0378.
          lv_vbeln_i0378 = lst_e1edk02_i0378-belnr.
        ENDIF.
        CLEAR lst_e1edk02_i0378.

      WHEN lc_e1edka1_i0378.
        lst_e1edka1_i0378 = lst_idoc_i0378-sdata.
        IF lst_e1edka1_i0378-parvw = lc_we_i0378.
          lv_ihrez_we_i0378 = lst_e1edka1_i0378-ihrez.
        ENDIF.
        CLEAR lst_e1edka1_i0378.

      WHEN lc_z1qtc_e1edp01_01_i0378.
        lst_z1qtc_e1edp01_i0378 = lst_idoc_i0378-sdata.

        " Convert License start date to User format
        IF lst_z1qtc_e1edp01_i0378-zzlicense_start_d IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_z1qtc_e1edp01_i0378-zzlicense_start_d
            IMPORTING
              output = lv_licsdate. " lv_licsdate is used for License start date
        ENDIF.

        " Convert License end date to User format
        IF lst_z1qtc_e1edp01_i0378-zzlicense_end_d IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_z1qtc_e1edp01_i0378-zzlicense_end_d
            IMPORTING
              output = lv_licedate. " lv_licedate is used for License end date
        ENDIF.

        " Convert Acceptance date to User format
        IF lst_z1qtc_e1edp01_i0378-vabndat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_z1qtc_e1edp01_i0378-vabndat
            IMPORTING
              output = lv_accepdate. " lv_accepdate is used for Acceptance date
        ELSE.
          lst_z1qtc_e1edp01_i0378-vabndat = sy-datum.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_z1qtc_e1edp01_i0378-vabndat
            IMPORTING
              output = lv_accepdate. " lv_accepdate is used for Acceptance date
        ENDIF.

        READ TABLE didoc_data INTO DATA(lst_idoc_data) WITH KEY segnum = lst_idoc_i0378-psgnum
                                                                segnam = lc_e1edp01_i0378.
        IF sy-subrc = 0.
          lst_item_i0378-posex = lst_idoc_data-sdata+0(6).
          CLEAR lst_idoc_data.
        ENDIF.
        lv_item_num = lv_item_num + 1.
        lst_item_i0378-item = lv_item_num.
        CONDENSE lst_item_i0378-item NO-GAPS.

        lst_item_i0378-licsdate = lv_licsdate.
        lst_item_i0378-licedate = lv_licedate.
        lst_item_i0378-accepdate = lv_accepdate.
        lst_item_i0378-artno = lst_z1qtc_e1edp01_i0378-zzartno.
        lst_item_i0378-subtype = lst_z1qtc_e1edp01_i0378-zzsubtyp.
        lst_item_i0378-coveryr = lst_z1qtc_e1edp01_i0378-zzcovryr.
        lst_item_i0378-ihrez = lst_z1qtc_e1edp01_i0378-ihrez_e.
        lst_item_i0378-ihrez_e = lv_vbeln_i0378.
        APPEND lst_item_i0378 TO li_item_i0378.
        CLEAR: lst_z1qtc_e1edp01_i0378,
               lst_item_i0378,
               lv_licsdate,
               lv_licedate,
               lv_accepdate.

      WHEN OTHERS.
        " Nothing to do

    ENDCASE.

    CLEAR lst_idoc_i0378.
  ENDLOOP. " LOOP AT didoc_data INTO lst_idoc_i0378

  CLEAR: lv_item_num, lv_vbeln_i0378.
ENDIF. " IF lv_data_populate = abap_true.

* Getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line_i0378.

* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO DATA(lst_dxbdcdata) INDEX lv_line_i0378.
IF sy-subrc = 0.

*  IF lst_dxbdcdata-fnam+0(10) = 'VBAP-POSEX'.
*    lv_pos_i0378 = lst_dxbdcdata-fnam+10(3).
*    lv_item_i0378 = lst_dxbdcdata-fval.
*
*    READ TABLE li_item_i0378 INTO lst_item_i0378 WITH KEY posex = lv_item_i0378.
*    IF sy-subrc = 0.

*      CLEAR lst_item_i0378.
*    ENDIF. " IF sy-subrc = 0 of READ TABLE li_item_i0378
*
*  ENDIF. " IF lst_bdcdata9-fnam+0(10) = 'VBAP-POSEX'.

*   Check the FNAM and FVAL value of the Last entry of BDCDATA
*   This is to restrict the execution of the code
  IF lst_dxbdcdata-fnam = 'BDC_OKCODE' AND
     lst_dxbdcdata-fval = 'SICH'.

*** Clearing Ship-to party Address fields which are not filled through IDOC segments
    " Clearing is required as While over-writing ShipTo address in partners screen,
    " original BP address data is not cleared-off properly with new record.
    LOOP AT dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_dxbdcdata>) WHERE fval = lv_addr_ident.

      CLEAR <lfs_dxbdcdata>-fval.

    ENDLOOP.

*** BOC: Header level data update
    " Read Function Code of 'Sales' tab
    READ TABLE dxbdcdata WITH KEY fnam = 'BDC_OKCODE' fval = 'KKAU'
         TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.
      lv_tabix_i0378 = sy-tabix.
      lv_tabix_i0378 = lv_tabix_i0378 + 1.

      LOOP AT dxbdcdata INTO lst_dxbdcdata FROM lv_tabix_i0378.
        IF lst_dxbdcdata-fnam = 'BDC_OKCODE'.
          lv_tabix_i0378 = sy-tabix.
          EXIT.
        ENDIF.
      ENDLOOP.

      " To get the Incoterms
      " Incoterms values has been updated in dxvbak
      " in ZQTCN_WOA_INSUB_ORD_I0378
      lst_xvbak_i0378 = dxvbak.

      " Read Function Code of 'Billing Document' tab
      READ TABLE dxbdcdata WITH KEY fnam = 'BDC_OKCODE' fval = 'KDE3'
           TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        DATA(lv_tabix_kde3) = sy-tabix.
        lv_tabix_kde3 = lv_tabix_kde3 + 2.

        lst_bdcdata_i0378-fnam = 'VBKD-INCO1'.
        lst_bdcdata_i0378-fval = lst_xvbak_i0378-inco1.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_fcode.  " Appending Incoterms (Part 1)
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VBKD-INCO2'.
        lst_bdcdata_i0378-fval = lst_xvbak_i0378-inco2.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_fcode.  " Appending Incoterms (Part 2)
        CLEAR lst_bdcdata_i0378.

        INSERT LINES OF li_bdcdata_fcode INTO dxbdcdata INDEX lv_tabix_kde3.
        CLEAR: li_bdcdata_fcode[], lv_tabix_kde3.
      ELSE.
        lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
        lst_bdcdata_i0378-fval = 'KDE3'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending FCode 'KDE3' to switch to 'Billing Document' tab
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-program = 'SAPMV45A'.
        lst_bdcdata_i0378-dynpro = '4002'.
        lst_bdcdata_i0378-dynbegin = 'X'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Screen data
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
        lst_bdcdata_i0378-fval = 'VBKD-INCO1'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VBKD-INCO1'.
        lst_bdcdata_i0378-fval = lst_xvbak_i0378-inco1.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Incoterms (Part 1)
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
        lst_bdcdata_i0378-fval = 'VBKD-INCO2'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VBKD-INCO2'.
        lst_bdcdata_i0378-fval = lst_xvbak_i0378-inco2.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Incoterms (Part 2)
        CLEAR lst_bdcdata_i0378.
      ENDIF.

      " BDC Mapping for field 'Your Reference' of Ship-to party
      IF lv_ihrez_we_i0378 IS NOT INITIAL.
        " Read Function Code of 'Order Data' tab
        READ TABLE dxbdcdata WITH KEY fnam = 'BDC_OKCODE' fval = 'KBES'
             TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          DATA(lv_tabix_kbes) = sy-tabix.
          lv_tabix_kbes = lv_tabix_kbes + 2.

          lst_bdcdata_i0378-fnam = 'VBKD-IHREZ_E'.
          lst_bdcdata_i0378-fval = lv_ihrez_we_i0378.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_fcode.  " Appending Your reference
          CLEAR lst_bdcdata_i0378.

          INSERT LINES OF li_bdcdata_fcode INTO dxbdcdata INDEX lv_tabix_kbes.
          CLEAR: li_bdcdata_fcode[], lv_tabix_kbes, lv_ihrez_we_i0378.
        ELSE.
          lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
          lst_bdcdata_i0378-fval = 'KBES'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending FCode 'KBES' to switch to 'Order Data' tab
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-program = 'SAPMV45A'.
          lst_bdcdata_i0378-dynpro = '4002'.
          lst_bdcdata_i0378-dynbegin = 'X'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Screen data
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBKD-IHREZ_E'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending cursor position
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBKD-IHREZ_E'.
          lst_bdcdata_i0378-fval = lv_ihrez_we_i0378.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Your reference
          CLEAR: lst_bdcdata_i0378, lv_ihrez_we_i0378.
        ENDIF. " IF sy-subrc = 0. --> READ TABLE dxbdcdata

      ENDIF. " IF lv_ihrez_we_i0378 IS NOT INITIAL.

      IF li_bdcdata_i0378[] IS NOT INITIAL.
        INSERT LINES OF li_bdcdata_i0378 INTO dxbdcdata INDEX lv_tabix_i0378.
        CLEAR: li_bdcdata_i0378[], lst_xvbak_i0378, lv_tabix_i0378.
      ENDIF.

    ENDIF.  " IF sy-subrc EQ. --> READ TABLE dxbdcdata
*** EOC: Header level data update

*** BOC: Item level data update
    " Updating License Start Date, License End Date, Acceptance date, Cover Year,
    " Your Reference for Item data
    LOOP AT li_item_i0378 INTO lst_item_i0378.

      IF sy-tabix = 1.
        lst_bdcdata_i0378-program = 'SAPMV45A'.
        lst_bdcdata_i0378-dynpro = '4001'.
        lst_bdcdata_i0378-dynbegin = 'X'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378. " Appending Screen
        CLEAR lst_bdcdata_i0378.
      ENDIF.

      CONCATENATE 'RV45A-VBAP_SELKZ(' lst_item_i0378-item ')' INTO lv_selkz_i0378.

      lst_bdcdata_i0378-fnam = lv_selkz_i0378.
      lst_bdcdata_i0378-fval = 'X'.
      APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.   " Appending OKCODE
      CLEAR lst_bdcdata_i0378.

      IF ( lst_item_i0378-licsdate IS NOT INITIAL AND lst_item_i0378-licsdate NE space ) OR
         ( lst_item_i0378-licedate IS NOT INITIAL AND lst_item_i0378-licedate NE space ) OR
           lst_item_i0378-artno IS NOT INITIAL OR
           lst_item_i0378-subtype IS NOT INITIAL OR
           lst_item_i0378-coveryr IS NOT INITIAL.

        " Switch to 'Additionla data B' tab at Item level
        lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
        lst_bdcdata_i0378-fval = 'PZKU'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending FCode '=PZKU' to go to 'Additionla data B' tab
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-program = 'SAPMV45A'.
        lst_bdcdata_i0378-dynpro = '4003'.
        lst_bdcdata_i0378-dynbegin = 'X'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.  " Appending Screen data
        CLEAR lst_bdcdata_i0378.

        " BDC Mapping for fields 'License Start Date' & 'License Etart Date'
        IF lst_item_i0378-licsdate IS NOT INITIAL AND
           lst_item_i0378-licsdate NE space.

          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBAP-ZZLICSTART'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBAP-ZZLICSTART'.
          lst_bdcdata_i0378-fval = lst_item_i0378-licsdate.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.       " Appending License start date
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBAP-ZZLICEND'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBAP-ZZLICEND'.
          lst_bdcdata_i0378-fval = lst_item_i0378-licedate.   " Appending License end date
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

        ENDIF. " IF lst_item_i0378-licsdate IS NOT INITIAL AND ...

        " BDC Mapping for field 'Article Number'
        IF lst_item_i0378-artno IS NOT INITIAL.
          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBAP-ZZARTNO'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBAP-ZZARTNO'.
          lst_bdcdata_i0378-fval = lst_item_i0378-artno.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.   " Appending Article Number
          CLEAR lst_bdcdata_i0378.
        ENDIF.

        " BDC Mapping for field 'Subscription Type'
        IF lst_item_i0378-subtype IS NOT INITIAL.
          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBAP-ZZSUBTYP'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBAP-ZZSUBTYP'.
          lst_bdcdata_i0378-fval = lst_item_i0378-subtype.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.   " Appending Subscription Type
          CLEAR lst_bdcdata_i0378.
        ENDIF.

        " BDC Mapping for field 'Cover Year'
        IF lst_item_i0378-coveryr IS NOT INITIAL.
          lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
          lst_bdcdata_i0378-fval = 'VBAP-ZZCOVRYR'.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
          CLEAR lst_bdcdata_i0378.

          lst_bdcdata_i0378-fnam = 'VBAP-ZZCOVRYR'.
          lst_bdcdata_i0378-fval = lst_item_i0378-coveryr.
          APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.   " Appending Cover Year
          CLEAR lst_bdcdata_i0378.
        ENDIF.

      ENDIF. " IF ( lst_item_i0378-licsdate IS NOT INITIAL AND lst_item_i0378-licsdate NE space ) OR

      " BDC Mapping for field 'Your Reference'
      IF lst_item_i0378-ihrez IS NOT INITIAL OR
         lst_item_i0378-ihrez_e IS NOT INITIAL.
        " Switch to 'Order Data' tab at Item level
        lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
        lst_bdcdata_i0378-fval = 'PBES'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending FCode 'PBES' to switch to 'Order Data' tab
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-program = 'SAPMV45A'.
        lst_bdcdata_i0378-dynpro = '4003'.
        lst_bdcdata_i0378-dynbegin = 'X'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending Screen data
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
        lst_bdcdata_i0378-fval = 'VBKD-IHREZ'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VBKD-IHREZ'.
        lst_bdcdata_i0378-fval = lst_item_i0378-ihrez.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending Your Reference (IHREZ) of Sold-to
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
        lst_bdcdata_i0378-fval = 'VBKD-IHREZ_E'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VBKD-IHREZ_E'.
        lst_bdcdata_i0378-fval = lst_item_i0378-ihrez_e.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending Your Reference (IHREZ_E) of Ship-to
        CLEAR lst_bdcdata_i0378.
      ENDIF. " IF lst_item_i0378-ihrez IS NOT INITIAL OR.

      " BDC Mapping for field 'Acceptance date'
      IF lst_item_i0378-accepdate IS NOT INITIAL.
        " Switch to 'Contract data' tab at Item level
        lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
        lst_bdcdata_i0378-fval = 'PVER'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending FCode 'PVER' to switch to 'Contract data' tab
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-program = 'SAPLV45W'.
        lst_bdcdata_i0378-dynpro = '4001'.
        lst_bdcdata_i0378-dynbegin = 'X'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending Screen data
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'BDC_CURSOR'.
        lst_bdcdata_i0378-fval = 'VEDA-VABNDAT'.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
        CLEAR lst_bdcdata_i0378.

        lst_bdcdata_i0378-fnam = 'VEDA-VABNDAT'.
        lst_bdcdata_i0378-fval = lst_item_i0378-accepdate.
        APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.    " Appending 'Acceptance date'
        CLEAR lst_bdcdata_i0378.
      ENDIF. " IF lst_item_i0378-accepdate IS NOT INITIAL.


      lst_bdcdata_i0378-fnam = 'BDC_OKCODE'.
      lst_bdcdata_i0378-fval = '/EBACK'.
      APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
      CLEAR lst_bdcdata_i0378.

      lst_bdcdata_i0378-program = 'SAPMV45A'.
      lst_bdcdata_i0378-dynpro = '4001'.
      lst_bdcdata_i0378-dynbegin = 'X'.
      APPEND lst_bdcdata_i0378 TO li_bdcdata_i0378.
      CLEAR lst_bdcdata_i0378.

      CLEAR lst_item_i0378.
    ENDLOOP.

    IF li_bdcdata_i0378[] IS NOT INITIAL.
      DESCRIBE TABLE dxbdcdata LINES lv_tabix_i0378.
      INSERT LINES OF li_bdcdata_i0378 INTO dxbdcdata INDEX lv_tabix_i0378.
      CLEAR: li_bdcdata_i0378[], li_item_i0378.
    ENDIF.
*** EOC: Item level data update

  ENDIF. " IF lst_bdcdata_i0378-fnam = 'BDC_OKCODE' AND lst_dxbdcdata-fval = 'SICH'.

ENDIF. " IF sy-subrc = 0. --> READ TABLE dxbdcdata
