*----------------------------------------------------------------------*
*   INCLUDE RJKSDDEMANDCHANGE_VARIANT                                  *
*----------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       FORM convert_to_params
*---------------------------------------------------------------------*
FORM CONVERT_TO_PARAMS USING
                                PV_VKORG  LIKE GV_VKORG
                                PV_VTWEG  LIKE GV_VTWEG
*                                PV_SPART  LIKE GV_SPART
                                PV_WERK   LIKE GV_WERK
                                PR_PRULE  LIKE GR_PRULE[]
                                PR_MPROD  LIKE GR_MPROD[]
                                PR_ISSUE   LIKE GR_ISSUE[]     "SEL_ISSUE
                                PR_PTYPE  LIKE GR_PTYPE[]
                                PR_MTYPE  LIKE GR_MTYPE[]
                                PR_MSTAV  LIKE GR_MSTAV[]
                                PR_VMSTA  LIKE GR_MSTAV[]
                                PR_MSTAE  LIKE GR_MSTAV[]
                                PR_MMSTA  LIKE GR_MSTAV[]
                                pv_filt   like gv_filt      "TK01042009
*                               pr_phmod  like gr_phmod[]   "TK01022008
*                               pr_phnr   like gr_phnr[]    "TK01022008
*                               pv_norm   like gv_norm      "TK01022008
*                               pv_incl   like gv_incl      "TK01022008
*                               pv_excl   like gv_excl      "TK01022008
  CHANGING PT_PARAMS  TYPE RSPARAMS_TT
           PT_UNKNOWN TYPE RSPARAMS_TT.

  DATA: LS_PARAMS TYPE RSPARAMS.

  DEFINE APPEND_RANGE_TO_PARAMS.
    DATA: LS_&2 LIKE LINE OF &1.
    LOOP AT &1 INTO LS_&2 WHERE NOT SIGN IS INITIAL.
      CLEAR LS_PARAMS.
      LS_PARAMS-SELNAME = '&1'.
      LS_PARAMS-KIND    = 'S'.
      MOVE-CORRESPONDING LS_&2 TO LS_PARAMS.
      APPEND LS_PARAMS TO PT_PARAMS.
    ENDLOOP.
  END-OF-DEFINITION.
*
  DEFINE APPEND_FIELD_TO_PARAMS.
    IF NOT &1 IS INITIAL.
      CLEAR LS_PARAMS.
      LS_PARAMS-SELNAME = '&1'.
      LS_PARAMS-KIND    = 'P'.
      LS_PARAMS-SIGN    = 'I'.
      LS_PARAMS-OPTION  = 'EQ'.
      LS_PARAMS-LOW     = &2.
      APPEND LS_PARAMS TO PT_PARAMS.
    ENDIF.
  END-OF-DEFINITION.
*
  REFRESH PT_PARAMS.
*
  APPEND_RANGE_TO_PARAMS GR_MPROD PR_MPROD.
  APPEND_RANGE_TO_PARAMS GR_ISSUE PR_ISSUE.      "SEL_ISSUE
  APPEND_RANGE_TO_PARAMS GR_PRULE PR_PRULE.
  APPEND_RANGE_TO_PARAMS GR_PTYPE PR_PTYPE.
  APPEND_RANGE_TO_PARAMS GR_MTYPE PR_MTYPE.
  APPEND_RANGE_TO_PARAMS GR_MSTAV PR_MSTAV.
  APPEND_RANGE_TO_PARAMS GR_VMSTA PR_VMSTA.
  APPEND_RANGE_TO_PARAMS GR_MSTAE PR_MSTAE.
  APPEND_RANGE_TO_PARAMS GR_MMSTA PR_MMSTA.
  APPEND_FIELD_TO_PARAMS GV_VKORG PV_VKORG.
  APPEND_FIELD_TO_PARAMS GV_VTWEG PV_VTWEG.
*  APPEND_FIELD_TO_PARAMS GV_SPART PV_SPART.
  APPEND_FIELD_TO_PARAMS GV_WERK  PV_WERK .
* APPEND_RANGE_TO_PARAMS GR_phmod PR_phmod.                 "TK01022008
* APPEND_RANGE_TO_PARAMS GR_phnr PR_phnr.                   "TK01022008
* APPEND_FIELD_TO_PARAMS Gv_norm  Pv_norm .                 "TK01022008
* APPEND_FIELD_TO_PARAMS Gv_incl  Pv_incl .                 "TK01022008
* APPEND_FIELD_TO_PARAMS Gv_excl  Pv_excl .                 "TK01022008
  APPEND_FIELD_TO_PARAMS GV_FILT PV_FILT.                   "TK01042009

*
  IF NOT PT_UNKNOWN[] IS INITIAL.
    APPEND LINES OF PT_UNKNOWN TO PT_PARAMS.
  ENDIF.

ENDFORM.                    "CONVERT_TO_PARAMS

*---------------------------------------------------------------------*
*       FORM convert_from_params                                      *
*---------------------------------------------------------------------*
FORM CONVERT_FROM_PARAMS USING    PT_PARAMS  TYPE RSPARAMS_TT
                         CHANGING PT_UNKNOWN TYPE RSPARAMS_TT
                                  PV_VKORG   LIKE GV_VKORG
                                  PV_VTWEG   LIKE GV_VTWEG
