*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RESTRICT_PROFORMA_COMP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTRICT_PROFORMA_COMP(Include)
*               Called from "userexit_save_document_prepare(RV60AFZZ)"
* PROGRAM DESCRIPTION: This userexit used to restrict proforma complete
*                      when there is an active Invoice
* DEVELOPER      : Prabhu
* CREATION DATE  : 08/19/2018
* OBJECT ID      : E174 / CR6082
* TRANSPORT NUMBER(S): ED2K913133
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES : BEGIN OF lty_vbfa,
          vbelv	  TYPE  vbeln_von,
          posnv	  TYPE posnr_von,
          vbeln	  TYPE vbeln_nach,
          posnn	  TYPE posnr_nach,
          vbtyp_n	TYPE vbtyp_n,
        END OF lty_vbfa.
TYPES : BEGIN OF lty_vbeln,
          vbeln TYPE vbeln_vf,
        END OF lty_vbeln.
DATA :   li_vbfa   TYPE STANDARD TABLE OF lty_vbfa,
         li_vbeln  TYPE STANDARD TABLE OF lty_vbeln,
         lst_vbeln TYPE lty_vbeln,
         lst_vbak  TYPE vbak,
         lv_vbeln  TYPE vbeln,
         lst_xvbrp TYPE vbrpvb.                       "Workarea for vbrp
CONSTANTS : lc_e          TYPE c VALUE 'E',
            lc_m          TYPE c VALUE 'M',
            lc_doc        TYPE c VALUE 'U',
            lc_s          TYPE c VALUE 'S',
            lc_devid_e174 TYPE zdevid      VALUE 'E174',                  "Development ID: E174
            lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
            lc_p1_potype  TYPE rvari_vnam  VALUE 'PO_TYPE',               "Name of Variant PO type
            lc_eal        TYPE rvari_vnam  VALUE 'EAL'..
*--*Check if request is for Proforma complete
IF vbrk-rfbsk = lc_e AND vbrk-vbtyp = lc_doc.
  IF xvbrp[] IS  NOT INITIAL.
*--*No data flow is available in runtime in cancellation so get Billing document data from VBFA
    SELECT vbelv,
           posnv,
           vbeln,
           posnn,
           vbtyp_n FROM vbfa INTO TABLE @li_vbfa
                                 FOR ALL ENTRIES IN @xvbrp
                                  WHERE vbelv = @xvbrp-vgbel
                                  AND  posnv = @xvbrp-vgpos
                                  AND vbtyp_n = @lc_m.
    IF sy-subrc EQ 0.
*--*Check if any active billing document
      SELECT vbeln INTO TABLE @li_vbeln FROM vbrk
                                         FOR ALL ENTRIES IN @li_vbfa
                                          WHERE vbeln = @li_vbfa-vbeln
                                            AND fksto = ''.
      IF sy-subrc EQ 0.
        READ TABLE xvbrp INTO lst_xvbrp INDEX 1.
        IF sy-subrc EQ 0.
*--*Get sales document header
          SELECT SINGLE * FROM vbak INTO @lst_vbak WHERE vbeln = @lst_xvbrp-vgbel.
          IF sy-subrc EQ 0.
            IF lis_constants IS INITIAL.
* Get Cnonstant values
              SELECT devid,                                                  "Devid
                     param1,                                                  "ABAP: Name of Variant Variable
                     param2,                                                  "ABAP: Name of Variant Variable
                     srno,                                                    "Current selection number
                     sign,                                                    "ABAP: ID: I/E (include/exclude values)
                     opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
                     low,                                                     "Lower Value of Selection Condition
                     high                                                     "Upper Value of Selection Condition
                FROM zcaconstant
                INTO TABLE @lis_constants
               WHERE devid    EQ @lc_devid_e174                               "Development ID
                 AND activate EQ @abap_true.                                  "Only active record
              IF sy-subrc IS INITIAL.
                LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_valu>).
                  CASE <lst_const_valu>-param1.
                    WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
                      CASE <lst_const_valu>-param2.
                        WHEN lc_eal.                                       "EAL Only
                          APPEND INITIAL LINE TO lrs_sales_offc ASSIGNING FIELD-SYMBOL(<lst_salesoffc>).
                          <lst_salesoffc>-sign   = <lst_const_valu>-sign.
                          <lst_salesoffc>-option = <lst_const_valu>-opti.
                          <lst_salesoffc>-low    = <lst_const_valu>-low.
                          <lst_salesoffc>-high   = <lst_const_valu>-high.
                        WHEN OTHERS.
*           Nothing to do
                      ENDCASE.
                    WHEN lc_p1_potype.
                      APPEND INITIAL LINE TO lrs_potype ASSIGNING FIELD-SYMBOL(<lst_potype>).
                      <lst_potype>-sign   = <lst_const_valu>-sign.
                      <lst_potype>-option = <lst_const_valu>-opti.
                      <lst_potype>-low    = <lst_const_valu>-low.
                      <lst_potype>-high   = <lst_const_valu>-high.
                    WHEN OTHERS.
*       Nothing to do
                  ENDCASE.
                ENDLOOP.
              ENDIF. " IF sy-subrc IS INITIAL
            ENDIF.
*--*Check sales office, PO type
*--*If all the conditions are satisfied, do not allow user to cmplete Proforma
            IF lst_vbak-vkbur IN lrs_sales_offc."AND lst_vbak-bsark IN lrs_potype.
              READ TABLE li_vbeln INTO lst_vbeln INDEX 1.
              MESSAGE e511(zqtc_r2) WITH lst_vbeln-vbeln DISPLAY LIKE lc_s.
            ENDIF. "Sales office and Po type check
          ENDIF. "Sales doc header check
        ENDIF."Read documents
      ENDIF. "Active billing doc check
    ENDIF. "Data flow - Billing docs
  ENDIF. "Proforma details
ENDIF. "Proforma Complete check
