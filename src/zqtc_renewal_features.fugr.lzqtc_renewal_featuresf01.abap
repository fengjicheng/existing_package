*----------------------------------------------------------------------*
* REPORT NAME:           ZQTC_Z3_QUOTATION_CREATE_CIC
* REPORT DESCRIPTION:    Copy of standard FM ISM_SE_CIC_SAMPLE_CREATE_CONTR
*                        with create quotation(VA21)
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         01/06/2017
* OBJECT ID:             E157
* TRANSPORT NUMBER(S):   ED2K906716(W),ED2K907051
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: JIRA# ERP-3495
* REFERENCE NO: ED2K907476
* DEVELOPER: Writtick roy
* DATE: 03/08/2017
* DESCRIPTION: Change of navigation of screen in VA21
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LJKSEORDER70F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  get_vbap
*&---------------------------------------------------------------------*
*      Read VBAP
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_vbap  USING    vbeln    TYPE vbak-vbeln " Sales Document
               CHANGING vbap_tab TYPE t_vbap_tab.
  FIELD-SYMBOLS <fs> TYPE rjksdorder2. " IS-M: SD Order
  DATA: key          TYPE sales_key,                   " Structure for Mass Accesses to SD Documents
        key_tab      TYPE STANDARD TABLE OF sales_key, " Structure for Mass Accesses to SD Documents
        followup_tab TYPE rjksdorder2_tab.

  key-vbeln = vbeln.
  APPEND key TO key_tab.
  CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
*   EXPORTING
*     I_BYPASSING_BUFFER          = ' '
*     I_REFRESH_BUFFER            =
    TABLES
      it_vbak_key           = key_tab
*     ET_VBAPVB             =
      et_vbap               = vbap_tab
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
    CLEAR vbap_tab[].
  ENDIF. " IF sy-subrc <> 0

* Delete those items that already have a Subsequent item has been created.
  DO.
*   Determine which positions already have a subsequent position
    PERFORM get_followup_items USING    vbap_tab
                               CHANGING followup_tab.
    IF followup_tab[] IS INITIAL.
      EXIT.
    ENDIF. " IF followup_tab[] IS INITIAL
    LOOP AT followup_tab ASSIGNING <fs>.
      DELETE vbap_tab
        WHERE ismprevbeln = <fs>-vbeln AND
              ismpreposnr = <fs>-posnr.
      DELETE vbap_tab
        WHERE vbeln = <fs>-vbeln AND
              posnr = <fs>-posnr.
    ENDLOOP. " LOOP AT followup_tab ASSIGNING <fs>
  ENDDO.
ENDFORM. " get_vbap

*&---------------------------------------------------------------------*
*&      Form  get_next_posnr
*&---------------------------------------------------------------------*
*       Nächste Positionsnummer für Kontrakt bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_next_posnr USING    vbeln      TYPE vbak-vbeln  " Sales Document
                             last_posnr TYPE vbap-posnr  " Sales Document Item
                    CHANGING posnr      TYPE vbap-posnr. " Sales Document Item
  DATA: auart TYPE vbak-auart, " Sales Document Type
        tvak  TYPE tvak.       " Sales Document Types

* Auftragsart bestimmen
  CALL FUNCTION 'ISM_SD_GET_AUART'
    EXPORTING
      in_vbeln  = vbeln
    IMPORTING
      out_auart = auart
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
    CLEAR auart.
  ENDIF. " IF sy-subrc <> 0

* TVAK lesen
  CALL FUNCTION 'ISM_SD_SELECT_SINGLE_TVAK'
    EXPORTING
      auart     = auart
    IMPORTING
      tvak_i    = tvak
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  CHECK sy-subrc = 0.
  IF last_posnr IS INITIAL.
    SELECT MAX( posnr ) INTO posnr FROM vbap " Sales Document: Item Data
      WHERE vbeln = vbeln.
    posnr = posnr + tvak-incpo.
  ELSE. " ELSE -> IF last_posnr IS INITIAL
    posnr = last_posnr + tvak-incpo.
  ENDIF. " IF last_posnr IS INITIAL
ENDFORM. " get_next_posnr

