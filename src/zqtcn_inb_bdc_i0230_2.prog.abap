
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INB_BDC_I0230_2
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INB_BDC_I0230_2
* PROGRAM DESCRIPTION: Include for customer population for Z24 for ZPPV
* DEVELOPER: NPOLINA (Nageswara)
* CREATION DATE:   06-Nov-2019
* OBJECT ID: I0230.2/ERPM935
* TRANSPORT NUMBER(S): ED2K916726
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917861
* REFERENCE NO:  I0230.2/ERPM13322
* DEVELOPER: Nagireddy Modugu
* DATE:  27-March-2020
* DESCRIPTION: Clearing static variable to make sure AUTH type get updated
*              as manual authorization on payment card details of the PPV order data
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920380
* REFERENCE NO:  I0230.2/OTCM-28180/OTCM-28181
* DEVELOPER: Nageswar
* DATE:  20-Nov-2020
* DESCRIPTION: Organization Name and Stree 2 address details update for Z24 PPV Orders
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K921024
* REFERENCE NO:  I0230.2/OTCM-27280
* DEVELOPER: Siva Guda
* DATE:  30-Dec-2020
* DESCRIPTION: Sales Tax registation number on WOL (VAT Number) update for Z24 PPV Orders
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K926818
* REFERENCE NO:  I0230.2/OTCM-58961
* DEVELOPER: Nageswara Polina(NPOLINA)
* DATE:  13-Apr-2022
* DESCRIPTION: Allow 3rd address line in PPV transactions from WOL.
*------------------------------------------------------------------------*

  DATA: lst_bdcdata_230_2     LIKE LINE OF  bdcdata,
        lst_edidd_230_2       TYPE edidd,
        lv_licstdt            TYPE char10,   " Stdt9 of type CHAR10
        lv_licenddt           TYPE char10,   " Eddt9 of type CHAR10
        lv_podate1            TYPE char10,   " Eddt9 of type CHAR10
        lst_e1edk14_2         TYPE e1edk14,
        lst_e1edk02_2         TYPE e1edk02,
        lst_e1edka1_2         TYPE e1edka1,
        lst_ze1edp01_2        TYPE z1qtc_e1edp01_01,
        lst1_z1qtc_e1edka1_04 TYPE z1qtc_e1edka1_01,
        lst_e1edk03_2         TYPE e1edk03.

  DATA: lv_loop_2              TYPE sy-tabix,
        lv_row_2(2)            TYPE n,
        lv_email_id            TYPE ad_smtpadr,
        lv_tabx_2              TYPE sy-tabix,
        lv_tabx_l              TYPE sy-tabix,
        lv_tabx_p              TYPE sy-tabix,
        lv_tabx_po             TYPE sy-tabix,
        lv_rowsel_2(80)        TYPE c,
        lv_nameco              TYPE ad_name_co,     "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
        lv_str4                TYPE char40,         "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
        lv_str5                TYPE char40,        "Add:OTCM-58961:NPOLINA:13-Apr-2022:ED2K926818
*- Begin of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
        lv_stceg               TYPE stceg,
        lv_actv_flag_i0230_2_2 TYPE zactive_flag. "Active / Inactive flag
*- End of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
  STATICS: lv_podat(1)       TYPE c,
           lv_email_2(1)     TYPE c,
           lv_email_i(1)     TYPE c,
           li_dxbdcdata_2302 TYPE STANDARD TABLE OF bdcdata,
           lv_sich(1)        TYPE c,
           lv_addr_char(1)   TYPE c,
           lv_docnum_t2      TYPE edi_docnum.

  CONSTANTS:lc_e1edk14_2         TYPE edilsegtyp VALUE 'E1EDK14',
            lc_e1edk03_2         TYPE edilsegtyp VALUE 'E1EDK03',
            lc1_e1edka1_2        TYPE char7      VALUE 'E1EDKA1',
            lc_ze1edp01_2        TYPE char16     VALUE 'Z1QTC_E1EDP01_01',
            lc1_z1qtc_e1edka1_02 TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
            lc_idoc_pa_2         TYPE char30     VALUE '(SAPLVEDA)XVBPA[]',
            lc_e1edk02_2         TYPE edilsegtyp VALUE 'E1EDK02',
            lc_devid2            TYPE zdevid     VALUE 'I0230.2',
            lc_ser_num_i0230_2_2 TYPE zsno       VALUE '002', "Serial Number (002) ""ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
            lc_var_key_i230_2_2  TYPE zvar_key   VALUE 'VAT ID'.  "Varible Key (VAT ID) ""ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
