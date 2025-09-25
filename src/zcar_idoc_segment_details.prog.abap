*----------------------------------------------------------------------*
* PROGRAM NAME:       ZCAR_IDOC_SEGMENT_DETAILS
* PROGRAM DESCRIPTION:Report to show no of segements selected
* DEVELOPER:          Nageswar (NPOLINA)
* CREATION DATE:      07/05/2019
* OBJECT ID:          XXXXX
* TRANSPORT NUMBER(S):ED2K915009
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zcar_idoc_segment_details.

TABLES: edidc.

TYPES: BEGIN OF ty_edidc,
         docnum  TYPE edi_docnum,     "IDoc number
         counter TYPE edi_clustc,    "Status of IDoc
         segnum  TYPE idocdsgnum,    "IDoc Type
         segnam  TYPE edi_segnam,    "Logical Message Variant
       END OF ty_edidc.

*===================================================================*
* Internal Table
*===================================================================*
DATA: i_edidc TYPE STANDARD TABLE OF ty_edidc,
      v_count TYPE i.   " Counter

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_direct TYPE edidc-direct NO-DISPLAY,
            p_mestyp TYPE edidc-mestyp  NO-DISPLAY.   " Message type


SELECT-OPTIONS: s_mescod FOR edidc-mescod NO-DISPLAY,
                s_mesfct FOR edidc-mesfct NO INTERVALS NO-DISPLAY,
                s_idoctp FOR edidc-idoctp , " Idoc Type
                s_docnum FOR edidc-docnum,
                s_status FOR edidc-status ,

                s_credat FOR edidc-credat,
                s_cretim FOR edidc-cretim NO-DISPLAY.

PARAMETERS: p_limit  TYPE i DEFAULT 2000000.
SELECTION-SCREEN:END OF BLOCK b1.

*===================================================================*
* S T A R T - O F - S E L E C T I O N
*===================================================================*
START-OF-SELECTION.

  FREE:i_edidc[].
  SELECT b~docnum
        a~counter
        a~segnum
        a~segnam
        FROM edid4 AS a

    INNER JOIN edidc AS b
    ON b~docnum = a~docnum
  INTO TABLE i_edidc
    UP TO p_limit ROWS
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

*===================================================================*
* E N D - O F - S E L E C T I O N
*===================================================================*
END-OF-SELECTION.

  WRITE:/ 'Number of Segements Selected : ', v_count.
