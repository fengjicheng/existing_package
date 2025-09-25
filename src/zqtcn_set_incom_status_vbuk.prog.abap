*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_SET_INCOM_STATUS_VBUK
* PROGRAM DESCRIPTION:Setting status for Incompletion.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S):ED2K903147
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*& Data Declration ---------------------------------------------
TYPES: BEGIN OF ty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const.
DATA:
  lv_address_number TYPE adrc-addrnumber,                             " Address Number
  lv_address_handle TYPE szad_field-handle,                           " Address Handle
  lv_current_state  TYPE xfeld,                                       " Current state
  lv_flag           TYPE char1,                                       " Flag
  li_smtp_table     TYPE STANDARD TABLE OF adsmtp ,                   " SMTP table
  li_const          TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,   "Constant internal table
  lst_const         TYPE ty_const,                                    " Work area for constant table
  lst_smtp_table    TYPE adsmtp,                                      " Work Area
  lst_kuagv         TYPE kuagv.                                       " Sold-to Party View of
*& Constants
CONSTANTS :
  lc_vbak         TYPE string      VALUE '(SAPMV45A)VBAK',    " Constant for memory id
  lc_xvbpa        TYPE string      VALUE '(SAPMV45A)XVBPA[]', " Constant for memory id
  lc_adsmtp       TYPE ad_tabtype  VALUE 'ADSMTP',            " Constant for SMTP table name
  lc_ag2          TYPE parvw       VALUE 'AG',                " Partner Function
  lc_new          TYPE char1       VALUE '$',                 " New entry
  lc_not_proc     TYPE vbuk-uvall  VALUE 'A',
  lc_param1_auart TYPE rvari_vnam  VALUE 'AUART', "Order type
  lc_devid_e111   TYPE zdevid      VALUE 'E111'.  "Development ID

*& Field Symbols
FIELD-SYMBOLS: <lst_kuagv> TYPE kuagv,
               <lst_vbak>  TYPE vbak,
               <li_xvbpa>  TYPE STANDARD TABLE,
               <lst_xvbpa> TYPE vbpavb.

*& Assign from global memory
ASSIGN (lc_vbak) TO <lst_vbak>.
IF <lst_vbak> IS ASSIGNED.


* Get data from constant table
  SELECT devid                      "Development ID
         param1                     "ABAP: Name of Variant Variable
         param2                     "ABAP: Name of Variant Variable
         srno                       "Current selection number
         sign                       "ABAP: ID: I/E (include/exclude values)
         opti                       "ABAP: Selection option (EQ/BT/CP/...)
         low                        "Lower Value of Selection Condition
         high                       "Upper Value of Selection Condition
         activate                   "Activation indicator for constant
         FROM zcaconstant           " Wiley Application Constant Table
         INTO TABLE li_const
         WHERE devid    = lc_devid_e111
         AND   activate = abap_true "Only active record
         ORDER BY devid param1 low.
  IF sy-subrc = 0.
    READ TABLE li_const INTO lst_const WITH KEY devid = lc_devid_e111
                                                param1 = lc_param1_auart
                                                low = <lst_vbak>-auart
                                                BINARY SEARCH
                                                TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
*& Get the Sold to Party details
      ASSIGN (lc_xvbpa) TO <li_xvbpa>.
      IF <li_xvbpa> IS ASSIGNED.
        LOOP AT <li_xvbpa> ASSIGNING <lst_xvbpa>.
          IF <lst_xvbpa>-parvw = lc_ag2.
            lv_address_number = <lst_xvbpa>-adrnr.
            EXIT.
          ENDIF.
        ENDLOOP.
        FIND FIRST OCCURRENCE OF lc_new IN lv_address_number.
        IF sy-subrc = 0.
          lv_address_handle = lv_address_number.
          CLEAR lv_address_number.
        ENDIF.
      ENDIF.
      lv_current_state = abap_true.
      CALL FUNCTION 'ADDR_COMM_GET'
        EXPORTING
          address_handle    = lv_address_handle
          address_number    = lv_address_number
          table_type        = lc_adsmtp "'ADSMTP'
          iv_current_state  = lv_current_state                "*981i
        TABLES
          comm_table        = li_smtp_table
        EXCEPTIONS
          parameter_error   = 1
          address_not_exist = 2
          internal_error    = 3
          address_blocked   = 4
          OTHERS            = 99.
      IF sy-subrc <> 0.
        CLEAR lv_flag.
      ENDIF.
      READ TABLE li_smtp_table INTO lst_smtp_table INDEX 1 TRANSPORTING smtp_addr.
      IF lst_smtp_table-smtp_addr IS NOT INITIAL.
        lv_flag = abap_true.
      ELSE.
        CLEAR lv_flag.
      ENDIF.
*& If no entry found then pass value 'Not Processed"
      IF lv_flag IS INITIAL.
        vbuk-uvall = lc_not_proc.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
