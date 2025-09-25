*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILTER_CNVRT_SDOC
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*Enhancement details
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : control processing legacy to SAP converted
*                      contracts using VA45
* DEVELOPER: Randheer Kumar
* CREATION DATE:  May 11th, 2018
* OBJECT ID:  E075, seq#11
* TRANSPORT NUMBER(S): ED2K912332
*----------------------------------------------------------------------*
  TYPES: BEGIN OF ty_legacy_ord,
           sign TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
           opti TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
           low  TYPE vsnmr_v,             "Lower Value of Selection Condition
           high TYPE vsnmr_v,             "Upper Value of Selection Condition
         END OF ty_legacy_ord,

         BEGIN OF ty_user,
           sign TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
           opti TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
           low  TYPE syst_uname,          "Lower Value of Selection Condition
           high TYPE syst_uname,          "Upper Value of Selection Condition
         END OF ty_user,

         BEGIN OF ty_vbeln,
           sign TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
           opti TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
           low  TYPE vbeln,               "Lower Value of Selection Condition
           high TYPE vbeln,               "Upper Value of Selection Condition
         END OF ty_vbeln,

         BEGIN OF ty_vbak_vbeln,
           vbeln TYPE vbeln,
         END OF ty_vbak_vbeln,

         tt_legacy_ord TYPE STANDARD TABLE OF ty_legacy_ord,
         tt_user       TYPE STANDARD TABLE OF ty_user,
         tt_vbeln      TYPE STANDARD TABLE OF ty_vbeln.

  CONSTANTS: c_devid_e075 TYPE zdevid VALUE 'E075',
             c_legacy_ord TYPE rvari_vnam VALUE 'LEGACY_ORDER',
             c_users      TYPE rvari_vnam VALUE 'USERS'.

  DATA: lt_constant   TYPE TABLE OF zcaconstant,
        lr_user       TYPE tt_user,
        lr_legacy_ord TYPE tt_legacy_ord,     "Range: Legacy order type.
        ls_orders     TYPE char40  VALUE '(SD_SALES_DOCUMENT_VA45)SVBELN[]',
        lv_tabix      TYPE sy-tabix,

        BEGIN OF ls_vbak,
          vbeln   TYPE vbeln,
          vsnmr_v TYPE vsnmr_v,
        END OF ls_vbak,
        lt_vbak       LIKE TABLE OF ls_vbak,

        ls_vbak_vbeln TYPE ty_vbak_vbeln,
        lt_vbak_vbeln TYPE TABLE OF ty_vbak_vbeln.

  FIELD-SYMBOLS:
    <lst_result1> TYPE any.            "Result (Structure)

  MOVE-CORRESPONDING ct_result TO lt_vbak_vbeln.

  IF lt_vbak_vbeln IS INITIAL.
    RETURN.
  ELSE.
    "get the source
    SELECT vbeln
           vsnmr_v FROM vbak
                   INTO TABLE lt_vbak
                   FOR ALL ENTRIES IN lt_vbak_vbeln
                   WHERE vbeln = lt_vbak_vbeln-vbeln.
  ENDIF.

  SELECT *
    FROM zcaconstant
    INTO TABLE lt_constant
   WHERE devid    EQ c_devid_e075                      "Development ID: E075
     AND activate EQ abap_true.                        "Active Entry
  IF sy-subrc EQ 0.
    SORT lt_constant BY param1 param2.
  ENDIF.
*  DELETE ct_result INDEX 1.
  LOOP AT lt_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
*       Range: Legacy order
      WHEN c_legacy_ord.
        APPEND INITIAL LINE TO lr_legacy_ord ASSIGNING FIELD-SYMBOL(<lst_legacy_ord>).
        <lst_legacy_ord>-sign = <lst_constant>-sign.       "ABAP: ID: I/E (include/exclude values)
        <lst_legacy_ord>-opti = <lst_constant>-opti.       "ABAP: Selection option (EQ/BT/CP/...)
        <lst_legacy_ord>-low  = <lst_constant>-low.        "Lower Value of Selection Condition
        <lst_legacy_ord>-high = <lst_constant>-high.       "Upper Value of Selection Condition
        UNASSIGN: <lst_legacy_ord>.
*       Range: exceptional users
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

"    check if the order is created from legacy
  LOOP AT lt_vbak INTO ls_vbak.
    lv_tabix = sy-tabix.
    IF ls_vbak-vsnmr_v IN lr_legacy_ord.
      DELETE lt_vbak INDEX lv_tabix.
    ELSE.
      CONTINUE.
    ENDIF.
  ENDLOOP.

"take the decision to filter required lines
  IF lt_vbak IS NOT INITIAL.
    SORT lt_vbak BY vbeln ASCENDING.
    "check if user is execption
    IF sy-uname NOT IN lr_user.
      LOOP AT ct_result ASSIGNING <lst_result1>.
        lv_tabix = sy-tabix.
        MOVE-CORRESPONDING <lst_result1> TO ls_vbak_vbeln.
        READ TABLE lt_vbak WITH KEY vbeln = ls_vbak_vbeln-vbeln
                                    BINARY SEARCH
                                    TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL.
          DELETE ct_result INDEX lv_tabix.
        ENDIF.
      ENDLOOP.

    ELSE.
      "user is under exception for execution, go ahead with regular output
    ENDIF.
  ELSE.
    "all the selected documents are converted orders
    FREE ct_result.
    "nothing to show in output
  ENDIF.
