FUNCTION zqtc_update_pr.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_EBAN) TYPE  ZTQTC_PURCH_REQUI
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_UPDATE_PR                                 *
* PROGRAM DESCRIPTION : Update Purchase Requisition                    *
* Update Close indicator of Purchase Requisition .
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 22/03/2017                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------

* Type Declaration
  TYPES : BEGIN OF lty_pr_head,
            banfn TYPE banfn,  " Purchase Requisition Number
            bsart TYPE bbsrt,  " Purchase Requisition Document Type
          END OF lty_pr_head,

          BEGIN OF lty_pr_item,
            banfn TYPE banfn,  " Purchase Requisition Number
            bnfpo TYPE  bnfpo, " Item Number of Purchase Requisition
            matnr TYPE matnr,  " Material Number
          END OF lty_pr_item.

* Internal Table Declaration
  DATA :
*        li_bapi_head   TYPE STANDARD TABLE OF bapimereqheader INITIAL SIZE 0,  " Transfer Structure for Enjoy Purchase Req. - Header
*         li_bapi_headx  TYPE STANDARD TABLE OF bapimereqheaderx INITIAL SIZE 0, " Change Parameter for Enjoy Purchase Requisition - Header
         li_bapi_item   TYPE STANDARD TABLE OF bapimereqitemimp INITIAL SIZE 0, " Change Toolbar for Enjoy Purchase Req. - Item
         li_bapi_itemx  TYPE STANDARD TABLE OF bapimereqitemx INITIAL SIZE 0,   " Change Parameter for Enjoy Purchase Requisition - Item Data
         li_pr_head     TYPE STANDARD TABLE OF lty_pr_head INITIAL SIZE 0,
        li_pr_item     TYPE STANDARD TABLE OF lty_pr_item INITIAL SIZE 0,
         li_return      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,         " Return Parameter

* Work Area Declaration
         lst_eban       TYPE zstqtc_purch_requi, " purchase requisition details
         lst_dummy      TYPE zstqtc_purch_requi, " purchase requisition details
         lst_pr_head    TYPE lty_pr_head,
         lst_bapi_head  TYPE bapimereqheader ,   " Transfer Structure for Enjoy Purchase Req. - Header
         lst_bapi_headx TYPE bapimereqheaderx ,  " Change Parameter for Enjoy Purchase Requisition - Header
         lst_bapi_item  TYPE bapimereqitemimp ,  " Change Toolbar for Enjoy Purchase Req. - Item
         lst_bapi_itemx TYPE bapimereqitemx,     " Change Parameter for Enjoy Purchase Requisition - Item Data
         lst_pr_item    TYPE lty_pr_item.

  CLEAR: li_return[].

  SORT im_eban BY banfn bnfpo.


  LOOP AT im_eban INTO lst_eban.
    lst_dummy = lst_eban.
    AT NEW banfn.
      APPEND INITIAL LINE TO li_pr_head ASSIGNING FIELD-SYMBOL(<lst_pr_head>).
      <lst_pr_head>-banfn = lst_dummy-banfn.
      <lst_pr_head>-bsart = lst_dummy-bsart.
    ENDAT.

    APPEND INITIAL LINE TO li_pr_item ASSIGNING FIELD-SYMBOL(<lst_pr_item>).
    <lst_pr_item>-banfn = lst_dummy-banfn.
    <lst_pr_item>-bnfpo = lst_dummy-bnfpo.
    <lst_pr_item>-matnr = lst_dummy-matnr.
  ENDLOOP. " LOOP AT im_eban INTO lst_eban


  LOOP AT li_pr_head ASSIGNING <lst_pr_head>.

* Populate PR Header Data
    lst_bapi_head-preq_no   = <lst_pr_head>-banfn.
    lst_bapi_headx-preq_no  = abap_true.

    lst_bapi_head-pr_type   = <lst_pr_head>-bsart.
    lst_bapi_headx-pr_type  =  abap_true.

* Populate Item Data
    LOOP AT li_pr_item ASSIGNING <lst_pr_item> WHERE banfn = <lst_pr_head>-banfn.

      IF <lst_pr_item>-banfn <> <lst_pr_head>-banfn.
        EXIT.
      ENDIF. " IF <lst_pr_item>-banfn <> <lst_pr_head>-banfn

      lst_bapi_item-preq_item = <lst_pr_item>-bnfpo.
      lst_bapi_itemx-preq_item =  <lst_pr_item>-bnfpo.
      lst_bapi_itemx-preq_itemx =  abap_true.

      lst_bapi_item-material = <lst_pr_item>-matnr.
      lst_bapi_itemx-material =  abap_true.

      lst_bapi_item-closed  = abap_true.
      lst_bapi_itemx-closed =  abap_true.

      APPEND lst_bapi_item TO li_bapi_item.
      CLEAR lst_bapi_item.

      APPEND lst_bapi_itemx TO li_bapi_itemx.
      CLEAR lst_bapi_itemx.

    ENDLOOP. " LOOP AT li_pr_item ASSIGNING <lst_pr_item> WHERE banfn = <lst_pr_head>-banfn

* first unrelease a PR
    CALL FUNCTION 'BAPI_PR_CHANGE'
      EXPORTING
        number  = lst_bapi_head-preq_no
      TABLES
        return  = li_return
        pritem  = li_bapi_item
        pritemx = li_bapi_itemx.

    CLEAR : lst_bapi_head,
            lst_bapi_headx,
            li_return[],
            li_bapi_item[],
            li_bapi_itemx[].

  ENDLOOP. " LOOP AT li_pr_head ASSIGNING <lst_pr_head>

ENDFUNCTION.
