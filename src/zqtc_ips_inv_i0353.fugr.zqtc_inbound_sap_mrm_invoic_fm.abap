FUNCTION zqtc_inbound_sap_mrm_invoic_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_EDIDD) TYPE  ZSTQTC_IDOC_INVOIC01
*"     VALUE(IM_EDIDC) TYPE  EDIDC
*"     VALUE(IM_IMMEDIATE) TYPE  FLAG DEFAULT 'X'
*"  EXPORTING
*"     VALUE(EX_DOC_NO) TYPE  RE_BELNR
*"     VALUE(EX_IDOC_NO) TYPE  EDI_DOCNUM
*"     VALUE(EX_MESSAGE) TYPE  BAPIRETCT
*"----------------------------------------------------------------------
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTC_INBOUND_SAP_MRM_INVOIC_FM
* PROGRAM DESCRIPTION : Tibco will call this RFC enabled function module
*                       instead of creating idoc in sap end. This function
*                       module receives data record and control record
*                       from tibco and will create idoc internally for
*                       MM Invoice
*                       After that it will process the idoc and pass the
*                       order number, IDOC No for the case of success and
*                       message for the case of failure to TIBCO.
* DEVELOPER           : Niraj Gadre (NGADRE)
* CREATION DATE       : 06.25.2018
* OBJECT ID           : I0353
* TRANSPORT NUMBER(S) : ED2K912233
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
* Change Tag :
*-----------------------------------------------------------------------*

  DATA : li_edids    TYPE STANDARD TABLE OF edids INITIAL SIZE 0, " Status Record (IDoc)
         lst_message TYPE bapiretc,                               " Return Parameter for Complex Data Type
         lst_edids   TYPE edids.                                  " Status Record (IDoc)


  DATA: lv_docnum     TYPE edi_docnum, " IDoc number
        lv_segnum     TYPE edi_segnum, " Number of SAP segment
        lv_dtint2     TYPE edi_dtint2, " Length field for VARC field
        lv_psgnum     TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_old TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_p01 TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_att TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_psgnum_ka1 TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
        lv_hlevel     TYPE edi_hlevel, " Hierarchy level
        lst_edidc     TYPE edidc.      " Control record (IDoc)


  DATA: lt_edidd           TYPE STANDARD TABLE OF edidd " Data record (IDoc)
                    INITIAL SIZE 0,
        lst_edidd          TYPE edidd,                  " Data record (IDoc)
*        lst_e1edk01        TYPE e1edk01,                " IDoc: Document header general data
        lst_e1edka1        TYPE e1edka1,               " IDoc: Document Header Partner Information
        lst_e1edk03        TYPE e1edk14,               " IDoc: Document Header Organizational Data
        lst_e1edk04        TYPE e1edk04,               " IDoc: Document header taxes
        lst_e1edk05        TYPE e1edk05,               " IDoc: Document header conditions
        lst_e1edk02        TYPE e1edk02,               " IDoc: Document header reference data
        lst_e1edk17        TYPE e1edk17,               " IDoc: Document Header Terms of Delivery
        lst_e1edk18        TYPE e1edk18,               " IDoc: Document Header Terms of Payment
        lst_e1edk23        TYPE e1edk23,               " IDoc: Document Header Currency Segment
        lst_e1edk28        TYPE e1edk28,               " IDoc: Document Header Bank Data
        lst_e1edk29        TYPE e1edk29,               " IDoc: Document Header General Foreign Trade Data
        lst_e1edk14        TYPE e1edk14,               " IDoc: Document Header Organizational Data
        lst_zstqtc_e1edkt1 TYPE zstqtc_e1edkt1,        " Structure For E1EDKT1
        lst_e1edkt2        TYPE e1edkt2,               " IDoc: Document Header Texts
        lst_zstqtc_e1edp01 TYPE zstqtc_e1edp01_inv,    " Structure For E1EDP01
        lst_e1edp03        TYPE e1edp03,               " IDoc: Document Item Date Segment
        lst_e1edp04        TYPE e1edp04,               " IDoc: Document Item Taxes
        lst_e1edp02        TYPE e1edp02,               " IDoc: Document Item Reference Data
        lst_e1edp19        TYPE e1edp19,               " IDoc: Document Item Object Identification
        lst_e1edp26        TYPE e1edp26,               " IDoc schedule lines
        lst_zstqtc_e1edpt1 TYPE zstqtc_e1edpt1,        " Structure For E1EDPT1
        lst_e1edpt2        TYPE e1edpt2,               " IDoc: Document Header Texts
        lst_e1edp28        TYPE e1edp28,               " IDoc: Document Item - General Foreign Trade Data
        lst_e1edp08        TYPE e1edp08,               " IDoc: Package data individual
        lst_e1edp05        TYPE e1edp05,               " IDoc: Document Item Conditions
        lst_e1edpa1        TYPE e1edpa1,               " IDoc: Doc.item partner information
        lst_e1edk01        TYPE zstqtc_e1edk01_inv,    " structure for E1EDK01 IPS interface
        lst_itm_acc_data   TYPE z1qtc_itm_acc_data_01, " I0353 - IPS Invoice Interface-Accounting data for line item
        lst_inv_att        TYPE zstqtc_inv_att,        " Strcture for Z1QTC_INV_ATTCH_01 for INVOIC01
