FUNCTION zqtc_get_form_logo_name.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DOC_NO) TYPE  VBELN_VA
*"     VALUE(IM_DOC_TYPE) TYPE  CHAR10
*"  EXPORTING
*"     REFERENCE(EX_LOGO_NAME) TYPE  CHAR100
*"     REFERENCE(EX_SOLD_TO_NAME) TYPE  NAME1_GP
*"  EXCEPTIONS
*"      NON_SOCIETY_CUSTOMERS
*"      NON_SOCIETY_MATERIALS
*"      INVALID_DOCUMENT_NUMBER
*"      INVALID_DOCUMENT_TYPE
*"      MATERIAL_GROUP_NOT_MAINTAINED
*"----------------------------------------------------------------------
*-----------------------------------------------------------------------------*
* PROGRAM NAME        :ZQTC_GET_FORM_LOGO_NAME
* PROGRAM DESCRIPTION : E110 – Renewal Forms and Logos
* Get the name of logo on the basis Sold to and ship to
* The Logos will be created for each Society Customer Number and placed
* in a central repository on the sap directory.  During the trigger of outputs
* the Logos will be displayed for the Society Order where the condition matches.
* DEVELOPER           : Lucky Kodwani
* CREATION DATE       : 04/18/2015
* OBJECT ID           : E110
* TRANSPORT NUMBER(S) : ED2K900927
*------------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------------*
* REVISION NO: ED2K911133
* REFERENCE NO: ERP-6685
* DEVELOPER: Pavan Bandlapalli
* DATE:  02/28/2018
* DESCRIPTION: We need to check only based on ZA partner function and all the other
*              validations are not needed.
*----------------------------------------------------------------------*

*  Type Declaration
  TYPES : BEGIN OF lty_vbpa,
            vbeln TYPE vbeln,                " Sales and Distribution Document Number
            posnr TYPE posnr,                " Item number of the SD document
            parvw TYPE parvw,                " Partner Function
            kunnr TYPE kunnr,                " Customer Number
          END OF lty_vbpa,

          BEGIN OF lty_vbap,
            vbeln TYPE vbeln_va,             " Sales Document
            posnr TYPE posnr_va,             " Sales Document Item
            matnr TYPE matnr,                " Material Number
*           BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
            mvgr5 TYPE mvgr5,                " Material group 5
*           EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
          END OF lty_vbap,

          BEGIN OF lty_vbrp,
            vbeln TYPE vbeln_vf,             " Billing Document
            posnr TYPE posnr_vf,             " Billing item
            matnr TYPE matnr,                " Material Number
*           BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
            mvgr5 TYPE mvgr5,                " Material group 5
*           EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
          END OF lty_vbrp,

*         BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*         BEGIN OF lty_mvke,
*           matnr TYPE matnr,                " Material Number
*           vkorg TYPE vkorg,                " Sales Organization
*           vtweg TYPE vtweg,                " Distribution Channel
*           mvgr5 TYPE mvgr5,                " Material group 5
*         END OF lty_mvke,

*         BEGIN OF lty_but050,
*           relnr     TYPE bu_relnr,          " BP Relationship Number
*           partner1 TYPE bu_partner,        " Business Partner Number
*           partner2 TYPE  bu_partner,
*           date_to   TYPE bu_datto,          " Validity Date (Valid To)
*           reltyp   TYPE bu_reltyp,         " Business Partner Relationship Category
*         END OF lty_but050,
*         EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133

          BEGIN OF lty_constant,
            devid  TYPE zdevid,              " Development ID
            param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            srno   TYPE tvarv_numb,          " ABAP: Current selection number
            sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_constant.

* Range Declaration
  DATA : lir_parvw  TYPE tt_parvw_r,
         lir_mvgr5  TYPE tt_mvgr5_r,
         lir_reltyp TYPE tt_reltyp_r,
         lir_kunnr  TYPE tt_kunnr_r.

