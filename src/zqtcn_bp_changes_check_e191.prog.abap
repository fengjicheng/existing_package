*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BP_CHANGES_CHECK_E191
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924965
* REFERENCE NO: FMM-8
* DEVELOPER:GKAMMILI
* DATE:  11/05/2021
* DESCRIPTION:BP change restriction warning to the user if they try
*             to change the BP for CREDIT/COLLECTION and FI CORRESPONSDENCE
*             related field on BP creation date/BP extension date
* REASON:     In the backend there is a chance of program E191 can
*             overwrite the modified entries if the changes are done
*             on same day as of creatoin/extension
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*-- This validation need to trigger only in forground for BP Transaction
  IF sy-batch EQ space AND sy-tcode = 'BP'.

    TYPES: BEGIN OF lty_const,"
             devid    TYPE zdevid,              " Development id
             param1   TYPE rvari_vnam,          " Parameter
             param2   TYPE rvari_vnam,          " Parameter
             srno     TYPE tvarv_numb,          " Serial number
             sign     TYPE tvarv_sign,          " Sign
             opti     TYPE tvarv_opti,          " Option
             low      TYPE salv_de_selopt_low,  " Low value
             high     TYPE salv_de_selopt_high, " High Value
             activate TYPE zconstactive,        " Activate
           END OF lty_const,
           ltt_const TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0.

    DATA: li_const  TYPE ltt_const,         " Internal table for Constant
          lst_const TYPE lty_const.         " Workarea for Constant

*-- Local declarations
    DATA: lv_res,
          lst_kna1                    TYPE kna1,
          lo_partner                  TYPE REF TO cl_udm_business_partner,
          li_udm_t_bp_profile_upd     TYPE udm_t_bp_profile_upd,
          li_udmbpprofile_o           TYPE udmbpprofile,
          li_udmbpprofile_n           TYPE udmbpprofile,
          li_udm_t_bp_segment_upd     TYPE udm_t_bp_segment_upd,
          li_vudmbpsegments_o         TYPE TABLE OF vudmbpsegments,
          li_vudmbpsegments_n         TYPE TABLE OF vudmbpsegments,
          li_udm_t_bp_tempassignm_upd TYPE udm_t_bp_tempassignm_upd,
          lv_changed                  TYPE boole_d,
          lv_chg_udm                  TYPE bu_xchng,
          lv_chg_ukm                  TYPE bus000flds-xchng,
          lst_knb1_n                  TYPE knb1,
          lst_knb1_o                  TYPE knb1,
          lst_ukmbp_cms               TYPE ukmbp_cms,
          lst_return                  TYPE bapiret2,
          lt_knb5_n                   TYPE STANDARD TABLE OF knb5,
          lt_knb5_o                   TYPE STANDARD TABLE OF knb5,
          lt_busdata_x                TYPE STANDARD TABLE OF busdata,
          lv_dun_flag                 TYPE flag,
          v_flname                    TYPE char12,
          lv_value_1                  TYPE char20,
          lv_value_2                  TYPE char20,
          lv_knb1_flag                TYPE flag.


    CONSTANTS: lc_const_kna1    TYPE char100      VALUE '(SAPLCVI_FS_UI_CUSTOMER)GS_KNA1',
               lc_const_ref     TYPE char100      VALUE '(SAPLUKM_BUPA_01)GO_BUPA_FACTORY',
               lc_devid         TYPE zdevid       VALUE 'E191',
               lc_bp_popup_knb1 TYPE rvari_vnam   VALUE 'BP_POPUP_KNB1',    " ABAP: Name of Variant Variable - Parameter 1
               lc_fields        TYPE rvari_vnam   VALUE 'FIELDS'.    " ABAP: Name of Variant Variable - Parameter 1

    FIELD-SYMBOLS: <lst_kna1>        TYPE kna1,
                   <lo_bupa_factory> TYPE REF TO cl_ukm_bupa_factory,
                   <lst_knb1_o>      TYPE knb1,
                   <lst_knb1_n>      TYPE knb1.

    CLEAR:lv_chg_udm,lv_chg_ukm,lv_dun_flag,
          lst_knb1_n,lt_knb5_n[],lt_knb5_o[],
          et_return[],lst_knb1_o,lv_knb1_flag,
          li_const[].

*-- Get KNB1 data from runtime
    CALL FUNCTION 'CVIC_BUPA_KNB1_GET'
      IMPORTING
        e_knb1 = lst_knb1_n.
    IF lst_knb1_n IS NOT INITIAL.
      ASSIGN lst_knb1_n TO <lst_knb1_n>.
    ENDIF.

*-- check if the change is happening on same date as creation/extension
    IF lst_knb1_n-erdat = sy-datum.

*-- Get data from constant table: ZCACONSTANT
      IF li_const[] IS INITIAL.
        SELECT devid            " Development ID
               param1           " ABAP: Name of Variant Variable
               param2           " ABAP: Name of Variant Variable
               srno             " Current selection number
               sign             " ABAP: ID: I/E (include/exclude values)
               opti             " ABAP: Selection option (EQ/BT/CP/...)
               low              " Lower Value of Selection Condition
               high             " Upper Value of Selection Condition
               activate         " Activation indicator for constant
               FROM zcaconstant " Wiley Application Constant Table
               INTO TABLE li_const
               WHERE devid    = lc_devid
               AND   activate = abap_true. " Only active record
      ENDIF.

