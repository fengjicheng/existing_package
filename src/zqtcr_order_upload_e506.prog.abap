*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ORDER_UPLOAD_E506 (Main Program)
* PROGRAM DESCRIPTION: To upload Mass Sales orders & Credit/Debit Memos
* REFERENCE NO: EAM-1155
* DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:   19/April/2022
* OBJECT ID:    E506
* TRANSPORT NUMBER(S):ED2K926870
*----------------------------------------------------------------------*
REPORT zqtcr_order_upload_e506 NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

INCLUDE zqtcn_order_upload_e506_top IF FOUND. "Data declaration

INCLUDE zqtcn_order_upload_e506_sel IF FOUND. "Selection screen

INCLUDE zqtcn_order_upload_e506_sub IF FOUND. "Subroutines

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

  sscrfields-functxt_01 = 'Download Template'(059).

** To refresh the global varaibles
  PERFORM f_initialization.

** To get Constant Details
  PERFORM f_get_constants.

** To Initialize Global variables
  PERFORM f_get_init_detials.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM f_f4_file_name   CHANGING p_file . "File Path

*====================================================================*
*AT SELECTION SCREEN
*====================================================================*
AT SELECTION-SCREEN.

** To Download Input file template
  PERFORM f_get_file.

** To Validate Input File
  PERFORM f_validate_file USING p_file.

*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
** If File placed in Application Server to Process via Background
  IF p_a_file IS INITIAL.

    IF rb_so_ct EQ abap_true. "Regular Order

** Convert Excel into Internal Table
      PERFORM f_convert_ord_excel USING p_file.

** IF Input file contains Errors stop processing
      READ TABLE i_regular_ord TRANSPORTING NO FIELDS WITH KEY msgty = c_e.  "#EC CI_STDSEQ

      IF sy-subrc IS INITIAL.

        MESSAGE i000(zqtc_r2) WITH 'The Input file has Errors'(032).

      ELSE.

** If Input file count is less than threshold value process the file in foreground else trigger Background job
        IF v_lines LE v_line_lmt.

          PERFORM f_create_reg_ord.

        ELSE.

          PERFORM f_create_reg_ord_bg.

        ENDIF.

      ENDIF.

    ELSEIF rb_cd_ct EQ abap_true.  "Credit/Debit Memo

** Convert Excel into Internal Table
      PERFORM f_convert_crdrme_crt_excel USING p_file.

** IF Input file contains Errors stop processing
      READ TABLE i_crdrme_crt TRANSPORTING NO FIELDS WITH KEY msgty = c_e. "#EC CI_STDSEQ

      IF sy-subrc IS INITIAL.

        MESSAGE i000(zqtc_r2) WITH 'The Input file has Errors'(032).

      ELSE.

** If Input file count is less than threshold value process the file in foreground else trigger Background job
        IF v_lines LE v_line_lmt.

          PERFORM f_create_crdr_memo.

        ELSE.

          PERFORM f_create_crdr_memo_bg.

        ENDIF.

      ENDIF.

    ENDIF. "IF rb_so_ct EQ abap_true.

  ELSE.

    IF rb_so_ct EQ abap_true.  "Regular Order

** Read File from Application Server
      PERFORM f_read_from_app_ord.

    ELSEIF rb_cd_ct EQ abap_true. "Credit/Debit Order

** Read File from Application Server
      PERFORM f_read_from_app_crdrme.

    ENDIF.

  ENDIF. "IF p_a_file IS INITIAL.

*====================================================================*
* E N D - O F - S E L E C T I O N
*====================================================================*
END-OF-SELECTION.

** If Processed in Background
  IF p_a_file IS NOT INITIAL.

    IF rb_so_ct = abap_true.    " Sales Order

      PERFORM f_create_reg_ord.

    ELSEIF rb_cd_ct = abap_true. "Crdei/Debit Memo

      PERFORM f_create_crdr_memo.

    ENDIF.

  ENDIF. "  IF p_a_file IS NOT INITIAL.
