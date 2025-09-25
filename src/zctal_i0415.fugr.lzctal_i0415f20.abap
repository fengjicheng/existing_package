*-------------------------------------------------------------------
***INCLUDE LCTALF20 .
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  READ_DEPS_CHARACT
*&---------------------------------------------------------------------*
*
*       read dependencies for a characteristic
*
*----------------------------------------------------------------------*
*  -->  KNOBJ                           pointer for dependencies
*  -->  KEY_DATE                        key_date
*  <->  T_IDOC_DATA                     table with IDocs
*----------------------------------------------------------------------*
FORM READ_DEPS_CHARACT TABLES T_IDOC_DATA  STRUCTURE EDIDD
                       USING  KNOBJ     LIKE CABN-KNOBJ
                              CHANGE_NO LIKE CABN-AENNR
                              KEY_DATE  LIKE SY-DATUM.

  CONSTANTS:
    TABLE    LIKE CUOB-KNTAB    VALUE 'CABN'.

  DATA:
    ALLOCATIONS LIKE RCUOB1 OCCURS 30 WITH HEADER LINE,
    DATE        LIKE CAPIPARMS-DATE.

*........ tables for API ...............................................

  DATA:
    DEPENDENCY_DATA LIKE DEPDATA,
    DESCRIPTION     LIKE DEPDESCR  OCCURS 30 WITH HEADER LINE,
    DOCUMENTATION   LIKE DOC_LANG  OCCURS 30 WITH HEADER LINE,
    SOURCE          LIKE DEPSOURCE OCCURS 30 WITH HEADER LINE.

*........ dependencies exist? ..........................................

  CHECK KNOBJ GT 0.

*........ convert date .................................................

  WRITE KEY_DATE TO DATE.

*........ get all allocations ..........................................

  CALL FUNCTION 'CUKD_API_ALLOCATIONS_READ'
       EXPORTING
            ALLOCATION_NUMBER   = KNOBJ
            TABLE               = TABLE
            DATE                = KEY_DATE            "  1731721 1846636
            WITH_ALLOC_DATA     = C_MARK
            WITH_BASIC_DATA     = SPACE
            WITH_LANG_DEP_NAMES = SPACE
            WITH_DOCUS          = SPACE
            WITH_SOURCES        = SPACE
            ALL_VALID_CUOB      = 'X'                         "  1846636
       TABLES
            ALLOCATIONS         = ALLOCATIONS
       EXCEPTIONS
            ERROR               = 1
            OTHERS              = 2.

  CHECK SY-SUBRC IS INITIAL.

*........ get informations for each allocation .........................

  LOOP AT ALLOCATIONS.

    CLEAR: E1CUKBM.
    E1CUKBM-MSGFN = E1CABNM-MSGFN.

*........ global dependency ............................................

    IF ALLOCATIONS-KNNAM CN C_NUMERIC.
      E1CUKBM-DEP_INTERN = ALLOCATIONS-KNNAM.
      E1CUKBM-DEP_EXTERN = ALLOCATIONS-XKNNAM.
      E1CUKBM-DEP_LINENO = ALLOCATIONS-KNSRT.

*........ copy data into IDoc structure ...............................*

      CLEAR T_IDOC_DATA.
      T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKBM.
      T_IDOC_DATA-SDATA  = E1CUKBM.
      APPEND T_IDOC_DATA.
    ELSE.

*........ read local dependency ........................................

      CALL FUNCTION 'CARD_DEPENDENCY_READ'
           EXPORTING
                CHANGE_NO             = CHANGE_NO
                DEPENDENCY            = ALLOCATIONS-KNNAM
                DATE                  = DATE
                FL_WITH_BASIC_DATA    = C_MARK
                FL_WITH_DESCRIPTION   = C_MARK
                FL_WITH_DOCUMENTATION = C_MARK
                FL_WITH_SOURCE        = C_MARK
           IMPORTING
                DEPENDENCY_DATA       = DEPENDENCY_DATA
           TABLES
                DESCRIPTION           = DESCRIPTION
                DOCUMENTATION         = DOCUMENTATION
                SOURCE                = SOURCE
           EXCEPTIONS
                ERROR                 = 1
                OTHERS                = 2.