*- Begin of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid2              "Constant value for WRICEF (I0230.2)
      im_ser_num     = lc_ser_num_i0230_2_2   "Serial Number (002)
      im_var_key     = lc_var_key_i230_2_2    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0230_2_2. "Active / Inactive flag
*- End of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
  FIELD-SYMBOLS : <li_xvbpa_2> TYPE tt_vbpavb .

*---Static Variable clearing based on DOCNUM field (IDOC Number).
  READ TABLE didoc_data INTO DATA(lst_edid_fs2) INDEX 1.
  IF sy-subrc = 0 .
    IF lv_docnum_t2 NE lst_edid_fs2-docnum.
      FREE:lv_podat,
           lv_email_2,
           lv_email_i,
           li_dxbdcdata_2302,
           lv_sich,
           lv_addr_char,
           lv_docnum_t2,
           lv_pcard.               " Added by nrmodugu-  ED2K917861 - ERPM-13322
      lv_docnum_t2  = lst_edid_fs2-docnum.
    ENDIF.
  ENDIF.
  IF lv_addr_char IS INITIAL.
    SELECT SINGLE low FROM zcaconstant
      INTO lv_addr_char
      WHERE devid = lc_devid2.
  ENDIF.
* Update PO type
  IF lv_podat IS INITIAL.
    CLEAR:lst_bdcdata_230_2.
    READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_230_2>)  WITH KEY fnam = 'VBKD-BSARK'.
    IF sy-subrc EQ 0.
      lv_tabx_po = sy-tabix.
      READ TABLE didoc_data INTO lst_edidd_230_2 WITH KEY segnam = lc_e1edk14_2
                                                         sdata+0(3) = '013'.
      IF sy-subrc EQ 0.
        lst_e1edk14_2 = lst_edidd_230_2-sdata.
        <lfs_230_2>-fval = lst_e1edk14_2-orgid.
      ENDIF.
* Update PO date
      CLEAR:lst_edidd_230_2.
      READ TABLE didoc_data INTO lst_edidd_230_2 WITH KEY segnam = lc_e1edk03_2
                                                         sdata+0(3) = '022'.
      IF sy-subrc EQ 0.
        lst_e1edk03_2 = lst_edidd_230_2-sdata.
      ELSE.
        lst_e1edk03_2-datum = sy-datum.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_e1edk03_2-datum
        IMPORTING
          output = lv_podate1.

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-fnam = 'VBKD-BSTDK'.
      lst_bdcdata_230_2-fval = lv_podate1.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. "
      INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx_po.
      FREE:li_dxbdcdata.
      lv_podat = abap_true.
    ENDIF.
  ENDIF.              "if lv_podat is INITIAL

* Header Payment Cards
  FREE:li_dxbdcdata[].
  DESCRIBE TABLE dxbdcdata LINES lv_tabx_p.
  READ TABLE dxbdcdata INTO lst_bdcdata_230_2  WITH KEY fnam+0(14) = 'CCDATE-EXDATBI'.
  IF  sy-subrc EQ 0 AND sy-tabix NE lv_tabx_p AND lv_pcard IS INITIAL.
    lv_tabx_p = sy-tabix.
    lv_pcard = abap_true.
    CLEAR:lst_edidd_230_2.
