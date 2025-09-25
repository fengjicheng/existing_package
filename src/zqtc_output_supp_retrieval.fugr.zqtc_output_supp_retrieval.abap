FUNCTION zqtc_output_supp_retrieval.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_INPUT) TYPE  ZTQTC_SUPPLEMENT_RET_INPUT
*"     VALUE(IM_AUART) TYPE  AUART
*"  EXPORTING
*"     REFERENCE(EX_OUTPUT) TYPE  ZTQTC_OUTPUT_SUPP_RETRIEVAL
*"     REFERENCE(EX_OUTPUT_ALL) TYPE  ZTQTC_OUTPUT_SUPP_RETRIEVAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_OUTPUT_SUPP_RETRIEVAL
* PROGRAM DESCRIPTION: FM to get the list of attachments in a material
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-10
* OBJECT ID: E151
* TRANSPORT NUMBER(S):  ED2K905075(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K907387
* Reference No: ERP-5131
* Developer: Writtick Roy (WROY)
* Date:  2017-11-29
* Description: Use Cust Cond Grp 2 in stead of Cust Cond Grp 1
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K912903, ED2K913306
* Reference No: ERP-6458
* Developer: Writtick Roy (WROY)
* Date:  2018-08-03
* Description: New Naming Convention of Attachments
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:   ES1K900341
* Reference No:  AMS_SPS_Upg_2019
* Developer:     Nikhilesh Palla (NPALLA)
* Date:          06/25/2019
* Description:   Upgrade Fix as SAP is not supporting table type TSTRINGS
*----------------------------------------------------------------------*
* Begin of ADD:ERP-6458:WROY:03-AUG-2018:ED2K912903
  TYPES:
    BEGIN OF lty_op_supp_ret,
      product_numb TYPE matnr,      "Material Number
      description  TYPE bitm_descr, "Description for Browser Item (Display Attribute)
      archiv_id    TYPE saearchivi, "Content Repository Identification
      arc_doc_id   TYPE saeardoid,  "SAP ArchiveLink: Document ID
    END   OF lty_op_supp_ret.

  DATA:
    li_constants   TYPE zcat_constants,    "Constant Values
    lir_new_cntrct TYPE fip_t_auart_range, "SD Doc Type: New Contract
    lir_ren_cntrct TYPE fip_t_auart_range, "SD Doc Type: Renewal Contract
    li_connections TYPE toav0_t,           "Connections table
* Begin of Change:AMS_SPS_Upg_2019:NPALLA:25-JUN-2019:ES1K900341
*    li_all_member  TYPE tstrings,          "Where Clause: All Member
*    li_non_member  TYPE tstrings,          "Where Clause: Non Member
*    li_renewal_doc TYPE tstrings,          "Where Clause: Renewal Documents
*    li_welcome_doc TYPE tstrings,          "Where Clause: Welcome Documents
    li_all_member  TYPE etstring_tab,      "Where Clause: All Member
    li_non_member  TYPE etstring_tab,      "Where Clause: Non Member
    li_renewal_doc TYPE etstring_tab,      "Where Clause: Renewal Documents
    li_welcome_doc TYPE etstring_tab,      "Where Clause: Welcome Documents
* End of Change:AMS_SPS_Upg_2019:NPALLA:25-JUN-2019:ES1K900341
    li_data_1024   TYPE crd_t_1024,        "For passing in FM
    li_solix_data  TYPE solix_tab,
    li_op_supp_ret TYPE STANDARD TABLE OF lty_op_supp_ret INITIAL SIZE 0.

  DATA:
    lv_dummy_mat   TYPE matnr,    "Material Number
    lv_cust_group  TYPE char3,    "Customer Group
    lv_xstring_cnt TYPE xstring,  "XSTRING data of PDF
    lv_select_file TYPE flag,     "Filename
    lv_product     TYPE saeobjid. "SAP ArchiveLink: Object ID (object identifier)

  CONSTANTS:
    lc_dev_id_e098 TYPE zdevid     VALUE 'E098',           "Development ID
    lc_new_cntrct  TYPE rvari_vnam VALUE 'DOC_CATEG_SUB',  "ABAP: Name of Variant Variable
    lc_ren_cntrct  TYPE rvari_vnam VALUE 'DOC_CATEG_REN',  "ABAP: Name of Variant Variable
    lc_dummy_mat   TYPE rvari_vnam VALUE 'DUMMY_MATERIAL', "ABAP: Name of Variant Variable
    lc_all_member  TYPE rvari_vnam VALUE 'ALL_MEMBER',     "ABAP: Name of Variant Variable
    lc_non_member  TYPE rvari_vnam VALUE 'NON_MEMBER',     "ABAP: Name of Variant Variable
    lc_renewal_doc TYPE rvari_vnam VALUE 'RENEWAL_DOCS',   "ABAP: Name of Variant Variable
    lc_welcome_doc TYPE rvari_vnam VALUE 'WELCOME_DOCS'.   "ABAP: Name of Variant Variable

  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_id_e098
    IMPORTING
      ex_constants = li_constants.
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_new_cntrct.
        APPEND INITIAL LINE TO lir_new_cntrct ASSIGNING FIELD-SYMBOL(<lst_auart>).
        <lst_auart>-sign   = <lst_constant>-sign.
        <lst_auart>-option = <lst_constant>-opti.
        <lst_auart>-low    = <lst_constant>-low.
        <lst_auart>-high   = <lst_constant>-high.

      WHEN lc_ren_cntrct.
        APPEND INITIAL LINE TO lir_ren_cntrct ASSIGNING <lst_auart>.
        <lst_auart>-sign   = <lst_constant>-sign.
        <lst_auart>-option = <lst_constant>-opti.
        <lst_auart>-low    = <lst_constant>-low.
        <lst_auart>-high   = <lst_constant>-high.

      WHEN lc_dummy_mat.
        lv_dummy_mat       = <lst_constant>-low.

      WHEN lc_all_member.
        APPEND INITIAL LINE TO li_all_member ASSIGNING FIELD-SYMBOL(<lv_string>).
        <lv_string> = <lst_constant>-low.

      WHEN lc_non_member.
        APPEND INITIAL LINE TO li_non_member ASSIGNING <lv_string>.
        <lv_string> = <lst_constant>-low.

      WHEN lc_renewal_doc.
        APPEND INITIAL LINE TO li_renewal_doc ASSIGNING <lv_string>.
        <lv_string> = <lst_constant>-low.

      WHEN lc_welcome_doc.
        APPEND INITIAL LINE TO li_welcome_doc ASSIGNING <lv_string>.
        <lv_string> = <lst_constant>-low.

      WHEN OTHERS.

    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)

