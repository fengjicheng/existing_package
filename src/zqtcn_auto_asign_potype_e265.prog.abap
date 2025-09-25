*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_ASIGN_POTYPE_E265 (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Auto Assignment PO type for FTP customer
*                      orders
* DEVELOPER: TDIMANTHA
* CREATION DATE: 03/12/2021
* OBJECT ID: E265
* TRANSPORT NUMBER(S): ED2K922516
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: OTCM-39848
* DEVELOPER: TDIMANTHA
* DATE: 01/12/2021
* TRANSPORT NUMBER(S): ED2K922991
* DESCRIPTION: Remove auto determination of po type/add warning message
* With one option
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
CONSTANTS:
  lc_dev_e265  TYPE zdevid     VALUE 'E265',    "Development ID
  lc_p_bsark   TYPE rvari_vnam VALUE 'BSARK',   "Parameter: PO Type.
  lc_p_kvgr1   TYPE rvari_vnam VALUE 'KVGR1',   "Parameter: Customer Group 1.
* BOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
  lc_p_konzs   TYPE rvari_vnam VALUE 'KONZS',   "Parameter: Corporate Group.
* EOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
  lc_ordheader TYPE vbkd-posnr VALUE '000000',  "Header
  lc_cremd     TYPE t180-trtyp VALUE 'H',       "Create Mode
  lc_chgmd     TYPE t180-trtyp VALUE 'V',       "Change Mode
  lc_ordcrepro TYPE SYST_CPROG VALUE 'SAPMV45A'. "ED2K923930 TDIMANTHA 23-June-2021 INC0369478

STATICS:
  lr_bsark_i    TYPE RANGE OF vbkd-bsark,        "Payment Method
  lr_kvgr1_i    TYPE RANGE OF vbak-kvgr1,        "Customer Group 1
  lv_bsark_prev TYPE vbkd-bsark,                 "Previous PO Type
  lv_vbeln_prev TYPE vbkd-bsark,                 "Previous Document
  lv_bsark_def  TYPE vbkd-bsark,                 "Default PO Type
* BOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
  lv_konzs      TYPE kna1-konzs,                 "Corporate Group
  lv_konzs_ftp  TYPE kna1-konzs,                 "Corporate Group for FTP
  lv_kvgr1      TYPE knvv-kvgr1.                 "Customer Group 1
* EOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021

DATA:
  lv_ans        TYPE c.                          "Pop-up return value

* Check the table and varable is empty or not.
IF lr_bsark_i IS INITIAL AND
   lr_kvgr1_i  IS INITIAL AND
   lv_bsark_def  IS INITIAL AND
* BOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
*   lv_konzs IS INITIAL AND "ED2K923504
   lv_konzs_ftp IS INITIAL.
*   AND lv_kvgr1 IS INITIAL. "ED2K923504
* EOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e265   "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
* fill the respective entries which are maintain in zcaconstant.
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_cnst>).
    CASE <lst_cnst>-param1.
      WHEN lc_p_bsark.
        APPEND INITIAL LINE TO lr_bsark_i ASSIGNING FIELD-SYMBOL(<lst_bsark_i>).
        <lst_bsark_i>-sign   = <lst_cnst>-sign.
        <lst_bsark_i>-option = <lst_cnst>-opti.
        <lst_bsark_i>-low    = <lst_cnst>-low.
        <lst_bsark_i>-high   = <lst_cnst>-high.

      WHEN lc_p_kvgr1.
        APPEND INITIAL LINE TO lr_kvgr1_i ASSIGNING FIELD-SYMBOL(<lst_kvgr1_i>).
        <lst_kvgr1_i>-sign   = <lst_cnst>-sign.
        <lst_kvgr1_i>-option = <lst_cnst>-opti.
        <lst_kvgr1_i>-low    = <lst_cnst>-low.
        <lst_kvgr1_i>-high   = <lst_cnst>-high.

      WHEN OTHERS.
*       Do nothing.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_cnst>)

  IF <lst_cnst> IS ASSIGNED.
    UNASSIGN <lst_cnst>.
  ENDIF.
  READ TABLE li_constants ASSIGNING <lst_cnst> WITH KEY param1 = lc_p_bsark.
  IF <lst_cnst> IS ASSIGNED.
    lv_bsark_def = <lst_cnst>-low.
  ENDIF.
* BOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
*BOC ED2K923504
*  SELECT SINGLE konzs INTO lv_konzs
*    FROM kna1
*    WHERE kunnr = vbak-kunnr.
*  TRANSLATE lv_konzs TO UPPER CASE.
*  CONDENSE lv_konzs.
*EOC ED2K923504
  READ TABLE li_constants ASSIGNING FIELD-SYMBOL(<lst_konzs>) WITH KEY param1 = lc_p_konzs.
  IF <lst_konzs> IS ASSIGNED.
    lv_konzs_ftp = <lst_konzs>-low.
  ENDIF.
