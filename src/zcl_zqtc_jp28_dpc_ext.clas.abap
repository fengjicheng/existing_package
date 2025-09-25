class ZCL_ZQTC_JP28_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_JP28_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods ZMATERIALSET_GET_ENTITY
    redefinition .
  methods ZMATERIALSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_JP28_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    IV_ACTION_NAME          =
**    IT_PARAMETER            =
**    IO_TECH_REQUEST_CONTEXT =
**  IMPORTING
**    ER_DATA                 =
*    .
** CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION .
** CATCH /IWBEP/CX_MGW_TECH_EXCEPTION .
**ENDTRY.
    DATA : lst_parameter TYPE /iwbep/s_mgw_name_value_pair,
           lst_material  TYPE zcl_zqtc_odata_materia_mpc=>ts_zmaterial,
           li_mat_out    TYPE zcl_zqtc_odata_materia_mpc=>tt_zmaterial.

    DATA: li_amara   TYPE TABLE OF mara_ueb,
          lst_amara  TYPE mara_ueb,
          li_errmsg  TYPE TABLE OF merrdat,
          lst_errmsg TYPE merrdat.

    FIELD-SYMBOLS : <lfs_parameter> TYPE /iwbep/s_mgw_name_value_pair.

    CONSTANTS : lc_action       TYPE string VALUE 'ZMaterial_Inputs_Update',         " Action Name
                lc_commonweight TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'CommonWeight',
                lc_extend       TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Extend',
                lc_grossweight  TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'GrossWeight',
                lc_length       TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Length',
                lc_material     TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Material',
                lc_netweight    TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'NetWeight',
                lc_paperweight  TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'PaperWeight',
                lc_thickness    TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Thickness',
                lc_width        TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Width',
                lc_s            TYPE messagetyp VALUE 'S'.
*
*    CASE iv_action_name.
*      WHEN lc_action.   " action is equal to ZMaterial_Input_Update then call the FM to Search the relevant data
*        IF it_parameter IS NOT INITIAL.     " request Parameter table In not null
*          " Add new record line for FM passing data table
*          APPEND INITIAL LINE TO li_amara ASSIGNING FIELD-SYMBOL(<lfs_amara>).
*          LOOP AT it_parameter ASSIGNING <lfs_parameter>.
*            CASE <lfs_parameter>-name.
*              WHEN lc_material.                                    " Material Number
*                <lfs_amara>-matnr  = <lfs_parameter>-value.
*              WHEN lc_grossweight.                                     " Gross Weight
*                <lfs_amara>-brgew  = <lfs_parameter>-value.
*              WHEN lc_netweight.
*                <lfs_amara>-ntgew  = <lfs_parameter>-value.         " Net Weight
*              WHEN lc_length.                                       " Length
*                <lfs_amara>-laeng  = <lfs_parameter>-value.
*              WHEN lc_width.                                        " Width
*                <lfs_amara>-breit  = <lfs_parameter>-value.
*              WHEN lc_thickness.                                    " Thickness
*                <lfs_amara>-hoehe = <lfs_parameter>-value.
*              WHEN lc_extend.                                       " Extend
*                <lfs_amara>-ismextent = <lfs_parameter>-value.
**              WHEN lc_unit.                                         " Unit of measure
**                <lfs_amara>-ismpapwthunit = <lfs_parameter>-value.
*              WHEN OTHERS.
*            ENDCASE.
*          ENDLOOP.
*
*          " Call material maitain FM
*          CALL FUNCTION 'MATERIAL_MAINTAIN_DARK'
*            EXPORTING
**             flag_muss_pruefen      = 'X'
**             sperrmodus             = 'E'
**             MAX_ERRORS             = 0
*              p_kz_no_warn           = lc_s
*              kz_prf                 = lc_s
**             KZ_VERW                = 'X'
**             KZ_AEND                = 'X'
**             KZ_DISPO               = 'X'
**             KZ_TEST                = ' '
**             NO_DATABASE_UPDATE     = ' '
**             CALL_MODE              = ' '
**             CALL_MODE2             = ' '
*              user                   = sy-uname
**             SUPPRESS_ARRAY_READ    = ' '
**             FLG_MASS               = ' '
**             IV_CHANGE_DOC_TCODE    = ' '
**           IMPORTING
**             MATNR_LAST             =
**             NUMBER_ERRORS_TRANSACTION       =
*            TABLES
*              amara_ueb              = li_amara
*              amerrdat               = li_errmsg
*            EXCEPTIONS
*              kstatus_empty          = 1
*              tkstatus_empty         = 2
*              t130m_error            = 3
*              internal_error         = 4
*              too_many_errors        = 5
*              update_error           = 6
*              error_propagate_header = 7
*              OTHERS                 = 8.
*          IF sy-subrc <> 0.
** Implement suitable error handling here
*          ENDIF.
*
*
*          " Build Final output table for response
*          LOOP AT li_errmsg ASSIGNING FIELD-SYMBOL(<lfs_errmsg>).
*            lst_material-msgtype   = <lfs_errmsg>-msgty.            " Message type
*            lst_material-msgnumber  = <lfs_errmsg>-msgno.        " Message Number
*            CONCATENATE <lfs_errmsg>-msgv1
*                        <lfs_errmsg>-msgv2
*                        <lfs_errmsg>-msgv3
*                        <lfs_errmsg>-msgv4
*                        INTO lst_material-message
*                        SEPARATED BY ' '.             " Message text
*            APPEND lst_material TO li_mat_out.                           " Append data to the response
*            CLEAR lst_material.
*          ENDLOOP.
*        ENDIF.
*    ENDCASE.
*
*
*    " Assign data to the response
*    copy_data_to_ref( EXPORTING is_data = li_mat_out
*                      CHANGING cr_data = er_data ).
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    iv_action_name          =
**    it_parameter            =
**    io_tech_request_context =
**  IMPORTING
**    er_data                 =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

  ENDMETHOD.


  METHOD zmaterialset_get_entity.

  ENDMETHOD.


  method ZMATERIALSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZMATERIALSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.
ENDCLASS.