*&---------------------------------------------------------------------*
*&      Form  get_new_items
*&---------------------------------------------------------------------*
*       Neue Positionen bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_new_items TABLES item_tab              STRUCTURE bapisditm
                          item_inx_tab          STRUCTURE bapisditmx
                          contract_data_tab     STRUCTURE bapictr
                          contract_data_inx_tab STRUCTURE bapictrx
                          prepos_tab            STRUCTURE vbap
                   USING  vbeln                 TYPE vbak-vbeln " Sales Document
                          vbap_tab              TYPE t_vbap_tab.
  FIELD-SYMBOLS <fs> TYPE vbap. " Sales Document: Item Data
  DATA: item              TYPE bapisditm,    " Communication Fields: Sales and Distribution Document Item
        item_inx          TYPE bapisditmx,   " Communication Fields: Sales and Distribution Document Item
        posnr             TYPE vbap-posnr,   " Sales Document Item
        last_posnr        TYPE vbap-posnr,   " Sales Document Item
        contract_data     TYPE bapictr,      " Communciation Fields: SD Contract Data
        contract_data_inx TYPE bapictrx,     " Communication fields: SD Contract Data Checkbox
        venddat           TYPE veda-venddat, " Contract end date
        prepos            TYPE vbap.         " Sales Document: Item Data

* Rückgabewerte initialisieren
  CLEAR: item_tab[],
         item_inx_tab[],
         contract_data_tab[],
         contract_data_inx_tab[],
         prepos_tab[].
  LOOP AT vbap_tab ASSIGNING <fs>.
*   Vertragsende der Vorgänderposition bestimmen
    PERFORM get_valid_until USING    vbeln
                                     <fs>-posnr
                            CHANGING venddat.
    CHECK NOT venddat IS INITIAL.
*   ansonsten macht es keinen Sinn eine weitere Position anzulegen
    PERFORM get_next_posnr USING    vbeln
                                    last_posnr
                           CHANGING posnr.
    last_posnr      = posnr.
    item-itm_number = posnr.
    item-material   = <fs>-matnr.
    item-item_categ = 'JWKN'.

    item_inx-itm_number = posnr.
    item_inx-updateflag = ''. "Anlegen einer neuen Vertriebsbelegposition
    APPEND item TO item_tab.
    APPEND item_inx TO item_inx_tab.

*   Vertragsanfang festlegen
    contract_data-itm_number     = posnr.
    contract_data-con_st_dat     = venddat + 1.
    contract_data_inx-itm_number = posnr.
    APPEND contract_data TO contract_data_tab.
    APPEND contract_data_inx TO contract_data_inx_tab.

*   Information über Vorgängerposition vermerken
    prepos-posnr       = posnr.
    prepos-ismprevbeln = vbeln.
    prepos-ismpreposnr = <fs>-posnr.
    APPEND prepos TO prepos_tab.
  ENDLOOP. " LOOP AT vbap_tab ASSIGNING <fs>
ENDFORM. " get_new_items

*&---------------------------------------------------------------------*
*&      Form  get_valid_until
*&---------------------------------------------------------------------*
*       Vertragsende der Position (vbeln, posnr) bestimmen
*----------------------------------------------------------------------*
*       ..
*----------------------------------------------------------------------*
FORM get_valid_until  USING    vbeln   TYPE vbap-vbeln    " Sales Document
                               posnr   TYPE vbap-posnr    " Sales Document Item
                      CHANGING venddat TYPE veda-venddat. " Contract end date

  SELECT SINGLE venddat INTO venddat FROM veda " Contract Data
    WHERE vbeln = vbeln AND
          vposn = posnr.
  IF sy-subrc <> 0.
    CLEAR venddat.
  ENDIF. " IF sy-subrc <> 0
ENDFORM. " get_valid_until

*&---------------------------------------------------------------------*
*&      Form  book_prepos_tab
*&---------------------------------------------------------------------*
*       Verbuchen der Beziehung Vorgänger/Nacholgeposition
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM book_prepos_tab TABLES pos_tab STRUCTURE vbap.
  FIELD-SYMBOLS <fs> TYPE vbap. " Sales Document: Item Data

  LOOP AT pos_tab ASSIGNING <fs>.
    UPDATE vbap SET ismprevbeln = <fs>-ismprevbeln
                    ismpreposnr = <fs>-ismpreposnr
      WHERE vbeln = <fs>-ismprevbeln AND
            posnr = <fs>-posnr.
  ENDLOOP. " LOOP AT pos_tab ASSIGNING <fs>