*        lst_att_header     TYPE z1qtc_inv_attch_01,    " I0353 - Segment for IPS invoice attachment File Name
        lst_att_content    TYPE z1qtc_attch_cont_01,   " I0353 - IPS Inovice Interface-Segment for Attachment content
        lst_e1eds01        TYPE e1eds01.               " IDoc: Summary segment general


  CONSTANTS:         lc_status_50 TYPE edi_status VALUE '50',   " Idoc Status
                     lc_status_64 TYPE edi_status VALUE '64',   " Idoc Status
                     lc_status_53 TYPE  edi_status  VALUE '53'. " Idoc Status


  CLEAR : lv_segnum, lv_psgnum, lv_psgnum_old, lv_psgnum_ka1, lv_psgnum_att.

  lv_dtint2 = '1000'.
  lv_hlevel = '01'.

  lst_e1edk01 = im_edidd-e1edk01.

  lst_edidd-segnam = 'E1EDK01'.
  lv_segnum = lv_segnum + 1.
  lst_edidd-segnum = lv_segnum.
  lst_edidd-dtint2 = lv_dtint2.
  lst_edidd-psgnum = lv_psgnum.
  lst_edidd-hlevel = lv_hlevel.
  lst_edidd-sdata = lst_e1edk01-e1edk01.
  APPEND lst_edidd TO lt_edidd.

  lv_psgnum_ka1 = lv_psgnum.
  lv_hlevel = lv_hlevel + 1.

  LOOP AT lst_e1edk01-z1qtc_itm_acc_data_01 INTO lst_itm_acc_data.
    lst_edidd-segnam = 'Z1QTC_ITM_ACC_DATA_01'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum_ka1.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_itm_acc_data.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT lst_e1edk01-z1qtc_itm_acc_data_01 INTO lst_itm_acc_data

  LOOP AT lst_e1edk01-z1qtc_inv_attch INTO lst_inv_att.

    IF lst_inv_att-z1qtc_inv_attch_01 IS NOT INITIAL.

      lst_edidd-segnam = 'Z1QTC_INV_ATTCH_01'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum_ka1.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_inv_att-z1qtc_inv_attch_01.
      APPEND lst_edidd TO lt_edidd.

      IF lst_inv_att-z1qtc_attch_cont_01 IS NOT INITIAL.
        lv_hlevel = lv_hlevel + 1.
        lv_psgnum = lv_segnum.

        LOOP AT lst_inv_att-z1qtc_attch_cont_01 INTO lst_att_content.

          lst_edidd-segnam = 'Z1QTC_ATTCH_CONT_01'.
          lv_segnum = lv_segnum + 1.
          lst_edidd-segnum = lv_segnum.
          lst_edidd-dtint2 = lv_dtint2.
          lst_edidd-psgnum = lv_psgnum.
          lst_edidd-hlevel = lv_hlevel.
          lst_edidd-sdata = lst_att_content-attcontent.
          APPEND lst_edidd TO lt_edidd.

        ENDLOOP. " LOOP AT lst_inv_att-z1qtc_attch_cont_01 INTO lst_att_content

        lv_hlevel = lv_hlevel - 1.

      ENDIF. " IF lst_inv_att-z1qtc_attch_cont_01 IS NOT INITIAL

      lv_psgnum = lv_psgnum_old.

    ENDIF. " IF lst_inv_att-z1qtc_inv_attch_01 IS NOT INITIAL

  ENDLOOP. " LOOP AT lst_e1edk01-z1qtc_inv_attch INTO lst_inv_att

