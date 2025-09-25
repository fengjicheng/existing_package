FUNCTION zqtc_entitlement_idoc_i0318.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC OPTIONAL
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWFAP_PAR-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWFAP_PAR-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"     REFERENCE(DOCUMENT_NUMBER) LIKE  VBAK-VBELN
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"      EDI_TEXT STRUCTURE  EDIORDTXT1 OPTIONAL
*"      EDI_TEXT_LINES STRUCTURE  EDIORDTXT2 OPTIONAL
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_IDOC_INPUT_ORDCHG_I0318 (Subscription Inbound Order)
* PROGRAM DESCRIPTION: FM for Subscription Order change
* DEVELOPER: Himanshu Patel
* CREATION DATE:  02/09/2018
* OBJECT ID: ERP-6918 (I0318)
* TRANSPORT NUMBER(S):  ED2K910736
* DESCRIPTION: New FM Created ZQTC_ENTITLEMENT_IDOC_I0318 for process
*              the Idoc for Subscription Order change.
*              1. Acceptance date
*              2. EAL Number (Item text) for Item
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

  DATA: lv_idocnum TYPE edi_docnum,                          "Idoc Number
        lst_return TYPE bapiret2.                            "Return table

  CONSTANTS: lc_mestyp TYPE edidc-mestyp VALUE 'ORDCHG',      "Message Type
             lc_idoctp TYPE edidc-idoctp VALUE 'ORDERS05'.    "Basic type


* FM should execute for message type ( ORDCHG ) , basic type ( ORDERS05 ) and
* message code ( XX ) else error message.

  IF   idoc_contrl-idoctp <> lc_idoctp
    OR idoc_contrl-mestyp <>  lc_mestyp.
    RAISE wrong_function_called.
  ENDIF. " IF   idoc_contrl-idoctp <> lc_idoctp

  CLEAR: li_ent_stat[], li_return[].

  SORT idoc_data BY docnum segnum.

  LOOP AT idoc_contrl INTO DATA(st_data).

*/////////////////////////
    LOOP AT  idoc_data INTO DATA(st_edidd) WHERE docnum = st_data-docnum.

*    Begin of case on Segnam
      CASE st_edidd-segnam.

        WHEN c_e1edk01.
          st_e1edk01 = st_edidd-sdata.
          lv_vbeln = st_e1edk01-belnr.

        WHEN c_e1edp01.
          st_e1edp01 = st_edidd-sdata.

        WHEN c_e1edp02.
          st_e1edp02 = st_edidd-sdata.
          st_ent_stat-fulfillment_id = st_e1edp02-ihrez.

        WHEN c_e1edp03.
          st_e1edp03 = st_edidd-sdata.
          st_ent_stat-licence_start_date = st_e1edp03-datum.
          READ TABLE idoc_data INTO DATA(st_edid_t) WITH KEY docnum = st_edidd-docnum
                                                             psgnum = st_edidd-psgnum
                                                             segnam = c_e1edpt1.
          IF sy-subrc NE 0.
            APPEND st_ent_stat TO li_ent_stat.
            CLEAR st_ent_stat.
          ENDIF.

        WHEN c_e1edpt1.
          st_e1edpt1 = st_edidd-sdata.

        WHEN c_e1edpt2.
          st_e1edpt2 = st_edidd-sdata.
          st_ent_stat-customer_id = st_e1edpt2-tdline.
          APPEND st_ent_stat TO li_ent_stat.
          CLEAR st_ent_stat.

      ENDCASE.

    ENDLOOP.  "LOOP AT  idoc_data INTO DATA(st_edidd) WHERE docnum = st_data-docnum.
    lv_idocnum = st_data-docnum.
*Change Contract acceptance date and EAL Number (Item text) for Item
    IF NOT li_ent_stat[] IS INITIAL.
      lv_flag = 'X'.                            " This flag is set for avoiding duplicate IDOC creation
      PERFORM f_update_sub_order USING lv_vbeln
                                       li_ent_stat
                                       lv_flag
                              CHANGING li_return.
      IF NOT li_return[] IS INITIAL.
*Write Idoc status
        PERFORM f_fill_idoc_status USING lv_idocnum
                                         lv_vbeln
                                         li_return
                                CHANGING idoc_status[].
      ENDIF.  "IF NOT li_return[] IS INITIAL.
    ELSE.
*If no records for Order to change, set Idoc status to error
      lst_return-type        = c_err.
      lst_return-id          = c_msg_cls.
      lst_return-number      = c_msgno_006.  "No data was found for your request
      lst_return-message_v1  = lv_vbeln.
      APPEND lst_return TO li_return.
      IF NOT li_return[] IS INITIAL.
*Write Idoc status
        PERFORM f_fill_idoc_status USING lv_idocnum
                                         lv_vbeln
                                         li_return
                                CHANGING idoc_status[].
      ENDIF.  "IF NOT li_return[] IS INITIAL.
    ENDIF.   "IF NOT li_ent_stat[] IS INITIAL.
  ENDLOOP.  "LOOP AT idoc_contrl INTO DATA(st_data).

ENDFUNCTION.