* Read Custom Header Segment for Payment cards Authorized information
    READ TABLE didoc_data INTO lst_edidd_230_2 WITH KEY segnam = lc_ze1edk01.
    IF sy-subrc EQ 0.

      lst_ze1edk01 = lst_edidd_230_2-sdata.

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-program = 'SAPLV60F'.
      lst_bdcdata_230_2-dynpro = '4001'.
      lst_bdcdata_230_2-dynbegin = 'X'.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_230_2. " Clearing work area for BDC data
      lst_bdcdata_230_2-fnam = lc_bok.
      lst_bdcdata_230_2-fval = '/00'.
      APPEND  lst_bdcdata_230_2 TO li_dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-program = 'SAPLV60F'.
      lst_bdcdata_230_2-dynpro = '4001'.
      lst_bdcdata_230_2-dynbegin = 'X'.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_230_2. " Clearing work area for BDC data
      lst_bdcdata_230_2-fnam = lc_bok.
      lst_bdcdata_230_2-fval = '=CCMA'.
      APPEND  lst_bdcdata_230_2 TO li_dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-program = 'SAPLV60F'.
      lst_bdcdata_230_2-dynpro = '0200'.
      lst_bdcdata_230_2-dynbegin = 'X'.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-fnam = 'FPLTC-AUNUM'.
      lst_bdcdata_230_2-fval = lst_ze1edk01-aunum.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " AUth num

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-fnam = 'FPLTC-AUTRA'.
*      lst_bdcdata_230_2-fval = lst_ze1edk01-autra.      "ED2K917118
* Commented to not use AUTRA field for this value
*      lst_bdcdata_230_2-fval = lst_ze1edk01-auth_order_id."ED2K917118 ED2K917187
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. "

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-fnam = 'FPLTC-AUTWR'.
      lst_bdcdata_230_2-fval = lst_ze1edk01-autwr.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " AUth Amount

      CLEAR lst_bdcdata_230_2. " Clearing work area for BDC data
      lst_bdcdata_230_2-fnam = lc_bok.
      lst_bdcdata_230_2-fval = '=BACK'.
      APPEND  lst_bdcdata_230_2 TO li_dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_230_2.
      lst_bdcdata_230_2-program = 'SAPLV60F'.
      lst_bdcdata_230_2-dynpro = '4001'.
      lst_bdcdata_230_2-dynbegin = 'X'.
      APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

      lv_tabx_p = lv_tabx_p + 1.
      INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx_p.
      FREE:li_dxbdcdata.
    ENDIF.
  ENDIF.

* Update License start and End Date
  FREE:li_dxbdcdata[].
  CLEAR:lst_bdcdata_230_2,lv_tabx_l.
  READ TABLE dxbdcdata INTO lst_bdcdata_230_2  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
  IF  sy-subrc EQ 0  AND lv_sich IS INITIAL .
    lv_tabx_l = sy-tabix.
    CLEAR:lst_edidd_230_2.
    READ TABLE didoc_data INTO lst_edidd_230_2 WITH KEY segnam = lc_ze1edp01_2.
    IF sy-subrc EQ 0.
      lst_ze1edp01_2 = lst_edidd_230_2-sdata.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_ze1edp01_2-zzlicense_start_d
        IMPORTING
          output = lv_licstdt.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_ze1edp01_2-zzlicense_end_d
        IMPORTING
          output = lv_licenddt.

      IF lv_licstdt IS NOT INITIAL OR lv_licenddt IS NOT INITIAL.
        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_2-fval = 'T\15'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-program = 'SAPMV45A'.
        lst_bdcdata_230_2-dynpro = '4003'.
        lst_bdcdata_230_2-dynbegin = 'X'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-fnam = 'VBAP-ZZLICSTART'.
        lst_bdcdata_230_2-fval = lv_licstdt.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " Appending Contract Start Date

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-fnam = 'VBAP-ZZLICEND'.
        lst_bdcdata_230_2-fval = lv_licenddt.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " Appending Contract End Date

        CLEAR lst_bdcdata_230_2. " Clearing work area for BDC data
        lst_bdcdata_230_2-fnam = lc_bok.
        lst_bdcdata_230_2-fval = 'BACK'.
        APPEND  lst_bdcdata_230_2 TO li_dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-program = 'SAPMV45A'.
        lst_bdcdata_230_2-dynpro = '4001'.
        lst_bdcdata_230_2-dynbegin = 'X'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_230_2. " Clearing work area for BDC data
        lst_bdcdata_230_2-fnam = lc_bok.
        lst_bdcdata_230_2-fval = 'HEAD'.
        APPEND  lst_bdcdata_230_2 TO li_dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-program = 'SAPLV60F'.
        lst_bdcdata_230_2-dynpro = '4001'.
        lst_bdcdata_230_2-dynbegin = 'X'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
        lst_bdcdata_230_2-fval = 'T\08'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

        CLEAR lst_bdcdata_230_2.
        lst_bdcdata_230_2-program = 'SAPMV45A'.
        lst_bdcdata_230_2-dynpro = '4002'.
        lst_bdcdata_230_2-dynbegin = 'X'.
        APPEND lst_bdcdata_230_2 TO li_dxbdcdata. " appending program and screen

        INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx_l.
        FREE:li_dxbdcdata.
        lv_sich  = abap_true.
      ENDIF.
    ENDIF.
  ENDIF.

