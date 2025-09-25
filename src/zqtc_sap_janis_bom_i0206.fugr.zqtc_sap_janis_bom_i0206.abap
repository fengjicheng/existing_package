*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_SAP_TO_JANIS_BOM_I0206                    *
* PROGRAM DESCRIPTION:  Function module to get the BDCP2 unprocessed   *
*                       Change Pointer details against the message Type*
*                       ZQTC_BOMMAT and generate IDoc for every change *
*                       triggered.                                     *
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        25/01/2017                                     *
* OBJECT ID:            I0206                                          *
* TRANSPORT NUMBER(S):  ED2K904011                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904011                                              *
* REFERENCE NO: ERP-1630                                               *
* DEVELOPER: Paramita Bose (PBOSE)                                     *
* DATE:  02/22/2017                                                    *
* DESCRIPTION: Populate valid from date in segment E1STKOM             *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_sap_janis_bom_i0206.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IDOC_CONTROL) LIKE  EDIDC STRUCTURE  EDIDC
*"  TABLES
*"      IDOC_DATA STRUCTURE  EDIDD
*"  EXCEPTIONS
*"      ERROR
*"      IDOC_ERROR
*"----------------------------------------------------------------------

* DO NOT CHANGE EXISTING SEGMENTS IN IDOC_DATA. IT MAY EFFECT THE
* WHOLE BILL OF MATERIAL YOU ARE CURRENTLY DISTRIBUTING.
* DO ONLY ADD OR INSERT YOUR OWN CUSTOMER-SEGMENTS.

* Type declaration for MARA
  TYPES : BEGIN OF lty_mara,
            matnr TYPE matnr, " Material Number
            mtart TYPE mtart, " Material Type
            bismt TYPE bismt, " Old material number
          END OF lty_mara,

*         Typr declaration for MARA
          BEGIN OF lty_mara1,
            matnr        TYPE matnr, " Material Number
            bismt        TYPE bismt, " Old material number
            ismmediatype TYPE ismmediatype,
          END OF lty_mara1,

*         Type declaration for MAKT
          BEGIN OF lty_makt,
            matnr TYPE matnr, " Material Number
            spras TYPE spras, " Language Key
            maktx TYPE maktx, " Material Description (Short Text)
          END OF lty_makt.

* Data Declaration
  DATA : lst_makt     TYPE lty_makt,  " Structure for MAKT
         lst_mara     TYPE lty_mara,  " Structure for MARA
         lst_mara1    TYPE lty_mara1, " Structure for MARA
         lst_e1mastm  TYPE e1mastm,   " Master material BOM
         lst_ze1stpom TYPE ze1stpom,  " Custom BOM Item
         lst_e1stpom  TYPE e1stpom,   " Master BOM Item
         lst_e1stkom  TYPE e1stkom,   " Master BOM (STKO)
         lst_ze1mastm TYPE ze1mastm,  " Custom Material BOM
         lv_andat     TYPE andat,     " Date record created on
         lv_index     TYPE sytabix.   " Line position

* Constant declaration
  CONSTANTS : lc_ze1mastm TYPE edilsegtyp VALUE 'ZE1MASTM', " Custom Material BOM
              lc_ze1stpom TYPE edilsegtyp VALUE 'ZE1STPOM', " Custom BOM Item
              lc_e1stpom  TYPE edilsegtyp VALUE 'E1STPOM',  " Master BOM Item
              lc_e1stkom  TYPE edilsegtyp VALUE 'E1STKOM',  " Segment type
              lc_e1mastm  TYPE edilsegtyp VALUE 'E1MASTM'.  " Master material BOM

* Field-Symbol declare
  FIELD-SYMBOLS : <lst_idoc_data> TYPE edidd. " Data record (IDoc)

* Read IDOC_DATA by segment name
  READ TABLE idoc_data ASSIGNING <lst_idoc_data>
                       WITH KEY segnam = lc_e1mastm.
  IF sy-subrc EQ 0.

*   Setting the heirarchy
    lv_index = sy-tabix + 1.
