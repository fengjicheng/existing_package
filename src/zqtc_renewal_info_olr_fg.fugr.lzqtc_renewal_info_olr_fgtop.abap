FUNCTION-POOL zqtc_renewal_info_olr_fg.   "MESSAGE-ID ..
*----------------------------------------------------------------------
* PROGRAM NAME        : LZQTC_RENEWAL_INFO_OLR_FGTOP
* PROGRAM DESCRIPTION : Subscription Renewal Information
* DEVELOPER           : Shubhanjali Sharma
* CREATION DATE       : 1/11/2017
* OBJECT ID           : I0337
* TRANSPORT NUMBER(S) : ED2K900927
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K906171, ED2K906173, ED2K906224, ED2K906258
* REFERENCE NO: JIRA Defect ERP-2160
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE: 17-May-2017
* DESCRIPTION: Tax amounts are not summing up correctly. The issue was due
* to not picking up all the entries from KONV when for all entries is used.
* To correct the same passed the full primary key in the select. Also to
* correct the population logic for Ismpubltype2.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906697
* REFERENCE NO: JIRA Defect ERP-2730
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 02-Jun-2017
* DESCRIPTION: As JKSESCHED will not update for Media issues and SAP confirmed
*              thats JKSESCHED is updated only for subscription but not quotes.
*              Hence we have changed the logic to rerieve from JKSENIP table
*              to get the number of issues and also numbers of orders created.
*              Contract start dates and end dates are taken from quotation as
*              subscription has the previous year dates.
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913244
* REFERENCE NO: ERP- 7316
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         31-Aug-2018
* DESCRIPTION:  Society name (NAME1,NAME2,NAME3 and NAME4) needs to
*               display in full on email renewal and OLR web landing page
*----------------------------------------------------------------------*
* INCLUDE LZQTC_RENEWAL_INFO_OLR_FG...    " Local class definition
*&---------------------------------------------------------------------*

*Type Declaration
TYPES:

* Structure Declaration for Address Details
  BEGIN OF ty_adrc,
    addrnumber TYPE ad_addrnum, "Address number
    name1      TYPE ad_name1,   "Name1
*  egin of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
    name2      TYPE ad_name2,   "Name2
    name3      TYPE ad_name3,   "Name3
    name4      TYPE ad_name4,   "Name4
*  End of ADD:ERP-7316:SGUDA:31-AUG-2018:ED2K913244
    street     TYPE ad_street,  "Street
    house_num1 TYPE ad_hsnm1,   "House Number1
    city1      TYPE city,       "City
    region     TYPE regio,      "Region
    post_code1 TYPE ad_pstcd1,  "Post Code1
    country    TYPE land1,      "Country
  END OF ty_adrc,

* Structure Declaration for Partner Details
  BEGIN OF ty_vbpa,
    vbeln TYPE vbeln,      "Sales and Distribution Document Number
    posnr TYPE posnr,      "Item number of the SD document
    parvw TYPE parvw,      "Partner Function
    adrnr TYPE adrnr,      "Address Number
    kunnr TYPE kunnr,
  END OF ty_vbpa,

* Structure to fetch Copy Number per material
  BEGIN OF ty_mara,
    matnr       TYPE matnr,         "Material
    ismcopynr   TYPE ismheftnummer, "Copy Number
    ismnrinyear TYPE ismnrimjahr,   " Issue Number  " Insert on 18-Jul-2017 by PBANDLAPAL for ERP-2730
  END OF ty_mara,

* Structure to Fetch Condition Details per Condition Type and Item
  BEGIN OF ty_konv,
    knumv TYPE knumv,         "Number of the document condition
    kposn TYPE kposn,         "Item number of the SD document
    kntyp TYPE kntyp,         "Condition category
* BOC by PBANDLAPAL on 05-May-2017 for ERP-2160
    stunr TYPE stunr,
    zaehk TYPE dzaehk,
* EOC by PBANDLAPAL on 05-May-2017 for ERP-2160
    kwert TYPE kwert,         "Condition Value
  END OF ty_konv,

