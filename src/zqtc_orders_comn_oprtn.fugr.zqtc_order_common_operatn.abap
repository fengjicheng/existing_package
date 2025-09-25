*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ORDER_COMMON_OPERATN
* PROGRAM DESCRIPTION: Function Module for Orders
* DEVELOPER:  ARABANERJE ; SAYANDAS (SAYANTAN DAS)
* CREATION DATE:   07/02/2017
* OBJECT ID: C064
* TRANSPORT NUMBER(S):  ED2K904419
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
FUNCTION zqtc_order_common_operatn.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DXVBAK) OPTIONAL
*"     VALUE(IM_DVTCOMAG) OPTIONAL
*"     VALUE(IM_DLAST_DYNPRO) OPTIONAL
*"     VALUE(IM_DXMESCOD) LIKE  EDIDC-MESCOD OPTIONAL
*"  TABLES
*"      T_DXBDCDATA STRUCTURE  BDCDATA OPTIONAL
*"      T_DXVBAP OPTIONAL
*"      T_DXVBEP OPTIONAL
*"      T_DYVBEP OPTIONAL
*"      T_DXVBADR OPTIONAL
*"      T_DYVBADR OPTIONAL
*"      T_DXVBPA STRUCTURE  VBPAVB OPTIONAL
*"      T_DXVBUV OPTIONAL
*"      T_DIDOC_DATA STRUCTURE  EDIDD OPTIONAL
*"      T_DXKOMV OPTIONAL
*"      T_DXVEKP OPTIONAL
*"      T_DYVEKP OPTIONAL
*"----------------------------------------------------------------------

*====================================================================*
* L O C A L  I N T E R N A L  T A B L E
*====================================================================*
  DATA:    li_bdcdata           TYPE  tty_bdcdata, " Batch input: New table field structure
           li_item              TYPE  tty_item,
           li_item1             TYPE  tty_item1,
*====================================================================*
* L O C A L  W O R K - A R E A
*====================================================================*
           lst_bdcdata          TYPE bdcdata,          " Batch input: New table field structure
           lst_vbadr            TYPE vbadr,            " Address work area
           lst_item             TYPE ty_item,
           lst_item1            TYPE ty_item1,
           lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
           lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
           lst_didoc_data       TYPE edidd,            " Data record (IDoc)
           lst_e1edk36          TYPE e1edk36,          " IDOC: Doc.header payment cards
           lst_e1edk03          TYPE e1edk03,          " IDoc: Document header date segment
           lst_e1edk02          TYPE e1edk02,          " IDoc: Document header date segment
           lst_e1edp01          TYPE e1edp01,          " IDoc: Document Item General Data
           lst_e1edka1          TYPE e1edka1,          " IDoc: Document Header Partner Information
           lst_e1edp02          TYPE e1edp02,          " IDoc: Document Item Reference Data

*====================================================================*
* L O C A L  V A R I A B L E
*====================================================================*
           lv_fnam              TYPE fnam_____4,             " Field name
           lv_fval              TYPE bdc_fval,               " BDC field value
           lv_tabix             TYPE sytabix,                " Row Index of Internal Tables
           lv_aunum             TYPE char10,                 " Aunum of type CHAR10
           lv_posex             TYPE posnr_va,               " Sales Document Item
           lv_posex1            TYPE posnr_va,               " Sales Document Item
           lv_ihrez             TYPE ihrez,                  " Your Reference
           lv_ihrez_e2          TYPE ihrez_e,                " Ship-to party character
           lv_faksp             TYPE string,
           lv_vbegdatc          TYPE char8,                  " Vbegdatc of type CHAR8
           lv_vbegdat           TYPE d,                      " Vbegdat of type Date
           lv_venddat           TYPE d,                      " Venddat of type Date
           lv_vbegdat1          TYPE dats,                   " Field of type DATS
           lv_venddat1          TYPE dats,                   " Field of type DATS
           lv_date              TYPE d,                      " Date of type Date
           lv_date1             TYPE dats,                   " Field of type DATS
           lv_prd1              TYPE dats,                   " Field of type DATS
           lv_prd               TYPE d,                      " Prd of type Date
           lv_and1              TYPE dats,                   " Field of type DATS
           lv_and               TYPE d,                      " And of type Date
           lv_bnd1              TYPE dats,                   " Field of type DATS
           lv_bnd               TYPE d,                      " Bnd of type Date
           lv_ccins             TYPE ccins,                  " Payment cards: Card type
           lv_zlsch             TYPE char1,                  " Zlsch of type CHAR1
           lv_mvgr3             TYPE mvgr3,                  " Material group 3
           lv_zzsubtyp          TYPE zsubtyp,                " Subscription Type
           lv_contract_flag     TYPE char1 VALUE abap_false. " Contract_flag of type CHAR1


  CONSTANTS : lc_we TYPE parvw VALUE 'WE'. " Partner Function

  CLEAR : li_bdcdata,
          lv_aunum,
          lv_zlsch,
          li_item.

  FIELD-SYMBOLS: <lst_bdcdata> TYPE bdcdata. " Batch input: New table field structure


