class ZCL_MAT_GRP4_DESC_FRM_TVM4 definition
  public
  create public .

public section.

  interfaces /IDT/USER_EXIT_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MAT_GRP4_DESC_FRM_TVM4 IMPLEMENTATION.


 METHOD /idt/user_exit_interface~user_exit.
*------------------------------------------------------------------------*
* PROGRAM NAME        : /IDT/USER_EXIT_INTERFACE~USER_EXIT               *
* PROGRAM DESCRIPTION : Populate Description of Material Group 4         *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2017-01-09                                       *
* OBJECT ID           : N/A (Logic from TR developer Anshul Garg)        *
* TRANSPORT NUMBER(S) : ED2K903086                                       *
*------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------*
* REVISION NO: ED2K906634
* REFERENCE NO: ERP-2761
* DEVELOPER: WROY (Writtick Roy) (Logic from TR developer Anshul Garg)
* DATE:  2017-06-09
* DESCRIPTION: Logic during Releasing Blocks of Contracts / Orders
*------------------------------------------------------------------------*
    DATA : mv_mat_grp_desc   TYPE  bezei40,
          mv_mat_grp4 TYPE mvgr4,
          mv_tcode TYPE char2,
          m_ref_item_req TYPE REF TO /idt/reference_utility.

    FIELD-SYMBOLS : <fv_mat_grp4> TYPE data.

**Capture transaction code to validate various sales process
    mv_tcode = sy-tcode(+2).

    CASE mv_tcode.
      WHEN 'VA'.         "For Contracts and Orders
        m_ref_item_req  = i_ref_util_source_data->field( 'VBAP-MVGR4' ).
        ASSIGN m_ref_item_req->g_ref_data->* TO <fv_mat_grp4>.
        IF <fv_mat_grp4> IS ASSIGNED AND sy-subrc = 0.
          mv_mat_grp4 = <fv_mat_grp4>.
        ENDIF.
      WHEN 'VF'.         " For Billing
        m_ref_item_req = i_ref_util_source_data->field( 'VBRP-MVGR4' ).
        ASSIGN m_ref_item_req->g_ref_data->* TO <fv_mat_grp4>.
        IF <fv_mat_grp4> IS ASSIGNED AND sy-subrc = 0.
          mv_mat_grp4  = <fv_mat_grp4>.
        ENDIF.
      WHEN OTHERS.    "fallback block , assuming VBAP holds the value.
        m_ref_item_req  = i_ref_util_source_data->field( 'VBAP-MVGR4' ).
        ASSIGN m_ref_item_req->g_ref_data->* TO <fv_mat_grp4>.
        IF <fv_mat_grp4> IS ASSIGNED AND sy-subrc = 0.
          mv_mat_grp4 = <fv_mat_grp4>.
        ENDIF.
    ENDCASE.

    IF mv_mat_grp4 IS NOT INITIAL.
      SELECT SINGLE bezei
             INTO mv_mat_grp_desc
             FROM tvm4t
             WHERE spras EQ 'EN'
               AND mvgr4 EQ mv_mat_grp4.
    ENDIF.

    rv_value = mv_mat_grp_desc.
  ENDMETHOD.
ENDCLASS.
