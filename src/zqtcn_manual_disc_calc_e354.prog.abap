*&---------------------------------------------------------------------*
* REVISION NO: ED2K926303 , ED2K926620 , ED2K926784 ,  ED2K926894
* PROGRAM NAME: ZQTCN_MANUAL_DISC_CALC_E354
* REFRENCE NO  : ASOTC-226
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE : 03/15/2022
* OBJECT ID: E354
* DESCRIPTION: Calculate Manual discount total and the standard discount total
*              and based on value value swith activate/inactivate the condition type
*&---------------------------------------------------------------------*
*
DATA : li_constant_e354 TYPE zcat_constants,                         " Internal table for Constant Table
       lv_cond_amt      TYPE kbetr,                                 " Base price for amount as a nemeric value
       lv_strval        TYPE string.

CONSTANTS: lc_devid_e354   TYPE zdevid      VALUE 'E354'.              " Development ID

*Fetching Entries from Constant Table
REFRESH li_constant_e354[].
CLEAR :  lv_strval , lv_cond_amt.

IF xkomv[] IS NOT INITIAL.

  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e354
    IMPORTING
      ex_constants = li_constant_e354.
*
  IF li_constant_e354[] IS NOT INITIAL.

    LOOP AT li_constant_e354 ASSIGNING FIELD-SYMBOL(<lfs_constant_e354>).
      "Assign the field name mapped in constant table to KOMP structure
      ASSIGN COMPONENT <lfs_constant_e354>-param2 OF STRUCTURE komp TO FIELD-SYMBOL(<lfs_val>).
      "If value exist in KOMP then calculate the Kbetr field
      IF <lfs_val> IS ASSIGNED AND <lfs_val> IS NOT INITIAL.
        READ TABLE xkomv ASSIGNING FIELD-SYMBOL(<lfs_xkomv>) WITH KEY kschl = <lfs_constant_e354>-low.
        IF sy-subrc = 0 AND <lfs_xkomv> IS ASSIGNED.
* BOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *
          lv_strval = <lfs_val>.
          "Covert to decimal with leading zero
          CALL FUNCTION 'HRCM_STRING_TO_AMOUNT_CONVERT'
            EXPORTING
              string        = lv_strval
            IMPORTING
              betrg         = lv_cond_amt
            EXCEPTIONS
              convert_error = 1
              OTHERS        = 2.
          IF sy-subrc <> 0.
            " Implement suitable error handling here
          ELSE.
            <lfs_xkomv>-kbetr = lv_cond_amt * <lfs_constant_e354>-high. "Calculate value & Percentage
          ENDIF.
          CLEAR : lv_strval , lv_cond_amt.
* EOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *
          UNASSIGN <lfs_xkomv>.
        ENDIF.
        UNASSIGN <lfs_val>.
      ENDIF.
    ENDLOOP.

  ENDIF.


**BOC - Vishnu
  CONSTANTS : lc_xveda      TYPE char40 VALUE '(SAPLV45W)XVEDA[]',
              lc_vbap_posnr TYPE string  VALUE '(SAPMV45A)VBAP-POSNR', " Constant for memory id
              lc_vbap_qty   TYPE string  VALUE '(SAPMV45A)VBAP-ZMENG'. " Constant for memory id

  FIELD-SYMBOLS : <lt_xveda> TYPE ztrar_vedavb,
                  <fs_posnr> TYPE posnr,
                  <fs_qty>   TYPE dzmeng.

  DATA : li_xveda   TYPE STANDARD TABLE OF vedavb,
         lv_months  TYPE vtbbewe-atage,
         lv_kwert_k TYPE konv-kwert_k.

  IF ( sy-uname = 'VCHITTIBAL' OR sy-uname = 'IYASIRU' OR sy-uname EQ 'PTUFARAM' ) ."AND kondtab-kschl EQ 'ZPLS'.
    READ TABLE xkomv ASSIGNING FIELD-SYMBOL(<lfs_komv>) WITH KEY kschl = 'ZPLS' .
    IF <lfs_komv> IS ASSIGNED.

      ASSIGN (lc_xveda) TO <lt_xveda>.
      IF <lt_xveda> IS ASSIGNED.
        li_xveda[] =  <lt_xveda>.
      ELSE.
        EXIT.
      ENDIF.

      ASSIGN (lc_vbap_posnr) TO <fs_posnr>.
      IF <fs_posnr> IS NOT ASSIGNED.
        EXIT.
      ENDIF.

      ASSIGN (lc_vbap_qty) TO <fs_qty>.
      IF <fs_qty> IS NOT ASSIGNED.
        EXIT.
      ENDIF.

      DATA(lst_xveda) =   VALUE #( li_xveda[ vposn = <fs_posnr> ] OPTIONAL ).
      IF lst_xveda-vbegdat IS INITIAL.
        lst_xveda =   VALUE #( li_xveda[ vposn = '00000000' ] OPTIONAL ).
      ENDIF.

      CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
        EXPORTING
          i_date_from = lst_xveda-vbegdat
*         i_key_day_from =
          i_date_to   = lst_xveda-venddat
*         I_KEY_DAY_TO   =
*         I_FLG_SEPARATE = ' '
*         I_FLG_ROUND_UP = 'X'
        IMPORTING
*         E_DAYS      =
          e_months    = lv_months.
*         E_YEARS     = .

      IF lv_months IS NOT INITIAL AND  <lfs_komv>-kbetr IS NOT INITIAL.
*        lv_kwert_k =   <lfs_komv>-kbetr * <fs_qty> .
*        lv_kwert_k =  <lfs_komv>-kbetr / lv_months.
*        CLEAR    <lfs_komv>-kwert_k." = lv_kwert_k.
*        <lfs_komv>-krech = 'M'.
      ENDIF.
      UNASSIGN <lfs_komv>.
    ENDIF.
  ENDIF.
**EOC - Vishnu
ENDIF.
