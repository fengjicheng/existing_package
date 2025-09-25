*&---------------------------------------------------------------------*
*& Report  ZQTCC_EXISTING_CUST_UPDATE
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCC_EXISTING_CUST_UPDATE
* PROGRAM DESCRIPTION:Report for customer update
* DEVELOPER:          WROY(Writtick Roy)
* CREATION DATE:      12/16/2016
* OBJECT ID:          C076
* TRANSPORT NUMBER(S):ED2K903796
*----------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zqtcc_existing_cust_update MESSAGE-ID zqtc_r2.

*===================================================================*
* Includes
*===================================================================*
INCLUDE zqtcn_existing_cust_upd_top IF FOUND.  "Global Declarations
INCLUDE zqtcn_existing_cust_upd_sel IF FOUND.  "Selection Screen
INCLUDE zqtcn_existing_cust_upd_sub IF FOUND.  "Form Routines

*===================================================================*
* I N I T I A L I Z A T I O N
*===================================================================*

INITIALIZATION.
  PERFORM f_clear_all.

* Populate Selection Screen Default Values

  PERFORM f_populate_defaults CHANGING s_erdat[]
                                       s_ktokd[]
                                       p_akont
                                       p_vtweg
                                       p_spart
                                       p_lifsd
                                       p_faksd
                                       s_idtyp[].
*===================================================================*
* S T A R T - O F - S E L E C T I O N
*===================================================================*

START-OF-SELECTION.

* Validation of Selection screen values

  PERFORM f_validate_data.

* Fetch and Process Records

  PERFORM f_fetch_n_process   USING    s_land1[]
                                       p_waers
                                       p_bukrs
                                       s_erdat[]
                                       s_ktokd[]
                                       s_kunnr[]
                                       p_akont
                                       p_vtweg
                                       p_spart
                                       p_lifsd
                                       p_faksd
                                       s_idtyp[].
