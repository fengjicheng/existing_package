*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CREDIT_LIMIT_REP_R091
* PROGRAM DESCRIPTION: Customer Credit Limits Report.
* DEVELOPER:           Nageswara
* CREATION DATE:       09/03/2019
* OBJECT ID:           R091
* TRANSPORT NUMBER(S): ED2K916008
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include          ZQTCN_CREDIT_LIMIT_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS:slis.
TABLES:tvkg.
*====================================================================*
* TYPES DECLARARTION
*====================================================================*
TYPES: BEGIN OF ty_output,
         kunnr     TYPE kunnr,
         name1     TYPE char70,
         city_post TYPE char50,
         land1     TYPE land1,
         bukrs     TYPE bukrs,
         zterm     TYPE dzterm,
         zwels     TYPE dzwels,
         crlimit   TYPE ukm_credit_limit,
         cr_curr   TYPE waers,
         crexpo    TYPE ukm_sgm_amount,
         cravail   TYPE ukm_sgm_amount,
         vtext     TYPE char40,
         text2     TYPE char120,
         xblocked  TYPE char10,   "Y/N
         abstk     TYPE abstk,
         abstk_t   TYPE char40,
         vkuegru   TYPE vkgru_veda,
         cancel_t  TYPE char40,
         vbedkue   TYPE vbedk_veda,
         vbeln     TYPE vbeln,
         auart     TYPE auart,
         waerk     TYPE waers,
         ozterm    TYPE dzterm,
         ozterm_t  TYPE char40,
         zlsch     TYPE schzw_bseg,
         ozlsch_t  TYPE char40,
         crseg     TYPE ukm_credit_sgmnt,
       END OF ty_output.

*====================================================================*
* GLOBAL VARIABLES
*====================================================================*

DATA: r_table   TYPE REF TO cl_salv_table,
      i_alvfc   TYPE slis_t_fieldcat_alv,
      st_alvfc  TYPE slis_fieldcat_alv,
      i_fldcat  TYPE lvc_t_fcat,
      v_fname   TYPE char20,
      v_columns TYPE i,
      st_fldcat TYPE lvc_s_fcat.

DATA:st_vbak       TYPE vbak,
     st_t001       TYPE t001,
     st_veda       TYPE veda,
     st_vbuk       TYPE vbuk,
     st_t005       TYPE t005,
     st_tvkg       TYPE tvkg,
     st_sgmnt      TYPE ukmbp_cms_sgm,
     i_output      TYPE STANDARD TABLE OF ty_output,
     i_ccl_001     TYPE STANDARD TABLE OF zcds_ccl_001,
     i_listheader  TYPE slis_t_listheader,
     st_listheader TYPE slis_listheader,
     st_output     TYPE ty_output,
     i_list        TYPE vrm_values,
     st_list       TYPE vrm_value.

CONSTANTS:c_y TYPE char1 VALUE 'Y',
          c_n TYPE char1 VALUE 'N'.