* Constant Declaration
  CONSTANTS : lc_ag_sold    TYPE parvw  VALUE 'AG',                   " Partner Function
              lc_we_ship    TYPE parvw  VALUE 'WE',                   " Partner Function
              lc_devid      TYPE zdevid VALUE 'E110',                 " Type of Identification Code
* BOI by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
              lc_parvw_za   TYPE parvw VALUE 'ZA',                    " ZA Partner Function
* EOI by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
              lc_mat_soci   TYPE rvari_vnam VALUE 'MATERIAL_SOCIETY', " ABAP: Name of Variant Variable
              lc_bp_rel_cat TYPE rvari_vnam VALUE 'BU_PART_REL_CAT'.  " ABAP: Name of Variant Variable
*              lc_reltyp     TYPE rvari_vnam VALUE 'RELTYP',           " ABAP: Name of Variant Variable
*              lc_mvgr5      TYPE rvari_vnam VALUE 'MVGR5'.            " ABAP: Name of Variant Variable

* Local varible Declaration
  DATA : lv_sold_to   TYPE kunnr,     " Customer Number
         lv_ship_to   TYPE kunnr,     " Customer Number
* BOI by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
         lv_kunnr     TYPE kunnr,
* EOI by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
         lv_sold_name TYPE name1,     " Name
         lv_reltyp    TYPE bu_reltyp, " Business Partner Relationship Category
         lv_vkorg     TYPE vkorg,     " Sales Org
         lv_cust_so   TYPE flag.      " General Flag

* Work Area Declaration
  DATA : lst_vbpa         TYPE lty_vbpa,
*        BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*        lst_mvke         TYPE lty_mvke,
         lst_vbap         TYPE lty_vbap,
         lst_vbrp         TYPE lty_vbrp,
*        EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
         lst_constant     TYPE lty_constant,
         lst_mvgr5        TYPE LINE OF tt_mvgr5_r,
         lst_reltyp       TYPE LINE OF tt_reltyp_r,
         lst_society_logo TYPE zqtc_societylogo. " Get the society logo name

* Internal Table Declaration
  DATA: li_vbpa          TYPE STANDARD TABLE OF lty_vbpa         INITIAL SIZE 0,
        li_constant      TYPE STANDARD TABLE OF lty_constant     INITIAL SIZE 0,  "
        li_constant_temp TYPE STANDARD TABLE OF lty_constant     INITIAL SIZE 0,  "
        li_vbap          TYPE STANDARD TABLE OF lty_vbap         INITIAL SIZE 0,
        li_vbrp          TYPE STANDARD TABLE OF lty_vbrp         INITIAL SIZE 0,
*       BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*       li_mvke          TYPE STANDARD TABLE OF lty_mvke         INITIAL SIZE 0,
*       EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
        li_societylogo   TYPE STANDARD TABLE OF zqtc_societylogo INITIAL SIZE 0. " Get the society logo name

  IF im_doc_type <> c_order AND
    im_doc_type <> c_invoice.
    RAISE invalid_document_type.
  ENDIF. " IF im_doc_type <> c_order AND

*  Data Validation
  PERFORM f_data_validation USING im_doc_no
                                  im_doc_type
                                  lv_vkorg.
* BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
**Populate range table for Sold to
* PERFORM f_populate_range_parvw USING lc_ag_sold
*                                CHANGING lir_parvw.
*
**Populate Range table for Ship to
* PERFORM f_populate_range_parvw USING lc_we_ship
*                               CHANGING lir_parvw.