ENDFORM. " book_prepos_tab

*&---------------------------------------------------------------------*
*&      Form  get_followup_items
*&---------------------------------------------------------------------*
*       Diejenigen Positionen bestimmen, die bereits eine Folgeposition
*       haben
*----------------------------------------------------------------------*
*       ..
*----------------------------------------------------------------------*
FORM get_followup_items  USING    vbap_tab     TYPE t_vbap_tab
                         CHANGING followup_tab TYPE rjksdorder2_tab.
  FIELD-SYMBOLS <fs> TYPE vbap. " Sales Document: Item Data
  DATA: followup    TYPE rjksdorder2,      " IS-M: SD Order
        no_preposnr TYPE vbap-ismpreposnr. " IS-M: Indicates Previous Item

  CLEAR followup_tab[].
  LOOP AT vbap_tab ASSIGNING <fs>
    WHERE ismpreposnr <> no_preposnr.
    followup-posnr = <fs>-ismpreposnr.
    followup-vbeln = <fs>-vbeln.
    APPEND followup TO followup_tab.
  ENDLOOP. " LOOP AT vbap_tab ASSIGNING <fs>
ENDFORM. " get_followup_items

*&---------------------------------------------------------------------*
*&      Form  get_items
*&---------------------------------------------------------------------*
*       Neue Kontraktpositionen zur Vbeln bestimmen
*----------------------------------------------------------------------*
*       ..
*----------------------------------------------------------------------*
FORM get_items  USING    vbeln        TYPE vbak-vbeln " Sales Document
                CHANGING out_line_tab TYPE rjksecontractcic_tab.
  FIELD-SYMBOLS <fs> TYPE vbap. " Sales Document: Item Data
  DATA: vbap_tab TYPE STANDARD TABLE OF vbap, " Sales Document: Item Data
        veda_tab TYPE STANDARD TABLE OF veda, " Contract Data
        veda     TYPE veda,                   " Contract Data
        line     TYPE rjksecontractcic.       " IS-M: Structure for CIC ISP Field List

* VBAP lesen
  SELECT vbeln posnr matnr zmeng zieme ismprevbeln ismpreposnr
    INTO CORRESPONDING FIELDS OF TABLE vbap_tab FROM vbap " Sales Document: Item Data
    WHERE vbeln = vbeln.

* Gültigkeit bestimmen
  SELECT vbeln vposn vbegdat venddat INTO CORRESPONDING FIELDS
    OF TABLE veda_tab FROM veda " Contract Data
    WHERE vbeln = vbeln.
  SORT veda_tab BY vbeln vposn.
  SORT vbap_tab BY vbeln posnr.

* Aufbau der Darstellungsdaten
  LOOP AT vbap_tab ASSIGNING <fs>.
    CLEAR line.
    MOVE-CORRESPONDING <fs> TO line. "#EC ENHOK
    line-prevbeln = <fs>-ismprevbeln.
    IF line-prevbeln IS INITIAL. line-prevbeln = <fs>-vbeln. ENDIF.
    line-preposnr = <fs>-ismpreposnr.
    line-product  = <fs>-matnr.
    line-quantity = <fs>-zmeng.
    line-unit     = <fs>-zieme.
    READ TABLE veda_tab INTO veda
      WITH KEY vbeln = <fs>-vbeln
               vposn = <fs>-posnr BINARY SEARCH.
    IF sy-subrc = 0.
      line-valid_from  = veda-vbegdat.
      line-valid_until = veda-venddat.
    ENDIF. " IF sy-subrc = 0
    APPEND line TO out_line_tab.
  ENDLOOP. " LOOP AT vbap_tab ASSIGNING <fs>
ENDFORM. " get_items

