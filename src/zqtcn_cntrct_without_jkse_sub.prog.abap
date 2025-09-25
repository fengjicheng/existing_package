*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CNTRCT_WITHOUT_JKSE_SUB (Include Program)
* PROGRAM DESCRIPTION: All the logic and data fetching implementation
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   02/13/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917550
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CNTRCT_WITHOUT_JKSE_R102 (Main Program)
* PROGRAM DESCRIPTION:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:   02/20/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917617
*&---------------------------------------------------------------------*

FORM f_get_zcaconstants .

  SELECT devid,                      " Development ID
       param1,                       " ABAP: Name of Variant Variable
       param2,                       " ABAP: Name of Variant Variable
       srno,                         " Current selection number
       sign,                         " ABAP: ID: I/E (include/exclude values)
       opti,                         " ABAP: Selection option (EQ/BT/CP/...)
       low,                          " Lower Value of Selection Condition
       high,                         " Upper Value of Selection Condition
       activate                      " Activation indicator for constant
       FROM zcaconstant              " Wiley Application Constant Table
       INTO TABLE @i_constant
       WHERE devid    = @c_devid
       AND   activate = @abap_true.       "Only active record
  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1.
  ENDIF.

ENDFORM.

FORM f_populate_defaults .

  DATA : lst_auart TYPE ty_auart.

  CONSTANTS : lc_auart TYPE rvari_vnam VALUE 'AUART'.     " Sales Document type

  IF i_constant IS NOT INITIAL.
    LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
      CASE <lfs_constant>-param1.
        WHEN lc_auart.                                      " Set default Contract types
          lst_auart-sign   = <lfs_constant>-sign.
          lst_auart-opti   = <lfs_constant>-opti.
          lst_auart-low    = <lfs_constant>-low.
          lst_auart-high   = <lfs_constant>-high.
          APPEND lst_auart TO s_auart.
          CLEAR lst_auart.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_fetch_data .

  " Fecth Output data from CDS view
  SELECT document_number,item,contract_type,document_date,sales_org,customer_number,customer_name,billing_document,material,
         item_category,qty,net_value,taxes,contract_start_date,contract_end_date,arrival_date,status
    FROM zcds_jkse_cwsch
    INTO TABLE @i_jkse
    WHERE contract_type IN @s_auart   AND
          document_date IN  @s_ddate  AND
          sales_org IN @s_vkorg       AND
          item_category IN @s_pstyv   AND
          contract_start_date IN @s_cdate.
  IF sy-subrc IS INITIAL.
    " Nothing to do
  ELSE.
    MESSAGE s563(zqtc_r2).      " Output itab is empty and return the Messege to selection screen
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM f_dispaly_data.

  PERFORM f_build_fieldcat_jkse.        " Build field catalog
  IF i_fieldcat_jkse[] IS NOT INITIAL.
    PERFORM f_display_alv.              " Display ALV output
  ENDIF.

ENDFORM.

FORM f_build_fieldcat_jkse.

  CLEAR : st_fieldcat_jkse ,i_fieldcat_jkse[].

  PERFORM f_build_fcat_jkse USING : 'CONTRACT_TYPE' 'I_JKSE' text-002 '4' '13' '',
                                    'SALES_ORG' 'I_JKSE' text-003 '4' '9' '',
                                    'DOCUMENT_NUMBER' 'I_JKSE' text-004 '10' '15' '',
                                    'ITEM' 'I_JKSE' text-017 '6' '8' '',
                                    'CUSTOMER_NUMBER' 'I_JKSE' text-005 '10' '15' '',
                                    'CUSTOMER_NAME' 'I_JKSE' text-006 '40' '' '',
                                    'BILLING_DOCUMENT' 'I_JKSE' text-007 '10' '15' '',
                                    'MATERIAL' 'I_JKSE' text-008 '18' '8' '',
                                    'ITEM_CATEGORY' 'I_JKSE' text-009 '4' '12' '',
                                    'QTY' 'I_JKSE' text-010 '' '' '0',
                                    'NET_VALUE' 'I_JKSE' text-011 '15' '' '2',
                                    'TAXES' 'I_JKSE' text-012 '13' '' '2',
                                    'CONTRACT_START_DATE' 'I_JKSE' text-013 '' '' '',
                                    'CONTRACT_END_DATE' 'I_JKSE' text-014 '' '' '',
                                    'ARRIVAL_DATE' 'I_JKSE' text-015 '' '' '',
                                    'STATUS' 'I_JKSE' text-016 '10' '' ''.

ENDFORM.

FORM f_build_fcat_jkse USING fp_field TYPE any    " Field Name
                             fp_tab TYPE any      " Itab Name
                             fp_text TYPE any     " Display Text
                             fp_ddout TYPE any    " ALV filtering box length
                             fp_outlen TYPE any   " Output length in ALV grid
                             fp_decout TYPE any.  " Decimal output

  st_fieldcat_jkse-fieldname = fp_field.
  st_fieldcat_jkse-tabname   = fp_tab.
  st_fieldcat_jkse-seltext_l   = fp_text.
  st_fieldcat_jkse-lowercase  = abap_true.
  st_fieldcat_jkse-ddic_outputlen = fp_ddout.
  st_fieldcat_jkse-outputlen = fp_outlen.
  st_fieldcat_jkse-decimals_out = fp_decout.

  APPEND st_fieldcat_jkse TO i_fieldcat_jkse.
  CLEAR st_fieldcat_jkse.

  v_layout-no_input = abap_true.
  v_layout-colwidth_optimize = abap_true.
  v_layout-zebra = abap_true.

ENDFORM.

FORM f_display_alv .

  IF i_jkse IS NOT INITIAL. " Check whether itab is empty
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid               " Program name
        is_layout          = v_layout               " Layout
        it_fieldcat        = i_fieldcat_jkse[]      " Field catalog
        it_sort            = i_sort                 " Sort
        i_save             = c_standard             " Variant save
        it_events          = i_events               " ALV events
      TABLES
        t_outtab           = i_jkse                 " resule output table
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDFORM.
