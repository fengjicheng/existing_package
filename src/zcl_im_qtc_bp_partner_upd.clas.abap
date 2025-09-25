class ZCL_IM_QTC_BP_PARTNER_UPD definition
  public
  final
  create public .

public section.

  interfaces IF_EX_PARTNER_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTC_BP_PARTNER_UPD IMPLEMENTATION.


  method IF_EX_PARTNER_UPDATE~CHANGE_BEFORE_OUTBOUND.
  endmethod.


  METHOD if_ex_partner_update~change_before_update.

    INCLUDE zqtcn_bp_reason_for_chnge_e191 IF FOUND . " Vishnu POC

  ENDMETHOD.
ENDCLASS.
