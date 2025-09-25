*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_SET_INCOM_LOG_VBAK
* PROGRAM DESCRIPTION:Populate  Incompletion Log
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S)ED2K903147
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *

* Data declaration
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
  lv_address_number TYPE adrc-addrnumber,                           " Address Number
  lv_address_handle TYPE szad_field-handle,                         " Address Handle
  lv_current_state  TYPE xfeld,                                     " Current state
  lv_flag           TYPE char1,                                     " Flag
  lv_telphon        TYPE char1,                                     " fLAG FOR TELEPHON
  lv_ustyp          TYPE xuustyp,                                   " User Type     " (++) PBOSE: W012: 14-03-2017
  li_smtp_table     TYPE STANDARD TABLE OF adsmtp ,                 " SMTP table
  li_tel_table      TYPE STANDARD TABLE OF adtel INITIAL SIZE 0,    " Telephon
  lst_tel_table     TYPE adtel,                                     " Wrok area for Telephon
  li_const          TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0, "Constant internal table
  li_abap_stack     TYPE  abap_callstack,
  li_sys_stack      TYPE  sys_callst,
  lst_cons          TYPE ty_const,
  lv_call_bapi      TYPE char1,
  lst_smtp_table    TYPE adsmtp.                                    " Work Area

*& Constants
CONSTANTS :
  lc_posnr          TYPE  vbap-posnr VALUE '000000', " Item No
  lc_tabnam         TYPE  tbnam_vb   VALUE 'VBAK',   " Table name
  lc_fdnam          TYPE  fdnam_vb   VALUE 'KUNNR',  " Field Name
  lc_statg          TYPE  statg      VALUE '06',     " Status Group
  lc_fcode          TYPE  fcode_fe   VALUE 'KPAR',   " Screen for creating missing data
  lc_textid         TYPE tdid        VALUE 'ZEML',   " Text Id
  lc_yes            TYPE t_bool      VALUE 'X',      " Value 'X'
  lc_adsmtp         TYPE ad_tabtype  VALUE 'ADSMTP', " Table Name
  lc_ag2            TYPE parvw       VALUE 'AG',     " Partner Function
  lc_va25           TYPE char4       VALUE 'VA25',   " VA25
  lc_va45           TYPE char4       VALUE 'VA45',   " VA45
  lc_param1_auart   TYPE rvari_vnam  VALUE 'AUART',  "Order type
  lc_create         TYPE trtyp       VALUE 'V',      " Transaction type
  lc_change         TYPE trtyp       VALUE 'H',      " Transaction type
  lc_new            TYPE char1       VALUE '$',      " New of type CHAR1
  lc_telephon       TYPE ad_tabtype  VALUE  'ADTEL', " Table COMM_TABLE structure name
  lc_not_mobile_def TYPE  adr2-r3_user VALUE '1',    "*904i
  lc_mobile         TYPE  adr2-r3_user VALUE '2',    "*904i
  lc_mobile_def     TYPE adr2-r3_user VALUE '3',     "*904i
  lc_devid_e111     TYPE zdevid      VALUE 'E111',   "Development ID
  lc_eventtype      TYPE char12      VALUE 'FUNC', " Function
  lc_sd             TYPE char2       VALUE 'SD'      , " SD function module
  lc_dialog_a       TYPE xuustyp     VALUE 'A'.      " User Type    " (++) PBOSE: W012: 14-03-2017

*& Only for on line transaction

IF ( sy-binpt = space AND sy-batch = space ) AND ( call_bapi EQ space ). " AND ( sy-tcode <> lc_va25
  " AND sy-tcode <> lc_va45 ) . "  Batch Input Processing Active

*& It would not be called during any DS FM called
  CALL FUNCTION 'SYSTEM_CALLSTACK'
    IMPORTING
      callstack    = li_abap_stack
      et_callstack = li_sys_stack.
*& No need of binary as no of entries would be less
  READ TABLE li_sys_stack TRANSPORTING NO FIELDS
    WITH KEY eventtype      =  lc_eventtype
             eventname+0(2) = lc_sd. "'ZTEST_NP'.   "Your Program name
  IF sy-subrc = 0.
    lv_call_bapi = abap_true.
    ENDIF.
  IF lv_call_bapi IS INITIAL.


*&If X, Gui is avaibale

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
*& Binary search not required as there are few entries
      READ TABLE li_const INTO lst_cons WITH KEY devid = lc_devid_e111
                                                  param1 = lc_param1_auart
                                                  low = vbak-auart
                                                  BINARY SEARCH
                                                  TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
