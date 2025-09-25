*&---------------------------------------------------------------------*
*&  Include           ZQTC_DIGI_DATA_INT_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ICEDIS_SUB
* PROGRAM DESCRIPTION: Report to upload a text file onto application
*                      layer for Digital Entitlement Data Interface
*                      sent to TIBCO                                   *
* DEVELOPER:           NMOUNIKA
* CREATION DATE:       07/07/2017
* OBJECT ID:           I0342
* TRANSPORT NUMBER(S): ED2K906926
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909770
* REFERENCE NO: ERP-5456
* DEVELOPER: Writtick Roy (WROY)
* DATE: 08-Dec-2017
* DESCRIPTION: Filter for R2-Materials only (Material Types)
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:    ED2K912399                                           *
* REFERENCE NO:   CR#6689/6609                                         *
* DEVELOPER:      SCBEZAWADA                                           *
* DATE:           06/22/2018                                           *
* DESCRIPTION:    To handle User Interface and BOM related Changes     *
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918160
* REFERENCE NO: ERPM-6517
* DEVELOPER: Lahiru Wathudura(LWATHUDURA)
* DATE: 05/08/2020
* DESCRIPTION: Add acquisition order to the flat file with given validity period
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
* Subroutine to fetch data
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data CHANGING fp_i_mara          TYPE tt_mara
                           fp_i_vapma         TYPE tt_vapma
                           fp_i_vbpa          TYPE tt_vbpa
                           fp_i_vbkd          TYPE tt_vbkd
                           fp_i_jptidcdassign TYPE tt_jptidcdassign
                           fp_i_zcaconstant   TYPE tt_const.

  TYPES : ltt_mstae      TYPE RANGE OF mstae,         " Cross-Plant Material Status
          ltt_idcodetype TYPE RANGE OF ismidcodetype. " Type of Identification Code
  CONSTANTS: lc_mstae      TYPE rvari_vnam VALUE 'MSTAE', " ABAP: Name of Variant Variable
             lc_auart      TYPE rvari_vnam VALUE 'AUART', " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
             lc_mtart      TYPE rvari_vnam VALUE 'MTART', " ABAP: Name of Variant Variable
*            End   of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
             lc_idcodetype TYPE rvari_vnam VALUE 'IDCODETYPE',
             lc_bom_hdr    TYPE posnr VALUE '000000'. "CR#6609:22 Jun 2018:SCBEZAWADA:ED2K912399
*Local internal table declaration
  DATA: lir_mstae      TYPE ltt_mstae,
        lir_idcodetype TYPE ltt_idcodetype,
        lir_ord_type   TYPE fip_t_auart_range,
*       Begin of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
        lir_mat_type   TYPE fip_t_mtart_range,
*       End   of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
        lst_mstae      TYPE LINE OF ltt_mstae,
        lst_idcodetype TYPE LINE OF ltt_idcodetype,
        lst_ord_type   TYPE fip_s_auart_range,
*       Begin of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
        lst_mat_type   TYPE fip_s_mtart_range,
*       End   of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
        li_veda        TYPE tt_veda,
        li_vapma       TYPE tt_vapma.

*--------------------------------------------------------------------*
  LOOP AT fp_i_zcaconstant INTO DATA(lst_const).
    CASE lst_const-param1.
      WHEN lc_mstae.
        lst_mstae-sign    = lst_const-sign.
        lst_mstae-option  = lst_const-opti.
        lst_mstae-low     = lst_const-low.
        lst_mstae-high    = lst_const-high.
        APPEND lst_mstae TO lir_mstae.
        CLEAR lst_mstae.

      WHEN lc_idcodetype.
        lst_idcodetype-sign    = lst_const-sign.
        lst_idcodetype-option  = lst_const-opti.
        lst_idcodetype-low     = lst_const-low.
        lst_idcodetype-high    = lst_const-high.
        APPEND lst_idcodetype TO lir_idcodetype.
        CLEAR lst_idcodetype.

      WHEN lc_auart.
        lst_ord_type-sign    = lst_const-sign.
        lst_ord_type-option  = lst_const-opti.
        lst_ord_type-low     = lst_const-low.
        lst_ord_type-high    = lst_const-high.
        APPEND lst_ord_type TO lir_ord_type.
        CLEAR lst_ord_type.