**Get the partner data from VBPA table
**Get the Sold to an ship to value from table VBPA
* SELECT vbeln " Sales Document
*        posnr " Sales Document Item
*        parvw " Partner Function
*        kunnr " Customer Number
*   FROM vbpa  " Sales Document: Partner
*   INTO TABLE li_vbpa
*   WHERE vbeln = im_doc_no
*   AND parvw IN lir_parvw.
* IF sy-subrc EQ 0.
*   SORT li_vbpa BY parvw.
* ENDIF. " IF sy-subrc EQ 0
*
* IF li_vbpa IS NOT INITIAL .
**  Get Sold to party from VBPA table
*   READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = lc_ag_sold
*                                             BINARY SEARCH .
*   IF sy-subrc EQ 0.
*     lv_sold_to = lst_vbpa-kunnr.
*   ENDIF. " IF sy-subrc EQ 0
*
**  Get Ship to party from VBPA table
*   READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = lc_we_ship
*                                             BINARY SEARCH .
*   IF sy-subrc EQ 0.
*     lv_ship_to = lst_vbpa-kunnr.
*   ENDIF. " IF sy-subrc EQ 0
* ENDIF. " IF li_vbpa IS NOT INITIAL
*
**Populate Customer Range Table for sold to value
* PERFORM f_populate_range_kunnr USING    lv_sold_to
*                                CHANGING lir_kunnr.
*
**Populate Customer Range Table for ship to value
* PERFORM f_populate_range_kunnr USING  lv_ship_to
*                                CHANGING lir_kunnr.
*
**Get the constant values from ZCACONSTANT Table
* SELECT devid                " Development ID
*        param1               " ABAP: Name of Variant Variable
*        param2               " ABAP: Name of Variant Variable
*        srno                 " ABAP: Current selection number
*        sign                 " ABAP: ID: I/E (include/exclude values)
*        opti                 " ABAP: Selection option (EQ/BT/CP/...)
*        low                  " Lower Value of Selection Condition
*        high                 " Upper Value of Selection Condition
*   FROM zcaconstant          " Wiley Application Constant Table
*   INTO TABLE li_constant
*   WHERE devid = lc_devid
*   AND activate = abap_true. "Only active record
* IF sy-subrc EQ 0.
*   li_constant_temp[] =  li_constant[].
*   DELETE li_constant_temp WHERE param1 <> lc_bp_rel_cat.
*   LOOP AT li_constant_temp INTO lst_constant.
**    Begin of DEL:ERP-3397:WROY:02-AUG-2017:ED2K907702
**    lst_reltyp-sign   = c_i.
**    lst_reltyp-option = c_eq.
**    lst_reltyp-low    = lst_constant-low.
**    End   of DEL:ERP-3397:WROY:02-AUG-2017:ED2K907702
**    Begin of ADD:ERP-3397:WROY:02-AUG-2017:ED2K907702
*     lst_reltyp-sign   = lst_constant-sign.
*     lst_reltyp-option = lst_constant-opti.
*     lst_reltyp-low    = lst_constant-low.
*     lst_reltyp-high   = lst_constant-high.
**    End   of ADD:ERP-3397:WROY:02-AUG-2017:ED2K907702
*     APPEND lst_reltyp TO lir_reltyp.
*     CLEAR lst_reltyp.
*   ENDLOOP. " LOOP AT li_constant_temp INTO lst_constant
* ENDIF. " IF sy-subrc EQ 0
*
* IF lv_sold_to <> lv_ship_to.
*   IF lir_reltyp[] IS NOT INITIAL.
*
**Check if the Business Partner Relationship Category is maintained in
**maintained in table BUT050.
*     SELECT reltyp " Business Partner Relationship Category
*     FROM but050   " BP relationships/role definitions: General data
*     INTO lv_reltyp
*     UP TO 1 ROWS
*     WHERE partner1 = lv_ship_to
*       AND partner2 = lv_sold_to
*       AND reltyp IN lir_reltyp.
*     ENDSELECT.
*     IF sy-subrc IS NOT INITIAL.
*       RAISE non_society_customers.
*     ENDIF. " IF sy-subrc IS NOT INITIAL
*   ENDIF. " IF lir_reltyp[] IS NOT INITIAL
* ENDIF. " IF lv_sold_to <> lv_ship_to

