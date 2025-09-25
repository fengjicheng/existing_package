*----------------------------------------------------------------------*
* PROGRAM NAME: ZXF06U06 (User-exit - Called from EXIT_SAPLIEDI_101)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate additional Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/29/2017
* OBJECT ID: E163
* TRANSPORT NUMBER(S):  ED2K906862
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K911408
* REFERENCE NO: CR-769
* DEVELOPER:    HIPATEL (Himanshu Patel)
* DATE:         03/16/2018
* DESCRIPTION:  Processing of transfer structures SD-FI-CR769 - when a
*               subscription order results in Inter- company AP posting
*               with BKPF-AWTYP=IBKPF, then passing contract number and
*               item number to BSEG-VBEL2 and BSEG-POSN2 respectively.
*               (Change the standard SD copy control for credit memo
*               requests to populate the main SD document number (parent)
*               into the FI accounting document sales document/item fields
*               instead of the Credit Memo Request document number. AP I/C
*               generated from SD I/C billing should populate the sales
*               document/item number).
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e163 TYPE zdevid VALUE 'E163',       "Constant value for WRICEF (E163)
    lc_ser_num_e163   TYPE zsno   VALUE '001'.        "Serial Number (001)

  DATA:
    lv_actv_flag_e163 TYPE zactive_flag.              "Active / Inactive flag

*   Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e163              "Constant value for WRICEF (E163)
      im_ser_num     = lc_ser_num_e163                "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e163.             "Active / Inactive flag

  IF lv_actv_flag_e163 = abap_true.
    INCLUDE zqtcn_ic_invoice_fields_01 IF FOUND.
  ENDIF. "IF lv_actv_flag_E163 = abap_true



*--------------------------------------------------------------------------*
*CR-769
  CONSTANTS:
    lc_wricef_id_cr769 TYPE zdevid VALUE 'CR-769',       "Constant value for WRICEF (CR-769)
    lc_ser_num_cr769   TYPE zsno   VALUE '001'.        "Serial Number (001)

  DATA:
    lv_actv_flag_cr769 TYPE zactive_flag.              "Active / Inactive flag

*   Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_cr769              "Constant value for WRICEF (CR-769)
      im_ser_num     = lc_ser_num_cr769                "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_cr769.             "Active / Inactive flag

  IF lv_actv_flag_cr769 = abap_true.
    INCLUDE zqtcn_ic_invoice_ord_fields IF FOUND.
  ENDIF. "IF lv_actv_flag_CR-769 = abap_true
