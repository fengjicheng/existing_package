FUNCTION ZQTC_GOBI_DOCUMENT_CREATION.
*"--------------------------------------------------------------------
*"*"Global Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWFAP_PAR-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWFAP_PAR-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"     VALUE(DOCUMENT_NUMBER) LIKE  VBAK-VBELN
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"      EDI_TEXT STRUCTURE  EDIORDTXT1 OPTIONAL
*"      EDI_TEXT_LINES STRUCTURE  EDIORDTXT2 OPTIONAL
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SALES_ORDER_CONV_I0338 (Subscription Inbound Order)
* PROGRAM DESCRIPTION: Include for Subscription Inbound Order
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   30/01/2017
* OBJECT ID: I0338
* TRANSPORT NUMBER(S):  ED2K904103
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K905441
* REFERENCE NO: I0338
* DEVELOPER: Lucky Kodwani
* DATE:  2017-04-17
* DESCRIPTION:QA Fix
* Begin of change:LKODWANI:ED2K905441:2017-04-17
* End of change:LKODWANI:ED2K905441:2017-04-17
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907618
* REFERENCE NO: I0338 (ERP-3599)
* DEVELOPER: Writtick Roy
* DATE:  2017-07-29
* DESCRIPTION: Add logic for Customer Purchase Order Type
* Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* Begin of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
* End   of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
*----------------------------------------------------------------------*
* REVISION NO: ED2K909052
* REFERENCE NO: I0338 (CR#696 / ERP-4665)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 19-OCT-2017
* DESCRIPTION: Code has been enhanced to include the change of email address
*               for bill to and ship to Parters. In Idoc email address will
*               be in E1EDKA3 for Qualf 005.
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
*====================================================================*
* Local Variable
*====================================================================*
  DATA :
    lv_v1            TYPE symsgv,     " Message1
    lv_v2            TYPE symsgv,     " Message2
    lv_v3            TYPE symsgv,     " Message3
    lv_v4            TYPE symsgv,     " Message4
    lv_belnr         TYPE vbeln_nach, " Reference number
    lv_renew         TYPE auart,      " Renew order type
*   Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
    lv_cust_po_type  TYPE bsark,      " Customer Purchase Order Type
*   End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
    lv_salesdocument TYPE vbeln_va,   " Sales document number
    lst_e1edk36      TYPE e1edk36,    " E1EDK36
    lst_e1edk14      TYPE e1edk14,    " E1EDK14
    lst_e1edk02      TYPE e1edk02,    " E1EDK02
* Begin of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
    lst_e1edka1      TYPE e1edka1,    " E1EDKA1
    lst_e1edka3      TYPE e1edka3,    " E1EDKA3
    lst_data_a3      TYPE edidd.
* End of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052

*   Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
  CONSTANTS:
    lc_qualf_012 TYPE edi_qualfo VALUE '012', " Order type
    lc_qualf_019 TYPE edi_qualfo VALUE '019'. " PO type (SD)
*   End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
  SORT idoc_data BY segnam.



* FM should execute for message type ( ORDERS ) , basic type ( ORDERS05 ) and
* message code ( Z6 ).Otherwise raise error

  LOOP AT idoc_contrl INTO DATA(lst_data).

* Read if Reference document ( Quotation ) is available in segment
* Otherwise do not go further

*/////////////////////////
    LOOP AT  idoc_data INTO DATA(lst_edidd).

*    Begin of case on Segnam
      CASE lst_edidd-segnam.

        WHEN c_e1edk02.

          lst_e1edk02 = lst_edidd-sdata.
          lv_belnr    = lst_e1edk02-belnr.

* If reference number is missing , raise error , otherwise go further
          IF lv_belnr IS NOT INITIAL.

* Check if it's duplicate posting with reference to same Quotation
* Check if any Subscription order is already present, populate error
* otherwise go further.Ideally there will be only one entry present
* for duplicate subscription order
            SELECT vbelv, posnv, vbeln
              FROM vbfa " Sales Document Flow
              INTO TABLE @DATA(li_sales)
              WHERE vbelv = @lv_belnr.
            IF sy-subrc NE 0.
              FREE li_sales.
            ENDIF. " IF sy-subrc NE 0
          ENDIF. " IF lv_belnr IS NOT INITIAL
*/////////////
        WHEN c_e1edk14.

          lst_e1edk14 = lst_edidd-sdata.
*         Begin of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
*         lv_renew = lst_e1edk14-orgid. " Subscription Order type
*         End   of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
*         Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
          CASE lst_e1edk14-qualf.
            WHEN lc_qualf_012.                     " Order type
              lv_renew        = lst_e1edk14-orgid. " Subscription Order type
*         End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* Validate if any subscription order exists with same quotation
              IF li_sales[] IS NOT INITIAL.
                SELECT vbeln, rplnr
                  FROM vbak                     " Sales Document: Header Data
                  INTO TABLE @DATA(li_sub_order)
                  FOR ALL ENTRIES IN @li_sales
                  WHERE vbeln = @li_sales-vbeln " Subscription Order
                  AND auart = @lv_renew.        " Subscription Order type
                IF sy-subrc NE 0.
* Order already present with same Quotation .So it is duplicate
                  FREE li_sub_order.
                ENDIF. " IF sy-subrc NE 0
              ENDIF. " IF li_sales[] IS NOT INITIAL

*         Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
            WHEN lc_qualf_019.                     " PO type (SD)
              lv_cust_po_type = lst_e1edk14-orgid. " Customer Purchase Order Type
            WHEN OTHERS.
*             Nothing to do
          ENDCASE.
*         End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* Begin of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
*/////////////
        WHEN c_e1edka1.
          lst_e1edka1 =  lst_edidd-sdata.
          CASE lst_e1edka1-parvw.
            WHEN c_parvw_re.
              st_e1edka1_re = lst_e1edka1.
              READ TABLE idoc_data INTO lst_data_a3 WITH KEY segnam = c_e1edka3
                                                             psgnum = lst_edidd-segnum.
              IF sy-subrc EQ 0.
                lst_e1edka3 = lst_data_a3-sdata.
                CASE lst_e1edka3-qualp.
                  WHEN c_qualf_005.
                    IF lst_e1edka3-stdpn IS NOT INITIAL.
                      v_email_bp  = lst_e1edka3-stdpn.
                    ENDIF.

                  WHEN OTHERS.
                ENDCASE.
              ENDIF.
            WHEN c_parvw_we.
              st_e1edka1_we = lst_e1edka1.
              CLEAR lst_data_a3.
              READ TABLE idoc_data INTO lst_data_a3 WITH KEY segnam = c_e1edka3
                                                             psgnum = lst_edidd-segnum.
              IF sy-subrc EQ 0.
                lst_e1edka3 = lst_data_a3-sdata.
                CASE lst_e1edka3-qualp.
                  WHEN c_qualf_005.
                    IF lst_e1edka3-stdpn IS NOT INITIAL.
                      v_email_sh  = lst_e1edka3-stdpn.
                    ENDIF.

                  WHEN OTHERS.
                ENDCASE.
              ENDIF.

            WHEN c_parvw_rg.
              st_e1edka1_rg = lst_e1edka1.
            WHEN OTHERS.
          ENDCASE.
* End of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
*/////////////
        WHEN c_e1edk36.
          lst_e1edk36 = lst_edidd-sdata.

        WHEN OTHERS.
*         No actons
      ENDCASE.
    ENDLOOP. " LOOP AT idoc_data INTO DATA(lst_edidd)

*////////////////////////////////////////

* Create Contract with reference to Quotation when Subscription
* order is not created with same reference
    IF li_sub_order IS INITIAL.
      PERFORM f_fill_bapi USING lv_belnr
                                lv_renew
*                               Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                lv_cust_po_type
*                               End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                lst_data-docnum
                                lst_e1edk36.
* There can be 2 scenarios.i)Payment details updated along with
* subscription order.ii)payment details not updated in subscription
* order , but subscription order created
    ELSE. " ELSE -> IF li_sub_order IS INITIAL

      READ TABLE li_sub_order INTO DATA(lst_lines) INDEX 1.
      IF lst_lines-rplnr NE space.
