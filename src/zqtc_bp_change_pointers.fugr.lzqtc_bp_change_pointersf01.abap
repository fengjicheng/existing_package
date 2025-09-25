*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_BP_CHANGE_POINTERSF01 (Subroutines)
* PROGRAM DESCRIPTION: Process CPs for Message Type ZQTC_DEBMAS_OUTB
* DEVELOPER: Cheenangshuk Das (CHDAS)
* CREATION DATE: 09-Dec-2016
* OBJECT ID: I0202
* TRANSPORT NUMBER(S): ED2K903293
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911203
* REFERENCE NO: ERP-6783
* DEVELOPER: Writtick Roy (WROY)
* DATE: 06-Mar-2018
* DESCRIPTION: Update "Process" flag, immediately after IDOC is created
*----------------------------------------------------------------------*
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
                           fp_i_kna1     TYPE tt_kna1
                           fp_i_but000   TYPE tt_but000
                           fp_i_but020   TYPE tt_but020.
*====================================================================*
* Local Internal table
*====================================================================*
  DATA: li_bdcp2       TYPE tt_bdcp2_objcl,
        li_bdcp2_adrnr TYPE tt_bdcp2_adrnr.
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
    DELETE li_bdcp2 WHERE cdobjcl NE lc_addresse.

    IF li_bdcp2[] IS NOT INITIAL.
*
      PERFORM f_move_to_tab  USING    li_bdcp2
                             CHANGING li_bdcp2_adrnr.
*     Get the related Customer from Kna1
      PERFORM f_fetch_kna1   USING    li_bdcp2_adrnr
                             CHANGING fp_i_kna1.
*     Get the Business Partner from BUT000
      PERFORM f_fetch_but000 USING    li_bdcp2_adrnr
                             CHANGING fp_i_but000.
*     Get the Business Partner from BUT020
      PERFORM f_fetch_but020 USING    li_bdcp2_adrnr
                             CHANGING fp_i_but020.
    ENDIF. " IF li_bdcp2[] IS NOT INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ADRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_BDCP2  text
*      <--P_I_ADRC  text
*----------------------------------------------------------------------*
FORM f_fetch_kna1  USING    fp_li_bdcp2_adrnr TYPE tt_bdcp2_adrnr
                   CHANGING fp_i_kna1         TYPE tt_kna1.
  SELECT kunnr     " Customer Number
         adrnr     " Address Number
         FROM kna1 " General Data in Customer Master
         INTO TABLE fp_i_kna1
         FOR ALL ENTRIES IN fp_li_bdcp2_adrnr
         WHERE adrnr EQ fp_li_bdcp2_adrnr-adrnr.
  IF sy-subrc IS INITIAL.
*      No Actions
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_BUT000
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_LI_BDCP2_ADRNR  text
*      <--FP_I_BUT000  text
*----------------------------------------------------------------------*
FORM f_fetch_but000  USING    fp_li_bdcp2_adrnr TYPE tt_bdcp2_adrnr
                     CHANGING fp_i_but000 TYPE tt_but000.

  SELECT partner     " Business partner
         addrcomm    " Address Number
         FROM but000 " BP: General data I
         INTO TABLE fp_i_but000
         FOR ALL ENTRIES IN fp_li_bdcp2_adrnr
         WHERE addrcomm  EQ fp_li_bdcp2_adrnr-adrnr.
  IF sy-subrc IS INITIAL.
*      No Actions
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_BUT020
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_BDCP2  text
*      <--P_I_BUT020  text
*----------------------------------------------------------------------*
FORM f_fetch_but020  USING    fp_li_bdcp2_adrnr TYPE tt_bdcp2_adrnr
                     CHANGING fp_i_but020 TYPE tt_but020.

  SELECT partner     " Business partner
         addrnumber  " Address Number
         FROM but020 " BP: Addresses
         INTO TABLE fp_i_but020
         FOR ALL ENTRIES IN fp_li_bdcp2_adrnr
         WHERE addrnumber EQ fp_li_bdcp2_adrnr-adrnr.
  IF sy-subrc IS INITIAL.
