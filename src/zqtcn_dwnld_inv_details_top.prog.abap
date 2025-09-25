*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DWNLD_INV_DETAILS_E071
* PROGRAM DESCRIPTION: Download invoice details and Credit details
*                      in a excel file.
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 10/04/2016
* OBJECT ID: E071
* TRANSPORT NUMBER(S): ED2K903054
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DWNLD_INV_DETAILS_TOP
*&---------------------------------------------------------------------*

*====================================================================*
* G L O B A L   S T R U C T U  R E
*====================================================================*

* Type Declaration
TYPES : BEGIN OF ty_final_inv,
          vbeln       TYPE vbeln, " Sales and Distribution Document Number
          fkart       TYPE fkart, " Billing Type
*         Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          waerk       TYPE waerk, " SD Document Currency
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          vkorg       TYPE vkorg,        " Sales Organization
          vtweg       TYPE vtweg,        " Distribution Channel
          fkdat       TYPE fkdat,        " Billing date for billing index and printout
          erdat       TYPE erdat,        " Date on Which Record Was Created
          kunrg       TYPE kunrg,        " Payer
          kunag       TYPE kunag,        " Sold-to party
          identcode   TYPE ismidentcode, " Identification Code
          ismartist   TYPE ismartist,    " Name of Author or Artist
          ismtitle    TYPE ismtitle,     " Title
*         Begin of change: PBOSE: 8-Dec-2016: CR_305:ED2K903054
*          ismmediatype TYPE ismmediatype,
*         End of change: PBOSE: 8-Dec-2016: CR_305:ED2K903054
*         Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          bezeichnung TYPE ismmediatype_ktxt, " Media Type Text
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
*         medium       TYPE medium,       " Medium " (--) PBOSE: 8-Dec-2016: SR_:ED2K903054
          ismpubldate TYPE ismdrerz, " Publication Key

*         Begin of change: PBOSE: 8-Dec-2016: CR_305:ED2K903054
*         Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*          fkimg       TYPE fkimg, " Actual Invoiced Quantity
*         End of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*         End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054

*         Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
          fkimg       TYPE i, " Fkimg of type Integers
*         Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

*         Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*          lfimg       TYPE lfimg, " Actual quantity delivered (in sales units)
*         Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054

*         Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
          lfimg       TYPE i, " Lfimg of type Integers
*         end of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

          list_sum    TYPE kbetr, " Rate (condition amount or percentage)
          disc_sum    TYPE kwert,    " Rate (condition amount or percentage)
*          disc_sum    TYPE char15,   " Discount Percentage
          netwr       TYPE netwr_fp, " Net value of the billing item in document currency
          posnr       TYPE posnr_vf, " Billing item
*         Begin of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
          bstnk       TYPE bstnk, " Customer purchase order number
*         End of change: PBOSE: 8-Dec-2016: SR_:ED2K903054
*         bstnk_vf     TYPE bstkd,        " Customer purchase order number  " (--) PBOSE: 8-Dec-2016: SR_:ED2K903054
          sales_tax   TYPE kwert, " Condition value
        END OF ty_final_inv,

*       Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
        BEGIN OF ty_inv_temp,
          vbeln        TYPE vbeln,             " Sales and Distribution Document Number
          fkart        TYPE fkart,             " Billing Type
          waerk        TYPE waerk,             " SD Document Currency
          vkorg        TYPE vkorg,             " Sales Organization
          vtweg        TYPE vtweg,             " Distribution Channel
          fkdat        TYPE fkdat,             " Billing date for billing index and printout
          erdat        TYPE erdat,             " Date on Which Record Was Created
          kunrg        TYPE kunrg,             " Payer
          kunag        TYPE kunag,             " Sold-to party
          identcode    TYPE ismidentcode,      " Identification Code
          ismartist    TYPE ismartist,         " Name of Author or Artist
          ismtitle     TYPE ismtitle,          " Title
          bezeichnung  TYPE ismmediatype_ktxt, " Media Type Text
*          kposn        TYPE kposn,             " Condition item number
*          krech        TYPE krech,             " Calculation type for condition
          ismpubldate  TYPE ismdrerz,          " Publication Key
          fkimg        TYPE fkimg,             " Fkimg of type Integers
          lfimg        TYPE lfimg,             " Lfimg of type Integers
          list_sum     TYPE kbetr,             " Rate (condition amount or percentage)
          disc_sum     TYPE kwert,             " Rate (condition amount or percentage)
          netwr        TYPE netwr_fp,          " Net value of the billing item in document currency
          posnr        TYPE posnr_vf,          " Billing item
          bstnk        TYPE bstnk,             " Customer purchase order number
          sales_tax    TYPE kwert,             " Condition value
        END OF ty_inv_temp,

        BEGIN OF ty_crd_temp,
          vbeln        TYPE vbeln,             " Sales and Distribution Document Number
          fkart        TYPE fkart,             " Billing Type
          waerk        TYPE waerk,             " SD Document Currency
          vkorg        TYPE vkorg,             " Sales Organization
          vtweg        TYPE vtweg,             " Distribution Channel
          fkdat        TYPE fkdat,             " Billing date for billing index and printout
          erdat        TYPE erdat,             " Date on Which Record Was Created
          kunrg        TYPE kunrg,             " Payer
          kunag        TYPE kunag,             " Sold-to party
          identcode    TYPE ismidentcode,      " Identification Code
          ismtitle     TYPE ismtitle,          " Title
