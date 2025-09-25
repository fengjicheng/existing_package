*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ENTITLEMENT_STATUS_I0318
* PROGRAM DESCRIPTION: FM to update Entitlement Status
* DEVELOPER: Paramita Bose
* CREATION DATE: 12/12/2016
* OBJECT ID: I0318
* TRANSPORT NUMBER(S): ED2K903833
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K906768
* REFERENCE NO: JIRA Defect ERP-2837
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 16-Jun-2017
* DESCRIPTION: Added application logs to make sure we will have a tracking.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K909276
* REFERENCE NO: ERP-4934
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 01-Nov-2017
* DESCRIPTION: To increase the length of field CUSTOMER_ID(EAL Number) to
*              char50 as legacy is sending bigger texts.
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910736
* REFERENCE NO: ERP-6918
* DEVELOPER: Himanshu Patel
* DATE: 02/09/2018
* DESCRIPTION: New FM added ZQTC_ENTITLEMENT_IDOC_I0318 in same Function
*              group which will be process Idoc for Subscription Order change
*              so all global data added in this top include
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_entitlmnt_status_fg. "MESSAGE-ID ..

* INCLUDE LZQTC_ENTITLMNT_STATUS_FGD...      " Local class definition

TYPES :
* Structure for VBKD table
  BEGIN OF ty_vbkd,
    vbeln TYPE vbeln, " Sales and Distribution Document Number
    posnr TYPE posnr, " Item number of the SD document
    ihrez TYPE ihrez, " Your Reference
  END OF ty_vbkd,

* Structure for final table
  BEGIN OF ty_entitle_status,
    vbeln              TYPE vbeln,      " Sales and Distribution Document Number
    posnr              TYPE posnr,      " Item number of the SD document
    fulfillment_id     TYPE ihrez,      " Your Reference
* BOC by PBNADLAPAL on 01-Nov-2017 for ERP-4934: TR#ED2K909276
*    customer_id        TYPE char16,     " Id of type CHAR16
    customer_id        TYPE char50,     " Id of type CHAR16
* EOC by PBNADLAPAL on 01-Nov-2017 for ERP-4934: TR#ED2K909276
    licence_start_date TYPE vadat_veda, " Agreement acceptance date
  END OF ty_entitle_status,

* Structure Declaration for VBAK table
  BEGIN OF ty_vbak,
    vbeln TYPE vbeln_va, " Sales Document
    vkorg TYPE vkorg,    " Sales Organization
    vtweg TYPE vtweg,    " Distribution Channel
    spart TYPE spart,    " Division
  END OF ty_vbak,

* Structure Declaration for VBAK table
  BEGIN OF ty_vbap,
    vbeln TYPE vbeln_va, " Sales Document
    posnr TYPE posnr_va, " Sales Document Item
    matnr TYPE matnr,    " Material Number
    pstyv TYPE pstyv,    " Sales document item category
    zmeng TYPE dzmeng,   " Target quantity in sales units
    mvgr3 TYPE mvgr3,    " Material group3  " Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
  END OF ty_vbap,

* Structure Declaration for VEDA table
  BEGIN OF ty_veda,
    vbeln   TYPE vbeln_va,   " Sales Document
    vposn   TYPE posnr_va,   " Sales Document Item
    vabndat TYPE vadat_veda, " Agreement acceptance date
  END OF ty_veda.

* Table type declaration
TYPES : tt_contract     TYPE STANDARD TABLE OF bapisditm  INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
        tt_agr_date     TYPE STANDARD TABLE OF bapictr    INITIAL SIZE 0, " Communciation Fields: SD Contract Data
        tt_agr_date_ind TYPE STANDARD TABLE OF bapictrx   INITIAL SIZE 0, " Communication fields: SD Contract Data Checkbox
        tt_text         TYPE STANDARD TABLE OF bapisdtext INITIAL SIZE 0, " Communication fields: SD texts
        tt_return       TYPE STANDARD TABLE OF bapiret2   INITIAL SIZE 0, " Return Parameter
        tt_cond_ind     TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0. " Communication Fields: Sales and Distribution Document Item

* Data Declaration
DATA : i_vbap         TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0, " Internal table for Sales Item
       i_veda         TYPE STANDARD TABLE OF ty_veda INITIAL SIZE 0, " Internal table for VEDA
       i_vbak         TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0, " Internal table for Sales header
       i_contract     TYPE tt_contract,                              " Internal table for Contract
       i_text         TYPE tt_text,                                  " Internal table for text
       i_cond_ind     TYPE tt_cond_ind,                              " Internal table for contract indicator
       i_agr_date     TYPE tt_agr_date,                              " Internal table for agreement date
       i_agr_date_ind TYPE tt_agr_date_ind,                          " Internal table for agreement date indicator
