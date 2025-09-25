*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INB_ORD_BDC_KNV_I0504
*&---------------------------------------------------------------------*
* REVISION NO : ED2K926658                                             *
* REFERENCE NO: EAM-8227                                               *
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)                         *
* DATE        : 04/27/2022                                             *
* DESCRIPTION : Enhancement to populate ship to party reference        *
*               for message code APL                                   *
*----------------------------------------------------------------------*
CONSTANTS: lc_e1edka1_504 TYPE char7 VALUE 'E1EDKA1',          " E1EDKA1_504 of type CHAR7
           lc_we_504      TYPE parvw VALUE 'WE'.                " Partner Function: Ship-to party
*DESCRIBE TABLE dxbdcdata LINES lv_line
DATA:"lst_bdcdata_504 TYPE bdcdata,
  lst_e1edka1_504 TYPE e1edka1,
  li_bdcdata504   TYPE STANDARD TABLE OF bdcdata. " Batch input: New table field structure
DATA(lv_line_504) = lines( dxbdcdata ).
READ TABLE dxbdcdata INTO DATA(lst_bdcdata_504) INDEX lv_line_504.
IF sy-subrc IS INITIAL.
  IF lst_bdcdata_504-fnam = 'BDC_OKCODE' AND
     lst_bdcdata_504-fval = 'SICH'.
    LOOP AT didoc_data INTO DATA(lst_idoc_504) WHERE segnam = lc_e1edka1_504.
      lst_e1edka1_504 = lst_idoc_504-sdata.
      IF lst_e1edka1_504-parvw = lc_we_504.
        DATA(lv_ihrez_e_504) = lst_e1edka1_504-ihrez.
        EXIT.
      ENDIF.
    ENDLOOP.
*    Get ship to reference from E1EDKA1 where PARVW = WE
    IF lv_ihrez_e_504 IS NOT INITIAL.

      CLEAR lst_bdcdata_504.
      lst_bdcdata_504-fnam = 'BDC_OKCODE'.
      lst_bdcdata_504-fval = '=KBES'.
      APPEND lst_bdcdata_504 TO li_bdcdata504. "appending OKCODE

      CLEAR lst_bdcdata_504.
      lst_bdcdata_504-program = 'SAPMV45A'.
      lst_bdcdata_504-dynpro = '4002'.
      lst_bdcdata_504-dynbegin = 'X'.
      APPEND lst_bdcdata_504 TO li_bdcdata504. " appending program and screen

      CLEAR lst_bdcdata_504.
      lst_bdcdata_504-fnam = 'BDC_CURSOR'.
      lst_bdcdata_504-fval = 'VBKD-IHREZ_E'.
      APPEND lst_bdcdata_504 TO li_bdcdata504.

      CLEAR lst_bdcdata_504.
      lst_bdcdata_504-fnam = 'VBKD-IHREZ_E'.
      lst_bdcdata_504-fval = lv_ihrez_e_504.
      APPEND lst_bdcdata_504 TO li_bdcdata504. " Appending Assignment

      CLEAR lst_bdcdata_504.
      lst_bdcdata_504-fnam = 'BDC_OKCODE'.
      lst_bdcdata_504-fval = '/EBACK'.
      APPEND  lst_bdcdata_504 TO li_bdcdata504. "appending OKCODE

    ENDIF. " IF lv_ihrez_e_504 IS NOT INITIAL
    CLEAR:lv_ihrez_e_504.
    lv_line_504 = lines( dxbdcdata ).
    READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lst_bdcdata_504>) INDEX lv_line_504.
    IF <lst_bdcdata_504> IS ASSIGNED.
      <lst_bdcdata_504>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_504> IS ASSIGNED
    INSERT LINES OF li_bdcdata504 INTO dxbdcdata INDEX lv_line_504.
  ENDIF.
  IF lst_bdcdata_504-fnam = 'BDC_OKCODE' AND lst_bdcdata_504-fval = 'OWN_OKCODE'.
    lv_line_504 = lines( dxbdcdata ).
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_504> INDEX lv_line_504.
    IF <lst_bdcdata_504> IS ASSIGNED.
      <lst_bdcdata_504>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_504> IS ASSIGNED
  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'
ENDIF.
