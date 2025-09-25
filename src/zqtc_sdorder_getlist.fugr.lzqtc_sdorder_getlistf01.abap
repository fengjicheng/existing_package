*----------------------------------------------------------------------*
* FUNCTION MODULE NAME:ZQTC_SDORDER_GETDETAILEDLIST (Get Subscription Order data)
* PROGRAM DESCRIPTION:Function Module for Sales Order Data
* DEVELOPER: Siva Guda ( SGUDA)
* CREATION DATE:   02/05/2016
* OBJECT ID: E096
* TRANSPORT NUMBER(S): ED2K910734
*----------------------------------------------------------------------*

*---------------------------------------------------------------------*
***INCLUDE LZQTC_SDORDER_GETLISTF01.
*&---------------------------------------------------------------------*
*&      Form  GET_TEXTHEAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SALES_DOCUMENTS  text
*      <--P_LI_THEAD  text
*----------------------------------------------------------------------*
FORM GET_TEXTHEAD  TABLES P_LI_THEAD STRUCTURE TY_THEAD
                          P_SALES_DOCUMENTS STRUCTURE ZQTC_SO_RANGE.
  TYPES : BEGIN OF LTY_VBELN,
            SIGN   TYPE TVARV_SIGN,                                  " Sign
            OPTION TYPE TVARV_OPTI,                                  " Option
            LOW    TYPE TDOBNAME,                                       " Sales Office
            HIGH   TYPE TDOBNAME,                                       " Sales Office
          END OF LTY_VBELN.
  DATA : LST_SALES_DOCUMENTS LIKE LINE OF P_SALES_DOCUMENTS,
         LI_XTHEAD           TYPE TABLE OF THEAD, " OCCURS 0 WITH HEADER LINE,
         LST_XTHEAD          LIKE LINE OF LI_XTHEAD,
         LST_TDNAME          LIKE THEAD-TDNAME,
         LR_VBELN            TYPE STANDARD TABLE OF LTY_VBELN INITIAL SIZE 0,
         LST_VBELN           TYPE LTY_VBELN,
         LT_STXH             TYPE STANDARD TABLE OF STXH,
         LST_STXH            TYPE STXH,
         LST_VBAK            TYPE VBAK.
  CONSTANTS:LC_I  TYPE CHAR1  VALUE 'I',
            LC_CP TYPE CHAR2  VALUE 'CP',
            LC_*  TYPE CHAR1  VALUE '*'.
*- Clear Work areas and internal tables
  REFRESH:LR_VBELN,LT_STXH,LI_XTHEAD.
  CLEAR:LST_SALES_DOCUMENTS,LST_XTHEAD,LST_TDNAME,LST_VBELN,LST_STXH.

*- Check entries
  IF LI_VBAK[] IS NOT INITIAL.
*- Fill Range table for selection
      LOOP AT LI_VBAK INTO LST_VBAK.
        LST_VBELN-SIGN    = LC_I.
        LST_VBELN-OPTION  = LC_CP.
        LST_VBELN-LOW    = LST_VBAK-VBELN.
        LST_VBELN-LOW+10 = LC_*.
        APPEND LST_VBELN TO LR_VBELN. " Billing Doc type
        CLEAR: LST_VBELN,LST_VBAK.
      ENDLOOP.
*- STXD SAPscript text file header
    SELECT * FROM STXH
             INTO TABLE LT_STXH
             WHERE TDOBJECT IN ('VBBK','VBBP')
             AND  TDNAME IN LR_VBELN.
*- Populating to original internal table
    LOOP AT LT_STXH INTO LST_STXH.
      MOVE-CORRESPONDING LST_STXH TO LST_XTHEAD.
      APPEND LST_XTHEAD TO P_LI_THEAD.
      CLEAR : LST_XTHEAD,LST_STXH.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TEXTLINES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_THEAD  text
*      -->P_LI_STX_LINES  text
*----------------------------------------------------------------------*
FORM GET_TEXTLINES  TABLES   P_LI_THEAD STRUCTURE TY_THEAD
                             P_LI_STX_LINES STRUCTURE BAPITEXTLI.

  STATICS : BEGIN OF TY_LANG,
              LANGU     TYPE BAPITEXTLI-LANGU,
              LANGU_ISO TYPE BAPITEXTLI-LANGU_ISO,
            END OF TY_LANG.

  DATA: LI_FXTHEAD       TYPE TABLE OF THEADVB,
        LST_LI_THEAD     LIKE LINE OF LI_FXTHEAD,
        LI_TLINETAB      TYPE TABLE OF TLINE,
        LST_TLINETAB     LIKE LINE OF LI_TLINETAB,
        V_LINE_NO        LIKE P_LI_STX_LINES-LINE_CNT,
        LST_LI_STX_LINES LIKE LINE OF P_LI_STX_LINES,
        V_INDEX          LIKE SY-TABIX,
        LI_THEAD_T       TYPE THEAD.

  REFRESH:LI_FXTHEAD.
  LI_FXTHEAD[] = P_LI_THEAD[].
