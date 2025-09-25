"Name: \FU:ISM_CIC_CUSTENV_SDORDERS\SE:END\EI
ENHANCEMENT 0 ZQTCEI_CIC0_SORT_CONTRACTS.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_CIC0_SORT_CONTRACTS(Enhancement Implementation)
*               Called from CIC0 transaction inside the
*               class - CL_ISM_CLU_BUILD_CUSTENV
*               Method- BUILD_SDORDERS
* PROGRAM DESCRIPTION: Sort the orders by document
* DEVELOPER: AMOHAMMED
* CREATION DATE:     :  Jan/27/2020
* OBJECT ID:         :  E229/ERPM-7157
* TRANSPORT NUMBER(S):  ED2K917162
*----------------------------------------------------------------------*
* Local Constant Declaration
  CONSTANTS:
    lc_sno_e229_002   TYPE zsno    VALUE '002',   "Serial Number
    lc_wricef_id_e229 TYPE zdevid  VALUE 'E229'. "Development ID
 DATA:
    lv_actv_flag_e229 TYPE zactive_flag. "Active / Inactive Flag
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e229  "Development ID (I201)
      im_ser_num     = lc_sno_e229_002    "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e229. "Active / Inactive Flag

  IF lv_actv_flag_e229 EQ abap_true. "Check for Active Flag
    IF ex_sdorder_keytab IS NOT INITIAL.
      SELECT vbeln, erdat, auart                         " Fetch the Contract creation date
        FROM vbak
        INTO TABLE @DATA(lt_vbak)
        FOR ALL ENTRIES IN @ex_sdorder_keytab
        WHERE vbeln = @ex_sdorder_keytab-vbeln.
      IF lt_vbak IS NOT INITIAL.
        SORT lt_vbak by auart erdat DESCENDING.          " Sort by document type and creation date
        REFRESH ex_sdorder_keytab.                       " Delete existing data
        MOVE-CORRESPONDING lt_vbak TO ex_sdorder_keytab. " Restore with required data
        FREE lt_vbak.                                    " Delete temporary internal table
      ENDIF.
    ENDIF.
  ENDIF.
ENDENHANCEMENT.