* Do not process, if SD Document Type is not relevant
  IF im_auart NOT IN lir_new_cntrct AND
     im_auart NOT IN lir_ren_cntrct.
    RETURN.
  ENDIF. " IF im_auart NOT IN lir_new_cntrct AND

* Fetch Sales Data for Material
  DATA(li_input) = im_input[].
  SORT li_input BY product_no.
  DELETE ADJACENT DUPLICATES FROM li_input
         COMPARING product_no.
  SELECT matnr                         "Material Number
    FROM mvke                          "Sales Data for Material
    INTO TABLE @DATA(li_prod_attr)
     FOR ALL ENTRIES IN @li_input
   WHERE matnr EQ @li_input-product_no "Product Number
     AND prat2 EQ @abap_true.          "Product attribute 2
  IF sy-subrc EQ 0.
    SORT li_prod_attr BY matnr.
  ENDIF. " IF sy-subrc EQ 0

* fetch Society Acronyms
  li_input = im_input[].
  SORT li_input BY society.
  DELETE ADJACENT DUPLICATES FROM li_input
         COMPARING society.
  SELECT society,         "Society number
         society_acrnym   "Society Acronym
    FROM zqtc_jgc_society "Journal Group Code to Society Mapping
    INTO TABLE @DATA(li_soc_acrnym)
     FOR ALL ENTRIES IN @li_input
   WHERE society EQ @li_input-society.
  IF sy-subrc EQ 0.
    SORT li_soc_acrnym BY society.
  ENDIF. " IF sy-subrc EQ 0

  DELETE ADJACENT DUPLICATES FROM im_input COMPARING ALL FIELDS.
  LOOP AT im_input INTO DATA(lst_input).
