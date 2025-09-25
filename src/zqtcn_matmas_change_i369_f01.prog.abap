*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MATMAS_CHANGE_I369_F01
*&---------------------------------------------------------------------*
* PROGRAM DESCRIPTION:  Report to get the BDCP2 unprocessed            *
*                       Change Pointer details against the Message Type*
*                       and Submit program “RBDSEMAT” (Tcode BD10)with *
*                       materials and Update the process indicator = ‘X’
*                       using FM CHANGE_POINTERS_STATUS_WRITE
* DEVELOPER:            MIMMADISET                                     *
* CREATION DATE:        03/30/2021                                     *
* OBJECT ID:            I0369.1                                        *
* TRANSPORT NUMBER(S):  ED2K922771                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&      Form  AUTHORITY_CHECK_MASTER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_MESTYP  text
*      -->P_ABAP_TRUE  text
*----------------------------------------------------------------------*
FORM authority_check_master_data USING VALUE(a_mestyp)
                                       VALUE(a_own_reaction).
  AUTHORITY-CHECK OBJECT 'B_ALE_MAST'
                  ID 'EDI_MES' FIELD a_mestyp.
  IF sy-subrc <> 0 AND NOT a_own_reaction IS INITIAL.
    MESSAGE ID 'B1' TYPE 'E' NUMBER '125'
      WITH 'B_ALE_MAST' a_mestyp '' ''.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATING_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_MESTYP  text
*----------------------------------------------------------------------*
FORM f_validating_input  USING fp_im_mestype TYPE  tbdme-mestyp.
* Validate MESTYPE
  SELECT SINGLE msgtyp     " Message Type
                FROM edmsg " Logical message types
                INTO @DATA(lv_mestyp)
                WHERE msgtyp = @fp_im_mestype.
  IF sy-subrc NE 0.
    MESSAGE e012(b1) WITH fp_im_mestype.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BDCP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_MESTYP  text
*      <--P_I_BDCP2  text
*      <--P_I_MARA  text
*----------------------------------------------------------------------*
FORM f_get_bdcp2  USING    fp_im_mestype TYPE tbdme-mestyp
                  CHANGING fp_i_bdcp2    TYPE tt_bdcp2
                           fp_i_mara     TYPE tt_mara.
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS:lc_material TYPE cdobjectcl VALUE 'MATERIAL'. " Object class

*====================================================================*
* Local Variables
*====================================================================*
  DATA : lir_tmstp TYPE RANGE OF timestamp,
         lsr_tmstp LIKE LINE OF lir_tmstp.
***Creating range table for timestamp
  IF p_rep IS NOT INITIAL.
    FREE:lir_tmstp.
    LOOP AT s_date.
      lsr_tmstp-sign   = s_date-sign.
      lsr_tmstp-option = s_date-option.
      lsr_tmstp-low    = s_date-low && s_time-low.
      IF s_date-high IS NOT INITIAL.
        lsr_tmstp-high   = s_date-high && s_time-high.
      ELSE.
        lsr_tmstp-option = c_bt.
        lsr_tmstp-high   = s_date-low && s_time-high.
      ENDIF.
      APPEND lsr_tmstp TO lir_tmstp.
      CLEAR lsr_tmstp.
    ENDLOOP.
  ENDIF.
**Get the Details from BDCP2
  SELECT    mestype    " Message Type
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
            WHERE mestype EQ fp_im_mestype   " Message type
            AND   process EQ p_rep         "If p_req eq "" unprocessed else reprocessed
            AND   acttime IN lir_tmstp
            AND   cdobjcl EQ lc_material
            AND   cdobjid IN s_mat.
  IF sy-subrc IS INITIAL AND fp_i_bdcp2[] IS NOT INITIAL.
    SORT fp_i_bdcp2 BY cretime cdobjid cdchgno tabname.
*     Get the related Material Details from MARA
    PERFORM f_fetch_mara   USING    fp_i_bdcp2
                           CHANGING fp_i_mara.
  ELSE.
    MESSAGE s000(zqtc_r2) WITH 'No records found'(002).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_I_BDCP2  text
*      <--P_FP_I_MARA  text
*----------------------------------------------------------------------*
FORM f_fetch_mara  USING    fp_i_bdcp2    TYPE tt_bdcp2
                   CHANGING fp_i_mara      TYPE tt_mara.

*====================================================================*
* Local Variables
*====================================================================*
  DATA:lir_matnr             TYPE tt_matnr,        "Range table for material
       lir_matkl_range_i0369 TYPE fip_t_matkl_range. "Range table for mat group
*====================================================================*
* Local Constants
*====================================================================*
  DATA:lc_matkl TYPE rvari_vnam VALUE 'MATKL'.

  LOOP AT i_constants[] ASSIGNING FIELD-SYMBOL(<lfs_constant_i0369>).
*   **---Material group
    IF <lfs_constant_i0369>-param1 = lc_matkl AND
       <lfs_constant_i0369>-param2 = p_mestyp.
      APPEND INITIAL LINE TO lir_matkl_range_i0369 ASSIGNING FIELD-SYMBOL(<lst_matkl_range>).
      <lst_matkl_range>-sign     = <lfs_constant_i0369>-sign.
      <lst_matkl_range>-option   = <lfs_constant_i0369>-opti.
      <lst_matkl_range>-low      = <lfs_constant_i0369>-low.
    ENDIF.
  ENDLOOP.
