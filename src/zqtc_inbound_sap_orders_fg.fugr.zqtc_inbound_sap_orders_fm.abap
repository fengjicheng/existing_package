FUNCTION zqtc_inbound_sap_orders_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_EDIDD) TYPE  ZSTQTC_IDOC_ORDERS05
*"     VALUE(IM_EDIDC) TYPE  EDIDC
*"     VALUE(IM_IMMEDIATE) TYPE  FLAG DEFAULT 'X'
*"  EXPORTING
*"     VALUE(EX_VBELN) TYPE  VBELN_VA
*"     VALUE(EX_MESSAGE) TYPE  BAPIRETCT
*"----------------------------------------------------------------------
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTC_INBOUND_SAP_ORDERS_FM
* PROGRAM DESCRIPTION : Tibco will call this RFC enabled function module
*                       instead of creating idoc in sap end. This function
*                       module receives data record and control record
*                       from tibco and will create idoc internally.
*                       After that it will process the idoc and pass the
*                       order number, for the case of success and message,
*                       for the case of failure to TIBCO.
* DEVELOPER           : Arijit Samanta
* CREATION DATE       : 16-Sep-2016
* OBJECT ID           : Cross Application for QTC (ORDERS05 Idoc)
* TRANSPORT NUMBER(S) : ED2K900927
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  07/12/2016
* DESCRIPTION:
* Change Tag :
* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
*-----------------------------------------------------------------------*
* REVISION NO:   ED2K906589
* REFERENCE NO:  ERP-2187
* DEVELOPER:     Pavan Bandlapalli(PBANDLAPAL)
* DATE:          07-Jun-2017
* DESCRIPTION: Code was missing for the segments E1EDPA1, E1EDPA3. Its been added
*  as part of this. Currently segment Z1QTC_E1EDPA1_01 is not being added as this
* segment will not be coming in inbound interface.
*&---------------------------------------------------------------------*
* REVISION NO:   ED2K908162
* REFERENCE NO:  ERP-2974
* DEVELOPER:     Writtick Roy (WROY)
* DATE:          23-Aug-2017
* DESCRIPTION:
* 1. Provide option for Immediate processing VS Batch processing
* 2. Update Error Handling process to display Standard messages
*&---------------------------------------------------------------------*
* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
  DATA : li_edids    TYPE STANDARD TABLE OF edids INITIAL SIZE 0, " Status Record (IDoc)
         lst_message TYPE bapiretc,                               " Return Parameter for Complex Data Type
         lst_edids   TYPE edids.                                  " Status Record (IDoc)
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639

  DATA: lv_docnum     TYPE edi_docnum, " IDoc number
        lv_segnum     TYPE edi_segnum, " Number of SAP segment
        lv_dtint2     TYPE edi_dtint2, " Length field for VARC field
        lv_psgnum     TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_old TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_p01 TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_hlevel     TYPE edi_hlevel, " Hierarchy level
        lst_edidc     TYPE edidc.      " Control record (IDoc)


  DATA: lt_edidd    TYPE STANDARD TABLE OF edidd " Data record (IDoc)
                    INITIAL SIZE 0,
        lst_edidd   TYPE edidd,                  " Data record (IDoc)
        lst_e1edk01 TYPE e1edk01.                " IDoc: Document header general data

  DATA: lst_e1edk14          TYPE e1edk14,          " IDoc: Document Header Organizational Data
        lst_e1edk03          TYPE e1edk14,          " IDoc: Document Header Organizational Data
        lst_e1edk04          TYPE e1edk04,          " IDoc: Document header taxes
        lst_e1edk05          TYPE e1edk05,          " IDoc: Document header conditions
        lst_zstqtc_e1edka1   TYPE zstqtc_e1edka1,   " Structure for E1EDKA1
        lst_e1edka3          TYPE e1edka3,          " IDoc: Document Header Partner Information Additional Data
        lst_e1edk02          TYPE e1edk02,          " IDoc: Document header reference data
        lst_e1edk17          TYPE e1edk17,          " IDoc: Document Header Terms of Delivery
        lst_e1edk18          TYPE e1edk18,          " IDoc: Document Header Terms of Payment
        lst_e1edk35          TYPE e1edk35,          " IDoc: Document Header Additional Data
        lst_e1edk36          TYPE e1edk36,          " IDOC: Doc.header payment cards
        lst_zstqtc_e1edkt1   TYPE zstqtc_e1edkt1,   " Structure For E1EDKT1
        lst_e1edkt2          TYPE e1edkt2,          " IDoc: Document Header Texts
        lst_zstqtc_e1edp01   TYPE zstqtc_e1edp01,   " Structure For E1EDP01
        lst_e1edp02          TYPE e1edp02,          " IDoc: Document Item Reference Data
        lst_e1addi1          TYPE e1addi1,          " IDoc: Additionals
        lst_e1edp03          TYPE e1edp03,          " IDoc: Document Item Date Segment
        lst_e1edp04          TYPE e1edp04,          " IDoc: Document Item Taxes
        lst_zstqtc_e1edp05   TYPE zstqtc_e1edp05,   " Structure For E1EDP05
        lst_e1edps5          TYPE e1edps5,          " A&D: Price Scale (Quantity)
        lst_e1edp20          TYPE e1edp20,          " IDoc schedule lines
        lst_zstqtc_e1edpa1   TYPE zstqtc_e1edpa1,   " Structure For E1EDPA1
        lst_e1edpa3          TYPE e1edpa3,          " IDoc: Document Item Partner Information Additional Data
        lst_z1qtc_e1edpa1_01 TYPE z1qtc_e1edpa1_01, " Partner Information (Legacy Customer Number)
        lst_e1edp19          TYPE e1edp19,          " IDoc: Document Item Object Identification
        lst_e1edp17          TYPE e1edp17,          " IDoc: Document item terms of delivery
        lst_e1edp18          TYPE e1edp18,          " IDoc: Document Item Terms of Payment
        lst_e1edp35          TYPE e1edp35,          " IDoc: Document Item Additional Data
        lst_zstqtc_e1edpt1   TYPE zstqtc_e1edpt1,   " Structure For E1EDPT1
        lst_e1edpt2          TYPE e1edpt2,          " IDoc: Document Header Texts
        lst_zstqtc_e1cucfg   TYPE zstqtc_e1cucfg,   " Structure for E1CUCFG
        lst_e1cuins          TYPE e1cuins,          " CU: Instance data
        lst_e1cuprt          TYPE e1cuprt,          " CU: part-of data
        lst_e1cuval          TYPE e1cuval,          " CU: Characteristic valuation
        lst_e1cublb          TYPE e1cublb,          " CU: Configuration BLOB (SCE)
        lst_zstqtc_e1edl37   TYPE zstqtc_e1edl37,   " Structure for E1EDL37
        lst_e1edl39          TYPE e1edl39,          " Control Segment for Handling Units
        lst_e1edl38          TYPE e1edl38,          " Handling Unit Header Descriptions
        lst_e1edl44          TYPE e1edl44,          " IDoc: Handling Unit Item (Delivery)
        lst_e1eds01          TYPE e1eds01,          " IDoc: Summary segment general
        lst_e1txtp1          TYPE e1txtp1.          " General Text Segment

  CONSTANTS: lc_status_50 TYPE edi_status VALUE '50', " Idoc Status
             lc_status_64 TYPE edi_status VALUE '64', " Idoc Status
* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
             lc_status_53 TYPE  edi_status  VALUE '53'. " Idoc Status
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639

  CLEAR : lv_segnum, lv_psgnum, lv_psgnum_old.

  lv_dtint2 = '1000'.
  lv_hlevel = '01'.

  lst_edidd-segnam = 'E1EDK01'.
  lv_segnum = lv_segnum + 1.
  lst_edidd-segnum = lv_segnum.
  lst_edidd-dtint2 = lv_dtint2.
  lst_edidd-psgnum = lv_psgnum.
  lst_edidd-hlevel = lv_hlevel.
  lst_edidd-sdata = im_edidd-e1edk01.
  APPEND lst_edidd TO lt_edidd.

  lv_hlevel = lv_hlevel + 1.

  IF im_edidd-z1qtc_e1edk01_01 IS NOT INITIAL.
    lst_edidd-segnam = 'Z1QTC_E1EDK01_01'.
    lv_psgnum = lv_segnum.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = im_edidd-z1qtc_e1edk01_01.
    APPEND lst_edidd TO lt_edidd.
  ENDIF. " IF im_edidd-z1qtc_e1edk01_01 IS NOT INITIAL

  lv_psgnum = lv_psgnum_old.
  LOOP AT im_edidd-e1edk14 INTO lst_e1edk14.
    lst_edidd-segnam = 'E1EDK14'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk14.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk14 INTO lst_e1edk14

  LOOP AT im_edidd-e1edk03 INTO lst_e1edk03.
    lst_edidd-segnam = 'E1EDK03'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk03.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk03 INTO lst_e1edk03

  LOOP AT im_edidd-e1edk04 INTO lst_e1edk04.
    lst_edidd-segnam = 'E1EDK04'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk04.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk04 INTO lst_e1edk04

  LOOP AT im_edidd-e1edk05 INTO lst_e1edk05.
    lst_edidd-segnam = 'E1EDK05'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk05.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk05 INTO lst_e1edk05

  LOOP AT im_edidd-e1edka1 INTO lst_zstqtc_e1edka1.
    lst_edidd-segnam = 'E1EDKA1'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_zstqtc_e1edka1-e1edka1.
    APPEND lst_edidd TO lt_edidd.