*........ ignore dependency if error ...................................

      IF NOT SY-SUBRC IS INITIAL.
        CONTINUE.
      ENDIF.

*........ basic data ...................................................

      E1CUKBM-DEP_INTERN = ALLOCATIONS-KNNAM.
      E1CUKBM-DEP_EXTERN = ALLOCATIONS-XKNNAM.
      MOVE-CORRESPONDING DEPENDENCY_DATA TO E1CUKBM.
      E1CUKBM-DEP_LINENO = ALLOCATIONS-KNSRT.

*........ copy data into IDoc structure ...............................*

      CLEAR T_IDOC_DATA.
      T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKBM.
      T_IDOC_DATA-SDATA  = E1CUKBM.
      APPEND T_IDOC_DATA.

*........ descriptions .................................................

      LOOP AT DESCRIPTION.
        CLEAR: E1CUKBT.
        E1CUKBT-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING DESCRIPTION TO E1CUKBT.

*........ convert language to ISO ......................................

        WRITE DESCRIPTION-LANGUAGE TO E1CUKBT-LANGUAGE_ISO.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKBT.
        T_IDOC_DATA-SDATA  = E1CUKBT.
        APPEND T_IDOC_DATA.
      ENDLOOP.  "at description

*........ sources ......................................................

      LOOP AT SOURCE.
        CLEAR: E1CUKNM.
        E1CUKNM-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING SOURCE TO E1CUKNM.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKNM.
        T_IDOC_DATA-SDATA  = E1CUKNM.
        APPEND T_IDOC_DATA.
      ENDLOOP. "  at source

*........ docu .........................................................

      LOOP AT DOCUMENTATION.
        CLEAR: E1CUTXM.
        E1CUTXM-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING DOCUMENTATION TO E1CUTXM.

*........ convert language to ISO ......................................

        WRITE DOCUMENTATION-LANGUAGE TO E1CUTXM-LANGUAGE_ISO.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUTXM.
        T_IDOC_DATA-SDATA  = E1CUTXM.
        APPEND T_IDOC_DATA.
      ENDLOOP. "  at DOCUMENTATION

    ENDIF.
  ENDLOOP.
ENDFORM.                    " READ_DEPS_CHARACT

*eject
*&---------------------------------------------------------------------*
*&      Form  READ_DEPS_VALUE
*&---------------------------------------------------------------------*
*
*       read dependencies for a characteristic value
*
*----------------------------------------------------------------------*
*  -->  KNOBJ                           pointer for dependencies
*  -->  CHANGE_NO                       change number
*  -->  KEY_DATE                        key_date
*  <->  T_IDOC_DATA                     table with IDocs
*----------------------------------------------------------------------*
FORM READ_DEPS_VALUE TABLES T_IDOC_DATA  STRUCTURE EDIDD
                     USING  KNOBJ     LIKE CABN-KNOBJ
                            CHANGE_NO LIKE CABN-AENNR
                            KEY_DATE  LIKE SY-DATUM.

  CONSTANTS:
    TABLE    LIKE CUOB-KNTAB    VALUE 'CAWN'.

  DATA:
    ALLOCATIONS LIKE RCUOB1 OCCURS 30 WITH HEADER LINE,
    DATE        LIKE CAPIPARMS-DATE.

*........ tables for API ...............................................

  DATA:
    DEPENDENCY_DATA LIKE DEPDATA,
    DESCRIPTION     LIKE DEPDESCR  OCCURS 30 WITH HEADER LINE,
    DOCUMENTATION   LIKE DOC_LANG  OCCURS 30 WITH HEADER LINE,
    SOURCE          LIKE DEPSOURCE OCCURS 30 WITH HEADER LINE.

*........ dependencies exist? ..........................................

  CHECK KNOBJ GT 0.

