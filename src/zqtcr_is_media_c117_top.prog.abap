*&---------------------------------------------------------------------*
*&  Include           ZQTCR_IS_MEDIA_C117_TOP
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_IS_MEDIA_C117
*& PROGRAM DESCRIPTION:   IS-Media Products & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:
*& CREATION DATE:         05/05/2022
*& OBJECT ID:             C117
*& TRANSPORT NUMBER(S):
*&----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES:BEGIN OF ity_file,
        matnr           TYPE matnr,            " Material
        ind_sect        TYPE mbrsh,            " Ind Sectore
        mtart           TYPE mtart,            " Mat Type
        bukrs           TYPE bukrs,            " Company COde
        werks           TYPE werks_d,          " Plant
        lgort           TYPE lgort_d,          "Storage Location
        vkorg           TYPE vkorg,            " Sale Org
        vtweg           TYPE vtweg,            " Distr Chanl
        identcode       TYPE ismidentcode,     "Identification Code
        xmainidcode     TYPE ismxmainidcode,   "Indicator: Main ID Code
        maktx           TYPE maktx,            "Mat Description
        ismartist       TYPE ismartist,        "Name Of Author
        ismtitle        TYPE ismtitle,         "Title of author
        ismsubtitle1    TYPE ismsubtitle1,     "SubTitle - 1
        ismsubtitle2    TYPE ismsubtitle2,     "SubTitle - 2
        tdname          TYPE tdname,           "Basic text
        langu           TYPE char1,            "Language
        ismpubltype     TYPE ismpubltype,      "Publication type
        ismmediatype    TYPE ismmediatype,     "Media TYPE
        ismpubldate     TYPE ismpubldate,      "Publication Date
        mstae           TYPE mstae,            "Cross Plant Material
        ismcopynr       TYPE ismheftnummer,    "Copy Number OF media issuer
        brgew           TYPE char16,           "Gross Weight
        gewei           TYPE char3,            "Weight Units
        ean11           TYPE ean11,            "International Article number(EAN/UPC)
        ismimprint      TYPE ismimprint,       "Imprint
        bismt           TYPE bismt18,          "Old Material
        matkl           TYPE matkl,            "Mat Group
        meins           TYPE char3,            "Units
        spart           TYPE spart,            "Division
        ismdesign       TYPE ismdesign,        "Product Presentation
        ismnumtyp1      TYPE ismnumtype,       "Featur 1
        ismnumtyp2      TYPE ismnumtype,       "Featur 2
        ismextent       TYPE ismextent,        "Extent
        vmsta           TYPE vmsta,            "Distribution-chain-specific material status
        aland           TYPE aland,            "Departure Country(Country from where goods are sent)
        tatyp           TYPE tatyp,            "Tax Category
        dwerk           TYPE dwerk,            "Delivery Plant
        taxkm           TYPE char1,            "Tax Classfication
        kondm           TYPE kondm,            "Material pricing Group
        mtpos           TYPE mtpos,            "Item Category group
        mvgr1           TYPE mvgr1,            "Material Group 1
        mvgr4           TYPE mvgr4,            "Material Group 4
        mtvfp           TYPE mtvfp,            "Availablity CHeck
        tragr           TYPE tragr,            "Transportation Group
        ladgr           TYPE ladgr,            "Loading Grup
        prctr           TYPE prctr,            "Profit Centre
        ismhierarchlevl	TYPE ismhierarchlvl,   "HIerarchy Level
        herkl           TYPE herkl,            "Country Of Origin.
        dismm           TYPE dismm,            "MRP Type
        beskz           TYPE beskz,            "Procurement Type
        bklas           TYPE bklas,            "Valuation Class
        vprsv           TYPE vprsv,            "Price Control Indicator
        peinh           TYPE char5,            "Price Unit
        stprs           TYPE char13,           "Standard price
        verpr           TYPE char13,           "Moving Average Price/Periodic Unit Price
