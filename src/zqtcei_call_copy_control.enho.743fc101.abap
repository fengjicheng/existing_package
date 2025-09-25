"Name: \PR:SAPLV45A\EX:SD_SALES_ITEM_MAINTAIN_03\EI
ENHANCEMENT 0 ZQTCEI_CALL_COPY_CONTROL.
*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCEI_CALL_COPY_CONTROL
* PROGRAM DESCRIPTION: This enhancement will copy changes from Billing into
* Sales Documents .
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
 DATA: lv_actv_flag_e131 TYPE zactive_flag. " Active / Inactive Flag

CONSTANTS : lC_WRICEF_ID_E131 type ZDEVID value 'E131',
            lC_SER_NUM_E131   type ZSNO value '1'.

*   To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id_e131
          im_ser_num     = lc_ser_num_e131
        IMPORTING
          ex_active_flag = lv_actv_flag_e131.

      IF lv_actv_flag_e131 EQ abap_true.
       INCLUDE zqtcn_call_copy_control_bill IF FOUND.
      ENDIF. " IF lv_actv_flag_e143 EQ abap_true

ENDENHANCEMENT.
