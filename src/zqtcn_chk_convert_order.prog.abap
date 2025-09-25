*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHK_CONVERT_ORDER
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : control editing legacy to SAP converted
*                      orders/ contracts in va02 & va42
* DEVELOPER: Randheer Kumar
* CREATION DATE:  May 11th, 2018
* OBJECT ID:  E075, seq#12
* TRANSPORT NUMBER(S): ED2K912332
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

  CONSTANTS: lc_devid_e075 TYPE zdevid     VALUE 'E075',
             c_legacy_ord  TYPE rvari_vnam VALUE 'LEGACY_ORDER',
             c_users       TYPE rvari_vnam VALUE 'USERS',
             c_va43        TYPE char4      VALUE 'VA43',
             c_a           TYPE char1      VALUE 'A',
             c_a43         TYPE char3      VALUE 'A43'.

  DATA: lr_legacy_ord TYPE tt_legacy_ord,
        lr_user       TYPE tt_user,
        li_const_e075 TYPE zcat_constants.

  STATICS: s_t180_original  TYPE t180,
           s_t185f_original TYPE t185f,
           s_t185v_original TYPE t185v.

  "CHECK FOR first time screen sequence or not
  IF s_t180_original IS INITIAL.
    s_t180_original = t180.
    s_t185f_original = t185f.
    s_t185v_original = t185v.
  ENDIF.

* Get data from constant table
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e075
    IMPORTING
      ex_constants = li_const_e075.


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



  "CHECK FOR CONVERTED ORDER
  IF vbak-vsnmr_v IN lr_legacy_ord.
    "yes, legacy order
    IF sy-uname IN lr_user."CHECK FOR USER id'S
      "move normal screens for speical users only
      t180  = s_t180_original.
      t185f = s_t185f_original.
      t185v = s_t185v_original.
    ELSE.
      "       T180 CORRECTION
      t180-tcode = c_va43.    "'VA43'.
      t180-trtyp = c_a.       "'A'.
      t180-aktyp = c_a.       "'A'.
      t180-panel = c_va43.    "'VA43'.

      "       T185F correction
      t185f-trtyp = c_a.      "'A'.
      t185f-aktyp = c_a.      "'A'.

      "       T185V CORRECTION
      t185v-panel = c_va43.   "'VA43'.
      t185v-ctitel = c_a43.   "'A43'.

    ENDIF.

  ELSE.
    "move normal screen navigation
    t180  = s_t180_original.
    t185f = s_t185f_original.
    t185v = s_t185v_original.
  ENDIF.
