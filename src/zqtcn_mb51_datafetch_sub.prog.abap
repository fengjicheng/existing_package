*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_MB51_DATAFETCH_SUB (Include Program)
* PROGRAM DESCRIPTION: Data fetch and logic for newly added fields in MB51
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   10/02/2019
* WRICEF ID: E218
* TRANSPORT NUMBER(S): ED2K916332
* REFERENCE NO: ERPM-835 / ERP-7933
*----------------------------------------------------------------------*
TYPES : BEGIN OF ty_mara,
          matnr        TYPE mara-matnr,
          ismrefmdprod TYPE mara-ismrefmdprod,
          ismyearnr    TYPE mara-ismyearnr,
        END OF ty_mara.

TYPES  : BEGIN OF ty_marc,
           matnr            TYPE marc-matnr,
           werks            TYPE marc-werks,
           ismarrivaldateac TYPE marc-ismarrivaldateac,
         END OF ty_marc.

DATA : li_tab_mara LIKE TABLE OF itab,
       li_tab_marc LIKE TABLE OF itab,
       li_mara     TYPE STANDARD TABLE OF ty_mara,
       li_marc     TYPE STANDARD TABLE OF ty_marc.

li_tab_mara[] = itab[].       " Copy standard itab data
li_tab_marc[] = itab[].       " Copy standard itab data

SORT li_tab_mara[] BY matnr.            " Sort copied material master general data
SORT li_tab_marc[] BY matnr werks.      " Sort copied material master plant data
DELETE ADJACENT DUPLICATES FROM li_tab_mara COMPARING matnr.
DELETE ADJACENT DUPLICATES FROM li_tab_marc COMPARING matnr werks.

IF itab[] IS NOT INITIAL.     " Check Standard itab is initial

  REFRESH li_mara[].
  SELECT matnr ismrefmdprod ismyearnr             " Fetch material master data
    FROM mara
    INTO TABLE li_mara
    FOR ALL ENTRIES IN li_tab_mara
    WHERE matnr = li_tab_mara-matnr.
  IF sy-subrc IS INITIAL.
    SORT li_mara BY matnr.                        " Sort material master general data
  ENDIF.

  REFRESH li_marc[].
  SELECT matnr werks ismarrivaldateac             " Fetch material master plant data
    FROM marc
    INTO TABLE li_marc
    FOR ALL ENTRIES IN li_tab_marc
    WHERE matnr = li_tab_marc-matnr   AND
          werks = li_tab_marc-werks.
  IF sy-subrc IS INITIAL.
    SORT li_marc BY matnr werks.                  " Sort material master general data
  ENDIF.

  LOOP AT itab.
    " Read Material master genaral data
    READ TABLE li_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>) WITH KEY matnr = itab-matnr BINARY SEARCH.          " Read and assign material general data to result itab
    IF sy-subrc = 0.
      itab-ismyearnr = <lfs_mara>-ismyearnr.            " Publication year
      itab-ismrefmdprod = <lfs_mara>-ismrefmdprod.      " Media Product
      MODIFY itab.
      UNASSIGN <lfs_mara>.
    ENDIF.
    " Read material master plant data
    READ TABLE li_marc ASSIGNING FIELD-SYMBOL(<lfs_marc>) WITH KEY matnr = itab-matnr werks = itab-werks BINARY SEARCH.       " Read and assign material plant data to result itab
    IF sy-subrc = 0.
      itab-ismanlftagi = <lfs_marc>-ismarrivaldateac.     " Actual goods received date
      MODIFY itab.
      UNASSIGN <lfs_marc>.
    ENDIF.
  ENDLOOP.

ENDIF.
