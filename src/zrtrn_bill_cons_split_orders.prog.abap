*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_BILL_CONS_SPLIT_ORDERS (Include)
*                      [Called from Req Billing Doc Routine - 901]
* PROGRAM DESCRIPTION: Restrict creation of Invoice, if all Split-Orders
*                      are not being billed together
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       01/09/2018
* OBJECT ID:           E070
* TRANSPORT NUMBER(S): ED2K910219
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910524
* REFERENCE NO: ERP-6208
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01/26/2018
* DESCRIPTION: Consider Blocks, Statuses, Locks before using the
*              Document for counting
*              [Referred logic from "Copying Requirement Routine-001"]
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913055
* REFERENCE NO:  ERP-7635 - E174
* DEVELOPER:Prabhu <PTUFARAM>
* DATE:  8/14/2018
* DESCRIPTION:Consider Version number of ZSUB with Number of PO's
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF lty_con_po,
    vbeln    TYPE vbeln_va,                                "Sales Document
    bstkd    TYPE bstkd,                                   "Customer purchase order number
*--*Begin of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
    vkbur    TYPE vkbur,                                             "Sales Office
*--*End of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
    vsnmr_vl TYPE vsnmr_v,                                 "Sales document version number
* Begin of ADD:ERP-7635:WROY:26-Jan-2018:ED2K910524
    faksk    TYPE faksk,                                   "Billing block in SD document
    uvprs    TYPE uvprs_uk,                                "Document is incomplete with respect to pricing
    uvfak    TYPE uvfak_uk,                                "Header incompletion status with respect to billing
    uvfas    TYPE uvfak_su,                                "Total incompletion status of all items: Billing
    cmgst    TYPE cmgst,                                   "Overall status of credit checks
    fmstk    TYPE fmstk,                                   "Status Funds Management
* End   of ADD:ERP-7635:WROY:26-Jan-2018:ED2K910524
  END OF lty_con_po,
  ltt_con_po TYPE STANDARD TABLE OF lty_con_po INITIAL SIZE 0,

  BEGIN OF lty_po_all,
    bstkd    TYPE bstkd,                                   "Customer purchase order number
    count_po TYPE i,                                       "Count - POs
  END OF lty_po_all,
  ltt_po_all TYPE SORTED TABLE OF lty_po_all INITIAL SIZE 0
             WITH UNIQUE KEY bstkd.

* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
*--*Begin of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
TYPES : BEGIN OF lty_po_count,
          vbeln TYPE vbeln_va,
          bstnk TYPE bstnk,
        END OF lty_po_count.
DATA li_po_count  TYPE STANDARD TABLE OF lty_po_count.
CONSTANTS : lc_g     TYPE c VALUE 'G',
            lc_vkbur TYPE vkbur VALUE '0050'.
*--*End of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
DATA:
  li_enqueue TYPE /isdfps/seqg3_t.                         "Dialog Fields for Lock Display
* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524

STATICS:
  li_con_pos TYPE ltt_con_po,                              "Customer purchase order number of Contracts
  li_pos_all TYPE ltt_po_all.                              "Count based on Customer purchase order number

DATA:
  lv_count    TYPE i,
  lv_po_count TYPE i,                                     "Count - POs
  lv_stop_bl  TYPE flag,                                    "Flag: Stop Billing
* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
  lv_lck_arg  TYPE eqegraarg.                               "Argument String (=Key Fields) of Lock Entry
* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524

READ TABLE li_con_pos TRANSPORTING NO FIELDS
     WITH KEY vbeln = xkomfk-vbeln                         "Sales Document
     BINARY SEARCH.
IF sy-subrc NE 0.
  CLEAR: li_pos_all,
         li_con_pos.

  IF xkomfk[] IS NOT INITIAL.
*   Sales Document: Business / Header Data
    SELECT d~vbeln                                         "Sales Document
           d~bstkd                                         "Customer purchase order number
*--*Begin of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
           k~vkbur
