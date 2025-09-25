*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Future Change Functionality for Firm Invoices
*                      1. When saving the contract should update the NAST table
*                         with Requested processing time, Date and Dispatch time
*                      2. This change should be applicable to document type ZREW
*                      3. This Change should be applicable to output type ZANP/ZANE.
* REFERENCE NO: E112 - ERPM-21151
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 09-07-2020
* TRANSPORT NUMBER(s):  ED2K919397
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923580
* REFERENCE NO:  OTCM-37780
* DEVELOPER: Krishna Srikanth (Ksrikanth)
* DATE:  2021-05-26
* DESCRIPTION:  This change should be applicable to document type ZREW
*               when executing from Auto renewal Program.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FRM_INV_ORD_SAVE_F032
*&---------------------------------------------------------------------*

DATA : r_contract_type     TYPE fip_t_werks_range,                 " Contract Type
       r_output            TYPE fip_t_werks_range,                 " Output Type
       r_zlsch             TYPE trty_zlsch_range,                  " Payment Method
       r_bsark             TYPE tdt_rg_bsark,                      " Customer purchase order type
       lii_constants       TYPE zcat_constants,                    " Constant Entris
       lt_constants        TYPE zcat_constants,                    " Constant Entris
       v_disp_time         TYPE na_vsztp,                          " Disp Time
       v_process_time      TYPE na_uhrvr,                          " Processing time
       v_date              TYPE sy-datum,                          " Billing Plan Date
       v_fkdat             TYPE fkdat,                             " Billing date for billing index and printout
       lv_days1            TYPE char2,                             " No.Of Days
       lst_output          TYPE fip_s_werks_range,                 " Work Area for Output
       lt_output           TYPE zrg_prog,                          " Work Area for Output
       lst_zqtc_renwl_plan TYPE zqtc_renwl_plan,                   " Renewal Plan table
       ls_zqtc_renwl_plan  TYPE zqtc_renwl_plan,                   " Renewal Plan table
       lv_flag_f032        TYPE char1,                             " Flag
       lv_doc_process_flag TYPE char1,                             " Flag
       r_constant          TYPE zdt_rg_prog,
       r_auart             TYPE fip_t_werks_range,
       lv_prog             TYPE program_id,
       lc_vsztp            TYPE na_vsztp,
       lv_doc_type         TYPE vbak-auart.

CONSTANTS:
  lc_devid_f032    TYPE zdevid        VALUE 'F032',                " Development ID
  lc_contract_type TYPE rvari_vnam    VALUE 'CONTRACT_TYPE',       " Contract Type
  lc_output_type   TYPE rvari_vnam    VALUE 'OUTPUT',              " Output Type
  lc_zlsch1        TYPE rvari_vnam    VALUE 'ZLSCH',               " Constant for payment method
  lc_bsark         TYPE rvari_vnam    VALUE 'BSARK',               " Constnat for PO type
  lc_process_time  TYPE rvari_vnam    VALUE 'PROCESS_TIME',        " Process Time
  lc_disp_time     TYPE rvari_vnam    VALUE 'VSZTP',               " Dispatch Time
  c_cs             TYPE zactivity_sub VALUE 'CS',                  " CS Activity
  c_001            TYPE vasch_veda    VALUE '0001',                " Action at end of contract
  c_0              TYPE vbkd-posnr    VALUE '000000',              " Item value
  c_manue          TYPE nast-manue    VALUE 'X',                   " Manual processing
  c_renewal_year   TYPE rvari_vnam    VALUE 'RENWAL_YEAR',         " Renewal Year
  c_xnast          TYPE char40        VALUE '(SAPLV61B)XNAST[]',   " XNAST Entries
  lc_devid_e112    TYPE zdevid        VALUE 'E112', "Development ID
  lc_prog          TYPE rvari_vnam    VALUE 'PROG',
  lc_auart1        TYPE rvari_vnam    VALUE 'AUART',
  lc_sno1          TYPE tvarv_numb    VALUE '1',
  lc_sno8          TYPE tvarv_numb    VALUE '8',
  lc_trtyp         TYPE trtyp         VALUE 'H',
  lc_trtyp2        TYPE trtyp         VALUE 'V',
  lc_auart2        TYPE auart         VALUE 'ZREW'.

*- Get Constant Entries with reference to DEVID F032
CLEAR lii_constants[].
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_f032                                     "Development ID: F032
  IMPORTING
    ex_constants = lii_constants.                                      "Constant Values
LOOP AT lii_constants ASSIGNING FIELD-SYMBOL(<lstt_zcaconstnt>).
  CASE <lstt_zcaconstnt>-param1.
*-  Contract Type
    WHEN lc_contract_type.
      lst_output-sign = <lstt_zcaconstnt>-sign.
      lst_output-option = <lstt_zcaconstnt>-opti.
      lst_output-low = <lstt_zcaconstnt>-low.
      APPEND lst_output TO r_contract_type.
*- Output Type
    WHEN lc_output_type.
      lst_output-sign = <lstt_zcaconstnt>-sign.
      lst_output-option = <lstt_zcaconstnt>-opti.
      lst_output-low = <lstt_zcaconstnt>-low.
      APPEND lst_output  TO r_output.
