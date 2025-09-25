*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0230_20
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916358
* REFERENCE NO:  I0230.20/ERPM1644
* DEVELOPER:     NPOLINA (Nageswara)
* DATE:          2019-10-03
* DESCRIPTION:   ZACO Order Change with Message Variant Z22 (Moodle IB).
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916662
* REFERENCE NO:  ERPM5059
* DEVELOPER:     NPOLINA (Nageswara)
* DATE:          2019-10-30
* DESCRIPTION:   ZACO Order Change with Message Variant Z22 (Moodle IB)
*                for Item Your Reference(Facilitator).
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917084
* REFERENCE NO:
* DEVELOPER:     MIMMADISET(Murali)
* DATE:          2019-12-13
* DESCRIPTION: 1.contrac start date and contract end date should update in the main line item
*instead Sub line itme
*2.Fixed vendor field value is not populating in sub line item.
*-------------------------------------------------------------------

DATA: lst_bdcdata_z22   LIKE LINE OF  dxbdcdata, " Batch input: New table field structure
      li_dxbdcdata_z22  TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_dxbdcdata_z22 TYPE  bdcdata, " Batch input: New table field structure
      lv_tabx           TYPE sy-tabix,
      lst_e1edp01       TYPE e1edp01,
      lst_ze1edp01_z22  TYPE z1qtc_e1edp01_01,
      lst_e1edk02_z22   TYPE e1edk02,
      lst_e1edp35_z22   TYPE e1edp35,
      lv_vbeln_z22      TYPE vbeln_va,
      lv_enddt_z22      TYPE char10,
      lv_begda_z22      TYPE char10,
      lv_ihrez_z22      TYPE ihrez,      "NPOLINA ERPM5089 ED2K916662
      lv_acpdt_z22      TYPE char10,
      lst_edid4_z22     TYPE edidd,
      lst_edid4_z35     TYPE edidd.
STATICS: lv_flag     TYPE char1,
         v_mvgr3     TYPE vbap-mvgr3,
         lv_docnum_t TYPE edi_docnum.
DATA:
  lv_pos_z22 TYPE char3,                     " Pos of type CHAR3
  lv_ind_z22 TYPE uepos,                    " Item number position
  lv_val_z22 TYPE char6,                     " Val of type CHAR6
  lv_selkz6  TYPE char22.                    " Selkz of type CHAR19

**BOC-MIMMADISET-ED2K917084
TYPES:BEGIN OF ty_eban,
        docunum TYPE edi_docnum,
        posnr   TYPE posnr,
        ihrez   TYPE ihrez,
      END OF ty_eban.
DATA:ls_eban  TYPE ty_eban,
     lv_id    TYPE char22,
     lv_lifnr TYPE lifnr,
     lt_eban  TYPE STANDARD TABLE OF ty_eban,
     lv_mvg   TYPE char50.
CONSTANTS:lc_id       TYPE char10 VALUE 'I230_Z22'.
*---Static Variable clearing based on DOCNUM field (IDOC Number).
READ TABLE didoc_data INTO DATA(lst_edidd_230_1) INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_t NE lst_edidd_230_1-docnum.
    FREE:lv_flag,
         v_mvgr3,
        lv_docnum_t.
    lv_docnum_t  = lst_edidd_230_1-docnum.
  ENDIF.
ENDIF.

FREE:li_dxbdcdata_z22[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
*** Idoc number and id number
** IMPORT statement is writtern in include ZQTCN_INBOUND_BDC_I0230_20_1.
CONCATENATE lv_docnum_t lc_id INTO lv_mvg.
IMPORT v_mvgr3 FROM MEMORY ID lv_mvg.
CLEAR:lst_bdcdata_z22.
FREE MEMORY ID lv_mvg.
* Add BDC part before SAVE
READ TABLE dxbdcdata INTO lst_dxbdcdata_z22  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF  sy-subrc EQ 0  AND lv_flag IS INITIAL .
  lv_tabx = sy-tabix.
  CLEAR:lst_edid4_z22.
* Get Order number
  READ TABLE didoc_data INTO lst_edid4_z22 WITH KEY  segnam = 'E1EDK02'
                                                    sdata+0(3) =  '002'.
  IF sy-subrc EQ 0.
    lst_e1edk02_z22 = lst_edid4_z22-sdata.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_e1edk02_z22-belnr
      IMPORTING
        output = lv_vbeln_z22.

* Get Order Items
    SELECT vbeln, posnr FROM vbap INTO TABLE @DATA(li_vbap_z22)
        WHERE vbeln = @lv_vbeln_z22.
    IF sy-subrc EQ 0.
      SORT li_vbap_z22[] BY vbeln posnr.



* Build BDC for each Item in IDOC (mostly 1 item)
      CLEAR:lst_edid4_z22.
      LOOP AT didoc_data INTO lst_edid4_z22 WHERE segnam = 'E1EDP01'.
        CLEAR:lst_e1edp01.
        lst_e1edp01 = lst_edid4_z22-sdata.
        IF lst_e1edp01-uepos IS NOT INITIAL.
* Read Contract end date and Acceptance/Grade date
          READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_zp01_z22>) WITH KEY segnam = 'Z1QTC_E1EDP01_01'.
          IF sy-subrc EQ 0.
            lst_ze1edp01_z22 = <lfs_zp01_z22>-sdata.
            lv_ihrez_z22 = lst_ze1edp01_z22-ihrez_e.      " NPOLINA ERPM5089  ED2K916662