*........ convert date .................................................

  WRITE KEY_DATE TO DATE.

*........ get all allocations ..........................................

  CALL FUNCTION 'CUKD_API_ALLOCATIONS_READ'
       EXPORTING
            ALLOCATION_NUMBER   = KNOBJ
            TABLE               = TABLE
            DATE                = KEY_DATE            "  1731721 1846636
            WITH_ALLOC_DATA     = C_MARK
            WITH_BASIC_DATA     = SPACE
            WITH_LANG_DEP_NAMES = SPACE
            WITH_DOCUS          = SPACE
            WITH_SOURCES        = SPACE
            ALL_VALID_CUOB      = 'X'                         "  1846636
       TABLES
            ALLOCATIONS         = ALLOCATIONS
       EXCEPTIONS
            ERROR               = 1
            OTHERS              = 2.

  CHECK SY-SUBRC IS INITIAL.

*........ get informations for each allocation .........................

  LOOP AT ALLOCATIONS.

    CLEAR: E1CUKB1.
    E1CUKB1-MSGFN = E1CABNM-MSGFN.

*........ global dependency ............................................

    IF ALLOCATIONS-KNNAM CN C_NUMERIC.
      E1CUKB1-DEP_INTERN = ALLOCATIONS-KNNAM.
      E1CUKB1-DEP_EXTERN = ALLOCATIONS-XKNNAM.
      E1CUKB1-DEP_LINENO = ALLOCATIONS-KNSRT.

*........ copy data into IDoc structure ...............................*

      CLEAR T_IDOC_DATA.
      T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKB1.
      T_IDOC_DATA-SDATA  = E1CUKB1.
      APPEND T_IDOC_DATA.
    ELSE.

*........ read local dependency ........................................

      CALL FUNCTION 'CARD_DEPENDENCY_READ'
           EXPORTING
                CHANGE_NO             = CHANGE_NO
                DEPENDENCY            = ALLOCATIONS-KNNAM
                DATE                  = DATE
                FL_WITH_BASIC_DATA    = C_MARK
                FL_WITH_DESCRIPTION   = C_MARK
                FL_WITH_DOCUMENTATION = C_MARK
                FL_WITH_SOURCE        = C_MARK
           IMPORTING
                DEPENDENCY_DATA       = DEPENDENCY_DATA
           TABLES
                DESCRIPTION           = DESCRIPTION
                DOCUMENTATION         = DOCUMENTATION
                SOURCE                = SOURCE
           EXCEPTIONS
                ERROR                 = 1
                OTHERS                = 2.

*........ ignore dependency if error ...................................

      IF NOT SY-SUBRC IS INITIAL.
        CONTINUE.
      ENDIF.

*........ basic data ...................................................

      E1CUKB1-DEP_INTERN = ALLOCATIONS-KNNAM.
      E1CUKB1-DEP_EXTERN = ALLOCATIONS-XKNNAM.
      MOVE-CORRESPONDING DEPENDENCY_DATA TO E1CUKB1.
      E1CUKB1-DEP_LINENO = ALLOCATIONS-KNSRT.

*........ copy data into IDoc structure ...............................*

      CLEAR T_IDOC_DATA.
      T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKB1.
      T_IDOC_DATA-SDATA  = E1CUKB1.
      APPEND T_IDOC_DATA.

*........ descriptions .................................................

      LOOP AT DESCRIPTION.
        CLEAR: E1CUKB2.
        E1CUKB2-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING DESCRIPTION TO E1CUKB2.

*........ convert language to ISO ......................................

        WRITE DESCRIPTION-LANGUAGE TO E1CUKB2-LANGUAGE_ISO.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKB2.
        T_IDOC_DATA-SDATA  = E1CUKB2.
        APPEND T_IDOC_DATA.
      ENDLOOP.  "at description

