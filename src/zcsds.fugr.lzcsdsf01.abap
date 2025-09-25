*----------------------------------------------------------------------*
*   INCLUDE LCSDSF01                                                   *
*----------------------------------------------------------------------*
*   Subprograms BOM-Distribution: Data Conversion                      *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  UNIT_CODES_SAP_TO_ISO
*&---------------------------------------------------------------------*
*       convert units from SAP to ISO Standard                         *
*----------------------------------------------------------------------*
FORM unit_codes_sap_to_iso
  USING     sap_code  LIKE t006-msehi
  CHANGING  iso_code  LIKE t006-isocode.

  IF sap_code IS INITIAL.
    CLEAR iso_code.
  ELSE.
    CALL FUNCTION 'UNIT_OF_MEASURE_SAP_TO_ISO'
      EXPORTING
        sap_code = sap_code
      IMPORTING
        iso_code = iso_code.
*      exceptions
*           not_found   = 1
*           no_iso_code = 2
*           others      = 3.
  ENDIF.
ENDFORM.                               "UNIT_CODES_SAP_TO_ISO

*---------------------------------------------------------------------*
*       FORM UNIT_CODES_ISO_TO_SAP                                    *
*---------------------------------------------------------------------*
*       converts ISO unit to SAP code                                 *
*---------------------------------------------------------------------*
FORM unit_codes_iso_to_sap
       USING    iso_code        LIKE t006-isocode
       CHANGING sap_code        LIKE t006-msehi.

*dIF ISO_CODE IS INITIAL.                                  "note 520417
*d  CLEAR SAP_CODE.                                        "note 520417
*dELSE.                                                    "note 520417

  CLEAR sap_code.                                          "note 520417

  IF NOT iso_code IS INITIAL.                              "note 520417
    CALL FUNCTION 'UNIT_OF_MEASURE_ISO_TO_SAP'
      EXPORTING
        iso_code  = iso_code
      IMPORTING
        sap_code  = sap_code
      EXCEPTIONS