* Convert Contract Start date to User format
            IF lst_ze1edp01_z22-vbegdat IS NOT INITIAL.
              CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                EXPORTING
                  input  = lst_ze1edp01_z22-vbegdat
                IMPORTING
                  output = lv_begda_z22.
            ENDIF.
            IF lst_ze1edp01_z22-venddat IS NOT INITIAL.
* Convert Contract End Date to User format
              CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                EXPORTING
                  input  = lst_ze1edp01_z22-venddat
                IMPORTING
                  output = lv_enddt_z22.
            ENDIF.

            IF lst_ze1edp01_z22-vabndat IS NOT INITIAL.
* Convert Acceptance Date to User format
              CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                EXPORTING
                  input  = lst_ze1edp01_z22-vabndat
                IMPORTING
                  output = lv_acpdt_z22.
            ENDIF.
          ENDIF.
* Pick parent item number
          DATA:lv_times TYPE i.
          READ TABLE li_vbap_z22 ASSIGNING FIELD-SYMBOL(<lfs_vbap_z22>) WITH KEY posnr = lst_e1edp01-uepos.
          IF sy-subrc EQ 0.
            lv_pos_z22 = '1'.
** BOC MIMMADISET-ED2K916662-11/14/2019           .
            lv_ind_z22 = lst_e1edp01-posex.
            CLEAR lst_bdcdata_z22.
*            lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
*            lst_bdcdata_z22-fval = '/EBACK'.
*            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
** EOC MIMMADISET-ED2K916662-11/14/2019
            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-program = 'SAPMV45A'.
            lst_bdcdata_z22-dynpro = '4001'.
            lst_bdcdata_z22-dynbegin = 'X'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
* Go to ITEM position in Item screen
            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
            lst_bdcdata_z22-fval = 'POPO'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-program = 'SAPMV45A'.
            lst_bdcdata_z22-dynpro = '0251'.
            lst_bdcdata_z22-dynbegin = 'X'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
* Select Item row
            CONCATENATE 'RV45A-VBAP_SELKZ(' lv_pos_z22 ')' INTO lv_selkz6.
            CONDENSE lv_selkz6 NO-GAPS.

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'RV45A-POSNR'.
            lst_bdcdata_z22-fval = lv_ind_z22."lst_e1edp01-uepos.
            APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
            lst_bdcdata_z22-fval = 'POSI'.
            APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-program = 'SAPMV45A'.
            lst_bdcdata_z22-dynpro = '4001'.
            lst_bdcdata_z22-dynbegin = 'X'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = lv_selkz6.
            lst_bdcdata_z22-fval = 'X'.
            APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'BDC_CURSOR'.
            lst_bdcdata_z22-fval = 'RV45A-MABNR(01)'.
            APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
            lst_bdcdata_z22-fval = 'ITEM'.
            APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-program = 'SAPMV45A'.
            lst_bdcdata_z22-dynpro = '4003'.
            lst_bdcdata_z22-dynbegin = 'X'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen
** BOC-ED2K917084- MIMMADISET
**            IF lv_enddt_z22 IS NOT INITIAL
**              OR lv_begda_z22 IS NOT INITIAL.
*** Go to Contract Data tab
**              CLEAR lst_bdcdata_z22.
**              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
**              lst_bdcdata_z22-fval = 'T\03'.
**              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
**
**              CLEAR lst_bdcdata_z22.
**              lst_bdcdata_z22-program = 'SAPLV45W'.
**              lst_bdcdata_z22-dynpro = '4001'.
**              lst_bdcdata_z22-dynbegin = 'X'.
**              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen
**              IF lv_begda_z22 IS NOT INITIAL.
**                CLEAR lst_bdcdata_z22.
**                lst_bdcdata_z22-fnam = 'VEDA-VBEGDAT'.
**                lst_bdcdata_z22-fval = lv_begda_z22.
**                APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Contract start Date
**              ENDIF.
**              IF lv_enddt_z22 IS NOT INITIAL.
**                CLEAR lst_bdcdata_z22.
**                lst_bdcdata_z22-fnam = 'VEDA-VENDDAT'.
**                lst_bdcdata_z22-fval = lv_enddt_z22.
**                APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Contract End Date
**              ENDIF.
**            ENDIF.
** EOC by mimmadiset ED2K917084
* SOC by NPOLINA ERPM5089  ED2K916662
* Fill Sold to Your Reference at Item for Facilitator
            IF lv_ihrez_z22 IS NOT INITIAL.
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'T\12'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '4003'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
* Fill Facilitatir
              lv_lifnr = lv_ihrez_z22.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lv_lifnr
                IMPORTING
                  output = lv_lifnr.
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'VBKD-IHREZ_E'.
              lst_bdcdata_z22-fval = lv_lifnr."lv_ihrez_z22.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Your Reference filed in Sold to Item