*& Read sold-to-party address
        READ TABLE  xvbpa WITH KEY parvw =   lc_ag2.
        IF sy-subrc = 0.
          lv_address_number = xvbpa-adrnr.
        ENDIF. " IF sy-subrc = 0
        FIND FIRST OCCURRENCE OF lc_new IN lv_address_number.
        IF sy-subrc = 0.
          lv_address_handle = lv_address_number.
          CLEAR lv_address_number.
        ENDIF. " IF sy-subrc = 0

        lv_current_state = abap_true.
        CALL FUNCTION 'ADDR_COMM_GET'
          EXPORTING
            address_handle    = lv_address_handle
            address_number    = lv_address_number
            table_type        = lc_adsmtp        "'ADSMTP'
            iv_current_state  = lv_current_state "*981i
          TABLES
            comm_table        = li_smtp_table
          EXCEPTIONS
            parameter_error   = 1
            address_not_exist = 2
            internal_error    = 3
            address_blocked   = 4
            OTHERS            = 99.
        IF sy-subrc <> 0.
*& If no entry found then pass value 1 to identify email
          lv_flag = 1.
        ENDIF. " IF sy-subrc <> 0
*& If no SMTP address found then pass flag = 1 as  flag for email id check
        READ TABLE li_smtp_table INTO lst_smtp_table INDEX 1 TRANSPORTING smtp_addr.
        IF lst_smtp_table-smtp_addr IS NOT INITIAL.
          CLEAR lv_flag.
        ELSE. " ELSE -> IF lst_smtp_table-smtp_addr IS NOT INITIAL
          lv_flag = 1.
        ENDIF. " IF lst_smtp_table-smtp_addr IS NOT INITIAL
        IF lv_flag IS INITIAL.
          CALL FUNCTION 'ADDR_COMM_GET'
            EXPORTING
              address_handle    = lv_address_handle
              address_number    = lv_address_number
              table_type        = lc_telephon      "'ADTEL'
              iv_current_state  = lv_current_state "*981i
            TABLES
              comm_table        = li_tel_table
            EXCEPTIONS
              parameter_error   = 1
              address_not_exist = 2
              internal_error    = 3
              address_blocked   = 4
              OTHERS            = 99.
          IF sy-subrc <> 0.
            CLEAR lv_flag.
          ELSE. " ELSE -> IF sy-subrc <> 0
*& Itiration on the internal table to find    if telephon exist
*& if exist cleare the flag and continue
*& If  doest not exist then pass value '2' to identify as telephpon check
            DELETE li_tel_table WHERE r3_user <> lc_not_mobile_def.
            IF li_tel_table[] IS NOT INITIAL.
              CLEAR lv_flag.
            ELSE.
              lv_flag = 2.
            ENDIF.
*          LOOP AT li_tel_table INTO lst_tel_table.
*            IF lst_tel_table-r3_user = lc_not_mobile_def .
*              CLEAR lv_flag.
*              RETURN.
*            ELSE. " ELSE -> IF lst_tel_table-r3_user = lc_not_mobile_def
*              lv_flag = 2.
*
*            ENDIF. " IF lst_tel_table-r3_user = lc_not_mobile_def
*          ENDLOOP. " LOOP AT li_tel_table INTO lst_tel_table
*          IF sy-subrc <> 0.
*            lv_flag = 2.
*          ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lv_flag IS INITIAL

* Begin of change: PBOSE: W012: 14-03-2017
        SELECT SINGLE ustyp " User Type
          INTO lv_ustyp
          FROM usr02        " Logon Data (Kernel-Side Use)
          WHERE bname EQ sy-uname.
        IF sy-subrc NE 0.
          CLEAR lv_ustyp.
        ENDIF. " IF y-subrc NE 0
* End of change: PBOSE: W012: 14-03-2017

*& The flag is not set, i,e is no email address set for sold-to-party
*& then throw incompletion log



        IF ( lv_flag IS NOT INITIAL ) AND
          ( t180-trtyp = lc_create OR t180-trtyp = lc_change )
          AND lv_ustyp EQ lc_dialog_a.   " (++) PBOSE: W012: 14-03-2017


          CALL FUNCTION 'ZQTC_POP_UP_TO_INFORM'
            EXPORTING
              im_flag = lv_flag.




        ENDIF. " IF ( lv_flag IS NOT INITIAL ) AND
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0
  ENDIF.
ENDIF. " IF ( sy-binpt = space AND sy-batch = space ) AND ( sy-tcode <> lc_va25