*** BOC by SAYANDAS
*    lv_psgnum = lv_segnum.
    lv_hlevel = lv_hlevel + 1.
    IF lst_zstqtc_e1edka1-z1qtc_e1edka1_01 IS NOT INITIAL.
      lst_edidd-segnam = 'Z1QTC_E1EDKA1_01'.
      lv_psgnum = lv_segnum.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata =  lst_zstqtc_e1edka1-z1qtc_e1edka1_01.
      APPEND lst_edidd TO lt_edidd.
    ENDIF. " IF lst_zstqtc_e1edka1-z1qtc_e1edka1_01 IS NOT INITIAL
    lv_hlevel = lv_hlevel - 1.
***EOC by SAYANDAS
    lv_psgnum = lv_segnum.
    lv_hlevel = lv_hlevel + 1.
    LOOP AT lst_zstqtc_e1edka1-e1edka3 INTO lst_e1edka3.
      lst_edidd-segnam = 'E1EDKA3'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edka3.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edka1-e1edka3 INTO lst_e1edka3
    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.
  ENDLOOP. " LOOP AT im_edidd-e1edka1 INTO lst_zstqtc_e1edka1

  LOOP AT im_edidd-e1edk02 INTO lst_e1edk02.
    lst_edidd-segnam = 'E1EDK02'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk02.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk02 INTO lst_e1edk02

  LOOP AT im_edidd-e1edk17 INTO lst_e1edk17.
    lst_edidd-segnam = 'E1EDK17'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk17.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk17 INTO lst_e1edk17

  LOOP AT im_edidd-e1edk18 INTO lst_e1edk18.
    lst_edidd-segnam = 'E1EDK18'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk18.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk18 INTO lst_e1edk18

  LOOP AT im_edidd-e1edk35 INTO lst_e1edk35.
    lst_edidd-segnam = 'E1EDK35'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk35.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk35 INTO lst_e1edk35

  LOOP AT im_edidd-e1edk36 INTO lst_e1edk36.
    lst_edidd-segnam = 'E1EDK36'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk36.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk36 INTO lst_e1edk36

  LOOP AT im_edidd-e1edkt1 INTO lst_zstqtc_e1edkt1.
    lst_edidd-segnam = 'E1EDKT1'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_zstqtc_e1edkt1-e1edkt1.
    APPEND lst_edidd TO lt_edidd.

    lv_psgnum = lv_segnum.
    lv_hlevel = lv_hlevel + 1.
    LOOP AT lst_zstqtc_e1edkt1-e1edkt2 INTO lst_e1edkt2.
      lst_edidd-segnam = 'E1EDKT2'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edkt2.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edkt1-e1edkt2 INTO lst_e1edkt2
    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.
  ENDLOOP. " LOOP AT im_edidd-e1edkt1 INTO lst_zstqtc_e1edkt1