*&---------------------------------------------------------------------*
*&      Form  get_contract_items
*&---------------------------------------------------------------------*
*       Kontraktpositonen zum Auftrag bestimmen.
*       Der Parameter order_items ist gleich 'X', wenn im Auftrag
*       vbeln auch Auftragspositionen enthalten sind, ansonsten initial.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_contract_items  USING    vbeln       TYPE vbak-vbeln " Sales Document
                         CHANGING vbap_tab    TYPE t_vbap_tab
                                  order_items TYPE c.         " Items of type Character
  FIELD-SYMBOLS <fs> TYPE t_vbap.
  DATA: key                TYPE sales_key,                   " Structure for Mass Accesses to SD Documents
        key_tab            TYPE STANDARD TABLE OF sales_key, " Structure for Mass Accesses to SD Documents
        contract_matnr_tab TYPE STANDARD TABLE OF mara.      " General Material Data

* Initialisierung
  CLEAR order_items.
  key-vbeln = vbeln.
  APPEND key TO key_tab.
  CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
*   EXPORTING
*     I_BYPASSING_BUFFER          = ' '
*     I_REFRESH_BUFFER            =
    TABLES
      it_vbak_key           = key_tab
*     ET_VBAPVB             =
      et_vbap               = vbap_tab
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
    CLEAR vbap_tab[].
  ENDIF. " IF sy-subrc <> 0

* Lösche diejenigen Positionen heraus, die keine Kontraktpositionen sind.
* Kontraktpositionen werden dadurch erkannt, dass das Material den
* Hierarchielevel '2' hat.
  SELECT matnr INTO CORRESPONDING FIELDS OF TABLE contract_matnr_tab FROM mara " General Material Data
    FOR ALL ENTRIES IN vbap_tab
    WHERE matnr           = vbap_tab-matnr AND
          ismhierarchlevl = '2'.
  SORT contract_matnr_tab BY matnr.
  DELETE ADJACENT DUPLICATES FROM contract_matnr_tab.

  LOOP AT vbap_tab ASSIGNING <fs>.
    READ TABLE contract_matnr_tab WITH KEY matnr = <fs>-matnr TRANSPORTING NO FIELDS.
    CHECK sy-subrc <> 0.
    DELETE vbap_tab.
    order_items = 'X'.
  ENDLOOP. " LOOP AT vbap_tab ASSIGNING <fs>
ENDFORM. " get_contract_items

*&---------------------------------------------------------------------*
*&      Form  create_contract
*&---------------------------------------------------------------------*
*       Kontrakt zu den Daten aus VBAP_TAB anlegen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM create_contract  USING    order_vbeln    TYPE vbap-vbeln  " Sales Document
                               order_item_tab TYPE t_vbap_tab
                      CHANGING contract_vbeln TYPE vbak-vbeln. " Sales Document
  FIELD-SYMBOLS: <pa> TYPE vbpa, " Sales Document: Partner
                 <od> TYPE t_vbap.
  DATA: header            TYPE bapisdhd1,                         " Communication Fields: Sales and Distribution Document Header
        header_inx        TYPE bapisdhd1x,                        " Checkbox Fields for Sales and Distribution Document Header
        item_tab          TYPE STANDARD TABLE OF bapisditm,       " Communication Fields: Sales and Distribution Document Item
        item              TYPE bapisditm,                         " Communication Fields: Sales and Distribution Document Item
        item_inx_tab      TYPE STANDARD TABLE OF bapisditmx,      " Communication Fields: Sales and Distribution Document Item
        item_inx          TYPE bapisditmx,                        " Communication Fields: Sales and Distribution Document Item
        partner_tab       TYPE STANDARD TABLE OF bapiparnr,       " Communications Fields: SD Document Partner: WWW
        partner           TYPE bapiparnr,                         " Communications Fields: SD Document Partner: WWW
        order_partner_tab TYPE STANDARD TABLE OF vbpa,            " Sales Document: Partner
        head_posnr        TYPE vbap-posnr,                        " Sales Document Item
        vbak              TYPE vbak,                              " Sales Document: Header Data
        pos_number        TYPE REF TO cl_ism_sd_order_pos_number, " IS-M: Determine Item Number in Order
        return_tab        TYPE STANDARD TABLE OF bapiret2.        " Return Parameter

  CHECK NOT  order_item_tab[] IS INITIAL.
  header-doc_type       = 'JWK1'.
  header_inx-updateflag = 'I'.
* Vertriebsbereich bestimmen
  PERFORM get_vbak USING    order_vbeln
                   CHANGING vbak.
  header-sales_org  = vbak-vkorg.
  header-distr_chan = vbak-vtweg.
  header-division   = vbak-spart.
