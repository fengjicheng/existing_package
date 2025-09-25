*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_GRP_MAPPING_913
*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_MAT_GRP_MAPPING_913
* PROGRAM DESCRIPTION: Material group 1 to 4 mapping
* DEVELOPER:           AMOHAMMED
* CREATION DATE:       12-04-2020
* OBJECT ID:           E0970 - OTCM-29848
* TRANSPORT NUMBER(S): ED2K920664
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K921315
* REFERENCE NO: OTCM-29848 / 41634
* DEVELOPER:    AMOHAMMED
* DATE:         2021-02-02
* DESCRIPTION:  Material Group 5 mapping
*----------------------------------------------------------------------*
TYPES : BEGIN OF lty_mvke,
          matnr TYPE matnr, " Material Number
          vkorg TYPE vkorg, " Sales Organization
          vtweg TYPE vtweg, " Distribution Channel
          mvgr1 TYPE mvgr1, " Material group 1
          mvgr2 TYPE mvgr2, " Material group 2
          mvgr3 TYPE mvgr3, " Material group 3
          mvgr4 TYPE mvgr4, " Material group 4
          mvgr5 TYPE mvgr5, " Material group 5 " ED2K921315
        END OF lty_mvke.
DATA : lst_mvke TYPE lty_mvke.
SELECT SINGLE matnr "  Material Number
              vkorg " Sales Organization
              vtweg " Distribution Channel
              mvgr1 " Material group 1
              mvgr2 " Material group 2
              mvgr3 " Material group 3
              mvgr4 " Material group 4
              mvgr5 " Material group 5 " ED2K921315
  FROM mvke
  INTO lst_mvke
  WHERE matnr EQ cvbap-matnr
    AND vkorg EQ cvbak-vkorg
    AND vtweg EQ cvbak-vtweg.
IF sy-subrc EQ 0.
  vbap-mvgr1 = lst_mvke-mvgr1.
  vbap-mvgr2 = lst_mvke-mvgr2.
  vbap-mvgr3 = lst_mvke-mvgr3.
  vbap-mvgr4 = lst_mvke-mvgr4.
  vbap-mvgr5 = lst_mvke-mvgr5. " ED2K921315
ENDIF.
