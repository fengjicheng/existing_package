*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBKD (Include)
* PROGRAM DESCRIPTION: Fill the Sub Ref ID, PO Type, PO number,
*                      Ship To Party “Your Reference” number at line item
* REFERENCE NO: E095 - ERPM-15045
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 09-18-2020
* TRANSPORT NUMBER(s): ED2K919548
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILL_SUBREF_ID_E095
*&---------------------------------------------------------------------*

* Work Area
TABLES : zqtc_renwl_plan.

* Type Declarations
TYPES : BEGIN OF lty_static_vars,
          hdr_bsark	TYPE bsark,   " Customer purchase order type
          bstkd	    TYPE bstkd,   " Customer purchase order number
          bsark	    TYPE bsark,   " Customer purchase order type
          ihrez	    TYPE ihrez,   " Your Reference
          ihrez_e	  TYPE ihrez_e, " Ship-to party character
        END OF lty_static_vars.

" Static structure holds the programatically changed values
STATICS : ls_static_vars TYPE lty_static_vars.

* Declarations
DATA : ls_vbak     TYPE vbak,                     " Work Area
       lt_vbkd     TYPE vbkd_t,                   " Internal table
       ls_vbkd_hdr TYPE vbkd,                     " Work Area
       ls_vbkd     TYPE vbkdvb,                   " Work area
       li_cons     TYPE zcat_constants,           " Internal table
       ls_const    TYPE zcast_constant,           " Work area
       li_quote    TYPE TABLE OF edm_auart_range, " Internal table
       lv_cq       TYPE zactivity_sub,            " Activity value
       lv_c        TYPE char1,                    " Cancelled
       lv_n        TYPE char1.                    " Profile changed

* Constants
CONSTANTS : lc_par      TYPE rvari_vnam VALUE 'AUART_FUTURE_QUOTE',
            lc_activity TYPE rvari_vnam VALUE 'ACTIVITY',
            lc_ren_stat TYPE rvari_vnam VALUE 'REN_STATUS',
            lc_0001     TYPE tvarv_numb VALUE '0001',
            lc_0002     TYPE tvarv_numb VALUE '0002',
            lc_hdr      TYPE posnr      VALUE '000000', " Header record
            lc_crte     TYPE t180-trtyp VALUE 'H',
            lc_chng     TYPE t180-trtyp VALUE 'V'.

" Works only in foreground
IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
* Read from ZCACONSTANTS table
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e095
    IMPORTING
      ex_constants = li_cons.
  IF li_cons IS NOT INITIAL.
    LOOP AT li_cons INTO ls_const.
      CASE ls_const-param1.
        WHEN lc_par. " ZSQT
          APPEND INITIAL LINE TO li_quote
              ASSIGNING FIELD-SYMBOL(<lst_quote>).
          <lst_quote>-sign   = ls_const-sign.
          <lst_quote>-option = ls_const-opti.
          <lst_quote>-low    = ls_const-low.
          <lst_quote>-high   = ls_const-high.
        WHEN lc_activity.
          lv_cq = ls_const-low.
        WHEN lc_ren_stat.
          CASE ls_const-srno.
            WHEN lc_0001.
              lv_c = ls_const-low.
            WHEN lc_0002.
              lv_n = ls_const-low.
          ENDCASE.
      ENDCASE.
      CLEAR : ls_const.
    ENDLOOP.
