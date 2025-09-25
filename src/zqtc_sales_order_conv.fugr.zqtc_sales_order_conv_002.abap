*----------------------------------------------------------------------*
* PROGRAM NAME: SAPLZQTC_SALES_ORDER_CONV (Sales Order Conversion)
* PROGRAM DESCRIPTION: Function Module for Sales Order Conversion
* DEVELOPER: Swagata Mukherjee (SWMUKHERJE)
* CREATION DATE:   05/10/2016
* OBJECT ID: C042
* TRANSPORT NUMBER(S):  ED2K902885
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
FUNCTION zqtc_sales_order_conv_002.
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
*====================================================================*
* L O C A L  W O R K - A R E A
*====================================================================*
           lst_bdcdata          TYPE bdcdata,          " Batch input: New table field structure
           lst_item             TYPE ty_item,
           lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
           lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
           lst_didoc_data       TYPE edidd,            " Data record (IDoc)
           lst_e1edk36          TYPE e1edk36,          " IDOC: Doc.header payment cards
           lst_e1edk03          TYPE e1edk03,          " IDoc: Document header date segment
           lst_e1edp01          TYPE e1edp01,          " IDoc: Document Item General Data

*====================================================================*
* L O C A L  V A R I A B L E
*====================================================================*
           lv_fnam              TYPE fnam_____4, " Field name
           lv_tabix             TYPE sytabix,    " Row Index of Internal Tables
           lv_aunum             TYPE char10,     " Aunum of type CHAR10
           lv_posex             TYPE string,
           lv_faksp             TYPE string,
           lv_vbegdat           TYPE d,          " Vbegdat of type Date
           lv_venddat           TYPE d,          " Venddat of type Date
           lv_vbegdat1          TYPE dats,       " Field of type DATS
           lv_venddat1          TYPE dats,       " Field of type DATS
           lv_date              TYPE d,          " Date of type Date
           lv_date1             TYPE dats,       " Field of type DATS
           lv_ccins             TYPE ccins,      " Payment cards: Card type
           lv_zlsch             TYPE char1.     " Zlsch of type CHAR1


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
        lv_aunum          = lst_z1qtc_e1edk01_01-aunum.
        lv_zlsch          = lst_z1qtc_e1edk01_01-zlsch.
        CLEAR lst_didoc_data.
      WHEN c_e1edk36.
        CLEAR: lst_e1edk36.
        lst_e1edk36 = lst_didoc_data-sdata.
        lv_ccins = lst_e1edk36-ccins.
      WHEN  c_e1edp01. "item segment
        CLEAR: lst_e1edp01,
               lst_item.
        lst_e1edp01    = lst_didoc_data-sdata.
*        lv_posex       = lst_e1edp01-posex.
      WHEN  c_z1qtc_e1edp01_01. "item segment
        CLEAR:lst_z1qtc_e1edp01_01,
              lst_item,
              lv_faksp.
        lst_z1qtc_e1edp01_01 = lst_didoc_data-sdata.
        lv_posex             = lst_z1qtc_e1edp01_01-vposn.
        lv_faksp             = lst_z1qtc_e1edp01_01-faksp.
        lv_vbegdat1           = lst_z1qtc_e1edp01_01-vbegdat.
        lv_venddat1           = lst_z1qtc_e1edp01_01-venddat.
        WRITE lv_vbegdat1 TO lv_vbegdat.
        WRITE lv_venddat1 TO lv_venddat.

      WHEN c_e1edk03.
        lst_e1edk03 = lst_didoc_data-sdata.
        IF lst_e1edk03-iddat = c_022.
          lv_date1 = lst_e1edk03-datum.
          WRITE lv_date1 TO lv_date.
*          EXIT.
        ENDIF. " IF lst_e1edk03-iddat = c_022
      WHEN OTHERS.
*        No Actions
    ENDCASE.
    IF  lv_posex  IS NOT INITIAL.
