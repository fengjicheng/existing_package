class ZQTCCL_CUSTOMER_ADD_DATA_BI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CUSTOMER_ADD_DATA_BI .

  class-methods METH_TRANSFER_STRUCTURES
    importing
      !IM_STRUCT type ref to CL_ABAP_STRUCTDESCR
      !IM_NODATA type NODATA_BI default '/'
      !IM_SRC_STR type ANY
    changing
      !CH_TRG_STR type ANY .
protected section.
PRIVATE SECTION.

* Begin of DEL:ERP-3944:WROY:23-SEP-2017:ED2K908674
* DATA st_data_z1rtr_knvvm TYPE z1rtr_knvvm . "Master customer master sales data (KNVV) - Additional Fields
* End   of DEL:ERP-3944:WROY:23-SEP-2017:ED2K908674
* Begin of ADD:ERP-3944:WROY:23-SEP-2017:ED2K908674
  TYPES:
    BEGIN OF ty_z1rtr_knvvm,
      vkorg TYPE vkorg,                       "Sales Organization
      vtweg TYPE vtweg,                       "Distribution Channel
      spart TYPE spart,                       "Division
      cdata TYPE z1rtr_knvvm,                 "Master customer master sales data (KNVV) - Additional Fields
    END OF ty_z1rtr_knvvm,
    tt_z1rtr_knvvm TYPE SORTED TABLE OF ty_z1rtr_knvvm INITIAL SIZE 0
                   WITH UNIQUE KEY vkorg vtweg spart.
  DATA:
    i_data_z1rtr_knvvm TYPE tt_z1rtr_knvvm.
* End   of ADD:ERP-3944:WROY:23-SEP-2017:ED2K908674
  CONSTANTS c_tab_name_bi TYPE tbnam VALUE 'ZSTRTR_BKNVV' ##NO_TEXT.
  CONSTANTS c_stype_bi_2 TYPE stype_bi VALUE '2' ##NO_TEXT.
  CONSTANTS c_nodata TYPE nodata_bi VALUE '/' ##NO_TEXT.
  CONSTANTS c_seg_name_knvvm TYPE edilsegtyp VALUE 'Z1RTR_KNVVM' ##NO_TEXT.
ENDCLASS.



CLASS ZQTCCL_CUSTOMER_ADD_DATA_BI IMPLEMENTATION.


  METHOD if_ex_customer_add_data_bi~check_data_row.
*------------------------------------------------------------------------*
* PROGRAM NAME        : ZRTREI_ADDITIONAL_KNVV_FIELDS                    *
* PROGRAM DESCRIPTION : Customer Master - Sales View extension           *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2016-08-02                                       *
* OBJECT ID           : C059                                             *
* TRANSPORT NUMBER(S) : ED2K902647                                       *
*------------------------------------------------------------------------*
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
    CONSTANTS:
      lc_wricefid_c059 TYPE zdevid VALUE 'C059',   "Constant value for WRICEF (C059)
      lc_ser_nr_001    TYPE zsno   VALUE '001'.    "Serial Number (001)

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
    DATA:
      lv_active_c059  TYPE zactive_flag,         "Active / Inactive flag
      lv_var_key_c059 TYPE zvar_key.             "Variable Key

*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricefid_c059        "Constant value for WRICEF (C059)
        im_ser_num     = lc_ser_nr_001           "Serial Number (001)
      IMPORTING
        ex_active_flag = lv_active_c059.         "Active / Inactive flag

    IF lv_active_c059 EQ abap_true.              "Enhancement is Active
      INCLUDE zrtrn_additional_knvv_fields_3 IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA_BI~FILL_ALE_SEGMENTS_OWN_DATA.
  endmethod.


  METHOD if_ex_customer_add_data_bi~fill_bi_table_with_own_segment.
*------------------------------------------------------------------------*
* PROGRAM NAME        : ZRTREI_ADDITIONAL_KNVV_FIELDS                    *
* PROGRAM DESCRIPTION : Customer Master - Sales View extension           *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2016-08-02                                       *
* OBJECT ID           : C059                                             *
* TRANSPORT NUMBER(S) : ED2K902647                                       *
*------------------------------------------------------------------------*
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
    CONSTANTS:
      lc_wricefid_c059 TYPE zdevid VALUE 'C059', "Constant value for WRICEF (C059)
      lc_ser_nr_001    TYPE zsno   VALUE '001'.  "Serial Number (001)

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
    DATA:
      lv_active_c059  TYPE zactive_flag,         "Active / Inactive flag
      lv_var_key_c059 TYPE zvar_key.             "Variable Key