*--End of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
           k~vsnmr_v                                       "Sales document version number
* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
           k~faksk                                         "Billing block in SD document
           u~uvprs                                         "Document is incomplete with respect to pricing
           u~uvfak                                         "Header incompletion status with respect to billing
           u~uvfas                                         "Total incompletion status of all items: Billing
           u~cmgst                                         "Overall status of credit checks
           u~fmstk                                         "Status Funds Management

* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
      FROM vbkd AS d INNER JOIN
           vbak AS k
* Begin of DEL:ERP-6208:WROY:26-Jan-2018:ED2K910524
*       ON k~vbeln EQ d~vbeln
* End   of DEL:ERP-6208:WROY:26-Jan-2018:ED2K910524
* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
        ON k~vbeln EQ d~vbeln INNER JOIN
           vbuk AS u
        ON u~vbeln EQ k~vbeln
* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
      INTO TABLE li_con_pos
       FOR ALL ENTRIES IN xkomfk
     WHERE d~vbeln EQ xkomfk-vbeln                         "Sales Document
       AND d~posnr EQ posnr_low.
    IF sy-subrc EQ 0.
      SORT li_con_pos BY vbeln.

* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
*     Determine unique Billing Block values
      DATA(li_con_pos_tmp) = li_con_pos.
      SORT li_con_pos_tmp BY faksk.
      DELETE ADJACENT DUPLICATES FROM li_con_pos_tmp
                   COMPARING faksk.
*     Fetch Billing: Blocking Reasons
*     SELECT * is used, since all the table fields will be needed
      SELECT *
        FROM tvfsp
        INTO TABLE @DATA(li_bill_blk_res)
         FOR ALL ENTRIES IN @li_con_pos_tmp
       WHERE faksp EQ @li_con_pos_tmp-faksk.
      IF sy-subrc EQ 0.
        SORT li_bill_blk_res BY faksp fkart.
      ENDIF.
    ENDIF.

    IF li_con_pos IS NOT INITIAL.
* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
      LOOP AT xkomfk ASSIGNING FIELD-SYMBOL(<lst_komfk>).
*       Identify Customer Purchase Order Number
        READ TABLE li_con_pos ASSIGNING FIELD-SYMBOL(<lst_con_po>)
             WITH KEY vbeln = <lst_komfk>-vbeln            "Sales Document
             BINARY SEARCH.
        IF sy-subrc EQ 0 AND
           <lst_con_po>-bstkd IS NOT INITIAL.              "Customer Purchase Order Number
* Begin of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524
*         Check for Billing Block
          IF <lst_con_po>-faksk IS NOT INITIAL.
            READ TABLE li_bill_blk_res TRANSPORTING NO FIELDS
                 WITH KEY faksp = <lst_con_po>-faksk
                          fkart = tvfk-fkart
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              CONTINUE.                                    "DO NOT Consider this document
            ENDIF.
          ENDIF.
*         Check for Pricing Status: Pricing Incomplete Indicator
          IF <lst_con_po>-uvprs NA ' C'.
            CONTINUE.                                      "DO NOT Consider this document
          ENDIF.
*         Check for Incompletion status for Billing Header
          IF <lst_con_po>-uvfak NA ' C'.
            CONTINUE.                                      "DO NOT Consider this document
          ENDIF.
*         Check for Overall Incompletion status for Billing Document
          IF <lst_con_po>-uvfas NA ' C'.
            CONTINUE.                                      "DO NOT Consider this document
          ENDIF.
*         Check for Credit limit check
          IF <lst_con_po>-cmgst CA 'BC'.
            CONTINUE.                                      "DO NOT Consider this document
          ENDIF.
*         Check for Funds-Management Status
          IF <lst_con_po>-fmstk CA 'A'.
            CONTINUE.                                      "DO NOT Consider this document
          ENDIF.
          IF <lst_con_po>-vbeln NE xkomfk-vbeln.