* Update Header Partner Email IDS, Address
  CLEAR:lst_bdcdata_230_2,lv_tabx.
  READ TABLE dxbdcdata INTO lst_bdcdata_230_2  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
  IF  sy-subrc = 0 AND  lv_email_2 IS INITIAL AND 1 = 1.
    lv_tabx_2 = sy-tabix.

    ASSIGN (lc_idoc_pa_2) TO <li_xvbpa_2>.

    IF <li_xvbpa_2> IS ASSIGNED .
      lv_email_2 = abap_true.
      LOOP AT didoc_data INTO lst_edidd_230_2 WHERE segnam = lc1_e1edka1_2.
        CLEAR:lv_loop_2,lv_email_id,lv_row_2,lv_nameco,      "NPOLINA OTCM-28180/OTCM-28181
              lv_stceg. "ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
        lv_loop_2 = sy-tabix.
        lv_loop_2 = lv_loop_2 + 1.
        CLEAR:lst1_z1qtc_e1edka1_04,lst_e1edka1_2.
        lst_e1edka1_2 = lst_edidd_230_2-sdata.
        READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_zka2>) WITH KEY segnam = lc1_z1qtc_e1edka1_02
                                                                          sdata+60(2) = lst_e1edka1_2-parvw.
        IF sy-subrc EQ 0.
          READ TABLE <li_xvbpa_2> ASSIGNING FIELD-SYMBOL(<lfs_pa2>) WITH KEY parvw = lst_e1edka1_2-parvw.
          IF sy-subrc EQ 0.
            lv_row_2 = sy-tabix.
            lst1_z1qtc_e1edka1_04 = <lfs_zka2>-sdata.
            lv_email_id = lst1_z1qtc_e1edka1_04-smtp_addr.
            lv_nameco = lst1_z1qtc_e1edka1_04-name_co.        "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
            lv_str4 = lst1_z1qtc_e1edka1_04-str_suppl3.        "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
*-Begin of ADD:OTCM-58961:NPOLINA:13-Apr-2022:ED2K926818
            "Get the value of the 3rd address line into lv_str5.
            lv_str5 = lst1_z1qtc_e1edka1_04-location.
*-End of ADD:OTCM-58961:NPOLINA:13-Apr-2022:ED2K926818
*- Begin of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
            "Populate Sales Tax VAT Number from custom IDOC segment Z1QTC_E1EDKA1_01-STCEG
            IF lv_actv_flag_i0230_2_2 = abap_true.
              IF lst1_z1qtc_e1edka1_04-stceg IS NOT INITIAL.
                lv_stceg  = lst1_z1qtc_e1edka1_04-stceg.
              ENDIF.
            ENDIF.
*- End of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
            CLEAR:lv_rowsel_2.
            CONCATENATE 'GVS_TC_DATA-SELKZ(' lv_row_2 ')' INTO lv_rowsel_2.
            CONDENSE lv_rowsel_2 NO-GAPS.
          ENDIF.
        ELSE.
          CONTINUE.
        ENDIF.

        IF lv_email_id IS NOT INITIAL OR lv_nameco IS NOT INITIAL
                           OR lv_str4 IS NOT INITIAL  "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
                           OR lv_str5 IS NOT INITIAL  "Add:OTCM-58961:NPOLINA:13-Apr-2022:ED2K926818
*                           OR lst_e1edka1_2-strs2 IS NOT INITIAL  "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
           " Checking Sales tax VAT number exists
                           OR lv_stceg IS NOT INITIAL. "ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPMV45A'.
          lst_bdcdata_230_2-dynpro = '4002'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = lv_rowsel_2.
          lst_bdcdata_230_2-fval = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'PSDE'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPLV09C'.
          lst_bdcdata_230_2-dynpro = '5000'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          IF lv_email_id IS NOT INITIAL .  "NPOLINA OTCM-28180/OTCM-28181 ED2K920380
            CLEAR lst_bdcdata_230_2.
            lst_bdcdata_230_2-fnam = 'SZA1_D0100-SMTP_ADDR'.
            lst_bdcdata_230_2-fval = lv_email_id.
            APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

            CLEAR lst_bdcdata_230_2.
            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-DEFLT_COMM'.
            lst_bdcdata_230_2-fval = 'INT'.
            APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
