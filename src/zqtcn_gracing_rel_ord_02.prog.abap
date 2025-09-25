*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_GRACING_REL_ORD_02 (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* PROGRAM DESCRIPTION: Create Fulfillment Items in RAR for Gracing
* Release Orders / Contacts
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE: 03/10/2019
* OBJECT ID: E141
* TRANSPORT NUMBER(S):  ED2K914447
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_devid_e142     TYPE zdevid         VALUE 'E142',                   "Development ID
    lc_param1         TYPE RVARI_VNAM     VALUE 'GRACING',
    lc_param2         TYPE RVARI_VNAM     VALUE 'PSTYV'.

  STATICS:
       lir_pstyv_gracing TYPE rjksd_pstyv_range_tab.    "Range: Item Cat.


*--------------------------------------------------------------------*
.

  IF lir_pstyv_gracing IS INITIAL.
*   Fetch Constant Values
    REFRESH li_constants.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid_e142                                      "Development ID: E142
      IMPORTING
        ex_constants = li_constants.                                      "Constant Values
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>).
      CASE <lst_constants>-param1.
        WHEN lc_param1.                                      "GRACING
           CASE <lst_constants>-param2.
            WHEN lc_param2.                                  "PSTYV
              APPEND INITIAL LINE TO lir_pstyv_gracing ASSIGNING FIELD-SYMBOL(<lst_pstyv_gracing>).
              <lst_pstyv_gracing>-sign   = <lst_constants>-sign.
              <lst_pstyv_gracing>-option = <lst_constants>-opti.
              <lst_pstyv_gracing>-low    = <lst_constants>-low.
              <lst_pstyv_gracing>-high   = <lst_constants>-high.


            WHEN OTHERS.
*             Nothing to do
          ENDCASE.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.

*-- Check if sales order item category is 'ZDUP'.
  TRY.
    DATA(lst_pstyv_gracing) = lir_pstyv_gracing[ 1 ].
  IF line_exists( xvbap[ pstyv = lst_pstyv_gracing-low ] ).
    CALL FUNCTION 'ZRAR_CREATE_PGI_FOR_GRACING' IN UPDATE TASK
      EXPORTING
        im_s_xvbak = vbak
        im_t_xvbap = xvbap[].
  ENDIF.
CATCH cx_sy_itab_line_not_found.
ENDTRY.
