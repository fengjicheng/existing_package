*&---------------------------------------------------------------------*
*&  Include           ZQTCN_REL_ORD_STATUS_CHK_E189
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_REL_ORD_STATUS_CHK_E189
* PROGRAM DESCRIPTION: For the renewal subscriptions (ZREW) where the item reference
* status is fully reference and has un fulfilled issues, the release orders(ZSRO) are
* not generated due to the status. This is a requirement to by pass the reference
* status so that the release orders/fulfillment are processed successfull
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE:   1/31/2019
* OBJECT ID: RITM0112417 / E189
* TRANSPORT NUMBER(S)   ED1K909470
*----------------------------------------------------------------------*
CONSTANTS:
    lc_param1         TYPE rvari_vnam VALUE 'UNAME'.

 DATA:  li_constant TYPE TABLE OF zcaconstant.

*--------------------------------------------------------------------*
 IF li_constant IS INITIAL.
   SELECT *
      FROM zcaconstant
      INTO TABLE li_constant
     WHERE devid    EQ lc_devid_e189  AND       "Development ID: E189
           param1   EQ lc_param1      AND
           activate EQ abap_true.

 ENDIF.

    IF line_exists( li_constant[ low = sy-uname ] ).

     PERFORM zbedingung_pruefen_002.

   ELSE. "AS-IS

      PERFORM bedingung_pruefen_002.

   ENDIF.