*FM will search customer number from Z table (ZQTC_SOCIETYLOGO) with sold-to and ship-to.
* IF lir_kunnr[] IS NOT INITIAL.
**Only two fields are in table so select * has used.
*   SELECT *
*   FROM zqtc_societylogo " Get the society logo name
*   INTO TABLE li_societylogo
*   WHERE  kunnr IN lir_kunnr.
*   IF sy-subrc EQ 0.
**Internal table li_societylogo having very less records
**so no binary search is used.
*     READ TABLE li_societylogo INTO lst_society_logo WITH KEY kunnr = lv_sold_to.
*     IF sy-subrc EQ 0.
*       lv_cust_so = abap_true.
*     ENDIF. " IF sy-subrc EQ 0
*   ELSE. " ELSE -> IF sy-subrc EQ 0
**If any of the value is not maintained in Z table (which means both sold-to and
**ship-to are not society customer), then no value will be returned from FM.
*     RAISE non_society_customers.
*   ENDIF. " IF sy-subrc EQ 0
* ENDIF. " IF lir_kunnr[] IS NOT INITIAL

* To get the ZA partner customer number
  SELECT kunnr " Customer Number
    FROM vbpa  " Sales Document: Partner
    INTO lv_kunnr
    WHERE vbeln = im_doc_no
    AND parvw = lc_parvw_za.
  ENDSELECT.

* Only two fields are in table so select * has used.
  SELECT SINGLE *
  FROM zqtc_societylogo " Get the society logo name
  INTO lst_society_logo
  WHERE  kunnr = lv_kunnr.
  IF sy-subrc EQ 0.
    lv_cust_so = abap_true.
  ELSE. " ELSE -> IF sy-subrc EQ 0
* If any of the value is not maintained in Z table (which means both sold-to and
* ship-to are not society customer), then no value will be returned from FM.
    RAISE non_society_customers.
  ENDIF. " IF sy-subrc EQ 0
* EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133

* If both sold-to and ship-to customer number maintains in Z table
*(which means, both sold-to and ship-to are society customer),
* then check material.
  IF lv_cust_so IS NOT INITIAL.
* if input document is sales order then select the materials from
* VBAP table.
    IF im_doc_type = c_order.
      SELECT vbeln " Sales Document
             posnr " Sales Document Item
             matnr " Material Number
*            BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
             mvgr5 " Material group 5
*            EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
        FROM vbap  " Sales Document: Item Data
        INTO TABLE li_vbap
        WHERE vbeln = im_doc_no.
      IF sy-subrc EQ 0.
*       BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*       SORT li_vbap BY matnr.
*       DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING matnr.
*       IF li_vbap[] IS NOT INITIAL.
*         SELECT  matnr " Material Number
*                 vkorg " Sales Organization
*                 vtweg " Distribution Channel
*                 mvgr5 " Material group 5
*            FROM mvke  " Sales Data for Material
*        INTO TABLE li_mvke
*        FOR ALL ENTRIES IN li_vbap
*        WHERE matnr = li_vbap-matnr
*          AND vkorg = lv_vkorg
*          AND vtweg = '00'.
*         IF sy-subrc EQ 0.
**           Required error handling is done later.
*         ENDIF. " IF sy-subrc EQ 0
*       ENDIF. " IF li_vbap[] IS NOT INITIAL
*       EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
      ENDIF. " IF sy-subrc EQ 0

    ELSEIF im_doc_type = c_invoice.
      SELECT vbeln " Sales Document
            posnr  " Sales Document Item
            matnr  " Material Number
*           BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
            mvgr5  " Material group 5
*           EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
       FROM vbrp   " Billing Document: Item Data
       INTO TABLE li_vbrp
       WHERE vbeln = im_doc_no.
      IF sy-subrc EQ 0 .
*       BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*       SORT li_vbrp BY matnr.
*       DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING matnr.
*       IF li_vbrp[] IS NOT INITIAL.
*         SELECT  matnr " Material Number
*                 vkorg " Sales Organization
*                 vtweg " Distribution Channel
*                 mvgr5 " Material group 5
*            FROM mvke  " Sales Data for Material
*        INTO TABLE li_mvke
*        FOR ALL ENTRIES IN li_vbrp
*        WHERE matnr = li_vbrp-matnr
*          AND vkorg = lv_vkorg
*          AND vtweg = '00'.
*         IF sy-subrc EQ 0.
** Required error handling is done later.
*         ENDIF. " IF sy-subrc EQ 0
*       ENDIF. " IF li_vbrp[] IS NOT INITIAL
*       EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF im_doc_type = c_order

