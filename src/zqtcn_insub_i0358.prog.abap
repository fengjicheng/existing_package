*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_I0358
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_I0358(Include Program for Methods)
* PROGRAM DESCRIPTION: Validation Invoice Instructions text lines
* DEVELOPER: Nageswar (NPOLINA)
* CREATION DATE:   02/18/2019
* OBJECT ID:  I0358/ERP7787
* TRANSPORT NUMBER(S):  ED2K914488
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
TYPES : BEGIN OF lty_constants,
          devid  TYPE zdevid,                                       "Devid
          param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                   "Current selection number
          sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
        END OF lty_constants.

TYPES: BEGIN OF lty_mescod,
         sign(1)   TYPE c,
         option(2) TYPE c,
         low       TYPE edi_mescod,
         high      TYPE edi_mescod,
       END OF lty_mescod.

TYPES: BEGIN OF lty_xe1edkt2 .
        INCLUDE STRUCTURE e1edkt1.
        INCLUDE STRUCTURE e1edkt2.
TYPES:     END OF lty_xe1edkt2.

TYPES: BEGIN OF lty_errtab ,
         trans     LIKE tstc-tcode,
         arbgb     LIKE t100-arbgb,
         class(1)  TYPE c,
         msgnr     LIKE t100-msgnr,
         text(123) TYPE c,
         msgv1     LIKE sy-msgv1,
         msgv2     LIKE sy-msgv2,
         msgv3     LIKE sy-msgv3,
         msgv4     LIKE sy-msgv4,
       END OF lty_errtab.

DATA:

  lst_de1edkt2    TYPE STANDARD TABLE OF lty_xe1edkt2,
  lv_tdformat(2)  TYPE n,
  lv_ctdformat(2) TYPE c,
  lv_tabx(2)      TYPE c,
  lst_errtab      TYPE lty_errtab,
  lst_e1edkt2     TYPE e1edkt2.

FIELD-SYMBOLS:
  <lfs_e1edkt2>      TYPE lty_xe1edkt2.

DATA : lrs_mescod    TYPE TABLE OF lty_mescod,
       lis_constants TYPE STANDARD TABLE OF lty_constants.              "Itab for constants

CONSTANTS:
  lc_devid_i0358 TYPE zdevid      VALUE 'I0358',                  "Development ID: I0358
  lc_p1_msgvar   TYPE rvari_vnam  VALUE 'MSG_VARIANT',            "Name of Variant Variable: message variant
  lc_msg_z18     TYPE rvari_vnam  VALUE 'Z18',                    "Name of Variant Variable: message variant value
  lc_e(1)        TYPE c           VALUE 'E',
  lc_msgid       TYPE char20      VALUE 'ZQTC_R2',
  lc_msgno       TYPE char20      VALUE '537',
  lc_msgv1       TYPE char100     VALUE 'Adjust Invoice Instructions in right sequence',
  lc_e1edkt2     TYPE char20      VALUE 'E1EDKT2',
  lc_status      TYPE char20      VALUE '51',
  lc_eq(1)       TYPE c           VALUE '=',
  lc_star(1)     TYPE c           VALUE '*'.


IF lis_constants[] IS INITIAL.
* Get Cnonstant values
  SELECT devid                                                   "Devid
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                     "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE lis_constants
    WHERE devid    EQ lc_devid_i0358 AND                          "Development ID
          activate EQ abap_true.                                 "Only active record

  IF lis_constants[] IS NOT INITIAL.
    LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value1>).
      CASE <lst_const_value1>-param1.
        WHEN lc_p1_msgvar.                                        "message variant
          APPEND INITIAL LINE TO lrs_mescod ASSIGNING FIELD-SYMBOL(<lst_mescod>).
          <lst_mescod>-sign   = <lst_const_value1>-sign.
          <lst_mescod>-option = <lst_const_value1>-opti.
          <lst_mescod>-low    = <lst_const_value1>-low.
          <lst_mescod>-high   = <lst_const_value1>-high.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF lis_constants IS NOT INITIAL.
ENDIF.

READ TABLE dedidc ASSIGNING FIELD-SYMBOL(<lfs_edidc>) INDEX 1.
IF sy-subrc EQ 0.
  IF lrs_mescod[] IS NOT INITIAL AND
     <lfs_edidc>-mescod IN lrs_mescod.  " Sales office check

    CLEAR:lst_errtab.
    LOOP AT dxe1edkt2 ASSIGNING <lfs_e1edkt2>.
      lv_tabx = lv_tabx + 1.
      lv_tdformat = lv_tabx.
      lv_ctdformat = lv_tdformat.
      IF <lfs_e1edkt2>-tdformat NE lv_tabx AND  <lfs_e1edkt2>-tdformat NE lv_ctdformat.
        lst_errtab-trans = sy-tcode.
        lst_errtab-arbgb = lc_msgid.
        lst_errtab-class = lc_e.
        lst_errtab-msgnr = lc_msgno.
        lst_errtab-text = lc_msgv1.
        lst_errtab-msgv1 = lc_e1edkt2.
        APPEND lst_errtab TO derrtab.
        CLEAR:lst_errtab.
      ELSE.
        IF lv_tabx EQ 1.
          CLEAR:<lfs_e1edkt2>-tdformat.
          <lfs_e1edkt2>-tdformat+0(1) = lc_star.
        ELSE.
          CLEAR:<lfs_e1edkt2>-tdformat.
          <lfs_e1edkt2>-tdformat+0(1) = lc_eq. .
        ENDIF.
      ENDIF.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM derrtab[] COMPARING ALL FIELDS.

  ENDIF.
ENDIF.