* ------->>> PO1 Segment
  LOOP AT im_edidd-e1edp01 INTO lst_zstqtc_e1edp01.
    lst_edidd-segnam = 'E1EDP01'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_zstqtc_e1edp01-e1edp01.
    APPEND lst_edidd TO lt_edidd.

    lv_psgnum = lv_segnum.
    lv_psgnum_p01 = lv_segnum.
    lv_hlevel = lv_hlevel + 1.

    IF lst_zstqtc_e1edp01-z1qtc_e1edp01_01 IS NOT INITIAL.
      lst_edidd-segnam = 'Z1QTC_E1EDP01_01'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edp01-z1qtc_e1edp01_01.
      APPEND lst_edidd TO lt_edidd.
    ENDIF. " IF lst_zstqtc_e1edp01-z1qtc_e1edp01_01 IS NOT INITIAL



    LOOP AT lst_zstqtc_e1edp01-e1edp02 INTO lst_e1edp02.
      lst_edidd-segnam = 'E1EDP02'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp02.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp02 INTO lst_e1edp02

    IF lst_zstqtc_e1edp01-e1curef IS NOT INITIAL.
      lst_edidd-segnam = 'E1CUREF'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edp01-e1curef.
      APPEND lst_edidd TO lt_edidd.
    ENDIF. " IF lst_zstqtc_e1edp01-e1curef IS NOT INITIAL


    LOOP AT lst_zstqtc_e1edp01-e1addi1 INTO lst_e1addi1.
      lst_edidd-segnam = 'E1ADDI1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1addi1.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1addi1 INTO lst_e1addi1
    LOOP AT lst_zstqtc_e1edp01-e1edp03 INTO lst_e1edp03.
      lst_edidd-segnam = 'E1EDP03'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp03.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp03 INTO lst_e1edp03
    LOOP AT lst_zstqtc_e1edp01-e1edp04 INTO lst_e1edp04.
      lst_edidd-segnam = 'E1EDP04'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp04.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp04 INTO lst_e1edp04
    LOOP AT lst_zstqtc_e1edp01-e1edp05 INTO lst_zstqtc_e1edp05.
      lst_edidd-segnam = 'E1EDP05'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edp05-e1edp05.
      APPEND lst_edidd TO lt_edidd.
      lv_hlevel = lv_hlevel + 1.
      lv_psgnum = lv_segnum.

      LOOP AT lst_zstqtc_e1edp05-e1edps5 INTO lst_e1edps5.
        lst_edidd-segnam = 'E1EDPS5'.
        lv_segnum = lv_segnum + 1.
        lst_edidd-segnum = lv_segnum.
        lst_edidd-dtint2 = lv_dtint2.
        lst_edidd-psgnum = lv_psgnum.
        lst_edidd-hlevel = lv_hlevel.
        lst_edidd-sdata = lst_e1edps5.
        APPEND lst_edidd TO lt_edidd.
      ENDLOOP. " LOOP AT lst_zstqtc_e1edp05-e1edps5 INTO lst_e1edps5
      lv_hlevel = lv_hlevel - 1.
      lv_psgnum = lv_psgnum_p01.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp05 INTO lst_zstqtc_e1edp05
    LOOP AT lst_zstqtc_e1edp01-e1edp20 INTO lst_e1edp20.
      lst_edidd-segnam = 'E1EDP20'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp20.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp20 INTO lst_e1edp20

