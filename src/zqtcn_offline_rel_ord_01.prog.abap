*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OFFLINE_REL_ORD_01 (Include)
*               From "ISM_SE_ORDERCREATION~CHANGE_DATA_BEFORE_RFC"
* PROGRAM DESCRIPTION: Before creating Offline Release Order, check if
* the Goods Arrival Date is updated in the Media Issue
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 02/15/2018
* OBJECT ID: E141
* TRANSPORT NUMBER(S): ED2K910582
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  TYPES:
    BEGIN OF lty_issue_details,
      vbeln           TYPE vbeln_va,                                      "Sales Document
      posnr           TYPE posnr_va,                                      "Sales Document Item
      vkorg	          TYPE vkorg,                                         "Sales Organization
      vtweg           TYPE vtweg,                                         "Distribution Channel
      nxt_media_issue TYPE matnr,                                         "Media Issue
    END OF lty_issue_details,
    ltt_issue_details TYPE STANDARD TABLE OF lty_issue_details INITIAL SIZE 0.

  CONSTANTS:
    lc_prm_ofl_relord TYPE rvari_vnam     VALUE 'OFFLINE_REL_ORD',        "ABAP: Name of Variant Variable
    lc_prm_order_type TYPE rvari_vnam     VALUE 'ORDER_TYPE',             "ABAP: Name of Variant Variable
    lc_devid_e141     TYPE zdevid         VALUE 'E141'.                   "Development ID

  DATA:
    li_constants      TYPE zcat_constants,                                "Constant Values
    li_issue_details  TYPE ltt_issue_details,                             "Media Issues
    li_issue_detail_t TYPE ltt_issue_details,                             "Media Issues
    li_order_tab_temp TYPE rjkseordergendata_tab.                         "IS-M: Type for Order Generation Data in Series Sales

  STATICS:
    lir_auart_offline TYPE fip_t_auart_range.                             "Range: Sales Document Types

  IF lir_auart_offline[] IS INITIAL.
*   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid_e141                                      "Development ID: E141
      IMPORTING
        ex_constants = li_constants.                                      "Constant Values
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
      CASE <lst_constant>-param1.
        WHEN lc_prm_order_type.                                           "Order Type
          CASE <lst_constant>-param2.
            WHEN lc_prm_ofl_relord.                                       "Offline Release Order
              APPEND INITIAL LINE TO lir_auart_offline ASSIGNING FIELD-SYMBOL(<lst_auart_offline>).
              <lst_auart_offline>-sign   = <lst_constant>-sign.
              <lst_auart_offline>-option = <lst_constant>-opti.
              <lst_auart_offline>-low    = <lst_constant>-low.
              <lst_auart_offline>-high   = <lst_constant>-high.

            WHEN OTHERS.
*             Nothing to do
          ENDCASE.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.

  li_order_tab_temp[] = order_tab[].
  SORT li_order_tab_temp BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_order_tab_temp
                  COMPARING vbeln.
* Fetch Sales Document: Header Data
  SELECT vbeln,                                                           "Sales Document
         vkorg,                                                           "Sales Organization
         vtweg                                                            "Distribution Channel
    FROM vbak
    INTO TABLE @DATA(li_sd_header)
     FOR ALL ENTRIES IN @li_order_tab_temp
   WHERE vbeln EQ @li_order_tab_temp-vbeln.
  IF sy-subrc EQ 0.
    SORT li_sd_header BY vbeln.
  ENDIF.

  LOOP AT order_tab ASSIGNING FIELD-SYMBOL(<lst_order>).
    IF <lst_order>-order_type IN lir_auart_offline.                       "Valid SD Document Type(s)
*     Get Sales Document: Header Details
      READ TABLE li_sd_header ASSIGNING FIELD-SYMBOL(<lst_sd_header>)
           WITH KEY vbeln = <lst_order>-vbeln                             "Sales Document
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Populate Media Issue Details
        LOOP AT <lst_order>-next_issues ASSIGNING FIELD-SYMBOL(<lst_next_issue>).
          APPEND INITIAL LINE TO li_issue_details ASSIGNING FIELD-SYMBOL(<lst_issue_detail>).
          <lst_issue_detail>-vbeln           = <lst_order>-vbeln.         "Sales Document
          <lst_issue_detail>-posnr           = <lst_order>-posnr.         "Sales Document Item
          <lst_issue_detail>-vkorg           = <lst_sd_header>-vkorg.     "Sales Organization
          <lst_issue_detail>-vtweg           = <lst_sd_header>-vtweg.     "Distribution Channel
          <lst_issue_detail>-nxt_media_issue = <lst_next_issue>-issue.    "Media Issue
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF li_issue_details[] IS NOT INITIAL.
    li_issue_detail_t[] = li_issue_details[].
    SORT li_issue_detail_t BY vkorg vtweg nxt_media_issue.
    DELETE ADJACENT DUPLICATES FROM li_issue_detail_t
                    COMPARING vkorg vtweg nxt_media_issue.
*   Fetch Sales and Plant Data for Material
    SELECT v~matnr,                                                       "Material Number
           v~vkorg,                                                       "Sales Organization
           v~vtweg,                                                       "Distribution Channel
           v~dwerk,                                                       "Delivering Plant (Own or External)
           c~ismarrivaldateac                                             "Actual Goods Arrival Date
      FROM mvke AS v INNER JOIN
           marc AS c
        ON c~matnr EQ v~matnr
       AND c~werks EQ v~dwerk
      INTO TABLE @DATA(li_mat_details)
       FOR ALL ENTRIES IN @li_issue_detail_t
     WHERE v~matnr EQ @li_issue_detail_t-nxt_media_issue                  "Media Issue
       AND v~vkorg EQ @li_issue_detail_t-vkorg                            "Sales Organization
       AND v~vtweg EQ @li_issue_detail_t-vtweg.                           "Distribution Channel
    IF sy-subrc EQ 0.
      SORT li_mat_details BY matnr vkorg vtweg.
    ENDIF.

    LOOP AT order_tab ASSIGNING <lst_order>.
      IF <lst_order>-order_type IN lir_auart_offline.                     "Valid SD Document Type(s)
*       Get Sales Document: Header Details
        READ TABLE li_sd_header ASSIGNING <lst_sd_header>
             WITH KEY vbeln = <lst_order>-vbeln
             BINARY SEARCH.
        IF sy-subrc EQ 0.
*         Validate Media Issue Details
          LOOP AT <lst_order>-next_issues ASSIGNING <lst_next_issue>.
*           Get Sales and Plant Data for Material
            READ TABLE li_mat_details ASSIGNING FIELD-SYMBOL(<lst_mat_detail>)
                 WITH KEY matnr = <lst_next_issue>-issue                  "Media Issue
                          vkorg = <lst_sd_header>-vkorg                   "Sales Organization
                          vtweg = <lst_sd_header>-vtweg                   "Distribution Channel
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
*             Actual Goods Arrival Date is not yet populated
              IF <lst_mat_detail>-ismarrivaldateac IS INITIAL OR
                 <lst_mat_detail>-ismarrivaldateac EQ space.
                CLEAR: <lst_next_issue>-issue.
              ENDIF.
            ELSE.
              CLEAR: <lst_next_issue>-issue.
            ENDIF.
          ENDLOOP.
          DELETE <lst_order>-next_issues[] WHERE issue IS INITIAL.
        ENDIF.
      ENDIF.
    ENDLOOP.
    DELETE order_tab[] WHERE next_issues IS INITIAL.
  ENDIF.