*     Begin of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
      WHEN lc_mtart.
        lst_mat_type-sign    = lst_const-sign.
        lst_mat_type-option  = lst_const-opti.
        lst_mat_type-low     = lst_const-low.
        lst_mat_type-high    = lst_const-high.
        APPEND lst_mat_type TO lir_mat_type.
        CLEAR lst_mat_type.
*     End   of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
    ENDCASE.
  ENDLOOP. " LOOP AT fp_i_zcaconstant INTO DATA(lst_const)
*--------------------------------------------------------------------*
  CLEAR: fp_i_mara.
  SELECT matnr    " Material Number
         mstae    " Cross-Plant Material Status
         ismtitle " Title
    FROM mara   " General Material Data
    INTO TABLE fp_i_mara
   WHERE mstae IN lir_mstae
*    Begin of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
     AND mtart IN lir_mat_type.
*    End   of ADD:ERP-5456:WROY:08-Dec-2017:ED2K909770
  IF sy-subrc IS INITIAL AND fp_i_mara IS NOT INITIAL.
    SORT fp_i_mara BY matnr.

*Selection from JPTIDCDASSIGN
    SELECT matnr         " Material Number
           identcode     " Identification Code
           idcodetype    " Type of Identification Code
      FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
      INTO TABLE fp_i_jptidcdassign
       FOR ALL ENTRIES IN fp_i_mara
     WHERE matnr EQ fp_i_mara-matnr
       AND idcodetype IN lir_idcodetype.
    IF sy-subrc IS  INITIAL.
      SORT fp_i_jptidcdassign BY matnr.
    ENDIF . " IF sy-subrc IS INITIAL

*Selection from VAPMA
    SELECT matnr " Material Number
           kunnr " Sold-to party
           vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
      FROM vapma " Sales Index: Order Items by Material
      INTO TABLE fp_i_vapma
       FOR ALL ENTRIES IN fp_i_mara
     WHERE matnr EQ fp_i_mara-matnr
       AND auart IN lir_ord_type
       AND kunnr EQ p_kunnr.
    IF sy-subrc EQ 0.
      SORT fp_i_vapma BY matnr vbeln posnr.

      li_vapma[] = fp_i_vapma[].
      SORT li_vapma BY vbeln.
      DELETE ADJACENT DUPLICATES FROM li_vapma
             COMPARING vbeln.
      "BOC CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
      SELECT vbeln,
             posnr,
             uepos
        FROM vbap
        INTO TABLE @DATA(li_vbap)
        FOR ALL ENTRIES IN @li_vapma
        WHERE vbeln EQ @li_vapma-vbeln.
      IF sy-subrc IS INITIAL.
        SORT li_vbap BY vbeln posnr uepos.
      ENDIF.
      "EOC CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399

      SELECT vbeln   " Sales Document
             vposn   " Sales Document Item
             vbegdat " Contract start date
             venddat " Contract end date
        FROM veda      " Contract Data
        INTO TABLE li_veda
         FOR ALL ENTRIES IN li_vapma
       WHERE vbeln EQ li_vapma-vbeln.
      IF sy-subrc EQ 0.
        SORT li_veda BY vbeln vposn.

        LOOP AT fp_i_vapma ASSIGNING FIELD-SYMBOL(<lst_vapma>).
*        Veda condition is needed for the beg dat and end dat scenario(restricted in select statement)
          READ TABLE li_veda ASSIGNING FIELD-SYMBOL(<lst_veda>)
               WITH KEY vbeln = <lst_vapma>-vbeln
                        vposn = <lst_vapma>-posnr
               BINARY SEARCH.
          IF sy-subrc NE 0.
            READ TABLE li_veda ASSIGNING <lst_veda>
                 WITH KEY vbeln = <lst_vapma>-vbeln
                          vposn = c_posnr_hdr
                 BINARY SEARCH.
          ENDIF.
          IF sy-subrc EQ 0.
