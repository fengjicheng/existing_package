*&---------------------------------------------------------------------*
*&  Include           ZXMEWU05
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZXMEWU05                                         *
* PROGRAM DESCRIPTION : Add-on Check-Creating Reservation UK Core->SAP   *
* DEVELOPER           : SRAMASUBRA (Sankarram R)                         *
* CREATION DATE       : 2022-03-31                                       *
* OBJECT ID           : I0512.1/EAM-8342                                 *
* TRANSPORT NUMBER(S) : ED2K926351                                       *
*------------------------------------------------------------------------*

*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*

DATA:
  lv_active_i0512_1 TYPE          zactive_flag,         "Active / Inactive flag
  lv_reserv_no      TYPE          bapi2093_res_key-reserv_no,      "Reservation No

  li_reserv_itms    TYPE TABLE OF bapi2093_res_item_change,   "Reservation Change Item Table
  li_reserv_itmsx   TYPE TABLE OF bapi2093_res_item_changex,  "Reservation Change ItemX Table
  li_bapi_ret       TYPE TABLE OF bapiret2,                   "Reservation Change ItemX Table

  lst_reserv_itms   TYPE          bapi2093_res_item_change,   "Reservation Change Item Table
  lst_reserv_itmsx  TYPE          bapi2093_res_item_changex   "Reservation Change ItemX Table

  .

*========================================================================*
*                         FIELD SYMBOLS DECLARATIONS                          *
*========================================================================*

FIELD-SYMBOLS:
  <lfs_edidc>       TYPE edidc
  .

*========================================================================*
*                         CONSTANTS DECLARATIONS                          *
*========================================================================*

CONSTANTS:
   lc_i0512_1       TYPE zdevid         VALUE 'I0512.1',  "Constant value for WRICEF (I0512.1)
   lc_ser_nr_001    TYPE zsno           VALUE '001',      "Serial Number (001)
   lc_id_code_typ   TYPE ismidcodetype  VALUE 'ZEAN'      "ID Code Type - ZEAN
   .


ASSIGN ('(SAPMSED7)EDIDC') TO <lfs_edidc>.

* Populate the Idoc Control Record's Msg. Type, Msg. Code, Msg. Function values
IF <lfs_edidc> IS ASSIGNED AND <lfs_edidc> IS NOT INITIAL.
  DATA(lv_res_key) = CONV zvar_key( |{ <lfs_edidc>-mestyp }| && |_| &&
                                    |{ <lfs_edidc>-mescod }| && |_| &&
                                    |{ <lfs_edidc>-mesfct }| ) .
  CONDENSE: lv_res_key.
ENDIF.

IF lv_res_key IS INITIAL.
* Populate the Idoc Control Record's Msg. Type, Msg. Code, Msg. Function values
* processed via BD87
  ASSIGN ('(RBDAPP01)T_IDOC_CONTROL_TMP') TO <lfs_edidc>.
  IF <lfs_edidc> IS ASSIGNED AND <lfs_edidc> IS NOT INITIAL.
    lv_res_key = CONV zvar_key( |{ <lfs_edidc>-mestyp }| && |_| &&
                                |{ <lfs_edidc>-mescod }| && |_| &&
                                |{ <lfs_edidc>-mesfct }| ) .
    CONDENSE: lv_res_key.
  ENDIF.
ENDIF.

* Enhancement Control Check
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_i0512_1         "Constant value for WRICEF (I0512.1)
    im_ser_num     = lc_ser_nr_001      "Serial Number (001)
    im_var_key     = lv_res_key         "Idoc Control Record Partner Profile Key
  IMPORTING
    ex_active_flag = lv_active_i0512_1. "Active / Inactive flag

IF lv_active_i0512_1 EQ abap_on.    "Enhancement is Active
  IF res_items[] IS NOT INITIAL.
*   Get Material No using Idoc data:Items-Id Code from JPTIDCDASSIGN
    SELECT
        matnr,
        idcodetype,
        identcode
      FROM jptidcdassign
      INTO TABLE @DATA(lt_matnr)
      FOR ALL ENTRIES IN @res_items
      WHERE idcodetype = @lc_id_code_typ
      AND   identcode  = @res_items-material.
    IF sy-subrc = 0.
      SORT lt_matnr BY identcode.
    ENDIF.
  ENDIF.

  LOOP AT res_items ASSIGNING FIELD-SYMBOL(<lfst_res_itm>).
*   Check Material No using Idoc data:Items-Id Code from JPTIDCDASSIGN
    READ TABLE lt_matnr INTO DATA(ls_matnr)
      WITH KEY identcode = <lfst_res_itm>-material
      BINARY SEARCH.
    IF ls_matnr-matnr IS INITIAL.
      DATA(lv_matnr) = <lfst_res_itm>-material.
    ELSE.
      lv_matnr = ls_matnr-matnr.
    ENDIF.