*      No Actions
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVE_TO_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_BDCP2  text
*      <--P_LI_BDCP2_ADRNR  text
*----------------------------------------------------------------------*
FORM f_move_to_tab  USING    fp_li_bdcp2       TYPE tt_bdcp2_objcl
                    CHANGING fp_li_bdcp2_adrnr TYPE tt_bdcp2_adrnr.

  DATA: lst_bdcp2       TYPE ty_bdcp2,
        lst_bdcp2_adrnr TYPE ty_bdcp2_adrnr.

  CLEAR lst_bdcp2.
  LOOP AT fp_li_bdcp2 INTO lst_bdcp2.
    lst_bdcp2_adrnr-cdobjcl = lst_bdcp2-cdobjcl. " Object class
    lst_bdcp2_adrnr-cdobjid = lst_bdcp2-cdobjid. " Object value
    lst_bdcp2_adrnr-adrnr   = lst_bdcp2-cdobjid+4(14).

    APPEND lst_bdcp2_adrnr TO fp_li_bdcp2_adrnr.
    CLEAR  lst_bdcp2_adrnr.
  ENDLOOP. " LOOP AT fp_li_bdcp2 INTO lst_bdcp2
  .
  DELETE ADJACENT DUPLICATES FROM fp_li_bdcp2_adrnr
  COMPARING adrnr.

ENDFORM.
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
                                         fp_i_kna1        TYPE tt_kna1
                                         fp_i_but020      TYPE tt_but020
                                CHANGING fp_i_bdcp2_final TYPE zttqtc_bdcp2_details.
*====================================================================*
*  Reference Work-Area object
*====================================================================*
  DATA: lr_bdcp2        TYPE REF TO ty_bdcp2,      " Bdcp2 class
        lr_kna1         TYPE REF TO ty_kna1,       " Kna1 class
        lr_but000       TYPE REF TO ty_but000,     " But000 class
        lr_but020       TYPE REF TO ty_but020,     " But020 class
        lst_bdcp2_final TYPE zstqtc_bdcp2_details. " Custom Structure
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS: lc_addresse TYPE cdobjectcl VALUE 'ADRESSE',  " Object class
             lc_but0id   TYPE cdobjectcl VALUE 'BUPA_BUP', " Object class
             lc_but050   TYPE cdobjectcl VALUE 'BUPR_BUB', " Object class
             lc_kna1     TYPE cdobjectcl VALUE 'KNA1'.     " Object class

  CLEAR lr_bdcp2.
  LOOP AT fp_i_bdcp2 REFERENCE INTO lr_bdcp2.

    CASE lr_bdcp2->cdobjcl.

      WHEN lc_addresse.
        CLEAR lr_kna1.
        READ TABLE i_kna1 REFERENCE INTO lr_kna1 WITH TABLE KEY adrnr_key COMPONENTS
                                                 adrnr = lr_bdcp2->cdobjid+4(14).
        IF sy-subrc IS INITIAL.
          lst_bdcp2_final-kunnr      = lr_kna1->kunnr.
          lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
          lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
          lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.
          APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
          CLEAR  lst_bdcp2_final.
        ENDIF. " IF sy-subrc IS INITIAL

        CLEAR lr_but000.
        READ TABLE i_but000 REFERENCE INTO lr_but000 WITH TABLE KEY addrcomm_key COMPONENTS
                                                 addrcomm = lr_bdcp2->cdobjid+4(14).
        IF sy-subrc IS INITIAL.
          lst_bdcp2_final-kunnr      = lr_but000->partner.
          lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
          lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
          lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.
          APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
          CLEAR  lst_bdcp2_final.

        ENDIF. " IF sy-subrc IS INITIAL

        CLEAR lr_but020.
        READ TABLE i_but020 REFERENCE INTO lr_but020 WITH TABLE KEY addrnumber_key COMPONENTS
                                                 addrnumber = lr_bdcp2->cdobjid+4(14).
        IF sy-subrc IS INITIAL.
          lst_bdcp2_final-kunnr      = lr_but020->partner.
          lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
          lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
          lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.
          APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
          CLEAR  lst_bdcp2_final.

        ENDIF. " IF sy-subrc IS INITIAL
      WHEN lc_but0id.
        lst_bdcp2_final-kunnr      = lr_bdcp2->cdobjid.
        lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
        lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
        lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.

        APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
        CLEAR  lst_bdcp2_final.

      WHEN lc_but050.
        lst_bdcp2_final-kunnr      = lr_bdcp2->cdobjid+12(10).
        lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
        lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
        lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.

        APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
        CLEAR  lst_bdcp2_final.

      WHEN lc_kna1.
        lst_bdcp2_final-kunnr      = lr_bdcp2->cdobjid.
        lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
        lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
        lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.
        APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
        CLEAR  lst_bdcp2_final.

      WHEN OTHERS.
        lst_bdcp2_final-kunnr      = lr_bdcp2->cdobjid.
        lst_bdcp2_final-class      = lr_bdcp2->cdobjcl. "  class
        lst_bdcp2_final-mestype    = lr_bdcp2->mestype.
        lst_bdcp2_final-cpident	   = lr_bdcp2->cpident.
        APPEND lst_bdcp2_final TO fp_i_bdcp2_final.
        CLEAR  lst_bdcp2_final.
    ENDCASE.
  ENDLOOP. " LOOP AT fp_i_bdcp2 REFERENCE INTO lr_bdcp2
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_BD12
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_BDCP2_FINAL  text
*----------------------------------------------------------------------*
FORM f_submit_bd12  USING    fp_i_bdcp2_final TYPE zttqtc_bdcp2_details.
*--------------------------------------------------------------------*
* Internal Table
*--------------------------------------------------------------------*
  DATA: lir_kunnr       TYPE tt_kunnr, " Customer Number
        lir_class       TYPE tt_class,