*d            OTHERS   = 0.                                "note 520417
        not_found = 1.                               "note 520417

    IF sy-subrc NE 0.                                      "note 520417
      CALL FUNCTION 'T006_READ'                            "note 557686
        EXPORTING                                       "note 557686
          flg_error = 'X'                            "note 557686
          flg_text  = ' '                            "note 557686
          msehi     = iso_code                       "note 557686
          spras     = sy-langu                       "note 557686
        EXCEPTIONS                                      "note 557686
          OTHERS    = 1.                             "note 557686
      IF sy-subrc EQ 0.                                    "note 557686
        sap_code = iso_code.                              "note 520417
      ENDIF.                                               "note 557686
    ENDIF.                                                 "note 520417
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  STPO_INTERNAL_TO_API
*&---------------------------------------------------------------------*
*       convert internal STPO data to API_STPO data                    *
*----------------------------------------------------------------------*
FORM stpo_internal_to_api USING p_tabix LIKE sy-tabix.
* fill api_stpo1
* STPO
  PERFORM itab_to_api_init USING 'STPOI'
                                  p_tabix
                                 'API_STPO1'
                                 'STPO_API01'
                                  c_true.
  PERFORM itab_to_api USING 'POSTP' 'ITEM_CATEG'.
  PERFORM itab_to_api USING 'POSNR' 'ITEM_NO'.
  PERFORM itab_to_api USING 'IDNRK' 'COMPONENT'.
  PERFORM itab_to_api USING 'MENGE' 'COMP_QTY'.
  PERFORM itab_to_api USING 'MEINS' 'COMP_UNIT'.
  PERFORM itab_to_api USING 'FMENG' 'FIXED_QTY'.
  PERFORM itab_to_api USING 'POTX1' 'ITEM_TEXT1'.
  PERFORM itab_to_api USING 'POTX2' 'ITEM_TEXT2'.
  PERFORM itab_to_api USING 'SORTF' 'SORTSTRING'.
  PERFORM itab_to_api USING 'SANKA' 'REL_COST'.
  PERFORM itab_to_api USING 'SANKO' 'REL_ENGIN'.
  PERFORM itab_to_api USING 'SANIN' 'REL_PMAINT'.
  PERFORM itab_to_api USING 'SANFE' 'REL_PROD'.
  PERFORM itab_to_api USING 'RVREL' 'REL_SALES'.
  PERFORM itab_to_api USING 'ERSKZ' 'SPARE_PART'.
  PERFORM itab_to_api USING 'BEIKZ' 'MAT_PROVIS'.
  PERFORM itab_to_api USING 'SCHGT' 'BULK_MAT'.
  PERFORM itab_to_api USING 'REKRS' 'REC_ALLOWD'.
  PERFORM itab_to_api USING 'AUSCH' 'COMP_SCRAP'.
  PERFORM itab_to_api USING 'AVOAU' 'OP_SCRAP'.
  PERFORM itab_to_api USING 'NETAU' 'OP_NET_IND'.
  PERFORM itab_to_api USING 'VERTI' 'DISTR_KEY'.
  PERFORM itab_to_api USING 'DSPST' 'EXPL_TYPE'.
  PERFORM itab_to_api USING 'LGORT' 'ISSUE_LOC'.
  PERFORM itab_to_api USING 'NLFZT' 'LEAD_TIME'.
  PERFORM itab_to_api USING 'NLFZV' 'OP_LEAD_TM'.
  PERFORM itab_to_api USING 'NLFMV' 'OP_LT_UNIT'.
  PERFORM itab_to_api USING 'KZKUP' 'CO_PRODUCT'.
  PERFORM itab_to_api USING 'NFEAG' 'DISCON_GRP'.
  PERFORM itab_to_api USING 'NFGRP' 'FOLLOW_GRP'.
  PERFORM itab_to_api USING 'ALPGR' 'AI_GROUP'.
  PERFORM itab_to_api USING 'ALPST' 'AI_STRATEG'.
  PERFORM itab_to_api USING 'ALPRF' 'AI_PRIO'.
  PERFORM itab_to_api USING 'EWAHR' 'USAGE_PROB'.
  PERFORM itab_to_api USING 'STKKZ' 'PM_ASSMBLY'.
  PERFORM itab_to_api USING 'SAKTO' 'COST_ELEM'.
  PERFORM itab_to_api USING 'LIFZT' 'DELIV_TIME'.
  PERFORM itab_to_api USING 'WEBAZ' 'GRP_TIME'.
  PERFORM itab_to_api USING 'MATKL' 'MAT_GROUP'.
  PERFORM itab_to_api USING 'PREIS' 'PRICE'.
  PERFORM itab_to_api USING 'PEINH' 'PRICE_UNIT'.
  PERFORM itab_to_api USING 'WAERS' 'CURRENCY'.
  PERFORM itab_to_api USING 'EKGRP' 'PURCH_GRP'.
  PERFORM itab_to_api USING 'EKORG' 'PURCH_ORG'.
  PERFORM itab_to_api USING 'LIFNR' 'VENDOR'.
  PERFORM itab_to_api USING 'ROANZ' 'VSI_NO'.
  PERFORM itab_to_api USING 'ROMEN' 'VSI_QTY'.
  PERFORM itab_to_api USING 'ROMS1' 'VSI_SIZE1'.
  PERFORM itab_to_api USING 'ROMS2' 'VSI_SIZE2'.
  PERFORM itab_to_api USING 'ROMS3' 'VSI_SIZE3'.
  PERFORM itab_to_api USING 'ROMEI' 'VSI_SZUNIT'.
  PERFORM itab_to_api USING 'RFORM' 'VSI_FORMUL'.
  PERFORM itab_to_api USING 'DOKNR' 'DOCUMENT'.
  PERFORM itab_to_api USING 'DOKAR' 'DOC_TYPE'.
  PERFORM itab_to_api USING 'DOKTL' 'DOC_PART'.
  PERFORM itab_to_api USING 'DOKVR' 'DOC_VERS'.
  PERFORM itab_to_api USING 'CLASS' 'CLASS'.
  PERFORM itab_to_api USING 'KLART' 'CLASS_TYPE'.
  PERFORM itab_to_api USING 'POTPR' 'RES_ITM_CT'.
  PERFORM itab_to_api USING 'KZCLB' 'SEL_COND'.
  PERFORM itab_to_api USING 'CLOBK' 'REQD_COMP'.
  PERFORM itab_to_api USING 'CLMUL' 'MULT_SELEC'.            "Note_2711777
  PERFORM itab_to_api USING 'DATUV' 'VALID_FROM'.
  PERFORM itab_to_api USING 'AENNR' 'CHANGE_NO'.
  PERFORM itab_to_api USING 'PRVBE' 'SUPPLYAREA'.
  PERFORM itab_to_api USING 'RFPNT' 'REFPOINT'.
  PERFORM itab_to_api USING 'ITSOB' 'SPPROCTYPE'.
  SHIFT stpoi-knobj LEFT DELETING LEADING '0'.
  PERFORM itab_to_api USING 'KNOBJ' 'IDENTIFIER'.
  SHIFT api_stpo1-identifier RIGHT DELETING TRAILING space.
  OVERLAY api_stpo1-identifier WITH '0000000000'.
  PERFORM itab_to_api USING 'GUIDX' 'ITEM_GUID'.            "note567351

