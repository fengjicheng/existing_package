*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_FEED_PRC_DISC_I0336_SUB (Subroutines)
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Anirban Saha
* CREATION DATE:       05/01/2017
* OBJECT ID:           I0336
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907564
* REFERENCE NO:  Defect 3643
* DEVELOPER: ANIRBAN SAHA
* DATE:  07/27/2017
* DESCRIPTION: price_tier_from_value / price_tier_to_value is not
*              getting populated correctly
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907768
* REFERENCE NO:  CR 624
* DEVELOPER: ANIRBAN SAHA
* DATE:  08/07/2017
* DESCRIPTION: CSV mapping change and ZAGD/ZDDP calculation change
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910364
* REFERENCE NO: ERP-6043
* DEVELOPER: WRITTICK ROY
* DATE:  01/17/2018
* DESCRIPTION: Place the following minus sign in front of the number
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910805
* REFERENCE NO: ERP-6215/6217
* DEVELOPER: WRITTICK ROY
* DATE:  02/09/2018
* DESCRIPTION: Populate Title and Description from Basic Data Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910805
* REFERENCE NO: ERP-6557
* DEVELOPER: WRITTICK ROY
* DATE:  02/09/2018
* DESCRIPTION: For CSV file, include Description within Quotes, so that
*             "Commas" within Description should not be treated as
*             field separator
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910877
* REFERENCE NO: ERP-6613
* DEVELOPER: WRITTICK ROY
* DATE:  02/14/2018
* DESCRIPTION: ONIX XML (IDOC) should have the "SERIAL_VERSION_ID_TYPE"
*              populated as '01', instead of '07'
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911417
* REFERENCE NO: ERP-
* DEVELOPER: WRITTICK ROY
* DATE:  03/16/2018
* DESCRIPTION: ONIX Excel: Do not consider BOMs those are not part of
*              the feed.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912198
* REFERENCE NO: CR-6335
* DEVELOPER: HIPATEL (Himanshu Patel
* DATE:  05/31/2018
* DESCRIPTION: If there are no ZLPR pricing records, then consider
*              the A986 table (ZLPS) condition prices for all 3 files.
*              i.e The net price (ZLPS – ZDDP and ZLPS-(ZDDP+ZAGD ).
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912794
* REFERENCE NO: CR-6735
* DEVELOPER: HIPATEL (Himanshu Patel)
* DATE:  07/26/2018
* DESCRIPTION: Agent XLS
*              1. Journal group code to be replaced by material number.
*              Agent CSV & Agent XML
*              2. Sorting order change based on the material descriptio
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908349/ED2K913279
* REFERENCE NO:  SCTASK0036922
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  09/03/2018
* DESCRIPTION:The country codes are truncated
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908594 / ED1K908707 / ED1K908731 / ED1K908738 /
*              ED1K908742 / ED1K908752
* REFERENCE NO: CR-7760 / INC0212602 / INC0213081 / INC0215495
* DEVELOPER: HIPATEL (Himanshu Patel)
* DATE:  10/01/2018
* DESCRIPTION: 1. Rounding of the NET discounts creates a discrepancy
*                 between the prices reported by Agent partners and
*                 the price calculated by SAP requiring reconciliation.
*                 So these rounding rules are requested to be removed.
*              2. For material group FTE, issue observed for
*                 assigning worng amount
*              3. CSV: INS print value should not display if INS-DDP
*                 print value exist
*              4. XML: Base price value should be added as a complete
*                 new segment with ZLPR condition; only with with DDP
*                 not required for without DDP.
*              5. XML: new segment should for all Scale and it should
*                 repeat for all currency.
*              6. XML: No additional segment required for ZLPS with DDP
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K910672
* REFERENCE NO:  INC0252071
* DEVELOPER: Bharani (BTIRUVATHU)
* DATE:  15-July-2019
* DESCRIPTION: The excel Price Lists show the Volume and Issues for the
*              selected year.  It also shows whether there is an
*              increase or decrease in the number of issues.
*              The logic is counting Supplements as an issue
*              which results in providing incorrect number of issues
*              but also the text informing of Increase or Decrease
*              in the number of issues is misleading.
*              The Supplements should NOT be included in the count.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917671
* REFERENCE NO:  ERPM 10295
* DEVELOPER: GKAMMILI
* DATE:  02/28/2017
* DESCRIPTION: ZDDP rates in SAP must exactly match those that were
*              published in the agent price list
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918137 & ED2K918227
* REFERENCE NO:  ERPM-6882
* DEVELOPER: AMOHAMMED & PRABHU
* DATE:  05/07/2020
* DESCRIPTION: 1. Additional issue numbers with alphanumeric value are
*              considered along with other issues by taking the total
*              count instead of hightest issue number.
*              2. Sort i_final internal table.
*              3. Remove duplicate components as it is printing already
*              at top and says “also available in another package”.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922066
* REFERENCE NO:  OTCM-25238
* DEVELOPER: NPOLINA
* DATE:  19/02/2021
* DESCRIPTION: Rolling title controlled by specific period
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*       Populate Default values of Selection Screen fields
*----------------------------------------------------------------------*
FORM f_default_values .
* Material Type: ZSBE - Journal Media Product
  APPEND INITIAL LINE TO s_mtarta ASSIGNING FIELD-SYMBOL(<lst_mtart>).
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zsbe.
* Material Type: ZWOL - WOL database & collection
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zwol.
* Material Type: ZMJL - Multi Journal Package
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmjl.
* Material Type: ZMMJ - Multi Media
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmmj.

* Material Type: ZMJL - Multi Journal Package
  APPEND INITIAL LINE TO s_mtartb ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmjl.
* Material Type: ZMMJ - Multi Media
  APPEND INITIAL LINE TO s_mtartb ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmmj.

* Condition Type: ZLPR - List Price
  APPEND INITIAL LINE TO s_kschlp ASSIGNING FIELD-SYMBOL(<lst_kschl>).
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zlpr.

** Condition Type: ZSD1 - Std Disc Product  %
*  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
*  <lst_kschl>-sign   = c_sign_i.
*  <lst_kschl>-option = c_opti_eq.
*  <lst_kschl>-low    = c_ct_zsd1.
* Condition Type: ZAJD - Agent Std.Discount %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zagd.
* Condition Type: ZDDP - Deep Discounting %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zddp.

* Characteristic (New Start Title) - JPSNT
  CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
    EXPORTING
      input  = c_ch_jpsnt
    IMPORTING
      output = p_ns_ttl.
* Characteristic (Merged With)  - JPSMW
  CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
    EXPORTING
      input  = c_ch_jpsmw
    IMPORTING
      output = p_megd_w.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  F_STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Status
*----------------------------------------------------------------------*
MODULE f_status_0100 OUTPUT.
*-----Generate button dynamically
  IF rb_age_x = abap_true.
    CLEAR v_text.
    v_text-icon_id = icon_execute_object.
    v_text-icon_text = 'Agent ONIX-PC XML'(o01).
    SET PF-STATUS '100'.
  ELSEIF rb_age_c = abap_true.
    CLEAR v_text.
    v_text-icon_id = icon_execute_object.
    v_text-icon_text = 'Agent CSV'(O02).
    SET PF-STATUS '100'.
  ELSEIF rb_age_e = abap_true.
    CLEAR v_text.
    v_text-icon_id = icon_execute_object.
    v_text-icon_text = 'Agent XLSX'(o03).
    SET PF-STATUS '100'.
  ENDIF.

*-----Titletext
  SET TITLEBAR '100'.
*-----Create Fieldcatalog
  IF i_fieldcat IS INITIAL.
    PERFORM f_fieldcat_1.
  ENDIF.
*-----Create layout
  PERFORM f_create_layout.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_CREATE_OBJECT  OUTPUT
*&---------------------------------------------------------------------*
*       Object creation
*----------------------------------------------------------------------*
MODULE f_create_object OUTPUT.
  IF r_cl_gui_custom_container IS INITIAL.
    CREATE OBJECT r_cl_gui_custom_container
      EXPORTING
        container_name              = 'CUSTOM_CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT r_cl_gui_alv_grid
      EXPORTING
        i_parent          = r_cl_gui_custom_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_FETCH_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       Get data
*----------------------------------------------------------------------*
MODULE f_fetch_data OUTPUT.
  IF i_final IS INITIAL.
    PERFORM f_prepare_data.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_TRANSFER_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       Transfer data to container
*----------------------------------------------------------------------*
MODULE f_transfer_data OUTPUT.
*-----Sequence for ALVo/p
  IF NOT i_final IS INITIAL.

    CALL METHOD r_cl_gui_alv_grid->set_table_for_first_display
      EXPORTING
        is_layout                     = v_layout
      CHANGING
        it_outtab                     = i_final
        it_fieldcatalog               = i_fieldcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_1
*&---------------------------------------------------------------------*
*       Prepare fieldcatalog
*----------------------------------------------------------------------*
FORM f_fieldcat_1 .
  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'EXTWG'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'EXTWG'.
  w_fieldcat-coltext   = text-a05. "Journal Group code
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'MATNR'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'MATNR'.
  w_fieldcat-coltext   = text-a01. "Material Number
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'MSTAE'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'MSTAE'.
  w_fieldcat-coltext   = text-a02. "Material Status
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'MTART'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'MTART'.
  w_fieldcat-coltext   = text-a03. "Material Type
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'BOM_INFO'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'BOM_INFO'.
  w_fieldcat-coltext   = text-a04.  "BOM Info
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'TITLE'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'TITLE'.
  w_fieldcat-coltext   = text-a06. "Full Title
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'MEDIATYPE'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'MEDIATYPE'.
  w_fieldcat-coltext   = text-a07. "Media Type
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'KNUMA_AG'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'KNUMA_AG'.
  w_fieldcat-coltext   = text-a08. "Price Type
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'PLTYP'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'PLTYP'.
  w_fieldcat-coltext   = text-a09. "Price List Type
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'PLTYD'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'PLTYD'.
  w_fieldcat-coltext   = text-a24. "Price List Type Description
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'KDGRP'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'KDGRP'.
  w_fieldcat-coltext   = text-a10. "Customer Group
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'KSTBM'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'KSTBM'.
  w_fieldcat-coltext   = text-a13. "FTE Range From
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'KONWA'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'KONWA'.
  w_fieldcat-coltext   = text-a14. "Currency
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'KBETR'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'KBETR'.
  w_fieldcat-cfieldname = 'KONWA'.
  w_fieldcat-coltext   = text-a15. "List Price
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'NPADD'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'NPADD'.
  w_fieldcat-cfieldname = 'KONWA'.
  w_fieldcat-coltext   = text-a16. "NET Price for Agent Discount
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'NPAPP'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'NPAPP'.
  w_fieldcat-cfieldname = 'KONWA'.
  w_fieldcat-coltext   = text-a23. "NET Price and DDP
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'NPADP'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'NPADP'.
  w_fieldcat-cfieldname = 'KONWA'.
  w_fieldcat-coltext   = text-a22. "NET Price Agent Discount and DDP
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'DATAB'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'DATAB'.
  w_fieldcat-datatype = 'DATS'.
  w_fieldcat-coltext   = text-a17. "Valid From
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'DATBI'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'DATBI'.
  w_fieldcat-datatype = 'DATS'.
  w_fieldcat-coltext   = text-a18. "Valid To
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

  CLEAR w_fieldcat.
  w_fieldcat-fieldname = 'HDR_COMP'.
  w_fieldcat-ref_table = 'I_FINAL'.
  w_fieldcat-ref_field = 'HDR_COMP'.
  w_fieldcat-coltext   = text-a19. "BOM Header/Component
  w_fieldcat-col_opt = abap_true.
  APPEND w_fieldcat TO i_fieldcat.

* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
  IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
    CLEAR w_fieldcat.
    w_fieldcat-fieldname = 'MAT_DESC'.
    w_fieldcat-ref_table = 'I_FINAL'.
    w_fieldcat-ref_field = 'MAT_DESC'.
    w_fieldcat-coltext   = text-a28. "BOM Header/Component Description
    w_fieldcat-col_opt = abap_true.
    APPEND w_fieldcat TO i_fieldcat.
  ENDIF.
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LAYOUT
*&---------------------------------------------------------------------*
*       Create Layout
*----------------------------------------------------------------------*
FORM f_create_layout .
  v_layout-grid_title = 'Feed price and discount from SAP'(o04).
  v_layout-detailtitl = 'Feed price and discount from SAP'(o04).
  v_layout-zebra      = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       User command
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      CLEAR : i_final.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANCEL'.
      CLEAR : i_final.
      LEAVE PROGRAM.
    WHEN 'BUTTON'.
      IF rb_age_x EQ abap_true.
        PERFORM f_send_data_onix.
      ELSEIF rb_age_c EQ abap_true.
        PERFORM f_send_data_csv.
      ELSEIF rb_age_e EQ abap_true.
        PERFORM f_send_data_xlsx.
      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANTS
*&---------------------------------------------------------------------*
*       Fetch Application Constants
*----------------------------------------------------------------------*
*      <--FP_I_CONSTANTS  text
*----------------------------------------------------------------------*
FORM f_fetch_constants  CHANGING fp_i_constants TYPE tt_constant.

* Wiley Application Constant Table
  SELECT param1      "ABAP: Name of variant variable
         param2      "ABAP: Name of variant variable
         srno        "ABAP: Current selection number
         sign        "ABAP: ID: I/E (include/exclude values)
         opti        "ABAP: Selection option (EQ/BT/CP/...)
         low         "Lower Value of Selection Condition
         high        "Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constants
   WHERE devid    EQ c_dev_i0336
     AND activate EQ abap_true
    ORDER BY PRIMARY KEY.
  IF sy-subrc NE 0.
    CLEAR: fp_i_constants.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_DATA
*&---------------------------------------------------------------------*
*       Prepare data
*----------------------------------------------------------------------*
FORM f_prepare_data.
  TYPES : BEGIN OF lty_konm,
            knumh TYPE knumh,
            kopos TYPE kopos,
            klfn1 TYPE klfn1,
            kstbm TYPE kstbm,
            kbetr TYPE kbetr,
          END   OF lty_konm,

          BEGIN OF lty_a935,
            kappl   TYPE kappl,
            kschl   TYPE kscha,
            zzkvgr1 TYPE kvgr1,
            matnr   TYPE matnr,
            kfrst   TYPE kfrst,
            datbi   TYPE kodatbi,
            datab   TYPE kodatab,
            kbstat  TYPE kbstat,
            knumh   TYPE knumh,
            kbetr   TYPE kbetr,
          END   OF lty_a935,

          BEGIN OF lty_a957,
            kappl   TYPE kappl,
            kschl   TYPE kscha,
*            kdgrp         TYPE kdgrp,
*            zzreltyp_sd1  TYPE bu_reltyp,
*            zzpartner2_sd TYPE zzpartner2,
            mtart   TYPE mtart,
            matnr   TYPE matnr,
            zzkvgr1 TYPE kvgr1,
            kfrst   TYPE kfrst,
            datbi   TYPE kodatbi,
            datab   TYPE kodatab,
            kbstat  TYPE kbstat,
            knumh   TYPE knumh,
            kbetr   TYPE kbetr,
          END   OF lty_a957,

          BEGIN OF lty_a947,
            kappl        TYPE kappl,
            kschl        TYPE kscha,
*            lland        TYPE lland,
            zzlic_id_grp TYPE zzlic_id_grp,
            mtart        TYPE mtart,
            ismmediatype TYPE ismmediatype,
            kfrst        TYPE kfrst,
            datbi        TYPE kodatbi,
            datab        TYPE kodatab,
            kbstat       TYPE kbstat,
            knumh        TYPE knumh,
            kbetr        TYPE kbetr,
            matnr        TYPE matnr,
          END   OF lty_a947,

          BEGIN OF lty_list_prc,
            kappl        TYPE kappl,                                       "Application
            kschl        TYPE kscha,                                       "Condition type
            pltyp        TYPE pltyp,                                       "Price list type
            kdgrp        TYPE kdgrp,                                       "Customer group
            matnr        TYPE matnr,                                       "Material Number
            datbi        TYPE kodatbi,                                     "Validity end date of the condition record
            datab        TYPE kodatab,                                     "Validity start date of the condition record
            knumh        TYPE knumh,                                       "Condition record number
            mstae        TYPE mstae,                                       "Cross-Plant Material Status
            mtart        TYPE mtart,                                       "Material Type
            extwg        TYPE extwg,                                       "External Material Group
            title        TYPE ismtitle,                                    "Title
            mediatype	   TYPE ismmediatype,                                "Media Type
            ismcopynr    TYPE ismheftnummer,                               "Volume from / to
            ismsubtitle3 TYPE ismsubtitle3,                                "SUBTITLE 3
            ismpubldate  TYPE ismpubldate,                                 "Publication date
            maktx        TYPE maktx,                                       "Material Description (Short Text)
            kopos        TYPE kopos,                                       "Sequential number of the condition
*            klfn1     TYPE klfn1,                                         "Current number of the line scale
            konwa        TYPE konwa,                                       "Rate unit (currency or percentage)
            knuma_ag     TYPE knuma_ag,                                    "Sales deal
            kstbm        TYPE kstbm,                                       "Condition scale quantity
            kbetr        TYPE kbetr_kond,                                  "Rate (condition amount or percentage) where no scale exists
          END OF lty_list_prc,

          BEGIN OF lty_final1,
            kappl        TYPE kappl,                                       "Application
            kschl        TYPE kscha,                                       "Condition type
            pltyp        TYPE pltyp,                                       "Price list type
            kdgrp        TYPE kdgrp,                                       "Customer group
            matnr        TYPE matnr,                                       "Material Number
            datbi        TYPE kodatbi,                                     "Validity end date of the condition record
            datab        TYPE kodatab,                                     "Validity start date of the condition record
            knumh        TYPE knumh,                                       "Condition record number
            mstae        TYPE mstae,                                       "Cross-Plant Material Status
            mtart        TYPE mtart,                                       "Material Type
            extwg        TYPE extwg,                                       "External Material Group
*           Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
            title        TYPE string,                                      "Title
*           End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*           Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*           title        TYPE ismtitle,                                    "Title
*           End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
            mediatype	   TYPE ismmediatype,                                "Media Type
            ismcopynr    TYPE ismheftnummer,                               "Volume from / to
            ismsubtitle3 TYPE ismsubtitle3,                             "SUBTITLE 3
            ismpubldate  TYPE ismpubldate,                                 "Publication date
*           Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
            maktx        TYPE string,                                      "Material Description (Short Text)
*           End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*           Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*           maktx        TYPE maktx,                                       "Material Description (Short Text)
*           End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
            kopos        TYPE kopos,                                       "Sequential number of the condition
            klfn1        TYPE klfn1,                                       "Current number of the line scale
            konwa        TYPE konwa,                                       "Rate unit (currency or percentage)
            knuma_ag     TYPE knuma_ag,                                    "Sales deal
            kstbm        TYPE kstbm,                                       "Condition scale quantity
            kbetr        TYPE kbetr_kond,                                  "Rate (condition amount or percentage) where no scale exists
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
            alpha_sep    TYPE char1,                                       "Alphabetical letter separator
            maktx_sub    TYPE text150,                                     "Material Description-2
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
          END OF lty_final1,

          BEGIN OF lty_konh,
            knumh TYPE knumh,                                       "Condition record number
            kosrt TYPE kosrt,                                       "PLTYP
          END   OF lty_konh,
*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
          BEGIN OF ty_matnr,
            sign   TYPE c LENGTH 1,
            option TYPE c LENGTH 2,
            low    TYPE matnr,
            high   TYPE matnr,
          END OF ty_matnr.
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>

  DATA:li_list_prc  TYPE STANDARD TABLE OF lty_list_prc,
       li_konp      TYPE STANDARD TABLE OF lty_list_prc,
       li_final1    TYPE STANDARD TABLE OF lty_final1,
       li_temp      TYPE STANDARD TABLE OF lty_final1,
       li_temp1     TYPE STANDARD TABLE OF lty_final1,
       li_a935      TYPE STANDARD TABLE OF lty_a935,
       li_a957      TYPE STANDARD TABLE OF lty_a957,
       li_a947      TYPE STANDARD TABLE OF lty_a947,
       li_bom_detl  TYPE STANDARD TABLE OF ty_bom_detl,
       li_bom_headr TYPE STANDARD TABLE OF ty_bom_detl,
       li_bom_comp  TYPE STANDARD TABLE OF ty_bom_detl,
       li_country   TYPE STANDARD TABLE OF zqtc_price_reg,
       li_country1  TYPE STANDARD TABLE OF zqtc_price_reg,
       li_konh      TYPE STANDARD TABLE OF lty_konh,
       li_temp2     TYPE STANDARD TABLE OF ty_final,
*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
       li_matnr     TYPE STANDARD TABLE OF ty_matnr,
       lst_matnr    TYPE ty_matnr,
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
*       lw_list_prc  TYPE lty_list_prc,
       lw_final1    TYPE lty_final1,
       lw_konp      TYPE lty_list_prc,
       lw_a935      TYPE lty_a935,
       lw_a957      TYPE lty_a957,
       lw_a947      TYPE lty_a947,
       w_final      TYPE ty_final,
       lw_country   TYPE zqtc_price_reg,
       lw_konh      TYPE lty_konh,
       lw_temp1     TYPE lty_final1,
       lw_temp2     TYPE ty_final.

  DATA : li_konm TYPE STANDARD TABLE OF lty_konm,
         lw_konm TYPE lty_konm.

  DATA : lv_count      TYPE i,
*        Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
         lv_basic_text TYPE string.
*        End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
  CONSTANTS: lc_zlps TYPE kschl VALUE 'ZLPS'.  "Condition Type
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>

*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
  DATA: lv_alpha_sep TYPE char1,
        lv_maktx_sub TYPE text150.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>


  REFRESH : li_konm, li_konp.
  CLEAR: lw_konp, lw_final1, lw_konp, lv_count.
* Price list/Cust.group/RelCat/Soc Number/Material
  SELECT a~kappl        AS kappl,                               "Application
         a~kschl        AS kschl,                               "Condition type
         a~pltyp        AS pltyp,                               "Price list type
         a~kdgrp        AS kdgrp,                               "Customer group
         a~matnr        AS matnr,                               "Material Number
         a~datbi        AS kodatbi,                             "Validity end date of the condition record
         a~datab        AS kodatab,                             "Validity start date of the condition record
         a~knumh        AS knumh,                               "Condition record number

         m~mstae        AS mstae,                               "Cross-Plant Material Status
         m~mtart        AS mtart,                               "Material Type
         m~extwg        AS extwg,                               "External Material Group
         m~ismtitle     AS title,                               "Title
         m~ismmediatype AS mediatype,                           "Media Type
         m~ismcopynr    AS ismcopynr,                           "Copy no
         m~ismsubtitle3 AS ismsubtitle3,                        "Subtitle 3
         m~ismpubldate  AS ismpubldate,                         " Publication Date

         k~maktx        AS maktx,                               "Material Description (Short Text)

         p~kopos        AS kopos,                               "Sequential number of the condition
         p~konwa        AS konwa,                               "Rate unit (currency or percentage)
         p~knuma_ag     AS knuma_ag,
         p~kstbm        AS kstbm,                               "Condition scale quantity
         p~kbetr        AS kbetr                                "Rate (condition amount or percentage) where no scale exists

    FROM a913 AS a              INNER JOIN
         konp AS p
      ON p~knumh EQ a~knumh     INNER JOIN
         mara AS m
      ON m~matnr EQ a~matnr     INNER JOIN
         makt AS k
      ON k~matnr EQ a~matnr
      APPENDING TABLE @li_list_prc
   WHERE a~kdgrp      IN @s_kdgrp                               "Customer Group
     AND a~kschl      IN @s_kschlp                              "Condition Type (List Price)
     AND m~mstae      IN @s_mstae                               "Material Status
     AND m~mtart      IN @s_mtarta                              "Material Type
     AND m~matnr      IN @s_matnr                               "Material Number
     AND k~spras      EQ @sy-langu                              "Material Descriptions
     AND ( a~datab    LE @p_prsdt                               "Validity start date of the condition record
     AND   a~datbi    GE @p_prsdt ).                            "Validity end date of the condition record
  IF sy-subrc EQ 0.
    li_konp = li_list_prc.
    SORT li_konp BY knumh kopos.
    DELETE ADJACENT DUPLICATES FROM li_konp COMPARING knumh kopos.
  ENDIF.
*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
*Collect unique Material received from A913(ZLPR condition) table
*and delete from A986 table records to avoid duplicate material entries
  IF NOT li_konp IS INITIAL.
    DATA(li_list_prc_tmp) = li_konp[].
    SORT li_list_prc_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_list_prc_tmp COMPARING matnr.
    LOOP AT li_list_prc_tmp INTO DATA(lst_list_tmp).
      CLEAR lst_matnr.
      lst_matnr-sign = 'I'.
      lst_matnr-option = 'EQ'.
      lst_matnr-low = lst_list_tmp-matnr.
      APPEND lst_matnr TO li_matnr.
    ENDLOOP.
  ENDIF.

*If there are no ZLPR pricing records, then consider the A986 table (ZLPS) condition
* Price list/RelCat/Soc Number/Material for ZLPS condition
  SELECT a~kappl        AS kappl,                               "Application
         a~kschl        AS kschl,                               "Condition type
         a~pltyp        AS pltyp,                               "Price list type
*         a~kdgrp        AS kdgrp,                               "Customer group
         a~matnr        AS matnr,                               "Material Number
         a~datbi        AS datbi,                             "Validity end date of the condition record
         a~datab        AS datab,                             "Validity start date of the condition record
         a~knumh        AS knumh,                               "Condition record number

         m~mstae        AS mstae,                               "Cross-Plant Material Status
         m~mtart        AS mtart,                               "Material Type
         m~extwg        AS extwg,                               "External Material Group
         m~ismtitle     AS title,                               "Title
         m~ismmediatype AS mediatype,                           "Media Type
         m~ismcopynr    AS ismcopynr,                           "Copy no
         m~ismsubtitle3 AS ismsubtitle3,                        "Subtitle 3
         m~ismpubldate  AS ismpubldate,                         " Publication Date

         k~maktx        AS maktx,                               "Material Description (Short Text)

         p~kopos        AS kopos,                               "Sequential number of the condition
         p~konwa        AS konwa,                               "Rate unit (currency or percentage)
         p~knuma_ag     AS knuma_ag,
         p~kstbm        AS kstbm,                               "Condition scale quantity
         p~kbetr        AS kbetr                                "Rate (condition amount or percentage) where no scale exists

    FROM a986 AS a              INNER JOIN
         konp AS p
      ON p~knumh EQ a~knumh     INNER JOIN
         mara AS m
      ON m~matnr EQ a~matnr     INNER JOIN
         makt AS k
      ON k~matnr EQ a~matnr
      APPENDING TABLE @DATA(li_list_prc_zlps)
   WHERE a~kschl      =  @lc_zlps                               "Condition Type (List Price)
     AND m~mstae      IN @s_mstae                               "Material Status
     AND m~mtart      IN @s_mtarta                              "Material Type
     AND m~matnr      IN @s_matnr                               "Material Number
     AND k~spras      EQ @sy-langu                              "Material Descriptions
     AND ( a~datab    LE @p_prsdt                               "Validity start date of the condition record
     AND   a~datbi    GE @p_prsdt ).                            "Validity end date of the condition record
  IF sy-subrc EQ 0.
* Materials received from A913(ZLPR condition) table should not be considered for ZLPS
    IF li_matnr[] IS NOT INITIAL.
      DELETE li_list_prc_zlps WHERE matnr IN li_matnr[].
    ENDIF.
    LOOP AT li_list_prc_zlps INTO DATA(lst_list_zlps).
      MOVE-CORRESPONDING lst_list_zlps TO lw_konp.
      APPEND lw_konp TO li_konp.
    ENDLOOP.
    SORT li_konp BY knumh kopos.
    DELETE ADJACENT DUPLICATES FROM li_konp COMPARING knumh kopos.
  ENDIF.
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>


* Get data from KONM
  IF NOT li_konp IS INITIAL.
    SELECT knumh
           kopos
           klfn1
           kstbm
           kbetr
      FROM konm
      INTO TABLE li_konm
      FOR ALL ENTRIES IN li_konp
      WHERE knumh = li_konp-knumh
      AND   kopos = li_konp-kopos.
    IF sy-subrc = 0.
      SORT li_konm BY knumh kopos.
    ENDIF.
  ENDIF.

*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
* Fetch Application Constants
  PERFORM f_fetch_constants  CHANGING i_constants.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

  DATA : lv_tabix TYPE sy-tabix.

*prepare FINAL1 table
  LOOP AT li_konp INTO lw_konp.
*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   Fetch Material Basic Data Text
    CLEAR: lv_basic_text.
    PERFORM f_get_basic_text USING lw_konp-matnr
                             CHANGING lv_basic_text.
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
    CLEAR: lv_alpha_sep, lv_maktx_sub.
    PERFORM f_get_alpha_sep USING lv_basic_text
                            CHANGING lv_alpha_sep
                                     lv_maktx_sub.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
    READ TABLE li_konm INTO lw_konm WITH KEY knumh = lw_konp-knumh
                                             kopos = lw_konp-kopos
                                             BINARY SEARCH.
    IF sy-subrc = 0.
      CLEAR: lv_tabix.
      lv_tabix = sy-tabix.
      LOOP AT li_konm INTO lw_konm FROM lv_tabix.
        IF NOT lw_konm-knumh EQ lw_konp-knumh.
          EXIT.
        ENDIF.
        lw_final1-kappl = lw_konp-kappl.
        lw_final1-kschl = lw_konp-kschl.
        lw_final1-pltyp = lw_konp-pltyp.
        lw_final1-kdgrp = lw_konp-kdgrp.
        lw_final1-matnr = lw_konp-matnr.
        lw_final1-datbi = lw_konp-datbi.
        lw_final1-datab = lw_konp-datab.
        lw_final1-knumh = lw_konp-knumh.
        lw_final1-mstae = lw_konp-mstae.
        lw_final1-mtart = lw_konp-mtart.
        lw_final1-extwg = lw_konp-extwg.
*       Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
        lw_final1-title = lv_basic_text.
        lw_final1-maktx = lv_basic_text.
*       End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
        lw_final1-alpha_sep = lv_alpha_sep.
        lw_final1-maktx_sub = lv_maktx_sub.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*       Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*       lw_final1-title = lw_konp-title.
*       End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
        lw_final1-mediatype = lw_konp-mediatype.
        lw_final1-ismcopynr = lw_konp-ismcopynr.
        lw_final1-ismsubtitle3 = lw_konp-ismsubtitle3.
        lw_final1-ismpubldate = lw_konp-ismpubldate.
*       Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*       lw_final1-maktx = lw_konp-maktx.
*       End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
        lw_final1-kopos = lw_konm-kopos.
        lw_final1-klfn1 = lw_konm-klfn1.
        lw_final1-konwa = lw_konp-konwa.
        lw_final1-knuma_ag = lw_konp-knuma_ag.
        lw_final1-kbetr = lw_konm-kbetr.
        lw_final1-kstbm = lw_konm-kstbm.
        APPEND lw_final1 TO li_final1.
        lv_tabix = lv_tabix + 1.
        CLEAR: lw_konm, lw_final1.
      ENDLOOP.
    ELSE.
      lw_final1-kappl = lw_konp-kappl.
      lw_final1-kschl = lw_konp-kschl.
      lw_final1-pltyp = lw_konp-pltyp.
      lw_final1-kdgrp = lw_konp-kdgrp.
      lw_final1-matnr = lw_konp-matnr.
      lw_final1-datbi = lw_konp-datbi.
      lw_final1-datab = lw_konp-datab.
      lw_final1-knumh = lw_konp-knumh.
      lw_final1-mstae = lw_konp-mstae.
      lw_final1-mtart = lw_konp-mtart.
      lw_final1-extwg = lw_konp-extwg.
*     Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
      lw_final1-title = lv_basic_text.
      lw_final1-maktx = lv_basic_text.
*     End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
      lw_final1-alpha_sep = lv_alpha_sep.
      lw_final1-maktx_sub = lv_maktx_sub.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*     Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*     lw_final1-title = lw_konp-title.
*     End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
      lw_final1-mediatype = lw_konp-mediatype.
      lw_final1-ismcopynr = lw_konp-ismcopynr.
      lw_final1-ismsubtitle3 = lw_konp-ismsubtitle3.
      lw_final1-ismpubldate = lw_konp-ismpubldate.
*     Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*     lw_final1-maktx = lw_konp-maktx.
*     End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
      lw_final1-kopos = lw_konp-kopos.
      lw_final1-konwa = lw_konp-konwa.
      lw_final1-kbetr = lw_konp-kbetr.
      lw_final1-kstbm = lw_konp-kstbm.
      APPEND lw_final1 TO li_final1.
      CLEAR: lw_final1.
    ENDIF.
    CLEAR : lw_konm.
  ENDLOOP.

  REFRESH: li_konp, li_konm.

* Get discount details - ZAGD - a935
  SELECT a~kappl   AS kappl,
         a~kschl   AS kscha,
         a~zzkvgr1 AS zzkvgr1,
         a~matnr   AS matnr,
         a~kfrst   AS kfrst,
         a~datbi   AS kodatbi,
         a~datab   AS kodatab,
         a~kbstat  AS kbstat,
         a~knumh   AS knumh,
         b~kbetr   AS kbetr
    FROM a935 AS a INNER JOIN
         konp AS b
    ON   a~knumh EQ b~knumh INNER JOIN
         mara AS m
    ON   m~matnr EQ a~matnr
    APPENDING TABLE @li_a935
    WHERE a~kschl IN @s_kschld
    AND   a~kschl IN @s_kschld
    AND m~mstae          IN @s_mstae                           "Material Status
    AND m~mtart          IN @s_mtarta                          "Material Type
    AND a~matnr          IN @s_matnr                           "Material No
     AND ( a~datab    LE @p_prsdt                               "Validity start date of the condition record
     AND   a~datbi    GE @p_prsdt ).                            "Validity end date of the condition record
  IF sy-subrc = 0.
    SORT li_a935 BY matnr.
  ENDIF.


* Get discount details - ZAGD - a937
  SELECT a~kappl   AS kappl,
         a~kschl   AS kscha,
*         a~kdgrp   AS kdgrp,
*         a~zzreltyp_sd1   AS bu_reltyp,
*         a~zzpartner2_sd1 AS zzpartner2,
         a~mtart   AS mtart,
         m~matnr   AS matnr,
         a~zzkvgr1   AS kvgr1,
         a~kfrst   AS kfrst,
         a~datbi   AS kodatbi,
         a~datab   AS kodatab,
         a~kbstat  AS kbstat,
         a~knumh   AS knumh,
         b~kbetr   AS kbetr
    FROM a957 AS a INNER JOIN
         konp AS b
    ON   a~knumh EQ b~knumh INNER JOIN
         mara AS m
    ON   m~mtart EQ a~mtart
    APPENDING TABLE @li_a957
    WHERE a~kschl IN @s_kschld
    AND m~mstae          IN @s_mstae                           "Material Status
    AND a~mtart          IN @s_mtarta                          "Material Type
    AND m~matnr          IN @s_matnr                           "Material No
     AND ( a~datab    LE @p_prsdt                               "Validity start date of the condition record
     AND   a~datbi    GE @p_prsdt ).                            "Validity end date of the condition record
  IF sy-subrc = 0.
*BOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
*    SORT li_a957 BY matnr.
    SORT li_a957 BY mtart matnr.
*EOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
  ENDIF.

* Get discount details - ZDDP - a947
  SELECT a~kappl   AS kappl,
         a~kschl   AS kscha,
*         a~lland   AS lland,
         a~zzlic_id_grp AS zzlic_id_grp,
         a~mtart        AS mtart,
         a~ismmediatype AS ismmediatype,
         a~kfrst   AS kfrst,
         a~datbi   AS kodatbi,
         a~datab   AS kodatab,
         a~kbstat  AS kbstat,
         a~knumh   AS knumh,
         b~kbetr   AS kbetr,
         m~matnr   AS matnr
    FROM a949 AS a INNER JOIN
         konp AS b
    ON   a~knumh EQ b~knumh INNER JOIN
         mara AS m
    ON   m~ismmediatype EQ a~ismmediatype
    APPENDING TABLE @li_a947
    WHERE a~kschl IN @s_kschld
    AND m~mstae          IN @s_mstae                           "Material Status
    AND a~mtart          IN @s_mtarta                          "Material Type
    AND m~matnr          IN @s_matnr                           "Material no
    AND a~ismmediatype   IN @s_mdtyp1                          "Mediatype
     AND ( a~datab    LE @p_prsdt                               "Validity start date of the condition record
     AND   a~datbi    GE @p_prsdt ).                            "Validity end date of the condition record
  IF sy-subrc = 0.
*BOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
*    SORT li_a947 BY matnr.
    SORT li_a947 BY mtart matnr.
*EOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
  ENDIF.

* Prepare final table
  DATA : "lv_kbetr   TYPE kbetr,
         lv_country TYPE string.   "char200. *+ <HIPATEL> <SCTASK0036922> <ED1K908349> <09/03/2018>

*Get all the countries
  SELECT * FROM zqtc_price_reg INTO TABLE li_country.

*Get KOSRT
  IF NOT li_final1 IS INITIAL.
    SELECT knumh kosrt FROM konh INTO TABLE li_konh
      FOR ALL ENTRIES IN li_final1
      WHERE knumh = li_final1-knumh.
    IF sy-subrc = 0.
      SORT li_konh BY knumh.
    ENDIF.
  ENDIF.

* Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
**----Get title text
*  TYPES : BEGIN OF lty_title,
*            extwg     TYPE extwg,
*            matnr     TYPE matnr,
*            mediatype TYPE ismmediatype,
*            title     TYPE char200,
*          END   OF lty_title,
*
*          BEGIN OF lty_mediatype,
*            sign   TYPE sign,
*            option TYPE option,
*            low    TYPE ismmediatype,
*            high   TYPE ismmediatype,
*          END   OF lty_mediatype.
*
*  DATA : li_title     TYPE STANDARD TABLE OF lty_title,
*         li_mediatype TYPE STANDARD TABLE OF lty_mediatype,
*         li_lines     TYPE STANDARD TABLE OF tline,
**         li_lines     LIKE tline OCCURS 0 WITH HEADER LINE,
*
*         lw_title     TYPE lty_title,
*         lw_lines     TYPE tline,
*         lw_mediatype TYPE lty_mediatype,
*
*         lv_name      TYPE tdobname.
*
*  CONSTANTS : lc_id  TYPE thead-tdid VALUE 'GRUN',
*              lc_obj TYPE thead-tdobject VALUE 'MATERIAL'.
*
*  REFRESH : li_temp1, li_mediatype, li_title.
*  CLEAR: lw_temp1, lw_mediatype, lw_title.
*
*  lw_mediatype-sign = c_sign_i.
*  lw_mediatype-option = c_opti_eq.
*  lw_mediatype-low = c_media_ph.
*  APPEND lw_mediatype TO li_mediatype.
*  lw_mediatype-sign = c_sign_i.
*  lw_mediatype-option = c_opti_eq.
*  lw_mediatype-low = c_media_di.
*  APPEND lw_mediatype TO li_mediatype.
*  lw_mediatype-sign = c_sign_i.
*  lw_mediatype-option = c_opti_eq.
*  lw_mediatype-low = c_media_mm.
*  APPEND lw_mediatype TO li_mediatype.
*
*  li_temp1[] = li_final1[].
*  SORT li_temp1 BY mediatype.
*  DELETE li_temp1 WHERE mediatype NOT IN li_mediatype.
*  SORT li_temp1 BY extwg matnr.
*  DELETE ADJACENT DUPLICATES FROM li_temp1 COMPARING extwg matnr.
*
*  LOOP AT li_temp1 INTO lw_temp1.
*    lv_name = lw_temp1-matnr.
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = lc_id
*        language                = sy-langu
*        name                    = lv_name
*        object                  = lc_obj
**       ARCHIVE_HANDLE          = 0
**       LOCAL_CAT               = ' '
**     IMPORTING
**       HEADER                  =
**       OLD_LINE_COUNTER        =
*      TABLES
*        lines                   = li_lines
*      EXCEPTIONS
*        id                      = 1
*        language                = 2
*        name                    = 3
*        not_found               = 4
*        object                  = 5
*        reference_check         = 6
*        wrong_access_to_archive = 7
*        OTHERS                  = 8.
*
*    IF NOT li_lines IS INITIAL.
*      lw_title-extwg = lw_temp1-extwg.
*      lw_title-matnr = lw_temp1-matnr.
*      lw_title-mediatype = lw_temp1-mediatype.
*      LOOP AT li_lines INTO lw_lines.
*        CONCATENATE lw_title-title lw_lines-tdline
*        INTO lw_title-title SEPARATED BY space.
*        SHIFT lw_title-title BY 1 PLACES LEFT.
*      ENDLOOP.
*      APPEND lw_title TO li_title.
*      CLEAR: lw_title.
*    ENDIF.
*
*    REFRESH: li_lines.
*    CLEAR: lv_name.
*  ENDLOOP.
* End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805

*-----Prrepare final table
  LOOP AT li_final1 INTO lw_final1.
    w_final-kappl = lw_final1-kappl.
    w_final-kschl = lw_final1-kschl.
    w_final-pltyp = lw_final1-pltyp.
    IF w_final-pltyp = c_pltyp_p3.     " Europe
      w_final-seqpltyp = c_seq_1.
    ELSEIF w_final-pltyp = c_pltyp_p2. " UK
      w_final-seqpltyp = c_seq_2.
    ELSEIF w_final-pltyp = c_pltyp_p4. " ROW
      w_final-seqpltyp = c_seq_3.
    ELSEIF w_final-pltyp = c_pltyp_p1. " The Americas
      w_final-seqpltyp = c_seq_4.
    ENDIF.
    w_final-kdgrp = lw_final1-kdgrp.
    w_final-matnr = lw_final1-matnr.
    w_final-datbi = lw_final1-datbi.
    w_final-datab = lw_final1-datab.
    w_final-knumh = lw_final1-knumh.
    w_final-mstae = lw_final1-mstae.
    w_final-mtart = lw_final1-mtart.
    w_final-extwg = lw_final1-extwg.
    w_final-mediatype = lw_final1-mediatype.

*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    w_final-title = lw_final1-title.
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   IF NOT li_title IS INITIAL.
*     READ TABLE li_title INTO lw_title WITH KEY extwg = w_final-extwg
*                                                matnr = w_final-matnr
*                                                mediatype = w_final-mediatype.
*     IF sy-subrc = 0.
*       w_final-title = lw_title-title.
*       CLEAR: lw_title.
*     ELSE.
*       w_final-title = ' '.
*     ENDIF.
*   ENDIF.
*   Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805

    IF w_final-mediatype = c_media_ph.
      w_final-seqmedia = c_seq_1.
    ELSEIF w_final-mediatype = c_media_di.
      w_final-seqmedia = c_seq_2.
    ELSEIF w_final-mediatype = c_media_mm.
      w_final-seqmedia = c_seq_3.
    ENDIF.
    w_final-ismcopynr = lw_final1-ismcopynr.
    w_final-ismsubtitle3 = lw_final1-ismsubtitle3.
    w_final-ismpubldate = lw_final1-ismpubldate.
    w_final-maktx = lw_final1-maktx.
    w_final-kopos = lw_final1-kopos.
    w_final-klfn1 = lw_final1-klfn1.
    w_final-konwa = lw_final1-konwa.

*-----Populate currency sign
    CASE w_final-konwa.
      WHEN 'USD'.
        w_final-csign = '$'.
      WHEN 'EUR'.
        w_final-csign = '€'.
      WHEN 'GBP'.
        w_final-csign = '£'.
    ENDCASE.

    READ TABLE li_konh INTO lw_konh WITH KEY knumh = lw_final1-knumh.
    IF sy-subrc = 0.
      w_final-knuma_ag = lw_konh-kosrt.
    ENDIF.
*    w_final-knuma_ag = lw_final1-knuma_ag.

    w_final-kstbm = lw_final1-kstbm.
    w_final-kbetr = lw_final1-kbetr.
*NET Price for Agent Discount	( ZLPR - ZAGD )
    READ TABLE li_a935 INTO lw_a935 WITH KEY matnr = w_final-matnr
    BINARY SEARCH.
    IF sy-subrc = 0.
      w_final-npadd = w_final-kbetr + ( w_final-kbetr * ( lw_a935-kbetr / 1000 ) ).
      w_final-pzagd = lw_a935-kbetr / 10 * -1.
*      lv_kbetr = ( lv_kbetr + lw_a935-kbetr ).
      w_final-fzagd = abap_true.

    ELSE.
*BOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
*      READ TABLE li_a957 INTO lw_a957 WITH KEY matnr = w_final-matnr
      READ TABLE li_a957 INTO lw_a957 WITH KEY mtart = w_final-mtart
                                               matnr = w_final-matnr
*EOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
BINARY SEARCH.
      IF sy-subrc = 0.
        w_final-npadd = w_final-kbetr + ( w_final-kbetr * ( lw_a957-kbetr / 1000 ) ).
        w_final-pzagd = lw_a957-kbetr / 10 * -1.
*        lv_kbetr = ( lv_kbetr + lw_a957-kbetr ).
        w_final-fzagd = abap_true.
      ELSE.
        w_final-npadd = w_final-kbetr.
        w_final-pzagd = 0.
      ENDIF.
    ENDIF.

*-----Get ZAGD discount.
    DATA : lv_zagd TYPE kbetr_kond.
    CLEAR : lv_zagd.
    IF NOT lw_a935-kbetr IS INITIAL.
      lv_zagd = lw_a935-kbetr.
    ELSEIF NOT lw_a957-kbetr IS INITIAL.
      lv_zagd = lw_a957-kbetr.
    ENDIF.
    CLEAR : lw_a935, lw_a957.




*    w_final-npadd = ( w_final-kbetr + lv_kbetr ).
*NET Price Agent Discount and DDP (ZLPR – (ZAGD +  ZDDP))
*BOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
*    READ TABLE li_a947 INTO lw_a947 WITH KEY matnr = w_final-matnr
    READ TABLE li_a947 INTO lw_a947 WITH KEY mtart = w_final-mtart
                                             matnr = w_final-matnr
*EOC <HIPATEL> <INC0213081> <ED1K908707> <10/15/2018>
    BINARY SEARCH.
    IF sy-subrc = 0.



*Begin of Del-Anirban-08.07.2017- ED2K907768-CR 624
*      w_final-npadp = w_final-kbetr + ( w_final-kbetr * ( ( lw_a947-kbetr + lv_zagd ) / 1000 ) ).
*End of Del-Anirban-08.07.2017- ED2K907768-CR 624

*Begin of Add-Anirban-08.07.2017- ED2K907768-CR 624
      w_final-npadp = w_final-kbetr + ( w_final-kbetr * ( lw_a947-kbetr  / 1000 ) ).
*--SOC ERPM 10295 GKAMMILI 02-28-2020 ED2K917671
*      w_final-npadp = w_final-npadp + ( w_final-npadp * ( lv_zagd  / 1000 ) )."Commented for ERPM 10295
      PERFORM f_caliculate_discount USING lv_zagd
                                    CHANGING w_final-npadp.
*--EOC ERPM 10295 GKAMMILI 02-28-2020 ED2K917671

*End of Add-Anirban-08.07.2017- ED2K907768-CR 624

      w_final-pzddp = lw_a947-kbetr / 10 * -1.
      w_final-fzddp = abap_true.

*NET Price and ZDDP	( ZLPR - ZDDP )
      w_final-npapp = w_final-kbetr + ( w_final-kbetr * ( lw_a947-kbetr / 1000 ) ).
    ELSE.
*      w_final-npadp = w_final-kbetr - lv_kbetr .
      IF NOT lv_zagd IS INITIAL.
        w_final-npadp = w_final-npadd.
      ELSE.
        w_final-npadp = w_final-kbetr.
      ENDIF.
      w_final-npapp = w_final-kbetr.
      w_final-pzddp = 0.
      w_final-fzddp = abap_false.
    ENDIF.

*-----Get the countries
    IF NOT w_final-pltyp IS INITIAL.
      li_country1[] = li_country[].
      SORT li_country1[] BY pltyp.
      DELETE li_country1 WHERE pltyp NE w_final-pltyp.
      SORT li_country1 BY land1.
      LOOP AT li_country1 INTO lw_country.
        CONCATENATE lv_country lw_country-land1 INTO lv_country SEPARATED BY space.
        IF w_final-pltyd IS INITIAL.
          w_final-pltyd = lw_country-ptext. " Populate Price list type description
        ENDIF.
      ENDLOOP.
      SHIFT lv_country BY 1 PLACES LEFT.
      w_final-country = lv_country.
    ENDIF.
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*Journal Alpha sections should being with the first Journal Description with that letter and end with the last.
    w_final-alpha_sep = lw_final1-alpha_sep.
    w_final-maktx_sub = lw_final1-maktx_sub.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

    APPEND w_final TO i_final.
    CLEAR:  w_final, lv_country.
    REFRESH: li_country1.
  ENDLOOP.

*-----Get Bom details
  REFRESH: li_temp.
  li_temp[] = li_final1[].
  SORT li_temp BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_temp COMPARING matnr.

  IF NOT li_temp IS INITIAL.
*-----BOM details (Based on BOM Components)
    SELECT p~idnrk                                              "BOM component
           t~stlnr                                              "Bill of material
           t~matnr                                              "Material Number
           m~extwg                                              "External Material Group
           m~mtart                                              "Material type
      FROM stpo AS p          INNER JOIN
           stas AS s
        ON s~stlty EQ p~stlty
       AND s~stlnr EQ p~stlnr
       AND s~stlkn EQ p~stlkn INNER JOIN
           mast AS t
        ON t~stlnr EQ s~stlnr
       AND t~stlal EQ s~stlal INNER JOIN
           mara AS m
        ON m~matnr EQ t~matnr
      INTO TABLE li_bom_detl
       FOR ALL ENTRIES IN li_temp
     WHERE p~idnrk EQ li_temp-matnr
       AND t~stlan EQ c_bom_us_sd
       AND m~mtart IN s_mtartb.
    IF sy-subrc EQ 0.
      DELETE li_bom_detl WHERE extwg IS INITIAL.
      SORT li_bom_detl BY stlnr matnr_hdr idnrk.
    ENDIF.

*   BOM details (Based on BOM Header)
    SELECT p~idnrk                                              "BOM component
           t~stlnr                                              "Bill of material
           t~matnr                                              "Material Number
           m~extwg                                              "External Material Group
           m~mtart                                              "Material type
      FROM mast AS t          INNER JOIN
           stas AS s
        ON s~stlnr EQ t~stlnr
       AND s~stlal EQ t~stlal INNER JOIN
           stpo AS p
        ON p~stlty EQ s~stlty
       AND p~stlnr EQ s~stlnr
       AND p~stlkn EQ s~stlkn INNER JOIN
           mara AS m
        ON m~matnr EQ t~matnr
 APPENDING TABLE li_bom_detl
       FOR ALL ENTRIES IN li_temp
     WHERE t~matnr EQ li_temp-matnr
       AND t~stlan EQ c_bom_us_sd
       AND m~mtart IN s_mtartb.
    IF sy-subrc EQ 0.
      DELETE li_bom_detl WHERE extwg IS INITIAL.
      SORT li_bom_detl BY stlnr matnr_hdr idnrk.
    ENDIF.

    DELETE ADJACENT DUPLICATES FROM li_bom_detl
                   COMPARING stlnr matnr_hdr idnrk.

* Begin by amohammed on 05/12/2020 - ERPM-6882 - ED2K918137
    DATA(li_bom_detl_tmp) = li_bom_detl.
    SORT li_bom_detl_tmp BY idnrk.
    DELETE ADJACENT DUPLICATES FROM li_bom_detl_tmp COMPARING idnrk.
*   Fetch External Material Group for the BOM Components
    SELECT matnr,                       "Material Number
           extwg,                       "External Material Group
           mtart,                       "Material Type
           mstae,                       "Cross-Plant Material Status
           ismtitle,                    "Title
           ismmediatype,                "Media Type
           ismpubltype                  "Publication Type
      FROM mara                         "General Material Data
      INTO TABLE @DATA(li_extwg_cmp)
       FOR ALL ENTRIES IN @li_bom_detl_tmp
     WHERE matnr EQ @li_bom_detl_tmp-idnrk. "BOM component
    IF sy-subrc EQ 0.
      SORT li_extwg_cmp BY matnr.
    ENDIF. " IF sy-subrc EQ 0
* End by amohammed on 05/12/2020 - ERPM-6882 - ED2K918137

    LOOP AT li_bom_detl ASSIGNING FIELD-SYMBOL(<lst_bom_detl>).
      READ TABLE li_temp INTO lw_final1
           WITH KEY matnr = <lst_bom_detl>-idnrk
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_bom_detl>-extwg_cmp = lw_final1-extwg.
      ENDIF.

* Begin by amohammed on 05/12/2020 - ERPM-6882 - ED2K918137
      IF <lst_bom_detl>-extwg_cmp IS INITIAL.
        READ TABLE li_extwg_cmp ASSIGNING FIELD-SYMBOL(<lst_extwg_cmp>)
           WITH KEY matnr = <lst_bom_detl>-idnrk
           BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lst_bom_detl>-extwg_cmp = <lst_extwg_cmp>-extwg.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
* End by amohammed on 05/12/2020 - ERPM-6882 - ED2K918137

*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
* If the Condition type is ZLPS, print the Material group
      IF lw_final1-kschl = lc_zlps.  "'ZLPS'.
        CONTINUE.
      ENDIF.
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
*     Begin of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
      READ TABLE li_temp INTO lw_final1
           WITH KEY matnr = <lst_bom_detl>-matnr_hdr
           BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR: <lst_bom_detl>-extwg_cmp,
               <lst_bom_detl>-extwg.
      ENDIF.
*     End   of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
    ENDLOOP.
*   Begin of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
    DELETE li_bom_detl WHERE extwg_cmp IS INITIAL
                         AND extwg     IS INITIAL.
*   End   of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
    SORT li_bom_detl BY extwg_cmp extwg.

* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
    IF rb_age_e IS NOT INITIAL.
      DATA(li_tmp_bom) = li_bom_detl.
      DELETE li_tmp_bom WHERE mtart NOT IN s_mtartc. "Consider Multi-Journal BOMs only
      IF li_tmp_bom IS NOT INITIAL.
*     Get the unique BOM Components
        SORT li_tmp_bom BY idnrk.
        DELETE ADJACENT DUPLICATES FROM li_tmp_bom
                  COMPARING idnrk.

        LOOP AT li_tmp_bom ASSIGNING FIELD-SYMBOL(<lst_tmp_bom>).
*       Check if BOM Component has price maintained
          READ TABLE li_temp TRANSPORTING NO FIELDS
               WITH KEY matnr = <lst_tmp_bom>-idnrk
               BINARY SEARCH.
          IF sy-subrc NE 0. "Price not maintained
*         Add an entry for the BOM Component with 0(Zero) Price
            APPEND INITIAL LINE TO i_final ASSIGNING FIELD-SYMBOL(<lst_fnl>).
            <lst_fnl>-kappl       = c_appl_sls.                  " Application (Sales/Distribution)
            <lst_fnl>-kschl       = s_kschlp-low.                " Condition type
            <lst_fnl>-pltyp       = s_pltyp1-low.                " Price list type
            <lst_fnl>-kdgrp       = s_kdgrpi-low.                " Customer group
            <lst_fnl>-matnr       = <lst_tmp_bom>-idnrk.         " Material Number
            <lst_fnl>-extwg       = <lst_tmp_bom>-extwg_cmp.     " External Material Group
            READ TABLE li_extwg_cmp ASSIGNING <lst_extwg_cmp>
                           WITH KEY matnr = <lst_tmp_bom>-idnrk
                           BINARY SEARCH.
            IF sy-subrc EQ 0.
              <lst_fnl>-mtart       = <lst_extwg_cmp>-mtart.         " Material Type
              <lst_fnl>-mstae       = <lst_extwg_cmp>-mstae.         " Cross-Plant Material Status
*              <lst_fnl>-title       = <lst_extwg_cmp>-ismtitle.      " Title
              <lst_fnl>-mediatype   = <lst_extwg_cmp>-ismmediatype.  " Media Type
** Commented as there is no field in i_final
**              <lst_fnl>-publtype    = <lst_extwg_cmp>-ismpubltype. " Publication Type
            ENDIF.
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
*   Fetch Material Basic Data Text
            CLEAR: lv_basic_text.
            PERFORM f_get_basic_text USING <lst_tmp_bom>-idnrk
                                     CHANGING lv_basic_text.

            CLEAR: lv_alpha_sep, lv_maktx_sub.
            PERFORM f_get_alpha_sep USING lv_basic_text
                                    CHANGING lv_alpha_sep
                                             lv_maktx_sub.
            <lst_fnl>-title = lv_basic_text.
            <lst_fnl>-maktx = lv_basic_text.
            <lst_fnl>-alpha_sep = lv_alpha_sep.
            <lst_fnl>-maktx_sub = lv_maktx_sub.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
            <lst_fnl>-datbi       = <lst_fnl>-datab = p_prsdt.   " Validity Dates
            <lst_fnl>-konwa       = c_curr_usd.                  " Currency (USD)
            <lst_fnl>-knuma_ag    = c_inst_rate.                 " Search term for conditions (Sales deal: Institutional)
* Commented as there is no field in i_final
*            <lst_fnl>-kotab       = c_wo_relat.                  " Condition Table (A913)

            <lst_fnl>-excld_prc   = abap_true.                   " Exclude Pricing
            <lst_fnl>-price_nm    = abap_true.                   " Price Not Maintained
          ENDIF. " IF sy-subrc NE 0
        ENDLOOP. " LOOP AT li_bom_detl ASSIGNING <lst_bom_detl>
      ENDIF. " IF li_bom_detl IS NOT INITIAL
    ENDIF. " IF rb_lib_e IS NOT INITIAL
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919

    REFRESH: li_temp.
    CLEAR: lw_final1.

    li_bom_headr[] = li_bom_detl[].
    li_bom_comp[]  = li_bom_detl[].

    SORT: li_bom_headr BY matnr_hdr idnrk,
          li_bom_comp  BY idnrk matnr_hdr.
    DELETE ADJACENT DUPLICATES FROM:
          li_bom_headr COMPARING matnr_hdr idnrk,
          li_bom_comp  COMPARING idnrk matnr_hdr.
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
    IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
      SELECT * FROM makt
        INTO TABLE @DATA(li_makt)
        FOR ALL ENTRIES IN @li_bom_headr
        WHERE matnr EQ @li_bom_headr-matnr_hdr
          AND spras EQ 'E'.
      SELECT * FROM makt
        APPENDING TABLE @li_makt
        FOR ALL ENTRIES IN @li_bom_comp
        WHERE matnr EQ @li_bom_comp-idnrk
          AND spras EQ 'E'.
      SORT li_makt BY matnr.
    ENDIF.
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
*-----populate BOM Hdr / component
    LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_final>).
      <lst_final>-bom_info    = c_flag_n.                          "Not a BOM Component or Header
      READ TABLE li_bom_comp TRANSPORTING NO FIELDS
           WITH KEY idnrk = <lst_final>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR: <lst_final>-hdr_comp.
        LOOP AT li_bom_comp ASSIGNING FIELD-SYMBOL(<lst_bom_comp>) FROM sy-tabix.
          IF <lst_bom_comp>-idnrk NE <lst_final>-matnr.
            EXIT.
          ENDIF.
          IF <lst_final>-hdr_comp IS INITIAL.
            <lst_final>-hdr_comp = <lst_bom_comp>-matnr_hdr.
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
            IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
              READ TABLE li_makt ASSIGNING FIELD-SYMBOL(<fs_makt>)
                WITH KEY matnr = <lst_bom_comp>-matnr_hdr BINARY SEARCH.
              IF sy-subrc EQ 0.
                <lst_final>-mat_desc = <fs_makt>-maktx.
              ENDIF.
            ENDIF.
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
          ELSE.
            CONCATENATE <lst_final>-hdr_comp
                        <lst_bom_comp>-matnr_hdr
                   INTO <lst_final>-hdr_comp
              SEPARATED BY c_comma.
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
            IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
              READ TABLE li_makt ASSIGNING <fs_makt>
                WITH KEY matnr = <lst_bom_comp>-matnr_hdr BINARY SEARCH.
              IF sy-subrc EQ 0.
                CONCATENATE <lst_final>-mat_desc
                          <fs_makt>-maktx
                     INTO <lst_final>-mat_desc
                SEPARATED BY c_comma.
              ENDIF.
            ENDIF.
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
          ENDIF.
        ENDLOOP.
        <lst_final>-bom_info  = c_flag_c.                          "BOM Component
      ENDIF.
      READ TABLE li_bom_headr TRANSPORTING NO FIELDS
           WITH KEY matnr_hdr = <lst_final>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR: <lst_final>-hdr_comp.
        LOOP AT li_bom_headr ASSIGNING FIELD-SYMBOL(<lst_bom_head>) FROM sy-tabix.
          IF <lst_bom_head>-matnr_hdr NE <lst_final>-matnr.
            EXIT.
          ENDIF.
          IF <lst_final>-hdr_comp IS INITIAL.
            <lst_final>-hdr_comp = <lst_bom_head>-idnrk.
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
            IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
              READ TABLE li_makt ASSIGNING <fs_makt>
                WITH KEY matnr = <lst_bom_head>-idnrk BINARY SEARCH.
              IF sy-subrc EQ 0.
                <lst_final>-mat_desc = <fs_makt>-maktx.
              ENDIF.
            ENDIF.
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
          ELSE.
            CONCATENATE <lst_final>-hdr_comp
                        <lst_bom_head>-idnrk
                   INTO <lst_final>-hdr_comp
              SEPARATED BY c_comma.
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
            IF rb_age_c IS NOT INITIAL OR rb_age_e IS NOT INITIAL. " Works only for CSV and XLS
              READ TABLE li_makt ASSIGNING <fs_makt>
                WITH KEY matnr = <lst_bom_head>-idnrk BINARY SEARCH.
              IF sy-subrc EQ 0.
                CONCATENATE <lst_final>-mat_desc
                          <fs_makt>-maktx
                     INTO <lst_final>-mat_desc
                SEPARATED BY c_comma.
              ENDIF.
            ENDIF.
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
          ENDIF.
        ENDLOOP.
        <lst_final>-bom_info  = c_flag_h.                          "BOM Header
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF NOT i_final IS INITIAL.
    SORT i_final BY extwg seqmedia kdgrp seqpltyp ASCENDING
                  klfn1 DESCENDING.
    LOOP AT i_final ASSIGNING FIELD-SYMBOL(<w_final>).
*-----determine scale
      IF NOT <w_final>-klfn1 IS INITIAL.
*BOC <HIPATEL> <INC0212602> <ED1K908594> <10/01/2018>
*FTE issue: Scale is not assigning properly while record are missing for
*Current number of the line scale(KONM-KLFN1)
*        lv_count = lv_count + 1.
*        IF lv_count = 1.
*          <w_final>-scale = c_large.
*        ELSEIF lv_count = 2.
*          <w_final>-scale = c_medium.
*        ELSEIF lv_count = 3.
*          <w_final>-scale = c_small.
*        ENDIF.
*        IF lv_count = 3.
*          CLEAR: lv_count.
*        ENDIF.
*New Scale
        lv_count = <w_final>-klfn1.
        IF lv_count = 1.
          <w_final>-scale = c_small.
        ELSEIF lv_count = 2.
          <w_final>-scale = c_medium.
        ELSEIF lv_count = 3.
          <w_final>-scale = c_large.
        ENDIF.
*EOC <HIPATEL> <INC0212602> <ED1K908594> <10/01/2018>
      ELSE.
        <w_final>-scale = ' ' .
      ENDIF.

*BOD <HIPATEL> <CR-7760> <ED1K908594> <10/01/2018>
*These rounding rules are requested to be removed.
*      DATA : lv_amt TYPE i.
**-----Round off all currency fields
*      lv_amt = <w_final>-kbetr.
*      <w_final>-kbetr = lv_amt.
*      CLEAR : lv_amt.
*      lv_amt = <w_final>-npadd.
*      <w_final>-npadd = lv_amt.
*      CLEAR : lv_amt.
*      lv_amt = <w_final>-npapp.
*      <w_final>-npapp = lv_amt.
*      CLEAR : lv_amt.
*      lv_amt = <w_final>-npadp.
*      <w_final>-npadp = lv_amt.
*      CLEAR : lv_amt.
*EOD <HIPATEL> <CR-7760> <ED1K908594> <10/01/2018>
    ENDLOOP.
  ENDIF.

*-----sequence
  IF rb_age_x EQ abap_true.
    SORT i_final BY extwg seqmedia kdgrp seqpltyp ASCENDING
                  klfn1 DESCENDING.
  ENDIF.
  IF rb_age_c EQ abap_true.
    LOOP AT i_final INTO w_final.

      CASE w_final-seqpltyp.
        WHEN 1.
          w_final-seqpltyp = 3.
        WHEN 2.
          w_final-seqpltyp = 2.
        WHEN 3.
          w_final-seqpltyp = 4.
        WHEN 4.
          w_final-seqpltyp = 1.
      ENDCASE.
      MODIFY i_final FROM w_final.
    ENDLOOP.

    SORT i_final BY extwg ASCENDING
                    seqmedia DESCENDING
                    klfn1 DESCENDING
                    seqpltyp ASCENDING.

  ENDIF.
  IF rb_age_e EQ abap_true.
    LOOP AT i_final INTO w_final.

      CASE w_final-seqpltyp.
        WHEN 1.
          w_final-seqpltyp = 3.
        WHEN 2.
          w_final-seqpltyp = 2.
        WHEN 3.
          w_final-seqpltyp = 4.
        WHEN 4.
          w_final-seqpltyp = 1.
      ENDCASE.
      MODIFY i_final FROM w_final.
    ENDLOOP.
    SORT i_final BY title ASCENDING
                    extwg ASCENDING
                    klfn1 ASCENDING
                    seqmedia DESCENDING
                    seqpltyp ASCENDING.
  ENDIF.



*-----Exclude prices only
  LOOP AT i_final INTO w_final.
    IF ( w_final-matnr     IN s_matnr1 AND s_matnr1 IS NOT INITIAL ) OR
       ( w_final-mstae     IN s_mstae1 AND s_mstae1 IS NOT INITIAL ) OR
       ( w_final-mtart     IN s_mtart1 AND s_mtart1 IS NOT INITIAL ) OR
       ( w_final-mediatype IN s_mdtyp1 AND s_mdtyp1 IS NOT INITIAL ) OR
       ( w_final-kdgrp     IN s_kdgrp1 AND s_kdgrp1 IS NOT INITIAL ).
      CLEAR : w_final-kbetr,
              w_final-npadd,
              w_final-npapp,
              w_final-npadp,
              w_final-pzagd,
              w_final-pzddp.
      w_final-excld = 'C'..
      MODIFY i_final FROM w_final.
    ENDIF.
  ENDLOOP.

*-----Exclude prices and products
  LOOP AT i_final INTO w_final.
    IF ( w_final-matnr     IN s_matnr2 AND s_matnr2 IS NOT INITIAL ) OR
       ( w_final-mstae     IN s_mstae2 AND s_mstae2 IS NOT INITIAL ) OR
       ( w_final-mtart     IN s_mtart2 AND s_mtart2 IS NOT INITIAL ) OR
       ( w_final-mediatype IN s_mdtyp2 AND s_mdtyp2 IS NOT INITIAL ) OR
       ( w_final-kdgrp     IN s_kdgrp2 AND s_kdgrp2 IS NOT INITIAL ).
      w_final-excld = abap_true.
      MODIFY i_final FROM w_final.
    ENDIF.
  ENDLOOP.

  DELETE i_final WHERE excld EQ abap_true.

*-----Get ISSN COde for only print and digital materials
  REFRESH: li_temp.
  li_temp2[] = i_final[].
  SORT li_temp2 BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_temp2 COMPARING matnr.

  SELECT m~extwg m~ismmediatype j~matnr j~idcodetype j~identcode
    FROM  jptidcdassign AS j INNER JOIN
          mara          AS m
    ON j~matnr EQ m~matnr
    INTO TABLE i_issn
    FOR ALL ENTRIES IN li_temp2
    WHERE j~matnr = li_temp2-matnr
    AND   j~idcodetype = p_idcdty "ZSSN
    AND   ( m~ismmediatype EQ c_media_ph OR m~ismmediatype EQ c_media_di ).
  IF sy-subrc = 0.
    SORT i_issn BY matnr idcodetype identcode.
    DELETE ADJACENT DUPLICATES FROM i_issn COMPARING ALL FIELDS.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_DATA_ONIX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_send_data_onix .
  TYPES : BEGIN OF lty_marc,
            matnr TYPE matnr,
            werks TYPE werks_d,
            herkl TYPE herkl,
          END   OF lty_marc,

          BEGIN OF lty_t005t,
            spras   TYPE spras,
            land1   TYPE land1,
            landx   TYPE landx,
            landx50 TYPE landx50,
          END   OF lty_t005t,

          BEGIN OF lty_noi,
            med_prod    TYPE ismrefmdprod,
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
            mpg_lfdnr   TYPE mpg_lfdnr,     "Sequence number of media issue
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
            matnr       TYPE matnr,
            ismpubldate TYPE ismpubldate,
            ismcopynr   TYPE ismheftnummer,
            ismnrinyear TYPE ismnrimjahr,
            ismyearnr   TYPE ismjahrgang,
          END   OF lty_noi,

          BEGIN OF lty_optin,
            matnr       TYPE matnr,
            ismpubltype TYPE ismpubltype,
          END   OF lty_optin.

  DATA:
    li_edidd      TYPE edidd_tt,
    lst_edidd     TYPE edidd,
    lst_edidd_pq1 TYPE edidd,
    lst_edidd_pq2 TYPE edidd,
    lst_edidd_pq3 TYPE edidd,
    lst_edidd_pq4 TYPE edidd,
    lst_edidd_pq5 TYPE edidd,
    lst_edidd_tp1 TYPE edidd,
    lst_edidd_tp2 TYPE edidd,
    lst_edidd_tp3 TYPE edidd,
    lst_edidd_tp4 TYPE edidd,
    lst_edidd_tp5 TYPE edidd,
    lst_trailer   TYPE edidd,
    li_idoc_cnt   TYPE edidc_tt.

  DATA:
    lst_edidc          TYPE edidc,
*    lst_jps_hdr        TYPE z1pdm_jps_hdr,
*    lst_journal        TYPE z1pdm_journal,
*    lst_colhead        TYPE z1pdm_colhead,
*    lst_price          TYPE z1pdm_price,

    lst_header         TYPE z1pdm_onix_header,
    lst_subs_product   TYPE z1pdm_onix_subs_product,
    lst_subs_prod_id   TYPE z1pdm_onix_subs_prod_id,
    lst_serial_version TYPE z1pdm_onix_serial_version,
    lst_version_scope  TYPE z1pdm_onix_version_scope,
    lst_catalog_price  TYPE z1pdm_onix_catalog_price,
    lst_price_qualf1   TYPE z1pdm_onix_price_qualf,
    lst_price_qualf2   TYPE z1pdm_onix_price_qualf,
    lst_price_qualf3   TYPE z1pdm_onix_price_qualf,
    lst_price_qualf4   TYPE z1pdm_onix_price_qualf,
    lst_price_qualf5   TYPE z1pdm_onix_price_qualf,
    lst_total_price1   TYPE z1pdm_onix_total_price,
    lst_total_price2   TYPE z1pdm_onix_total_price,
    lst_total_price3   TYPE z1pdm_onix_total_price,
    lst_total_price4   TYPE z1pdm_onix_total_price,
    lst_total_price5   TYPE z1pdm_onix_total_price,
    lst_onix_trailer   TYPE z1pdm_onix_trailer,

*    li_subs_product    TYPE STANDARD TABLE OF z1pdm_onix_subs_product,
*    li_subs_prod_id    TYPE STANDARD TABLE OF z1pdm_onix_subs_prod_id,
*    li_serial_version  TYPE STANDARD TABLE OF z1pdm_onix_serial_version,
*    li_version_scope   TYPE STANDARD TABLE OF z1pdm_onix_version_scope,
*    li_catalog_price   TYPE STANDARD TABLE OF z1pdm_onix_catalog_price,
*    li_price_qualf     TYPE STANDARD TABLE OF z1pdm_onix_price_qualf,
*    li_total_price     TYPE STANDARD TABLE OF z1pdm_onix_total_price,
    li_noi             TYPE STANDARD TABLE OF lty_noi,
    li_noi_tmp         TYPE STANDARD TABLE OF lty_noi,

    li_final           TYPE STANDARD TABLE OF ty_final,
*    li_final1          TYPE STANDARD TABLE OF ty_final,
    li_final2          TYPE STANDARD TABLE OF ty_final,
    li_marc            TYPE STANDARD TABLE OF lty_marc,
    li_t005t           TYPE STANDARD TABLE OF lty_t005t,
    li_seq             TYPE STANDARD TABLE OF zqtc_msg_no,
    li_optin           TYPE STANDARD TABLE OF lty_optin,

    lw_final           TYPE ty_final,
*    lw_final1          TYPE ty_final,
    lw_final2          TYPE ty_final,
    lw_final3          TYPE ty_final,
    lw_marc            TYPE lty_marc,
    lw_t005t           TYPE lty_t005t,
    lw_noi             TYPE lty_noi,
    lw_seq             TYPE zqtc_msg_no,
    lw_optin           TYPE lty_optin.

  DATA:
    lv_c_segnum        TYPE idocdsgnum,
    lv_p_segn_h        TYPE edi_psgnum,
*    lv_p_segn_j        TYPE edi_psgnum,
*    lv_p_segn_c        TYPE edi_psgnum,
    lv_text            TYPE char100,
    lv_subs_prod       TYPE sy-tabix,
*    lv_subs_prod_id    TYPE i,
    lv_idoc            TYPE i,
    lv_no_of_rec       TYPE i,
    lv_total_idoc_no   TYPE i,
    lv_current_idoc_no TYPE i,
    lv_decimal         TYPE p DECIMALS 4,
    lv_fraction        TYPE p DECIMALS 4,
    lv_guid            TYPE guid_16,
    lv_tabix_scale     TYPE sy-tabix,
    lv_counter         TYPE i,
    lv_kstbm           TYPE kstbm,
*Begin of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
    lv_max_no_of_idoc  TYPE i,
*End of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
    lv_len             TYPE i,
    lv_req_len         TYPE i,
*-----Get volume/issues from Print
    lv_issue           TYPE string, "ismnrimjahr,
    lv_volume          TYPE string. "ismheftnummer.
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>

*Begin of Del-Anirban-07.25.2017-ED2K907503-Defect 3536
*  CONSTANTS : lv_max_no_of_idoc TYPE i VALUE '500',
*End of Del-Anirban-07.25.2017-ED2K907503-Defect 3536
  CONSTANTS : lc_kstbm          TYPE kstbm VALUE '9999999.000'.
  REFRESH: li_optin.
  CLEAR: lv_idoc, lv_idoc, lv_no_of_rec, lv_total_idoc_no, lv_decimal, lv_fraction,
         lv_current_idoc_no, lv_guid, lv_text, lw_optin.

  lv_max_no_of_idoc = p_rec.
  IF NOT i_final IS INITIAL.
    REFRESH: li_final.
    li_final[] = i_final[].
    SORT li_final BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_final COMPARING matnr.
*BOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*Sorting order change based on the material description
*    SORT li_final BY extwg seqmedia ASCENDING.
    SORT li_final BY maktx seqmedia ASCENDING.
*EOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>

*-----calculate total idoc no to be created
    DESCRIBE TABLE li_final LINES lv_no_of_rec.
    lv_decimal = lv_no_of_rec / lv_max_no_of_idoc.
    lv_total_idoc_no = lv_decimal DIV 1.
    lv_fraction = lv_decimal MOD 1.
    IF lv_fraction GT 0.
      lv_total_idoc_no = lv_total_idoc_no + 1.
    ENDIF.
*-----Get GUID
    IF lv_guid IS INITIAL.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_16 = lv_guid.
    ENDIF.

    REFRESH: li_final2.
    li_final2[] = i_final[].
    SORT li_final2 BY extwg matnr .
    DELETE ADJACENT DUPLICATES FROM li_final2 COMPARING extwg matnr.

*-----Get country of origin
    SELECT matnr werks herkl FROM marc INTO TABLE li_marc
    FOR ALL ENTRIES IN i_final
    WHERE matnr = i_final-matnr.
    IF sy-subrc = 0.
      SORT li_marc BY herkl.
      DELETE li_marc WHERE herkl IS INITIAL.
      SORT li_marc BY matnr herkl.
      DELETE ADJACENT DUPLICATES FROM li_marc COMPARING matnr herkl.

*-----Get HERKL Description
      SELECT spras land1 landx landx50 FROM t005t INTO TABLE li_t005t
        FOR ALL ENTRIES IN li_marc WHERE spras = sy-langu
                                   AND   land1 = li_marc-herkl.
    ENDIF.

*-----Get no of issues
    SELECT med_prod
           mpg_lfdnr "+<HIPATEL> <INC0215495> <ED1K908707>
           matnr
           ismpubldate
           ismcopynr
           ismnrinyear
           ismyearnr
      FROM jptmg0
      INTO TABLE li_noi
      FOR ALL ENTRIES IN i_final
      WHERE med_prod = i_final-matnr.
    IF sy-subrc = 0.
      SORT li_noi ASCENDING BY med_prod.
    ENDIF.
  ENDIF.

*-----Get optin title details.
  SELECT matnr ismpubltype
        FROM mara
        INTO TABLE li_optin
        FOR ALL ENTRIES IN li_final
        WHERE matnr = li_final-matnr.
  IF sy-subrc = 0.
    SORT li_optin BY matnr.
  ENDIF.




  IF NOT i_final IS INITIAL.
    LOOP AT li_final INTO lw_final.
      lv_idoc = lv_idoc + 1. "No of idocs
      IF ( lv_idoc = lv_max_no_of_idoc + 1 OR lv_idoc = 1 ).
* Populate IDOC Control Record
        PERFORM f_idoc_cntrl_rec USING    c_m_typ_j
                                          c_i_typ_j
                                 CHANGING lst_edidc.
*-----Populate current idoc no
        lv_current_idoc_no = lv_current_idoc_no + 1.
*-----Populate Header
        lv_c_segnum = lv_c_segnum + 1.
        CLEAR: lst_header.
        lst_header-sender_name = 'John Wiley & Sons Ltd.'(o05).
        lst_header-sender_contact = 'eBusiness Team'(o06).
        lst_header-sender_email = 'onix@wiley.com'(o07).

        "Get sequence no for every run
        SELECT * FROM zqtc_msg_no INTO TABLE li_seq.
        IF sy-subrc = 0.
          SORT li_seq DESCENDING BY zzseq.
          READ TABLE li_seq INTO lw_seq INDEX 1.
          IF sy-subrc = 0.
            lst_header-message_number = lw_seq-zzseq + 1.
          ENDIF.
        ELSE.
          lst_header-message_number = 1.
        ENDIF.

        "Populate ZQTC_MSG_NO with current sequence no
        IF NOT lst_header-message_number IS INITIAL.
          CLEAR : lw_seq.
          REFRESH li_seq.
          lw_seq-mandt = sy-mandt.
          lw_seq-zzseq = lst_header-message_number.
          lw_seq-aenam = sy-uname.
          lw_seq-aedat = sy-datum.
          lw_seq-aezet = sy-uzeit.
          APPEND lw_seq TO li_seq.
          MODIFY zqtc_msg_no FROM TABLE li_seq.
          CLEAR : lw_seq.
          REFRESH li_seq.
        ENDIF.

        lst_header-sent_date_time = sy-datum.
        lst_header-message_note = 'SAP ERP 7.40'(o09).
        CONCATENATE p_prsdt+0(4) 'Calendar Year Prices'(o10) INTO lv_text SEPARATED BY space.
        lst_header-subscription_period_label = lv_text.
        CLEAR: lv_text.
        CONCATENATE p_prsdt+0(4) '0101' INTO lv_text.
        CONDENSE lv_text.
        lst_header-subscription_period_start_date = lv_text.
        CLEAR: lv_text.
        CONCATENATE p_prsdt+0(4) '1231' INTO lv_text.
        CONDENSE lv_text.
        lst_header-subscription_period_end_date = lv_text.
        CLEAR: lv_text.
        lst_header-complete_file = ' '.
        APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd>).

        <lst_edidd>-segnum = lv_c_segnum.
        <lst_edidd>-segnam = c_seg_hdr.
        <lst_edidd>-hlevel = 1.
        <lst_edidd>-psgnum = 0.

        <lst_edidd>-sdata  = lst_header.
        lv_p_segn_h        = lv_c_segnum.
      ENDIF.