* Begin of Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
       i_zcacons_ent  TYPE zcat_constants,   " Internal table for ZCACONSTANT entries
       r_mat_grp3_zca TYPE efg_tab_ranges,   " Range for Material Group3
* End of Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
       v_log_handle   TYPE balloghndl,                               " "Application Log: Log Handle
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
       st_header_data TYPE bapisdh1,                                 " Communication Fields: SD Order Header
       st_header_ind  TYPE bapisdh1x.                                " Checkbox List: SD Order Header

* Constant Declaration
CONSTANTS : c_upd           TYPE updkz_d    VALUE 'U',    " Update indicator
            c_textid        TYPE tdid       VALUE '0012', " Text ID
            c_inf           TYPE bapi_mtype VALUE 'I',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_err           TYPE bapi_mtype VALUE 'E',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_abt           TYPE bapi_mtype VALUE 'A',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_064           TYPE symsgno    VALUE '064',  " Message Number
            c_060           TYPE symsgno    VALUE '060',  " Message Number
            c_065           TYPE symsgno    VALUE '065',  " Message Number
            c_167           TYPE symsgno    VALUE '167',  " Message Number
            c_170           TYPE symsgno    VALUE '170',  " Message Number
* BOI by NPALLA on 16-Dec-2021 for OCTM-44804:  ED2K925279
            c_262           TYPE symsgno    VALUE '262',  " Message Number
* EOI by NPALLA on 16-Dec-2021 for OCTM-44804:  ED2K925279
            c_suc           TYPE bapi_mtype VALUE 'S',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_func          TYPE msgfn      VALUE '009',  " Function : Original
* Begin of Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
            c_devid_i0229   TYPE zdevid VALUE 'I0229',
            c_param_matgrp3 TYPE rvari_vnam VALUE 'MAT_GRP_3',
* End of Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
            c_msgno_000     TYPE symsgno VALUE '000',
            c_msg_cls       TYPE symsgid VALUE 'ZQTC_R2',
            c_bal_objnm     TYPE balobj_d VALUE 'ZQTC',
            c_bal_subobjnm  TYPE balsubobj VALUE 'ZDF_ENTSTAT_RFC',
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
            c_tdobj_vbbp    TYPE tdobject VALUE 'VBBP'. " TDOBJECT for Read text of WAL number

*Start insert by <HIPATEL> <ERP-6918> <ED2K910736> <02/07/2018>
*====================================================================*
* Types
*====================================================================*
TYPES : tt_ent_stat       TYPE STANDARD TABLE OF zstqtc_ent_stat  INITIAL SIZE 0,
        tt_bdidocstat     TYPE STANDARD TABLE OF bdidocstat INITIAL SIZE 0,
        tt_entitle_status TYPE STANDARD TABLE OF ty_entitle_status.

*====================================================================*
* Local Variable
*====================================================================*
DATA: st_e1edk01 TYPE e1edk01,                             "IDoc: Document header general data
      st_e1edk14 TYPE e1edk14,                             "IDoc: Document Header Organizational Data
      st_e1edp01 TYPE e1edp01,                             "IDoc: Document Item General Data
      st_e1edp02 TYPE e1edp02,                             "IDoc: Document Item Reference Data
      st_e1edp03 TYPE e1edp03,                             "IDoc: Document Item Date Segment
      st_e1edpt1 TYPE e1edpt1,                             "IDoc: Document Item Text Identification
      st_e1edpt2 TYPE e1edpt2.                             "IDoc: Document Item Texts

DATA: li_ent_stat TYPE STANDARD TABLE OF zstqtc_ent_stat,  "Import Structure for Entitlement status I0318
      st_ent_stat TYPE zstqtc_ent_stat,
      li_return   TYPE bapiret2_t,                         "Return table
      lv_flag     TYPE char1,                              "Flag Idoc creation
      lv_vbeln    TYPE vbeln_va.                           "Contract number


*====================================================================*
* Constants
*====================================================================*
CONSTANTS:  c_e1edk01   TYPE char7       VALUE 'E1EDK01',  " Segment structure
            c_e1edp01   TYPE char7       VALUE 'E1EDP01',  " Segment structure
            c_e1edp02   TYPE char7       VALUE 'E1EDP02',  " Segment structure
            c_e1edp03   TYPE char7       VALUE 'E1EDP03',  " Segment structure
            c_e1edpt1   TYPE char7       VALUE 'E1EDPT1',  " Segment structure
            c_e1edpt2   TYPE char7       VALUE 'E1EDPT2',  " Segment structure
            c_status_51 TYPE edi_status  VALUE '51',       " Error Status
            c_status_53 TYPE edi_status  VALUE '53',       " Sucess Status
            c_msgno_006 TYPE symsgno     VALUE '006'.      "Message number
*End insert by <HIPATEL> <ERP-6918> <ED2K910736> <02/07/2018>