*........ sources ......................................................

      LOOP AT SOURCE.
        CLEAR: E1CUKN1.
        E1CUKN1-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING SOURCE TO E1CUKN1.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUKN1.
        T_IDOC_DATA-SDATA  = E1CUKN1.
        APPEND T_IDOC_DATA.
      ENDLOOP. "  at source

*........ docu .........................................................

      LOOP AT DOCUMENTATION.
        CLEAR: E1CUTX1.
        E1CUTX1-MSGFN = E1CABNM-MSGFN.
        MOVE-CORRESPONDING DOCUMENTATION TO E1CUTX1.

*........ copy data into IDoc structure ...............................*

        CLEAR T_IDOC_DATA.
        T_IDOC_DATA-SEGNAM = C_SEGNAM_CUTX1.
        T_IDOC_DATA-SDATA  = E1CUTX1.
        APPEND T_IDOC_DATA.
      ENDLOOP. "  at DOCUMENTATION

    ENDIF.
  ENDLOOP.
ENDFORM.                    " READ_DEPS_VALUE

*eject
*&---------------------------------------------------------------------*
*&      Form  SAVE_DEPS_CHARACT
*&---------------------------------------------------------------------*
*
*       save dependencies for a characteristic
*
*----------------------------------------------------------------------*
*  -->  CHARACT                      characteristic
*  -->  CHANGE_NUMBER                change number
*  -->  KEY_DATE                     key date
*  -->  ERROR                        error occured
*  -->  WARNING                      warning occured
*----------------------------------------------------------------------*
FORM SAVE_DEPS_CHARACT USING CHARACT       LIKE CABN-ATNAM
                             CHANGE_NUMBER LIKE CABN-AENNR
                             KEY_DATE      LIKE SY-DATUM
                             ERROR         LIKE SY-BATCH
                             WARNING       LIKE SY-BATCH.

*........ tables for API ...............................................

  DATA:
    ALLOCATIONS LIKE RCUOB1   OCCURS 10 WITH HEADER LINE,
    BASIC_DATA  LIKE RCUKB1   OCCURS 10 WITH HEADER LINE,
    NAMES       LIKE RCUKBT1  OCCURS 10 WITH HEADER LINE,
    DOCUS       LIKE RCUKDOC1 OCCURS 10 WITH HEADER LINE,
    SOURCES     LIKE RCUKN1   OCCURS 10 WITH HEADER LINE.

*........ init .........................................................

  CLEAR:
    ERROR,
    WARNING.

  REFRESH:
    ALLOCATIONS,
    BASIC_DATA,
    NAMES,
    DOCUS,
    SOURCES.

*........ get all allocations from buffer ..............................

  LOOP AT T_E1CUKBM.

*........ save infos for allocations ...................................

    CLEAR: ALLOCATIONS.
    IF T_E1CUKBM-DEP_INTERN CO C_NUMERIC.
      ALLOCATIONS-XKNNAM = T_E1CUKBM-DEP_INTERN.
    ELSE.
      ALLOCATIONS-KNNAM  = T_E1CUKBM-DEP_INTERN.
    ENDIF.
    ALLOCATIONS-KNSRT  = T_E1CUKBM-DEP_LINENO.
    APPEND ALLOCATIONS.

*........ no additional informations for global dependency .............

    IF T_E1CUKBM-DEP_INTERN CN C_NUMERIC.
      CONTINUE.
    ENDIF.

*........ save basic data ..............................................

    CLEAR: BASIC_DATA.
    BASIC_DATA-XKNNAM = T_E1CUKBM-DEP_INTERN.
    BASIC_DATA-KNART  = T_E1CUKBM-DEP_TYPE.
    BASIC_DATA-KNSTA  = T_E1CUKBM-STATUS.
    BASIC_DATA-KNGRP  = T_E1CUKBM-GROUP.
    BASIC_DATA-KNBEO  = T_E1CUKBM-WHR_TO_USE.

