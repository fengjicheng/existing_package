*---------------------------------------------------------------------*
*PROGRAM NAME :  ZQTCN_KNW_CUST_OUTINV_I0245_2(Include Program)       *
*REVISION NO  :  ED2K921668                                           *
*REFERENCE NO :  OTCM-29968                                           *
*DEVELOPER    :  Lahiru Wathudura (LWATHUDURA)                        *
*WRICEF ID    :  I0245                                                *
*DATE         :  03/23/2021                                           *
*DESCRIPTION  :  INC0313695 -Knewton Customer: Follett Higher Education *
*                Group requires invoices via EDI and remove the       *
*                punctuation characters from the old materail number  *
*---------------------------------------------------------------------*

DATA : lv_lines_i0245_2       TYPE i,            " row cound of the Idoc segment table
       lst_e1edp19_i0245_2    TYPE e1edp19,      " Item Object Identification,
       lst_z1qtc_item_i0245_2 TYPE z1qtc_item,   " Additional field for Item
       lv_bismt_i0245_2       TYPE bismt,        " Old material number
       lv_matnr_i0245_2       TYPE char35.       " Matnr of type CHAR35

CONSTANTS : lc_e1edp19_i0245_2   TYPE edilsegtyp VALUE 'E1EDP19',      " Segment E1EDP19
            lc_custm_itm_i0245_2 TYPE edilsegtyp VALUE 'Z1QTC_ITEM',   " Custom item segment
            lc_qualf_i0245_2     TYPE edi_qualfr VALUE '002'.          " Qulifiar 002.

* Describing IDOC Data Table
DESCRIBE TABLE int_edidd LINES lv_lines_i0245_2.
* Reading last record of IDOC Data Table
READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lfs_edidd_i0245_2>) INDEX lv_lines_i0245_2.
IF sy-subrc = 0.
* Checking segments and implementing required logic
  CASE <lfs_edidd_i0245_2>-segnam.
    WHEN lc_e1edp19_i0245_2.

      " Get the current line item related custom segment 'Z1QTC_ITEM'
      LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_tmp_i0245_2>)
        WHERE segnam = lc_custm_itm_i0245_2.
      ENDLOOP.
      " Here SY-SUBRC will always be 0 , because custom item segment has been added in E1EDP01 segment.
      IF sy-subrc = 0.
        lst_e1edp19_i0245_2 = <lfs_edidd_i0245_2>-sdata.
        IF lst_e1edp19_i0245_2-qualf = lc_qualf_i0245_2.    " Check qualifier is = 002
          lv_matnr_i0245_2 = lst_e1edp19_i0245_2-idtnr.

          " Fetch Old material number
          SELECT SINGLE bismt     " Old material number
            FROM mara
            INTO lv_bismt_i0245_2
            WHERE matnr = lv_matnr_i0245_2.
          IF sy-subrc = 0.
            FIND REGEX '[[:punct:]]' IN lv_bismt_i0245_2.       " Find the all punctuation characters using regular expressions
            IF sy-subrc = 0.                                    " If found, Punctuation characters remove and replace with spaces
              REPLACE ALL OCCURRENCES OF REGEX '[[:punct:]]' IN lv_bismt_i0245_2 WITH space.
              CONDENSE lv_bismt_i0245_2 NO-GAPS.                " Remove all spaces
            ELSE.
              CONDENSE lv_bismt_i0245_2 NO-GAPS.                " remove all spaces
            ENDIF.
            " Assign the first 13 characters to IDoc segment
            lst_z1qtc_item_i0245_2-zisbncode = lv_bismt_i0245_2.
            CLEAR lv_bismt_i0245_2.

            " Assign data to Idoc segment
            <lst_edidd_tmp_i0245_2>-sdata = lst_z1qtc_item_i0245_2.
          ENDIF.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDIF.