*   Getting values of IDOC segment E1MASTM to a work area
    lst_e1mastm =  <lst_idoc_data>-sdata. " Get application data

*   Fetch Material Type and Old material number from MARA table
    SELECT SINGLE matnr " Material Number
                  mtart " Material Type
                  bismt " Old material number
    FROM mara           " General Material Data
    INTO lst_mara
    WHERE matnr = lst_e1mastm-matnr.
    IF sy-subrc EQ 0.

*     Fetch Material description from table MAKT.
      SELECT SINGLE matnr " Material Number
                    spras " Language Key
                    maktx " Material Description (Short Text)
             INTO lst_makt
             FROM makt    " Material Descriptions
             WHERE matnr EQ lst_e1mastm-matnr
               AND spras EQ sy-langu.
      IF sy-subrc EQ 0.

*       Populate segment values and segment name for extended segment
        idoc_data-segnam   = lc_ze1mastm. " Append segment name
        lst_ze1mastm-mtart = lst_mara-mtart. " Append material type value to segment
        lst_ze1mastm-maktx = lst_makt-maktx. " Append material text value to segment
        lst_ze1mastm-spras = lst_makt-spras. " Append language value to segment
        lst_ze1mastm-bismt = lst_mara-bismt. " Append old material value to segment

*       Append values to application data
        MOVE lst_ze1mastm TO idoc_data-sdata.
*       Populate child segment (extension) after parent segment
        INSERT idoc_data INDEX lv_index.
        CLEAR lv_index.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

* Begin of change: PBOSE: ERP-1630: 02-22-2017: ED2K904011
  READ TABLE idoc_data ASSIGNING <lst_idoc_data>
                         WITH KEY segnam = lc_e1stkom.
  IF sy-subrc EQ 0.
*   Getting values of IDOC segment E1STKOM to a work area
    lst_e1stkom =  <lst_idoc_data>-sdata. " Get application data

*   Retrieve created on date from MAST table
    SELECT SINGLE andat " Date record created on
      FROM mast         " Material to BOM Link
      INTO lv_andat
      WHERE matnr = lst_e1mastm-matnr
        AND werks = lst_e1mastm-werks
        AND stlan = lst_e1mastm-stlan
        AND stlnr = lst_e1mastm-stlnr
        AND stlal = lst_e1mastm-stlal.
    IF sy-subrc EQ 0.
      lst_e1stkom-datuv = lv_andat. " Valid from date population

*     Append modified values in the segment.
      <lst_idoc_data>-sdata = lst_e1stkom.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* End of change: PBOSE: ERP-1630: 02-22-2017: ED2K904011

* Read table with segment, if present then populate child segment
  LOOP AT idoc_data ASSIGNING <lst_idoc_data> WHERE segnam = lc_e1stpom.

*   Setting the heirarchy
    lv_index = sy-tabix + 1.
*   Getting values of IDOC segment E1MASTM to a work area
    lst_e1stpom =  <lst_idoc_data>-sdata. " Get application data

*   Populate segment values and segment name for extended segment
    idoc_data-segnam = lc_ze1stpom.
*   Fetch Material Type and Old material number from MARA table
    SELECT SINGLE matnr        " Material Number
                  bismt        " Old material number
                  ismmediatype " Media Type
    FROM mara                  " General Material Data
    INTO lst_mara1
    WHERE matnr = lst_e1stpom-idnrk.
    IF sy-subrc EQ 0.

      lst_ze1stpom-matnr_old    = lst_mara1-bismt. " Append material type value to segment
      lst_ze1stpom-ismmediatype = lst_mara1-ismmediatype. " Append material type value to segment

*     Append values to application data
      MOVE lst_ze1stpom TO idoc_data-sdata.
*     Populate child segment (extension) after parent segment
      INSERT idoc_data INDEX lv_index.
      CLEAR : lv_index,
              lst_mara1,
              lst_ze1stpom.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT idoc_data ASSIGNING <lst_idoc_data> WHERE segnam = lc_e1stpom
ENDFUNCTION.
