FUNCTION zqtc_find_quote_i0341.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_IHREZ) TYPE  EDI3413LA OPTIONAL
*"     VALUE(IM_MATNR) TYPE  EDI_IDTNR OPTIONAL
*"     VALUE(IM_CONTRL) TYPE  EDIDC OPTIONAL
*"  EXPORTING
*"     VALUE(EX_QUOTE) TYPE  IHREZ
*"     VALUE(EX_MATNR) TYPE  EDI_IDTNR
*"     VALUE(EX_KUNNR) TYPE  KUNNR
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_FIND_QUOTE_I0341(FM)
* PROGRAM DESCRIPTION: This FM is built to find the quote number.
* This has been called for ZREW orders inside userexit of inbound ORDERS IDoc
* DEVELOPER: Nageswar
* CREATION DATE: 09/11/2019
* OBJECT ID: I0341/ERPM1431
* TRANSPORT NUMBER(S): ED2K916111
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
**---------------------------------------------------------------------*
* REVISION NO:  ED1K911596
* REFERENCE NO: INC0279717
* DEVELOPER: RKUMAR2
* DATE: 06-FEB-2020
* DESCRIPTION: In case of BOM Scenarios, reference mateial check must happen
*              only for BOM header and not at product level
*-----------------------------------------------------------------------*
**---------------------------------------------------------------------*
* REVISION NO   : ED2K926646
* REFERENCE NO  : OTCM-54391
* DEVELOPER     : VDPATABALL
* DATE          : 04/07/2022
* DESCRIPTION   : For FTP Orders, if Media change, then also coping the Freight
*                 forwarder based on Sold to paty Ref number
*-----------------------------------------------------------------------*
* Local Types
  TYPES: BEGIN OF lty_vbkd,
           vbeln TYPE vbeln,
         END OF lty_vbkd,
         BEGIN OF lty_vbak,
           vbeln TYPE vbeln_va,
           erdat TYPE erdat,
           erzet TYPE erzet,
         END OF   lty_vbak.

* Local Data
  DATA: li_vbkd  TYPE STANDARD TABLE OF lty_vbkd, " VBKD fields
        lv_matnr TYPE edi_idtnr,                  " Material
        li_vbak  TYPE STANDARD TABLE OF lty_vbak. " Vbak fields

  " Local Constants
  CONSTANTS:
    lc_b       TYPE char1 VALUE 'B',
    lc_a       TYPE char1 VALUE 'A',
    lc_we9     TYPE parvw VALUE 'WE',             " NPOLINA ERPM1431 ED2K916473
    lc_posnr_9 TYPE posnr VALUE '000000'.
*---BOC VDPATABALL 04/07/2022 Adding new changes for I0341  OTCM-54391 ED2K926646 If the material is changed from Quotation
  CONSTANTS:lc_devid_i0341 TYPE zdevid VALUE 'I0341',
            lc_1           TYPE tvarv_numb VALUE 1,
            lc_message_fun TYPE rvari_vnam VALUE 'MSG_FUN'.
