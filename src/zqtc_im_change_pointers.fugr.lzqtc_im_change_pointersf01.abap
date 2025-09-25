*----------------------------------------------------------------------*
***INCLUDE LZQTC_BP_CHANGE_POINTERSF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATING_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_RAISE  text
*----------------------------------------------------------------------*
FORM f_validating_input    USING    fp_im_mestype TYPE  tbdme-mestyp
                           CHANGING fp_v_raise    TYPE  char1. " V_raise of type CHAR1
*====================================================================*
* Local variable
*====================================================================*
  DATA: lv_mestyp TYPE char1. " Mestyp of type CHAR1
* Validate MESTYPE
  SELECT SINGLE msgtyp     " Message Type
                FROM edmsg " Logical message types
                INTO lv_mestyp
                WHERE msgtyp = fp_im_mestype.
  IF sy-subrc IS INITIAL.
    CLEAR fp_v_raise.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    fp_v_raise = abap_true.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BDCP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_MESTYPE  text
*      <--P_I_BDCP2  text
*----------------------------------------------------------------------*
FORM f_get_bdcp2  USING    fp_im_mestype TYPE tbdme-mestyp
                  CHANGING fp_i_bdcp2    TYPE tt_bdcp2
                           fp_i_mara     TYPE tt_mara.
*                           fp_i_but000   TYPE tt_but000
*                           fp_i_but020   TYPE tt_but020.
*====================================================================*
* Local Internal table
*====================================================================*
  DATA: li_bdcp2       TYPE tt_bdcp2_objcl,
        li_bdcp2_matnr TYPE tt_bdcp2_matnr.
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS: lc_addresse TYPE cdobjectcl VALUE 'ADRESSE'. " Object class

  SELECT  mandt      " Client
          mestype    " Message Type
          cpident    " Change pointer ID
          process    " ALE processing indicator
          tabname    " Table Name
          tabkey     " Table Key for CDPOS in Character 254
          fldname    " Field Name
          cretime    " Creation time of a change pointer
          acttime    " Activation time of a change pointer
          usrname    " User name of the person responsible in change document
          cdobjcl    " Object class
          cdobjid    " Object value
          cdchgno    " Document change number
          cdchgid    " Change Type (U, I, S, D)
          FROM bdcp2 " Aggregated Change Pointers (BDCP, BDCPS)
          INTO TABLE fp_i_bdcp2
          WHERE mestype EQ fp_im_mestype
          AND   process EQ abap_false.
  IF sy-subrc IS INITIAL.
    CLEAR li_bdcp2.
    li_bdcp2[] = fp_i_bdcp2[].

    IF li_bdcp2[] IS NOT INITIAL.

*     Get the related Material Details from MARA
      PERFORM f_fetch_mara   USING    li_bdcp2_matnr
                             CHANGING fp_i_mara.

    ENDIF. " IF li_bdcp2[] IS NOT INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*
*&---------------------------------------------------------------------*
*&      Form  F_FILTER_BDCP2_ON_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_BDCP2  text
*      -->P_I_KNA1  text
*      -->P_I_BUT020  text
*----------------------------------------------------------------------*
FORM f_filter_bdcp2_on_partner  USING    fp_i_bdcp2       TYPE tt_bdcp2
                                         fp_i_mara        TYPE tt_mara
                                CHANGING fp_i_bdcp2_final TYPE zttqtc_bdcp2_details_im.