****Read data from custom segements
  LOOP AT t_didoc_data INTO lst_didoc_data.
    CASE lst_didoc_data-segnam.
      WHEN  c_z1qtc_e1edk01_01. "Header segment : to be populated once for every set of records
        CLEAR: lst_z1qtc_e1edk01_01.
        lst_z1qtc_e1edk01_01 = lst_didoc_data-sdata.
        lv_zlsch          = lst_z1qtc_e1edk01_01-zlsch.
        CLEAR lst_didoc_data.
      WHEN c_e1edka1.
        lst_e1edka1 = lst_didoc_data-sdata.
        IF lst_e1edka1-parvw = lc_we.
          lv_ihrez_e2 = lst_e1edka1-ihrez.
        ENDIF. " IF lst_e1edka1-parvw = lc_we
      WHEN c_e1edk36.
        CLEAR: lst_e1edk36.
        lst_e1edk36 = lst_didoc_data-sdata.
      WHEN  c_e1edp02. "item segment
        CLEAR: lst_e1edp02,
               lst_item.
        lst_e1edp02    = lst_didoc_data-sdata.
        IF lst_e1edp02-qualf = '001'.
          lv_posex1 = lst_e1edp02-zeile.
          lv_ihrez = lst_e1edp02-ihrez.
        ENDIF. " IF lst_e1edp02-qualf = '001'
        IF lst_e1edp02-qualf = '043'.
          lv_contract_flag = abap_true.
        ENDIF. " IF lst_e1edp02-qualf = '043'
      WHEN  c_z1qtc_e1edp01_01. "item segment
        CLEAR:lst_z1qtc_e1edp01_01,
              lst_item.
        lst_z1qtc_e1edp01_01 = lst_didoc_data-sdata.
        lv_posex             = lst_z1qtc_e1edp01_01-vposn.
        lv_vbegdat1           = lst_z1qtc_e1edp01_01-vbegdat.
        lv_venddat1           = lst_z1qtc_e1edp01_01-venddat.
        WRITE lv_vbegdat1 TO lv_vbegdat.
        WRITE lv_venddat1 TO lv_venddat.

        lv_mvgr3 = lst_z1qtc_e1edp01_01-mvgr3.
        lv_zzsubtyp = lst_z1qtc_e1edp01_01-zzsubtyp.

      WHEN c_e1edk03.
        lst_e1edk03 = lst_didoc_data-sdata.
        IF lst_e1edk03-iddat = c_022.
          lv_date1 = lst_e1edk03-datum.
          WRITE lv_date1 TO lv_date.

        ENDIF. " IF lst_e1edk03-iddat = c_022
        IF lst_e1edk03-iddat = c_prd.
          lv_prd1 = lst_e1edk03-datum.
          WRITE lv_prd1 TO lv_prd.
        ENDIF. " IF lst_e1edk03-iddat = c_prd
        IF lst_e1edk03-iddat = c_and.
          lv_and1 = lst_e1edk03-datum.
          WRITE lv_and1 TO lv_and.
        ENDIF. " IF lst_e1edk03-iddat = c_and
        IF lst_e1edk03-iddat = c_bnd.
          lv_bnd1 = lst_e1edk03-datum.
          WRITE lv_bnd1 TO lv_bnd.
        ENDIF. " IF lst_e1edk03-iddat = c_bnd

      WHEN c_e1edk02.
        lst_e1edk02 = lst_didoc_data-sdata.
        IF lst_e1edk02-qualf = '043'.
          lv_contract_flag = abap_true.
        ENDIF. " IF lst_e1edk02-qualf = '043'
      WHEN OTHERS.
