* PROGRAM NAME: ZQTC_ENTITLEMENT_STATUS_I0318
* PROGRAM DESCRIPTION: Implement RFC to update acceptance date and Texts
*                      in contract details what passing through the RFC.
* DEVELOPER: Paramita Bose(PBOSE)
* CREATION DATE: 12/07/2016
* OBJECT ID: I0318
* TRANSPORT NUMBER(S): ED2K903833
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903833
* REFERENCE NO: CR 254/331
* DEVELOPER: Paramita Bose(PBOSE)
* DATE: 13-Mar-2017
* DESCRIPTION: Cuurently CR changes has been reverted back as per the
* communication from functional.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906508
* REFERENCE NO: CR#534
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE: 05-Jun-2017
* DESCRIPTION: To include subscription number also as part of the selection
* along with the fulfillment line item id.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906768
* REFERENCE NO: JIRA Defect ERP-2837
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 16-Jun-2017
* DESCRIPTION: Added application logs to make sure we will have a tracking.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907581
* REFERENCE NO: CR#612 (ERP-3473)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 28-Jul-2017
* DESCRIPTION: Fulfilment response id will be same for all the BOM products.
*              Existing logic will not work for BOM scenario as the IHREZ
*              is same for BOM header and componenets. Also additional
*              logic to check on the material group3 is added and we should
*              update only for the line items that has the material group
*              maintained in ZCACONSTANT table. Entries realted to material
*              group3 are set for WRICEF I0229 as it needs to be in sync.
*              DEVID = I0229  and PARAM1 = MAT_GRP_3 for ZCACONSTANT entry.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K909276
* REFERENCE NO: ERP-4934
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 01-Nov-2017
* DESCRIPTION: To increase the length of field CUSTOMER_ID(EAL Number) to
*              char50 as legacy is sending bigger texts.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K910736
* REFERENCE NO: ERP-6918
* DEVELOPER: Himanshu Patel
* DATE: 02/09/2018
* DESCRIPTION: New FM added ZQTC_ENTITLEMENT_IDOC_I0318 in same Function
*              group which will be process Idoc for Subscription Order change
*              so all global data added in this top include
*----------------------------------------------------------------------*

FUNCTION zqtc_entitlement_status_i0318.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_ENT_STATUS) TYPE  ZTQTC_ENTITLEMNT_STAT
*"     VALUE(IM_SUBS_NUM) TYPE  VBELN
*"     VALUE(IM_ERR_IDOC) TYPE  ERRHANDLE OPTIONAL
*"  EXPORTING
*"     VALUE(EX_T_RETURN_MSG) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
* Type Declaration for Reference Number
  TYPES : BEGIN OF lty_ihrez,
            vbeln TYPE vbeln, " Sales and Distribution Document Number
            posnr TYPE posnr, " Item number of the SD document
            ihrez TYPE ihrez, " Your Reference
          END OF lty_ihrez,

          BEGIN OF lty_refid,
            ihrez TYPE ihrez, " Your Reference
          END OF lty_refid,

          BEGIN OF lty_doc_type,
            vbeln TYPE vbeln, " Sales and Distribution Document Number
            vbtyp TYPE vbtyp, " SD document category
          END OF lty_doc_type,

          BEGIN OF lty_resp,
            vbeln TYPE vbeln, " Sales and Distribution Document Number
            posnr TYPE posnr, " Item number of the SD document
          END OF lty_resp.

* Data Declaration
  DATA : li_ent_status        TYPE ztqtc_entitlemnt_stat,                              " Table for entitlement status
         li_entitle_status    TYPE STANDARD TABLE OF ty_entitle_status INITIAL SIZE 0, " Entitlement Status
         li_ihrez             TYPE STANDARD TABLE OF lty_ihrez         INITIAL SIZE 0, " Table for Reference Number
*        Begin of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833
         li_refid             TYPE STANDARD TABLE OF lty_refid         INITIAL SIZE 0,
         li_resp              TYPE STANDARD TABLE OF lty_resp          INITIAL SIZE 0,
         li_resp1             TYPE STANDARD TABLE OF lty_resp          INITIAL SIZE 0,
         li_doc_type          TYPE STANDARD TABLE OF lty_doc_type      INITIAL SIZE 0,
