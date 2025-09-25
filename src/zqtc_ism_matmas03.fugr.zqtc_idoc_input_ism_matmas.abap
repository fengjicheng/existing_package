FUNCTION ZQTC_IDOC_INPUT_ISM_MATMAS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_INPUT_METHOD) TYPE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(IM_MASS_PROCESSING) TYPE  BDWFAP_PAR-MASS_PROC
*"     VALUE(IM_NO_APPLICATION_LOG) TYPE  SY-DATAR OPTIONAL
*"     VALUE(IM_MASSSAVEINFOS) TYPE  MASSSAVINF OPTIONAL
*"     VALUE(IM_KZ_TEST) TYPE  MDAT1-KZ_TEST DEFAULT SPACE
*"     VALUE(IM_ONLY_MAPPING) TYPE  MDAT1-KZ_TEST DEFAULT SPACE
*"     VALUE(IM_KZ_MMCC) TYPE  SY-DATAR DEFAULT SPACE
*"  EXPORTING
*"     VALUE(EX_WORKFLOW_RESULT) TYPE  BDWF_PARAM-RESULT
*"     VALUE(EX_APPLICATION_VARIABLE) TYPE  BDWF_PARAM-APPL_VAR
*"     VALUE(EX_IN_UPDATE_TASK) TYPE  BDWFAP_PAR-UPDATETASK
*"     VALUE(EX_CALL_TRANSACTION_DONE) TYPE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"----------------------------------------------------------------------
*{ALE Begin} generation http://intranet.sap.com/materialversion
 CALL FUNCTION 'MGV_ALE_ADD_INTERNAL_MATNR'
      TABLES
           idoc_data       = idoc_data
           idoc_contrl     = idoc_contrl
      EXCEPTIONS
           NUMBER_MISMATCH = 1
           OTHERS          = 2.
*{ALE End} generation
" Read idoc data with segment E1MARAM.
  READ TABLE idoc_data
    ASSIGNING FIELD-SYMBOL(<fs_e1maram>)
    WITH KEY segnam = 'E1MARAM'.
  IF  sy-subrc IS INITIAL
  AND <fs_e1maram> IS ASSIGNED.
    CLEAR: lst_e1maram,lst_matnr.
    lst_e1maram = <fs_e1maram>-sdata.
    IF lst_e1maram-matnr IS INITIAL.
      CALL FUNCTION 'MATERIAL_NUMBER_GET_NEXT'
        EXPORTING
          materialart          = lst_e1maram-mtart
        IMPORTING
          materialnr           = lst_matnr
*         RETURNCODE           =
        EXCEPTIONS
          no_internal_interval = 1
          type_not_found       = 2
          OTHERS               = 3.
      IF sy-subrc = 0.
        lst_e1maram-matnr    = lst_matnr.
        LOOP AT idoc_data WHERE segnam = 'E1MARAM'..
          lst_e1maram = idoc_data-sdata.
          lst_e1maram-matnr = lst_matnr.
          idoc_data-sdata = lst_e1maram.
          MODIFY idoc_data INDEX sy-tabix.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
* Initialize data - general
  REFRESH T_MFIELDRES.
  REFRESH T_IDOC_TRANC.
  REFRESH T_IDOC_MATNR.                "JH/02.02.98/4.0C  KPr100004993
* REFRESH t_idoc_tranc_segment.   " //br 40 : unnötig
* REFRESH matnr_tranc.            "    -"-
* REFRESH t_matnr.
  COUNTER-TRANC = 1.
  COUNTER-D_IND = 1.
  REFRESH T_MARA_UEB.
  REFRESH T_MAKT_UEB.
  REFRESH T_MARC_UEB.
  REFRESH T_MARD_UEB.
  REFRESH T_MFHM_UEB.
  REFRESH T_MARM_UEB.
  CLEAR   T_MARM_DEL[].                                                 " n_2595170
  CLEAR   T_MARM_DIMID[].                                               " n_2595170
  REFRESH T_MEAN_UEB.
  REFRESH T_MBEW_UEB.
  REFRESH T_STEU_UEB.
  REFRESH T_STEUMM_UEB.
  REFRESH T_MLGN_UEB.
  REFRESH T_MLGT_UEB.                  " //br010797 neu zu 4.0
  REFRESH T_MPGD_UEB.
  REFRESH T_MPOP_UEB.
  REFRESH T_MVEG_UEB.
  REFRESH T_MVEU_UEB.
  REFRESH T_MVKE_UEB.
  REFRESH T_MPRW_UEB.
