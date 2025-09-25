*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0230_20_1
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916358
* REFERENCE NO:  I0230.20
* DEVELOPER:     NPOLINA (Nageswara)
* DATE:          2019-10-03
* DESCRIPTION:   ZACO Order Change with Message Variant Z22.
*-------------------------------------------------------------------
DATA: lv_idoc_z22    TYPE char30 VALUE '(SAPLVEDB)IDOC_DATA[]', " Idoc_i0341 of type CHAR30
      lst_e1edp35_n1 TYPE e1edp35,
      lv_id          TYPE char50.

FIELD-SYMBOLS:<li_idoc_rec_n1>  TYPE edidd_tt.
STATICS:v_mvgr3      TYPE vbap-mvgr3,
        lv_docnum_t1 TYPE edi_docnum,
        lv_flag_n2   TYPE char1.
CONSTANTS:lc_e1edp35_n1 TYPE char7 VALUE 'E1EDP35',
          lc_id         TYPE char10 VALUE 'I230_Z22'.

*---Static Variable clearing based on DOCNUM field (IDOC Number)..
ASSIGN (lv_idoc_z22) TO <li_idoc_rec_n1>.
IF <li_idoc_rec_n1> IS ASSIGNED.
  READ TABLE <li_idoc_rec_n1> INTO DATA(lst_edidd_230_1) INDEX 1.
  IF sy-subrc = 0.
    IF lv_docnum_t1 NE lst_edidd_230_1-docnum.
      FREE:lv_flag_n2,v_mvgr3,lv_docnum_t1.
      lv_docnum_t1  = lst_edidd_230_1-docnum.
    ENDIF.
  ENDIF.
ENDIF.
IF lv_flag_n2 IS INITIAL.
  ASSIGN (lv_idoc_z22) TO <li_idoc_rec_n1>.
* Read Customer Group 3 value from E1EDP35 segment to update Parent Item Customer Group3 in additional Tab A
  READ TABLE <li_idoc_rec_n1> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_n1>)
                                      WITH KEY segnam     = lc_e1edp35_n1
                                          sdata+0(3) = '003'.
  IF sy-subrc = 0.
    lst_e1edp35_n1 = <lst_idoc_rec_n1>-sdata.
    v_mvgr3 = lst_e1edp35_n1-cusadd.
    CONCATENATE <lst_idoc_rec_n1>-docnum lc_id INTO lv_id.
    EXPORT v_mvgr3 TO MEMORY ID lv_id.
    DELETE <li_idoc_rec_n1> INDEX sy-tabix.
    lv_flag_n2 = abap_true.
  ENDIF.
ENDIF.