*        End of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833

         lst_vbap             TYPE ty_vbap,           " Work area for VBAP
         lst_vbkd             TYPE lty_ihrez,         " Work area for VBKD
         lst_ihrez            TYPE lty_ihrez,         " work area for IHREZ
         lst_veda             TYPE ty_veda,           " Work area for VEDA
         lst_vbak             TYPE ty_vbak,           " Work area for VBAK
* BOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
         lst_zcaconst_ent     TYPE zcast_constant,    " work area for ZCACONSTANT
* EOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
         lst_ent_status       TYPE zstqtc_ent_stat,   " Import Structure for Entitlement status
         lst_entitle_stat     TYPE ty_entitle_status, " work area for Entitle status
         lst_ent_status_dummy TYPE ty_entitle_status, " Import Structure for Entitlement status
         lv_msg_type          TYPE bapi_mtype,        " Message Type: S/E
         lv_ref               TYPE char15,            " Ref of type CHAR15
         lv_ref1              TYPE string,
         lv_msgno             TYPE symsgno,           " Message Number
* Begin of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833
         lst_refid            TYPE lty_refid,
         lst_resp             TYPE lty_resp,
         lv_length            TYPE char2. " Length of type CHAR2

* Constant Declaration:
  CONSTANTS : lc_order       TYPE vbtyp VALUE 'C', " SD document category = C
              lc_contract    TYPE vbtyp VALUE 'G', " SD document category = G
              lc_vposn_zeros TYPE posnr_va VALUE '000000'.  " Header Item no.

* End of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833

  IF im_ent_status[] IS NOT INITIAL.
* Begin of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833
*    LOOP AT im_ent_status INTO lst_ent_status.
*      DESCRIBE FIELD lst_ent_status-fulfillment_id LENGTH lv_length IN CHARACTER MODE.
*      IF lv_length LT 12.
*        lst_refid-ihrez = lst_ent_status-fulfillment_id.
*        APPEND lst_refid-ihrez TO li_refid.
*        CLEAR lst_refid.
*      ELSEIF lv_length EQ 16.
*        lst_resp-vbeln = lst_ent_status-fulfillment_id+0(10).
*        lst_resp-posnr = lst_ent_status-fulfillment_id+10(6).
*        APPEND lst_resp TO li_resp.
*        CLEAR lst_resp.
*      ENDIF. " IF lv_length EQ 12
*    ENDLOOP. " LOOP AT im_ent_status INTO lst_ent_status

*   Validating fullfilment ID
*    SELECT vbeln " Sales and Distribution Document Number
*           posnr " Item number of the SD document
*           ihrez " Your Reference
*      INTO TABLE li_ihrez
*      FROM vbkd  " Sales Document: Business Data
*      FOR ALL ENTRIES IN li_refid
*      WHERE ihrez EQ li_refid-ihrez.
*
*    IF sy-subrc EQ 0.
*      LOOP AT li_ihrez INTO lst_ihrez.
*        lst_resp-vbeln = lst_ihrez-vbeln.
*        lst_resp-posnr = lst_ihrez-posnr.
*        APPEND lst_resp TO li_resp1.
*        CLEAR lst_resp.
*      ENDLOOP. " LOOP AT li_ihrez INTO DATA(lst_ihrez)
*      APPEND LINES OF li_resp1 TO li_resp.
*      CLEAR li_resp1.
*
**   Fetch document category from VBAK table
*      SELECT vbeln,     " Sales Document
*             vbtyp      " SD document category
*             FROM vbak " Sales Document: Header Data
*             INTO TABLE @DATA(li_doc_typ)
*             FOR ALL ENTRIES IN @li_resp
*             WHERE vbeln EQ @li_resp-vbeln.
*      IF sy-subrc EQ 0.
*        li_doc_type[] = li_doc_typ[].
*        DELETE li_doc_typ  WHERE vbtyp EQ lc_order.
*        DELETE li_doc_type WHERE vbtyp EQ lc_contract.
*      ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0

* End of change: PBOSE:CR 254/331: 13-Mar-2017: ED2K903833

* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
*   Create the Application Log
*   This Application Log can be displayed through UKM_LOGS_DISPLAY
    PERFORM f_log_create_and_add USING im_subs_num
                                       im_ent_status.
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
********************************************
* Populate importing values in a local internal table
    li_ent_status[] = im_ent_status[].

    SORT li_ent_status BY fulfillment_id.
*   Delete duplicate values
    DELETE ADJACENT DUPLICATES FROM li_ent_status COMPARING fulfillment_id.

*  SORT li_refid by ihrez.
*  DELETE ADJACENT DUPLICATES FROM li_refid COMPARING ihrez.
*   Validating fullfilment ID
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           ihrez " Your Reference
      INTO TABLE li_ihrez
      FROM vbkd  " Sales Document: Business Data
      FOR ALL ENTRIES IN li_ent_status
      WHERE vbeln EQ im_subs_num AND        "Insert for CR 534
            ihrez EQ li_ent_status-fulfillment_id.

    IF sy-subrc NE 0.

      CLEAR : lv_msg_type,
              lv_msgno.
      lv_ref = im_subs_num.
      lv_msg_type = c_err.
      lv_msgno    = c_064.
*     If all the Fulfillment ID is wrong, then populate error message
      PERFORM f_populate_message USING   lv_msg_type
                                         lv_ref
                                         lv_msgno
                               CHANGING  ex_t_return_msg.
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
      lv_ref1  = im_subs_num.
      PERFORM f_log_add USING c_err                              "Message Type
                              c_msgno_000                        "Message Number
                              'No operation performed due to wrong '(t09)   "Message Variable 1
                              ' input values for subscription order'(t10)   "Message Variable 2
                              lv_ref1                               "Message Variable 3
                              space.                                "Message Variable 4
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837

    ELSE. " ELSE -> IF sy-subrc NE 0
      SORT li_ihrez BY vbeln posnr ihrez.
*     Fetch Sales data from VBAK table.
      SELECT vbeln      " Sales Document
             vkorg      " Sales Organization
             vtweg      " Distribution Channel
             spart      " Division
              FROM vbak " Sales Document: Header Data
              INTO TABLE i_vbak
              FOR ALL ENTRIES IN li_ihrez
              WHERE vbeln = li_ihrez-vbeln
             ORDER BY PRIMARY KEY.

      IF sy-subrc EQ 0.

*       Fetch Item sales data from VBAP table
        SELECT vbeln " Sales Document
               posnr " Sales Document Item
               matnr " Material Number
               pstyv " Sales document item category
               zmeng " Target quantity in sales units
               mvgr3 " Material group3  " Insert by PBANDLAPAL on 27-Jul-2017 for CR#612
          INTO TABLE i_vbap
          FROM vbap  " Sales Document: Item Data
          FOR ALL ENTRIES IN li_ihrez
          WHERE vbeln EQ li_ihrez-vbeln.
        IF sy-subrc EQ 0.
          SORT i_vbap BY vbeln posnr.

*       Fetch Agreement Acceptance Date from VEDA table.
          SELECT vbeln   " Sales Document
                 vposn   " Sales Document Item
                 vabndat " Agreement acceptance date
          INTO TABLE i_veda
          FROM veda      " Contract Data
          FOR ALL ENTRIES IN i_vbap
          WHERE vbeln EQ i_vbap-vbeln.
*            AND vposn EQ i_vbap-posnr.
          IF sy-subrc IS INITIAL.
            SORT i_veda BY vbeln vposn.
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF sy-subrc EQ 0

* BOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
* To get ZCACONSTANT entries for the I0229 Wricefs.
        CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
          EXPORTING
            im_devid         = c_devid_i0229
          IMPORTING
            ex_t_zcacons_ent = i_zcacons_ent.
        LOOP AT i_zcacons_ent INTO lst_zcaconst_ent
                                      WHERE param1 = c_param_matgrp3.
          APPEND INITIAL LINE TO r_mat_grp3_zca ASSIGNING FIELD-SYMBOL(<fst_mat_grp3_zca>).
          <fst_mat_grp3_zca>-sign   = lst_zcaconst_ent-sign.
          <fst_mat_grp3_zca>-option = lst_zcaconst_ent-opti.
          <fst_mat_grp3_zca>-low    = lst_zcaconst_ent-low.
          <fst_mat_grp3_zca>-high   = lst_zcaconst_ent-high.
        ENDLOOP.
* EOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581

      ENDIF. " IF sy-subrc EQ 0

* BOC by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
*     Loop through the table to get the validated Fulfillment ID and that
*     related Cutomer ID and License Start date.
*      LOOP AT li_ent_status INTO lst_ent_status.
*        CLEAR : lst_ihrez.
**       Redat the table got after validation.
*        READ TABLE li_ihrez INTO lst_ihrez
*                            WITH KEY ihrez = lst_ent_status-fulfillment_id
*                            .
      LOOP AT li_ihrez INTO lst_ihrez.
        READ TABLE li_ent_status INTO lst_ent_status
                                 WITH KEY fulfillment_id =  lst_ihrez-ihrez.
* EOC by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
        IF sy-subrc IS INITIAL.
          lst_ent_status_dummy-vbeln              = lst_ihrez-vbeln. " Sales Doc No
          lst_ent_status_dummy-posnr              = lst_ihrez-posnr. " Fulfillment ID
          lst_ent_status_dummy-fulfillment_id     = lst_ihrez-ihrez. " Fulfillment ID
          lst_ent_status_dummy-customer_id        = lst_ent_status-customer_id. " Text to be updated
          lst_ent_status_dummy-licence_start_date = lst_ent_status-licence_start_date. " Acceptance Date
          APPEND lst_ent_status_dummy TO li_entitle_status.
          CLEAR lst_ent_status_dummy.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDLOOP. " LOOP AT li_ent_status INTO lst_ent_status

      SORT li_entitle_status BY vbeln.
*     Loop through the entitlement status table
      LOOP AT li_entitle_status INTO lst_entitle_stat.
*       Populate values to work area
        lst_ent_status_dummy = lst_entitle_stat.

*       For new fulfillment ID
        CLEAR: st_header_data,
               st_header_ind,
               lst_vbkd,
               lst_vbak,
               lst_vbap,
               lst_veda.

*       Read table VBKD
        READ TABLE li_ihrez INTO lst_vbkd
                          WITH KEY vbeln = lst_ent_status_dummy-vbeln
                                   posnr = lst_ent_status_dummy-posnr
                                   ihrez = lst_ent_status_dummy-fulfillment_id
                          BINARY SEARCH.

        IF sy-subrc EQ 0.
          READ TABLE i_vbak INTO lst_vbak
                            WITH KEY vbeln = lst_vbkd-vbeln
                            BINARY SEARCH.
          IF sy-subrc EQ 0.

*           Read item data
            READ TABLE i_vbap INTO lst_vbap
                              WITH KEY vbeln = lst_vbkd-vbeln
                                       posnr = lst_vbkd-posnr
                              BINARY SEARCH.
            IF sy-subrc EQ 0.
* BOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
              IF lst_vbap-mvgr3 IN r_mat_grp3_zca.
* EOI by PBANDLAPAL on 27-Jul-2017 for CR#612(ERP-3473): ED2K907581
*             Subroutine to update item data
                PERFORM f_pop_item_data USING lst_vbap
                                     CHANGING i_contract
                                              i_cond_ind.

*     Check if acceptance date is already in system, then do not update that.
* Check if the item entry exists in the VEDA table
                READ TABLE i_veda INTO lst_veda
                                  WITH KEY vbeln = lst_vbap-vbeln
                                           vposn = lst_vbap-posnr
                                  BINARY SEARCH.

                IF sy-subrc EQ 0.
                  IF lst_veda-vabndat IS INITIAL.
*               Subroutine to update agreement acceptance date
                    PERFORM f_pop_agreement_date USING lst_vbap
                                                       lst_ent_status_dummy
                                              CHANGING i_agr_date
                                                       i_agr_date_ind.

                  ENDIF. " IF lst_veda-vabndat IS INITIAL
                ELSE.
