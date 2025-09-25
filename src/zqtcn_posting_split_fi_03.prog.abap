*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POSTING_SPLIT_FI_03 (Include Program)
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1482786
*                      Activate automatic accounting document split
*                      (Tax Summarization)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/10/2017
* OBJECT ID: E123
* TRANSPORT NUMBER(S): ED2K908916
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909547
* REFERENCE NO: ERP-5063
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-11-22
* DESCRIPTION: Compression should not happen for Down Payments
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* Begin of ADD:ERP-5063:WROY:22-Nov-2017:ED2K909547
DATA:
  li_constant TYPE zcat_constants.                              "Constant Values

IF r_bus_tran IS INITIAL.
* Get Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = c_wricef_id_e123                           "Development ID: E123
    IMPORTING
      ex_constants = li_constant.                               "Constant Values
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN c_prm_noii.                                          "Parameter: Number Of Invoice Items
        CASE <lst_constant>-param2.
          WHEN c_prm_bstr.
            APPEND INITIAL LINE TO r_bus_tran ASSIGNING FIELD-SYMBOL(<lst_bus_tran>).
            <lst_bus_tran>-sign   = <lst_constant>-sign.
            <lst_bus_tran>-option = <lst_constant>-opti.
            <lst_bus_tran>-low    = <lst_constant>-low.
            <lst_bus_tran>-high   = <lst_constant>-high.
          WHEN OTHERS.
*           Nothing to Do
        ENDCASE.
      WHEN OTHERS.
*       Nothing to Do
    ENDCASE.
  ENDLOOP.
ENDIF.

READ TABLE i_t_bkpf ASSIGNING FIELD-SYMBOL(<lst_bkpf>)
     WITH KEY awtyp = c_awtyp_vbrk.
IF sy-subrc EQ 0 AND
   <lst_bkpf>-glvor NOT IN r_bus_tran.
* End   of ADD:ERP-5063:WROY:22-Nov-2017:ED2K909547
* Begin of DEL:ERP-5063:WROY:22-Nov-2017:ED2K909547
*READ TABLE i_t_bkpf TRANSPORTING NO FIELDS
*     WITH KEY awtyp = c_awtyp_vbrk.
*IF sy-subrc EQ 0.
* End   of DEL:ERP-5063:WROY:22-Nov-2017:ED2K909547
  e_bset_compress = abap_true.
  c_flg_xtxit     = abap_false.
ENDIF.
