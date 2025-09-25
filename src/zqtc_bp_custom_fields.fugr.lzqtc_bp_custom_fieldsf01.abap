*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_BP_CUSTOM_FIELDSF01 (Sub-routines)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
FORM f_set_data USING    fp_s_kna1     TYPE kna1
                         fp_s_knvv     TYPE knvv
                         fp_i_activity TYPE aktyp.

  st_kna1    = fp_s_kna1.                        "General Data in Customer Master
  knvv       = fp_s_knvv.                        "Customer Master Sales Data

  v_activity = fp_i_activity.                    "Activity category in SAP transaction

ENDFORM.

FORM f_get_data CHANGING fp_s_kna1     TYPE kna1
                         fp_s_knvv     TYPE knvv.

  fp_s_kna1 = st_kna1.                           "General Data in Customer Master
  fp_s_knvv = knvv.                              "Customer Master Sales Data

  CLEAR: st_kna1,
         knvv,
         v_activity.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE bus_pai INPUT.
  IF v_cntrl_bp EQ abap_true.
    CALL FUNCTION 'BUS_PAI'.
  ENDIF.
ENDMODULE.