*##################################  POPULATE IDOC STRUCTURE  ############################
*-----Populate Z1PDM_ONIX_SUBS_PRODUCT
      lv_subs_prod = sy-tabix + 1.
      lv_c_segnum = lv_c_segnum + 1.

      lst_subs_product-notification_type = '00'.
      lst_subs_product-reason_for_notification_type = '00'.
      CONCATENATE 'Publication of'(o11) lw_final-datab+0(4) 'Price List'(o12) INTO lv_text SEPARATED BY space.
      lst_subs_product-notification_type_note = lv_text.
      CLEAR : lv_text.
      lst_subs_product-online_publishing_role = '05'.
      lst_subs_product-online_publisher_name = 'John Wiley & Sons Ltd.'(o05).
      lst_subs_product-subscription_product_name = lw_final-maktx.

      CASE lw_final-mediatype.
        WHEN c_media_ph.
          CONCATENATE p_prsdt+2(2) lw_final-extwg c_slash c_media_p INTO lv_text SEPARATED BY space.
        WHEN c_media_di.
          CONCATENATE p_prsdt+2(2) lw_final-extwg c_slash 'D' INTO lv_text SEPARATED BY space.
        WHEN c_media_mm.
          CONCATENATE p_prsdt+2(2) lw_final-extwg c_slash 'C' INTO lv_text SEPARATED BY space.
      ENDCASE.
      lst_subs_product-subscription_product_desc = lv_text.
      CLEAR: lv_text.

      lst_subs_product-content_hosting_system = 'Wiley Online Library'(o13).

      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd1>).
      <lst_edidd1>-segnum = lv_c_segnum.
      <lst_edidd1>-segnam = c_subs_prod.
      <lst_edidd1>-hlevel = 2.
      <lst_edidd1>-psgnum = 1.
      <lst_edidd1>-sdata  = lst_subs_product.
      CLEAR: lst_subs_product.
