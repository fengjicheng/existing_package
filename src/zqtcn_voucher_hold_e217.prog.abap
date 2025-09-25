*&---------------------------------------------------------------------*
*&  Include           ZQTCN_VOUCHER_HOLD_E217
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VOUCHER_HOLD_E217(Include)
*               Called from MV45AFZZ SAVE_DOCUMENT_PREPARE routine"
* PROGRAM DESCRIPTION: Check if order should be put on hold (voucher) from VA02
* DEVELOPER          : murali(MIMMADISET)
* CREATION DATE:     :  10/01/2019
* OBJECT ID:         :  E217/ERPM2213
* TRANSPORT NUMBER(S):ED2K916334
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VOUCHER_HOLD_E217(Include)
*               Called from MV45AFZZ SAVE_DOCUMENT_PREPARE routine"
* PROGRAM DESCRIPTION: (ERPM-4359) ERPM-2073-Hold status check box is not checked by default,
*even the invoice is not create for contract.
* DEVELOPER          : murali(MIMMADISET)
* CREATION DATE:     : 10/22/2019
* OBJECT ID:         : E217/ERPM4359
* TRANSPORT NUMBER(S): ED2K916523
*----------------------------------------------------------------------*
* Type Declaration
TYPES:
  BEGIN OF ty_constant,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF ty_constant,
  BEGIN OF ty_vbrp,
    vbeln TYPE vbeln_vf,
    aubel TYPE vbeln_va,
    aupos TYPE posnr_va,
  END OF ty_vbrp,
  BEGIN OF ty_vbrk,
    vbeln TYPE vbeln_vf,
    fkdat TYPE fkdat,
    bukrs TYPE bukrs,
  END OF ty_vbrk,
  BEGIN OF ty_tj30t,
    stsma TYPE j_stsma,
    estat TYPE j_estat,
  END OF ty_tj30t,
  BEGIN OF ty_item,
    objnr TYPE j_objnr,                    "Object number
    posnr TYPE posnr_vf,                   "Billing item
    aubel TYPE vbeln_va,                   "Sales Document
    aupos TYPE posnr_va,                   "Sales Document item
  END OF ty_item,
  BEGIN OF ty_bseg,
    bukrs TYPE bukrs,
    belnr TYPE belnr_d,
    gjahr TYPE gjahr,
    buzei TYPE buzei,
    augbl TYPE augbl,
    dmbtr TYPE dmbtr,
    rebzg TYPE rebzg,
  END OF ty_bseg,
  BEGIN OF ty_vbap,
    vbeln TYPE vbeln_va,
    posnr TYPE posnr_va,
  END OF ty_vbap.
TYPES:BEGIN OF ty_jest_buf.
        INCLUDE STRUCTURE jest_upd.
        TYPES:mod,
        inact_old LIKE jest-inact.
TYPES END OF: ty_jest_buf.
DATA:lv_year TYPE gjahr.
* local Internal Table Declaration
DATA:
  li_jest_ins  TYPE STANDARD TABLE OF jest_upd,
  li_jest_upd  TYPE STANDARD TABLE OF jest_upd,
  li_jsto_ins  TYPE STANDARD TABLE OF jsto,
  li_jsto_upd  TYPE STANDARD TABLE OF jsto_upd,
  li_obj_del   TYPE STANDARD TABLE OF onr00,
  li_vbkd      TYPE STANDARD TABLE OF vbkdvb,
  li_item      TYPE STANDARD TABLE OF ty_item,
  li_final     TYPE STANDARD TABLE OF ty_item,
  ls_item      TYPE ty_item,
  li_vbrp      TYPE STANDARD TABLE OF ty_vbrp,
  li_vbrk      TYPE STANDARD TABLE OF ty_vbrk,
  ls_vbrk      TYPE ty_vbrk,
  li_jest      TYPE STANDARD TABLE OF jest,
  ls_jest_upd  TYPE jest_upd,
  ls_jest_ins  TYPE jest_upd,
  li_tj30t     TYPE STANDARD TABLE OF ty_tj30t,
  ls_tj30t     TYPE ty_tj30t,
  li_con       TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
  lir_ordtyp1  TYPE fip_t_auart_range,
  lir_prof     TYPE rnrangestsma_tt,
  lir_user     TYPE tdt_rg_estat,
  lir_cat      TYPE rjksd_pstyv_range_tab,
  li_bseg      TYPE STANDARD TABLE OF ty_bseg,                      "Cleared items.
  li_bseg_rul  TYPE STANDARD TABLE OF ty_bseg,                      "Partial cleared items
  li_jest_upd1 TYPE STANDARD TABLE OF ty_jest_buf,                 "JEST_BUF values
  li_vbap      TYPE STANDARD TABLE OF ty_vbap.