*        No Actions
    ENDCASE.

    IF lv_posex1 IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_posex1
        IMPORTING
          output = lv_posex1.

      lst_item1-posex = lv_posex1.
      lst_item1-ihrez = lv_ihrez.
      APPEND lst_item1 TO li_item1.
      CLEAR : lst_item1,
              lv_posex1,
              lv_ihrez.
    ENDIF. " IF lv_posex1 IS NOT INITIAL

    IF  lv_posex  IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_posex
        IMPORTING
          output = lv_posex.

      lst_item-posex = lv_posex.
*      lst_item-faksp = lv_faksp.
      lst_item-vbegdat = lv_vbegdat.
      lst_item-venddat = lv_venddat.
      lst_item-mvgr3 = lv_mvgr3.
      lst_item-zzsubtyp = lv_zzsubtyp.
      APPEND lst_item TO li_item.
      CLEAR: lst_item,
             lv_faksp,
             lv_posex ,
             lv_vbegdat,
             lv_venddat,
             lv_mvgr3,
             lv_zzsubtyp,
             lst_didoc_data.
    ENDIF. " IF lv_posex IS NOT INITIAL
  ENDLOOP. " LOOP AT t_didoc_data INTO lst_didoc_data

  DESCRIBE TABLE t_dxbdcdata LINES lv_tabix.

* Reading BDCDATA table into a work area using last index
  READ TABLE t_dxbdcdata INTO lst_bdcdata INDEX lv_tabix.
  IF sy-subrc = 0.

    IF   lst_bdcdata-fnam = 'BDC_OKCODE'
    AND  lst_bdcdata-fval = 'SICH'.

* If the control is on Item details screen , bring it back to Sales order main screen
      IF im_dlast_dynpro = '4003'.
        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER2'.
        APPEND lst_bdcdata TO li_bdcdata.
      ENDIF. " IF im_dlast_dynpro = '4003'

      IF lv_date IS NOT INITIAL.
        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER1'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-BSTDK'.
        lst_bdcdata-fval = lv_date.
        APPEND lst_bdcdata TO li_bdcdata. " appending Billing Block

        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER2'.
        APPEND lst_bdcdata TO li_bdcdata.
      ENDIF. " IF lv_date IS NOT INITIAL

*** Pricing Date
      IF lv_prd IS NOT INITIAL.

        CLEAR lst_bdcdata. " Clearing work area for BDC data
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KKAU'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-PRSDT'.
        lst_bdcdata-fval = lv_prd.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER2'.
        APPEND lst_bdcdata TO li_bdcdata.

      ENDIF. " IF lv_prd IS NOT INITIAL

      IF lv_and IS NOT INITIAL.
        CLEAR lst_bdcdata. " Clearing work area for BDC data

        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER1'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-ANGDT'.
        lst_bdcdata-fval = lv_and.
        APPEND lst_bdcdata TO li_bdcdata. " appending contract start date

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-BNDDT'.
        lst_bdcdata-fval = lv_bnd.
        APPEND lst_bdcdata TO li_bdcdata. " appending contract end date

      ENDIF. " IF lv_and IS NOT INITIAL
* Payment Method
      IF lv_zlsch IS NOT INITIAL.
*--------------->> Payment Method

        CLEAR lst_bdcdata. " Clearing work area for BDC data
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KBUC'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4002'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-ZLSCH'.
        lst_bdcdata-fval = lv_zlsch.
        APPEND lst_bdcdata TO li_bdcdata.


      ENDIF. " IF lv_zlsch IS NOT INITIAL

      IF lv_ihrez_e2 IS NOT INITIAL.
        CLEAR lst_bdcdata. " Clearing work area for BDC data
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'UER1'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=KBES'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4002'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBKD-IHREZ_E'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-IHREZ_E'.
        lst_bdcdata-fval = lv_ihrez_e2.
        APPEND lst_bdcdata TO li_bdcdata. " Appending Assignment

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen
      ENDIF. " IF lv_ihrez_e2 IS NOT INITIAL
*    ENDIF.
*** EOC by Sayantan Das on 01.05.2016 TR ED2K902885
      CLEAR:  lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND lst_bdcdata TO li_bdcdata.

