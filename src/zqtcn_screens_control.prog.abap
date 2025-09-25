*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SCREENS_CONTROL
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912332
* REFERENCE NO:  E075
* DEVELOPER: RKUMAR2 (rkumar2)
* DATE:  11-MAY-2018
* DESCRIPTION: Stop loading 'Bill Plan' and 'Payment Cards' tab for
*              converted orders
*----------------------------------------------------------------------*

  TYPES: BEGIN OF ty_legacy_ord,
           sign TYPE tvarv_sign,       "ABAP: ID: I/E (include/exclude values)
           opti TYPE tvarv_opti,       "ABAP: Selection option (EQ/BT/CP/...)
           low  TYPE vsnmr_v,          "Lower Value of legacy info
           high TYPE vsnmr_v,          "Upper Value of legacy info
         END OF ty_legacy_ord,

         BEGIN OF ty_user,
           sign TYPE tvarv_sign,      "ABAP: ID: I/E (include/exclude values)
           opti TYPE tvarv_opti,      "ABAP: Selection option (EQ/BT/CP/...)
           low  TYPE syst_uname,      "Lower Value of exceptional users
           high TYPE syst_uname,      "Upper Value of Selection Condition
         END OF ty_user,

         tt_legacy_ord TYPE STANDARD TABLE OF ty_legacy_ord,
         tt_user       TYPE STANDARD TABLE OF ty_user.

  DATA: lr_legacy_ord TYPE tt_legacy_ord,
        lr_user       TYPE tt_user,
        li_const_e075 TYPE zcat_constants.

  CONSTANTS:
    c_legacy_ord TYPE rvari_vnam VALUE 'LEGACY_ORDER',
    c_users      TYPE rvari_vnam VALUE 'USERS'.

*     Retrieve the Constant values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_wricef_id_e075                             "Development ID (E134)
    IMPORTING
      ex_constants = li_const_e075.                            "Constant Values

  LOOP AT li_const_e075 ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
*       Range: Legacy order
      WHEN c_legacy_ord.
        APPEND INITIAL LINE TO lr_legacy_ord ASSIGNING FIELD-SYMBOL(<lst_legacy_ord>).
        <lst_legacy_ord>-sign = <lst_constant>-sign.       "ABAP: ID: I/E (include/exclude values)
        <lst_legacy_ord>-opti = <lst_constant>-opti.       "ABAP: Selection option (EQ/BT/CP/...)
        <lst_legacy_ord>-low  = <lst_constant>-low.        "Lower Value of Selection Condition
        <lst_legacy_ord>-high = <lst_constant>-high.       "Upper Value of Selection Condition
        UNASSIGN: <lst_legacy_ord>.
*       Range: users with exception
      WHEN c_users.
        APPEND INITIAL LINE TO lr_user ASSIGNING FIELD-SYMBOL(<lst_users>).
        <lst_users>-sign = <lst_constant>-sign.       "ABAP: ID: I/E (include/exclude values)
        <lst_users>-opti = <lst_constant>-opti.       "ABAP: Selection option (EQ/BT/CP/...)
        <lst_users>-low  = <lst_constant>-low.        "Lower Value of Selection Condition
        <lst_users>-high = <lst_constant>-high.       "Upper Value of Selection Condition
        UNASSIGN: <lst_users>.

      WHEN OTHERS.
*         Nothing to do
    ENDCASE.
  ENDLOOP.

  IF vbak-vsnmr_v IN lr_legacy_ord AND
     sy-uname NOT IN lr_user.
    CASE sy-tcode.
      WHEN 'VA02'.
      WHEN 'VA42'.
        IF fcode = 'PFPL' OR fcode = 'KRPL'.
*          MESSAGE 'This tab is not allowed for converted orders. Please use VA43 to view this data.' TYPE 'I'.
          MESSAGE ID 'ZQTC_R2' TYPE 'I' NUMBER 247.
          fcode = old_fcode.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDIF. "legacy order check
