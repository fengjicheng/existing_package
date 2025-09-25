FUNCTION zqtc_update_mat_master.
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_UPDATE_PR                                 *
* PROGRAM DESCRIPTION : Update Material Master Data                    *
* Update Item Catrgory of material in Material Master
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
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_MATNR) TYPE  MATNR
*"     VALUE(IM_ITM_CAT_GRP) TYPE  MTPOS OPTIONAL
*"     VALUE(IM_GEN_ITM_CAT_GRP) TYPE  MTPOS_MARA OPTIONAL
*"----------------------------------------------------------------------

  DATA: li_headdata    TYPE STANDARD TABLE OF bapie1matheader INITIAL SIZE 0, " Header Segment with Control Information
        li_clientdata  TYPE STANDARD TABLE OF bapie1mara INITIAL SIZE 0,      " Material Data at Client Level
        li_clientdatax TYPE STANDARD TABLE OF bapie1marax INITIAL SIZE 0,     " Checkbox Structure for BAPIE1MARA
        li_salesdata   TYPE STANDARD TABLE OF bapie1mvke INITIAL SIZE 0,      " Sales Data
        li_salesdatax  TYPE STANDARD TABLE OF bapie1mvkex INITIAL SIZE 0,     " Checkbox Structure for BAPIE1MVKE
        li_retdata     TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0.        " Return Parameter

  CONSTANTS : lc_upd          TYPE bapifn     VALUE 'UPD'. " Function of BAPI

  DATA : lst_headdata    TYPE  bapie1matheader, " Header Segment with Control Information
         lst_clientdata  TYPE  bapie1mara ,     " Material Data at Client Level
         lst_clientdatax TYPE  bapie1marax ,    " Checkbox Structure for BAPIE1MARA
         lst_salesdata   TYPE  bapie1mvke,      " Sales Data
         lst_salesdatax  TYPE  bapie1mvkex ,    " Checkbox Structure for BAPIE1MVKE
         lst_bapiret2    TYPE bapiret2.         " Return Parameter

  SELECT matnr, " Material Number
         vkorg, " Sales Organization
         vtweg  " Distribution Channel
   FROM mvke    " Sales Data for Material
   INTO TABLE @DATA(li_mvke)
   WHERE matnr = @im_matnr.
  IF sy-subrc EQ 0.
*  Do nothing
  ENDIF. " IF sy-subrc EQ 0

* Populate Header Data for material
  lst_headdata-function   = lc_upd.
  lst_headdata-material   = im_matnr.
  lst_headdata-basic_view = abap_true.
  lst_headdata-sales_view = abap_true.
  APPEND lst_headdata TO li_headdata.
  CLEAR: lst_headdata.

* Populate Client Data
* General Item Category Group
  lst_clientdata-function   = lc_upd.
  lst_clientdata-material   = im_matnr.
  lst_clientdata-item_cat   = im_gen_itm_cat_grp.
  APPEND lst_clientdata TO li_clientdata.
  CLEAR: lst_clientdata.

  lst_clientdatax-function   = lc_upd.
  lst_clientdatax-material   = im_matnr.
  lst_clientdatax-item_cat   = abap_true.
  APPEND lst_clientdatax TO li_clientdatax.
  CLEAR: lst_clientdata.

* Item Category Group
  LOOP AT li_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>).
    lst_salesdata-function   = lc_upd.
    lst_salesdata-material    = im_matnr.
    lst_salesdata-sales_org   = <lst_mvke>-vkorg.
    lst_salesdata-distr_chan  = <lst_mvke>-vtweg.
    lst_salesdata-item_cat    = im_gen_itm_cat_grp.
    APPEND lst_salesdata TO li_salesdata.
    CLEAR: lst_salesdata.

    lst_salesdatax-function   = lc_upd.
    lst_salesdatax-material    = im_matnr.
    lst_salesdatax-sales_org   = <lst_mvke>-vkorg.
    lst_salesdatax-distr_chan  = <lst_mvke>-vtweg.
    lst_salesdatax-item_cat    = abap_true.
    APPEND lst_salesdatax TO li_salesdatax.
    CLEAR: lst_salesdatax.
  ENDLOOP. " LOOP AT li_mvke ASSIGNING FIELD-SYMBOL(<lst_mvke>)

  CALL FUNCTION 'BAPI_MATERIAL_SAVEREPLICA'
    EXPORTING
      noappllog      = abap_true
      nochangedoc    = space
      testrun        = space
      inpfldcheck    = space
    IMPORTING
      return         = lst_bapiret2
    TABLES
      headdata       = li_headdata
      clientdata     = li_clientdata
      clientdatax    = li_clientdatax
      salesdata      = li_salesdata
      salesdatax     = li_salesdatax
      returnmessages = li_retdata.

ENDFUNCTION.