*** Begin of Changes by Lahiru on 05/08/2020 for ERPM-6517 with ED2K918160 ***
*** Begin of Comment by Lahiru on on 05/08/2020 ****
*            IF <lst_veda>-vbegdat GT sy-datum OR
*               <lst_veda>-venddat LT sy-datum.
*              CLEAR: <lst_vapma>-vbeln.
*            ENDIF.
*** End of Comment by Lahiru on on 05/08/2020 ****
            IF s_valdat-high IS INITIAL.                    " Check the "To Validity date" is null
              IF <lst_veda>-vbegdat GT s_valdat-low OR      " Check the date range based on "From Validity date"
                 <lst_veda>-venddat LT s_valdat-low.
                CLEAR: <lst_vapma>-vbeln.
              ENDIF.
            ELSE.                                           " Consider validity date range
              IF <lst_veda>-vbegdat GT s_valdat-high OR <lst_veda>-venddat LT s_valdat-low.
                CLEAR: <lst_vapma>-vbeln.
              ENDIF.
            ENDIF.
*** End of Changes by Lahiru on 05/08/2020 for ERPM-6517 with ED2K918160 ***
          ELSE.
            CLEAR: <lst_vapma>-vbeln.
          ENDIF.
          "BOADD CR#6609:22 Jun 2018:SCBEZAWADA:ED2K912399
          READ TABLE li_vbap WITH KEY vbeln = <lst_vapma>-vbeln
                                      posnr = <lst_vapma>-posnr
                                      uepos = lc_bom_hdr
                                      TRANSPORTING NO FIELDS
                                      BINARY SEARCH.
          IF sy-subrc IS NOT INITIAL.
            "looks like this line is BOM child item
            "Only BOM Headers must be send, filter the child lines
            "EOADD CR#6609:22 Jun 2018:SCBEZAWADA:ED2K912399
            CLEAR: <lst_vapma>-vbeln.
          ENDIF.

        ENDLOOP.
        DELETE fp_i_vapma WHERE vbeln IS INITIAL.

      ELSE.
        CLEAR: fp_i_vapma.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

    IF fp_i_vapma[] IS NOT INITIAL.
      li_vapma[] = fp_i_vapma[].
      SORT li_vapma BY vbeln.
      DELETE ADJACENT DUPLICATES FROM li_vapma
             COMPARING vbeln.

*Selection from VBKD  " Sales Document: Business Data
      SELECT vbeln " Sales and Distribution Document Number
             posnr " Item number of the SD document
             bstkd " Customer purchase order number
             ihrez " Your Reference
        FROM vbkd  " Sales Document: Business Data
        INTO TABLE fp_i_vbkd
         FOR ALL ENTRIES IN li_vapma
       WHERE vbeln EQ li_vapma-vbeln.
      IF sy-subrc IS INITIAL.
        SORT fp_i_vbkd BY vbeln posnr.
      ENDIF. " IF sy-subrc IS INITIAL

*Selection from VBPA
      SELECT vbeln     " Sales and Distribution Document Number
             posnr     " Item number of the SD document
             parvw     " Partner Function
             kunnr     " Customer Number
             adrnr     " Address
        FROM vbpa " Sales Document: Partner
        INTO TABLE fp_i_vbpa
         FOR ALL ENTRIES IN li_vapma
       WHERE vbeln EQ li_vapma-vbeln
         AND parvw EQ c_parvw_sp.
      IF sy-subrc IS INITIAL.
        SORT fp_i_vbpa BY vbeln posnr.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc IS INITIAL AND fp_i_mara IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