*====================================================================*
*  Reference Work-Area object
*====================================================================*
  DATA: lr_bdcp2        TYPE REF TO ty_bdcp2,         " Bdcp2 class
        lr_mara         TYPE REF TO ty_mara,          " Kna1 class
        lst_bdcp2_final TYPE zstqtc_bdcp2_details_im. " Custom Structure
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS: lc_material TYPE cdobjectcl VALUE 'MATERIAL'. " Object class
*             lc_but0id   TYPE cdobjectcl VALUE 'BUPA_BUP', " Object class
*             lc_but050   TYPE cdobjectcl VALUE 'BUPR_BUB', " Object class
*             lc_kna1     TYPE cdobjectcl VALUE 'KNA1'.     " Object class

  CLEAR lr_bdcp2.
  LOOP AT fp_i_bdcp2 REFERENCE INTO lr_bdcp2.

    CASE lr_bdcp2->cdobjcl.

      WHEN lc_material.
        CLEAR lr_mara.
        READ TABLE i_mara REFERENCE INTO lr_mara WITH TABLE KEY matnr_key COMPONENTS
                                                 matnr = lr_bdcp2->cdobjid+0(18).
        IF sy-subrc IS INITIAL.
          lst_bdcp2_final-matnr      = lr_mara->matnr.
          lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
          lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
          lst_bdcp2_final-cpident     = lr_bdcp2->cpident.
          APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
          CLEAR  lst_bdcp2_final.
        ENDIF. " IF sy-subrc IS INITIAL

    ENDCASE.
  ENDLOOP. " LOOP AT fp_i_bdcp2 REFERENCE INTO lr_bdcp2
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_RANGE_POP_KUNNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_BDCP2_DUMMY  text
*      <--P_LIR_KUNNR  text
*----------------------------------------------------------------------*
FORM f_range_pop_kunnr  USING    fp_lst_bdcp2_dummy TYPE zstqtc_bdcp2_details_im " Custom Structure
                        CHANGING fp_lir_matnr       TYPE tt_matnr.               " Customer Number
*--------------------------------------------------------------------*
* Data declaration
*--------------------------------------------------------------------*
  DATA: lst_matnr      TYPE ty_matnr.
*--------------------------------------------------------------------*
*  Local Constant
*--------------------------------------------------------------------*
  CONSTANTS: lc_sign_i TYPE tvarv_sign VALUE 'I',  " ABAP: ID: I/E (include/exclude values)
             lc_opti   TYPE tvarv_opti VALUE 'EQ'. " ABAP: Selection option (EQ/BT/CP/...)

  lst_matnr-sign = lc_sign_i.
  lst_matnr-opti = lc_opti.
  lst_matnr-low  = fp_lst_bdcp2_dummy-matnr.

  APPEND lst_matnr TO fp_lir_matnr.
  CLEAR  lst_matnr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL_GLOBAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_all_global .
  CLEAR : i_bdcp2       ,
          i_mara        ,
          i_bdcp2_final ,
          i_but020      ,
          i_selscreen   ,
          i_rep_data    ,
          v_raise       .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_MODIFY_BDCP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_BDCP2  text
*----------------------------------------------------------------------*
FORM f_process_modify_bdcp2  USING    fp_i_bdcp2_final TYPE zttqtc_bdcp2_details_im.
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
  DATA: lv_message_type TYPE edi_mestyp,
        li_cpident      TYPE drf_t_cpident.
*--------------------------------------------------------------------*
* Local Field Symbols
*--------------------------------------------------------------------*
  FIELD-SYMBOLS : <lst_bdcp2> TYPE zstqtc_bdcp2_details_im. " Custom Structure
*--------------------------------------------------------------------*
*  Local Constants
*--------------------------------------------------------------------*
  CONSTANTS : lc_table     TYPE tabname VALUE 'BDCP2', " Table Name
              lc_lock_md_e TYPE enqmode VALUE 'E'.     " Lock mode



  LOOP AT fp_i_bdcp2_final ASSIGNING <lst_bdcp2>.
    lv_message_type     = <lst_bdcp2>-mestype.
    APPEND INITIAL LINE TO li_cpident ASSIGNING FIELD-SYMBOL(<lst_cpident>).
    <lst_cpident>-cpident  = <lst_bdcp2>-cpident.
  ENDLOOP. " LOOP AT fp_i_bdcp2_final ASSIGNING <lst_bdcp2>

* Lock table
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      mode_rstable   = lc_lock_md_e "Lock Mode - Write Lock
      tabname        = lc_table     "Table Name
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc = 0.

