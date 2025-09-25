class ZCL_IM_QTCBI_PROCESS_PO definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_PROCESS_PO_CUST .
protected section.
private section.

  types:
    BEGIN OF ty_constants,
      devid	 TYPE zdevid,              "Development ID
      param1 TYPE rvari_vnam,          "ABAP: Name of Variant Variable
      param2 TYPE rvari_vnam,          "ABAP: Name of Variant Variable
      srno   TYPE tvarv_numb,          "ABAP: Current selection number
      sign   TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
      opti   TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
      low    TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
      high   TYPE salv_de_selopt_high, "Upper Value of Selection Condition
    END OF ty_constants .
  types:
    tt_constants TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0 .
  types:
    BEGIN OF ty_eban,
           banfn TYPE banfn,  " Purchase Requisition Number
           bnfpo TYPE  bnfpo, " Item Number of Purchase Requisition
           bsart TYPE bbsrt,  " Purchase Requisition Document Type
           matnr TYPE  matnr, " Material Number
           menge TYPE bamng,  " Purchase Requisition Quantity
           meins TYPE bamei,  " Purchase Requisition Unit of Measure
         END OF ty_eban .
  types:
    tt_eban type STANDARD TABLE OF ty_eban INITIAL SIZE 0 .

  constants C_WRICEF_ID_E143 type ZDEVID value 'E143' ##NO_TEXT. " Development ID
  constants C_SER_NUM_2_E143 type ZSNO value '002' ##NO_TEXT. " Development ID " Serial Number
  data I_CONSTANTS type TT_CONSTANTS .
  data ST_MAT_DETL type MARA . " General Material Data
  data V_FIRST_PRINT type FLAG . " General Flag
  data I_EBAN type TT_EBAN .
  data I_EBAN_NB type TT_EBAN .
  data V_MAT_OLD type MATNR .
  data V_DROPSHIP_FG type FLAG .
  data V_CONF_QUNT type BSTMG .
  data V_ITM_QTY type BSTMG .
  data V_NETPR type BPREI .
ENDCLASS.



CLASS ZCL_IM_QTCBI_PROCESS_PO IMPLEMENTATION.


  METHOD if_ex_me_process_po_cust~check.
*----------------------------------------------------------------------*
* PROGRAM NAME        : IF_EX_ME_PROCESS_PO_CUST~CHECK                 *
* PROGRAM DESCRIPTION : Purchase Order Enhancement                     *
* An enhancement has done in standard SAP purchase orders to meet      *
* Wiley’s business requirements for Printer purchase order  and        *
* distributor purchase order processes.                                *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*

    DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = c_wricef_id_e143
          im_ser_num     = c_ser_num_2_e143
        IMPORTING
          ex_active_flag = lv_actv_flag_e143.

      IF lv_actv_flag_e143 EQ abap_true.
        INCLUDE zqtcn_purch_ord_enh_check IF FOUND.
      ENDIF. " IF lv_actv_flag_e143 EQ abap_true

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~CLOSE.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM_REFKEYS.
  endmethod.


  METHOD if_ex_me_process_po_cust~initialize.
*----------------------------------------------------------------------*
* PROGRAM NAME        : if_ex_me_process_po_cust~initialize            *
* PROGRAM DESCRIPTION : Purchase Order Enhancement                     *
* An enhancement has done in standard SAP purchase orders to meet      *
* Wiley’s business requirements for Printer purchase order  and        *
* distributor purchase order processes.                                *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------
    DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e143
        im_ser_num     = c_ser_num_2_e143
      IMPORTING
        ex_active_flag = lv_actv_flag_e143.

    IF lv_actv_flag_e143 EQ abap_true.
      INCLUDE zqtcn_purch_ord_enh_init IF FOUND.
    ENDIF. " IF lv_actv_flag_e143 EQ abap_true

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~OPEN.
*----------------------------------------------------------------------*
* PROGRAM NAME        : if_ex_me_process_po_cust~initialize            *
* PROGRAM DESCRIPTION : Purchase Order Enhancement                     *
* An enhancement has done in standard SAP purchase orders to meet      *
* Wiley’s business requirements for Printer purchase order  and        *
* distributor purchase order processes.                                *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------
    DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e143
        im_ser_num     = c_ser_num_2_e143
      IMPORTING
        ex_active_flag = lv_actv_flag_e143.

    IF lv_actv_flag_e143 EQ abap_true.
      INCLUDE zqtcn_purch_ord_enh_open IF FOUND.
    ENDIF. " IF lv_actv_flag_e143 EQ abap_true
  endmethod.


  METHOD if_ex_me_process_po_cust~post.

    INCLUDE /idt/purchasing_badi_post. " Include for BADI ME_PROCESS_PO_CUST, method post()

*----------------------------------------------------------------------*
* PROGRAM NAME        : IF_EX_ME_PROCESS_PO_CUST~POST          *
* PROGRAM DESCRIPTION : Enhance Purchase Order                         *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------

   DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = c_wricef_id_e143
          im_ser_num     = c_ser_num_2_e143
        IMPORTING
          ex_active_flag = lv_actv_flag_e143.

      IF lv_actv_flag_e143 EQ abap_true.
        INCLUDE zqtcn_purch_ord_enh_post IF FOUND.
      ENDIF. " IF lv_actv_flag_e143 EQ abap_true

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_account.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_header.
*----------------------------------------------------------------------*
* PROGRAM NAME        : IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM          *
* PROGRAM DESCRIPTION : Purchase Order Enhancement                     *
* An enhancement has done in standard SAP purchase orders to meet      *
* Wiley’s business requirements for Printer purchase order  and        *
* distributor purchase order processes.                                *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------

      DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = c_wricef_id_e143
          im_ser_num     = c_ser_num_2_e143
        IMPORTING
          ex_active_flag = lv_actv_flag_e143.

      IF lv_actv_flag_e143 EQ abap_true.
        INCLUDE zqtcn_purch_ord_enh_hdr IF FOUND.
      ENDIF. " IF lv_actv_flag_e143 EQ abap_true

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_item.
*----------------------------------------------------------------------*
* PROGRAM NAME        : IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM          *
* PROGRAM DESCRIPTION : Purchase Order Enhancement                     *
* An enhancement has done in standard SAP purchase orders to meet      *
* Wiley’s business requirements for Printer purchase order  and        *
* distributor purchase order processes.                                *
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------

     DATA: lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

*   To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = c_wricef_id_e143
          im_ser_num     = c_ser_num_2_e143
        IMPORTING
          ex_active_flag = lv_actv_flag_e143.

      IF lv_actv_flag_e143 EQ abap_true.
        INCLUDE zqtcn_purch_ord_enh_itm IF FOUND.
      ENDIF. " IF lv_actv_flag_e143 EQ abap_true

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_SCHEDULE.
  endmethod.
ENDCLASS.
