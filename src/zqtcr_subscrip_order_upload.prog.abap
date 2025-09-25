*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_SUBSCRIPTION_UPLOAD (Main Program)
* PROGRAM DESCRIPTION: To upload subscription orders
* DEVELOPER: Prosenjit Chaudhuri(PCHAUDHURI)
* CREATION DATE:   28/11/2016
* OBJECT ID:  E101
* TRANSPORT NUMBER(S):  ED2K903417
*----------------------------------------------------------------------*
* * BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059                 *
* REVISION NO: ED2K911059, ED2K911212                                  *
* REFERENCE NO: ERP-6292                                               *
* DEVELOPER: Dinakar T(DTIRUKOOVA)                                     *
* DATE:  23-Feb-2018                                                   *
* DESCRIPTION: Adding New condition type columns and defalut Sales Off *
*              to 0050 as per CR 6292                                  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913189, ED2K913477                                  *
* REFERENCE NO: ERP-7614                                               *
* DEVELOPER: Sayantan Das (SAYANDAS)                                   *
* DATE: 24-AUG-2018                                                    *
* DESCRIPTION: Add Background Processing Option                        *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913574                                              *
* REFERENCE NO: ERP7614                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12-Oct-2018                                                   *
* DESCRIPTION: Application Server paths changed to FILE from constants *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913722/ED2K914144                                   *
* REFERENCE NO: ERP7763                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12-Dec-2018                                                   *
* DESCRIPTION: Added Converted Order(ZSCR) download and Upload         *
*----------------------------------------------------------------------*
* REVISION NO: ED2K915483                                              *
* REFERENCE NO: DM1913                                                 *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  01-July-2019                                                  *
* DESCRIPTION:Order Reason A10 update                                  *
*----------------------------------------------------------------------*
* REVISION NO: ED2K916556                                              *
* REFERENCE NO:ERPM4543/ERPM4547                                       *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  24-Oct-2019                                                   *
* DESCRIPTION:Condition Group2 update to ZOFL Order Items              *
*----------------------------------------------------------------------*
* REVISION NO: ED2K916854                                              *
* REFERENCE NO:ERPM2334                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  05-Dec-2019                                                   *
* DESCRIPTION: Code adjustment to work for BP and Order Upload         *
*----------------------------------------------------------------------*
* REVISION NO: ED2K920134                                              *
* REFERENCE NO:ERPM-27580                                              *
* DEVELOPER: AMOHAMMED                                                 *
* DATE:  29-Oct-2020                                                   *
* DESCRIPTION: ZADR Acquisition Debit Additional Enhancements          *
*----------------------------------------------------------------------*
* REVISION NO: ED2K923278                                              *
* REFERENCE NO: OTCM-44200                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  05/05/2021                                                    *
* DESCRIPTION: ZADR File template changes and new validatinos          *
*----------------------------------------------------------------------*
REPORT zqtcr_subscrip_order_upload NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

*Begin of change by CHDAS: 28-Feb-2017:ED2K903417

INCLUDE zqtcn_subs_ord_upload_rep_top IF FOUND. "constants declaration

INCLUDE zqtcn_subs_ord_upload_rep_sel IF FOUND. "selection screen

INCLUDE zqtcn_subs_ord_upload_rep_sub IF FOUND. "subroutines

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

***BOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
  sscrfields-functxt_01 = 'Download Template'.
***EOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722

  PERFORM f_date_dynamics .

  PERFORM f_get_conditions CHANGING i_vbpa.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
* the change in item level or header level should be possible only if the modification option is selected
  PERFORM f_screen_dynamics_01.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_bstnk-low. "purchase order no.
  PERFORM f_fill_po USING c_bstnk.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_bstnk-high. "purchase order no.
  PERFORM f_fill_po USING c_bstnk.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_userid-low. "subscription order creator
  PERFORM f_get_creator USING c_userid.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_crd_by-low.
  PERFORM f_get_creator USING c_crd_by.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_doc-high. "reference invoice
  PERFORM f_get_invoices.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_doc-low. "reference invoice
  PERFORM f_get_invoices.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_cmr-low. "credit memo
  PERFORM f_get_credit_memo.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_cmr-high. "credit memo
  PERFORM f_get_credit_memo.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_bstnk1-low.
  PERFORM f_fill_po USING c_bstnk1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_bstnk1-high.
  PERFORM f_fill_po USING c_bstnk1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_user1-low.
  PERFORM f_get_creator USING c_user1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_user1-high.
  PERFORM f_get_creator USING c_user1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_order-low.
  PERFORM f_get_normal_order.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_order-high.
  PERFORM f_get_normal_order.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_vbeln-low.
  PERFORM f_get_subs_order.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_vbeln-high.
  PERFORM f_get_subs_order.