*  REFRESH: T_E1CUCFG_UEB.
*  REFRESH: T_E1CUINS_UEB.
*  REFRESH: T_E1CUVAL_UEB.
*  REFRESH: T_E1CUCOM_UEB.
*  REFRESH VKORG_ALAND.
*  REFRESH WERKS_ALAND.

  CLEAR APPLICATION_SUBRC.
  REFRESH T_MERRDAT.

    IF  IDOC_CONTRL-IDOCTP <> 'MATMAS01'
    AND IDOC_CONTRL-IDOCTP <> 'MATMAS02'
    AND IDOC_CONTRL-IDOCTP <> 'MATMAS03'
    AND IDOC_CONTRL-IDOCTP <> 'MATMAS05'
    AND IDOC_CONTRL-IDOCTP <> 'MATCOR01'.
      RAISE WRONG_FUNCTION_CALLED.
    ENDIF.
* ----------------------------------------------------------------------
* Fill Data from IDOC into internal material tables
* the master data tables are filled as follows:
*   first: it is tried to create the material
*   immediately afterwards: it is tried to change the material
* ----------------------------------------------------------------------
  LOOP AT IDOC_CONTRL.

*   Initialize data - per IDOC
*   t_idoc_tranc-docnum = counter-tranc.
    T_IDOC_TRANC-DOCNUM = IDOC_CONTRL-DOCNUM.
    T_IDOC_TRANC-FIRST_TRANC_IDOC = COUNTER-TRANC + 2.
    APPEND T_IDOC_TRANC.

*   Select segments which belong to IDOC
    REFRESH T_EDIDD.
    LOOP AT IDOC_DATA WHERE DOCNUM = IDOC_CONTRL-DOCNUM.
      APPEND IDOC_DATA TO T_EDIDD.
    ENDLOOP.

     call function 'OPEN_FI_PERFORM_MGV00200_E'         "note0388000
          exporting                                     "note0388000
              idoc_header       = idoc_contrl           "note0388000
              FLG_APPEND_STATUS = 'X'                   "note0388000
          tables                                        "note0388000
* (DEL)       idoc_data         = idoc_data "note0388000 note0418561
              idoc_data         = t_edidd               "note0418561
              idoc_status       = idoc_status           "note0388000
          exceptions                                    "note0388000
              others       = 1.                         "note0388000
     if sy-subrc = 1.
*      in example function module SAMPLE_INTERFACE_MGV00200
*       continue.                                       "note0388000
       APPLICATION_SUBRC = SY-SUBRC.
*       PERFORM HANDLE_ERROR_BTE
*                   TABLES
*                      IDOC_CONTRL
*                      IDOC_STATUS
*                      RETURN_VARIABLES
*                   USING
*                      APPLICATION_SUBRC
*                   CHANGING
*                      EX_WORKFLOW_RESULT.
       EXIT.
     endif.
*   Within one IDOC: loop through data segments:
*   Prepare internal tables for the current material
    LOOP AT T_EDIDD INTO IDOC_DATA.
      CASE IDOC_DATA-SEGNAM.
*         Initialize data - per material
          COUNTER-D_IND = 1.
*          FIRST_TRANC = COUNTER-TRANC.
*         interpret segment
          lst_e1maram = IDOC_DATA-SDATA.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.
   DATA: lst_mara TYPE mara_ueb.
   CLEAR lst_mara.
   MOVE-CORRESPONDING lst_e1maram TO lst_mara.
   APPEND lst_mara TO t_mara_ueb.
*   media call
    call function 'MATERIAL_MAINTAIN_DARK'
     exporting
          p_kz_no_warn       = 'N'
          kz_prf             = 'W'
          kz_aend            = 'X'
          kz_verw            = 'X'
          call_mode          = 'ALE'
          call_mode2         = 'ISM'
          sperrmodus         = 'E'
          max_errors         = '0'
          flag_muss_pruefen  = 'X'
          IV_CHANGE_DOC_TCODE = '(ALE)'
          KZ_TEST             = IM_KZ_TEST             "TK18112009