*   Check for existence in RESB - Then mark that record for deletion
    SELECT
        rsnum,    "Reservation No
        rspos,    "Reservation Item No
        lgort,    "Storage Location
        charg,    "Batch No
        erfmg,    "Quantity UoE
        bdter,    "Req. Date
        sgtxt,    "Item Text
        wempf,    "Goods Receipient/Ship To
        ablad,    "Unloading Point
        fmeng,    "Fixed Qty.
        xwaok,    "Goods Movement for Reservation Allowed
        xloek,    "Deletion Ind.
        kzear,    "Final Issue for This Reservation
        matnr,    "Material No
        werks,    "Plant
        bwart,    "Movement Type
        prio_urg, "Requirement Urgency
        prio_req, "Requirement Priority
        sgt_scat, "Stock Segment
        sgt_rcat  "Requirement Segment
      FROM resb
      INTO  TABLE @DATA(li_resb)
      WHERE matnr = @lv_matnr
      AND   werks = @res_header-plant
      AND   bwart = @res_header-move_type
      AND   xloek = @space.
    IF sy-subrc <> 0.
      REFRESH: li_resb.
    ENDIF.
    LOOP AT li_resb INTO DATA(lst_resb).
      IF lst_resb-xloek IS INITIAL AND lst_resb-kzear IS INITIAL.
        CLEAR: lst_reserv_itms, lv_reserv_no,
               lst_reserv_itmsx.

        lv_reserv_no = lst_resb-rsnum.

        lst_reserv_itms-res_item          = lst_resb-rspos.
        lst_reserv_itms-stge_loc          = lst_resb-lgort.
        lst_reserv_itms-batch             = lst_resb-charg.
        lst_reserv_itms-entry_qnt         = lst_resb-erfmg.
        lst_reserv_itms-req_date          = lst_resb-bdter.
        lst_reserv_itms-item_text         = lst_resb-sgtxt.
        lst_reserv_itms-gr_rcpt           = lst_resb-wempf.
        lst_reserv_itms-unload_pt         = lst_resb-ablad.
        lst_reserv_itms-fixed_quan        = lst_resb-fmeng.
        lst_reserv_itms-movement          = lst_resb-xwaok.
        lst_reserv_itms-delete_ind        = abap_on.
        lst_reserv_itms-withdrawn         = lst_resb-kzear.
        lst_reserv_itms-prio_urgency      = lst_resb-prio_urg.
        lst_reserv_itms-prio_requirement  = lst_resb-prio_req.
        lst_reserv_itms-stk_segment       = lst_resb-sgt_scat.
        lst_reserv_itms-req_segment       = lst_resb-sgt_rcat.

        APPEND lst_reserv_itms TO li_reserv_itms.

        lst_reserv_itmsx-res_item         =  lst_resb-rspos.
        lst_reserv_itmsx-stge_loc         =  abap_on.
        lst_reserv_itmsx-batch            =  abap_on.
        lst_reserv_itmsx-entry_qnt        =  abap_on.
        lst_reserv_itmsx-req_date         =  abap_on.
        lst_reserv_itmsx-item_text        =  abap_on.
        lst_reserv_itmsx-gr_rcpt          =  abap_on.
        lst_reserv_itmsx-unload_pt        =  abap_on.
        lst_reserv_itmsx-fixed_quan       =  abap_on.
        lst_reserv_itmsx-movement         =  abap_on.
        lst_reserv_itmsx-delete_ind       =  abap_on.
        lst_reserv_itmsx-withdrawn        =  abap_on.
        lst_reserv_itmsx-prio_urgency     =  abap_on.
        lst_reserv_itmsx-prio_requirement =  abap_on.
        lst_reserv_itmsx-stk_segment      =  abap_on.
        lst_reserv_itmsx-req_segment      =  abap_on.

        APPEND lst_reserv_itmsx TO li_reserv_itmsx.

*       Call Reservation Change BAPI to mark it deleted
        CALL FUNCTION 'BAPI_RESERVATION_CHANGE'
          EXPORTING
            reservation                 = lv_reserv_no
          TABLES
            reservationitems_changed    = li_reserv_itms
            reservationitems_changedx   = li_reserv_itmsx
            return                      = li_bapi_ret .

        LOOP AT li_bapi_ret ASSIGNING FIELD-SYMBOL(<lfs_ret>)
          WHERE type = sy-abcde+4(1).
          DATA(lv_error) = abap_on.
          EXIT.
        ENDLOOP.
        IF lv_error IS INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait   = abap_on .
        ELSE.
          TRY.
            RAISE EXCEPTION TYPE cx_demo_t100.
          CATCH cx_demo_t100 INTO DATA(lo_ref).
            MESSAGE
            ID      <lfs_ret>-id
            TYPE    <lfs_ret>-type
            NUMBER  <lfs_ret>-number
            WITH    <lfs_ret>-message_v1 <lfs_ret>-message_v2
                    <lfs_ret>-message_v3 <lfs_ret>-message_v4.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDLOOP.
*   Update ISBN Material from Idoc to the mapped IS Assignment Table Material
*   so that the Create Reservations will proceed without errors
    <lfst_res_itm>-material = lv_matnr.
  ENDLOOP.
ENDIF.
