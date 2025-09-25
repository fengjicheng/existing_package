*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILE_UPLOAD_ORDBP_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILE_UPLOAD_ORDBP_TOP (Declarations)
* PROGRAM DESCRIPTION: Create ZOPM (Online Program Management ) contracts
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   03/06/2019
* OBJECT ID:       TBD
* TRANSPORT NUMBER(S): ED2K914619
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
* GLOBAL VARIABLE DECLARATION-----------------------------------------------------*

TABLES:sscrfields.            " NPOLINA ERP7787  ED2K914488
***Data Declarations
*** Variable Declaration
DATA: v_file_path   TYPE localfile, " Local file for upload/download
      v_file_guid   TYPE sysuuid_c32,
      v_kunnr       TYPE kunnr,     " Customer Number
      v_fileext(20) TYPE c,     " NPOLINA ERP6378 ED2K913631
      v_log         TYPE string.    " NPOLINA ED2K913699
***Constant declarations

*----------------------------------------------------------------------*
*       CLASS cl_main DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_main DEFINITION FINAL. " Main class
  PUBLIC SECTION.
*** Type Declaration
    TYPES: BEGIN OF ty_file_excel,
             uid        TYPE char50, " Uid of type CHAR50
             auart      TYPE char50, " Sales Document Type
             spart      TYPE char50, " division SAP mandatory
             bstkd      TYPE char50, " purchase order number
             kunnr_sp   TYPE char50, " Customer Number - Sold to
             kunnr_we   TYPE char50, " Customer Number - Ship to
             vkbur      TYPE char50, " Sales Office
             augru      TYPE augru,  " Order eason
             guebg      TYPE char50, " contract start date Wiley mandatory
             gueen      TYPE char50, " contract end date Wiley mandatory
             faksk      TYPE char50, " billing block
             matnr      TYPE char50, " Material
             kwmeng     TYPE char50, " Cumulative Order Quantity in Sales Units
             arktx      TYPE arktx,  " Contract Item Text
             kdmat      TYPE matnr_ku, " Material used by Coustomer
             vkaus      TYPE vkaus,  " Usae Indicator
             guebg_itm  TYPE char50, " contract start date Wiley mandatory
             gueen_itm  TYPE char50, " contract end date Wiley mandatory
             faksp      TYPE char50, " billing block Item
             kbetr      TYPE char50, " pricing Wiley mandatory
             kschl      TYPE char50, " pricing condition value Wiley mandatory
             kbetr2     TYPE char50, " pricing Wiley mandatory
             kschl2     TYPE char50, " pricing condition value Wiley mandatory
             kbetr3     TYPE char50, " pricing Wiley mandatory
             parvw      TYPE char50, " Partner Function
             partner    TYPE char50, " Customer Number
             name1      TYPE char50, " Name1 of type CHAR50
             name2      TYPE char50, " Name2 of type CHAR50
             street     TYPE char50, " Street of type CHAR50
             city1      TYPE char50, " City of type CHAR50
             post_code1 TYPE char50, " Postal code of type CHAR50
             regio      TYPE char50, " Regio of type CHAR50
             land1      TYPE char50, " Land1 of type CHAR50
             tzone      TYPE char50, " time zone of type CHAR50
*
*
*
*             stxh          TYPE char50, "Stxh of type CHAR200

*             vkorg         TYPE char50, "sales org. SAP mandatory
*             vtweg         TYPE char50, "dist. channel SAP mandatory
*
*
*             posnr         TYPE char50, "Item number
*
**         plant    TYPE werks_d,    "Plant
*             vbeln         TYPE char50, "Sales and Distribution Document Number
*             pstyv         TYPE char50, "item category SAP mandatory
*
*             lifsk         TYPE char50, "delivery block Wiley mandatory
*
*             abgru         TYPE char50, "reason for rejection
*
*             xblnr         TYPE char50, "Reference
*             zlsch         TYPE char50, "Payment Method
*             bsark         TYPE char50, "PO Type
*
*
*             ihrez         TYPE char50, "Your Reference
*             zzpromo       TYPE char50, "Promo code
*             kdkg4         TYPE char50, " Customer condition group 4
*             kdkg5         TYPE char50, " Customer condition group 5
*             kdkg3         TYPE char50, " Customer condition group 3
*             srid          TYPE char50, " Your Reference
*
*             fkdat         TYPE char50, " Billing date for billing index and printout
*             inv_text(264) TYPE c,  " Invoice Instructions     " NPOLINA ERP7787 ED2K914488
*
*             smn           TYPE char50, " Smn of type CHAR50
*             prefix        TYPE char50, " Prefix of type CHAR50
*
*             suffix        TYPE char50, " Suffix of type CHAR50
*             cmpaff        TYPE char50, " Cmpaff of type CHAR50
*             dept          TYPE char50, " Dept of type CHAR50
*             adrnr         TYPE char50, " Adrnr of type CHAR50
*             adrnr2        TYPE char50, " Adrnr2 of type CHAR50
*             adrnr3        TYPE char50, " Adrnr3 of type CHAR50
*
*             pstlz         TYPE char50, " Pstlz of type CHAR50
*             smtp_addr     TYPE char50, " Addr of type CHAR50
*             telf1         TYPE char50, " Telf1 of type CHAR50
*             relcat        TYPE char50, " Relcat of type CHAR50
*             relstdt       TYPE char50, " Relstdt of type CHAR50
*             relendt       TYPE char50, " Relendt of type CHAR50
*             bukrs         TYPE char50, " Bukrs of type CHAR50
           END OF ty_file_excel.
*** Table Type Declaration
    TYPES:
*   tt_kunnr TYPE STANDARD TABLE OF kunnr INITIAL SIZE 0.
        tt_file_excel TYPE STANDARD TABLE OF ty_file_excel INITIAL SIZE 0.
    DATA: i_final     TYPE STANDARD TABLE OF ty_file_excel INITIAL SIZE 0,
          i_final_csv TYPE truxs_t_text_data.

*** Class Methods for Validation
    CLASS-METHODS:     validate_society IMPORTING  im_kunnr TYPE kunnr " Customer Number
                                        EXPORTING  ex_kunnr TYPE kunnr " Customer Number
                                        EXCEPTIONS invalid_society,
      f4help_file,
      down_template,                             " NPOLINA ERP7787 ED2K914488
      get_file_path  EXPORTING ex_file_path TYPE localfile.            " Local file for upload/download

    METHODS: convert_excel,
      validate_customer,
      prepare_csv,
      file_upload,
      send_mail.

ENDCLASS.
***Reference Variable Declaration
DATA: o_main TYPE REF TO lcl_main. " Main class

CONSTANTS :c_fc01   TYPE sy-ucomm VALUE 'FC01'.   "NPOLINA ERP7787 ED2K914488