*  ENDLOOP. " LOOP AT im_edidd-e1edk01 INTO lst_e1edk01

  LOOP AT im_edidd-e1edka1 INTO lst_e1edka1.
    lst_edidd-segnam = 'E1EDKA1'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edka1.
    APPEND lst_edidd TO lt_edidd.

  ENDLOOP. " LOOP AT im_edidd-e1edka1 INTO lst_e1edka1

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

  LOOP AT im_edidd-e1edk23 INTO lst_e1edk23.
    lst_edidd-segnam = 'E1EDK23'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk23.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk23 INTO lst_e1edk23

  LOOP AT im_edidd-e1edk28 INTO lst_e1edk28.
    lst_edidd-segnam = 'E1EDK28'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk28.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk28 INTO lst_e1edk28

  LOOP AT im_edidd-e1edk29 INTO lst_e1edk29.
    lst_edidd-segnam = 'E1EDK29'.
    lv_segnum = lv_segnum + 1.
    lst_edidd-segnum = lv_segnum.
    lst_edidd-dtint2 = lv_dtint2.
    lst_edidd-psgnum = lv_psgnum.
    lst_edidd-hlevel = lv_hlevel.
    lst_edidd-sdata = lst_e1edk29.
    APPEND lst_edidd TO lt_edidd.
  ENDLOOP. " LOOP AT im_edidd-e1edk29 INTO lst_e1edk29

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

    LOOP AT lst_zstqtc_e1edp01-e1edp26 INTO lst_e1edp26.
      lst_edidd-segnam = 'E1EDP26'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp26.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp26 INTO lst_e1edp26

    LOOP AT lst_zstqtc_e1edp01-e1edpa1 INTO lst_e1edpa1.
      lst_edidd-segnam = 'E1EDPA1'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edpa1.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edpa1 INTO lst_e1edpa1

    LOOP AT lst_zstqtc_e1edp01-e1edp05 INTO lst_e1edp05.
      lst_edidd-segnam = 'E1EDP05'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp05.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp05 INTO lst_e1edp05

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

    LOOP AT lst_zstqtc_e1edp01-e1edp28 INTO lst_e1edp28.
      lst_edidd-segnam = 'E1EDP28'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp28.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp28 INTO lst_e1edp28

    LOOP AT lst_zstqtc_e1edp01-e1edp08 INTO lst_e1edp08.
      lst_edidd-segnam = 'E1EDP08'.
      lv_segnum = lv_segnum + 1.
      lst_edidd-segnum = lv_segnum.
      lst_edidd-dtint2 = lv_dtint2.
      lst_edidd-psgnum = lv_psgnum.
      lst_edidd-hlevel = lv_hlevel.
      lst_edidd-sdata = lst_e1edp08.
      APPEND lst_edidd TO lt_edidd.
    ENDLOOP. " LOOP AT lst_zstqtc_e1edp01-e1edp08 INTO lst_e1edp08

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

    lv_hlevel = lv_hlevel - 1.
    lv_psgnum = lv_psgnum_old.

  ENDLOOP. " LOOP AT im_edidd-e1edp01 INTO lst_zstqtc_e1edp01

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

          ex_idoc_no = lst_edidc-docnum.

          IF im_immediate IS NOT INITIAL.
*           Call submit program to process the idoc.
            SUBMIT rbdapp01
              WITH docnum EQ lst_edidc-docnum " Idoc Number
              EXPORTING LIST TO MEMORY
              AND RETURN.

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
              ex_doc_no = lst_edids-stapa2.
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

          ELSE. " ELSE -> IF im_immediate IS NOT INITIAL
            MESSAGE s693(edereg_inv) WITH lst_edidc-docnum INTO DATA(lv_message). " IDOC &1 successfully created
            PERFORM f_populate_error_msg CHANGING ex_message.
          ENDIF. " IF im_immediate IS NOT INITIAL

        ENDIF. " IF lst_edidc-status = lc_status_50

      ELSE. " ELSE -> IF sy-subrc IS INITIAL

        PERFORM f_populate_error_msg CHANGING ex_message.


      ENDIF. " IF sy-subrc IS INITIAL
    ELSE. " ELSE -> IF sy-subrc IS INITIAL

      PERFORM f_populate_error_msg CHANGING ex_message.

    ENDIF. " IF sy-subrc IS INITIAL
  ELSE. " ELSE -> IF sy-subrc IS INITIAL

    PERFORM f_populate_error_msg CHANGING ex_message.

  ENDIF. " IF sy-subrc IS INITIAL

ENDFUNCTION.