*---EOC VDPATABALL 04/07/2022 Adding new changes for I0341  OTCM-54391 ED2K926646 If the material is changed from Quotation

  " Look for Quote directly
  IF im_ihrez IS NOT INITIAL AND im_matnr IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = im_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    " Fetch the reference quote from VBAK based on IHREZ (your reference value)
    SELECT SINGLE vbeln FROM vbak INTO ex_quote WHERE vbeln = im_ihrez
                                                AND   vbtyp EQ lc_b.
    IF sy-subrc NE 0." IHREZ (your reference) is not quote
      " Get all the reference documents matching with your reference(IHREZ) value
      SELECT vbeln FROM vbkd INTO TABLE li_vbkd
                             WHERE ihrez EQ im_ihrez.
      IF sy-subrc EQ 0 AND li_vbkd[] IS NOT INITIAL.
        " Get the existing reference quotes
        SELECT vbeln erdat erzet FROM vbak INTO TABLE li_vbak
                                 FOR ALL ENTRIES IN li_vbkd
                                 WHERE vbeln EQ li_vbkd-vbeln
                                 AND   vbtyp EQ lc_b.
        IF sy-subrc EQ 0 AND li_vbak[] IS NOT INITIAL.
          " Filter the existing Reference Quotes based on Status
          SELECT vbeln, posnr, rfsta, rfgsa
                 FROM vbup
                 INTO TABLE @DATA(li_vbup)
                 FOR ALL ENTRIES IN @li_vbak
                 WHERE vbeln = @li_vbak-vbeln
                 AND rfsta = @lc_a
                 AND rfgsa = @lc_a.
          IF sy-subrc = 0 AND li_vbup[] IS NOT INITIAL.
            SORT li_vbup BY vbeln DESCENDING.    " To get the latest Quote
            DATA(lv_vbeln) = li_vbup[ 1 ]-vbeln. " Latest Ref Quote
            READ TABLE li_vbak WITH KEY vbeln = lv_vbeln TRANSPORTING NO FIELDS.
            IF sy-subrc EQ 0.
              SELECT SINGLE kunnr FROM vbpa INTO ex_kunnr
                     WHERE vbeln = lv_vbeln AND
                           posnr = lc_posnr_9 AND
                           parvw = lc_we9.
            ENDIF.

            ex_matnr = lv_matnr.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input        = ex_matnr
              IMPORTING
                output       = ex_matnr
              EXCEPTIONS
                length_error = 1
                OTHERS       = 2.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.
            " Fetch the Quotes with reference to Material passed via FTP Order
            SELECT vbeln, posnr, matnr FROM vbap
                   INTO TABLE @DATA(li_vbap)
                   WHERE vbeln = @lv_vbeln
                   AND matnr = @lv_matnr
                   AND uepos = @lc_posnr_9. "Added ny RKUMAR2, INC0279717, ED1K911596
            IF sy-subrc EQ 0 AND li_vbap[] IS NOT INITIAL.
              " Scenario: Ref Quote exists and Product in both FTP Order and Ref Quote are same
              " In this case ZREW should be created with reference to Ref Quote

              " Pass Latest Ref Quote as reference document
              ex_quote = lv_vbeln.

            ELSE.  " ELSE ==> IF sy-subrc EQ 0 AND li_vbap[] IS NOT INITIAL.
              " Scenario: Ref Quote exists, but Product in both FTP Order and Ref Quote are different
              " In this case ZREW should be created without reference to Ref Quote
*---BOC VDPATABALL 04/07/2022 Adding new changes for I0341  OTCM-54391 ED2K926646 If the material is changed from Quotation
              CALL METHOD zca_utilities=>get_constants
                EXPORTING
                  im_devid     = lc_devid_i0341           "I0341
                  im_param1    = lc_message_fun
                IMPORTING
                  et_constants = DATA(li_const_msg).          "Constant Values
              DATA(lv_msg_fun) =   li_const_msg[ param1 = lc_message_fun srno = lc_1 ]-low. "get the message fun
              IF im_contrl-mesfct = lv_msg_fun.
                ex_quote = lv_vbeln.
              ENDIF.
*---EOC VDPATABALL 04/07/2022 Adding new changes for I0341 OTCM-54391 ED2K926646 If the material is changed from Quotation
            ENDIF. " SELECT on VBAP

          ELSE. " ELSE ==> IF sy-subrc = 0 AND li_vbup[] IS NOT INITIAL.
            " Ref. Quote doesn't exist. Hence an error message should throw
            " Error Msg: No reference quotation found to create a renewal contract
            ex_quote = abap_true.             " helps to throw error
          ENDIF.                              " SELECT on VBUP
        ELSE.
          " No Reference Quote exits at VBAK level
        ENDIF. " li_vbak is not initail
      ENDIF.   " li_vbkd is not initial
    ENDIF.     " IF sy-subrc ne 0 (SELECT on VBAK)

    CLEAR: li_vbkd[], li_vbak[], li_vbap[], li_vbup[], lv_vbeln, lv_matnr.
  ENDIF.       " IF im_ihrez IS NOT INITIAL.



ENDFUNCTION.