* Subroutine to process the data for final table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_data USING   fp_i_mara          TYPE  tt_mara
                            fp_i_vapma         TYPE  tt_vapma
                            fp_i_vbpa          TYPE  tt_vbpa
                            fp_i_vbkd          TYPE  tt_vbkd
                   CHANGING fp_i_final         TYPE  tt_final
                            fp_i_jptidcdassign TYPE  tt_jptidcdassign.


*====================================================================*
*  Local Variable
*====================================================================*
* Data declaration
  DATA: lst_final TYPE ty_final,
        lv_tabix  TYPE sy-tabix, " ABAP System Field: Row Index of Internal Tables
        lv_line   TYPE c LENGTH 315.   " Address line

  LOOP AT fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>).
    CLEAR: lst_final.

    lst_final-matnr    = <lst_mara>-matnr.
    lst_final-ismtitle = <lst_mara>-ismtitle.
    READ TABLE fp_i_jptidcdassign ASSIGNING FIELD-SYMBOL(<lst_jptidcdassign>)
         WITH KEY matnr = <lst_mara>-matnr
         BINARY SEARCH.
    IF  sy-subrc IS INITIAL.
      lst_final-identcode = <lst_jptidcdassign>-identcode.
    ENDIF. " IF sy-subrc IS INITIAL

    READ TABLE fp_i_vapma TRANSPORTING NO FIELDS
         WITH KEY matnr = <lst_mara>-matnr
         BINARY SEARCH.
    IF sy-subrc = 0.
      lv_tabix = sy-tabix.
      LOOP AT fp_i_vapma ASSIGNING FIELD-SYMBOL(<lst_vapma>) FROM lv_tabix. "Avoiding Where clause
        IF <lst_vapma>-matnr <> <lst_mara>-matnr. "This checks whether to exit out of loop
          EXIT.
        ENDIF. " IF <lst_vapma>-matnr <> <lst_mara>-matnr

* Read table vbkd to populate
        READ TABLE fp_i_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
             WITH KEY vbeln = <lst_vapma>-vbeln
                      posnr = <lst_vapma>-posnr
             BINARY SEARCH.
        IF sy-subrc NE 0.
* Populate purchase order document number
          READ TABLE fp_i_vbkd ASSIGNING <lst_vbkd>
               WITH KEY vbeln = <lst_vapma>-vbeln
                        posnr = c_posnr_hdr
               BINARY SEARCH.
        ENDIF.
        IF sy-subrc EQ 0.
          lst_final-bstkd = <lst_vbkd>-bstkd.
          lst_final-ihrez = <lst_vbkd>-ihrez.
        ENDIF. " IF sy-subrc EQ 0

        READ TABLE fp_i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
             WITH KEY vbeln = <lst_vapma>-vbeln
                      posnr = <lst_vapma>-posnr
             BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE fp_i_vbpa ASSIGNING <lst_vbpa>
               WITH KEY vbeln = <lst_vapma>-vbeln
                        posnr = c_posnr_hdr
               BINARY SEARCH.
        ENDIF.
        IF sy-subrc EQ 0.
          CLEAR: i_printform_table.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = <lst_vbpa>-adrnr
            IMPORTING
              address_printform_table        = i_printform_table
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc = 0.
            CLEAR: lv_line.
            LOOP AT i_printform_table INTO DATA(lst_printform).
              IF lst_printform-address_line IS NOT INITIAL.
                IF lv_line IS INITIAL.
                  lv_line = lst_printform-address_line.
                ELSE. " ELSE -> IF lv_count = 1
                  CONCATENATE lv_line
                              lst_printform-address_line
                         INTO lv_line
                    SEPARATED BY ','.
                ENDIF. " IF lv_count = 1
              ENDIF. " IF lst_printform-address_line IS NOT INITIAL
            ENDLOOP. " LOOP AT i_printform_table INTO DATA(lst_printform)