*   Customer Group (_<Customer Group>)
    IF lst_input-cust_grp IS NOT INITIAL.
      lv_cust_group = c_underscore && lst_input-cust_grp.
    ENDIF. " IF lst_input-cust_grp IS NOT INITIAL

*   Society Acronym
    IF lst_input-society IS NOT INITIAL.
      READ TABLE li_soc_acrnym ASSIGNING FIELD-SYMBOL(<lst_soc_acrnym>)
           WITH KEY society = lst_input-society
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_soc_acrnym) = <lst_soc_acrnym>-society_acrnym.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_input-society IS NOT INITIAL

*   If Product attribute 2 is populated, use the Dummy / Generic Material
    READ TABLE li_prod_attr TRANSPORTING NO FIELDS
         WITH KEY matnr = lst_input-product_no
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_product = lv_dummy_mat.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      lv_product = lst_input-product_no.
    ENDIF. " IF sy-subrc EQ 0

*   To get the details of the attachment
    CALL FUNCTION 'ARCHIV_GET_CONNECTIONS'
      EXPORTING
        object_id     = lv_product                "Object ID (Product Number)
      TABLES
        connections   = li_connections            "Attachments
      EXCEPTIONS
        nothing_found = 1
        OTHERS        = 2.
    IF sy-subrc EQ 0.
      LOOP AT li_connections INTO DATA(lst_connection).
        DATA(lo_al_item) = NEW cl_arl_al_item( is_connection = lst_connection ). "Attachment Name

        CLEAR: lv_select_file.
        IF im_auart IN lir_new_cntrct.                               "New Contracts
*         Look for Welcome Letters
          LOOP AT li_welcome_doc ASSIGNING <lv_string>.
            IF lo_al_item->gp_descr CS <lv_string>.
              lv_select_file = abap_true.
            ENDIF. " IF lo_al_item->gp_descr CS <lv_string>
          ENDLOOP. " LOOP AT li_welcome_doc ASSIGNING <lv_string>
        ELSEIF im_auart IN lir_ren_cntrct.                           "Renewals
*         Look for Renewal Documents
          LOOP AT li_renewal_doc ASSIGNING <lv_string>.
            IF lo_al_item->gp_descr CS <lv_string>.
              lv_select_file = abap_true.
            ENDIF. " IF lo_al_item->gp_descr CS <lv_string>
          ENDLOOP. " LOOP AT li_renewal_doc ASSIGNING <lv_string>
        ENDIF. " IF im_auart IN lir_new_cntrct
        IF lv_select_file IS INITIAL.
          CONTINUE.
        ENDIF. " IF lv_select_file IS INITIAL

*       Look for Society Acronym
        IF lv_soc_acrnym IS NOT INITIAL.
          IF lo_al_item->gp_descr CS lv_soc_acrnym.
            DATA(lv_soc_specific) = abap_true.
          ENDIF. " IF lo_al_item->gp_descr CS lv_soc_acrnym
        ENDIF. " IF lv_soc_acrnym IS NOT INITIAL

        CLEAR: lv_select_file.