*--------------------------------------
*        extwg    TYPE extwg,        "External Material Group
*        mstde                   TYPE mstde,        " Date from which the cross-plant material status is valid
*        item_cat                TYPE mtpos_mara,   " General Material Category Group
*        ntgew                   TYPE char16,       " Net WEIGHT
*        vrkme                   TYPE char3,        " Sale Unit
*        umren                   TYPE char5,        "Denominator for conversion to base units of measure
*        umrez                   TYPE char5,        "Numerator for Conversion to Base Units of Measure
*        aumng                   TYPE char16,       " Minimum Order
*        minbe                   TYPE char16,       " Reorder Point
*        disls                   TYPE disls,        "Lot size (materials planning)
*        mabst                   TYPE char16,       " Max.STock
*        ekgrp                   TYPE ekgrp,        " Purchase Group
*        dispo                   TYPE dispo,        "MRP Controller
*        dzeit                   TYPE char3,        " In House Prod
*        plifz                   TYPE char3,        " Planned Delv Time
*        text                    TYPE char256,      " Sale Text
*        provg                   TYPE provg,        "Commission group
*        sernp                   TYPE serail,       "Serial Number Profile
*        sfcpf                   TYPE co_prodprf,   "Production Scheduling Profile
        docnum          TYPE char20,       "Field: Rate unit (currency or percentage)
*        fin_message_alv TYPE char80,   "Field: Rate unit (currency or percentage)
        vvis_lights     TYPE vvis_lights,   "Field: Rate unit (currency or percentage)
        type            TYPE bapi_mtype,   "Msg Type
        message         TYPE bapi_msg,     " Message Description
      END OF ity_file,

      BEGIN OF ity_file_clf,
        klart	  TYPE klassenart,  "Class Type
        class	  TYPE klasse_d,  "Class
        obtab   TYPE char20,    "Name of database table for object
*        objek   TYPE objnum,    "Key of object to be classified
        objek   TYPE MATNR,    "Key of object to be classified
        mafid	  TYPE klmaf,     "Indicator: Object/Class
        statu   TYPE char1,     "Classification status
        atnam   TYPE char30,  "Characteristic Name  CHAR  30                CABN
        atwrt   TYPE char30,  ""Characteristic Value  CHAR  30              AUSP
*        atnam   TYPE char30,  "Editor_Code  CHAR  30                        CABN
*        atwrt   TYPE char30,  "Editor Code Values CHAR  30                  AUSP
*        atnam   TYPE char30,  "SUBJECT_CODE CHAR  30                        CABN
*        atwrt   TYPE char30,  "SUBJECT CODE Values  CHAR  31                AUSP
*        atnam   TYPE char30,  "Subject_category CHAR  30                    CABN
*        atwrt   TYPE char30,  "Subject_category Values  CHAR  30            AUSP
*        atnam   TYPE char30,  "PRODLIN_K_VCH  CHAR  30                      CABN
*        atwrt   TYPE char30,  "PRODLIN_K_VCH Values CHAR  30                AUSP
*        atnam   TYPE char30,  "PRODUCT_LINE CHAR  30                        CABN
*        atwrt   TYPE char30,  "PRODUCT_LINE Values  CHAR  30                AUSP
*        atnam   TYPE char30,  "PRODUCT_LINE_CHICH  CHAR  30                 CABN
*        atwrt   TYPE char30,  "PRODUCT_LINE_CHICH Values CHAR  30           AUSP
*        atnam   TYPE char30,  "PRODUCT_LINE_NEWYORK  CHAR  30               CABN
*        atwrt   TYPE char30,  "PRODUCT_LINE_NEWYORK Values CHAR  30         AUSP
*        atnam   TYPE char30,  "Sales_Publisher_number  CHAR  30             CABN
*        atwrt   TYPE char30,  "Sales Publisher number Values CHAR  30       AUSP
*        atnam   TYPE char30,  "Product_Group CHAR  30                       CABN
*        atwrt   TYPE char30,  "Product Group Values  CHAR  30               AUSP
*        atnam   TYPE char30,  "Division_ID CHAR  30                         CABN
*        atwrt   TYPE char30,  "Division ID Values  CHAR  30                 AUSP
*        atnam   TYPE char30,  "Planned_Date  CHAR  30                       CABN
*        atwrt   TYPE char30,  "Planned Date Values Date  BUCH_ZEIT_KENNZ    AUSP
        type    TYPE bapi_mtype,
        message TYPE bapi_msg,