*   BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*   IF li_mvke IS NOT INITIAL.
*     SORT li_mvke BY mvgr5.
*     DELETE ADJACENT DUPLICATES FROM li_mvke COMPARING mvgr5.
    IF li_vbap IS NOT INITIAL OR
       li_vbrp IS NOT INITIAL.
      IF li_vbap IS NOT INITIAL.
        SORT li_vbap BY mvgr5.
        DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING mvgr5.
      ENDIF.
      IF li_vbrp IS NOT INITIAL.
        SORT li_vbrp BY mvgr5.
        DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING mvgr5.
      ENDIF.
*   EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
      CLEAR lst_constant.
      CLEAR li_constant_temp[].
      li_constant_temp[] =  li_constant[].
      DELETE li_constant_temp WHERE param1 <> lc_mat_soci.
      LOOP AT li_constant_temp INTO lst_constant.
*       Begin of DEL:ERP-3397:WROY:02-AUG-2017:ED2K907702
*       lst_mvgr5-sign = c_i.
*       lst_mvgr5-option = c_eq.
*       lst_mvgr5-low = lst_constant-low.
*       End   of DEL:ERP-3397:WROY:02-AUG-2017:ED2K907702
*       Begin of ADD:ERP-3397:WROY:02-AUG-2017:ED2K907702
        lst_mvgr5-sign   = lst_constant-sign.
        lst_mvgr5-option = lst_constant-opti.
        lst_mvgr5-low    = lst_constant-low.
        lst_mvgr5-high   = lst_constant-high.
*       End   of ADD:ERP-3397:WROY:02-AUG-2017:ED2K907702
        APPEND lst_mvgr5 TO lir_mvgr5 .
        CLEAR lst_mvgr5.
      ENDLOOP. " LOOP AT li_constant_temp INTO lst_constant

*     BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
*     LOOP AT li_mvke INTO lst_mvke.
*       IF lst_mvke-mvgr5 NOT IN  lir_mvgr5.
*         RAISE non_society_materials.
*       ENDIF. " IF lst_mvke-mvgr5 NOT IN lir_mvgr5
*     ENDLOOP. " LOOP AT li_mvke INTO lst_mvke
      IF li_vbap IS NOT INITIAL.
        LOOP AT li_vbap INTO lst_vbap.
          IF lst_vbap-mvgr5 NOT IN  lir_mvgr5.
            RAISE non_society_materials.
          ENDIF. " IF lst_mvke-mvgr5 NOT IN lir_mvgr5
        ENDLOOP. " LOOP AT li_mvke INTO lst_mvke
      ENDIF.
      IF li_vbrp IS NOT INITIAL.
        LOOP AT li_vbrp INTO lst_vbrp.
          IF lst_vbrp-mvgr5 NOT IN  lir_mvgr5.
            RAISE non_society_materials.
          ENDIF. " IF lst_mvke-mvgr5 NOT IN lir_mvgr5
        ENDLOOP. " LOOP AT li_mvke INTO lst_mvke
      ENDIF.
*     EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
      ex_logo_name = lst_society_logo-logo_name.

*  Get The name of Sold to party from KNA1 table
      SELECT SINGLE name1 " Name 1
        FROM kna1         " General Data in Customer Master
        INTO lv_sold_name
*       BOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
        WHERE kunnr = lv_kunnr.
*       WHERE kunnr = lv_sold_to.
*       EOC by PBANDLAPAL on 28-Feb-2018 for ERP-6685: ED2K911133
      IF sy-subrc EQ 0.
        ex_sold_to_name = lv_sold_name.
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF li_mvke IS NOT INITIAL
      RAISE material_group_not_maintained.
    ENDIF. " IF li_mvke IS NOT INITIAL
  ENDIF. " IF lv_cust_so IS NOT INITIAL

ENDFUNCTION.
