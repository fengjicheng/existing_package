
*&-------------------------------------------------------------------------------*
*&  Include           ZQTCN_APL_DELIV_IN_I0510
*&-------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_APL_DELIV_IN_I0510                                 *
* PROGRAM DESCRIPTION : Include to update the text Cancellation Reason population*
*                       Inbound IDOC for Outbound delivery from WMS to SAP ECC   *
* DEVELOPER           : Sivarami Isireddy                                        *
* CREATION DATE       : 05/10/2022                                               *
* OBJECT ID           : I0510 / EAM-7074                                         *
* TRANSPORT NUMBER(S) : ED2K926908                                               *
*--------------------------------------------------------------------------------*

*Structures and Internal Tables
DATA:lst_thead   TYPE thead,
     lst_tline   TYPE tline,
     lst_e1txth8 TYPE e1txth8,
     lst_e1txtp8 TYPE e1txtp8,
     lst_e1txth9 TYPE e1txth9,
     lst_e1txtp9 TYPE e1txtp9,
     li_thead    TYPE STANDARD TABLE OF thead INITIAL SIZE 0,
     li_tlines   TYPE STANDARD TABLE OF tline INITIAL SIZE 0.
*Constants
CONSTANTS:lc_zw_seqnam_hd  TYPE edilsegtyp VALUE 'E1TXTH8'.
CONSTANTS:lc_zw_seqnam_tp  TYPE edilsegtyp VALUE 'E1TXTP8'.
CONSTANTS:lc_zw_seqnam_hdi TYPE edilsegtyp VALUE 'E1TXTH9'.
CONSTANTS:lc_zw_seqnam_tpi TYPE edilsegtyp VALUE 'E1TXTP9'.

*Header Text for Cancelation Reason
CLEAR:lst_e1txth8,
      lst_e1txtp8.
READ TABLE idoc_data[] INTO DATA(lst_idocdata_i0510) WITH KEY segnam = lc_zw_seqnam_hd.
IF sy-subrc EQ 0.
  CLEAR:lst_thead.
  lst_e1txth8  = lst_idocdata_i0510-sdata.
  lst_thead-tdobject = lst_e1txth8-tdobject.
  lst_thead-tdname   = lst_e1txth8-tdobname.
  lst_thead-tdid     = lst_e1txth8-tdid.
  lst_thead-tdspras  = lst_e1txth8-tdspras.
*  APPEND lst_thead TO li_thead .
*  CLEAR:lst_thead.
  READ TABLE idoc_data[] INTO DATA(lst_idocdata_i0510t) WITH KEY segnam = lc_zw_seqnam_tp.
  IF sy-subrc EQ 0.
   lst_e1txtp8 = lst_idocdata_i0510t-sdata.
    lst_tline-tdformat = lst_e1txtp8-tdformat.
    lst_tline-tdline   = lst_e1txtp8-tdline.
    APPEND lst_tline TO li_tlines.
    CLEAR:lst_tline.
  ENDIF.
  CALL FUNCTION 'SAVE_TEXT'
    EXPORTING
      client          = sy-mandt
      header          = lst_thead
      insert          = abap_true
      savemode_direct = abap_true
    IMPORTING
      newheader       = lst_thead
    TABLES
      lines           = li_tlines[]
    EXCEPTIONS
      id              = 1
      language        = 2
      name            = 3
      object          = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
** WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*ITEM TEXT for Cancelation Reason.
  LOOP AT idoc_data[] INTO DATA(lst_idocdata_i0510i) WHERE segnam = lc_zw_seqnam_hdi.
    REFRESH:li_tlines[],
            li_thead[].
    CLEAR:lst_thead.
    DATA(lv_index) = sy-tabix + 1.
    READ TABLE idoc_data[] INTO DATA(lst_idocdata_i0510ti) INDEX lv_index.
    IF sy-subrc EQ 0 AND lst_idocdata_i0510ti-segnam = lc_zw_seqnam_tpi.
      lst_e1txth9  = lst_idocdata_i0510i-sdata.
      lst_thead-tdobject = lst_e1txth9-tdobject.
      lst_thead-tdname   = lst_e1txth9-tdobname.
      lst_thead-tdid     = lst_e1txth9-tdid.
      lst_thead-tdspras  = lst_e1txth9-tdspras.
      lst_e1txtp9 = lst_idocdata_i0510ti-sdata.
      lst_tline-tdformat = lst_e1txtp9-tdformat.
      lst_tline-tdline   = lst_e1txtp9-tdline.
      APPEND lst_tline TO li_tlines.
      CLEAR:lst_tline.
      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          client          = sy-mandt
          header          = lst_thead
          insert          = abap_true
          savemode_direct = abap_true
        IMPORTING
          newheader       = lst_thead
        TABLES
          lines           = li_tlines[]
        EXCEPTIONS
          id              = 1
          language        = 2
          name            = 3
          object          = 4
          OTHERS          = 5.
      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
** WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      ENDIF.
  ENDLOOP.
ENDIF.