*........ translate dependency type ....................................

    CALL FUNCTION 'DEPENDENCY_GET_INT_TYPE'
         EXPORTING
              DEPENDENCY_TYPE_EXT = T_E1CUKBM-DEP_TYPE
         IMPORTING
              DEPENDENCY_TYPE_INT = BASIC_DATA-KNART
         EXCEPTIONS
              DEP_TYPE_INVALID    = 1
              OTHERS              = 2.
    if not sy-subrc is initial.
      clear sy-subrc.
    endif.

    APPEND BASIC_DATA.

*........ save descriptions ............................................

    LOOP AT T_E1CUKBT
      WHERE CHARACT    EQ CHARACT
      AND   DEP_INTERN EQ T_E1CUKBM-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKBM-DEP_EXTERN.
      CLEAR: NAMES.
      NAMES-XKNNAM = T_E1CUKBM-DEP_INTERN.
      NAMES-LANGU  = T_E1CUKBT-LANGUAGE.
      NAMES-KNKTXT = T_E1CUKBT-DESCRIPT.
      APPEND NAMES.
    ENDLOOP.  " at T_E1CUKBT

*........ save docu ....................................................

    LOOP AT T_E1CUTXM
      WHERE CHARACT    EQ CHARACT
      AND   DEP_INTERN EQ T_E1CUKBM-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKBM-DEP_EXTERN.
      CLEAR: DOCUS.
      DOCUS-XKNNAM  = T_E1CUKBM-DEP_INTERN.
      DOCUS-LINE_NO = SY-TABIX.
      DOCUS-LANGU   = T_E1CUTXM-LANGUAGE.
      DOCUS-FORMAT  = T_E1CUTXM-TXT_FORM.
      DOCUS-LINE    = T_E1CUTXM-TXT_LINE.
      APPEND DOCUS.
    ENDLOOP.  " at T_E1CUTXM

*........ save sources .................................................

    LOOP AT T_E1CUKNM
      WHERE CHARACT    EQ CHARACT
      AND   DEP_INTERN EQ T_E1CUKBM-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKBM-DEP_EXTERN.
      CLEAR: SOURCES.
      SOURCES-XKNNAM  = T_E1CUKBM-DEP_INTERN.
      SOURCES-LINE_NO = SY-TABIX.
      SOURCES-LINE    = T_E1CUKNM-LINE.
      APPEND SOURCES.
    ENDLOOP.  " at T_E1CUKNM

  ENDLOOP.  " at t_e1cukbm

*........ save allocations .............................................

  CHECK SY-SUBRC IS INITIAL.
  CALL FUNCTION 'CTMV_CHARACT_CHANGE_KNOWL'
       EXPORTING
            CHANGE_NUMBER = CHANGE_NUMBER
            CHARACT       = CHARACT
            KEY_DATE      = KEY_DATE
       IMPORTING
            WARNING       = WARNING
       TABLES
            ALLOCATIONS   = ALLOCATIONS
            BASIC_DATA    = BASIC_DATA
            NAMES         = NAMES
            DOCUS         = DOCUS
            SOURCES       = SOURCES
       EXCEPTIONS
            ERROR         = 1
            OTHERS        = 2.

*........ set error flag if exception raised ...........................

  IF SY-SUBRC IS INITIAL.
    CLEAR ERROR.
  ELSE.
    ERROR = C_MARK.
  ENDIF.

ENDFORM.    " SAVE_DEPS_CHARACT

*eject
*&---------------------------------------------------------------------*
*&      Form  SAVE_DEPS_VALUE
*&---------------------------------------------------------------------*
*
*       save dependencies for characteristic's values
*
*----------------------------------------------------------------------*
*  -->  CHARACT                      characteristic
*  -->  CHANGE_NUMBER                change number
*  -->  KEY_DATE                     key date
*  -->  ERROR                        error occured
*  -->  WARNING                      warning occured
*----------------------------------------------------------------------*
FORM SAVE_DEPS_VALUE USING CHARACT       LIKE CABN-ATNAM
                           CHANGE_NUMBER LIKE CABN-AENNR
                           KEY_DATE      LIKE SY-DATUM
                           ERROR         LIKE SY-BATCH
                           WARNING       LIKE SY-BATCH.