*    lv_p_segn_h        = lv_c_segnum.

*-----Populate Z1PDM_ONIX_SUBS_PROD_ID
*-----Populate product code
      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd2>).
      lv_c_segnum = lv_c_segnum + 1.
*      lv_subs_prod_id = lv_subs_prod + 1.

      lst_subs_prod_id-subscription_prod_id_type = '01'.
      lst_subs_prod_id-subscription_prod_id_type_name = 'Product Code'(o14).
      CASE lw_final-mediatype.
        WHEN c_media_ph.
          CONCATENATE lw_final-extwg '/P' INTO lv_text.
          lst_subs_prod_id-subscription_prod_id_value = lv_text.
        WHEN c_media_di.
          CONCATENATE lw_final-extwg '/D' INTO lv_text.
          lst_subs_prod_id-subscription_prod_id_value = lv_text.
        WHEN c_media_mm.
          CONCATENATE lw_final-extwg '/C' INTO lv_text.
          lst_subs_prod_id-subscription_prod_id_value = lv_text.
        WHEN OTHERS.
          lst_subs_prod_id-subscription_prod_id_value = ' '.
      ENDCASE.
      CLEAR: lv_text.
      <lst_edidd2>-segnum = lv_c_segnum.
      <lst_edidd2>-segnam = c_subs_prod_id.
      <lst_edidd2>-hlevel = 3.
      <lst_edidd2>-psgnum = 2.
      <lst_edidd2>-sdata  = lst_subs_prod_id.
      CLEAR : lst_subs_prod_id.

*-----Populate Package details
      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd3>).
      lv_c_segnum = lv_c_segnum + 1.
*      lv_subs_prod_id = lv_subs_prod.

      lst_subs_prod_id-subscription_prod_id_type = '01'.
      lst_subs_prod_id-subscription_prod_id_type_name = 'Package Number'(o15).
      lst_subs_prod_id-subscription_prod_id_value = lw_final-matnr.

      <lst_edidd3>-segnum = lv_c_segnum.
      <lst_edidd3>-segnam = c_subs_prod_id.
      <lst_edidd3>-hlevel = 3.
      <lst_edidd3>-psgnum = 2.
      <lst_edidd3>-sdata  = lst_subs_prod_id.
      CLEAR : lst_subs_prod_id.

*-----Populate Z1PDM_ONIX_SERIAL_VERSION
      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd4>).
      lv_c_segnum = lv_c_segnum + 1.
*      lv_subs_prod_id = lv_subs_prod.

*     Begin of DEL:ERP-6613:WROY:14-Feb-2018:ED2K910877
*     lst_serial_version-serial_version_id_type = '07'.
*     End   of DEL:ERP-6613:WROY:14-Feb-2018:ED2K910877
*     Begin of ADD:ERP-6613:WROY:14-Feb-2018:ED2K910877
      lst_serial_version-serial_version_id_type = '01'.
*     End   of ADD:ERP-6613:WROY:14-Feb-2018:ED2K910877
      lst_serial_version-serial_version_id_value = lw_final-matnr.

      lst_serial_version-serial_work_id_type = '01'.
      lst_serial_version-serial_work_id_type_name = 'Journal Code'(o16).
      lst_serial_version-serial_work_id_value = lw_final-extwg.

      lst_serial_version-serial_work_title_type = '09'.
      lst_serial_version-serial_work_title_text = lw_final-title.

*-----Get Country of dispatch
      READ TABLE li_marc INTO lw_marc WITH KEY matnr = lw_final-matnr.
      IF sy-subrc = 0.