DATA:lv_fname_xjest TYPE char40 VALUE '(SAPLBSVA)JEST_BUF[]'.      "Read Jest run time.

FIELD-SYMBOLS:<li_jest_upd> TYPE ANY TABLE.                        "JEST Runtime table data

*-- Constants

CONSTANTS:
  lc_id_e217 TYPE zdevid     VALUE 'E217',                    "Development ID
  lc_cust    TYPE koart      VALUE 'D',
  lc_hold    TYPE j_txt04    VALUE 'HOLD',
  lc_vbp     TYPE j_obtyp    VALUE 'VBP',
  lc_vb      TYPE rvari_vnam VALUE 'VB',
  lc_va02    TYPE tcode      VALUE 'VA02',
  lc_cat     TYPE rvari_vnam VALUE 'PSTYV',                   "ABAP: Name of Variant Variable
  lc_ordt    TYPE rvari_vnam VALUE 'AUART',                   "ABAP: Name of Variant Variable
  lc_stsma   TYPE rvari_vnam VALUE 'STSMA',                   "ABAP: Name of Variant Variable
  lc_estat   TYPE rvari_vnam VALUE 'ESTAT'.
*--------------------------------------------------------------------*
IF t180-trtyp = 'V' AND t180-tcode = lc_va02.
  SELECT devid                                                  "Development ID
         param1	                                                "ABAP: Name of Variant Variable
         param2	                                                "ABAP: Name of Variant Variable
         srno	                                                  "ABAP: Current selection number
         sign	                                                  "ABAP: ID: I/E (include/exclude values)
         opti	                                                  "ABAP: Selection option (EQ/BT/CP/...)
         low                                                    "Lower Value of Selection Condition
         high	                                                  "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant                                            "Wiley Application Constant Table
    INTO TABLE li_con
   WHERE devid    EQ lc_id_e217
     AND activate EQ abap_true.
  IF sy-subrc EQ 0.
    LOOP AT li_con ASSIGNING FIELD-SYMBOL(<lst_const1>).
      CASE <lst_const1>-param1.
        WHEN lc_ordt.
*          Get the Order Types from Constant Table
          APPEND INITIAL LINE TO lir_ordtyp1 ASSIGNING FIELD-SYMBOL(<lst_ortype>).
          <lst_ortype>-sign   = <lst_const1>-sign.
          <lst_ortype>-option = <lst_const1>-opti.
          <lst_ortype>-low    = <lst_const1>-low.
          <lst_ortype>-high   = <lst_const1>-high.
        WHEN lc_cat.
*         Get the Sales document item category from constant table
          APPEND INITIAL LINE TO lir_cat ASSIGNING FIELD-SYMBOL(<ls_cat>).
          <ls_cat>-sign   = <lst_const1>-sign.
          <ls_cat>-option = <lst_const1>-opti.
          <ls_cat>-low    = <lst_const1>-low.
          <ls_cat>-high   = <lst_const1>-high.
        WHEN lc_stsma.
*         Get the Profile from constant table
          APPEND INITIAL LINE TO lir_prof ASSIGNING FIELD-SYMBOL(<ls_prof>).
          <ls_prof>-sign   = <lst_const1>-sign.
          <ls_prof>-option = <lst_const1>-opti.
          <ls_prof>-low    = <lst_const1>-low.
          <ls_prof>-high   = <lst_const1>-high.
        WHEN lc_estat.