*       Look for Customer Group
        IF lst_input-cust_grp IS NOT INITIAL.              "Customer Group is populated (Member)
          IF lo_al_item->gp_descr CS lv_cust_group.        "Specific Customer Group
            lv_select_file = abap_true.
          ELSE. " ELSE -> IF lo_al_item->gp_descr CS lv_cust_group
            LOOP AT li_all_member ASSIGNING <lv_string>.   "Generic Customer Group (All Member)
              IF lo_al_item->gp_descr CS <lv_string>.
                lv_select_file = abap_true.
              ENDIF. " IF lo_al_item->gp_descr CS <lv_string>
            ENDLOOP. " LOOP AT li_all_member ASSIGNING <lv_string>
          ENDIF. " IF lo_al_item->gp_descr CS lv_cust_group
        ELSE.                                              "Customer Group is not populated (Non-Member)
          LOOP AT li_non_member ASSIGNING <lv_string>.
            IF lo_al_item->gp_descr CS <lv_string>.
              lv_select_file = abap_true.
            ENDIF. " IF lo_al_item->gp_descr CS <lv_string>
          ENDLOOP. " LOOP AT li_non_member ASSIGNING <lv_string>
        ENDIF. " IF lst_input-cust_grp IS NOT INITIAL
        IF lv_select_file IS INITIAL.
          CONTINUE.
        ENDIF. " IF lv_select_file IS INITIAL

        APPEND INITIAL LINE TO li_op_supp_ret ASSIGNING FIELD-SYMBOL(<lst_op_supp_ret>).
        <lst_op_supp_ret>-product_numb = lst_input-product_no. "Product Number
        <lst_op_supp_ret>-description  = lo_al_item->gp_descr. "Attachment Name
        <lst_op_supp_ret>-archiv_id    = lst_connection-archiv_id.
        <lst_op_supp_ret>-arc_doc_id   = lst_connection-arc_doc_id.
      ENDLOOP. " LOOP AT li_connections INTO DATA(lst_connection)
    ENDIF. " IF sy-subrc EQ 0

*   Look for Society Specific Documents (Society Acronyms)
    IF lv_soc_specific IS NOT INITIAL.
      DATA(li_op_supp_ret_tmp) = li_op_supp_ret[].
      DELETE li_op_supp_ret WHERE description NS lv_soc_acrnym.
      IF li_op_supp_ret IS INITIAL.
        li_op_supp_ret = li_op_supp_ret_tmp.
      ENDIF. " IF li_op_supp_ret IS INITIAL
    ENDIF. " IF lv_soc_specific IS NOT INITIAL

    LOOP AT li_op_supp_ret ASSIGNING <lst_op_supp_ret>.
*     Get the pdf in binary format using archieve id and archieve document id
      CALL FUNCTION 'SCMS_AO_TABLE_GET'
        EXPORTING
          arc_id       = <lst_op_supp_ret>-archiv_id
          doc_id       = <lst_op_supp_ret>-arc_doc_id
        TABLES
          data         = li_data_1024
        EXCEPTIONS
          error_http   = 1
          error_archiv = 2
          error_kernel = 3
          error_config = 4
          OTHERS       = 5.
      IF sy-subrc = 0.
*       Conversion of RAW1024 data to RAW255
        CALL METHOD cl_rmps_general_functions=>convert_1024_to_255
          EXPORTING
            im_tab_1024 = li_data_1024
          RECEIVING
            re_tab_255  = li_solix_data.

*       Conversion of SOLIX_TAB data to XSTRING
        CALL METHOD cl_bcs_convert=>solix_to_xstring
          EXPORTING
            it_solix   = li_solix_data
          RECEIVING
            ev_xstring = lv_xstring_cnt.
      ENDIF. " IF sy-subrc = 0
      IF lv_xstring_cnt IS NOT INITIAL.
        APPEND INITIAL LINE TO ex_output ASSIGNING FIELD-SYMBOL(<lst_output>).
        <lst_output>-product_no      = <lst_op_supp_ret>-product_numb.
        <lst_output>-attachment_name = <lst_op_supp_ret>-description.
        <lst_output>-pdf_stream      = lv_xstring_cnt.
      ENDIF. " IF lv_xstring_cnt IS NOT INITIAL

      CLEAR: li_data_1024,
             li_solix_data,
             lv_xstring_cnt.
    ENDLOOP. " LOOP AT li_op_supp_ret ASSIGNING <lst_op_supp_ret>

    CLEAR: lv_soc_acrnym,
           lv_product,
           lv_select_file,
           lv_cust_group,
           lv_soc_specific,
           li_op_supp_ret.
  ENDLOOP. " LOOP AT im_input INTO DATA(lst_input)
  ex_output_all = ex_output. "Keep all entries against the Product Numbers
