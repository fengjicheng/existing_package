*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_LOCKBOXUPD_DISP_F01
* PROGRAM DESCRIPTION: To Display Lockbox ZQTCLOCKBOX_UPD Table Data
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 18/03/2019
* OBJECT ID: INC0235034
* TRANSPORT NUMBER(S): ED1K909832
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911226
* REFERENCE NO:  ERPM-3463
* DEVELOPER: GKAMMILI
* DATE:  10/25/2019
* DESCRIPTION:Adding two fields(contract and billing document) to rport
*             output
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911298
* REFERENCE NO:  ERPM-3463
* DEVELOPER: GKAMMILI
* DATE:  11/07/2019
* DESCRIPTION:Adding Reason code in selection screen and providing
*             Variant save option in the output
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_LOCKBOXUPD_DISP_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_TABLE_DATA
*&---------------------------------------------------------------------*
* To Retrieve the data from table ZQTCLOCKBOX_UPD based
* on Clearing Date (AUGDT)
*    Company Code (BUKRS)
*    Document No (BELNR)
*    Customer No (KUNNR)
*----------------------------------------------------------------------*
FORM f_get_table_data .

  SELECT * FROM zqtclockbox_upd INTO TABLE i_lockbox
           WHERE augdt IN s_augdt
             AND bukrs EQ p_bukrs
             AND belnr IN s_belnr
             AND kunnr IN s_kunnr
             AND reason_code IN s_rcode. " Added by GKAMMILI on 25/10/2019 TR-ED1K911298 Jar ERPM - 3463
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
  IF i_lockbox IS NOT INITIAL.
    SELECT vbelv   "Preceding sales and distribution document
           vbeln   "Subsequent sales and distribution document
           vbtyp_n "Document category of subsequent document
           FROM vbfa INTO TABLE i_vbfa
           FOR ALL ENTRIES IN i_lockbox
           WHERE vbelv = i_lockbox-vbeln
           AND   ( vbtyp_n = c_contract OR
                   vbtyp_n = c_billing ).

  ENDIF.
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILED_CATELOG
*&---------------------------------------------------------------------*
*    To Prepare field Catelog based on internal table i_lockbox
*----------------------------------------------------------------------*

FORM f_filed_catelog .
*-- BOC by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463.
*Merge Field Catalog
*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name       = 'ZQTCLOCKBOX_UPD'
*    CHANGING
*      ct_fieldcat            = i_fieldcat
*    EXCEPTIONS
*      inconsistent_interface = 1
*      program_error          = 2
*      OTHERS                 = 3.
*-- EOC by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463.
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463.
  CLEAR v_col_pos.
  PERFORM f_prepare_fcat USING  'XBLNR'(F01)          'Ref Key'(H01)               '10'.
  PERFORM f_prepare_fcat USING  'AUGDT'(F02)          'Clearing Date'(H02)         '13'.
  PERFORM f_prepare_fcat USING  'ZTIME'(F03)          'Time'(H03)                  '8'.
  PERFORM f_prepare_fcat USING  'BELNR'(F04)          'DocumentNo'(H04)            '10'.
  PERFORM f_prepare_fcat USING  'VBELN'(F05)          'Sales Document'(H05)        '15'.
  PERFORM f_prepare_fcat USING  'ZVBELN_S'(F06)       'Contract'(H06)              '10'.
  PERFORM f_prepare_fcat USING  'ZVBELN_B'(F07)       'Billing Document'(H07)      '15'.
  PERFORM f_prepare_fcat USING  'BUKRS'(F08)          'Company Code'(H08)          '12'.
  PERFORM f_prepare_fcat USING  'WAERS'(F09)          'Currency Key'(H09)          '12'.
  PERFORM f_prepare_fcat USING  'REFERENCE'(F10)      'Reference'(H10)             '16'.
  PERFORM f_prepare_fcat USING  'KUNNR'(F11)          'Customer'(H11)              '10'.
  PERFORM f_prepare_fcat USING  'NAME1'(F12)          'Name 1'(H12)                '30'.
  PERFORM f_prepare_fcat USING  'QUOTE_CURRENCY'(F13) 'SD Document Currency'(H13)  '20'.
  PERFORM f_prepare_fcat USING  'QUOTE_AMOUNT'(F14)   'Quote Amount'(H14)          '16'.
  PERFORM f_prepare_fcat USING  'PAYMENT_AMOUNT'(F15) 'Payment Amount'(H15)        '16'.
  PERFORM f_prepare_fcat USING  'POSTING_DATE'(F16)   'Posting Date'(H16)          '12'.
  PERFORM f_prepare_fcat USING  'SALES_AREA'(F17)     'Sales Organization'(H17)    '18'.
  PERFORM f_prepare_fcat USING  'QUOTE_TYPE'(F18)     'Sales Document Type'(H18)   '19'.
  PERFORM f_prepare_fcat USING  'REASON_CODE'(F19)    'Reason Code'(H19)           '10'.
  PERFORM f_prepare_fcat USING  'FLREASON'(F20)       'Reason Description'(H20)    '100'.