*    AND lv_faksp  IS NOT INITIAL.
      lst_item-posex = lv_posex.
      lst_item-faksp = lv_faksp.
      lst_item-vbegdat = lv_vbegdat.
      lst_item-venddat = lv_venddat.
      APPEND lst_item TO li_item.
      CLEAR: lst_item,
             lv_faksp,
             lv_posex ,
             lv_vbegdat,
             lv_venddat,
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

      IF lv_ccins IS NOT INITIAL.


        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KRPL'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'FPLTD-SELKZ(01)'.
        lst_bdcdata-fval ='X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=CCMA'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '0200'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'FPLTC-AUNUM'.
        lst_bdcdata-fval = lv_aunum.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=BACK'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.


        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=S\BACK'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KBUC'.
        APPEND lst_bdcdata TO li_bdcdata.

*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=T\07'.
*      APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4002'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-ZLSCH'.
        lst_bdcdata-fval = lv_zlsch.
        APPEND lst_bdcdata TO li_bdcdata.
*** BOC by Sayantan Das on 01.05.2016 TR ED2K902885
      ELSE. " ELSE -> IF lv_ccins IS NOT INITIAL

* When Payment card type is blank the the following code will be
* triggered to update Payment Method
        IF lv_zlsch IS NOT INITIAL.
*        CLEAR lst_bdcdata. " Clearing work area for BDC data
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'KKAU'.
*        APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4002'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO li_bdcdata. " appending program and screen

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
      ENDIF. " IF lv_ccins IS NOT INITIAL
*** EOC by Sayantan Das on 01.05.2016 TR ED2K902885
      CLEAR:  lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND lst_bdcdata TO li_bdcdata.

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

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = wa_xvbap-posex
            IMPORTING
              output = wa_xvbap-posex.



          READ TABLE li_item INTO lst_item WITH KEY posex = wa_xvbap-posex BINARY SEARCH.
          IF sy-subrc = 0.
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

*          CLEAR:  lst_bdcdata.
*          lst_bdcdata-fnam = 'BDC_OKCODE'.
*          lst_bdcdata-fval = 'UER2'.
*          APPEND lst_bdcdata TO li_bdcdata.

            CLEAR:  lst_bdcdata.
            lst_bdcdata-fnam = 'BDC_OKCODE'.
            lst_bdcdata-fval = 'PDE3'.
            APPEND lst_bdcdata TO li_bdcdata.

            CLEAR:  lst_bdcdata.
            lst_bdcdata-program = 'SAPMV45A'.
            lst_bdcdata-dynpro  =  '4003'.
            lst_bdcdata-dynbegin   = 'X'.
            APPEND lst_bdcdata TO li_bdcdata.

            CLEAR:  lst_bdcdata.
            lst_bdcdata-fnam = 'VBAP-FAKSP'.
            lst_bdcdata-fval = lst_item-faksp.
            APPEND lst_bdcdata TO li_bdcdata.

            IF lst_item-vbegdat IS NOT INITIAL.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'UER1'.
              APPEND lst_bdcdata TO li_bdcdata.

              CLEAR lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro = '4001'.
              lst_bdcdata-dynbegin = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

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

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '=S\BACK'.
              APPEND  lst_bdcdata TO li_bdcdata. "appending OKCODE

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata.

            ENDIF. " IF lst_item-vbegdat IS NOT INITIAL

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
      READ TABLE t_dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
      IF <lst_bdcdata> IS ASSIGNED.
        <lst_bdcdata>-fval = 'OWN_OKCODE'.
      ENDIF. " IF <lst_bdcdata> IS ASSIGNED
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
*      CLEAR lst_bdcdata.
*      lst_bdcdata-program = 'SAPLSPO2'.
*      lst_bdcdata-dynpro = '0101'.
*      lst_bdcdata-dynbegin = 'X'.
*      APPEND lst_bdcdata TO t_dxbdcdata.
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=OPT1'.
*      APPEND lst_bdcdata TO  t_dxbdcdata.

*    ENDIF. " IF <lst_bdcdata> IS ASSIGNED

    ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'
  ENDIF. " IF sy-subrc = 0
ENDFUNCTION.