*- Process the loop for hedaer table
  CLEAR LST_LI_THEAD.
  LOOP AT LI_FXTHEAD INTO LST_LI_THEAD.
    V_INDEX = SY-TABIX.
    CLEAR V_LINE_NO.
    MOVE-CORRESPONDING LST_LI_THEAD TO LI_THEAD_T.
*-SAPscript: Text lesen -----------------------------------------------
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        ID              = LST_LI_THEAD-TDID
        LANGUAGE        = LST_LI_THEAD-TDSPRAS
        NAME            = LST_LI_THEAD-TDNAME
        OBJECT          = LST_LI_THEAD-TDOBJECT
      IMPORTING
        HEADER          = LI_THEAD_T
      TABLES
        LINES           = LI_TLINETAB
      EXCEPTIONS
        ID              = 01
        LANGUAGE        = 02
        NAME            = 03
        NOT_FOUND       = 04
        OBJECT          = 05
        REFERENCE_CHECK = 06
        ERROR_MESSAGE   = 7
        OTHERS          = 8.
    CASE SY-SUBRC.
      WHEN 0.
        CALL FUNCTION 'TEXT_INCLUDE_REPLACE'
          EXPORTING
            HEADER        = LI_THEAD_T
          IMPORTING
            NEWHEADER     = LI_THEAD_T
          TABLES
            LINES         = LI_TLINETAB
          EXCEPTIONS
            ERROR_MESSAGE = 1
            OTHERS        = 2.
        LOOP AT LI_TLINETAB INTO LST_TLINETAB.
          V_LINE_NO = V_LINE_NO + 1.
          READ TABLE LI_FXTHEAD INTO LST_LI_THEAD INDEX V_INDEX.
          CASE LST_LI_THEAD-UPDKZ.
            WHEN 'U' OR ''.
              LST_LI_STX_LINES-OPERATION = '004'.
            WHEN 'I'.
              LST_LI_STX_LINES-OPERATION = '009'.
            WHEN 'E' OR 'D'.
              LST_LI_STX_LINES-OPERATION = '003'.
          ENDCASE.
          LST_LI_STX_LINES-APPLOBJECT = LST_LI_THEAD-TDOBJECT.
          LST_LI_STX_LINES-TEXT_NAME = LST_LI_THEAD-TDNAME.
          LST_LI_STX_LINES-TEXT_ID = LST_LI_THEAD-TDID.
          LST_LI_STX_LINES-LANGU = LST_LI_THEAD-TDSPRAS.
          IF NOT LST_LI_STX_LINES-LANGU IS INITIAL.
            IF LST_LI_STX_LINES-LANGU = TY_LANG-LANGU.
              LST_LI_STX_LINES-LANGU_ISO = TY_LANG-LANGU_ISO.
            ELSE.
              CALL FUNCTION 'LANGUAGE_CODE_SAP_TO_ISO'
                EXPORTING
                  SAP_CODE      = LST_LI_STX_LINES-LANGU
                IMPORTING
                  ISO_CODE      = LST_LI_STX_LINES-LANGU_ISO
                EXCEPTIONS
                  NOT_FOUND     = 1
                  ERROR_MESSAGE = 2
                  OTHERS        = 3.
              TY_LANG-LANGU     = LST_LI_STX_LINES-LANGU.
              TY_LANG-LANGU_ISO = LST_LI_STX_LINES-LANGU_ISO.
            ENDIF.
          ENDIF.
          LST_LI_STX_LINES-LINE_CNT = V_LINE_NO.
          LST_LI_STX_LINES-LINE = LST_TLINETAB-TDLINE.
          LST_LI_STX_LINES-FORMAT_COL = LST_TLINETAB-TDFORMAT.
          APPEND LST_LI_STX_LINES TO P_LI_STX_LINES.
          CLEAR : LST_LI_STX_LINES, LST_TLINETAB.
        ENDLOOP.
    ENDCASE.
    CLEAR: LI_TLINETAB.
    REFRESH: LI_TLINETAB.
  ENDLOOP.

ENDFORM.
