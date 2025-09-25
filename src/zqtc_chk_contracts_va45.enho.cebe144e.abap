"Name: \TY:CL_SDOC_VIEW\ME:AT_SELECTION_SCREEN\SE:BEGIN\EI
ENHANCEMENT 0 ZQTC_CHK_CONTRACTS_VA45.
*----------------------------------------------------------------------*
*Enhancement details
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : control editing legacy to SAP converted
*                      contracts using VA45
* DEVELOPER: Randheer Kumar
* CREATION DATE:  May 11th, 2018
* OBJECT ID:  E075, seq#11
* TRANSPORT NUMBER(S): ED1K907232
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915044
* REFERENCE NO: DM-1791
* DEVELOPER:  Prabhu(PTUFARAM)
* DATE:  2016-09-12
* DESCRIPTION:Enhanced Layout parameter on selection screen of ZQTC_VA45
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910257
* REFERENCE NO: INC0245900
* DEVELOPER: Prabhu
* DATE:  5/31/2019
* DESCRIPTION: Layout F4 help
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Layout F4 help for ZQTC_VA05 on selection screen
*----------------------------------------------------------------------*
  types: BEGIN OF ty_legacy_ord,
          sign TYPE tvarv_sign,            "ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,            "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vsnmr_v,               "Lower Value of Selection Condition
          high TYPE vsnmr_v,               "Upper Value of Selection Condition
        END OF ty_legacy_ord,

        BEGIN OF ty_vbeln,
          sign TYPE tvarv_sign,            "ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,            "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vbeln,                 "Lower Value of Selection Condition
          high TYPE vbeln,                 "Upper Value of Selection Condition
        END OF ty_vbeln,

        tt_legacy_ord TYPE STANDARD TABLE OF ty_legacy_ord,
        tt_vbeln      TYPE STANDARD TABLE OF ty_vbeln.

  CONSTANTS: c_DEVID_e075 type ZDEVID VALUE 'E075',         "enhancement ID
             c_ser_num_11_e075 TYPE zsno     VALUE '011',   " enh Serial Number
             c_legacy_ord TYPE RVARI_VNAM VALUE 'LEGACY_ORDER',
             c_users TYPE RVARI_VNAM VALUE 'USERS',
             c_va05  TYPE char4      VALUE 'VA05'.       "NPOLINA 08/13/2019 DM7836 ED2K915777

DATA: lt_constant     TYPE TABLE OF zcaconstant,
      lr_legacy_ord  TYPE tt_legacy_ord,     "Range: Legacy order type.
      ls_orders      TYPE char40  VALUE '(SD_SALES_DOCUMENT_VA45)SVBELN[]',
      ls_layout      TYPE char40 VALUE '(SD_SALES_DOCUMENT_VA45)P_LAYOUT',
      ls_layout_05   TYPE char40 VALUE '(SD_SALES_DOCUMENT_VIEW)P_LAYOUT',  " NPOLINA ED2K915777 DM7836
      lv_actv_flag_e075 TYPE zactive_flag,           " Active / Inactive Flag
      lv_varkey TYPE zvar_key,

      BEGIN OF ls_vbak,
       vbeln TYPE vbeln,
       vsnmr_v TYPE vsnmr_v,
      end of ls_vbak  .

FIELD-SYMBOLS: <fs_orders> TYPE tt_vbeln,
*--*Begin of change by Prabhu for DM-1791 TR#ED2K915044 5/15/2019
               <fs_layout> TYPE disvariant-variant.".
*--*End of change by Prabhu for DM-1791 TR#ED2K915044 5/15/2019
lv_varkey = sy-tcode.
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = c_DEVID_e075
    im_ser_num     = c_ser_num_11_e075
    IM_VAR_KEY     = lv_varkey
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
 ASSIGN (ls_orders) TO <fs_orders>.
  IF <fs_orders> IS not ASSIGNED.
    " if any document doesn't exist.. no use to make further checks
    RETURN.
    ELSE.
      if <fs_orders> IS INITIAL.
        RETURN.
        else.
      "get the source
       SELECT vbeln,
              vsnmr_v FROM vbak
                      INTO TABLE @DATA(lt_vbak)
                      WHERE vbeln in @<fs_orders>.
      endif.
  ENDIF.

    SELECT *
      FROM zcaconstant
      INTO TABLE lt_constant
     WHERE devid    EQ c_DEVID_e075                      "Development ID: E075
       AND activate EQ abap_true.                        "Active Entry
    IF sy-subrc EQ 0.
      SORT lt_constant BY param1 param2.
    ENDIF.

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
      WHEN OTHERS.
*         Nothing to do
    ENDCASE.
  ENDLOOP.

  LOOP AT lt_vbak INTO ls_vbak WHERE vsnmr_v in lr_legacy_ord.
  "looks like converted orders are entered
*    MESSAGE 'One or more converted order(s) entered' TYPE 'I'.
    MESSAGE ID 'ZQTC_R2' TYPE 'I' NUMBER 246.
    exit.
  ENDLOOP.
ENDIF.
*--*Begin of change by Prabhu for DM-1791 TR#ED2K915044 5/15/2019
ASSIGN (ls_layout) TO <fs_layout>.
IF <fs_layout> IS ASSIGNED.
  IF <fs_layout> IS NOT INITIAL.
    ms_layout-layout = <fs_layout>.
    ms_layout-report = 'SD_SALES_DOCUMENT_VA45'."sy-repid.
  ENDIF.
ENDIF.

*--SOC NPOLINA 08/13/2019 DM7836 ED2K915777
IF sy-tcode cs c_va05 AND sy-subrc NE 0.
ASSIGN (ls_layout_05) TO <fs_layout>.
IF <fs_layout> IS ASSIGNED.
  IF <fs_layout> IS NOT INITIAL.
    ms_layout-layout = <fs_layout>.
    ms_layout-report = 'SD_SALES_DOCUMENT_VIEW'."sy-repid.
  ENDIF.
ENDIF.
ENDIF.
*--EOC NPOLINA 08/13/2019 DM7836 ED2K915777

*--*End of change by Prabhu for DM-1791 TR#ED2K915044 5/15/2019
ENDENHANCEMENT.
