FUNCTION zqtc_ism_se_check_issue_e231 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IN_ISSUE) TYPE  RJKSEORDERGENADD-ISSUE
*"     REFERENCE(IN_VBELN) TYPE  RJKSECONTRACT-VBELN
*"     REFERENCE(IN_POSNR) TYPE  RJKSECONTRACT-POSNR
*"     REFERENCE(IN_QUANTITY) TYPE  RJKSEORDERGENADD-QUANTITY
*"     REFERENCE(IN_UNIT) TYPE  RJKSEORDERGENADD-UNIT
*"     REFERENCE(IN_TESTRUN) TYPE  CHAR01
*"     REFERENCE(IN_MESSAGE) TYPE REF TO  CL_ISM_SD_MESSAGE
*"  EXPORTING
*"     REFERENCE(OUT_CHECK_FAILED) TYPE  C
*"     REFERENCE(OUT_CALL_PROCESSING) TYPE  C
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_ISM_SE_CHECK_ISSUE_E231 (FM)
* PROGRAM DESCRIPTION: This FM is copied from  ISM_SE_SAMPLE_CHECK_ISSUE
*                      Added logic tostop order creation for certain
*                      set parameters
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 02/21/2020
* OBJECT ID:     E231/ERPM-12582
* TRANSPORT NUMBER(S): ED2K917590
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:INC0298878
* DEVELOPER:Prabhu
* DATE:7/10/2020
* DESCRIPTION:Release order if non of the fields maintained in constant table
*            with out considering order type and Item category
*&---------------------------------------------------------------------*
************************************************************************
* Prüfung auf duplikativ vergebene Ausgaben pro Generierungslauf zu einem
* Warenempfänger
************************************************************************
* Typ zum Puffern Zuordnung Ausgabe/Warenempfänger

*--*Get Contract details
* Warenempfänger bestimmen
  CONSTANTS:
    lc_wricef_id_e231 TYPE zdevid   VALUE 'E231', " Development ID
    lc_ser_num_2_e231 TYPE zsno     VALUE '002'.  " Serial Number

  DATA:
    lv_actv_flag_e231 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e231
      im_ser_num     = lc_ser_num_2_e231
    IMPORTING
      ex_active_flag = lv_actv_flag_e231.

  IF lv_actv_flag_e231 EQ abap_true.
    PERFORM get_jksecontrindex USING    in_vbeln
                                        in_posnr
                               CHANGING jksecontrindex.
*--*Get Shipto address data
    PERFORM f_get_shipto_address USING  in_vbeln
                                        in_posnr.
*--*Get Constnat table entries
    PERFORM f_get_constants.
*--*Get Material info
    PERFORM f_get_material_info USING in_issue.
*--*Get Customer additional data and PO info.
    PERFORM f_additional_info.
*--*check prerequisites for validations
    PERFORM f_prerequisites_check.

    IF v_prerequisite_fail = abap_true.
*--* no need of further validation processing..
    ELSE.
*--*Check the required conditions to pass item record
      PERFORM f_validate_data CHANGING out_check_failed.
    ENDIF.

*--*Raise an informationmessage
    IF out_check_failed = abap_true.

      MESSAGE v_msg TYPE 'I'.
      CALL METHOD in_message->add
        EXPORTING
          level1 = in_vbeln
          level2 = in_posnr
          level3 = in_issue.
    ENDIF.
  ENDIF.
* Prüfen, ob Warenempfänger Medienausgabe bereits erhalten hat
ENDFUNCTION.