* Get Unique Attachments
  SORT ex_output BY attachment_name pdf_stream.
  DELETE ADJACENT DUPLICATES FROM ex_output
          COMPARING attachment_name pdf_stream.
* End   of ADD:ERP-6458:WROY:03-AUG-2018:ED2K912903
* Begin of DEL:ERP-6458:WROY:03-AUG-2018:ED2K912903
**  Local type declaration
*  TYPES: BEGIN OF lty_product,
*           product TYPE saeobjid, "Product Number
*         END OF lty_product,
*
*         ltt_product TYPE STANDARD TABLE OF lty_product INITIAL SIZE 0,
*
*         BEGIN OF lty_kdkg2_rng,
*           sign   TYPE ddsign,    "Sign
*           option TYPE ddoption,  "Option
*           low    TYPE char3,     "Low
*           high   TYPE char3,     "High
*         END OF lty_kdkg2_rng,
*
*         ltt_kdkg2_rng TYPE STANDARD TABLE OF lty_kdkg2_rng INITIAL SIZE 0,
*
*         BEGIN OF lty_categ,
*           sign   TYPE ddsign,    "Sign
*           option TYPE ddoption,  "Option
*           low    TYPE auart,     "Low
*           high   TYPE auart,     "High
*         END OF lty_categ,
*
*         ltt_categ TYPE STANDARD TABLE OF lty_categ INITIAL SIZE 0.
*
*  DATA: lr_product         TYPE REF TO matnr,                 "Product
*        li_product         TYPE ltt_product,                  "Internal table for Product Number
*        lir_kdkg2_rng      TYPE ltt_kdkg2_rng,                "Range table for customer group
*        lst_kdkg2_rng      TYPE lty_kdkg2_rng,                "Structure for customer group
*        li_connections     TYPE STANDARD TABLE OF toav0,      "Connections table
*        li_data            TYPE crd_t_1024,                   "For passing in FM
*        lv_filename        TYPE string,                       "Filename
*        lv_name            TYPE string,                       "Name
*        lv_extension       TYPE string,                       "Extension
*        lv_count           TYPE sy-index,                     "Count
*        lv_xstring_content TYPE xstring,                      "XSTRING data of PDF
*        li_solix_data      TYPE solix_tab,
*        lst_categ1         TYPE lty_categ,
*        lir_categ1         TYPE ltt_categ,
*        lir_categ2         TYPE ltt_categ,
*        lv_product         TYPE saeobjid,
*        lst_final          TYPE zstqtc_output_supp_retrieval, "Final structure
*        li_final           TYPE ztqtc_output_supp_retrieval.  "Final internal table
*
*  CONSTANTS: lc_cat1    TYPE rvari_vnam VALUE 'DOC_CATEG_SUB', " ABAP: Name of Variant Variable
*             lc_cat2    TYPE rvari_vnam VALUE 'DOC_CATEG_REN', " ABAP: Name of Variant Variable
*             lc_welcome TYPE char50 VALUE 'Welc',              " Welcome of type CHAR50
*             lc_wel     TYPE char50 VALUE 'welc',              " Wel of type CHAR50
*             lc_generic TYPE char50 VALUE 'Generi',            " Generic of type CHAR50
*             lc_gen     TYPE char40 VALUE 'generi',            " Gen of type CHAR40
**            Begin of ADD:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
*             lc_ren_uc  TYPE char50 VALUE 'Ren',               " Generic of type CHAR50
*             lc_ren_lc  TYPE char40 VALUE 'ren',               " Gen of type CHAR40
**            End   of ADD:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
*             lc_devid   TYPE zdevid VALUE 'E098'.              " Development ID
*
** Clear output table
*  CLEAR ex_output[].
*
*
**  IF im_kdkg2 IS INITIAL.
**    lst_kdkg2_rng-sign = c_sign.
**    lst_kdkg2_rng-option = c_option.
**    CONCATENATE c_underscore '00' INTO lst_kdkg2_rng-low.
**    APPEND lst_kdkg2_rng TO lir_kdkg2_rng.
**    CLEAR: lst_kdkg2_rng.
**  ENDIF. " IF im_kdkg1 IS INITIAL
*
** If Product Number and customer group in input is not blank
**  IF im_product_no IS NOT INITIAL.
**    LOOP AT im_product_no REFERENCE INTO lr_product.
**      APPEND lr_product->*  TO li_product.
**      CLEAR lr_product->*.
**    ENDLOOP. " LOOP AT im_product_no REFERENCE INTO lr_product
**    DELETE ADJACENT DUPLICATES FROM li_product COMPARING product.
**
*** Populate Range table for customer group
**    LOOP AT im_kdkg2 INTO DATA(lv_kdkg2).
**      lst_kdkg2_rng-sign = c_sign.
**      lst_kdkg2_rng-option = c_option.
**      lst_kdkg2_rng-low = lv_kdkg2.
**      CONCATENATE c_underscore lst_kdkg2_rng-low INTO lst_kdkg2_rng-low.
**      APPEND lst_kdkg2_rng TO lir_kdkg2_rng.
**      CLEAR: lst_kdkg2_rng,lv_kdkg2.
**    ENDLOOP. " LOOP AT im_kdkg1 INTO DATA(lv_kdkg1)
*
*  SELECT  devid,     " Development ID
*          param1,    " ABAP: Name of Variant Variable
*          param2,    " ABAP: Name of Variant Variable
*          srno ,     " ABAP: Current selection number
*          sign,      " ABAP: ID: I/E (include/exclude values)
*          opti  ,    " ABAP: Selection option (EQ/BT/CP/...)
*          low  ,     " Lower Value of Selection Condition
*          high       " Upper Value of Selection Condition
*    FROM zcaconstant " Wiley Application Constant Table
*    INTO TABLE @DATA(li_constant)
*    WHERE devid = @lc_devid.
*  IF sy-subrc EQ 0.
*    SORT li_constant BY param1.
*    LOOP AT li_constant INTO DATA(lst_constant).
*      CASE lst_constant-param1.
*        WHEN lc_cat1.
*          lst_categ1-sign = c_sign.
*          lst_categ1-option = c_option.
*          lst_categ1-low = lst_constant-low.
*          APPEND lst_categ1 TO lir_categ1.
*          CLEAR lst_categ1.
*        WHEN lc_cat2.
*          lst_categ1-sign = c_sign.
*          lst_categ1-option = c_option.
*          lst_categ1-low = lst_constant-low.
*          APPEND lst_categ1 TO lir_categ2.
*          CLEAR lst_categ1.
*        WHEN OTHERS.
* "No Action
*      ENDCASE.
*    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
*  ENDIF. " IF sy-subrc EQ 0
*
*  IF im_input IS NOT INITIAL.
*    DELETE ADJACENT DUPLICATES FROM im_input COMPARING ALL FIELDS.
*    LOOP AT im_input INTO DATA(lst_product).
*      lst_kdkg2_rng-sign = c_sign.
*      lst_kdkg2_rng-option = c_option.
*      IF lst_product-cust_grp IS INITIAL.
*        lst_kdkg2_rng-low = c_underscore && '00'.
*      ELSE. " ELSE -> IF lst_product-cust_grp IS INITIAL
*        lst_kdkg2_rng-low = c_underscore && lst_product-cust_grp.
*      ENDIF. " IF lst_product-cust_grp IS INITIAL
*      APPEND lst_kdkg2_rng TO lir_kdkg2_rng.
*      CLEAR: lst_kdkg2_rng.
** To get the details of the attachment
*      lv_product = lst_product-product_no.
*      CALL FUNCTION 'ARCHIV_GET_CONNECTIONS'
*        EXPORTING
*          object_id     = lv_product
*        IMPORTING
*          count         = lv_count
*        TABLES
*          connections   = li_connections
*        EXCEPTIONS
*          nothing_found = 1
*          OTHERS        = 2.
*      IF sy-subrc EQ 0.
*        LOOP AT li_connections INTO DATA(lst_connections).
*          DATA(lo_al_item) = NEW cl_arl_al_item( is_connection = lst_connections ). "Attachment Name
*          lst_final-product_no = lst_connections-object_id. "Product Number
*          lst_final-attachment_name = lo_al_item->gp_descr. "Attachment Name
**         PDF Stream
*          IF lv_count > 1.
*            lv_filename = lst_final-attachment_name.
*            CALL FUNCTION 'CH_SPLIT_FILENAME'
*              EXPORTING
*                complete_filename = lv_filename
*              IMPORTING
*                extension         = lv_extension
*                name              = lv_name
*              EXCEPTIONS
*                invalid_drive     = 1
*                invalid_path      = 2
*                OTHERS            = 3.
*            IF sy-subrc = 0.
*              DATA(lv_str_len) = strlen( lv_name ).
*              lv_str_len = lv_str_len - 3.
**              If the KDKG1 value matches with the end of the filename then check lv_flag and select files matching with VBKD-KDKG1
**              else filename_00 will be selected
*              IF lv_str_len > 0 AND
*                 lv_name+lv_str_len(3) IN lir_kdkg2_rng.
*                DATA(lv_flag) = abap_true.
**              ELSEIF lv_name+lv_str_len(3) = '_00'. (--)MODUTTA:03/08/2017:ED2K907718
**                lv_flag = abap_true.
*              ENDIF. " IF lv_str_len > 0 AND
*            ENDIF. " IF sy-subrc = 0
*          ELSE. " ELSE -> IF lv_count > 1
*            lv_flag = abap_true.
*          ENDIF. " IF lv_count > 1
*
*          IF lv_flag IS NOT INITIAL.
**   To get the pdf in binary format using archieve id and archieve document id
*            CALL FUNCTION 'SCMS_AO_TABLE_GET'
*              EXPORTING
*                arc_id       = lst_connections-archiv_id
*                doc_id       = lst_connections-arc_doc_id
*              TABLES
*                data         = li_data
*              EXCEPTIONS
*                error_http   = 1
*                error_archiv = 2
*                error_kernel = 3
*                error_config = 4
*                OTHERS       = 5.
*            IF sy-subrc = 0.
**                PDF Stream
**              Conversion of RAW1024 data to RAW255
*              CALL METHOD cl_rmps_general_functions=>convert_1024_to_255
*                EXPORTING
*                  im_tab_1024 = li_data
*                RECEIVING
*                  re_tab_255  = li_solix_data.
*
**               Conversion of SOLIX_TAB data to XSTRING
*              CALL METHOD cl_bcs_convert=>solix_to_xstring
*                EXPORTING
*                  it_solix   = li_solix_data
*                RECEIVING
*                  ev_xstring = lv_xstring_content.
*
*              lst_final-pdf_stream = lv_xstring_content.
*            ENDIF. " IF sy-subrc = 0
*            APPEND lst_final TO li_final.
*          ENDIF. " IF lv_flag IS NOT INITIAL
*          CLEAR:lst_connections,lv_extension,lst_final,lv_flag.
*        ENDLOOP. " LOOP AT li_connections INTO DATA(lst_connections)
*      ENDIF. " IF sy-subrc EQ 0
*    ENDLOOP. " LOOP AT im_input INTO DATA(lst_product)
*
*    IF im_auart IN lir_categ1.
*      DELETE li_final WHERE attachment_name NS lc_welcome
*                         OR attachment_name NS lc_wel.
*
*    ELSEIF im_auart IN lir_categ2.
**     Begin of DEL:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
**     DELETE li_final WHERE attachment_name NS lc_gen
**                        OR attachment_name NS lc_generic.
**     End   of DEL:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
**     Begin of ADD:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
*      DELETE li_final WHERE attachment_name NS lc_ren_uc
*                         OR attachment_name NS lc_ren_lc.
**     End   of ADD:ERP-XXXX:WROY:28-Mar-2018:ED2K911651
*    ENDIF. " IF im_auart IN lir_categ1
*
*    ex_output[] = li_final[].
*  ENDIF. " IF im_input IS NOT INITIAL
* End   of DEL:ERP-6458:WROY:03-AUG-2018:ED2K912903
ENDFUNCTION.
