*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCE_E095_RENWAL_MODULE
* PROGRAM DESCRIPTION:Include for populating auto renewal plan table
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E096
* TRANSPORT NUMBER(S) ED2K903901
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K906915
* REFERENCE NO:  Defect 2887
* DEVELOPER: Anriban Saha
* DATE:  2017-06-26
* DESCRIPTION: Introduced packet size to be processed and Activity
*              date in the selection screen.
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K910691
* REFERENCE NO:  ERP 6242
* DEVELOPER: Writtick Roy
* DATE:  2018-02-05
* DESCRIPTION: 1. Make Activity Date as a Range
*              2. Add new Selection Criteria based on Sales Org
*-------------------------------------------------------------------*
REPORT zqtce_e096_renwal_module_copy.
*& Top Incldue  for data declaration
INCLUDE ZQTCN_E096_TOP_INDCLUDE_COPY.
*INCLUDE zqtcn_e096_top_indclude.

*& Incldue for Selection screeen
INCLUDE ZQTCN_E096_SEL_SCREEN_COPY.
*INCLUDE zqtcn_e096_sel_screen.

*& Incldue for Form declaration
INCLUDE ZQTCN_E096_FORM_DECL_COPY.
*INCLUDE zqtcn_e096_form_decl.


INITIALIZATION.
*& Fetch Constant Table data
  PERFORM f_fetch_constant_table CHANGING i_const.
*& Fetch all relevent Activity
  PERFORM f_fetch_activity CHANGING i_activity
                                    i_list_act.
*& fetch Details from Notification profile
  PERFORM f_fetch_prof CHANGING i_renwl_prof
                                i_list_renwl.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_vbeln-low.
  PERFORM f_f4 CHANGING s_vbeln-low.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_vbeln-high.
  PERFORM f_f4 CHANGING s_vbeln-high.

* Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
AT SELECTION-SCREEN ON s_vkorg.
  PERFORM f_validate_sales_org.
* End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691

AT SELECTION-SCREEN .
* validate Order
  PERFORM f_order.
*Begin of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
** validate if both check boxes are selected or not
*  PERFORM f_check.
*End of Del-Anirban-07.25.2017-ED2K907327-Defect 3301

START-OF-SELECTION.
* Fetch data from renewal determination table
  PERFORM f_fetch_renwal_deter USING p_activ
                                     p_prof
                               CHANGING i_final
                                        i_renwl_plan.
* Fetch Notification profile
  PERFORM f_fetch_notif_prof USING i_final
                             CHANGING i_notif_p_det.

*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  IF sy-batch EQ abap_true.
    IF i_final[] IS NOT INITIAL.
*-----Check no of records found to be processed.
      CLEAR : v_nor.
      i_final1[] = i_final[].
      CLEAR: i_final.
      LOOP AT i_final1 INTO st_final.
        APPEND st_final TO i_final.
        v_nor = v_nor + 1.
        IF v_nor = p_nor.

          "process records.
          PERFORM f_fetch_data CHANGING     i_final
                                            i_item
                                            i_partner
                                            i_business
                                            i_textheaders
                                            i_textlines
                                            i_header
                                            i_contr_data
                                            i_docflow
                                            i_veda
                                            i_nast.
          PERFORM f_process_data USING sy-batch
                             i_item
                             i_business
                             i_partner
                             i_textheaders
                             i_textlines
                             i_header
                             i_contr_data
                             i_const
                             i_notif_p_det
                             i_renwl_plan
                             i_veda
                             i_nast
                             i_docflow
                             p_test
                         CHANGING   i_final1.
          CLEAR : v_nor.
          CLEAR: i_final.
        ENDIF.
      ENDLOOP.
      IF NOT i_final IS INITIAL.
        PERFORM f_fetch_data CHANGING     i_final
                                          i_item
                                          i_partner
                                          i_business
                                          i_textheaders
                                          i_textlines
                                          i_header
                                          i_contr_data
                                          i_docflow
                                          i_veda
                                          i_nast.
        PERFORM f_process_data USING sy-batch
                           i_item
                           i_business
                           i_partner
                           i_textheaders
                           i_textlines
                           i_header
                           i_contr_data
                           i_const
                           i_notif_p_det
                           i_renwl_plan
                           i_veda
                           i_nast
                           i_docflow
                           p_test
                       CHANGING   i_final1.
      ENDIF.
    ENDIF.
  ENDIF.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887


*-----When the program is running in foreground
  IF sy-batch EQ abap_false.
    IF i_final[] IS NOT INITIAL.
* Fetch all relevent data of subscription order
      PERFORM f_fetch_data CHANGING     i_final
                                      i_item
                                      i_partner
                                      i_business
                                      i_textheaders
                                      i_textlines
                                      i_header
                                      i_contr_data
                                      i_docflow
                                      i_veda
                                      i_nast.


*& Process the data
      PERFORM f_process_data USING sy-batch
                               i_item
                               i_business
                               i_partner
                               i_textheaders
                               i_textlines
                               i_header
                               i_contr_data
                               i_const
                               i_notif_p_det
                               i_renwl_plan
                               i_veda
                               i_nast
                               i_docflow
                               p_test
                           CHANGING   i_final    .
    ENDIF.
  ENDIF.

*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  IF sy-batch EQ abap_true.
    CLEAR: i_final.
    i_final[] = i_final1[].
    CLEAR: i_final1.
  ENDIF.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887


END-OF-SELECTION.

  PERFORM f_popul_field_catalog CHANGING i_fcat .

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*& Display ALV
*  PERFORM f_display_alv USING i_fcat
*                              i_final.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*& Display ALV
  PERFORM f_display_alv USING i_fcat
                              i_final.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
