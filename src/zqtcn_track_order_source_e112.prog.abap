*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TRACK_ORDER_SOURCE_E112 (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used for changes or checks,
*                      before a document is saved.
* This program will assigned unique name to the subscription.
* This name will be assigned in the “Your ZZFICE “field at header level in Order Data tabB.
* DEVELOPER: Krishna Srikanth J
* CREATION DATE:   06/09/2021
* OBJECT ID: OTCM-37780
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:  (MM/DD/YYYY).
* DESCRIPTION:
*-------------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TRACK_ORDER_SOURCE_E112
*&---------------------------------------------------------------------*

* local Internal Table Declaration
DATA :
  lt_constants TYPE zcat_constants,                    " Constant Entris
  lt_output    TYPE zrg_prog,                          " Work Area for Output
  r_constant   TYPE zdt_rg_prog,
  r_auart      TYPE fip_t_werks_range.

* Local Variable Declaration
DATA :
  lv_prog     TYPE program_id,
  v_prog      TYPE program_id,
  set         TYPE i,
  lv_cust     TYPE c,
  lv_doc_type TYPE vbak-auart.

* Local Constant Declaration
DATA :
  lc_dev_id_e112 TYPE zdevid        VALUE 'E112', "Development ID
  lc_auart1      TYPE rvari_vnam    VALUE 'AUART',
  lc_trtyp       TYPE trtyp         VALUE 'H',
  lc_custom      TYPE trtyp         VALUE 'Z',
  lc_auart2      TYPE auart         VALUE 'ZREW'.

IF t180-trtyp EQ lc_trtyp.

  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_id_e112
    IMPORTING
      ex_constants = lt_constants.

  LOOP AT lt_constants ASSIGNING FIELD-SYMBOL(<ls_constants>).
    CASE <ls_constants>-param1.
*- Output Type
      WHEN lc_auart1.
        lt_output-sign = <ls_constants>-sign.
        lt_output-option = <ls_constants>-opti.
        lt_output-low = <ls_constants>-low.
        APPEND lt_output  TO r_auart.
      WHEN OTHERS.
    ENDCASE.
    CLEAR lt_output.
  ENDLOOP.
    IF vbak-auart IN r_auart.
      lv_prog = sy-cprog.
      set = strlen( lv_prog ).
      lv_cust = lv_prog+0(set).
      IF lv_cust EQ lc_custom.
        v_prog = lv_prog+6(set).
        CONCATENATE 'Z' v_prog
                   INTO v_prog.
        vbak-zzfice = v_prog.
      ELSE.
        vbak-zzfice = lv_prog.
      ENDIF.
    ENDIF.
  ENDIF.