**** BOC by SAYANDAS on 07-Jun-2017 for Defect ERP-2187
    LOOP AT lst_zstqtc_e1edp01-e1edpa1 INTO lst_zstqtc_e1edpa1.
      lst_edidd-segnam = 'E1EDPA1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edpa1-e1edpa1.
      APPEND lst_edidd TO lt_edidd.
      lv_hlevel = lv_hlevel + 1.
      lv_psgnum = lv_segnum.

*      LOOP AT lst_zstqtc_e1edpa1-z1qtc_e1edpa1_01 INTO lst_z1qtc_e1edpa1_01.
*        lst_edidd-segnam = 'Z1QTC_E1EDPA1_01'.
*        lv_segnum = lv_segnum + 1.
*        lst_edidd-segnum = lv_segnum.
*        lst_edidd-dtint2 = lv_dtint2.
*        lst_edidd-psgnum = lv_psgnum.
*        lst_edidd-hlevel = lv_hlevel.
*        lst_edidd-sdata = lst_z1qtc_e1edpa1_01.
*        APPEND lst_edidd TO lt_edidd.
*      ENDLOOP. " LOOP AT lst_zstqtc_e1edpa1-z1qtc_e1edpa1_01 INTO lst_z1qtc_e1edpa1_01
*
*      lv_psgnum = lv_segnum.
*
      LOOP AT lst_zstqtc_e1edpa1-e1edpa3 INTO lst_e1edpa3.
        lst_edidd-segnam = 'E1EDPA3'.
        lv_segnum = lv_segnum + 1.
        lst_edidd-segnum = lv_segnum.
        lst_edidd-dtint2 = lv_dtint2.
        lst_edidd-psgnum = lv_psgnum.
        lst_edidd-hlevel = lv_hlevel.
        lst_edidd-sdata = lst_e1edpa3.
        APPEND lst_edidd TO lt_edidd.
      ENDLOOP. " LOOP AT lst_zstqtc_e1edpa1-e1edpa3 INTO lst_e1edpa3
      lv_hlevel = lv_hlevel - 1.
      lv_psgnum = lv_psgnum_p01.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edpa1 INTO lst_zstqtc_e1edpa1
**** EOC by SAYANDAS on 07-Jun-2017 for Defect ERP-2187

    LOOP AT lst_zstqtc_e1edp01-e1edp19 INTO lst_e1edp19.
      lst_edidd-segnam = 'E1EDP19'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp19.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp19 INTO lst_e1edp19

    IF lst_zstqtc_e1edp01-e1edpad-e1edpad IS NOT INITIAL.
      lst_edidd-segnam = 'E1EDPAD'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edp01-e1edpad-e1edpad.
      APPEND lst_edidd TO lt_edidd.
    ENDIF. " IF lst_zstqtc_e1edp01-e1edpad-e1edpad IS NOT INITIAL

    IF lst_zstqtc_e1edp01-e1edpad-e1txth1-e1txth1 IS NOT INITIAL.
      lst_edidd-segnam = 'E1TXTH1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edp01-e1edpad-e1txth1-e1txth1.
      APPEND lst_edidd TO lt_edidd.
    ENDIF. " IF lst_zstqtc_e1edp01-e1edpad-e1txth1-e1txth1 IS NOT INITIAL

    LOOP AT lst_zstqtc_e1edp01-e1edpad-e1txth1-e1txtp1 INTO lst_e1txtp1.
      lst_edidd-segnam = 'E1TXTP1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1txtp1.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edpad-e1txth1-e1txtp1 INTO lst_e1txtp1

    LOOP AT lst_zstqtc_e1edp01-e1edp17 INTO lst_e1edp17.
      lst_edidd-segnam = 'E1EDP17'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp17.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp17 INTO lst_e1edp17
    LOOP AT lst_zstqtc_e1edp01-e1edp18 INTO lst_e1edp18.
      lst_edidd-segnam = 'E1EDP18'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp18.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp18 INTO lst_e1edp18
    LOOP AT lst_zstqtc_e1edp01-e1edp35 INTO lst_e1edp35.
      lst_edidd-segnam = 'E1EDP35'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp35.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp35 INTO lst_e1edp35

