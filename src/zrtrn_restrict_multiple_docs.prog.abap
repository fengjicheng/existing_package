*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_RESTRICT_MULTIPLE_DOCS (Include)
* [Called from Copying Requirement Billing Doc Routine - 900 (RV60B900)]
* PROGRAM DESCRIPTION: Restrict creation of Multiple Documents
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/10/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908714
* REFERENCE NO:  ERP 4683
* DEVELOPER: Anirban Saha
* DATE:  09/28/2017
* DESCRIPTION: Once FAZ is cancelled, this routine was not allowing
*              user to create another FAZ. Now it will allow user to
*              create a new FAZ billing document.
*              Do not allow to create a FAZ Billing document as loon
*              as a complete billing docuemnt exists for the order.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_doc_exists TYPE flag.                                      "Flag: Target Doc already exists

DATA:
  lr_sales_offc TYPE rjksd_vkbur_range_tab.                     "Range: Sales Office

CONSTANTS:
  lc_devid_e164 TYPE zdevid      VALUE 'E164',                  "Development ID: E164
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
  lc_p2_eal     TYPE rvari_vnam  VALUE 'EAL'.                   "Name of Variant Variable: EAL

*Begin of Add-Anirban-09.28.2017-ED2K908714-Defect 4683
DATA : lv_fksto TYPE fksto.
CLEAR: lv_fksto.
*End of Add-Anirban-09.28.2017-ED2K908714-Defect 4683

* Get Cnonstant values
SELECT param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values)
 WHERE devid    EQ @lc_devid_e164                               "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_eal.                                       "EAL Only
            APPEND INITIAL LINE TO lr_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

IF vbak-vkbur IN lr_sales_offc.                            "EAL Only
* Check Sales Document Flow - if Target document is already created
  SELECT vbfa~vbelv,                                       "Preceding sales and distribution document
         vbfa~posnv,                                       "Preceding item of an SD document
         vbfa~vbeln,                                       "Subsequent sales and distribution document
         vbfa~posnn	                                       "Subsequent item of an SD document
    FROM vbfa INNER JOIN vbrk
      ON vbfa~vbeln EQ vbrk~vbeln
    INTO TABLE @DATA(li_dwn_pmnt)
   WHERE vbfa~vbelv   EQ @vbak-vbeln                       "Sales Doc - Order / Contract (Source)
     AND vbfa~vbtyp_n EQ @vbtyp_rech                       "SD Doc Category - M (Invoice)
     AND vbrk~fkart   EQ @xfkart.                          "Billing Type (Target)
  IF sy-subrc    EQ 0 AND
     li_dwn_pmnt IS NOT INITIAL.
*Begin of Add-Anirban-09.28.2017-ED2K908714-Defect 4683
* Check if the billing doc is cancelled.
    SORT li_dwn_pmnt BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_dwn_pmnt COMPARING vbeln.
    IF NOT li_dwn_pmnt IS INITIAL.
      SELECT fksto
        FROM vbrk
        INTO lv_fksto
        FOR ALL ENTRIES IN li_dwn_pmnt
        WHERE vbeln = li_dwn_pmnt-vbeln
        AND fksto = 'C'.
      ENDSELECT.
      IF sy-subrc = 0.
        lv_doc_exists = abap_true.
      ENDIF.
    ENDIF.
*End of Add-Anirban-09.28.2017-ED2K908714-Defect 4683
*Begin of Del-Anirban-09.28.2017-ED2K908714-Defect 4683
*    lv_doc_exists = abap_true.
*End of Del-Anirban-09.28.2017-ED2K908714-Defect 4683
  ENDIF.
ENDIF.

IF lv_doc_exists IS NOT INITIAL.                           "Target Document already exists
  xkomfk-fxmsg = '017'.                                    "The document has already been fully invoiced (Msg ID: VF)
* Write Error Log
  PERFORM vbfs_hinzufuegen USING posnr_low
                                 '017'
                                 space
                                 space
                                 space.
  sy-subrc = 4.
ELSE.                                                      "Target Document not yet created
  sy-subrc = 0.
ENDIF.
