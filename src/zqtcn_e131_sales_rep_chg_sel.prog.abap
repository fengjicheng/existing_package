*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_E131_SALES_REP_CHG_SEL
* PROGRAM DESCRIPTION:This enhancement will change the sales rep
* after the order has been billed. Individual orders will be manually
* changed, however, mass changes will be allowed through this enhancement.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E131_SALES_REP_CHG_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-005.
SELECT-OPTIONS: s_vkorg FOR v_vkorg,                         " Sales Organization
                s_kunnr FOR v_kunnr,                         " Customer Number
                s_fkdat FOR v_fkdat OBLIGATORY NO-EXTENSION, " Billing date for billing index and printout
*** BOC: CR#7764 KKRAVURI20181220  ED2K914088
                s_auart FOR v_auart NO INTERVALS.
*** EOC: CR#7764 KKRAVURI20181220  ED2K914088
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003 .
PARAMETERS :p_srep1  TYPE persno MATCHCODE OBJECT prem, " Standard Selections for HR Master Data Reporting
            p_nsrep1 TYPE persno MATCHCODE OBJECT prem,    " Standard Selections for HR Master Data Reporting
            p_srep2  TYPE persno MATCHCODE OBJECT prem,    " Standard Selections for HR Master Data Reporting
            p_nsrep2 TYPE persno MATCHCODE OBJECT prem.    " Standard Selections for HR Master Data Reporting
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004 .
PARAMETERS :     p_land1 TYPE t005s-land1. " Country Key
SELECT-OPTIONS : s_bland FOR v_bland,     " Region (State, Province, County)
                 s_pcode FOR v_post_code. " City postal code
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN END OF BLOCK b1.
