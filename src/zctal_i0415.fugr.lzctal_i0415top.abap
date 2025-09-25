FUNCTION-POOL ZCTAL_I0415.     "MESSAGE-ID ..

INCLUDE lctald01.                                             "  1854522

*....Types..............................................................
types:
    begin of t_inst,
      inst                             type ref to cl_chr_main,
    end   of t_inst,
    tt_inst                            type table of t_inst,

    begin of t_e1cukb1,
      charact                          type atnam,
      value                            type atwrt,
      e1cukbm                          type e1cukbm,
    end   of t_e1cukb1,
    tt_e1cukb1                         type table of t_e1cukb1,

    begin of t_e1cukb2,
      charact                          type atnam,
      value                            type atwrt,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cukbt                          type e1cukbt,
    end   of t_e1cukb2,
    tt_e1cukb2                         type table of t_e1cukb2,

    begin of t_e1cukbm,
      charact                          type atnam,
      e1cukbm                          type e1cukbm,
    end   of t_e1cukbm,
    tt_e1cukbm                         type table of t_e1cukbm,

    begin of t_e1cukbt,
      charact                          type atnam,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cukbt                          type e1cukbt,
    end   of t_e1cukbt,
    tt_e1cukbt                         type table of t_e1cukbt,

    begin of t_e1cukn1,
      charact                          type atnam,
      value                            type atwrt,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cuknm                          type e1cuknm,
    end   of t_e1cukn1,
    tt_e1cukn1                         type table of t_e1cukn1,

    begin of t_e1cuknm,
      charact                          type atnam,
      value                            type atwrt,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cuknm                          type e1cuknm,
    end   of t_e1cuknm,
    tt_e1cuknm                         type table of t_e1cuknm,

    begin of t_e1cutx1,
      charact                          type atnam,
      value                            type atwrt,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cutxm                          type e1cutxm,
    end   of t_e1cutx1,
    tt_e1cutx1                         type table of t_e1cutx1,

    begin of t_e1cutxm,
      charact                          type atnam,
      value                            type atwrt,
      dep_intern                       type knnam_int,
      dep_extern                       type knnam_ext,
      e1cutxm                          type e1cutxm,
    end   of t_e1cutxm,
    tt_e1cutxm                         type table of t_e1cutxm,

    begin of t_valalloc,
      value                            type atwrt,
      alloc                            type tt_rcuob1,
    end   of t_valalloc,
    tt_valalloc                        type table of t_valalloc,

    begin of t_valbasic,
      value                            type atwrt,
      basic                            type tt_rcukb1,
    end   of t_valbasic,
    tt_valbasic                        type table of t_valbasic,

    begin of t_valdescr,
      value                            type atwrt,
      descr                            type tt_rcukbt1,
    end   of t_valdescr,
    tt_valdescr                        type table of t_valdescr,

    begin of t_valdocu,
      value                            type atwrt,
      docu                             type tt_rcukdoc1,
    end   of t_valdocu,
    tt_valdocu                         type table of t_valdocu,

    begin of t_valsource,
      value                            type atwrt,
      source                           type tt_rcukn1,
    end   of t_valsource,
    tt_valsource                       type table of t_valsource,

    begin of t_valtext,
      value                            type atwrt,
      text                             type tt_chr_text,
    end   of t_valtext,
    tt_valtext                         type table of t_valtext.


*....Tables.............................................................
data:
    gt_inst                            type tt_inst.


