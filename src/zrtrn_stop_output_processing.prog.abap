*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_STOP_OUTPUT_PROCESSING (Include)
* PROGRAM DESCRIPTION: Stop Processing of Output (RDIV) if RAR Contract
*                      is missing
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       01/09/2018
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K910206, ED2K910495
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911464
* REFERENCE NO: ED2K911464
* DEVELOPER: Writtick Roy (WROY)
* DATE:  03/20/2018
* DESCRIPTION: Additional check on Billing Type
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_bil_doc TYPE vbeln_vf,                                          "Billing Document
  lv_status  TYPE farr_rai_status,                                   "Status of Revenue Accounting Item
  lv_src_id  TYPE farr_rai_srcid.                                    "Source Item ID

* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
DATA:
  li_constnt TYPE zcat_constants.                                    "Constant Values

STATICS:
  lr_bl_type TYPE j_3rs_so_invoice_sd.                               "Range: Billing Type
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464

CONSTANTS:
* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
  lc_dv_e160 TYPE zdevid     VALUE 'E160',                           "Development ID
  lc_p_bltyp TYPE rvari_vnam VALUE 'BILL_TYPE',                      "Parameter: Billing Type
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
  lc_pattrn  TYPE char1      VALUE '%'.                              "Pattern (%)

lv_bil_doc = nast-objky.                                             "Billing Document = Object Key
* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
SELECT SINGLE fkart
  FROM vbrk
  INTO @DATA(lv_bill_typ)
 WHERE vbeln EQ @lv_bil_doc.
IF sy-subrc EQ 0.
  IF lr_bl_type[] IS INITIAL.
*   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dv_e160                                    "Development ID
      IMPORTING
        ex_constants = li_constnt.                                   "Constant Values
    LOOP AT li_constnt ASSIGNING FIELD-SYMBOL(<lst_constant>).
      CASE <lst_constant>-param1.
        WHEN lc_p_bltyp.                                             "Parameter: Billing Type
*         Populate Range: Billing Type
          APPEND INITIAL LINE TO lr_bl_type ASSIGNING FIELD-SYMBOL(<lst_bl_type>).
          <lst_bl_type>-sign   = <lst_constant>-sign.
          <lst_bl_type>-option = <lst_constant>-opti.
          <lst_bl_type>-low    = <lst_constant>-low.
          <lst_bl_type>-high   = <lst_constant>-high.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF lv_bill_typ IN lr_bl_type.
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
    CONCATENATE lv_bil_doc                                           "Billing Document
                lc_pattrn                                            "Pattern (%)
           INTO lv_src_id.                                           "Source Item ID
*   Fetch Items for Class SD03 - Processed
    SELECT status                                                    "Status of Revenue Accounting Item
      FROM /1ra/0sd034mi
      INTO lv_status
     UP TO 1 ROWS
     WHERE srcdoc_comp   EQ if_farric_constants=>co_srcdoc_comp_sd   "Source Document Component of Revenue Accounting Items
       AND srcdoc_logsys EQ space                                    "Logical System of the Source Item
       AND srcdoc_type   EQ if_farric_constants=>co_srcdoc_type_sdii "Source Document Item Type: Invoice Item
       AND srcdoc_id     LIKE lv_src_id.                             "Source Item ID
    ENDSELECT.
    IF sy-subrc NE 0.                                                "Not yet processed in RAR
*     Release lock on object EVVBRKE
      CALL FUNCTION 'DEQUEUE_EVVBRKE'
        EXPORTING
          vbeln = lv_bil_doc.                                        "Billing Document
      sy-subrc = 2.                                                  "Skip with Information Message
    ENDIF.
* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
  ENDIF.
ENDIF.
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