* Implement suitable error handling here
          ENDIF. " IF sy-subrc = 0
          lst_final-kunnr = lv_line.
          CLEAR: lv_line.
        ENDIF. " IF sy-subrc EQ 0
        APPEND lst_final TO fp_i_final.
        CLEAR: lst_final-bstkd,
               lst_final-kunnr,
               lst_final-ihrez.
      ENDLOOP. " LOOP AT fp_i_vapma ASSIGNING FIELD-SYMBOL(<lst_vapma>) FROM lv_tabix
    ELSE. " ELSE -> IF sy-subrc = 0
      APPEND lst_final TO fp_i_final.
      CLEAR: lst_final.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>)

  IF fp_i_final IS NOT INITIAL.
    SORT fp_i_final BY matnr.
  ENDIF. " IF i_final IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA
*&---------------------------------------------------------------------*
* Subroutine to upload data
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_data.
  DATA: lv_data        TYPE string,
        lst_final      TYPE ty_final,
        lst_final_temp TYPE ty_final,
        lv_path_fname  TYPE string,
        lv_flag        TYPE char1,                                          " Flag of type CHAR1
        lv_tab         TYPE c VALUE cl_abap_char_utilities=>horizontal_tab. " Tab of type Character

  CLEAR lv_path_fname.
* Want to make sure filename is not missed in any case if they try to run in background
* in batch job scenario if they give file path in the selection screen.
  CONCATENATE p_path
              v_filenm
              c_underscore
              p_kunnr
              c_underscore
              sy-datum
              c_underscore
              sy-uzeit
              c_extn
              INTO
             lv_path_fname.
  CONDENSE lv_path_fname NO-GAPS.

  OPEN DATASET lv_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0

* Build Record type 1
  CONCATENATE 'Record Type'(001)
              'Material- Journal'(019)
              'Journal Title'(020)
              'ID Code'(047)
         INTO lv_data
    SEPARATED BY lv_tab.
  TRANSFER lv_data TO lv_path_fname.
  CLEAR: lv_data.
* Build Record type 2
  CONCATENATE 'Record Type'(001)
              'Agent Purchase Order no.'(048)
              'Publisher sub ref.'(055)
              'Ship to party'(056)
              'ID Code'(047)
              'Material'(057)
         INTO lv_data
    SEPARATED BY lv_tab.
  TRANSFER lv_data TO lv_path_fname.
  CLEAR: lv_data.

  LOOP AT i_final INTO lst_final.
    lst_final_temp = lst_final.
    AT NEW matnr.
      CONCATENATE c_1
                  lst_final_temp-matnr
                  lst_final_temp-ismtitle
                  lst_final_temp-identcode
             INTO lv_data
        SEPARATED BY lv_tab.
      TRANSFER lv_data TO lv_path_fname.
      CLEAR: lv_data.
    ENDAT.

* Build Record type 2
    IF lst_final-kunnr IS NOT INITIAL.
      CONCATENATE c_2
                  lst_final_temp-bstkd
                  lst_final_temp-ihrez
                  lst_final_temp-kunnr
                  lst_final_temp-identcode
                  lst_final_temp-matnr
             INTO lv_data
        SEPARATED BY lv_tab.
      TRANSFER lv_data TO lv_path_fname.
      CLEAR: lv_data.
    ENDIF. " IF lst_final-kunnr IS NOT INITIAL
    CLEAR : lst_final, lst_final_temp.
  ENDLOOP. " LOOP AT i_final INTO lst_final

* Close the file
  CLOSE DATASET lv_path_fname.
  IF sy-subrc IS INITIAL.
    MESSAGE s003.
    LEAVE LIST-PROCESSING.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    MESSAGE s088 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALUE_REQUEST_FOR_APPL_FILE
*&---------------------------------------------------------------------*
* Subroutine for the F4 help of file path
*----------------------------------------------------------------------*
*      <--P_P_PATH  text
*----------------------------------------------------------------------*
FORM f_value_request_for_appl_file CHANGING fp_p_path TYPE localfile. " Local file for upload/download
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = ' '
    IMPORTING
      serverfile       = v_localfile
    EXCEPTIONS
      canceled_by_user = 1.

  IF sy-subrc <> 0.
    MESSAGE e220 . "Unable to process
  ENDIF. " IF sy-subrc <> 0
  fp_p_path = v_localfile.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VAR_GET_CONST