*-----Get Imprint
        READ TABLE li_t005t INTO lw_t005t WITH KEY land1 = lw_marc-herkl.
        IF sy-subrc = 0.
          lst_serial_version-serial_work_imprint_name = lw_t005t-landx50.
        ENDIF.
      ENDIF.

      IF  lw_final-mediatype = c_media_di.
        IF NOT lw_final-ismsubtitle3 IS INITIAL.
          lst_serial_version-serial_work_website_role = '04'.
          lst_serial_version-serial_work_website_desc = 'Journal Home Page'(o17).
          lst_serial_version-serial_work_website_link = lw_final-ismsubtitle3.
        ENDIF.
      ENDIF.

      CASE lw_final-mediatype.
        WHEN c_media_ph.
          lst_serial_version-serial_version_form = 'JB'.
        WHEN c_media_di.
          lst_serial_version-serial_version_form = 'JD'.
        WHEN c_media_mm.
          lst_serial_version-serial_version_form = 'JB'.
        WHEN OTHERS.
          lst_serial_version-serial_version_form = ' '.
      ENDCASE.

      <lst_edidd4>-segnum = lv_c_segnum.
      <lst_edidd4>-segnam = c_serial_version.
      <lst_edidd4>-hlevel = 3.
      <lst_edidd4>-psgnum = 2.
      <lst_edidd4>-sdata  = lst_serial_version.
      CLEAR : lst_serial_version.

*-----Populate Segment Z1PDM_ONIX_VERSION_SCOPE
      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd5>).
      lv_c_segnum = lv_c_segnum + 1.
*      lv_subs_prod_id = lv_subs_prod.

      CONCATENATE p_prsdt+0(4) 'Calendar Year Prices'(o18) INTO lv_text SEPARATED BY space.
      lst_version_scope-subscription_period_label = lv_text.
      CLEAR: lv_text.

      REFRESH li_noi_tmp.
      li_noi_tmp[] = li_noi[].
      SORT li_noi_tmp BY med_prod.
      DELETE li_noi_tmp WHERE med_prod NE lw_final-matnr.
      SORT li_noi_tmp BY ismyearnr.
      DELETE li_noi_tmp WHERE ismyearnr NE p_prsdt+0(4).
      IF NOT li_noi_tmp IS INITIAL.
**BOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
**BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
**        SORT li_noi_tmp DESCENDING BY ismnrinyear.
*        SORT li_noi_tmp BY mpg_lfdnr DESCENDING.
**EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*        READ TABLE li_noi_tmp INTO lw_noi INDEX 1.
*        IF sy-subrc = 0.
**BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
**          lst_version_scope-issues_per_year = lw_noi-ismnrinyear+2(2).
*          CLEAR: lv_len, lv_req_len.
*          lv_len = strlen( lw_noi-ismnrinyear ).
*          IF lv_len GT 2.
*            lv_req_len = lv_len - 2.
*          ENDIF.
*          lst_version_scope-issues_per_year = lw_noi-ismnrinyear+lv_req_len(2). "no of issues
**EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
**EOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
        CLEAR lv_issue.
        DESCRIBE TABLE li_noi_tmp LINES lv_issue.
        lst_version_scope-issues_per_year = lv_issue.   "no of issues
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*        ENDIF.
      ENDIF.

      lst_version_scope-online_publishing_role = '05'.
      lst_version_scope-online_publisher_name = 'John Wiley & Sons Ltd.'(o05).
      lst_version_scope-coverage_description_level = '02'.
      lst_version_scope-supplement_inclusion = '02'.
      lst_version_scope-index_inclusion = '04'.


      lst_version_scope-coverage_seq_start_lvl2_unit = 'Issue'(o20).
      lst_version_scope-coverage_seq_start_lvl2_number = '01'.

      IF NOT li_noi_tmp IS INITIAL.
        SORT li_noi_tmp DESCENDING BY ismcopynr.
        READ TABLE li_noi_tmp INTO lw_noi INDEX 1.
        IF sy-subrc = 0.
          lst_version_scope-coverage_seq_start_lvl1_unit = 'Volume'(o19).
          lst_version_scope-coverage_seq_start_lvl1_number = lw_noi-ismcopynr.
        ENDIF.

        SORT li_noi_tmp ASCENDING BY ismnrinyear.
        READ TABLE li_noi_tmp INTO lw_noi INDEX 1.
        IF sy-subrc = 0.
*          lst_version_scope-coverage_seq_start_lvl2_unit = 'Issue'(o20).
*          lst_version_scope-coverage_seq_start_lvl2_number = lw_noi-ismnrinyear+2(2).
          lst_version_scope-coverage_seq_start_date_format = '01'.
          lst_version_scope-coverage_seq_start_date = lw_noi-ismpubldate+0(6).
        ENDIF.

        SORT li_noi_tmp DESCENDING BY ismcopynr.
        READ TABLE li_noi_tmp INTO lw_noi INDEX 1.
        IF sy-subrc = 0.
          lst_version_scope-coverage_seq_end_lvl1_unit = 'Volume'(o19).
          lst_version_scope-coverage_seq_end_lvl1_number = lw_noi-ismcopynr.
        ENDIF.
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*        SORT li_noi_tmp DESCENDING BY ismnrinyear.
        SORT li_noi_tmp BY mpg_lfdnr DESCENDING.
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
        READ TABLE li_noi_tmp INTO lw_noi INDEX 1.
        IF sy-subrc = 0.
          lst_version_scope-coverage_seq_end_lvl2_unit = 'Issue'(o20).
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*          lst_version_scope-coverage_seq_end_lvl2_number = lw_noi-ismnrinyear+2(2).
*          CLEAR: lv_len, lv_req_len.
*          lv_len = strlen( lw_noi-ismnrinyear ).
*          IF lv_len GT 2.
*            lv_req_len = lv_len - 2.
*          ENDIF.
          CLEAR lv_issue.
          DESCRIBE TABLE li_noi_tmp LINES lv_issue.
          lst_version_scope-coverage_seq_end_lvl2_number = lv_issue.
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
          lst_version_scope-coverage_seq_end_date_format = '01'.
          lst_version_scope-coverage_seq_end_date = lw_noi-ismpubldate+0(6).
        ENDIF.
      ENDIF.

      <lst_edidd5>-segnum = lv_c_segnum.
      <lst_edidd5>-segnam = c_version_scope.
      <lst_edidd5>-hlevel = 4.
      <lst_edidd5>-psgnum = 3.
      <lst_edidd5>-sdata  = lst_version_scope.
      CLEAR : lst_version_scope.

*-----Populate Z1PDM_ONIX_CATALOG_PRICE
      li_final2[] = i_final[].
      "delete unwanted materials.
      SORT li_final2[] BY matnr.
      DELETE li_final2 WHERE matnr NE lw_final-matnr.

*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
      DATA(li_final_ddp) = li_final2[].
      CLEAR lw_final2.
      READ TABLE li_final2 INTO lw_final2 WITH KEY kschl = c_ct_zlpr
                                                   fzddp = abap_true.
      IF sy-subrc = 0.
        LOOP AT li_final_ddp INTO lw_final2 WHERE fzddp = abap_true.
          IF lw_final2-kschl = c_ct_zlpr.
            CLEAR lw_final2-fzddp.
            APPEND lw_final2 TO li_final2.
          ENDIF.
        ENDLOOP.
      ENDIF.
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>

*      SORT li_final2 BY seqpltyp ASCENDING
*                        knuma_ag DESCENDING.

*BOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*Sorting order change based on the material description
*      SORT li_final2 BY extwg seqmedia kdgrp seqpltyp ASCENDING
*                        klfn1 DESCENDING.
      SORT li_final2 BY maktx seqmedia kdgrp seqpltyp ASCENDING
                        klfn1 DESCENDING.
*EOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*-----Check if this is an opt-in title.
      READ TABLE li_optin INTO lw_optin WITH KEY matnr = lw_final-matnr
                                                 ismpubltype = 'OI'.

      IF sy-subrc = 0.
        lv_c_segnum = lv_c_segnum + 1.
        lst_catalog_price-total_price_currency_code = 'USD'.
        lst_catalog_price-price_note = 'Opt in title'.

        CLEAR : lst_edidd.
        lst_edidd-segnum = lv_c_segnum.
        lst_edidd-segnam = c_catalog_price.
        lst_edidd-hlevel = 3.
        lst_edidd-psgnum = 2.
        lst_edidd-sdata  = lst_catalog_price.
        APPEND lst_edidd TO li_edidd.
        CLEAR : lst_catalog_price, lst_edidd.

        lv_c_segnum = lv_c_segnum + 1.
        lst_total_price1-total_price_component_type = '01'.
        lst_total_price1-total_price_component_desc = 'Total Price (inc. Discount/Postage)'(o22).
        lst_total_price1-total_price_amount = '0.00'.

        lst_edidd_tp1-segnum = lv_c_segnum.
        lst_edidd_tp1-segnam = c_total_price.
        lst_edidd_tp1-hlevel = 4.
        lst_edidd_tp1-psgnum = 3.
        lst_edidd_tp1-sdata  = lst_total_price1.
        APPEND lst_edidd_tp1 TO li_edidd.
        CLEAR : lst_edidd_tp1, lst_total_price1.

      ELSE.
*Begin of Add-Anirban-07.27.2017-ED2K907564-Defect 3643
        CLEAR: lv_counter.
*End of Add-Anirban-07.27.2017-ED2K907564-Defect 3643
        LOOP AT li_final2 INTO lw_final2.
          lv_tabix_scale = sy-tabix - 1.
          APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd6>).
          lv_c_segnum = lv_c_segnum + 1.
*        lv_subs_prod_id = lv_subs_prod.

          IF NOT lw_final2-kstbm IS INITIAL. "Do no populate if scale qty is0.
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*            lv_counter = lv_counter + 1. "Counter for scale
            lv_counter = lw_final2-klfn1. "Counter for scale
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
            lst_catalog_price-price_tier_unit = '03'.
            lst_catalog_price-price_tier_from_value = lw_final2-kstbm.
            IF lv_counter = 3.  "1.  "+<HIPATEL> <INC0215495> <ED1K908707>
              lst_catalog_price-price_tier_to_value = lc_kstbm. "9999999
            ELSE.
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*              READ TABLE li_final2 INTO lw_final3 INDEX lv_tabix_scale.
*Reading High level of the scale for DDP and without DDP
              DATA(lv_klfn1) = lw_final2-klfn1 + 1.
              CLEAR lw_final3.
              READ TABLE li_final2 INTO lw_final3 WITH KEY kappl = lw_final2-kappl
                                                           kschl = lw_final2-kschl
                                                           pltyp = lw_final2-pltyp
                                                           pltyd = lw_final2-pltyd
                                                           kdgrp = lw_final2-kdgrp
                                                           matnr = lw_final2-matnr
                                                           knumh = lw_final2-knumh
                                                           mtart = lw_final2-mtart
                                                           extwg = lw_final2-extwg
                                                           mediatype = lw_final2-mediatype
                                                           klfn1 = lv_klfn1.
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
              IF sy-subrc = 0.
                lv_kstbm = lw_final3-kstbm - 1.
                lst_catalog_price-price_tier_to_value = lv_kstbm.
*               Begin of ADD:ERP-6043:WROY:18-Jan-2018:ED2K910364
*               Place the following minus sign in front of the number
                CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
                  CHANGING
                    value = lst_catalog_price-price_tier_to_value.
*               End   of ADD:ERP-6043:WROY:18-Jan-2018:ED2K910364
                CLEAR : lv_kstbm.
              ENDIF.
            ENDIF.
*BOD <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*            IF lv_counter EQ 3.
*              CLEAR: lv_counter.
*            ENDIF.
*BOD <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
          ENDIF.
          lst_catalog_price-total_price_currency_code = lw_final2-konwa.
          lst_catalog_price-price_note = lw_final2-pltyd.
*- BOC SGURIJALA 10162018 ED1K908731
          " If Scale-To value is not populated, then populate End value
          IF lst_catalog_price-price_tier_unit IS NOT INITIAL AND
             lst_catalog_price-price_tier_to_value IS INITIAL.
            lst_catalog_price-price_tier_to_value = lc_kstbm.
          ENDIF.
*- BOC SGURIJALA 10162018 ED1K908731
          <lst_edidd6>-segnum = lv_c_segnum.
          <lst_edidd6>-segnam = c_catalog_price.
          <lst_edidd6>-hlevel = 3.
          <lst_edidd6>-psgnum = 2.
          <lst_edidd6>-sdata  = lst_catalog_price.
          CLEAR : lst_catalog_price.

*-----Populate z1pdm_onix_price_qualf
          "Price qualifier 1
          IF lw_final2-kdgrp = '03'.
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_price_qualf1-price_qualifier_type = '04'.
            lst_price_qualf1-price_qualifier_value = '28'.

            lst_edidd_pq1-segnum = lv_c_segnum.
            lst_edidd_pq1-segnam = c_price_qualf.
            lst_edidd_pq1-hlevel = 4.
            lst_edidd_pq1-psgnum = 3.
            lst_edidd_pq1-sdata  = lst_price_qualf1.
            APPEND lst_edidd_pq1 TO li_edidd.
          ENDIF.

          "Price qualifier 2 - Country
*        IF lw_final2-fzddp = abap_true.
          lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

          lst_price_qualf2-price_qualifier_type = '05'.
          lst_price_qualf2-price_qualifier_value = lw_final2-country.

          lst_edidd_pq2-segnum = lv_c_segnum.
          lst_edidd_pq2-segnam = c_price_qualf.
          lst_edidd_pq2-hlevel = 4.
          lst_edidd_pq2-psgnum = 3.
          lst_edidd_pq2-sdata  = lst_price_qualf2.
          APPEND lst_edidd_pq2 TO li_edidd.
*        ENDIF.

          "Price qualifier 3
          IF NOT ( lw_final2-kstbm IS INITIAL AND lw_final-kbetr IS INITIAL ).
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_price_qualf3-price_qualifier_type = '16'.
            lst_price_qualf3-price_qualifier_value = 'Structured description'(o21).

            lst_edidd_pq3-segnum = lv_c_segnum.
            lst_edidd_pq3-segnam = c_price_qualf.
            lst_edidd_pq3-hlevel = 4.
            lst_edidd_pq3-psgnum = 3.
            lst_edidd_pq3-sdata  = lst_price_qualf3.
            APPEND lst_edidd_pq3 TO li_edidd.
          ENDIF.

          "Price qualifier 5
          lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

          lst_price_qualf5-price_qualifier_type = '04'.
          lst_price_qualf5-price_qualifier_value = '29'.

          lst_edidd_pq5-segnum = lv_c_segnum.
          lst_edidd_pq5-segnam = c_price_qualf.
          lst_edidd_pq5-hlevel = 4.
          lst_edidd_pq5-psgnum = 3.
          lst_edidd_pq5-sdata  = lst_price_qualf5.
          APPEND lst_edidd_pq5 TO li_edidd.

          "Price qualifier 4
          IF lw_final2-fzddp = abap_true.
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_price_qualf4-price_qualifier_type = '08'.
            lst_price_qualf4-price_qualifier_value = '07'.

            lst_edidd_pq4-segnum = lv_c_segnum.
            lst_edidd_pq4-segnam = c_price_qualf.
            lst_edidd_pq4-hlevel = 4.
            lst_edidd_pq4-psgnum = 3.
            lst_edidd_pq4-sdata  = lst_price_qualf4.
            APPEND lst_edidd_pq4 TO li_edidd.
          ENDIF.

*-----Populate segment z1pdm_onix_total_price for 08 / 07
          "Total price 1
*          IF ( lst_price_qualf4-price_qualifier_type = '08' AND
*               lst_price_qualf4-price_qualifier_value = '07' ).
          IF lw_final2-fzddp = abap_true.
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_total_price1-total_price_component_type = '01'.
            lst_total_price1-total_price_component_desc = 'Total Price (inc. Discount/Postage)'(o22).
            lst_total_price1-total_price_amount = lw_final2-npadp.

            lst_edidd_tp1-segnum = lv_c_segnum.
            lst_edidd_tp1-segnam = c_total_price.
            lst_edidd_tp1-hlevel = 4.
            lst_edidd_tp1-psgnum = 3.
            lst_edidd_tp1-sdata  = lst_total_price1.
            APPEND lst_edidd_tp1 TO li_edidd.

            "Total price 3
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_total_price3-total_price_component_type = '02'.
            lst_total_price3-total_price_component_desc = 'Package Base Price'(o23).
            lst_total_price3-total_price_amount = lw_final2-npapp.

            lst_edidd_tp3-segnum = lv_c_segnum.
            lst_edidd_tp3-segnam = c_total_price.
            lst_edidd_tp3-hlevel = 4.
            lst_edidd_tp3-psgnum = 3.
            lst_edidd_tp3-sdata  = lst_total_price3.
            APPEND lst_edidd_tp3 TO li_edidd.

            "Total price 5
            lv_c_segnum = lv_c_segnum + 1.
*        lv_subs_prod_id = lv_subs_prod.
            lst_total_price5-total_price_component_type = '06'.
            lst_total_price5-total_price_component_desc = 'Agent Discount'(o24).
            IF lw_final2-fzagd = abap_true.
              lst_total_price5-total_price_amount = lw_final2-pzagd.
            ELSE.
              lst_total_price5-total_price_amount = '0'.
            ENDIF.

            lst_edidd_tp5-segnum = lv_c_segnum.
            lst_edidd_tp5-segnam = c_total_price.
            lst_edidd_tp5-hlevel = 4.
            lst_edidd_tp5-psgnum = 3.
            lst_edidd_tp5-sdata  = lst_total_price5.
            APPEND lst_edidd_tp5 TO li_edidd.
          ENDIF.
**/////////////////////////////////////////////////////////
*        "Price qualifier 5
*        lv_c_segnum = lv_c_segnum + 1.
**          lv_subs_prod_id = lv_subs_prod.
*
*        lst_price_qualf5-price_qualifier_type = '04'.
*        lst_price_qualf5-price_qualifier_value = '29'.
*
*        lst_edidd_pq5-segnum = lv_c_segnum.
*        lst_edidd_pq5-segnam = c_price_qualf.
*        lst_edidd_pq5-hlevel = 4.
*        lst_edidd_pq5-psgnum = 3.
*        lst_edidd_pq5-sdata  = lst_price_qualf5.
*        APPEND lst_edidd_pq5 TO li_edidd.
*
*-----Populate segment z1pdm_onix_total_price for 04 / 29
*          IF ( lst_price_qualf5-price_qualifier_type = '04' AND
*               lst_price_qualf5-price_qualifier_value = '29' ).

          IF lw_final2-fzddp NE abap_true.
            "Total price 2
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

            lst_total_price2-total_price_component_type = '01'.
            lst_total_price2-total_price_component_desc = 'Total Price (inc. Discount/Postage)'(o22).
            lst_total_price2-total_price_amount = lw_final2-npadd.

            lst_edidd_tp2-segnum = lv_c_segnum.
            lst_edidd_tp2-segnam = c_total_price.
            lst_edidd_tp2-hlevel = 4.
            lst_edidd_tp2-psgnum = 3.
            lst_edidd_tp2-sdata  = lst_total_price2.
            APPEND lst_edidd_tp2 TO li_edidd.

            "Total price 4
            lv_c_segnum = lv_c_segnum + 1.
*          lv_subs_prod_id = lv_subs_prod.

*BOC <HIPATEL> <INC0215495> <ED1K908752> <10/17/2018>
*Component position shoud be 02
*            lst_total_price4-total_price_component_type = '01'.
            lst_total_price4-total_price_component_type = '02'.
*EOC <HIPATEL> <INC0215495> <ED1K908752> <10/17/2018>
            lst_total_price4-total_price_component_desc = 'Package Base Price'(o23).
            lst_total_price4-total_price_amount = lw_final2-kbetr.

            lst_edidd_tp4-segnum = lv_c_segnum.
            lst_edidd_tp4-segnam = c_total_price.
            lst_edidd_tp4-hlevel = 4.
            lst_edidd_tp4-psgnum = 3.
            lst_edidd_tp4-sdata  = lst_total_price4.
            APPEND lst_edidd_tp4 TO li_edidd.

            "Total price 5
            lv_c_segnum = lv_c_segnum + 1.
*        lv_subs_prod_id = lv_subs_prod.
            lst_total_price5-total_price_component_type = '06'.
            lst_total_price5-total_price_component_desc = 'Agent Discount'(o24).
            IF lw_final2-fzagd = abap_true.
              lst_total_price5-total_price_amount = lw_final2-pzagd.
            ELSE.
              lst_total_price5-total_price_amount = '0'.
            ENDIF.

            lst_edidd_tp5-segnum = lv_c_segnum.
            lst_edidd_tp5-segnam = c_total_price.
            lst_edidd_tp5-hlevel = 4.
            lst_edidd_tp5-psgnum = 3.
            lst_edidd_tp5-sdata  = lst_total_price5.
            APPEND lst_edidd_tp5 TO li_edidd.
          ENDIF.

          CLEAR:  lst_edidd_pq1, lst_edidd_pq2, lst_edidd_pq3, lst_edidd_pq4, lst_edidd_pq5,
                  lst_total_price1, lst_total_price2, lst_total_price3, lst_total_price4, lst_total_price5,
                  lst_price_qualf1, lst_price_qualf2, lst_price_qualf3, lst_price_qualf4, lst_price_qualf5,
                  lst_edidd_tp1, lst_edidd_tp2, lst_edidd_tp3, lst_edidd_tp4, lst_edidd_tp5,
                  lv_tabix_scale.
        ENDLOOP.
      ENDIF.
      CLEAR: lv_tabix_scale.

      IF lv_idoc = lv_max_no_of_idoc.

*-----Populate Z1PDM_ONIX_TRAILER
        lv_c_segnum = lv_c_segnum + 1.
*        lv_subs_prod_id = lv_subs_prod.

        lst_onix_trailer-total_idoc_no = lv_total_idoc_no.
        lst_onix_trailer-current_idoc_no = lv_current_idoc_no.
        lst_onix_trailer-batch_number = lv_guid.

        lst_trailer-segnum = lv_c_segnum.
        lst_trailer-segnam = c_trailer.
        lst_trailer-hlevel = 1.
        lst_trailer-psgnum = 0.
        lst_trailer-sdata  = lst_onix_trailer.
        APPEND lst_trailer TO li_edidd.

* Call functipon module to send idoc
        CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
          EXPORTING
            master_idoc_control            = lst_edidc                "IDOC Control Record
          TABLES
            communication_idoc_control     = li_idoc_cnt              "IDOC Control Record (Comm)
            master_idoc_data               = li_edidd                 "IDOC Data Record
          EXCEPTIONS
            error_in_idoc_control          = 1
            error_writing_idoc_status      = 2
            error_in_idoc_data             = 3
            sending_logical_system_unknown = 4
            OTHERS                         = 5.
        IF sy-subrc EQ 0.
          COMMIT WORK.
          READ TABLE li_idoc_cnt ASSIGNING FIELD-SYMBOL(<lst_idoc_cnt>)
          INDEX lv_current_idoc_no.
          IF sy-subrc EQ 0.
*     IDOC &1 was created
            MESSAGE s171(/spe/id_handling) WITH <lst_idoc_cnt>-docnum.
          ENDIF.
        ELSE.
          MESSAGE ID sy-msgid
                TYPE c_msgty_i
              NUMBER sy-msgno
                WITH sy-msgv1
                     sy-msgv2
                     sy-msgv3
                     sy-msgv4.
          LEAVE LIST-PROCESSING.
        ENDIF.
        REFRESH: li_edidd.
        CLEAR: lv_idoc, lv_c_segnum.
      ENDIF.
    ENDLOOP. "LOOP AT li_final INTO lw_final.

*-----Trigger idoc for last set of records.
    IF NOT li_edidd IS INITIAL.
*-----Populate Z1PDM_ONIX_TRAILER
      lv_c_segnum = lv_c_segnum + 1.
*      lv_subs_prod_id = lv_subs_prod.
      lst_onix_trailer-total_idoc_no = lv_total_idoc_no.
      lst_onix_trailer-current_idoc_no = lv_current_idoc_no.
      lst_onix_trailer-batch_number = lv_guid.

      lst_trailer-segnum = lv_c_segnum.
      lst_trailer-segnam = c_trailer.
      lst_trailer-hlevel = 1.
      lst_trailer-psgnum = 0.
      lst_trailer-sdata  = lst_onix_trailer.
      APPEND lst_trailer TO li_edidd.

* Call functipon module to send idoc
      CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
        EXPORTING
          master_idoc_control            = lst_edidc                "IDOC Control Record
        TABLES
          communication_idoc_control     = li_idoc_cnt              "IDOC Control Record (Comm)
          master_idoc_data               = li_edidd                 "IDOC Data Record
        EXCEPTIONS
          error_in_idoc_control          = 1
          error_writing_idoc_status      = 2
          error_in_idoc_data             = 3
          sending_logical_system_unknown = 4
          OTHERS                         = 5.
      IF sy-subrc EQ 0.
        COMMIT WORK.
        READ TABLE li_idoc_cnt ASSIGNING FIELD-SYMBOL(<lst_idoc_cnt1>)
        INDEX lv_current_idoc_no.
        IF sy-subrc EQ 0.
*     IDOC &1 was created
          MESSAGE s171(/spe/id_handling) WITH <lst_idoc_cnt1>-docnum.
        ENDIF.
      ELSE.
        MESSAGE ID sy-msgid
              TYPE c_msgty_i
            NUMBER sy-msgno
              WITH sy-msgv1
                   sy-msgv2
                   sy-msgv3
                   sy-msgv4.
        LEAVE LIST-PROCESSING.
      ENDIF.
      REFRESH: li_edidd.
      CLEAR: lv_idoc, lv_c_segnum.
*Begin of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
      MESSAGE i228(zqtc_r2). "Processing completed
*End of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_DATA_CSV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_send_data_csv .
  TYPES : BEGIN OF lty_issn,
            matnr      TYPE matnr,
            idcodetype TYPE ismidcodetype,
            identcode  TYPE ismidentcode,
          END   OF lty_issn,

          BEGIN OF lty_noi,
            med_prod    TYPE ismrefmdprod,
*BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
            mpg_lfdnr   TYPE mpg_lfdnr,     "Sequence number of media issue
*EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
            ismcopynr   TYPE ismheftnummer,
            ismnrinyear TYPE ismnrimjahr,
            ismyearnr   TYPE ismjahrgang,
          END   OF lty_noi,

          BEGIN OF lty_marc,
            matnr TYPE matnr,
            werks TYPE werks_d,
            herkl TYPE herkl,
          END   OF lty_marc,

          BEGIN OF lty_t005t,
            spras   TYPE spras,
            land1   TYPE land1,
            landx   TYPE landx,
            landx50 TYPE landx50,
          END   OF lty_t005t.

  DATA : li_temp    TYPE STANDARD TABLE OF ty_final,
         li_issn    TYPE STANDARD TABLE OF lty_issn,
         li_noi     TYPE STANDARD TABLE OF lty_noi,
         li_noi_tmp TYPE STANDARD TABLE OF lty_noi,
         li_marc    TYPE STANDARD TABLE OF lty_marc,
*         li_marc_tmp TYPE STANDARD TABLE OF lty_marc,
         li_t005t   TYPE STANDARD TABLE OF lty_t005t,
         li_t189t   TYPE STANDARD TABLE OF t189t,

         lw_issn    TYPE lty_issn,
         lw_noi     TYPE lty_noi,
         lw_noi_tmp TYPE lty_noi,
         lw_csv     TYPE ty_final_csv,
*         lw_temp  TYPE ty_final,
         lw_marc    TYPE lty_marc,
         lw_t005t   TYPE lty_t005t,
         lw_t189t   TYPE t189t,

         lv_count   TYPE i,
         lv_count1  TYPE i,
         lv_txt     TYPE matnr.
*         lv_knumh TYPE knumh.
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*-----Get volume/issues from Print
  DATA : lv_issue  TYPE string. "ismnrimjahr,
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

  CONSTANTS : lc_zssn TYPE ismidcodetype VALUE 'ZSSN',
              lc_ins  TYPE char12        VALUE 'INS'. "+ by <HIPATEL> <INC0212602> <ED1K908594>

  REFRESH : li_temp, li_issn, li_noi, li_marc, li_t005t, i_csv, li_noi_tmp.
  CLEAR: lw_issn, lw_noi, lw_csv, lw_marc, lv_count, lw_noi_tmp, lv_count.

  IF s_email IS INITIAL.
*   E-mail recipient missing
    MESSAGE i042(edocument).
    RETURN.
  ENDIF.

  li_temp[] = i_final[].

*-----Get all ISSN
  SORT li_temp BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_temp COMPARING matnr.
  IF NOT li_temp IS INITIAL.
    SELECT matnr idcodetype identcode FROM jptidcdassign INTO TABLE li_issn
      FOR ALL ENTRIES IN li_temp
      WHERE matnr = li_temp-matnr
      AND idcodetype = lc_zssn. "ZSSN
    IF sy-subrc = 0.
      SORT li_issn BY matnr idcodetype.
    ENDIF.

*-----Get no of issues
    SELECT med_prod
           mpg_lfdnr "+<HIPATEL> <INC0215495> <ED1K908707>
           ismcopynr
           ismnrinyear
           ismyearnr
      FROM jptmg0
      INTO TABLE li_noi
      FOR ALL ENTRIES IN li_temp
      WHERE med_prod = li_temp-matnr.
    IF sy-subrc = 0.
      SORT li_noi BY ismyearnr.
      DELETE li_noi WHERE ismyearnr NE p_prsdt+0(4).
    ENDIF.