**BOC-ED2K917084- MIMMADISET
              ls_eban-docunum = lst_edid4_z22-docnum.
              ls_eban-posnr = lst_e1edp01-posex.
              ls_eban-ihrez = lv_lifnr.
              CONCATENATE 'E222' ls_eban-docunum INTO lv_id.
              APPEND ls_eban TO lt_eban.
              CLEAR:ls_eban.
**EOC-ED2K917084- MIMMADISET
            ENDIF.
* EOC by NPOLINA ERPM5089  ED2K916662
            CLEAR lst_bdcdata_z22.
            lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
            lst_bdcdata_z22-fval = '/EBACK'.
            APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
*****************Logic to update the final grade.
            IF v_mvgr3 IS NOT INITIAL OR lv_acpdt_z22 IS NOT INITIAL.
              lv_ind_z22 = lst_e1edp01-uepos.
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '4001'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
* Go to ITEM position in Item screen
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'POPO'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '0251'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

* Select Item row
              CONCATENATE 'RV45A-VBAP_SELKZ(' lv_pos_z22 ')' INTO lv_selkz6.
              CONDENSE lv_selkz6 NO-GAPS.

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'RV45A-POSNR'.
              lst_bdcdata_z22-fval = lv_ind_z22."lst_e1edp01-uepos.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'POSI'.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '4001'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = lv_selkz6.
              lst_bdcdata_z22-fval = 'X'.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_CURSOR'.
              lst_bdcdata_z22-fval = 'RV45A-MABNR(01)'.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'ITEM'.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. "appending OKCODE

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '4003'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen
* Go to Contract Data tab
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'T\03'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPLV45W'.
              lst_bdcdata_z22-dynpro = '4001'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Screen
**BOC-ED2K917084- MIMMADISET
              IF lv_begda_z22 IS NOT INITIAL.
                CLEAR lst_bdcdata_z22.
                lst_bdcdata_z22-fnam = 'VEDA-VBEGDAT'.
                lst_bdcdata_z22-fval = lv_begda_z22.
                APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Contract start Date
              ENDIF.
              IF lv_enddt_z22 IS NOT INITIAL.
                CLEAR lst_bdcdata_z22.
                lst_bdcdata_z22-fnam = 'VEDA-VENDDAT'.
                lst_bdcdata_z22-fval = lv_enddt_z22.
                APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Contract End Date
              ENDIF.
**EOC-ED2K917084- MIMMADISET
              IF lv_acpdt_z22 IS NOT INITIAL.
                CLEAR lst_bdcdata_z22.
                lst_bdcdata_z22-fnam = 'VEDA-VABNDAT'.
                lst_bdcdata_z22-fval = lv_acpdt_z22.
                APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Acceptance Date
              ENDIF.
** Go to Additional Data A tab
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = 'T\15'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-program = 'SAPMV45A'.
              lst_bdcdata_z22-dynpro = '4003'.
              lst_bdcdata_z22-dynbegin = 'X'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.

* Fill Condition group 3
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'VBAP-MVGR3'.
              lst_bdcdata_z22-fval = v_mvgr3.
              APPEND  lst_bdcdata_z22 TO li_dxbdcdata_z22. " Appending Grade
              CLEAR lst_bdcdata_z22.
              lst_bdcdata_z22-fnam = 'BDC_OKCODE'.
              lst_bdcdata_z22-fval = '/EBACK'.
              APPEND lst_bdcdata_z22 TO li_dxbdcdata_z22.
            ENDIF.
*******************End logic.

            lv_tabx = lv_tabx ..
            INSERT LINES OF li_dxbdcdata_z22 INTO  dxbdcdata INDEX lv_tabx.
            FREE:li_dxbdcdata_z22.

          ENDIF.
        ENDIF.

      ENDLOOP.
      lv_flag = abap_true.
**BOC-ED2K917084- MIMMADISET
**IMPORT statement is written in include ZQTCN_MOVE_FIELD_TO_EBAN
**Fixed Vendor populating in eban-flief
      IF lt_eban[] IS NOT INITIAL AND lv_id IS NOT INITIAL.
        EXPORT lt_eban TO MEMORY ID lv_id.
      ENDIF.
**EOC-ED2K917084- MIMMADISET
    ENDIF.
  ENDIF.
*Update Item number with external number
  READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_dx2>) WITH KEY fnam+0(10) = 'VBAP-POSEX'.
  IF sy-subrc EQ 0.
    <lfs_dx2>-fnam+0(10) = 'VBAP-POSNR'.
  ENDIF.

ENDIF.                                    "lv_flag IS INITIAL