*&---------------------------------------------------------------------*
*  To Clear all global varibles internal tables work-area
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_var_get_const .
*--------------------------------------------------------------------*
* Clear all global varibles internal tables work-area
*--------------------------------------------------------------------*
  CLEAR:i_vbpa,
        i_vbkd,
        i_mara,
        i_jptidcdassign,
        i_final,
        v_filepath,
        v_filenm,
        v_kunnr.
*--------------------------------------------------------------------*
*  get filename
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LAST_RUN_DT

*&---------------------------------------------------------------------*
*&      Form  POPULATE_PATH
*&---------------------------------------------------------------------*
* To populate the path
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_path CHANGING fp_p_path TYPE localfile " Local file for upload/download
                            fp_i_zcaconstant TYPE tt_const.
  DATA: lst_zcaconstant TYPE LINE OF tt_const.
  CONSTANTS: lc_devid    TYPE zdevid     VALUE 'I0352',     " Development ID
             lc_i        TYPE tvarv_sign VALUE 'I',         " ABAP: ID: I/E (include/exclude values)
             lc_eq       TYPE rvari_vnam VALUE 'EQ',        " ABAP: Selection option (EQ/BT/CP/...)
             lc_ed       TYPE rvari_vnam VALUE 'ED',        " ABAP: Name of Variant Variable
             lc_ep       TYPE rvari_vnam VALUE 'EP',        " ABAP: Name of Variant Variable
             lc_param1   TYPE rvari_vnam VALUE 'APPL_SERV', " ABAP: Name of Variant Variable
             lc_filepath TYPE rvari_vnam VALUE 'FILEPATH',  " ABAP: Name of Variant Variable
             lc_param2   TYPE rvari_vnam VALUE 'FILENAME',  " ABAP: Name of Variant Variable
             lc_srno     TYPE tvarv_numb VALUE '01'.        " ABAP: Current selection number

  IF fp_p_path IS INITIAL.

    SELECT param1      " ABAP: Name of Variant Variable
           param2      " ABAP: Name of Variant Variable
           srno        " ABAP: Current selection number
           sign        " ABAP: ID: I/E (include/exclude values)
           opti        " ABAP: Selection option (EQ/BT/CP/...)
           low         " Lower Value of Selection Condition
           high        " Upper Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO TABLE fp_i_zcaconstant
      WHERE devid  = lc_devid
        AND activate = abap_true.
    IF sy-subrc EQ 0.
      SORT i_zcaconstant BY param1
                            param2.

      IF sy-sysid+0(2) = lc_ed.
        READ TABLE i_zcaconstant INTO lst_zcaconstant
             WITH KEY param1 = lc_filepath
                      param2 = lc_ed
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          v_filepath = lst_zcaconstant-low.
          v_filenm   = lst_zcaconstant-high.
          fp_p_path  = v_filepath .
        ELSE. " ELSE -> IF sy-subrc IS INITIAL
          MESSAGE e225.
          CLEAR: v_filepath, v_filenm.

        ENDIF. " IF sy-subrc IS INITIAL
      ELSEIF sy-sysid+0(2) = lc_eq.
        CLEAR: lst_zcaconstant,
               v_filepath.
        READ TABLE i_zcaconstant INTO lst_zcaconstant
             WITH KEY param1 = lc_filepath
                      param2 = lc_eq
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          v_filepath = lst_zcaconstant-low.
          v_filenm   = lst_zcaconstant-high.
          fp_p_path  = v_filepath .
        ELSE. " ELSE -> IF sy-subrc IS INITIAL
          MESSAGE e225.
          CLEAR: v_filepath, v_filenm.

        ENDIF. " IF sy-subrc IS INITIAL
      ELSEIF sy-sysid+0(2) = lc_ep.
        CLEAR: lst_zcaconstant,
               v_filepath.
        READ TABLE i_zcaconstant INTO lst_zcaconstant
             WITH KEY param1 = lc_filepath
                      param2 = lc_ep
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          v_filepath = lst_zcaconstant-low.
          v_filenm   = lst_zcaconstant-high.
          fp_p_path  = v_filepath .
        ELSE. " ELSE -> IF sy-subrc IS INITIAL
          MESSAGE e225.
          CLEAR: v_filepath, v_filenm.

        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-sysid+0(2) = lc_ed
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_p_path IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
* Validation of selection screen values
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data .

