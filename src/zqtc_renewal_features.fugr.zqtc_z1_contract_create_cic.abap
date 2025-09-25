FUNCTION zqtc_z1_contract_create_cic .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IN_KUNNR) TYPE  KUNNR
*"     REFERENCE(IN_CONTRACT_TAB) TYPE  RJKSDORDER2_TAB
*"     REFERENCE(IN_LINE_TAB) TYPE  RJKSECONTRACTCIC_TAB
*"  EXPORTING
*"     REFERENCE(OUT_LINE_TAB) TYPE  RJKSECONTRACTCIC_TAB
*"     REFERENCE(OUT_CHANGED_BOR_OBJECTS_TAB) TYPE  TRL_BORID
*"----------------------------------------------------------------------
************************************************************************
* Beispielfunktionsbaustein zur Anlage einer Normalposition zu einer
* vorgehenden befristeten Position.
* Die befristete Position wird in der Transaktion va41 angelegt. Diese
* Transaktion wird via call transaction aufgerugen. Anschliessend wird eine
* unbefristete Folgeposition angelegt.

*  Local constant declaration
  CONSTANTS: lc_order TYPE rvari_vnam VALUE 'ORDER_TYPE_CONT'. " ABAP: Name of Variant Variable

  DATA: vbeln             TYPE vbak-vbeln,                   " Sales Document
        header            TYPE bapisdh1,                     " Communication Fields: SD Order Header
        header_inx        TYPE bapisdh1x,                    " Checkbox List: SD Order Header
        item              TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        item_inx          TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
        return            TYPE bapiret2,                     " Return Parameter
        return_tab        TYPE STANDARD TABLE OF bapiret2,   " Return Parameter
        vbap_tab          TYPE t_vbap_tab,
        vbap              TYPE vbap,                         " Sales Document: Item Data
        contract_data     TYPE STANDARD TABLE OF bapictr,    " Communciation Fields: SD Contract Data
        contract_data_inx TYPE STANDARD TABLE OF bapictrx,   " Communication fields: SD Contract Data Checkbox
        prepos_tab        TYPE STANDARD TABLE OF vbap,       " Sales Document: Item Data
        bor               TYPE borident,                     " Object Relationship Service: BOR object identifier
        lv_auart          TYPE auart.                        " Sales Document Type

* Rückgabewerte initialiseren
  CLEAR: out_changed_bor_objects_tab[],
         out_line_tab[].

* Get data from ZCACONSTANT
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid = c_devid.
  IF sy-subrc EQ 0.
    SORT i_constant BY param1.
  ENDIF. " IF sy-subrc EQ 0

*Get the order type for creating quotation with reference to subscription order
  READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = lc_order
                                                BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_auart = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Verkaufsbelegart festlegen, mit der Kontrakt anzulegen ist
  SET PARAMETER ID 'KTT' FIELD lv_auart.
  SET PARAMETER ID 'VFR' FIELD vbeln.
* AG vorbelegen:
  SET PARAMETER ID 'VAU' FIELD in_kunnr.
* Aufruf der Transaktion va41
  CALL TRANSACTION 'VA41'. " and skip first screen.
* nach dem Ende der Transaktion va41 per Set/Get-Parameter bearbeiteten
* Kontrakt bestimmen
  GET PARAMETER ID 'VFR' FIELD vbeln.
* Prüfe, dass auch wirklich ein Kontrakt angelegt wurde
  CHECK NOT vbeln IS INITIAL.

* VBAP zum Kontrakt lesem
  PERFORM get_vbap USING    vbeln
                   CHANGING vbap_tab.

* Für alle Einträge aus vbap_tab neue Positionen erzeugen
  PERFORM get_new_items TABLES item[]
                               item_inx[]
                               contract_data[]
                               contract_data_inx[]
                               prepos_tab[]
                        USING  vbeln
                               vbap_tab.

  header_inx-updateflag = 'U'.
  DO.
    CALL FUNCTION 'BAPI_CUSTOMERCONTRACT_CHANGE'
      EXPORTING
        salesdocument       = vbeln
        contract_header_in  = header
        contract_header_inx = header_inx
*       SIMULATION          =
*       BEHAVE_WHEN_ERROR   = ' '
*       INT_NUMBER_ASSIGNMENT       = ' '
*       LOGIC_SWITCH        =
      TABLES
        return              = return_tab[]
        contract_item_in    = item[]
        contract_item_inx   = item_inx[]
*       PARTNERS            =
*       PARTNERCHANGES      =
*       PARTNERADDRESSES    =
*       conditions_in       =
*       conditions_inx      =
*       CONTRACT_CFGS_REF   =
*       CONTRACT_CFGS_INST  =
*       CONTRACT_CFGS_PART_OF       =
*       CONTRACT_CFGS_VALUE =
*       CONTRACT_CFGS_BLOB  =
*       CONTRACT_CFGS_VK    =
*       CONTRACT_CFGS_REFINST       =
*       CONTRACT_TEXT       =
        contract_data_in    = contract_data[]
        contract_data_inx   = contract_data_inx[]
*       CONTRACT_KEYS       =
*       EXTENSIONIN         =
      .
    IF NOT return_tab[] IS INITIAL.
      READ TABLE return_tab INDEX 1 INTO return.
      IF NOT return-id     = 'V1' AND
         NOT return-number = '042'.
        EXIT.
      ENDIF. " IF NOT return-id = 'V1' AND
    ELSE. " ELSE -> IF NOT return_tab[] IS INITIAL
      EXIT.
    ENDIF. " IF NOT return_tab[] IS INITIAL
  ENDDO.
* Verbuchung abwarten
  COMMIT WORK AND WAIT.
* IS-M Beziehung Vorgänger/Nachfolgeposition verbuchen
  PERFORM book_prepos_tab TABLES prepos_tab.
* Aufbau der out_line_tab
  PERFORM get_items USING    vbeln
                    CHANGING out_line_tab[].

* Geändertes BorObjekt zurückgegeben
  bor-objkey  = vbeln.
  bor-objtype = 'BUS2034'. "Kontrakt
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = bor-logsys
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.

  APPEND bor TO out_changed_bor_objects_tab.
ENDFUNCTION.