*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricefid_c059        "Constant value for WRICEF (C059)
        im_ser_num     = lc_ser_nr_001           "Serial Number (001)
      IMPORTING
        ex_active_flag = lv_active_c059.         "Active / Inactive flag

    IF lv_active_c059 EQ abap_true.              "Enhancement is Active
      INCLUDE zrtrn_additional_knvv_fields_2 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_customer_add_data_bi~fill_ft_table_using_data_rows.
*------------------------------------------------------------------------*
* PROGRAM NAME        : ZRTREI_ADDITIONAL_KNVV_FIELDS                    *
* PROGRAM DESCRIPTION : Customer Master - Sales View extension           *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2016-08-02                                       *
* OBJECT ID           : C059                                             *
* TRANSPORT NUMBER(S) : ED2K902647                                       *
*------------------------------------------------------------------------*
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
    CONSTANTS:
      lc_wricefid_c059 TYPE zdevid VALUE 'C059',   "Constant value for WRICEF (C059)
      lc_ser_nr_001    TYPE zsno   VALUE '001'.    "Serial Number (001)

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
    DATA:
      lv_active_c059  TYPE zactive_flag,          "Active / Inactive flag
      lv_var_key_c059 TYPE zvar_key.              "Variable Key

*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricefid_c059            "Constant value for WRICEF (C059)
        im_ser_num     = lc_ser_nr_001               "Serial Number (001)
      IMPORTING
        ex_active_flag = lv_active_c059.             "Active / Inactive flag

    IF lv_active_c059 EQ abap_true.                "Enhancement is Active
      INCLUDE zrtrn_additional_knvv_fields_4 IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA_BI~MODIFY_BI_STRUCT_FROM_STD_SEG.
  endmethod.


  METHOD if_ex_customer_add_data_bi~pass_non_standard_segment.
*------------------------------------------------------------------------*
* PROGRAM NAME        : ZRTREI_ADDITIONAL_KNVV_FIELDS                    *
* PROGRAM DESCRIPTION : Customer Master - Sales View extension           *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2016-08-02                                       *
* OBJECT ID           : C059                                             *
* TRANSPORT NUMBER(S) : ED2K902647                                       *
*------------------------------------------------------------------------*
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
    CONSTANTS:
      lc_wricefid_c059 TYPE zdevid VALUE 'C059',   "Constant value for WRICEF (C059)
      lc_ser_nr_001    TYPE zsno   VALUE '001'.    "Serial Number (001)

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
    DATA:
      lv_active_c059  TYPE zactive_flag,          "Active / Inactive flag
      lv_var_key_c059 TYPE zvar_key.              "Variable Key

*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricefid_c059            "Constant value for WRICEF (C059)
        im_ser_num     = lc_ser_nr_001               "Serial Number (001)
      IMPORTING
        ex_active_flag = lv_active_c059.             "Active / Inactive flag

    IF lv_active_c059 EQ abap_true.                "Enhancement is Active
      INCLUDE zrtrn_additional_knvv_fields_1 IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA_BI~PROCESS_ALE_OWN_CHANGE_POINTER.
  endmethod.


  METHOD meth_transfer_structures.

    DATA:
      li_cmpnt   TYPE abap_component_tab.         "Components of a Structure

    DATA:
      lr_struct   TYPE REF TO cl_abap_structdescr. "Describe a Structure

    FIELD-SYMBOLS:
      <lv_source> TYPE any,                        "Source Field
      <lv_target> TYPE any.                        "Target Field

*   Returns Component Description Table of Structure
    lr_struct ?= im_struct.
    li_cmpnt   = lr_struct->get_components( ).

*   Initialize Field Values
    LOOP AT li_cmpnt ASSIGNING FIELD-SYMBOL(<lst_cmpnt>).
      IF <lst_cmpnt>-name IS NOT INITIAL.
        ASSIGN COMPONENT <lst_cmpnt>-name OF STRUCTURE ch_trg_str TO <lv_target>.
        IF <lv_target> IS ASSIGNED.
          <lv_target> = im_nodata.

          ASSIGN COMPONENT <lst_cmpnt>-name OF STRUCTURE im_src_str TO <lv_source>.
          IF <lv_source> IS ASSIGNED AND
             <lv_source> NE im_nodata.
            <lv_target> = <lv_source>.
          ENDIF.
        ENDIF.
      ELSE.
        IF <lst_cmpnt>-as_include EQ abap_true.
          lr_struct ?= <lst_cmpnt>-type.
          CALL METHOD zqtccl_customer_add_data_bi=>meth_transfer_structures
            EXPORTING
              im_struct  = lr_struct
              im_nodata  = im_nodata
              im_src_str = im_src_str
            CHANGING
              ch_trg_str = ch_trg_str.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
