*&---------------------------------------------------------------------*
*&  Include           ZRTRN_VALIDATE_VERSION_ZF5
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_VALIDATE_VERSION_ZF5 (Include)
*                      [Called from Req Billing Doc Routine - 902 for ZF5]
* PROGRAM DESCRIPTION: Restrict creation of Invoice, if all Split-Orders
*                      are not being billed together
* DEVELOPER:           Nageswara (NPOLINA)
* CREATION DATE:       9-Oct-2018
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K913544/ED2K914183
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF lty_con_po,
    vbeln    TYPE vbeln_va,                                "Sales Document
    bstkd    TYPE bstkd,                                   "Customer purchase order number
    vkbur    TYPE vkbur,                                             "Sales Office
    vsnmr_vl TYPE vsnmr_v,                                 "Sales document version number
  END OF lty_con_po,

  ltt_con_po TYPE STANDARD TABLE OF lty_con_po INITIAL SIZE 0,

  BEGIN OF lty_po_all,
    bstkd    TYPE bstkd,                                   "Customer purchase order number
    count_po TYPE i,                                       "Count - POs
  END OF lty_po_all,

  ltt_po_all TYPE SORTED TABLE OF lty_po_all INITIAL SIZE 0
             WITH UNIQUE KEY bstkd.

TYPES : BEGIN OF lty_po_count,
          vbeln TYPE vbeln_va,
          bstnk TYPE bstnk,
        END OF lty_po_count.

DATA li_po_count  TYPE STANDARD TABLE OF lty_po_count.

CONSTANTS : lc_g     TYPE c     VALUE 'G',
            lc_vkbur TYPE vkbur VALUE '0050'.

STATICS:
  li_con_pos TYPE ltt_con_po,                              "Customer purchase order number of Contracts
  li_pos_all TYPE ltt_po_all.                              "Count based on Customer purchase order number

DATA:
  lv_count    TYPE i,
  lv_po_count TYPE i,                                       "Count - POs
  lv_stop_bl  TYPE flag.                                    "Flag: Stop Billing

READ TABLE li_con_pos TRANSPORTING NO FIELDS
     WITH KEY vbeln = xkomfk-vbeln                         "Sales Document
     BINARY SEARCH.

IF sy-subrc NE 0.
  CLEAR: li_pos_all,
         li_con_pos.

  IF xkomfk[] IS NOT INITIAL.
*   Sales Document: Business / Header Data
    SELECT d~vbeln                                         "Sales Document
           d~bstkd                                         "Customer purchase order number
           k~vkbur
           k~vsnmr_v                                       "Sales document version number
      FROM vbkd AS d INNER JOIN
           vbak AS k
        ON k~vbeln EQ d~vbeln
      INTO TABLE li_con_pos
       FOR ALL ENTRIES IN xkomfk
     WHERE d~vbeln EQ xkomfk-vbeln                         "Sales Document
       AND d~posnr EQ posnr_low.
    IF sy-subrc EQ 0.
      SORT li_con_pos BY vbeln.

*     Determine unique Billing Block values
      DATA(li_con_pos_tmp) = li_con_pos.
    ENDIF.

    IF li_con_pos IS NOT INITIAL.
      LOOP AT xkomfk ASSIGNING FIELD-SYMBOL(<lst_komfk>).
*       Identify Customer Purchase Order Number
        READ TABLE li_con_pos ASSIGNING FIELD-SYMBOL(<lst_con_po>)
             WITH KEY vbeln = <lst_komfk>-vbeln            "Sales Document
             BINARY SEARCH.
        IF sy-subrc EQ 0 AND
           <lst_con_po>-bstkd IS NOT INITIAL.              "Customer Purchase Order Number

*         Count Number of Sales Document based on Customer Purchase Order Number
          READ TABLE li_pos_all INTO DATA(lst_po_all)
               WITH KEY bstkd = <lst_con_po>-bstkd         "Customer Purchase Order Number
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            DATA(lv_tabix) = sy-tabix.
            lst_po_all-count_po = lst_po_all-count_po + 1. "Count - POs
            MODIFY li_pos_all FROM lst_po_all INDEX lv_tabix
                   TRANSPORTING count_po.
          ELSE.
            CLEAR: lst_po_all.
            lst_po_all-bstkd    = <lst_con_po>-bstkd.      "Customer Purchase Order Number
            lst_po_all-count_po = lst_po_all-count_po + 1. "Count - POs
            INSERT lst_po_all INTO TABLE li_pos_all.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.

READ TABLE li_con_pos ASSIGNING <lst_con_po>
     WITH KEY vbeln = xkomfk-vbeln
     BINARY SEARCH.
IF sy-subrc EQ 0 AND
   <lst_con_po>-vsnmr_vl IS NOT INITIAL AND                "Sales document version number
   <lst_con_po>-bstkd    IS NOT INITIAL.                   "Customer Purchase Order Number

  IF <lst_con_po>-vkbur = lc_vkbur.  "Check Sales office
* Version field will store the Count of Split-Orders from Source System
    TRY.
        lv_count = <lst_con_po>-vsnmr_vl.                    "Sales document version number
      CATCH cx_root.
        CLEAR: lv_count.
    ENDTRY.
* Determine the Count of Split-Orders from Invoice Due List
    READ TABLE li_pos_all INTO lst_po_all
         WITH KEY bstkd = <lst_con_po>-bstkd                 "Customer Purchase Order Number
         BINARY SEARCH.
    IF sy-subrc EQ 0.

      CLEAR : li_po_count,lv_po_count.
*--*Get the Count of all Contracts for the PO
      SELECT vbeln bstnk  FROM vbak INTO TABLE li_po_count
                              WHERE vbtyp = lc_g
                               AND  bstnk = <lst_con_po>-bstkd.
      IF sy-subrc EQ 0.
*--* Check the PO count with Version number
        DESCRIBE TABLE li_po_count LINES lv_po_count.
        IF lv_po_count NE lv_count.
          lv_stop_bl = abap_true.                                "Flag: Stop Billing
        ENDIF.
      ELSE.
        sy-subrc = 0.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

IF lv_stop_bl IS NOT INITIAL.                              "Flag: Stop Billing
* Write Error Log
  PERFORM vbfs_hinzufuegen_allg USING xkomfk-vbeln
                                      posnr_low
                                      'ZQTC_R2'
                                      'E'
                                      '240'
                                      space
                                      space
                                      space
                                      space.
  sy-subrc = 4.
ENDIF.
