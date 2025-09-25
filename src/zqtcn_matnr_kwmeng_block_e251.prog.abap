*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Material and Order quantity Block
* Req - 1   when Material ID is changed
* Req - 2.1 when Order quantity is changed
* Req - 2.2, 2.3, 2.4 when Target quantity is changed
* Req - 3   when Contract dates are changed
* Note : 1. As each changed line item is addressed, No need of saperate
*           logic for 2.4. In 2.2 and 2.3 only 2.4 logic works.
*        2. If the user has no authorization, he will get popup message
*           IF the user has authorization, his is changes are saved
* REFERENCE NO: E251 - ERPM-17773
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-13-2020
* TRANSPORT NUMBER(s): ED2K918882
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MATNR_KWMENG_BLOCK_E251
*&---------------------------------------------------------------------*

* Type Declaration
TYPES : BEGIN OF lty_order_type,
          devid    TYPE zdevid,              " Development ID
          param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          " ABAP: Current selection number
          sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          activate TYPE zconstactive,        " Activation indicator for constant
        END OF   lty_order_type,
        BEGIN OF lty_jksesched,
          vbeln	         TYPE vbeln,           " Sales and Distribution Document Number
          posnr	         TYPE posnr,           " Item number of the SD document
          issue	         TYPE ismmatnr_issue,  " Media Issue
          xorder_created TYPE jmorder_created, " IS-M: Indicator Denoting that Order Was Generated
        END OF lty_jksesched,
        BEGIN OF lty_marc,
          matnr	           TYPE matnr,         " Material Number
          werks            TYPE werks_d,       " Plant
          ismarrivaldateac TYPE ismanlftagi,   " Actual Goods Arrival Date
        END OF lty_marc,
        BEGIN OF lty_mara,
          matnr	TYPE matnr,                    " Material Number
          mtart	TYPE mtart,	                                                                                                    " Material Type
        END OF lty_mara,
        BEGIN OF lty_jkseflow,
          contract_vbeln TYPE jvbelncontract,  " Contract Number
          contract_posnr TYPE jposnrcontract,  " Item Number in Contract
          shipping_date	 TYPE jshipping_date,  " IS-M: Delivery Date
        END OF lty_jkseflow.

* Local Constant Declaration
CONSTANTS : lc_e251       TYPE zdevid     VALUE 'E251',  " Development ID
            lc_order_type TYPE rvari_vnam VALUE 'AUART', " ABAP: Name of Variant Variabl
            lc_order      TYPE rvari_vnam VALUE 'ORDER', " Order
            lc_contract   TYPE rvari_vnam VALUE 'CONTRACT', " Contract
            lc_pstyv      TYPE rvari_vnam VALUE 'PSTYV',    " Item Category
            lc_arvl_dat   TYPE rvari_vnam VALUE 'CONTRACT_ARVL_DAT', " Arrival Date
            lc_accp_dat   TYPE rvari_vnam VALUE 'CONTRACT_ACCP_DAT', " Acceptance Date
            lc_tcode_va02 TYPE syst_tcode VALUE 'VA02',  " VA02 t-code
            lc_tcode_va42 TYPE syst_tcode VALUE 'VA42',  " VA42 t-code
            lc_tcode_va45 TYPE syst_tcode VALUE 'VA45',  " VA45 t-code
            lc_x          TYPE c          VALUE 'X',     " Flag
            lc_j          TYPE c          VALUE 'J',     " Delivery
            lc_xveda      TYPE char40     VALUE '(SAPLV45W)XVEDA[]',
            lc_yveda      TYPE char40     VALUE '(SAPLV45W)YVEDA[]',
            lc_zsbe       TYPE mtart      VALUE 'ZSBE', " Journal Media Product
            lc_znjd       TYPE mtart      VALUE 'ZNJD', " Non Journals Digital
            lc_actvt(2)   TYPE c          VALUE '02'.   " Declare numerical activity indicator