*BOC ED2K923504
*  SELECT SINGLE kvgr1 INTO lv_kvgr1
*    FROM knvv
*    WHERE kunnr = vbak-kunnr
*    AND vkorg = vbak-vkorg
*    AND vtweg = vbak-vtweg
*    AND spart = vbak-spart.
*EOC ED2K923504
* EOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
ENDIF. " IF lr_bsark_i IS INITIAL
*BOI ED2K923504

SELECT SINGLE konzs INTO lv_konzs
  FROM kna1
  WHERE kunnr = vbak-kunnr.
TRANSLATE lv_konzs TO UPPER CASE.
CONDENSE lv_konzs.

SELECT SINGLE kvgr1 INTO lv_kvgr1
  FROM knvv
  WHERE kunnr = vbak-kunnr
  AND vkorg = vbak-vkorg
  AND vtweg = vbak-vtweg
  AND spart = vbak-spart.

IF *vbkd-bsark IS INITIAL.
  CLEAR lv_bsark_prev.
ENDIF.

*EOI ED2K923504
*BOC ED2K923504
IF lv_bsark_prev IS INITIAL AND *vbkd-bsark IS NOT INITIAL.
  lv_bsark_prev = *vbkd-bsark.
ENDIF.


* BOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
*IF vbak-kvgr1 IN lr_kvgr1_i AND vbkd-posnr EQ lc_ordheader.
IF lv_kvgr1 IN lr_kvgr1_i AND lv_konzs EQ lv_konzs_ftp AND vbkd-posnr EQ lc_ordheader.
*  IF t180-trtyp = lc_chgmd.             " Order Change Mode
  IF t180-trtyp = lc_chgmd OR t180-trtyp = lc_cremd.  " Order Change Mode OR Order Creation Mode
* EOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
    IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL
*BOI ED2K923930 NPOLINA 22-June-2021 INC0369478
      AND sy-cprog = lc_ordcrepro. "Only fore ground changes
*EOI ED2K923930 NPOLINA 22-June-2021 INC0369478
      IF vbkd-bsark NOT IN lr_bsark_i AND vbkd-bsark NE lv_bsark_prev.
* BOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
        CALL FUNCTION 'POPUP_FOR_INTERACTION'
          EXPORTING
            headline = 'Warning PO type Change'(903)
            text1    = 'The PO type entered is not correct'(902)
            text2    = 'Please enter PO type 0160 for FTP customers'(904)
*           TEXT3    = ' '
*           TEXT4    = ' '
*           TEXT5    = ' '
*           TEXT6    = ' '
            ticon    = 'W'
            button_1 = 'OK'
*           BUTTON_2 = ' '
*           BUTTON_3 = ' '
*         IMPORTING
*           BUTTON_PRESSED       =
          .
* EOI ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
* BOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
*        CALL FUNCTION 'POPUP_TO_CONFIRM' ##TEXT_POOL "BOC ED2K922991
*          EXPORTING
*            titlebar              = 'Warning PO type Change'(903)
*            text_question         = 'For FTP Customers, 0160(FTP) is the correct PO type. Are you sure you want to continue?'(902)
*            text_button_1         = 'OK'
*            icon_button_1         = 'ICON_CHECKED'
*            text_button_2         = 'CANCEL'
*            icon_button_2         = 'ICON_CANCEL'
*            display_cancel_button = ' '
*            popup_type            = 'ICON_MESSAGE_WARNING'
*          IMPORTING
*            answer                = lv_ans.
*        IF lv_ans = 2.
*          vbkd-bsark = lv_bsark_def.
*        ENDIF.
* EOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
        lv_bsark_prev = vbkd-bsark.
      ELSEIF vbkd-bsark EQ lv_bsark_def.
        lv_bsark_prev = vbkd-bsark.
      ENDIF.
    ENDIF. "IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
* BOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
*  ELSEIF t180-trtyp = lc_cremd.             " Order Creation Mode
*    vbkd-bsark = lv_bsark_def.
* EOC ED2K922991 OTCM-39848 TDIMANTHA 01/12/2021
  ENDIF.  "IF t180-trtyp = lc_chgmd OR t180-trtyp = lc_cremd.
ENDIF.  "IF lv_kvgr1 IN lr_kvgr1_i AND lv_konzs EQ lv_konzs_ftp AND vbkd-posnr EQ lc_ordheader.
*EOC ED2K923504