*  Check if acceptance date is already in system, then do not update that.
* check if the header entry exists in the VEDA table.
                  READ TABLE i_veda INTO lst_veda
                                    WITH KEY vbeln = lst_vbap-vbeln
                                             vposn = lc_vposn_zeros
                                    BINARY SEARCH.

                  IF sy-subrc EQ 0.
                    IF lst_veda-vabndat IS INITIAL.
*               Subroutine to update agreement acceptance date
                      PERFORM f_pop_agreement_date USING lst_vbap
                                                         lst_ent_status_dummy
                                                CHANGING i_agr_date
                                                         i_agr_date_ind.

                    ENDIF. " IF lst_veda-vabndat IS INITIAL
                  ENDIF.
                ENDIF. " IF sy-subrc EQ 0

* To check if text already exists or not and if it exists then we don't need to update
*else we will update text.
                PERFORM f_pop_update_text USING lst_ent_status_dummy
                                                lst_vbkd
                                       CHANGING i_text.

              ENDIF. " IF sy-subrc EQ 0 for READ TABLE i_vbap
            ENDIF.  " IF lst_vbap-mvgr3 IN r_mat_grp3_zca.
          ENDIF. " IF sy-subrc EQ 0  for READ TABLE i_vbak
        ENDIF. " IF sy-subrc EQ 0 for READ TABLE li_ihrez

        AT END OF vbeln.
*       Populate header data to pass in the BAPI
          PERFORM f_pop_sales_data USING lst_vbak
                                CHANGING st_header_data
                                         st_header_ind.
          IF i_agr_date[] IS NOT INITIAL OR i_text[] IS NOT INITIAL.
*         Subroutine to call BAPI for updating subscription order
            PERFORM f_update_subscrpt_ord USING st_header_data
                                                lst_vbkd
                                                st_header_ind
                                                i_contract
                                                i_cond_ind
                                                i_agr_date_ind
                                                i_agr_date
                                                i_text
                                                li_entitle_status  "+<HIPATEL> <ERP-6918> <02/12/2018>
                                                IM_ERR_IDOC        "+<HIPATEL> <ERP-6918> <02/12/2018>
                                   CHANGING     ex_t_return_msg.
          ELSE.
            CLEAR : lv_msg_type,
                    lv_msgno.
            lv_msg_type = c_inf.
            lv_msgno    = c_170.
            lv_ref      = im_subs_num.
            lv_ref1     = im_subs_num.
*     If all the Fulfillment ID is wrong, then populate error message
            PERFORM f_populate_message USING   lv_msg_type
                                       lv_ref
                                       lv_msgno
                             CHANGING  ex_t_return_msg.
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
            PERFORM f_log_add USING c_inf                              "Message Type
                                    c_msgno_000                        "Message Number
                                    'No update has been performed as values'(t11)  "Message Variable 1
                                    'already exists in'(t12)                       "Message Variable 2
                                    lv_ref1                              "Message Variable 3
                                    space.                             "Message Variable 4
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
          ENDIF.
          CLEAR: i_contract,
                 i_cond_ind,
                 i_agr_date,
                 i_text,
                 i_agr_date_ind.
        ENDAT.
      ENDLOOP. " LOOP AT li_entitle_status INTO lst_entitle_stat
    ENDIF. " IF sy-subrc NE 0
  ELSE.
    CLEAR : lv_msg_type,
            lv_msgno.
    lv_msg_type = c_err.
    lv_msgno    = c_167.
    lv_ref      = im_subs_num.
    lv_ref1     = im_subs_num.
*     If all the Fulfillment ID is wrong, then populate error message
    PERFORM f_populate_message USING   lv_msg_type
                                       lv_ref
                                       lv_msgno
                             CHANGING  ex_t_return_msg.
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
    PERFORM f_log_add USING c_err                              "Message Type
                            c_167                              "Message Number
                            lv_ref1                            "Message Variable 1
                            space                              "Message Variable 2
                            space                              "Message Variable 3
                            space.                             "Message Variable 4
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
  ENDIF. " IF im_ent_status[] IS NOT INITIAL
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
*   Save the Application Log
  IF v_log_handle IS NOT INITIAL.
    PERFORM f_log_save.
  ENDIF.
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
ENDFUNCTION.
