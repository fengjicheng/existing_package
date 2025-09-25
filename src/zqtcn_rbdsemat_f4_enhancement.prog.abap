*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_RBDSEMAT_F4_ENHANCEMENT                  *
* PROGRAM DESCRIPTION:  Include for RBDSEMAT for Enhancing the F4 help *
* DEVELOPER:            Sarada Mukherjee                               *
* CREATION DATE:        01/12/2017                                     *
* OBJECT ID:            I0204                                          *
* TRANSPORT NUMBER(S):  ED2K904106                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RBDSEMAT_F4_ENHANCEMENT
*&---------------------------------------------------------------------*
*====================================================================*
* Local Types
*====================================================================*
TYPES: BEGIN OF ty_zcaconstant,
         devid    TYPE zdevid,              " Development ID
         param1	  TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2	  TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno	    TYPE tvarv_numb,          " ABAP: Current selection number
         sign	    TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti	    TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high	    TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         activate	TYPE zconstactive,
       END OF ty_zcaconstant.

*====================================================================*
* Local Work-area
*====================================================================*
DATA: lst_zcaconstant TYPE ty_zcaconstant.
*====================================================================*
* Local Constants
*====================================================================*
CONSTANTS: lc_devid  TYPE zdevid     VALUE 'I0204',    " Development ID
           lc_param1 TYPE rvari_vnam VALUE 'MSG_TYPE', " ABAP: Name of Variant Variable
           lc_param2 TYPE rvari_vnam VALUE 'OUTBOUND', " ABAP: Name of Variant Variable
           lc_srno   TYPE tvarv_numb VALUE '01'.       " ABAP: Current selection number

CLEAR lst_zcaconstant.
* Get the Message type from the constant table
SELECT SINGLE devid                      " Development ID
              param1                     " ABAP: Name of Variant Variable
              param2                     " ABAP: Name of Variant Variable
              srno                       " ABAP: Current selection number
              sign                       " ABAP: ID: I/E (include/exclude values)
              opti                       " ABAP: Selection option (EQ/BT/CP/...)
              low                        " Lower Value of Selection Condition
              high                       " Upper Value of Selection Condition
              activate                   " Activation indicator for constant
              FROM zcaconstant           " Wiley Application Constant Table
              INTO lst_zcaconstant
              WHERE devid      = lc_devid  " Development ID
              AND   param1     = lc_param1 " ABAP: Name of Variant Variable
              AND   param2     = lc_param2 " ABAP: Name of Variant Variable
              AND   srno       = lc_srno . " ABAP: Current selection number
IF sy-subrc IS INITIAL.
  APPEND lst_zcaconstant-low TO mestyp_list_mat.
ENDIF.