*- Payment Method
    WHEN lc_zlsch1.
      lst_output-sign = <lstt_zcaconstnt>-sign.
      lst_output-option = <lstt_zcaconstnt>-opti.
      lst_output-low = <lstt_zcaconstnt>-low.
      APPEND lst_output  TO r_zlsch.
*- Customer purchase order type
    WHEN lc_bsark.
      lst_output-sign = <lstt_zcaconstnt>-sign.
      lst_output-option = <lstt_zcaconstnt>-opti.
      lst_output-low = <lstt_zcaconstnt>-low.
      APPEND lst_output  TO r_bsark.
*- Process Time
    WHEN lc_process_time.
      v_process_time = <lstt_zcaconstnt>-low.
      CONDENSE v_process_time.
*- Dispatch Time
    WHEN lc_disp_time.
      v_disp_time = <lstt_zcaconstnt>-low.
      CONDENSE v_disp_time.
    WHEN OTHERS.
  ENDCASE.
  CLEAR lst_output.
ENDLOOP.
*- Get XNAST Entries
FIELD-SYMBOLS: <lfs_xnast> TYPE any.
ASSIGN (c_xnast) TO <lfs_xnast>.
IF <lfs_xnast> IS ASSIGNED.
* Get values of table XNAST
  xnast[] = <lfs_xnast>.
ENDIF. " IF <lfs_XNAST> IS ASSIGNED
CLEAR lv_flag_f032.
*- For Output Validation - ZANE/ZANP
LOOP AT xnast INTO DATA(lst_nast) WHERE kschl IN r_output.
  lv_flag_f032 = abap_true.
ENDLOOP.
"++ Begin of Changes By Krishna On_31052021
"This change should be applicable to document type ZREW
*& Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e112
  IMPORTING
    ex_constants = lt_constants.
LOOP AT lt_constants ASSIGNING FIELD-SYMBOL(<ls_constants>).
  CASE <ls_constants>-param1.
*-  Contract Type
    WHEN lc_prog.
      lt_output-sign = <ls_constants>-sign.
      lt_output-option = <ls_constants>-opti.
      lt_output-low = <ls_constants>-low.
      APPEND lt_output TO r_constant.
*- Output Type
    WHEN lc_auart1.
      lt_output-sign = <ls_constants>-sign.
      lt_output-option = <ls_constants>-opti.
      lt_output-low = <ls_constants>-low.
      APPEND lt_output  TO r_auart.
    WHEN OTHERS.
  ENDCASE.
  CLEAR lt_output.
ENDLOOP.
CLEAR:lv_doc_process_flag.
"++ End of Changes By Krishna On_31052021
*-  For Payment Method
READ TABLE xvbkd INTO DATA(lst_vbkd) WITH KEY posnr = c_0.
*- Validate for Output Type of ZANP/ZANE
IF lv_flag_f032 IS NOT INITIAL.
*- To Validate Document type - ZREW
  IF xvbak-auart IN r_contract_type AND
*- To Validate Customer purchase order type
     xvbak-bsark IN r_bsark AND
*- To Validate Payment Method
     lst_vbkd-zlsch IN r_zlsch  AND
*- To Validate Action at end of contract
     veda-vaktsch = c_001.
    "++ Begin of Changes By Krishna On_31052021
    " To validate renewal program & document type (ZREW)
*- To Check whether the document is completly processed or not.
    IF t180-trtyp EQ lc_trtyp OR t180-trtyp EQ lc_trtyp2.
      IF xvbak-zzfice IN r_constant AND xvbak-auart IN r_auart.
        lst_nast-vsdat  = sy-datum.
        lst_nast-vsura  = sy-uzeit.
        lst_nast-manue  = c_manue.
        MODIFY xnast FROM lst_nast INDEX 1 TRANSPORTING vsdat vsura manue.
        <lfs_xnast> = xnast[].
        lv_doc_process_flag = abap_true.
      ENDIF.
    ENDIF.
    "++ End of Changes By Krishna On_31052021
    IF lv_doc_process_flag IS INITIAL.
*- Get Billing Plan Date From Renewal Plan table with Reference to Reference document of ZREW
      SELECT SINGLE * FROM zqtc_renwl_plan INTO lst_zqtc_renwl_plan
                                           WHERE vbeln = xvbak-vgbel.
*- Validating Constant entries have data and Billing Plan date is existed ot not
      IF sy-subrc EQ 0 AND lst_zqtc_renwl_plan-eadat IS NOT INITIAL.
        lst_nast-vsztp  = v_disp_time.    "Dispatch Time
        lst_nast-vsdat  = lst_zqtc_renwl_plan-eadat."v_fkdat.       "Dispatch Date
        lst_nast-vsura  = v_process_time.
        lst_nast-manue  = c_manue.
        MODIFY xnast FROM lst_nast INDEX 1 TRANSPORTING vsztp vsdat vsura manue.
        <lfs_xnast> = xnast[].
      ELSE.
      ENDIF.
    ENDIF.
  ELSE.
  ENDIF.
ELSE.
ENDIF.