* when it is duplicate , populate error message
        lv_v1 = text-001. " 'Subscription Order'
        lv_v2 = text-003. " 'already present for'
        lv_v3 = lv_belnr.
        PERFORM f_fill_status USING lst_data-docnum
                              c_status " 51
                              c_error
                              c_id_s
                              c_msg_no_e
                              lv_v1
                              lv_v2
                              lv_v3
                              lv_v4.
        CLEAR : lv_v1 , lv_v2, lv_v3,lv_v4.
      ELSE. " ELSE -> IF lst_lines-rplnr NE space
* Update only Payment details
        lv_salesdocument = lst_lines-vbeln.

        PERFORM f_payment_update USING lst_e1edk36
                                       lv_salesdocument
*                                      Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                       lv_cust_po_type
*                                      End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                       lst_data-docnum.

      ENDIF. " IF lst_lines-rplnr NE space
    ENDIF. " IF li_sub_order IS INITIAL

    FREE : li_sub_order[],li_sales[].

* BOC:ED2K913394:GKINTALI:09/19/2018:INC0206656
    READ TABLE idoc_status TRANSPORTING NO FIELDS
         WITH KEY docnum = lst_data-docnum
                  status = c_succ. " 53
    IF sy-subrc = 0.
    ELSE.
* To trigger the error handling workflow, pass the workflow parameters.
      CLEAR return_variables.
      return_variables-doc_number = lst_data-docnum.
      return_variables-wf_param   = c_retv_error_idocs.
      APPEND return_variables.

      workflow_result = 99999.
    ENDIF.
* EOC:ED2K913394:GKINTALI:09/19/2018:INC0206656

  ENDLOOP. " LOOP AT idoc_contrl INTO DATA(lst_data)
ENDFUNCTION.