*** BOC BY SAYANDAS
    LOOP AT lst_zstqtc_e1edp01-e1edpt1 INTO lst_zstqtc_e1edpt1.
      lst_edidd-segnam = 'E1EDPT1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_zstqtc_e1edpt1-e1edpt1.
      APPEND lst_edidd TO lt_edidd.

      lv_hlevel = lv_hlevel + 1.
      lv_psgnum = lv_segnum.

      LOOP AT lst_zstqtc_e1edpt1-e1edpt2 INTO lst_e1edpt2.
        lst_edidd-segnam = 'E1EDPT2'.
        lv_segnum = lv_segnum + 1.
        lst_edidd-segnum = lv_segnum.
        lst_edidd-dtint2 = lv_dtint2.
        lst_edidd-psgnum = lv_psgnum.
        lst_edidd-hlevel = lv_hlevel.
        lst_edidd-sdata = lst_e1edpt2.
        APPEND lst_edidd TO lt_edidd.
      ENDLOOP. " LOOP AT lst_zstqtc_e1edpt1-e1edpt2 INTO lst_e1edpt2
      lv_hlevel = lv_hlevel - 1.
      lv_psgnum = lv_psgnum_p01.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edpt1 INTO lst_zstqtc_e1edpt1
*** EOC BY SAYANDAS
    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.
  ENDLOOP. " LOOP AT im_edidd-e1edp01 INTO lst_zstqtc_e1edp01