*       Get the User Status from constant table
          APPEND INITIAL LINE TO lir_user ASSIGNING FIELD-SYMBOL(<ls_user>).
          <ls_user>-sign   = <lst_const1>-sign.
          <ls_user>-option = <lst_const1>-opti.
          <ls_user>-low    = <lst_const1>-low.
          <ls_user>-high   = <lst_const1>-high.
        WHEN OTHERS.
*           Nothing to do
      ENDCASE.
    ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
  ENDIF. " IF sy-subrc EQ 0
  IF vbak-auart IN lir_ordtyp1 AND lir_cat IS NOT INITIAL. "‘ZACO’
    li_vbkd[] = xvbkd[].
** Consider voucher number items only.
    DELETE li_vbkd WHERE bstkd_e IS INITIAL.
    LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<fs_xvbap>)
      WHERE pstyv IN lir_cat AND mvgr3 IS NOT INITIAL."ZACC anf final grade
      READ TABLE li_vbkd INTO DATA(lst_xvbkd_e217)
                  WITH KEY vbeln = <fs_xvbap>-vbeln
                           posnr = <fs_xvbap>-posnr.
      IF sy-subrc = 0.
** Objectnumber = ‘VB’ + (10 char order number) + (6 position item number)
        CONCATENATE lc_vb <fs_xvbap>-vbeln <fs_xvbap>-posnr
        INTO ls_item-objnr.
        ls_item-posnr  = lst_xvbkd_e217-posnr.
        ls_item-aubel = lst_xvbkd_e217-bstkd_e+0(8).   "voucher number
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_item-aubel
          IMPORTING
            output = ls_item-aubel.
        ls_item-aupos = lst_xvbkd_e217-bstkd_e+8(6).   "item
        APPEND ls_item TO li_item.
      ENDIF.
    ENDLOOP.
    IF li_item[] IS NOT INITIAL.
**Read table VBRP using these values (VBRP-AUBEL, VBRP-AUPOS) to get VBRP-VBELN (Invoice number).
      SELECT vbeln
             aubel
             aupos
         FROM vbrp
         INTO TABLE li_vbrp
         FOR ALL ENTRIES IN li_item
         WHERE aubel = li_item-aubel AND aupos = li_item-aupos.
      IF sy-subrc = 0.
**Read table VBRK using invoice number to get VBRK-BUKRS (Company Code).
        SELECT vbeln
               fkdat
               bukrs
          FROM vbrk
          INTO TABLE li_vbrk
          FOR ALL ENTRIES IN li_vbrp
          WHERE vbeln EQ li_vbrp-vbeln.
        IF sy-subrc = 0.
**Read current year based on company code and date
          READ TABLE li_vbrk INTO ls_vbrk INDEX 1.
          IF sy-subrc = 0.
            CALL FUNCTION 'GET_CURRENT_YEAR'
              EXPORTING
                bukrs = ls_vbrk-bukrs
                date  = ls_vbrk-fkdat
              IMPORTING
                curry = lv_year.
          ENDIF.
** Read payment document no(AUGBL) based on invoic number,year and customer flag
          IF li_vbrk IS NOT INITIAL.
            SELECT bukrs
                   belnr
                   gjahr
                   buzei
                   augbl
                   dmbtr
                   rebzg
              FROM bseg
              INTO TABLE li_bseg
              FOR ALL ENTRIES IN li_vbrk
              WHERE  bukrs EQ li_vbrk-bukrs AND
                     belnr EQ li_vbrk-vbeln AND
                     gjahr EQ lv_year AND
                     koart EQ lc_cust.               "Customer
            IF sy-subrc = 0.