* local Internal Table Declaration
DATA : li_zcaconst             TYPE STANDARD TABLE OF lty_order_type INITIAL SIZE 0,
       li_auart_range          TYPE fip_t_auart_range, " Range: Sales Document Type
       li_order_range          TYPE fip_t_auart_range, " Range: Sales Document Type
       li_contract_range       TYPE fip_t_auart_range, " Range: Sales Document Type
       li_arvl_dat_pstyv_range TYPE fip_t_auart_range, " Range: Sales Document Item Cat
       li_accp_dat_pstyv_range TYPE fip_t_auart_range, " Range: Sales Document Item Cat
       lst_auart_range         TYPE fip_s_auart_range,
       li_jksesched            TYPE STANDARD TABLE OF lty_jksesched INITIAL SIZE 0,
       li_jksesched_veda       TYPE STANDARD TABLE OF lty_jksesched INITIAL SIZE 0,
       li_marc                 TYPE STANDARD TABLE OF lty_marc INITIAL SIZE 0,
       li_marc_veda            TYPE STANDARD TABLE OF lty_marc INITIAL SIZE 0,
       li_mara                 TYPE STANDARD TABLE OF lty_mara INITIAL SIZE 0,
       li_mara_veda            TYPE STANDARD TABLE OF lty_mara INITIAL SIZE 0,
       li_jkseflow             TYPE STANDARD TABLE OF lty_jkseflow INITIAL SIZE 0,
       lv_changed              TYPE c,
       li_xveda                TYPE STANDARD TABLE OF vedavb, " Reference Structure XVEDA/YVEDA
       li_yveda                TYPE STANDARD TABLE OF vedavb, " Reference Structure XVEDA/YVEDA
       lv_tabix                TYPE syst_tabix,               " Row index of internal table
       yvbap_temp              LIKE TABLE OF yvbap.

* Local Field symbols declaration
FIELD-SYMBOLS:
  <lfs_xveda> TYPE any, " Changed records with new values, Unchanged records with old values
  <lfs_yveda> TYPE any. " Changed records with old values

