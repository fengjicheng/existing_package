
*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_CPY_CNTRL_E6317 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Copy controls from Billing to Accounting
* DEVELOPER: Agudurkhad
* CREATION DATE:   06/25/2018
* OBJECT ID: E177
* TRANSPORT NUMBER(S):   ED2K912177
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910411
* REFERENCE NO:  INC0247960
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2019-06-19
* DESCRIPTION: Select details from VBFA where the "Document category of
*              preceding SD document" is Contract or Order
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917830
* REFERENCE NO: ERPM-8177
* DEVELOPER: Prabhu (PTUFARAM)
* DATE:  2019-06-19
* DESCRIPTION: ERPM-8177 Performance improvement for the Intercompany Revenue 1B process
*            :VBFA link for updating reference documents has been removed
*             by the time of DMR creation, hence required information is fetching from
*             VBKD instead of VBFA in this include
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K920270
* REFERENCE NO: OTCM-30855
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  11/11/2020
* DESCRIPTION: Correct assignment group on a ZADR in order to allow
*              RAR and AR to earn properly
*----------------------------------------------------------------------*

* Local Types
TYPES : BEGIN OF lty_vbkd_zadr,
          bstkd   TYPE bstkd,
          bstkd_e TYPE bstkd_e,
          posex_e TYPE posex_e,
        END OF lty_vbkd_zadr.

* Local Data declarations
DATA: lv_bstkd_zadr       TYPE bstkd,
      lv_vbelv_zadr       TYPE vbeln_von,
      lv_posnv_zadr       TYPE posnr_von,
      lst_vbkd_zadr       TYPE lty_vbkd_zadr,
      r_billing_type_zadr TYPE RANGE OF salv_de_selopt_low.  "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
* Local Constants
*CONSTANTS: c_fkart  TYPE fkart  VALUE 'ZIDR'. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
*CONSTANTS: c_rmvct  TYPE rmvct VALUE 'ZRV'.
*BOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>
CONSTANTS: c_contract_zadr  TYPE char1 VALUE 'G'.
CONSTANTS: c_order_zadr     TYPE char1 VALUE 'C'.
CONSTANTS: c_space_zadr TYPE char1 VALUE ' '.
*EOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>

" BOC <SGUDA> OTCM-30855 311/NOV/2020  ED2K920270
CONSTANTS: lc_devid_zadr        TYPE zdevid VALUE 'E177',              " Development ID
           lc_billing_type_zadr TYPE zcaconstant-param1 VALUE 'BILLING_TYPE',  " Billing Type
           lc_aquisition_debt   TYPE zcaconstant-param2 VALUE 'AQUISITION_DEBT'.  " Billing Type
* Fetch values from constant table
SELECT  devid,     " Development ID
        param1,    " ABAP: Name of Variant Variable
        param2,    " ABAP: Name of Variant Variable
        srno,      " ABAP: Current selection number
        sign,      " ABAP: ID: I/E (include/exclude values)
        opti,      " ABAP: Selection option (EQ/BT/CP/...)
        low,       " Lower Value of Selection Condition
        high,      " Upper Value of Selection Condition
        activate   " Activation indicator for constant
  INTO TABLE @DATA(li_constant_zadr)
  FROM zcaconstant " Wiley Application Constant Table
  WHERE devid EQ @lc_devid_zadr
    AND activate EQ @abap_true.
IF sy-subrc EQ 0.
  SORT li_constant_zadr BY devid param1.
  LOOP AT li_constant_zadr INTO DATA(lst_constant_zadr).
    IF lst_constant_zadr-param1 EQ lc_billing_type_zadr AND lst_constant_zadr-param2 = lc_aquisition_debt.
      APPEND INITIAL LINE TO r_billing_type_zadr ASSIGNING FIELD-SYMBOL(<lst_billing_type_zadr>).
      <lst_billing_type_zadr>-sign   = lst_constant_zadr-sign.
      <lst_billing_type_zadr>-option = lst_constant_zadr-opti.
      <lst_billing_type_zadr>-low    = lst_constant_zadr-low.
      <lst_billing_type_zadr>-high   = lst_constant_zadr-high.
    ENDIF.
  ENDLOOP.
ENDIF.
" EOC <SGUDA> OTCM-30855 311/NOV/2020  ED2K920270
*IF xaccit-fkart = c_fkart. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
IF  xaccit-fkart IN r_billing_type_zadr. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
  " Below Read stmt is to control ERPM-8177 changes
  READ TABLE li_enh_ctrl WITH KEY wricef_id = lc_wricef_id_e177
                                  var_key = lc_vkey_zadr
                                  active_flag = abap_true TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    " Continue with the old logic
    SELECT SINGLE vbelv posnv INTO (lv_vbelv_zadr, lv_posnv_zadr)
      FROM vbfa
      WHERE vbeln EQ xvbrp-vgbel
        AND posnn EQ xvbrp-vgpos
        AND ( vbtyp_v = c_contract_zadr OR
              vbtyp_v = c_order_zadr    )
        AND stufe = c_space_zadr.
    CONCATENATE lv_vbelv_zadr lv_posnv_zadr INTO xaccit-zuonr.
  ELSE.
    SELECT SINGLE bstkd, bstkd_e, posex_e INTO @lst_vbkd_zadr FROM vbkd
                         WHERE vbeln = @xvbrp-vgbel
                         AND   posnr = @xvbrp-vgpos.
    IF sy-subrc = 0 AND lst_vbkd_zadr-bstkd IS NOT INITIAL AND
      lst_vbkd_zadr-bstkd_e IS NOT INITIAL AND lst_vbkd_zadr-posex_e IS NOT INITIAL.
      CONCATENATE lst_vbkd_zadr-bstkd_e lst_vbkd_zadr-posex_e INTO xaccit-zuonr.
      CLEAR lst_vbkd_zadr.
    ELSE.
      SELECT SINGLE vbelv posnv INTO (lv_vbelv_zadr, lv_posnv_zadr)
             FROM vbfa
             WHERE vbeln EQ xvbrp-vgbel AND
                   posnn EQ xvbrp-vgpos AND
                   ( vbtyp_v = c_contract_zadr OR vbtyp_v = c_order_zadr ) AND
                   stufe = c_space_zadr.
      CONCATENATE lv_vbelv_zadr lv_posnv_zadr INTO xaccit-zuonr.
    ENDIF. " IF sy-subrc = 0 AND lst_vbkd-bstkd_e IS NOT INITIAL...
  ENDIF.
ENDIF.