**Read table to check rules for checking partially cleared
              SELECT bukrs
                     belnr
                     gjahr
                     buzei
                     augbl
                     dmbtr
                     rebzg
                FROM bseg
                INTO TABLE li_bseg_rul
                FOR ALL ENTRIES IN li_vbrk
                WHERE  bukrs EQ li_vbrk-bukrs AND
                       rebzg EQ li_vbrk-vbeln AND
                       koart EQ lc_cust.
            ENDIF."IF sy-subrc = 0.
          ENDIF."IF li_vbrk IS NOT INITIAL.
        ENDIF." IF sy-subrc = 0.
      ENDIF."IF sy-subrc = 0.
**Read the contract orders and items.
* BOC-ED2K916523-E217/ERPM4359-MIMMADISET
      SELECT vbeln posnr FROM vbap
             INTO TABLE li_vbap
             FOR ALL ENTRIES IN li_item
             WHERE vbeln = li_item-aubel AND
                   posnr = li_item-aupos.
* EOC-ED2K916523-E217/ERPM4359-MIMMADISET
      LOOP AT li_item INTO ls_item.
**Read the invoice no based on voucher no and item
        READ TABLE li_vbrp INTO DATA(ls_vbrp) WITH KEY
                                                 aubel = ls_item-aubel
                                                 aupos = ls_item-aupos.
        IF sy-subrc = 0.
**Read company code,
          READ TABLE li_vbrk INTO ls_vbrk WITH KEY vbeln = ls_vbrp-vbeln.
          IF sy-subrc = 0.
**Read payment document no to check invoice is cleare or not
            READ TABLE li_bseg INTO DATA(ls_bseg) WITH KEY
                                               bukrs = ls_vbrk-bukrs
                                               belnr = ls_vbrk-vbeln
                                               gjahr = lv_year.
            IF sy-subrc = 0.
              IF ls_bseg-augbl IS NOT INITIAL.
** if LS_BSEG-AUGBL is not initial , then payment was made but need to check if partial only.
                READ TABLE li_bseg_rul INTO DATA(ls_bseg_rul) WITH KEY
                                                       bukrs = ls_vbrk-bukrs
                                                       rebzg = ls_vbrk-vbeln.
                IF sy-subrc = 0.
                  IF ls_bseg_rul-augbl IS INITIAL.
*For the line returned, if the AUGBL field is <blank>,
*then this represents a Partial Payment and the HOLD status must be set.
                    APPEND ls_item TO li_final.
                  ENDIF.
*For the line returned, if the AUGBL field is NOT <blank>,
*then this represents a Full Payment made up of multiple partial payments and the HOLD status must NOT be set.
                ENDIF.
              ELSE.
**  If ls_bseg-AUGBL = <blank> then set the Line item status to HOLD.
                APPEND ls_item TO li_final.
              ENDIF."IF ls_bseg-augbl IS NOT INITIAL.
            ENDIF.
          ENDIF.
        ELSE.
* BOC-ED2K916523-E217/ERPM4359-MIMMADISET
*Hold status check box should be checked
* even the invoice is not create for contract.
          READ TABLE li_vbap TRANSPORTING NO FIELDS
                WITH KEY vbeln = ls_item-aubel
                         posnr = ls_item-aupos.
          IF sy-subrc = 0.
            APPEND ls_item TO li_final.
          ENDIF.
* EOC-ED2K916523-E217/ERPM4359-MIMMADISET
        ENDIF.
        CLEAR:ls_item.
      ENDLOOP.


** Read user statusus
      IF lir_prof[] IS NOT INITIAL AND
         lir_user[] IS NOT INITIAL AND
         li_final[] IS NOT INITIAL.
** Read tj30t table for profile and user status
        SELECT stsma estat FROM tj30t INTO TABLE li_tj30t
          WHERE stsma IN lir_prof AND estat IN lir_user AND spras EQ sy-langu
          AND txt04 = lc_hold.
        IF sy-subrc = 0.
          READ TABLE li_tj30t INTO ls_tj30t INDEX 1.
          IF sy-subrc = 0.