*          kposn        TYPE kposn,             " Condition item number
*          krech        TYPE krech,             " Calculation type for condition
          fkimg        TYPE fkimg,             " Actual Invoiced Quantity
          list_sum     TYPE kbetr,             " Rate (condition amount or percentage)
          disc_sum     TYPE kwert,             " Condition value
          netwr        TYPE netwr_fp,          " Net value of the billing item in document currency
          posnr        TYPE posnr_vf,          " Billing item
          augru_auft   TYPE augru,             " Order reason (reason for the business transaction)
          va_vgbel     TYPE vgbel,             " Document number of the reference document
          sales_tax    TYPE kwert,             " Condition value
        END OF ty_crd_temp,

*       End of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

        BEGIN OF ty_final_crd,
          vbeln      TYPE vbeln, " Sales and Distribution Document Number
          fkart      TYPE fkart, " Billing Type
*         Begin of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          waerk      TYPE waerk, " SD Document Currency
*         End of change: PBOSE: 19-Dec-2016: CR_305:ED2K903054
          vkorg      TYPE vkorg,        " Sales Organization
          vtweg      TYPE vtweg,        " Distribution Channel
          fkdat      TYPE fkdat,        " Billing date for billing index and printout
          erdat      TYPE erdat,        " Date on Which Record Was Created
          kunrg      TYPE kunrg,        " Payer
          kunag      TYPE kunag,        " Sold-to party
          identcode  TYPE ismidentcode, " Identification Code
          ismtitle   TYPE ismtitle,     " Title

*         Begin of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054
*          fkimg      TYPE fkimg,        " Actual Invoiced Quantity
*         End of Del: PBOSE: 20-Dec-2016: CR_305:ED2K903054

*         Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
          fkimg      TYPE i, " Fkimg of type Integers
*         End of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054

          list_sum   TYPE kbetr, " Rate (condition amount or percentage)
          disc_sum   TYPE kwert,      " Condition value
*          disc_sum   TYPE kbetr,   " Discount Percentage
          netwr      TYPE netwr_fp, " Net value of the billing item in document currency
          posnr      TYPE posnr_vf, " Billing item
          augru_auft TYPE char30,   " Order reason (reason for the business transaction)
          va_vgbel   TYPE vgbel,    " Document number of the reference document
          sales_tax  TYPE kwert,    " Condition value
        END OF ty_final_crd.

*====================================================================*
* G L O B A L   T A B L E  T Y P E
*====================================================================*
TYPES: tty_final_inv TYPE STANDARD TABLE OF ty_final_inv INITIAL SIZE 0,
*      Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
       tty_inv_temp  TYPE STANDARD TABLE OF ty_inv_temp  INITIAL SIZE 0,
       tty_crd_temp  TYPE STANDARD TABLE OF ty_crd_temp  INITIAL SIZE 0,
*      End of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
       tty_final_crd TYPE STANDARD TABLE OF ty_final_crd INITIAL SIZE 0.
*=================  ===================================================*
* G L O B A L   I N T E R N A L   T A B L E
*====================================================================*
DATA : i_final_inv TYPE tty_final_inv, " Final Internal table for invoice
*      Begin of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
       i_inv_temp  TYPE tty_inv_temp,
       i_crd_temp  TYPE tty_crd_temp,
*      End of change: PBOSE: 20-Dec-2016: CR_305:ED2K903054
       i_final_crd TYPE tty_final_crd, " Final Internal table for credit
*====================================================================*
* G L O B A L   V A R I A B L E
*====================================================================*
       v_vbeln     TYPE vbrk-vbeln, " Billing Document
       v_fkart     TYPE vbrk-fkart, " Billing Type
       v_kunrg     TYPE vbrk-kunrg, " Customer
       v_kunag     TYPE vbrk-kunag, " Payer
       v_fkdat     TYPE fkdat,      " Billing date for billing index and printout
       v_vkorg     TYPE vbrk-vkorg, " Sales Organization
       v_vtweg     TYPE vbrk-vtweg. " Distribution Channel
*====================================================================*
* Declaration for ALV Columns
*====================================================================*
DATA : i_table       TYPE REF TO cl_salv_table,         " Basis Class for Simple Tables
       i_column_ref  TYPE        salv_t_column_ref,
       st_column_ref TYPE        salv_s_column_ref,     " Column of ALV List
       v_columns     TYPE REF TO cl_salv_columns_table, " Columns in Simple, Two-Dimensional Tables
       v_column      TYPE REF TO cl_salv_column_table.  " Column Description of Simple, Two-Dimensional Tables