AT SELECTION-SCREEN.
  PERFORM f_get_file.
  PERFORM f_get_date_diff USING s_date[].
  PERFORM f_get_date_diff USING s_inv[].
  PERFORM f_get_date_diff USING s_invo[].
  PERFORM f_get_date_diff USING s_ord_dt[].
  PERFORM f_validate_file USING p_file.
* End of change by CHDAS: 28-Feb-2017:ED2K903417


*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
* SOC by NPOLINA E101 Paths  ED2K913574 ERP7614
  IF i_const IS INITIAL.
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
            INTO TABLE i_const
            WHERE ( devid    = c_devid
                  OR devid  = c_devid_e209 )  " NPOLINA DM1913 28/June/2019 ED2K915483
            AND   activate = c_x. "Only active record
    IF sy-subrc EQ 0.
      SORT i_const BY devid param1.
*--*Text ID
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e101>) WITH KEY devid = c_devid
                                                param1 = c_path
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_e101 = <lst_e101>-low.
      ENDIF.

* SOC by NPOLINA DM1913 28/June/2019 ED2K915483
* Get Order Reason match with ZCACONSTANT for Dev id E209/DM1913
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lfs_augru>) WITH KEY devid = c_devid_e209
                                                                            param1 = c_augru
                                                                            BINARY SEARCH.
      IF sy-subrc = 0.
        v_augru = <lfs_augru>-low.
      ENDIF.
* EOC by NPOLINA DM1913 28/June/2019 ED2K915483
    ENDIF.
  ENDIF.
* EOC by NPOLINA E101 Paths  ED2K913574 ERP7614
* Begin of change by CHDAS: 28-Feb-2017:ED2K903417
  IF rb_crea EQ c_x
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
    OR rb_cros EQ c_x.
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    IF  p_a_file IS NOT INITIAL.
      PERFORM f_read_from_app_sub.
    ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      PERFORM f_convert_new_subs_ord_excel  USING    p_file     "File path
                                            CHANGING i_final[]. "Input Data (table)
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
  ELSEIF rb_modi EQ c_x.

    IF rb_upd_m IS NOT INITIAL.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      IF  p_a_file IS NOT INITIAL.
        PERFORM f_read_from_app_sub.
      ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
        PERFORM f_convert_new_subs_ord_excel  USING    p_file    "File path
                                             CHANGING i_final[]. "Input Data (table)
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ELSEIF rb_sel_m IS NOT INITIAL.
      PERFORM f_display_subs_ord_change_alv.
    ENDIF. " IF rb_upd_m IS NOT INITIAL


  ELSEIF rb_crem EQ abap_true.

    IF  rb_upd IS NOT INITIAL.
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
*      PERFORM f_convert_crdt_excel   USING    p_file
*                                     CHANGING i_final_crdt.
* Change in table structure
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      IF  p_a_file IS NOT INITIAL.
        PERFORM f_read_from_app_crdt.
      ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
        PERFORM f_convert_crme_crt_excel USING p_file
                                      CHANGING i_final_crme_crt.

* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ELSEIF rb_sel IS NOT INITIAL.
* SOC by NPOLINA ERP7763 ED2K913722
*      IF s_doc IS INITIAL.
*        MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e.
*        LEAVE LIST-PROCESSING.
*      ELSE. " ELSE -> IF s_doc IS INITIAL
* EOC by NPOLINA ERP7763 ED2K913722
      PERFORM f_pop_credit_memo_final USING c_inv
                              CHANGING i_final_crdt.
* BOC 07-MAR-2018 : DTIRUKOOVA : CR#6292: ED2K911212
* move file data to ALV data table
      MOVE-CORRESPONDING i_final_crdt TO i_final_crme_crt.