*           Check if the Document is locked
            CLEAR: lv_lck_arg,
                   li_enqueue.
            CONCATENATE sy-mandt                           "Client
                        <lst_con_po>-vbeln                 "Sales Document
                   INTO lv_lck_arg.                        "Argument String (=Key Fields) of Lock Entry
            CALL FUNCTION 'ENQUEUE_READ'
              EXPORTING
                garg                  = lv_lck_arg         "Argument String (=Key Fields) of Lock Entry
                guname                = space
              TABLES
                enq                   = li_enqueue         "Dialog Fields for Lock Display
              EXCEPTIONS
                communication_failure = 1
                system_failure        = 2
                OTHERS                = 3.
            IF sy-subrc EQ 0 AND
               li_enqueue IS NOT INITIAL.
              CONTINUE.                                    "DO NOT Consider this document
            ENDIF.
          ENDIF.
* End   of ADD:ERP-6208:WROY:26-Jan-2018:ED2K910524

*         Count Number of Sales Document based on Customer Purchase Order Number
          READ TABLE li_pos_all INTO DATA(lst_po_all)
               WITH KEY bstkd = <lst_con_po>-bstkd         "Customer Purchase Order Number
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            DATA(lv_tabix) = sy-tabix.
            lst_po_all-count_po = lst_po_all-count_po + 1. "Count - POs
            MODIFY li_pos_all FROM lst_po_all INDEX lv_tabix
                   TRANSPORTING count_po.
          ELSE.
            CLEAR: lst_po_all.
            lst_po_all-bstkd    = <lst_con_po>-bstkd.      "Customer Purchase Order Number
            lst_po_all-count_po = lst_po_all-count_po + 1. "Count - POs
            INSERT lst_po_all INTO TABLE li_pos_all.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.

READ TABLE li_con_pos ASSIGNING <lst_con_po>
     WITH KEY vbeln = xkomfk-vbeln
     BINARY SEARCH.
IF sy-subrc EQ 0 AND
   <lst_con_po>-vsnmr_vl IS NOT INITIAL AND                "Sales document version number
   <lst_con_po>-bstkd    IS NOT INITIAL.                   "Customer Purchase Order Number
*--*Begin of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
  IF <lst_con_po>-vkbur = lc_vkbur.  "Check Sales office
*--*End of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
* Version field will store the Count of Split-Orders from Source System
    TRY.
        lv_count = <lst_con_po>-vsnmr_vl.                    "Sales document version number
      CATCH cx_root.
        CLEAR: lv_count.
    ENDTRY.
* Determine the Count of Split-Orders from Invoice Due List
    READ TABLE li_pos_all INTO lst_po_all
         WITH KEY bstkd = <lst_con_po>-bstkd                 "Customer Purchase Order Number
         BINARY SEARCH.
    IF sy-subrc EQ 0. "AND
*--*Begin of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
      CLEAR : li_po_count,lv_po_count.
*--*Get the Count of all Contracts for the PO
      SELECT vbeln bstnk  FROM vbak INTO TABLE li_po_count
                              WHERE vbtyp = lc_g
                               AND  bstnk = <lst_con_po>-bstkd.
*     lst_po_all-count_po NE lv_count.                      "Counts are not same
      IF sy-subrc EQ 0.
*--* Check the PO count with Version number
        DESCRIBE TABLE li_po_count LINES lv_po_count.
        IF lv_po_count NE lv_count.
          lv_stop_bl = abap_true.                                "Flag: Stop Billing
        ENDIF.
      ELSE.
        sy-subrc = 0.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
*--*ENDIF of ADD:ERP-7635:PTUFARAM: 8/14/2018:ED2K913055
IF lv_stop_bl IS NOT INITIAL.                              "Flag: Stop Billing
* Write Error Log
  PERFORM vbfs_hinzufuegen_allg USING xkomfk-vbeln
                                      posnr_low
                                      'ZQTC_R2'
                                      'E'
                                      '240'
                                      space
                                      space
                                      space
                                      space.
  sy-subrc = 4.
ENDIF.