**Append the materials to range to table
  lir_matnr = VALUE #( FOR ls_bdcp2 IN fp_i_bdcp2
                      (  sign = 'I' "incl "sy-abcde+7(8)
                         opti = 'EQ' "sy-abcde+3(4) && sy-abcde+15 "
                         low = ls_bdcp2-cdobjid+0(18) )
                      ).
  SORT lir_matnr BY low.
  DELETE ADJACENT DUPLICATES FROM lir_matnr COMPARING low.
  IF lir_matnr IS NOT INITIAL.
    SELECT matnr         " Material number
           matkl         " Material type
         FROM mara       " General Data
         INTO TABLE fp_i_mara
         WHERE matnr IN lir_matnr AND
               matkl IN lir_matkl_range_i0369.
    IF sy-subrc IS INITIAL.
*Submit BD10
      PERFORM f_submit_bd10 USING fp_i_mara.
* update the unprocessed records in bdcp2 table
      IF p_rep IS INITIAL.
        PERFORM f_process_modify_bdcp2 USING fp_i_bdcp2 fp_i_mara.
      ENDIF.
    ELSE.
      MESSAGE s000(zqtc_r2) WITH 'No records found'(002).
    ENDIF." IF sy-subrc IS INITIAL
  ENDIF."IF lrt_matnr IS NOT INITIAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FREE_GLOABL_TABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_free_gloabl_tables .
  FREE:i_bdcp2,i_mara,i_selscreen,i_constants.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_constants .
  CONSTANTS:lc_devid_i0369 TYPE zdevid VALUE 'I0369.1'.
*---Check the Constant table before going to the actual logiC.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_i0369  "Development ID
    IMPORTING
      ex_constants = i_constants. "Constant Values
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_BD10
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_I_MARA  text
*----------------------------------------------------------------------*
FORM f_submit_bd10  USING  fp_i_mara TYPE tt_mara.
*====================================================================*
* Local internal table
*====================================================================*
  DATA:lir_matnr TYPE tt_matnr.   "Range table for material

  lir_matnr = VALUE #( FOR ls_mara IN fp_i_mara
                      (  sign = 'I' " incl "sy-abcde+9    "
                         opti = 'EQ' "sy-abcde+5 && sy-abcde+17 "
                         low = ls_mara-matnr )
                      ).
*     Submit the rbdsemat -program
  IF lir_matnr[] IS NOT INITIAL.
*    cl_salv_bs_runtime_info=>set(    EXPORTING display  = abap_false
*                                                  metadata = abap_false
*                                                  data     = abap_true ).
    SUBMIT rbdsemat  WITH SELECTION-TABLE i_selscreen
    WITH   matsel   IN lir_matnr
    WITH   mestyp    EQ p_mestyp
    WITH   sendall   EQ abap_true
*    WITH nomsg EQ abap_true
    AND RETURN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_MODIFY_BDCP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_I_BDCP2_FINAL  text
*----------------------------------------------------------------------*
FORM f_process_modify_bdcp2  USING  fp_i_bdcp2 TYPE tt_bdcp2
                                    fp_i_mara  TYPE tt_mara.
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
  DATA: lv_message_type TYPE edi_mestyp,
        lv_varkey       TYPE vim_enqkey,
        li_cpident      TYPE drf_t_cpident.
*--------------------------------------------------------------------*
*  Local Constants
*--------------------------------------------------------------------*
  CONSTANTS : lc_table     TYPE tabname VALUE 'BDCP2', " Table Name
              lc_all_recs  TYPE char1   VALUE '*',
              lc_lock_md_e TYPE enqmode VALUE 'E'.     " Lock mode

  li_cpident = VALUE #( FOR ls_bdcp2 IN fp_i_bdcp2
                        FOR ls_mara IN fp_i_mara WHERE ( matnr = ls_bdcp2-cdobjid+0(18) )
                        (  cpident  = ls_bdcp2-cpident )
                        ).
  IF li_cpident IS NOT INITIAL.
* Prepare Lock key for tables
    CONCATENATE sy-mandt                                 " Client
                p_mestyp                                 " Message Type
                lc_all_recs                              " All Records
           INTO lv_varkey.
* Lock table
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        mode_rstable   = lc_lock_md_e "Lock Mode - Write Lock
        tabname        = lc_table     "Table Name
        varkey         = lv_varkey
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc = 0.

* write staus of all processed pointers
      CALL FUNCTION 'CHANGE_POINTERS_STATUS_WRITE'
        EXPORTING
          message_type           = p_mestyp
        TABLES
          change_pointers_idents = li_cpident.

      CALL FUNCTION 'DB_COMMIT'.
      COMMIT WORK.

      CLEAR li_cpident. REFRESH li_cpident.

*   Unlock table
      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          mode_rstable = lc_lock_md_e "Lock Mode - Write Lock
          tabname      = lc_table    "Table Name
          varkey       = lv_varkey.
    ENDIF. " IF sy-subrc = 0
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ENABLE_FLD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_enable_fld .
  LOOP AT SCREEN.
    IF p_rep = abap_true.
      IF screen-group1 = 'GP1'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ELSE.
      IF screen-group1 = 'GP1'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF p_rep EQ space.
    FREE:s_date,s_time.
    CLEAR:s_date,s_time.
***Defaulting the end time.
    s_time-sign = c_i.
    s_time-option = c_bt.
    s_time-high = c_etime.
    APPEND s_time.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ENTER_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_enter_date .
  IF p_rep IS NOT INITIAL
    AND s_date IS INITIAL
    AND s_mat IS INITIAL.
    MESSAGE i000 WITH 'Enter the Date'(001).
    STOP.
  ENDIF.
ENDFORM.