*-- Get KNB1 data from DB to compare the changes only for BUSAB and XAUSZ
      SELECT SINGLE *
                    FROM knb1
                    INTO lst_knb1_o
                    WHERE kunnr = lst_knb1_n-kunnr
                    AND   bukrs = lst_knb1_n-bukrs.
      IF sy-subrc = 0.
        ASSIGN lst_knb1_o TO <lst_knb1_o>.
      ENDIF.

      CLEAR: lv_value_1,lv_value_2.
      IF lst_knb1_o IS NOT INITIAL AND lst_knb1_n IS NOT INITIAL.
        LOOP AT li_const INTO lst_const WHERE param1 = lc_bp_popup_knb1    " 'BP_POPUP_KNB1'
                                        AND   param2 = lc_fields.          " 'FIELDS'.

          IF <lst_knb1_o> IS ASSIGNED.
            v_flname = lst_const-low.    "'BUSAB or XAUSZ.
            ASSIGN COMPONENT  v_flname
               OF STRUCTURE <lst_knb1_o> TO FIELD-SYMBOL(<fs_fldval>).
            IF sy-subrc = 0.
              lv_value_1 =  <fs_fldval>.
            ENDIF.
          ENDIF.
          IF <lst_knb1_n> IS ASSIGNED.
            v_flname = lst_const-low.    "'BUSAB or XAUSZ
            ASSIGN COMPONENT  v_flname
               OF STRUCTURE <lst_knb1_n> TO <fs_fldval>.
            IF sy-subrc = 0.
              lv_value_2 =  <fs_fldval>.
            ENDIF.
          ENDIF.

          IF lv_value_1 NE lv_value_2.
            lv_knb1_flag = abap_true.
          ENDIF.
        ENDLOOP.
      ENDIF.

*-- Get KNA1 data from runtime
      CALL FUNCTION 'CVIC_BUPA_KNA1_GET'
        IMPORTING
          e_kna1 = lst_kna1.

*--- To get the Collection Role data if it got changed on the screen by User
      CALL FUNCTION 'UDM_BUPA_EVENT_XCHNG'
        IMPORTING
          e_xchng = lv_chg_udm.

      ASSIGN (lc_const_ref) TO <lo_bupa_factory>.
      IF <lo_bupa_factory> IS ASSIGNED AND <lo_bupa_factory> IS BOUND.
*--- To get the Credit Role data if it got changed on the screen by User
        CALL FUNCTION 'UKM_BUPA_EVENT_XCHNG'
          IMPORTING
            e_xchng = lv_chg_ukm.

      ENDIF.


      CALL FUNCTION 'CVIC_BUPA_KNB5_GET'
        TABLES
          t_knb5 = lt_knb5_n
          t_data = lt_busdata_x.

*-- Get KNB5 data from DB to compare the changes for respective companycode
      SELECT * FROM knb5 INTO TABLE lt_knb5_o
                    WHERE kunnr = lst_knb1_n-kunnr
                    AND   bukrs = lst_knb1_n-bukrs.
      IF sy-subrc = 0.
        READ TABLE lt_knb5_n INTO DATA(lst_knb5_n)
        WITH KEY kunnr = lst_knb1_n-kunnr
                 bukrs = lst_knb1_n-bukrs.
        IF sy-subrc = 0.
          DELETE lt_knb5_n WHERE bukrs NE lst_knb1_n-bukrs.
        ENDIF.
      ENDIF.
      IF lt_knb5_n[] NE lt_knb5_o[].
        lv_dun_flag = abap_true.
      ENDIF.

*-- Calling pop up only if any of the AR related fields got changed on same date as of BP creation or extension
      IF lst_knb1_n-erdat = sy-datum AND
                                        ( lv_knb1_flag IS NOT INITIAL OR
                                         lv_chg_udm IS NOT INITIAL OR
                                         lv_chg_ukm IS NOT INITIAL OR
                                         lv_dun_flag IS NOT INITIAL ).
        CLEAR:lv_res.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'Confirmation'(001)
            text_question         = 'BP was created/extended today, Would you still like to change?'(002)
            text_button_1         = 'Yes'(003)
            text_button_2         = 'No'(004)
            default_button        = '2'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_res
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
*        MESSAGE 'Choose Appropriate Response'(020) TYPE 'E'.
          MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        IF lv_res = '2'.
          lst_return-type    = 'E'.
          lst_return-id      = 'ZQTC_R2'.
          lst_return-number  = '000'.
          lst_return-message = 'BP not saved'(005).
          APPEND lst_return TO et_return.
          CLEAR:lst_return.
        ENDIF.
      ENDIF.

      UNASSIGN: <lst_knb1_o>.
    ENDIF." if lst_knb1-erdat = sy-datum.
  ENDIF.