* Aufbau der Parnter auf Kopfebene
  SELECT kunnr parvw posnr INTO CORRESPONDING FIELDS OF TABLE order_partner_tab
    FROM vbpa " Sales Document: Partner
      WHERE vbeln = order_vbeln.
  LOOP AT order_partner_tab ASSIGNING <pa>
    WHERE posnr = head_posnr.
    partner-partn_role = <pa>-parvw.
    partner-partn_numb = <pa>-kunnr.
    APPEND partner TO partner_tab.
  ENDLOOP. " LOOP AT order_partner_tab ASSIGNING <pa>
* Aufbau der Positionsdaten
  CREATE OBJECT pos_number
    EXPORTING
      doc_type = header-doc_type.
  LOOP AT order_item_tab ASSIGNING <od>.
*   Positionsnummer bestimmen
    CALL METHOD pos_number->get
      IMPORTING
        posnr = item-itm_number.
*   Material und Menge
    item-material   = <od>-matnr.
    item-target_qty = <od>-kwmeng.
    item-target_qu  = <od>-kmein.
    APPEND item TO item_tab.
*   und die zugehörigen Partner bestimmen
    LOOP AT order_partner_tab ASSIGNING <pa>
      WHERE posnr = <od>-posnr.
      partner-itm_number = item-itm_number.
      partner-partn_role = <pa>-parvw.
      partner-partn_numb = <pa>-kunnr.
      APPEND partner TO partner_tab.
    ENDLOOP. " LOOP AT order_partner_tab ASSIGNING <pa>
  ENDLOOP. " LOOP AT order_item_tab ASSIGNING <od>
  CALL FUNCTION 'BAPI_CONTRACT_CREATEFROMDATA'
    EXPORTING
*     salesdocumentin     =
      contract_header_in  = header
      contract_header_inx = header_inx
*     SENDER              =
*     BINARY_RELATIONSHIPTYPE       = ' '
*     INT_NUMBER_ASSIGNMENT         = ' '
*     BEHAVE_WHEN_ERROR   = ' '
*     LOGIC_SWITCH        =
*     TESTRUN             =
*     CONVERT             = ' '
    IMPORTING
      salesdocument       = contract_vbeln
    TABLES
      return              = return_tab
      contract_items_in   = item_tab
      contract_items_inx  = item_inx_tab
      contract_partners   = partner_tab
*     CONTRACT_CONDITIONS_IN        =
*     CONTRACT_CONDITIONS_INX       =
*     CONTRACT_CFGS_REF   =
*     CONTRACT_CFGS_INST  =
*     CONTRACT_CFGS_PART_OF         =
*     CONTRACT_CFGS_VALUE =
*     CONTRACT_CFGS_BLOB  =
*     CONTRACT_CFGS_VK    =
*     CONTRACT_CFGS_REFINST         =
*     CONTRACT_DATA_IN    =
*     CONTRACT_DATA_INX   =
*     CONTRACT_TEXT       =
*     CONTRACT_KEYS       =
*     EXTENSIONIN         =
*     PARTNERADDRESSES    =
    .
ENDFORM. " create_contract

*&---------------------------------------------------------------------*
*&      Form  remove_items_from_order
*&---------------------------------------------------------------------*
*       Positionen aus remove_tab aus Auftrag entfernen. Der komplette
*       Auftrag ist von der Datenbank zu löschen, wenn
*       not_delete_complete_order initial ist.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM remove_items_from_order  USING    order                     TYPE vbap-vbeln " Sales Document
                                       remove_tab                TYPE t_vbap_tab
                                       not_delete_complete_order TYPE c.         " Delete_complete_order of type Character
  FIELD-SYMBOLS <fs> TYPE t_vbap.
  DATA: header       TYPE bapisdhead1,                   " Communication Fields: Sales and Distribution Document Header
        header_inx   TYPE bapisdhead1x,                  " Checkbox Fields for Sales and Distribution Document Header
        item_inx_tab TYPE STANDARD TABLE OF bapisditemx, " Communication Fields: Sales and Distribution Document Item
        item_inx     TYPE bapisditemx,                   " Communication Fields: Sales and Distribution Document Item
        return_tab   TYPE STANDARD TABLE OF bapiret2.    " Return Parameter

  IF not_delete_complete_order IS INITIAL.
    header_inx-updateflag = 'D'.
  ELSE. " ELSE -> IF not_delete_complete_order IS INITIAL
    header_inx-updateflag = 'U'.