*                                  PV_SPART   LIKE GV_SPART
                                  PV_WERK    LIKE GV_WERK
                                  PR_PRULE   LIKE GR_PRULE[]
                                  PR_MPROD   LIKE GR_MPROD[]
                                  PR_ISSUE   LIKE GR_ISSUE[]     "SEL_ISSUE
                                  PR_PTYPE   LIKE GR_PTYPE[]
                                  PR_MTYPE   LIKE GR_MTYPE[]
                                  PR_MSTAV   LIKE GR_MSTAV[]
                                  PR_VMSTA   LIKE GR_MSTAV[]
                                  PR_MSTAE   LIKE GR_MSTAV[]
                                  PR_MMSTA   LIKE GR_MSTAV[]
                                  pv_filt    like gv_filt.   "TK01042009
*                                  pv_norm    like gv_norm   "TK01022008
*                                  pv_incl    like gv_incl   "TK01022008
*                                  pv_excl    like gv_excl.  "TK01022008
*                                  pr_phmod   like gr_phmod[]. "TK01022008


*
  DATA: LS_PARAMS LIKE LINE OF PT_PARAMS,
        LS_MPROD  LIKE LINE OF PR_MPROD,
        LS_ISSUE  LIKE LINE OF PR_ISSUE,       "SEL_ISSUE
        LS_PRULE  LIKE LINE OF PR_PRULE,
        LS_PTYPE  LIKE LINE OF PR_PTYPE,
        LS_MTYPE  LIKE LINE OF PR_MTYPE,
        LS_MSTAV  LIKE LINE OF PR_MSTAV,
        LS_VMSTA  LIKE LINE OF PR_VMSTA,
        LS_MSTAE  LIKE LINE OF PR_MSTAE,
        LS_MMSTA  LIKE LINE OF PR_MMSTA.
*       LS_phmod  LIKE LINE OF PR_phmod.                    "TK01022008


*

*  DATA: lv_editmask(7) TYPE c,
*        lv_cexit TYPE convexit.
*
  CLEAR:   PV_VKORG, PV_VTWEG, PV_WERK.  "PV_SPART
  REFRESH : PR_PRULE, PR_MPROD, PR_MTYPE, PR_PTYPE,
            PR_MSTAV, PR_VMSTA, PR_MSTAE, PR_MMSTA.
* refresh   pr_phmod.                                       "TK01022008
* clear     pv_norm.                                        "TK01022008
* clear     pv_incl.                                        "TK01022008
* clear     pv_excl.                                        "TK01022008
  clear     pv_filt.                                        "TK01042009

  refresh   pr_issue.                                  "SEL_ISSUE

  REFRESH: GT_UNKNOWN_PARAMS.
*
  LOOP AT PT_PARAMS INTO LS_PARAMS.
    CASE LS_PARAMS-SELNAME.
      WHEN 'GR_ISSUE'.                                  "SEL_ISSUE
        MOVE-CORRESPONDING LS_PARAMS TO LS_ISSUE.       "SEL_ISSUE
        APPEND LS_ISSUE TO PR_ISSUE.                    "SEL_ISSUE
      WHEN 'GR_MPROD'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_MPROD.
        APPEND LS_MPROD TO PR_MPROD.
      WHEN 'GR_PRULE'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_PRULE.
        APPEND LS_PRULE TO PR_PRULE.
      WHEN 'GR_MTYPE'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_MTYPE.
        APPEND LS_MTYPE TO PR_MTYPE.
      WHEN 'GR_PTYPE'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_PTYPE.
        APPEND LS_PTYPE TO PR_PTYPE.
      WHEN 'GR_MSTAV'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_MSTAV.
        APPEND LS_MSTAV TO PR_MSTAV.
      WHEN 'GR_VMSTA'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_VMSTA.
        APPEND LS_VMSTA TO PR_VMSTA.
      WHEN 'GR_MSTAE'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_MSTAE.
        APPEND LS_MSTAE TO PR_MSTAE.
      WHEN 'GR_MMSTA'.
        MOVE-CORRESPONDING LS_PARAMS TO LS_MMSTA.
        APPEND LS_MMSTA TO PR_MMSTA.
      WHEN 'GV_VKORG'.
        PV_VKORG = LS_PARAMS-LOW.
      WHEN 'GV_VTWEG'.
        PV_VTWEG = LS_PARAMS-LOW.
*      WHEN 'GV_SPART'.
*        PV_SPART = LS_PARAMS-LOW.
      WHEN 'GV_WERK'.
        PV_WERK = LS_PARAMS-LOW.
*      WHEN 'GR_PHMOD'.                                      "TK01022008
*        MOVE-CORRESPONDING LS_PARAMS TO LS_PHMOD.           "TK01022008
*        APPEND LS_PHMOD TO PR_PHMOD.                        "TK01022008
*      WHEN 'GV_INCL'.                                       "TK01022008
*        PV_INCL  = LS_PARAMS-LOW.                           "TK01022008
*      WHEN 'GV_EXCL'.                                       "TK01022008
*        PV_EXCL  = LS_PARAMS-LOW.                           "TK01022008
*      WHEN 'GV_NORM'.                                       "TK01022008
*        PV_NORM  = LS_PARAMS-LOW.                           "TK01022008
      WHEN 'GV_FILT'.                                        "TK01042009
        PV_FILT = LS_PARAMS-LOW.                             "TK01042009
      WHEN OTHERS.
        APPEND LS_PARAMS TO PT_UNKNOWN.
    ENDCASE.
  ENDLOOP.
ENDFORM.                    "CONVERT_FROM_PARAMS
