*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_E131_SALES_REP_CHG_TOP
* PROGRAM DESCRIPTION:This enhancement will change the sales rep
* after the order has been billed. Individual orders will be manually
* changed, however, mass changes will be allowed through this enhancement.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E131_SALES_REP_CHG_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbeln_vf,             " Billing Document
          fkart TYPE fkart,                " Billing Type
          vkorg TYPE vkorg,                " Sales Organization
          vtweg TYPE vtweg,                " Distribution Channel
          fkdat TYPE fkdat,                " Billing date for billing index and printout
          land1 TYPE lland,                " Country of Destination
          regio TYPE regio,                " Region (State, Province, County)
          kunag TYPE kunag,                " Sold-to party
        END OF ty_vbrk,

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

        BEGIN OF ty_vbrp,
          vbeln TYPE vbeln_vf,             " Billing Document
          posnr TYPE posnr_vf,             " Billing item
          uepos TYPE uepos,                " Billing Higher level Item
          netwr TYPE netwr_fp,             "Billing Item value
          matnr TYPE matnr,                " Material Number
          aubel TYPE vbeln_va,             " Sales Document
          aupos TYPE posnr_va,             " Sales Document Item
        END OF ty_vbrp,

        BEGIN OF ty_vbpa,
          vbeln TYPE vbeln,                " Sales and Distribution Document Number
          posnr TYPE posnr,                " Item number of the SD document
          parvw TYPE parvw,                " Partner Function
          pernr TYPE pernr_d,              " Personnel Number
          adrnr	TYPE adrnr,
        END OF ty_vbpa,

        BEGIN OF ty_final,
          sel,
          vbeln   TYPE vbeln_vf,           " Billing Document
          posnr   TYPE posnr,              " Item number of the SD document
          fkart   TYPE fkart,              " Billing Type
          matnr   TYPE matnr,              " Material Number
          srep1   TYPE pernr_d,            " Standard Selections for HR Master Data Reporting
          srep2   TYPE pernr_d,            " Standard Selections for HR Master Data Reporting
          nsrep1  TYPE zz_persno,          " Standard Selections for HR Master Data Reporting
          nsrep2  TYPE zz_persno,          " Standard Selections for HR Master Data Reporting
          jobname TYPE char70,             " Jobname of type CHAR70
        END OF ty_final,

        BEGIN OF ty_adrc,
          addrnumber TYPE ad_addrnum,      " Address number
          date_from	 TYPE ad_date_fr,      " Valid-from date - in current Release only 00010101 possible
          nation     TYPE  ad_nation,      " Version ID for International Addresses
          post_code1 TYPE ad_pstcd1,       " City postal code
        END OF ty_adrc,

        BEGIN OF ty_vbfa,
          vbelv	  TYPE vbeln_von,          " Preceding sales and distribution document
          posnv	  TYPE posnr_von,          " Preceding item of an SD document
          vbeln   TYPE vbeln_nach,         " Subsequent sales and distribution document
          posnn	  TYPE posnr_nach,         " Subsequent item of an SD document
          vbtyp_n TYPE vbtyp_n,            " Document category of subsequent document
          rfwrt	  TYPE rfwrt,              " Reference value
        END OF ty_vbfa,

        " RTR INC0207762 ED1K908586
        BEGIN OF ty_vbak,
          vbeln TYPE vbeln_va,
          auart TYPE auart,
        END OF ty_vbak,
*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
* Declaration of Range
        tt_fkart_r TYPE RANGE OF fkart,     " Billing Type
        tt_parvw_r TYPE RANGE OF parvw,     " Partner Function
        tt_pernr_r TYPE RANGE OF zz_persno, " Personnel Number
        tt_range_r TYPE RANGE OF char32,   " Range_r type range of type CHAR30
        tt_vbtyv_r TYPE RANGE OF vbtyp_v,   " RTR Range for preceding document
        tt_vbtyn_r TYPE RANGE OF vbtyp_n.   " RTR Range for follow on document type
*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA : i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
       i_vbrp     TYPE STANDARD TABLE OF ty_vbrp     INITIAL SIZE 0,
       i_adrc     TYPE STANDARD TABLE OF ty_adrc     INITIAL SIZE 0,
       i_vbpa     TYPE STANDARD TABLE OF ty_vbpa     INITIAL SIZE 0,
       i_vbrk     TYPE STANDARD TABLE OF ty_vbrk     INITIAL SIZE 0,
       i_vbfa     TYPE STANDARD TABLE OF ty_vbfa     INITIAL SIZE 0, " RTR INC0207762 ED1K908586
       i_vbak     TYPE STANDARD TABLE OF ty_vbak     INITIAL SIZE 0, " RTR INC0207762 ED1K908586
       i_vbfa1    TYPE STANDARD TABLE OF ty_vbfa     INITIAL SIZE 0,
       i_fcat     TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
       i_process  TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0,
       i_final    TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0,
       ir_land    TYPE shp_land1_range_t,
       i_selines  TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0.
*&--------------------------------------------------------------------*
*& V A R I A B L E
*&-------------------------------------------------------------------
DATA :      v_vkorg     TYPE vkorg ,      " Sales Organization
            v_kunnr     TYPE kunnr,       " Customer Number
            v_fkdat     TYPE fkdat,       " Billing date for billing index and printout
            v_auart     TYPE auart,       " Sales Document Type  " RTR INC0207762
            v_bland     LIKE t005s-bland, " Region (State, Province, County)
            v_post_code TYPE pstlz_hr,    " Postal Code
            v_credit    TYPE bapivbeln-vbeln,  " BAPI return variable RTR ERP-7786 Credit memo
            v_debit     TYPE bapivbeln-vbeln,  " BAPI return varibale  RTR ERP-7786 debit memo
            v_debit1    TYPE vbeln.           " Check varibale Debit memo RTR ERP-7786 debit memo
*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS : c_i        TYPE tvarv_sign VALUE 'I',  " I of type CHAR1
            c_eq       TYPE tvarv_opti VALUE 'EQ', " Eq of type CHAR2
            c_parvw_ve TYPE parvw VALUE 'VE',      " Partner Function
            c_parvw_ze TYPE parvw VALUE 'ZE',      " Partner Function
            c_parvw_ag TYPE parvw VALUE 'AG',      " Partner Function
            c_credit   TYPE bapisdhd1-doc_type  VALUE 'ZRPC',   "Credit Memo type  RTR ERP-7786 Credit memo type
            c_debit    TYPE bapisdhd1-doc_type  VALUE 'ZRPD',   " Debit Memo       RTR ERP-7786 Debit  memo type
            c_k        TYPE  vbtyp_v            VALUE  'K',     " Refrence Doc type for VBFA
            c_c        TYPE  vbtyp_v             VALUE  'C',     " Refrence Doc type for VBFA
            c_m        TYPE vbtyp_n             VALUE  'M'.     " Refrence Doc type for VBFA
