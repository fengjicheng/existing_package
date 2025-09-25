*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_PRC_ALLOC (Include)
*               [Called from BADI method BOM_UPDATE~CHANGE_AT_SAVE]
* PROGRAM DESCRIPTION: Validation for % Allocation for Database BOM
* DEVELOPER: Writtick Roy
* CREATION DATE:   07/06/2017
* OBJECT ID: E162
* TRANSPORT NUMBER(S): ED2K906978
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908513, ED2K910112
* REFERENCE NO: CR#607
* DEVELOPER: Writtick Roy
* DATE:  10/30/2017
* DESCRIPTION: Use Custom Field, since the requirement is to use
*              8 Decimal Places
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* Begin of ADD:CR#607:WROY:30-Oct-2017:ED2K908513
DATA:
  li_delta_stpob TYPE cs01_stpob_tab,                           "BOM item document table
  li_delta_stasb TYPE cs01_stasb_tab.                           "BOMs - Item Selection

DATA:
  lv_prcnt_alloc TYPE rai_percentage_kk,                        "Total of Percentage Allocation
  lv_zzalloc     TYPE rai_percentage_kk.                        "Percentage Allocation

* BOMs - Item Selection specific to the ALternate BOM
li_delta_stasb[] = delta_stasb[].
DELETE li_delta_stasb WHERE stlal NE i_stlal.                   "Alternate BOM

* Get the BOM Items
li_delta_stpob[] = delta_stpob[].
* Identify the latest BOM item node number
SORT li_delta_stpob BY guidx ASCENDING
                       stlkn DESCENDING
                       stpoz DESCENDING.
DELETE ADJACENT DUPLICATES FROM li_delta_stpob
             COMPARING guidx.

* Calculate Total of Percentage Allocation
CLEAR: lv_prcnt_alloc.
LOOP AT li_delta_stasb ASSIGNING FIELD-SYMBOL(<lst_stasb>).
* Loop through the BOM Items specific to the ALternate BOM
  READ TABLE delta_stpob TRANSPORTING NO FIELDS
       WITH KEY stlty = <lst_stasb>-stlty                       "BOM category
                stlnr = <lst_stasb>-stlnr                       "Bill of material
                stlkn = <lst_stasb>-stlkn                       "BOM item node number
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    LOOP AT delta_stpob ASSIGNING FIELD-SYMBOL(<lst_stpob>) FROM sy-tabix.
      IF <lst_stpob>-stlty NE <lst_stasb>-stlty OR              "BOM category
         <lst_stpob>-stlnr NE <lst_stasb>-stlnr OR              "Bill of material
         <lst_stpob>-stlkn NE <lst_stasb>-stlkn.                "BOM item node number
        EXIT.
      ENDIF.
*     Consider the latest BOM item node number
      READ TABLE li_delta_stpob ASSIGNING FIELD-SYMBOL(<lst_delta_stpob>)
           WITH KEY guidx = <lst_stpob>-guidx                   "Global identification of an item's change status
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        TRY.
            lv_zzalloc = <lst_delta_stpob>-zzalloc.
          CATCH cx_root.
            CLEAR: lv_zzalloc.
        ENDTRY.
*       Calculate Total of Percentage Allocation
        lv_prcnt_alloc = lv_prcnt_alloc + lv_zzalloc.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDLOOP.

IF li_delta_stasb[] IS INITIAL.
  LOOP AT delta_stpob ASSIGNING <lst_delta_stpob>.
    TRY.
        lv_zzalloc = <lst_delta_stpob>-zzalloc.
      CATCH cx_root.
        CLEAR: lv_zzalloc.
    ENDTRY.
*   Calculate Total of Percentage Allocation
    lv_prcnt_alloc = lv_prcnt_alloc + lv_zzalloc.
  ENDLOOP.
ENDIF.

* Check Total of Percentage Allocation
IF lv_prcnt_alloc IS NOT INITIAL AND
   lv_prcnt_alloc NE 100.
* Message: Total of Percentage Allocations must be 100%
  MESSAGE e213(zqtc_r2) RAISING error_with_message.
ENDIF.
* End   of ADD:CR#607:WROY:30-Oct-2017:ED2K908513
* Begin of DEL:CR#607:WROY:30-Oct-2017:ED2K908513
*DATA:
*  li_delta_stpob TYPE cs01_stpob_tab.                           "BOM item document table
*
*DATA:
*  lv_prcnt_alloc TYPE kausf.                                    "Total of Percentage Allocation
*
** Get the BOM Items
*li_delta_stpob[] = delta_stpob[].
** Identify the latest BOM item node number
*SORT li_delta_stpob BY posnr ASCENDING
*                       stlkn DESCENDING
*                       stpoz DESCENDING.
*DELETE ADJACENT DUPLICATES FROM li_delta_stpob
*             COMPARING posnr.
*
** Calculate Total of Percentage Allocation
*CLEAR: lv_prcnt_alloc.
*LOOP AT li_delta_stpob ASSIGNING FIELD-SYMBOL(<lst_delta_stpob>).
*  lv_prcnt_alloc = lv_prcnt_alloc + <lst_delta_stpob>-ausch.
*ENDLOOP.
*
** Check Total of Percentage Allocation
*IF lv_prcnt_alloc IS NOT INITIAL AND
*   lv_prcnt_alloc NE 100.
** Message: Total of Percentage Allocations must be 100%
*  MESSAGE e213(zqtc_r2) RAISING error_with_message.
*ENDIF.
* End   of DEL:CR#607:WROY:30-Oct-2017:ED2K908513