* EOC 07-MAR-2018 : DTIRUKOOVA : CR#6292: ED2K911212
*      ENDIF. " IF s_doc IS INITIAL       *  NPOLINA ERP7763 ED2K913722
* SOC by NPOLINA ERP7763   ED2K913722
    ELSEIF rb_ord IS NOT INITIAL.
      PERFORM f_zscr_credit_memo_final USING c_sub
                             CHANGING i_final_crdt.
* move file data to ALV data table
      MOVE-CORRESPONDING i_final_crdt TO i_final_crme_crt.

* EOC by NPOLINA ERP7763    ED2K913722
    ENDIF. " IF rb_upd IS NOT INITIAL

  ELSEIF rb_crcg EQ abap_true.

    IF rb_upd1 IS NOT INITIAL.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      IF  p_a_file IS NOT INITIAL.
        PERFORM f_read_from_app_crdtch.
      ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
        PERFORM f_convert_crdt_excel      USING    p_file
                                          CHANGING i_final_crdt.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ELSEIF rb_sel1 IS NOT INITIAL.
      PERFORM f_pop_credit_memo_final USING c_cre
                                      CHANGING i_final_crdt.

    ENDIF. " IF rb_upd1 IS NOT INITIAL

* Begin by AMOHAMMED on 10/29/2020 TR # ED2K920134
  ELSEIF rb_dm_cr EQ c_x.
    IF  p_a_file IS NOT INITIAL.
      PERFORM f_read_from_app_dbt.
    ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
      PERFORM f_convert_dbm_crt_excel USING p_file
                                    CHANGING i_final_dbm_crt.
* BOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *
      PERFORM f_get_reference_data CHANGING i_final_dbm_crt.
* EOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *
    ENDIF.
* End by AMOHAMMED on 10/29/2020 TR # ED2K920134

  ELSEIF rb_or_ct EQ c_x.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    IF p_a_file IS NOT INITIAL.
      PERFORM f_read_from_app_ord.
    ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      PERFORM f_convert_ord_excel   USING    p_file.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
  ELSEIF rb_or_cn EQ c_x.

    IF rb_upd2 IS NOT INITIAL.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      IF p_a_file IS NOT INITIAL.
        PERFORM f_read_from_app_ord.
      ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
        PERFORM f_convert_ord_excel   USING    p_file.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
      ENDIF. " IF p_a_file IS NOT INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    ELSEIF rb_sel2 IS NOT INITIAL.
      PERFORM f_pop_ord_final.
    ENDIF. " IF rb_upd2 IS NOT INITIAL
  ENDIF. " IF rb_crea EQ c_x

END-OF-SELECTION.
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
  IF p_a_file IS INITIAL.
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
    IF rb_crea EQ c_x
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
      OR rb_cros EQ c_x. "creatiion of frsh subscription order
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
      CHECK v_error IS INITIAL.
      PERFORM f_display_new_subs_ord_alv.

    ELSEIF rb_modi EQ c_x. "modification of existing subscription order
      CHECK v_error IS INITIAL.
      PERFORM f_display_change_subs_ord.

    ELSEIF rb_crem EQ abap_true.
* SOC by NPOLINA CR7763  ED2K913722/ED2K914144

      IF rb_ord IS NOT INITIAL.
        PERFORM f_display_create_cred_memo USING c_zscr.  " To display from Selection
      ELSE.
        READ TABLE i_final_crme_crt ASSIGNING FIELD-SYMBOL(<lfs_ord2>) INDEX 1. " To display from Upload file
        IF sy-subrc EQ 0 AND <lfs_ord2>-auart = c_zscr.
          PERFORM f_display_create_cred_memo USING c_zscr.
        ELSE.
* EOC by NPOLINA CR7763 ED2K913722/ED2K914144
          PERFORM f_display_create_cred_memo USING c_inv.
        ENDIF.
      ENDIF.                      "NPOLINA CR7763 ED2K913722
    ELSEIF rb_crcg EQ abap_true.

      PERFORM f_display_create_cred_memo USING c_cre.

