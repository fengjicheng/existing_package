**********************************************************************
* Name     : ljpismdc2                                                *
* Issue    : 10/28/1999 - jw    . - SAP AG, IBU Media                 *
*                                                                     *
* Purpose  : Constant declaration for msd and mpd                     *
*                                                                     *
* Changes  :                                                          *
* [ Date ] - [ Name    ] - [ Action                    ]              *
*
* 16012007 - Kast        - constants for articles addes               *
*
*   /  /   -             -                                            *
************************************************************************
*----------------------------------------------------------------------*
*   INCLUDE LJPISMDC2                                                  *
*----------------------------------------------------------------------*

CONSTANTS: CON_FLAG_YES(1)     TYPE C             VALUE 'X'
         , CON_FLAG_NO(1)      TYPE C             VALUE ' '
         , CON_FLAG_POS(1)     TYPE C             VALUE 'P'
         , CON_FLAG_NEG(1)     TYPE C             VALUE 'N'
         , CON_CHAR_BLANK      TYPE C             VALUE ' '
         , CON_ID_FOUND(10)    TYPE C             VALUE 'ID-FOUND'
         .
CONSTANTS: CON_ON              TYPE C             VALUE '1',
           CON_OFF             TYPE C             VALUE '0'.

CONSTANTS: CON_NUM_CHAR(10)    TYPE C             VALUE '0123456789'
         .


* constants for units and dimensions for table T006D
CONSTANTS:
     CON_DIM_MASS(14)       TYPE C              VALUE '+0+1+0+0+0+0+0'

    ,CON_DIM_AREAWEIGHT(14) TYPE C              VALUE '-2+1+0+0+0+0+0'

    ,CON_DIM_LENGTH(14)     TYPE C              VALUE '+1+0+0+0+0+0+0'

    ,CON_DIM_VOLUME(14)     TYPE C              VALUE '+3+0+0+0+0+0+0'

    ,CON_LENGTH_UNIT_SI     TYPE T006-MSEHI     VALUE 'M'

    ,CON_VOLUME_UNIT_SI     TYPE T006-MSEHI     VALUE 'M3'

    .

* constants for role types
CONSTANTS:
     CON_RLTYP_PUBLISHER   TYPE BU_RLTYPE      VALUE 'BUP000'.

*------------------------------Anfang----------------------"TK16012007
CONSTANTS:  "see T130M
*  Hinzufuegen
     CON_ACTYPE_CREATE_rt  LIKE T130M-AKTYP      VALUE 'N',
*  Veraendern
     CON_ACTYPE_CHANGE_rt  LIKE T130M-AKTYP      VALUE 'C',
*  Anzeigen
     CON_ACTYPE_DISPLAY_rt LIKE T130M-AKTYP      VALUE 'A'.
*------------------------------Ende------------------------"TK16012007

* constants for activity type maintaining media master data
CONSTANTS:
*  Hinzufuegen
     CON_ACTYPE_CREATE  LIKE T130M-AKTYP      VALUE 'H',
*  Veraendern
     CON_ACTYPE_CHANGE  LIKE T130M-AKTYP      VALUE 'V',
*  Anzeigen
     CON_ACTYPE_DISPLAY LIKE T130M-AKTYP      VALUE 'A',
*  Setzen Löschvormerkung
     CON_ACTYPE_DELETE  LIKE T130M-AKTYP      VALUE 'L'.
**  Referenz für Kurztexte
*     con_actype_R  VALUE 'R',
**  Anzeigen alten/neuen Stand
*     con_actype_Z LIKE T130M-AKTYP VALUE 'Z',
**  gepl. Änderung HBK11K094941
*     con_actype_P LIKE T130M-AKTYP VALUE 'P',
**  Ändern Materialart
*     con_actype_M LIKE T130M-AKTYP VALUE 'M',
**  Neuanlegen Material
*     con_actype_N LIKE T130M-AKTYP VALUE 'N',
**  Pflegen Material
*     con_actype_C LIKE T130M-AKTYP VALUE 'C',
**  Anlage mit Vorlage WerkDiBe
*     con_actype_NW LIKE T130M-AKTYP VALUE 'W',
**  Anlage mit Vorlage DiBe
*     con_actype_ND LIKE T130M-AKTYP VALUE 'D'.

* error codes
CONSTANTS: CON_UPDATE_ERROR LIKE SY-SUBRC VALUE 4,
           CON_INSERT_ERROR LIKE SY-SUBRC VALUE 8,
           CON_MODIFY_ERROR LIKE SY-SUBRC VALUE 10,
           CON_DELETE_ERROR LIKE SY-SUBRC VALUE 12,
           CON_BUFFER_WRONG LIKE SY-SUBRC VALUE 16.

* constants for message types
  CONSTANTS: CON_MSG_TYPE_INFO     TYPE SYMSGTY  VALUE 'I'
           , CON_MSG_TYPE_S        TYPE SYMSGTY  VALUE 'S'
           , CON_MSG_TYPE_ERROR    TYPE SYMSGTY  VALUE 'E'
           , CON_MSG_TYPE_WARNING  TYPE SYMSGTY  VALUE 'W'
           .
* constant for message class
  CONSTANTS: CON_MSG_CLASS_JMM     TYPE ARBGB    VALUE 'JMM'.

* constants for type of change (for change documents)
CONSTANTS:
       CON_CT_UPDATE    TYPE C   VALUE 'U'
     , CON_CT_INSERT    TYPE C   VALUE 'I'
     , CON_CT_DELETE    TYPE C   VALUE 'D'
     .