*** BOC BY SAYANDAS
*  LOOP AT lst_zstqtc_e1edp01-e1edpt1 INTO lst_zstqtc_e1edpt1.
*    lst_edidd-segnam = 'E1EDPT1'.
*    lv_segnum = lv_segnum + 1.
*    lst_edidd-segnum = lv_segnum.
*    lst_edidd-dtint2 = lv_dtint2.
*    lst_edidd-psgnum = lv_psgnum.
*    lst_edidd-hlevel = lv_hlevel.
*    lst_edidd-sdata = lst_zstqtc_e1edpt1-e1edpt1.
*    APPEND lst_edidd TO lt_edidd.
*
*    lv_psgnum = lv_segnum.
*    lv_hlevel = lv_hlevel + 1.
*    LOOP AT lst_zstqtc_e1edpt1-e1edpt2 INTO lst_e1edpt2.
*      lst_edidd-segnam = 'E1EDPT2'.
*      lv_segnum = lv_segnum + 1.
*      lst_edidd-segnum = lv_segnum.
*      lst_edidd-dtint2 = lv_dtint2.
*      lst_edidd-psgnum = lv_psgnum.
*      lst_edidd-hlevel = lv_hlevel.
*      lst_edidd-sdata = lst_e1edpt2.
*      APPEND lst_edidd TO lt_edidd.
*    ENDLOOP. " LOOP AT lst_zstqtc_e1edpt1-e1edpt2 INTO lst_e1edpt2
*    lv_hlevel = lv_hlevel - 1.
*    lv_psgnum = lv_psgnum_old.
*  ENDLOOP. " LOOP AT im_edidd-e1edpt1 INTO lst_zstqtc_e1edpt1
*** EOC BY SAYANDAS

  LOOP AT im_edidd-e1cucfg INTO lst_zstqtc_e1cucfg.
    lst_edidd-segnam = 'E1CUCFG'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_zstqtc_e1cucfg-e1cucfg.
    APPEND lst_edidd TO lt_edidd.

    lv_psgnum = lv_segnum.
    lv_hlevel = lv_hlevel + 1.
    LOOP AT lst_zstqtc_e1cucfg-e1cuins INTO lst_e1cuins.
      lst_edidd-segnam = 'E1CUINS'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1cuins.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1cucfg-e1cuins INTO lst_e1cuins
    LOOP AT lst_zstqtc_e1cucfg-e1cuprt INTO lst_e1cuprt.
      lst_edidd-segnam = 'E1CUPRT'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1cuprt.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1cucfg-e1cuprt INTO lst_e1cuprt
    LOOP AT lst_zstqtc_e1cucfg-e1cuval INTO lst_e1cuval.
      lst_edidd-segnam = 'E1CUVAL'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1cuval.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1cucfg-e1cuval INTO lst_e1cuval
    LOOP AT lst_zstqtc_e1cucfg-e1cublb INTO lst_e1cublb.
      lst_edidd-segnam = 'E1CUBLB'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1cublb.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1cucfg-e1cublb INTO lst_e1cublb
    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.
  ENDLOOP. " LOOP AT im_edidd-e1cucfg INTO lst_zstqtc_e1cucfg


  LOOP AT im_edidd-e1edl37 INTO lst_zstqtc_e1edl37.
    lst_edidd-segnam = 'E1EDL37'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_zstqtc_e1edl37-e1edl37.
    APPEND lst_edidd TO lt_edidd.

    lv_psgnum = lv_segnum.
    lv_hlevel = lv_hlevel + 1.
    LOOP AT lst_zstqtc_e1edl37-e1edl39 INTO lst_e1edl39.
      lst_edidd-segnam = 'E1EDL39'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edl39.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edl37-e1edl39 INTO lst_e1edl39
    LOOP AT lst_zstqtc_e1edl37-e1edl38 INTO lst_e1edl38.
      lst_edidd-segnam = 'E1EDL38'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edl38.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edl37-e1edl38 INTO lst_e1edl38
    LOOP AT lst_zstqtc_e1edl37-e1edl44 INTO lst_e1edl44.
      lst_edidd-segnam = 'E1EDL44'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edl44.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edl37-e1edl44 INTO lst_e1edl44
    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.
  ENDLOOP. " LOOP AT im_edidd-e1edl37 INTO lst_zstqtc_e1edl37

  LOOP AT im_edidd-e1eds01 INTO lst_e1eds01.
    lst_edidd-segnam = 'E1EDS01'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1eds01.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1eds01 INTO lst_e1eds01


  CALL FUNCTION 'EDI_DOCUMENT_OPEN_FOR_CREATE'
    EXPORTING
      idoc_control         = im_edidc
*     PI_RFC_MULTI_CP      = '    '
    IMPORTING
      identifier           = lv_docnum
    EXCEPTIONS
      other_fields_invalid = 1
      OTHERS               = 2.
  IF sy-subrc IS INITIAL.

    CALL FUNCTION 'EDI_SEGMENTS_ADD_BLOCK'
      EXPORTING
        identifier                    = lv_docnum
      TABLES
        idoc_containers               = lt_edidd
      EXCEPTIONS
        identifier_invalid            = 1
        idoc_containers_empty         = 2
        parameter_error               = 3
        segment_number_not_sequential = 4
        OTHERS                        = 5.
    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'EDI_DOCUMENT_CLOSE_CREATE'
        EXPORTING
          identifier          = lv_docnum
*         NO_DEQUEUE          = ' '
*         SYN_ACTIVE          = ' '
        IMPORTING
          idoc_control        = lst_edidc
*         SYNTAX_RETURN       =
        EXCEPTIONS
          document_not_open   = 1
          document_no_key     = 2
          failure_in_db_write = 3
          parameter_error     = 4
          OTHERS              = 5.
      IF sy-subrc IS INITIAL.
        IF lst_edidc-status = lc_status_50.
          COMMIT WORK.

*         Call submit program to change the Idoc status from 51 to 64.
          SUBMIT rc1_idoc_set_status
            WITH p_idoc   EQ lst_edidc-docnum " Idoc Number
            WITH p_mestyp EQ lst_edidc-mestyp " Message Type
            WITH p_status EQ lc_status_50     " Current Status -> '50'
            WITH p_staneu EQ lc_status_64     " To Be status -> '64'
            WITH p_test   EQ abap_false
            EXPORTING LIST TO MEMORY
            AND RETURN.
