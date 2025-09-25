*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_REJCT_DATA_DECL
* PROGRAM DESCRIPTION:Data Declaration for Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-11-10
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
TYPES: BEGIN OF ty_kotg501,
         kappl TYPE kappl,   " Application
         kschl TYPE kschg ,  "  Material listing/exclusion type
         land1 TYPE land1,   "  Country of Destination
         matnr TYPE matnr ,  "  Material Number
         datbi TYPE kodatbi, " Validity end date of the condition record
         datab TYPE kodatab, " Validity start date of the condition record
       END OF ty_kotg501,
       BEGIN OF ty_kotg001,
         kappl TYPE kappl,   " Application
         kschl TYPE kschg ,  "  Material listing/exclusion type
         kunnr TYPE kunnr_v, "  Customer number
         matnr TYPE matnr ,  "  Material Number
         datbi TYPE kodatbi, " Validity end date of the condition record
         datab TYPE kodatab, " Validity start date of the condition record
       END OF ty_kotg001,
** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
       BEGIN OF ty_kotg509,
         kappl TYPE kappl,   " Application
         kschl TYPE kschg ,  "  Material listing/exclusion type
         kdgrp TYPE kdgrp,   "  Customer group
         matnr TYPE matnr ,  "  Material Number
         datbi TYPE kodatbi, " Validity end date of the condition record
         datab TYPE kodatab, " Validity start date of the condition record
       END OF ty_kotg509,
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
** Begin Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
       BEGIN OF ty_sub_tot,
         kposn TYPE kposn, " Condition item number
         worke TYPE kwert, " Condition Value - Subtotal E
         workg TYPE kwert, " Condition Value - Subtotal G
       END OF ty_sub_tot,
** End Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
       BEGIN OF ty_const,
         devid  TYPE zdevid,              " Development ID
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_const.
DATA: v_lifsk_01 TYPE vbak-lifsk, " Variable for Delivery block (document header): scenario 2
**** Begin of change: SRBOSE: 27-JUN-2017: ED2K906739
      v_delivery TYPE vbak-lifsk, " Variable for Delivery block (document header): scenario 3
      v_billing  TYPE vbak-faksk, " Billing block in SD document
**** End of change: SRBOSE: 27-JUN-2017: ED2K906739
      v_abgru    TYPE char1,       " Variable for flag
      v_lifsk_02 TYPE vbak-lifsk . " Global variable for delivery block: Scenario 2
DATA: i_kotg501  TYPE TABLE OF ty_kotg501   , " Internal table
      i_constant TYPE TABLE OF ty_const,      " Constant table
** Begin Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
      i_kotg509  TYPE TABLE OF ty_kotg509, " Internal table
** End Of Change By SRBOSE on 22-Feb-2017 #TR:ED2K903001
** Begin Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
      i_sub_tot  TYPE SORTED TABLE OF ty_sub_tot INITIAL SIZE 0
                 WITH UNIQUE KEY kposn,
** End Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
      i_kotg001  TYPE TABLE OF ty_kotg001. " Internal table
DATA i_cdshw TYPE STANDARD TABLE OF cdshw INITIAL SIZE 0. " Change documents, formatting table