*          flg_mass            = flg_mass            "TK05062012/Hinw.1726821
     tables
          amara_ueb          = t_mara_ueb
          amakt_ueb          = t_makt_ueb
          amarc_ueb          = t_marc_ueb
          amard_ueb          = t_mard_ueb
          amfhm_ueb          = t_mfhm_ueb
          amarm_ueb          = t_marm_ueb
          amea1_ueb          = t_mean_ueb
          ambew_ueb          = t_mbew_ueb
          asteu_ueb          = t_steu_ueb
          astmm_ueb          = t_steumm_ueb
          amlgn_ueb          = t_mlgn_ueb
          amlgt_ueb          = t_mlgt_ueb
          ampgd_ueb          = t_mpgd_ueb
          ampop_ueb          = t_mpop_ueb
          amveg_ueb          = t_mveg_ueb
          amveu_ueb          = t_mveu_ueb
          amvke_ueb          = t_mvke_ueb
          amprw_ueb          = t_mprw_ueb
          altx1_ueb          = t_ltx1_ueb
*          AE1CUCFG_UEB       = T_E1CUCFG_UEB "TF4.7/ALE MatVar
*          AE1CUINS_UEB       = T_E1CUINS_UEB "TF4.7/ALE MatVar
*          AE1CUVAL_UEB       = T_E1CUVAL_UEB "TF4.7/ALE MatVar
*          AE1CUCOM_UEB       = T_E1CUCOM_UEB "TF4.7/ALE MatVar
          amfieldres         = t_mfieldres
          amerrdat           = t_merrdat
     exceptions
          kstatus_empty      = 01
          tkstatus_empty     = 02
          t130m_error        = 03
          internal_error     = 04
          too_many_errors    = 05
          update_error       = 06
          error_message      = 11.

   if sy-subrc eq 0.
*   note 2507960
     DATA: ls_ism_merrdat like merrdat.
*   anticipate standard error handling (see FORM HANDLE_ERROR_EXT)
     LOOP AT T_MERRDAT INTO LS_ISM_MERRDAT WHERE MSGTY NA 'SDHWI'.
       EXIT.
     ENDLOOP.
     IF SY-SUBRC = 0.
*     no action!! error occurred ==> rollback work will be done
     ELSE.
       CALL FUNCTION 'ISM_IDOC_SAVE_JPTMARA_DATA'
       exporting                                  "TK18112009
         KZ_TEST      = IM_KZ_TEST                   "TK18112009
       CHANGING
         PT_C_MERRDAT = t_merrdat.

     CALL FUNCTION 'ISM_IDOC_SAVE_IDOC_BUPA_DATA'
       exporting                                  "TK18112009
         KZ_TEST      = IM_KZ_TEST                   "TK18112009
       CHANGING
         PT_C_MERRDAT = t_merrdat.
     sy-subrc  = 0.                                   "TK01032012/Hinw.1691252
     ENDIF.
   endif.
  DATA(GENERAL_SUBRC) = SY-SUBRC.

* //br300896 das hier folgende Coding wurde in einer Form-Routine
* gekapselt (1:1 Kopie), da es auch für die Customer-Exits gebraucht
* wurde

*  PERFORM HANDLE_ERROR_EXT             " //br40
*              TABLES                                        "
*                 IDOC_CONTRL                                "
*                 IDOC_STATUS                                "
*                 RETURN_VARIABLES                           "
*                 T_MERRDAT                                  "
*                 T_IDOC_TRANC                               "
*                 T_IDOC_MATNR          "JH/4.0C/KPr100004993
*              USING
*                 IM_KZ_TEST                                    "
*                 GENERAL_SUBRC                              "
*                 NO_APPLICATION_LOG                         "
*                 MASSSAVEINFOS         "wk/40c
*              CHANGING                                      "
*                 WORKFLOW_RESULT.                           "
** PERFORM handle_error                          "
**             TABLES                            "
**                idoc_contrl                    "
**                idoc_status                    "
**                return_variables               "
**                t_merrdat                      "
**             USING                             "
**                general_subrc                  "
**             CHANGING                          "
**                workflow_result.               "

* ALE ditribution unity : update IDOC status                "note0361838
*  LOOP AT it_dsp_idocstat.                                  "note0361838
*     LOOP AT IDOC_STATUS WHERE DOCNUM = it_dsp_idocstat.    "note0361838
*        DELETE idoc_status INDEX sy-tabix.                  "note0361838
*     ENDLOOP.                                               "note0361838
*     APPEND it_dsp_idocstat TO idoc_status.                 "note0361838
*  ENDLOOP.                                                  "note0361838

ENDFUNCTION.