* Material and Order quantity Block
CASE t180-tcode.
* When Contract / Order is in change mode
  WHEN lc_tcode_va02 OR lc_tcode_va42 OR lc_tcode_va45.
    CLEAR : lv_changed, lv_tabix.
    IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
      " Get The sales order type from zcaconstant Table
      SELECT devid       "Development ID
             param1	     "ABAP: Name of Variant Variable
             param2	     "ABAP: Name of Variant Variable
             srno	       "ABAP: Current selection number
             sign	       "ABAP: ID: I/E (include/exclude values)
             opti	       "ABAP: Selection option (EQ/BT/CP/...)
             low         "Lower Value of Selection Condition
             high	       "Upper Value of Selection Condition
             activate    "Activation indicator for constant
        FROM zcaconstant "Wiley Application Constant Table
        INTO TABLE li_zcaconst
       WHERE devid  = lc_e251
         AND activate = abap_true.
      IF sy-subrc EQ 0.
        SORT li_zcaconst BY param1.
        LOOP AT li_zcaconst ASSIGNING FIELD-SYMBOL(<lst_zcaconst>).
          lst_auart_range-sign = <lst_zcaconst>-sign.
          lst_auart_range-option = <lst_zcaconst>-opti.
          lst_auart_range-low = <lst_zcaconst>-low.
          CASE <lst_zcaconst>-param1.
            WHEN lc_order_type. " AUART
              APPEND lst_auart_range TO li_auart_range.
              CASE <lst_zcaconst>-param2.
                WHEN lc_order. " ORDER
                  APPEND lst_auart_range TO li_order_range.
                WHEN lc_contract. " CONTRACT
                  APPEND lst_auart_range TO li_contract_range.
              ENDCASE.
            WHEN lc_pstyv. " PSTYV
              CASE <lst_zcaconst>-param2.
                WHEN lc_arvl_dat. " CONTRACT_ARVL_DAT
                  APPEND lst_auart_range TO li_arvl_dat_pstyv_range.
                WHEN lc_accp_dat. " CONTRACT_ACCP_DAT
                  APPEND lst_auart_range TO li_accp_dat_pstyv_range.
              ENDCASE.
          ENDCASE.
          CLEAR: lst_auart_range.
        ENDLOOP.

        " When the order type is same as maintained in ZCACONSTANT table
        IF vbak-auart IN li_auart_range.

          " *** Requirement - 3 ***
          " When Contract dates are changed at line items
          " For order types ZSUB / ZREW
          IF vbak-auart IN li_contract_range.
            " For Contracts
            IF ( t180-tcode EQ lc_tcode_va42 ) OR
               ( t180-tcode EQ lc_tcode_va45 ).
              " Read XVEDA[]
              ASSIGN (lc_xveda) TO <lfs_xveda>.
              IF <lfs_xveda> IS ASSIGNED.
                " Get values of table XVEDA
                li_xveda[] = <lfs_xveda>.
                SORT li_xveda BY vbeln vposn.
              ENDIF.
              " Read changed line items of YVEDA[]
              ASSIGN (lc_yveda) TO <lfs_yveda>.
              IF <lfs_yveda> IS ASSIGNED.
                " Get values of table YVEDA
                li_yveda[] = <lfs_yveda>.
                SORT li_yveda BY vbeln vposn.
              ENDIF.
            ENDIF.
          ENDIF. " IF vbak-auart IN li_contract_range.

          " When item no, material id and order quantity are changed at any line item
          IF yvbap IS NOT INITIAL.

            " *** Requirement - 2 - Order quantity changes ***
            " 2.2, 2.3, 2.4 For order types ZSUB / ZREW
            IF vbak-auart IN li_contract_range.
              " For Contracts
              IF t180-tcode EQ lc_tcode_va42.
                " Fetching IS-M: Media Schedule Lines
                SELECT vbeln posnr issue xorder_created
                  FROM jksesched
                  INTO TABLE li_jksesched
                  FOR ALL ENTRIES IN yvbap
                  WHERE vbeln EQ yvbap-vbeln
                    AND posnr EQ yvbap-posnr.
                IF sy-subrc EQ 0.
                  SORT li_jksesched BY issue.
                  SELECT matnr werks ismarrivaldateac
                    FROM marc
                    INTO TABLE li_marc
                    FOR ALL ENTRIES IN li_jksesched
                    WHERE matnr EQ li_jksesched-issue
                      AND ismarrivaldateac NE '00000000'.
                  IF sy-subrc EQ 0.
                    SORT li_marc BY matnr.
                  ENDIF.
                ENDIF.
                SELECT matnr mtart
                    FROM mara
                    INTO TABLE li_mara
                    FOR ALL ENTRIES IN yvbap
                    WHERE matnr EQ yvbap-matnr.
                IF sy-subrc EQ 0.
                  SORT li_mara BY matnr.
                ENDIF.
              ENDIF. " IF t180-tcode EQ lc_tcode_va42.
            ENDIF. " IF vbak-auart IN li_contract_range.

            " Loop all modified line items
            LOOP AT yvbap ASSIGNING FIELD-SYMBOL(<lst_yvbap>).
              READ TABLE xvbap ASSIGNING FIELD-SYMBOL(<lst_xvbap>)
                WITH KEY vbeln = <lst_yvbap>-vbeln
                         posnr = <lst_yvbap>-posnr.
              IF sy-subrc EQ 0.

                " *** Requirement - 1 - Item, Material ID changes ***
                " If Item number or Material ID is changed
                IF ( <lst_yvbap>-posnr NE <lst_xvbap>-posnr ) OR
                   ( <lst_yvbap>-matnr NE <lst_xvbap>-matnr ).
                  " Check if user is authorized to work on this area
                  AUTHORITY-CHECK OBJECT 'ZBLK_E251'
                    ID 'ACTVT'   FIELD lc_actvt.
                  " If authorization check is positive
                  IF sy-subrc NE 0.
                    lv_changed = lc_x.
                    EXIT.
                  ENDIF. " IF SY-SUBRC EQ 0.
                ENDIF.

                " *** Requirement - 2 - Order quantity changes ***
                " 2.1 For order types ZOR / ZFOC / ZCLM
                IF vbak-auart IN li_order_range.
                  " For Orders
                  IF t180-tcode EQ lc_tcode_va02.
                    " If Order Quantity is changed
                    IF <lst_yvbap>-kwmeng NE <lst_xvbap>-kwmeng.
                      " Check if user is authorized to work on this area
                      AUTHORITY-CHECK OBJECT 'ZBLK_E251'
                        ID 'ACTVT'   FIELD lc_actvt.
                      " If authorization check is positive
                      IF sy-subrc NE 0.
                        " *** Scenario - 1 ***
                        " Check Delivery is available for the Order
                        READ TABLE xvbfa ASSIGNING FIELD-SYMBOL(<lst_xvbfa>)
                          WITH KEY vbelv = <lst_yvbap>-vbeln
                                   posnv = <lst_yvbap>-posnr
                                   vbtyp_n = lc_j.  " Delivery
                        " If Delivery is available
                        IF sy-subrc EQ 0.
                          lv_changed = lc_x.
                          EXIT.
                        ENDIF.

                        " *** Scenario - 2 ***
                        " Check Purchase Requisition is available for the Order
                        READ TABLE xvbep ASSIGNING FIELD-SYMBOL(<lst_xvbep>)
                          WITH KEY vbeln = <lst_yvbap>-vbeln
                                   posnr = <lst_yvbap>-posnr.
                        " If Purchase Requisition is available
                        IF sy-subrc EQ 0 AND
                          ( <lst_xvbep>-etenr IS NOT INITIAL AND
                            <lst_xvbep>-banfn IS NOT INITIAL ).
                          lv_changed = lc_x.
                          EXIT.
                        ENDIF.
                      ENDIF. " IF SY-SUBRC EQ 0.
                    ENDIF. " IF <lst_yvbap>-kwmeng NE <lst_xvbap>-kwmeng.
                  ENDIF. " IF t180-tcode EQ lc_tcode_va02.

                  " 2.2, 2.3, 2.4 For order types ZSUB / ZREW
                ELSEIF vbak-auart IN li_contract_range.
                  " For Contracts
                  IF t180-tcode EQ lc_tcode_va42.
                    " If Target Quantity is changed
                    IF <lst_yvbap>-zmeng NE <lst_xvbap>-zmeng.
                      " Check if user is authorized to work on this area
                      AUTHORITY-CHECK OBJECT 'ZBLK_E251'
                        ID 'ACTVT'   FIELD lc_actvt.
                      " If authorization check is positive
                      IF sy-subrc NE 0.
                        " 2.2 Release Orders
                        IF li_jksesched IS NOT INITIAL.
                          SORT li_jksesched BY vbeln posnr xorder_created.
                          " 2.2 Release Orders
                          " Check Print once release order is created.
                          READ TABLE li_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>)
                            WITH KEY vbeln = <lst_yvbap>-vbeln
                                     posnr = <lst_yvbap>-posnr
                                     xorder_created = lc_x
                                     BINARY SEARCH.
                          IF sy-subrc EQ 0.
                            lv_changed = lc_x.
                            EXIT.
                          ELSE.
                            " 2.3 Digital
                            " Checking of arrival date
                            IF li_marc IS NOT INITIAL.
                              READ TABLE li_jksesched TRANSPORTING NO FIELDS
                              WITH KEY vbeln = <lst_yvbap>-vbeln
                                       posnr = <lst_yvbap>-posnr
                                       BINARY SEARCH.
                              IF sy-subrc EQ 0.
                                CLEAR lv_tabix.
                                lv_tabix = sy-tabix.
                                LOOP AT li_jksesched FROM lv_tabix ASSIGNING <lst_jksesched>.
                                  IF <lst_jksesched>-vbeln EQ <lst_yvbap>-vbeln
                                    AND <lst_jksesched>-posnr EQ <lst_yvbap>-posnr.
                                    READ TABLE li_marc ASSIGNING FIELD-SYMBOL(<lst_marc>)
                                      WITH KEY matnr = <lst_jksesched>-issue
                                               BINARY SEARCH.
                                    IF sy-subrc EQ 0.
                                      " *** Condition - 1 ***
                                      IF <lst_yvbap>-pstyv IN li_arvl_dat_pstyv_range.
                                        lv_changed = lc_x.
                                        EXIT.
                                      ENDIF. " IF yvbap-pstyv IN li_arvl_dat_pstyp_range.
                                      " *** Condition - 2 ***
                                      READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lst_mara>)
                                        WITH KEY matnr = <lst_yvbap>-matnr
                                                 mtart = lc_zsbe BINARY SEARCH.
                                      IF sy-subrc EQ 0.
                                        lv_changed = lc_x.
                                        EXIT.
                                      ENDIF.
                                    ENDIF. " IF sy-subrc EQ 0.
                                  ELSE.
                                    EXIT.
                                  ENDIF.
                                ENDLOOP.
                              ENDIF. " IF sy-subrc EQ 0.
                            ENDIF. " IF li_marc IS NOT INITIAL.
                            IF lv_changed IS NOT INITIAL.
                              EXIT. " Come out of Outer loop
                            ENDIF.
                          ENDIF. " IF sy-subrc EQ 0.
                        ENDIF. " IF li_jksesched IS NOT INITIAL.

                        " For checking the Acceptance date for Non Journal
                        IF <lst_yvbap>-pstyv IN li_accp_dat_pstyv_range.
                          READ TABLE li_mara ASSIGNING <lst_mara>
                                WITH KEY matnr = <lst_yvbap>-matnr
                                         mtart = lc_znjd BINARY SEARCH.
                          IF sy-subrc EQ 0.
                            IF li_xveda IS NOT INITIAL.
                              READ TABLE li_xveda ASSIGNING FIELD-SYMBOL(<lst_xveda>)
                                WITH KEY vbeln = <lst_xvbap>-vbeln
                                         vposn = <lst_xvbap>-posnr.
                              IF sy-subrc EQ 0 AND <lst_xveda>-vabndat IS NOT INITIAL.
                                lv_changed = lc_x.
                                EXIT.
                              ENDIF.
                            ENDIF. " IF li_yveda IS NOT INITIAL.
                          ENDIF. " IF sy-subrc EQ 0.
                        ENDIF. " IF <lst_yvbap>-pstyv IN li_accp_dat_pstyv_range.
                      ENDIF. " IF SY-SUBRC EQ 0.
                    ENDIF. " IF <lst_yvbap>-zmeng NE <lst_xvbap>-zmeng.
                  ENDIF. " IF t180-tcode EQ lc_tcode_va42.
                ENDIF. " IF vbak-auart IN li_order_range.
              ENDIF. " IF sy-subrc EQ 0.
            ENDLOOP. " LOOP AT yvbap ASSIGNING FIELD-SYMBOL(<lst_yvbap>).
          ENDIF. " IF yvbap IS NOT INITIAL.

          " *** Requirement - 3 ***
          " When Contract dates are changed at line items
          " For order types ZSUB / ZREW
          IF lv_changed IS INITIAL AND vbak-auart IN li_contract_range.
            " For Contracts
            IF ( t180-tcode EQ lc_tcode_va42 ) OR
               ( t180-tcode EQ lc_tcode_va45 ).
              " When Contract dates are changed at any line item
              IF li_yveda IS NOT INITIAL.
                " Fetching IS-M: Document Flow for Generated Orders ISP
                SELECT contract_vbeln contract_posnr shipping_date
                  FROM jkseflow
                  INTO TABLE li_jkseflow
                  FOR ALL ENTRIES IN li_yveda
                  WHERE contract_vbeln EQ li_yveda-vbeln
                    AND contract_posnr EQ li_yveda-vposn.
                IF sy-subrc EQ 0.
                  SORT li_jkseflow BY contract_vbeln ASCENDING
                                      contract_posnr ASCENDING
                                      shipping_date  ASCENDING.

                ENDIF. " IF sy-subrc EQ 0.
                LOOP AT li_yveda ASSIGNING FIELD-SYMBOL(<lst_yveda>).
                  READ TABLE xvbap ASSIGNING <lst_xvbap>
                                WITH KEY vbeln = <lst_yveda>-vbeln
                                         posnr = <lst_yveda>-vposn.
                  IF sy-subrc EQ 0.
                    APPEND <lst_xvbap> TO yvbap_temp.
                  ENDIF.
                ENDLOOP.
                " Fetching IS-M: Media Schedule Lines
                SELECT vbeln posnr issue xorder_created
                  FROM jksesched
                  INTO TABLE li_jksesched_veda
                  FOR ALL ENTRIES IN li_yveda
                  WHERE vbeln EQ li_yveda-vbeln
                    AND posnr EQ li_yveda-vposn.
                IF sy-subrc EQ 0.
                  SORT li_jksesched_veda BY issue.
                  SELECT matnr werks ismarrivaldateac
                    FROM marc
                    INTO TABLE li_marc_veda
                    FOR ALL ENTRIES IN li_jksesched_veda
                    WHERE matnr EQ li_jksesched_veda-issue
                      AND ismarrivaldateac NE '00000000'.
                  IF sy-subrc EQ 0.
                    SORT li_marc_veda BY werks.
                    SORT yvbap_temp BY werks.
                    LOOP AT li_marc_veda ASSIGNING <lst_marc>.
                      READ TABLE yvbap_temp ASSIGNING FIELD-SYMBOL(<lst_vbap_temp>)
                        WITH KEY werks = <lst_marc>-werks
                        BINARY SEARCH.
                      IF sy-subrc NE 0.
                        CLEAR: <lst_marc>-werks.
                      ENDIF.
                    ENDLOOP.
                    DELETE li_marc_veda WHERE werks IS INITIAL.
                    SORT li_marc_veda BY matnr.
                  ENDIF.
                ENDIF.
                SORT yvbap_temp BY matnr.
                SELECT matnr mtart
                    FROM mara
                    INTO TABLE li_mara_veda
                    FOR ALL ENTRIES IN yvbap_temp
                    WHERE matnr EQ yvbap_temp-matnr.
                IF sy-subrc EQ 0.
                  SORT li_mara_veda BY matnr.
                ENDIF.

                " Loop all modified line items
                " Nested loops with Parallel cursor technique is used for
                "   better performance
                LOOP AT li_yveda ASSIGNING <lst_yveda>.
                  READ TABLE li_xveda ASSIGNING <lst_xveda>
                    WITH KEY vbeln = <lst_yveda>-vbeln
                             vposn = <lst_yveda>-vposn.
                  IF sy-subrc EQ 0.
                    " If Contract dates are changed
                    IF <lst_yveda>-vbegdat NE <lst_xveda>-vbegdat OR
                       <lst_yveda>-venddat NE <lst_xveda>-venddat.
                      " Check if user is authorized to work on this area
                      AUTHORITY-CHECK OBJECT 'ZBLK_E251'
                        ID 'ACTVT'   FIELD lc_actvt.
                      " If authorization check is positive
                      IF sy-subrc NE 0.
                        IF li_jkseflow IS NOT INITIAL.
                          DATA(li_jkseflow_temp) = li_jkseflow.
                          DELETE li_jkseflow_temp WHERE contract_posnr NE <lst_xveda>-vposn.
                          LOOP AT li_jkseflow_temp ASSIGNING FIELD-SYMBOL(<lst_jkseflow>).
                            " Compare contract start date with the oldest shipping date
                            AT FIRST.
                              IF <lst_xveda>-vbegdat GT <lst_jkseflow>-shipping_date.
                                lv_changed = lc_x.
                                EXIT. " Come out of Inner loop
                              ENDIF.
                            ENDAT.
                            " Compare contract end date with the latest shipping date
                            AT LAST.
                              IF <lst_xveda>-venddat LT <lst_jkseflow>-shipping_date.
                                lv_changed = lc_x.
                                EXIT. " Come out of Inner loop
                              ENDIF.
                            ENDAT.
                          ENDLOOP.
                        ELSE.
                          READ TABLE xvbap ASSIGNING <lst_xvbap>
                                WITH KEY vbeln = <lst_yveda>-vbeln
                                         posnr = <lst_yveda>-vposn.
                          IF sy-subrc EQ 0.
                            IF li_jksesched_veda IS NOT INITIAL.
                              " 2.3 Digital
                              " Checking of arrival date
                              IF li_marc_veda IS NOT INITIAL.
                                READ TABLE li_jksesched_veda TRANSPORTING NO FIELDS
                                WITH KEY vbeln = <lst_yveda>-vbeln
                                         posnr = <lst_yveda>-vposn
                                         BINARY SEARCH.
                                IF sy-subrc EQ 0.
                                  CLEAR lv_tabix.
                                  lv_tabix = sy-tabix.
                                  LOOP AT li_jksesched_veda FROM lv_tabix ASSIGNING <lst_jksesched>.
                                    IF <lst_jksesched>-vbeln EQ <lst_yveda>-vbeln
                                      AND <lst_jksesched>-posnr EQ <lst_yveda>-vposn.
                                      READ TABLE li_marc_veda ASSIGNING <lst_marc>
                                        WITH KEY matnr = <lst_jksesched>-issue
                                                 BINARY SEARCH.
                                      IF sy-subrc EQ 0.
                                        IF ( <lst_xveda>-vbegdat GT <lst_marc>-ismarrivaldateac OR
                                             <lst_xveda>-venddat LT <lst_marc>-ismarrivaldateac ).
                                          " *** Condition - 1 ***
                                          IF <lst_xvbap>-pstyv IN li_arvl_dat_pstyv_range.
                                            lv_changed = lc_x.
                                            EXIT.
                                          ENDIF. " IF yvbap-pstyv IN li_arvl_dat_pstyp_range.
                                          " *** Condition - 2 ***
                                          READ TABLE li_mara_veda ASSIGNING <lst_mara>
                                            WITH KEY matnr = <lst_xvbap>-matnr
                                                     mtart = lc_zsbe BINARY SEARCH.
                                          IF sy-subrc EQ 0.
                                            lv_changed = lc_x.
                                            EXIT.
                                          ENDIF.
                                        ENDIF. " IF ( <lst_xveda>-vbegdat GT <lst_marc>-ismarrivaldateac OR
                                        "             <lst_xveda>-venddat LT <lst_marc>-ismarrivaldateac ).
                                      ENDIF. " IF sy-subrc EQ 0.
                                    ELSE.
                                      EXIT.
                                    ENDIF.
                                  ENDLOOP.
                                ENDIF. " IF sy-subrc EQ 0.
                              ENDIF. " IF li_marc IS NOT INITIAL.
                            ENDIF. " IF li_jksesched IS NOT INITIAL.
                            " For checking the Acceptance date for Non Journal
                            IF <lst_xvbap>-pstyv IN li_accp_dat_pstyv_range.
                              READ TABLE li_mara_veda ASSIGNING <lst_mara>
                                    WITH KEY matnr = <lst_xvbap>-matnr
                                             mtart = lc_znjd BINARY SEARCH.
                              IF sy-subrc EQ 0.
                                IF <lst_yveda>-vabndat IS NOT INITIAL.
                                  lv_changed = lc_x.
                                  EXIT.
                                ENDIF. " IF <lst_xveda>-vabndat IS NOT INITIAL.
                              ENDIF. " IF sy-subrc EQ 0.
                            ENDIF. " IF <lst_yvbap>-pstyv IN li_accp_dat_pstyv_range.
                          ENDIF. " IF sy-subrc EQ 0.
                        ENDIF. " IF li_jkseflow IS NOT INITIAL.
                        IF lv_changed IS NOT INITIAL.
                          EXIT. " Come out of Outer loop
                        ENDIF.
                      ENDIF. " IF sy-subrc NE 0.
                    ENDIF.
                  ENDIF. " IF sy-subrc EQ 0.
                ENDLOOP.
              ENDIF. " IF li_yveda IS NOT INITIAL.
            ENDIF. " IF ( t180-tcode EQ lc_tcode_va42 ) OR ( t180-tcode EQ lc_tcode_va45 ).
          ENDIF. " lv_changed IS INITIAL AND IF vbak-auart IN li_contract_range.

          " Disply the popup when items are changed
          IF lv_changed IS NOT INITIAL.
            CLEAR lv_changed.
            " This will display a message about the problem
            " or the reason for not saving the document
            CALL FUNCTION 'POPUP_TO_CONFIRM_MSG_WITH_CALL'
              EXPORTING
                txt01                         = text-018
*               TXT02                         = ' '
*               TXT03                         = ' '
*               TXT04                         = ' '
*               PAR01                         = ' '
*               PAR02                         = ' '
*               PAR03                         = ' '
*               PAR04                         = ' '
*               NEW_LINE1                     = ' '
*               NEW_LINE2                     = ' '
*               NEW_LINE3                     = ' '
                title                         = 'Item Blocked'(019)
                length                        = 111
                txt_first_pushbutton          = 'Ok'(023)
*               TXT_SECOND_PUSHBUTTN          =
*               FUNCT_MODULE                  = ' '
              EXCEPTIONS
                function_module_missed        = 1
                text_second_pushbutton_missed = 2
                OTHERS                        = 3.
            IF sy-subrc EQ 0.
              " This will stay on the same screen
              " where the user was when clicking on 'Save'.
              PERFORM folge_gleichsetzen(saplv00f).
              fcode = 'ENT1'.
              SET SCREEN syst-dynnr.
              LEAVE SCREEN.
            ENDIF. " IF sy-subrc EQ 0.
          ENDIF. " IF lv_changed IS NOT INITIAL.
        ENDIF. " IF vbak-auart IN li_auart_range.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL
ENDCASE. " CASE t180-tcode.