*       Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        li_cpident      TYPE drf_t_cpident,
*       End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
*--------------------------------------------------------------------*
* Work-Area
*--------------------------------------------------------------------*
        lst_bdcp2_final TYPE zstqtc_bdcp2_details, " Custom Structure
        lst_bdcp2_dummy TYPE zstqtc_bdcp2_details. " Custom Structure

  SORT fp_i_bdcp2_final BY kunnr.

  LOOP AT fp_i_bdcp2_final INTO lst_bdcp2_final.

    CLEAR lst_bdcp2_dummy.
    lst_bdcp2_dummy = lst_bdcp2_final.
    AT NEW kunnr.
      CLEAR lir_kunnr.
    ENDAT.

*   Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
    APPEND INITIAL LINE TO li_cpident ASSIGNING FIELD-SYMBOL(<lst_cpident>).
    <lst_cpident>-cpident  = lst_bdcp2_final-cpident.
*   End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203

*  At End of kunnr
    AT END OF kunnr.
*     Populate partner
      PERFORM f_range_pop_kunnr USING lst_bdcp2_dummy
                                CHANGING lir_kunnr.

      cl_salv_bs_runtime_info=>set(    EXPORTING display  = abap_false
                                                 metadata = abap_false
                                                 data     = abap_true ).

*     Submit the RBDSEDEB -program
      SUBMIT rbdsedeb  WITH SELECTION-TABLE i_selscreen
      WITH   selkunnr  IN lir_kunnr
      WITH   mestyp    EQ lst_bdcp2_dummy-mestype
      AND RETURN.

*     Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
      PERFORM f_process_modify_bdcp2 USING li_cpident
                                           lst_bdcp2_dummy-mestype.
      CLEAR: li_cpident.
*     End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203

    ENDAT.
  ENDLOOP. " LOOP AT fp_i_bdcp2_final INTO lst_bdcp2_final

* Begin of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
**Check out the processed records in BDCP2 table
* PERFORM f_process_modify_bdcp2 USING fp_i_bdcp2_final.
* End   of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RANGE_POP_KUNNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_BDCP2_DUMMY  text
*      <--P_LIR_KUNNR  text
*----------------------------------------------------------------------*
FORM f_range_pop_kunnr  USING    fp_lst_bdcp2_dummy TYPE zstqtc_bdcp2_details " Custom Structure
                        CHANGING fp_lir_kunnr       TYPE tt_kunnr.            " Customer Number