* SOC NPOLINA OTCM-28180/OTCM-28181 ED2K920380
          ENDIF.

          IF  lv_nameco IS NOT INITIAL.
            CLEAR lst_bdcdata_230_2.
*            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-NAME_CO'.    "NPOLINA ED2K922140 24/02/2021
            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-STR_SUPPL2'.  "NPOLINA ED2K922140 24/02/2021
            lst_bdcdata_230_2-fval = lv_nameco.
            APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
            CLEAR:lv_nameco.
          ENDIF.

*          IF  lst_e1edka1_2-strs2 IS NOT INITIAL.
          IF  lv_str4 IS NOT INITIAL.
            CLEAR lst_bdcdata_230_2.
*            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-STR_SUPPL1'.   "NPOLINA ED2K922140 24/02/2021
            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-STR_SUPPL3'.    "NPOLINA ED2K922140 24/02/2021
            lst_bdcdata_230_2-fval = lv_str4.
*            lst_bdcdata_230_2-fval = lst_e1edka1_2-strs2.
            APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
          ENDIF.
*Begin of ADD: OTCM-58961:NPOLINA:13-Apr-2022: ED2K926818
          IF  lv_str5 IS NOT INITIAL.
            CLEAR lst_bdcdata_230_2.
            "Mapping the 3rd address line to Street5(ADDR1_DATA-LOCATION)
            lst_bdcdata_230_2-fnam = 'ADDR1_DATA-LOCATION'.
            lst_bdcdata_230_2-fval = lv_str5.
            APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
          ENDIF."IF  lv_str5 IS NOT INITIAL.
*End of ADD: OTCM-58961:NPOLINA:13-Apr-2022: ED2K926818
*- Begin of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
          IF lv_actv_flag_i0230_2_2 = abap_true.
            " BDC for Sales Tax VAT numer to screen
            IF lv_stceg IS NOT INITIAL.
              CLEAR lst_bdcdata_230_2.
              lst_bdcdata_230_2-fnam = 'GDF_STCEG'.
              lst_bdcdata_230_2-fval = lv_stceg.
              APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
            ENDIF.
          ENDIF.
*- End of ADD:OTCM-27280:SGUDA:30-Dec-2020:ED2K921024
* EOC NPOLINA OTCM-28180/OTCM-28181 ED2K920380

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'ENT1'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPMV45A'.
          lst_bdcdata_230_2-dynpro = '4002'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
        ENDIF.                    " if lv_email1 is not initial
      ENDLOOP.

      INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx_2.
      FREE:li_dxbdcdata.
    ENDIF.

  ENDIF.

* Clearing Address fields which are not filled through IDOC segments
  LOOP AT dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_dxdata3>) WHERE fval = lv_addr_char.
    IF <lfs_dxdata3>-fnam = 'ADDR1_DATA-NAME2' OR <lfs_dxdata3>-fnam = 'ADDR1_DATA-REGION' OR
      <lfs_dxdata3>-fnam = 'ADDR1_DATA-HAUSN' OR      <lfs_dxdata3>-fnam = 'ADDR1_DATA-PSTL2' OR
      <lfs_dxdata3>-fnam = 'ADDR1_DATA-PFACH' OR    <lfs_dxdata3>-fnam = 'SZA1_D0100-TEL_NUMBER' OR
      <lfs_dxdata3>-fnam = 'ADDR1_DATA-POST_CODE2' OR <lfs_dxdata3>-fnam = 'ADDR1_DATA-PO_BOX' OR
      <lfs_dxdata3>-fnam = 'ADDR1_DATA-HOUSE_NUM1' OR
      <lfs_dxdata3>-fnam = 'VBAK-TELF1'.
      CLEAR: <lfs_dxdata3>-fval .
    ENDIF.
  ENDLOOP.

