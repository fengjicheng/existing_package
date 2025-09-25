*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_ORDER_DET_E144 (Include Program)
* PROGRAM DESCRIPTION: Include for Copy controls from Billing to Accounting
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/28/2017
* OBJECT ID: E144
* TRANSPORT NUMBER(S): ED2K906990
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910433
* REFERENCE NO: CR-769
* DEVELOPER:    GKINTALI (Geeta Kintali)
* DATE:         01/10/2018
* DESCRIPTION:  Processing of transfer structures SD-FI – to populate
*               BSEG-VBEL2 and BSEG-POSN2 with contract/order number
*               instead of Credit memo number in case of credit memo
*               scenario (Change the standard SD copy control for credit memo
*               requests to populate the main SD document number (parent) into the FI
*               accounting document sales document/item fields instead of the
*               Credit Memo Request document number. AP I/C generated from
*               SD I/C billing should populate the sales document/item number).

*----------------------------------------------------------------------*
* BOC - GKINTALI - 10.01.2018 - ED2K910433
CONSTANTS: lc_vbtyp_k    TYPE vbtyp VALUE 'K',    " Credit Memo Request
           lc_vbtyp_g    TYPE vbtyp VALUE 'G',    " Contract
           lc_vbtyp_c    TYPE vbtyp VALUE 'C',    " Order
           lc_awtyp_bkpf TYPE awtyp VALUE 'IBKPF'." Reference Transaction
DATA: lv_vbelv TYPE vbeln_von,
      lv_posnv TYPE posnr_von.
* EOC - GKINTALI - 10.01.2018 - ED2K910433
LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<lst_accit>).
  <lst_accit>-kdauf = <lst_accit>-aubel.         "Sales Document
  <lst_accit>-kdpos = <lst_accit>-aupos.         "Sales Document Item

* BOC - GKINTALI - 10.01.2018 - ED2K910433
  IF <lst_accit>-aubel IS NOT INITIAL.
* Fetch the original Sales Document number and item number against
* which the CMR is created - in case of CMR scenario
   SELECT SINGLE vbelv posnv
     INTO (lv_vbelv, lv_posnv)
     FROM vbfa
     WHERE vbeln = <lst_accit>-aubel
     AND   posnn = <lst_accit>-aupos
     AND   vbtyp_n = lc_vbtyp_k      " Credit Memo Request
     AND   vbtyp_v IN (lc_vbtyp_g,   " Contract
                       lc_vbtyp_c).  " Order
* Passing the contract number and item number to BSEG-VBEL2 and BSEG-POSN2 respectively
   IF sy-subrc = 0.
     <lst_accit>-kdauf = lv_vbelv.  " Original Sales Order Number against which CMR is created
     <lst_accit>-kdpos = lv_posnv.  " Sales Document Item
   ENDIF.
 ENDIF.  " IF <lst_accit>-vbel2 IS NOT INITIAL.
* EOC - GKINTALI - 10.01.2018 - ED2K910433
ENDLOOP.
