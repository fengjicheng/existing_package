
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
TYPES : BEGIN OF lty_vbkd,
          bstkd   TYPE bstkd,
          bstkd_e TYPE bstkd_e,
          posex_e TYPE posex_e,
        END OF lty_vbkd.

* Local Data declarations
DATA: lv_bstkd       TYPE bstkd,
      lv_vbelv       TYPE vbeln_von,
      lv_posnv       TYPE posnr_von,
      lst_vbkd       TYPE lty_vbkd,
      r_billing_type TYPE RANGE OF salv_de_selopt_low.  "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
* Local Constants
*CONSTANTS: c_fkart  TYPE fkart  VALUE 'ZIDR'. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
CONSTANTS: c_rmvct  TYPE rmvct VALUE 'ZRV'.
*BOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>
CONSTANTS: c_contract  TYPE char1 VALUE 'G'.
CONSTANTS: c_order     TYPE char1 VALUE 'C'.
CONSTANTS: c_space TYPE char1 VALUE ' '.
*EOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>

" BOC <SGUDA> OTCM-30855 311/NOV/2020  ED2K920270
CONSTANTS: lc_devid         TYPE zdevid VALUE 'E177',              " Development ID
           lc_billing_type  TYPE zcaconstant-param1 VALUE 'BILLING_TYPE',  " Billing Type
           lc_inter_company TYPE zcaconstant-param2 VALUE 'INTER_COMPANY'.  " Billing Type
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
  INTO TABLE @DATA(li_constant)
  FROM zcaconstant " Wiley Application Constant Table
  WHERE devid EQ @lc_devid
    AND activate EQ @abap_true.
IF sy-subrc EQ 0.
  SORT li_constant BY devid param1.
  LOOP AT li_constant INTO DATA(lst_constant).
    IF lst_constant-param1 EQ lc_billing_type AND lst_constant-param2 = lc_inter_company.
      APPEND INITIAL LINE TO r_billing_type ASSIGNING FIELD-SYMBOL(<lst_billing_type>).
      <lst_billing_type>-sign   = lst_constant-sign.
      <lst_billing_type>-option = lst_constant-opti.
      <lst_billing_type>-low    = lst_constant-low.
      <lst_billing_type>-high   = lst_constant-high.
    ENDIF.
  ENDLOOP.
ENDIF.
" EOC <SGUDA> OTCM-30855 311/NOV/2020  ED2K920270
*IF xaccit-fkart = c_fkart. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
IF  xaccit-fkart IN r_billing_type. "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
  " BOC: ERPM-8177  KKRAVURI 23-JULY-2020  ED2K918984
  " Below Read stmt is to control ERPM-8177 changes
  READ TABLE li_enh_ctrl WITH KEY wricef_id = lc_wricef_id_e177
*                                  var_key = lc_vkey      "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
                                  var_key  = lc_vkey_zidr "OTCM-30855  SGUDA 11/NOV/2020  ED2K920270
                                  active_flag = abap_true TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    " Continue with the old logic
    " EOC: ERPM-8177  KKRAVURI 23-JULY-2020  ED2K918984
*BOC <HIPATEL> <ERP-6317> <ED2K912612> <07/11/2018>
    SELECT SINGLE vbelv posnv INTO (lv_vbelv, lv_posnv)
      FROM vbfa
      WHERE vbeln EQ xvbrp-vgbel
        AND posnn EQ xvbrp-vgpos
*BOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>
        AND ( vbtyp_v = c_contract OR
              vbtyp_v = c_order    )
        AND stufe = c_space.
*EOC <NPALLA> <INC0247960> <ED1K910411> <06/19/2019>
    IF sy-subrc = 0.
*EOC <HIPATEL> <ERP-6317> <ED2K912612> <07/11/2018>
      SELECT SINGLE bstkd INTO lv_bstkd FROM vbkd
                          WHERE vbeln = xvbrp-vgbel
                          AND   posnr = xvbrp-vgpos.
      IF sy-subrc = 0.
        xaccit-xref3 = lv_bstkd.
      ENDIF.
    ENDIF.
    CONCATENATE lv_vbelv lv_posnv INTO xaccit-zuonr.
    " BOC: ERPM-8177  KKRAVURI 23-JULY-2020  ED2K918984
  ELSE. " --> IF sy-subrc <> 0.
    " BOC <PRABHU> ERPM-8177 3/20/2020
    SELECT SINGLE bstkd, bstkd_e, posex_e INTO @lst_vbkd FROM vbkd
                         WHERE vbeln = @xvbrp-vgbel
                         AND   posnr = @xvbrp-vgpos.
    IF sy-subrc = 0 AND lst_vbkd-bstkd IS NOT INITIAL AND
      lst_vbkd-bstkd_e IS NOT INITIAL AND lst_vbkd-posex_e IS NOT INITIAL.
      xaccit-xref3 = lst_vbkd-bstkd.
      CONCATENATE lst_vbkd-bstkd_e lst_vbkd-posex_e INTO xaccit-zuonr.
      CLEAR lst_vbkd.
    ELSE.
      SELECT SINGLE vbelv posnv INTO (lv_vbelv, lv_posnv)
             FROM vbfa
             WHERE vbeln EQ xvbrp-vgbel AND
                   posnn EQ xvbrp-vgpos AND
                   ( vbtyp_v = c_contract OR vbtyp_v = c_order ) AND
                   stufe = c_space.
      IF sy-subrc = 0.
        SELECT SINGLE bstkd INTO lv_bstkd FROM vbkd
                            WHERE vbeln = xvbrp-vgbel AND
                                  posnr = xvbrp-vgpos.
        IF sy-subrc = 0.
          xaccit-xref3 = lv_bstkd.
        ENDIF.
      ENDIF.
      CONCATENATE lv_vbelv lv_posnv INTO xaccit-zuonr.
    ENDIF. " IF sy-subrc = 0 AND lst_vbkd-bstkd_e IS NOT INITIAL...
  ENDIF.
  " EOC <PRABHU> ERPM-8177 3/20/2020
  " EOC: ERPM-8177  KKRAVURI 23-JULY-2020  ED2K918984

  xaccit-rmvct = c_rmvct.

ENDIF. " IF xaccit-fkart = c_fkart.