*....Flags..............................................................
data:
    gf_new_processing                  type flag value ''.



  TABLES:
    CABN,                               "characteristic master
    CABNZ,                              "table fields for character.
    CAWN,                               "characteristic values
    E1CABNM,                            "characteristic master
    E1CABTM,                            "characteristic texts
    E1CAWNM,                            "characteristic values
    E1CAWTM,                            "characteristic values texts
    E1CABZM,                            "table fields
    E1CUKB1,                            "master allocations of values
    E1CUKB2,                            "text of local dependencies (val
    E1CUKBM,                            "master allocations
    E1CUKBT,                            "text of local dependencies
    E1CUKN1,                            "source of local dependencies
    E1CUKNM,                            "source of local dependencies
    E1CUTX1,                            "docu of local dependencies
    E1CUTXM,                            "docu of local dependencies
    E1DATEM,                            "changenumber and keydate
    E1TEXTL,                            "long texts characteristic
    E1TXTL1,                            "lon text values
    E1TCMEM,                            "restrictions
    KLAH,                               "class header
    TCME,                               "restrictions of a charact.
    TCMS,                               "status of a charact.
    USR01.                              "user account

  CONSTANTS:
    C_BUS_OBJECT    TYPE OJ_NAME        "Business object characteristic
                    VALUE 'BUS1088',
    C_MARK(1)       TYPE C VALUE 'X',   "mark for a checkbox
    C_IDOCS_BEFORE_COMMIT LIKE SY-TABIX VALUE 100, "IDocs to commit
    C_NUMERIC(11)   TYPE C              "valid chars for numeric check
                    VALUE '0123456789 ',
    FORMAT_CHAR     LIKE CABN-ATFOR     "datatype 'CHAR'
                    VALUE 'CHAR',

    MAXDATE         like sy-datum value '99991231'.            "1731721


  DATA:
    DATEFORMAT      LIKE CABN-ATSCH,    "mask for date
    DECIMALPOINT(1) TYPE C,             "representation of decimalpoint
    G_MESTYPE       LIKE BDALEDC-IDOCTP."actual message type

*........ IDOC structures for characteristics .........................*

  CONSTANTS:
    C_SEGNAM_CABN  LIKE EDIDD-SEGNAM VALUE 'E1CABNM',
    C_SEGNAM_CABNT LIKE EDIDD-SEGNAM VALUE 'E1CABTM',
    C_SEGNAM_CAWN  LIKE EDIDD-SEGNAM VALUE 'E1CAWNM',
    C_SEGNAM_CAWNT LIKE EDIDD-SEGNAM VALUE 'E1CAWTM',
    C_SEGNAM_CABNZ LIKE EDIDD-SEGNAM VALUE 'E1CABZM',
    C_SEGNAM_CUKB1 LIKE EDIDD-SEGNAM VALUE 'E1CUKB1',
    C_SEGNAM_CUKB2 LIKE EDIDD-SEGNAM VALUE 'E1CUKB2',
    C_SEGNAM_CUKBM LIKE EDIDD-SEGNAM VALUE 'E1CUKBM',
    C_SEGNAM_CUKBT LIKE EDIDD-SEGNAM VALUE 'E1CUKBT',
    C_SEGNAM_CUKN1 LIKE EDIDD-SEGNAM VALUE 'E1CUKN1',
    C_SEGNAM_CUKNM LIKE EDIDD-SEGNAM VALUE 'E1CUKNM',
    C_SEGNAM_CUTX1 LIKE EDIDD-SEGNAM VALUE 'E1CUTX1',
    C_SEGNAM_CUTXM LIKE EDIDD-SEGNAM VALUE 'E1CUTXM',
    C_SEGNAM_DATE  LIKE EDIDD-SEGNAM VALUE 'E1DATEM',
    C_SEGNAM_TCME  LIKE EDIDD-SEGNAM VALUE 'E1TCMEM',
    C_SEGNAM_TEXTL LIKE EDIDD-SEGNAM VALUE 'E1TEXTL',
    C_SEGNAM_TXTL1 LIKE EDIDD-SEGNAM VALUE 'E1TXTL1'.

*........ Message functions ...........................................*

  CONSTANTS:
    C_CHANGE    LIKE E1CABNM-MSGFN VALUE '004',     "change
    C_DELETE    LIKE E1CABNM-MSGFN VALUE '003'.     "delete

*........ type of IDoc.................................................*

  CONSTANTS:
*     C_IDOCTP LIKE BDALEDC-IDOCTP VALUE 'CHRMAS03',           "2449445
     C_IDOCTP LIKE BDALEDC-IDOCTP VALUE 'CHRMAS05',            "2449445
     C_MESTYP LIKE EDIDC-MESTYP   VALUE 'CHRMAS'.

*....... IDoc status ..................................................*

  CONSTANTS:
    C_IDOC_OK    LIKE BDIDOCSTAT-STATUS VALUE '53',    "o. k.
    C_IDOC_NOK   LIKE BDIDOCSTAT-STATUS VALUE '51'.    "not o. k.

*........ header of IDoc ..............................................*

  DATA: F_IDOC_HEADER LIKE EDIDC.

*........ data of IDoc ................................................*

  DATA: T_IDOC_DATA LIKE EDIDD OCCURS 30 WITH HEADER LINE.

*........ communication control .......................................*

  DATA: T_IDOC_COMM_CONTROL LIKE EDIDC OCCURS 10 WITH HEADER LINE.