ENHANCEMENT-POINT unit_codes_sap_to_iso_01 SPOTS es_saplcsds.
* mapping customer fields stpoi -> api_stpo1
  PERFORM itab_customerfields_to_api USING 'CSCI_STPO'.

* fill api_stpo3 (external position identification)
  MOVE-CORRESPONDING api_stpo1 TO api_stpo3.
  WRITE stpoi-lkenz TO api_stpo3-fldelete.
  IF stpoi-id_itm_ctg IS INITIAL AND                        "note723692
     stzub-vbkz NE c_bom_update.    "not SMD                 "note831468
*   no ext.ID given, use internal ID (STPO) if not SMD change request
*   IF a new item is distributed via SMD do not populate the ext. ID
*   fields. As a result the ext. ID fields allows us later to
*   decide whether the item has to be created or changed.
*    ( SMD + initial ext. ID => new item )
    PERFORM itab_to_api_init USING 'STPOI'
                                    p_tabix
                                   'API_STPO3'
                                   'STPO_API03'
                                    space.
    PERFORM itab_to_api USING 'POSTP' 'ID_ITM_CTG'.
    PERFORM itab_to_api USING 'POSNR' 'ID_ITEM_NO'.
    PERFORM itab_to_api USING 'IDNRK' 'ID_COMP'.
    PERFORM itab_to_api USING 'CLASS' 'ID_CLASS'.
    PERFORM itab_to_api USING 'KLART' 'ID_CL_TYPE'.
    PERFORM itab_to_api USING 'DOKNR' 'ID_DOC'.
    PERFORM itab_to_api USING 'DOKAR' 'ID_DOC_TYP'.
    PERFORM itab_to_api USING 'DOKTL' 'ID_DOC_PRT'.
    PERFORM itab_to_api USING 'DOKVR' 'ID_DOC_VRS'.
    PERFORM itab_to_api USING 'SORTF' 'ID_SORT'.
  ELSE.
*   external ID given (CSIDENT_02)
    PERFORM itab_to_api_init USING 'STPOI'
                                    p_tabix
                                   'API_STPO3'
                                   'STPO_API03'
                                    space.
    PERFORM itab_to_api USING 'ID_ITM_CTG' 'ID_ITM_CTG'.
    PERFORM itab_to_api USING 'ID_ITEM_NO' 'ID_ITEM_NO'.
    PERFORM itab_to_api USING 'ID_COMP'    'ID_COMP'.
    PERFORM itab_to_api USING 'ID_CLASS'   'ID_CLASS'.
    PERFORM itab_to_api USING 'ID_CL_TYPE' 'ID_CL_TYPE'.
    PERFORM itab_to_api USING 'ID_DOC'     'ID_DOC'.
    PERFORM itab_to_api USING 'ID_DOC_TYP' 'ID_DOC_TYP'.
    PERFORM itab_to_api USING 'ID_DOC_PRT' 'ID_DOC_PRT'.
    PERFORM itab_to_api USING 'ID_DOC_VRS' 'ID_DOC_VRS'.
    PERFORM itab_to_api USING 'ID_SORT'    'ID_SORT'.
  ENDIF.

  PERFORM itab_to_api USING 'ID_GUID' 'ID_GUID'.            "note567351

  APPEND api_stpo3.

ENDFORM.                               " STPO_INTERNAL_TO_API

*---------------------------------------------------------------------*
*        FORM CONVERT_UPDATE_LOGIC                                    *
*---------------------------------------------------------------------*
*  conversion of IDOC update logic to API update logic:               *
*      IDOC             API                   DB
*      new_data         new_data        ->    new_data
*      initial          data_reset_sign ->    initial
*      no_update_sign   initial         ->    old_data
*---------------------------------------------------------------------*
FORM convert_update_logic USING itabname        LIKE dntab-tabname
                                tabname         LIKE dntab-tabname.

  DATA: nametab LIKE dfies OCCURS 0 WITH HEADER LINE,
        hlp_fld TYPE c.

  FIELD-SYMBOLS:
    <f1>     TYPE any,                                   "UC-Test
    <fstruc> TYPE any.                                   "UC-Test

  ASSIGN (itabname) TO <fstruc>.

  CHECK stzub-vbkz NE c_bom_insert.

* get namtab
  CALL FUNCTION 'DDIF_NAMETAB_GET'
    EXPORTING
      tabname   = tabname
    TABLES
      dfies_tab = nametab
    EXCEPTIONS
      OTHERS    = 0.