* write staus of all processed pointers
    CALL FUNCTION 'CHANGE_POINTERS_STATUS_WRITE'
      EXPORTING
        message_type           = lv_message_type
      TABLES
        change_pointers_idents = li_cpident.

    CALL FUNCTION 'DB_COMMIT'.
    COMMIT WORK.

    CLEAR li_cpident. REFRESH li_cpident.

*   Unlock table
    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING
        mode_rstable = lc_lock_md_e "Lock Mode - Write Lock
        tabname      = lc_table.    "Table Name
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_BDCP2_MATNR  text
*      <--P_FP_I_MARA  text
*----------------------------------------------------------------------*
FORM f_fetch_mara USING fp_li_bdcp2_matnr TYPE tt_bdcp2_matnr
                  CHANGING fp_i_mara      TYPE tt_mara.

  IF fp_li_bdcp2_matnr IS NOT INITIAL.
    SELECT matnr       " Customer Number
           ismpubldate " Address Number
       FROM mara       " General Data in Customer Master
       INTO TABLE fp_i_mara
       FOR ALL ENTRIES IN fp_li_bdcp2_matnr
       WHERE matnr EQ fp_li_bdcp2_matnr-matnr.
    IF sy-subrc IS INITIAL.
*      No Actions
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF fp_li_bdcp2_matnr IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_BD10
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_BDCP2  text
*----------------------------------------------------------------------*
FORM f_submit_bd10  USING  fp_i_bdcp2_final TYPE zttqtc_bdcp2_details_im.
*--------------------------------------------------------------------*
* Internal Table
*--------------------------------------------------------------------*
  DATA: lir_matnr       TYPE tt_matnr, " Material Number
        lir_class       TYPE tt_class,
*--------------------------------------------------------------------*
* Work-Area
*--------------------------------------------------------------------*
        lst_bdcp2_final TYPE zstqtc_bdcp2_details_im, "zstqtc_bdcp2_details, " Custom Structure
        lst_bdcp2_dummy TYPE zstqtc_bdcp2_details_im. " Custom Structure

  SORT fp_i_bdcp2_final BY matnr.

  LOOP AT fp_i_bdcp2_final INTO lst_bdcp2_final.


    cl_salv_bs_runtime_info=>set(    EXPORTING display  = abap_false
                                               metadata = abap_false
                                               data     = abap_true ).

*     Submit the rbdsemat -program
    SUBMIT rbdsemat  WITH SELECTION-TABLE i_selscreen
    WITH   selmatnr  IN lir_matnr
    WITH   mestyp    EQ lst_bdcp2_dummy-mestype
    AND RETURN.


  ENDLOOP. " LOOP AT fp_i_bdcp2_final INTO lst_bdcp2_final

* Check out the processed records in BDCP2 table
  PERFORM f_process_modify_bdcp2 USING fp_i_bdcp2_final.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MASTER_DISTRIBUTE_FMCALL
*&---------------------------------------------------------------------*

FORM f_master_distribute_fmcall  USING    p_i_bdcp2.

*  DATA:  lst_idoc_control    TYPE edidc,          " Control record (IDoc)
*         li_idoc_control     TYPE TABLE OF edidc, " Control record (IDoc)
*         li_master_idoc_data TYPE TABLE OF edidd. " Data record (IDoc)
*
*  lst_idoc_control
*
*  CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
*    EXPORTING
*      master_idoc_control        = lst_idoc_control
*    TABLES
*      communication_idoc_control = li_idoc_control
*      master_idoc_data           = li_master_idoc_data
** EXCEPTIONS
**     ERROR_IN_IDOC_CONTROL      = 1
**     ERROR_WRITING_IDOC_STATUS  = 2
**     ERROR_IN_IDOC_DATA         = 3
**     SENDING_LOGICAL_SYSTEM_UNKNOWN       = 4
**     OTHERS                     = 5
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF. " IF sy-subrc <> 0

ENDFORM.