**-----Get country of origin
*    SELECT matnr werks herkl FROM marc INTO TABLE li_marc
*    FOR ALL ENTRIES IN li_temp
*    WHERE matnr = li_temp-matnr.
*    IF sy-subrc = 0.
*      SORT li_marc BY matnr.
*      DELETE ADJACENT DUPLICATES FROM li_marc COMPARING matnr.
*      "Assuming HERKL will be always same for all plants
*      li_marc_tmp[] = li_marc[].
*      SORT li_marc_tmp BY herkl.
*      DELETE li_marc WHERE herkl IS INITIAL.
*      DELETE ADJACENT DUPLICATES FROM li_marc COMPARING matnr herkl.
**-----Get HERK Description
*      SELECT spras land1 landx landx50 FROM t005t INTO TABLE li_t005t
*        FOR ALL ENTRIES IN li_marc WHERE spras = sy-langu
*                                   AND   land1 = li_marc-herkl.
*    ENDIF.

*-----Get country of origin
    SELECT matnr werks herkl FROM marc INTO TABLE li_marc
    FOR ALL ENTRIES IN li_temp
    WHERE matnr = li_temp-matnr.
    IF sy-subrc = 0.
      SORT li_marc BY herkl.
      DELETE li_marc WHERE herkl IS INITIAL.
      SORT li_marc BY matnr herkl.
      DELETE ADJACENT DUPLICATES FROM li_marc COMPARING matnr herkl.

*-----Get HERKL Description
      SELECT spras land1 landx landx50 FROM t005t INTO TABLE li_t005t
        FOR ALL ENTRIES IN li_marc WHERE spras = sy-langu
                                   AND   land1 = li_marc-herkl.
    ENDIF.


*-----Get all price region text
*    refresh li_temp.
*    li_temp[] = i_final[].
*    sort li_temp by pltyp.
*    DELETE ADJACENT DUPLICATES FROM li_temp COMPARING pltyp.
    SELECT * FROM t189t INTO TABLE li_t189t.
*      for all entries in li_temp
*      where PLTYP = li_temp-PLTYP.
  ENDIF.
  REFRESH li_temp[].
*  SORT i_final BY knumh kopos klfn1.
  LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_final>).
*-----Condition no
    lw_csv-knumh = <lst_final>-knumh.
*-----Multi journal package
    IF <lst_final>-mtart = c_mt_zmjl. "ZMJL
      lw_csv-mtart = 'Y'.
    ELSE.
      lw_csv-mtart = ' '.
    ENDIF.
*-----Product code
    CLEAR: lv_txt.
    CASE <lst_final>-mediatype.
      WHEN c_media_ph. "PH
        CONCATENATE <lst_final>-extwg c_media_p INTO lv_txt SEPARATED BY c_slash.
        CONCATENATE p_prsdt+2(2) lv_txt INTO lv_txt SEPARATED BY space.
      WHEN c_media_di. "DI
        CONCATENATE <lst_final>-extwg c_media_d INTO lv_txt SEPARATED BY c_slash.
        CONCATENATE p_prsdt+2(2) lv_txt INTO lv_txt SEPARATED BY space.
      WHEN c_media_mm. "MM.
        CONCATENATE <lst_final>-extwg c_media_c INTO lv_txt SEPARATED BY c_slash.
        CONCATENATE p_prsdt+2(2) lv_txt INTO lv_txt SEPARATED BY space.
    ENDCASE.

    lw_csv-matnr = lv_txt.
    CLEAR: lv_txt.
*-----Package
    lw_csv-packg = <lst_final>-matnr.
*-----Get ISSN
    READ TABLE li_issn INTO lw_issn WITH KEY matnr      = <lst_final>-matnr
                                             idcodetype = lc_zssn
                                             BINARY SEARCH.
    IF sy-subrc = 0.
      lw_csv-identcode = lw_issn-identcode.
    ENDIF.
*-----Get Country of dispatch
    READ TABLE li_marc INTO lw_marc WITH KEY matnr = <lst_final>-matnr.
    IF sy-subrc = 0.
      lw_csv-codis   = lw_marc-herkl.
*-----Get Imprint
      READ TABLE li_t005t INTO lw_t005t WITH KEY land1 = lw_marc-herkl.
      IF sy-subrc = 0.
        lw_csv-landx50 = lw_t005t-landx50.
      ENDIF.
    ENDIF.
*-----Journal
    lw_csv-maktx = <lst_final>-title. "Journal
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*Journal Alpha sections should being with the first letter of Journal Description
    lw_csv-alpha_sep = <lst_final>-alpha_sep.
    lw_csv-maktx_sub = <lst_final>-maktx_sub.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*-----Package date from
    lw_csv-datab = <lst_final>-datab. "Package date to
*-----Package date to
    lw_csv-datbi = <lst_final>-datbi. "Package date from

    REFRESH li_noi_tmp.
    CLEAR: lw_noi_tmp.
    li_noi_tmp[] = li_noi[].

*-----Populate volume from and volume to. and no of copies
    IF NOT li_noi_tmp IS INITIAL.
      SORT li_noi_tmp BY med_prod.
      DELETE li_noi_tmp WHERE med_prod NE <lst_final>-matnr.
      DELETE li_noi_tmp WHERE ismcopynr IS INITIAL.

      SORT li_noi_tmp BY ismcopynr.
      READ TABLE li_noi_tmp INTO lw_noi_tmp INDEX 1.
      lw_csv-ismcopynf = lw_noi_tmp-ismcopynr.    "Volume from
      CLEAR : lw_noi_tmp.

      SORT li_noi_tmp DESCENDING BY ismcopynr.
      READ TABLE li_noi_tmp INTO lw_noi_tmp INDEX 1.
      lw_csv-ismcopynt = lw_noi_tmp-ismcopynr.    "Volume to
      CLEAR: lw_noi_tmp.
    ENDIF.

    REFRESH li_noi_tmp.
    CLEAR: lw_noi_tmp.
    li_noi_tmp[] = li_noi[].
    IF NOT li_noi_tmp IS INITIAL.
      SORT li_noi_tmp BY med_prod.
      DELETE li_noi_tmp WHERE med_prod NE <lst_final>-matnr.
**BOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
**BOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*      SORT li_noi_tmp DESCENDING BY ismnrinyear.
*      SORT li_noi_tmp BY mpg_lfdnr DESCENDING.
**EOC <HIPATEL> <INC0215495> <ED1K908707> <10/15/2018>
*      READ TABLE li_noi_tmp INTO lw_noi_tmp INDEX 1.
*      lw_csv-ismnrinyear = lw_noi_tmp-ismnrinyear. "no of issues
*      CLEAR: lw_noi_tmp.
**EOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
**BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
      IF NOT li_noi_tmp[] IS INITIAL.
        CLEAR lv_issue.
        DESCRIBE TABLE li_noi_tmp LINES lv_issue.
        lw_csv-ismnrinyear = lv_issue.
      ENDIF.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
    ENDIF.
    REFRESH li_noi_tmp.

**-----Populate no of issues
*    READ TABLE li_noi INTO lw_noi WITH KEY med_prod  = <lst_final>-matnr
*                                           ismyearnr = p_prsdt+0(4).
*    IF sy-subrc = 0.
*      lw_csv-ismnrinyear = lw_noi-ismnrinyear. "no of issues
*    ENDIF.

*-----Payment rate desc
    IF <lst_final>-scale IS INITIAL.
      lw_csv-prdsc = text-l29. "INS
    ELSEIF <lst_final>-scale = c_small. "'S'.
      lw_csv-prdsc = text-l26. "'INS-FTES'.
    ELSEIF <lst_final>-scale = c_medium. "'M'.
      lw_csv-prdsc = text-l27. "'INS-FTEM'.
    ELSEIF <lst_final>-scale = c_large. "'L'.
      lw_csv-prdsc = text-l28.  "'INS-FTEL'.
    ENDIF.

*-----Print mediatype
    CASE <lst_final>-mediatype.
      WHEN c_media_di. "DI
        lw_csv-mediatype = text-l18. "'Online'.
      WHEN c_media_mm. "'MM'.
        lw_csv-mediatype = text-l19. "'Print and Online'.
      WHEN c_media_ph. "'PH'.
        lw_csv-mediatype = text-l25. "c_print.
    ENDCASE.
*-----Currency
    lw_csv-konwa = <lst_final>-konwa. "Currency
*-----Standard price
    lw_csv-kbetr = <lst_final>-kbetr.
*    IF ( ( <lst_final>-npadp NE <lst_final>-kbetr ) AND ( lw_csv-mediatype = 'PH' ) ).
*      get correct logic
*    ELSE.
*      lw_csv-kbetr = <lst_final>-kbetr.
*    ENDIF.
*-----Calculate agent price
    IF <lst_final>-fzagd EQ abap_true.
      lw_csv-npadd = <lst_final>-npadd.
    ELSE.
      lw_csv-npadd = <lst_final>-kbetr.
    ENDIF.
*    IF <lst_final>-npadp = <lst_final>-kbetr.
*      lw_csv-npadd = <lst_final>-npadd.
*    ELSE.
*      lw_csv-npadd = <lst_final>-npadd.
*    ENDIF.

*-----Price region
    READ TABLE li_t189t INTO lw_t189t WITH KEY pltyp = <lst_final>-pltyp
                                               spras = sy-langu.
    IF sy-subrc = 0.
      lw_csv-pltyp = lw_t189t-ptext. "Price region
    ENDIF.
*-----Countries applicable
    "Need logic to populate
    lw_csv-country = <lst_final>-country.

    lw_csv-seqmedia = <lst_final>-seqmedia.
    lw_csv-seqpltyp = <lst_final>-seqpltyp.

    lw_csv-ltype = c_id_c. "C
    lw_csv-extwg = <lst_final>-extwg.
    lw_csv-klfn1 = <lst_final>-klfn1.

    APPEND lw_csv TO i_csv.

    IF <lst_final>-fzddp = abap_true. " Do not populate DDP Lines if no deep discounts present
*-----Populate ZDDP in CSV file.
      CLEAR :lw_csv-prdsc, lw_csv-kbetr, lw_csv-npadd.
*-----Payment rate desc for DDP
      IF <lst_final>-scale IS INITIAL.
        lw_csv-prdsc = text-l33. "INS
*BOC <HIPATEL> <INC0212602> <ED1K908594> <10/01/2018>
*If INS-DDP present then don't display INS value
        IF <lst_final>-kschl EQ c_zlps.
          READ TABLE i_csv INTO DATA(lw_csv_tmp) WITH KEY knumh = <lst_final>-knumh
                                                          prdsc = lc_ins
                                                          mediatype = c_print.
          IF sy-subrc = 0.
            DELETE i_csv INDEX sy-tabix.
          ENDIF.
        ENDIF.
*EOC <HIPATEL> <INC0212602> <ED1K908594> <10/01/2018>
      ELSEIF <lst_final>-scale = c_small. "'S'.
        lw_csv-prdsc = text-l30. "'INS-FTES-DDP'.
      ELSEIF <lst_final>-scale = c_medium. "'M'.
        lw_csv-prdsc = text-l31. "'INS-FTEM-DDP'.
      ELSEIF <lst_final>-scale = c_large. "'L'.
        lw_csv-prdsc = text-l32.  "'INS-FTEL-DDP'.
      ENDIF.

*-----Pricing
      lw_csv-ltype = c_id_d. "'D'.
      IF <lst_final>-fzddp EQ abap_true.
        lw_csv-kbetr = <lst_final>-npapp.
      ELSE.
        lw_csv-kbetr = <lst_final>-kbetr.
      ENDIF.
      IF <lst_final>-fzddp EQ abap_true.
        lw_csv-npadd = <lst_final>-npadp.
      ELSE.
        lw_csv-npadd = <lst_final>-npadd.
      ENDIF.
      APPEND lw_csv TO i_csv.
    ENDIF.
    CLEAR: lw_csv.
  ENDLOOP.

*-----format record as per required o/p
  PERFORM f_format_csv_output.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FORMAT_CSV_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_format_csv_output .
  DATA : li_temp     TYPE STANDARD TABLE OF ty_final_csv,
         li_temp1    TYPE STANDARD TABLE OF ty_final_csv,
         li_temp2    TYPE STANDARD TABLE OF ty_final_csv,
         lw_temp     TYPE ty_final_csv,
         lw_temp1    TYPE ty_final_csv,
         lw_temp2    TYPE ty_final_csv,
         lw_blank    TYPE ty_final_csv,
         lw_csv_op   TYPE ty_csv_op,

         lv_xcel_rec TYPE string,
         lv_xcel_att TYPE string.

  REFRESH: li_temp, i_csv_op.
  CLEAR: lw_temp,lw_csv_op, lw_blank.


*  li_temp[] = i_csv[].
*  SORT li_temp BY mtart matnr packg kbetr.
*  IF NOT li_temp IS INITIAL.
*    LOOP AT li_temp INTO lw_temp.
*      lw_temp1-mtart     = lw_temp-mtart.
*      lw_temp1-matnr     = lw_temp-matnr.
*      lw_temp1-packg     = lw_temp-packg.
*      lw_temp1-identcode = lw_temp-identcode.
*      lw_temp1-landx50   = lw_temp-landx50.
*      lw_temp1-maktx     = lw_temp-maktx.
*      lw_temp1-datab     = lw_temp-datab.
*      lw_temp1-datbi     = lw_temp-datbi.
*      lw_temp1-ismcopynf = lw_temp-ismcopynf.
*      lw_temp1-ismcopynt = lw_temp-ismcopynt.
*      lw_temp1-ismnrinyear = lw_temp-ismnrinyear.
*
*      lw_temp2 = lw_temp.
*      AT NEW kbetr.
*        lw_temp1-prdsc = lw_temp2-prdsc.
*        lw_temp1-mediatype = lw_temp2-mediatype.
*        lw_temp1-konwa = lw_temp2-konwa.
*        lw_temp1-kbetr = lw_temp2-kbetr.
*        lw_temp1-npadd = lw_temp2-npadd.
*        lw_temp1-pltyp = lw_temp2-pltyp.
*        lw_temp1-country = lw_temp2-country.
*        lw_temp1-codis = lw_temp2-codis.
*        lw_temp1-knumh = lw_temp2-knumh.
*        lw_temp1-seqmedia = lw_temp2-seqmedia.
*        lw_temp1-seqpltyp = lw_temp2-seqpltyp.
*        APPEND lw_temp1 TO li_temp1.
*        CLEAR: lw_temp1, lw_temp2.
*      ENDAT.
*      APPEND lw_temp1 TO li_temp1.
*    ENDLOOP.
*  ENDIF.

  li_temp1[] = i_csv[].
  REFRESH: li_temp.
  CLEAR: lw_temp, lw_blank, lw_temp2.
*BOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*Sorting order change based on the material description
*  SORT li_temp1 BY extwg ASCENDING
  SORT li_temp1 BY maktx_sub ASCENDING  "+<HIPATEL> <INC0215495> <ED1K908742>
*EOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
                    seqmedia DESCENDING
                    ltype ASCENDING
                    klfn1 DESCENDING
                    seqpltyp ASCENDING.
*-----Adding blank lines.
  IF NOT li_temp1 IS INITIAL.
    DELETE li_temp1 WHERE matnr IS INITIAL.
    LOOP AT li_temp1 INTO lw_temp1.
      IF lw_temp2-matnr NE lw_temp1-matnr.
        IF sy-tabix NE 1.
          APPEND lw_blank TO li_temp2.
          APPEND lw_blank TO li_temp2.
        ENDIF.
      ENDIF.
      lw_temp2 = lw_temp1.

      APPEND lw_temp2 TO li_temp2.
    ENDLOOP.
  ENDIF.

  LOOP AT li_temp2 INTO lw_temp2.
    lw_csv_op-mtart        = lw_temp2-mtart.
    lw_csv_op-matnr       = lw_temp2-matnr.
    lw_csv_op-packg       = lw_temp2-packg.
    lw_csv_op-identcode   = lw_temp2-identcode.
    lw_csv_op-landx50     = lw_temp2-landx50.
*   Begin of ADD:ERP-6557:WROY:09-Feb-2018:ED2K910805
    CONCATENATE '"'
                lw_temp2-maktx
                '"'
           INTO lw_csv_op-maktx.
*   End   of ADD:ERP-6557:WROY:09-Feb-2018:ED2K910805
*   Begin of DEL:ERP-6557:WROY:09-Feb-2018:ED2K910805
*   lw_csv_op-maktx       = lw_temp2-maktx.
*   End   of DEL:ERP-6557:WROY:09-Feb-2018:ED2K910805
    MOVE lw_temp2-datab TO lw_csv_op-datab.
    IF lw_temp2-datab IS INITIAL.
      CLEAR: lw_csv_op-datab.
    ENDIF.
    MOVE lw_temp2-datbi TO lw_csv_op-datbi.
    IF lw_temp2-datbi IS INITIAL.
      CLEAR: lw_csv_op-datbi.
    ENDIF.
    lw_csv_op-ismcopynf   = lw_temp2-ismcopynf.
    lw_csv_op-ismcopynt   = lw_temp2-ismcopynt.
    lw_csv_op-ismnrinyear = lw_temp2-ismnrinyear.
    lw_csv_op-codis       = lw_temp2-codis .
    lw_csv_op-prdsc       = lw_temp2-prdsc.
    lw_csv_op-mediatype   = lw_temp2-mediatype.
    lw_csv_op-konwa       = lw_temp2-konwa.
    IF lw_temp2-kbetr IS INITIAL.
      lw_csv_op-kbetr = ' '.
    ELSE.
      MOVE lw_temp2-kbetr TO lw_csv_op-kbetr.
    ENDIF.
    IF lw_temp2-npadd IS INITIAL.
      lw_csv_op-npadd = ' '.
    ELSE.
      MOVE lw_temp2-npadd TO lw_csv_op-npadd.
    ENDIF.
    lw_csv_op-pltyp       = lw_temp2-pltyp.
    lw_csv_op-country     = lw_temp2-country.
    lw_csv_op-knumh       = lw_temp2-knumh.
    lw_csv_op-ltype       = lw_temp2-ltype.
    lw_csv_op-extwg       = lw_temp2-extwg.
    lw_csv_op-klfn1       = lw_temp2-klfn1.

    APPEND lw_csv_op TO i_csv_op.
  ENDLOOP.

*-----Creating header of CSV file
  CLEAR: lv_xcel_rec.

  lw_csv_op-mtart       = 'Multi Journal Package'(o25).
  lw_csv_op-matnr       = 'Product Code'(o26).
  lw_csv_op-packg       = 'Package'(o27).
  lw_csv_op-identcode   = 'ISSN'(o28).
  lw_csv_op-landx50     = 'Imprint'(o29).
  lw_csv_op-maktx       = 'Journal'(o43).
  lw_csv_op-datab       = 'Package Date From'(o30).
  lw_csv_op-datbi       = 'Package Date To'(o31).
  lw_csv_op-ismcopynf   = 'Volume From'(o32).
  lw_csv_op-ismcopynt   = 'Volume to'(o33).
* Aslam by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
*  lw_csv_op-ismnrinyear = 'No of Copies'(o34).
  lw_csv_op-ismnrinyear = 'No of Issues'(o34).
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
  lw_csv_op-codis       = 'Country of dispatch'(o35).
  lw_csv_op-prdsc       = 'Payment Rate Description'(o36).
  lw_csv_op-mediatype   = 'Media'(o37).
  lw_csv_op-konwa       = 'Currency'(o38).
  lw_csv_op-kbetr       = 'Std Price'(o39).
  lw_csv_op-npadd       = 'Agent Price'(o40).
  lw_csv_op-pltyp       = 'Price Region'(o41).
  lw_csv_op-country     = 'Countries Applicable'(o42).

  CONCATENATE
  lw_csv_op-mtart
  lw_csv_op-matnr
  lw_csv_op-packg
  lw_csv_op-identcode
  lw_csv_op-landx50
  lw_csv_op-maktx
  lw_csv_op-datab
  lw_csv_op-datbi
  lw_csv_op-ismcopynf
  lw_csv_op-ismcopynt
  lw_csv_op-ismnrinyear
  lw_csv_op-codis
  lw_csv_op-prdsc
  lw_csv_op-mediatype
  lw_csv_op-konwa
  lw_csv_op-kbetr
  lw_csv_op-npadd
  lw_csv_op-pltyp
  lw_csv_op-country
  INTO lv_xcel_rec
  SEPARATED BY c_comma. "',' .
  CONCATENATE lv_xcel_rec
              cl_bcs_convert=>gc_crlf
         INTO lv_xcel_rec.
  IF lv_xcel_att IS INITIAL.
    lv_xcel_att = lv_xcel_rec.
  ELSE.
    CONCATENATE lv_xcel_att
                lv_xcel_rec
           INTO lv_xcel_att.
  ENDIF.

*-----Copy the content
  LOOP AT i_csv_op INTO lw_csv_op.
    CLEAR: lv_xcel_rec.
    CONCATENATE
    lw_csv_op-mtart
*Begin of Del-Anirban-08.07.2017- ED2K907768-CR 624
*    lw_csv_op-matnr
*    lw_csv_op-packg
*End of Del-Anirban-08.07.2017- ED2K907768-CR 624
*Begin of Add-Anirban-08.07.2017- ED2K907768-CR 624
    lw_csv_op-packg
    lw_csv_op-matnr
*End of Add-Anirban-08.07.2017- ED2K907768-CR 624
    lw_csv_op-identcode
    lw_csv_op-landx50
    lw_csv_op-maktx
    lw_csv_op-datab
    lw_csv_op-datbi
    lw_csv_op-ismcopynf
    lw_csv_op-ismcopynt
    lw_csv_op-ismnrinyear
    lw_csv_op-codis
    lw_csv_op-prdsc
    lw_csv_op-mediatype
    lw_csv_op-konwa
    lw_csv_op-kbetr
    lw_csv_op-npadd
    lw_csv_op-pltyp
    lw_csv_op-country
    INTO lv_xcel_rec
    SEPARATED BY c_comma."','    "cl_bcs_convert=>gc_tab.
    CONCATENATE lv_xcel_rec
                cl_bcs_convert=>gc_crlf
           INTO lv_xcel_rec.
    IF lv_xcel_att IS INITIAL.
      lv_xcel_att = lv_xcel_rec.
    ELSE.
      CONCATENATE lv_xcel_att
                  lv_xcel_rec
             INTO lv_xcel_att.
    ENDIF.

  ENDLOOP.

*-----Send mail
  PERFORM f_send_email USING lv_xcel_att.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_DATA_XLSX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_send_data_xlsx .
  IF s_email IS INITIAL.
*   E-mail recipient missing
    MESSAGE i042(edocument). "E-mail recipient missing
    RETURN.
  ENDIF.

  TYPES : BEGIN OF lty_output,
            col1  TYPE string,
            col2  TYPE string,
            col3  TYPE string,
            col4  TYPE string,
            col5  TYPE string,
            col6  TYPE string,
            col7  TYPE string,
            col8  TYPE string,
            col9  TYPE string,
            col10 TYPE string,
            col11 TYPE string,
            col12 TYPE extwg,
            col13 TYPE matnr,
            col14 TYPE char1,
            col15 TYPE char1, "sequence for mediatype
            col16 TYPE char1, "Sequence for scale
          END   OF lty_output,

          BEGIN OF lty_issue,
            med_prod     TYPE ismrefmdprod,
            mpg_lfdnr    TYPE mpg_lfdnr,
            ismcopynr    TYPE ismheftnummer,
            ismnrinyear  TYPE ismnrimjahr,
            ismyearnr    TYPE ismjahrgang,
            extwg        TYPE extwg,
            ismmediatype TYPE ismmediatype,
          END   OF lty_issue,

          BEGIN OF lty_text,
            text TYPE string,
          END   OF lty_text,

          BEGIN OF lty_ausp,
            objek TYPE objnum,
            atinn TYPE atinn,
            atzhl TYPE wzaehl,
            atwrt TYPE atwrt,
          END   OF lty_ausp,

          BEGIN OF lty_matnr,
            sign   TYPE sign,
            option TYPE option,
            low    TYPE matnr,
            high   TYPE matnr,
          END   OF lty_matnr,

          BEGIN OF lty_total_mat, "Material range to get data from AUSP
            sign   TYPE sign,
            option TYPE option,
            low    TYPE objnum,
            high   TYPE objnum,
          END   OF lty_total_mat,

          BEGIN OF lty_bom,
            stlnr TYPE stnum,
            idnrk TYPE idnrk,
            matnr TYPE matnr,
          END   OF lty_bom,

          BEGIN OF lty_mara,
            matnr        TYPE matnr,
            mtart        TYPE mtart,
            extwg        TYPE extwg,
            ismmediatype TYPE ismmediatype,
          END   OF lty_mara,

          BEGIN OF lty_mara1,
            matnr        TYPE matnr,
            mtart        TYPE mtart,
            extwg        TYPE extwg,
            ismmediatype TYPE ismmediatype,
            ismpubltype  TYPE ismpubltype,
            sequence     TYPE char1,
          END   OF lty_mara1,

          BEGIN OF lty_final_bom,
            stlnr        TYPE stnum,
            idnrk        TYPE idnrk,
            extwg        TYPE extwg,
            ismmediatype TYPE ismmediatype,
            sequence     TYPE char1,
            matnr        TYPE matnr,
            mtart        TYPE mtart,
            mat_extwg    TYPE extwg,
            media        TYPE ismmediatype,
            sequence1    TYPE char1,
            ismpubltype  TYPE ismpubltype,
            priceex      TYPE c,
          END   OF lty_final_bom,

          BEGIN OF lty_marc,
            matnr TYPE matnr,
            werks TYPE werks_d,
            herkl TYPE herkl,
          END   OF lty_marc,

          BEGIN OF lty_optin,
            matnr       TYPE matnr,
            ismpubltype TYPE ismpubltype,
          END   OF lty_optin.


  DATA : li_input       TYPE STANDARD TABLE OF ty_final,
         li_final       TYPE STANDARD TABLE OF lty_output,
         li_tmp1        TYPE STANDARD TABLE OF ty_final, "Journal Group Code
         li_tmp2        TYPE STANDARD TABLE OF ty_final, "List of materials
         li_tmp3        TYPE STANDARD TABLE OF ty_final, "prices
         li_output      TYPE STANDARD TABLE OF lty_output,
         li_zddp        TYPE STANDARD TABLE OF lty_output,
         li_issue       TYPE STANDARD TABLE OF lty_issue,
         li_issue1      TYPE STANDARD TABLE OF lty_issue,
         li_issue2      TYPE STANDARD TABLE OF lty_issue,
         li_issue_tmp   TYPE STANDARD TABLE OF lty_issue,
         li_text        TYPE STANDARD TABLE OF lty_text,
         li_tmp4        TYPE STANDARD TABLE OF lty_output,
         li_ausp        TYPE STANDARD TABLE OF lty_ausp,
         li_total_mat   TYPE STANDARD TABLE OF lty_total_mat,
         li_bom         TYPE STANDARD TABLE OF lty_bom,
         li_bom1        TYPE STANDARD TABLE OF lty_bom,
         li_bom_tmp     TYPE STANDARD TABLE OF lty_bom,
         li_final_bom   TYPE STANDARD TABLE OF lty_final_bom,
         li_final_bom1  TYPE STANDARD TABLE OF lty_final_bom,
         li_final_bom2  TYPE STANDARD TABLE OF lty_final_bom,
         li_mara        TYPE STANDARD TABLE OF lty_mara,
         li_marc        TYPE STANDARD TABLE OF lty_marc,
         li_optin       TYPE STANDARD TABLE OF lty_optin,
         li_mara1       TYPE STANDARD TABLE OF lty_mara1,
         li_mara1_final TYPE STANDARD TABLE OF lty_mara1,
         li_mara2       TYPE STANDARD TABLE OF lty_mara1.

  DATA : lw_input       TYPE ty_final,
         lw_final       TYPE lty_output,
         lw_output      TYPE lty_output,
         lw_zddp        TYPE lty_output,
         lw_tmp4        TYPE lty_output,
         lw_tmp1        TYPE ty_final,
         lw_tmp2        TYPE ty_final,
         lw_tmp3        TYPE ty_final,
         lw_issue       TYPE lty_issue,
         lw_issue1      TYPE lty_issue,
         lw_issue2      TYPE lty_issue,
         lw_issue_tmp   TYPE lty_issue,
         lw_text        TYPE lty_text,
         lw_ausp        TYPE lty_ausp,
         lw_total_mat   TYPE lty_total_mat,
         lw_bom         TYPE lty_bom,
         lw_bom1        TYPE lty_bom,
         lw_final_bom   TYPE lty_final_bom,
         lw_final_bom1  TYPE lty_final_bom,
         lw_final_bom2  TYPE lty_final_bom,
         lw_mara        TYPE lty_mara,
         lw_marc        TYPE lty_marc,
         lw_optin       TYPE lty_optin,
         lw_mara1       TYPE lty_mara1,
         lw_mara1_final TYPE lty_mara1,
         lw_mara2       TYPE lty_mara1.

  DATA : lv_valid_on     TYPE sy-datum,
         lv_alphabet     TYPE c,
         lv_txt          TYPE string,
         lv_sepa         TYPE c VALUE cl_abap_char_utilities=>newline,
         lv_year         TYPE ismjahrgang,
         lv_flag         TYPE c,
         lv_extwg1       TYPE extwg,
         lv_ismmediatype TYPE ismmediatype,                 "ED1K910672
         lv_amt          TYPE i.