*        ind_sect TYPE mbrsh,
*        mtart    TYPE mtart,
*        bismt    TYPE bismt18,
*        klart    TYPE klassenart,
*        class    TYPE klasse_d,
*        charact  TYPE atnam,
*        atzhl    TYPE char4,
*        atwrt    TYPE atwrt,
*        atwtb    TYPE text30,
*        matnr    TYPE matnr,
*        matkl    TYPE matkl,
*        type    TYPE bapi_mtype,
*        message TYPE bapi_msg,
      END OF ity_file_clf,

      BEGIN OF ity_mara,
        matnr TYPE matnr,
        vpsta TYPE vpsta,
        mtart TYPE mtart,
        bismt TYPE bismt18,
        matkl TYPE matkl,
      END OF ity_mara,

      BEGIN OF ty_status,
        fin_message_alv TYPE fin_message_alv, " Message
        vvis_lights     TYPE  vvis_lights,    "Field: Rate unit (currency or percentage)
      END OF ty_status.


DATA: i_file_data  TYPE STANDARD TABLE OF ity_file,
      i_file_temp  TYPE STANDARD TABLE OF ity_file,
      i_sucess_rec TYPE STANDARD TABLE OF ity_file,
      i_error_rec  TYPE STANDARD TABLE OF ity_file,
      i_mara       TYPE STANDARD TABLE OF ity_mara,
      i_head       TYPE string,
      v_rows       TYPE char05.

DATA: i_file_data_clf  TYPE STANDARD TABLE OF ity_file_clf,
      i_file_temp_clf  TYPE STANDARD TABLE OF ity_file_clf,
      i_sucess_rec_clf TYPE STANDARD TABLE OF ity_file_clf,
      i_error_rec_clf  TYPE STANDARD TABLE OF ity_file_clf,
      i_char_file_data TYPE STANDARD TABLE OF ity_file_clf,
      i_bismt          TYPE bismt18,
      i_matnr          TYPE matnr,
      i_count          TYPE i VALUE '1'.

DATA:i_objectkey          TYPE bapi1003_key-object,
     i_objecttab          TYPE bapi1003_key-objecttable,
     i_classnum           TYPE bapi1003_key-classnum,
     i_classtype          TYPE bapi1003_key-classtype,
     i_status             TYPE bapi1003_key-status VALUE '1',
     i_keydate            TYPE bapi1003_key-keydate,
     st_atnam             TYPE clatnamrange,
     st_allocvalueschar   TYPE bapi1003_alloc_values_char,
     i_atnam              TYPE STANDARD TABLE OF clatnamrange,
     i_allocvaluesnumnew  TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
     i_allocvaluescurrnew TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
     i_allocvalueschar    TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
     i_return             TYPE STANDARD TABLE OF bapiret2.

DATA : st_edidc TYPE edidc. " Control record (IDoc)



CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.

DATA: ir_events     TYPE REF TO lcl_handle_events,
      ir_table      TYPE REF TO cl_salv_table,
      ir_selections TYPE REF TO cl_salv_selections.
DATA: i_const      TYPE STANDARD TABLE OF zcaconstant,
      v_total_proc TYPE char05,
      v_success    TYPE char05,
      v_error      TYPE char05,
      v_file_path  TYPE string.
DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_ERR'.

CONSTANTS: c_e      TYPE char1       VALUE 'E',
           c_x      TYPE char1       VALUE 'X',
           c_s      TYPE char1       VALUE 'S',
           c_true   TYPE sap_bool    VALUE 'X',
           c_devid  TYPE zdevid      VALUE 'C113',
           c_langu  TYPE char1       VALUE 'E',
           c_param1 TYPE rvari_vnam  VALUE 'NO_OF_RECORDS'.

CONSTANTS: c_field       TYPE dynfnam   VALUE 'P_FILE',          "Field name
           c_rucomm      TYPE syucomm   VALUE 'RUCOMM',          "Function Code
           c_onli        TYPE syucomm   VALUE 'ONLI',            "Function Code
           c_separator   TYPE char1     VALUE ',',               "Separator of type Character
           c_kvewe_a     TYPE kvewe     VALUE 'A',               "Usage of the condition table
           c_alv_light_3 TYPE char1     VALUE '3',               "3 of type CHAR1
           c_alv_light_1 TYPE char1     VALUE '1',               "1 of type CHAR1
           c_msgid       TYPE symsgid   VALUE 'ZQTC_R2',         "Message Class
           c_msg_type_i  TYPE symsgty   VALUE 'I',               "Message Type
           c_msg_type_e  TYPE symsgty   VALUE 'E',               "Message Type
           c_mara        TYPE char4     VALUE 'MARA'.             "table name
