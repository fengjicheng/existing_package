*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SOCIETY_SURVEY_R043
* PROGRAM DESCRIPTION: Society Survey options Report
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-04-26
* OBJECT ID: R043
* TRANSPORT NUMBER(S): ED2K904138
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K907530
* REFERENCE NO:  ERP-3472
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-26
* DESCRIPTION: Salutation should have the description instead of number.
*              same has been fixed. Member Category Desc was having an
*              issue in reading BINARY search and hence used SORT to work.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SOCIETY_SURVEY_TOP
*&---------------------------------------------------------------------*
TABLES : but000, " BP: General data I
         tbz9,   " BP relationship categories
         vbak.   " Sales Document: Header Data

TYPES :     BEGIN OF ty_tab_records,
              first_name    TYPE bu_namep_f,        " First name of business partner (person)
              last_name     TYPE bu_namep_l,        " Last name of business partner (person)
              email         TYPE ad_smtpadr,        " E-Mail Address
              ext_data_ref  TYPE char10,            " Data_ref of type CHAR10
* Begin of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3472
*              salutation    TYPE ad_title,          " Form-of-Address Key
              salutation    TYPE ad_titletx,         " Salutation Text.
* End of Change by PBANDLAPAL on 26-Jul-2017 for ERP-3472
              inst_name     TYPE ad_strspp1,        " Street 2
              dept_name     TYPE ad_strspp2,        " Street 3
              street        TYPE ad_street,         " Street
              city          TYPE ad_city1,          " City
              post_code     TYPE ad_pstcd1,         " City postal code
              country       TYPE landx,             " Country Name
              telephone     TYPE ad_tlnmbr,         " Telephone no.: dialling code+number
              mem_num       TYPE bu_partner,        " Business Partner Number
              society_num   TYPE bu_partner,        " Business Partner Number
              society_name  TYPE ad_name1,          " Name 1
              subscrptn_num TYPE vbeln_va,          " Sales Document
              mem_cat       TYPE bu_rtitl,          " Title of Object Part
            END OF ty_tab_records,
            tt_tab_records TYPE STANDARD TABLE OF ty_tab_records,
            tt_reltyp_r    TYPE RANGE OF bu_reltyp. " Business Partner Relationship Category

CONSTANTS : c_scrgrp     TYPE char3  VALUE 'CG1',  " Scrgrp of type CHAR3
            c_sign_incld TYPE ddsign   VALUE 'I',  "Sign: (I)nclude
            c_opti_equal TYPE ddoption VALUE 'EQ', "Option: (EQ)ual
            c_auart_zsub TYPE auart VALUE 'ZSUB',  " Sales Document Type
            c_auart_zrew TYPE auart VALUE 'ZREW',  " Sales Document Type
            c_vbtyp_g    TYPE vbtyp VALUE 'G',     " SD document category
            c_x          TYPE char1 VALUE 'X'.     " X of type CHAR1

DATA : i_tab_final    TYPE tt_tab_records,
       i_final_csv    TYPE truxs_t_text_data,
       i_fieldcatalog TYPE slis_t_fieldcat_alv. "fieldcatalog table
