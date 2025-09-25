*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_EXPIRE_ORD_WOA_E229
* PROGRAM DESCRIPTION : Idoc generation &  release order
* DEVELOPER           : NPOLINA
* CREATION DATE       : 23/Jan/2020
* OBJECT ID           : I0378
* TRANSPORT NUMBER(S) : ED2K917365.
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01. "Selection Criteria
SELECT-OPTIONS:
  s_auart   FOR vbak-auart          OBLIGATORY, "Sales Document Type
  s_pstyv   FOR vbap-pstyv          OBLIGATORY. "Sales document item category
*  s_enddt   FOR veda-venddat        OBLIGATORY . " Contract end date
PARAMETERS: p_enddt   TYPE veda-venddat       OBLIGATORY . " Contract end date
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02. "Further Parameters
PARAMETERS:
  p_mestyp TYPE edidc-mestyp   DEFAULT text-s03 , " Message Type               'ORDERS'
  p_mescod TYPE edidc-mescod   DEFAULT text-s04 , " Logical Message Variant    'Z25'
  p_mesfct TYPE edidc-mesfct   DEFAULT text-s05 . " Logical message function   'TOK'
SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_auart TYPE vbak-auart     DEFAULT text-s06 , " Sales Document Type        'ZOAC'
  p_kschl TYPE konv-kschl     DEFAULT text-s07 , " Condition Type             'ZTRL'
  p_bstkd TYPE vbkd-bstkd     DEFAULT text-s22 . " Customer Purchase Order No 'UNUSED TOKENS'
SELECTION-SCREEN END OF BLOCK b2.