*........ tables for API ...............................................

  DATA:
    ALLOCATIONS LIKE RCUOB1   OCCURS 10 WITH HEADER LINE,
    BASIC_DATA  LIKE RCUKB1   OCCURS 10 WITH HEADER LINE,
    NAMES       LIKE RCUKBT1  OCCURS 10 WITH HEADER LINE,
    DOCUS       LIKE RCUKDOC1 OCCURS 10 WITH HEADER LINE,
    SOURCES     LIKE RCUKN1   OCCURS 10 WITH HEADER LINE.

  DATA:
    VALUE       LIKE CAWN-ATWRT.            "buffer for value
  Data: lh_msgv1 like sy-msgv1.                                "2552779

*........ init .........................................................

  CLEAR:
    ERROR,
    VALUE.

  REFRESH:
    ALLOCATIONS,
    BASIC_DATA,
    NAMES,
    DOCUS,
    SOURCES.

*........ get all allocations from buffer ..............................

  LOOP AT T_E1CUKB1.

*........ save allocation for new value ................................

    IF T_E1CUKB1-VALUE NE VALUE.
      IF NOT VALUE IS INITIAL.

*........ save allocations for value ...................................

        CALL FUNCTION 'CTMV_CHARACT_CHANGE_KNOWL_VAL'
             EXPORTING
                  CHANGE_NUMBER = CHANGE_NUMBER
                  CHARACT       = CHARACT
                  KEY_DATE      = KEY_DATE
                  VALUE         = VALUE
             IMPORTING
                  WARNING       = WARNING
             TABLES
                  ALLOCATIONS   = ALLOCATIONS
                  BASIC_DATA    = BASIC_DATA
                  NAMES         = NAMES
                  DOCUS         = DOCUS
                  SOURCES       = SOURCES
             EXCEPTIONS
                  ERROR         = 1
                  OTHERS        = 2.

*........ set error flag if exception raised ...........................

        IF SY-SUBRC IS INITIAL.

*........ init for new value ...........................................

          VALUE = T_E1CUKB1-VALUE.
          REFRESH:
            ALLOCATIONS,
            BASIC_DATA,
            NAMES,
            DOCUS,
            SOURCES.
        ELSE.
        lh_msgv1 = value.                                      "2552779
        PERFORM DISPLAY_MESSAGE USING 'C1'                     "2552779
                               880                             "2552779
                               'E'                             "2552779
                               lh_msgv1 SPACE SPACE SPACE.     "2552779
          ERROR = C_MARK.
          EXIT.
        ENDIF.
      ENDIF.

*........ init for new value ...........................................

      VALUE = T_E1CUKB1-VALUE.
    ENDIF.

*........ save infos for allocations ...................................

    CLEAR: ALLOCATIONS.
    IF T_E1CUKB1-DEP_INTERN CO C_NUMERIC.
      ALLOCATIONS-XKNNAM = T_E1CUKB1-DEP_INTERN.
    ELSE.
      ALLOCATIONS-KNNAM  = T_E1CUKB1-DEP_INTERN.
    ENDIF.
    ALLOCATIONS-KNSRT  = T_E1CUKB1-DEP_LINENO.
    APPEND ALLOCATIONS.

*........ no additional informations for global dependency .............

    IF T_E1CUKB1-DEP_INTERN CN C_NUMERIC.
      CONTINUE.
    ENDIF.

*........ save basic data ..............................................

    CLEAR: BASIC_DATA.
    BASIC_DATA-XKNNAM = T_E1CUKB1-DEP_INTERN.
    BASIC_DATA-KNART  = T_E1CUKB1-DEP_TYPE.
    BASIC_DATA-KNSTA  = T_E1CUKB1-STATUS.
    BASIC_DATA-KNGRP  = T_E1CUKB1-GROUP.
    BASIC_DATA-KNBEO  = T_E1CUKB1-WHR_TO_USE.