* Begin by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
  DATA : lv_title      TYPE string,
         lv_title1     TYPE string,
         lv_mat_extwg  TYPE extwg,
         lv_mat_extwg1 TYPE extwg,
         lv_idcode     TYPE ismidentcode,
         lv_idcode1    TYPE ismidentcode,
         lv_txt1       TYPE string.
  CLEAR : lv_title,     lv_title1,
          lv_mat_extwg, lv_mat_extwg1,
          lv_idcode,    lv_idcode1,
          lv_txt,       lv_txt1.
* End by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919

  CONSTANTS : lc_undsc     TYPE char200 VALUE
  '________________________________________________________________________________________________________________________________________________________________________________________________________',
              lc_herkl     TYPE herkl VALUE 'DE',
              lc_atinn_866 TYPE atinn VALUE '0000000866', "JPSNT = 0000000866
              lc_atinn_867 TYPE atinn VALUE '0000000867'. "JPSNT = 0000000867

  li_input[] = i_final[].

  CLEAR : lw_input, lw_tmp1, lv_alphabet, lw_tmp2, lv_txt,
          lw_final, lw_output, lw_total_mat, lv_year, lw_bom,
          lw_final_bom, lw_marc, lw_optin, lw_bom1, lw_mara1, lw_mara2, lw_final_bom2.
  REFRESH: li_tmp1, li_tmp2, li_final, li_output, li_ausp, li_total_mat, li_bom, li_final_bom,
           li_marc, li_issue, li_issue2, li_mara, li_bom_tmp, li_optin, li_bom1, li_mara1,
           li_mara2, li_final_bom2.

READ TABLE i_constants INTO DATA(lst_const) WITH  KEY param1 = 'MONTHS_RANGE' BINARY SEARCH.
IF sy-subrc EQ 0.
 v_low_month = lst_const-low.
 v_high_month = lst_const-high.
ENDIF.
**-----Round off all currency fields
*  LOOP AT li_input INTO lw_input.
*    lv_amt = lw_input-kbetr.
*    lw_input-kbetr = lv_amt.
*    CLEAR : lv_amt.
*    lv_amt = lw_input-npadd.
*    lw_input-npadd = lv_amt.
*    CLEAR : lv_amt.
*    lv_amt = lw_input-npapp.
*    lw_input-npapp = lv_amt.
*    CLEAR : lv_amt.
*    lv_amt = lw_input-npadp.
*    lw_input-npadp = lv_amt.
*    CLEAR : lv_amt.
*    MODIFY li_input FROM lw_input.
*  ENDLOOP.

*-----Get Volume and issue details from JPTMG0
  REFRESH li_tmp3.
  li_tmp3[] = li_input[].
  SORT li_tmp3 BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_tmp3 COMPARING matnr.
  IF NOT li_tmp3 IS INITIAL.
    SELECT j~med_prod
           j~mpg_lfdnr
           j~ismcopynr
           j~ismnrinyear
           j~ismyearnr
           m~extwg
           m~ismmediatype
      FROM mara   AS m INNER JOIN
           jptmg0 AS j
      ON   j~med_prod EQ m~matnr
      INTO TABLE li_issue
      FOR ALL ENTRIES IN li_tmp3
      WHERE j~med_prod = li_tmp3-matnr
      AND ( m~ismmediatype = c_media_ph OR m~ismmediatype EQ c_media_di ).
    IF sy-subrc = 0.
      SORT li_issue BY ismyearnr.
      li_issue1[] = li_issue[].
      DELETE li_issue WHERE ismyearnr NE p_prsdt+0(4).
    ENDIF.

*-----Get Volume and issue details from JPTMG0 for current and previous year
    lv_year = p_prsdt+0(4).
    lv_year = lv_year - 1.
* Added logic to ignore the supplements from the Select query
    SELECT j~med_prod
           j~mpg_lfdnr
           j~ismcopynr
           j~ismnrinyear
           j~ismyearnr
           m~extwg
           m~ismmediatype
      FROM mara   AS m INNER JOIN
           jptmg0 AS j
      ON   j~med_prod EQ m~matnr
      INTO TABLE li_issue2
      FOR ALL ENTRIES IN li_tmp3
      WHERE j~med_prod = li_tmp3-matnr
      AND   j~matnr    NOT LIKE '________S%'                "ED1K910672
*      AND ( m~ismmediatype = 'PH' OR m~ismmediatype EQ 'DI' )
      AND ( j~ismyearnr = p_prsdt+0(4) OR j~ismyearnr = lv_year ).
    IF sy-subrc = 0.
* BOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672
* Issue Number (ISMNRINYEAR) may contain blank for the Supplement
* and also some contain leading zeros which may result in wrong
* calculation of the issues.. hence making them consistant before
* Sorting.
      LOOP AT li_issue2 ASSIGNING FIELD-SYMBOL(<lst_sq>).
        IF <lst_sq>-ismnrinyear IS ASSIGNED.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_sq>-ismnrinyear
            IMPORTING
              output = <lst_sq>-ismnrinyear.
        ENDIF.
      ENDLOOP.
      SORT li_issue2 BY ismyearnr.
    ENDIF.
* EOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672

*-----Get Characteristics details
    LOOP AT li_tmp3 INTO lw_tmp3.
      lw_total_mat-sign = c_sign_i. "c_sign_i.
      lw_total_mat-option = c_opti_eq. "c_opti_eq.
      lw_total_mat-low = lw_tmp3-matnr.
      APPEND lw_total_mat TO li_total_mat.
      CLEAR: lw_total_mat.
    ENDLOOP.

    SELECT objek atinn atzhl atwrt
      FROM ausp
      INTO TABLE li_ausp
      FOR ALL ENTRIES IN li_total_mat
      WHERE objek = li_total_mat-low
*      AND ( atinn = 'JPSMW' OR atinn = 'JPSNT' ).
      AND ( atinn = lc_atinn_866 OR atinn = lc_atinn_867 ).
    "JPSNT = 0000000866
    "JPSMW = 0000000867

    IF sy-subrc = 0.
      SORT li_ausp ASCENDING BY objek atinn
                   DESCENDING atzhl.
    ENDIF.

*-----Get BOM data for free text 1
    SELECT s~stlnr
           s~idnrk
           m~matnr
      FROM stpo AS s INNER JOIN
           mast AS m
           ON s~stlnr EQ m~stlnr
               INTO TABLE li_bom
      FOR ALL ENTRIES IN li_tmp3
      WHERE s~idnrk EQ li_tmp3-matnr
      AND m~stlan EQ c_bom_us_sd.
    IF NOT li_bom IS INITIAL.
      REFRESH: li_bom_tmp.
      li_bom_tmp[] = li_bom[].
      SORT li_bom_tmp BY matnr.
      DELETE ADJACENT DUPLICATES FROM li_bom_tmp COMPARING matnr.
      SELECT matnr mtart extwg ismmediatype
        FROM mara
        INTO TABLE li_mara
        FOR ALL ENTRIES IN li_bom_tmp
        WHERE matnr = li_bom_tmp-matnr
        AND extwg NE space
        AND mtart EQ c_mt_zmjl. " 'ZMJL'.
      IF sy-subrc = 0.
        SORT li_mara BY matnr.
      ENDIF.
      REFRESH : li_bom_tmp.

      LOOP AT li_bom INTO lw_bom.
*       Begin of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
        READ TABLE li_tmp3 TRANSPORTING NO FIELDS
             WITH KEY matnr = lw_bom-matnr
             BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.
*       End   of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
        READ TABLE li_mara INTO lw_mara WITH KEY matnr = lw_bom-matnr
*       Begin of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
        BINARY SEARCH.
*       End   of ADD:ERP-6616:WROY:16-Mar-2018:ED2K911417
        IF sy-subrc = 0.
          lw_final_bom-stlnr = lw_bom-stlnr.
          lw_final_bom-idnrk = lw_bom-idnrk.
          READ TABLE i_final INTO w_final WITH KEY matnr = lw_bom-idnrk.
          IF sy-subrc = 0.
            lw_final_bom-priceex = w_final-excld.
            lw_final_bom-ismmediatype = w_final-mediatype.
            IF lw_final_bom-ismmediatype EQ c_media_ph. "'PH'.
              lw_final_bom-sequence = 1.
            ELSEIF lw_final_bom-ismmediatype EQ c_media_di. "'DI'.
              lw_final_bom-sequence = 2.
            ELSEIF lw_final_bom-ismmediatype EQ c_media_mm. "'MM'.
              lw_final_bom-sequence = 3.
            ENDIF.
            lw_final_bom-extwg = w_final-extwg.
          ENDIF.
          lw_final_bom-matnr = lw_mara-matnr.
          lw_final_bom-mtart = lw_mara-mtart.
          lw_final_bom-mat_extwg = lw_mara-extwg.
          lw_final_bom-media = lw_mara-ismmediatype.
          IF lw_final_bom-media EQ c_media_ph. "'PH'.
            lw_final_bom-sequence1 = 1.
          ELSEIF lw_final_bom-media EQ c_media_di. "'DI'.
            lw_final_bom-sequence1 = 2.
          ELSEIF lw_final_bom-media EQ c_media_mm. "'MM'.
            lw_final_bom-sequence1 = 3.
          ENDIF.
          APPEND lw_final_bom TO li_final_bom.
          CLEAR: lw_final_bom.
        ENDIF.
      ENDLOOP.
      SORT li_final_bom BY extwg sequence.
    ENDIF.

*-----Get BOM data for free text 2
    SELECT matnr mtart extwg ismmediatype ismpubltype
      FROM mara
      INTO TABLE li_mara1
      FOR ALL ENTRIES IN li_tmp3
      WHERE matnr = li_tmp3-matnr
      AND   mtart = c_mt_zmjl. "'ZMJL'.
    IF sy-subrc = 0.
      LOOP AT li_mara1 INTO lw_mara1.
        IF lw_mara1-ismpubltype = c_media_ph. "'PH'.
          lw_mara1-sequence = c_seq_1. "c_seq_1
        ELSEIF lw_mara1-ismpubltype = c_media_di. "'DI'.
          lw_mara1-sequence = c_seq_2. "c_seq_2.
        ELSEIF lw_mara1-ismpubltype = c_media_mm. "'MM'.
          lw_mara1-sequence = c_seq_3. "c_seq_3.
        ENDIF.
        MODIFY li_mara1 FROM lw_mara1.
        CLEAR : lw_mara1.
      ENDLOOP.
*      SORT li_mara1 BY extwg sequence.                   "ED1K910672
      SORT li_mara1 BY extwg ismmediatype sequence.         "ED1K910672
      LOOP AT li_mara1 INTO lw_mara1.
        IF lv_extwg1 NE lw_mara1-extwg OR
           lv_ismmediatype NE lw_mara1-ismmediatype.        "ED1K910672
          lw_mara1_final = lw_mara1.
          APPEND lw_mara1_final TO li_mara1_final.
          lv_extwg1 = lw_mara1-extwg.
          lv_ismmediatype = lw_mara1-ismmediatype.          "ED1K910672
        ENDIF.
      ENDLOOP.
      CLEAR : lv_extwg1, lv_ismmediatype.                   "ED1K910672

      IF NOT li_mara1_final IS INITIAL.
        SELECT s~stlnr
               s~idnrk
               m~matnr
          FROM stpo AS s INNER JOIN
               mast AS m
               ON s~stlnr EQ m~stlnr
                   INTO TABLE li_bom1
          FOR ALL ENTRIES IN li_mara1_final
          WHERE m~matnr EQ li_mara1_final-matnr
          AND m~stlan EQ c_bom_us_sd.
      ENDIF.

      LOOP AT li_bom1 INTO lw_bom1.
        lw_final_bom1-matnr = lw_bom1-matnr.
        lw_final_bom1-stlnr = lw_bom1-stlnr.
        lw_final_bom1-idnrk = lw_bom1-idnrk.
        READ TABLE li_mara1 INTO lw_mara1 WITH KEY matnr = lw_bom1-matnr.
        IF sy-subrc = 0.
          lw_final_bom1-mtart = lw_mara1-mtart.
          lw_final_bom1-extwg = lw_mara1-extwg.
          lw_final_bom1-ismmediatype = lw_mara1-ismmediatype.
          lw_final_bom1-sequence = lw_mara1-sequence.
        ENDIF.
        APPEND lw_final_bom1 TO li_final_bom1.
      ENDLOOP.

      IF NOT li_final_bom1 IS INITIAL.
        SELECT matnr mtart extwg ismmediatype ismpubltype
          FROM mara
          INTO TABLE li_mara2
          FOR ALL ENTRIES IN li_final_bom1
          WHERE matnr = li_final_bom1-idnrk.
        IF sy-subrc = 0.
          LOOP AT li_final_bom1 INTO lw_final_bom1.
            READ TABLE li_mara2 INTO lw_mara2 WITH KEY matnr = lw_final_bom1-idnrk.
            IF sy-subrc = 0.
              lw_final_bom1-mat_extwg = lw_mara2-extwg.
              lw_final_bom1-media = lw_mara2-ismmediatype.
              lw_final_bom1-ismpubltype = lw_mara2-ismpubltype.
              IF lw_final_bom1-ismmediatype = c_media_ph. "'PH'.
                lw_final_bom1-sequence = c_seq_1. "c_seq_1.
              ELSEIF lw_final_bom1-ismmediatype = c_media_di. "'DI'.
                lw_final_bom1-sequence = c_seq_2. "c_seq_2.
              ELSEIF lw_final_bom1-ismmediatype = c_media_mm. "'MM'.
                lw_final_bom1-sequence = c_seq_3. "c_seq_3.
              ENDIF.
              IF lw_final_bom1-media = c_media_ph. "'PH'.
                lw_final_bom1-sequence1 = c_seq_1. "c_seq_1.
              ELSEIF lw_final_bom1-media = c_media_di. "'DI'.
                lw_final_bom1-sequence1 = c_seq_2. "c_seq_2.
              ELSEIF lw_final_bom1-media = c_media_mm. "'MM'.
                lw_final_bom1-sequence1 = c_seq_3. "c_seq_3.
              ENDIF.
              MODIFY li_final_bom1 FROM lw_final_bom1.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Get HERKL from MARC
    SELECT matnr werks herkl
      FROM marc
      INTO TABLE li_marc
      FOR ALL ENTRIES IN li_tmp3
      WHERE matnr = li_tmp3-matnr
      AND   herkl = lc_herkl. " DE
    IF sy-subrc = 0.
      SORT li_marc.
    ENDIF.

*-----Get ISMPUBLTYPE for OPT-IN
    SELECT matnr ismpubltype
      FROM mara
      INTO TABLE li_optin
      FOR ALL ENTRIES IN li_tmp3
      WHERE matnr = li_tmp3-matnr.
*      AND ismpubltype = 'OI'.
  ENDIF.

  REFRESH :li_tmp3, li_total_mat, li_bom, li_mara.


*-----Populate excel header
  CONCATENATE 'For information on our' p_prsdt+0(4) 'journal changes, please find it here:'
  INTO lv_txt SEPARATED BY space.

  lw_output-col1 = lv_txt.
  APPEND lw_output TO li_final.
  CLEAR: lv_txt, lw_output.

  CONCATENATE text-x01 lv_sepa text-x02 lv_sepa text-x03
  lv_sepa text-x04 lv_sepa
* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
  text-x16 lv_sepa
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
  text-x05 INTO lv_txt. "Journal Title/Acronym/Print ISSN/Online ISSN/Vol & issues
  lw_output-col1 = lv_txt.
  lw_output-col2 = text-x06. "'Journal Code'. "Material Number + <HIPATEL> <CR-6735> <ED2K912794>
  lw_output-col3 = text-x07. "'Media'.
  lw_output-col4 = text-x08. "'USA'.
  lw_output-col5 = text-x09. "'USA Agent Rate'.
  lw_output-col6 = text-x10. "'UK'.
  lw_output-col7 = text-x11. "'UK Agent Rate'.
  lw_output-col8 = text-x12. "'Europe'.
  lw_output-col9 = text-x13. "'Europe Agent Rate'.
  lw_output-col10 = text-x14. "'Rest of World'.
  lw_output-col11 = text-x15. "'Rest of World Agent Rate'.
  APPEND lw_output TO li_final.
  CLEAR : lw_output.

*-----Get Journal group code
  li_tmp1[] = li_input[].
  SORT li_tmp1 ASCENDING BY extwg.
  DELETE ADJACENT DUPLICATES FROM li_tmp1 COMPARING extwg.

*-----sort product title
  TYPES : BEGIN OF lty_title,
            extwg TYPE extwg,
            title TYPE char200,
          END   OF lty_title.
  DATA : li_title TYPE STANDARD TABLE OF lty_title,
         lw_title TYPE lty_title.

*  LOOP AT li_tmp1 INTO lw_tmp1.
*    READ TABLE li_input INTO lw_input WITH KEY extwg = lw_tmp1-extwg
*                                                  mediatype = c_media_ph. "'PH'.
*    IF sy-subrc = 0.
*      lw_title-extwg = lw_tmp1-extwg.
*      lw_title-title = lw_input-title.
*      APPEND lw_title TO li_title.
*    ELSE.
*      READ TABLE li_input INTO lw_input WITH KEY extwg = lw_tmp1-extwg
*                                                    mediatype = c_media_di. "'DI'.
*      IF sy-subrc = 0.
*        lw_title-extwg = lw_tmp1-extwg.
*        lw_title-title = lw_input-title.
*        APPEND lw_title TO li_title.
*      ELSE.
*        READ TABLE li_input INTO lw_input WITH KEY extwg = lw_tmp1-extwg
*                                                      mediatype = c_media_mm."'MM'.
*        IF sy-subrc = 0.
*          lw_title-extwg = lw_tmp1-extwg.
*          lw_title-title = lw_input-title.
*          APPEND lw_title TO li_title.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT li_tmp1 INTO lw_tmp1.
*    READ TABLE li_title INTO lw_title WITH KEY extwg = lw_tmp1-extwg.
*    IF sy-subrc = 0.
*      lw_tmp1-title = lw_title-title.
*      MODIFY li_tmp1 FROM lw_tmp1.
*    ENDIF.
*  ENDLOOP.

*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*  SORT li_tmp1 BY title.
  SORT li_tmp1 BY alpha_sep maktx_sub.
* Begin by amohammed on 05/07/2020 - ERPM-6882 - ED2K918137
*  extwg pltyp.
* End by amohammed on 05/07/2020 - ERPM-6882 - ED2K918137
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

  LOOP AT li_tmp1 INTO lw_tmp1.
*-----Populate the alphabet
*BOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*    IF lv_alphabet NE lw_tmp1-title+0(1).
*      lv_alphabet = lw_tmp1-title+0(1).
*      lw_final-col7 = lv_alphabet.
*      APPEND lw_final TO li_final.
*      CLEAR: lw_final.
*    ENDIF.
*EOD <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
*-----Populate the alphabet
    IF lv_alphabet NE lw_tmp1-alpha_sep.
      lv_alphabet = lw_tmp1-alpha_sep.
      lw_final-col7 = lv_alphabet.
      APPEND lw_final TO li_final.
      CLEAR: lw_final.
    ENDIF.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

    lw_final-col1 = lw_tmp1-title.
    APPEND lw_final TO li_final.
    CLEAR: lw_final, lw_input.

*-----Print Journal Grp Code
    lw_final-col1 = lw_tmp1-extwg.
    APPEND lw_final TO li_final.
    CLEAR: lw_final.
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
*--*Print only Pricing Components
    IF lw_tmp1-excld_prc IS INITIAL.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
*-----Get only those materials for the same Journal grp code
      li_tmp2[] = li_input[].
      SORT li_tmp2 ASCENDING BY extwg.
      DELETE li_tmp2 WHERE extwg NE lw_tmp1-extwg.

      SORT li_tmp2 ASCENDING BY matnr mediatype scale.
      DELETE ADJACENT DUPLICATES FROM li_tmp2 COMPARING matnr mediatype scale.

      SORT li_tmp2 BY klfn1 ASCENDING
                  seqmedia DESCENDING.
      LOOP AT li_tmp2 INTO lw_tmp2.

        IF lw_tmp2-mediatype EQ c_media_mm.
          IF lw_tmp2-scale = c_small.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_c space c_small1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt.  "+<HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_small1 INTO lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_pne. "P + E.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.

            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_mm.
            DELETE li_tmp3 WHERE scale NE c_small.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_medium.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_c space c_medium1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt.    "+<HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_medium1 INTO lv_txt.  "+<HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_pne.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_mm.
            DELETE li_tmp3 WHERE scale NE c_medium.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_large.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_c space c_large1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_large1 INTO lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_pne.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_mm.
            DELETE li_tmp3 WHERE scale NE c_large.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output,lw_zddp.

          ELSEIF lw_tmp2-scale = ' '.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_c INTO lv_txt.
*          CONCATENATE lw_tmp2-matnr c_slash c_media_c INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_pne.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_mm.
            DELETE li_tmp3 WHERE scale NE ' '.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ENDIF.


        ELSEIF lw_tmp2-mediatype EQ c_media_di.
          IF lw_tmp2-scale = c_small.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_e space c_small1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_small1 INTO lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_elec.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_di.
            DELETE li_tmp3 WHERE scale NE c_small.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_medium.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_e space c_medium1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_medium1 INTO lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_elec.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_di.
            DELETE li_tmp3 WHERE scale NE c_medium.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_large.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_e space c_large1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_large1 INTO lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_elec.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_di.
            DELETE li_tmp3 WHERE scale NE c_large.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = ' '.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_e INTO lv_txt.
*          CONCATENATE lw_tmp2-matnr c_slash c_media_e INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_elec.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_di.
            DELETE li_tmp3 WHERE scale NE ' '.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ENDIF.
        ELSEIF lw_tmp2-mediatype EQ c_media_ph.
          IF lw_tmp2-scale = c_small.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_p space c_small1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_small1 INTO lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_print.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_ph.
            DELETE li_tmp3 WHERE scale NE c_small.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_medium.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_p space c_medium1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_medium1 INTO lv_txt. "+ <HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_print.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_ph.
            DELETE li_tmp3 WHERE scale NE c_medium.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = c_large.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_p space c_large1 INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>

            CONCATENATE lv_txt space c_large1 INTO lv_txt. "+<HIPATEL> <INC0212602> <ED1K908594>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_print.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_ph.
            DELETE li_tmp3 WHERE scale NE c_large.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ELSEIF lw_tmp2-scale = ' '.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE lw_tmp2-extwg c_slash c_media_p INTO lv_txt.
*          CONCATENATE lw_tmp2-matnr c_slash c_media_p INTO lv_txt.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = lw_tmp2-matnr
              IMPORTING
                output = lv_txt.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
            lw_output-col2 = lv_txt.
            lw_zddp-col2 = lv_txt.
            CLEAR: lv_txt.
            lw_output-col3 = c_print.
            lw_zddp-col3 = c_ddp.

            li_tmp3[] = li_input[].
            SORT li_tmp3 BY extwg matnr mediatype scale.
            DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
            DELETE li_tmp3 WHERE matnr NE lw_tmp2-matnr.
            DELETE li_tmp3 WHERE mediatype NE c_media_ph.
            DELETE li_tmp3 WHERE scale NE ' '.
            LOOP AT li_tmp3 INTO lw_tmp3.
              IF lw_tmp3-pltyp = c_pltyp_p1.
                lw_output-col4 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col4 INTO lw_output-col4 SEPARATED BY space.
                lw_output-col5 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col5 INTO lw_output-col5 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col4 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col4 INTO lw_zddp-col4 SEPARATED BY space.
                  lw_zddp-col5 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col5 INTO lw_zddp-col5 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p2.
                lw_output-col6 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col6 INTO lw_output-col6 SEPARATED BY space.
                lw_output-col7 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col7 INTO lw_output-col7 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col6 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col6 INTO lw_zddp-col6 SEPARATED BY space.
                  lw_zddp-col7 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col7 INTO lw_zddp-col7 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p3.
                lw_output-col8 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col8 INTO lw_output-col8 SEPARATED BY space.
                lw_output-col9 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col9 INTO lw_output-col9 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col8 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col8 INTO lw_zddp-col8 SEPARATED BY space.
                  lw_zddp-col9 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col9 INTO lw_zddp-col9 SEPARATED BY space.
                ENDIF.
              ELSEIF lw_tmp3-pltyp = c_pltyp_p4.
                lw_output-col10 = lw_tmp3-kbetr.
                CONCATENATE lw_tmp3-csign lw_output-col10 INTO lw_output-col10 SEPARATED BY space.
                lw_output-col11 = lw_tmp3-npadd.
                CONCATENATE lw_tmp3-csign lw_output-col11 INTO lw_output-col11 SEPARATED BY space.
                IF lw_tmp3-fzddp = abap_true.
                  lw_zddp-col10 = lw_tmp3-npapp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col10 INTO lw_zddp-col10 SEPARATED BY space.
                  lw_zddp-col11 = lw_tmp3-npadp.
                  CONCATENATE lw_tmp3-csign lw_zddp-col11 INTO lw_zddp-col11 SEPARATED BY space.
                ENDIF.
              ENDIF.
            ENDLOOP.
*BOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
*Validation required on ZLPS condition type
            lw_output-col1 = lw_tmp3-kschl.
            lw_zddp-col1   = lw_tmp3-kschl.
*EOC <HIPATEL> <CR-6335> <ED2K912391> <06/22/2018>
            lw_output-col12 = lw_tmp3-extwg.
            lw_output-col13 = lw_tmp3-matnr.
            lw_output-col14 = lw_tmp3-seqmedia.
            lw_zddp-col12 = lw_tmp3-extwg.
            lw_zddp-col13 = lw_tmp3-matnr.
            lw_zddp-col14 = lw_tmp3-seqmedia.

            IF lw_tmp3-kbetr = 0.
              lw_output-col4 = c_dot.
              lw_output-col6 = c_dot.
              lw_output-col8 = c_dot.
              lw_output-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadd = 0.
              lw_output-col5 = c_dot.
              lw_output-col7 = c_dot.
              lw_output-col9 = c_dot.
              lw_output-col11 = c_dot.
            ENDIF.
            IF lw_tmp3-npapp = 0.
              lw_zddp-col4 = c_dot.
              lw_zddp-col6 = c_dot.
              lw_zddp-col8 = c_dot.
              lw_zddp-col10 = c_dot.
            ENDIF.
            IF lw_tmp3-npadp = 0.
              lw_zddp-col5 = c_dot.
              lw_zddp-col7 = c_dot.
              lw_zddp-col9 = c_dot.
              lw_zddp-col11 = c_dot.
            ENDIF.

            APPEND lw_output TO li_output.
            APPEND lw_zddp TO li_zddp.
            REFRESH: li_tmp3.
            CLEAR: lw_tmp3, lw_output, lw_zddp.

          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF. " IF lw_tmp1-excld IS INITIAL.
*-----Populate Print ISSN/Online ISSN
    TYPES : BEGIN OF lty_mediatype,
              sign   TYPE sign,
              option TYPE option,
              low    TYPE ismmediatype,
              high   TYPE ismmediatype,
            END   OF lty_mediatype.

    DATA : lv_issnp     TYPE string, "Issn for Print
           lv_index     TYPE sy-index,
           li_mediatype TYPE STANDARD TABLE OF lty_mediatype,
           lw_mediatype TYPE lty_mediatype,
           lv_issnd     TYPE string. "ISSN for digital

    REFRESH li_mediatype.
    CLEAR : lw_mediatype.
    lw_mediatype-sign = c_sign_i.
    lw_mediatype-option = c_opti_eq.
    lw_mediatype-low = c_media_ph.
    APPEND lw_mediatype TO li_mediatype.
    lw_mediatype-sign = c_sign_i.
    lw_mediatype-option = c_opti_eq.
    lw_mediatype-low = c_media_di.
    APPEND lw_mediatype TO li_mediatype.


    REFRESH li_tmp3.
    CLEAR: lw_tmp3, lv_issnp, lv_issnd.
    li_tmp3[] = li_input[].
    SORT li_tmp3 BY extwg.
    DELETE li_tmp3 WHERE extwg NE lw_tmp1-extwg.
    SORT li_tmp3 BY mediatype.
    DELETE li_tmp3 WHERE mediatype NOT IN li_mediatype.
    SORT li_tmp3 BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_tmp3 COMPARING matnr.

    IF NOT li_tmp3 IS INITIAL.
      LOOP AT li_tmp3 INTO lw_tmp3 WHERE mediatype = c_media_ph.
        READ TABLE i_issn INTO w_issn WITH KEY matnr = lw_tmp3-matnr
                                               ismmediatype = c_media_ph.
        IF sy-subrc = 0.
          lv_issnp = w_issn-identcode.
          EXIT.
        ENDIF.
      ENDLOOP.
      LOOP AT li_tmp3 INTO lw_tmp3 WHERE mediatype = c_media_di.
        READ TABLE i_issn INTO w_issn WITH KEY matnr = lw_tmp3-matnr
                                               ismmediatype = c_media_di.
        IF sy-subrc = 0.
          lv_issnd = w_issn-identcode.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    REFRESH : li_tmp3.
    CLEAR: lw_tmp3.
