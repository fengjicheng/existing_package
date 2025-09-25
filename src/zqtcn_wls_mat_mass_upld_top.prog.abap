*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_MAT_MASS_UPLD_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_WLS_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         03/04/2020
*& OBJECT ID:             C113
*& TRANSPORT NUMBER(S):   ED2K917656
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
        matnr    TYPE matnr,    " Material
        ind_sect TYPE mbrsh,    " Ind Sectore
        mtart    TYPE mtart,    " Mat Type
        bukrs    TYPE bukrs,    " Company COde
        werks    TYPE werks_d,  " Plant
        vkorg    TYPE vkorg,    " Sale Org
        vtweg    TYPE vtweg,    " Distr Chanl
        maktx    TYPE maktx,    " Mat Description
        langu    TYPE char1,    " Language
        meins    TYPE char3,    " Units
        matkl    TYPE matkl,    " Mat Group
        bismt    TYPE bismt18,  " Old Material
        extwg    TYPE extwg,    "External Material Group
        spart    TYPE spart,    " Division
        mstae    TYPE mstae,    " Cross Plant Material
        mstde    TYPE mstde,        " Date from which the cross-plant material status is valid
        item_cat TYPE mtpos_mara,   " General Material Category Group
        brgew    TYPE char16,       " Gross Weight
        ntgew    TYPE char16,       " Net WEIGHT
        gewei    TYPE char3,        " Weight Units
        vrkme    TYPE char3,        " Sale Unit
        umren    TYPE char5,        "Denominator for conversion to base units of measure
        umrez    TYPE char5,        "Numerator for Conversion to Base Units of Measure
        dwerk    TYPE dwerk,        " Delivery Plant
        taxkm    TYPE char1,        " Tax Classfication
        aumng    TYPE char16,       " Minimum Order
        mvgr2    TYPE mvgr2,        " Material Group 2
        mtpos    TYPE mtpos,        " Item Category group
        mvgr4    TYPE mvgr4,        " Material Group 4
        mtvfp    TYPE mtvfp,        " Availablity CHeck
        tragr    TYPE tragr,        " Transportation Group
        ladgr    TYPE ladgr,        " Loading Grup
        prctr    TYPE prctr,        " Profit Centre
        minbe    TYPE char16,       " Reorder Point
        disls    TYPE disls,        "Lot size (materials planning)
        mabst    TYPE char16,       " Max.STock
        ekgrp    TYPE ekgrp,        " Purchase Group
        dismm    TYPE dismm,        " MRP Type
        dispo    TYPE dispo,        "MRP Controller
        beskz    TYPE beskz,        " Procurement Type
        dzeit    TYPE char3,        " In House Prod
        plifz    TYPE char3,        " Planned Delv Time
        bklas    TYPE bklas,        "Valuation Class
        vprsv    TYPE vprsv,        "Price Control Indicator
        peinh    TYPE char5,        "Price Unit
        stprs    TYPE char13,       "Standard price
        verpr    TYPE char13,       "Moving Average Price/Periodic Unit Price
        text     TYPE char256,      " Sale Text
        provg    TYPE provg,        "Commission group
        sernp    TYPE serail,       "Serial Number Profile
        sfcpf    TYPE co_prodprf,   "Production Scheduling Profile
        type     TYPE bapi_mtype,   "Msg Type
        message  TYPE bapi_msg,     " Message Description
      END OF ity_file,

      BEGIN OF ity_file_clf,
        ind_sect TYPE mbrsh,
        mtart    TYPE mtart,
        bismt    TYPE bismt18,
        klart    TYPE klassenart,
        class    TYPE klasse_d,
        charact  TYPE atnam,
        atzhl    TYPE char4,
        atwrt    TYPE atwrt,
        atwtb    TYPE text30,
        matnr    TYPE matnr,
        matkl    TYPE matkl,
        type     TYPE bapi_mtype,
        message  TYPE bapi_msg,
      END OF ity_file_clf,

      BEGIN OF ity_mara,
        matnr TYPE matnr,
        vpsta TYPE vpsta,
        mtart TYPE mtart,
        bismt TYPE bismt18,
        matkl TYPE matkl,
      END OF ity_mara.

DATA: i_file_data  TYPE STANDARD TABLE OF ity_file,
      i_file_temp  TYPE STANDARD TABLE OF ity_file,
      i_sucess_rec TYPE STANDARD TABLE OF ity_file,
      i_error_rec  TYPE STANDARD TABLE OF ity_file,
      i_mara       TYPE STANDARD TABLE OF ity_mara,
      i_head       TYPE string,
      i_rows       TYPE char05.

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


CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.


ENDCLASS.




DATA: ir_events     TYPE REF TO lcl_handle_events,
      ir_table      TYPE REF TO cl_salv_table,
      ir_selections TYPE REF TO cl_salv_selections.
DATA: i_const       TYPE STANDARD TABLE OF zcaconstant,
*      i_constants   TYPE zcat_constants,
      gv_total_proc TYPE char05,
      gv_success    TYPE char05,
      gv_error      TYPE char05,
      v_file_path   TYPE string.
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