* Trigger Only for Quotes
    IF vbak-auart IN li_quote.
      " When xvbkd internal table has records
      IF xvbkd[] IS NOT INITIAL.
        DESCRIBE TABLE xvbkd[] LINES DATA(lv_lines).
        " When xvbkd internal table has line items along with header record
        IF lv_lines GT 1.
          IF t180-trtyp EQ lc_chng AND vbak-bname NE *vbak-bname.
            MESSAGE e575(zqtc_r2).
          ELSEIF t180-trtyp EQ lc_crte.
            " When the "Name of orderer" field is filled
            IF vbak-bname IS NOT INITIAL.
              IF ls_static_vars IS INITIAL.
                " Fetch records from VBAK to check whether already quotes are created with this reference contract
                SELECT SINGLE *
                  FROM vbak
                  INTO ls_vbak
                  WHERE auart IN li_quote
                    AND bname EQ vbak-bname.
                IF sy-subrc EQ 0.
                  MESSAGE e573(zqtc_r2) WITH ls_vbak-vbeln ls_vbak-bname.
                ELSE.
                  " Fetch a record from ZQTC_RENWL_PLAN table based on the BNAME field value
                  SELECT SINGLE *
                    FROM zqtc_renwl_plan
                    WHERE vbeln EQ vbak-bname
                      AND activity EQ lv_cq.
                  IF sy-subrc EQ 0.
                    " When Renewal status is 'C' display error message
                    IF zqtc_renwl_plan-ren_status EQ lv_c.
                      MESSAGE e579(zqtc_r2).
                      " When Renewal status is 'N' display error message
                    ELSEIF zqtc_renwl_plan-ren_status EQ lv_n.
                      MESSAGE e580(zqtc_r2).
                      " When Exclusion reason is not blank display error message
                    ELSEIF zqtc_renwl_plan-excl_resn IS NOT INITIAL OR
                           zqtc_renwl_plan-excl_resn2 IS NOT INITIAL..
                      MESSAGE e581(zqtc_r2).
                    ELSE.
                      " Fetch records from VBKD table based on BNAME field value
                      SELECT *
                        FROM vbkd
                        INTO TABLE lt_vbkd
                        WHERE vbeln EQ vbak-bname.
                      IF sy-subrc EQ 0.
                        " Delete the header record
                        DELETE lt_vbkd WHERE posnr EQ lc_hdr.
                        " Sort by item numbers
                        SORT lt_vbkd BY posnr.
                        " Read the first record
                        READ TABLE lt_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
                          INDEX 1.
                        IF sy-subrc EQ 0.
                          " Assign the first record values of BNAME contract to the newly created contract line items
                          LOOP AT xvbkd[] INTO ls_vbkd WHERE posnr NE lc_hdr.
                            ls_static_vars-bstkd = ls_vbkd-bstkd = <lst_vbkd>-bstkd.       " PO Number
                            ls_static_vars-bsark = ls_vbkd-bsark = <lst_vbkd>-bsark.       " PO Type
                            ls_static_vars-ihrez = ls_vbkd-ihrez = <lst_vbkd>-ihrez.       " Your Reference (Sub Ref ID)
                            ls_static_vars-ihrez_e = ls_vbkd-ihrez_e = <lst_vbkd>-ihrez_e. " Your Reference (Ship-to party character)
                            MODIFY xvbkd[] FROM ls_vbkd INDEX sy-tabix
                            TRANSPORTING bstkd bsark ihrez ihrez_e.
                            CLEAR ls_vbkd.
                          ENDLOOP.
                        ENDIF. " IF sy-subrc EQ 0.
                      ENDIF. " IF sy-subrc EQ 0.
                    ENDIF.
                  ENDIF. " IF sy-subrc EQ 0.
                ENDIF. " IF sy-subrc EQ 0.
              ENDIF. " IF ls_static_vars IS INITIAL.
            ELSE.
              CLEAR ls_static_vars.
              LOOP AT xvbkd[] INTO ls_vbkd WHERE posnr NE lc_hdr.
                CLEAR : ls_vbkd-bstkd, ls_vbkd-bsark,
                        ls_vbkd-ihrez, ls_vbkd-ihrez_e.
                MODIFY xvbkd[] FROM ls_vbkd INDEX sy-tabix
                  TRANSPORTING bstkd bsark ihrez ihrez_e.
                CLEAR ls_vbkd.
              ENDLOOP.
            ENDIF. " IF vbak-bname IS NOT INITIAL.
          ENDIF. " IF t180-trtyp EQ lc_chng AND vbak-bname NE *vbak-bname.
        ENDIF. " IF lv_lines GT 1.
        FREE : lv_lines, zqtc_renwl_plan, lt_vbkd, ls_vbkd, ls_vbkd_hdr.
      ENDIF. " IF xvbkd[] IS NOT INITIAL.
    ENDIF. " vbak-auart IN li_quote.
  ENDIF. " IF li_cons IS NOT INITIAL.
ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
