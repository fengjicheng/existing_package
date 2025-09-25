*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_AUTOMATED_LOCKBOX_E097
* REPORT DESCRIPTION:    Top include
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         31/07/2017
* OBJECT ID:             E097(CR# 463)
* TRANSPORT NUMBER(S):   ED2K907624(W)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_AUTOMATED_LOCKBOX_TOP
*&---------------------------------------------------------------------*
*Global type declaration
TYPES: BEGIN OF ty_augdt,
         sign   TYPE ddsign,              " Type of SIGN component in row type of a Ranges type
         option TYPE ddoption,            " Type of OPTION component in row type of a Ranges type
         low    TYPE augdt,               " Clearing Date
         high   TYPE augdt,               " Clearing Date
       END OF ty_augdt,

       tt_augdt TYPE STANDARD TABLE OF ty_augdt INITIAL SIZE 0,

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

       tt_constant TYPE STANDARD TABLE OF ty_constant
              INITIAL SIZE 0,

       BEGIN OF ty_final,
         bukrs   TYPE bukrs,              " Company Code
         gjahr   TYPE gjahr,              " Fiscal Year
         belnr   TYPE belnr_d,            " Accounting Document Number
         augbl   TYPE augbl,              " Document Number of the Clearing Document
         augdt   TYPE augdt,              " Clearing Date
         xref1   TYPE xref1,              " Business Partner Reference Key
         aubel   TYPE vbeln_va,           " Sales Document
         aupos   TYPE posnr_va,           " Sales Document Item
         message TYPE bapi_msg,
       END OF ty_final,

       tt_final TYPE STANDARD TABLE OF ty_final
           INITIAL SIZE 0.

*Global internal table declaration
DATA: i_constant  TYPE tt_constant,
      i_final_tab TYPE tt_final.

*Global constant declaration
CONSTANTS: c_sign_incld TYPE ddsign    VALUE 'I',  "Sign: (I)nclude
           c_opti_equal TYPE ddoption  VALUE 'EQ'. "Option: (EQ)ual

*Global variable declaration
DATA: v_augdt TYPE augdt, " Clearing Date
      v_umskz TYPE umskz, " Special G/L Indicator
      v_bukrs TYPE bukrs, " Company Code
      v_blart TYPE blart, " Document Type
      v_fkart TYPE fkart. " Billing Type