* Begin of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
          IF im_immediate IS NOT INITIAL.
* End   of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
*           Call submit program to process the idoc.
            SUBMIT rbdapp01
              WITH docnum EQ lst_edidc-docnum " Idoc Number
              EXPORTING LIST TO MEMORY
              AND RETURN.

* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
* Table EDIDS is having only 26 record so Select * has been used.
            SELECT *
            FROM edids " Status Record (IDoc)
            INTO TABLE li_edids
            WHERE docnum = lst_edidc-docnum.
            IF sy-subrc EQ 0.
              SORT li_edids BY status.
            ENDIF. " IF sy-subrc EQ 0
* Check if IDOC is succssfully(Status 53) posted or not .
            READ TABLE li_edids INTO lst_edids WITH KEY status  = lc_status_53
                                                        BINARY SEARCH .
            IF sy-subrc EQ 0.
              ex_vbeln = lst_edids-stapa2.
              lst_message-type    = lst_edids-statyp.
              lst_message-id      = lst_edids-stamid.
              lst_message-number  = lst_edids-stamno.
              lst_message-message_v1 = lst_edids-stapa1.
              lst_message-message_v2 = lst_edids-stapa2.
              lst_message-message_v3 = lst_edids-stapa3.
              lst_message-message_v4 = lst_edids-stapa4.
              IF lst_message-type IS INITIAL.
                lst_message-type = 'S'.
              ENDIF. " IF lst_message-type IS INITIAL

              MESSAGE ID lst_message-id
                    TYPE lst_message-type
                  NUMBER lst_message-number
                    WITH lst_message-message_v1
                         lst_message-message_v2
                         lst_message-message_v3
                         lst_message-message_v4
                    INTO lst_message-message.
              APPEND lst_message TO ex_message.
              CLEAR lst_message.
            ELSE. " ELSE -> IF sy-subrc EQ 0
              LOOP AT li_edids INTO lst_edids WHERE statyp EQ 'E'.
                lst_message-type    = lst_edids-statyp.
                lst_message-id      = lst_edids-stamid.
                lst_message-number  = lst_edids-stamno.
                lst_message-message_v1 = lst_edids-stapa1.
                lst_message-message_v2 = lst_edids-stapa2.
                lst_message-message_v3 = lst_edids-stapa3.
                lst_message-message_v4 = lst_edids-stapa4.

                MESSAGE ID lst_message-id
                      TYPE lst_message-type
                    NUMBER lst_message-number
                      WITH lst_message-message_v1
                           lst_message-message_v2
                           lst_message-message_v3
                           lst_message-message_v4
                      INTO lst_message-message.
                APPEND lst_message TO ex_message.
                CLEAR lst_message.
              ENDLOOP. " LOOP AT li_edids INTO lst_edids WHERE statyp EQ 'E'
            ENDIF. " IF sy-subrc EQ 0
* Begin of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
          ELSE.
            MESSAGE s693(edereg_inv) WITH lst_edidc-docnum INTO DATA(lv_message).
            PERFORM f_populate_error_msg CHANGING ex_message.
          ENDIF.
* End   of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
        ENDIF. " IF lst_edidc-status = lc_status_50
      ELSE. " ELSE -> IF sy-subrc IS INITIAL
* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
        PERFORM f_populate_error_msg CHANGING ex_message.
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639

      ENDIF. " IF sy-subrc IS INITIAL
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
      PERFORM f_populate_error_msg CHANGING ex_message.
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
    ENDIF. " IF sy-subrc IS INITIAL
  ELSE. " ELSE -> IF sy-subrc IS INITIAL

* BOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
    PERFORM f_populate_error_msg CHANGING ex_message.
* EOC by LKODWANI on 07-Dec-2016 TR#ED2K902639
  ENDIF. " IF sy-subrc IS INITIAL

ENDFUNCTION.