* conversion
  LOOP AT nametab
    WHERE inttype = 'N' OR             " nichtnumerisch?
          inttype = 'C'.
    ASSIGN COMPONENT nametab-fieldname OF STRUCTURE <fstruc> TO <f1>.
*d  hlp_fld = <f1>.                                        " UC-Test
    WRITE <f1> TO hlp_fld.                                 " UC-Test
    IF <f1> IS INITIAL.
      <f1> = c_data_reset.
    ELSEIF hlp_fld = c_nodata.
      CLEAR <f1>.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " CONVERT_UPDATE_LOGIC

*---------------------------------------------------------------------*
*        FORM APPL_LOG_WRITE_SINGLE_MESSAGE                           *
*---------------------------------------------------------------------*
*  Nachrichten in den Application Log schreiben                       *
*---------------------------------------------------------------------*
FORM appl_log_write_single_message USING
                                      VALUE(msgty) LIKE balmi-msgty
                                      VALUE(msgid) LIKE balmi-msgid
                                      VALUE(msgno) LIKE bdidocstat-msgno
                                      VALUE(msgv1) TYPE c
                                      VALUE(msgv2) TYPE c
                                      VALUE(msgv3) TYPE c
                                      VALUE(msgv4) TYPE c.

  DATA: msg LIKE balmi.

  msg-msgty = msgty.
  msg-msgid = msgid.
  msg-msgno = msgno.
  WRITE msgv1 TO msg-msgv1.
  WRITE msgv2 TO msg-msgv2.
  WRITE msgv3 TO msg-msgv3.
  WRITE msgv4 TO msg-msgv4.

  CALL FUNCTION 'STAP_LOG_WRITE_SINGLE_MESSAGE'
    EXPORTING
      message                 = msg
    EXCEPTIONS
      log_object_not_found    = 0
      log_subobject_not_found = 0
      OTHERS                  = 0.

ENDFORM.

*---------------------------------------------------------------------*
*        FORM COMPARE_HEADER                                          *
*---------------------------------------------------------------------*
*  compare old and new header                                         *
*---------------------------------------------------------------------*
FORM compare_header USING VALUE(stko_old) LIKE stko_api01
                    CHANGING stko_new     LIKE stko_api01.

  DATA: nametab    LIKE dfies OCCURS 0 WITH HEADER LINE,
        hlp_tab    TYPE ddobjname,
        l_changed  TYPE c,
        l_stko_new LIKE dntab-tabname VALUE 'STKO_NEW',
        l_stko_old LIKE dntab-tabname VALUE 'STKO_OLD'.

  DATA: ls_tabfield TYPE tabfield,
        l_bmeng     LIKE stkob-bmeng.

  FIELD-SYMBOLS: <old>       TYPE any,
                 <new>       TYPE any,
                 <old_struc> TYPE any,
                 <new_struc> TYPE any.

  IF stko_new EQ stko_old.
    CLEAR stko_new.
    EXIT.
  ENDIF.

  ASSIGN (l_stko_old) TO <old_struc>.
  ASSIGN (l_stko_new) TO <new_struc>.

* get nametab
  hlp_tab = 'STKO_API01'.

  CALL FUNCTION 'DDIF_NAMETAB_GET'
    EXPORTING
      tabname   = hlp_tab
    TABLES
      dfies_tab = nametab
    EXCEPTIONS
      OTHERS    = 0.

* conversion
  LOOP AT nametab.
    ASSIGN COMPONENT nametab-fieldname
      OF STRUCTURE <old_struc> TO <old>.
    ASSIGN COMPONENT nametab-fieldname
      OF STRUCTURE <new_struc> TO <new>.
    CHECK NOT <new> IS INITIAL.

    IF <new> NE <old>.
      IF nametab-fieldname EQ 'BASE_QUAN'.
        IF stko_new-base_quan NE c_data_reset.
          ls_tabfield-tabname = 'STKO'.
          ls_tabfield-fieldname = 'BMENG'.
          CALL FUNCTION 'RS_CONV_EX_2_IN'
            EXPORTING
              input_external  = stko_old-base_quan
              table_field     = ls_tabfield
            IMPORTING
              output_internal = l_bmeng
            EXCEPTIONS
              OTHERS          = 1.

          IF sy-subrc EQ 0.
            CLEAR <old>.
            WRITE l_bmeng TO <old> UNIT stko_old-base_quan.
          ELSE.
          ENDIF.
          IF <new> NE <old>.
            l_changed = 'X'.
            EXIT.
          ENDIF.
        ENDIF.
      ELSE.
        l_changed = 'X'.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF l_changed IS INITIAL.
    CLEAR stko_new.
  ENDIF.

ENDFORM.
