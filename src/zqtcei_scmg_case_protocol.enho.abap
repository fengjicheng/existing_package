CLASS lcl_zqtcei_scmg_case_protocol DEFINITION DEFERRED.
CLASS cl_scmg_case_protocol DEFINITION LOCAL FRIENDS lcl_zqtcei_scmg_case_protocol.
CLASS lcl_zqtcei_scmg_case_protocol DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zqtcei_scmg_case_protocol. "#EC NEEDED
    DATA core_object TYPE REF TO cl_scmg_case_protocol .    "#EC NEEDED
 INTERFACES  IPO_ZQTCEI_SCMG_CASE_PROTOCOL.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO cl_scmg_case_protocol OPTIONAL.
ENDCLASS.
CLASS lcl_zqtcei_scmg_case_protocol IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipo_zqtcei_scmg_case_protocol~get_special_act_list.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods GET_SPECIAL_ACT_LIST
*"  changing
*"    !EX_SPECIAL_LIST type SRMPT_PROTO_ACT_DESC_TAB .
*"------------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: METH_SEND_CRDT_APPL_LETTER (Class Method)
* PROGRAM DESCRIPTION: Send Credit Application Letter
* Add Activity ID and It's Description for Credit Application Letter
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   01/06/2017
* OBJECT ID: F014
* TRANSPORT NUMBER(S):  ED2K904034
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

    APPEND INITIAL LINE TO ex_special_list ASSIGNING FIELD-SYMBOL(<lst_opr_desc>).
    <lst_opr_desc>-act_id = cl_scmg_case_protocol=>c_credit_appl_letter.
    <lst_opr_desc>-log_level = 3.
    <lst_opr_desc>-act_otr_ref = 'ZQTC/CREDIT_APPL_LETTER'.
    <lst_opr_desc>-db_update_mode = if_srm=>db_update.

  ENDMETHOD.
ENDCLASS.