* Structure to fetch Issue details from JKSESCHED
  BEGIN OF ty_jkses,
    vbeln          TYPE vbeln,           "Sales and Distribution Document Number
    posnr	         TYPE posnr,           "Item number of the SD document
    issue          TYPE ismmatnr_issue , "Media Issue
    product        TYPE ismmatnr_product, "Media Product
    sequence       TYPE jmsequence  ,    "IS-M: Sequence
    xorder_created TYPE jmorder_created, "IS-M: Indicator Denoting that Order Was Generated
  END OF ty_jkses,

* Begin of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
  BEGIN OF ty_jksenip,
    product       TYPE ismmatnr_product, "Media Product
    issue         TYPE ismmatnr_issue ,  "Media Issue
    shipping_date TYPE jshipping_date,  "Delivery Date
    status        TYPE jnipstatus,       "Status
  END OF ty_jksenip,

  BEGIN OF ty_mvke,
    matnr TYPE matnr,     "Media Issue
    dwerk TYPE dwerk_ext, "Delivering Plant
  END OF ty_mvke,

  BEGIN OF ty_marc,
    matnr            TYPE matnr,    " Media Issue
    werks            TYPE werks_d,  " Plant
    ismarrivaldateac TYPE ismanlftagi,
  END OF ty_marc,

  BEGIN OF ty_veda_qt,
    vbeln   TYPE  vbeln_va,
    vposn   TYPE  posnr_va,
    vbegdat TYPE vbdat_veda,
    venddat TYPE vedat_veda,
  END OF ty_veda_qt,

  BEGIN OF ty_cntrct_dat_qt,
    sign   TYPE sign,
    option TYPE option,
    low    TYPE  vbdat_veda,
    high   TYPE  vedat_veda,
  END OF ty_cntrct_dat_qt,
* End of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730

  BEGIN OF ty_constant,
    devid  TYPE zdevid,              " Development ID
    param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
    param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
    srno   TYPE tvarv_numb,          " ABAP: Current selection number
    sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
    opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
    low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
    high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
  END OF ty_constant,

* Table Type Declaration
  tt_adrc     TYPE STANDARD TABLE OF ty_adrc  INITIAL SIZE 0,
  tt_mara     TYPE STANDARD TABLE OF ty_mara  INITIAL SIZE 0,
  tt_vbpa     TYPE STANDARD TABLE OF ty_vbpa  INITIAL SIZE 0,
  tt_konv     TYPE STANDARD TABLE OF ty_konv  INITIAL SIZE 0,
  tt_jkses    TYPE STANDARD TABLE OF ty_jkses INITIAL SIZE 0,
  tt_constant TYPE STANDARD TABLE OF ty_constant
                    INITIAL SIZE 0.

* Constants Declaration
CONSTANTS: c_char_s    TYPE char1 VALUE 'S',
* Begin of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730
           c_sign_i    TYPE sign VALUE 'I',
           c_option_bt TYPE option VALUE 'BT',
           c_stats_04  TYPE jnipstatus VALUE '04',
           c_stats_10  TYPE jnipstatus VALUE '10'.
* End of Insert on 18-JuL-2017 by PBANDLAPAL for ERP-2730

*&---------------------------------------------------------------------*
*&       Class lclsubscription_renewal_info
*&---------------------------------------------------------------------*
*        Local Class for methods holding subscription renewal methods
*----------------------------------------------------------------------*
CLASS lclsubscription_renewal_info DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS:

*     Method to fetch data and populate the exporting table
      meth_fetch_data IMPORTING im_quoteid      TYPE vbeln_va
                      EXPORTING ex_data_tab     TYPE ztqtc_subscrptn_renewal_info
                                ex_t_return_msg TYPE ztqtc_retmsg
                      CHANGING  ch_constant     TYPE tt_constant,

*     Method to send email as error notification
      meth_send_email IMPORTING im_t_error      TYPE ztqtc_retmsg
                                im_constant     TYPE tt_constant
                      CHANGING  ex_t_return_msg TYPE ztqtc_retmsg.

ENDCLASS.