*====================================================================*
* Declaration for Layout Settings
*====================================================================*
DATA : v_layout     TYPE REF TO cl_salv_layout,         " Settings for Layout
       v_functions  TYPE REF TO cl_salv_functions_list, " Generic and User-Defined Functions in List-Type Tables
       v_layout_key TYPE        salv_s_layout_key.      " Layout Key
*====================================================================*
* Declaration for Global Display Settings
*====================================================================*
DATA : v_display TYPE REF TO cl_salv_display_settings, " Appearance of the ALV Output
       v_title   TYPE        lvc_title.                " ALV Control: Title bar text
*====================================================================*
*  G L O B A L  C O N S T A N T S
*====================================================================*
CONSTANTS: c_e      TYPE bapi_mtype  VALUE 'E', " Message type: S Success, E Error, W Warning, I Info, A Abort
           c_percnt TYPE char1       VALUE '%'. " Percnt of type CHAR1
*====================================================================*
* G L O B A L  R E P O R T  C L A S S
*====================================================================*
CLASS lcl_data_val DEFINITION DEFERRED. "
*====================================================================*
* G L O B A L   R E P O R T  O B J E C T
*====================================================================*
DATA:o_dwnld_inv_details TYPE REF TO lcl_data_val. " Data_val class
*====================================================================*
* CLASS LCL_DATA_VAL DEFINITION
*====================================================================*
CLASS lcl_data_val DEFINITION . " Data_val class

* Declaration of public section to define class method.
  PUBLIC SECTION.
*====================================================================*
*   Data Declaration
*====================================================================*
    DATA:      v_display_mode      TYPE char1. " Display_mode of type CHAR1
*====================================================================*
*   Constant Declaration
*====================================================================*
    CONSTANTS: c_display_mode_inv  TYPE char1 VALUE 'I', " Display_mode_inv of type CHAR1
               c_display_mode_crdt TYPE char1 VALUE 'C'. " Display_mode_crdt of type CHAR1
*====================================================================*
*   Static Methods: Class Method for data Validation
*====================================================================*
    CLASS-METHODS:
*--------------------------------------------------------------------*
*     Method used for User Input validation( Selection screen input)
*--------------------------------------------------------------------*
      validate_data EXCEPTIONS vbeln_not_validated
                               fkart_not_validated
                               kunag_not_validated
                               kunrg_not_validated
                               vkorg_not_validated
                               vtweg_not_validated.
*====================================================================*
*  Instantiated Methods : Methods used for data display.
*====================================================================*
    METHODS:
*--------------------------------------------------------------------*
*     Constructor Method-Method will be created at Object creation
*                        used for clearing all the Report Global
*                        variables
*--------------------------------------------------------------------*
      constructor,
*--------------------------------------------------------------------*
*     Method to set the mode of Display ('I' for Invoice ;'C' for Credit)
*     depending on user input in the report runtime
*--------------------------------------------------------------------*
      set_display_mode,
*--------------------------------------------------------------------*
*     Method to determine the user input and determine action as per
*     the user input
*--------------------------------------------------------------------*
      get_display_mode EXPORTING ev_display_mode TYPE char1, " Display_mode exporting ev_ of type CHAR1
*--------------------------------------------------------------------*
*     Method to initialize the display mode status-Clearing variables
*--------------------------------------------------------------------*
      reset_display_mode,
*--------------------------------------------------------------------*
*     Method to set column heading in ald display for invoice.
*--------------------------------------------------------------------*
      column_settings_invoice,
*--------------------------------------------------------------------*
*     Method to set column heading in ald display for credit.
*--------------------------------------------------------------------*
      column_settings_credit,
*--------------------------------------------------------------------*
*     Method to consume the CDS views and filter depending on the user
*     input and populate the ALV report display table
*--------------------------------------------------------------------*
      get_data
        EXPORTING
          ex_final_inv TYPE tty_final_inv
          ex_final_crd TYPE tty_final_crd,
*--------------------------------------------------------------------*
*     Method responsible for Invoice details ALV display
*--------------------------------------------------------------------*
      alv_display_inv,
*--------------------------------------------------------------------*
*     Method responsible for Credit details ALV display
*--------------------------------------------------------------------*
      alv_display_crd.
*====================================================================*
* Declaration of private section to define methods for data fetching.
*====================================================================*
  PRIVATE SECTION.
*--------------------------------------------------------------------*
*            Method to consume the CDS view responsible for Invoice
*            details.Triggered from within the method GET_DATA only
*            when the user wants the details regarding the Invoices
*--------------------------------------------------------------------*
    METHODS: get_inv_det EXPORTING ex_inv_det TYPE tty_final_inv,
*--------------------------------------------------------------------*
*            Method to consume the CDS view responsible for Credit
*            details.Triggered from within the method GET_DATA only
*            when the user wants the details regarding the Invoices
*--------------------------------------------------------------------*
      get_crd_det EXPORTING ex_crd_det TYPE tty_final_crd.

ENDCLASS.
