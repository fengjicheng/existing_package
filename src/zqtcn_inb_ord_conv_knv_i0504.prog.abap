*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INB_ORD_CONV_KNV
*&---------------------------------------------------------------------*
* REVISION NO   : ED2K926658
* REFERENCE NO  : EAM-8227 / I0504.1
* DEVELOPER     : Vamsi Mamillapalli (VMAMILLAPA)
* DATE          : 04/07/2022
* PROGRAM NAME  : ZQTCN_INB_ORD_CONV_KNV(Include)
*                 Called from IDOC_INPUT_ORDERS CUSTOMER-FUNCTION '001'
* DESCRIPTION   : Data conversion from KNV-SAP
*                 GLN number to customer conversion using EDPAR table
*-------------------------------------------------------------------------*

CONSTANTS:lc_ag_504     TYPE edi3035_a VALUE 'AG',
          lc_we_504     TYPE edi3035_a VALUE 'WE',
          lc_re_504     TYPE edi3035_a VALUE 'RE',
          lc_devid_504  TYPE zdevid    VALUE 'I0504.1',
          lc_idcode_504 TYPE rvari_vnam    VALUE 'IDCODETYPE', " ABAP: Name of Variant Variable
          lc_idoc_i0504 TYPE char30    VALUE '(SAPLVEDA)IDOC_DATA[]'.
"Data declaration
DATA: lst_e1edka1_2 TYPE e1edka1,
      lst_e1edk01_2 TYPE e1edk01,
      li_const_504  TYPE zcat_constants.

"Field Symbol Declaration
FIELD-SYMBOLS:
    <li_idoc_rec_i0504> TYPE edidd_tt.
CASE segment-segnam.
  WHEN 'E1EDK01'.
    lst_e1edk01_2 = segment-sdata.
    IF lst_e1edk01_2-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak.
      lst_xvbak = dxvbak.
      lst_xvbak-bsark = lst_e1edk01_2-bsart.
      dxvbak = lst_xvbak.
      lst_flag1 = dd_flag_k.
      lst_flag1-kbes = abap_true.
      dd_flag_k = lst_flag1.

    ENDIF. " IF lst_e1edk01-bsart IS NOT INITIAL
  WHEN 'E1EDKA1'.
    CLEAR:lst_e1edka1_2.
    lst_e1edka1_2 = segment-sdata.
    DATA(lv_segno) = segment-segnum.
    ASSIGN (lc_idoc_i0504) TO <li_idoc_rec_i0504>.
    IF <li_idoc_rec_i0504> IS ASSIGNED.
*      Assign the segment
      READ TABLE <li_idoc_rec_i0504> ASSIGNING FIELD-SYMBOL(<lfs_i0504>)
      WITH KEY segnum = lv_segno.
      IF   sy-subrc IS INITIAL
       AND  <lfs_i0504> IS ASSIGNED AND <lfs_i0504>-segnam EQ 'E1EDKA1'.
        CASE lst_e1edka1_2-parvw.
          WHEN lc_ag_504 OR lc_we_504 OR lc_re_504.
            DATA(lv_kunnr_in) = CONV kunnr( lst_e1edka1_2-partn ).
*            Check if customer exists in KNA1
            SELECT SINGLE kunnr FROM kna1 INTO @DATA(lv_kna1)
               WHERE kunnr = @lv_kunnr_in.
            IF sy-subrc IS NOT INITIAL.
*              Retrieve the customer number from EDPAR using GLN
              SELECT SINGLE * FROM edpar INTO @DATA(lst_edpar)
                 WHERE parvw = @lst_e1edka1_2-parvw
                 AND expnr = @lst_e1edka1_2-partn.
              IF sy-subrc = 0.
                MOVE lst_edpar-inpnr TO lst_e1edka1_2-partn.
                <lfs_i0504>-sdata = lst_e1edka1_2.
                IF lst_e1edka1_2-parvw EQ lc_ag_504.
*                 Modify XVBAK-KUNNR
                  ASSIGN COMPONENT 'KUNNR' OF STRUCTURE dxvbak TO FIELD-SYMBOL(<lfs_kunnr_1>).
                  IF <lfs_kunnr_1> IS ASSIGNED.
                    <lfs_kunnr_1> = lst_e1edka1_2-partn.
                  ENDIF.
                ENDIF.
*                  Modify customer in address table
                READ TABLE dxvbadr ASSIGNING FIELD-SYMBOL(<lst_xvbadr_504>)
                WITH KEY ('PARVW') = lst_e1edka1_2-parvw.
                IF sy-subrc EQ 0.
                  ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <lst_xvbadr_504> TO <lv_field_value>.
                  IF sy-subrc EQ 0.
                    <lv_field_value> = lst_e1edka1_2-partn.
                  ENDIF.
                ELSE.
                  APPEND INITIAL LINE TO dxvbadr ASSIGNING <lst_xvbadr_504>.
                  ASSIGN COMPONENT 'PARVW' OF STRUCTURE <lst_xvbadr_504> TO <lv_field_value>.
                  IF sy-subrc EQ 0.
                    <lv_field_value> = lst_e1edka1_2-parvw.
                  ENDIF.
                  ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <lst_xvbadr_504> TO <lv_field_value>.
                  IF sy-subrc EQ 0.
                    <lv_field_value> = lst_e1edka1_2-partn.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDIF.
    ENDIF.
  WHEN 'E1EDP19'.
    IF li_const_504 IS INITIAL.
*   Get data from constant table
      SELECT devid                                               "Development ID
             param1                                              "ABAP: Name of Variant Variable
             param2                                              "ABAP: Name of Variant Variable
             srno                                                "ABAP: Current selection number
             sign                                                "ABAP: ID: I/E (include/exclude values)
             opti                                                "ABAP: Selection option (EQ/BT/CP/...)
             low                                                 "Lower Value of Selection Condition
             high                                                "Upper Value of Selection Condition
        FROM zcaconstant                                         "Wiley Application Constant Table
        INTO TABLE li_const_504
        WHERE devid = lc_devid_504.
      IF sy-subrc IS INITIAL.

      ENDIF.
    ENDIF.
*   Get the IDoc data into local work area to process further
    CLEAR lst_e1edp19_st.
    lst_e1edp19_st = segment-sdata.
    IF li_const_504[] IS NOT INITIAL.
      READ TABLE li_const_504 INTO DATA(lst_const_504) WITH KEY devid  = lc_devid_504
                                                  param1 = lc_idcode_504
                                                  param2 = lst_e1edp19_st-qualf.

      IF sy-subrc EQ 0.
        DATA(lv_idcode_504) = CONV ismidcodetype( lst_const_504-low ). " Type of Identification Code
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF
*      Get the VBAP structure data into local work area to process further
    CLEAR lst_xvbap_st.
    lst_xvbap_st = dxvbap.
    DATA(lv_mat_no_504)    = CONV ismidentcode( lst_e1edp19_st-idtnr ). " Legacy Material Number

*   Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lv_idcode_504         " Type of Identification Code
        im_legacy_material = lv_mat_no_504          " Legacy Material Number
      IMPORTING
        ex_sap_material    = lst_xvbap_st-matnr " SAP Material Number
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc EQ 0.
      dxvbap = lst_xvbap_st.
    ENDIF.
ENDCASE.