*........ translate dependency type ....................................

    CALL FUNCTION 'DEPENDENCY_GET_INT_TYPE'
         EXPORTING
              DEPENDENCY_TYPE_EXT = T_E1CUKB1-DEP_TYPE
         IMPORTING
              DEPENDENCY_TYPE_INT = BASIC_DATA-KNART
         EXCEPTIONS
              DEP_TYPE_INVALID    = 1
              OTHERS              = 2.
    if not sy-subrc is initial.
      clear sy-subrc.
    endif.

    APPEND BASIC_DATA.

*........ save descriptions ............................................

    LOOP AT T_E1CUKB2
      WHERE CHARACT    EQ T_E1CUKB1-CHARACT
      AND   VALUE      EQ T_E1CUKB1-VALUE
      AND   DEP_INTERN EQ T_E1CUKB1-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKB1-DEP_EXTERN.
      CLEAR: NAMES.
      NAMES-XKNNAM = T_E1CUKB1-DEP_INTERN.
      NAMES-LANGU  = T_E1CUKB2-LANGUAGE.
      NAMES-KNKTXT = T_E1CUKB2-DESCRIPT.
      APPEND NAMES.
    ENDLOOP.  " at T_E1CUKB2

*........ save docu ....................................................

    LOOP AT T_E1CUTX1
      WHERE CHARACT    EQ T_E1CUKB1-CHARACT
      AND   VALUE      EQ T_E1CUKB1-VALUE
      AND   DEP_INTERN EQ T_E1CUKB1-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKB1-DEP_EXTERN.
      CLEAR: DOCUS.
      DOCUS-XKNNAM  = T_E1CUKB1-DEP_INTERN.
      DOCUS-LINE_NO = SY-TABIX.
      DOCUS-LANGU   = T_E1CUTX1-LANGUAGE.
      DOCUS-FORMAT  = T_E1CUTX1-TXT_FORM.
      DOCUS-LINE    = T_E1CUTX1-TXT_LINE.
      APPEND DOCUS.
    ENDLOOP.  " at T_E1CUTX1

*........ save sources .................................................

    LOOP AT T_E1CUKN1
      WHERE CHARACT    EQ T_E1CUKB1-CHARACT
      AND   VALUE      EQ T_E1CUKB1-VALUE
      AND   DEP_INTERN EQ T_E1CUKB1-DEP_INTERN
      AND   DEP_EXTERN EQ T_E1CUKB1-DEP_EXTERN.
      CLEAR: SOURCES.
      SOURCES-XKNNAM  = T_E1CUKB1-DEP_INTERN.
      SOURCES-LINE_NO = SY-TABIX.
      SOURCES-LINE    = T_E1CUKN1-LINE.
      APPEND SOURCES.
    ENDLOOP.  " at T_E1CUKN1

  ENDLOOP.  " at t_e1cukb1

*........ save last allocation if necessary ............................

  CHECK ERROR IS INITIAL.
  READ TABLE ALLOCATIONS INDEX 1.
  IF SY-SUBRC IS INITIAL.

*........ save allocations for value ...................................

    CALL FUNCTION 'CTMV_CHARACT_CHANGE_KNOWL_VAL'
         EXPORTING
              CHANGE_NUMBER = CHANGE_NUMBER
              CHARACT       = CHARACT
              KEY_DATE      = KEY_DATE
              VALUE         = VALUE
         IMPORTING
              WARNING       = WARNING
         TABLES
              ALLOCATIONS   = ALLOCATIONS
              BASIC_DATA    = BASIC_DATA
              NAMES         = NAMES
              DOCUS         = DOCUS
              SOURCES       = SOURCES
         EXCEPTIONS
              ERROR         = 1
              OTHERS        = 2.

*........ set error flag if exception raised ...........................

    IF NOT SY-SUBRC IS INITIAL.
      ERROR = C_MARK.
    ENDIF.
  ENDIF.

ENDFORM.    " SAVE_DEPS_CHARACT