*--------------------------------------------------------------------*
* Data declaration
*--------------------------------------------------------------------*
  DATA: lst_kunnr      TYPE ty_kunnr.
*--------------------------------------------------------------------*
*  Local Constant
*--------------------------------------------------------------------*
  CONSTANTS: lc_sign_i TYPE tvarv_sign VALUE 'I',  " ABAP: ID: I/E (include/exclude values)
             lc_opti   TYPE tvarv_opti VALUE 'EQ'. " ABAP: Selection option (EQ/BT/CP/...)

  lst_kunnr-sign = lc_sign_i.
  lst_kunnr-opti = lc_opti.
  lst_kunnr-low  = fp_lst_bdcp2_dummy-kunnr.

  APPEND lst_kunnr TO fp_lir_kunnr.
  CLEAR  lst_kunnr.

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
          i_kna1        ,
          i_bdcp2_final ,
          i_but020      ,
          i_selscreen   ,
          v_raise       .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_MODIFY_BDCP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_BDCP2  text
*----------------------------------------------------------------------*
* Begin of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
*FORM f_process_modify_bdcp2  USING    fp_i_bdcp2_final TYPE zttqtc_bdcp2_details.
* End   of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
* Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
FORM f_process_modify_bdcp2  USING    fp_li_cpident      TYPE drf_t_cpident
                                      fp_lv_message_type TYPE edi_mestyp.
* End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
  DATA: lv_message_type TYPE edi_mestyp,
*       Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        lv_varkey       TYPE vim_enqkey,
*       End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        li_cpident      TYPE drf_t_cpident.
*--------------------------------------------------------------------*
* Local Field Symbols
*--------------------------------------------------------------------*
  FIELD-SYMBOLS : <lst_bdcp2> TYPE zstqtc_bdcp2_details. " Custom Structure
*--------------------------------------------------------------------*
*  Local Constants
*--------------------------------------------------------------------*
  CONSTANTS : lc_table     TYPE tabname VALUE 'BDCP2', " Table Name
*             Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
              lc_all_recs  TYPE char1   VALUE '*',
*             End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
              lc_lock_md_e TYPE enqmode VALUE 'E'.     " Lock mode


* Begin of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
* LOOP AT fp_i_bdcp2_final ASSIGNING <lst_bdcp2>.
*   lv_message_type     = <lst_bdcp2>-mestype.
*   APPEND INITIAL LINE TO li_cpident ASSIGNING FIELD-SYMBOL(<lst_cpident>).
*   <lst_cpident>-cpident  = <lst_bdcp2>-cpident.
* ENDLOOP. " LOOP AT fp_i_bdcp2_final ASSIGNING <lst_bdcp2>
* End   of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
* Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
  lv_message_type = fp_lv_message_type.
* Prepare Lock key for tables
  CONCATENATE sy-mandt                                 " Client
              lv_message_type                          " Message Type
              lc_all_recs                              " All Records
         INTO lv_varkey.
* End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203

* Lock table
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      mode_rstable   = lc_lock_md_e "Lock Mode - Write Lock
      tabname        = lc_table     "Table Name
*     Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
      varkey         = lv_varkey
*     End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
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
* Begin of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
*       change_pointers_idents = li_cpident.
* End   of DEL:ERP-6783:WROY:06-Mar-2018:ED2K911203
* Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        change_pointers_idents = fp_li_cpident.
* End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203

    CALL FUNCTION 'DB_COMMIT'.
    COMMIT WORK.

    CLEAR li_cpident. REFRESH li_cpident.

*   Unlock table
    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING
        mode_rstable = lc_lock_md_e "Lock Mode - Write Lock
*       Begin of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        varkey       = lv_varkey
*       End   of ADD:ERP-6783:WROY:06-Mar-2018:ED2K911203
        tabname      = lc_table.    "Table Name
  ENDIF. " IF sy-subrc = 0

ENDFORM.