* Alle Positionen in der Tabelle remove_tab sind im Auftrag zu löschen
    LOOP AT remove_tab ASSIGNING <fs>.
      item_inx-itm_number = <fs>-posnr.
      item_inx-updateflag = 'D'.
      APPEND item_inx TO item_inx_tab.
    ENDLOOP. " LOOP AT remove_tab ASSIGNING <fs>
  ENDIF. " IF not_delete_complete_order IS INITIAL
  CALL FUNCTION 'BAPI_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument    = order
      order_header_in  = header
      order_header_inx = header_inx
*     SIMULATION       = ' '
    TABLES
      return           = return_tab
*     ITEM_IN          =
      item_inx         = item_inx_tab
*     SCHEDULE_IN      =
*     SCHEDULE_INX     =
*     SALES_CFGS_REF   =
*     SALES_CFGS_INST  =
*     SALES_CFGS_PART_OF       =
*     SALES_CFGS_VALUE =
*     SALES_CFGS_BLOB  =
    .
ENDFORM. " remove_items_from_order

*&---------------------------------------------------------------------*
*&      Form  get_vbak
*&---------------------------------------------------------------------*
*       VBAK zum Auftrag lesen
*----------------------------------------------------------------------*
*       ..
*----------------------------------------------------------------------*
FORM get_vbak  USING    vbeln TYPE vbak-vbeln " Sales Document
               CHANGING vbak  TYPE vbak.      " Sales Document: Header Data

  CALL FUNCTION 'SD_VBAK_SINGLE_READ'
    EXPORTING
      i_vbeln          = vbeln
*     I_BYPASSING_BUFFER       = ' '
*     I_REFRESH_BUFFER =
    IMPORTING
      e_vbak           = vbak
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    CLEAR vbak.
  ENDIF. " IF sy-subrc <> 0
ENDFORM. " get_vbak
*&---------------------------------------------------------------------*
*&      Form  F_CALL_VA21
*&---------------------------------------------------------------------*
*       Call VA21 screen
*----------------------------------------------------------------------*
FORM f_call_va21 USING fp_lv_auart TYPE auart " Sales Document Type
                       fp_in_contract_tab TYPE rjksdorder2_tab
                       fp_in_line_tab TYPE rjksecontractcic_tab.
  DATA: lv_date TYPE char10.

  READ TABLE fp_in_contract_tab INTO DATA(lst_contract_tab) INDEX 1.
  IF sy-subrc EQ 0.
    DATA(lv_contract) = lst_contract_tab-vbeln.
  ENDIF. " IF sy-subrc EQ 0

  WRITE sy-datum to lv_date.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '0101'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VBAK-AUART'.
  PERFORM bdc_field       USING 'VBAK-AUART'
                                fp_lv_auart.
* Begin of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=COPY'.
* End   of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476

  PERFORM bdc_dynpro      USING 'SAPLV45C' '0100'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LV45C-VBELN'.
* Begin of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=RKON'.
* End   of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476

  PERFORM bdc_dynpro      USING 'SAPLV45C' '0100'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LV45C-VBELN'.
  PERFORM bdc_field       USING 'LV45C-VBELN'
                                lv_contract.
  PERFORM bdc_field       USING 'LV45C-KETDAT'
                                lv_date.
  PERFORM bdc_field       USING 'LV45C-KPRGBZ'
                                'D'.

  CALL TRANSACTION 'VA21' USING bdcdata
* Begin of DEL:ERP-3495:WROY:03-AUG-2017:ED2K907476
*                  MODE   'A'
* End   of DEL:ERP-3495:WROY:03-AUG-2017:ED2K907476
* Begin of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476
                   MODE   'E'
* End   of ADD:ERP-3495:WROY:03-AUG-2017:ED2K907476
                   UPDATE 'S'
                   MESSAGES INTO messtab.
  CLEAR: lv_contract,
         bdcdata[],
         messtab[].
ENDFORM.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF. " IF fval <> space
ENDFORM.
