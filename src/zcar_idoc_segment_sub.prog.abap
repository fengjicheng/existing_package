*----------------------------------------------------------------------*
* PROGRAM NAME:       ZCAR_IDOC_SEGMENT_DETAILS
* PROGRAM DESCRIPTION:Report to show no of segements selected
* DEVELOPER:          Nageswar (NPOLINA)
* CREATION DATE:      07/05/2019
* OBJECT ID:          XXXXX
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_IDOCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_idocs .
  FREE:i_edidc[].
  SELECT b~docnum
a~counter
a~segnum
a~segnam
        FROM edid4 AS a
    INNER JOIN edidc AS b
    ON b~docnum = a~docnum
  INTO TABLE i_edidc
    WHERE b~docnum IN s_docnum AND
          b~status IN s_status AND
*          direct EQ p_direct AND
          b~mescod IN s_mescod AND
          b~mesfct IN s_mesfct AND
          b~credat IN s_credat AND
          b~cretim IN s_cretim AND
*          mestyp EQ p_mestyp AND
          b~idoctp IN s_idoctp.
  IF NOT i_edidc[] IS INITIAL.
    SORT i_edidc BY docnum.
    DESCRIBE TABLE i_edidc LINES v_count.
  ENDIF.
ENDFORM.