***Validation of customer number
  IF p_kunnr IS NOT INITIAL.
    SELECT SINGLE kunnr " Customer Number
       FROM kna1        " General Data in Customer Master
       INTO @DATA(lv_kunnr)
       WHERE kunnr EQ @p_kunnr.
    IF sy-subrc <> 0.
      MESSAGE e226. "Customer Number doesn't exist
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF p_kunnr IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALUE_REQ_PRES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_PATH  text
*----------------------------------------------------------------------*
FORM f_value_req_pres  CHANGING fp_p_path TYPE localfile. " Local file for upload/download
  DATA: lv_file TYPE string.

  CALL METHOD cl_salv_test_data=>select_file
    IMPORTING
      filename = lv_file.

  fp_p_path = lv_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA_PS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_data_ps .
*Move complete file path to file name
  DATA : lv_path_fname  TYPE string,
         lv_data        TYPE string,
         lv_tab         TYPE c VALUE cl_abap_char_utilities=>horizontal_tab, " Tab of type Character
         lst_final      TYPE ty_final,
         lst_final_temp TYPE ty_final,
         li_final_txt   TYPE stringtab.

* Build Record type 1
  CONCATENATE 'Record Type'(001)
              'Material- Journal'(019)
              'Journal Title'(020)
              'ID Code'(047)
         INTO lv_data
    SEPARATED BY lv_tab.
  APPEND lv_data TO li_final_txt.
  CLEAR: lv_data.
* Build Record type 2
  CONCATENATE 'Record Type'(001)
              'Agent Purchase Order no.'(048)
              'Publisher sub ref.'(055)
              'Ship to party'(056)
              'ID Code'(047)
              'Material'(057)
         INTO lv_data
    SEPARATED BY lv_tab.
  APPEND lv_data TO li_final_txt.
  CLEAR: lv_data.

  LOOP AT i_final INTO lst_final.
    lst_final_temp = lst_final.
    AT NEW matnr.
      CONCATENATE c_1
                  lst_final_temp-matnr
                  lst_final_temp-ismtitle
                  lst_final_temp-identcode
             INTO lv_data
        SEPARATED BY lv_tab.
      APPEND lv_data TO li_final_txt.
      CLEAR: lv_data.
    ENDAT.

* Build Record type 2
    IF lst_final-kunnr IS NOT INITIAL.
      CONCATENATE c_2
                  lst_final_temp-bstkd
                  lst_final_temp-ihrez
                  lst_final_temp-kunnr
                  lst_final_temp-identcode
                  lst_final_temp-matnr
             INTO lv_data
        SEPARATED BY lv_tab.
      APPEND lv_data TO li_final_txt.
      CLEAR: lv_data.
    ENDIF. " IF lst_final-kunnr IS NOT INITIAL
    CLEAR : lst_final, lst_final_temp.
  ENDLOOP. " LOOP AT i_final INTO lst_final

*Download the internal table data into a file in SAP presentation server

* BOC ----- Adding extension to the path if the path is not Given. CR# 6689:22 Jun 2018:SCBEZAWADA:ED2K912399
  IF  v_path NS '.txt' AND v_path IS NOT INITIAL.
    CONCATENATE v_path '.txt' INTO v_path.
  ENDIF.

  lv_path_fname = v_path.
* EOC ----- CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename = lv_path_fname
    TABLES
      data_tab = li_final_txt.

ENDFORM.