*read table i_issn into w_issn with key extwg = lw_tmp1-extwg


*-----Popultate volume and issue no
*-----Get volume/issues from Print
    DATA : lv_issue  TYPE string, "ismnrimjahr,
           lv_volume TYPE string. "ismheftnummer.

    REFRESH li_issue_tmp.
    CLEAR : lv_issue, lv_volume, lw_issue_tmp, lv_txt.

    li_issue_tmp[] = li_issue[].
    SORT li_issue_tmp BY extwg.
    DELETE li_issue_tmp WHERE extwg NE lw_tmp1-extwg.

    SORT li_issue_tmp BY ismmediatype.
    DELETE li_issue_tmp WHERE ismmediatype NE c_media_ph.

    IF NOT li_issue_tmp IS INITIAL.
      "Get issue
      DESCRIBE TABLE li_issue_tmp LINES lv_issue.
*      SORT li_issue_tmp DESCENDING BY ismnrinyear.
*      READ TABLE li_issue_tmp INTO lw_issue_tmp INDEX 1.
*      IF sy-subrc = 0.
*        lv_issue = lw_issue_tmp-ismnrinyear.
*        SHIFT lv_issue LEFT DELETING LEADING '0'.
*      ENDIF.

      "Get volume
      SORT li_issue_tmp BY ismcopynr.
      DELETE ADJACENT DUPLICATES FROM li_issue_tmp COMPARING ismcopynr.
      LOOP AT li_issue_tmp INTO lw_issue_tmp.
        CONCATENATE lv_volume lw_issue_tmp-ismcopynr INTO lv_volume SEPARATED BY c_hyphn.
      ENDLOOP.
      IF NOT lv_volume IS INITIAL.
        SHIFT lv_volume BY 1 PLACES LEFT.
      ENDIF.
* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
* If number of issues are greater than 12 OR
* If the pricing condition records valid from & Valid to dates
*  are different from 01/01/XXXX & 12/31/XXXX
* Then classify the title as rolling

*      IF lv_issue > 12.
*        CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
*               INTO lv_txt
*               SEPARATED BY space. " Volume and issues
*      ELSE.

*      IF ( ( lw_tmp1-datab+4(2) NE c_jan_one OR
*             lw_tmp1-datab+6(2) NE c_jan_one ) OR
*             ( lw_tmp1-datbi+4(2) NE c_dec OR
*               lw_tmp1-datbi+6(2) NE c_month_end ) ).
      IF ( ( lw_tmp1-datab+4(2) GE v_low_month AND
             lw_tmp1-datab+6(2) GE c_jan_one ) AND
             ( lw_tmp1-datbi+4(2) LE v_high_month AND
               lw_tmp1-datbi+6(2) LE c_month_end ) ).
        CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
               INTO lv_txt
               SEPARATED BY space. " Volume and issues

      ELSE.
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
        CONCATENATE text-a25 lv_volume c_comma lv_issue text-a26 INTO lv_txt SEPARATED BY space. " Volume and issues
* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
      ENDIF.
*      ENDIF.
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
    ELSE.

*-----Get volume/issues from DIgital if not found from Print
      li_issue_tmp[] = li_issue[].
      SORT li_issue_tmp BY extwg.
      DELETE li_issue_tmp WHERE extwg NE lw_tmp1-extwg.

      SORT li_issue_tmp BY ismmediatype.
      DELETE li_issue_tmp WHERE ismmediatype NE c_media_di.

      IF NOT li_issue_tmp IS INITIAL.
        "Get issue
        DESCRIBE TABLE li_issue_tmp LINES lv_issue.
*        SORT li_issue_tmp DESCENDING BY ismnrinyear.
*        READ TABLE li_issue_tmp INTO lw_issue_tmp INDEX 1.
*        IF sy-subrc = 0.
*          lv_issue = lw_issue_tmp-ismnrinyear.
*        ENDIF.
        "Get volume
        SORT li_issue_tmp BY ismcopynr.
        DELETE ADJACENT DUPLICATES FROM li_issue_tmp COMPARING ismcopynr.
        LOOP AT li_issue_tmp INTO lw_issue_tmp.
          CONCATENATE lv_volume lw_issue_tmp-ismcopynr INTO lv_volume SEPARATED BY c_hyphn.
        ENDLOOP.
        IF NOT lv_volume IS INITIAL.
          SHIFT lv_volume BY 1 PLACES LEFT.
        ENDIF.
* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
* If number of issues are greater than 12 OR
* If the pricing condition records valid from & Valid to dates
*  are different from 01/01/XXXX & 12/31/XXXX
* Then classify the title as rolling

*        IF lv_issue > 12.
*          CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
*                 INTO lv_txt
*                 SEPARATED BY space. " Volume and issues
*        ELSE.
* SOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
*        IF ( ( lw_tmp1-datab+4(2) NE c_jan_one OR
*               lw_tmp1-datab+6(2) NE c_jan_one ) OR
*             ( lw_tmp1-datbi+4(2) NE c_dec OR
*               lw_tmp1-datbi+6(2) NE c_month_end ) )

    IF ( ( lw_tmp1-datab+4(2) GE v_low_month AND
             lw_tmp1-datab+6(2) GE c_jan_one ) AND
             ( lw_tmp1-datbi+4(2) LE v_high_month AND
               lw_tmp1-datbi+6(2) LE c_month_end ) ).
* EOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
          CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
                 INTO lv_txt
                 SEPARATED BY space. " Volume and issues

        ELSE.
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
          CONCATENATE text-a25 lv_volume c_comma lv_issue text-a26 INTO lv_txt SEPARATED BY space. " Volume and issues
* Begin by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
        ENDIF.
*        ENDIF.
* End by amohammed on 04/07/2020 - ERPM-6882 - ED2K917919
        ELSE.
* SOC by NPOLINA OTCM-25238 Rolling Title display irrespective of Media Issues
          IF ( ( lw_tmp1-datab+4(2) GE v_low_month AND
             lw_tmp1-datab+6(2) GE c_jan_one ) AND
             ( lw_tmp1-datbi+4(2) LE v_high_month AND
               lw_tmp1-datbi+6(2) LE c_month_end ) ).

              lv_txt = 'Rolling title'(a27)  .

          ENDIF.
* EOC by NPOLINA OTCM-25238 Rolling Title display irrespective of Media Issues

      ENDIF.
    ENDIF.
    REFRESH : li_issue_tmp.
    CLEAR: lw_issue_tmp, lv_volume, lv_issue.


*-----Populate ZDDP Entries.
    APPEND LINES OF li_zddp TO li_output.


*-----Sequence output
    DATA : lv_len TYPE i.

    LOOP AT li_output INTO lw_output.
      IF lw_output-col3 = c_pne.
        lw_output-col15 = c_seq_1.
      ELSEIF lw_output-col3 = c_elec.
        lw_output-col15 = c_seq_2.
      ELSEIF lw_output-col3 = c_print.
        lw_output-col15 = c_seq_3.
      ELSEIF lw_output-col3 = c_ddp.
        lw_output-col15 = c_seq_4.
      ENDIF.
      IF lw_output-col2 CS c_small1.
        lw_output-col16 = c_seq_2.
      ELSEIF lw_output-col2 CS c_medium1.
        lw_output-col16 = c_seq_3.
      ELSEIF lw_output-col2 CS c_large1.
        lw_output-col16 = c_seq_4.
      ELSE.
        lw_output-col16 = c_seq_1.
      ENDIF.
*BOD <HIPATEL> <CR-7760> <ED1K908594> <10/01/2018>
*These rounding rules are requested to be removed.
*      "delete last 3 characters from the amount field.
*      IF NOT ( lw_output-col4 IS INITIAL OR lw_output-col4 EQ '.' ) .
*        lv_len = strlen( lw_output-col4 ).
*        lv_len = lv_len - 4.
*        lw_output-col4 = lw_output-col4+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col5 IS INITIAL OR lw_output-col5 EQ '.' ) .
*        lv_len = strlen( lw_output-col5 ).
*        lv_len = lv_len - 4.
*        lw_output-col5 = lw_output-col5+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col6 IS INITIAL OR lw_output-col6 EQ '.' ) .
*        lv_len = strlen( lw_output-col6 ).
*        lv_len = lv_len - 4.
*        lw_output-col6 = lw_output-col6+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col7 IS INITIAL OR lw_output-col7 EQ '.' ) .
*        lv_len = strlen( lw_output-col7 ).
*        lv_len = lv_len - 4.
*        lw_output-col7 = lw_output-col7+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col8 IS INITIAL OR lw_output-col8 EQ '.' ) .
*        lv_len = strlen( lw_output-col8 ).
*        lv_len = lv_len - 4.
*        lw_output-col8 = lw_output-col8+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col9 IS INITIAL OR lw_output-col9 EQ '.' ) .
*        lv_len = strlen( lw_output-col9 ).
*        lv_len = lv_len - 4.
*        lw_output-col9 = lw_output-col9+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col10 IS INITIAL OR lw_output-col10 EQ '.' ) .
*        lv_len = strlen( lw_output-col10 ).
*        lv_len = lv_len - 4.
*        lw_output-col10 = lw_output-col10+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*      IF NOT ( lw_output-col11 IS INITIAL OR lw_output-col11 EQ '.' ) .
*        lv_len = strlen( lw_output-col11 ).
*        lv_len = lv_len - 4.
*        lw_output-col11 = lw_output-col11+0(lv_len).
*        CLEAR : lv_len.
*      ENDIF.
*EOD <HIPATEL> <CR-7760> <ED1K908594> <10/01/2018>
      MODIFY li_output FROM lw_output.
    ENDLOOP.
    SORT li_output BY col16 ASCENDING
                      col15 ASCENDING.

*Begin of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
* Delete lines where all currency field is zero
    CLEAR: lw_output.
    LOOP AT li_output INTO lw_output.
      CLEAR : lv_index.
      lv_index = sy-tabix.
      IF  lw_output-col4 IS INITIAL
      AND lw_output-col5 IS INITIAL
      AND lw_output-col6 IS INITIAL
      AND lw_output-col7 IS INITIAL
      AND lw_output-col8 IS INITIAL
      AND lw_output-col9 IS INITIAL
      AND lw_output-col10 IS INITIAL
      AND lw_output-col11 IS INITIAL.
        DELETE li_output INDEX lv_index.
      ENDIF.
    ENDLOOP.
*End of Add-Anirban-09.11.2017-ED2K908468-Defect 4392

*-----Populate body with ISSN/Vol/Issue/price
*Begin of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
    DATA: lv_lines TYPE i.
    CLEAR: lv_lines.
    DESCRIBE TABLE li_output LINES lv_lines.
*End of Add-Anirban-09.11.2017-ED2K908468-Defect 4392

    LOOP AT li_output INTO lw_output.
      IF sy-tabix = 1.
        IF NOT lv_issnp IS INITIAL.
          lw_final-col1 = lv_issnp.
          CLEAR: lv_issnp.
        ELSEIF NOT lv_issnd IS INITIAL.
          lw_final-col1 = lv_issnd.
          CLEAR : lv_issnd.
        ELSEIF NOT lv_txt IS INITIAL.
          lw_final-col1 = lv_txt.
          CLEAR: lv_txt.
        ENDIF.
      ENDIF.
      IF sy-tabix = 2.
        IF NOT lv_issnd IS INITIAL.
          lw_final-col1 = lv_issnd.
          CLEAR: lv_issnd.
        ELSEIF NOT lv_txt IS INITIAL.
          lw_final-col1 = lv_txt.
          CLEAR: lv_txt.
        ENDIF.
      ENDIF.
      IF sy-tabix = 3.
        IF NOT lv_txt IS INITIAL.
          lw_final-col1 = lv_txt.
          CLEAR: lv_txt.
        ENDIF.
      ENDIF.

*BOC <HIPATEL> <CR-6335> <ED2K912198> <06/12/2018>
      IF lw_output-col1 = c_zlps AND lw_output-col3 = c_print.
        CLEAR lw_tmp4.
        READ TABLE li_output INTO lw_tmp4 WITH KEY col2  = lw_output-col2
                                                   col3  = c_ddp
                                                   col13 = lw_output-col13.
        IF sy-subrc = 0.
          lw_output = lw_tmp4.
          DELETE li_output INDEX sy-tabix.
        ENDIF.
      ENDIF.
*EOC <HIPATEL> <CR-6335> <ED2K912198> <06/12/2018>

      lw_final-col2 = lw_output-col2.
      lw_final-col3 = lw_output-col3.
      lw_final-col4 = lw_output-col4.
      lw_final-col5 = lw_output-col5.
      lw_final-col6 = lw_output-col6.
      lw_final-col7 = lw_output-col7.
      lw_final-col8 = lw_output-col8.
      lw_final-col9 = lw_output-col9.
      lw_final-col10 = lw_output-col10.
      lw_final-col11 = lw_output-col11.
      lw_final-col12 = lw_output-col12.
      lw_final-col13 = lw_output-col13.
      lw_final-col14 = lw_output-col14.
      APPEND lw_final TO li_final.
      CLEAR : lw_final, lw_output.
    ENDLOOP.
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
*--*For No price Materials Print ISSN
    IF lw_tmp1-excld_prc IS NOT INITIAL AND li_output IS INITIAL.
      IF NOT lv_issnp IS INITIAL.
        lw_final-col1 = lv_issnp.
        APPEND lw_final TO li_final.
        CLEAR: lv_issnp,lw_final.
      ENDIF.
      IF NOT lv_issnd IS INITIAL.
        lw_final-col1 = lv_issnd.
        APPEND lw_final TO li_final.
        CLEAR : lv_issnd,lw_final.
      ENDIF.
    ENDIF.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
*Begin of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
    CASE lv_lines.
      WHEN 1.
        IF NOT lv_issnd IS INITIAL.
          lw_final-col1 = lv_issnd.
          CLEAR: lv_issnd.
        ELSEIF NOT lv_txt IS INITIAL.
          lw_final-col1 = lv_txt.
          CLEAR: lv_txt.
        ENDIF.
        APPEND lw_final TO li_final.
      WHEN 2.
        IF NOT lv_txt IS INITIAL.
          lw_final-col1 = lv_txt.
          CLEAR: lv_txt.
        ENDIF.
        APPEND lw_final TO li_final.
    ENDCASE.
*End of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
    li_tmp4[] = li_output[].
    REFRESH : li_output.
    CLEAR : lw_final, lw_output.

*-----Populate ZDDP Entries.
*    APPEND LINES OF li_zddp TO li_tmp4.
*    LOOP AT li_zddp INTO lw_zddp.
*      APPEND lw_zddp TO li_final.
*    ENDLOOP.

    REFRESH: li_zddp.
    CLEAR : lw_zddp.

*-----Populate free text lines.
    DATA : li_tmp5  TYPE STANDARD TABLE OF lty_output,
           li_matnr TYPE STANDARD TABLE OF lty_matnr,
           lw_tmp5  TYPE lty_output,
           lw_matnr TYPE lty_matnr.

    REFRESH : li_tmp5[], li_matnr.
    CLEAR : lw_matnr, lw_tmp5.

    "Get unique material no
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    LOOP AT li_tmp5 INTO lw_tmp5.
      lw_matnr-sign = c_sign_i.
      lw_matnr-option = c_opti_eq.
      lw_matnr-low = lw_tmp5-col13.
      APPEND lw_matnr TO li_matnr.
    ENDLOOP.
    REFRESH: li_tmp5.
    CLEAR : lw_matnr.


*---------------------------------------------------------------------------
*            FREE TEXT # 1 - Also available in  xxx package
*---------------------------------------------------------------------------

    DATA : li_final_bom_tmp TYPE STANDARD TABLE OF lty_final_bom,
           li_lines         TYPE STANDARD TABLE OF tline,
           lw_final_bom_tmp TYPE lty_final_bom,
           lw_lines         TYPE tline,
           lv_name          TYPE tdobname,
           lv_desc          TYPE string,
           lv_desc1         TYPE string,
           lv_extwg         TYPE extwg.

    CONSTANTS : lc_sep TYPE char3 VALUE ' & '.

    CONSTANTS : lc_obj TYPE thead-tdobject VALUE 'MATERIAL',
                lc_id  TYPE thead-tdid VALUE 'GRUN'.
    REFRESH: li_final_bom_tmp.
    CLEAR : lv_desc.
    li_final_bom_tmp[] = li_final_bom[].
    DELETE li_final_bom_tmp WHERE extwg NE lw_tmp1-extwg.
    SORT li_final_bom_tmp BY mat_extwg sequence1.

    IF NOT li_final_bom_tmp IS INITIAL.
      LOOP AT li_final_bom_tmp INTO lw_final_bom_tmp.
        IF lv_extwg NE lw_final_bom_tmp-mat_extwg.
          lv_name = lw_final_bom_tmp-matnr.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = lc_id
              language                = sy-langu
              name                    = lv_name
              object                  = lc_obj
            TABLES
              lines                   = li_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF NOT li_lines IS INITIAL.
            IF lw_final_bom_tmp-priceex = ' '.
              LOOP AT li_lines INTO lw_lines.
                CONCATENATE lv_desc lw_lines-tdline
                INTO lv_desc SEPARATED BY lc_sep. " &
              ENDLOOP.
            ELSEIF lw_final_bom_tmp-priceex = 'C'.
              LOOP AT li_lines INTO lw_lines.
                CONCATENATE lv_desc1 lw_lines-tdline
                INTO lv_desc1 SEPARATED BY lc_sep. " &
              ENDLOOP.
            ENDIF.
          ENDIF.
          CLEAR : lv_name.
          REFRESH: li_lines.
          lv_extwg = lw_final_bom_tmp-mat_extwg.
        ENDIF.
      ENDLOOP.
    ENDIF.


    IF NOT lv_desc IS INITIAL.
      SHIFT lv_desc BY 2 PLACES LEFT.
*     Begin of DEL:ERP-6616:WROY:23-Feb-2018:ED2K911047
*     CONCATENATE 'Also available in' lv_desc 'Packages' INTO lw_text-text SEPARATED BY space.
*     End   of DEL:ERP-6616:WROY:23-Feb-2018:ED2K911047
*     Begin of ADD:ERP-6616:WROY:23-Feb-2018:ED2K911047
      CONCATENATE 'Also available in' lv_desc INTO lw_text-text SEPARATED BY space.
*     End   of ADD:ERP-6616:WROY:23-Feb-2018:ED2K911047
      APPEND lw_text TO li_text.
      CLEAR: lw_text, lv_desc.
    ENDIF.

    IF NOT lv_desc1 IS INITIAL.
      SHIFT lv_desc1 BY 2 PLACES LEFT.
      CONCATENATE 'See' lv_desc1 INTO lw_text-text SEPARATED BY space.
      APPEND lw_text TO li_text.
      CLEAR: lw_text, lv_desc.
    ENDIF.

*---------------------------------------------------------------------------
*            FREE TEXT # 2  - Includes xx1, xx2, … xxn
*            FREE TEXT # 3 - Includes Opt-in title xxx
*---------------------------------------------------------------------------
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.

    li_final_bom2[] = li_final_bom1[].
    SORT li_final_bom2 BY  matnr.

    LOOP AT li_tmp5 INTO lw_tmp5.
      DELETE li_final_bom2 WHERE matnr NE lw_tmp5-col13.
      LOOP AT li_final_bom2 INTO lw_final_bom2.
        IF lw_final_bom2-ismpubltype NE 'OI'.
          lv_name = lw_final_bom2-idnrk.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = lc_id
              language                = sy-langu
              name                    = lv_name
              object                  = lc_obj
            TABLES
              lines                   = li_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF NOT li_lines IS INITIAL.
*            CLEAR lv_desc.
            LOOP AT li_lines INTO lw_lines.
              CONCATENATE lv_desc lw_lines-tdline
              INTO lv_desc SEPARATED BY c_comma.
            ENDLOOP.

* Begin by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
**    Exclude the materials which are already printing as separately ( avodiding duplicates)
            READ TABLE li_tmp1 ASSIGNING FIELD-SYMBOL(<lw_tmp11>)
              WITH KEY extwg = lw_final_bom2-mat_extwg.
            IF sy-subrc EQ 0 AND <lw_tmp11>-matnr CA lw_final_bom2-idnrk.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
              CONTINUE.
            ENDIF.
*
            " Extract title
            CLEAR lv_title.
            lv_title = lv_desc.

            " Extract external material group
            CLEAR lv_mat_extwg.
            lv_mat_extwg = lw_final_bom2-mat_extwg.

            " Extract identification code
            CLEAR lv_idcode.
            READ TABLE i_issn ASSIGNING FIELD-SYMBOL(<fs_issn>)
              WITH KEY matnr = lw_final_bom2-idnrk
                       BINARY SEARCH.
            IF sy-subrc EQ 0.
              lv_idcode = <fs_issn>-identcode.
            ENDIF.

            " Extract Volume and Issue details of current BOM item
            CLEAR lv_txt.
            PERFORM f_populate_vol_issues_of_bom USING li_issue
                                                       lw_final_bom2
                                                       lw_tmp1
                                                 CHANGING lv_txt.
* End by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919

          ENDIF.
          CLEAR : lv_name.
          REFRESH: li_lines.
        ELSEIF lw_final_bom2-ismpubltype EQ 'OI'.
          lv_name = lw_final_bom2-idnrk.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = lc_id
              language                = sy-langu
              name                    = lv_name
              object                  = lc_obj
            TABLES
              lines                   = li_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF NOT li_lines IS INITIAL.
*            CLEAR lv_desc1.
            LOOP AT li_lines INTO lw_lines.
              CONCATENATE lv_desc1 lw_lines-tdline
              INTO lv_desc1 SEPARATED BY c_comma.
            ENDLOOP.

* Begin by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
**    Exclude the materials which are already printing as separately ( avodiding duplicates)
            READ TABLE li_tmp1 ASSIGNING <lw_tmp11>
            WITH KEY extwg = lw_final_bom2-mat_extwg.
            IF sy-subrc EQ 0 AND <lw_tmp11>-matnr CA lw_final_bom2-idnrk.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
              CONTINUE.
            ENDIF.

            " Extract title
            CLEAR lv_title1.
            lv_title1 = lv_desc1.

            " Extract external material group
            CLEAR lv_mat_extwg1.
            lv_mat_extwg1 = lw_final_bom2-mat_extwg.

            " Extract identification code
            CLEAR lv_idcode1.
            READ TABLE i_issn ASSIGNING <fs_issn>
              WITH KEY matnr = lw_final_bom2-idnrk
                       BINARY SEARCH.
            IF sy-subrc EQ 0.
              lv_idcode1 = <fs_issn>-identcode.
            ENDIF.

            " Extract Volume and Issue details of current BOM item
            CLEAR lv_txt1.
            PERFORM f_populate_vol_issues_of_bom USING li_issue
                                                       lw_final_bom2
                                                       lw_tmp1
                                                 CHANGING lv_txt1.
* End by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919

          ENDIF.
          CLEAR : lv_name.
          REFRESH: li_lines.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    IF NOT  lv_desc IS INITIAL OR NOT lv_desc1 IS INITIAL .
      IF NOT lv_desc IS INITIAL.
        SHIFT lv_desc BY 1 PLACES LEFT.
        CONCATENATE 'Includes' lv_desc c_dot INTO lv_desc SEPARATED BY space.
      ENDIF.
      IF NOT lv_desc1 IS INITIAL.
        SHIFT lv_desc1 BY 1 PLACES LEFT.
        CONCATENATE 'Includes Opt-in title' lv_desc1 INTO lv_desc1 SEPARATED BY space.
      ENDIF.
      CONCATENATE lv_desc lv_desc1 INTO lw_text-text SEPARATED BY space.
      APPEND lw_text TO li_text.
      CLEAR : lv_desc, lv_desc1, lw_text.
    ENDIF.
    REFRESH : li_tmp5.
    CLEAR: lw_tmp5.

* Begin by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
* Fill li_text internal table.
    IF lv_title IS NOT INITIAL.
      " Add empty line
      CLEAR lw_text.
      APPEND lw_text TO li_text.

      " Add title of first BOM item
      CLEAR lw_text.
      SHIFT lv_title BY 1 PLACES LEFT.
      lw_text-text = lv_title.
      APPEND lw_text TO li_text.
      CLEAR lv_title.
    ENDIF.

    " Add External Material Group of first BOM item
    IF lv_mat_extwg IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_mat_extwg.
      APPEND lw_text TO li_text.
      CLEAR lv_mat_extwg.
    ENDIF.

    " Add Identification code of first BOM item
    IF lv_idcode IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_idcode.
      APPEND lw_text TO li_text.
      CLEAR lv_idcode.
    ENDIF.

    " Add Volume and Issue details
    IF lv_txt IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_txt.
      APPEND lw_text TO li_text.
      CLEAR lv_txt.
    ENDIF.

    IF lv_title1 IS NOT INITIAL.
      " Add empty line
      CLEAR lw_text.
      APPEND lw_text TO li_text.

      " Add title of second BOM item
      CLEAR lw_text.
      SHIFT lv_title1 BY 1 PLACES LEFT.
      lw_text-text = lv_title1.
      APPEND lw_text TO li_text.
      CLEAR lv_title1.
    ENDIF.

    " Add External Material Group of second BOM item
    IF lv_mat_extwg1 IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_mat_extwg1.
      APPEND lw_text TO li_text.
      CLEAR lv_mat_extwg1.
    ENDIF.

    " Add Identification code of first BOM item
    IF lv_idcode1 IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_idcode1.
      APPEND lw_text TO li_text.
      CLEAR lv_idcode1.
    ENDIF.

    " Add Volume and Issue details
    IF lv_txt1 IS NOT INITIAL.
      CLEAR lw_text.
      lw_text-text = lv_txt1.
      APPEND lw_text TO li_text.
      CLEAR lv_txt1.

      CLEAR lw_text.
      lw_text-text = 'OPT-IN TITLE'.
      APPEND lw_text TO li_text.
      CLEAR lw_text.
    ENDIF.
* End by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919

*---------------------------------------------------------------------------
*            FREE TEXT # 5 amd # 6 - Increasing from / Decreasing from n2 to n1 issues
*---------------------------------------------------------------------------
    DATA : li_issue3 TYPE STANDARD TABLE OF lty_issue,
           li_issue4 TYPE STANDARD TABLE OF lty_issue,
           lw_issue3 TYPE lty_issue,
           lw_issue4 TYPE lty_issue.
* BOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672
*    DATA :  lv_chigh TYPE char2, "ismnrimjahr, "Issue no for all year
*            lv_phigh TYPE char2. "ismnrimjahr. "Issue no for the valid on date (Year)
    DATA : lv_chigh TYPE char4, "ismnrimjahr, "Issue no for all year
           lv_phigh TYPE char4. "ismnrimjahr. "Issue no for the valid on date (Year)
* EOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672

    REFRESH: li_issue3,li_issue4 , li_tmp5. "li_matnr,
    CLEAR : lw_issue3, lw_issue4, lw_tmp5. "lw_matnr

    li_tmp5[] = li_tmp4[].

    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.

    LOOP AT li_tmp5 INTO lw_tmp5.
      li_issue3[] = li_issue2[].
      li_issue4[] = li_issue2[].

      SORT li_issue3 BY med_prod.
      SORT li_issue4 BY med_prod.

      DELETE li_issue3 WHERE med_prod NE lw_tmp5-col13.
      DELETE li_issue4 WHERE med_prod NE lw_tmp5-col13.

      SORT li_issue3 BY ismyearnr.
      SORT li_issue4 BY ismyearnr.

      DELETE li_issue3 WHERE ismyearnr NE p_prsdt+0(4).
      DELETE li_issue4 WHERE ismyearnr NE lv_year.

*      SORT li_issue3 DESCENDING BY ismnrinyear.
*      SORT li_issue4 DESCENDING BY ismnrinyear.
* BOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672
      SORT li_issue3 BY ismnrinyear DESCENDING.
      SORT li_issue4 BY ismnrinyear DESCENDING.
*--BOC: SKKAIRAMKO - INC0252071- 08/01/19
*      READ TABLE li_issue3 INTO lw_issue3 INDEX 1.
*      IF sy-subrc EQ 0.
*        MOVE lw_issue3-ismnrinyear TO lv_chigh.
*      ENDIF.
*
*      READ TABLE li_issue4 INTO lw_issue4 INDEX 1.
*      IF sy-subrc EQ 0.
*        MOVE lw_issue4-ismnrinyear TO lv_phigh.
*      ENDIF.

* Begin by amohammed on 05/07/2020 - ERPM-6882 - ED2K918137
*& Additional issue numbers with alphanumeric value are
*&   considered along with other issues by taking the total
*&   count instead of hightest issue number.

