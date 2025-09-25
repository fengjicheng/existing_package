*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OUTBOUND_I0229_9
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Murali (MIMMADISET)
* CREATION DATE:   11/11/2019
* OBJECT ID: I0229.9 (ERPM-5900)
* TRANSPORT NUMBER(S):Contract start and end date mismatching in ALM and Moodle
*due to these date are not in SAP IDOC
*----------------------------------------------------------------------*
CONSTANTS: lc1_z1qtc_e1edp01_01 TYPE char16 VALUE 'Z1QTC_E1EDP01_01'. " Z1qtc_e1edp01_01 of type CHAR16
DATA:lv1_line              TYPE sytabix,      " Row Index of Internal Tables
     lst1_e1edp01          TYPE e1edp01,      " IDoc: Document Item General Data
     lst1_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01. " IDOC Segment for STATUS Field in Item Level
*** Describing IDOC Data Table
DESCRIBE TABLE int_edidd LINES lv1_line.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd INTO lst_edidd INDEX lv1_line.
IF sy-subrc = 0.
*** Checking segments and implementing required logic
  CASE lst_edidd-segnam.
    WHEN 'E1EDP01'. " For Item general Data
      lst1_e1edp01 = lst_edidd-sdata.
*** DXVBAP is a table but it contains corresponding item value in it's header
*** in standard, so we have used dxvbap
      SELECT  SINGLE vbegdat,venddat,vdemdat
           FROM veda            " Contract Data
           INTO @DATA(lst1_veda)
           WHERE vbeln = @dxvbap-vbeln
           AND vposn = @dxvbap-posnr.
      IF sy-subrc = 0 .
        SELECT SINGLE posex FROM vbap
          INTO @DATA(lv_posex)
          WHERE vbeln = @dxvbap-vbeln
           AND posnr = @dxvbap-posnr.
        IF sy-subrc = 0.
          lst1_z1qtc_e1edp01_01-vposn = lv_posex.
        ENDIF.
        lst1_z1qtc_e1edp01_01-venddat = lst1_veda-venddat." Contract End Date
        lst1_z1qtc_e1edp01_01-vbegdat = lst1_veda-vbegdat." Contract start Date
        lst1_z1qtc_e1edp01_01-vdemdat = lst1_veda-vdemdat."Dismandling date
        lst_edidd-segnam = lc1_z1qtc_e1edp01_01.           " Adding new segment
        lst_edidd-sdata =  lst1_z1qtc_e1edp01_01.
        APPEND lst_edidd TO int_edidd.
      ENDIF.
  ENDCASE.
ENDIF.
