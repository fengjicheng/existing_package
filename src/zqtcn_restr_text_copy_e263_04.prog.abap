*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RESTR_TEXT_COPY_E263_04
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTR_TEXT_COPY_E263_04 (Include)
*               Called from Routine - 901 (RV45T901)
* PROGRAM DESCRIPTION: if supplementary PO is ‘SO’
* copy text from order to Invoice instead of customer master.
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE: 07/15/2021
* OBJECT ID: E263(OTCM - 45037
* TRANSPORT NUMBER(S):  ED2K924060
*----------------------------------------------------------------------*
DATA:
  li_constants_e263 TYPE zcat_constants.                         "Wiley Application Constant Table

CONSTANTS:
  lc_devid_e263 TYPE zdevid     VALUE 'E263',                     "Development ID
  lc_bstzd_e263 TYPE rvari_vnam VALUE 'SUPPLEMENT_PO'.            " SO

STATICS:r_supplement_po TYPE RANGE OF salv_de_selopt_low.
IF r_supplement_po IS INITIAL.
*---Check the Constant table before going to the actual logiC.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e263  "Development ID
    IMPORTING
      ex_constants = li_constants_e263. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
  IF li_constants_e263[] IS NOT INITIAL.
    LOOP AT li_constants_e263[] INTO DATA(lst_const_e263).
      IF lst_const_e263-param1 = lc_bstzd_e263.
        APPEND INITIAL LINE TO r_supplement_po ASSIGNING FIELD-SYMBOL(<lst_supplement_po>).
        <lst_supplement_po>-sign   = lst_const_e263-sign.
        <lst_supplement_po>-option = lst_const_e263-opti.
        <lst_supplement_po>-low    = lst_const_e263-low.
        <lst_supplement_po>-high   = lst_const_e263-high.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.

IF  r_supplement_po IS NOT INITIAL
    AND ftvcom-vbelv IS NOT INITIAL.
  DATA:ls_vbeln TYPE vbeln. "Sales Document: Header Data
  CLEAR:ls_vbeln.
  SELECT SINGLE vbeln FROM vbak INTO ls_vbeln
    WHERE vbeln = ftvcom-vbelv
     AND bstzd IN r_supplement_po.
  IF sy-subrc = 0.
    bp_subrc = 4.          "Text will not be copied
  ENDIF.
ENDIF.
