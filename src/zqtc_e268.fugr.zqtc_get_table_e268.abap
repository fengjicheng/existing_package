FUNCTION zqtc_get_table_e268.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_USR_COM) TYPE  SYST_UCOMM
*"     VALUE(IM_ITAB) TYPE  ANY TABLE
*"     REFERENCE(IM_IRCAT_TAB) TYPE  ANY TABLE
*"     REFERENCE(IM_GRCAT_TAB) TYPE  ANY TABLE
*"     REFERENCE(IM_IRTYP_TAB) TYPE  ANY TABLE
*"     REFERENCE(IM_GRTYP_TAB) TYPE  ANY TABLE
*"  EXPORTING
*"     REFERENCE(EX_BASETAB) TYPE  ZTQTC_MEREP_OUTTAB_PURCHDOC
*"     REFERENCE(EX_SCHETAB) TYPE  ZTQTC_MEREP_OUTTAB_SCHEDLINES
*"     REFERENCE(EX_ACCTAB) TYPE  ZTQTC_MEREP_OUTTAB_ACCOUNTING
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923403
* REFERENCE NO: E268
* DEVELOPER: Thilina Dimantha
* DATE: 12-May-2021
* DESCRIPTION: Add PO History related fields to ME2N ME2M Output
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923969
* REFERENCE NO: E268 / OTCM-48208
* DEVELOPER: Thilina Dimantha
* DATE: 29-June-2021
* DESCRIPTION: Output Changes for ME2M and ME2N
*-----------------------------------------------------------------------*

  CLEAR: i_table_pur, i_table_sche, i_table_acc,
         i_table_pur_dis, i_table_sche_dis, i_table_acc_dis.
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
  ir_ir_cat = im_ircat_tab.
  ir_gr_cat = im_grcat_tab.
  ir_ir_typ = im_irtyp_tab.
  ir_gr_typ = im_grtyp_tab.
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
  CASE sy-ucomm.
    WHEN '' OR lc_base.
      PERFORM f_base_selection USING im_itab
            CHANGING i_table_pur_dis.

    WHEN lc_schedule.
      PERFORM f_schedule_selection USING im_itab
            CHANGING i_table_sche_dis.

    WHEN lc_account.
      PERFORM f_account_selection USING im_itab
            CHANGING i_table_acc_dis.

  ENDCASE.

  ex_basetab = i_table_pur_dis.
  ex_schetab = i_table_sche_dis.
  ex_acctab  = i_table_acc_dis.

ENDFUNCTION. "#EC CI_VALPAR