** Read JEST table
            SELECT * FROM jest
              INTO TABLE li_jest
              FOR ALL ENTRIES IN li_final
              WHERE objnr = li_final-objnr.
            LOOP AT li_final INTO ls_item.
              READ TABLE li_jest INTO ls_jest_upd WITH KEY
                                              objnr = ls_item-objnr
                                              stat  = ls_tj30t-estat
                                              inact = space.
              IF sy-subrc = 0.
**If there is a record found for line item and the JEST-INACT field is Blank, then the order line item status
**is already set to HOLD and no action is required .
**But User unselect the hold status field as X(INACT as 'X') in Run time but JEST table old value INACT = SPACE
**Passing JEST_buff runtime buffer values to temp field symbol internal table,
                ASSIGN (lv_fname_xjest) TO <li_jest_upd>.
                IF sy-subrc = 0.
                  li_jest_upd1[] = <li_jest_upd>.
                  READ TABLE li_jest_upd1 ASSIGNING FIELD-SYMBOL(<fs_jest>)
                                            WITH KEY objnr = ls_item-objnr
                                                stat  = ls_tj30t-estat
                                                inact = abap_true.
                  IF sy-subrc = 0.
**Updating JEST_BUF internal table with HOLD Status set as Blank,Because record failed with the above combination
** Like invoice not created,Partially cleared
                    <fs_jest>-inact = space.
                    <li_jest_upd> = li_jest_upd1[].
                  ENDIF.
                ENDIF.
              ELSE.
**Line Item Previously was on HOLD but no longer.
                READ TABLE li_jest INTO ls_jest_upd WITH KEY objnr = ls_item-objnr
                                                stat  = ls_tj30t-estat
                                                inact = abap_true.
                IF sy-subrc = 0.
                  ls_jest_upd-mandt = sy-mandt.
                  ls_jest_upd-inact = ' '.
                  ADD 1 TO ls_jest_upd-chgnr.
                  ls_jest_upd-chgkz = abap_true.
                  ls_jest_upd-obtyp = lc_vbp.  "Object category
                  ls_jest_upd-stsma = ls_tj30t-stsma.
                  APPEND ls_jest_upd TO li_jest_upd.
                ELSE.
*In this case, no record is found in JEST. Therefore, insert a new record in
*JEST for STAT = E0001(example) setting the CHGNR = 001.
                  ls_jest_ins-mandt = sy-mandt.
                  ls_jest_ins-objnr = ls_item-objnr.
                  ls_jest_ins-stat  = ls_tj30t-estat.
                  ls_jest_ins-inact = ' '.
                  ls_jest_ins-chgnr = '001'.
                  ls_jest_ins-chgkz = abap_true.
                  ls_jest_ins-obtyp = lc_vbp. ""Object category
                  ls_jest_ins-stsma = ls_tj30t-stsma.
                  APPEND ls_jest_ins TO li_jest_ins.
                ENDIF."IF sy-subrc = 0.
              ENDIF."IF sy-subrc = 0.
              CLEAR:ls_jest_upd,ls_jest_ins,ls_item.
            ENDLOOP."LOOP AT li_final INTO ls_item.
            IF li_jest_ins[] IS NOT INITIAL OR li_jest_upd[] IS NOT INITIAL.
              CALL FUNCTION 'STATUS_UPDATE'
                TABLES
                  jest_ins = li_jest_ins
                  jest_upd = li_jest_upd
                  jsto_ins = li_jsto_ins
                  jsto_upd = li_jsto_upd
                  obj_del  = li_obj_del
                EXCEPTIONS
                  OTHERS   = 1.
            ENDIF."IF li_jest_ins[] IS NOT INITIAL OR li_jest_upd[] IS NOT INITIAL.
          ENDIF."IF sy-subrc = 0.
        ENDIF."IF sy-subrc = 0. TJ30T
      ENDIF."IF lir_prof[] IS NOT INITIAL AND lir_user[] IS NOT INITIAL and li_final[] IS NOT INITIAL.
    ENDIF." IF li_item[] IS NOT INITIAL.
  ENDIF."IF vbak-auart IN lir_ordtyp AND lir_cat IS NOT INITIAL.
ENDIF.
