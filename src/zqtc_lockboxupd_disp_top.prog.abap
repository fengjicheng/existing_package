*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_LOCKBOXUPD_DISP_TOP
* PROGRAM DESCRIPTION: To Display Lockbox ZQTCLOCKBOX_UPD Table Data
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 18/03/2019
* OBJECT ID: INC0235034
* TRANSPORT NUMBER(S): ED1K909832
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911226
* REFERENCE NO:  ERPM-3463
* DEVELOPER: GKAMMILI
* DATE:  10/25/2019
* DESCRIPTION:Adding two fields(contract and billing document) to rport
*             outpu
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911298
* REFERENCE NO:  ERPM-3463
* DEVELOPER: GKAMMILI
* DATE:  11/07/2019
* DESCRIPTION:Adding Reason code in selection screen and providing
*             Variant save option in the output
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_LOCKBOXUPD_DISP_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.  " SLIS contains all the ALV data types

*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
*-- Types declarations
TYPES: BEGIN OF ty_vbfa,
         vbelv   TYPE vbfa-vbelv,
         vbeln   TYPE vbfa-vbeln,
         vbtyp_n TYPE vbfa-vbtyp_n,
       END OF ty_vbfa.
TYPES: BEGIN OF ty_final.
         INCLUDE STRUCTURE zqtclockbox_upd.
TYPES:   zvbeln_s TYPE vbeln_va,
         zvbeln_b TYPE vbeln_vf,
       END OF ty_final.
TYPES:BEGIN OF ty_rcode,
        reason_code TYPE zqtclockbox_upd-reason_code,
      END OF ty_rcode.
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM- 3463

***Global data declaration
data : v_augdt type ZQTCLOCKBOX_UPD-AUGDT, "Clearing Date
       v_belnr type ZQTCLOCKBOX_UPD-BELNR, "Document No
       v_bukrs type ZQTCLOCKBOX_UPD-bukrs, "Company Code
       v_kunnr type ZQTCLOCKBOX_UPD-KUNNR, "Customer No
       v_rcode TYPE zqtclockbox_upd-reason_code,  "Reason Code "Added by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
       v_col_pos       TYPE i,
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
***Internal table Declaration
       i_lockbox  type STANDARD TABLE OF ZQTCLOCKBOX_UPD,
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
      i_final     TYPE STANDARD TABLE OF ty_final,
      i_vbfa      TYPE STANDARD TABLE OF ty_vbfa,
      i_rcode     TYPE STANDARD TABLE OF ty_rcode,
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM- 3463

***Work Area Declaration
       st_lockbox type ZQTCLOCKBOX_UPD,
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
      st_final    TYPE  ty_final,
      st_vbfa     TYPE  ty_vbfa,
      st_rcode    TYPE  ty_rcode,
*-- EOI by GKAMMILI on 25/10/2019 fTR-ED1K911226 Jar ERPM- 3463

*** ALV Declarations
       i_fieldcat  TYPE slis_t_fieldcat_alv,
       st_fieldcat  TYPE slis_fieldcat_alv.
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
CONSTANTS:c_contract TYPE vbtyp_n VALUE 'G',
          c_billing  TYPE vbtyp_n VALUE 'M'.
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