* Update Item Partner Email IDS
  CLEAR:lst_bdcdata_230_2,lv_tabx_2,lv_tabx.
  READ TABLE dxbdcdata INTO lst_bdcdata_230_2  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
  IF  sy-subrc = 0 AND  lv_email_i IS INITIAL AND 1 = 1.
    lv_tabx_2 = sy-tabix.

    ASSIGN (lc_idoc_pa_2) TO <li_xvbpa_2>.

    IF <li_xvbpa_2> IS ASSIGNED .
      lv_email_i = abap_true.
      LOOP AT didoc_data INTO lst_edidd_230_2 WHERE segnam = lc1_e1edka1_2 AND sdata+0(3) NE 'AG'.
        CLEAR:lv_loop_2,lv_email_id,lv_row_2,
              lv_stceg. "OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785
        lv_loop_2 = sy-tabix.
        lv_loop_2 = lv_loop_2 + 1.
        CLEAR:lst1_z1qtc_e1edka1_04,lst_e1edka1_2.
        lst_e1edka1_2 = lst_edidd_230_2-sdata.
        READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_zka2i>) WITH KEY segnam = lc1_z1qtc_e1edka1_02
                                                                          sdata+60(2) = lst_e1edka1_2-parvw.
        IF sy-subrc EQ 0.
          READ TABLE <li_xvbpa_2> ASSIGNING FIELD-SYMBOL(<lfs_pa2i>) WITH KEY parvw = lst_e1edka1_2-parvw.
          IF sy-subrc EQ 0.
            lv_row_2 = sy-tabix.
            lst1_z1qtc_e1edka1_04 = <lfs_zka2i>-sdata.
            lv_email_id = lst1_z1qtc_e1edka1_04-smtp_addr.
*- Begin of ADD:OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785
            "Populate Sales Tax VAT Number from custom IDOC segment Z1QTC_E1EDKA1_01-STCEG
            IF lv_actv_flag_i0230_2_2 = abap_true.
              IF lst1_z1qtc_e1edka1_04-stceg IS NOT INITIAL.
                lv_stceg  = lst1_z1qtc_e1edka1_04-stceg.
              ENDIF.
            ENDIF.
*- End of ADD:OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785
            CLEAR:lv_rowsel_2.
            CONCATENATE 'GVS_TC_DATA-SELKZ(' lv_row_2 ')' INTO lv_rowsel_2.
            DATA(lv_row_selmat) = 'RV45A-VBAP_SELKZ(1)'.
            CONDENSE lv_rowsel_2 NO-GAPS.
          ENDIF.
        ELSE.
          CONTINUE.
        ENDIF.

        IF lv_email_id IS NOT INITIAL
          OR lv_stceg IS NOT INITIAL. "OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'BACK'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPMV45A'.
          lst_bdcdata_230_2-dynpro = '4001'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_CURSOR'.
          lst_bdcdata_230_2-fval = 'VBAP-POSNR(01)'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = lv_row_selmat.
          lst_bdcdata_230_2-fval = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'PPAR_SUB'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPMV45A'.
          lst_bdcdata_230_2-dynpro = '4003'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'PAPO'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = lv_rowsel_2.
          lst_bdcdata_230_2-fval = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'PSDE'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPLV09C'.
          lst_bdcdata_230_2-dynpro = '5000'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

        IF lv_email_id IS NOT INITIAL. "OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785
          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'SZA1_D0100-SMTP_ADDR'.
          lst_bdcdata_230_2-fval = lv_email_id.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'ADDR1_DATA-DEFLT_COMM'.
          lst_bdcdata_230_2-fval = 'INT'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
        ENDIF. "OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785

*- Begin of ADD:OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785
          IF lv_actv_flag_i0230_2_2 = abap_true.
            " BDC for Sales Tax VAT numer to screen
            IF lv_stceg IS NOT INITIAL.
              CLEAR lst_bdcdata_230_2.
              lst_bdcdata_230_2-fnam = 'GDF_STCEG'.
              lst_bdcdata_230_2-fval = lv_stceg.
              APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
            ENDIF.
          ENDIF.
*- End of ADD:OTCM-27280:TDIMANTHA:15-June-2021:ED2K923785

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_2-fval = 'ENT1'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_2.
          lst_bdcdata_230_2-program = 'SAPMV45A'.
          lst_bdcdata_230_2-dynpro = '4003'.
          lst_bdcdata_230_2-dynbegin = 'X'.
          APPEND lst_bdcdata_230_2 TO li_dxbdcdata.
        ENDIF.                    " if lv_email1 is not initial
      ENDLOOP.

      INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx_2.
      FREE:li_dxbdcdata.
    ENDIF.
  ENDIF.