*........ Masterdata (CABN) ...........................................*

  DATA: CABN_I LIKE CABN.

*........ Texts of Masterdata (CABNT) .................................*

  DATA: CABNT_I LIKE CABNT OCCURS 10 WITH HEADER LINE.

*........ Characteristic's values (CAWN) ..............................*

  DATA: CAWN_I LIKE CAWN OCCURS 30 WITH HEADER LINE.

*........ Characteristic's values texts (CAWNT) .......................*

  DATA: CAWNT_I LIKE CAWNT OCCURS 50 WITH HEADER LINE.

*........ ref. tables (CABNZ) .........................................*

  DATA: CABNZ_I LIKE CABNZ OCCURS 3 WITH HEADER LINE.

*........ restrictions (API) ..........................................*

  DATA: CHARACT_CLASSTYPE LIKE CHAR_CLTYP OCCURS 1 WITH HEADER LINE.

*........ masterdata (API) ............................................*

  DATA: CHARACT_DATA LIKE CHARACTS OCCURS 1 WITH HEADER LINE.

*........ characteristic's texts (API) ................................*

  DATA: CHARACT_DESCRIPTION LIKE CHAR_DESCR OCCURS 10 WITH HEADER LINE.

*........ ref. tables (API) ...........................................*

  DATA: CHARACT_OBJECT LIKE REF_TABLES OCCURS 3 WITH HEADER LINE.

*........ values (API) ................................................*

  DATA: CHARACT_VALUE LIKE CHAR_VALS OCCURS 30 WITH HEADER LINE.

*........ texts of values (API) .......................................*

  DATA: CHARACT_VALUE_DESCRIPTION LIKE CHV_DESCR
                                  OCCURS 50 WITH HEADER LINE.

*........ Restrictions (TCME) .........................................*

  DATA: TCME_I LIKE TCME OCCURS 3 WITH HEADER LINE.

*........ Knowledge basic data for value ...............................

  DATA: BEGIN OF T_E1CUKB1 OCCURS 30,
          CHARACT LIKE CHARACTS-CHARACT,
          VALUE   LIKE CAWN-ATWRT.
        INCLUDE STRUCTURE E1CUKBM.
  DATA: END OF T_E1CUKB1.

*........ text of knowledge for value ..................................

  DATA: BEGIN OF T_E1CUKB2 OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUKBT.
  DATA: END OF T_E1CUKB2.

*........ Knowledge basic data for characteristic ......................

  DATA: BEGIN OF T_E1CUKBM OCCURS 30,
          CHARACT LIKE CHARACTS-CHARACT.
        INCLUDE STRUCTURE E1CUKBM.
  DATA: END OF T_E1CUKBM.

*........ text of knowledge for characteristic .........................

  DATA: BEGIN OF T_E1CUKBT OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUKBT.
  DATA: END OF T_E1CUKBT.

*........ source of knowledge for value ................................

  DATA: BEGIN OF T_E1CUKN1 OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUKNM.
  DATA: END OF T_E1CUKN1.

*........ source of knowledge for characteristic .......................

  DATA: BEGIN OF T_E1CUKNM OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUKNM.
  DATA: END OF T_E1CUKNM.

*........ docu of knowledge for value ..................................

  DATA: BEGIN OF T_E1CUTX1 OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUTXM.
  DATA: END OF T_E1CUTX1.

*........ docu of knowledge for characteristic .........................

  DATA: BEGIN OF T_E1CUTXM OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT,
          DEP_INTERN LIKE E1CUKBM-DEP_INTERN,
          DEP_EXTERN LIKE E1CUKBM-DEP_EXTERN.
        INCLUDE STRUCTURE E1CUTXM.
  DATA: END OF T_E1CUTXM.

*........ long texts for characteristic

  DATA: BEGIN OF T_E1TEXTL OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT.
        INCLUDE STRUCTURE E1TEXTL.
  DATA: END OF T_E1TEXTL.

*........ long texts for characteristic

  DATA: BEGIN OF T_E1TXTL1 OCCURS 30,
          CHARACT    LIKE CHARACTS-CHARACT,
          VALUE      LIKE CAWN-ATWRT.
        INCLUDE STRUCTURE E1TXTL1.
  DATA: END OF T_E1TXTL1.

  data lr_badi_idoc_processing TYPE REF TO chrmas_idoc_processing.  "reference to badi instance