*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*  To Display ALV REport
*----------------------------------------------------------------------*

FORM f_alv_list_display .

*Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid    "Added by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463
      it_fieldcat        = i_fieldcat
      i_save             = 'A'         "Added by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463
    TABLES
*      t_outtab          = i_lockbox  "Commented by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
      t_outtab           = i_final     "Added by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_PROCESS_DATA .
*-- BOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
  SORT:i_lockbox BY vbeln,
       i_vbfa BY vbelv vbeln vbtyp_n.
  DELETE ADJACENT DUPLICATES FROM i_vbfa COMPARING vbelv vbeln vbtyp_n.
*-- Processing lockbox data
  LOOP AT i_lockbox INTO st_lockbox.
    MOVE-CORRESPONDING st_lockbox TO st_final.
*-- Reading vbfa for contract
    READ TABLE i_vbfa INTO st_vbfa WITH KEY vbelv   = st_lockbox-vbeln
                                            vbtyp_n = c_contract
                                            BINARY SEARCH.
    IF sy-subrc = 0.
      st_final-zvbeln_s  = st_vbfa-vbeln.
    ENDIF.
*-- Reading vbfa for billing document
    READ TABLE i_vbfa INTO st_vbfa WITH KEY vbelv   = st_lockbox-vbeln
                                            vbtyp_n = c_billing
                                            BINARY SEARCH.
    IF sy-subrc = 0.
      st_final-zvbeln_b  = st_vbfa-vbeln.
    ENDIF.
    APPEND st_final TO i_final.
    CLEAR: st_final,st_vbfa.
  ENDLOOP.
*-- EOI by GKAMMILI on 25/10/2019 TR-ED1K911226 Jar ERPM - 3463
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_prepare_fcat
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->fp_fieldname   text
*      -->fp_seltext     text
*      -->fP_outputlen   text
*----------------------------------------------------------------------*
FORM f_prepare_fcat  USING  fp_fieldname
                            fp_seltext
                            fP_outputlen.
  v_col_pos = v_col_pos + 1.
  st_fieldcat-fieldname   = fp_fieldname.
  st_fieldcat-seltext_m   = fp_seltext.
  st_fieldcat-col_pos     = v_col_pos.
  st_fieldcat-outputlen   = fp_outputlen.
  APPEND st_fieldcat TO i_fieldcat.
  CLEAR  st_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4
*&---------------------------------------------------------------------*
*       F4 help for  reaseon code selection screen field
*----------------------------------------------------------------------*
*      -->fp_rcode
*----------------------------------------------------------------------*
FORM F_F4  USING  fp_rcode.
*-- local constants declarations
  CONSTANTS:lc_retfield TYPE dfies-fieldname VALUE 'REASON_CODE',
            lc_dynprofld TYPE help_info-dynprofld VALUE 'S_RCODE',
            lc_value_org TYPE ddbool_d VALUE 'S',
            lc_b         TYPE c VALUE 'B', " B of type Character
            lc_c         TYPE c VALUE 'C', " C of type Character
            lc_d         TYPE c VALUE 'D', " D of type Character
            lc_e         TYPE c VALUE 'E', " E of type Character
            lc_f         TYPE c VALUE 'F', " F of type Character
            lc_x         TYPE c VALUE 'X'. " F of type Character
*-- Filling the Valu table
  REFRESH i_rcode.
  st_rcode-reason_code = lc_b.
  APPEND st_rcode TO i_rcode.
  st_rcode-reason_code = lc_c.
  APPEND st_rcode TO i_rcode.
  st_rcode-reason_code = lc_d.
  APPEND st_rcode TO i_rcode.
  st_rcode-reason_code = lc_e.
  APPEND st_rcode TO i_rcode.
  st_rcode-reason_code = lc_f.
  APPEND st_rcode TO i_rcode.
  st_rcode-reason_code = lc_x.
  APPEND st_rcode TO i_rcode.
*-- Calling function module for proving F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield    = lc_retfield
      pvalkey     = ' '
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = lc_dynprofld
      value_org   = lc_value_org
    TABLES
      value_tab   = i_rcode
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc = 0.
*  Nothing to do
  ENDIF.



ENDFORM.
