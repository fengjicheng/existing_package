*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SAP_CWS_SHPD_FROM_TOP (Include Program)
* PROGRAM DESCRIPTION: For print media at Wiley, all journals are initially
* shipped directly from a third party distributor, therefore the distributor
* address will be used. The distributor for each journal will be designated
* as the fixed vendor on the source list. From the source list we will pull
* the fixed vendor and send the address of the vendor as the “ship-from”
* for that product.
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   02/08/2017
* OBJECT ID:  I0322
* TRANSPORT NUMBER(S):  ED2K904348
*----------------------------------------------------------------------*
*====================================================================*
* Structure
*====================================================================*
TYPES: BEGIN OF ty_zcaint,
         mandt  TYPE mandt,                       " Client
         devid  TYPE zdevid,                      " Development ID
         param1	TYPE rvari_vnam,                  " Name of Variant Variable
         param2	TYPE rvari_vnam,                  " Name of Variant Variable
         lrdat  TYPE zlrdat,                      " Last run date
         lrtime	TYPE zlrtime,                     " Last run time
       END OF ty_zcaint,
* Begin of Insert Defect 2029
       BEGIN OF ty_obj_dtls,
         matnr TYPE matnr,                        " Material Number
         werks TYPE ewerk,                        " Plant Table for National (Centrally Agreed) Contracts
         zeord TYPE dzeord,                       " Number of Source List Record
       END OF ty_obj_dtls,
* End of Insert Defect 2029
       BEGIN OF ty_eord_ph,
         matnr TYPE matnr,                        " Material Number
         werks TYPE ewerk,                      " Plant Table for National (Centrally Agreed) Contracts
         lifnr TYPE lifnr,                        " Account Number of Vendor or Creditor
         bwkey TYPE bwkey,                        " Valuation Area
       END OF ty_eord_ph,

       BEGIN OF ty_ph_fin,
         matnr        TYPE matnr,                 " Material Number
         mtart        TYPE mtart,                 " Material Type
         ismrefmdprod TYPE ismrefmdprod,          " Higher-Level Media Product
         ismmediatype TYPE ismmediatype,
         ismpubldate  TYPE ismpubldate,           " Publication Date
       END OF ty_ph_fin,

       BEGIN OF ty_adrc_ph,
         addrnumber TYPE ad_addrnum,              " Address number
         city1      TYPE ad_city1,                " City
         post_code1 TYPE ad_pstcd1,               " City postal code
         country    TYPE land1,                   " Country Key
         region     TYPE regio,                   " Region (State, Province, County)
       END OF ty_adrc_ph,

       BEGIN OF ty_lfa1_ph,
         lifnr TYPE lifnr,                        " Account Number of Vendor or Creditor
         adrnr TYPE adrnr,                        " Address
       END OF ty_lfa1_ph,

       BEGIN OF ty_issn,
         matnr      TYPE matnr,                   " Material Number
         idcodetype TYPE ismidcodetype,           " identification Type
         identcode  TYPE ismidentcode,            " Identification Code
       END OF ty_issn,

       BEGIN OF ty_bezei,
         land1 TYPE land1,                        " Country Key
         bland TYPE regio,                        " Region (State, Province, County)
         bezei TYPE bezei20,                      " Description
       END OF ty_bezei,

       BEGIN OF ty_ph_crt,
         matnr        TYPE matnr,                 " Material Number
         ismrefmdprod TYPE ismrefmdprod,          " Higher-Level Media Product
         ismmediatype TYPE ismmediatype,          " Media Type
         ismpubldate  TYPE ismpubldate,           " Publication Date
       END OF ty_ph_crt,

       ty_datum   TYPE  /grcpi/gria_s_date_range, " Date Range

       ty_uzeit   TYPE mcw_rangeuzeit,            " Range Table for Time
*====================================================================*
* Table Type
*====================================================================*
       tt_datum   TYPE /grcpi/gria_t_date_range,

       tt_uzeit   TYPE STANDARD TABLE OF mcw_rangeuzeit INITIAL SIZE 0, " Range Table for Time

       tt_eord_ph TYPE STANDARD TABLE OF ty_eord_ph INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS matnr werks lifnr,

       tt_ph_fin  TYPE STANDARD TABLE OF ty_ph_fin INITIAL SIZE 0,

       tt_adrc_ph TYPE STANDARD TABLE OF ty_adrc_ph INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS addrnumber,

       tt_lfa1_ph TYPE STANDARD TABLE OF ty_lfa1_ph INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS lifnr adrnr,

       tt_issn    TYPE STANDARD TABLE OF ty_issn INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS matnr,

       tt_bezei   TYPE STANDARD TABLE OF ty_bezei INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS land1 bland bezei,

       tt_ph_crt  TYPE STANDARD TABLE OF ty_ph_crt INITIAL SIZE 0
                 WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS matnr.

*====================================================================*
* Internal Table
*====================================================================*
DATA :   i_date_range    TYPE tt_datum,                               " Int Table for DATE
         i_uzeit         TYPE tt_uzeit,                               " Int Table for TIME
         i_idoc_control  TYPE STANDARD TABLE OF edidc INITIAL SIZE 0, " Control record (IDoc)
         i_edidd         TYPE STANDARD TABLE OF edidd INITIAL SIZE 0, " Data record (IDoc)
*====================================================================*
* Work-Area
*====================================================================*
         st_edidc        TYPE edidc,         " Control record (IDoc)
         st_edidd        TYPE edidd,         " Data record (IDoc)
         st_idoc_control TYPE edidc,         " Control record (IDoc)
         st_shpd_cws     TYPE z1qtc_sap_cws, " Custom seg for Shipped-From data to society website (CWS)
*====================================================================*
* Variable
*====================================================================*
         v_flag          TYPE abap_bool,
         v_datum         TYPE sydatum, " System Date
         v_uzeit         TYPE syuzeit, " System Time
         v_idoc_prc      TYPE char1.   " Idoc Processed
*====================================================================*
* Constants
*====================================================================*
CONSTANTS :  c_scope_enq TYPE c          VALUE '2',                   " Scope : 2 used for Enqueue
             c_scope_deq TYPE c          VALUE '3',                   " Scope : 3 used for Dequeue
             c_ls        TYPE edi_rcvprt VALUE 'LS',                  " Partner Type of Receiver
             c_devid     TYPE zdevid     VALUE 'I0322',               " Development ID
             c_sign      TYPE tvarv_sign VALUE 'I',                   " ABAP: ID: I/E (include/exclude values)
             c_opti_bt   TYPE tvarv_opti VALUE 'BT',                  " ABAP: Selection option (EQ/BT/CP/...)
             c_msgtyp    TYPE edi_mestyp VALUE 'ZQTC_SHIPD_DATA_WEB', " Message Type
             c_idoctp    TYPE edi_idoctp VALUE 'ZQTCB_SAP_CWS01',     " Basic type
             c_segtyp    TYPE edilsegtyp VALUE 'Z1QTC_SAP_CWS',       " Segment type
             c_ca        TYPE land1      VALUE 'CA'.                  " Country Key