*& Loops are commented and DESCRIBE code is added
*      LOOP AT li_issue3 INTO lw_issue3.
*
*        MOVE lw_issue3-ismnrinyear TO lv_chigh.
*        FIND REGEX '^[[:alnum:]]+$' IN lv_chigh.
*        IF sy-subrc EQ 0.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*
*
*      LOOP AT li_issue4 INTO lw_issue4.
*
*        MOVE lw_issue4-ismnrinyear TO lv_phigh.
*        FIND REGEX '^[[:alnum:]]+$' IN lv_phigh.
*        IF sy-subrc EQ 0.
*          EXIT.
*        ENDIF.
*      ENDLOOP
      CLEAR : lv_chigh, lv_phigh.
      DESCRIBE TABLE li_issue3 LINES lv_chigh.
      DESCRIBE TABLE li_issue4 LINES lv_phigh.
      CONDENSE : lv_chigh, lv_phigh.
* End by amohammed on 05/07/2020 - ERPM-6882 - ED2K918137

*--EOC: SKKAIRAMKO - INC0252071- 08/01/19
*      DESCRIBE TABLE li_issue3 LINES lv_chigh.
*      DESCRIBE TABLE li_issue4 LINES lv_phigh.
* EOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672

      IF NOT ( lv_chigh EQ 0 OR lv_phigh EQ 0 ).
        IF lv_chigh > lv_phigh.
          SHIFT lv_phigh LEFT DELETING LEADING '0'.         "ED1K910672
          SHIFT lv_chigh LEFT DELETING LEADING '0'.         "ED1K910672
          CONCATENATE 'Increase from' lv_phigh 'to' lv_chigh 'issues' INTO lw_text-text SEPARATED BY space.
          APPEND lw_text TO li_text.
          CLEAR: lw_text, lv_chigh, lv_phigh.
          EXIT.
        ELSEIF lv_phigh > lv_chigh.
          SHIFT lv_phigh LEFT DELETING LEADING '0'.         "ED1K910672
          SHIFT lv_chigh LEFT DELETING LEADING '0'.         "ED1K910672
          CONCATENATE 'Decreasing from' lv_phigh 'to' lv_chigh 'issues' INTO lw_text-text SEPARATED BY space.
          APPEND lw_text TO li_text.
          CLEAR: lw_text, lv_chigh, lv_phigh.
          EXIT.
        ENDIF.
      ENDIF.
*      READ TABLE li_issue3 INTO lw_issue3 INDEX 1.
*      IF sy-subrc = 0.
*        lv_chigh = lw_issue3-ismnrinyear.
*        SHIFT lv_chigh LEFT DELETING LEADING '0'.
*        IF lv_chigh IS INITIAL.
*          lv_chigh = '0000'.
*        ENDIF.
*      ENDIF.
*
*      READ TABLE li_issue4 INTO lw_issue4 INDEX 1.
*      IF sy-subrc = 0.
*        lv_phigh = lw_issue4-ismnrinyear.
*        SHIFT lv_phigh LEFT DELETING LEADING '0'.
*        IF lv_phigh IS INITIAL.
*          lv_phigh = '0000'.
*        ENDIF.
*      ENDIF.
*      CLEAR : lw_issue3, lw_issue4.
*      IF NOT lv_chigh IS INITIAL AND NOT lv_phigh IS INITIAL.
*        IF lv_chigh LT lv_phigh.
*          CONCATENATE 'Decreasing from' lv_phigh 'to' lv_chigh 'issues' INTO lw_text-text SEPARATED BY space.
*          APPEND lw_text TO li_text.
*          CLEAR: lw_text, lv_chigh, lv_phigh.
*          EXIT.
*        ELSEIF lv_phigh LT lv_chigh.
*          CONCATENATE 'Increase from' lv_phigh 'to' lv_chigh 'issues' INTO lw_text-text SEPARATED BY space.
*          APPEND lw_text TO li_text.
*          CLEAR: lw_text, lv_chigh, lv_phigh.
*          EXIT.
*        ENDIF.
*      ENDIF.
    ENDLOOP.
    REFRESH: li_issue3, li_issue4, li_tmp5. "li_matnr,
    CLEAR : lw_issue3, lw_issue4, lw_tmp5. "lw_matnr

*---------------------------------------------------------------------------
*            FREE TEXT # 7 - Merged with xxx
*            FREE TEXT # 4 - Includes the new start title xxx
*---------------------------------------------------------------------------
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.

    "Includes the new start title xxx
    IF NOT li_matnr IS INITIAL.
      LOOP AT li_tmp5 INTO lw_tmp5.
        READ TABLE li_ausp INTO lw_ausp WITH KEY objek = lw_tmp5-col13
                                                 atinn = '0000000866'. "JPSNT
        IF sy-subrc = 0.
          CONCATENATE 'Includes the new start title' lw_ausp-atwrt INTO lw_text-text SEPARATED BY space.
          APPEND lw_text TO li_text.
          CLEAR : lw_text, lw_ausp.
          EXIT.
        ENDIF.
      ENDLOOP.
      "Merged with xxx
      LOOP AT li_tmp5 INTO lw_tmp5.
        READ TABLE li_ausp INTO lw_ausp WITH KEY objek = lw_tmp5-col13
                                                 atinn = '0000000867'. "JPSMW
        IF sy-subrc = 0.
          CONCATENATE 'Merged with' lw_ausp-atwrt INTO lw_text-text SEPARATED BY space.
          APPEND lw_text TO li_text.
          CLEAR : lw_text, lw_ausp.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    REFRESH : li_tmp5.
    CLEAR: lw_tmp5.

*---------------------------------------------------------------------------
*            FREE TEXT # 8 - VCH Title
*---------------------------------------------------------------------------
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.
    LOOP AT li_tmp5 INTO lw_tmp5.
      READ TABLE li_marc INTO lw_marc WITH KEY matnr = lw_tmp5-col13.
      IF sy-subrc = 0.
        lw_text-text = 'VCH Title'.
        APPEND lw_text TO li_text.
        CLEAR : lw_text, lw_marc.
        EXIT.
      ENDIF.
    ENDLOOP.
    REFRESH : li_tmp5.
    CLEAR: lw_tmp5.

*---------------------------------------------------------------------------
*            FREE TEXT # 9 - OPT-IN TITLE
*---------------------------------------------------------------------------
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.

    LOOP AT li_tmp5 INTO lw_tmp5.
      READ TABLE li_optin INTO lw_optin WITH KEY matnr = lw_tmp5-col13
                                                 ismpubltype = 'OI'.
      IF sy-subrc = 0.
        lw_text-text = 'OPT-IN TITLE'.
        APPEND lw_text TO li_text.
        CLEAR : lw_text, lw_optin.
        EXIT.
      ENDIF.
    ENDLOOP.
    REFRESH : li_tmp5.
    CLEAR: lw_tmp5.

*---------------------------------------------------------------------------
*            FREE TEXT # 11 - No Agency Discount Offered
*---------------------------------------------------------------------------
**BOC Prabhu ERP-6882 5/15/2020 ED2K918227
*--*Exclude if there is no Price
    IF lw_tmp1-excld_prc IS INITIAL.
**EOC Prabhu ERP-6882 5/15/2020 ED2K918227
      li_tmp5[] = li_tmp4[].

      CLEAR : lv_flag.
      SORT li_tmp5 BY col13.
      DELETE li_tmp5 WHERE col3 = c_ddp.
      LOOP AT li_tmp5 INTO lw_tmp5.
        IF lw_tmp5-col4 NE lw_tmp5-col5.
          lv_flag = abap_true.
          EXIT.
        ENDIF.
        IF lw_tmp5-col6 NE lw_tmp5-col7.
          lv_flag = abap_true.
          EXIT.
        ENDIF.
        IF lw_tmp5-col8 NE lw_tmp5-col9.
          lv_flag = abap_true.
          EXIT.
        ENDIF.
        IF lw_tmp5-col10 NE lw_tmp5-col11.
          lv_flag = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_flag IS INITIAL.
        lw_text-text = 'No Agency Discount Offered'.
        APPEND lw_text TO li_text.
        CLEAR : lw_text.
      ENDIF.
      REFRESH : li_tmp5.
      CLEAR: lw_tmp5, lv_flag.
    ENDIF."IF lw_tmp1-excld IS INITIAL.
*---------------------------------------------------------------------------
*            FREE TEXT # 12 - FTE
*---------------------------------------------------------------------------
    li_tmp5[] = li_tmp4[].
    SORT li_tmp5 BY col13.
    DELETE ADJACENT DUPLICATES FROM li_tmp5 COMPARING col13.
    SORT li_tmp5 ASCENDING BY col14.

    LOOP AT li_tmp5 INTO lw_tmp5.
      IF lw_tmp5-col2 CS '(SMALL)'.
        lw_text-text = 'FTE'.
        APPEND lw_text TO li_text.
        CLEAR : lw_text.
      ENDIF.
      EXIT.
    ENDLOOP.
    REFRESH : li_tmp5.
    CLEAR: lw_tmp5.



*-----Populate free text into the final table
    IF NOT li_text IS INITIAL.
      LOOP AT li_text INTO lw_text.
        lw_final-col1 = lw_text-text.
        APPEND lw_final TO li_final.
      ENDLOOP.
    ENDIF.

    CLEAR: lw_tmp4.
    REFRESH: li_tmp4, li_text.

*-----Populate underscore
    lw_final-col1 = lc_undsc.
*    lw_final-col2 = lc_undsc.
*    lw_final-col3 = lc_undsc.
*    lw_final-col4 = lc_undsc.
*    lw_final-col5 = lc_undsc.
*    lw_final-col6 = lc_undsc.
*    lw_final-col7 = lc_undsc.
*    lw_final-col8 = lc_undsc.
*    lw_final-col9 = lc_undsc.
*    lw_final-col10 = lc_undsc.
*    lw_final-col11 = lc_undsc.
    APPEND lw_final TO li_final.
    CLEAR: lw_final.
  ENDLOOP.

*-----Remove entries where all price = 0
*  DATA : lv_index TYPE sy-index.
  CLEAR: lv_index.
  LOOP AT li_final INTO lw_final.
    lv_index = sy-tabix.
    IF ( lw_final-col1 IS INITIAL
    AND lw_final-col4 IS INITIAL
    AND lw_final-col5 IS INITIAL
    AND lw_final-col6 IS INITIAL
    AND lw_final-col7 IS INITIAL
    AND lw_final-col8 IS INITIAL
    AND lw_final-col9 IS INITIAL
    AND lw_final-col10 IS INITIAL
    AND lw_final-col11 IS INITIAL ).
      lw_final-col2 = abap_true.
      MODIFY li_final FROM lw_final INDEX lv_index.
    ENDIF.
  ENDLOOP.
  CLEAR: lv_index.
  DELETE li_final WHERE col2 = abap_true.


*-----blank when price exclusion
  CLEAR: lv_index.
  LOOP AT li_final INTO lw_final.
    lv_index = sy-tabix.
    IF lw_final-col4 = c_dot.
      CLEAR: lw_final-col4.
    ENDIF.
    IF lw_final-col5 = c_dot.
      CLEAR: lw_final-col5.
    ENDIF.
    IF lw_final-col6 = c_dot.
      CLEAR: lw_final-col6.
    ENDIF.
    IF lw_final-col7 = c_dot.
      CLEAR: lw_final-col7.
    ENDIF.
    IF lw_final-col8 = c_dot.
      CLEAR: lw_final-col8.
    ENDIF.
    IF lw_final-col9 = c_dot.
      CLEAR: lw_final-col9.
    ENDIF.
    IF lw_final-col10 = c_dot.
      CLEAR: lw_final-col10.
    ENDIF.
    IF lw_final-col11 = c_dot.
      CLEAR: lw_final-col11.
    ENDIF.
    MODIFY li_final FROM lw_final INDEX lv_index.
  ENDLOOP.
  CLEAR: lv_index.



*-----Send file
  FIELD-SYMBOLS : <lst_xcel> TYPE lty_output.
  DATA : lv_xcel_rec TYPE string,
         lv_xcel_att TYPE string.

  CLEAR: lv_xcel_rec.
  LOOP AT li_final ASSIGNING <lst_xcel>.
    CLEAR: lv_xcel_rec.
    CONCATENATE <lst_xcel>-col1
                <lst_xcel>-col2
                <lst_xcel>-col3
                <lst_xcel>-col4
                <lst_xcel>-col5
                <lst_xcel>-col6
                <lst_xcel>-col7
                <lst_xcel>-col8
                <lst_xcel>-col9
                <lst_xcel>-col10
                <lst_xcel>-col11
           INTO lv_xcel_rec
      SEPARATED BY cl_bcs_convert=>gc_tab.
    CONCATENATE lv_xcel_rec
                cl_bcs_convert=>gc_crlf
           INTO lv_xcel_rec.
    IF lv_xcel_att IS INITIAL.
      lv_xcel_att = lv_xcel_rec.
    ELSE.
      CONCATENATE lv_xcel_att
                  lv_xcel_rec
             INTO lv_xcel_att.
    ENDIF.
  ENDLOOP.
*-----Send mail
  PERFORM f_send_email USING lv_xcel_att.


ENDFORM.

FORM f_send_email  USING    fp_lv_xcel_att TYPE string.

  DATA:
    lo_send_request TYPE REF TO cl_bcs,
    lo_document     TYPE REF TO cl_document_bcs,
*    lo_sender       TYPE REF TO if_sender_bcs,
    lo_recipient    TYPE REF TO if_recipient_bcs,
    lx_document_bcs TYPE REF TO cx_document_bcs.

  DATA:
    li_message_body TYPE bcsy_text,
    li_xcel_att     TYPE solix_tab.

  DATA:
    lv_file_size   TYPE so_obj_len,
    lv_sent_to_all TYPE os_boolean.

* Create send request
  lo_send_request = cl_bcs=>create_persistent( ).

*For CSV file
  IF rb_age_c = abap_true.
* Put your text into the document
    lo_document = cl_document_bcs=>create_document(
                     i_type = 'RAW'
                     i_text = li_message_body
                     i_subject = 'Agent CSV'(o46) ).
*For XLSX file
  ELSEIF rb_age_e = abap_true.
* Put your text into the document
    lo_document = cl_document_bcs=>create_document(
                     i_type = 'RAW'
                     i_text = li_message_body
                     i_subject = 'Agent xlsx'(o47) ).
  ENDIF.
*For CSV file
  IF rb_age_c = abap_true.
    TRY.
        cl_bcs_convert=>string_to_solix(
          EXPORTING
            iv_string = fp_lv_xcel_att
            iv_add_bom = abap_true "for other doc types
          IMPORTING
            et_solix = li_xcel_att
            ev_size = lv_file_size ).
      CATCH cx_bcs.
        MESSAGE e445(so).
    ENDTRY.
*For XLSX file
  ELSEIF rb_age_e = abap_true.
    TRY.
        cl_bcs_convert=>string_to_solix(
          EXPORTING
            iv_string = fp_lv_xcel_att
            iv_codepage = '4103' "suitable for MS Excel, leave empty
            iv_add_bom = abap_true "for other doc types
          IMPORTING
            et_solix = li_xcel_att
            ev_size = lv_file_size ).
      CATCH cx_bcs.
        MESSAGE e445(so).
    ENDTRY.
  ENDIF.

*For CSV file
  IF rb_age_c = abap_true.
    TRY.
        lo_document->add_attachment(
          EXPORTING
            i_attachment_type = 'CSV'
            i_attachment_subject = 'Agent CSV'(o46)
            i_attachment_size = lv_file_size
            i_att_content_hex = li_xcel_att ).

      CATCH cx_document_bcs INTO lx_document_bcs.
    ENDTRY.
*For XLSX file
  ELSEIF rb_age_e = abap_true.
    TRY.
        lo_document->add_attachment(
          EXPORTING
            i_attachment_type = 'XLS'
            i_attachment_subject = 'Agent xlsx'(o47)
            i_attachment_size = lv_file_size
            i_att_content_hex = li_xcel_att ).

      CATCH cx_document_bcs INTO lx_document_bcs.
    ENDTRY.
  ENDIF.


* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  LOOP AT s_email ASSIGNING FIELD-SYMBOL(<lst_email>).
*   Create recipient
    lo_recipient = cl_cam_address_bcs=>create_internet_address( <lst_email>-low ).
*   Set recipient
    lo_send_request->add_recipient(
         EXPORTING
           i_recipient = lo_recipient ).
  ENDLOOP.

* Send email
  lo_send_request->send(
    EXPORTING
      i_with_error_screen = abap_true
    RECEIVING
      result = lv_sent_to_all ).

  COMMIT WORK.

* Message: Email sent successfully!
  MESSAGE i013(zrtr_r2).

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IDOC_CNTRL_REC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM f_idoc_cntrl_rec  USING    fp_m_type    TYPE edi_mestyp
                                fp_i_type    TYPE edi_idoctp
                       CHANGING fp_lst_edidc TYPE edidc.

* Populate EDIDC Data
  fp_lst_edidc-direct = c_dir_out.                              "Direction for IDoc-Outbound(1)
  fp_lst_edidc-mestyp = fp_m_type.                              "Message Type-'ZPDM_PRICE_FEED'
  fp_lst_edidc-idoctp = fp_i_type.                              "IDOC Type-'ZPDMB_PRICE_FEED01'

* Fetch details from Partner Profile: Outbound (technical parameters)
  SELECT rcvprn                                                 "Partner Number of Receiver
         rcvprt                                                 "Partner Type of Receiver
         rcvpor                                                 "Receiver port
    FROM edp13                                                  "Partner Profile: Outbound (technical parameters)
   UP TO 1 ROWS
    INTO ( fp_lst_edidc-rcvprn,                                 "Partner Number of Receiver
           fp_lst_edidc-rcvprt,                                 "Partner Type of Receiver
           fp_lst_edidc-rcvpor )                                "Receiver port
   WHERE mestyp EQ fp_m_type.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: fp_lst_edidc-rcvprn,                                 "Partner Number of Receiver
           fp_lst_edidc-rcvprt,                                 "Partner Type of Receiver
           fp_lst_edidc-rcvpor.                                 "Receiver port
  ENDIF.

  CONCATENATE c_sys_sap
              sy-sysid
              INTO fp_lst_edidc-sndpor.                         "Sender port
  CONDENSE fp_lst_edidc-sndpor.

  fp_lst_edidc-sndprt = c_p_typ_l.                              "Partner Type: Logical Syatem (LS).

* Get sender information (Current System)
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_lst_edidc-sndprn      "Partner Number of Sender
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.
    CLEAR fp_lst_edidc-sndprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*&---------------------------------------------------------------------*
*&      Form  F_GET_BASIC_TEXT
*&---------------------------------------------------------------------*
*       Fetch Material Basic Data Text
*----------------------------------------------------------------------*
*      -->FP_MATNR       Material Number
*      <--FP_BASIC_TEXT  Basic Data Text
*----------------------------------------------------------------------*
FORM f_get_basic_text  USING    fp_matnr      TYPE matnr
                       CHANGING fp_basic_text TYPE string.

  CONSTANTS:
    lc_text_id_grun TYPE tdid     VALUE 'GRUN',            "Text ID: GRUN
    lc_text_obj_mat TYPE tdobject VALUE 'MATERIAL'.        "Text Object: MATERIAL

  DATA:
    lv_text_name    TYPE tdobname.                         "Text Name: Material Number

  DATA:
    li_text_lines   TYPE tlinetab.                         "Text Lines

  lv_text_name = fp_matnr.                                 "Text Name: Material Number
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_text_id_grun            "Text ID: GRUN
      language                = sy-langu                   "Language Key
      name                    = lv_text_name               "Text Name: Material Number
      object                  = lc_text_obj_mat            "Text Object: MATERIAL
    TABLES
      lines                   = li_text_lines              "Text Lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
*   Converts ITF text into a string
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_text_lines                     "Text Lines
      IMPORTING
        ev_text_string = fp_basic_text.                    "String
  ENDIF.

ENDFORM.
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*&---------------------------------------------------------------------*
*&      Form  F_GET_ALPHA_SEP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_BASIC_TEXT  text
*      <--P_LW_FINAL1_ALPHA_SEP  text
*----------------------------------------------------------------------*
FORM f_get_alpha_sep  USING    fp_basic_text  TYPE string     "Material Description
                      CHANGING fp_alpha_sep   TYPE char1      "Alpha Separator
                               fp_maktx_sub   TYPE text150.   "Material Description-2.
  DATA: lv_alpha1 TYPE string,
        lv_alpha2 TYPE string.

  CONSTANTS: c_param_alp TYPE rvari_vnam   VALUE 'ALPHA_SEPARATOR'.   "Alpha Separator
*Journal Alpha sections should being with the first letter of Journal Description
*Journals should be alpha by the “Description” Name, the logic should ignore “The” when alphabetizing
  SPLIT fp_basic_text AT space INTO lv_alpha1 lv_alpha2.

  READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
     WITH KEY param1 = c_param_alp
              low    = lv_alpha1.
  IF sy-subrc NE 0.
    TRANSLATE lv_alpha1 TO UPPER CASE.
    READ TABLE i_constants ASSIGNING <lst_constant>
       WITH KEY param1 = c_param_alp
                low    = lv_alpha1.
  ENDIF. " IF sy-subrc EQ 0
  IF sy-subrc = 0.
    TRANSLATE lv_alpha2 TO UPPER CASE.
    CONDENSE lv_alpha2.
    fp_alpha_sep   = lv_alpha2(1).         "Alphabetical letter separator
    fp_maktx_sub   = lv_alpha2.            "Material Description for Sort
  ELSE.
    fp_alpha_sep   = fp_basic_text(1).     "Alphabetical letter separator
    TRANSLATE fp_alpha_sep TO UPPER CASE.
    fp_maktx_sub   = fp_basic_text.        "Material Description for Sort
    TRANSLATE fp_maktx_sub TO UPPER CASE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALICULATE_DISCOUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_ZAGD  text
*      <--P_W_FINAL_NPADP  text
*----------------------------------------------------------------------*
FORM f_caliculate_discount  USING    fp_zagd TYPE kbetr_kond
                            CHANGING fp_npadp TYPE kbetr_kond.
  DATA:lv_zwisu(15)   TYPE p,
       lv_xkbetr(15)  TYPE p,
       lv_arbfeld(15) TYPE p,
       lv_zagd        TYPE kbetr_kond.
  lv_zwisu   = fp_npadp * 100.
  lv_xkbetr  = fp_zagd * 100.
  lv_arbfeld = lv_zwisu * lv_xkbetr.
  lv_arbfeld = lv_arbfeld / 100000.
  lv_zagd    = lv_arbfeld / 100.
  fp_npadp = fp_npadp +  lv_zagd.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_VOL_ISSUES_OF_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_ISSUE  text
*----------------------------------------------------------------------*
FORM f_populate_vol_issues_of_bom  USING p_li_issue      TYPE tt_issue
                                         p_lw_final_bom2 TYPE ty_final_bom
                                         p_tmp1          TYPE ty_final
                                    CHANGING p_txt       TYPE string.

*-----Popultate volume and issue no
*-----Get volume/issues from Print
  DATA : lv_issue     TYPE string, "ismnrimjahr,
         lv_volume    TYPE string, "ismheftnummer.
         lw_issue_tmp TYPE ty_issue,
         lv_batch(10).


  CLEAR : lv_issue, lv_volume, lw_issue_tmp, p_txt.

  DATA(li_issue_tmp) = p_li_issue[].
  SORT li_issue_tmp BY med_prod.
  DELETE li_issue_tmp WHERE med_prod NE p_lw_final_bom2-idnrk.

  SORT li_issue_tmp BY ismmediatype.
  DELETE li_issue_tmp WHERE ismmediatype NE c_media_ph.

  IF NOT li_issue_tmp IS INITIAL.
    "Get issue
    DESCRIBE TABLE li_issue_tmp LINES lv_issue.

    "Get volume
    SORT li_issue_tmp BY ismcopynr.
    DELETE ADJACENT DUPLICATES FROM li_issue_tmp COMPARING ismcopynr.
    LOOP AT li_issue_tmp INTO lw_issue_tmp.
      CONCATENATE lv_volume lw_issue_tmp-ismcopynr INTO lv_volume
      SEPARATED BY c_hyphn.
    ENDLOOP.
    IF NOT lv_volume IS INITIAL.
      SHIFT lv_volume BY 1 PLACES LEFT.
    ENDIF.

* If number of issues are greater than 12 OR
* If the pricing condition records valid from & Valid to dates
*  are different from 01/01/XXXX & 12/31/XXXX
* Then classify the title as rolling

*      IF lv_issue > 12.
*        CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
*               INTO lv_txt
*               SEPARATED BY space. " Volume and issues
*      ELSE.
* SOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
*    IF ( ( p_tmp1-datab+4(2) NE c_jan_one OR
*           p_tmp1-datab+6(2) NE c_jan_one ) OR
*           ( p_tmp1-datbi+4(2) NE c_dec OR
*             p_tmp1-datbi+6(2) NE c_month_end ) ).


    IF ( ( p_tmp1-datab+4(2) GE v_low_month AND
             p_tmp1-datab+6(2) GE c_jan_one ) AND
             ( p_tmp1-datbi+4(2) LE v_high_month AND
               p_tmp1-datbi+6(2) LE c_month_end ) ).
* EOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
      CONCATENATE 'Rolling title'(a27) text-a25
                  lv_volume c_comma lv_issue text-a26
             INTO p_txt
             SEPARATED BY space. " Volume and issues
      CONCATENATE p_txt lv_batch c_print INTO p_txt RESPECTING BLANKS.
    ELSE.
      CONCATENATE text-a25 lv_volume c_comma lv_issue text-a26
             INTO p_txt SEPARATED BY space. " Volume and issues
      CONCATENATE p_txt lv_batch c_print INTO p_txt RESPECTING BLANKS.
    ENDIF.
  ELSE.

*-----Get volume/issues from DIgital if not found from Print
    li_issue_tmp[] = p_li_issue[].
    SORT li_issue_tmp BY med_prod.
    DELETE li_issue_tmp WHERE med_prod NE p_lw_final_bom2-idnrk.

    SORT li_issue_tmp BY ismmediatype.
    DELETE li_issue_tmp WHERE ismmediatype NE c_media_di.

    IF NOT li_issue_tmp IS INITIAL.
      "Get issue
      DESCRIBE TABLE li_issue_tmp LINES lv_issue.

      "Get volume
      SORT li_issue_tmp BY ismcopynr.
      DELETE ADJACENT DUPLICATES FROM li_issue_tmp COMPARING ismcopynr.
      LOOP AT li_issue_tmp INTO lw_issue_tmp.
        CONCATENATE lv_volume lw_issue_tmp-ismcopynr INTO lv_volume
        SEPARATED BY c_hyphn.
      ENDLOOP.
      IF NOT lv_volume IS INITIAL.
        SHIFT lv_volume BY 1 PLACES LEFT.
      ENDIF.
* If number of issues are greater than 12 OR
* If the pricing condition records valid from & Valid to dates
*  are different from 01/01/XXXX & 12/31/XXXX
* Then classify the title as rolling

*        IF lv_issue > 12.
*          CONCATENATE 'Rolling title'(a27) text-a25 lv_volume c_comma lv_issue text-a26
*                 INTO lv_txt
*                 SEPARATED BY space. " Volume and issues
*        ELSE.
* SOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
*      IF ( ( p_tmp1-datab+4(2) NE c_jan_one OR
*             p_tmp1-datab+6(2) NE c_jan_one ) OR
*           ( p_tmp1-datbi+4(2) NE c_dec OR
*             p_tmp1-datbi+6(2) NE c_month_end ) ).
    IF ( ( p_tmp1-datab+4(2) GE v_low_month AND
             p_tmp1-datab+6(2) GE c_jan_one ) AND
             ( p_tmp1-datbi+4(2) LE v_high_month AND
               p_tmp1-datbi+6(2) LE c_month_end ) ).
* EOC by NPOLINA 19/02/2021 ED2K922066 OTCM-25238
        CONCATENATE 'Rolling title'(a27) text-a25
                    lv_volume c_comma lv_issue text-a26
               INTO p_txt
               SEPARATED BY space. " Volume and issues
        CONCATENATE p_txt lv_batch c_elec INTO p_txt RESPECTING BLANKS.
      ELSE.
        CONCATENATE text-a25 lv_volume c_comma lv_issue text-a26
               INTO p_txt SEPARATED BY space. " Volume and issues
        CONCATENATE p_txt lv_batch c_elec INTO p_txt RESPECTING BLANKS.
      ENDIF.
* SOC by NPOLINA OTCM-25238 Rolling Title display irrespective of Media Issues
    ELSE.
    IF ( ( p_tmp1-datab+4(2) GE v_low_month AND
             p_tmp1-datab+6(2) GE c_jan_one ) AND
             ( p_tmp1-datbi+4(2) LE v_high_month AND
               p_tmp1-datbi+6(2) LE c_month_end ) ).

         p_txt = 'Rolling title'(a27)  .

    ENDIF.
* EOC by NPOLINA OTCM-25238 Rolling Title display irrespective of Media Issues
    ENDIF.
  ENDIF.
  REFRESH : li_issue_tmp.
  CLEAR: lw_issue_tmp, lv_volume, lv_issue.
ENDFORM.
