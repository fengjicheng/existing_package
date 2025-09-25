"Name: \PR:SAPLMEREP\IC:LMEREPTOP\SE:END\EI
ENHANCEMENT 0 ZQTCEI_CUST_FIELDS_E268.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924078
* REFERENCE NO: E268 / OTCM-49256
* DEVELOPER: Thilina Dimantha
* DATE: 12-July-2021
* DESCRIPTION: PO History show incorrect data ME2N ME2M Output
*-----------------------------------------------------------------------*
*Gobal variables
DATA: i_constants_e268        TYPE zcat_constants,
      v_actv_flag_e268_001    TYPE zactive_flag,
      ir_tcode_e268           TYPE RANGE OF syst-tcode.

FIELD-SYMBOLS: <table_cust> TYPE STANDARD TABLE.
ENDENHANCEMENT.