**** code to update IHREZ
      IF li_item1 IS NOT INITIAL.
        SORT li_item1 BY posex.
        LOOP AT t_dxvbap.
          MOVE-CORRESPONDING t_dxvbap TO wa_xvbap1.
          CLEAR:  lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro  =  '4001'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdata.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = wa_xvbap1-posex
            IMPORTING
              output = wa_xvbap1-posex.

          READ TABLE li_item1 INTO lst_item1 WITH KEY posex = wa_xvbap1-posex BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_item1-ihrez IS NOT INITIAL.
              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'POPO'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '251'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata-fval = wa_xvbap1-posex.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PBES'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4003'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'VBKD-IHREZ'.
              lst_bdcdata-fval = lst_item1-ihrez.
              APPEND lst_bdcdata TO li_bdcdata.


              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '/EBACK'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.
            ENDIF. " IF lst_item1-ihrez IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT t_dxvbap

      ENDIF. " IF li_item1 IS NOT INITIAL
*** code of ihrez
      IF li_item IS NOT INITIAL.

        SORT li_item BY posex.

        LOOP AT t_dxvbap. "INTO wa_xvbap.
          MOVE-CORRESPONDING t_dxvbap TO wa_xvbap.

*************************************************************************
*************Item Additional Data tab population*************************
*************************************************************************

          CLEAR:  lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro  =  '4001'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdata.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = wa_xvbap-posex
            IMPORTING
              output = wa_xvbap-posex.

          READ TABLE li_item INTO lst_item WITH KEY posex = wa_xvbap-posex BINARY SEARCH.
          IF sy-subrc = 0.

            IF lst_item-zzsubtyp IS NOT INITIAL.
              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'POPO'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '251'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata-fval = wa_xvbap-posex.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PZKU'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4003'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'VBAP-ZZSUBTYP'.
              lst_bdcdata-fval = lst_item-zzsubtyp.
              APPEND lst_bdcdata TO li_bdcdata.


              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '/EBACK'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

            ENDIF. " IF lst_item-zzsubtyp IS NOT INITIAL


            lv_vbegdatc = lst_item-vbegdat.

            IF NOT lv_vbegdatc IS INITIAL.
* Choose item
              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'POPO'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '251'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata-fval = wa_xvbap-posex.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PVER'.
              APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPLV45W'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
              lst_bdcdata-fval = lst_item-vbegdat.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'VEDA-VENDDAT'.
              lst_bdcdata-fval = lst_item-venddat.
              APPEND lst_bdcdata TO li_bdcdata.

              IF lst_item-vbelkue IS NOT INITIAL.
                CLEAR: lst_bdcdata.
                lst_bdcdata-fnam = 'VEDA-VBELKUE'.
                lst_bdcdata-fval = lst_item-vbelkue.
                APPEND lst_bdcdata TO li_bdcdata.
              ENDIF. " IF lst_item-vbelkue IS NOT INITIAL

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '=S\BACK'.
              APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

            ENDIF. " IF NOT lv_vbegdatc IS INITIAL

            CLEAR:  lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_OKCODE'.
            lst_bdcdata-fval = 'UER2'.
            APPEND lst_bdcdata TO li_bdcdata.
          ENDIF. " IF sy-subrc = 0
*- Dynpro-field name --------------------------------------------------*
*- contents -----------------------------------------------------------*
          APPEND lst_bdcdata TO li_bdcdata.
        ENDLOOP. " LOOP AT t_dxvbap

      ENDIF. " IF li_item IS NOT INITIAL
      DESCRIBE TABLE t_dxbdcdata LINES lv_tabix.
******************    added to remove fm  **********
      IF lv_contract_flag = abap_false.

        READ TABLE t_dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
        IF <lst_bdcdata> IS ASSIGNED.
          <lst_bdcdata>-fval = 'OWN_OKCODE'.
        ENDIF. " IF <lst_bdcdata> IS ASSIGNED
      ENDIF. " IF lv_contract_flag = abap_false
****************************************************
      INSERT LINES OF li_bdcdata INTO t_dxbdcdata INDEX lv_tabix.

    ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

    IF   lst_bdcdata-fnam = 'BDC_OKCODE'
   AND lst_bdcdata-fval = 'OWN_OKCODE'.

      DESCRIBE TABLE t_dxbdcdata LINES lv_tabix.
      READ TABLE t_dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
      IF <lst_bdcdata> IS ASSIGNED.
        <lst_bdcdata>-fval = 'SICH'.

      ENDIF. " IF <lst_bdcdata> IS ASSIGNED

    ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'
  ENDIF. " IF sy-subrc = 0
ENDFUNCTION.