* Begin by AMOHAMMED on 10/29/2020 TR # ED2K920134
    ELSEIF rb_dm_cr EQ c_x.
      IF i_final_dbm_crt IS NOT INITIAL.
        LOOP AT i_final_dbm_crt ASSIGNING FIELD-SYMBOL(<lfs_dbmc>).
          " Check at header level
          IF <lfs_dbmc>-parvw EQ c_ag.
            " Check the document type is 'ZADR'
            IF <lfs_dbmc>-auart NE c_zadr.
              IF v_doctype_check EQ abap_true.
                CLEAR v_doctype_check.
              ENDIF.
              EXIT.
            ELSE.
              v_doctype_check = abap_true.
            ENDIF.
            " Check the Contract is filled
            IF <lfs_dbmc>-vbeln IS NOT INITIAL.
              v_cntrct_check = abap_true.
            ELSE.
              CONTINUE.
            ENDIF.
            " Check at item level
          ELSE.
            " Check the contract is filled
            IF <lfs_dbmc>-vbeln IS NOT INITIAL.
              v_cntrct_check = abap_true.
            ELSE.
              IF v_cntrct_check EQ abap_true.
                CLEAR v_cntrct_check.
              ENDIF.
              EXIT.
            ENDIF.
*            " Check Condition type is 'ZMPR'
*            IF <lfs_dbmc>-kschl NE c_zmpr.
*              IF v_condtyp_chk EQ abap_true.
*                CLEAR v_condtyp_chk.
*              ENDIF.
*              EXIT.
*            ELSE.
*              v_condtyp_chk = abap_true.
*            ENDIF.
          ENDIF.
        ENDLOOP.
        IF v_cntrct_check EQ abap_true AND v_doctype_check EQ abap_true. " AND v_condtyp_chk EQ abap_true.
          FREE : v_cntrct_check, v_doctype_check. ", v_condtyp_chk.
          PERFORM f_display_create_debit_memo USING c_zadr.
        ELSE.
          IF v_doctype_check EQ abap_false.
            MESSAGE s000 WITH text-104 DISPLAY LIKE c_e.
          ENDIF.
          IF v_cntrct_check EQ abap_false.
            MESSAGE s000 WITH text-103 DISPLAY LIKE c_e.
          ENDIF.
*            IF v_condtyp_chk EQ abap_false.
*              MESSAGE s000 WITH text-106 DISPLAY LIKE c_e.
*            ENDIF.
        ENDIF.
      ELSE.
        MESSAGE s000 WITH text-055 DISPLAY LIKE c_e.
      ENDIF.
* End by AMOHAMMED on 10/29/2020 TR # ED2K920134

    ELSEIF rb_or_ct EQ abap_true.

      PERFORM f_display_display_reg_ord.

    ELSEIF rb_or_cn EQ abap_true.

      PERFORM f_display_display_reg_ord.

    ENDIF. " IF rb_crea EQ c_x
* End of change by CHDAS: 28-Feb-2017:ED2K903417
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
  ELSE. " ELSE -> IF p_a_file IS INITIAL
    IF rb_crea EQ c_x.
      PERFORM f_contract_createfromdata .
*   BOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
    ELSEIF rb_cros EQ c_x.
*        PERFORM f_rew_qref_contract_create. " commented for new approach
*** BOC CR#498
      PERFORM f_rew_qref_contract_copy.
*** EOC CR#498
*   EOC CR#498: 29-JUL-2017 : SAYANDAS: ED2K907365
    ELSEIF rb_modi EQ c_x.
      PERFORM f_change_subscription.
    ELSEIF rb_crem EQ c_x.
* BOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
*        PERFORM f_create_cred_memo    CHANGING i_final_crdt.
* Change in table structure
      PERFORM f_create_cred_memo    CHANGING i_final_crme_crt.
* EOC 23-FEB-2018 : DTIRUKOOVA : CR#6292: ED2K911059
    ELSEIF rb_crcg EQ c_x.
      PERFORM f_change_cred_memo    USING i_final_crdt.
    ELSEIF rb_dm_cr EQ c_x.
      PERFORM f_create_debit_memo CHANGING i_final_dbm_crt.
    ELSEIF rb_or_ct EQ abap_true.
      PERFORM f_create_reg_ord      CHANGING i_ord_alv.
    ELSEIF rb_or_cn EQ abap_true.
      PERFORM f_change_reg_ord      USING i_ord_alv.
    ENDIF. " IF rb_crea EQ c_x
  ENDIF. " IF p_a_file IS INITIAL
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
